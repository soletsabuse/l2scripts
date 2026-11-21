class OlympiadResultWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(5081);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    RegisterState("OlympiadResultWnd", "GamingState");
    SetContainerWindow("SkinnedWindow", 0);
    return;
}
