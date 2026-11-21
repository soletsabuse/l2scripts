class ReviveRequestDialogWnd extends PacketsInfo;

const REVIVE_OK = 1;
const REVIVE_CANCEL = 0;

struct _reviveData
{
    var float fPercent;
    var string casterName;
    var string TargetName;
};

struct _reviveTimeData
{
    var int nCurrentTime;
    var int nMaximumTime;
};

var bool bPreviousLazyMode;
var _reviveData reviveData;
var _reviveTimeData reviveTimeData;
var int nStartRevive;
var int timeSec;
var int MAX_TIME;
var int CURR_TIME;
var string m_WindowName;
var WindowHandle Me;
var ProgressCtrlHandle ReviveRequestProgress;
var StatusBarHandle TimeBar;
var TextBoxHandle ReviveInfoTxt;
var TextBoxHandle ReviveEndTimeTxt;
var TextBoxHandle ReviveEndTimeMsTxt;
var ButtonHandle OKButton;
var ButtonHandle CancelButton;

function OnLoad()
{
    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    OKButton = GetButtonHandle(m_WindowName $ ".OKButton");
    CancelButton = GetButtonHandle(m_WindowName $ ".CancelButton");
    ReviveRequestProgress = GetProgressCtrlHandle(m_WindowName $ ".ReviveRequestProgress");
    TimeBar = GetStatusBarHandle(m_WindowName $ ".ReviveInfoWnd.TimeBar");
    ReviveInfoTxt = GetTextBoxHandle(m_WindowName $ ".ReviveInfoWnd.ReviveInfoTxt");
    ReviveEndTimeTxt = GetTextBoxHandle(m_WindowName $ ".ReviveInfoWnd.ReviveEndTimeTxt");
    ReviveEndTimeMsTxt = GetTextBoxHandle(m_WindowName $ ".ReviveInfoWnd.ReviveEndTimeMsTxt");
    MAX_TIME = 60;
    CURR_TIME = 60;
    timeSec = MAX_TIME;
    clearReviveUI();
    return;
}

function OnShow()
{
    return;
}

function OnHide()
{
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(3550);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1A
    if(Event_ID == 3550)
    {
        _OnEvent(param);
    }
    return;
}

function _OnEvent(string param)
{
    local int Event_ID;

    ParseInt(param, "EventID", Event_ID);
    switch(Event_ID)
    {
        // End:0x36
        case 1120:
            handleReviveRequest(param);
            // End:0x68
            break;
        // End:0x4C
        case 1121:
            handleReviveUpdate(param);
            // End:0x68
            break;
        // End:0x62
        case 1122:
            handleReviveResult(param);
            // End:0x68
            break;
        // End:0xFFFF
        default:
            // End:0x68
            break;
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    // End:0x1B
    if(strID == "OKButton")
    {
        requestRevive(1);
    }
    // End:0x3A
    if(strID == "CancelButton")
    {
        requestRevive(0);
    }
    // End:0xB5
    if(strID == "test")
    {
        SendFake(string(1120), string(RandRange(5000.0000000, 1000000.0000000)), string(0), "TestCaster" $ string(Rand(1000)), "TestTarget" $ string(Rand(1000)));
        SendFake(string(1121), string(CURR_TIME), string(MAX_TIME));
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x40
    if(TimerID == 10000)
    {
        timeSec--;
        // End:0x40
        if(timeSec == 0)
        {
            timeSec = MAX_TIME;
            Me.KillTimer(10000);
        }
    }
    // End:0x55
    if(TimerID == 10001)
    {
        updateReviveDialog();
    }
    return;
}

function handleReviveRequest(string param)
{
    local int nPercent;
    local string casterName, TargetName;

    ClearTimer();
    ClearData();
    ParseInt(param, "ask", nPercent);
    ParseString(param, "param1", casterName);
    ParseString(param, "param2", TargetName);
    reviveData.fPercent = float(nPercent / 10000);
    reviveData.casterName = casterName;
    reviveData.TargetName = TargetName;
    setReviveRequest();
    return;
}

function setReviveRequest()
{
    TimeBar.SetPoint(reviveTimeData.nCurrentTime, reviveTimeData.nMaximumTime);
    ReviveInfoTxt.SetText(MakeFullSystemMsg(GetSystemMessage(1510), reviveData.casterName, reviveData.TargetName, string(reviveData.fPercent)));
    OKButton.EnableWindow();
    CancelButton.EnableWindow();
    Me.ShowWindow();
    return;
}

function handleReviveUpdate(string param)
{
    local int nCurr, nMax;

    ParseInt(param, "ask", nCurr);
    ParseInt(param, "reply", nMax);
    reviveTimeData.nCurrentTime = nCurr * 100;
    reviveTimeData.nMaximumTime = nMax * 100;
    setReviveDialog();
    return;
}

function setReviveDialog()
{
    ClearTimer();
    Me.SetTimer(10001, 10);
    Me.SetTimer(10000, 1000);
    setTime(reviveTimeData.nCurrentTime, reviveTimeData.nMaximumTime);
    return;
}

function updateReviveDialog()
{
    reviveTimeData.nCurrentTime--;
    // End:0x1E
    if(reviveTimeData.nCurrentTime <= 0)
    {
        return;
    }
    setTime(reviveTimeData.nCurrentTime, reviveTimeData.nMaximumTime);
    return;
}

function handleReviveResult(string param)
{
    clearReviveUI();
    return;
}

function setTime(int nTime, int nMaxTime)
{
    // End:0x77
    if((nTime > 0) && nMaxTime > 0)
    {
        ReviveEndTimeTxt.SetText(string(nTime / 100) $ ".");
        ReviveEndTimeMsTxt.SetText(getMs(string(float(nTime) % float(100))));
        TimeBar.SetPoint(nTime, nMaxTime);        
    }
    else
    {
        ReviveEndTimeTxt.SetText("0.");
        ReviveEndTimeMsTxt.SetText("000");
        TimeBar.SetPoint(0, 0);
    }
    return;
}

function clearReviveUI()
{
    restorePreviousLazyMode();
    Me.HideWindow();
    ClearData();
    ClearTimer();
    setTime(0, 0);
    OKButton.DisableWindow();
    CancelButton.DisableWindow();
    return;
}

function restorePreviousLazyMode()
{
    return;
}

function ClearTimer()
{
    Me.KillTimer(10000);
    Me.KillTimer(10001);
    return;
}

function ClearData()
{
    local _reviveTimeData tData;
    local _reviveData rData;

    reviveTimeData = tData;
    reviveData = rData;
    return;
}

function string getMs(coerce string val)
{
    local string sVal;

    // End:0x2D
    if(Len(val) == 2)
    {
        sVal = val $ string(RandRange(1.0000000, 9.0000000));
    }
    // End:0x59
    if(Len(val) == 1)
    {
        sVal = val $ string(RandRange(10.0000000, 99.0000000));
    }
    return sVal;
    return;
}

function requestRevive(int nType)
{
    RequestBypassToServer("revive" @ string(nType));
    return;
}
