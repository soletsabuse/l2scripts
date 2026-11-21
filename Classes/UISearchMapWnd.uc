class UISearchMapWnd extends UICommonAPI;

const MAX_HUNTINGZONE_NUM = 400;

var WindowHandle Me;
var ListCtrlHandle resultList;
var EditBoxHandle searchEditBox;
var ButtonHandle SearchBtn;
var ButtonHandle InitBtn;
var string m_WindowName;
var MinimapWnd miniMapWndScript;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("UISearchMapWnd");
    resultList = GetListCtrlHandle("UISearchMapWnd.resultList");
    SearchBtn = GetButtonHandle("UISearchMapWnd.searchBtn");
    InitBtn = GetButtonHandle("UISearchMapWnd.initBtn");
    searchEditBox = GetEditBoxHandle("UISearchMapWnd.searchEditBox");
    miniMapWndScript = MinimapWnd(GetScript("MinimapWnd"));
    GetTextBoxHandle("UISearchMapWnd.descTextBox").SetText("클릭: 맵보기, 더블클릭:이동");
    return;
}

function OnShow()
{
    initProcess();
    return;
}

function initProcess()
{
    searchEditBox.ClearAdditionalSearchList(3);
    inputData("", true);
    return;
}

function inputData(string searchStr, bool bAddList)
{
    local int i, MinLevel, MaxLevel, Zone, FieldType;

    local string HuntingZoneName, LevelLimit, modifiedString, mapWndStr;
    local LVDataRecord Record;
    local Vector loc;

    resultList.DeleteAllItem();
    Record.LVDataList.Length = 5;
    searchEditBox.ClearAdditionalSearchList(3);
    mapWndStr = miniMapWndScript.currentWndName();
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.DeleteAllTarget(mapWndStr $ ".Minimap");
    i = 0;
    J0x6A:

    // End:0x2B7 [Loop If]
    if(i < 400)
    {
        // End:0x2AD
        if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
        {
            FieldType = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i);
            // End:0x2AD
            if(true)
            {
                HuntingZoneName = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i);
                MinLevel = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetMinLevel(i);
                MaxLevel = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetMaxLevel(i);
                Zone = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i);
                // End:0x14C
                if((MinLevel > 0) && MaxLevel > 0)
                {
                    LevelLimit = (string(MinLevel) $ "~") $ string(MaxLevel);                    
                }
                else
                {
                    // End:0x179
                    if(MinLevel > 0)
                    {
                        LevelLimit = (string(MinLevel) $ " ") $ GetSystemString(859);                        
                    }
                    else
                    {
                        LevelLimit = GetSystemString(866);
                    }
                }
                modifiedString = Locs(HuntingZoneName, " ", "", false);
                loc = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(i);
                // End:0x2AD
                if(((loc.X != 0.0000000) && loc.Y != 0.0000000) && loc.Z != 0.0000000)
                {
                    searchEditBox.AddNameToAdditionalSearchList(HuntingZoneName, 3);
                    // End:0x2AD
                    if(StringMatching(modifiedString, searchStr, " ") || searchStr == "")
                    {
                        // End:0x2AD
                        if(bAddList)
                        {
                            // End:0x26B
                            if(searchStr != "")
                            {
                                Class'NWindow.UIAPI_MINIMAPCTRL'.static.AddTarget(mapWndStr $ ".Minimap", loc);
                            }
                            Record.LVDataList[0].nReserved1 = i;
                            Record.LVDataList[0].szData = HuntingZoneName;
                            resultList.InsertRecord(Record);
                        }
                    }
                }
            }
        }
        i++;
        // [Loop Continue]
        goto J0x6A;
    }
    return;
}

function OnDBClickListCtrlRecord(string Id)
{
    local LVDataRecord Record;
    local Vector loc;

    // End:0x130
    if("resultList" == Id)
    {
        resultList.GetSelectedRec(Record);
        loc = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
        // End:0x10E
        if(((loc.X != 0.0000000) && loc.Y != 0.0000000) && loc.Z != 0.0000000)
        {
            Debug((("teleport -> " @ string(loc.X)) @ string(loc.Y)) @ string(loc.Z));
            ProcessChatMessage((("//teleport" @ string(loc.X)) @ string(loc.Y)) @ string(loc.Z), 0);            
        }
        else
        {
            Debug("Error: loc X, Y, Z is zero");
        }
    }
    return;
}

function OnClickListCtrlRecord(string Id)
{
    local LVDataRecord Record;
    local Vector loc;
    local string mapWndStr;

    // End:0x14B
    if("resultList" == Id)
    {
        resultList.GetSelectedRec(Record);
        loc = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneLoc(Record.LVDataList[0].nReserved1);
        mapWndStr = miniMapWndScript.currentWndName();
        GetWindowHandle(mapWndStr).ShowWindow();
        MinimapWnd(GetScript("MinimapWnd")).SetLocContinent(loc);
        // End:0x14B
        if(((loc.X != 0.0000000) && loc.Y != 0.0000000) && loc.Z != 0.0000000)
        {
            Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView(mapWndStr $ ".Minimap", loc, false);
            Class'NWindow.UIAPI_MINIMAPCTRL'.static.DeleteAllTarget(mapWndStr $ ".Minimap");
            Class'NWindow.UIAPI_MINIMAPCTRL'.static.AddTarget(mapWndStr $ ".Minimap", loc);
        }
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1E
        case "searchBtn":
            OnSearchBtnClick();
            // End:0x71
            break;
        // End:0x6E
        case "initBtn":
            Class'NWindow.UIAPI_MINIMAPCTRL'.static.DeleteAllTarget(miniMapWndScript.currentWndName() $ ".Minimap");
            searchEditBox.SetString("");
            initProcess();
            // End:0x71
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnSearchBtnClick()
{
    inputData(searchEditBox.GetString(), true);
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x28
    if(searchEditBox.IsFocused())
    {
        // End:0x28
        if(int(nKey) == int(13))
        {
            OnSearchBtnClick();
        }
    }
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
    m_WindowName="UISearchMapWnd"
}