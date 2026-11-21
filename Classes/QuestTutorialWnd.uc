class QuestTutorialWnd extends UICommonAPI;

var HtmlHandle m_hQuestTutorialViewerWndHtmlQuestTutorialViewer;
var int Index;

function OnRegisterEvent()
{
    RegisterEvent(2430);
    RegisterEvent(2440);
    RegisterEvent(2431);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    m_hQuestTutorialViewerWndHtmlQuestTutorialViewer = GetHtmlHandle("QuestTutorialWnd.HtmlViewer");
    return;
}

function OnClickButton(string a_ButtonID)
{
    switch(a_ButtonID)
    {
        // End:0x1D
        case "CloseBtn":
            HandleCloseBtn();
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleCloseBtn()
{
    HideWindow("QuestTutorialWnd");
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string HtmlFile;
    local int ViewerType;

    switch(Event_ID)
    {
        // End:0x80
        case 2431:
            ParseString(param, "HtmlFile", HtmlFile);
            ParseInt(param, "ViewerType", ViewerType);
            // End:0x7D
            if(ViewerType == 2)
            {
                m_hQuestTutorialViewerWndHtmlQuestTutorialViewer.LoadHtml(HtmlFile);
                ShowWindowWithFocus("QuestTutorialWnd");
            }
            // End:0xA6
            break;
        // End:0xA3
        case 2440:
            HideWindow("QuestTutorialWnd");
            // End:0xA6
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
    // End:0x3A
    if(int(Key) == int(27))
    {
        PlayConsoleSound(6);
        GetWindowHandle("QuestTutorialWnd").HideWindow();
    }
    return;
}
