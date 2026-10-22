unit NecroFight;

// =============================================================================
// NecroFight - necromancer with a summon: fight, rebuff (safe point), supplies, anti-disarm.
// + patrol (DMoveTo, fights on the way, then on to the same point).
// Alerts ON by default: character died, champion (MaxHP > 100000) spawned in the zone.
//
//   uses NecroFight in 'necro_fight.pas';
//   begin
//     AddMySkill(1234, KIND_DRAIN,  70);      // our skills, priority order inside each kind
//     AddMySkill(1148, KIND_NUKE,   0);
//     SetSummon(1154);
//     AddPetSkill(1200, KIND_DEBUFF, 8000);   // summon skills = action IDs
//     SetPetAttack(-1);                       // summon attack order: -1 never, 0 all, N = MaxHP >= N
//     SetTargetRange(900);
//     RunNecro();
//   end.
//
// The interface is OFF, the script fights:
//   target : mobs on us / the summon (lowest absolute HP) -> keep the current target ->
//            new mob with the lowest HP; ALL targets only inside the zone active in the bot
//            (no zone -> FreeRadius around the start) and within TargetRange / AggroRange
//   skills : every SpamMs a skill packet is sent with DUseSkill (no waiting), even while
//            the skill is still reloading - it fires the moment the reuse ends. By priority:
//              1) DRAIN  - our HP below its %          (several -> the one ready first)
//              2) DEBUFF - not on the mob yet          (mob buffs, or "went into reuse")
//              3) NUKE   - the one that is ready first (reload time from SkillList)
//   summon : attack order by SetPetAttack, its skills by their own timers; missing -> summon it
// =============================================================================

interface

uses SysUtils, Classes;

const
  KIND_NUKE   = 1;   // damage: always spammed (the one that reloads first); summon: PARAM = interval ms
  KIND_DEBUFF = 2;   // PARAM = ms before casting it again on the SAME mob
  KIND_DRAIN  = 3;   // PARAM = HP %: only when HP is below it (ours / the summon's)
  KIND_PBAOE  = 5;   // AddMyPbAoe: AoE around US - PARAM = radius, only when ready and enough mobs
                     //   are within that radius of us (AddMyPbAoe MinMobs)
  KIND_AOE    = 4;   // PARAM = radius around the target (0 = 400): only when ready and at least
                     //   AOE_MIN_MOBS mobs (target included) are in that radius - no spam

// supplies for AddSupply (value = inventory item ID)
  SOULSHOT_D                = 1463;
  SOULSHOT_C                = 1464;
  SOULSHOT_B                = 1465;
  SOULSHOT_A                = 1466;
  SOULSHOT_S                = 1467;
  BLESSED_SPIRITSHOT_D      = 3948;
  BLESSED_SPIRITSHOT_C      = 3949;
  BLESSED_SPIRITSHOT_B      = 3950;
  BLESSED_SPIRITSHOT_A      = 3951;
  BLESSED_SPIRITSHOT_S      = 3952;
  BEAST_SOULSHOT            = 6645;
  BEAST_BLESSED_SPIRITSHOT  = 6647;
  SPIRIT_ORE                = 3031;
  CURSED_BONE               = 2508;
  MANA_DRUG                 = 726;
  MANA_POTION               = 728;
  HEALING_POTION            = 1539;

procedure SetBuff(WatchBuffID: integer; Bypasses: array of string);
procedure SetSummonBuff(WatchBuffID: integer; Bypasses: array of string);
procedure SetSafePoint(X, Y, Z: integer);
procedure AddSupply(ItemID: integer; MinCount, MaxCount: integer);
procedure SetWeapon(ItemID: integer);
procedure SetPatrol(Points: array of integer);
procedure SetPatrolRange(Range: integer);
procedure AddMySkill(SkillID, Kind, Param: integer);
procedure AddMyDebuff(SkillID, RecastMs, MinMobHP: integer);
procedure AddMyPbAoe(SkillID, Radius, MinMobs: integer);
procedure AddMyAoe(SkillID, Radius, CastRange: integer);
procedure SetSpamMs(Ms: integer);
procedure SetSummon(SummonSkillID: integer);
procedure SetConfig(Name: string);
procedure SetBlessing(SkillID: integer);
procedure AddPetSkill(ActionID, Kind, Param: integer);
procedure SetPetAttack(MinMobMaxHP: integer);
procedure SetTargetRange(Range: integer);
procedure SetAggroRange(Range: integer);
procedure SetFreeRadius(Range: integer);
procedure SetCastRange(Range: integer);
procedure AddIgnoreName(Name: string);
procedure RunNecro();
procedure NecroOnAction(Action: TL2Action; P1, P2: cardinal);

implementation

const
  PET_ATTACK_ACTION = 22;      // RequestActionUse: summon attacks the target
  PET_ATTACK_MS     = 2000;    // repeat the attack order every N ms
  PET_SKILL_GAP     = 1000;    // at least N ms between two summon skills
  DEBUFF_CONFIRM_MS = 3000;    // a debuff cast counts as landed if it went into reuse within this
  AOE_RADIUS        = 400;     // KIND_AOE default radius around the target
  AOE_MIN_MOBS      = 3;       // KIND_AOE: at least this many mobs (target included) in the radius
  SUMMON_RETRY_MS   = 3000;    // summon pressed, still no summon -> press again after this
  SUMMON_APPEAR_MS  = 10000;   // rebuff: wait this long for the summon to appear before buffing

  REBUFF_TIME       = 600000;  // rebuff when the watched buff has less than this (ms)
  PATH_REACHED      = 150;     // "I am at the safe point"

  INVENTORY_PACKET  = '14';    // RequestItemList: the server resends the inventory
  ADENA_ID          = 57;
  BUY_WAIT          = 1200;    // ms after the last purchase before the check
  BUY_GAP           = 300;     // ms between two purchases
  INVENTORY_WAIT    = 700;     // ms for the server to send the inventory after RequestItemList
  SHOP_WAIT         = 500;     // ms after each shop bypass
  SHOP_OPEN         = 'PremShopList';
  MULTISELL_ID      = 7300;
  MULTISELL_OPEN    = '_bbs_multisell?id=7300';

  CONFIG_DIR = '..\Configurations\';   // SetConfig files, relative to Library\Scripts
  BLESS_RETRY_MS = 2000;       // SetBlessing: one cast try per this many ms
  SUMMON_BUFF_TRIES = 5;       // rebuff: the summon still without its buff after this many tries -> give up on it
  SERVER_PATH = true;         // walk to a mob: true = straight at its X/Y/Z (server path), false = our FindPath
  PATROL_REISSUE_MS = 1500;   // patrol: repeat DMoveTo every N ms while running to the point
  PATROL_WAIT_MIN   = 3000;    // patrol: stand at a reached point a random time between these (ms)
  PATROL_WAIT_MAX   = 5000;
  WEAPON_POLL_MS    = 2000;    // anti-disarm: check the weapon every N ms
  WEAPON_SLOT_RHAND = $0080;   // L2 body part: right hand
  WEAPON_SLOT_LRHAND = $4000;  // L2 body part: two hands
  EQUIP_TRIES       = 5;

  SOUND_DIR         = '..\Sounds\';       // Library\Sounds (relative to Library\Scripts)
  DEATH_SOUND       = 'caracter died.wav';
  CHAMPION_SOUND    = 'champion.wav';
  CHAMPION_HP       = 100000;  // champion alert: a mob in the zone with MaxHP above this
  PLAYER_ALERT_RANGE = 700;    // a player this close -> blinking window

  RETARGET_MS       = 1000;    // SetTarget the same mob again every N ms (a mob can knock the target off)
  LOS_STEP          = 100;     // "clear line" check: a point of the line to the mob every N units must be in the zone
  APPROACH_STEP     = 150;     // "Can't see target.": walk this much closer than we stood (again on every new one)
  APPROACH_MIN      = 50;      //   ... but not closer than this (right next to it)
  APPROACH_MS       = 8000;    // ... but not longer than this
  CANT_SEE_MSG_ID   = 181;     // system message "Can't see target." (laSysMsg P1)
  APPROACH_POINT_MS = 8000;    // max time to reach one path point
  UNREACHABLE_MS    = 10000;   // a mob we could not reach is skipped this long

// ===================== Settings (defaults; the script changes them) =====================
var
  MySkillID, MySkillKind, MySkillParam: array of integer;
  MySkillMinHP: array of integer;          // AddMyDebuff: cast only on mobs with more HP than this
  MySkillCastRange: array of integer;      // AddMyAoe: cast only when the target is this close (0 = any)
  MySkillMinMobs: array of integer;        // AddMyPbAoe: at least this many mobs around us
  SpamMs: integer;
  SummonSkill: integer;
  PetSkillID, PetSkillKind, PetSkillParam: array of integer;
  PetAttackMinMaxHP: integer;
  PetAttackSet: boolean;
  TargetRange, AggroRange, FreeRadius: integer;
  MaxCastRange: integer;                   // SetCastRange: farther than this -> walk closer first (DUseSkill does not walk)
  IgnoreNames: array of string;   // lower case
  BuffID: integer;                         // SetBuff: watched buff (0 = no rebuff)
  BuffBypasses, SummonBuffBypasses: array of string;
  SummonBuffID: integer;                   // SetSummonBuff: buff watched on the summon (0 = same as ours)
  SummonBuffSkipUntil: cardinal;
  ConfigName: string;                      // SetConfig: bot config loaded at start (Library\Configurations)
  BlessSkill: integer;                     // SetBlessing: a buff that survives the summon's death (Noblesse 1323)
  LastBlessTry: cardinal;           // gave up buffing the summon: its buff is not checked until then
  HasSafePoint: boolean;
  SafeX, SafeY, SafeZ: integer;
  SupplyItems, SupplyMin, SupplyMax: array of integer;
  WeaponID: integer;                       // SetWeapon / remembered at start (0 = no anti-disarm)
  LastWeaponCheck: cardinal;
  SeenChamps: array of integer;            // champions already reported (alert once per mob)
  LastChampionCheck: cardinal;
  SeenPlayers: array of integer;           // players already reported as close (blink once each)
  LastPlayerCheck: cardinal;
  ZoneX, ZoneY: integer;                   // FindZoneNear result: nearest zone point
  PatrolPoints: array of integer;          // SetPatrol: x, y, z triples
  PatrolIdx: integer;                      // the point we are heading to (kept through fights)
  PatrolRange: integer;                    // SetPatrolRange: with patrol, new mobs only this close
  PatrolActive: boolean;                   // a DMoveTo to PatrolIdx is in progress
  PatrolLeg: boolean;                      // we are on the way to PatrolIdx (new mobs: PatrolRange)
  PatrolWaitUntil: cardinal;               // standing at a reached point until this tick
  LastPatrolMove: cardinal;

// ===================== State =====================
  UseRadius: boolean;
  HomeX, HomeY, HomeZ: integer;
  CurTarget: integer;
  LastSetTarget: cardinal;                 // last SetTarget (refreshed every RETARGET_MS)
  LastSysOID: cardinal;                    // newest system chat message we have looked at
  UnreachOID: array[0..15] of integer;     // mobs we could not reach ("cannot see" + no path)
  UnreachTime: array[0..15] of cardinal;
  UnreachHead: integer;
  ClusterX, ClusterY: array of integer;    // path to a mob (nearest mob / "can't see target")
  ClusterIdx, ClusterOID: integer;
  ClusterBuilt, LastClusterMove: cardinal;
  ClusterActive, ClusterFormatWarned: boolean;
  ApproachOID: integer;                    // "Can't see target." -> walking to this mob
  ApproachUntil: cardinal;
  ApproachDist: integer;                   // walk until this close to ApproachOID
  LastApproachOID: integer;                // the mob of the last approach (same mob -> closer again)
  CantSeeFlag: boolean;                    // set by NecroOnAction on the "Can't see target." system message
  LastPetAttack, LastPetSkill, LastSummonTry: cardinal;
  PetLast: array of cardinal;     // last use of each summon skill

  // debuffs we put on mobs: ring of (key, mob OID, time); key = our index / 1000 + summon index
  DebKey: array[0..63] of integer;
  DebOID: array[0..63] of integer;
  DebTime: array[0..63] of cardinal;
  DebHead: integer;

  // our debuff sent while it was ready: waiting to see it go into reuse (= it was cast)
  PendSkill, PendOID: integer;
  PendTime: cardinal;

// ===================== Setters =====================

procedure SetBuff(WatchBuffID: integer; Bypasses: array of string);
var i: integer;
begin
  BuffID := WatchBuffID;
  SetLength(BuffBypasses, Length(Bypasses));
  for i := 0 to Length(Bypasses) - 1 do BuffBypasses[i] := Bypasses[i];
end;

procedure SetSummonBuff(WatchBuffID: integer; Bypasses: array of string);
var i: integer;
begin
  SummonBuffID := WatchBuffID;
  SetLength(SummonBuffBypasses, Length(Bypasses));
  for i := 0 to Length(Bypasses) - 1 do SummonBuffBypasses[i] := Bypasses[i];
end;

procedure SetSafePoint(X, Y, Z: integer);
begin
  SafeX := X;
  SafeY := Y;
  SafeZ := Z;
  HasSafePoint := true;
end;

procedure AddSupply(ItemID: integer; MinCount, MaxCount: integer);
var n: integer;
begin
  n := Length(SupplyItems);
  SetLength(SupplyItems, n + 1);
  SetLength(SupplyMin, n + 1);
  SetLength(SupplyMax, n + 1);
  SupplyItems[n] := ItemID;
  SupplyMin[n] := MinCount;
  SupplyMax[n] := MaxCount;
end;

procedure SetWeapon(ItemID: integer);
begin
  WeaponID := ItemID;
end;

procedure SetPatrol(Points: array of integer);
var i: integer;
begin
  SetLength(PatrolPoints, Length(Points));
  for i := 0 to Length(Points) - 1 do PatrolPoints[i] := Points[i];
end;

procedure SetPatrolRange(Range: integer);
begin
  PatrolRange := Range;
end;

procedure AddMySkill(SkillID, Kind, Param: integer);
var n: integer;
begin
  n := Length(MySkillID);
  SetLength(MySkillID, n + 1);
  SetLength(MySkillKind, n + 1);
  SetLength(MySkillParam, n + 1);
  SetLength(MySkillMinHP, n + 1);
  SetLength(MySkillCastRange, n + 1);
  SetLength(MySkillMinMobs, n + 1);
  MySkillID[n] := SkillID;
  MySkillKind[n] := Kind;
  MySkillParam[n] := Param;
  MySkillMinHP[n] := 0;
  MySkillCastRange[n] := 0;
  MySkillMinMobs[n] := 0;
end;

// AoE nuke: Radius around the target (0 = AOE_RADIUS); cast only when the target is within
// CastRange of us (0 = any distance), the skill is ready and AOE_MIN_MOBS mobs are in Radius
procedure AddMyAoe(SkillID, Radius, CastRange: integer);
begin
  AddMySkill(SkillID, KIND_AOE, Radius);
  MySkillCastRange[Length(MySkillCastRange) - 1] := CastRange;
end;

// AoE around us (point blank): cast only when ready and at least MinMobs alive mobs are within
// Radius of us (MinMobs 0 = 3)
procedure AddMyPbAoe(SkillID, Radius, MinMobs: integer);
begin
  if MinMobs <= 0 then MinMobs := 3;
  AddMySkill(SkillID, KIND_PBAOE, Radius);
  MySkillMinMobs[Length(MySkillMinMobs) - 1] := MinMobs;
end;

// debuff with an HP threshold: cast only on mobs with more than MinMobHP (absolute HP)
procedure AddMyDebuff(SkillID, RecastMs, MinMobHP: integer);
begin
  AddMySkill(SkillID, KIND_DEBUFF, RecastMs);
  MySkillMinHP[Length(MySkillMinHP) - 1] := MinMobHP;
end;

procedure SetSpamMs(Ms: integer);
begin
  SpamMs := Ms;
end;

procedure SetSummon(SummonSkillID: integer);
begin
  SummonSkill := SummonSkillID;
end;

procedure SetConfig(Name: string);
begin
  ConfigName := Name;
end;

procedure SetBlessing(SkillID: integer);
begin
  BlessSkill := SkillID;
end;

procedure AddPetSkill(ActionID, Kind, Param: integer);
var n: integer;
begin
  n := Length(PetSkillID);
  SetLength(PetSkillID, n + 1);
  SetLength(PetSkillKind, n + 1);
  SetLength(PetSkillParam, n + 1);
  PetSkillID[n] := ActionID;
  PetSkillKind[n] := Kind;
  PetSkillParam[n] := Param;
end;

procedure SetPetAttack(MinMobMaxHP: integer);
begin
  PetAttackMinMaxHP := MinMobMaxHP;
  PetAttackSet := true;
end;

procedure SetTargetRange(Range: integer);
begin
  TargetRange := Range;
end;

procedure SetAggroRange(Range: integer);
begin
  AggroRange := Range;
end;

procedure SetFreeRadius(Range: integer);
begin
  FreeRadius := Range;
end;
procedure SetCastRange(Range: integer);
begin
  MaxCastRange := Range;
end;

procedure AddIgnoreName(Name: string);
var n: integer;
begin
  n := Length(IgnoreNames);
  SetLength(IgnoreNames, n + 1);
  IgnoreNames[n] := LowerCase(Name);
end;

// never targeted by default (other players' summons, chests...); our own summon is skipped anyway
procedure AddDefaultIgnoreNames();
begin
  AddIgnoreName('Cursed Man');
  AddIgnoreName('Corrupted Man');
  AddIgnoreName('Big Boom');
  AddIgnoreName('Kat the Cat');
  AddIgnoreName('Merrow the Unicorn');
  AddIgnoreName('Boxer the Unicorn');
  AddIgnoreName('Mirage the Unicorn');
  AddIgnoreName('Shadow');
  AddIgnoreName('Magnus the Unicorn');
  AddIgnoreName('Spectral Lord');
  AddIgnoreName('Soulless');
  AddIgnoreName('Nightshade');
  AddIgnoreName('Reanimated Man');
  AddIgnoreName('Silhouette');
  AddIgnoreName('Servitor');
  AddIgnoreName('Cougar');
  AddIgnoreName('Toy Knight');
  AddIgnoreName('Feline Queen');
  AddIgnoreName('Feline King');
  AddIgnoreName('Soulgazer');
  AddIgnoreName('Treasure Chest');
  AddIgnoreName('Dark Panther');
end;

// ===================== Helpers =====================

function HexLE32(Value: integer): string;
begin
  result := IntToHex(Value and $FF, 2) + IntToHex((Value shr 8) and $FF, 2) +
            IntToHex((Value shr 16) and $FF, 2) + IntToHex((Value shr 24) and $FF, 2);
end;

function NpcIdx(OID: integer): integer;
var i: integer;
begin
  result := -1;
  for i := 0 to NpcList.Count - 1 do
    if NpcList(i).OID = OID then begin result := i; exit; end;
end;

// no zone: a circle of FreeRadius - around the start point, or around US when we patrol
// (patrol takes us away from the start, the mobs there must still count)
function InFarmArea(X, Y, Z: integer): boolean;
var DX, DY: double;
  CX, CY: integer;
begin
  if UseRadius then begin
    if Length(PatrolPoints) >= 3 then begin
      CX := User.X;
      CY := User.Y;
    end else begin
      CX := HomeX;
      CY := HomeY;
    end;
    DX := X - CX;
    DY := Y - CY;
    result := Sqrt(DX * DX + DY * DY) <= FreeRadius;
  end else
    result := Engine.InZone(X, Y, Z);
end;

// our own pets / summons + ignore list
function IsIgnored(i: integer): boolean;
var j, OID, PetOID: integer;
  N: string;
begin
  result := true;
  OID := NpcList(i).OID;
  for j := 0 to PetList.Count - 1 do begin
    PetOID := PetList(j).OID;
    if OID = PetOID then exit;
  end;
  result := false;
  N := LowerCase(NpcList(i).Name);
  for j := 0 to Length(IgnoreNames) - 1 do
    if N = IgnoreNames[j] then begin result := true; exit; end;
end;

// ===================== Unreachable mobs ("cannot see target" + no path) =====================

function IsUnreachable(OID: integer): boolean;
var i: integer;
begin
  result := false;
  for i := 0 to 15 do
    if (UnreachOID[i] = OID) and (UnreachTime[i] > 0) and (GetTickCount - UnreachTime[i] < UNREACHABLE_MS) then begin
      result := true;
      exit;
    end;
end;

procedure MarkUnreachable(OID: integer);
begin
  UnreachOID[UnreachHead] := OID;
  UnreachTime[UnreachHead] := GetTickCount;
  UnreachHead := (UnreachHead + 1) mod 16;
end;

// ===================== Debuff memory =====================

function DebuffAge(Key, OID: integer): cardinal;
var i: integer;
begin
  result := $7FFFFFFF;
  for i := 0 to 63 do
    if (DebKey[i] = Key) and (DebOID[i] = OID) and (DebTime[i] > 0) then
      if GetTickCount - DebTime[i] < result then result := GetTickCount - DebTime[i];
end;

procedure MarkDebuff(Key, OID: integer);
begin
  DebKey[DebHead] := Key;
  DebOID[DebHead] := OID;
  DebTime[DebHead] := GetTickCount;
  DebHead := (DebHead + 1) mod 64;
end;

// the mob shows this buff/debuff (if the server sends mob buffs at all)
function MobHasBuff(OID, SkillID: integer): boolean;
var i, j, ID: integer;
begin
  result := false;
  i := NpcIdx(OID);
  if i < 0 then exit;
  try
    for j := 0 to NpcList(i).Buffs.Count - 1 do begin
      ID := NpcList(i).Buffs.Items(j).ID;
      if ID = SkillID then begin result := true; exit; end;
    end;
  except
    result := false;
  end;
end;

// ===================== Our skills =====================

// reload time left of our skill (ms), 0 = ready / unknown
function SkillLeft(ID: integer): cardinal;
var i, SID: integer;
begin
  result := 0;
  for i := 0 to SkillList.Count - 1 do begin
    SID := SkillList(i).ID;
    if SID = ID then begin
      result := SkillList(i).EndTime;
      exit;
    end;
  end;
end;

// among our skills of this kind that pass the filter: the ready one with the best
// priority, else the one with the smallest reload left. -1 = none passes
// distance from us to a mob (huge = gone)
function MobDist(OID: integer): integer;
var i, NX, NY, NZ: integer;
begin
  result := MaxInt;
  i := NpcIdx(OID);
  if i < 0 then exit;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  result := Round(User.DistTo(NX, NY, NZ));
end;

// current absolute HP of a mob (0 = gone)
function MobCurHP(OID: integer): integer;
var i: integer;
begin
  result := 0;
  i := NpcIdx(OID);
  if i >= 0 then result := NpcList(i).CurHP;
end;

// alive mobs (target included) within Radius of the target; Radius 0 = AOE_RADIUS
function MobsAround(OID, Radius: integer): integer;
var i, t, TX, TY, NX, NY: integer;
  DX, DY: double;
begin
  result := 0;
  t := NpcIdx(OID);
  if t < 0 then exit;
  if Radius <= 0 then Radius := AOE_RADIUS;
  TX := NpcList(t).X;
  TY := NpcList(t).Y;
  for i := 0 to NpcList.Count - 1 do begin
    if NpcList(i).Dead or IsIgnored(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    DX := NX - TX;
    DY := NY - TY;
    if Sqrt(DX * DX + DY * DY) <= Radius then Inc(result);
  end;
end;

// alive mobs within Radius of us
function MobsAroundMe(Radius: integer): integer;
var i, UX, UY, NX, NY: integer;
  DX, DY: double;
begin
  result := 0;
  UX := User.X;
  UY := User.Y;
  for i := 0 to NpcList.Count - 1 do begin
    if NpcList(i).Dead or IsIgnored(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    DX := NX - UX;
    DY := NY - UY;
    if Sqrt(DX * DX + DY * DY) <= Radius then Inc(result);
  end;
end;

function BestOfKind(Kind, OID: integer): integer;
var k: integer;
  Left, BestLeft: cardinal;
  Ok: boolean;
begin
  result := -1;
  BestLeft := $7FFFFFFF;
  for k := 0 to Length(MySkillID) - 1 do begin
    if MySkillKind[k] <> Kind then continue;
    if Kind = KIND_DRAIN then
      Ok := User.HP < MySkillParam[k]
    else if Kind = KIND_DEBUFF then
      Ok := (MobCurHP(OID) > MySkillMinHP[k]) and          // AddMyDebuff threshold (0 = any mob)
            (not MobHasBuff(OID, MySkillID[k])) and (DebuffAge(k, OID) >= cardinal(MySkillParam[k]))
    else if Kind = KIND_AOE then
      Ok := ((MySkillCastRange[k] <= 0) or (MobDist(OID) <= MySkillCastRange[k])) and   // target in cast range
            (MobsAround(OID, MySkillParam[k]) >= AOE_MIN_MOBS)
    else if Kind = KIND_PBAOE then
      Ok := MobsAroundMe(MySkillParam[k]) >= MySkillMinMobs[k]
    else
      Ok := true;
    if not Ok then continue;
    Left := SkillLeft(MySkillID[k]);
    // debuffs and AoE: only when the reuse is over, no spam
    if ((Kind = KIND_DEBUFF) or (Kind = KIND_AOE) or (Kind = KIND_PBAOE)) and (Left > 0) then continue;
    if Left < BestLeft then begin   // strict "<": ties keep the earlier (higher priority) skill
      BestLeft := Left;
      result := k;
    end;
  end;
end;

// a debuff we sent while it was ready went into reuse -> it was cast on that mob
procedure CheckPendingDebuff();
begin
  if PendSkill < 0 then exit;
  if SkillLeft(MySkillID[PendSkill]) > 0 then begin
    MarkDebuff(PendSkill, PendOID);
    PendSkill := -1;
  end else if GetTickCount - PendTime > DEBUFF_CONFIRM_MS then
    PendSkill := -1;   // never went into reuse: did not land, try again
end;

// one spam step: drain (HP low) -> debuff (not on the mob) -> nuke
procedure SpamSkill(OID: integer);
var k: integer;
begin
  CheckPendingDebuff();

  k := BestOfKind(KIND_DRAIN, OID);
  if k < 0 then begin
    k := BestOfKind(KIND_DEBUFF, OID);
    if (k >= 0) and (SkillLeft(MySkillID[k]) = 0) and (PendSkill < 0) then begin
      PendSkill := k;   // watch it go into reuse
      PendOID := OID;
      PendTime := GetTickCount;
    end;
  end;
  if k < 0 then k := BestOfKind(KIND_PBAOE, OID);  // enough mobs around us and ready
  if k < 0 then k := BestOfKind(KIND_AOE, OID);    // enough mobs around the target and ready
  if k < 0 then k := BestOfKind(KIND_NUKE, OID);

  if k >= 0 then
    Engine.DUseSkill(MySkillID[k], false, false)   // no waiting: fires as soon as it can
  else if Length(MySkillID) = 0 then
    Engine.Attack(300);
end;

// ===================== Summon =====================

procedure PetAction(ActionID: integer);
begin
  Engine.SendToServer('56' + HexLE32(ActionID) + '00000000' + '00');   // RequestActionUse
end;

function HaveSummon(): boolean;
begin
  result := (PetList.Count > 0) and (not PetList(0).Dead);
end;

// summon corpse still lying there: the server will not let us summon until it is gone
function SummonCorpse(): boolean;
begin
  result := (PetList.Count > 0) and PetList(0).Dead;
end;

// just press the summon skill (DUseSkill, no waiting) and go on fighting;
// pressed again after SUMMON_RETRY_MS if the summon still is not there
procedure Summon();
begin
  if SummonSkill <= 0 then exit;
  Engine.Msg('[Summon]', 'No summon, summoning', 128);
  Engine.DUseSkill(SummonSkill, false, false);
  LastSummonTry := GetTickCount;
end;

function PetSkillReady(k, OID: integer): boolean;
begin
  if PetSkillKind[k] = KIND_DEBUFF then
    result := DebuffAge(1000 + k, OID) >= cardinal(PetSkillParam[k])
  else if PetSkillKind[k] = KIND_DRAIN then
    result := HaveSummon() and (PetList(0).HP < PetSkillParam[k]) and (GetTickCount - PetLast[k] >= 3000)
  else
    result := GetTickCount - PetLast[k] >= cardinal(PetSkillParam[k]);
end;

procedure PetStep(OID: integer);
var k, MaxHP: integer;
begin
  if not HaveSummon() then exit;

  // attack order (melee) only if SetPetAttack allows it for this mob
  if PetAttackMinMaxHP >= 0 then begin
    k := NpcIdx(OID);
    MaxHP := 0;
    if k >= 0 then MaxHP := NpcList(k).MaxHP;
    if (MaxHP >= PetAttackMinMaxHP) and (GetTickCount - LastPetAttack >= PET_ATTACK_MS) then begin
      PetAction(PET_ATTACK_ACTION);
      LastPetAttack := GetTickCount;
    end;
  end;

  // one summon skill by priority
  if GetTickCount - LastPetSkill < PET_SKILL_GAP then exit;
  for k := 0 to Length(PetSkillID) - 1 do begin
    if not PetSkillReady(k, OID) then continue;
    PetAction(PetSkillID[k]);
    PetLast[k] := GetTickCount;
    if PetSkillKind[k] = KIND_DEBUFF then MarkDebuff(1000 + k, OID);
    LastPetSkill := GetTickCount;
    exit;
  end;
end;

// ===================== Targets =====================

// mob is busy with us / the summon: hits one of us, or holds one of us as its target (casts at us)
function MobOnUs(i: integer): boolean;
var Atk, Tgt, PetOID: integer;
begin
  result := false;
  Atk := NpcList(i).AtkOID;
  Tgt := 0;
  try
    Tgt := NpcList(i).Target.OID;
  except
    Tgt := 0;
  end;
  if (Atk = User.OID) or (Tgt = User.OID) then begin result := true; exit; end;
  if HaveSummon() then begin
    PetOID := PetList(0).OID;
    result := (Atk = PetOID) or (Tgt = PetOID);
  end;
end;

// alive mob busy with us / the summon within AggroRange - NO zone check: whoever hits us
// is fought wherever he stands, otherwise we would walk away (patrol / group) and die
function IsOnUs(i: integer): boolean;
var NX, NY, NZ: integer;
begin
  result := false;
  if NpcList(i).Dead then exit;
  if IsIgnored(i) then exit;
  if not MobOnUs(i) then exit;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  result := User.DistTo(NX, NY, NZ) <= AggroRange;
end;

// the straight line from us to the point stays inside the zone (checked every LOS_STEP):
// no line of sight in the bot API, the drawn zone is our map. No zone (radius) -> always true
function LineClear(X, Y, Z: integer): boolean;
var UX, UY, UZ, Steps, s, PX, PY, PZ: integer;
  DX, DY: double;
begin
  result := true;
  if UseRadius then exit;
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  DX := X - UX;
  DY := Y - UY;
  Steps := Trunc(Sqrt(DX * DX + DY * DY) / LOS_STEP);
  for s := 1 to Steps do begin
    PX := UX + (X - UX) * s div (Steps + 1);
    PY := UY + (Y - UY) * s div (Steps + 1);
    PZ := UZ + (Z - UZ) * s div (Steps + 1);
    if not Engine.InZone(PX, PY, PZ) then begin
      result := false;
      exit;
    end;
  end;
end;

// new mobs are taken only this close: TargetRange, or PatrolRange when we patrol
// (mobs that attack us are always taken, up to AggroRange)
function NewMobRange(): integer;
begin
  if PatrolLeg then result := PatrolRange   // running between patrol points
  else result := TargetRange;               // standing (at a point / no patrol)
end;

// OnlyAggro = true: mobs busy with us; false: new mobs within NewMobRange, in the zone,
// with a clear straight line to them (not behind a corner)
function PickLowestHP(OnlyAggro: boolean): integer;
var i, HP, BestHP, NX, NY, NZ: integer;
  D, BestD: double;
begin
  result := 0;
  BestHP := MaxInt;
  BestD := 999999;
  for i := 0 to NpcList.Count - 1 do begin
    if OnlyAggro then begin
      if not IsOnUs(i) then continue;
    end else begin
      if NpcList(i).Dead or IsIgnored(i) then continue;
    end;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    D := User.DistTo(NX, NY, NZ);
    if not OnlyAggro then begin
      if D > NewMobRange() then continue;
      if not InFarmArea(NX, NY, NZ) then continue;
      if not LineClear(NX, NY, NZ) then continue;
    end;
    HP := NpcList(i).CurHP;
    if (HP < BestHP) or ((HP = BestHP) and (D < BestD)) then begin
      BestHP := HP;
      BestD := D;
      result := NpcList(i).OID;
    end;
  end;
end;

// keep the current target while it is alive, in the zone, in range and still attackable
// (busy with us, or a clear line to it)
function CurTargetAlive(): boolean;
var i, NX, NY, NZ: integer;
begin
  result := false;
  i := NpcIdx(CurTarget);
  if (CurTarget = 0) or (i < 0) then exit;
  if NpcList(i).Dead then exit;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  // busy with us: keep it wherever it is (no zone check)
  if MobOnUs(i) and (User.DistTo(NX, NY, NZ) <= AggroRange) then begin
    result := true;
    exit;
  end;
  if not (InFarmArea(NX, NY, NZ) and (User.DistTo(NX, NY, NZ) <= TargetRange)) then exit;
  result := LineClear(NX, NY, NZ);
end;

function ChooseTarget(): integer;
begin
  result := PickLowestHP(true);      // 1) mobs busy with us / the summon
  if result <> 0 then exit;
  if CurTargetAlive() then begin     // 2) keep the current one
    result := CurTarget;
    exit;
  end;
  result := PickLowestHP(false);     // 3) new mob with a clear line
end;

// ===================== Alerts (ON by default) =====================

// red line in the bot chat + sound from Library\Sounds + blinking game window in the taskbar
procedure Alert(Title, Text, Sound: string);
begin
  Engine.Msg(Title, Text, 255);
  if Sound <> '' then PlaySound(Script.Path + SOUND_DIR + Sound);
  Engine.BlinkWindow(true);
end;

// a champion (MaxHP above CHAMPION_HP) appeared in the farm area: once per mob,
// forgotten when it dies / leaves, so a respawned one alerts again
procedure ChampionTick();
var i, n, OID, MaxHP, NX, NY, NZ: integer;
  Known: boolean;
  Cur: array of integer;
  j: integer;
begin
  if GetTickCount - LastChampionCheck < 1000 then exit;
  LastChampionCheck := GetTickCount;
  SetLength(Cur, 0);
  for i := 0 to NpcList.Count - 1 do begin
    if NpcList(i).Dead or IsIgnored(i) then continue;
    MaxHP := NpcList(i).MaxHP;
    if MaxHP <= CHAMPION_HP then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    if not InFarmArea(NX, NY, NZ) then continue;

    OID := NpcList(i).OID;
    n := Length(Cur);
    SetLength(Cur, n + 1);
    Cur[n] := OID;

    Known := false;
    for j := 0 to Length(SeenChamps) - 1 do
      if SeenChamps[j] = OID then begin Known := true; break; end;
    if not Known then
      Alert('[Champion]', NpcList(i).Name + ' (' + IntToStr(MaxHP) + ' HP) spawned in the zone', CHAMPION_SOUND);
  end;
  SetLength(SeenChamps, Length(Cur));
  for i := 0 to Length(Cur) - 1 do SeenChamps[i] := Cur[i];
end;

// a player came within PLAYER_ALERT_RANGE: blink the window, once per player while he stays
// close (forgotten when he leaves the range, so coming back alerts again)
procedure PlayerTick();
var i, j, n, OID, PX, PY, PZ, Dist: integer;
  Known: boolean;
  Cur: array of integer;
begin
  if GetTickCount - LastPlayerCheck < 500 then exit;
  LastPlayerCheck := GetTickCount;
  SetLength(Cur, 0);
  for i := 0 to CharList.Count - 1 do begin
    OID := CharList(i).OID;
    if OID = User.OID then continue;
    PX := CharList(i).X;
    PY := CharList(i).Y;
    PZ := CharList(i).Z;
    Dist := User.DistTo(PX, PY, PZ);
    if Dist > PLAYER_ALERT_RANGE then continue;
    n := Length(Cur);
    SetLength(Cur, n + 1);
    Cur[n] := OID;

    Known := false;
    for j := 0 to Length(SeenPlayers) - 1 do
      if SeenPlayers[j] = OID then begin Known := true; break; end;
    if not Known then begin
      Engine.Msg('[Player]', CharList(i).Name + ' is close (' + IntToStr(Dist) + ')', 255);
      Engine.BlinkWindow(true);
    end;
  end;
  SetLength(SeenPlayers, Length(Cur));
  for i := 0 to Length(Cur) - 1 do SeenPlayers[i] := Cur[i];
end;

// one fight step on the target: retarget, summon, our skill
procedure FightTarget(OID: integer);
begin
  ChampionTick();
  PlayerTick();
  if OID <> CurTarget then begin
    Engine.SetTarget(OID);
    CurTarget := OID;
    LastPetAttack := 0;
    LastSetTarget := GetTickCount;
  end else if GetTickCount - LastSetTarget >= RETARGET_MS then begin
    Engine.SetTarget(OID);   // the same mob again: a mob can knock our target off
    LastSetTarget := GetTickCount;
  end;
  PetStep(OID);
  SpamSkill(OID);
end;

// ===================== Supplies =====================

function SupplyCatalog(ItemID: integer; var EntryID: integer; var Price: integer; var Name: string): boolean;
begin
  result := true;
  case ItemID of
    SOULSHOT_D:               begin EntryID := 1;   Price := 14;    Name := 'Soulshot D';               end;
    SOULSHOT_C:               begin EntryID := 3;   Price := 22;    Name := 'Soulshot C';               end;
    SOULSHOT_B:               begin EntryID := 5;   Price := 50;    Name := 'Soulshot B';               end;
    SOULSHOT_A:               begin EntryID := 7;   Price := 120;   Name := 'Soulshot A';               end;
    SOULSHOT_S:               begin EntryID := 9;   Price := 200;   Name := 'Soulshot S';               end;
    BLESSED_SPIRITSHOT_D:     begin EntryID := 21;  Price := 28;    Name := 'Blessed Spiritshot D';     end;
    BLESSED_SPIRITSHOT_C:     begin EntryID := 23;  Price := 42;    Name := 'Blessed Spiritshot C';     end;
    BLESSED_SPIRITSHOT_B:     begin EntryID := 25;  Price := 245;   Name := 'Blessed Spiritshot B';     end;
    BLESSED_SPIRITSHOT_A:     begin EntryID := 27;  Price := 440;   Name := 'Blessed Spiritshot A';     end;
    BLESSED_SPIRITSHOT_S:     begin EntryID := 29;  Price := 720;   Name := 'Blessed Spiritshot S';     end;
    BEAST_SOULSHOT:           begin EntryID := 31;  Price := 24;    Name := 'Beast Soulshot';           end;
    BEAST_BLESSED_SPIRITSHOT: begin EntryID := 35;  Price := 120;   Name := 'Beast Blessed Spiritshot'; end;
    SPIRIT_ORE:               begin EntryID := 59;  Price := 540;   Name := 'Spirit Ore';               end;
    CURSED_BONE:              begin EntryID := 47;  Price := 360;   Name := 'Cursed Bone';              end;
    MANA_DRUG:                begin EntryID := 103; Price := 35000; Name := 'Mana Drug';                end;
    MANA_POTION:              begin EntryID := 101; Price := 40000; Name := 'Mana Potion';              end;
    HEALING_POTION:           begin EntryID := 99;  Price := 20000; Name := 'Healing Potion';           end;
  else
    result := false;
  end;
end;

procedure OpenShop();
begin
  Engine.BypassToServer(SHOP_OPEN);
  Delay(SHOP_WAIT);
  Engine.BypassToServer(MULTISELL_OPEN);
  Delay(SHOP_WAIT);
end;

// RequestMultiSellChoose (B0), copied from a manual purchase
procedure MultisellBuy(EntryID, Amount: integer);
begin
  Engine.SendToServer('B0' + HexLE32(MULTISELL_ID) + HexLE32(EntryID) +
    HexLE32(Amount) + '00000000' +
    '00000000000000000000' + 'FEFF' + '00000000000000000000000000000000');
end;

procedure RefreshInventory();
begin
  Engine.SendToServer(INVENTORY_PACKET);
  Delay(INVENTORY_WAIT);
end;

function ItemCount(ItemID: integer): Int64;
var i, ID: integer;
  Cnt: Int64;
begin
  result := 0;
  for i := 0 to Inventory.User.Count - 1 do begin
    ID := Inventory.User.Items(i).ID;
    if ID = ItemID then begin
      Cnt := Inventory.User.Items(i).Count;
      result := result + Cnt;
    end;
  end;
end;

// Fast supplies: ONE inventory refresh -> count what is missing (adena budget for all) ->
// open the shop ONCE -> send every purchase in a row -> ONE wait + refresh to check.
procedure BuySupplies();
var
  i, n, ItemID, EntryID, Price: integer;
  Have, After, Adena, Need, CanPay: Int64;
  Name: string;
  BuyIdx, BuyEntry, BuyNeed: array of integer;
  BuyHave: array of Int64;
  BuyName: array of string;
begin
  if Length(SupplyItems) = 0 then exit;
  RefreshInventory();
  Adena := ItemCount(ADENA_ID);

  // 1) what to buy
  SetLength(BuyIdx, 0);
  for i := 0 to Length(SupplyItems) - 1 do begin
    ItemID := SupplyItems[i];
    if not SupplyCatalog(ItemID, EntryID, Price, Name) then begin
      Engine.Msg('[Supplies]', 'Unknown item ID ' + IntToStr(ItemID), 128);
      continue;
    end;
    Have := ItemCount(ItemID);
    if Have >= SupplyMin[i] then continue;
    Need := SupplyMax[i] - Have;
    CanPay := Adena div Price;
    if Need > CanPay then Need := CanPay;
    if Need <= 0 then begin
      Engine.Msg('[Supplies]', Name + ': not enough adena', 128);
      continue;
    end;
    Adena := Adena - Need * Price;   // what is left for the next items
    n := Length(BuyIdx);
    SetLength(BuyIdx, n + 1);
    SetLength(BuyEntry, n + 1);
    SetLength(BuyNeed, n + 1);
    SetLength(BuyHave, n + 1);
    SetLength(BuyName, n + 1);
    BuyIdx[n] := i;
    BuyEntry[n] := EntryID;
    BuyNeed[n] := Need;
    BuyHave[n] := Have;
    BuyName[n] := Name;
  end;
  if Length(BuyIdx) = 0 then exit;   // everything is there

  // 2) shop once, all purchases in a row
  OpenShop();
  for n := 0 to Length(BuyIdx) - 1 do begin
    if User.Dead then exit;
    Engine.Msg('[Supplies]', BuyName[n] + ': ' + IntToStr(BuyHave[n]) + ' -> buying ' + IntToStr(BuyNeed[n]), 128);
    MultisellBuy(BuyEntry[n], BuyNeed[n]);
    Delay(BUY_GAP);
  end;

  // 3) one check
  Delay(BUY_WAIT);
  RefreshInventory();
  for n := 0 to Length(BuyIdx) - 1 do begin
    After := ItemCount(SupplyItems[BuyIdx[n]]);
    if After > BuyHave[n] then
      Engine.Msg('[Supplies]', BuyName[n] + ': now ' + IntToStr(After), 0)
    else
      Engine.Msg('[Supplies]', BuyName[n] + ': purchase NOT confirmed', 128);
  end;
end;

// ===================== Anti-disarm =====================

function IsEquipped(ItemID: integer): boolean;
var i, ID: integer;
begin
  result := false;
  for i := 0 to Inventory.User.Count - 1 do begin
    ID := Inventory.User.Items(i).ID;
    if (ID = ItemID) and Inventory.User.Items(i).Equipped then begin
      result := true;
      exit;
    end;
  end;
end;

// using a worn item takes it OFF: refresh and check again before every UseItem
procedure EquipWeapon(ItemID: integer);
var Tries: integer;
begin
  Tries := 0;
  while (Tries < EQUIP_TRIES) and (not User.Dead) do begin
    RefreshInventory();
    if IsEquipped(ItemID) then exit;
    Inc(Tries);
    Engine.Msg('[Weapon]', 'Weapon ' + IntToStr(ItemID) + ' is not on (disarm?), equipping', 128);
    Engine.UseItem(ItemID);
    Delay(1000);
    if IsEquipped(ItemID) then exit;
  end;
end;

// no SetWeapon: the weapon in hands at start (right-hand / two-hand slot)
procedure RememberWeapon();
var i, Part: integer;
begin
  if WeaponID > 0 then exit;
  RefreshInventory();
  for i := 0 to Inventory.User.Count - 1 do begin
    if not Inventory.User.Items(i).Equipped then continue;
    Part := Inventory.User.Items(i).BodyPart;
    if (Part = WEAPON_SLOT_RHAND) or (Part = WEAPON_SLOT_LRHAND) then begin
      WeaponID := Inventory.User.Items(i).ID;
      Engine.Msg('[Weapon]', 'Remembered weapon: ' + Inventory.User.Items(i).Name, 128);
      exit;
    end;
  end;
  Engine.Msg('[Weapon]', 'No weapon in hands - anti-disarm is OFF', 128);
end;

procedure CheckWeapon();
begin
  if WeaponID <= 0 then exit;
  if GetTickCount - LastWeaponCheck < WEAPON_POLL_MS then exit;
  LastWeaponCheck := GetTickCount;
  if not IsEquipped(WeaponID) then EquipWeapon(WeaponID);
end;

// ===================== Rebuff =====================

function BuffTime(ID: integer): cardinal;
var i: integer;
begin
  result := 0;
  for i := 0 to User.Buffs.Count - 1 do
    if User.Buffs.Items(i).ID = ID then begin
      result := User.Buffs.Items(i).EndTime;
      exit;
    end;
end;

// buff time left on our summon (0 = not there)
function SummonBuffTime(ID: integer): cardinal;
var i, BID: integer;
begin
  result := 0;
  if (PetList.Count = 0) or PetList(0).Dead then exit;
  try
    for i := 0 to PetList(0).Buffs.Count - 1 do begin
      BID := PetList(0).Buffs.Items(i).ID;
      if BID = ID then begin
        result := PetList(0).Buffs.Items(i).EndTime;
        exit;
      end;
    end;
  except
    result := 0;
  end;
end;

// the summon's buff is running out (no summon -> nothing to check)
function SummonBuffLow(): boolean;
var ID: integer;
begin
  result := false;
  if not HaveSummon() then exit;
  if GetTickCount < SummonBuffSkipUntil then exit;   // gave up on it a moment ago
  ID := SummonBuffID;
  if ID = 0 then ID := BuffID;   // default: the same buff as ours (it gets buffed with us)
  if ID = 0 then exit;
  result := SummonBuffTime(ID) < REBUFF_TIME;
end;

// ours or the summon's buff is running out
function BuffLow(): boolean;
begin
  result := ((BuffID <> 0) and (BuffTime(BuffID) < REBUFF_TIME)) or SummonBuffLow();
end;

// mob attacks us / the summon and is close (no zone check: whoever hits us gets killed)
function HitsUs(i: integer): boolean;
var NX, NY, NZ, Atk, PetOID: integer;
begin
  result := false;
  if NpcList(i).Dead then exit;
  if IsIgnored(i) then exit;
  Atk := NpcList(i).AtkOID;
  if Atk <> User.OID then begin
    if not HaveSummon() then exit;
    PetOID := PetList(0).OID;
    if Atk <> PetOID then exit;
  end;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  result := User.DistTo(NX, NY, NZ) <= AggroRange;
end;

// lowest absolute HP among the mobs that hit us; 0 = nobody
function PickHitter(): integer;
var i, HP, BestHP: integer;
begin
  result := 0;
  BestHP := MaxInt;
  for i := 0 to NpcList.Count - 1 do begin
    if not HitsUs(i) then continue;
    HP := NpcList(i).CurHP;
    if HP < BestHP then begin
      BestHP := HP;
      result := NpcList(i).OID;
    end;
  end;
end;

// Fight whatever hits us until we are OUT OF COMBAT. No timeouts, no random waits:
// somebody hits us -> kill him; nobody hits us -> wait for the combat stance to drop.
procedure FightUntilOutOfCombat();
var OID: integer;
begin
  while not User.Dead do begin
    CheckWeapon();
    OID := PickHitter();
    if OID <> 0 then begin
      FightTarget(OID);
      Delay(SpamMs);
      continue;
    end;
    if not User.InCombat then exit;   // out of combat
    Delay(SpamMs);
  end;
end;

// kill whatever hits us / the summon right now; does NOT wait for the combat stance to drop
procedure KillHitters();
var OID: integer;
begin
  while not User.Dead do begin
    CheckWeapon();
    OID := PickHitter();
    if OID = 0 then exit;
    FightTarget(OID);
    Delay(SpamMs);
  end;
end;

// run to the safe point (DMoveTo, checked every tick); hit on the way -> kill him, run on.
// No waiting for the combat stance here - that happens at the safe point.
procedure GoToSafePoint();
var LastMove: cardinal;
begin
  if not HasSafePoint then exit;
  Engine.Msg('[Rebuff]', 'Going to the safe point', 0);
  CurTarget := 0;
  LastMove := 0;
  while (User.DistTo(SafeX, SafeY, SafeZ) > PATH_REACHED) and (not User.Dead) do begin
    if PickHitter() <> 0 then begin
      KillHitters();
      LastMove := 0;   // move again right after the fight
      continue;
    end;
    if (LastMove = 0) or (GetTickCount - LastMove >= PATROL_REISSUE_MS) then begin
      Engine.DMoveTo(SafeX, SafeY, SafeZ);
      LastMove := GetTickCount;
    end;
    Delay(SpamMs);
  end;
end;

// both profiles every rebuff: ours, then the summon's own (SetSummonBuff, if the summon is out).
// No SetSummonBuff -> the summon is buffed together with us by our bypasses.
procedure SendBuffs();
var i: integer;
begin
  for i := 0 to Length(BuffBypasses) - 1 do
    if Engine.BypassToServer(BuffBypasses[i]) then Delay(555);
  if HaveSummon() and (Length(SummonBuffBypasses) > 0) then begin
    for i := 0 to Length(SummonBuffBypasses) - 1 do
      if Engine.BypassToServer(SummonBuffBypasses[i]) then Delay(555);
  end;
end;

// fight off until out of combat -> safe point (if set) -> summon (only if there is no summon
// and no corpse) -> buff ours + the summon's, again and again until both are on (out of combat) -> supplies
procedure Rebuff();
var OID, Tries: integer;
  Started: cardinal;
begin
  Engine.Msg('[Rebuff]', '=== Buff is low: fight off, safe point, summon, buff, supplies ===', 128);

  // kill the mobs on us and run to the safe point at once (no waiting for the combat stance);
  // without a safe point we stay here
  KillHitters();
  if User.Dead then exit;

  GoToSafePoint();
  if User.Dead then exit;

  // summon: press it once, only if neither a summon nor its corpse is there
  // (corpse -> no waiting, the main loop summons it once the corpse is gone)
  FightUntilOutOfCombat();
  if User.Dead then exit;
  if (SummonSkill > 0) and (PetList.Count = 0) then begin
    Summon();
    // it must be out before the buff (it gets buffed with us); meanwhile fight whoever hits us
    Started := GetTickCount;
    while (not HaveSummon()) and (not User.Dead) and (GetTickCount - Started < SUMMON_APPEAR_MS) do begin
      OID := PickHitter();
      if OID <> 0 then FightTarget(OID);
      Delay(SpamMs);
    end;
  end;

  // buff until it is on; every try: first kill whatever hits us and leave combat.
  // Only the summon's buff missing after SUMMON_BUFF_TRIES tries (wrong bypass / buff ID?) ->
  // give up on it, back to farm (ours must be on, that one is retried forever)
  Tries := 0;
  while BuffLow() and (not User.Dead) do begin
    if (BuffID = 0) or (BuffTime(BuffID) >= REBUFF_TIME) then begin
      Inc(Tries);
      if Tries > SUMMON_BUFF_TRIES then begin
        Engine.Msg('[Rebuff]', 'The summon did not get its buff after ' + IntToStr(SUMMON_BUFF_TRIES) +
          ' tries - check SetSummonBuff (buff ID / bypass); not checked for 10 min', 255);
        SummonBuffSkipUntil := GetTickCount + 600000;
        break;
      end;
    end;
    FightUntilOutOfCombat();
    if User.Dead then exit;
    SendBuffs();
    Delay(2000);
  end;
  if User.Dead then exit;
  Engine.Msg('[Rebuff]', 'Buff received', 128);

  // supplies on every rebuff
  FightUntilOutOfCombat();
  if User.Dead then exit;
  BuySupplies();
  CurTarget := 0;
  Engine.Msg('[Rebuff]', 'Done, back to farm', 128);
end;

// ===================== No patrol: go to the nearest mob =====================
// Nothing attackable here (no mob busy with us, no mob with a clear line): walk to the
// nearest mob in the zone on a FindPath path, DMoveTo step by step. The main loop looks for
// targets every tick, so we kill everything near us and then move on.

// the nearest alive mob in the zone; 0 = no mobs
function FindNearestMob(): integer;
var i, NX, NY, NZ: integer;
  D, BestD: double;
begin
  result := 0;
  BestD := 999999;
  for i := 0 to NpcList.Count - 1 do begin
    if NpcList(i).Dead or IsIgnored(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    if not InFarmArea(NX, NY, NZ) then continue;
    D := User.DistTo(NX, NY, NZ);
    if D < BestD then begin
      BestD := D;
      result := NpcList(i).OID;
    end;
  end;
end;

// ===================== Path to a mob: FindPath (bot map zones) =====================


// value of a FindPath list item: the list holds the coordinates themselves (not pointers)
function PathVal(L: TList; i: integer): integer;
begin
  result := integer(L[i]);
end;

// (re)build the path to the mob from FindPath. The list holds plain numbers X, Y, X, Y...
// (not pointers - reading them as pointers crashed). Checked to be near us / the mob;
// anything else -> straight to the mob.
procedure BuildPathTo(OID: integer);
var L: TList;
  i, MI, UX, UY, MX, MY, PX, PY, n, Cnt: integer;
  Valid, FPOk: boolean;
begin
  SetLength(ClusterX, 0);
  SetLength(ClusterY, 0);
  ClusterIdx := 0;
  ClusterOID := OID;
  ClusterBuilt := GetTickCount;
  MI := NpcIdx(OID);
  if MI < 0 then exit;
  UX := User.X;  UY := User.Y;
  MX := NpcList(MI).X;  MY := NpcList(MI).Y;

  L := TList.Create;
  try
    FPOk := Engine.FindPath(UX, UY, MX, MY, L);
    Cnt := L.Count;


    if FPOk and (Cnt >= 2) and (Cnt mod 2 = 0) then begin
      Valid := true;
      i := 0;
      while i + 1 < Cnt do begin
        PX := PathVal(L, i);
        PY := PathVal(L, i + 1);
        if (Abs(PX - UX) > 10000) or (Abs(PY - UY) > 10000) then begin Valid := false; break; end;
        i := i + 2;
      end;
      if Valid then begin
        i := 0;
        while i + 1 < Cnt do begin
          n := Length(ClusterX);
          SetLength(ClusterX, n + 1);
          SetLength(ClusterY, n + 1);
          ClusterX[n] := PathVal(L, i);
          ClusterY[n] := PathVal(L, i + 1);
          i := i + 2;
        end;
      end else if not ClusterFormatWarned then begin
        Engine.Msg('[Move]', 'FindPath: unexpected numbers, walking straight', 128);
        ClusterFormatWarned := true;
      end;
    end;
  except
    Engine.Msg('[Move]', 'FindPath: could not read the path, walking straight', 128);
  end;
  L.Free;

  // no usable path: one point = the mob itself
  if Length(ClusterX) = 0 then begin
    SetLength(ClusterX, 1);
    SetLength(ClusterY, 1);
    ClusterX[0] := MX;
    ClusterY[0] := MY;
  end;
end;

// walk the path to this mob one step (DMoveTo); the path is rebuilt for a new mob / every 3 sec
procedure FollowPathTo(OID: integer);
var UZ, MI, MZ, TX, TY, TZ: integer;
begin
  // test: the server builds the path itself (like a mouse click) - walk straight at the mob
  // with ITS X/Y/Z, repeated (the mob moves); our FindPath is not used
  if SERVER_PATH then begin
    MI := NpcIdx(OID);
    if MI < 0 then begin ClusterActive := false; exit; end;
    if (OID <> ClusterOID) or (not ClusterActive) then begin
      ClusterOID := OID;
      ClusterActive := true;
      LastClusterMove := 0;
    end;
    if (LastClusterMove = 0) or (GetTickCount - LastClusterMove >= PATROL_REISSUE_MS) then begin
      TX := NpcList(MI).X;
      TY := NpcList(MI).Y;
      TZ := NpcList(MI).Z;
      Engine.DMoveTo(TX, TY, TZ);
      LastClusterMove := GetTickCount;
    end;
    exit;
  end;

  if (OID <> ClusterOID) or (not ClusterActive) or (GetTickCount - ClusterBuilt >= 3000) then begin
    BuildPathTo(OID);
    ClusterActive := true;
    LastClusterMove := 0;
  end;
  if NpcIdx(ClusterOID) < 0 then begin ClusterActive := false; exit; end;
  UZ := User.Z;

  while (ClusterIdx < Length(ClusterX)) and
        (User.DistTo(ClusterX[ClusterIdx], ClusterY[ClusterIdx], UZ) < PATH_REACHED) do begin
    Inc(ClusterIdx);
    LastClusterMove := 0;
  end;
  if ClusterIdx >= Length(ClusterX) then exit;

  // the last point = the mob: its own Z (our Z may be inside the floor / a wall there)
  MZ := UZ;
  if ClusterIdx = Length(ClusterX) - 1 then begin
    MI := NpcIdx(ClusterOID);
    if MI >= 0 then MZ := NpcList(MI).Z;
  end;
  if (LastClusterMove = 0) or (GetTickCount - LastClusterMove >= PATROL_REISSUE_MS) then begin
    Engine.DMoveTo(ClusterX[ClusterIdx], ClusterY[ClusterIdx], MZ);
    LastClusterMove := GetTickCount;
  end;
end;

// no patrol, nothing to hit here: go to the nearest mob in the zone
procedure ClusterTick();
var OID: integer;
begin
  OID := FindNearestMob();
  if OID = 0 then begin
    if ClusterActive then Engine.Msg('[Move]', 'No mobs in the zone', 0);
    ClusterActive := false;
    exit;
  end;
  if (not ClusterActive) or (OID <> ClusterOID) then
    Engine.Msg('[Move]', 'Nothing to hit here, going to the nearest mob', 0);
  FollowPathTo(OID);
end;

// ===================== "Can't see target." =====================
// The server says the target is behind a wall: walk to it on a FindPath path (fighting
// whoever hits us on the way) APPROACH_STEP closer than we stood, max APPROACH_MS; the same
// mob "can't see" again -> another APPROACH_STEP closer, down to APPROACH_MIN.

// the bot game event, forwarded from the script's OnAction: system message 181 = "Can't see target."
// Called from the bot's event thread (in parallel with the main loop): only set a flag here -
// no arrays, no chat messages (that corrupted memory: "Invalid pointer operation").
procedure NecroOnAction(Action: TL2Action; P1, P2: cardinal);
begin
  if (Action = laSysMsg) and (P1 = CANT_SEE_MSG_ID) then CantSeeFlag := true;
end;

// "Can't see target." arrived: the system message event (NecroOnAction), or a new line in the
// system chat history (in case the bot keeps it there)
function CantSeeTarget(): boolean;
var i: integer;
  M: TChatMessage;
  T: string;
begin
  result := CantSeeFlag;
  CantSeeFlag := false;
  try
    for i := 0 to History.Count(mtSystem) - 1 do begin
      M := History.GetMessage(i, mtSystem);
      if M.OID <= LastSysOID then continue;
      LastSysOID := M.OID;
      T := LowerCase(M.Text);
      if Pos('see target', T) > 0 then result := true;
    end;
  except
    // history not available: the event flag above is enough
  end;
end;

// remember the newest system message at start: old lines are not events
procedure InitSysMessages();
var i: integer;
  M: TChatMessage;
begin
  LastSysOID := 0;
  try
    for i := 0 to History.Count(mtSystem) - 1 do begin
      M := History.GetMessage(i, mtSystem);
      if M.OID > LastSysOID then LastSysOID := M.OID;
    end;
  except
  end;
end;

// ===================== Patrol =====================
// No target: run to the current patrol point with DMoveTo (does not wait to arrive),
// the main loop keeps looking for targets every tick. Something attacks us / a mob
// shows up -> we fight it, then run on to the SAME point. The next point only once
// the current one is reached.

// debug: why no target - how many mobs we see, how many are close, how many in the zone
procedure LogMobsAround();
var i, NX, NY, NZ, Seen, Close, InArea: integer;
begin
  Seen := 0;
  Close := 0;
  InArea := 0;
  for i := 0 to NpcList.Count - 1 do begin
    if NpcList(i).Dead or IsIgnored(i) then continue;
    Inc(Seen);
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    if User.DistTo(NX, NY, NZ) > NewMobRange() then continue;
    Inc(Close);
    if InFarmArea(NX, NY, NZ) then Inc(InArea);
  end;
  Engine.Msg('[Patrol]', 'Mobs: ' + IntToStr(Seen) + ' alive, ' + IntToStr(Close) + ' within ' +
    IntToStr(NewMobRange()) + ', ' + IntToStr(InArea) + ' of them in the zone', 0);
end;

procedure PatrolTick();
var n, TX, TY, TZ: integer;
begin
  n := Length(PatrolPoints) div 3;
  if n = 0 then exit;
  if PatrolIdx >= n then PatrolIdx := 0;
  TX := PatrolPoints[PatrolIdx * 3];
  TY := PatrolPoints[PatrolIdx * 3 + 1];
  TZ := PatrolPoints[PatrolIdx * 3 + 2];

  // reached the point: stand there a random 3-5 sec (targets in the full TargetRange), then the next one
  if PatrolLeg and (User.DistTo(TX, TY, TZ) < PATH_REACHED) then begin
    PatrolIdx := (PatrolIdx + 1) mod n;
    PatrolLeg := false;
    PatrolActive := false;
    PatrolWaitUntil := GetTickCount + cardinal(PATROL_WAIT_MIN + Random(PATROL_WAIT_MAX - PATROL_WAIT_MIN + 1));
    exit;
  end;
  if (not PatrolLeg) and (GetTickCount < PatrolWaitUntil) then exit;   // still standing at the point

  if (not PatrolActive) or (GetTickCount - LastPatrolMove >= PATROL_REISSUE_MS) then begin
    if not PatrolLeg then begin
      Engine.Msg('[Patrol]', 'No targets, running to point ' + IntToStr(PatrolIdx + 1) + '/' + IntToStr(n), 0);
      LogMobsAround();
    end;
    Engine.DMoveTo(TX, TY, TZ);
    PatrolLeg := true;       // on the way: new mobs only within PatrolRange (kept through fights)
    PatrolActive := true;
    LastPatrolMove := GetTickCount;
  end;
end;

// is a zone on at all: we may stand a bit outside a roughly drawn zone, so look for any zone
// point in rings around us (step 100, up to 3000); found -> the nearest one in ZoneX / ZoneY (globals: var params crash PaxScript)
function FindZoneNear(UX, UY, UZ: integer): boolean;
var Ring, Off, PX, PY, Side: integer;
  Found: boolean;
begin
  ZoneX := UX;
  ZoneY := UY;
  Found := Engine.InZone(UX, UY, UZ);
  Ring := 100;
  while (not Found) and (Ring <= 3000) do begin
    // square ring of "radius" Ring: 4 sides, a point every 100
    Off := -Ring;
    while (not Found) and (Off <= Ring) do begin
      Side := 0;
      while (not Found) and (Side < 4) do begin
        if Side = 0 then begin PX := UX + Off; PY := UY - Ring; end;
        if Side = 1 then begin PX := UX + Off; PY := UY + Ring; end;
        if Side = 2 then begin PX := UX - Ring; PY := UY + Off; end;
        if Side = 3 then begin PX := UX + Ring; PY := UY + Off; end;
        if Engine.InZone(PX, PY, UZ) then begin
          ZoneX := PX;
          ZoneY := PY;
          Found := true;
        end;
        Side := Side + 1;
      end;
      Off := Off + 100;
    end;
    Ring := Ring + 100;
  end;
  result := Found;
end;

// ===================== Blessing (SetBlessing, e.g. Noblesse 1323) =====================
// Kept on the summon and on us. Cast only when the summon is out (a new summon has to get it
// too), first on the summon, then on us; one cast per BLESS_RETRY_MS. Our own buffs survive
// the summon's death, so after a resummon only the summon needs it again.
procedure BlessingTick();
var PetOID: integer;
begin
  if BlessSkill <= 0 then exit;
  if (SummonSkill > 0) and (not HaveSummon()) then exit;   // wait for the summon
  if GetTickCount - LastBlessTry < BLESS_RETRY_MS then exit;

  if HaveSummon() and (SummonBuffTime(BlessSkill) = 0) then begin
    PetOID := PetList(0).OID;
    Engine.Msg('[Blessing]', 'Summon without the blessing, casting it on the summon', 0);
    Engine.SetTarget(PetOID);
    Delay(100);
    Engine.DUseSkill(BlessSkill, false, false);
    LastBlessTry := GetTickCount;
    CurTarget := 0;     // the fight takes its target again
    exit;
  end;

  if BuffTime(BlessSkill) = 0 then begin
    Engine.Msg('[Blessing]', 'No blessing on me, casting it on myself', 0);
    Engine.SetTarget(User.OID);
    Delay(100);
    Engine.DUseSkill(BlessSkill, false, false);
    LastBlessTry := GetTickCount;
    CurTarget := 0;
  end;
end;

// ===================== Main loop =====================

procedure RunNecro();
var OID, UX, UY, UZ, k: integer;
  NoTargetMsg: boolean;
begin
  Engine.Msg('[Necro]', 'Necro started', 128);
  // bot config (SetConfig): only event notifications, NO fighting in it - the script fights.
  // Its notifications work only with the interface ON, so with a config it is switched on;
  // without one the interface stays OFF
  if ConfigName <> '' then begin
    Engine.Msg('[Necro]', 'LoadConfig: ' + Script.Path + CONFIG_DIR + ConfigName + ', interface ON', 128);
    Engine.LoadConfig(Script.Path + CONFIG_DIR + ConfigName);
    Delay(500);
    Engine.FaceControl(0, true);
  end else
    Engine.FaceControl(0, false);

  // defaults for whatever the script did not set
  if SpamMs <= 0 then SpamMs := 100;
  if TargetRange <= 0 then TargetRange := 900;
  if AggroRange <= 0 then AggroRange := 900;
  if FreeRadius <= 0 then FreeRadius := 900;
  if MaxCastRange <= 0 then MaxCastRange := 600;
  if PatrolRange <= 0 then PatrolRange := 200;
  if not PetAttackSet then PetAttackMinMaxHP := -1;   // summon melee off unless SetPetAttack
  AddDefaultIgnoreNames();

  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  HomeX := UX;
  HomeY := UY;
  HomeZ := UZ;
  UseRadius := not FindZoneNear(UX, UY, UZ);
  if UseRadius then
    Engine.Msg('[Necro]', 'No zone in the bot: farming within ' + IntToStr(FreeRadius) + ' of the start point', 128)
  else begin
    Engine.Msg('[Necro]', 'Using the zone that is active in the bot', 128);
    // standing outside the zone: step into it first
    if (ZoneX <> UX) or (ZoneY <> UY) then begin
      Engine.Msg('[Necro]', 'Outside the zone, walking into it', 0);
      // the found point is right on the border: go 100 further in the same direction
      OID := ZoneX;
      k := ZoneY;
      if OID > UX then OID := OID + 100 else if OID < UX then OID := OID - 100;
      if k > UY then k := k + 100 else if k < UY then k := k - 100;
      Engine.MoveTo(OID, k, UZ);
    end;
  end;

  SetLength(PetLast, Length(PetSkillID));
  for k := 0 to Length(PetLast) - 1 do PetLast[k] := 0;
  PendSkill := -1;
  PatrolIdx := 0;
  PatrolLeg := false;
  PatrolWaitUntil := 0;
  Randomize;
  PatrolActive := false;
  CurTarget := 0;
  NoTargetMsg := false;

  RememberWeapon();   // no SetWeapon -> the weapon in hands now
  InitSysMessages();  // old system chat lines are not "Can't see target." events
  ApproachOID := 0;
  if not User.InCombat then BuySupplies();

  while Delay(SpamMs) do begin
    if User.Dead then begin
      Alert('[Death]', 'Character died, waiting for a resurrection', DEATH_SOUND);
      while User.Dead do Delay(1000);
      CurTarget := 0;
      Delay(3000);
      continue;
    end;

    CheckWeapon();     // anti-disarm
    ChampionTick();    // champion respawned in the zone -> alert
    PlayerTick();      // a player close by -> blink

    // "Can't see target." -> walk to that mob (FindPath), fighting whoever hits us on the way
    if CantSeeTarget() and (CurTarget <> 0) then begin
      // APPROACH_STEP closer than we stand now; the same mob again -> closer than last time too
      k := MobDist(CurTarget);
      if (CurTarget = LastApproachOID) and (ApproachDist < k) then k := ApproachDist;
      ApproachDist := k - APPROACH_STEP;
      if ApproachDist < APPROACH_MIN then ApproachDist := APPROACH_MIN;
      ApproachOID := CurTarget;
      LastApproachOID := CurTarget;
      ApproachUntil := GetTickCount + APPROACH_MS;
      ClusterActive := false;
      Engine.Msg('[Target]', 'Can''t see the target, walking closer (to ' + IntToStr(ApproachDist) + ')', 0);
    end;
    if ApproachOID <> 0 then begin
      if (NpcIdx(ApproachOID) < 0) or NpcList(NpcIdx(ApproachOID)).Dead or
         (GetTickCount > ApproachUntil) or (MobDist(ApproachOID) <= ApproachDist) then begin
        ApproachOID := 0;      // there / gone / too long: back to the normal fight
        ClusterActive := false;
      end else begin
        // somebody ELSE hits us on the way -> kill him first; the hidden mob itself hitting us
        // does not stop the walk (that was the "cast into the wall" loop)
        OID := PickLowestHP(true);
        if (OID <> 0) and (OID <> ApproachOID) then FightTarget(OID) else FollowPathTo(ApproachOID);
        continue;
      end;
    end;
    // buff running out -> rebuff (it does not come back until the buff is on)
    if BuffLow() then begin
      Rebuff();
      continue;
    end;

    // summon died: while its corpse lies there we just keep fighting (nothing to do about it);
    // once it is gone from the list -> summon at once
    if (SummonSkill > 0) and (not HaveSummon()) and (not SummonCorpse()) and
       (GetTickCount - LastSummonTry >= SUMMON_RETRY_MS) then begin
      Summon();
      continue;
    end;

    // blessing (SetBlessing) on the summon and on us, as soon as the summon is out
    BlessingTick();

    OID := ChooseTarget();
    if OID = 0 then begin
      CurTarget := 0;
      if Length(PatrolPoints) >= 3 then
        PatrolTick()     // patrol: run on to the current point
      else
        ClusterTick();   // no patrol: go to the nearest mob in the zone (FindPath)
      continue;
    end;

    // a target (busy with us / a clear line to it): fight it; the patrol / the walk to the
    // group resumes afterwards
    NoTargetMsg := false;
    PatrolActive := false;

    // too far for our skills (DUseSkill does not walk us there): walk closer first (FindPath)
    if MobDist(OID) > MaxCastRange then begin
      if OID <> CurTarget then begin
        Engine.SetTarget(OID);
        CurTarget := OID;
        LastSetTarget := GetTickCount;
      end;
      FollowPathTo(OID);
      continue;
    end;

    ClusterActive := false;
    FightTarget(OID);
  end;
end;

end.
