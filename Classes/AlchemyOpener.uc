class AlchemyOpener extends L2UIGFxScript;

function OnLoad()
{
    RegisterState("AlchemyOpener", "GamingState");
    SetContainerWindow("SkinnedWindow", 3257);
    AddState("GAMINGSTATE");
    SetAnchor("", 5, 5, 0, 0);
    return;
}
