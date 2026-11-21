class AlchemySkillCollectionWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    RegisterState("AlchemySkillCollectionWnd", "GamingState");
    SetContainerWindow("SkinnedWindow", 3298);
    AddState("GAMINGSTATE");
    return;
}

function OnShow()
{
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    return;
}
