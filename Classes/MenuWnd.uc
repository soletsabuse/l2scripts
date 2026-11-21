class MenuWnd extends L2UIGFxScript;

var bool isPrologueGrowTypeState;

function OnRegisterEvent()
{
    RegisterEvent(150);
    RegisterGFxEvent(5090);
    RegisterGFxEvent(5091);
    RegisterGFxEvent(3080);
    RegisterEvent(3410);
    RegisterEvent(5312);
    return;
}

function OnLoad()
{
    SetContainerWindow("SimpleNoBgNoDrag", 0);
    AddState("ARENAGAMINGSTATE");
    AddState("ARENABATTLESTATE");
    AddState("GAMINGSTATE");
    AddState("ARENAOBSERVERSTATE");
    SetHavingFocus(false);
    return;
}

function onMenuClick(string MenuName)
{
    switch(MenuName)
    {
        // End:0x25
        case "Attend":
            RequestBypassToServer("attendui");
            // End:0x49
            break;
        // End:0x38
        case "nShop":
            clickNShopMenu();
            // End:0x49
            break;
        // End:0xFFFF
        default:
            showHide(MenuName);
            // End:0x49
            break;
            break;
    }
    return;
}

function clickNShopMenu()
{
    NoticeWnd(GetScript("NoticeWnd")).showHideL2InGameWeb("nshop", "");
    return;
}

function showHide(string MenuName)
{
    // End:0x2E
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(MenuName))
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(MenuName);        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(MenuName);
    }
    return;
}

function SetLISTSUBDATA()
{
    local UIEventManager.ELanguageType Language;
    local bool isClassic, isKorean, isArena;

    isArena = getInstanceUIData().getIsArenaServer();
    isClassic = getInstanceUIData().getIsClassicServer();
    Language = GetLanguage();
    isKorean = int(Language) == 0;
    setLIST(2469, "Productinven", "", (!GetINIBool2Bool("PrimeShop", "UseGoodsInventory") || isArena) || isPrologueGrowTypeState);
    setLIST(498, "Shop", "", isArena || isPrologueGrowTypeState);
    inputDivision();
    setLIST(5190, "Attend", "AttendCheckWnd", false);
    setLIST(2074, "Post", "PostWnd", isArena || isPrologueGrowTypeState);
    setLIST(3068, "ClanSearch", "", isArena || isPrologueGrowTypeState);
    setLIST(4528, "ArenaRanking", "ArenaRankingWnd", !isArena || isPrologueGrowTypeState);
    setLIST(389, "PartyMatch", "PartyMatchWnd", isArena || isPrologueGrowTypeState);
    setLIST(2383, "PersonalConnection", "PersonalConnectionsWnd", isPrologueGrowTypeState);
    setLIST(3136, "Qna", "", (isClassic || !isKorean) || isArena);
    setLIST(387, "Bbs", "BoardWnd", isArena);
    inputDivision();
    setLIST(2642, "Add");
    inputDivision();
    setLIST(2643, "Service");
    setLIST(3471, "IngameWeb", "IngameWebWnd", (isArena || !isKorean) || getInstanceUIData().getIsArenaServer());
    setLIST(3634, "NShop", "IngameWebWnd", (isArena || !isKorean) || isPrologueGrowTypeState);
    inputDivision();
    setLIST(1523, "ShortcutAssign");
    setLIST(711, "Macro", "MacroWnd", isArena);
    setLIST(146, "Option", "OptionWnd");
    inputDivision();
    setLIST(147, "Restart", "", GetGameStateName() == "ARENABATTLESTATE");
    setLIST(148, "Exit");
    return;
}

function setLISTUnderDATA()
{
    local bool isArena, isClassic, isKorean;
    local string parentName;
    local UIEventManager.ELanguageType Language;

    Language = GetLanguage();
    isKorean = int(Language) == 0;
    isArena = getInstanceUIData().getIsArenaServer();
    isClassic = getInstanceUIData().getIsClassicServer();
    parentName = "Shop";
    setLISTSUB(parentName, 2644, "ShopSell");
    setLISTSUB(parentName, 2645, "ShopBuy");
    setLISTSUB(parentName, 2646, "ShopSellAll");
    setLISTSUB(parentName, 1283, "ShopSearch");
    parentName = "Add";
    setLISTSUB(parentName, 2796, "InstancedZone", "", isArena);
    setLISTSUB(parentName, 1277, "PcRoom", "", (isArena || isClassic) || !GetINIBool2Bool("Localize", "UsePCBangPoint"));
    setLISTSUB(parentName, 2647, "ReplayRec");
    parentName = "Service";
    setLISTSUB(parentName, 145, "Help", "", isClassic || isArena);
    setLISTSUB(parentName, 470, "Petition", "", !isKorean || isArena);
    setLISTSUB(parentName, 3169, "IngameNotice", "", !isKorean && int(Language) != 2);
    setLISTSUB(parentName, 2257, "Homepage");
    setLISTSUB(parentName, 5178, "PathToAwakening", "", !GetINIBool2Bool("Localize", "UsePathToAwakening"));
    setLISTSUB(parentName, 3327, "PlayerAge", "", !isKorean);
    return;
}

function StartSubMenu()
{
    CallGFxFunction(getCurrentWindowName(string(self)), "evMenuSubStart", "");
    return;
}

function EndSubMenu()
{
    CallGFxFunction(getCurrentWindowName(string(self)), "evMenuSubEnd", "");
    return;
}

function inputDivision()
{
    CallGFxFunction(getCurrentWindowName(string(self)), "evMenuSubList", "");
    return;
}

function setLIST(int stringNum, string MenuName, optional string tooltipKey, optional bool notUse)
{
    setLISTSUB("", stringNum, MenuName, tooltipKey, notUse == true);
    return;
}

function setLISTSUB(string parentMenuName, int stringNum, string MenuName, optional string tooltipKey, optional bool notUse)
{
    local string strParam;

    // End:0x0B
    if(notUse)
    {
        return;
    }
    ParamAdd(strParam, "parentMenuName", parentMenuName);
    ParamAdd(strParam, "stringNumber", string(stringNum));
    ParamAdd(strParam, "menuName", MenuName);
    ParamAdd(strParam, "tooltipKey", tooltipKey);
    CallGFxFunction(getCurrentWindowName(string(self)), "evMenuSubList", strParam);
    return;
}

function int b2i(bool Value)
{
    // End:0x0E
    if(Value)
    {
        return 1;        
    }
    else
    {
        return 0;
    }
    return;
}

function bool i2b(int Value)
{
    // End:0x10
    if(Value == 0)
    {
        return false;        
    }
    else
    {
        return true;
    }
    return;
}

function bool GetINIBool2Bool(string Category, string ItemName)
{
    local int bValue;

    // End:0x24
    if(!GetINIBool(Category, ItemName, bValue, "L2.ini"))
    {
        return false;
    }
    return i2b(bValue);
    return;
}

function bool getUseVipAttendance()
{
    local string UseVIPAttendanceItemName;

    // End:0x35
    if(getInstanceUIData().getIsClassicServer())
    {
        UseVIPAttendanceItemName = "UseVIPAttendanceClassic";        
    }
    else
    {
        UseVIPAttendanceItemName = "UseVIPAttendanceLive";
    }
    return GetINIBool2Bool("Localize", UseVIPAttendanceItemName);
    return;
}

function handleChangedSubjob(string param)
{
    local bool tmpIsPrologueGrowTypeState;

    tmpIsPrologueGrowTypeState = getisPrologueGrowTypeState(param);
    // End:0x48
    if(tmpIsPrologueGrowTypeState != isPrologueGrowTypeState)
    {
        isPrologueGrowTypeState = tmpIsPrologueGrowTypeState;
        StartSubMenu();
        SetLISTSUBDATA();
        setLISTUnderDATA();
        EndSubMenu();
    }
    return;
}

function bool getisPrologueGrowTypeState(string param)
{
    local int currentClassID;

    // End:0x32
    if(param != "")
    {
        ParseInt(param, "CurrentSubjobClassID", currentClassID);
    }
    return getInstanceL2Util().getIsPrologueGrowType(currentClassID);
    return;
}

function OnShow()
{
    handleChangedSubjob("");
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x36
    if(Event_ID == 150)
    {
        isPrologueGrowTypeState = getisPrologueGrowTypeState("");
        StartSubMenu();
        SetLISTSUBDATA();
        setLISTUnderDATA();
        EndSubMenu();        
    }
    else
    {
        // End:0x53
        if(Event_ID == 5312)
        {
            handleChangedSubjob(param);            
        }
        else
        {
            // End:0x91
            if(Event_ID == 3410)
            {
                // End:0x79
                if(!getInstanceUIData().getIsArenaServer())
                {
                    return;
                }
                StartSubMenu();
                SetLISTSUBDATA();
                setLISTUnderDATA();
                EndSubMenu();
            }
        }
    }
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x25
        case "onMenuClick":
            onMenuClick(param);
            // End:0x2B
            break;
        // End:0xFFFF
        default:
            // End:0x2B
            break;
            break;
    }
    return;
}
