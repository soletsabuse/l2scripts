class BR_PathWnd extends UICommonAPI;

const N_MAX_WEB_RES_X = 1024;
const N_MAX_WEB_RES_Y = 1024;
const N_BUTTON_HEAD_AREA_BUFFER = 75;

var string m_WindowName;
var WindowHandle m_hPathWnd;
var WebBrowserHandle m_hBrowserViewer;
var EditBoxHandle ChatEditBox;
var bool m_firstOpen;

function OnRegisterEvent()
{
    RegisterEvent(10010);
    RegisterEvent(10011);
    RegisterEvent(10012);
    RegisterEvent(2900);
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
        m_hPathWnd = GetHandle(m_WindowName);
        m_hBrowserViewer = WebBrowserHandle(GetHandle(m_WindowName $ ".WebBrowser"));        
    }
    else
    {
        m_hPathWnd = GetWindowHandle(m_WindowName);
        m_hBrowserViewer = GetWebBrowserHandle(m_WindowName $ ".WebBrowser");
    }
    m_firstOpen = false;
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

function NavigateToPathPage(string additionalURL)
{
    local string lineage2PathMapURL;
    local WebRequestInfo requestInfo;

    requestInfo.eMethodType = 1;
    // End:0x66
    if(additionalURL == "main")
    {
        // End:0x63
        if(GetINIString("URL", "L2InGameBrowserPathMapURL", lineage2PathMapURL, "l2.ini"))
        {
            requestInfo.strRequestUrl = lineage2PathMapURL;
        }        
    }
    else
    {
        requestInfo.strRequestUrl = additionalURL;
    }
    m_hBrowserViewer.Navigate(requestInfo);
    return;
}

function HandleShowWebPathMapMainPage(string param)
{
    local string URL;

    ParseString(param, "Message", URL);
    // End:0x31
    if(URL == "")
    {
        URL = "main";
    }
    // End:0x4B
    if(m_firstOpen == false)
    {
        m_firstOpen = true;
        CheckResolution();
    }
    ChatEditBox.ReleaseFocus();
    m_hPathWnd.ShowWindow();
    m_hPathWnd.SetFocus();
    NavigateToPathPage(URL);
    return;
}

function HandleShowWebPathMapListPage()
{
    m_hPathWnd.ShowWindow();
    m_hPathWnd.SetFocus();
    NavigateToPathPage("list");
    return;
}

function HandleShowWebPathAlarm(string param)
{
    local int PathToAwakeningAlarmType, PathToAwakeningAlarmValue;

    PathToAwakeningAlarmType = 0;
    PathToAwakeningAlarmValue = 0;
    m_hPathWnd.ShowWindow();
    m_hPathWnd.SetFocus();
    ParseInt(param, "Type", PathToAwakeningAlarmType);
    ParseInt(param, "Value", PathToAwakeningAlarmValue);
    Debug(((" ShowWebPathAlarm Type" @ string(PathToAwakeningAlarmType)) @ "Value") @ string(PathToAwakeningAlarmValue));
    NavigateToPathPage("list");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 10010:
            HandleShowWebPathMapMainPage(param);
            // End:0x5D
            break;
        // End:0x2E
        case 10011:
            HandleShowWebPathMapListPage();
            // End:0x5D
            break;
        // End:0x44
        case 10012:
            HandleShowWebPathAlarm(param);
            // End:0x5D
            break;
        // End:0x5A
        case 2900:
            HandleResolutionChanged(param);
            // End:0x5D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x25
        case "HomeButton":
            NavigateToPathPage("main");
            // End:0x28
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleResolutionChanged(string aParam)
{
    local int NewWidth, NewHeight;

    ParseInt(aParam, "NewWidth", NewWidth);
    ParseInt(aParam, "NewHeight", NewHeight);
    // End:0x4F
    if((NewWidth <= 0) || NewHeight <= 0)
    {
        return;
    }
    ResetWebSize(NewWidth, NewHeight);
    return;
}

function CheckResolution()
{
    local int CurrentMaxWidth, CurrentMaxHeight;

    GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
    ResetWebSize(CurrentMaxWidth, CurrentMaxHeight);
    return;
}

function ResetWebSize(int CurrentWidth, int CurrentHeight)
{
    local int adjustedwidth, adjustedheight, MainMapWidth, MainMapHeight;

    MainMapWidth = CurrentWidth;
    MainMapHeight = CurrentHeight;
    adjustedwidth = CurrentWidth - 19;
    adjustedheight = (CurrentHeight - 75) - 5;
    // End:0x61
    if(CurrentWidth > 1024)
    {
        adjustedwidth = 1024 - 19;
        MainMapWidth = 1024;
    }
    // End:0x8A
    if(CurrentHeight > 1024)
    {
        adjustedheight = 1024 - 75;
        MainMapHeight = 1024;
    }
    m_hPathWnd.SetWindowSize(MainMapWidth + 2, MainMapHeight - 2);
    m_hBrowserViewer.SetWindowSize(adjustedwidth + 2, adjustedheight - 2);
    return;
}

defaultproperties
{
    m_WindowName="BR_PathWnd"
}