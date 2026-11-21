class PartyMatchWnd extends PartyMatchWndCommon;

const MAXMEMBER = 12;

var string m_WindowName;
var WindowHandle Me;
var ListCtrlHandle PartyMatchListCtrl;
var ComboBoxHandle LevelFilterComboBox;
var ButtonHandle PrevBtn;
var ButtonHandle NextBtn;
var ButtonHandle AutoJoinBtn;
var ButtonHandle RefreshBtn;
var WindowHandle PartyMatchMakeRoomWnd;
var WindowHandle PartyMatchWaitListWnd;
var WindowHandle PartyMatchOutWaitListWnd;
var EditBoxHandle PartyMatchOutWaitListWnd_MinLevel;
var EditBoxHandle PartyMatchOutWaitListWnd_MaxLevel;
var WindowHandle DisableWnd;
var WindowHandle PartyMatchHistory_Wnd;
var ListCtrlHandle WaitList_ListCtrl;
var TextBoxHandle ActivityPartyTitle_Text;
var TextBoxHandle ActivityParty_Text;
var TextBoxHandle ActivityPartyMemberTitle_Text;
var TextBoxHandle ActivityPartyMember_Text;
var ComboBoxHandle JobFilterComboBox;
var EditBoxHandle PartyMatchOutWaitListWnd_Name;
var int CompletelyQuitPartyMatching;
var bool bOpenStateLobby;
var int CUR_PAGE;
var ListCtrlHandle UnionMatchListCtrl;
var ButtonHandle UnionPrevBtn;
var ButtonHandle UnionNextBtn;
var ButtonHandle UnionRefreshBtn;
var WindowHandle UnionMatchMakeRoomWnd;
var int CUR_PAGE_UNION;
var bool IsInParty;

function InitHandle()
{
    Me = m_hOwnerWnd;
    PartyMatchListCtrl = GetListCtrlHandle("PartyMatchWnd.PartyMatchListCtrl");
    UnionMatchListCtrl = GetListCtrlHandle("PartyMatchWnd.UnionMatchListCtrl");
    LevelFilterComboBox = GetComboBoxHandle("PartyMatchWnd.LevelFilterComboBox");
    PrevBtn = GetButtonHandle("PartyMatchWnd.PrevBtn");
    NextBtn = GetButtonHandle("PartyMatchWnd.NextBtn");
    AutoJoinBtn = GetButtonHandle("PartyMatchWnd.AutoJoinBtn");
    RefreshBtn = GetButtonHandle("PartyMatchWnd.RefreshBtn");
    PartyMatchMakeRoomWnd = GetWindowHandle("PartyMatchMakeRoomWnd");
    PartyMatchWaitListWnd = GetWindowHandle("PartyMatchWaitListWnd");
    PartyMatchOutWaitListWnd = GetWindowHandle("PartyMatchOutWaitListWnd");
    PartyMatchOutWaitListWnd_MinLevel = GetEditBoxHandle("PartyMatchOutWaitListWnd.MinLevel");
    PartyMatchOutWaitListWnd_MaxLevel = GetEditBoxHandle("PartyMatchOutWaitListWnd.MaxLevel");
    JobFilterComboBox = GetComboBoxHandle("PartyMatchOutWaitListWnd.Job");
    PartyMatchOutWaitListWnd_Name = GetEditBoxHandle("PartyMatchOutWaitListWnd.Name");
    UnionPrevBtn = GetButtonHandle("PartyMatchWnd.UnionPrevBtn");
    UnionNextBtn = GetButtonHandle("PartyMatchWnd.UnionNextBtn");
    UnionRefreshBtn = GetButtonHandle("PartyMatchWnd.UnionRefreshBtn");
    UnionMatchMakeRoomWnd = GetWindowHandle("UnionMatchMakeRoomWnd");
    DisableWnd = GetWindowHandle("PartyMatchWnd.DisableWnd");
    PartyMatchHistory_Wnd = GetWindowHandle("PartyMatchWnd.PartyMatchHistory_Wnd");
    WaitList_ListCtrl = GetListCtrlHandle("PartyMatchWnd.PartyMatchHistory_Wnd.WaitList_ListCtrl");
    ActivityPartyTitle_Text = GetTextBoxHandle("PartyMatchWnd.ActivityPartyTitle_Text");
    ActivityParty_Text = GetTextBoxHandle("PartyMatchWnd.ActivityParty_Text");
    ActivityPartyMemberTitle_Text = GetTextBoxHandle("PartyMatchWnd.ActivityPartyMemberTitle_Text");
    ActivityPartyMember_Text = GetTextBoxHandle("PartyMatchWnd.ActivityPartyMember_Text");
    DisableWnd.DisableWindow();
    return;
}

function SetIsInParty(bool B)
{
    IsInParty = B;
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(1540);
    RegisterEvent(1570);
    RegisterEvent(1550);
    RegisterEvent(4010);
    RegisterEvent(4020);
    RegisterEvent(4870);
    RegisterEvent(40);
    RegisterEvent(1551);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    InitHandle();
    Init();
    return;
}

function Init()
{
    CompletelyQuitPartyMatching = 0;
    bOpenStateLobby = false;
    CUR_PAGE = 0;
    CUR_PAGE_UNION = 0;
    IsInParty = false;
    LevelFilterComboBox.SetSelectedNum(1);
    return;
}

function OnShow()
{
    PlayConsoleSound(5);
    PartyMatchHistory_Wnd.HideWindow();
    DisableCurrentWindow(false);
    PartyMatchListCtrl.ShowScrollBar(false);
    UnionMatchListCtrl.DeleteAllItem();
    // End:0x67
    if(!getInstanceUIData().getIsArenaServer())
    {
        Me.SetTimer(1, 1000);
    }
    CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onShow windowName=PartyMatchWnd");
    return;
}

function OnTimer(int TimerID)
{
    // End:0x22
    if(TimerID == 1)
    {
        RequestUnionRoomList(1);
        Me.KillTimer(1);
    }
    return;
}

function OnSendPacketWhenHiding()
{
    Class'NWindow.PartyMatchAPI'.static.RequestExitPartyMatchingWaitingRoom();
    return;
}

function OnHide()
{
    PlayConsoleSound(6);
    PartyMatchMakeRoomWnd.HideWindow();
    PartyMatchHistory_Wnd.HideWindow();
    DisableCurrentWindow(false);
    CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onHide");
    return;
}

function OnEvent(int a_EventID, string param)
{
    local PartyMatchMakeRoomWnd script;

    switch(a_EventID)
    {
        // End:0xCC
        case 1540:
            // End:0x80
            if(CompletelyQuitPartyMatching == 1)
            {
                Class'NWindow.PartyMatchAPI'.static.RequestExitPartyMatchingWaitingRoom();
                Me.HideWindow();
                script = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));
                script.OnCancelButtonClick();
                CompletelyQuitPartyMatching = 0;
                SetWaitListWnd(false);                
            }
            else
            {
                UpdateWaitListWnd();
                // End:0xBA
                if(Me.IsShowWindow() == false)
                {
                    Me.ShowWindow();
                    PartyMatchListCtrl.ShowScrollBar(false);
                }
                Me.SetFocus();
            }
            // End:0x169
            break;
        // End:0xE2
        case 1570:
            HandlePartyMatchList(param);
            // End:0x169
            break;
        // End:0xFC
        case 1550:
            Me.HideWindow();
            // End:0x169
            break;
        // End:0x112
        case 4010:
            HandleListMpccWaitingStart(param);
            // End:0x169
            break;
        // End:0x128
        case 4020:
            HandleListMpccWaitingRoomInfo(param);
            // End:0x169
            break;
        // End:0x139
        case 4870:
            HandlePartyToggle();
            // End:0x169
            break;
        // End:0x150
        case 40:
            SetIsInParty(false);
            bOpenStateLobby = false;
            // End:0x169
            break;
        // End:0x166
        case 1551:
            updatePartyMatchingRoomHistory(param);
            // End:0x169
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function updatePartyMatchingRoomHistory(string param)
{
    local int i, Count;
    local string masterName, roomName;
    local LVDataRecord Record;

    Debug("파티 히스토리 " @ param);
    WaitList_ListCtrl.DeleteAllItem();
    Record.LVDataList.Length = 2;
    ParseInt(param, "Count", Count);
    i = 0;
    J0x58:

    // End:0x10D [Loop If]
    if(i < Count)
    {
        roomName = "";
        masterName = "";
        ParseString(param, "MasterName_" $ string(i), masterName);
        ParseString(param, "RoomName_" $ string(i), roomName);
        Record.LVDataList[0].szData = roomName;
        Record.LVDataList[1].szData = masterName;
        WaitList_ListCtrl.InsertRecord(Record);
        i++;
        // [Loop Continue]
        goto J0x58;
    }
    return;
}

function OnMinimize()
{
    CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onMinimize");
    return;
}

function HandlePartyToggle()
{
    local WindowHandle TaskWnd, TaskWnd2;
    local PartyMatchRoomWnd p2_script;

    TaskWnd = GetWindowHandle("PartyMatchWnd");
    TaskWnd2 = GetWindowHandle("PartyMatchRoomWnd");
    p2_script = PartyMatchRoomWnd(GetScript("PartyMatchRoomWnd"));
    // End:0x79
    if(TaskWnd.IsShowWindow())
    {
        ClosePartyMatchingWnd();        
    }
    else
    {
        // End:0xAC
        if(TaskWnd2.IsShowWindow())
        {
            TaskWnd2.HideWindow();
            p2_script.OnSendPacketWhenHiding();            
        }
        else
        {
            // End:0xE3
            if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
            {
                TaskWnd2.ShowWindow();                
            }
            else
            {
                RequestPartyRoomListLocal(1);
            }
        }
    }
    return;
}

function ClosePartyMatchingWnd()
{
    local WindowHandle TaskWnd;
    local PartyMatchWnd p_script;

    p_script = PartyMatchWnd(GetScript("PartyMatchWnd"));
    TaskWnd = GetWindowHandle("PartyMatchWnd");
    TaskWnd.HideWindow();
    p_script.OnSendPacketWhenHiding();
    return;
}

function OnButtonTimer(bool bExpired)
{
    // End:0x48
    if(bExpired)
    {
        PrevBtn.EnableWindow();
        NextBtn.EnableWindow();
        AutoJoinBtn.EnableWindow();
        RefreshBtn.EnableWindow();        
    }
    else
    {
        PrevBtn.DisableWindow();
        NextBtn.DisableWindow();
        AutoJoinBtn.DisableWindow();
        RefreshBtn.DisableWindow();
    }
    return;
}

function HandlePartyMatchList(string param)
{
    local int Count, i;
    local LVDataRecord Record;
    local int Number;
    local string PartyRoomName, PartyLeader;
    local int MinLevel, MaxLevel, MinMemberCnt, MaxMemberCnt, j, memberCnt,
	    MemberClassID;

    local string memberName;
    local LVData data1;
    local int totalPartyMemberCount, totalPartyCount;

    ParseInt(param, "TotalPartyCount", totalPartyCount);
    ParseInt(param, "TotalPartyMemberCount", totalPartyMemberCount);
    ActivityParty_Text.SetText(MakeFullSystemMsg(GetSystemMessage(1983), string(totalPartyCount)));
    ActivityPartyMember_Text.SetText(MakeFullSystemMsg(GetSystemMessage(3305), string(totalPartyMemberCount)));
    PartyMatchListCtrl.DeleteAllItem();
    Record.LVDataList.Length = 7 + (12 / 2);
    ParseInt(param, "PageNum", CUR_PAGE);
    ParseInt(param, "RoomCount", Count);
    i = 0;
    J0xF6:

    // End:0x425 [Loop If]
    if(i < Count)
    {
        ParseInt(param, "RoomNum_" $ string(i), Number);
        ParseString(param, "Leader_" $ string(i), PartyLeader);
        ParseInt(param, "MinLevel_" $ string(i), MinLevel);
        ParseInt(param, "MaxLevel_" $ string(i), MaxLevel);
        ParseInt(param, "CurMember_" $ string(i), MinMemberCnt);
        ParseInt(param, "MaxMember_" $ string(i), MaxMemberCnt);
        // End:0x247
        if(!getInstanceUIData().getIsClassicServer())
        {
            // End:0x21C
            if(MaxLevel == getInstanceUIData().MAXLV)
            {
                MaxLevel = getInstanceUIData().85;
            }
            // End:0x247
            if(MinLevel == getInstanceUIData().MAXLV)
            {
                MinLevel = getInstanceUIData().85;
            }
        }
        ParseString(param, "RoomName_" $ string(i), PartyRoomName);
        ParseInt(param, "MemberCnt_" $ string(i), memberCnt);
        Record.LVDataList[0].szData = string(Number);
        Record.LVDataList[1].szData = PartyLeader;
        Record.LVDataList[2].szData = PartyRoomName;
        Record.LVDataList[3].szData = (string(MinLevel) $ "-") $ string(MaxLevel);
        Record.LVDataList[4].szData = (string(MinMemberCnt) $ "/") $ string(MaxMemberCnt);
        Record.LVDataList[5].szData = string(memberCnt);
        j = 0;
        J0x349:

        // End:0x407 [Loop If]
        if(j < memberCnt)
        {
            ParseString(param, (("MemberName_" $ string(i)) $ "_") $ string(j), memberName);
            ParseInt(param, (("MemberClassID_" $ string(i)) $ "_") $ string(j), MemberClassID);
            data1.nReserved1 = MemberClassID;
            data1.szData = memberName;
            Record.LVDataList[7 + j] = data1;
            ++j;
            // [Loop Continue]
            goto J0x349;
        }
        PartyMatchListCtrl.InsertRecord(Record);
        ++i;
        // [Loop Continue]
        goto J0xF6;
    }
    return;
}

function DisableCurrentWindow(bool bFlag)
{
    DisableWnd.DisableWindow();
    // End:0x2A
    if(bFlag)
    {
        DisableWnd.ShowWindow();        
    }
    else
    {
        DisableWnd.HideWindow();
    }
    return;
}

function OnClickButton(string a_strButtonName)
{
    switch(a_strButtonName)
    {
        // End:0x1F
        case "RefreshBtn":
            OnRefreshBtnClick();
            // End:0x228
            break;
        // End:0x34
        case "PrevBtn":
            OnPrevBtnClick();
            // End:0x228
            break;
        // End:0x49
        case "NextBtn":
            OnNextBtnClick();
            // End:0x228
            break;
        // End:0x62
        case "MakeRoomBtn":
            OnMakeRoomBtnClick();
            // End:0x228
            break;
        // End:0x7B
        case "AutoJoinBtn":
            OnAutoJoinBtnClick();
            // End:0x228
            break;
        // End:0x97
        case "WaitListButton":
            OnWaitListButton();
            // End:0x228
            break;
        // End:0xB4
        case "UnionRefreshBtn":
            OnUnionRefreshBtn();
            // End:0x228
            break;
        // End:0xCE
        case "UnionPrevBtn":
            OnUnionPrevBtn();
            // End:0x228
            break;
        // End:0xE8
        case "UnionNextBtn":
            OnUnionNextBtn();
            // End:0x228
            break;
        // End:0x19E
        case "PartyMatchHistory_Btn":
            // End:0x139
            if(GetWindowHandle("PartyMatchWaitListWnd").IsShowWindow())
            {
                SetWaitListWnd(false);
                ShowHideWaitListWnd();
            }
            DisableCurrentWindow(true);
            PartyMatchHistory_Wnd.ShowWindow();
            PartyMatchHistory_Wnd.SetFocus();
            Debug("Call --> RequestPartyMatchingHistory()");
            Class'NWindow.PartyMatchAPI'.static.RequestPartyMatchingHistory();
            // End:0x228
            break;
        // End:0x1AE
        case "CloseButton":
        // End:0x1D5
        case "Close_Btn":
            PartyMatchHistory_Wnd.HideWindow();
            DisableCurrentWindow(false);
            // End:0x228
            break;
        // End:0x225
        case "Refresh_Btn":
            Debug("Call --> RequestPartyMatchingHistory()");
            Class'NWindow.PartyMatchAPI'.static.RequestPartyMatchingHistory();
            // End:0x228
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnWaitListButton()
{
    ToggleWaitListWnd();
    UpdateWaitListWnd();
    return;
}

function OnRefreshBtnClick()
{
    RequestPartyRoomListLocal(1);
    return;
}

function OnPrevBtnClick()
{
    local int WantedPageNum;

    // End:0x15
    if(1 >= CUR_PAGE)
    {
        WantedPageNum = 1;        
    }
    else
    {
        WantedPageNum = CUR_PAGE - 1;
    }
    RequestPartyRoomListLocal(WantedPageNum);
    return;
}

function OnNextBtnClick()
{
    RequestPartyRoomListLocal(CUR_PAGE + 1);
    return;
}

function RequestPartyRoomListLocal(int a_Page)
{
    Class'NWindow.PartyMatchAPI'.static.RequestPartyRoomList(a_Page, GetLocationFilter(), GetLevelFilter());
    return;
}

function OnMakeRoomBtnClick()
{
    local PartyMatchMakeRoomWnd script;
    local UserInfo PlayerInfo;
    local int MAX_LEVEL;

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
    // End:0x149
    if(script != none)
    {
        script.SetRoomNumber(0);
        script.SetTitle(GetSystemMessage(1398));
        script.SetMaxPartyMemberCount(12);
        // End:0x149
        if(GetPlayerInfo(PlayerInfo))
        {
            // End:0xED
            if((PlayerInfo.nLevel - 5) > 0)
            {
                script.SetMinLevel(PlayerInfo.nLevel - 5);                
            }
            else
            {
                script.SetMinLevel(1);
            }
            // End:0x135
            if((PlayerInfo.nLevel + 5) <= MAX_LEVEL)
            {
                script.SetMaxLevel(PlayerInfo.nLevel + 5);                
            }
            else
            {
                script.SetMaxLevel(MAX_LEVEL);
            }
        }
    }
    script.InviteState = script.0;
    PartyMatchMakeRoomWnd.ShowWindow();
    PartyMatchMakeRoomWnd.SetFocus();
    return;
}

function OnDBClickListCtrlRecord(string a_ListCtrlName)
{
    local int SelectedRecordIndex;
    local LVDataRecord Record;

    // End:0x71
    if(a_ListCtrlName == "PartyMatchListCtrl")
    {
        SelectedRecordIndex = PartyMatchListCtrl.GetSelectedIndex();
        PartyMatchListCtrl.GetRec(SelectedRecordIndex, Record);
        Class'NWindow.PartyMatchAPI'.static.RequestJoinPartyRoom(int(Record.LVDataList[0].szData));        
    }
    else
    {
        // End:0xE0
        if(a_ListCtrlName == "UnionMatchListCtrl")
        {
            SelectedRecordIndex = UnionMatchListCtrl.GetSelectedIndex();
            UnionMatchListCtrl.GetRec(SelectedRecordIndex, Record);
            Class'NWindow.PartyMatchAPI'.static.RequestJoinMpccRoom(int(Record.LVDataList[0].szData), 0);
        }
    }
    return;
    return;
}

function OnAutoJoinBtnClick()
{
    Class'NWindow.PartyMatchAPI'.static.RequestJoinPartyRoomAuto(CUR_PAGE, GetLocationFilter(), GetLevelFilter());
    return;
}

function int GetLocationFilter()
{
    return -1;
    return;
}

function int GetLevelFilter()
{
    return LevelFilterComboBox.GetSelectedNum();
    return;
}

function SetWaitListWnd(bool bShow)
{
    bOpenStateLobby = bShow;
    return;
}

function ShowHideWaitListWnd()
{
    // End:0x2A
    if(bOpenStateLobby)
    {
        PartyMatchOutWaitListWnd.ShowWindow();
        PartyMatchWaitListWnd.ShowWindow();        
    }
    else
    {
        PartyMatchOutWaitListWnd.HideWindow();
        PartyMatchWaitListWnd.HideWindow();
    }
    return;
}

function UpdateWaitListWnd()
{
    local int MinLevel, MaxLevel;
    local string strName;

    // End:0x71
    if(IsShowWaitListWnd())
    {
        MinLevel = int(PartyMatchOutWaitListWnd_MinLevel.GetString());
        MaxLevel = int(PartyMatchOutWaitListWnd_MaxLevel.GetString());
        strName = PartyMatchOutWaitListWnd_Name.GetString();
        RequestPartyMatchWaitList(1, MinLevel, MaxLevel, JobFilterComboBox.GetSelectedNum(), strName);
    }
    return;
}

function ToggleWaitListWnd()
{
    bOpenStateLobby = !bOpenStateLobby;
    ShowHideWaitListWnd();
    return;
}

function bool IsShowWaitListWnd()
{
    return bOpenStateLobby;
    return;
}

function HandleListMpccWaitingStart(string param)
{
    local int ListCount;

    ParseInt(param, "Page", CUR_PAGE_UNION);
    ParseInt(param, "listCount", ListCount);
    UnionMatchListCtrl.DeleteAllItem();
    // End:0x5A
    if(CUR_PAGE_UNION > 1)
    {
        UnionPrevBtn.EnableWindow();
    }
    // End:0x74
    if(ListCount > 0)
    {
        UnionNextBtn.EnableWindow();
    }
    return;
}

function HandleListMpccWaitingRoomInfo(string param)
{
    local LVDataRecord Record;
    local int RoomNum;
    local string Title, masterName;
    local int MinLevelLimit, MaxLevelLimit, CurrentJoinMemberCnt, MaxMemberLimit;

    Record.LVDataList.Length = 5;
    ParseInt(param, "RoomNum", RoomNum);
    ParseString(param, "Title", Title);
    ParseString(param, "MasterName", masterName);
    ParseInt(param, "MinLevelLimit", MinLevelLimit);
    ParseInt(param, "MaxLevelLimit", MaxLevelLimit);
    ParseInt(param, "CurrentJoinMemberCnt", CurrentJoinMemberCnt);
    ParseInt(param, "MaxMemberLimit", MaxMemberLimit);
    Record.LVDataList[0].szData = string(RoomNum);
    Record.LVDataList[1].szData = Title;
    Record.LVDataList[2].szData = masterName;
    Record.LVDataList[3].szData = (string(MinLevelLimit) $ "-") $ string(MaxLevelLimit);
    Record.LVDataList[4].szData = (string(CurrentJoinMemberCnt) $ "/") $ string(MaxMemberLimit);
    UnionMatchListCtrl.InsertRecord(Record);
    return;
}

function OnUnionRefreshBtn()
{
    RequestUnionRoomList(1);
    return;
}

function OnUnionPrevBtn()
{
    local int WantedPageNum;

    // End:0x15
    if(1 >= CUR_PAGE_UNION)
    {
        WantedPageNum = 1;        
    }
    else
    {
        WantedPageNum = CUR_PAGE_UNION - 1;
    }
    RequestUnionRoomList(WantedPageNum);
    return;
}

function OnUnionNextBtn()
{
    RequestUnionRoomList(CUR_PAGE_UNION + 1);
    return;
}

function RequestUnionRoomList(int a_Page)
{
    UnionPrevBtn.DisableWindow();
    UnionNextBtn.DisableWindow();
    Class'NWindow.PartyMatchAPI'.static.RequestListMpccWaiting(a_Page, GetLocationFilter(), GetLevelFilter());
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="PartyMatchWnd"
}