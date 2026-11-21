class GuideWnd extends UICommonAPI;

const GUIDEICON_SIZE = 30;
const MAX_QUEST_NUM = 500;
const MAX_HUNTINGZONE_NUM = 250;
const MAX_RAID_NUM = 500;
const TIMER_ID = 1;
const TIMER_DELAY = 4000;
const HUNTING_ZONE_TYPE = 0;
const HUNTING_ZONE_FIELDHUTINGZONE = 1;
const HUNTING_ZONE_DUNGEON = 2;
const HUNTING_ZONE_CASTLEVILLE = 3;
const HUNTING_ZONE_HARBOR = 4;
const HUNTING_ZONE_Agit = 5;
const HUNTING_ZONE_COLOSSEUM = 6;
const HUNTING_ZONE_ETCERA = 7;
const ANTARASMONID1 = 29066;
const ANTARASMONID2 = 29067;
const ANTARASMONID3 = 29068;
const REGIONINFO_OFFSETX = 3400;
const REGIONINFO_OFFSETY = 6400;

struct RaidIconData
{
    var array<int> RaidID;
    var array<int> Index;
};

struct RAIDRECORD
{
    var int A;
    var int B;
    var int C;
};

var bool tabLoc;
var string serverMaxRecord;
var int global_i;
var int g_modedID;
var bool bLock;
var array<int> agitid1;
var array<int> agitid2;
var array<int> agitid3;
var string m_WindowName;
var array<RAIDRECORD> RaidRecordList;
var array<string> currentmaprecord;
var array<int> g_CastleID;
var WindowHandle MinimapDrawerWnd;
var ListCtrlHandle m_hQuestListCtrl;
var ListCtrlHandle m_hHuntingZoneListCtrl;
var ListCtrlHandle m_hRaidListCtrl;
var ListCtrlHandle m_hAreaInfoListCtrl;
var ListCtrlHandle m_CastleListCtrl;
var ListCtrlHandle m_FortressListCtrl;
var ListCtrlHandle m_AgitListCtrl;
var ListCtrlHandle m_TerritoryListCtrl;
var TabHandle m_hTabCtrl;
var TabHandle m_hTabCtrl_Exp;
var ComboBoxHandle m_hQuestComboBox;
var WindowHandle m_QuestTab;
var WindowHandle m_HuntTab;
var WindowHandle m_RaidTab;
var WindowHandle m_AreaTab;
var WindowHandle m_SiegeCastleTab;
var WindowHandle m_SiegeFortressTab;
var WindowHandle m_AgitTab;
var WindowHandle m_TerritoryWarTab;
var MinimapCtrlHandle m_MiniMap;
var ButtonHandle ReduceButton;
var ButtonHandle ReduceButton_Expand;
var int m_DominionInfoCnt;
var RaidIconData bossList;
var MinimapWnd m_MiniMapWndScript;
var int TerritoryListSelectedIndex;

function OnRegisterEvent()
{
    RegisterEvent(120);
    RegisterEvent(130);
    RegisterEvent(3140);
    RegisterEvent(3150);
    RegisterEvent(3160);
    RegisterEvent(3170);
    RegisterEvent(3180);
    RegisterEvent(3190);
    RegisterEvent(3200);
    RegisterEvent(3590);
    RegisterEvent(3600);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x2F4
    if(1 == 0)
    {
        m_hQuestListCtrl = ListCtrlHandle(GetHandle("QuestListCtrl"));
        m_hHuntingZoneListCtrl = ListCtrlHandle(GetHandle("HuntingZoneListCtrl"));
        m_hRaidListCtrl = ListCtrlHandle(GetHandle("RaidListCtrl"));
        m_hAreaInfoListCtrl = ListCtrlHandle(GetHandle("AreaInfoListCtrl"));
        m_hTabCtrl = TabHandle(GetHandle("TabCtrl"));
        m_hTabCtrl_Exp = TabHandle(GetHandle("TabCtrl_Exp"));
        m_hQuestComboBox = ComboBoxHandle(GetHandle("QuestComboBox"));
        m_QuestTab = GetHandle("QuestTab");
        m_HuntTab = GetHandle("HuntTab");
        m_RaidTab = GetHandle("RaidTab");
        m_AreaTab = GetHandle("AreaTab");
        m_SiegeCastleTab = GetHandle("SiegeCastleTab");
        m_SiegeFortressTab = GetHandle("SiegeFortressTab");
        m_TerritoryWarTab = GetHandle("TerritoryWarTab");
        m_AgitTab = GetHandle("AgitTab");
        m_MiniMap = MinimapCtrlHandle(GetHandle("MinimapWnd.Minimap"));
        m_CastleListCtrl = ListCtrlHandle(GetHandle("CastleListCtrl"));
        m_FortressListCtrl = ListCtrlHandle(GetHandle("FortressListCtrl"));
        m_AgitListCtrl = ListCtrlHandle(GetHandle("AgitListCtrl"));
        m_TerritoryListCtrl = ListCtrlHandle(GetHandle("TerritoryListCtrl"));
        MinimapDrawerWnd = GetHandle("MiniMapDrawerWnd");
        ReduceButton = ButtonHandle(GetHandle("MinimapWnd.btnReduce"));
        ReduceButton_Expand = ButtonHandle(GetHandle("MinimapWnd_Expand.btnReduce"));
        m_MiniMapWndScript = MinimapWnd(GetScript("MinimapWnd"));        
    }
    else
    {
        m_hQuestListCtrl = GetListCtrlHandle((m_WindowName $ ".") $ "QuestTab.QuestListCtrl");
        m_hHuntingZoneListCtrl = GetListCtrlHandle((m_WindowName $ ".") $ "HuntTab.HuntingZoneListCtrl");
        m_hRaidListCtrl = GetListCtrlHandle((m_WindowName $ ".") $ "RaidTab.RaidListCtrl");
        m_hAreaInfoListCtrl = GetListCtrlHandle((m_WindowName $ ".") $ "AreaTab.AreaInfoListCtrl");
        m_hTabCtrl = GetTabHandle((m_WindowName $ ".") $ "TabCtrl");
        m_hTabCtrl_Exp = GetTabHandle((m_WindowName $ ".") $ "TabCtrl_Exp");
        m_hQuestComboBox = GetComboBoxHandle((m_WindowName $ ".") $ "QuestTab.QuestComboBox");
        m_QuestTab = GetWindowHandle((m_WindowName $ ".") $ "QuestTab");
        m_HuntTab = GetWindowHandle((m_WindowName $ ".") $ "HuntTab");
        m_RaidTab = GetWindowHandle((m_WindowName $ ".") $ "RaidTab");
        m_AreaTab = GetWindowHandle((m_WindowName $ ".") $ "AreaTab");
        m_TerritoryWarTab = GetWindowHandle((m_WindowName $ ".") $ "TerritoryWarTab");
        m_SiegeCastleTab = GetWindowHandle((m_WindowName $ ".") $ "SiegeCastleTab");
        m_SiegeFortressTab = GetWindowHandle((m_WindowName $ ".") $ "SiegeFortressTab");
        m_AgitTab = GetWindowHandle((m_WindowName $ ".") $ "AgitTab");
        m_MiniMap = GetMinimapCtrlHandle("MinimapWnd.Minimap");
        m_CastleListCtrl = GetListCtrlHandle((m_WindowName $ ".") $ "SiegeCastleTab.CastleListCtrl");
        m_FortressListCtrl = GetListCtrlHandle((m_WindowName $ ".") $ "SiegeFortressTab.FortressListCtrl");
        m_AgitListCtrl = GetListCtrlHandle((m_WindowName $ ".") $ "AgitTab.AgitListCtrl");
        m_TerritoryListCtrl = GetListCtrlHandle((m_WindowName $ ".") $ "TerritoryListCtrl");
        MinimapDrawerWnd = GetWindowHandle("MiniMapDrawerWnd");
        ReduceButton = GetButtonHandle("MinimapWnd.btnReduce");
        ReduceButton_Expand = GetButtonHandle("MinimapWnd_Expand.btnReduce");
        m_MiniMapWndScript = MinimapWnd(GetScript("MinimapWnd"));
    }
    SetCastleLocData();
    return;
}

function OnTimer(int TimerID)
{
    // End:0x29
    if(TimerID == 1)
    {
        m_hTabCtrl.EnableWindow();
        m_hTabCtrl_Exp.EnableWindow();
    }
    return;
}

function DisableTabBtn()
{
    m_hOwnerWnd.SetTimer(1, 4000);
    m_hTabCtrl.DisableWindow();
    m_hTabCtrl_Exp.DisableWindow();
    return;
}

function OnShow()
{
    // End:0x21
    if(MinimapDrawerWnd.IsShowWindow())
    {
        MinimapDrawerWnd.HideWindow();
    }
    bLock = false;
    m_hHuntingZoneListCtrl.DeleteAllItem();
    m_hRaidListCtrl.DeleteAllItem();
    m_hAreaInfoListCtrl.DeleteAllItem();
    m_hTabCtrl.InitTabCtrl();
    m_hTabCtrl_Exp.InitTabCtrl();
    LoadQuestList();
    swaptab1();
    m_hQuestComboBox.SetSelectedNum(0);
    m_QuestTab.ShowWindow();
    m_HuntTab.HideWindow();
    m_RaidTab.HideWindow();
    m_AreaTab.HideWindow();
    m_SiegeCastleTab.HideWindow();
    m_SiegeFortressTab.HideWindow();
    m_TerritoryWarTab.HideWindow();
    m_AgitTab.HideWindow();
    return;
}

function OnHide()
{
    local MinimapWnd script;

    script = MinimapWnd(GetScript("MinimapWnd"));
    Class'NWindow.UIAPI_WINDOW'.static.KillUITimer("GuideWnd.RaidTab", 1);
    m_MiniMap.EraseAllRegionInfo();
    bLock = false;
    // End:0x6B
    if(script.m_Dominion == false)
    {
    }
    return;
}

function OnClickButton(string Id)
{
    local int QuestComboCurrentData, QuestComboCurrentReservedData, HuntingZoneComboboxCurrentData, HuntingZoneComboboxCurrentReservedData, RaidCurrentComboboxCurrentReservedData, AreaInfoComboBoxCurrentData,
	    AreaInfoComboBoxCurrentReservedData;

    ReDrawAllIcons();
    // End:0xC6
    if(Id == "TabCtrl0")
    {
        swaptab1();
        LoadQuestList();
        m_hQuestComboBox.SetSelectedNum(0);
        m_QuestTab.ShowWindow();
        m_HuntTab.HideWindow();
        m_RaidTab.HideWindow();
        m_AreaTab.HideWindow();
        m_SiegeCastleTab.HideWindow();
        m_SiegeFortressTab.HideWindow();
        m_AgitTab.HideWindow();
        m_TerritoryWarTab.HideWindow();
        DisableTabBtn();
        m_MiniMap.DeleteAllTarget();        
    }
    else
    {
        // End:0x1A4
        if(Id == "TabCtrl1")
        {
            swaptab1();
            LoadHuntingZoneList();
            Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("GuideWnd.HuntingZoneComboBox", 0);
            m_QuestTab.HideWindow();
            m_HuntTab.ShowWindow();
            m_RaidTab.HideWindow();
            m_AreaTab.HideWindow();
            m_SiegeCastleTab.HideWindow();
            m_SiegeFortressTab.HideWindow();
            m_AgitTab.HideWindow();
            m_TerritoryWarTab.HideWindow();
            m_MiniMap.DeleteAllTarget();
            DisableTabBtn();            
        }
        else
        {
            // End:0x24E
            if(Id == "TabCtrl2")
            {
                swaptab1();
                m_QuestTab.HideWindow();
                m_HuntTab.HideWindow();
                m_RaidTab.ShowWindow();
                m_AreaTab.HideWindow();
                m_SiegeCastleTab.HideWindow();
                m_SiegeFortressTab.HideWindow();
                m_AgitTab.HideWindow();
                m_TerritoryWarTab.HideWindow();
                m_MiniMap.DeleteAllTarget();
                DisableTabBtn();                
            }
            else
            {
                // End:0x329
                if(Id == "TabCtrl3")
                {
                    swaptab1();
                    m_QuestTab.HideWindow();
                    m_HuntTab.HideWindow();
                    m_RaidTab.HideWindow();
                    m_AreaTab.ShowWindow();
                    m_SiegeCastleTab.HideWindow();
                    m_SiegeFortressTab.HideWindow();
                    m_TerritoryWarTab.HideWindow();
                    m_AgitTab.HideWindow();
                    LoadAreaInfoList();
                    m_MiniMap.DeleteAllTarget();
                    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("GuideWnd.AreaInfoComboBox", 0);
                    DisableTabBtn();                    
                }
                else
                {
                    // End:0x3FB
                    if(Id == "TabCtrl_Exp0")
                    {
                        swaptab2();
                        m_QuestTab.HideWindow();
                        m_HuntTab.HideWindow();
                        m_RaidTab.HideWindow();
                        m_AreaTab.HideWindow();
                        m_TerritoryWarTab.ShowWindow();
                        m_SiegeCastleTab.HideWindow();
                        m_SiegeFortressTab.HideWindow();
                        m_AgitTab.HideWindow();
                        m_MiniMap.DeleteAllTarget();
                        m_CastleListCtrl.DeleteAllItem();
                        m_TerritoryListCtrl.DeleteAllItem();
                        RequestDominionInfo();
                        DisableTabBtn();                        
                    }
                    else
                    {
                        // End:0x4D6
                        if(Id == "TabCtrl_Exp1")
                        {
                            swaptab2();
                            m_QuestTab.HideWindow();
                            m_HuntTab.HideWindow();
                            m_RaidTab.HideWindow();
                            m_AreaTab.HideWindow();
                            m_SiegeCastleTab.ShowWindow();
                            m_SiegeFortressTab.HideWindow();
                            m_TerritoryWarTab.HideWindow();
                            m_AgitTab.HideWindow();
                            m_MiniMap.DeleteAllTarget();
                            m_CastleListCtrl.DeleteAllItem();
                            m_TerritoryListCtrl.DeleteAllItem();
                            m_MiniMapWndScript.RequestRedrawCastle();
                            DisableTabBtn();                            
                        }
                        else
                        {
                            // End:0x5B9
                            if(Id == "TabCtrl_Exp2")
                            {
                                swaptab2();
                                m_QuestTab.HideWindow();
                                m_HuntTab.HideWindow();
                                m_RaidTab.HideWindow();
                                m_AreaTab.HideWindow();
                                m_SiegeCastleTab.HideWindow();
                                m_SiegeFortressTab.ShowWindow();
                                m_TerritoryWarTab.HideWindow();
                                m_AgitTab.HideWindow();
                                bLock = true;
                                m_FortressListCtrl.DeleteAllItem();
                                m_TerritoryListCtrl.DeleteAllItem();
                                m_MiniMapWndScript.RequestRedrawFortress();
                                m_MiniMap.DeleteAllTarget();
                                DisableTabBtn();                                
                            }
                            else
                            {
                                // End:0x690
                                if(Id == "TabCtrl_Exp3")
                                {
                                    swaptab2();
                                    m_QuestTab.HideWindow();
                                    m_HuntTab.HideWindow();
                                    m_RaidTab.HideWindow();
                                    m_AreaTab.HideWindow();
                                    m_SiegeCastleTab.HideWindow();
                                    m_SiegeFortressTab.HideWindow();
                                    m_TerritoryWarTab.HideWindow();
                                    m_AgitTab.ShowWindow();
                                    bLock = true;
                                    m_AgitListCtrl.DeleteAllItem();
                                    m_TerritoryListCtrl.DeleteAllItem();
                                    AgitInfo();
                                    m_MiniMap.DeleteAllTarget();
                                    DisableTabBtn();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    RequestRaidRecord();
    // End:0x6E7
    if(Id == "btn_search1")
    {
        QuestComboCurrentData = m_hQuestComboBox.GetSelectedNum();
        QuestComboCurrentReservedData = m_hQuestComboBox.GetReserved(QuestComboCurrentData);
        LoadQuestSearchResult(QuestComboCurrentReservedData);
    }
    // End:0x774
    if(Id == "btn_search2")
    {
        HuntingZoneComboboxCurrentData = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("GuideWnd.HuntingZoneComboBox");
        HuntingZoneComboboxCurrentReservedData = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("GuideWnd.HuntingZoneComboBox", HuntingZoneComboboxCurrentData);
        LoadHuntingZoneListSearchResult(HuntingZoneComboboxCurrentReservedData);
    }
    // End:0x796
    if(Id == "btn_search3")
    {
        LoadRaidSearchResult(RaidCurrentComboboxCurrentReservedData);
    }
    // End:0x81D
    if(Id == "btn_search4")
    {
        AreaInfoComboBoxCurrentData = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("GuideWnd.AreaInfoComboBox");
        AreaInfoComboBoxCurrentReservedData = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("GuideWnd.AreaInfoComboBox", AreaInfoComboBoxCurrentData);
        LoadAreaInfoListSearchResult(AreaInfoComboBoxCurrentReservedData);
    }
    // End:0x870
    if(Id == "QuestComboBox")
    {
        QuestComboCurrentData = m_hQuestComboBox.GetSelectedNum();
        QuestComboCurrentReservedData = m_hQuestComboBox.GetReserved(QuestComboCurrentData);
        LoadQuestSearchResult(QuestComboCurrentReservedData);
    }
    // End:0x905
    if(Id == "HuntingZoneComboBox")
    {
        HuntingZoneComboboxCurrentData = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("GuideWnd.HuntingZoneComboBox");
        HuntingZoneComboboxCurrentReservedData = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("GuideWnd.HuntingZoneComboBox", HuntingZoneComboboxCurrentData);
        LoadHuntingZoneListSearchResult(HuntingZoneComboboxCurrentReservedData);
    }
    // End:0x940
    if(Id == "CloseButton")
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MinimapWnd.GuideWnd");
    }
    return;
}

function swaptab1()
{
    m_hTabCtrl.ClearAnchor();
    m_hTabCtrl_Exp.ClearAnchor();
    m_hTabCtrl.MoveTo(12, 23);
    m_hTabCtrl_Exp.MoveTo(12, 6);
    m_hTabCtrl.SetAnchor("GuideWnd", "TopLeft", "TopLeft", 12, 23);
    m_hTabCtrl_Exp.SetAnchor("GuideWnd", "TopLeft", "TopLeft", 12, 6);
    return;
}

function swaptab2()
{
    m_hTabCtrl.ClearAnchor();
    m_hTabCtrl_Exp.ClearAnchor();
    m_hTabCtrl.MoveTo(12, 6);
    m_hTabCtrl_Exp.MoveTo(12, 23);
    m_hTabCtrl.SetAnchor("GuideWnd", "TopLeft", "TopLeft", 12, 6);
    m_hTabCtrl_Exp.SetAnchor("GuideWnd", "TopLeft", "TopLeft", 12, 23);
    return;
}

function swapReset()
{
    m_hTabCtrl.MoveTo(12, 6);
    m_hTabCtrl_Exp.MoveTo(12, 23);
    return;
}

function OnComboBoxItemSelected(string sName, int Index)
{
    local int QuestComboCurrentReservedData, HuntingZoneComboboxCurrentReservedData, AreaInfoComboBoxCurrentReservedData;

    // End:0x3E
    if(sName == "QuestComboBox")
    {
        QuestComboCurrentReservedData = m_hQuestComboBox.GetReserved(Index);
        LoadQuestSearchResult(QuestComboCurrentReservedData);
    }
    // End:0xA0
    if(sName == "HuntingZoneComboBox")
    {
        HuntingZoneComboboxCurrentReservedData = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("GuideWnd.HuntingZoneComboBox", Index);
        LoadHuntingZoneListSearchResult(HuntingZoneComboboxCurrentReservedData);
    }
    // End:0xFC
    if(sName == "AreaInfoComboBox")
    {
        AreaInfoComboBoxCurrentReservedData = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("GuideWnd.AreaInfoComboBox", Index);
        LoadAreaInfoListSearchResult(AreaInfoComboBoxCurrentReservedData);
    }
    return;
}

function ReDrawAllIcons()
{
    local int i;

    m_MiniMap.EraseAllRegionInfo();
    m_MiniMap.DeleteAllTarget();
    i = 0;
    J0x25:

    // End:0x6B [Loop If]
    if(i < m_MiniMapWndScript.RegionData.Length)
    {
        m_MiniMapWndScript.addMapIcon(m_MiniMapWndScript.RegionData[i]);
        i++;
        // [Loop Continue]
        goto J0x25;
    }
    m_MiniMapWndScript.bCompleteBaseElementShow = false;
    m_MiniMapWndScript.showMapIconElement();
    return;
}

function OnClickListCtrlRecord(string Id)
{
    local LVDataRecord Record;
    local Vector loc;
    local int SelectedIndex;
    local MinimapRegionIconData emptyIconData;

    ReDrawAllIcons();
    // End:0xC1
    if(Id == "QuestListCtrl")
    {
        m_hQuestListCtrl.GetSelectedRec(Record);
        SelectedIndex = m_hQuestListCtrl.GetSelectedIndex();
        loc = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(Record.LVDataList[0].nReserved1, 1);
        m_MiniMapWndScript.SetLocContinent(loc);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, false);
        m_MiniMapWndScript.mapIconHighlightEx(loc, 1);
    }
    // End:0x18D
    if(Id == "HuntingZoneListCtrl")
    {
        m_hHuntingZoneListCtrl.GetSelectedRec(Record);
        SelectedIndex = m_hHuntingZoneListCtrl.GetSelectedIndex();
        loc = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
        m_MiniMapWndScript.SetLocContinent(loc);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, false);
        displayCurrentDataOnTheMap(loc, 0);
        m_MiniMapWndScript.mapIconHighlightEx(loc, 0);
    }
    // End:0x2E5
    if(Id == "RaidListCtrl")
    {
        m_hRaidListCtrl.GetSelectedRec(Record);
        SelectedIndex = m_hRaidListCtrl.GetSelectedIndex();
        loc = Class'NWindow.UIDATA_RAID'.static.GetRaidLoc(Record.LVDataList[0].nReserved1);
        m_MiniMapWndScript.SetLocContinent(loc);
        // End:0x280
        if(((loc.X != 0.0000000) && loc.Y != 0.0000000) && loc.Z != 0.0000000)
        {
            Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, false);
            displayCurrentDataOnTheMap(loc, 0);            
        }
        else
        {
            loc.X = -30000000.0000000;
            loc.Y = -30000000.0000000;
            loc.Z = 0.0000000;
            displayCurrentDataOnTheMap(loc, 0);
        }
        m_MiniMapWndScript.updateRaidListRecord(-1);
        m_MiniMapWndScript.mapIconHighlightEx(loc, 0);
    }
    // End:0x3AE
    if(Id == "AreaInfoListCtrl")
    {
        m_hAreaInfoListCtrl.GetSelectedRec(Record);
        SelectedIndex = m_hAreaInfoListCtrl.GetSelectedIndex();
        loc = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
        m_MiniMapWndScript.SetLocContinent(loc);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, false);
        displayCurrentDataOnTheMap(loc, 0);
        m_MiniMapWndScript.mapIconHighlightEx(loc, 0);
    }
    // End:0x475
    if(Id == "CastleListCtrl")
    {
        m_CastleListCtrl.GetSelectedRec(Record);
        SelectedIndex = m_CastleListCtrl.GetSelectedIndex();
        loc = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
        m_MiniMapWndScript.SetLocContinent(loc);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, false);
        displayCurrentDataOnTheMap(loc, 0);
        m_MiniMapWndScript.mapIconHighlightEx(loc, 0);
    }
    // End:0x53E
    if(Id == "FortressListCtrl")
    {
        m_FortressListCtrl.GetSelectedRec(Record);
        SelectedIndex = m_FortressListCtrl.GetSelectedIndex();
        loc = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
        m_MiniMapWndScript.SetLocContinent(loc);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, false);
        displayCurrentDataOnTheMap(loc, 1);
        m_MiniMapWndScript.mapIconHighlightEx(loc, 0);
    }
    // End:0x6F0
    if(Id == "AgitListCtrl")
    {
        m_AgitListCtrl.GetSelectedRec(Record);
        SelectedIndex = m_AgitListCtrl.GetSelectedIndex();
        // End:0x60B
        if(agitid1[Record.LVDataList[0].nReserved1] > 0)
        {
            loc.X = float(agitid1[Record.LVDataList[0].nReserved1]);
            loc.Y = float(agitid2[Record.LVDataList[0].nReserved1]);
            loc.Z = float(agitid3[Record.LVDataList[0].nReserved1]);            
        }
        else
        {
            loc.X = getInstanceL2Util().getCastleLocEx(Record.LVDataList[0].nReserved1).X;
            loc.Y = getInstanceL2Util().getCastleLocEx(Record.LVDataList[0].nReserved1).Y;
            loc.Z = getInstanceL2Util().getCastleLocEx(Record.LVDataList[0].nReserved1).Z;
        }
        m_MiniMapWndScript.SetLocContinent(loc);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, false);
        m_MiniMapWndScript.mapIconHighlightEx(loc, 1);
    }
    // End:0x7B4
    if(Id == "TerritoryListCtrl")
    {
        m_TerritoryListCtrl.GetSelectedRec(Record);
        TerritoryListSelectedIndex = m_TerritoryListCtrl.GetSelectedIndex();
        loc = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, false);
        m_MiniMapWndScript.SetLocContinent(loc);
        RequestDominionInfo();
        m_MiniMapWndScript.mapIconHighlightEx(loc, 0);
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1E
        case 130:
            m_hOwnerWnd.ShowWindow();
            // End:0x125
            break;
        // End:0x31
        case 120:
            LoadRaidList(a_Param);
            // End:0x125
            break;
        // End:0x51
        case 3140:
            m_CastleListCtrl.DeleteAllItem();
            ResetArray();
            // End:0x125
            break;
        // End:0x67
        case 3150:
            LoadCastleInfo(a_Param);
            // End:0x125
            break;
        // End:0x87
        case 3160:
            m_FortressListCtrl.DeleteAllItem();
            ResetArray();
            // End:0x125
            break;
        // End:0x9D
        case 3170:
            LoadFortressInfo(a_Param);
            // End:0x125
            break;
        // End:0xC4
        case 3180:
            m_AgitListCtrl.DeleteAllItem();
            ResetArray();
            global_i = 0;
            // End:0x125
            break;
        // End:0xDA
        case 3190:
            LoadAgitInfo(a_Param);
            // End:0x125
            break;
        // End:0xF0
        case 3200:
            LoadFortressSeigeInfo(a_Param);
            // End:0x125
            break;
        // End:0x106
        case 3590:
            HandleDominionInfoCnt(a_Param);
            // End:0x125
            break;
        // End:0x11C
        case 3600:
            HandleDominionInfo(a_Param);
            // End:0x125
            break;
        // End:0xFFFF
        default:
            // End:0x125
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x125
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x125
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x125
}

function LoadHuntingZoneList()
{
    local string HuntingZoneName;
    local int MinLevel, MaxLevel;
    local string LevelLimit;
    local int FieldType;
    local string FieldType_Name;
    local int Zone;
    local LVDataRecord Record;
    local LVData data1, data2, data3, data4;
    local int i;
    local Vector loc;
    local string DataforMap;

    ResetArray();
    m_hHuntingZoneListCtrl.DeleteAllItem();
    comboxFiller("HuntingZoneComboBox");
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("GuideWnd.HuntingZoneComboBox", 0);
    i = 0;
    J0x65:

    // End:0x266 [Loop If]
    if(i < 250)
    {
        // End:0x25C
        if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
        {
            FieldType = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i);
            // End:0x25C
            if((FieldType == 1) || FieldType == 2)
            {
                HuntingZoneName = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i);
                MinLevel = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetMinLevel(i);
                MaxLevel = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetMaxLevel(i);
                Zone = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i);
                // End:0x159
                if((MinLevel > 0) && MaxLevel > 0)
                {
                    LevelLimit = (string(MinLevel) $ "~") $ string(MaxLevel);                    
                }
                else
                {
                    // End:0x186
                    if(MinLevel > 0)
                    {
                        LevelLimit = (string(MinLevel) $ " ") $ GetSystemString(859);                        
                    }
                    else
                    {
                        LevelLimit = GetSystemString(866);
                    }
                }
                FieldType_Name = conv_zoneType(FieldType);
                data1.nReserved1 = i;
                data1.szData = HuntingZoneName;
                Record.LVDataList[0] = data1;
                data2.szData = FieldType_Name;
                Record.LVDataList[1] = data2;
                data3.szData = conv_zoneName(Zone);
                Record.LVDataList[2] = data3;
                data4.szData = LevelLimit;
                Record.LVDataList[3] = data4;
                m_hHuntingZoneListCtrl.InsertRecord(Record);
            }
        }
        i++;
        // [Loop Continue]
        goto J0x65;
    }
    return;
}

function LoadHuntingZoneListSearchResult(int SearchZone)
{
    local string HuntingZoneName;
    local int MinLevel, MaxLevel;
    local string LevelLimit;
    local int FieldType;
    local string FieldType_Name;
    local int Zone;
    local string Description;
    local LVDataRecord Record;
    local LVData data1, data2, data3, data4;
    local int i;

    // End:0x18
    if(SearchZone == 19989)
    {
        LoadHuntingZoneList();        
    }
    else
    {
        m_hHuntingZoneListCtrl.DeleteAllItem();
        i = 0;
        J0x2E:

        // End:0x267 [Loop If]
        if(i < 250)
        {
            // End:0x25D
            if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
            {
                // End:0x25D
                if(Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i) == SearchZone)
                {
                    FieldType = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i);
                    // End:0x25D
                    if((FieldType == 1) || FieldType == 2)
                    {
                        HuntingZoneName = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i);
                        MinLevel = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetMinLevel(i);
                        MaxLevel = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetMaxLevel(i);
                        Zone = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i);
                        Description = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingDescription(i);
                        // End:0x15A
                        if((MinLevel > 0) && MaxLevel > 0)
                        {
                            LevelLimit = (string(MinLevel) $ "~") $ string(MaxLevel);                            
                        }
                        else
                        {
                            // End:0x187
                            if(MinLevel > 0)
                            {
                                LevelLimit = (string(MinLevel) $ " ") $ GetSystemString(859);                                
                            }
                            else
                            {
                                LevelLimit = GetSystemString(866);
                            }
                        }
                        FieldType_Name = conv_zoneType(FieldType);
                        data1.nReserved1 = i;
                        data1.szData = HuntingZoneName;
                        Record.LVDataList[0] = data1;
                        data2.szData = FieldType_Name;
                        Record.LVDataList[1] = data2;
                        data3.szData = conv_zoneName(Zone);
                        Record.LVDataList[2] = data3;
                        data4.szData = LevelLimit;
                        Record.LVDataList[3] = data4;
                        m_hHuntingZoneListCtrl.InsertRecord(Record);
                    }
                }
            }
            i++;
            // [Loop Continue]
            goto J0x2E;
        }
    }
    return;
}

function LoadRaidRanking()
{
    return;
}

function LoadRaidList(string a_Param)
{
    local int i, j, RaidMonsterID, RaidMonsterLevel, RaidMonsterZone;

    local string RaidPointStr, RaidMonsterPrefferedLevel, raidMonsterName, RaidDescription;
    local LVDataRecord Record;
    local LVData data1, data2, data3, data4;
    local int RaidRanking, RaidSeasonPoint, RaidNum, ClearRaidMonsterID, ClearSeasonPoint, ClearTotalPoint,
	    AntarasPoint;

    local string SeasonTotalString, DataforMap;
    local Vector loc;
    local RaidIconData prevBossList;
    local UserInfo pUserInfo;
    local int recLvMin, recLvMax;

    GetPlayerInfo(pUserInfo);
    ResetArray();
    m_hRaidListCtrl.DeleteAllItem();
    AntarasPoint = 0;
    ParseInt(a_Param, "RaidRank", RaidRanking);
    ParseInt(a_Param, "SeasonPoint", RaidSeasonPoint);
    // End:0x98
    if(RaidRanking == 0)
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("GuideWnd.Ranking", GetSystemString(1454));        
    }
    else
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("GuideWnd.Ranking", RaidRanking);
    }
    SeasonTotalString = ("" $ string(RaidSeasonPoint)) @ GetSystemString(1442);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("GuideWnd.SeasonTotalPoint", SeasonTotalString);
    ParseInt(a_Param, "Count", RaidNum);
    prevBossList = bossList;
    bossList.RaidID.Remove(0, bossList.RaidID.Length);
    bossList.Index.Remove(0, bossList.Index.Length);
    RaidRecordList.Remove(0, RaidRecordList.Length);
    RaidRecordList.Insert(0, RaidNum);
    i = 0;
    J0x17B:

    // End:0x246 [Loop If]
    if(i < RaidNum)
    {
        ParseInt(a_Param, "MonsterID" $ string(i), ClearRaidMonsterID);
        ParseInt(a_Param, "CurrentPoint" $ string(i), ClearSeasonPoint);
        ParseInt(a_Param, "TotalPoint" $ string(i), ClearTotalPoint);
        RaidRecordList[i].A = ClearRaidMonsterID;
        RaidRecordList[i].B = ClearSeasonPoint;
        RaidRecordList[i].C = ClearTotalPoint;
        i++;
        // [Loop Continue]
        goto J0x17B;
    }
    i = 0;
    J0x24D:

    // End:0x9D0 [Loop If]
    if(i < 500)
    {
        // End:0x9C6
        if(Class'NWindow.UIDATA_RAID'.static.IsValidData(i))
        {
            Class'NWindow.UIDATA_RAID'.static.GetRaidRecommendLevel(i, recLvMin, recLvMax);
            // End:0x2B4
            if((tryLevelCheck(pUserInfo.nLevel, recLvMin, recLvMax)) == false)
            {
                // [Explicit Continue]
                goto J0x9C6;
            }
            RaidMonsterID = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterID(i);
            RaidMonsterLevel = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterLevel(i);
            RaidMonsterZone = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterZone(i);
            RaidDescription = Class'NWindow.UIDATA_RAID'.static.GetRaidDescription(i);
            raidMonsterName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(RaidMonsterID);
            // End:0x4AB
            if(RaidMonsterID == 29066)
            {
                // End:0x372
                if(RaidMonsterLevel > 0)
                {
                    RaidMonsterPrefferedLevel = (GetSystemString(537) $ " ") $ string(RaidMonsterLevel);                    
                }
                else
                {
                    RaidMonsterPrefferedLevel = GetSystemString(1415);
                }
                data1.nReserved1 = i;
                data1.szData = raidMonsterName;
                Record.LVDataList[0] = data1;
                data2.szData = RaidMonsterPrefferedLevel;
                Record.LVDataList[1] = data2;
                data3.szData = conv_zoneName(RaidMonsterZone);
                Record.LVDataList[2] = data3;
                RaidPointStr = "0";
                j = 0;
                J0x410:

                // End:0x45F [Loop If]
                if(j < RaidNum)
                {
                    // End:0x455
                    if(RaidRecordList[j].A == RaidMonsterID)
                    {
                        RaidPointStr = string(RaidRecordList[j].B) $ "";
                    }
                    j++;
                    // [Loop Continue]
                    goto J0x410;
                }
                AntarasPoint = int(RaidPointStr) + AntarasPoint;
                data4.szData = string(AntarasPoint);
                Record.LVDataList[3] = data4;
                Record.szReserved = RaidDescription;
                // [Explicit Continue]
                goto J0x9C6;
            }
            // End:0x620
            if(RaidMonsterID == 29067)
            {
                // End:0x4E7
                if(RaidMonsterLevel > 0)
                {
                    RaidMonsterPrefferedLevel = (GetSystemString(537) $ " ") $ string(RaidMonsterLevel);                    
                }
                else
                {
                    RaidMonsterPrefferedLevel = GetSystemString(1415);
                }
                data1.nReserved1 = i;
                data1.szData = raidMonsterName;
                Record.LVDataList[0] = data1;
                data2.szData = RaidMonsterPrefferedLevel;
                Record.LVDataList[1] = data2;
                data3.szData = conv_zoneName(RaidMonsterZone);
                Record.LVDataList[2] = data3;
                RaidPointStr = "0";
                j = 0;
                J0x585:

                // End:0x5D4 [Loop If]
                if(j < RaidNum)
                {
                    // End:0x5CA
                    if(RaidRecordList[j].A == RaidMonsterID)
                    {
                        RaidPointStr = string(RaidRecordList[j].B) $ "";
                    }
                    j++;
                    // [Loop Continue]
                    goto J0x585;
                }
                AntarasPoint = int(RaidPointStr) + AntarasPoint;
                data4.szData = string(AntarasPoint);
                Record.LVDataList[3] = data4;
                Record.szReserved = RaidDescription;
                // [Explicit Continue]
                goto J0x9C6;
            }
            // End:0x7A9
            if(RaidMonsterID == 29068)
            {
                // End:0x65C
                if(RaidMonsterLevel > 0)
                {
                    RaidMonsterPrefferedLevel = (GetSystemString(537) $ " ") $ string(RaidMonsterLevel);                    
                }
                else
                {
                    RaidMonsterPrefferedLevel = GetSystemString(1415);
                }
                data1.nReserved1 = i;
                data1.szData = raidMonsterName;
                Record.LVDataList[0] = data1;
                data2.szData = RaidMonsterPrefferedLevel;
                Record.LVDataList[1] = data2;
                data3.szData = conv_zoneName(RaidMonsterZone);
                Record.LVDataList[2] = data3;
                RaidPointStr = "0";
                j = 0;
                J0x6FA:

                // End:0x749 [Loop If]
                if(j < RaidNum)
                {
                    // End:0x73F
                    if(RaidRecordList[j].A == RaidMonsterID)
                    {
                        RaidPointStr = string(RaidRecordList[j].B) $ "";
                    }
                    j++;
                    // [Loop Continue]
                    goto J0x6FA;
                }
                AntarasPoint = int(RaidPointStr) + AntarasPoint;
                data4.szData = string(AntarasPoint);
                Record.LVDataList[3] = data4;
                Record.szReserved = RaidDescription;
                m_hRaidListCtrl.InsertRecord(Record);
                // [Explicit Continue]
                goto J0x9C6;
            }
            // End:0x7D6
            if(RaidMonsterLevel > 0)
            {
                RaidMonsterPrefferedLevel = (GetSystemString(537) $ " ") $ string(RaidMonsterLevel);                
            }
            else
            {
                RaidMonsterPrefferedLevel = GetSystemString(1415);
            }
            data1.nReserved1 = i;
            data1.szData = raidMonsterName;
            Record.LVDataList[0] = data1;
            data2.szData = RaidMonsterPrefferedLevel;
            Record.LVDataList[1] = data2;
            data3.szData = conv_zoneName(RaidMonsterZone);
            Record.LVDataList[2] = data3;
            RaidPointStr = "0";
            j = 0;
            J0x874:

            // End:0x8C3 [Loop If]
            if(j < RaidNum)
            {
                // End:0x8B9
                if(RaidRecordList[j].A == RaidMonsterID)
                {
                    RaidPointStr = string(RaidRecordList[j].B) $ "";
                }
                j++;
                // [Loop Continue]
                goto J0x874;
            }
            data4.szData = RaidPointStr;
            Record.LVDataList[3] = data4;
            Record.szReserved = RaidDescription;
            Record.LVDataList[0].szReserved = "";
            bossList.RaidID[bossList.RaidID.Length] = RaidMonsterID;
            bossList.Index[bossList.RaidID.Length] = i;
            ParamAdd(Record.LVDataList[0].szReserved, "npcID", string(RaidMonsterID));
            ParamAdd(Record.LVDataList[0].szReserved, "index", string(i));
            ParamAdd(Record.LVDataList[0].szReserved, "addStr", string(RaidMonsterLevel));
            m_hRaidListCtrl.InsertRecord(Record);
        }
        J0x9C6:

        i++;
        // [Loop Continue]
        goto J0x24D;
    }
    // End:0x9FA
    if(bossList.RaidID.Length > 0)
    {
        Class'NWindow.MiniMapAPI'.static.RequestRaidBossSpawnInfo(bossList.RaidID);
    }
    return;
}

function LoadRaidList2()
{
    local int i, RaidMonsterID, RaidMonsterLevel, RaidMonsterZone;
    local string RaidPointStr, RaidMonsterPrefferedLevel, raidMonsterName, RaidDescription;
    local LVDataRecord Record;
    local LVData data1, data2, data3, data4;
    local string DataforMap;
    local Vector loc;
    local int RaidNum, RaidCount;

    m_hRaidListCtrl.DeleteAllItem();
    ResetArray();
    i = 0;
    J0x1C:

    // End:0x220 [Loop If]
    if(i < 500)
    {
        // End:0x216
        if(Class'NWindow.UIDATA_RAID'.static.IsValidData(i))
        {
            RaidMonsterID = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterID(i);
            RaidMonsterLevel = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterLevel(i);
            RaidMonsterZone = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterZone(i);
            RaidDescription = Class'NWindow.UIDATA_RAID'.static.GetRaidDescription(i);
            raidMonsterName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(RaidMonsterID);
            // End:0xF1
            if(RaidMonsterLevel > 0)
            {
                RaidMonsterPrefferedLevel = (GetSystemString(537) $ " ") $ string(RaidMonsterLevel);                
            }
            else
            {
                RaidMonsterPrefferedLevel = GetSystemString(1415);
            }
            data1.nReserved1 = i;
            data1.szData = raidMonsterName;
            Record.LVDataList[0] = data1;
            data2.szData = RaidMonsterPrefferedLevel;
            Record.LVDataList[1] = data2;
            data3.szData = conv_zoneName(RaidMonsterZone);
            Record.LVDataList[2] = data3;
            RaidPointStr = "0";
            // End:0x1CF
            if(RaidCount < RaidNum)
            {
                // End:0x1CF
                if(RaidRecordList[RaidCount].A == RaidMonsterID)
                {
                    RaidPointStr = string(RaidRecordList[RaidCount++].B) $ "";
                }
            }
            data4.szData = RaidPointStr;
            Record.LVDataList[3] = data4;
            Record.szReserved = RaidDescription;
            m_hRaidListCtrl.InsertRecord(Record);
        }
        i++;
        // [Loop Continue]
        goto J0x1C;
    }
    return;
}

function LoadRaidSearchResult(int SearchZone)
{
    local int i, RaidMonsterID, RaidMonsterLevel, RaidMonsterZone;
    local string RaidPointStr, RaidMonsterPrefferedLevel, raidMonsterName, RaidDescription;
    local LVDataRecord Record;
    local LVData data1, data2, data3, data4;
    local int RaidNum, RaidCount;

    // End:0x18
    if(SearchZone == 19989)
    {
        LoadRaidList2();        
    }
    else
    {
        m_hRaidListCtrl.DeleteAllItem();
        RaidNum = RaidRecordList.Length;
        RaidCount = 0;
        i = 0;
        J0x41:

        // End:0x25E [Loop If]
        if(i < 500)
        {
            // End:0x254
            if(Class'NWindow.UIDATA_RAID'.static.IsValidData(i))
            {
                RaidMonsterZone = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterZone(i);
                // End:0x254
                if(SearchZone == RaidMonsterZone)
                {
                    RaidMonsterID = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterID(i);
                    RaidMonsterLevel = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterLevel(i);
                    RaidDescription = Class'NWindow.UIDATA_RAID'.static.GetRaidDescription(i);
                    raidMonsterName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(RaidMonsterID);
                    // End:0x125
                    if(RaidMonsterLevel > 0)
                    {
                        RaidMonsterPrefferedLevel = (GetSystemString(537) $ " ") $ string(RaidMonsterLevel);                        
                    }
                    else
                    {
                        RaidMonsterPrefferedLevel = "-";
                    }
                    data1.nReserved1 = i;
                    data1.szData = raidMonsterName;
                    Record.LVDataList[0] = data1;
                    data2.szData = RaidMonsterPrefferedLevel;
                    Record.LVDataList[1] = data2;
                    data3.szData = conv_zoneName(RaidMonsterZone);
                    Record.LVDataList[2] = data3;
                    RaidPointStr = "0";
                    // End:0x1FB
                    if(RaidCount < RaidNum)
                    {
                        // End:0x1FB
                        if(RaidRecordList[RaidCount].A == RaidMonsterID)
                        {
                            RaidPointStr = string(RaidRecordList[RaidCount++].B) $ "";
                        }
                    }
                    data4.szData = RaidPointStr;
                    Record.LVDataList[3] = data4;
                    Record.szReserved = RaidDescription;
                    Record.nReserved1 = (RaidMonsterZone);
                    m_hRaidListCtrl.InsertRecord(Record);
                }
            }
            i++;
            // [Loop Continue]
            goto J0x41;
        }
    }
    return;
}

function LoadQuestList()
{
    local string QuestName;
    local int MinLevel, MaxLevel, Type, Npc;
    local string LevelLimit, NpcName;
    local int Id, i;
    local LVDataRecord Record;
    local LVData data1, data2, data3, data4;
    local string TypeText[5];
    local Vector loc;

    ResetArray();
    m_hQuestListCtrl.DeleteAllItem();
    comboxFiller("QuestComboBox");
    m_hQuestComboBox.SetSelectedNum(0);
    TypeText[0] = GetSystemString(861);
    TypeText[1] = GetSystemString(862);
    TypeText[2] = GetSystemString(861);
    TypeText[3] = GetSystemString(862);
    TypeText[4] = GetSystemString(861);
    i = 1;
    Id = Class'NWindow.UIDATA_QUEST'.static.GetFirstID();
    J0xB8:

    // End:0x315 [Loop If]
    if(-1 != Id)
    {
        QuestName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(Id);
        MinLevel = Class'NWindow.UIDATA_QUEST'.static.GetMinLevel(Id, 1);
        MaxLevel = Class'NWindow.UIDATA_QUEST'.static.GetMaxLevel(Id, 1);
        Type = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(Id, 1);
        Npc = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(Id, 1);
        NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(Npc);
        // End:0x19D
        if((MinLevel > 0) && MaxLevel > 0)
        {
            LevelLimit = (string(MinLevel) $ "~") $ string(MaxLevel);            
        }
        else
        {
            // End:0x1CA
            if(MinLevel > 0)
            {
                LevelLimit = (string(MinLevel) $ " ") $ GetSystemString(859);                
            }
            else
            {
                LevelLimit = GetSystemString(866);
            }
        }
        // End:0x207
        if((NpcName == "") || NpcName == "None")
        {
            NpcName = GetSystemString(27);
        }
        data1.nReserved1 = Id;
        data1.szData = QuestName;
        Record.LVDataList[0] = data1;
        // End:0x268
        if((0 <= Type) && Type <= 4)
        {
            data2.szData = TypeText[Type];
        }
        Record.LVDataList[1] = data2;
        data3.szData = NpcName;
        Record.LVDataList[2] = data3;
        data4.szData = LevelLimit;
        Record.LVDataList[3] = data4;
        m_hQuestListCtrl.InsertRecord(Record);
        loc = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(Id, 1);
        i = i + 1;
        Id = Class'NWindow.UIDATA_QUEST'.static.GetNextID();
        // [Loop Continue]
        goto J0xB8;
    }
    return;
}

function displayCurrentDataOnTheMap(Vector currentloc, int txtureint)
{
    local int i, comparedVecX, comparedVecY;
    local string temp, temp1, temp2, temp3, temp4, temp5,
	    temp6, temp7;

    switch(txtureint)
    {
        // End:0xFFFF
        default:
            i = 0;
            J0x11:

            // End:0x3B0 [Loop If]
            if(i < currentmaprecord.Length)
            {
                ParseInt(currentmaprecord[i], "WorldX", comparedVecX);
                ParseInt(currentmaprecord[i], "WorldY", comparedVecY);
                comparedVecX = comparedVecX + 3400;
                comparedVecY = comparedVecY + 6400;
                switch(txtureint)
                {
                    // End:0x386
                    case 0:
                        // End:0x383
                        if((currentloc.X == float(comparedVecX)) && currentloc.Y == float(comparedVecY))
                        {
                            ParseString(currentmaprecord[i], "Index", temp1);
                            ParseString(currentmaprecord[i], "WorldX", temp2);
                            ParseString(currentmaprecord[i], "WorldY", temp3);
                            ParseString(currentmaprecord[i], "Description", temp4);
                            ParseString(currentmaprecord[i], "DescOffsetX", temp5);
                            ParseString(currentmaprecord[i], "DescOffsetY", temp6);
                            ParseString(currentmaprecord[i], "Tooltip", temp7);
                            currentmaprecord[i] = "";
                            ParamAdd(currentmaprecord[i], "Index", temp1);
                            ParamAdd(currentmaprecord[i], "WorldX", temp2);
                            ParamAdd(currentmaprecord[i], "WorldY", temp3);
                            ParamAdd(currentmaprecord[i], "Description", temp4);
                            ParamAdd(currentmaprecord[i], "DescOffsetX", temp5);
                            ParamAdd(currentmaprecord[i], "DescOffsetY", temp6);
                            ParamAdd(currentmaprecord[i], "Tooltip", temp7);
                            ParamAdd(currentmaprecord[i], "BtnTexNormal", "L2UI.TargetPos");
                            ParamAdd(currentmaprecord[i], "BtnTexPushed", "L2UI.TargetPos");
                            ParamAdd(currentmaprecord[i], "BtnTexOver", "L2UI.TargetPos");
                            ParamAdd(currentmaprecord[i], "BtnWidth", string(30));
                            ParamAdd(currentmaprecord[i], "BtnHeight", string(30));
                            ParseString(currentmaprecord[i], "BtnTexNormal", temp);
                            g_modedID = i;
                        }
                        // End:0x38C
                        break;
                    // End:0xFFFF
                    default:
                        // End:0x38C
                        break;
                        break;
                }
                m_MiniMap.AddRegionInfo(currentmaprecord[i]);
                i++;
                // [Loop Continue]
                goto J0x11;
            }
            // End:0x3B3
            break;
            break;
    }
    return;
}

function JustdisplayCurrentDataOnTheMap()
{
    local int i;

    m_MiniMap.EraseAllRegionInfo();
    i = 0;
    J0x16:

    // End:0x4A [Loop If]
    if(i < currentmaprecord.Length)
    {
        m_MiniMap.AddRegionInfo(currentmaprecord[i]);
        i++;
        // [Loop Continue]
        goto J0x16;
    }
    return;
}

function LoadQuestSearchResult(int SearchZone)
{
    local string QuestName, Condition;
    local int MinLevel, MaxLevel, Type, Zone, Npc;

    local string Description, LevelLimit, NpcName;
    local int i;
    local LVDataRecord Record;
    local LVData data1, data2, data3, data4;
    local string TypeText;

    // End:0x18
    if(SearchZone == 19989)
    {
        LoadQuestList();        
    }
    else
    {
        m_hQuestListCtrl.DeleteAllItem();
        i = 0;
        J0x2E:

        // End:0x318 [Loop If]
        if(i < 500)
        {
            // End:0x30E
            if(Class'NWindow.UIDATA_QUEST'.static.IsValidData(i))
            {
                // End:0x30E
                if(Class'NWindow.UIDATA_QUEST'.static.GetQuestZone(i, 1) == SearchZone)
                {
                    QuestName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(i);
                    Condition = Class'NWindow.UIDATA_QUEST'.static.GetRequirement(i, 1);
                    MinLevel = Class'NWindow.UIDATA_QUEST'.static.GetMinLevel(i, 1);
                    MaxLevel = Class'NWindow.UIDATA_QUEST'.static.GetMaxLevel(i, 1);
                    Type = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(i, 1);
                    Zone = Class'NWindow.UIDATA_QUEST'.static.GetQuestZone(i, 1);
                    Description = Class'NWindow.UIDATA_QUEST'.static.GetIntro(i, 1);
                    Npc = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(i, 1);
                    NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(Npc);
                    // End:0x19A
                    if((MinLevel > 0) && MaxLevel > 0)
                    {
                        LevelLimit = (string(MinLevel) $ "~") $ string(MaxLevel);                        
                    }
                    else
                    {
                        // End:0x1C7
                        if(MinLevel > 0)
                        {
                            LevelLimit = (string(MinLevel) $ " ") $ GetSystemString(859);                            
                        }
                        else
                        {
                            LevelLimit = GetSystemString(866);
                        }
                    }
                    switch(Type)
                    {
                        // End:0x1F7
                        case 0:
                            TypeText = GetSystemString(861);
                            // End:0x260
                            break;
                        // End:0x20F
                        case 1:
                            TypeText = GetSystemString(862);
                            // End:0x260
                            break;
                        // End:0x228
                        case 2:
                            TypeText = GetSystemString(861);
                            // End:0x260
                            break;
                        // End:0x241
                        case 3:
                            TypeText = GetSystemString(862);
                            // End:0x260
                            break;
                        // End:0x25A
                        case 4:
                            TypeText = GetSystemString(861);
                            // End:0x260
                            break;
                        // End:0xFFFF
                        default:
                            // End:0x260
                            break;
                            break;
                    }
                    data1.nReserved1 = i;
                    data1.szData = QuestName;
                    Record.LVDataList[0] = data1;
                    data2.szData = TypeText;
                    Record.LVDataList[1] = data2;
                    data3.szData = NpcName;
                    Record.LVDataList[2] = data3;
                    data4.szData = LevelLimit;
                    Record.LVDataList[3] = data4;
                    m_hQuestListCtrl.InsertRecord(Record);
                }
            }
            i++;
            // [Loop Continue]
            goto J0x2E;
        }
    }
    return;
}

function LoadAreaInfoList()
{
    local string AreaName;
    local int Type, Zone;
    local string ZoneName, zonetype, Description;
    local int i;
    local LVDataRecord Record;
    local LVData data1, data2, data3;
    local Vector loc;
    local string DataforMap;

    m_hAreaInfoListCtrl.DeleteAllItem();
    ResetArray();
    comboxFiller("AreaInfoComboBox");
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("GuideWnd.AreaInfoComboBox", 0);
    i = 0;
    J0x5F:

    // End:0x1CF [Loop If]
    if(i < 250)
    {
        // End:0x1C5
        if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
        {
            Type = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i);
            // End:0x1C5
            if(Type > 2)
            {
                AreaName = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i);
                Zone = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i);
                Description = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingDescription(i);
                ZoneName = conv_dom(Zone);
                zonetype = conv_zoneType(Type);
                data1.nReserved1 = i;
                data1.szData = AreaName;
                Record.LVDataList[0] = data1;
                data2.szData = zonetype;
                Record.LVDataList[1] = data2;
                data3.szData = ZoneName;
                Record.LVDataList[2] = data3;
                Record.nReserved1 = (Zone);
                Record.szReserved = Description;
                m_hAreaInfoListCtrl.InsertRecord(Record);
            }
        }
        i++;
        // [Loop Continue]
        goto J0x5F;
    }
    return;
}

function ResetArray()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x2D [Loop If]
    if(i < currentmaprecord.Length)
    {
        currentmaprecord.Remove(1, i);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function LoadAreaInfoListSearchResult(int SearchZone)
{
    local string AreaName;
    local int Type, Zone;
    local string ZoneName, zonetype, Description;
    local int i;
    local LVDataRecord Record;
    local LVData data1, data2, data3;

    // End:0x18
    if(SearchZone == 19989)
    {
        LoadAreaInfoList();        
    }
    else
    {
        m_hAreaInfoListCtrl.DeleteAllItem();
        i = 0;
        J0x2E:

        // End:0x19D [Loop If]
        if(i < 500)
        {
            // End:0x193
            if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
            {
                // End:0x193
                if(Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i) == SearchZone)
                {
                    Type = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i);
                    // End:0x193
                    if(Type > 2)
                    {
                        AreaName = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i);
                        Zone = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i);
                        Description = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingDescription(i);
                        ZoneName = conv_dom(Zone);
                        zonetype = conv_zoneType(Type);
                        data1.nReserved1 = i;
                        data1.szData = AreaName;
                        Record.LVDataList[0] = data1;
                        data2.szData = zonetype;
                        Record.LVDataList[1] = data2;
                        data3.szData = ZoneName;
                        Record.LVDataList[2] = data3;
                        m_hAreaInfoListCtrl.InsertRecord(Record);
                    }
                }
            }
            i++;
            // [Loop Continue]
            goto J0x2E;
        }
    }
    return;
}

function comboxFiller(string ComboboxName)
{
    switch(ComboboxName)
    {
        // End:0x31
        case "QuestComboBox":
            proc_combox("QuestComboBox");
            // End:0x9D
            break;
        // End:0x67
        case "HuntingZoneComboBox":
            proc_combox("HuntingZoneComboBox");
            // End:0x9D
            break;
        // End:0x97
        case "AreaInfoComboBox":
            proc_combox("AreaInfoComboBox");
            // End:0x9D
            break;
        // End:0xFFFF
        default:
            // End:0x9D
            break;
            break;
    }
    return;
}

function proc_combox(string ComboboxName)
{
    local string ComboboxNameFull, ZoneName;
    local int Zone, i;

    ComboboxNameFull = "GuideWnd." $ ComboboxName;
    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(ComboboxNameFull);
    Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(ComboboxNameFull, GetSystemString(144), 19989);
    i = 0;
    J0x54:

    // End:0xED [Loop If]
    if(i < 250)
    {
        // End:0xE3
        if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
        {
            // End:0xE3
            if(Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i) == 0)
            {
                ZoneName = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i);
                Zone = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i);
                Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved(ComboboxNameFull, ZoneName, Zone);
            }
        }
        i++;
        // [Loop Continue]
        goto J0x54;
    }
    return;
}

function string conv_dom(int ZoneNameNum)
{
    local string ZoneNameStr;
    local int i;

    i = 0;
    J0x07:

    // End:0x86 [Loop If]
    if(i < 250)
    {
        // End:0x7C
        if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
        {
            // End:0x7C
            if(Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i) == 0)
            {
                // End:0x7C
                if(Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i) == ZoneNameNum)
                {
                    ZoneNameStr = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i);
                }
            }
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return ZoneNameStr;
    return;
}

function string conv_zoneType(int ZoneTypeNum)
{
    local string ZoneTypeStr;

    switch(ZoneTypeNum)
    {
        // End:0x1F
        case 1:
            ZoneTypeStr = GetSystemString(1313);
            // End:0xBB
            break;
        // End:0x38
        case 2:
            ZoneTypeStr = GetSystemString(1314);
            // End:0xBB
            break;
        // End:0x51
        case 3:
            ZoneTypeStr = GetSystemString(1315);
            // End:0xBB
            break;
        // End:0x6A
        case 4:
            ZoneTypeStr = GetSystemString(1316);
            // End:0xBB
            break;
        // End:0x83
        case 5:
            ZoneTypeStr = GetSystemString(1317);
            // End:0xBB
            break;
        // End:0x9C
        case 6:
            ZoneTypeStr = GetSystemString(1318);
            // End:0xBB
            break;
        // End:0xB5
        case 7:
            ZoneTypeStr = GetSystemString(1319);
            // End:0xBB
            break;
        // End:0xFFFF
        default:
            // End:0xBB
            break;
            break;
    }
    return ZoneTypeStr;
    return;
}

function string conv_zoneName(int search_zoneid)
{
    local string HuntingZoneName;
    local int i;

    i = 0;
    J0x07:

    // End:0x86 [Loop If]
    if(i < 250)
    {
        // End:0x7C
        if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
        {
            // End:0x7C
            if(Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i) == 0)
            {
                // End:0x7C
                if(Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i) == search_zoneid)
                {
                    HuntingZoneName = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i);
                }
            }
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return HuntingZoneName;
    return;
}

function CastleInfo()
{
    RequestAllCastleInfo();
    return;
}

function FortressInfo()
{
    RequestAllFortressInfo();
    return;
}

function AgitInfo()
{
    RequestAllAgitInfo();
    return;
}

function FortressSeigeInfoReq()
{
    RequestFortressSiegeInfo();
    return;
}

function int GetMapCastleID(string CastleName)
{
    local int i, resultval;

    i = 0;
    J0x07:

    // End:0x46 [Loop If]
    if(i < 250)
    {
        // End:0x3C
        if(Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i) == CastleName)
        {
            resultval = i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return resultval;
    return;
}

function LoadCastleInfo(string param)
{
    local int castleID;
    local string OwnerClanName, OwnerClanNameToolTip, TaxRate, NextSiegeTime, NextSiegeYear, NextSiegeMonth,
	    NextSiegeDay, NextSiegeHour, NextSiegeMin, NextSiegeSec;

    local LVDataRecord Record;
    local LVData data1, data2, data3, data4;
    local Vector loc;
    local string DataforMap, CastleName;
    local int ZoneID;

    ParseInt(param, "CastleID", castleID);
    CastleName = getInstanceL2Util().getCastleNameEx(castleID);
    ParseString(param, "OwnerClanName", OwnerClanName);
    ParseString(param, "TaxRate", TaxRate);
    ParseString(param, "NextSiegeYear", NextSiegeYear);
    ParseString(param, "NextSiegeMonth", NextSiegeMonth);
    ParseString(param, "NextSiegeDay", NextSiegeDay);
    ParseString(param, "NextSiegeHour", NextSiegeHour);
    ParseString(param, "NextSiegeMin", NextSiegeMin);
    ParseString(param, "NextSiegeSec", NextSiegeSec);
    ZoneID = g_CastleID[castleID];
    // End:0x164
    if(OwnerClanName == "")
    {
        OwnerClanName = GetSystemString(27);
        OwnerClanNameToolTip = GetSystemMessage(2196);        
    }
    else
    {
        OwnerClanNameToolTip = MakeFullSystemMsg(GetSystemMessage(2197), OwnerClanName);
        OwnerClanName = OwnerClanName @ GetSystemString(439);
    }
    // End:0x1D8
    if(((NextSiegeMonth == "0") && NextSiegeYear == "70") && NextSiegeDay == "1")
    {
        NextSiegeTime = GetSystemString(584);        
    }
    else
    {
        NextSiegeMonth = string(int(NextSiegeMonth) + 1);
        NextSiegeTime = MakeFullSystemMsg(GetSystemMessage(2203), NextSiegeMonth, NextSiegeDay);
    }
    data1.nReserved1 = ZoneID;
    data1.szData = CastleName;
    Record.LVDataList[0] = data1;
    data2.szData = OwnerClanName;
    Record.LVDataList[1] = data2;
    data3.szData = TaxRate $ "%";
    Record.LVDataList[2] = data3;
    data4.szData = NextSiegeTime;
    Record.LVDataList[3] = data4;
    m_CastleListCtrl.InsertRecord(Record);
    loc = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(ZoneID);
    DataforMap = "";
    DataforMap = "";
    return;
}

function LoadFortressInfo(string param)
{
    local int FortressID;
    local string OwnerClanName, OwnerClanNameToolTip;
    local int SiegeState, LastOwndedTime;
    local LVDataRecord Record;
    local LVData data1, data2, data3, data4;
    local Vector loc;
    local string DataforMap, CastleName, Statcur;
    local int ZoneID;
    local string IconName;
    local int Hour, Date, Min, Sec;
    local string DateTotal;

    Hour = 0;
    Date = 0;
    Min = 0;
    Sec = 0;
    ParseInt(param, "FortressID", FortressID);
    CastleName = getInstanceL2Util().getCastleNameEx(FortressID);
    ParseString(param, "OwnerClanName", OwnerClanName);
    ParseInt(param, "SiegeStatae", SiegeState);
    ParseInt(param, "LastOwnedTime", LastOwndedTime);
    ZoneID = g_CastleID[FortressID];
    // End:0xED
    if(OwnerClanName == "")
    {
        OwnerClanName = GetSystemString(27);
        OwnerClanNameToolTip = GetSystemMessage(2196);        
    }
    else
    {
        OwnerClanNameToolTip = MakeFullSystemMsg(GetSystemMessage(2197), OwnerClanName);
        OwnerClanName = OwnerClanName @ GetSystemString(439);
    }
    // End:0x165
    if(SiegeState == 0)
    {
        Statcur = GetSystemString(894);
        IconName = "L2UI_CT1.ICON_DF_SIEGE_SHIELD";        
    }
    else
    {
        // End:0x1A5
        if(SiegeState == 1)
        {
            Statcur = GetSystemString(340);
            IconName = "L2UI_CT1.ICON_DF_SIEGE_SWORD";
        }
    }
    Min = LastOwndedTime / 60;
    Hour = Min / 60;
    Date = Hour / 24;
    // End:0x208
    if((Min < 60) && Min != 0)
    {
        DateTotal = string(Min) @ GetSystemString(1111);        
    }
    else
    {
        // End:0x23E
        if((Hour < 60) && Hour != 0)
        {
            DateTotal = string(Hour) @ GetSystemString(1110);            
        }
        else
        {
            // End:0x263
            if(Date != 0)
            {
                DateTotal = string(Date) @ GetSystemString(1109);
            }
        }
    }
    data1.nReserved1 = ZoneID;
    data1.szData = CastleName;
    Record.LVDataList[0] = data1;
    data2.szData = OwnerClanName;
    Record.LVDataList[1] = data2;
    data3.szData = Statcur;
    Record.LVDataList[2] = data3;
    // End:0x2FB
    if(LastOwndedTime == 0)
    {
        data4.szData = GetSystemString(27);        
    }
    else
    {
        data4.szData = DateTotal;
    }
    Record.LVDataList[3] = data4;
    m_FortressListCtrl.InsertRecord(Record);
    return;
}

function LoadAgitInfo(string param)
{
    local int AgitID;
    local string OwnerClanName, OwnerClanMasterName;
    local int Type;
    local LVDataRecord Record;
    local LVData data1, data2, data3, data4;
    local Vector loc;
    local string DataforMap, CastleName;
    local int ZoneID;
    local string History;

    ParseInt(param, "AgitID", AgitID);
    CastleName = getInstanceL2Util().getCastleNameEx(AgitID);
    ParseString(param, "OwnerClanName", OwnerClanName);
    // End:0x6C
    if(OwnerClanName == "")
    {
        OwnerClanName = GetSystemString(27);
    }
    ParseString(param, "OwnerClanMasterName", OwnerClanMasterName);
    // End:0xAB
    if(OwnerClanMasterName == "")
    {
        OwnerClanMasterName = GetSystemString(27);
    }
    ParseInt(param, "Type", Type);
    ZoneID = g_CastleID[AgitID];
    // End:0xF1
    if(Type == 0)
    {
        History = GetSystemString(1706);        
    }
    else
    {
        // End:0x110
        if(Type == 1)
        {
            History = GetSystemString(1210);            
        }
        else
        {
            // End:0x12A
            if(Type == 2)
            {
                History = GetSystemString(49);
            }
        }
    }
    data1.nReserved1 = AgitID;
    data1.szData = CastleName;
    Record.LVDataList[0] = data1;
    data2.szData = OwnerClanName;
    Record.LVDataList[1] = data2;
    data3.szData = OwnerClanMasterName;
    Record.LVDataList[2] = data3;
    data4.szData = History;
    Record.LVDataList[3] = data4;
    m_AgitListCtrl.InsertRecord(Record);
    loc.X = float(agitid1[AgitID]);
    loc.Y = float(agitid2[AgitID]);
    DataforMap = "";
    return;
}

function LoadFortressSeigeInfo(string param)
{
    local int FortressID;
    local Vector loc;
    local string DataforMap, CastleName;
    local int ZoneID;
    local string IconName;
    local int TotalBarrackCnt, CapturedBarrackCnt;
    local string CurrentStat, currentText;

    ParseInt(param, "FortressID", FortressID);
    CastleName = getInstanceL2Util().getCastleNameEx(FortressID);
    ParseInt(param, "TotalBarrackCnt", TotalBarrackCnt);
    ParseInt(param, "CapturedBarrackCnt", CapturedBarrackCnt);
    currentText = GetSystemString(340);
    CurrentStat = (string(CapturedBarrackCnt) $ "/") $ string(TotalBarrackCnt);
    IconName = "L2UI_CT1.ICON_DF_SIEGE_SWORD";
    ZoneID = g_CastleID[FortressID];
    DataforMap = "";
    loc = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(ZoneID);
    ParamAdd(DataforMap, "Index", string(FortressID - 100));
    ParamAdd(DataforMap, "WorldX", string(loc.X - float(3400)));
    ParamAdd(DataforMap, "WorldY", string(loc.Y - float(6400)));
    ParamAdd(DataforMap, "BtnTexNormal", IconName);
    ParamAdd(DataforMap, "BtnTexPushed", IconName);
    ParamAdd(DataforMap, "BtnTexOver", IconName);
    ParamAdd(DataforMap, "BtnWidth", string(30));
    ParamAdd(DataforMap, "BtnHeight", string(30));
    // End:0x237
    if((ReduceButton.IsShowWindow() == false) || ReduceButton_Expand.IsShowWindow() == false)
    {
        m_MiniMap.AddRegionInfo(DataforMap);
    }
    DataforMap = "";
    return;
}

function SetCastleLocData()
{
    g_CastleID[1] = 43;
    g_CastleID[2] = 9;
    g_CastleID[3] = 27;
    g_CastleID[4] = 83;
    g_CastleID[5] = 112;
    g_CastleID[6] = 127;
    g_CastleID[7] = 182;
    g_CastleID[8] = 202;
    g_CastleID[9] = 156;
    g_CastleID[101] = 254;
    g_CastleID[102] = 255;
    g_CastleID[103] = 250;
    g_CastleID[104] = 253;
    g_CastleID[105] = 256;
    g_CastleID[106] = 261;
    g_CastleID[107] = 262;
    g_CastleID[108] = 264;
    g_CastleID[109] = 267;
    g_CastleID[110] = 269;
    g_CastleID[111] = 266;
    g_CastleID[112] = 251;
    g_CastleID[113] = 257;
    g_CastleID[114] = 252;
    g_CastleID[115] = 258;
    g_CastleID[116] = 259;
    g_CastleID[117] = 260;
    g_CastleID[118] = 263;
    g_CastleID[119] = 265;
    g_CastleID[120] = 268;
    g_CastleID[121] = 270;
    agitid1[21] = 43370;
    agitid1[22] = -16029;
    agitid1[23] = -14848;
    agitid1[24] = -13879;
    agitid1[25] = -12710;
    agitid1[26] = -84416;
    agitid1[27] = -84171;
    agitid1[28] = -84236;
    agitid1[29] = -79544;
    agitid1[30] = -79513;
    agitid1[31] = 17760;
    agitid1[32] = 18800;
    agitid1[33] = 20096;
    agitid1[34] = 177930;
    agitid1[35] = 80339;
    agitid1[36] = 149134;
    agitid1[37] = 150644;
    agitid1[38] = 145667;
    agitid1[39] = 150748;
    agitid1[40] = 143992;
    agitid1[41] = 144014;
    agitid1[42] = 78592;
    agitid1[43] = 82032;
    agitid1[44] = 83392;
    agitid1[45] = 80960;
    agitid1[46] = 82064;
    agitid1[47] = 146022;
    agitid1[48] = 146960;
    agitid1[49] = 148480;
    agitid1[50] = 149376;
    agitid1[51] = 37736;
    agitid1[52] = 38737;
    agitid1[53] = 39403;
    agitid1[54] = 39599;
    agitid1[55] = 39440;
    agitid1[56] = 38712;
    agitid1[57] = 37711;
    agitid1[58] = 85812;
    agitid1[59] = 86609;
    agitid1[60] = 88093;
    agitid1[61] = 88901;
    agitid1[62] = 140949;
    agitid1[63] = 60608;
    agitid1[64] = 57932;
    agitid2[21] = 108839;
    agitid2[22] = 123642;
    agitid2[23] = 125552;
    agitid2[24] = 125413;
    agitid2[25] = 124029;
    agitid2[26] = 152192;
    agitid2[27] = 153385;
    agitid2[28] = 155520;
    agitid2[29] = 150181;
    agitid2[30] = 151506;
    agitid2[31] = 145200;
    agitid2[32] = 143248;
    agitid2[33] = 146064;
    agitid2[34] = -18629;
    agitid2[35] = -15442;
    agitid2[36] = 23140;
    agitid2[37] = 23653;
    agitid2[38] = 25356;
    agitid2[39] = 26540;
    agitid2[40] = 27092;
    agitid2[41] = 28202;
    agitid2[42] = 148080;
    agitid2[43] = 145328;
    agitid2[44] = 145328;
    agitid2[45] = 151600;
    agitid2[46] = 151904;
    agitid2[47] = -55560;
    agitid2[48] = -56768;
    agitid2[49] = -56848;
    agitid2[50] = -55568;
    agitid2[51] = -50777;
    agitid2[52] = -50491;
    agitid2[53] = -49668;
    agitid2[54] = -48264;
    agitid2[55] = -46806;
    agitid2[56] = -46042;
    agitid2[57] = -45723;
    agitid2[58] = -143183;
    agitid2[59] = -141949;
    agitid2[60] = -141931;
    agitid2[61] = -143200;
    agitid2[62] = -124658;
    agitid2[63] = -94016;
    agitid2[64] = -26064;
    agitid3[21] = -1980;
    agitid3[22] = -3101;
    agitid3[23] = -3128;
    agitid3[24] = -3128;
    agitid3[25] = -3096;
    agitid3[26] = -3123;
    agitid3[27] = -3159;
    agitid3[28] = -3160;
    agitid3[29] = -3038;
    agitid3[30] = -3041;
    agitid3[31] = -3036;
    agitid3[32] = -3010;
    agitid3[33] = -3111;
    agitid3[34] = -2240;
    agitid3[35] = -1804;
    agitid3[36] = -2160;
    agitid3[37] = -2150;
    agitid3[38] = -2150;
    agitid3[39] = -2280;
    agitid3[40] = -2290;
    agitid3[41] = -2280;
    agitid3[42] = -3581;
    agitid3[43] = -3520;
    agitid3[44] = -3389;
    agitid3[45] = -3517;
    agitid3[46] = -3520;
    agitid3[47] = -2765;
    agitid3[48] = -2765;
    agitid3[49] = -2765;
    agitid3[50] = -2765;
    agitid3[51] = 950;
    agitid3[52] = 950;
    agitid3[53] = 950;
    agitid3[54] = 950;
    agitid3[55] = 950;
    agitid3[56] = 950;
    agitid3[57] = 950;
    agitid3[58] = -1230;
    agitid3[59] = -1230;
    agitid3[60] = -1230;
    agitid3[61] = -1230;
    agitid3[62] = -1800;
    agitid3[63] = -1349;
    agitid3[64] = 595;
    return;
}

function HandleDominionInfoCnt(string param)
{
    m_TerritoryListCtrl.DeleteAllItem();
    ParseInt(param, "DominionInfoCnt", m_DominionInfoCnt);
    return;
}

function HandleDominionInfo(string param)
{
    local int DominionID, DominionName;
    local string ClanName;
    local int DominionsOwnCnt, DominionsOwnName[8], NextDate, i;
    local LVDataRecord Record;
    local LVData data1, data2, data3, data4;
    local Vector loc;
    local string DataforMap, CastleName;
    local int ZoneID;
    local Texture DominionFlagTex, DominionFlagTexreset;

    ParseInt(param, "DominionID", DominionID);
    ParseInt(param, "DominionsOwnCnt", DominionsOwnCnt);
    ParseInt(param, "NextDate", NextDate);
    ParseInt(param, "DominionName", DominionName);
    ParseString(param, "ClanName", ClanName);
    ZoneID = g_CastleID[DominionID - 80];
    data3.arrTexture.Length = 9;
    i = 1;
    J0xB9:

    // End:0x1EE [Loop If]
    if(i < 10)
    {
        ParseInt(param, "HaveOwnthingDominionID" $ string(i), DominionsOwnName[i]);
        DominionFlagTex = DominionFlagTexreset;
        DominionFlagTex = GetGuideDominionIcon(DominionsOwnName[i]);
        data3.arrTexture[i - 1].objTex = DominionFlagTex;
        data3.arrTexture[i - 1].Width = 12;
        data3.arrTexture[i - 1].Height = 12;
        data3.arrTexture[i - 1].X = i * 12;
        data3.arrTexture[i - 1].Y = 0;
        data3.arrTexture[i - 1].U = 32;
        data3.arrTexture[i - 1].V = 32;
        i++;
        // [Loop Continue]
        goto J0xB9;
    }
    Record.LVDataList[2] = data3;
    CastleName = getInstanceL2Util().getCastleNameEx(DominionID);
    data1.nReserved1 = ZoneID;
    data1.szData = CastleName;
    Record.LVDataList[0] = data1;
    data2.szData = ClanName;
    Record.LVDataList[1] = data2;
    data4.szData = ConvertTimetoStr(NextDate);
    Record.LVDataList[3] = data4;
    m_TerritoryListCtrl.InsertRecord(Record);
    loc = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(ZoneID);
    return;
}

function Texture GetGuideDominionIcon(int castleID)
{
    switch(castleID)
    {
        // End:0x4A
        case 81:
            return GetTexture("L2UI_CT1.GuideWnd.GuideWnd_DF_TerritoryWarIcon_Gludio");
        // End:0x8B
        case 82:
            return GetTexture("L2UI_CT1.GuideWnd.GuideWnd_DF_TerritoryWarIcon_Dion");
        // End:0xCD
        case 83:
            return GetTexture("L2UI_CT1.GuideWnd.GuideWnd_DF_TerritoryWarIcon_Giran");
        // End:0x10E
        case 84:
            return GetTexture("L2UI_CT1.GuideWnd.GuideWnd_DF_TerritoryWarIcon_Oren");
        // End:0x14F
        case 85:
            return GetTexture("L2UI_CT1.GuideWnd.GuideWnd_DF_TerritoryWarIcon_Aden");
        // End:0x194
        case 86:
            return GetTexture("L2UI_CT1.GuideWnd.GuideWnd_DF_TerritoryWarIcon_Innadril");
        // End:0x1D7
        case 87:
            return GetTexture("L2UI_CT1.GuideWnd.GuideWnd_DF_TerritoryWarIcon_Godard");
        // End:0x218
        case 88:
            return GetTexture("L2UI_CT1.GuideWnd.GuideWnd_DF_TerritoryWarIcon_Rune");
        // End:0x25F
        case 89:
            return GetTexture("L2UI_CT1.GuideWnd.GuideWnd_DF_TerritoryWarIcon_Schuttgart");
        // End:0xFFFF
        default:
            // End:0x265
            break;
            break;
    }
    return;
}

defaultproperties
{
    m_WindowName="GuideWnd"
}