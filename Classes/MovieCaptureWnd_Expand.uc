class MovieCaptureWnd_Expand extends UICommonAPI;

const TIMER_ID_COUNTUP = 7069;
const TIMER_DELAY = 1000;

var WindowHandle Me;
var ButtonHandle cBtn;
var WindowHandle m_wnd;
var TextBoxHandle Timer;
var int secInt;

function OnLoad()
{
    // End:0x0A
    if(1 == 0)
    {        
    }
    else
    {
        Timer = TextBoxHandle(GetHandle("MovieCapturewnd_Expand.timer"));
    }
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("MovieCaptureWnd_Expand");
    m_wnd = GetWindowHandle("MovieCaptureWnd");
    cBtn = GetButtonHandle("MovieCapturewnd_Expand.cBtn");
    Timer = GetTextBoxHandle("MovieCapturewnd_Expand.timer");
    return;
}

function OnTimer(int TimerID)
{
    // End:0x16
    if(TimerID == 7069)
    {
        secInt++;
    }
    setTimeTxt();
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x19
        case "cBtn":
            MovieCaptureToggle();
            // End:0x1C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function string itoStr(int tmpNum)
{
    local string tmpStr;

    // End:0x21
    if(tmpNum < 10)
    {
        tmpStr = "0" $ string(tmpNum);        
    }
    else
    {
        tmpStr = string(tmpNum);
    }
    return tmpStr;
    return;
}

function setTimeTxt()
{
    Timer.SetText(((((itoStr(int(float((secInt / 60) / 60) % float(60)))) $ " : ") $ (itoStr(int(float(secInt / 60) % float(60))))) $ " : ") $ (itoStr(int(float(secInt) % float(60)))));
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(5420);
    RegisterEvent(5430);
    RegisterEvent(5440);
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x38
        case 5420:
            secInt = 0;
            setTimeTxt();
            Me.SetTimer(7069, 1000);
            // End:0x79
            break;
        // End:0x57
        case 5430:
            Me.KillTimer(7069);
            // End:0x79
            break;
        // End:0x76
        case 5440:
            Me.KillTimer(7069);
            // End:0x79
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
