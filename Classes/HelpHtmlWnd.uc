class HelpHtmlWnd extends UICommonAPI;

var bool m_bShow;
var string m_WindowName;
var HtmlHandle m_hHelpHtmlWndHtmlViewer;

function OnRegisterEvent()
{
    RegisterEvent(1210);
    RegisterEvent(1220);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    RegisterState("HelpHtmlWnd", "GamingState");
    RegisterState("HelpHtmlWnd", "LoginState");
    m_hHelpHtmlWndHtmlViewer = GetHtmlHandle("HelpHtmlWnd.HtmlViewer");
    m_bShow = false;
    return;
}

function OnShow()
{
    m_bShow = true;
    return;
}

function OnHide()
{
    m_bShow = false;
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x33
    if(GetGameStateName() != "SERVERLISTSTATE")
    {
        // End:0x33
        if(!getInstanceUIData().getIsClassicServer())
        {
            return;
        }
    }
    // End:0x50
    if(Event_ID == 1210)
    {
        HandleShowHelp(param);        
    }
    else
    {
        // End:0x6A
        if(Event_ID == 1220)
        {
            HandleLoadHelpHtml(param);
        }
    }
    return;
}

function HandleShowHelp(string param)
{
    local string strPath;

    // End:0x30
    if(m_bShow)
    {
        PlayConsoleSound(6);
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HelpHtmlWnd");        
    }
    else
    {
        // End:0xC4
        if(param == "FilePath=..\\L2text\\125")
        {
            m_hHelpHtmlWndHtmlViewer.LoadHtml("..\\L2text\\help_item_upgrade.htm");
            PlayConsoleSound(5);
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HelpHtmlWnd");
            Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HelpHtmlWnd");
            return;
        }
        ParseString(param, "FilePath", strPath);
        // End:0x1A1
        if(Len(strPath) > 0)
        {
            // End:0x130
            if(strPath == "..\\L2text\\server_help.htm")
            {
                Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("HelpHtmlWnd", true);                
            }
            else
            {
                Class'NWindow.UIAPI_WINDOW'.static.SetAlwaysOnTop("HelpHtmlWnd", false);
            }
            m_hHelpHtmlWndHtmlViewer.LoadHtml(strPath);
            PlayConsoleSound(5);
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HelpHtmlWnd");
            Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HelpHtmlWnd");
        }
    }
    return;
}

function HandleLoadHelpHtml(string param)
{
    local string strHtml;

    ParseString(param, "HtmlString", strHtml);
    // End:0x3D
    if(Len(strHtml) > 0)
    {
        m_hHelpHtmlWndHtmlViewer.LoadHtmlFromString(strHtml);
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
    m_WindowName="HelpHtmlWnd"
}