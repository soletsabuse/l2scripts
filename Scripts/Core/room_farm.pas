unit RoomFarm;

// Rooms: polygons inside the farm map (drawn in Library\Nav\nav_view.html, stored in the .navgrid as
// "Q name minMobs mode prio x y x y ..." lines). The bot farms one room at a time: picks the room
// where the most mobs are expected, farms it empty, goes on to the next; mobs nowhere enough ->
// waits in the best room. Far rooms are not seen, so each room remembers what it saw and learns its
// respawn speed (mobs per minute after it was cleared) - saved to a file, kept between runs.
// Another player in a room: the room is left after RoomSetPlayers seconds and avoided for a while.
//
// Shared library: scripts only call it, nobody edits it.

interface

uses SysUtils, Classes, NavMove in 'Core\nav_move.pas', MobPull in 'Core\mob_pull.pas';

procedure RoomClear();
procedure RoomAdd(Name: string; MinMobs, Mode, Prio: integer);   // a new room (points follow)
procedure RoomAddPoint(X, Y: integer);                           // a polygon point of the last room
procedure RoomSetPlayers(Seconds: integer);  // another player in the room this long -> leave it
procedure RoomSetAvoid(Seconds: integer);    // ... and do not go there this long (default 30)
                                             // (0 = at once, -1 = never mind players)
function RoomCount(): integer;
function RoomName(i: integer): string;
function RoomMin(i: integer): integer;
function RoomMode(i: integer): integer;
function RoomInside(i, X, Y: integer): boolean;
function RoomDist(i, X, Y: integer): double;     // 0 inside, else to the nearest edge of the polygon
function RoomOfSpot(X, Y: integer): integer;     // the room a farm spot belongs to (inside / near it), -1 none
function RoomPointCount(i: integer): integer;
function RoomPX(i, k: integer): integer;
function RoomPY(i, k: integer): integer;
function RoomAnchorX(i: integer): integer;    // a walkable point inside the room (to run to / wait at)
function RoomAnchorY(i: integer): integer;
procedure RoomUpdate();                       // every tick: what we see in the rooms, respawn, players
function RoomSeen(i: integer): boolean;       // we see the room now (near enough)
function RoomFree(i: integer): integer;       // free mobs in it now (when seen)
function RoomMobs(i: integer): integer;       // RoomFree + skipped champions: for its minimum
function RoomStalest(MinAgeMs: integer): integer;   // not seen for the longest (MinAgeMs+), -1 none
function RoomExpected(i: integer): double;    // free mobs expected in it now
function RoomBusy(i: integer): boolean;       // another player farms it
procedure RoomMarkCleared(i: integer);        // we farmed it empty: the respawn clock starts
function RoomPick(): integer;                 // the best room with at least its minimum expected; -1 none
function RoomPickExcept(Skip: integer): integer;   // the same, not this room
function RoomWaitPick(): integer;             // the best room to wait in (most expected), -1 none
function RoomInfo(i: integer): string;        // one line for the debug: seen / expected / min / respawn / busy
procedure RoomLoadStats(F: string);           // learned respawn speeds
procedure RoomSaveStats(F: string);

implementation

const
  RM_SPOT_NEAR = 500;     // a farm spot this close outside a room belongs to it
  RM_SEE      = 1800;     // a room is seen when its anchor is this close to us
  RM_FRESH_MS = 3000;     // a count seen this recently is taken as it is
  RM_BUSY_MS  = 30000;    // a room with another player is avoided this long (RoomSetAvoid changes it)
  RM_MAX      = 64;

var
  RName: array[0..63] of string;
  RMin, RMode, RPrio, RStart, RCnt: array[0..63] of integer;
  RPX, RPY: array of integer;       // all polygon points in a row
  RPN, RN: integer;
  RAX, RAY: array[0..63] of integer;
  RAnchorOK: array[0..63] of boolean;
  RLast, RMaxSeen: array[0..63] of integer;
  RLastAt, RClearAt, RPlayerSince, RBusyUntil: array[0..63] of cardinal;
  RRate: array[0..63] of double;     // learned respawn: mobs per second
  RBase: array[0..63] of integer;    // mobs left at the clear (skipped champions): not respawn
  RPlayers: integer;                 // RoomSetPlayers (not called: 60 s)
  RPlayersSet: boolean;
  RAvoidMs: integer;                 // RoomSetAvoid; 0 = not set: RM_BUSY_MS

procedure RoomClear();
begin
  RN := 0;
  RPN := 0;
  SetLength(RPX, 0);
  SetLength(RPY, 0);
end;

procedure RoomAdd(Name: string; MinMobs, Mode, Prio: integer);
begin
  if RN >= RM_MAX then exit;
  RName[RN] := Name;
  RMin[RN] := MinMobs;
  if RMin[RN] < 1 then RMin[RN] := 1;
  RMode[RN] := Mode;
  RPrio[RN] := Prio;
  if RPrio[RN] < 1 then RPrio[RN] := 1;
  RStart[RN] := RPN;
  RCnt[RN] := 0;
  RAnchorOK[RN] := false;
  RLast[RN] := 0;
  RMaxSeen[RN] := 0;
  RLastAt[RN] := 0;
  RClearAt[RN] := 0;
  RPlayerSince[RN] := 0;
  RBusyUntil[RN] := 0;
  RRate[RN] := 0;
  Inc(RN);
end;

procedure RoomAddPoint(X, Y: integer);
begin
  if RN = 0 then exit;
  SetLength(RPX, RPN + 1);
  SetLength(RPY, RPN + 1);
  RPX[RPN] := X;
  RPY[RPN] := Y;
  Inc(RPN);
  Inc(RCnt[RN - 1]);
end;

procedure RoomSetPlayers(Seconds: integer);
begin
  RPlayers := Seconds;
  RPlayersSet := true;
end;

procedure RoomSetAvoid(Seconds: integer);
begin
  RAvoidMs := Seconds * 1000;
  if RAvoidMs <= 0 then RAvoidMs := 1000;   // 0: leave it, but come back at once
end;

function RoomCount(): integer;
begin
  result := RN;
end;

function RoomName(i: integer): string;
begin
  result := RName[i];
end;

function RoomMin(i: integer): integer;
begin
  result := RMin[i];
end;

function RoomMode(i: integer): integer;
begin
  result := RMode[i];
end;

function RoomPointCount(i: integer): integer;
begin
  result := RCnt[i];
end;

function RoomPX(i, k: integer): integer;
begin
  result := RPX[RStart[i] + k];
end;

function RoomPY(i, k: integer): integer;
begin
  result := RPY[RStart[i] + k];
end;

function RoomInside(i, X, Y: integer): boolean;
var k, j, A, B, AX, AY, BX, BY: integer;
begin
  result := false;
  if (i < 0) or (i >= RN) or (RCnt[i] < 3) then exit;
  A := RStart[i];
  B := A + RCnt[i] - 1;
  j := B;
  for k := A to B do begin
    AX := RPX[k];
    AY := RPY[k];
    BX := RPX[j];
    BY := RPY[j];
    if ((AY > Y) <> (BY > Y)) and (X < (BX - AX) * (Y - AY) / (BY - AY) + AX) then result := not result;
    j := k;
  end;
end;

function RoomDist(i, X, Y: integer): double;
var k, j, A, B: integer;
  AX, AY, BX, BY, T, L2, PX, PY, D: double;
begin
  result := 1E18;
  if (i < 0) or (i >= RN) or (RCnt[i] < 3) then exit;
  if RoomInside(i, X, Y) then begin
    result := 0;
    exit;
  end;
  A := RStart[i];
  B := A + RCnt[i] - 1;
  j := B;
  for k := A to B do begin
    AX := RPX[j];
    AY := RPY[j];
    BX := RPX[k];
    BY := RPY[k];
    L2 := Sqr(BX - AX) + Sqr(BY - AY);
    if L2 < 1 then T := 0
    else T := ((X - AX) * (BX - AX) + (Y - AY) * (BY - AY)) / L2;
    if T < 0 then T := 0;
    if T > 1 then T := 1;
    PX := AX + (BX - AX) * T;
    PY := AY + (BY - AY) * T;
    D := Sqrt(Sqr(X - PX) + Sqr(Y - PY));
    if D < result then result := D;
    j := k;
  end;
end;

// a farm spot of a room: inside it, or outside but within RM_SPOT_NEAR of it (a spot in the passage
// round the corner) and nearer to it than to any other room
function RoomOfSpot(X, Y: integer): integer;
var i: integer;
  D, Best: double;
begin
  result := -1;
  Best := RM_SPOT_NEAR;
  for i := 0 to RN - 1 do begin
    D := RoomDist(i, X, Y);
    if D <= Best then begin
      Best := D;
      result := i;
    end;
  end;
end;

// a walkable point inside the room near its middle: the middle itself, else rings round it
procedure RmAnchor(i: integer);
var k, CX, CY, R, a, X, Y, UZ: integer;
  Ang: double;
begin
  if RAnchorOK[i] then exit;
  CX := 0;
  CY := 0;
  for k := 0 to RCnt[i] - 1 do begin
    CX := CX + RPX[RStart[i] + k];
    CY := CY + RPY[RStart[i] + k];
  end;
  if RCnt[i] > 0 then begin
    CX := CX div RCnt[i];
    CY := CY div RCnt[i];
  end;
  RAX[i] := CX;
  RAY[i] := CY;
  RAnchorOK[i] := true;
  UZ := User.Z;
  if RoomInside(i, CX, CY) and PullInArea(CX, CY, UZ) then exit;
  R := 40;
  while R <= 1500 do begin
    for a := 0 to 15 do begin
      Ang := a * 3.14159265 / 8;
      X := CX + Round(Cos(Ang) * R);
      Y := CY + Round(Sin(Ang) * R);
      if RoomInside(i, X, Y) and PullInArea(X, Y, UZ) then begin
        RAX[i] := X;
        RAY[i] := Y;
        exit;
      end;
    end;
    R := R + 40;
  end;
end;

function RoomAnchorX(i: integer): integer;
begin
  RmAnchor(i);
  result := RAX[i];
end;

function RoomAnchorY(i: integer): integer;
begin
  RmAnchor(i);
  result := RAY[i];
end;

function RoomSeen(i: integer): boolean;
var UX, UY, AX, AY: integer;
  DX, DY: double;
begin
  UX := User.X;
  UY := User.Y;
  AX := RoomAnchorX(i);
  AY := RoomAnchorY(i);
  DX := AX - UX;
  DY := AY - UY;
  result := RoomInside(i, UX, UY) or (Sqrt(DX * DX + DY * DY) <= RM_SEE);
end;

function RoomFree(i: integer): integer;
var k, NX, NY: integer;
begin
  result := 0;
  for k := 0 to NpcList.Count - 1 do begin
    if not PullIsFree(k) then continue;
    NX := NpcList(k).X;
    NY := NpcList(k).Y;
    if RoomInside(i, NX, NY) then Inc(result);
  end;
end;

// the minimum of a room counts every mob of it: a champion we do not fight is a mob there too
function RoomMobs(i: integer): integer;
var k, NX, NY: integer;
begin
  result := 0;
  for k := 0 to NpcList.Count - 1 do begin
    if not (PullIsFree(k) or PullIsChampion(k)) then continue;
    NX := NpcList(k).X;
    NY := NpcList(k).Y;
    if RoomInside(i, NX, NY) then Inc(result);
  end;
end;

function RmPlayersIn(i: integer): integer;
var k, X, Y: integer;
begin
  result := 0;
  for k := 0 to CharList.Count - 1 do begin
    X := CharList(k).X;
    Y := CharList(k).Y;
    if RoomInside(i, X, Y) then Inc(result);
  end;
end;

// what we see now: the count, the respawn speed (from the clear to now), other players
procedure RoomUpdate();
var i, c: integer;
  T: cardinal;
  Sample: double;
begin
  T := GetTickCount;
  if not RPlayersSet then begin
    RPlayers := 60;
    RPlayersSet := true;
  end;
  for i := 0 to RN - 1 do begin
    if not RoomSeen(i) then continue;
    c := RoomMobs(i);
    if c > RMaxSeen[i] then RMaxSeen[i] := c;
    // respawn: mobs back since the clear (one sample per new mob, not before 10 s)
    if (RClearAt[i] > 0) and (c > RLast[i]) and (c > RBase[i]) and (T - RClearAt[i] > 10000) then begin
      Sample := (c - RBase[i]) / ((T - RClearAt[i]) / 1000);
      if RRate[i] <= 0 then RRate[i] := Sample else RRate[i] := RRate[i] * 0.7 + Sample * 0.3;
      if c >= RMin[i] then RClearAt[i] := 0;     // back to its minimum: enough measured
    end;
    RLast[i] := c;
    RLastAt[i] := T;
    if RPlayers >= 0 then begin
      if RmPlayersIn(i) > 0 then begin
        if RPlayerSince[i] = 0 then RPlayerSince[i] := T;
        if (T - RPlayerSince[i] >= RPlayers * 1000) and (T >= RBusyUntil[i]) then begin
          if RAvoidMs > 0 then RBusyUntil[i] := T + RAvoidMs else RBusyUntil[i] := T + RM_BUSY_MS;
          Engine.Msg('[Room]', 'Room ' + RName[i] + ': another player there, avoiding it ' +
            IntToStr((RBusyUntil[i] - T) div 1000) + ' s', 0);
        end;
      end else RPlayerSince[i] := 0;
    end;
  end;
end;

function RoomBusy(i: integer): boolean;
begin
  result := GetTickCount < RBusyUntil[i];
end;

procedure RoomMarkCleared(i: integer);
begin
  RClearAt[i] := GetTickCount;
  RBase[i] := RoomMobs(i);             // champions left there are not the respawn
  RLast[i] := RBase[i];
  RLastAt[i] := GetTickCount;
end;

// seen just now -> that count; else the last count + the learned respawn since; a room never seen
// is worth a look (its minimum); never more than the most ever seen there
function RoomExpected(i: integer): double;
var T: cardinal;
  Cap: double;
begin
  T := GetTickCount;
  if RLastAt[i] = 0 then begin
    result := RMin[i];
    exit;
  end;
  result := RLast[i];
  if T - RLastAt[i] < RM_FRESH_MS then exit;
  result := RLast[i] + RRate[i] * ((T - RLastAt[i]) / 1000);
  Cap := RMaxSeen[i];
  if Cap < RMin[i] then Cap := RMin[i];
  if result > Cap then result := Cap;
end;

// expected x priority, a far room counts less
function RmScore(i: integer): double;
var AX, AY: integer;
  L: double;
begin
  AX := RoomAnchorX(i);
  AY := RoomAnchorY(i);
  L := NavPathLen(AX, AY);
  if L < 0 then L := 5000;
  result := RoomExpected(i) * RPrio[i] / (1 + L / 2000);
end;

// another player seen in the room right now (from afar too): we do not go there
function RmTaken(i: integer): boolean;
begin
  result := (RPlayers >= 0) and (RmPlayersIn(i) > 0);
end;

function RoomPickExcept(Skip: integer): integer;
var i: integer;
  S, Best: double;
begin
  result := -1;
  Best := -1;
  for i := 0 to RN - 1 do begin
    if (i = Skip) or RoomBusy(i) or (RCnt[i] < 3) or RmTaken(i) then continue;
    if RoomExpected(i) < RMin[i] then continue;
    S := RmScore(i);
    if S > Best then begin
      Best := S;
      result := i;
    end;
  end;
end;

function RoomPick(): integer;
begin
  result := RoomPickExcept(-1);
end;

function RoomWaitPick(): integer;
var i: integer;
  S, Best: double;
begin
  result := -1;
  Best := -1;
  for i := 0 to RN - 1 do begin
    if RoomBusy(i) or (RCnt[i] < 3) or RmTaken(i) then continue;
    S := RmScore(i) + RRate[i] * 60;  // waiting: the room that respawns fastest helps most
    if S > Best then begin
      Best := S;
      result := i;
    end;
  end;
end;

// the room not seen for the longest (at least MinAgeMs, never seen first), not busy, not seen now:
// nothing to farm -> go and look at it (far rooms: the mobs show only near)
function RoomStalest(MinAgeMs: integer): integer;
var i: integer;
  T, Age, Best: cardinal;
begin
  result := -1;
  T := GetTickCount;
  Best := 0;
  for i := 0 to RN - 1 do begin
    if RoomBusy(i) or (RCnt[i] < 3) or RoomSeen(i) or RmTaken(i) then continue;
    if RLastAt[i] = 0 then Age := T else Age := T - RLastAt[i];
    if Age < MinAgeMs then continue;
    if (result < 0) or (Age > Best) then begin
      Best := Age;
      result := i;
    end;
  end;
end;

function RoomInfo(i: integer): string;
var S: string;
begin
  if RoomSeen(i) then S := 'seen ' + IntToStr(RoomMobs(i))
  else if RLastAt[i] = 0 then S := 'never seen'
  else S := 'seen ' + IntToStr((GetTickCount - RLastAt[i]) div 1000) + ' s ago: ' + IntToStr(RLast[i]);
  result := RName[i] + ': ' + S + ', expected ' + IntToStr(Round(RoomExpected(i))) + ' of min ' + IntToStr(RMin[i]) +
    ', respawn ' + IntToStr(Round(RRate[i] * 3600)) + '/h';
  if RoomBusy(i) then result := result + ', BUSY (player)';
end;

function RmField(S: string; k: integer): string;
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

// "name rate_per_hour maxseen" per line
procedure RoomLoadStats(F: string);
var L: TStringList;
  i, k: integer;
  S, N: string;
begin
  if not FileExists(F) then exit;
  L := TStringList.Create;
  L.LoadFromFile(F);
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    N := RmField(S, 0);
    for k := 0 to RN - 1 do
      if RName[k] = N then begin
        RRate[k] := StrToIntDef(RmField(S, 1), 0) / 3600;
        RMaxSeen[k] := StrToIntDef(RmField(S, 2), 0);
      end;
  end;
  L.Free;
end;

procedure RoomSaveStats(F: string);
var L: TStringList;
  k: integer;
begin
  L := TStringList.Create;
  L.Add('# room respawn learned by the bot: name mobs_per_hour most_seen');
  for k := 0 to RN - 1 do
    L.Add(RName[k] + ' ' + IntToStr(Round(RRate[k] * 3600)) + ' ' + IntToStr(RMaxSeen[k]));
  try
    L.SaveToFile(F);
  except
  end;
  L.Free;
end;

end.
