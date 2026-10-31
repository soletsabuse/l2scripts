unit NavExplore;

// Lidar scan of a zone: the character runs STRAIGHT (no server pathfinding: the server stops it at
// the first wall) inside the zone and feels every wall out. The zone is cut into cells:
//   '.' = we ran through it (free), '#' = we bumped into it (wall), '?' = not felt yet, ' ' = out of the zone.
// Each step: the nearest not felt cell next to a free one -> run there through free cells, then run
// straight into it and on; where we stop is a wall. No such cells left = done. The grid is saved
// to Library\Nav\<GridFile> (every 20 s and at the end; started again = goes on from the file) and is
// used by spot_farm_pack_nav.pas (SetNavGrid) and shown / edited / turned into a .zmap by
// Library\Nav\nav_view.html.
//
//   uses NavExplore in 'Core\nav_explore.pas';
//   begin
//     ExploreZone('CRUMA_MORDEO_1.zmap', 'CRUMA_MORDEO_1.navgrid', 40);
//   end.
//
// Scan area = the OUTER contour of the .zmap + 200 round it; its cut-outs are scanned too (they are
// usually places not to farm, not walls) - so the farm zone itself does. The bot's zone is not changed.
// Stand inside the zone, no mobs on you (the scan does not fight; a mob in the way looks like a wall
// for a moment - a later run through that cell fixes it).

interface

uses SysUtils, Classes;

// ZoneFile: .zmap in Library\Zones ('' or no such file = the zone active in the bot, its edges found by itself);
// GridFile: result in Library\Nav; Cell: cell size (0 = 40)
procedure ExploreZone(ZoneFile, GridFile: string; Cell: integer);
// FAST scan, only the obstacles: straight rows Spacing apart across the zone, then columns; an
// obstacle on the way = its wall is written, we run round it (server path) and go on along the row.
// Minutes instead of hours; the rest (fill the rooms) is done in nav_view.html
procedure ExploreRows(ZoneFile, GridFile: string; Cell, Spacing: integer);

implementation

const
  EX_CELL      = 40;
  EX_PROBE     = 8;          // a probe runs on this many cells past the cell it was sent to
  EX_STOP_MS   = 600;        // not moved this long = stopped (wall)
  EX_REACH     = 45;         // this close to the point = got there (the server stops a bit short)
  EX_WAY_TRIES = 3;          // the way to a not felt cell failed so many times -> that cell is given up
  EX_GO_NEAR   = 60;         // rows: server path run counts as there this close
  EX_GO_STALL  = 1500;       // rows: server path run not moving this long = cannot get there
  EX_JUMP      = 64;         // rows: after an obstacle try to go on this much further along the row
  EX_GO_DEAD   = 800;        // rows: server path run that does not move us at all this long = no way there
  EX_TICK_MS   = 50;
  EX_SAVE_MS   = 20000;
  EX_NONE      = -999999999;
  EX_MARGIN    = 200;        // scan this far out of the zone contour too (walls right at its edge)
  EX_RING      = 200;        // no zone file: the active zone's box is felt with InZone this often
  EX_RING_MAX  = 20000;      // ... at most this far from us
  ST_UNKNOWN   = 0;
  ST_FREE      = 1;
  ST_WALL      = 2;
  ST_OUT       = 3;

var
  GX0, GY0, GCell, GW, GH, GZ: integer;
  GSt: array of integer;
  BX0, BY0, BX1, BY1: integer;
  Prev, Queue: array of integer;
  GridPath: string;
  SavedAt: cardinal;
  WayFails: integer;           // runs along a "free" way that stopped short, in a row
  ZOX, ZOY: array of integer;  // outer contour of the zone
  GIn: array of boolean;       // the cell is in the zone itself (not in the margin round it)
  ZOn: integer;

function ExHex(Value: integer): string;
begin
  result := IntToHex(Value and $FF, 2) + IntToHex((Value shr 8) and $FF, 2) +
            IntToHex((Value shr 16) and $FF, 2) + IntToHex((Value shr 24) and $FF, 2);
end;

// a STRAIGHT run order: like a click, but 0 = not by mouse -> no server pathfinding, the server
// stops us at the first wall on the line
procedure ExMoveOrder(X, Y, Z: integer);
var UX, UY, UZ: integer;
begin
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  Engine.SendToServer('0F' + ExHex(X) + ExHex(Y) + ExHex(Z) + ExHex(UX) + ExHex(UY) + ExHex(UZ) + ExHex(0));
end;

function ExAttr(S, Key: string): integer;
var p, q: integer;
  T: string;
begin
  result := EX_NONE;
  p := Pos(Key + '="', S);
  if p = 0 then exit;
  T := Copy(S, p + Length(Key) + 2, 20);
  q := Pos('"', T);
  if q > 0 then T := Copy(T, 1, q - 1);
  result := StrToIntDef(T, EX_NONE);
end;

// only the OUTER contour of the .zmap: its cut-outs are usually places not to farm, not walls -
// the scan finds the real walls itself. Box = contour + EX_MARGIN
function ExLoadOuter(F: string): boolean;
var L: TStringList;
  i, X, Y: integer;
  S: string;
  InOuter: boolean;
begin
  result := false;
  ZOn := 0;
  if not FileExists(F) then exit;
  L := TStringList.Create;
  L.LoadFromFile(F);
  SetLength(ZOX, L.Count);
  SetLength(ZOY, L.Count);
  InOuter := false;
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    if Pos('<ExternalPoly', S) > 0 then InOuter := true
    else if Pos('</ExternalPoly', S) > 0 then InOuter := false
    else if InOuter and (Pos('<point', S) > 0) then begin
      X := ExAttr(S, ' x');
      Y := ExAttr(S, ' y');
      if (X = EX_NONE) or (Y = EX_NONE) then continue;
      ZOX[ZOn] := X;
      ZOY[ZOn] := Y;
      if ZOn = 0 then begin
        BX0 := X; BX1 := X; BY0 := Y; BY1 := Y;
      end;
      if X < BX0 then BX0 := X;
      if X > BX1 then BX1 := X;
      if Y < BY0 then BY0 := Y;
      if Y > BY1 then BY1 := Y;
      Inc(ZOn);
    end;
  end;
  L.Free;
  BX0 := BX0 - EX_MARGIN;
  BY0 := BY0 - EX_MARGIN;
  BX1 := BX1 + EX_MARGIN;
  BY1 := BY1 + EX_MARGIN;
  result := ZOn >= 3;
end;

// the point is inside the outer contour of the zone
function ExInOuter(X, Y: integer): boolean;
var i, j: integer;
begin
  result := false;
  j := ZOn - 1;
  for i := 0 to ZOn - 1 do begin
    if ((ZOY[i] > Y) <> (ZOY[j] > Y)) and
       (X < (ZOX[j] - ZOX[i]) * (Y - ZOY[i]) / (ZOY[j] - ZOY[i]) + ZOX[i]) then result := not result;
    j := i;
  end;
end;

// the point is in the scan area: inside the outer contour or at most EX_MARGIN out of it
function ExInScan(X, Y: integer): boolean;
var i, j: integer;
  AX, AY, BX, BY, DX, DY, L2, T, PX, PY: double;
begin
  result := false;
  j := ZOn - 1;
  for i := 0 to ZOn - 1 do begin
    if ((ZOY[i] > Y) <> (ZOY[j] > Y)) and
       (X < (ZOX[j] - ZOX[i]) * (Y - ZOY[i]) / (ZOY[j] - ZOY[i]) + ZOX[i]) then result := not result;
    j := i;
  end;
  if result then exit;
  j := ZOn - 1;
  for i := 0 to ZOn - 1 do begin
    AX := ZOX[j]; AY := ZOY[j]; BX := ZOX[i]; BY := ZOY[i];
    DX := BX - AX;
    DY := BY - AY;
    L2 := DX * DX + DY * DY;
    T := 0;
    if L2 > 0 then T := ((X - AX) * DX + (Y - AY) * DY) / L2;
    if T < 0 then T := 0;
    if T > 1 then T := 1;
    PX := AX + DX * T - X;
    PY := AY + DY * T - Y;
    if PX * PX + PY * PY <= EX_MARGIN * EX_MARGIN then begin
      result := true;
      exit;
    end;
    j := i;
  end;
end;

function ExField(S: string; k: integer): string;
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

// cell index of a point; -1 = off the grid
function ExIdx(X, Y: integer): integer;
var cx, cy: integer;
begin
  result := -1;
  if (X < GX0) or (Y < GY0) then exit;
  cx := (X - GX0) div GCell;
  cy := (Y - GY0) div GCell;
  if (cx >= GW) or (cy >= GH) then exit;
  result := cy * GW + cx;
end;

function ExCX(i: integer): integer;
begin
  result := GX0 + (i mod GW) * GCell + GCell div 2;
end;

function ExCY(i: integer): integer;
begin
  result := GY0 + (i div GW) * GCell + GCell div 2;
end;

procedure ExSave();
var L: TStringList;
  cy, cx, St: integer;
  Row: string;
begin
  L := TStringList.Create;
  L.Add('# navgrid from nav_explore: . free, # wall, ? not scanned, space = out of the zone');
  L.Add('G ' + IntToStr(GX0) + ' ' + IntToStr(GY0) + ' ' + IntToStr(GCell) + ' ' + IntToStr(GW) + ' ' +
    IntToStr(GH) + ' ' + IntToStr(GZ));
  for cy := 0 to GH - 1 do begin
    Row := '';
    for cx := 0 to GW - 1 do begin
      St := GSt[cy * GW + cx];
      if St = ST_FREE then Row := Row + '.'
      else if St = ST_WALL then Row := Row + '#'
      else if St = ST_UNKNOWN then Row := Row + '?'
      else Row := Row + ' ';
    end;
    L.Add('R ' + Row);
  end;
  try
    L.SaveToFile(GridPath);
  except
    Engine.Msg('[Scan]', 'Could not write ' + GridPath, 255);
  end;
  L.Free;
  SavedAt := GetTickCount;
end;

// an earlier scan of the same grid: take what it felt
procedure ExLoadOld();
var L: TStringList;
  i, cx, cy: integer;
  S, Row: string;
  C: char;
begin
  if not FileExists(GridPath) then exit;
  L := TStringList.Create;
  L.LoadFromFile(GridPath);
  cy := -1;
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    if ExField(S, 0) = 'G' then begin
      if (StrToIntDef(ExField(S, 1), 0) <> GX0) or (StrToIntDef(ExField(S, 2), 0) <> GY0) or
         (StrToIntDef(ExField(S, 3), 0) <> GCell) or (StrToIntDef(ExField(S, 4), 0) <> GW) then begin
        Engine.Msg('[Scan]', 'Old ' + GridPath + ' is for another grid, starting anew', 128);
        L.Free;
        exit;
      end;
      cy := 0;
    end else if (Copy(S, 1, 2) = 'R ') and (cy >= 0) and (cy < GH) then begin
      Row := Copy(S, 3, GW);
      for cx := 0 to Length(Row) - 1 do begin
        if GSt[cy * GW + cx] = ST_OUT then continue;
        C := Row[cx + 1];
        if C = '.' then GSt[cy * GW + cx] := ST_FREE
        else if C = '#' then GSt[cy * GW + cx] := ST_WALL;
      end;
      Inc(cy);
    end;
  end;
  L.Free;
  Engine.Msg('[Scan]', 'Going on from ' + GridPath, 128);
end;

// cells on the line A -> B we ran through: free (a run through a "wall" cell fixes it)
procedure ExMarkTrail(X1, Y1, X2, Y2: integer);
var k, n, i: integer;
  DX, DY, L: double;
begin
  DX := X2 - X1;
  DY := Y2 - Y1;
  L := Sqrt(DX * DX + DY * DY);
  n := Trunc(L / (GCell * 0.5)) + 1;
  for k := 0 to n do begin
    i := ExIdx(Round(X1 + DX * k / n), Round(Y1 + DY * k / n));
    if (i >= 0) and (GSt[i] <> ST_OUT) then GSt[i] := ST_FREE;
  end;
end;

// run straight to the point and feel the way: true = got there. Stopped short -> the cell right
// in front of us is a wall, if it was not felt yet (a free cell is never turned into a wall)
function ExRun(X, Y: integer): boolean;
var UX, UY, LX, LY, PX, PY, i: integer;
  Started, StillSince, MaxMs: cardinal;
  DX, DY, L: double;
begin
  result := false;
  LX := User.X;
  LY := User.Y;
  PX := LX;
  PY := LY;
  DX := X - LX;
  DY := Y - LY;
  L := Sqrt(DX * DX + DY * DY);
  if L < EX_REACH then begin
    result := true;
    exit;
  end;
  MaxMs := Round(L * 10) + 2000;
  Started := GetTickCount;
  StillSince := GetTickCount;
  ExMoveOrder(X, Y, GZ);
  while not User.Dead do begin
    Delay(EX_TICK_MS);
    UX := User.X;
    UY := User.Y;
    ExMarkTrail(PX, PY, UX, UY);
    PX := UX;
    PY := UY;
    DX := X - UX;
    DY := Y - UY;
    if Sqrt(DX * DX + DY * DY) <= EX_REACH then begin
      result := true;
      exit;
    end;
    if (Abs(UX - LX) > 8) or (Abs(UY - LY) > 8) then begin
      LX := UX;
      LY := UY;
      StillSince := GetTickCount;
    end else if GetTickCount - StillSince > EX_STOP_MS then break;
    if GetTickCount - Started > MaxMs then break;
  end;
  if User.Dead then exit;
  // stopped short: the cell ahead on the line is a wall
  L := Sqrt(DX * DX + DY * DY);
  if L > 0 then begin
    i := ExIdx(Round(PX + DX / L * GCell * 0.8), Round(PY + DY / L * GCell * 0.8));
    if (i >= 0) and (GSt[i] = ST_UNKNOWN) then GSt[i] := ST_WALL;
  end;
end;

// straight line through free cells only (where we can run without feeling anew)
function ExLineFree(X1, Y1, X2, Y2: integer): boolean;
var k, n, i: integer;
  DX, DY, L: double;
begin
  result := true;
  DX := X2 - X1;
  DY := Y2 - Y1;
  L := Sqrt(DX * DX + DY * DY);
  n := Trunc(L / (GCell * 0.5)) + 1;
  for k := 0 to n do begin
    i := ExIdx(Round(X1 + DX * k / n), Round(Y1 + DY * k / n));
    if (i < 0) or (GSt[i] <> ST_FREE) then begin
      result := false;
      exit;
    end;
  end;
end;

// breadth search over free cells from Start to the nearest free cell that touches a not felt one.
// result = that not felt cell (-1 = none left); Prev[] leads back to Start
function ExFindFrontier(Start: integer): integer;
var Head, Tail, c, n, k, cx, cy, ax, ay: integer;
begin
  result := -1;
  for c := 0 to GW * GH - 1 do Prev[c] := -2;
  Head := 0;
  Tail := 0;
  Queue[Tail] := Start;
  Inc(Tail);
  Prev[Start] := -1;
  while Head < Tail do begin
    c := Queue[Head];
    Inc(Head);
    cx := c mod GW;
    cy := c div GW;
    for k := 0 to 3 do begin
      ax := cx;
      ay := cy;
      if k = 0 then Inc(ax) else if k = 1 then Dec(ax) else if k = 2 then Inc(ay) else Dec(ay);
      if (ax < 0) or (ay < 0) or (ax >= GW) or (ay >= GH) then continue;
      n := ay * GW + ax;
      if GSt[n] = ST_UNKNOWN then begin
        Prev[n] := c;
        result := n;
        exit;
      end;
      if (GSt[n] = ST_FREE) and (Prev[n] = -2) then begin
        Prev[n] := c;
        Queue[Tail] := n;
        Inc(Tail);
      end;
    end;
  end;
end;

// run along the found way (free cells) to the cell From: straight to the farthest cell of the way
// still in sight, again and again
function ExRunWay(From: integer): boolean;
var Way: array of integer;
  n, c, k, j, UX, UY, X, Y: integer;
begin
  result := false;
  n := 0;
  c := From;
  while c >= 0 do begin
    Inc(n);
    c := Prev[c];
  end;
  SetLength(Way, n);
  c := From;
  for k := n - 1 downto 0 do begin
    Way[k] := c;
    c := Prev[c];
  end;
  k := 0;
  while k < n - 1 do begin
    UX := User.X;
    UY := User.Y;
    j := n - 1;
    while j > k + 1 do begin
      X := ExCX(Way[j]);
      Y := ExCY(Way[j]);
      if ExLineFree(UX, UY, X, Y) then break;
      Dec(j);
    end;
    X := ExCX(Way[j]);
    Y := ExCY(Way[j]);
    if not ExRun(X, Y) then exit;      // a wall where we thought free: search again
    k := j;
  end;
  result := true;
end;

// the zone active in the bot (no file): its box, found by asking InZone on rings every EX_RING round
// us until a ring has no zone point left; false = we do not stand in a zone
function ExActiveBox(UX, UY, UZ: integer): boolean;
var R, Far, k, n, X, Y, Side: integer;
  Any: boolean;
begin
  result := Engine.InZone(UX, UY, UZ);
  if not result then exit;
  BX0 := UX; BX1 := UX; BY0 := UY; BY1 := UY;
  Far := 0;
  R := EX_RING;
  while R <= EX_RING_MAX do begin
    Any := false;
    n := (2 * R) div EX_RING;
    for Side := 0 to 3 do
      for k := 0 to n - 1 do begin
        if Side = 0 then begin X := UX - R + k * EX_RING; Y := UY - R; end
        else if Side = 1 then begin X := UX + R; Y := UY - R + k * EX_RING; end
        else if Side = 2 then begin X := UX + R - k * EX_RING; Y := UY + R; end
        else begin X := UX - R; Y := UY + R - k * EX_RING; end;
        if Engine.InZone(X, Y, UZ) then begin
          Any := true;
          if X < BX0 then BX0 := X;
          if X > BX1 then BX1 := X;
          if Y < BY0 then BY0 := Y;
          if Y > BY1 then BY1 := Y;
        end;
      end;
    if Any then Far := R
    else if R > Far + EX_RING * 2 then break;   // two empty rings past the last zone point: done
    R := R + EX_RING;
  end;
  BX0 := BX0 - EX_RING - EX_MARGIN;
  BY0 := BY0 - EX_RING - EX_MARGIN;
  BX1 := BX1 + EX_RING + EX_MARGIN;
  BY1 := BY1 + EX_RING + EX_MARGIN;
end;

// active zone: cells up to EX_MARGIN out of the zone are scanned too (walls at its very edge)
procedure ExGrowActive();
var cx, cy, k, M, Run: integer;
  Tmp: array of integer;
begin
  M := EX_MARGIN div GCell;
  if M < 1 then exit;
  SetLength(Tmp, GW * GH);
  for k := 0 to GW * GH - 1 do Tmp[k] := GSt[k];
  // rows then columns: a cell is in when a zone cell is at most M cells away
  for cy := 0 to GH - 1 do begin
    Run := -100000;
    for cx := 0 to GW - 1 do begin
      if GSt[cy * GW + cx] <> ST_OUT then Run := cx;
      if cx - Run <= M then Tmp[cy * GW + cx] := ST_UNKNOWN;
    end;
    Run := 100000;
    for cx := GW - 1 downto 0 do begin
      if GSt[cy * GW + cx] <> ST_OUT then Run := cx;
      if Run - cx <= M then Tmp[cy * GW + cx] := ST_UNKNOWN;
    end;
  end;
  for k := 0 to GW * GH - 1 do GSt[k] := Tmp[k];
  for cx := 0 to GW - 1 do begin
    Run := -100000;
    for cy := 0 to GH - 1 do begin
      if GSt[cy * GW + cx] <> ST_OUT then Run := cy;
      if cy - Run <= M then Tmp[cy * GW + cx] := ST_UNKNOWN;
    end;
    Run := 100000;
    for cy := GH - 1 downto 0 do begin
      if GSt[cy * GW + cx] <> ST_OUT then Run := cy;
      if Run - cy <= M then Tmp[cy * GW + cx] := ST_UNKNOWN;
    end;
  end;
  for k := 0 to GW * GH - 1 do GSt[k] := Tmp[k];
end;

// zone + grid + an earlier scan; false = we do not stand in the zone
function ExInit(ZoneFile, GridFile: string; Cell: integer): boolean;
var i, cx, cy, X, Y, UX, UY, UZ: integer;
  ZoneOk: boolean;
begin
  result := false;
  GCell := Cell;
  if GCell <= 0 then GCell := EX_CELL;
  GridPath := Script.Path + '..\Nav\' + GridFile;
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  GZ := UZ;
  ZoneOk := false;
  if ZoneFile <> '' then begin
    ZoneOk := ExLoadOuter(Script.Path + '..\Zones\' + ZoneFile);
    if not ZoneOk then Engine.Msg('[Scan]', 'No zone file ' + ZoneFile + ', using the zone active in the bot', 128);
  end;
  if (ZoneOk and (not ExInScan(UX, UY))) or ((not ZoneOk) and (not ExActiveBox(UX, UY, UZ))) then begin
    Engine.Msg('[Scan]', 'Stand inside the zone first (no zone file: the zone active in the bot)', 255);
    exit;
  end;
  if not ZoneOk then
    Engine.Msg('[Scan]', 'Zone active in the bot: ' + IntToStr(BX0) + '..' + IntToStr(BX1) + ' x ' +
      IntToStr(BY0) + '..' + IntToStr(BY1), 128);
  GX0 := BX0 - GCell * 2;
  GY0 := BY0 - GCell * 2;
  GW := (BX1 - BX0) div GCell + 5;
  GH := (BY1 - BY0) div GCell + 5;
  SetLength(GSt, GW * GH);
  SetLength(GIn, GW * GH);
  SetLength(Prev, GW * GH);
  SetLength(Queue, GW * GH);
  for cy := 0 to GH - 1 do
    for cx := 0 to GW - 1 do begin
      X := GX0 + cx * GCell + GCell div 2;
      Y := GY0 + cy * GCell + GCell div 2;
      if ZoneOk then begin
        GIn[cy * GW + cx] := ExInOuter(X, Y);
        if GIn[cy * GW + cx] or ExInScan(X, Y) then GSt[cy * GW + cx] := ST_UNKNOWN
        else GSt[cy * GW + cx] := ST_OUT;
      end else begin
        GIn[cy * GW + cx] := Engine.InZone(X, Y, UZ);
        if GIn[cy * GW + cx] then GSt[cy * GW + cx] := ST_UNKNOWN else GSt[cy * GW + cx] := ST_OUT;
      end;
    end;
  if not ZoneOk then ExGrowActive();
  ExLoadOld();
  i := ExIdx(UX, UY);
  if i >= 0 then GSt[i] := ST_FREE;
  Engine.Msg('[Scan]', 'Scanning ' + IntToStr(GW) + 'x' + IntToStr(GH) + ' cells of ' + IntToStr(GCell) +
    ' into ' + GridPath, 128);
  result := true;
end;

procedure ExploreZone(ZoneFile, GridFile: string; Cell: integer);
var i, cx, X, Y, UX, UY, Target, Probes, nF, nW, nU, PX, PY, k: integer;
  DX, DY, L: double;
begin
  if not ExInit(ZoneFile, GridFile, Cell) then exit;
  Probes := 0;
  while not User.Dead do begin
    UX := User.X;
    UY := User.Y;
    i := ExIdx(UX, UY);
    if i < 0 then begin
      Engine.Msg('[Scan]', 'Out of the grid, stopped', 255);
      break;
    end;
    GSt[i] := ST_FREE;
    Target := ExFindFrontier(i);
    if Target < 0 then begin
      Engine.Msg('[Scan]', 'Done: every reachable cell of the zone is felt', 128);
      break;
    end;
    // to the free cell next to it, then straight into it and EX_PROBE cells on
    if (Prev[Target] >= 0) and (Prev[Target] <> i) then
      if not ExRunWay(Prev[Target]) then begin
        Inc(WayFails);
        if WayFails >= EX_WAY_TRIES then begin
          GSt[Target] := ST_WALL;      // cannot get next to it: give this cell up, go on with others
          WayFails := 0;
        end;
        continue;
      end;
    WayFails := 0;
    UX := User.X;
    UY := User.Y;
    PX := ExCX(Target);
    PY := ExCY(Target);
    DX := PX - UX;
    DY := PY - UY;
    L := Sqrt(DX * DX + DY * DY);
    if L < 1 then L := 1;
    // the probe ends at the zone border: never run out of the zone
    k := 0;
    while k < EX_PROBE do begin
      X := Round(PX + DX / L * GCell * (k + 1));
      Y := Round(PY + DY / L * GCell * (k + 1));
      cx := ExIdx(X, Y);
      if (cx < 0) or (GSt[cx] = ST_OUT) then break;
      Inc(k);
    end;
    X := Round(PX + DX / L * GCell * k);
    Y := Round(PY + DY / L * GCell * k);
    ExRun(X, Y);
    if GSt[Target] = ST_UNKNOWN then GSt[Target] := ST_WALL;   // could not get into it
    Inc(Probes);
    if Probes mod 25 = 0 then begin
      nF := 0; nW := 0; nU := 0;
      for k := 0 to GW * GH - 1 do
        if GSt[k] = ST_FREE then Inc(nF) else if GSt[k] = ST_WALL then Inc(nW) else if GSt[k] = ST_UNKNOWN then Inc(nU);
      Engine.Msg('[Scan]', IntToStr(Probes) + ' probes: free ' + IntToStr(nF) + ', walls ' + IntToStr(nW) +
        ', left ' + IntToStr(nU), 0);
    end;
    if GetTickCount - SavedAt > EX_SAVE_MS then ExSave();
  end;
  ExSave();
  Engine.Msg('[Scan]', 'Saved ' + GridPath, 128);
end;

// ===================== fast scan: rows and columns =====================

// a server path run order (mouse click: the server goes round obstacles)
procedure ExClick(X, Y: integer);
var UX, UY, UZ: integer;
begin
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  Engine.SendToServer('0F' + ExHex(X) + ExHex(Y) + ExHex(GZ) + ExHex(UX) + ExHex(UY) + ExHex(UZ) + ExHex(1));
end;

// server path run to the point, the way we run is written as free; true = got within EX_GO_NEAR
function ExGo(X, Y: integer): boolean;
var UX, UY, LX, LY, PX, PY, SX0, SY0: integer;
  Started, StillSince, LastSend, MaxMs: cardinal;
  DX, DY: double;
begin
  result := false;
  LX := User.X;
  LY := User.Y;
  SX0 := LX;
  SY0 := LY;
  PX := LX;
  PY := LY;
  DX := X - LX;
  DY := Y - LY;
  MaxMs := Round(Sqrt(DX * DX + DY * DY) * 10) + 4000;
  Started := GetTickCount;
  StillSince := GetTickCount;
  LastSend := 0;
  while not User.Dead do begin
    if (LastSend = 0) or (GetTickCount - LastSend >= 1500) then begin
      ExClick(X, Y);
      LastSend := GetTickCount;
    end;
    Delay(EX_TICK_MS);
    UX := User.X;
    UY := User.Y;
    ExMarkTrail(PX, PY, UX, UY);
    PX := UX;
    PY := UY;
    DX := X - UX;
    DY := Y - UY;
    if Sqrt(DX * DX + DY * DY) <= EX_GO_NEAR then begin
      result := true;
      exit;
    end;
    if (Abs(UX - LX) > 8) or (Abs(UY - LY) > 8) then begin
      LX := UX;
      LY := UY;
      StillSince := GetTickCount;
    end else if GetTickCount - StillSince > EX_GO_STALL then exit;
    // not a step from where we started: the server finds no way there
    if (GetTickCount - Started > EX_GO_DEAD) and (Abs(UX - SX0) <= 8) and (Abs(UY - SY0) <= 8) then exit;
    if GetTickCount - Started > MaxMs then exit;
  end;
end;

// along the line A -> B: straight runs (they feel the walls); stopped by an obstacle -> go round it by
// the server path to a point further along the line and run straight on from there
procedure ExLine(AX, AY, BX, BY: integer);
var UX, UY, PX, PY: integer;
  Len, T, T2, UXd, UYd, DX, DY: double;
begin
  DX := BX - AX;
  DY := BY - AY;
  Len := Sqrt(DX * DX + DY * DY);
  if Len < GCell then exit;
  UXd := DX / Len;
  UYd := DY / Len;
  T := 0;
  while (T < Len) and (not User.Dead) do begin
    PX := Round(AX + UXd * T);
    PY := Round(AY + UYd * T);
    if not ExGo(PX, PY) then begin
      T := T + EX_JUMP;                // inside an obstacle / no way: a bit further along
      continue;
    end;
    if ExRun(BX, BY) then exit;        // ran to the end of the line
    UX := User.X;                      // stopped by an obstacle: on past it
    UY := User.Y;
    T2 := (UX - AX) * UXd + (UY - AY) * UYd + EX_JUMP;
    if T2 > T + EX_JUMP then T := T2 else T := T + EX_JUMP;   // always forward, never the same spot again
  end;
end;

// the parts of the row / column at cell index Fixed inside the scan area, as cell index pairs
var SegA, SegB: array of integer;
  SegN: integer;
procedure ExSegments(Fixed: integer; Rows: boolean);
var k, n, St, Start: integer;
begin
  SegN := 0;
  if Rows then n := GW else n := GH;
  SetLength(SegA, n);
  SetLength(SegB, n);
  Start := -1;
  for k := 0 to n do begin
    St := ST_OUT;                      // rows go only through the zone itself, not its margin
    if k < n then
      if Rows then begin
        if GIn[Fixed * GW + k] then St := ST_UNKNOWN;
      end else if GIn[k * GW + Fixed] then St := ST_UNKNOWN;
    if (St <> ST_OUT) and (Start < 0) then Start := k;
    if ((St = ST_OUT) or (k = n)) and (Start >= 0) then begin
      if k - 1 - Start >= 2 then begin
        SegA[SegN] := Start;
        SegB[SegN] := k - 1;
        Inc(SegN);
      end;
      Start := -1;
    end;
  end;
end;

// cells of the segment not felt yet (a resumed scan skips done lines)
function ExSegUnknown(Fixed, A, B: integer; Rows: boolean): integer;
var k: integer;
begin
  result := 0;
  for k := A to B do
    if Rows then begin
      if GSt[Fixed * GW + k] = ST_UNKNOWN then Inc(result);
    end else if GSt[k * GW + Fixed] = ST_UNKNOWN then Inc(result);
end;

procedure ExSweep(Spacing: integer; Rows: boolean);
var Step, Fixed, n, j, Idx, Line, Lines, A, B, P1, P2, Q: integer;
  Back: boolean;
begin
  Step := Spacing div GCell;
  if Step < 1 then Step := 1;
  if Rows then n := GH else n := GW;
  Lines := n div Step;
  Line := 0;
  Back := false;
  Fixed := Step div 2;
  while (Fixed < n) and (not User.Dead) do begin
    Inc(Line);
    if Rows then Engine.Msg('[Scan]', 'Row ' + IntToStr(Line) + '/' + IntToStr(Lines), 0)
    else Engine.Msg('[Scan]', 'Column ' + IntToStr(Line) + '/' + IntToStr(Lines), 0);
    ExSegments(Fixed, Rows);
    for j := 0 to SegN - 1 do begin
      if Back then Idx := SegN - 1 - j else Idx := j;
      if ExSegUnknown(Fixed, SegA[Idx], SegB[Idx], Rows) = 0 then continue;
      if Back then begin
        A := SegB[Idx];
        B := SegA[Idx];
      end else begin
        A := SegA[Idx];
        B := SegB[Idx];
      end;
      if Rows then begin
        Q := GY0 + Fixed * GCell + GCell div 2;
        P1 := GX0 + A * GCell + GCell div 2;
        P2 := GX0 + B * GCell + GCell div 2;
        ExLine(P1, Q, P2, Q);
      end else begin
        Q := GX0 + Fixed * GCell + GCell div 2;
        P1 := GY0 + A * GCell + GCell div 2;
        P2 := GY0 + B * GCell + GCell div 2;
        ExLine(Q, P1, Q, P2);
      end;
    end;
    Back := not Back;                  // a snake: no run back to the start of every row
    ExSave();
    Fixed := Fixed + Step;
  end;
end;

procedure ExploreRows(ZoneFile, GridFile: string; Cell, Spacing: integer);
var Sp: integer;
begin
  if not ExInit(ZoneFile, GridFile, Cell) then exit;
  Sp := Spacing;
  if Sp <= 0 then Sp := 200;
  Engine.Msg('[Scan]', 'Fast scan: rows and columns every ' + IntToStr(Sp), 128);
  ExSweep(Sp, true);
  ExSweep(Sp, false);
  ExSave();
  Engine.Msg('[Scan]', 'Done. Saved ' + GridPath + ' - fill the rooms in nav_view.html', 128);
end;

end.
