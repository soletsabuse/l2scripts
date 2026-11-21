class PartyMatchWaitListWnd extends PartyMatchWndCommon;

var int entire_page;
var int current_page;
var int MinLevel;
var int MaxLevel;
var int RoomNumber;
var int MaxPartyMemberCount;
var int LootingMethodID;
var string m_WindowName;
var ListCtrlHandle m_hPartyMatchWaitListWndWaitListCtrl;
var ComboBoxHandle JobFilterComboBox;
var string strName;
var int Job;
var EditBoxHandle m_MinLevelEditBox;
var EditBoxHandle m_MaxLevelEditBox;
var int MyMembershipType;

function OnRegisterEvent()
{
    RegisterEvent(1550);
    RegisterEvent(1610);
    RegisterEvent(1620);
    RegisterEvent(40);
    return;
}

function OnLoad()
{
    entire_page = 1;
    current_page = 1;
    m_MinLevelEditBox = GetEditBoxHandle("PartyMatchWaitListWnd.MinLevel");
    m_MinLevelEditBox.DisableWindow();
    m_MaxLevelEditBox = GetEditBoxHandle("PartyMatchWaitListWnd.MaxLevel");
    m_MaxLevelEditBox.DisableWindow();
    m_hPartyMatchWaitListWndWaitListCtrl = GetListCtrlHandle(m_WindowName $ ".WaitListCtrl");
    JobFilterComboBox = GetComboBoxHandle("PartyMatchWaitListWnd.Job");
    setRoleStringJobCombox();
    return;
}

function setRoleStringJobCombox()
{
    local int i;

    JobFilterComboBox.AddStringWithReserved(GetSystemString(1046), 0);
    i = 1;
    J0x22:

    // End:0x65 [Loop If]
    if(i <= getInstanceUIData().9)
    {
        JobFilterComboBox.AddStringWithReserved(GetClassRoleNameByRole(int(byte(i))), i);
        i++;
        // [Loop Continue]
        goto J0x22;
    }
    return;
}

function OnShow()
{
    current_page = 1;
    return;
}

function OnEvent(int a_EventID, string param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 1550:
            HandlePartyMatchRoomStart(param);
            // End:0x5A
            break;
        // End:0x33
        case 1610:
            HandlePartyMatchWaitListStart(param);
            // End:0x5A
            break;
        // End:0x49
        case 1620:
            HandlePartyMatchWaitList(param);
            // End:0x5A
            break;
        // End:0x57
        case 40:
            HandleRestart();
            // End:0x5A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleRestart()
{
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchWaitListWnd.Name", "");
    return;
}

function UpdateMyMembershipType(int MembershipType)
{
    MyMembershipType = MembershipType;
    // End:0x4D
    if(getInstanceUIData().getIsClassicServer())
    {
        m_MinLevelEditBox.SetString(string(MinLevel));
        m_MaxLevelEditBox.SetString(string(MaxLevel));        
    }
    else
    {
        switch(MyMembershipType)
        {
            // End:0x141
            case 1:
                MinLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox"));
                MaxLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox"));
                // End:0xE6
                if(MinLevel == 0)
                {
                    MinLevel = 1;
                }
                // End:0xF8
                if(MaxLevel == 0)
                {
                    MaxLevel = 1;
                }
                // End:0x112
                if(MinLevel > MaxLevel)
                {
                    MaxLevel = MinLevel;
                }
                m_MinLevelEditBox.SetString(string(MinLevel));
                m_MaxLevelEditBox.SetString(string(MaxLevel));
                // End:0x1D2
                break;
            // End:0x145
            case 0:
            // End:0x1CF
            case 2:
                // End:0x175
                if(MaxLevel == getInstanceUIData().MAXLV)
                {
                    MaxLevel = getInstanceUIData().85;
                }
                // End:0x1A0
                if(MinLevel == getInstanceUIData().MAXLV)
                {
                    MinLevel = getInstanceUIData().85;
                }
                m_MinLevelEditBox.SetString(string(MinLevel));
                m_MaxLevelEditBox.SetString(string(MaxLevel));
                // End:0x1D2
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    return;
}

function HandlePartyMatchRoomStart(string param)
{
    ParseInt(param, "RoomNum", RoomNumber);
    ParseInt(param, "MaxMember", MaxPartyMemberCount);
    ParseInt(param, "MinLevel", MinLevel);
    ParseInt(param, "MaxLevel", MaxLevel);
    ParseInt(param, "LootingMethodID", LootingMethodID);
    return;
}

function HandlePartyMatchWaitListStart(string param)
{
    local int AllCount, Count;
    local string totalPages, currentPage, page_info;

    ParseInt(param, "AllCount", AllCount);
    ParseInt(param, "Count", Count);
    totalPages = string((AllCount / 64) + 1);
    entire_page = (AllCount / 64) + 1;
    currentPage = string(current_page);
    page_info = (currentPage $ "/") $ totalPages;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchWaitListWnd.MemberCount", page_info);
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("PartyMatchWaitListWnd.WaitListCtrl");
    CheckButtonAlive();
    return;
}

function HandlePartyMatchWaitList(string param)
{
    local string Name;
    local int ClassID, Level;
    local LVDataRecord Record;
    local int RestrictZoneCnt;
    local string RestrictZoneID;
    local int temp, i;

    RestrictZoneID = "";
    ParseString(param, "Name", Name);
    ParseInt(param, "ClassID", ClassID);
    ParseInt(param, "Level", Level);
    ParseInt(param, "RestrictZoneCnt", RestrictZoneCnt);
    // End:0x82
    if(RestrictZoneCnt == 0)
    {
        RestrictZoneID = "";
    }
    i = 0;
    J0x89:

    // End:0x108 [Loop If]
    if(i < RestrictZoneCnt)
    {
        ParseInt(param, "RestrictZoneID_" $ string(i), temp);
        // End:0xED
        if(i != 0)
        {
            RestrictZoneID = (RestrictZoneID $ ",") $ GetInZoneNameWithZoneID(temp);
            // [Explicit Continue]
            goto J0xFE;
        }
        RestrictZoneID = GetInZoneNameWithZoneID(temp);
        J0xFE:

        i++;
        // [Loop Continue]
        goto J0x89;
    }
    Record.LVDataList.Length = 5;
    Record.LVDataList[0].szData = Name;
    Record.LVDataList[1].szTexture = GetClassRoleIconName(ClassID);
    Record.LVDataList[1].nTextureWidth = 11;
    Record.LVDataList[1].nTextureHeight = 11;
    Record.LVDataList[1].szData = string(ClassID);
    Record.LVDataList[1].HiddenStringForSorting = string(GetClassRoleType(ClassID));
    Record.LVDataList[2].szData = GetAmbiguousLevelString(Level, false);
    Record.LVDataList[3].szData = RestrictZoneID;
    Record.nReserved1 = (Level);
    Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("PartyMatchWaitListWnd.WaitListCtrl", Record);
    return;
}

function OnClickButton(string a_strButtonName)
{
    switch(a_strButtonName)
    {
        // End:0x22
        case "RefreshButton":
            OnRefreshButtonClick();
            // End:0xD0
            break;
        // End:0x3D
        case "WhisperButton":
            OnWhisperButtonClick();
            // End:0xD0
            break;
        // End:0x5C
        case "PartyInviteButton":
            OnInviteButtonClick();
            // End:0xD0
            break;
        // End:0x75
        case "CloseButton":
            OnCloseButtonClick();
            // End:0xD0
            break;
        // End:0x8D
        case "btn_Search":
            OnSearchBtnClick();
            // End:0xD0
            break;
        // End:0xA3
        case "prev_btn":
            OnPrevbuttonClick();
            // End:0xD0
            break;
        // End:0xB9
        case "next_btn":
            OnNextbuttonClick();
            // End:0xD0
            break;
        // End:0xCD
        case "btn_Reset":
            OnResetbuttonClick();
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnRefreshButtonClick()
{
    MinLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchWaitListWnd.MinLevel"));
    MaxLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchWaitListWnd.MaxLevel"));
    Job = JobFilterComboBox.GetSelectedNum();
    strName = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchWaitListWnd.Name");
    RequestPartyMatchWaitList(current_page, MinLevel, MaxLevel, Job, strName);
    return;
}

function OnNextbuttonClick()
{
    current_page = current_page + 1;
    RequestPartyMatchWaitList(current_page, MinLevel, MaxLevel, Job, strName);
    return;
}

function OnPrevbuttonClick()
{
    current_page = current_page - 1;
    RequestPartyMatchWaitList(current_page, MinLevel, MaxLevel, Job, strName);
    return;
}

function OnSearchBtnClick()
{
    MinLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchWaitListWnd.MinLevel"));
    MaxLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchWaitListWnd.MaxLevel"));
    // End:0x8A
    if(MinLevel > GetMaxLevel())
    {
        MinLevel = GetMaxLevel();
    }
    // End:0xA6
    if(MaxLevel > GetMaxLevel())
    {
        MaxLevel = GetMaxLevel();
    }
    Job = JobFilterComboBox.GetSelectedNum();
    strName = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchWaitListWnd.Name");
    current_page = 1;
    RequestPartyMatchWaitList(current_page, MinLevel, MaxLevel, Job, strName);
    return;
}

function OnWhisperButtonClick()
{
    local LVDataRecord Record;
    local string szData1;

    m_hPartyMatchWaitListWndWaitListCtrl.GetSelectedRec(Record);
    szData1 = Record.LVDataList[0].szData;
    // End:0x4C
    if(szData1 != "")
    {
        SetChatMessage(("\"" $ szData1) $ " ");
    }
    return;
}

function OnInviteButtonClick()
{
    local LVDataRecord Record;

    m_hPartyMatchWaitListWndWaitListCtrl.GetSelectedRec(Record);
    Class'NWindow.PartyMatchAPI'.static.RequestAskJoinPartyRoom(Record.LVDataList[0].szData);
    return;
}

function OnCloseButtonClick()
{
    local PartyMatchWnd script;

    script = PartyMatchWnd(GetScript("PartyMatchWnd"));
    // End:0x4A
    if(script != none)
    {
        script.SetWaitListWnd(false);
        script.ShowHideWaitListWnd();
    }
    return;
}

function OnDBClickListCtrlRecord(string a_ListCtrlName)
{
    local LVDataRecord Record;

    // End:0x1A
    if(a_ListCtrlName != "WaitListCtrl")
    {
        return;
    }
    m_hPartyMatchWaitListWndWaitListCtrl.GetSelectedRec(Record);
    SetChatMessage(("\"" $ Record.LVDataList[0].szData) $ " ");
    return;
}

function OnResetbuttonClick()
{
    JobFilterComboBox.SetSelectedNum(0);
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchWaitListWnd.Name", "");
    Job = 0;
    strName = "";
    return;
}

function MakeRoomFirst(int TargetLevel, string InviteTargetName)
{
    local PartyMatchMakeRoomWnd script;
    local UserInfo PlayerInfo;
    local int LevelMin, LevelMax, MAX_LEVEL;

    // End:0x2B
    if(getInstanceUIData().getIsClassicServer())
    {
        MAX_LEVEL = getInstanceUIData().MAXLV;        
    }
    else
    {
        MAX_LEVEL = getInstanceUIData().85;
    }
    script = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));
    // End:0x1B0
    if(script != none)
    {
        script.InviteState = script.1;
        script.InvitedName = InviteTargetName;
        script.SetRoomNumber(0);
        script.SetTitle(GetSystemMessage(1398));
        script.SetMaxPartyMemberCount(12);
        // End:0x1B0
        if(GetPlayerInfo(PlayerInfo))
        {
            // End:0x119
            if(TargetLevel < PlayerInfo.nLevel)
            {
                LevelMin = TargetLevel;
                LevelMax = PlayerInfo.nLevel;                
            }
            else
            {
                LevelMin = PlayerInfo.nLevel;
                LevelMax = TargetLevel;
            }
            // End:0x15E
            if((LevelMin - 5) > 0)
            {
                script.SetMinLevel(LevelMin - 5);                
            }
            else
            {
                script.SetMinLevel(1);
            }
            // End:0x19C
            if((LevelMax + 5) <= MAX_LEVEL)
            {
                script.SetMaxLevel(LevelMax + 5);                
            }
            else
            {
                script.SetMaxLevel(MAX_LEVEL);
            }
        }
    }
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PartyMatchMakeRoomWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyMatchMakeRoomWnd");
    return;
}

function CheckButtonAlive()
{
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("PartyMatchWaitListWnd.prev_btn");
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("PartyMatchWaitListWnd.next_btn");
    // End:0x98
    if(current_page == 1)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("PartyMatchWaitListWnd.prev_btn");
    }
    // End:0xD6
    if(current_page == entire_page)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("PartyMatchWaitListWnd.next_btn");
    }
    return;
}

defaultproperties
{
    m_WindowName="PartyMatchWaitListWnd"
}