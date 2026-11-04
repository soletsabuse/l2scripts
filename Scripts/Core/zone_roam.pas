unit ZoneRoam;

// Running round a zone with no points given. The zone active in the bot is cut into cells; a cell is
// "seen" when we pass within RM_SEE of it. RoamNext gives the nearest cell of the zone not seen for
// RM_AGAIN_MS (all seen lately -> the one seen longest ago): running there one after another sweeps
// the whole zone and later comes back to the old places. The caller runs there in short steps,
// calls RoamSeen on the way and stops for its own reasons (a mob in sight...); a point it cannot
// reach (a wall, no way) -> RoamFailed, that place is skipped for a while.
//
//   uses ZoneRoam in 'Core\zone_roam.pas';
//   if RoamNext() then <run to RoamX(), RoamY() calling RoamSeen(); stuck -> RoamFailed()>
//
// The first RoamNext must be made inside the zone: its box is felt round us with Engine.InZone.
// The cells are flat: the point is at our own height (a zone of one floor).
//
// Shared library: scripts only call it, nobody edits it.

interface

uses SysUtils;

function RoamNext(): boolean;      // the next point to run to (RoamX, RoamY); false = we do not stand in a bot zone
function RoamX(): integer;
function RoamY(): integer;
procedure RoamSeen();              // call on the way: the cells round us are seen now
procedure RoamFailed();            // the point of RoamNext cannot be reached: its place is skipped for a while

implementation

const
  RM_CELL     = 500;         // cell size
  RM_SEE      = 1500;        // cells this close to us count as seen (mobs are seen farther anyway)
  RM_AGAIN_MS = 120000;      // a seen cell is worth a run again after this
  RM_FAIL_R   = 700;         // RoamFailed: cells this close to the point count as seen
  RM_RING     = 400;         // the zone's box is felt with InZone on rings this far apart ...
  RM_RING_MAX = 20000;       // ... at most this far from us

var
  RmReady: boolean;
  RmX0, RmY0, RmW, RmH: integer;
  RmIn: array of boolean;        // the cell centre is in the zone
  RmSeenAt: array of cardinal;   // when the cell was seen last (0 = never)
  RmTX, RmTY: integer;           // the point of the last RoamNext

function RmCX(i: integer): integer;
begin
  result := RmX0 + (i mod RmW) * RM_CELL + RM_CELL div 2;
end;

function RmCY(i: integer): integer;
begin
  result := RmY0 + (i div RmW) * RM_CELL + RM_CELL div 2;
end;

// the zone's box (rings round us, like nav_explore) and its cells; false = we do not stand in a zone
function RmBuild(): boolean;
var UX, UY, UZ, R, Far, k, n, X, Y, Side, BX0, BY0, BX1, BY1, i: integer;
  Any: boolean;
begin
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  result := Engine.InZone(UX, UY, UZ);
  if not result then exit;
  BX0 := UX; BX1 := UX; BY0 := UY; BY1 := UY;
  Far := 0;
  R := RM_RING;
  while R <= RM_RING_MAX do begin
    Any := false;
    n := (2 * R) div RM_RING;
    for Side := 0 to 3 do
      for k := 0 to n - 1 do begin
        if Side = 0 then begin X := UX - R + k * RM_RING; Y := UY - R; end
        else if Side = 1 then begin X := UX + R; Y := UY - R + k * RM_RING; end
        else if Side = 2 then begin X := UX + R - k * RM_RING; Y := UY + R; end
        else begin X := UX - R; Y := UY + R - k * RM_RING; end;
        if Engine.InZone(X, Y, UZ) then begin
          Any := true;
          if X < BX0 then BX0 := X;
          if X > BX1 then BX1 := X;
          if Y < BY0 then BY0 := Y;
          if Y > BY1 then BY1 := Y;
        end;
      end;
    if Any then Far := R
    else if R > Far + RM_RING * 2 then break;   // two empty rings past the last zone point: done
    R := R + RM_RING;
  end;
  RmX0 := BX0 - RM_RING;
  RmY0 := BY0 - RM_RING;
  RmW := (BX1 + RM_RING - RmX0) div RM_CELL + 1;
  RmH := (BY1 + RM_RING - RmY0) div RM_CELL + 1;
  SetLength(RmIn, RmW * RmH);
  SetLength(RmSeenAt, RmW * RmH);
  n := 0;
  for i := 0 to RmW * RmH - 1 do begin
    RmIn[i] := Engine.InZone(RmCX(i), RmCY(i), UZ);
    RmSeenAt[i] := 0;
    if RmIn[i] then Inc(n);
  end;
  RmReady := true;
  Engine.Msg('[Roam]', 'Zone ' + IntToStr(RmW * RM_CELL) + ' x ' + IntToStr(RmH * RM_CELL) + ', ' +
    IntToStr(n) + ' cells to run round', 0);
end;

// the cells within R of the point are seen now
procedure RmMark(X, Y, R: integer);
var cx0, cx1, cy0, cy1, cx, cy, i: integer;
  T: cardinal;
  DX, DY: double;
begin
  if not RmReady then exit;
  T := GetTickCount;
  if T = 0 then T := 1;
  cx0 := (X - R - RmX0) div RM_CELL;
  cx1 := (X + R - RmX0) div RM_CELL;
  cy0 := (Y - R - RmY0) div RM_CELL;
  cy1 := (Y + R - RmY0) div RM_CELL;
  if cx0 < 0 then cx0 := 0;
  if cy0 < 0 then cy0 := 0;
  if cx1 > RmW - 1 then cx1 := RmW - 1;
  if cy1 > RmH - 1 then cy1 := RmH - 1;
  for cy := cy0 to cy1 do
    for cx := cx0 to cx1 do begin
      i := cy * RmW + cx;
      DX := RmCX(i) - X;
      DY := RmCY(i) - Y;
      if DX * DX + DY * DY <= 1.0 * R * R then RmSeenAt[i] := T;
    end;
end;

function RoamNext(): boolean;
var i, Best, Old, UX, UY: integer;
  T, Age, OldAge: cardinal;
  D, BestD, DX, DY: double;
begin
  if not RmReady then RmBuild();
  result := RmReady;
  if not result then exit;
  UX := User.X;
  UY := User.Y;
  RmMark(UX, UY, RM_SEE);
  T := GetTickCount;
  Best := -1;
  BestD := 0;
  Old := -1;
  OldAge := 0;
  for i := 0 to RmW * RmH - 1 do begin
    if not RmIn[i] then continue;
    if (RmSeenAt[i] <> 0) and (T - RmSeenAt[i] < RM_AGAIN_MS) then begin
      Age := T - RmSeenAt[i];          // seen lately: only if nothing else is left, the oldest
      if (Old < 0) or (Age > OldAge) then begin
        Old := i;
        OldAge := Age;
      end;
      continue;
    end;
    DX := RmCX(i) - UX;
    DY := RmCY(i) - UY;
    D := DX * DX + DY * DY;
    if (Best < 0) or (D < BestD) then begin
      Best := i;
      BestD := D;
    end;
  end;
  if Best < 0 then Best := Old;
  if Best < 0 then begin   // no cell in the zone at all
    result := false;
    exit;
  end;
  RmTX := RmCX(Best);
  RmTY := RmCY(Best);
end;

function RoamX(): integer;
begin
  result := RmTX;
end;

function RoamY(): integer;
begin
  result := RmTY;
end;

procedure RoamSeen();
var UX, UY: integer;
begin
  UX := User.X;
  UY := User.Y;
  RmMark(UX, UY, RM_SEE);
end;

procedure RoamFailed();
begin
  RmMark(RmTX, RmTY, RM_FAIL_R);
end;

end.
