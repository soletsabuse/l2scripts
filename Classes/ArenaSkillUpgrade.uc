class ArenaSkillUpgrade extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(1280);
    RegisterGFxEvent(1290);
    RegisterGFxEvent(1291);
    RegisterGFxEvent(2064);
    RegisterGFxEvent(2065);
    RegisterGFxEvent(4600);
    RegisterEvent(40);
    return;
}

function OnEvent(int Id, string param)
{
    switch(Id)
    {
        // End:0x15
        case 40:
            HideWindow();
            // End:0x18
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnLoad()
{
    AddState("ARENABATTLESTATE");
    AddState("ARENAGAMINGSTATE");
    SetContainerHUD("none", 0);
    SetHavingFocus(false);
    return;
}

function OnFlashLoaded()
{
    SetAnchor("", 8, 8, 23, -130);
    return;
}
