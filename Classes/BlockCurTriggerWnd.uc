class BlockCurTriggerWnd extends UIScript;

var WindowHandle Me;
var ButtonHandle BlockCurTriggerBtn;
var WindowHandle BlockCurWnd;

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
    Me = GetHandle("BlockCurTriggerWnd");
    BlockCurTriggerBtn = ButtonHandle(GetHandle("BlockCurTriggerBtn"));
    BlockCurWnd = GetHandle("BlockCurWnd");
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("BlockCurTriggerWnd");
    BlockCurTriggerBtn = GetButtonHandle("BlockCurTriggerWnd.BlockTriggerBtn");
    BlockCurWnd = GetWindowHandle("BlockCurWnd");
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x21
        case 3890:
            Me.ShowWindow();
            // End:0x3E
            break;
        // End:0x3B
        case 3900:
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
        case "BlockCurTriggerBtn":
            BlockCurWnd.ShowWindow();
            // End:0x33
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
