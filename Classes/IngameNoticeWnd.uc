class IngameNoticeWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle m_hIngameNoticeWnd;
var WebBrowserHandle m_hBrowserViewer;

function OnLoad()
{
    SetClosingOnESC();
    m_hIngameNoticeWnd = GetWindowHandle(m_WindowName);
    m_hBrowserViewer = GetWebBrowserHandle(m_WindowName $ ".WebBrowser");
    return;
}

function OnShow()
{
    local string strGetUrl;

    m_hBrowserViewer.ShowWindow();
    strGetUrl = m_hBrowserViewer.GetUrl();
    // End:0x4F
    if((strGetUrl == "") || strGetUrl == "about:blank")
    {
        MainMenuShow();
    }
    return;
}

function OnHide()
{
    LogInternal("-----HideWindow1");
    m_hBrowserViewer.HideWindow();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(5750);
    RegisterEvent(9750);
    RegisterEvent(5752);
    return;
}

function NavigateToPetitionPage()
{
    local UserInfo UserInfo;
    local int serverNo;
    local string cookieKey, lineage2NoticeURL;

    m_hBrowserViewer.BeginParam("UTF-8");
    serverNo = GetServerNo();
    m_hBrowserViewer.PushParam("server_id", string(serverNo));
    GetPlayerInfo(UserInfo);
    m_hBrowserViewer.PushParam("char_name", UserInfo.Name);
    cookieKey = ((UserInfo.Name $ "_") $ string(serverNo)) $ "_not_notice_again";
    // End:0x120
    if(GetINIString("URL", "L2InGameBrowserNoticeURL", lineage2NoticeURL, "l2.ini"))
    {
        // End:0x111
        if(m_hBrowserViewer.GetCookie(lineage2NoticeURL, cookieKey) == "")
        {
            m_hBrowserViewer.NavigateAsPost(lineage2NoticeURL);            
        }
        else
        {
            m_hIngameNoticeWnd.HideWindow();
        }
    }
    return;
}

function MainMenuShow()
{
    local UserInfo UserInfo;
    local int serverNo;
    local string lineage2NoticeURL;

    m_hBrowserViewer.BeginParam("UTF-8");
    serverNo = GetServerNo();
    m_hBrowserViewer.PushParam("server_id", string(serverNo));
    GetPlayerInfo(UserInfo);
    m_hBrowserViewer.PushParam("char_name", UserInfo.Name);
    // End:0xBB
    if(GetINIString("URL", "L2InGameBrowserNoticeURL", lineage2NoticeURL, "l2.ini"))
    {
        m_hBrowserViewer.NavigateAsPost(lineage2NoticeURL);
    }
    return;
}

function IsOpenWnd(string param)
{
    local string Str, URL;

    ParseString(param, "url", URL);
    // End:0x96
    if(URL == m_hBrowserViewer.GetUrl())
    {
        m_hBrowserViewer.ExecuteJavaScriptWithStringResult("getNoticeOpenStatus()", Str);
        // End:0x87
        if(Str == "Y")
        {
            m_hIngameNoticeWnd.ShowWindow();
            m_hIngameNoticeWnd.SetFocus();            
        }
        else
        {
            m_hIngameNoticeWnd.HideWindow();
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x43
        case 5750:
            LogInternal("-----EV_WebBrowser_FinishedLoading");
            IsOpenWnd(param);
            // End:0x6C
            break;
        // End:0x69
        case 9750:
            LogInternal("-----EV_GameStart");
            NavigateToPetitionPage();
            // End:0x6C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    LogInternal("-----HideWindow3");
    GetWindowHandle(m_WindowName).HideWindow();
    Debug("m_WindowName>>>>>>" @ m_WindowName);
    return;
}

defaultproperties
{
    m_WindowName="IngameNoticeWnd"
}