class PVPCounterTrigger extends UIScript;

var WindowHandle Me;
var ButtonHandle Btn_PVPWnd;
var WindowHandle PVPDetailedWnd;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    InitializeCOD();
    Me.HideWindow();
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("PVPCounterTrigger");
    Btn_PVPWnd = GetButtonHandle("PVPCounterTrigger.Btn_PVPWnd");
    PVPDetailedWnd = GetWindowHandle("PVPDetailedWnd");
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 3370:
            HandlePVPMatchRecord(a_Param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandlePVPMatchRecord(string param)
{
    local int CurrentState;

    ParseInt(param, "CurrentState", CurrentState);
    switch(CurrentState)
    {
        // End:0x3B
        case 0:
            Me.ShowWindow();
            // End:0x55
            break;
        // End:0x52
        case 2:
            Me.HideWindow();
            // End:0x55
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x2E
        case "Btn_PVPWnd":
            PVPDetailedWnd.ShowWindow();
            RequestPVPMatchRecord();
            // End:0x31
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
