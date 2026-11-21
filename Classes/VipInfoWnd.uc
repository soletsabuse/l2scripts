class VipInfoWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(20150);
    RegisterGFxEvent(20151);
    return;
}

function OnLoad()
{
    AddState("GAMINGSTATE");
    SetContainerWindow("SkinnedWindow", 5819);
    return;
}
