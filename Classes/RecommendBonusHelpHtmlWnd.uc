class RecommendBonusHelpHtmlWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle texBack;
var HtmlHandle htmlViewerRecommendBonusHelp;

function OnRegisterEvent()
{
    RegisterEvent(4941);
    return;
}

function OnLoad()
{
    OnRegisterEvent();
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("RecommendBonusHelpHtmlWnd");
    texBack = GetTextureHandle("RecommendBonusHelpHtmlWnd.texBack");
    htmlViewerRecommendBonusHelp = GetHtmlHandle("RecommendBonusHelpHtmlWnd.htmlViewerRecommendBonusHelp");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x18
        case 4941:
            OnShow();
            // End:0x1B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnShow()
{
    ShowHelp("..\\L2text\\event_2010_bless001.htm");
    return;
}

function ShowHelp(string strPath)
{
    // End:0x3F
    if(Len(strPath) > 0)
    {
        htmlViewerRecommendBonusHelp.LoadHtml(strPath);
        Me.ShowWindow();
        Me.SetFocus();
    }
    return;
}
