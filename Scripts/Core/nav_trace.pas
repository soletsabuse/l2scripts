unit NavTrace;

// Wall trace recorder: you run along the walls and obstacles right up against them (slide along
// them), the script writes a point every Step of the run. Strokes = runs between pauses. In
// Library\Nav\nav_view.html the strokes become walls of a grid, rooms are filled with one click,
// the grid becomes a .zmap / .navgrid.
//
// Control - the PARTY chat menu (Core\chat_menu.pas, no party needed, only you see the answers):
//   #r  record (a new stroke)      #p  pause (the stroke ends)
//   #u  delete the last stroke     #s  status       #h  help
//   #f  this place is a perfect farm spot (round a corner)   #fu  delete the last farm spot
// Farm spots are saved as "F x y z" lines; spot_farm_pack_nav.pas takes them with SetFarmSpots and
// picks one that fits the pack (the mobs do not see it and come round the corner).
// Starts paused: run up to a wall, #r, slide along it, #p.
// Saved to Library\Nav\<FileName> every 2 s; a new start loads the file and adds new strokes.
//
//   uses NavTrace in 'Core\nav_trace.pas';
//   procedure OnCliPacket(ID1, ID2: Cardinal; Data: Pointer; Size: Word);
//   begin
//     TraceOnCliPacket(ID1, ID2, Data, Size);     // the party chat menu needs the chat packets
//   end;
//   begin
//     TraceRecord('CRUMA_1.navtrace', 12);
//   end.
//
// Shared library: scripts only call it, nobody edits it.

interface

uses SysUtils, Classes, ChatMenu in 'Core\chat_menu.pas';

// FileName in Library\Nav; Step = a point every so many units of the run (0 = 12)
procedure TraceRecord(FileName: string; Step: integer);
// forward the script's OnCliPacket here (the party chat menu)
procedure TraceOnCliPacket(ID1, ID2: Cardinal; Data: Pointer; Size: Word);

implementation

const
  TR_STEP     = 12;
  TR_TICK_MS  = 50;
  TR_JUMP     = 400;        // moved more than this in one tick = teleport: the stroke ends
  TR_SAVE_MS  = 2000;

var
  PX, PY: array of integer;       // all points in a row
  SStart, SZ: array of integer;   // stroke k = points SStart[k] .. SStart[k + 1] - 1, floor Z
  PN, SN: integer;
  FX, FY, FZ: array of integer;   // farm spots (#f)
  FN: integer;
  Dirty: boolean;
  TrPath: string;

procedure TraceOnCliPacket(ID1, ID2: Cardinal; Data: Pointer; Size: Word);
begin
  ChatMenuOnCliPacket(ID1, ID2, Data, Size);
end;

function TrField(S: string; k: integer): string;
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

procedure TrAddPoint(X, Y: integer);
begin
  if PN >= Length(PX) then begin
    SetLength(PX, PN * 2 + 1024);
    SetLength(PY, PN * 2 + 1024);
  end;
  PX[PN] := X;
  PY[PN] := Y;
  Inc(PN);
  SStart[SN] := PN;
  Dirty := true;
end;

procedure TrNewStroke(Z: integer);
begin
  if SN + 2 > Length(SStart) then begin
    SetLength(SStart, SN * 2 + 64);
    SetLength(SZ, SN * 2 + 64);
  end;
  SStart[SN] := PN;
  SZ[SN] := Z;
  Inc(SN);
  SStart[SN] := PN;
end;

// the open stroke ends; a stroke with less than 2 points is dropped
procedure TrEndStroke();
begin
  if SN = 0 then exit;
  SStart[SN] := PN;
  if PN - SStart[SN - 1] < 2 then begin
    PN := SStart[SN - 1];
    Dec(SN);
    SStart[SN] := PN;
  end;
end;

procedure TrDeleteLast();
begin
  if SN = 0 then exit;
  PN := SStart[SN - 1];
  Dec(SN);
  SStart[SN] := PN;
  Dirty := true;
end;

procedure TrAddSpot(X, Y, Z: integer);
begin
  if FN >= Length(FX) then begin
    SetLength(FX, FN + 16);
    SetLength(FY, FN + 16);
    SetLength(FZ, FN + 16);
  end;
  FX[FN] := X;
  FY[FN] := Y;
  FZ[FN] := Z;
  Inc(FN);
  Dirty := true;
end;

// file: "S z" = a new stroke on floor z, then "P x y" per point; "F x y z" = a farm spot
procedure TrLoad();
var L: TStringList;
  i: integer;
  S, K: string;
begin
  PN := 0;
  SN := 0;
  FN := 0;
  SetLength(SStart, 64);
  SetLength(SZ, 64);
  SStart[0] := 0;
  if not FileExists(TrPath) then exit;
  L := TStringList.Create;
  L.LoadFromFile(TrPath);
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    K := TrField(S, 0);
    if K = 'S' then begin
      TrEndStroke();
      TrNewStroke(StrToIntDef(TrField(S, 1), 0));
    end else if (K = 'P') and (SN > 0) then
      TrAddPoint(StrToIntDef(TrField(S, 1), 0), StrToIntDef(TrField(S, 2), 0))
    else if K = 'F' then
      TrAddSpot(StrToIntDef(TrField(S, 1), 0), StrToIntDef(TrField(S, 2), 0), StrToIntDef(TrField(S, 3), 0));
  end;
  TrEndStroke();
  L.Free;
  Dirty := false;
  Engine.Msg('[Trace]', 'Loaded ' + TrPath + ': ' + IntToStr(SN) + ' strokes, ' + IntToStr(PN) + ' points, ' +
    IntToStr(FN) + ' farm spots', 128);
end;

procedure TrSave();
var L: TStringList;
  k, i: integer;
begin
  L := TStringList.Create;
  L.Add('# navtrace: S z = new stroke on floor z, P x y = point');
  for k := 0 to SN - 1 do begin
    L.Add('S ' + IntToStr(SZ[k]));
    for i := SStart[k] to SStart[k + 1] - 1 do
      L.Add('P ' + IntToStr(PX[i]) + ' ' + IntToStr(PY[i]));
  end;
  for k := 0 to FN - 1 do
    L.Add('F ' + IntToStr(FX[k]) + ' ' + IntToStr(FY[k]) + ' ' + IntToStr(FZ[k]));
  try
    L.SaveToFile(TrPath);
    Dirty := false;
  except
    Engine.Msg('[Trace]', 'Could not write ' + TrPath, 255);
  end;
  L.Free;
end;

procedure TrSay(Text: string);
begin
  ChatSay(Text);
  Engine.Msg('[Trace]', Text, 0);
end;

procedure TrHelp();
begin
  TrSay('r = record, p = pause, u = delete last stroke, f = farm spot here, fu = delete last farm spot, ' +
    's = status, h = help');
end;

procedure TraceRecord(FileName: string; Step: integer);
var UX, UY, UZ, LX, LY, St, OX, OY: integer;
  Rec: boolean;
  SavedAt: cardinal;
  DX, DY: double;
  Cmd: string;
begin
  St := Step;
  if St <= 0 then St := TR_STEP;
  TrPath := Script.Path + '..\Nav\' + FileName;
  ChatMenuStart('Trace');
  ChatMenuWords('r rec p pause u undo f farm fu s status h help ?');
  TrLoad();
  Rec := false;
  SavedAt := GetTickCount;
  OX := User.X;
  OY := User.Y;
  LX := OX;
  LY := OY;
  TrSay('Paused. ' + IntToStr(SN) + ' strokes in ' + FileName + '. Write in the party chat:');
  TrHelp();
  while true do begin
    Delay(TR_TICK_MS);
    UX := User.X;
    UY := User.Y;
    UZ := User.Z;
    if (UX = 0) and (UY = 0) then continue;   // not in game
    Cmd := ChatCommand();
    if (Cmd = 'r') or (Cmd = 'rec') then begin
      if Rec then TrSay('Already recording stroke ' + IntToStr(SN))
      else begin
        Rec := true;
        TrNewStroke(UZ);
        TrAddPoint(UX, UY);
        LX := UX;
        LY := UY;
        TrSay('RECORDING stroke ' + IntToStr(SN));
      end;
    end else if (Cmd = 'p') or (Cmd = 'pause') then begin
      if not Rec then TrSay('Already paused')
      else begin
        Rec := false;
        TrEndStroke();
        Dirty := true;
        TrSay('PAUSE: ' + IntToStr(SN) + ' strokes, ' + IntToStr(PN) + ' points');
      end;
    end else if (Cmd = 'u') or (Cmd = 'undo') then begin
      if Rec then begin
        Rec := false;
        TrEndStroke();
      end;
      if SN = 0 then TrSay('No strokes to delete')
      else begin
        TrDeleteLast();
        TrSay('Last stroke DELETED, ' + IntToStr(SN) + ' left. Paused');
      end;
    end else if (Cmd = 'f') or (Cmd = 'farm') then begin
      TrAddSpot(UX, UY, UZ);
      TrSay('Farm spot ' + IntToStr(FN) + ' saved at ' + IntToStr(UX) + ', ' + IntToStr(UY));
    end else if Cmd = 'fu' then begin
      if FN = 0 then TrSay('No farm spots to delete')
      else begin
        Dec(FN);
        Dirty := true;
        TrSay('Farm spot ' + IntToStr(FN + 1) + ' DELETED, ' + IntToStr(FN) + ' left');
      end;
    end else if (Cmd = 's') or (Cmd = 'status') then begin
      if Rec then TrSay('Recording stroke ' + IntToStr(SN) + ': ' + IntToStr(PN) + ' points, ' + IntToStr(FN) + ' farm spots')
      else TrSay('Paused: ' + IntToStr(SN) + ' strokes, ' + IntToStr(PN) + ' points, ' + IntToStr(FN) + ' farm spots');
    end else if (Cmd = 'h') or (Cmd = 'help') or (Cmd = '?') then TrHelp()
    else if Cmd <> '' then TrSay('Unknown "' + Cmd + '". ');
    DX := UX - OX;
    DY := UY - OY;
    if Rec and (Sqrt(DX * DX + DY * DY) > TR_JUMP) then begin
      TrEndStroke();                   // teleport / death: a new stroke from here
      TrNewStroke(UZ);
      TrAddPoint(UX, UY);
      LX := UX;
      LY := UY;
    end;
    OX := UX;
    OY := UY;
    if Rec and (not User.Dead) then begin
      DX := UX - LX;
      DY := UY - LY;
      if Sqrt(DX * DX + DY * DY) >= St then begin
        TrAddPoint(UX, UY);
        LX := UX;
        LY := UY;
      end;
    end;
    if Dirty and (GetTickCount - SavedAt >= TR_SAVE_MS) then begin
      TrSave();
      SavedAt := GetTickCount;
    end;
  end;
end;

end.
