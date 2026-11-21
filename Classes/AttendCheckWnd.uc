class AttendCheckWnd extends UICommonAPI;

const DialogCloseID = 1002112;
const texNumber = "L2UI_CT1.AttendCheckWnd.Attend_DateNum_";
const Red = true;
const Yellow = false;
const VIP_TYPE = true;
const NORMAL_TYPE = false;
const TWINKLE_ANI = true;
const STAMP_ANI = false;

var WindowHandle Me;
var WindowHandle AttendCheck_SlotGroup;
var WindowHandle AttendCheck_VIPGroup;
var AnimTextureHandle TodayTwinkle_VIP_AnimTex;
var AnimTextureHandle TodayStampYellow_VIP_AnimText;
var AnimTextureHandle TodayStampRed_VIP_AnimText;
var AnimTextureHandle TodayTwinkle_AnimTex;
var AnimTextureHandle TodayStampYellow_AnimText;
var AnimTextureHandle TodayStampRed_AnimText;
var WindowHandle week1Slot_Window;
var WindowHandle week2Slot_Window;
var WindowHandle week3Slot_Window;
var WindowHandle week4Slot_Window;
var TextBoxHandle Message_TextBox;
var TextBoxHandle Checklist_TextBox;
var int baseWindowSizeW;
var int baseWindowSizeH;
var int slotWindowSizeW;
var int slotWindowSizeH;
var int vipSlotWindowSizeW;
var int vipSlotWindowSizeH;
var Rect TodayStampYellow_VIP_Rect;
var Rect TodayStampRed_VIP_Rect;
var Rect TodayTwinkle_VIP_Rect;
var Rect TodayStampYellow_Rect;
var Rect TodayStampRed_Rect;
var Rect TodayTwinkle_Rect;
var int todayNormalDay;
var int todayVIpDay;
var int aniState_NormalRedStamp_nDay;
var int aniState_NormalYellowStamp_nDay;
var int aniState_VipRedStamp_nDay;
var int aniState_VipYellowStamp_nDay;

function OnRegisterEvent()
{
    RegisterEvent(16);
    RegisterEvent(580);
    RegisterEvent(10050);
    RegisterEvent(10051);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    load();
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    return;
}

function Initialize()
{
    Me = GetWindowHandle("AttendCheckWnd");
    AttendCheck_VIPGroup = GetWindowHandle("AttendCheckWnd.AttendCheck_VIPGroup");
    AttendCheck_SlotGroup = GetWindowHandle("AttendCheckWnd.AttendCheck_SlotGroup");
    week1Slot_Window = GetWindowHandle("AttendCheckWnd.AttendCheck_SlotGroup.week1Slot_Window");
    week2Slot_Window = GetWindowHandle("AttendCheckWnd.AttendCheck_SlotGroup.week2Slot_Window");
    week3Slot_Window = GetWindowHandle("AttendCheckWnd.AttendCheck_SlotGroup.week3Slot_Window");
    week4Slot_Window = GetWindowHandle("AttendCheckWnd.AttendCheck_SlotGroup.week4Slot_Window");
    Message_TextBox = GetTextBoxHandle("AttendCheckWnd.Message_TextBox");
    Checklist_TextBox = GetTextBoxHandle("AttendCheckWnd.Checklist_TextBox");
    TodayTwinkle_VIP_AnimTex = GetAnimTextureHandle("AttendCheckWnd.AttendCheck_VIPGroup.TodayTwinkle_AnimTex");
    TodayStampRed_VIP_AnimText = GetAnimTextureHandle("AttendCheckWnd.AttendCheck_VIPGroup.TodayStampRed_AnimText");
    TodayStampYellow_VIP_AnimText = GetAnimTextureHandle("AttendCheckWnd.AttendCheck_VIPGroup.TodayStampYellow_AnimText");
    TodayTwinkle_AnimTex = GetAnimTextureHandle("AttendCheckWnd.AttendCheck_SlotGroup.TodayTwinkle_AnimTex");
    TodayStampRed_AnimText = GetAnimTextureHandle("AttendCheckWnd.AttendCheck_SlotGroup.TodayStampRed_AnimText");
    TodayStampYellow_AnimText = GetAnimTextureHandle("AttendCheckWnd.AttendCheck_SlotGroup.TodayStampYellow_AnimText");
    Message_TextBox.SetText("");
    Checklist_TextBox.SetText(GetSystemMessage(6189));
    return;
}

function load()
{
    elementInit();
    Me.GetWindowSize(baseWindowSizeW, baseWindowSizeH);
    AttendCheck_VIPGroup.GetWindowSize(vipSlotWindowSizeW, vipSlotWindowSizeH);
    AttendCheck_SlotGroup.GetWindowSize(slotWindowSizeW, slotWindowSizeH);
    TodayStampYellow_VIP_Rect = TodayStampYellow_VIP_AnimText.GetRect();
    TodayStampRed_VIP_Rect = TodayStampRed_VIP_AnimText.GetRect();
    TodayTwinkle_VIP_Rect = TodayTwinkle_VIP_AnimTex.GetRect();
    TodayStampYellow_Rect = TodayStampYellow_AnimText.GetRect();
    TodayStampRed_Rect = TodayStampRed_AnimText.GetRect();
    TodayTwinkle_Rect = TodayTwinkle_AnimTex.GetRect();
    return;
}

function elementInit()
{
    local int i;

    i = 1;
    J0x07:

    // End:0x12A [Loop If]
    if(i <= 28)
    {
        setStampTexture(false, true, i, false);
        setStampTexture(false, false, i, false);
        setStampTexture(true, true, i, false);
        setStampTexture(true, false, i, false);
        setStampBgTexture(true, i, false);
        setStampBgTexture(false, i, false);
        setSlotHighlightTexture(true, i, false);
        setSlotHighlightTexture(false, i, false);
        setDayNumberTexture(true, i);
        setDayNumberTexture(false, i);
        setItemWindow(true, i, 0, 0);
        setItemWindow(false, i, 0, 0);
        setTextBoxAttendItemCount(true, i, 0);
        setTextBoxAttendItemCount(false, i, 0);
        // End:0x120
        if((getDay(i)) > 1)
        {
            GetTextureHandle(((getSlotWnd(getWeek(i))) $ ".slot_arrow") $ string((getDay(i)) - 1)).ShowWindow();
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    setTextBoxAttendItemCount(true, 7, 0);
    setTextBoxAttendItemCount(true, 14, 0);
    setTextBoxAttendItemCount(true, 21, 0);
    setTextBoxAttendItemCount(true, 28, 0);
    setVipPribbonTexture(7, 0);
    setVipPribbonTexture(14, 0);
    setVipPribbonTexture(21, 0);
    setVipPribbonTexture(28, 0);
    hideAllAniTexture();
    aniState_NormalRedStamp_nDay = 0;
    aniState_NormalYellowStamp_nDay = 0;
    aniState_VipRedStamp_nDay = 0;
    aniState_VipYellowStamp_nDay = 0;
    return;
}

function hideAllAniTexture()
{
    TodayStampYellow_VIP_AnimText.Pause();
    TodayStampYellow_VIP_AnimText.Stop();
    TodayStampYellow_VIP_AnimText.HideWindow();
    TodayStampYellow_AnimText.Pause();
    TodayStampYellow_AnimText.Stop();
    TodayStampYellow_AnimText.HideWindow();
    TodayStampRed_VIP_AnimText.Pause();
    TodayStampRed_VIP_AnimText.Stop();
    TodayStampRed_VIP_AnimText.HideWindow();
    TodayStampRed_AnimText.Pause();
    TodayStampRed_AnimText.Stop();
    TodayStampRed_AnimText.HideWindow();
    TodayTwinkle_VIP_AnimTex.Pause();
    TodayTwinkle_VIP_AnimTex.Stop();
    TodayTwinkle_VIP_AnimTex.HideWindow();
    TodayTwinkle_AnimTex.Pause();
    TodayTwinkle_AnimTex.Stop();
    TodayTwinkle_AnimTex.HideWindow();
    return;
}

function setTextBoxAttendItemCount(bool isVip, int nDay, int ItemCount)
{
    local string pStr;

    // End:0x1A
    if(ItemCount > 99)
    {
        pStr = "99+";        
    }
    else
    {
        pStr = "x" $ string(ItemCount);
    }
    // End:0x114
    if(isVip)
    {
        // End:0x111
        if((float(nDay) % float(7)) == float(0))
        {
            // End:0x94
            if(ItemCount == 0)
            {
                GetTextBoxHandle((((getVipWnd()) $ ".vip_") $ string(nDay)) $ "dayCount_TextBox").HideWindow();                
            }
            else
            {
                GetTextBoxHandle((((getVipWnd()) $ ".vip_") $ string(nDay)) $ "dayCount_TextBox").SetText(pStr);
                GetTextBoxHandle((((getVipWnd()) $ ".vip_") $ string(nDay)) $ "dayCount_TextBox").ShowWindow();
            }
        }        
    }
    else
    {
        // End:0x171
        if(ItemCount == 0)
        {
            GetTextBoxHandle((((getSlotWnd(getWeek(nDay))) $ ".AttendDayCount") $ string(getDay(nDay))) $ "_TextBox").HideWindow();            
        }
        else
        {
            GetTextBoxHandle((((getSlotWnd(getWeek(nDay))) $ ".AttendDayCount") $ string(getDay(nDay))) $ "_TextBox").SetText(pStr);
            GetTextBoxHandle((((getSlotWnd(getWeek(nDay))) $ ".AttendDayCount") $ string(getDay(nDay))) $ "_TextBox").ShowWindow();
        }
    }
    return;
}

function setItemWindow(bool isVip, int nDay, int nItemID, int amount)
{
    local ItemID pItemID;
    local ItemInfo ResourceInfo;
    local string Path;

    // End:0x44
    if(isVip)
    {
        Path = (((getVipWnd()) $ ".AttendVIP") $ string(getWeek(nDay))) $ "_ItemWindow";        
    }
    else
    {
        Path = (((getSlotWnd(getWeek(nDay))) $ ".AttendMonth") $ string(getDay(nDay))) $ "_ItemWindow";
    }
    GetItemWindowHandle(Path).Clear();
    // End:0x11E
    if(nItemID > 0)
    {
        pItemID.ClassID = nItemID;
        Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(pItemID, ResourceInfo);
        // End:0x104
        if(IsStackableItem(ResourceInfo.ConsumeType) && amount > 0)
        {
            ResourceInfo.ItemNum = (amount);
        }
        GetItemWindowHandle(Path).AddItem(ResourceInfo);
    }
    return;
}

function ItemWindowHandle getItemWindow(bool isVip, int nDay)
{
    local string Path;

    // End:0x44
    if(isVip)
    {
        Path = (((getVipWnd()) $ ".AttendVIP") $ string(getWeek(nDay))) $ "_ItemWindow";        
    }
    else
    {
        Path = (((getSlotWnd(getWeek(nDay))) $ ".AttendMonth") $ string(getDay(nDay))) $ "_ItemWindow";
    }
    return GetItemWindowHandle(Path);
    return;
}

function setAttendWndSize(bool isVip, int nDay)
{
    local int i, SlotCount, decSlotHeight, nWidth, nHeight, baseWndW,
	    baseWndH;

    SlotCount = getWeek(nDay);
    decSlotHeight = (4 - SlotCount) * (83 + 3);
    // End:0x4E
    if(isVip)
    {
        baseWndW = baseWindowSizeW;
        AttendCheck_VIPGroup.ShowWindow();        
    }
    else
    {
        baseWndW = baseWindowSizeW - vipSlotWindowSizeW;
        AttendCheck_VIPGroup.HideWindow();
    }
    AttendCheck_VIPGroup.SetWindowSize(vipSlotWindowSizeW, (vipSlotWindowSizeH - decSlotHeight) - 2);
    nWidth = slotWindowSizeW;
    nHeight = slotWindowSizeH - decSlotHeight;
    AttendCheck_SlotGroup.SetWindowSize(nWidth, nHeight);
    i = 1;
    J0xD0:

    // End:0x131 [Loop If]
    if(i <= 4)
    {
        // End:0x10C
        if((SlotCount + 1) > i)
        {
            GetWindowHandle(getSlotWnd(i)).ShowWindow();
            // [Explicit Continue]
            goto J0x127;
        }
        GetWindowHandle(getSlotWnd(i)).HideWindow();
        J0x127:

        i++;
        // [Loop Continue]
        goto J0xD0;
    }
    baseWndH = baseWindowSizeH - decSlotHeight;
    Me.SetWindowSize(baseWndW, baseWndH);
    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    local int nX, nY, nDay, SystemMsgIndex;

    // End:0x80
    if(Event_ID == 16)
    {
        ParseInt(a_Param, "x", nX);
        ParseInt(a_Param, "y", nY);
        ParseInt(a_Param, "day", nDay);
        playMotionTodayTwinkle(true, nDay, true);
        playMotionTodayTwinkle(false, nDay, true);
        playMotionStamp(false, true, nX, true);
        playMotionStamp(false, false, nX, true);        
    }
    else
    {
        // End:0xF8
        if(Event_ID == 580)
        {
            ParseInt(a_Param, "Index", SystemMsgIndex);
            // End:0xCC
            if(SystemMsgIndex == 129)
            {
                Message_TextBox.SetText(GetSystemMessage(129));                
            }
            else
            {
                // End:0xF5
                if(SystemMsgIndex == 6178)
                {
                    Message_TextBox.SetText(GetSystemMessage(6178));
                }
            }            
        }
        else
        {
            // End:0x139
            if(Event_ID == 10050)
            {
                // End:0x12B
                if(Me.IsShowWindow())
                {
                    Me.HideWindow();                    
                }
                else
                {
                    processEvent_VipAttendanceItemList(a_Param);
                }                
            }
            else
            {
                // End:0x153
                if(Event_ID == 10051)
                {
                    processEvent_VipAttendanceCheck(a_Param);
                }
            }
        }
    }
    return;
}

function processEvent_VipAttendanceItemList(string param)
{
    local int i, itemTotalCount, vipItemTotalCount, normalItemGetEnable, vipItemGetEnable, NormalDay,
	    Today, ItemID, amount, multiple, highLight,
	    vipItemID, vipAmount, vipMultiple, vipHighLight, vipLevel,
	    minimumLevel, vipDay, pcCafeDay;

    local bool bTodayGetEnable;
    local UserInfo PlayerInfo;

    todayVIpDay = -1;
    todayNormalDay = -1;
    ParseInt(param, "Today", Today);
    ParseInt(param, "NormalDay", NormalDay);
    ParseInt(param, "ItemCount", itemTotalCount);
    ParseInt(param, "VipItemCount", vipItemTotalCount);
    ParseInt(param, "NormalAttendanceEnable", normalItemGetEnable);
    ParseInt(param, "VipAttendanceEnable", vipItemGetEnable);
    ParseInt(param, "MinimumLevel", minimumLevel);
    // End:0x106
    if(vipItemTotalCount > 0)
    {
        setAttendWndSize(true, itemTotalCount);        
    }
    else
    {
        setAttendWndSize(false, itemTotalCount);
    }
    i = 1;
    J0x119:

    // End:0x2E1 [Loop If]
    if(i <= itemTotalCount)
    {
        ParseInt(param, "ItemID_" $ string(i), ItemID);
        ParseInt(param, "Amount_" $ string(i), amount);
        ParseInt(param, "Multiple_" $ string(i), multiple);
        ParseInt(param, "HighLight_" $ string(i), highLight);
        ParseInt(param, "PcCafeDay_" $ string(i), pcCafeDay);
        // End:0x234
        if((NormalDay < i) || normalItemGetEnable > 0)
        {
            setItemWindow(false, i, ItemID, amount);
            setTextBoxAttendItemCount(false, i, amount);
            setSlotHighlightTexture(false, i, numToBool(highLight));
        }
        // End:0x2D7
        if(NormalDay >= i)
        {
            setStampTexture(false, true, i, true);
            setStampTexture(false, false, i, numToBool(pcCafeDay));
            setStampBgTexture(false, i, true);
            setItemWindow(false, i, 0, 0);
            // End:0x2D7
            if((getDay(i)) > 1)
            {
                GetTextureHandle(((getSlotWnd(getWeek(i))) $ ".slot_arrow") $ string((getDay(i)) - 1)).HideWindow();
            }
        }
        i++;
        // [Loop Continue]
        goto J0x119;
    }
    i = 1;
    J0x2E8:

    // End:0x48B [Loop If]
    if(i <= vipItemTotalCount)
    {
        ParseInt(param, "VipItemID_" $ string(i), vipItemID);
        ParseInt(param, "VipAmount_" $ string(i), vipAmount);
        ParseInt(param, "VipMultiple_" $ string(i), vipMultiple);
        ParseInt(param, "VipHighLight_" $ string(i), vipHighLight);
        ParseInt(param, "VipLevel_" $ string(i), vipLevel);
        ParseInt(param, "VipDay_" $ string(i), vipDay);
        // End:0x442
        if(vipDay <= 0)
        {
            setItemWindow(true, i * 7, vipItemID, amount);
            setTextBoxAttendItemCount(true, i * 7, vipAmount);
            setSlotHighlightTexture(true, i * 7, numToBool(vipHighLight));
            setVipPribbonTexture(i * 7, vipLevel);
            // [Explicit Continue]
            goto J0x481;
        }
        setStampBgTexture(true, i * 7, numToBool(vipDay));
        setStampTexture(true, true, i * 7, true);
        setItemWindow(true, i * 7, 0, 0);
        J0x481:

        i++;
        // [Loop Continue]
        goto J0x2E8;
    }
    // End:0x4E6
    if(normalItemGetEnable > 0)
    {
        // End:0x4E6
        if((NormalDay == (Today - 1)) || NormalDay == Today)
        {
            playMotionTodayTwinkle(false, Today, true);
            todayNormalDay = Today;
            bTodayGetEnable = true;
            setStampBgTexture(false, Today, false);
        }
    }
    // End:0x525
    if((NormalDay == (Today - 1)) && vipItemGetEnable > 0)
    {
        playMotionTodayTwinkle(true, Today, true);
        todayVIpDay = Today;
        bTodayGetEnable = true;
    }
    GetPlayerInfo(PlayerInfo);
    // End:0x57B
    if((minimumLevel > 0) && minimumLevel > PlayerInfo.nLevel)
    {
        Message_TextBox.SetText(MakeFullSystemMsg(GetSystemMessage(6188), string(minimumLevel)));        
    }
    else
    {
        // End:0x5EA
        if(bTodayGetEnable)
        {
            // End:0x5BD
            if(NormalDay == Today)
            {
                Message_TextBox.SetText(MakeFullSystemMsg(GetSystemMessage(6174), string(NormalDay)));                
            }
            else
            {
                Message_TextBox.SetText(MakeFullSystemMsg(GetSystemMessage(6174), string(NormalDay + 1)));
            }            
        }
        else
        {
            Message_TextBox.SetText(MakeFullSystemMsg(GetSystemMessage(6176), string(Today)));
        }
    }
    // End:0x643
    if(!Me.IsShowWindow())
    {
        Me.ShowWindow();
        Me.SetFocus();
    }
    return;
}

function processEvent_VipAttendanceCheck(string param)
{
    local int CheckDay, CheckType;
    local bool isVip, isVipRed, isNormal, isNormalRed;

    ParseInt(param, "CheckDay", CheckDay);
    ParseInt(param, "CheckType", CheckType);
    // End:0x26A
    if(CheckDay > 0)
    {
        switch(CheckType)
        {
            // End:0x5E
            case 1:
                isNormal = true;
                isNormalRed = true;
                // End:0xE1
                break;
            // End:0x76
            case 2:
                isNormal = true;
                isNormalRed = false;
                // End:0xE1
                break;
            // End:0x8E
            case 4:
                isVip = true;
                isVipRed = true;
                // End:0xE1
                break;
            // End:0xB6
            case 5:
                isNormal = true;
                isNormalRed = true;
                isVip = true;
                isVipRed = true;
                // End:0xE1
                break;
            // End:0xDE
            case 6:
                isVip = true;
                isVipRed = true;
                isNormal = true;
                isNormalRed = false;
                // End:0xE1
                break;
            // End:0xFFFF
            default:
                break;
        }
        Message_TextBox.SetText(MakeFullSystemMsg(GetSystemMessage(6176), string(CheckDay)));
        // End:0x17E
        if((CheckType == 3) || CheckType == 7)
        {
            playMotionStamp(false, true, CheckDay, true);
            playMotionStamp(false, false, CheckDay, true);
            PlaySound("InterfaceSound.stamp_double");
            // End:0x17B
            if(CheckType == 7)
            {
                playMotionStamp(true, true, CheckDay, true);
            }            
        }
        else
        {
            // End:0x19A
            if(isNormal)
            {
                playMotionStamp(false, isNormalRed, CheckDay, true);
            }
            // End:0x1B6
            if(isVip)
            {
                playMotionStamp(true, isVipRed, CheckDay, true);
            }
            // End:0x1ED
            if(isVipRed || isNormalRed)
            {
                PlaySound("InterfaceSound.stamp_red");                
            }
            else
            {
                PlaySound("InterfaceSound.stamp_yellow");
            }
        }
        TodayTwinkle_AnimTex.Pause();
        TodayTwinkle_AnimTex.Stop();
        TodayTwinkle_AnimTex.HideWindow();
        TodayTwinkle_VIP_AnimTex.Pause();
        TodayTwinkle_VIP_AnimTex.Stop();
        TodayTwinkle_VIP_AnimTex.HideWindow();
    }
    return;
}

function OnHide()
{
    elementInit();
    return;
}

function OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
    // End:0x5A
    if(TodayTwinkle_AnimTex.IsShowWindow() || TodayTwinkle_VIP_AnimTex.IsShowWindow())
    {
        // End:0x5A
        if(((getItemWindow(true, todayVIpDay)) == a_hItemWindow) || (getItemWindow(false, todayNormalDay)) == a_hItemWindow)
        {
            RequestAttendanceCheck();
        }
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1C
        case "HelpBtn":
            OnHelpBtnClick();
            // End:0x36
            break;
        // End:0x33
        case "CancelBtn":
            OnCancelBtnClick();
            // End:0x36
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnCancelBtnClick()
{
    Me.HideWindow();
    return;
}

function OnHelpBtnClick()
{
    local string strParam;

    // End:0x5F
    if(getInstanceUIData().getIsClassicServer())
    {
        ParamAdd(strParam, "FilePath", "..\\L2text\\g_attendance_help001.htm");
        ExecuteEvent(1210, strParam);        
    }
    else
    {
        ExecuteEvent(1210, "155");
    }
    return;
}

function setDayNumberTexture(bool isVip, int nDay)
{
    local string tex1Path, tex10Path, ten, one;

    strDaySplit(nDay, ten, one);
    // End:0x129
    if(isVip && (float(nDay) % float(7)) == float(0))
    {
        tex1Path = (((getVipWnd()) $ ".DateNum") $ string(nDay)) $ "_VIP_1_Texture";
        tex10Path = (((getVipWnd()) $ ".DateNum") $ string(nDay)) $ "_VIP_10_Texture";
        GetTextureHandle(tex1Path).SetTexture("L2UI_CT1.AttendCheckWnd.Attend_DateNum_" $ one);
        GetTextureHandle(tex10Path).SetTexture("L2UI_CT1.AttendCheckWnd.Attend_DateNum_" $ ten);        
    }
    else
    {
        tex1Path = (((getSlotWnd(getWeek(nDay))) $ ".DateNum") $ string(getDay(nDay))) $ "_Month_1_Texture";
        tex10Path = (((getSlotWnd(getWeek(nDay))) $ ".DateNum") $ string(getDay(nDay))) $ "_Month_10_Texture";
        GetTextureHandle(tex1Path).SetTexture("L2UI_CT1.AttendCheckWnd.Attend_DateNum_" $ one);
        GetTextureHandle(tex10Path).SetTexture("L2UI_CT1.AttendCheckWnd.Attend_DateNum_" $ ten);
    }
    return;
}

function setVipPribbonTexture(int nDay, int nLevel)
{
    local string texPath;

    // End:0xC5
    if((float(nDay) % float(7)) == float(0))
    {
        texPath = ((getVipWnd()) $ ".Attend_VIPribbon") $ string(getWeek(nDay));
        // End:0xB0
        if(nLevel > 0)
        {
            GetTextureHandle(texPath).ShowWindow();
            GetTextureHandle(texPath).SetTexture("L2UI_ct1.AttendCheckWnd.Attend_VIPribbon" $ string(nLevel));            
        }
        else
        {
            GetTextureHandle(texPath).HideWindow();
        }
    }
    return;
}

function setStampTexture(bool isVip, bool isRed, int nDay, bool nShow)
{
    local string texRedPath, texYellowPath, texStampBgPath;

    // End:0x139
    if(isVip && (float(nDay) % float(7)) == float(0))
    {
        texRedPath = (((getVipWnd()) $ ".StampRed") $ string(getWeek(nDay))) $ "_Texture";
        texYellowPath = (((getVipWnd()) $ ".StampYellow") $ string(getWeek(nDay))) $ "_Texture";
        texStampBgPath = (((getVipWnd()) $ ".StampBG") $ string(getWeek(nDay))) $ "_Texture";
        // End:0x100
        if(nShow)
        {
            // End:0xE8
            if(isRed)
            {
                GetTextureHandle(texRedPath).ShowWindow();                
            }
            else
            {
                GetTextureHandle(texYellowPath).ShowWindow();
            }            
        }
        else
        {
            // End:0x121
            if(isRed)
            {
                GetTextureHandle(texRedPath).HideWindow();                
            }
            else
            {
                GetTextureHandle(texYellowPath).HideWindow();
            }
        }        
    }
    else
    {
        texRedPath = (((getSlotWnd(getWeek(nDay))) $ ".StampRed") $ string(getDay(nDay))) $ "_Texture";
        texYellowPath = (((getSlotWnd(getWeek(nDay))) $ ".StampYellow") $ string(getDay(nDay))) $ "_Texture";
        texStampBgPath = (((getSlotWnd(getWeek(nDay))) $ ".StampBG") $ string(getDay(nDay))) $ "_Texture";
        // End:0x23A
        if(nShow)
        {
            // End:0x222
            if(isRed)
            {
                GetTextureHandle(texRedPath).ShowWindow();                
            }
            else
            {
                GetTextureHandle(texYellowPath).ShowWindow();
            }            
        }
        else
        {
            // End:0x25B
            if(isRed)
            {
                GetTextureHandle(texRedPath).HideWindow();                
            }
            else
            {
                GetTextureHandle(texYellowPath).HideWindow();
            }
        }
        // End:0x2BB
        if(!GetTextureHandle(texRedPath).IsShowWindow() && !GetTextureHandle(texYellowPath).IsShowWindow())
        {
            GetTextureHandle(texStampBgPath).ShowWindow();
        }
    }
    return;
}

function setStampBgTexture(bool isVip, int nDay, bool nShow)
{
    local string texStampBgPath;

    // End:0x8C
    if(isVip && (float(nDay) % float(7)) == float(0))
    {
        texStampBgPath = (((getVipWnd()) $ ".StampBG") $ string(getWeek(nDay))) $ "_Texture";
        // End:0x74
        if(nShow)
        {
            GetTextureHandle(texStampBgPath).ShowWindow();            
        }
        else
        {
            GetTextureHandle(texStampBgPath).HideWindow();
        }        
    }
    else
    {
        texStampBgPath = (((getSlotWnd(getWeek(nDay))) $ ".StampBG") $ string(getDay(nDay))) $ "_Texture";
        // End:0xEB
        if(nShow)
        {
            GetTextureHandle(texStampBgPath).ShowWindow();            
        }
        else
        {
            GetTextureHandle(texStampBgPath).HideWindow();
        }
    }
    return;
}

function setSlotHighlightTexture(bool isVip, int nDay, bool nShow)
{
    local string texPath;

    // End:0x96
    if(isVip && (float(nDay) % float(7)) == float(0))
    {
        texPath = (((getVipWnd()) $ ".SlotHighlight") $ string(getWeek(nDay))) $ "_VIP_Texture";
        // End:0x7E
        if(nShow)
        {
            GetTextureHandle(texPath).ShowWindow();            
        }
        else
        {
            GetTextureHandle(texPath).HideWindow();
        }        
    }
    else
    {
        texPath = (((getSlotWnd(getWeek(nDay))) $ ".SlotHighlight") $ string(getDay(nDay))) $ "_Texture";
        // End:0xFB
        if(nShow)
        {
            GetTextureHandle(texPath).ShowWindow();            
        }
        else
        {
            GetTextureHandle(texPath).HideWindow();
        }
    }
    return;
}

function playMotionStamp(bool isVip, bool isRed, int nDay, bool bPlay)
{
    local int nX, nY;

    setStampTexture(isVip, isRed, nDay, bPlay);
    // End:0x228
    if(isVip && (float(nDay) % float(7)) == float(0))
    {
        // End:0x137
        if(isRed)
        {
            // End:0x116
            if(bPlay)
            {
                aniState_VipRedStamp_nDay = nDay;
                nX = 3;
                nY = 3;
                TodayStampRed_VIP_AnimText.ShowWindow();
                TodayStampRed_VIP_AnimText.SetAnchor("AttendCheckWnd.AttendCheck_VIPGroup", "TopLeft", "TopLeft", nX - 16, (nY - 22) + (((getWeek(nDay)) - 1) * 87));
                TodayStampRed_VIP_AnimText.SetLoopCount(1);
                TodayStampRed_VIP_AnimText.Stop();
                TodayStampRed_VIP_AnimText.Play();                
            }
            else
            {
                TodayStampRed_VIP_AnimText.HideWindow();
                TodayStampRed_VIP_AnimText.Stop();
            }            
        }
        else
        {
            // End:0x207
            if(bPlay)
            {
                aniState_VipYellowStamp_nDay = nDay;
                nX = 3;
                nY = 3;
                TodayStampYellow_VIP_AnimText.ShowWindow();
                TodayStampYellow_VIP_AnimText.SetAnchor("AttendCheckWnd.AttendCheck_VIPGroup", "TopLeft", "TopLeft", nX - 8, (nY + 9) + (((getWeek(nDay)) - 1) * 87));
                TodayStampYellow_VIP_AnimText.SetLoopCount(1);
                TodayStampYellow_VIP_AnimText.Stop();
                TodayStampYellow_VIP_AnimText.Play();                
            }
            else
            {
                TodayStampYellow_VIP_AnimText.HideWindow();
                TodayStampYellow_VIP_AnimText.Stop();
            }
        }        
    }
    else
    {
        // End:0x321
        if(isRed)
        {
            // End:0x300
            if(bPlay)
            {
                aniState_NormalRedStamp_nDay = nDay;
                nX = 7;
                nY = 87;
                TodayStampRed_AnimText.ShowWindow();
                TodayStampRed_AnimText.SetAnchor("AttendCheckWnd", "TopLeft", "TopLeft", (nX - 16) + (((getDay(nDay)) - 1) * 59), (nY - 22) + (((getWeek(nDay)) - 1) * 87));
                TodayStampRed_AnimText.SetLoopCount(1);
                TodayStampRed_AnimText.Stop();
                TodayStampRed_AnimText.Play();                
            }
            else
            {
                TodayStampRed_AnimText.HideWindow();
                TodayStampRed_AnimText.Stop();
            }            
        }
        else
        {
            // End:0x3F0
            if(bPlay)
            {
                aniState_NormalYellowStamp_nDay = nDay;
                nX = 6;
                nY = 86;
                TodayStampYellow_AnimText.ShowWindow();
                TodayStampYellow_AnimText.SetAnchor("AttendCheckWnd", "TopLeft", "TopLeft", (nX - 8) + (((getDay(nDay)) - 1) * 59), (nY + 9) + (((getWeek(nDay)) - 1) * 87));
                TodayStampYellow_AnimText.SetLoopCount(1);
                TodayStampYellow_AnimText.Stop();
                TodayStampYellow_AnimText.Play();                
            }
            else
            {
                TodayStampYellow_AnimText.HideWindow();
                TodayStampYellow_AnimText.Stop();
            }
        }
    }
    return;
}

function playMotionTodayTwinkle(bool isVip, int nDay, bool bPlay)
{
    local int nX, nY;

    // End:0xFA
    if(isVip && (float(nDay) % float(7)) == float(0))
    {
        // End:0xD9
        if(bPlay)
        {
            TodayTwinkle_VIP_AnimTex.ShowWindow();
            TodayTwinkle_VIP_AnimTex.SetAnchor("AttendCheckWnd.AttendCheck_VIPGroup", "TopLeft", "TopLeft", nX + 7, (nY + 7) + (((getWeek(nDay)) - 1) * 87));
            TodayTwinkle_VIP_AnimTex.Stop();
            TodayTwinkle_VIP_AnimTex.SetLoopCount(99999);
            TodayTwinkle_VIP_AnimTex.Play();            
        }
        else
        {
            TodayTwinkle_VIP_AnimTex.HideWindow();
            TodayTwinkle_VIP_AnimTex.Stop();
        }        
    }
    else
    {
        // End:0x1C2
        if(bPlay)
        {
            nX = 7;
            nY = 87;
            TodayTwinkle_AnimTex.ShowWindow();
            TodayTwinkle_AnimTex.SetAnchor("AttendCheckWnd", "TopLeft", "TopLeft", (nX + 4) + (((getDay(nDay)) - 1) * 59), (nY + 5) + (((getWeek(nDay)) - 1) * 87));
            TodayTwinkle_AnimTex.Stop();
            TodayTwinkle_AnimTex.SetLoopCount(99999);
            TodayTwinkle_AnimTex.Play();            
        }
        else
        {
            TodayTwinkle_AnimTex.HideWindow();
            TodayTwinkle_AnimTex.Stop();
        }
    }
    return;
}

function string getSlotWnd(int SlotNum)
{
    return ("AttendCheckWnd.AttendCheck_SlotGroup.week" $ string(SlotNum)) $ "Slot_Window";
    return;
}

function string getVipWnd()
{
    return "AttendCheckWnd.AttendCheck_VIPGroup";
    return;
}

function strDaySplit(int nDay, out string ten, out string one)
{
    // End:0x31
    if(nDay > 9)
    {
        ten = Mid(string(nDay), 0, 1);
        one = Mid(string(nDay), 1, 1);        
    }
    else
    {
        ten = "0";
        one = string(nDay);
    }
    return;
}

function int getWeek(int nDay)
{
    local int nValue;

    // End:0x27
    if((float(nDay) % float(7)) <= float(0))
    {
        nValue = nDay / 7;        
    }
    else
    {
        nValue = (nDay / 7) + 1;
    }
    return nValue;
    return;
}

function int getDay(int nDay)
{
    local int nValue;

    nValue = int(float(nDay) % float(7));
    // End:0x28
    if(nValue <= 0)
    {
        nValue = 7;
    }
    return nValue;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
