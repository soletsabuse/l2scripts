class FlightShipCtrlWnd extends UIScript;

const MAX_ShortcutPerPage = 12;
const FSShortcutPage = 21;
const Relative_Altitude = 4000;
const SelectTex_X = 1;
const SelectTex_Y = 1;

var WindowHandle Me;
var WindowHandle ShortcutWnd;
var TextBoxHandle AltitudeTxt;
var TextureHandle SelectTex;
var ButtonHandle UpButton;
var ButtonHandle DownButton;
var ButtonHandle LockBtn;
var ButtonHandle UnlockBtn;
var ButtonHandle JoypadBtn;
var EditBoxHandle ChatEditBox;
var ShortcutWnd scriptShortcutWnd;
var int i;
var bool preEnterChattingOption;
var bool m_IsLocked;
var bool m_preDriver;
var bool isNowActiveFlightShipShortcut;
var int preSlot;

function OnRegisterEvent()
{
    RegisterEvent(3540);
    RegisterEvent(3541);
    RegisterEvent(91);
    RegisterEvent(3801);
    RegisterEvent(640);
    RegisterEvent(630);
    RegisterEvent(650);
    return;
}

function OnLoad()
{
    Me = GetWindowHandle("FlightShipCtrlWnd");
    ShortcutWnd = GetWindowHandle("ShortcutWnd");
    AltitudeTxt = GetTextBoxHandle("FlightShipCtrlWnd.AltitudeTxt");
    SelectTex = GetTextureHandle("FlightShipCtrlWnd.FlightShortCut.SelectTex");
    UpButton = GetButtonHandle("FlightShipCtrlWnd.FlightSteerWnd.UpButton");
    DownButton = GetButtonHandle("FlightShipCtrlWnd.FlightSteerWnd.DownButton");
    LockBtn = GetButtonHandle("FlightShipCtrlWnd.FlightShortCut.LockBtn");
    UnlockBtn = GetButtonHandle("FlightShipCtrlWnd.FlightShortCut.UnlockBtn");
    JoypadBtn = GetButtonHandle("FlightShipCtrlWnd.FlightShortCut.JoypadBtn");
    ChatEditBox = GetEditBoxHandle("ChatWnd.ChatEditBox");
    scriptShortcutWnd = ShortcutWnd(GetScript("ShortcutWnd"));
    isNowActiveFlightShipShortcut = false;
    m_preDriver = false;
    preSlot = -1;
    JoypadBtn.HideWindow();
    updateLockButton();
    ShortCutUpdateAll();
    return;
}

function OnExitState(name a_NextStateName)
{
    CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(false));
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

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 3540:
            OnAirShipState(a_Param);
            // End:0xA0
            break;
        // End:0x33
        case 3541:
            OnAirShipAltitude(a_Param);
            // End:0xA0
            break;
        // End:0x46
        case 91:
            ExecuteShortcutCommandBySlot(a_Param);
            // End:0xA0
            break;
        // End:0x5C
        case 3801:
            OnReserveShortCut(a_Param);
            // End:0xA0
            break;
        // End:0x72
        case 630:
            HandleShortcutUpdate(a_Param);
            // End:0xA0
            break;
        // End:0x83
        case 640:
            ShortCutUpdateAll();
            // End:0xA0
            break;
        // End:0x9A
        case 650:
            HandleShortcutClear();
            updateLockButton();
            // End:0xA0
            break;
        // End:0xFFFF
        default:
            // End:0xA0
            break;
            break;
    }
    return;
}

function OnAirShipState(string a_Param)
{
    local int VehicleID, IsDriver;

    ParseInt(a_Param, "VehicleID", VehicleID);
    ParseInt(a_Param, "IsDriver", IsDriver);
    // End:0x183
    if(IsDriver > 0)
    {
        // End:0x180
        if(VehicleID > 0)
        {
            preEnterChattingOption = GetChatFilterBool("Global", "EnterChatting");
            SetChatFilterBool("Global", "EnterChatting", true);
            Debug("OnAirShipState true");
            CallGFxFunction("OptionWnd", "onSwitchEnterChatting", string(true));
            CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(true));
            Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");
            updateLockButton();
            // End:0x161
            if(!Me.IsShowWindow())
            {
                Me.ShowWindow();
                ShortcutWnd.HideWindow();
            }
            ChatEditBox.ReleaseFocus();
            isNowActiveFlightShipShortcut = true;
            m_preDriver = true;
        }        
    }
    else
    {
        // End:0x317
        if((VehicleID > 0) && m_preDriver == true)
        {
            CallGFxFunction("OptionWnd", "onSwitchDisableEnterChatting", string(false));
            Class'NWindow.ShortcutAPI'.static.DeactivateGroup("FlightStateShortcut");
            SetChatFilterBool("Global", "EnterChatting", preEnterChattingOption);
            // End:0x240
            if(preEnterChattingOption)
            {
                Class'NWindow.ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
            }
            CallGFxFunction("Menu", "onSetShortcut", "");
            CallGFxFunction("MenuWnd", "onSetShortcut", "");
            Debug("OnAirShipState2  " @ string(preEnterChattingOption));
            CallGFxFunction("OptionWnd", "onSwitchEnterChatting", string(preEnterChattingOption));
            // End:0x300
            if(Me.IsShowWindow())
            {
                Me.HideWindow();
                ShortcutWnd.ShowWindow();
            }
            isNowActiveFlightShipShortcut = false;
            ChatEditBox.ReleaseFocus();
        }
    }
    return;
}

function OnAirShipAltitude(string a_Param)
{
    local int m_nZ;

    ParseInt(a_Param, "Z", m_nZ);
    AltitudeTxt.SetText(string(m_nZ + 4000));
    return;
}

function ShortCutUpdateAll()
{
    local int nShortcutID;

    nShortcutID = 12 * 21;
    i = 0;
    J0x13:

    // End:0x7B [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("FlightShipCtrlWnd.FlightShortCut.Shortcut" $ string(i + 1), nShortcutID);
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
    nShortcutNum = (nShortcutID - (12 * 21)) + 1;
    // End:0x96
    if((nShortcutNum > 0) && nShortcutNum < (12 + 1))
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("FlightShipCtrlWnd.FlightShortCut.Shortcut" $ string(nShortcutNum), nShortcutID);
    }
    return;
}

function HandleShortcutClear()
{
    i = 0;
    J0x07:

    // End:0x63 [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("FlightShipCtrlWnd.FlightShortCut.Shortcut" $ string(i + 1));
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function ExecuteShortcutCommandBySlot(string a_Param)
{
    local int Slot;

    ParseInt(a_Param, "Slot", Slot);
    // End:0x4F
    if((Slot >= (12 * 21)) && Slot < (12 * (21 + 1)))
    {
        Class'NWindow.ShortcutAPI'.static.ExecuteShortcutBySlot(Slot);
    }
    return;
}

function OnReserveShortCut(string a_Param)
{
    local int Slot, slotFromOne;

    ParseInt(a_Param, "Slot", Slot);
    // End:0xD9
    if((Slot >= (12 * 21)) && Slot < (12 * (21 + 1)))
    {
        slotFromOne = (Slot - (12 * 21)) + 1;
        SelectTex.SetAnchor(("FlightShipCtrlWnd.FlightShortCut.F" $ string(slotFromOne)) $ "Tex", "TopLeft", "TopLeft", 1, 1);
        // End:0xCE
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

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x26
        case "UpButton":
            Class'NWindow.VehicleAPI'.static.AirShipMoveUp();
            // End:0xC6
            break;
        // End:0x47
        case "DownButton":
            Class'NWindow.VehicleAPI'.static.AirShipMoveDown();
            // End:0xC6
            break;
        // End:0x84
        case "LockBtn":
            m_IsLocked = false;
            SetOptionBool("Game", "IsLockShortcutWnd", false);
            updateLockButton();
            // End:0xC6
            break;
        // End:0xC3
        case "UnlockBtn":
            m_IsLocked = true;
            SetOptionBool("Game", "IsLockShortcutWnd", true);
            updateLockButton();
            // End:0xC6
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
