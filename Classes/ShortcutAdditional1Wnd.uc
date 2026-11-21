class ShortcutAdditional1Wnd extends UICommonAPI;

const MAX_ShortcutPerPage = 12;
const FSShortcutPage = 15;
const SLOT_SPACE = 37;
const ROW_SPACE = 5;

var int preSlot;
var WindowHandle Me;
var WindowHandle horShortcut;
var WindowHandle verShortcut;
var WindowHandle ShortcutAdditional1SettingsWnd;
var ShortcutAdditional1SettingsWnd ShortcutAdditional1SettingsWnd_scr;
var ButtonHandle btnSettings;
var array<TextureHandle> horBackdrops;
var array<TextureHandle> verBackdrops;
var int nView;

function OnRegisterEvent()
{
    RegisterEvent(150);
    RegisterEvent(91);
    RegisterEvent(3801);
    RegisterEvent(640);
    RegisterEvent(630);
    RegisterEvent(650);
    return;
}

function OnHide()
{
    ShortcutAdditional1SettingsWnd.HideWindow();
    return;
}

function OnLoad()
{
    local int i, R, C;

    Me = GetWindowHandle("ShortcutAdditional1Wnd");
    horShortcut = GetWindowHandle("ShortcutAdditional1Wnd.horShortcut");
    verShortcut = GetWindowHandle("ShortcutAdditional1Wnd.verShortcut");
    ShortcutAdditional1SettingsWnd = GetWindowHandle("ShortcutAdditional1SettingsWnd");
    ShortcutAdditional1SettingsWnd_scr = ShortcutAdditional1SettingsWnd(GetScript("ShortcutAdditional1SettingsWnd"));
    btnSettings = GetButtonHandle("ShortcutAdditional1Wnd.btnSettings");
    i = 0;
    J0x118:

    // End:0x1C2 [Loop If]
    if(i < 12)
    {
        horBackdrops[i] = GetTextureHandle("ShortcutAdditional1Wnd.HorShortcut.bakdrop" $ string(i + 1));
        verBackdrops[i] = GetTextureHandle("ShortcutAdditional1Wnd.VerShortcut.bakdrop" $ string(i + 1));
        i++;
        // [Loop Continue]
        goto J0x118;
    }
    ShortCutUpdateAll();
    return;
}

function Init()
{
    local int t, R, C;
    local byte bv;

    t = GetOptionInt(GetMyName(), "PANEL_1_TYPE");
    getCase(t, R, C, bv);
    // End:0x6C
    if((R > 0) && C > 0)
    {
        switchView(R, C, bool(bv));        
    }
    else
    {
        switchView(1, 12, false);
    }
    ShortcutAdditional1SettingsWnd_scr.ViewSlider.SetCurrentTick(t);
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x15
        case 150:
            Init();
            // End:0x7F
            break;
        // End:0x28
        case 91:
            ExecuteShortcutCommandBySlot(a_Param);
            // End:0x7F
            break;
        // End:0x3E
        case 3801:
            OnReserveShortCut(a_Param);
            // End:0x7F
            break;
        // End:0x54
        case 630:
            HandleShortcutUpdate(a_Param);
            // End:0x7F
            break;
        // End:0x65
        case 640:
            ShortCutUpdateAll();
            // End:0x7F
            break;
        // End:0x76
        case 650:
            HandleShortcutClear();
            // End:0x7F
            break;
        // End:0xFFFF
        default:
            // End:0x7F
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07F
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07F
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07F
}

function OnClickButton(string Id)
{
    switch(Id)
    {
        // End:0x5C
        case "btnSettings":
            // End:0x3B
            if(ShortcutAdditional1SettingsWnd.IsShowWindow())
            {
                ShortcutAdditional1SettingsWnd.HideWindow();                
            }
            else
            {
                ShortcutAdditional1SettingsWnd.ShowWindow();
                ShortcutAdditional1SettingsWnd.SetFocus();
            }
            // End:0x78
            break;
        // End:0x72
        case "LockBtn":
            checkLock(true);
            // End:0x78
            break;
        // End:0xFFFF
        default:
            // End:0x78
            break;
            break;
    }
    return;
}

function checkLock(optional bool bSwitch)
{
    // End:0xF0
    if(!ShortcutWnd(GetScript("ShortcutWnd")).m_IsLocked)
    {
        // End:0x52
        if(bSwitch)
        {
            ShortcutWnd(GetScript("ShortcutWnd")).Lock();
        }
        GetButtonHandle("ShortcutAdditional1Wnd.LockBtn").SetTexture("L2UI_CH3.ShortcutWnd.joypad_lock", "L2UI_CH3.ShortcutWnd.joypad_lock_down", "L2UI_CH3.ShortcutWnd.joypad_lock");        
    }
    else
    {
        // End:0x11B
        if(bSwitch)
        {
            ShortcutWnd(GetScript("ShortcutWnd")).UNLOCK();
        }
        GetButtonHandle("ShortcutAdditional1Wnd.LockBtn").SetTexture("L2UI_CH3.ShortcutWnd.joypad_unlock", "L2UI_CH3.ShortcutWnd.joypad_unlock_down", "L2UI_CH3.ShortcutWnd.joypad_unlock");
    }
    return;
}

function changeView(int N)
{
    local int R, C;
    local byte bv;

    nView = N;
    getCase(nView, R, C, bv);
    SetOptionInt(GetMyName(), "PANEL_1_TYPE", nView);
    ini(1);
    switchView(R, C, bool(bv));
    return;
}

function getCase(int Case, out int row, out int Col, out byte bVertical)
{
    switch(Case)
    {
        // End:0x25
        case 0:
            row = 1;
            Col = 12;
            bVertical = 0;
            // End:0xC9
            break;
        // End:0x44
        case 1:
            row = 2;
            Col = 6;
            bVertical = 0;
            // End:0xC9
            break;
        // End:0x64
        case 2:
            row = 3;
            Col = 4;
            bVertical = 0;
            // End:0xC9
            break;
        // End:0x84
        case 3:
            row = 4;
            Col = 3;
            bVertical = 0;
            // End:0xC9
            break;
        // End:0xA4
        case 4:
            row = 6;
            Col = 2;
            bVertical = 1;
            // End:0xC9
            break;
        // End:0xC3
        case 5:
            row = 12;
            Col = 1;
            bVertical = 1;
            // End:0xC9
            break;
        // End:0xFFFF
        default:
            // End:0xC9
            break;
            break;
    }
    return;
}

function switchView(int Rows, int cols, coerce bool bVertical)
{
    local int i, Index, row, Col, SLOT_WIDTH, totalCols,
	    totalSlots, panelWidth;

    SLOT_WIDTH = 37;
    totalCols = 12;
    totalSlots = Rows * cols;
    panelWidth = cols * SLOT_WIDTH;
    // End:0x51
    if((float(panelWidth) % float(2)) == float(0))
    {
        panelWidth += 1;
    }
    // End:0xF0
    if(!bVertical)
    {
        Me.SetWindowSize((22 + panelWidth) + 20, Rows * 40);
        horShortcut.ShowWindow();
        verShortcut.HideWindow();
        btnSettings.SetAnchor("ShortcutAdditional1Wnd.HorShortcut", "TopRight", "TopRight", -2, 3);        
    }
    else
    {
        Me.SetWindowSize(4 + panelWidth, (Rows * 40) + 37);
        horShortcut.HideWindow();
        verShortcut.ShowWindow();
        btnSettings.SetAnchor("ShortcutAdditional1Wnd.VerShortcut", "BottomLeft", "BottomLeft", 3, -3);
    }
    i = 0;
    J0x18C:

    // End:0x29F [Loop If]
    if(i < totalSlots)
    {
        row = i / cols;
        Col = int(float(i) % float(cols));
        horBackdrops[i].SetAnchor("ShortcutAdditional1Wnd.HorShortcut", "TopLeft", "TopLeft", 20 + (Col * SLOT_WIDTH), 3 + (row * 40));
        verBackdrops[i].SetAnchor("ShortcutAdditional1Wnd.VerShortcut", "TopLeft", "TopLeft", 2 + (Col * SLOT_WIDTH), 20 + (row * 40));
        i++;
        // [Loop Continue]
        goto J0x18C;
    }
    return;
}

function ShortCutUpdateAll()
{
    local int nShortcutID, i;

    nShortcutID = 12 * 15;
    i = 0;
    J0x13:

    // End:0xCA [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutAdditional1Wnd.HorShortcut.Shortcut" $ string(i + 1), nShortcutID);
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutAdditional1Wnd.VerShortcut.Shortcut" $ string(i + 1), nShortcutID);
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
    nShortcutNum = (nShortcutID - (12 * 15)) + 1;
    // End:0xE2
    if((nShortcutNum > 0) && nShortcutNum < (12 + 1))
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutAdditional1Wnd.HorShortcut.Shortcut" $ string(nShortcutNum), nShortcutID);
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutAdditional1Wnd.VerShortcut.Shortcut" $ string(nShortcutNum), nShortcutID);
    }
    return;
}

function HandleShortcutClear()
{
    local int i;

    i = 0;
    J0x07:

    // End:0xAD [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutAdditional1Wnd.HorShortcut.Shortcut" $ string(i + 1));
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutAdditional1Wnd.VerShortcut.Shortcut" $ string(i + 1));
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
    if((Slot >= (12 * 15)) && Slot < (12 * (15 + 1)))
    {
        Class'NWindow.ShortcutAPI'.static.ExecuteShortcutBySlot(Slot);
    }
    return;
}

function OnReserveShortCut(string a_Param)
{
    local int Slot, slotFromOne;

    ParseInt(a_Param, "Slot", Slot);
    // End:0x82
    if((Slot >= (12 * 15)) && Slot < (12 * (15 + 1)))
    {
        slotFromOne = (Slot - (12 * 15)) + 1;
        // End:0x77
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
