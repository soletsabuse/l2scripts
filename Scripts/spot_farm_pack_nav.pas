unit SpotFarmPackNav;

// = spot_farm_pack.pas + runs by the map (Core\nav_move.pas): on the spot a graph is built from the
// zone (or a lidar grid of Core\nav_explore.pas); a point behind a wall is reached along it, the plain
// run getting stuck goes along it too.
//     SetNavZone('CRUMA_WALLS.zmap');      // optional: map for runs = this .zmap, not the farm zone (its
//                                          //   cut-outs may be places not to farm, not walls)
//     SetNavGrid('CRUMA_1.navgrid');       // optional: lidar grid (Library\Nav) instead of the zone
//     SetNavTrace('CHURCH_1.navtrace');    // optional: wall trace of nav_trace_run (Library\Nav) over the
//                                          //   zone: cuts off what is behind the traced walls / pillars
//     SetNavCell(40);                      // optional: cell size of the zone grid (default 40)
//   SetNavGrid also is the pull area: mobs are pulled only on its walkable cells (Core\mob_pull.pas).
//   SetNavGrid also applies the settings saved in the .navgrid by nav_view.html (tab Settings, "K key
//   value" lines) at once: a script can be just SetNavGrid + RunFarm; lines after SetNavGrid override.
//   Pull tuning by name: SetPull('touch_wait_ms', 800) etc. (list in Core\mob_pull.pas, PullSet)
//     SetAutoCorner(800);                  // optional: fight round a wall corner found on the map
//     SetFarmSpots('CRUMA_1.navtrace');    // optional: perfect farm spots marked with #f while tracing
//     SetFarmMode(FARM_AUTO);              // optional: FARM_PACK (default) / FARM_SINGLE (one by one
//                                          //   where they stand, patrol) / FARM_AUTO (pack when dense) /
//                                          //   FARM_ROOMS (on by itself when the nav map has rooms)
//     SetRoomPlayers(60);                  // rooms: another player there 60 s -> leave (0 at once, -1 never)
//                                          //   (taken first when one fits the pack, then SetAutoCorner)
//     SetFarmPoints('CRUMA_1.navpts');     // optional: corners / safe point / patrol from nav_view.html
//                                          //   (Library\Nav) - same as AddCorner / SetSafePoint / SetPatrol

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
//     SetSpoilFarm(254, 42, [0], [0], 100);  // optional: single mobs WITHOUT the interface: run to the mob with
//                                          //   the server path before every hit, act only within 100 of it;
//                                          //   spoil, sweep, attack skills ([0] = plain attack), mob IDs ([0] = any)
//     SetPackFarm(6, 302, 444, [0]);       // optional: body pull a pack of 6 (server path), run to the
//                                          //   nearest AddCorner point, mass spoil 302, auto attack with
//                                          //   target switching for the splash, mass sweep 444; mob IDs ([0] = any)
//     AddCorner(x, y, z);                  // any number: corner points the pack is stacked at
//     SetPackDagger(itemID, 0);            // optional: dagger on when only a fat mob (MaxHP above the
//                                          //   2nd param, 0 = the champion limit) is left of the pack
//     SetPackTap(itemID, 600);             // optional: a mob that does not aggro from the run past it is hit
//                                          //   once with this weapon from 600, and we run on at once
//     AddSelfBuff(1068, 0);                // optional, any number: buff gone -> cast this skill on self
//                                          //   (2nd param = buff ID to watch, 0 = same as the skill)
//     SetSecondTeleport(30233, ['teleport_request', 'teleport_...']);  // optional: after the Aden
//                                          //   teleport run to this NPC and send these bypasses one after another
//   Every move of this library goes as a mouse-click packet: the server builds the path (hills, walls).
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

uses SysUtils, Classes, NavMove in 'Core\nav_move.pas', MobPull in 'Core\mob_pull.pas',
  RoomFarm in 'Core\room_farm.pas';

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

// ===================== Farm modes for SetFarmMode =====================
  FARM_PACK     = 0;   // pull a pack -> farm spot / round a corner -> fight (default)
  FARM_SINGLE   = 1;   // run over the location and kill the mobs one by one where they stand
  FARM_AUTO     = 2;   // many free mobs near -> a pack round a corner, few -> one by one
  FARM_ROOMS    = 3;   // the rooms of the nav map, one after another (on by itself when the map has rooms)

procedure SetZone(Name: string);
procedure SetConfig(Name: string);
procedure SetTeleport(Bypass: string);
procedure SetBuff(WatchBuffID: integer; Bypasses: array of string);
procedure SetPath(Points: array of integer);
procedure SetSafePoint(X, Y, Z: integer);
procedure SetExpOff(Enabled: boolean);
procedure SetTreeMobs(BowID, MeleeID, BowRange: integer);
procedure SetAoeFarm(PackSize, SpoilSkill, SweepSkill: integer; AoeSkillIDs, MobIDs: array of integer);
procedure SetSpoilFarm(SpoilSkill, SweepSkill: integer; SkillIDs, MobIDs: array of integer; Range: integer);
procedure SetSecondTeleport(NpcID: integer; Bypasses: array of string);
procedure AddSelfBuff(SkillID, BuffID: integer);
procedure SetPackFarm(PackSize, MassSpoilSkill, MassSweepSkill: integer; MobIDs: array of integer);
procedure AddCorner(X, Y, Z: integer);
procedure SetPackDagger(DaggerID, FatMaxHP: integer);
procedure SetPackTap(WeaponID, Range: integer);
procedure SetPackTapAlways(Enable: boolean);
procedure SetCornerRadius(Radius: integer);
procedure SetZRange(Range: integer);
procedure SetNavGrid(Name: string);
procedure SetNavZone(Name: string);
procedure SetNavTrace(Name: string);
procedure SetNavCell(Cell: integer);
procedure SetFarmPoints(Name: string);
procedure SetPull(Key: string; Value: integer);
procedure SetPullIgnore(MobIDs: array of integer);
procedure SetAutoCorner(MaxDist: integer);
procedure SetFarmSpots(Name: string);
procedure SetFarmMode(Mode: integer);
procedure SetRoomPlayers(Seconds: integer);
procedure SetDebug(Level: integer);
procedure SetRangedHunt(Ms: integer);
procedure SetSpotsOnly(Enable: boolean);
procedure SetSkipChampions(Enable: boolean);
procedure SetChampionHP(MinMaxHP: integer);
procedure SpoilOnAction(Action: TL2Action; P1, P2: cardinal);
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
  SAFE_AGGRO_RANGE  = 700;      // rebuff at the safe point: mobs hitting us (also from range) this close are killed, farther ignored
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
  NAV_STALL_MS      = 2500;     // MoveWait: not moved this long = the plain server path is stuck
  SOUND_DIR         = '..\Sounds\';   // relative to Library\Scripts (Script.Path)
  DEFAULT_PLAYER_ALERT_RANGE = 0;     // players around: OFF by default (SetPlayerAlert(2000) turns it on)
  DEFAULT_PLAYER_SOUND  = 'alarm (fem).wav';
  DEFAULT_PRIVATE_SOUND = 'incoming private msg (fem).wav';
  DEFAULT_DEATH_SOUND   = 'caracter died.wav';
  DEFAULT_BUFF_ID       = 1204;    // no SetBuff / buff setting: this buff via the buffer (same on all our chars)
  DEFAULT_BUFF_BYPASS1  = '_bbs_buffer_show';
  DEFAULT_BUFF_BYPASS2  = 'book_use?name=s&pre=0&target=Player';
  DEFAULT_SELF_BUFF     = 421;     // no AddSelfBuff / self buff setting: this skill on self
  DEFAULT_CHAMPION_HP   = 100000;  // champion alert ON by default: a mob with MaxHP above this
  DEFAULT_CHAMPION_SOUND = 'champion.wav';
  WEAPON_POLL_MS        = 2000;    // check every N ms that the weapon is on (disarm)
  WEAPON_SLOT_RHAND     = $0080;   // L2 body part: right hand (one-hand weapon)
  WEAPON_SLOT_LRHAND    = $4000;   // L2 body part: two-hand weapon ($8000 = full armor, NOT a weapon)
  EVENTS_POLL_MS    = 1000;   // how often players around / private messages are checked
  LOGIN_KEY_WAIT    = 4;       // seconds before each Enter (proxy, character) - same as login_test.txt
  LOGIN_RETRY_WAIT  = 30000;    // ms between failed login attempts
  MOVE_RESEND_MS    = 1500;     // server-path move: the click packet is sent again every N ms
  MOVE_WAIT_MS      = 15000;    // MoveWait: give up reaching the point after this
  SP_MOVE_MS        = 600;      // spoil farm: run order to the mob repeated every N ms (it moves)
  SP_APPROACH_MS    = 15000;    // spoil farm: cannot get next to a mob this long -> skip it
  SP_IGNORE_MS      = 30000;    // spoil farm: a skipped mob is not taken again for this long
  SP_SPOIL_TRIES    = 3;        // spoil farm: spoil casts on one mob before giving up on the spoil
  SP_FORCE_MS       = 3000;     // spoil farm: a mob hitting us we cannot get next to this long -> hit it from here
  SP_STUCK_MS       = 4000;     // spoil farm: running to a mob but not moving this long -> skip it
  SP_NODMG_MS       = 12000;    // spoil farm: mob HP does not drop this long -> skip it (even if it "hits" us)
  SP_SWEEP_TRIES    = 3;        // spoil farm: sweep casts on one corpse
  PK_TICK_MS        = 50;       // pack farm: main loop tick
  PK_REACH          = 25;       // pack farm: corner / drop reached when we stand this close to the point
  PK_STOP_MS        = 300;      // pack farm: not moving this long = stopped -> click again
  PK_RECLICK_DIST   = 80;       // pack farm: the mob moved this far from our click point -> click again
  PK_NEAR_OK        = 60;       // pack farm: stopped this close to a point 3 times = as close as the server lets us
  PK_TOUCH          = 120;      // pack farm: this close to a free mob = it should aggro (body pull)
  PK_TOUCH_WAIT_MS  = 800;      // pack farm: nobody on us yet, next to a mob this long without aggro -> tap it once
  PK_TOUCH_GRACE_MS = 3000;     // pack farm: a touched mob is given this long to aggro before we run at it again
  PK_TOUCH_MAX      = 3;        // pack farm: touched this many times without aggro = passive -> skipped
  PK_PULL_SKIP_MS   = 8000;     // pack farm: pull mob we got stuck on the way to (wall / our pack) -> skipped this long
  PK_TAP_AFTER_MS   = 1000;     // pack farm, SetPackTap: run past a mob, no aggro this long -> tap it
  PK_TAP_MS         = 4000;     // pack farm, SetPackTap: weapon swap + hit must land within this, else skip the mob
  PK_TAP_SKIP_MS    = 10000;    // pack farm, SetPackTap: a tapped mob is not run at again this long (it comes to us)
  PK_STATIC_MS      = 2000;     // pack farm: a mob on us that does not move this long ...
  PK_STATIC_DIST    = 150;      // ... and stays farther than this = a shooter standing in place: ignored
  PK_EXTRA_RANGE    = 300;      // pack farm: pack full -> still take free mobs this close (on the way)
  PK_BACK_PENALTY   = 400;      // pack farm: pull order - a mob behind us costs this much extra distance
  PK_HIT_RANGE      = 80;       // pack farm: auto attack only this close; farther -> run by the server path
  PK_STUCK_MS       = 1500;     // pack farm: running to a mob without moving this long (wall) -> skip it
  PK_POINT_STUCK_MS = 3000;     // pack farm: running to a point without moving this long -> give up
  PK_PULL_MIN_HP    = 50;       // pack farm: HP % below this -> stop pulling, fight what we have
  PK_PULL_NOGAIN_MS = 15000;    // pack farm: no new aggro this long -> fight what we have
  PK_PULL_MAX_MS    = 60000;    // pack farm: max time of one pull
  PK_STACK_DIST     = 100;      // pack farm: at the corner the pack is stacked when every mob is this close
  PK_SPOIL_FIRST_MS = 600;      // pack farm: auto attack this long before the 1st mass spoil
  PK_SPOIL_GAP_MS   = 1500;     // pack farm: at least this long between mass spoils
  PK_FIGHT_RANGE    = 700;      // pack farm: a mob on us this close belongs to the pack being fought (stragglers too)
  PK_NO_GAIN_MS     = 6000;     // a run that gets no 100 closer to its target this long = stuck
  PK_ROOM_ENTRY     = 600;      // rooms: aggro this close outside the room polygon (its entry) -> pull the room
  PK_ROOM_NEAR      = 520;      // rooms: this close to a room polygon = at the room (its spots go 500 out)
  PK_ROOM_LOOK_MS   = 60000;    // rooms, nothing to farm: a room not seen this long -> go and look at it
  PK_LEAD_B         = 300;      // the way in to a farm spot: the leg before the turn at the corner
  PK_PHANTOM_MS     = 20000;    // "on us" but too far / another floor: not aggro this long
  PK_FIGHT_IDLE_MS  = 5000;     // pack farm: at the corner nobody comes into reach this long -> the fight is over
  PK_SPLASH_RANGE   = 150;      // pack farm: mobs this close in front of us are hit by the auto attack splash
  PK_SPLASH_ANGLE   = 60;       // pack farm: splash cone, degrees to each side of the target
  PK_SPOIL_CASTS    = 2;        // pack farm: mass spoil casts per pack if the server never sends the spoil messages
  PK_SPOIL_MAX      = 8;        // pack farm: max mass spoil casts per pack (+ new mobs) while not all are spoiled
  PK_SPOIL_RESULT_MS = 1200;    // pack farm: after a mass spoil count the spoil messages this long
  PK_SPOIL_AREA     = 200;      // pack farm: mobs this close to us are taken as hit by a mass spoil
  PK_NEW_SPOIL_MS   = 300;      // pack farm: a new (not spoiled) mob next to us -> mass spoil after this pause
  PK_CAST_MS        = 300;      // pack farm: short pause after a mass spoil / mass sweep cast, then hit again
  PK_CORPSE_MS      = 4000;     // pack farm: a single corpse is swept after lying this long
  PK_CORNER_DRIFT   = 80;       // pack farm: pushed this far from the corner -> back into it
  PK_PICKUP_RANGE   = 600;
  PK_AUTO_RANGE     = 1500;     // FARM_AUTO: free mobs this close to us decide pack / one by one      // pack farm: pick up drops this close after a pack
  SP_SPOIL_WAIT_MS  = 2500;     // spoil farm: after a spoil cast wait this long for "spoil activated"
  SPOIL_OK_MSG_ID   = 612;      // system message "The spoil condition has been activated."
  SPOIL_DONE_MSG_ID = 357;      // system message "It has already been spoiled." 
  SP_PICKUP_RANGE   = 500;      // spoil farm: pick up drops this close after a kill

// ===================== Spot data (filled by the spot script) =====================
var
  ZoneName: string;
  ConfigName: string;
  TeleportBypass: string;
  BuffID: integer;               // watched buff (SetBuff)
  BuffBypasses: array of string;  // buff bypasses, sent in order (SetBuff)
  BuffSet, SelfBuffSet: boolean;  // set by the script / the map: no defaults (DEFAULT_BUFF_ID, DEFAULT_SELF_BUFF)
  Path: array of integer;
  HasSafePoint: boolean;          // SetSafePoint called
  NavZoneName: string;            // SetNavZone: map for runs ('' = the farm zone)
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

// ===================== Spoil farm (SetSpoilFarm) =====================
  SpoilEnabled: boolean;          // SetSpoilFarm called: the script farms, the interface stays OFF
  SpSpoilSkill, SpSweepSkill, SpRange: integer;
  SpSkills: array of integer;     // attack skills; empty = plain attack
  SpMobIDs: array of integer;     // mobs to attack; empty = any mob in the zone
  SpTarget, SpSpoilTries, SpMoveOID: integer;
  LastSpMove: cardinal;
  SpIgnOID: array[0..15] of integer;   // mobs we could not get to: skipped for SP_IGNORE_MS
  SpIgnTime: array[0..15] of cardinal;
  SpIgnHead: integer;
  SpWasSpoiled: boolean;          // the current target was seen spoiled while alive -> sweep it
  SpoilMsgFlag: boolean;          // set by SpoilOnAction: "spoil activated" / "already spoiled"
  PkEvSpoil: integer;             // SpoilOnAction: spoil messages counted (one per mob under a mass spoil)
  PkHistSpoil: integer;           // the same counted from the system chat history
  PkSeenSpoilMsg: boolean;        // the server sends spoil messages at all
  SpLastSysOID: cardinal;         // newest system chat message we have looked at
  SecondNpcID: integer;           // SetSecondTeleport: NPC after the Aden teleport (0 = none)
  SecondBypasses: array of string;
  SelfBuffSkill: array of integer;   // AddSelfBuff: skill to cast on self ...
  SelfBuffID: array of integer;      // ... when this buff is gone
  PackEnabled: boolean;           // SetPackFarm called: the script farms packs, the interface stays OFF
  PkPackSize, PkMassSpoil, PkMassSweep: integer;
  PkMobIDs: array of integer;     // mobs to pull; empty = any mob in the zone
  PkCorners: array of integer;    // AddCorner points (x, y, z)
  PkCorner, PkCX, PkCY, PkCZ: integer;   // the corner of the current pack (-1 = none)
  PkDaggerID, PkFatHP, PkMainWeapon, PkCorpseOID: integer;
  PkDaggerOn: boolean;            // the dagger is on for a fat mob: the disarm guard leaves it
  PkTapWeapon, PkTapRange, PkTapMain: integer;   // SetPackTap: weapon to tap with, from how far; farm weapon
  PkTapOn: boolean;               // the tap weapon is (being) put on: the disarm guard leaves it
  PkTapAlways: boolean;           // SetPackTapAlways: every pull mob is tapped, no body pull
  PkSafeReady: boolean;           // pack farm, rebuff due: we stand at the safe point, mobs dead, out of combat
  PkPullGrid: string;             // SetNavGrid: pull area = its walkable cells
  PkAutoCorner: integer;          // SetAutoCorner: search a corner spot this far (0 = AddCorner only)
  PkSpotsOnly: boolean;           // SetSpotsOnly: the pack goes only to the farm spots of the map
  PkSkipChamps: boolean;          // SetSkipChampions: champions are not pulled / fought
  PkRoomSeq: boolean;             // room_order SEQ: the rooms one after another A, B, C..., no counting
  PkSeqNext, PkSeqGoal: integer;  // SEQ: the room to go to next / the one we went for
  PkCycleWait: integer;           // room_cycle_wait: SEQ, after the last room wait this many seconds
  PkSeqWaitUntil: cardinal;       // ... until then
  PkRoomRecount: boolean;         // room_recount: the pull takes the mobs that came up meanwhile too
  PkIgnoreWay: boolean;           // room_ignore_way: aggro away from the room we go to -> run on, no fight
  PkChampHP: integer;             // SetChampionHP: a mob with MaxHP above this is a champion (0 = the alert limit)
  PkLeadBX, PkLeadBY, PkLeadEX, PkLeadEY: integer;   // PkPlanLead: the way in round the corner
  PkRebuffSaidAt: cardinal;       // last "waiting for the rebuff" message
  PkSpotX, PkSpotY, PkSpotZ: array of integer;   // SetFarmSpots: perfect farm spots (#f of nav_trace)
  PkSpotRooms: array of string;   // "F x y z A,B": the rooms the spot is for (',A,B,'); '' = by place
  PkSpotN: integer;
  PkFarmMode: integer;            // SetFarmMode
  PkFarmModeSet: boolean;         // SetFarmMode was called (else rooms in the map switch rooms on)
  PkRoomSel: integer;             // the room we farm now + 1 (0 = none)
  PkRoomWaiting: boolean;         // not enough mobs anywhere: waiting in this room
  PkDebug: integer;               // SetDebug: 0 off, 1 state changes (default), 2 + the rooms table
  PkDebugSet: boolean;
  PkLastState: string;            // the last [State] line and when it was said
  PkStateAt, PkRoomsAt: cardinal;
  PkPatrolX, PkPatrolY, PkPatrolK: integer;   // one by one: where the patrol runs now
  PkPatrolOn: boolean;
  PkAreaSet: boolean;
  PkZRange: integer;              // SetZRange: pack farm takes mobs only this far up / down from us (0 = any)
  PkCornerR: integer;             // SetCornerRadius: at the corner fight mobs this far from the point (0 = only in hit range)
  PkRangedMs: integer;            // SetRangedHunt: a mob on us that does not come closer this long -> run and kill it
  PkRangedSet: boolean;
  PkNearD: double;                // PkNearestFight: its distance
  PkWearID: integer;              // PkWear: the weapon being put on now
  PkWearUseAt, PkWearRefAt: cardinal;   // PkWear: last UseItem / last inventory request
  PkWearOK: boolean;              // PkWear: PkWearID is on (seen in a fresh inventory)
  PkCorpseSince: cardinal;
  PkLX, PkLY: integer;            // our position at the last real move (wall check)
  PkMovedAt: cardinal;
  PkClickX, PkClickY: integer;    // the point of our last click
  PkClickAt: cardinal;
  PkTouchOID: array[0..15] of integer;    // mobs we ran past during the pull (they should follow us)
  PkTouchAt: array[0..15] of cardinal;
  PkTouchCnt: array[0..15] of integer;
  PkSkipOID: array[0..31] of integer;     // pull only: mobs skipped for a while (stuck on the way / passive)
  PkSkipUntil: array[0..31] of cardinal;
  PkSkipHead: integer;
  PkTouchHead: integer;
  PkTrkOID: array[0..31] of integer;     // shooter check: mobs on us, last position and when it moved
  PkTrkX, PkTrkY: array[0..31] of integer;
  PkTrkAt: array[0..31] of cardinal;
  PkTrkHead: integer;
  PkShootOID: array[0..31] of integer;   // shooters (do not move, shoot from afar): never pulled / fought
  PkShootHead: integer;
  PkDirX, PkDirY: integer;               // pull order: where we came from (the last touched mob)
  PkSpoiledOID: array[0..63] of integer; // mobs of the pack hit by our mass spoil
  PkSpoiledHead: integer;
  PkSnapOID: array[0..31] of integer;    // mobs under the last mass spoil (taken at the cast)
  PkSnapN: integer;
  PkSweptOID: array[0..63] of integer;   // corpses a mass sweep was cast on (the bot may keep Sweepable on them)
  PkSweptHead: integer;

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
  BuffSet := true;
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

// single-mob spoil farm without the interface (see the header); Range = act only this close
procedure SetSpoilFarm(SpoilSkill, SweepSkill: integer; SkillIDs, MobIDs: array of integer; Range: integer);
var i: integer;
begin
  SpSpoilSkill := SpoilSkill;
  SpSweepSkill := SweepSkill;
  SpRange := Range;
  if SpRange <= 0 then SpRange := 100;
  SetLength(SpSkills, 0);
  for i := 0 to Length(SkillIDs) - 1 do
    if SkillIDs[i] > 0 then begin      // [0] = plain attack only
      SetLength(SpSkills, Length(SpSkills) + 1);
      SpSkills[Length(SpSkills) - 1] := SkillIDs[i];
    end;
  SetLength(SpMobIDs, 0);
  for i := 0 to Length(MobIDs) - 1 do
    if MobIDs[i] > 0 then begin        // [0] = any mob in the zone
      SetLength(SpMobIDs, Length(SpMobIDs) + 1);
      SpMobIDs[Length(SpMobIDs) - 1] := MobIDs[i];
    end;
  SpoilEnabled := true;
end;

// pack farm without the interface: the pack and the skills; the mobs come by PkPackAddMob
procedure PkPackStart(PackSize, MassSpoilSkill, MassSweepSkill: integer);
begin
  PkPackSize := PackSize;
  if PkPackSize < 1 then PkPackSize := 1;
  PkMassSpoil := MassSpoilSkill;
  PkMassSweep := MassSweepSkill;
  SetLength(PkMobIDs, 0);
  if SpRange <= 0 then SpRange := 100;   // single-mob kill (rebuff / safe point) uses it
  PkCorner := -1;
  PackEnabled := true;
  PullSetPackSize(PkPackSize);         // the pull itself is Core\mob_pull.pas
  PullClearMobs();
end;

// one more pack mob ID (0 = nothing: no IDs at all = any mob in the zone)
procedure PkPackAddMob(ID: integer);
begin
  if ID <= 0 then exit;
  SetLength(PkMobIDs, Length(PkMobIDs) + 1);
  PkMobIDs[Length(PkMobIDs) - 1] := ID;
  PullAddMob(ID);                      // one by one: an open array cannot be passed on
end;

// pack farm without the interface (see the header)
procedure SetPackFarm(PackSize, MassSpoilSkill, MassSweepSkill: integer; MobIDs: array of integer);
var i: integer;
begin
  PkPackStart(PackSize, MassSpoilSkill, MassSweepSkill);
  for i := 0 to Length(MobIDs) - 1 do PkPackAddMob(MobIDs[i]);
end;

// after the pull: fight round a wall corner found on the nav map within MaxDist (0 = off; then the
// AddCorner points). The mobs run round the corner and bunch up
procedure SetAutoCorner(MaxDist: integer);
begin
  PkAutoCorner := MaxDist;
end;

// FARM_PACK (default) / FARM_SINGLE (one by one where they stand) / FARM_AUTO (pack when dense)
procedure SetFarmMode(Mode: integer);
begin
  PkFarmMode := Mode;
  PkFarmModeSet := true;
end;

// what the farm is doing and why: 0 = quiet, 1 = a [State] line on every change (default),
// 2 = also a table of the rooms every 15 s
procedure SetDebug(Level: integer);
begin
  PkDebug := Level;
  PkDebugSet := true;
end;

// at the farm spot a mob on us stays away (shoots / casts from its place) and does not come closer this
// many ms -> run to it and kill it, then back to the spot (0 = never, wait for it; default 3000)
procedure SetRangedHunt(Ms: integer);
begin
  PkRangedMs := Ms;
  PkRangedSet := true;
end;

// true = the pack is taken only to the farm spots of the map (the best that fits, else the nearest),
// never to a corner found by itself (SetAutoCorner) or an AddCorner point
procedure SetSpotsOnly(Enable: boolean);
begin
  PkSpotsOnly := Enable;
end;

// true = champions (MaxHP above the champion alert limit, SetChampionAlert) are never pulled, not
// fought and not counted: the room is done without them, the farm goes on to the next one
procedure SetSkipChampions(Enable: boolean);
begin
  PkSkipChamps := Enable;
end;

// SetSkipChampions: a mob with MaxHP above this is a champion (0 = the champion alert limit)
procedure SetChampionHP(MinMaxHP: integer);
begin
  PkChampHP := MinMaxHP;
end;

// rooms: another player in the room this many seconds -> leave it, avoid it for a while
// (0 = at once, -1 = never mind other players; default 60)
procedure SetRoomPlayers(Seconds: integer);
begin
  RoomSetPlayers(Seconds);
end;

// mobs never pulled, never counted as aggro and not fought (archers that shoot from their place...)
procedure SetPullIgnore(MobIDs: array of integer);
var i: integer;
begin
  for i := 0 to Length(MobIDs) - 1 do PullIgnoreID(MobIDs[i]);
end;

// pull tuning by name (Core\mob_pull.pas, PullSet: touch, touch_wait_ms, min_hp, nogain_ms, ...)
procedure SetPull(Key: string; Value: integer);
begin
  PullSet(Key, Value);
end;

procedure AddCorner(X, Y, Z: integer);
var n: integer;
begin
  n := Length(PkCorners);
  SetLength(PkCorners, n + 3);
  PkCorners[n] := X;
  PkCorners[n + 1] := Y;
  PkCorners[n + 2] := Z;
end;

procedure SetPackDagger(DaggerID, FatMaxHP: integer);
begin
  PkDaggerID := DaggerID;
  PkFatHP := FatMaxHP;
end;

// a mob that does not aggro from the run past it: hit it once with WeaponID from Range, then run on
procedure SetPackTap(WeaponID, Range: integer);
begin
  PkTapWeapon := WeaponID;
  PkTapRange := Range;
  if PkTapRange <= 0 then PkTapRange := PK_HIT_RANGE;
  PullSetTap(WeaponID, PkTapRange);
end;

// SetPackTap weapon pulls EVERY mob: run to PkTapRange, one hit, next mob (no running past it)
procedure SetPackTapAlways(Enable: boolean);
begin
  PkTapAlways := Enable;
  PullSetTapAlways(Enable);
end;

// at the corner: run to and hit pack mobs up to Radius from the corner point (0 = stand in the
// corner, hit only what comes within PK_HIT_RANGE)
// pack farm: pull and fight only mobs at most Range up / down from us (0 = no limit)
// map for runs = this .zmap (Library\Zones) instead of the farm zone
procedure SetNavZone(Name: string);
begin
  NavZoneName := Name;
end;

// wall trace (Library\Nav) over the zone; the corners / safe point / we tell which pieces stay
procedure SetNavTrace(Name: string);
begin
  NavSetTrace(Name);
end;

procedure SetNavCell(Cell: integer);
begin
  NavSetCell(Cell);
end;

procedure SetZRange(Range: integer);
begin
  PkZRange := Range;
  PullSetZRange(Range);
end;

procedure SetCornerRadius(Radius: integer);
begin
  PkCornerR := Radius;
  if PkCornerR < 0 then PkCornerR := 0;
end;

// self buff: the buff BuffID is gone -> cast SkillID (BuffID = 0 -> the buff has the skill's ID)
procedure AddSelfBuff(SkillID, BuffID: integer);
var n: integer;
begin
  SelfBuffSet := true;
  if SkillID <= 0 then exit;           // AddSelfBuff(0, 0) = no own buffs at all (no default either)
  n := Length(SelfBuffSkill);
  SetLength(SelfBuffSkill, n + 1);
  SetLength(SelfBuffID, n + 1);
  SelfBuffSkill[n] := SkillID;
  if BuffID > 0 then SelfBuffID[n] := BuffID else SelfBuffID[n] := SkillID;
end;

// double teleport: after the Aden gatekeeper teleport run to NPC NpcID (it is near the landing)
// and send these bypasses one after another
procedure SetSecondTeleport(NpcID: integer; Bypasses: array of string);
var i: integer;
begin
  SecondNpcID := NpcID;
  SetLength(SecondBypasses, Length(Bypasses));
  for i := 0 to Length(Bypasses) - 1 do SecondBypasses[i] := Bypasses[i];
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
  PullIgnoreName(Name);                // the pull module never takes them either
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
  // SetNavGrid: the painted walkable cells are the farm area too (the pull goes all over them)
  if (not result) and PkAreaSet and (PkPullGrid <> '') then result := PullInArea(X, Y, Z);
end;

// ===================== Moves: server path =====================
// Every move goes as the packet the client sends on a mouse click (MoveBackwardToLocation 0F:
// target X Y Z, our X Y Z, 1 = by mouse): the server builds the path itself (hills, walls).

function ClickHex(Value: integer): string;
begin
  result := IntToHex(Value and $FF, 2) + IntToHex((Value shr 8) and $FF, 2) +
            IntToHex((Value shr 16) and $FF, 2) + IntToHex((Value shr 24) and $FF, 2);
end;

// one run order (non-blocking)
procedure MoveServer(X, Y, Z: integer);
var UX, UY, UZ: integer;
begin
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  Engine.SendToServer('0F' + ClickHex(X) + ClickHex(Y) + ClickHex(Z) +
    ClickHex(UX) + ClickHex(UY) + ClickHex(UZ) + ClickHex(1));
end;

// run to the point and wait until we are there (order repeated every MOVE_RESEND_MS),
// max MOVE_WAIT_MS; true = reached. Not moving for NAV_STALL_MS = stuck -> false
function MoveWaitPlain(X, Y, Z: integer): boolean;
var Started, LastSend, StillSince: cardinal;
  UX, UY, LX, LY: integer;
begin
  result := false;
  Started := GetTickCount;
  StillSince := GetTickCount;
  LX := User.X;
  LY := User.Y;
  LastSend := 0;
  while not User.Dead do begin
    if User.DistTo(X, Y, Z) < PATH_REACHED then begin
      result := true;
      exit;
    end;
    if GetTickCount - Started > MOVE_WAIT_MS then exit;
    UX := User.X;
    UY := User.Y;
    if (Abs(UX - LX) > 20) or (Abs(UY - LY) > 20) then begin
      LX := UX;
      LY := UY;
      StillSince := GetTickCount;
    end else if GetTickCount - StillSince > NAV_STALL_MS then exit;
    if (LastSend = 0) or (GetTickCount - LastSend >= MOVE_RESEND_MS) then begin
      MoveServer(X, Y, Z);
      LastSend := GetTickCount;
    end;
    Delay(100);
  end;
end;

// behind a wall on the map -> along the graph first; then the plain server path; stuck -> the graph
function MoveWait(X, Y, Z: integer): boolean;
begin
  if NavIsReady() and (not NavIsBusy()) and (not NavSeeFromUs(X, Y)) then NavGraphTo(X, Y, Z);
  result := MoveWaitPlain(X, Y, Z);
  if result or User.Dead or NavIsBusy() or (not NavIsReady()) then exit;
  if NavGraphTo(X, Y, Z) then result := MoveWaitPlain(X, Y, Z);
  if (not result) and (not User.Dead) then
    if NavUnstick() then begin end;    // stuck: out of there for the next try
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

// field k (0..) of a line split by spaces
function PtField(S: string; k: integer): string;
var p, n: integer;
  T: string;
begin
  T := Trim(S);
  n := k;
  while n > 0 do begin
    p := Pos(' ', T);
    if p = 0 then begin
      result := '';
      exit;
    end;
    T := Trim(Copy(T, p + 1, Length(T)));
    Dec(n);
  end;
  p := Pos(' ', T);
  if p > 0 then result := Copy(T, 1, p - 1) else result := T;
end;

// farm points set in nav_view.html (file in Library\Nav): "C x y z" = corner (AddCorner),
// "S x y z" = safe point (SetSafePoint), "P x y z" = patrol point (SetPatrol, in file order)
procedure SetFarmPoints(Name: string);
var L: TStringList;
  i, X, Y, Z, nC, nP: integer;
  F, S, K: string;
  Pat: array of integer;
begin
  F := Script.Path + '..\Nav\' + Name;
  if not FileExists(F) then begin
    Engine.Msg('[Init]', 'No farm points file ' + F, 128);
    exit;
  end;
  L := TStringList.Create;
  L.LoadFromFile(F);
  nC := 0;
  nP := 0;
  SetLength(Pat, 0);
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    K := PtField(S, 0);
    if (K <> 'C') and (K <> 'S') and (K <> 'P') then continue;
    X := StrToIntDef(PtField(S, 1), 0);
    Y := StrToIntDef(PtField(S, 2), 0);
    Z := StrToIntDef(PtField(S, 3), 0);
    if K = 'C' then begin
      AddCorner(X, Y, Z);
      Inc(nC);
    end else if K = 'S' then SetSafePoint(X, Y, Z)
    else begin
      SetLength(Pat, (nP + 1) * 3);
      Pat[nP * 3] := X;
      Pat[nP * 3 + 1] := Y;
      Pat[nP * 3 + 2] := Z;
      Inc(nP);
    end;
  end;
  L.Free;
  if nP > 0 then begin                 // straight into the patrol (an array cannot go to an open array)
    PatrolIdle := 0;
    SetLength(PatrolPoints, nP * 3);
    for i := 0 to nP * 3 - 1 do PatrolPoints[i] := Pat[i];
    PatrolIdx := 0;
  end;
  Engine.Msg('[Init]', 'Farm points ' + Name + ': ' + IntToStr(nC) + ' corners, ' + IntToStr(nP) + ' patrol', 128);
end;

// perfect farm spots marked with #f while tracing (F lines of a .navtrace in Library\Nav). Before a
// fight the nearest one that fits is taken: the pack does not see it and runs round the corner to it
procedure SetFarmSpots(Name: string);
var L: TStringList;
  i: integer;
  F, S: string;
begin
  F := Script.Path + '..\Nav\' + Name;
  if not FileExists(F) then begin
    Engine.Msg('[Init]', 'No farm spots file ' + F, 128);
    exit;
  end;
  L := TStringList.Create;
  L.LoadFromFile(F);
  SetLength(PkSpotX, L.Count);
  SetLength(PkSpotY, L.Count);
  SetLength(PkSpotZ, L.Count);
  SetLength(PkSpotRooms, L.Count);
  PkSpotN := 0;
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    if PtField(S, 0) <> 'F' then continue;
    PkSpotX[PkSpotN] := StrToIntDef(PtField(S, 1), 0);
    PkSpotY[PkSpotN] := StrToIntDef(PtField(S, 2), 0);
    PkSpotZ[PkSpotN] := StrToIntDef(PtField(S, 3), 0);
    PkSpotRooms[PkSpotN] := '';
    Inc(PkSpotN);
  end;
  L.Free;
  Engine.Msg('[Init]', 'Farm spots ' + Name + ': ' + IntToStr(PkSpotN), 128);
end;

// the extras the viewer keeps in the .navgrid: "Q name min mode prio x y ..." rooms, "F x y z" farm
// spots, "S x y z" the safe point (the script's own SetSafePoint wins)
procedure PkLoadMapExtras(Name: string);
var L: TStringList;
  i, k, n, X, Y, Z, Mode, UZ: integer;
  F, S, K0, M: string;
begin
  F := Script.Path + '..\Nav\' + Name;
  if not FileExists(F) then exit;
  UZ := User.Z;
  L := TStringList.Create;
  L.LoadFromFile(F);
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    K0 := Copy(S, 1, 2);
    if (K0 <> 'Q ') and (K0 <> 'F ') and (K0 <> 'S ') then continue;   // the grid rows are skipped fast
    if K0 = 'Q ' then begin
      M := UpperCase(PtField(S, 3));
      if M = 'SINGLE' then Mode := FARM_SINGLE
      else if M = 'AUTO' then Mode := FARM_AUTO
      else Mode := FARM_PACK;
      RoomAdd(PtField(S, 1), StrToIntDef(PtField(S, 2), 4), Mode, StrToIntDef(PtField(S, 4), 1));
      n := 5;
      while PtField(S, n + 1) <> '' do begin
        X := StrToIntDef(PtField(S, n), 0);
        Y := StrToIntDef(PtField(S, n + 1), 0);
        RoomAddPoint(X, Y);
        n := n + 2;
      end;
    end else begin
      X := StrToIntDef(PtField(S, 1), 0);
      Y := StrToIntDef(PtField(S, 2), 0);
      Z := StrToIntDef(PtField(S, 3), 0);
      if Z = 0 then Z := UZ;
      if K0 = 'F ' then begin
        SetLength(PkSpotX, PkSpotN + 1);
        SetLength(PkSpotY, PkSpotN + 1);
        SetLength(PkSpotZ, PkSpotN + 1);
        SetLength(PkSpotRooms, PkSpotN + 1);
        PkSpotX[PkSpotN] := X;
        PkSpotY[PkSpotN] := Y;
        PkSpotZ[PkSpotN] := Z;
        M := UpperCase(Trim(PtField(S, 4)));    // the rooms it is for, set in the viewer ('' = by place)
        if M <> '' then M := ',' + M + ',';
        PkSpotRooms[PkSpotN] := M;
        Inc(PkSpotN);
      end else if not HasSafePoint then SetSafePoint(X, Y, Z);
    end;
  end;
  L.Free;
  k := RoomCount();
  if k > 0 then begin
    RoomLoadStats(F + '.roomstat');
    if not PkFarmModeSet then PkFarmMode := FARM_ROOMS;
  end;
  Engine.Msg('[Init]', 'Nav map ' + Name + ': ' + IntToStr(k) + ' rooms, ' + IntToStr(PkSpotN) + ' farm spots' +
    ', safe point ' + IntToStr(Ord(HasSafePoint)), 128);
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
  MoveWait(PatrolPoints[PatrolIdx * 3], PatrolPoints[PatrolIdx * 3 + 1], PatrolPoints[PatrolIdx * 3 + 2]);
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

// the line from field k (0..) to its end
function PkRest(S: string; k: integer): string;
var p, n: integer;
  T: string;
begin
  T := Trim(S);
  n := k;
  while n > 0 do begin
    p := Pos(' ', T);
    if p = 0 then begin
      result := '';
      exit;
    end;
    T := Trim(Copy(T, p + 1, Length(T)));
    Dec(n);
  end;
  result := T;
end;

// piece k (0..) of a list split by Sep ('' past the end)
function PkPiece(S, Sep: string; k: integer): string;
var p, n: integer;
  T: string;
begin
  T := S;
  n := k;
  while n > 0 do begin
    p := Pos(Sep, T);
    if p = 0 then begin
      result := '';
      exit;
    end;
    T := Copy(T, p + Length(Sep), Length(T));
    Dec(n);
  end;
  p := Pos(Sep, T);
  if p > 0 then result := Trim(Copy(T, 1, p - 1)) else result := Trim(T);
end;

function PkPieceCount(S, Sep: string): integer;
var p: integer;
  T: string;
begin
  result := 0;
  if Trim(S) = '' then exit;
  T := S;
  result := 1;
  p := Pos(Sep, T);
  while p > 0 do begin
    Inc(result);
    T := Copy(T, p + Length(Sep), Length(T));
    p := Pos(Sep, T);
  end;
end;

// one setting of nav_view.html (a "K key value" line of the .navgrid) = the setter of the same meaning
procedure PkSetting(K, V: string);
var i, n: integer;
  M: string;
begin
  if K = 'zone' then SetZone(V)
  else if K = 'config' then SetConfig(V)
  else if K = 'login' then SetLogin(PtField(V, 0), PtField(V, 1))
  else if K = 'teleport' then SetTeleport(V)
  else if K = 'buff' then begin        // id bypass|bypass|...  (id 0 = no buff at all)
    BuffSet := true;
    BuffID := StrToIntDef(PtField(V, 0), 0);
    M := PkRest(V, 1);
    n := PkPieceCount(M, '|');
    SetLength(BuffBypasses, n);
    for i := 0 to n - 1 do BuffBypasses[i] := PkPiece(M, '|', i);
  end
  else if K = 'second_tp' then begin   // npc bypass|bypass|...
    SecondNpcID := StrToIntDef(PtField(V, 0), 0);
    M := PkRest(V, 1);
    n := PkPieceCount(M, '|');
    SetLength(SecondBypasses, n);
    for i := 0 to n - 1 do SecondBypasses[i] := PkPiece(M, '|', i);
  end
  else if K = 'path' then begin        // x y z x y z ...
    n := 0;
    while PtField(V, n) <> '' do Inc(n);
    SetLength(Path, n);
    for i := 0 to n - 1 do Path[i] := StrToIntDef(PtField(V, i), 0);
  end
  else if K = 'selfbuff' then AddSelfBuff(StrToIntDef(PtField(V, 0), 0), StrToIntDef(PtField(V, 1), 0))
  else if K = 'pack' then begin        // size spoil sweep id,id,...
    PkPackStart(StrToIntDef(PtField(V, 0), 6), StrToIntDef(PtField(V, 1), 0), StrToIntDef(PtField(V, 2), 0));
    M := PkRest(V, 3);
    n := PkPieceCount(M, ',');
    for i := 0 to n - 1 do PkPackAddMob(StrToIntDef(PkPiece(M, ',', i), 0));
  end
  else if K = 'mode' then begin
    M := UpperCase(V);
    if M = 'SINGLE' then SetFarmMode(FARM_SINGLE)
    else if M = 'AUTO' then SetFarmMode(FARM_AUTO)
    else if M = 'ROOMS' then SetFarmMode(FARM_ROOMS)
    else SetFarmMode(FARM_PACK);
  end
  else if K = 'ignore' then begin      // id,id,...
    n := PkPieceCount(V, ',');
    for i := 0 to n - 1 do PullIgnoreID(StrToIntDef(PkPiece(V, ',', i), 0));
  end
  else if K = 'pull' then SetPull(PtField(V, 0), StrToIntDef(PtField(V, 1), 0))
  else if K = 'supply' then AddSupply(StrToIntDef(PtField(V, 0), 0), StrToIntDef(PtField(V, 1), 0), StrToIntDef(PtField(V, 2), 0))
  else if K = 'zrange' then SetZRange(StrToIntDef(V, 0))
  else if K = 'weapon' then SetWeapon(StrToIntDef(V, 0))
  else if K = 'tap' then SetPackTap(StrToIntDef(PtField(V, 0), 0), StrToIntDef(PtField(V, 1), 0))
  else if K = 'tap_always' then SetPackTapAlways(V = '1')
  else if K = 'dagger' then SetPackDagger(StrToIntDef(PtField(V, 0), 0), StrToIntDef(PtField(V, 1), 0))
  else if K = 'corner_radius' then SetCornerRadius(StrToIntDef(V, 0))
  else if K = 'auto_corner' then SetAutoCorner(StrToIntDef(V, 0))
  else if K = 'room_players' then SetRoomPlayers(StrToIntDef(V, 60))
  else if K = 'room_avoid' then RoomSetAvoid(StrToIntDef(V, 30))
  else if K = 'debug' then SetDebug(StrToIntDef(V, 1))
  else if K = 'ranged_ms' then SetRangedHunt(StrToIntDef(V, 3000))
  else if K = 'spots_only' then SetSpotsOnly(V = '1')
  else if K = 'skip_champions' then SetSkipChampions(V = '1')
  else if K = 'champ_hp' then SetChampionHP(StrToIntDef(V, 0))
  else if K = 'room_order' then PkRoomSeq := UpperCase(V) = 'SEQ'
  else if K = 'room_cycle_wait' then PkCycleWait := StrToIntDef(V, 0)
  else if K = 'room_recount' then PkRoomRecount := V = '1'
  else if K = 'room_ignore_way' then PkIgnoreWay := V = '1'
  else if K = 'exp_off' then SetExpOff(V = '1')
  else if K = 'player_alert' then SetPlayerAlert(StrToIntDef(V, 0))
  else if K = 'private_alert' then SetPrivateAlert(V = '1')
  else if K = 'champion_alert' then SetChampionAlert(StrToIntDef(V, 0))
  else if K = 'telegram' then SetTelegram(V)
  else Engine.Msg('[Init]', 'Unknown setting "' + K + '" in the nav map', 255);
end;

// runs by a nav map of nav_view.html (file in Library\Nav) instead of the zone; the map is the pull
// area too, and its settings ("K key value" lines, tab Settings of the viewer) are applied right now -
// the script lines after SetNavGrid override them
procedure SetNavGrid(Name: string);
var L: TStringList;
  i, n: integer;
  F, S: string;
begin
  NavSetGrid(Name);
  PkPullGrid := Name;                  // the grid is the pull area too
  F := Script.Path + '..\Nav\' + Name;
  if not FileExists(F) then exit;
  L := TStringList.Create;
  L.LoadFromFile(F);
  n := 0;
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    if Copy(S, 1, 2) <> 'K ' then continue;   // the grid rows are skipped fast
    PkSetting(LowerCase(PtField(S, 1)), PkRest(S, 2));
    Inc(n);
  end;
  L.Free;
  if n > 0 then Engine.Msg('[Init]', 'Settings from ' + Name + ': ' + IntToStr(n), 128);
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

// script modes farm by themselves: the interface is ON only for the SetConfig profile, which must
// be an alarm one (AutoAtk / AutoMove / PickUp off, only events: player / chat sounds)
function ScriptMode(): boolean;
begin
  result := AoeEnabled or CasterEnabled or SpoilEnabled or PackEnabled;
end;

procedure FarmOn();
begin
  if ScriptMode() then begin
    Engine.FaceControl(0, ConfigName <> '');
    FarmPaused := false;
  end else
    Engine.FaceControl(0, true);
end;

procedure FarmOff();
begin
  FarmPaused := true;
  if ScriptMode() and (ConfigName <> '') then exit;   // the alarm profile keeps running
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
  TargetOID := PullMobTarget(i);
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
  if n >= 3 then MoveWait(Path[n - 3], Path[n - 2], Path[n - 1]);
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
    MoveWait(MX, MY, MZ);
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
    MoveWait(DX, DY, DZ);
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

// ===================== Spoil farm (SetSpoilFarm): single mobs, server path =====================
// No interface, no packs. One mob at a time: before EVERY hit / skill we run to the mob with the
// server path (mouse-click packet) and act only when it is within SpRange (right next to it) -
// the location is crooked and hilly, a straight run / a cast from afar does not work there.
// Order: spoil (until it is spoiled) -> attack skills that are ready -> plain attack;
// dead -> sweep -> pick up the drop around. Mobs that hit us are taken first.

function SpSkillLeft(ID: integer): cardinal;
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

function SpIgnored(OID: integer): boolean;
var i: integer;
begin
  result := false;
  for i := 0 to 15 do
    if (SpIgnOID[i] = OID) and (GetTickCount - SpIgnTime[i] < SP_IGNORE_MS) then begin
      result := true;
      exit;
    end;
end;

procedure SpIgnore(OID: integer);
begin
  SpIgnOID[SpIgnHead] := OID;
  SpIgnTime[SpIgnHead] := GetTickCount;
  SpIgnHead := (SpIgnHead + 1) mod 16;
  PullForget(OID, SP_IGNORE_MS);       // unreachable: not aggro / not pulled in the pull module too
end;

function SpMobIdx(OID: integer): integer;
var i: integer;
begin
  result := -1;
  for i := 0 to NpcList.Count - 1 do
    if NpcList(i).OID = OID then begin result := i; exit; end;
end;

function SpWhitelisted(i: integer): boolean;
var j, ID: integer;
begin
  result := Length(SpMobIDs) = 0;   // empty list = any mob
  if result then exit;
  ID := NpcList(i).ID;
  for j := 0 to Length(SpMobIDs) - 1 do
    if ID = SpMobIDs[j] then begin
      result := true;
      exit;
    end;
end;

// alive mob that hits / holds us and is not far (far "aggro" = stuck / teleported)
function SpOnUs(i: integer): boolean;
var Atk, Tgt, NX, NY, NZ: integer;
begin
  result := false;
  if NpcList(i).Dead then exit;
  Atk := NpcList(i).AtkOID;
  Tgt := PullMobTarget(i);
  if (Atk <> User.OID) and (Tgt <> User.OID) then exit;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  result := User.DistTo(NX, NY, NZ) < AOE_AGGRO_DIST;
end;

// the nearest mob hitting us; none -> the nearest whitelisted mob in the zone
function SpPickTarget(OnlyAggro: boolean): integer;
var i, Pass, NX, NY, NZ: integer;
  D, BestD: double;
  Aggro: boolean;
begin
  result := 0;
  for Pass := 0 to 1 do begin
    Aggro := Pass = 0;           // pass 0: mobs hitting us, pass 1: new mobs
    if (not Aggro) and OnlyAggro then exit;
    BestD := 999999;
    for i := 0 to NpcList.Count - 1 do begin
      if NpcList(i).Dead or IsIgnoredNpc(i) then continue;
      if SpIgnored(NpcList(i).OID) then continue;
      if Aggro then begin
        if not SpOnUs(i) then continue;
      end else begin
        if not SpWhitelisted(i) then continue;
      end;
      NX := NpcList(i).X;
      NY := NpcList(i).Y;
      NZ := NpcList(i).Z;
      if (not Aggro) and (not InFarmArea(NX, NY, NZ)) then continue;
      D := User.DistTo(NX, NY, NZ);
      if D < BestD then begin
        BestD := D;
        result := NpcList(i).OID;
      end;
    end;
    if result <> 0 then exit;
  end;
end;

// distance on the ground (no height: on hills the height alone is often more than SpRange)
function SpDist(Idx: integer): integer;
var UX, UY, NX, NY: integer;
  DX, DY: double;
begin
  UX := User.X;
  UY := User.Y;
  NX := NpcList(Idx).X;
  NY := NpcList(Idx).Y;
  DX := NX - UX;
  DY := NY - UY;
  result := Round(Sqrt(DX * DX + DY * DY));
end;

// the bot game event, forwarded from the script's OnAction. Called from the bot's event thread:
// only set a flag here (no arrays, no chat messages)
procedure SpoilOnAction(Action: TL2Action; P1, P2: cardinal);
begin
  if (Action = laSysMsg) and ((P1 = SPOIL_OK_MSG_ID) or (P1 = SPOIL_DONE_MSG_ID)) then begin
    SpoilMsgFlag := true;
    Inc(PkEvSpoil);
  end;
end;

// "spoil activated" / "already spoiled" arrived since the last call: the event flag
// (SpoilOnAction), or a new line in the system chat history
function SpSpoilMsg(): boolean;
var i, n: integer;
  M: TChatMessage;
  T: string;
begin
  result := SpoilMsgFlag;
  SpoilMsgFlag := false;
  // the history grows / is trimmed in the bot's thread while we read it: the count is checked before
  // every line - no try (a try here broke the script with "Invalid
  // pointer operation" when we died in a fight: new lines came in the middle of the loop)
  n := History.Count(mtSystem);
  for i := 0 to n - 1 do begin
    if i >= History.Count(mtSystem) then break;
    M := History.GetMessage(i, mtSystem);
    if M.OID <= SpLastSysOID then continue;
    SpLastSysOID := M.OID;
    T := LowerCase(M.Text);
    if (Pos('spoil condition has been activated', T) > 0) or
       (Pos('already been spoiled', T) > 0) then result := true;
  end;
end;

// one step on the mob: too far -> run to it (server path); right next to it (or Force) ->
// spoil / skill / hit
procedure SpFightStep(OID: integer; Force: boolean);
var Idx, k, MX, MY, MZ: integer;
begin
  Idx := SpMobIdx(OID);
  if (Idx < 0) or NpcList(Idx).Dead then exit;
  MX := NpcList(Idx).X;
  MY := NpcList(Idx).Y;
  MZ := NpcList(Idx).Z;

  // before every action: are we right next to it? no -> run there first
  if (not Force) and (SpDist(Idx) > SpRange) then begin
    if (OID <> SpMoveOID) or (GetTickCount - LastSpMove >= SP_MOVE_MS) then begin
      MoveServer(MX, MY, MZ);
      SpMoveOID := OID;
      LastSpMove := GetTickCount;
    end;
    exit;
  end;

  if OID <> SpTarget then begin
    Engine.SetTarget(OID);
    SpTarget := OID;
    SpSpoilTries := 0;
    SpWasSpoiled := false;
    SpSpoilMsg();                    // old messages belong to the previous mob
    Delay(50);
  end;
  if NpcList(Idx).Sweepable then SpWasSpoiled := true;   // spoiled -> sweep it when it dies
  if SpSpoilMsg() then SpWasSpoiled := true;

  // spoil once: never again after "spoil activated" (max SP_SPOIL_TRIES casts if it fails)
  if (SpSpoilSkill > 0) and (not SpWasSpoiled) and (SpSpoilTries < SP_SPOIL_TRIES) and
     (SpSkillLeft(SpSpoilSkill) = 0) then begin
    Engine.UseSkill(SpSpoilSkill);
    Inc(SpSpoilTries);
    // wait for the result of the cast before anything else (no second spoil on a spoiled mob)
    for k := 1 to SP_SPOIL_WAIT_MS div 100 do begin
      Delay(100);
      if SpSpoilMsg() then begin
        SpWasSpoiled := true;
        break;
      end;
      Idx := SpMobIdx(OID);
      if (Idx < 0) or NpcList(Idx).Dead then break;
    end;
    exit;
  end;

  // attack skills that are ready, in order
  for k := 0 to Length(SpSkills) - 1 do
    if SpSkillLeft(SpSkills[k]) = 0 then begin
      Engine.UseSkill(SpSkills[k]);
      exit;
    end;

  Engine.Attack(300);   // plain attack
end;

// dead mob: sweep it (if spoiled) and pick up the drop around. The corpse may get its "sweepable"
// flag a moment after the death, the sweep may still be in reuse: wait for both, run next to the
// corpse, up to SP_SWEEP_TRIES casts until it is swept
procedure SpAfterKill(OID: integer);
var i, k, Idx, DX, DY, DZ, CX, CY, CZ: integer;
begin
  if SpSweepSkill > 0 then begin
    Idx := SpMobIdx(OID);
    if (Idx >= 0) and (not NpcList(Idx).Sweepable) and (SpWasSpoiled or (OID <> SpTarget)) then
      for k := 1 to 15 do begin                // up to 1.5 sec for the flag
        Delay(100);
        Idx := SpMobIdx(OID);
        if (Idx < 0) or NpcList(Idx).Sweepable then break;
      end;
    for k := 1 to SP_SWEEP_TRIES do begin
      if User.Dead or NeedReturn then exit;
      Idx := SpMobIdx(OID);
      if (Idx < 0) or (not NpcList(Idx).Sweepable) then break;   // swept / corpse gone
      if SpDist(Idx) > SpRange then begin
        CX := NpcList(Idx).X;
        CY := NpcList(Idx).Y;
        CZ := NpcList(Idx).Z;
        MoveWait(CX, CY, CZ);
      end;
      i := 0;
      while (SpSkillLeft(SpSweepSkill) > 0) and (i < 20) do begin   // up to 2 sec of reuse
        Delay(100);
        Inc(i);
      end;
      Engine.SetTarget(OID);
      Delay(100);
      Engine.UseSkill(SpSweepSkill);
      Delay(400);
    end;
  end;
  for i := DropList.Count - 1 downto 0 do begin
    if User.Dead or NeedReturn then exit;
    if i >= DropList.Count then continue;   // the list shrinks while we pick up
    DX := DropList(i).X;
    DY := DropList(i).Y;
    DZ := DropList(i).Z;
    if User.DistTo(DX, DY, DZ) > SP_PICKUP_RANGE then continue;
    MoveWait(DX, DY, DZ);
    Engine.Pickup;
    Delay(400);
  end;
end;

// kill one mob to the end. Rebuffing = called by the rebuff (farm paused): only death / return
// stop it. Skipped for SP_IGNORE_MS: cannot get to it for SP_APPROACH_MS, stuck on the way for
// SP_STUCK_MS, or its HP does not drop for SP_NODMG_MS (unreachable / stale "attacks us" flag)
procedure SpKillMob(OID: integer; Rebuffing: boolean);
var Idx, MX, MY, MZ, HP, LastHP, UX, UY, LastUX, LastUY, Other: integer;
  FarSince, HPSince, MovedSince: cardinal;
  Force: boolean;
  DX, DY: double;
begin
  FarSince := 0;
  LastHP := -1;
  HPSince := GetTickCount;
  LastUX := User.X;
  LastUY := User.Y;
  MovedSince := GetTickCount;
  while true do begin
    if User.Dead or NeedReturn then exit;
    if (not Rebuffing) and AoeMustStop() then exit;
    Idx := SpMobIdx(OID);
    if Idx < 0 then exit;
    if NpcList(Idx).Dead then begin
      SpAfterKill(OID);
      exit;
    end;
    MX := NpcList(Idx).X;
    MY := NpcList(Idx).Y;
    MZ := NpcList(Idx).Z;

    // our mob does not fight us, but another one does -> switch to it (our mob is not skipped,
    // it is taken again after the fight)
    if not SpOnUs(Idx) then begin
      Other := SpPickTarget(true);
      if (Other <> 0) and (Other <> OID) then begin
        SpTarget := 0;
        exit;
      end;
    end;

    // HP does not drop -> we cannot hurt it (unreachable, or it does not really fight us)
    // (counted only while we are next to it: running to it is not "no damage")
    HP := NpcList(Idx).CurHP;
    if (HP <> LastHP) or (SpDist(Idx) > SpRange) then begin
      LastHP := HP;
      HPSince := GetTickCount;
    end;
    if GetTickCount - HPSince >= SP_NODMG_MS then begin
      Engine.Msg('[Spoil]', 'No damage on ' + NpcList(Idx).Name + ', skipping it for a while', 0);
      SpIgnore(OID);
      Engine.CancelTarget;
      SpTarget := 0;
      exit;
    end;

    // are we really moving?
    UX := User.X;
    UY := User.Y;
    DX := UX - LastUX;
    DY := UY - LastUY;
    if Sqrt(DX * DX + DY * DY) > 30 then begin
      LastUX := UX;
      LastUY := UY;
      MovedSince := GetTickCount;
    end;

    Force := false;
    if SpDist(Idx) > SpRange then begin
      if FarSince = 0 then begin
        FarSince := GetTickCount;
        MovedSince := GetTickCount;
      end;
      if SpOnUs(Idx) then begin
        // it hits us -> it is reachable: keep running to it, no skip for being stuck
        // (only a safety limit of 2 x SP_APPROACH_MS for a stale "attacks us" flag)
        if GetTickCount - FarSince >= 2 * SP_APPROACH_MS then begin
          Engine.Msg('[Spoil]', 'Cannot get to ' + NpcList(Idx).Name + ' (aggro), skipping it for a while', 0);
          SpIgnore(OID);
          SpTarget := 0;
          exit;
        end;
      end else if (GetTickCount - FarSince >= SP_APPROACH_MS) or
                  (GetTickCount - MovedSince >= SP_STUCK_MS) then begin
        Engine.Msg('[Spoil]', 'Cannot get to ' + NpcList(Idx).Name + ', skipping it for a while', 0);
        SpIgnore(OID);
        SpTarget := 0;
        exit;
      end;
    end else
      FarSince := 0;
    SpFightStep(OID, Force);
    Delay(150);
  end;
end;

// rebuff / leaving combat: kill everything that hits us
procedure SpKillAggro();
var OID: integer;
begin
  while (not User.Dead) and (not NeedReturn) do begin
    OID := SpPickTarget(true);
    if OID = 0 then exit;
    SpKillMob(OID, true);
  end;
end;

procedure SpoilFarm_Thread();
var OID: integer;
begin
  while Delay(200) do begin
    if AoeMustStop() or TreeBusy then continue;
    if (BuffID <> 0) and (BuffTime(BuffID) < REBUFF_TIME) then begin
      // rebuff first: no new mobs, but what hits us is killed
      OID := SpPickTarget(true);
      if OID <> 0 then SpKillMob(OID, false);
      continue;
    end;
    OID := SpPickTarget(false);
    if OID = 0 then begin
      // no mobs: safe point (SetSafePoint) / patrol / back to the spot start
      if HasSafePoint then MoveWait(SafeX, SafeY, SafeZ)
      else if HasPatrol() then PatrolStep()
      else AoeRunToSpot();
      continue;
    end;
    SpKillMob(OID, false);
  end;
end;

// ===================== Self buffs (AddSelfBuff) =====================
// Every second: a watched buff is gone and its skill is out of reuse -> cast the skill on self.
// Not while travelling / recovering / dead.

// the character has this skill (it is in its skill list)
function HasSkill(ID: integer): boolean;
var i, SID: integer;
begin
  result := false;
  for i := 0 to SkillList.Count - 1 do begin
    SID := SkillList(i).ID;
    if SID = ID then begin
      result := true;
      exit;
    end;
  end;
end;

procedure SelfBuff_Thread();
var i, SkillID, ID: integer;
  Told: array of boolean;
begin
  SetLength(Told, Length(SelfBuffSkill));
  for i := 0 to Length(Told) - 1 do Told[i] := false;
  while Delay(1000) do begin
    if User.Dead or (not IsOnline()) or IsRecovering or NeedReturn then continue;
    if SkillList.Count = 0 then continue;         // the skill list is not loaded yet (just logged in)
    for i := 0 to Length(SelfBuffSkill) - 1 do begin
      SkillID := SelfBuffSkill[i];
      ID := SelfBuffID[i];
      if not HasSkill(SkillID) then begin          // this character has no such skill: never cast it
        if not Told[i] then begin
          Engine.Msg('[SelfBuff]', 'No skill ' + IntToStr(SkillID) + ' on this character - own buff skipped', 128);
          Told[i] := true;
        end;
        continue;
      end;
      if BuffTime(ID) > 0 then continue;          // still on us
      if SpSkillLeft(SkillID) > 0 then continue;  // reuse
      Engine.Msg('[SelfBuff]', 'Buff ' + IntToStr(ID) + ' is gone, casting ' + IntToStr(SkillID), 0);
      Engine.UseSkill(SkillID);
      Delay(1500);
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
    MoveServer(TX, TY, TZ);
    Delay(PATROL_STEP_MS);
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

// mobs on us for ClearCombat (spoil mode: only those SpKillAggro would take)
function CombatAggro(): boolean;
begin
  if SpoilEnabled or PackEnabled then result := SpPickTarget(true) <> 0
  else result := HaveAgroMobs();
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

    // 1) kill everything that is on us (profile mode: the profile kills them, AoE mode: the script)
    if CombatAggro() then begin
      Engine.Msg('[Rebuff]', 'Mobs on me, killing them', 128);
      if AoeEnabled then begin
        FarmOff();          // no new pulls, just kill what is on us
        AoeFightPack();
      end else if CasterEnabled then begin
        FarmOff();
        CasterKillAggro();
      end else if SpoilEnabled or PackEnabled then begin
        FarmOff();
        SpKillAggro();
      end else begin
        FarmOn();
        Wait := 0;
        while CombatAggro() and (Wait < 220) do begin
          if User.Dead or NeedReturn then exit;
          Delay(555); Inc(Wait);
        end;
      end;
    end;

    // 2) nobody on us now: stop farm and wait for the combat flag to drop
    FarmOff();
    Wait := 0;
    while User.InCombat and (not CombatAggro()) and (Wait < 40) do begin
      if User.Dead or NeedReturn then exit;
      Delay(555); Inc(Wait);
    end;

    // 3) somebody hit us again -> back to killing (farm is switched on in step 1)
    if CombatAggro() then begin
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
var i: integer;
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
  if NavZoneName <> '' then NavSetZone(NavZoneName)   // the map for runs: SetNavZone,
  else NavSetZone(ZoneName);           //   else the farm zone (SetNavGrid wins over both)
  if not PkAreaSet then begin
    PkAreaSet := true;
    if PkPullGrid <> '' then begin
      PullSetGrid(PkPullGrid);         // mobs only on the grid's walkable cells
      PkLoadMapExtras(PkPullGrid);     // rooms / farm spots / safe point drawn in the viewer
    end
    else if UseRadius then PullSetRadius(HomeX, HomeY, FREE_RADIUS);   // else the bot zone
  end;
  for i := 0 to Length(PkCorners) div 3 - 1 do NavAddSeed(PkCorners[i * 3], PkCorners[i * 3 + 1]);
  if HasSafePoint then NavAddSeed(SafeX, SafeY);   // these places are walkable: the trace keeps their pieces
  NavBuild();                          // once: the graph
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
    MoveWait(X, Y, Z);
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
    MoveWait(SafeX, SafeY, SafeZ);
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

// nearest alive mob that hits us within SAFE_AGGRO_RANGE (also archers / casters hitting
// from range - we go and kill them); farther ones are ignored
function NearAggroOID(): integer;
var i, NX, NY, NZ: integer;
  D, BestD: double;
begin
  result := 0;
  BestD := 999999;
  for i := 0 to NpcList.Count - 1 do begin
    if not IsAgr(NpcList(i)) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    D := User.DistTo(NX, NY, NZ);
    if D > SAFE_AGGRO_RANGE then continue;
    if D < BestD then begin
      BestD := D;
      result := NpcList(i).OID;
    end;
  end;
end;

// the script itself kills one mob that hits us (the interface is OFF here)
procedure SafeFightStep(OID: integer);
begin
  if SpoilEnabled or PackEnabled then begin
    SpFightStep(OID, false);
    Delay(150);
    exit;
  end;
  if AoeEnabled then begin
    AoeFightPack();
    exit;
  end;
  if CasterEnabled then begin
    CasterFightStep(OID);
    Delay(200);
    exit;
  end;
  Engine.SetTarget(OID);
  Engine.Attack(500);
end;

// Rebuff with a safe point: interface OFF -> run to the safe point (no fighting on the way) ->
// there kill everybody who came after us and wait until we are out of combat -> true.
// Keeps trying until it works; false only on death / return.
// kill this mob to the end (max 60 sec: unreachable / bugged mob)
procedure SafeKillMob(OID: integer);
var i, Idx: integer;
  Started: cardinal;
begin
  Started := GetTickCount;
  while (not User.Dead) and (not NeedReturn) and (GetTickCount - Started < 60000) do begin
    Idx := -1;
    for i := 0 to NpcList.Count - 1 do
      if NpcList(i).OID = OID then begin Idx := i; break; end;
    if (Idx < 0) or NpcList(Idx).Dead then exit;
    SafeFightStep(OID);
  end;
end;

function SafePointClear(): boolean;
var OID, Tries: integer;
begin
  result := false;
  FarmOff();
  Engine.Msg('[Rebuff]', 'Interface OFF, running to the safe point', 0);
  Tries := 0;
  while (User.DistTo(SafeX, SafeY, SafeZ) > 150) and (Tries < 5) do begin
    if User.Dead or NeedReturn then exit;
    MoveWait(SafeX, SafeY, SafeZ);
    Inc(Tries);
  end;

  // at the safe point: a mob hits us -> kill it to the end -> back to the safe point;
  // again and again until we are out of combat
  while true do begin
    if User.Dead or NeedReturn then exit;
    OID := NearAggroOID();
    if OID <> 0 then begin
      SafeKillMob(OID);
      if User.Dead or NeedReturn then exit;
      Engine.CancelTarget;
      MoveWait(SafeX, SafeY, SafeZ);
      continue;
    end;
    if User.DistTo(SafeX, SafeY, SafeZ) > 150 then begin
      MoveWait(SafeX, SafeY, SafeZ);
      continue;
    end;
    if not User.InCombat then break;
    Delay(300);
  end;
  Engine.CancelTarget;
  Engine.Msg('[Rebuff]', 'Out of combat at the safe point', 0);
  result := true;
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
  MoveWait(GK_X, GK_Y, GK_Z);
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

// SetSecondTeleport: run to the NPC near the landing, open its dialog, send the bypasses one
// after another; true only if we really moved away (max 3 tries)
function SecondTeleport(): boolean;
var i, k, Idx, NpcOID, NX, NY, NZ, Tries: integer;
begin
  result := false;
  Engine.Msg('[Return]', 'Second teleport via NPC ' + IntToStr(SecondNpcID), 0);
  for Tries := 1 to 3 do begin
    if User.Dead then exit;
    // the NPC may show up a moment after the landing
    Idx := -1;
    for k := 1 to 20 do begin
      for i := 0 to NpcList.Count - 1 do
        if NpcList(i).ID = SecondNpcID then begin Idx := i; break; end;
      if Idx >= 0 then break;
      Delay(250);
    end;
    if Idx < 0 then begin
      Engine.Msg('[Return]', 'NPC ' + IntToStr(SecondNpcID) + ' not found nearby!', 128);
      exit;
    end;
    NpcOID := NpcList(Idx).OID;
    NX := NpcList(Idx).X;
    NY := NpcList(Idx).Y;
    NZ := NpcList(Idx).Z;
    MoveWait(NX, NY, NZ);
    Engine.SetTarget(NpcOID);
    Delay(800);
    if Engine.DlgOpen(SecondNpcID) then begin
      Delay(1500);
      for i := 0 to Length(SecondBypasses) - 1 do begin
        Engine.BypassToServer(SecondBypasses[i]);
        Delay(1500);
      end;
      Engine.ConfirmDialog(true);
      Delay(4000);
      if User.DistTo(NX, NY, NZ) > 3000 then begin
        Engine.Msg('[Return]', 'Second teleport done!', 128);
        result := true;
        exit;
      end;
    end;
    Engine.Msg('[Return]', 'Second teleport try #' + IntToStr(Tries) + ' failed, retry...', 128);
    Delay(2000);
  end;
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
    if (SecondNpcID > 0) and (not SecondTeleport()) then begin
      Engine.Msg('[GoToSpot]', 'Second teleport failed, farm is OFF', 128);
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
  Fails, Tries: integer;
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

      // --- safe point set: interface OFF, run there, fight back there until out of combat ---
      if OnSpot and PackEnabled then begin
        // pack farm: the pack thread runs to the safe point (none: stays) and kills what follows there
        // (splash, mass spoil, sweep); we wait until it is clear, then the farm is off for the buff.
        // Up to 3 min: a big pack takes long, the farm is never paused in the middle of it
        Tries := 0;
        while (not PkSafeReady) and (not User.Dead) and (not NeedReturn) and (Tries < 1800) do begin
          Delay(100);
          Inc(Tries);
        end;
        if User.Dead or NeedReturn then continue;
        if PkSafeReady then FarmOff()
        else if HasSafePoint then begin
          if not SafePointClear() then continue;   // the pack thread did not make it in 60 s
        end else if not ClearCombat() then continue;
        Delay(500);
      end else
      if OnSpot and HasSafePoint then begin
        if not SafePointClear() then continue;   // died / going back via Aden
        Delay(500);
      end else
      // --- no safe point: fight off mobs and leave combat right here (only on the spot) ---
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

// OID of the current target, 0 if none. The target object is taken once and checked for nil, no try:
// a try round a target that is gone (the mob / we died) broke the script ("Invalid pointer operation")
function TargetOID(): integer;
var T: TL2Live;
begin
  result := 0;
  T := User.Target;
  if T <> nil then result := T.OID;
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
  MoveWait(BackoffX, BackoffY, UZ);
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
        MoveWait(BackoffX, BackoffY, UZ);
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
  if GaveUp and HasSafePoint then MoveWait(SafeX, SafeY, SafeZ);
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
    if (not IsOnline()) or User.Dead or TreeBusy or PkDaggerOn or PullTapActive() then continue;   // tree handler wears the bow / dagger on a fat mob on purpose
    if IsEquipped(WeaponID) then continue;
    Engine.Msg('[Weapon]', 'Weapon ' + IntToStr(WeaponID) + ' is not on (disarm?), equipping', 128);
    EquipWeapon(WeaponID);
  end;
end;

// ===================== Pack farm (SetPackFarm): body pull -> corner -> auto attack =====================
// No interface. Body pull with the server path: run next to free mobs until PkPackSize of them
// follow us; run to the nearest corner point (AddCorner) so the pack stacks up in one spot;
// mass spoil; auto attack, switching the target all the time to the mob that puts the most other
// mobs into the splash of the auto attack (vampiric from auto attacks works on all of them);
// mass sweep the corpses before they vanish; pick up. A fat mob (champion) left alone ->
// dagger on (SetPackDagger) until it dies, then the main weapon back. Loops tick every PK_TICK_MS.

// distance on the ground from us
function PkDist(X, Y: integer): double;
var UX, UY: integer;
  DX, DY: double;
begin
  UX := User.X;
  UY := User.Y;
  DX := X - UX;
  DY := Y - UY;
  result := Sqrt(DX * DX + DY * DY);
end;

// SetZRange: the mob height is close enough to ours
function PkZOk(Z: integer): boolean;
var UZ: integer;
begin
  UZ := User.Z;
  result := (PkZRange <= 0) or (Abs(Z - UZ) <= PkZRange);
end;

// wall check: a new run starts now
procedure PkMoveReset();
begin
  PkLX := User.X;
  PkLY := User.Y;
  PkMovedAt := GetTickCount;
end;

// wall check: ms since we really moved (10+ on the ground)
function PkStillMs(): cardinal;
var UX, UY: integer;
begin
  UX := User.X;
  UY := User.Y;
  if (UX - PkLX) * (UX - PkLX) + (UY - PkLY) * (UY - PkLY) >= 100 then begin
    PkLX := UX;
    PkLY := UY;
    PkMovedAt := GetTickCount;
  end;
  result := GetTickCount - PkMovedAt;
end;

// one server-path click, remembered. The click is NOT repeated on a timer: every new click makes
// the server build the path again from where we are, and its first node may lie behind us -
// that was the run forth and back
procedure PkClick(X, Y, Z: integer);
begin
  MoveServer(X, Y, Z);
  PkClickX := X;
  PkClickY := Y;
  PkClickAt := GetTickCount;
end;

// click again only when the goal moved away from our click point, or we stopped short
function PkNeedClick(X, Y: integer): boolean;
var DX, DY: double;
begin
  result := true;
  if PkClickAt = 0 then exit;
  DX := X - PkClickX;
  DY := Y - PkClickY;
  if Sqrt(DX * DX + DY * DY) > PK_RECLICK_DIST then exit;
  result := (PkStillMs() >= PK_STOP_MS) and (GetTickCount - PkClickAt >= PK_STOP_MS);
end;

// shooters / aggro are kept by the pull module (Core\mob_pull.pas)
function PkIsShooter(OID: integer): boolean;
begin
  result := PullIsShooter(OID);
end;

procedure PkCheckShooters();
begin
  PullCheckShooters();
end;

function PkAggro(i: integer): boolean;
begin
  result := PullIsAggro(i);
end;

function PkCountAggro(): integer;
begin
  result := PullCountAggro();
end;

// run to the point with the server path and stand within Radius of it (on the ground).
// The click is repeated only when we stopped short of the point (see PkClick)
function MoveExactPlain(X, Y, Z, Radius: integer): boolean;
var Started: cardinal;
  Stops: integer;
  D: double;
begin
  result := false;
  Started := GetTickCount;
  Stops := 0;
  PkMoveReset();
  PkClick(X, Y, Z);
  while not User.Dead do begin
    D := PkDist(X, Y);
    if D <= Radius then begin
      result := true;
      exit;
    end;
    if GetTickCount - Started > MOVE_WAIT_MS then exit;
    if PkStillMs() > PK_POINT_STUCK_MS then exit;     // wall: the server finds no way there
    PullTapRestore();                  // the farm weapon goes back on while we run (no-op if done)
    if PkNeedClick(X, Y) then begin
      // stopped short: a few times close to the point = the server cannot put us nearer
      Inc(Stops);
      if (Stops >= 3) and (D <= PK_NEAR_OK) then begin
        result := true;
        exit;
      end;
      PkClick(X, Y, Z);
    end;
    Delay(PK_TICK_MS);
  end;
end;

// MoveExactPlain; behind a wall on the map -> along the graph first; stuck -> the graph
function MoveExact(X, Y, Z, Radius: integer): boolean;
begin
  if NavIsReady() and (not NavIsBusy()) and (not NavSeeFromUs(X, Y)) then NavGraphTo(X, Y, Z);
  result := MoveExactPlain(X, Y, Z, Radius);
  if result or User.Dead or NavIsBusy() or (not NavIsReady()) then exit;
  if NavGraphTo(X, Y, Z) then result := MoveExactPlain(X, Y, Z, Radius);
  if (not result) and (not User.Dead) then
    if NavUnstick() then begin end;    // stuck: out of there for the next try
end;

// [State]: what the farm does now and why - said when it changes, repeated every 30 s
procedure PkState(S: string);
begin
  if not PkDebugSet then begin
    PkDebug := 1;
    PkDebugSet := true;
  end;
  if PkDebug <= 0 then exit;
  if (S = PkLastState) and (GetTickCount - PkStateAt < 30000) then exit;
  PkLastState := S;
  PkStateAt := GetTickCount;
  Engine.Msg('[State]', S, 0);
end;

// why the farm stands still (AoeMustStop)
function PkStopReason(): string;
begin
  if User.Dead then result := 'dead'
  else if not IsOnline() then result := 'offline'
  else if NeedReturn then result := 'going back via Aden'
  else if IsRecovering then result := 'recovering'
  else if not OnSpot then result := 'not on the spot yet'
  else if FarmPaused then result := 'farm paused (rebuff / safe point / script)'
  else result := 'tree mob handler busy';
end;

// no mobs at all: stand at the safe point / patrol / the spot start
procedure PkIdle();
begin
  if HasSafePoint then MoveExact(SafeX, SafeY, SafeZ, PK_REACH)
  else if HasPatrol() then PatrolStep()
  else AoeRunToSpot();
end;

// the weapon in hands right now (right hand / two hands); 0 = none
function PkCurrentWeapon(): integer;
var i, Part: integer;
begin
  result := 0;
  RefreshInventory();
  for i := 0 to Inventory.User.Count - 1 do begin
    if not Inventory.User.Items(i).Equipped then continue;
    Part := Inventory.User.Items(i).BodyPart;
    if (Part = WEAPON_SLOT_RHAND) or (Part = WEAPON_SLOT_LRHAND) then begin
      result := Inventory.User.Items(i).ID;
      exit;
    end;
  end;
end;

// the farm weapon back after a pull with the tap weapon (pull module; call every tick until done)
procedure PkTapRestore();
begin
  PullTapRestore();
end;

// index of the corner point nearest to us; -1 = no corners
function PkNearestCorner(): integer;
var k, n: integer;
  D, BestD: double;
begin
  result := -1;
  BestD := 999999;
  n := Length(PkCorners) div 3;
  for k := 0 to n - 1 do begin
    D := PkDist(PkCorners[k * 3], PkCorners[k * 3 + 1]);
    if D < BestD then begin
      BestD := D;
      result := k;
    end;
  end;
end;

// every mob of the pack stands close to us
function PkStacked(): boolean;
var i, NX, NY: integer;
begin
  result := true;
  for i := 0 to NpcList.Count - 1 do
    if PkAggro(i) then begin
      NX := NpcList(i).X;
      NY := NpcList(i).Y;
      if PkDist(NX, NY) > PK_STACK_DIST then begin
        result := false;
        exit;
      end;
    end;
end;

// the best farm spot (SetFarmSpots) for the pack (NavSpotAddMob done): within the corner search range,
// scored on the nav map like a corner (the pack does not see it, a sharp turn round the corner, a
// long shielding wall, not through the pack); a spot of yours gets a bonus over a found corner.
// Without a nav map: the nearest one not through the pack. -1 = none fits
// the farm spot k is for room n: the rooms set for it in the viewer, none set -> by place (inside the
// room / in the passage up to 500 out, nearest room)
function PkSpotFor(k, n: integer): boolean;
var L, SX, SY: integer;
  R: string;
begin
  R := PkSpotRooms[k];
  if R <> '' then begin
    L := Pos(',' + UpperCase(RoomName(n)) + ',', R);
    result := L > 0;
    exit;
  end;
  SX := PkSpotX[k];
  SY := PkSpotY[k];
  result := RoomOfSpot(SX, SY) = n;
end;

function PkPickSpot(UX, UY, CX, CY: integer): integer;
var k, SX, SY, Range, Nearest: integer;
  D, Best, Sc, DUC, DSC, DX, DY, NearD: double;
begin
  result := -1;
  if PkSpotN = 0 then exit;
  Range := PkAutoCorner;
  if Range <= 0 then Range := 1500;
  if (PkRoomSel > 0) or PkSpotsOnly then Range := 999999;   // rooms / only the spots: however far
  Nearest := -1;
  NearD := 1E18;
  DX := CX - UX;
  DY := CY - UY;
  DUC := Sqrt(DX * DX + DY * DY);
  Best := -1;
  for k := 0 to PkSpotN - 1 do begin
    SX := PkSpotX[k];
    SY := PkSpotY[k];
    if (PkRoomSel > 0) and (not PkSpotFor(k, PkRoomSel - 1)) then continue;   // rooms: its own (set / in / near it)
    DX := SX - UX;
    DY := SY - UY;
    D := Sqrt(DX * DX + DY * DY);
    if D > Range then continue;
    if D < NearD then begin            // the nearest one - taken when none passes the corner test
      NearD := D;
      Nearest := k;
    end;
    if NavIsReady() then begin
      Sc := NavSpotScore(SX, SY, UX, UY, CX, CY);
      if Sc < 0 then continue;
      Sc := Sc + 30;                   // yours: a bonus
    end else begin
      DX := SX - CX;
      DY := SY - CY;
      DSC := Sqrt(DX * DX + DY * DY);
      if DSC < DUC * 0.8 then continue;
      Sc := 10000 - D;
    end;
    if Sc > Best then begin
      Best := Sc;
      result := k;
    end;
  end;
  // your spots come first: none passed the corner test -> the nearest of yours anyway
  if result < 0 then result := Nearest;
end;

// run to the nearest corner (within PK_REACH); the fight starts right away, no wait for the
// whole pack (while we hit we live)
// the way in to the spot S round a corner: B (S not seen from it, nor from the middle of B-E) ->
// E (sees S, the turn at E 80+ degrees) -> S. The pack runs behind us B -> E, sees S only at E and
// turns round the corner there - it comes to S bunched. B nearest to us; false = no such way
function PkPlanLead(SX, SY: integer): boolean;
var a, b, r, EX, EY, BX, BY, MX, MY, UX, UY: integer;
  Ang, C, DES, Sc, Best, DU, DS: double;
begin
  result := false;
  if not NavIsReady() then exit;
  UX := User.X;
  UY := User.Y;
  DS := PkDist(SX, SY);
  Best := 1E18;
  for r := 1 to 3 do
    for a := 0 to 15 do begin
      Ang := a * 3.14159265 / 8;
      EX := SX + Round(Cos(Ang) * (50 + r * 100));
      EY := SY + Round(Sin(Ang) * (50 + r * 100));
      if not NavIsFree(EX, EY) then continue;
      if not NavSee(SX, SY, EX, EY) then continue;
      DES := Sqrt(Sqr(SX - EX) + Sqr(SY - EY));
      for b := 0 to 15 do begin
        Ang := b * 3.14159265 / 8;
        BX := EX + Round(Cos(Ang) * PK_LEAD_B);
        BY := EY + Round(Sin(Ang) * PK_LEAD_B);
        C := ((BX - EX) * (SX - EX) + (BY - EY) * (SY - EY)) / (PK_LEAD_B * DES);
        if C > 0.17 then continue;     // the turn at E under 80 degrees
        DU := Sqrt(Sqr(BX - UX) + Sqr(BY - UY));
        Sc := DU + C * 200;            // near us, the sharper turn the better
        if Sc >= Best then continue;
        if DU > DS + 600 then continue;   // a long way round is not worth it
        if not NavIsFree(BX, BY) then continue;
        if not NavSee(EX, EY, BX, BY) then continue;
        if NavSee(BX, BY, SX, SY) then continue;
        MX := (BX + EX) div 2;
        MY := (BY + EY) div 2;
        if NavSee(MX, MY, SX, SY) then continue;
        Best := Sc;
        PkLeadBX := BX;
        PkLeadBY := BY;
        PkLeadEX := EX;
        PkLeadEY := EY;
        result := true;
      end;
    end;
end;

// a run with the pack behind: along the nav map, never stopping; a pack mob about to lose us ->
// zigzag until it catches up (Core\mob_pull.pas, leash_range). true = within Radius
function PkLeadTo(X, Y, Z, Radius: integer): boolean;
var Started: cardinal;
  TX, TY: integer;
begin
  result := false;
  Started := GetTickCount;
  PkMoveReset();
  PkClickAt := 0;
  while (not User.Dead) and (not NeedReturn) and (not FarmPaused) do begin
    if PkDist(X, Y) <= Radius then begin
      result := true;
      exit;
    end;
    if GetTickCount - Started > MOVE_WAIT_MS then exit;
    PullTapRestore();
    if PullLeashTick() then begin      // zigzag: the click is the pull module's
      PkMoveReset();
      PkClickAt := 0;
      Delay(PK_TICK_MS);
      continue;
    end;
    TX := X;
    TY := Y;
    if NavIsReady() and NavWaypoint(X, Y) then begin
      TX := NavWpX();
      TY := NavWpY();
    end;
    if PkNeedClick(TX, TY) then PkClick(TX, TY, Z);
    if PkStillMs() > PK_POINT_STUCK_MS then begin
      if NavUnstick() then begin end;  // out of the stuck place; the caller goes on (or MoveExact)
      exit;
    end;
    Delay(PK_TICK_MS);
  end;
end;

// to the farm spot with the pack: round the corner when there is such a way in, the leash all the way.
// NOT USED now: the mobs behaved worse with it - PkGather runs with MoveExact as before
procedure PkLeadRun(SX, SY, SZ: integer);
var BX, BY, EX, EY: integer;
  Ok: boolean;
begin
  if PkPlanLead(SX, SY) then begin
    BX := PkLeadBX;
    BY := PkLeadBY;
    EX := PkLeadEX;
    EY := PkLeadEY;
    Engine.Msg('[Pack]', 'Lead round the corner: ' + IntToStr(BX) + ', ' + IntToStr(BY) + ' -> turn at ' +
      IntToStr(EX) + ', ' + IntToStr(EY) + ' -> spot', 0);
    Ok := PkLeadTo(BX, BY, SZ, 70);
    if Ok then Ok := PkLeadTo(EX, EY, SZ, 50);
  end;
  if not PkLeadTo(SX, SY, SZ, PK_REACH) then MoveExact(SX, SY, SZ, PK_REACH);
end;

procedure PkGather();
var i, k, NX, NY, CX, CY, n, UX, UY, UZ, Far: integer;
begin
  n := 0;
  // SetAutoCorner: a spot round a wall corner found on the map - the pack runs round the corner
  // and bunches up on us there
  if ((PkAutoCorner > 0) and NavIsReady()) or (PkSpotN > 0) then begin
    CX := 0;
    CY := 0;
    n := 0;
    NavSpotClear();                    // every mob of the pack: none of them may see the spot
    for i := 0 to NpcList.Count - 1 do
      if PkAggro(i) then begin
        NX := NpcList(i).X;
        NY := NpcList(i).Y;
        CX := CX + NX;
        CY := CY + NY;
        NavSpotAddMob(NX, NY);
        Inc(n);
      end;
    UX := User.X;
    UY := User.Y;
    UZ := User.Z;
    if n > 0 then begin
      CX := CX div n;                  // where the pack comes from
      CY := CY div n;
      // the perfect farm spots first (#f of nav_trace), if one fits this pack
      k := PkPickSpot(UX, UY, CX, CY);
      if k >= 0 then begin
        PkCorner := 0;
        PkCX := PkSpotX[k];
        PkCY := PkSpotY[k];
        PkCZ := PkSpotZ[k];
        if PkCZ = 0 then PkCZ := UZ;
        Engine.Msg('[Pack]', 'Pack ' + IntToStr(n) + ' -> farm spot ' + IntToStr(k + 1), 0);
        MoveExact(PkCX, PkCY, PkCZ, PK_REACH);   // a server-path click (as it always was); stuck -> NavUnstick
        exit;
      end;
      if PkSpotsOnly and (PkSpotN > 0) then begin   // only the spots: none here -> fight where we are
        Far := 0;                      // (here: the spots of this room, for the message)
        for i := 0 to PkSpotN - 1 do
          if (PkRoomSel > 0) and PkSpotFor(i, PkRoomSel - 1) then Inc(Far);
        Engine.Msg('[Pack]', 'No farm spot taken (pack ' + IntToStr(n) + ', spots ' + IntToStr(PkSpotN) +
          ', room ' + IntToStr(PkRoomSel - 1) + ' has ' + IntToStr(Far) + ') - fight here', 0);
        exit;
      end;
      // a good corner near; none -> look twice as far (a good corner is worth the run)
      Far := PkAutoCorner * 2;
      if Far > 1500 then Far := 1500;
      if (PkAutoCorner > 0) and NavIsReady() and
         (NavFindCornerSpot(UX, UY, CX, CY, PkAutoCorner) or NavFindCornerSpot(UX, UY, CX, CY, Far)) then begin
        PkCorner := 0;
        PkCX := NavSpotX();
        PkCY := NavSpotY();
        PkCZ := UZ;
        Engine.Msg('[Pack]', 'Pack ' + IntToStr(n) + ' -> round the corner at ' + IntToStr(PkCX) + ', ' + IntToStr(PkCY), 0);
        MoveExact(PkCX, PkCY, PkCZ, PK_REACH);   // a server-path click (as it always was); stuck -> NavUnstick
        exit;
      end;
    end;
  end;
  PkCorner := PkNearestCorner();
  if PkCorner < 0 then begin          // no corners: fight where we stand
    Engine.Msg('[Pack]', 'No farm spot / corner (pack mobs counted ' + IntToStr(n) + ', spots ' + IntToStr(PkSpotN) + ') - fight here', 0);
    exit;
  end;
  PkCX := PkCorners[PkCorner * 3];
  PkCY := PkCorners[PkCorner * 3 + 1];
  PkCZ := PkCorners[PkCorner * 3 + 2];
  Engine.Msg('[Pack]', 'Pack ' + IntToStr(PkCountAggro()) + ' -> corner ' + IntToStr(PkCorner + 1), 0);
  MoveExact(PkCX, PkCY, PkCZ, PK_REACH);
end;

// a mob of the pack we fight: alive, on us, within PK_FIGHT_RANGE, not a shooter. Skipped
// (wall) mobs count too: once the pack is at the corner it is finished, not left for a new pull
function PkFightMob(i: integer): boolean;
var Atk, Tgt, NX, NY, NZ, OID: integer;
begin
  result := false;
  if i >= NpcList.Count then exit;     // the list got shorter while we walk it
  if NpcList(i).Dead then exit;
  OID := NpcList(i).OID;
  if PkIsShooter(OID) then exit;
  Atk := NpcList(i).AtkOID;
  Tgt := PullMobTarget(i);
  if (Atk <> User.OID) and (Tgt <> User.OID) then exit;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  result := (PkDist(NX, NY) <= PK_FIGHT_RANGE) and PkZOk(NZ);
end;

// all mobs under the last mass spoil answered "spoiled": exactly those (taken at the cast) are
// marked - a mob that showed up after the cast was not hit
procedure PkMarkSpoiled();
var j, k, OID: integer;
  Found: boolean;
begin
  for j := 0 to PkSnapN - 1 do begin
    OID := PkSnapOID[j];
    Found := false;
    for k := 0 to 63 do
      if PkSpoiledOID[k] = OID then begin
        Found := true;
        break;
      end;
    if Found then continue;
    PkSpoiledOID[PkSpoiledHead] := OID;
    PkSpoiledHead := (PkSpoiledHead + 1) mod 64;
  end;
end;

// a pack mob next to us that no mass spoil has hit yet (came late, or spawned from a corpse)
function PkHasUnspoiled(): boolean;
var i, k, OID, NX, NY: integer;
  Found: boolean;
begin
  result := false;
  for i := 0 to NpcList.Count - 1 do begin
    if not PkFightMob(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    if PkDist(NX, NY) > PK_HIT_RANGE then continue;
    OID := NpcList(i).OID;
    Found := false;
    for k := 0 to 63 do
      if PkSpoiledOID[k] = OID then begin
        Found := true;
        break;
      end;
    if not Found then begin
      result := true;
      exit;
    end;
  end;
end;

// a mass spoil is cast now: start counting its messages
procedure PkSpoilCountReset();
begin
  SpSpoilMsg();                        // old lines / flag belong to nobody
  PkEvSpoil := 0;
  PkHistSpoil := 0;
end;

// spoil messages since PkSpoilCountReset: "spoil condition has been activated" (spoiled now) +
// "already been spoiled" - one per mob hit by the mass spoil. The event and the chat history are
// two sources of the same lines: the bigger count wins
function PkSpoilCount(): integer;
var i, n: integer;
  M: TChatMessage;
  T: string;
begin
  n := History.Count(mtSystem);        // no try: see SpSpoilMsg
  for i := 0 to n - 1 do begin
    if i >= History.Count(mtSystem) then break;
    M := History.GetMessage(i, mtSystem);
    if M.OID <= SpLastSysOID then continue;
    SpLastSysOID := M.OID;
    T := LowerCase(M.Text);
    if (Pos('spoil condition has been activated', T) > 0) or
       (Pos('already been spoiled', T) > 0) then Inc(PkHistSpoil);
  end;
  result := PkEvSpoil;
  if PkHistSpoil > result then result := PkHistSpoil;
  if result > 0 then PkSeenSpoilMsg := true;
end;

// a mass spoil is cast now: remember every live mob close enough to be hit (aggro or not - each one
// answers with a spoil message); result = how many
function PkSnapSpoilArea(): integer;
var i, NX, NY: integer;
begin
  PkSnapN := 0;
  for i := 0 to NpcList.Count - 1 do begin
    if NpcList(i).Dead or IsIgnoredNpc(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    if PkDist(NX, NY) > PK_SPOIL_AREA then continue;
    if PkSnapN > 31 then break;
    PkSnapOID[PkSnapN] := NpcList(i).OID;
    Inc(PkSnapN);
  end;
  result := PkSnapN;
end;

function PkCountFight(): integer;
var i: integer;
begin
  result := 0;
  for i := 0 to NpcList.Count - 1 do
    if PkFightMob(i) then Inc(result);
end;

// the target within MaxReach that puts the most mobs of the pack into the splash of the auto
// attack (a cone of +-PK_SPLASH_ANGLE in front of us, PK_SPLASH_RANGE deep). Same count -> the
// lowest HP; out of the splash range -> the nearest. The current target is kept unless another one
// catches more. 0 = nobody within MaxReach
function PkBestTarget(CurOID, MaxReach: integer): integer;
var i, j, UX, UY, NX, NY, MX, MY, Score, BestScore, CurScore: integer;
  AX, AY, BX, BY, LA, LB, Tie, BestTie, CosLim, QX, QY: double;
begin
  result := 0;
  UX := User.X;
  UY := User.Y;
  CosLim := Cos(PK_SPLASH_ANGLE * 3.14159265 / 180);
  BestScore := -1;
  BestTie := 999999999;
  CurScore := -1;
  for i := 0 to NpcList.Count - 1 do begin
    if not PkFightMob(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    AX := NX - UX;
    AY := NY - UY;
    LA := Sqrt(AX * AX + AY * AY);
    if LA > MaxReach then continue;
    if (PkCorner >= 0) and (PkCornerR > 0) and (LA > PK_HIT_RANGE) then begin
      // SetCornerRadius: run only to mobs inside the corner zone, never to a wall-stuck one
      QX := NX - PkCX;
      QY := NY - PkCY;
      if Sqrt(QX * QX + QY * QY) > PkCornerR then continue;
      if SpIgnored(NpcList(i).OID) then continue;
    end;
    if LA > PK_SPLASH_RANGE then begin
      Score := 0;
      Tie := LA;                       // out of the splash: the nearest first
    end else begin
      Score := 1;
      for j := 0 to NpcList.Count - 1 do begin
        if (j = i) or (not PkFightMob(j)) then continue;
        MX := NpcList(j).X;
        MY := NpcList(j).Y;
        BX := MX - UX;
        BY := MY - UY;
        LB := Sqrt(BX * BX + BY * BY);
        if LB > PK_SPLASH_RANGE then continue;
        if (LA < 1) or (LB < 1) then begin
          Inc(Score);
          continue;
        end;
        if (AX * BX + AY * BY) / (LA * LB) >= CosLim then Inc(Score);
      end;
      Tie := NpcList(i).CurHP;         // same count: finish the weakest
    end;
    if NpcList(i).OID = CurOID then CurScore := Score;
    if (Score > BestScore) or ((Score = BestScore) and (Tie < BestTie)) then begin
      BestScore := Score;
      BestTie := Tie;
      result := NpcList(i).OID;
    end;
  end;
  if (CurScore >= 0) and (CurScore >= BestScore) then result := CurOID;
end;

// every mob left of the pack is fat (MaxHP above the SetPackDagger limit)
function PkOnlyFatLeft(): boolean;
var i, MaxHP, Lim: integer;
begin
  result := false;
  Lim := PkFatHP;
  if Lim <= 0 then Lim := ChampionMinHP;
  if Lim <= 0 then Lim := DEFAULT_CHAMPION_HP;
  for i := 0 to NpcList.Count - 1 do
    if PkFightMob(i) then begin
      MaxHP := NpcList(i).MaxHP;
      if MaxHP <= Lim then begin
        result := false;
        exit;
      end;
      result := true;
    end;
end;

function PkSwept(OID: integer): boolean;
var k: integer;
begin
  result := false;
  for k := 0 to 63 do
    if PkSweptOID[k] = OID then begin
      result := true;
      exit;
    end;
end;

// sweepable corpses near us that no mass sweep was cast on yet: count + one of them
function PkCorpses(): integer;
var i, NX, NY, OID: integer;
begin
  result := 0;
  PkCorpseOID := 0;
  for i := 0 to NpcList.Count - 1 do begin
    if (not NpcList(i).Dead) or (not NpcList(i).Sweepable) then continue;
    OID := NpcList(i).OID;
    if PkSwept(OID) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    if PkDist(NX, NY) > AOE_SWEEP_RANGE then continue;
    Inc(result);
    if PkCorpseOID = 0 then PkCorpseOID := OID;
  end;
end;

// one mass sweep on a sweepable corpse near us; every such corpse near us is then taken as swept
// (one cast per corpse, never a sweep with no sweepable corpse around)
procedure PkSweepNow();
var i, NX, NY, OID, COID: integer;
begin
  if PkCorpses() = 0 then exit;        // checked again right before the cast
  COID := PkCorpseOID;
  Engine.SetTarget(COID);
  Engine.UseSkill(PkMassSweep);
  Delay(PK_CAST_MS);
  for i := 0 to NpcList.Count - 1 do begin
    if (not NpcList(i).Dead) or (not NpcList(i).Sweepable) then continue;
    OID := NpcList(i).OID;
    if PkSwept(OID) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    if PkDist(NX, NY) > AOE_SWEEP_RANGE then continue;
    PkSweptOID[PkSweptHead] := OID;
    PkSweptHead := (PkSweptHead + 1) mod 64;
  end;
end;

// mass sweep during the fight: 2+ corpses, or one lying PK_CORPSE_MS (corpses vanish);
// true = cast (the target is a corpse now)
function PkTrySweep(): boolean;
var n: integer;
begin
  result := false;
  if PkMassSweep = 0 then exit;
  n := PkCorpses();
  if n = 0 then begin
    PkCorpseSince := 0;
    exit;
  end;
  if PkCorpseSince = 0 then PkCorpseSince := GetTickCount;
  if (n < 2) and (GetTickCount - PkCorpseSince < PK_CORPSE_MS) then exit;
  if SpSkillLeft(PkMassSweep) > 0 then exit;
  PkSweepNow();
  PkCorpseSince := 0;
  result := true;
end;

// after the pack: mass sweep while a sweepable corpse not swept yet is near (waits for the reuse)
procedure PkFinalSweep();
var k, w: integer;
begin
  if PkMassSweep = 0 then exit;
  for k := 1 to 5 do begin
    if User.Dead or NeedReturn then exit;
    if PkCorpses() = 0 then break;
    w := 0;
    while (SpSkillLeft(PkMassSweep) > 0) and (w < 40) do begin
      Delay(PK_TICK_MS);
      Inc(w);
    end;
    PkSweepNow();
  end;
  PkCorpseSince := 0;
end;

// the nearest mob of the fight (on us); 0 = none. Its distance -> PkNearD
function PkNearestFight(): integer;
var i, NX, NY: integer;
  D: double;
begin
  result := 0;
  PkNearD := 1E18;
  for i := 0 to NpcList.Count - 1 do begin
    if not PkFightMob(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    D := PkDist(NX, NY);
    if D < PkNearD then begin
      PkNearD := D;
      result := NpcList(i).OID;
    end;
  end;
end;

// kill the pack. At a corner the pack is FINISHED there: we never leave the corner while a mob of
// the pack lives - we hit only mobs within PK_HIT_RANGE, the others come to us; nobody comes for
// PK_FIGHT_IDLE_MS (behind a wall, far) -> the fight is over. No corner -> we run to the targets.
// Auto attack -> mass spoil -> auto attack ..., sweep on the way, dagger on a fat mob left alone
procedure PkFight();
var OID, NewOID, Casts, Main, Idx, TX, TY, TZ, RunOID, Reach, HuntOID, NearOID: integer;
  NextSpoil, IdleSince, SpoilCastAt, RangedSince: cardinal;
  NearD0: double;
  Running, WasRunning, SpoilWait, AllSpoiled: boolean;
  R, SpoilN: integer;
begin
  OID := 0;
  Running := false;
  RunOID := 0;
  IdleSince := 0;
  Casts := 0;
  NextSpoil := 0;                      // set by the first hit: hit first, spoil after
  SpoilWait := false;
  AllSpoiled := false;
  SpoilCastAt := 0;
  SpoilN := 0;
  for Idx := 0 to 63 do PkSpoiledOID[Idx] := 0;   // a new pack: nobody spoiled yet
  PkCorpseSince := 0;
  HuntOID := 0;
  NearOID := 0;
  NearD0 := 0;
  RangedSince := 0;
  if not PkRangedSet then begin
    PkRangedMs := 3000;
    PkRangedSet := true;
  end;
  while (not User.Dead) and (not NeedReturn) and (not FarmPaused) do begin
    WasRunning := Running;             // the run to the target goes on only if the last tick ran too
    Running := false;
    PkCheckShooters();
    if PkCountFight() = 0 then break;  // the pack is dead
    PkTapRestore();                    // the farm weapon back after the pull (until it is on)

    // the pack is down, a fat one is left -> dagger
    if (PkDaggerID > 0) and (not PkDaggerOn) and (not PullTapActive()) and PkOnlyFatLeft() then begin
      Main := WeaponID;                // the farm weapon (in hands at start / SetWeapon)
      if Main <= 0 then Main := PkCurrentWeapon();
      if (Main > 0) and (Main <> PkDaggerID) then begin
        Engine.Msg('[Pack]', 'Fat mob left, dagger on', 0);
        PkMainWeapon := Main;
        PkDaggerOn := true;
        EquipWeapon(PkDaggerID);
        OID := 0;
      end;
    end;

    if (PkCorner >= 0) and (PkCornerR <= 0) then Reach := PK_HIT_RANGE else Reach := 999999;
    if HuntOID <> 0 then begin         // the one hitting us from afar: until it is dead
      Idx := SpMobIdx(HuntOID);
      if Idx < 0 then HuntOID := 0
      else if not PkFightMob(Idx) then HuntOID := 0;
    end;
    if HuntOID <> 0 then NewOID := HuntOID else NewOID := PkBestTarget(OID, Reach);
    if NewOID = 0 then begin
      // corner, nobody within the hit yet: stand in the corner, they come to us
      if IdleSince = 0 then IdleSince := GetTickCount;
      // ... unless the nearest one does not come: it stays and hits from afar -> go kill it
      if RangedSince = 0 then begin
        RangedSince := GetTickCount;
        NearOID := PkNearestFight();
        NearD0 := PkNearD;
      end else if (PkRangedMs > 0) and (GetTickCount - RangedSince > PkRangedMs) then begin
        TX := PkNearestFight();
        if (TX <> 0) and (TX = NearOID) and (PkNearD > NearD0 - 50) then begin
          HuntOID := TX;
          Idx := SpMobIdx(TX);
          if Idx >= 0 then
            Engine.Msg('[Pack]', NpcList(Idx).Name + ' stays ' + IntToStr(Round(PkNearD)) + ' away and does not come - running to kill it', 0);
          RangedSince := 0;
          IdleSince := 0;
          continue;
        end;
        RangedSince := 0;              // it comes (or another one is nearest): look again
      end;
      if GetTickCount - IdleSince > PK_FIGHT_IDLE_MS then begin
        Engine.Msg('[Pack]', 'Nobody comes to the corner, fight over', 0);
        break;
      end;
      if (PkDist(PkCX, PkCY) > PK_REACH * 2) and PkNeedClick(PkCX, PkCY) then PkClick(PkCX, PkCY, PkCZ);
      PkTrySweep();
      OID := 0;
      Delay(PK_TICK_MS);
      continue;
    end;
    IdleSince := 0;
    RangedSince := 0;
    if NewOID <> OID then begin
      OID := NewOID;
      Engine.SetTarget(OID);
    end;

    Idx := SpMobIdx(OID);
    if Idx < 0 then begin
      OID := 0;
      continue;
    end;
    TX := NpcList(Idx).X;
    TY := NpcList(Idx).Y;

    // no corner / inside the corner zone, target farther than the hit -> run to it by the server
    // path (Attack runs straight)
    if PkDist(TX, TY) > PK_HIT_RANGE then begin
      if (not WasRunning) or (OID <> RunOID) then PkMoveReset();
      Running := true;
      if PkStillMs() > PK_STUCK_MS then begin
        // the server finds no way to it (behind a wall): skip it
        Engine.Msg('[Pack]', 'Cannot get to ' + NpcList(Idx).Name + ' (wall?), skipping it', 0);
        SpIgnore(OID);
        if OID = HuntOID then HuntOID := 0;
        OID := 0;
        RunOID := 0;
        Running := false;
        continue;
      end;
      if (OID <> RunOID) or PkNeedClick(TX, TY) then begin
        TZ := NpcList(Idx).Z;
        PkClick(TX, TY, TZ);
        RunOID := OID;
      end;
      Delay(PK_TICK_MS);
      continue;
    end;

    // auto attack -> mass spoil -> auto attack -> ... Every mob under a mass spoil answers with one
    // message ("spoil activated" / "already spoiled"): fewer messages than mobs = somebody is not
    // spoiled yet -> mass spoil again. All spoiled -> again only for new mobs (spawned from a corpse,
    // came late)
    if SpoilWait and (GetTickCount - SpoilCastAt >= PK_SPOIL_RESULT_MS) then begin
      SpoilWait := false;
      R := PkSpoilCount();
      if PkSeenSpoilMsg then AllSpoiled := R >= SpoilN
      else AllSpoiled := Casts >= PK_SPOIL_CASTS;   // the server sends no spoil messages: old rule
      if AllSpoiled then PkMarkSpoiled();
      Engine.Msg('[Pack]', 'Mass spoil: ' + IntToStr(R) + '/' + IntToStr(SpoilN) + ' spoiled', 0);
    end;
    if NextSpoil = 0 then NextSpoil := GetTickCount + PK_SPOIL_FIRST_MS;
    if (PkMassSpoil > 0) and (not SpoilWait) and (Casts < PK_SPOIL_MAX) and
       (GetTickCount >= NextSpoil) and (SpSkillLeft(PkMassSpoil) = 0) and
       ((not AllSpoiled) or PkHasUnspoiled()) then begin
      if AllSpoiled then Engine.Msg('[Pack]', 'New mobs, mass spoil again', 0);
      PkSpoilCountReset();
      SpoilN := PkSnapSpoilArea();
      Engine.UseSkill(PkMassSpoil);
      Inc(Casts);
      SpoilWait := true;
      SpoilCastAt := GetTickCount;
      AllSpoiled := false;
      NextSpoil := GetTickCount + PK_SPOIL_GAP_MS;
      Delay(PK_CAST_MS);
      continue;
    end;

    // corpses vanish: sweep them now
    if PkTrySweep() then begin
      OID := 0;
      continue;
    end;

    Engine.Attack(PK_TICK_MS);
  end;

  if PkDaggerOn then begin
    Main := PkMainWeapon;
    Engine.Msg('[Pack]', 'Main weapon back', 0);
    EquipWeapon(Main);
    PkDaggerOn := false;
  end;
  if not User.Dead then PkFinalSweep();
end;

// pick up the drop near us (not far from the corner)
procedure PkPickup();
var i, DX, DY, DZ: integer;
begin
  for i := DropList.Count - 1 downto 0 do begin
    if User.Dead or NeedReturn or (PkCountAggro() > 0) then exit;
    if i >= DropList.Count then continue;   // the list shrinks while we pick up
    DX := DropList(i).X;
    DY := DropList(i).Y;
    DZ := DropList(i).Z;
    if PkDist(DX, DY) > PK_PICKUP_RANGE then continue;
    MoveExactPlain(DX, DY, DZ, PK_REACH);   // drop behind a wall is not worth a detour
    Engine.Pickup;
    Delay(300);
  end;
end;

// one by one, nothing to kill near: run over the location - the farm spots (#f), else the patrol
// points, else far nav map points one after another. Never stands: the next point is taken before
// we reach this one
procedure PkPatrolTick();
var UX, UY, UZ, TX, TY, n: integer;
  D: double;
begin
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  if PkPatrolOn then begin
    D := PkDist(PkPatrolX, PkPatrolY);
    if D < 200 then PkPatrolOn := false;
  end;
  if not PkPatrolOn then begin
    n := Length(PatrolPoints) div 3;
    if PkSpotN > 1 then begin
      PkPatrolK := (PkPatrolK + 1) mod PkSpotN;
      PkPatrolX := PkSpotX[PkPatrolK];
      PkPatrolY := PkSpotY[PkPatrolK];
      PkPatrolOn := true;
    end else if n > 0 then begin
      PkPatrolK := (PkPatrolK + 1) mod n;
      PkPatrolX := PatrolPoints[PkPatrolK * 3];
      PkPatrolY := PatrolPoints[PkPatrolK * 3 + 1];
      PkPatrolOn := true;
    end else if NavFarPoint(1200) then begin
      PkPatrolX := NavFarX();
      PkPatrolY := NavFarY();
      PkPatrolOn := true;
    end else begin
      PkIdle();                        // nothing to run to: the safe point / the spot start
      exit;
    end;
    Engine.Msg('[Hunt]', 'No mobs near, patrol to ' + IntToStr(PkPatrolX) + ', ' + IntToStr(PkPatrolY), 0);
    PkMoveReset();
    PkClickAt := 0;
  end;
  TX := PkPatrolX;
  TY := PkPatrolY;
  if NavIsReady() and NavWaypoint(TX, TY) then begin
    TX := NavWpX();
    TY := NavWpY();
  end;
  if PkNeedClick(TX, TY) then PkClick(TX, TY, UZ);
  if PkStillMs() > PK_POINT_STUCK_MS then PkPatrolOn := false;   // cannot get there: the next point
end;

// FARM_AUTO: few free mobs near us -> one by one (a pack pull is not worth it)
function PkFewFree(): boolean;
var UX, UY: integer;
begin
  UX := User.X;
  UY := User.Y;
  result := PullCountFree(UX, UY, PK_AUTO_RANGE) < PullDensity();
end;

// one by one: the nearest free mob (by the way, nav map) - run at it never stopping, hit it, then the
// usual fight with everything on us (spoil, sweep, dagger); nobody near -> patrol
procedure PkSingleTick();
var OID, Idx, MX, MY: integer;
  Started: cardinal;
  First: boolean;
begin
  if PkCountAggro() > 0 then begin     // something hits us: kill it here
    PkState('one by one: ' + IntToStr(PkCountAggro()) + ' on us - fight here');
    PkCorner := -1;
    PkFight();
    PkPickup();
    exit;
  end;
  OID := PullPickSingle();
  if OID = 0 then begin
    PkState('one by one: no free mob within reach - patrol');
    PkPatrolTick();
    exit;
  end;
  PkPatrolOn := false;
  Idx := SpMobIdx(OID);
  if Idx >= 0 then PkState('one by one: running at ' + NpcList(Idx).Name);
  Started := GetTickCount;
  First := true;
  while not AoeMustStop() do begin
    Idx := SpMobIdx(OID);
    if (Idx < 0) or NpcList(Idx).Dead then exit;
    if PkCountAggro() > 0 then break;  // it (or another) is on us now: fight
    MX := NpcList(Idx).X;
    MY := NpcList(Idx).Y;
    if PkDist(MX, MY) <= PK_HIT_RANGE then begin
      Engine.SetTarget(OID);
      Engine.Attack(300);              // the first hit: it is on us after it
    end else begin
      PullChase(OID, First);           // by the nav map, through it, no stops
      First := false;
      if PkStillMs() > PK_POINT_STUCK_MS then begin
        Engine.Msg('[Hunt]', 'Cannot get to ' + NpcList(Idx).Name + ', skipping it', 0);
        PullForget(OID, SP_IGNORE_MS);
        exit;
      end;
    end;
    if GetTickCount - Started > SP_APPROACH_MS then begin
      PullForget(OID, SP_IGNORE_MS);
      exit;
    end;
    Delay(PK_TICK_MS);
  end;
  if AoeMustStop() then exit;
  PkCorner := -1;                      // where it stands
  PkFight();
  PkPickup();
end;

// rooms: the pull / one by one only inside this room
procedure PkRoomSet(n: integer);
var k, X, Y: integer;
begin
  PkRoomSel := n + 1;
  PullPolyClear();
  for k := 0 to RoomPointCount(n) - 1 do begin
    X := RoomPX(n, k);
    Y := RoomPY(n, k);
    PullPolyAdd(X, Y);
  end;
end;

// rooms: where to wait in a room - its farm spot, else a walkable point in its middle
procedure PkRoomWaitAt(n: integer);
var k, X, Y, UZ, SX, SY: integer;
begin
  X := RoomAnchorX(n);
  Y := RoomAnchorY(n);
  for k := 0 to PkSpotN - 1 do begin
    SX := PkSpotX[k];
    SY := PkSpotY[k];
    if PkSpotFor(k, n) then begin
      X := SX;
      Y := SY;
      break;
    end;
  end;
  UZ := User.Z;
  if PkDist(X, Y) > 150 then MoveExact(X, Y, UZ, PK_REACH);
end;

// at the room: inside its polygon, or at one of its farm spots (they may lie in the passage outside)
function PkAtRoom(n: integer): boolean;
var k, UX, UY, SX, SY: integer;
begin
  UX := User.X;
  UY := User.Y;
  result := RoomInside(n, UX, UY);
  if result then exit;
  for k := 0 to PkSpotN - 1 do begin
    SX := PkSpotX[k];
    SY := PkSpotY[k];
    if (PkDist(SX, SY) <= 200) and PkSpotFor(k, n) then begin
      result := true;
      exit;
    end;
  end;
end;

// run to the room along the nav map, but only until we are in it (the pull starts at the entry, not
// in its middle); something on us on the way -> stop here, the pull goes on from here
procedure PkRunIntoRoom(n: integer);
var Started, BestAt: cardinal;
  AX, AY, UZ, TX, TY: integer;
  D, BestD: double;
begin
  AX := RoomAnchorX(n);
  AY := RoomAnchorY(n);
  UZ := User.Z;
  Started := GetTickCount;
  BestD := PkDist(AX, AY);
  BestAt := GetTickCount;
  PkMoveReset();
  PkClickAt := 0;
  while (not AoeMustStop()) and (not PkAtRoom(n)) and
        ((PkCountAggro() = 0) or (PkIgnoreWay and (User.HP >= 50))) do begin
    if GetTickCount - Started > MOVE_WAIT_MS then exit;
    PullTapRestore();
    TX := AX;
    TY := AY;
    if NavIsReady() and NavWaypoint(AX, AY) then begin
      TX := NavWpX();
      TY := NavWpY();
    end;
    if PkNeedClick(TX, TY) then PkClick(TX, TY, UZ);
    D := PkDist(AX, AY);
    if D < BestD - 100 then begin      // getting closer
      BestD := D;
      BestAt := GetTickCount;
    end;
    // stands, or jerks at a wall without getting closer: out by the server path to the nearest own node
    if (PkStillMs() > PK_POINT_STUCK_MS) or (GetTickCount - BestAt > PK_NO_GAIN_MS) then begin
      if not NavUnstick() then MoveWait(AX, AY, UZ);
      exit;                            // the next tick goes on from there as before
    end;
    Delay(PK_TICK_MS);
  end;
end;

// the room is done (empty / its pack killed): stats, in order -> the next one (the round pause after
// the last), no room selected - the next tick picks the next room
procedure PkRoomDone(n: integer; Why: string);
begin
  Engine.Msg('[Room]', 'Room ' + RoomName(n) + ' ' + Why, 0);
  if PkRoomSeq and (n = PkSeqGoal) then begin
    PkSeqNext := n + 1;
    if (PkSeqNext >= RoomCount()) and (PkCycleWait > 0) then begin
      PkSeqNext := 0;
      PkSeqWaitUntil := GetTickCount + PkCycleWait * 1000;
      Engine.Msg('[Room]', 'Round of the rooms done, waiting ' + IntToStr(PkCycleWait) + ' s', 0);
    end;
  end;
  RoomMarkCleared(n);
  RoomSaveStats(Script.Path + '..\Nav\' + PkPullGrid + '.roomstat');
  PkRoomSel := 0;
end;

// FARM_ROOMS: the room with the most mobs expected (with its minimum), farmed empty by its own mode,
// then the next; nowhere enough -> wait in the best one (a better one comes up -> go there)
// mobs "on us" by their target, but none of them can be fought: farther than the fight range (behind
// walls in another room), on another floor, a target left from an old aggro. The rooms would stand
// on "1 on us - fight here" for ever: they are not aggro for a while, the farm goes on
procedure PkForgetPhantoms();
var i, OID, n: integer;
begin
  n := 0;
  for i := NpcList.Count - 1 downto 0 do begin
    if i >= NpcList.Count then continue;
    if PkAggro(i) and (not PkFightMob(i)) then begin
      OID := NpcList(i).OID;
      PullForget(OID, PK_PHANTOM_MS);
      Inc(n);
    end;
  end;
  if n > 0 then
    Engine.Msg('[Pack]', IntToStr(n) + ' "on us" but none near / on our floor - not aggro for ' +
      IntToStr(PK_PHANTOM_MS div 1000) + ' s', 0);
end;

procedure PkRoomTick();
var n, cur, UX, UY, UZ, AX, AY, k: integer;
  MS: string;
  Near: boolean;
begin
  RoomUpdate();
  if (PkCountAggro() > 0) and (PkCountFight() = 0) then PkForgetPhantoms();
  if (PkDebug >= 2) and ((PkRoomsAt = 0) or (GetTickCount - PkRoomsAt > 15000)) then begin
    PkRoomsAt := GetTickCount;
    for k := 0 to RoomCount() - 1 do Engine.Msg('[Rooms]', RoomInfo(k), 0);
  end;
  if PkCountAggro() > 0 then begin
    cur := PkRoomSel - 1;
    // a fight began in a room we only ran through (another room was the goal): this room is ours now
    UX := User.X;
    UY := User.Y;
    for k := 0 to RoomCount() - 1 do
      if (not PkIgnoreWay) and (k <> cur) and RoomInside(k, UX, UY) and (RoomMode(k) <> FARM_SINGLE) then begin
        Engine.Msg('[Room]', 'Aggro in room ' + RoomName(k) + ' on the way - farming it now', 0);
        PkRoomSet(k);
        PkRoomWaiting := false;
        cur := k;
        break;
      end;
    if cur >= 0 then begin
      AX := RoomAnchorX(cur);
      AY := RoomAnchorY(cur);
    end;
    // a pack room and we are in it / at its spot / at its entry (just before it) / near its middle:
    // these come along, the pull below takes the rest of the room
    Near := false;
    if (cur >= 0) and (RoomMode(cur) <> FARM_SINGLE) then begin
      UX := User.X;
      UY := User.Y;
      Near := PkAtRoom(cur) or (RoomDist(cur, UX, UY) <= PK_ROOM_ENTRY) or (PkDist(AX, AY) < 1500);
    end;
    if Near then PkState('rooms: ' + IntToStr(PkCountAggro()) + ' on us at room ' + RoomName(cur) + ' - they come along, pulling the room');
    if (not Near) and PkIgnoreWay and (cur >= 0) and (User.HP >= 50) and (GetTickCount >= PkSeqWaitUntil) then begin
      // not the room we go to: they follow us and join the pull there
      PkState('rooms: ' + IntToStr(PkCountAggro()) + ' on us on the way - ignoring them, running on to room ' + RoomName(cur));
      Near := true;
    end;
    if not Near then begin
      PkState('rooms: ' + IntToStr(PkCountAggro()) + ' on us (far from the room / one by one) - fight here');
      PkCorner := -1;
      PkFight();
      PkPickup();
      exit;
    end;
  end;
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  cur := PkRoomSel - 1;
  if cur >= 0 then begin
    if RoomBusy(cur) then cur := -1
    else if (not PkRoomWaiting) and PkAtRoom(cur) and (RoomFree(cur) = 0) then begin
      PkRoomDone(cur, 'cleared');
      cur := -1;
    end;
  end;
  if (cur < 0) and PkRoomSeq and (GetTickCount < PkSeqWaitUntil) then begin
    PkState('rooms in order: round done, next round in ' + IntToStr((PkSeqWaitUntil - GetTickCount) div 1000) + ' s');
    if HasSafePoint then PkIdle();
    Delay(500);
    exit;
  end;
  if (cur < 0) and PkRoomSeq then begin
    // in order: the next room of the list (the order of the viewer), whatever its mobs; a room with
    // another player in it now / avoided -> the one after it
    n := -1;
    for k := 0 to RoomCount() - 1 do begin
      cur := (PkSeqNext + k) mod RoomCount();
      if (not RoomBusy(cur)) and (not RoomTaken(cur)) and (RoomPointCount(cur) >= 3) then begin
        n := cur;
        break;
      end;
    end;
    cur := -1;
    if n < 0 then begin
      PkState('rooms in order: every room busy (players) - idle');
      PkIdle();
      Delay(500);
      exit;
    end;
    PkSeqNext := n;
    PkSeqGoal := n;
    PkRoomWaiting := false;
    Engine.Msg('[Room]', 'In order: to room ' + RoomName(n), 0);
    PkRoomSet(n);
    cur := n;
  end;
  if cur < 0 then begin
    n := RoomPick();
    PkRoomWaiting := n < 0;
    if n < 0 then n := RoomWaitPick();
    if n < 0 then begin
      PkState('rooms: no room to go to (all busy / no polygon) - idle');
      PkIdle();
      Delay(500);
      exit;
    end;
    if PkRoomWaiting then
      Engine.Msg('[Room]', 'Not enough mobs anywhere, waiting in room ' + RoomName(n) + ' (expected ' +
        IntToStr(Round(RoomExpected(n))) + ' of ' + IntToStr(RoomMin(n)) + ')', 0)
    else
      Engine.Msg('[Room]', 'To room ' + RoomName(n) + ' (expected ' + IntToStr(Round(RoomExpected(n))) + ')', 0);
    PkRoomSet(n);
    cur := n;
  end;
  // at the room = inside it or at its farm spot outside (in the passage): RoomOfSpot takes them up to 500 out
  if (not PkAtRoom(cur)) and ((PkCountAggro() = 0) or (PkIgnoreWay and (User.HP >= 50))) then begin
    AX := RoomAnchorX(cur);
    AY := RoomAnchorY(cur);
    PkState('rooms: running to room ' + RoomName(cur) + ' (' + IntToStr(AX) + ', ' + IntToStr(AY) + ')');
    PkRunIntoRoom(cur);                // until we are in it: the pull starts at the entry
    exit;
  end;
  if PkRoomWaiting and (PkCountAggro() = 0) then begin
    if (RoomMobs(cur) >= RoomMin(cur)) and (RoomFree(cur) > 0) then begin
      PkRoomWaiting := false;
      Engine.Msg('[Room]', 'Room ' + RoomName(cur) + ': ' + IntToStr(RoomMobs(cur)) + ' mobs, farming', 0);
    end else begin
      n := RoomPick();
      if (n >= 0) and (n <> cur) then begin   // another room has enough now
        PkRoomSel := 0;
        exit;
      end;
      // a room not seen for a while (far: its mobs show only near) -> go and look at it, one by one
      n := RoomStalest(PK_ROOM_LOOK_MS);
      if (n >= 0) and (n <> cur) then begin
        Engine.Msg('[Room]', 'Nothing to farm, going to look at room ' + RoomName(n), 0);
        PkRoomSet(n);
        exit;                          // still waiting: the next ticks run there and count it
      end;
      PkState('rooms: waiting in room ' + RoomName(cur) + ': ' + IntToStr(RoomMobs(cur)) + ' mobs of min ' +
        IntToStr(RoomMin(cur)) + ', no room has its minimum');
      PkRoomWaitAt(cur);
      Delay(500);
      exit;
    end;
  end;
  // a few left here (under its minimum) and another room is ready: leave them, go there
  if (not PkRoomSeq) and (PkCountAggro() = 0) and (RoomFree(cur) < RoomMin(cur)) then begin
    n := RoomPickExcept(cur);
    if n >= 0 then begin
      Engine.Msg('[Room]', 'Room ' + RoomName(cur) + ': only ' + IntToStr(RoomFree(cur)) + ' left (min ' +
        IntToStr(RoomMin(cur)) + '), room ' + RoomName(n) + ' is ready - going there', 0);
      RoomMarkCleared(cur);
      RoomSaveStats(Script.Path + '..\Nav\' + PkPullGrid + '.roomstat');
      PkRoomSet(n);
      exit;
    end;
  end;
  // farm the room by its own mode
  n := RoomMode(cur);
  if n = FARM_SINGLE then MS := 'one by one' else if n = FARM_AUTO then MS := 'auto' else MS := 'pack';
  PkState('rooms: farming room ' + RoomName(cur) + ' (' + MS + '): ' + IntToStr(RoomFree(cur)) + ' free');
  if (n = FARM_SINGLE) or ((n = FARM_AUTO) and PkFewFree()) then begin
    PkSingleTick();
    exit;
  end;
  // the full room: every free mob of it + what is on us already (the pack size does not matter here:
  // the room's own minimum decided we came)
  k := RoomFree(cur) + PkCountAggro();
  if k < 1 then k := 1;
  PkState('rooms: pulling room ' + RoomName(cur) + ' full: ' + IntToStr(PkCountAggro()) + ' on us, ' +
    IntToStr(RoomFree(cur)) + ' free -> pack ' + IntToStr(k));
  PullSetPackSize(k);
  PullSetPackLive(PkRoomRecount);      // respawn meanwhile: taken too, until we run to the spot
  PullRun();
  PullSetPackLive(false);
  PullSetPackSize(PkPackSize);
  PkTapRestore();
  if AoeMustStop() then exit;
  if PkCountAggro() > 0 then begin
    PkState('rooms: ' + IntToStr(PkCountAggro()) + ' on us - to the farm spot of room ' + RoomName(cur) + ', fight there');
    PkGather();
    PkFight();
    PkPickup();
    // the pack of the room is dead: on to the next room - a mob that came up meanwhile is not pulled
    // alone (it waits for the next visit)
    if (not User.Dead) and (not NeedReturn) and (PkCountAggro() = 0) then
      PkRoomDone(cur, 'done: its pack is dead (' + IntToStr(RoomFree(cur)) + ' came up meanwhile, left for later)');
  end;
end;

// the pull module ends the pull at once when the farm must stop (pause, return, death...)
procedure PullStop_Thread();
begin
  while Delay(100) do PullSetStop(AoeMustStop());
end;

procedure PackFarm_Thread();
begin
  while Delay(PK_TICK_MS) do begin
    if AoeMustStop() or TreeBusy then begin
      PkState('stopped: ' + PkStopReason());
      continue;
    end;
    if (BuffID <> 0) and (BuffTime(BuffID) < REBUFF_TIME) then begin
      PkState('rebuff: buff ' + IntToStr(BuffID) + ' has ' + IntToStr(BuffTime(BuffID) div 1000) + ' s left, ' +
        'mobs on us ' + IntToStr(PkCountAggro()) + ' - to the safe point, no pulls');
      // rebuff first: no new pulls. Safe point set -> run there (server path, the mobs on us come
      // along), the safe point is the corner: finish them there, then the rebuff thread buffs
      if not HasSafePoint then begin
        // no safe point: finish what is on us right here (the pack fight), then tell the rebuff
        // thread it may buff - it never pauses the farm in the middle of the pack
        PkTapRestore();
        if PkCountAggro() > 0 then begin
          PkSafeReady := false;
          PkCorner := -1;
          PkFight();
          PkPickup();
          continue;
        end;
        PkSafeReady := (not User.InCombat) and (not PullTapActive());
        continue;
      end;
      PkTapRestore();
      if PkDist(SafeX, SafeY) > PK_REACH * 2 then begin
        PkSafeReady := false;
        Engine.Msg('[Pack]', 'Rebuff due, running to the safe point', 0);
        MoveExact(SafeX, SafeY, SafeZ, PK_REACH);
        continue;
      end;
      if PkCountAggro() > 0 then begin
        PkSafeReady := false;
        PkCorner := 0;                 // the safe point is the corner of this fight
        PkCX := SafeX;
        PkCY := SafeY;
        PkCZ := SafeZ;
        PkFight();
        PkCorner := -1;
        continue;
      end;
      PkSafeReady := (not User.InCombat) and (not PullTapActive());   // the rebuff thread waits for this
      if (PkRebuffSaidAt = 0) or (GetTickCount - PkRebuffSaidAt > 10000) then begin
        PkRebuffSaidAt := GetTickCount;
        Engine.Msg('[Pack]', 'At the safe point for the rebuff: buff ' + IntToStr(BuffID) + ' has ' +
          IntToStr(BuffTime(BuffID) div 1000) + ' s left (rebuff below ' + IntToStr(REBUFF_TIME div 1000) +
          ' s), in combat: ' + IntToStr(Ord(User.InCombat)) + ' - no pulls until it is buffed', 0);
      end;
      continue;
    end;
    PkSafeReady := false;
    if (PkFarmMode = FARM_ROOMS) and (RoomCount() > 0) then begin
      PkRoomTick();
      continue;
    end;
    // one by one (FARM_SINGLE, or FARM_AUTO with few free mobs near)
    if (PkFarmMode = FARM_SINGLE) or ((PkFarmMode = FARM_AUTO) and PkFewFree()) then begin
      PkSingleTick();
      continue;
    end;
    if PullTapActive() and (PkCountAggro() = 0) and (not PkTapAlways) then begin
      PkTapRestore();                  // the farm weapon goes back on before a pull without the tap
      continue;
    end;
    PkState('pack: pulling (pack ' + IntToStr(PkPackSize) + ')');
    PullRun();                         // the pull: Core\mob_pull.pas
    PkTapRestore();
    if AoeMustStop() then continue;
    if PkCountAggro() = 0 then begin   // nothing to pull and nobody on us
      PkState('pack: nothing to pull - idle at the safe point / patrol');
      PkIdle();
      Delay(300);
      continue;
    end;
    if PkCountAggro() > 0 then begin
      PkState('pack: ' + IntToStr(PkCountAggro()) + ' on us - to the corner, fight');
      PkGather();
      PkFight();
      PkPickup();
    end;
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
      MoveServer(TX, TY, TZ);
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
  if not BuffSet then begin            // the same on all our chars: the buffer buff + own buff 421
    BuffID := DEFAULT_BUFF_ID;
    SetLength(BuffBypasses, 2);
    BuffBypasses[0] := DEFAULT_BUFF_BYPASS1;
    BuffBypasses[1] := DEFAULT_BUFF_BYPASS2;
    Engine.Msg('[Init]', 'Buff: default ' + IntToStr(BuffID) + ' via the buffer', 128);
  end;
  if not SelfBuffSet then AddSelfBuff(DEFAULT_SELF_BUFF, 0);
  if PkSkipChamps then begin           // own limit, else the same as the champion alert
    if PkChampHP > 0 then PullSkipChampions(PkChampHP)
    else if ChampionMinHP > 0 then PullSkipChampions(ChampionMinHP)
    else PullSkipChampions(DEFAULT_CHAMPION_HP);
  end;
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
  if SpoilEnabled then Script.NewThread(@SpoilFarm_Thread);
  if PackEnabled then begin
    Script.NewThread(@PullStop_Thread);
    Script.NewThread(@PackFarm_Thread);
  end;
  if Length(SelfBuffSkill) > 0 then Script.NewThread(@SelfBuff_Thread);
  if SpoilEnabled then SpSpoilMsg();   // old system messages are not events
  if CasterEnabled then begin
    if CasterRange <= 0 then CasterRange := DEFAULT_TARGET_RANGE;
    Script.NewThread(@CasterFarm_Thread);
    if SummonSkill > 0 then Script.NewThread(@SummonWatch_Thread);
  end;
  if HasPatrol() and (not AoeEnabled) and (not CasterEnabled) and (not SpoilEnabled) and (not PackEnabled) then Script.NewThread(@Patrol_Thread);
  if (not AoeEnabled) and (not CasterEnabled) and (not SpoilEnabled) and (not PackEnabled) then Script.NewThread(@IgnoreWatch_Thread);
  RememberWeapon();   // no SetWeapon -> the weapon in hands right now
  PullSetFarmWeapon(WeaponID);         // the pull puts it back after the tap weapon
  if WeaponID > 0 then Script.NewThread(@WeaponWatch_Thread);
  if (PlayerAlertRange > 0) or PrivateAlert or (ChampionMinHP > 0) then Script.NewThread(@Events_Thread);
  Delay(-1);
end;

end.
