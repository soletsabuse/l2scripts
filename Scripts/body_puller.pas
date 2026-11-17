unit BodyPuller;

// Body puller for a party: a fast runner (Treasure Hunter) gathers packs and never hits a mob.
//   - goes over the rooms of the nav map (Core\room_farm.pas: where the most mobs are expected, or one
//     after another in the list order), round the walls by the map (Core\nav_move.pas);
//   - in a room runs past the free mobs until they follow (Core\mob_pull.pas with no_hit: a mob that does
//     not aggro from the run past it is left alone - no taps). A room had fewer than the pack size: on to
//     the next room with them in tow (puller_chain), until the pack is full;
//   - brings the pack to the party point (the Safe point of the map) and stands there until the party has
//     taken all of them off us but puller_leave, then goes for the next pack;
//   - Dash (puller_dash) whenever it is ready and no mob on us is right next to us;
//   - items of a list (puller_loot: wigs...; IDs or parts of names) lying anywhere in sight are picked up
//     on the way while no mob is on us.
// Everything is set in the .navgrid with Library\Nav\nav_view.html: the map (walls, rails, own nodes), the
// rooms (Room tool), the party point (Safe tool), the settings (Settings > Puller; the pull tuning:
// Settings > Pull). The K lines it reads:
//   K puller_pack 8            mobs to bring at once
//   K puller_mobs 1,2          only these mobs (none = any)
//   K puller_leave 1           leave the party point when this many or fewer are still on us
//   K puller_wait_max 0        ... after this many seconds anyway (0 = wait as long as it takes)
//   K puller_dash 4            the speed skill (0 = none)
//   K puller_loot 1234,Wig     what to pick up: item IDs / parts of item names, comma separated
//   K puller_loot_range 1500   an item at most this far from us is gone for
//   K puller_chain 1           a pack short of puller_pack goes on to the next room (0 = brought at once)
//   and of the farm settings: ignore, zrange, room_order SEQ, room_players, room_avoid, skip_champions,
//   champ_hp, pull <key> <value>, debug_file, debug_run, nav_clear, nav_wp_cache_ms (the rest is not ours).
// Started in the zone: no teleport, no town. Dead -> waits for a resurrection (accepts it).
//
//   uses BodyPuller in 'body_puller.pas';
//   begin
//     SetNavGrid('SPOT.navgrid');          // Library\Nav
//     RunPuller();
//   end.
//
// A line between them overrides the map: SetPackSize(10); SetPartyPoint(x, y, z); SetLeaveAggro(2);
// SetDash(0); SetLoot('1234, Wig').

interface

uses SysUtils, Classes, NavMove in 'Core\nav_move.pas', MobPull in 'Core\mob_pull.pas',
  DbgLog in 'Core\dbg_log.pas', RoomFarm in 'Core\room_farm.pas';

procedure SetNavGrid(Name: string);            // the map, the rooms, the party point and the settings
procedure SetPackSize(N: integer);             // mobs to bring at once
procedure SetPartyPoint(X, Y, Z: integer);     // where the party stands (else the Safe point of the map)
procedure SetLeaveAggro(N: integer);           // leave the party point when this many or fewer are on us
procedure SetDash(SkillID: integer);           // the speed skill, 0 = none
procedure SetLoot(List: string);               // what to pick up: item IDs / parts of names, comma separated
procedure RunPuller();

implementation

const
  PH_TICK_MS       = 50;
  PH_REACH         = 80;       // at the party point: this close
  PH_POINT_R       = 900;      // mobs on us this close to the party point count for leaving it
  PH_STAND_MS      = 1500;     // at the party point at least this long
  PH_RUN_MS        = 60000;    // one run gives up after this
  PH_STUCK_MS      = 3000;     // not moved this long on a run -> out of the stuck place
  PH_ROOM_REACH    = 150;      // the run into a room: this close to its middle (or inside it) is there
  PH_LOOT_LOOK_MS  = 300;      // the drop is looked through this often
  PH_LOOT_AGAIN_MS = 60000;    // an item gone for once is not gone for again this long (it stays: cannot)
  PH_LOOT_Z        = 400;      // an item only on our floor
  PH_CHAIN_DIST    = 3000;     // with the pack in tow only to a room this close
  PH_SAY_MS        = 20000;    // "still N on us" said this often
  PH_IDLE_MS       = 1000;
  PH_LOW_HP        = 50;       // our HP % below this with mobs on us: to the party at once

var
  PhInited: boolean;
  PhGrid: string;
  PhPack, PhLeave, PhWaitMax, PhDash, PhLootRange, PhChampHP: integer;
  PhChain, PhSeq, PhSkipChamp, PhDebugFile: boolean;
  PhPX, PhPY, PhPZ: integer;           // the party point
  PhHasPoint: boolean;
  PhLootIDs: array of integer;         // puller_loot: item IDs ...
  PhLootNames: array of string;        // ... and parts of item names (lower case)
  PhLkID: array[0..255] of integer;    // loot by name: the item kinds judged (a name read once per kind) ...
  PhLkYes: array[0..255] of boolean;   // ... and the verdict
  PhLkN: integer;
  PhLtOID: array[0..31] of integer;    // items gone for: not again for a while
  PhLtUntil: array[0..31] of cardinal;
  PhLtHead: integer;
  PhLootAt: cardinal;
  PhState: string;                     // the last state said
  PhSeqIdx: integer;                   // rooms in order: the last room taken
  PhTrip: string;                      // the rooms of this pack: ',0,3,'

// ===================== little helpers =====================

// field k of a line (space separated, 0 = the first)
function PhField(S: string; k: integer): string;
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

// the line from field k on
function PhRest(S: string; k: integer): string;
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

function PhDistP(X1, Y1, X2, Y2: integer): double;
var DX, DY: double;
begin
  DX := X1 - X2;
  DY := Y1 - Y2;
  result := Sqrt(DX * DX + DY * DY);
end;

function PhDist(X, Y: integer): double;
begin
  result := PhDistP(User.X, User.Y, X, Y);
end;

// a new state into the bot's window (only when it changes)
procedure PhStateSet(Text: string);
begin
  if Text = PhState then exit;
  PhState := Text;
  Engine.Msg('[Puller]', Text, 0);
  Dbg('[Puller]', Text);
end;

// every number of a list ("1, 2,3") -> the mob list of the pull (Kind 0) / never pulled (1)
procedure PhEachId(V: string; Kind: integer);
var i, n: integer;
  C: string;
begin
  n := 0;
  for i := 1 to Length(V) + 1 do begin
    if i <= Length(V) then C := Copy(V, i, 1) else C := ' ';
    if (C >= '0') and (C <= '9') then n := n * 10 + StrToInt(C)
    else begin
      if n > 0 then begin
        if Kind = 0 then PullAddMob(n) else PullIgnoreID(n);
      end;
      n := 0;
    end;
  end;
end;

procedure PhInit();
var k: integer;
begin
  if PhInited then exit;
  PhInited := true;
  PhPack := 8;
  PhLeave := 1;
  PhWaitMax := 0;
  PhDash := 4;                         // Dash of the rogues
  PhLootRange := 1500;
  PhChain := true;
  PhSeq := false;
  PhSkipChamp := false;
  PhChampHP := 0;
  PhDebugFile := false;
  PhHasPoint := false;
  PhLkN := 0;
  PhLtHead := 0;
  for k := 0 to 31 do begin
    PhLtOID[k] := 0;
    PhLtUntil[k] := 0;
  end;
  PhLootAt := 0;
  PhState := '';
  PhSeqIdx := -1;
  PhTrip := ',';
  SetLength(PhLootIDs, 0);
  SetLength(PhLootNames, 0);
  PullSet('no_hit', 1);                // no taps: a mob that does not aggro from the run past it is left alone
  PullSet('ignore_ms', 120000);        // ... for 2 min (K pull lines may change it)
  RoomSetPlayers(60);
end;

// ===================== settings =====================

procedure SetPackSize(N: integer);
begin
  PhInit();
  PhPack := N;
  if PhPack < 1 then PhPack := 1;
end;

procedure SetPartyPoint(X, Y, Z: integer);
begin
  PhInit();
  PhPX := X;
  PhPY := Y;
  PhPZ := Z;
  if PhPZ = 0 then PhPZ := User.Z;
  PhHasPoint := true;
end;

procedure SetLeaveAggro(N: integer);
begin
  PhInit();
  PhLeave := N;
  if PhLeave < 0 then PhLeave := 0;
end;

procedure SetDash(SkillID: integer);
begin
  PhInit();
  PhDash := SkillID;
end;

procedure SetLoot(List: string);
var S, P: string;
  k, n: integer;
begin
  PhInit();
  SetLength(PhLootIDs, 0);
  SetLength(PhLootNames, 0);
  PhLkN := 0;
  S := List;
  while S <> '' do begin
    k := Pos(',', S);
    if k = 0 then k := Length(S) + 1;
    P := Trim(Copy(S, 1, k - 1));
    Delete(S, 1, k);
    if P = '' then continue;
    n := StrToIntDef(P, 0);
    if n > 0 then begin
      SetLength(PhLootIDs, Length(PhLootIDs) + 1);
      PhLootIDs[Length(PhLootIDs) - 1] := n;
    end else begin
      SetLength(PhLootNames, Length(PhLootNames) + 1);
      PhLootNames[Length(PhLootNames) - 1] := LowerCase(P);
    end;
  end;
end;

// one "K key value" line of the map; the keys of the farm script that are not ours are left alone
procedure PhSetting(K, V: string);
begin
  if K = 'puller_pack' then SetPackSize(StrToIntDef(V, 8))
  else if K = 'puller_mobs' then begin
    PullClearMobs();
    PhEachId(V, 0);
  end
  else if K = 'puller_leave' then SetLeaveAggro(StrToIntDef(V, 1))
  else if K = 'puller_wait_max' then PhWaitMax := StrToIntDef(V, 0)
  else if K = 'puller_dash' then SetDash(StrToIntDef(V, 4))
  else if K = 'puller_loot' then SetLoot(V)
  else if K = 'puller_loot_range' then PhLootRange := StrToIntDef(V, 1500)
  else if K = 'puller_chain' then PhChain := V <> '0'
  else if K = 'ignore' then PhEachId(V, 1)
  else if K = 'zrange' then PullSetZRange(StrToIntDef(V, 0))
  else if K = 'room_order' then PhSeq := UpperCase(V) = 'SEQ'
  else if K = 'room_players' then RoomSetPlayers(StrToIntDef(V, 60))
  else if K = 'room_avoid' then RoomSetAvoid(StrToIntDef(V, 30))
  else if K = 'skip_champions' then PhSkipChamp := V = '1'
  else if K = 'champ_hp' then PhChampHP := StrToIntDef(V, 0)
  else if K = 'pull' then PullSet(PhField(V, 0), StrToIntDef(PhField(V, 1), 0))
  else if K = 'debug_file' then begin
    if V = '1' then PhDebugFile := true;
  end
  else if K = 'debug_run' then begin
    if V = '1' then begin
      PhDebugFile := true;
      NavSetDebug(true);
    end;
  end
  else if K = 'nav_clear' then NavSetRunClear(StrToIntDef(V, 40))
  else if K = 'nav_wp_cache_ms' then NavSetWpCache(StrToIntDef(V, 500));
end;

// "Q name min mode prio x y x y ..." of the viewer -> a room
procedure PhAddRoom(S: string);
var n, X, Y: integer;
begin
  RoomAdd(PhField(S, 1), StrToIntDef(PhField(S, 2), 4), 0, StrToIntDef(PhField(S, 4), 1));
  n := 5;
  while PhField(S, n + 1) <> '' do begin
    X := StrToIntDef(PhField(S, n), 0);
    Y := StrToIntDef(PhField(S, n + 1), 0);
    RoomAddPoint(X, Y);
    n := n + 2;
  end;
end;

// the nav map of nav_view.html (Library\Nav): runs by it, the pull area, the rooms (Q), the party point
// (the Safe point, S) and the settings (K)
procedure SetNavGrid(Name: string);
var L: TStringList;
  i, n, X, Y, Z: integer;
  F, S, K0: string;
begin
  PhInit();
  NavSetGrid(Name);
  PhGrid := Name;
  F := Script.Path + '..\Nav\' + Name;
  if not FileExists(F) then begin
    Engine.Msg('[Puller]', 'No nav map ' + F, 128);
    exit;
  end;
  L := TStringList.Create;
  L.LoadFromFile(F);
  RoomClear();
  n := 0;
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    K0 := Copy(S, 1, 2);
    if K0 = 'K ' then begin
      PhSetting(LowerCase(PhField(S, 1)), PhRest(S, 2));
      Inc(n);
    end else if K0 = 'Q ' then PhAddRoom(S)
    else if K0 = 'S ' then begin
      X := StrToIntDef(PhField(S, 1), 0);
      Y := StrToIntDef(PhField(S, 2), 0);
      Z := StrToIntDef(PhField(S, 3), 0);
      SetPartyPoint(X, Y, Z);
    end;
  end;
  L.Free;
  Engine.Msg('[Puller]', 'Nav map ' + Name + ': ' + IntToStr(RoomCount()) + ' rooms, ' + IntToStr(n) + ' settings', 0);
end;

// ===================== the loot (wigs...) =====================

// DropList(i) is an item of the list: by its ID, else by its name (read once per item kind)
function PhIsLoot(i: integer): boolean;
var ID, k: integer;
  Nm: string;
begin
  result := false;
  if i >= DropList.Count then exit;
  ID := DropList(i).ID;
  for k := 0 to Length(PhLootIDs) - 1 do
    if PhLootIDs[k] = ID then begin
      result := true;
      exit;
    end;
  if Length(PhLootNames) = 0 then exit;
  for k := 0 to PhLkN - 1 do
    if PhLkID[k] = ID then begin
      result := PhLkYes[k];
      exit;
    end;
  Nm := '';
  try
    Nm := LowerCase(DropList(i).Name);
  except
    Nm := '';
  end;
  if Nm = '' then exit;                // no name yet: judged next time
  for k := 0 to Length(PhLootNames) - 1 do
    if Pos(PhLootNames[k], Nm) > 0 then result := true;
  if PhLkN < 256 then begin
    PhLkID[PhLkN] := ID;
    PhLkYes[PhLkN] := result;
    Inc(PhLkN);
  end;
  if result then Engine.Msg('[Puller]', 'Loot: "' + Nm + '" (ID ' + IntToStr(ID) + ') is picked up', 0);
end;

// a walkable map cell at the point or right next to it (an item may lie at a wall)
function PhNearFree(X, Y: integer): boolean;
begin
  result := NavIsFree(X, Y) or NavIsFree(X + 40, Y) or NavIsFree(X - 40, Y) or NavIsFree(X, Y + 40) or
    NavIsFree(X, Y - 40);
end;

// the nearest item of the list within puller_loot_range on our floor and the map, not more than MaxAggro
// mobs on us: run to it (round the walls) and pick it up. true = we went for one (the caller's run clicks
// again). AtOnce = look now (else at most every PH_LOOT_LOOK_MS)
function PhLootTick(MaxAggro: integer; AtOnce: boolean): boolean;
var i, k, OID, Best, BX, BY, BZ, X, Y, Z, UZ: integer;
  D, BestD: double;
  Skip, Ok: boolean;
begin
  result := false;
  if (Length(PhLootIDs) = 0) and (Length(PhLootNames) = 0) then exit;
  if (not AtOnce) and (PhLootAt <> 0) and (GetTickCount - PhLootAt < PH_LOOT_LOOK_MS) then exit;
  PhLootAt := GetTickCount;
  if User.Dead then exit;
  if PullCountAggro() > MaxAggro then exit;
  Best := 0;
  BestD := PhLootRange + 1;
  BX := 0;
  BY := 0;
  BZ := 0;
  UZ := User.Z;
  for i := 0 to DropList.Count - 1 do if i < DropList.Count then begin
    if not PhIsLoot(i) then continue;
    if i >= DropList.Count then continue;
    OID := DropList(i).OID;
    X := DropList(i).X;
    Y := DropList(i).Y;
    Z := DropList(i).Z;
    if Abs(Z - UZ) > PH_LOOT_Z then continue;
    D := PhDist(X, Y);
    if D >= BestD then continue;
    Skip := false;
    for k := 0 to 31 do
      if (PhLtOID[k] = OID) and (GetTickCount < PhLtUntil[k]) then Skip := true;
    if Skip then continue;
    if not PhNearFree(X, Y) then continue;   // off the map: behind a wall, out of the zone
    Best := OID;
    BestD := D;
    BX := X;
    BY := Y;
    BZ := Z;
  end;
  if Best = 0 then exit;
  result := true;
  PhLtOID[PhLtHead] := Best;           // not again for a while if it is still there after this
  PhLtUntil[PhLtHead] := GetTickCount + PH_LOOT_AGAIN_MS;
  PhLtHead := (PhLtHead + 1) mod 32;
  Dbg('[Loot]', 'to an item ' + IntToStr(Best) + ' d=' + IntToStr(Round(BestD)));
  if BestD > 60 then Ok := NavRun(BX, BY, BZ, 60);
  if User.Dead then exit;
  for i := 0 to DropList.Count - 1 do if i < DropList.Count then
    if DropList(i).OID = Best then begin
      Engine.Pickup(DropList(i));
      break;
    end;
  Delay(300);
end;

// ===================== runs =====================

// a run to X, Y in ticks along the map, Dash on the way. Free (Lead false): an item of the list in sight
// is picked up first (no mob on us); a full pack on us ends the run (the caller brings it). With the pack
// (Lead true): the leash - a pack mob about to lose us -> zigzag until it catches up. StopRoom >= 0: being
// inside that room is there too. true = there
function PhRunTo(X, Y, Z, Reach: integer; Lead: boolean; StopRoom: integer): boolean;
var Started: cardinal;
  Stucks: integer;
  Ok: boolean;
begin
  result := false;
  Started := GetTickCount;
  Stucks := 0;
  NavStepReset();
  while not User.Dead do begin
    if PhDist(X, Y) <= Reach then begin
      result := true;
      exit;
    end;
    if (StopRoom >= 0) and RoomInside(StopRoom, User.X, User.Y) then begin
      result := true;
      exit;
    end;
    if GetTickCount - Started > PH_RUN_MS then break;
    RoomUpdate();
    DbgTick();
    if Lead then begin
      if PullLeashTick() then begin    // zigzag: the click is the pull module's
        NavStepReset();
        if not Delay(PH_TICK_MS) then exit;
        continue;
      end;
    end else begin
      if PullCountAggro() >= PhPack then exit;   // a pack on us already: the caller brings it
      if PhLootTick(0, false) then begin
        NavStepReset();
        continue;
      end;
    end;
    if PullDashTick() then NavClickForget();   // its cast may stop us: the next step clicks again
    NavStep(X, Y, Z, true);
    if NavStillMs() > PH_STUCK_MS then begin
      Inc(Stucks);
      if Stucks > 3 then break;
      Dbg('[Puller]', 'stuck on the way to ' + IntToStr(X) + ',' + IntToStr(Y) + ' - unstick');
      Ok := NavUnstick();
      NavStepReset();
    end;
    if not Delay(PH_TICK_MS) then exit;
  end;
  if User.Dead then exit;
  if (not Lead) and (PullCountAggro() >= PhPack) then exit;
  result := NavRun(X, Y, Z, Reach);    // the last try: the blocking run (graph, unstick)
end;

// mobs on us this close to the party point
function PhAggroNear(R: integer): integer;
var i, NX, NY: integer;
begin
  result := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if not PullIsAggro(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    if PhDistP(NX, NY, PhPX, PhPY) <= R then Inc(result);
  end;
end;

// at the party point: stand until the party has taken them off us - at most puller_leave left and fewer than
// the most we had here (a pack of puller_leave or fewer: none left), PH_STAND_MS at least
procedure PhWaitAtPoint();
var Arrived, SaidAt: cardinal;
  n, Most: integer;
begin
  Arrived := GetTickCount;
  SaidAt := GetTickCount;
  Most := 0;
  NavStepReset();
  PhStateSet('At the party point with ' + IntToStr(PhAggroNear(PH_POINT_R)) + ' on us: waiting for the party to take them');
  while not User.Dead do begin
    DbgTick();
    n := PhAggroNear(PH_POINT_R);
    if n > Most then Most := n;
    if GetTickCount - Arrived >= PH_STAND_MS then begin
      if n = 0 then break;
      if (n <= PhLeave) and (n < Most) then break;
    end;
    if (PhWaitMax > 0) and (GetTickCount - Arrived > PhWaitMax * 1000) then begin
      Engine.Msg('[Puller]', 'Still ' + IntToStr(n) + ' on us after ' + IntToStr(PhWaitMax) +
        ' s at the party point - going on anyway', 128);
      break;
    end;
    if GetTickCount - SaidAt > PH_SAY_MS then begin
      SaidAt := GetTickCount;
      Engine.Msg('[Puller]', 'Party point: still ' + IntToStr(n) + ' on us (leaving at ' + IntToStr(PhLeave) + ')', 0);
    end;
    if PhDist(PhPX, PhPY) > PH_REACH + 70 then NavStep(PhPX, PhPY, PhPZ, true)   // pushed off it: back
    else NavStepReset();
    if not Delay(100) then exit;
  end;
  if not User.Dead then
    Dbg('[Puller]', 'leaving the party point: ' + IntToStr(PhAggroNear(PH_POINT_R)) + ' on us, most ' + IntToStr(Most));
end;

// the pack on us to the party point, the wait there, then the items of the list round it
procedure PhBring();
var Ok: boolean;
begin
  PhStateSet('Bringing ' + IntToStr(PullCountAggro()) + ' to the party point');
  Ok := PhRunTo(PhPX, PhPY, PhPZ, PH_REACH, true, -1);
  if User.Dead then exit;
  PhWaitAtPoint();
  while (not User.Dead) and PhLootTick(PhLeave, true) do Ok := true;   // the drop of the pack (wigs...)
  PhTrip := ',';
end;

// nothing to pull now: to the party point and wait there
procedure PhIdle();
var Ok: boolean;
begin
  if PhDist(PhPX, PhPY) > 300 then Ok := PhRunTo(PhPX, PhPY, PhPZ, PH_REACH, false, -1)
  else Delay(PH_IDLE_MS);
end;

// ===================== rooms =====================

// rooms in order: the next one after PhSeqIdx nobody else farms; -1 = none
function PhSeqPeek(): integer;
var k, n, i: integer;
begin
  result := -1;
  n := RoomCount();
  for k := 1 to n do begin
    i := (PhSeqIdx + k) mod n;
    if i < 0 then i := i + n;
    if not RoomBusy(i) then begin
      result := i;
      exit;
    end;
  end;
end;

// the room to pull next: in the list order (room_order SEQ) or where the most mobs are expected (its
// minimum reached); -1 = none worth it now
function PhPickRoom(): integer;
begin
  result := -1;
  if RoomCount() = 0 then exit;
  if PhSeq then begin
    result := PhSeqPeek();
    if result >= 0 then PhSeqIdx := result;
  end else result := RoomPick();
end;

// with a pack short of puller_pack in tow: the next room not done with this pack, not far; -1 = none
function PhChainRoom(): integer;
var i, UX, UY: integer;
begin
  result := -1;
  if (not PhChain) or (RoomCount() = 0) then exit;
  if PhSeq then i := PhSeqPeek() else i := RoomPick();
  if i < 0 then exit;
  if Pos(',' + IntToStr(i) + ',', PhTrip) > 0 then exit;   // done with this pack already
  UX := User.X;
  UY := User.Y;
  if RoomDist(i, UX, UY) > PH_CHAIN_DIST then exit;
  if PhSeq then PhSeqIdx := i;
  result := i;
end;

// pull room n: run into it (Lead: mobs on us come along - the leash), then its free mobs (the pack size
// counts what is on us already). Result: mobs on us
function PhPullRoom(n: integer; Lead: boolean): integer;
var k, AX, AY, UZ: integer;
  Ok: boolean;
begin
  result := 0;
  AX := RoomAnchorX(n);
  AY := RoomAnchorY(n);
  UZ := User.Z;
  if not RoomInside(n, User.X, User.Y) then begin
    if Lead then PhStateSet('To room ' + RoomName(n) + ' with ' + IntToStr(PullCountAggro()) + ' in tow')
    else PhStateSet('To room ' + RoomName(n) + ' (expected ' + IntToStr(Round(RoomExpected(n))) + ')');
    Ok := PhRunTo(AX, AY, UZ, PH_ROOM_REACH, Lead, n);
  end;
  if User.Dead then exit;
  result := PullCountAggro();
  if result >= PhPack then exit;       // a pack came on the way
  PullPolyClear();
  for k := 0 to RoomPointCount(n) - 1 do PullPolyAdd(RoomPX(n, k), RoomPY(n, k));
  PullSetPackSize(PhPack);
  PhStateSet('Pulling room ' + RoomName(n) + ': ' + IntToStr(RoomFree(n)) + ' free, ' + IntToStr(result) + ' on us');
  result := PullRun();
  RoomMarkCleared(n);
  PhTrip := PhTrip + IntToStr(n) + ',';
end;

// ===================== death =====================

procedure PhDeath();
var At: cardinal;
begin
  Engine.Msg('[Puller]', 'Dead - waiting for a resurrection (it is accepted)', 128);
  DbgFlush();
  At := 0;
  while User.Dead do begin
    if not Delay(1000) then exit;
    if GetTickCount - At > 3000 then begin
      At := GetTickCount;
      Engine.ConfirmDialog(true);
    end;
  end;
  Engine.Msg('[Puller]', 'Resurrected - going on', 128);
  Delay(2000);
  PhState := '';
  PhTrip := ',';
end;

// ===================== the puller =====================

procedure RunPuller();
var n, Cnt, Nx: integer;
  Ok: boolean;
  Order, Loot: string;
begin
  PhInit();
  if not PhHasPoint then begin
    Engine.Msg('[Puller]', 'No party point: put the Safe point on the map in nav_view.html (or SetPartyPoint) - stopped', 128);
    exit;
  end;
  Engine.FaceControl(0, false);        // the bot interface off: no auto attack, no own moves
  if PhDebugFile then DbgStart(User.Name);
  NavAddSeed(PhPX, PhPY);
  Ok := NavBuild();
  if PhGrid <> '' then PullSetGrid(PhGrid);   // mobs only on the map (after NavBuild: its own cells)
  if PhSkipChamp then begin
    if PhChampHP > 0 then PullSkipChampions(PhChampHP) else PullSkipChampions(100000);
  end;
  PullSetDash(PhDash);
  if not PhNearFree(PhPX, PhPY) then
    Engine.Msg('[Puller]', 'The party point is not on a walkable cell of the map - check the Safe point', 128);
  if PhSeq then Order := 'in turn' else Order := 'where most mobs are';
  if (Length(PhLootIDs) = 0) and (Length(PhLootNames) = 0) then Loot := 'nothing'
  else Loot := IntToStr(Length(PhLootIDs)) + ' IDs, ' + IntToStr(Length(PhLootNames)) + ' names within ' + IntToStr(PhLootRange);
  Engine.Msg('[Puller]', 'Puller: packs of ' + IntToStr(PhPack) + ' to ' + IntToStr(PhPX) + ', ' + IntToStr(PhPY) +
    ', leaving at ' + IntToStr(PhLeave) + ' on us; rooms: ' + IntToStr(RoomCount()) + ' (' + Order + '); dash ' +
    IntToStr(PhDash) + '; loot: ' + Loot, 128);
  while Delay(10) do begin
    DbgTick();
    if User.Dead then begin
      PhDeath();
      continue;
    end;
    RoomUpdate();
    Cnt := PullCountAggro();
    // mobs on us outside a pull (aggro on the way / left after the party point): a full pack, HP low or
    // no chaining -> to the party; fewer -> they come along to the next room
    if (Cnt > 0) and ((Cnt >= PhPack) or (User.HP < PH_LOW_HP) or (not PhChain)) then begin
      PhBring();
      continue;
    end;
    if Cnt = 0 then
      if PhLootTick(0, true) then continue;
    if RoomCount() = 0 then begin      // no rooms drawn: the whole map is one room
      PullPolyClear();
      PullSetPackSize(PhPack);
      PhStateSet('Pulling the map (no rooms drawn)');
      Cnt := PullRun();
      if User.Dead then continue;
      if Cnt > 0 then PhBring() else PhIdle();
      continue;
    end;
    n := PhPickRoom();
    if n < 0 then begin
      if Cnt > 0 then PhBring()        // the few on us: to the party, no room to add to them
      else begin
        PhStateSet('No room with enough mobs - waiting at the party point');
        PhIdle();
      end;
      continue;
    end;
    PhTrip := ',';
    Cnt := PhPullRoom(n, Cnt > 0);
    // short of a pack: on to the next room with them in tow
    while (Cnt > 0) and (Cnt < PhPack) and (not User.Dead) and (User.HP >= PH_LOW_HP) do begin
      Nx := PhChainRoom();
      if Nx < 0 then break;
      Cnt := PhPullRoom(Nx, true);
    end;
    if User.Dead then continue;
    if PullCountAggro() > 0 then PhBring();
  end;
  DbgFlush();
end;

end.
