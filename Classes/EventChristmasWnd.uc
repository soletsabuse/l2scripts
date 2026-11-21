class EventChristmasWnd extends GFxUIScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9650);
    return;
}

function OnLoad()
{
    RegisterState("EventChristmasWnd", "GamingState");
    SetContainer("ContainerWindow");
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    return;
}
