class ShortcutWnd extends UICommonAPI;

const MAX_Page = 15;
const MAX_ShortcutPerPage = 12;
const MAX_ShortcutPerPage2 = 24;
const MAX_ShortcutPerPage3 = 36;
const MAX_ShortcutPerPage4 = 48;

enum EJoyShortcut
{
    JOYSHORTCUT_Left,               // 0
    JOYSHORTCUT_Center,             // 1
    JOYSHORTCUT_Right               // 2
};

var WindowHandle AutoPotion;
var zAutoPotionWnd AutoPotionWnd;
var WindowHandle Me;
var int CurrentShortcutPage;
var int CurrentShortcutPage2;
var int CurrentShortcutPage3;
var bool m_IsLocked;
var bool m_IsVertical;
var bool m_IsJoypad;
var bool m_IsJoypadExpand;
var bool m_IsJoypadOn;
var int CurrentShortcutPage4;
var int CurrentShortcutPage5;
var int m_Expand;
var bool m_IsShortcutExpand;
var string m_ShortcutWndName;
var AutoShotItemWnd AutoShotItemWndScript;
var int trialsec;

function OnRegisterEvent()
{
    RegisterEvent(630);
    RegisterEvent(640);
    RegisterEvent(660);
    RegisterEvent(650);
    RegisterEvent(590);
    RegisterEvent(600);
    RegisterEvent(610);
    RegisterEvent(620);
    RegisterEvent(91);
    RegisterEvent(693);
    RegisterEvent(5090);
    RegisterEvent(5091);
    RegisterEvent(40);
    return;
}

function OnShow()
{
    LoadINIValues();
    // End:0xB3
    if(m_IsLocked)
    {
        Lock();
        GetButtonHandle("ShortcutAdditional1Wnd.LockBtn").SetTexture("L2UI_CH3.ShortcutWnd.joypad_lock", "L2UI_CH3.ShortcutWnd.joypad_lock_down", "L2UI_CH3.ShortcutWnd.joypad_lock");        
    }
    else
    {
        UNLOCK();
        GetButtonHandle("ShortcutAdditional1Wnd.LockBtn").SetTexture("L2UI_CH3.ShortcutWnd.joypad_unlock", "L2UI_CH3.ShortcutWnd.joypad_unlock_down", "L2UI_CH3.ShortcutWnd.joypad_unlock");
    }
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_1");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_1");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_2");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_2");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_3");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_3");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_4");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_4");
    ExpandByNum(m_Expand);
    SetVertical(m_IsVertical);
    ReAnchorPotion();
    ShortcutSettingsWnd(GetScript("ShortcutSettingsWnd")).updateAnchor();
    // End:0x34F
    if(trialsec <= 0)
    {
        trialsec = 44444;
    }
    GetTextBoxHandle("ChatWnd.a").HideWindow();
    return;
}

function ReAnchorPotion()
{
    local bool isSpecialSlot;

    isSpecialSlot = getIsSpecialSlotPlayer();
    AutoPotionWnd.Position(m_IsVertical);
    // End:0xAF
    if(!m_IsVertical)
    {
        // End:0x71
        if(isSpecialSlot)
        {
            AnchorAutoPotion("ShortcutWnd.ShortcutWndHorizontal" $ (getShortcutIndexStr()), 236, -30);            
        }
        else
        {
            AnchorAutoPotion("ShortcutWnd.ShortcutWndHorizontal" $ (getShortcutIndexStr()), 270, -30);
        }        
    }
    else
    {
        // End:0xF1
        if(isSpecialSlot)
        {
            AnchorAutoPotion("ShortcutWnd.ShortcutWndVertical" $ (getShortcutIndexStr()), -30, 236);            
        }
        else
        {
            AnchorAutoPotion("ShortcutWnd.ShortcutWndVertical" $ (getShortcutIndexStr()), -30, 270);
        }
    }
    return;
}

function bool IsPetSummonState()
{
    return (numToBool(Class'NWindow.UIDATA_PET'.static.GetSummonNum())) || Class'NWindow.UIDATA_PET'.static.IsHavePet();
    return;
}

function string getShortcutIndexStr()
{
    local int nIndex;
    local string RValue;

    nIndex = getExpandNum();
    // End:0x22
    if(nIndex <= 0)
    {
        RValue = "";        
    }
    else
    {
        RValue = "_" $ string(nIndex);
    }
    return RValue;
    return;
}

function AnchorAutoPotion(string window, int X, int Y)
{
    AutoPotion.SetAnchor(window, "TopLeft", "TopLeft", X, Y);
    return;
}

function OnTimer(int TimerID)
{
    // End:0x9F
    if(TimerID == 10000)
    {
        trialsec--;
        GetTextBoxHandle("ChatWnd.a").SetText((GetSystemString(3605) $ "\\n") $ (toTime(trialsec)));
        GetTextBoxHandle("ChatWnd.a").SetDraggable(true);
        GetTextBoxHandle("ChatWnd.a").ShowWindow();
        // End:0x9F
        if(trialsec <= 0)
        {
            GotoLogin();
            RequestExit();
            return;
        }
    }
    return;
}

function string toTime(int Sec)
{
    local string returnStr;
    local int RemainSec, m_timeDay, m_timeHour, m_timeMin, m_timeSec;

    m_timeDay = Sec / 86400;
    RemainSec = int(float(Sec) % float(86400));
    m_timeHour = RemainSec / 3600;
    RemainSec = int(float(RemainSec) % float(3600));
    m_timeMin = RemainSec / 60;
    m_timeSec = int(float(RemainSec) % float(60));
    returnStr = "";
    returnStr = string(m_timeDay) $ " d. ";
    // End:0xC5
    if(m_timeHour < 10)
    {
        returnStr = ((returnStr $ "0") $ string(m_timeHour)) $ " h. ";        
    }
    else
    {
        returnStr = (returnStr $ string(m_timeHour)) $ " h. ";
    }
    // End:0x111
    if(m_timeMin < 10)
    {
        returnStr = ((returnStr $ "0") $ string(m_timeMin)) $ " m. ";        
    }
    else
    {
        returnStr = (returnStr $ string(m_timeMin)) $ " m. ";
    }
    // End:0x15D
    if(m_timeSec < 10)
    {
        returnStr = ((returnStr $ "0") $ string(m_timeSec)) $ " s. ";        
    }
    else
    {
        returnStr = (returnStr $ string(m_timeSec)) $ " s. ";
    }
    return returnStr;
    return;
}

function LoadINIValues()
{
    local int tmpInt;

    GetINIInt("ShortcutWnd", "e", m_Expand, "WindowsInfo.ini");
    GetINIBool("ShortcutWnd", "l", tmpInt, "windowsInfo.ini");
    m_IsLocked = GetOptionBool("Game", "IsLockShortcutWnd");
    // End:0x91
    if(bool(tmpInt))
    {
        OnMaxBtn();        
    }
    else
    {
        OnMinBtn();
    }
    GetINIInt("ShortcutWnd", "v", tmpInt, "WindowsInfo.ini");
    m_IsVertical = bool(tmpInt);
    return;
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    return;
}

function OnLoad()
{
    local bool bMinTooltip;
    local ToolTip script;
    local int minTooltip;

    // End:0x15
    if(getInstanceUIData().getIsArenaServer())
    {
        return;
    }
    Me = GetWindowHandle("ShortcutWnd");
    AutoPotion = GetWindowHandle("AutoPotionWnd");
    AutoPotionWnd = zAutoPotionWnd(GetScript("AutoPotionWnd"));
    AutoShotItemWndScript = AutoShotItemWnd(GetScript("AutoShotItemWnd"));
    LoadINIValues();
    InitShortPageNum();
    GetINIBool("ShortcutWnd", "l", minTooltip, "windowsInfo.ini");
    bMinTooltip = bool(minTooltip);
    script = ToolTip(GetScript("Tooltip"));
    script.setBoolSelect(!bMinTooltip);
    // End:0x1E6
    if(bMinTooltip)
    {
        HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
        ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
        HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
        ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");        
    }
    else
    {
        ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
        HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
        ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
        HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");
    }
    return;
}

function OnDefaultPosition()
{
    // End:0x15
    if(getInstanceUIData().getIsArenaServer())
    {
        return;
    }
    // End:0x39
    if(GetOptionInt("Game", "LayoutDF") == 1)
    {
        m_Expand = 4;
    }
    ArrangeWnd();
    ExpandWnd();
    // End:0x68
    if(GetOptionInt("Game", "LayoutDF") == 1)
    {
        SetVertical(false);
    }
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x15
    if(getInstanceUIData().getIsArenaServer())
    {
        return;
    }
    ArrangeWnd();
    ExpandWnd();
    // End:0x36
    if(a_PreStateName == 'LoadingState')
    {
        InitShortPageNum();
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    // End:0x15
    if(getInstanceUIData().getIsArenaServer())
    {
        return;
    }
    switch(a_EventID)
    {
        // End:0xC7
        case 91:
            // End:0x6E
            if(GetWindowHandle("ShortcutSettingsWnd").IsShowWindow())
            {
                GetWindowHandle("ShortcutSettingsWnd").HideWindow();
            }
            // End:0xB9
            if(GetWindowHandle("AutoPotionParamWnd").IsShowWindow())
            {
                GetWindowHandle("AutoPotionParamWnd").HideWindow();
            }
            ExecuteShortcutCommandBySlot(a_Param);
            // End:0x37B
            break;
        // End:0x175
        case 640:
            // End:0x11C
            if(GetWindowHandle("ShortcutSettingsWnd").IsShowWindow())
            {
                GetWindowHandle("ShortcutSettingsWnd").HideWindow();
            }
            // End:0x167
            if(GetWindowHandle("AutoPotionParamWnd").IsShowWindow())
            {
                GetWindowHandle("AutoPotionParamWnd").HideWindow();
            }
            HandleShortcutPageUpdate(a_Param);
            // End:0x37B
            break;
        // End:0x18B
        case 660:
            HandleShortcutJoypad(a_Param);
            // End:0x37B
            break;
        // End:0x1A1
        case 590:
            HandleJoypadLButtonDown(a_Param);
            // End:0x37B
            break;
        // End:0x1B7
        case 600:
            HandleJoypadLButtonUp(a_Param);
            // End:0x37B
            break;
        // End:0x1CD
        case 610:
            HandleJoypadRButtonDown(a_Param);
            // End:0x37B
            break;
        // End:0x1E3
        case 620:
            HandleJoypadRButtonUp(a_Param);
            // End:0x37B
            break;
        // End:0x291
        case 630:
            // End:0x238
            if(GetWindowHandle("ShortcutSettingsWnd").IsShowWindow())
            {
                GetWindowHandle("ShortcutSettingsWnd").HideWindow();
            }
            // End:0x283
            if(GetWindowHandle("AutoPotionParamWnd").IsShowWindow())
            {
                GetWindowHandle("AutoPotionParamWnd").HideWindow();
            }
            HandleShortcutUpdate(a_Param);
            // End:0x37B
            break;
        // End:0x346
        case 650:
            // End:0x2E6
            if(GetWindowHandle("ShortcutSettingsWnd").IsShowWindow())
            {
                GetWindowHandle("ShortcutSettingsWnd").HideWindow();
            }
            // End:0x331
            if(GetWindowHandle("AutoPotionParamWnd").IsShowWindow())
            {
                GetWindowHandle("AutoPotionParamWnd").HideWindow();
            }
            HandleShortcutClear();
            ArrangeWnd();
            ExpandWnd();
            // End:0x37B
            break;
        // End:0x34E
        case 693:
        // End:0x356
        case 5090:
        // End:0x367
        case 5091:
            ClearAllShortcutItemTooltip();
            // End:0x37B
            break;
        // End:0x375
        case 40:
            InitShortPageNum();
            // End:0x37B
            break;
        // End:0xFFFF
        default:
            // End:0x37B
            break;
            break;
    }
    return;
}

function ClearAllShortcutItemTooltip()
{
    Me.ClearAllChildShortcutItemTooltip();
    return;
}

function InitShortPageNum()
{
    CurrentShortcutPage = 0;
    CurrentShortcutPage2 = 1;
    CurrentShortcutPage3 = 2;
    CurrentShortcutPage4 = 3;
    CurrentShortcutPage5 = 4;
    return;
}

function HandleShortcutPageUpdate(string param)
{
    local int i, nShortcutID, ShortcutPage;

    // End:0xFD
    if(ParseInt(param, "ShortcutPage", ShortcutPage))
    {
        // End:0x3C
        if((0 > ShortcutPage) || 15 <= ShortcutPage)
        {
            return;
        }
        CurrentShortcutPage = ShortcutPage;
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(("ShortcutWnd." $ m_ShortcutWndName) $ ".PageNumTextBox", string(CurrentShortcutPage + 1));
        nShortcutID = CurrentShortcutPage * 12;
        i = 0;
        J0x9E:

        // End:0xFD [Loop If]
        if(i < 12)
        {
            Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((("ShortcutWnd." $ m_ShortcutWndName) $ ".Shortcut") $ string(i + 1), nShortcutID);
            nShortcutID++;
            ++i;
            // [Loop Continue]
            goto J0x9E;
        }
    }
    return;
}

function HandleShortcutUpdate(string param)
{
    local int nShortcutID, nShortcutNum;

    ParseInt(param, "ShortcutID", nShortcutID);
    nShortcutNum = int((float(nShortcutID) % float(12)) + float(1));
    // End:0x88
    if(IsShortcutIDInCurPage(CurrentShortcutPage, nShortcutID))
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((("ShortcutWnd." $ m_ShortcutWndName) $ ".Shortcut") $ string(nShortcutNum), nShortcutID);
    }
    // End:0xDC
    if(IsShortcutIDInCurPage(CurrentShortcutPage2, nShortcutID))
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((("ShortcutWnd." $ m_ShortcutWndName) $ "_1.Shortcut") $ string(nShortcutNum), nShortcutID);
    }
    // End:0x130
    if(IsShortcutIDInCurPage(CurrentShortcutPage3, nShortcutID))
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((("ShortcutWnd." $ m_ShortcutWndName) $ "_2.Shortcut") $ string(nShortcutNum), nShortcutID);
    }
    // End:0x184
    if(IsShortcutIDInCurPage(CurrentShortcutPage4, nShortcutID))
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((("ShortcutWnd." $ m_ShortcutWndName) $ "_3.Shortcut") $ string(nShortcutNum), nShortcutID);
    }
    // End:0x1D8
    if(IsShortcutIDInCurPage(CurrentShortcutPage5, nShortcutID))
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut((("ShortcutWnd." $ m_ShortcutWndName) $ "_4.Shortcut") $ string(nShortcutNum), nShortcutID);
    }
    return;
}

function HandleShortcutClear()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x2A2 [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical.Shortcut" $ string(i + 1));
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical_1.Shortcut" $ string(i + 1));
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical_2.Shortcut" $ string(i + 1));
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndVertical_3.Shortcut" $ string(i + 1));
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal.Shortcut" $ string(i + 1));
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal_1.Shortcut" $ string(i + 1));
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal_2.Shortcut" $ string(i + 1));
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndHorizontal_3.Shortcut" $ string(i + 1));
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndJoypadExpand.Shortcut" $ string(i + 1));
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    i = 0;
    J0x2A9:

    // End:0x302 [Loop If]
    if(i < 4)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string(i + 1));
        ++i;
        // [Loop Continue]
        goto J0x2A9;
    }
    return;
}

function HandleShortcutJoypad(string a_Param)
{
    local int OnOff;

    // End:0xAF
    if(ParseInt(a_Param, "OnOff", OnOff))
    {
        // End:0x66
        if(1 == OnOff)
        {
            m_IsJoypadOn = true;
            // End:0x63
            if(Len(m_ShortcutWndName) > 0)
            {
                ShowWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".JoypadBtn");
            }            
        }
        else
        {
            // End:0xAF
            if(0 == OnOff)
            {
                m_IsJoypadOn = false;
                // End:0xAF
                if(Len(m_ShortcutWndName) > 0)
                {
                    HideWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".JoypadBtn");
                }
            }
        }
    }
    return;
}

function HandleJoypadLButtonUp(string a_Param)
{
    SetJoypadShortcut(1);
    return;
}

function HandleJoypadLButtonDown(string a_Param)
{
    SetJoypadShortcut(0);
    return;
}

function HandleJoypadRButtonUp(string a_Param)
{
    SetJoypadShortcut(1);
    return;
}

function HandleJoypadRButtonDown(string a_Param)
{
    SetJoypadShortcut(2);
    return;
}

function SetJoypadShortcut(ShortcutWnd.EJoyShortcut a_JoyShortcut)
{
    local int i, nShortcutID;

    switch(a_JoyShortcut)
    {
        // End:0x238
        case 0:
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "L2UI_CH3.ShortcutWnd.joypad2_back_over1");
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 28, 0);
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadLButtonTex", "L2UI_ch3.Joypad.joypad_L_HOLD");
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadRButtonTex", "L2UI_ch3.Joypad.joypad_R");
            nShortcutID = (CurrentShortcutPage * 12) + 4;
            i = 0;
            J0x1D0:

            // End:0x235 [Loop If]
            if(i < 4)
            {
                Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string(i + 1), nShortcutID);
                nShortcutID++;
                ++i;
                // [Loop Continue]
                goto J0x1D0;
            }
            // End:0x69A
            break;
        // End:0x460
        case 1:
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "L2UI_CH3.ShortcutWnd.joypad2_back_over2");
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 158, 0);
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadLButtonTex", "L2UI_ch3.Joypad.joypad_L");
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadRButtonTex", "L2UI_ch3.Joypad.joypad_R");
            nShortcutID = CurrentShortcutPage * 12;
            i = 0;
            J0x3F8:

            // End:0x45D [Loop If]
            if(i < 4)
            {
                Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string(i + 1), nShortcutID);
                nShortcutID++;
                ++i;
                // [Loop Continue]
                goto J0x3F8;
            }
            // End:0x69A
            break;
        // End:0x694
        case 2:
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "L2UI_CH3.ShortcutWnd.joypad2_back_over3");
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand.JoypadButtonBackTex", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 288, 0);
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadLButtonTex", "L2UI_ch3.Joypad.joypad_L");
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ShortcutWnd.ShortcutWndJoypad.JoypadRButtonTex", "L2UI_ch3.Joypad.joypad_R_HOLD");
            nShortcutID = (CurrentShortcutPage * 12) + 8;
            i = 0;
            J0x62C:

            // End:0x691 [Loop If]
            if(i < 4)
            {
                Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut("ShortcutWnd.ShortcutWndJoypad.Shortcut" $ string(i + 1), nShortcutID);
                nShortcutID++;
                ++i;
                // [Loop Continue]
                goto J0x62C;
            }
            // End:0x69A
            break;
        // End:0xFFFF
        default:
            // End:0x69A
            break;
            break;
    }
    return;
}

function OnClickButton(string a_strID)
{
    switch(a_strID)
    {
        // End:0x1C
        case "PrevBtn":
            OnPrevBtn();
            // End:0x279
            break;
        // End:0x31
        case "NextBtn":
            OnNextBtn();
            // End:0x279
            break;
        // End:0x47
        case "PrevBtn2":
            OnPrevBtn2();
            // End:0x279
            break;
        // End:0x5D
        case "NextBtn2":
            OnNextBtn2();
            // End:0x279
            break;
        // End:0x73
        case "PrevBtn3":
            OnPrevBtn3();
            // End:0x279
            break;
        // End:0x89
        case "NextBtn3":
            OnNextBtn3();
            // End:0x279
            break;
        // End:0x9E
        case "LockBtn":
            OnClickLockBtn();
            // End:0x279
            break;
        // End:0xB5
        case "UnlockBtn":
            OnClickUnlockBtn();
            // End:0x279
            break;
        // End:0x102
        case "RotateBtn":
            OnRotateBtn();
            ReAnchorPotion();
            AutoShotPositionAutoMove();
            ShortcutSettingsWnd(GetScript("ShortcutSettingsWnd")).updateAnchor();
            // End:0x279
            break;
        // End:0x119
        case "JoypadBtn":
            OnJoypadBtn();
            // End:0x279
            break;
        // End:0x130
        case "ExpandBtn":
            OnExpandBtn();
            // End:0x279
            break;
        // End:0x17A
        case "ExpandButton":
            OnClickExpandShortcutButton();
            ReAnchorPotion();
            ShortcutSettingsWnd(GetScript("ShortcutSettingsWnd")).updateAnchor();
            // End:0x279
            break;
        // End:0x1C4
        case "ReduceButton":
            OnClickExpandShortcutButton();
            ReAnchorPotion();
            ShortcutSettingsWnd(GetScript("ShortcutSettingsWnd")).updateAnchor();
            // End:0x279
            break;
        // End:0x1DA
        case "PrevBtn4":
            OnPrevBtn4();
            // End:0x279
            break;
        // End:0x1F0
        case "NextBtn4":
            OnNextBtn4();
            // End:0x279
            break;
        // End:0x206
        case "PrevBtn5":
            OnPrevBtn5();
            // End:0x279
            break;
        // End:0x21C
        case "NextBtn5":
            OnNextBtn5();
            // End:0x279
            break;
        // End:0x237
        case "TooltipMinBtn":
            OnMinBtn();
            // End:0x279
            break;
        // End:0x252
        case "TooltipMaxBtn":
            OnMaxBtn();
            // End:0x279
            break;
        // End:0x273
        case "ShortcutSettingsBtn":
            handleSettingsWnd();
            // End:0x279
            break;
        // End:0xFFFF
        default:
            // End:0x279
            break;
            break;
    }
    return;
}

function handleSettingsWnd()
{
    // End:0x50
    if(GetWindowHandle("ShortcutSettingsWnd").IsShowWindow())
    {
        GetWindowHandle("ShortcutSettingsWnd").HideWindow();        
    }
    else
    {
        GetWindowHandle("ShortcutSettingsWnd").ShowWindow();
    }
    return;
}

function OnMinBtn()
{
    local ToolTip script;

    HandleShortcutClear();
    ArrangeWnd();
    ExpandWnd();
    script = ToolTip(GetScript("Tooltip"));
    script.setBoolSelect(true);
    ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
    HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
    ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
    HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");
    SetINIBool("ShortcutWnd", "l", false, "windowsInfo.ini");
    return;
}

function OnMaxBtn()
{
    local ToolTip script;

    HandleShortcutClear();
    ArrangeWnd();
    ExpandWnd();
    script = ToolTip(GetScript("Tooltip"));
    script.setBoolSelect(false);
    ShowWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn");
    HideWindow("ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn");
    ShowWindow("ShortcutWnd.ShortcutWndVertical.TooltipMinBtn");
    HideWindow("ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn");
    SetINIBool("ShortcutWnd", "l", true, "windowsInfo.ini");
    return;
}

function OnPrevBtn()
{
    local int nNewPage;

    nNewPage = CurrentShortcutPage - 1;
    // End:0x24
    if(0 > nNewPage)
    {
        nNewPage = 15 - 1;
    }
    SetCurPage(nNewPage);
    return;
}

function OnPrevBtn2()
{
    local int nNewPage;

    nNewPage = CurrentShortcutPage2 - 1;
    // End:0x24
    if(0 > nNewPage)
    {
        nNewPage = 15 - 1;
    }
    SetCurPage2(nNewPage);
    return;
}

function OnPrevBtn3()
{
    local int nNewPage;

    nNewPage = CurrentShortcutPage3 - 1;
    // End:0x24
    if(0 > nNewPage)
    {
        nNewPage = 15 - 1;
    }
    SetCurPage3(nNewPage);
    return;
}

function OnNextBtn()
{
    local int nNewPage;

    nNewPage = CurrentShortcutPage + 1;
    // End:0x21
    if(15 <= nNewPage)
    {
        nNewPage = 0;
    }
    SetCurPage(nNewPage);
    return;
}

function OnNextBtn2()
{
    local int nNewPage;

    nNewPage = CurrentShortcutPage2 + 1;
    // End:0x21
    if(15 <= nNewPage)
    {
        nNewPage = 0;
    }
    SetCurPage2(nNewPage);
    return;
}

function OnNextBtn3()
{
    local int nNewPage;

    nNewPage = CurrentShortcutPage3 + 1;
    // End:0x21
    if(15 <= nNewPage)
    {
        nNewPage = 0;
    }
    SetCurPage3(nNewPage);
    return;
}

function OnPrevBtn4()
{
    local int nNewPage;

    nNewPage = CurrentShortcutPage4 - 1;
    // End:0x24
    if(0 > nNewPage)
    {
        nNewPage = 15 - 1;
    }
    SetCurPage4(nNewPage);
    return;
}

function OnNextBtn4()
{
    local int nNewPage;

    nNewPage = CurrentShortcutPage4 + 1;
    // End:0x21
    if(15 <= nNewPage)
    {
        nNewPage = 0;
    }
    SetCurPage4(nNewPage);
    return;
}

function OnPrevBtn5()
{
    local int nNewPage;

    nNewPage = CurrentShortcutPage5 - 1;
    // End:0x24
    if(0 > nNewPage)
    {
        nNewPage = 15 - 1;
    }
    SetCurPage5(nNewPage);
    return;
}

function OnNextBtn5()
{
    local int nNewPage;

    nNewPage = CurrentShortcutPage5 + 1;
    // End:0x21
    if(15 <= nNewPage)
    {
        nNewPage = 0;
    }
    SetCurPage5(nNewPage);
    return;
}

function OnClickLockBtn()
{
    ShortcutAdditional1Wnd(GetScript("ShortcutAdditional1Wnd")).checkLock(true);
    return;
}

function OnClickUnlockBtn()
{
    ShortcutAdditional1Wnd(GetScript("ShortcutAdditional1Wnd")).checkLock(true);
    return;
}

function OnRotateBtn()
{
    SetVertical(!m_IsVertical);
    // End:0x128
    if(m_IsVertical)
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndVertical", "ShortcutWnd.ShortcutWndHorizontal", "BottomRight", "BottomRight", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndVertical");
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndHorizontal", "ShortcutWnd.ShortcutWndVertical", "BottomRight", "BottomRight", 0, 0);        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndHorizontal", "ShortcutWnd.ShortcutWndVertical", "BottomRight", "BottomRight", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndHorizontal");
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndVertical", "ShortcutWnd.ShortcutWndHorizontal", "BottomRight", "BottomRight", 0, 0);
    }
    NoticeWnd(GetScript("NoticeWnd")).checkMultiLayOut();
    ExpandByNum(m_Expand);
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ShortcutWnd." $ m_ShortcutWndName);
    return;
}

function OnJoypadBtn()
{
    SetJoypad(!m_IsJoypad);
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ShortcutWnd." $ m_ShortcutWndName);
    return;
}

function OnExpandBtn()
{
    SetJoypadExpand(!m_IsJoypadExpand);
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ShortcutWnd." $ m_ShortcutWndName);
    return;
}

function SetCurPage(int a_nCurPage)
{
    // End:0x1B
    if((0 > a_nCurPage) || 15 <= a_nCurPage)
    {
        return;
    }
    Class'NWindow.ShortcutAPI'.static.SetShortcutPage(a_nCurPage);
    return;
}

function SetCurPage2(int a_nCurPage)
{
    local int i, nShortcutID;

    // End:0x1B
    if((0 > a_nCurPage) || 15 <= a_nCurPage)
    {
        return;
    }
    CurrentShortcutPage2 = a_nCurPage;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1") $ ".PageNumTextBox", string(CurrentShortcutPage2 + 1));
    nShortcutID = CurrentShortcutPage2 * 12;
    i = 0;
    J0x8F:

    // End:0x100 [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1") $ ".Shortcut") $ string(i + 1), nShortcutID);
        nShortcutID++;
        ++i;
        // [Loop Continue]
        goto J0x8F;
    }
    return;
}

function SetCurPage3(int a_nCurPage)
{
    local int i, nShortcutID;

    // End:0x1B
    if((0 > a_nCurPage) || 15 <= a_nCurPage)
    {
        return;
    }
    CurrentShortcutPage3 = a_nCurPage;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_2") $ ".PageNumTextBox", string(CurrentShortcutPage3 + 1));
    nShortcutID = CurrentShortcutPage3 * 12;
    i = 0;
    J0x9D:

    // End:0x11C [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_2") $ ".Shortcut") $ string(i + 1), nShortcutID);
        nShortcutID++;
        ++i;
        // [Loop Continue]
        goto J0x9D;
    }
    return;
}

function SetCurPage4(int a_nCurPage)
{
    local int i, nShortcutID;

    // End:0x1B
    if((0 > a_nCurPage) || 15 <= a_nCurPage)
    {
        return;
    }
    CurrentShortcutPage4 = a_nCurPage;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_3") $ ".PageNumTextBox", string(CurrentShortcutPage4 + 1));
    nShortcutID = CurrentShortcutPage4 * 12;
    i = 0;
    J0x9D:

    // End:0x11C [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_3") $ ".Shortcut") $ string(i + 1), nShortcutID);
        nShortcutID++;
        ++i;
        // [Loop Continue]
        goto J0x9D;
    }
    return;
}

function SetCurPage5(int a_nCurPage)
{
    local int i, nShortcutID;

    // End:0x1B
    if((0 > a_nCurPage) || 15 <= a_nCurPage)
    {
        return;
    }
    CurrentShortcutPage5 = a_nCurPage;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_4") $ ".PageNumTextBox", string(CurrentShortcutPage5 + 1));
    nShortcutID = CurrentShortcutPage5 * 12;
    i = 0;
    J0x9D:

    // End:0x11C [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(((((((("ShortcutWnd." $ m_ShortcutWndName) $ ".") $ m_ShortcutWndName) $ "_1.") $ m_ShortcutWndName) $ "_4") $ ".Shortcut") $ string(i + 1), nShortcutID);
        nShortcutID++;
        ++i;
        // [Loop Continue]
        goto J0x9D;
    }
    return;
}

function bool IsShortcutIDInCurPage(int PageNum, int a_nShortcutID)
{
    // End:0x15
    if((PageNum * 12) > a_nShortcutID)
    {
        return false;
    }
    // End:0x2D
    if(((PageNum + 1) * 12) <= a_nShortcutID)
    {
        return false;
    }
    return true;
    return;
}

function Lock()
{
    m_IsLocked = true;
    SetOptionBool("Game", "IsLockShortcutWnd", true);
    ShowWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".LockBtn");
    HideWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".UnlockBtn");
    return;
}

function UNLOCK()
{
    m_IsLocked = false;
    SetOptionBool("Game", "IsLockShortcutWnd", false);
    ShowWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".UnlockBtn");
    HideWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".LockBtn");
    return;
}

function SetVertical(bool a_IsVertical)
{
    m_IsVertical = a_IsVertical;
    SetINIInt("ShortcutWnd", "v", int(m_IsVertical), "WindowsInfo.ini");
    ArrangeWnd();
    ExpandWnd();
    return;
}

function SetJoypad(bool a_IsJoypad)
{
    m_IsJoypad = a_IsJoypad;
    ArrangeWnd();
    return;
}

function SetJoypadExpand(bool a_IsJoypadExpand)
{
    m_IsJoypadExpand = a_IsJoypadExpand;
    // End:0xB4
    if(m_IsJoypadExpand)
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypadExpand", "ShortcutWnd.ShortcutWndJoypad", "TopLeft", "TopLeft", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndJoypadExpand");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("ShortcutWnd.ShortcutWndJoypad", "ShortcutWnd.ShortcutWndJoypadExpand", "TopLeft", "TopLeft", 0, 0);
        Class'NWindow.UIAPI_WINDOW'.static.ClearAnchor("ShortcutWnd.ShortcutWndJoypad");
    }
    ArrangeWnd();
    return;
}

function ArrangeWnd()
{
    local Rect WindowRect;

    // End:0x140
    if(m_IsJoypad)
    {
        HideWindow("ShortcutWnd.ShortcutWndVertical");
        HideWindow("ShortcutWnd.ShortcutWndHorizontal");
        // End:0xD4
        if(m_IsJoypadExpand)
        {
            HideWindow("ShortcutWnd.ShortcutWndJoypad");
            ShowWindow("ShortcutWnd.ShortcutWndJoypadExpand");
            m_ShortcutWndName = "ShortcutWndJoypadExpand";            
        }
        else
        {
            HideWindow("ShortcutWnd.ShortcutWndJoypadExpand");
            ShowWindow("ShortcutWnd.ShortcutWndJoypad");
            m_ShortcutWndName = "ShortcutWndJoypad";
        }        
    }
    else
    {
        HideWindow("ShortcutWnd.ShortcutWndJoypadExpand");
        HideWindow("ShortcutWnd.ShortcutWndJoypad");
        // End:0x288
        if(m_IsVertical)
        {
            m_ShortcutWndName = "ShortcutWndVertical";
            WindowRect = Class'NWindow.UIAPI_WINDOW'.static.GetRect("ShortcutWnd.ShortcutWndVertical");
            // End:0x235
            if(WindowRect.nY < 0)
            {
                Class'NWindow.UIAPI_WINDOW'.static.MoveTo("ShortcutWnd.ShortcutWndVertical", WindowRect.nX, 0);
            }
            HideWindow("ShortcutWnd.ShortcutWndHorizontal");
            ShowWindow("ShortcutWnd.ShortcutWndVertical");            
        }
        else
        {
            m_ShortcutWndName = "ShortcutWndHorizontal";
            WindowRect = Class'NWindow.UIAPI_WINDOW'.static.GetRect("ShortcutWnd.ShortcutWndHorizontal");
            // End:0x32A
            if(WindowRect.nX < 0)
            {
                Class'NWindow.UIAPI_WINDOW'.static.MoveTo("ShortcutWnd.ShortcutWndHorizontal", 0, WindowRect.nY);
            }
            HideWindow("ShortcutWnd.ShortcutWndVertical");
            ShowWindow("ShortcutWnd.ShortcutWndHorizontal");
        }
        // End:0x3AF
        if(m_IsJoypadOn)
        {
            ShowWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".JoypadBtn");            
        }
        else
        {
            HideWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".JoypadBtn");
        }
    }
    // End:0x485
    if(m_IsLocked)
    {
        Lock();
        GetButtonHandle("ShortcutAdditional1Wnd.LockBtn").SetTexture("L2UI_CH3.ShortcutWnd.joypad_lock", "L2UI_CH3.ShortcutWnd.joypad_lock_down", "L2UI_CH3.ShortcutWnd.joypad_lock");        
    }
    else
    {
        UNLOCK();
        GetButtonHandle("ShortcutAdditional1Wnd.LockBtn").SetTexture("L2UI_CH3.ShortcutWnd.joypad_unlock", "L2UI_CH3.ShortcutWnd.joypad_unlock_down", "L2UI_CH3.ShortcutWnd.joypad_unlock");
    }
    SetCurPage(CurrentShortcutPage);
    SetCurPage2(CurrentShortcutPage2);
    SetCurPage3(CurrentShortcutPage3);
    SetCurPage4(CurrentShortcutPage4);
    SetCurPage5(CurrentShortcutPage5);
    m_IsShortcutExpand = m_Expand != 4;
    HandleExpandButton();
    return;
}

function ExpandWnd()
{
    // End:0x21
    if(m_Expand > 0)
    {
        m_IsShortcutExpand = false;
        ExpandByNum(m_Expand);        
    }
    else
    {
        m_IsShortcutExpand = true;
        Reduce();
    }
    return;
}

function ExpandByNum(int expandNum)
{
    m_IsShortcutExpand = true;
    m_Expand = expandNum;
    switch(expandNum)
    {
        // End:0x85
        case 4:
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_4");
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_4");
        // End:0xF0
        case 3:
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_3");
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_3");
        // End:0x15B
        case 2:
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_2");
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_2");
        // End:0x1C8
        case 1:
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_1");
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_1");
            // End:0x1CE
            break;
        // End:0xFFFF
        default:
            // End:0x1CE
            break;
            break;
    }
    SetINIInt("ShortcutWnd", "e", m_Expand, "WindowsInfo.ini");
    HandleExpandButton();
    AutoShotItemWndScript.windowPositionAutoMove();
    AutoShotItemWndScript.checkSlotShowState();
    return;
}

function Reduce()
{
    m_IsShortcutExpand = true;
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_1");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_2");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_1");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_2");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_3");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_3");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_4");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_4");
    m_Expand = 0;
    SetINIInt("ShortcutWnd", "e", m_Expand, "WindowsInfo.ini");
    HandleExpandButton();
    AutoShotItemWndScript.windowPositionAutoMove();
    AutoShotItemWndScript.checkSlotShowState();
    return;
}

function OnClickExpandShortcutButton()
{
    // End:0x15
    if(m_Expand == 4)
    {
        Reduce();        
    }
    else
    {
        ExpandByNum(m_Expand + 1);
    }
    AutoShotPositionAutoMove();
    ReAnchorPotion();
    return;
}

function ExecuteShortcutCommandBySlot(string param)
{
    local int Slot;

    ParseInt(param, "Slot", Slot);
    // End:0x134
    if(Me.IsShowWindow())
    {
        // End:0x63
        if((Slot >= 0) && Slot < 12)
        {
            Class'NWindow.ShortcutAPI'.static.ExecuteShortcutBySlot((CurrentShortcutPage * 12) + Slot);            
        }
        else
        {
            // End:0xA7
            if((Slot >= 12) && Slot < (12 * 2))
            {
                Class'NWindow.ShortcutAPI'.static.ExecuteShortcutBySlot(((CurrentShortcutPage2 * 12) + Slot) - 12);                
            }
            else
            {
                // End:0xEF
                if((Slot >= (12 * 2)) && Slot < (12 * 3))
                {
                    Class'NWindow.ShortcutAPI'.static.ExecuteShortcutBySlot(((CurrentShortcutPage3 * 12) + Slot) - 24);                    
                }
                else
                {
                    // End:0x134
                    if((Slot >= (12 * 3)) && Slot < (12 * 4))
                    {
                        Class'NWindow.ShortcutAPI'.static.ExecuteShortcutBySlot(((CurrentShortcutPage4 * 12) + Slot) - 36);
                    }
                }
            }
        }
    }
    return;
}

function HandleExpandButton()
{
    // End:0x64
    if(m_IsShortcutExpand)
    {
        ShowWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".ExpandButton");
        HideWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".ReduceButton");        
    }
    else
    {
        HideWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".ExpandButton");
        ShowWindow(("ShortcutWnd." $ m_ShortcutWndName) $ ".ReduceButton");
    }
    return;
}

function bool IsVertical()
{
    return m_IsVertical;
    return;
}

function int getExpandNum()
{
    return m_Expand;
    return;
}

function AutoShotPositionAutoMove()
{
    AutoShotItemWndScript.windowPositionAutoMove();
    AutoShotItemWndScript.checkSlotShowState();
    return;
}

defaultproperties
{
    m_IsVertical=true
}