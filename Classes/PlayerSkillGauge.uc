class PlayerSkillGauge extends L2UIGFxScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = -220;

function OnRegisterEvent()
{
    RegisterGFxEvent(5330);
    RegisterGFxEvent(5340);
    return;
}

function OnLoad()
{
    local int addShortcutExpandLocY;

    SetContainerHUD("none", 0);
    AddState("GAMINGSTATE");
    AddState("ARENAPICKSTATE");
    AddState("ARENAGAMINGSTATE");
    AddState("ARENABATTLESTATE");
    addShortcutExpandLocY = -60;
    SetAnchor("", 8, 8, 0, -220 + addShortcutExpandLocY);
    SetDefaultShow(true);
    SetHavingFocus(false);
    return;
}
