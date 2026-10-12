unit SpotFarm;

// Common farm logic for every spot. A spot script only feeds data:
//
//   uses SpotFarm in 'spot_farm.pas';
//   begin
//     SetZone('xxx.zmap');                 // file in Library\Zones
//     SetConfig('xxx.xml');                // file in Library\Configurations ('' = do not load)
//     SetTeleport('_bbs_teleport?...');    // Aden gatekeeper -> spot bypass
//     SetBuff(1204, ['_bbs_buffer_show', 'book_use?...']);  // watched buff ID + buff bypasses in order
//     SetPath([x1, y1, z1,  x2, y2, z2]);  // teleport landing -> inside the zone
//     SetSafePoint(x, y, z);               // optional: where to stand while rebuffing on the spot
//     SetExpOff(true);                     // optional: turn XP gain off (exp?state=off)
//     SetLogin('login', 'password');       // optional: log in at start and after a disconnect
//     SetTreeMobs(bow, melee, 600);        // optional: shoot mobs the profile cannot reach (bow/melee item IDs)
//     -- alerts are ON by default, these lines only change them --
//     SetPlayerAlert(2000);                // player (not party/clan) closer than N; 0 = off
//     SetPrivateAlert(true);               // private messages; false = off
//     SetPlayerSound('player.wav');        // file in Library\Sounds; '' = no sound
//     SetPrivateSound('private.wav');      // file in Library\Sounds; '' = no sound
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

procedure SetZone(Name: string);
procedure SetConfig(Name: string);
procedure SetTeleport(Bypass: string);
procedure SetBuff(WatchBuffID: integer; Bypasses: array of string);
procedure SetPath(Points: array of integer);
procedure SetSafePoint(X, Y, Z: integer);
procedure SetExpOff(Enabled: boolean);
procedure SetTreeMobs(BowID, MeleeID, BowRange: integer);
procedure SetLogin(Login, Password: string);
procedure SetPlayerAlert(Range: integer);
procedure SetPrivateAlert(Enabled: boolean);
procedure SetPlayerSound(FileName: string);
procedure SetPrivateSound(FileName: string);
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
  EQUIP_TRIES       = 5;        // UseItem attempts until the weapon is really on
  WEAPON_CHECK_MS   = 5000;     // while farming: check every N ms that the melee weapon is on
  PATH_STEP         = 1500;     // long path segments are split into pieces of this length
  PATH_POINT_TIMEOUT = 60;      // seconds to reach one path point (MoveTo is repeated until then)
  PATH_REACHED      = 150;      // "I am at the point"
  SOUND_DIR         = '..\Sounds\';   // relative to Library\Scripts (Script.Path)
  DEFAULT_PLAYER_ALERT_RANGE = 2000;  // alerts are ON unless the spot script changes them
  DEFAULT_PLAYER_SOUND  = 'player.wav';
  DEFAULT_PRIVATE_SOUND = 'private.wav';
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

// ===================== Events (players around, private messages) =====================
// Defaults (ON) are applied in RunFarm for everything the spot script did not set.
  PlayerAlertRange: integer;      // SetPlayerAlert: 0 = off
  PrivateAlert: boolean;          // SetPrivateAlert
  PlayerSound: string;            // SetPlayerSound: file in Library\Sounds, '' = no sound
  PrivateSound: string;           // SetPrivateSound: file in Library\Sounds, '' = no sound
  TelegramKey: string;            // SetTelegram: '' = no telegram
  AlertBlink: boolean;            // SetAlertBlink: blink the game window in the taskbar
  PlayerAlertSet, PrivateAlertSet, PlayerSoundSet, PrivateSoundSet, AlertBlinkSet: boolean;

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
  i, ID, Cnt: integer;
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
  ShopOpened: boolean;
  Name: string;
begin
  if Length(SupplyItems) = 0 then exit;
  ShopOpened := false;

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
    if not ShopOpened then begin
      OpenShop();
      ShopOpened := true;
    end;
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

// Fights off everything that attacks us and leaves combat.
// Farm is turned OFF only when nobody hits us; if a mob appears again, farm goes back ON.
function ClearCombat(): boolean;
var Rounds, Wait: integer;
begin
  result := false;
  Rounds := 0;
  while (Rounds < 8) do begin
    if User.Dead or NeedReturn then exit;

    // 1) kill everything that is on us
    if HaveAgroMobs() then begin
      Engine.Msg('[Rebuff]', 'Mobs on me, killing them', 128);
      Engine.FaceControl(0, true);
      Wait := 0;
      while HaveAgroMobs() and (Wait < 220) do begin
        if User.Dead or NeedReturn then exit;
        Delay(555); Inc(Wait);
      end;
    end;

    // 2) nobody on us now: stop farm and wait for the combat flag to drop
    Engine.FaceControl(0, false);
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
  result := Engine.InZone(UX, UY, UZ);
end;

// Loads the interface config and the farm zone.
// Whether the zone really loaded is checked afterwards by IsInFarmZone.
procedure LoadFarmSettings();
begin
  if ConfigName <> '' then begin
    Engine.Msg('[Init]', 'LoadConfig: ' + Script.Path + CONFIG_DIR + ConfigName, 128);
    Engine.LoadConfig(Script.Path + CONFIG_DIR + ConfigName);
    Delay(1000);
  end;

  Engine.Msg('[Init]', 'LoadZone: ' + Script.Path + ZONE_DIR + ZoneName, 128);
  Engine.ClearZone;
  Engine.LoadZone(Script.Path + ZONE_DIR + ZoneName);
  Delay(500);
end;

// Loads zone + config and turns the profile on ONLY if we stand inside the zone.
// ReportMismatch = true: say in chat that the path and the zone do not match.
function StartFarm(ReportMismatch: boolean): boolean;
begin
  result := false;
  OnSpot := false;
  Engine.FaceControl(0, false);

  LoadFarmSettings();

  if not IsInFarmZone() then begin
    if ReportMismatch then
      Engine.Msg('[Path]', 'Path and zone do not match! Standing at ' +
        IntToStr(User.X) + ', ' + IntToStr(User.Y) + ', ' + IntToStr(User.Z) +
        ' - outside ' + ZoneName + '. Fix the path or the zone. Farm is OFF', 128);
    exit;
  end;

  OnSpot := true;
  Engine.FaceControl(0, true);
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
    Engine.FaceControl(0, false);
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
  Engine.FaceControl(0, false);
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
  Engine.FaceControl(0, false);
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
  Engine.FaceControl(0, false);
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

  GoToGatekeeper();
  if not TeleportToSpot() then begin
    Engine.Msg('[GoToSpot]', 'Teleport failed, farm is OFF', 128);
    IsRecovering := false;
    exit;
  end;

  result := WalkToSpot();
  if not result then
    Engine.Msg('[GoToSpot]', 'Not in the farm zone, farm is OFF', 128);
  IsRecovering := false;
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
      Engine.FaceControl(0, false);
      Engine.Msg('[Death]', 'Dead. Waiting 5 sec before "To Village"...', 128);

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
    if TreeBusy then continue;   // tree handler is shooting a mob, rebuff after it
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
          Engine.FaceControl(0, true);
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
          Engine.FaceControl(0, true);
          Delay(5000);
          continue;
        end;
        Delay(1000);
      end;

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

      if OnSpot and (not User.Dead) and (not NeedReturn) then Engine.FaceControl(0, true);   // back to farm
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
function EquipWeapon(ItemID: integer): boolean;
var Tries: integer;
begin
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
    Engine.Msg('[Tree]', 'Could not equip item ' + IntToStr(ItemID) + ' after ' + IntToStr(EQUIP_TRIES) + ' tries', 128);
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
  OID, LastOID, Idx, HP, LastHP, StuckMs, NX, NY, NZ, WeaponMs: integer;
begin
  LastOID := 0;
  LastHP := -1;
  StuckMs := 0;
  WeaponMs := 0;
  while Delay(POLL_MS) do begin
    // only while farming; a low buff belongs to the rebuff thread
    if (not IsOnline()) or (not OnSpot) or IsRecovering or NeedReturn or User.Dead or
       ((BuffID <> 0) and (BuffTime(BuffID) < REBUFF_TIME)) then begin
      StuckMs := 0;
      continue;
    end;

    // the melee weapon must be on while farming (fixes "fights with bare hands / with the bow")
    WeaponMs := WeaponMs + POLL_MS;
    if WeaponMs >= WEAPON_CHECK_MS then begin
      WeaponMs := 0;
      if not IsEquipped(TreeMeleeID) then begin
        RefreshInventory();
        if not IsEquipped(TreeMeleeID) then begin
          Engine.Msg('[Tree]', 'Melee weapon is not on, equipping ' + IntToStr(TreeMeleeID), 128);
          TreeBusy := true;
          EquipWeapon(TreeMeleeID);
          TreeBusy := false;
        end;
      end;
    end;

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
      Engine.FaceControl(0, false);
      HandleTreeMob(OID);
      if OnSpot and (not User.Dead) and (not NeedReturn) then Engine.FaceControl(0, true);
      TreeBusy := false;
      LastOID := 0;
      StuckMs := 0;
    end;
  end;
end;

// ===================== Events: players around, private messages =====================
// Everything is polled from one thread, so spot scripts need no OnAction.
// Every event goes to the bot chat + its sound from Library\Sounds + Telegram (SetTelegram).

procedure Alert(Title, Text, Sound: string);
begin
  Engine.Msg(Title, Text, 255);
  if Sound <> '' then PlaySound(Script.Path + SOUND_DIR + Sound);
  if AlertBlink then Engine.BlinkWindow(true);   // true = game window, false = Adrenaline window
  if TelegramKey <> '' then SendToTelegram(TelegramKey, User.Name + ': ' + Title + ' ' + Text);
end;

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

procedure Events_Thread();
var
  Seen, Cur: array of integer;   // OIDs of players near us: last poll / this poll
  i, j, n, OID, X, Y, Z: integer;
  Known: boolean;
  MaxOID: cardinal;
  M: TChatMessage;
  Me: string;
begin
  SetLength(Seen, 0);
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
    Engine.FaceControl(0, false);
  end else if StartFarm(false) then begin
    Engine.Msg('[Init]', 'Already in the farm zone. Farming', 128);
  end else begin
    // in Aden, another town or anywhere else -> standard route via Aden
    Engine.Msg('[Init]', 'Not on the spot. Going via Aden', 128);
    Engine.FaceControl(0, false);
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
  if not AlertBlinkSet then AlertBlink := true;
end;

procedure RunFarm();
begin
  Engine.Msg('[Init]', 'Spot farm started, zone ' + ZoneName, 128);
  ApplyAlertDefaults();
  IsRecovering := false;
  NeedReturn := false;
  OnSpot := false;

  if HasLogin then
    while not DoLogin() do Delay(LOGIN_RETRY_WAIT);
  Delay(1000);

  StartInGame();

  Script.NewThread(@AltB_Rebuff_Thread);
  Script.NewThread(@DeathHandler_Thread);
  if HasLogin then Script.NewThread(@Login_Thread);
  if TreeEnabled then Script.NewThread(@TreeWatch_Thread);
  if (PlayerAlertRange > 0) or PrivateAlert then Script.NewThread(@Events_Thread);
  Delay(-1);
end;

end.
