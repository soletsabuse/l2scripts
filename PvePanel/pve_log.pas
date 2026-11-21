unit PveLog;

// PvePanel: the debug log of pve.txt and of its map runs (pve_nav.pas) - Library\PvePanel\Logs\pve_<nick>_<time>_<part>.log.
// Lines are kept in memory and written out every 2 s (LogTick); a part over 4000 lines is closed, the next part starts.
// Off unless LogStart. The Logs folder is made by PvePanel.exe; cannot write there -> next to pve.txt.

interface

uses SysUtils, Classes;

procedure LogStart(Nick: string);            // on: the file name part (the character)
procedure LogStop();                         // off (what is kept is written out first)
function LogOn(): boolean;
procedure LogLine(Tag, Text: string);        // one line: time, tag, text
procedure LogTick();                         // call often: writes the lines out every 2 s
procedure LogFlush();                        // write the lines out now
function LogFile(): string;                  // the file written now ('' = off)

implementation

var
  PlOn: boolean;
  PlLines: TStringList;
  PlDir, PlName: string;
  PlPart: integer;
  PlSavedAt: cardinal;
  PlMoved: boolean;

function LogOn(): boolean;
begin
  result := PlOn;
end;

function LogFile(): string;
begin
  result := '';
  if PlOn then result := PlDir + PlName + '_' + IntToStr(PlPart) + '.log';
end;

procedure LogStart(Nick: string);
begin
  if PlOn then exit;
  PlDir := Script.Path + 'Logs\';
  PlName := 'pve_' + Nick + '_' + FormatDateTime('mmdd_hhnnss', Now);
  PlPart := 1;
  PlMoved := false;
  if PlLines = nil then PlLines := TStringList.Create;
  PlLines.Clear;
  PlSavedAt := GetTickCount;
  PlOn := true;
end;

procedure LogFlush();
var Ok: boolean;
begin
  if not PlOn then exit;
  Ok := true;
  try
    PlLines.SaveToFile(PlDir + PlName + '_' + IntToStr(PlPart) + '.log');
  except
    Ok := false;
  end;
  if (not Ok) and (not PlMoved) then begin
    PlMoved := true;
    PlDir := Script.Path;
    try
      PlLines.SaveToFile(PlDir + PlName + '_' + IntToStr(PlPart) + '.log');
    except
    end;
  end;
  PlSavedAt := GetTickCount;
  if PlLines.Count > 4000 then begin
    PlLines.Clear;
    Inc(PlPart);
  end;
end;

procedure LogStop();
begin
  if not PlOn then exit;
  LogFlush();
  PlOn := false;
end;

procedure LogLine(Tag, Text: string);
begin
  if not PlOn then exit;
  PlLines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' ' + Tag + ' ' + Text);
end;

procedure LogTick();
begin
  if not PlOn then exit;
  if GetTickCount - PlSavedAt >= 2000 then LogFlush();
end;

end.
