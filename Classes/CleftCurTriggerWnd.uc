class CleftCurTriggerWnd extends UIScript;

var WindowHandle Me;
var ButtonHandle CleftCurTriggerBtn;
var WindowHandle CleftCurWnd;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x1D
    if(1 == 0)
    {
        Initialize();        
    }
    else
    {
        InitializeCOD();
    }
    Me.HideWindow();
    return;
}

function Initialize()
{
    Me = GetHandle("CleftCurTriggerWnd");
    CleftCurTriggerBtn = ButtonHandle(GetHandle("CleftCurTriggerWnd.CleftCurTriggerBtn"));
    CleftCurWnd = GetHandle("CleftCurWnd");
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("CleftCurTriggerWnd");
    CleftCurTriggerBtn = GetButtonHandle("CleftCurTriggerWnd.CleftCurTriggerBtn");
    CleftCurWnd = GetWindowHandle("CleftCurWnd");
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x21
        case 3740:
            Me.ShowWindow();
            // End:0x3E
            break;
        // End:0x3B
        case 3750:
            Me.ShowWindow();
            // End:0x3E
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
        // End:0x30
        case "CleftCurTriggerBtn":
            CleftCurWnd.ShowWindow();
            // End:0x33
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
