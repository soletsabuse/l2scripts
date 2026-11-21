class EssenceMainDesc extends UICommonAPI;

const TEMP_DISABLE = 0;
const ELEMENT_COUNT = 7;
const DEFAULT_BUTTON_HEIGHT = 52;
const BOTTOM_BUTTON_HEIGHT = 24;
const BUTTON_RESET_OFFSET = -3;
const EXPAND_OFFSET = 249;
const SPECIAL_OFFSET = 50;
const ATTRIBUTE_FIRE = 0;
const ATTRIBUTE_WATER = 1;
const ATTRIBUTE_WIND = 2;
const ATTRIBUTE_EARTH = 3;
const ATTRIBUTE_HOLY = 4;
const ATTRIBUTE_UNHOLY = 5;

var int MainWindow_Y;
var int ATTR_MAX_FIRE;
var int ATTR_MAX_WATER;
var int ATTR_MAX_WIND;
var int ATTR_MAX_EARTH;
var int ATTR_MAX_HOLY;
var int ATTR_MAX_UNHOLY;
var string sZoneIDglobal;
var INT64 Count;
var INT64 Level;
var float ostatok;
var int MAX_FOR_LEVEL;
var INT64 RandCount;
var int RandLevel;
var int Randostatok;
var int MAX_FOR_LEVEL_RAND;
var string ClubBuffBypass;
var int ViewState;
var WindowHandle Me;
var ItemID collectionId;
var ItemID LampID;
var ItemID RandomID;
var TextBoxHandle AttrLevelTxt;
var TextureHandle LampIcon;
var TextureHandle ElementIcon;
var TextureHandle TimezoneIcon;
var TextureHandle AstroIcon;
var ButtonHandle VitalityBtn;
var ButtonHandle LampBtn;
var ButtonHandle ElementBtn;
var ButtonHandle RandomBtn;
var ButtonHandle TimezoneBtn;
var ButtonHandle AstroBtn;
var ButtonHandle RankingBtn;
var ButtonHandle SystemBtn;
var TextBoxHandle ElementTxt;
var TextureHandle MainElement;
var StatusBarHandle AttrStatusBar;
var TextBoxHandle LampTxt;
var TextureHandle iLampIcon;
var StatusBarHandle LampBar;
var TextBoxHandle RandomTxt;
var TextureHandle iRandomIcon;
var StatusBarHandle RandomBar;
var ButtonHandle ShowHideBtn;
var ItemWindowHandle Inventory;
var ItemWindowHandle quest;
var ItemWindowHandle rHand;
var WindowHandle ClanSearchWnd;
var WindowHandle RandomWnd;
var bool VitalityEnable;
var bool LampEnable;
var bool RandomEnable;
var bool AttributeEnable;
var bool bButtonDrag;
var Rect rectWndLDowned;
var WindowHandle MissionCount;
var TextureHandle CountBg;
var TextureHandle NumTx;
var TextureHandle PlusTx;
var int nToDoRewardMissionCount;

function OnLoad()
{
    Me = GetWindowHandle("EssenceMainDesc");
    MissionCount = GetWindowHandle("EssenceMainDesc.MissionCount");
    NumTx = GetTextureHandle("EssenceMainDesc.MissionCount.NumTx");
    PlusTx = GetTextureHandle("EssenceMainDesc.MissionCount.PlusTx");
    LampIcon = GetTextureHandle("EssenceMainDesc.LampIcon");
    ElementIcon = GetTextureHandle("EssenceMainDesc.ElementIcon");
    TimezoneIcon = GetTextureHandle("EssenceMainDesc.TimezoneIcon");
    AstroIcon = GetTextureHandle("EssenceMainDesc.AstroIcon");
    VitalityBtn = GetButtonHandle("EssenceMainDesc.VitalityBtn");
    LampBtn = GetButtonHandle("EssenceMainDesc.LampBtn");
    ElementBtn = GetButtonHandle("EssenceMainDesc.ElementBtn");
    RandomBtn = GetButtonHandle("EssenceMainDesc.RandomBtn");
    TimezoneBtn = GetButtonHandle("EssenceMainDesc.TimezoneBtn");
    AstroBtn = GetButtonHandle("EssenceMainDesc.AstroBtn");
    RankingBtn = GetButtonHandle("EssenceMainDesc.RankingBtn");
    SystemBtn = GetButtonHandle("EssenceMainDesc.SystemBtn");
    ShowHideBtn = GetButtonHandle("EssenceMainDesc.ShowHideBtn");
    RandomBar = GetStatusBarHandle("RandomWnd.RandomBar");
    iRandomIcon = GetTextureHandle("RandomWnd.RandomIcon");
    RandomTxt = GetTextBoxHandle("RandomWnd.RandomTxt");
    Inventory = GetItemWindowHandle("InventoryWnd.InventoryItem");
    quest = GetItemWindowHandle("InventoryWnd.QuestItem");
    ClanSearchWnd = GetWindowHandle("ClanSearchWnd");
    RandomWnd = GetWindowHandle("RandomWnd");
    nToDoRewardMissionCount = 0;
    collectionId.ClassID = 1;
    HideUnusedElement();
    return;
}

function OnShow()
{
    ViewState = GetOptionInt("SideBar", "ShowMinimize");
    DescState(ViewState);
    return;
}

function OnDefaultPosition()
{
    ReAnchorSideWindows();
    return;
}

function HideUnusedElement()
{
    local int OpenElement, CloseElement, i;
    local array<string> ElementIdxArr;

    ElementIdxArr.Remove(0, ElementIdxArr.Length);
    ResetElementSize();
    RefreshINIPrefixed("settings.ini");
    // End:0x64
    if(SettingSectorBool("COLLECTION", "COLLECION_UI"))
    {
        CloseElement = Split("7", ";", ElementIdxArr);        
    }
    else
    {
        CloseElement = Split("6;7", ";", ElementIdxArr);
    }
    // End:0xEC
    if(GetOptionInt("L2", "CustomServerType") == 1)
    {
        ElementIdxArr[ElementIdxArr.Length] = "4";
        CloseElement = CloseElement + 1;
        HideW("AutomaticPlay");
        SetOptionBool("SideBar", "Autoplay", false);
    }
    OpenElement = (7 - CloseElement) + 1;
    // End:0x11E
    if(Class'Interface.ReleaseGate'.static.RankingEnabled())
    {
        OpenElement = OpenElement + 1;
    }
    // End:0x14D
    if(OpenElement > 0)
    {
        MainWindow_Y = ((OpenElement * 52) + 24) + (-3 * OpenElement);        
    }
    else
    {
        DescState(1);
        return;
    }
    Me.SetWindowSize(54, MainWindow_Y);
    VitalityEnable = true;
    LampEnable = true;
    RandomEnable = true;
    AttributeEnable = true;
    i = 0;
    J0x193:

    // End:0x7B8 [Loop If]
    if(i < ElementIdxArr.Length)
    {
        switch(int(ElementIdxArr[i]))
        {
            // End:0x2A0
            case 1:
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.VitalityBtn", 52, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.VitalityBtn", "EssenceMainDesc", "TopLeft", "TopLeft", 0, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.VitalityIcon", 32, 0);
                HideW("ClanSearchWnd");
                SetOptionBool("SideBar", "Vitality", false);
                VitalityEnable = false;
                // End:0x7AE
                break;
            // End:0x379
            case 2:
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.LampBtn", 52, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.LampBtn", "EssenceMainDesc.VitalityBtn", "BottomLeft", "TopLeft", 0, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.LampIcon", 32, 0);
                SetOptionBool("SideBar", "Lamp", false);
                LampEnable = false;
                // End:0x7AE
                break;
            // End:0x45B
            case 3:
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ElementBtn", 52, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.ElementBtn", "EssenceMainDesc.LampBtn", "BottomLeft", "TopLeft", 0, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ElementIcon", 32, 0);
                SetOptionBool("SideBar", "Autoplay", false);
                AttributeEnable = false;
                // End:0x7AE
                break;
            // End:0x549
            case 4:
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.RandomBtn", 52, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.RandomBtn", "EssenceMainDesc.ElementBtn", "BottomLeft", "TopLeft", 0, 0);
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("EssenceMainDesc.RandomIcon");
                HideW("RandomWnd");
                SetOptionBool("SideBar", "Random", false);
                RandomEnable = false;
                // End:0x7AE
                break;
            // End:0x632
            case 5:
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.TimezoneBtn", 52, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.TimezoneBtn", "EssenceMainDesc.RandomBtn", "BottomLeft", "TopLeft", 0, 0);
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("EssenceMainDesc.TimezoneIcon");
                HideW("RadioWnd");
                SetOptionBool("SideBar", "Radio", false);
                // End:0x7AE
                break;
            // End:0x6F0
            case 6:
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.AstroBtn", 52, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.AstroBtn", "EssenceMainDesc.TimezoneBtn", "BottomLeft", "TopLeft", 0, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.AstroIcon", 32, 0);
                // End:0x7AE
                break;
            // End:0x7A8
            case 7:
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ShopBtn", 52, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.ShopBtn", "EssenceMainDesc.AstroBtn", "BottomLeft", "TopLeft", 0, 0);
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ShopIcon", 32, 0);
                // End:0x7AE
                break;
            // End:0xFFFF
            default:
                // End:0x7AE
                break;
                break;
        }
        i++;
        // [Loop Continue]
        goto J0x193;
    }
    // End:0x83E
    if(SettingSectorBool("COLLECTION", "COLLECION_UI"))
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.RankingBtn", "EssenceMainDesc.AstroBtn", "BottomLeft", "TopLeft", 0, -3);        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.RankingBtn", "EssenceMainDesc.TimezoneBtn", "BottomLeft", "TopLeft", 0, -3);
    }
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.SystemBtn", "EssenceMainDesc.RankingBtn", "BottomLeft", "TopLeft", 0, -3);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.CloseAllBtn", "EssenceMainDesc.SystemBtn", "BottomLeft", "BottomLeft", 0, 23);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.ShowHideBtn", "EssenceMainDesc.SystemBtn", "BottomLeft", "BottomLeft", 26, 23);
    HideW("EssenceMainDesc.ExpandBtn");
    HideW("EssenceMainDesc.ExpandIcon");
    ShowHideBtn.SetTexture("L2_UI8.interfacenew1.SideBar_Btn_Reduce_n", "L2_UI8.interfacenew1.SideBar_Btn_Reduce_n", "L2_UI8.interfacenew1.SideBar_Btn_Reduce_o");
    return;
}

function DescState(int State)
{
    // End:0x863
    if(State == 1)
    {
        Me.SetWindowSize(54, 72);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.VitalityBtn", 52, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.VitalityBtn", "EssenceMainDesc", "TopLeft", "TopLeft", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.VitalityIcon", 32, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.LampBtn", 52, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.LampBtn", "EssenceMainDesc.VitalityBtn", "BottomLeft", "TopLeft", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.LampIcon", 32, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ElementBtn", 52, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.ElementBtn", "EssenceMainDesc.LampBtn", "BottomLeft", "TopLeft", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ElementIcon", 32, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.RandomBtn", 52, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.RandomBtn", "EssenceMainDesc.ElementBtn", "BottomLeft", "TopLeft", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("EssenceMainDesc.RandomIcon");
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.TimezoneBtn", 52, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.TimezoneBtn", "EssenceMainDesc.RandomBtn", "BottomLeft", "TopLeft", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("EssenceMainDesc.TimezoneIcon");
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.AstroBtn", 52, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.AstroBtn", "EssenceMainDesc.TimezoneBtn", "BottomLeft", "TopLeft", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.AstroIcon", 32, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ShopBtn", 52, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.ShopBtn", "EssenceMainDesc.AstroBtn", "BottomLeft", "TopLeft", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ShopIcon", 32, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.RankingBtn", 52, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.RankingBtn", "EssenceMainDesc.ShopBtn", "BottomLeft", "TopLeft", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.RankingIcon", 40, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.SystemBtn", 52, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.SystemBtn", "EssenceMainDesc.RankingBtn", "BottomLeft", "TopLeft", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.SystemIcon", 28, 0);
        HideW("EssenceMainDesc.SystemBtn");
        HideW("EssenceMainDesc.SystemIcon");
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.CloseAllBtn", "EssenceMainDesc.ExpandBtn", "BottomLeft", "BottomLeft", 0, 23);
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.ShowHideBtn", "EssenceMainDesc.ExpandBtn", "BottomLeft", "BottomLeft", 26, 23);
        CloseAll();
        showHideMissionCount(false);
        ShowW("EssenceMainDesc.ExpandBtn");
        ShowW("EssenceMainDesc.ExpandIcon");
        ShowHideBtn.SetTexture("L2_UI8.interfacenew1.SideBar_Btn_Open_n", "L2_UI8.interfacenew1.SideBar_Btn_Open_n", "L2_UI8.interfacenew1.SideBar_Btn_Open_o");        
    }
    else
    {
        HideUnusedElement();
        showHideMissionCount(true);
    }
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(150);
    RegisterEvent(3550);
    RegisterEvent(160);
    RegisterEvent(20177);
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1B
        case 150:
            CheckButtonTexture();
            SaveLoad();
            // End:0x3F
            break;
        // End:0x23
        case 160:
            // End:0x3F
            break;
        // End:0x39
        case 20177:
            updateCurrentMissonCount(a_Param);
            // End:0x3F
            break;
        // End:0xFFFF
        default:
            // End:0x3F
            break;
            break;
    }
    return;
}

function updateCurrentMissonCount(string a_Param)
{
    ParseInt(a_Param, "rewardCount", nToDoRewardMissionCount);
    refreshCurrentMissonCount(nToDoRewardMissionCount);
    return;
}

function refreshCurrentMissonCount(int nToDoRewardMissionCount)
{
    local string param;

    MissionCount.ShowWindow();
    // End:0x48
    if(nToDoRewardMissionCount > 9)
    {
        nToDoRewardMissionCount = 9;
        CountBg.SetWindowSize(28, 16);
        PlusTx.ShowWindow();        
    }
    else
    {
        // End:0x78
        if(nToDoRewardMissionCount > 0)
        {
            CountBg.SetWindowSize(24, 16);
            PlusTx.HideWindow();            
        }
        else
        {
            MissionCount.HideWindow();
        }
    }
    NumTx.SetTexture("L2UI_CT1.ItemCountNum_" $ string(nToDoRewardMissionCount));
    showHideMissionCount((nToDoRewardMissionCount > 0) && ViewState == 0);
    param = "";
    ParamAdd(param, "rewardCount", string(nToDoRewardMissionCount));
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButtonWithParam(int(NoticeWnd(GetScript("NoticeWnd")).18), 3670, param);
    return;
}

function showHideMissionCount(bool B)
{
    // End:0x47
    if(B)
    {
        // End:0x35
        if(nToDoRewardMissionCount > 0)
        {
            MissionCount.ShowWindow();
            MissionCount.BringToFront();            
        }
        else
        {
            MissionCount.HideWindow();
        }        
    }
    else
    {
        MissionCount.HideWindow();
    }
    return;
}

function OnClickButton(string a_ControlID)
{
    local int i;
    local string strParam;
    local Rect Rect;

    // End:0x0B
    if(CheckDrag())
    {
        return;
    }
    Rect = Me.GetRect();
    // End:0x7B
    if(a_ControlID == "VitalityBtn")
    {
        SetOptionBool("SideBar", "PartyMatchWnd", !IsShow("PartyMatchWnd"));
        Class'NWindow.PartyMatchAPI'.static.RequestOpenPartyMatch();
    }
    // End:0x107
    if(a_ControlID == "LampBtn")
    {
        // End:0xD8
        if(IsShow("ClanSearchWnd"))
        {
            HideW("ClanSearchWnd");
            SetOptionBool("SideBar", "Vitality", false);            
        }
        else
        {
            ShowW("ClanSearchWnd");
            SetOptionBool("SideBar", "Vitality", true);
        }
    }
    // End:0x16D
    if(a_ControlID == "ElementBtn")
    {
        SetOptionBool("SideBar", "Lamp", !IsShow("ToDoListClanWnd"));
        getInstanceL2Util().toggleWindow("ToDoListClanWnd", true);
    }
    // End:0x1D2
    if(a_ControlID == "RandomBtn")
    {
        SetOptionBool("SideBar", "Autoplay", !IsShow("AutomaticPlay"));
        getInstanceL2Util().toggleWindow("AutomaticPlay", true);
    }
    // End:0x24F
    if(a_ControlID == "TimezoneBtn")
    {
        // End:0x228
        if(!IsShowWindow("RadioWnd"))
        {
            ShowW("RadioWnd");
            SetOptionBool("SideBar", "Radio", true);            
        }
        else
        {
            HideW("RadioWnd");
            SetOptionBool("SideBar", "Radio", false);
        }
    }
    // End:0x2A4
    if(a_ControlID == "AstroBtn")
    {
        // End:0x28F
        if(!IsShowWindow("CollectionWnd"))
        {
            RequestBypassToServer("coll_ui");            
        }
        else
        {
            HideW("CollectionWnd");
        }
    }
    // End:0x305
    if(a_ControlID == "RankingBtn")
    {
        // End:0x2E4
        if(IsShowWindow("RankingWnd"))
        {
            HideW("RankingWnd");            
        }
        else
        {
            RankingWnd(GetScript("RankingWnd")).OpenByCommand();
        }
    }
    // End:0x36B
    if(a_ControlID == "SystemBtn")
    {
        // End:0x352
        if(IsShow("PlayerGameplayWnd"))
        {
            HideW("PlayerGameplayWnd");            
        }
        else
        {
            ShowW("PlayerGameplayWnd");
        }
    }
    // End:0x40B
    if(a_ControlID == "ShowHideBtn")
    {
        // End:0x3C5
        if(ViewState == 0)
        {
            ViewState = 1;
            Me.MoveTo(Rect.nX, (Rect.nY + MainWindow_Y) - 72);            
        }
        else
        {
            ViewState = 0;
            Me.MoveTo(Rect.nX, (Rect.nY - MainWindow_Y) + 72);
            SaveLoad();
        }
        DescState(ViewState);
    }
    // End:0x466
    if(a_ControlID == "ExpandBtn")
    {
        ViewState = 0;
        DescState(ViewState);
        Me.MoveTo(Rect.nX, (Rect.nY - MainWindow_Y) + 72);
        SaveLoad();
    }
    // End:0x4FE
    if(a_ControlID == "CloseAllBtn")
    {
        CloseAll();
        SetOptionBool("SideBar", "Element", false);
        SetOptionBool("SideBar", "Vitality", false);
        SetOptionBool("SideBar", "Autoplay", false);
        SetOptionBool("SideBar", "Random", false);
        SetOptionBool("SideBar", "Lamp", false);
    }
    SetOptionInt("SideBar", "ShowMinimize", ViewState);
    CheckButtonTexture();
    FocusBuggedElement();
    ini(1);
    return;
}

function string ReturnRadialBar(int Percent)
{
    // End:0x12
    if(Percent < 0)
    {
        Percent = 0;
    }
    // End:0x26
    if(Percent > 100)
    {
        Percent = 100;
    }
    // End:0x5F
    if(Percent == 100)
    {
        return "L2_UI8.interfacenew1.circle_progress100";        
    }
    else
    {
        // End:0x70
        if(Percent == 0)
        {
            return "";            
        }
        else
        {
            // End:0xB0
            if(Percent < 10)
            {
                return "L2_UI8.interfacenew1.circle_progress0" $ string(Percent);                
            }
            else
            {
                return "L2_UI8.interfacenew1.circle_progress" $ string(Percent);
            }
        }
    }
    return;
}

function CloseAll()
{
    return;
}

function CheckButtonTexture()
{
    CheckByType(0);
    CheckByType(1);
    CheckByType(2);
    CheckByType(3);
    return;
}

function CheckByType(int nType)
{
    switch(nType)
    {
        // End:0x127
        case 0:
            // End:0xA5
            if(IsShow("PartyMatchWnd"))
            {
                VitalityBtn.SetTexture("L2_UI8.interfacenew.sidebar_active", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");                
            }
            else
            {
                VitalityBtn.SetTexture("L2_UI8.interfacenew.sidebar_normal", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");
            }
            // End:0x797
            break;
        // End:0x247
        case 1:
            // End:0x1C5
            if(IsShow("ClanSearchWnd"))
            {
                LampBtn.SetTexture("L2_UI8.interfacenew.sidebar_active", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");                
            }
            else
            {
                LampBtn.SetTexture("L2_UI8.interfacenew.sidebar_normal", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");
            }
            // End:0x797
            break;
        // End:0x36A
        case 2:
            // End:0x2E8
            if(IsShow("ToDoListClanWnd"))
            {
                ElementBtn.SetTexture("L2_UI8.interfacenew.sidebar_active", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");                
            }
            else
            {
                ElementBtn.SetTexture("L2_UI8.interfacenew.sidebar_normal", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");
            }
            // End:0x797
            break;
        // End:0x554
        case 3:
            // End:0x409
            if(IsShow("AutomaticPlay"))
            {
                RandomBtn.SetTexture("L2_UI8.interfacenew.sidebar_active", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");                
            }
            else
            {
                RandomBtn.SetTexture("L2_UI8.interfacenew.sidebar_normal", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");
            }
            // End:0x4FF
            if(GetOptionBool("SideBar", "AutoplayEnabled"))
            {
                GetTextureHandle("EssenceMainDesc.RandomIcon").SetTexture("UI_BOHPTS.SideBar.SideBarAutoPlayON");                
            }
            else
            {
                GetTextureHandle("EssenceMainDesc.RandomIcon").SetTexture("UI_BOHPTS.SideBar.SideBarAutoPlayOFF");
            }
            // End:0x797
            break;
        // End:0x670
        case 4:
            // End:0x5EE
            if(IsShow("RadioWnd"))
            {
                TimezoneBtn.SetTexture("L2_UI8.interfacenew.sidebar_active", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");                
            }
            else
            {
                TimezoneBtn.SetTexture("L2_UI8.interfacenew.sidebar_normal", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");
            }
            // End:0x797
            break;
        // End:0x791
        case 5:
            // End:0x70F
            if(IsShow("CollectionWnd"))
            {
                AstroBtn.SetTexture("L2_UI8.interfacenew.sidebar_active", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");                
            }
            else
            {
                AstroBtn.SetTexture("L2_UI8.interfacenew.sidebar_normal", "L2_UI8.interfacenew.sidebar_hover", "L2_UI8.interfacenew.sidebar_activehover");
            }
            // End:0x797
            break;
        // End:0xFFFF
        default:
            // End:0x797
            break;
            break;
    }
    return;
}

function FocusBuggedElement()
{
    FocusW("EssenceMainDesc.VitalityIcon");
    FocusW("EssenceMainDesc.LampIcon");
    FocusW("EssenceMainDesc.MissionCount");
    FocusW("EssenceMainDesc.ElementIcon");
    FocusW("EssenceMainDesc.TimezoneIcon");
    FocusW("EssenceMainDesc.AstroIcon");
    FocusW("EssenceMainDesc.ShopIcon");
    return;
}

function SetDraggableSideWindows()
{
    RandomWnd.ClearAnchor();
    RandomWnd.SetDraggable(true);
    return;
}

function ReAnchorSideWindows()
{
    RandomWnd.SetAnchor("EssenceMainDesc", "TopLeft", "TopLeft", -169, 196);
    RandomWnd.SetDraggable(false);
    return;
}

function ResetElementSize()
{
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.VitalityIcon", 32, 32);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.VitalityBtn", 52, 52);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.VitalityBtn", "EssenceMainDesc", "TopLeft", "TopLeft", 0, -3);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.LampBtn", 52, 52);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.LampBtn", "EssenceMainDesc.VitalityBtn", "BottomLeft", "TopLeft", 0, -3);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.LampIcon", 32, 32);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ElementBtn", 52, 52);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.ElementBtn", "EssenceMainDesc.LampBtn", "BottomLeft", "TopLeft", 0, -3);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ElementIcon", 32, 32);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.RandomBtn", 52, 52);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.RandomBtn", "EssenceMainDesc.ElementBtn", "BottomLeft", "TopLeft", 0, -3);
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("EssenceMainDesc.RandomIcon");
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.TimezoneBtn", 52, 52);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.TimezoneBtn", "EssenceMainDesc.RandomBtn", "BottomLeft", "TopLeft", 0, -3);
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("EssenceMainDesc.TimezoneIcon");
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.AstroBtn", 52, 52);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.AstroBtn", "EssenceMainDesc.TimezoneBtn", "BottomLeft", "TopLeft", 0, -3);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.AstroIcon", 32, 32);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ShopBtn", 52, 52);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.ShopBtn", "EssenceMainDesc.AstroBtn", "BottomLeft", "TopLeft", 0, -3);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.ShopIcon", 32, 32);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.RankingBtn", 52, 52);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.RankingBtn", "EssenceMainDesc.ShopBtn", "BottomLeft", "TopLeft", 0, -3);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.RankingIcon", 40, 40);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.SystemBtn", 52, 52);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("EssenceMainDesc.SystemBtn", "EssenceMainDesc.RankingBtn", "BottomLeft", "TopLeft", 0, -3);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.SystemIcon", 28, 28);
    ShowW("EssenceMainDesc.SystemBtn");
    ShowW("EssenceMainDesc.SystemIcon");
    // End:0x76F
    if(!Class'Interface.ReleaseGate'.static.RankingEnabled())
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("EssenceMainDesc.RankingBtn", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("EssenceMainDesc.RankingBtn");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("EssenceMainDesc.RankingIcon");
    }
    return;
}

function SaveLoad()
{
    // End:0x2C
    if(GetOptionBool("SideBar", "Radio"))
    {
        ShowW("RadioWnd");        
    }
    else
    {
        HideW("RadioWnd");
    }
    return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    rectWndLDowned = Me.GetRect();
    return;
}

function bool CheckDrag()
{
    local Rect rectWnd;

    rectWnd = Me.GetRect();
    return ((GetAbs(rectWndLDowned.nX - rectWnd.nX)) > 5) || (GetAbs(rectWndLDowned.nY - rectWnd.nY)) > 5;
    return;
}
