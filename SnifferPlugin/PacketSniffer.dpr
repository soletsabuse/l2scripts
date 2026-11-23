library PacketSniffer;

{ Packet Sniffer - плагин для L2 Adrenaline.
  Загружается самим ботом как обычный плагин, скрипт не нужен.
  Только сниффер: никаких действий в игре плагин не выполняет.
  Перехват исходящих (sendactID) включается из окна плагина. }

uses
  SimpleShareMem,
  Forms,
  Windows,
  SysUtils,
  Controls,
  Messages,
  PluginAPI in 'PluginAPI.pas',
  BypassMon in 'BypassMon.pas',
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

var
  LoadMode: Integer;
  hAppThread: THandle;
  AppThreadID: Cardinal;

function AppThread(P: Pointer): Integer;
begin
  try
    MainThreadID := GetCurrentThreadId;
    Application := TApplication.Create(nil);
    try
      Application.Initialize;
      Application.MainFormOnTaskbar := True;
      Application.CreateForm(TForm1, Form1);
      Application.Run;
    finally
      Application.Free;
    end;
  except
  end;
  Result := 0;
  EndThread(0);
end;

function StartPlugin(AppHandle: Cardinal; PProc: Pointer): Cardinal; stdcall;
begin
  if LoadMode <> 0 then Exit(1);
  @_PluginProc := Pointer(PProc);   // при загрузке без скрипта может быть nil - это нормально
  CaptureEnabled := True;
  if AppHandle = 0 then
  begin
    LoadMode := 1;
    Application.Free;
    hAppThread := BeginThread(nil, 0, @AppThread, nil, 0, AppThreadID);
  end
  else
  begin
    LoadMode := 2;
    Application.Handle := AppHandle;
    Application.CreateForm(TForm1, Form1);
  end;
  Result := 1;
end;

function StopPlugin: Boolean; stdcall;
begin
  CaptureEnabled := False;
  if LoadMode = 1 then
  begin
    PostMessage(Application.MainForm.Handle, WM_QUIT, 0, 0);
    WaitForSingleObject(hAppThread, INFINITE);
    CloseHandle(hAppThread);
    Application := TApplication.Create(nil);
  end
  else
  if LoadMode = 2 then
    FreeAndNil(Form1);
  LoadMode := 0;
  Result := True;
end;

procedure ShowPlugin; stdcall;
begin
  if (LoadMode <> 0) and (Form1 <> nil) then
    PostMessage(Form1.Handle, WM_PluginShow, 0, 0);
end;

function InitControl(AEngine: IL2Control): THandle; stdcall;
begin
  Result := AppThreadID;
  Engine := AEngine;
end;

// Входящие пакеты (сервер -> клиент)
procedure OnPacket(ID1, ID2: Cardinal; Data: Pointer; Size: Word); stdcall;
begin
  SnifferPush(pdServer, ID1, ID2, Data, Size);
end;

// Исходящие пакеты (клиент -> сервер). Нужен sendactID(1) или (2) - выбирается в окне.
procedure OnCliPacket(ID1, ID2: Cardinal; Data: Pointer; Size: Word); stdcall;
begin
  SnifferPush(pdClient, ID1, ID2, Data, Size);
end;

// События бота плагину не нужны - пустой обработчик для совместимости
procedure OnAction(Action: TL2Action; P1, P2: Pointer); stdcall;
begin
end;

exports
  StartPlugin,
  StopPlugin,
  ShowPlugin,
  InitControl,
  OnAction,
  OnPacket,
  OnCliPacket;

end.
