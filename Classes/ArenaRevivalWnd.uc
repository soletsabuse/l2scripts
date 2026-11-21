class ArenaRevivalWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(50);
    RegisterGFxEvent(540);
    RegisterGFxEvent(40);
    RegisterEvent(40);
    RegisterEvent(1430);
    RegisterEvent(1440);
    RegisterGFxEvent(3410);
    return;
}

function OnLoad()
{
    AddState("ARENAGAMINGSTATE");
    AddState("ARENABATTLESTATE");
    AddState("ARENAPICKSTATE");
    SetContainerWindow("none", 0);
    SetHavingFocus(false);
    return;
}

function OnFlashLoaded()
{
    SetRenderOnTop(true);
    SetAlwaysFullAlpha(true);
    SetAnchor("", 5, 5, 0, -50);
    return;
}

function OnEvent(int Id, string param)
{
    switch(Id)
    {
        // End:0x18
        case 1430:
            ShowWindow();
            // End:0x31
            break;
        // End:0x20
        case 1440:
        // End:0x2E
        case 40:
            HideWindow();
            // End:0x31
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
