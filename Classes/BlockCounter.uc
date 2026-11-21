class BlockCounter extends UIScript;

const TIMER_ID = 1010;
const TIMER_DELAY = 1000;
const TeamRed_ID = 1;
const TeamBlue_ID = 0;
const CHAT_UNION_MAX = 20;

var WindowHandle Me;
var TextBoxHandle TeamRedCount;
var TextBoxHandle TeamBlueCount;
var TextBoxHandle TimerCount;
var TextBoxHandle TimerCountTitle;
var TextBoxHandle CountCenter;
var int Min;
var int Sec;
var string MinStr;
var string SecStr;

function OnRegisterEvent()
{
    RegisterEvent(3890);
    RegisterEvent(3900);
    RegisterEvent(3910);
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
    Me = GetHandle("BlockCounter");
    TeamRedCount = TextBoxHandle(GetHandle("BlockCounter.TeamRedCount"));
    TeamBlueCount = TextBoxHandle(GetHandle("BlockCounter.TeamBlueCount"));
    TimerCount = TextBoxHandle(GetHandle("BlockCounter.TimerCount"));
    TimerCountTitle = TextBoxHandle(GetHandle("BlockCounter.TimerCountTitle"));
    CountCenter = TextBoxHandle(GetHandle("BlockCounter.CountCenter"));
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("BlockCounter");
    TeamRedCount = GetTextBoxHandle("BlockCounter.TeamRedCount");
    TeamBlueCount = GetTextBoxHandle("BlockCounter.TeamBlueCount");
    TimerCount = GetTextBoxHandle("BlockCounter.TimerCount");
    TimerCountTitle = GetTextBoxHandle("BlockCounter.TimerCountTitle");
    CountCenter = GetTextBoxHandle("BlockCounter.CountCenter");
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 3890:
            HandleBlockStateTeam(a_Param);
            // End:0x47
            break;
        // End:0x33
        case 3900:
            HandleBlockStatePlayer(a_Param);
            // End:0x47
            break;
        // End:0x44
        case 3910:
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
    Me.KillTimer(1010);
    return;
}

function OnShow()
{
    local Color A, B;

    A.R = byte(255);
    A.G = 111;
    A.B = 111;
    B.R = 111;
    B.G = 111;
    B.B = byte(255);
    TeamRedCount.SetTextColor(A);
    TeamBlueCount.SetTextColor(B);
    Me.SetTimer(1010, 1000);
    return;
}

function HandleBlockStateTeam(string param)
{
    local int TeamID, TeamScore, RemainSec;

    ParseInt(param, "TeamID", TeamID);
    ParseInt(param, "TeamScore", TeamScore);
    ParseInt(param, "RemainSec", RemainSec);
    TimerReset(RemainSec);
    // End:0x8B
    if(TeamID == 1)
    {
        TeamRedCount.SetText(string(TeamScore));
        TimerReset(RemainSec);
        DrawTimerCount();
    }
    // End:0xBD
    if(TeamID == 0)
    {
        TeamBlueCount.SetText(string(TeamScore));
        TimerReset(RemainSec);
        DrawTimerCount();
    }
    return;
}

function HandleBlockStatePlayer(string param)
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
    // End:0x12C
    if(TimerID == 1010)
    {
        // End:0x102
        if((Min == 0) && Sec < 10)
        {
            // End:0x4C
            if((Min == 0) && Sec == 5)
            {
                AddSystemMessage(2922);
            }
            // End:0x70
            if((Min == 0) && Sec == 4)
            {
                AddSystemMessage(2923);
            }
            // End:0x94
            if((Min == 0) && Sec == 3)
            {
                AddSystemMessage(2925);
            }
            // End:0xB8
            if((Min == 0) && Sec == 2)
            {
                AddSystemMessage(2926);
            }
            // End:0xDB
            if((Min == 0) && Sec == 1)
            {
                AddSystemMessage(2927);
            }
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
    TeamRedCount.SetText("0");
    TeamBlueCount.SetText("0");
    return;
}

function HandleHide()
{
    Me.HideWindow();
    return;
}
