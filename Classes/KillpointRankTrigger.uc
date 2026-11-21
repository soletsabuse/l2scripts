class KillpointRankTrigger extends UIScript;

var WindowHandle Me;
var WindowHandle KillPointRankWnd;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    // End:0x4A
    if(1 == 0)
    {
        Me = GetHandle("KillPointRankTrigger");
        KillPointRankWnd = GetHandle("KillPointRankWnd");        
    }
    else
    {
        Me = GetWindowHandle("KillPointRankTrigger");
        KillPointRankWnd = GetWindowHandle("KillPointRankWnd");
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int statusInt;

    switch(Event_ID)
    {
        // End:0x21
        case 3500:
            Me.ShowWindow();
            // End:0x98
            break;
        // End:0x7B
        case 3470:
            ParseInt(param, "Status", statusInt);
            switch(statusInt)
            {
                // End:0x5E
                case 0:
                    Me.ShowWindow();
                    // End:0x78
                    break;
                // End:0x75
                case 2:
                    Me.HideWindow();
                    // End:0x78
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x98
            break;
        // End:0x95
        case 3501:
            Me.HideWindow();
            // End:0x98
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    // End:0x35
    if(Name == "KillPointRankTrigger")
    {
        KillPointRankWnd.ShowWindow();
        RequestStartShowCrataeCubeRank();
    }
    return;
}
