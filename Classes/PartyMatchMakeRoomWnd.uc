class PartyMatchMakeRoomWnd extends UICommonAPI;

enum InviteStateType
{
    MAKEROOM,                       // 0
    INVITE_MAKEROOM,                // 1
    SETTINGCHANGE                   // 2
};

var PartyMatchMakeRoomWnd.InviteStateType InviteState;
var int RoomNumber;
var string InvitedName;
var EditBoxHandle MinLevelEditBox;
var EditBoxHandle MaxLevelEditBox;

function OnLoad()
{
    MinLevelEditBox = GetEditBoxHandle("PartyMatchMakeRoomWnd.MinLevelEditBox");
    MaxLevelEditBox = GetEditBoxHandle("PartyMatchMakeRoomWnd.MaxLevelEditBox");
    return;
}

function OnShow()
{
    switch(InviteState)
    {
        // End:0x4A
        case 0:
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchMakeRoomWnd.TitletoDo", GetSystemString(1457));
            // End:0xD3
            break;
        // End:0x8D
        case 1:
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchMakeRoomWnd.TitletoDo", GetSystemString(1458));
            // End:0xD3
            break;
        // End:0xD0
        case 2:
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchMakeRoomWnd.TitletoDo", GetSystemString(1460));
            // End:0xD3
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string a_strButtonName)
{
    switch(a_strButtonName)
    {
        // End:0x1D
        case "OKButton":
            OnOKButtonClick();
            // End:0x3A
            break;
        // End:0x37
        case "CancelButton":
            OnCancelButtonClick();
            // End:0x3A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnOKButtonClick()
{
    local int MaxPartyMemberCount, MinLevel, MaxLevel;
    local string RoomTitle;

    // End:0x2B
    if(getInstanceUIData().getIsClassicServer())
    {
        MaxLevel = getInstanceUIData().MAXLV;        
    }
    else
    {
        MaxLevel = getInstanceUIData().85;
    }
    MinLevel = Clamp(int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox")), 1, MaxLevel);
    MaxLevel = Clamp(int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox")), 1, MaxLevel);
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchMakeRoomWnd.MinLevelEditBox", string(MinLevel));
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchMakeRoomWnd.MaxLevelEditBox", string(MaxLevel));
    MaxLevel = getInstanceUIData().MAXLV;
    RoomTitle = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.TitleEditBox");
    MaxPartyMemberCount = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("PartyMatchMakeRoomWnd.MaxPartyMemberCountComboBox") + 2;
    MinLevel = Clamp(int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox")), 1, MaxLevel);
    MaxLevel = Clamp(int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox")), 1, MaxLevel);
    Class'NWindow.PartyMatchAPI'.static.RequestManagePartyRoom(RoomNumber, MaxPartyMemberCount, MinLevel, MaxLevel, RoomTitle);
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PartyMatchMakeRoomWnd");
    // End:0x30E
    if(int(InviteState) == int(1))
    {
        Debug("방 만든 뒤 초대하기 INVITE_MAKEROOM");
        Class'NWindow.PartyMatchAPI'.static.RequestAskJoinPartyRoom(InvitedName);
        InviteState = 0;
    }
    return;
}

function OnCancelButtonClick()
{
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PartyMatchMakeRoomWnd");
    // End:0x3E
    if(int(InviteState) == int(1))
    {
        InviteState = 0;
    }
    return;
}

function SetRoomNumber(int a_RoomNumber)
{
    RoomNumber = a_RoomNumber;
    return;
}

function SetTitle(string a_Title)
{
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchMakeRoomWnd.TitleEditBox", a_Title);
    return;
}

function SetMinLevel(int a_MinLevel)
{
    MinLevelEditBox.SetString(string(a_MinLevel));
    return;
}

function SetMaxLevel(int a_MaxLevel)
{
    MaxLevelEditBox.SetString(string(a_MaxLevel));
    return;
}

function SetMaxPartyMemberCount(int a_MaxPartyMemberCount)
{
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("PartyMatchMakeRoomWnd.MaxPartyMemberCountComboBox", a_MaxPartyMemberCount - 2);
    return;
}
