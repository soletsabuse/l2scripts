class CharacterPasswordHelpHtmlWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle texBack;
var HtmlHandle htmlViewerCharacterPasswordHelp;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("CharacterPasswordHelpHtmlWnd");
    texBack = GetTextureHandle("CharacterPasswordHelpHtmlWnd.texBack");
    htmlViewerCharacterPasswordHelp = GetHtmlHandle("CharacterPasswordHelpHtmlWnd.htmlViewerCharacterPasswordHelp");
    return;
}

function OnEvent(int Event_ID, string param)
{
    return;
}

function OnShow()
{
    ShowHelp("..\\L2text\\help_characterpassword00.htm");
    return;
}

function ShowHelp(string strPath)
{
    // End:0x3F
    if(Len(strPath) > 0)
    {
        htmlViewerCharacterPasswordHelp.LoadHtml(strPath);
        Me.ShowWindow();
        Me.SetFocus();
    }
    return;
}
