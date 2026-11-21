class FishViewportWnd extends UICommonAPI;

const EFFECT_TIMER_ID = 2;
const EFFECT_TIMER_DELAY = 1000;
const STATUS_TIMER_ID = 3;
const STATUS_TIMER_DELAY = 0;
const REELING_TIMER_ID = 5;
const PUMPING_TIMER_ID = 4;
const PUMPING_TIMER_DELAY = 80;
const FAKE_TIMER_ID = 7;

var string m_WindowName;
var WindowHandle m_hFishViewportWnd;
var WindowHandle m_hPumpingIcon;
var TextBoxHandle m_hPumpingText;
var WindowHandle m_hReelingIcon;
var TextBoxHandle m_hReelingText;
var WindowHandle m_hFishHPBarEffect;
var BarHandle m_hFishHPBar;
var BarHandle m_hFishHPBarFake;
var TextBoxHandle m_hTbSec;
var WindowHandle m_hTexClock;
var WindowHandle m_hWndStatus;
var TextBoxHandle m_hTbStatus;
var TextBoxHandle m_hTbDeltaHP;
var WindowHandle m_hFakeIcon;
var int m_OriginalFishHP;
var int m_OriginalFishTime;
var int m_CurrentFishHP;
var int m_PumpintTimerCount;
var int m_FakeTimerCount;
var int m_FishLevel;
var string m_FishState;

function OnRegisterEvent()
{
    RegisterEvent(2470);
    RegisterEvent(2480);
    RegisterEvent(2500);
    RegisterEvent(2510);
    RegisterEvent(2522);
    RegisterEvent(2520);
    RegisterEvent(2521);
    return;
}

function OnLoad()
{
    InitHandleCOD();
    HideHPBarNEtc();
    m_hFishHPBarEffect.HideWindow();
    m_OriginalFishHP = 0;
    m_FishState = "stanby";
    RegisterState("FishViewportWnd", "GamingState");
    return;
}

function InitHandleCOD()
{
    m_hPumpingIcon = GetWindowHandle(m_WindowName $ ".texPumping");
    m_hPumpingText = TextBoxHandle(GetWindowHandle(m_WindowName $ ".txtPumping"));
    m_hReelingIcon = GetWindowHandle(m_WindowName $ ".texReeling");
    m_hReelingText = TextBoxHandle(GetWindowHandle(m_WindowName $ ".txtReeling"));
    m_hFishHPBar = GetBarHandle(m_WindowName $ ".barFishHp");
    m_hFishHPBarFake = GetBarHandle(m_WindowName $ ".barFishHpFake");
    m_hFishHPBarEffect = GetWindowHandle(m_WindowName $ ".wndEffect");
    m_hFishViewportWnd = GetWindowHandle(m_WindowName);
    m_hTbSec = GetTextBoxHandle(m_WindowName $ ".txtVarSec");
    m_hTexClock = GetWindowHandle(m_WindowName $ ".texClock");
    m_hWndStatus = GetWindowHandle(m_WindowName $ ".wndStatus");
    m_hTbStatus = GetTextBoxHandle(m_WindowName $ ".wndStatus.txtVarStatus");
    m_hTbDeltaHP = GetTextBoxHandle(m_WindowName $ ".wndStatus.txtVarDeltaHP");
    m_hFakeIcon = GetWindowHandle(m_WindowName $ ".texFakeIcon");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x54
        case 2470:
            m_hFakeIcon.HideWindow();
            m_hFishViewportWnd.ShowWindow();
            m_hFishViewportWnd.SetFocus();
            HideHPBarNEtc();
            m_hFishHPBarEffect.HideWindow();
            // End:0x11E
            break;
        // End:0x6E
        case 2480:
            m_hFishViewportWnd.HideWindow();
            // End:0x11E
            break;
        // End:0xA5
        case 2522:
            // End:0xA2
            if(m_hFishHPBar.IsShowWindow() || m_hFishHPBarFake.IsShowWindow())
            {
                ShowEffect();
            }
            // End:0x11E
            break;
        // End:0xBB
        case 2520:
            HandleInitFishStatus(param);
            // End:0x11E
            break;
        // End:0xD1
        case 2521:
            HandleSetFishStatus(param);
            // End:0x11E
            break;
        // End:0xF6
        case 2500:
            ShowWindow(m_WindowName $ ".btnRanking");
            // End:0x11E
            break;
        // End:0x11B
        case 2510:
            HideWindow(m_WindowName $ ".btnRanking");
            // End:0x11E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ShowHPBarNEtc(int ShowType, int Guts)
{
    m_hFishHPBar.ShowWindow();
    m_hTexClock.ShowWindow();
    m_hTbSec.ShowWindow();
    // End:0x78
    if(ShowType == 4)
    {
        m_hPumpingIcon.HideWindow();
        m_hPumpingText.HideWindow();
        m_hReelingIcon.HideWindow();
        m_hReelingText.HideWindow();        
    }
    else
    {
        // End:0x173
        if(m_FishLevel == 0)
        {
            // End:0x102
            if(Guts == 0)
            {
                m_hPumpingIcon.ShowWindow();
                m_hPumpingText.ShowWindow();
                m_hReelingIcon.HideWindow();
                m_hReelingText.HideWindow();
                // End:0xFF
                if(m_FishState != "pumping")
                {
                    m_hPumpingIcon.SetTimer(4, 80);
                    m_FishState = "pumping";
                }                
            }
            else
            {
                m_hPumpingIcon.HideWindow();
                m_hPumpingText.HideWindow();
                m_hReelingIcon.ShowWindow();
                m_hReelingText.ShowWindow();
                // End:0x173
                if(m_FishState != "reeling")
                {
                    m_hReelingIcon.SetTimer(5, 80);
                    m_FishState = "reeling";
                }
            }
        }
    }
    return;
}

function HideHPBarNEtc()
{
    m_hFishHPBar.HideWindow();
    m_hFishHPBarFake.HideWindow();
    m_hTexClock.HideWindow();
    m_hTbSec.HideWindow();
    m_hPumpingIcon.HideWindow();
    m_hPumpingText.HideWindow();
    m_hReelingIcon.HideWindow();
    m_hReelingText.HideWindow();
    return;
}

function HandleInitFishStatus(string param)
{
    ParseInt(param, "OriginalFishHP", m_OriginalFishHP);
    ParseInt(param, "OriginalFishTime", m_OriginalFishTime);
    ParseInt(param, "FishLevel", m_FishLevel);
    m_CurrentFishHP = m_OriginalFishHP;
    return;
}

function HandleSetFishStatus(string param)
{
    local int FishHP, TimeCount, DeltaHP, ShowType, Guts, Effect,
	    Penalty, Fake;

    ParseInt(param, "CurrentFishHP", FishHP);
    ParseInt(param, "TimeCount", TimeCount);
    ParseInt(param, "ShowType", ShowType);
    ParseInt(param, "Effect", Effect);
    ParseInt(param, "Guts", Guts);
    ParseInt(param, "Penalty", Penalty);
    ParseInt(param, "Fake", Fake);
    DeltaHP = FishHP - m_CurrentFishHP;
    // End:0x12A
    if(ShowType != 4)
    {
        m_CurrentFishHP = FishHP;
        m_hFishHPBar.SetValue(m_OriginalFishHP * 2, FishHP);
        m_hFishHPBarFake.SetValue(m_OriginalFishHP * 2, FishHP);
        m_hTbSec.SetText(string(TimeCount));
    }
    ShowHPBarNEtc(ShowType, Guts);
    // End:0x173
    if(!m_hFishHPBar.IsShowWindow() && (m_OriginalFishTime - TimeCount) >= 3)
    {
        ShowHPBarNEtc(ShowType, Guts);
    }
    // End:0x18E
    if(ShowType == 3)
    {
        ShowFishString(1261, 0);        
    }
    else
    {
        // End:0x1A6
        if(ShowType == 4)
        {
            ShowFishString(1264, 0);
        }
    }
    // End:0x340
    if(m_hFishHPBar.IsShowWindow() || m_hFishHPBarFake.IsShowWindow())
    {
        // End:0x1DD
        if(Effect != 0)
        {
            ShowEffect();
        }
        // End:0x23C
        if(ShowType == 1)
        {
            // End:0x229
            if(DeltaHP < 0)
            {
                // End:0x216
                if(Penalty > 0)
                {
                    ShowFishStringWithPenalty(1672, DeltaHP, Penalty);                    
                }
                else
                {
                    ShowFishString(1256, DeltaHP);
                }                
            }
            else
            {
                ShowFishString(1258, DeltaHP);
            }            
        }
        else
        {
            // End:0x299
            if(ShowType == 2)
            {
                // End:0x289
                if(DeltaHP < 0)
                {
                    // End:0x276
                    if(Penalty > 0)
                    {
                        ShowFishStringWithPenalty(1671, DeltaHP, Penalty);                        
                    }
                    else
                    {
                        ShowFishString(1257, DeltaHP);
                    }                    
                }
                else
                {
                    ShowFishString(1259, DeltaHP);
                }
            }
        }
        // End:0x313
        if(Fake != 0)
        {
            m_hFishHPBarFake.ShowWindow();
            m_hFishHPBar.HideWindow();
            m_hFakeIcon.HideWindow();
            // End:0x301
            if(m_FishLevel == 0)
            {
                m_hFakeIcon.SetTimer(7, 80);
                m_hFakeIcon.ShowWindow();                
            }
            else
            {
                m_hFakeIcon.HideWindow();
            }            
        }
        else
        {
            m_hFishHPBarFake.HideWindow();
            m_hFishHPBar.ShowWindow();
            m_hFakeIcon.HideWindow();
        }
    }
    return;
}

function ShowEffect()
{
    m_hFishHPBarEffect.ShowWindow();
    m_hFishHPBarEffect.SetTimer(2, 1000);
    return;
}

function ShowFishString(int strID, int DeltaHP)
{
    local Color Col;

    // End:0x37
    if(DeltaHP > 0)
    {
        Col.R = byte(255);
        Col.G = 0;
        Col.B = 0;        
    }
    else
    {
        Col.R = 220;
        Col.G = 220;
        Col.B = 220;
    }
    m_hTbStatus.SetTextColor(Col);
    m_hTbDeltaHP.SetTextColor(Col);
    m_hTbStatus.SetText(GetSystemString(strID));
    // End:0xC4
    if(DeltaHP != 0)
    {
        m_hTbDeltaHP.SetText(string(DeltaHP));        
    }
    else
    {
        m_hTbDeltaHP.SetText("");
    }
    m_hWndStatus.ShowWindow();
    m_hWndStatus.SetTimer(3, 0);
    return;
}

function ShowFishStringWithPenalty(int strID, int DeltaHP, int Penalty)
{
    local Color Col;

    Col.R = byte(255);
    Col.G = 0;
    Col.B = 0;
    m_hTbStatus.SetTextColor(Col);
    m_hTbDeltaHP.SetTextColor(Col);
    m_hTbStatus.SetText(GetSystemMessageWithParamNumber(strID, Penalty));
    // End:0x94
    if(DeltaHP != 0)
    {
        m_hTbDeltaHP.SetText(string(DeltaHP));        
    }
    else
    {
        m_hTbDeltaHP.SetText("");
    }
    m_hWndStatus.ShowWindow();
    m_hWndStatus.SetTimer(3, 0);
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1F
        case "btnRanking":
            RequestFishRanking();
            // End:0x22
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
        // End:0x97
        case 7:
            ++m_FakeTimerCount;
            // End:0x3A
            if((float(m_FakeTimerCount) % float(2)) == float(0))
            {
                m_hFakeIcon.ShowWindow();                
            }
            else
            {
                // End:0x5E
                if((float(m_FakeTimerCount) % float(2)) == float(1))
                {
                    m_hFakeIcon.HideWindow();
                }
            }
            // End:0x91
            if(m_FakeTimerCount > 2)
            {
                m_hFakeIcon.KillTimer(7);
                m_hFakeIcon.ShowWindow();
                m_FakeTimerCount = 0;
            }
            // End:0x2DC
            break;
            // End:0x2DC
            break;
        // End:0xC2
        case 2:
            m_hFishHPBarEffect.KillTimer(TimerID);
            m_hFishHPBarEffect.HideWindow();
            // End:0x2DC
            break;
        // End:0xED
        case 3:
            m_hWndStatus.KillTimer(TimerID);
            m_hWndStatus.HideWindow();
            // End:0x2DC
            break;
        // End:0x1E3
        case 4:
            ++m_PumpintTimerCount;
            // End:0x14D
            if((float(m_PumpintTimerCount) % float(2)) == float(0))
            {
                m_hPumpingIcon.ShowWindow();
                m_hPumpingText.ShowWindow();
                m_hReelingIcon.HideWindow();
                m_hReelingText.HideWindow();                
            }
            else
            {
                // End:0x19E
                if((float(m_PumpintTimerCount) % float(2)) == float(1))
                {
                    m_hPumpingIcon.HideWindow();
                    m_hPumpingText.HideWindow();
                    m_hReelingIcon.HideWindow();
                    m_hReelingText.HideWindow();
                }
            }
            // End:0x1E0
            if(m_PumpintTimerCount > 2)
            {
                m_hPumpingIcon.KillTimer(4);
                m_PumpintTimerCount = 0;
                m_hPumpingIcon.ShowWindow();
                m_hPumpingText.ShowWindow();
            }
            // End:0x2DC
            break;
        // End:0x2D9
        case 5:
            ++m_PumpintTimerCount;
            // End:0x243
            if((float(m_PumpintTimerCount) % float(2)) == float(0))
            {
                m_hReelingIcon.ShowWindow();
                m_hReelingText.ShowWindow();
                m_hPumpingIcon.HideWindow();
                m_hPumpingText.HideWindow();                
            }
            else
            {
                // End:0x294
                if((float(m_PumpintTimerCount) % float(2)) == float(1))
                {
                    m_hReelingIcon.HideWindow();
                    m_hReelingText.HideWindow();
                    m_hPumpingIcon.HideWindow();
                    m_hPumpingText.HideWindow();
                }
            }
            // End:0x2D6
            if(m_PumpintTimerCount > 2)
            {
                m_hReelingIcon.KillTimer(5);
                m_PumpintTimerCount = 0;
                m_hReelingIcon.ShowWindow();
                m_hReelingText.ShowWindow();
            }
            // End:0x2DC
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ClearTimer(int TimerID)
{
    // End:0x39
    if(TimerID == 4)
    {
        m_hPumpingIcon.ShowWindow();
        m_hPumpingText.ShowWindow();
        m_FishState = "pumping";
    }
    // End:0x72
    if(TimerID == 5)
    {
        m_hReelingIcon.ShowWindow();
        m_hReelingText.ShowWindow();
        m_FishState = "reeling";
    }
    return;
}

defaultproperties
{
    m_WindowName="FishViewportWnd"
}