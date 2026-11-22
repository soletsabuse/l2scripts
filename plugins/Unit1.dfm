object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 602
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 24
    Top = 15
    Width = 73
    Height = 25
    Caption = 'UserName'
    TabOrder = 0
    OnClick = btn1Click
  end
  object Edit1: TEdit
    Left = 117
    Top = 17
    Width = 118
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object btn2: TButton
    Left = 24
    Top = 71
    Width = 73
    Height = 23
    Caption = 'MoveTo'
    TabOrder = 2
    OnClick = btn2Click
  end
  object btn3: TButton
    Left = 24
    Top = 125
    Width = 73
    Height = 24
    Caption = 'Print'
    TabOrder = 3
    OnClick = btn3Click
  end
  object Edit2: TEdit
    Left = 117
    Top = 127
    Width = 118
    Height = 21
    TabOrder = 4
    Text = 'Print text'
  end
  object ColorBox1: TColorBox
    Left = 241
    Top = 127
    Width = 157
    Height = 22
    TabOrder = 5
  end
  object Edit3: TEdit
    Left = 117
    Top = 72
    Width = 79
    Height = 21
    TabOrder = 6
    Text = 'Edit1'
  end
  object Edit4: TEdit
    Left = 202
    Top = 72
    Width = 79
    Height = 21
    TabOrder = 7
    Text = 'Edit1'
  end
  object btn4: TButton
    Left = 287
    Top = 71
    Width = 73
    Height = 23
    Caption = 'CurPos'
    TabOrder = 8
    OnClick = btn4Click
  end
  object btn5: TButton
    Left = 326
    Top = 179
    Width = 72
    Height = 25
    Caption = 'Hide'
    TabOrder = 9
    OnClick = btn5Click
  end
  object CheckBox1: TCheckBox
    Left = 24
    Top = 179
    Width = 94
    Height = 17
    Caption = 'Hide unselected'
    TabOrder = 10
    OnClick = CheckBox1Click
  end
  object mmo1: TMemo
    Left = 24
    Top = 209
    Width = 374
    Height = 132
    TabOrder = 11
  end
  object btn6: TButton
    Left = 24
    Top = 347
    Width = 67
    Height = 23
    Caption = 'NpcList'
    TabOrder = 12
    OnClick = btn6Click
  end
  object btn7: TButton
    Left = 97
    Top = 347
    Width = 68
    Height = 23
    Caption = 'CharList'
    TabOrder = 13
    OnClick = btn7Click
  end
  object lv1: TListView
    Left = 24
    Top = 383
    Width = 374
    Height = 185
    Checkboxes = True
    Columns = <
      item
        Width = 272
      end
      item
        Width = 91
      end>
    DoubleBuffered = True
    DragMode = dmAutomatic
    FlatScrollBars = True
    ReadOnly = True
    RowSelect = True
    ParentDoubleBuffered = False
    TabOrder = 14
    ViewStyle = vsReport
    OnAdvancedCustomDrawItem = lv1AdvancedCustomDrawItem
  end
  object btn8: TButton
    Left = 202
    Top = 573
    Width = 72
    Height = 23
    Caption = 'SkillList'
    TabOrder = 15
    OnClick = btn8Click
  end
  object btn9: TBitBtn
    Left = 22
    Top = 573
    Width = 86
    Height = 23
    Caption = 'Find ICO (Base)'
    TabOrder = 16
    OnClick = btn9Click
  end
  object edt1: TEdit
    Left = 113
    Top = 573
    Width = 40
    Height = 21
    TabOrder = 17
    Text = '555'
  end
  object chk1: TCheckBox
    Left = 158
    Top = 576
    Width = 53
    Height = 15
    Caption = 'Item'
    TabOrder = 18
  end
  object btn10: TButton
    Left = 280
    Top = 573
    Width = 67
    Height = 23
    Caption = 'ItemList'
    TabOrder = 19
    OnClick = btn10Click
  end
  object btn11: TBitBtn
    Left = 351
    Top = 573
    Width = 68
    Height = 23
    Caption = 'CharList'
    TabOrder = 20
    OnClick = btn11Click
  end
  object BitBtn1: TBitBtn
    Left = 323
    Top = 352
    Width = 75
    Height = 25
    Caption = 'test'
    TabOrder = 21
    OnClick = BitBtn1Click
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 152
    Top = 176
  end
end
