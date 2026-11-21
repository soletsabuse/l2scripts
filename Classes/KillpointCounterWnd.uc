class KillpointCounterWnd extends UIScript;

const MAX_GAME_TIME_MIN = 20;
const TIMER_ID = 1024;
const TIMER_DELAY = 1000;

var WindowHandle Me;
var WindowHandle MEBtn;
var TextBoxHandle KillPointTxt;
var TextBoxHandle MinTxt;
var TextBoxHandle SecTxt;
var TextBoxHandle DividerTxt;
var int Min;
var int Sec;
var string MinStr;
var string SecStr;
var bool m_InGameBool;

function OnRegisterEvent()
{
    RegisterEvent(3500);
    RegisterEvent(3470);
    RegisterEvent(3501);
    return;
}

function OnLoad()
{
    // End:0xE9
    if(1 == 0)
    {
        Me = GetHandle("KillPointCounterWnd");
        KillPointTxt = TextBoxHandle(GetHandle("KillPointCounterWnd.KillPointTxt"));
        MinTxt = TextBoxHandle(GetHandle("KillPointCounterWnd.MinTxt"));
        SecTxt = TextBoxHandle(GetHandle("KillPointCounterWnd.SecTxt"));
        DividerTxt = TextBoxHandle(GetHandle("KillPointCounterWnd.DividerTxt"));        
    }
    else
    {
        Me = GetWindowHandle("KillPointCounterWnd");
        KillPointTxt = GetTextBoxHandle("KillPointCounterWnd.KillPointTxt");
        MinTxt = GetTextBoxHandle("KillPointCounterWnd.MinTxt");
        SecTxt = GetTextBoxHandle("KillPointCounterWnd.SecTxt");
        DividerTxt = GetTextBoxHandle("KillPointCounterWnd.DividerTxt");
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int statusInt;

    switch(Event_ID)
    {
        // End:0x53
        case 3500:
            // End:0x45
            if(!Me.IsShowWindow() && !m_InGameBool)
            {
                Me.ShowWindow();
                LaunchTimer();
            }
            UpdateMyKillPoint(param);
            // End:0xC4
            break;
        // End:0x9F
        case 3470:
            ParseInt(param, "Status", statusInt);
            switch(statusInt)
            {
                // End:0x99
                case 2:
                    m_InGameBool = false;
                    Me.HideWindow();
                    // End:0x9C
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0xC4
            break;
        // End:0xC1
        case 3501:
            m_InGameBool = false;
            Me.HideWindow();
            // End:0xC4
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function UpdateMyKillPoint(string param)
{
    local string KillPoint;

    ParseString(param, "KillPoint", KillPoint);
    KillPointTxt.SetText(KillPoint);
    return;
}

function LaunchTimer()
{
    TimerReset();
    Me.SetTimer(1024, 1000);
    return;
}

function OnTimer(int TimerID)
{
    // End:0x9F
    if(TimerID == 1024)
    {
        // End:0x6C
        if((Min == 0) && Sec < 9)
        {
            MinTxt.HideWindow();
            SecTxt.HideWindow();
            DividerTxt.HideWindow();
            Me.KillTimer(1024);            
        }
        else
        {
            MinTxt.ShowWindow();
            SecTxt.ShowWindow();
            DividerTxt.ShowWindow();
            UpdateTimerCount();
        }
    }
    return;
}

function UpdateTimerCount()
{
    MinStr = string(Min);
    SecStr = string(Sec);
    // End:0x36
    if(Min < 10)
    {
        MinStr = "0" $ MinStr;
    }
    // End:0x52
    if(Sec < 10)
    {
        SecStr = "0" $ SecStr;
    }
    MinTxt.SetText(MinStr);
    SecTxt.SetText(SecStr);
    // End:0x9E
    if(Sec == 0)
    {
        Sec = 59;
        Min = Min - 1;        
    }
    else
    {
        Sec = Sec - 1;
    }
    return;
}

function TimerReset()
{
    Min = 20;
    Sec = 0;
    MinStr = string(Min);
    SecStr = string(Sec);
    MinTxt.SetText(MinStr);
    SecTxt.SetText(SecStr);
    m_InGameBool = true;
    return;
}

function OnHide()
{
    Me.KillTimer(1024);
    return;
}
