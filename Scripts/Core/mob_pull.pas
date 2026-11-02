unit MobPull;

// Mob pull (body pull): run next to free mobs by the server path until the pack follows us. A mob
// behind a wall is reached along the nav map (Core\nav_move.pas: NavWaypoint) when it is built. We never
// stop while mobs are on us (the pack catches up and hits): touching a mob = at once to the next.
// A mob that does not aggro from the run past it is hit once (with the tap weapon if set). Mobs that
// are on the ignore list (PullIgnoreID: archers that shoot from their place...) are never pulled. Ends: pack full and nothing close, nothing free left,
// HP low, no new aggro for a while, pull time over, stop asked. The fight is the caller's job.
//
//   uses MobPull in 'Core\mob_pull.pas';
//   PullSetMobs([20215]);                 // [] = any mob
//   PullSetPackSize(15);
//   PullSetGrid('CRUMA_MORDEO_1.navgrid'); // mobs only on walkable cells of this grid (Library\Nav)
//   PullSet('touch_wait_ms', 800);         // any tuning value by name, see PullSet
//   ...
//   if PullRun() = 0 then <nothing to pull: stand at the safe point>
//
// Shared library: scripts only call it, nobody edits it.

interface

uses SysUtils, Classes, NavMove in 'Core\nav_move.pas';

procedure PullSetMobs(IDs: array of integer);    // mob IDs to pull; [] = any mob (from a script)
procedure PullClearMobs();                       // no mob list = any mob
procedure PullAddMob(ID: integer);               // one more mob ID to pull (from another unit)
procedure PullSetPackSize(N: integer);           // aggro count that makes a pack
procedure PullSetZRange(R: integer);             // only mobs at most R up / down from us (0 = any)
procedure PullSetGrid(GridFile: string);         // only mobs on walkable cells of this .navgrid
procedure PullSetRadius(X, Y, R: integer);       // no grid: only mobs within R of this point (0 = bot zone)
procedure PullSetTap(WeaponID, Range: integer);  // a mob that does not aggro is hit with this weapon from Range
procedure PullSetTapAlways(Enable: boolean);     // every mob is pulled by a hit of the tap weapon
procedure PullSetFarmWeapon(ID: integer);        // weapon put back after the tap (0 = the one in hands)
procedure PullSet(Key: string; Value: integer);  // tuning by name (see the list in PullSet)
procedure PullIgnore(OID, Ms: integer);          // do not run at this mob for Ms (it still counts as aggro)
procedure PullForget(OID, Ms: integer);          // unreachable (behind a wall): not aggro, not pulled for Ms
procedure PullIgnoreName(Name: string);          // never take mobs with this name
procedure PullIgnoreID(ID: integer);             // never pull / count / fight mobs with this ID (shooters...)
procedure PullSetStop(Stop: boolean);            // true = end the pull at once (farm paused, return...)
function PullRun(): integer;                     // the pull; result = mobs on us (0 = nothing to pull)
function PullIsAggro(i: integer): boolean;       // NpcList(i) is on us (shooters / ignored do not count)
function PullMobTarget(i: integer): integer;     // OID of whom NpcList(i) targets, 0 = none / gone
function PullCountAggro(): integer;
function PullIsShooter(OID: integer): boolean;    // the mob is on the ignore list (PullIgnoreID) / a skipped champion
function PullIsShooterAt(i: integer): boolean;    // the same for NpcList(i) (no search by OID: cheap)
procedure PullSkipChampions(MinMaxHP: integer);   // mobs with MaxHP above this: never pulled / fought (0 = off)
function PullIsChampion(i: integer): boolean;     // NpcList(i) is a live champion skipped by PullSkipChampions
procedure PullSetPackLive(Enable: boolean);       // true: pack = on us + every free mob of the area, every tick
procedure PullCheckShooters();                   // (does nothing now: no automatic shooters)
function PullInArea(X, Y, Z: integer): boolean;  // the point is where we pull
procedure PullPolyClear();                       // no extra polygon: the whole area
procedure PullPolyAdd(X, Y: integer);            // pull only inside this polygon too (a room)
function PullIsFree(i: integer): boolean;        // NpcList(i) is a free mob we may take
function PullTapActive(): boolean;               // the tap / farm weapon swap is ours now (disarm guard: wait)
// one by one (farm mobs where they stand): the free mob nearest by the way to it (nav map), within
// single_range; 0 = none
function PullPickSingle(): integer;
function PullCountFree(X, Y, R: integer): integer;   // free mobs of the list within R of the point
function PullDensity(): integer;                     // auto mode: this many free mobs near = a pack
procedure PullChase(OID: integer; First: boolean);   // one step of the run to this mob (never stops)
procedure PullTapRestore();                      // the farm weapon back; call every tick until not active
// the run to the farm spot with the pack behind: a pack mob is about to lose us -> one zigzag step
// across the way to it (true = this tick is ours, do not click your target). leash_range, 0 -> 800
function PullLeashTick(): boolean;

implementation

var
  MpInited: boolean;
  // tuning (PullSet)
  MpPack, MpTouchDist, MpTouchWaitMs, MpTouchGraceMs, MpTouchMax, MpSkipMs, MpIgnoreMs, MpApproachMs,
  MpTapAfterMs, MpTapMs, MpTapSkipMs, MpStaticMs, MpStaticDist, MpExtraRange, MpBackPenalty,
  MpHitRange, MpStuckMs, MpMinHP, MpNoGainMs, MpMaxMs, MpAggroDist, MpPackMult, MpStopMs,
  MpReclickDist, MpTickMs, MpGridTol, MpPullRange, MpLeash, MpZig, MpOvershoot, MpSingleRange,
  MpPackDensity: integer;
  // the pack behind us (each tick of the pull)
  MpFarX, MpFarY: integer;
  MpFarD: double;
  MpHavePack, MpWaiting: boolean;
  MpZigSign: integer;
  MpZigAt: cardinal;
  MpFarOID, MpWaitOID: integer;   // the lagging mob / the one we wait for
  MpWaitD0: double;               // its distance when we began to wait (or 4 s ago)
  MpWaitAt: cardinal;
  // why nothing was found (MpFindFree), told now and then
  MpCntAll, MpCntArea, MpCntRange, MpCntZ, MpCntSkip: integer;
  MpWhyAt: cardinal;
  // run to a mob along the nav map
  MpWpOn: boolean;
  MpWpX, MpWpY: integer;
  MpWpAt: cardinal;
  MpChaseMX, MpChaseMY: integer;   // where the mob was at our last straight click
  // config
  MpMobIDs: array of integer;
  MpZRange: integer;
  MpRX, MpRY, MpRR: integer;
  MpTapWeapon, MpTapRange, MpFarmWeapon: integer;
  MpTapAlways: boolean;
  MpNames: array of string;
  MpIgnIDs: array of integer;   // PullIgnoreID
  MpChampHP: integer;           // PullSkipChampions: 0 = champions are mobs like any other
  MpPackLive: boolean;          // PullSetPackLive: the pack size follows the free mobs (a room: respawn joins)
  MpStop: boolean;
  // area grid
  GgX0, GgY0, GgCell, GgW, GgH: integer;
  GgFree: array of boolean;
  GgOn: boolean;
  PpX, PpY: array of integer;   // PullPolyAdd: the room we farm (3+ points = on)
  PpN: integer;
  // run state
  MpLX, MpLY: integer;
  MpMovedAt, MpClickAt: cardinal;
  MpClickX, MpClickY: integer;
  MpDirX, MpDirY: integer;
  MpTouchOID: array[0..15] of integer;
  MpTouchAt: array[0..15] of cardinal;
  MpTouchCnt: array[0..15] of integer;
  MpTouchHead: integer;
  MpSkipOID: array[0..63] of integer;
  MpSkipUntil: array[0..63] of cardinal;
  MpSkipHead: integer;
  MpHardOID: array[0..31] of integer;     // PullForget
  MpHardUntil: array[0..31] of cardinal;
  MpHardHead: integer;
  MpTrkOID: array[0..31] of integer;
  MpTrkX, MpTrkY: array[0..31] of integer;
  MpTrkAt: array[0..31] of cardinal;
  MpTrkHead: integer;
  MpShootOID: array[0..31] of integer;
  MpShootHead: integer;
  // tap weapon
  MpTapOn: boolean;
  MpTapMain: integer;
  MpWearID: integer;
  MpWearUseAt, MpWearRefAt: cardinal;
  MpWearOK: boolean;

procedure MpInit();
begin
  if MpInited then exit;
  MpInited := true;
  MpPack := 10;
  MpTouchDist := 120;          // this close to a free mob = it should aggro (body pull)
  MpTouchWaitMs := 800;    // nobody on us yet, next to a mob this long without aggro -> hit it once
  MpTouchGraceMs := 3000;  // a touched mob gets this long to aggro before we run at it again
  MpTouchMax := 3;         // touched this many times without aggro = passive -> skipped
  MpSkipMs := 8000;        // a mob we got stuck on the way to -> skipped this long
  MpIgnoreMs := 30000;     // a passive / not hit mob -> skipped this long
  MpApproachMs := 15000;   // cannot get next to a mob this long -> skipped
  MpTapAfterMs := 1000;    // tap weapon: ran past a mob, no aggro this long -> tap it
  MpTapMs := 4000;         // tap weapon: swap + hit must land within this
  MpTapSkipMs := 10000;    // a tapped mob is not run at again this long (it comes to us)
  MpStaticMs := 2000;      // a mob hitting us from afar without moving this long ...
  MpStaticDist := 150;     // ... farther than this = a shooter: never pulled / fought
  MpExtraRange := 300;     // pack full: still take free mobs this close (on the way)
  MpBackPenalty := 400;    // pull order: a mob behind us costs this much extra distance
  MpHitRange := 80;        // hit only this close (farther the attack runs straight, not by the path)
  MpStuckMs := 1500;       // running to a mob without moving this long (wall) -> skip it
  MpMinHP := 50;           // HP % below this -> pull ends
  MpNoGainMs := 15000;     // no new aggro this long -> pull ends
  MpMaxMs := 60000;        // max time of one pull
  MpAggroDist := 1500;     // a mob "on us" farther than this does not count (stuck / teleported)
  MpPackMult := 2;         // this many packs on us -> pull ends at once
  MpStopMs := 300;         // not moving this long = stopped -> click again
  MpReclickDist := 80;     // the mob moved this far from our click point -> click again
  MpTickMs := 50;
  MpGridTol := 48;         // grid area: a mob this close to a walkable cell still counts
  MpPullRange := 0;        // a free mob farther than this from us is not pulled (0 = any distance)
  MpLeash := 0;            // a pack mob farther than this from us loses us: wait for it zigzagging (0 = off)
  MpZig := 180;            // zigzag: this far to each side across the way to the lagging mob
  MpOvershoot := 150;      // running at a mob we click this far past it: no stop at the click point
  MpSingleRange := 3000;   // one by one: mobs farther than this (by the way to them) are not taken
  MpPackDensity := 0;      // auto mode: this many free mobs near us -> pull a pack (0 = half the pack)
  MpTapRange := 80;
end;

// tuning by name; unknown name -> a message
procedure PullSet(Key: string; Value: integer);
var K: string;
begin
  MpInit();
  K := LowerCase(Key);
  if K = 'pack' then MpPack := Value
  else if K = 'touch' then MpTouchDist := Value
  else if K = 'touch_wait_ms' then MpTouchWaitMs := Value
  else if K = 'touch_grace_ms' then MpTouchGraceMs := Value
  else if K = 'touch_max' then MpTouchMax := Value
  else if K = 'skip_ms' then MpSkipMs := Value
  else if K = 'ignore_ms' then MpIgnoreMs := Value
  else if K = 'approach_ms' then MpApproachMs := Value
  else if K = 'tap_after_ms' then MpTapAfterMs := Value
  else if K = 'tap_ms' then MpTapMs := Value
  else if K = 'tap_skip_ms' then MpTapSkipMs := Value
  else if K = 'static_ms' then MpStaticMs := Value
  else if K = 'static_dist' then MpStaticDist := Value
  else if K = 'extra_range' then MpExtraRange := Value
  else if K = 'back_penalty' then MpBackPenalty := Value
  else if K = 'hit_range' then MpHitRange := Value
  else if K = 'stuck_ms' then MpStuckMs := Value
  else if K = 'min_hp' then MpMinHP := Value
  else if K = 'nogain_ms' then MpNoGainMs := Value
  else if K = 'max_ms' then MpMaxMs := Value
  else if K = 'aggro_dist' then MpAggroDist := Value
  else if K = 'pack_mult' then MpPackMult := Value
  else if K = 'stop_ms' then MpStopMs := Value
  else if K = 'reclick_dist' then MpReclickDist := Value
  else if K = 'tick_ms' then MpTickMs := Value
  else if K = 'grid_tol' then MpGridTol := Value
  else if K = 'pull_range' then MpPullRange := Value
  else if K = 'leash_range' then MpLeash := Value
  else if K = 'zig' then MpZig := Value
  else if K = 'overshoot' then MpOvershoot := Value
  else if K = 'single_range' then MpSingleRange := Value
  else if K = 'pack_density' then MpPackDensity := Value
  else Engine.Msg('[Pull]', 'PullSet: unknown "' + Key + '"', 255);
end;

procedure PullSetMobs(IDs: array of integer);
var i: integer;
begin
  MpInit();
  SetLength(MpMobIDs, 0);
  for i := 0 to Length(IDs) - 1 do
    if IDs[i] > 0 then begin           // [0] = any mob too
      SetLength(MpMobIDs, Length(MpMobIDs) + 1);
      MpMobIDs[Length(MpMobIDs) - 1] := IDs[i];
    end;
end;

procedure PullClearMobs();
begin
  MpInit();
  SetLength(MpMobIDs, 0);
end;

procedure PullAddMob(ID: integer);
begin
  MpInit();
  if ID <= 0 then exit;                // 0 = any mob
  SetLength(MpMobIDs, Length(MpMobIDs) + 1);
  MpMobIDs[Length(MpMobIDs) - 1] := ID;
end;

procedure PullSetPackSize(N: integer);
begin
  MpInit();
  MpPack := N;
  if MpPack < 1 then MpPack := 1;
end;

procedure PullSetZRange(R: integer);
begin
  MpInit();
  MpZRange := R;
end;

procedure PullSetRadius(X, Y, R: integer);
begin
  MpInit();
  MpRX := X;
  MpRY := Y;
  MpRR := R;
end;

procedure PullSetTap(WeaponID, Range: integer);
begin
  MpInit();
  MpTapWeapon := WeaponID;
  MpTapRange := Range;
  if MpTapRange <= 0 then MpTapRange := MpHitRange;
end;

procedure PullSetTapAlways(Enable: boolean);
begin
  MpInit();
  MpTapAlways := Enable;
end;

procedure PullSetFarmWeapon(ID: integer);
begin
  MpInit();
  MpFarmWeapon := ID;
end;

procedure PullSetStop(Stop: boolean);
begin
  MpStop := Stop;
end;

procedure PullIgnoreID(ID: integer);
begin
  MpInit();
  if ID <= 0 then exit;
  SetLength(MpIgnIDs, Length(MpIgnIDs) + 1);
  MpIgnIDs[Length(MpIgnIDs) - 1] := ID;
end;

procedure PullIgnoreName(Name: string);
begin
  MpInit();
  SetLength(MpNames, Length(MpNames) + 1);
  MpNames[Length(MpNames) - 1] := LowerCase(Name);
end;

procedure PullIgnore(OID, Ms: integer);
begin
  MpInit();
  MpSkipOID[MpSkipHead] := OID;
  MpSkipUntil[MpSkipHead] := GetTickCount + Ms;
  MpSkipHead := (MpSkipHead + 1) mod 64;
end;

procedure PullForget(OID, Ms: integer);
begin
  MpInit();
  MpHardOID[MpHardHead] := OID;
  MpHardUntil[MpHardHead] := GetTickCount + Ms;
  MpHardHead := (MpHardHead + 1) mod 32;
end;

function MpSkippedHard(OID: integer): boolean;
var k: integer;
begin
  result := false;
  for k := 0 to 31 do
    if (MpHardOID[k] = OID) and (GetTickCount < MpHardUntil[k]) then begin
      result := true;
      exit;
    end;
end;

function MpSkipped(OID: integer): boolean;
var k: integer;
begin
  result := false;
  for k := 0 to 63 do
    if (MpSkipOID[k] = OID) and (GetTickCount < MpSkipUntil[k]) then begin
      result := true;
      exit;
    end;
end;

function MpField(S: string; k: integer): string;
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

// the walkable cells ('.') of a .navgrid are where we pull
procedure PullSetGrid(GridFile: string);
var L: TStringList;
  i, cx, cy, n: integer;
  S, F, Row: string;
begin
  MpInit();
  GgOn := false;
  F := Script.Path + '..\Nav\' + GridFile;
  if not FileExists(F) then begin
    Engine.Msg('[Pull]', 'No grid file ' + F + ' - pulling in the bot zone', 255);
    exit;
  end;
  L := TStringList.Create;
  L.LoadFromFile(F);
  cy := -1;
  n := 0;
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    if MpField(S, 0) = 'G' then begin
      GgX0 := StrToIntDef(MpField(S, 1), 0);
      GgY0 := StrToIntDef(MpField(S, 2), 0);
      GgCell := StrToIntDef(MpField(S, 3), 32);
      GgW := StrToIntDef(MpField(S, 4), 0);
      GgH := StrToIntDef(MpField(S, 5), 0);
      SetLength(GgFree, GgW * GgH);
      for cx := 0 to GgW * GgH - 1 do GgFree[cx] := false;
      cy := 0;
    end else if (Copy(S, 1, 2) = 'R ') and (cy >= 0) and (cy < GgH) then begin
      Row := Copy(S, 3, GgW);
      for cx := 0 to Length(Row) - 1 do
        if Row[cx + 1] = '.' then begin
          GgFree[cy * GgW + cx] := true;
          Inc(n);
        end;
      Inc(cy);
    end;
  end;
  L.Free;
  GgOn := (GgW > 0) and (n > 0);
  Engine.Msg('[Pull]', 'Pull area: ' + GridFile + ', ' + IntToStr(n) + ' walkable cells', 128);
end;

function MpGridFree(X, Y: integer): boolean;
var cx, cy: integer;
begin
  result := false;
  if (X < GgX0) or (Y < GgY0) then exit;
  cx := (X - GgX0) div GgCell;
  cy := (Y - GgY0) div GgCell;
  if (cx >= GgW) or (cy >= GgH) then exit;
  result := GgFree[cy * GgW + cx];
end;

procedure PullPolyClear();
begin
  PpN := 0;
end;

procedure PullPolyAdd(X, Y: integer);
begin
  if PpN >= Length(PpX) then begin
    SetLength(PpX, PpN + 16);
    SetLength(PpY, PpN + 16);
  end;
  PpX[PpN] := X;
  PpY[PpN] := Y;
  Inc(PpN);
end;

function MpInPoly(X, Y: integer): boolean;
var k, j: integer;
begin
  result := true;
  if PpN < 3 then exit;
  result := false;
  j := PpN - 1;
  for k := 0 to PpN - 1 do begin
    if ((PpY[k] > Y) <> (PpY[j] > Y)) and
       (X < (PpX[j] - PpX[k]) * (Y - PpY[k]) / (PpY[j] - PpY[k]) + PpX[k]) then result := not result;
    j := k;
  end;
end;

function PullInArea(X, Y, Z: integer): boolean;
var DX, DY: double;
  T: integer;
begin
  MpInit();
  if not MpInPoly(X, Y) then begin     // a room is set: only inside it
    result := false;
    exit;
  end;
  if GgOn then begin
    T := MpGridTol;                    // a mob at the very wall stands on a cell painted as wall
    result := MpGridFree(X, Y) or MpGridFree(X - T, Y) or MpGridFree(X + T, Y) or
              MpGridFree(X, Y - T) or MpGridFree(X, Y + T);
  end else if MpRR > 0 then begin
    DX := X - MpRX;
    DY := Y - MpRY;
    result := Sqrt(DX * DX + DY * DY) <= MpRR;
  end else
    result := Engine.InZone(X, Y, Z);
end;

function MpDist(X, Y: integer): double;
var UX, UY: integer;
  DX, DY: double;
begin
  UX := User.X;
  UY := User.Y;
  DX := X - UX;
  DY := Y - UY;
  result := Sqrt(DX * DX + DY * DY);
end;

function MpIdx(OID: integer): integer;
var i: integer;
begin
  result := -1;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then
    if NpcList(i).OID = OID then begin
      result := i;
      exit;
    end;
end;

function MpNameIgnored(i: integer): boolean;
var k: integer;
  N: string;
begin
  result := false;
  if Length(MpNames) = 0 then exit;
  N := LowerCase(NpcList(i).Name);
  for k := 0 to Length(MpNames) - 1 do
    if N = MpNames[k] then begin
      result := true;
      exit;
    end;
end;

function MpWhitelisted(i: integer): boolean;
var j, ID: integer;
begin
  result := Length(MpMobIDs) = 0;
  if result then exit;
  ID := NpcList(i).ID;
  for j := 0 to Length(MpMobIDs) - 1 do
    if ID = MpMobIDs[j] then begin
      result := true;
      exit;
    end;
end;

function MpZOk(Z: integer): boolean;
var UZ: integer;
begin
  UZ := User.Z;
  result := (MpZRange <= 0) or (Abs(Z - UZ) <= MpZRange);
end;

// ---------- run by the server path ----------

function MpHex(Value: integer): string;
begin
  result := IntToHex(Value and $FF, 2) + IntToHex((Value shr 8) and $FF, 2) +
            IntToHex((Value shr 16) and $FF, 2) + IntToHex((Value shr 24) and $FF, 2);
end;

procedure MpMoveReset();
begin
  MpLX := User.X;
  MpLY := User.Y;
  MpMovedAt := GetTickCount;
end;

function MpStillMs(): cardinal;
var UX, UY: integer;
begin
  UX := User.X;
  UY := User.Y;
  if (UX - MpLX) * (UX - MpLX) + (UY - MpLY) * (UY - MpLY) >= 100 then begin
    MpLX := UX;
    MpLY := UY;
    MpMovedAt := GetTickCount;
  end;
  result := GetTickCount - MpMovedAt;
end;

// one server path click (mouse click packet), remembered: it is NOT repeated on a timer - a new click
// makes the server build the path anew, and its first node may lie behind us
procedure MpClick(X, Y, Z: integer);
var UX, UY, UZ: integer;
begin
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  NavSend('0F' + MpHex(X) + MpHex(Y) + MpHex(Z) + MpHex(UX) + MpHex(UY) + MpHex(UZ) + MpHex(1));
  MpClickX := X;
  MpClickY := Y;
  MpClickAt := GetTickCount;
end;

function MpNeedClick(X, Y: integer): boolean;
var DX, DY: double;
begin
  result := true;
  if MpClickAt = 0 then exit;
  DX := X - MpClickX;
  DY := Y - MpClickY;
  if Sqrt(DX * DX + DY * DY) > MpReclickDist then exit;
  result := (MpStillMs() >= MpStopMs) and (GetTickCount - MpClickAt >= MpStopMs);
end;

// run to a mob, never stopping: in sight -> click 150 PAST it (we run through it - the touch / hit
// happens on the way, no stop at the click point); behind a wall -> the farthest node of the nav map
// route in sight, the next one asked as soon as we are near it. A new click only when the mob moved,
// we are near the click point or we stopped. First = the first click of this run
procedure MpChase(MX, MY, MZ: integer; First: boolean);
var TX, TY, UX, UY: integer;
  DX, DY, L: double;
  Again: boolean;
begin
  UX := User.X;
  UY := User.Y;
  if NavIsReady() then begin
    Again := First or (GetTickCount - MpWpAt > 500);
    if MpWpOn and (Sqrt(Sqr(MpWpX - UX) + Sqr(MpWpY - UY)) < 120) then Again := true;
    if Again then begin
      MpWpOn := NavWaypoint(MX, MY);
      if MpWpOn then begin
        MpWpX := NavWpX();
        MpWpY := NavWpY();
      end;
      MpWpAt := GetTickCount;
    end;
  end else MpWpOn := false;
  if MpWpOn then begin
    TX := MpWpX;
    TY := MpWpY;
    if First or (Sqrt(Sqr(TX - MpClickX) + Sqr(TY - MpClickY)) > MpReclickDist) or
       (MpStillMs() >= MpStopMs) then MpClick(TX, TY, MZ);
    exit;
  end;
  // straight at the mob: the overshoot direction is kept between clicks (no turning back after we
  // ran past it)
  Again := First or (MpStillMs() >= MpStopMs);
  if Sqrt(Sqr(MX - MpChaseMX) + Sqr(MY - MpChaseMY)) > MpReclickDist then Again := true;
  if Sqrt(Sqr(MpClickX - UX) + Sqr(MpClickY - UY)) < 100 then Again := true;
  if not Again then exit;
  DX := MX - UX;
  DY := MY - UY;
  L := Sqrt(DX * DX + DY * DY);
  TX := MX;
  TY := MY;
  if L > 1 then begin
    TX := MX + Round(DX / L * MpOvershoot);
    TY := MY + Round(DY / L * MpOvershoot);
    if NavIsReady() and (not NavSee(MX, MY, TX, TY)) then begin   // a wall right behind it: no overshoot
      TX := MX;
      TY := MY;
    end;
  end;
  MpChaseMX := MX;
  MpChaseMY := MY;
  MpClick(TX, TY, MZ);
end;

// ---------- ignored mobs, aggro ----------

function MpIgnoredID(ID: integer): boolean;
var k: integer;
begin
  result := false;
  for k := 0 to Length(MpIgnIDs) - 1 do
    if MpIgnIDs[k] = ID then begin
      result := true;
      exit;
    end;
end;

// a mob of the ignore list (PullIgnoreID): never pulled, never counted as aggro, not fought
function PullIsShooterAt(i: integer): boolean;
var ID, HP: integer;
begin
  result := false;
  if (Length(MpIgnIDs) = 0) and (MpChampHP <= 0) then exit;
  if (i < 0) or (i >= NpcList.Count) then exit;
  if MpChampHP > 0 then begin          // a champion: as if it were not there
    HP := NpcList(i).MaxHP;
    if HP > MpChampHP then begin
      result := true;
      exit;
    end;
  end;
  if Length(MpIgnIDs) = 0 then exit;
  ID := NpcList(i).ID;
  result := MpIgnoredID(ID);
end;

function PullIsShooter(OID: integer): boolean;
var i, ID, HP: integer;
begin
  result := false;
  if (Length(MpIgnIDs) = 0) and (MpChampHP <= 0) then exit;
  i := MpIdx(OID);
  if i < 0 then exit;
  if MpChampHP > 0 then begin          // a champion: as if it were not there
    HP := NpcList(i).MaxHP;
    if HP > MpChampHP then begin
      result := true;
      exit;
    end;
  end;
  if Length(MpIgnIDs) = 0 then exit;
  ID := NpcList(i).ID;
  result := MpIgnoredID(ID);
end;

procedure PullSkipChampions(MinMaxHP: integer);
begin
  MpChampHP := MinMaxHP;
end;

function PullIsChampion(i: integer): boolean;
var HP: integer;
begin
  result := false;
  if (MpChampHP <= 0) or NpcList(i).Dead then exit;
  HP := NpcList(i).MaxHP;
  result := HP > MpChampHP;
end;

// no automatic shooter detection any more (it took normal mobs for shooters): the ignore list only
procedure PullCheckShooters();
begin
end;

// whom the mob targets. The list changes in the bot's own thread while we walk it: the index may be
// past its end now and the target object may be gone - no exception (a try round .Target.OID broke
// the script with "Invalid pointer operation"): the object is taken once and checked for nil
function PullMobTarget(i: integer): integer;
var T: TL2Live;
begin
  result := 0;
  if (i < 0) or (i >= NpcList.Count) then exit;
  T := NpcList(i).Target;
  if T <> nil then result := T.OID;
end;

function PullIsAggro(i: integer): boolean;
var Atk, Tgt, NX, NY, OID: integer;
begin
  MpInit();
  result := false;
  if i >= NpcList.Count then exit;
  if NpcList(i).Dead then exit;
  OID := NpcList(i).OID;
  if MpSkippedHard(OID) or PullIsShooterAt(i) then exit;
  Atk := NpcList(i).AtkOID;
  Tgt := PullMobTarget(i);
  if (Atk <> User.OID) and (Tgt <> User.OID) then exit;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  result := MpDist(NX, NY) < MpAggroDist;
end;

function PullCountAggro(): integer;
var i: integer;
begin
  result := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then
    if PullIsAggro(i) then Inc(result);
end;

// ---------- touch list (mobs we ran past) ----------

procedure MpTouch(OID: integer);
var i: integer;
begin
  MpDirX := User.X;
  MpDirY := User.Y;
  for i := 0 to 15 do
    if MpTouchOID[i] = OID then begin
      if GetTickCount - MpTouchAt[i] >= MpTouchGraceMs then begin   // one touch per grace time
        MpTouchAt[i] := GetTickCount;
        Inc(MpTouchCnt[i]);
      end;
      exit;
    end;
  MpTouchOID[MpTouchHead] := OID;
  MpTouchAt[MpTouchHead] := GetTickCount;
  MpTouchCnt[MpTouchHead] := 1;
  MpTouchHead := (MpTouchHead + 1) mod 16;
end;

function MpTouchSlot(OID: integer): integer;
var i: integer;
begin
  result := -1;
  for i := 0 to 15 do
    if MpTouchOID[i] = OID then begin
      result := i;
      exit;
    end;
end;

// the next free mob within MaxDist (0 = none): nearest first, one behind us costs back_penalty more
// (we run on along the zone, not back and forth); a just touched one only if nothing else is free;
// touched touch_max times without aggro -> passive, skipped
function MpFindFree(MaxDist: integer): integer;
var i, NX, NY, NZ, OID, UX, UY, Slot, Pass: integer;
  D, BestD, Cost, FX, FY, FL, MXd, MYd, CosA, LDX, LDY, LD, LimD: double;
  T, Grace: cardinal;
begin
  result := 0;
  UX := User.X;
  UY := User.Y;
  FX := UX - MpDirX;
  FY := UY - MpDirY;
  FL := Sqrt(FX * FX + FY * FY);
  Grace := MpTouchGraceMs;
  if MpTapWeapon > 0 then Grace := MpTapAfterMs;   // no aggro soon -> it gets tapped
  MpCntAll := 0;
  MpCntArea := 0;
  MpCntRange := 0;
  MpCntZ := 0;
  MpCntSkip := 0;
  for Pass := 0 to 1 do begin
    BestD := 999999999;
    for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
      if NpcList(i).Dead or MpNameIgnored(i) then continue;
      if PullIsAggro(i) then continue;
      if not MpWhitelisted(i) then continue;
      if Pass = 0 then Inc(MpCntAll);
      OID := NpcList(i).OID;
      if MpSkipped(OID) or MpSkippedHard(OID) or PullIsShooterAt(i) then begin
        if Pass = 0 then Inc(MpCntSkip);
        continue;
      end;
      Slot := MpTouchSlot(OID);
      if Slot >= 0 then begin
        T := GetTickCount - MpTouchAt[Slot];
        if (MpTouchCnt[Slot] >= MpTouchMax) and (T >= MpTouchGraceMs) then begin
          PullIgnore(OID, MpIgnoreMs);   // ran past it again and again, it never comes: passive
          MpTouchOID[Slot] := 0;
          continue;
        end;
        if (Pass = 0) and (T < Grace) then continue;
      end;
      NX := NpcList(i).X;
      NY := NpcList(i).Y;
      NZ := NpcList(i).Z;
      if not PullInArea(NX, NY, NZ) then begin
        if Pass = 0 then Inc(MpCntArea);
        continue;
      end;
      if not MpZOk(NZ) then begin
        if Pass = 0 then Inc(MpCntZ);
        continue;
      end;
      D := MpDist(NX, NY);
      if D > MaxDist then continue;
      // pull_range: with a pack behind us a free mob farther than this is not taken (we would run
      // away from the pack); the first mob of a pull may be anywhere in the area
      if (MpPullRange > 0) and MpHavePack and (D > MpPullRange) then begin
        if Pass = 0 then Inc(MpCntRange);
        continue;
      end;
      // (leash: no filter here - a stretched pack is kept together by the zigzag in PullRun)
      LimD := MpTouchDist * 2;
      if (Pass = 1) and (D <= LimD) then continue;   // just touched and still next to us: no use
      Cost := D;
      if PpN >= 3 then begin
        // a room: from where the pull began (the entry) to the far end - near us AND near the entry
        // first, a mob behind a wall (not seen straight) later
        LDX := NX - MpDirX;
        LDY := NY - MpDirY;
        LD := Sqrt(LDX * LDX + LDY * LDY);
        Cost := D + LD * 0.7;
        // the sight check is a line through the map: only for a mob that could still win
        if (Cost < BestD) and (not NavSee(UX, UY, NX, NY)) then Cost := Cost + 400;
      end else if (FL > 50) and (D > 1) then begin
        MXd := NX - UX;
        MYd := NY - UY;
        CosA := (FX * MXd + FY * MYd) / (FL * D);
        Cost := D + MpBackPenalty * (1 - CosA) / 2;
      end;
      if Cost < BestD then begin
        BestD := Cost;
        result := OID;
      end;
    end;
    if result <> 0 then exit;
  end;
end;

// ---------- one by one ----------

// a free mob we may take: alive, on the list, not ignored / skipped / on us, in the area, our floor
function MpFreeOK(i: integer): boolean;
var OID, NX, NY, NZ: integer;
begin
  result := false;
  if NpcList(i).Dead or MpNameIgnored(i) then exit;
  if PullIsAggro(i) or (not MpWhitelisted(i)) then exit;
  OID := NpcList(i).OID;
  if MpSkipped(OID) or MpSkippedHard(OID) or PullIsShooterAt(i) then exit;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  if not PullInArea(NX, NY, NZ) then exit;
  result := MpZOk(NZ);
end;

function PullIsFree(i: integer): boolean;
begin
  MpInit();
  result := MpFreeOK(i);
end;

procedure PullSetPackLive(Enable: boolean);
begin
  MpPackLive := Enable;
end;

// every free mob we may take now (the area / the room polygon, our floor)
function MpCountFreeAll(): integer;
var i: integer;
begin
  result := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then
    if MpFreeOK(i) then Inc(result);
end;

function PullCountFree(X, Y, R: integer): integer;
var i, NX, NY: integer;
  DX, DY: double;
begin
  MpInit();
  result := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if not MpFreeOK(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    DX := NX - X;
    DY := NY - Y;
    if Sqrt(DX * DX + DY * DY) <= R then Inc(result);
  end;
end;

function PullDensity(): integer;
begin
  MpInit();
  result := MpPackDensity;
  if result <= 0 then result := MpPack div 2;
  if result < 2 then result := 2;
end;

// the nearest by the way: the 6 nearest in a straight line are measured along the nav map
function PullPickSingle(): integer;
var i, k, n, NX, NY, Best: integer;
  D, BestD, PL: double;
  CandOID: array[0..5] of integer;
  CandD: array[0..5] of double;
  CandX, CandY: array[0..5] of integer;
begin
  MpInit();
  result := 0;
  n := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if not MpFreeOK(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    D := MpDist(NX, NY);
    if D > MpSingleRange then continue;
    // keep the 6 nearest (straight)
    if n < 6 then begin
      CandOID[n] := NpcList(i).OID;
      CandD[n] := D;
      CandX[n] := NX;
      CandY[n] := NY;
      Inc(n);
    end else begin
      Best := 0;
      for k := 1 to 5 do if CandD[k] > CandD[Best] then Best := k;
      if D < CandD[Best] then begin
        CandOID[Best] := NpcList(i).OID;
        CandD[Best] := D;
        CandX[Best] := NX;
        CandY[Best] := NY;
      end;
    end;
  end;
  BestD := 1E18;
  for k := 0 to n - 1 do begin
    PL := CandD[k];
    NX := CandX[k];
    NY := CandY[k];
    if NavIsReady() then PL := NavPathLen(NX, NY);
    if (PL < 0) or (PL > MpSingleRange) then continue;   // no way / too far by the way
    if PL < BestD then begin
      BestD := PL;
      result := CandOID[k];
    end;
  end;
end;

procedure PullChase(OID: integer; First: boolean);
var i, MX, MY, MZ: integer;
begin
  MpInit();
  i := MpIdx(OID);
  if i < 0 then exit;
  MX := NpcList(i).X;
  MY := NpcList(i).Y;
  MZ := NpcList(i).Z;
  if First then MpMoveReset();
  MpChase(MX, MY, MZ, First);
end;

// ---------- tap weapon ----------

function MpEquipped(ItemID: integer): boolean;
var i, ID: integer;
begin
  result := false;
  for i := 0 to Inventory.User.Count - 1 do if i < Inventory.User.Count then begin
    ID := Inventory.User.Items(i).ID;
    if (ID = ItemID) and Inventory.User.Items(i).Equipped then begin
      result := true;
      exit;
    end;
  end;
end;

// the weapon in hands now (right hand $0080 / two hands $4000), from a fresh inventory; 0 = none
function MpCurrentWeapon(): integer;
var i, Part: integer;
begin
  result := 0;
  NavSend('14');
  Delay(1500);
  for i := 0 to Inventory.User.Count - 1 do if i < Inventory.User.Count then begin
    if not Inventory.User.Items(i).Equipped then continue;
    Part := Inventory.User.Items(i).BodyPart;
    if (Part = $0080) or (Part = $4000) then begin
      result := Inventory.User.Items(i).ID;
      exit;
    end;
  end;
end;

// puts weapon W on without blocking (call every tick); true = on. The bot's "equipped" flag is
// trusted only from an inventory the server resent after our last UseItem (a 2nd UseItem of a weapon
// that is on takes it OFF)
function MpWear(W: integer): boolean;
var T: cardinal;
begin
  result := false;
  T := GetTickCount;
  if MpWearID <> W then begin
    MpWearID := W;
    MpWearOK := false;
    MpWearUseAt := 0;
    NavSend('14');
    MpWearRefAt := T;
    exit;
  end;
  if MpWearOK then begin
    result := true;
    exit;
  end;
  if T - MpWearRefAt < 800 then exit;
  if MpWearRefAt > MpWearUseAt then begin
    if MpEquipped(W) then begin
      MpWearOK := true;
      result := true;
      exit;
    end;
    if MpWearUseAt > 0 then Engine.Msg('[Weapon]', 'Item ' + IntToStr(W) + ' still not on, using it again', 0);
    Engine.UseItem(W);
    MpWearUseAt := T;
    exit;
  end;
  if T - MpWearUseAt < 1000 then exit;
  NavSend('14');
  MpWearRefAt := T;
end;

function MpTapReady(): boolean;
var W: integer;
begin
  if not MpTapOn then begin
    MpTapMain := MpFarmWeapon;
    if MpTapMain <= 0 then MpTapMain := MpCurrentWeapon();
    MpTapOn := true;
    if MpTapMain = MpTapWeapon then
      Engine.Msg('[Weapon]', 'Farm weapon = tap weapon ' + IntToStr(MpTapMain) +
        ' (started with it in hands?) - set the farm weapon in the script', 128)
    else
      Engine.Msg('[Weapon]', 'Pull: tap weapon ' + IntToStr(MpTapWeapon) + ', farm weapon ' +
        IntToStr(MpTapMain) + ' after it', 0);
  end;
  W := MpTapWeapon;
  result := MpWear(W);
end;

function PullTapActive(): boolean;
begin
  result := MpTapOn;
end;

procedure PullTapRestore();
var W: integer;
begin
  if not MpTapOn then exit;
  W := MpTapMain;
  if (W <= 0) or MpWear(W) then begin
    MpTapOn := false;
    Engine.Msg('[Weapon]', 'Farm weapon ' + IntToStr(W) + ' is on', 0);
  end;
end;

// this mob is to be tapped: we ran past it tap_after_ms ago without aggro, or nobody is on us yet
// and it stands next to us without aggro (or tap always)
function MpNeedTap(OID, Cnt: integer; NearSince: cardinal): boolean;
var Slot: integer;
begin
  result := false;
  if MpTapWeapon <= 0 then exit;
  if MpTapAlways then begin
    result := true;
    exit;
  end;
  Slot := MpTouchSlot(OID);
  if (Slot >= 0) and (GetTickCount - MpTouchAt[Slot] >= MpTapAfterMs) then result := true;
  if (Cnt = 0) and (NearSince > 0) and (GetTickCount - NearSince >= MpTouchWaitMs) then result := true;
end;

function MpMustStop(): boolean;
begin
  result := MpStop or User.Dead;
end;

// the most lagging mob of the pack on us (farthest from us)
procedure MpUpdatePack();
var i, NX, NY: integer;
  D: double;
begin
  MpHavePack := false;
  MpFarD := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if not PullIsAggro(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    D := MpDist(NX, NY);
    if (not MpHavePack) or (D > MpFarD) then begin
      MpFarD := D;
      MpFarX := NX;
      MpFarY := NY;
      MpFarOID := NpcList(i).OID;
      MpHavePack := true;
    end;
  end;
end;

// the pack is stretched: keep moving (standing = being hit) but not farther from the lagging mob:
// run across the way to it, side to side by "zig", a little towards it, until it catches up
procedure MpZigzag();
var UX, UY, UZ, TX, TY: integer;
  VX, VY, L: double;
begin
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  VX := MpFarX - UX;
  VY := MpFarY - UY;
  L := Sqrt(VX * VX + VY * VY);
  if L < 1 then exit;
  VX := VX / L;
  VY := VY / L;
  // the side is changed before we reach the side point (no stop there)
  if (MpZigAt = 0) or (GetTickCount - MpZigAt > 1500) or (MpStillMs() >= MpStopMs) or
     (Sqrt(Sqr(MpClickX - UX) + Sqr(MpClickY - UY)) < 60) then begin
    if MpZigSign = 0 then MpZigSign := 1 else MpZigSign := -MpZigSign;
    TX := UX + Round(-VY * MpZig * MpZigSign + VX * 40);
    TY := UY + Round(VX * MpZig * MpZigSign + VY * 40);
    if not PullInArea(TX, TY, UZ) then begin   // that side is a wall / out of the area: the other side
      MpZigSign := -MpZigSign;
      TX := UX + Round(-VY * MpZig * MpZigSign + VX * 40);
      TY := UY + Round(VX * MpZig * MpZigSign + VY * 40);
    end;
    MpMoveReset();
    MpClick(TX, TY, UZ);
    MpZigAt := GetTickCount;
  end;
end;

function PullLeashTick(): boolean;
var Idx: integer;
  L, LimHi, LimLo: double;
begin
  MpInit();
  result := false;
  L := MpLeash;
  if L <= 0 then L := 800;
  MpUpdatePack();
  if not MpHavePack then begin
    MpWaiting := false;
    exit;
  end;
  LimHi := L * 0.85;
  LimLo := L * 0.6;
  if (not MpWaiting) and (MpFarD > LimHi) then begin
    MpWaiting := true;
    MpZigAt := 0;
    MpWaitOID := MpFarOID;
    MpWaitD0 := MpFarD;
    MpWaitAt := GetTickCount;
    Engine.Msg('[Pull]', 'Pack stretched (' + IntToStr(Round(MpFarD)) + ') on the way to the spot, zigzag', 0);
  end else if MpWaiting and (MpFarD < LimLo) then MpWaiting := false;
  if not MpWaiting then exit;
  if MpFarOID <> MpWaitOID then begin
    MpWaitOID := MpFarOID;
    MpWaitD0 := MpFarD;
    MpWaitAt := GetTickCount;
  end else if GetTickCount - MpWaitAt > 4000 then begin
    if MpFarD > MpWaitD0 - 100 then begin   // it does not come (wall): not waiting for it
      Idx := MpIdx(MpWaitOID);
      if Idx >= 0 then
        Engine.Msg('[Pull]', NpcList(Idx).Name + ' does not come (' + IntToStr(Round(MpFarD)) + '), not waiting for it', 0);
      PullForget(MpWaitOID, MpIgnoreMs);
      MpWaiting := false;
      exit;
    end;
    MpWaitD0 := MpFarD;
    MpWaitAt := GetTickCount;
  end;
  MpZigzag();
  result := true;
end;

// ---------- the pull ----------

function PullRun(): integer;
var OID, Idx, MX, MY, MZ, Cnt, Prev, Limit, HP, TapHP0: integer;
  Started, LastGain, NearSince, LastSend, ApproachSince, TapStart: cardinal;
  Tapped, Tapping, TapOk: boolean;
  LimHi, LimLo: double;
begin
  MpInit();
  result := 0;
  Tapping := false;
  TapHP0 := 0;
  TapStart := 0;
  Started := GetTickCount;
  LastGain := GetTickCount;
  Prev := -1;
  OID := 0;
  Tapped := false;
  NearSince := 0;
  LastSend := 0;
  ApproachSince := 0;
  MpDirX := User.X;
  MpDirY := User.Y;
  MpWaiting := false;                  // a new pull: no waiting carried over
  while not MpMustStop() do begin
    PullCheckShooters();
    Cnt := PullCountAggro();
    result := Cnt;
    if MpPackLive then begin             // a mob that came up meanwhile is taken too
      Limit := Cnt + MpCountFreeAll();
      if Limit < 1 then Limit := 1;
      if Limit > MpPack then
        Engine.Msg('[Pull]', 'New mobs in the room: pack ' + IntToStr(MpPack) + ' -> ' + IntToStr(Limit), 0);
      MpPack := Limit;
    end;
    if Cnt <> Prev then begin
      if Cnt > Prev then LastGain := GetTickCount;
      Engine.Msg('[Pull]', 'Aggro ' + IntToStr(Cnt) + '/' + IntToStr(MpPack), 0);
      Prev := Cnt;
    end;
    if Cnt >= MpPackMult * MpPack then begin
      Engine.Msg('[Pull]', 'Pull end: ' + IntToStr(Cnt) + ' (' + IntToStr(MpPackMult) + ' packs)', 0);
      exit;
    end;
    Limit := 999999;
    if Cnt >= MpPack then Limit := MpExtraRange;   // pack full: only free mobs right on the way
    if Cnt > 0 then begin
      if User.HP < MpMinHP then begin
        Engine.Msg('[Pull]', 'Pull end: ' + IntToStr(Cnt) + ', HP low', 0);
        exit;
      end;
      if GetTickCount - LastGain > MpNoGainMs then begin
        Engine.Msg('[Pull]', 'Pull end: ' + IntToStr(Cnt) + ', no new aggro ' + IntToStr(MpNoGainMs div 1000) + ' sec', 0);
        exit;
      end;
      if GetTickCount - Started > MpMaxMs then begin
        Engine.Msg('[Pull]', 'Pull end: ' + IntToStr(Cnt) + ', pull time is over', 0);
        exit;
      end;
    end;

    // leash: the most lagging pack mob is about to lose us -> zigzag until it catches up
    MpUpdatePack();
    if (MpLeash > 0) and MpHavePack then begin
      LimHi := MpLeash * 0.85;
      LimLo := MpLeash * 0.6;
      if (not MpWaiting) and (MpFarD > LimHi) then begin
        MpWaiting := true;
        MpZigAt := 0;
        MpWaitOID := MpFarOID;
        MpWaitD0 := MpFarD;
        MpWaitAt := GetTickCount;
        Engine.Msg('[Pull]', 'Pack stretched (' + IntToStr(Round(MpFarD)) + '), zigzag until it catches up', 0);
      end else if MpWaiting and (MpFarD < LimLo) then begin
        MpWaiting := false;
        OID := 0;                      // pick the next mob from here
      end;
      // the lagging mob does not come closer (stuck behind a wall / does not chase us): we do not
      // wait for it - it is dropped from the pack for a while, the pull goes on
      if MpWaiting then begin
        if MpFarOID <> MpWaitOID then begin
          MpWaitOID := MpFarOID;
          MpWaitD0 := MpFarD;
          MpWaitAt := GetTickCount;
        end else if GetTickCount - MpWaitAt > 4000 then begin
          if MpFarD > MpWaitD0 - 100 then begin
            Idx := MpIdx(MpWaitOID);
            if Idx >= 0 then
              Engine.Msg('[Pull]', NpcList(Idx).Name + ' does not come (' + IntToStr(Round(MpFarD)) +
                '), not waiting for it', 0);
            PullForget(MpWaitOID, MpIgnoreMs);
            MpWaiting := false;
            continue;
          end;
          MpWaitD0 := MpFarD;          // it comes: measure the next 4 s
          MpWaitAt := GetTickCount;
        end;
      end;
      if MpWaiting and ((Cnt >= MpPack) or (MpFindFree(Limit) = 0)) then begin
        // nothing more to pull (or the pack is full): no use waiting here - to the fight, the
        // lagging ones come to the corner
        MpWaiting := false;
        Engine.Msg('[Pull]', 'Pull end: ' + IntToStr(Cnt) + ', nothing more to pull, no zigzag', 0);
        exit;
      end;
      if MpWaiting then begin
        LastGain := GetTickCount;      // waiting for the pack is not "no new aggro"
        MpZigzag();
        Delay(MpTickMs);
        continue;
      end;
    end;                               // (an aggro flicker does not end the wait)

    // the pull mob aggroed / died / vanished / too far for an extra -> the next one
    if OID <> 0 then begin
      Idx := MpIdx(OID);
      if (Idx < 0) or NpcList(Idx).Dead or PullIsAggro(Idx) or PullIsShooter(OID) then OID := 0
      else begin
        MX := NpcList(Idx).X;
        MY := NpcList(Idx).Y;
        if MpDist(MX, MY) > Limit then OID := 0;
      end;
    end;
    if OID = 0 then begin
      OID := MpFindFree(Limit);
      Tapped := false;
      Tapping := false;
      NearSince := 0;
      LastSend := 0;
      ApproachSince := GetTickCount;
      if OID = 0 then begin
        if Cnt > 0 then begin
          if Cnt >= MpPack then
            Engine.Msg('[Pull]', 'Pull end: ' + IntToStr(Cnt) + ' (pack full, nothing close)', 0)
          else
            Engine.Msg('[Pull]', 'Pull end: ' + IntToStr(Cnt) + ', no free mobs: ' + IntToStr(MpCntAll) +
              ' of the list in sight, ' + IntToStr(MpCntArea) + ' out of the area, ' + IntToStr(MpCntRange) +
              ' farther than pull_range, ' + IntToStr(MpCntZ) + ' on another floor, ' + IntToStr(MpCntSkip) +
              ' skipped / ignored', 0);
        end;
        if (Cnt = 0) and ((MpWhyAt = 0) or (GetTickCount - MpWhyAt > 10000)) then begin
          MpWhyAt := GetTickCount;
          Engine.Msg('[Pull]', 'Nothing to pull: ' + IntToStr(MpCntAll) + ' mobs of the list in sight, ' +
            IntToStr(MpCntArea) + ' out of the area' + ', ' + IntToStr(MpCntZ) + ' on another floor, ' +
            IntToStr(MpCntSkip) + ' skipped for a while', 0);
        end;
        exit;                          // nothing on us and nothing to pull: the caller idles
      end;
    end;

    Idx := MpIdx(OID);
    if Idx < 0 then begin
      OID := 0;
      continue;
    end;
    MX := NpcList(Idx).X;
    MY := NpcList(Idx).Y;
    MZ := NpcList(Idx).Z;

    // tap weapon: it does not aggro from the run past it -> one hit from tap range, at once run on
    if Tapping or MpNeedTap(OID, Cnt, NearSince) then begin
      if not Tapping then begin
        if MpDist(MX, MY) > MpTapRange then begin
          if LastSend = 0 then MpMoveReset();
          if MpStillMs() > MpStuckMs then begin
            PullIgnore(OID, MpSkipMs);
            OID := 0;
            continue;
          end;
          TapOk := MpTapReady();       // the tap weapon goes on while we run, not at the mob
          MpChase(MX, MY, MZ, LastSend = 0);
          LastSend := GetTickCount;
          Delay(MpTickMs);
          continue;
        end;
        Tapping := true;
        TapStart := GetTickCount;
        TapHP0 := NpcList(Idx).CurHP;
        Engine.SetTarget(OID);
      end;
      HP := NpcList(Idx).CurHP;
      if HP < TapHP0 then begin
        PullIgnore(OID, MpTapSkipMs);  // hit: it comes after us now
        Tapping := false;
        OID := 0;
        continue;
      end;
      if GetTickCount - TapStart > MpTapMs then begin
        Engine.Msg('[Pull]', 'Tap on ' + NpcList(Idx).Name + ' did not land, skipping it', 0);
        PullIgnore(OID, MpIgnoreMs);
        Tapping := false;
        OID := 0;
        continue;
      end;
      if MpTapReady() then Engine.Attack(MpTickMs) else Delay(MpTickMs);
      continue;
    end;

    if MpDist(MX, MY) > MpTouchDist then begin
      NearSince := 0;
      if LastSend = 0 then MpMoveReset();
      if (GetTickCount - ApproachSince > MpApproachMs) or (MpStillMs() > MpStuckMs) then begin
        Engine.Msg('[Pull]', 'Cannot get to ' + NpcList(Idx).Name + ' (wall?), skipping it', 0);
        PullIgnore(OID, MpSkipMs);
        OID := 0;
        continue;
      end;
      MpChase(MX, MY, MZ, LastSend = 0);   // by the nav map if it is behind a wall
      LastSend := GetTickCount;
    end else if Cnt > 0 then begin
      MpTouch(OID);                    // mobs are on us: no stop - this one should follow, on to the next
      OID := 0;
      continue;
    end else begin
      if NearSince = 0 then NearSince := GetTickCount;
      if GetTickCount - NearSince >= MpTouchWaitMs then begin
        if not Tapped then begin
          if MpDist(MX, MY) > MpHitRange then begin
            MpChase(MX, MY, MZ, LastSend = 0);
            LastSend := GetTickCount;
          end else begin
            Engine.SetTarget(OID);
            Engine.Attack(300);
            Engine.CancelTarget;
            Tapped := true;
            NearSince := GetTickCount;
          end;
        end else begin
          PullIgnore(OID, MpIgnoreMs);   // does not aggro at all
          OID := 0;
        end;
      end;
    end;
    Delay(MpTickMs);
  end;
end;

end.
