class NPCDialogWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle m_hNPCDialogWnd;
var HtmlHandle m_hHtmlViewer;
var bool m_bRecievedCloseUI;
var bool m_bNpcZoomMode;

function OnRegisterEvent()
{
    RegisterEvent(3270);
    RegisterEvent(3280);
    RegisterEvent(3290);
    RegisterEvent(3321);
    RegisterEvent(150);
    RegisterEvent(160);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x53
    if(1 == 0)
    {
        m_hNPCDialogWnd = GetHandle(m_WindowName);
        m_hHtmlViewer = HtmlHandle(GetHandle(m_WindowName $ ".HtmlViewer"));        
    }
    else
    {
        m_hNPCDialogWnd = GetWindowHandle(m_WindowName);
        m_hHtmlViewer = GetHtmlHandle(m_WindowName $ ".HtmlViewer");
    }
    return;
}

function OnShow()
{
    getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "QuestHTMLWnd,NPCDialogWnd");
    // End:0x73
    if(GetWindowHandle("MultiSellWnd").IsShowWindow())
    {
        GetWindowHandle("MultiSellWnd").HideWindow();
    }
    return;
}

function OnHide()
{
    ProcCloseNPCDialogWnd();
    getInstanceL2Util().syncWindowLocAuto("QuestHTMLWnd,NPCDialogWnd");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x18
        case 3270:
            ShowNPCDialogWnd();
            // End:0x79
            break;
        // End:0x29
        case 3280:
            HideNPCDialogWnd();
            // End:0x79
            break;
        // End:0x59
        case 3290:
            m_hNPCDialogWnd.SetWindowTitle(GetSystemString(444));
            HandleLoadHtmlFromString(param);
            // End:0x79
            break;
        // End:0x73
        case 3321:
            m_hNPCDialogWnd.HideWindow();
            // End:0x79
            break;
        // End:0xFFFF
        default:
            // End:0x79
            break;
            break;
    }
    return;
}

function OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
    // End:0x15
    if(a_HtmlHandle == m_hHtmlViewer)
    {
        HideNPCDialogWnd();
    }
    return;
}

function HandleLoadHtmlFromString(string param)
{
    local int SizeX, SizeY;
    local string HtmlString;

    SetDialogSize(-1, -1);
    ParseString(param, "HTMLString", HtmlString);
    ParseInt(param, "dialogWidth", SizeX);
    ParseInt(param, "dialogHeight", SizeY);
    SetDialogSize(SizeX, SizeY);
    m_hHtmlViewer.LoadHtmlFromString(HtmlString);
    return;
}

function SetDialogSize(int W, int h)
{
    // End:0x34
    if((W > 0) && h > 0)
    {
        m_hNPCDialogWnd.SetWindowSize(W, h);        
    }
    else
    {
        // End:0x68
        if((W > 0) && h <= 0)
        {
            m_hNPCDialogWnd.SetWindowSize(W, 408);            
        }
        else
        {
            // End:0x9C
            if((W <= 0) && h > 0)
            {
                m_hNPCDialogWnd.SetWindowSize(314, h);                
            }
            else
            {
                m_hNPCDialogWnd.SetWindowSize(314, 408);
            }
        }
    }
    return;
}

function PressCloseButton()
{
    // End:0x11
    if(m_bNpcZoomMode)
    {
        m_bRecievedCloseUI = true;
    }
    return;
}

function OnClickButton(string Name)
{
    PressCloseButton();
    return;
}

function BeginNpcZoomMode()
{
    m_bRecievedCloseUI = false;
    m_bNpcZoomMode = true;
    return;
}

function EndNpcZoomMode()
{
    ProcCloseNPCDialogWnd();
    m_bRecievedCloseUI = false;
    m_bNpcZoomMode = false;
    return;
}

function OnExitState(name a_NextStateName)
{
    // End:0x15
    if(a_NextStateName == 'NpcZoomCameraState')
    {
        BeginNpcZoomMode();
    }
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x15
    if(a_PreStateName == 'NpcZoomCameraState')
    {
        EndNpcZoomMode();
    }
    return;
}

function ShowNPCDialogWnd()
{
    ExecuteEvent(3324);
    m_hNPCDialogWnd.ShowWindow();
    m_hNPCDialogWnd.SetFocus();
    return;
}

function HideNPCDialogWnd()
{
    m_hNPCDialogWnd.HideWindow();
    return;
}

function ProcCloseNPCDialogWnd()
{
    // End:0x22
    if(m_bRecievedCloseUI && m_bNpcZoomMode)
    {
        m_bRecievedCloseUI = false;
        RequestFinishNPCZoomCamera();
    }
    return;
}

function OnReceivedCloseUI()
{
    PressCloseButton();
    PlayConsoleSound(6);
    GetWindowHandle("NPCDialogWnd").HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="NPCDialogWnd"
}