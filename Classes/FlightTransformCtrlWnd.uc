class FlightTransformCtrlWnd extends UIScript;

const MAX_ShortcutPerPage = 12;
const FTShortcutPage = 20;
const SelectTex_X = 1;
const SelectTex_Y = 1;
const FT_TIME = 45000;
const FT_TIME1 = 1000;
const FT_TIMER_ID = 150;
const FT_TIMER_ID1 = 152;

var WindowHandle Me;
var WindowHandle ShortcutWnd;
var ButtonHandle LockBtn;
var ButtonHandle UnlockBtn;
var ButtonHandle JoypadBtn;
var TextureHandle SelectTex;
var ShortcutWnd scriptShortcutWnd;
var int i;
var bool preEnterChattingOption;
var bool isNowActiveFlightTransShortcut;
var bool m_IsLocked;
var int preSlot;

function OnRegisterEvent()
{
    RegisterEvent(3800);
    RegisterEvent(630);
    RegisterEvent(650);
    RegisterEvent(640);
    RegisterEvent(91);
    RegisterEvent(3801);
    RegisterEvent(160);
    return;
}

function OnLoad()
{
    Me = GetWindowHandle("FlightTransformCtrlWnd");
    ShortcutWnd = GetWindowHandle("ShortcutWnd");
    SelectTex = GetTextureHandle("FlightTransformCtrlWnd.SelectTex");
    LockBtn = GetButtonHandle("FlightTransformCtrlWnd.FlightShortCut.LockBtn");
    UnlockBtn = GetButtonHandle("FlightTransformCtrlWnd.FlightShortCut.UnlockBtn");
    JoypadBtn = GetButtonHandle("FlightTransformCtrlWnd.FlightShortCut.JoypadBtn");
    scriptShortcutWnd = ShortcutWnd(GetScript("ShortcutWnd"));
    JoypadBtn.HideWindow();
    isNowActiveFlightTransShortcut = false;
    preSlot = -1;
    updateLockButton();
    ShortCutUpdateAll();
    return;
}

function updateLockButton()
{
    m_IsLocked = GetOptionBool("Game", "IsLockShortcutWnd");
    // End:0x76
    if(m_IsLocked)
    {
        // End:0x52
        if(!LockBtn.IsShowWindow())
        {
            LockBtn.ShowWindow();
        }
        // End:0x73
        if(UnlockBtn.IsShowWindow())
        {
            UnlockBtn.HideWindow();
        }        
    }
    else
    {
        // End:0x97
        if(LockBtn.IsShowWindow())
        {
            LockBtn.HideWindow();
        }
        // End:0xBA
        if(!UnlockBtn.IsShowWindow())
        {
            UnlockBtn.ShowWindow();
        }
    }
    scriptShortcutWnd.ArrangeWnd();
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x44
        case "LockBtn":
            m_IsLocked = false;
            SetOptionBool("Game", "IsLockShortcutWnd", false);
            updateLockButton();
            // End:0x86
            break;
        // End:0x83
        case "UnlockBtn":
            m_IsLocked = true;
            SetOptionBool("Game", "IsLockShortcutWnd", true);
            updateLockButton();
            // End:0x86
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnExitState(name a_NextStateName)
{
    CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(false));
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 3800:
            OnFlightTransformState(a_Param);
            // End:0xB4
            break;
        // End:0x30
        case 91:
            ExecuteShortcutCommandBySlot(a_Param);
            // End:0xB4
            break;
        // End:0x46
        case 3801:
            OnReserveShortCut(a_Param);
            // End:0xB4
            break;
        // End:0x70
        case 160:
            Me.KillTimer(150);
            Me.KillTimer(152);
            // End:0xB4
            break;
        // End:0x86
        case 630:
            HandleShortcutUpdate(a_Param);
            // End:0xB4
            break;
        // End:0x97
        case 640:
            ShortCutUpdateAll();
            // End:0xB4
            break;
        // End:0xAE
        case 650:
            HandleShortcutClear();
            updateLockButton();
            // End:0xB4
            break;
        // End:0xFFFF
        default:
            // End:0xB4
            break;
            break;
    }
    return;
}

function OnTimer(int TimerID)
{
    local Vector MyPosition;

    // End:0x58
    if(TimerID == 150)
    {
        // End:0x44
        if(!GetOptionBool("ScreenInfo", "SystemTutorialBox"))
        {
            ShowAirTutorial(-1);            
        }
        else
        {
            Me.KillTimer(150);
        }        
    }
    else
    {
        // End:0x70
        if(TimerID == 152)
        {
            MyPosition = GetPlayerPosition();
        }
    }
    return;
}

function OnFlightTransformState(string a_Param)
{
    local int IsFlying;

    ParseInt(a_Param, "IsFly", IsFlying);
    // End:0x1BB
    if(IsFlying > 0)
    {
        // End:0x78
        if(!GetOptionBool("ScreenInfo", "SystemTutorialBox"))
        {
            ShowAirTutorial(2493);
            ShowAirTutorial(2495);
            Me.SetTimer(150, 45000);
        }
        Me.SetTimer(152, 1000);
        preEnterChattingOption = GetChatFilterBool("Global", "EnterChatting");
        SetChatFilterBool("Global", "EnterChatting", true);
        Debug("OnFlightTransformState true");
        CallGFxFunction("OptionWnd", "onSwitchEnterChatting", string(true));
        CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(true));
        updateLockButton();
        Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");
        // End:0x1B0
        if(!Me.IsShowWindow())
        {
            Me.ShowWindow();
            ShortcutWnd.HideWindow();
        }
        isNowActiveFlightTransShortcut = true;        
    }
    else
    {
        Me.KillTimer(150);
        Me.KillTimer(152);
        CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(false));
        Class'NWindow.ShortcutAPI'.static.DeactivateGroup("FlightTransformShortcut");
        SetChatFilterBool("Global", "EnterChatting", preEnterChattingOption);
        // End:0x285
        if(preEnterChattingOption)
        {
            Class'NWindow.ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
        }
        CallGFxFunction("Menu", "onSetShortcut", "");
        CallGFxFunction("MenuWnd", "onSetShortcut", "");
        Debug("OnFlightTransformState" @ string(preEnterChattingOption));
        CallGFxFunction("OptionWnd", "onSwitchEnterChatting", string(preEnterChattingOption));
        // End:0x34A
        if(Me.IsShowWindow())
        {
            Me.HideWindow();
            ShortcutWnd.ShowWindow();
        }
        isNowActiveFlightTransShortcut = false;
    }
    return;
}

function ShortCutUpdateAll()
{
    local int nShortcutID;

    nShortcutID = 12 * 20;
    i = 0;
    J0x13:

    // End:0x80 [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("FlightTransformCtrlWnd.FlightShortCut.Shortcut" $ string(i + 1), nShortcutID);
        nShortcutID++;
        ++i;
        // [Loop Continue]
        goto J0x13;
    }
    return;
}

function HandleShortcutUpdate(string param)
{
    local int nShortcutID, nShortcutNum;

    ParseInt(param, "ShortcutID", nShortcutID);
    nShortcutNum = (nShortcutID - (12 * 20)) + 1;
    // End:0x9B
    if((nShortcutNum > 0) && nShortcutNum < (12 + 1))
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("FlightTransformCtrlWnd.FlightShortCut.Shortcut" $ string(nShortcutNum), nShortcutID);
    }
    return;
}

function HandleShortcutClear()
{
    i = 0;
    J0x07:

    // End:0x68 [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("FlightTransformCtrlWnd.FlightShortCut.Shortcut" $ string(i + 1));
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function HandleShortcutPageUpdate(string param)
{
    local int ShortcutPage;

    // End:0x61
    if(ParseInt(param, "ShortcutPage", ShortcutPage))
    {
        Debug("----------------ShortcutPage " $ string(ShortcutPage));
        // End:0x61
        if(ShortcutPage == 20)
        {
            ShortCutUpdateAll();
        }
    }
    return;
}

function ExecuteShortcutCommandBySlot(string a_Param)
{
    local int Slot, slotFromOne;

    ParseInt(a_Param, "Slot", Slot);
    // End:0xB2
    if((Slot >= (12 * 20)) && Slot < (12 * (20 + 1)))
    {
        slotFromOne = (Slot - (12 * 20)) + 1;
        Class'NWindow.ShortcutAPI'.static.ExecuteShortcutBySlot(Slot);
        SelectTex.SetAnchor(("FlightTransformCtrlWnd.F" $ string(slotFromOne)) $ "Tex", "TopLeft", "TopLeft", 1, 1);
    }
    return;
}

function OnReserveShortCut(string a_Param)
{
    local int Slot, slotFromOne;

    ParseInt(a_Param, "Slot", Slot);
    // End:0xCF
    if((Slot >= (12 * 20)) && Slot < (12 * (20 + 1)))
    {
        slotFromOne = (Slot - (12 * 20)) + 1;
        SelectTex.SetAnchor(("FlightTransformCtrlWnd.F" $ string(slotFromOne)) $ "Tex", "TopLeft", "TopLeft", 1, 1);
        // End:0xC4
        if(preSlot == slotFromOne)
        {
            Class'NWindow.ShortcutAPI'.static.ExecuteShortcutBySlot(Slot);            
        }
        else
        {
            preSlot = slotFromOne;
        }
    }
    return;
}

function ShowAirTutorial(int SystemMsgID)
{
    local int RandVal, RandSystemMsgID;

    // End:0x77
    if(SystemMsgID < 0)
    {
        RandVal = Rand(4);
        RandSystemMsgID = 2493;
        switch(RandVal)
        {
            // End:0x39
            case 0:
                RandSystemMsgID = 2493;
                // End:0x74
                break;
            // End:0x4B
            case 1:
                RandSystemMsgID = 2495;
                // End:0x74
                break;
            // End:0x5E
            case 2:
                RandSystemMsgID = 2496;
                // End:0x74
                break;
            // End:0x71
            case 3:
                RandSystemMsgID = 2497;
                // End:0x74
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        RandSystemMsgID = SystemMsgID;
    }
    // End:0xBA
    if(!GetOptionBool("ScreenInfo", "SystemTutorialBox"))
    {
        AddSystemMessage(RandSystemMsgID);        
    }
    else
    {
        Me.KillTimer(150);
    }
    return;
}
