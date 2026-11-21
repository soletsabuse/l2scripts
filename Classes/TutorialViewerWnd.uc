class TutorialViewerWnd extends UICommonAPI;

var HtmlHandle m_hTutorialViewerWndHtmlTutorialViewer;

function OnRegisterEvent()
{
    RegisterEvent(2430);
    RegisterEvent(2440);
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
    m_hTutorialViewerWndHtmlTutorialViewer = GetHtmlHandle("TutorialViewerWnd.HtmlTutorialViewer");
    return;
}

function OnShow()
{
    PlayConsoleSound(5);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string HtmlString;
    local int ViewerType;

    switch(Event_ID)
    {
        // End:0x9C
        case 2430:
            ParseString(param, "HtmlString", HtmlString);
            ParseInt(param, "ViewerType", ViewerType);
            // End:0x99
            if(ViewerType == 1)
            {
                m_hTutorialViewerWndHtmlTutorialViewer.SetWindowTitle(GetSystemString(448));
                m_hTutorialViewerWndHtmlTutorialViewer.LoadHtmlFromString(HtmlString);
                ShowWindowWithFocus("TutorialViewerWnd");
            }
            // End:0xC3
            break;
        // End:0xC0
        case 2440:
            HideWindow("TutorialViewerWnd");
            // End:0xC3
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
    GetWindowHandle("TutorialViewerWnd").HideWindow();
    return;
}
