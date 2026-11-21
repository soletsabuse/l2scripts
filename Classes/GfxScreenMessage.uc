class GfxScreenMessage extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(542);
    return;
}

function OnLoad()
{
    RegisterState(getCurrentWindowName(string(self)), "GAMINGSTATE");
    RegisterState(getCurrentWindowName(string(self)), "ARENAPICKSTATE");
    RegisterState(getCurrentWindowName(string(self)), "ARENAGAMINGSTATE");
    RegisterState(getCurrentWindowName(string(self)), "ARENABATTLESTATE");
    SetDefaultShow(true);
    SetHavingFocus(false);
    return;
}

function OnFlashLoaded()
{
    SetAnchor("", 9, 1, 0, 0);
    SetRenderOnTop(true);
    SetAlwaysFullAlpha(true);
    IgnoreUIEvent(true);
    return;
}
