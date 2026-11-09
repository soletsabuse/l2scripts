unit ChatMenu;

// Script menu in the PARTY chat, by packets only (Engine.Say does not work in this bot).
// You write in the party chat (#...), the script catches the outgoing chat packet: a command is NOT
// sent to the server, anything else goes out as usual. The script answers with fake party
// messages from MenuName - only your client sees them, no party needed.
// A command = a party message starting with "!" (#!rec), or one of the words given to
// ChatMenuWords written alone (#r).
//
// The bot gives packets only to the main script, so the script forwards them:
//   procedure OnCliPacket(ID1, ID2: Cardinal; Data: Pointer; Size: Word);
//   begin
//     ChatMenuOnCliPacket(ID1, ID2, Data, Size);
//   end;
//
// Shared library: scripts only call it, nobody edits it.

interface

uses SysUtils;

procedure ChatMenuStart(MenuName: string);     // packet hooks on, outgoing chat goes through us
procedure ChatMenuWords(Words: string);        // words that are commands without "!" ('r p u s')
procedure ChatMenuOnCliPacket(ID1, ID2: Cardinal; Data: Pointer; Size: Word);
procedure ChatSay(Text: string);               // a fake party message from MenuName (only we see it)
procedure ChatSayFrom(Name, Text: string);     // a fake party message from Name - no menu needed for it
function ChatCommand(): string;                // next command typed (lower case, no "!"); '' = none

implementation

const
  CM_PARTY = 3;               // chat type: party
  CM_QUEUE = 16;

var
  CmName: string;
  CmWords: string;            // ' r p u s ' - with spaces round every word
  CmQ: array[0..15] of string;
  CmHead, CmTail: integer;
  CmNext: integer;            // offset after the last string read (no var params)

function CmByte(Data: Pointer; Ofs: integer): integer;
var P: Pointer;
begin
  P := Data;
  Inc(Cardinal(P), Ofs);
  result := PByte(P)^;
end;

function CmHex(Data: Pointer; Size: integer): string;
var i: integer;
begin
  result := '';
  for i := 0 to Size - 1 do result := result + IntToHex(CmByte(Data, i), 2);
end;

// UTF-16 string ending with 0000 at Ofs
function CmStr(Data: Pointer; Ofs, Size: integer): string;
var c: integer;
begin
  result := '';
  CmNext := Ofs;
  while CmNext + 1 < Size do begin
    c := CmByte(Data, CmNext) or (CmByte(Data, CmNext + 1) shl 8);
    CmNext := CmNext + 2;
    if c = 0 then exit;
    result := result + Chr(c);
  end;
end;

// string -> UTF-16 hex + 0000 (Russian letters of a 1251 string become their Unicode codes)
function CmHexS(S: string): string;
var i, c: integer;
begin
  result := '';
  for i := 1 to Length(S) do begin
    c := Ord(S[i]);
    if (c >= 192) and (c <= 255) then c := $0410 + c - 192
    else if c = 168 then c := $0401
    else if c = 184 then c := $0451;
    result := result + IntToHex(c and $FF, 2) + IntToHex((c shr 8) and $FF, 2);
  end;
  result := result + '0000';
end;

function CmHexD(V: integer): string;
begin
  result := IntToHex(V and $FF, 2) + IntToHex((V shr 8) and $FF, 2) + IntToHex((V shr 16) and $FF, 2) +
            IntToHex((V shr 24) and $FF, 2);
end;

procedure ChatMenuStart(MenuName: string);
begin
  CmName := MenuName;
  if CmName = '' then CmName := 'Menu';
  Engine.SendActID(2);                                // packet hooks on
  Engine.BlockPacket($49, 0, False, Cardinal(-1));    // outgoing chat: we look at it, then send it on
end;

procedure ChatMenuWords(Words: string);
begin
  CmWords := ' ' + LowerCase(Trim(Words)) + ' ';
end;

// CreatureSay as this server sends it: objectId, chat type, name, -1, text
procedure ChatSayFrom(Name, Text: string);
begin
  Engine.SendToClient('4A' + CmHexD(0) + CmHexD(CM_PARTY) + CmHexS(Name) + CmHexD(-1) + CmHexS(Text));
end;

procedure ChatSay(Text: string);
begin
  ChatSayFrom(CmName, Text);
end;

procedure CmPush(Cmd: string);
begin
  if (CmTail + 1) mod CM_QUEUE = CmHead then exit;   // full: drop
  CmQ[CmTail] := Cmd;
  CmTail := (CmTail + 1) mod CM_QUEUE;
end;

function ChatCommand(): string;
begin
  result := '';
  if CmHead = CmTail then exit;
  result := CmQ[CmHead];
  CmHead := (CmHead + 1) mod CM_QUEUE;
end;

// outgoing chat (Say2 49: text, chat type, target): a command is kept, the rest goes out
procedure ChatMenuOnCliPacket(ID1, ID2: Cardinal; Data: Pointer; Size: Word);
var Text, Low: string;
  T: integer;
begin
  if ID1 <> $49 then exit;
  Text := CmStr(Data, 0, Size);
  T := -1;
  if CmNext + 3 < Size then
    T := CmByte(Data, CmNext) or (CmByte(Data, CmNext + 1) shl 8) or (CmByte(Data, CmNext + 2) shl 16) or
         (CmByte(Data, CmNext + 3) shl 24);
  Low := LowerCase(Trim(Text));
  if T = CM_PARTY then begin
    if (Length(Low) >= 2) and (Low[1] = '!') then begin
      CmPush(Trim(Copy(Low, 2, Length(Low))));
      exit;
    end;
    if (Low <> '') and (Pos(' ' + Low + ' ', CmWords) > 0) then begin
      CmPush(Low);
      exit;
    end;
  end;
  Engine.SendToServer('49' + CmHex(Data, Size));      // not ours: out as it was
end;

end.
