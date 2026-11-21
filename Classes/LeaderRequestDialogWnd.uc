class LeaderRequestDialogWnd extends PacketsInfo;

var string m_WindowName;
var int nCurrentProgressTime;
var WindowHandle Me;
var ProgressCtrlHandle ReadyProgress;
var TextBoxHandle ProgressInfoTxt;

function OnLoad()
{
    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    ReadyProgress = GetProgressCtrlHandle(m_WindowName $ ".DialogBody.ReadyProgress");
    ProgressInfoTxt = GetTextBoxHandle(m_WindowName $ ".DialogBody.ProgressInfoTxt");
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

function OnClickButton(string strID)
{
    // End:0x1D
    if(strID == "OKButton")
    {
        evRqDialogOk();        
    }
    else
    {
        // End:0x3B
        if(strID == "CancelButton")
        {
            evRqDialogCancel();
        }
    }
    deleteProgress();
    Me.HideWindow();
    return;
}

function OnProgressTimeUp(string strID)
{
    // End:0x2E
    if(strID == "ReadyProgress")
    {
        deleteProgress();
        Me.HideWindow();
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x15
    if(TimerID == 1001)
    {
        updateTextProgress();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1A
    if(Event_ID == 3550)
    {
        handleCustomPacket(param);
    }
    return;
}

function handleCustomPacket(string param)
{
    local int EventID;

    ParseInt(param, "EventID", EventID);
    switch(EventID)
    {
        // End:0x36
        case 1225:
            handleDialogShow(param);
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            // End:0x3C
            break;
            break;
    }
    return;
}

function handleDialogShow(string param)
{
    local int nResult;

    ParseInt(param, "ask", nCurrentProgressTime);
    // End:0x3B
    if(nCurrentProgressTime > 0)
    {
        initProgress();
        startProgress();
        Me.ShowWindow();
    }
    return;
}

function initProgress()
{
    Me.KillTimer(1001);
    ReadyProgress.Reset();
    ReadyProgress.SetProgressTime(nCurrentProgressTime * 1000);
    ProgressInfoTxt.SetText(string(nCurrentProgressTime) @ GetSystemString(5184));
    return;
}

function startProgress()
{
    Me.KillTimer(1001);
    Me.SetTimer(1001, 1000);
    ReadyProgress.Start();
    return;
}

function deleteProgress()
{
    Me.KillTimer(1001);
    ReadyProgress.Stop();
    return;
}

function updateTextProgress()
{
    Me.KillTimer(1001);
    nCurrentProgressTime--;
    // End:0x28
    if(nCurrentProgressTime < 0)
    {
        return;
    }
    Me.SetTimer(1001, 1000);
    ProgressInfoTxt.SetText(string(nCurrentProgressTime) @ GetSystemString(5184));
    return;
}

function evRqDialogOk()
{
    RequestBypassToServer("leader_control_dialog yes");
    return;
}

function evRqDialogCancel()
{
    RequestBypassToServer("leader_control_dialog no");
    return;
}
