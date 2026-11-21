class L2UIToolTip extends GFxUIScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(2900);
    return;
}

function OnLoad()
{
    RegisterState("L2UIToolTip", "LoginState");
    RegisterState("L2UIToolTip", "GamingState");
    RegisterState("L2UIToolTip", "CHARACTERCREATESTATE");
    RegisterState("L2UIToolTip", "CHARACTERSELECTSTATE");
    RegisterState("L2UIToolTip", "ARENAGAMINGSTATE");
    RegisterState("L2UIToolTip", "ARENABATTLESTATE");
    SetHavingFocus(false);
    SetDefaultShow(true);
    return;
}

function OnFlashLoaded()
{
    SetRenderOnTop(true);
    SetAlwaysFullAlpha(true);
    IgnoreUIEvent(true);
    return;
}
