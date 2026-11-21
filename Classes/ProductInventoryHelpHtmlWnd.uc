class ProductInventoryHelpHtmlWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle texBack;
var HtmlHandle htmlViewerProductInventoryHelp;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    load();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("ProductInventoryHelpHtmlWnd");
    texBack = GetTextureHandle("ProductInventoryHelpHtmlWnd.texBack");
    htmlViewerProductInventoryHelp = GetHtmlHandle("ProductInventoryHelpHtmlWnd.htmlViewerProductInventoryHelp");
    return;
}

function OnShow()
{
    ShowHelp("..\\L2text\\product_inventory_help00.htm");
    return;
}

function load()
{
    return;
}

function ShowHelp(string strPath)
{
    // End:0x3F
    if(Len(strPath) > 0)
    {
        htmlViewerProductInventoryHelp.LoadHtml(strPath);
        Me.ShowWindow();
        Me.SetFocus();
    }
    return;
}

function OnReceivedCloseUI()
{
    Me.HideWindow();
    return;
}
