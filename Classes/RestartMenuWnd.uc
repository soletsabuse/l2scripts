class RestartMenuWnd extends UICommonAPI;

const TimerValue1 = 329;

var bool m_bShow;
var bool m_bRestartON;
var bool m_bVillage;
var bool m_bAgit;
var bool m_bCastle;
var bool m_bBattleCamp;
var bool m_bOriginal;
var bool m_bFotress;
var bool m_bUnPenaltyLimit;
var WindowHandle m_wndTop;
var ButtonHandle m_btnVillage;
var ButtonHandle m_btnAgit;
var ButtonHandle m_btnCastle;
var ButtonHandle m_btnBattleCamp;
var ButtonHandle m_btnOriginal;
var ButtonHandle m_btnFortress;
var ButtonHandle m_btnUnPenaltyLimit;
var TextBoxHandle UnPenaltyTime;
var int reLiveTime;

function OnRegisterEvent()
{
    RegisterEvent(50);
    RegisterEvent(40);
    RegisterEvent(1430);
    RegisterEvent(1440);
    return;
}

function OnLoad()
{
    m_wndTop = GetWindowHandle("RestartMenuWnd");
    m_btnVillage = GetButtonHandle("RestartMenuWnd.btnVillage");
    m_btnAgit = GetButtonHandle("RestartMenuWnd.btnAgit");
    m_btnCastle = GetButtonHandle("RestartMenuWnd.btnCastle");
    m_btnBattleCamp = GetButtonHandle("RestartMenuWnd.btnBattleCamp");
    m_btnOriginal = GetButtonHandle("RestartMenuWnd.BtnUnPenalty");
    m_btnFortress = GetButtonHandle("RestartMenuWnd.btnFortress");
    UnPenaltyTime = GetTextBoxHandle("RestartMenuWnd.UnPenaltyTime");
    m_btnUnPenaltyLimit = GetButtonHandle("RestartMenuWnd.btnUnPenaltyLimit");
    m_bShow = false;
    m_bRestartON = false;
    return;
}

function OnShow()
{
    m_bShow = true;
    return;
}

function OnHide()
{
    m_bShow = false;
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x12
    if(m_bRestartON)
    {
        ShowMe();        
    }
    else
    {
        HideMe();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1A
    if(Event_ID == 50)
    {
        HandleDie(param);        
    }
    else
    {
        // End:0x2F
        if(Event_ID == 40)
        {
            HandleRestart();            
        }
        else
        {
            // End:0x47
            if(Event_ID == 1430)
            {
                HandleRestartMenuShow();                
            }
            else
            {
                // End:0x5C
                if(Event_ID == 1440)
                {
                    HandleRestartMenuHide();
                }
            }
        }
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x25
        case "btnVillage":
            timerAllKill();
            OnVillageClick();
            // End:0xE5
            break;
        // End:0x40
        case "btnAgit":
            timerAllKill();
            OnAgitClick();
            // End:0xE5
            break;
        // End:0x5D
        case "btnCastle":
            timerAllKill();
            OnCastleClick();
            // End:0xE5
            break;
        // End:0x7E
        case "btnBattleCamp":
            timerAllKill();
            OnBattleCampClick();
            // End:0xE5
            break;
        // End:0x9E
        case "BtnUnPenalty":
            timerAllKill();
            OnOriginalClick();
            // End:0xE5
            break;
        // End:0xBD
        case "btnFortress":
            timerAllKill();
            OnFortressClick();
            // End:0xE5
            break;
        // End:0xE2
        case "btnUnPenaltyLimit":
            timerAllKill();
            OnUnPenaltyLimitClick();
            // End:0xE5
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnVillageClick()
{
    RequestRestartPoint(0);
    HideMe();
    return;
}

function OnAgitClick()
{
    RequestRestartPoint(1);
    HideMe();
    return;
}

function OnCastleClick()
{
    RequestRestartPoint(2);
    HideMe();
    return;
}

function OnBattleCampClick()
{
    RequestRestartPoint(4);
    HideMe();
    return;
}

function OnOriginalClick()
{
    RequestRestartPoint(5);
    HideMe();
    return;
}

function OnFortressClick()
{
    RequestRestartPoint(3);
    HideMe();
    return;
}

function OnUnPenaltyLimitClick()
{
    RequestRestartPoint(7);
    HideMe();
    return;
}

function HandleDie(string param)
{
    local int VILLAGE, Agit, CASTLE, BattleCamp, Original, FORTRESS,
	    DelayToUseRebirthItem, AvailableCountRebirthItem, WinSize;

    WinSize = 175;
    Class'NWindow.FlashWindowAPI'.static.FlashWindow();
    ParseInt(param, "Village", VILLAGE);
    ParseInt(param, "Agit", Agit);
    ParseInt(param, "Castle", CASTLE);
    ParseInt(param, "BattleCamp", BattleCamp);
    ParseInt(param, "Original", Original);
    ParseInt(param, "Fortress", FORTRESS);
    ParseInt(param, "DelayToUseRebirthItem", DelayToUseRebirthItem);
    ParseInt(param, "AvailableCountRebirthItem", AvailableCountRebirthItem);
    Debug(param);
    m_bVillage = false;
    m_bAgit = false;
    m_bCastle = false;
    m_bBattleCamp = false;
    m_bOriginal = false;
    m_bFotress = false;
    m_bUnPenaltyLimit = false;
    // End:0x156
    if(VILLAGE > 0)
    {
        m_bVillage = true;
    }
    // End:0x169
    if(Agit > 0)
    {
        m_bAgit = true;
    }
    // End:0x17C
    if(CASTLE > 0)
    {
        m_bCastle = true;
    }
    // End:0x18F
    if(BattleCamp > 0)
    {
        m_bBattleCamp = true;
    }
    // End:0x1A2
    if(FORTRESS > 0)
    {
        m_bFotress = true;
    }
    // End:0x1C6
    if(AvailableCountRebirthItem > 0)
    {
        m_bUnPenaltyLimit = true;
        UnPenaltyTime.SetText("");
    }
    // End:0x259
    if(Original > 0)
    {
        m_bOriginal = true;
        // End:0x231
        if(DelayToUseRebirthItem != 0)
        {
            timerAllKill();
            m_btnOriginal.DisableWindow();
            reLiveTime = DelayToUseRebirthItem - 1;
            setReLiveText();
            m_wndTop.SetTimer(329, 1000);
            WinSize = 216;            
        }
        else
        {
            m_btnOriginal.EnableWindow();
            UnPenaltyTime.SetText("");
            WinSize = 201;
        }
    }
    windowReSize(WinSize);
    return;
}

function HandleRestartMenuShow()
{
    ShowMe();
    return;
}

function HandleRestartMenuHide()
{
    HideMe();
    return;
}

function HandleRestart()
{
    HideMe();
    return;
}

function ShowMe()
{
    // End:0x5C
    if((((((!m_bVillage && !m_bAgit) && !m_bCastle) && !m_bBattleCamp) && !m_bOriginal) && !m_bFotress) && !m_bUnPenaltyLimit)
    {        
    }
    else
    {
        m_bRestartON = true;
        m_wndTop.ShowWindow();
        // End:0x8E
        if(m_bVillage)
        {
            m_btnVillage.ShowWindow();            
        }
        else
        {
            m_btnVillage.HideWindow();
        }
        // End:0xB8
        if(m_bAgit)
        {
            m_btnAgit.ShowWindow();            
        }
        else
        {
            m_btnAgit.HideWindow();
        }
        // End:0xE2
        if(m_bCastle)
        {
            m_btnCastle.ShowWindow();            
        }
        else
        {
            m_btnCastle.HideWindow();
        }
        // End:0x10C
        if(m_bBattleCamp)
        {
            m_btnBattleCamp.ShowWindow();            
        }
        else
        {
            m_btnBattleCamp.HideWindow();
        }
        // End:0x136
        if(m_bOriginal)
        {
            m_btnOriginal.ShowWindow();            
        }
        else
        {
            m_btnOriginal.HideWindow();
        }
        // End:0x160
        if(m_bFotress)
        {
            m_btnFortress.ShowWindow();            
        }
        else
        {
            m_btnFortress.HideWindow();
        }
        // End:0x18A
        if(m_bUnPenaltyLimit)
        {
            m_btnUnPenaltyLimit.ShowWindow();            
        }
        else
        {
            m_btnUnPenaltyLimit.HideWindow();
        }
        m_wndTop.SetFocus();
    }
    return;
}

function HideMe()
{
    timerAllKill();
    m_bRestartON = false;
    m_wndTop.HideWindow();
    return;
}

function OnTimer(int TimerID)
{
    // End:0x51
    if(TimerID == 329)
    {
        reLiveTime = reLiveTime - 1;
        setReLiveText();
        // End:0x51
        if(reLiveTime == 0)
        {
            m_wndTop.KillTimer(329);
            m_btnOriginal.EnableWindow();
        }
    }
    return;
}

function timerAllKill()
{
    m_wndTop.KillTimer(329);
    return;
}

function windowReSize(int Size)
{
    m_wndTop.SetWindowSize(135, Size);
    return;
}

function setReLiveText()
{
    local string Str;

    Str = MakeFullSystemMsg(GetSystemMessage(3278), string(reLiveTime));
    UnPenaltyTime.SetText(Str);
    return;
}
