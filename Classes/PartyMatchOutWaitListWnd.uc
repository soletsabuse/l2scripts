class PartyMatchOutWaitListWnd extends PartyMatchWndCommon;

const MINLV = 1;

var int entire_page;
var int current_page;
var int MinLevel;
var int MaxLevel;
var string m_WindowName;
var ListCtrlHandle m_hPartyMatchOutWaitListWndWaitListCtrl;
var ComboBoxHandle JobFilterComboBox;
var string strName;
var int Job;
var ButtonHandle SearchBtn;

function OnRegisterEvent()
{
    RegisterEvent(1610);
    RegisterEvent(1620);
    RegisterEvent(40);
    RegisterEvent(8000);
    return;
}

function OnLoad()
{
    local int MAX_LEVEL;

    entire_page = 1;
    current_page = 1;
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.MinLevel", "1");
    // End:0x6E
    if(getInstanceUIData().getIsClassicServer())
    {
        MAX_LEVEL = getInstanceUIData().MAXLV;        
    }
    else
    {
        MAX_LEVEL = getInstanceUIData().85;
    }
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.MaxLevel", string(MAX_LEVEL));
    m_hPartyMatchOutWaitListWndWaitListCtrl = GetListCtrlHandle(m_WindowName $ ".WaitListCtrl");
    SearchBtn = GetButtonHandle("PartyMatchOutWaitListWnd.btn_Search");
    JobFilterComboBox = GetComboBoxHandle("PartyMatchOutWaitListWnd.Job");
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
    Class'NWindow.UIAPI_EDITBOX'.static.SetFocus("PartyMatchOutWaitListWnd.MaxLevel");
    return;
}

function OnEvent(int a_EventID, string param)
{
    local int MAX_LEVEL;

    switch(a_EventID)
    {
        // End:0x1D
        case 1610:
            HandlePartyMatchWaitListStart(param);
            // End:0xBC
            break;
        // End:0x33
        case 1620:
            HandlePartyMatchWaitList(param);
            // End:0xBC
            break;
        // End:0x41
        case 40:
            HandleRestart();
            // End:0xBC
            break;
        // End:0xB9
        case 8000:
            // End:0x6B
            if(getInstanceUIData().getIsClassicServer())
            {
                MAX_LEVEL = GetMaxLevel();                
            }
            else
            {
                MAX_LEVEL = getInstanceUIData().85;
            }
            Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.MaxLevel", string(MAX_LEVEL));
            // End:0xBC
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleRestart()
{
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.Name", "");
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
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchOutWaitListWnd.MemberCount", page_info);
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("PartyMatchOutWaitListWnd.WaitListCtrl");
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
    Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("PartyMatchOutWaitListWnd.WaitListCtrl", Record);
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
    MinLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.MinLevel"));
    MaxLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.MaxLevel"));
    Job = JobFilterComboBox.GetSelectedNum();
    strName = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.Name");
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
    MinLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.MinLevel"));
    MaxLevel = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.MaxLevel"));
    Job = JobFilterComboBox.GetSelectedNum();
    strName = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchOutWaitListWnd.Name");
    current_page = 1;
    RequestPartyMatchWaitList(current_page, MinLevel, MaxLevel, Job, strName);
    return;
}

function OnWhisperButtonClick()
{
    local LVDataRecord Record;
    local string szData1;

    m_hPartyMatchOutWaitListWndWaitListCtrl.GetSelectedRec(Record);
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

    m_hPartyMatchOutWaitListWndWaitListCtrl.GetSelectedRec(Record);
    MakeRoomFirst(name(Record.nReserved1), Record.LVDataList[0].szData);
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
    m_hPartyMatchOutWaitListWndWaitListCtrl.GetSelectedRec(Record);
    SetChatMessage(("\"" $ Record.LVDataList[0].szData) $ " ");
    return;
}

function OnResetbuttonClick()
{
    local int MAX_LEVEL;

    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.MinLevel", string(1));
    // End:0x60
    if(getInstanceUIData().getIsClassicServer())
    {
        MAX_LEVEL = getInstanceUIData().MAXLV;        
    }
    else
    {
        MAX_LEVEL = getInstanceUIData().85;
    }
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.MaxLevel", string(MAX_LEVEL));
    JobFilterComboBox.SetSelectedNum(0);
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchOutWaitListWnd.Name", "");
    MinLevel = 1;
    MaxLevel = getInstanceUIData().MAXLV;
    Job = 0;
    strName = "";
    return;
}

function OnButtonTimer(bool bExpired)
{
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
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("PartyMatchOutWaitListWnd.prev_btn");
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("PartyMatchOutWaitListWnd.next_btn");
    // End:0xA1
    if(current_page == 1)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("PartyMatchOutWaitListWnd.prev_btn");
    }
    // End:0xE2
    if(current_page == entire_page)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("PartyMatchOutWaitListWnd.next_btn");
    }
    return;
}

defaultproperties
{
    m_WindowName="PartyMatchOutWaitListWnd"
}