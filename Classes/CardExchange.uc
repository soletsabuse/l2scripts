class CardExchange extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9660);
    RegisterGFxEvent(9670);
    RegisterGFxEvent(9680);
    return;
}

function OnLoad()
{
    RegisterState("CardExchange", "GamingState");
    SetContainerWindow("SkinnedWindow", 0);
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    return;
}
