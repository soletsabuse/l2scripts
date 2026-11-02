unit DbgLog;

// Debug log to a file (Library\Logs\dbg_<name>_<time>_<part>.log): every decision of the pull / the fight /
// the rooms with its numbers, for looking at afterwards. Lines are kept in memory and written out every
// 2 s (DbgTick); a part over 4000 lines is closed and the next part starts. Off unless DbgStart.
// Library\Logs must exist (no folder functions in the script); cannot write there -> the scripts folder.
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
  DlDir, DlName: string;
  DlPart: integer;
  DlSavedAt: cardinal;
  DlMoved: boolean;                   // fell back to the scripts folder

function DbgOn(): boolean;
begin
  result := DlOn;
end;

procedure DbgStart(Name: string);
begin
  if DlOn then exit;
  DlDir := Script.Path + '..\Logs\';
  DlName := 'dbg_' + Name + '_' + FormatDateTime('mmdd_hhnnss', Now);
  DlPart := 1;
  DlMoved := false;
  DlLines := TStringList.Create;
  DlSavedAt := GetTickCount;
  DlOn := true;
  Engine.Msg('[Debug]', 'Debug log: ' + DlDir + DlName + '_1.log', 128);
end;

procedure DbgFlush();
var Ok: boolean;
begin
  if not DlOn then exit;
  Ok := true;
  try
    DlLines.SaveToFile(DlDir + DlName + '_' + IntToStr(DlPart) + '.log');
  except
    Ok := false;
  end;
  if (not Ok) and (not DlMoved) then begin   // no Library\Logs: the scripts folder
    DlMoved := true;
    DlDir := Script.Path;
    Engine.Msg('[Debug]', 'Cannot write to Library\Logs - debug log: ' + DlDir + DlName + '_' + IntToStr(DlPart) + '.log', 128);
    try
      DlLines.SaveToFile(DlDir + DlName + '_' + IntToStr(DlPart) + '.log');
    except
    end;
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
