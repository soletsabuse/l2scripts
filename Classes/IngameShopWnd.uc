class IngameShopWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(20140);
    RegisterGFxEvent(20141);
    RegisterGFxEvent(20142);
    RegisterGFxEvent(20150);
    RegisterGFxEvent(9015);
    RegisterGFxEvent(9060);
    RegisterGFxEvent(20143);
    RegisterGFxEvent(9050);
    RegisterGFxEventForLoaded(2610);
    return;
}

function OnLoad()
{
    AddState("GAMINGSTATE");
    SetContainerWindow("SkinnedWindow", 5001);
    return;
}
