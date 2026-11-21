class ToDoListWnd extends UICommonAPI;

const TIMER_ID = 99900;
const TIMER_DELAY = 1000;
const TIMER_CLICK = 99901;
const TIMER_DELAYC = 3000;

struct ToDoListInfo
{
    var LVDataRecord Record;
    var int sort0;
    var int sort1;
};

var WindowHandle Me;
var CheckBoxHandle AllLevelCheckBox;
var WindowHandle ToDoList_Wnd;
var ListCtrlHandle ToDoList_ListCtrl;
var WindowHandle DetailInfo_Wnd;
var TextBoxHandle DetailInfoTitle_Text;
var TextBoxHandle MissionName_Text;
var TextureHandle IconLock_texture;
var TextBoxHandle MissionDateName_Text;
var TextureHandle divider_texture;
var TextureHandle DetailInfoMissionGroupbox_texture;
var TextureHandle DetailInfoMissionGroupboxDeco_texture;
var TextureHandle scrollGroupBox_Texture;
var TextureHandle DailyMissionListWndGroupBox_Texture;
var TextureHandle DailyMissionInfoWndGroupBox_Texture;
var ButtonHandle RefreshBtn;
var ButtonHandle EssentialBtn;
var ButtonHandle RewardBtn;
var WindowHandle CompleteWnd_scrollarea;
var TextBoxHandle CompleteDescriotion_Text;
var WindowHandle TimedWnd_scrollarea;
var TextBoxHandle TimedDescriotion_Text;
var WindowHandle RewardInfoWnd_scrollarea;
var ButtonHandle LocalfindBtn_BTN;
var ItemWindowHandle DailyRewardItem;
var StatusBarHandle Completegage_statusbar;
var WindowHandle areaScroll;
var int selectRewardID;
var int selectServerID;
var string rewardDesc;
var string rewardPeriod;
var Color R;
var Color Y;
var Color B;
var int saveIndex;
var int DayRemainTime;
var int WeekRemainTime;
var int MonthRemainTime;
var int ServerDay;
var array<ToDoListInfo> todoArray;
var int nResetPeriod;
//var delegate<OnSortCompare> __OnSortCompare__Delegate;
//var delegate<OnSortCompare1> __OnSortCompare1__Delegate;

function OnRegisterEvent()
{
    RegisterEvent(20160);
    RegisterEvent(20170);
    RegisterEvent(20171);
    RegisterEvent(20172);
    RegisterEvent(20173);
    RegisterEvent(20174);
    RegisterEvent(20175);
    return;
}

function OnShow()
{
    loadOptionToDo();
    refreshList();
    Me.SetFocus();
    EssenceMainDesc(GetScript("EssenceMainDesc")).CheckByType(2);
    return;
}

function OnHide()
{
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.SetDailyQuest("MinimapWnd.Minimap", false, selectRewardID);
    EssenceMainDesc(GetScript("EssenceMainDesc")).CheckByType(2);
    return;
}

function OnDefaultPosition()
{
    return;
}

function OnLoad()
{
    RegisterState(getCurrentWindowName(string(self)), "GamingState");
    SetClosingOnESC();
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("ToDoListWnd");
    AllLevelCheckBox = GetCheckBoxHandle("ToDoListWnd.AllLevelCheckBox");
    ToDoList_Wnd = GetWindowHandle("ToDoListWnd.ToDoList_Wnd");
    ToDoList_ListCtrl = GetListCtrlHandle("ToDoListWnd.ToDoList_Wnd.ToDoList_ListCtrl");
    DetailInfo_Wnd = GetWindowHandle("ToDoListWnd.DetailInfo_Wnd");
    DetailInfoTitle_Text = GetTextBoxHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfoTitle_Text");
    MissionName_Text = GetTextBoxHandle("ToDoListWnd.DetailInfo_Wnd.MissionName_Text");
    IconLock_texture = GetTextureHandle("ToDoListWnd.DetailInfo_Wnd.IconLock_texture");
    MissionDateName_Text = GetTextBoxHandle("ToDoListWnd.DetailInfo_Wnd.MissionDateName_Text");
    divider_texture = GetTextureHandle("ToDoListWnd.DetailInfo_Wnd.divider_texture");
    DetailInfoMissionGroupbox_texture = GetTextureHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfoMissionGroupbox_texture");
    DetailInfoMissionGroupboxDeco_texture = GetTextureHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfoMissionGroupboxDeco_texture");
    scrollGroupBox_Texture = GetTextureHandle("ToDoListWnd.DetailInfo_Wnd.scrollGroupBox_Texture");
    DailyMissionListWndGroupBox_Texture = GetTextureHandle("ToDoListWnd.DailyMissionListWndGroupBox_Texture");
    DailyMissionInfoWndGroupBox_Texture = GetTextureHandle("ToDoListWnd.DailyMissionInfoWndGroupBox_Texture");
    RefreshBtn = GetButtonHandle("ToDoListWnd.RefreshBtn");
    EssentialBtn = GetButtonHandle("ToDoListWnd.EssentialBtn");
    areaScroll = GetWindowHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfo_ScrollArea");
    RewardInfoWnd_scrollarea = GetWindowHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea");
    RewardBtn = GetButtonHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.RewardBtn");
    DailyRewardItem = GetItemWindowHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.DailyRewardItem");
    CompleteDescriotion_Text = GetTextBoxHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.CompleteDescriotion_Text");
    CompleteWnd_scrollarea = GetWindowHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea");
    LocalfindBtn_BTN = GetButtonHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.LocalfindBtn_BTN");
    Completegage_statusbar = GetStatusBarHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.Completegage_statusbar");
    TimedDescriotion_Text = GetTextBoxHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.TimedWnd_scrollarea.TimedDescriotion_Text");
    TimedWnd_scrollarea = GetWindowHandle("ToDoListWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.TimedWnd_scrollarea");
    R.R = byte(255);
    R.G = 153;
    R.B = 153;
    Y.R = byte(255);
    Y.G = byte(255);
    Y.B = 187;
    B.R = 136;
    B.G = byte(255);
    B.B = byte(255);
    saveIndex = 0;
    return;
}

function OnEvent(int a_EventID, string param)
{
    switch(a_EventID)
    {
        // End:0x3E
        case 20160:
            Debug("EV_TodoListShow : " @ param);
            openProcess(param);
            // End:0xCC
            break;
        // End:0x54
        case 20170:
            OneDayRewardListStart(param);
            // End:0xCC
            break;
        // End:0x75
        case 20171:
            Debug(param);
            OneDayRewardList(param);
            // End:0xCC
            break;
        // End:0x8B
        case 20172:
            OneDayRewardListEnd(param);
            // End:0xCC
            break;
        // End:0xA5
        case 20173:
            DailyRewardItem.Clear();
            // End:0xCC
            break;
        // End:0xBB
        case 20174:
            OneDayRewardItemList(param);
            // End:0xCC
            break;
        // End:0xC6
        case 20175:
            // End:0xCC
            break;
        // End:0xFFFF
        default:
            // End:0xCC
            break;
            break;
    }
    return;
}

function OneDayRewardListStart(string param)
{
    todoArray.Remove(0, todoArray.Length);
    ParseInt(param, "DayRemainTime", DayRemainTime);
    ParseInt(param, "WeekRemainTime", WeekRemainTime);
    ParseInt(param, "MonthRemainTime", MonthRemainTime);
    ParseInt(param, "ServerDay", ServerDay);
    ToDoList_ListCtrl.DeleteAllItem();
    Me.KillTimer(99900);
    Me.SetTimer(99900, 1000);
    return;
}

function OneDayRewardList(string param)
{
    local int CanConditionDay, CanConditionDayCount, CanConditionLvMin, CanConditionLvMax, rewardID, ServerID,
	    rewardStatus, CurrentCount, maxCount, NewEvent, ShowQuestRange,
	    ResetPeriod;

    local string rewardName;
    local int i;
    local UserInfo PlayerInfo;
    local int nSort;
    local LVDataRecord Record;
    local bool bLock;
    local string rewardBool;

    bLock = false;
    nSort = 0;
    rewardBool = "f";
    GetPlayerInfo(PlayerInfo);
    ParseInt(param, "CanConditionDayCount", CanConditionDayCount);
    ParseInt(param, "rewardID", rewardID);
    ParseInt(param, "serverID", ServerID);
    ParseInt(param, "rewardStatus", rewardStatus);
    ParseInt(param, "NewEvent", NewEvent);
    ParseInt(param, "CurrentCount", CurrentCount);
    ParseInt(param, "MaxCount", maxCount);
    ParseInt(param, "ResetPeriod", ResetPeriod);
    ParseInt(param, "CanConditionLvMin", CanConditionLvMin);
    ParseInt(param, "CanConditionLvMax", CanConditionLvMax);
    ParseInt(param, "ShowQuestRange", ShowQuestRange);
    ParseString(param, "rewardName", rewardName);
    // End:0x1A2
    if(CanConditionLvMax == 0)
    {
        CanConditionLvMax = 999;
    }
    // End:0x1D4
    if((PlayerInfo.nLevel < CanConditionLvMin) || PlayerInfo.nLevel > CanConditionLvMax)
    {
        bLock = true;
    }
    // End:0x24E
    if(CanConditionDayCount != 0)
    {
        i = 0;
        J0x1E6:

        // End:0x24E [Loop If]
        if(i < CanConditionDayCount)
        {
            ParseInt(param, "CanConditionDay" $ string(i), CanConditionDay);
            // End:0x23C
            if(ServerDay == CanConditionDay)
            {
                bLock = false;
                // [Explicit Break]
                goto J0x24E;
                // [Explicit Continue]
                goto J0x244;
            }
            bLock = true;
            J0x244:

            i++;
            // [Loop Continue]
            goto J0x1E6;
        }
    }
    J0x24E:

    Record.LVDataList.Length = 3;
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[1].bUseTextColor = true;
    Record.LVDataList[2].bUseTextColor = true;
    Record.LVDataList[0].TextColor = SetTextColor(ResetPeriod);
    switch(ResetPeriod)
    {
        // End:0x2E1
        case 1:
            Record.LVDataList[0].szData = GetSystemString(3579);
            // End:0x356
            break;
        // End:0x306
        case 2:
            Record.LVDataList[0].szData = GetSystemString(3580);
            // End:0x356
            break;
        // End:0x32B
        case 3:
            Record.LVDataList[0].szData = GetSystemString(3581);
            // End:0x356
            break;
        // End:0x350
        case 4:
            Record.LVDataList[0].szData = GetSystemString(1792);
            // End:0x356
            break;
        // End:0xFFFF
        default:
            // End:0x356
            break;
            break;
    }
    Record.LVDataList[1].TextColor = getInstanceL2Util().BrightWhite;
    switch(rewardStatus)
    {
        // End:0x3D5
        case 1:
            Record.LVDataList[2].TextColor = getInstanceL2Util().Yellow;
            Record.LVDataList[2].szData = GetSystemString(3586);
            rewardBool = "t";
            nSort = 1;
            // End:0x742
            break;
        // End:0x6CB
        case 2:
            // End:0x4ED
            if(bLock)
            {
                nSort = 3;
                Record.LVDataList[2].hasIcon = true;
                Record.LVDataList[2].nTextureWidth = 14;
                Record.LVDataList[2].nTextureHeight = 14;
                Record.LVDataList[2].nTextureU = 14;
                Record.LVDataList[2].nTextureV = 14;
                Record.LVDataList[2].szTexture = "L2UI_CT1.DailyMissionWnd_IconLock";
                Record.LVDataList[2].IconPosX = 46;
                Record.LVDataList[2].FirstLineOffsetX = 5;
                Record.LVDataList[2].TextColor = R;
                Record.LVDataList[2].szData = GetSystemString(3587);                
            }
            else
            {
                nSort = 2;
                Record.bUseStatusBar = true;
                Record.nStatusBarIndex = 2;
                Record.LVDataList[Record.nStatusBarIndex].nStatusBarCurrentCount = CurrentCount;
                Record.LVDataList[Record.nStatusBarIndex].nStatusBarMaxCount = maxCount;
                Record.strStatusBarForeLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
                Record.strStatusBarForeCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
                Record.strStatusBarForeRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";
                Record.strStatusBarBackLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Left3";
                Record.strStatusBarBackCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Center3";
                Record.strStatusBarBackRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Right3";
                Record.nStatusBarWidth = 110;
                Record.nStatusBarHeight = 12;
            }
            // End:0x742
            break;
        // End:0x73C
        case 3:
            nSort = 4;
            Record.LVDataList[1].TextColor = getInstanceL2Util().Gray;
            Record.LVDataList[2].TextColor = getInstanceL2Util().Gray;
            Record.LVDataList[2].szData = GetSystemString(898);
            // End:0x742
            break;
        // End:0xFFFF
        default:
            // End:0x742
            break;
            break;
    }
    // End:0x825
    if(NewEvent == 1)
    {
        Record.LVDataList[1].hasIcon = true;
        Record.LVDataList[1].iconPostion = true;
        Record.LVDataList[1].nTextureWidth = 41;
        Record.LVDataList[1].nTextureHeight = 19;
        Record.LVDataList[1].nTextureU = 41;
        Record.LVDataList[1].nTextureV = 19;
        Record.LVDataList[1].szTexture = "L2UI_CT1.DailyMissionWnd_IconNewt";
        Record.LVDataList[1].IconPosX = 2;
        Record.LVDataList[1].FirstLineOffsetX = 4;        
    }
    else
    {
        // End:0x907
        if(NewEvent == 2)
        {
            Record.LVDataList[1].hasIcon = true;
            Record.LVDataList[1].iconPostion = true;
            Record.LVDataList[1].nTextureWidth = 41;
            Record.LVDataList[1].nTextureHeight = 19;
            Record.LVDataList[1].nTextureU = 41;
            Record.LVDataList[1].nTextureV = 19;
            Record.LVDataList[1].szTexture = "L2UI_CT1.DailyMissionWnd_IconEvent";
            Record.LVDataList[1].IconPosX = 2;
            Record.LVDataList[1].FirstLineOffsetX = 4;
        }
    }
    Record.LVDataList[1].szData = rewardName;
    Record.LVDataList[1].textAlignment = 1;
    Debug("ï¿½Ø¿ï¿½ È®ï¿½ï¿½ï¿½ï¿½ ï¿½Ê¿ï¿½ï¿½ï¿½!!!.");
    Record.LVDataList[0].textAlignment = 2;
    Record.LVDataList[2].textAlignment = 2;
    ParamAdd(param, "rewardBool", rewardBool);
    ParamAdd(param, "Block", string(bLock));
    Record.szReserved = param;
    Record.nReserved1 = (rewardID);
    Record.nReserved2 = (ServerID);
    todoArray.Insert(todoArray.Length, 1);
    todoArray[todoArray.Length - 1].Record = Record;
    todoArray[todoArray.Length - 1].sort0 = nSort;
    todoArray[todoArray.Length - 1].sort1 = NewEvent;
    return;
}

function OneDayRewardListEnd(string param)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x8B [Loop If]
    if(i < todoArray.Length)
    {
        // End:0x4B
        if(AllLevelCheckBox.IsChecked())
        {
            ToDoList_ListCtrl.InsertRecord(todoArray[i].Record);
            // [Explicit Continue]
            goto J0x81;
        }
        // End:0x81
        if(todoArray[i].sort0 != 3)
        {
            ToDoList_ListCtrl.InsertRecord(todoArray[i].Record);
        }
        J0x81:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0xAA
    if(saveIndex < 1)
    {
        ToDoList_ListCtrl.SetSelectedIndex(0, true);        
    }
    else
    {
        ToDoList_ListCtrl.SetSelectedIndex(saveIndex, true);
    }
    OnClickListCtrlRecord("DailyRewardListCtrl");
    return;
}

function OneDayRewardItemList(string param)
{
    local ItemInfo ItemInfo;
    local ItemID ItemID;
    local int ItemCount;

    ParseItemID(param, ItemID);
    ParseInt(param, "itemCount", ItemCount);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(ItemID, ItemInfo);
    ItemInfo.ItemNum = (ItemCount);
    DailyRewardItem.AddItem(ItemInfo);
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x2B
        case "AllLevelCheckBox":
            SetOptionToDo();
            refreshList();
            // End:0x31
            break;
        // End:0xFFFF
        default:
            // End:0x31
            break;
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x47
        case "RefreshBtn":
            Me.SetTimer(99901, 3000);
            RefreshBtn.DisableWindow();
            refreshList();
            // End:0xAA
            break;
        // End:0x6A
        case "EssentialBtn":
            Me.HideWindow();
            // End:0xAA
            break;
        // End:0x86
        case "RewardBtn":
            RequestOneDayRewardReceive(selectServerID);
            // End:0xAA
            break;
        // End:0xA4
        case "LocalfindBtn_BTN":
            LocalfindBtnClick();
            // End:0xAA
            break;
        // End:0xFFFF
        default:
            // End:0xAA
            break;
            break;
    }
    return;
}

function LocalfindBtnClick()
{
    local LVDataRecord Record;
    local Vector XYZ;
    local float X, Y, Z;
    local string param;
    local MinimapWnd mapScript;
    local MinimapCtrlHandle m_MiniMap;

    mapScript = MinimapWnd(GetScript("MinimapWnd"));
    m_MiniMap = GetMinimapCtrlHandle("MinimapWnd.Minimap");
    ToDoList_ListCtrl.GetRec(saveIndex, Record);
    param = Record.szReserved;
    // End:0xBF
    if(!GetWindowHandle("MinimapWnd").IsShowWindow())
    {
        GetWindowHandle("MinimapWnd").ShowWindow();
        GetWindowHandle("MinimapWnd").SetFocus();
    }
    ParseFloat(param, "TargetX", X);
    ParseFloat(param, "TargetY", Y);
    ParseFloat(param, "TargetZ", Z);
    XYZ.X = X;
    XYZ.Y = Y;
    XYZ.Z = Z;
    mapScript.SetContinent(m_MiniMap.GetContinent(XYZ));
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", XYZ, false);
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.SetDailyQuest("MinimapWnd.Minimap", true, selectRewardID);
    return;
}

function openProcess(string a_Param)
{
    local UserInfo MyInfo;
    local int nforceOpen;

    // End:0x12
    if(!GetPlayerInfo(MyInfo))
    {
        return;
    }
    ParseInt(a_Param, "forceOpen", nforceOpen);
    // End:0x96
    if(((MyInfo.nLevel > 1) || nforceOpen == 1) && SettingSectorBool("MISSION", "OpenMissionListAtStartup"))
    {
        getInstanceL2Util().toggleWindow("ToDoListWnd", true);
    }
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    local int rewardID, ServerID, CurrentCount, maxCount;
    local LVDataRecord Record;
    local string param, rewardBool;
    local int ResetPeriod, ShowQuestRange;
    local string bLock;

    saveIndex = ToDoList_ListCtrl.GetSelectedIndex();
    // End:0x310
    if(saveIndex >= 0)
    {
        ToDoList_ListCtrl.GetSelectedRec(Record);
        param = Record.szReserved;
        ParseInt(param, "ResetPeriod", ResetPeriod);
        ParseInt(param, "rewardID", rewardID);
        ParseInt(param, "serverID", ServerID);
        ParseInt(param, "ShowQuestRange", ShowQuestRange);
        ParseInt(param, "CurrentCount", CurrentCount);
        ParseInt(param, "MaxCount", maxCount);
        ParseString(param, "rewardBool", rewardBool);
        ParseString(param, "Block", bLock);
        selectRewardID = rewardID;
        selectServerID = ServerID;
        MissionName_Text.SetText(Record.LVDataList[1].szData);
        MissionDateName_Text.SetTextColor(SetTextColor(ResetPeriod));
        switch(ResetPeriod)
        {
            // End:0x198
            case 1:
                MissionDateName_Text.SetText(GetSystemString(3583));
                // End:0x204
                break;
            // End:0x1BA
            case 2:
                MissionDateName_Text.SetText(GetSystemString(3584));
                // End:0x204
                break;
            // End:0x1DC
            case 3:
                MissionDateName_Text.SetText(GetSystemString(3585));
                // End:0x204
                break;
            // End:0x1FE
            case 4:
                MissionDateName_Text.SetText(GetSystemString(3582));
                // End:0x204
                break;
            // End:0xFFFF
            default:
                // End:0x204
                break;
                break;
        }
        RequestOneDayRewardItemList(rewardID);
        rewardDesc = RequestOneDayRewardDesc(rewardID);
        // End:0x253
        if(rewardBool == "t")
        {
            RewardBtn.SetButtonName(2279);
            RewardBtn.EnableWindow();            
        }
        else
        {
            RewardBtn.SetButtonName(3604);
            RewardBtn.DisableWindow();
        }
        // End:0x2A2
        if(ShowQuestRange == 0)
        {
            LocalfindBtn_BTN.DisableWindow();
            LocalfindBtn_BTN.HideWindow();            
        }
        else
        {
            LocalfindBtn_BTN.ShowWindow();
            LocalfindBtn_BTN.EnableWindow();
        }
        // End:0x2E2
        if(bLock == "True")
        {
            IconLock_texture.ShowWindow();            
        }
        else
        {
            IconLock_texture.HideWindow();
        }
        Completegage_statusbar.SetPoint(CurrentCount, maxCount);
        rewardInfo();
    }
    return;
}

function rewardInfo()
{
    local int resultHeight;

    selectIndexPeriod();
    resultHeight = setTextFieldHight(TimedDescriotion_Text, timeToString());
    TimedWnd_scrollarea.SetWindowSize(266, resultHeight + 30);
    resultHeight = setTextFieldHight(CompleteDescriotion_Text, rewardDesc);
    CompleteWnd_scrollarea.SetWindowSize(266, resultHeight + 53);
    areaScroll.SetScrollPosition(0);
    areaScroll.SetScrollHeight((RewardInfoWnd_scrollarea.GetRect().nHeight + TimedWnd_scrollarea.GetRect().nHeight) + CompleteWnd_scrollarea.GetRect().nHeight);
    return;
}

function int setTextFieldHight(TextBoxHandle txtWnd, string Text)
{
    local int nWidth, nHeight, defaultHeight, i, descHeight;

    local string sNextStringWithWidth;

    txtWnd.SetText(Text);
    GetTextSizeDefault(Text, nWidth, defaultHeight);
    CompleteDescriotion_Text.GetWindowSize(nWidth, nHeight);
    i = 0;
    sNextStringWithWidth = DivideStringWithWidth(Text, nWidth);
    J0x5F:

    // End:0x86 [Loop If]
    if(sNextStringWithWidth != "")
    {
        sNextStringWithWidth = NextStringWithWidth(nWidth);
        i++;
        // [Loop Continue]
        goto J0x5F;
    }
    descHeight = i * (defaultHeight + 1);
    txtWnd.SetWindowSize(nWidth, descHeight);
    return descHeight;
    return;
}

function OnTimer(int TimerID)
{
    // End:0x3C
    if(TimerID == 99900)
    {
        DayRemainTime--;
        WeekRemainTime--;
        MonthRemainTime--;
        TimedDescriotion_Text.SetText(timeToString());        
    }
    else
    {
        // End:0x6E
        if(TimerID == 99901)
        {
            RefreshBtn.EnableWindow();
            Me.KillTimer(99901);
        }
    }
    return;
}

function string timeToString()
{
    local string Str;

    switch(selectIndexPeriod())
    {
        // End:0x20
        case 1:
            Str = getTimeStringBySec(DayRemainTime);
            // End:0x71
            break;
        // End:0x39
        case 2:
            Str = getTimeStringBySec(WeekRemainTime);
            // End:0x71
            break;
        // End:0x52
        case 3:
            Str = getTimeStringBySec(MonthRemainTime);
            // End:0x71
            break;
        // End:0x6B
        case 4:
            Str = GetSystemString(1792);
            // End:0x71
            break;
        // End:0xFFFF
        default:
            // End:0x71
            break;
            break;
    }
    return Str;
    return;
}

function string getTimeStringBySec(int Sec)
{
    local int timeTemp, timeTemp0, timeTemp1;
    local string returnStr;

    returnStr = "";
    timeTemp = ((Sec / 60) / 60) / 24;
    timeTemp0 = (Sec / 60) / 60;
    timeTemp1 = Sec / 60;
    // End:0x97
    if(timeTemp > 0)
    {
        returnStr = MakeFullSystemMsg(GetSystemMessage(4466), string(timeTemp), string(float((Sec / 60) / 60) % float(24)), string(float(Sec / 60) % float(60)));        
    }
    else
    {
        // End:0xD6
        if(timeTemp0 > 0)
        {
            returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(float(Sec / 60) % float(60)));            
        }
        else
        {
            // End:0x102
            if(timeTemp1 > 0)
            {
                returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp0));                
            }
            else
            {
                returnStr = GetSystemMessage(4360);
            }
        }
    }
    return returnStr;
    return;
}

function int selectIndexPeriod()
{
    local LVDataRecord Record;
    local string param;

    ToDoList_ListCtrl.GetSelectedRec(Record);
    // End:0x52
    if(Record.szReserved != "")
    {
        param = Record.szReserved;
        ParseInt(param, "ResetPeriod", nResetPeriod);
    }
    return nResetPeriod;
    return;
}

function Color SetTextColor(int N)
{
    local Color returnColor;

    switch(N)
    {
        // End:0x19
        case 1:
            returnColor = Y;
            // End:0x58
            break;
        // End:0x2C
        case 2:
            returnColor = R;
            // End:0x58
            break;
        // End:0x3F
        case 3:
            returnColor = B;
            // End:0x58
            break;
        // End:0x52
        case 4:
            returnColor = Y;
            // End:0x58
            break;
        // End:0xFFFF
        default:
            // End:0x58
            break;
            break;
    }
    return returnColor;
    return;
}

function SetOptionToDo()
{
    local bool bChecked;

    bChecked = AllLevelCheckBox.IsChecked();
    SetOptionBool("UI", "TodoList", bChecked);
    return;
}

function loadOptionToDo()
{
    local bool bChecked;

    bChecked = GetOptionBool("UI", "TodoList");
    AllLevelCheckBox.SetCheck(bChecked);
    return;
}

function refreshList()
{
    RequestTodoListOneDayReward();
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}

delegate int OnSortCompare(ToDoListInfo A, ToDoListInfo B)
{
    // End:0x22
    if(A.sort0 > B.sort0)
    {
        return -1;        
    }
    else
    {
        return 0;
    }
    return;
}

delegate int OnSortCompare1(ToDoListInfo A, ToDoListInfo B)
{
    // End:0x22
    if(A.sort1 < B.sort1)
    {
        return -1;        
    }
    else
    {
        return 0;
    }
    return;
}
