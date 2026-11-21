class IngameWebWnd extends UICommonAPI;

const LINEAGE2_WEB_ID = 32;
const TIMER_ID_WEB_SESSION = 8989;
const INGAMEWEB_SECTION_CLASSIC = "IngameWeb_Classic";
const INGAMEWEB_SECTION_LIVE = "IngameWeb_Live";
const REFRESH_WEB_SESSION_TIME = 2400000;

var string m_WindowName;
var WindowHandle m_hIngameWebWnd;
var WebBrowserHandle m_hBrowserViewer;
var WebBrowserHandle m_hBrowserForSessionRefresh;
var bool m_bCheckFinishPageForSession;
var string m_strRequestURL;
var string lastShowCategory;

function OnLoad()
{
    SetClosingOnESC();
    m_hIngameWebWnd = GetWindowHandle(m_WindowName);
    m_hBrowserViewer = GetWebBrowserHandle(m_WindowName $ ".WebBrowser");
    m_hBrowserForSessionRefresh = GetWebBrowserHandle(m_WindowName $ ".WebBrowserForSession");
    m_hBrowserForSessionRefresh.HideWindow();
    m_bCheckFinishPageForSession = false;
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(5750);
    RegisterEvent(10120);
    RegisterEvent(10140);
    RegisterEvent(5751);
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 5750:
            OnWebBrowser_FinishedLoading(param);
            // End:0xA6
            break;
        // End:0x48
        case 10120:
            // End:0x45
            if(!getInstanceUIData().getIsArenaServer())
            {
                NavigatePage(param);
            }
            // End:0xA6
            break;
        // End:0x7D
        case 10140:
            getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
            m_hIngameWebWnd.HideWindow();
            // End:0xA6
            break;
        // End:0x93
        case 5751:
            OnWebBrowser_ReceivedTitle(param);
            // End:0xA6
            break;
        // End:0xA3
        case 40:
            lastShowCategory = "";
            // End:0xA6
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function NavigatePage(string param)
{
    local string Category, Message, strURL;

    ParseString(param, "Category", Category);
    ParseString(param, "Message", Message);
    // End:0x50
    if(Category == "url")
    {
        NavigateUrlPage(Message);        
    }
    else
    {
        // End:0x72
        if(Category == "test_url")
        {
            NavigateUrlPageWithoutNPToken(Message);            
        }
        else
        {
            // End:0x94
            if(Category == "check_session")
            {
                TestCheckSession();                
            }
            else
            {
                // End:0xD2
                if((lastShowCategory == Category) && IsShowWindow("InGameWebWnd"))
                {
                    HideWindow("InGameWebWnd");
                    return;
                }
                // End:0xFB
                if(GetUrlPageAtL2INI(Category, strURL))
                {
                    lastShowCategory = Category;
                    NavigateUrlPage(strURL);
                }
            }
        }
    }
    return;
}

function string GetParameterForNPSession(string strURL, out array<WebRequestParam> arrParams)
{
    local UserInfo UserInfo;
    local int serverNo, lineage2WebID;
    local string strExtraParam;
    local int nStrIndex, nArrayIndex;
    local string strKey, strValue;

    nStrIndex = InStr(strURL, "?");
    // End:0x42
    if(nStrIndex > 0)
    {
        strExtraParam = Mid(strURL, nStrIndex + 1);
        strURL = Left(strURL, nStrIndex);
    }
    lineage2WebID = 32;
    serverNo = GetServerNo();
    GetPlayerInfo(UserInfo);
    nArrayIndex = arrParams.Length;
    arrParams.Insert(nArrayIndex, 1);
    arrParams[nArrayIndex].strKey = "target";
    arrParams[nArrayIndex].strValue = string(lineage2WebID);
    nArrayIndex++;
    arrParams.Insert(nArrayIndex, 1);
    arrParams[nArrayIndex].strKey = "server_id";
    arrParams[nArrayIndex].strValue = string(serverNo);
    nArrayIndex++;
    arrParams.Insert(nArrayIndex, 1);
    arrParams[nArrayIndex].bNeedUrlEncode = true;
    arrParams[nArrayIndex].strKey = "char_name";
    arrParams[nArrayIndex].strValue = UserInfo.Name;
    nArrayIndex++;
    // End:0x246
    if(Len(strExtraParam) > 0)
    {
        nStrIndex = InStr(strExtraParam, "=");
        J0x172:

        // End:0x246 [Loop If]
        if(nStrIndex > 0)
        {
            strKey = Left(strExtraParam, nStrIndex);
            strExtraParam = Mid(strExtraParam, nStrIndex + 1);
            nStrIndex = InStr(strExtraParam, "&");
            // End:0x1E9
            if(nStrIndex > 0)
            {
                strValue = Left(strExtraParam, nStrIndex);
                strExtraParam = Mid(strExtraParam, nStrIndex + 1);                
            }
            else
            {
                strValue = strExtraParam;
            }
            arrParams.Insert(nArrayIndex, 1);
            arrParams[nArrayIndex].strKey = strKey;
            arrParams[nArrayIndex].strValue = strValue;
            nArrayIndex++;
            nStrIndex = InStr(strExtraParam, "=");
            // [Loop Continue]
            goto J0x172;
        }
    }
    return strURL;
    return;
}

function CloseAnotherWebWnd()
{
    return;
}

function bool GetUrlPageAtL2INI(string Category, out string outURL)
{
    local string strSection;

    // End:0x2F
    if(getInstanceUIData().getIsClassicServer())
    {
        strSection = "IngameWeb_Classic";        
    }
    else
    {
        strSection = "IngameWeb_Live";
    }
    // End:0x67
    if(GetINIString(strSection, Category, outURL, "l2.ini"))
    {
        return true;
    }
    return false;
    return;
}

function NavigateUrlPage(string strURL)
{
    local string strNpLoginWebURL;
    local WebRequestInfo requestInfo;

    // End:0x26
    if(IsPlayerOnWorldRaidServer())
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
        return;
    }
    m_hIngameWebWnd.ShowWindow();
    m_hIngameWebWnd.SetFocus();
    Debug("[InGameWebWnd]NavigateUrlPage URL :" @ strURL);
    // End:0x16D
    if(GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini"))
    {
        CloseAnotherWebWnd();
        m_bCheckFinishPageForSession = true;
        m_hIngameWebWnd.KillTimer(8989);
        requestInfo.eMethodType = 0;
        requestInfo.strRequestUrl = GetParameterForNPSession(strURL, requestInfo.arrRequestParams);
        requestInfo.strNPAuthTokenLoginUrl = strNpLoginWebURL $ "/sso";
        requestInfo.arrHeaderParams.Length = 1;
        requestInfo.arrHeaderParams[0].strKey = "User-Agent";
        requestInfo.arrHeaderParams[0].strValue = "Lineage2";
        m_hBrowserViewer.Navigate(requestInfo);
        m_strRequestURL = strURL;
    }
    return;
}

function NavigateUrlPageWithoutNPToken(string strURL)
{
    local WebRequestInfo requestInfo;

    m_hIngameWebWnd.ShowWindow();
    Debug("[InGameWebWnd]NavigateUrlPageWithoutNPToken URL :" @ strURL);
    requestInfo.eMethodType = 0;
    requestInfo.strRequestUrl = strURL;
    requestInfo.arrHeaderParams.Length = 1;
    requestInfo.arrHeaderParams[0].strKey = "User-Agent";
    requestInfo.arrHeaderParams[0].strValue = "Lineage2";
    m_hBrowserViewer.Navigate(requestInfo);
    m_strRequestURL = strURL;
    return;
}

function bool TestCheckSession()
{
    local WebRequestInfo requestInfo;

    requestInfo.eMethodType = 0;
    requestInfo.strRequestUrl = "http://dev.mlogin.plaync.com/test/ingamesso";
    m_hBrowserViewer.Navigate(requestInfo);
    Debug("[InGameWebWnd]TestCheckSession");
    return true;
    return;
}

function bool RefreshWebSession()
{
    local string strNpLoginWebURL;
    local WebRequestInfo requestInfo;

    // End:0xFA
    if(GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini"))
    {
        requestInfo.eMethodType = 0;
        requestInfo.strRequestUrl = strNpLoginWebURL $ "/check";
        requestInfo.arrRequestParams.Length = 1;
        requestInfo.arrRequestParams[0].strKey = "return_url";
        requestInfo.arrRequestParams[0].strValue = "about:blank";
        requestInfo.arrHeaderParams.Length = 1;
        requestInfo.arrHeaderParams[0].strKey = "Accept";
        requestInfo.arrHeaderParams[0].strValue = "application/json";
        m_hBrowserForSessionRefresh.Navigate(requestInfo);
    }
    Debug("[InGameWebWnd]RefreshWebSession");
    return true;
    return;
}

function OnHide()
{
    m_hIngameWebWnd.KillTimer(8989);
    m_bCheckFinishPageForSession = false;
    lastShowCategory = "";
    m_hBrowserViewer.HideWindow();
    m_hBrowserForSessionRefresh.HideWindow();
    return;
}

function OnTimer(int TimerID)
{
    // End:0x42
    if(TimerID == 8989)
    {
        RefreshWebSession();
        m_hIngameWebWnd.KillTimer(8989);
        m_hIngameWebWnd.SetTimer(8989, 2400000);
    }
    return;
}

function OnWebBrowser_FinishedLoading(string param)
{
    local string URL, strNpLoginWebURL;
    local int Index;

    ParseString(param, "url", URL);
    // End:0x9C
    if(m_bCheckFinishPageForSession && GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini"))
    {
        Index = InStr(URL, m_strRequestURL);
        // End:0x9C
        if(Index >= 0)
        {
            m_hIngameWebWnd.KillTimer(8989);
            m_hIngameWebWnd.SetTimer(8989, 2400000);
            m_bCheckFinishPageForSession = false;
        }
    }
    Debug(("[InGameWebWnd]EV_WebBrowser_FinishedLoading >> " @ URL) @ string(m_bCheckFinishPageForSession));
    Debug("[InGameWebWnd]EV_WebBrowser_FinishedLoading >> GetURL" @ m_hBrowserViewer.GetUrl());
    return;
}

function OnWebBrowser_ReceivedTitle(string param)
{
    local string WindowName, Title;

    ParseString(param, "WindowName", WindowName);
    ParseString(param, "Title", Title);
    // End:0x71
    if((InStr(WindowName, "IngameWebWnd") >= 0) && Len(Title) > 0)
    {
        m_hIngameWebWnd.SetWindowTitle(Title);
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    Debug("m_WindowName>>>>>>" @ m_WindowName);
    return;
}

function OnShow()
{
    // End:0x41
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("WebPetitionWnd"))
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("WebPetitionWnd");
    }
    m_hBrowserViewer.ShowWindow();
    return;
}

defaultproperties
{
    m_WindowName="IngameWebWnd"
}