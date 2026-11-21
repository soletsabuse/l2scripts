class AnniveEvent extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9660);
    RegisterGFxEvent(9670);
    RegisterGFxEvent(9680);
    RegisterGFxEvent(6000);
    return;
}

function OnLoad()
{
    SetContainerWindow("SkinnedWindow", 3208);
    AddState("GAMINGSTATE");
    SetAnchor("", 5, 5, 0, 0);
    return;
}
