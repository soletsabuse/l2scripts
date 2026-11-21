class ArenaScoreBoardHUD extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(8500);
    RegisterGFxEvent(8520);
    RegisterGFxEvent(190);
    RegisterGFxEvent(2610);
    RegisterEvent(3410);
    return;
}

function OnLoad()
{
    AddState("ARENABATTLESTATE");
    AddState("ARENAGAMINGSTATE");
    AddState("ARENAOBSERVERSTATE");
    SetContainerHUD("none", 0);
    SetHavingFocus(false);
    return;
}

function OnFlashLoaded()
{
    IgnoreUIEvent(true);
    SetAnchor("", 2, 2, 0, 0);
    return;
}

function OnEvent(int Id, string param)
{
    switch(Id)
    {
        // End:0x6F
        case 3410:
            // End:0x5D
            if((param == "ARENABATTLESTATE") || param == "ARENAOBSERVERSTATE")
            {
                ShowWindow(getCurrentWindowName(string(self)));                
            }
            else
            {
                HideWindow(getCurrentWindowName(string(self)));
            }
            // End:0x72
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
