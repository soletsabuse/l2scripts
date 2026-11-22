unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, PluginApi, Graphics, ComCtrls, ImgList, Buttons;

const
  WM_PluginShow = WM_USER + 5402;
  ver = 'plugin version 2.4';
type
  TForm1 = class(TForm)
    btn1: TButton;
    Edit1: TEdit;
    btn2: TButton;
    btn3: TButton;
    Edit2: TEdit;
    ColorBox1: TColorBox;
    Edit3: TEdit;
    Edit4: TEdit;
    btn4: TButton;
    btn5: TButton;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    mmo1: TMemo;
    btn6: TButton;
    btn7: TButton;
    lv1: TListView;
    btn8: TButton;
    btn9: TBitBtn;
    edt1: TEdit;
    chk1: TCheckBox;
    btn10: TButton;
    btn11: TBitBtn;
    BitBtn1: TBitBtn;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure lv1AdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure btn11Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    fRestore: Boolean;
    procedure ShowPugin(var Msg: TMessage); message WM_PluginShow;
  public
  end;

var
  Form1: TForm1;
  _PluginProc: function(Code: Cardinal; p1, p2, p3: widestring): widestring; stdcall;
  Engine: IL2Control;

implementation

{$R *.dfm}

procedure TForm1.ShowPugin(var Msg: TMessage);
var
  i: integer;
begin
  Visible := not Visible;
  if Visible then
    SetForegroundWindow(Handle);
{  for i := 0 to Application.ComponentCount - 1 do
    if (Application.Components[I] is TForm) then
      (Application.Components[I] as TForm).Visible := Visible;}
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  Hide;
end;

function PluginProc(Code: Cardinal; p1: widestring = ''; p2: widestring = ''; p3: widestring = ''): widestring;
begin
  if Assigned(@_PluginProc) then
    Result := _PluginProc(Code, p1, p2, p3)
  else
    result := '';
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  i: Integer;
  X: Cardinal;
  Item: IL2Object;
begin
//  for I := 0 to engine.BotList.count - 1 do
//    Engine.BotList.Items[I].Active := True;
//  Caption := engine.Bot.GetScriptHWID;
//  AllocConsole;  Writeln(ord(Engine.Bot.ScriptStatus));
//  Engine.BotList[1].ScriptLoad(Engine.Bot.ScriptPath);
//  Engine.BotList[1].Scriptstop;
  if Engine.ItemList.User.ByIndex[2, Item] then // ищев второй айтем по индексу
  begin
    Edit1.Text := IntToStr(Item.OID);
    Edit1.Text := IntToStr((Item as IL2Item).BodyPart); // обращаемся к полям  IL2Item
    X := Item.ID;
    Engine.Bot.DoEntryPlugin(X);
   end;
end;

procedure TForm1.btn10Click(Sender: TObject);
var
  I: Integer;
begin
  lv1.Clear;
  with engine do
    for I := 0 to ItemList.User.Count - 1 do
    begin
      lv1.AddItem(ItemList.User[I].Name, Pointer(ItemList.User[I].GetIcoHandle));
      lv1.Items[I].SubItems.Add('count = ' + inttostr(ItemList.User[I].Count));
    end;
end;

procedure TForm1.btn11Click(Sender: TObject);
var
  I: Integer;
  H: Thandle;
begin
  lv1.Clear;
  with engine do
    for I := 0 to CharList.Count - 1 do
    begin
      lv1.AddItem(CharList[I].Name, Pointer(CharList[I].CrestIcoHandle));
        lv1.Items[I].SubItems.Add(CharList[I].ClanName)
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  Edit1.Text := Engine.User.name;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  Engine.DMoveTo(StrToInt(Edit3.Text), StrToInt(Edit4.Text), Engine.User.Z);
end;

procedure TForm1.btn3Click(Sender: TObject);
begin
  Engine.Msg(ver, Edit2.Text, ColorBox1.Selected);
end;

procedure TForm1.btn4Click(Sender: TObject);
begin
  Edit3.Text := IntToStr(engine.User.X);
  Edit4.Text := IntToStr(engine.User.Y);
end;

procedure TForm1.btn5Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btn6Click(Sender: TObject);
var
  I: Integer;
begin
  mmo1.Clear;
  with engine do
    for I := 0 to NpcList.Count - 1 do
      mmo1.Lines.Add('Npcinfo = ' + NpcList[I].Name + ' lvl = ' + IntToStr(NpcList[I].Level) + ' ID = ' +  IntToStr(NpcList[I].ID));
end;

procedure TForm1.btn7Click(Sender: TObject);
var
  I: Integer;
begin
  mmo1.Clear;
  with engine do
    for I := 0 to CharList.Count - 1 do
      mmo1.Lines.Add('Charinfo = ' + CharList[I].Name + ' lvl = ' + IntToStr(CharList[I].Level) + ' class = ' +  CharList[I].ClassName);
end;

procedure TForm1.btn8Click(Sender: TObject);
var
  I: Integer;
begin
  lv1.Clear;
  with engine do
    for I := 0 to SkillList.Count - 1 do
    begin
      lv1.AddItem(SkillList[I].Name, Pointer(SkillList[I].GetIcoHandle));
      lv1.Items[I].SubItems.Add(inttostr(SkillList[I].Level) + ' level');
    end;
end;

procedure TForm1.btn9Click(Sender: TObject);
var
  I: Integer;
  H: Thandle;
begin
  lv1.Clear;
  H := Engine.GetBaseIconHandle(StrToInt(edt1.Text), Integer(chk1.Checked));
  if H <> 0 then
  begin
      lv1.AddItem(Edit1.Text, Pointer(H));
      if chk1.Checked then
        lv1.Items[I].SubItems.Add('item id = ' + edt1.Text)
      else
        lv1.Items[I].SubItems.Add('skill id = ' + edt1.Text);
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  Timer1.Enabled := CheckBox1.Checked;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if not Engine.AccountSelected and Visible then
  begin
    Hide;
    fRestore := True;
  end;
  if Engine.AccountSelected and fRestore then
  begin
    Visible := True;
    fRestore := False;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Caption := Engine.User.Name;
  if Caption = '' then
    Caption := ver;
  Engine.Msg(ver, Edit2.Text, ColorBox1.Selected);
end;


procedure TForm1.lv1AdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
var
  Bmp: TBitmap;
begin
  if Item.Data = nil then exit;
  if (Item.ImageIndex <= 0) then
  begin
    Bmp := TBitmap.Create;
    try
//      Bmp.LoadFromClipboardFormat(CF_BITMAP,THandle(Item.Data),0);
//      Bmp.Handle :=  CopyImage(THandle(Item.Data),IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION);
      Bmp.Handle := THandle(Item.Data);
      if TListView(Sender).SmallImages = nil then
      begin
        TListView(Sender).SmallImages := TImageList.Create(Sender);
        TListView(Sender).SmallImages.ColorDepth := cd32Bit;
        TListView(Sender).SmallImages.DrawingStyle := dsTransparent;
        TListView(Sender).SmallImages.Masked := True;
        TListView(Sender).SmallImages.Width := Bmp.Width;//16
        TListView(Sender).SmallImages.Height := Bmp.Height;//16
      end;
      Item.ImageIndex := TListView(Sender).SmallImages.AddMasked(Bmp, clNone);
    finally
      Bmp.ReleaseHandle;
      Bmp.Free;
    end;
  end;
end;

end.
