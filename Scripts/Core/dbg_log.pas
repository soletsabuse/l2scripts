unit DbgLog;

// Debug log to a file (Library\Logs\dbg_<name>_<part>.log): every decision of the pull / the fight /
// the rooms with its numbers, for looking at afterwards. Lines are kept in memory and written out every
// 2 s (DbgTick); a part over 4000 lines is closed and the next part starts. Off unless DbgStart.
//
// Shared library: scripts only call it, nobody edits it.

interface

uses SysUtils, Classes;

procedure DbgStart(Name: string);             // on: the file name part (the character name)
function DbgOn(): boolean;
procedure Dbg(Tag, Text: string);             // one line: time, tag, text
procedure DbgTick();                          // call often: writes the lines out every 2 s
procedure DbgFlush();                         // write the lines out now

implementation

var
  DlOn: boolean;
  DlLines: TStringList;
  DlBase: string;
  DlPart: integer;
  DlSavedAt: cardinal;

function DbgOn(): boolean;
begin
  result := DlOn;
end;

procedure DbgStart(Name: string);
var Dir: string;
begin
  if DlOn then exit;
  Dir := Script.Path + '..\Logs\';
  try
    if not DirectoryExists(Dir) then ForceDirectories(Dir);
  except
  end;
  if not DirectoryExists(Dir) then Dir := Script.Path;
  DlBase := Dir + 'dbg_' + Name + '_' + FormatDateTime('mmdd_hhnnss', Now);
  DlPart := 1;
  DlLines := TStringList.Create;
  DlSavedAt := GetTickCount;
  DlOn := true;
  Engine.Msg('[Debug]', 'Debug log: ' + DlBase + '_1.log', 128);
end;

procedure DbgFlush();
begin
  if not DlOn then exit;
  try
    DlLines.SaveToFile(DlBase + '_' + IntToStr(DlPart) + '.log');
  except
  end;
  DlSavedAt := GetTickCount;
  if DlLines.Count > 4000 then begin   // this part is full: the next file
    DlLines.Clear;
    Inc(DlPart);
  end;
end;

procedure Dbg(Tag, Text: string);
begin
  if not DlOn then exit;
  DlLines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' ' + Tag + ' ' + Text);
end;

procedure DbgTick();
begin
  if not DlOn then exit;
  if GetTickCount - DlSavedAt >= 2000 then DbgFlush();
end;

end.
