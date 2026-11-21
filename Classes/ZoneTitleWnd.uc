class ZoneTitleWnd extends UICommonAPI;

const StartZoneNameX = 100;
const StartZoneNameY = 80;
const TIMER_ID = 0;
const TIMER_DELAY = 4000;

var string m_WindowName;
var WindowHandle m_hZoneTitleWnd;
var TextBoxHandle m_hTbZoneNameBack;
var TextBoxHandle m_hTbZoneNameFront;

function OnRegisterEvent()
{
    RegisterEvent(2420);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x7F
    if(1 == 0)
    {
        m_hZoneTitleWnd = GetHandle(m_WindowName);
        m_hTbZoneNameBack = TextBoxHandle(GetHandle(m_WindowName $ ".textZoneNameBack"));
        m_hTbZoneNameFront = TextBoxHandle(GetHandle(m_WindowName $ ".textZoneNameFront"));        
    }
    else
    {
        m_hZoneTitleWnd = GetWindowHandle(m_WindowName);
        m_hTbZoneNameBack = GetTextBoxHandle(m_WindowName $ ".textZoneNameBack");
        m_hTbZoneNameFront = GetTextBoxHandle(m_WindowName $ ".textZoneNameFront");
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string ZoneName, SubZoneName1, SubZoneName2;

    switch(Event_ID)
    {
        // End:0xA4
        case 2420:
            // End:0xA1
            if(GetOptionBool("ScreenInfo", "ShowZoneTitle") == true)
            {
                ParseString(param, "ZoneName", ZoneName);
                ParseString(param, "SubZoneName1", SubZoneName1);
                ParseString(param, "SubZoneName2", SubZoneName2);
                BeginShowZoneName(ZoneName, SubZoneName1, SubZoneName2);
            }
            // End:0xA7
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function BeginShowZoneName(string ZoneName, string SubZoneName1, string SubZoneName2)
{
    local int textWidth, textHeight, ScreenWidth, ScreenHeight;

    m_hTbZoneNameBack.SetText(ZoneName);
    m_hTbZoneNameFront.SetText(ZoneName);
    GetTextSize(ZoneName, "ZoneTitle", textWidth, textHeight);
    GetCurrentResolution(ScreenWidth, ScreenHeight);
    m_hZoneTitleWnd.SetWindowSize(textWidth + 100, 200);
    m_hZoneTitleWnd.MoveTo(((ScreenWidth / 2) - (textWidth / 2)) - 100, (ScreenHeight / 5) - 80);
    m_hZoneTitleWnd.ShowWindow();
    m_hZoneTitleWnd.SetTimer(0, 4000);
    return;
}

function OnTimer(int TimerID)
{
    m_hZoneTitleWnd.KillTimer(TimerID);
    m_hZoneTitleWnd.HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="ZoneTitleWnd"
}