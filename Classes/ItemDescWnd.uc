class ItemDescWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle m_hItemDescWnd;
var HtmlHandle m_hHtmlViewer;

function OnRegisterEvent()
{
    RegisterEvent(3300);
    RegisterEvent(3310);
    RegisterEvent(3320);
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
        m_hItemDescWnd = GetHandle(m_WindowName);
        m_hHtmlViewer = HtmlHandle(GetHandle(m_WindowName $ ".HtmlViewer"));        
    }
    else
    {
        m_hItemDescWnd = GetWindowHandle(m_WindowName);
        m_hHtmlViewer = GetHtmlHandle(m_WindowName $ ".HtmlViewer");
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x30
        case 3300:
            m_hItemDescWnd.ShowWindow();
            m_hItemDescWnd.SetFocus();
            // End:0x5F
            break;
        // End:0x46
        case 3310:
            HandleLoadHtmlFromString(param);
            // End:0x5F
            break;
        // End:0x5C
        case 3320:
            HandleWindowTitle(param);
            // End:0x5F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleWindowTitle(string param)
{
    local string Title;

    ParseString(param, "Title", Title);
    m_hItemDescWnd.SetWindowTitle(Title);
    return;
}

function HandleLoadHtmlFromString(string param)
{
    local string HtmlString;

    ParseString(param, "HTMLString", HtmlString);
    m_hHtmlViewer.LoadHtmlFromString(HtmlString);
    return;
}

function ShowHelp(string strPath)
{
    // End:0x3F
    if(Len(strPath) > 0)
    {
        m_hHtmlViewer.LoadHtml(strPath);
        m_hItemDescWnd.ShowWindow();
        m_hItemDescWnd.SetFocus();
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="ItemDescWnd"
}