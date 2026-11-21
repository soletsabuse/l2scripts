class AttendCheckWndNew extends AttendCheckAPI;

var string m_WindowName;
var int currentPage;
var bool bPremiumCardOnFront;
var array<_slotItem> DefaultSlotItems;
var array<_slotItem> PremiumSlotItems;
var array<_attendanceItem> defaultSlots;
var array<_attendanceItem> premiumSlots;
var _attendanceData attendanceData;
var Paginator Paginator;
var WindowHandle Me;
var WindowHandle DialogContainerWnd;
var ItemWindowHandle DialogSlot;
var TextBoxHandle DialogRewardTypeTxt;
var TextBoxHandle DialogDayTxt;
var TextBoxHandle DialogCountTxt;
var TextBoxHandle TitlePeriodTimeTxt;
var AnimTextureHandle DialogAniTx;
var ButtonHandle MonthLeftBtn;
var ButtonHandle MonthRightBtn;
var ButtonHandle RewardCardSwitchBtn;
var ButtonHandle BuyPremiumBtn;
var ButtonHandle ClaimBtn;

function OnLoad()
{
    local int i;

    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    DialogContainerWnd = GetWindowHandle(m_WindowName $ ".DialogContainerWnd");
    RewardCardSwitchBtn = GetButtonHandle(m_WindowName $ ".DialogContainerWnd.RewardCardSwitchBtn");
    BuyPremiumBtn = GetButtonHandle(m_WindowName $ ".DialogContainerWnd.BuyPremiumBtn");
    ClaimBtn = GetButtonHandle(m_WindowName $ ".DialogContainerWnd.ClaimBtn");
    TitlePeriodTimeTxt = GetTextBoxHandle(m_WindowName $ ".TitlePeriodTimeTxt");
    DialogSlot = GetItemWindowHandle(m_WindowName $ ".DialogContainerWnd.CurrentSlotWnd.DialogSlot");
    DialogRewardTypeTxt = GetTextBoxHandle(m_WindowName $ ".DialogContainerWnd.CurrentSlotWnd.DialogRewardTypeTxt");
    DialogDayTxt = GetTextBoxHandle(m_WindowName $ ".DialogContainerWnd.CurrentSlotWnd.DialogDayTxt");
    DialogCountTxt = GetTextBoxHandle(m_WindowName $ ".DialogContainerWnd.CurrentSlotWnd.DialogCountTxt");
    DialogAniTx = GetAnimTextureHandle(m_WindowName $ ".DialogContainerWnd.CurrentSlotWnd.DialogAniTx");
    DefaultSlotItems.Length = 7;
    PremiumSlotItems.Length = 7;
    MonthLeftBtn = GetButtonHandle("AttendCheckWndNew.RewardContainerWnd.MonthLeftBtn");
    MonthRightBtn = GetButtonHandle("AttendCheckWndNew.RewardContainerWnd.MonthRightBtn");
    i = 0;
    J0x305:

    // End:0x72A [Loop If]
    if(i < 7)
    {
        DefaultSlotItems[i].SlotWnd = GetWindowHandle("AttendCheckWndNew.RewardContainerWnd.DaySlot0" $ string(i));
        DefaultSlotItems[i].SlotDisableWnd = GetTextureHandle((("AttendCheckWndNew.RewardContainerWnd.DaySlot0" $ string(i)) $ ".SlotDisableTx0") $ string(i));
        DefaultSlotItems[i].SlotBringTx = GetAnimTextureHandle((("AttendCheckWndNew.RewardContainerWnd.DaySlot0" $ string(i)) $ ".aniTx0") $ string(i));
        DefaultSlotItems[i].SlotItem = GetItemWindowHandle((("AttendCheckWndNew.RewardContainerWnd.DaySlot0" $ string(i)) $ ".DaySlotItem0") $ string(i));
        DefaultSlotItems[i].Day = GetTextBoxHandle((("AttendCheckWndNew.RewardContainerWnd.DaySlot0" $ string(i)) $ ".DayTxt0") $ string(i));
        DefaultSlotItems[i].SlotCount = GetTextBoxHandle((("AttendCheckWndNew.RewardContainerWnd.DaySlot0" $ string(i)) $ ".RewardCountTxt0") $ string(i));
        PremiumSlotItems[i].SlotWnd = GetWindowHandle("AttendCheckWndNew.RewardContainerWnd.DayPremiumSlot0" $ string(i));
        PremiumSlotItems[i].Day = GetTextBoxHandle((("AttendCheckWndNew.RewardContainerWnd.DayPremiumSlot0" $ string(i)) $ ".DayPremiumTxt0") $ string(i));
        PremiumSlotItems[i].SlotCount = GetTextBoxHandle((("AttendCheckWndNew.RewardContainerWnd.DayPremiumSlot0" $ string(i)) $ ".RewardPremiumCountTxt0") $ string(i));
        PremiumSlotItems[i].SlotItem = GetItemWindowHandle((("AttendCheckWndNew.RewardContainerWnd.DayPremiumSlot0" $ string(i)) $ ".DayPremiumSlotItem0") $ string(i));
        i++;
        // [Loop Continue]
        goto J0x305;
    }
    clearAttendanceReward();
    initPaginator();
    return;
}

function OnHide()
{
    clearAttendanceReward();
    return;
}

function initPaginator()
{
    currentPage = 1;
    Paginator = new Class'Interface.Paginator';
    Paginator.SetPaginatorElement(GetTextBoxHandle(""), GetTextBoxHandle(""), GetButtonHandle(m_WindowName $ ".RewardContainerWnd.MonthRightBtn"), GetButtonHandle(m_WindowName $ ".RewardContainerWnd.MonthLeftBtn"), GetButtonHandle(""), GetButtonHandle(""));
    Paginator.__onPageNext__Delegate = handlePageNext;
    Paginator.__onPagePrev__Delegate = handlePagePrev;
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(160);
    RegisterEvent(3550);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1D
    if(Event_ID == 3550)
    {
        _OnEvent(param);        
    }
    else
    {
        // End:0x3D
        if(Event_ID == 160)
        {
            Me.KillTimer(5870);
        }
    }
    return;
}

function _OnEvent(string param)
{
    local int Event_ID;

    ParseInt(param, "EventID", Event_ID);
    switch(Event_ID)
    {
        // End:0x36
        case 1091:
            handleAttendanceInfo(param);
            // End:0x52
            break;
        // End:0x4C
        case 1092:
            handleAttendanceState(param);
            // End:0x52
            break;
        // End:0xFFFF
        default:
            // End:0x52
            break;
            break;
    }
    return;
}

function OnTimer(int TimerID)
{
    local int Index;

    // End:0x43
    if(TimerID >= 1000000)
    {
        Me.KillTimer(TimerID);
        Index = TimerID - 1000000;
        showPremiumSlot(Index);        
    }
    else
    {
        // End:0x9D
        if(TimerID == 5870)
        {
            Me.KillTimer(5870);
            // End:0x78
            if(attendanceData.WaitingTime == 0)
            {
                return;
            }
            attendanceData.WaitingTime--;
            Me.SetTimer(5870, 1000);
        }
    }
    return;
}

function OnClickButton(string strID)
{
    // End:0x33
    if(strID == "MonthRightBtn")
    {
        bPremiumCardOnFront = false;
        Paginator.setNextPage();        
    }
    else
    {
        // End:0x65
        if(strID == "MonthLeftBtn")
        {
            bPremiumCardOnFront = false;
            Paginator.setPrevPage();            
        }
        else
        {
            // End:0x8D
            if(strID == "RewardCardSwitchBtn")
            {
                changeOnFrontView();                
            }
            else
            {
                // End:0xC0
                if(strID == "BuyPremiumBtn")
                {
                    RequestBypassToServer("showms" @ string(77501));                    
                }
                else
                {
                    // End:0xE6
                    if(strID == "CloseBtn")
                    {
                        DialogContainerWnd.HideWindow();                        
                    }
                    else
                    {
                        // End:0x112
                        if(strID == "ClaimBtn")
                        {
                            requestReward(ClaimBtn.GetButtonValue());                            
                        }
                        else
                        {
                            // End:0x128
                            if(strID == "test")
                            {
                                requestAttendance();
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    local bool bIsPremium;
    local string Prefix;

    // End:0x34
    if(InStr(strID, "DaySlotItem") > -1)
    {
        Prefix = "DaySlotItem";        
    }
    else
    {
        // End:0x73
        if(InStr(strID, "DayPremiumSlotItem") > -1)
        {
            Prefix = "DayPremiumSlotItem";
        }
    }
    // End:0x82
    if(Len(Prefix) <= 0)
    {
        return;
    }
    handleDialog(Prefix == "DayPremiumSlotItem", int(Locs(strID, Prefix, "", true)), Index);
    return;
}

function OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
    local int Index;

    // End:0x6C
    if((InStr(a_WindowHandle.GetWindowName(), "DaySlot") > -1) || InStr(a_WindowHandle.GetWindowName(), "DaySlotItem") > -1)
    {
        Index = int(Right(a_WindowHandle.GetWindowName(), 2));        
    }
    else
    {
        // End:0xE3
        if((InStr(a_WindowHandle.GetWindowName(), "DayPremiumSlot") > -1) || InStr(a_WindowHandle.GetWindowName(), "DayPremiumSlotItem") > -1)
        {
            Index = int(Right(a_WindowHandle.GetWindowName(), 2));
        }
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local int Index;

    // End:0x6C
    if((InStr(a_WindowHandle.GetWindowName(), "DaySlot") > -1) || InStr(a_WindowHandle.GetWindowName(), "DaySlotItem") > -1)
    {
        Index = int(Right(a_WindowHandle.GetWindowName(), 2));        
    }
    else
    {
        // End:0xE3
        if((InStr(a_WindowHandle.GetWindowName(), "DayPremiumSlot") > -1) || InStr(a_WindowHandle.GetWindowName(), "DayPremiumSlotItem") > -1)
        {
            Index = int(Right(a_WindowHandle.GetWindowName(), 2));
        }
    }
    return;
}

function handlePageNext()
{
    currentPage = Paginator.getCurrentPage();
    requestChangePage(currentPage);
    return;
}

function handlePagePrev()
{
    currentPage = Paginator.getCurrentPage();
    requestChangePage(currentPage);
    return;
}

function handleAttendanceInfo(string param)
{
    ParseInt(param, "ask", attendanceData.Month);
    ParseInt(param, "reply", attendanceData.premium);
    ParseInt(param, "param1", attendanceData.currentDay);
    ParseInt(param, "param2", attendanceData.periodStart);
    ParseInt(param, "param3", attendanceData.PeriodEnd);
    ParseInt(param, "param5", attendanceData.WaitingTime);
    iniSet("AttendParam:" @ param);
    defaultSlots = getDefaultRewardByMonth(attendanceData.Month);
    premiumSlots = getPremiumRewardByMonth(attendanceData.Month);
    Me.KillTimer(5870);
    Me.SetTimer(5870, 1000);
    return;
}

function handleAttendanceState(string param)
{
    local int nCurrentWeekPage;
    local string defaultStates, premiumStates;
    local array<string> dStates, pStates;

    // End:0x15
    if(attendanceData.Month != (getActiveMonth()))
    {
    }
    // End:0x23
    if(defaultSlots.Length < 1)
    {
        return;
    }
    ParseInt(param, "ask", nCurrentWeekPage);
    ParseString(param, "param1", defaultStates);
    ParseString(param, "param2", premiumStates);
    dStates = Arr(defaultStates, ",");
    // End:0x8A
    if(dStates.Length < 1)
    {
        return;
    }
    // End:0xAB
    if(Len(premiumStates) > 0)
    {
        pStates = Arr(premiumStates, ",");
    }
    // End:0xD0
    if((attendanceData.Month < 1) || attendanceData.Month > 12)
    {
        return;
    }
    // End:0xF5
    if((attendanceData.currentDay < 1) || attendanceData.currentDay > 31)
    {
        return;
    }
    TitlePeriodTimeTxt.SetText((Left(ConvertTimetoStr(attendanceData.periodStart), 10) @ "~") @ Left(ConvertTimetoStr(attendanceData.PeriodEnd), 10));
    Paginator.setPages(currentPage, appCeil(float(defaultSlots.Length) / 7.0000000));
    loadAttendanceReward(dStates, pStates, nCurrentWeekPage);
    return;
}

function clearAttendanceReward()
{
    local int i;

    DialogContainerWnd.HideWindow();
    GetTextureHandle("AttendCheckWndNew.RewardContainerWnd.selector2").SetAlpha(0);
    stopFlameAni();
    i = 0;
    J0x5D:

    // End:0x20F [Loop If]
    if(i < 7)
    {
        Me.KillTimer(1000000 + i);
        setDefaultTakenPanel(0, i);
        setPremiumTakenPanel(0, i);
        DefaultSlotItems[i].SlotDisableWnd.ShowWindow();
        PremiumSlotItems[i].SlotWnd.HideWindow();
        // End:0x11F
        if(i == (7 - 1))
        {
            DefaultSlotItems[i].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.DollCard_R");            
        }
        else
        {
            DefaultSlotItems[i].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.RelicSummonCard_N");
        }
        DefaultSlotItems[i].SlotItem.Clear();
        DefaultSlotItems[i].Day.SetText("");
        DefaultSlotItems[i].SlotCount.SetText("");
        PremiumSlotItems[i].SlotItem.Clear();
        PremiumSlotItems[i].Day.SetText("");
        PremiumSlotItems[i].SlotCount.SetText("");
        i++;
        // [Loop Continue]
        goto J0x5D;
    }
    return;
}

function loadAttendanceReward(array<string> dStates, array<string> pStates, int nCurrentWeekPage)
{
    local ItemInfo item;
    local int i, SlotIndex, startIndex, endIndex;

    // End:0x16
    if(nCurrentWeekPage > 0)
    {
        currentPage = nCurrentWeekPage;
    }
    startIndex = (currentPage - 1) * 7;
    endIndex = Min(startIndex + 7, defaultSlots.Length);
    SlotIndex = 0;
    item.Reserved = 778;
    clearAttendanceReward();
    i = startIndex;
    J0x67:

    // End:0x219 [Loop If]
    if(i < endIndex)
    {
        // End:0x141
        if(GetItemInfoByClassID(defaultSlots[i].ItemID, item, true))
        {
            item.ItemNum = defaultSlots[i].Count;
            item.Reserved64 = (int(dStates[SlotIndex]));
            setEnchanted(defaultSlots[i].Enchant, item);
            setDefaultTakenPanel(byte(int(dStates[SlotIndex])), SlotIndex);
            setDefaultBackTextureByState(byte(int(dStates[SlotIndex])), SlotIndex);
            setDefaultSlot(SlotIndex, i + 1, item);
            setCurrentDayHighlight(i, SlotIndex);
        }
        // End:0x208
        if(pStates.Length > 0)
        {
            // End:0x208
            if(GetItemInfoByClassID(premiumSlots[i].ItemID, item, true))
            {
                item.ItemNum = premiumSlots[i].Count;
                item.Reserved64 = (int(pStates[SlotIndex]));
                setEnchanted(premiumSlots[i].Enchant, item);
                setPremiumTakenPanel(byte(int(pStates[SlotIndex])), SlotIndex);
                setPremiumBackTextureByState(byte(int(pStates[SlotIndex])), SlotIndex);
                setPremiumSlot(SlotIndex, i + 1, item);
            }
        }
        SlotIndex++;
        i++;
        // [Loop Continue]
        goto J0x67;
    }
    setControlButtons();
    Me.ShowWindow();
    return;
}

function setDefaultSlot(int SlotIndex, int nDay, ItemInfo item)
{
    DefaultSlotItems[SlotIndex].SlotItem.Clear();
    DefaultSlotItems[SlotIndex].SlotItem.AddItem(item);
    DefaultSlotItems[SlotIndex].Day.SetText(string(nDay));
    DefaultSlotItems[SlotIndex].SlotCount.SetText("x" $ MakeCostStringINT64(item.ItemNum));
    DefaultSlotItems[SlotIndex].SlotDisableWnd.HideWindow();
    setFlameAni(SlotIndex);
    return;
}

function setPremiumSlot(int SlotIndex, int nDay, ItemInfo item)
{
    PremiumSlotItems[SlotIndex].SlotItem.Clear();
    PremiumSlotItems[SlotIndex].SlotItem.AddItem(item);
    PremiumSlotItems[SlotIndex].Day.SetText(string(nDay));
    PremiumSlotItems[SlotIndex].SlotCount.SetText("x" $ MakeCostStringINT64(item.ItemNum));
    Me.KillTimer(1000000 + SlotIndex);
    Me.SetTimer(1000000 + SlotIndex, 700);
    return;
}

function showPremiumSlot(int SlotIndex)
{
    PremiumSlotItems[SlotIndex].SlotWnd.SetAlpha(0);
    PremiumSlotItems[SlotIndex].SlotWnd.SetAlpha(255, 0.2000000);
    PremiumSlotItems[SlotIndex].SlotWnd.ShowWindow();
    return;
}

function setDialogSlot(string Type, Color Col, string Day, string Count, ItemInfo item)
{
    DialogSlot.Clear();
    DialogSlot.AddItem(item);
    DialogRewardTypeTxt.SetText(Type);
    DialogRewardTypeTxt.SetTextColor(Col);
    DialogDayTxt.SetText(Day);
    DialogCountTxt.SetText(Count);
    DialogContainerWnd.ShowWindow();
    DialogAniTx.SetLoopCount(1);
    DialogAniTx.Stop();
    DialogAniTx.Play();
    return;
}

function changeOnFrontView()
{
    local int i;

    bPremiumCardOnFront = !bPremiumCardOnFront;
    i = 0;
    J0x16:

    // End:0x6C [Loop If]
    if(i < 7)
    {
        // End:0x48
        if(bPremiumCardOnFront)
        {
            PremiumSlotItems[i].SlotWnd.BringToFront();
            // [Explicit Continue]
            goto J0x62;
        }
        DefaultSlotItems[i].SlotWnd.BringToFront();
        J0x62:

        i++;
        // [Loop Continue]
        goto J0x16;
    }
    return;
}

function handleDialog(bool bIsPremium, int SlotIndex, int Index)
{
    local ItemInfo item;
    local string Day, Count, Type;
    local int claimId;
    local Color Col;

    claimId = getDay(SlotIndex);
    // End:0xA5
    if(!bIsPremium)
    {
        DefaultSlotItems[SlotIndex].SlotItem.GetItem(0, item);
        Day = DefaultSlotItems[SlotIndex].Day.GetText();
        Count = DefaultSlotItems[SlotIndex].SlotCount.GetText();
        Type = GetSystemString(7829);
        Col = getInstanceL2Util().ColorDesc;        
    }
    else
    {
        claimId += 1000;
        PremiumSlotItems[SlotIndex].SlotItem.GetItem(0, item);
        Day = PremiumSlotItems[SlotIndex].Day.GetText();
        Count = PremiumSlotItems[SlotIndex].SlotCount.GetText();
        Type = GetSystemString(7826);
        Col = GetColor(255, 215, 15, 255);
    }
    // End:0x14D
    if(isRefuseDialogAction((item.Reserved64)))
    {
        return;
    }
    ClaimBtn.SetButtonValue(claimId);
    OnClickButton("ClaimBtn");
    return;
}

function setCurrentDayHighlight(int Day, int SlotIndex)
{
    local TextureHandle Tex;

    // End:0xDC
    if(Day == (attendanceData.currentDay - 1))
    {
        Tex = GetTextureHandle("AttendCheckWndNew.RewardContainerWnd.selector2");
        Tex.SetAnchor("AttendCheckWndNew.RewardContainerWnd.DaySlot0" $ string(SlotIndex), "TopLeft", "TopLeft", -32, -28);
        Tex.SetAlpha(0);
        Tex.SetAlpha(255, 2.0000000);
    }
    return;
}

function setFlameAni(int Index)
{
    DefaultSlotItems[Index].SlotBringTx.SetLoopCount(1);
    DefaultSlotItems[Index].SlotBringTx.Stop();
    DefaultSlotItems[Index].SlotBringTx.Play();
    return;
}

function stopFlameAni()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x37 [Loop If]
    if(i < 7)
    {
        DefaultSlotItems[i].SlotBringTx.Stop();
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function setControlButtons()
{
    MonthLeftBtn.SetAlpha(115);
    MonthLeftBtn.SetAlpha(255, 0.2500000);
    MonthRightBtn.SetAlpha(115);
    MonthRightBtn.SetAlpha(255, 0.2500000);
    // End:0x70
    if(attendanceData.premium > 0)
    {
        BuyPremiumBtn.HideWindow();        
    }
    else
    {
        BuyPremiumBtn.ShowWindow();
    }
    return;
}

function setDefaultTakenPanel(AttendCheckAPI.AttendanceRewardState State, int Index)
{
    switch(State)
    {
        // End:0x71
        case 3:
            GetTextureHandle((("AttendCheckWndNew.RewardContainerWnd.DaySlot0" $ string(Index)) $ ".SlotTakenTx0") $ string(Index)).ShowWindow();
            // End:0xDC
            break;
        // End:0xFFFF
        default:
            GetTextureHandle((("AttendCheckWndNew.RewardContainerWnd.DaySlot0" $ string(Index)) $ ".SlotTakenTx0") $ string(Index)).HideWindow();
            // End:0xDC
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0DC
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0DC
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0DC
}

function setPremiumTakenPanel(AttendCheckAPI.AttendanceRewardState State, int Index)
{
    switch(State)
    {
        // End:0x7F
        case 3:
            GetTextureHandle((("AttendCheckWndNew.RewardContainerWnd.DayPremiumSlot0" $ string(Index)) $ ".PremiumSlotTakenTx0") $ string(Index)).ShowWindow();
            // End:0xF8
            break;
        // End:0xFFFF
        default:
            GetTextureHandle((("AttendCheckWndNew.RewardContainerWnd.DayPremiumSlot0" $ string(Index)) $ ".PremiumSlotTakenTx0") $ string(Index)).HideWindow();
            // End:0xF8
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0F8
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0F8
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0F8
}

function setDefaultBackTextureByState(AttendCheckAPI.AttendanceRewardState State, int Index)
{
    // End:0x135
    if(Index == (7 - 1))
    {
        switch(State)
        {
            // End:0x5C
            case 0:
                DefaultSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.DollCardDis_R");
                // End:0x133
                break;
            // End:0x61
            case 2:
            // End:0xA4
            case 1:
                DefaultSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.DollCard_R");
                // End:0x133
                break;
            // End:0xEA
            case 3:
                DefaultSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.DollCardDis_R");
                // End:0x133
                break;
            // End:0x12D
            case 4:
                DefaultSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.DollCard_R");
                // End:0x133
                break;
            // End:0xFFFF
            default:
                // End:0x133
                break;
                break;
        }
        return;
    }
    switch(State)
    {
        // End:0x187
        case 0:
            DefaultSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.RelicDisableCard_N");
            // End:0x26A
            break;
        // End:0x18C
        case 2:
        // End:0x1D6
        case 1:
            DefaultSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.RelicSummonCard_N");
            // End:0x26A
            break;
        // End:0x221
        case 3:
            DefaultSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.RelicDisableCard_N");
            // End:0x26A
            break;
        // End:0x264
        case 4:
            DefaultSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.DollCard_C");
            // End:0x26A
            break;
        // End:0xFFFF
        default:
            // End:0x26A
            break;
            break;
    }
    return;
}

function setPremiumBackTextureByState(AttendCheckAPI.AttendanceRewardState State, int Index)
{
    switch(State)
    {
        // End:0x4D
        case 0:
            PremiumSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.DollCardDis_S");
            // End:0x127
            break;
        // End:0x52
        case 2:
        // End:0x95
        case 1:
            PremiumSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.DollCard_S");
            // End:0x127
            break;
        // End:0xDB
        case 3:
            PremiumSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.DollCardDis_S");
            // End:0x127
            break;
        // End:0x121
        case 4:
            PremiumSlotItems[Index].SlotWnd.SetBackTexture("L2UI_NewTex.RelicWnd.DollCardDis_S");
            // End:0x127
            break;
        // End:0xFFFF
        default:
            // End:0x127
            break;
            break;
    }
    return;
}

function bool isRefuseDialogAction(AttendCheckAPI.AttendanceRewardState State)
{
    local int currentMin;

    switch(State)
    {
        // End:0x40
        case 0:
            getInstanceL2Util().showGfxScreenMessage(GetSystemString(7835));
            AddSystemMessageString(GetSystemString(7835));
            requestBuyPremium();
            return true;
        // End:0x73
        case 3:
            getInstanceL2Util().showGfxScreenMessage(GetSystemString(7831));
            AddSystemMessageString(GetSystemString(7831));
            return true;
        // End:0xA6
        case 4:
            getInstanceL2Util().showGfxScreenMessage(GetSystemString(7832));
            AddSystemMessageString(GetSystemString(7832));
            return true;
        // End:0x121
        case 2:
            currentMin = attendanceData.WaitingTime / 60;
            getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemString(8089), string(currentMin) @ GetSystemString(1043)));
            AddSystemMessageString(MakeFullSystemMsg(GetSystemString(8089), string(currentMin) @ GetSystemString(1043)));
            return true;
        // End:0xFFFF
        default:
            getInstanceL2Util().showGfxScreenMessage(GetSystemString(7830));
            AddSystemMessageString(GetSystemString(7830));
            return false;
            break;
    }    
    return;
}

function int getDay(int localIndex)
{
    return (((currentPage - 1) * 7) + localIndex) + 1;
    return;
}
