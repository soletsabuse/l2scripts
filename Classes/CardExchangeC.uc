class CardExchangeC extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9660);
    RegisterGFxEvent(9670);
    RegisterGFxEvent(9680);
    return;
}

function OnLoad()
{
    AddState("GAMINGSTATE");
    SetContainerWindow("SkinnedWindow", 3129);
    return;
}
