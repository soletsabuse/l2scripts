class ExpBar extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(180);
    RegisterGFxEvent(40);
    RegisterGFxEvent(9550);
    RegisterGFxEvent(9560);
    RegisterGFxEvent(9570);
    RegisterGFxEvent(2070);
    RegisterGFxEvent(320);
    RegisterGFxEvent(10450);
    RegisterGFxEvent(420);
    RegisterGFxEvent(10470);
    RegisterGFxEvent(8000);
    RegisterGFxEvent(9720);
    return;
}

function OnLoad()
{
    AddState("GAMINGSTATE");
    AddState("ARENAGAMINGSTATE");
    AddState("ARENABATTLESTATE");
    AddState("ARENAPICKSTATE");
    SetContainerHUD("none", 0);
    SetDefaultShow(true);
    SetHavingFocus(false);
    SetHUD();
    return;
}
