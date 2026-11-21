class WebBrowserWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle m_hWebBrowserWnd;
var WebBrowserHandle m_hBrowserViewer;
var string m_callBackFunction;

function OnRegisterEvent()
{
    RegisterEvent(5740);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x4D
    if(1 == 0)
    {
        m_hWebBrowserWnd = GetHandle(m_WindowName);
        m_hBrowserViewer = WebBrowserHandle(GetHandle(m_WindowName $ ".WebBrowser"));        
    }
    else
    {
        m_hWebBrowserWnd = GetWindowHandle(m_WindowName);
        m_hBrowserViewer = GetWebBrowserHandle(m_WindowName $ ".WebBrowser");
    }
    return;
}

function OnShow()
{
    m_hBrowserViewer.ShowWindow();
    return;
}

function OnHide()
{
    m_hBrowserViewer.HideWindow();
    return;
}

function ShowFileRegisterWnd(string param)
{
    ParseString(param, "CallBack", m_callBackFunction);
    FileRegisterWndShow(4);
    return;
}

function UploadFileFullPath(string Path)
{
    local string Command;

    Command = ((m_callBackFunction $ "('") $ Path) $ "')";
    m_hBrowserViewer.ExecuteJavaScript(Command);
    FileRegisterWndHide();
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 5740:
            ShowFileRegisterWnd(param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

defaultproperties
{
    m_WindowName="WebBrowserWnd"
}