class XMasSealWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle m_hXMasSealWnd;
var TextureHandle m_hTexItem;

function OnRegisterEvent()
{
    RegisterEvent(3330);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x4A
    if(1 == 0)
    {
        m_hXMasSealWnd = GetHandle(m_WindowName);
        m_hTexItem = TextureHandle(GetHandle(m_WindowName $ ".texItem"));        
    }
    else
    {
        m_hXMasSealWnd = GetWindowHandle(m_WindowName);
        m_hTexItem = GetTextureHandle(m_WindowName $ ".texItem");
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 3330:
            HandleToggleXMasSealWndShowHide(param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleToggleXMasSealWndShowHide(string param)
{
    local ItemID Id;
    local string TextureName;

    ParseItemID(param, Id);
    TextureName = Class'NWindow.UIDATA_ITEM'.static.GetEtcItemTextureName(Id);
    m_hTexItem.SetTexture(TextureName);
    // End:0x62
    if(m_hXMasSealWnd.IsShowWindow())
    {
        m_hXMasSealWnd.HideWindow();        
    }
    else
    {
        m_hXMasSealWnd.ShowWindow();
        m_hXMasSealWnd.SetFocus();
    }
    return;
}

defaultproperties
{
    m_WindowName="XMasSealWnd"
}