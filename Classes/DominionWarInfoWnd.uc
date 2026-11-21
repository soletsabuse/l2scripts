class DominionWarInfoWnd extends UICommonAPI;

var string ClanTexList[17];
var WindowHandle Me;
var WindowHandle DeclaredWarInfo;
var ListCtrlHandle ListCtrlTerritoryWarList;
var TextBoxHandle txtCurrentTerritory;
var TextBoxHandle txtLordNameTitle;
var TextBoxHandle txtLordName;
var TextBoxHandle txtClanNameTitle;
var TextBoxHandle txtClanName;
var TextBoxHandle txtAlleyNameTitle;
var TextBoxHandle txtAlleyName;
var TabHandle TabCtrl;
var TextBoxHandle txtTerritoryWarTimeTitle;
var TextBoxHandle txtCurrentTimeTitle;
var TextBoxHandle txtTerritoryWarTime;
var ButtonHandle btnClose;
var TextBoxHandle txtCurrentTime;
var ButtonHandle btnApplyMachinery;
var ButtonHandle btnClanApplyBtn;
var WindowHandle AttendeeInfo;
var ListCtrlHandle ListCtrlClanList;
var ButtonHandle btnAcceptClan;
var TextBoxHandle txtTotalClanCountHead;
var TextBoxHandle txtTotalMachineryCountHead;
var TextBoxHandle txtTotalClanCount;
var TextBoxHandle txtTotalMachineryCount;
var TextureHandle GroupBoxBg3;
var TextureHandle GroupBoxBg1;
var TextureHandle GroupBoxBg2;
var int m_DominionID;
var string m_DominionName;
var bool m_ClanBtnBool;
var bool m_MachineryBtnBool;

function InitClanTexName()
{
    ClanTexList[0] = "L2UI_CT1.CLAN_DF_TERRITORYWARICON_ADEN";
    ClanTexList[1] = "L2UI_CT1.CLAN_DF_TERRITORYWARICON_DION";
    ClanTexList[2] = "L2UI_CT1.CLAN_DF_TERRITORYWARICON_GIRAN";
    ClanTexList[3] = "L2UI_CT1.CLAN_DF_TERRITORYWARICON_GLUDIO";
    ClanTexList[4] = "L2UI_CT1.CLAN_DF_TERRITORYWARICON_GODARD";
    ClanTexList[5] = "L2UI_CT1.CLAN_DF_TERRITORYWARICON_INNADRIL";
    ClanTexList[6] = "L2UI_CT1.CLAN_DF_TERRITORYWARICON_OREN";
    ClanTexList[7] = "L2UI_CT1.CLAN_DF_TERRITORYWARICON_RUNE";
    ClanTexList[8] = "L2UI_CT1.CLAN_DF_TERRITORYWARICON_SCHUTTGART";
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x1D
    if(1 == 0)
    {
        InitHandle();        
    }
    else
    {
        InitHandleCOD();
    }
    load();
    m_ClanBtnBool = true;
    m_MachineryBtnBool = true;
    btnClanApplyBtn.SetButtonName(1957);
    btnApplyMachinery.SetButtonName(1958);
    Me.SetWindowTitle(GetSystemString(1776));
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(3570);
    RegisterEvent(3580);
    RegisterEvent(3571);
    RegisterEvent(3572);
    return;
}

function InitHandle()
{
    Me = GetHandle("DominionWarInfoWnd");
    DeclaredWarInfo = GetHandle("DominionWarInfoWnd.DeclaredWarInfo");
    ListCtrlTerritoryWarList = ListCtrlHandle(GetHandle("DominionWarInfoWnd.DeclaredWarInfo.ListCtrlTerritoryWarList"));
    txtCurrentTerritory = TextBoxHandle(GetHandle("DominionWarInfoWnd.txtCurrentTerritory"));
    txtLordNameTitle = TextBoxHandle(GetHandle("DominionWarInfoWnd.txtLordNameTitle"));
    txtLordName = TextBoxHandle(GetHandle("DominionWarInfoWnd.txtLordName"));
    txtClanNameTitle = TextBoxHandle(GetHandle("DominionWarInfoWnd.txtClanNameTitle"));
    txtClanName = TextBoxHandle(GetHandle("DominionWarInfoWnd.txtClanName"));
    txtAlleyNameTitle = TextBoxHandle(GetHandle("DominionWarInfoWnd.txtAlleyNameTitle"));
    txtAlleyName = TextBoxHandle(GetHandle("DominionWarInfoWnd.txtAlleyName"));
    TabCtrl = TabHandle(GetHandle("DominionWarInfoWnd.TabCtrl"));
    txtTerritoryWarTimeTitle = TextBoxHandle(GetHandle("DominionWarInfoWnd.txtTerritoryWarTimeTitle"));
    txtCurrentTimeTitle = TextBoxHandle(GetHandle("DominionWarInfoWnd.txtCurrentTimeTitle"));
    txtTerritoryWarTime = TextBoxHandle(GetHandle("DominionWarInfoWnd.txtTerritoryWarTime"));
    btnClose = ButtonHandle(GetHandle("DominionWarInfoWnd.btnClose"));
    txtCurrentTime = TextBoxHandle(GetHandle("DominionWarInfoWnd.txtCurrentTime"));
    btnApplyMachinery = ButtonHandle(GetHandle("DominionWarInfoWnd.btnApplyMachinery"));
    btnClanApplyBtn = ButtonHandle(GetHandle("DominionWarInfoWnd.btnClanApplyBtn"));
    AttendeeInfo = GetHandle("DominionWarInfoWnd.AttendeeInfo");
    ListCtrlClanList = ListCtrlHandle(GetHandle("DominionWarInfoWnd.AttendeeInfo.ListCtrlClanList"));
    btnAcceptClan = ButtonHandle(GetHandle("DominionWarInfoWnd.AttendeeInfo.btnAcceptClan"));
    txtTotalClanCountHead = TextBoxHandle(GetHandle("DominionWarInfoWnd.AttendeeInfo.txtTotalClanCountHead"));
    txtTotalMachineryCountHead = TextBoxHandle(GetHandle("DominionWarInfoWnd.AttendeeInfo.txtTotalMachineryCountHead"));
    txtTotalClanCount = TextBoxHandle(GetHandle("DominionWarInfoWnd.AttendeeInfo.txtTotalClanCount"));
    txtTotalMachineryCount = TextBoxHandle(GetHandle("DominionWarInfoWnd.AttendeeInfo.txtTotalMachineryCount"));
    GroupBoxBg3 = TextureHandle(GetHandle("DominionWarInfoWnd.GroupBoxBg3"));
    GroupBoxBg1 = TextureHandle(GetHandle("DominionWarInfoWnd.GroupBoxBg1"));
    GroupBoxBg2 = TextureHandle(GetHandle("DominionWarInfoWnd.GroupBoxBg2"));
    return;
}

function InitHandleCOD()
{
    Me = GetWindowHandle("DominionWarInfoWnd");
    DeclaredWarInfo = GetWindowHandle("DominionWarInfoWnd.DeclaredWarInfo");
    ListCtrlTerritoryWarList = GetListCtrlHandle("DominionWarInfoWnd.DeclaredWarInfo.ListCtrlTerritoryWarList");
    txtCurrentTerritory = GetTextBoxHandle("DominionWarInfoWnd.txtCurrentTerritory");
    txtLordNameTitle = GetTextBoxHandle("DominionWarInfoWnd.txtLordNameTitle");
    txtLordName = GetTextBoxHandle("DominionWarInfoWnd.txtLordName");
    txtClanNameTitle = GetTextBoxHandle("DominionWarInfoWnd.txtClanNameTitle");
    txtClanName = GetTextBoxHandle("DominionWarInfoWnd.txtClanName");
    txtAlleyNameTitle = GetTextBoxHandle("DominionWarInfoWnd.txtAlleyNameTitle");
    txtAlleyName = GetTextBoxHandle("DominionWarInfoWnd.txtAlleyName");
    TabCtrl = GetTabHandle("DominionWarInfoWnd.TabCtrl");
    txtTerritoryWarTimeTitle = GetTextBoxHandle("DominionWarInfoWnd.txtTerritoryWarTimeTitle");
    txtCurrentTimeTitle = GetTextBoxHandle("DominionWarInfoWnd.txtCurrentTimeTitle");
    txtTerritoryWarTime = GetTextBoxHandle("DominionWarInfoWnd.txtTerritoryWarTime");
    btnClose = GetButtonHandle("DominionWarInfoWnd.btnClose");
    txtCurrentTime = GetTextBoxHandle("DominionWarInfoWnd.txtCurrentTime");
    btnApplyMachinery = GetButtonHandle("DominionWarInfoWnd.btnApplyMachinery");
    btnClanApplyBtn = GetButtonHandle("DominionWarInfoWnd.btnClanApplyBtn");
    AttendeeInfo = GetWindowHandle("DominionWarInfoWnd.AttendeeInfo");
    ListCtrlClanList = GetListCtrlHandle("DominionWarInfoWnd.AttendeeInfo.ListCtrlClanList");
    btnAcceptClan = GetButtonHandle("DominionWarInfoWnd.AttendeeInfo.btnAcceptClan");
    txtTotalClanCountHead = GetTextBoxHandle("DominionWarInfoWnd.AttendeeInfo.txtTotalClanCountHead");
    txtTotalMachineryCountHead = GetTextBoxHandle("DominionWarInfoWnd.AttendeeInfo.txtTotalMachineryCountHead");
    txtTotalClanCount = GetTextBoxHandle("DominionWarInfoWnd.AttendeeInfo.txtTotalClanCount");
    txtTotalMachineryCount = GetTextBoxHandle("DominionWarInfoWnd.AttendeeInfo.txtTotalMachineryCount");
    GroupBoxBg3 = GetTextureHandle("DominionWarInfoWnd.GroupBoxBg3");
    GroupBoxBg1 = GetTextureHandle("DominionWarInfoWnd.GroupBoxBg1");
    GroupBoxBg2 = GetTextureHandle("DominionWarInfoWnd.GroupBoxBg2");
    return;
}

function load()
{
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x26
        case "btnApplyMachinery":
            OnbtnApplyMachineryClick();
            // End:0x61
            break;
        // End:0x43
        case "btnClanApplyBtn":
            OnbtnClanApplyBtnClick();
            // End:0x61
            break;
        // End:0x5E
        case "btnAcceptClan":
            OnbtnAcceptClanClick();
            // End:0x61
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnbtnApplyMachineryClick()
{
    local int PlayerID;

    PlayerID = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerID();
    Debug((((("영지 ID" $ string(m_MachineryBtnBool)) $ "     ") $ string(m_DominionID)) $ "     ") $ string(PlayerID));
    // End:0xAA
    if(m_MachineryBtnBool)
    {
        Debug((((("이프" $ string(m_MachineryBtnBool)) $ "     ") $ string(m_DominionID)) $ "     ") $ string(PlayerID));
        RequestJoinDominionWar(m_DominionID, 0, 1, PlayerID);        
    }
    else
    {
        Debug((((("엘스" $ string(m_MachineryBtnBool)) $ "     ") $ string(m_DominionID)) $ "     ") $ string(PlayerID));
        RequestJoinDominionWar(m_DominionID, 0, 0, PlayerID);
    }
    return;
}

function OnbtnClanApplyBtnClick()
{
    local UserInfo TempUserInfo;
    local int clanID;

    GetPlayerInfo(TempUserInfo);
    clanID = TempUserInfo.nClanID;
    // End:0x39
    if(m_ClanBtnBool)
    {
        RequestJoinDominionWar(m_DominionID, 1, 1, clanID);        
    }
    else
    {
        RequestJoinDominionWar(m_DominionID, 1, 0, clanID);
    }
    return;
}

function OnbtnAcceptClanClick()
{
    return;
}

function OnEvent(int Event_ID, string param)
{
    Debug("Dominion Event ID" $ string(Event_ID));
    switch(Event_ID)
    {
        // End:0x4E
        case 3570:
            ListCtrlTerritoryWarList.DeleteAllItem();
            HandleShowDominionWarJoinList(param);
            // End:0xBA
            break;
        // End:0x64
        case 3580:
            HandleResultJoinDominionWar(param);
            // End:0xBA
            break;
        // End:0x7A
        case 3590:
            HandleDominionInfoCnt(param);
            // End:0xBA
            break;
        // End:0x90
        case 3600:
            HandleDominionInfo(param);
            // End:0xBA
            break;
        // End:0xA6
        case 3571:
            HandleShowDominionWarJoinListEnemyDominionInfo(param);
            // End:0xBA
            break;
        // End:0xB7
        case 3572:
            HandleShowDominionWarJoisnListEnd();
            // End:0xBA
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleShowDominionWarJoinListEnemyDominionInfo(string param)
{
    local int i, enemyDominionID, HaveOwnthingDominionID[9];
    local LVDataRecord Record;
    local LVData data1, data2;
    local Texture DominionFlagTex, DominionFlagTexreset;

    ParseInt(param, "enemyDominionID", enemyDominionID);
    data2.arrTexture.Length = 9;
    i = 1;
    J0x36:

    // End:0x16B [Loop If]
    if(i < 10)
    {
        ParseInt(param, "HaveOwnthingDominionID" $ string(i), HaveOwnthingDominionID[i]);
        DominionFlagTex = DominionFlagTexreset;
        DominionFlagTex = GetDominionFlagIconTex(HaveOwnthingDominionID[i]);
        data2.arrTexture[i - 1].objTex = DominionFlagTex;
        data2.arrTexture[i - 1].Width = 12;
        data2.arrTexture[i - 1].Height = 12;
        data2.arrTexture[i - 1].X = i * 12;
        data2.arrTexture[i - 1].Y = 0;
        data2.arrTexture[i - 1].U = 32;
        data2.arrTexture[i - 1].V = 32;
        i++;
        // [Loop Continue]
        goto J0x36;
    }
    data1.szData = GetCastleName(enemyDominionID);
    Record.LVDataList[0] = data1;
    Record.LVDataList[1] = data2;
    ListCtrlTerritoryWarList.InsertRecord(Record);
    return;
}

function HandleShowDominionWarJoisnListEnd()
{
    return;
}

function HandleShowDominionWarJoinList(string param)
{
    local int DominionID;
    local string ClanName, clanMasterName, allianceName, MyClanJoinDominionID, UserJoinDominionID;

    local int JoinedClanCnt, JoinedUserCnt, NextDominionWarDate, CurrentDate, EnemyDominionCnt;

    Me.ShowWindow();
    ParseInt(param, "DominionID", DominionID);
    ParseInt(param, "JoinedClanCnt", JoinedClanCnt);
    ParseInt(param, "JoinedUserCnt", JoinedUserCnt);
    ParseInt(param, "NextDominionWarDate", NextDominionWarDate);
    ParseInt(param, "CurrentDate", CurrentDate);
    ParseInt(param, "EnemyDominionCnt", EnemyDominionCnt);
    ParseString(param, "ClanName", ClanName);
    ParseString(param, "ClanMasterName", clanMasterName);
    ParseString(param, "AllianceName", allianceName);
    ParseString(param, "MyClanJoinDominionID", MyClanJoinDominionID);
    ParseString(param, "UserJoinDominionID", UserJoinDominionID);
    m_DominionID = DominionID;
    m_DominionName = GetCastleName(DominionID);
    Debug((("MyClanJoinDominionID" @ MyClanJoinDominionID) @ "UserJoinDominionID") @ UserJoinDominionID);
    // End:0x1F7
    if(int(MyClanJoinDominionID) > 0)
    {
        btnClanApplyBtn.SetButtonName(1959);
        m_ClanBtnBool = false;        
    }
    else
    {
        // End:0x220
        if(int(MyClanJoinDominionID) == 0)
        {
            btnClanApplyBtn.SetButtonName(1957);
            m_ClanBtnBool = true;
        }
    }
    // End:0x24C
    if(int(UserJoinDominionID) > 0)
    {
        btnApplyMachinery.SetButtonName(1960);
        m_MachineryBtnBool = false;        
    }
    else
    {
        // End:0x275
        if(int(UserJoinDominionID) == 0)
        {
            btnApplyMachinery.SetButtonName(1958);
            m_MachineryBtnBool = true;
        }
    }
    txtCurrentTerritory.SetText(GetCastleName(DominionID));
    txtLordName.SetText(clanMasterName);
    txtClanName.SetText(ClanName);
    txtAlleyName.SetText(allianceName);
    txtTerritoryWarTime.SetText(ConvertTimetoStr(NextDominionWarDate));
    txtCurrentTime.SetText(ConvertTimetoStr(CurrentDate));
    txtTotalClanCount.SetText(string(JoinedClanCnt));
    txtTotalMachineryCount.SetText(string(JoinedUserCnt));
    return;
}

function HandleResultJoinDominionWar(string param)
{
    local int DominionID, Clan, Join, Success, ClanCnt, UserCnt;

    Debug("HandleResultJoinDominionWar" @ param);
    ParseInt(param, "DominionID", DominionID);
    ParseInt(param, "Clan", Clan);
    ParseInt(param, "Join", Join);
    ParseInt(param, "Success", Success);
    ParseInt(param, "ClanCnt", ClanCnt);
    ParseInt(param, "UserCnt", UserCnt);
    // End:0x21C
    if(m_DominionID == DominionID)
    {
        // End:0x17B
        if(Clan == 1)
        {
            // End:0x135
            if((Join == 1) && Success == 1)
            {
                btnClanApplyBtn.SetButtonName(1959);
                m_ClanBtnBool = false;
                txtTotalClanCount.SetText(MakeFullSystemMsg(GetSystemMessage(2781), string(ClanCnt)));                
            }
            else
            {
                btnClanApplyBtn.SetButtonName(1957);
                m_ClanBtnBool = true;
                txtTotalClanCount.SetText(MakeFullSystemMsg(GetSystemMessage(2781), string(ClanCnt)));
            }            
        }
        else
        {
            // End:0x1D9
            if((Join == 1) && Success == 1)
            {
                btnApplyMachinery.SetButtonName(1960);
                m_MachineryBtnBool = false;
                txtTotalMachineryCount.SetText(MakeFullSystemMsg(GetSystemMessage(2782), string(UserCnt)));                
            }
            else
            {
                btnApplyMachinery.SetButtonName(1958);
                m_MachineryBtnBool = true;
                txtTotalMachineryCount.SetText(MakeFullSystemMsg(GetSystemMessage(2782), string(UserCnt)));
            }
        }
    }
    return;
}

function HandleDominionInfoCnt(string param)
{
    local int DominionInfoCnt;

    Debug("HandleDominionInfoCnt" @ param);
    ParseInt(param, "DominionInfoCnt", DominionInfoCnt);
    return;
}

function HandleDominionInfo(string param)
{
    local int DominionID;
    local string DominionName, ClanName;
    local int DominionsOwnCnt;
    local string DominionsOwnName[8];
    local int NextDate, i;

    Debug("HandleDominionInfoCnt" @ param);
    ParseInt(param, "DominionID", DominionID);
    ParseInt(param, "DominionsOwnCnt", DominionsOwnCnt);
    ParseInt(param, "NextDate", NextDate);
    ParseString(param, "DominionName", DominionName);
    ParseString(param, "ClanName", ClanName);
    i = 0;
    J0xBA:

    // End:0x107 [Loop If]
    if(i <= DominionsOwnCnt)
    {
        ParseString(param, "DominionsOwnName" $ string(i + 1), DominionsOwnName[i]);
        i++;
        // [Loop Continue]
        goto J0xBA;
    }
    return;
}

function HandleDominionWarJoinList(string param)
{
    local int MyClanJoinDominionID, UserJoinDominionID, ImMaster;

    Debug("HandleDominionsOwnPos" @ param);
    ParseInt(param, "MyClanJoinDominionID", MyClanJoinDominionID);
    ParseInt(param, "UserJoinDominionID", UserJoinDominionID);
    ParseInt(param, "ImMaster", ImMaster);
    // End:0xB2
    if(MyClanJoinDominionID > 0)
    {
        btnApplyMachinery.SetButtonName(1959);
        m_ClanBtnBool = false;        
    }
    else
    {
        btnClanApplyBtn.SetButtonName(1957);
        m_ClanBtnBool = true;
    }
    // End:0xF8
    if(UserJoinDominionID > 0)
    {
        btnApplyMachinery.SetButtonName(1960);
        m_MachineryBtnBool = false;        
    }
    else
    {
        btnApplyMachinery.SetButtonName(1958);
        m_MachineryBtnBool = true;
    }
    // End:0x140
    if(ImMaster == 0)
    {
        btnApplyMachinery.DisableWindow();
        btnClanApplyBtn.DisableWindow();        
    }
    else
    {
        btnApplyMachinery.EnableWindow();
        btnClanApplyBtn.EnableWindow();
    }
    return;
}
