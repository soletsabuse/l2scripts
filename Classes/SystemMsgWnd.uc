class SystemMsgWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle m_hChatWnd;
var TextureHandle m_hdBodyTex;

function OnRegisterEvent()
{
    RegisterEvent(150);
    RegisterEvent(555);
    RegisterEvent(2900);
    return;
}

function OnLoad()
{
    Me = GetWindowHandle("SystemMsgWnd");
    Me.EnableDynamicAlpha(true);
    m_hChatWnd = GetWindowHandle("ChatWnd");
    m_hdBodyTex = GetTextureHandle("SystemMsgWnd.BackTexture");
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local int tempVal;

    switch(a_EventID)
    {
        // End:0x88
        case 150:
            GetINIBool("global", "SystemMsgWnd", tempVal, "chatfilter.ini");
            // End:0x68
            if(tempVal != 0)
            {
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");                
            }
            else
            {
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
            }
            // End:0xB5
            break;
        // End:0x9E
        case 555:
            Resize(a_Param);
            // End:0xB5
            break;
        // End:0xAF
        case 2900:
            UpdateResolution();
            // End:0xB5
            break;
        // End:0xFFFF
        default:
            // End:0xB5
            break;
            break;
    }
    return;
}

function SetDefaultAlpha(int Type)
{
    // End:0x24
    if(Type == 0)
    {
        m_hdBodyTex.SetAlpha(255, 0.0000000);        
    }
    else
    {
        m_hdBodyTex.SetAlpha(50, 0.0000000);
    }
    return;
}

function OnMouseOver(WindowHandle W)
{
    local ChatWnd script;

    script = ChatWnd(GetScript("ChatWnd"));
    // End:0x44
    if(script.m_UseAlpha == 1)
    {
        m_hdBodyTex.SetAlpha(255, 0.5000000);
    }
    return;
}

function OnMouseOut(WindowHandle W)
{
    local ChatWnd script;

    script = ChatWnd(GetScript("ChatWnd"));
    // End:0x44
    if(script.m_UseAlpha == 1)
    {
        m_hdBodyTex.SetAlpha(50, 0.5000000);
    }
    return;
}

function UpdateResolution()
{
    local int CurrentMaxWidth, CurrentMaxHeight, CurrentChatWidth, CurrentChatHeight;

    GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
    m_hChatWnd.GetWindowSize(CurrentChatWidth, CurrentChatHeight);
    // End:0x7F
    if((CurrentChatWidth > CurrentMaxWidth) || CurrentChatHeight > (CurrentMaxHeight - 15))
    {
        Me.GetWindowSize(CurrentChatWidth, CurrentChatHeight);
        Me.SetWindowSize(348, CurrentChatHeight);
    }
    return;
}

function Resize(string param)
{
    local int W, resizeWidth, h;

    ParseInt(param, "Width", resizeWidth);
    Me.GetWindowSize(W, h);
    Me.SetWindowSize(resizeWidth, h);
    return;
}

function OnShow()
{
    local int useAlpha, tempVal, W, h, sizeW;

    local string showWndParam;

    // End:0x3B
    if(GetINIBool("global", "UseAlpha", tempVal, "chatfilter.ini"))
    {
        useAlpha = tempVal;
    }
    // End:0x50
    if(useAlpha == 0)
    {
        SetDefaultAlpha(0);        
    }
    else
    {
        SetDefaultAlpha(1);
    }
    Me.GetWindowSize(W, h);
    // End:0xC1
    if(GetINIInt("global", "ChatSizeWidth", sizeW, "chatfilter.ini"))
    {
        Me.SetWindowSize(sizeW, h);        
    }
    else
    {
        Me.SetWindowSize(W, h);
    }
    Me.SetResizeFrameOffset(348, h);
    ChangeAnchorEffectButton("SystemMsgWnd");
    ParamAdd(showWndParam, "visible", string(1));
    // End:0x186
    if(GetINIBool("global", "UseWorldChatSpeaker", tempVal, "chatfilter.ini"))
    {
        CallGFxFunction("worldChatBox", "IsShowSystemMsgWnd", showWndParam);
    }
    CallGFxFunction("UserAlertMessage", "IsShowSystemMsgWnd", showWndParam);
    return;
}

function OnHide()
{
    local string showWndParam;

    ChangeAnchorEffectButton("ChatWnd");
    ParamAdd(showWndParam, "visible", string(0));
    CallGFxFunction("worldChatBox", "IsShowSystemMsgWnd", showWndParam);
    CallGFxFunction("UserAlertMessage", "IsShowSystemMsgWnd", showWndParam);
    return;
}

function ChangeAnchorEffectButton(string strID)
{
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("TutorialBtnWnd", strID, "TopLeft", "BottomLeft", 5, -5);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("QuestBtnWnd", strID, "TopLeft", "BottomLeft", 42, -5);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("MailBtnWnd", strID, "TopLeft", "BottomLeft", 79, -5);
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("BirthdayAlarmBtn", strID, "TopLeft", "BottomLeft", 42, -37);
    return;
}
