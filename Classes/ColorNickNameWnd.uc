class ColorNickNameWnd extends UICommonAPI;

var WindowHandle Me;
var EditBoxHandle NickNameEditBox;
var ComboBoxHandle ColorComboBox;
var array<Color> ColorTable;
var array<int> ColorIndexs;
var ButtonHandle btnOk;
var ButtonHandle btnCancel;
var ItemID m_ClickedItemID;

function OnRegisterEvent()
{
    RegisterEvent(3440);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Me = GetWindowHandle("ColorNickNameWnd");
    NickNameEditBox = GetEditBoxHandle("ColorNickNameWnd.Edit_NickName");
    ColorComboBox = GetComboBoxHandle("ColorNickNameWnd.ColorCombo");
    btnOk = GetButtonHandle("ColorNickNameWnd.BtnOk");
    btnCancel = GetButtonHandle("ColorNickNameWnd.BtnCancel");
    return;
}

function OnChangeEditBox(string strID)
{
    switch(strID)
    {
        // End:0x2B
        case "Edit_NickName":
            btnOk.EnableWindow();
            // End:0x2E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int EventID, string param)
{
    switch(EventID)
    {
        // End:0x1D
        case 3440:
            OnOpenWnd(param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnOpenWnd(string param)
{
    local UserInfo UserInfo;
    local Color colNickNameColor;
    local string strNickName;
    local int i, numOfColorIndex, ColorIndex, colorSysStringID;

    ParseItemID(param, m_ClickedItemID);
    ParseInt(param, "numOfColorIndex", numOfColorIndex);
    ColorTable.Remove(0, ColorTable.Length);
    ColorIndexs.Remove(0, ColorIndexs.Length);
    ColorTable.Length = numOfColorIndex + 1;
    ColorIndexs.Length = numOfColorIndex + 1;
    ColorTable[0].A = byte(255);
    ColorTable[0].R = 162;
    ColorTable[0].G = 249;
    ColorTable[0].B = 236;
    ColorComboBox.Clear();
    i = 1;
    J0xBD:

    // End:0x173 [Loop If]
    if(i <= numOfColorIndex)
    {
        ParseInt(param, "ColorIndex" $ string(i), ColorIndex);
        ColorTable[i] = GetNicknameColorWithIndex(ColorIndex);
        ColorIndexs[i] = ColorIndex;
        ParseInt(param, "ColorSysStringID" $ string(i), colorSysStringID);
        ColorComboBox.AddStringWithColor(GetSystemString(colorSysStringID), ColorTable[i]);
        i++;
        // [Loop Continue]
        goto J0xBD;
    }
    Me.ShowWindow();
    NickNameEditBox.SetFocus();
    // End:0x243
    if(GetPlayerInfo(UserInfo))
    {
        strNickName = UserInfo.strNickName;
        colNickNameColor = UserInfo.NicknameColor;
        NickNameEditBox.Clear();
        NickNameEditBox.SetString(strNickName);
        i = 0;
        J0x1E9:

        // End:0x243 [Loop If]
        if(i < numOfColorIndex)
        {
            // End:0x239
            if(ColorTable[i] == colNickNameColor)
            {
                ColorComboBox.SetSelectedNum(i - 1);
                btnOk.DisableWindow();
                // [Explicit Break]
                goto J0x243;
            }
            i++;
            // [Loop Continue]
            goto J0x1E9;
        }
    }
    J0x243:

    return;
}

function OnComboBoxItemSelected(string ComboboxName, int Id)
{
    local UserInfo UserInfo;
    local Color colNickNameColor;

    // End:0x5A
    if(GetPlayerInfo(UserInfo))
    {
        colNickNameColor = UserInfo.NicknameColor;
        // End:0x4B
        if(ColorTable[Id + 1] == colNickNameColor)
        {
            btnOk.DisableWindow();            
        }
        else
        {
            btnOk.EnableWindow();
        }
    }
    return;
}

function OnClickButton(string buttonName)
{
    local int selectedNum;

    switch(buttonName)
    {
        // End:0x81
        case "BtnOk":
            // End:0x7E
            if(NickNameEditBox.GetString() != "")
            {
                selectedNum = ColorComboBox.GetSelectedNum();
                selectedNum = selectedNum;
                RequestChangeNicknameNColor(ColorIndexs[selectedNum + 1], NickNameEditBox.GetString(), m_ClickedItemID);
                Me.HideWindow();
            }
            // End:0xA4
            break;
        // End:0xA1
        case "BtnCancel":
            Me.HideWindow();
            // End:0xA4
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("ColorNickNameWnd").HideWindow();
    return;
}
