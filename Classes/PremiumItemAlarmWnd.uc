class PremiumItemAlarmWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle CTextureCtrl1038;
var TextBoxHandle CTextBox1039;
var ButtonHandle btnOk;

function OnLoad()
{
    Initialize();
    load();
    return;
}

function Initialize()
{
    // End:0xB2
    if(1 == 0)
    {
        Me = GetHandle("PremiumItemAlarmWnd");
        CTextureCtrl1038 = TextureHandle(GetHandle("CFrameWnd461.CTextureCtrl1038"));
        CTextBox1039 = TextBoxHandle(GetHandle("CFrameWnd461.CTextBox1039"));
        btnOk = ButtonHandle(GetHandle("CFrameWnd461.CButton1414"));        
    }
    else
    {
        Me = GetWindowHandle("PremiumItemAlarmWnd");
        CTextureCtrl1038 = GetTextureHandle("CFrameWnd461.CTextureCtrl1038");
        CTextBox1039 = GetTextBoxHandle("CFrameWnd461.CTextBox1039");
        btnOk = GetButtonHandle("CFrameWnd461.CButton1414");
    }
    return;
}

function load()
{
    return;
}

function OnEvent(int Event_ID, string param)
{
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x23
        case "btnOK":
            Me.HideWindow();
            // End:0x26
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnExitState(name a_NextStateName)
{
    Me.HideWindow();
    return;
}
