class MysteriousMansionResultWnd extends L2UIGFxScript;

var string userFakeName;

function OnRegisterEvent()
{
    RegisterGFxEvent(9370);
    RegisterGFxEvent(9380);
    RegisterGFxEvent(9381);
    RegisterGFxEvent(9382);
    RegisterGFxEvent(9341);
    return;
}

function OnLoad()
{
    RegisterState(getCurrentWindowName(string(self)), "GamingState");
    SetContainerWindow("SkinnedWindow", 2806);
    AddState("GAMINGSTATE");
    return;
}
