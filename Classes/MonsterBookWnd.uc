class MonsterBookWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(10150);
    RegisterGFxEvent(10151);
    RegisterGFxEvent(10152);
    RegisterGFxEvent(10161);
    RegisterGFxEvent(10162);
    RegisterGFxEventForLoaded(40);
    RegisterGFxEventForLoaded(10080);
    return;
}

function OnLoad()
{
    AddState("GAMINGSTATE");
    SetContainerWindow("SkinnedWindow", 3511);
    return;
}
