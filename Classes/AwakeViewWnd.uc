class AwakeViewWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(5480);
    return;
}

function OnLoad()
{
    RegisterState(getCurrentWindowName(string(self)), "GamingState");
    SetContainerWindow("SkinnedWindow", 2491);
    AddState("GAMINGSTATE");
    return;
}

function OnCallUCFunction(string funcName, string param)
{
    // End:0x17
    if(funcName == "1")
    {
        RequestChangeToAwakenedClass(1);        
    }
    else
    {
        RequestChangeToAwakenedClass(0);
    }
    return;
}
