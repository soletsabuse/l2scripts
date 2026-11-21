class ArenaRankingWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(8650);
    RegisterGFxEvent(8660);
    return;
}

function OnLoad()
{
    AddState("ARENAGAMINGSTATE");
    AddState("ARENABATTLESTATE");
    SetContainerWindow("SkinnedWindow", 4528);
    return;
}
