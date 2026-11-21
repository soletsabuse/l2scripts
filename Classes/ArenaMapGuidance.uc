class ArenaMapGuidance extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(8500);
    RegisterGFxEvent(4560);
    RegisterGFxEvent(4570);
    RegisterEvent(3410);
    return;
}

function OnLoad()
{
    AddState("ARENAGAMINGSTATE");
    AddState("ARENABATTLESTATE");
    AddState("SPECIALCAMERASTATE");
    SetContainerWindow("none", 0);
    SetHUD();
    SetHavingFocus(false);
    return;
}

function OnFlashLoaded()
{
    IgnoreUIEvent(true);
    return;
}

function OnEvent(int EventID, string param)
{
    switch(EventID)
    {
        // End:0x34
        case 3410:
            // End:0x31
            if(param == "ARENAGAMINGSTATE")
            {
                HideWindow();
            }
            // End:0x37
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
