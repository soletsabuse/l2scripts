class BirthdayAlarmBtn extends UICommonAPI;

var WindowHandle Me;
var WindowHandle BirthdayAlarmWnd;
var ButtonHandle btnItemPop;

function OnRegisterEvent()
{
    RegisterEvent(3560);
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
    return;
}

function Initialize()
{
    Me = GetHandle("BirthdayAlarmBtn");
    BirthdayAlarmWnd = GetHandle("BirthdayAlarmWnd");
    btnItemPop = ButtonHandle(GetHandle("BirthdayAlarmBtn.btnItemPop"));
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("BirthdayAlarmBtn");
    BirthdayAlarmWnd = GetWindowHandle("BirthdayAlarmWnd");
    btnItemPop = GetButtonHandle("BirthdayAlarmBtn.btnItemPop");
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x5D
        case "btnItemPop":
            // End:0x39
            if(!BirthdayAlarmWnd.IsShowWindow())
            {
                BirthdayAlarmWnd.ShowWindow();
            }
            Me.HideWindow();
            Me.SetWindowSize(0, 32);
            // End:0x60
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    switch(Event_ID)
    {
        // End:0x79
        case 3560:
            Me.SetWindowSize(32, 32);
            ShowWindowWithFocus("BirthdayAlarmBtn");
            btnItemPop.ShowWindow();
            Class'NWindow.UIAPI_EFFECTBUTTON'.static.BeginEffect("BirthdayAlarmBtn.btnItemPop", 0);
            // End:0x7C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnExitState(name a_NextStateName)
{
    Me.SetWindowSize(0, 32);
    Me.HideWindow();
    return;
}
