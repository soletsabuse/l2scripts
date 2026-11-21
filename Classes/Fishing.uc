class Fishing extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(2490);
    RegisterGFxEvent(2471);
    RegisterGFxEvent(2481);
    RegisterGFxEvent(10);
    return;
}

function OnLoad()
{
    RegisterState("Fishing", "GamingState");
    SetContainerHUD("none", 0);
    AddState("GAMINGSTATE");
    SetHavingFocus(false);
    SetAnchor("", 9, 1, 0, 0);
    return;
}

function OnShow()
{
    return;
}

function OnFlashLoaded()
{
    return;
}

function OnHide()
{
    return;
}

function OnCallUCLogic(int logicID, string param)
{
    // End:0x17
    if(logicID == 1)
    {
        SetNextFocus();
        HideWindow();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    return;
}
