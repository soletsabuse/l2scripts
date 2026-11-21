class MultiTimer extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(3550);
    RegisterGFxEvent(10200);
    RegisterGFxEvent(10210);
    RegisterGFxEvent(40);
    return;
}

function OnLoad()
{
    RegisterState("MultiTimer", "GamingState");
    SetContainerHUD("none", 0);
    AddState("GAMINGSTATE");
    SetDefaultShow(true);
    SetHavingFocus(false);
    return;
}
