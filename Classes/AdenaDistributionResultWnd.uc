class AdenaDistributionResultWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9710);
    return;
}

function OnLoad()
{
    RegisterState("AdenaDistributionResultWnd", "GamingState");
    SetContainerWindow("SkinnedWindow", 0);
    SetAnchor("", 5, 5, 0, 0);
    return;
}
