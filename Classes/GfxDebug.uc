class GfxDebug extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9990);
    RegisterGFxEvent(9991);
    RegisterGFxEvent(9992);
    RegisterGFxEvent(9993);
    RegisterGFxEvent(18);
    return;
}

function OnLoad()
{
    SetContainerWindow("SkinnedWindow", 3365);
    AddState("GAMINGSTATE");
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x36
        case "ucExecuteCommand":
            // End:0x33
            if(param != "")
            {
                ExecuteCommand(param);
            }
            // End:0x39
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
