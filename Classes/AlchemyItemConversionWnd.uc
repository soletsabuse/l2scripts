class AlchemyItemConversionWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9900);
    RegisterGFxEvent(9870);
    RegisterGFxEvent(9890);
    RegisterGFxEvent(2610);
    RegisterGFxEvent(2057);
    return;
}

function OnLoad()
{
    SetContainerWindow("SkinnedWindow", 3266);
    AddState("GAMINGSTATE");
    return;
}

function OnShow()
{
    local L2Util util;

    util = L2Util(GetScript("L2Util"));
    util.ItemRelationWindowHide("AlchemyItemConversionWnd");
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    return;
}
