class WorldChatBox extends L2UIGFxScript;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    RegisterState("WorldChatBox", "GamingState");
    SetContainerHUD("none", 0);
    AddState("GAMINGSTATE");
    AddState("ARENABATTLESTATE");
    AddState("ARENAGAMINGSTATE");
    SetHavingFocus(false);
    SetAnchor("", 9, 1, 0, 0);
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    return;
}
