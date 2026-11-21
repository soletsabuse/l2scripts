class ArenaDualManager extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(2710);
    RegisterGFxEvent(2720);
    RegisterGFxEvent(2730);
    RegisterGFxEvent(2740);
    RegisterGFxEvent(2750);
    RegisterGFxEvent(8520);
    RegisterGFxEvent(8400);
    RegisterGFxEvent(8370);
    RegisterGFxEvent(980);
    return;
}

function OnLoad()
{
    AddState("ARENABATTLESTATE");
    AddState("ARENAOBSERVERSTATE");
    SetDefaultShow(true);
    SetContainerHUD("none", 0);
    SetHavingFocus(false);
    return;
}

function OnFlashLoaded()
{
    IgnoreUIEvent(true);
    SetAnchor("", 6, 3, -26, -160);
    return;
}
