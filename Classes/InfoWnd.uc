class InfoWnd extends UICommonAPI;

const TOPPING_MAX = 6;
const TOPPING_ICON_WH = 22;
const WINDOW_H_MIN = 2;
const WINDOW_H_GAP = 2;
const WINDOWS_MAX = 4;

var int m_TotalPoint;
var int m_AddPoint;
var int m_PeriodType;
var int m_RemainTime;
var int m_PointType;
var string m_ToppingWndName;
var string m_VPWndName;
var string m_PCCafeWndwName;
var string m_MysteriousMansionWaitingWndName;
var string m_WindowName;
var TextureHandle windowBackground;
var WindowHandle Me;
var WindowHandle ToppingWnd;
var array<StatusIconHandle> toppingStatusIcons;
var array<TextureHandle> toppingDisableTextures;
var array<ToppingSkillExtraInfo> toppingDefaultInfos;
var WindowHandle VPWnd;
var TextureHandle VpIcon;
var StatusBarHandle VpDetailBar;
var int nVitalityBonus;
var int nVitalityExtraBonus;
var int nVitalityItemMaxRestoreCount;
var bool isAfterStatusNormaEvent;
var bool isVPApply;
var WindowHandle PCCafeEventWnd;
var WindowHandle HelpButton;
var WindowHandle MysteriousMansionWaitingWnd;
var WindowHandle MHelpButton;
var ButtonHandle MCancelButton;
var array<WindowHandle> allWindow;
var bool m_bIsPCCafeEvent;
var bool bIsOptionValue;
var bool bIsShowBackup;
var bool isEnterState;
var bool isShowInfoWnd;

function OnRegisterEvent()
{
    RegisterEvent(150);
    RegisterEvent(161);
    RegisterEvent(950);
    RegisterEvent(180);
    RegisterEvent(4110);
    RegisterEvent(1910);
    RegisterEvent(531);
    RegisterEvent(9310);
    RegisterEvent(9320);
    RegisterEvent(40);
    RegisterEvent(8000);
    return;
}

function OnLoad()
{
    local int i;

    VPWnd = GetWindowHandle(m_VPWndName);
    VpDetailBar = GetStatusBarHandle(m_VPWndName $ ".VpDetailBar");
    VpIcon = GetTextureHandle(m_VPWndName $ ".VPIcon");
    PCCafeEventWnd = GetWindowHandle(m_PCCafeWndwName);
    HelpButton = GetWindowHandle(m_PCCafeWndwName $ ".HelpButton");
    ToppingWnd = GetWindowHandle(m_ToppingWndName);
    toppingStatusIcons.Length = 6;
    i = 0;
    J0xA0:

    // End:0x133 [Loop If]
    if(i < 6)
    {
        toppingStatusIcons[i] = GetStatusIconHandle((m_ToppingWndName $ ".StatusIcon") $ string(i + 1));
        toppingStatusIcons[i].Clear();
        toppingDisableTextures[i] = GetTextureHandle((m_ToppingWndName $ ".toppingDisable") $ string(i + 1));
        i++;
        // [Loop Continue]
        goto J0xA0;
    }
    MysteriousMansionWaitingWnd = GetWindowHandle(m_MysteriousMansionWaitingWndName);
    MHelpButton = GetWindowHandle(m_MysteriousMansionWaitingWndName $ ".MHelpButton");
    MHelpButton.SetTooltipCustomType(getCustomTooltip(GetSystemString(2812)));
    MCancelButton = GetButtonHandle(m_MysteriousMansionWaitingWndName $ ".MCancelButton");
    Me = GetWindowHandle(m_WindowName);
    windowBackground = GetTextureHandle(m_WindowName $ ".CTextureCtrl939");
    setWindowOrder();
    m_bIsPCCafeEvent = false;
    return;
}

function setWindowOrder()
{
    local int i;

    allWindow.Length = 4;
    allWindow[i++] = ToppingWnd;
    allWindow[i++] = VPWnd;
    allWindow[i++] = PCCafeEventWnd;
    allWindow[i++] = MysteriousMansionWaitingWnd;
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x15
        case 150:
            handleOnGamingStateEnter();
            // End:0x179
            break;
        // End:0x48
        case 161:
            // End:0x45
            if(!getInstanceUIData().getIsClassicServer())
            {
                bIsShowBackup = PCCafeEventWnd.IsShowWindow();
            }
            // End:0x179
            break;
        // End:0x9B
        case 950:
            // End:0x98
            if(int(GetLanguage()) == int(0))
            {
                handleBuffEvent(a_Param);
                // End:0x98
                if(getInstanceUIData().getIsClassicServer())
                {
                    // End:0x98
                    if(!isAfterStatusNormaEvent)
                    {
                        isAfterStatusNormaEvent = true;
                        showVPSystemMsg();
                    }
                }
            }
            // End:0x179
            break;
        // End:0xA9
        case 180:
            handleVPPoint();
            // End:0x179
            break;
        // End:0xE3
        case 4110:
            // End:0xE0
            if(int(GetLanguage()) == int(0))
            {
                // End:0xE0
                if(getInstanceUIData().getIsClassicServer())
                {
                    HandleVitalityEffectInfo(a_Param);
                }
            }
            // End:0x179
            break;
        // End:0xF9
        case 1910:
            HandlePCCafePointInfo(a_Param);
            // End:0x179
            break;
        // End:0x10A
        case 531:
            HandleToggleShowPCCafeEventWnd();
            // End:0x179
            break;
        // End:0x11E
        case 40:
            setWindowShowHide(MysteriousMansionWaitingWnd, false);
            // End:0x179
            break;
        // End:0x135
        case 9320:
            setWindowShowHide(MysteriousMansionWaitingWnd, false);
            // End:0x179
            break;
        // End:0x14B
        case 9310:
            CuriousHouseHandle(a_Param);
            // End:0x179
            break;
        // End:0x176
        case 8000:
            MHelpButton.SetTooltipCustomType(getCustomTooltip(GetSystemString(2812)));
            // End:0x179
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string a_ButtonID)
{
    switch(a_ButtonID)
    {
        // End:0x20
        case "CloseButton":
            HandleToggleShowPCCafeEventWnd();
            // End:0x55
            break;
        // End:0x37
        case "PCCafeBtn":
            HandleToggleShowPCCafeCommuniWnd();
            // End:0x55
            break;
        // End:0x52
        case "MCancelButton":
            RequestCancelCuriousHouse();
            // End:0x55
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function getToppingDefault()
{
    local int i;
    local ToppingSkillExtraInfo tmpSkillExtraInfo;

    toppingDefaultInfos.Remove(0, toppingDefaultInfos.Length);
    toppingDefaultInfos.Length = 6;
    Class'NWindow.UIDATA_SKILL'.static.GetFirstDefaultToppingSkillExtraInfo(toppingDefaultInfos[0]);
    J0x2C:

    // End:0x5E [Loop If]
    if(Class'NWindow.UIDATA_SKILL'.static.GetNextDefaultToppingSkillExtraInfo(tmpSkillExtraInfo))
    {
        i++;
        toppingDefaultInfos[i] = tmpSkillExtraInfo;
        // [Loop Continue]
        goto J0x2C;
    }
    return;
}

function setToppingBuffIcon(int SlotIndex, StatusIconInfo toppingInfo, bool bActive)
{
    local StatusIconInfo tmpInfo;

    toppingStatusIcons[SlotIndex - 1].GetItem(0, 0, tmpInfo);
    // End:0x43
    if(bActive)
    {
        toppingDisableTextures[SlotIndex - 1].HideWindow();        
    }
    else
    {
        toppingDisableTextures[SlotIndex - 1].ShowWindow();
    }
    // End:0x6F
    if(tmpInfo == toppingInfo)
    {
        return;
    }
    toppingStatusIcons[SlotIndex - 1].Clear();
    toppingStatusIcons[SlotIndex - 1].AddRow();
    toppingStatusIcons[SlotIndex - 1].AddCol(0, toppingInfo);
    return;
}

function handleBuffEvent(string param)
{
    local int i, Max;
    local StatusIconInfo Info;
    local ToppingSkillExtraInfo toppingSkillInfo;
    local array<int> bActivedSlot;

    bActivedSlot.Length = 6;
    Info.Size = 22;
    Info.BackTex = "l2ui_ct1.Ntopping_Lock";
    Info.bShow = true;
    Info.bEtcItem = false;
    Info.bShortItem = false;
    ParseInt(param, "ServerID", Info.ServerID);
    ParseInt(param, "Max", Max);
    i = 0;
    J0x9B:

    // End:0x259 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "SkillLevel_" $ string(i), Info.Level);
        ParseInt(param, "SkillSubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "RemainTime_" $ string(i), Info.RemainTime);
        ParseString(param, "Name_" $ string(i), Info.Name);
        ParseString(param, "IconName_" $ string(i), Info.IconName);
        ParseString(param, "Description_" $ string(i), Info.Description);
        // End:0x24F
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            Class'NWindow.UIDATA_SKILL'.static.GetToppingSkillExtraInfo(Info.Id, Info.Level, Info.SubLevel, toppingSkillInfo);
            bActivedSlot[toppingSkillInfo.SlotIndex - 1] = 1;
            setToppingBuffIcon(toppingSkillInfo.SlotIndex, Info, true);
        }
        i++;
        // [Loop Continue]
        goto J0x9B;
    }
    setDefaultToppingBuff(bActivedSlot);
    return;
}

function setDefaultToppingBuff(array<int> bActivedSlot)
{
    local int i;
    local StatusIconInfo Info;
    local bool isActived;

    Info.Size = 22;
    Info.BackTex = "l2ui_ct1.Ntopping_Lock";
    Info.bShow = true;
    Info.bEtcItem = false;
    Info.bShortItem = false;
    i = 0;
    J0x5E:

    // End:0x1B7 [Loop If]
    if(i < 6)
    {
        isActived = bActivedSlot[i] == 1;
        // End:0x1AD
        if(!isActived)
        {
            Info.Id = GetItemID(toppingDefaultInfos[i].Id);
            Info.Level = toppingDefaultInfos[i].Level;
            Info.SubLevel = toppingDefaultInfos[i].SubLevel;
            Info.RemainTime = -1;
            Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, Info.SubLevel);
            Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, Info.SubLevel);
            Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
            setToppingBuffIcon(i + 1, Info, false);
        }
        i++;
        // [Loop Continue]
        goto J0x5E;
    }
    return;
}

function handleVPPoint()
{
    local UserInfo UserInfo;
    local int vitality;

    // End:0x8B
    if(GetPlayerInfo(UserInfo))
    {
        vitality = UserInfo.nVitality;
        VpDetailBar.SetPoint(vitality, GetMaxVitality());
        // End:0x71
        if((vitality < 2205) && vitality > 0)
        {
            VpDetailBar.SetPoint(2205, GetMaxVitality());            
        }
        else
        {
            VpDetailBar.SetPoint(vitality, GetMaxVitality());
        }
    }
    return;
}

function HandleVitalityEffectInfo(string param)
{
    local CustomTooltip t;
    local int nVitality, nVitalityItemRestoreCount;
    local string sBonusString, sExtraBonusString, sSysMsgParamString, tmpStr;
    local L2Util util;

    ParseInt(param, "vitalityPoint", nVitality);
    ParseInt(param, "vitalityBonus", nVitalityBonus);
    ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
    ParseInt(param, "maxRestoreCount", nVitalityItemMaxRestoreCount);
    ParseInt(param, "vitalityExtraBonus", nVitalityExtraBonus);
    sBonusString = string(nVitalityBonus) $ "%";
    // End:0xD7
    if(nVitalityExtraBonus > 0)
    {
        sExtraBonusString = ("(+" $ string(nVitalityExtraBonus)) $ "%)";
    }
    util = L2Util(GetScript("L2Util"));
    util.setCustomTooltip(t);
    util.ToopTipInsertText(GetSystemString(2494), true, false);
    // End:0x19B
    if(nVitality <= 0)
    {
        util.ToopTipInsertText(GetSystemString(2496), true, false, util.1);
        util.ToopTipInsertText(", ", true, false);
        VpIcon.SetTexture("L2UI_CT1.Icon.InfoWnd_VPIcon_dis");        
    }
    else
    {
        util.ToopTipInsertText(sBonusString, true, false);
        util.ToopTipInsertText(sExtraBonusString, true, false, util.4);
        util.ToopTipInsertText((" " $ GetSystemString(2495)) $ ". ", true, false);
        VpIcon.SetTexture("L2UI_CT1.Icon.InfoWNd_VPIcon");
    }
    sSysMsgParamString = "";
    tmpStr = "";
    ParamAdd(sSysMsgParamString, "Type", string(int(1)));
    ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemRestoreCount));
    AddSystemMessageParam(sSysMsgParamString);
    tmpStr = EndSystemMessageParam(6073, true);
    util.ToopTipInsertText(tmpStr, true, false);
    VpDetailBar.SetTooltipCustomType(util.getCustomTooltip());
    // End:0x2EE
    if((isVPApply && nVitality == 0) || !isVPApply && nVitality > 0)
    {
        showVPSystemMsg();
    }
    return;
}

function showVPSystemMsg()
{
    local string sBonusString, sExtraBonusString, sSysMsgParamString;
    local UserInfo UserInfo;
    local int nVitality;
    local string sMessage;

    // End:0x12
    if(!GetPlayerInfo(UserInfo))
    {
        return;
    }
    nVitality = UserInfo.nVitality;
    sBonusString = string(nVitalityBonus) $ "%";
    // End:0x58
    if(nVitalityExtraBonus > 0)
    {
        sExtraBonusString = ("(+" $ string(nVitalityExtraBonus)) $ "%)";
    }
    // End:0x187
    if(isAfterStatusNormaEvent)
    {
        isVPApply = nVitality > 0;
        // End:0x126
        if(isVPApply)
        {
            ParamAdd(sSysMsgParamString, "Type", string(int(0)));
            ParamAdd(sSysMsgParamString, "param1", sBonusString $ sExtraBonusString);
            AddSystemMessageParam(sSysMsgParamString);
            sSysMsgParamString = "";
            ParamAdd(sSysMsgParamString, "Type", string(int(1)));
            ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
            AddSystemMessageParam(sSysMsgParamString);
            sMessage = EndSystemMessageParam(6067, true);
            AddSystemMessageString(sMessage);
            isVPApply = true;            
        }
        else
        {
            ParamAdd(sSysMsgParamString, "Type", string(int(1)));
            ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
            AddSystemMessageParam(sSysMsgParamString);
            sMessage = EndSystemMessageParam(6068, true);
            AddSystemMessageString(sMessage);
            isVPApply = false;
        }
    }
    return;
}

function HandleToggleShowPCCafeCommuniWnd()
{
    // End:0x21
    if(getInstanceL2Util().getIsPrologueGrowType())
    {
        AddSystemMessage(4533);        
    }
    else
    {
        Class'NWindow.PCCafeAPI'.static.RequestOpenWndWithoutNPC();
    }
    return;
}

function HandlePCCafePointInfo(string a_Param)
{
    local int Show;
    local bool bOption;

    ParseInt(a_Param, "TotalPoint", m_TotalPoint);
    ParseInt(a_Param, "AddPoint", m_AddPoint);
    ParseInt(a_Param, "PeriodType", m_PeriodType);
    ParseInt(a_Param, "RemainTime", m_RemainTime);
    ParseInt(a_Param, "PointType", m_PointType);
    ParseInt(a_Param, "Show", Show);
    // End:0x113
    if((Show > 0) && !m_bIsPCCafeEvent)
    {
        bOption = GetOptionBool("ScreenInfo", "IsPcRoomBox");
        // End:0x10B
        if(!getInstanceUIData().getIsClassicServer() && !bOption)
        {
            setWindowShowHide(PCCafeEventWnd, true);
        }
        m_bIsPCCafeEvent = true;
    }
    RefreshPcCafeInfo(Show);
    return;
}

function bool IsPCCafeEventOpened()
{
    // End:0x0D
    if(0 < m_PeriodType)
    {
        return true;
    }
    return false;
    return;
}

function RefreshPcCafeInfo(int nShow)
{
    local Color TextColor;
    local string AddPointText, FullPointText;

    // End:0x16
    if(nShow == 0)
    {
        setWindowShowHide(PCCafeEventWnd);
    }
    HelpButton.SetTooltipCustomType(getCustomTooltip(GetSystemString(2256)));
    FullPointText = MakeCostString(string(m_TotalPoint));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_PCCafeWndwName $ ".PointTextBox", FullPointText);
    Class'NWindow.UIAPI_WINDOW'.static.SetAlpha(m_PCCafeWndwName $ ".PointAddTextBox", 0);
    // End:0x2E8
    if((0 != m_AddPoint) && nShow != 0)
    {
        // End:0xDA
        if(0 < m_AddPoint)
        {
            AddPointText = "+" $ MakeCostString(string(m_AddPoint));            
        }
        else
        {
            AddPointText = MakeCostString(string(m_AddPoint));
        }
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_PCCafeWndwName $ ".PointAddTextBox", AddPointText);
        switch(m_PointType)
        {
            // End:0x153
            case 0:
                TextColor.R = byte(255);
                TextColor.G = byte(255);
                TextColor.B = 0;
                // End:0x1B9
                break;
            // End:0x185
            case 1:
                TextColor.R = 0;
                TextColor.G = byte(255);
                TextColor.B = byte(255);
                // End:0x1B9
                break;
            // End:0x1B6
            case 2:
                TextColor.R = byte(255);
                TextColor.G = 0;
                TextColor.B = 0;
                // End:0x1B9
                break;
            // End:0xFFFF
            default:
                break;
        }
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(m_PCCafeWndwName $ ".PointAddTextBox", TextColor);
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor(m_PCCafeWndwName $ ".PointAddTextBox", m_PCCafeWndwName, "TopRight", "TopRight", -5, 41);
        Class'NWindow.UIAPI_WINDOW'.static.ClearAnchor(m_PCCafeWndwName $ ".PointAddTextBox");
        Class'NWindow.UIAPI_WINDOW'.static.Move(m_PCCafeWndwName $ ".PointAddTextBox", 0, -18, 1.0000000);
        Class'NWindow.UIAPI_WINDOW'.static.SetAlpha(m_PCCafeWndwName $ ".PointAddTextBox", 255);
        Class'NWindow.UIAPI_WINDOW'.static.SetAlpha(m_PCCafeWndwName $ ".PointAddTextBox", 0, 0.8000000);
        m_AddPoint = 0;
    }
    return;
}

function string GetHelpButtonTooltipText()
{
    local string TooltipSystemMsg;

    // End:0x1F
    if(1 == m_PeriodType)
    {
        TooltipSystemMsg = GetSystemMessage(1705);        
    }
    else
    {
        // End:0x3F
        if(2 == m_PeriodType)
        {
            TooltipSystemMsg = GetSystemMessage(1706);            
        }
        else
        {
            return "";
        }
    }
    return MakeFullSystemMsg(TooltipSystemMsg, string(m_RemainTime), "");
    return;
}

function HandleToggleShowPCCafeEventWnd(optional bool bIsForceSet, optional bool bIsHide)
{
    // End:0x4C
    if(bIsForceSet)
    {
        SetOptionValue(bIsHide);
        setWindowShowHide(PCCafeEventWnd, (!bIsHide && IsPCCafeEvent()) && !getInstanceUIData().getIsClassicServer());
        return;
    }
    // End:0x6C
    if(PCCafeEventWnd.IsShowWindow())
    {
        setWindowShowHide(PCCafeEventWnd);        
    }
    else
    {
        // End:0x96
        if(IsPCCafeEvent())
        {
            // End:0x96
            if(!getInstanceUIData().getIsClassicServer())
            {
                setWindowShowHide(PCCafeEventWnd, true);
            }
        }
    }
    return;
}

function bool IsPCCafeEvent()
{
    // End:0x16
    if(m_bIsPCCafeEvent && bIsOptionValue)
    {
        return false;
    }
    return m_bIsPCCafeEvent;
    return;
}

function CuriousHouseHandle(string a_Param)
{
    local int HouseState;

    ParseInt(a_Param, "State", HouseState);
    switch(HouseState)
    {
        // End:0x22
        case 0:
        // End:0x35
        case 1:
            setWindowShowHide(MysteriousMansionWaitingWnd, false);
            // End:0x8C
            break;
        // End:0x72
        case 2:
            AddSystemMessage(3732);
            MCancelButton.EnableWindow();
            setWindowShowHide(MysteriousMansionWaitingWnd, true);
            Me.SetFocus();
            // End:0x8C
            break;
        // End:0x89
        case 3:
            MCancelButton.DisableWindow();
            // End:0x8C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function handleOnGamingStateEnter()
{
    local int useToppingType;
    local bool bOption;

    bOption = GetOptionBool("ScreenInfo", "IsPcRoomBox");
    // End:0x3D
    if(bOption)
    {
        setWindowShowHide(PCCafeEventWnd);        
    }
    else
    {
        setWindowShowHide(PCCafeEventWnd, bIsShowBackup && !getInstanceUIData().getIsClassicServer());
    }
    // End:0x96
    if(!GetINIBool("L2UI", "UseTopping", useToppingType, "L2.ini"))
    {
        useToppingType = 0;
    }
    // End:0xA7
    if(useToppingType == 1)
    {
        getToppingDefault();
    }
    setWindowShowHide(ToppingWnd, useToppingType == 1);
    setWindowShowHide(MysteriousMansionWaitingWnd);
    return;
}

function OnEnterState(name a_PreStateName)
{
    local int nShow;

    isAfterStatusNormaEvent = false;
    setWindowShowHide(VPWnd, false);
    // End:0x27
    if(IsPCCafeEvent())
    {
        nShow = 1;        
    }
    else
    {
        nShow = 0;
    }
    RefreshPcCafeInfo(nShow);
    isEnterState = true;
    Me.ShowWindow();
    return;
}

function OnExitState(name a_NextStateName)
{
    RefreshPcCafeInfo(0);
    isEnterState = false;
    Me.HideWindow();
    return;
}

function OnShow()
{
    // End:0x1A
    if(!isShowInfoWnd)
    {
        Me.HideWindow();
    }
    return;
}

function OnHide()
{
    PlayConsoleSound(6);
    return;
}

function CustomTooltip getCustomTooltip(string Text)
{
    local CustomTooltip ToolTip;
    local DrawItemInfo Info;

    ToolTip.MinimumWidth = 144;
    ToolTip.DrawList.Length = 1;
    Info.eType = 1;
    Info.t_bDrawOneLine = true;
    Info.t_color.R = 178;
    Info.t_color.G = 190;
    Info.t_color.B = 207;
    Info.t_color.A = byte(255);
    Info.t_strText = Text;
    ToolTip.DrawList[0] = Info;
    return ToolTip;
    return;
}

function setWindowShowHide(WindowHandle tmpWnd, optional bool IsShow)
{
    local int nWndWidth, nWndHeight, i, nWndHMax;
    local Rect rectWnd;

    // End:0x1C
    if(IsShow == tmpWnd.IsShowWindow())
    {
        return;
    }
    // End:0x37
    if(IsShow)
    {
        tmpWnd.ShowWindow();        
    }
    else
    {
        tmpWnd.HideWindow();
    }
    rectWnd = Me.GetRect();
    isShowInfoWnd = false;
    i = 0;
    J0x6A:

    // End:0x105 [Loop If]
    if(i < allWindow.Length)
    {
        // End:0xFB
        if(allWindow[i].IsShowWindow())
        {
            allWindow[i].GetWindowSize(nWndWidth, nWndHeight);
            allWindow[i].MoveTo(rectWnd.nX, rectWnd.nY + nWndHMax);
            nWndHMax = nWndHMax + nWndHeight;
            isShowInfoWnd = true;
        }
        i++;
        // [Loop Continue]
        goto J0x6A;
    }
    Me.SetWindowSize(rectWnd.nWidth, nWndHMax + 2);
    windowBackground.SetWindowSize(rectWnd.nWidth, nWndHMax + 2);
    // End:0x16F
    if(isShowInfoWnd && isEnterState)
    {
        Me.ShowWindow();        
    }
    else
    {
        Me.HideWindow();
    }
    return;
}

function SetOptionValue(bool bValue)
{
    bIsOptionValue = bValue;
    return;
}

defaultproperties
{
    m_ToppingWndName="InfoWnd.ToppingWnd"
    m_VPWndName="InfoWnd.VPWnd"
    m_PCCafeWndwName="InfoWnd.PCCafeEventWnd"
    m_MysteriousMansionWaitingWndName="InfoWnd.MysteriousMansionWaitingWnd"
    m_WindowName="InfoWnd"
}