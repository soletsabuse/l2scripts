class AbilityWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9720);
    RegisterGFxEvent(9721);
    RegisterGFxEvent(180);
    RegisterGFxEvent(9730);
    RegisterGFxEvent(9731);
    RegisterGFxEvent(40);
    return;
}

function OnLoad()
{
    RegisterState("AbilityWnd", "GamingState");
    SetContainerWindow("SkinnedWindow", 3151);
    AddState("GAMINGSTATE");
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    local string strParam;

    switch(functionName)
    {
        // End:0x6D
        case "OpenHelpHTML":
            ParamAdd(strParam, "HtmlFile", "..\\L2text\\" $ param);
            ParamAdd(strParam, "ViewerType", "2");
            ExecuteEvent(2431, strParam);
            // End:0x70
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
