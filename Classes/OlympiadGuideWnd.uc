class OlympiadGuideWnd extends UICommonAPI;

const TIMER_ID = 151;
const TIMER_DELAY = 5000;

var WindowHandle Me;
var ButtonHandle CloseButton;
var TextBoxHandle TitleTextBox;
var TextBoxHandle TextWASD;
var TextBoxHandle TextPageUpDown;
var TextBoxHandle TextRecord;
var TextBoxHandle TextMove;
var TextBoxHandle TextViewPoint;
var TextBoxHandle TextViewMove;
var TextureHandle GroupBg;
var TextureHandle GuideImg;
var bool Open;

function OnRegisterEvent()
{
    RegisterEvent(5030);
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x30
        case 5030:
            Open = true;
            m_hOwnerWnd.SetTimer(151, 5000);
            // End:0x33
            break;
        // End:0xFFFF
        default:
            break;
    }
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
    Me = GetWindowHandle("OlympiadGuideWnd");
    CloseButton = GetButtonHandle("OlympiadGuideWnd.CloseButton");
    TitleTextBox = GetTextBoxHandle("OlympiadGuideWnd.TitleTextBox");
    TextWASD = GetTextBoxHandle("OlympiadGuideWnd.TextWASD");
    TextPageUpDown = GetTextBoxHandle("OlympiadGuideWnd.TextPageUpDown");
    TextRecord = GetTextBoxHandle("OlympiadGuideWnd.TextRecord");
    TextMove = GetTextBoxHandle("OlympiadGuideWnd.TextMove");
    TextViewPoint = GetTextBoxHandle("OlympiadGuideWnd.TextViewPoint");
    TextViewMove = GetTextBoxHandle("OlympiadGuideWnd.TextViewMove");
    GroupBg = GetTextureHandle("OlympiadGuideWnd.GroupBg");
    GuideImg = GetTextureHandle("OlympiadGuideWnd.GuideImg");
    return;
}

function load()
{
    return;
}

function OnShow()
{
    Me.SetFocus();
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x20
        case "CloseButton":
            OpenCloseGuide();
            // End:0x23
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnTimer(int TimerID)
{
    switch(TimerID)
    {
        // End:0x3D
        case 151:
            m_hOwnerWnd.KillTimer(151);
            m_hOwnerWnd.SetAlpha(0, 1000.0000000);
            Open = false;
            // End:0x40
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OpenCloseGuide()
{
    // End:0x2C
    if(Open)
    {
        Me.KillTimer(151);
        Me.HideWindow();        
    }
    else
    {
        Me.SetAlpha(255);
        Me.ShowWindow();
    }
    Open = !Open;
    return;
}

function MysteriousMansionShow()
{
    Open = false;
    Me.KillTimer(151);
    Me.SetAlpha(255);
    Me.ShowWindow();
    return;
}

function MysteriousMansionHide()
{
    Open = true;
    Me.KillTimer(151);
    Me.HideWindow();
    return;
}
