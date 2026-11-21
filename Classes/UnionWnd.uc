class UnionWnd extends UICommonAPI;

const UNION_SKILL_AVAILABLILITY = 1030;
const UNION_STATISTIC = 1031;

enum eCommandChannelRoutingType
{
    CCRT_LEADER,                    // 0
    CCRT_FINDERS_KEEPERS            // 1
};

var int currentRoutingType;
var bool m_bChOpened;
var string m_UnionOwnerName;
var string m_userName;
var int m_PartyNum;
var int m_NearNum;
var int m_TotalKillNum;
var int m_TotalDeathNum;
var int m_PartyMemberNum;
var int m_SearchedMasterID;
var WindowHandle Me;
var WindowHandle PartyMemberWnd;
var AnimTextureHandle UnionKillTx;
var AnimTextureHandle UnionDeathTx;
var TextBoxHandle txtOwner;
var TextBoxHandle txtRoutingType;
var ButtonHandle routeUpBtn;
var ButtonHandle routeDownBtn;
var TextBoxHandle txtCountInfo;
var TextBoxHandle txtNearInfo;
var TextBoxHandle txtAliveCount;
var TextBoxHandle txtDeadCount;
var TextBoxHandle txtTotalUnionKillCount;
var TextBoxHandle txtTotalUnionDeathCount;
var ButtonHandle banBtn;
var ButtonHandle quitBtn;
var ButtonHandle btnadenacalculate;
var ButtonHandle btnUnionSkills;
var ListCtrlHandle lstParty;
var UnionDetailWnd UnionDetail;
var UnionMagicSkillWnd UnionMagicSkill;
var UserInfo MyInfo;

function OnRegisterEvent()
{
    RegisterEvent(1360);
    RegisterEvent(1370);
    RegisterEvent(1380);
    RegisterEvent(1390);
    RegisterEvent(1395);
    RegisterEvent(1400);
    RegisterEvent(3550);
    return;
}

function OnLoad()
{
    Me = GetWindowHandle("UnionWnd");
    setPartyMemberWnd();
    txtOwner = GetTextBoxHandle("UnionWnd.txtOwner");
    txtRoutingType = GetTextBoxHandle("UnionWnd.txtRoutingType");
    routeUpBtn = GetButtonHandle("UnionWnd.routeUpBtn");
    routeDownBtn = GetButtonHandle("UnionWnd.routeDownBtn");
    txtCountInfo = GetTextBoxHandle("UnionWnd.txtCountInfo");
    txtNearInfo = GetTextBoxHandle("UnionWnd.txtNearInfo");
    txtAliveCount = GetTextBoxHandle("UnionWnd.txtAliveCount");
    txtDeadCount = GetTextBoxHandle("UnionWnd.txtDeadCount");
    UnionKillTx = GetAnimTextureHandle("UnionWnd.NewKillAnim");
    UnionDeathTx = GetAnimTextureHandle("UnionWnd.NewDeathAnim");
    txtTotalUnionKillCount = GetTextBoxHandle("UnionWnd.txtEnemyKillCount");
    txtTotalUnionDeathCount = GetTextBoxHandle("UnionWnd.txtEnemyDeathCount");
    lstParty = GetListCtrlHandle("UnionWnd.lstParty");
    banBtn = GetButtonHandle("UnionWnd.btnBan");
    quitBtn = GetButtonHandle("UnionWnd.btnOut");
    btnadenacalculate = GetButtonHandle("UnionWnd.btnadenacalculate");
    btnUnionSkills = GetButtonHandle("UnionWnd.btnUnionSkills");
    UnionDetail = UnionDetailWnd(GetScript("UnionDetailWnd"));
    UnionMagicSkill = UnionMagicSkillWnd(GetScript("UnionMagicSkillWnd"));
    m_bChOpened = false;
    m_PartyNum = 0;
    m_TotalKillNum = 0;
    m_TotalDeathNum = 0;
    m_PartyMemberNum = 0;
    m_SearchedMasterID = 0;
    return;
}

function setPartyMemberWnd()
{
    PartyMemberWnd = getUnionDetailWnd();
    return;
}

function WindowHandle getUnionDetailWnd()
{
    return GetWindowHandle("UnionDetailWnd");
    return;
}

function OnShow()
{
    local UserInfo a_UserInfo;

    setPartyMemberWnd();
    GetPlayerInfo(a_UserInfo);
    MyInfo = a_UserInfo;
    m_userName = a_UserInfo.Name;
    PartyMemberWnd.HideWindow();
    checkRoutingTypeButtons();
    return;
}

function OnHide()
{
    UnionMagicSkill.HandleHide();
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x1B
    if(m_bChOpened)
    {
        Me.ShowWindow();        
    }
    else
    {
        Me.HideWindow();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x18
    if(Event_ID == 1360)
    {
        HandleCommandChannelStart();        
    }
    else
    {
        // End:0x30
        if(Event_ID == 1370)
        {
            HandleCommandChannelEnd();            
        }
        else
        {
            // End:0x4D
            if(Event_ID == 1380)
            {
                HandleCommandChannelInfo(param);                
            }
            else
            {
                // End:0x6A
                if(Event_ID == 1390)
                {
                    HandleCommandChannelPartyList(param);                    
                }
                else
                {
                    // End:0x87
                    if(Event_ID == 1395)
                    {
                        HandleCommandChannelPartyUpdate(param);                        
                    }
                    else
                    {
                        // End:0xA4
                        if(Event_ID == 1400)
                        {
                            HandleCommandChannelRoutingType(param);                            
                        }
                        else
                        {
                            // End:0xBE
                            if(Event_ID == 3550)
                            {
                                HandleOnEvent(param);
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function HandleOnEvent(string param)
{
    local int EventID;

    ParseInt(param, "EventID", EventID);
    // End:0x36
    if(EventID == 1030)
    {
        unionAvailableSkills(param);        
    }
    else
    {
        // End:0x50
        if(EventID == 1031)
        {
            unionStatistic(param);
        }
    }
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x58
        case "OwnerEffectMarkCBox":
            requestMarkLeader(int(GetCheckBoxHandle("UnionWnd.OwnerEffectMarkCBox").IsChecked()));
            // End:0x5E
            break;
        // End:0xFFFF
        default:
            // End:0x5E
            break;
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1F
        case "btnRefresh":
            OnRefreshClick();
            // End:0xC0
            break;
        // End:0x33
        case "btnBan":
            OnBanClick();
            // End:0xC0
            break;
        // End:0x47
        case "btnOut":
            OnOutClick();
            // End:0xC0
            break;
        // End:0x62
        case "btnMemberInfo":
            OnMemberInfoClick();
            // End:0xC0
            break;
        // End:0x86
        case "btnUnionSkills":
            RequestBypassToServer("getusl");
            // End:0xC0
            break;
        // End:0x9F
        case "routeUpBtn":
            changeRoutingType(true);
            // End:0xC0
            break;
        // End:0xBA
        case "routeDownBtn":
            changeRoutingType(false);
            // End:0xC0
            break;
        // End:0xFFFF
        default:
            // End:0xC0
            break;
            break;
    }
    return;
}

function OnRefreshClick()
{
    RequestNewInfo();
    return;
}

function unionStatistic(string param)
{
    local int nKillCnt, nDeathCnt;

    ParseInt(param, "ask", nKillCnt);
    ParseInt(param, "reply", nDeathCnt);
    UpdateUnionInfoByType(0, nKillCnt);
    UpdateUnionInfoByType(1, nDeathCnt);
    return;
}

function unionAvailableSkills(string param)
{
    local string skillsLine;
    local array<string> skillsData;

    ParseString(param, "param1", skillsLine);
    skillsData = Arr(skillsLine, "|");
    UnionMagicSkill.addSkills(skillsData);
    return;
}

function OnDBClickListCtrlRecord(string strID)
{
    // End:0x1B
    if(strID == "lstParty")
    {
        RequestPartyMember(true);
    }
    return;
}

function Clear()
{
    requestMarkLeader(int(false));
    GetCheckBoxHandle("UnionWnd.OwnerEffectMarkCBox").SetCheck(false);
    MemberClear();
    txtOwner.SetText("");
    txtRoutingType.SetText(GetSystemString(1383));
    txtCountInfo.SetText("");
    return;
}

function MemberClear()
{
    lstParty.DeleteAllItem();
    return;
}

function RequestNewInfo()
{
    Class'NWindow.CommandChannelAPI'.static.RequestCommandChannelInfo();
    return;
}

function OnBanClick()
{
    local int idx;
    local LVDataRecord Record;
    local string PartyMasterName;

    idx = lstParty.GetSelectedIndex();
    // End:0x75
    if(idx > -1)
    {
        lstParty.GetRec(idx, Record);
        PartyMasterName = Record.LVDataList[0].szData;
        // End:0x75
        if(Len(PartyMasterName) > 0)
        {
            Class'NWindow.CommandChannelAPI'.static.RequestCommandChannelBanParty(PartyMasterName);
        }
    }
    return;
}

function OnOutClick()
{
    Class'NWindow.CommandChannelAPI'.static.RequestCommandChannelWithdraw();
    return;
}

function OnMemberInfoClick()
{
    // End:0x24
    if(PartyMemberWnd.IsShowWindow())
    {
        PartyMemberWnd.HideWindow();        
    }
    else
    {
        RequestPartyMember(true);
    }
    return;
}

function RequestPartyMember(bool bShowWindow)
{
    local LVDataRecord Record;
    local string PartyMasterName;
    local int MasterID;

    m_SearchedMasterID = 0;
    lstParty.GetSelectedRec(Record);
    PartyMasterName = Record.LVDataList[0].szData;
    MasterID = name(Record.nReserved1);
    // End:0xC2
    if((Len(PartyMasterName) > 0) && MasterID > 0)
    {
        // End:0x8A
        if(bShowWindow)
        {
            // End:0x8A
            if(!PartyMemberWnd.IsShowWindow())
            {
                PartyMemberWnd.ShowWindow();
            }
        }
        m_SearchedMasterID = MasterID;
        UnionDetail.SetMasterInfo(PartyMasterName, MasterID);
        Class'NWindow.CommandChannelAPI'.static.RequestCommandChannelPartyMembersInfo(MasterID);
    }
    return;
}

function HandleCommandChannelStart()
{
    Me.ShowWindow();
    Me.SetFocus();
    m_bChOpened = true;
    m_TotalKillNum = 0;
    m_TotalDeathNum = 0;
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnBan");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnOut");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnadenacalculate");
    return;
}

function HandleCommandChannelEnd()
{
    Me.HideWindow();
    Clear();
    m_bChOpened = false;
    return;
}

function HandleCommandChannelInfo(string param)
{
    local string OwnerName;
    local int PartyNum, PartyMemberNum, nNearMembers, nCurrentAliveMembers, nCurrentDeadMembers;

    local string strParam;
    local array<string> strData;

    MemberClear();
    ParseString(param, "OwnerName", strParam);
    strData = Arr(strParam, ";");
    OwnerName = strData[0];
    nNearMembers = int(strData[1]);
    nCurrentAliveMembers = int(strData[2]);
    nCurrentDeadMembers = int(strData[3]);
    m_UnionOwnerName = OwnerName;
    m_NearNum = nNearMembers;
    ParseInt(param, "RoutingType", currentRoutingType);
    ParseInt(param, "PartyNum", PartyNum);
    ParseInt(param, "PartyMemberNum", PartyMemberNum);
    m_PartyNum = PartyNum;
    m_PartyMemberNum = PartyMemberNum;
    txtOwner.SetText(OwnerName);
    txtNearInfo.SetText(string(nNearMembers));
    txtAliveCount.SetText(string(nCurrentAliveMembers));
    txtDeadCount.SetText(string(nCurrentDeadMembers));
    UpdateRoutingType(currentRoutingType);
    UpdateCountInfo();
    // End:0x1D8
    if(OwnerName == m_userName)
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnBan");
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("UnionWnd.btnBan");
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnadenacalculate");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnBan");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("UnionWnd.btnBan");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnadenacalculate");
    }
    checkRoutingTypeButtons();
    checkUnionSkillsButton();
    return;
}

function changeRoutingType(bool bUp)
{
    // End:0x13
    if(bUp)
    {
        currentRoutingType++;        
    }
    else
    {
        currentRoutingType--;
    }
    // End:0x2C
    if(currentRoutingType > 1)
    {
        currentRoutingType = 0;
    }
    // End:0x3E
    if(currentRoutingType < 0)
    {
        currentRoutingType = 1;
    }
    requestChangeRoutingType(currentRoutingType);
    return;
}

function UpdateRoutingType(int Type)
{
    // End:0x28
    if(Type == 0)
    {
        txtRoutingType.SetText(GetSystemString(8084));        
    }
    else
    {
        // End:0x4D
        if(Type == 1)
        {
            txtRoutingType.SetText(GetSystemString(8085));
        }
    }
    return;
}

function HandleCommandChannelPartyList(string param)
{
    local LVDataRecord Record;
    local string masterName, strParam;
    local int MasterID, PartyNum, TotalCount, nKillCnt, nDeathCnt, nPvPDamage,
	    nPvEDamage, nTotalKill, nTotalDeath;

    local array<string> strData;

    ParseString(param, "MasterName", strParam);
    strData = Arr(strParam, ";");
    masterName = strData[0];
    nKillCnt = int(strData[1]);
    nDeathCnt = int(strData[2]);
    nPvPDamage = int(strData[3]);
    nPvEDamage = int(strData[4]);
    ParseInt(param, "MasterID", MasterID);
    ParseInt(param, "PartyNum", PartyNum);
    Record.LVDataList.Length = 6;
    Record.nReserved1 = (MasterID);
    Record.LVDataList[0].szData = masterName;
    Record.LVDataList[0].bUseTextColor = masterName == m_UnionOwnerName;
    Record.LVDataList[0].TextColor = getInstanceL2Util().Yellow03;
    Record.LVDataList[1].szData = string(PartyNum);
    Record.LVDataList[1].textAlignment = 2;
    Record.LVDataList[2].szData = string(nKillCnt);
    Record.LVDataList[2].textAlignment = 2;
    Record.LVDataList[3].szData = string(nDeathCnt);
    Record.LVDataList[3].textAlignment = 2;
    Record.LVDataList[4].HiddenStringForSorting = string(nPvPDamage);
    Record.LVDataList[4].szData = convertDamageToString(nPvPDamage);
    Record.LVDataList[5].HiddenStringForSorting = string(nPvEDamage);
    Record.LVDataList[5].szData = convertDamageToString(nPvEDamage);
    lstParty.InsertRecord(Record);
    // End:0x2A3
    if((m_SearchedMasterID > 0) && m_SearchedMasterID == MasterID)
    {
        // End:0x2A3
        if(PartyMemberWnd.IsShowWindow())
        {
            TotalCount = lstParty.GetRecordCount();
            // End:0x29C
            if(TotalCount > 0)
            {
                lstParty.SetSelectedIndex(TotalCount - 1, false);
            }
            RequestPartyMember(false);
        }
    }
    UpdateCountInfo();
    checkUnionSkillsButton();
    checkRoutingTypeButtons();
    // End:0x2E4
    if(masterName == m_userName)
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnOut");
    }
    return;
}

function HandleCommandChannelPartyUpdate(string param)
{
    local LVDataRecord Record;
    local string masterName, strParam;
    local int SearchIdx, MasterID, MemberCount, Type, nKillCnt, nDeathCnt,
	    nPvPDamage, nPvEDamage;

    local array<string> strData;

    ParseString(param, "MasterName", strParam);
    ParseInt(param, "MasterID", MasterID);
    ParseInt(param, "MemberCount", MemberCount);
    ParseInt(param, "Type", Type);
    strData = Arr(strParam, ";");
    masterName = strData[0];
    nKillCnt = int(strData[1]);
    nDeathCnt = int(strData[2]);
    nPvPDamage = int(strData[3]);
    nPvEDamage = int(strData[4]);
    // End:0xD6
    if(MasterID < 1)
    {
        return;
    }
    switch(Type)
    {
        // End:0x1AC
        case 0:
            SearchIdx = FindMasterID(MasterID);
            // End:0x1A9
            if(SearchIdx > -1)
            {
                lstParty.GetRec(SearchIdx, Record);
                MemberCount = int(Record.LVDataList[1].szData);
                lstParty.DeleteRecord(SearchIdx);
                m_PartyNum--;
                m_PartyMemberNum = m_PartyMemberNum - MemberCount;
                // End:0x1A9
                if(PartyMemberWnd.IsShowWindow())
                {
                    // End:0x1A9
                    if(MasterID == UnionDetail.GetMasterID())
                    {
                        UnionDetail.Clear();
                        PartyMemberWnd.HideWindow();
                    }
                }
            }
            // End:0x318
            break;
        // End:0x312
        case 1:
            Record.LVDataList.Length = 6;
            Record.nReserved1 = (MasterID);
            Record.LVDataList[0].szData = masterName;
            Record.LVDataList[1].szData = string(MemberCount);
            Record.LVDataList[1].textAlignment = 2;
            Record.LVDataList[2].szData = string(nKillCnt);
            Record.LVDataList[2].textAlignment = 2;
            Record.LVDataList[3].szData = string(nDeathCnt);
            Record.LVDataList[3].textAlignment = 2;
            Record.LVDataList[4].HiddenStringForSorting = string(nPvPDamage);
            Record.LVDataList[4].szData = convertDamageToString(nPvPDamage);
            Record.LVDataList[5].HiddenStringForSorting = string(nPvEDamage);
            Record.LVDataList[5].szData = convertDamageToString(nPvEDamage);
            lstParty.InsertRecord(Record);
            m_PartyNum++;
            m_PartyMemberNum = m_PartyMemberNum + MemberCount;
            // End:0x318
            break;
        // End:0xFFFF
        default:
            // End:0x318
            break;
            break;
    }
    UpdateCountInfo();
    checkUnionSkillsButton();
    checkRoutingTypeButtons();
    // End:0x359
    if(masterName == m_userName)
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnOut");
    }
    return;
}

function HandleCommandChannelRoutingType(string param)
{
    local int RoutingType;

    ParseInt(param, "RoutingType", RoutingType);
    UpdateRoutingType(RoutingType);
    return;
}

function int FindMasterID(int MasterID)
{
    local int idx;
    local LVDataRecord Record;
    local int SearchIdx;

    SearchIdx = -1;
    idx = 0;
    J0x12:

    // End:0x72 [Loop If]
    if(idx < lstParty.GetRecordCount())
    {
        lstParty.GetRec(idx, Record);
        // End:0x68
        if(name(Record.nReserved1) == MasterID)
        {
            SearchIdx = idx;
            // [Explicit Break]
            goto J0x72;
        }
        idx++;
        // [Loop Continue]
        goto J0x12;
    }
    J0x72:

    return SearchIdx;
    return;
}

function UpdateUnionInfoByType(int nType, int nVal)
{
    local string prevVal, costString;

    // End:0x15
    if(nVal < 0)
    {
        nVal = 0;        
    }
    else
    {
        // End:0x3A
        if(nVal > 999)
        {
            costString = MakeCostString(string(nVal));            
        }
        else
        {
            costString = string(nVal);
        }
    }
    switch(nType)
    {
        // End:0xD1
        case 0:
            prevVal = txtTotalUnionKillCount.GetText();
            // End:0x78
            if(prevVal == costString)
            {
                return;
            }
            UnionKillTx.SetTimes(1.7000000);
            UnionKillTx.Stop();
            UnionKillTx.SetLoopCount(1);
            UnionKillTx.Play();
            txtTotalUnionKillCount.SetText(costString);
            // End:0x15A
            break;
        // End:0x154
        case 1:
            prevVal = txtTotalUnionDeathCount.GetText();
            // End:0xFB
            if(prevVal == costString)
            {
                return;
            }
            UnionDeathTx.SetTimes(1.7000000);
            UnionDeathTx.Stop();
            UnionDeathTx.SetLoopCount(1);
            UnionDeathTx.Play();
            txtTotalUnionDeathCount.SetText(costString);
            // End:0x15A
            break;
        // End:0xFFFF
        default:
            // End:0x15A
            break;
            break;
    }
    return;
}

function UpdateCountInfo()
{
    txtCountInfo.SetText((((string(m_PartyNum) @ GetSystemString(7673)) $ " / ") $ string(m_PartyMemberNum)) @ GetSystemString(7674));
    return;
}

function UpdatePartyMemberCount(int MasterID, int MemberCount)
{
    local int idx;
    local LVDataRecord Record;

    idx = FindMasterID(MasterID);
    // End:0x9D
    if(idx > -1)
    {
        lstParty.GetRec(idx, Record);
        m_PartyMemberNum = m_PartyMemberNum - int(Record.LVDataList[1].szData);
        m_PartyMemberNum = m_PartyMemberNum + MemberCount;
        Record.LVDataList[1].szData = string(MemberCount);
        lstParty.ModifyRecord(idx, Record);
    }
    UpdateCountInfo();
    return;
}

function OnExitState(name a_NextStateName)
{
    // End:0x15
    if(a_NextStateName == 'LoadingState')
    {
        HandleCommandChannelEnd();
    }
    return;
}

function bool iAmChannelLeader()
{
    return m_userName == m_UnionOwnerName;
    return;
}

function bool iAmPartyLeader()
{
    local int idx;
    local LVDataRecord Record;

    idx = 0;
    J0x07:

    // End:0x61 [Loop If]
    if(idx < lstParty.GetRecordCount())
    {
        lstParty.GetRec(idx, Record);
        // End:0x57
        if(__NFUN_412__(Record.nReserved1, (MyInfo.nID)))
        {
            return true;
        }
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function checkUnionSkillsButton()
{
    // End:0x26
    if((iAmChannelLeader()) || iAmPartyLeader())
    {
        btnUnionSkills.ShowWindow();        
    }
    else
    {
        btnUnionSkills.HideWindow();
    }
    return;
}

function checkRoutingTypeButtons()
{
    // End:0x2A
    if(iAmChannelLeader())
    {
        routeUpBtn.ShowWindow();
        routeDownBtn.ShowWindow();        
    }
    else
    {
        routeUpBtn.HideWindow();
        routeDownBtn.HideWindow();
    }
    return;
}

function requestChangeRoutingType(coerce int nType)
{
    RequestBypassToServer("union_route " @ string(nType));
    return;
}

function requestMarkLeader(coerce int nMarked)
{
    RequestBypassToServer("union_mark " @ string(nMarked));
    return;
}
