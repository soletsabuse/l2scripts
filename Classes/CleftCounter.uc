class CleftCounter extends UIScript;

const TIMER_ID = 1023;
const TIMER_DELAY = 1000;
const TeamA_ID = 0;
const TeamB_ID = 1;

var WindowHandle Me;
var TextBoxHandle TeamACount;
var TextBoxHandle TeamBCount;
var TextBoxHandle TimerCount;
var TextBoxHandle TimerCountTitle;
var TextBoxHandle CountCenter;
var int Min;
var int Sec;
var string MinStr;
var string SecStr;

function OnRegisterEvent()
{
    RegisterEvent(3740);
    RegisterEvent(3750);
    RegisterEvent(3760);
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
    Me = GetHandle("CleftCounter");
    TeamACount = TextBoxHandle(GetHandle("TeamACount"));
    TeamBCount = TextBoxHandle(GetHandle("TeamBCount"));
    TimerCount = TextBoxHandle(GetHandle("TimerCount"));
    TimerCountTitle = TextBoxHandle(GetHandle("TimerCountTitle"));
    CountCenter = TextBoxHandle(GetHandle("CountCenter"));
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("CleftCounter");
    TeamACount = GetTextBoxHandle("CleftCounter.TeamACount");
    TeamBCount = GetTextBoxHandle("CleftCounter.TeamBCount");
    TimerCount = GetTextBoxHandle("CleftCounter.TimerCount");
    TimerCountTitle = GetTextBoxHandle("CleftCounter.TimerCountTitle");
    CountCenter = GetTextBoxHandle("CleftCounter.CountCenter");
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 3740:
            HandleCleftStateTeam(a_Param);
            // End:0x47
            break;
        // End:0x33
        case 3750:
            HandleCleftStatePlayer(a_Param);
            // End:0x47
            break;
        // End:0x44
        case 3760:
            HandleHide();
            // End:0x47
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnHide()
{
    Me.KillTimer(1023);
    return;
}

function OnShow()
{
    Me.SetTimer(1023, 1000);
    return;
}

function HandleCleftStateTeam(string param)
{
    local int TeamID, TeamPoint, RemainSec;

    ParseInt(param, "TeamID", TeamID);
    ParseInt(param, "TeamPoint", TeamPoint);
    ParseInt(param, "RemainSec", RemainSec);
    TimerReset(RemainSec);
    DrawTimerCount();
    // End:0x83
    if(TeamID == 0)
    {
        TeamACount.SetText(string(TeamPoint));        
    }
    else
    {
        // End:0xA4
        if(TeamID == 1)
        {
            TeamBCount.SetText(string(TeamPoint));
        }
    }
    return;
}

function HandleCleftStatePlayer(string param)
{
    local int RemainSec;

    ParseInt(param, "RemainSec", RemainSec);
    TimerReset(RemainSec);
    DrawTimerCount();
    return;
}

function OnClickButton(string Name)
{
    return;
}

function OnTimer(int TimerID)
{
    // End:0xC0
    if(TimerID == 1023)
    {
        // End:0x32
        if((Min == 1) && Sec == 0)
        {
            AddSystemMessage(2420);
        }
        // End:0x56
        if((Min == 0) && Sec == 10)
        {
            AddSystemMessage(2421);
        }
        // End:0x96
        if((Min == 0) && Sec < 9)
        {
            TimerCount.HideWindow();
            TimerCountTitle.HideWindow();
            UpdateTimerCount();            
        }
        else
        {
            TimerCount.ShowWindow();
            TimerCountTitle.ShowWindow();
            DrawTimerCount();
            UpdateTimerCount();
        }
    }
    return;
}

function DrawTimerCount()
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
    TimerCount.SetText((MinStr $ ":") $ SecStr);
    return;
}

function UpdateTimerCount()
{
    // End:0x24
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

function TimerReset(int RemainTime)
{
    Min = RemainTime / 60;
    Sec = int(float(RemainTime) % float(60));
    return;
}

function ResetCurrentStat()
{
    TeamACount.SetText("0");
    TeamBCount.SetText("0");
    return;
}

function HandleHide()
{
    Me.HideWindow();
    return;
}
