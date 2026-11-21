class RankingWnd extends UICommonAPI;

const EV_RANKING_DATA = 48880;
const EV_RANKING_CLAN = 48881;
const EV_RANKING_ROSTER = 48882;
const EV_RANKING_SEARCH = 48883;
const HDR_FIELDS = 19;
const ROW_FIELDS = 11;
const CLAN_HDR_FIELDS = 20;
const CLAN_ROW_FIELDS = 10;
const ROSTER_HDR_FIELDS = 5;
const ROSTER_ROW_FIELDS = 5;
const SEARCH_FIELDS = 14;
const SUB_TOP = 0;
const SUB_CLASS = 1;
const SUB_HALL = 2;
const TAB_CLAN = 3;
const NO_GAP = -1;
const NO_CLOCK = -1;
const STANDING_NO_CLAN = 0;
const STANDING_ACADEMY = 1;
const STANDING_COUNTED = 2;
const STANDING_OUTSIDE = 3;
const STANDING_NO_SCORE = 4;

var WindowHandle Me;
var WindowHandle CharacterRankingWnd;
var ButtonHandle RankingTab1Button;
var ButtonHandle RankingTab2Button;
var ButtonHandle RankingTab3Button;
var ButtonHandle RankingTab4Button;
var ButtonHandle RankingTab5Button;
var ButtonHandle RankingTab6Button;
var ComboBoxHandle ClassFilterCombo;
var int CurrentTabIndex;
var int CurrentBottomTabIndex;
var int CurrentClassFilter;
var bool bRosterMode;
var int RosterClanId;
var int MyLineId;
var string MyName;
var int ClanCutoff;

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function Initialize()
{
    local int i;

    Me = GetWindowHandle("RankingWnd");
    RankingTab1Button = GetButtonHandle("RankingWnd.RankingTab1Button");
    RankingTab2Button = GetButtonHandle("RankingWnd.RankingTab2Button");
    RankingTab3Button = GetButtonHandle("RankingWnd.RankingTab3Button");
    RankingTab4Button = GetButtonHandle("RankingWnd.RankingTab4Button");
    RankingTab5Button = GetButtonHandle("RankingWnd.RankingTab5Button");
    RankingTab6Button = GetButtonHandle("RankingWnd.RankingTab6Button");
    CharacterRankingWnd = GetWindowHandle("RankingWnd.RankingWnd_Character");
    RankingTab4Button.ShowWindow();
    RankingTab5Button.HideWindow();
    RankingTab6Button.HideWindow();
    GetTextureHandle("RankingWnd.RankingTabLineBg").HideWindow();
    GetTextureHandle("RankingWnd.RankingTabLine2Bg").HideWindow();
    GetTextureHandle("RankingWnd.RankingTabLine4Bg").HideWindow();
    GetTextureHandle("RankingWnd.RankingTabLine5Bg").HideWindow();
    GetTextureHandle("RankingWnd.RankingTabLine3Bg").ShowWindow();
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("RankingWnd.RankingTabLine3Bg", "RankingWnd", "TopLeft", "TopLeft", 466, 35);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("RankingWnd.RankingTabLine3Bg", 309, 23);
    ClassFilterCombo = GetComboBoxHandle("RankingWnd.RankingWnd_Character.RankingTabAllWnd.ClassFilterCombo");
    ClassFilterCombo.Clear();
    ClassFilterCombo.AddString(GetSystemString(9020));
    i = 0;
    J0x358:

    // End:0x38C [Loop If]
    if(i < (GetClassListCount()))
    {
        ClassFilterCombo.AddString(GetClassListName(i));
        i++;
        // [Loop Continue]
        goto J0x358;
    }
    ClassFilterCombo.SetSelectedNum(0);
    ClassFilterCombo.HideWindow();
    return;
}

function OpenByCommand()
{
    Initialize();
    Me.ShowWindow();
    Me.SetFocus();
    showtab(CurrentTabIndex);
    return;
}

function OnShow()
{
    showtab(CurrentTabIndex);
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(48880);
    RegisterEvent(48881);
    RegisterEvent(48882);
    RegisterEvent(48883);
    return;
}

function OnEvent(int EventID, string param)
{
    switch(EventID)
    {
        // End:0x1D
        case 48880:
            FillRankingFromData(param);
            // End:0x62
            break;
        // End:0x33
        case 48881:
            FillClanFromData(param);
            // End:0x62
            break;
        // End:0x49
        case 48882:
            FillRosterFromData(param);
            // End:0x62
            break;
        // End:0x5F
        case 48883:
            FillSearchResult(param);
            // End:0x62
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x27
        case "RankingTab1Button":
            showtab(0);
            // End:0x19F
            break;
        // End:0x47
        case "RankingTab2Button":
            showtab(1);
            // End:0x19F
            break;
        // End:0x68
        case "RankingTab3Button":
            showtab(2);
            // End:0x19F
            break;
        // End:0x89
        case "RankingTab4Button":
            showtab(3);
            // End:0x19F
            break;
        // End:0xA4
        case "RefreshButton":
            RefreshView();
            // End:0x19F
            break;
        // End:0xC4
        case "ShowLastWeekButton":
            RefreshView();
            // End:0x19F
            break;
        // End:0xEF
        case "RankingServerTabButton":
            SelectBottomTab(0);
            RefreshView();
            // End:0x19F
            break;
        // End:0x11E
        case "RankingClanMemberTabButton":
            SelectBottomTab(1);
            RefreshView();
            // End:0x19F
            break;
        // End:0x13F
        case "Top100Button":
            SelectBottomTab(0);
            RefreshView();
            // End:0x19F
            break;
        // End:0x15C
        case "MyRankingButton":
            RefreshView();
            // End:0x19F
            break;
        // End:0x17D
        case "RankingSearchButton":
            DoSearch();
            // End:0x19F
            break;
        // End:0x19C
        case "RankingBackButton":
            LeaveRosterMode();
            // End:0x19F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
    // End:0x2D
    if(strID == "ClassFilterCombo")
    {
        CurrentClassFilter = IndexID;
        RefreshView();
    }
    return;
}

function OnCompleteEditBox(string EditBoxID)
{
    // End:0x23
    if(EditBoxID == "RankingSearchEdit")
    {
        DoSearch();
    }
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    local ListCtrlHandle RankingList;
    local LVDataRecord Record;
    local int clanID;

    // End:0x21
    if(ListCtrlID != "RankingTab_RichList")
    {
        return;
    }
    // End:0x3A
    if((CurrentTabIndex != 3) || bRosterMode)
    {
        return;
    }
    RankingList = GetListCtrlHandle(GetCurrentListPath());
    RankingList.GetSelectedRec(Record);
    clanID = name(Record.nReserved1);
    // End:0x7F
    if(clanID <= 0)
    {
        return;
    }
    RequestClanRoster(clanID);
    return;
}

function showtab(int tabindex)
{
    CurrentTabIndex = tabindex;
    CurrentBottomTabIndex = 0;
    CurrentClassFilter = 0;
    bRosterMode = false;
    RosterClanId = 0;
    HideAllTabs();
    UpdateTabButtons();
    UpdateBottomTabButtons();
    CharacterRankingWnd.ShowWindow();
    FixTopTextureLayout();
    RefreshView();
    return;
}

function FixTopTextureLayout()
{
    local string WindowName;

    WindowName = GetCurrentRankingWindowName();
    GetTextureHandle(WindowName $ ".RankingBg1").SetWindowSize(765, 152);
    GetTextureHandle(WindowName $ ".RankingTrophy").SetWindowSize(302, 142);
    GetTextureHandle(WindowName $ ".RankingFlag").SetWindowSize(94, 147);
    GetTextureHandle(WindowName $ ".RaceMark").SetWindowSize(64, 64);
    GetTextureHandle(WindowName $ ".RankingRewardICON_Btn").SetWindowSize(219, 64);
    return;
}

function HideAllTabs()
{
    CharacterRankingWnd.HideWindow();
    return;
}

function UpdateTabButtons()
{
    SetTabTexture(RankingTab1Button, CurrentTabIndex == 0);
    SetTabTexture(RankingTab2Button, CurrentTabIndex == 1);
    SetTabTexture(RankingTab3Button, CurrentTabIndex == 2);
    SetTabTexture(RankingTab4Button, CurrentTabIndex == 3);
    return;
}

function SetTabTexture(ButtonHandle TabButton, bool selected)
{
    // End:0x75
    if(selected)
    {
        TabButton.SetTexture("L2UI_CT1.Tab_DF_Tab_Selected", "L2UI_CT1.Tab_DF_Tab_Selected", "L2UI_CT1.Tab_DF_Tab_Selected");        
    }
    else
    {
        TabButton.SetTexture("L2UI_CT1.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab_DF_Tab_Selected", "L2UI_CT1.Tab_DF_Tab_Unselected_Over");
    }
    return;
}

function SelectBottomTab(int tabindex)
{
    local int classIndex;

    CurrentBottomTabIndex = tabindex;
    // End:0x20
    if(tabindex != 1)
    {
        CurrentClassFilter = 0;        
    }
    else
    {
        classIndex = GetClassListIndex(MyLineId);
        // End:0x4D
        if(classIndex >= 0)
        {
            CurrentClassFilter = classIndex + 1;            
        }
        else
        {
            CurrentClassFilter = 0;
        }
        ClassFilterCombo.SetSelectedNum(CurrentClassFilter);
    }
    UpdateBottomTabButtons();
    return;
}

function UpdateBottomTabButtons()
{
    local string ParentPath;

    ParentPath = (GetCurrentRankingWindowName()) $ ".RankingTabAllWnd";
    GetButtonHandle(ParentPath $ ".RankingServerTabButton").ShowWindow();
    // End:0x136
    if(CurrentTabIndex == 3)
    {
        GetButtonHandle(ParentPath $ ".RankingClanMemberTabButton").HideWindow();
        SetBottomTabTexture(GetButtonHandle(ParentPath $ ".RankingServerTabButton"), true);
        ClassFilterCombo.HideWindow();
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor(ParentPath $ ".TabLineBg2", ParentPath, "TopLeft", "TopLeft", 128, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize(ParentPath $ ".TabLineBg2", 635, 23);
        return;
    }
    GetButtonHandle(ParentPath $ ".RankingClanMemberTabButton").ShowWindow();
    SetBottomTabTexture(GetButtonHandle(ParentPath $ ".RankingServerTabButton"), CurrentBottomTabIndex == 0);
    SetBottomTabTexture(GetButtonHandle(ParentPath $ ".RankingClanMemberTabButton"), CurrentBottomTabIndex == 1);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor(ParentPath $ ".TabLineBg2", ParentPath, "TopLeft", "TopLeft", 248, 0);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize(ParentPath $ ".TabLineBg2", 515, 23);
    // End:0x25A
    if(CurrentBottomTabIndex == 1)
    {
        ClassFilterCombo.ShowWindow();        
    }
    else
    {
        ClassFilterCombo.HideWindow();
    }
    return;
}

function SetBottomTabTexture(ButtonHandle TabButton, bool selected)
{
    // End:0x75
    if(selected)
    {
        TabButton.SetTexture("L2UI_CT1.Tab_DF_Tab_Selected", "L2UI_CT1.Tab_DF_Tab_Selected", "L2UI_CT1.Tab_DF_Tab_Selected");        
    }
    else
    {
        TabButton.SetTexture("L2UI_CT1.Tab_DF_Tab_Unselected", "L2UI_CT1.Tab_DF_Tab_Selected", "L2UI_CT1.Tab_DF_Tab_Unselected_Over");
    }
    return;
}

function string GetCurrentRankingWindowName()
{
    return "RankingWnd.RankingWnd_Character";
    return;
}

function string GetCurrentListPath()
{
    return (GetCurrentRankingWindowName()) $ ".RankingTabAllWnd.RankingTab_RichList";
    return;
}

function string GetTabAllPath()
{
    return (GetCurrentRankingWindowName()) $ ".RankingTabAllWnd";
    return;
}

function int GetCurrentColumnCount()
{
    return 6;
    return;
}

function ApplyCurrentListColumnLayout(ListCtrlHandle RankingList)
{
    RankingList.SetResizable(false);
    RankingList.SetColumnMinimumWidth(true);
    // End:0xAB
    if((CurrentTabIndex == 3) && !bRosterMode)
    {
        RankingList.SetColumnWidth(0, 70);
        RankingList.SetColumnWidth(1, 130);
        RankingList.SetColumnWidth(2, 200);
        RankingList.SetColumnWidth(3, 160);
        RankingList.SetColumnWidth(4, 70);
        RankingList.SetColumnWidth(5, 121);
        return;
    }
    RankingList.SetColumnWidth(0, 70);
    RankingList.SetColumnWidth(1, 162);
    RankingList.SetColumnWidth(2, 188);
    RankingList.SetColumnWidth(3, 150);
    RankingList.SetColumnWidth(4, 120);
    RankingList.SetColumnWidth(5, 61);
    return;
}

function ApplyColumnHeaders(ListCtrlHandle RankingList)
{
    // End:0x88
    if((CurrentTabIndex == 3) && !bRosterMode)
    {
        RankingList.SetColumnString(1, 9042);
        RankingList.SetColumnString(2, 9038);
        RankingList.SetColumnString(3, 9039);
        RankingList.SetColumnString(4, 9040);
        RankingList.SetColumnString(5, 9041);
        return;
    }
    // End:0x100
    if(bRosterMode)
    {
        RankingList.SetColumnString(1, 9009);
        RankingList.SetColumnString(2, 2321);
        RankingList.SetColumnString(3, 2290);
        RankingList.SetColumnString(4, 9065);
        RankingList.SetColumnString(5, 9032);
        return;
    }
    switch(CurrentTabIndex)
    {
        // End:0x123
        case 1:
            RankingList.SetColumnString(1, 9021);
            // End:0x15B
            break;
        // End:0x140
        case 2:
            RankingList.SetColumnString(1, 9022);
            // End:0x15B
            break;
        // End:0xFFFF
        default:
            RankingList.SetColumnString(1, 9009);
            // End:0x15B
            break;
            break;
    }
    RankingList.SetColumnString(2, 2321);
    RankingList.SetColumnString(3, 2290);
    RankingList.SetColumnString(4, 314);
    RankingList.SetColumnString(5, 9032);
    return;
}

function int GetClassListCount()
{
    return 36;
    return;
}

function string GetClassListName(int Index)
{
    switch(Index)
    {
        // End:0x15
        case 0:
            return "Duelist";
        // End:0x27
        case 1:
            return "Dreadnought";
        // End:0x3D
        case 2:
            return "Phoenix Knight";
        // End:0x50
        case 3:
            return "Hell Knight";
        // End:0x63
        case 4:
            return "Sagittarius";
        // End:0x75
        case 5:
            return "Adventurer";
        // End:0x85
        case 6:
            return "Archmage";
        // End:0x96
        case 7:
            return "Soultaker";
        // End:0xA9
        case 8:
            return "Arcana Lord";
        // End:0xB9
        case 9:
            return "Cardinal";
        // End:0xCB
        case 10:
            return "Hierophant";
        // End:0xE0
        case 11:
            return "Eva's Templar";
        // End:0xF2
        case 12:
            return "Sword Muse";
        // End:0x104
        case 13:
            return "Wind Rider";
        // End:0x11E
        case 14:
            return "Moonlight Sentinel";
        // End:0x131
        case 15:
            return "Mystic Muse";
        // End:0x149
        case 16:
            return "Elemental Master";
        // End:0x15C
        case 17:
            return "Eva's Saint";
        // End:0x174
        case 18:
            return "Shillien Templar";
        // End:0x18B
        case 19:
            return "Spectral Dancer";
        // End:0x19F
        case 20:
            return "Ghost Hunter";
        // End:0x1B5
        case 21:
            return "Ghost Sentinel";
        // End:0x1CB
        case 22:
            return "Storm Screamer";
        // End:0x1E2
        case 23:
            return "Spectral Master";
        // End:0x1F8
        case 24:
            return "Shillien Saint";
        // End:0x205
        case 25:
            return "Titan";
        // End:0x21C
        case 26:
            return "Grand Khavatari";
        // End:0x22D
        case 27:
            return "Dominator";
        // End:0x23E
        case 28:
            return "Doomcryer";
        // End:0x254
        case 29:
            return "Fortune Seeker";
        // End:0x263
        case 30:
            return "Maestro";
        // End:0x276
        case 31:
            return "Doombringer";
        // End:0x28C
        case 32:
            return "Soul Hound (M)";
        // End:0x2A2
        case 33:
            return "Soul Hound (F)";
        // End:0x2B3
        case 34:
            return "Trickster";
        // End:0x2C4
        case 35:
            return "Judicator";
        // End:0xFFFF
        default:
            return "Duelist";
            break;
    }
    return;
}

function int GetClassListID(int Index)
{
    switch(Index)
    {
        // End:0x0E
        case 0:
            return 88;
        // End:0x15
        case 1:
            return 89;
        // End:0x1D
        case 2:
            return 90;
        // End:0x25
        case 3:
            return 91;
        // End:0x2D
        case 4:
            return 92;
        // End:0x35
        case 5:
            return 93;
        // End:0x3D
        case 6:
            return 94;
        // End:0x45
        case 7:
            return 95;
        // End:0x4D
        case 8:
            return 96;
        // End:0x55
        case 9:
            return 97;
        // End:0x5D
        case 10:
            return 98;
        // End:0x65
        case 11:
            return 99;
        // End:0x6D
        case 12:
            return 100;
        // End:0x75
        case 13:
            return 101;
        // End:0x7D
        case 14:
            return 102;
        // End:0x85
        case 15:
            return 103;
        // End:0x8D
        case 16:
            return 104;
        // End:0x95
        case 17:
            return 105;
        // End:0x9D
        case 18:
            return 106;
        // End:0xA5
        case 19:
            return 107;
        // End:0xAD
        case 20:
            return 108;
        // End:0xB5
        case 21:
            return 109;
        // End:0xBD
        case 22:
            return 110;
        // End:0xC5
        case 23:
            return 111;
        // End:0xCD
        case 24:
            return 112;
        // End:0xD5
        case 25:
            return 113;
        // End:0xDD
        case 26:
            return 114;
        // End:0xE5
        case 27:
            return 115;
        // End:0xED
        case 28:
            return 116;
        // End:0xF5
        case 29:
            return 117;
        // End:0xFD
        case 30:
            return 118;
        // End:0x105
        case 31:
            return 131;
        // End:0x10D
        case 32:
            return 132;
        // End:0x115
        case 33:
            return 133;
        // End:0x11D
        case 34:
            return 134;
        // End:0x125
        case 35:
            return 136;
        // End:0xFFFF
        default:
            return 88;
            break;
    }
    return;
}

function int GetClassListIndex(int ClassID)
{
    local int i;

    // End:0x11
    if(ClassID <= 0)
    {
        return -1;
    }
    i = 0;
    J0x18:

    // End:0x4D [Loop If]
    if(i < (GetClassListCount()))
    {
        // End:0x43
        if((GetClassListID(i)) == ClassID)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x18;
    }
    return -1;
    return;
}

function int PackQuery()
{
    local int Type, SubType, ClassID;

    Type = CurrentTabIndex;
    // End:0x24
    if(Type == 3)
    {
        return Type * 100000;
    }
    // End:0x60
    if(CurrentBottomTabIndex == 1)
    {
        // End:0x58
        if(CurrentClassFilter > 0)
        {
            SubType = 1;
            ClassID = GetClassListID(CurrentClassFilter - 1);            
        }
        else
        {
            SubType = 2;
        }
    }
    return ((Type * 100000) + (SubType * 10000)) + ClassID;
    return;
}

function RequestCurrentView()
{
    local int Query;

    Query = PackQuery();
    Class'NWindow.RankingAPI'.static.RequestRankingData(Query);
    return;
}

function RequestClanRoster(int clanID)
{
    RosterClanId = clanID;
    RequestBypassToServer("rankClan" @ string(clanID));
    return;
}

function DoSearch()
{
    local string Name;
    local int Type;

    Name = GetEditBoxHandle((GetTabAllPath()) $ ".RankingSearchEdit").GetString();
    // End:0x40
    if(Name == "")
    {
        return;
    }
    Type = CurrentTabIndex;
    RequestBypassToServer(("rankSearch" @ string(Type)) @ Name);
    return;
}

function LeaveRosterMode()
{
    bRosterMode = false;
    RosterClanId = 0;
    RefreshView();
    return;
}

function RefreshView()
{
    local ListCtrlHandle RankingList;

    bRosterMode = false;
    RankingList = GetListCtrlHandle(GetCurrentListPath());
    PrepareList(RankingList);
    UpdateClassIconTooltips();
    UpdateCharacterNameTooltips();
    UpdateAuxControls();
    RequestCurrentView();
    return;
}

function PrepareList(ListCtrlHandle RankingList)
{
    ApplyCurrentListColumnLayout(RankingList);
    RankingList.SetSelectedSelTooltip(false);
    RankingList.SetAppearTooltipAtMouseX(true);
    // End:0x4B
    if(CurrentTabIndex == 3)
    {
        RankingList.SetTooltipType("");        
    }
    else
    {
        RankingList.SetTooltipType("RankingCharacterInfo");
    }
    RankingList.DeleteAllItem();
    ApplyColumnHeaders(RankingList);
    return;
}

function UpdateAuxControls()
{
    local string P;

    P = GetTabAllPath();
    // End:0x9B
    if(bRosterMode)
    {
        GetEditBoxHandle(P $ ".RankingSearchEdit").HideWindow();
        GetButtonHandle(P $ ".RankingSearchButton").HideWindow();
        GetButtonHandle(P $ ".RankingBackButton").ShowWindow();        
    }
    else
    {
        GetEditBoxHandle(P $ ".RankingSearchEdit").ShowWindow();
        GetButtonHandle(P $ ".RankingSearchButton").ShowWindow();
        GetButtonHandle(P $ ".RankingBackButton").HideWindow();
    }
    return;
}

function int GetPointsTitleSysString()
{
    switch(CurrentTabIndex)
    {
        // End:0x11
        case 1:
            return 9021;
        // End:0x1C
        case 2:
            return 9022;
        // End:0x27
        case 3:
            return 9042;
        // End:0xFFFF
        default:
            return 9015;
            break;
    }
    return;
}

function FillMyRankHeader(int myLevel, string PlayerName, string MyClass, string MyClan)
{
    local string WindowName;

    WindowName = GetCurrentRankingWindowName();
    GetTextBoxHandle(WindowName $ ".LevelText").SetText("Lv. " $ string(myLevel));
    GetTextBoxHandle(WindowName $ ".NameText").SetText(PlayerName);
    GetTextBoxHandle(WindowName $ ".ClassText").SetText(MyClass);
    GetTextBoxHandle(WindowName $ ".ClanNameText").SetText(MyClan);
    return;
}

function FillMyCrests(int MyClanId, int MyAllyId)
{
    local string W;
    local Texture ClanCrest, AllyCrest;

    W = GetCurrentRankingWindowName();
    GetButtonHandle(W $ ".RankingHelpButton").HideWindow();
    // End:0xAC
    if((MyClanId > 0) && Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(MyClanId, ClanCrest))
    {
        GetTextureHandle(W $ ".ClanMark").ShowWindow();
        GetTextureHandle(W $ ".ClanMark").SetTextureWithObject(ClanCrest);        
    }
    else
    {
        GetTextureHandle(W $ ".ClanMark").HideWindow();
    }
    // End:0x143
    if((MyAllyId > 0) && Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(MyAllyId, AllyCrest))
    {
        GetTextureHandle(W $ ".AllyMark").ShowWindow();
        GetTextureHandle(W $ ".AllyMark").SetTextureWithObject(AllyCrest);        
    }
    else
    {
        GetTextureHandle(W $ ".AllyMark").HideWindow();
    }
    return;
}

function FillRankBlock(int MyRank, int ClassRank, int DeltaDay, int DeltaHour)
{
    local string W, RankText;

    W = GetCurrentRankingWindowName();
    // End:0x8C
    if(MyRank > 0)
    {
        RankText = string(MyRank);
        // End:0x57
        if((CurrentBottomTabIndex == 1) && ClassRank > 0)
        {
            RankText = (RankText $ " / ") $ string(ClassRank);
        }
        GetTextBoxHandle(W $ ".ServerMyRankingText").SetText(RankText);        
    }
    else
    {
        GetTextBoxHandle(W $ ".ServerMyRankingText").SetText("-");
    }
    ApplyDelta(W $ ".ServerRankingArrow", W $ ".RankingDeltaText", MyRank > 0, DeltaDay, DeltaHour);
    return;
}

function ApplyDelta(string ArrowPath, string TextPath, bool bRanked, int DeltaDay, int DeltaHour)
{
    local TextureHandle Arrow;
    local TextBoxHandle Text;

    Arrow = GetTextureHandle(ArrowPath);
    Text = GetTextBoxHandle(TextPath);
    // End:0x94
    if(!bRanked || DeltaDay == 0)
    {
        Arrow.HideWindow();
        Text.SetText("-");
        Text.SetTextColor(GetDeltaNeutralColor());
        Text.SetTooltipType("");
        Text.SetTooltipText("");
        return;
    }
    Arrow.ShowWindow();
    // End:0x11F
    if(DeltaDay > 0)
    {
        Arrow.SetTexture("UI_BOHPTS.RankingWnd.RankingWnd_ArrowUp");
        Text.SetText(("(+" $ string(DeltaDay)) $ ")");
        Text.SetTextColor(GetDeltaUpColor());        
    }
    else
    {
        Arrow.SetTexture("UI_BOHPTS.RankingWnd.RankingWnd_ArrowDown");
        Text.SetText(("(" $ string(DeltaDay)) $ ")");
        Text.SetTextColor(GetDeltaDownColor());
    }
    Text.SetTooltipType("text");
    Text.SetTooltipText((GetSystemString(9053) $ ": ") $ (SignedString(DeltaHour)));
    return;
}

function Color GetDeltaUpColor()
{
    return GetColor(76, 175, 80, 255);
    return;
}

function Color GetDeltaDownColor()
{
    return GetColor(224, 75, 75, 255);
    return;
}

function Color GetDeltaNeutralColor()
{
    return GetColor(128, 128, 128, 255);
    return;
}

function string SignedString(int Value)
{
    // End:0x18
    if(Value > 0)
    {
        return "+" $ string(Value);
    }
    // End:0x2B
    if(Value < 0)
    {
        return string(Value);
    }
    return "-";
    return;
}

function FillPointsBlock(int MyPoints, int MyKills, int MyDeaths)
{
    local string W;
    local bool bShowStats;

    W = GetCurrentRankingWindowName();
    bShowStats = (CurrentTabIndex == 1) || CurrentTabIndex == 2;
    GetTextBoxHandle(W $ ".PvpPointText").SetText(GetSystemString(GetPointsTitleSysString()));
    GetTextBoxHandle(W $ ".PvpMyPointText").SetText(MakeCostString(string(MyPoints)));
    // End:0xE1
    if((CurrentTabIndex == 0) || CurrentTabIndex == 3)
    {
        GetTextBoxHandle(W $ ".PvpMyPointText").SetTextColor(GetGearScoreTierColor((MyPoints)));        
    }
    else
    {
        GetTextBoxHandle(W $ ".PvpMyPointText").SetTextColor(GetColor(221, 221, 221, 255));
    }
    // End:0x253
    if(bShowStats)
    {
        GetTextureHandle(W $ ".PvpScoreBg").ShowWindow();
        GetTextBoxHandle(W $ ".PvpScoreText").ShowWindow();
        GetTextBoxHandle(W $ ".PvpMyScoreKillText").ShowWindow();
        GetTextBoxHandle(W $ ".PvpMyScoreDeathText").ShowWindow();
        GetTextBoxHandle(W $ ".PvpMyScoreKillText").SetText((GetSystemString(9024) $ ": ") $ string(MyKills));
        GetTextBoxHandle(W $ ".PvpMyScoreDeathText").SetText((GetSystemString(9025) $ ": ") $ string(MyDeaths));        
    }
    else
    {
        GetTextureHandle(W $ ".PvpScoreBg").HideWindow();
        GetTextBoxHandle(W $ ".PvpScoreText").HideWindow();
        GetTextBoxHandle(W $ ".PvpMyScoreKillText").HideWindow();
        GetTextBoxHandle(W $ ".PvpMyScoreDeathText").HideWindow();
    }
    return;
}

function FillGoalLines(int GapToTop, int NextRank, int GapToNext, bool bFirst)
{
    local string P;
    local TextBoxHandle TopLine, NextLine;

    P = GetTabAllPath();
    TopLine = GetTextBoxHandle(P $ ".RankingGoalTopText");
    NextLine = GetTextBoxHandle(P $ ".RankingGoalNextText");
    // End:0xAD
    if(GapToTop != -1)
    {
        TopLine.SetText((GetSystemString(9045) $ ": ") $ MakeCostString(string(GapToTop)));
        TopLine.ShowWindow();        
    }
    else
    {
        TopLine.SetText("");
        TopLine.HideWindow();
    }
    // End:0x101
    if(bFirst)
    {
        NextLine.SetText(GetSystemString(9047));
        NextLine.ShowWindow();
        return;
    }
    // End:0x166
    if((GapToNext != -1) && NextRank > 0)
    {
        NextLine.SetText(((GetSystemString(9046) @ string(NextRank)) $ ": ") $ MakeCostString(string(GapToNext)));
        NextLine.ShowWindow();
        return;
    }
    NextLine.SetText("");
    NextLine.HideWindow();
    return;
}

function FillInfoLines(int RankedCount, int Avg, int BuiltAt, int NextAt)
{
    local string P, Info;
    local int AvgTitle;

    P = GetTabAllPath();
    // End:0x25
    if(CurrentBottomTabIndex == 1)
    {
        AvgTitle = 9050;        
    }
    else
    {
        AvgTitle = 9049;
    }
    Info = GetSystemString(9048) @ string(RankedCount);
    // End:0x8B
    if(Avg > 0)
    {
        Info = (((Info $ "  -  ") $ GetSystemString(AvgTitle)) $ ": ") $ MakeCostString(string(Avg));
    }
    GetTextBoxHandle(P $ ".RankingInfoText").SetText(Info);
    FillUpdatedLine(BuiltAt, NextAt);
    return;
}

function FillUpdatedLine(int BuiltAt, int NextAt)
{
    local string P, LINE;

    P = GetTabAllPath();
    // End:0x5B
    if(BuiltAt == -1)
    {
        GetTextBoxHandle(P $ ".RankingUpdatedText").SetText(GetSystemString(9051) $ ": -");
        return;
    }
    LINE = GetSystemString(9051) @ (ClockString(BuiltAt));
    // End:0xB6
    if(NextAt != -1)
    {
        LINE = ((LINE $ "  -  ") $ GetSystemString(9052)) @ (ClockString(NextAt));
    }
    GetTextBoxHandle(P $ ".RankingUpdatedText").SetText(LINE);
    return;
}

function string ClockString(int Hhmm)
{
    local int h, M;
    local string MM;

    h = Hhmm / 100;
    M = int(float(Hhmm) % float(100));
    MM = string(M);
    // End:0x4D
    if(M < 10)
    {
        MM = "0" $ MM;
    }
    return (string(h) $ ":") $ MM;
    return;
}

function FillRankingFromData(string Data)
{
    local array<string> F;
    local int i, N, Rows;
    local ListCtrlHandle RankingList;
    local int MyRank;
    local bool bMineShown;

    N = Split(Data, ";", F);
    // End:0x2B
    if(N < (19 + 11))
    {
        return;
    }
    // End:0x4B
    if((int(F[1]) != CurrentTabIndex) || bRosterMode)
    {
        return;
    }
    MyLineId = int(F[17]);
    MyName = F[19 + 4];
    MyRank = int(F[4]);
    RankingList = GetListCtrlHandle(GetCurrentListPath());
    PrepareList(RankingList);
    Rows = 0;
    i = 19 + 11;
    J0xAD:

    // End:0x16E [Loop If]
    if(((i + 11) - 1) < N)
    {
        // End:0xE4
        if(F[i + 4] ~= MyName)
        {
            bMineShown = true;
        }
        AddRankRecord(RankingList, int(F[i]), F[i + 4], int(F[i + 1]), int(F[i + 2]), F[i + 5], int(F[i + 3]), F[i + 6]);
        Rows++;
        i += 11;
        // [Loop Continue]
        goto J0xAD;
    }
    // End:0x20A
    if((!bMineShown && MyRank > 0) && Rows > 0)
    {
        i = 19;
        AddRankRecord(RankingList, MyRank, F[i + 4], int(F[i + 1]), int(F[i + 2]), F[i + 5], int(F[i + 3]), F[i + 6]);
    }
    ShowEmptyState(Rows == 0, 9056);
    UpdateClassIconTooltips();
    UpdateCharacterNameTooltips();
    UpdateAuxControls();
    FillMyRankHeader(int(F[19 + 1]), F[19 + 4], GetClassType(int(F[19 + 2])), F[19 + 5]);
    FillRankBlock(MyRank, int(F[5]), int(F[6]), int(F[7]));
    FillPointsBlock(int(F[8]), int(F[19 + 7]), int(F[19 + 8]));
    FillMyCrests(int(F[19 + 9]), int(F[19 + 10]));
    FillGoalLines(int(F[9]), int(F[10]), int(F[11]), int(F[12]) != 0);
    FillInfoLines(int(F[13]), int(F[14]), int(F[15]), int(F[16]));
    return;
}

function FillClanFromData(string Data)
{
    local array<string> F;
    local int i, N, Rows;
    local ListCtrlHandle RankingList;
    local int clanID, clanRank;

    N = Split(Data, ";", F);
    // End:0x27
    if(N < 20)
    {
        return;
    }
    // End:0x40
    if((CurrentTabIndex != 3) || bRosterMode)
    {
        return;
    }
    ClanCutoff = int(F[13]);
    clanID = int(F[1]);
    clanRank = int(F[2]);
    RankingList = GetListCtrlHandle(GetCurrentListPath());
    PrepareList(RankingList);
    Rows = 0;
    i = 20;
    J0x9B:

    // End:0x153 [Loop If]
    if(((i + 10) - 1) < N)
    {
        AddClanRecord(RankingList, int(F[i]), int(F[i + 1]), int(F[i + 2]), int(F[i + 3]), int(F[i + 4]), F[i + 8], F[i + 9], int(F[i + 7]), clanID);
        Rows++;
        i += 10;
        // [Loop Continue]
        goto J0x9B;
    }
    ShowEmptyState(Rows == 0, 13023);
    UpdateClassIconTooltips();
    UpdateCharacterNameTooltips();
    UpdateAuxControls();
    FillRankBlock(clanRank, 0, int(F[3]), int(F[4]));
    FillPointsBlock(int(F[5]), 0, 0);
    FillGoalLines(int(F[6]), int(F[7]), int(F[8]), int(F[9]) != 0);
    FillClanStandingLine(int(F[14]), int(F[15]), int(F[16]), int(F[17]), int(F[18]));
    FillUpdatedLine(int(F[11]), int(F[12]));
    return;
}

function FillClanStandingLine(int Standing, int Position, int RosterSize, int MembersCount, int GapToCutoff)
{
    local string P, LINE, Cutoff;

    P = GetTabAllPath();
    // End:0x27
    if(ClanCutoff > 0)
    {
        Cutoff = string(ClanCutoff);        
    }
    else
    {
        Cutoff = string(RosterSize);
    }
    switch(Standing)
    {
        // End:0x53
        case 1:
            LINE = GetSystemString(9064);
            // End:0x172
            break;
        // End:0xEF
        case 2:
            LINE = ((GetSystemString(9059) @ string(Position)) @ GetSystemString(9060)) @ string(MembersCount);
            // End:0xC6
            if((ClanCutoff <= 0) || RosterSize <= ClanCutoff)
            {
                LINE = (LINE $ " - ") $ GetSystemString(9063);                
            }
            else
            {
                LINE = ((LINE $ " - ") $ GetSystemString(9061)) $ Cutoff;
            }
            // End:0x172
            break;
        // End:0x14A
        case 3:
            LINE = (((((GetSystemString(9059) @ string(Position)) @ GetSystemString(9060)) @ string(MembersCount)) $ " - ") $ GetSystemString(9062)) @ MakeCostString(string(GapToCutoff));
            // End:0x172
            break;
        // End:0x163
        case 4:
            LINE = GetSystemString(9056);
            // End:0x172
            break;
        // End:0xFFFF
        default:
            LINE = "-";
            // End:0x172
            break;
            break;
    }
    GetTextBoxHandle(P $ ".RankingInfoText").SetText(LINE);
    GetTextBoxHandle(P $ ".RankingInfoText").SetTooltipType("text");
    GetTextBoxHandle(P $ ".RankingInfoText").SetTooltipText((GetSystemString(9057) @ Cutoff) @ GetSystemString(9058));
    return;
}

function FillRosterFromData(string Data)
{
    local array<string> F;
    local int i, N, Rows, Cutoff, Position;

    local ListCtrlHandle RankingList;
    local string ClanName;

    N = Split(Data, ";", F);
    // End:0x27
    if(N < 5)
    {
        return;
    }
    // End:0x46
    if((CurrentTabIndex != 3) || int(F[1]) <= 0)
    {
        return;
    }
    bRosterMode = true;
    RosterClanId = int(F[1]);
    Cutoff = int(F[2]);
    ClanName = F[4];
    RankingList = GetListCtrlHandle(GetCurrentListPath());
    PrepareList(RankingList);
    Rows = 0;
    i = 5;
    J0xA7:

    // End:0x179 [Loop If]
    if(((i + 5) - 1) < N)
    {
        Position = int(F[i]);
        AddRosterRecord(RankingList, Position, F[i + 4], int(F[i + 1]), int(F[i + 2]), int(F[i + 3]), (Cutoff > 0) && Position > Cutoff);
        Rows++;
        // End:0x16D
        if((Cutoff > 0) && Position == Cutoff)
        {
            AddCutoffSeparator(RankingList, Cutoff);
        }
        i += 5;
        // [Loop Continue]
        goto J0xA7;
    }
    ShowEmptyState(Rows == 0, 13023);
    UpdateClassIconTooltips();
    UpdateCharacterNameTooltips();
    UpdateAuxControls();
    GetTextBoxHandle((GetTabAllPath()) $ ".RankingInfoText").SetText((GetSystemString(9067) $ ": ") $ ClanName);
    return;
}

function FillSearchResult(string Data)
{
    local array<string> F;
    local int N;
    local ListCtrlHandle RankingList;

    N = Split(Data, ";", F);
    // End:0x27
    if(N < 14)
    {
        return;
    }
    RankingList = GetListCtrlHandle(GetCurrentListPath());
    PrepareList(RankingList);
    UpdateAuxControls();
    // End:0x87
    if(int(F[2]) == 0)
    {
        // End:0x79
        if(int(F[1]) == 3)
        {
            ShowEmptyState(true, 9055);            
        }
        else
        {
            ShowEmptyState(true, 9054);
        }
        return;
    }
    ShowEmptyState(false, 0);
    // End:0x103
    if(int(F[1]) == 3)
    {
        AddClanRecord(RankingList, int(F[3]), int(F[9]), int(F[6]), int(F[8]), int(F[5]), F[11], F[12], int(F[10]), int(F[9]));        
    }
    else
    {
        AddRankRecord(RankingList, int(F[3]), F[11], int(F[6]), int(F[7]), F[12], int(F[5]), F[13]);
    }
    return;
}

function ShowEmptyState(bool bEmpty, int SysStringId)
{
    local string P;

    P = GetTabAllPath();
    // End:0x7E
    if(bEmpty)
    {
        GetTextBoxHandle(P $ ".DisableWndList.List_Empty").SetText(GetSystemString(SysStringId));
        GetWindowHandle(P $ ".DisableWndList").ShowWindow();        
    }
    else
    {
        GetWindowHandle(P $ ".DisableWndList").HideWindow();
    }
    return;
}

function string GetClassIconTooltipParentPath()
{
    return (GetCurrentRankingWindowName()) $ ".RankingTabAllWnd";
    return;
}

function UpdateClassIconTooltips()
{
    local int i;
    local string ParentPath;
    local WindowHandle ClassTooltipWnd;

    ParentPath = GetClassIconTooltipParentPath();
    // End:0x1A
    if(ParentPath == "")
    {
        return;
    }
    i = 0;
    J0x21:

    // End:0x8A [Loop If]
    if(i < 8)
    {
        ClassTooltipWnd = GetWindowHandle((ParentPath $ ".ClassIconTooltipButton") $ string(i));
        ClassTooltipWnd.ClearTooltip();
        ClassTooltipWnd.HideWindow();
        i++;
        // [Loop Continue]
        goto J0x21;
    }
    return;
}

function UpdateCharacterNameTooltips()
{
    local int i;
    local string ParentPath;
    local WindowHandle NameTooltipWnd;

    ParentPath = GetClassIconTooltipParentPath();
    // End:0x1A
    if(ParentPath == "")
    {
        return;
    }
    i = 0;
    J0x21:

    // End:0x8E [Loop If]
    if(i < 8)
    {
        NameTooltipWnd = GetWindowHandle((ParentPath $ ".CharacterNameTooltipButton") $ string(i));
        NameTooltipWnd.ClearTooltip();
        NameTooltipWnd.HideWindow();
        i++;
        // [Loop Continue]
        goto J0x21;
    }
    return;
}

function SetRankCellData(out LVData RankData, int Rank)
{
    local string RankTexture;

    RankData.szData = string(Rank);
    RankData.bUseTextColor = true;
    RankData.TextColor = GetColor(170, 153, 119, 255);
    RankData.textAlignment = 2;
    RankData.HiddenStringForSorting = string(Rank);
    RankTexture = GetRankTexture(Rank);
    // End:0x111
    if(RankTexture != "")
    {
        RankData.szData = " ";
        RankData.TextColor = GetColor(255, 255, 255, 0);
        RankData.textAlignment = 1;
        RankData.FirstLineOffsetX = 0;
        RankData.hasIcon = true;
        RankData.szTexture = RankTexture;
        RankData.nTextureWidth = 38;
        RankData.nTextureHeight = 33;
        RankData.nTextureU = 38;
        RankData.nTextureV = 33;
        RankData.IconPosX = 16;
    }
    return;
}

function int GetRewardSkillID(int Rank)
{
    // End:0x18
    if((CurrentTabIndex != 0) || bRosterMode)
    {
        return 0;
    }
    // End:0x4F
    if(CurrentBottomTabIndex == 1)
    {
        switch(Rank)
        {
            // End:0x34
            case 1:
                return 64406;
            // End:0x3F
            case 2:
                return 64405;
            // End:0x4A
            case 3:
                return 64404;
            // End:0xFFFF
            default:
                return 0;
                break;
        }
    }
    switch(Rank)
    {
        // End:0x60
        case 1:
            return 64403;
        // End:0x6B
        case 2:
            return 64402;
        // End:0x76
        case 3:
            return 64401;
        // End:0xFFFF
        default:
            return 0;
            break;
    }
    return;
}

function string GetRewardSkillIconTexture(int Rank)
{
    local int SkillID;
    local string IconName;

    SkillID = GetRewardSkillID(Rank);
    // End:0x1F
    if(SkillID <= 0)
    {
        return "";
    }
    IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(GetItemID(SkillID), 1, 0);
    // End:0x75
    if((IconName == "") || IconName ~= "None")
    {
        IconName = "icon.skill0000";
    }
    return IconName;
    return;
}

function SetRewardSkillCellData(out LVData rewardData, int Rank)
{
    local string IconTexture;

    rewardData.szData = "";
    IconTexture = GetRewardSkillIconTexture(Rank);
    // End:0x2C
    if(IconTexture == "")
    {
        return;
    }
    rewardData.szData = " ";
    rewardData.nReserved1 = GetRewardSkillID(Rank);
    rewardData.hasIcon = true;
    rewardData.szTexture = IconTexture;
    rewardData.nTextureWidth = 32;
    rewardData.nTextureHeight = 32;
    rewardData.nTextureU = 32;
    rewardData.nTextureV = 32;
    rewardData.IconPosX = 14;
    return;
}

function AddRankRecord(ListCtrlHandle RankingList, int Rank, string charName, int CharLevel, int ClassID, string ClanName, int Points, string RaceName)
{
    local LVDataRecord Record;
    local LVData RankData, nameData, ClassData, ClanData, PointData, rewardData;

    local int ColumnCount;
    local bool bMine;

    ColumnCount = GetCurrentColumnCount();
    Record.LVDataList.Length = ColumnCount;
    bMine = (MyName != "") && charName ~= MyName;
    SetRankCellData(RankData, Rank);
    nameData.szData = ((charName $ " (Lv.") $ string(CharLevel)) $ ")";
    nameData.bUseTextColor = true;
    // End:0xA7
    if(bMine)
    {
        nameData.TextColor = GetColor(255, 215, 120, 255);        
    }
    else
    {
        nameData.TextColor = GetColor(220, 220, 220, 255);
    }
    nameData.hasIcon = true;
    nameData.szTexture = "L2UI_CT1.EmptyBtn";
    nameData.nTextureWidth = 1;
    nameData.nTextureHeight = 1;
    nameData.nTextureU = 1;
    nameData.nTextureV = 1;
    nameData.IconPosX = 0;
    nameData.FirstLineOffsetX = 6;
    nameData.AttrColor = GetColor(178, 190, 207, 255);
    nameData.AttrStat[0] = RaceName;
    nameData.HiddenStringForSorting = charName;
    ClassData.szData = "";
    ClassData.szReserved = GetClassType(ClassID);
    ClassData.szTexture = GetRankingClassIconTexture(ClassID);
    ClassData.nTextureWidth = 31;
    ClassData.nTextureHeight = 42;
    ClassData.textAlignment = 2;
    ClassData.HiddenStringForSorting = GetClassType(ClassID);
    ClanData.szData = ClanName;
    ClanData.HiddenStringForSorting = ClanName;
    SetRewardSkillCellData(rewardData, Rank);
    PointData.szData = MakeCostString(string(Points));
    PointData.textAlignment = 2;
    PointData.HiddenStringForSorting = string(Points);
    // End:0x27C
    if(CurrentTabIndex == 0)
    {
        PointData.bUseTextColor = true;
        PointData.TextColor = GetGearScoreTierColor((Points));
    }
    Record.szReserved = charName;
    Record.nReserved1 = (CharLevel);
    nameData.szReserved = RaceName;
    nameData.nReserved1 = CharLevel;
    ClassData.nReserved1 = ClassID;
    ClanData.szReserved = ClanName;
    Record.LVDataList[0] = RankData;
    Record.LVDataList[1] = PointData;
    Record.LVDataList[2] = nameData;
    Record.LVDataList[3] = ClassData;
    Record.LVDataList[4] = ClanData;
    Record.LVDataList[5] = rewardData;
    RankingList.InsertRecord(Record);
    return;
}

function SetNameCrests(out LVData nameData, int clanID, int allyId)
{
    local Texture ClanCrest, AllyCrest;
    local bool bClan, bAlly;

    bClan = (clanID > 0) && Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(clanID, ClanCrest);
    bAlly = (allyId > 0) && Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(allyId, AllyCrest);
    nameData.hasIcon = true;
    // End:0xEB
    if(bAlly && bClan)
    {
        nameData.arrTexture.Length = 3;
        SetLvCrest(nameData, 0, AllyCrest, 3, 8);
        SetLvCrest(nameData, 1, ClanCrest, 11, 16);
        SetLvCrest(nameData, 2, GetTexture("L2UI_CT1.EmptyBtn"), 0, 2);
        nameData.FirstLineOffsetX = 30;
        return;
    }
    // End:0x14E
    if(bAlly)
    {
        nameData.arrTexture.Length = 2;
        SetLvCrest(nameData, 0, AllyCrest, 3, 8);
        SetLvCrest(nameData, 1, GetTexture("L2UI_CT1.EmptyBtn"), 0, 2);
        nameData.FirstLineOffsetX = 15;
        return;
    }
    // End:0x1B1
    if(bClan)
    {
        nameData.arrTexture.Length = 2;
        SetLvCrest(nameData, 0, ClanCrest, 3, 16);
        SetLvCrest(nameData, 1, GetTexture("L2UI_CT1.EmptyBtn"), 0, 2);
        nameData.FirstLineOffsetX = 22;
        return;
    }
    nameData.arrTexture.Length = 1;
    SetLvCrest(nameData, 0, GetTexture("L2UI_CT1.EmptyBtn"), 0, 6);
    nameData.FirstLineOffsetX = 2;
    return;
}

function SetLvCrest(out LVData Data, int Index, Texture t, int X, int W)
{
    Data.arrTexture[Index].objTex = t;
    Data.arrTexture[Index].X = X;
    Data.arrTexture[Index].Y = 0;
    Data.arrTexture[Index].Width = W;
    Data.arrTexture[Index].Height = 12;
    Data.arrTexture[Index].U = 0;
    Data.arrTexture[Index].V = 4;
    return;
}

function AddClanRecord(ListCtrlHandle RankingList, int Rank, int clanID, int Level, int MembersCount, int ClanGearScore, string ClanName, string LeaderName, int allyId, int MyClanId)
{
    local LVDataRecord Record;
    local LVData RankData, PointData, nameData, LeaderData, LevelData, MembersData;

    local bool bMine;

    Record.LVDataList.Length = GetCurrentColumnCount();
    bMine = (MyClanId > 0) && clanID == MyClanId;
    SetRankCellData(RankData, Rank);
    PointData.szData = MakeCostString(string(ClanGearScore));
    PointData.textAlignment = 2;
    PointData.bUseTextColor = true;
    PointData.TextColor = GetGearScoreTierColor((ClanGearScore));
    PointData.HiddenStringForSorting = string(ClanGearScore);
    nameData.szData = ClanName;
    nameData.bUseTextColor = true;
    // End:0xE0
    if(bMine)
    {
        nameData.TextColor = GetColor(255, 215, 120, 255);        
    }
    else
    {
        nameData.TextColor = GetColor(220, 220, 220, 255);
    }
    nameData.HiddenStringForSorting = ClanName;
    SetNameCrests(nameData, clanID, allyId);
    LeaderData.szData = LeaderName;
    LeaderData.HiddenStringForSorting = LeaderName;
    LevelData.szData = string(Level);
    LevelData.textAlignment = 2;
    LevelData.HiddenStringForSorting = string(Level);
    MembersData.szData = string(MembersCount);
    MembersData.textAlignment = 2;
    MembersData.HiddenStringForSorting = string(MembersCount);
    Record.szReserved = ClanName;
    Record.nReserved1 = (clanID);
    Record.LVDataList[0] = RankData;
    Record.LVDataList[1] = PointData;
    Record.LVDataList[2] = nameData;
    Record.LVDataList[3] = LeaderData;
    Record.LVDataList[4] = LevelData;
    Record.LVDataList[5] = MembersData;
    RankingList.InsertRecord(Record);
    return;
}

function AddRosterRecord(ListCtrlHandle RankingList, int Position, string charName, int CharLevel, int ClassID, int GearScore, bool bOutside)
{
    local LVDataRecord Record;
    local LVData RankData, PointData, nameData, ClassData, statusData, EmptyData;

    local bool bMine;

    Record.LVDataList.Length = GetCurrentColumnCount();
    bMine = (MyName != "") && charName ~= MyName;
    RankData.szData = string(Position);
    RankData.bUseTextColor = true;
    RankData.TextColor = GetColor(170, 153, 119, 255);
    RankData.textAlignment = 2;
    RankData.HiddenStringForSorting = string(Position);
    PointData.szData = MakeCostString(string(GearScore));
    PointData.textAlignment = 2;
    PointData.bUseTextColor = true;
    PointData.TextColor = GetGearScoreTierColor((GearScore));
    PointData.HiddenStringForSorting = string(GearScore);
    nameData.szData = ((charName $ " (Lv.") $ string(CharLevel)) $ ")";
    nameData.bUseTextColor = true;
    // End:0x13F
    if(bMine)
    {
        nameData.TextColor = GetColor(255, 215, 120, 255);        
    }
    else
    {
        nameData.TextColor = GetColor(220, 220, 220, 255);
    }
    nameData.FirstLineOffsetX = 6;
    nameData.HiddenStringForSorting = charName;
    ClassData.szData = "";
    ClassData.szReserved = GetClassType(ClassID);
    ClassData.szTexture = GetRankingClassIconTexture(ClassID);
    ClassData.nTextureWidth = 31;
    ClassData.nTextureHeight = 42;
    ClassData.textAlignment = 2;
    ClassData.nReserved1 = ClassID;
    ClassData.HiddenStringForSorting = GetClassType(ClassID);
    // End:0x243
    if(bOutside)
    {
        statusData.szData = GetSystemString(9066);
        statusData.bUseTextColor = true;
        statusData.TextColor = GetColor(128, 128, 128, 255);        
    }
    else
    {
        statusData.szData = "";
    }
    statusData.textAlignment = 2;
    EmptyData.szData = "";
    Record.szReserved = charName;
    Record.nReserved1 = (0);
    Record.LVDataList[0] = RankData;
    Record.LVDataList[1] = PointData;
    Record.LVDataList[2] = nameData;
    Record.LVDataList[3] = ClassData;
    Record.LVDataList[4] = statusData;
    Record.LVDataList[5] = EmptyData;
    RankingList.InsertRecord(Record);
    return;
}

function AddCutoffSeparator(ListCtrlHandle RankingList, int Cutoff)
{
    local LVDataRecord Record;
    local LVData Empty, LINE;
    local int i;

    Record.LVDataList.Length = GetCurrentColumnCount();
    i = 0;
    J0x19:

    // End:0x56 [Loop If]
    if(i < (GetCurrentColumnCount()))
    {
        Empty.szData = "";
        Record.LVDataList[i] = Empty;
        i++;
        // [Loop Continue]
        goto J0x19;
    }
    LINE.szData = (("---------- " $ GetSystemString(9065)) $ string(Cutoff)) $ " ----------";
    LINE.bUseTextColor = true;
    LINE.TextColor = GetColor(128, 128, 128, 255);
    LINE.textAlignment = 2;
    Record.LVDataList[2] = LINE;
    Record.nReserved1 = (0);
    RankingList.InsertRecord(Record);
    return;
}

function string GetRankTexture(int Rank)
{
    switch(Rank)
    {
        // End:0x31
        case 1:
            return "UI_BOHPTS.RankingWnd.RankingWnd_1st";
        // End:0x5C
        case 2:
            return "UI_BOHPTS.RankingWnd.RankingWnd_2nd";
        // End:0x87
        case 3:
            return "UI_BOHPTS.RankingWnd.RankingWnd_3rd";
        // End:0xFFFF
        default:
            return "";
            break;
    }
    return;
}

function string GetRankingClassIconTexture(int ClassID)
{
    // End:0x42
    if(ClassID > 0)
    {
        return ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(ClassID)) $ "_Big";
    }
    return GetClassRoleIconName(ClassID);
    return;
}
