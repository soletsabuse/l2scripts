class ArenaScoreBoardWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(2740);
    RegisterGFxEvent(1140);
    RegisterGFxEvent(1160);
    RegisterGFxEvent(1150);
    RegisterGFxEvent(1170);
    RegisterGFxEvent(180);
    RegisterGFxEvent(8510);
    RegisterGFxEvent(8500);
    RegisterGFxEvent(8520);
    RegisterGFxEvent(8400);
    RegisterGFxEvent(8401);
    RegisterGFxEvent(8402);
    RegisterGFxEvent(8370);
    RegisterGFxEvent(8430);
    return;
}

function OnLoad()
{
    AddState("ARENABATTLESTATE");
    AddState("ARENAGAMINGSTATE");
    AddState("ARENAOBSERVERSTATE");
    SetContainerWindow("none", 0);
    SetHavingFocus(false);
    return;
}

function OnFlashLoaded()
{
    SetRenderOnTop(true);
    SetAlwaysFullAlpha(true);
    SetAnchor("", 5, 5, 0, 0);
    return;
}

function OnEvent(int Id, string param)
{
    switch(Id)
    {
        // End:0x52
        case 3410:
            // End:0x4F
            if((param == "ARENAGAMINGSTATE") || param == "ARENABATTLESTATE")
            {
                HideWindow();
            }
            // End:0x55
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
