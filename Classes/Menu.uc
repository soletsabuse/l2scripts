class Menu extends L2UIGFxScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = -20;

function OnRegisterEvent()
{
    RegisterGFxEvent(5090);
    RegisterGFxEvent(5091);
    RegisterEvent(150);
    return;
}

function OnLoad()
{
    SetContainerHUD("none", 0);
    AddState("GAMINGSTATE");
    AddState("ARENAGAMINGSTATE");
    AddState("ARENABATTLESTATE");
    AddState("ARENAOBSERVERSTATE");
    SetDefaultShow(true);
    SetAlwaysFullAlpha(true);
    SetHavingFocus(false);
    return;
}

function onMenuClick(string MenuName)
{
    switch(MenuName)
    {
        // End:0xFFFF
        default:
            // End:0x0D
            break;
            break;
    }
    return;
}

function setLISTDATA()
{
    // End:0x92
    if(getInstanceUIData().getIsArenaServer())
    {
        setLIST(0, 1, "Inven", "InventoryWnd");
        setLIST(0, 127, "Action", "ActionWnd");
        setLIST(0, 119, "Skill", "MagicskillWnd");
        setLIST(0, 2641, "MenuAll", "SystemMenuWnd");        
    }
    else
    {
        setLIST(0, 434, "Char", "DetailStatusWnd");
        setLIST(0, 1, "Inven", "InventoryWnd");
        setLIST(0, 127, "Action", "ActionWnd");
        setLIST(0, 119, "Skill", "MagicskillWnd");
        setLIST(1, 198, "Quest", "QuestTreeWnd");
        setLIST(1, 314, "Clan", "ClanWnd");
        setLIST(1, 447, "Map", "MinimapWnd");
        setLIST(1, 2641, "MenuAll", "SystemMenuWnd");
    }
    return;
}

function StartMenu()
{
    CallGFxFunction(getCurrentWindowName(string(self)), "evMenuStart", "");
    return;
}

function EndMenu()
{
    CallGFxFunction(getCurrentWindowName(string(self)), "evMenuEnd", "");
    return;
}

function setLIST(int lineNum, int stringNum, string MenuName, string tooltipKey)
{
    local string strParam;

    ParamAdd(strParam, "lineNum", string(lineNum));
    ParamAdd(strParam, "stringNumber", string(stringNum));
    ParamAdd(strParam, "menuName", MenuName);
    ParamAdd(strParam, "tooltipKey", tooltipKey);
    CallGFxFunction(getCurrentWindowName(string(self)), "evMenuList", strParam);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1E
    if(Event_ID == 150)
    {
        StartMenu();
        setLISTDATA();
        EndMenu();
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
