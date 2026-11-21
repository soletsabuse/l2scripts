class AbnormalSettingsWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var SliderCtrlHandle DebuffSizeSlider;
var AbnormalStatusWnd AbnormalStatus;
var AbnormalStatusDebuffWnd AbnormalStatusDebuff;
var int currentTickSize;

function OnLoad()
{
    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    AbnormalStatus = AbnormalStatusWnd(GetScript("AbnormalStatusWnd"));
    AbnormalStatusDebuff = AbnormalStatusDebuffWnd(GetScript("AbnormalStatusDebuffWnd"));
    DebuffSizeSlider = GetSliderCtrlHandle("AbnormalSettingsWnd.DebuffSizeSlider");
    return;
}

function showHide(bool B)
{
    // End:0x1B
    if(B)
    {
        Me.ShowWindow();        
    }
    else
    {
        Me.HideWindow();
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x79
    if(TimerID == 1001)
    {
        Me.KillTimer(1001);
        SetOptionInt("Game", "AbnormalSize", currentTickSize);
        AbnormalStatusDebuff.nStatusIconSize = currentTickSize;
        AbnormalStatusDebuff.HandleAddNormalStatus(GetCurrentEffectParam(AbnormalStatusDebuff.StatusIcon));
    }
    return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
    switch(strID)
    {
        // End:0x5D
        case "DebuffSizeSlider":
            currentTickSize = tickToSize(iCurrentTick);
            Me.KillTimer(1001);
            Me.SetTimer(1001, 500);
            // End:0x63
            break;
        // End:0xFFFF
        default:
            // End:0x63
            break;
            break;
    }
    return;
}

function int tickToSize(int nTick)
{
    switch(nTick)
    {
        // End:0x0E
        case 0:
            return 12;
        // End:0x15
        case 1:
            return 16;
        // End:0x1D
        case 2:
            return 24;
        // End:0x25
        case 3:
            return 32;
        // End:0x2D
        case 4:
            return 48;
        // End:0x35
        case 5:
            return 64;
        // End:0xFFFF
        default:
            // End:0x3B
            break;
            break;
    }
    return;
}
