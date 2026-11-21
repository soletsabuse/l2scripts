class EventMatchGMFenceWnd extends UICommonAPI;

var ButtonHandle m_hOKButton;
var ButtonHandle m_hCancelButton;
var ButtonHandle m_hMyLocationButton;
var EditBoxHandle m_hXEditBox;
var EditBoxHandle m_hYEditBox;
var EditBoxHandle m_hZEditBox;
var EditBoxHandle m_hXLengthEditBox;
var EditBoxHandle m_hYLengthEditBox;

function OnRegisterEvent()
{
    RegisterEvent(2180);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x107
    if(1 == 0)
    {
        m_hOKButton = ButtonHandle(GetHandle("OKButton"));
        m_hCancelButton = ButtonHandle(GetHandle("CancelButton"));
        m_hMyLocationButton = ButtonHandle(GetHandle("MyLocationButton"));
        m_hXEditBox = EditBoxHandle(GetHandle("XEditBox"));
        m_hYEditBox = EditBoxHandle(GetHandle("YEditBox"));
        m_hZEditBox = EditBoxHandle(GetHandle("ZEditBox"));
        m_hXLengthEditBox = EditBoxHandle(GetHandle("XLengthEditBox"));
        m_hYLengthEditBox = EditBoxHandle(GetHandle("YLengthEditBox"));        
    }
    else
    {
        m_hOKButton = GetButtonHandle("EventMatchGMFenceWnd.OKButton");
        m_hCancelButton = GetButtonHandle("EventMatchGMFenceWnd.CancelButton");
        m_hMyLocationButton = GetButtonHandle("EventMatchGMFenceWnd.MyLocationButton");
        m_hXEditBox = GetEditBoxHandle("EventMatchGMFenceWnd.XEditBox");
        m_hYEditBox = GetEditBoxHandle("EventMatchGMFenceWnd.YEditBox");
        m_hZEditBox = GetEditBoxHandle("EventMatchGMFenceWnd.ZEditBox");
        m_hXLengthEditBox = GetEditBoxHandle("EventMatchGMFenceWnd.XLengthEditBox");
        m_hYLengthEditBox = GetEditBoxHandle("EventMatchGMFenceWnd.YLengthEditBox");
    }
    return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
    switch(a_ButtonHandle)
    {
        // End:0x18
        case m_hOKButton:
            OnClickOKButton();
            // End:0x3D
            break;
        // End:0x29
        case m_hCancelButton:
            OnClickCancelButton();
            // End:0x3D
            break;
        // End:0x3A
        case m_hMyLocationButton:
            OnClickMyLocationButton();
            // End:0x3D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickOKButton()
{
    local int XLength, YLength;
    local Vector Position;
    local EventMatchGMWnd GMWndScript;

    XLength = int(m_hXLengthEditBox.GetString());
    // End:0x50
    if(!(100 <= XLength) && 5000 > XLength)
    {
        DialogShow(1, 5, GetSystemMessage(1414), string(self));
        return;
    }
    YLength = int(m_hYLengthEditBox.GetString());
    // End:0xA0
    if(!(100 <= YLength) && 5000 > YLength)
    {
        DialogShow(1, 5, GetSystemMessage(1414), string(self));
        return;
    }
    Position.X = float(int(m_hXEditBox.GetString()));
    Position.Y = float(int(m_hYEditBox.GetString()));
    Position.Z = float(int(m_hZEditBox.GetString()));
    m_hOwnerWnd.HideWindow();
    GMWndScript = EventMatchGMWnd(GetScript("EventMatchGMWnd"));
    // End:0x154
    if(GMWndScript != none)
    {
        GMWndScript.NotifyFenceInfo(Position, XLength, YLength);
    }
    return;
}

function OnClickCancelButton()
{
    m_hOwnerWnd.HideWindow();
    return;
}

function OnClickMyLocationButton()
{
    local Vector PlayerPosition;

    PlayerPosition = GetPlayerPosition();
    m_hXEditBox.SetString(string(int(PlayerPosition.X)));
    m_hYEditBox.SetString(string(int(PlayerPosition.Y)));
    m_hZEditBox.SetString(string(int(PlayerPosition.Z)));
    return;
}
