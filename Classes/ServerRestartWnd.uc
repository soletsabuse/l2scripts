class ServerRestartWnd extends UICommonAPI;

const EV_SERVER_RESTART = 48890;
const TIMER_ID = 48891;
const TICK_MS = 1000;

var WindowHandle Me;
var TextBoxHandle TitleTxt;
var TextBoxHandle TimeTxt;
var StatusBarHandle TimeBar;
var int Remain;
var int total;

function OnLoad()
{
    Me = GetWindowHandle("ServerRestartWnd");
    TitleTxt = GetTextBoxHandle("ServerRestartWnd.TitleTxt");
    TimeTxt = GetTextBoxHandle("ServerRestartWnd.TimeTxt");
    TimeBar = GetStatusBarHandle("ServerRestartWnd.TimeBar");
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(48890);
    return;
}

function OnEvent(int EventID, string param)
{
    local array<string> F;
    local int N;

    // End:0x11
    if(EventID != 48890)
    {
        return;
    }
    N = Split(param, ";", F);
    // End:0x4E
    if((N < 1) || int(F[0]) == 0)
    {
        StopCountdown();
        return;
    }
    // End:0x5C
    if(N < 4)
    {
        return;
    }
    total = int(F[2]);
    Remain = int(F[3]);
    // End:0x8E
    if(Remain < 0)
    {
        Remain = 0;
    }
    // End:0xA8
    if(total < Remain)
    {
        total = Remain;
    }
    // End:0xBA
    if(total < 1)
    {
        total = 1;
    }
    // End:0xF1
    if((N >= 5) && F[4] != "")
    {
        TitleTxt.SetText(F[4]);        
    }
    else
    {
        // End:0x124
        if(int(F[1]) == 2)
        {
            TitleTxt.SetText("Server Shutdown");            
        }
        else
        {
            TitleTxt.SetText("Server Restart");
        }
    }
    UpdateDisplay();
    Me.ShowWindow();
    Me.KillTimer(48891);
    Me.SetTimer(48891, 1000);
    return;
}

function OnTimer(int TimerID)
{
    // End:0x11
    if(TimerID != 48891)
    {
        return;
    }
    Remain--;
    // End:0x2B
    if(Remain <= 0)
    {
        StopCountdown();
        return;
    }
    UpdateDisplay();
    return;
}

function UpdateDisplay()
{
    TimeTxt.SetText(FormatHMS(Remain));
    TimeBar.SetPoint(Remain, total);
    return;
}

function StopCountdown()
{
    Me.KillTimer(48891);
    Me.HideWindow();
    return;
}

function OnHide()
{
    Me.KillTimer(48891);
    return;
}

function string FormatHMS(int Seconds)
{
    local int h, M, S;
    local string HStr, MStr, SStr;

    h = Seconds / 3600;
    M = int(float(Seconds) % float(3600)) / 60;
    S = int(float(Seconds) % float(60));
    HStr = string(h);
    MStr = string(M);
    SStr = string(S);
    // End:0x86
    if(h < 10)
    {
        HStr = "0" $ HStr;
    }
    // End:0xA2
    if(M < 10)
    {
        MStr = "0" $ MStr;
    }
    // End:0xBE
    if(S < 10)
    {
        SStr = "0" $ SStr;
    }
    return (((HStr $ ":") $ MStr) $ ":") $ SStr;
    return;
}
