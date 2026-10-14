unit SpotFarm3;

// farm_spot_v3: the INTERFACE fights (attack + skills from the profile), the script
// only picks targets, drives the summon, spams HP drain skills, rebuffs, summons, buys.
// The profile must be in MANUAL target mode (MTarget="true" in its config): it never
// picks targets itself and stays ON all the time.
//
//   uses SpotFarm3 in 'farm_spot_v3.pas';
//   begin
//     SetZone('xxx.zmap');                 // Library\Zones; '' = the zone active in the bot,
//                                          //   no zone there -> FREE_RADIUS around the start point
//     SetConfig('xxx.xml');                // Library\Configurations ('' = keep the current one)
//     SetBuff(1204, ['_bbs_buffer_show', 'book_use?...target=Player']);   // our buff
//     SetSummonBuff(['book_use?...']);     // summon buff bypasses (sent right after ours)
//     SetSafePoint(x, y, z);               // where to summon / buff (after the aggro is dead)
//     SetPatrol([x1, y1, z1,  x2, y2, z2]);  // no target -> run these points (does not wait)
//     SetTargetRange(700);                 // new targets only this close
//     SetSummon(skillID, 10);              // summon skill; summon time left (Fed %) < 10 -> new one
//     AddPetSkill(action, SKILL_DEBUFF, 8000, 0);     // summon skills = action IDs
//     SetPetAttack(true, 100000);          // summon attack order only on mobs with MaxHP >= N (0 = all)
//     AddDrainSkill(1234, 70);             // our HP < 70 % -> spam it until its reuse starts
//     AddSupply(MANA_DRUG, 200, 500);
//     RunFarm();
//   end.
//
// One loop, every TICK_MS:
//   dead -> wait for a resurrection
//   buff low / no summon / summon time low -> SERVICE:
//     kill the mobs on us (we target, the profile hits) -> safe point ->
//     dismiss the old summon if needed + summon a new one -> our buff + summon buff -> supplies
//   target: mobs on us / the summon (lowest HP) -> current target -> lowest HP within range
//   summon: attack order (MaxHP rule) + its skills; drain skills when our HP is low
//   nothing to fight -> patrol: DMoveTo the next point, targets are searched on the way

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

// ===================== Skill kinds for AddPetSkill =====================
  SKILL_NUKE    = 1;   // damage: every IntervalMs
  SKILL_DEBUFF  = 2;   // once per mob, again on the same mob only after IntervalMs
  SKILL_DRAIN   = 3;   // only when summon HP % < Param

procedure SetZone(Name: string);
procedure SetConfig(Name: string);
procedure SetBuff(WatchBuffID: integer; Bypasses: array of string);
procedure SetSummonBuff(Bypasses: array of string);
procedure SetSafePoint(X, Y, Z: integer);
procedure SetPatrol(Points: array of integer);
procedure SetTargetRange(Range: integer);
procedure SetMobs(MobIDs: array of integer);
procedure SetSummon(SummonSkillID, RenewPercent: integer);
procedure AddPetSkill(ActionID, Kind, IntervalMs, Param: integer);
procedure SetPetAttack(Enabled: boolean; MinMobMaxHP: integer);
procedure AddDrainSkill(SkillID, HPPercent: integer);
procedure AddSupply(ItemID: integer; MinCount, MaxCount: integer);
procedure RunFarm();

implementation

// ===================== Library constants =====================
const
  TICK_MS           = 100;      // main loop step
  REBUFF_TIME       = 600000;   // rebuff when the watched buff has less than this (ms)
  ZONE_DIR          = '..\Zones\';            // relative to Library\Scripts (Script.Path)
  CONFIG_DIR        = '..\Configurations\';
  FREE_RADIUS       = 900;      // SetZone('') and no zone in the bot: farm this close to the start point
  DEFAULT_TARGET_RANGE = 700;   // new targets only this close (SetTargetRange)
  AGGRO_MAX_RANGE   = 1000;     // mobs on us / the summon are targeted only this close

  PET_ATTACK_ACTION = 22;       // RequestActionUse: summon attacks the target
  PET_ATTACK_MS     = 2000;     // repeat the attack order every N ms
  PET_SKILL_GAP     = 1000;     // at least N ms between two summon skills
  RESUMMON_WAIT     = 5000;     // ms to wait after casting the summon skill
  SUMMON_TRIES      = 3;        // summon attempts in a row

  PATH_REACHED      = 150;      // "I am at the point"
  PATROL_REISSUE_MS = 1500;     // patrol: repeat DMoveTo every N ms while running to the point
  SERVICE_FIGHT_MS  = 180000;   // service: at most this long fighting off mobs
  SERVICE_RETRY_MS  = 20000;    // service did not fix it -> next try not earlier than this

  INVENTORY_PACKET  = '14';     // RequestItemList: server resends the inventory
  ADENA_ID          = 57;
  BUY_WAIT          = 4000;     // ms after each purchase before refreshing the inventory
  SHOP_OPEN         = 'PremShopList';
  MULTISELL_ID      = 7300;
  MULTISELL_OPEN    = '_bbs_multisell?id=7300';

// ===================== Settings (filled by the spot script) =====================
var
  ZoneName, ConfigName: string;
  BuffID: integer;
  BuffBypasses, SummonBuffBypasses: array of string;
  HasSafePoint: boolean;
  SafeX, SafeY, SafeZ: integer;
  PatrolPoints: array of integer;
  TargetRange: integer;
  MobList: array of integer;
  SummonSkill, SummonRenewPct: integer;
  PetAttackOn: boolean;
  PetAttackMinHP: integer;
  DrainID, DrainHP: array of integer;   // AddDrainSkill
  SupplyItems, SupplyMin, SupplyMax: array of integer;

  // summon skills (AddPetSkill), in priority order
  SkID, SkKind, SkInterval, SkParam: array of integer;
  SkLast: array of cardinal;

// ===================== State =====================
  UseRadius: boolean;
  HomeX, HomeY, HomeZ: integer;
  CurTarget: integer;             // OID we target now (the profile attacks it)
  LastPetAttack, LastPetSkill: cardinal;
  PatrolIdx: integer;
  PatrolActive: boolean;
  LastPatrolMove: cardinal;
  IgnoreNames: array of string;
  DebuffSk: array[0..63] of integer;
  DebuffOID: array[0..63] of integer;
  DebuffTime: array[0..63] of cardinal;
  DebuffHead: integer;

// ===================== Setters =====================

procedure SetZone(Name: string);
begin
  ZoneName := Name;
end;

procedure SetConfig(Name: string);
begin
  ConfigName := Name;
end;

procedure SetBuff(WatchBuffID: integer; Bypasses: array of string);
var i: integer;
begin
  BuffID := WatchBuffID;
  SetLength(BuffBypasses, Length(Bypasses));
  for i := 0 to Length(Bypasses) - 1 do BuffBypasses[i] := Bypasses[i];
end;

procedure SetSummonBuff(Bypasses: array of string);
var i: integer;
begin
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

procedure SetPatrol(Points: array of integer);
var i: integer;
begin
  SetLength(PatrolPoints, Length(Points));
  for i := 0 to Length(Points) - 1 do PatrolPoints[i] := Points[i];
end;

procedure SetTargetRange(Range: integer);
begin
  TargetRange := Range;
end;

procedure SetMobs(MobIDs: array of integer);
var i: integer;
begin
  SetLength(MobList, 0);
  for i := 0 to Length(MobIDs) - 1 do
    if MobIDs[i] > 0 then begin     // [0] = any mob
      SetLength(MobList, Length(MobList) + 1);
      MobList[Length(MobList) - 1] := MobIDs[i];
    end;
end;

procedure SetSummon(SummonSkillID, RenewPercent: integer);
begin
  SummonSkill := SummonSkillID;
  SummonRenewPct := RenewPercent;
end;

procedure AddPetSkill(ActionID, Kind, IntervalMs, Param: integer);
var n: integer;
begin
  n := Length(SkID);
  SetLength(SkID, n + 1);
  SetLength(SkKind, n + 1);
  SetLength(SkInterval, n + 1);
  SetLength(SkParam, n + 1);
  SetLength(SkLast, n + 1);
  SkID[n] := ActionID;
  SkKind[n] := Kind;
  SkInterval[n] := IntervalMs;
  SkParam[n] := Param;
  SkLast[n] := 0;
end;

procedure SetPetAttack(Enabled: boolean; MinMobMaxHP: integer);
begin
  PetAttackOn := Enabled;
  PetAttackMinHP := MinMobMaxHP;
end;

procedure AddDrainSkill(SkillID, HPPercent: integer);
var n: integer;
begin
  n := Length(DrainID);
  SetLength(DrainID, n + 1);
  SetLength(DrainHP, n + 1);
  DrainID[n] := SkillID;
  DrainHP[n] := HPPercent;
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

// ===================== Ignored NPCs (never targeted) =====================

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

// on the ignore list, or one of OUR pets / summons
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

// ===================== Farm area =====================

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

procedure LoadArea();
var UX, UY, UZ: integer;
begin
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  HomeX := UX;
  HomeY := UY;
  HomeZ := UZ;

  if ConfigName <> '' then begin
    Engine.Msg('[Init]', 'LoadConfig: ' + ConfigName, 0);
    Engine.LoadConfig(Script.Path + CONFIG_DIR + ConfigName);
    Delay(1000);
  end;

  if ZoneName <> '' then begin
    Engine.Msg('[Init]', 'LoadZone: ' + ZoneName, 0);
    Engine.ClearZone;
    Engine.LoadZone(Script.Path + ZONE_DIR + ZoneName);
    Delay(500);
    UseRadius := false;
  end else begin
    UseRadius := not Engine.InZone(UX, UY, UZ);
    if UseRadius then
      Engine.Msg('[Init]', 'No zone in the bot: farming within ' + IntToStr(FREE_RADIUS) + ' of the start point', 128)
    else
      Engine.Msg('[Init]', 'Using the zone that is active in the bot', 128);
  end;
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

function HexLE32(Value: integer): string;
begin
  result := IntToHex(Value and $FF, 2) +
            IntToHex((Value shr 8) and $FF, 2) +
            IntToHex((Value shr 16) and $FF, 2) +
            IntToHex((Value shr 24) and $FF, 2);
end;

procedure OpenShop();
begin
  Engine.BypassToServer(SHOP_OPEN);
  Delay(1000);
  Engine.BypassToServer(MULTISELL_OPEN);
  Delay(1500);
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
  Delay(1500);
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

// every AddSupply line: less than Min -> buy up to Max (as much as adena allows)
procedure BuySupplies();
var
  i, ItemID, EntryID, Price: integer;
  Have, After, Adena, Need, CanPay: Int64;
  Name: string;
begin
  for i := 0 to Length(SupplyItems) - 1 do begin
    if User.Dead then exit;
    ItemID := SupplyItems[i];
    if not SupplyCatalog(ItemID, EntryID, Price, Name) then begin
      Engine.Msg('[Supplies]', 'Unknown item ID ' + IntToStr(ItemID), 128);
      continue;
    end;

    RefreshInventory();
    Have := ItemCount(ItemID);
    if Have >= SupplyMin[i] then begin
      Engine.Msg('[Supplies]', Name + ': ' + IntToStr(Have) + ' - ok', 0);
      continue;
    end;

    Need := SupplyMax[i] - Have;
    Adena := ItemCount(ADENA_ID);
    CanPay := Adena div Price;
    if Need > CanPay then Need := CanPay;
    if Need <= 0 then begin
      Engine.Msg('[Supplies]', Name + ': not enough adena', 128);
      continue;
    end;

    Engine.Msg('[Supplies]', Name + ': ' + IntToStr(Have) + ' -> buying ' + IntToStr(Need), 128);
    OpenShop();   // before every purchase
    MultisellBuy(EntryID, Need);
    Delay(BUY_WAIT);

    RefreshInventory();
    After := ItemCount(ItemID);
    if After > Have then
      Engine.Msg('[Supplies]', Name + ': now ' + IntToStr(After), 128)
    else
      Engine.Msg('[Supplies]', Name + ': purchase NOT confirmed', 128);
  end;
end;

// ===================== Buff =====================

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

function BuffLow(): boolean;
begin
  result := (BuffID <> 0) and (BuffTime(BuffID) < REBUFF_TIME);
end;

// our buff bypasses, then the summon buff bypasses (if the summon is out)
procedure SendBuffs();
var i: integer;
begin
  for i := 0 to Length(BuffBypasses) - 1 do
    if Engine.BypassToServer(BuffBypasses[i]) then Delay(555);
  if (PetList.Count > 0) and (not PetList(0).Dead) then
    for i := 0 to Length(SummonBuffBypasses) - 1 do
      if Engine.BypassToServer(SummonBuffBypasses[i]) then Delay(555);
end;

// ===================== Our skill reuse (SkillList, EndTime = reload time left) =====================

// skill is reloading (or disabled) right now; unknown skill -> false
function SkillOnCooldown(ID: integer): boolean;
var i, SID: integer;
  Left: cardinal;
begin
  result := false;
  for i := 0 to SkillList.Count - 1 do begin
    SID := SkillList(i).ID;
    if SID = ID then begin
      Left := SkillList(i).EndTime;
      result := (Left > 0) or SkillList(i).Disabled;
      exit;
    end;
  end;
end;

// our HP below the skill's % -> spam it (no waiting) while it is NOT reloading;
// once its reuse starts we stop and use it again only after the reuse is over
procedure DrainTick();
var k: integer;
begin
  if CurTarget = 0 then exit;
  for k := 0 to Length(DrainID) - 1 do begin
    if User.HP >= DrainHP[k] then continue;
    if SkillOnCooldown(DrainID[k]) then continue;
    Engine.DUseSkill(DrainID[k], false, false);
    exit;   // one per tick, the first one in the list wins
  end;
end;

// ===================== Summon =====================

// RequestActionUse (56): action ID, ctrl, shift
procedure PetAction(ActionID: integer);
begin
  Engine.SendToServer('56' + HexLE32(ActionID) + '00000000' + '00');
end;

function HaveSummon(): boolean;
begin
  result := (PetList.Count > 0) and (not PetList(0).Dead);
end;

// summon time left (Fed %) is below SetSummon renew %
function SummonTimeLow(): boolean;
var Fed: integer;
begin
  result := false;
  if (SummonRenewPct <= 0) or (not HaveSummon()) then exit;
  Fed := PetList(0).Fed;
  result := Fed < SummonRenewPct;
end;

// the summon needs a renew: none / dead / time running out
function SummonNeeded(): boolean;
begin
  result := (SummonSkill > 0) and ((not HaveSummon()) or SummonTimeLow());
end;

// cast the summon skill until the summon is out (SUMMON_TRIES)
procedure Summon();
var Tries: integer;
begin
  if SummonSkill <= 0 then exit;
  Tries := 0;
  while (not HaveSummon()) and (Tries < SUMMON_TRIES) and (not User.Dead) do begin
    Inc(Tries);
    Engine.Msg('[Summon]', 'Summoning (try ' + IntToStr(Tries) + ')', 128);
    Engine.UseSkill(SummonSkill);
    Delay(RESUMMON_WAIT);
  end;
end;

// ---- summon skills by priority (AddPetSkill) ----

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

function PetSkillReady(k, OID: integer): boolean;
var Since: cardinal;
begin
  Since := GetTickCount - SkLast[k];
  if SkKind[k] = SKILL_DEBUFF then
    result := (Since >= 1000) and (DebuffAge(k, OID) >= cardinal(SkInterval[k]))
  else if SkKind[k] = SKILL_DRAIN then
    result := HaveSummon() and (PetList(0).HP < SkParam[k]) and (Since >= cardinal(SkInterval[k]))
  else
    result := Since >= cardinal(SkInterval[k]);
end;

function UsePetSkill(OID: integer): boolean;
var k: integer;
begin
  result := false;
  for k := 0 to Length(SkID) - 1 do begin
    if not PetSkillReady(k, OID) then continue;
    PetAction(SkID[k]);
    SkLast[k] := GetTickCount;
    if SkKind[k] = SKILL_DEBUFF then MarkDebuff(k, OID);
    result := true;
    exit;
  end;
end;

// ===================== Targets =====================

function MobWanted(i: integer): boolean;
var j, ID: integer;
begin
  result := Length(MobList) = 0;
  if result then exit;
  ID := NpcList(i).ID;
  for j := 0 to Length(MobList) - 1 do
    if ID = MobList[j] then begin result := true; exit; end;
end;

// alive mob that attacks us or the summon and is close
function IsOnUs(i: integer): boolean;
var NX, NY, NZ, Atk, PetOID: integer;
begin
  result := false;
  if NpcList(i).Dead then exit;
  if IsIgnoredNpc(i) then exit;
  Atk := NpcList(i).AtkOID;
  if Atk <> User.OID then begin
    if not HaveSummon() then exit;
    PetOID := PetList(0).OID;
    if Atk <> PetOID then exit;
  end;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  result := User.DistTo(NX, NY, NZ) <= AGGRO_MAX_RANGE;
end;

function OnUsOID(OID: integer): boolean;
var i: integer;
begin
  result := false;
  if OID = 0 then exit;
  for i := 0 to NpcList.Count - 1 do
    if NpcList(i).OID = OID then begin
      result := IsOnUs(i);
      exit;
    end;
end;

// lowest absolute HP among the mobs on us; 0 = nobody
function PickAggro(): integer;
var i, HP, BestHP, NX, NY, NZ: integer;
  D, BestD: double;
begin
  result := 0;
  BestHP := MaxInt;
  BestD := 999999;
  for i := 0 to NpcList.Count - 1 do begin
    if not IsOnUs(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    D := User.DistTo(NX, NY, NZ);
    HP := NpcList(i).CurHP;
    if (HP < BestHP) or ((HP = BestHP) and (D < BestD)) then begin
      BestHP := HP;
      BestD := D;
      result := NpcList(i).OID;
    end;
  end;
end;

// new mob: lowest absolute HP within TargetRange, inside the farm area; 0 = nothing
function PickNewMob(): integer;
var i, HP, BestHP, NX, NY, NZ: integer;
  D, BestD: double;
begin
  result := 0;
  BestHP := MaxInt;
  BestD := 999999;
  for i := 0 to NpcList.Count - 1 do begin
    if NpcList(i).Dead then continue;
    if IsIgnoredNpc(i) then continue;
    if not MobWanted(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    D := User.DistTo(NX, NY, NZ);
    if D > TargetRange then continue;
    if not InFarmArea(NX, NY, NZ) then continue;
    HP := NpcList(i).CurHP;
    if (HP < BestHP) or ((HP = BestHP) and (D < BestD)) then begin
      BestHP := HP;
      BestD := D;
      result := NpcList(i).OID;
    end;
  end;
end;

function CurTargetAlive(): boolean;
var i, NX, NY, NZ: integer;
begin
  result := false;
  if CurTarget = 0 then exit;
  for i := 0 to NpcList.Count - 1 do
    if NpcList(i).OID = CurTarget then begin
      if NpcList(i).Dead then exit;
      NX := NpcList(i).X;
      NY := NpcList(i).Y;
      NZ := NpcList(i).Z;
      result := InFarmArea(NX, NY, NZ) or (User.DistTo(NX, NY, NZ) <= TargetRange);
      exit;
    end;
end;

// mobs on us (lowest HP) -> current target -> new lowest-HP mob within range
function ChooseTarget(): integer;
begin
  result := PickAggro();
  if result <> 0 then exit;
  if CurTargetAlive() then begin
    result := CurTarget;
    exit;
  end;
  result := PickNewMob();
end;

function MobMaxHP(OID: integer): integer;
var i: integer;
begin
  result := 0;
  for i := 0 to NpcList.Count - 1 do
    if NpcList(i).OID = OID then begin
      result := NpcList(i).MaxHP;
      exit;
    end;
end;

// ===================== Fight: we target, the profile hits, we drive the summon =====================

procedure FightStep(OID: integer);
begin
  if OID <> CurTarget then begin
    Engine.SetTarget(OID);    // the profile (manual target mode) attacks the current target
    CurTarget := OID;
    LastPetAttack := 0;
  end;

  if HaveSummon() then begin
    if PetAttackOn and (MobMaxHP(OID) >= PetAttackMinHP) and
       (GetTickCount - LastPetAttack >= PET_ATTACK_MS) then begin
      PetAction(PET_ATTACK_ACTION);
      LastPetAttack := GetTickCount;
    end;
    if GetTickCount - LastPetSkill >= PET_SKILL_GAP then
      if UsePetSkill(OID) then LastPetSkill := GetTickCount;
  end;

  DrainTick();
end;

// ===================== Patrol (does not wait to arrive) =====================

procedure PatrolTick();
var n, TX, TY, TZ: integer;
begin
  n := Length(PatrolPoints) div 3;
  if n = 0 then exit;
  if PatrolIdx >= n then PatrolIdx := 0;
  TX := PatrolPoints[PatrolIdx * 3];
  TY := PatrolPoints[PatrolIdx * 3 + 1];
  TZ := PatrolPoints[PatrolIdx * 3 + 2];

  if User.DistTo(TX, TY, TZ) < PATH_REACHED then begin
    PatrolIdx := (PatrolIdx + 1) mod n;
    PatrolActive := false;
    exit;
  end;

  if (not PatrolActive) or (GetTickCount - LastPatrolMove >= PATROL_REISSUE_MS) then begin
    if not PatrolActive then
      Engine.Msg('[Patrol]', 'No targets, running to point ' + IntToStr(PatrolIdx + 1) + '/' + IntToStr(n), 0);
    Engine.DMoveTo(TX, TY, TZ);
    PatrolActive := true;
    LastPatrolMove := GetTickCount;
  end;
end;

// ===================== Service =====================

// kill everything on us / the summon (we keep ONE target until it dies, the profile
// hits it), then wait until we are out of combat
procedure KillAggro();
var Started, Calm: cardinal;
begin
  Started := GetTickCount;
  Calm := 0;
  while (not User.Dead) and (GetTickCount - Started < SERVICE_FIGHT_MS) do begin
    if not OnUsOID(CurTarget) then CurTarget := 0;
    if CurTarget = 0 then begin
      CurTarget := PickAggro();
      if CurTarget <> 0 then Engine.SetTarget(CurTarget);
    end;
    if CurTarget <> 0 then begin
      Calm := 0;
      if HaveSummon() and (GetTickCount - LastPetSkill >= PET_SKILL_GAP) then
        if UsePetSkill(CurTarget) then LastPetSkill := GetTickCount;
      DrainTick();
      Delay(TICK_MS);
      continue;
    end;
    if not User.InCombat then exit;
    if Calm = 0 then Calm := GetTickCount;
    if GetTickCount - Calm > 20000 then exit;   // nobody on us for 20 sec: good enough
    Delay(300);
  end;
end;

procedure GoToSafePoint();
var Started: cardinal;
begin
  if not HasSafePoint then exit;
  Engine.Msg('[Safe]', 'Going to the safe point', 0);
  Started := GetTickCount;
  while (User.DistTo(SafeX, SafeY, SafeZ) > PATH_REACHED) and (GetTickCount - Started < 60000) do begin
    if User.Dead then exit;
    Engine.MoveTo(SafeX, SafeY, SafeZ);
  end;
end;

// kill the aggro -> safe point -> (dismiss) + new summon -> our buff + summon buff -> supplies
procedure Service(Reason: string);
var Tries: integer;
begin
  Engine.Msg('[Service]', '=== ' + Reason + ': fight off, safe point, summon, buff ===', 128);
  PatrolActive := false;

  // 1) kill whatever is on us
  KillAggro();
  if User.Dead then exit;

  // 2) safe point (mobs that followed us are killed there)
  CurTarget := 0;
  Engine.CancelTarget;
  GoToSafePoint();
  if User.Dead then exit;
  KillAggro();
  if User.Dead then exit;

  // 3) summon: dismiss the old one only if it is still there (its time is running out)
  if SummonSkill > 0 then begin
    if HaveSummon() and SummonTimeLow() then begin
      Engine.Msg('[Service]', 'Dismissing the old summon', 0);
      Engine.DismissSum;
      Delay(2000);
    end;
    Summon();
  end;
  if User.Dead then exit;

  // 4) buff: ours + the summon's
  if BuffID <> 0 then begin
    Tries := 0;
    repeat
      SendBuffs();
      Delay(2000);
      Inc(Tries);
    until (not BuffLow()) or (Tries >= 5) or User.Dead;
    if BuffLow() then
      Engine.Msg('[Service]', 'Buff NOT received', 128)
    else
      Engine.Msg('[Service]', 'Buff received', 128);
  end;
  if User.Dead then exit;

  // 5) supplies
  BuySupplies();
  Engine.Msg('[Service]', 'Done, back to farm', 128);
end;

// ===================== Main loop =====================

procedure RunFarm();
var OID: integer;
  LastService: cardinal;
  Reason: string;
begin
  Engine.Msg('[Init]', 'farm_spot_v3 started (profile must be in MANUAL target mode)', 128);
  LoadIgnoreNames();
  if TargetRange <= 0 then TargetRange := DEFAULT_TARGET_RANGE;
  LoadArea();
  Engine.FaceControl(0, true);   // the profile fights; it never picks targets itself
  CurTarget := 0;
  PatrolIdx := 0;
  LastService := 0;

  while Delay(TICK_MS) do begin
    // dead: no travelling, wait for a resurrection
    if User.Dead then begin
      Engine.Msg('[Death]', 'Character died, waiting for a resurrection', 128);
      CurTarget := 0;
      PatrolActive := false;
      while User.Dead do Delay(1000);
      Delay(3000);
      continue;
    end;

    // buff / summon checks -> service (failed -> next try after SERVICE_RETRY_MS)
    Reason := '';
    if BuffLow() then Reason := 'Buff is low'
    else if (SummonSkill > 0) and (not HaveSummon()) then Reason := 'No summon'
    else if SummonTimeLow() then Reason := 'Summon time is running out';
    if (Reason <> '') and ((LastService = 0) or (GetTickCount - LastService >= SERVICE_RETRY_MS)) then begin
      LastService := GetTickCount;
      Service(Reason);
      continue;
    end;

    OID := ChooseTarget();
    if OID <> 0 then begin
      PatrolActive := false;
      FightStep(OID);
    end else begin
      CurTarget := 0;
      PatrolTick();
    end;
  end;
end;

end.
