class FactionWnd extends L2UIGFxScript;

const TYPE_FACTION_START_NPC = 2;

function OnRegisterEvent()
{
    RegisterGFxEvent(10080);
    RegisterGFxEvent(10170);
    return;
}

function OnLoad()
{
    AddState("GAMINGSTATE");
    SetContainerWindow("SkinnedWindow", 3443);
    return;
}

function OnHide()
{
    eraseStartNpcRegioninfo();
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x26
        case "showStartNPC":
            showStartNpc(param);
            // End:0x43
            break;
        // End:0x40
        case "hideStartNPC":
            eraseStartNpcRegioninfo();
            // End:0x43
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function showStartNpc(string param)
{
    local Vector XYZ;
    local int X, Y, Z;
    local string NpcName;
    local MinimapCtrlHandle m_MiniMap;
    local MinimapWnd mapScript;
    local MinimapRegionInfo regionInfoForMapIcon;

    mapScript = MinimapWnd(GetScript("MinimapWnd"));
    m_MiniMap = GetMinimapCtrlHandle("MinimapWnd.Minimap");
    // End:0x7A
    if(!GetWindowHandle("MinimapWnd").IsShowWindow())
    {
        GetWindowHandle("MinimapWnd").ShowWindow();
    }
    ParseString(param, "npcName", NpcName);
    ParseInt(param, "StartNpcX", X);
    ParseInt(param, "StartNpcY", Y);
    ParseInt(param, "StartNpcZ", Z);
    XYZ.X = float(X);
    XYZ.Y = float(Y);
    XYZ.Z = float(Z);
    mapScript.SetContinent(m_MiniMap.GetContinent(XYZ));
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", XYZ, false);
    m_MiniMap.SetShowRegionInfoByType(8, true);
    regionInfoForMapIcon = makeRegionInfo(NpcName, XYZ);
    m_MiniMap.EraseRegionInfoCtrl(8, 2);
    m_MiniMap.AddRegionInfoCtrl(regionInfoForMapIcon);
    return;
}

function eraseStartNpcRegioninfo()
{
    local MinimapCtrlHandle m_MiniMap;

    m_MiniMap = GetMinimapCtrlHandle("MinimapWnd.Minimap");
    m_MiniMap.EraseRegionInfoCtrl(8, 2);
    return;
}

function MinimapRegionInfo makeRegionInfo(string TooltipString, Vector pLoc)
{
    local MinimapRegionInfo regionInfoForMapIcon;
    local MinimapRegionIconData IconData;
    local string toolTipParam;

    toolTipParam = "";
    ParamAdd(toolTipParam, "tooltipString", TooltipString);
    ParamAdd(toolTipParam, "Type", string(int(8)));
    regionInfoForMapIcon.strTooltip = toolTipParam;
    regionInfoForMapIcon.eType = 8;
    regionInfoForMapIcon.nIndex = 2;
    IconData.nWidth = 32;
    IconData.nHeight = 32;
    IconData.nWorldLocX = int(pLoc.X);
    IconData.nWorldLocY = int(pLoc.Y);
    IconData.nWorldLocZ = int(pLoc.Z);
    IconData.nIconOffsetX = -3;
    IconData.nIconOffsetY = -20;
    IconData.strIconNormal = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign_Over";
    IconData.strIconOver = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign";
    IconData.strIconPushed = "L2UI_CT1.Minimap.Minimap_DF_Icon_Pin_Campaign_Over";
    regionInfoForMapIcon.IconData = IconData;
    return regionInfoForMapIcon;
    return;
}
