class ClanRaidsWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(10410);
    RegisterGFxEvent(10400);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    SetContainerWindow("SkinnedWindow", 3646);
    AddState("GAMINGSTATE");
    return;
}
