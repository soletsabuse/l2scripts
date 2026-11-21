class MinimapMissionWnd extends UICommonAPI;

struct MapListInfo
{
    var string sortingKey;
    var int Index;
};

var WindowHandle Me;
var TextBoxHandle TxtMission_Title;
var WindowHandle MissionTab;
var ButtonHandle BTN_Huntingzone;
var ButtonHandle BTN_Inzone;
var ButtonHandle BTN_Raid;
var ListCtrlHandle Mission_ListCtrl;
var WindowHandle LocalInfoTab;
var ListCtrlHandle LocalInfo_ListCtrl;
var TabHandle TabCtrl;
var MinimapWnd miniMapWndScript;
var bool bShowHuntingZone;
var bool bShowInzone;
var bool bShowRaid;
var LVDataRecord lastSelectListRecord;
//var delegate<OnSortCompare> __OnSortCompare__Delegate;
//var delegate<OnSortCompareForRaid> __OnSortCompareForRaid__Delegate;

function OnRegisterEvent()
{
    RegisterEvent(40);
    RegisterEvent(5860);
    RegisterEvent(10181);
    return;
}

function OnLoad()
{
    Initialize();
    load();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("MinimapMissionWnd");
    TxtMission_Title = GetTextBoxHandle("MinimapMissionWnd.TxtMission_Title");
    MissionTab = GetWindowHandle("MinimapMissionWnd.MissionTab");
    BTN_Huntingzone = GetButtonHandle("MinimapMissionWnd.MissionTab.BTN_Huntingzone");
    BTN_Inzone = GetButtonHandle("MinimapMissionWnd.MissionTab.BTN_Inzone");
    BTN_Raid = GetButtonHandle("MinimapMissionWnd.MissionTab.BTN_Raid");
    Mission_ListCtrl = GetListCtrlHandle("MinimapMissionWnd.MissionTab.Mission_ListCtrl");
    LocalInfoTab = GetWindowHandle("MinimapMissionWnd.LocalInfoTab");
    LocalInfo_ListCtrl = GetListCtrlHandle("MinimapMissionWnd.LocalInfoTab.LocalInfo_ListCtrl");
    TabCtrl = GetTabHandle("MinimapMissionWnd.TabCtrl");
    miniMapWndScript = MinimapWnd(GetScript("MinimapWnd"));
    return;
}

function OnShow()
{
    updateOptionSave();
    refresh();
    return;
}

function load()
{
    Init();
    return;
}

function Init()
{
    bShowRaid = true;
    bShowInzone = true;
    bShowHuntingZone = true;
    LocalInfo_ListCtrl.DeleteAllItem();
    Mission_ListCtrl.DeleteAllItem();
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x14
        case "BTN_Raid":
        // End:0x23
        case "BTN_Inzone":
        // End:0x45
        case "BTN_Huntingzone":
            toggleButtonClick(Name);
            // End:0x95
            break;
        // End:0x52
        case "TabCtrl0":
        // End:0x62
        case "TabCtrl1":
            // End:0x95
            break;
        // End:0x92
        case "CloseButton":
            miniMapWndScript.OnClickButton("OpenGuideWnd");
            // End:0x95
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function toggleButtonClick(string buttonName)
{
    switch(buttonName)
    {
        // End:0x8D
        case "BTN_Raid":
            bShowRaid = !bShowRaid;
            miniMapWndScript.showRegionIcon(int(7), bShowRaid);
            SetINIBool("MinimapMissionWnd", "a", bShowRaid, "WindowsInfo.ini");
            Debug((buttonName @ ": ") @ string(bShowRaid));
            // End:0x16F
            break;
        // End:0xFA
        case "BTN_Inzone":
            bShowInzone = !bShowInzone;
            miniMapWndScript.showRegionIcon(int(6), bShowInzone);
            SetINIBool("MinimapMissionWnd", "e", bShowInzone, "WindowsInfo.ini");
            // End:0x16F
            break;
        // End:0x16C
        case "BTN_Huntingzone":
            bShowHuntingZone = !bShowHuntingZone;
            miniMapWndScript.showRegionIcon(int(5), bShowHuntingZone);
            SetINIBool("MinimapMissionWnd", "p", bShowHuntingZone, "WindowsInfo.ini");
            // End:0x16F
            break;
        // End:0xFFFF
        default:
            break;
    }
    refresh();
    return;
}

function updateOptionSave()
{
    local int nHunt, nInzone, nRaid, nFirstRun;

    GetINIBool("MinimapMissionWnd", "l", nFirstRun, "WindowsInfo.ini");
    GetINIBool("MinimapMissionWnd", "a", nRaid, "WindowsInfo.ini");
    GetINIBool("MinimapMissionWnd", "e", nInzone, "WindowsInfo.ini");
    GetINIBool("MinimapMissionWnd", "p", nHunt, "WindowsInfo.ini");
    // End:0x1B5
    if(nFirstRun == 0)
    {
        bShowRaid = true;
        bShowInzone = true;
        bShowHuntingZone = true;
        SetINIBool("MinimapMissionWnd", "a", bShowRaid, "WindowsInfo.ini");
        SetINIBool("MinimapMissionWnd", "e", bShowInzone, "WindowsInfo.ini");
        SetINIBool("MinimapMissionWnd", "p", bShowHuntingZone, "WindowsInfo.ini");
        SetINIBool("MinimapMissionWnd", "l", true, "WindowsInfo.ini");        
    }
    else
    {
        bShowRaid = numToBool(nRaid);
        bShowInzone = numToBool(nInzone);
        bShowHuntingZone = numToBool(nHunt);
    }
    miniMapWndScript.showRegionIcon(int(7), bShowRaid);
    miniMapWndScript.showRegionIcon(int(6), bShowInzone);
    miniMapWndScript.showRegionIcon(int(5), bShowHuntingZone);
    return;
}

function updateToggleButton()
{
    // End:0x83
    if(bShowRaid)
    {
        BTN_Raid.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");        
    }
    else
    {
        BTN_Raid.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
    }
    // End:0x197
    if(bShowHuntingZone)
    {
        BTN_Huntingzone.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");        
    }
    else
    {
        BTN_Huntingzone.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
    }
    // End:0x3B2
    if(getInstanceUIData().getIsClassicServer())
    {
        bShowInzone = false;
        BTN_Inzone.HideWindow();
        GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Inzone_Tex").HideWindow();
        BTN_Raid.ClearAnchor();
        BTN_Raid.SetAnchor("MinimapMissionWnd.MissionTab.BTN_Huntingzone", "TopLeft", "TopLeft", 107, 0);
        GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Raid_Tex").ClearAnchor();
        GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Raid_Tex").SetAnchor("MinimapMissionWnd.MissionTab.BTN_Raid", "TopLeft", "TopLeft", 6, 5);        
    }
    else
    {
        BTN_Raid.ClearAnchor();
        BTN_Raid.SetAnchor("MinimapMissionWnd.MissionTab.BTN_Huntingzone", "TopLeft", "TopLeft", 254, 0);
        GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Raid_Tex").ClearAnchor();
        GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Raid_Tex").SetAnchor("MinimapMissionWnd.MissionTab.BTN_Raid", "TopLeft", "TopLeft", 6, 5);
        BTN_Inzone.ShowWindow();
        GetTextureHandle("MinimapMissionWnd.MissionTab.BTNICON_Inzone_Tex").ShowWindow();
        // End:0x5A1
        if(bShowInzone)
        {
            BTN_Inzone.SetTexture("L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small", "L2UI_CT1.Button.Button_DF_Small_Over");            
        }
        else
        {
            BTN_Inzone.SetTexture("L2UI_CT1.Button.Button_DF_Small_Toggle", "L2UI_CT1.Button.Button_DF_Small_Toggle_Down", "L2UI_CT1.Button.Button_DF_Small_Toggle_Over");
        }
    }
    return;
}

function bool isShowRaid()
{
    return bShowRaid;
    return;
}

function bool isShowInzone()
{
    return bShowInzone;
    return;
}

function bool isShowHuntingZone()
{
    return bShowHuntingZone;
    return;
}

function refresh()
{
    updateToggleButton();
    addMissionList();
    addLocalList();
    return;
}

function addMissionList()
{
    local int i;
    local array<MapListInfo> nHuntingArray, nInzoneArray;
    local UserInfo pUserInfo;
    local HuntingZoneUIData huntingZoneData;

    GetPlayerInfo(pUserInfo);
    Mission_ListCtrl.DeleteAllItem();
    nHuntingArray.Remove(0, nHuntingArray.Length);
    nInzoneArray.Remove(0, nInzoneArray.Length);
    i = 0;
    J0x3B:

    // End:0x212 [Loop If]
    if(i < 500)
    {
        // End:0x67
        if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i) == false)
        {
            // [Explicit Continue]
            goto J0x208;
        }
        Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
        // End:0x150
        if(((huntingZoneData.nType == int(1)) || huntingZoneData.nType == int(2)) || huntingZoneData.nType == int(10))
        {
            // End:0x14D
            if(bShowHuntingZone)
            {
                // End:0xF3
                if((tryLevelCheck(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel)) == false)
                {
                    // [Explicit Continue]
                    goto J0x208;
                }
                nHuntingArray.Insert(nHuntingArray.Length, 1);
                nHuntingArray[nHuntingArray.Length - 1].Index = i;
                nHuntingArray[nHuntingArray.Length - 1].sortingKey = getInstanceL2Util().makeZeroString(4, (huntingZoneData.nMinLevel));
            }
            // [Explicit Continue]
            goto J0x208;
        }
        // End:0x208
        if((huntingZoneData.nType == int(3)) || huntingZoneData.nType == int(4))
        {
            // End:0x208
            if(bShowInzone)
            {
                // End:0x1AE
                if((tryLevelCheck(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel)) == false)
                {
                    // [Explicit Continue]
                    goto J0x208;
                }
                nInzoneArray.Insert(nInzoneArray.Length, 1);
                nInzoneArray[nInzoneArray.Length - 1].Index = i;
                nInzoneArray[nInzoneArray.Length - 1].sortingKey = getInstanceL2Util().makeZeroString(4, (huntingZoneData.nMinLevel));
            }
        }
        J0x208:

        i++;
        // [Loop Continue]
        goto J0x3B;
    }
    makeMapList(Mission_ListCtrl, nHuntingArray, GetSystemString(1296), true, "L2UI_CT1.Minimap.Mission_huntingzone", false);
    makeMapList(Mission_ListCtrl, nInzoneArray, GetSystemString(2668), true, "L2UI_CT1.Minimap.Mission_inzone", true);
    // End:0x2A3
    if(bShowInzone)
    {
        RequestInzoneWaitingTime(false);
    }
    // End:0x2B2
    if(bShowRaid)
    {
        makeRaidList();
    }
    missionListBeforeSelect();
    return;
}

function missionListBeforeSelect()
{
    local int i, nInstantZoneID, Index, nFactionID, NpcID, selectedInstantZoneID,
	    SelectedIndex, selectedNFactionID, selectedNpcID;

    local LVDataRecord Record;

    i = 0;
    J0x07:

    // End:0x227 [Loop If]
    if(i < Mission_ListCtrl.GetRecordCount())
    {
        Mission_ListCtrl.GetRec(i, Record);
        // End:0x4D
        if(Record.LVDataList.Length == 0)
        {
            // [Explicit Continue]
            goto J0x21D;
        }
        ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
        ParseInt(Record.LVDataList[0].szReserved, "nFactionID", nFactionID);
        ParseInt(Record.LVDataList[0].szReserved, "index", Index);
        ParseInt(Record.LVDataList[0].szReserved, "npcID", NpcID);
        // End:0xFA
        if(lastSelectListRecord.LVDataList.Length == 0)
        {
            // [Explicit Continue]
            goto J0x21D;
        }
        ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "instantZoneID", selectedInstantZoneID);
        ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "nFactionID", selectedNFactionID);
        ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "index", SelectedIndex);
        ParseInt(lastSelectListRecord.LVDataList[0].szReserved, "npcID", selectedNpcID);
        // End:0x1B6
        if((((nInstantZoneID + nFactionID) + Index) + NpcID) <= 0)
        {
            // [Explicit Continue]
            goto J0x21D;
        }
        // End:0x21D
        if((((nInstantZoneID == selectedInstantZoneID) && selectedNFactionID == nFactionID) && SelectedIndex == Index) || (selectedNpcID == NpcID) && selectedNpcID > 0)
        {
            Mission_ListCtrl.SetSelectedIndex(i, true);
            // [Explicit Break]
            goto J0x227;
        }
        J0x21D:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x227:

    return;
}

function makeMapList(ListCtrlHandle List, array<MapListInfo> targetMapListInfo, string headerString, bool bLevelLimitView, string headerIcon, optional bool bInstanceZoneID)
{
    local int N, i;
    local string addStr, backStr, szReserved;
    local HuntingZoneUIData huntingZoneData;

    N = 0;
    J0x07:

    // End:0x17F [Loop If]
    if(N < targetMapListInfo.Length)
    {
        addStr = "";
        szReserved = "";
        i = targetMapListInfo[N].Index;
        Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
        // End:0x8B
        if(N == 0)
        {
            addListItemHead(List, ((headerString $ " (") $ string(targetMapListInfo.Length)) $ ")", headerIcon);
        }
        ParamAdd(szReserved, "index", string(i));
        // End:0xD3
        if(bInstanceZoneID)
        {
            ParamAdd(szReserved, "instantZoneID", string(huntingZoneData.nInstantZoneID));
        }
        // End:0xED
        if(bLevelLimitView)
        {
            addStr = getLevelRangeString(i);
        }
        backStr = "";
        // End:0x12E
        if((huntingZoneData.nInstantZoneID == 0) && bInstanceZoneID == true)
        {
            backStr = ("(" $ GetSystemString(3554)) $ ")";
        }
        addListItem(List, makeListLvDataText((addStr $ huntingZoneData.strName) $ backStr, getInstanceL2Util().Gold, huntingZoneData.nWorldLoc, szReserved));
        N++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function addLocalList()
{
    local int i;
    local array<MapListInfo> nCastlevilleArray, nFortressArray, nAgitCountArray, nHuntingZoneArray, nFactionArray;

    local HuntingZoneUIData huntingZoneData;

    // End:0x328
    if(LocalInfo_ListCtrl.GetRecordCount() <= 0)
    {
        LocalInfo_ListCtrl.DeleteAllItem();
        nCastlevilleArray.Remove(0, nCastlevilleArray.Length);
        nFortressArray.Remove(0, nFortressArray.Length);
        nAgitCountArray.Remove(0, nAgitCountArray.Length);
        nHuntingZoneArray.Remove(0, nHuntingZoneArray.Length);
        nFactionArray.Remove(0, nFactionArray.Length);
        i = 0;
        J0x6C:

        // End:0x266 [Loop If]
        if(i < 500)
        {
            // End:0x98
            if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i) == false)
            {
                // [Explicit Continue]
                goto J0x25C;
            }
            Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
            // End:0x10D
            if(huntingZoneData.nType == int(8))
            {
                nCastlevilleArray.Insert(nCastlevilleArray.Length, 1);
                nCastlevilleArray[nCastlevilleArray.Length - 1].Index = i;
                nCastlevilleArray[nCastlevilleArray.Length - 1].sortingKey = huntingZoneData.strName;
                // [Explicit Continue]
                goto J0x25C;
            }
            // End:0x169
            if(huntingZoneData.nType == int(9))
            {
                nFortressArray.Insert(nFortressArray.Length, 1);
                nFortressArray[nFortressArray.Length - 1].Index = i;
                nFortressArray[nFortressArray.Length - 1].sortingKey = huntingZoneData.strName;
                // [Explicit Continue]
                goto J0x25C;
            }
            // End:0x1C5
            if(huntingZoneData.nType == int(5))
            {
                nAgitCountArray.Insert(nAgitCountArray.Length, 1);
                nAgitCountArray[nAgitCountArray.Length - 1].Index = i;
                nAgitCountArray[nAgitCountArray.Length - 1].sortingKey = huntingZoneData.strName;
                // [Explicit Continue]
                goto J0x25C;
            }
            // End:0x25C
            if(((huntingZoneData.nType == int(1)) || huntingZoneData.nType == int(2)) || huntingZoneData.nType == int(10))
            {
                nHuntingZoneArray.Insert(nHuntingZoneArray.Length, 1);
                nHuntingZoneArray[nHuntingZoneArray.Length - 1].Index = i;
                nHuntingZoneArray[nHuntingZoneArray.Length - 1].sortingKey = getInstanceL2Util().makeZeroString(4, (huntingZoneData.nMinLevel));
            }
            J0x25C:

            i++;
            // [Loop Continue]
            goto J0x6C;
        }
        makeMapList(LocalInfo_ListCtrl, nCastlevilleArray, GetSystemString(3529), false, "L2UI_CT1.EmptyBtn");
        makeMapList(LocalInfo_ListCtrl, nFortressArray, GetSystemString(1605), false, "L2UI_CT1.EmptyBtn");
        makeMapList(LocalInfo_ListCtrl, nAgitCountArray, GetSystemString(1616), false, "L2UI_CT1.EmptyBtn");
        makeMapList(LocalInfo_ListCtrl, nHuntingZoneArray, GetSystemString(1296), true, "L2UI_CT1.EmptyBtn");
        makeFactionList();
    }
    return;
}

function makeFactionList()
{
    local array<L2UserFactionUIInfo> factionInfoListArray;
    local UserInfo pUserInfo;
    local int i, N;
    local string szReserved;
    local L2FactionUIData FactionData;
    local MinimapRegionIconData IconData;
    local Vector loc;

    GetPlayerInfo(pUserInfo);
    GetUserFactionInfoList(pUserInfo.nID, factionInfoListArray);
    i = 0;
    J0x27:

    // End:0x161 [Loop If]
    if(i < factionInfoListArray.Length)
    {
        GetFactionData(factionInfoListArray[i].nFactionID, FactionData);
        // End:0xAF
        if(GetMinimapRegionIconData(FactionData.nRegionID, IconData))
        {
            loc.X = float(IconData.nWorldLocX);
            loc.Y = float(IconData.nWorldLocY);
            loc.Z = float(IconData.nWorldLocZ);
        }
        // End:0xF8
        if(i == 0)
        {
            addListItemHead(LocalInfo_ListCtrl, ((GetSystemString(3443) $ " (") $ string(factionInfoListArray.Length)) $ ")", "L2UI_CT1.EmptyBtn");
        }
        szReserved = "";
        ParamAdd(szReserved, "nFactionID", string(FactionData.nFactionID));
        addListItem(LocalInfo_ListCtrl, makeListLvDataText(FactionData.strFactionName, getInstanceL2Util().Gold, loc, szReserved));
        i++;
        // [Loop Continue]
        goto J0x27;
    }
    return;
}

function makeRaidList()
{
    local UserInfo pUserInfo;
    local int i, RaidCount;
    local array<int> raidNpcIDArray;
    local string addStr, textStr;
    local array<RaidUIData> raidUIDataArray;
    local RaidUIData raidData;
    local array<int> raidDataKeyList;
    local string szReserved;

    GetPlayerInfo(pUserInfo);
    Class'NWindow.UIDATA_RAID'.static.GetRaidDataKeyList(raidDataKeyList);
    i = 0;
    J0x26:

    // End:0x113 [Loop If]
    if(i < raidDataKeyList.Length)
    {
        raidData = getRaidDataByIndex(raidDataKeyList[i]);
        addStr = "";
        // End:0xA1
        if(((raidData.nWorldLoc.X == float(0)) && raidData.nWorldLoc.Y == float(0)) && raidData.nWorldLoc.Z == float(0))
        {
            // [Explicit Continue]
            goto J0x109;
        }
        // End:0xCE
        if((tryLevelCheck(pUserInfo.nLevel, raidData.nMinLevel, raidData.nMaxLevel)) == false)
        {
            // [Explicit Continue]
            goto J0x109;
        }
        raidData.sortingKey = getInstanceL2Util().makeZeroString(4, (raidData.nRaidMonsterLevel));
        raidUIDataArray[raidUIDataArray.Length] = raidData;
        J0x109:

        i++;
        // [Loop Continue]
        goto J0x26;
    }
    i = 0;
    J0x11A:

    // End:0x2ED [Loop If]
    if(i < raidUIDataArray.Length)
    {
        // End:0x17F
        if(RaidCount == 0)
        {
            addListItemHead(Mission_ListCtrl, ((GetSystemString(1297) $ " (") $ string(raidUIDataArray.Length)) $ ")", "L2UI_CT1.Minimap.Mission_raid");
        }
        RaidCount++;
        raidData = raidUIDataArray[i];
        szReserved = "";
        ParamAdd(szReserved, "npcID", string(raidData.nRaidMonsterID));
        ParamAdd(szReserved, "index", string(raidData.Id));
        addStr = ("[Lv." $ string(raidData.nRaidMonsterLevel)) $ "] ";
        ParamAdd(szReserved, "addStr", addStr);
        raidNpcIDArray[raidNpcIDArray.Length] = raidData.nRaidMonsterID;
        // End:0x280
        if((int(GetLanguage()) == int(8)) || int(GetLanguage()) == int(9))
        {
            textStr = (((addStr $ raidData.raidMonsterName) $ " (") $ GetSystemString(3526)) $ ")";            
        }
        else
        {
            textStr = (((addStr $ raidData.raidMonsterName) $ " (") $ GetSystemString(1718)) $ ")";
        }
        addListItem(Mission_ListCtrl, makeListLvDataText(textStr, getInstanceL2Util().ColorGray, raidData.nWorldLoc, szReserved));
        i++;
        // [Loop Continue]
        goto J0x11A;
    }
    // End:0x30D
    if(raidNpcIDArray.Length > 0)
    {
        Class'NWindow.MiniMapAPI'.static.RequestRaidBossSpawnInfo(raidNpcIDArray);
    }
    return;
}

function addListItem(ListCtrlHandle List, LVData lData)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 1;
    Record.LVDataList[0] = lData;
    List.InsertRecord(Record);
    return;
}

function addListItemHead(ListCtrlHandle List, string textStr, string IconName)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 1;
    Record.LVDataList[0].hasIcon = true;
    Record.LVDataList[0].szData = " " $ textStr;
    Record.LVDataList[0].nTextureWidth = 15;
    Record.LVDataList[0].nTextureHeight = 15;
    Record.LVDataList[0].nTextureU = 15;
    Record.LVDataList[0].nTextureV = 15;
    Record.LVDataList[0].szTexture = IconName;
    Record.LVDataList[0].iconBackTexName = "L2UI_CT1.List_HeadLineFrame";
    Record.LVDataList[0].backTexOffsetXFromIconPosX = -6;
    Record.LVDataList[0].backTexOffsetYFromIconPosY = 0;
    Record.LVDataList[0].backTexWidth = 354;
    Record.LVDataList[0].backTexHeight = 19;
    Record.LVDataList[0].backTexUL = 32;
    Record.LVDataList[0].backTexVL = 19;
    List.InsertRecord(Record);
    return;
}

function OnClickListCtrlRecord(string strID)
{
    local int idx, nInstantZoneID, nFactionID, Index, NpcID;

    local LVDataRecord Record;
    local HuntingZoneUIData huntingZoneData;
    local MinimapRegionIconData IconData;
    local L2FactionUIData FactionData;
    local Vector loc;

    // End:0x4D
    if(strID == "Mission_ListCtrl")
    {
        idx = Mission_ListCtrl.GetSelectedIndex();
        Mission_ListCtrl.GetRec(idx, Record);        
    }
    else
    {
        // End:0x99
        if(strID == "LocalInfo_ListCtrl")
        {
            idx = LocalInfo_ListCtrl.GetSelectedIndex();
            LocalInfo_ListCtrl.GetRec(idx, Record);
        }
    }
    loc.X = float(Record.LVDataList[0].nReserved1);
    loc.Y = float(Record.LVDataList[0].nReserved2);
    loc.Z = float(Record.LVDataList[0].nReserved3);
    ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
    ParseInt(Record.LVDataList[0].szReserved, "index", Index);
    ParseInt(Record.LVDataList[0].szReserved, "nFactionID", nFactionID);
    ParseInt(Record.LVDataList[0].szReserved, "npcID", NpcID);
    Debug("OnClickListCtrlRecord szReserved: " @ Record.LVDataList[0].szReserved);
    Debug("OnClickListCtrlRecord 1:" @ string(Record.LVDataList[0].nReserved1));
    Debug("OnClickListCtrlRecord 2:" @ string(Record.LVDataList[0].nReserved2));
    Debug("OnClickListCtrlRecord 3:" @ string(Record.LVDataList[0].nReserved3));
    lastSelectListRecord = Record;
    // End:0x2DB
    if(NpcID > 0)
    {
        loc.X = float(Record.LVDataList[0].nReserved1);
        loc.Y = float(Record.LVDataList[0].nReserved2);
        loc.Z = float(Record.LVDataList[0].nReserved3);        
    }
    else
    {
        // End:0x37F
        if(Index > 0)
        {
            Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(Index, huntingZoneData);
            GetMinimapRegionIconData(huntingZoneData.nRegionID, IconData);
            // End:0x36C
            if(huntingZoneData.nRegionID > 0)
            {
                loc.X = float(IconData.nWorldLocX);
                loc.Y = float(IconData.nWorldLocY);
                loc.Z = float(IconData.nWorldLocZ);                
            }
            else
            {
                loc = huntingZoneData.nWorldLoc;
            }            
        }
        else
        {
            // End:0x3F7
            if(nFactionID > 0)
            {
                GetFactionData(nFactionID, FactionData);
                // End:0x3F7
                if(GetMinimapRegionIconData(FactionData.nRegionID, IconData))
                {
                    loc.X = float(IconData.nWorldLocX);
                    loc.Y = float(IconData.nWorldLocY);
                    loc.Z = float(IconData.nWorldLocZ);
                }
            }
        }
    }
    // End:0x45E
    if((isVectorZero(loc)) == false)
    {
        miniMapWndScript.SetLocContinent(loc);
        miniMapWndScript.mapIconHighlight(loc, IconData);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, false);
    }
    // End:0x48C
    if(strID == "Mission_ListCtrl")
    {
        Mission_ListCtrl.SetFocus();        
    }
    else
    {
        // End:0x4B9
        if(strID == "LocalInfo_ListCtrl")
        {
            LocalInfo_ListCtrl.SetFocus();
        }
    }
    return;
}

function LVData makeListLvDataText(string textStr, Color pColor, Vector loc, optional string szReserved)
{
    local LVData lData;

    lData.bUseTextColor = true;
    lData.TextColor = pColor;
    lData.szData = textStr;
    lData.nReserved1 = int(loc.X);
    lData.nReserved2 = int(loc.Y);
    lData.nReserved3 = int(loc.Z);
    lData.szReserved = szReserved;
    return lData;
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x15
    if(Event_ID == 40)
    {
        Init();        
    }
    else
    {
        // End:0x32
        if(Event_ID == 10181)
        {
            updateRaidNpc(param);            
        }
        else
        {
            // End:0x4D
            if(Event_ID == 5860)
            {
                handleInzoneWaitingInfo(param);
            }
        }
    }
    return;
}

function string handleInzoneWaitingInfo(string param)
{
    local int sizeOfBlockedInzone, blockedInzoneID, i, M, nInstantZoneID, Index,
	    nDataSystemMessage, nShowWindow;

    local string addStr;
    local LVDataRecord Record;

    ParseInt(param, "ShowWindow", nShowWindow);
    ParseInt(param, "sizeOfBlockedInzone", sizeOfBlockedInzone);
    // End:0x3E6
    if(nShowWindow <= 0)
    {
        i = 0;
        J0x53:

        // End:0x205 [Loop If]
        if(i < sizeOfBlockedInzone)
        {
            ParseInt(param, "blockedInzoneID_" $ string(i), blockedInzoneID);
            M = 0;
            J0x94:

            // End:0x1FB [Loop If]
            if(M < Mission_ListCtrl.GetRecordCount())
            {
                Mission_ListCtrl.GetRec(M, Record);
                // End:0x1F1
                if(Record.LVDataList[0].szReserved != "")
                {
                    ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
                    ParseInt(Record.LVDataList[0].szReserved, "index", Index);
                    // End:0x1F1
                    if(nInstantZoneID == blockedInzoneID)
                    {
                        addStr = getLevelRangeString(Index);
                        Record.LVDataList[0].bUseTextColor = true;
                        Record.LVDataList[0].TextColor = getInstanceL2Util().ColorGray;
                        Record.LVDataList[0].szData = (((addStr $ GetInZoneNameWithZoneID(nInstantZoneID)) $ " (") $ GetSystemString(5099)) $ ")";
                        Mission_ListCtrl.ModifyRecord(M, Record);
                        miniMapWndScript.drawMinimapRegionInfo(6, Index, false, true);
                        // [Explicit Break]
                        goto J0x1FB;
                    }
                }
                M++;
                // [Loop Continue]
                goto J0x94;
            }
            J0x1FB:

            i++;
            // [Loop Continue]
            goto J0x53;
        }
        M = 0;
        J0x20C:

        // End:0x3E6 [Loop If]
        if(M < Mission_ListCtrl.GetRecordCount())
        {
            Mission_ListCtrl.GetRec(M, Record);
            // End:0x3DC
            if(Record.LVDataList[0].szReserved != "")
            {
                Index = 0;
                nInstantZoneID = 0;
                ParseInt(Record.LVDataList[0].szReserved, "instantZoneID", nInstantZoneID);
                ParseInt(Record.LVDataList[0].szReserved, "index", Index);
                // End:0x3DC
                if(nInstantZoneID > 0)
                {
                    nDataSystemMessage = miniMapWndScript.getServerNData(int(6));
                    // End:0x3DC
                    if(((nInstantZoneID == 265) || nInstantZoneID == 266) && ((nDataSystemMessage == 4432) || nDataSystemMessage == 4434) || nDataSystemMessage == 4435)
                    {
                        addStr = getLevelRangeString(Index);
                        Record.LVDataList[0].bUseTextColor = true;
                        Record.LVDataList[0].TextColor = getInstanceL2Util().ColorGray;
                        Record.LVDataList[0].szData = (((addStr $ GetInZoneNameWithZoneID(nInstantZoneID)) $ " (") $ GetSystemString(5099)) $ ")";
                        Mission_ListCtrl.ModifyRecord(M, Record);
                        miniMapWndScript.drawMinimapRegionInfo(6, Index, false, true);
                    }
                }
            }
            M++;
            // [Loop Continue]
            goto J0x20C;
        }
    }
    return;
}

function updateRaidNpc(string param)
{
    local int npcCount, i, NpcID;

    ParseInt(param, "NpcCount", npcCount);
    i = 0;
    J0x21:

    // End:0x71 [Loop If]
    if(i < npcCount)
    {
        ParseInt(param, "NpcId_" $ string(i), NpcID);
        // End:0x67
        if(NpcID > 0)
        {
            updateRaidListRecord(NpcID);
        }
        i++;
        // [Loop Continue]
        goto J0x21;
    }
    return;
}

function updateRaidListRecord(int NpcID)
{
    local LVDataRecord Record;
    local int i, currentNpcID, Index;
    local string addStr;

    i = 0;
    J0x07:

    // End:0x16A [Loop If]
    if(i < Mission_ListCtrl.GetRecordCount())
    {
        Mission_ListCtrl.GetRec(i, Record);
        // End:0x160
        if(Record.LVDataList[0].szReserved != "")
        {
            ParseInt(Record.LVDataList[0].szReserved, "npcID", currentNpcID);
            ParseInt(Record.LVDataList[0].szReserved, "index", Index);
            ParseString(Record.LVDataList[0].szReserved, "addStr", addStr);
            // End:0x160
            if(currentNpcID == NpcID)
            {
                Record.LVDataList[0].bUseTextColor = true;
                Record.LVDataList[0].TextColor = getInstanceL2Util().Gold;
                Record.LVDataList[0].szData = addStr $ Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
                Mission_ListCtrl.ModifyRecord(i, Record);
                miniMapWndScript.drawMinimapRegionInfo(7, Index, true, true);
                // [Explicit Break]
                goto J0x16A;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x16A:

    return;
}

function string getLevelRangeString(int i)
{
    local string addStr;
    local HuntingZoneUIData huntingZoneData;

    Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
    // End:0x6E
    if((huntingZoneData.nMinLevel != 0) && huntingZoneData.nMinLevel != 0)
    {
        addStr = ((("[Lv." $ string(huntingZoneData.nMinLevel)) $ "~") $ string(huntingZoneData.nMaxLevel)) $ "] ";
    }
    return addStr;
    return;
}

delegate int OnSortCompare(MapListInfo A, MapListInfo B)
{
    // End:0x22
    if(A.sortingKey > B.sortingKey)
    {
        return -1;        
    }
    else
    {
        return 0;
    }
    return;
}

delegate int OnSortCompareForRaid(RaidUIData A, RaidUIData B)
{
    // End:0x22
    if(A.sortingKey > B.sortingKey)
    {
        return -1;        
    }
    else
    {
        return 0;
    }
    return;
}
