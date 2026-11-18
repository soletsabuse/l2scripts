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
// the same, split for a script whose main loop builds strings: the hook only copies the chat packet as numbers
// (PaxScript strings made in two threads at once crash the script: "Access violation ... read of address 4"),
// the main loop reads it and sends the chat on (ChatMenuPoll, every tick, before ChatCommand):
//   procedure OnCliPacket(...); begin ChatMenuOnCliPacketRaw(ID1, ID2, Data, Size); end;
procedure ChatMenuOnCliPacketRaw(ID1, ID2: Cardinal; Data: Pointer; Size: Word);
procedure ChatMenuPoll();
procedure ChatSay(Text: string);               // a fake party message from MenuName (only we see it)
procedure ChatSayFrom(Name, Text: string);     // a fake party message from Name - no menu needed for it
// a fake message of any chat type from Name (only we see it): 3 party, 15 the command channel commander (the
// client shows it in the middle of the screen - as the siege commander's), 19 a screen announce, 18 a red announce
procedure ChatSayType(ChatType: integer; Name, Text: string);
function ChatCommand(): string;                // next command typed (lower case, no "!"); '' = none

implementation

const
  CM_PARTY = 3;               // chat type: party
  CM_QUEUE = 16;
  CM_RAW_N = 8;               // ChatMenuOnCliPacketRaw: chat packets waiting for the main loop ...
  CM_RAW_B = 640;             // ... bytes of each (a chat packet is far shorter)

var
  CmName: string;
  CmWords: string;            // ' r p u s ' - with spaces round every word
  CmQ: array[0..15] of string;
  CmHead, CmTail: integer;
  CmNext: integer;            // offset after the last string read (no var params)
  CmRawLen: array[0..7] of integer;        // ChatMenuOnCliPacketRaw: the chat packets as numbers
  CmRawByte: array[0..5119] of integer;    // packet i: CmRawByte[i * CM_RAW_B + b]
  CmRawHead, CmRawTail: integer;

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

procedure ChatSayType(ChatType: integer; Name, Text: string);
begin
  Engine.SendToClient('4A' + CmHexD(0) + CmHexD(ChatType) + CmHexS(Name) + CmHexD(-1) + CmHexS(Text));
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

// the hook (the packet thread): the outgoing chat packet copied as numbers, nothing else (no strings here)
procedure ChatMenuOnCliPacketRaw(ID1, ID2: Cardinal; Data: Pointer; Size: Word);
var i, n, b: integer;
  P: Pointer;
begin
  if ID1 <> $49 then exit;
  if CmRawHead - CmRawTail >= CM_RAW_N then exit;    // 8 waiting already: this one is lost (never so fast by hand)
  n := Size;
  if n > CM_RAW_B then exit;                         // not a chat packet we can hold: lost
  i := CmRawHead mod CM_RAW_N;
  for b := 0 to n - 1 do begin
    P := Data;
    Inc(Cardinal(P), b);
    CmRawByte[i * CM_RAW_B + b] := PByte(P)^;
  end;
  CmRawLen[i] := n;
  CmRawHead := CmRawHead + 1;
end;

// the main loop: the chat packets the hook took - a command is kept, the rest goes out as it was
procedure ChatMenuPoll();
var i, n, b, c, p, T, Base: integer;
  Text, Low, H: string;
begin
  while CmRawTail < CmRawHead do begin
    i := CmRawTail mod CM_RAW_N;
    n := CmRawLen[i];
    Base := i * CM_RAW_B;
    Text := '';                                      // UTF-16 text up to 0000
    p := 0;
    while p + 1 < n do begin
      c := CmRawByte[Base + p] or (CmRawByte[Base + p + 1] shl 8);
      p := p + 2;
      if c = 0 then break;
      Text := Text + Chr(c);
    end;
    T := -1;                                         // the chat type after it
    if p + 3 < n then
      T := CmRawByte[Base + p] or (CmRawByte[Base + p + 1] shl 8) or (CmRawByte[Base + p + 2] shl 16) or
           (CmRawByte[Base + p + 3] shl 24);
    Low := LowerCase(Trim(Text));
    if (T = CM_PARTY) and (Length(Low) >= 2) and (Low[1] = '!') then CmPush(Trim(Copy(Low, 2, Length(Low))))
    else if (T = CM_PARTY) and (Low <> '') and (Pos(' ' + Low + ' ', CmWords) > 0) then CmPush(Low)
    else begin
      H := '';
      for b := 0 to n - 1 do H := H + IntToHex(CmRawByte[Base + b], 2);
      Engine.SendToServer('49' + H);                 // not ours: out as it was
    end;
    CmRawTail := CmRawTail + 1;
  end;
end;

end.
