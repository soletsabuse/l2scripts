class WebPetitionWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle m_hPetitionWnd;
var WebBrowserHandle m_hBrowserViewer;
var EditBoxHandle ChatEditBox;

function OnRegisterEvent()
{
    RegisterEvent(9450);
    RegisterEvent(9451);
    return;
}

function OnLoad()
{
    m_hPetitionWnd = GetWindowHandle(m_WindowName);
    m_hBrowserViewer = GetWebBrowserHandle(m_WindowName $ ".WebBrowser");
    ChatEditBox = GetEditBoxHandle("ChatWnd.ChatEditBox");
    return;
}

function OnShow()
{
    m_hBrowserViewer.ShowWindow();
    // End:0x4C
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("IngameWebWnd"))
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("IngameWebWnd");
    }
    return;
}

function OnHide()
{
    m_hBrowserViewer.HideWindow();
    return;
}

function NavigateToPetitionPage(string additionalURL)
{
    local UserInfo UserInfo;
    local int serverNo;
    local string lineage2PetitionURL;
    local int lineage2PetitionID;
    local string strNpLoginWebURL;
    local WebRequestInfo requestInfo;

    // End:0x19C
    if(GetINIString("URL", "L2InGameBrowserPetitionURL", lineage2PetitionURL, "l2.ini"))
    {
        // End:0x19C
        if(GetINIString("URL", "NPLoginWebURL", strNpLoginWebURL, "l2.ini"))
        {
            lineage2PetitionID = 32;
            serverNo = GetServerNo();
            GetPlayerInfo(UserInfo);
            requestInfo.eMethodType = 0;
            requestInfo.strRequestUrl = (lineage2PetitionURL $ "/") $ additionalURL;
            requestInfo.strNPAuthTokenLoginUrl = strNpLoginWebURL $ "/sso";
            requestInfo.arrRequestParams.Length = 3;
            requestInfo.arrRequestParams[0].strKey = "target";
            requestInfo.arrRequestParams[0].strValue = string(lineage2PetitionID);
            requestInfo.arrRequestParams[1].strKey = "server_id";
            requestInfo.arrRequestParams[1].strValue = string(serverNo);
            requestInfo.arrRequestParams[2].bNeedUrlEncode = true;
            requestInfo.arrRequestParams[2].strKey = "char_name";
            requestInfo.arrRequestParams[2].strValue = UserInfo.Name;
            m_hBrowserViewer.Navigate(requestInfo);
        }
    }
    return;
}

function HandleShowWebPetitionMainPage()
{
    ChatEditBox.ReleaseFocus();
    m_hPetitionWnd.ShowWindow();
    m_hPetitionWnd.SetFocus();
    NavigateToPetitionPage("main");
    return;
}

function HandleShowWebPetitionListPage()
{
    m_hPetitionWnd.ShowWindow();
    m_hPetitionWnd.SetFocus();
    NavigateToPetitionPage("list");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x18
        case 9450:
            HandleShowWebPetitionMainPage();
            // End:0x2C
            break;
        // End:0x29
        case 9451:
            HandleShowWebPetitionListPage();
            // End:0x2C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

defaultproperties
{
    m_WindowName="WebPetitionWnd"
}