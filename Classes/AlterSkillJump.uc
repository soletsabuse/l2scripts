class AlterSkillJump extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9231);
    return;
}

function OnLoad()
{
    SetAnchor("", 5, 5, 116, -3);
    AddState("GAMINGSTATE");
    AddState("ARENABATTLESTATE");
    AddState("ARENAGAMINGSTATE");
    SetContainerHUD("none", 0);
    SetAlwaysFullAlpha(true);
    SetHavingFocus(false);
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x1C
        case "flyMove":
            RequestFlyMoveStart();
            // End:0x1F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function bool bFlag(int nflag)
{
    // End:0x10
    if(nflag > 0)
    {
        return true;        
    }
    else
    {
        return false;
    }
    return;
}
