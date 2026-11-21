class ClanDrawerWndClassic extends UIData;

const DIALOG_AskLossClanWar = 90009;
const DIALOG_AskClanWarCancel = 487;
const c_maxranklimit = 100;
const changelineval1 = 23;
const DISABLE_ALPHA = 100;
const ACADEMY_INDEX = 7;
const NUMOFOPTIONS_SYSTEM = 10;
const NUMOFOPTIONS_AGIT = 5;
const NUMOFOPTIONS_CASTLE = 8;

var string m_state;
var int m_clanType;
var int m_clanWarListPage;
var int m_currentEditGradeID;
var string m_currentName;
var string m_myName;
var int m_currentMaster;
var string currentMasterName;
var string currentLossWarClanName;
var string m_WindowName;
var string m_ClanPledgeBonusDrawerWndName;
var ListCtrlHandle m_hClanDrawerWndClan8_DeclaredListCtrl;
var ListCtrlHandle m_hClanDrawerWndClan8_GotDeclaredListCtrl;
var ListCtrlHandle m_hClanDrawerWndClan5_AuthListCtrl;
var FileRegisterWnd fileRegisterWndHandle;
var ClanWndClassic clanWndClassicScript;

function OnRegisterEvent()
{
    RegisterEvent(350);
    RegisterEvent(360);
    RegisterEvent(370);
    RegisterEvent(380);
    RegisterEvent(430);
    RegisterEvent(460);
    RegisterEvent(490);
    RegisterEvent(500);
    RegisterEvent(160);
    RegisterEvent(470);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    InitHandle();
    InitializeGradeComboBox();
    HideAll();
    m_clanWarListPage = -1;
    m_hClanDrawerWndClan8_DeclaredListCtrl = GetListCtrlHandle(m_WindowName $ ".Clan8_DeclaredListCtrl");
    m_hClanDrawerWndClan8_GotDeclaredListCtrl = GetListCtrlHandle(m_WindowName $ ".Clan8_DeclaredListCtrl");
    m_hClanDrawerWndClan5_AuthListCtrl = GetListCtrlHandle(m_WindowName $ ".Clan5_AuthListCtrl");
    fileRegisterWndHandle = FileRegisterWnd(GetScript("FileRegisterWnd"));
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan2_Check108");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan2_Check109");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan2_Check110");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan2_Check302");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan6_Check108");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan6_Check109");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan6_Check110");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan6_Check302");
    return;
}

function InitHandle()
{
    clanWndClassicScript = ClanWndClassic(GetScript("ClanWndClassic"));
    return;
}

function OnShow()
{
    // End:0x2D
    if(GetWindowHandle(m_ClanPledgeBonusDrawerWndName).IsShowWindow())
    {
        GetWindowHandle(m_ClanPledgeBonusDrawerWndName).HideWindow();
    }
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
    // End:0x1A3
    if(clanWndClassicScript.m_bClanMaster == 0)
    {
        // End:0x11A
        if(clanWndClassicScript.m_bNickName == 0)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
        }
        // End:0x161
        if(clanWndClassicScript.m_bGrade == 0)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
        }
        // End:0x1A3
        if(clanWndClassicScript.m_bOustMember == 0)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
        }
    }
    switchingWarCancelButton();
    return;
}

function Clear()
{
    m_state = "";
    m_clanType = -1;
    m_clanWarListPage = -1;
    m_currentEditGradeID = -1;
    m_currentName = "";
    return;
}

function SetStateAndShow(string State)
{
    local int i;
    local string string1, string2, string3, string4;

    m_state = State;
    // End:0x38
    if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(m_WindowName))
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName);
    }
    HideAll();
    // End:0x12B
    if(m_state == "ClanMemberInfoState")
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanMemberInfoWnd");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");        
    }
    else
    {
        // End:0x29C
        if(m_state == "ClanMemberAuthState")
        {
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanMemberAuthWnd");
            i = 0;
            J0x17B:

            // End:0x1FF [Loop If]
            if(i <= 10)
            {
                // End:0x1C6
                if(i < 10)
                {
                    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName $ ".Clan2_Check10") $ string(i), true);
                    // [Explicit Continue]
                    goto J0x1F5;
                }
                Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName $ ".Clan2_Check1") $ string(i), true);
                J0x1F5:

                ++i;
                // [Loop Continue]
                goto J0x17B;
            }
            i = 0;
            J0x206:

            // End:0x24C [Loop If]
            if(i <= 5)
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName $ ".Clan2_Check20") $ string(i), true);
                ++i;
                // [Loop Continue]
                goto J0x206;
            }
            i = 0;
            J0x253:

            // End:0x299 [Loop If]
            if(i <= 8)
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName $ ".Clan2_Check30") $ string(i), true);
                ++i;
                // [Loop Continue]
                goto J0x253;
            }            
        }
        else
        {
            // End:0x316
            if(m_state == "ClanInfoState")
            {
                InitializeClanInfoWnd();
                Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear(m_WindowName $ ".ClanSkillWnd");
                Class'NWindow.UIDATA_CLAN'.static.RequestClanSkillList();
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanInfoWnd");                
            }
            else
            {
                // End:0x365
                if(m_state == "ClanAuthManageWndState")
                {
                    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanAuthManageWnd");                    
                }
                else
                {
                    // End:0x4ED
                    if(m_state == "ClanEmblemManageWndState")
                    {
                        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanEmblemManageWnd");
                        string1 = Left(GetSystemMessage(211), 23);
                        string2 = Right(GetSystemMessage(211), Len(GetSystemMessage(211)) - 23);
                        string3 = Left(GetSystemMessage(1478), 23);
                        string4 = Right(GetSystemMessage(1478), Len(GetSystemMessage(1478)) - 23);
                        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan7_ManageEmb1Text1", string1);
                        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan7_ManageEmb1Text2", string2);
                        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan7_ManageEmb2Text1", string3);
                        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan7_ManageEmb2Text2", string4);                        
                    }
                    else
                    {
                        // End:0x542
                        if(m_state == "ClanWarManagementWndState")
                        {
                            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanWarManagementWnd");                            
                        }
                        else
                        {
                            // End:0x58D
                            if(m_state == "ClanAuthEditWndState")
                            {
                                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanAuthEditWnd");                                
                            }
                            else
                            {
                                // End:0x5CD
                                if(m_state == "ClanHeroWndState")
                                {
                                    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanHeroWnd");
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

function HideAll()
{
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ClanMemberInfoWnd");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ClanMemberAuthWnd");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ClanInfoWnd");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ClanPenaltyWnd");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ClanWarManagementWnd");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ClanAuthManageWnd");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ClanAuthEditWnd");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ClanEmblemManageWnd");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ClanHeroWnd");
    return;
}

function OnClickButton(string strID)
{
    local array<string> fileextarr;

    // End:0x62
    if(strID == "Clan1_AskJoinPartyBtn")
    {
        RequestInviteParty(Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName"));        
    }
    else
    {
        // End:0x161
        if(strID == "Clan1_ChangeMemberNameBtn")
        {
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");
            Class'NWindow.UIAPI_EDITBOX'.static.SetString(m_WindowName $ ".Clan1_ChangeNameTextEditbox", "");            
        }
        else
        {
            // End:0x22B
            if(strID == "Clan1_ChangeMemberGradeBtn")
            {
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");                
            }
            else
            {
                // End:0x301
                if(strID == "Clan1_ChangeBanishBtn")
                {
                    HideClanWindow();
                    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
                    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");
                    RequestClanExpelMember(m_clanType, Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName"));                    
                }
                else
                {
                    // End:0x321
                    if(strID == "Clan1_OKBtn")
                    {
                        HideClanWindow();                        
                    }
                    else
                    {
                        // End:0x429
                        if(strID == "Clan1_ChangeNameAssignBtn")
                        {
                            RequestClanChangeNickName(Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName"), Class'NWindow.UIAPI_EDITBOX'.static.GetString(m_WindowName $ ".Clan1_ChangeNameTextEditbox"));
                            Class'NWindow.UIAPI_EDITBOX'.static.SetString(m_WindowName $ ".Clan1_ChangeNameTextEditbox", "");
                            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
                            RecallCurrentMemberInfo();                            
                        }
                        else
                        {
                            // End:0x4FF
                            if(strID == "Clan1_ChangeNameDeleteBtn")
                            {
                                RequestClanChangeNickName(Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName"), "");
                                Class'NWindow.UIAPI_EDITBOX'.static.SetString(m_WindowName $ ".Clan1_ChangeNameTextEditbox", "");
                                Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
                                RecallCurrentMemberInfo();                                
                            }
                            else
                            {
                                // End:0x656
                                if(strID == "Clan1_ChangeMemberGradeAssignBtn")
                                {
                                    // End:0x5D2
                                    if(Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".Clan1_MemberGradeList") < 5)
                                    {
                                        RequestClanChangeGrade(Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName"), Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".Clan1_MemberGradeList") + 1);                                        
                                    }
                                    else
                                    {
                                        RequestClanChangeGrade(Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName"), getCurrentGradebyClanType());
                                    }
                                    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");
                                    RecallCurrentMemberInfo();                                    
                                }
                                else
                                {
                                    // End:0x6C2
                                    if(strID == "Clan1_ChangeMemberKnightHoodBtn")
                                    {
                                        proc_swapmember();
                                        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");                                        
                                    }
                                    else
                                    {
                                        // End:0x710
                                        if(strID == "Clan1_Cancel1")
                                        {
                                            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");                                            
                                        }
                                        else
                                        {
                                            // End:0x763
                                            if(strID == "Clan1_Cancel2")
                                            {
                                                Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");                                                
                                            }
                                            else
                                            {
                                                // End:0x7B7
                                                if(strID == "Clan1_Cancel4")
                                                {
                                                    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");                                                    
                                                }
                                                else
                                                {
                                                    // End:0x834
                                                    if(strID == "Clan7_RegEmbBtn")
                                                    {
                                                        // End:0x831
                                                        if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false)
                                                        {
                                                            fileextarr.Length = 1;
                                                            fileextarr[0] = "bmp";
                                                            ClearFileRegisterWndFileExt();
                                                            AddFileRegisterWndFileExt(GetSystemString(2811), fileextarr);
                                                            FileRegisterWndShow(1);
                                                        }                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x857
                                                        if(strID == "Clan7_RmEmbBtn")
                                                        {
                                                            RequestClanUnregisterCrest();                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x8E3
                                                            if(strID == "Clan7_RegEmb2Btn")
                                                            {
                                                                // End:0x8E0
                                                                if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false)
                                                                {
                                                                    fileextarr.Length = 2;
                                                                    fileextarr[0] = "tga";
                                                                    fileextarr[1] = "bmp";
                                                                    ClearFileRegisterWndFileExt();
                                                                    AddFileRegisterWndFileExt(GetSystemString(2233), fileextarr);
                                                                    FileRegisterWndShow(2);
                                                                }                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x907
                                                                if(strID == "Clan7_RmEmb2Btn")
                                                                {
                                                                    RequestClanUnregisterEmblem();                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x96C
                                                                    if(strID == "Clan8_CancelWar1Btn")
                                                                    {
                                                                        Class'Interface.UICommonAPI'.static.DialogSetID(487);
                                                                        Class'Interface.UICommonAPI'.static.DialogSetDefaultCancle();
                                                                        DialogShow(1, 0, MakeFullSystemMsg(GetSystemMessage(3883), ""), string(self));                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x995
                                                                        if(strID == "Clan8_DeclareWar1Btn")
                                                                        {
                                                                            HandleDeclareWar();                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x9BD
                                                                            if(strID == "Clan8_CancelWar2Btn")
                                                                            {
                                                                                HandleCancelWar2();                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x9EB
                                                                                if(strID == "Clan8_ViewMoreBtn")
                                                                                {
                                                                                    RequestClanWarList(++m_clanWarListPage, 1);                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    // End:0xA0D
                                                                                    if(strID == "Clan8_LoseBtn")
                                                                                    {
                                                                                        HandleDeclareLoseWar();                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        // End:0xA2D
                                                                                        if(strID == "Clan2_OKBtn")
                                                                                        {
                                                                                            HideClanWindow();                                                                                            
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            // End:0xA4D
                                                                                            if(strID == "Clan3_OKBtn")
                                                                                            {
                                                                                                HideClanWindow();                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                // End:0xA6D
                                                                                                if(strID == "Clan4_OKBtn")
                                                                                                {
                                                                                                    HideClanWindow();                                                                                                    
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    // End:0xA8D
                                                                                                    if(strID == "Clan5_OKBtn")
                                                                                                    {
                                                                                                        HideClanWindow();                                                                                                        
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        // End:0xAAD
                                                                                                        if(strID == "Clan7_OKBtn")
                                                                                                        {
                                                                                                            HideClanWindow();                                                                                                            
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                            // End:0xACF
                                                                                                            if(strID == "ClanWar_OKBtn")
                                                                                                            {
                                                                                                                HideClanWindow();                                                                                                                
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                // End:0xAF3
                                                                                                                if(strID == "Clan5_ManageBtn")
                                                                                                                {
                                                                                                                    EditAuthGrade();                                                                                                                    
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    // End:0xB34
                                                                                                                    if(strID == "Clan6_ApplyBtn")
                                                                                                                    {
                                                                                                                        ApplyEditGrade();
                                                                                                                        SetStateAndShow("ClanAuthManageWndState");                                                                                                                        
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        // End:0xB70
                                                                                                                        if(strID == "Clan6_CancelBtn")
                                                                                                                        {
                                                                                                                            SetStateAndShow("ClanAuthManageWndState");                                                                                                                            
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            // End:0xB96
                                                                                                                            if(strID == "ClanWarTabCtrl0")
                                                                                                                            {
                                                                                                                                RequestClanWarList(0, 0);                                                                                                                                
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                // End:0xBC0
                                                                                                                                if(strID == "ClanWarTabCtrl1")
                                                                                                                                {
                                                                                                                                    RequestClanWarList(m_clanWarListPage, 1);                                                                                                                                    
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    // End:0xC6F
                                                                                                                                    if(strID == "Clan1_ChangeNameAssignNobBtn")
                                                                                                                                    {
                                                                                                                                        RequestClanChangeNickName(clanWndClassicScript.m_myName, Class'NWindow.UIAPI_EDITBOX'.static.GetString(m_WindowName $ ".Clan1_ChangeNobNameTextEditbox"));
                                                                                                                                        Class'NWindow.UIAPI_EDITBOX'.static.SetString(m_WindowName $ ".Clan1_ChangeNobNameTextEditbox", "");                                                                                                                                        
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        // End:0xC94
                                                                                                                                        if(strID == "Clan1_NobCancel1")
                                                                                                                                        {
                                                                                                                                            HideClanWindow();                                                                                                                                            
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            // End:0xCD5
                                                                                                                                            if(strID == "Clan1_ChangeNameDeleteNobBtn")
                                                                                                                                            {
                                                                                                                                                RequestClanChangeNickName(clanWndClassicScript.m_myName, "");                                                                                                                                                
                                                                                                                                            }
                                                                                                                                            else
                                                                                                                                            {
                                                                                                                                                // End:0xCF9
                                                                                                                                                if(strID == "Clan8_RefreshBtn")
                                                                                                                                                {
                                                                                                                                                    RequestClanWarList(0, 0);
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
                        }
                    }
                }
            }
        }
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    // End:0x24
    if(ListCtrlID == "Clan5_AuthListCtrl")
    {
        EditAuthGrade();
    }
    return;
}

function RecallCurrentMemberInfo()
{
    RequestClanMemberInfo(clanWndClassicScript.G_CurrentRecord, clanWndClassicScript.G_CurrentSzData);
    SetStateAndShow("ClanMemberInfoState");
    return;
}

function OnClickCheckBox(string CheckBoxID)
{
    local string CheckboxNum, CheckboxName;
    local bool CheckedStat;
    local int i;

    CheckboxName = Left(CheckBoxID, 12);
    // End:0x208
    if(CheckboxName == "Clan6_Check1")
    {
        CheckboxNum = Right(CheckBoxID, 2);
        // End:0x1A4
        if(CheckboxNum == "00")
        {
            CheckedStat = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(m_WindowName $ ".Clan6_Check100");
            switch(CheckedStat)
            {
                // End:0x10C
                case true:
                    i = 0;
                    J0x85:

                    // End:0x109 [Loop If]
                    if(i <= 10)
                    {
                        // End:0xD0
                        if(i < 10)
                        {
                            Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check10") $ string(i), true);
                            // [Explicit Continue]
                            goto J0xFF;
                        }
                        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check1") $ string(i), true);
                        J0xFF:

                        ++i;
                        // [Loop Continue]
                        goto J0x85;
                    }
                    // End:0x1A1
                    break;
                // End:0x19E
                case false:
                    i = 0;
                    J0x117:

                    // End:0x19B [Loop If]
                    if(i <= 10)
                    {
                        // End:0x162
                        if(i < 10)
                        {
                            Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check10") $ string(i), false);
                            // [Explicit Continue]
                            goto J0x191;
                        }
                        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check1") $ string(i), false);
                        J0x191:

                        ++i;
                        // [Loop Continue]
                        goto J0x117;
                    }
                    // End:0x1A1
                    break;
                // End:0xFFFF
                default:
                    break;
            }            
        }
        else
        {
            // End:0x1E0
            if((count_all_check("1", 10)) == true)
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check100", true);                
            }
            else
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check100", false);
            }
        }
    }
    // End:0x385
    if(CheckboxName == "Clan6_Check2")
    {
        CheckboxNum = Right(CheckBoxID, 2);
        // End:0x321
        if(CheckboxNum == "00")
        {
            CheckedStat = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(m_WindowName $ ".Clan6_Check200");
            switch(CheckedStat)
            {
                // End:0x2C7
                case true:
                    i = 0;
                    J0x27E:

                    // End:0x2C4 [Loop If]
                    if(i <= 5)
                    {
                        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check20") $ string(i), true);
                        ++i;
                        // [Loop Continue]
                        goto J0x27E;
                    }
                    // End:0x31E
                    break;
                // End:0x31B
                case false:
                    i = 0;
                    J0x2D2:

                    // End:0x318 [Loop If]
                    if(i <= 5)
                    {
                        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check20") $ string(i), false);
                        ++i;
                        // [Loop Continue]
                        goto J0x2D2;
                    }
                    // End:0x31E
                    break;
                // End:0xFFFF
                default:
                    break;
            }            
        }
        else
        {
            // End:0x35D
            if((count_all_check("2", 5)) == true)
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check200", true);                
            }
            else
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check200", false);
            }
        }
    }
    // End:0x502
    if(CheckboxName == "Clan6_Check3")
    {
        CheckboxNum = Right(CheckBoxID, 2);
        // End:0x49E
        if(CheckboxNum == "00")
        {
            CheckedStat = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(m_WindowName $ ".Clan6_Check300");
            switch(CheckedStat)
            {
                // End:0x444
                case true:
                    i = 0;
                    J0x3FB:

                    // End:0x441 [Loop If]
                    if(i <= 8)
                    {
                        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check30") $ string(i), true);
                        ++i;
                        // [Loop Continue]
                        goto J0x3FB;
                    }
                    // End:0x49B
                    break;
                // End:0x498
                case false:
                    i = 0;
                    J0x44F:

                    // End:0x495 [Loop If]
                    if(i <= 8)
                    {
                        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check30") $ string(i), false);
                        ++i;
                        // [Loop Continue]
                        goto J0x44F;
                    }
                    // End:0x49B
                    break;
                // End:0xFFFF
                default:
                    break;
            }            
        }
        else
        {
            // End:0x4DA
            if((count_all_check("3", 8)) == true)
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check300", true);                
            }
            else
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check300", false);
            }
        }
    }
    return;
}

function bool count_all_check(string numString, int totalNum)
{
    local bool checkall, currentcheck;
    local int i;

    checkall = false;
    i = 1;
    J0x0F:

    // End:0xC6 [Loop If]
    if(i <= totalNum)
    {
        // End:0x6D
        if(i < 10)
        {
            currentcheck = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((((m_WindowName $ ".Clan6_Check") $ numString) $ "0") $ string(i));            
        }
        else
        {
            currentcheck = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((m_WindowName $ ".Clan6_Check") $ numString) $ string(i));
        }
        // End:0xBC
        if(currentcheck == true)
        {
            checkall = true;
        }
        ++i;
        // [Loop Continue]
        goto J0x0F;
    }
    return checkall;
    return;
}

function bool count_all_check2(string numString, int totalNum)
{
    local bool checkall, currentcheck;
    local int i;

    checkall = false;
    i = 1;
    J0x0F:

    // End:0xC6 [Loop If]
    if(i <= totalNum)
    {
        // End:0x6D
        if(i < 10)
        {
            currentcheck = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((((m_WindowName $ ".Clan2_Check") $ numString) $ "0") $ string(i));            
        }
        else
        {
            currentcheck = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(((m_WindowName $ ".Clan2_Check") $ numString) $ string(i));
        }
        // End:0xBC
        if(currentcheck == true)
        {
            checkall = true;
        }
        ++i;
        // [Loop Continue]
        goto J0x0F;
    }
    return checkall;
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
        // End:0x32
        case 350:
            HandleClanAuthGradeList(a_Param);
            // End:0x11D
            break;
        // End:0x48
        case 460:
            HandleClanWarList(a_Param);
            // End:0x11D
            break;
        // End:0x5B
        case 360:
            HandleCrestChange(a_Param);
        // End:0x71
        case 430:
            HandleClanMemberInfo(a_Param);
            // End:0x11D
            break;
        // End:0x87
        case 490:
            HandleSkillList(a_Param);
            // End:0x11D
            break;
        // End:0x9D
        case 500:
            HandleSkillList(a_Param);
            // End:0x11D
            break;
        // End:0xB3
        case 370:
            HandleClanAuth(a_Param);
            // End:0x11D
            break;
        // End:0xC9
        case 380:
            HandleClanAuthMember(a_Param);
            // End:0x11D
            break;
        // End:0xE5
        case 160:
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName);
            // End:0x11D
            break;
        // End:0xFB
        case 470:
            HandleClearWarList(a_Param);
            // End:0x11D
            break;
        // End:0x10C
        case 1710:
            HandleDialogOK();
            // End:0x11D
            break;
        // End:0x117
        case 1720:
            // End:0x11D
            break;
        // End:0xFFFF
        default:
            // End:0x11D
            break;
            break;
    }
    return;
}

function HandleDialogOK()
{
    local int dialogID;

    // End:0x0D
    if(!DialogIsMine())
    {
        return;
    }
    dialogID = DialogGetID();
    // End:0x5F
    if(dialogID == 90009)
    {
        RequestClanWarList(0, 0);
        SetStateAndShow("ClanWarManagementWndState");
        RequestSurrenderPledgeWar(currentLossWarClanName);        
    }
    else
    {
        // End:0x74
        if(dialogID == 487)
        {
            HandleCancelWar1();
        }
    }
    switchingWarCancelButton();
    return;
}

function HandleClanAuthGradeList(string a_Param)
{
    local int Count, Id, members, i;
    local LVDataRecord Record;
    local LVData Data;

    Record.LVDataList.Length = 2;
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName $ ".Clan5_AuthListCtrl");
    ParseInt(a_Param, "Count", Count);
    i = 0;
    J0x57:

    // End:0x148 [Loop If]
    if(i < 5)
    {
        ParseInt(a_Param, "GradeID" $ string(i), Id);
        ParseInt(a_Param, "GradeMemberCount" $ string(i), members);
        Data.szData = GetStringByGradeID(Id);
        Record.LVDataList[0] = Data;
        Data.szData = string(members);
        Record.LVDataList[1] = Data;
        Record.nReserved1 = (Id);
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName $ ".Clan5_AuthListCtrl", Record);
        ++i;
        // [Loop Continue]
        goto J0x57;
    }
    Class'NWindow.UIAPI_LISTCTRL'.static.SetSelectedIndex(m_WindowName $ ".Clan5_AuthListCtrl", 0, true);
    return;
}

function HandleClanWarList(string a_Param)
{
    local LVDataRecord Record;
    local int page;
    local string sClanName;
    local int State, progressTimeInSec;
    local Color colorValue;
    local int totalWarSec, point, pointDiff, leftKillCountOfEnemyToWar;

    ParseInt(a_Param, "Page", page);
    ParseString(a_Param, "ClanName", sClanName);
    ParseInt(a_Param, "State", State);
    ParseInt(a_Param, "ProgressTimeInSec", progressTimeInSec);
    ParseInt(a_Param, "Point", point);
    ParseInt(a_Param, "PointDiff", pointDiff);
    ParseInt(a_Param, "LeftKillCountOfEnemyToWar", leftKillCountOfEnemyToWar);
    totalWarSec = ((60 * 60) * 24) * 7;
    colorValue.R = 220;
    colorValue.G = 220;
    colorValue.B = 220;
    Record.LVDataList.Length = 7;
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[0].szData = sClanName;
    Record.LVDataList[0].TextColor = colorValue;
    Record.LVDataList[1].bUseTextColor = true;
    Record.LVDataList[1].szData = getWarStateString(State);
    Record.LVDataList[1].TextColor = colorValue;
    Record.LVDataList[1].nReserved1 = State;
    Record.LVDataList[2].nReserved1 = getWarType(point);
    Record.LVDataList[2].szData = "";
    Record.LVDataList[2].szTexture = getWarSituationTexture(point);
    Record.LVDataList[2].nTextureWidth = 11;
    Record.LVDataList[2].nTextureHeight = 11;
    Record.LVDataList[3].bUseTextColor = true;
    Record.LVDataList[3].szData = string(point);
    Record.LVDataList[3].TextColor = colorValue;
    Record.LVDataList[3].nReserved1 = point;
    Record.LVDataList[4].nReserved1 = pointDiff;
    Record.LVDataList[5].nReserved1 = leftKillCountOfEnemyToWar;
    Record.LVDataList[6].nReserved1 = totalWarSec - progressTimeInSec;
    m_clanWarListPage = page;
    m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(0, 2);
    m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(1, 2);
    m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(2, 2);
    m_hClanDrawerWndClan8_DeclaredListCtrl.SetHeaderAlignment(3, 2);
    Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName $ ".Clan8_DeclaredListCtrl", Record);
    switchingWarCancelButton();
    return;
}

function switchingWarCancelButton()
{
    local int Len;

    Len = m_hClanDrawerWndClan8_DeclaredListCtrl.GetRecordCount();
    // End:0x4F
    if(Len > 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan8_CancelWar1Btn");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan8_CancelWar1Btn");
    }
    return;
}

function string getWarStateString(int State)
{
    // End:0x1A
    if(State == 0)
    {
        return GetSystemString(2349);        
    }
    else
    {
        // End:0x34
        if(State == 1)
        {
            return GetSystemString(2350);            
        }
        else
        {
            // End:0x4F
            if(State == 2)
            {
                return GetSystemString(340);                
            }
            else
            {
                // End:0x6A
                if(State == 3)
                {
                    return GetSystemString(828);                    
                }
                else
                {
                    // End:0x85
                    if(State == 4)
                    {
                        return GetSystemString(2356);                        
                    }
                    else
                    {
                        // End:0x9D
                        if(State == 5)
                        {
                            return GetSystemString(846);
                        }
                    }
                }
            }
        }
    }
    return "Error";
    return;
}

function string getWarSituationString(int pointDiff)
{
    local string returnStr;

    returnStr = "(";
    switch(getWarType(pointDiff))
    {
        // End:0x35
        case 0:
            returnStr = returnStr $ GetSystemString(2355);
            // End:0xB7
            break;
        // End:0x54
        case 1:
            returnStr = returnStr $ GetSystemString(2354);
            // End:0xB7
            break;
        // End:0x74
        case 2:
            returnStr = returnStr $ GetSystemString(2353);
            // End:0xB7
            break;
        // End:0x94
        case 3:
            returnStr = returnStr $ GetSystemString(2352);
            // End:0xB7
            break;
        // End:0xB4
        case 4:
            returnStr = returnStr $ GetSystemString(2351);
            // End:0xB7
            break;
        // End:0xFFFF
        default:
            break;
    }
    returnStr = returnStr $ ")";
    return returnStr;
    return;
}

function string getWarSituationTexture(int pointDiff)
{
    local string returnStr;

    switch(getWarType(pointDiff))
    {
        // End:0x3B
        case 0:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow5";
            // End:0xF9
            break;
        // End:0x69
        case 1:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow4";
            // End:0xF9
            break;
        // End:0x98
        case 2:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow3";
            // End:0xF9
            break;
        // End:0xC7
        case 3:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow2";
            // End:0xF9
            break;
        // End:0xF6
        case 4:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow1";
            // End:0xF9
            break;
        // End:0xFFFF
        default:
            break;
    }
    return returnStr;
    return;
}

function int getWarType(int Value)
{
    local int Num;

    // End:0x19
    if(Value <= -50)
    {
        Num = 0;        
    }
    else
    {
        // End:0x43
        if((Value > -50) && Value <= -20)
        {
            Num = 1;            
        }
        else
        {
            // End:0x6B
            if((Value > -20) && Value <= 19)
            {
                Num = 2;                
            }
            else
            {
                // End:0x90
                if((Value > 19) && Value <= 49)
                {
                    Num = 3;                    
                }
                else
                {
                    // End:0xA4
                    if(Value >= 50)
                    {
                        Num = 4;
                    }
                }
            }
        }
    }
    return Num;
    return;
}

function string getSecToDateStr(int Sec, bool onlyDayFlag)
{
    local string returnStr;
    local int RemainSec, m_timeDay, m_timeHour, m_timeMin;

    m_timeDay = Sec / 86400;
    RemainSec = int(float(Sec) % float(86400));
    m_timeHour = (RemainSec / 60) / 60;
    m_timeMin = int(float(RemainSec / 60) % float(60));
    returnStr = "";
    // End:0x83
    if(m_timeDay > 0)
    {
        returnStr = string(m_timeDay) $ GetSystemString(1109);
    }
    // End:0x169
    if(onlyDayFlag == false)
    {
        // End:0xAB
        if(returnStr != "")
        {
            returnStr = returnStr $ "/";
        }
        // End:0xF5
        if(m_timeHour > 0)
        {
            // End:0xDE
            if(m_timeHour < 10)
            {
                returnStr = (returnStr $ "0") $ string(m_timeHour);                
            }
            else
            {
                returnStr = returnStr $ string(m_timeHour);
            }            
        }
        else
        {
            returnStr = returnStr $ "/00";
        }
        // End:0x157
        if(m_timeMin > 0)
        {
            // End:0x13B
            if(m_timeMin < 10)
            {
                returnStr = (returnStr $ ":0") $ string(m_timeMin);                
            }
            else
            {
                returnStr = (returnStr $ ":") $ string(m_timeMin);
            }            
        }
        else
        {
            returnStr = returnStr $ ":00";
        }
    }
    return returnStr;
    return;
}

function HandleClanMemberInfo(string a_Param)
{
    local string nickname;
    local int gradeID;
    local string organization, masterName, organizationtext;

    ParseInt(a_Param, "ClanType", m_clanType);
    ParseString(a_Param, "Name", m_currentName);
    ParseString(a_Param, "NickName", nickname);
    ParseInt(a_Param, "GradeID", gradeID);
    ParseString(a_Param, "OrderName", organization);
    ParseString(a_Param, "MasterName", masterName);
    currentMasterName = masterName;
    // End:0xBF
    if(masterName == "")
    {
        masterName = GetSystemString(27);
    }
    organizationtext = ((getClanOrderString(m_clanType)) @ "-") @ organization;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName", m_currentName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedMemberSName", nickname);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedMemberGrade", GetStringByGradeID(gradeID));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedMemberOrderName", organizationtext);
    // End:0x24D
    if(clanWndClassicScript.m_CurrentclanMasterReal == m_currentName)
    {
        // End:0x24D
        if(clanWndClassicScript.m_currentShowIndex == 0)
        {
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedMemberGrade", GetSystemString(342));
        }
    }
    clanWndClassicScript.resetBtnShowHide();
    CheckandCompareMyNameandDisableThings();
    return;
}

function CheckandCompareMyNameandDisableThings()
{
    local UserInfo UserInfo;

    GetPlayerInfo(UserInfo);
    m_myName = UserInfo.Name;
    // End:0x60
    if(clanWndClassicScript.m_bClanMaster > 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
        Proc_AuthValidation();
        // End:0x19C
        if(clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex) < clanWndClassicScript.m_myClanType)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
            // End:0x16A
            if(m_clanType == -1)
            {                
            }
            else
            {
                Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
            }
        }
        // End:0x2FD
        if(clanWndClassicScript.m_myClanType > 1)
        {
            // End:0x2FD
            if(clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex) != 0)
            {
                // End:0x20C
                if((clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)) == 1)
                {
                    Proc_AuthValidation();
                }
                // End:0x249
                if((clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)) == 1000)
                {
                    Proc_AuthValidation();
                }
                // End:0x283
                if((clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)) == 100)
                {
                    Proc_AuthValidation();
                }
                // End:0x2C0
                if((clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)) == 999)
                {
                    Proc_AuthValidation();
                }
                // End:0x2FD
                if((clanWndClassicScript.m_myClanType - clanWndClassicScript.GetClanTypeFromIndex(clanWndClassicScript.m_currentShowIndex)) == 1001)
                {
                    Proc_AuthValidation();
                }
            }
        }
        // End:0x3A5
        if(clanWndClassicScript.G_CurrentAlias == true)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
        }
        // End:0x450
        if(clanWndClassicScript.m_CurrentclanMasterReal == m_currentName)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
        }
    }
    // End:0x4C0
    if(m_currentName == m_myName)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
    }
    // End:0x502
    if(m_clanType == -1)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
    }
    return;
}

function Proc_AuthValidation()
{
    // End:0xA9
    if(clanWndClassicScript.m_bNickName == 0)
    {
        // End:0x74
        if((clanWndClassicScript.G_IamHero == true) || clanWndClassicScript.G_IamNobless > 0)
        {
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
        }        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
    }
    // End:0x125
    if(clanWndClassicScript.m_bGrade == 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
    }
    // End:0x19D
    if(clanWndClassicScript.m_bOustMember == 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
    }
    return;
}

function HandleCrestChange(string param)
{
    // End:0x5F
    if(m_state == "ClanEmblemManageWndState")
    {
        Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTextureWithClanCrest(m_WindowName $ ".ClanCrestTextureCtrl", clanWndClassicScript.m_clanID);
    }
    return;
}

function HandleSkillList(string a_Param)
{
    local int Count, i, Level;
    local ItemID cID;

    ParseInt(a_Param, "Count", Count);
    i = 0;
    J0x1E:

    // End:0x82 [Loop If]
    if(i < Count)
    {
        ParseItemIDWithIndex(a_Param, cID, i);
        ParseInt(a_Param, "SkillLevel_" $ string(i), Level);
        AddSkill(cID, Level);
        ++i;
        // [Loop Continue]
        goto J0x1E;
    }
    return;
}

function HandleDeclareLoseWar()
{
    local LVDataRecord Record;
    local int Index;

    Index = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName $ ".Clan8_DeclaredListCtrl");
    // End:0xAA
    if(Index >= 0)
    {
        m_hClanDrawerWndClan8_DeclaredListCtrl.GetRec(Index, Record);
        currentLossWarClanName = Record.LVDataList[0].szData;
        DialogSetID(90009);
        DialogShow(1, 0, MakeFullSystemMsg(GetSystemMessage(3409), Record.LVDataList[0].szData), string(self));
    }
    return;
}

function bool searchClanWarDeclare(string ClanName)
{
    local LVDataRecord Record;
    local int i, maxRec;
    local bool bCheck;

    bCheck = false;
    maxRec = m_hClanDrawerWndClan8_DeclaredListCtrl.GetRecordCount();
    i = 0;
    J0x24:

    // End:0x93 [Loop If]
    if(i < maxRec)
    {
        m_hClanDrawerWndClan8_DeclaredListCtrl.GetRec(i, Record);
        // End:0x89
        if(Record.LVDataList[0].szData == ClanName)
        {
            // End:0x89
            if(Record.LVDataList[1].nReserved1 == 1)
            {
                bCheck = true;
                // [Explicit Break]
                goto J0x93;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x24;
    }
    J0x93:

    return bCheck;
    return;
}

function HandleCancelWar1()
{
    local LVDataRecord Record;
    local int Index;

    Index = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName $ ".Clan8_DeclaredListCtrl");
    // End:0x99
    if(Index >= 0)
    {
        m_hClanDrawerWndClan8_DeclaredListCtrl.GetRec(Index, Record);
        RequestClanWithdrawWarWithClanName(Record.LVDataList[0].szData);
        RequestClanWarList(0, 0);
        SetStateAndShow("ClanWarManagementWndState");
    }
    return;
}

function HandleDeclareWar()
{
    local LVDataRecord Record;
    local int Index;

    Index = m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetSelectedIndex();
    // End:0x5C
    if(Index >= 0)
    {
        m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetRec(Index, Record);
        RequestClanDeclareWarWithClanName(Record.LVDataList[0].szData);
        RequestClanWarList(m_clanWarListPage, 1);
    }
    return;
}

function HandleCancelWar2()
{
    local LVDataRecord Record;
    local int Index;

    Index = m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetSelectedIndex();
    // End:0x89
    if(Index >= 0)
    {
        m_hClanDrawerWndClan8_GotDeclaredListCtrl.GetRec(Index, Record);
        RequestClanWithdrawWarWithClanName(Record.LVDataList[0].szData);
        RequestClanWarList(m_clanWarListPage, 1);
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanWarManagementWnd");
    }
    return;
}

function HandleClanAuth(string a_Param)
{
    local int gradeID, Command;
    local array<int> powers;
    local int i, Index;

    ParseInt(a_Param, "GradeID", gradeID);
    ParseInt(a_Param, "Command", Command);
    powers.Length = 32;
    i = 0;
    J0x42:

    // End:0x83 [Loop If]
    if(i < 32)
    {
        ParseInt(a_Param, "PowerValue" $ string(i), powers[i]);
        ++i;
        // [Loop Continue]
        goto J0x42;
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan6_CurrentSelectedRankName", (GetStringByGradeID(gradeID)) $ GetSystemString(1376));
    Index = 1;
    i = 1;
    J0xDF:

    // End:0x17F [Loop If]
    if(i <= 10)
    {
        // End:0x138
        if(i < 10)
        {
            Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check10") $ string(i), bool(powers[Index++]));
            // [Explicit Continue]
            goto J0x175;
        }
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check1") $ string(i), bool(powers[Index++]));
        J0x175:

        ++i;
        // [Loop Continue]
        goto J0xDF;
    }
    i = 1;
    J0x186:

    // End:0x1DA [Loop If]
    if(i <= 5)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check20") $ string(i), bool(powers[Index++]));
        ++i;
        // [Loop Continue]
        goto J0x186;
    }
    i = 1;
    J0x1E1:

    // End:0x235 [Loop If]
    if(i <= 8)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check30") $ string(i), bool(powers[Index++]));
        ++i;
        // [Loop Continue]
        goto J0x1E1;
    }
    // End:0x271
    if((count_all_check("1", 10)) == true)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check100", true);        
    }
    else
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check100", false);
    }
    // End:0x2D5
    if((count_all_check("2", 5)) == true)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check200", true);        
    }
    else
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check200", false);
    }
    // End:0x339
    if((count_all_check("3", 8)) == true)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check300", true);        
    }
    else
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check300", false);
    }
    // End:0x376
    if(gradeID == 9)
    {
        disableAcademyAuth();        
    }
    else
    {
        resetAcademyAuth();
    }
    return;
}

function HandleClanAuthMember(string a_Param)
{
    local int gradeID;
    local string sName;
    local array<int> powers;
    local int i, Index;

    ParseInt(a_Param, "Grade", gradeID);
    ParseString(a_Param, "Name", sName);
    powers.Length = 32;
    i = 0;
    J0x3D:

    // End:0x7E [Loop If]
    if(i < 32)
    {
        ParseInt(a_Param, "PowerValue" $ string(i), powers[i]);
        ++i;
        // [Loop Continue]
        goto J0x3D;
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan2_CurrentSelectedMemberName", (sName @ "-") @ (GetStringByGradeID(gradeID)));
    Index = 1;
    i = 1;
    J0xDB:

    // End:0x17B [Loop If]
    if(i <= 10)
    {
        // End:0x134
        if(i < 10)
        {
            Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check10") $ string(i), bool(powers[Index++]));
            // [Explicit Continue]
            goto J0x171;
        }
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check1") $ string(i), bool(powers[Index++]));
        J0x171:

        ++i;
        // [Loop Continue]
        goto J0xDB;
    }
    i = 1;
    J0x182:

    // End:0x1D6 [Loop If]
    if(i <= 5)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check20") $ string(i), bool(powers[Index++]));
        ++i;
        // [Loop Continue]
        goto J0x182;
    }
    i = 1;
    J0x1DD:

    // End:0x231 [Loop If]
    if(i <= 8)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check30") $ string(i), bool(powers[Index++]));
        ++i;
        // [Loop Continue]
        goto J0x1DD;
    }
    // End:0x26D
    if((count_all_check2("1", 10)) == true)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check100", true);        
    }
    else
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check100", false);
    }
    // End:0x2D1
    if((count_all_check2("2", 5)) == true)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check200", true);        
    }
    else
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check200", false);
    }
    // End:0x335
    if((count_all_check2("3", 8)) == true)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check300", true);        
    }
    else
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check300", false);
    }
    // End:0x474
    if(clanWndClassicScript.m_myName == sName)
    {
        // End:0x3B5
        if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(m_WindowName $ ".Clan2_Check101") == true)
        {
            clanWndClassicScript.m_bJoin = 1;            
        }
        else
        {
            clanWndClassicScript.m_bJoin = 0;
        }
        // End:0x405
        if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(m_WindowName $ ".Clan2_Check107") == true)
        {
            clanWndClassicScript.m_bCrest = 1;            
        }
        else
        {
            clanWndClassicScript.m_bCrest = 0;
        }
        // End:0x455
        if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(m_WindowName $ ".Clan2_Check105") == true)
        {
            clanWndClassicScript.m_bWar = 1;            
        }
        else
        {
            clanWndClassicScript.m_bWar = 0;
        }
        clanWndClassicScript.resetBtnShowHide();
    }
    // End:0x600
    if(clanWndClassicScript.m_CurrentclanMasterReal == sName)
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan2_CurrentSelectedMemberName", (sName @ "-") @ GetSystemString(342));
        i = 0;
        J0x4E2:

        // End:0x566 [Loop If]
        if(i <= 10)
        {
            // End:0x52D
            if(i < 10)
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check10") $ string(i), true);
                // [Explicit Continue]
                goto J0x55C;
            }
            Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check1") $ string(i), true);
            J0x55C:

            ++i;
            // [Loop Continue]
            goto J0x4E2;
        }
        i = 0;
        J0x56D:

        // End:0x5B3 [Loop If]
        if(i <= 5)
        {
            Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check20") $ string(i), true);
            ++i;
            // [Loop Continue]
            goto J0x56D;
        }
        i = 0;
        J0x5BA:

        // End:0x600 [Loop If]
        if(i <= 8)
        {
            Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check30") $ string(i), true);
            ++i;
            // [Loop Continue]
            goto J0x5BA;
        }
    }
    return;
}

function HandleClearWarList(string a_Param)
{
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName $ ".Clan8_DeclaredListCtrl");
    switchingWarCancelButton();
    return;
}

function string GetStringByGradeID(int gradeID)
{
    local int stringIndex;

    stringIndex = -1;
    // End:0x24
    if(gradeID == 1)
    {
        stringIndex = 1406;        
    }
    else
    {
        // End:0x3E
        if(gradeID == 2)
        {
            stringIndex = 1407;            
        }
        else
        {
            // End:0x58
            if(gradeID == 3)
            {
                stringIndex = 1408;                
            }
            else
            {
                // End:0x72
                if(gradeID == 4)
                {
                    stringIndex = 1409;                    
                }
                else
                {
                    // End:0x8C
                    if(gradeID == 5)
                    {
                        stringIndex = 1410;                        
                    }
                    else
                    {
                        // End:0xA6
                        if(gradeID == 6)
                        {
                            stringIndex = 1411;                            
                        }
                        else
                        {
                            // End:0xC0
                            if(gradeID == 7)
                            {
                                stringIndex = 1412;                                
                            }
                            else
                            {
                                // End:0xDA
                                if(gradeID == 8)
                                {
                                    stringIndex = 1413;                                    
                                }
                                else
                                {
                                    // End:0xF1
                                    if(gradeID == 9)
                                    {
                                        stringIndex = 1414;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // End:0x10F
    if(stringIndex != -1)
    {
        return GetSystemString(stringIndex);        
    }
    else
    {
        return "";
    }
    return;
}

function InitializeClanInfoWnd()
{
    local Color Blue, Red, DarkYellow;
    local SkillTrainClanTreeWnd script2;
    local int i;
    local string ClanNameVal, ClanRankStr, ToolTip;
    local int clanType;

    Blue.R = 126;
    Blue.G = 158;
    Blue.B = 245;
    Red.R = 200;
    Red.G = 50;
    Red.B = 80;
    DarkYellow.R = 175;
    DarkYellow.G = 152;
    DarkYellow.B = 120;
    script2 = SkillTrainClanTreeWnd(GetScript("SkillTrainClanTreeWnd"));
    ClanNameVal = string(clanWndClassicScript.m_clanNameValue) @ GetSystemString(1442);
    // End:0xE8
    if(clanWndClassicScript.m_clanRank == 0)
    {
        ClanRankStr = GetSystemString(1374);        
    }
    else
    {
        // End:0x123
        if(clanWndClassicScript.m_clanRank <= 100)
        {
            ClanRankStr = string(clanWndClassicScript.m_clanRank) @ GetSystemString(1375);            
        }
        else
        {
            ClanRankStr = GetSystemString(1374);
        }
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan3_ClanName", clanWndClassicScript.m_clanName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan3_ClanPoint", ClanNameVal);
    // End:0x1DA
    if(clanWndClassicScript.m_clanNameValue == 0)
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName $ ".Clan3_ClanPoint", DarkYellow);        
    }
    else
    {
        // End:0x21E
        if(clanWndClassicScript.m_clanNameValue < 0)
        {
            Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName $ ".Clan3_ClanPoint", Red);            
        }
        else
        {
            // End:0x25F
            if(clanWndClassicScript.m_clanNameValue > 0)
            {
                Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName $ ".Clan3_ClanPoint", Blue);
            }
        }
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan3_ClanRanking", ClanRankStr);
    i = 0;
    J0x295:

    // End:0x482 [Loop If]
    if(i < 8)
    {
        // End:0x478
        if(clanWndClassicScript.m_memberList[i].m_sName != "")
        {
            clanType = clanWndClassicScript.GetClanTypeFromIndex(i);
            // End:0x33A
            if(clanType == 0)
            {
                ToolTip = (((clanWndClassicScript.m_memberList[i].m_sName $ "\\n") $ GetSystemString(342)) $ " : ") $ clanWndClassicScript.m_memberList[i].m_sMasterName;
            }
            // End:0x368
            if(clanType == -1)
            {
                ToolTip = clanWndClassicScript.m_memberList[i].m_sName;
            }
            // End:0x3D6
            if((clanType == 100) || clanType == 200)
            {
                ToolTip = (((clanWndClassicScript.m_memberList[i].m_sName $ "\\n") $ GetSystemString(1438)) $ " : ") $ clanWndClassicScript.m_memberList[i].m_sMasterName;
            }
            // End:0x46C
            if((((clanType == 1001) || clanType == 1002) || clanType == 2001) || clanType == 2002)
            {
                ToolTip = (((clanWndClassicScript.m_memberList[i].m_sName $ "\\n") $ GetSystemString(1433)) $ " : ") $ clanWndClassicScript.m_memberList[i].m_sMasterName;
            }
            // End:0x478
            if(ToolTip != "")
            {
            }
        }
        ++i;
        // [Loop Continue]
        goto J0x295;
    }
    return;
}

function InitializeGradeComboBox()
{
    local int i;

    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(m_WindowName $ ".Clan1_MemberGradeList");
    i = 1;
    J0x35:

    // End:0x84 [Loop If]
    if(i < 6)
    {
        Class'NWindow.UIAPI_COMBOBOX'.static.AddString(m_WindowName $ ".Clan1_MemberGradeList", GetStringByGradeID(i));
        ++i;
        // [Loop Continue]
        goto J0x35;
    }
    Class'NWindow.UIAPI_COMBOBOX'.static.AddString(m_WindowName $ ".Clan1_MemberGradeList", GetSystemString(1451));
    return;
}

function KnighthoodCombobox()
{
    local int i;

    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(m_WindowName $ ".Clan1_targetknighthoodcombobox");
    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(m_WindowName $ ".Clan1_targetknighthoodmember");
    Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".Clan1_targetknighthoodcombobox", GetSystemString(1465), 0);
    Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".Clan1_targetknighthoodmember", GetSystemString(1466), 0);
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_targetknighthoodmember");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodBtn");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_ChangeMemberKnightHoodTXT1", MakeFullSystemMsg(GetSystemMessage(1906), m_currentName, ""));
    i = 0;
    J0x1B5:

    // End:0x267 [Loop If]
    if(i < clanWndClassicScript.8)
    {
        // End:0x25D
        if(clanWndClassicScript.m_memberList[i].m_sName != "")
        {
            // End:0x25D
            if(clanWndClassicScript.GetClanTypeFromIndex(i) != -1)
            {
                Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".Clan1_targetknighthoodcombobox", clanWndClassicScript.m_memberList[i].m_sName, i);
            }
        }
        ++i;
        // [Loop Continue]
        goto J0x1B5;
    }
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".Clan1_targetknighthoodcombobox", 0);
    return;
}

function swapTargetSelect(int clanNo)
{
    local int i;

    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(m_WindowName $ ".Clan1_targetknighthoodmember");
    Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".Clan1_targetknighthoodmember", GetSystemString(1466), 0);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_ChangeMemberKnightHoodTXT1", MakeFullSystemMsg(GetSystemMessage(1907), m_currentName, ""));
    i = 0;
    J0xCE:

    // End:0x1B0 [Loop If]
    if(i <= clanWndClassicScript.m_memberList[clanNo].m_array.Length)
    {
        // End:0x1A6
        if(clanWndClassicScript.m_memberList[clanNo].m_array[i].sName != clanWndClassicScript.m_CurrentclanMasterReal)
        {
            Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".Clan1_targetknighthoodmember", clanWndClassicScript.m_memberList[clanNo].m_array[i].sName, clanWndClassicScript.m_memberList[clanNo].m_array[i].clanType);
        }
        ++i;
        // [Loop Continue]
        goto J0xCE;
    }
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".Clan1_targetknighthoodmember", 0);
    return;
}

function proc_swapmember()
{
    local int currentindexnew1, currentindexnew2;
    local string currentstring1, currentstring2;
    local int Type, clantype1;

    currentindexnew1 = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".Clan1_targetknighthoodcombobox");
    currentstring1 = Class'NWindow.UIAPI_COMBOBOX'.static.GetString(m_WindowName $ ".Clan1_targetknighthoodcombobox", currentindexnew1);
    clantype1 = clanWndClassicScript.GetClanTypeFromIndex(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".Clan1_targetknighthoodcombobox", currentindexnew1));
    currentindexnew2 = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".Clan1_targetknighthoodmember");
    currentstring2 = Class'NWindow.UIAPI_COMBOBOX'.static.GetString(m_WindowName $ ".Clan1_targetknighthoodmember", currentindexnew2);
    // End:0x160
    if(currentindexnew2 == 0)
    {
        Type = 0;        
    }
    else
    {
        Type = 1;
    }
    // End:0x18B
    if(Type == 1)
    {
        RequestClanReorganizeMember(1, m_currentName, clantype1, currentstring2);        
    }
    else
    {
        // End:0x1A9
        if(Type == 0)
        {
            RequestClanReorganizeMember(0, m_currentName, clantype1, "");
        }
    }
    return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
    local int selectval;

    // End:0xE4
    if(strID == "Clan1_targetknighthoodcombobox")
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_targetknighthoodmember");
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodBtn");
        selectval = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".Clan1_targetknighthoodcombobox", Index);
        swapTargetSelect(selectval);
    }
    return;
}

function HideClanWindow()
{
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName);
    clanWndClassicScript.ResetOpeningVariables();
    switchingWarCancelButton();
    return;
}

function ApplyEditGrade()
{
    local array<int> powers;
    local int i, Index;

    powers.Length = 32;
    powers[0] = 0;
    Index = 1;
    i = 1;
    J0x20:

    // End:0xC9 [Loop If]
    if(i <= 10)
    {
        // End:0x7A
        if(i < 10)
        {
            // End:0x77
            if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_WindowName $ ".Clan6_Check10") $ string(i)))
            {
                powers[Index] = 1;
            }            
        }
        else
        {
            // End:0xB8
            if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_WindowName $ ".Clan6_Check1") $ string(i)))
            {
                powers[Index] = 1;
            }
        }
        ++Index;
        ++i;
        // [Loop Continue]
        goto J0x20;
    }
    i = 1;
    J0xD0:

    // End:0x12C [Loop If]
    if(i <= 5)
    {
        // End:0x11B
        if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_WindowName $ ".Clan6_Check20") $ string(i)))
        {
            powers[Index] = 1;
        }
        ++Index;
        ++i;
        // [Loop Continue]
        goto J0xD0;
    }
    i = 1;
    J0x133:

    // End:0x18F [Loop If]
    if(i <= 8)
    {
        // End:0x17E
        if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked((m_WindowName $ ".Clan6_Check30") $ string(i)))
        {
            powers[Index] = 1;
        }
        ++Index;
        ++i;
        // [Loop Continue]
        goto J0x133;
    }
    RequestEditClanAuth(m_currentEditGradeID, powers);
    return;
}

function EditAuthGrade()
{
    local int Index;
    local LVDataRecord Record;

    Index = m_hClanDrawerWndClan5_AuthListCtrl.GetSelectedIndex();
    // End:0x7C
    if(Index >= 0)
    {
        m_hClanDrawerWndClan5_AuthListCtrl.GetRec(Index, Record);
        RequestClanAuth(name(Record.nReserved1));
        m_currentEditGradeID = name(Record.nReserved1);
        SetStateAndShow("ClanAuthEditWndState");        
    }
    else
    {
        SetStateAndShow("ClanAuthManageWndState");
    }
    return;
}

function AddSkill(ItemID cID, int Level)
{
    local ItemInfo Info;

    Info.Id = cID;
    Info.Level = Level;
    Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, Info.SubLevel);
    Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
    Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, Info.SubLevel);
    Info.AdditionalName = Class'NWindow.UIDATA_SKILL'.static.GetEnchantName(Info.Id, Info.Level, Info.SubLevel);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(m_WindowName $ ".ClanSkillWnd", Info);
    return;
}

function ReplaceSkill(int Index, ItemID cID, int Level)
{
    local ItemInfo Info;

    Info.Id = cID;
    Info.Level = Level;
    Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, Info.SubLevel);
    Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
    Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, Info.SubLevel);
    Info.AdditionalName = Class'NWindow.UIDATA_SKILL'.static.GetEnchantName(Info.Id, Info.Level, Info.SubLevel);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem(m_WindowName $ ".ClanSkillWnd", Index, Info);
    return;
}

function string getClanOrderString(int gradeID)
{
    local int stringIndex;

    stringIndex = -1;
    // End:0x24
    if(gradeID == 0)
    {
        stringIndex = 1399;        
    }
    else
    {
        // End:0x3E
        if(gradeID == 100)
        {
            stringIndex = 1400;            
        }
        else
        {
            // End:0x58
            if(gradeID == 200)
            {
                stringIndex = 1401;                
            }
            else
            {
                // End:0x75
                if(gradeID == 1001)
                {
                    stringIndex = 1402;                    
                }
                else
                {
                    // End:0x92
                    if(gradeID == 1002)
                    {
                        stringIndex = 1403;                        
                    }
                    else
                    {
                        // End:0xAF
                        if(gradeID == 2001)
                        {
                            stringIndex = 1404;                            
                        }
                        else
                        {
                            // End:0xCC
                            if(gradeID == 2002)
                            {
                                stringIndex = 1405;                                
                            }
                            else
                            {
                                // End:0xE6
                                if(gradeID == -1)
                                {
                                    stringIndex = 1419;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // End:0x104
    if(stringIndex != -1)
    {
        return GetSystemString(stringIndex);        
    }
    else
    {
        return "";
    }
    return;
}

function disableAcademyAuth()
{
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check100", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check101", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check102", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check106", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check104", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check105", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check107", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check200", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check203", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check204", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check205", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check300", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check303", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check305", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check306", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check307", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check308", true);
    return;
}

function resetAcademyAuth()
{
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check100", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check101", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check102", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check106", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check104", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check105", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check107", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check200", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check203", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check204", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check205", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check300", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check303", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check305", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check306", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check307", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check308", false);
    return;
}

function int getCurrentGradebyClanType()
{
    local int GradeNum;

    switch(m_clanType)
    {
        // End:0x16
        case 0:
            GradeNum = 6;
            // End:0x98
            break;
        // End:0x26
        case 100:
            GradeNum = 7;
            // End:0x98
            break;
        // End:0x36
        case 200:
            GradeNum = 7;
            // End:0x98
            break;
        // End:0x49
        case 1001:
            GradeNum = 8;
            // End:0x98
            break;
        // End:0x5C
        case 1002:
            GradeNum = 8;
            // End:0x98
            break;
        // End:0x6F
        case 2001:
            GradeNum = 8;
            // End:0x98
            break;
        // End:0x82
        case 2002:
            GradeNum = 8;
            // End:0x98
            break;
        // End:0x95
        case -1:
            GradeNum = 9;
            // End:0x98
            break;
        // End:0xFFFF
        default:
            break;
    }
    return GradeNum;
    return;
}

function CustomTooltip SetTooltip(string Text)
{
    local CustomTooltip ToolTip;
    local DrawItemInfo Info;

    ToolTip.MinimumWidth = 144;
    ToolTip.DrawList.Length = 1;
    Info.eType = 1;
    Info.t_color.R = 178;
    Info.t_color.G = 190;
    Info.t_color.B = 207;
    Info.t_color.A = byte(255);
    Info.t_strText = Text;
    ToolTip.DrawList[0] = Info;
    return ToolTip;
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

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="ClanDrawerWndClassic"
    m_ClanPledgeBonusDrawerWndName="ClanPledgeBonusDrawerWndClassic"
}