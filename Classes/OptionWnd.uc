class OptionWnd extends L2UIGFxScript;

const PARTY_MODIFY_REQUEST = 9;
const DIALOGID_proc1 = 10;
const DIALOGID_proc2 = 11;
const DIALOGID_proc3 = 12;
const DIALOGID_proc4 = 13;
const ID_CALL_DIALOG = 10;
const ID_EXEC_FUNCTION = 11;
const ID_OPENWINDOW = 12;

var bool m_bL2Shader;
var bool m_bDOF;
var bool m_bShaderWater;
var int m_AntiAliasing;
var int m_PostProc;
var bool m_bAutoPartyMatching;
var int g_CurrentMaxWidth;
var int g_CurrentMaxHeight;
var int nPixelShaderVersion;
var int nVertexShaderVersion;
var bool isGAMINGSTATE;
var DialogBox dScript;
var bool bPartyMember;
var bool bPartyMaster;
var FlightShipCtrlWnd scriptShip;
var FlightTransformCtrlWnd scriptTrans;
var array<string> m_datasheetKeyReplace;
var array<string> m_datasheetKeyReplaced;
var bool isOpenShortCut;
var WindowHandle m_hPartyMatchWnd;
var WindowHandle m_hUnionMatchWnd;
var bool preEnterChattingOption;

function OnRegisterEvent()
{
    RegisterEvent(9170);
    RegisterEvent(9175);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(3410);
    RegisterEvent(4910);
    RegisterEvent(4911);
    RegisterGFxEvent(5870);
    RegisterGFxEvent(3420);
    RegisterGFxEvent(3430);
    RegisterGFxEvent(510);
    RegisterEvent(520);
    RegisterEvent(4913);
    RegisterEvent(4916);
    RegisterEvent(4914);
    RegisterEvent(4915);
    RegisterEvent(4918);
    RegisterEvent(4919);
    RegisterEvent(1560);
    RegisterEvent(40);
    RegisterEvent(4917);
    RegisterGFxEvent(3452);
    RegisterGFxEvent(5871);
    RegisterGFxEvent(691);
    RegisterGFxEvent(692);
    RegisterGFxEvent(6210);
    RegisterGFxEvent(9320);
    RegisterGFxEvent(9330);
    RegisterEvent(692);
    RegisterEvent(3550);
    RegisterEvent(11030);
    return;
}

function LoadAudioOption()
{
    local bool bMute;

    // End:0x4A
    if(CanUseAudio())
    {
        bMute = GetOptionBool("Audio", "AudioMuteOn");
        SetOptionBool("Audio", "AudioMuteOn", bMute);
    }
    return;
}

function LoadVideoOption()
{
    local bool bKeepMinFrameRate;

    m_AntiAliasing = GetOptionInt("Video", "AntiAliasing");
    m_PostProc = GetOptionInt("Video", "PostProc");
    m_bL2Shader = GetOptionBool("Video", "L2Shader");
    m_bDOF = GetOptionBool("Video", "S30DOFBOX");
    m_bShaderWater = GetOptionBool("Video", "S30WaterEffectBox");
    bKeepMinFrameRate = GetOptionBool("Video", "IsKeepMinFrameRate");
    // End:0x11C
    if(!bKeepMinFrameRate)
    {
        // End:0x11C
        if((nPixelShaderVersion >= 30) && nVertexShaderVersion >= 30)
        {
            SetL2Shader(m_bL2Shader);
            // End:0x11C
            if(m_bL2Shader)
            {
                SetDOF(m_bDOF);
                SetShaderWaterEffect(m_bShaderWater);
            }
        }
    }
    return;
}

function LoadGameOption()
{
    local bool bChecked;
    local int iChecked;

    bChecked = false;
    bChecked = GetOptionBool("Control", "RightClickBox");
    SetFixedDefaultCamera(bChecked);
    // End:0x92
    if(!GetINIBool("ScreenInfo", "ShowZoneTitle", iChecked, "Option.ini"))
    {
        SetOptionBool("ScreenInfo", "ShowZoneTitle", true);
    }
    // End:0xED
    if(!GetINIBool("ScreenInfo", "ShowGameTipMsg", iChecked, "Option.ini"))
    {
        SetOptionBool("ScreenInfo", "ShowGameTipMsg", true);
    }
    return;
}

function OnLoad()
{
    SetContainerWindow("SkinnedWindow", 205);
    AddState("GAMINGSTATE");
    AddState("LOGINSTATE");
    AddState("PAWNVIEWERSTATE");
    AddState("ARENAGAMINGSTATE");
    AddState("ARENABATTLESTATE");
    SetOptionBool("ScreenInfo", "HideDropItem", false);
    GetShaderVersion(nPixelShaderVersion, nVertexShaderVersion);
    LoadVideoOption();
    LoadAudioOption();
    LoadGameOption();
    DataSheetAssignKeyReplacement();
    scriptShip = FlightShipCtrlWnd(GetScript("FlightShipCtrlWnd"));
    scriptTrans = FlightTransformCtrlWnd(GetScript("FlightTransformCtrlWnd"));
    m_hPartyMatchWnd = GetWindowHandle("PartyMatchWnd");
    m_hUnionMatchWnd = GetWindowHandle("UnionMatchWnd");
    return;
}

function DataSheetAssignKeyReplacement()
{
    m_datasheetKeyReplace[1] = "LEFTMOUSE";
    m_datasheetKeyReplace[2] = "RIGHTMOUSE";
    m_datasheetKeyReplace[3] = "BACKSPACE";
    m_datasheetKeyReplace[4] = "ENTER";
    m_datasheetKeyReplace[5] = "SHIFT";
    m_datasheetKeyReplace[6] = "CTRL";
    m_datasheetKeyReplace[7] = "ALT";
    m_datasheetKeyReplace[8] = "PAUSE";
    m_datasheetKeyReplace[9] = "CAPSLOCK";
    m_datasheetKeyReplace[10] = "ESCAPE";
    m_datasheetKeyReplace[11] = "SPACE";
    m_datasheetKeyReplace[12] = "PAGEUP";
    m_datasheetKeyReplace[13] = "PAGEDOWN";
    m_datasheetKeyReplace[14] = "END";
    m_datasheetKeyReplace[15] = "HOME";
    m_datasheetKeyReplace[16] = "LEFT";
    m_datasheetKeyReplace[17] = "UP";
    m_datasheetKeyReplace[18] = "RIGHT";
    m_datasheetKeyReplace[19] = "DOWN";
    m_datasheetKeyReplace[20] = "SELECT";
    m_datasheetKeyReplace[21] = "PRINT";
    m_datasheetKeyReplace[22] = "PRINTSCRN";
    m_datasheetKeyReplace[23] = "INSERT";
    m_datasheetKeyReplace[24] = "DELETE";
    m_datasheetKeyReplace[25] = "HELP";
    m_datasheetKeyReplace[26] = "NUMPAD0";
    m_datasheetKeyReplace[27] = "NUMPAD1";
    m_datasheetKeyReplace[28] = "NUMPAD2";
    m_datasheetKeyReplace[29] = "NUMPAD3";
    m_datasheetKeyReplace[30] = "NUMPAD4";
    m_datasheetKeyReplace[31] = "NUMPAD5";
    m_datasheetKeyReplace[32] = "NUMPAD6";
    m_datasheetKeyReplace[33] = "NUMPAD7";
    m_datasheetKeyReplace[34] = "NUMPAD8";
    m_datasheetKeyReplace[35] = "NUMPAD9";
    m_datasheetKeyReplace[36] = "GREYSTAR";
    m_datasheetKeyReplace[37] = "GREYPLUS";
    m_datasheetKeyReplace[38] = "SEPARATOR";
    m_datasheetKeyReplace[39] = "GREYMINUS";
    m_datasheetKeyReplace[40] = "NUMPADPERIOD";
    m_datasheetKeyReplace[41] = "GREYSLASH";
    m_datasheetKeyReplace[42] = "NUMLOCK";
    m_datasheetKeyReplace[43] = "SCROLLLOCK";
    m_datasheetKeyReplace[44] = "UNICODE";
    m_datasheetKeyReplace[45] = "SEMICOLON";
    m_datasheetKeyReplace[46] = "EQUALS";
    m_datasheetKeyReplace[47] = "COMMA";
    m_datasheetKeyReplace[48] = "MINUS";
    m_datasheetKeyReplace[49] = "SLASH";
    m_datasheetKeyReplace[50] = "TILDE";
    m_datasheetKeyReplace[51] = "LEFTBRACKET";
    m_datasheetKeyReplace[52] = "BACKSLASH";
    m_datasheetKeyReplace[53] = "RIGHTBRACKET";
    m_datasheetKeyReplace[54] = "SINGLEQUOTE";
    m_datasheetKeyReplace[55] = "PERIOD";
    m_datasheetKeyReplace[56] = "MIDDLEMOUSE";
    m_datasheetKeyReplace[57] = "MOUSEWHEELDOWN";
    m_datasheetKeyReplace[58] = "MOUSEWHEELUP";
    m_datasheetKeyReplace[59] = "UNKNOWN16";
    m_datasheetKeyReplace[60] = "UNKNOWN17";
    m_datasheetKeyReplace[61] = "BACKSLASH";
    m_datasheetKeyReplace[62] = "UNKNOWN19";
    m_datasheetKeyReplace[63] = "UNKNOWN5C";
    m_datasheetKeyReplace[64] = "UNKNOWN5D";
    m_datasheetKeyReplace[65] = "UNKNOWN0C";
    m_datasheetKeyReplaced[1] = GetSystemString(1670);
    m_datasheetKeyReplaced[2] = GetSystemString(1671);
    m_datasheetKeyReplaced[3] = GetSystemString(1517);
    m_datasheetKeyReplaced[4] = "Enter";
    m_datasheetKeyReplaced[5] = "Shift";
    m_datasheetKeyReplaced[6] = "Ctrl";
    m_datasheetKeyReplaced[7] = "Alt";
    m_datasheetKeyReplaced[8] = "Pause";
    m_datasheetKeyReplaced[9] = "CapsLock";
    m_datasheetKeyReplaced[10] = "ESC";
    m_datasheetKeyReplaced[11] = GetSystemString(1672);
    m_datasheetKeyReplaced[12] = "PageUp";
    m_datasheetKeyReplaced[13] = "PageDown";
    m_datasheetKeyReplaced[14] = "End";
    m_datasheetKeyReplaced[15] = "Home";
    m_datasheetKeyReplaced[16] = "Left";
    m_datasheetKeyReplaced[17] = "Up";
    m_datasheetKeyReplaced[18] = "Right";
    m_datasheetKeyReplaced[19] = "Down";
    m_datasheetKeyReplaced[20] = "Select";
    m_datasheetKeyReplaced[21] = "Print";
    m_datasheetKeyReplaced[22] = "PrintScrn";
    m_datasheetKeyReplaced[23] = "Insert";
    m_datasheetKeyReplaced[24] = "Delete";
    m_datasheetKeyReplaced[25] = "Help";
    m_datasheetKeyReplaced[26] = GetSystemString(1657);
    m_datasheetKeyReplaced[27] = GetSystemString(1658);
    m_datasheetKeyReplaced[28] = GetSystemString(1659);
    m_datasheetKeyReplaced[29] = GetSystemString(1660);
    m_datasheetKeyReplaced[30] = GetSystemString(1661);
    m_datasheetKeyReplaced[31] = GetSystemString(1662);
    m_datasheetKeyReplaced[32] = GetSystemString(1663);
    m_datasheetKeyReplaced[33] = GetSystemString(1664);
    m_datasheetKeyReplaced[34] = GetSystemString(1665);
    m_datasheetKeyReplaced[35] = GetSystemString(1666);
    m_datasheetKeyReplaced[36] = "*";
    m_datasheetKeyReplaced[37] = "+";
    m_datasheetKeyReplaced[38] = "Separator";
    m_datasheetKeyReplaced[39] = "-";
    m_datasheetKeyReplaced[40] = ".";
    m_datasheetKeyReplaced[41] = "/";
    m_datasheetKeyReplaced[42] = "NumLock";
    m_datasheetKeyReplaced[43] = "ScrollLock";
    m_datasheetKeyReplaced[44] = "Unicode";
    m_datasheetKeyReplaced[45] = ";";
    m_datasheetKeyReplaced[46] = "=";
    m_datasheetKeyReplaced[47] = ",";
    m_datasheetKeyReplaced[48] = "-";
    m_datasheetKeyReplaced[49] = "/";
    m_datasheetKeyReplaced[50] = "`";
    m_datasheetKeyReplaced[51] = "[";
    m_datasheetKeyReplaced[52] = "";
    m_datasheetKeyReplaced[53] = "]";
    m_datasheetKeyReplaced[54] = "'";
    m_datasheetKeyReplaced[55] = ".";
    m_datasheetKeyReplaced[56] = GetSystemString(1669);
    m_datasheetKeyReplaced[57] = GetSystemString(1667);
    m_datasheetKeyReplaced[58] = GetSystemString(1668);
    m_datasheetKeyReplaced[59] = "-";
    m_datasheetKeyReplaced[60] = "=";
    m_datasheetKeyReplaced[61] = GetSystemString(1676);
    m_datasheetKeyReplaced[62] = GetSystemString(1673);
    m_datasheetKeyReplaced[63] = GetSystemString(1674);
    m_datasheetKeyReplaced[64] = GetSystemString(1675);
    m_datasheetKeyReplaced[65] = GetSystemString(1677);
    return;
}

function string GetUserReadableKeyName(string Input)
{
    local int i;
    local string output;

    i = 0;
    J0x07:

    // End:0x47 [Loop If]
    if(i < m_datasheetKeyReplace.Length)
    {
        // End:0x3D
        if(m_datasheetKeyReplace[i] == Input)
        {
            output = m_datasheetKeyReplaced[i];
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x5E
    if(output == "")
    {
        output = Input;
    }
    return output;
    return;
}

function PartyLootingChanged(int selectedNum)
{
    // End:0x62
    if(bPartyMaster || (IsRoomMaster()) && !bPartyMember)
    {
        // End:0x50
        if(GetOptionInt("Communication", "PartyLooting") == selectedNum)
        {
            return;
        }
        setEnableLootingBox(false);
        RequestPartyLootingModify(selectedNum);
    }
    return;
}

function chkRequestRegistWaitingSubstitute(bool checked)
{
    // End:0x3C
    if(checked == GetOptionBool("Communication", "StartupAutoPartyMatching"))
    {
        return;
    }
    // End:0x47
    if(m_bAutoPartyMatching)
    {
        return;
    }
    // End:0x57
    if(checked)
    {
        RequestRegistWaitingSubstitute(1);
    }
    return;
}

function HandleSwitchEnterchatting()
{
    local bool __var9868;
    local FlightTransformCtrlWnd scriptFlgithForm;
    local FlightShipCtrlWnd scriptFlightShip;

    scriptFlgithForm = FlightTransformCtrlWnd(GetScript("FlightTransformCtrlWnd"));
    // End:0x3D
    if(scriptFlgithForm.isNowActiveFlightTransShortcut)
    {
        return;
    }
    scriptFlightShip = FlightShipCtrlWnd(GetScript("FlightShipCtrlWnd"));
    // End:0x75
    if(scriptFlightShip.isNowActiveFlightShipShortcut)
    {
        return;
    }
    Class'NWindow.ShortcutAPI'.static.ActivateGroup("GamingStateDefaultShortcut");
    Class'NWindow.ShortcutAPI'.static.ActivateGroup("CameraControl");
    Class'NWindow.ShortcutAPI'.static.ActivateGroup("GamingStateGMShortcut");
    // End:0x196
    if(getInstanceUIData().getIsArenaServer())
    {
        Class'NWindow.ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
        preEnterChattingOption = GetChatFilterBool("Global", "EnterChatting");
        SetChatFilterBool("Global", "EnterChatting", true);
        __var9868 = true;
        CallGFxFunction(getCurrentWindowName(string(self)), "onSwitchDisableEnterChatting", string(true));        
    }
    else
    {
        // End:0x201
        if(GetChatFilterBool("Global", "EnterChatting"))
        {
            Class'NWindow.ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
            SetChatFilterBool("Global", "EnterChatting", true);
            __var9868 = true;            
        }
        else
        {
            Class'NWindow.ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");
            SetChatFilterBool("Global", "EnterChatting", false);
            __var9868 = false;
        }
    }
    handleArenaShortCut();
    CallGFxFunction(getCurrentWindowName(string(self)), "onSwitchEnterChatting", string(__var9868));
    return;
}

function saveArenaShortcutList()
{
    local ShortcutCommandItem shortcutItem;

    shortcutItem.sCommand = "getNextTarget";
    shortcutItem.Key = "TAB";
    shortcutItem.subkey1 = "";
    shortcutItem.subkey2 = "";
    shortcutItem.sState = "";
    shortcutItem.sAction = "Press";
    Class'NWindow.ShortcutAPI'.static.AssignCommand("ArenaGamingEnterChattingShortcut", shortcutItem);
    shortcutItem.sCommand = "getPrevTarget";
    shortcutItem.Key = "TAB";
    shortcutItem.subkey1 = "Shift";
    shortcutItem.subkey2 = "";
    shortcutItem.sState = "";
    shortcutItem.sAction = "Press";
    Class'NWindow.ShortcutAPI'.static.AssignCommand("ArenaGamingEnterChattingShortcut", shortcutItem);
    shortcutItem.sCommand = "useRunSkill";
    shortcutItem.Key = "F";
    shortcutItem.subkey1 = "";
    shortcutItem.subkey2 = "";
    shortcutItem.sState = "";
    shortcutItem.sAction = "Press";
    Class'NWindow.ShortcutAPI'.static.AssignCommand("ArenaGamingEnterChattingShortcut", shortcutItem);
    shortcutItem.sCommand = "useBaseRecallSkill";
    shortcutItem.Key = "B";
    shortcutItem.subkey1 = "";
    shortcutItem.subkey2 = "";
    shortcutItem.sState = "";
    shortcutItem.sAction = "Press";
    Class'NWindow.ShortcutAPI'.static.AssignCommand("ArenaGamingEnterChattingShortcut", shortcutItem);
    shortcutItem.sCommand = "ArenaSelectTarget";
    shortcutItem.Key = "SPACE";
    shortcutItem.subkey1 = "";
    shortcutItem.subkey2 = "";
    shortcutItem.sState = "";
    shortcutItem.sAction = "Press";
    Class'NWindow.ShortcutAPI'.static.AssignCommand("ArenaGamingEnterChattingShortcut", shortcutItem);
    Class'NWindow.ShortcutAPI'.static.Save();
    return;
}

function ToggleOpenMeWnd(bool isShortCut)
{
    isOpenShortCut = isShortCut;
    // End:0x1F
    if(IsShowWindow())
    {
        HideWindow();        
    }
    else
    {
        ShowWindow();
    }
    return;
}

function ShortCutReset()
{
    ActiveFlightShort();
    HandleSwitchEnterchatting();
    handleArenaShortCut();
    return;
}

function OnCallUCFunction(string funcName, string param)
{
    switch(funcName)
    {
        // End:0x22
        case "ShortCutReset":
            ShortCutReset();
            // End:0x135
            break;
        // End:0x49
        case "HandleSwitchEnterchatting":
            HandleSwitchEnterchatting();
            // End:0x135
            break;
        // End:0x71
        case "PartyLootingChanged":
            PartyLootingChanged(int(param));
            // End:0x135
            break;
        // End:0xA4
        case "RequestRegistWaitingSubstitute":
            chkRequestRegistWaitingSubstitute(bool(param));
            // End:0x135
            break;
        // End:0xC9
        case "SetPcRoomBoxData":
            SetPcRoomBoxData(bool(param));
            // End:0x135
            break;
        // End:0xEA
        case "StateBoxShow":
            StateBoxShow(bool(param));
            // End:0x135
            break;
        // End:0x110
        case "handleShaderOptionChange":
            handleShaderOptionChange();
            // End:0x135
            break;
        // End:0x12F
        case "setChattingOption":
            setChattingOption();
            // End:0x135
            break;
        // End:0xFFFF
        default:
            // End:0x135
            break;
            break;
    }
    return;
}

function SetDefaultPositionByClick()
{
    GetCurrentResolution(g_CurrentMaxWidth, g_CurrentMaxHeight);
    SetDefaultPosition();
    return;
}

function InitControlOption()
{
    CallGFxFunction(getCurrentWindowName(string(self)), "InitControlOption", "");
    return;
}

function InitScreenInfoOption()
{
    CallGFxFunction(getCurrentWindowName(string(self)), "InitScreenInfoOption", "");
    return;
}

function StateBoxShow(bool bChecked)
{
    local TargetStatusWnd util;

    util = TargetStatusWnd(GetScript("TargetStatusWnd"));
    util.StateBoxShow(bChecked);
    return;
}

function SetPcRoomBoxData(bool bOption)
{
    local InfoWnd script;

    script = InfoWnd(GetScript("InfoWnd"));
    // End:0x46
    if((script != none) && isGAMINGSTATE)
    {
        script.HandleToggleShowPCCafeEventWnd(true, bOption);
    }
    return;
}

function ActiveFlightShort()
{
    // End:0xC8
    if(scriptShip.Me.IsShowWindow())
    {
        SetChatFilterBool("Global", "EnterChatting", true);
        CallGFxFunction(getCurrentWindowName(string(self)), "onSwitchEnterChatting", string(true));
        CallGFxFunction(getCurrentWindowName(string(self)), "onSwitchDisableEnterChatting", string(true));
        Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");
        scriptShip.updateLockButton();        
    }
    else
    {
        // End:0x191
        if(scriptTrans.Me.IsShowWindow())
        {
            SetChatFilterBool("Global", "EnterChatting", true);
            CallGFxFunction(getCurrentWindowName(string(self)), "onSwitchEnterChatting", string(true));
            CallGFxFunction(getCurrentWindowName(string(self)), "onSwitchDisableEnterChatting", string(true));
            scriptTrans.updateLockButton();
            Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");
        }
    }
    return;
}

function handleShaderOptionChange()
{
    m_AntiAliasing = GetOptionInt("Video", "AntiAliasing");
    m_PostProc = GetOptionInt("Video", "PostProc");
    m_bL2Shader = GetOptionBool("Video", "L2Shader");
    m_bDOF = GetOptionBool("Video", "S30DOFBOX");
    m_bShaderWater = GetOptionBool("Video", "S30WaterEffectBox");
    SetHDR(m_PostProc);
    SetAntialiasing(m_AntiAliasing);
    SetShaderWaterEffect(m_bShaderWater);
    SetDOF(m_bDOF);
    SetL2Shader(m_bL2Shader);
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x19
        case 1710:
            HandleDialogResult(true);
            // End:0x20C
            break;
        // End:0x2B
        case 1720:
            HandleDialogResult(false);
            // End:0x20C
            break;
        // End:0x41
        case 3410:
            UIActivationUponStateChanges(a_Param);
            // End:0x20C
            break;
        // End:0x57
        case 4910:
            OnAskPartyLootingModify(a_Param);
            // End:0x20C
            break;
        // End:0x6D
        case 4911:
            OnPartyLootingHasModified(a_Param);
            // End:0x20C
            break;
        // End:0x75
        case 4917:
        // End:0x7D
        case 4916:
        // End:0x9E
        case 4913:
            bPartyMember = false;
            bPartyMaster = false;
            OnPartyHasDismissed();
            // End:0x20C
            break;
        // End:0xC4
        case 4914:
            bPartyMember = true;
            bPartyMaster = false;
            OnBecamePartyMember(a_Param);
            // End:0x20C
            break;
        // End:0xEA
        case 4915:
            bPartyMember = false;
            bPartyMaster = true;
            OnBecamePartyMaster(a_Param);
            // End:0x20C
            break;
        // End:0x153
        case 4918:
            bPartyMember = true;
            bPartyMaster = false;
            OnHandOverPartyMaster();
            // End:0x12C
            if(m_hPartyMatchWnd.IsShowWindow() == true)
            {
                m_hPartyMatchWnd.HideWindow();
            }
            // End:0x150
            if(m_hUnionMatchWnd.IsShowWindow() == true)
            {
                m_hUnionMatchWnd.HideWindow();
            }
            // End:0x20C
            break;
        // End:0x174
        case 4919:
            bPartyMember = false;
            bPartyMaster = true;
            OnRecvPartyMaster();
            // End:0x20C
            break;
        // End:0x192
        case 40:
            bPartyMember = false;
            bPartyMaster = false;
            OnRestart();
            // End:0x20C
            break;
        // End:0x1A3
        case 1560:
            OnPartyMatchRoomClose();
            // End:0x20C
            break;
        // End:0x1B6
        case 9170:
            m_bAutoPartyMatching = true;
            // End:0x20C
            break;
        // End:0x1C9
        case 9175:
            m_bAutoPartyMatching = false;
            // End:0x20C
            break;
        // End:0x1DA
        case 692:
            handleArenaShortCut();
            // End:0x20C
            break;
        // End:0x1F0
        case 3550:
            _OnEvent(a_Param);
            // End:0x20C
            break;
        // End:0x206
        case 11030:
            toggleNT(a_Param);
            // End:0x20C
            break;
        // End:0xFFFF
        default:
            // End:0x20C
            break;
            break;
    }
    return;
}

function toggleNT(string param)
{
    local int __var19218;

    ParseInt(param, "NextTargetMode", __var19218);
    switch(__var19218)
    {
        // End:0x49
        case 0:
            getInstanceL2Util().showGfxScreenMessage(GetSystemString(3862));
            // End:0xB7
            break;
        // End:0x6B
        case 1:
            getInstanceL2Util().showGfxScreenMessage(GetSystemString(3863));
            // End:0xB7
            break;
        // End:0x8E
        case 2:
            getInstanceL2Util().showGfxScreenMessage(GetSystemString(3864));
            // End:0xB7
            break;
        // End:0xB1
        case 3:
            getInstanceL2Util().showGfxScreenMessage(GetSystemString(3865));
            // End:0xB7
            break;
        // End:0xFFFF
        default:
            // End:0xB7
            break;
            break;
    }
    return;
}

function _OnEvent(string _param)
{
    return;
}

function handleArenaShortCut()
{
    local string __var7491;

    __var7491 = GetGameStateName();
    // End:0xDD
    if((((__var7491 == "ARENAGAMINGSTATE") || __var7491 == "ARENABATTLESTATE") || __var7491 == "ARENAPICKSTATE") || __var7491 == "ARENAOBSERVERSTATE")
    {
        saveArenaShortcutList();
        Class'NWindow.ShortcutAPI'.static.ActivateGroup("ArenaGamingShortcut");
        Class'NWindow.ShortcutAPI'.static.ActivateGroup("ArenaGamingEnterChattingShortcut");
    }
    return;
}

function HandleDialogResult(bool bOK)
{
    local DialogBox dialogBoxScript;

    dialogBoxScript = DialogBox(GetScript("DialogBox"));
    // End:0x53
    if(Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
    {
        // End:0x53
        if(dialogBoxScript.DialogGetID() == 9)
        {
            SetRequestPartyLootingModifyAgreement(bOK);
        }
    }
    return;
}

function setEnableLootingBox(bool bEnable)
{
    CallGFxFunction(getCurrentWindowName(string(self)), "setEnableLootingBox", string(bEnable));
    return;
}

function setLootingBoxSelection(int SelectNum)
{
    CallGFxFunction(getCurrentWindowName(string(self)), "setLootingBoxSelection", string(SelectNum));
    return;
}

function saveLootingBoxSelection()
{
    CallGFxFunction(getCurrentWindowName(string(self)), "saveLootingBoxSelection", "");
    return;
}

function SetRequestPartyLootingModifyAgreement(bool bOK)
{
    // End:0x13
    if(bOK)
    {
        RequestPartyLootingModifyAgreement(1);        
    }
    else
    {
        dScript.SetButtonName(1337, 1342);
        RequestPartyLootingModifyAgreement(0);
    }
    return;
}

function OnPartyMatchRoomClose()
{
    // End:0x41
    if(!bPartyMember && !bPartyMaster)
    {
        setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
    }
    return;
}

function OnPartyHasDismissed()
{
    setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
    setEnableLootingBox(true);
    return;
}

function OnBecamePartyMember(string a_Param)
{
    local int Lootingtype;

    ParseInt(a_Param, "Lootingtype", Lootingtype);
    setLootingBoxSelection(Lootingtype);
    setEnableLootingBox(false);
    return;
}

function OnBecamePartyMaster(string a_Param)
{
    local int Lootingtype;

    ParseInt(a_Param, "Lootingtype", Lootingtype);
    setLootingBoxSelection(Lootingtype);
    setEnableLootingBox(true);
    return;
}

function OnHandOverPartyMaster()
{
    setEnableLootingBox(false);
    return;
}

function OnRecvPartyMaster()
{
    saveLootingBoxSelection();
    setEnableLootingBox(true);
    return;
}

function OnRestart()
{
    setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
    setEnableLootingBox(true);
    // End:0x66
    if(getInstanceUIData().getIsArenaServer())
    {
        SetChatFilterBool("Global", "EnterChatting", preEnterChattingOption);
    }
    return;
}

function bool IsRoomMaster()
{
    local PartyWnd script;

    script = PartyWnd(GetScript("PartyWnd"));
    return script.m_AmIRoomMaster;
    return;
}

function OnPartyLootingHasModified(string a_Param)
{
    local int IsSuccess, LootingScheme;
    local string Schemestr, strParam;
    local PartyWnd script;
    local SystemMsgData SystemMsgCurrent;
    local TextBoxHandle t_handle;
    local L2Util util;

    util = L2Util(GetScript("L2Util"));
    script = PartyWnd(GetScript("PartyWnd"));
    ParseInt(a_Param, "IsSuccess", IsSuccess);
    ParseInt(a_Param, "LootingScheme", LootingScheme);
    // End:0xE8
    if(IsSuccess != 0)
    {
        script.SetMasterTooltip(LootingScheme);
        Schemestr = util.getLootingString(LootingScheme);
        t_handle = GetTextBoxHandle("PartyMatchRoomWnd.LootingMethod");
        t_handle.SetText(Schemestr);
    }
    // End:0x16D
    if(bPartyMaster || IsRoomMaster())
    {
        AddSystemMessage(3136);
        // End:0x13D
        if(IsSuccess != 0)
        {
            SetOptionInt("Communication", "PartyLooting", LootingScheme);            
        }
        else
        {
            setLootingBoxSelection(GetOptionInt("Communication", "PartyLooting"));
        }
        setEnableLootingBox(true);
    }
    // End:0x17B
    if(IsSuccess == 0)
    {        
    }
    else
    {
        // End:0x345
        if(IsSuccess == 1)
        {
            Schemestr = util.getLootingString(LootingScheme);
            GetSystemMsgInfo(3138, SystemMsgCurrent);
            ParamAdd(strParam, "MsgType", string(1));
            ParamAdd(strParam, "WindowType", string(SystemMsgCurrent.WindowType));
            ParamAdd(strParam, "FontType", string(SystemMsgCurrent.FontType));
            ParamAdd(strParam, "BackgroundType", string(SystemMsgCurrent.BackgroundType));
            ParamAdd(strParam, "LifeTime", string(SystemMsgCurrent.Lifetime * 1000));
            ParamAdd(strParam, "AnimationType", string(SystemMsgCurrent.AnimationType));
            ParamAdd(strParam, "Msg", MakeFullSystemMsg(SystemMsgCurrent.OnScrMsg, Schemestr));
            ParamAdd(strParam, "MsgColorR", string(SystemMsgCurrent.FontColor.R));
            ParamAdd(strParam, "MsgColorG", string(SystemMsgCurrent.FontColor.G));
            ParamAdd(strParam, "MsgColorB", string(SystemMsgCurrent.FontColor.B));
            ExecuteEvent(140, strParam);
            PlaySound(SystemMsgCurrent.Sound);
            setLootingBoxSelection(LootingScheme);            
        }
        else
        {
            // End:0x50D
            if(IsSuccess == 2)
            {
                Schemestr = util.getLootingString(LootingScheme);
                GetSystemMsgInfo(3138, SystemMsgCurrent);
                ParamAdd(strParam, "MsgType", string(1));
                ParamAdd(strParam, "WindowType", string(SystemMsgCurrent.WindowType));
                ParamAdd(strParam, "FontType", string(SystemMsgCurrent.FontType));
                ParamAdd(strParam, "BackgroundType", string(SystemMsgCurrent.BackgroundType));
                ParamAdd(strParam, "LifeTime", string(SystemMsgCurrent.Lifetime * 1000));
                ParamAdd(strParam, "AnimationType", string(SystemMsgCurrent.AnimationType));
                ParamAdd(strParam, "Msg", MakeFullSystemMsg(SystemMsgCurrent.OnScrMsg, Schemestr));
                ParamAdd(strParam, "MsgColorR", string(SystemMsgCurrent.FontColor.R));
                ParamAdd(strParam, "MsgColorG", string(SystemMsgCurrent.FontColor.G));
                ParamAdd(strParam, "MsgColorB", string(SystemMsgCurrent.FontColor.B));
                ExecuteEvent(140, strParam);
                PlaySound(SystemMsgCurrent.Sound);
                setLootingBoxSelection(LootingScheme);
            }
        }
    }
    return;
}

function OnAskPartyLootingModify(string a_Param)
{
    local string LeaderName;
    local int LootingScheme;
    local string Schemestr;
    local L2Util util;

    util = L2Util(GetScript("L2Util"));
    // End:0x3F
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("DialogBox"))
    {
        SetRequestPartyLootingModifyAgreement(false);
        return;
    }
    dScript.SetButtonName(184, 185);
    Class'Interface.UICommonAPI'.static.DialogSetID(9);
    Class'Interface.UICommonAPI'.static.DialogSetParamInt64((10 * 1000));
    Class'Interface.UICommonAPI'.static.DialogSetDefaultCancle();
    ParseString(a_Param, "LeaderName", LeaderName);
    ParseInt(a_Param, "LootingScheme", LootingScheme);
    Schemestr = util.getLootingString(LootingScheme);
    Class'Interface.UICommonAPI'.static.DialogShow(1, 7, MakeFullSystemMsg(GetSystemMessage(3134), Schemestr), string(self));
    return;
}

function UIActivationUponStateChanges(string a_Param)
{
    // End:0x8F
    if((((a_Param == "GAMINGSTATE") || a_Param == "ARENAGAMINGSTATE") || a_Param == "ARENABATTLESTATE") || a_Param == "ARENAPICKSTATE")
    {
        HandleSwitchEnterchatting();
        Class'NWindow.ShortcutAPI'.static.RequestList();
        isGAMINGSTATE = true;        
    }
    else
    {
        isGAMINGSTATE = false;
    }
    SetAlwaysOnTop(!isGAMINGSTATE);
    InitControlOption();
    return;
}

function setChattingOption()
{
    local ChatWnd script;
    local SystemMsgWnd SysMsgScript;
    local int tempVal, i, resultNum;

    script = ChatWnd(GetScript("ChatWnd"));
    SysMsgScript = SystemMsgWnd(GetScript("ChatWnd.SystemMsgWnd"));
    i = 0;
    J0x48:

    // End:0x575 [Loop If]
    if(i < script.m_sectionName.Length)
    {
        GetINIBool(script.m_sectionName[i], "system", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bSystem = tempVal;
        GetINIBool(script.m_sectionName[i], "useitems", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bUseitem = tempVal;
        GetINIBool(script.m_sectionName[i], "damage", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bDamage = tempVal;
        GetINIBool(script.m_sectionName[i], "chat", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bChat = tempVal;
        GetINIBool(script.m_sectionName[i], "normal", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bNormal = tempVal;
        GetINIBool(script.m_sectionName[i], "party", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bParty = tempVal;
        GetINIBool(script.m_sectionName[i], "shout", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bShout = tempVal;
        GetINIBool(script.m_sectionName[i], "market", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bTrade = tempVal;
        GetINIBool(script.m_sectionName[i], "pledge", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bClan = tempVal;
        GetINIBool(script.m_sectionName[i], "tell", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bWhisper = tempVal;
        GetINIBool(script.m_sectionName[i], "ally", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bAlly = tempVal;
        GetINIBool(script.m_sectionName[i], "hero", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bHero = tempVal;
        GetINIBool(script.m_sectionName[i], "union", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bUnion = tempVal;
        GetINIBool(script.m_sectionName[i], "nonpcmessage", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bNoNpcMessage = tempVal;
        GetINIBool(script.m_sectionName[i], "worldChat", tempVal, "chatfilter.ini");
        script.m_filterInfo[i].bWorldChat = tempVal;
        i++;
        // [Loop Continue]
        goto J0x48;
    }
    script.m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));
    GetINIBool("global", "keywordsound", resultNum, "chatfilter.ini");
    script.m_KeywordFilterSound = resultNum;
    GetINIBool("global", "keywordactivate", resultNum, "chatfilter.ini");
    script.m_KeywordFilterActivate = resultNum;
    GetINIBool("global", "UseAlpha", resultNum, "chatfilter.ini");
    script.m_UseAlpha = resultNum;
    GetINIBool("global", "ChatResizing", resultNum, "chatfilter.ini");
    script.m_ChatResizeOnOff = resultNum;
    GetINIBool("global", "SystemMsgWnd", resultNum, "chatfilter.ini");
    script.m_bUseSystemMsgWnd = resultNum;
    GetINIBool("global", "UseSystemMsg", resultNum, "chatfilter.ini");
    script.m_bSystemMsgWnd = resultNum;
    GetINIBool("global", "SystemMsgWndDamage", resultNum, "chatfilter.ini");
    script.m_bDamageOption = resultNum;
    GetINIBool("global", "SystemMsgWndExpendableItem", resultNum, "chatfilter.ini");
    script.m_bUseSystemItem = resultNum;
    GetINIBool("global", "UseWorldChatSpeaker", resultNum, "chatfilter.ini");
    script.m_bWorldChatSpeaker = resultNum;
    GetINIBool("global", "OnlyUseSystemMsgWnd", resultNum, "chatfilter.ini");
    script.m_bOnlyUseSystemMsgWnd = resultNum;
    GetINIString("global", "Keyword0", script.m_Keyword0, "chatfilter.ini");
    GetINIString("global", "Keyword1", script.m_Keyword1, "chatfilter.ini");
    GetINIString("global", "Keyword2", script.m_Keyword2, "chatfilter.ini");
    GetINIString("global", "Keyword3", script.m_Keyword3, "chatfilter.ini");
    // End:0x97F
    if(bool(script.m_bUseSystemMsgWnd))
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
    }
    // End:0x9B9
    if(bool(script.m_ChatResizeOnOff))
    {
        EnableChatWndResizing(false);        
    }
    else
    {
        EnableChatWndResizing(true);
    }
    script.SetDefaultAlpha(script.m_UseAlpha);
    SysMsgScript.SetDefaultAlpha(script.m_UseAlpha);
    script.GetAllcurrentAssignedChatTypeID();
    return;
}
