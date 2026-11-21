class DepthOfField extends UICommonAPI;

function OnRegisterEvent()
{
    RegisterEvent(3410);
    RegisterEvent(50000);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    return;
}

function HandleStateChanged(string a_NewState)
{
    switch(a_NewState)
    {
        // End:0x16
        case "LOGINSTATE":
        // End:0x29
        case "LOGINWAITSTATE":
        // End:0x3A
        case "EULAMSGSTATE":
        // End:0x50
        case "CHINAWARNMSGSTATE":
        // End:0x64
        case "SERVERLISTSTATE":
        // End:0x7A
        case "REPLAYSELECTSTATE":
        // End:0xDE
        case "CARDKEYLOGINSTATE":
            Class'NWindow.GraphicAPI'.static.DoFResume();
            Class'NWindow.GraphicAPI'.static.DoFSetFocusDistance(300.0000000);
            Class'NWindow.GraphicAPI'.static.DoFSetStartDistance(300.0000000);
            Class'NWindow.GraphicAPI'.static.DoFSetEndDistance(9000.0000000);
            // End:0x20F
            break;
        // End:0x145
        case "CHARACTERSELECTSTATE":
            Class'NWindow.GraphicAPI'.static.DoFResume();
            Class'NWindow.GraphicAPI'.static.DoFSetFocusDistance(300.0000000);
            Class'NWindow.GraphicAPI'.static.DoFSetStartDistance(300.0000000);
            Class'NWindow.GraphicAPI'.static.DoFSetEndDistance(5000.0000000);
            // End:0x20F
            break;
        // End:0x168
        case "LOADINGSTATE":
            Class'NWindow.GraphicAPI'.static.DoFPause();
            // End:0x20F
            break;
        // End:0x1C1
        case "GAMINGSTATE":
            Class'NWindow.GraphicAPI'.static.DoFResume();
            Class'NWindow.GraphicAPI'.static.DoFSetFocusPlayer();
            Class'NWindow.GraphicAPI'.static.DoFSetStartDistance(300.0000000);
            Class'NWindow.GraphicAPI'.static.DoFSetEndDistance(9000.0000000);
            // End:0x20F
            break;
        // End:0xFFFF
        default:
            Class'NWindow.GraphicAPI'.static.DoFResume();
            Class'NWindow.GraphicAPI'.static.DoFSetFocusDistance(300.0000000);
            Class'NWindow.GraphicAPI'.static.DoFSetStartDistance(300.0000000);
            Class'NWindow.GraphicAPI'.static.DoFSetEndDistance(2000.0000000);
            break;
    }
    return;
}

function HandleCharacterSelectionChanged(string a_Param)
{
    local int charIndex;

    // End:0x90
    if(ParseInt(a_Param, "CharIndex", charIndex))
    {
        // End:0x90
        if((GetUIState()) == "CHARACTERCREATESTATE")
        {
            Class'NWindow.GraphicAPI'.static.DoFResume();
            Class'NWindow.GraphicAPI'.static.DoFSetFocusActor(GetCharacterSelectionActor(charIndex));
            Class'NWindow.GraphicAPI'.static.DoFSetStartDistance(300.0000000);
            Class'NWindow.GraphicAPI'.static.DoFSetEndDistance(3000.0000000);
        }
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 3410:
            HandleStateChanged(a_Param);
            // End:0x36
            break;
        // End:0x33
        case 50000:
            HandleCharacterSelectionChanged(a_Param);
            // End:0x36
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
