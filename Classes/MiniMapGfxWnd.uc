class MiniMapGfxWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    AddState("GAMINGSTATE");
    SetContainerWindow("SkinnedWindow", 447);
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
