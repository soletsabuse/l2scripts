class ShortcutSettingsWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var CheckBoxHandle AutoShotONOFF;
var CheckBoxHandle AutoPotionsONOFF;
var CheckBoxHandle AddShortcutONOFF;
var CheckBoxHandle SetPanelONOFF;
var CheckBoxHandle LifeStonePanelONOFF;

function OnRegisterEvent()
{
    RegisterEvent(150);
    return;
}

function OnEvent(int EventID, string param)
{
    // End:0x141
    if(!GetOptionBool("Shortcut", "FirstLoad"))
    {
        AutoShotONOFF.SetCheck(true);
        AutoPotionsONOFF.SetCheck(true);
        AddShortcutONOFF.SetCheck(false);
        SetPanelONOFF.SetCheck(false);
        LifeStonePanelONOFF.SetCheck(false);
        SetOptionInt("Shortcut", "AutoShotONOFF", 1);
        SetOptionInt("Shortcut", "AutoPotionsONOFF", 1);
        SetOptionInt("Shortcut", "AddShortcutONOFF", 0);
        SetOptionInt("Shortcut", "SetPanelONOFF", 0);
        SetOptionInt("Shortcut", "LifeStonePanelONOFF", 0);
        SetOptionBool("Shortcut", "FirstLoad", true);
        updateWindows();        
    }
    else
    {
        CheckBoxesLoad();
        updateWindows();
    }
    return;
}

function OnLoad()
{
    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    AutoShotONOFF = GetCheckBoxHandle(m_WindowName $ ".AutoShotONOFF");
    AutoPotionsONOFF = GetCheckBoxHandle(m_WindowName $ ".AutoPotionsONOFF");
    AddShortcutONOFF = GetCheckBoxHandle(m_WindowName $ ".AddShortcutONOFF");
    SetPanelONOFF = GetCheckBoxHandle(m_WindowName $ ".SetPanelONOFF");
    LifeStonePanelONOFF = GetCheckBoxHandle(m_WindowName $ ".LifeStonePanelONOFF");
    SetClosingOnESC();
    return;
}

function CheckBoxesLoad()
{
    local int nTmp;

    nTmp = GetOptionInt("Shortcut", "AutoShotONOFF");
    AutoShotONOFF.SetCheck(bool(nTmp));
    nTmp = GetOptionInt("Shortcut", "AutoPotionsONOFF");
    AutoPotionsONOFF.SetCheck(bool(nTmp));
    nTmp = GetOptionInt("Shortcut", "AddShortcutONOFF");
    AddShortcutONOFF.SetCheck(bool(nTmp));
    nTmp = GetOptionInt("Shortcut", "SetPanelONOFF");
    SetPanelONOFF.SetCheck(bool(nTmp));
    nTmp = GetOptionInt("Shortcut", "LifeStonePanelONOFF");
    LifeStonePanelONOFF.SetCheck(bool(nTmp));
    return;
}

function OnClickButton(string strID)
{
    Me.HideWindow();
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x51
        case "AutoShotONOFF":
            SetOptionInt("Shortcut", "AutoShotONOFF", int(!AutoShotONOFF.IsChecked()) ^ 1);
            // End:0x197
            break;
        // End:0xA1
        case "AutoPotionsONOFF":
            SetOptionInt("Shortcut", "AutoPotionsONOFF", int(!AutoPotionsONOFF.IsChecked()) ^ 1);
            // End:0x197
            break;
        // End:0xF1
        case "AddShortcutONOFF":
            SetOptionInt("Shortcut", "AddShortcutONOFF", int(!AddShortcutONOFF.IsChecked()) ^ 1);
            // End:0x197
            break;
        // End:0x13B
        case "SetPanelONOFF":
            SetOptionInt("Shortcut", "SetPanelONOFF", int(!SetPanelONOFF.IsChecked()) ^ 1);
            // End:0x197
            break;
        // End:0x191
        case "LifeStonePanelONOFF":
            SetOptionInt("Shortcut", "LifeStonePanelONOFF", int(!LifeStonePanelONOFF.IsChecked()) ^ 1);
            // End:0x197
            break;
        // End:0xFFFF
        default:
            // End:0x197
            break;
            break;
    }
    ini(1);
    updateWindows();
    return;
}

function updateWindows()
{
    local bool bShortcutVertical;

    bShortcutVertical = ShortcutWnd(GetScript("ShortcutWnd")).m_IsVertical;
    // End:0x85
    if(AutoShotONOFF.IsChecked())
    {
        AutoShotItemWnd(GetScript("AutoShotItemWnd")).checkSlotShowState();
        GetWindowHandle("AutoShotItemWnd").ShowWindow();        
    }
    else
    {
        GetWindowHandle("AutoShotItemWnd").HideWindow();
    }
    // End:0x105
    if(AutoPotionsONOFF.IsChecked())
    {
        zAutoPotionWnd(GetScript("zAutoPotionWnd")).Position(bShortcutVertical);
        GetWindowHandle("AutoPotionWnd").ShowWindow();        
    }
    else
    {
        GetWindowHandle("AutoPotionWnd").HideWindow();
    }
    // End:0x161
    if(AddShortcutONOFF.IsChecked())
    {
        GetWindowHandle("ShortcutAdditional1Wnd").ShowWindow();        
    }
    else
    {
        GetWindowHandle("ShortcutAdditional1Wnd").HideWindow();
    }
    // End:0x1C3
    if(SetPanelONOFF.IsChecked())
    {
        GetWindowHandle("SetItemAutoEquipWnd").ShowWindow();        
    }
    else
    {
        GetWindowHandle("SetItemAutoEquipWnd").HideWindow();
    }
    // End:0x21D
    if(LifeStonePanelONOFF.IsChecked())
    {
        GetWindowHandle("RefineryUseWnd").ShowWindow();        
    }
    else
    {
        GetWindowHandle("RefineryUseWnd").HideWindow();
    }
    updateAnchor();
    return;
}

function updateAnchor()
{
    local bool bShortcutVertical;

    bShortcutVertical = ShortcutWnd(GetScript("ShortcutWnd")).m_IsVertical;
    // End:0x86
    if(bShortcutVertical)
    {
        Me.SetAnchor("ShortcutWnd.ShortcutWndVertical", "TopRight", "BottomRight", -3, -10);        
    }
    else
    {
        Me.SetAnchor("ShortcutWnd.ShortcutWndHorizontal", "TopLeft", "BottomRight", -3, -10);
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
