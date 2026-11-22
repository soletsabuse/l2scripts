library Plugin;

uses
  SimpleShareMem,
  Forms,
  Windows,
  SysUtils,
  Controls,
  Messages,
  TypInfo,
  PluginAPI in 'PluginAPI.pas',
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
      //Application.CreateForm(TForm2, Form2);
      //Application.CreateForm(TForm3, Form3);
      Application.Run;
    finally
      Application.Free;
    end;
  except
  end;
  Result := 0;
  Endthread(0);
end;

function StartPlugin(AppHandle: Cardinal; PProc: Pointer): Cardinal; stdcall;
begin
  if LoadMode <> 0 then Exit(1);
  @_PluginProc := Pointer(pproc);
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
    // Application.CreateForm(TForm2, Form2);
    // Application.CreateForm(TForm3, Form3);
    // ..
  end;
  Result := 1;
end;

function StopPlugin: Boolean; stdcall;
begin
  if LoadMode = 1 then
  begin
    PostMessage(Application.MainForm.Handle, WM_QUIT, 0, 0);
    WaitForSingleObject(hAppThread, INFINITE);
    CloseHandle(hAppThread);
    Application := TApplication.Create(nil);
  end
  else
  if LoadMode = 2 then
  begin
    FreeAndNil(Form1);
    //FreeAndNil(Form2);
    //FreeAndNil(Form3);
  end;
  LoadMode := 0;
  Result := True;
end;

procedure ShowPlugin; stdcall;
begin
  if LoadMode <> 0 then
    PostMessage(Form1.Handle, WM_PluginShow, 0, 0);
end;

procedure OnAction(Action: TL2Action; P1, P2: Pointer); stdcall;
begin
  Engine.Msg('Action', inttostr(Ord(Action)));
end;

procedure OnPacket(ID1, ID2: Cardinal; Data: Pointer; Size: Word); stdcall;
begin
  Engine.Msg('C<-S', MemToHex(ID1, 1) + MemToHex(Data^, Size));
end;

procedure OnCliPacket(ID1, ID2: Cardinal; Data: Pointer; Size: Word); stdcall;
begin
  Engine.Msg('C->S', MemToHex(ID1, 1) + MemToHex(Data^, Size));
end;

procedure GlobalOnPacket(Bot: IBot; ID1, ID2: Cardinal; Data: Pointer; Size: Word); stdcall;
begin
  Engine.Msg(Bot.UserName + ' Global C<-S', MemToHex(ID1, 1) + MemToHex(Data^, Size));
end;

procedure GlobalOnCliPacket(Bot: IBot; ID1, ID2: Cardinal; Data: Pointer; Size: Word); stdcall;
begin
  Engine.Msg(Bot.UserName + ' Global C->S', MemToHex(ID1, 1) + MemToHex(Data^, Size));
end;

function InitControl(AEngine: IL2Control): THandle; stdcall;
begin
  Result := AppThreadID;
  Engine := AEngine;
end;

function OnEntry(var prm): Boolean;
begin
  Engine.Msg('OnEntry  Prm = ', IntToStr(Cardinal(prm)));
  Result := True;
end;

exports
  OnEntry,
  StartPlugin,
  StopPlugin,
  ShowPlugin,
  InitControl,
  OnAction,
  OnPacket,
  OnCliPacket
//  GlobalOnPacket,
//  GlobalOnCliPacket
  ;

end.






