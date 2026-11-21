class EventInfoWnd extends UICommonAPI;

const TIMER_ID = 112221;
const EVENTTYPE_13thANNIVE = 11;

var WindowHandle Me;
var WindowHandle EventInfoList_Wnd;
var ListCtrlHandle ToDoList_ListCtrl;
var WindowHandle EventDetailInfo_Wnd;
var ButtonHandle EssentialBtn;
var TextBoxHandle EventName_text;
var TextBoxHandle EventNameDetail_text;
var HtmlHandle EventDescription_HtmlViewer;
var TextureHandle EventIcon_texture;
var int clientStartSec;
var int addTimeSec;
var int currentTimeSec;
var L2UITime L2UITime;
var int serverStartTime;
var bool hasNoticeIcon;

function OnRegisterEvent()
{
    RegisterEvent(10230);
    RegisterEvent(40);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function OnShow()
{
    checkNeedNotice();
    refreshList();
    return;
}

function refreshList()
{
    local int nDataCount, i;
    local EventAlarmUIData EventData;
    local bool bTodayIsEventDay;

    ToDoList_ListCtrl.DeleteAllItem();
    nDataCount = GetEventAlarmDataCount();
    i = 0;
    J0x22:

    // End:0xF7 [Loop If]
    if(i < nDataCount)
    {
        GetEventAlarmDataByIndex(i, EventData);
        // End:0xED
        if(EventData.nEventID > 0)
        {
            // End:0x65
            if(EventData.nEventType == 11)
            {
                // [Explicit Continue]
                goto J0xED;
            }
            bTodayIsEventDay = ((isEventPeroid(EventData)) && isEventDay(EventData.nEventDay, L2UITime.nWeekDay)) && isEventOnTime(EventData);
            // End:0xED
            if(isEventPeroid(EventData))
            {
                AddListData(EventData.strTitle, EventData.strEventDesc, EventData.strNotifyIcon, EventData.nEventType, i, bTodayIsEventDay);
            }
        }
        J0xED:

        i++;
        // [Loop Continue]
        goto J0x22;
    }
    // End:0x134
    if(ToDoList_ListCtrl.GetRecordCount() > 0)
    {
        ToDoList_ListCtrl.SetSelectedIndex(0, true);
        OnClickListCtrlRecord("");
        ToDoList_ListCtrl.SetFocus();
    }
    return;
}

function Initialize()
{
    Me = GetWindowHandle("EventInfoWnd");
    EventInfoList_Wnd = GetWindowHandle("EventInfoWnd.EventInfoList_Wnd");
    EventDetailInfo_Wnd = GetWindowHandle("EventInfoWnd.EventDetailInfo_Wnd");
    ToDoList_ListCtrl = GetListCtrlHandle("EventInfoWnd.EventInfoList_Wnd.ToDoList_ListCtrl");
    EventName_text = GetTextBoxHandle("EventInfoWnd.EventDetailInfo_Wnd.EventName_text");
    EventNameDetail_text = GetTextBoxHandle("EventInfoWnd.EventDetailInfo_Wnd.EventNameDetail_text");
    EventIcon_texture = GetTextureHandle("EventDetailInfo_Wnd.EventIcon_texture");
    EventDescription_HtmlViewer = GetHtmlHandle("EventInfoWnd.EventDetailInfo_Wnd.EventDescription_HtmlViewer");
    EssentialBtn = GetButtonHandle("EventInfoWnd.EssentialBtn");
    return;
}

function AddListData(string Title, string Desc, string IconName, int nEventType, int Index, bool bTodayIsEventDay)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 1;
    Record.LVDataList[0].nReserved1 = Index;
    Record.LVDataList[0].szData = getEventStr(nEventType);
    Record.LVDataList[0].bUseTextColor = true;
    // End:0x82
    if(bTodayIsEventDay)
    {
        Record.LVDataList[0].TextColor = getInstanceL2Util().Yellow;        
    }
    else
    {
        Record.LVDataList[0].TextColor = GetColor(175, 152, 120, 255);
    }
    Record.LVDataList[0].hasIcon = true;
    Record.LVDataList[0].nTextureWidth = 32;
    Record.LVDataList[0].nTextureHeight = 32;
    Record.LVDataList[0].nTextureU = 32;
    Record.LVDataList[0].nTextureV = 32;
    Record.LVDataList[0].szTexture = IconName;
    Record.LVDataList[0].IconPosX = 10;
    Record.LVDataList[0].FirstLineOffsetX = 6;
    Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
    Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
    Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
    Record.LVDataList[0].backTexWidth = 36;
    Record.LVDataList[0].backTexHeight = 36;
    Record.LVDataList[0].backTexUL = 36;
    Record.LVDataList[0].backTexVL = 36;
    // End:0x2B4
    if(bTodayIsEventDay == false)
    {
        Record.LVDataList[0].iconPanelName = "L2UI_CT1.Windows.WindowDisable_BG";
        Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
        Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
        Record.LVDataList[0].panelWidth = 32;
        Record.LVDataList[0].panelHeight = 32;
        Record.LVDataList[0].panelUL = 8;
        Record.LVDataList[0].panelVL = 8;
    }
    // End:0x311
    if(bTodayIsEventDay)
    {
        Record.LVDataList[0].AttrColor.R = byte(255);
        Record.LVDataList[0].AttrColor.G = byte(255);
        Record.LVDataList[0].AttrColor.B = byte(255);        
    }
    else
    {
        Record.LVDataList[0].AttrColor.R = 120;
        Record.LVDataList[0].AttrColor.G = 120;
        Record.LVDataList[0].AttrColor.B = 120;
    }
    Record.LVDataList[0].AttrStat[0] = makeShortStringByPixel(Title, 260 - 16, "..");
    ToDoList_ListCtrl.InsertRecord(Record);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1D
    if(Event_ID == 10230)
    {
        setCurrentserverTime(param);        
    }
    else
    {
        // End:0x5A
        if(Event_ID == 40)
        {
            clientStartSec = 0;
            currentTimeSec = 0;
            addTimeSec = 0;
            hasNoticeIcon = false;
            Me.KillTimer(112221);
        }
    }
    return;
}

function setCurrentserverTime(string param)
{
    clientStartSec = int(GetAppSeconds());
    addTimeSec = int((GetAppSeconds()) - float(clientStartSec));
    ParseInt(param, "ServerTime", serverStartTime);
    checkNeedNotice();
    Me.KillTimer(112221);
    Me.SetTimer(112221, 60000);
    return;
}

function OnTimer(int TimerID)
{
    // End:0x15
    if(TimerID == 112221)
    {
        checkNeedNotice();
    }
    return;
}

function checkNeedNotice()
{
    local int nDataCount, i;
    local EventAlarmUIData EventData;
    local bool bShowNotice;

    addTimeSec = int((GetAppSeconds()) - float(clientStartSec));
    currentTimeSec = serverStartTime + addTimeSec;
    GetTimeStruct(currentTimeSec, L2UITime);
    nDataCount = GetEventAlarmDataCount();
    i = 0;
    J0x4C:

    // End:0x123 [Loop If]
    if(i < nDataCount)
    {
        GetEventAlarmDataByIndex(i, EventData);
        // End:0x119
        if(EventData.nEventID > 0)
        {
            // End:0x119
            if((isEventPeroid(EventData)) && (EventData.nEventDay.Length == 0) || isEventDay(EventData.nEventDay, L2UITime.nWeekDay))
            {
                // End:0xED
                if(EventData.nEventType == 11)
                {
                    ShowWindow("AnniveEventLauncher");
                    // [Explicit Continue]
                    goto J0x119;                    
                }
                else
                {
                    bShowNotice = true;
                }
                // End:0x119
                if(hasNoticeIcon == false)
                {
                    getInstanceNoticeWnd().EventInfoArrived();
                    hasNoticeIcon = true;
                }
            }
        }
        J0x119:

        i++;
        // [Loop Continue]
        goto J0x4C;
    }
    // End:0x147
    if(bShowNotice == false)
    {
        hasNoticeIcon = false;
        getInstanceNoticeWnd().hideNoticeButton_EventInfo();
    }
    return;
}

function bool isEventPeroid(EventAlarmUIData EventData)
{
    // End:0x2C
    if((currentTimeSec >= EventData.nIntTimeStart) && currentTimeSec <= EventData.nIntTimeEnd)
    {
        return true;
    }
    return false;
    return;
}

function bool isEventOnTime(EventAlarmUIData EventData)
{
    local string hourStr, hourEndStr, minuteStr, minuteEndStr;
    local int startM, endM, currentM;

    hourStr = "0";
    minuteStr = "0";
    // End:0x75
    if(EventData.nActivateTime > 0)
    {
        hourStr = Mid(getInstanceL2Util().makeZeroString(4, (EventData.nActivateTime)), 0, 2);
        minuteStr = Mid(getInstanceL2Util().makeZeroString(4, (EventData.nActivateTime)), 2, 2);
    }
    hourEndStr = "0";
    minuteEndStr = "0";
    // End:0xEA
    if(EventData.nDeactivateTime > 0)
    {
        hourEndStr = Mid(getInstanceL2Util().makeZeroString(4, (EventData.nDeactivateTime)), 0, 2);
        minuteEndStr = Mid(getInstanceL2Util().makeZeroString(4, (EventData.nDeactivateTime)), 2, 2);
    }
    // End:0x129
    if((((int(hourStr) <= 0) && int(minuteStr) <= 0) && int(hourEndStr) <= 0) && int(minuteEndStr) <= 0)
    {
        return true;        
    }
    else
    {
        // End:0x1C3
        if((getMinute(int(hourStr), int(minuteStr))) <= (getMinute(int(hourEndStr), int(minuteEndStr))))
        {
            // End:0x1C0
            if(((getMinute(L2UITime.nHour, L2UITime.nMin)) >= (getMinute(int(hourStr), int(minuteStr)))) && (getMinute(L2UITime.nHour, L2UITime.nMin)) < (getMinute(int(hourEndStr), int(minuteEndStr))))
            {
                return true;
            }            
        }
        else
        {
            startM = getMinute(int(hourStr), int(minuteStr));
            endM = getMinute(int(hourEndStr), int(minuteEndStr));
            currentM = getMinute(L2UITime.nHour, L2UITime.nMin);
            // End:0x25B
            if((startM > currentM) && currentM <= endM)
            {
                currentM = getMinute(L2UITime.nHour + 24, L2UITime.nMin);
            }
            endM = getMinute(int(hourEndStr) + 24, int(minuteEndStr));
            // End:0x29B
            if((currentM >= startM) && currentM < endM)
            {
                return true;
            }
        }
    }
    return false;
    return;
}

function int getMinute(int nHour, int nMin)
{
    return (nHour * 60) + nMin;
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x21
        case "EssentialBtn":
            OnEssentialBtnClick();
            // End:0x24
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEssentialBtnClick()
{
    Me.HideWindow();
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    local LVDataRecord Record;
    local int nSelect;

    nSelect = ToDoList_ListCtrl.GetSelectedIndex();
    // End:0x5A
    if(nSelect >= 0)
    {
        ToDoList_ListCtrl.GetSelectedRec(Record);
        showDetailPage(Record.LVDataList[0].nReserved1);
        ToDoList_ListCtrl.SetFocus();
    }
    return;
}

function showDetailPage(int Index)
{
    local EventAlarmUIData EventData;
    local string htmlStr, addDate;

    GetEventAlarmDataByIndex(Index, EventData);
    EventIcon_texture.SetTexture(EventData.strNotifyIcon);
    EventName_text.SetText(makeShortStringByPixel(EventData.strTitle, 260, ".."));
    EventName_text.SetTooltipString(EventData.strTitle);
    EventNameDetail_text.SetText(getEventStr(EventData.nEventType));
    addDate = (((((((((((("<table width=290 cellpadding=0 border=0 cellspacing=0>" $ "<tr><td width=285>") $ (htmlfontAdd(GetSystemString(1366) $ " : ", "dddddd"))) $ (htmlfontAdd((getPeriodString(EventData)) $ "<br1>", "bbaa88"))) $ "</td></tr><br>") $ "<tr><td width=285>") $ (htmlfontAdd(GetSystemString(3605) $ " : ", "dddddd"))) $ (htmlfontAdd(getEventTimeString(EventData), "bbaa88"))) $ "</td></tr><br>") $ "<tr><td width=285><img src=L2UI_CT1.Divider.Divider_DF_Ver width=284 height=2></td></tr>") $ "<tr><td width=285><br>") $ (htmlfontAdd(EventData.strEventDesc, "999999"))) $ "</td></tr>") $ "</table><br>";
    htmlStr = ("<html><body>" $ addDate) $ "</body></html>";
    EventDescription_HtmlViewer.LoadHtmlFromString(htmlStr);
    return;
}

function string getPeriodString(EventAlarmUIData EventData)
{
    local string yearStr, monthStr, dayStr, rStr;

    yearStr = Mid(getInstanceL2Util().makeZeroString(6, (EventData.nStartDate)), 0, 2);
    monthStr = Mid(getInstanceL2Util().makeZeroString(6, (EventData.nStartDate)), 2, 2);
    dayStr = Mid(getInstanceL2Util().makeZeroString(6, (EventData.nStartDate)), 4, 2);
    rStr = MakeFullSystemMsg(GetSystemMessage(4464), yearStr, monthStr, dayStr);
    yearStr = Mid(getInstanceL2Util().makeZeroString(6, (EventData.nEndDate)), 0, 2);
    monthStr = Mid(getInstanceL2Util().makeZeroString(6, (EventData.nEndDate)), 2, 2);
    dayStr = Mid(getInstanceL2Util().makeZeroString(6, (EventData.nEndDate)), 4, 2);
    rStr = (rStr $ " ~ ") $ MakeFullSystemMsg(GetSystemMessage(4463), yearStr, monthStr, dayStr);
    return rStr;
    return;
}

function string getEventTimeString(EventAlarmUIData EventData)
{
    local string rStr, hourStr, hourEndStr, minuteStr, minuteEndStr;

    hourStr = "0";
    minuteStr = "0";
    // End:0x75
    if(EventData.nActivateTime > 0)
    {
        hourStr = Mid(getInstanceL2Util().makeZeroString(4, (EventData.nActivateTime)), 0, 2);
        minuteStr = Mid(getInstanceL2Util().makeZeroString(4, (EventData.nActivateTime)), 2, 2);
    }
    hourEndStr = "0";
    minuteEndStr = "0";
    // End:0xEA
    if(EventData.nDeactivateTime > 0)
    {
        hourEndStr = Mid(getInstanceL2Util().makeZeroString(4, (EventData.nDeactivateTime)), 0, 2);
        minuteEndStr = Mid(getInstanceL2Util().makeZeroString(4, (EventData.nDeactivateTime)), 2, 2);
    }
    // End:0x138
    if((((int(hourStr) <= 0) && int(minuteStr) <= 0) && int(hourEndStr) <= 0) && int(minuteEndStr) <= 0)
    {
        rStr = GetSystemString(3614);        
    }
    else
    {
        rStr = MakeFullSystemMsg(GetSystemMessage(4465), getDayString(EventData.nEventDay), ((hourStr $ ":") $ minuteStr) $ " ", ((hourEndStr $ ":") $ minuteEndStr) $ " ");
    }
    return rStr;
    return;
}

function string getEventStr(int nType)
{
    local string rStr;

    switch(nType)
    {
        // End:0x1F
        case 1:
            rStr = GetSystemString(3599);
            // End:0xD1
            break;
        // End:0x38
        case 2:
            rStr = GetSystemString(3600);
            // End:0xD1
            break;
        // End:0x51
        case 3:
            rStr = GetSystemString(3601);
            // End:0xD1
            break;
        // End:0x6A
        case 4:
            rStr = GetSystemString(3602);
            // End:0xD1
            break;
        // End:0x83
        case 5:
            rStr = GetSystemString(3603);
            // End:0xD1
            break;
        // End:0x9C
        case 6:
            rStr = GetSystemString(3618);
            // End:0xD1
            break;
        // End:0xB5
        case 7:
            rStr = GetSystemString(3619);
            // End:0xD1
            break;
        // End:0xCE
        case 8:
            rStr = GetSystemString(3620);
            // End:0xD1
            break;
        // End:0xFFFF
        default:
            break;
    }
    return rStr;
    return;
}

function string getDayString(array<int> nEventDay)
{
    local int i, Len, nCount;
    local string dayStr;

    Len = nEventDay.Length;
    // End:0x208
    if(Len > 0)
    {
        i = 1;
        J0x1E:

        // End:0x1C0 [Loop If]
        if(i < Len)
        {
            // End:0x1B6
            if(nEventDay[i] > 0)
            {
                nCount++;
                switch(i)
                {
                    // End:0x87
                    case 1:
                        // End:0x6C
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5134);
                        // End:0x1B6
                        break;
                    // End:0xC3
                    case 2:
                        // End:0xA8
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5135);
                        // End:0x1B6
                        break;
                    // End:0xFF
                    case 3:
                        // End:0xE4
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5136);
                        // End:0x1B6
                        break;
                    // End:0x13B
                    case 4:
                        // End:0x120
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5137);
                        // End:0x1B6
                        break;
                    // End:0x177
                    case 5:
                        // End:0x15C
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5138);
                        // End:0x1B6
                        break;
                    // End:0x1B3
                    case 6:
                        // End:0x198
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5139);
                        // End:0x1B6
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
            }
            else
            {
                i++;
                // [Loop Continue]
                goto J0x1E;
            }/* !MISMATCHING REMOVE, tried Loop got Type:Else Position:0x1B6! */
            // End:0x208
            if(nEventDay[0] > 0)
            {
                nCount++;
                // End:0x1F0
                if(dayStr != "")
                {
                    dayStr = dayStr $ ",";
                }
                dayStr = dayStr $ GetSystemString(5140);
            }
        }/* !MISMATCHING REMOVE, tried If got Type:Loop Position:0x01E! */
        // End:0x232
        if((nCount > 6) || nCount == 0)
        {
            dayStr = GetSystemString(3613);
        }
        dayStr = ("[" $ dayStr) $ "]";
        return dayStr;
        return;
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x00C! */
}

function bool isEventDay(array<int> nEventDay, int nToday)
{
    local int i, Len, nCount;

    Len = nEventDay.Length;
    i = 0;
    J0x13:

    // End:0x55 [Loop If]
    if(i < Len)
    {
        // End:0x4B
        if(nEventDay[i] > 0)
        {
            nCount++;
            // End:0x4B
            if(nToday == i)
            {
                return true;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x13;
    }
    // End:0x70
    if((nCount > 6) || nCount == 0)
    {
        return true;
    }
    return false;
    return;
}

function string htmlfontAdd(string strText, optional string FontColor)
{
    local string targetHtml;

    // End:0x1A
    if(FontColor == "")
    {
        FontColor = "d3c5ae";
    }
    targetHtml = (((("<font color=\"" $ FontColor) $ "\"") $ ">") $ strText) $ "</font>";
    return targetHtml;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
