unit Unit1;

{ ---------------------------------------------------------------------------
  Packet Sniffer для L2 Adrenaline (на основе plugin 2.4).
  Только сниффер: плагин ничего не отправляет на сервер, кроме вызова sendactID
  (включение перехвата исходящих), который выбирается в окне.

  Формат пакета, как в скрипте разработчика:
    ID2 = 0  ->  ID1(1 байт) + Data
    ID2 <> 0 ->  ID1(1 байт) + ID2(2 байта) + Data
  Перехват исходящих (C->S) включается через Engine.SendActID(1) (или 2).
  --------------------------------------------------------------------------- }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Menus, Graphics, Clipbrd, SyncObjs, Math,
  ShellAPI, Generics.Collections, Generics.Defaults, PluginAPI, BypassMon;

const
  WM_PluginShow = WM_USER + 5402;
  ver = 'Packet Sniffer 1.1';
  MAX_PACKETS = 300000;      // сколько пакетов держим в памяти
  HEX_PREVIEW = 200;         // сколько байт показывать в колонке "Данные"

type
  TPacketDir = (pdServer, pdClient);   // pdServer: S->C, pdClient: C->S

  TPacket = record
    Num: Integer;
    Time: TDateTime;
    Dir: TPacketDir;
    ID1: Byte;
    ID2: Word;
    HasID2: Boolean;
    Mode: ShortInt;        // режим sendactID на момент захвата (-1 = не вызывался)
    Data: TBytes;          // полный пакет: ID1 [+ ID2] + тело
  end;

  TIdRule = record
    ID1: Byte;
    AnyID2: Boolean;
    ID2: Word;
  end;

  TStatRec = record
    Key: Cardinal;
    Dir: TPacketDir;
    ID1: Byte;
    HasID2: Boolean;
    ID2: Word;
    Count: Integer;
    Bytes: Int64;
    Last: TDateTime;
    ModeCnt: array[0..3] of Integer;   // по режимам: 0, 1, 2, без вызова
  end;

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FPackets: TList<TPacket>;
    FView: TList<Integer>;                       // индексы FPackets, прошедшие фильтр
    FStats: TDictionary<Cardinal, TStatRec>;
    FNextNum: Integer;
    FInclude, FExclude: TArray<TIdRule>;
    FSearch1, FSearch2: TBytes;
    FShowS2C, FShowC2S: Boolean;
    FFilterDirty: Boolean;
    FFilterChangeTick: Cardinal;
    FActApplied: Boolean;
    FFirstShown: Boolean;
    FEngineGreeted: Boolean;
    FInfoTick: Cardinal;
    FCur: TPacket;
    FHasCur: Boolean;

    pnlTop: TPanel;
    btnCapture, btnClear, btnSave, btnCopy, btnOpenLogs: TButton;
    chkS2C, chkC2S, chkAutoScroll: TCheckBox;
    cbOutMode: TComboBox;
    edtInclude, edtExclude, edtSearch: TEdit;
    Pages: TPageControl;
    tsPackets, tsStats: TTabSheet;
    lvPackets: TListView;
    splDetail: TSplitter;
    pnlDetail: TPanel;
    mmoInfo: TMemo;            // the selected packet, decoded
    lvStats: TListView;
    StatusBar: TStatusBar;
    Timer: TTimer;
    pmPackets, pmStats: TPopupMenu;

    // вкладка "Байпасы"
    tsBypass: TTabSheet;
    lvBypass: TListView;
    mmoBypass: TMemo;
    lblBypass: TLabel;
    chkBpAll: TCheckBox;
    FBpShown: Integer;

    procedure ShowPugin(var Msg: TMessage); message WM_PluginShow;

    // построение интерфейса
    procedure BuildUI;
    procedure BuildBypassTab;
    procedure SyncBypass;
    procedure lvBypassData(Sender: TObject; Item: TListItem);
    procedure lvBypassSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure lvBypassCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnBpClearClick(Sender: TObject);
    procedure btnBpSaveClick(Sender: TObject);
    function AddButton(AParent: TWinControl; X, Y, W: Integer; const ACaption: string; AOnClick: TNotifyEvent): TButton;
    function AddCheck(AParent: TWinControl; X, Y, W: Integer; const ACaption: string; AChecked: Boolean): TCheckBox;
    function AddLabel(AParent: TWinControl; X, Y: Integer; const ACaption: string): TLabel;
    function AddEdit(AParent: TWinControl; X, Y, W: Integer; const AHint: string): TEdit;
    procedure AddColumn(LV: TListView; const ACaption: string; AWidth: Integer);
    function AddMenuItem(Menu: TPopupMenu; const ACaption: string; AOnClick: TNotifyEvent): TMenuItem;

    // данные
    procedure FlushPending;
    procedure AddStat(const P: TPacket);
    function Matches(const P: TPacket): Boolean;
    procedure ApplyFilter;
    procedure RebuildView;
    procedure SyncListCount;
    procedure TrimPackets;
    procedure ShowPacket(ViewIndex: Integer);
    procedure RefreshStats;
    procedure UpdateStatus;
    procedure UpdateGameInfo;
    procedure ApplyActMode;
    function SelectedViewIndexes: TList<Integer>;
    function CurrentIdText: string;
    procedure AddIdToEdit(Edit: TEdit; const IdText: string);
    function LogsDir: string;

    // события
    procedure TimerTimer(Sender: TObject);
    procedure FilterChanged(Sender: TObject);
    procedure btnCaptureClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnOpenLogsClick(Sender: TObject);
    procedure cbOutModeChange(Sender: TObject);
    procedure lvPacketsData(Sender: TObject; Item: TListItem);
    procedure lvPacketsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure lvPacketsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvPacketsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PagesChange(Sender: TObject);
    procedure btnStatsRefreshClick(Sender: TObject);
    procedure lvStatsDblClick(Sender: TObject);
    procedure miCopyHexClick(Sender: TObject);
    procedure miCopyLinesClick(Sender: TObject);
    procedure miHideIdClick(Sender: TObject);
    procedure miOnlyIdClick(Sender: TObject);
    procedure miResetFiltersClick(Sender: TObject);
    procedure miStatHideClick(Sender: TObject);
    procedure miStatOnlyClick(Sender: TObject);
  public
  end;

var
  Form1: TForm1;
  _PluginProc: function(Code: Cardinal; p1, p2, p3: widestring): widestring; stdcall;
  Engine: IL2Control;
  CaptureEnabled: Boolean = True;
  CurActMode: Integer = -1;   // последний вызванный sendactID

// вызывается из OnPacket / OnCliPacket (поток бота)
procedure SnifferPush(Dir: TPacketDir; ID1, ID2: Cardinal; Data: Pointer; Size: Word);

implementation

{$R *.dfm}

var
  PendingLock: TCriticalSection;
  PendingList: TList<TPacket>;

{ ---------------------------------------------------------------------------
  Вспомогательные функции
  --------------------------------------------------------------------------- }

procedure SnifferPush(Dir: TPacketDir; ID1, ID2: Cardinal; Data: Pointer; Size: Word);
var
  P: TPacket;
  Hdr: Integer;
begin
  if not CaptureEnabled then Exit;
  P.Num := 0;
  P.Time := Now;
  P.Dir := Dir;
  P.ID1 := Byte(ID1);
  P.ID2 := Word(ID2);
  P.HasID2 := ID2 <> 0;
  P.Mode := CurActMode;
  if P.HasID2 then Hdr := 3 else Hdr := 1;
  SetLength(P.Data, Hdr + Size);
  P.Data[0] := Byte(ID1);
  if P.HasID2 then
  begin
    // как memtohex(ID2, 2) в скрипте: младший байт первым
    P.Data[1] := Byte(ID2);
    P.Data[2] := Byte(ID2 shr 8);
  end;
  if (Size > 0) and (Data <> nil) then
    Move(Data^, P.Data[Hdr], Size);
  PendingLock.Enter;
  try
    PendingList.Add(P);
  finally
    PendingLock.Leave;
  end;
end;

function BytesToHex(const B: TBytes; MaxLen: Integer = -1; Sep: Boolean = False): string;
const
  HexAlf: array[0..15] of Char = '0123456789ABCDEF';
var
  i, N, Step, Pos: Integer;
begin
  N := Length(B);
  if (MaxLen >= 0) and (N > MaxLen) then N := MaxLen;
  if Sep then Step := 3 else Step := 2;
  SetLength(Result, N * Step);
  Pos := 1;
  for i := 0 to N - 1 do
  begin
    Result[Pos] := HexAlf[B[i] shr 4];
    Result[Pos + 1] := HexAlf[B[i] and $F];
    if Sep then Result[Pos + 2] := ' ';
    Inc(Pos, Step);
  end;
  if Sep and (N > 0) then SetLength(Result, Length(Result) - 1);
end;

function CleanHex(const S: string; out Valid: Boolean): string;
var
  C: Char;
  SB: TStringBuilder;
begin
  Valid := True;
  SB := TStringBuilder.Create;
  try
    for C in S do
      case C of
        '0'..'9', 'A'..'F': SB.Append(C);
        'a'..'f': SB.Append(Char(Ord(C) - 32));
        ' ', #9, '-', ',': ;
      else
        Valid := False;
      end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

function HexToBytes(const Hex: string): TBytes;
var
  i: Integer;
begin
  SetLength(Result, Length(Hex) div 2);
  for i := 0 to Length(Result) - 1 do
    Result[i] := StrToInt('$' + Copy(Hex, i * 2 + 1, 2));
end;

function BytesPos(const Sub, Data: TBytes): Integer;
var
  i, j, LS, LD: Integer;
begin
  Result := -1;
  LS := Length(Sub);
  LD := Length(Data);
  if (LS = 0) or (LS > LD) then Exit;
  for i := 0 to LD - LS do
  begin
    j := 0;
    while (j < LS) and (Data[i + j] = Sub[j]) do Inc(j);
    if j = LS then Exit(i);
  end;
end;

function IdText(ID1: Byte; HasID2: Boolean; ID2: Word): string;
begin
  if HasID2 then
    Result := Format('%.2X:%.4X', [ID1, ID2])
  else
    Result := Format('%.2X', [ID1]);
end;

function PacketIdText(const P: TPacket): string;
begin
  Result := IdText(P.ID1, P.HasID2, P.ID2);
end;

function DirText(Dir: TPacketDir): string;
begin
  if Dir = pdServer then Result := 'S>C' else Result := 'C>S';
end;

function ModeText(M: Integer): string;
begin
  if M < 0 then Result := '-' else Result := IntToStr(M);
end;

function ModeIdx(M: Integer): Integer;
begin
  if (M >= 0) and (M <= 2) then Result := M else Result := 3;
end;

function PacketLine(const P: TPacket): string;
begin
  // режим - последней колонкой, чтобы старые разборщики логов не ломались
  Result := Format('%d'#9'%s'#9'%s'#9'%s'#9'%d'#9'%s'#9'%s',
    [P.Num, FormatDateTime('hh:nn:ss.zzz', P.Time), DirText(P.Dir),
     PacketIdText(P), Length(P.Data), BytesToHex(P.Data), ModeText(P.Mode)]);
end;

function HexDump(const B: TBytes): string;
var
  SB: TStringBuilder;
  i, j, Len: Integer;
  C: Byte;
begin
  // формат строки: "0000  XX XX ... XX  ascii"
  // колонки: 0..3 смещение, 6..53 hex (по 3 символа), 55..70 ascii
  SB := TStringBuilder.Create;
  try
    Len := Length(B);
    i := 0;
    while i < Len do
    begin
      SB.Append(IntToHex(i, 4)).Append('  ');
      for j := 0 to 15 do
        if i + j < Len then
          SB.Append(IntToHex(B[i + j], 2)).Append(' ')
        else
          SB.Append('   ');
      SB.Append(' ');
      for j := 0 to 15 do
        if i + j < Len then
        begin
          C := B[i + j];
          if (C >= 32) and (C < 127) then SB.Append(Char(C)) else SB.Append('.');
        end;
      SB.AppendLine;
      Inc(i, 16);
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

{ ---------------------------------------------------------------------------
  Packet names and fields (this server: protocol 140; what was seen and checked in the logs).
  A spec is a list of fields "name:type" split by spaces. Types:
    c byte, h word, d int32, u uint32 (hex), o object id (hex + what it is),
    p a point x y z (3 x int32), q int64, s UTF-16 string,
    *a:t,b:t,...  a group of fields repeated (the last number read) times.
  A name ending with "?" is the usual L2 name of this id, not checked on this server.
  --------------------------------------------------------------------------- }

type
  TPkDef = record
    Client: Boolean;      // C>S
    ID1: Byte;
    HasID2: Boolean;
    ID2: Word;
    Name: string;
    Spec: string;
  end;

  TPkField = record
    Name: string;
    Text: string;
  end;

var
  PkDefs: TList<TPkDef>;
  PkObj: TDictionary<Cardinal, string>;    // object id -> what it is (npc 21026 ...)
  PkMyOid: Cardinal;

procedure PkAdd(Client: Boolean; const Id, Name, Spec: string);
var
  D: TPkDef;
  p: Integer;
begin
  D.Client := Client;
  p := Pos(':', Id);
  if p > 0 then
  begin
    D.ID1 := StrToInt('$' + Copy(Id, 1, p - 1));
    D.HasID2 := True;
    D.ID2 := StrToInt('$' + Copy(Id, p + 1, 4));
  end
  else
  begin
    D.ID1 := StrToInt('$' + Id);
    D.HasID2 := False;
    D.ID2 := 0;
  end;
  D.Name := Name;
  D.Spec := Spec;
  PkDefs.Add(D);
end;

procedure PkInit;
begin
  PkDefs := TList<TPkDef>.Create;
  PkObj := TDictionary<Cardinal, string>.Create;
  // ----- C>S (the client) -----
  PkAdd(True, '0F', 'MoveToLocation (бег)', 'to:p from:p mode:d');
  PkAdd(True, '59', 'ValidatePosition', 'pos:p heading:d vehicle:d flag:c');
  PkAdd(True, '1F', 'Action (клик по объекту)', 'target:o me:p shift:c');
  PkAdd(True, '39', 'MagicSkillUse (каст)', 'skill:d ctrl:d shift:c');
  PkAdd(True, 'D0:00FE', 'NextTarget (Tab)', 'target:o flag:h');
  PkAdd(True, 'B1', 'NetPing?', 'id:u ping:d mtu:d');
  PkAdd(True, '01', 'AttackRequest?', 'target:o me:p shift:c');
  PkAdd(True, '19', 'UseItem?', 'item:o ctrl:d');
  PkAdd(True, '48', 'RequestTargetCancel?', 'unselect:h');
  // ----- S>C (the server) -----
  PkAdd(False, '2F', 'MoveToLocation', 'obj:o to:p from:p');
  PkAdd(False, '47', 'StopMove', 'obj:o pos:p heading:d');
  PkAdd(False, '79', 'ValidateLocation', 'obj:o pos:p heading:d');
  PkAdd(False, '22', 'TeleportToLocation', 'obj:o pos:p');
  PkAdd(False, '48', 'MagicSkillUse', 'type:d caster:o target:o skill:d level:d hitTime:d');
  PkAdd(False, 'B9', 'MyTargetSelected', 'flag:d target:o levelDiff:h');
  PkAdd(False, '85', 'AbnormalStatusUpdate (бафы)', 'count:h *skill:d,level:d,type:d,left:h');
  PkAdd(False, '62', 'SystemMessage', 'msg:h');
  PkAdd(False, '08', 'DeleteObject', 'obj:o flag:d');
  PkAdd(False, '0C', 'NpcInfo', '');                  // decoded by hand (PkNpcInfo)
  PkAdd(False, '32', 'UserInfo', 'obj:o');
  PkAdd(False, '31', 'CharInfo?', '');
  PkAdd(False, '4A', 'CreatureSay (чат)', 'obj:o type:d name:s npcstr:d text:s');
  PkAdd(False, '25', 'AutoAttackStart?', 'obj:o');
  PkAdd(False, '26', 'AutoAttackStop?', 'obj:o');
  PkAdd(False, '1F', 'ActionFailed?', '');
  PkAdd(False, '05', 'SpawnItem?', 'obj:o item:d pos:p');
  PkAdd(False, '16', 'DropItem?', 'dropper:o obj:o item:d pos:p');
  PkAdd(False, '17', 'GetItem?', 'player:o obj:o pos:p');
  PkAdd(False, '21', 'InventoryUpdate?', '');
  PkAdd(False, '11', 'ItemList?', '');
  PkAdd(False, '00', 'Die?', 'obj:o');
  PkAdd(False, '01', 'Revive?', 'obj:o');
  PkAdd(False, '18', 'StatusUpdate?', 'obj:o');
  PkAdd(False, '33', 'Attack?', 'attacker:o target:o');
  PkAdd(False, 'D9', 'NetPing?', 'id:u');
end;

function PkFind(Client: Boolean; ID1: Byte; HasID2: Boolean; ID2: Word; out D: TPkDef): Boolean;
var
  i: Integer;
begin
  for i := 0 to PkDefs.Count - 1 do
  begin
    D := PkDefs[i];
    if (D.Client = Client) and (D.ID1 = ID1) and (D.HasID2 = HasID2) and ((not HasID2) or (D.ID2 = ID2)) then
      Exit(True);
  end;
  Result := False;
end;

function PkNameOf(Client: Boolean; ID1: Byte; HasID2: Boolean; ID2: Word): string;
var
  D: TPkDef;
begin
  if PkFind(Client, ID1, HasID2, ID2, D) then Result := D.Name else Result := '';
end;

function PkName(const P: TPacket): string;
begin
  Result := PkNameOf(P.Dir = pdClient, P.ID1, P.HasID2, P.ID2);
end;

function PkI32(const B: TBytes; Off: Integer): Integer;
begin
  Result := Integer(Cardinal(B[Off]) or (Cardinal(B[Off + 1]) shl 8) or
    (Cardinal(B[Off + 2]) shl 16) or (Cardinal(B[Off + 3]) shl 24));
end;

function PkObjText(V: Cardinal): string;
var
  S: string;
begin
  Result := IntToHex(V, 8);
  if (PkMyOid <> 0) and (V = PkMyOid) then
    Result := Result + ' (я)'
  else if PkObj.TryGetValue(V, S) then
    Result := Result + ' (' + S + ')';
end;

// what the packets tell about the objects: my id (UserInfo), the npcs (NpcInfo), the ones taken away
procedure PkLearn(const P: TPacket);
var
  Oid: Cardinal;
begin
  if (P.Dir <> pdServer) or P.HasID2 then Exit;
  if (P.ID1 = $32) and (Length(P.Data) >= 5) then
    PkMyOid := Cardinal(PkI32(P.Data, 1))
  else if (P.ID1 = $0C) and (Length(P.Data) >= 37) then
  begin
    Oid := Cardinal(PkI32(P.Data, 1));
    if PkObj.Count > 200000 then PkObj.Clear;
    PkObj.AddOrSetValue(Oid, 'npc ' + IntToStr(PkI32(P.Data, 21) - 1000000));
  end;
end;

procedure PkAddField(L: TList<TPkField>; const N, T: string);
var
  F: TPkField;
begin
  F.Name := N;
  F.Text := T;
  L.Add(F);
end;

// one field at Off (moved on); False - the packet ended
function PkReadField(const B: TBytes; var Off: Integer; const Tok: string; L: TList<TPkField>;
  var LastNum: Integer; const Prefix: string): Boolean;
var
  N, T, S: string;
  p, Len: Integer;
  W: Word;
begin
  Result := False;
  Len := Length(B);
  p := Pos(':', Tok);
  if p < 1 then Exit;
  N := Prefix + Copy(Tok, 1, p - 1);
  T := Copy(Tok, p + 1, MaxInt);
  if T = 'c' then
  begin
    if Off + 1 > Len then Exit;
    LastNum := B[Off];
    PkAddField(L, N, IntToStr(B[Off]));
    Inc(Off, 1);
  end
  else if T = 'h' then
  begin
    if Off + 2 > Len then Exit;
    LastNum := B[Off] or (B[Off + 1] shl 8);
    PkAddField(L, N, IntToStr(LastNum));
    Inc(Off, 2);
  end
  else if T = 'd' then
  begin
    if Off + 4 > Len then Exit;
    LastNum := PkI32(B, Off);
    PkAddField(L, N, IntToStr(LastNum));
    Inc(Off, 4);
  end
  else if T = 'u' then
  begin
    if Off + 4 > Len then Exit;
    PkAddField(L, N, '$' + IntToHex(Cardinal(PkI32(B, Off)), 8));
    Inc(Off, 4);
  end
  else if T = 'o' then
  begin
    if Off + 4 > Len then Exit;
    PkAddField(L, N, PkObjText(Cardinal(PkI32(B, Off))));
    Inc(Off, 4);
  end
  else if T = 'p' then
  begin
    if Off + 12 > Len then Exit;
    PkAddField(L, N, Format('%d, %d, %d', [PkI32(B, Off), PkI32(B, Off + 4), PkI32(B, Off + 8)]));
    Inc(Off, 12);
  end
  else if T = 'q' then
  begin
    if Off + 8 > Len then Exit;
    PkAddField(L, N, IntToStr(PInt64(@B[Off])^));
    Inc(Off, 8);
  end
  else if T = 's' then
  begin
    S := '';
    while True do
    begin
      if Off + 2 > Len then Exit;
      W := B[Off] or (B[Off + 1] shl 8);
      Inc(Off, 2);
      if W = 0 then Break;
      S := S + Char(W);
    end;
    PkAddField(L, N, '"' + S + '"');
  end
  else
    Exit;
  Result := True;
end;

// NpcInfo of this server (mask-based): object @1, npc id @21 (+1000000), x y z @25, heading @37,
// the state byte 3 before the end (04 targetable, 08 the name shown, 01 in a fight, 02 dead)
procedure PkNpcInfo(const B: TBytes; L: TList<TPkField>; out Used: Integer);
var
  St: Integer;
  S: string;
begin
  Used := 1;
  if Length(B) < 41 then Exit;
  PkAddField(L, 'obj', PkObjText(Cardinal(PkI32(B, 1))));
  PkAddField(L, 'npc', IntToStr(PkI32(B, 21) - 1000000));
  PkAddField(L, 'pos', Format('%d, %d, %d', [PkI32(B, 25), PkI32(B, 29), PkI32(B, 33)]));
  PkAddField(L, 'heading', IntToStr(PkI32(B, 37)));
  St := B[Length(B) - 3];
  S := '';
  if (St and 1) <> 0 then S := S + ' в бою';
  if (St and 2) <> 0 then S := S + ' мёртв';
  if (St and 4) <> 0 then S := S + ' таргетится';
  if (St and 8) <> 0 then S := S + ' имя';
  PkAddField(L, 'state', '$' + IntToHex(St, 2) + S);
  Used := Length(B);
end;

// the fields of a packet by its spec; Used - how many bytes they took (from the start, ids included)
function PkDecode(const P: TPacket; out Name: string; out Used: Integer): TList<TPkField>;
var
  D: TPkDef;
  Toks, Sub: TArray<string>;
  i, j, k, n, LastNum, Off, Hdr: Integer;
  DX, DY: Double;
  Ok: Boolean;
begin
  Result := TList<TPkField>.Create;
  if P.HasID2 then Hdr := 3 else Hdr := 1;
  Used := Hdr;
  Name := '';
  if not PkFind(P.Dir = pdClient, P.ID1, P.HasID2, P.ID2, D) then Exit;
  Name := D.Name;
  if (P.Dir = pdServer) and (not P.HasID2) and (P.ID1 = $0C) then
  begin
    PkNpcInfo(P.Data, Result, Used);
    Exit;
  end;
  if D.Spec = '' then Exit;
  Off := Hdr;
  LastNum := 0;
  Ok := True;
  Toks := D.Spec.Split([' ']);
  for i := 0 to High(Toks) do
  begin
    if Toks[i] = '' then Continue;
    if Toks[i][1] = '*' then
    begin
      // a group: its fields LastNum times
      Sub := Copy(Toks[i], 2, MaxInt).Split([',']);
      n := LastNum;
      if (n < 0) or (n > 1000) then n := 0;
      for k := 1 to n do
      begin
        for j := 0 to High(Sub) do
          if not PkReadField(P.Data, Off, Sub[j], Result, LastNum, Format('[%d] ', [k])) then
          begin
            Ok := False;
            Break;
          end;
        if not Ok then Break;
      end;
    end
    else if not PkReadField(P.Data, Off, Toks[i], Result, LastNum, '') then
      Ok := False;
    if not Ok then Break;
  end;
  Used := Off;
  // a click to run: how far and how much down
  if Ok and (P.Dir = pdClient) and (not P.HasID2) and (P.ID1 = $0F) and (Length(P.Data) >= 25) then
  begin
    DX := PkI32(P.Data, 1) - PkI32(P.Data, 13);
    DY := PkI32(P.Data, 5) - PkI32(P.Data, 17);
    PkAddField(Result, 'distance', IntToStr(Round(Sqrt(DX * DX + DY * DY))));
    PkAddField(Result, 'dz', IntToStr(PkI32(P.Data, 9) - PkI32(P.Data, 21)));
  end;
end;

// one line for the list: the fields, or the body as hex for an unknown packet
function PkSummary(const P: TPacket): string;
var
  L: TList<TPkField>;
  Name: string;
  Used, i: Integer;
  SB: TStringBuilder;
  Rest: TBytes;
begin
  L := PkDecode(P, Name, Used);
  SB := TStringBuilder.Create;
  try
    for i := 0 to L.Count - 1 do
    begin
      if i > 0 then SB.Append('   ');
      SB.Append(L[i].Name).Append(' ').Append(L[i].Text);
      if SB.Length > 400 then
      begin
        SB.Append(' ...');
        Break;
      end;
    end;
    if (L.Count = 0) or ((Used < Length(P.Data)) and (SB.Length < 400) and (Name = '')) then
    begin
      Rest := Copy(P.Data, Used, 120);
      if SB.Length > 0 then SB.Append('   ');
      SB.Append(BytesToHex(Rest, -1, True));
      if Length(P.Data) - Used > 120 then SB.Append(' ...');
    end;
    Result := SB.ToString;
  finally
    SB.Free;
    L.Free;
  end;
end;

// the bottom window: the header, a field per line, what is left undecoded, the hex
function PkDetails(const P: TPacket): string;
var
  L: TList<TPkField>;
  Name: string;
  Used, i, W: Integer;
  SB: TStringBuilder;
begin
  L := PkDecode(P, Name, Used);
  SB := TStringBuilder.Create;
  try
    if Name = '' then Name := 'неизвестный пакет';
    SB.AppendLine(Format('#%d   %s   %s   %s   %s', [P.Num, FormatDateTime('hh:nn:ss.zzz', P.Time),
      DirText(P.Dir), PacketIdText(P), Name]));
    SB.AppendLine(Format('размер %d байт   режим перехвата %s', [Length(P.Data), ModeText(P.Mode)]));
    SB.AppendLine('');
    W := 8;
    for i := 0 to L.Count - 1 do
      if Length(L[i].Name) > W then W := Length(L[i].Name);
    for i := 0 to L.Count - 1 do
      SB.AppendLine('  ' + L[i].Name + StringOfChar(' ', W - Length(L[i].Name) + 3) + L[i].Text);
    if L.Count = 0 then SB.AppendLine('  (поля этого пакета не разобраны)');
    if Used < Length(P.Data) then
    begin
      SB.AppendLine('');
      SB.AppendLine(Format('  не разобрано: %d байт с @%d', [Length(P.Data) - Used, Used]));
    end;
    SB.AppendLine('');
    SB.AppendLine('HEX:');
    SB.Append(HexDump(P.Data));
    Result := SB.ToString;
  finally
    SB.Free;
    L.Free;
  end;
end;

function ParseRules(const S: string; out Ok: Boolean): TArray<TIdRule>;
var
  Parts: TArray<string>;
  T0, T, A, B: string;
  p, v1, v2, n: Integer;
  R: TIdRule;
begin
  Ok := True;
  SetLength(Result, 0);
  n := 0;
  Parts := S.Split([',', ';', ' ', #9]);
  for T0 in Parts do
  begin
    T := UpperCase(Trim(T0));
    if T = '' then Continue;
    if T[1] = '$' then Delete(T, 1, 1);
    if Copy(T, 1, 2) = '0X' then Delete(T, 1, 2);
    p := Pos(':', T);
    if p > 0 then
    begin
      A := Copy(T, 1, p - 1);
      B := Copy(T, p + 1, MaxInt);
    end
    else
    begin
      A := T;
      B := '';
    end;
    v1 := StrToIntDef('$' + A, -1);
    if (A = '') or (v1 < 0) or (v1 > $FF) then
    begin
      Ok := False;
      Continue;
    end;
    R.ID1 := v1;
    R.AnyID2 := B = '';
    R.ID2 := 0;
    if not R.AnyID2 then
    begin
      v2 := StrToIntDef('$' + B, -1);
      if (v2 < 0) or (v2 > $FFFF) then
      begin
        Ok := False;
        Continue;
      end;
      R.ID2 := v2;
    end;
    SetLength(Result, n + 1);
    Result[n] := R;
    Inc(n);
  end;
end;

function RuleListMatch(const Rules: TArray<TIdRule>; const P: TPacket): Boolean;
var
  i: Integer;
begin
  for i := 0 to Length(Rules) - 1 do
    if (Rules[i].ID1 = P.ID1) and
       (Rules[i].AnyID2 or (P.HasID2 and (Rules[i].ID2 = P.ID2))) then
      Exit(True);
  Result := False;
end;

function PluginProc(Code: Cardinal; p1: widestring = ''; p2: widestring = ''; p3: widestring = ''): widestring;
begin
  if Assigned(@_PluginProc) then
    Result := _PluginProc(Code, p1, p2, p3)
  else
    Result := '';
end;

{ ---------------------------------------------------------------------------
  Построение интерфейса
  --------------------------------------------------------------------------- }

function TForm1.AddButton(AParent: TWinControl; X, Y, W: Integer; const ACaption: string; AOnClick: TNotifyEvent): TButton;
begin
  Result := TButton.Create(Self);
  Result.Parent := AParent;
  Result.SetBounds(X, Y, W, 23);
  Result.Caption := ACaption;
  Result.OnClick := AOnClick;
end;

function TForm1.AddCheck(AParent: TWinControl; X, Y, W: Integer; const ACaption: string; AChecked: Boolean): TCheckBox;
begin
  Result := TCheckBox.Create(Self);
  Result.Parent := AParent;
  Result.SetBounds(X, Y + 3, W, 17);
  Result.Caption := ACaption;
  Result.Checked := AChecked;
end;

function TForm1.AddLabel(AParent: TWinControl; X, Y: Integer; const ACaption: string): TLabel;
begin
  Result := TLabel.Create(Self);
  Result.Parent := AParent;
  Result.Left := X;
  Result.Top := Y + 4;
  Result.Caption := ACaption;
end;

function TForm1.AddEdit(AParent: TWinControl; X, Y, W: Integer; const AHint: string): TEdit;
begin
  Result := TEdit.Create(Self);
  Result.Parent := AParent;
  Result.SetBounds(X, Y + 1, W, 21);
  Result.Text := '';
  Result.TextHint := AHint;
  Result.Hint := AHint;
  Result.ShowHint := True;
end;

procedure TForm1.AddColumn(LV: TListView; const ACaption: string; AWidth: Integer);
var
  C: TListColumn;
begin
  C := LV.Columns.Add;
  C.Caption := ACaption;
  C.Width := AWidth;
end;

function TForm1.AddMenuItem(Menu: TPopupMenu; const ACaption: string; AOnClick: TNotifyEvent): TMenuItem;
begin
  Result := TMenuItem.Create(Menu);
  Result.Caption := ACaption;
  Result.OnClick := AOnClick;
  Menu.Items.Add(Result);
end;

procedure TForm1.BuildUI;
var
  P: TPanel;
  Mono: string;
begin
  Mono := 'Consolas';
  Caption := ver;
  Width := 1100;
  Height := 720;

  // --- верхняя панель ---
  pnlTop := TPanel.Create(Self);
  pnlTop.Parent := Self;
  pnlTop.Align := alTop;
  pnlTop.Height := 64;
  pnlTop.BevelOuter := bvNone;

  btnCapture := AddButton(pnlTop, 6, 6, 85, 'Пауза', btnCaptureClick);
  btnClear := AddButton(pnlTop, 95, 6, 80, 'Очистить', btnClearClick);
  chkS2C := AddCheck(pnlTop, 185, 6, 105, 'S>C (сервер)', True);
  chkC2S := AddCheck(pnlTop, 295, 6, 105, 'C>S (клиент)', True);
  chkAutoScroll := AddCheck(pnlTop, 405, 6, 105, 'Автопрокрутка', True);
  chkS2C.OnClick := FilterChanged;
  chkC2S.OnClick := FilterChanged;

  AddLabel(pnlTop, 515, 6, 'Исходящие:');
  cbOutMode := TComboBox.Create(Self);
  cbOutMode.Parent := pnlTop;
  cbOutMode.Style := csDropDownList;
  cbOutMode.SetBounds(578, 7, 175, 21);
  cbOutMode.Items.Add('sendactID(1)');
  cbOutMode.Items.Add('sendactID(2)');
  cbOutMode.Items.Add('sendactID(0)');
  cbOutMode.Items.Add('Не вызывать sendactID');
  cbOutMode.ItemIndex := 0;
  cbOutMode.OnChange := cbOutModeChange;

  btnSave := AddButton(pnlTop, 760, 6, 90, 'Сохранить лог', btnSaveClick);
  btnOpenLogs := AddButton(pnlTop, 854, 6, 90, 'Папка логов', btnOpenLogsClick);
  btnCopy := AddButton(pnlTop, 948, 6, 110, 'Копировать HEX', btnCopyClick);

  AddLabel(pnlTop, 6, 36, 'Только ID:');
  edtInclude := AddEdit(pnlTop, 66, 36, 230, 'Напр.: 0F, FE:0017  (пусто = все)');
  AddLabel(pnlTop, 306, 36, 'Скрыть ID:');
  edtExclude := AddEdit(pnlTop, 366, 36, 230, 'Напр.: B1, 59, 1F');
  AddLabel(pnlTop, 606, 36, 'Поиск:');
  edtSearch := AddEdit(pnlTop, 646, 36, 412, 'HEX-байты (1A 00 FF) или "текст" (ищет UTF-16 и ANSI)');
  edtInclude.OnChange := FilterChanged;
  edtExclude.OnChange := FilterChanged;
  edtSearch.OnChange := FilterChanged;

  // --- статус ---
  StatusBar := TStatusBar.Create(Self);
  StatusBar.Parent := Self;
  StatusBar.SimplePanel := True;

  // --- вкладки ---
  Pages := TPageControl.Create(Self);
  Pages.Parent := Self;
  Pages.Align := alClient;
  Pages.OnChange := PagesChange;

  tsPackets := TTabSheet.Create(Self);
  tsPackets.PageControl := Pages;
  tsPackets.Caption := 'Пакеты';

  tsStats := TTabSheet.Create(Self);
  tsStats.PageControl := Pages;
  tsStats.Caption := 'Статистика по ID';

  // --- вкладка "Пакеты": снизу - разбор выбранного пакета ---
  pnlDetail := TPanel.Create(Self);
  pnlDetail.Parent := tsPackets;
  pnlDetail.Align := alBottom;
  pnlDetail.Height := 230;
  pnlDetail.BevelOuter := bvNone;

  splDetail := TSplitter.Create(Self);
  splDetail.Parent := tsPackets;
  splDetail.Align := alBottom;
  splDetail.Top := pnlDetail.Top - 5;
  splDetail.Height := 5;

  mmoInfo := TMemo.Create(Self);
  mmoInfo.Parent := pnlDetail;
  mmoInfo.Align := alClient;
  mmoInfo.ReadOnly := True;
  mmoInfo.WordWrap := False;
  mmoInfo.ScrollBars := ssBoth;
  mmoInfo.Font.Name := Mono;
  mmoInfo.Font.Size := 10;
  mmoInfo.Color := $00FBF8F5;

  // --- список пакетов (виртуальный, быстрый на сотнях тысяч строк) ---
  pmPackets := TPopupMenu.Create(Self);
  AddMenuItem(pmPackets, 'Копировать HEX (Ctrl+C)', miCopyHexClick);
  AddMenuItem(pmPackets, 'Копировать строки целиком', miCopyLinesClick);
  AddMenuItem(pmPackets, '-', nil);
  AddMenuItem(pmPackets, 'Скрыть этот ID', miHideIdClick);
  AddMenuItem(pmPackets, 'Показывать только этот ID', miOnlyIdClick);
  AddMenuItem(pmPackets, 'Сбросить фильтры', miResetFiltersClick);

  lvPackets := TListView.Create(Self);
  lvPackets.Parent := tsPackets;
  lvPackets.Align := alClient;
  lvPackets.ViewStyle := vsReport;
  lvPackets.OwnerData := True;
  lvPackets.ReadOnly := True;
  lvPackets.RowSelect := True;
  lvPackets.MultiSelect := True;
  lvPackets.HideSelection := False;
  lvPackets.DoubleBuffered := True;
  lvPackets.Font.Name := Mono;
  lvPackets.Font.Size := 9;
  AddColumn(lvPackets, '#', 65);
  AddColumn(lvPackets, 'Время', 95);
  AddColumn(lvPackets, 'Напр.', 45);
  AddColumn(lvPackets, 'Реж.', 40);
  AddColumn(lvPackets, 'ID', 70);
  AddColumn(lvPackets, 'Пакет', 190);
  AddColumn(lvPackets, 'Размер', 55);
  AddColumn(lvPackets, 'Содержимое', 2000);
  lvPackets.OnData := lvPacketsData;
  lvPackets.OnSelectItem := lvPacketsSelectItem;
  lvPackets.OnCustomDrawItem := lvPacketsCustomDrawItem;
  lvPackets.OnKeyDown := lvPacketsKeyDown;
  lvPackets.PopupMenu := pmPackets;

  // --- вкладка "Статистика" ---
  P := TPanel.Create(Self);
  P.Parent := tsStats;
  P.Align := alTop;
  P.Height := 32;
  P.BevelOuter := bvNone;
  AddButton(P, 6, 4, 90, 'Обновить', btnStatsRefreshClick);
  AddLabel(P, 106, 4, 'Двойной клик - показать только этот ID. Правая кнопка - скрыть/показать.');

  pmStats := TPopupMenu.Create(Self);
  AddMenuItem(pmStats, 'Скрыть этот ID', miStatHideClick);
  AddMenuItem(pmStats, 'Показывать только этот ID', miStatOnlyClick);
  AddMenuItem(pmStats, 'Сбросить фильтры', miResetFiltersClick);

  lvStats := TListView.Create(Self);
  lvStats.Parent := tsStats;
  lvStats.Align := alClient;
  lvStats.ViewStyle := vsReport;
  lvStats.ReadOnly := True;
  lvStats.RowSelect := True;
  lvStats.HideSelection := False;
  lvStats.Font.Name := Mono;
  lvStats.Font.Size := 9;
  AddColumn(lvStats, 'Напр.', 50);
  AddColumn(lvStats, 'ID', 90);
  AddColumn(lvStats, 'Кол-во', 80);
  AddColumn(lvStats, 'Байт всего', 100);
  AddColumn(lvStats, 'Последний', 100);
  AddColumn(lvStats, 'реж.1', 60);
  AddColumn(lvStats, 'реж.2', 60);
  AddColumn(lvStats, 'реж.0', 60);
  AddColumn(lvStats, 'без вызова', 75);
  AddColumn(lvStats, 'Пакет', 220);
  lvStats.OnDblClick := lvStatsDblClick;
  lvStats.PopupMenu := pmStats;

  BuildBypassTab;

  Pages.ActivePage := tsPackets;

  // --- таймер: перенос пакетов из очереди в список ---
  Timer := TTimer.Create(Self);
  Timer.Interval := 100;
  Timer.OnTimer := TimerTimer;
end;

{ ---------------------------------------------------------------------------
  Вкладка "Байпасы"
  --------------------------------------------------------------------------- }

procedure TForm1.BuildBypassTab;
var
  P: TPanel;
  Spl: TSplitter;
begin
  tsBypass := TTabSheet.Create(Self);
  tsBypass.PageControl := Pages;
  tsBypass.Caption := 'Байпасы';

  P := TPanel.Create(Self);
  P.Parent := tsBypass;
  P.Align := alTop;
  P.Height := 56;
  P.BevelOuter := bvNone;
  AddButton(P, 6, 4, 90, 'Очистить', btnBpClearClick);
  AddButton(P, 100, 4, 110, 'Сохранить отчёт', btnBpSaveClick);
  chkBpAll := AddCheck(P, 220, 4, 330, 'Ловить текст из ВСЕХ пакетов клиента (не только 23)', False);
  lblBypass := AddLabel(P, 6, 30, BpSummary);
  lblBypass.Font.Style := [fsBold];

  mmoBypass := TMemo.Create(Self);
  mmoBypass.Parent := tsBypass;
  mmoBypass.Align := alBottom;
  mmoBypass.Height := 260;
  mmoBypass.ReadOnly := True;
  mmoBypass.WordWrap := False;
  mmoBypass.ScrollBars := ssBoth;
  mmoBypass.Font.Name := 'Consolas';
  mmoBypass.Font.Size := 9;

  Spl := TSplitter.Create(Self);
  Spl.Parent := tsBypass;
  Spl.Align := alBottom;
  Spl.Top := mmoBypass.Top - 5;
  Spl.Height := 5;

  lvBypass := TListView.Create(Self);
  lvBypass.Parent := tsBypass;
  lvBypass.Align := alClient;
  lvBypass.ViewStyle := vsReport;
  lvBypass.OwnerData := True;
  lvBypass.ReadOnly := True;
  lvBypass.RowSelect := True;
  lvBypass.HideSelection := False;
  lvBypass.Font.Name := 'Consolas';
  lvBypass.Font.Size := 9;
  AddColumn(lvBypass, '#', 60);
  AddColumn(lvBypass, 'Время', 95);
  AddColumn(lvBypass, 'Тип', 80);
  AddColumn(lvBypass, 'Пакет', 60);
  AddColumn(lvBypass, 'Команда / страница', 220);
  AddColumn(lvBypass, 'Кнопка', 170);
  AddColumn(lvBypass, 'Проверка', 200);
  AddColumn(lvBypass, 'Задержка', 70);
  AddColumn(lvBypass, 'Замечание', 400);
  lvBypass.OnData := lvBypassData;
  lvBypass.OnSelectItem := lvBypassSelectItem;
  lvBypass.OnCustomDrawItem := lvBypassCustomDrawItem;
end;

procedure TForm1.SyncBypass;
begin
  if BpCount <> FBpShown then
  begin
    FBpShown := BpCount;
    lvBypass.Items.Count := FBpShown;
    lvBypass.Invalidate;
    lblBypass.Caption := BpSummary;
  end;
end;

procedure TForm1.lvBypassData(Sender: TObject; Item: TListItem);
var
  E: TBpEntry;
begin
  if (Item.Index < 0) or (Item.Index >= BpCount) then Exit;
  E := BpGet(Item.Index);
  Item.Caption := IntToStr(E.Num);
  Item.SubItems.Add(FormatDateTime('hh:nn:ss.zzz', E.Time));
  case E.Kind of
    bkPage: Item.SubItems.Add('S>C стр.');
    bkBypass: Item.SubItems.Add('C>S байпас');
  else
    Item.SubItems.Add('C>S текст');
  end;
  Item.SubItems.Add(E.PacketID);
  Item.SubItems.Add(E.Text);
  Item.SubItems.Add(E.Caption);
  Item.SubItems.Add(E.Check);
  if E.DelayMs >= 0 then Item.SubItems.Add(IntToStr(E.DelayMs) + ' мс') else Item.SubItems.Add('');
  Item.SubItems.Add(E.Note);
end;

procedure TForm1.lvBypassSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Selected and (Item <> nil) and (Item.Index >= 0) and (Item.Index < BpCount) then
    mmoBypass.Text := BpGet(Item.Index).Detail;
end;

procedure TForm1.lvBypassCustomDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
  E: TBpEntry;
begin
  if (Item.Index < 0) or (Item.Index >= BpCount) then Exit;
  E := BpGet(Item.Index);
  if E.Suspicious then
    Sender.Canvas.Font.Color := clRed
  else if E.Kind = bkPage then
    Sender.Canvas.Font.Color := clNavy
  else
    Sender.Canvas.Font.Color := clMaroon;
end;

procedure TForm1.btnBpClearClick(Sender: TObject);
begin
  BpClear;
  FBpShown := -1;
  if mmoBypass <> nil then mmoBypass.Clear;
  if lvBypass <> nil then SyncBypass;
end;

procedure TForm1.btnBpSaveClick(Sender: TObject);
var
  FileName: string;
begin
  ForceDirectories(LogsDir);
  FileName := LogsDir + 'bypass_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt';
  BpSaveToFile(FileName);
  StatusBar.SimpleText := '  Сохранено: ' + FileName;
  if Engine <> nil then Engine.Msg(ver, 'Отчёт по байпасам: ' + FileName);
end;

{ ---------------------------------------------------------------------------
  Форма
  --------------------------------------------------------------------------- }

procedure TForm1.FormCreate(Sender: TObject);
begin
  FPackets := TList<TPacket>.Create;
  FView := TList<Integer>.Create;
  FStats := TDictionary<Cardinal, TStatRec>.Create;
  FShowS2C := True;
  FShowC2S := True;
  BuildUI;
  UpdateStatus;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if Timer <> nil then Timer.Enabled := False;
  FStats.Free;
  FView.Free;
  FPackets.Free;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  Hide;
end;

procedure TForm1.ShowPugin(var Msg: TMessage);
begin
  Visible := not Visible;
  if Visible then
    SetForegroundWindow(Handle);
end;

{ ---------------------------------------------------------------------------
  Данные
  --------------------------------------------------------------------------- }

procedure TForm1.TimerTimer(Sender: TObject);
begin
  // при первом тике показываем окно, в каком бы режиме бот ни загрузил плагин
  if not FFirstShown then
  begin
    FFirstShown := True;
    Visible := True;
    WindowState := wsNormal;
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
    SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
    SetForegroundWindow(Handle);
  end;
  if Engine <> nil then
  begin
    if not FEngineGreeted then
    begin
      FEngineGreeted := True;
      try
        Engine.Msg(ver, 'плагин загружен, окно открыто');
      except
      end;
    end;
    if not FActApplied then ApplyActMode;
    if GetTickCount - FInfoTick > 2000 then
    begin
      FInfoTick := GetTickCount;
      UpdateGameInfo;
    end;
  end;
  if FFilterDirty and (GetTickCount - FFilterChangeTick > 300) then
    ApplyFilter;
  FlushPending;
  SyncBypass;
  UpdateStatus;

end;

procedure TForm1.FlushPending;
var
  Batch: TList<TPacket>;
  i: Integer;
  P: TPacket;
  Added: Boolean;
begin
  PendingLock.Enter;
  try
    if PendingList.Count = 0 then Exit;
    Batch := PendingList;
    PendingList := TList<TPacket>.Create;
  finally
    PendingLock.Leave;
  end;

  Added := False;
  try
    for i := 0 to Batch.Count - 1 do
    begin
      P := Batch[i];
      Inc(FNextNum);
      P.Num := FNextNum;
      PkLearn(P);
      FPackets.Add(P);
      AddStat(P);
      BpProcess(P.Num, P.Time, P.Dir = pdClient, PacketIdText(P), P.ID1, P.Data, chkBpAll.Checked);
      if Matches(P) then
      begin
        FView.Add(FPackets.Count - 1);
        Added := True;
      end;
    end;
  finally
    Batch.Free;
  end;

  if FPackets.Count > MAX_PACKETS then
    TrimPackets
  else if Added then
    SyncListCount;
end;

procedure TForm1.AddStat(const P: TPacket);
var
  K: Cardinal;
  R: TStatRec;
begin
  K := (Cardinal(Ord(P.Dir)) shl 24) or (Cardinal(P.ID1) shl 16) or P.ID2;
  if not FStats.TryGetValue(K, R) then
  begin
    R.Key := K;
    R.Dir := P.Dir;
    R.ID1 := P.ID1;
    R.HasID2 := P.HasID2;
    R.ID2 := P.ID2;
    R.Count := 0;
    R.Bytes := 0;
    FillChar(R.ModeCnt, SizeOf(R.ModeCnt), 0);
  end;
  Inc(R.ModeCnt[ModeIdx(P.Mode)]);
  Inc(R.Count);
  Inc(R.Bytes, Length(P.Data));
  R.Last := P.Time;
  FStats.AddOrSetValue(K, R);
end;

function TForm1.Matches(const P: TPacket): Boolean;
begin
  Result := False;
  if (P.Dir = pdServer) and not FShowS2C then Exit;
  if (P.Dir = pdClient) and not FShowC2S then Exit;
  if (Length(FInclude) > 0) and not RuleListMatch(FInclude, P) then Exit;
  if RuleListMatch(FExclude, P) then Exit;
  if Length(FSearch1) > 0 then
    if (BytesPos(FSearch1, P.Data) < 0) and
       ((Length(FSearch2) = 0) or (BytesPos(FSearch2, P.Data) < 0)) then Exit;
  Result := True;
end;

procedure TForm1.FilterChanged(Sender: TObject);
begin
  FFilterDirty := True;
  FFilterChangeTick := GetTickCount;
end;

procedure TForm1.ApplyFilter;
const
  BadColor = $C0C0FF;
var
  Ok: Boolean;
  T, H: string;
  Valid: Boolean;
begin
  FFilterDirty := False;
  FShowS2C := chkS2C.Checked;
  FShowC2S := chkC2S.Checked;

  FInclude := ParseRules(edtInclude.Text, Ok);
  if Ok then edtInclude.Color := clWindow else edtInclude.Color := BadColor;
  FExclude := ParseRules(edtExclude.Text, Ok);
  if Ok then edtExclude.Color := clWindow else edtExclude.Color := BadColor;

  // поиск
  SetLength(FSearch1, 0);
  SetLength(FSearch2, 0);
  Ok := True;
  T := Trim(edtSearch.Text);
  if T <> '' then
  begin
    if (T[1] = '"') or (T[1] = '''') then
    begin
      Delete(T, 1, 1);
      if (T <> '') and ((T[Length(T)] = '"') or (T[Length(T)] = '''')) then
        Delete(T, Length(T), 1);
      if T <> '' then
      begin
        FSearch1 := TEncoding.Unicode.GetBytes(T);   // строки L2 - UTF-16LE
        FSearch2 := TEncoding.ANSI.GetBytes(T);
      end;
    end
    else
    begin
      H := CleanHex(T, Valid);
      if Valid and (H <> '') and not Odd(Length(H)) then
        FSearch1 := HexToBytes(H)
      else
        Ok := False;
    end;
  end;
  if Ok then edtSearch.Color := clWindow else edtSearch.Color := BadColor;

  RebuildView;
end;

procedure TForm1.RebuildView;
var
  i: Integer;
begin
  FView.Clear;
  for i := 0 to FPackets.Count - 1 do
    if Matches(FPackets[i]) then
      FView.Add(i);
  lvPackets.Items.Count := FView.Count;
  lvPackets.Invalidate;
  if chkAutoScroll.Checked and (FView.Count > 0) then
    lvPackets.Items[FView.Count - 1].MakeVisible(False);
end;

procedure TForm1.SyncListCount;
begin
  lvPackets.Items.Count := FView.Count;
  if chkAutoScroll.Checked and (FView.Count > 0) then
    lvPackets.Items[FView.Count - 1].MakeVisible(False);
end;

procedure TForm1.TrimPackets;
begin
  FPackets.DeleteRange(0, MAX_PACKETS div 5);
  RebuildView;
end;

procedure TForm1.UpdateStatus;
var
  Pend: Integer;
  S: string;
begin
  PendingLock.Enter;
  try
    Pend := PendingList.Count;
  finally
    PendingLock.Leave;
  end;
  if CaptureEnabled then S := 'идёт' else S := 'ПАУЗА';
  StatusBar.SimpleText := Format('  Захват: %s   |   sendactID: %s   |   Всего в памяти: %d   |   Показано: %d   |   В очереди: %d   |   Типов пакетов: %d',
    [S, ModeText(CurActMode), FPackets.Count, FView.Count, Pend, FStats.Count]);
end;

procedure TForm1.UpdateGameInfo;
var
  S, Name: string;
begin
  try
    Name := '';
    if Engine.User <> nil then Name := Engine.User.Name;
    S := ver;
    if Name <> '' then S := S + ' - ' + Name;
    S := S + Format('   [GameVersion: %d, Protocol: %d, Classic: %s]',
      [Engine.GameVersion, Engine.GameProtocol, BoolToStr(Engine.IsClassicServer, True)]);
    if Caption <> S then Caption := S;
  except
  end;
end;

procedure TForm1.ApplyActMode;
begin
  FActApplied := True;
  try
    case cbOutMode.ItemIndex of
      0: CurActMode := 1;
      1: CurActMode := 2;
      2: CurActMode := 0;
    else
      Exit;
    end;
    Engine.SendActID(CurActMode);
    Engine.Msg(ver, Format('вызван sendactID(%d) - пакеты помечаются режимом %d', [CurActMode, CurActMode]));
  except
  end;
end;

procedure TForm1.cbOutModeChange(Sender: TObject);
begin
  FActApplied := False;   // применится на следующем тике таймера
end;

{ ---------------------------------------------------------------------------
  Список пакетов
  --------------------------------------------------------------------------- }

procedure TForm1.lvPacketsData(Sender: TObject; Item: TListItem);
var
  P: TPacket;
  Idx: Integer;
  S: string;
begin
  Idx := Item.Index;
  if (Idx < 0) or (Idx >= FView.Count) then Exit;
  P := FPackets[FView[Idx]];
  Item.Caption := IntToStr(P.Num);
  Item.SubItems.Add(FormatDateTime('hh:nn:ss.zzz', P.Time));
  Item.SubItems.Add(DirText(P.Dir));
  Item.SubItems.Add(ModeText(P.Mode));
  Item.SubItems.Add(PacketIdText(P));
  S := PkName(P);
  if S = '' then S := '?';
  Item.SubItems.Add(S);
  Item.SubItems.Add(IntToStr(Length(P.Data)));
  Item.SubItems.Add(PkSummary(P));
end;

procedure TForm1.lvPacketsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Idx: Integer;
begin
  Idx := Item.Index;
  if (Idx < 0) or (Idx >= FView.Count) then Exit;
  if FPackets[FView[Idx]].Dir = pdClient then
    Sender.Canvas.Font.Color := clMaroon     // C>S - бордовый
  else
    Sender.Canvas.Font.Color := clNavy;      // S>C - синий
end;

procedure TForm1.lvPacketsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  if Selected and (Item <> nil) then
    ShowPacket(Item.Index);
end;

procedure TForm1.lvPacketsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (Key = Ord('C')) then
  begin
    miCopyHexClick(nil);
    Key := 0;
  end;
end;

procedure TForm1.ShowPacket(ViewIndex: Integer);
begin
  if (ViewIndex < 0) or (ViewIndex >= FView.Count) then Exit;
  FCur := FPackets[FView[ViewIndex]];
  FHasCur := True;
  mmoInfo.Text := PkDetails(FCur);
end;

function TForm1.SelectedViewIndexes: TList<Integer>;
var
  Item: TListItem;
begin
  Result := TList<Integer>.Create;
  Item := lvPackets.Selected;
  while Item <> nil do
  begin
    if (Item.Index >= 0) and (Item.Index < FView.Count) then
      Result.Add(Item.Index);
    Item := lvPackets.GetNextItem(Item, sdAll, [isSelected]);
  end;
end;

function TForm1.CurrentIdText: string;
begin
  if FHasCur then Result := PacketIdText(FCur) else Result := '';
end;

procedure TForm1.AddIdToEdit(Edit: TEdit; const IdText: string);
begin
  if IdText = '' then Exit;
  if Trim(Edit.Text) = '' then
    Edit.Text := IdText
  else
    Edit.Text := Edit.Text + ', ' + IdText;
end;

{ ---------------------------------------------------------------------------
  Кнопки и меню
  --------------------------------------------------------------------------- }

procedure TForm1.btnCaptureClick(Sender: TObject);
begin
  CaptureEnabled := not CaptureEnabled;
  if CaptureEnabled then btnCapture.Caption := 'Пауза' else btnCapture.Caption := 'Старт';
  UpdateStatus;
end;

procedure TForm1.btnClearClick(Sender: TObject);
begin
  btnBpClearClick(nil);
  PendingLock.Enter;
  try
    PendingList.Clear;
  finally
    PendingLock.Leave;
  end;
  FPackets.Clear;
  FView.Clear;
  FStats.Clear;
  FNextNum := 0;
  FHasCur := False;
  lvPackets.Items.Count := 0;
  lvPackets.Invalidate;
  lvStats.Items.Clear;
  mmoInfo.Clear;
  UpdateStatus;
end;

function TForm1.LogsDir: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(GetModuleName(HInstance))) + 'SnifferLogs\';
end;

procedure TForm1.btnSaveClick(Sender: TObject);
var
  SL: TStringList;
  i: Integer;
  FileName: string;
begin
  SL := TStringList.Create;
  try
    SL.Add('# ' + Caption);
    SL.Add('# Фильтр: только=[' + edtInclude.Text + '] скрыть=[' + edtExclude.Text + '] поиск=[' + edtSearch.Text + ']');
    SL.Add('# num'#9'time'#9'dir'#9'id'#9'size'#9'hex'#9'mode');
    for i := 0 to FView.Count - 1 do
      SL.Add(PacketLine(FPackets[FView[i]]));
    ForceDirectories(LogsDir);
    FileName := LogsDir + 'packets_' + FormatDateTime('yyyymmdd_hhnnss', Now) + '.txt';
    SL.SaveToFile(FileName, TEncoding.UTF8);
    if Engine <> nil then
      Engine.Msg(ver, Format('Сохранено %d пакетов: %s', [FView.Count, FileName]));
    StatusBar.SimpleText := '  Сохранено: ' + FileName;
  finally
    SL.Free;
  end;
end;

procedure TForm1.btnOpenLogsClick(Sender: TObject);
begin
  ForceDirectories(LogsDir);
  ShellExecute(0, 'open', PChar(LogsDir), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.btnCopyClick(Sender: TObject);
begin
  miCopyHexClick(nil);
end;

procedure TForm1.miCopyHexClick(Sender: TObject);
var
  Sel: TList<Integer>;
  SB: TStringBuilder;
  i: Integer;
begin
  Sel := SelectedViewIndexes;
  SB := TStringBuilder.Create;
  try
    for i := 0 to Sel.Count - 1 do
      SB.AppendLine(BytesToHex(FPackets[FView[Sel[i]]].Data));
    if SB.Length > 0 then Clipboard.AsText := SB.ToString;
  finally
    SB.Free;
    Sel.Free;
  end;
end;

procedure TForm1.miCopyLinesClick(Sender: TObject);
var
  Sel: TList<Integer>;
  SB: TStringBuilder;
  i: Integer;
begin
  Sel := SelectedViewIndexes;
  SB := TStringBuilder.Create;
  try
    for i := 0 to Sel.Count - 1 do
      SB.AppendLine(PacketLine(FPackets[FView[Sel[i]]]));
    if SB.Length > 0 then Clipboard.AsText := SB.ToString;
  finally
    SB.Free;
    Sel.Free;
  end;
end;

procedure TForm1.miHideIdClick(Sender: TObject);
begin
  AddIdToEdit(edtExclude, CurrentIdText);
end;

procedure TForm1.miOnlyIdClick(Sender: TObject);
begin
  if CurrentIdText <> '' then edtInclude.Text := CurrentIdText;
end;

procedure TForm1.miResetFiltersClick(Sender: TObject);
begin
  edtInclude.Text := '';
  edtExclude.Text := '';
  edtSearch.Text := '';
  chkS2C.Checked := True;
  chkC2S.Checked := True;
end;

{ ---------------------------------------------------------------------------
  Статистика
  --------------------------------------------------------------------------- }

procedure TForm1.RefreshStats;
var
  Arr: TList<TStatRec>;
  R: TStatRec;
  Item: TListItem;
  i: Integer;
begin
  Arr := TList<TStatRec>.Create;
  try
    for R in FStats.Values do
      Arr.Add(R);
    Arr.Sort(TComparer<TStatRec>.Construct(
      function(const A, B: TStatRec): Integer
      begin
        Result := B.Count - A.Count;
      end));
    lvStats.Items.BeginUpdate;
    try
      lvStats.Items.Clear;
      for i := 0 to Arr.Count - 1 do
      begin
        R := Arr[i];
        Item := lvStats.Items.Add;
        Item.Caption := DirText(R.Dir);
        Item.SubItems.Add(IdText(R.ID1, R.HasID2, R.ID2));
        Item.SubItems.Add(IntToStr(R.Count));
        Item.SubItems.Add(IntToStr(R.Bytes));
        Item.SubItems.Add(FormatDateTime('hh:nn:ss.zzz', R.Last));
        Item.SubItems.Add(IntToStr(R.ModeCnt[1]));
        Item.SubItems.Add(IntToStr(R.ModeCnt[2]));
        Item.SubItems.Add(IntToStr(R.ModeCnt[0]));
        Item.SubItems.Add(IntToStr(R.ModeCnt[3]));
        Item.SubItems.Add(PkNameOf(R.Dir = pdClient, R.ID1, R.HasID2, R.ID2));
      end;
    finally
      lvStats.Items.EndUpdate;
    end;
  finally
    Arr.Free;
  end;
end;

procedure TForm1.PagesChange(Sender: TObject);
begin
  if Pages.ActivePage = tsStats then RefreshStats;
end;

procedure TForm1.btnStatsRefreshClick(Sender: TObject);
begin
  RefreshStats;
end;

procedure TForm1.lvStatsDblClick(Sender: TObject);
begin
  miStatOnlyClick(nil);
end;

procedure TForm1.miStatHideClick(Sender: TObject);
begin
  if lvStats.Selected <> nil then
    AddIdToEdit(edtExclude, lvStats.Selected.SubItems[0]);
end;

procedure TForm1.miStatOnlyClick(Sender: TObject);
begin
  if lvStats.Selected = nil then Exit;
  edtInclude.Text := lvStats.Selected.SubItems[0];
  Pages.ActivePage := tsPackets;
end;

initialization
  PendingLock := TCriticalSection.Create;
  PendingList := TList<TPacket>.Create;
  PkInit;

finalization
  CaptureEnabled := False;
  PendingList.Free;
  PendingLock.Free;
  PkDefs.Free;
  PkObj.Free;

end.
