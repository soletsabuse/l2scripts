class ClanDrawerWnd extends UICommonAPI;

const DIALOG_AskLossClanWar = 90009;
const DIALOG_AskClanWarCancel = 487;
const c_maxranklimit = 100;
const changelineval1 = 23;
const DISABLE_ALPHA = 100;
const ACADEMY_INDEX = 7;

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
var ListCtrlHandle m_hClanDrawerWndClan1_AssignApprenticeList;
var ListCtrlHandle m_hClanDrawerWndClan8_DeclaredListCtrl;
var ListCtrlHandle m_hClanDrawerWndClan8_GotDeclaredListCtrl;
var ListCtrlHandle m_hClanDrawerWndClan5_AuthListCtrl;
var ListCtrlHandle m_hClanDrawerWndClan5_AuthListCtrl2;
var int ClanClickedID;
var WindowHandle Clan3_OrgIcon[8];
var TextureHandle Clan3_OrgHighLight[8];
var FileRegisterWnd fileRegisterWndHandle;

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
    ClanClickedID = -1;
    m_hClanDrawerWndClan1_AssignApprenticeList = GetListCtrlHandle(m_WindowName $ ".Clan1_AssignApprenticeList");
    m_hClanDrawerWndClan8_DeclaredListCtrl = GetListCtrlHandle(m_WindowName $ ".Clan8_DeclaredListCtrl");
    m_hClanDrawerWndClan8_GotDeclaredListCtrl = GetListCtrlHandle(m_WindowName $ ".Clan8_DeclaredListCtrl");
    m_hClanDrawerWndClan5_AuthListCtrl = GetListCtrlHandle(m_WindowName $ ".Clan5_AuthListCtrl");
    m_hClanDrawerWndClan5_AuthListCtrl2 = GetListCtrlHandle(m_WindowName $ ".Clan5_AuthListCtrl2");
    fileRegisterWndHandle = FileRegisterWnd(GetScript("FileRegisterWnd"));
    return;
}

function InitHandle()
{
    local int i;

    i = 0;
    J0x07:

    // End:0xEC [Loop If]
    if(i < 8)
    {
        Clan3_OrgIcon[i] = GetWindowHandle((m_WindowName $ ".Clan3_OrgIcon") $ string(i + 1));
        Clan3_OrgHighLight[i] = GetTextureHandle(((m_WindowName $ ".Clan3_OrgIconWnd") $ string(i + 1)) $ ".texIconHighlight");
        // End:0xCD
        if(i == 7)
        {
            Clan3_OrgIcon[i].DisableWindow();
            Clan3_OrgIcon[i].SetAlpha(100);
        }
        Clan3_OrgHighLight[i].HideWindow();
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnShow()
{
    local ClanWnd script;

    script = ClanWnd(GetScript("ClanWnd"));
    // End:0x47
    if(GetWindowHandle(m_ClanPledgeBonusDrawerWndName).IsShowWindow())
    {
        GetWindowHandle(m_ClanPledgeBonusDrawerWndName).HideWindow();
    }
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
    // End:0x299
    if(script.m_bClanMaster == 0)
    {
        // End:0x198
        if(script.m_bNickName == 0)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
        }
        // End:0x1DF
        if(script.m_bGrade == 0)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
        }
        // End:0x257
        if(script.m_bManageMaster == 0)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
        }
        // End:0x299
        if(script.m_bOustMember == 0)
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
    Debug("SetStateAndShow" @ string(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd")));
    // End:0x85
    if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanDrawerWnd"))
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ClanDrawerWnd");
    }
    HideAll();
    // End:0x1AA
    if(m_state == "ClanMemberInfoState")
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanMemberInfoWnd");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_AssignApprenticeWnd");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");        
    }
    else
    {
        // End:0x31B
        if(m_state == "ClanMemberAuthState")
        {
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanMemberAuthWnd");
            i = 0;
            J0x1FA:

            // End:0x27E [Loop If]
            if(i <= 10)
            {
                // End:0x245
                if(i < 10)
                {
                    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName $ ".Clan2_Check10") $ string(i), true);
                    // [Explicit Continue]
                    goto J0x274;
                }
                Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName $ ".Clan2_Check1") $ string(i), true);
                J0x274:

                ++i;
                // [Loop Continue]
                goto J0x1FA;
            }
            i = 0;
            J0x285:

            // End:0x2CB [Loop If]
            if(i <= 5)
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName $ ".Clan2_Check20") $ string(i), true);
                ++i;
                // [Loop Continue]
                goto J0x285;
            }
            i = 0;
            J0x2D2:

            // End:0x318 [Loop If]
            if(i <= 8)
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable((m_WindowName $ ".Clan2_Check30") $ string(i), true);
                ++i;
                // [Loop Continue]
                goto J0x2D2;
            }            
        }
        else
        {
            // End:0x395
            if(m_state == "ClanInfoState")
            {
                InitializeClanInfoWnd();
                Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear(m_WindowName $ ".ClanSkillWnd");
                Class'NWindow.UIDATA_CLAN'.static.RequestClanSkillList();
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanInfoWnd");                
            }
            else
            {
                // End:0x3E4
                if(m_state == "ClanAuthManageWndState")
                {
                    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanAuthManageWnd");                    
                }
                else
                {
                    // End:0x56C
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
                        // End:0x5C1
                        if(m_state == "ClanWarManagementWndState")
                        {
                            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanWarManagementWnd");                            
                        }
                        else
                        {
                            // End:0x60C
                            if(m_state == "ClanAuthEditWndState")
                            {
                                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".ClanAuthEditWnd");                                
                            }
                            else
                            {
                                // End:0x64C
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
    local LVDataRecord Record;
    local int temp1, nClanIdx, i;
    local ClanWnd script;
    local array<string> fileextarr;

    script = ClanWnd(GetScript("ClanWnd"));
    // End:0x7C
    if(strID == "Clan1_AskJoinPartyBtn")
    {
        RequestInviteParty(Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName"));        
    }
    else
    {
        // End:0x1AD
        if(strID == "Clan1_ChangeMemberNameBtn")
        {
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_AssignApprenticeWnd");
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");
            Class'NWindow.UIAPI_EDITBOX'.static.SetString(m_WindowName $ ".Clan1_ChangeNameTextEditbox", "");            
        }
        else
        {
            // End:0x2A9
            if(strID == "Clan1_ChangeMemberGradeBtn")
            {
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_AssignApprenticeWnd");                
            }
            else
            {
                // End:0x3B1
                if(strID == "Clan1_ChangeBanishBtn")
                {
                    HideClanWindow();
                    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
                    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");
                    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_AssignApprenticeWnd");
                    RequestClanExpelMember(m_clanType, Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName"));                    
                }
                else
                {
                    // End:0x4B2
                    if(strID == "Clan1_AssignApprenticeBtn")
                    {
                        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".Clan1_AssignApprenticeWnd");
                        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
                        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");
                        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");
                        InitializeAcademyList();                        
                    }
                    else
                    {
                        // End:0x5B2
                        if(strID == "Clan1_ChangeMemberKHOpen")
                        {
                            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");
                            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_AssignApprenticeWnd");
                            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
                            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");
                            KnighthoodCombobox();                            
                        }
                        else
                        {
                            // End:0x656
                            if(strID == "Clan1_DeleteApprenticeBtn")
                            {
                                RequestClanDeletePupil(Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName"), Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedApprentice"));
                                RecallCurrentMemberInfo();                                
                            }
                            else
                            {
                                // End:0x676
                                if(strID == "Clan1_OKBtn")
                                {
                                    HideClanWindow();                                    
                                }
                                else
                                {
                                    // End:0x77E
                                    if(strID == "Clan1_ChangeNameAssignBtn")
                                    {
                                        RequestClanChangeNickName(Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName"), Class'NWindow.UIAPI_EDITBOX'.static.GetString(m_WindowName $ ".Clan1_ChangeNameTextEditbox"));
                                        Class'NWindow.UIAPI_EDITBOX'.static.SetString(m_WindowName $ ".Clan1_ChangeNameTextEditbox", "");
                                        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
                                        RecallCurrentMemberInfo();                                        
                                    }
                                    else
                                    {
                                        // End:0x854
                                        if(strID == "Clan1_ChangeNameDeleteBtn")
                                        {
                                            RequestClanChangeNickName(Class'NWindow.UIAPI_TEXTBOX'.static.GetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName"), "");
                                            Class'NWindow.UIAPI_EDITBOX'.static.SetString(m_WindowName $ ".Clan1_ChangeNameTextEditbox", "");
                                            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");
                                            RecallCurrentMemberInfo();                                            
                                        }
                                        else
                                        {
                                            // End:0x9AB
                                            if(strID == "Clan1_ChangeMemberGradeAssignBtn")
                                            {
                                                // End:0x927
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
                                                // End:0xA8C
                                                if(strID == "Clan1_ApprenticeAssignBtn")
                                                {
                                                    i = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName $ ".Clan1_AssignApprenticeList");
                                                    // End:0xA57
                                                    if((i >= 0) && m_currentName != "")
                                                    {
                                                        m_hClanDrawerWndClan1_AssignApprenticeList.GetRec(i, Record);
                                                        RequestClanAssignPupil(m_currentName, Record.LVDataList[0].szData);
                                                    }
                                                    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_AssignApprenticeWnd");                                                    
                                                }
                                                else
                                                {
                                                    // End:0xAF8
                                                    if(strID == "Clan1_ChangeMemberKnightHoodBtn")
                                                    {
                                                        proc_swapmember();
                                                        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0xB46
                                                        if(strID == "Clan1_Cancel1")
                                                        {
                                                            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberNameWnd");                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0xB99
                                                            if(strID == "Clan1_Cancel2")
                                                            {
                                                                Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberGradeNameWnd");                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0xBE7
                                                                if(strID == "Clan1_Cancel3")
                                                                {
                                                                    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_AssignApprenticeWnd");                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0xC3B
                                                                    if(strID == "Clan1_Cancel4")
                                                                    {
                                                                        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodWnd");                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0xCB8
                                                                        if(strID == "Clan7_RegEmbBtn")
                                                                        {
                                                                            // End:0xCB5
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
                                                                            // End:0xCDB
                                                                            if(strID == "Clan7_RmEmbBtn")
                                                                            {
                                                                                RequestClanUnregisterCrest();                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0xD67
                                                                                if(strID == "Clan7_RegEmb2Btn")
                                                                                {
                                                                                    // End:0xD64
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
                                                                                    // End:0xD8B
                                                                                    if(strID == "Clan7_RmEmb2Btn")
                                                                                    {
                                                                                        RequestClanUnregisterEmblem();                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        // End:0xDF0
                                                                                        if(strID == "Clan8_CancelWar1Btn")
                                                                                        {
                                                                                            Class'Interface.UICommonAPI'.static.DialogSetID(487);
                                                                                            Class'Interface.UICommonAPI'.static.DialogSetDefaultCancle();
                                                                                            DialogShow(1, 0, MakeFullSystemMsg(GetSystemMessage(3883), ""), string(self));                                                                                            
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            // End:0xE19
                                                                                            if(strID == "Clan8_DeclareWar1Btn")
                                                                                            {
                                                                                                HandleDeclareWar();                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                // End:0xE41
                                                                                                if(strID == "Clan8_CancelWar2Btn")
                                                                                                {
                                                                                                    HandleCancelWar2();                                                                                                    
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    // End:0xE6F
                                                                                                    if(strID == "Clan8_ViewMoreBtn")
                                                                                                    {
                                                                                                        RequestClanWarList(++m_clanWarListPage, 1);                                                                                                        
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        // End:0xE91
                                                                                                        if(strID == "Clan8_LoseBtn")
                                                                                                        {
                                                                                                            HandleDeclareLoseWar();                                                                                                            
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                            // End:0xEB1
                                                                                                            if(strID == "Clan2_OKBtn")
                                                                                                            {
                                                                                                                HideClanWindow();                                                                                                                
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                // End:0xED1
                                                                                                                if(strID == "Clan3_OKBtn")
                                                                                                                {
                                                                                                                    HideClanWindow();                                                                                                                    
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    // End:0xEF1
                                                                                                                    if(strID == "Clan4_OKBtn")
                                                                                                                    {
                                                                                                                        HideClanWindow();                                                                                                                        
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        // End:0xF11
                                                                                                                        if(strID == "Clan5_OKBtn")
                                                                                                                        {
                                                                                                                            HideClanWindow();                                                                                                                            
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            // End:0xF31
                                                                                                                            if(strID == "Clan7_OKBtn")
                                                                                                                            {
                                                                                                                                HideClanWindow();                                                                                                                                
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                // End:0xF53
                                                                                                                                if(strID == "ClanWar_OKBtn")
                                                                                                                                {
                                                                                                                                    HideClanWindow();                                                                                                                                    
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    // End:0xF77
                                                                                                                                    if(strID == "Clan5_ManageBtn")
                                                                                                                                    {
                                                                                                                                        EditAuthGrade();                                                                                                                                        
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        // End:0xF9C
                                                                                                                                        if(strID == "Clan5_ManageBtn2")
                                                                                                                                        {
                                                                                                                                            EditAuthGrade2();                                                                                                                                            
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            // End:0xFDD
                                                                                                                                            if(strID == "Clan6_ApplyBtn")
                                                                                                                                            {
                                                                                                                                                ApplyEditGrade();
                                                                                                                                                SetStateAndShow("ClanAuthManageWndState");                                                                                                                                                
                                                                                                                                            }
                                                                                                                                            else
                                                                                                                                            {
                                                                                                                                                // End:0x1019
                                                                                                                                                if(strID == "Clan6_CancelBtn")
                                                                                                                                                {
                                                                                                                                                    SetStateAndShow("ClanAuthManageWndState");                                                                                                                                                    
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                    // End:0x103F
                                                                                                                                                    if(strID == "ClanWarTabCtrl0")
                                                                                                                                                    {
                                                                                                                                                        RequestClanWarList(0, 0);                                                                                                                                                        
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                        // End:0x1069
                                                                                                                                                        if(strID == "ClanWarTabCtrl1")
                                                                                                                                                        {
                                                                                                                                                            RequestClanWarList(m_clanWarListPage, 1);                                                                                                                                                            
                                                                                                                                                        }
                                                                                                                                                        else
                                                                                                                                                        {
                                                                                                                                                            // End:0x1118
                                                                                                                                                            if(strID == "Clan1_ChangeNameAssignNobBtn")
                                                                                                                                                            {
                                                                                                                                                                RequestClanChangeNickName(script.m_myName, Class'NWindow.UIAPI_EDITBOX'.static.GetString(m_WindowName $ ".Clan1_ChangeNobNameTextEditbox"));
                                                                                                                                                                Class'NWindow.UIAPI_EDITBOX'.static.SetString(m_WindowName $ ".Clan1_ChangeNobNameTextEditbox", "");                                                                                                                                                                
                                                                                                                                                            }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                                // End:0x113D
                                                                                                                                                                if(strID == "Clan1_NobCancel1")
                                                                                                                                                                {
                                                                                                                                                                    HideClanWindow();                                                                                                                                                                    
                                                                                                                                                                }
                                                                                                                                                                else
                                                                                                                                                                {
                                                                                                                                                                    // End:0x117E
                                                                                                                                                                    if(strID == "Clan1_ChangeNameDeleteNobBtn")
                                                                                                                                                                    {
                                                                                                                                                                        RequestClanChangeNickName(script.m_myName, "");                                                                                                                                                                        
                                                                                                                                                                    }
                                                                                                                                                                    else
                                                                                                                                                                    {
                                                                                                                                                                        // End:0x1303
                                                                                                                                                                        if(Left(strID, 12) == "Clan3_OrgIco")
                                                                                                                                                                        {
                                                                                                                                                                            temp1 = int(Right(strID, 1));
                                                                                                                                                                            // End:0x11B8
                                                                                                                                                                            if(temp1 == 8)
                                                                                                                                                                            {
                                                                                                                                                                                return;
                                                                                                                                                                            }
                                                                                                                                                                            // End:0x1300
                                                                                                                                                                            if((temp1 > 0) && temp1 < (8 + 2))
                                                                                                                                                                            {
                                                                                                                                                                                // End:0x129A
                                                                                                                                                                                if((ClanClickedID < 0) || temp1 != ClanClickedID)
                                                                                                                                                                                {
                                                                                                                                                                                    Clan3_OrgHighLight[temp1 - 1].ShowWindow();
                                                                                                                                                                                    // End:0x1230
                                                                                                                                                                                    if(ClanClickedID != -1)
                                                                                                                                                                                    {
                                                                                                                                                                                        Clan3_OrgHighLight[ClanClickedID - 1].HideWindow();
                                                                                                                                                                                    }
                                                                                                                                                                                    nClanIdx = GetClanTypeFromIndex(temp1 - 1);
                                                                                                                                                                                    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear(m_WindowName $ ".ClanSkillWnd");
                                                                                                                                                                                    Class'NWindow.UIDATA_CLAN'.static.RequestClanSkillList();
                                                                                                                                                                                    Class'NWindow.UIDATA_CLAN'.static.RequestSubClanSkillList(nClanIdx);
                                                                                                                                                                                    ClanClickedID = temp1;                                                                                                                                                                                    
                                                                                                                                                                                }
                                                                                                                                                                                else
                                                                                                                                                                                {
                                                                                                                                                                                    // End:0x1300
                                                                                                                                                                                    if(temp1 == ClanClickedID)
                                                                                                                                                                                    {
                                                                                                                                                                                        Clan3_OrgHighLight[temp1 - 1].HideWindow();
                                                                                                                                                                                        Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear(m_WindowName $ ".ClanSkillWnd");
                                                                                                                                                                                        Class'NWindow.UIDATA_CLAN'.static.RequestClanSkillList();
                                                                                                                                                                                        ClanClickedID = -1;
                                                                                                                                                                                    }
                                                                                                                                                                                }
                                                                                                                                                                            }                                                                                                                                                                            
                                                                                                                                                                        }
                                                                                                                                                                        else
                                                                                                                                                                        {
                                                                                                                                                                            // End:0x1327
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
    local int i;
    local LVDataRecord Record;

    // End:0x24
    if(ListCtrlID == "Clan5_AuthListCtrl")
    {
        EditAuthGrade();
    }
    // End:0x49
    if(ListCtrlID == "Clan5_AuthListCtrl2")
    {
        EditAuthGrade2();
    }
    // End:0x128
    if(ListCtrlID == "Clan1_AssignApprenticeList")
    {
        i = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName $ ".Clan1_AssignApprenticeList");
        // End:0xF6
        if((i >= 0) && m_currentName != "")
        {
            m_hClanDrawerWndClan1_AssignApprenticeList.GetRec(i, Record);
            RequestClanAssignPupil(m_currentName, Record.LVDataList[0].szData);
        }
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".Clan1_AssignApprenticeWnd");
    }
    return;
}

function RecallCurrentMemberInfo()
{
    local ClanWnd script;

    script = ClanWnd(GetScript("ClanWnd"));
    RequestClanMemberInfo(script.G_CurrentRecord, script.G_CurrentSzData);
    SetStateAndShow("ClanMemberInfoState");
    return;
}

function OnClickCheckBox(string CheckBoxID)
{
    local string CheckboxNum, CheckboxName;
    local bool CheckedStat;
    local int i;

    CheckboxName = Left(CheckBoxID, 12);
    // End:0x20B
    if(CheckboxName == "Clan6_Check1")
    {
        CheckboxNum = Right(CheckBoxID, 2);
        // End:0x1A7
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
                    // End:0x1A4
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
                    // End:0x1A4
                    break;
                // End:0xFFFF
                default:
                    // End:0x1A4
                    break;
                    break;
            }            
        }
        else
        {
            // End:0x1E3
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
    // End:0x38B
    if(CheckboxName == "Clan6_Check2")
    {
        CheckboxNum = Right(CheckBoxID, 2);
        // End:0x327
        if(CheckboxNum == "00")
        {
            CheckedStat = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(m_WindowName $ ".Clan6_Check200");
            switch(CheckedStat)
            {
                // End:0x2CA
                case true:
                    i = 0;
                    J0x281:

                    // End:0x2C7 [Loop If]
                    if(i <= 5)
                    {
                        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check20") $ string(i), true);
                        ++i;
                        // [Loop Continue]
                        goto J0x281;
                    }
                    // End:0x324
                    break;
                // End:0x31E
                case false:
                    i = 0;
                    J0x2D5:

                    // End:0x31B [Loop If]
                    if(i <= 5)
                    {
                        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check20") $ string(i), false);
                        ++i;
                        // [Loop Continue]
                        goto J0x2D5;
                    }
                    // End:0x324
                    break;
                // End:0xFFFF
                default:
                    // End:0x324
                    break;
                    break;
            }            
        }
        else
        {
            // End:0x363
            if((count_all_check("2", 8)) == true)
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check200", true);                
            }
            else
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan6_Check200", false);
            }
        }
    }
    // End:0x50B
    if(CheckboxName == "Clan6_Check3")
    {
        CheckboxNum = Right(CheckBoxID, 2);
        // End:0x4A7
        if(CheckboxNum == "00")
        {
            CheckedStat = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(m_WindowName $ ".Clan6_Check300");
            switch(CheckedStat)
            {
                // End:0x44A
                case true:
                    i = 0;
                    J0x401:

                    // End:0x447 [Loop If]
                    if(i <= 9)
                    {
                        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check30") $ string(i), true);
                        ++i;
                        // [Loop Continue]
                        goto J0x401;
                    }
                    // End:0x4A4
                    break;
                // End:0x49E
                case false:
                    i = 0;
                    J0x455:

                    // End:0x49B [Loop If]
                    if(i <= 9)
                    {
                        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan6_Check30") $ string(i), false);
                        ++i;
                        // [Loop Continue]
                        goto J0x455;
                    }
                    // End:0x4A4
                    break;
                // End:0xFFFF
                default:
                    // End:0x4A4
                    break;
                    break;
            }            
        }
        else
        {
            // End:0x4E3
            if((count_all_check("3", 9)) == true)
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
            // End:0x12A
            break;
        // End:0x48
        case 460:
            HandleClanWarList(a_Param);
            // End:0x12A
            break;
        // End:0x5B
        case 360:
            HandleCrestChange(a_Param);
        // End:0x71
        case 430:
            HandleClanMemberInfo(a_Param);
            // End:0x12A
            break;
        // End:0x87
        case 490:
            HandleSkillList(a_Param);
            // End:0x12A
            break;
        // End:0x9D
        case 500:
            HandleSkillList(a_Param);
            // End:0x12A
            break;
        // End:0xB3
        case 370:
            HandleClanAuth(a_Param);
            // End:0x12A
            break;
        // End:0xC9
        case 380:
            HandleClanAuthMember(a_Param);
            // End:0x12A
            break;
        // End:0xEF
        case 160:
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ClanDrawerWnd");
            // End:0x12A
            break;
        // End:0x105
        case 470:
            HandleClearWarList(a_Param);
            // End:0x12A
            break;
        // End:0x116
        case 1710:
            HandleDialogOK();
            // End:0x12A
            break;
        // End:0x121
        case 1720:
            // End:0x12A
            break;
        // End:0xFFFF
        default:
            // End:0x12A
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x12A
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x12A
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x12A
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
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName $ ".Clan5_AuthListCtrl2");
    ParseInt(a_Param, "Count", Count);
    i = 0;
    J0x83:

    // End:0x174 [Loop If]
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
        goto J0x83;
    }
    i = 5;
    J0x17C:

    // End:0x26E [Loop If]
    if(i < 9)
    {
        ParseInt(a_Param, "GradeID" $ string(i), Id);
        ParseInt(a_Param, "GradeMemberCount" $ string(i), members);
        Data.szData = GetStringByGradeID(Id);
        Record.LVDataList[0] = Data;
        Data.szData = string(members);
        Record.LVDataList[1] = Data;
        Record.nReserved1 = (Id);
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName $ ".Clan5_AuthListCtrl2", Record);
        ++i;
        // [Loop Continue]
        goto J0x17C;
    }
    Class'NWindow.UIAPI_LISTCTRL'.static.SetSelectedIndex(m_WindowName $ ".Clan5_AuthListCtrl", 0, true);
    Class'NWindow.UIAPI_LISTCTRL'.static.SetSelectedIndex(m_WindowName $ ".Clan5_AuthListCtrl2", 0, true);
    return;
}

function HandleClanWarList(string a_Param)
{
    local LVDataRecord Record;
    local int page;
    local string sClanName;
    local int State, progressTimeInSec;
    local Color colorValue;
    local int totalWarSec, point, pointDiff, leftKillCountOfEnemyToWar, KillCountOfEnemyToWar;

    ParseInt(a_Param, "Page", page);
    ParseString(a_Param, "ClanName", sClanName);
    ParseInt(a_Param, "State", State);
    ParseInt(a_Param, "ProgressTimeInSec", progressTimeInSec);
    ParseInt(a_Param, "Point", point);
    ParseInt(a_Param, "PointDiff", pointDiff);
    ParseInt(a_Param, "LeftKillCountOfEnemyToWar", leftKillCountOfEnemyToWar);
    KillCountOfEnemyToWar = SettingSectorInt("CLAN", "WAR_START_ENEMY_COUNT");
    totalWarSec = SettingSectorInt("CLAN", "WAR_MAXIMUM_TIME");
    // End:0x133
    if(totalWarSec <= 0)
    {
        totalWarSec = ((60 * 60) * 24) * 7;
    }
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
    Record.LVDataList[2].szTexture = getWarSituationTextureNew(State);
    Record.LVDataList[2].nTextureWidth = 11;
    Record.LVDataList[2].nTextureHeight = 11;
    Record.LVDataList[3].bUseTextColor = true;
    Record.LVDataList[3].szData = string(point);
    Record.LVDataList[3].TextColor = colorValue;
    Record.LVDataList[3].nReserved1 = point;
    Record.LVDataList[3].textAlignment = 2;
    Record.LVDataList[4].nReserved1 = pointDiff;
    Record.LVDataList[5].nReserved1 = leftKillCountOfEnemyToWar;
    Record.LVDataList[5].nReserved2 = KillCountOfEnemyToWar;
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
            // End:0xBA
            break;
        // End:0x54
        case 1:
            returnStr = returnStr $ GetSystemString(2354);
            // End:0xBA
            break;
        // End:0x74
        case 2:
            returnStr = returnStr $ GetSystemString(2353);
            // End:0xBA
            break;
        // End:0x94
        case 3:
            returnStr = returnStr $ GetSystemString(2352);
            // End:0xBA
            break;
        // End:0xB4
        case 4:
            returnStr = returnStr $ GetSystemString(2351);
            // End:0xBA
            break;
        // End:0xFFFF
        default:
            // End:0xBA
            break;
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
            // End:0xFC
            break;
        // End:0x69
        case 1:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow4";
            // End:0xFC
            break;
        // End:0x98
        case 2:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow3";
            // End:0xFC
            break;
        // End:0xC7
        case 3:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow2";
            // End:0xFC
            break;
        // End:0xF6
        case 4:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow1";
            // End:0xFC
            break;
        // End:0xFFFF
        default:
            // End:0xFC
            break;
            break;
    }
    return returnStr;
    return;
}

function string getWarSituationTextureNew(int State)
{
    local string returnStr;

    switch(State)
    {
        // End:0x35
        case 0:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow3";
            // End:0x98
            break;
        // End:0x63
        case 1:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow4";
            // End:0x98
            break;
        // End:0x92
        case 2:
            returnStr = "L2ui_ct1.clan_DF_warlist_arrow2";
            // End:0x98
            break;
        // End:0xFFFF
        default:
            // End:0x98
            break;
            break;
    }
    return returnStr;
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
    local string organization, masterName;
    local ClanWnd script;
    local string organizationtext;

    script = ClanWnd(GetScript("ClanWnd"));
    ParseInt(a_Param, "ClanType", m_clanType);
    ParseString(a_Param, "Name", m_currentName);
    ParseString(a_Param, "NickName", nickname);
    ParseInt(a_Param, "GradeID", gradeID);
    ParseString(a_Param, "OrderName", organization);
    ParseString(a_Param, "MasterName", masterName);
    currentMasterName = masterName;
    // End:0xD9
    if(masterName == "")
    {
        masterName = GetSystemString(27);
    }
    organizationtext = ((getClanOrderString(m_clanType)) @ "-") @ organization;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedMemberName", m_currentName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedMemberSName", nickname);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedMemberGrade", GetStringByGradeID(gradeID));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedMemberOrderName", organizationtext);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedApprentice", masterName);
    // End:0x2A4
    if(script.m_CurrentclanMasterReal == m_currentName)
    {
        // End:0x2A4
        if(script.m_currentShowIndex == 0)
        {
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedMemberGrade", GetSystemString(342));
        }
    }
    // End:0x362
    if(m_clanType == -1)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedApprenticeTitle", GetSystemString(1332));        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
        // End:0x439
        if(currentMasterName != "")
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
        }
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_CurrentSelectedApprenticeTitle", GetSystemString(1431));
    }
    script.resetBtnShowHide();
    CheckandCompareMyNameandDisableThings();
    return;
}

function CheckandCompareMyNameandDisableThings()
{
    local ClanWnd script;
    local UserInfo UserInfo;

    GetPlayerInfo(UserInfo);
    m_myName = UserInfo.Name;
    script = ClanWnd(GetScript("ClanWnd"));
    // End:0x1C9
    if(script.m_bClanMaster > 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeMemberKHOpen");
        // End:0x162
        if(currentMasterName != "")
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
            // End:0x15F
            if(script.G_CurrentAlias == true)
            {
                Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
            }            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
        }        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberKHOpen");
        Proc_AuthValidation();
        // End:0x39A
        if(script.GetClanTypeFromIndex(script.m_currentShowIndex) < script.m_myClanType)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
            // End:0x368
            if(m_clanType == -1)
            {                
            }
            else
            {
                Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
            }
        }
        // End:0x4FB
        if(script.m_myClanType > 1)
        {
            // End:0x4FB
            if(script.GetClanTypeFromIndex(script.m_currentShowIndex) != 0)
            {
                // End:0x40A
                if((script.m_myClanType - script.GetClanTypeFromIndex(script.m_currentShowIndex)) == 1)
                {
                    Proc_AuthValidation();
                }
                // End:0x447
                if((script.m_myClanType - script.GetClanTypeFromIndex(script.m_currentShowIndex)) == 1000)
                {
                    Proc_AuthValidation();
                }
                // End:0x481
                if((script.m_myClanType - script.GetClanTypeFromIndex(script.m_currentShowIndex)) == 100)
                {
                    Proc_AuthValidation();
                }
                // End:0x4BE
                if((script.m_myClanType - script.GetClanTypeFromIndex(script.m_currentShowIndex)) == 999)
                {
                    Proc_AuthValidation();
                }
                // End:0x4FB
                if((script.m_myClanType - script.GetClanTypeFromIndex(script.m_currentShowIndex)) == 1001)
                {
                    Proc_AuthValidation();
                }
            }
        }
        // End:0x638
        if(script.G_CurrentAlias == true)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberKHOpen");
        }
        // End:0x778
        if(script.m_CurrentclanMasterReal == m_currentName)
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberNameBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberKHOpen");
        }
    }
    // End:0x819
    if(m_currentName == m_myName)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeBanishBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberKHOpen");
    }
    // End:0x8BF
    if(m_clanType == -1)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
    }
    return;
}

function Proc_AuthValidation()
{
    local ClanWnd script;

    script = ClanWnd(GetScript("ClanWnd"));
    // End:0xC3
    if(script.m_bNickName == 0)
    {
        // End:0x8E
        if((script.G_IamHero == true) || script.G_IamNobless > 0)
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
    // End:0x13F
    if(script.m_bGrade == 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_ChangeMemberGradeBtn");
    }
    // End:0x1ED
    if(script.m_bManageMaster == 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");        
    }
    else
    {
        // End:0x260
        if(currentMasterName != "")
        {
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.EnableWindow(m_WindowName $ ".Clan1_AssignApprenticeBtn");
            Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_DeleteApprenticeBtn");
        }
    }
    // End:0x309
    if(script.m_bOustMember == 0)
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
    local ClanWnd script;

    // End:0x79
    if(m_state == "ClanEmblemManageWndState")
    {
        script = ClanWnd(GetScript("ClanWnd"));
        Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTextureWithClanCrest(m_WindowName $ ".ClanCrestTextureCtrl", script.m_clanID);
    }
    return;
}

function HandleSkillList(string a_Param)
{
    local int Count, i, Level, findItemID;
    local string AgitText;
    local ItemID cID;

    ParseInt(a_Param, "Count", Count);
    i = 0;
    J0x1E:

    // End:0xDD [Loop If]
    if(i < Count)
    {
        ParseItemIDWithIndex(a_Param, cID, i);
        ParseInt(a_Param, "SkillLevel_" $ string(i), Level);
        findItemID = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".ClanSkillWnd", cID);
        AgitText = Class'NWindow.UIAPI_TEXTBOX'.static.GetText("ClanWnd.ClanAgitText");
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
    local ClanWnd script;
    local int gradeID;
    local string sName;
    local array<int> powers;
    local int i, Index;

    script = ClanWnd(GetScript("ClanWnd"));
    ParseInt(a_Param, "Grade", gradeID);
    ParseString(a_Param, "Name", sName);
    powers.Length = 32;
    i = 0;
    J0x57:

    // End:0x98 [Loop If]
    if(i < 32)
    {
        ParseInt(a_Param, "PowerValue" $ string(i), powers[i]);
        ++i;
        // [Loop Continue]
        goto J0x57;
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan2_CurrentSelectedMemberName", (sName @ "-") @ (GetStringByGradeID(gradeID)));
    Index = 1;
    i = 1;
    J0xF5:

    // End:0x195 [Loop If]
    if(i <= 10)
    {
        // End:0x14E
        if(i < 10)
        {
            Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check10") $ string(i), bool(powers[Index++]));
            // [Explicit Continue]
            goto J0x18B;
        }
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check1") $ string(i), bool(powers[Index++]));
        J0x18B:

        ++i;
        // [Loop Continue]
        goto J0xF5;
    }
    i = 1;
    J0x19C:

    // End:0x1F0 [Loop If]
    if(i <= 5)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check20") $ string(i), bool(powers[Index++]));
        ++i;
        // [Loop Continue]
        goto J0x19C;
    }
    i = 1;
    J0x1F7:

    // End:0x24B [Loop If]
    if(i <= 8)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check30") $ string(i), bool(powers[Index++]));
        ++i;
        // [Loop Continue]
        goto J0x1F7;
    }
    // End:0x287
    if((count_all_check2("1", 10)) == true)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check100", true);        
    }
    else
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check100", false);
    }
    // End:0x2EB
    if((count_all_check2("2", 5)) == true)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check200", true);        
    }
    else
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check200", false);
    }
    // End:0x34F
    if((count_all_check2("3", 8)) == true)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check300", true);        
    }
    else
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck(m_WindowName $ ".Clan2_Check300", false);
    }
    // End:0x48E
    if(script.m_myName == sName)
    {
        // End:0x3CF
        if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(m_WindowName $ ".Clan2_Check101") == true)
        {
            script.m_bJoin = 1;            
        }
        else
        {
            script.m_bJoin = 0;
        }
        // End:0x41F
        if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(m_WindowName $ ".Clan2_Check107") == true)
        {
            script.m_bCrest = 1;            
        }
        else
        {
            script.m_bCrest = 0;
        }
        // End:0x46F
        if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked(m_WindowName $ ".Clan2_Check105") == true)
        {
            script.m_bWar = 1;            
        }
        else
        {
            script.m_bWar = 0;
        }
        script.resetBtnShowHide();
    }
    // End:0x61A
    if(script.m_CurrentclanMasterReal == sName)
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan2_CurrentSelectedMemberName", (sName @ "-") @ GetSystemString(342));
        i = 0;
        J0x4FC:

        // End:0x580 [Loop If]
        if(i <= 10)
        {
            // End:0x547
            if(i < 10)
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check10") $ string(i), true);
                // [Explicit Continue]
                goto J0x576;
            }
            Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check1") $ string(i), true);
            J0x576:

            ++i;
            // [Loop Continue]
            goto J0x4FC;
        }
        i = 0;
        J0x587:

        // End:0x5CD [Loop If]
        if(i <= 5)
        {
            Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check20") $ string(i), true);
            ++i;
            // [Loop Continue]
            goto J0x587;
        }
        i = 0;
        J0x5D4:

        // End:0x61A [Loop If]
        if(i <= 8)
        {
            Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck((m_WindowName $ ".Clan2_Check30") $ string(i), true);
            ++i;
            // [Loop Continue]
            goto J0x5D4;
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

function InitializeAcademyList()
{
    local ClanWnd script;
    local int i;
    local LVDataRecord Record;

    Record.LVDataList.Length = 3;
    script = ClanWnd(GetScript("ClanWnd"));
    InitializeClan1_AssignApprenticeList();
    i = 0;
    J0x35:

    // End:0x26D [Loop If]
    if(i < script.m_memberList[script.GetIndexFromType(-1)].m_array.Length)
    {
        // End:0x263
        if(script.m_memberList[script.GetIndexFromType(-1)].m_array[i].bHaveMaster == 0)
        {
            Record.LVDataList[0].szData = script.m_memberList[script.GetIndexFromType(-1)].m_array[i].sName;
            Record.LVDataList[1].szData = string(script.m_memberList[script.GetIndexFromType(-1)].m_array[i].Level);
            Record.nReserved1 = (script.m_memberList[script.GetIndexFromType(-1)].m_array[i].clanType);
            Record.LVDataList[2].szData = string(script.m_memberList[script.GetIndexFromType(-1)].m_array[i].ClassID);
            Record.LVDataList[2].szTexture = GetClassRoleIconName(script.m_memberList[script.GetIndexFromType(-1)].m_array[i].ClassID);
            Record.LVDataList[2].nTextureWidth = 11;
            Record.LVDataList[2].nTextureHeight = 11;
            Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName $ ".Clan1_AssignApprenticeList", Record);
        }
        ++i;
        // [Loop Continue]
        goto J0x35;
    }
    return;
}

function InitializeClan1_AssignApprenticeList()
{
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName $ ".Clan1_AssignApprenticeList");
    return;
}

function InitializeClanInfoWnd()
{
    local Color Blue, Red, DarkYellow;
    local ClanWnd script;
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
    script = ClanWnd(GetScript("ClanWnd"));
    script2 = SkillTrainClanTreeWnd(GetScript("SkillTrainClanTreeWnd"));
    ClanNameVal = string(script.m_clanNameValue) @ GetSystemString(1442);
    // End:0x11A
    if((ClanClickedID > 0) && Clan3_OrgHighLight[ClanClickedID - 1].IsShowWindow())
    {
        Clan3_OrgHighLight[ClanClickedID - 1].HideWindow();
    }
    ClanClickedID = -1;
    reset_clan_org();
    // End:0x153
    if(script.m_clanRank == 0)
    {
        ClanRankStr = GetSystemString(1374);        
    }
    else
    {
        // End:0x18E
        if(script.m_clanRank <= 100)
        {
            ClanRankStr = GetSystemString(1375) @ string(script.m_clanRank);            
        }
        else
        {
            ClanRankStr = GetSystemString(1374);
        }
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan3_ClanName", script.m_clanName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan3_ClanPoint", ClanNameVal);
    // End:0x245
    if(script.m_clanNameValue == 0)
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName $ ".Clan3_ClanPoint", DarkYellow);        
    }
    else
    {
        // End:0x289
        if(script.m_clanNameValue < 0)
        {
            Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName $ ".Clan3_ClanPoint", Red);            
        }
        else
        {
            // End:0x2CA
            if(script.m_clanNameValue > 0)
            {
                Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(m_WindowName $ ".Clan3_ClanPoint", Blue);
            }
        }
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan3_ClanRanking", ClanRankStr);
    i = 0;
    J0x300:

    // End:0x57E [Loop If]
    if(i < 8)
    {
        // End:0x574
        if(script.m_memberList[i].m_sName != "")
        {
            clanType = script.GetClanTypeFromIndex(i);
            // End:0x3A5
            if(clanType == 0)
            {
                ToolTip = (((script.m_memberList[i].m_sName $ "\\n") $ GetSystemString(342)) $ " : ") $ script.m_memberList[i].m_sMasterName;
            }
            // End:0x3D3
            if(clanType == -1)
            {
                ToolTip = script.m_memberList[i].m_sName;
            }
            // End:0x441
            if((clanType == 100) || clanType == 200)
            {
                ToolTip = (((script.m_memberList[i].m_sName $ "\\n") $ GetSystemString(1438)) $ " : ") $ script.m_memberList[i].m_sMasterName;
            }
            // End:0x4D7
            if((((clanType == 1001) || clanType == 1002) || clanType == 2001) || clanType == 2002)
            {
                ToolTip = (((script.m_memberList[i].m_sName $ "\\n") $ GetSystemString(1433)) $ " : ") $ script.m_memberList[i].m_sMasterName;
            }
            // End:0x574
            if(ToolTip != "")
            {
                Clan3_OrgIcon[i].ShowWindow();
                Clan3_OrgIcon[i].EnableWindow();
                Clan3_OrgIcon[i].SetTooltipCustomType(SetTooltip(ToolTip));
                script2.Clan_OrgIcon[i].ShowWindow();
                script2.Clan_OrgIcon[i].SetTooltipCustomType(SetTooltip(ToolTip));
            }
        }
        ++i;
        // [Loop Continue]
        goto J0x300;
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
    local ClanWnd script;
    local int i;

    script = ClanWnd(GetScript("ClanWnd"));
    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(m_WindowName $ ".Clan1_targetknighthoodcombobox");
    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(m_WindowName $ ".Clan1_targetknighthoodmember");
    Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".Clan1_targetknighthoodcombobox", GetSystemString(1465), 0);
    Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".Clan1_targetknighthoodmember", GetSystemString(1466), 0);
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_targetknighthoodmember");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow(m_WindowName $ ".Clan1_ChangeMemberKnightHoodBtn");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_ChangeMemberKnightHoodTXT1", MakeFullSystemMsg(GetSystemMessage(1906), m_currentName, ""));
    i = 0;
    J0x1CF:

    // End:0x283 [Loop If]
    if(i < int(script.8))
    {
        // End:0x279
        if(script.m_memberList[i].m_sName != "")
        {
            // End:0x279
            if(script.GetClanTypeFromIndex(i) != -1)
            {
                Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".Clan1_targetknighthoodcombobox", script.m_memberList[i].m_sName, i);
            }
        }
        ++i;
        // [Loop Continue]
        goto J0x1CF;
    }
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".Clan1_targetknighthoodcombobox", 0);
    return;
}

function swapTargetSelect(int clanNo)
{
    local ClanWnd script;
    local int i;

    script = ClanWnd(GetScript("ClanWnd"));
    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(m_WindowName $ ".Clan1_targetknighthoodmember");
    Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".Clan1_targetknighthoodmember", GetSystemString(1466), 0);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".Clan1_ChangeMemberKnightHoodTXT1", MakeFullSystemMsg(GetSystemMessage(1907), m_currentName, ""));
    i = 0;
    J0xE8:

    // End:0x1CA [Loop If]
    if(i <= script.m_memberList[clanNo].m_array.Length)
    {
        // End:0x1C0
        if(script.m_memberList[clanNo].m_array[i].sName != script.m_CurrentclanMasterReal)
        {
            Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName $ ".Clan1_targetknighthoodmember", script.m_memberList[clanNo].m_array[i].sName, script.m_memberList[clanNo].m_array[i].clanType);
        }
        ++i;
        // [Loop Continue]
        goto J0xE8;
    }
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName $ ".Clan1_targetknighthoodmember", 0);
    return;
}

function proc_swapmember()
{
    local int currentindexnew1, currentindexnew2;
    local string currentstring1, currentstring2;
    local int Type, clantype1;
    local ClanWnd script;

    script = ClanWnd(GetScript("ClanWnd"));
    currentindexnew1 = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".Clan1_targetknighthoodcombobox");
    currentstring1 = Class'NWindow.UIAPI_COMBOBOX'.static.GetString(m_WindowName $ ".Clan1_targetknighthoodcombobox", currentindexnew1);
    clantype1 = script.GetClanTypeFromIndex(Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(m_WindowName $ ".Clan1_targetknighthoodcombobox", currentindexnew1));
    currentindexnew2 = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName $ ".Clan1_targetknighthoodmember");
    currentstring2 = Class'NWindow.UIAPI_COMBOBOX'.static.GetString(m_WindowName $ ".Clan1_targetknighthoodmember", currentindexnew2);
    // End:0x17A
    if(currentindexnew2 == 0)
    {
        Type = 0;        
    }
    else
    {
        Type = 1;
    }
    // End:0x1A5
    if(Type == 1)
    {
        RequestClanReorganizeMember(1, m_currentName, clantype1, currentstring2);        
    }
    else
    {
        // End:0x1C3
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
    local ClanWnd script;

    script = ClanWnd(GetScript("ClanWnd"));
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ClanDrawerWnd");
    script.ResetOpeningVariables();
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

function EditAuthGrade2()
{
    local int Index;
    local LVDataRecord Record;

    Index = m_hClanDrawerWndClan5_AuthListCtrl2.GetSelectedIndex();
    // End:0x7C
    if(Index >= 0)
    {
        m_hClanDrawerWndClan5_AuthListCtrl2.GetRec(Index, Record);
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

function reset_clan_org()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x64 [Loop If]
    if(i < 8)
    {
        Clan3_OrgIcon[i].HideWindow();
        Clan3_OrgIcon[i].DisableWindow();
        Clan3_OrgIcon[i].SetTooltipCustomType(SetTooltip(""));
        ++i;
        // [Loop Continue]
        goto J0x07;
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
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check108", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check109", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check110", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check200", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check203", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check204", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check205", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check300", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check303", true);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check302", true);
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
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check108", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check109", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check110", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check200", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check203", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check204", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check205", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check300", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check303", false);
    Class'NWindow.UIAPI_CHECKBOX'.static.SetDisable(m_WindowName $ ".Clan6_Check302", false);
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
            // End:0x9B
            break;
        // End:0x26
        case 100:
            GradeNum = 7;
            // End:0x9B
            break;
        // End:0x36
        case 200:
            GradeNum = 7;
            // End:0x9B
            break;
        // End:0x49
        case 1001:
            GradeNum = 8;
            // End:0x9B
            break;
        // End:0x5C
        case 1002:
            GradeNum = 8;
            // End:0x9B
            break;
        // End:0x6F
        case 2001:
            GradeNum = 8;
            // End:0x9B
            break;
        // End:0x82
        case 2002:
            GradeNum = 8;
            // End:0x9B
            break;
        // End:0x95
        case -1:
            GradeNum = 9;
            // End:0x9B
            break;
        // End:0xFFFF
        default:
            // End:0x9B
            break;
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
    m_WindowName="ClanDrawerWnd"
    m_ClanPledgeBonusDrawerWndName="ClanPledgeBonusDrawerWnd"
}