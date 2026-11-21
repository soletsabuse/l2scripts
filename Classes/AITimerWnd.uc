class AITimerWnd extends UIScript;

const TIMER_ID_COUNTDOWN = 2025;
const TIMER_ID_COUNTUP = 2026;
const TIMER_DELAY = 1000;

var WindowHandle Me;
var WindowHandle MEBtn;
var TextBoxHandle txtAITimerObject;
var TextBoxHandle MinTxt;
var TextBoxHandle SecTxt;
var TextBoxHandle DividerTxt;
var int UserID;
var int EventID;
var int ASK;
var int Reply;
var int Min;
var int Sec;
var int CurMin;
var int CurSec;
var int TargetMin;
var int TargetSec;
var int TempMin;
var int TempSec;
var string Param1;
var string Param2;
var string param3;
var string param4;
var string param5;
var string param6;
var string MinStr;
var string SecStr;
var bool m_InGameBool;

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0xCD
    if(1 == 0)
    {
        Me = GetHandle("AITimerWnd");
        MinTxt = TextBoxHandle(GetHandle("AITimerWnd.MinTxt"));
        SecTxt = TextBoxHandle(GetHandle("AITimerWnd.SecTxt"));
        DividerTxt = TextBoxHandle(GetHandle("AITimerWnd.DividerTxt"));
        txtAITimerObject = TextBoxHandle(GetHandle("AITimerWnd.txtAITimerObject"));        
    }
    else
    {
        Me = GetWindowHandle("AITimerWnd");
        MinTxt = GetTextBoxHandle("AITimerWnd.MinTxt");
        SecTxt = GetTextBoxHandle("AITimerWnd.SecTxt");
        DividerTxt = GetTextBoxHandle("AITimerWnd.DividerTxt");
        txtAITimerObject = GetTextBoxHandle("AITimerWnd.txtAITimerObject");
    }
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(3550);
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 3550:
            HandleAIController(param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleAIController(string param)
{
    local string Param1, Param2, param3, param4;
    local int EventID;

    ParseString(param, "Param1", Param1);
    ParseString(param, "Param2", Param2);
    ParseString(param, "Param3", param3);
    ParseString(param, "Param4", param4);
    ParseString(param, "Param5", param5);
    ParseString(param, "Param6", param6);
    ParseInt(param, "EventID", EventID);
    Min = 0;
    Sec = 0;
    CurMin = 0;
    CurSec = 0;
    TargetMin = 0;
    TargetSec = 0;
    // End:0x173
    if(EventID == 0)
    {
        switch(Param1)
        {
            // End:0x129
            case "0":
                Me.KillTimer(2025);
                StartCountDown(int(Param2), int(param3), param4, int(param5), int(param6));
                // End:0x170
                break;
            // End:0x16D
            case "1":
                Me.KillTimer(2026);
                StartCountUp(int(Param2), int(param3), param4, int(param5), int(param6));
                // End:0x170
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        // End:0x23A
        if(EventID == 1)
        {
            switch(Param1)
            {
                // End:0x1DE
                case "0":
                    MinTxt.HideWindow();
                    SecTxt.HideWindow();
                    DividerTxt.HideWindow();
                    txtAITimerObject.HideWindow();
                    Me.KillTimer(2025);
                    // End:0x23A
                    break;
                // End:0x237
                case "1":
                    MinTxt.HideWindow();
                    SecTxt.HideWindow();
                    DividerTxt.HideWindow();
                    txtAITimerObject.HideWindow();
                    Me.KillTimer(2026);
                    // End:0x23A
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
        }
        return;
    }
}

function OnTimer(int TimerID)
{
    // End:0xC4
    if(TimerID == 2025)
    {
        // End:0x7F
        if((Min == TargetMin) && Sec < 10)
        {
            MinTxt.HideWindow();
            SecTxt.HideWindow();
            DividerTxt.HideWindow();
            txtAITimerObject.HideWindow();
            Me.KillTimer(2025);            
        }
        else
        {
            txtAITimerObject.ShowWindow();
            MinTxt.ShowWindow();
            SecTxt.ShowWindow();
            DividerTxt.ShowWindow();
            UpdateTimerCountDown();
        }        
    }
    else
    {
        // End:0x295
        if(TimerID == 2026)
        {
            // End:0x1DC
            if(TargetSec < 11)
            {
                Debug((((("TargetMin" @ string(TargetMin)) @ "Min") @ string(Min)) @ "Sec") @ string(Sec));
                // End:0x197
                if((Min == (TargetMin - 1)) && ((TargetSec + 60) - Sec) < 10)
                {
                    MinTxt.HideWindow();
                    SecTxt.HideWindow();
                    DividerTxt.HideWindow();
                    txtAITimerObject.HideWindow();
                    Me.KillTimer(2026);                    
                }
                else
                {
                    txtAITimerObject.ShowWindow();
                    MinTxt.ShowWindow();
                    SecTxt.ShowWindow();
                    DividerTxt.ShowWindow();
                    UpdateTimerCountUp();
                }                
            }
            else
            {
                // End:0x253
                if((Min == TargetMin) && (TargetSec - Sec) < 10)
                {
                    MinTxt.HideWindow();
                    SecTxt.HideWindow();
                    DividerTxt.HideWindow();
                    txtAITimerObject.HideWindow();
                    Me.KillTimer(2026);                    
                }
                else
                {
                    txtAITimerObject.ShowWindow();
                    MinTxt.ShowWindow();
                    SecTxt.ShowWindow();
                    DividerTxt.ShowWindow();
                    UpdateTimerCountUp();
                }
            }
        }
    }
    return;
}

function UpdateTimerCountDown()
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

function UpdateTimerCountUp()
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
    if(Sec == 59)
    {
        Sec = 0;
        Min = Min + 1;        
    }
    else
    {
        Sec = Sec + 1;
    }
    return;
}

function TimerReset(int CurMin, int CurSec)
{
    Min = CurMin;
    Sec = CurSec;
    MinStr = string(Min);
    SecStr = string(Sec);
    // End:0x4C
    if(Min < 10)
    {
        MinStr = "0" $ MinStr;
    }
    // End:0x68
    if(Sec < 10)
    {
        SecStr = "0" $ SecStr;
    }
    MinTxt.SetText(MinStr);
    SecTxt.SetText(SecStr);
    m_InGameBool = true;
    return;
}

function StartCountDown(int CurMin, int CurSec, string strDisplayTxt, int TMin, int TSec)
{
    CurMin = CurMin;
    CurSec = CurSec;
    TargetMin = TMin;
    TargetSec = TSec;
    TimerReset(CurMin, CurSec);
    txtAITimerObject.SetText(strDisplayTxt);
    Me.ShowWindow();
    Me.SetTimer(2025, 1000);
    return;
}

function StartCountUp(int CurMin, int CurSec, string strDisplayTxt, int TMin, int TSec)
{
    CurMin = CurMin;
    CurSec = CurSec;
    TargetMin = TMin;
    TargetSec = TSec;
    Debug("TargetMin" @ string(TargetMin));
    TimerReset(CurMin, CurSec);
    txtAITimerObject.SetText(strDisplayTxt);
    Me.ShowWindow();
    Me.SetTimer(2026, 1000);
    return;
}

function OnHide()
{
    Me.KillTimer(2026);
    Me.KillTimer(2025);
    return;
}
