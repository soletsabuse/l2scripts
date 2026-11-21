class AnniveEventLauncher extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9681);
    return;
}

function OnLoad()
{
    RegisterState("AnniveEventLauncher", "GamingState");
    SetContainerHUD("SimpleNoBgNoDrag", 0);
    AddState("GAMINGSTATE");
    NotUseESC();
    SetHUD();
    SetHavingFocus(false);
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    return;
}
