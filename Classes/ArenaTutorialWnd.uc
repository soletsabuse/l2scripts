class ArenaTutorialWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle m_hNPCDialogViewPortWnd;
var WindowHandle m_hViewPortWndMonster;
var HtmlHandle m_hHtmlViewer;
var ViewPortWndMonster m_hViewPortWndMonsterScript;

function OnRegisterEvent()
{
    RegisterEvent(8700);
    RegisterEvent(8701);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    m_hNPCDialogViewPortWnd = GetWindowHandle(m_WindowName);
    m_hHtmlViewer = GetHtmlHandle(m_WindowName $ ".HtmlViewer");
    m_hViewPortWndMonster = GetWindowHandle("ViewPortWndMonster");
    m_hViewPortWndMonsterScript = ViewPortWndMonster(GetScript("ViewPortWndMonster"));
    return;
}

function OnSetFocus(WindowHandle a_WindowHandle, bool IsFocused)
{
    // End:0x18
    if(IsFocused)
    {
        m_hViewPortWndMonster.BringToFront();
    }
    return;
}

function OnShow()
{
    return;
}

function OnHide()
{
    m_hViewPortWndMonster.HideWindow();
    m_hViewPortWndMonster.ClearAnchor();
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x21
        case 8701:
            m_hNPCDialogViewPortWnd.HideWindow();
            // End:0x3A
            break;
        // End:0x37
        case 8700:
            handleHtmlViewPort(param);
            // End:0x3A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function handleHtmlViewPort(string param)
{
    local int Id, Show, SocialAnim, AttackAnim;
    local string htmlStr;

    ParseInt(param, "ID", Id);
    // End:0x32
    if(Id == -1)
    {
        m_hNPCDialogViewPortWnd.HideWindow();
    }
    ParseInt(param, "Show", Show);
    ParseString(param, "HtmlStr", htmlStr);
    LoadHtml(htmlStr);
    ShowWindowWithFocus(m_WindowName);
    m_hViewPortWndMonsterScript.SetNPCViewportData(Id);
    // End:0xA5
    if(Show == 1)
    {
        m_hViewPortWndMonsterScript.SpawnNPC();
    }
    ParseInt(param, "AttackAnim", AttackAnim);
    ParseInt(param, "SocialAnim", SocialAnim);
    m_hViewPortWndMonster.ShowWindow();
    m_hViewPortWndMonster.SetAnchor(m_WindowName, "CenterRight", "CenterLeft", 0, 0);
    m_hViewPortWndMonster.BringToFront();
    // End:0x150
    if(AttackAnim > -1)
    {
        m_hViewPortWndMonsterScript.PlayAnimation(AttackAnim);        
    }
    else
    {
        // End:0x173
        if(SocialAnim > -1)
        {
            m_hViewPortWndMonsterScript.PlayAnimation(SocialAnim);
        }
    }
    return;
}

function LoadHtml(string param)
{
    m_hHtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(param));
    m_hNPCDialogViewPortWnd.SetFocus();
    return;
}

function string htmlSetHtmlStart(string targetHtml)
{
    return ("<html><body>" $ targetHtml) $ "</body></html>";
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    m_hNPCDialogViewPortWnd.HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="ArenaTutorialWnd"
}