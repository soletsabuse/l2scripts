unit BypassMon;

{ ---------------------------------------------------------------------------
  Монитор байпасов.

  - Из пакетов сервера вытаскивает HTML-страницы (ComBoard, диалоги NPC и т.д.),
    все ссылки "bypass ..." / "link ..." с подписями кнопок и ищет
    подозрительное: невидимые кнопки, ссылки в HTML-комментариях, повторы кодов.
  - Каждый байпас от клиента (пакет 23) сверяет со страницами:
    была ли такая кнопка на последней показанной странице, как она подписана,
    через сколько мс после показа страницы её нажали.
  - По желанию собирает текстовые строки из любых пакетов клиента.
  Работает в потоке формы (вызывается из FlushPending).
  --------------------------------------------------------------------------- }

interface

uses
  SysUtils, Classes, Types, DateUtils, Generics.Collections, RegularExpressions;

type
  TBpKind = (bkPage, bkBypass, bkString);

  TBpLink = record
    Code: string;       // первое слово команды (без -h)
    Full: string;       // команда целиком, как в странице
    Caption: string;    // подпись кнопки / текст ссылки
    Kind: string;       // кнопка / ссылка / вне тегов
    Suspect: string;    // замечание, если что-то не так
  end;

  TBpPage = record
    Num: Integer;
    Time: TDateTime;
    PacketID: string;
    Text: string;
    Links: TArray<TBpLink>;
    EntryIndex: Integer;
  end;

  TBpEntry = record
    Num: Integer;
    Time: TDateTime;
    Kind: TBpKind;
    PacketID: string;
    Text: string;
    Caption: string;
    Check: string;
    DelayMs: Integer;
    Note: string;
    Detail: string;
    Suspicious: Boolean;
  end;

procedure BpProcess(Num: Integer; Time: TDateTime; FromClient: Boolean;
  const PacketID: string; ID1: Byte; const Data: TBytes; AllClientStrings: Boolean);
function BpCount: Integer;
function BpGet(Index: Integer): TBpEntry;
procedure BpClear;
function BpSummary: string;
procedure BpSaveToFile(const FileName: string);

implementation

const
  MAX_PAGES = 300;

var
  Pages: TList<TBpPage>;
  Entries: TList<TBpEntry>;
  CntPages, CntBypass, CntStrings, CntSuspect: Integer;

{ --- утилиты --- }

function BytesPosB(const Sub: array of Byte; const Data: TBytes): Boolean;
var
  i, j, LS, LD: Integer;
begin
  Result := False;
  LS := Length(Sub);
  LD := Length(Data);
  for i := 0 to LD - LS do
  begin
    j := 0;
    while (j < LS) and (Data[i + j] = Sub[j]) do Inc(j);
    if j = LS then Exit(True);
  end;
end;

// декодируем UTF-16LE с двух чётностей (строка может начинаться с любого байта)
function DecodeBoth(const B: TBytes): string;
var
  Off, N: Integer;
begin
  Result := '';
  for Off := 1 to 2 do
  begin
    N := (Length(B) - Off) div 2;
    if N > 0 then
      Result := Result + TEncoding.Unicode.GetString(B, Off, N * 2) + #0#0;
  end;
end;

// все печатные UTF-16 строки длиной >= MinLen
function ExtractStrings(const B: TBytes; MinLen: Integer): TArray<string>;
var
  Off, i, n: Integer;
  W: Word;
  Cur: string;
  L: TList<string>;
begin
  L := TList<string>.Create;
  try
    for Off := 1 to 2 do
    begin
      Cur := '';
      i := Off;
      while i + 1 < Length(B) do
      begin
        W := B[i] or (Word(B[i + 1]) shl 8);
        if (W >= 32) and (W < $FFFE) and not ((W >= $D800) and (W <= $DFFF)) then
          Cur := Cur + Char(W)
        else
        begin
          if (Length(Cur) >= MinLen) and not L.Contains(Cur) then L.Add(Cur);
          Cur := '';
        end;
        Inc(i, 2);
      end;
      if (Length(Cur) >= MinLen) and not L.Contains(Cur) then L.Add(Cur);
    end;
    // отбрасываем мусор: строки, где мало букв/цифр
    SetLength(Result, 0);
    n := 0;
    for Cur in L do
      if Cur.Trim <> '' then
      begin
        SetLength(Result, n + 1);
        Result[n] := Cur;
        Inc(n);
      end;
  finally
    L.Free;
  end;
end;

function FirstWord(const S: string): string;
var
  T: string;
  P: Integer;
begin
  T := Trim(S);
  if T.StartsWith('-h ', True) then T := Trim(Copy(T, 4, MaxInt));
  P := Pos(' ', T);
  if P > 0 then Result := Copy(T, 1, P - 1) else Result := T;
end;

function StripTags(const S: string): string;
begin
  Result := Trim(TRegEx.Replace(S, '<[^>]*>', ''));
  Result := TRegEx.Replace(Result, '\s+', ' ');
end;

function AttrInt(const Tag, Name: string): Integer;
var
  M: TMatch;
begin
  M := TRegEx.Match(Tag, Name + '\s*=\s*"?(\d+)', [roIgnoreCase]);
  if M.Success then Result := StrToIntDef(M.Groups[1].Value, -1) else Result := -1;
end;

function AttrStr(const Tag, Name: string; out Found: Boolean): string;
var
  M: TMatch;
begin
  M := TRegEx.Match(Tag, Name + '\s*=\s*"([^"]*)"', [roIgnoreCase]);
  Found := M.Success;
  if Found then Result := M.Groups[1].Value
  else
  begin
    M := TRegEx.Match(Tag, Name + '\s*=\s*([^\s>]+)', [roIgnoreCase]);
    Found := M.Success;
    if Found then Result := M.Groups[1].Value else Result := '';
  end;
end;

function IsObfuscated(const Code: string): Boolean;
begin
  Result := TRegEx.IsMatch(Code, '^[0-9a-fA-F]{3,}$');
end;

function IsClientBuiltin(const Code: string): Boolean;
begin
  // вкладки ComBoard и прочие команды, которые клиент шлёт сам (Alt+B и т.п.)
  Result := Code.StartsWith('_bbs', True) or Code.StartsWith('_maillist', True) or
            Code.StartsWith('_friend', True);
end;

{ --- разбор страницы --- }

function ParseLinks(const Text: string): TArray<TBpLink>;
var
  M: TMatch;
  Comments: TArray<TPoint>;
  CM: TMatch;
  i, n, TagStart, TagEnd, W, H, CloseA: Integer;
  Tag, Val: string;
  L: TBpLink;
  HasVal, HasFore: Boolean;
  Seen: TDictionary<string, Integer>;
begin
  SetLength(Result, 0);
  // HTML-комментарии
  n := 0;
  for CM in TRegEx.Matches(Text, '<!--.*?-->', [roSingleLine]) do
  begin
    SetLength(Comments, n + 1);
    Comments[n] := Point(CM.Index, CM.Index + CM.Length);
    Inc(n);
  end;

  Seen := TDictionary<string, Integer>.Create;
  try
    n := 0;
    for M in TRegEx.Matches(Text, '\b(bypass|link)\s+((?:-h\s+)?[^"''<>\x00]+?)\s*(?=["''>]|\x00|$)', [roIgnoreCase]) do
    begin
      L.Full := Trim(M.Groups[2].Value);
      L.Code := FirstWord(L.Full);
      if L.Code = '' then Continue;
      if M.Groups[1].Value.ToLower = 'link' then L.Code := 'link ' + L.Code;
      L.Caption := '';
      L.Kind := 'вне тегов';
      L.Suspect := '';

      // в каком теге находится
      TagStart := Text.LastIndexOf('<', M.Index - 1);   // 0-based
      TagEnd := Text.IndexOf('>', M.Index - 1);
      if (TagStart >= 0) and (TagEnd > TagStart) and (Text.LastIndexOf('>', M.Index - 1) < TagStart) then
      begin
        Tag := Text.Substring(TagStart, TagEnd - TagStart + 1);
        if Tag.StartsWith('<button', True) then
        begin
          L.Kind := 'кнопка';
          Val := AttrStr(Tag, 'value', HasVal);
          L.Caption := Trim(Val);
          AttrStr(Tag, 'fore', HasFore);
          W := AttrInt(Tag, 'width');
          H := AttrInt(Tag, 'height');
          if ((W >= 0) and (W < 5)) or ((H >= 0) and (H < 5)) then
            L.Suspect := Format('кнопка размером %dx%d - не видна', [W, H])
          else if (L.Caption = '') and not HasFore then
            L.Suspect := 'кнопка без подписи и без картинки';
          if (L.Caption = '') and HasFore then
            L.Caption := '(картинка)';
        end
        else if Tag.StartsWith('<a', True) then
        begin
          L.Kind := 'ссылка';
          CloseA := Text.IndexOf('</a>', TagEnd, Length(Text) - TagEnd);
          if CloseA < 0 then CloseA := Text.IndexOf('</A>', TagEnd, Length(Text) - TagEnd);
          if CloseA > TagEnd then
            L.Caption := StripTags(Text.Substring(TagEnd + 1, CloseA - TagEnd - 1));
          if L.Caption = '' then L.Suspect := 'ссылка без текста - не видна';
        end
        else
          L.Kind := 'тег ' + Copy(Tag, 1, 12);
      end;

      for i := 0 to High(Comments) do
        if (M.Index >= Comments[i].X) and (M.Index <= Comments[i].Y) then
          L.Suspect := 'внутри HTML-комментария - на экране не видна';

      if Seen.ContainsKey(L.Code) then
      begin
        if L.Suspect = '' then L.Suspect := 'код повторяется на странице';
      end
      else
        Seen.Add(L.Code, n);

      SetLength(Result, n + 1);
      Result[n] := L;
      Inc(n);
    end;
  finally
    Seen.Free;
  end;
end;

function PageDetail(const P: TBpPage): string;
var
  SB: TStringBuilder;
  L: TBpLink;
  i, Obf, Sus: Integer;
begin
  SB := TStringBuilder.Create;
  try
    Obf := 0;
    Sus := 0;
    for L in P.Links do
    begin
      if IsObfuscated(L.Code) then Inc(Obf);
      if L.Suspect <> '' then Inc(Sus);
    end;
    SB.AppendLine(Format('Страница #%d  пакет %s  %s', [P.Num, P.PacketID, FormatDateTime('hh:nn:ss.zzz', P.Time)]));
    SB.AppendLine(Format('Ссылок: %d, из них закодированных: %d, подозрительных: %d', [Length(P.Links), Obf, Sus]));
    SB.AppendLine('');
    for i := 0 to High(P.Links) do
    begin
      L := P.Links[i];
      SB.Append(Format('%3d. %-32s -> %-14s [%s]', [i + 1, Copy(L.Caption, 1, 32), L.Full, L.Kind]));
      if L.Suspect <> '' then SB.Append('   !!! ' + L.Suspect);
      SB.AppendLine;
    end;
    SB.AppendLine('');
    SB.AppendLine('---- текст страницы ----');
    SB.Append(StringReplace(P.Text, #0, ' ', [rfReplaceAll]));
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

procedure AddEntry(var E: TBpEntry);
begin
  if E.Suspicious then Inc(CntSuspect);
  Entries.Add(E);
end;

procedure ProcessServerPage(Num: Integer; Time: TDateTime; const PacketID: string; const Data: TBytes);
var
  Text: string;
  Links: TArray<TBpLink>;
  P: TBpPage;
  E: TBpEntry;
  L: TBpLink;
  i, Sus: Integer;
  Merge: Boolean;
begin
  Text := DecodeBoth(Data);
  if (Pos('bypass', LowerCase(Text)) = 0) and (Pos('<html', LowerCase(Text)) = 0) then Exit;
  Links := ParseLinks(Text);

  // части одной страницы (ComBoard шлёт 101/102/103) склеиваем
  Merge := False;
  if Pages.Count > 0 then
    Merge := (Pages[Pages.Count - 1].PacketID = PacketID) and
             (MilliSecondsBetween(Time, Pages[Pages.Count - 1].Time) <= 100);
  if Merge then
  begin
    P := Pages[Pages.Count - 1];
    P.Text := P.Text + Text;
    i := Length(P.Links);
    SetLength(P.Links, i + Length(Links));
    for L in Links do
    begin
      P.Links[i] := L;
      Inc(i);
    end;
    Pages[Pages.Count - 1] := P;
  end
  else
  begin
    P.Num := Num;
    P.Time := Time;
    P.PacketID := PacketID;
    P.Text := Text;
    P.Links := Links;
    P.EntryIndex := Entries.Count;
    Inc(CntPages);
    E := Default(TBpEntry);
    E.Num := Num;
    E.Time := Time;
    E.Kind := bkPage;
    E.PacketID := PacketID;
    E.DelayMs := -1;
    AddEntry(E);
    Pages.Add(P);
    if Pages.Count > MAX_PAGES then Pages.Delete(0);
  end;

  // обновляем запись страницы
  E := Entries[P.EntryIndex];
  Sus := 0;
  for L in P.Links do
    if L.Suspect <> '' then Inc(Sus);
  E.Text := Format('страница: %d ссылок', [Length(P.Links)]);
  if Sus > 0 then
  begin
    if not E.Suspicious then Inc(CntSuspect);
    E.Suspicious := True;
    E.Note := Format('подозрительных ссылок: %d', [Sus]);
  end;
  E.Detail := PageDetail(P);
  Entries[P.EntryIndex] := E;
end;

procedure ProcessClientBypass(Num: Integer; Time: TDateTime; const PacketID: string; const Cmd: string);
var
  E: TBpEntry;
  Code: string;
  i, j: Integer;
  P: TBpPage;
  Found: Boolean;
  SB: TStringBuilder;
begin
  E := Default(TBpEntry);
  E.Num := Num;
  E.Time := Time;
  E.Kind := bkBypass;
  E.PacketID := PacketID;
  E.Text := Cmd;
  E.DelayMs := -1;
  Code := FirstWord(Cmd);
  Inc(CntBypass);

  Found := False;
  SB := TStringBuilder.Create;
  try
    SB.AppendLine('Байпас от клиента: "' + Cmd + '"');
    SB.AppendLine('');
    for i := Pages.Count - 1 downto 0 do
    begin
      P := Pages[i];
      if P.Time > Time then Continue;
      for j := 0 to High(P.Links) do
        if SameText(P.Links[j].Code, Code) then
        begin
          Found := True;
          E.Caption := P.Links[j].Caption;
          E.DelayMs := Integer(MilliSecondsBetween(Time, P.Time));
          if i = Pages.Count - 1 then
            E.Check := 'есть на последней странице'
          else
          begin
            E.Check := Format('только на старой странице #%d', [P.Num]);
            E.Note := 'код со страницы, которая уже сменилась';
            E.Suspicious := True;
          end;
          if P.Links[j].Suspect <> '' then
          begin
            E.Note := 'НАЖАТА НЕВИДИМАЯ ССЫЛКА: ' + P.Links[j].Suspect;
            E.Suspicious := True;
          end;
          SB.AppendLine(Format('Найдена на странице #%d (%s), кнопка "%s" [%s]',
            [P.Num, FormatDateTime('hh:nn:ss.zzz', P.Time), P.Links[j].Caption, P.Links[j].Kind]));
          SB.AppendLine(Format('Нажата через %d мс после показа страницы', [E.DelayMs]));
          Break;
        end;
      if Found then Break;
    end;

    if not Found then
    begin
      if IsClientBuiltin(Code) then
        E.Check := 'встроенная команда клиента'
      else
      begin
        E.Check := 'НЕТ ни на одной странице';
        E.Note := 'такой кнопки сервер не показывал';
        E.Suspicious := True;
      end;
      SB.AppendLine('На полученных страницах такой команды нет.');
    end
    else if (E.DelayMs >= 0) and (E.DelayMs < 150) then
    begin
      E.Suspicious := True;
      if E.Note = '' then E.Note := Format('нажата слишком быстро: %d мс после показа', [E.DelayMs]);
    end;
    E.Detail := SB.ToString;
  finally
    SB.Free;
  end;
  AddEntry(E);
end;

procedure ProcessClientStrings(Num: Integer; Time: TDateTime; const PacketID: string; const Data: TBytes);
var
  Strs: TArray<string>;
  E: TBpEntry;
begin
  Strs := ExtractStrings(Data, 3);
  if Length(Strs) = 0 then Exit;
  E := Default(TBpEntry);
  E.Num := Num;
  E.Time := Time;
  E.Kind := bkString;
  E.PacketID := PacketID;
  E.Text := string.Join(' | ', Strs);
  E.DelayMs := -1;
  E.Detail := 'Текстовые строки в пакете клиента ' + PacketID + ':' + sLineBreak + string.Join(sLineBreak, Strs);
  Inc(CntStrings);
  AddEntry(E);
end;

{ --- интерфейс --- }

procedure BpProcess(Num: Integer; Time: TDateTime; FromClient: Boolean;
  const PacketID: string; ID1: Byte; const Data: TBytes; AllClientStrings: Boolean);
const
  PatYpass: array[0..9] of Byte = (Ord('y'), 0, Ord('p'), 0, Ord('a'), 0, Ord('s'), 0, Ord('s'), 0);
  PatTml: array[0..5] of Byte = (Ord('t'), 0, Ord('m'), 0, Ord('l'), 0);
  PatTmlU: array[0..5] of Byte = (Ord('T'), 0, Ord('M'), 0, Ord('L'), 0);
var
  Cmd: string;
  N: Integer;
begin
  if Length(Data) < 2 then Exit;
  if FromClient then
  begin
    if (ID1 = $23) and (PacketID = '23') then
    begin
      // RequestBypassToServer: строка UTF-16 сразу после ID
      N := (Length(Data) - 1) div 2;
      Cmd := TEncoding.Unicode.GetString(Data, 1, N * 2);
      if Pos(#0, Cmd) > 0 then Cmd := Copy(Cmd, 1, Pos(#0, Cmd) - 1);
      ProcessClientBypass(Num, Time, PacketID, Cmd);
    end
    else if AllClientStrings then
      ProcessClientStrings(Num, Time, PacketID, Data);
  end
  else
  begin
    if BytesPosB(PatYpass, Data) or BytesPosB(PatTml, Data) or BytesPosB(PatTmlU, Data) then
      ProcessServerPage(Num, Time, PacketID, Data);
  end;
end;

function BpCount: Integer;
begin
  Result := Entries.Count;
end;

function BpGet(Index: Integer): TBpEntry;
begin
  Result := Entries[Index];
end;

procedure BpClear;
begin
  Pages.Clear;
  Entries.Clear;
  CntPages := 0;
  CntBypass := 0;
  CntStrings := 0;
  CntSuspect := 0;
end;

function BpSummary: string;
begin
  Result := Format('Страниц с HTML: %d   |   байпасов от клиента: %d   |   строк из других пакетов: %d   |   ПОДОЗРИТЕЛЬНЫХ: %d',
    [CntPages, CntBypass, CntStrings, CntSuspect]);
end;

procedure BpSaveToFile(const FileName: string);
var
  SL: TStringList;
  E: TBpEntry;
  KindS, DelayS: string;
begin
  SL := TStringList.Create;
  try
    SL.Add('# ' + BpSummary);
    for E in Entries do
    begin
      case E.Kind of
        bkPage: KindS := 'СТРАНИЦА';
        bkBypass: KindS := 'БАЙПАС';
      else
        KindS := 'СТРОКА';
      end;
      if E.DelayMs >= 0 then DelayS := IntToStr(E.DelayMs) + ' мс' else DelayS := '';
      SL.Add('');
      SL.Add(Format('==== #%d %s %s пакет %s  %s  %s  %s  %s', [E.Num, FormatDateTime('hh:nn:ss.zzz', E.Time),
        KindS, E.PacketID, E.Text, E.Check, DelayS, E.Note]));
      SL.Add(E.Detail);
    end;
    SL.SaveToFile(FileName, TEncoding.UTF8);
  finally
    SL.Free;
  end;
end;

initialization
  Pages := TList<TBpPage>.Create;
  Entries := TList<TBpEntry>.Create;

finalization
  Entries.Free;
  Pages.Free;

end.
