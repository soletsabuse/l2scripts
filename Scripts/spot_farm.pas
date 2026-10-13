unit SpotFarm;

// Common farm logic for every spot. A spot script only feeds data:
//
//   uses SpotFarm in 'spot_farm.pas';
//   begin
//     SetZone('xxx.zmap');                 // file in Library\Zones; '' = the zone active in the bot,
//                                          //   no zone there -> 900 around the start point
//     SetConfig('xxx.xml');                // file in Library\Configurations ('' = do not load)
//     SetTeleport('_bbs_teleport?...');    // Aden gatekeeper -> spot bypass (no line = no teleport, path starts in Aden)
//     SetBuff(1204, ['_bbs_buffer_show', 'book_use?...']);  // watched buff ID + buff bypasses in order
//     SetPath([x1, y1, z1,  x2, y2, z2]);  // teleport landing -> inside the zone
//     SetSafePoint(x, y, z);               // optional: where to stand while rebuffing on the spot
//     SetExpOff(true);                     // optional: turn XP gain off (exp?state=off)
//     SetLogin('login', 'password');       // optional: log in at start and after a disconnect
//     SetTreeMobs(bow, melee, 600);        // optional: shoot mobs the profile cannot reach (bow/melee item IDs)
//     SetPatrol(3, [x1, y1, z1,  x2, y2, z2]);   // optional: standing still 3 sec with no target -> run to the
//                                          //   farthest point; stop as soon as the profile takes a target
//     SetCasterFarm([mobs]);               // optional: farm WITHOUT the interface, lowest-HP mob first, retarget all the time
//     AddCasterSkill(id, SKILL_DEBUFF, 30000, 0);  // our skills in priority order (kind, interval ms, param)
//     SetSummon(skill, 0);                 // optional: summon skill - cast when the summon is dead / missing
//                                          //   (safe point, leave combat, summon, rebuff) and before every buff;
//                                          //   the second number is ignored (summon time is not watched)
//     SetTargetRange(700);                 // optional: caster mode picks targets only this close (default 700)
//     SetWeapon(itemID);                   // optional: weapon to put back on after a disarm
//                                          //   (no line = the weapon in hands at start is remembered)
//     SetChampionAlert(100000);            // champion alert (mob MaxHP above N), ON by default; 0 = off
//     AddPetSkill(action, SKILL_NUKE, 5000, 0);    // summon skills = action IDs, same kinds
//     SetSummonBuff(['bypass']);           // optional: buff bypasses for the summon
//   No SetPath and no SetTeleport = stay mode: farm where started, never travel, wait for a res on death.
//     SetAoeFarm(5, 302, 444, [36], [20941, 20944]);  // optional: farm WITHOUT the interface (pull pack of 5,
//                                          //   mass spoil 302, mass sweep 444, AoE skills, mob IDs; [0] = none/any)
//     -- alerts: defaults below, these lines only change them --
//     SetPlayerAlert(2000);                // player (not party/clan) closer than N; default 0 = off
//     SetPrivateAlert(true);               // private messages; default ON, false = off
//     SetPlayerSound('alarm (fem).wav');   // file in Library\Sounds; '' = no sound
//     SetPrivateSound('incoming private msg (fem).wav');
//     SetDeathSound('caracter died.wav');  // our character died; '' = no sound
//     SetAlertBlink(true);                 // blink the game window in the taskbar; false = off
//     SetTelegram('api key');              // optional: send alerts to Telegram (key from the Adrenaline cabinet)
//     AddSupply(SOULSHOT_C, 8000, 15000);  // optional: less than 8000 -> buy up to 15000 (constants below)
//     RunFarm();
//   end.
//
// Model: any return (start outside the zone, death, stuck outside the zone,
// failed rebuff on the spot) goes Aden SOE -> buff + supplies in Aden ->
// Aden gatekeeper -> path -> load zone + config -> check we are inside the
// zone -> profile ON. If everything is fine, rebuff happens right on the spot.

interface

uses SysUtils, Classes;

// ===================== Supplies for AddSupply (value = inventory item ID) =====================
const
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

// ===================== Skill kinds for AddCasterSkill / AddPetSkill =====================
  SKILL_NUKE    = 1;   // damage: every IntervalMs (its reuse)
  SKILL_DEBUFF  = 2;   // once per mob, again on the same mob only after IntervalMs
  SKILL_DRAIN   = 3;   // only when HP % < Param (necro HP for AddCasterSkill, summon HP for AddPetSkill)

procedure SetZone(Name: string);
procedure SetConfig(Name: string);
procedure SetTeleport(Bypass: string);
procedure SetBuff(WatchBuffID: integer; Bypasses: array of string);
procedure SetPath(Points: array of integer);
procedure SetSafePoint(X, Y, Z: integer);
procedure SetExpOff(Enabled: boolean);
procedure SetTreeMobs(BowID, MeleeID, BowRange: integer);
procedure SetAoeFarm(PackSize, SpoilSkill, SweepSkill: integer; AoeSkillIDs, MobIDs: array of integer);
procedure SetPatrol(IdleSeconds: integer; Points: array of integer);
procedure SetCasterFarm(MobIDs: array of integer);
procedure SetSummon(SummonSkillID, RenewPercent: integer);
procedure SetTargetRange(Range: integer);
procedure SetWeapon(ItemID: integer);
procedure SetChampionAlert(MinMaxHP: integer);
procedure AddCasterSkill(SkillID, Kind, IntervalMs, Param: integer);
procedure AddPetSkill(ActionID, Kind, IntervalMs, Param: integer);
procedure SetSummonBuff(Bypasses: array of string);
procedure SetLogin(Login, Password: string);
procedure SetPlayerAlert(Range: integer);
procedure SetPrivateAlert(Enabled: boolean);
procedure SetPlayerSound(FileName: string);
procedure SetPrivateSound(FileName: string);
procedure SetDeathSound(FileName: string);
procedure SetAlertBlink(Enabled: boolean);
procedure SetTelegram(ApiKey: string);
procedure AddSupply(ItemID: integer; MinCount, MaxCount: integer);
procedure RunFarm();

implementation

// ===================== Library defaults (same for every spot) =====================
const
  ADEN_SKILL_ID     = 27501;    // SOE / teleport skill to Aden
  ADEN_X            = 147448;   // where the Aden teleport drops us
  ADEN_Y            = 25817;
  ADEN_Z            = -2008;
  ADEN_RADIUS       = 3000;     // "I am in Aden"
  GK_ID             = 30848;    // Aden gatekeeper
  GK_X              = 147684;   // next to the Aden gatekeeper
  GK_Y              = 25918;
  GK_Z              = -2008;

  REBUFF_TIME       = 600000;   // rebuff when the watched buff has less than this (ms)
  SPOT_REBUFF_FAILS = 3;        // failed rebuffs on the spot before going to Aden to buff
  RESPAWN_WAIT      = 5000;     // ms to wait after "To Village" before casting the Aden teleport
  OUT_OF_ZONE_LIMIT = 30;       // seconds outside the farm zone while farming -> back via Aden

  ZONE_DIR          = '..\Zones\';            // relative to Library\Scripts (Script.Path)
  CONFIG_DIR        = '..\Configurations\';

  INVENTORY_PACKET  = '14';     // RequestItemList (client -> server, no payload): server resends the inventory
  ADENA_ID          = 57;
  BUY_WAIT          = 4000;     // ms to wait after each purchase before refreshing the inventory
  SHOP_OPEN         = 'PremShopList';             // bypass: open the shop (captured from a manual purchase)
  MULTISELL_ID      = 7300;                       // shop multisell list
  MULTISELL_OPEN    = '_bbs_multisell?id=7300';   // bypass: open that multisell
  EXP_OFF_BYPASS    = 'exp?state=off';            // bypass: stop gaining XP (SetExpOff)
  LOGIN_TIMEOUT     = 120;      // seconds to wait for the character to get in game after AuthLogin
  TREE_DETECT_MS    = 8000;     // target close to us but its HP does not drop this long -> tree mob
  TREE_NEAR_RANGE   = 1000;     // "close to us" for the detection above
  TREE_STUCK_MS     = 10000;    // while shooting: no HP drop this long -> move around the mob (45 deg)
  TREE_MAX_REPOS    = 8;        // repositions (full circle) before giving up on the mob
  AGGRO_MAX_RANGE   = 1000;     // caster mode: mobs attacking us / the summon are targeted only this close
  FREE_RADIUS       = 900;    // SetZone('') and no zone in the bot: farm this close to the start point
  DEFAULT_TARGET_RANGE = 700;  // caster mode: pick targets only this close, unless SetTargetRange
  PET_ATTACK_ACTION = 22;      // RequestActionUse action: summon (servitor) attacks the target (pet = 16)
  PET_ATTACK_MS     = 2000;     // repeat the attack order every N ms
  PET_MELEE_MIN_HP  = 100000;   // the summon gets the attack order (runs in, hits with hands) only on mobs with MaxHP above this
  PET_SKILL_GAP     = 1000;     // at least N ms between two summon skills
  RESUMMON_WAIT     = 5000;     // ms to wait after casting the summon skill
  SUMMON_BUFF_TRIES = 3;        // summon attempts before a buff when the summon is missing
  AOE_AGGRO_DIST    = 1500;    // AoE mode: "aggro" mobs farther than this are ignored (stuck / teleported)
  AOE_SWEEP_RANGE   = 150;      // AoE mode: sweep only corpses this close
  AOE_PICKUP_RANGE  = 1500;     // AoE mode: pick up drops this close after a pack
  EQUIP_TRIES       = 5;       // UseItem attempts until the weapon is really on
  PATH_STEP         = 1500;     // long path segments are split into pieces of this length
  PATH_POINT_TIMEOUT = 60;      // seconds to reach one path point (MoveTo is repeated until then)
  PATROL_MOB_RANGE  = 900;      // profile patrol: a live mob this close (in the zone) stops the run
  PATROL_STEP_MS    = 800;     // profile patrol: one MoveTo step, then the target is checked again
  PATH_REACHED      = 150;     // "I am at the point"
  SOUND_DIR         = '..\Sounds\';   // relative to Library\Scripts (Script.Path)
  DEFAULT_PLAYER_ALERT_RANGE = 0;     // players around: OFF by default (SetPlayerAlert(2000) turns it on)
  DEFAULT_PLAYER_SOUND  = 'alarm (fem).wav';
  DEFAULT_PRIVATE_SOUND = 'incoming private msg (fem).wav';
  DEFAULT_DEATH_SOUND   = 'caracter died.wav';
  DEFAULT_CHAMPION_HP   = 100000;  // champion alert ON by default: a mob with MaxHP above this
  DEFAULT_CHAMPION_SOUND = 'champion.wav';
  WEAPON_POLL_MS        = 2000;    // check every N ms that the weapon is on (disarm)
  WEAPON_SLOT_RHAND     = $0080;   // L2 body part: right hand (one-hand weapon)
  WEAPON_SLOT_LRHAND    = $4000;   // L2 body part: two-hand weapon ($8000 = full armor, NOT a weapon)
  EVENTS_POLL_MS    = 1000;   // how often players around / private messages are checked
  LOGIN_KEY_WAIT    = 4;       // seconds before each Enter (proxy, character) - same as login_test.txt
  LOGIN_RETRY_WAIT  = 30000;    // ms between failed login attempts

// ===================== Spot data (filled by the spot script) =====================
var
  ZoneName: string;
  ConfigName: string;
  TeleportBypass: string;
  BuffID: integer;               // watched buff (SetBuff)
  BuffBypasses: array of string;  // buff bypasses, sent in order (SetBuff)
  Path: array of integer;
  HasSafePoint: boolean;          // SetSafePoint called
  SafeX, SafeY, SafeZ: integer;   // where to stand while rebuffing on the spot
  ExpOff: boolean;                // SetExpOff(true): turn XP gain off
  HasLogin: boolean;              // SetLogin called: log in at start and after a disconnect
  AccLogin, AccPassword: string;
  SupplyItems: array of integer;  // item IDs (AddSupply constants)
  SupplyMin: array of integer;    // buy when we have less than this
  SupplyMax: array of integer;    // ...up to this amount

// ===================== State =====================
  IsRecovering: boolean;  // true while the return thread is moving us: rebuff thread must not touch anything
  NeedReturn: boolean;    // true while the character must be brought back to the spot via Aden
  OnSpot: boolean;        // true while we are on the farm spot (farm is ON)
  TreeBusy: boolean;      // true while the tree handler shoots a mob: rebuff thread waits
  EquipBusy: boolean;     // true while some thread is swapping weapons (EquipWeapon)
  PatrolBusy: boolean;    // true while the profile patrol runs to a point (profile OFF): rebuff waits

// ===================== Events (players around, private messages) =====================
// Defaults (ON) are applied in RunFarm for everything the spot script did not set.
  PlayerAlertRange: integer;      // SetPlayerAlert: 0 = off
  PrivateAlert: boolean;          // SetPrivateAlert
  PlayerSound: string;            // SetPlayerSound: file in Library\Sounds, '' = no sound
  PrivateSound: string;           // SetPrivateSound: file in Library\Sounds, '' = no sound
  TelegramKey: string;            // SetTelegram: '' = no telegram
  DeathSound: string;             // SetDeathSound: file in Library\Sounds, '' = no sound
  AlertBlink: boolean;            // SetAlertBlink: blink the game window in the taskbar
  PlayerAlertSet, PrivateAlertSet, PlayerSoundSet, PrivateSoundSet, DeathSoundSet, AlertBlinkSet: boolean;

// ===================== AoE farm (SetAoeFarm) =====================
  AoeEnabled: boolean;            // SetAoeFarm called: the script farms, the interface stays OFF
  FarmPaused: boolean;            // AoE mode: FarmOff() pauses AoeFarm_Thread
  AoePackSize, AoeSpoilSkill, AoeSweepSkill: integer;
  AoeSkills: array of integer;    // AoE damage skills; empty = plain attack
  AoeMobIDs: array of integer;    // mobs to pull; empty = any mob in the zone

// ===================== Caster farm (SetCasterFarm) + summon (SetSummon) =====================
  CasterEnabled: boolean;         // SetCasterFarm called: the script farms, the interface stays OFF
  CasterMobIDs: array of integer; // mobs to attack; empty = any mob in the zone
  CasterTarget: integer;          // OID we are attacking now
  SummonSkill: integer;           // skill that summons the servitor; 0 = do not summon
  SummonRenewPct: integer;        // not used any more (summon time is not watched), kept so old scripts compile
  SummonBusy: boolean;            // true while the summon is being renewed: fight / rebuff threads wait
  CasterRange: integer;           // SetTargetRange: pick targets only this close (aggro mobs always)
  IgnoreNames: array of string;   // NPCs never targeted (other players' summons, chests...), lower case
  WeaponID: integer;              // SetWeapon: put it back on if a mob disarms us; 0 = no check
  ChampionMinHP: integer;         // SetChampionAlert: alert on a mob with MaxHP above this; 0 = off
  ChampionAlertSet: boolean;
  LastPetAttack, LastPetSkill: cardinal;

  // skills of the necro (owner 0, AddCasterSkill) and of the summon (owner 1, AddPetSkill),
  // in priority order: the first one that may be used right now is used
  SkOwner, SkID, SkKind, SkInterval, SkParam: array of integer;
  SkLast: array of cardinal;      // when it was used last time

  // debuffs on mobs: ring of (skill index, mob OID, time)
  DebuffSk: array[0..63] of integer;
  DebuffOID: array[0..63] of integer;
  DebuffTime: array[0..63] of cardinal;
  DebuffHead: integer;
  SummonBuffBypasses: array of string;   // SetSummonBuff: buff bypasses for the summon

// ===================== Stay mode (no SetPath and no SetTeleport) =====================
  HomeX, HomeY, HomeZ: integer;   // where the script was started: we come back here

// ===================== Farm area =====================
// SetZone('') = use the zone that is active in the bot (drawn by hand);
// no zone there at all -> farm within FREE_RADIUS of the start point.
  UseRadius: boolean;             // true = no zone, farm area is a circle around Home
  AreaDecided: boolean;

// ===================== Patrol (SetPatrol) =====================
  PatrolPoints: array of integer; // x, y, z triples; empty = no patrol
  PatrolIdle: integer;            // seconds without a target before patrolling (profile mode)
  PatrolIdx: integer;             // next patrol point

// ===================== Tree mobs (SetTreeMobs) =====================
  TreeEnabled: boolean;
  TreeBowID, TreeMeleeID, TreeBowRange: integer;

// ===================== Setters =====================

procedure SetZone(Name: string);
begin
  ZoneName := Name;
end;

procedure SetConfig(Name: string);
begin
  ConfigName := Name;
end;

procedure SetTeleport(Bypass: string);
begin
  TeleportBypass := Bypass;
end;

procedure SetBuff(WatchBuffID: integer; Bypasses: array of string);
var i: integer;
begin
  BuffID := WatchBuffID;
  SetLength(BuffBypasses, Length(Bypasses));
  for i := 0 to Length(Bypasses) - 1 do
    BuffBypasses[i] := Bypasses[i];
end;

procedure SetPath(Points: array of integer);
var i: integer;
begin
  SetLength(Path, Length(Points));
  for i := 0 to Length(Points) - 1 do
    Path[i] := Points[i];
end;

procedure SetSafePoint(X, Y, Z: integer);
begin
  SafeX := X;
  SafeY := Y;
  SafeZ := Z;
  HasSafePoint := true;
end;

procedure SetExpOff(Enabled: boolean);
begin
  ExpOff := Enabled;
end;

procedure SetAoeFarm(PackSize, SpoilSkill, SweepSkill: integer; AoeSkillIDs, MobIDs: array of integer);
var i: integer;
begin
  AoePackSize := PackSize;
  AoeSpoilSkill := SpoilSkill;
  AoeSweepSkill := SweepSkill;
  SetLength(AoeSkills, 0);
  for i := 0 to Length(AoeSkillIDs) - 1 do
    if AoeSkillIDs[i] > 0 then begin   // [0] = no AoE skills (PaxScript has no empty array literal)
      SetLength(AoeSkills, Length(AoeSkills) + 1);
      AoeSkills[Length(AoeSkills) - 1] := AoeSkillIDs[i];
    end;
  SetLength(AoeMobIDs, 0);
  for i := 0 to Length(MobIDs) - 1 do
    if MobIDs[i] > 0 then begin        // [0] = any mob in the zone
      SetLength(AoeMobIDs, Length(AoeMobIDs) + 1);
      AoeMobIDs[Length(AoeMobIDs) - 1] := MobIDs[i];
    end;
  AoeEnabled := true;
end;

procedure SetCasterFarm(MobIDs: array of integer);
var i: integer;
begin
  SetLength(CasterMobIDs, 0);
  for i := 0 to Length(MobIDs) - 1 do
    if MobIDs[i] > 0 then begin        // [0] = any mob in the zone
      SetLength(CasterMobIDs, Length(CasterMobIDs) + 1);
      CasterMobIDs[Length(CasterMobIDs) - 1] := MobIDs[i];
    end;
  CasterEnabled := true;
end;

procedure SetSummon(SummonSkillID, RenewPercent: integer);
begin
  SummonSkill := SummonSkillID;
  SummonRenewPct := RenewPercent;
end;

procedure SetTargetRange(Range: integer);
begin
  CasterRange := Range;
end;

procedure SetWeapon(ItemID: integer);
begin
  WeaponID := ItemID;
end;

procedure SetChampionAlert(MinMaxHP: integer);
begin
  ChampionMinHP := MinMaxHP;
  ChampionAlertSet := true;
end;

// ===================== Ignored NPCs =====================
// Never target these: other players' summons / pets, chests. Edit the list right here.

procedure AddIgnoreName(Name: string);
var n: integer;
begin
  n := Length(IgnoreNames);
  SetLength(IgnoreNames, n + 1);
  IgnoreNames[n] := LowerCase(Name);
end;

procedure LoadIgnoreNames();
begin
  SetLength(IgnoreNames, 0);
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

// NPC i is on the ignore list, or it is one of OUR pets / summons
function IsIgnoredNpc(i: integer): boolean;
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
    if N = IgnoreNames[j] then begin
      result := true;
      exit;
    end;
end;

procedure AddSkill(Owner, ID, Kind, IntervalMs, Param: integer);
var n: integer;
begin
  n := Length(SkID);
  SetLength(SkOwner, n + 1);
  SetLength(SkID, n + 1);
  SetLength(SkKind, n + 1);
  SetLength(SkInterval, n + 1);
  SetLength(SkParam, n + 1);
  SetLength(SkLast, n + 1);
  SkOwner[n] := Owner;
  SkID[n] := ID;
  SkKind[n] := Kind;
  SkInterval[n] := IntervalMs;
  SkParam[n] := Param;
  SkLast[n] := 0;
end;

procedure AddCasterSkill(SkillID, Kind, IntervalMs, Param: integer);
begin
  AddSkill(0, SkillID, Kind, IntervalMs, Param);
end;

procedure AddPetSkill(ActionID, Kind, IntervalMs, Param: integer);
begin
  AddSkill(1, ActionID, Kind, IntervalMs, Param);
end;

procedure SetSummonBuff(Bypasses: array of string);
var i: integer;
begin
  SetLength(SummonBuffBypasses, Length(Bypasses));
  for i := 0 to Length(Bypasses) - 1 do
    SummonBuffBypasses[i] := Bypasses[i];
end;

// point is inside the farm area: the bot zone, or (no zone) FREE_RADIUS around the start point
function InFarmArea(X, Y, Z: integer): boolean;
var DX, DY: double;
begin
  if UseRadius then begin
    DX := X - HomeX;
    DY := Y - HomeY;
    result := Sqrt(DX * DX + DY * DY) <= FREE_RADIUS;
  end else
    result := Engine.InZone(X, Y, Z);
end;

// no SetPath and no SetTeleport: we never travel, we farm where the script was started
function StayMode(): boolean;
begin
  result := (Length(Path) = 0) and (TeleportBypass = '');
end;

procedure SetPatrol(IdleSeconds: integer; Points: array of integer);
var i: integer;
begin
  PatrolIdle := IdleSeconds;
  SetLength(PatrolPoints, Length(Points));
  for i := 0 to Length(Points) - 1 do
    PatrolPoints[i] := Points[i];
  PatrolIdx := 0;
end;

function HasPatrol(): boolean;
begin
  result := Length(PatrolPoints) >= 3;
end;

// walks to the next patrol point (round robin)
procedure PatrolStep();
var n: integer;
begin
  n := Length(PatrolPoints) div 3;
  if n = 0 then exit;
  if PatrolIdx >= n then PatrolIdx := 0;
  Engine.Msg('[Patrol]', 'No mobs, patrol point ' + IntToStr(PatrolIdx + 1) + '/' + IntToStr(n), 0);
  Engine.MoveTo(PatrolPoints[PatrolIdx * 3], PatrolPoints[PatrolIdx * 3 + 1], PatrolPoints[PatrolIdx * 3 + 2]);
  PatrolIdx := (PatrolIdx + 1) mod n;
end;

procedure SetTreeMobs(BowID, MeleeID, BowRange: integer);
begin
  TreeBowID := BowID;
  TreeMeleeID := MeleeID;
  TreeBowRange := BowRange;
  TreeEnabled := true;
end;

procedure SetPlayerAlert(Range: integer);
begin
  PlayerAlertRange := Range;
  PlayerAlertSet := true;
end;

procedure SetPrivateAlert(Enabled: boolean);
begin
  PrivateAlert := Enabled;
  PrivateAlertSet := true;
end;

procedure SetPlayerSound(FileName: string);
begin
  PlayerSound := FileName;
  PlayerSoundSet := true;
end;

procedure SetPrivateSound(FileName: string);
begin
  PrivateSound := FileName;
  PrivateSoundSet := true;
end;

procedure SetDeathSound(FileName: string);
begin
  DeathSound := FileName;
  DeathSoundSet := true;
end;

procedure SetAlertBlink(Enabled: boolean);
begin
  AlertBlink := Enabled;
  AlertBlinkSet := true;
end;

procedure SetTelegram(ApiKey: string);
begin
  TelegramKey := ApiKey;
end;

procedure SetLogin(Login, Password: string);
begin
  AccLogin := Login;
  AccPassword := Password;
  HasLogin := true;
end;

// ===================== Login =====================

function IsOnline(): boolean;
begin
  result := Engine.Status = lsOnline;
end;

// waits up to Sec seconds for the character to get in game
function WaitOnline(Sec: integer): boolean;
var Waited: integer;
begin
  Waited := 0;
  while (not IsOnline()) and (Waited < Sec) do begin
    Delay(1000);
    Inc(Waited);
  end;
  result := IsOnline();
end;

// Logs in with SetLogin data and waits until the character is in game.
// Same steps as login_test.txt: AuthLogin -> Enter (proxy) -> Enter (character),
// GameStart as a fallback. The proxy screen disconnects after ~13 sec, so Enter comes fast.
function DoLogin(): boolean;
begin
  result := IsOnline();
  if result or (not HasLogin) then exit;

  Engine.Msg('[Login]', 'Not in game, logging in as ' + AccLogin, 128);
  Engine.AuthLogin(AccLogin, AccPassword);

  if not WaitOnline(LOGIN_KEY_WAIT) then begin
    Engine.Msg('[Login]', 'Enter: proxy', 0);
    Engine.UseKey('Enter');
  end;
  if not WaitOnline(LOGIN_KEY_WAIT) then begin
    Engine.Msg('[Login]', 'Enter: character', 0);
    Engine.UseKey('Enter');
  end;
  if not WaitOnline(LOGIN_TIMEOUT div 2) then begin
    Engine.Msg('[Login]', 'Still not in game, GameStart', 0);
    Engine.GameStart();
  end;

  result := WaitOnline(LOGIN_TIMEOUT div 2);
  if result then begin
    Engine.Msg('[Login]', 'In game', 128);
    Delay(5000);   // let the client load the world around us
  end else
    Engine.Msg('[Login]', 'Login failed (not in game after ' + IntToStr(LOGIN_TIMEOUT) + ' sec)', 128);
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

// ===================== Supplies =====================

// Shop catalog: item ID -> entry number in multisell 7300, adena price per piece, name for logs.
// All values captured with buy_logger.txt. Returns false for an unknown item.
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

// little-endian hex of a 32-bit value, as the game packets want it
function HexLE32(Value: integer): string;
begin
  result := IntToHex(Value and $FF, 2) +
            IntToHex((Value shr 8) and $FF, 2) +
            IntToHex((Value shr 16) and $FF, 2) +
            IntToHex((Value shr 24) and $FF, 2);
end;

// Opens the shop multisell (same bypasses the client sends on a manual purchase).
procedure OpenShop();
begin
  Engine.BypassToServer(SHOP_OPEN);
  Delay(1000);
  Engine.BypassToServer(MULTISELL_OPEN);
  Delay(1500);
end;

// RequestMultiSellChoose (B0), copied from a manual purchase of 111 SSC:
// listId(4) entryId(4) amount(8) + 10 zero bytes + FEFF (no attribute) + 16 zero bytes.
procedure MultisellBuy(EntryID, Amount: integer);
begin
  Engine.SendToServer('B0' + HexLE32(MULTISELL_ID) + HexLE32(EntryID) +
    HexLE32(Amount) + '00000000' +
    '00000000000000000000' + 'FEFF' + '00000000000000000000000000000000');
end;

// Asks the server for a fresh inventory list (RequestItemList 0x14), so the counts below are up to date.
procedure RefreshInventory();
begin
  Engine.SendToServer(INVENTORY_PACKET);
  Delay(1500);
end;

// Total amount of an item in the inventory (all stacks). Call RefreshInventory first.
function ItemCount(ItemID: integer): Int64;
var
  i, ID: integer;
  Cnt: Int64;     // 64-bit: adena can be above 2.1 billion
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

// For every AddSupply line: if we have less than Min, buy up to Max (as much as adena allows).
procedure BuySupplies();
var
  i, ItemID, EntryID, Price: integer;
  Have, After, Adena, Need, CanPay: Int64;

  Name: string;
begin
  if Length(SupplyItems) = 0 then exit;

  for i := 0 to Length(SupplyItems) - 1 do begin
    if User.Dead then exit;

    ItemID := SupplyItems[i];
    if not SupplyCatalog(ItemID, EntryID, Price, Name) then begin
      Engine.Msg('[Supplies]', 'Unknown item ID ' + IntToStr(ItemID) + ' - add it to SupplyCatalog', 128);
      continue;
    end;

    RefreshInventory();   // fresh counts before every item
    Have := ItemCount(ItemID);
    if Have >= SupplyMin[i] then begin
      Engine.Msg('[Supplies]', Name + ': ' + IntToStr(Have) + ' (min ' + IntToStr(SupplyMin[i]) + ') - ok', 0);
      continue;
    end;

    Need := SupplyMax[i] - Have;
    Adena := ItemCount(ADENA_ID);
    CanPay := Adena div Price;
    if Need > CanPay then Need := CanPay;
    if Need <= 0 then begin
      Engine.Msg('[Supplies]', Name + ': ' + IntToStr(Have) + ', not enough adena to buy', 128);
      continue;
    end;

    Engine.Msg('[Supplies]', Name + ': ' + IntToStr(Have) + ' -> buying ' + IntToStr(Need), 128);
    // open the multisell before EVERY purchase: the inventory refresh in between
    // may make the server forget the open list
    OpenShop();
    MultisellBuy(EntryID, Need);
    Delay(BUY_WAIT);   // let the server finish the purchase before asking for the inventory

    RefreshInventory();
    After := ItemCount(ItemID);
    if After > Have then
      Engine.Msg('[Supplies]', Name + ': now ' + IntToStr(After), 128)
    else
      Engine.Msg('[Supplies]', Name + ': purchase NOT confirmed (still ' + IntToStr(After) + ')', 128);
  end;
end;

// ===================== Helper functions =====================

function BuffTime(ID: integer): cardinal;
var i: integer;
begin
  result := 0;
  for i := 0 to User.Buffs.Count - 1 do begin
    if (User.Buffs.Items(i).id = ID) then begin
      result := User.Buffs.Items(i).EndTime;
      break;
    end;
  end;
end;

procedure BuffAltB();
var i: integer;
begin
  for i := 0 to Length(BuffBypasses) - 1 do
    if Engine.BypassToServer(BuffBypasses[i]) then delay(555);
  // optional extra bypasses for the summon (SetSummonBuff), only if it is out
  if PetList.Count > 0 then
    for i := 0 to Length(SummonBuffBypasses) - 1 do
      if Engine.BypassToServer(SummonBuffBypasses[i]) then delay(555);
end;

function IsAgr(Mob: TL2Npc): boolean;
begin
  result := (Mob.AtkOID = User.OID) and (not Mob.Dead);
end;

function HaveAgroMobs(): boolean;
var i: integer;
begin
  result := false;
  for i := 0 to NpcList.Count - 1 do begin
    if (IsAgr(NpcList(i))) then begin
      result := true;
      break;
    end;
  end;
end;

// ===================== Farm ON / OFF =====================
// Profile mode: the bot interface (FaceControl) farms.
// AoE mode (SetAoeFarm): the interface stays OFF, AoeFarm_Thread farms; ON/OFF = unpause/pause it.

procedure FarmOn();
begin
  if AoeEnabled or CasterEnabled then begin
    Engine.FaceControl(0, false);
    FarmPaused := false;
  end else
    Engine.FaceControl(0, true);
end;

procedure FarmOff();
begin
  FarmPaused := true;
  Engine.FaceControl(0, false);
end;

// ===================== AoE farm (SetAoeFarm), ported from tanor_aoe_walk_1 =====================
// Run past mobs until AoePackSize of them follow us -> mass spoil + AoE skills +
// mass sweep until the pack is dead -> pick up the drop around. No interface.

// mob is alive, attacks / chases us and is close (far "aggro" = teleported away / stuck)
function AoeMobIsAggroed(i: integer): boolean;
var AtkOID, TargetOID, NX, NY, NZ: integer;
begin
  result := false;
  if NpcList(i).Dead then exit;
  AtkOID := NpcList(i).AtkOID;
  TargetOID := NpcList(i).Target.OID;
  if (AtkOID <> User.OID) and (TargetOID <> User.OID) then exit;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  result := User.DistTo(NX, NY, NZ) < AOE_AGGRO_DIST;
end;

function AoeMobIsWhitelisted(i: integer): boolean;
var j, ID: integer;
begin
  result := Length(AoeMobIDs) = 0;   // empty list = any mob
  if result then exit;
  ID := NpcList(i).ID;
  for j := 0 to Length(AoeMobIDs) - 1 do
    if ID = AoeMobIDs[j] then begin
      result := true;
      exit;
    end;
end;

function AoeCountAggro(): integer;
var i: integer;
begin
  result := 0;
  for i := 0 to NpcList.Count - 1 do
    if AoeMobIsAggroed(i) then Inc(result);
end;

function AoeHasUnspoiledMob(): boolean;
var i: integer;
begin
  result := false;
  for i := 0 to NpcList.Count - 1 do
    if AoeMobIsAggroed(i) and (not NpcList(i).Sweepable) then begin
      result := true;
      exit;
    end;
end;

function AoeHasSweepableCorpse(): boolean;
var i, NX, NY, NZ: integer;
begin
  result := false;
  for i := 0 to NpcList.Count - 1 do begin
    if not NpcList(i).Dead then continue;
    if not NpcList(i).Sweepable then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    if User.DistTo(NX, NY, NZ) <= AOE_SWEEP_RANGE then begin
      result := true;
      exit;
    end;
  end;
end;

procedure AoeTrySpoil();
begin
  if (AoeSpoilSkill > 0) and AoeHasUnspoiledMob() then begin
    Engine.UseSkill(AoeSpoilSkill);
    Delay(150);
  end;
end;

procedure AoeTrySweep();
begin
  if (AoeSweepSkill > 0) and AoeHasSweepableCorpse() then begin
    Engine.UseSkill(AoeSweepSkill);
    Delay(150);
  end;
end;

// pull must stop: something else (rebuff, death, return, tree) needs the character
function AoeMustStop(): boolean;
begin
  result := User.Dead or NeedReturn or IsRecovering or FarmPaused or (not OnSpot) or (not IsOnline());
end;

// where to run when no mob is visible: the last point of the path (start of the spot)
procedure AoeRunToSpot();
var n: integer;
begin
  n := Length(Path);
  if n >= 3 then Engine.MoveTo(Path[n - 3], Path[n - 2], Path[n - 1]);
end;

// nearest live, not yet aggroed, whitelisted mob inside the zone
function AoeFindPullMob(var MX, MY, MZ, MOID: integer): boolean;
var
  i, NX, NY, NZ: integer;
  BestDist, D: double;
begin
  result := false;
  BestDist := 999999;
  for i := 0 to NpcList.Count - 1 do begin
    if NpcList(i).Dead then continue;
    if IsIgnoredNpc(i) then continue;
    if AoeMobIsAggroed(i) then continue;
    if not AoeMobIsWhitelisted(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    if not InFarmArea(NX, NY, NZ) then continue;
    D := User.DistTo(NX, NY, NZ);
    if D < BestDist then begin
      BestDist := D;
      MX := NX; MY := NY; MZ := NZ;
      MOID := NpcList(i).OID;
      result := true;
    end;
  end;
end;

procedure AoePullPack();
var
  PrevCount, NoProgress, AggroBefore, MX, MY, MZ, MOID: integer;
begin
  PrevCount := -1;
  NoProgress := 0;
  while (AoeCountAggro() < AoePackSize) and (not AoeMustStop()) do begin
    if AoeCountAggro() <> PrevCount then begin
      Engine.Msg('[AoE]', 'Aggro ' + IntToStr(AoeCountAggro()) + '/' + IntToStr(AoePackSize), 0);
      PrevCount := AoeCountAggro();
      NoProgress := 0;
    end else
      Inc(NoProgress);
    if NoProgress > 25 then begin
      Engine.Msg('[AoE]', 'No progress, fighting what we have', 0);
      exit;
    end;

    if not AoeFindPullMob(MX, MY, MZ, MOID) then begin
      if HasPatrol() then PatrolStep() else AoeRunToSpot();   // no mobs: patrol (SetPatrol) or back to the spot start
      Delay(300);
      continue;
    end;

    // run to the mob: getting close should aggro it
    AggroBefore := AoeCountAggro();
    Engine.MoveTo(MX, MY, MZ);
    Delay(150);

    // did not aggro -> tap it once
    if AoeCountAggro() = AggroBefore then begin
      Engine.SetTarget(MOID);
      Delay(30);
      Engine.Attack;
      Delay(50);
      Engine.CancelTarget;
    end;
  end;
end;

// spoil + AoE + sweep until nothing attacks us (also used by the rebuff to clear mobs)
procedure AoeFightPack();
var i, ai, OID: integer;
begin
  while (AoeCountAggro() > 0) and (not User.Dead) and (not NeedReturn) do begin
    OID := 0;
    for i := 0 to NpcList.Count - 1 do
      if AoeMobIsAggroed(i) then begin
        OID := NpcList(i).OID;
        break;
      end;
    if OID = 0 then break;

    Engine.SetTarget(OID);
    Delay(50);
    AoeTrySpoil();
    AoeTrySweep();

    for ai := 0 to Length(AoeSkills) - 1 do begin
      if (AoeCountAggro() = 0) or User.Dead then break;
      AoeTrySpoil();
      Engine.UseSkill(AoeSkills[ai]);
      Delay(150);
      AoeTrySweep();
    end;

    AoeTrySpoil();
    AoeTrySweep();
    if (AoeCountAggro() > 0) and (not User.Dead) then begin
      Engine.Attack;
      Delay(150);
      AoeTrySweep();
    end;
  end;
  if (not User.Dead) and (AoeSweepSkill > 0) then Engine.UseSkill(AoeSweepSkill);   // final sweep
end;

// pick up every drop near us
procedure AoePickupLoot();
var i, DX, DY, DZ: integer;
begin
  for i := DropList.Count - 1 downto 0 do begin
    if User.Dead or NeedReturn then exit;
    if i >= DropList.Count then continue;   // the list shrinks while we pick up
    DX := DropList(i).X;
    DY := DropList(i).Y;
    DZ := DropList(i).Z;
    if User.DistTo(DX, DY, DZ) > AOE_PICKUP_RANGE then continue;
    Engine.MoveTo(DX, DY, DZ);
    Delay(300);
    Engine.Pickup;
    Delay(500);
  end;
end;

// the AoE farm loop; runs only while we are on the spot and nobody paused it
procedure AoeFarm_Thread();
begin
  while Delay(300) do begin
    if AoeMustStop() or TreeBusy then continue;
    if (BuffID <> 0) and (BuffTime(BuffID) < REBUFF_TIME) then continue;   // rebuff first

    AoePullPack();
    if AoeMustStop() then continue;

    if AoeCountAggro() > 0 then begin
      Engine.Msg('[AoE]', 'Pack ' + IntToStr(AoeCountAggro()) + ', spoil + AoE + sweep', 0);
      AoeFightPack();
      AoePickupLoot();
    end;
  end;
end;

// ===================== Caster farm (SetCasterFarm + SetSummon) =====================
// No interface. Every tick: pick the mob with the LOWEST HP (switching target
// all the time, even in the middle of a fight), send the summon at it, use a
// summon skill, cast our next attack skill. Mobs: whitelist inside the zone +
// anything that attacks us. Summon missing -> cast SetSummon skill.

// RequestActionUse (56): action ID, ctrl, shift - how the client gives orders to the summon
procedure PetAction(ActionID: integer);
begin
  Engine.SendToServer('56' + HexLE32(ActionID) + '00000000' + '00');
end;

function HaveSummon(): boolean;
begin
  result := (PetList.Count > 0) and (not PetList(0).Dead);
end;

// no summon -> summon it (SetSummon skill)
procedure CheckSummon();
begin
  if (SummonSkill <= 0) or HaveSummon() or User.Dead then exit;
  Engine.Msg('[Summon]', 'No summon, casting ' + IntToStr(SummonSkill), 128);
  Engine.UseSkill(SummonSkill);
  Delay(RESUMMON_WAIT);
end;

// the summon is buffed together with us -> before every buff make sure it is out
// and alive; summon it (several tries) if it is not
procedure SummonBeforeBuff();
var Tries: integer;
begin
  if SummonSkill <= 0 then exit;
  Tries := 0;
  while (not HaveSummon()) and (Tries < SUMMON_BUFF_TRIES) and (not User.Dead) and (not NeedReturn) do begin
    Inc(Tries);
    Engine.Msg('[Summon]', 'No summon before the buff, summoning (try ' + IntToStr(Tries) + ')', 128);
    Engine.UseSkill(SummonSkill);
    Delay(RESUMMON_WAIT);
  end;
  if not HaveSummon() then
    Engine.Msg('[Summon]', 'Summon is not out - it will not get the buff', 128);
end;

function CasterMobIsWhitelisted(i: integer): boolean;
var j, ID: integer;
begin
  result := Length(CasterMobIDs) = 0;
  if result then exit;
  ID := NpcList(i).ID;
  for j := 0 to Length(CasterMobIDs) - 1 do
    if ID = CasterMobIDs[j] then begin
      result := true;
      exit;
    end;
end;

// mob attacks us or our summon
function CasterIsAggro(i: integer): boolean;
var Atk, PetOID: integer;
begin
  Atk := NpcList(i).AtkOID;
  result := Atk = User.OID;
  if (not result) and HaveSummon() then begin
    PetOID := PetList(0).OID;
    result := Atk = PetOID;
  end;
end;

// Mob to farm (not attacking us yet), always the lowest absolute HP (CurHP), nearest on a tie:
// Mode 0 = inside CasterRange, Mode 1 = anywhere in the zone (we run to it). 0 = nothing.
function CasterFindNewMob(Mode: integer): integer;
var
  i, NX, NY, NZ, UX, UY, UZ, HP, BestHP: integer;
  D, BestDist: double;
begin
  result := 0;
  BestHP := MaxInt;
  BestDist := 999999;
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  for i := 0 to NpcList.Count - 1 do begin
    if NpcList(i).Dead then continue;
    if IsIgnoredNpc(i) then continue;
    if not CasterMobIsWhitelisted(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    if not InFarmArea(NX, NY, NZ) then continue;
    D := User.DistTo(NX, NY, NZ);
    if (Mode = 0) and (D > CasterRange) then continue;
    HP := NpcList(i).CurHP;   // absolute HP, not percent
    if (HP < BestHP) or ((HP = BestHP) and (D < BestDist)) then begin
      BestHP := HP;
      BestDist := D;
      result := NpcList(i).OID;
    end;
  end;
end;

// lowest absolute HP (CurHP) mob among those that attack us or the summon; 0 = nobody attacks
function CasterPickAggro(): integer;
var
  i, NX, NY, NZ, HP, BestHP: integer;
  D, BestDist: double;
begin
  result := 0;
  BestHP := MaxInt;
  BestDist := 999999;
  for i := 0 to NpcList.Count - 1 do begin
    if NpcList(i).Dead then continue;
    if IsIgnoredNpc(i) then continue;
    if not CasterIsAggro(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    D := User.DistTo(NX, NY, NZ);
    // never chase: aggro mobs farther than AGGRO_MAX_RANGE are not targeted
    if D > AGGRO_MAX_RANGE then continue;
    HP := NpcList(i).CurHP;   // absolute HP, not percent
    if (HP < BestHP) or ((HP = BestHP) and (D < BestDist)) then begin
      BestHP := HP;
      BestDist := D;
      result := NpcList(i).OID;
    end;
  end;
end;

// current target is still alive and inside the zone / radius (or right next to us)
function CasterTargetAlive(): boolean;
var i, NX, NY, NZ: integer;
begin
  result := false;
  if CasterTarget = 0 then exit;
  for i := 0 to NpcList.Count - 1 do
    if NpcList(i).OID = CasterTarget then begin
      if NpcList(i).Dead then exit;
      NX := NpcList(i).X;
      NY := NpcList(i).Y;
      NZ := NpcList(i).Z;
      result := InFarmArea(NX, NY, NZ) or (User.DistTo(NX, NY, NZ) <= CasterRange);
      exit;
    end;
end;

// Target choice:
//  1) something attacks us / the summon -> the lowest-HP of them (switching between them)
//  2) else keep the current target until it dies
//  3) else a new mob: lowest HP within CasterRange (in the zone)
//  nothing -> CasterFarm_Thread patrols to the next SetPatrol point (like patrol.txt)
function CasterChooseTarget(): integer;
begin
  result := CasterPickAggro();
  if result <> 0 then exit;
  if CasterTargetAlive() then begin
    result := CasterTarget;
    exit;
  end;
  result := CasterFindNewMob(0);
end;

// mob with this OID is a champion (MaxHP above PET_MELEE_MIN_HP)
function IsChampionOID(OID: integer): boolean;
var i, MaxHP: integer;
begin
  result := false;
  for i := 0 to NpcList.Count - 1 do
    if NpcList(i).OID = OID then begin
      MaxHP := NpcList(i).MaxHP;
      result := MaxHP > PET_MELEE_MIN_HP;
      exit;
    end;
end;

// ---- skills by priority (AddCasterSkill / AddPetSkill) ----

function HasSkills(Owner: integer): boolean;
var k: integer;
begin
  result := false;
  for k := 0 to Length(SkID) - 1 do
    if SkOwner[k] = Owner then begin
      result := true;
      exit;
    end;
end;

// ms since skill k was put on this mob; huge if never
function DebuffAge(k, OID: integer): cardinal;
var i: integer;
begin
  result := $7FFFFFFF;
  for i := 0 to 63 do
    if (DebuffSk[i] = k) and (DebuffOID[i] = OID) and (DebuffTime[i] > 0) then
      if GetTickCount - DebuffTime[i] < result then result := GetTickCount - DebuffTime[i];
end;

procedure MarkDebuff(k, OID: integer);
begin
  DebuffSk[DebuffHead] := k;
  DebuffOID[DebuffHead] := OID;
  DebuffTime[DebuffHead] := GetTickCount;
  DebuffHead := (DebuffHead + 1) mod 64;
end;

// HP % of the skill owner: necro or summon
function OwnerHP(Owner: integer): integer;
begin
  result := 100;
  if Owner = 0 then result := User.HP
  else if HaveSummon() then result := PetList(0).HP;
end;

function SkillReady(k, OID: integer): boolean;
var Since: cardinal;
begin
  Since := GetTickCount - SkLast[k];
  if SkKind[k] = SKILL_DEBUFF then
    result := (Since >= 1000) and (DebuffAge(k, OID) >= cardinal(SkInterval[k]))
  else if SkKind[k] = SKILL_DRAIN then
    result := (OwnerHP(SkOwner[k]) < SkParam[k]) and (Since >= cardinal(SkInterval[k]))
  else
    result := Since >= cardinal(SkInterval[k]);
end;

// uses the first skill of this owner (0 = necro, 1 = summon) that may be used now
function UseNextSkill(Owner, OID: integer): boolean;
var k: integer;
  Ok: boolean;
begin
  result := false;
  for k := 0 to Length(SkID) - 1 do begin
    if SkOwner[k] <> Owner then continue;
    if not SkillReady(k, OID) then continue;

    if Owner = 0 then
      Ok := Engine.UseSkill(SkID[k])
    else begin
      PetAction(SkID[k]);
      Ok := true;
    end;
    if not Ok then continue;   // not castable now (reuse, range...) -> try the next one

    SkLast[k] := GetTickCount;
    if SkKind[k] = SKILL_DEBUFF then MarkDebuff(k, OID);
    result := true;
    exit;
  end;
end;

// one fight step on the lowest-HP mob: retarget, summon attack + skill, our skill
procedure CasterFightStep(OID: integer);
begin
  if OID <> CasterTarget then begin
    Engine.SetTarget(OID);
    CasterTarget := OID;
    LastPetAttack := 0;   // new target -> order the summon right away
    Delay(100);
  end;

  if HaveSummon() then begin
    // the summon runs in and hits with its hands only on champions; on others it just uses its skills
    if (GetTickCount - LastPetAttack >= PET_ATTACK_MS) and IsChampionOID(OID) then begin
      PetAction(PET_ATTACK_ACTION);
      LastPetAttack := GetTickCount;
    end;
    if GetTickCount - LastPetSkill >= PET_SKILL_GAP then
      if UseNextSkill(1, OID) then LastPetSkill := GetTickCount;
  end;

  if not UseNextSkill(0, OID) then begin
    if HasSkills(0) then Delay(100)        // every skill is waiting for its time
    else Engine.Attack(300);               // no skills at all: plain attack
  end;
end;

// kill everything that attacks us (rebuff uses it to leave combat)
procedure CasterKillAggro();
var OID: integer;
begin
  while (not User.Dead) and (not NeedReturn) do begin
    OID := CasterPickAggro();
    if OID = 0 then exit;
    CasterFightStep(OID);
    Delay(200);
  end;
end;

// Patrol like patrol.txt: run to the next patrol point (round robin) in short
// steps; stop as soon as a mob shows up within range or something attacks us.
procedure CasterPatrolStep();
var n, TX, TY, TZ: integer;
  Started: cardinal;
begin
  n := Length(PatrolPoints) div 3;
  if n = 0 then exit;
  if PatrolIdx >= n then PatrolIdx := 0;
  TX := PatrolPoints[PatrolIdx * 3];
  TY := PatrolPoints[PatrolIdx * 3 + 1];
  TZ := PatrolPoints[PatrolIdx * 3 + 2];
  Engine.Msg('[Patrol]', 'No mobs around, patrol point ' + IntToStr(PatrolIdx + 1) + '/' + IntToStr(n), 0);
  PatrolIdx := (PatrolIdx + 1) mod n;

  Started := GetTickCount;
  while User.DistTo(TX, TY, TZ) > PATH_REACHED do begin
    if User.Dead or AoeMustStop() or TreeBusy or SummonBusy then exit;
    if CasterChooseTarget() <> 0 then exit;     // a mob within range / attacking us -> fight it
    if GetTickCount - Started > 60000 then exit;
    Engine.MoveTo(TX, TY, TZ, PATROL_STEP_MS);
  end;
end;

procedure CasterFarm_Thread();
var OID, IdleMs, IdleLimit: integer;
begin
  CasterTarget := 0;
  IdleMs := 0;
  IdleLimit := PatrolIdle * 1000;
  if IdleLimit <= 0 then IdleLimit := 3000;
  while Delay(200) do begin
    if AoeMustStop() or TreeBusy or SummonBusy then begin
      CasterTarget := 0;
      IdleMs := 0;
      continue;
    end;
    if (BuffID <> 0) and (BuffTime(BuffID) < REBUFF_TIME) then continue;   // rebuff first

    // a dead / missing summon is renewed by SummonWatch_Thread (safe point, combat, summon, buff)
    OID := CasterChooseTarget();
    if OID = 0 then begin
      // nobody within range: after IdleLimit go to the next patrol point (SetPatrol)
      CasterTarget := 0;
      IdleMs := IdleMs + 200;
      if HasPatrol() and (IdleMs >= IdleLimit) then begin
        CasterPatrolStep();
        IdleMs := 0;
      end;
      continue;
    end;

    IdleMs := 0;
    CasterFightStep(OID);
  end;
end;

// ===================== Clear combat (rebuff) =====================

// Fights off everything that attacks us and leaves combat.
// Farm is turned OFF only when nobody hits us; if a mob appears again, farm goes back ON.
function ClearCombat(): boolean;
var Rounds, Wait: integer;
begin
  result := false;
  Rounds := 0;
  while (Rounds < 8) do begin
    if User.Dead or NeedReturn then exit;

    // 1) kill everything that is on us (profile mode: the profile kills them, AoE mode: the script)
    if HaveAgroMobs() then begin
      Engine.Msg('[Rebuff]', 'Mobs on me, killing them', 128);
      if AoeEnabled then begin
        FarmOff();          // no new pulls, just kill what is on us
        AoeFightPack();
      end else if CasterEnabled then begin
        FarmOff();
        CasterKillAggro();
      end else begin
        FarmOn();
        Wait := 0;
        while HaveAgroMobs() and (Wait < 220) do begin
          if User.Dead or NeedReturn then exit;
          Delay(555); Inc(Wait);
        end;
      end;
    end;

    // 2) nobody on us now: stop farm and wait for the combat flag to drop
    FarmOff();
    Wait := 0;
    while User.InCombat and (not HaveAgroMobs()) and (Wait < 40) do begin
      if User.Dead or NeedReturn then exit;
      Delay(555); Inc(Wait);
    end;

    // 3) somebody hit us again -> back to killing (farm is switched on in step 1)
    if HaveAgroMobs() then begin
      Inc(Rounds);
      continue;
    end;

    if not User.InCombat then begin
      result := true;
      exit;
    end;
    Inc(Rounds);
  end;
end;

function IsInAden(): boolean;
begin
  result := User.DistTo(ADEN_X, ADEN_Y, ADEN_Z) < ADEN_RADIUS;
end;

// coordinates are copied into locals first: passing User.X/Y/Z straight into
// Engine.InZone crashes the script (access violation)
function IsInFarmZone(): boolean;
var UX, UY, UZ: integer;
begin
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  result := InFarmArea(UX, UY, UZ);
end;

// Loads the interface config and the farm zone.
// Whether the zone really loaded is checked afterwards by IsInFarmZone.
// SetZone('') = keep the zone that is active in the bot; if there is none
// (we do not stand in it) -> FREE_RADIUS around the start point.
procedure LoadFarmSettings();
var UX, UY, UZ: integer;
begin
  if ConfigName <> '' then begin
    Engine.Msg('[Init]', 'LoadConfig: ' + Script.Path + CONFIG_DIR + ConfigName, 128);
    Engine.LoadConfig(Script.Path + CONFIG_DIR + ConfigName);
    Delay(1000);
  end;

  if ZoneName <> '' then begin
    Engine.Msg('[Init]', 'LoadZone: ' + Script.Path + ZONE_DIR + ZoneName, 128);
    Engine.ClearZone;
    Engine.LoadZone(Script.Path + ZONE_DIR + ZoneName);
    Delay(500);
    UseRadius := false;
  end else if not AreaDecided then begin
    AreaDecided := true;
    UX := User.X;
    UY := User.Y;
    UZ := User.Z;
    UseRadius := not Engine.InZone(UX, UY, UZ);
    if UseRadius then begin
      if not StayMode() then begin   // home = start point (stay mode sets it in RunFarm)
        HomeX := UX;
        HomeY := UY;
        HomeZ := UZ;
      end;
      Engine.Msg('[Init]', 'No zone in the bot: farming within ' + IntToStr(FREE_RADIUS) + ' of the start point', 128);
    end else
      Engine.Msg('[Init]', 'Using the zone that is active in the bot', 128);
  end;
end;

// Loads zone + config and turns the profile on ONLY if we stand inside the zone.
// ReportMismatch = true: say in chat that the path and the zone do not match.
function StartFarm(ReportMismatch: boolean): boolean;
begin
  result := false;
  OnSpot := false;
  FarmOff();

  LoadFarmSettings();

  if not IsInFarmZone() then begin
    if ReportMismatch then
      Engine.Msg('[Path]', 'Path and zone do not match! Standing at ' +
        IntToStr(User.X) + ', ' + IntToStr(User.Y) + ', ' + IntToStr(User.Z) +
        ' - outside ' + ZoneName + '. Fix the path or the zone. Farm is OFF', 128);
    exit;
  end;

  OnSpot := true;
  FarmOn();
  Engine.Msg('[Farm]', '=== In the zone, profile ON ===', 128);
  result := true;
end;

// Walks the spot path, then loads the zone and starts the farm.
// Returns true only if we are inside the zone and the profile is ON.
// Walks to one point: MoveTo is repeated until we are there (MoveTo alone can
// stop half way on a long run) or PATH_POINT_TIMEOUT seconds pass.
function WalkToPoint(X, Y, Z: integer): boolean;
var Started: cardinal;
begin
  result := false;
  Started := GetTickCount;
  while not User.Dead do begin
    if User.DistTo(X, Y, Z) < PATH_REACHED then begin
      result := true;
      exit;
    end;
    if GetTickCount - Started > PATH_POINT_TIMEOUT * 1000 then begin
      Engine.Msg('[Path]', 'Could not reach ' + IntToStr(X) + ', ' + IntToStr(Y) + ', ' + IntToStr(Z) +
        ' in ' + IntToStr(PATH_POINT_TIMEOUT) + ' sec', 128);
      exit;
    end;
    Engine.MoveTo(X, Y, Z);
    Delay(300);
  end;
end;

// Walks from where we stand to the point, splitting a long run into PATH_STEP pieces.
function WalkSegment(X, Y, Z: integer): boolean;
var
  FX, FY, FZ, Steps, s: integer;
  Dist: double;
begin
  FX := User.X;
  FY := User.Y;
  FZ := User.Z;
  Dist := User.DistTo(X, Y, Z);
  Steps := Trunc(Dist / PATH_STEP) + 1;
  result := true;
  for s := 1 to Steps - 1 do begin
    // intermediate points do not have to be reached exactly
    WalkToPoint(FX + (X - FX) * s div Steps, FY + (Y - FY) * s div Steps, FZ + (Z - FZ) * s div Steps);
    if User.Dead then begin result := false; exit; end;
  end;
  result := WalkToPoint(X, Y, Z);
end;

function WalkToSpot(): boolean;
var i: integer;
begin
  result := false;
  Engine.Msg('[Path]', '=== Walking to the spot ===', 128);
  i := 0;
  while (i + 2) < Length(Path) do begin
    if User.Dead then begin
      Engine.Msg('[Path]', 'Died on the way', 128);
      exit;
    end;
    WalkSegment(Path[i], Path[i + 1], Path[i + 2]);   // a missed point is reported, we still try the next one
    i := i + 3;
  end;
  if User.Dead then exit;
  Engine.Msg('[Path]', 'Path finished, checking the zone', 0);

  result := StartFarm(true);
end;

// Walks to the safe point (farm OFF) and makes sure nobody hits us there.
// Mobs that followed us are killed and we walk back again (max 3 times).
// Without SetSafePoint we just stay where we are.
function GoToSafePoint(): boolean;
var Tries: integer;
begin
  result := true;
  if not HasSafePoint then exit;

  result := false;
  for Tries := 1 to 3 do begin
    if User.Dead or NeedReturn then exit;
    Engine.Msg('[Rebuff]', 'Going to the safe point', 0);
    FarmOff();
    Engine.MoveTo(SafeX, SafeY, SafeZ);
    Delay(1000);
    if User.Dead or NeedReturn then exit;

    if not HaveAgroMobs() then begin
      result := true;
      exit;
    end;

    Engine.Msg('[Rebuff]', 'Mobs followed me to the safe point, killing them', 128);
    if not ClearCombat() then exit;
  end;
end;

// SetExpOff(true): tell the server to stop giving XP. Sent at start and on every
// return via Aden, so it stays off even if the server reset it.
procedure ApplyExpOff();
begin
  if not ExpOff then exit;
  Engine.Msg('[Init]', 'XP gain OFF (' + EXP_OFF_BYPASS + ')', 0);
  Engine.BypassToServer(EXP_OFF_BYPASS);
  Delay(500);
end;

// Something is wrong: stop the farm and let the return thread bring us back via Aden.
procedure RequestReturn(Reason: string);
begin
  Engine.Msg('[Return]', Reason + ' -> going back via Aden', 128);
  OnSpot := false;
  NeedReturn := true;
  FarmOff();
end;

// ===================== Return logic (always via Aden) =====================

// returns true if we are in Aden (already there or teleported)
function TeleportToAden(): boolean;
var
  Attempt, Waited: integer;
begin
  result := IsInAden();
  if result then begin
    Engine.Msg('[Return]', 'Already in Aden', 0);
    exit;
  end;

  for Attempt := 1 to 3 do begin
    if User.Dead then exit;
    Engine.Msg('[Return]', 'Casting Aden teleport (try ' + IntToStr(Attempt) + ')', 0);
    if Engine.UseSkill(ADEN_SKILL_ID) then begin
      Waited := 0;
      while (Waited < 20000) and (not IsInAden()) and (not User.Dead) do begin
        Delay(500);
        Waited := Waited + 500;
      end;
      if IsInAden() then begin
        Engine.Msg('[Return]', 'In Aden', 128);
        result := true;
        exit;
      end;
    end;
    Engine.Msg('[Return]', 'Aden teleport failed, retry...', 128);
    Delay(2000);
  end;
end;

// Buff on the save point (Aden). Bot is OFF here.
procedure TownRebuff();
var Tries: integer;
begin
  if BuffID = 0 then exit;   // SetBuff not called: no rebuff
  if BuffTime(BuffID) > REBUFF_TIME then begin
    Engine.Msg('[Return]', 'Buff is still fine, skipping rebuff', 0);
    exit;
  end;

  Engine.Msg('[Return]', 'Buffing in Aden...', 0);
  SummonBeforeBuff();   // the summon is buffed together with us
  Tries := 0;
  repeat
    if User.Dead then exit;
    BuffAltB();
    Delay(2000);
    Inc(Tries);
  until (BuffTime(BuffID) > REBUFF_TIME) or (Tries >= 10);

  if BuffTime(BuffID) > REBUFF_TIME then
    Engine.Msg('[Return]', 'Buff received', 128)
  else
    Engine.Msg('[Return]', 'Buff NOT received after 10 tries, continuing anyway', 128);
end;

procedure GoToGatekeeper();
begin
  Engine.Msg('[Return]', 'Going to gatekeeper...', 0);
  FarmOff();
  Engine.MoveTo(GK_X, GK_Y, GK_Z);
  Delay(1000);
end;

// returns true only if the teleport really happened
function TeleportToSpot(): boolean;
var
  AttemptCount: integer;
  i: integer;
  NpcOID: integer;
begin
  result := false;
  Engine.Msg('[Return]', 'Teleporting to the spot...', 0);

  NpcOID := 0;
  for i := 0 to NpcList.Count - 1 do begin
    if (NpcList(i).ID = GK_ID) then begin
      NpcOID := NpcList(i).OID;
      break;
    end;
  end;

  if (NpcOID = 0) then begin
    Engine.Msg('[Return]', 'Gatekeeper not found nearby!', 128);
    exit;
  end;

  AttemptCount := 0;
  while (AttemptCount < 3) do begin
    if User.Dead then exit;

    Engine.SetTarget(NpcOID);
    Delay(800);

    if Engine.DlgOpen(GK_ID) then begin
      Delay(1500);

      Engine.DlgSel(0);
      Delay(2000);

      Engine.BypassToServer(TeleportBypass);
      Delay(1500);

      Engine.ConfirmDialog(true);
      Delay(4000);

      if (User.DistTo(GK_X, GK_Y, GK_Z) > 3000) then begin
        Engine.Msg('[Return]', 'Teleported!', 128);
        result := true;
        exit;
      end;
    end;

    Inc(AttemptCount);
    Engine.Msg('[Return]', 'Attempt #' + IntToStr(AttemptCount) + ' failed, retry...', 128);
    Delay(2000);
  end;

  Engine.Msg('[Return]', 'Failed to teleport in 3 attempts', 128);
end;

// Full trip: Aden -> buff + supplies -> gatekeeper -> spot.
// Returns true only if the character really reached the spot (farm is ON then).
function GoToFarmSpot(): boolean;
begin
  result := false;
  IsRecovering := true;
  OnSpot := false;
  FarmOff();
  // stay mode: no Aden, no teleport - walk back to where the script was started
  if StayMode() then begin
    Engine.Msg('[GoToSpot]', 'Stay mode: back to the start point', 0);
    WalkToPoint(HomeX, HomeY, HomeZ);
    result := StartFarm(true);
    IsRecovering := false;
    exit;
  end;

  Engine.Msg('[GoToSpot]', '=== Going to the farm spot via Aden ===', 128);

  if not TeleportToAden() then begin
    Engine.Msg('[GoToSpot]', 'Could not get to Aden, farm is OFF', 128);
    IsRecovering := false;
    exit;
  end;

  ApplyExpOff();
  TownRebuff();
  if User.Dead then begin IsRecovering := false; exit; end;

  BuySupplies();
  if User.Dead then begin IsRecovering := false; exit; end;

  // no SetTeleport: no gatekeeper, the path starts right in Aden
  if TeleportBypass <> '' then begin
    GoToGatekeeper();
    if not TeleportToSpot() then begin
      Engine.Msg('[GoToSpot]', 'Teleport failed, farm is OFF', 128);
      IsRecovering := false;
      exit;
    end;
  end else
    Engine.Msg('[GoToSpot]', 'No SetTeleport, walking from Aden', 0);

  result := WalkToSpot();
  if not result then
    Engine.Msg('[GoToSpot]', 'Not in the farm zone, farm is OFF', 128);
  IsRecovering := false;
end;

// ===================== Alerts =====================
// Every alert goes to the bot chat + its sound from Library\Sounds + taskbar blink + Telegram (SetTelegram).

procedure Alert(Title, Text, Sound: string);
begin
  Engine.Msg(Title, Text, 255);
  if Sound <> '' then PlaySound(Script.Path + SOUND_DIR + Sound);
  if AlertBlink then Engine.BlinkWindow(true);   // true = game window, false = Adrenaline window
  if TelegramKey <> '' then SendToTelegram(TelegramKey, User.Name + ': ' + Title + ' ' + Text);
end;

// ===================== Death / return thread =====================
// The ONLY thread that moves the character between town and spot.

procedure DeathHandler_Thread();
var
  WaitCounter: integer;
  OutOfZone: integer;
begin
  OutOfZone := 0;
  while Delay(1000) do begin
    if not IsOnline() then continue;   // disconnected: Login_Thread handles it

    if User.Dead then begin
      // block the rebuff thread immediately
      IsRecovering := true;
      OnSpot := false;
      NeedReturn := true;
      FarmOff();
      Alert('[Death]', 'Character died', DeathSound);

      // stay mode: there is no way back from town -> wait for a resurrection
      if StayMode() then begin
        Engine.Msg('[Death]', 'Stay mode: waiting for a resurrection (no "To Village")', 128);
        while User.Dead do Delay(1000);
        Delay(3000);
        IsRecovering := false;
        continue;   // NeedReturn -> back to the start point and farm
      end;

      Engine.Msg('[Death]', 'Waiting 5 sec before "To Village"...', 128);

      WaitCounter := 0;
      while (WaitCounter < 5) and User.Dead do begin
        Delay(1000);
        Inc(WaitCounter);
      end;

      while User.Dead do begin
        Engine.Msg('[Death]', 'Pressing "To Village"', 128);
        Engine.GoHome;
        Delay(2000);
      end;

      Delay(RESPAWN_WAIT);
      Engine.Msg('[Death]', 'Resurrected, returning to the spot via Aden', 128);
      IsRecovering := false;
    end;

    // farming but stuck outside the zone for too long -> unclear situation
    if OnSpot and (not IsRecovering) and (not IsInFarmZone()) then begin
      Inc(OutOfZone);
      if OutOfZone >= OUT_OF_ZONE_LIMIT then begin
        OutOfZone := 0;
        RequestReturn('Outside the farm zone for ' + IntToStr(OUT_OF_ZONE_LIMIT) + ' sec');
      end;
    end else
      OutOfZone := 0;

    if NeedReturn and (not User.Dead) then begin
      if GoToFarmSpot() then
        NeedReturn := false
      else begin
        Engine.Msg('[Return]', 'Retry in 10 sec', 128);
        Delay(10000);
      end;
    end;

  end;
end;

// ===================== Rebuff thread =====================
// Character is fine -> rebuff in place on the spot (kill mobs, leave combat,
// buff, buy supplies once per cycle). If it keeps failing -> go to Aden and buff there.

procedure AltB_Rebuff_Thread();
var
  Fails: integer;
  SuppliesDone: boolean;
begin
  Fails := 0;
  SuppliesDone := false;
  while delay(1000) do begin
    if TreeBusy or SummonBusy or PatrolBusy then continue;   // tree handler / summon renew / patrol run are busy, rebuff after them
    if (not IsOnline()) or IsRecovering or NeedReturn then begin
      Fails := 0;
      continue;
    end;
    if User.Dead then continue;
    if BuffID = 0 then continue;   // SetBuff not called: no rebuff

    if (BuffTime(BuffID) < REBUFF_TIME) then begin
      Engine.Msg('[Rebuff]', 'Buff is low, preparing to rebuff...', 0);

      // --- fight off mobs and leave combat (only on the spot) ---
      if OnSpot then begin
        if not ClearCombat() then begin
          if User.Dead or NeedReturn then continue;
          Inc(Fails);
          if (Fails >= SPOT_REBUFF_FAILS) then begin
            Fails := 0;
            RequestReturn('Cannot leave combat to rebuff');
            continue;
          end;
          Engine.Msg('[Rebuff]', 'Still in combat, back to farm, retry in 5 sec', 128);
          FarmOn();
          Delay(5000);
          continue;
        end;
        if User.Dead or NeedReturn then continue;

        // --- step aside to the safe point before buffing ---
        if not GoToSafePoint() then begin
          if User.Dead or NeedReturn then continue;
          Inc(Fails);
          if (Fails >= SPOT_REBUFF_FAILS) then begin
            Fails := 0;
            RequestReturn('Cannot get to the safe point to rebuff');
            continue;
          end;
          Engine.Msg('[Rebuff]', 'Safe point is not safe, back to farm, retry in 5 sec', 128);
          FarmOn();
          Delay(5000);
          continue;
        end;
        Delay(1000);
      end;

      SummonBeforeBuff();   // the summon is buffed together with us
      BuffAltB();
      Delay(2000);

      if (BuffTime(BuffID) < REBUFF_TIME) then begin
        Inc(Fails);
        if (Fails >= SPOT_REBUFF_FAILS) then begin
          Fails := 0;
          if OnSpot then begin
            RequestReturn('Rebuff on the spot failed ' + IntToStr(SPOT_REBUFF_FAILS) + ' times');
            continue;
          end;
          Engine.Msg('[Rebuff]', 'Rebuff failed ' + IntToStr(SPOT_REBUFF_FAILS) + ' times, pause 60 sec', 128);
          Delay(60000);
        end;
      end else
        Fails := 0;

      // --- supplies once per rebuff cycle, AFTER the buff ---
      if not SuppliesDone then begin
        SuppliesDone := true;
        BuySupplies();
      end;

      if OnSpot and (not User.Dead) and (not NeedReturn) then FarmOn();   // back to farm
    end else
      SuppliesDone := false;     // buffed: next low-buff event is a new cycle
  end;
end;

// ===================== Tree mobs (SetTreeMobs) =====================
// The profile sometimes picks a mob it cannot hit (on a tree, behind a rock):
// the bot stands next to it and the mob's HP does not move. Then we turn the
// profile off, put on the bow, step back, shoot the mob dead (moving around it
// if the shots do not land), put the melee weapon back and turn the profile on.

function FindNpcIdxByOID(NpcOID: integer): integer;
var i: integer;
begin
  result := -1;
  for i := 0 to NpcList.Count - 1 do
    if NpcList(i).OID = NpcOID then begin
      result := i;
      exit;
    end;
end;

// OID of the current target, 0 if none
function TargetOID(): integer;
begin
  result := 0;
  try
    if User.Target <> nil then result := User.Target.OID;
  except
    result := 0;
  end;
end;

// true if an item with this ID is equipped right now
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

// Puts the weapon on and checks that it really is on. A single UseItem is
// sometimes ignored (attack / cast animation) and the char fights with bare hands.
// Using an item that is already on takes it OFF, so before every UseItem the
// inventory is refreshed and checked again - never toggle on stale data.
// Only one thread swaps weapons at a time (EquipBusy): two UseItem of the same
// weapon in a row would take it off again.
function EquipWeapon(ItemID: integer): boolean;
var Tries, Waited: integer;
begin
  // another thread is swapping right now -> wait for it, then check again
  Waited := 0;
  while EquipBusy and (Waited < 15000) do begin
    Delay(200);
    Waited := Waited + 200;
  end;
  EquipBusy := true;

  result := IsEquipped(ItemID);
  Tries := 0;
  while (not result) and (Tries < EQUIP_TRIES) and (not User.Dead) do begin
    RefreshInventory();
    result := IsEquipped(ItemID);
    if result then break;
    Inc(Tries);
    Engine.UseItem(ItemID);
    Delay(1000);
    result := IsEquipped(ItemID);
  end;
  if not result then
    Engine.Msg('[Weapon]', 'Could not equip item ' + IntToStr(ItemID) + ' after ' + IntToStr(EQUIP_TRIES) + ' tries', 128);

  EquipBusy := false;
end;

// Shoots the mob with the bow until it dies. Ported from spoil_cbp_dion_2 HandleTreeMob.
procedure HandleTreeMob(OID: integer);
const
  POLL_DELAY_MS = 500;
  PI_VAL        = 3.14159265358979;
var
  Idx, MX, MY, MZ, UX, UY, UZ: integer;
  DX, DY, Len, NX, NY, AngleRad, RotX, RotY: double;
  Repositions, BackoffX, BackoffY, LastHP, CurHP, StuckMs: integer;
  GaveUp: boolean;
begin
  Idx := FindNpcIdxByOID(OID);
  if Idx < 0 then exit;
  MX := NpcList(Idx).X;
  MY := NpcList(Idx).Y;
  MZ := NpcList(Idx).Z;
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;

  // direction from the mob to us; standing right under it -> pick east
  DX := UX - MX;
  DY := UY - MY;
  Len := Sqrt(DX * DX + DY * DY);
  if Len < 50 then begin DX := 1; DY := 0; Len := 1; end;
  NX := DX / Len;
  NY := DY / Len;

  Engine.Msg('[Tree]', 'Tree mob OID=' + IntToStr(OID) + ', equipping bow ' + IntToStr(TreeBowID), 128);
  if not EquipWeapon(TreeBowID) then begin
    EquipWeapon(TreeMeleeID);   // no bow -> at least do not stay with bare hands
    exit;
  end;

  Repositions := 0;
  LastHP := -1;
  StuckMs := 0;
  GaveUp := false;

  BackoffX := MX + Round(NX * TreeBowRange);
  BackoffY := MY + Round(NY * TreeBowRange);
  Engine.MoveTo(BackoffX, BackoffY, UZ);
  Engine.SetTarget(OID);
  Engine.Attack;

  while not User.Dead do begin
    Idx := FindNpcIdxByOID(OID);
    if (Idx < 0) or NpcList(Idx).Dead then break;

    Engine.SetTarget(OID);
    Engine.Attack;
    Delay(POLL_DELAY_MS);

    Idx := FindNpcIdxByOID(OID);
    if (Idx < 0) or NpcList(Idx).Dead then break;

    CurHP := NpcList(Idx).CurHP;
    if (LastHP < 0) or (CurHP < LastHP) then begin
      StuckMs := 0;   // the shots land
      LastHP := CurHP;
    end else begin
      StuckMs := StuckMs + POLL_DELAY_MS;
      if StuckMs >= TREE_STUCK_MS then begin
        Inc(Repositions);
        if Repositions > TREE_MAX_REPOS then begin
          Engine.Msg('[Tree]', 'No HP drop after ' + IntToStr(TREE_MAX_REPOS) + ' repositions, giving up', 128);
          GaveUp := true;
          break;
        end;
        // move 45 deg further around the mob
        AngleRad := 45 * Repositions * PI_VAL / 180.0;
        RotX := NX * Cos(AngleRad) - NY * Sin(AngleRad);
        RotY := NX * Sin(AngleRad) + NY * Cos(AngleRad);
        BackoffX := MX + Round(RotX * TreeBowRange);
        BackoffY := MY + Round(RotY * TreeBowRange);
        Engine.Msg('[Tree]', 'No HP drop, reposition #' + IntToStr(Repositions), 0);
        Engine.MoveTo(BackoffX, BackoffY, UZ);
        Engine.SetTarget(OID);
        Engine.Attack;
        StuckMs := 0;
      end;
    end;
  end;

  Engine.Msg('[Tree]', 'Done, equipping melee ' + IntToStr(TreeMeleeID), 128);
  Engine.CancelTarget;   // stop shooting, otherwise the swap can be ignored
  Delay(500);
  EquipWeapon(TreeMeleeID);

  // gave up: walk away to break its aggro (safe point if we have one)
  if GaveUp and HasSafePoint then Engine.MoveTo(SafeX, SafeY, SafeZ);
end;

// Watches the target while farming and calls HandleTreeMob for a stuck one.
procedure TreeWatch_Thread();
const
  POLL_MS = 500;
var
  OID, LastOID, Idx, HP, LastHP, StuckMs, NX, NY, NZ: integer;
begin
  LastOID := 0;
  LastHP := -1;
  StuckMs := 0;
  while Delay(POLL_MS) do begin
    // only while farming; a low buff belongs to the rebuff thread
    if (not IsOnline()) or (not OnSpot) or IsRecovering or NeedReturn or User.Dead or
       ((BuffID <> 0) and (BuffTime(BuffID) < REBUFF_TIME)) then begin
      StuckMs := 0;
      continue;
    end;

    // the melee weapon between tree mobs is kept on by WeaponWatch_Thread (WeaponID = TreeMeleeID)

    OID := TargetOID();
    Idx := -1;
    if OID <> 0 then Idx := FindNpcIdxByOID(OID);
    if (Idx < 0) or NpcList(Idx).Dead then begin
      LastOID := 0;
      StuckMs := 0;
      continue;
    end;

    HP := NpcList(Idx).CurHP;
    NX := NpcList(Idx).X;
    NY := NpcList(Idx).Y;
    NZ := NpcList(Idx).Z;

    if (OID = LastOID) and (HP >= LastHP) and (User.DistTo(NX, NY, NZ) < TREE_NEAR_RANGE) then
      StuckMs := StuckMs + POLL_MS
    else
      StuckMs := 0;
    LastOID := OID;
    LastHP := HP;

    if StuckMs >= TREE_DETECT_MS then begin
      TreeBusy := true;
      FarmOff();
      HandleTreeMob(OID);
      if OnSpot and (not User.Dead) and (not NeedReturn) then FarmOn();
      TreeBusy := false;
      LastOID := 0;
      StuckMs := 0;
    end;
  end;
end;

// No SetWeapon: remember the weapon we hold when the script starts.
// Weapon = equipped item in the right-hand ($0080) or two-hand ($4000) slot.
procedure RememberWeapon();
var i, ID, Part: integer;
  Parts: string;
begin
  // tree mobs on: the weapon between them is the melee one from SetTreeMobs, never the bow
  if TreeEnabled then begin
    if (WeaponID > 0) and (WeaponID <> TreeMeleeID) then
      Engine.Msg('[Weapon]', 'SetWeapon differs from the SetTreeMobs melee weapon, using ' + IntToStr(TreeMeleeID), 128);
    WeaponID := TreeMeleeID;
    exit;
  end;
  if WeaponID > 0 then exit;
  RefreshInventory();
  Parts := '';
  for i := 0 to Inventory.User.Count - 1 do begin
    if not Inventory.User.Items(i).Equipped then continue;
    ID := Inventory.User.Items(i).ID;
    Part := Inventory.User.Items(i).BodyPart;
    if (Part = WEAPON_SLOT_RHAND) or (Part = WEAPON_SLOT_LRHAND) then begin
      WeaponID := ID;
      Engine.Msg('[Weapon]', 'Remembered weapon: ' + Inventory.User.Items(i).Name + ' (ID ' + IntToStr(ID) +
        ', slot ' + IntToStr(Part) + ')', 128);
      exit;
    end;
    Parts := Parts + ' ' + IntToStr(ID) + '/' + IntToStr(Part);
  end;
  Engine.Msg('[Weapon]', 'No weapon in hands - disarm check is OFF. Equipped ID/slot:' + Parts, 128);
end;

// ===================== Disarm guard (SetWeapon) =====================
// A mob can take the weapon off (disarm): put it back on. EquipWeapon refreshes
// the inventory first, so a weapon that is on is never toggled off.

procedure WeaponWatch_Thread();
begin
  while Delay(WEAPON_POLL_MS) do begin
    if (not IsOnline()) or User.Dead or TreeBusy then continue;   // tree handler wears the bow on purpose
    if IsEquipped(WeaponID) then continue;
    Engine.Msg('[Weapon]', 'Weapon ' + IntToStr(WeaponID) + ' is not on (disarm?), equipping', 128);
    EquipWeapon(WeaponID);
  end;
end;

// ===================== Ignored NPCs in profile mode =====================
// Script modes skip them when picking targets; the profile picks its own targets,
// so here we just drop the target if the profile took an ignored NPC.

procedure IgnoreWatch_Thread();
var OID, Idx: integer;
begin
  while Delay(300) do begin
    if (not IsOnline()) or (not OnSpot) or User.Dead then continue;
    OID := TargetOID();
    if OID = 0 then continue;
    Idx := FindNpcIdxByOID(OID);
    if (Idx >= 0) and IsIgnoredNpc(Idx) then begin
      Engine.Msg('[Target]', 'Ignored NPC ' + NpcList(Idx).Name + ', dropping target', 0);
      Engine.CancelTarget;
    end;
  end;
end;

// ===================== Summon renew (SetSummon) =====================
// Summon died / is missing: summon a new one RIGHT HERE, in the middle of the fight
// (no safe point, no leaving combat), then rebuff so the new summon gets the buff.
// The fight thread only pauses while the summon skill is being cast.

procedure RenewSummon(Reason: string);
begin
  SummonBusy := true;   // the fight thread waits while we cast the summon
  Engine.Msg('[Summon]', Reason + ', summoning right here', 128);

  if (not User.Dead) and (not NeedReturn) then begin
    Engine.UseSkill(SummonSkill);
    Delay(RESUMMON_WAIT);
    if HaveSummon() then
      Engine.Msg('[Summon]', 'New summon is out', 128)
    else
      Engine.Msg('[Summon]', 'Summon did NOT come out, next try in a moment', 128);

    // rebuff: the summon is buffed together with us
    if (BuffID <> 0) and (not User.Dead) and HaveSummon() then begin
      Engine.Msg('[Summon]', 'Rebuff after the summon', 0);
      BuffAltB();
      Delay(2000);
    end;
  end;

  SummonBusy := false;
end;

// summon died / is not out -> renew it (its time left is NOT watched)
procedure SummonWatch_Thread();
begin
  while Delay(1000) do begin
    if (not IsOnline()) or (not OnSpot) or IsRecovering or NeedReturn or User.Dead or TreeBusy then continue;
    if not HaveSummon() then RenewSummon('Summon is dead / missing');
  end;
end;

// ===================== Patrol thread (SetPatrol, profile mode) =====================
// The profile only attacks what it sees. No live target for PatrolIdle seconds ->
// walk the patrol points one by one (profile stays ON) until it picks a target.
// AoE mode patrols inside AoePullPack instead.

function HasLiveTarget(): boolean;
var OID, Idx: integer;
begin
  result := false;
  OID := TargetOID();
  if OID = 0 then exit;
  Idx := FindNpcIdxByOID(OID);
  if Idx < 0 then exit;
  result := not NpcList(Idx).Dead;
end;

// mobs that were around when the run started: the profile did not take them, do not stop for them
var
  PatrolStartOIDs: array of integer;

function PatrolMobOK(i: integer): boolean;
var NX, NY, NZ: integer;
begin
  result := false;
  if NpcList(i).Dead then exit;
  if IsIgnoredNpc(i) then exit;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  if User.DistTo(NX, NY, NZ) > PATROL_MOB_RANGE then exit;
  result := InFarmArea(NX, NY, NZ);
end;

procedure RememberPatrolStartMobs();
var i, n: integer;
begin
  SetLength(PatrolStartOIDs, 0);
  for i := 0 to NpcList.Count - 1 do
    if PatrolMobOK(i) then begin
      n := Length(PatrolStartOIDs);
      SetLength(PatrolStartOIDs, n + 1);
      PatrolStartOIDs[n] := NpcList(i).OID;
    end;
end;

// a NEW live mob (not there at the start of the run) close to us inside the farm area
function PatrolMobNearby(): boolean;
var i, j, OID: integer;
  Old: boolean;
begin
  result := false;
  for i := 0 to NpcList.Count - 1 do begin
    if not PatrolMobOK(i) then continue;
    OID := NpcList(i).OID;
    Old := false;
    for j := 0 to Length(PatrolStartOIDs) - 1 do
      if PatrolStartOIDs[j] = OID then begin Old := true; break; end;
    if Old then continue;
    result := true;
    exit;
  end;
end;

// index of the patrol point farthest from us
function FarthestPatrolPoint(): integer;
var k, n, PX, PY, PZ: integer;
  D, Best: double;
begin
  result := 0;
  Best := -1;
  n := Length(PatrolPoints) div 3;
  for k := 0 to n - 1 do begin
    PX := PatrolPoints[k * 3];
    PY := PatrolPoints[k * 3 + 1];
    PZ := PatrolPoints[k * 3 + 2];
    D := User.DistTo(PX, PY, PZ);
    if D > Best then begin
      Best := D;
      result := k;
    end;
  end;
end;

// Profile mode patrol: we stand still for PatrolIdle seconds with no target and
// nobody hitting us -> run to the FARTHEST patrol point in short steps; as soon
// as the profile takes a target (or a mob attacks) we stop and leave it alone.
procedure Patrol_Thread();
const
  POLL_MS = 250;
var
  StillMs, LastX, LastY, UX, UY, k, TX, TY, TZ: integer;
  Moving: boolean;
  MoveStart: cardinal;
  DX, DY: double;
begin
  StillMs := 0;
  Moving := false;
  LastX := User.X;
  LastY := User.Y;
  while Delay(POLL_MS) do begin
    if (not IsOnline()) or (not OnSpot) or IsRecovering or NeedReturn or TreeBusy or User.Dead or
       ((not Moving) and (BuffID <> 0) and (BuffTime(BuffID) < REBUFF_TIME)) then begin
      StillMs := 0;
      Moving := false;
      PatrolBusy := false;
      continue;
    end;

    // running to a patrol point: the profile is OFF meanwhile (it would hold us back),
    // plain MoveTo like patrol.txt; a live mob near us -> stop and give it back to the profile
    if Moving then begin
      if HaveAgroMobs() or PatrolMobNearby() or
         (User.DistTo(TX, TY, TZ) < PATH_REACHED) or (GetTickCount - MoveStart > 60000) then begin
        Moving := false;
        StillMs := 0;
        PatrolBusy := false;
        if OnSpot and (not User.Dead) and (not NeedReturn) then FarmOn();
        continue;
      end;
      Engine.MoveTo(TX, TY, TZ);
      continue;
    end;

    // standing still?
    UX := User.X;
    UY := User.Y;
    DX := UX - LastX;
    DY := UY - LastY;
    if Sqrt(DX * DX + DY * DY) < 30 then StillMs := StillMs + POLL_MS else StillMs := 0;
    LastX := UX;
    LastY := UY;

    if HasLiveTarget() or HaveAgroMobs() then begin
      StillMs := 0;
      continue;
    end;

    if StillMs >= PatrolIdle * 1000 then begin
      k := FarthestPatrolPoint();
      TX := PatrolPoints[k * 3];
      TY := PatrolPoints[k * 3 + 1];
      TZ := PatrolPoints[k * 3 + 2];
      Engine.Msg('[Patrol]', 'Standing without a target, running to patrol point ' + IntToStr(k + 1), 0);
      PatrolBusy := true;   // rebuff waits, the profile is off while we run
      FarmOff();
      RememberPatrolStartMobs();
      Moving := true;
      MoveStart := GetTickCount;
      StillMs := 0;
    end;
  end;
end;

// ===================== Events: players around, private messages =====================
// Everything is polled from one thread, so spot scripts need no OnAction.
// Every event goes through Alert (see above the death thread).

// ---- players around (SetPlayerAlert) ----

// a player near us (and not from our party / clan) appeared
procedure OnPlayerDetected(Ch: TL2Char);
var Info: string;
begin
  Info := Ch.Name + ' lvl ' + IntToStr(Ch.Level);
  if Ch.Clan <> '' then Info := Info + ' [' + Ch.Clan + ']';
  if Ch.PK or (Ch.Karma > 0) then Info := Info + ' PK';
  Alert('[Player]', Info + ' near me', PlayerSound);
end;

function IsFriendly(Ch: TL2Char): boolean;
var MyClan, ChClan: cardinal;
begin
  result := Ch.IsMember;   // party member
  if result then exit;
  MyClan := User.ClanID;
  ChClan := Ch.ClanID;
  result := (MyClan <> 0) and (ChClan = MyClan);
end;

// ---- private messages (SetPrivateAlert) ----

procedure OnPrivateMessage(Sender, Text: string);
begin
  Alert('[PM]', Sender + ': ' + Text, PrivateSound);
end;

// highest OID of private messages we already know (new ones have a bigger OID)
function LastPrivateOID(): cardinal;
var i: integer;
  M: TChatMessage;
begin
  result := 0;
  for i := 0 to History.Count(mtPrivate) - 1 do begin
    M := History.GetMessage(i, mtPrivate);
    if M.OID > result then result := M.OID;
  end;
end;

// ---- champions (SetChampionAlert): a mob with a lot of HP appeared ----

procedure OnChampionDetected(i: integer);
var MaxHP: integer;
begin
  MaxHP := NpcList(i).MaxHP;
  Alert('[Champion]', NpcList(i).Name + ' (' + IntToStr(MaxHP) + ' HP) spawned in the farm area', DEFAULT_CHAMPION_SOUND);
end;

procedure Events_Thread();
var
  Seen, Cur: array of integer;   // OIDs of players near us: last poll / this poll
  SeenChamp: array of integer;   // OIDs of champions we already reported
  i, j, n, OID, X, Y, Z, MaxHP: integer;
  Known: boolean;
  MaxOID: cardinal;
  M: TChatMessage;
  Me: string;
begin
  SetLength(Seen, 0);
  SetLength(SeenChamp, 0);
  MaxOID := LastPrivateOID();   // old messages are not events

  while Delay(EVENTS_POLL_MS) do begin
    if not IsOnline() then begin
      SetLength(Seen, 0);
      continue;
    end;

    // --- players: alert once when a player comes into range, forget when he leaves ---
    if PlayerAlertRange > 0 then begin
      SetLength(Cur, 0);
      for i := 0 to CharList.Count - 1 do begin
        X := CharList(i).X;
        Y := CharList(i).Y;
        Z := CharList(i).Z;
        if User.DistTo(X, Y, Z) > PlayerAlertRange then continue;
        if IsFriendly(CharList(i)) then continue;

        OID := CharList(i).OID;
        n := Length(Cur);
        SetLength(Cur, n + 1);
        Cur[n] := OID;

        Known := false;
        for j := 0 to Length(Seen) - 1 do
          if Seen[j] = OID then begin Known := true; break; end;
        if not Known then OnPlayerDetected(CharList(i));
      end;
      SetLength(Seen, Length(Cur));
      for i := 0 to Length(Cur) - 1 do Seen[i] := Cur[i];
    end;

    // --- private messages: everything with a new OID, except our own replies ---
    if PrivateAlert then begin
      Me := User.Name;
      for i := 0 to History.Count(mtPrivate) - 1 do begin
        M := History.GetMessage(i, mtPrivate);
        if M.OID <= MaxOID then continue;
        MaxOID := M.OID;
        if M.Sender <> Me then OnPrivateMessage(M.Sender, M.Text);
      end;
    end;

    // --- champions: alive mob with MaxHP above ChampionMinHP, once per mob ---
    if ChampionMinHP > 0 then begin
      SetLength(Cur, 0);
      for i := 0 to NpcList.Count - 1 do begin
        if NpcList(i).Dead then continue;
        MaxHP := NpcList(i).MaxHP;
        if MaxHP <= ChampionMinHP then continue;
        if IsIgnoredNpc(i) then continue;
        // only champions in our farm area: the zone, or (no zone) FREE_RADIUS around the start point
        X := NpcList(i).X;
        Y := NpcList(i).Y;
        Z := NpcList(i).Z;
        if not InFarmArea(X, Y, Z) then continue;

        OID := NpcList(i).OID;
        n := Length(Cur);
        SetLength(Cur, n + 1);
        Cur[n] := OID;

        Known := false;
        for j := 0 to Length(SeenChamp) - 1 do
          if SeenChamp[j] = OID then begin Known := true; break; end;
        if not Known then OnChampionDetected(i);
      end;
      // remember only champions that are still around (dead / gone -> forgotten)
      SetLength(SeenChamp, Length(Cur));
      for i := 0 to Length(Cur) - 1 do SeenChamp[i] := Cur[i];
    end;
  end;
end;

// ===================== Start =====================

// Decides what to do once we are in game (script start or after a relogin):
// in the zone -> farm, dead -> death handler, anywhere else -> via Aden.
procedure StartInGame();
begin
  if not User.Dead then ApplyExpOff();

  if User.Dead then begin
    Engine.Msg('[Init]', 'Character is dead, death handler will take over', 128);
    FarmOff();
  end else if StartFarm(false) then begin
    Engine.Msg('[Init]', 'Already in the farm zone. Farming', 128);
  end else begin
    // in Aden, another town or anywhere else -> standard route via Aden
    Engine.Msg('[Init]', 'Not on the spot. Going via Aden', 128);
    FarmOff();
    NeedReturn := true;
  end;
end;

// ===================== Login thread =====================
// SetLogin only: disconnected -> log in again and start over.

procedure Login_Thread();
begin
  while Delay(5000) do begin
    if IsOnline() then continue;

    // block the other threads while we are out of the game
    IsRecovering := true;
    OnSpot := false;
    NeedReturn := false;
    Engine.Msg('[Login]', 'Disconnected', 128);

    while not DoLogin() do Delay(LOGIN_RETRY_WAIT);

    IsRecovering := false;
    StartInGame();
  end;
end;

// alerts are ON by default: anything the spot script did not set gets the default
procedure ApplyAlertDefaults();
begin
  if not PlayerAlertSet then PlayerAlertRange := DEFAULT_PLAYER_ALERT_RANGE;
  if not PrivateAlertSet then PrivateAlert := true;
  if not PlayerSoundSet then PlayerSound := DEFAULT_PLAYER_SOUND;
  if not PrivateSoundSet then PrivateSound := DEFAULT_PRIVATE_SOUND;
  if not DeathSoundSet then DeathSound := DEFAULT_DEATH_SOUND;
  if not AlertBlinkSet then AlertBlink := true;
  if not ChampionAlertSet then ChampionMinHP := DEFAULT_CHAMPION_HP;
end;

procedure RunFarm();
begin
  Engine.Msg('[Init]', 'Spot farm started, zone ' + ZoneName, 128);
  ApplyAlertDefaults();
  LoadIgnoreNames();
  IsRecovering := false;
  NeedReturn := false;
  OnSpot := false;

  if HasLogin then
    while not DoLogin() do Delay(LOGIN_RETRY_WAIT);
  Delay(1000);

  if StayMode() then begin
    HomeX := User.X;
    HomeY := User.Y;
    HomeZ := User.Z;
    Engine.Msg('[Init]', 'Stay mode (no SetPath / SetTeleport): farming here, never travelling', 128);
  end;

  StartInGame();

  Script.NewThread(@AltB_Rebuff_Thread);
  Script.NewThread(@DeathHandler_Thread);
  if HasLogin then Script.NewThread(@Login_Thread);
  if TreeEnabled then Script.NewThread(@TreeWatch_Thread);
  if AoeEnabled then Script.NewThread(@AoeFarm_Thread);
  if CasterEnabled then begin
    if CasterRange <= 0 then CasterRange := DEFAULT_TARGET_RANGE;
    Script.NewThread(@CasterFarm_Thread);
    if SummonSkill > 0 then Script.NewThread(@SummonWatch_Thread);
  end;
  if HasPatrol() and (not AoeEnabled) and (not CasterEnabled) then Script.NewThread(@Patrol_Thread);
  if (not AoeEnabled) and (not CasterEnabled) then Script.NewThread(@IgnoreWatch_Thread);
  RememberWeapon();   // no SetWeapon -> the weapon in hands right now
  if WeaponID > 0 then Script.NewThread(@WeaponWatch_Thread);
  if (PlayerAlertRange > 0) or PrivateAlert or (ChampionMinHP > 0) then Script.NewThread(@Events_Thread);
  Delay(-1);
end;

end.
