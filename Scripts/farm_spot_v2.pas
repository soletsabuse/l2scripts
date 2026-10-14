unit SpotFarm2;

// farm_spot_v2: the script farms by itself (no interface), standing on one spot.
//
//   uses SpotFarm2 in 'farm_spot_v2.pas';
//   begin
//     SetZone('xxx.zmap');                 // file in Library\Zones; '' = the zone active in the bot,
//                                          //   no zone there -> FREE_RADIUS around the start point
//     SetBuff(1204, ['_bbs_buffer_show', 'book_use?...']);   // watched buff + buff bypasses
//     SetSafePoint(x, y, z);               // where to fight off / buy / summon / buff
//     SetPatrol([x1, y1, z1,  x2, y2, z2]);  // no target -> run these points (does not wait to arrive)
//     SetTargetRange(700);                 // new targets only this close
//     AddCasterSkill(id, SKILL_NUKE, 500, 0);         // our skills, priority order, cast async
//     SetSummon(skillID);                  // summon skill
//     AddPetSkill(action, SKILL_DEBUFF, 8000, 0);     // summon skills = action IDs
//     SetPetAttack(true, 100000);          // summon attack order only on mobs with MaxHP >= N (0 = all)
//     AddSupply(MANA_DRUG, 200, 500);
//     RunFarm();
//   end.
//
// One loop, every TICK_MS:
//   dead -> wait for a resurrection
//   buff running out -> safe point, fight off what is on us, supplies,
//                        dismiss + summon a new summon, buff, back to farm
//   no summon -> summon it right here
//   target: mobs on us / the summon (lowest HP) -> current target -> lowest HP within range
//   fight: skills by priority with DUseSkill (no waiting), summon skills / attack
//   nothing to fight -> patrol: DMoveTo the next point, keep looking for targets on the way

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
  SKILL_NUKE    = 1;   // damage: every IntervalMs
  SKILL_DEBUFF  = 2;   // once per mob, again on the same mob only after IntervalMs
  SKILL_DRAIN   = 3;   // only when HP % < Param (our HP for AddCasterSkill, summon HP for AddPetSkill)

procedure SetZone(Name: string);
procedure SetConfig(Name: string);
procedure SetBuff(WatchBuffID: integer; Bypasses: array of string);
procedure SetSafePoint(X, Y, Z: integer);
procedure SetPatrol(Points: array of integer);
procedure SetTargetRange(Range: integer);
procedure SetMobs(MobIDs: array of integer);
procedure AddCasterSkill(SkillID, Kind, IntervalMs, Param: integer);
procedure SetSummon(SummonSkillID: integer);
procedure AddPetSkill(ActionID, Kind, IntervalMs, Param: integer);
procedure SetPetAttack(Enabled: boolean; MinMobMaxHP: integer);
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
  SUMMON_RETRY_MS   = 8000;     // no summon in the fight -> try again not more often than this

  PATH_REACHED      = 150;      // "I am at the point"
  PATROL_REISSUE_MS = 1500;     // patrol: repeat DMoveTo every N ms while running to the point
  SERVICE_FIGHT_MS  = 180000;   // safe point: at most this long fighting off mobs

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
  BuffBypasses: array of string;
  HasSafePoint: boolean;
  SafeX, SafeY, SafeZ: integer;
  PatrolPoints: array of integer;
  TargetRange: integer;
  MobList: array of integer;
  SummonSkill: integer;
  PetAttackOn: boolean;
  PetAttackMinHP: integer;
  SupplyItems, SupplyMin, SupplyMax: array of integer;

  // skills: owner 0 = us (AddCasterSkill), 1 = summon (AddPetSkill), in priority order
  SkOwner, SkID, SkKind, SkInterval, SkParam: array of integer;
  SkLast: array of cardinal;

// ===================== State =====================
  UseRadius: boolean;             // no zone: farm area = FREE_RADIUS around Home
  HomeX, HomeY, HomeZ: integer;
  CurTarget: integer;             // OID we attack now
  LastPetAttack, LastPetSkill, LastSummonTry: cardinal;
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

procedure SetSummon(SummonSkillID: integer);
begin
  SummonSkill := SummonSkillID;
end;

procedure AddPetSkill(ActionID, Kind, IntervalMs, Param: integer);
begin
  AddSkill(1, ActionID, Kind, IntervalMs, Param);
end;

procedure SetPetAttack(Enabled: boolean; MinMobMaxHP: integer);
begin
  PetAttackOn := Enabled;
  PetAttackMinHP := MinMobMaxHP;
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

// zone file / active zone / radius; optional interface config (the interface stays OFF)
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

procedure BuffAltB();
var i: integer;
begin
  for i := 0 to Length(BuffBypasses) - 1 do
    if Engine.BypassToServer(BuffBypasses[i]) then Delay(555);
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
  LastSummonTry := GetTickCount;
end;

// ===================== Skills by priority =====================

function HasSkills(Owner: integer): boolean;
var k: integer;
begin
  result := false;
  for k := 0 to Length(SkID) - 1 do
    if SkOwner[k] = Owner then begin result := true; exit; end;
end;

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

// first skill of this owner that may be used now; ours are cast with DUseSkill (no waiting)
function UseNextSkill(Owner, OID: integer): boolean;
var k: integer;
begin
  result := false;
  for k := 0 to Length(SkID) - 1 do begin
    if SkOwner[k] <> Owner then continue;
    if not SkillReady(k, OID) then continue;
    if Owner = 0 then
      Engine.DUseSkill(SkID[k], false, false)
    else
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

// current target alive and (in the farm area or close)
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

// ===================== Fight =====================

// one step on the target: retarget, summon attack / skill, our next skill (async)
procedure FightStep(OID: integer);
begin
  if OID <> CurTarget then begin
    Engine.SetTarget(OID);
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
      if UseNextSkill(1, OID) then LastPetSkill := GetTickCount;
  end;

  if not UseNextSkill(0, OID) then
    if not HasSkills(0) then Engine.Attack(300);   // no skills at all: plain attack
end;

// ===================== Patrol (does not wait to arrive) =====================

// nothing to fight: run to the current patrol point with DMoveTo, next point when there
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
    PatrolIdx := (PatrolIdx + 1) mod n;   // there -> next point
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

// ===================== Safe point service =====================

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

// kill everything on us / the summon, then wait until we are out of combat
procedure KillAggro();
var OID: integer;
  Started, Calm: cardinal;
begin
  Started := GetTickCount;
  Calm := 0;
  while (not User.Dead) and (GetTickCount - Started < SERVICE_FIGHT_MS) do begin
    OID := PickAggro();
    if OID <> 0 then begin
      Calm := 0;
      FightStep(OID);
      Delay(TICK_MS);
      continue;
    end;
    if not User.InCombat then exit;
    if Calm = 0 then Calm := GetTickCount;
    if GetTickCount - Calm > 20000 then exit;   // nobody on us for 20 sec: good enough
    Delay(300);
  end;
end;

// safe point -> fight off -> supplies -> dismiss + new summon -> buff
procedure Service();
var Tries: integer;
begin
  Engine.Msg('[Safe]', '=== Buff is low: safe point, fight off, supplies, summon, buff ===', 128);
  CurTarget := 0;
  PatrolActive := false;

  GoToSafePoint();
  if User.Dead then exit;

  KillAggro();
  if User.Dead then exit;

  BuySupplies();
  if User.Dead then exit;

  if SummonSkill > 0 then begin
    if HaveSummon() then begin
      Engine.Msg('[Safe]', 'Dismissing the summon', 0);
      Engine.DismissSum;
      Delay(2000);
    end;
    Summon();
  end;
  if User.Dead then exit;

  Tries := 0;
  repeat
    BuffAltB();
    Delay(2000);
    Inc(Tries);
  until (not BuffLow()) or (Tries >= 5) or User.Dead;
  if BuffLow() then
    Engine.Msg('[Safe]', 'Buff NOT received, next try in a minute', 128)
  else
    Engine.Msg('[Safe]', 'Buff received, back to farm', 128);
end;

// ===================== Main loop =====================

procedure RunFarm();
var OID: integer;
  LastServiceTry: cardinal;
begin
  Engine.Msg('[Init]', 'farm_spot_v2 started', 128);
  Engine.FaceControl(0, false);   // the script farms, the interface stays OFF
  LoadIgnoreNames();
  if TargetRange <= 0 then TargetRange := DEFAULT_TARGET_RANGE;
  LoadArea();
  CurTarget := 0;
  PatrolIdx := 0;
  LastServiceTry := 0;

  BuySupplies();
  if (SummonSkill > 0) and (not HaveSummon()) then Summon();

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

    // buff running out -> safe point service (not more often than once a minute if it fails)
    if BuffLow() and (GetTickCount - LastServiceTry >= 60000) then begin
      LastServiceTry := GetTickCount;
      Service();
      continue;
    end;

    // summon died / is missing -> summon it right here
    if (SummonSkill > 0) and (not HaveSummon()) and (GetTickCount - LastSummonTry >= SUMMON_RETRY_MS) then begin
      Summon();
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
