class ClanSearchWnd extends ClanSearchAPI;

var WindowHandle Me;
var WindowHandle SortListContainer;
var WindowHandle SortAcademyListContainer;
var WindowHandle FilterContainer;
var ComboBoxHandle ClanLevelCBox;
var ComboBoxHandle ClanFriendshipTypeCBox;
var ComboBoxHandle SearchTypeCBox;
var EditBoxHandle SearchEBox;
var ButtonHandle SearchBtn;
var WindowHandle ClanListContainer;
var WindowHandle ListDisableContainer;
var ListCtrlHandle ClanList;
var ListCtrlHandle AcademyList;
var WindowHandle ClanListDetailContainer;
var TabHandle ClanListDetailTab;
var TextBoxHandle ClanListDetailNameTxt;
var TextBoxHandle ClanListDetailLeaderTxt;
var TextBoxHandle InviteYourClanNotifyTxt;
var TextBoxHandle ClanListDetailLvTxt;
var TextBoxHandle ClanListDetailNumTxt;
var TextureHandle ClanDetailClanCrestTx;
var TextureHandle ClanDetailAllyCrestTx;
var TextBoxHandle FriendshipDetailTypeHeadTxt;
var TextBoxHandle ClanListFriendshipDetailTypeTxt;
var TextBoxHandle ClanListInviteDetailTypeTxt;
var TextBoxHandle ClanListDetailRankTxt;
var TextBoxHandle ClanListDetailReputationTxt;
var TextBoxHandle ClanListDetailAvgLevelTxt;
var TextBoxHandle ClanListDetailPVPTxt;
var TextBoxHandle ClanListDetailPKTxt;
var TextBoxHandle ClanListDetailHeroesTxt;
var TextBoxHandle ClanListDetailNobleTxt;
var TextBoxHandle TGTxt;
var TextBoxHandle DSTxt;
var WindowHandle MEditLockWnd;
var MultiEditBoxHandle ClanInfoMEdit;
var ButtonHandle RequestJoinBtn;
var WindowHandle ClanInfoDetailLockWnd;
var WindowHandle ClanListDetailSkillWnd;
var ItemWindowHandle ClanSkillList;
var ListCtrlHandle WarClanList;
var ListCtrlHandle SelectedClanList;
var WindowHandle ClanListMyClanContainer;
var WindowHandle ClanSearchRequestorDrawerWnd;
var TextureHandle MyAllyCrestTx;
var TextureHandle MyClanCrestTx;
var TextBoxHandle MyClanNameTxt;
var TextBoxHandle MyAllyNameTxt;
var TextBoxHandle MyBaseNameTxt;
var TextBoxHandle MyHallNameTxt;
var TextureHandle MyClanLvTx;
var TextBoxHandle MyClanNumTxt;
var ComboBoxHandle MyClanKnighthoodCBox;
var TextBoxHandle MyFriendshipTypeTxt;
var TextBoxHandle MyRequestTypeTxt;
var TextureHandle MyClanInfoHlBg;
var MultiEditBoxHandle MyClanInfoMEdit;
var WindowHandle RequestMEditLockWnd;
var ListBoxHandle RequestorClanInfoLEdit;
var ListCtrlHandle InviteRequestList;
var ListCtrlHandle InviteRequestAcademyList;
var ButtonHandle MyClanPenaltyBtn;
var ButtonHandle MyInviteAddBtn;
var ButtonHandle MyInviteCancelBtn;
var EditBoxHandle TelegramEBox;
var EditBoxHandle DiscordEBox;
var EditBoxHandle AcademyPriceEBox;
var ButtonHandle MyClanAddClanBtn;
var ButtonHandle MyClanResetChangesBtn;
var WindowHandle PaginationContainer;
var WindowHandle PagiDisabledWnd;
var Paginator ClanListPaginator;
var Paginator DetailClanListPaginator;
var Paginator DetailClanWarListPaginator;
var ButtonHandle ClanTypeLeftBtn;
var ButtonHandle ClanTypeRightBtn;
var TextBoxHandle ClanTypeNameTxt;
var TextureHandle MyClanClanInviteTypeIcoTx;
var ButtonHandle InviteTypeLeftBtn;
var ButtonHandle InviteTypeRightBtn;
var TextBoxHandle InviteTypeNameTxt;
var ButtonHandle KnighthoodLeftBtn;
var ButtonHandle KnighthoodRightBtn;
var TextBoxHandle KnighthoodNameTxt;
var WindowHandle HeadTab00;
var WindowHandle HeadTab01;
var WindowHandle HeadTab02;
var ButtonHandle HeadTab00Btn;
var ButtonHandle HeadTab01Btn;
var ButtonHandle HeadTab02Btn;
var TextBoxHandle HeadTab00Txt;
var TextBoxHandle HeadTab01Txt;
var TextBoxHandle HeadTab02Txt;
var TextureHandle HeadTab00Tx;
var TextureHandle HeadTab01Tx;
var TextureHandle HeadTab02Tx;
var sClanListData targetListClanData;
var sAcademyListData targetListAcademyData;
var int currentSort[7];
var int currentSortType;
var int currentAcademySort[7];
var int currentAcademySortType;
var int currentSelectedTab;
var int currMyFriendshipType;
var int currMyInviteType;
var int currMyKnighthoodType;
var array<int> AvailableKnighthoodIDs;
var int currKnighthoodIndex;
var array<sRequestor> requestorsList;

function OnLoad()
{
    SortListContainer = GetWindowHandle("ClanSearchWnd.ClanListContainer.SortListContainer");
    SortAcademyListContainer = GetWindowHandle("ClanSearchWnd.ClanListContainer.SortAcademyListContainer");
    ClanListDetailNameTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailNameTxt");
    HeadTab00 = GetWindowHandle("ClanSearchWnd.HeadTab00Wnd");
    HeadTab01 = GetWindowHandle("ClanSearchWnd.HeadTab01Wnd");
    HeadTab02 = GetWindowHandle("ClanSearchWnd.HeadTab02Wnd");
    HeadTab00Btn = GetButtonHandle("ClanSearchWnd.HeadTab00Wnd.HeadTab00");
    HeadTab01Btn = GetButtonHandle("ClanSearchWnd.HeadTab01Wnd.HeadTab01");
    HeadTab02Btn = GetButtonHandle("ClanSearchWnd.HeadTab02Wnd.HeadTab02");
    HeadTab00Txt = GetTextBoxHandle("ClanSearchWnd.HeadTab01Wnd.HeadTab00Txt");
    HeadTab01Txt = GetTextBoxHandle("ClanSearchWnd.HeadTab01Wnd.HeadTab01Txt");
    HeadTab02Txt = GetTextBoxHandle("ClanSearchWnd.HeadTab02Wnd.HeadTab02Txt");
    HeadTab00Tx = GetTextureHandle("ClanSearchWnd.HeadTab01Wnd.HeadTab00Tx");
    HeadTab01Tx = GetTextureHandle("ClanSearchWnd.HeadTab01Wnd.HeadTab01Tx");
    HeadTab02Tx = GetTextureHandle("ClanSearchWnd.HeadTab02Wnd.HeadTab02Tx");
    Me = GetWindowHandle("ClanSearchWnd");
    FilterContainer = GetWindowHandle("ClanSearchWnd.ClanListContainer.FilterContainer");
    ClanLevelCBox = GetComboBoxHandle("ClanSearchWnd.ClanListContainer.FilterContainer.ClanLevelCBox");
    ClanFriendshipTypeCBox = GetComboBoxHandle("ClanSearchWnd.ClanListContainer.FilterContainer.ClanFriendshipTypeCBox");
    SearchTypeCBox = GetComboBoxHandle("ClanSearchWnd.ClanListContainer.FilterContainer.SearchTypeCBox");
    SearchEBox = GetEditBoxHandle("ClanSearchWnd.ClanListContainer.FilterContainer.SearchEBox");
    SearchBtn = GetButtonHandle("ClanSearchWnd.ClanListContainer.FilterContainer.SearchBtn");
    ClanListContainer = GetWindowHandle("ClanSearchWnd.ClanListContainer");
    ListDisableContainer = GetWindowHandle("ClanSearchWnd.ClanListContainer.ListDisableContainer");
    ClanList = GetListCtrlHandle("ClanSearchWnd.ClanListContainer.ClanList");
    AcademyList = GetListCtrlHandle("ClanSearchWnd.ClanListContainer.AcademyList");
    ClanListDetailContainer = GetWindowHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer");
    ClanListDetailTab = GetTabHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListDetailTab");
    ClanListDetailNameTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailNameTxt");
    ClanListDetailLeaderTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailLeaderTxt");
    InviteYourClanNotifyTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.InviteYourClanNotifyTxt");
    ClanListDetailLvTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailLvTxt");
    ClanListDetailNumTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailNumTxt");
    ClanDetailClanCrestTx = GetTextureHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanDetailClanNumTx");
    ClanDetailAllyCrestTx = GetTextureHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanDetailAllyCrestTx");
    FriendshipDetailTypeHeadTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.FriendshipDetailTypeHeadTxt");
    ClanListFriendshipDetailTypeTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListFriendshipDetailTypeTxt");
    ClanListInviteDetailTypeTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListInviteDetailTypeTxt");
    ClanListDetailRankTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailRankTxt");
    ClanListDetailReputationTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailReputationTxt");
    ClanListDetailAvgLevelTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailAvgLevelTxt");
    ClanListDetailPVPTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailPVPTxt");
    ClanListDetailPKTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailPKTxt");
    ClanListDetailNobleTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailNobleTxt");
    ClanListDetailHeroesTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailHeroesTxt");
    ClanInfoMEdit = GetMultiEditBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanInfoMEdit");
    TGTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.TGTxt");
    DSTxt = GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.DSTxt");
    MEditLockWnd = GetWindowHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.MEditLockWnd");
    RequestJoinBtn = GetButtonHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.RequestJoinBtn");
    ClanInfoDetailLockWnd = GetWindowHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanInfoDetailLockWnd");
    ClanListDetailSkillWnd = GetWindowHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailSkillWnd");
    ClanSkillList = GetItemWindowHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanInfoDetailContainer.ClanListDetailSkillWnd.ClanSkillList");
    SelectedClanList = GetListCtrlHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListWarContainer.SelectedClanList");
    WarClanList = GetListCtrlHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListWarContainer.WarClanList");
    ClanListMyClanContainer = GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer");
    ClanSearchRequestorDrawerWnd = GetWindowHandle("ClanSearchRequestorDrawerWnd");
    MyAllyCrestTx = GetTextureHandle("ClanSearchWnd.ClanListMyClanContainer.MyAllyCrestTx");
    MyClanCrestTx = GetTextureHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanCrestTx");
    MyClanNameTxt = GetTextBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanNameTxt");
    MyAllyNameTxt = GetTextBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyAllyNameTxt");
    MyHallNameTxt = GetTextBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyHallNameTxt");
    MyBaseNameTxt = GetTextBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyBaseNameTxt");
    MyClanLvTx = GetTextureHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanLvTx");
    MyClanNumTxt = GetTextBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanNumTxt");
    MyFriendshipTypeTxt = GetTextBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyFriendshipTypeTxt");
    MyClanKnighthoodCBox = GetComboBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanKnighthoodCBox");
    MyRequestTypeTxt = GetTextBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyRequestTypeTxt");
    MyClanInfoHlBg = GetTextureHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanInfoHlBg");
    MyClanInfoMEdit = GetMultiEditBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanInfoMEdit");
    TelegramEBox = GetEditBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.TelegramEBox");
    DiscordEBox = GetEditBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.DiscordEBox");
    AcademyPriceEBox = GetEditBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.AcademyPriceEBox");
    MyClanPenaltyBtn = GetButtonHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanPenaltyBtn");
    MyClanAddClanBtn = GetButtonHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanAddClanBtn");
    MyClanResetChangesBtn = GetButtonHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanResetChangesBtn");
    ClanTypeLeftBtn = GetButtonHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.ClanTypeSelectorWnd.ClanTypeLeftBtn");
    ClanTypeRightBtn = GetButtonHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.ClanTypeSelectorWnd.ClanTypeRightBtn");
    ClanTypeNameTxt = GetTextBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.ClanTypeSelectorWnd.ClanTypeNameTxt");
    MyClanClanInviteTypeIcoTx = GetTextureHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanClanInviteTypeIcoTx");
    InviteTypeLeftBtn = GetButtonHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.InviteTypeSelectorWnd.InviteTypeLeftBtn");
    InviteTypeRightBtn = GetButtonHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.InviteTypeSelectorWnd.InviteTypeRightBtn");
    InviteTypeNameTxt = GetTextBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.InviteTypeSelectorWnd.InviteTypeNameTxt");
    KnighthoodLeftBtn = GetButtonHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.KnighthoodSelectorWnd.KnighthoodLeftBtn");
    KnighthoodRightBtn = GetButtonHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.KnighthoodSelectorWnd.KnighthoodRightBtn");
    KnighthoodNameTxt = GetTextBoxHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.KnighthoodSelectorWnd.KnighthoodNameTxt");
    InviteRequestList = GetListCtrlHandle("ClanSearchRequestorDrawerWnd.InviteRequestList");
    InviteRequestAcademyList = GetListCtrlHandle("ClanSearchRequestorDrawerWnd.InviteRequestAcademyList");
    RequestMEditLockWnd = GetWindowHandle("ClanSearchRequestorDrawerWnd.RequestMEditLockWnd");
    RequestorClanInfoLEdit = GetListBoxHandle("ClanSearchRequestorDrawerWnd.RequestorClanInfoLEdit");
    MyInviteCancelBtn = GetButtonHandle("ClanSearchRequestorDrawerWnd.MyInviteCancelBtn");
    MyInviteAddBtn = GetButtonHandle("ClanSearchRequestorDrawerWnd.MyInviteAddBtn");
    ClanInfoMEdit.SetMaxSizeOfText(100);
    MyClanInfoMEdit.SetMaxSizeOfText(100);
    ClanInfoMEdit.DisableWindow();
    ClanListDetailNumTxt.HideWindow();
    ClanList.SetResizable(false);
    ClanList.SetSelectedSelTooltip(false);
    ClanList.SetAppearTooltipAtMouseX(true);
    AcademyList.SetResizable(false);
    AcademyList.SetSelectedSelTooltip(false);
    AcademyList.SetAppearTooltipAtMouseX(true);
    InviteRequestList.SetResizable(false);
    InviteRequestList.SetSelectedSelTooltip(false);
    InviteRequestList.SetAppearTooltipAtMouseX(true);
    InviteRequestAcademyList.SetResizable(false);
    InviteRequestAcademyList.SetSelectedSelTooltip(false);
    InviteRequestAcademyList.SetAppearTooltipAtMouseX(true);
    initSelector();
    initPaginator();
    initListFilter();
    initWindow();
    SetClosingOnESC();
    return;
}

function initWindow()
{
    initOther();
    initHeadTab();
    initDetailTab();
    toggleMyClanState();
    toggleDetailSkillList(false);
    toggleRequestorAboutLock(true);
    toggleClanListDetailWindow(false);
    toggleHeadTab(0);
    changeWindowState(0);
    return;
}

function initOther()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x40 [Loop If]
    if(i < 7)
    {
        currentSort[i] = 0;
        toggleHeaderSortIcon(i, currentSort[i]);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    toggleRequestLock(false);
    currentSort[0] = 0;
    currentSort[1] = 0;
    currentSort[2] = 0;
    currentSort[3] = 0;
    currentSort[4] = 0;
    currentSort[5] = 0;
    currentSort[6] = 0;
    currentSort[7] = 0;
    currentSortType = 0;
    currentAcademySort[0] = 0;
    currentAcademySort[1] = 0;
    currentAcademySort[2] = 0;
    currentAcademySort[3] = 0;
    currentAcademySort[4] = 0;
    currentAcademySort[5] = 0;
    currentAcademySort[6] = 0;
    currentAcademySort[7] = 0;
    currentAcademySortType = 0;
    currentSelectedTab = 0;
    currMyFriendshipType = 0;
    currMyInviteType = 0;
    currMyKnighthoodType = 0;
    currKnighthoodIndex = 0;
    AvailableKnighthoodIDs.Remove(0, AvailableKnighthoodIDs.Length);
    ClanLevelCBox.SetSelectedNum(0);
    ClanFriendshipTypeCBox.SetSelectedNum(0);
    SearchTypeCBox.SetSelectedNum(0);
    SearchEBox.Clear();
    ClanList.DeleteAllItem();
    AcademyList.DeleteAllItem();
    InviteRequestList.DeleteAllItem();
    InviteRequestAcademyList.DeleteAllItem();
    ClanSkillList.Clear();
    RequestorClanInfoLEdit.Clear();
    ClanInfoMEdit.SetString("");
    MyClanInfoMEdit.SetString("");
    TelegramEBox.SetString("");
    DiscordEBox.SetString("");
    AcademyPriceEBox.SetString("");
    return;
}

function OnShow()
{
    initWindow();
    EssenceMainDesc(GetScript("EssenceMainDesc")).CheckByType(1);
    // End:0x68
    if(getImAcademyUser())
    {
        FAKE_RQ_CLAN_SYSTEM_A(1, getFilterClanLevel(), getFilterClanType(), currentAcademySort[currentAcademySortType], currentAcademySortType, getFilterSearchType(), getFilterStringLine());        
    }
    else
    {
        FAKE_RQ_CLAN_SYSTEM(1, getFilterClanLevel(), getFilterClanType(), currentSort[currentSortType], currentSortType, getFilterSearchType(), getFilterStringLine());
    }
    return;
}

function OnHide()
{
    EssenceMainDesc(GetScript("EssenceMainDesc")).CheckByType(1);
    initWindow();
    return;
}

function OnChangeEditBox(string strID)
{
    local string Str, cutStr;

    // End:0x69
    if(strID == "SearchEBox")
    {
        Str = SearchEBox.GetString();
        // End:0x66
        if(InStr(Str, " ") > -1)
        {
            Str = Locs(Str, " ", "", false);
            SearchEBox.SetString(Str);
        }        
    }
    else
    {
        // End:0xD4
        if(strID == "TelegramEBox")
        {
            Str = TelegramEBox.GetString();
            // End:0xD1
            if(InStr(Str, " ") > -1)
            {
                Str = Locs(Str, " ", "", false);
                TelegramEBox.SetString(Str);
            }            
        }
        else
        {
            // End:0x13B
            if(strID == "DiscordEBox")
            {
                Str = DiscordEBox.GetString();
                // End:0x13B
                if(InStr(Str, " ") > -1)
                {
                    Str = Locs(Str, " ", "", false);
                    DiscordEBox.SetString(Str);
                }
            }
        }
    }
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(320);
    RegisterEvent(3550);
    RegisterEvent(1710);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1A
    if(Event_ID == 320)
    {
        HandleClanInfo(param);
    }
    // End:0x34
    if(Event_ID == 3550)
    {
        handleCustomPacket(param);
    }
    // End:0x49
    if(Event_ID == 1710)
    {
        processJoin();
    }
    return;
}

function handleCustomPacket(string param)
{
    local int EventID;

    ParseInt(param, "EventID", EventID);
    switch(EventID)
    {
        // End:0x36
        case 1250:
            handleClanSystemInfo(param);
            // End:0xEC
            break;
        // End:0x4C
        case 1251:
            handleClanList(param);
            // End:0xEC
            break;
        // End:0x62
        case 1258:
            handleAcademyList(param);
            // End:0xEC
            break;
        // End:0x78
        case 1252:
            handleClanDetailInfo(param);
            // End:0xEC
            break;
        // End:0x8E
        case 1257:
            handleClanDetailSkillList(param);
            // End:0xEC
            break;
        // End:0xA4
        case 1256:
            handleClanDetailWarList(param);
            // End:0xEC
            break;
        // End:0xBA
        case 1253:
            handleClanDetailList(param);
            // End:0xEC
            break;
        // End:0xD0
        case 1254:
            handleMyClanInfo(param);
            // End:0xEC
            break;
        // End:0xE6
        case 1255:
            handleMyClanInfoRequestorAbout(param);
            // End:0xEC
            break;
        // End:0xFFFF
        default:
            // End:0xEC
            break;
            break;
    }
    return;
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    // End:0x47
    if(a_WindowHandle.GetWindowName() == "ClanList")
    {
        Me.KillTimer(3001);
        Me.SetTimer(3001, 1);
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    // End:0x47
    if(a_WindowHandle.GetWindowName() == "ClanList")
    {
        Me.KillTimer(3001);
        Me.SetTimer(3001, 1);
    }
    return;
}

function OnRButtonDblClick(WindowHandle a_WindowHandle, int X, int Y)
{
    // End:0x47
    if(a_WindowHandle.GetWindowName() == "ClanList")
    {
        Me.KillTimer(3001);
        Me.SetTimer(3001, 1);
    }
    return;
}

function OnLButtonDblClick(WindowHandle a_WindowHandle, int X, int Y)
{
    // End:0x47
    if(a_WindowHandle.GetWindowName() == "ClanList")
    {
        Me.KillTimer(3001);
        Me.SetTimer(3001, 1);
    }
    return;
}

function OnMButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    // End:0x47
    if(a_WindowHandle.GetWindowName() == "ClanList")
    {
        Me.KillTimer(3001);
        Me.SetTimer(3001, 1);
    }
    return;
}

function string getShortSocial(string Str)
{
    local string S;
    local int P;

    S = Str;
    P = InStr(S, "/");
    J0x1B:

    // End:0x52 [Loop If]
    if(P > -1)
    {
        S = Mid(S, P + 1);
        P = InStr(S, "/");
        // [Loop Continue]
        goto J0x1B;
    }
    // End:0x70
    if(Left(S, 1) == "@")
    {
        S = Mid(S, 1);
    }
    return S;
    return;
}

function OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
    local string Link, tg;

    // End:0xD2
    if(a_WindowHandle.GetWindowName() == "TGTxt")
    {
        tg = ClanListDetailInfo.Socials.tg;
        // End:0xCF
        if((tg != "-") && tg != "")
        {
            // End:0xA2
            if(InStr(Caps(tg), "T.ME/") > -1)
            {
                // End:0x88
                if(InStr(Caps(tg), "HTTP") == 0)
                {
                    Link = tg;                    
                }
                else
                {
                    Link = "https://" $ tg;
                }                
            }
            else
            {
                Link = "https://t.me/" $ (getShortSocial(tg));
            }
            OpenGivenURL(Link);
        }        
    }
    else
    {
        // End:0x161
        if(a_WindowHandle.GetWindowName() == "DSTxt")
        {
            // End:0x161
            if((DSTxt.GetText() != "-") && DSTxt.GetText() != "")
            {
                ClipboardCopy(ClanListDetailInfo.Socials.ds);
                getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemString(8031), ClanListDetailInfo.Socials.ds));
            }
        }
    }
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    switch(ListCtrlID)
    {
        // End:0x27
        case "InviteRequestList":
            handleRequestorClick(false);
            // End:0x64
            break;
        // End:0x4E
        case "InviteRequestAcademyList":
            handleRequestorClick(true);
            // End:0x64
            break;
        // End:0x5E
        case "ClanList":
            // End:0x64
            break;
        // End:0xFFFF
        default:
            // End:0x64
            break;
            break;
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    switch(ListCtrlID)
    {
        // End:0x14
        case "ClanList":
        // End:0x2D
        case "AcademyList":
            handleDetailClick();
            // End:0x33
            break;
        // End:0xFFFF
        default:
            // End:0x33
            break;
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    // End:0x55
    if(strID == "HeadTab00")
    {
        currentSelectedTab = 0;
        FAKE_RQ_CLAN_SYSTEM(1, getFilterClanLevel(), getFilterClanType(), currentSort[currentSortType], currentSortType, getFilterSearchType(), getFilterStringLine());
        toggleRequestLock(true);        
    }
    else
    {
        // End:0xB2
        if(strID == "HeadTab01")
        {
            currentSelectedTab = 1;
            FAKE_RQ_CLAN_SYSTEM_A(1, getFilterClanLevel(), getFilterClanType(), currentSort[currentSortType], currentSortType, getFilterSearchType(), getFilterStringLine());
            changeWindowState(1);
            toggleRequestLock(true);            
        }
        else
        {
            // End:0xDC
            if(strID == "HeadTab02")
            {
                currentSelectedTab = 2;
                FAKE_RQ_CLAN_SYSTEM_MY_CLAN();
                toggleRequestLock(true);
            }
        }
    }
    // End:0x16A
    if(strID == "SearchBtn")
    {
        // End:0x12E
        if(currentSelectedTab == 0)
        {
            FAKE_RQ_CLAN_SYSTEM(1, getFilterClanLevel(), getFilterClanType(), currentSort[currentSortType], currentSortType, getFilterSearchType(), getFilterStringLine());            
        }
        else
        {
            // End:0x160
            if(currentSelectedTab == 1)
            {
                FAKE_RQ_CLAN_SYSTEM_A(1, 100, 100, currentAcademySort[currentAcademySortType], currentAcademySortType, getFilterSearchType(), getFilterStringLine());
            }
        }
        toggleRequestLock(true);        
    }
    else
    {
        // End:0x18D
        if(strID == "RequestJoinBtn")
        {
            requestJoin();            
        }
        else
        {
            // End:0x1C2
            if(strID == "ClanListDetailSkillBtn")
            {
                FAKE_RQ_CLAN_SYSTEM_DETAIL_CLAN_SKILL(targetListClanData.clanID);                
            }
            else
            {
                // End:0x1EB
                if(strID == "CloseDetailSkillBtn")
                {
                    toggleDetailSkillList(false);                    
                }
                else
                {
                    // End:0x21E
                    if(strID == "MyInviteAddBtn")
                    {
                        FAKE_RQ_CLAN_SYSTEM_REQUESTOR_ACTION(MyInviteAddBtn.GetButtonValue(), 1);                        
                    }
                    else
                    {
                        // End:0x254
                        if(strID == "MyInviteCancelBtn")
                        {
                            FAKE_RQ_CLAN_SYSTEM_REQUESTOR_ACTION(MyInviteAddBtn.GetButtonValue(), 0);                            
                        }
                        else
                        {
                            // End:0x281
                            if(strID == "RequestPrivateMessageBtn")
                            {
                                whisperToUser();                                
                            }
                            else
                            {
                                // End:0x2A9
                                if(strID == "RequestPostWriteBtn")
                                {
                                    sendPost();                                    
                                }
                                else
                                {
                                    // End:0x2F2
                                    if((strID == "ClanListDetailCancelBtn") || strID == "CloseDetailBtn")
                                    {
                                        toggleClanListDetailWindow(false);                                        
                                    }
                                    else
                                    {
                                        // End:0x332
                                        if(strID == "MyClanAddClanBtn")
                                        {
                                            // End:0x329
                                            if(getClanTypeSelect())
                                            {
                                                // End:0x326
                                                if(canAddClan())
                                                {
                                                    FAKE_RQ_CLAN_SYSTEM_MY_CLAN_ADD();
                                                }                                                
                                            }
                                            else
                                            {
                                                FAKE_RQ_CLAN_SYSTEM_MY_ACADEMY_ADD();
                                            }                                            
                                        }
                                        else
                                        {
                                            // End:0x3BC
                                            if(strID == "MyClanResetChangesBtn")
                                            {
                                                // End:0x386
                                                if(MyClanAddClanBtn.GetButtonValue() == 0)
                                                {
                                                    // End:0x380
                                                    if(currMyKnighthoodType == -1)
                                                    {
                                                        FAKE_RQ_CLAN_SYSTEM_MY_ACADEMY();                                                        
                                                    }
                                                    else
                                                    {
                                                        FAKE_RQ_CLAN_SYSTEM_MY_CLAN();
                                                    }
                                                }
                                                // End:0x3B9
                                                if(MyClanAddClanBtn.GetButtonValue() == 1)
                                                {
                                                    // End:0x3B3
                                                    if(currMyKnighthoodType == -1)
                                                    {
                                                        FAKE_RQ_CLAN_SYSTEM_MY_ACADEMY_REMOVE();                                                        
                                                    }
                                                    else
                                                    {
                                                        FAKE_RQ_CLAN_SYSTEM_MY_CLAN_REMOVE();
                                                    }
                                                }                                                
                                            }
                                            else
                                            {
                                                // End:0x3ED
                                                if(strID == "ClanListDetailTab0")
                                                {
                                                    FAKE_RQ_CLAN_SYSTEM_DETAIL(targetListClanData.clanID);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x426
                                                    if(strID == "ClanListDetailTab1")
                                                    {
                                                        FAKE_RQ_CLAN_SYSTEM_DETAIL_CLAN_WAR(1, targetListClanData.clanID);
                                                        toggleDetailSkillList(false);                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x45F
                                                        if(strID == "ClanListDetailTab2")
                                                        {
                                                            FAKE_RQ_CLAN_SYSTEM_DETAIL_CLAN_LIST(1, targetListClanData.clanID);
                                                            toggleDetailSkillList(false);                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x490
                                                            if(strID == "callSearch")
                                                            {
                                                                OnShow();
                                                                ShowWindow("ClanSearch");                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x4C0
                                                                if(strID == "BtnViewNext")
                                                                {
                                                                    ClanListPaginator.setNextPage();
                                                                    toggleRequestLock(true);                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x4EF
                                                                    if(strID == "BtnViewPre")
                                                                    {
                                                                        ClanListPaginator.setPrevPage();
                                                                        toggleRequestLock(true);                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x522
                                                                        if(strID == "BtnViewNextEnd")
                                                                        {
                                                                            ClanListPaginator.setMaxPage();
                                                                            toggleRequestLock(true);                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x554
                                                                            if(strID == "BtnViewPreEnd")
                                                                            {
                                                                                ClanListPaginator.setMinPage();
                                                                                toggleRequestLock(true);                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x583
                                                                                if(strID == "BtnDetailViewNext")
                                                                                {
                                                                                    DetailClanListPaginator.setNextPage();                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    // End:0x5B1
                                                                                    if(strID == "BtnDetailViewPre")
                                                                                    {
                                                                                        DetailClanListPaginator.setPrevPage();                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        // End:0x5E3
                                                                                        if(strID == "BtnDetailViewNextEnd")
                                                                                        {
                                                                                            DetailClanListPaginator.setMaxPage();                                                                                            
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            // End:0x614
                                                                                            if(strID == "BtnDetailViewPreEnd")
                                                                                            {
                                                                                                DetailClanListPaginator.setMinPage();                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                // End:0x639
                                                                                                if(strID == "ClanTypeLeftBtn")
                                                                                                {
                                                                                                    SwitchClanFriendshipType(false);                                                                                                    
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    // End:0x65F
                                                                                                    if(strID == "ClanTypeRightBtn")
                                                                                                    {
                                                                                                        SwitchClanFriendshipType(true);                                                                                                        
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        // End:0x686
                                                                                                        if(strID == "InviteTypeLeftBtn")
                                                                                                        {
                                                                                                            SwitchClanInviteType(false);                                                                                                            
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                            // End:0x6AE
                                                                                                            if(strID == "InviteTypeRightBtn")
                                                                                                            {
                                                                                                                SwitchClanInviteType(true);                                                                                                                
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                // End:0x6D5
                                                                                                                if(strID == "KnighthoodLeftBtn")
                                                                                                                {
                                                                                                                    SwitchKnighthoodType(false);                                                                                                                    
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    // End:0x6FD
                                                                                                                    if(strID == "KnighthoodRightBtn")
                                                                                                                    {
                                                                                                                        SwitchKnighthoodType(true);                                                                                                                        
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        // End:0x726
                                                                                                                        if(InStr(strID, "SortTab0") > -1)
                                                                                                                        {
                                                                                                                            handleHeaderSort(strID);                                                                                                                            
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            // End:0x753
                                                                                                                            if(InStr(strID, "SortAcademyTab0") > -1)
                                                                                                                            {
                                                                                                                                handleAcademyHeaderSort(strID);
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

function OnTimer(int TimerID)
{
    // End:0x6B
    if(TimerID == 1001)
    {
        Me.KillTimer(TimerID);
        // End:0x47
        if(RequestJoinBtn.GetButtonValue() != 1)
        {
            ClanInfoMEdit.ReleaseFocus();
        }
        // End:0x68
        if(ListDisableContainer.IsShowWindow())
        {
            SearchEBox.ReleaseFocus();
        }        
    }
    else
    {
        // End:0x98
        if(TimerID == 2001)
        {
            Me.KillTimer(TimerID);
            toggleRequestLock(false);            
        }
        else
        {
            // End:0xCA
            if(TimerID == 3001)
            {
                Me.KillTimer(TimerID);
                SortListContainer.SetFocus();
            }
        }
    }
    return;
}

function handleHeaderSort(string Str)
{
    local ClanSearchAPI.eSortType clickedSortType;

    currentSortType = int(Locs(Str, "SortTab0", "", true));
    currentSort[currentSortType] = currentSort[currentSortType] ^ 1;
    toggleHeaderSortIcon(currentSortType, currentSort[currentSortType]);
    toggleRequestLock(true);
    FAKE_RQ_CLAN_SYSTEM(1, getFilterClanLevel(), getFilterClanType(), currentSort[currentSortType], currentSortType, getFilterSearchType(), getFilterStringLine());
    return;
}

function handleAcademyHeaderSort(string Str)
{
    local ClanSearchAPI.eAcademySortType clickedSortType;

    currentAcademySortType = int(Locs(Str, "SortAcademyTab0", "", true));
    currentAcademySort[currentAcademySortType] = currentAcademySort[currentAcademySortType] ^ 1;
    toggleAcademyHeaderSortIcon(currentAcademySortType, currentAcademySort[currentAcademySortType]);
    toggleRequestLock(true);
    FAKE_RQ_CLAN_SYSTEM_A(1, getFilterClanLevel(), getFilterClanType(), currentAcademySort[currentAcademySortType], currentAcademySortType, getFilterSearchType(), getFilterStringLine());
    return;
}

function toggleRequestLock(bool bLocked)
{
    local int i;

    Me.KillTimer(2001);
    i = 0;
    J0x1B:

    // End:0x1AB [Loop If]
    if(i < 7)
    {
        // End:0x88
        if(bLocked)
        {
            GetButtonHandle("ClanSearchWnd.ClanListContainer.SortListContainer.SortTab0" $ string(i)).DisableWindow();            
        }
        else
        {
            GetButtonHandle("ClanSearchWnd.ClanListContainer.SortListContainer.SortTab0" $ string(i)).EnableWindow();
        }
        // End:0x145
        if(bLocked)
        {
            GetButtonHandle("ClanSearchWnd.ClanListContainer.SortListContainer.SortAcademyTab0" $ string(i)).DisableWindow();
            // [Explicit Continue]
            goto J0x1A1;
        }
        GetButtonHandle("ClanSearchWnd.ClanListContainer.SortListContainer.SortAcademyTab0" $ string(i)).EnableWindow();
        J0x1A1:

        i++;
        // [Loop Continue]
        goto J0x1B;
    }
    // End:0x22D
    if(bLocked)
    {
        HeadTab00.DisableWindow();
        HeadTab01.DisableWindow();
        HeadTab02.DisableWindow();
        SearchBtn.DisableWindow();
        PagiDisabledWnd.ShowWindow();
        PagiDisabledWnd.SetAlpha(255, 0.1500000);
        Me.SetTimer(2001, 1);        
    }
    else
    {
        HeadTab00.EnableWindow();
        HeadTab01.EnableWindow();
        HeadTab02.EnableWindow();
        PagiDisabledWnd.HideWindow();
        PagiDisabledWnd.SetAlpha(0, 0.1000000);
        SearchBtn.EnableWindow();
    }
    return;
}

function toggleHeaderSortIcon(int Index, int isUp)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x167 [Loop If]
    if(i < 7)
    {
        // End:0xE3
        if((i == Index) && isUp == 1)
        {
            GetWindowHandle("ClanSearchWnd.ClanListContainer.SortListContainer");
            GetTextureHandle("ClanSearchWnd.ClanListContainer.SortListContainer.SortIco0" $ string(Index)).SetTexture("L2UI_NewTex.Windows.List_Arrow_Up");
            // [Explicit Continue]
            goto J0x15D;
        }
        GetTextureHandle("ClanSearchWnd.ClanListContainer.SortListContainer.SortIco0" $ string(i)).SetTexture("L2UI_NewTex.Windows.List_Arrow_Down");
        J0x15D:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function toggleAcademyHeaderSortIcon(int Index, int isUp)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x18A [Loop If]
    if(i < 7)
    {
        // End:0xF8
        if((i == Index) && isUp == 1)
        {
            GetWindowHandle("ClanSearchWnd.ClanListContainer.SortAcademyListContainer");
            GetTextureHandle("ClanSearchWnd.ClanListContainer.SortAcademyListContainer.SortAcademyIco0" $ string(Index)).SetTexture("L2UI_NewTex.Windows.List_Arrow_Up");
            // [Explicit Continue]
            goto J0x180;
        }
        GetTextureHandle("ClanSearchWnd.ClanListContainer.SortAcademyListContainer.SortAcademyIco0" $ string(i)).SetTexture("L2UI_NewTex.Windows.List_Arrow_Down");
        J0x180:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function initHeadTab()
{
    // End:0x99
    if(getImAcademyUser())
    {
        HeadTab00.ShowWindow();
        HeadTab01.ShowWindow();
        HeadTab02.HideWindow();
        HeadTab00.SetWindowSize(379, 36);
        HeadTab01.SetWindowSize(379, 36);
        HeadTab00.SetAnchor("ClanSearchWnd", "TopLeft", "TopLeft", 7, 40);        
    }
    else
    {
        // End:0x13F
        if(getImClanLeader())
        {
            HeadTab00.ShowWindow();
            HeadTab01.ShowWindow();
            HeadTab02.ShowWindow();
            HeadTab00.SetWindowSize(252, 36);
            HeadTab01.SetWindowSize(252, 36);
            HeadTab02.SetWindowSize(252, 36);
            HeadTab00.SetAnchor("ClanSearchWnd", "TopLeft", "TopLeft", 7, 40);            
        }
        else
        {
            HeadTab00.ShowWindow();
            HeadTab01.HideWindow();
            HeadTab02.HideWindow();
            HeadTab00.SetWindowSize(252 * 3, 36);
            HeadTab00.SetAnchor("ClanSearchWnd", "TopLeft", "TopLeft", 7, 40);
        }
    }
    return;
}

function initDetailTab()
{
    ClanListDetailTab.SetTopOrder(0, false);
    return;
}

function initListFilter()
{
    local int i;

    ClanLevelCBox.AddStringWithReserved(GetSystemString(144), 100);
    i = 1;
    J0x20:

    // End:0x5B [Loop If]
    if(i < 12)
    {
        ClanLevelCBox.AddStringWithReserved(GetSystemString(88) @ string(i), i);
        i++;
        // [Loop Continue]
        goto J0x20;
    }
    ClanFriendshipTypeCBox.AddStringWithReserved(GetSystemString(144), 100);
    ClanFriendshipTypeCBox.AddStringWithReserved(GetSystemString(412) @ GetSystemString(8001), 0);
    ClanFriendshipTypeCBox.AddStringWithReserved(GetSystemString(412) @ GetSystemString(8002), 1);
    ClanFriendshipTypeCBox.AddStringWithReserved(GetSystemString(412) @ GetSystemString(8003), 2);
    ClanFriendshipTypeCBox.AddStringWithReserved(GetSystemString(412) @ GetSystemString(8004), 3);
    SearchTypeCBox.AddStringWithReserved(GetSystemString(144), 100);
    SearchTypeCBox.AddStringWithReserved(GetSystemString(7988), 0);
    SearchTypeCBox.AddStringWithReserved(GetSystemString(7989), 1);
    return;
}

function initPaginator()
{
    PagiDisabledWnd = GetWindowHandle("ClanSearchWnd.ClanListContainer.PagiDisabledWnd");
    PaginationContainer = GetWindowHandle("ClanSearchWnd.ClanListContainer.PaginationContainer");
    ClanListPaginator = new Class'Interface.Paginator';
    ClanListPaginator.SetPaginatorElement(GetTextBoxHandle("ClanSearchWnd.ClanListContainer.PaginationContainer.currPageTxt"), GetTextBoxHandle("ClanSearchWnd.ClanListContainer.PaginationContainer.totalPageTxt"), GetButtonHandle("ClanSearchWnd.ClanListContainer.PaginationContainer.BtnViewNext"), GetButtonHandle("ClanSearchWnd.ClanListContainer.PaginationContainer.BtnViewPre"), GetButtonHandle("ClanSearchWnd.ClanListContainer.PaginationContainer.BtnViewPreEnd"), GetButtonHandle("ClanSearchWnd.ClanListContainer.PaginationContainer.BtnViewNextEnd"));
    ClanListPaginator.__onPageNext__Delegate = handlePageNext;
    ClanListPaginator.__onPagePrev__Delegate = handlePagePrev;
    DetailClanListPaginator = new Class'Interface.Paginator';
    DetailClanListPaginator.SetPaginatorElement(GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListDetailContainer.ClanListDetailContainer.currDetailPageTxt"), GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListDetailContainer.ClanListDetailContainer.totalDetailPageTxt"), GetButtonHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListDetailContainer.ClanListDetailContainer.BtnDetailViewNext"), GetButtonHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListDetailContainer.ClanListDetailContainer.BtnDetailViewPre"), GetButtonHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListDetailContainer.ClanListDetailContainer.BtnDetailViewPreEnd"), GetButtonHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListDetailContainer.ClanListDetailContainer.BtnDetailViewNextEnd"));
    DetailClanListPaginator.__onPageNext__Delegate = handlePageDetailNext;
    DetailClanListPaginator.__onPagePrev__Delegate = handlePageDetailPrev;
    DetailClanWarListPaginator = new Class'Interface.Paginator';
    DetailClanWarListPaginator.SetPaginatorElement(GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListWarContainer.SelectedClanWarPaginationContainer.currDetailWarPageTxt"), GetTextBoxHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListWarContainer.SelectedClanWarPaginationContainer.totalDetailWarPageTxt"), GetButtonHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListWarContainer.SelectedClanWarPaginationContainer.BtnDetailWarViewNext"), GetButtonHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListWarContainer.SelectedClanWarPaginationContainer.BtnDetailWarViewPre"), GetButtonHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListWarContainer.SelectedClanWarPaginationContainer.BtnDetailWarViewPreEnd"), GetButtonHandle("ClanSearchWnd.ClanListContainer.ClanDetailContainer.ClanListWarContainer.SelectedClanWarPaginationContainer.BtnDetailWarViewNextEnd"));
    DetailClanWarListPaginator.__onPageNext__Delegate = handlePageDetailWarNext;
    DetailClanWarListPaginator.__onPagePrev__Delegate = handlePageDetailWarPrev;
    return;
}

function handlePageNext()
{
    local int page;

    page = ClanListPaginator.getCurrentPage();
    // End:0x56
    if(currentSelectedTab == 0)
    {
        FAKE_RQ_CLAN_SYSTEM(page, getFilterClanLevel(), getFilterClanType(), currentSort[currentSortType], currentSortType, getFilterSearchType(), getFilterStringLine());        
    }
    else
    {
        FAKE_RQ_CLAN_SYSTEM_A(page, getFilterClanLevel(), getFilterClanType(), currentSort[currentSortType], currentSortType, getFilterSearchType(), getFilterStringLine());
    }
    return;
}

function handlePagePrev()
{
    local int page;

    page = ClanListPaginator.getCurrentPage();
    // End:0x56
    if(currentSelectedTab == 0)
    {
        FAKE_RQ_CLAN_SYSTEM(page, getFilterClanLevel(), getFilterClanType(), currentSort[currentSortType], currentSortType, getFilterSearchType(), getFilterStringLine());        
    }
    else
    {
        FAKE_RQ_CLAN_SYSTEM_A(page, getFilterClanLevel(), getFilterClanType(), currentSort[currentSortType], currentSortType, getFilterSearchType(), getFilterStringLine());
    }
    return;
}

function handlePageDetailNext()
{
    local int page;

    page = DetailClanListPaginator.getCurrentPage();
    FAKE_RQ_CLAN_SYSTEM_DETAIL_CLAN_LIST(page, targetListClanData.clanID);
    return;
}

function handlePageDetailPrev()
{
    local int page;

    page = DetailClanListPaginator.getCurrentPage();
    FAKE_RQ_CLAN_SYSTEM_DETAIL_CLAN_LIST(page, targetListClanData.clanID);
    return;
}

function handlePageDetailWarNext()
{
    local int page;

    page = DetailClanWarListPaginator.getCurrentPage();
    FAKE_RQ_CLAN_SYSTEM_DETAIL_CLAN_WAR(page, targetListClanData.clanID);
    return;
}

function handlePageDetailWarPrev()
{
    local int page;

    page = DetailClanWarListPaginator.getCurrentPage();
    FAKE_RQ_CLAN_SYSTEM_DETAIL_CLAN_WAR(page, targetListClanData.clanID);
    return;
}

function changeDetailWindowState(ClanSearchAPI.eAskJoinState State)
{
    // End:0x33
    if(int(State) == 0)
    {
        MEditLockWnd.ShowWindow();
        RequestJoinBtn.SetButtonName(7990);        
    }
    else
    {
        // End:0x86
        if(int(State) == 1)
        {
            MEditLockWnd.HideWindow();
            ClanInfoMEdit.SetString("");
            ClanInfoMEdit.SetFocus();
            RequestJoinBtn.SetButtonName(7991);            
        }
        else
        {
            // End:0x105
            if(int(State) == 2)
            {
                MEditLockWnd.ShowWindow();
                // End:0xCA
                if(currentSelectedTab == 0)
                {
                    ClanInfoMEdit.SetString(ClanListInfo.askJoinRequestClanAbout);                    
                }
                else
                {
                    // End:0xEE
                    if(currentSelectedTab == 1)
                    {
                        ClanInfoMEdit.SetString(ClanListInfo.askJoinRequestAcademyAbout);
                    }
                }
                RequestJoinBtn.SetButtonName(7992);                
            }
            else
            {
                // End:0x181
                if(int(State) == 3)
                {
                    MEditLockWnd.ShowWindow();
                    // End:0x149
                    if(currentSelectedTab == 0)
                    {
                        ClanInfoMEdit.SetString(ClanListInfo.askJoinRequestClanAbout);                        
                    }
                    else
                    {
                        // End:0x16D
                        if(currentSelectedTab == 1)
                        {
                            ClanInfoMEdit.SetString(ClanListInfo.askJoinRequestAcademyAbout);
                        }
                    }
                    RequestJoinBtn.SetButtonName(8055);
                }
            }
        }
    }
    RequestJoinBtn.SetButtonValue(int(State));
    return;
}

function requestJoin()
{
    // End:0x56
    if(RequestJoinBtn.GetButtonValue() == 2)
    {
        // End:0x31
        if(currentSelectedTab == 0)
        {
            evRqClanSearchSystemClanCancelAskJoin(targetListClanData.clanID);
        }
        // End:0x4C
        if(currentSelectedTab == 1)
        {
            evRqClanSearchSystemAcademyCancelAskJoin(targetListAcademyData.clanID);
        }
        toggleClanListDetailWindow(false);        
    }
    else
    {
        // End:0xBB
        if(isFreeInvite())
        {
            DialogSetID(1111220);
            // End:0x85
            if(currentSelectedTab == 0)
            {
                DialogSetReservedInt(targetListClanData.clanID);
            }
            // End:0xA0
            if(currentSelectedTab == 1)
            {
                DialogSetReservedInt(targetListAcademyData.clanID);
            }
            DialogShow(0, 0, GetSystemString(8039), string(self));            
        }
        else
        {
            // End:0xDB
            if(RequestJoinBtn.GetButtonValue() == 0)
            {
                changeDetailWindowState(1);                
            }
            else
            {
                // End:0x17A
                if(RequestJoinBtn.GetButtonValue() == 1)
                {
                    // End:0x12B
                    if(((getAskJoinAbout()) == "") || Len(getAskJoinAbout()) < 5)
                    {
                        getInstanceL2Util().showGfxScreenMessage(GetSystemString(8040));
                        return;
                    }
                    // End:0x14C
                    if(currentSelectedTab == 0)
                    {
                        evRqClanSearchSystemClanAskJoin(targetListClanData.clanID, getAskJoinAbout());
                    }
                    // End:0x16D
                    if(currentSelectedTab == 1)
                    {
                        evRqClanSearchSystemAcademyAskJoin(targetListAcademyData.clanID, getAskJoinAbout());
                    }
                    changeWindowState(byte(currentSelectedTab));
                }
            }
        }
    }
    return;
}

function processJoin()
{
    // End:0x5D
    if(DialogIsMine())
    {
        switch(DialogGetID())
        {
            // End:0x57
            case 1111220:
                // End:0x30
                if(currentSelectedTab == 0)
                {
                    evRqClanSearchSystemClanJoin(DialogGetReservedInt());
                }
                // End:0x47
                if(currentSelectedTab == 1)
                {
                    evRqClanSearchSystemAcademyJoin(DialogGetReservedInt());
                }
                changeWindowState(byte(currentSelectedTab));
                // End:0x5D
                break;
            // End:0xFFFF
            default:
                // End:0x5D
                break;
                break;
        }
    }
    return;
}

function changeWindowState(ClanSearchAPI.eWindowState State)
{
    switch(State)
    {
        // End:0xC8
        case 0:
            toggleClanListDetailWindow(false);
            ClanLevelCBox.ShowWindow();
            ClanFriendshipTypeCBox.ShowWindow();
            ClanListContainer.ShowWindow();
            ClanListMyClanContainer.HideWindow();
            ClanListContainer.SetAlpha(255, 0.2500000);
            ClanListMyClanContainer.SetAlpha(0, 0.2500000);
            ClanSearchRequestorDrawerWnd.HideWindow();
            ClanList.ShowWindow();
            SortListContainer.ShowWindow();
            AcademyList.HideWindow();
            SortAcademyListContainer.HideWindow();
            // End:0x1EC
            break;
        // End:0x189
        case 1:
            toggleClanListDetailWindow(false);
            ClanLevelCBox.HideWindow();
            ClanFriendshipTypeCBox.HideWindow();
            ClanListContainer.ShowWindow();
            ClanListMyClanContainer.HideWindow();
            ClanListContainer.SetAlpha(255, 0.2500000);
            ClanListMyClanContainer.SetAlpha(0, 0.2500000);
            ClanSearchRequestorDrawerWnd.HideWindow();
            ClanList.HideWindow();
            SortListContainer.HideWindow();
            AcademyList.ShowWindow();
            SortAcademyListContainer.ShowWindow();
            // End:0x1EC
            break;
        // End:0x1E6
        case 2:
            toggleMyClanState();
            initSelector();
            ClanListContainer.HideWindow();
            ClanListMyClanContainer.ShowWindow();
            ClanListContainer.SetAlpha(0, 0.2500000);
            ClanListMyClanContainer.SetAlpha(255, 0.2500000);
            // End:0x1EC
            break;
        // End:0xFFFF
        default:
            // End:0x1EC
            break;
            break;
    }
    toggleHeadTab(State);
    return;
}

function handleClanSystemInfo(string param)
{
    ParseInt(param, "ask", ClanListInfo.nAskJoinRequestClanId);
    ParseInt(param, "reply", ClanListInfo.nAskJoinRequestAcademyId);
    ParseString(param, "param1", ClanListInfo.askJoinRequestClanAbout);
    ParseString(param, "param2", ClanListInfo.askJoinRequestAcademyAbout);
    return;
}

function handleClanList(string param)
{
    local int i, j, nPage, nMaxPage;
    local string Param1, Param2, param3;
    local array<string> clansInfo1, clansInfo2, clansInfo3, clansInfo4, mergedInfo1, mergedInfo2,
	    clansInfo, ClanInfo;

    local sClanListData tmpClanData;

    ParseInt(param, "ask", nPage);
    ParseInt(param, "reply", nMaxPage);
    ParseString(param, "param1", Param1);
    ParseString(param, "param2", Param2);
    ParseString(param, "param3", param3);
    ClanListPaginator.setPages(nPage, nMaxPage);
    ClanListData.Remove(0, ClanListData.Length);
    clansInfo1 = Arr(Param1, ";");
    clansInfo2 = Arr(Param2, ";");
    clansInfo3 = Arr(param3, ";");
    mergedInfo1 = MergeArray(clansInfo1, clansInfo2);
    mergedInfo2 = MergeArray(clansInfo3, clansInfo4);
    clansInfo = MergeArray(mergedInfo1, mergedInfo2);
    ClanListData.Length = clansInfo.Length;
    i = 0;
    J0x12C:

    // End:0x2EE [Loop If]
    if(i < clansInfo.Length)
    {
        ClanInfo = Arr(clansInfo[i], ",");
        j = 0;
        J0x15D:

        // End:0x2D3 [Loop If]
        if(j < ClanInfo.Length)
        {
            tmpClanData.clanID = int(ClanInfo[0]);
            tmpClanData.allyId = int(ClanInfo[1]);
            // End:0x1BA
            if(tmpClanData.allyId == 1)
            {
                tmpClanData.allyId = tmpClanData.clanID;
            }
            tmpClanData.ClanName = ClanInfo[2];
            tmpClanData.alyName = ClanInfo[3];
            tmpClanData.LeaderName = ClanInfo[4];
            tmpClanData.knighthood = int(ClanInfo[5]);
            tmpClanData.Level = int(ClanInfo[6]);
            tmpClanData.Count = int(ClanInfo[7]);
            tmpClanData.clanType = byte(int(ClanInfo[8]));
            tmpClanData.clanRequestType = byte(int(ClanInfo[9]));
            tmpClanData.baseId = int(ClanInfo[10]);
            tmpClanData.hallId = int(ClanInfo[11]);
            tmpClanData.ServerID = int(ClanInfo[12]);
            tmpClanData.cIconId = int(ClanInfo[13]);
            tmpClanData.aIconId = int(ClanInfo[14]);
            j++;
            // [Loop Continue]
            goto J0x15D;
        }
        ClanListData[i] = tmpClanData;
        i++;
        // [Loop Continue]
        goto J0x12C;
    }
    insertClanList();
    return;
}

function insertClanList()
{
    local int i;

    ClanList.DeleteAllItem();
    i = 0;
    J0x16:

    // End:0x50 [Loop If]
    if(i < ClanListData.Length)
    {
        ClanList.InsertRecord(getClanListRecord(ClanListData[i]));
        i++;
        // [Loop Continue]
        goto J0x16;
    }
    changeWindowState(0);
    return;
}

function handleAcademyList(string param)
{
    local int i, j, nPage, nMaxPage;
    local string Param1, Param2, param3;
    local array<string> academysInfo1, academysInfo2, academysInfo3, academysInfo4, mergedInfo1, mergedInfo2,
	    academysInfo, ClanInfo;

    local sAcademyListData tmpClanData;

    ParseInt(param, "ask", nPage);
    ParseInt(param, "reply", nMaxPage);
    ParseString(param, "param1", Param1);
    ParseString(param, "param2", Param2);
    ParseString(param, "param3", param3);
    ClanListPaginator.setPages(nPage, nMaxPage);
    AcademyListData.Remove(0, AcademyListData.Length);
    academysInfo1 = Arr(Param1, ";");
    academysInfo2 = Arr(Param2, ";");
    academysInfo3 = Arr(param3, ";");
    mergedInfo1 = MergeArray(academysInfo1, academysInfo2);
    mergedInfo2 = MergeArray(academysInfo3, academysInfo4);
    academysInfo = MergeArray(mergedInfo1, mergedInfo2);
    AcademyListData.Length = academysInfo.Length;
    i = 0;
    J0x12C:

    // End:0x2D7 [Loop If]
    if(i < academysInfo.Length)
    {
        ClanInfo = Arr(academysInfo[i], ",");
        j = 0;
        J0x15D:

        // End:0x2BC [Loop If]
        if(j < ClanInfo.Length)
        {
            tmpClanData.clanID = int(ClanInfo[0]);
            tmpClanData.allyId = int(ClanInfo[1]);
            // End:0x1BA
            if(tmpClanData.allyId == 1)
            {
                tmpClanData.allyId = tmpClanData.clanID;
            }
            tmpClanData.ClanName = ClanInfo[2];
            tmpClanData.alyName = ClanInfo[3];
            tmpClanData.LeaderName = ClanInfo[4];
            tmpClanData.Level = int(ClanInfo[5]);
            tmpClanData.Count = int(ClanInfo[6]);
            tmpClanData.clanRequestType = byte(int(ClanInfo[7]));
            tmpClanData.baseId = int(ClanInfo[8]);
            tmpClanData.hallId = int(ClanInfo[9]);
            tmpClanData.academyPrice = (ClanInfo[10]);
            tmpClanData.ServerID = int(ClanInfo[11]);
            tmpClanData.cIconId = int(ClanInfo[12]);
            tmpClanData.aIconId = int(ClanInfo[13]);
            j++;
            // [Loop Continue]
            goto J0x15D;
        }
        AcademyListData[i] = tmpClanData;
        i++;
        // [Loop Continue]
        goto J0x12C;
    }
    insertAcademyList();
    return;
}

function insertAcademyList()
{
    local int i;

    AcademyList.DeleteAllItem();
    i = 0;
    J0x16:

    // End:0x50 [Loop If]
    if(i < AcademyListData.Length)
    {
        AcademyList.InsertRecord(getAcademyListRecord(AcademyListData[i]));
        i++;
        // [Loop Continue]
        goto J0x16;
    }
    changeWindowState(1);
    return;
}

function handleDetailClick()
{
    local LVDataRecord Record;

    // End:0x4D
    if(currentSelectedTab == 0)
    {
        ClanList.GetSelectedRec(Record);
        targetListClanData = ClanListData[ClanList.GetSelectedIndex()];
        FAKE_RQ_CLAN_SYSTEM_DETAIL(targetListClanData.clanID);        
    }
    else
    {
        // End:0x97
        if(currentSelectedTab == 1)
        {
            AcademyList.GetSelectedRec(Record);
            targetListAcademyData = AcademyListData[AcademyList.GetSelectedIndex()];
            FAKE_RQ_CLAN_SYSTEM_DETAIL_A(targetListAcademyData.clanID);
        }
    }
    return;
}

function handleRequestorClick(bool bAcademy)
{
    local LVDataRecord Record;

    // End:0x20
    if(bAcademy)
    {
        InviteRequestAcademyList.GetSelectedRec(Record);        
    }
    else
    {
        InviteRequestList.GetSelectedRec(Record);
    }
    FAKE_RQ_CLAN_SYSTEM_REQUESTOR_ABOUT(name(Record.nReserved1));
    MyInviteAddBtn.SetButtonValue(name(Record.nReserved1));
    return;
}

function handleClanDetailInfo(string param)
{
    local string detailDataStr, socialsStr, clanDecription;
    local array<string> detailDataArr, socialsArr;

    ParseString(param, "param1", detailDataStr);
    ParseString(param, "param2", socialsStr);
    ParseString(param, "param3", clanDecription);
    detailDataArr = Arr(detailDataStr, ",");
    socialsArr = Arr(socialsStr, ",");
    // End:0x10D
    if(detailDataArr.Length > 0)
    {
        ClanListDetailInfo.Position = int(detailDataArr[0]);
        ClanListDetailInfo.reputation = int(detailDataArr[1]);
        ClanListDetailInfo.averageLevel = int(detailDataArr[2]);
        ClanListDetailInfo.pvp = int(detailDataArr[3]);
        ClanListDetailInfo.pk = int(detailDataArr[4]);
        ClanListDetailInfo.nNobles = int(detailDataArr[5]);
        ClanListDetailInfo.nHeroes = int(detailDataArr[6]);
    }
    ClanListDetailInfo.Socials.tg = socialsArr[0];
    ClanListDetailInfo.Socials.ds = socialsArr[1];
    ClanListDetailInfo.Description = clanDecription;
    toggleClanListDetailWindow(true);
    return;
}

function handleClanDetailList(string param)
{
    local LVDataRecord Record;
    local int i, j, nPage, nMaxPage;
    local string clanStr;
    local array<string> ClanMembersData, ClanMemberData;

    ParseInt(param, "ask", nPage);
    ParseInt(param, "reply", nMaxPage);
    ParseString(param, "param1", clanStr);
    DetailClanListPaginator.setPages(nPage, nMaxPage);
    SelectedClanList.DeleteAllItem();
    ClanMembersData = Arr(clanStr, ";");
    Record.LVDataList.Length = 15;
    i = 0;
    J0x95:

    // End:0x1E8 [Loop If]
    if(i < ClanMembersData.Length)
    {
        ClanMemberData = Arr(ClanMembersData[i], ",");
        Record.nReserved1 = (int(ClanMemberData[1]));
        Record.szReserved = ClanMemberData[0];
        Record.LVDataList[0].szData = ClanMemberData[0];
        Record.LVDataList[1].szData = string(int(ClanMemberData[2]));
        Record.LVDataList[1].szTexture = GetClassRoleIconName(int(ClanMemberData[2]));
        Record.LVDataList[1].HiddenStringForSorting = ClanMemberData[2];
        Record.LVDataList[1].nTextureWidth = 11;
        Record.LVDataList[1].nTextureHeight = 11;
        Record.LVDataList[1].textAlignment = 2;
        Record.LVDataList[2].szData = string(int(ClanMemberData[3]));
        Record.LVDataList[2].textAlignment = 2;
        SelectedClanList.InsertRecord(Record);
        i++;
        // [Loop Continue]
        goto J0x95;
    }
    return;
}

function handleClanDetailSkillList(string param)
{
    local int i, j;
    local string skillsStr;
    local array<string> skillsData, skillData;
    local sClanWarListData ClanWarListData;
    local SkillInfo Skill;

    ParseString(param, "param1", skillsStr);
    ClanSkillList.Clear();
    skillsData = Arr(skillsStr, ";");
    i = 0;
    J0x42:

    // End:0xB1 [Loop If]
    if(i < skillsData.Length)
    {
        skillData = Arr(skillsData[i], ",");
        // End:0xA7
        if(GetSkillInfo(int(skillData[0]), int(skillData[1]), 0, Skill))
        {
            ClanSkillList.AddItem(getSkillToItemInfo(Skill));
        }
        i++;
        // [Loop Continue]
        goto J0x42;
    }
    ClanSkillList.EnableWindow();
    // End:0xDB
    if(skillsData.Length == 0)
    {
        ClanSkillList.DisableWindow();
    }
    toggleDetailSkillList(true);
    return;
}

function handleClanDetailWarList(string param)
{
    local LVDataRecord Record;
    local int i, j, nPage, nMaxPage;
    local string clanWarStr;
    local array<string> ClanWarsData, ClanWarData;
    local sClanWarListData ClanWarListData;

    ParseInt(param, "ask", nPage);
    ParseInt(param, "reply", nMaxPage);
    ParseString(param, "param1", clanWarStr);
    DetailClanWarListPaginator.setPages(nPage, nMaxPage);
    WarClanList.DeleteAllItem();
    ClanWarsData = Arr(clanWarStr, ";");
    Record.LVDataList.Length = 15;
    i = 0;
    J0x95:

    // End:0x15D [Loop If]
    if(i < ClanWarsData.Length)
    {
        ClanWarData = Arr(ClanWarsData[i], ",");
        ClanWarListData.ClanName = ClanWarData[0];
        ClanWarListData.State = int(ClanWarData[1]);
        ClanWarListData.progressTimeInSec = int(ClanWarData[2]);
        ClanWarListData.point = int(ClanWarData[3]);
        ClanWarListData.pointDiff = int(ClanWarData[4]);
        ClanWarListData.leftKillCountOfEnemyToWar = int(ClanWarData[5]);
        WarClanList.InsertRecord(getClanWarListRecord(ClanWarListData));
        i++;
        // [Loop Continue]
        goto J0x95;
    }
    return;
}

function whisperToUser()
{
    local ChatWnd chatWndScript;
    local LVDataRecord Record;

    SelectedClanList.GetSelectedRec(Record);
    // End:0x62
    if(Record.szReserved != "")
    {
        chatWndScript = ChatWnd(GetScript("ChatWnd"));
        chatWndScript.setChatEditBox(("\"" $ Record.szReserved) $ " ");
    }
    return;
}

function sendPost()
{
    local PostBoxWnd postBoxWndScript;
    local PostWriteWnd postWriteWndScript;
    local LVDataRecord Record;

    SelectedClanList.GetSelectedRec(Record);
    // End:0x96
    if(Record.szReserved != "")
    {
        postBoxWndScript = PostBoxWnd(GetScript("PostBoxWnd"));
        postWriteWndScript = PostWriteWnd(GetScript("PostWriteWnd"));
        postBoxWndScript.OnClickButton("PostSendBtn");
        postWriteWndScript.toWrite(Record.szReserved);
    }
    return;
}

function HandleClanInfo(string a_Param)
{
    local string clanMasterName, ClanName, allianceName, baseName, hallName;

    local int crestID, SkillLevel, castleID, agitType, AgitID, fotressID,
	    Status, bGuilty, allianceID, AllianceCrestID, bInWar,
	    clanType, clanRank, clanNameValue, clanID;

    local UserInfo Player;
    local Texture myAlianceCrest, myClanCrest;

    ParseInt(a_Param, "ClanID", clanID);
    ParseInt(a_Param, "ClanType", clanType);
    ParseString(a_Param, "ClanName", ClanName);
    ParseString(a_Param, "ClanMasterName", clanMasterName);
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
    hallName = "-";
    baseName = "-";
    // End:0x21C
    if(AgitID > 0)
    {
        hallName = getInstanceL2Util().getCastleNameEx(AgitID);
    }
    // End:0x245
    if(castleID > 0)
    {
        baseName = getInstanceL2Util().getCastleNameEx(castleID);        
    }
    else
    {
        // End:0x26B
        if(fotressID > 0)
        {
            baseName = getInstanceL2Util().getCastleNameEx(fotressID);
        }
    }
    Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(clanID, myClanCrest);
    Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(allianceID, myAlianceCrest);
    MyAllyCrestTx.SetTextureWithObject(myAlianceCrest);
    MyClanCrestTx.SetTextureWithObject(myClanCrest);
    ClanName = Class'NWindow.UIDATA_CLAN'.static.GetName(clanID);
    MyClanNameTxt.SetText(ClanName);
    MyAllyNameTxt.SetText(allianceName);
    MyHallNameTxt.SetText(hallName);
    MyBaseNameTxt.SetText(baseName);
    MyClanLvTx.SetTexture("L2UI_CT1.ShortcutWnd.ShortcutWnd_DF_Number_f" $ getInstanceL2Util().makeZeroString(2, (SkillLevel)));
    return;
}

function handleMyClanInfo(string param)
{
    local LVDataRecord Record;
    local string clanDecription, requestorsStr, extraStr;
    local array<string> Socials, requestorsData, requestorData;
    local int i, nClanCount, nKnighthood, nFriendshipType, nInviteType;

    local sRequestor requestor;
    local bool bIsAcademy;

    getMyClanInfo();
    ParseInt(param, "ask", nFriendshipType);
    ParseInt(param, "reply", nInviteType);
    ParseInt(param, "param1", nKnighthood);
    ParseInt(param, "param2", nClanCount);
    ParseString(param, "param3", clanDecription);
    ParseString(param, "param5", extraStr);
    ParseString(param, "param6", requestorsStr);
    currMyFriendshipType = nFriendshipType;
    currMyInviteType = nInviteType;
    InviteRequestList.DeleteAllItem();
    InviteRequestAcademyList.DeleteAllItem();
    MyClanNumTxt.SetText(string(nClanCount));
    MyFriendshipTypeTxt.SetText(getFriendShipTypeString(byte(nFriendshipType)));
    MyRequestTypeTxt.SetText(getInviteTypeString(byte(nInviteType)));
    initSelector();
    initKnighthood(nKnighthood);
    toggleRequestorAboutLock(true);
    // End:0x184
    if(currMyKnighthoodType == -1)
    {
        MyClanInfoMEdit.SetString(clanDecription);
        AcademyPriceEBox.SetString(MakeCostString(extraStr));        
    }
    else
    {
        MyClanInfoMEdit.SetString(clanDecription);
        Socials = Arr(extraStr, ",");
        TelegramEBox.SetString(Socials[0]);
        DiscordEBox.SetString(Socials[1]);
    }
    requestorsData = Arr(requestorsStr, ";");
    requestorsList.Remove(0, requestorsList.Length);
    i = 0;
    J0x200:

    // End:0x2BE [Loop If]
    if(i < requestorsData.Length)
    {
        requestorData = Arr(requestorsData[i], ",");
        // End:0x239
        if(requestorData.Length <= 0)
        {
            // [Explicit Continue]
            goto J0x2B4;
        }
        requestor.Name = requestorData[0];
        requestor.objId = int(requestorData[1]);
        requestor.ClassID = int(requestorData[2]);
        requestor.Level = int(requestorData[3]);
        requestor.bIsAcademyRequest = requestorData[4] == "1";
        requestorsList[requestorsList.Length] = requestor;
        J0x2B4:

        i++;
        // [Loop Continue]
        goto J0x200;
    }
    // End:0x2DD
    if(requestorsList.Length >= 50)
    {
        MyClanPenaltyBtn.ShowWindow();        
    }
    else
    {
        MyClanPenaltyBtn.HideWindow();
    }
    Record.LVDataList.Length = 15;
    i = 0;
    J0x301:

    // End:0x481 [Loop If]
    if(i < requestorsList.Length)
    {
        Record.nReserved1 = (requestorsList[i].objId);
        Record.LVDataList[0].szData = requestorsList[i].Name;
        Record.LVDataList[1].szData = string(requestorsList[i].Level);
        Record.LVDataList[1].szTexture = GetClassRoleIconName(requestorsList[i].ClassID);
        Record.LVDataList[1].HiddenStringForSorting = string(requestorsList[i].ClassID);
        Record.LVDataList[1].nTextureWidth = 11;
        Record.LVDataList[1].nTextureHeight = 11;
        Record.LVDataList[1].textAlignment = 2;
        Record.LVDataList[2].szData = string(requestorsList[i].Level);
        Record.LVDataList[2].textAlignment = 2;
        // End:0x463
        if(!requestorsList[i].bIsAcademyRequest)
        {
            InviteRequestList.InsertRecord(Record);
            // [Explicit Continue]
            goto J0x477;
        }
        InviteRequestAcademyList.InsertRecord(Record);
        J0x477:

        i++;
        // [Loop Continue]
        goto J0x301;
    }
    changeWindowState(2);
    return;
}

function handleMyClanInfoRequestorAbout(string param)
{
    local string requestorAbout;

    ParseString(param, "param1", requestorAbout);
    toggleRequestorAboutLock(false);
    RequestorClanInfoLEdit.AddString(requestorAbout);
    return;
}

function OnSetFocus(WindowHandle Handle, bool bFocused)
{
    // End:0x39
    if(Handle == ClanInfoMEdit)
    {
        Me.KillTimer(1001);
        Me.SetTimer(1001, 10);
    }
    // End:0x62
    if(Handle == SortListContainer)
    {
        // End:0x62
        if(!bFocused)
        {
            Handle.SetFocus();
        }
    }
    // End:0x8B
    if(Handle == SortAcademyListContainer)
    {
        // End:0x8B
        if(!bFocused)
        {
            Handle.SetFocus();
        }
    }
    return;
}

function toggleDetailSkillList(bool bOpen)
{
    // End:0x65
    if(bOpen)
    {
        ClanInfoDetailLockWnd.ShowWindow();
        ClanListDetailSkillWnd.ShowWindow();
        ClanInfoDetailLockWnd.SetAlpha(255, 0.1000000);
        ClanListDetailSkillWnd.SetAlpha(255, 0.1500000);
        ClanSkillList.SetFocus();        
    }
    else
    {
        ClanInfoDetailLockWnd.HideWindow();
        ClanListDetailSkillWnd.HideWindow();
        ClanInfoDetailLockWnd.SetAlpha(0);
        ClanListDetailSkillWnd.SetAlpha(0);
    }
    return;
}

function toggleHeadTab(ClanSearchAPI.eWindowState State)
{
    HeadTab00Btn.SetTexture("L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Unselected", "L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Unselected", "L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Unselected_Over");
    HeadTab01Btn.SetTexture("L2UI_EPIC.ClanWnd.ClanWnd.ClanWnd_Tab_Right_Unselected", "L2UI_EPIC.ClanWnd.ClanWnd.ClanWnd_Tab_Right_Unselected", "L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Unselected_Over");
    HeadTab02Btn.SetTexture("L2UI_EPIC.ClanWnd.ClanWnd.ClanWnd_Tab_Right_Unselected", "L2UI_EPIC.ClanWnd.ClanWnd.ClanWnd_Tab_Right_Unselected", "L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Unselected_Over");
    HeadTab00Txt.SetTextColor(GetColor(125, 125, 125, 255));
    HeadTab01Txt.SetTextColor(GetColor(125, 125, 125, 255));
    HeadTab02Txt.SetTextColor(GetColor(125, 125, 125, 255));
    HeadTab00Tx.SetAlpha(180, 0.1500000);
    HeadTab01Tx.SetAlpha(180, 0.1500000);
    HeadTab02Tx.SetAlpha(180, 0.1500000);
    // End:0x381
    if(int(State) == 0)
    {
        HeadTab00Btn.SetTexture("L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Selected", "L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Selected", "L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Selected_Over");
        HeadTab00Txt.SetTextColor(GetColor(255, 255, 255, 255));
        HeadTab00Tx.SetAlpha(255);        
    }
    else
    {
        // End:0x45D
        if(int(State) == 1)
        {
            HeadTab01Btn.SetTexture("L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Selected", "L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Selected", "L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Selected_Over");
            HeadTab01Txt.SetTextColor(GetColor(255, 255, 255, 255));
            HeadTab01Tx.SetAlpha(255);            
        }
        else
        {
            // End:0x537
            if(int(State) == 2)
            {
                HeadTab02Btn.SetTexture("L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Selected", "L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Selected", "L2UI_EPIC.ClanWnd.ClanWnd_Tab_Right_Selected_Over");
                HeadTab02Txt.SetTextColor(GetColor(255, 255, 255, 255));
                HeadTab02Tx.SetAlpha(255);
            }
        }
    }
    return;
}

function toggleMyClanState()
{
    local ClanSearchAPI.eMyListState targetState;

    // End:0x3F
    if(currMyKnighthoodType == -1)
    {
        // End:0x2D
        if(getIsMyClan(ClanListInfo.nAskJoinRequestAcademyId))
        {
            targetState = 1;            
        }
        else
        {
            targetState = 0;
        }
        changeMyClanView(false);        
    }
    else
    {
        // End:0x5D
        if(getIsMyClan(ClanListInfo.nAskJoinRequestClanId))
        {
            targetState = 1;            
        }
        else
        {
            targetState = 0;
        }
        changeMyClanView(true);
    }
    // End:0x1AE
    if(int(targetState) == 0)
    {
        MyClanAddClanBtn.SetButtonName(8023);
        MyClanResetChangesBtn.SetButtonName(479);
        MyClanAddClanBtn.SetTexture("L2UI_NewTex.RelicWnd.Button36Yellow_DF", "L2UI_NewTex.RelicWnd.Button36Yellow_Down", "L2UI_NewTex.RelicWnd.Button36Yellow_Over");
        MyClanResetChangesBtn.SetTexture("L2UI_NewTex.Button.Button36_DF", "L2UI_NewTex.Button.Button36_Down", "L2UI_NewTex.Button.Button36_Over");
        ClanSearchRequestorDrawerWnd.HideWindow();
    }
    // End:0x305
    if(int(targetState) == 1)
    {
        MyClanAddClanBtn.SetButtonName(8024);
        MyClanResetChangesBtn.SetButtonName(8025);
        MyClanAddClanBtn.SetTexture("L2UI_NewTex.RelicWnd.Button29Green_DF", "L2UI_NewTex.RelicWnd.Button29Green_DF_Down", "L2UI_NewTex.RelicWnd.Button29Green_DF_Over");
        MyClanResetChangesBtn.SetTexture("L2UI_NewTex.Button.Button29red2_DF", "L2UI_NewTex.Button.Button29red2_DF_Down", "L2UI_NewTex.Button.Button29red2_DF_Over");
        ClanSearchRequestorDrawerWnd.ShowWindow();
    }
    MyClanAddClanBtn.SetButtonValue(int(targetState));
    MyClanResetChangesBtn.SetButtonValue(int(targetState));
    return;
}

function changeMyClanView(bool bClanInviteView)
{
    // End:0x6E0
    if(bClanInviteView)
    {
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanClanInviteTypeIcoTx").SetAnchor("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer", "TopRight", "TopRight", -15, 5);
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanInfoBg").SetAnchor("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer", "BottomCenter", "BottomCenter", 0, -150);
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanClanTypeIcoTx").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanClanTypeIcoTx").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanClanTypeIcoTxt").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.ClanTypeSelectorWnd").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanSocialBg").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MySocialHeaderTxt").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanSocialDivTx").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.TelegramEBoxTxt").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.TelegramEBox").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.DiscordEBoxTxt").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.DiscordEBox").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.AcademyPriceBg").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.AcademyPriceEBoxTxt").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.AcademyPriceEBox").HideWindow();        
    }
    else
    {
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanClanInviteTypeIcoTx").SetAnchor("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer", "TopCenter", "TopCenter", 80, 50);
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanInfoBg").SetAnchor("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer", "BottomCenter", "BottomCenter", 0, -105);
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanClanTypeIcoTx").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanClanTypeIcoTxt").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.ClanTypeSelectorWnd").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanSocialBg").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MySocialHeaderTxt").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.MyClanSocialDivTx").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.TelegramEBoxTxt").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.TelegramEBox").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.DiscordEBoxTxt").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.DiscordEBox").HideWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.AcademyPriceBg").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.AcademyPriceEBoxTxt").ShowWindow();
        GetWindowHandle("ClanSearchWnd.ClanListMyClanContainer.MyClanStettingsContainer.AcademyPriceEBox").ShowWindow();
    }
    return;
}

function toggleRequestorAboutLock(bool bLock)
{
    RequestorClanInfoLEdit.Clear();
    // End:0x48
    if(bLock)
    {
        RequestMEditLockWnd.ShowWindow();
        MyInviteAddBtn.DisableWindow();
        MyInviteCancelBtn.DisableWindow();        
    }
    else
    {
        RequestMEditLockWnd.HideWindow();
        MyInviteAddBtn.EnableWindow();
        MyInviteCancelBtn.EnableWindow();
    }
    return;
}

function setDetailClanCrest(int ServerID, int cIconId, int aIconId)
{
    local Texture texPledge, texAlliance;

    // End:0x69
    if(cIconId > 0)
    {
        texPledge = GetTexture((("Crest.pledge_crest_" $ string(ServerID)) $ "_") $ string(cIconId));
        ClanDetailClanCrestTx.SetTextureWithObject(texPledge);
        ClanDetailClanCrestTx.ShowWindow();        
    }
    else
    {
        ClanDetailClanCrestTx.HideWindow();
    }
    // End:0xDF
    if(aIconId > 0)
    {
        texAlliance = GetTexture((("Crest.ally_crest_" $ string(ServerID)) $ "_") $ string(aIconId));
        ClanDetailAllyCrestTx.SetTextureWithObject(texAlliance);
        ClanDetailAllyCrestTx.ShowWindow();        
    }
    else
    {
        ClanDetailAllyCrestTx.HideWindow();
    }
    return;
}

function toggleClanListDetailWindow(bool bShow)
{
    local bool bIsRequestCancel, bIsMyClanRequest;
    local Color Blue, Red, DarkYellow;
    local string askJoinDescription;

    Blue.R = 126;
    Blue.G = 158;
    Blue.B = 245;
    Red.R = 200;
    Red.G = 50;
    Red.B = 80;
    DarkYellow.R = 175;
    DarkYellow.G = 152;
    DarkYellow.B = 120;
    // End:0xC9
    if(currentSelectedTab == 0)
    {
        bIsRequestCancel = ClanListInfo.nAskJoinRequestClanId == targetListClanData.clanID;
        bIsMyClanRequest = (getCurrentName()) == targetListClanData.LeaderName;
        askJoinDescription = ClanListDetailInfo.Description;        
    }
    else
    {
        // End:0x11A
        if(currentSelectedTab == 1)
        {
            bIsRequestCancel = ClanListInfo.nAskJoinRequestAcademyId == targetListAcademyData.clanID;
            bIsMyClanRequest = (getCurrentName()) == targetListAcademyData.LeaderName;
            askJoinDescription = ClanListDetailInfo.Description;
        }
    }
    // End:0x6E1
    if(bShow)
    {
        initDetailTab();
        // End:0x165
        if(bIsRequestCancel)
        {
            // End:0x146
            if(bIsMyClanRequest)
            {
                changeDetailWindowState(3);                
            }
            else
            {
                changeDetailWindowState(2);
            }
            ClanInfoMEdit.SetString(askJoinDescription);            
        }
        else
        {
            changeDetailWindowState(0);
            ClanInfoMEdit.SetString(askJoinDescription);
        }
        RequestJoinBtn.EnableWindow();
        InviteYourClanNotifyTxt.HideWindow();
        // End:0x1C6
        if(bIsMyClanRequest)
        {
            RequestJoinBtn.DisableWindow();
            InviteYourClanNotifyTxt.ShowWindow();
        }
        // End:0x2BE
        if(currentSelectedTab == 0)
        {
            ClanListDetailNameTxt.SetText(targetListClanData.ClanName);
            ClanListDetailLeaderTxt.SetText(targetListClanData.LeaderName);
            ClanListDetailLvTxt.SetText(string(targetListClanData.Level));
            ClanListDetailNumTxt.SetText(MakeCostString(string(targetListClanData.Count)));
            setDetailClanCrest(targetListClanData.ServerID, targetListClanData.cIconId, targetListClanData.aIconId);
            FriendshipDetailTypeHeadTxt.SetText(GetSystemString(8008));
            ClanListFriendshipDetailTypeTxt.SetText(getFriendShipTypeString(targetListClanData.clanType));
            ClanListInviteDetailTypeTxt.SetText(getInviteTypeString(targetListClanData.clanRequestType));            
        }
        else
        {
            // End:0x3C0
            if(currentSelectedTab == 1)
            {
                ClanListDetailNameTxt.SetText(targetListAcademyData.ClanName);
                ClanListDetailLeaderTxt.SetText(targetListAcademyData.LeaderName);
                ClanListDetailLvTxt.SetText(string(targetListAcademyData.Level));
                ClanListDetailNumTxt.SetText(MakeCostString(string(targetListAcademyData.Count)));
                setDetailClanCrest(targetListAcademyData.ServerID, targetListAcademyData.cIconId, targetListAcademyData.aIconId);
                FriendshipDetailTypeHeadTxt.SetText(GetSystemString(3202));
                ClanListFriendshipDetailTypeTxt.SetText(MakeCostStringINT64(targetListAcademyData.academyPrice) @ GetSystemString(469));
                ClanListInviteDetailTypeTxt.SetText(getInviteTypeString(targetListAcademyData.clanRequestType));
            }
        }
        // End:0x3EE
        if(ClanListDetailInfo.Position > 0)
        {
            ClanListDetailRankTxt.SetText(string(ClanListDetailInfo.Position));            
        }
        else
        {
            ClanListDetailRankTxt.SetText("-");
        }
        ClanListDetailReputationTxt.SetText(MakeCostString(string(ClanListDetailInfo.reputation)));
        // End:0x448
        if(ClanListDetailInfo.reputation == 0)
        {
            ClanListDetailReputationTxt.SetTextColor(DarkYellow);            
        }
        else
        {
            // End:0x46F
            if(ClanListDetailInfo.reputation < 0)
            {
                ClanListDetailReputationTxt.SetTextColor(Red);                
            }
            else
            {
                // End:0x493
                if(ClanListDetailInfo.reputation > 0)
                {
                    ClanListDetailReputationTxt.SetTextColor(Blue);
                }
            }
        }
        ClanListDetailAvgLevelTxt.SetText(string(ClanListDetailInfo.averageLevel));
        ClanListDetailPVPTxt.SetText(MakeCostString(string(ClanListDetailInfo.pvp)));
        ClanListDetailPKTxt.SetText(MakeCostString(string(ClanListDetailInfo.pk)));
        ClanListDetailNobleTxt.SetText(string(ClanListDetailInfo.nNobles));
        ClanListDetailHeroesTxt.SetText(string(ClanListDetailInfo.nHeroes));
        // End:0x58A
        if((ClanListDetailInfo.Socials.tg == "-") || ClanListDetailInfo.Socials.tg == "")
        {
            TGTxt.SetText("-");
            TGTxt.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(8054)));            
        }
        else
        {
            TGTxt.SetText(getShortSocial(ClanListDetailInfo.Socials.tg));
            TGTxt.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(8033)));
        }
        // End:0x632
        if((ClanListDetailInfo.Socials.ds == "-") || ClanListDetailInfo.Socials.ds == "")
        {
            DSTxt.SetText("-");
            DSTxt.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(8054)));            
        }
        else
        {
            DSTxt.SetText(getShortSocial(ClanListDetailInfo.Socials.ds));
            DSTxt.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(8032)));
        }
        SearchEBox.DisableWindow();
        ListDisableContainer.ShowWindow();
        ListDisableContainer.SetAlpha(255, 0.2500000);
        ListDisableContainer.BringToFront();
        ClanListDetailContainer.ShowWindow();
        ClanListDetailContainer.SetAlpha(255, 0.2500000);        
    }
    else
    {
        SearchEBox.EnableWindow();
        ListDisableContainer.SetAlpha(0, 0.2500000);
        ClanListDetailContainer.SetAlpha(0, 0.2500000);
        toggleDetailSkillList(false);
        ListDisableContainer.HideWindow();
        ClanListDetailContainer.HideWindow();
    }
    return;
}

function LVDataRecord getClanListRecord(sClanListData ClanData)
{
    local LVDataRecord Record;
    local string param, Name, Desc, baseName, hallName, clanOwnPlacesString;

    local int ClassID;
    local Color Color;
    local Texture texPledge, texAlliance;
    local int NameOffset, ownOffset;

    texPledge = GetTexture((("Crest.pledge_crest_" $ string(ClanData.ServerID)) $ "_") $ string(ClanData.cIconId));
    texAlliance = GetTexture((("Crest.ally_crest_" $ string(ClanData.ServerID)) $ "_") $ string(ClanData.aIconId));
    Record.LVDataList.Length = 15;
    Record.LVDataList[0].HiddenStringForSorting = string(1);
    // End:0x211
    if((ClanData.cIconId > 0) && ClanData.aIconId > 0)
    {
        Record.LVDataList[0].arrTexture.Length = 3;
        // End:0x184
        if((ClanData.baseId > 0) || ClanData.hallId > 0)
        {
            Record = getLvTexture(texAlliance, Record, 0, 3, -6, 8, 12, 0, 4);
            Record = getLvTexture(texPledge, Record, 1, 11, -6, 16, 12, 0, 4);
            Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 2, 0, -6, 2, 12, 0, 4);            
        }
        else
        {
            Record = getLvTexture(texAlliance, Record, 0, 3, 0, 8, 12, 0, 4);
            Record = getLvTexture(texPledge, Record, 1, 11, 0, 16, 12, 0, 4);
            Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 2, 0, 0, 2, 12, 0, 4);
        }
        NameOffset = 30;
        ownOffset = -25;        
    }
    else
    {
        // End:0x323
        if(ClanData.aIconId > 0)
        {
            Record.LVDataList[0].arrTexture.Length = 2;
            // End:0x2B8
            if((ClanData.baseId > 0) || ClanData.hallId > 0)
            {
                Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 1, 0, -6, 2, 12, 0, 4);
                Record = getLvTexture(texAlliance, Record, 0, 3, -6, 8, 12, 0, 4);                
            }
            else
            {
                Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 1, 0, 0, 2, 12, 0, 4);
                Record = getLvTexture(texAlliance, Record, 0, 3, 0, 8, 12, 0, 4);
            }
            NameOffset = 15;
            ownOffset = -10;            
        }
        else
        {
            // End:0x435
            if(ClanData.cIconId > 0)
            {
                Record.LVDataList[0].arrTexture.Length = 2;
                // End:0x3CA
                if((ClanData.baseId > 0) || ClanData.hallId > 0)
                {
                    Record = getLvTexture(texPledge, Record, 0, 3, -6, 16, 12, 0, 4);
                    Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 1, 0, -6, 2, 12, 0, 4);                    
                }
                else
                {
                    Record = getLvTexture(texPledge, Record, 0, 3, 0, 16, 12, 0, 4);
                    Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 1, 0, 0, 2, 12, 0, 4);
                }
                NameOffset = 22;
                ownOffset = -17;                
            }
            else
            {
                Record.LVDataList[0].arrTexture.Length = 1;
                Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 0, 0, -6, 6, 12, 0, 4);
                NameOffset = 2;
                ownOffset = 1;
            }
        }
    }
    Record.LVDataList[0].FirstLineOffsetX = NameOffset;
    Record.LVDataList[0].szData = ClanData.ClanName;
    baseName = getInstanceL2Util().getCastleNameEx(ClanData.baseId);
    hallName = getInstanceL2Util().getCastleNameEx(ClanData.hallId);
    clanOwnPlacesString = "";
    // End:0x522
    if(baseName != "")
    {
        clanOwnPlacesString = baseName;
    }
    // End:0x56C
    if(hallName != "")
    {
        // End:0x554
        if(clanOwnPlacesString != "")
        {
            clanOwnPlacesString = (clanOwnPlacesString @ "/") @ hallName;            
        }
        else
        {
            clanOwnPlacesString = GetSystemString(8022) @ hallName;
        }
    }
    Record.nReserved1 = (ClanData.clanID);
    Record.LVDataList[0].hasIcon = true;
    Record.LVDataList[0].AttrIconTexArray.Length = 1;
    Record.LVDataList[0].AttrIconTexArray[0].X = ownOffset;
    Record.LVDataList[0].AttrIconTexArray[0].Y = 2;
    Record.LVDataList[0].AttrIconTexArray[0].Width = 0;
    Record.LVDataList[0].AttrIconTexArray[0].Height = 0;
    Record.LVDataList[0].AttrIconTexArray[0].U = 0;
    Record.LVDataList[0].AttrIconTexArray[0].V = 0;
    Record.LVDataList[0].AttrIconTexArray[0].UL = 0;
    Record.LVDataList[0].AttrIconTexArray[0].VL = 0;
    Record.LVDataList[0].AttrIconTexArray[0].objTex = GetTexture("");
    Record.LVDataList[0].AttrColor = GetColor(175, 152, 120, 255);
    Record.LVDataList[0].AttrStat[0] = clanOwnPlacesString;
    Record.LVDataList[1].szData = ClanData.LeaderName;
    Record.LVDataList[1].HiddenStringForSorting = ClanData.LeaderName;
    Record.LVDataList[1].textAlignment = 2;
    Record.LVDataList[2].szData = string(ClanData.Level);
    Record.LVDataList[2].HiddenStringForSorting = string(ClanData.Level);
    Record.LVDataList[2].textAlignment = 2;
    Record.LVDataList[3].szData = GetClanTypeNameFromIndex(ClanData.knighthood);
    Record.LVDataList[3].HiddenStringForSorting = GetClanTypeNameFromIndex(ClanData.knighthood);
    Record.LVDataList[3].textAlignment = 2;
    Record.LVDataList[4].szData = string(ClanData.Count);
    Record.LVDataList[4].HiddenStringForSorting = string(ClanData.Count);
    Record.LVDataList[4].textAlignment = 2;
    Record.LVDataList[5].bUseTextColor = true;
    Record.LVDataList[5].HiddenStringForSorting = string(ClanData.clanType);
    Record.LVDataList[5].TextColor = GetFriendshipTypeColor(ClanData.clanType);
    Record.LVDataList[5].szData = getFriendShipTypeString(ClanData.clanType);
    Record.LVDataList[5].textAlignment = 2;
    Record.LVDataList[6].bUseTextColor = true;
    Record.LVDataList[6].HiddenStringForSorting = string(ClanData.clanRequestType);
    Record.LVDataList[6].TextColor = GetInviteTypeColor(ClanData.clanRequestType);
    Record.LVDataList[6].szData = getInviteTypeString(ClanData.clanRequestType);
    Record.LVDataList[6].textAlignment = 2;
    return Record;
    return;
}

function LVDataRecord getAcademyListRecord(sAcademyListData ClanData)
{
    local LVDataRecord Record;
    local string param, Name, Desc, baseName, hallName, clanOwnPlacesString;

    local int ClassID;
    local Color Color;
    local Texture texPledge, texAlliance;
    local int NameOffset, ownOffset;

    texPledge = GetTexture((("Crest.pledge_crest_" $ string(ClanData.ServerID)) $ "_") $ string(ClanData.cIconId));
    texAlliance = GetTexture((("Crest.ally_crest_" $ string(ClanData.ServerID)) $ "_") $ string(ClanData.aIconId));
    Record.LVDataList.Length = 15;
    Record.LVDataList[0].HiddenStringForSorting = string(1);
    // End:0x211
    if((ClanData.cIconId > 0) && ClanData.aIconId > 0)
    {
        Record.LVDataList[0].arrTexture.Length = 3;
        // End:0x184
        if((ClanData.baseId > 0) || ClanData.hallId > 0)
        {
            Record = getLvTexture(texAlliance, Record, 0, 3, -6, 8, 12, 0, 4);
            Record = getLvTexture(texPledge, Record, 1, 11, -6, 16, 12, 0, 4);
            Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 2, 0, -6, 2, 12, 0, 4);            
        }
        else
        {
            Record = getLvTexture(texAlliance, Record, 0, 3, 0, 8, 12, 0, 4);
            Record = getLvTexture(texPledge, Record, 1, 11, 0, 16, 12, 0, 4);
            Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 2, 0, 0, 2, 12, 0, 4);
        }
        NameOffset = 30;
        ownOffset = -25;        
    }
    else
    {
        // End:0x323
        if(ClanData.aIconId > 0)
        {
            Record.LVDataList[0].arrTexture.Length = 2;
            // End:0x2B8
            if((ClanData.baseId > 0) || ClanData.hallId > 0)
            {
                Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 1, 0, -6, 2, 12, 0, 4);
                Record = getLvTexture(texAlliance, Record, 0, 3, -6, 8, 12, 0, 4);                
            }
            else
            {
                Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 1, 0, 0, 2, 12, 0, 4);
                Record = getLvTexture(texAlliance, Record, 0, 3, 0, 8, 12, 0, 4);
            }
            NameOffset = 15;
            ownOffset = -10;            
        }
        else
        {
            // End:0x435
            if(ClanData.cIconId > 0)
            {
                Record.LVDataList[0].arrTexture.Length = 2;
                // End:0x3CA
                if((ClanData.baseId > 0) || ClanData.hallId > 0)
                {
                    Record = getLvTexture(texPledge, Record, 0, 3, -6, 16, 12, 0, 4);
                    Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 1, 0, -6, 2, 12, 0, 4);                    
                }
                else
                {
                    Record = getLvTexture(texPledge, Record, 0, 3, 0, 16, 12, 0, 4);
                    Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 1, 0, 0, 2, 12, 0, 4);
                }
                NameOffset = 22;
                ownOffset = -17;                
            }
            else
            {
                Record.LVDataList[0].arrTexture.Length = 1;
                Record = getLvTexture(GetTexture("L2UI_CT1.EmptyBtn"), Record, 0, 0, -6, 6, 12, 0, 4);
                NameOffset = 2;
                ownOffset = 1;
            }
        }
    }
    Record.LVDataList[0].FirstLineOffsetX = NameOffset;
    Record.LVDataList[0].szData = ClanData.ClanName;
    baseName = getInstanceL2Util().getCastleNameEx(ClanData.baseId);
    hallName = getInstanceL2Util().getCastleNameEx(ClanData.hallId);
    clanOwnPlacesString = "";
    // End:0x522
    if(baseName != "")
    {
        clanOwnPlacesString = baseName;
    }
    // End:0x56C
    if(hallName != "")
    {
        // End:0x554
        if(clanOwnPlacesString != "")
        {
            clanOwnPlacesString = (clanOwnPlacesString @ "/") @ hallName;            
        }
        else
        {
            clanOwnPlacesString = GetSystemString(8022) @ hallName;
        }
    }
    Record.nReserved1 = (ClanData.clanID);
    Record.LVDataList[0].hasIcon = true;
    Record.LVDataList[0].AttrIconTexArray.Length = 1;
    Record.LVDataList[0].AttrIconTexArray[0].X = ownOffset;
    Record.LVDataList[0].AttrIconTexArray[0].Y = 2;
    Record.LVDataList[0].AttrIconTexArray[0].Width = 0;
    Record.LVDataList[0].AttrIconTexArray[0].Height = 0;
    Record.LVDataList[0].AttrIconTexArray[0].U = 0;
    Record.LVDataList[0].AttrIconTexArray[0].V = 0;
    Record.LVDataList[0].AttrIconTexArray[0].UL = 0;
    Record.LVDataList[0].AttrIconTexArray[0].VL = 0;
    Record.LVDataList[0].AttrIconTexArray[0].objTex = GetTexture("");
    Record.LVDataList[0].AttrColor = GetColor(175, 152, 120, 255);
    Record.LVDataList[0].AttrStat[0] = clanOwnPlacesString;
    Record.LVDataList[1].szData = ClanData.LeaderName;
    Record.LVDataList[1].HiddenStringForSorting = ClanData.LeaderName;
    Record.LVDataList[1].textAlignment = 2;
    Record.LVDataList[2].szData = string(ClanData.Level);
    Record.LVDataList[2].HiddenStringForSorting = string(ClanData.Level);
    Record.LVDataList[2].textAlignment = 2;
    Record.LVDataList[3].szData = GetSystemString(1419);
    Record.LVDataList[3].HiddenStringForSorting = GetSystemString(1419);
    Record.LVDataList[3].textAlignment = 2;
    Record.LVDataList[4].szData = string(ClanData.Count);
    Record.LVDataList[4].HiddenStringForSorting = string(ClanData.Count);
    Record.LVDataList[4].textAlignment = 2;
    Record.LVDataList[5].bUseTextColor = true;
    Record.LVDataList[5].HiddenStringForSorting = string(ClanData.clanRequestType);
    Record.LVDataList[5].TextColor = GetInviteTypeColor(ClanData.clanRequestType);
    Record.LVDataList[5].szData = getInviteTypeString(ClanData.clanRequestType);
    Record.LVDataList[5].textAlignment = 2;
    Record.LVDataList[6].bUseTextColor = true;
    Record.LVDataList[6].szData = MakeCostStringINT64(ClanData.academyPrice);
    Record.LVDataList[6].TextColor = GetColor(255, 215, 15, 255);
    Record.LVDataList[6].HiddenStringForSorting = (ClanData.academyPrice);
    Record.LVDataList[6].textAlignment = 2;
    return Record;
    return;
}

function LVDataRecord getClanWarListRecord(sClanWarListData ClanWarListData)
{
    local LVDataRecord Record;
    local int page;
    local string sClanName;
    local int progressTimeInSec;
    local Color colorValue;
    local int totalWarSec, point, pointDiff, leftKillCountOfEnemyToWar, KillCountOfEnemyToWar;

    local ClanDrawerWnd ClanDrawer;

    ClanDrawer = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
    sClanName = ClanWarListData.ClanName;
    progressTimeInSec = ClanWarListData.progressTimeInSec;
    point = ClanWarListData.point;
    pointDiff = ClanWarListData.pointDiff;
    leftKillCountOfEnemyToWar = ClanWarListData.leftKillCountOfEnemyToWar;
    colorValue.R = 220;
    colorValue.G = 220;
    colorValue.B = 220;
    Record.LVDataList.Length = 7;
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[0].szData = sClanName;
    Record.LVDataList[0].TextColor = colorValue;
    Record.LVDataList[1].bUseTextColor = true;
    Record.LVDataList[1].szData = ClanDrawer.getWarStateString(ClanWarListData.State);
    Record.LVDataList[1].TextColor = colorValue;
    Record.LVDataList[1].nReserved1 = ClanWarListData.State;
    Record.LVDataList[2].nReserved1 = ClanDrawer.getWarType(point);
    Record.LVDataList[2].szData = "";
    Record.LVDataList[2].szTexture = ClanDrawer.getWarSituationTextureNew(ClanWarListData.State);
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
    return Record;
    return;
}

function initSelector()
{
    UpdateFriendshipType(byte(currMyFriendshipType));
    UpdateInviteType(byte(currMyInviteType));
    UpdateKnighthoodType(currMyKnighthoodType);
    UpdateKnighthoodType_FromArray();
    CheckButtonState(byte(currMyFriendshipType), byte(currMyInviteType), currMyKnighthoodType);
    return;
}

function CheckButtonState(ClanSearchAPI.eClanSearchFriendshipType t1, ClanSearchAPI.eClanRequestType t2, int t3)
{
    ClanTypeLeftBtn.EnableWindow();
    ClanTypeRightBtn.EnableWindow();
    InviteTypeLeftBtn.EnableWindow();
    InviteTypeRightBtn.EnableWindow();
    KnighthoodLeftBtn.EnableWindow();
    KnighthoodRightBtn.EnableWindow();
    // End:0x76
    if(int(t1) <= 0)
    {
        ClanTypeLeftBtn.DisableWindow();
    }
    // End:0x96
    if(int(t1) >= (4 - 1))
    {
        ClanTypeRightBtn.DisableWindow();
    }
    // End:0xB2
    if(int(t2) <= 0)
    {
        InviteTypeLeftBtn.DisableWindow();
    }
    // End:0xD2
    if(int(t2) >= (2 - 1))
    {
        InviteTypeRightBtn.DisableWindow();
    }
    // End:0xFF
    if(AvailableKnighthoodIDs.Length <= 1)
    {
        KnighthoodLeftBtn.DisableWindow();
        KnighthoodRightBtn.DisableWindow();        
    }
    else
    {
        // End:0x119
        if(currKnighthoodIndex <= 0)
        {
            KnighthoodLeftBtn.DisableWindow();
        }
        // End:0x13B
        if(currKnighthoodIndex >= (AvailableKnighthoodIDs.Length - 1))
        {
            KnighthoodRightBtn.DisableWindow();
        }
    }
    return;
}

function SwitchClanFriendshipType(bool bIncrement)
{
    // End:0x13
    if(bIncrement)
    {
        currMyFriendshipType++;        
    }
    else
    {
        currMyFriendshipType--;
    }
    currMyFriendshipType = CheckFriendshipType(currMyFriendshipType);
    UpdateFriendshipType(byte(currMyFriendshipType));
    return;
}

function SwitchClanInviteType(bool bIncrement)
{
    // End:0x13
    if(bIncrement)
    {
        currMyInviteType++;        
    }
    else
    {
        currMyInviteType--;
    }
    currMyInviteType = CheckInviteType(currMyInviteType);
    UpdateInviteType(byte(currMyInviteType));
    return;
}

function SwitchKnighthoodType(bool bIncrement)
{
    // End:0x0E
    if(AvailableKnighthoodIDs.Length <= 1)
    {
        return;
    }
    // End:0x21
    if(bIncrement)
    {
        currKnighthoodIndex++;        
    }
    else
    {
        currKnighthoodIndex--;
    }
    // End:0x45
    if(currKnighthoodIndex < 0)
    {
        currKnighthoodIndex = AvailableKnighthoodIDs.Length - 1;        
    }
    else
    {
        // End:0x5C
        if(currKnighthoodIndex >= AvailableKnighthoodIDs.Length)
        {
            currKnighthoodIndex = 0;
        }
    }
    currMyKnighthoodType = AvailableKnighthoodIDs[currKnighthoodIndex];
    UpdateKnighthoodType_FromArray();
    CheckButtonState(byte(currMyFriendshipType), byte(currMyInviteType), currMyKnighthoodType);
    toggleMyClanState();
    return;
}

function int CheckFriendshipType(int Type)
{
    // End:0x12
    if(Type <= 0)
    {
        Type = 0;
    }
    // End:0x29
    if(Type >= 4)
    {
        Type = 4 - 1;
    }
    return Type;
    return;
}

function int CheckInviteType(int Type)
{
    // End:0x12
    if(Type <= 0)
    {
        Type = 0;
    }
    // End:0x29
    if(Type >= 2)
    {
        Type = 2 - 1;
    }
    return Type;
    return;
}

function int CheckKnighthoodType(int Type)
{
    // End:0x12
    if(Type <= 0)
    {
        Type = 0;
    }
    // End:0x26
    if(Type >= 8)
    {
        Type = 8;
    }
    return Type;
    return;
}

function UpdateFriendshipType(ClanSearchAPI.eClanSearchFriendshipType Type)
{
    ClanTypeNameTxt.SetText(getFriendShipTypeString(Type));
    ClanTypeNameTxt.SetTextColor(GetFriendshipTypeColor(Type));
    ClanTypeNameTxt.SetAlpha(25);
    ClanTypeNameTxt.SetAlpha(255, 0.2500000);
    CheckButtonState(byte(currMyFriendshipType), byte(currMyInviteType), currMyKnighthoodType);
    return;
}

function UpdateInviteType(ClanSearchAPI.eClanRequestType Type)
{
    InviteTypeNameTxt.SetText(getInviteTypeString(Type));
    InviteTypeNameTxt.SetTextColor(GetInviteTypeColor(Type));
    InviteTypeNameTxt.SetAlpha(25);
    InviteTypeNameTxt.SetAlpha(255, 0.2500000);
    // End:0xAD
    if(int(Type) == 1)
    {
        MyClanClanInviteTypeIcoTx.SetTexture("L2UI_NewTex.MenuWnd.MainMenu_Icon_PersonalConnection");
    }
    // End:0xF5
    if(int(Type) == 0)
    {
        MyClanClanInviteTypeIcoTx.SetTexture("L2UI_NewTex.MenuWnd.MainMenu_Icon_Bbs_Down");
    }
    CheckButtonState(byte(currMyFriendshipType), byte(currMyInviteType), currMyKnighthoodType);
    return;
}

function UpdateKnighthoodType(int Type)
{
    KnighthoodNameTxt.SetText(GetClanTypeNameFromIndex(Type));
    KnighthoodNameTxt.SetAlpha(25);
    KnighthoodNameTxt.SetAlpha(255, 0.2500000);
    CheckButtonState(byte(currMyFriendshipType), byte(currMyInviteType), currMyKnighthoodType);
    return;
}

function UpdateKnighthoodType_FromArray()
{
    local string DisplayName;
    local int CurrentID;

    // End:0x20
    if(AvailableKnighthoodIDs.Length == 0)
    {
        KnighthoodNameTxt.SetText("");        
    }
    else
    {
        CurrentID = AvailableKnighthoodIDs[currKnighthoodIndex];
        DisplayName = GetClanTypeNameFromIndex(CurrentID);
        DisplayName = (DisplayName @ "-") @ (GetKnighthoodLeaderName(CurrentID));
        KnighthoodNameTxt.SetText(DisplayName);
    }
    KnighthoodNameTxt.SetAlpha(25);
    KnighthoodNameTxt.SetAlpha(255, 0.2500000);
    return;
}

function string GetKnighthoodLeaderName(int knighthoodID)
{
    local int i;
    local ClanWnd ClanWnd;

    ClanWnd = ClanWnd(GetScript("ClanWnd"));
    i = 0;
    J0x21:

    // End:0xA9 [Loop If]
    if(i < 8)
    {
        // End:0x9F
        if((ClanWnd.m_memberList[i].m_sName != "") && InviteClanPopWnd(GetScript("InviteClanPopWnd")).m_knighthoodIndex[i] == knighthoodID)
        {
            return ClanWnd.m_memberList[i].m_sName;
        }
        ++i;
        // [Loop Continue]
        goto J0x21;
    }
    return "";
    return;
}

function initKnighthood(int nKnighthood)
{
    local int i;
    local ClanWnd ClanWnd;
    local InviteClanPopWnd InviteClanPopWnd;
    local string countnum, countnum2, m_sName;
    local int cnt1, cnt2;

    ClanWnd = ClanWnd(GetScript("ClanWnd"));
    InviteClanPopWnd = InviteClanPopWnd(GetScript("InviteClanPopWnd"));
    AvailableKnighthoodIDs.Length = 0;
    countnum2 = "" $ string(ClanWnd.m_myClanType);
    cnt1 = Len(countnum2);
    i = 0;
    J0x73:

    // End:0x131 [Loop If]
    if(i < 8)
    {
        m_sName = ClanWnd.m_memberList[i].m_sName;
        countnum = "" $ string(InviteClanPopWnd.m_knighthoodIndex[i]);
        cnt2 = Len(countnum);
        // End:0x127
        if(m_sName != "")
        {
            // End:0x127
            if((InviteClanPopWnd.m_knighthoodIndex[i] == -1) || cnt1 <= cnt2)
            {
                AvailableKnighthoodIDs[AvailableKnighthoodIDs.Length] = InviteClanPopWnd.m_knighthoodIndex[i];
            }
        }
        ++i;
        // [Loop Continue]
        goto J0x73;
    }
    FindAndSetCurrentKnighthood(nKnighthood);
    UpdateKnighthoodType_FromArray();
    CheckButtonState(byte(currMyFriendshipType), byte(currMyInviteType), 0);
    return;
}

function FindAndSetCurrentKnighthood(int desiredID)
{
    local int i;

    currKnighthoodIndex = 0;
    // End:0x1C
    if(AvailableKnighthoodIDs.Length == 0)
    {
        currMyKnighthoodType = 0;
        return;
    }
    i = 0;
    J0x23:

    // End:0x6A [Loop If]
    if(i < AvailableKnighthoodIDs.Length)
    {
        // End:0x60
        if(AvailableKnighthoodIDs[i] == desiredID)
        {
            currKnighthoodIndex = i;
            currMyKnighthoodType = desiredID;
            return;
        }
        ++i;
        // [Loop Continue]
        goto J0x23;
    }
    currKnighthoodIndex = 0;
    currMyKnighthoodType = AvailableKnighthoodIDs[0];
    return;
}

function bool isFreeInvite()
{
    // End:0x1B
    if(currentSelectedTab == 0)
    {
        return int(targetListClanData.clanRequestType) == 1;
    }
    // End:0x36
    if(currentSelectedTab == 1)
    {
        return int(targetListAcademyData.clanRequestType) == 1;
    }
    return;
}

function int getFilterClanLevel()
{
    return ClanLevelCBox.GetReserved(ClanLevelCBox.GetSelectedNum());
    return;
}

function int getFilterClanType()
{
    return ClanFriendshipTypeCBox.GetReserved(ClanFriendshipTypeCBox.GetSelectedNum());
    return;
}

function int getFilterSearchType()
{
    return SearchTypeCBox.GetReserved(SearchTypeCBox.GetSelectedNum());
    return;
}

function string getFilterStringLine()
{
    return SearchEBox.GetString();
    return;
}

function string getAskJoinAbout()
{
    return ClanInfoMEdit.GetString();
    return;
}

function string getMyClanAbout()
{
    return MyClanInfoMEdit.GetString();
    return;
}

function string getMyTelegram()
{
    // End:0x34
    if((TelegramEBox.GetString() == "") || Len(TelegramEBox.GetString()) < 4)
    {
        return "-";
    }
    return TelegramEBox.GetString();
    return;
}

function string getMyDiscord()
{
    // End:0x4D
    if(((DiscordEBox.GetString() == "") || DiscordEBox.GetString() == "@") || Len(DiscordEBox.GetString()) < 4)
    {
        return "-";
    }
    return DiscordEBox.GetString();
    return;
}

function string getMyAcademyPrice()
{
    // End:0x1A
    if(AcademyPriceEBox.GetString() == "")
    {
        return "0";
    }
    return AcademyPriceEBox.GetString();
    return;
}

function bool canAddClan()
{
    // End:0x2A
    if((getMyClanAbout()) == "")
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(8035));
        return false;
    }
    return true;
    return;
}

function bool getClanTypeSelect()
{
    return currMyKnighthoodType != -1;
    return;
}

function FAKE_RQ_CLAN_SYSTEM(int nPage, int clanLv, int clanType, int sortType, int nSort, int searchType, string LINE)
{
    evRqClanSearchSystem(nPage, clanLv, clanType, sortType, nSort, searchType, LINE);
    return;
}

function FAKE_RQ_CLAN_SYSTEM_A(int nPage, int clanLv, int clanType, int sortType, int nSort, int searchType, string LINE)
{
    local string clanLine;

    evRqClanSearchSystem_a(nPage, clanLv, clanType, sortType, nSort, searchType, LINE);
    return;
}

function FAKE_RQ_CLAN_SYSTEM_DETAIL(int clanID)
{
    evRqClanSearchSystemDetail(clanID);
    return;
}

function FAKE_RQ_CLAN_SYSTEM_DETAIL_A(int clanID)
{
    evRqClanSearchSystemDetailA(clanID);
    return;
}

function FAKE_RQ_CLAN_SYSTEM_MY_CLAN()
{
    evRqClanSearchMyClanInfo();
    return;
}

function FAKE_RQ_CLAN_SYSTEM_MY_ACADEMY()
{
    evRqClanSearchMyAcademyInfo();
    return;
}

function FAKE_RQ_CLAN_SYSTEM_MY_ACADEMY_ADD()
{
    evRqClanSearchMyAcademyAdd(currMyInviteType, getMyAcademyPrice(), getMyClanAbout());
    return;
}

function FAKE_RQ_CLAN_SYSTEM_MY_CLAN_ADD()
{
    evRqClanSearchMyClanAdd(currMyFriendshipType, currMyInviteType, currMyKnighthoodType, getMyTelegram(), getMyDiscord(), getMyClanAbout());
    return;
}

function FAKE_RQ_CLAN_SYSTEM_MY_CLAN_REMOVE()
{
    evRqClanSearchMyClanRemove();
    return;
}

function FAKE_RQ_CLAN_SYSTEM_MY_ACADEMY_REMOVE()
{
    evRqClanSearchMyAcademyRemove();
    return;
}

function FAKE_RQ_CLAN_SYSTEM_REQUESTOR_ABOUT(int nRequestorId)
{
    evRqClanSearchMyClanInfoRequestorAbout(nRequestorId);
    return;
}

function FAKE_RQ_CLAN_SYSTEM_REQUESTOR_ACTION(int nRequestorId, int nResult)
{
    evRqClanSearchMyClanInfoRequestorAction(nRequestorId, nResult);
    return;
}

function FAKE_RQ_CLAN_SYSTEM_DETAIL_CLAN_SKILL(int clanID)
{
    evRqClanSearchSystemClanSkill(clanID);
    return;
}

function FAKE_RQ_CLAN_SYSTEM_DETAIL_CLAN_WAR(int nPage, int clanID)
{
    evRqClanSearchSystemClanWar(nPage, clanID);
    return;
}

function FAKE_RQ_CLAN_SYSTEM_DETAIL_CLAN_LIST(int nPage, int clanID)
{
    evRqClanSearchSystemClanList(nPage, clanID);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    Me.HideWindow();
    return;
}
