class BR_EventHtmlWndC extends UICommonAPI;

var WindowHandle Me;
var HtmlHandle HtmlViewer;

function OnRegisterEvent()
{
    RegisterEvent(9113);
    return;
}

function OnLoad()
{
    Initialize();
    load();
    return;
}

function Initialize()
{
    // End:0x57
    if(1 == 0)
    {
        Me = GetHandle("BR_EventHtmlWndC");
        HtmlViewer = HtmlHandle(GetHandle("BR_EventHtmlWndC.HtmlViewer3"));        
    }
    else
    {
        Me = GetWindowHandle("BR_EventHtmlWndC");
        HtmlViewer = GetHtmlHandle("BR_EventHtmlWndC.HtmlViewer3");
    }
    return;
}

function load()
{
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1A
    if(Event_ID == 9113)
    {
        ShowEventHtml(param);
    }
    return;
}

function ShowEventHtml(string param)
{
    local string strPath, strTitle;

    ParseString(param, "FilePath", strPath);
    ParseString(param, "Title", strTitle);
    // End:0x52
    if(Len(strPath) > 0)
    {
        HtmlViewer.LoadHtml(strPath);
    }
    Me.SetWindowTitle(strTitle);
    return;
}
