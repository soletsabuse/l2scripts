class ClanWnd extends UICommonAPI;

const DIALOG_StartPledgeWar = 90006;
const DIALOG_AskPledgeWar = 90010;
const TIMER_ID = 20001;
const TIMER_DELAY = 200;

struct sActivity
{
    var string sName;
    var int nTime;
};

var array<sActivity> activityPlayers;
var WindowHandle Me;
var ClanDrawerWnd ClanDrawerWndScript;
var int m_clanID;
var string m_clanName;
var int m_clanRank;
var int m_clanLevel;
var int m_clanNameValue;
var int m_bMoreInfo;
var int m_currentShowIndex;
var int G_CurrentRecord;
var string G_CurrentSzData;
var bool G_CurrentAlias;
var int G_IamNobless;
var bool G_IamHero;
var int G_ClanMember;
var string m_WindowName;
var string m_DrawerWindowName;
var int m_myClanType;
var string m_myName;
var string m_myClanName;
var int m_indexNum;
var bool m_currentactivestatus1;
var bool m_currentactivestatus2;
var bool m_currentactivestatus3;
var bool m_currentactivestatus4;
var bool m_currentactivestatus5;
var bool m_currentactivestatus6;
var bool m_currentactivestatus7;
var bool m_currentactivestatus8;
var int m_bClanMaster;
var int m_bJoin;
var int m_bNickName;
var int m_bCrest;
var int m_bWar;
var int m_bGrade;
var int m_bManageMaster;
var int m_bOustMember;
var TextBoxHandle TxtClanWar_Title;
var ListCtrlHandle m_hClanMemberList;
var string m_CurrentclanMasterName;
var string m_CurrentclanMasterReal;
var int m_CurrentNHType;
var array<ClanInfo> m_memberList;
var string withWarPledgeNameStr;
var int pledgeDelayTimerCount;
var bool bShowOnlyOnlineUser;

function getMyClanInfo()
{
    local UserInfo UserInfo;

    // End:0x61
    if(GetPlayerInfo(UserInfo))
    {
        m_myName = UserInfo.Name;
        m_myClanType = findmyClanData(m_myName);
        G_IamNobless = UserInfo.nNobless;
        G_IamHero = UserInfo.bHero;
        G_ClanMember = UserInfo.nClanID;
    }
    return;
}

function int findmyClanData(string C_Name)
{
    local int i, j, clannum;

    i = 0;
    J0x07:

    // End:0x93 [Loop If]
    if(i < m_memberList.Length)
    {
        j = 0;
        J0x1E:

        // End:0x89 [Loop If]
        if(j < m_memberList[i].m_array.Length)
        {
            // End:0x7F
            if(m_memberList[i].m_array[j].sName == C_Name)
            {
                clannum = m_memberList[i].m_array[j].clanType;
            }
            ++j;
            // [Loop Continue]
            goto J0x1E;
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return clannum;
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    InitHandleCOD();
    load();
    m_memberList.Length = 8;
    m_currentShowIndex = 0;
    m_bMoreInfo = 0;
    G_CurrentAlias = false;
    Clear();
    m_currentactivestatus1 = false;
    m_currentactivestatus2 = false;
    m_currentactivestatus3 = false;
    m_currentactivestatus4 = false;
    m_currentactivestatus5 = false;
    m_currentactivestatus6 = false;
    m_currentactivestatus7 = false;
    m_hClanMemberList = GetListCtrlHandle(m_WindowName $ ".ClanMemberList");
    ClanDrawerWndScript = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
    bShowOnlyOnlineUser = false;
    return;
}

function InitHandleCOD()
{
    Me = GetWindowHandle(m_WindowName);
    TxtClanWar_Title = GetTextBoxHandle(m_DrawerWindowName $ ".ClanWarManagementWnd.TxtClanWar_Title");
    return;
}

function load()
{
    pledgeDelayTimerCount = 0;
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(320);
    RegisterEvent(330);
    RegisterEvent(420);
    RegisterEvent(400);
    RegisterEvent(440);
    RegisterEvent(410);
    RegisterEvent(450);
    RegisterEvent(150);
    RegisterEvent(160);
    RegisterEvent(340);
    RegisterEvent(480);
    RegisterEvent(3580);
    RegisterEvent(5180);
    RegisterEvent(9426);
    RegisterEvent(20192);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function int GetClanTypeFromIndex(int Index)
{
    local int Type;

    // End:0x12
    if(Index == 0)
    {
        Type = 0;
    }
    // End:0x25
    if(Index == 1)
    {
        Type = 100;
    }
    // End:0x39
    if(Index == 2)
    {
        Type = 200;
    }
    // End:0x50
    if(Index == 3)
    {
        Type = 1001;
    }
    // End:0x67
    if(Index == 4)
    {
        Type = 1002;
    }
    // End:0x7E
    if(Index == 5)
    {
        Type = 2001;
    }
    // End:0x95
    if(Index == 6)
    {
        Type = 2002;
    }
    // End:0xAC
    if(Index == 7)
    {
        Type = -1;
    }
    return Type;
    return;
}

function string GetClanTypeNameFromIndex(int Index)
{
    local string Type;

    // End:0x1C
    if(Index == 0)
    {
        Type = GetSystemString(1399);
    }
    // End:0x39
    if(Index == 100)
    {
        Type = GetSystemString(1400);
    }
    // End:0x56
    if(Index == 200)
    {
        Type = GetSystemString(1401);
    }
    // End:0x76
    if(Index == 1001)
    {
        Type = GetSystemString(1402);
    }
    // End:0x96
    if(Index == 1002)
    {
        Type = GetSystemString(1403);
    }
    // End:0xB6
    if(Index == 2001)
    {
        Type = GetSystemString(1404);
    }
    // End:0xD6
    if(Index == 2002)
    {
        Type = GetSystemString(1405);
    }
    // End:0xF6
    if(Index == -1)
    {
        Type = GetSystemString(1452);
    }
    return Type;
    return;
}

function OnShow()
{
    local int i;
    local Rect comboboxMainClanWndRect;

    comboboxMainClanWndRect = GetComboBoxHandle("ClanWnd.ComboboxMainClanWnd").GetRect();
    // End:0x1EE
    if(false)
    {
        GetTextBoxHandle("ClanWnd.ClanCurrentNum").MoveTo(comboboxMainClanWndRect.nX + 184, comboboxMainClanWndRect.nY + 3);
        GetTextureHandle("ClanWnd.PledgeflagIcon_Texture").ShowWindow();
        GetButtonHandle("ClanWnd.PledgeBonusWnd_Btn").ShowWindow();
        // End:0x13C
        if(bShowOnlyOnlineUser)
        {
            GetButtonHandle("ClanWnd.PledgePCOnline_Btn").ShowWindow();
            GetButtonHandle("ClanWnd.PledgePCOffline_Btn").HideWindow();            
        }
        else
        {
            GetButtonHandle("ClanWnd.PledgePCOnline_Btn").HideWindow();
            GetButtonHandle("ClanWnd.PledgePCOffline_Btn").ShowWindow();
        }
        m_hClanMemberList.SetColumnString(3, 5850);
        // End:0x1E5
        if(!ClanPledgeBonusDrawerWnd(GetScript("ClanPledgeBonusDrawerWnd")).getHasPledgeBonusList())
        {
            PledgeBonusRewardList();
        }
        PledgeBonusOpen();        
    }
    else
    {
        GetTextBoxHandle("ClanWnd.ClanCurrentNum").MoveTo(comboboxMainClanWndRect.nX + 202, comboboxMainClanWndRect.nY + 3);
        m_hClanMemberList.SetColumnString(3, 346);
        GetButtonHandle("ClanWnd.PledgePCOnline_Btn").HideWindow();
        GetButtonHandle("ClanWnd.PledgePCOffline_Btn").HideWindow();
        GetTextureHandle("ClanWnd.PledgeflagIcon_Texture").HideWindow();
        GetButtonHandle("ClanWnd.PledgeBonusWnd_Btn").HideWindow();
    }
    getMyClanInfo();
    RefreshCombobox();
    resetBtnShowHide();
    NoblessMenuValidate();
    i = 10;
    J0x31D:

    // End:0x39E [Loop If]
    if(i >= 0)
    {
        // End:0x394
        if(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", i) == m_myClanType)
        {
            Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd", i);
        }
        --i;
        // [Loop Continue]
        goto J0x31D;
    }
    ShowList(m_myClanType);
    Class'NWindow.UIAPI_LISTCTRL'.static.SetSelectedIndex(m_WindowName $ ".ClanMemberList", m_indexNum, true);
    // End:0x415
    if(m_myClanType == -1)
    {
        Class'NWindow.UIAPI_LISTCTRL'.static.SetSelectedIndex(m_WindowName $ ".ClanMemberList", m_indexNum - 1, true);
    }
    return;
}

function NoblessMenuValidate()
{
    // End:0xB8
    if(G_ClanMember == 0)
    {
        // End:0x6E
        if((G_IamHero == true) || G_IamNobless > 0)
        {
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".HeroBtn");
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ClanMemInfoBtn");            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".HeroBtn");
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanMemInfoBtn");
        }        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".HeroBtn");
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanMemInfoBtn");
    }
    return;
}

function OnHide()
{
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x15
    if(getInstanceL2Util().isClanV2())
    {
        return;
    }
    getMyClanInfo();
    NoblessMenuValidate();
    Clear();
    Class'NWindow.UIDATA_CLAN'.static.RequestClanInfo();
    return;
}

function OnClickButton(string strID)
{
    local ClanDrawerWnd script;
    local LVDataRecord Record;
    local string strParam;

    Record.LVDataList.Length = 10;
    Debug("strID" @ strID);
    script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
    // End:0x13E
    if(strID == "ClanMemInfoBtn")
    {
        // End:0x124
        if(m_currentactivestatus1 == false)
        {
            ResetOpeningVariables();
            m_currentactivestatus1 = true;
            // End:0x121
            if(GetSelectedListCtrlItem(Record))
            {
                RequestClanMemberInfo(name(Record.nReserved1), Record.LVDataList[0].szData);
                G_CurrentRecord = name(Record.nReserved1);
                G_CurrentSzData = Record.LVDataList[0].szData;
                // End:0xF5
                if(Record.LVDataList[3].szData == "0")
                {
                    G_CurrentAlias = true;                    
                }
                else
                {
                    G_CurrentAlias = false;
                }
                script.SetStateAndShow("ClanMemberInfoState");
            }            
        }
        else
        {
            m_currentactivestatus1 = false;
            script.HideClanWindow();
        }        
    }
    else
    {
        // End:0x1E4
        if(strID == "ClanMemAuthBtn")
        {
            // End:0x1CA
            if(m_currentactivestatus2 == false)
            {
                ResetOpeningVariables();
                m_currentactivestatus2 = true;
                // End:0x1C7
                if(GetSelectedListCtrlItem(Record))
                {
                    RequestClanMemberAuth(name(Record.nReserved1), Record.LVDataList[0].szData);
                    script.SetStateAndShow("ClanMemberAuthState");
                }                
            }
            else
            {
                m_currentactivestatus2 = false;
                script.HideClanWindow();
            }            
        }
        else
        {
            // End:0x225
            if(strID == "ClanBoardBtn")
            {
                PledgeNoticeWnd(GetScript("PledgeNoticeWnd")).evRqClanNotice();                
            }
            else
            {
                // End:0x291
                if(strID == "ClanInfoBtn")
                {
                    // End:0x277
                    if(m_currentactivestatus3 == false)
                    {
                        ResetOpeningVariables();
                        m_currentactivestatus3 = true;
                        script.SetStateAndShow("ClanInfoState");                        
                    }
                    else
                    {
                        m_currentactivestatus3 = false;
                        script.HideClanWindow();
                    }                    
                }
                else
                {
                    // End:0x2C3
                    if(strID == "ClanPenaltyBtn")
                    {
                        ExecuteCommandFromAction("pledgepenalty");                        
                    }
                    else
                    {
                        // End:0x2ED
                        if(strID == "ClanQuitBtn")
                        {
                            RequestClanLeave(m_clanName, m_myClanType);                            
                        }
                        else
                        {
                            // End:0x384
                            if(strID == "ClanWarInfoBtn")
                            {
                                // End:0x36A
                                if(m_currentactivestatus5 == false)
                                {
                                    ResetOpeningVariables();
                                    m_currentactivestatus5 = true;
                                    script.m_clanWarListPage = -1;
                                    RequestClanWarList(0, 0);
                                    script.SetStateAndShow("ClanWarManagementWndState");                                    
                                }
                                else
                                {
                                    m_currentactivestatus5 = false;
                                    script.HideClanWindow();
                                }                                
                            }
                            else
                            {
                                // End:0x3AA
                                if(strID == "ClanWarDeclareBtn")
                                {
                                    RequestClanDeclareWar();                                    
                                }
                                else
                                {
                                    // End:0x41C
                                    if(strID == "ClanUnionBtn")
                                    {
                                        // End:0x3FE
                                        if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanSearch"))
                                        {
                                            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ClanSearch");                                            
                                        }
                                        else
                                        {
                                            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ClanSearch");
                                        }                                        
                                    }
                                    else
                                    {
                                        // End:0x43F
                                        if(strID == "ClanAskJoinBtn")
                                        {
                                            askJoin();                                            
                                        }
                                        else
                                        {
                                            // End:0x4BE
                                            if(strID == "ClanAuthEditBtn")
                                            {
                                                // End:0x4A4
                                                if(m_currentactivestatus6 == false)
                                                {
                                                    ResetOpeningVariables();
                                                    m_currentactivestatus6 = true;
                                                    RequestClanGradeList();
                                                    script.SetStateAndShow("ClanAuthManageWndState");                                                    
                                                }
                                                else
                                                {
                                                    m_currentactivestatus6 = false;
                                                    script.HideClanWindow();
                                                }                                                
                                            }
                                            else
                                            {
                                                // End:0x53C
                                                if(strID == "ClanTitleManageBtn")
                                                {
                                                    // End:0x522
                                                    if(m_currentactivestatus7 == false)
                                                    {
                                                        ResetOpeningVariables();
                                                        m_currentactivestatus7 = true;
                                                        script.SetStateAndShow("ClanEmblemManageWndState");                                                        
                                                    }
                                                    else
                                                    {
                                                        m_currentactivestatus7 = false;
                                                        script.HideClanWindow();
                                                    }                                                    
                                                }
                                                else
                                                {
                                                    // End:0x5A1
                                                    if(strID == "HeroBtn")
                                                    {
                                                        // End:0x587
                                                        if(m_currentactivestatus8 == false)
                                                        {
                                                            m_currentactivestatus8 = true;
                                                            script.SetStateAndShow("ClanHeroWndState");                                                            
                                                        }
                                                        else
                                                        {
                                                            m_currentactivestatus8 = false;
                                                            script.HideClanWindow();
                                                        }                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x618
                                                        if(strID == "PledgeBonusWnd_Btn")
                                                        {
                                                            // End:0x60F
                                                            if(IsShowWindow("ClanPledgeBonusDrawerWnd"))
                                                            {
                                                                GetWindowHandle("ClanPledgeBonusDrawerWnd").HideWindow();                                                                
                                                            }
                                                            else
                                                            {
                                                                PledgeBonusOpen();
                                                            }                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x783
                                                            if((strID == "PledgePCOnline_Btn") || strID == "PledgePCOffline_Btn")
                                                            {
                                                                // End:0x6C4
                                                                if(isOnlyOnline())
                                                                {
                                                                    GetButtonHandle("ClanWnd.PledgePCOnline_Btn").HideWindow();
                                                                    GetButtonHandle("ClanWnd.PledgePCOffline_Btn").ShowWindow();
                                                                    bShowOnlyOnlineUser = false;                                                                    
                                                                }
                                                                else
                                                                {
                                                                    GetButtonHandle("ClanWnd.PledgePCOnline_Btn").ShowWindow();
                                                                    GetButtonHandle("ClanWnd.PledgePCOffline_Btn").HideWindow();
                                                                    bShowOnlyOnlineUser = true;
                                                                }
                                                                ShowList(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd")));
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function bool isOnlyOnline()
{
    return GetButtonHandle("ClanWnd.PledgePCOnline_Btn").IsShowWindow();
    return;
}

function IsWorldRaidServer()
{
    // End:0x1DE
    if(IsPlayerOnWorldRaidServer() == true)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanMemInfoBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanMemAuthBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanBoardBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanInfoBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanPenaltyBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanQuitBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarDeclareBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanUnionBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAskJoinBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    // End:0x15
    if(getInstanceL2Util().isClanV2())
    {
        return;
    }
    switch(a_EventID)
    {
        // End:0x2D
        case 420:
            Clear();
            // End:0x1CC
            break;
        // End:0x3B
        case 160:
            Clear();
            // End:0x1CC
            break;
        // End:0x51
        case 320:
            HandleClanInfo(a_Param);
            // End:0x1CC
            break;
        // End:0x67
        case 410:
            HandleAddClanMemberMultiple(a_Param);
            // End:0x1CC
            break;
        // End:0x7D
        case 440:
            HandleMemberInfoUpdate(a_Param);
            // End:0x1CC
            break;
        // End:0x93
        case 400:
            HandleAddClanMember(a_Param);
            // End:0x1CC
            break;
        // End:0xA9
        case 450:
            HandleDeleteMember(a_Param);
            // End:0x1CC
            break;
        // End:0xBF
        case 330:
            HandleClanInfoUpdate(a_Param);
            // End:0x1CC
            break;
        // End:0xD5
        case 480:
            HandleSubClanUpdated(a_Param);
            // End:0x1CC
            break;
        // End:0xEB
        case 340:
            HandleClanMyAuth(a_Param);
            // End:0x1CC
            break;
        // End:0x101
        case 5180:
            HandleEV_RequestStartPledgeWar(a_Param);
            // End:0x1CC
            break;
        // End:0x1B2
        case 20192:
            Debug("ì´ˆê¸°í™” ë¨. EV_PledgeBonusMarkReset");
            ClearList();
            deleteAllBActive();
            ShowList(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd")));
            // End:0x1CC
            break;
        // End:0x1C3
        case 1710:
            HandleDialogOK();
            // End:0x1CC
            break;
        // End:0xFFFF
        default:
            // End:0x1CC
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1CC
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1CC
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1CC
}

function deleteAllBActive()
{
    local int N, i;

    i = 0;
    J0x07:

    // End:0x6A [Loop If]
    if(i < m_memberList.Length)
    {
        N = 0;
        J0x1E:

        // End:0x60 [Loop If]
        if(N < m_memberList[i].m_array.Length)
        {
            m_memberList[i].m_array[N].bActive = 0;
            N++;
            // [Loop Continue]
            goto J0x1E;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnComboBoxItemSelected(string sName, int Index)
{
    ClearList();
    ShowList(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd")));
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    local ClanDrawerWnd script;
    local LVDataRecord Record;

    Record.LVDataList.Length = 10;
    script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
    // End:0x17C
    if(ListCtrlID == "ClanMemberList")
    {
        // End:0x10D
        if(m_currentactivestatus1 == true)
        {
            ResetOpeningVariables();
            m_currentactivestatus1 = true;
            // End:0x10D
            if(GetSelectedListCtrlItem(Record))
            {
                RequestClanMemberInfo(name(Record.nReserved1), Record.LVDataList[0].szData);
                G_CurrentRecord = name(Record.nReserved1);
                G_CurrentSzData = Record.LVDataList[0].szData;
                // End:0xE1
                if(Record.LVDataList[3].szData == "0")
                {
                    G_CurrentAlias = true;                    
                }
                else
                {
                    G_CurrentAlias = false;
                }
                script.SetStateAndShow("ClanMemberInfoState");
            }
        }
        // End:0x17C
        if(m_currentactivestatus2 == true)
        {
            ResetOpeningVariables();
            m_currentactivestatus2 = true;
            // End:0x17C
            if(GetSelectedListCtrlItem(Record))
            {
                RequestClanMemberAuth(name(Record.nReserved1), Record.LVDataList[0].szData);
                script.SetStateAndShow("ClanMemberAuthState");
            }
        }
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    local ClanDrawerWnd script;
    local LVDataRecord Record;

    Record.LVDataList.Length = 10;
    script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
    // End:0x19C
    if(ListCtrlID == "ClanMemberList")
    {
        // End:0x110
        if(m_currentactivestatus1 == false)
        {
            ResetOpeningVariables();
            m_currentactivestatus1 = true;
            // End:0x10D
            if(GetSelectedListCtrlItem(Record))
            {
                RequestClanMemberInfo(name(Record.nReserved1), Record.LVDataList[0].szData);
                G_CurrentRecord = name(Record.nReserved1);
                G_CurrentSzData = Record.LVDataList[0].szData;
                // End:0xE1
                if(Record.LVDataList[3].szData == "0")
                {
                    G_CurrentAlias = true;                    
                }
                else
                {
                    G_CurrentAlias = false;
                }
                script.SetStateAndShow("ClanMemberInfoState");
            }            
        }
        else
        {
            ResetOpeningVariables();
            m_currentactivestatus1 = true;
            // End:0x19C
            if(GetSelectedListCtrlItem(Record))
            {
                RequestClanMemberInfo(name(Record.nReserved1), Record.LVDataList[0].szData);
                G_CurrentRecord = name(Record.nReserved1);
                G_CurrentSzData = Record.LVDataList[0].szData;
                script.SetStateAndShow("ClanMemberInfoState");
            }
        }
    }
    return;
}

function resetBtnShowHide()
{
    local ClanDrawerWnd script;

    script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
    NoblessMenuValidate();
    IsNoblessToChangeMemberNameBtnEnabled();
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanUnionBtn");
    // End:0x1E5
    if(m_clanID == 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanMemInfoBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanMemAuthBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanBoardBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanInfoBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanQuitBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarDeclareBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAskJoinBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");        
    }
    else
    {
        // End:0x4B6
        if(m_clanLevel > 5)
        {
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarDeclareBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");            
        }
        else
        {
            switch(m_clanLevel)
            {
                // End:0x74E
                case 0:
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanBoardBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarDeclareBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
                    // End:0x14D5
                    break;
                // End:0x9DF
                case 1:
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanBoardBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarDeclareBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
                    // End:0x14D5
                    break;
                // End:0xC71
                case 2:
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarDeclareBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
                    // End:0x14D5
                    break;
                // End:0xF3B
                case 3:
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarDeclareBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
                    // End:0x14D5
                    break;
                // End:0x1205
                case 4:
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarDeclareBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
                    // End:0x14D5
                    break;
                // End:0x14CF
                case 5:
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanMemAuthBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanBoardBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanPenaltyBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanQuitBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanWarDeclareBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAskJoinBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAuthEditBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
                    // End:0x14D5
                    break;
                // End:0xFFFF
                default:
                    // End:0x14D5
                    break;
                    break;
            }
        }
        // End:0x1566
        if(m_bClanMaster > 0)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanQuitBtn");
            // End:0x153B
            if(m_clanLevel > 2)
            {
                Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanTitleManageBtn");
            }
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanAuthEditBtn");            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
            // End:0x16AD
            if(m_bJoin == 0)
            {
                Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanAskJoinBtn");
            }
            // End:0x16E6
            if(m_bCrest == 0)
            {
                Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanTitleManageBtn");                
            }
            else
            {
                // End:0x171D
                if(m_clanLevel > 2)
                {
                    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".ClanTitleManageBtn");
                }
            }
            // End:0x1752
            if(m_bWar == 0)
            {
                Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".ClanWarDeclareBtn");
            }
        }
        script.CheckandCompareMyNameandDisableThings();
    }
    IsWorldRaidServer();
    NoblessMenuValidate();
    return;
}

function IsNoblessToChangeMemberNameBtnEnabled()
{
    // End:0x4E
    if((G_IamHero == true) || G_IamNobless > 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_DrawerWindowName $ ".Clan1_ChangeMemberNameBtn");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_DrawerWindowName $ ".Clan1_ChangeMemberNameBtn");
    }
    return;
}

function Clear()
{
    local ClanDrawerWnd script;
    local int i;

    ClearList();
    script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
    script.Clear();
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_DrawerWindowName);
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanNameText", "");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanMasterNameText", "");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", GetSystemString(27));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanStatusText", "");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".ClanLevelText", 0);
    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(m_WindowName $ ".ComboboxMainClanWnd");
    m_clanID = 0;
    m_clanName = "";
    m_clanRank = 0;
    m_clanLevel = 0;
    m_clanNameValue = 0;
    m_bMoreInfo = 0;
    m_currentShowIndex = 0;
    m_bClanMaster = 0;
    m_bJoin = 0;
    m_bNickName = 0;
    m_bCrest = 0;
    m_bWar = 0;
    m_bGrade = 0;
    m_bManageMaster = 0;
    m_bOustMember = 0;
    i = 0;
    J0x1D8:

    // End:0x237 [Loop If]
    if(i < 8)
    {
        m_memberList[i].m_array.Remove(0, m_memberList[i].m_array.Length);
        m_memberList[i].m_sName = "";
        m_memberList[i].m_sMasterName = "";
        ++i;
        // [Loop Continue]
        goto J0x1D8;
    }
    return;
}

function HandleEV_RequestStartPledgeWar(string param)
{
    ParseString(param, "PledgeName", withWarPledgeNameStr);
    ResetOpeningVariables();
    ClanDrawerWndScript.m_clanWarListPage = -1;
    RequestClanWarList(0, 0);
    m_currentactivestatus5 = false;
    ClanDrawerWndScript.HideClanWindow();
    pledgeDelayTimerCount = 0;
    Me.KillTimer(20001);
    Me.SetTimer(20001, 200);
    return;
}

function OnTimer(int TimerID)
{
    // End:0x99
    if(pledgeDelayTimerCount > 0)
    {
        // End:0x99
        if(TimerID == 20001)
        {
            Me.KillTimer(20001);
            DialogSetID(90010);
            // End:0x76
            if(ClanDrawerWndScript.searchClanWarDeclare(withWarPledgeNameStr))
            {
                DialogShow(1, 0, MakeFullSystemMsg(GetSystemMessage(3524), withWarPledgeNameStr), string(self));                
            }
            else
            {
                DialogShow(1, 0, MakeFullSystemMsg(GetSystemMessage(3306), withWarPledgeNameStr), string(self));
            }
        }
    }
    pledgeDelayTimerCount++;
    return;
}

function HandleDialogOK()
{
    local int dialogID;

    // End:0x43
    if(DialogIsMine())
    {
        dialogID = DialogGetID();
        // End:0x43
        if(dialogID == 90010)
        {
            // End:0x3B
            if(withWarPledgeNameStr != "")
            {
                RequestPledgeWar(withWarPledgeNameStr);
            }
            withWarPledgeNameStr = "";
        }
    }
    return;
}

function HandleClanInfo(string a_Param)
{
    local string clanMasterName, ClanName;
    local int crestID, SkillLevel, castleID, agitType, AgitID, fotressID,
	    Status, bGuilty, allianceID;

    local string allianceName;
    local int AllianceCrestID, bInWar, clanType, clanRank, clanNameValue, clanID;

    ParseInt(a_Param, "ClanID", clanID);
    ParseInt(a_Param, "ClanType", clanType);
    m_CurrentNHType = clanType;
    ParseString(a_Param, "ClanName", ClanName);
    ParseString(a_Param, "ClanMasterName", clanMasterName);
    m_CurrentclanMasterName = clanMasterName;
    // End:0x98
    if(clanType == 0)
    {
        m_CurrentclanMasterReal = clanMasterName;
    }
    ParseInt(a_Param, "CrestID", crestID);
    ParseInt(a_Param, "SkillLevel", SkillLevel);
    ParseInt(a_Param, "CastleID", castleID);
    ParseInt(a_Param, "AgitType", agitType);
    ParseInt(a_Param, "AgitID", AgitID);
    ParseInt(a_Param, "FortressID", fotressID);
    ParseInt(a_Param, "ClanRank", clanRank);
    ParseInt(a_Param, "ClanNameValue", clanNameValue);
    ParseInt(a_Param, "Status", Status);
    ParseInt(a_Param, "Guilty", bGuilty);
    ParseInt(a_Param, "AllianceID", allianceID);
    ParseString(a_Param, "AllianceName", allianceName);
    ParseInt(a_Param, "AllianceCrestID", AllianceCrestID);
    ParseInt(a_Param, "InWar", bInWar);
    // End:0x252
    if(clanType == 0)
    {
        m_clanName = ClanName;
        m_clanRank = clanRank;
        m_clanNameValue = clanNameValue;
        m_clanLevel = SkillLevel;
        m_clanID = clanID;
    }
    m_memberList[GetIndexFromType(clanType)].m_sName = ClanName;
    m_memberList[GetIndexFromType(clanType)].m_sMasterName = clanMasterName;
    // End:0x51B
    if(clanType == 0)
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanNameText", ClanName);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanMasterNameText", m_CurrentclanMasterReal);
        // End:0x380
        if(AgitID > 0)
        {
            // End:0x342
            if(agitType == 0)
            {
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", getInstanceL2Util().getCastleNameEx(AgitID));                
            }
            else
            {
                // End:0x37D
                if(agitType == 1)
                {
                    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", GetInZoneNameWithZoneID(AgitID));
                }
            }            
        }
        else
        {
            // End:0x3C8
            if(castleID > 0)
            {
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", getInstanceL2Util().getCastleNameEx(castleID));                
            }
            else
            {
                // End:0x410
                if(fotressID > 0)
                {
                    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", getInstanceL2Util().getCastleNameEx(fotressID));                    
                }
                else
                {
                    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", GetSystemString(27));
                }
            }
        }
        // End:0x47E
        if(Status == 3)
        {
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanStatusText", GetSystemString(341));            
        }
        else
        {
            // End:0x4BE
            if(bInWar == 0)
            {
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanStatusText", GetSystemString(894));                
            }
            else
            {
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanStatusText", GetSystemString(340));
            }
        }
        Class'NWindow.UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".ClanLevelText", SkillLevel);
    }
    RefreshCombobox();
    getMyClanInfo();
    return;
}

function HandleClanInfoUpdate(string a_Param)
{
    local int PledgeCrestID, castleID, agitType, AgitID, fotressID, Status,
	    bGuilty, allianceID;

    local string sAllianceName;
    local int AllianceCrestID, InWar, LargePledgeCrestID;
    local ClanDrawerWnd script;

    ParseInt(a_Param, "ClanID", m_clanID);
    ParseInt(a_Param, "CrestID", PledgeCrestID);
    ParseInt(a_Param, "SkillLevel", m_clanLevel);
    ParseInt(a_Param, "CastleID", castleID);
    ParseInt(a_Param, "AgitType", agitType);
    ParseInt(a_Param, "AgitID", AgitID);
    ParseInt(a_Param, "FortressID", fotressID);
    ParseInt(a_Param, "ClanRank", m_clanRank);
    ParseInt(a_Param, "ClanNameValue", m_clanNameValue);
    ParseInt(a_Param, "Status", Status);
    ParseInt(a_Param, "Guilty", bGuilty);
    ParseInt(a_Param, "AllianceID", allianceID);
    ParseString(a_Param, "AllianceName", sAllianceName);
    ParseInt(a_Param, "AllianceCrestID", AllianceCrestID);
    ParseInt(a_Param, "InWar", InWar);
    ParseInt(a_Param, "LargeCrestID", LargePledgeCrestID);
    // End:0x20A
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd.ClanInfoWnd"))
    {
        script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
        script.InitializeClanInfoWnd();
    }
    // End:0x29B
    if(AgitID > 0)
    {
        // End:0x25D
        if(agitType == 0)
        {
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", getInstanceL2Util().getCastleNameEx(AgitID));            
        }
        else
        {
            // End:0x298
            if(agitType == 1)
            {
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", GetInZoneNameWithZoneID(AgitID));
            }
        }        
    }
    else
    {
        // End:0x2E3
        if(castleID > 0)
        {
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", getInstanceL2Util().getCastleNameEx(castleID));            
        }
        else
        {
            // End:0x32B
            if(fotressID > 0)
            {
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", getInstanceL2Util().getCastleNameEx(fotressID));                
            }
            else
            {
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanAgitText", GetSystemString(27));
            }
        }
    }
    // End:0x399
    if(Status == 3)
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanStatusText", GetSystemString(341));        
    }
    else
    {
        // End:0x3D9
        if(InWar == 0)
        {
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanStatusText", GetSystemString(894));            
        }
        else
        {
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanStatusText", GetSystemString(340));
        }
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt(m_WindowName $ ".ClanLevelText", m_clanLevel);
    resetBtnShowHide();
    getMyClanInfo();
    return;
}

function HandleAddClanMemberMultiple(string a_Param)
{
    local ClanMemberInfo Info;
    local int i, Count, Index;
    local array<string> nameTime;
    local bool bFound;

    ParseInt(a_Param, "ClanType", Info.clanType);
    Index = GetIndexFromType(Info.clanType);
    ParseString(a_Param, "Name", Info.sName);
    // End:0xAA
    if(InStr(Info.sName, ";") > -1)
    {
        nameTime = Arr(Info.sName, ";");
        Info.sName = nameTime[0];
        setTime(nameTime[0], int(nameTime[1]));
    }
    ParseInt(a_Param, "Level", Info.Level);
    ParseInt(a_Param, "Class", Info.ClassID);
    ParseInt(a_Param, "Gender", Info.gender);
    ParseInt(a_Param, "Race", Info.Race);
    ParseInt(a_Param, "ID", Info.Id);
    ParseInt(a_Param, "HaveMaster", Info.bHaveMaster);
    ParseInt(a_Param, "MemberActive", Info.bActive);
    bFound = false;
    i = 0;
    J0x186:

    // End:0x1FC [Loop If]
    if(i < m_memberList[Index].m_array.Length)
    {
        // End:0x1F2
        if(m_memberList[Index].m_array[i].sName == Info.sName)
        {
            m_memberList[Index].m_array[i] = Info;
            bFound = true;
            // [Explicit Break]
            goto J0x1FC;
        }
        i++;
        // [Loop Continue]
        goto J0x186;
    }
    J0x1FC:

    // End:0x254
    if(!bFound)
    {
        Count = m_memberList[Index].m_array.Length;
        m_memberList[Index].m_array.Length = Count + 1;
        m_memberList[Index].m_array[Count] = Info;
    }
    // End:0x273
    if(Index == m_currentShowIndex)
    {
        ShowList(Info.clanType);
    }
    return;
}

function ClearList()
{
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName $ ".ClanMemberList");
    return;
}

function ShowList(int clanType)
{
    local int Index;

    Index = GetIndexFromType(clanType);
    m_currentShowIndex = Index;
    ClearList();
    AddToList(Index);
    return;
}

function int getClanKnighthoodMasterInfo(string NameVal)
{
    local int i, ReturnVal;

    i = 0;
    J0x07:

    // End:0x54 [Loop If]
    if(i < m_memberList[0].m_array.Length)
    {
        // End:0x4A
        if(m_memberList[0].m_array[i].sName == NameVal)
        {
            ReturnVal = i;
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return ReturnVal;
    return;
}

function AddToList(int idx)
{
    local Color White, Yellow, Blue, BrightWhite, Gold;

    local int i, OnLineNum;
    local LVDataRecord Record;

    BrightWhite.R = byte(255);
    BrightWhite.G = byte(255);
    BrightWhite.B = byte(255);
    White.R = 170;
    White.G = 170;
    White.B = 170;
    Yellow.R = 235;
    Yellow.G = 205;
    Yellow.B = 0;
    Blue.R = 102;
    Blue.G = 150;
    Blue.B = 253;
    Gold.R = 176;
    Gold.G = 153;
    Gold.B = 121;
    OnLineNum = 0;
    Record.LVDataList.Length = 4;
    // End:0xF2
    if((GetClanTypeFromIndex(m_currentShowIndex)) <= 0)
    {        
    }
    else
    {
        // End:0x1C2
        if(m_memberList[m_currentShowIndex].m_sMasterName == "")
        {
            i = getClanKnighthoodMasterInfo(m_memberList[m_currentShowIndex].m_sMasterName);
            Record.LVDataList[0].bUseTextColor = true;
            Record.LVDataList[0].szData = GetSystemString(1445);
            Record.LVDataList[0].TextColor = Gold;
            Record.LVDataList[1].szData = "";
            Record.LVDataList[2].szData = "";
            Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName $ ".ClanMemberList", Record);
        }
        i = 0;
    }
    i = 0;
    J0x1D0:

    // End:0x884 [Loop If]
    if(i < m_memberList[idx].m_array.Length)
    {
        // End:0x21C
        if(true)
        {
            // End:0x21C
            if(isOnlyOnline())
            {
                // End:0x21C
                if(m_memberList[idx].m_array[i].Id <= 0)
                {
                    // [Explicit Continue]
                    goto J0x87A;
                }
            }
        }
        Record.LVDataList[0].bUseTextColor = true;
        Record.LVDataList[0].szData = m_memberList[idx].m_array[i].sName;
        // End:0x298
        if(m_memberList[idx].m_array[i].bHaveMaster == 0)
        {
            Record.LVDataList[0].TextColor = White;            
        }
        else
        {
            Record.LVDataList[0].TextColor = Yellow;
        }
        // End:0x32F
        if(m_memberList[idx].m_array[i].sName == m_myName)
        {
            Record.LVDataList[0].TextColor = BrightWhite;
            Record.LVDataList[1].TextColor = BrightWhite;
            // End:0x321
            if((GetClanTypeFromIndex(m_currentShowIndex)) == 0)
            {
                m_indexNum = i;                
            }
            else
            {
                m_indexNum = i + 1;
            }
        }
        Record.LVDataList[1].bUseTextColor = true;
        // End:0x420
        if(false)
        {
            // End:0x39D
            if(m_memberList[idx].m_array[i].sName == m_myName)
            {
                Record.LVDataList[0].TextColor = Yellow;
                Record.LVDataList[1].TextColor = Yellow;                
            }
            else
            {
                // End:0x3EF
                if(m_memberList[idx].m_array[i].Id > 0)
                {
                    Record.LVDataList[0].TextColor = BrightWhite;
                    Record.LVDataList[1].TextColor = BrightWhite;                    
                }
                else
                {
                    Record.LVDataList[0].TextColor = White;
                    Record.LVDataList[1].TextColor = White;
                }
            }            
        }
        else
        {
            // End:0x45F
            if(m_memberList[idx].m_array[i].sName == m_myName)
            {
                Record.LVDataList[1].TextColor = BrightWhite;                
            }
            else
            {
                Record.LVDataList[1].TextColor = White;
            }
        }
        Record.LVDataList[1].szData = string(m_memberList[idx].m_array[i].Level);
        Record.LVDataList[2].szData = string(m_memberList[idx].m_array[i].ClassID);
        Record.LVDataList[2].szTexture = GetClassRoleIconName(m_memberList[idx].m_array[i].ClassID);
        Record.LVDataList[2].HiddenStringForSorting = string(GetClassRoleType(m_memberList[idx].m_array[i].ClassID));
        Record.LVDataList[2].nTextureWidth = 11;
        Record.LVDataList[2].nTextureHeight = 11;
        Record.LVDataList[3].nTextureWidth = 31;
        Record.LVDataList[3].nTextureHeight = 11;
        Record.nReserved1 = (m_memberList[idx].m_array[i].clanType);
        Record.nReserved2 = (getActivityTime(m_memberList[idx].m_array[i].sName));
        // End:0x77C
        if(false)
        {
            // End:0x61B
            if(m_memberList[idx].m_array[i].Id > 0)
            {
                OnLineNum = OnLineNum++;
            }
            // End:0x6BA
            if(m_memberList[idx].m_array[i].bActive == 1)
            {
                Record.LVDataList[3].nTextureWidth = 16;
                Record.LVDataList[3].nTextureHeight = 16;
                Record.LVDataList[3].szData = "1";
                Record.LVDataList[3].szTexture = "L2UI_CT1.PledgeBonusWnd.PledgeflagIcon";                
            }
            else
            {
                // End:0x74F
                if(m_memberList[idx].m_array[i].bActive == 2)
                {
                    Record.LVDataList[3].nTextureWidth = 26;
                    Record.LVDataList[3].nTextureHeight = 9;
                    Record.LVDataList[3].szData = "2";
                    Record.LVDataList[3].szTexture = "L2UI_CT1.pledgeBonusWnd.New";                    
                }
                else
                {
                    Record.LVDataList[3].szData = "";
                    Record.LVDataList[3].szTexture = "";
                }
            }            
        }
        else
        {
            // End:0x7FD
            if(m_memberList[idx].m_array[i].Id > 0)
            {
                Record.LVDataList[3].szData = "1";
                Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
                OnLineNum = OnLineNum++;                
            }
            else
            {
                Record.LVDataList[3].szData = "2";
                Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
            }
        }
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName $ ".ClanMemberList", Record);
        J0x87A:

        ++i;
        // [Loop Continue]
        goto J0x1D0;
    }
    // End:0x8EA
    if((GetClanTypeFromIndex(m_currentShowIndex)) <= 0)
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanCurrentNum", ((("(" $ string(OnLineNum)) $ "/") $ string(m_memberList[idx].m_array.Length)) $ ")");        
    }
    else
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".ClanCurrentNum", ((("(" $ string(OnLineNum)) $ "/") $ string(m_memberList[idx].m_array.Length)) $ ")");
    }
    return;
}

function bool GetSelectedListCtrlItem(out LVDataRecord Record)
{
    local int Index;

    Index = m_hClanMemberList.GetSelectedIndex();
    // End:0x3B
    if(Index >= 0)
    {
        m_hClanMemberList.GetRec(Index, Record);
        return true;
    }
    return false;
    return;
}

function HandleMemberInfoUpdate(string a_Param)
{
    local ClanMemberInfo Info;
    local int i, j, Count;
    local ClanDrawerWnd script;
    local bool bHaveMasterChanged, bMemberChanged;
    local int process_length, process_clanindex;
    local array<string> nameTime;

    bHaveMasterChanged = false;
    bMemberChanged = false;
    ParseString(a_Param, "Name", Info.sName);
    // End:0x85
    if(InStr(Info.sName, ";") > -1)
    {
        nameTime = Arr(Info.sName, ";");
        Info.sName = nameTime[0];
        setTime(nameTime[0], int(nameTime[1]));
    }
    ParseInt(a_Param, "Level", Info.Level);
    ParseInt(a_Param, "Class", Info.ClassID);
    ParseInt(a_Param, "Gender", Info.gender);
    ParseInt(a_Param, "Race", Info.Race);
    ParseInt(a_Param, "ID", Info.Id);
    ParseInt(a_Param, "ClanType", Info.clanType);
    ParseInt(a_Param, "HaveMaster", Info.bHaveMaster);
    // End:0x175
    if(true)
    {
        ParseInt(a_Param, "MemberActive", Info.bActive);
    }
    i = 0;
    J0x17C:

    // End:0x48D [Loop If]
    if(i < 8)
    {
        Count = m_memberList[i].m_array.Length;
        j = 0;
        J0x1A6:

        // End:0x471 [Loop If]
        if(j < Count)
        {
            // End:0x467
            if(m_memberList[i].m_array[j].sName == Info.sName)
            {
                // End:0x22D
                if(m_memberList[i].m_array[j].bHaveMaster != Info.bHaveMaster)
                {
                    bHaveMasterChanged = true;
                    m_memberList[i].m_array[j] = Info;
                }
                // End:0x438
                if(m_memberList[i].m_array[j].clanType != Info.clanType)
                {
                    bMemberChanged = true;
                    m_memberList[i].m_array.Remove(j, 1);
                    process_clanindex = GetIndexFromType(Info.clanType);
                    process_length = m_memberList[process_clanindex].m_array.Length;
                    m_memberList[process_clanindex].m_array.Insert(process_length, 1);
                    m_memberList[process_clanindex].m_array[process_length].sName = Info.sName;
                    m_memberList[process_clanindex].m_array[process_length].clanType = Info.clanType;
                    m_memberList[process_clanindex].m_array[process_length].Level = Info.Level;
                    m_memberList[process_clanindex].m_array[process_length].ClassID = Info.ClassID;
                    m_memberList[process_clanindex].m_array[process_length].gender = Info.gender;
                    m_memberList[process_clanindex].m_array[process_length].Race = Info.Race;
                    m_memberList[process_clanindex].m_array[process_length].Id = Info.Id;
                    m_memberList[process_clanindex].m_array[process_length].bHaveMaster = Info.bHaveMaster;
                    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_DrawerWindowName $ ".Clan1_CurrentSelectedMemberGrade", "");
                    ShowList(Info.clanType);                    
                }
                else
                {
                    m_memberList[i].m_array[j] = Info;
                    ShowList(Info.clanType);
                }
                // [Explicit Break]
                goto J0x471;
            }
            ++j;
            // [Loop Continue]
            goto J0x1A6;
        }
        J0x471:

        // End:0x483
        if(j < Count)
        {
            // [Explicit Break]
            goto J0x48D;
        }
        ++i;
        // [Loop Continue]
        goto J0x17C;
    }
    J0x48D:

    script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
    // End:0x551
    if(bHaveMasterChanged && Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(m_DrawerWindowName $ ".ClanMemberInfoWnd"))
    {
        // End:0x51C
        if(script.m_currentName == Info.sName)
        {
            RequestClanMemberInfo(Info.clanType, Info.sName);
        }
        // End:0x546
        if((GetIndexFromType(Info.clanType)) == m_currentShowIndex)
        {
            ShowList(Info.clanType);
        }
        ShowList(m_currentShowIndex);
    }
    // End:0x5E6
    if(bMemberChanged && Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(m_DrawerWindowName $ ".ClanMemberInfoWnd"))
    {
        ClearList();
        ShowList(Info.clanType);
        RefreshCombobox1(Info.clanType);
        // End:0x5E6
        if(script.m_currentName == Info.sName)
        {
            RequestClanMemberInfo(Info.clanType, Info.sName);
        }
    }
    return;
}

function RefreshCombobox1(int ClanT)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x89 [Loop If]
    if(i < 10)
    {
        // End:0x7F
        if(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", i) == ClanT)
        {
            Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd", i);
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function HandleAddClanMember(string a_Param)
{
    local int Count;
    local ClanMemberInfo Info;
    local array<string> nameTime;

    ParseString(a_Param, "Name", Info.sName);
    // End:0x75
    if(InStr(Info.sName, ";") > -1)
    {
        nameTime = Arr(Info.sName, ";");
        Info.sName = nameTime[0];
        setTime(nameTime[0], int(nameTime[1]));
    }
    ParseInt(a_Param, "Level", Info.Level);
    ParseInt(a_Param, "Class", Info.ClassID);
    ParseInt(a_Param, "Gender", Info.gender);
    ParseInt(a_Param, "Race", Info.Race);
    ParseInt(a_Param, "ID", Info.Id);
    ParseInt(a_Param, "ClanType", Info.clanType);
    // End:0x144
    if(true)
    {
        ParseInt(a_Param, "MemberActive", Info.bActive);
    }
    Info.bHaveMaster = 0;
    Count = m_memberList[GetIndexFromType(Info.clanType)].m_array.Length;
    m_memberList[GetIndexFromType(Info.clanType)].m_array.Length = Count + 1;
    m_memberList[GetIndexFromType(Info.clanType)].m_array[Count] = Info;
    // End:0x1E8
    if((GetIndexFromType(Info.clanType)) == m_currentShowIndex)
    {
        ShowList(Info.clanType);
    }
    return;
}

function int GetIndexFromType(int Type)
{
    local int i;

    i = -1;
    // End:0x20
    if(Type == 0)
    {
        i = 0;        
    }
    else
    {
        // End:0x36
        if(Type == 100)
        {
            i = 1;            
        }
        else
        {
            // End:0x4D
            if(Type == 200)
            {
                i = 2;                
            }
            else
            {
                // End:0x67
                if(Type == 1001)
                {
                    i = 3;                    
                }
                else
                {
                    // End:0x81
                    if(Type == 1002)
                    {
                        i = 4;                        
                    }
                    else
                    {
                        // End:0x9B
                        if(Type == 2001)
                        {
                            i = 5;                            
                        }
                        else
                        {
                            // End:0xB5
                            if(Type == 2002)
                            {
                                i = 6;                                
                            }
                            else
                            {
                                // End:0xCC
                                if(Type == -1)
                                {
                                    i = 7;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return i;
    return;
}

function HandleDeleteMember(string a_Param)
{
    local int i, j, k, Count;
    local string sName;

    ParseString(a_Param, "Name", sName);
    i = 0;
    J0x1D:

    // End:0x115 [Loop If]
    if(i < 8)
    {
        Count = m_memberList[i].m_array.Length;
        j = 0;
        J0x47:

        // End:0xF9 [Loop If]
        if(j < Count)
        {
            // End:0xEF
            if(m_memberList[i].m_array[j].sName == sName)
            {
                k = j;
                J0x86:

                // End:0xD2 [Loop If]
                if(k < (Count - 1))
                {
                    m_memberList[i].m_array[k] = m_memberList[i].m_array[k + 1];
                    ++k;
                    // [Loop Continue]
                    goto J0x86;
                }
                m_memberList[i].m_array.Length = Count - 1;
                // [Explicit Break]
                goto J0xF9;
            }
            ++j;
            // [Loop Continue]
            goto J0x47;
        }
        J0xF9:

        // End:0x10B
        if(j < Count)
        {
            // [Explicit Break]
            goto J0x115;
        }
        ++i;
        // [Loop Continue]
        goto J0x1D;
    }
    J0x115:

    // End:0x12F
    if(i == m_currentShowIndex)
    {
        ShowList(i);
    }
    return;
}

function RefreshCombobox()
{
    local int i, Index, newIndex, addedCount;

    Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd");
    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(m_WindowName $ ".ComboboxMainClanWnd");
    addedCount = -1;
    i = 0;
    J0x70:

    // End:0x11D [Loop If]
    if(i < 8)
    {
        // End:0x113
        if(m_memberList[i].m_sName != "")
        {
            Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".ComboboxMainClanWnd", ((GetClanTypeNameFromIndex(GetClanTypeFromIndex(i))) @ "-") @ m_memberList[i].m_sName, GetClanTypeFromIndex(i));
            ++addedCount;
            // End:0x113
            if(i == m_currentShowIndex)
            {
                newIndex = addedCount;
            }
        }
        ++i;
        // [Loop Continue]
        goto J0x70;
    }
    i = 0;
    J0x124:

    // End:0x1A6 [Loop If]
    if(i < 10)
    {
        // End:0x19C
        if(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".ComboboxMainClanWnd", i) == m_myClanType)
        {
            Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".ComboboxMainClanWnd", i);
        }
        ++i;
        // [Loop Continue]
        goto J0x124;
    }
    return;
}

function HandleSubClanUpdated(string a_Param)
{
    local int Id, Type;
    local string sName, sMasterName;
    local ClanDrawerWnd script;

    ParseInt(a_Param, "ClanID", Id);
    ParseInt(a_Param, "ClanType", Type);
    ParseString(a_Param, "ClanName", sName);
    ParseString(a_Param, "MasterName", sMasterName);
    m_memberList[GetIndexFromType(Type)].m_sName = sName;
    m_memberList[GetIndexFromType(Type)].m_sMasterName = sMasterName;
    RefreshCombobox();
    // End:0xFC
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(m_DrawerWindowName $ ".ClanInfoWnd"))
    {
        script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
        script.InitializeClanInfoWnd();
    }
    return;
}

function askJoin()
{
    local UserInfo User;
    local InviteClanPopWnd InviteClanPopWndScript;

    // End:0x50
    if(GetTargetInfo(User))
    {
        // End:0x50
        if(User.nID > 0)
        {
            InviteClanPopWndScript = InviteClanPopWnd(GetScript("InviteClanPopWnd"));
            InviteClanPopWndScript.showByClanWnd();
        }
    }
    return;
}

function HandleClanMyAuth(string a_Param)
{
    ParseInt(a_Param, "ClanMaster", m_bClanMaster);
    ParseInt(a_Param, "Join", m_bJoin);
    ParseInt(a_Param, "NickName", m_bNickName);
    ParseInt(a_Param, "ClanCrest", m_bCrest);
    ParseInt(a_Param, "War", m_bWar);
    ParseInt(a_Param, "Grade", m_bGrade);
    ParseInt(a_Param, "ManageMaster", m_bManageMaster);
    ParseInt(a_Param, "OustMember", m_bOustMember);
    resetBtnShowHide();
    return;
}

function ResetOpeningVariables()
{
    m_currentactivestatus1 = false;
    m_currentactivestatus2 = false;
    m_currentactivestatus3 = false;
    m_currentactivestatus4 = false;
    m_currentactivestatus5 = false;
    m_currentactivestatus6 = false;
    m_currentactivestatus7 = false;
    m_currentactivestatus8 = false;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

function setTime(string Name, coerce int Time)
{
    local int i;
    local sActivity tmpActivity;

    tmpActivity.sName = Name;
    tmpActivity.nTime = Time;
    i = 0;
    J0x27:

    // End:0x6E [Loop If]
    if(i < activityPlayers.Length)
    {
        // End:0x64
        if(activityPlayers[i].sName == Name)
        {
            activityPlayers[i] = tmpActivity;
            return;
        }
        i++;
        // [Loop Continue]
        goto J0x27;
    }
    activityPlayers[activityPlayers.Length] = tmpActivity;
    return;
}

function int getActivityTime(string Name)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x4C [Loop If]
    if(i < activityPlayers.Length)
    {
        // End:0x42
        if(activityPlayers[i].sName == Name)
        {
            return activityPlayers[i].nTime;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

defaultproperties
{
    m_WindowName="ClanWnd"
    m_DrawerWindowName="ClanDrawerWnd"
}