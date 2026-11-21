class BirthdayAlarmWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle BirthDayItem;
var TextBoxHandle itemAlarmTxt;
var ButtonHandle btnOk;

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

function OnShow()
{
    return;
}

function Initialize()
{
    Me = GetHandle("BirthdayAlarmWnd");
    BirthDayItem = TextureHandle(GetHandle("BirthDayItem"));
    itemAlarmTxt = TextBoxHandle(GetHandle("itemAlarmTxt"));
    btnOk = ButtonHandle(GetHandle("btnOK"));
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("BirthdayAlarmWnd");
    BirthDayItem = GetTextureHandle("BirthdayAlarmWnd.BirthDayItem");
    itemAlarmTxt = GetTextBoxHandle("BirthdayAlarmWnd.itemAlarmTxt");
    btnOk = GetButtonHandle("BirthdayAlarmWnd.btnOK");
    return;
}

function load()
{
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x12
        case 3890:
            // End:0x15
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
        // End:0x23
        case "btnOK":
            Me.HideWindow();
            // End:0x26
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnExitState(name a_NextStateName)
{
    Me.HideWindow();
    return;
}
