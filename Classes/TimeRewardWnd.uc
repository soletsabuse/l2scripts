class TimeRewardWnd extends PacketsInfo;

const SLOT_TIMER_INDEX = 10000;
const SLOT_MAX_WITH_SPECIAL = 6;
const SLOT_ALPHA_BRING = 500;

enum TimeRewardViewType
{
    VT_SMALL,                       // 0
    VT_EXPAND                       // 1
};

struct _TimeItem
{
    var ItemInfo item;
    var int nTime;
};

var int SLOT_MAX;
var string m_WindowName;
var WindowHandle Me;
var WindowHandle MaxWnd;
var WindowHandle MinWnd;
var ButtonHandle SwapBtn;
var TextureHandle mainBg;
var array<_TimeItem> TimeItems;
var TimeRewardWnd.TimeRewardViewType nCurrentViewType;
var int nTargetIndex;

function OnLoad()
{
    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    MinWnd = GetWindowHandle("TimeRewardWnd.MinContainer");
    MinWnd = GetWindowHandle("TimeRewardWnd.MinContainer");
    mainBg = GetTextureHandle("TimeRewardWnd.mainBg");
    SwapBtn = GetButtonHandle("TimeRewardWnd.SwapBtn");
    SLOT_MAX = 6;
    nTargetIndex = 0;
    nCurrentViewType = 0;
    switchView(0);
    ClearAll();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(3550);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1A
    if(Event_ID == 3550)
    {
        _OnEvent(param);
    }
    return;
}

function _OnEvent(string param)
{
    local int EventID;

    ParseInt(param, "EventID", EventID);
    switch(EventID)
    {
        // End:0x36
        case 1070:
            prepareTimeList(param);
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            // End:0x3C
            break;
            break;
    }
    return;
}

function prepareTimeList(string param)
{
    local int i, arrSize;
    local string rewardItemsString;
    local array<string> Items, item, HiddenItem;
    local ItemInfo Info;
    local int bIsVisibleFinalReward;

    ParseString(param, "param1", rewardItemsString);
    Items = Arr(rewardItemsString, ";", arrSize);
    SLOT_MAX = arrSize;
    TimeItems.Remove(0, TimeItems.Length);
    TimeItems.Length = SLOT_MAX;
    i = 0;
    J0x5C:

    // End:0x179 [Loop If]
    if(i < Items.Length)
    {
        item = Arr(Items[i], ",");
        Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(int(item[0])), Info);
        Info.Reserved = 778;
        Info.IconName = Locs(Info.IconName, "icon.", "iconBig.", false);
        Info.ItemNum = (int(item[1]));
        // End:0x13E
        if(int(item[2]) == 0)
        {
            Info.IconPanel = "L2UI_NewTex.SkillWnd.SkillPanel_01Disable";
        }
        TimeItems[i].item = Info;
        TimeItems[i].nTime = int(item[2]);
        i++;
        // [Loop Continue]
        goto J0x5C;
    }
    // End:0x19D
    if(TimeItems.Length > 0)
    {
        loadTimeRewardList();
        Me.ShowWindow();        
    }
    else
    {
        Me.HideWindow();
    }
    return;
}

function loadTimeRewardList()
{
    local int i, LastTime;
    local ItemInfo Info;

    ClearAll();
    nTargetIndex = -1;
    LastTime = 0;
    i = 0;
    J0x1F:

    // End:0x149 [Loop If]
    if(i < TimeItems.Length)
    {
        // End:0xBC
        if(TimeItems[i].nTime > 0)
        {
            // End:0x5B
            if(nTargetIndex < 0)
            {
                nTargetIndex = i;
            }
            TimeItems[i].item.IconPanel = "";
            showTargetSlotUI(i);
            Me.KillTimer(i + 10000);
            Me.SetTimer(i + 10000, 1000);            
        }
        else
        {
            TimeItems[i].item.IconPanel = "L2UI_NewTex.SkillWnd.SkillPanel_01Disable";
        }
        SetItem(i, TimeItems[i].item, TimeItems[i].nTime);
        LastTime += TimeItems[i].nTime;
        i++;
        // [Loop Continue]
        goto J0x1F;
    }
    // End:0x162
    if(LastTime == 0)
    {
        nTargetIndex = SLOT_MAX - 1;
    }
    // End:0x1A7
    if(SLOT_MAX == 6)
    {
        GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot06").ClearTooltip();
    }
    switchView(nCurrentViewType);
    return;
}

function SetItem(int Index, ItemInfo item, int nTime)
{
    // End:0xD0
    if(!GetItemWindowHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".RewardItem0") $ string(Index + 1)).super(TimeRewardWnd).SetItem(0, item))
    {
        GetItemWindowHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".RewardItem0") $ string(Index + 1)).AddItem(item);
    }
    setItemTime(Index, nTime);
    return;
}

function setItemTime(int Index, int Time)
{
    // End:0x27A
    if(Time > 0)
    {
        // End:0xA7
        if((Index + 1) == 6)
        {
            GetTextureHandle(("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".RewardSlotsTex").SetTexture("L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCardSmall_05");            
        }
        else
        {
            GetTextureHandle(("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".RewardSlotsTex").SetTexture("L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCardSmall_01");
        }
        GetTextBoxHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".TimeLeftTxt0") $ string(Index + 1)).SetFontIDByName("calibri");
        GetTextBoxHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".TimeLeftTxt0") $ string(Index + 1)).SetTextColor(getInstanceL2Util().ColorMinimapFont);
        GetTextBoxHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".TimeLeftTxt0") $ string(Index + 1)).SetText(getSecToTimeStr(Time));        
    }
    else
    {
        // End:0x316
        if((Index + 1) == 6)
        {
            GetTextureHandle(("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".RewardSlotsTex").SetTexture("L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCardSmall_05");            
        }
        else
        {
            GetTextureHandle(("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".RewardSlotsTex").SetTexture("L2UI_EPIC.LCoinShopWnd.LCoinShopCraftCardSmall_02");
        }
        GetTextBoxHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".TimeLeftTxt0") $ string(Index + 1)).SetFontIDByName("hs7");
        GetTextBoxHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".TimeLeftTxt0") $ string(Index + 1)).SetText(GetSystemString(7820));
        GetTextBoxHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".TimeLeftTxt0") $ string(Index + 1)).SetTextColor(getInstanceL2Util().Yellow03);
        hideTargetSlotUI(Index);
        // End:0x507
        if(nTargetIndex == Index)
        {
            onScreenNotify(Index);
        }
    }
    return;
}

function onScreenNotify(int Index)
{
    // End:0x4B
    if(Index == (SLOT_MAX - 1))
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(7769));
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(7770));        
    }
    else
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(7767));
        getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemString(7768), getSecToTimeStrFull(TimeItems[Index + 1].nTime)));
    }
    return;
}

function setTargetItem(int Index)
{
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot01").SetAnchor("TimeRewardWnd.MinContainer", "TopLeft", "TopLeft", 9999, 4);
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)).SetAnchor("TimeRewardWnd.MinContainer", "TopLeft", "TopLeft", 6, 4);
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)).ShowWindow();
    return;
}

function switchView(TimeRewardWnd.TimeRewardViewType nView, optional bool bReload)
{
    local int i;

    nCurrentViewType = nView;
    switch(nView)
    {
        // End:0x54
        case 0:
            bringAlpha(false);
            HideSlotAnim();
            setTargetItem(nTargetIndex);
            Me.SetWindowSize(68, 92);
            SwapBtn.HideWindow();
            // End:0x9D
            break;
        // End:0x97
        case 1:
            bringAlpha(true);
            // End:0x6F
            if(bReload)
            {
                loadTimeRewardList();
            }
            Me.SetWindowSize(378, 92);
            SwapBtn.ShowWindow();
            // End:0x9D
            break;
        // End:0xFFFF
        default:
            // End:0x9D
            break;
            break;
    }
    return;
}

function HideSlotAnim()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x7D [Loop If]
    if(i < 6)
    {
        GetAnimTextureHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(i + 1)) $ ".bottomAnim0") $ string(i + 1)).HideWindow();
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function hideTargetSlotUI(int Index)
{
    // End:0x1C
    if((int(nCurrentViewType) == 0) || Index < 0)
    {
        return;
    }
    GetAnimTextureHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".bottomAnim0") $ string(Index + 1)).HideWindow();
    return;
}

function showTargetSlotUI(int Index)
{
    // End:0x1C
    if((int(nCurrentViewType) == 0) || Index < 0)
    {
        return;
    }
    GetAnimTextureHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".bottomAnim0") $ string(Index + 1)).SetLoopCount(99999999);
    GetAnimTextureHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".bottomAnim0") $ string(Index + 1)).SetTimes(0.9000000);
    GetAnimTextureHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".bottomAnim0") $ string(Index + 1)).Play();
    GetAnimTextureHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index + 1)) $ ".bottomAnim0") $ string(Index + 1)).ShowWindow();
    return;
}

function bringAlpha(bool bShow)
{
    local int i;

    // End:0x2C
    if(bShow)
    {
        mainBg.SetAlpha(255, float("0." $ string(500)));        
    }
    else
    {
        mainBg.SetAlpha(0, float("0." $ string(100)));
    }
    i = 1;
    J0x4F:

    // End:0x79 [Loop If]
    if(i < 6)
    {
        showHideSmallSlot(i + 1, bShow);
        i++;
        // [Loop Continue]
        goto J0x4F;
    }
    return;
}

function showHideSmallSlot(int Index, bool bShow)
{
    // End:0x4D
    if(bShow)
    {
        GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index)).ShowWindow();        
    }
    else
    {
        GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot0" $ string(Index)).HideWindow();
    }
    return;
}

function showNotBuyedPremiumSlot()
{
    local ItemInfo Info;

    GetItemInfoByClassID(57, Info);
    Info.Name = GetSystemString(7817);
    Info.Description = GetSystemString(7819);
    Info.IconName = "L2UI_EPIC.BalrogWnd.QuestionmarkSlot";
    Info.Reserved = 778;
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot06").ClearTooltip();
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot06").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7819)));
    GetTextBoxHandle("TimeRewardWnd.MinContainer.RewardSlot06.TimeLeftTxt06").SetFontIDByName("hs7");
    GetTextBoxHandle("TimeRewardWnd.MinContainer.RewardSlot06.TimeLeftTxt06").SetText(GetSystemString(7818));
    GetTextBoxHandle("TimeRewardWnd.MinContainer.RewardSlot06.TimeLeftTxt06").SetTextColor(getInstanceL2Util().Yellow03);
    // End:0x28D
    if(!GetItemWindowHandle("TimeRewardWnd.MinContainer.RewardSlot06.RewardItem06").SetItem(0, Info))
    {
        GetItemWindowHandle("TimeRewardWnd.MinContainer.RewardSlot06.RewardItem06").AddItem(Info);
    }
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot06").ShowWindow();
    return;
}

function OnTimer(int TimerID)
{
    local int SlotIndex, nLeftTime;

    // End:0x2C
    if(TimerID == 1000)
    {
        Me.KillTimer(TimerID);
        switchView(1, true);
    }
    // End:0x58
    if(TimerID == 1001)
    {
        Me.KillTimer(TimerID);
        switchView(0, true);
    }
    // End:0xE3
    if(TimerID >= 10000)
    {
        SlotIndex = TimerID - 10000;
        nLeftTime = TimeItems[SlotIndex].nTime;
        // End:0xB6
        if(nLeftTime <= 0)
        {
            Me.KillTimer(TimerID);
            loadTimeRewardList();
            return;
        }
        nLeftTime--;
        TimeItems[SlotIndex].nTime = nLeftTime;
        setItemTime(SlotIndex, nLeftTime);
    }
    return;
}

event OnMouseMove(WindowHandle a_WindowHandle, int X, int Y)
{
    // End:0x0F
    if(!IsKeyDown(1))
    {
        return;
    }
    Me.KillTimer(1000);
    Me.KillTimer(1001);
    switchView(0);
    return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    // End:0x6B
    if((InStr(a_WindowHandle.GetWindowName(), "RewardSlot06") > -1) || InStr(a_WindowHandle.GetWindowName(), "RewardItem06") > -1)
    {
        RequestBypassToServer("showms" @ string(77500));
    }
    Me.KillTimer(1000);
    Me.KillTimer(1001);
    switchView(0);
    return;
}

function OnMouseOver(WindowHandle W)
{
    Me.KillTimer(1001);
    Me.KillTimer(1000);
    Me.SetTimer(1000, 500);
    return;
}

function OnMouseOut(WindowHandle W)
{
    Me.KillTimer(1000);
    Me.KillTimer(1001);
    Me.SetTimer(1001, 500);
    return;
}

function ClearAll()
{
    local int i;

    resetRewardSlots();
    HideSlotAnim();
    i = 0;
    J0x13:

    // End:0x105 [Loop If]
    if(i < 6)
    {
        GetTextBoxHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(i)) $ ".TimeLeftTxt0") $ string(i)).SetFontIDByName("calibri");
        GetTextBoxHandle((("TimeRewardWnd.MinContainer.RewardSlot0" $ string(i)) $ ".TimeLeftTxt0") $ string(i)).SetText("");
        Me.KillTimer(10000 + i);
        i++;
        // [Loop Continue]
        goto J0x13;
    }
    showNotBuyedPremiumSlot();
    return;
}

function resetRewardSlots()
{
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot01").SetAnchor("TimeRewardWnd.MinContainer", "TopLeft", "TopLeft", 6, 4);
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot02").SetAnchor("TimeRewardWnd.MinContainer", "TopLeft", "TopLeft", 69, 4);
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot03").SetAnchor("TimeRewardWnd.MinContainer", "TopLeft", "TopLeft", 132, 4);
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot04").SetAnchor("TimeRewardWnd.MinContainer", "TopLeft", "TopLeft", 195, 4);
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot05").SetAnchor("TimeRewardWnd.MinContainer", "TopLeft", "TopLeft", 258, 4);
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot06").SetAnchor("TimeRewardWnd.MinContainer", "TopLeft", "TopLeft", 321, 4);
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot01").ClearAnchor();
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot02").ClearAnchor();
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot03").ClearAnchor();
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot04").ClearAnchor();
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot05").ClearAnchor();
    GetWindowHandle("TimeRewardWnd.MinContainer.RewardSlot06").ClearAnchor();
    return;
}
