unit NavMove;

// Runs by the map. A zone (.zmap drawn in the bot, Library\Zones) or a lidar grid (.navgrid from
// Core\nav_explore.pas, Library\Nav) is cut into cells. A wall trace (.navtrace from
// Core\nav_trace.pas: runs along the walls) cuts the zone like walls: of the pieces only those with a
// seed point (NavAddSeed: farm points, where we stand) stay - behind the walls / inside pillars goes; a graph is built from them: points at the
// corners of the walls (moved up to NAV_CLEAR off the wall where there is room; narrow passages stay), links = straight lines of sight.
// NavMoveTo: target in sight -> the plain server path (a mouse click); behind a wall -> along the
// graph (server path between the points, a point is skipped as soon as the next one is in sight),
// then to the target; the plain run gets stuck -> the graph too. No map -> plain server path only.
//
//   uses NavMove in 'Core\nav_move.pas';
//   begin
//     NavSetZone('CRUMA_MORDEO_1.zmap');    // or NavSetGrid('CRUMA_MORDEO_1.navgrid');
//     NavBuild();                           // once, standing in the zone
//     NavMoveTo(23962, 118963, -12112, 50);
//   end.
//
// Shared library: scripts only call it, nobody edits it.

interface

uses SysUtils, Classes;

procedure NavSetZone(ZoneFile: string);       // map = this .zmap ('' = the zone active in the bot)
procedure NavSetGrid(GridFile: string);       // map = this .navgrid (wins over the zone)
procedure NavSetCell(Cell: integer);          // cell of the zone grid (default 40)
procedure NavSetTrace(TraceFile: string);     // + wall trace .navtrace (Library\Nav) over the zone
procedure NavAddSeed(X, Y: integer);          // a point surely walkable (farm point): its piece stays
function NavBuild(): boolean;                 // build the graph now (once; later calls do nothing)
function NavIsReady(): boolean;               // there is a map
function NavIsBusy(): boolean;                // a graph run is going on right now
procedure NavClick(X, Y, Z: integer);         // one server path run order (non-blocking)
function NavSee(X1, Y1, X2, Y2: integer): boolean;   // no wall of the map on the straight line
function NavSeeFromUs(X, Y: integer): boolean;
function NavIsFree(X, Y: integer): boolean;     // a walkable cell of the map (no map = true)
function NavGraphTo(X, Y, Z: integer): boolean;      // along the graph until the target is in sight
// a moving target (a mob): where to click now - the farthest route node in sight; false = the target
// itself is in sight (click it) or no way. Call again as we run
function NavWaypoint(X, Y: integer): boolean;
function NavWpX(): integer;
function NavWpY(): integer;
function NavMoveTo(X, Y, Z, Radius: integer): boolean;   // the whole run; true = within Radius
// a spot round a corner: walkable, the mobs at MX, MY do not see it, it sees the corner - they run
// round the corner and bunch up there. Nearest to FromX, FromY, corners within MaxDist; false = none
function NavFindCornerSpot(FromX, FromY, MX, MY, MaxDist: integer): boolean;
function NavSpotX(): integer;                 // the spot found by NavFindCornerSpot
function NavSpotY(): integer;
procedure NavSpotClear();                     // the pack for the corner choice: forget the mobs
procedure NavSpotAddMob(X, Y: integer);       // ... and add every mob of the pack (up to 64)
// how good a given spot (a farm spot #f) is against the pack at MX, MY: -1 = no good (the pack
// sees it / no sharp turn round a corner / through the pack), else the higher the better
function NavSpotScore(PX, PY, FromX, FromY, MX, MY: integer): double;
function NavPathLen(X, Y: integer): double;   // run length to X, Y along the map; -1 = no way
function NavFarPoint(MinDist: integer): boolean;   // a walkable map point at least MinDist away (patrol)
function NavFarX(): integer;
function NavFarY(): integer;

implementation

const
  NAV_CELL          = 40;       // cell of the zone grid
  NAV_NONE          = -999999999;
  NAV_CLEAR         = 40;       // graph lines keep this far off the walls (units, any cell size)
  NAV_NODE_GAP      = 64;
  NAV_BAN_R         = 40;       // "X x y" of the grid file: no corner node this close       // graph nodes closer than this to each other: one is enough
  NAV_LINK_MAX      = 2500;     // longest graph link
  NAV_SEE_MAX       = 3000;     // first / last graph node only this close to us / the target
  NAV_END_SKIP      = 60;       // a wall cell this close to us / the target does not block the sight
  NAV_RING          = 200;      // no zone file: the active zone's box is felt with InZone this often
  NAV_RING_MAX      = 20000;    // ... at most this far from us
  NAV_MAX_NODES     = 600;
  NAV_POINT_REACH   = 150;      // this close to a graph node -> run to the next one (no stop)
  NAV_POINT_MS      = 20000;    // one node not reached in this -> the graph run is given up
  NAV_STILL_MS      = 2000;     // not moved this long -> click again
  NAV_STUCK_MAX     = 3;        // so many re-clicks without moving -> given up
  NAV_RESEND_MS     = 1500;     // plain run: the click is repeated this often
  NAV_STALL_MS      = 2500;     // plain run: not moved this long = stuck
  NAV_BAD_MS        = 60000;    // a node we could not get to is left out of routes this long
  NAV_SPOT_R        = 110;      // corner spot: this far from the corner node, round the corner
  NAV_STITCH        = 64;       // trace: a stroke end this close to another trace point is joined to it

var
  NmUserX, NmUserY: array of integer;   // "N x y" lines of the grid file: own graph nodes
  NmUserN: integer;
  NmBanX, NmBanY: array of integer;     // "X x y": a corner node is never put this close (removed in the viewer)
  NmBanN: integer;
  NmZoneFile, NmGridFile, NmTraceFile: string;
  NmSpotX, NmSpotY: integer;               // NavFindCornerSpot result
  NmWpX, NmWpY: integer;                   // NavWaypoint result
  NmBadUntil: array of cardinal;           // a node we could not get to: left out of routes till then
  NmMobX, NmMobY: array[0..63] of integer;  // NavSpotAddMob: the pack for the corner choice
  NmMobN: integer;
  NmFarXv, NmFarYv, NmFarNext: integer;     // NavFarPoint
  NmSeedX, NmSeedY: array of integer;
  NmSeedN: integer;
  TrcX, TrcY, TrStart: array of integer;   // trace: all points in a row; stroke k = TrStart[k]..TrStart[k+1]-1
  TrPN, TrSN: integer;
  NmWall: array of boolean;              // trace: cells under the strokes
  NmCellSet: integer;
  NgX0, NgY0, NgCell, NgW, NgH, NgZ: integer;
  NgFree, NgSafe: array of boolean;
  NgBX0, NgBY0, NgBX1, NgBY1: integer;
  ZOX, ZOY: array of integer;             // zone outer contour
  ZOn: integer;
  ZIX, ZIY, ZIStart: array of integer;    // zone holes, all points in a row; ZIStart[k] = first point of hole k
  ZIn, ZIPts: integer;
  NavX, NavY: array of integer;
  NavN: integer;
  NavHead, NavTo, NavNext: array of integer;
  NavLinkN: integer;
  NavD: array of double;
  NavPrev: array of integer;
  NavDone: array of boolean;
  NavRoute: array of integer;
  NavRouteN: integer;
  NavBuilt, NavOn, NavBusyFlag: boolean;

procedure NavSetZone(ZoneFile: string);
begin
  NmZoneFile := ZoneFile;
end;

procedure NavSetGrid(GridFile: string);
begin
  NmGridFile := GridFile;
end;

procedure NavSetTrace(TraceFile: string);
begin
  NmTraceFile := TraceFile;
end;

procedure NavAddSeed(X, Y: integer);
begin
  SetLength(NmSeedX, NmSeedN + 1);
  SetLength(NmSeedY, NmSeedN + 1);
  NmSeedX[NmSeedN] := X;
  NmSeedY[NmSeedN] := Y;
  Inc(NmSeedN);
end;

procedure NavSetCell(Cell: integer);
begin
  NmCellSet := Cell;
end;

function NavIsReady(): boolean;
begin
  result := NavOn;
end;

function NavIsBusy(): boolean;
begin
  result := NavBusyFlag;
end;

function NmHex(Value: integer): string;
begin
  result := IntToHex(Value and $FF, 2) + IntToHex((Value shr 8) and $FF, 2) +
            IntToHex((Value shr 16) and $FF, 2) + IntToHex((Value shr 24) and $FF, 2);
end;

// the packet of a mouse click (MoveBackwardToLocation: target, our place, 1 = by mouse):
// the server builds the way itself
procedure NavClick(X, Y, Z: integer);
var UX, UY, UZ: integer;
begin
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  Engine.SendToServer('0F' + NmHex(X) + NmHex(Y) + NmHex(Z) + NmHex(UX) + NmHex(UY) + NmHex(UZ) + NmHex(1));
end;

function NmField(S: string; k: integer): string;
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

// number of the attribute Key="123" (Key with a space before: ' x'); none -> NAV_NONE
function NmAttr(S, Key: string): integer;
var p, q: integer;
  T: string;
begin
  result := NAV_NONE;
  p := Pos(Key + '="', S);
  if p = 0 then exit;
  T := Copy(S, p + Length(Key) + 2, 20);
  q := Pos('"', T);
  if q > 0 then T := Copy(T, 1, q - 1);
  result := StrToIntDef(T, NAV_NONE);
end;

// the .zmap: outer contour + holes; false = no file / no contour
function NmLoadZone(F: string): boolean;
var L: TStringList;
  i, X, Y, Mode: integer;
  S: string;
begin
  result := false;
  ZOn := 0;
  ZIn := 0;
  ZIPts := 0;
  if not FileExists(F) then exit;
  L := TStringList.Create;
  L.LoadFromFile(F);
  SetLength(ZOX, L.Count);
  SetLength(ZOY, L.Count);
  SetLength(ZIX, L.Count);
  SetLength(ZIY, L.Count);
  SetLength(ZIStart, L.Count + 1);
  Mode := 0;                           // 1 = outer contour, 2 = a hole
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    if Pos('<ExternalPoly', S) > 0 then Mode := 1
    else if Pos('<InternalPolies', S) > 0 then Mode := 0
    else if Pos('<poly>', S) > 0 then begin
      Mode := 2;
      ZIStart[ZIn] := ZIPts;
      Inc(ZIn);
    end else if Pos('<point', S) > 0 then begin
      X := NmAttr(S, ' x');
      Y := NmAttr(S, ' y');
      if (X = NAV_NONE) or (Y = NAV_NONE) then continue;
      if Mode = 1 then begin
        ZOX[ZOn] := X;
        ZOY[ZOn] := Y;
        Inc(ZOn);
      end else if Mode = 2 then begin
        ZIX[ZIPts] := X;
        ZIY[ZIPts] := Y;
        Inc(ZIPts);
      end;
    end;
  end;
  ZIStart[ZIn] := ZIPts;
  L.Free;
  result := ZOn >= 3;
end;

// point in the polygon made of points From..To-1 of the arrays (outer: Hole = false)
function NmInPoly(X, Y, From, Upto: integer; Hole: boolean): boolean;
var i, j, AX, AY, BX, BY: integer;
begin
  result := false;
  j := Upto - 1;
  for i := From to Upto - 1 do begin
    if Hole then begin
      AX := ZIX[i]; AY := ZIY[i]; BX := ZIX[j]; BY := ZIY[j];
    end else begin
      AX := ZOX[i]; AY := ZOY[i]; BX := ZOX[j]; BY := ZOY[j];
    end;
    if ((AY > Y) <> (BY > Y)) and (X < (BX - AX) * (Y - AY) / (BY - AY) + AX) then result := not result;
    j := i;
  end;
end;

procedure NmAlloc(X0, Y0, X1, Y1, Cell: integer);
var i: integer;
begin
  NgCell := Cell;
  NgX0 := X0 - Cell * 2;
  NgY0 := Y0 - Cell * 2;
  NgW := (X1 - X0) div Cell + 5;
  NgH := (Y1 - Y0) div Cell + 5;
  SetLength(NgFree, NgW * NgH);
  SetLength(NgSafe, NgW * NgH);
  for i := 0 to NgW * NgH - 1 do begin
    NgFree[i] := false;
    NgSafe[i] := false;
  end;
end;

// no zone file: the box of the zone active in the bot, found by asking InZone on rings every
// NAV_RING round us until two rings in a row have no zone point; false = we do not stand in a zone
function NmActiveBox(UX, UY, UZ: integer): boolean;
var R, Far, k, n, X, Y, Side: integer;
  Any: boolean;
begin
  result := Engine.InZone(UX, UY, UZ);
  if not result then exit;
  NgBX0 := UX; NgBX1 := UX; NgBY0 := UY; NgBY1 := UY;
  Far := 0;
  R := NAV_RING;
  while R <= NAV_RING_MAX do begin
    Any := false;
    n := (2 * R) div NAV_RING;
    for Side := 0 to 3 do
      for k := 0 to n - 1 do begin
        if Side = 0 then begin X := UX - R + k * NAV_RING; Y := UY - R; end
        else if Side = 1 then begin X := UX + R; Y := UY - R + k * NAV_RING; end
        else if Side = 2 then begin X := UX + R - k * NAV_RING; Y := UY + R; end
        else begin X := UX - R; Y := UY + R - k * NAV_RING; end;
        if Engine.InZone(X, Y, UZ) then begin
          Any := true;
          if X < NgBX0 then NgBX0 := X;
          if X > NgBX1 then NgBX1 := X;
          if Y < NgBY0 then NgBY0 := Y;
          if Y > NgBY1 then NgBY1 := Y;
        end;
      end;
    if Any then Far := R
    else if R > Far + NAV_RING * 2 then break;
    R := R + NAV_RING;
  end;
  NgBX0 := NgBX0 - NAV_RING;
  NgBY0 := NgBY0 - NAV_RING;
  NgBX1 := NgBX1 + NAV_RING;
  NgBY1 := NgBY1 + NAV_RING;
end;

// grid from the zone: a cell is free when its centre is inside the contour and not in a hole.
// No zone file -> the zone active in the bot (Engine.InZone, its box found by NmActiveBox)
function NmFromZone(): boolean;
var cx, cy, X, Y, UX, UY, UZ, Cell, k, i: integer;
  Free: boolean;
begin
  result := false;
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  NgZ := UZ;
  Cell := NmCellSet;
  if Cell <= 0 then Cell := NAV_CELL;
  if (NmZoneFile <> '') and NmLoadZone(Script.Path + '..\Zones\' + NmZoneFile) then begin
    NgBX0 := ZOX[0]; NgBX1 := ZOX[0]; NgBY0 := ZOY[0]; NgBY1 := ZOY[0];
    for i := 1 to ZOn - 1 do begin
      if ZOX[i] < NgBX0 then NgBX0 := ZOX[i];
      if ZOX[i] > NgBX1 then NgBX1 := ZOX[i];
      if ZOY[i] < NgBY0 then NgBY0 := ZOY[i];
      if ZOY[i] > NgBY1 then NgBY1 := ZOY[i];
    end;
    NmAlloc(NgBX0, NgBY0, NgBX1, NgBY1, Cell);
    for cy := 0 to NgH - 1 do
      for cx := 0 to NgW - 1 do begin
        X := NgX0 + cx * NgCell + NgCell div 2;
        Y := NgY0 + cy * NgCell + NgCell div 2;
        Free := NmInPoly(X, Y, 0, ZOn, false);
        if Free then
          for k := 0 to ZIn - 1 do
            if NmInPoly(X, Y, ZIStart[k], ZIStart[k + 1], true) then begin
              Free := false;
              break;
            end;
        NgFree[cy * NgW + cx] := Free;
      end;
    result := true;
    exit;
  end;
  if NmZoneFile <> '' then Engine.Msg('[Nav]', 'No zone file ' + NmZoneFile + ', trying the zone active in the bot', 128);
  if not NmActiveBox(UX, UY, UZ) then exit;
  NmAlloc(NgBX0, NgBY0, NgBX1, NgBY1, Cell);
  for cy := 0 to NgH - 1 do
    for cx := 0 to NgW - 1 do begin
      X := NgX0 + cx * NgCell + NgCell div 2;
      Y := NgY0 + cy * NgCell + NgCell div 2;
      NgFree[cy * NgW + cx] := Engine.InZone(X, Y, UZ);
    end;
  result := true;
end;

// lidar grid: "G x0 y0 cell cols rows z", then one "R ...." line per row ('.' = free)
function NmFromFile(F: string): boolean;
var L: TStringList;
  i, cx, cy: integer;
  S, K, Row: string;
begin
  result := false;
  NmUserN := 0;
  NmBanN := 0;
  if not FileExists(F) then begin
    Engine.Msg('[Nav]', 'No grid file ' + F, 128);
    exit;
  end;
  L := TStringList.Create;
  L.LoadFromFile(F);
  cy := -1;
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    K := NmField(S, 0);
    if K = 'G' then begin
      NgX0 := StrToIntDef(NmField(S, 1), 0);
      NgY0 := StrToIntDef(NmField(S, 2), 0);
      NgCell := StrToIntDef(NmField(S, 3), NAV_CELL);
      NgW := StrToIntDef(NmField(S, 4), 0);
      NgH := StrToIntDef(NmField(S, 5), 0);
      NgZ := StrToIntDef(NmField(S, 6), 0);
      SetLength(NgFree, NgW * NgH);
      SetLength(NgSafe, NgW * NgH);
      for cx := 0 to NgW * NgH - 1 do NgFree[cx] := false;
      cy := 0;
    end else if (K = 'R') and (cy >= 0) and (cy < NgH) then begin
      Row := Copy(S, 3, NgW);
      for cx := 0 to Length(Row) - 1 do
        if (cx < NgW) and (Row[cx + 1] = '.') then NgFree[cy * NgW + cx] := true;
      Inc(cy);
    end else if (K = 'N') and (NmUserN < NAV_MAX_NODES) then begin   // a node drawn in the viewer
      SetLength(NmUserX, NmUserN + 1);
      SetLength(NmUserY, NmUserN + 1);
      NmUserX[NmUserN] := StrToIntDef(NmField(S, 1), 0);
      NmUserY[NmUserN] := StrToIntDef(NmField(S, 2), 0);
      Inc(NmUserN);
    end else if K = 'X' then begin       // a graph node removed in the viewer
      SetLength(NmBanX, NmBanN + 1);
      SetLength(NmBanY, NmBanN + 1);
      NmBanX[NmBanN] := StrToIntDef(NmField(S, 1), 0);
      NmBanY[NmBanN] := StrToIntDef(NmField(S, 2), 0);
      Inc(NmBanN);
    end;
  end;
  L.Free;
  result := (NgW > 0) and (NgH > 0);
end;

// graph cells: free and NAV_CLEAR units off the walls, whatever the cell size
function NmErodeCells(): integer;
begin
  result := (NAV_CLEAR + NgCell div 2) div NgCell;
  if result < 1 then result := 1;
end;

procedure NmErode();
var cx, cy, dx, dy, ax, ay, R: integer;
  Ok: boolean;
begin
  R := NmErodeCells();
  for cy := 0 to NgH - 1 do
    for cx := 0 to NgW - 1 do begin
      Ok := NgFree[cy * NgW + cx];
      if Ok then
        for dy := -R to R do
          for dx := -R to R do begin
            if not Ok then break;
            ax := cx + dx;
            ay := cy + dy;
            if (ax < 0) or (ay < 0) or (ax >= NgW) or (ay >= NgH) then Ok := false
            else if not NgFree[ay * NgW + ax] then Ok := false;
          end;
      NgSafe[cy * NgW + cx] := Ok;
    end;
end;

// outside the grid = free (the server knows better there)
function NmFreeAt(X, Y: integer; Safe: boolean): boolean;
var cx, cy: integer;
begin
  result := true;
  if (X < NgX0) or (Y < NgY0) then exit;
  cx := (X - NgX0) div NgCell;
  cy := (Y - NgY0) div NgCell;
  if (cx >= NgW) or (cy >= NgH) then exit;
  if Safe then result := NgSafe[cy * NgW + cx] else result := NgFree[cy * NgW + cx];
end;

// straight line through free cells (every half cell). Not Safe: an end standing in a wall / a hole
// of the zone (a corner point in a cut-out, the safe point out of the zone) - the cells from it up
// to the first free one do not count, and walls within NAV_END_SKIP of the ends do not count either
// (we / the target may stand at the very wall). Only a wall BETWEEN free cells blocks the sight
function NmLineFree(X1, Y1, X2, Y2: integer; Safe: boolean): boolean;
var k, n, PX, PY, K0, K1: integer;
  L, T, DX, DY: double;
begin
  result := true;
  DX := X2 - X1;
  DY := Y2 - Y1;
  L := Sqrt(DX * DX + DY * DY);
  if NgCell >= 16 then n := Trunc(L / (NgCell * 0.5)) + 1
  else n := Trunc(L / 8) + 1;             // tiny cells: not finer than every 8 units, else the start takes ages
  K0 := 0;
  K1 := n;
  if not Safe then begin
    while (K0 <= n) and (not NmFreeAt(Round(X1 + DX * K0 / n), Round(Y1 + DY * K0 / n), false)) do Inc(K0);
    while (K1 >= K0) and (not NmFreeAt(Round(X1 + DX * K1 / n), Round(Y1 + DY * K1 / n), false)) do Dec(K1);
  end;
  for k := K0 to K1 do begin
    T := k / n;
    if (not Safe) and ((T * L < NAV_END_SKIP) or ((1 - T) * L < NAV_END_SKIP)) then continue;
    PX := Round(X1 + DX * T);
    PY := Round(Y1 + DY * T);
    if not NmFreeAt(PX, PY, Safe) then begin
      result := false;
      exit;
    end;
  end;
end;

function NavSee(X1, Y1, X2, Y2: integer): boolean;
begin
  result := true;
  if NavOn then result := NmLineFree(X1, Y1, X2, Y2, false);
end;

function NavIsFree(X, Y: integer): boolean;
begin
  result := true;
  if NavOn then result := NmFreeAt(X, Y, false);
end;

function NavSeeFromUs(X, Y: integer): boolean;
var UX, UY: integer;
begin
  UX := User.X;
  UY := User.Y;
  result := NavSee(UX, UY, X, Y);
end;

function NmDist(i, j: integer): double;
var DX, DY: double;
begin
  DX := NavX[i] - NavX[j];
  DY := NavY[i] - NavY[j];
  result := Sqrt(DX * DX + DY * DY);
end;

procedure NmLink(A, B: integer);
begin
  if NavLinkN + 2 > Length(NavTo) then begin
    SetLength(NavTo, NavLinkN * 2 + 256);
    SetLength(NavNext, NavLinkN * 2 + 256);
  end;
  NavTo[NavLinkN] := B;
  NavNext[NavLinkN] := NavHead[A];
  NavHead[A] := NavLinkN;
  Inc(NavLinkN);
  NavTo[NavLinkN] := A;
  NavNext[NavLinkN] := NavHead[B];
  NavHead[B] := NavLinkN;
  Inc(NavLinkN);
end;

function NmSafeCell(cx, cy: integer): boolean;
begin
  result := false;
  if (cx < 0) or (cy < 0) or (cx >= NgW) or (cy >= NgH) then exit;
  result := NgSafe[cy * NgW + cx];
end;

// the trace file: "S z" = a new stroke, "P x y" = point
function NmLoadTrace(F: string): boolean;
var L: TStringList;
  i: integer;
  S, K: string;
begin
  result := false;
  TrPN := 0;
  TrSN := 0;
  if not FileExists(F) then begin
    Engine.Msg('[Nav]', 'No trace file ' + F, 128);
    exit;
  end;
  L := TStringList.Create;
  L.LoadFromFile(F);
  SetLength(TrcX, L.Count);
  SetLength(TrcY, L.Count);
  SetLength(TrStart, L.Count + 1);
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    K := NmField(S, 0);
    if K = 'S' then begin
      TrStart[TrSN] := TrPN;
      Inc(TrSN);
    end else if (K = 'P') and (TrSN > 0) then begin
      TrcX[TrPN] := StrToIntDef(NmField(S, 1), 0);
      TrcY[TrPN] := StrToIntDef(NmField(S, 2), 0);
      Inc(TrPN);
    end;
  end;
  TrStart[TrSN] := TrPN;
  L.Free;
  result := TrPN > 1;
end;

function NmCellOf(X, Y: integer): integer;
var cx, cy: integer;
begin
  result := -1;
  if (X < NgX0) or (Y < NgY0) then exit;
  cx := (X - NgX0) div NgCell;
  cy := (Y - NgY0) div NgCell;
  if (cx >= NgW) or (cy >= NgH) then exit;
  result := cy * NgW + cx;
end;

// cells on the line A -> B become trace walls
procedure NmMarkLine(X1, Y1, X2, Y2: integer);
var k, n, c: integer;
  DX, DY, L: double;
begin
  DX := X2 - X1;
  DY := Y2 - Y1;
  L := Sqrt(DX * DX + DY * DY);
  n := Trunc(L / (NgCell / 3)) + 1;
  for k := 0 to n do begin
    c := NmCellOf(Round(X1 + DX * k / n), Round(Y1 + DY * k / n));
    if c >= 0 then NmWall[c] := true;
  end;
end;

// the trace cuts the free cells: stroke cells are walls (stroke ends closer than NAV_STITCH to any
// other trace point are joined), the pieces with a seed stay (none - the biggest piece), the stroke
// cells next to what stays are free again (our centre ran there)
procedure NmApplyTrace();
var Lab, Queue, Keep: array of integer;
  k, i, j, e, c, n, Head, Tail, Labels, Best, BestN, Cnt, X, Y, X2, Y2, Kept, Open: integer;
  D, BD: double;
  Any: boolean;
begin
  n := NgW * NgH;
  SetLength(NmWall, n);
  for c := 0 to n - 1 do NmWall[c] := false;
  Open := 0;
  for k := 0 to TrSN - 1 do begin
    for i := TrStart[k] to TrStart[k + 1] - 2 do begin
      X := TrcX[i]; Y := TrcY[i]; X2 := TrcX[i + 1]; Y2 := TrcY[i + 1];
      NmMarkLine(X, Y, X2, Y2);
    end;
    if TrStart[k + 1] - TrStart[k] < 2 then continue;
    for e := 0 to 1 do begin
      if e = 0 then i := TrStart[k] else i := TrStart[k + 1] - 1;
      BD := NAV_STITCH;
      Best := -1;
      for j := 0 to TrPN - 1 do begin
        if (j >= TrStart[k]) and (j < TrStart[k + 1]) and (Abs(j - i) < 15) then continue;
        D := Sqrt(Sqr(TrcX[j] - TrcX[i]) + Sqr(TrcY[j] - TrcY[i]));
        if D < BD then begin
          BD := D;
          Best := j;
        end;
      end;
      if Best >= 0 then begin
        X := TrcX[i]; Y := TrcY[i]; X2 := TrcX[Best]; Y2 := TrcY[Best];
        NmMarkLine(X, Y, X2, Y2);
      end else Inc(Open);
    end;
  end;
  for c := 0 to n - 1 do if NmWall[c] then NgFree[c] := false;
  // pieces of the free cells
  SetLength(Lab, n);
  SetLength(Queue, n);
  for c := 0 to n - 1 do Lab[c] := -1;
  Labels := 0;
  SetLength(Keep, 0);
  Best := -1;
  BestN := 0;
  for c := 0 to n - 1 do begin
    if (not NgFree[c]) or (Lab[c] >= 0) then continue;
    Head := 0;
    Tail := 1;
    Queue[0] := c;
    Lab[c] := Labels;
    Cnt := 0;
    while Head < Tail do begin
      i := Queue[Head];
      Inc(Head);
      Inc(Cnt);
      for e := 0 to 3 do begin
        if e = 0 then begin if (i mod NgW) = NgW - 1 then continue; j := i + 1; end
        else if e = 1 then begin if (i mod NgW) = 0 then continue; j := i - 1; end
        else if e = 2 then j := i + NgW
        else j := i - NgW;
        if (j < 0) or (j >= n) then continue;
        if NgFree[j] and (Lab[j] < 0) then begin
          Lab[j] := Labels;
          Queue[Tail] := j;
          Inc(Tail);
        end;
      end;
    end;
    if Cnt > BestN then begin
      BestN := Cnt;
      Best := Labels;
    end;
    Inc(Labels);
  end;
  SetLength(Keep, Labels + 1);
  for i := 0 to Labels - 1 do Keep[i] := 0;
  Any := false;
  NavAddSeed(User.X, User.Y);            // where we stand is walkable for sure
  for k := 0 to NmSeedN - 1 do begin
    c := NmCellOf(NmSeedX[k], NmSeedY[k]);
    if c < 0 then continue;
    // a seed right on a stroke: take the free cells round it
    for j := -1 to 1 do
      for i := -1 to 1 do begin
        e := c + j * NgW + i;
        if (e >= 0) and (e < n) and (Lab[e] >= 0) then begin
          Keep[Lab[e]] := 1;
          Any := true;
        end;
      end;
  end;
  if (not Any) and (Best >= 0) then Keep[Best] := 1;
  Kept := 0;
  for c := 0 to n - 1 do begin
    NgFree[c] := (Lab[c] >= 0) and (Keep[Lab[c]] = 1);
    if NgFree[c] then Inc(Kept);
  end;
  // the strokes themselves are walkable where they touch what stays
  for c := 0 to n - 1 do
    if NmWall[c] then begin
      i := c mod NgW;
      if ((i < NgW - 1) and (c + 1 < n) and NgFree[c + 1] and (not NmWall[c + 1])) or
         ((i > 0) and NgFree[c - 1] and (not NmWall[c - 1])) or
         ((c + NgW < n) and NgFree[c + NgW] and (not NmWall[c + NgW])) or
         ((c - NgW >= 0) and NgFree[c - NgW] and (not NmWall[c - NgW])) then Lab[c] := -2;
    end;
  for c := 0 to n - 1 do if Lab[c] = -2 then NgFree[c] := true;
  Engine.Msg('[Nav]', 'Trace: ' + IntToStr(TrSN) + ' strokes cut the map into ' + IntToStr(Labels) +
    ' pieces, kept ' + IntToStr(Kept) + ' cells' + '; open stroke ends: ' + IntToStr(Open), 128);
end;

// no zone, only the trace: every cell of the trace box is free before the cut
function NmFromTraceBox(): boolean;
var i, c, Cell, X0, Y0, X1, Y1: integer;
begin
  X0 := TrcX[0]; X1 := TrcX[0]; Y0 := TrcY[0]; Y1 := TrcY[0];
  for i := 1 to TrPN - 1 do begin
    if TrcX[i] < X0 then X0 := TrcX[i];
    if TrcX[i] > X1 then X1 := TrcX[i];
    if TrcY[i] < Y0 then Y0 := TrcY[i];
    if TrcY[i] > Y1 then Y1 := TrcY[i];
  end;
  Cell := NmCellSet;
  if Cell <= 0 then Cell := NAV_CELL;
  NmAlloc(X0 - Cell * 2, Y0 - Cell * 2, X1 + Cell * 2, Y1 + Cell * 2, Cell);
  for c := 0 to NgW * NgH - 1 do NgFree[c] := true;
  NgZ := User.Z;
  result := true;
end;

// a node at every convex corner of the walls (a safe cell whose diagonal neighbour is a wall while
// both side neighbours are safe), links between nodes that see each other
function NavBuild(): boolean;
var cx, cy, dx, dy, i, j, k, X, Y, X2, Y2, R, PX, PY: integer;
  Started: cardinal;
  Near: boolean;
begin
  result := NavOn;
  if NavBuilt then exit;
  NavBuilt := true;
  Started := GetTickCount;
  NavOn := false;
  if NmGridFile <> '' then NavOn := NmFromFile(Script.Path + '..\Nav\' + NmGridFile);
  if (not NavOn) and (NmTraceFile <> '') and NmLoadTrace(Script.Path + '..\Nav\' + NmTraceFile) then begin
    NavOn := NmFromZone();
    if not NavOn then NavOn := NmFromTraceBox();
    if NavOn then NmApplyTrace();
  end;
  if not NavOn then NavOn := NmFromZone();
  result := NavOn;
  if not NavOn then begin
    Engine.Msg('[Nav]', 'No map (zone / grid): runs go by the plain server path only', 128);
    exit;
  end;
  // corners and lines by the real map: a narrow passage must never vanish. A corner node is moved
  // off the wall (away from the corner) by up to NAV_CLEAR where there is room
  for i := 0 to NgW * NgH - 1 do NgSafe[i] := NgFree[i];
  R := NmErodeCells();
  NavN := 0;
  SetLength(NavX, NAV_MAX_NODES);
  SetLength(NavY, NAV_MAX_NODES);
  // own nodes drawn in the viewer first: always kept, the corner nodes next to them are not added
  for i := 0 to NmUserN - 1 do
    if NavN < NAV_MAX_NODES then begin
      NavX[NavN] := NmUserX[i];
      NavY[NavN] := NmUserY[i];
      Inc(NavN);
    end;
  for cy := 0 to NgH - 1 do
    for cx := 0 to NgW - 1 do begin
      if not NgSafe[cy * NgW + cx] then continue;
      for k := 0 to 3 do begin
        if k mod 2 = 0 then dx := 1 else dx := -1;
        if k < 2 then dy := 1 else dy := -1;
        if NmSafeCell(cx + dx, cy + dy) or (not NmSafeCell(cx + dx, cy)) or
           (not NmSafeCell(cx, cy + dy)) then continue;
        PX := cx;
        PY := cy;
        for j := 1 to R do
          if NmSafeCell(cx - dx * j, cy - dy * j) and NmSafeCell(cx - dx * j + dx, cy - dy * j) and
             NmSafeCell(cx - dx * j, cy - dy * j + dy) then begin
            PX := cx - dx * j;
            PY := cy - dy * j;
          end else break;
        X := NgX0 + PX * NgCell + NgCell div 2;
        Y := NgY0 + PY * NgCell + NgCell div 2;
        Near := false;
        for i := 0 to NavN - 1 do
          if (Abs(NavX[i] - X) <= NAV_NODE_GAP) and (Abs(NavY[i] - Y) <= NAV_NODE_GAP) then begin
            Near := true;
            break;
          end;
        for i := 0 to NmBanN - 1 do      // removed in the viewer: no node here
          if (Abs(NmBanX[i] - X) <= NAV_BAN_R) and (Abs(NmBanY[i] - Y) <= NAV_BAN_R) then begin
            Near := true;
            break;
          end;
        if (not Near) and (NavN < NAV_MAX_NODES) then begin
          NavX[NavN] := X;
          NavY[NavN] := Y;
          Inc(NavN);
        end;
        break;
      end;
    end;
  SetLength(NavHead, NavN);
  SetLength(NmBadUntil, NavN);
  for i := 0 to NavN - 1 do begin
    NavHead[i] := -1;
    NmBadUntil[i] := 0;
  end;
  NavLinkN := 0;
  for i := 0 to NavN - 1 do
    for j := i + 1 to NavN - 1 do begin
      if NmDist(i, j) > NAV_LINK_MAX then continue;
      X := NavX[i];
      Y := NavY[i];
      X2 := NavX[j];
      Y2 := NavY[j];
      if NmLineFree(X, Y, X2, Y2, true) then NmLink(i, j);
    end;
  Engine.Msg('[Nav]', 'Map ' + IntToStr(NgW) + 'x' + IntToStr(NgH) + ' cells of ' + IntToStr(NgCell) +
    ': ' + IntToStr(NavN) + ' nodes (' + IntToStr(NmUserN) + ' own), ' + IntToStr(NavLinkN div 2) + ' links (' +
    IntToStr((GetTickCount - Started) div 1000) + ' s)', 128);
end;

// server path to one node without stopping at it: true as soon as we are near it
function NmGo(PX, PY, PZ: integer): boolean;
var UX, UY, LX, LY, Stuck: integer;
  Started, StillSince: cardinal;
begin
  result := false;
  Started := GetTickCount;
  StillSince := GetTickCount;
  Stuck := 0;
  LX := User.X;
  LY := User.Y;
  NavClick(PX, PY, PZ);
  while User.DistTo(PX, PY, PZ) > NAV_POINT_REACH do begin
    if User.Dead then exit;
    if GetTickCount - Started > NAV_POINT_MS then exit;
    UX := User.X;
    UY := User.Y;
    if (Abs(UX - LX) > 20) or (Abs(UY - LY) > 20) then begin
      LX := UX;
      LY := UY;
      StillSince := GetTickCount;
    end else if GetTickCount - StillSince > NAV_STILL_MS then begin
      Inc(Stuck);
      if Stuck >= NAV_STUCK_MAX then exit;
      NavClick(PX, PY, PZ);
      StillSince := GetTickCount;
    end;
    Delay(100);
  end;
  result := true;
end;

// the route on the graph from us to the target into NavRoute: first nodes = every node in sight of
// us, last node = the one in sight of the target with the shortest total way; false = no way
function NmPlanTo(X, Y: integer): boolean;
var i, u, v, e, k, Best, UX, UY, PX, PY: integer;
  Alt, BestD, DX, DY: double;
begin
  result := false;
  if (not NavOn) or (NavN = 0) then exit;
  SetLength(NavD, NavN);
  SetLength(NavPrev, NavN);
  SetLength(NavDone, NavN);
  UX := User.X;
  UY := User.Y;
  for i := 0 to NavN - 1 do begin
    NavD[i] := 1E18;
    NavPrev[i] := -1;
    NavDone[i] := false;
    DX := NavX[i] - UX;
    DY := NavY[i] - UY;
    Alt := Sqrt(DX * DX + DY * DY);
    if Alt <= NAV_SEE_MAX then begin
      PX := NavX[i];
      PY := NavY[i];
      if (GetTickCount >= NmBadUntil[i]) and NmLineFree(UX, UY, PX, PY, false) then NavD[i] := Alt;
    end;
  end;
  for k := 0 to NavN - 1 do begin
    u := -1;
    BestD := 1E17;
    for i := 0 to NavN - 1 do
      if (not NavDone[i]) and (NavD[i] < BestD) then begin
        BestD := NavD[i];
        u := i;
      end;
    if u < 0 then break;
    NavDone[u] := true;
    e := NavHead[u];
    while e >= 0 do begin
      v := NavTo[e];
      if (not NavDone[v]) and (GetTickCount >= NmBadUntil[v]) then begin
        Alt := NavD[u] + NmDist(u, v);
        if Alt < NavD[v] then begin
          NavD[v] := Alt;
          NavPrev[v] := u;
        end;
      end;
      e := NavNext[e];
    end;
  end;
  Best := -1;
  BestD := 1E17;
  for i := 0 to NavN - 1 do begin
    if NavD[i] >= 1E17 then continue;
    DX := NavX[i] - X;
    DY := NavY[i] - Y;
    Alt := Sqrt(DX * DX + DY * DY);
    if (Alt > NAV_SEE_MAX) or (NavD[i] + Alt >= BestD) then continue;
    PX := NavX[i];
    PY := NavY[i];
    if NmLineFree(PX, PY, X, Y, false) then begin
      BestD := NavD[i] + Alt;
      Best := i;
    end;
  end;
  if Best < 0 then exit;
  NavRouteN := 0;
  v := Best;
  while v >= 0 do begin
    Inc(NavRouteN);
    v := NavPrev[v];
  end;
  SetLength(NavRoute, NavRouteN);
  v := Best;
  for i := NavRouteN - 1 downto 0 do begin
    NavRoute[i] := v;
    v := NavPrev[v];
  end;
  result := true;
end;

// where to click now on the way to X, Y: the farthest node of the route that is in sight of us
// (a short cut over the nodes before it); false = the target is in sight itself, or no way
function NavWaypoint(X, Y: integer): boolean;
var k, i, UX, UY, PX, PY: integer;
begin
  result := false;
  if not NavOn then exit;
  UX := User.X;
  UY := User.Y;
  if NmLineFree(UX, UY, X, Y, false) then exit;   // straight to it
  if not NmPlanTo(X, Y) then exit;
  for k := NavRouteN - 1 downto 0 do begin
    i := NavRoute[k];
    PX := NavX[i];
    PY := NavY[i];
    if (k = 0) or NmLineFree(UX, UY, PX, PY, false) then begin
      NmWpX := PX;
      NmWpY := PY;
      result := true;
      exit;
    end;
  end;
end;

function NavWpX(): integer;
begin
  result := NmWpX;
end;

function NavWpY(): integer;
begin
  result := NmWpY;
end;

// along the graph to the target; a node is skipped as soon as the next one is in sight.
// true = the target is in sight now (the caller runs the rest)
function NavGraphTo(X, Y, Z: integer): boolean;
var i, k, PX, PY, NX2, NY2: integer;
  Ok: boolean;
begin
  result := false;
  if NavBusyFlag or (not NavOn) or (NavN = 0) then exit;
  if not NmPlanTo(X, Y) then begin
    Engine.Msg('[Nav]', 'No way on the map to ' + IntToStr(X) + ', ' + IntToStr(Y) + ' - plain server path', 128);
    exit;
  end;
  Engine.Msg('[Nav]', 'Wall on the way, along the map (' + IntToStr(NavRouteN) + ' nodes)', 0);
  NavBusyFlag := true;
  Ok := true;
  k := 0;
  while k < NavRouteN do begin
    if NavSeeFromUs(X, Y) then break;  // the target is in sight: the rest goes straight
    if k + 1 < NavRouteN then begin
      i := NavRoute[k + 1];
      NX2 := NavX[i];
      NY2 := NavY[i];
      if NavSeeFromUs(NX2, NY2) then begin
        Inc(k);                        // the next node is in sight: this one is not needed
        continue;
      end;
    end;
    i := NavRoute[k];
    PX := NavX[i];
    PY := NavY[i];
    if not NmGo(PX, PY, Z) then begin
      if not User.Dead then begin
        // the map is wrong there (painted walkable, but it is not): routes go round it for a while
        NmBadUntil[i] := GetTickCount + NAV_BAD_MS;
        Engine.Msg('[Nav]', 'Cannot get to map node ' + IntToStr(i + 1) + ' at ' + IntToStr(PX) + ', ' +
          IntToStr(PY) + ' - left out of routes for ' + IntToStr(NAV_BAD_MS div 1000) +
          ' s (fix the nav map there?)', 128);
      end;
      Ok := false;
      break;
    end;
    Inc(k);
  end;
  NavBusyFlag := false;
  result := Ok;
end;

// ---------- farm spot round a corner ----------

function NavSpotX(): integer;
begin
  result := NmSpotX;
end;

function NavSpotY(): integer;
begin
  result := NmSpotY;
end;

procedure NavSpotClear();
begin
  NmMobN := 0;
end;

procedure NavSpotAddMob(X, Y: integer);
begin
  if NmMobN >= 64 then exit;
  NmMobX[NmMobN] := X;
  NmMobY[NmMobN] := Y;
  Inc(NmMobN);
end;

// no mob of the pack sees P (at most 8 of them checked, spread over the list); none added - the centre
function NmHiddenAll(PX, PY, CX, CY: integer): boolean;
var k, Step, MX, MY: integer;
begin
  result := false;
  if NmLineFree(CX, CY, PX, PY, false) then exit;
  Step := NmMobN div 8 + 1;
  k := 0;
  while k < NmMobN do begin
    MX := NmMobX[k];
    MY := NmMobY[k];
    if NmLineFree(MX, MY, PX, PY, false) then exit;
    k := k + Step;
  end;
  result := true;
end;

// a corner that really shields: P moved 50 / 90 to both sides (across the way from the pack) is
// still hidden from the pack centre and walkable -> 0..4 (a long wall, not a small bump)
function NmShield(PX, PY, CX, CY: integer): integer;
var k, QX, QY: integer;
  UX, UY, L, Off: double;
begin
  result := 0;
  UX := PX - CX;
  UY := PY - CY;
  L := Sqrt(UX * UX + UY * UY);
  if L < 1 then exit;
  UX := UX / L;
  UY := UY / L;
  for k := 0 to 3 do begin
    if k = 0 then Off := -90 else if k = 1 then Off := -50 else if k = 2 then Off := 50 else Off := 90;
    QX := PX + Round(-UY * Off);
    QY := PY + Round(UX * Off);
    if NmFreeAt(QX, QY, false) and (not NmLineFree(CX, CY, QX, QY, false)) then Inc(result);
  end;
end;

// the score of P round the corner node N against the pack centre C (we stand at F): -1 = no good.
// The pack sees N, N sees P, no mob of the pack sees P, the way pack -> N -> P turns by 80+ degrees,
// P is not much closer to the pack than we are. Higher = sharper turn, longer shielding wall, nearer
function NmSpotScore(NX, NY, PX, PY, CX, CY, FX, FY: integer; Given: boolean): double;
var AX, AY, BX, BY, LA, LB, CosT, DUC, DPC, DUP: double;
begin
  result := -1;
  // a found point must be walkable on the map; a given one (recorded in the game) is reachable for
  // sure even off the painted cells - the run ends there by the plain server path
  if (not Given) and (not NmFreeAt(PX, PY, false)) then exit;
  AX := NX - CX;
  AY := NY - CY;
  BX := PX - NX;
  BY := PY - NY;
  LA := Sqrt(AX * AX + AY * AY);
  LB := Sqrt(BX * BX + BY * BY);
  if (LA < 1) or (LB < 1) then exit;
  CosT := (AX * BX + AY * BY) / (LA * LB);
  if CosT > 0.17 then exit;                  // less than ~80 degrees of turn: they just run on to us
  DUC := Sqrt(Sqr(FX - CX) + Sqr(FY - CY));
  DPC := Sqrt(Sqr(PX - CX) + Sqr(PY - CY));
  if DPC < DUC * 0.8 then exit;              // through the pack
  if not NmLineFree(NX, NY, PX, PY, not Given) then exit;
  if not NmLineFree(CX, CY, NX, NY, false) then exit;   // the pack must see the corner itself
  if not NmHiddenAll(PX, PY, CX, CY) then exit;
  DUP := Sqrt(Sqr(FX - PX) + Sqr(FY - PY));
  result := (1 - CosT) * 90 + NmShield(PX, PY, CX, CY) * 25 - DUP / 20;
  if result < 0 then result := 0;
end;

// the graph nodes stand at the convex corners of the walls. Round every node within MaxDist of us
// try points 65 / 95 away (12 directions) and keep the best scored one (NmSpotScore)
function NavFindCornerSpot(FromX, FromY, MX, MY, MaxDist: integer): boolean;
var i, a, r, NX, NY, PX, PY: integer;
  D, Best, Sc, Ang, Rad: double;
begin
  result := false;
  if (not NavOn) or (NavN = 0) then exit;
  Best := -1;
  for i := 0 to NavN - 1 do begin
    NX := NavX[i];
    NY := NavY[i];
    D := Sqrt(Sqr(NX - FromX) + Sqr(NY - FromY));
    if D > MaxDist then continue;
    if not NmLineFree(MX, MY, NX, NY, false) then continue;   // the pack must see the corner itself
    for r := 0 to 1 do begin
      if r = 0 then Rad := 65 else Rad := 95;
      for a := 0 to 11 do begin
        Ang := a * 3.14159265 / 6;
        PX := NX + Round(Cos(Ang) * Rad);
        PY := NY + Round(Sin(Ang) * Rad);
        Sc := NmSpotScore(NX, NY, PX, PY, MX, MY, FromX, FromY, false);
        if Sc > Best then begin
          Best := Sc;
          NmSpotX := PX;
          NmSpotY := PY;
          result := true;
        end;
      end;
    end;
  end;
end;

// a given spot: scored round the best corner node near it (within 220)
function NavSpotScore(PX, PY, FromX, FromY, MX, MY: integer): double;
var i, NX, NY: integer;
  D, Sc: double;
begin
  result := -1;
  if (not NavOn) or (NavN = 0) then exit;
  for i := 0 to NavN - 1 do begin
    NX := NavX[i];
    NY := NavY[i];
    D := Sqrt(Sqr(NX - PX) + Sqr(NY - PY));
    if D > 220 then continue;
    Sc := NmSpotScore(NX, NY, PX, PY, MX, MY, FromX, FromY, true);
    if Sc > result then result := Sc;
  end;
end;

// run length to X, Y: straight if in sight, else along the planned route
function NavPathLen(X, Y: integer): double;
var k, i, j, UX, UY: integer;
  DX, DY: double;
begin
  UX := User.X;
  UY := User.Y;
  DX := X - UX;
  DY := Y - UY;
  result := Sqrt(DX * DX + DY * DY);
  if (not NavOn) or NmLineFree(UX, UY, X, Y, false) then exit;
  if not NmPlanTo(X, Y) then begin
    result := -1;
    exit;
  end;
  i := NavRoute[0];
  result := Sqrt(Sqr(NavX[i] - UX) + Sqr(NavY[i] - UY));
  for k := 1 to NavRouteN - 1 do begin
    i := NavRoute[k - 1];
    j := NavRoute[k];
    result := result + NmDist(i, j);
  end;
  i := NavRoute[NavRouteN - 1];
  result := result + Sqrt(Sqr(NavX[i] - X) + Sqr(NavY[i] - Y));
end;

// patrol: the next graph node at least MinDist away, going round the node list (spread over the map)
function NavFarPoint(MinDist: integer): boolean;
var k, i, UX, UY: integer;
  D: double;
begin
  result := false;
  if (not NavOn) or (NavN = 0) then exit;
  UX := User.X;
  UY := User.Y;
  for k := 0 to NavN - 1 do begin
    i := (NmFarNext + k * 7 + 3) mod NavN;   // a big step through the list: far apart one after another
    D := Sqrt(Sqr(NavX[i] - UX) + Sqr(NavY[i] - UY));
    if D < MinDist then continue;
    if GetTickCount < NmBadUntil[i] then continue;
    NmFarXv := NavX[i];
    NmFarYv := NavY[i];
    NmFarNext := i;
    result := true;
    exit;
  end;
end;

function NavFarX(): integer;
begin
  result := NmFarXv;
end;

function NavFarY(): integer;
begin
  result := NmFarYv;
end;

// plain server path run to within Radius; not moving for NAV_STALL_MS = stuck -> false
function NmPlain(X, Y, Z, Radius: integer): boolean;
var Started, LastSend, StillSince, MaxMs: cardinal;
  UX, UY, LX, LY: integer;
  DX, DY: double;
begin
  result := false;
  LX := User.X;
  LY := User.Y;
  DX := X - LX;
  DY := Y - LY;
  MaxMs := Round(Sqrt(DX * DX + DY * DY) * 10) + 5000;
  Started := GetTickCount;
  StillSince := GetTickCount;
  LastSend := 0;
  while not User.Dead do begin
    UX := User.X;
    UY := User.Y;
    DX := X - UX;
    DY := Y - UY;
    if Sqrt(DX * DX + DY * DY) <= Radius then begin
      result := true;
      exit;
    end;
    if GetTickCount - Started > MaxMs then exit;
    if (Abs(UX - LX) > 20) or (Abs(UY - LY) > 20) then begin
      LX := UX;
      LY := UY;
      StillSince := GetTickCount;
    end else if GetTickCount - StillSince > NAV_STALL_MS then exit;
    if (LastSend = 0) or (GetTickCount - LastSend >= NAV_RESEND_MS) then begin
      NavClick(X, Y, Z);
      LastSend := GetTickCount;
    end;
    Delay(100);
  end;
end;

// the whole run: behind a wall -> along the graph first; then the plain server path; stuck -> the
// graph and the plain path once more
function NavMoveTo(X, Y, Z, Radius: integer): boolean;
begin
  if NavOn and (not NavBusyFlag) and (not NavSeeFromUs(X, Y)) then NavGraphTo(X, Y, Z);
  result := NmPlain(X, Y, Z, Radius);
  if result or User.Dead or NavBusyFlag or (not NavOn) then exit;
  if NavGraphTo(X, Y, Z) then result := NmPlain(X, Y, Z, Radius);
end;

end.
