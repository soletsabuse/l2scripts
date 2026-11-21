class ToDoListClanWnd extends UICommonAPI;

const TIMER_CLICK = 99901;
const TIMER_DELAYC = 3000;
const STATE_COMPLETE = 0;
const STATE_BLOCK = 1;
const STATE_PROCESS = 2;
const STATE_REWARD = 3;
const TAB_NORMAL = 1;
const TAB_DEEPENING = 2;
const TAB_ACHIEVEMENTS = 3;
const TAB_EVENT = 4;
const TAB_MONTHLY = 5;

struct ToDoListInfo
{
    var LVDataRecord Record;
    var int sort0;
    var int sort1;
};

struct ToDoListClanData
{
    var int MissionID;
    var int progressCount;
    var int curState;
    var int Category;
    var bool isEventPeroid;
};

var WindowHandle Me;
var CheckBoxHandle AllLevelCheckBox;
var ListCtrlHandle ToDoList_ListCtrl;
var TextBoxHandle MissionName_Text;
var TextureHandle IconLock_texture;
var TextBoxHandle MissionDateName_Text;
var ButtonHandle RefreshBtn;
var ButtonHandle EssentialBtn;
var ButtonHandle RewardBtn;
var WindowHandle CompleteWnd_scrollarea;
var TextBoxHandle CompleteDescriotion_Text;
var WindowHandle ConditionWnd_scrollarea;
var TextBoxHandle ConditionDescriotion_Text;
var WindowHandle RewardInfoWnd_scrollarea;
var ItemWindowHandle DailyRewardItem;
var StatusBarHandle Completegage_statusbar;
var WindowHandle areaScroll;
var TextBoxHandle ClanFameInput_Text;
var TextBoxHandle PrivateFameInput_Text;
var TextBoxHandle WeekMissionNum_Text;
var TextBoxHandle WeekMission_Text;
var ButtonHandle HelpButton;
var TabHandle ToDoListClan_TabCtrl;
var WindowHandle toDoDisable_Wnd;
var WindowHandle todoComplete_Wnd;
var array<ToDoListInfo> todoArray;
var int curRewardCount;
var int maxRewardCount;
var Color Y;
var Color R;
var Color V;
var int CurrentTabIndex;
var array<ToDoListClanData> toDoClanArray;
var int serverStartTime;
var int numOfEventList;
var int numOfRewardList;
var int clientStartSec;
var TextureHandle NoticeCount[5];

function OnRegisterEvent()
{
    RegisterEvent(10440);
    RegisterEvent(10441);
    RegisterEvent(40);
    RegisterEvent(10230);
    return;
}

function Initialize()
{
    Me = GetWindowHandle("ToDoListClanWnd");
    AllLevelCheckBox = GetCheckBoxHandle("ToDoListClanWnd.AllLevelCheckBox");
    ToDoList_ListCtrl = GetListCtrlHandle("ToDoListClanWnd.ToDoList_Wnd.ToDoList_ListCtrl");
    MissionName_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.MissionName_Text");
    IconLock_texture = GetTextureHandle("ToDoListClanWnd.DetailInfo_Wnd.IconLock_texture");
    MissionDateName_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.MissionDateName_Text");
    NoticeCount[0] = GetTextureHandle("ToDoListClanWnd.TabNoticeCount0");
    NoticeCount[1] = GetTextureHandle("ToDoListClanWnd.TabNoticeCount1");
    NoticeCount[2] = GetTextureHandle("ToDoListClanWnd.TabNoticeCount2");
    NoticeCount[3] = GetTextureHandle("ToDoListClanWnd.TabNoticeCount3");
    NoticeCount[4] = GetTextureHandle("ToDoListClanWnd.TabNoticeCount4");
    RefreshBtn = GetButtonHandle("ToDoListClanWnd.RefreshBtn");
    EssentialBtn = GetButtonHandle("ToDoListClanWnd.EssentialBtn");
    areaScroll = GetWindowHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea");
    RewardInfoWnd_scrollarea = GetWindowHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea");
    RewardBtn = GetButtonHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.RewardBtn");
    DailyRewardItem = GetItemWindowHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.RewardInfoWnd_scrollarea.DailyRewardItem");
    CompleteDescriotion_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.CompleteDescriotion_Text");
    CompleteWnd_scrollarea = GetWindowHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea");
    Completegage_statusbar = GetStatusBarHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.CompleteWnd_scrollarea.Completegage_statusbar");
    ConditionDescriotion_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.ConditionWnd_scrollarea.ConditionDescriotion_Text");
    ConditionWnd_scrollarea = GetWindowHandle("ToDoListClanWnd.DetailInfo_Wnd.DetailInfo_ScrollArea.ConditionWnd_scrollarea");
    WeekMissionNum_Text = GetTextBoxHandle("ToDoListClanWnd.WeekMissionNum_Text");
    WeekMission_Text = GetTextBoxHandle("ToDoListClanWnd.WeekMission_Text");
    HelpButton = GetButtonHandle("ToDoListClanWnd.HelpButton");
    ClanFameInput_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.RewardInfoWnd_scrollarea.ClanFameInput_Text");
    PrivateFameInput_Text = GetTextBoxHandle("ToDoListClanWnd.DetailInfo_Wnd.RewardInfoWnd_scrollarea.PrivateFameInput_Text");
    ToDoListClan_TabCtrl = GetTabHandle("ToDoListClanWnd.ToDoListClan_TabCtrl");
    toDoDisable_Wnd = GetWindowHandle("ToDoListClanWnd.TodoDisable_Wnd");
    todoComplete_Wnd = GetWindowHandle("ToDoListClanWnd.TodoComplete_Wnd");
    R.R = byte(255);
    R.G = 153;
    R.B = 153;
    Y.R = byte(255);
    Y.G = byte(255);
    Y.B = 187;
    V.R = 238;
    V.G = 170;
    V.B = byte(255);
    numOfEventList = 0;
    numOfRewardList = 0;
    SetTabCompletedNum(0, 0);
    SetTabCompletedNum(1, 0);
    SetTabCompletedNum(2, 0);
    SetTabCompletedNum(3, 0);
    SetTabCompletedNum(4, 0);
    return;
}

function OnLoad()
{
    Initialize();
    setResultEmpty();
    RegisterState(getCurrentWindowName(string(self)), "GamingState");
    SetClosingOnESC();
    loadOptionToDo();
    refreshByTabIndexChage(1);
    HelpButton.SetTooltipCustomType(getCustomTooltip(GetSystemString(3688)));
    return;
}

function OnShow()
{
    Me.SetTimer(99901, 3000);
    RefreshBtn.DisableWindow();
    RequestPledgeMissionInfo();
    Me.SetFocus();
    EssenceMainDesc(GetScript("EssenceMainDesc")).CheckByType(2);
    return;
}

function OnHide()
{
    EssenceMainDesc(GetScript("EssenceMainDesc")).CheckByType(2);
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x2B
        case "AllLevelCheckBox":
            SetOptionToDo();
            refreshData();
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
            RequestPledgeMissionInfo();
            // End:0x165
            break;
        // End:0x6A
        case "EssentialBtn":
            Me.HideWindow();
            // End:0x165
            break;
        // End:0x81
        case "RewardBtn":
            requestReward();
            // End:0x165
            break;
        // End:0xA5
        case "ToDoListClan_TabCtrl0":
            refreshByTabIndexChage(1);
            // End:0x165
            break;
        // End:0xCA
        case "ToDoListClan_TabCtrl1":
            refreshByTabIndexChage(2);
            // End:0x165
            break;
        // End:0xEF
        case "ToDoListClan_TabCtrl2":
            refreshByTabIndexChage(3);
            // End:0x165
            break;
        // End:0x114
        case "ToDoListClan_TabCtrl3":
            refreshByTabIndexChage(4);
            // End:0x165
            break;
        // End:0x139
        case "ToDoListClan_TabCtrl4":
            refreshByTabIndexChage(5);
            // End:0x165
            break;
        // End:0x15F
        case "WndHelp_Button":
            ExecuteEvent(1210, "152");
            // End:0x165
            break;
        // End:0xFFFF
        default:
            // End:0x165
            break;
            break;
    }
    return;
}

function OnEvent(int a_EventID, string param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 10440:
            handlePledgeMissionInfo(param);
            // End:0x86
            break;
        // End:0x36
        case 10441:
            handlePledgeMissionRewardCount(param);
            // End:0x86
            break;
            // End:0x86
            break;
        // End:0x6A
        case 40:
            ToDoList_ListCtrl.DeleteAllItem();
            toDoClanArray.Length = 0;
            numOfEventList = 0;
            clientStartSec = 0;
            numOfRewardList = 0;
            // End:0x86
            break;
        // End:0x80
        case 10230:
            setCurrentserverTime(param);
            // End:0x86
            break;
        // End:0xFFFF
        default:
            // End:0x86
            break;
            break;
    }
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    local LVDataRecord Record;
    local PledgeMissionUIData pledgeMissionUIDataOut;

    // End:0x154
    if(ToDoList_ListCtrl.GetSelectedIndex() >= 0)
    {
        ToDoList_ListCtrl.GetSelectedRec(Record);
        GetPledgeMissionData(int(Record.szReserved), pledgeMissionUIDataOut);
        setResultTitle(Record.LVDataList[1].szData, pledgeMissionUIDataOut.IsRepeat, toDoClanArray[name(Record.nReserved1)].curState);
        setResultReward(pledgeMissionUIDataOut.RewardItems, pledgeMissionUIDataOut.RewardPledgeNameValue, pledgeMissionUIDataOut.RewardPVPPoint, toDoClanArray[name(Record.nReserved1)].curState);
        setResultConditions(pledgeMissionUIDataOut.Condition);
        setResultGoalCondition(pledgeMissionUIDataOut.GoalDesc, toDoClanArray[name(Record.nReserved1)].progressCount, pledgeMissionUIDataOut.GoalCount);
        areaScroll.SetScrollPosition(0);
        areaScroll.SetScrollHeight((RewardInfoWnd_scrollarea.GetRect().nHeight + ConditionWnd_scrollarea.GetRect().nHeight) + CompleteWnd_scrollarea.GetRect().nHeight);
    }
    return;
}

function setCurrentserverTime(string param)
{
    ParseInt(param, "ServerTime", serverStartTime);
    clientStartSec = int(GetAppSeconds());
    return;
}

function bool isEventPeroid(PledgeMissionCondition Condition)
{
    local L2UITime L2UITime;
    local int curDate, CurTime;

    // End:0x12
    if(Condition.StartDate == 0)
    {
        return true;
    }
    GetTimeStruct(int(float(serverStartTime) + (GetAppSeconds())) - clientStartSec, L2UITime);
    curDate = (int(float(L2UITime.nYear) % float(100 * 10000)) + (L2UITime.nMonth * 100)) + L2UITime.nDay;
    CurTime = (L2UITime.nHour * 100) + L2UITime.nMin;
    // End:0x138
    if((Condition.StartDate > 0) && Condition.EndDate > 0)
    {
        // End:0xE0
        if((curDate < Condition.StartDate) || curDate > Condition.EndDate)
        {
            return false;
        }
        // End:0x10C
        if((curDate == Condition.StartDate) && CurTime < Condition.StartTime)
        {
            return false;
        }
        // End:0x138
        if((curDate == Condition.EndDate) && CurTime >= Condition.EndTime)
        {
            return false;
        }
    }
    return true;
    return;
}

function handleEventMissionNum(int idx, bool isEventPeroid)
{
    // End:0x48
    if(idx != -1)
    {
        // End:0x45
        if(isEventPeroid != toDoClanArray[idx].isEventPeroid)
        {
            // End:0x3E
            if(isEventPeroid)
            {
                numOfEventList++;                
            }
            else
            {
                numOfEventList--;
            }
        }        
    }
    else
    {
        // End:0x58
        if(isEventPeroid)
        {
            numOfEventList++;
        }
    }
    ToDoListClan_TabCtrl.SetDisable(3, numOfEventList == 0);
    return;
}

function calculateFinished()
{
    local int i, nTotal, finishedTab[5];

    finishedTab[0] = 0;
    finishedTab[1] = 0;
    finishedTab[2] = 0;
    finishedTab[3] = 0;
    finishedTab[4] = 0;
    i = 0;
    J0x37:

    // End:0x133 [Loop If]
    if(i < toDoClanArray.Length)
    {
        switch(toDoClanArray[i].Category)
        {
            // End:0x80
            case 1:
                // End:0x7D
                if(toDoClanArray[i].curState == 3)
                {
                    finishedTab[0]++;
                }
                // End:0x129
                break;
            // End:0xA8
            case 2:
                // End:0xA5
                if(toDoClanArray[i].curState == 3)
                {
                    finishedTab[1]++;
                }
                // End:0x129
                break;
            // End:0xD1
            case 3:
                // End:0xCE
                if(toDoClanArray[i].curState == 3)
                {
                    finishedTab[2]++;
                }
                // End:0x129
                break;
            // End:0xFA
            case 4:
                // End:0xF7
                if(toDoClanArray[i].curState == 3)
                {
                    finishedTab[3]++;
                }
                // End:0x129
                break;
            // End:0x123
            case 5:
                // End:0x120
                if(toDoClanArray[i].curState == 3)
                {
                    finishedTab[4]++;
                }
                // End:0x129
                break;
            // End:0xFFFF
            default:
                // End:0x129
                break;
                break;
        }
        i++;
        // [Loop Continue]
        goto J0x37;
    }
    SetTabCompletedNum(0, finishedTab[0]);
    SetTabCompletedNum(1, finishedTab[1]);
    SetTabCompletedNum(2, finishedTab[2]);
    SetTabCompletedNum(3, finishedTab[3]);
    SetTabCompletedNum(4, finishedTab[4]);
    nTotal = (((finishedTab[0] + finishedTab[1]) + finishedTab[2]) + finishedTab[3]) + finishedTab[4];
    EssenceMainDesc(GetScript("EssenceMainDesc")).refreshCurrentMissonCount(nTotal);
    return;
}

function OnTimer(int TimerID)
{
    // End:0x32
    if(TimerID == 99901)
    {
        RefreshBtn.EnableWindow();
        Me.KillTimer(99901);
    }
    // End:0x5B
    if(TimerID == 555555)
    {
        calculateFinished();
        Me.KillTimer(555555);
    }
    return;
}

function SetTabCompletedNum(int tabindex, int completedNum)
{
    local string TextureName;

    // End:0x3D
    if(completedNum > 9)
    {
        TextureName = "L2UI_CT1.Tab.TabNoticeCount_09" $ "Plus";        
    }
    else
    {
        // End:0x76
        if(completedNum != 0)
        {
            TextureName = "L2UI_CT1.Tab.TabNoticeCount_0" $ string(completedNum);
        }
    }
    NoticeCount[tabindex].SetTexture(TextureName);
    // End:0xB3
    if(completedNum > 0)
    {
        NoticeCount[tabindex].ShowWindow();        
    }
    else
    {
        NoticeCount[tabindex].HideWindow();
    }
    focusNum(tabindex);
    return;
}

function focusNum(int tabindex)
{
    NoticeCount[0].SetFocus();
    NoticeCount[0].BringToFront();
    NoticeCount[1].SetFocus();
    NoticeCount[1].BringToFront();
    NoticeCount[2].SetFocus();
    NoticeCount[2].BringToFront();
    NoticeCount[3].SetFocus();
    NoticeCount[3].BringToFront();
    NoticeCount[4].SetFocus();
    NoticeCount[4].BringToFront();
    return;
}

function handleCompletedMissionNum(int idx, bool isRwardState, bool isEventPeroid)
{
    local NoticeWnd script;
    local EssenceMainDesc EssenceMainDesc;
    local string param;
    local int oldNumOfRewardList;

    script = NoticeWnd(GetScript("NoticeWnd"));
    EssenceMainDesc = EssenceMainDesc(GetScript("EssenceMainDesc"));
    oldNumOfRewardList = numOfRewardList;
    // End:0xBD
    if(idx != -1)
    {
        // End:0xBA
        if((toDoClanArray[idx].isEventPeroid != isEventPeroid) || isRwardState != (toDoClanArray[idx].curState == 3))
        {
            // End:0xB3
            if(isRwardState && isEventPeroid)
            {
                numOfRewardList++;                
            }
            else
            {
                numOfRewardList--;
            }
        }        
    }
    else
    {
        // End:0xD8
        if(isRwardState && isEventPeroid)
        {
            numOfRewardList++;
        }
    }
    // End:0xE9
    if(oldNumOfRewardList == numOfRewardList)
    {
        return;
    }
    // End:0x123
    if(numOfRewardList == 0)
    {
        script.removeNoticeButton(int(script.18));
        EssenceMainDesc.showHideMissionCount(false);        
    }
    else
    {
        EssenceMainDesc.updateCurrentMissonCount(param);
    }
    Me.KillTimer(555555);
    Me.SetTimer(555555, 5);
    return;
}

function handlePledgeMissionInfo(string param)
{
    local int idx, listIndex;
    local ToDoListClanData tmpToDoListClanDataOut;
    local PledgeMissionUIData tmpPledgeMissionUIData;

    ParseInt(param, "MissionID", tmpToDoListClanDataOut.MissionID);
    ParseInt(param, "ProgressCount", tmpToDoListClanDataOut.progressCount);
    ParseInt(param, "CurState", tmpToDoListClanDataOut.curState);
    // End:0x7F
    if(!GetPledgeMissionData(tmpToDoListClanDataOut.MissionID, tmpPledgeMissionUIData))
    {
        return;
    }
    tmpToDoListClanDataOut.Category = tmpPledgeMissionUIData.Category;
    tmpToDoListClanDataOut.isEventPeroid = isEventPeroid(tmpPledgeMissionUIData.Condition);
    idx = FindIdx(tmpToDoListClanDataOut.MissionID);
    handleEventMissionNum(idx, tmpToDoListClanDataOut.isEventPeroid);
    handleCompletedMissionNum(idx, tmpToDoListClanDataOut.curState == 3, tmpToDoListClanDataOut.isEventPeroid);
    // End:0x15E
    if(idx == -1)
    {
        idx = toDoClanArray.Length;
        toDoClanArray.Length = toDoClanArray.Length + 1;
        toDoClanArray[idx] = tmpToDoListClanDataOut;
        // End:0x15B
        if(tmpPledgeMissionUIData.Category == CurrentTabIndex)
        {
            listinsert(idx);
        }        
    }
    else
    {
        toDoClanArray[idx] = tmpToDoListClanDataOut;
        // End:0x256
        if(tmpPledgeMissionUIData.Category == CurrentTabIndex)
        {
            listIndex = findListIndex(idx);
            // End:0x1B1
            if(listIndex == -1)
            {
                listinsert(idx);                
            }
            else
            {
                // End:0x1E2
                if((tmpPledgeMissionUIData.Category == 4) && !tmpToDoListClanDataOut.isEventPeroid)
                {
                    listDelete(listIndex);                    
                }
                else
                {
                    switch(toDoClanArray[idx].curState)
                    {
                        // End:0x22B
                        case 1:
                            // End:0x21D
                            if(AllLevelCheckBox.IsChecked())
                            {
                                listModify(listIndex, idx);                                
                            }
                            else
                            {
                                listDelete(listIndex);
                            }
                            // End:0x256
                            break;
                        // End:0x23D
                        case 0:
                            listDelete(listIndex);
                            // End:0x256
                            break;
                        // End:0xFFFF
                        default:
                            listModify(listIndex, idx);
                            // End:0x256
                            break;
                            break;
                    }                    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Else Position:0x256
    handleListEmpty();
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Else Position:0x256
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Else Position:0x256
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Else Position:0x256
}

function handleListEmpty()
{
    // End:0x73
    if(ToDoList_ListCtrl.GetRecordCount() == 0)
    {
        // End:0x52
        if((CurrentTabIndex == 1) && curRewardCount == maxRewardCount)
        {
            toDoDisable_Wnd.HideWindow();
            todoComplete_Wnd.ShowWindow();            
        }
        else
        {
            todoComplete_Wnd.HideWindow();
            toDoDisable_Wnd.ShowWindow();
        }        
    }
    else
    {
        toDoDisable_Wnd.HideWindow();
        todoComplete_Wnd.HideWindow();
    }
    return;
}

function listinsert(int idx)
{
    // End:0xA3
    if(toDoClanArray[idx].curState != 0)
    {
        // End:0xA3
        if(AllLevelCheckBox.IsChecked() || toDoClanArray[idx].curState != 1)
        {
            // End:0xA3
            if((toDoClanArray[idx].Category != 4) || toDoClanArray[idx].isEventPeroid)
            {
                // End:0xA3
                if((CurrentTabIndex != 1) || curRewardCount != maxRewardCount)
                {
                    ToDoList_ListCtrl.InsertRecord(makeMissionRecord(idx));
                }
            }
        }
    }
    return;
}

function listDelete(int listIndex)
{
    setResultEmpty();
    ToDoList_ListCtrl.DeleteRecord(listIndex);
    return;
}

function listModify(int listIndex, int idx)
{
    ToDoList_ListCtrl.ModifyRecord(listIndex, makeMissionRecord(idx));
    // End:0x40
    if(listIndex == ToDoList_ListCtrl.GetSelectedIndex())
    {
        OnClickListCtrlRecord("");
    }
    return;
}

function refreshData()
{
    local int i;

    ToDoList_ListCtrl.DeleteAllItem();
    i = 0;
    J0x16:

    // End:0x55 [Loop If]
    if(i < toDoClanArray.Length)
    {
        // End:0x4B
        if(toDoClanArray[i].Category == CurrentTabIndex)
        {
            listinsert(i);
        }
        i++;
        // [Loop Continue]
        goto J0x16;
    }
    handleListEmpty();
    return;
}

function handlePledgeMissionRewardCount(string param)
{
    ParseInt(param, "CurRewardCount", curRewardCount);
    ParseInt(param, "MaxRewardCount", maxRewardCount);
    WeekMissionNum_Text.SetText(((("(" $ string(curRewardCount)) $ "/") $ string(maxRewardCount)) $ ")");
    handleListEmpty();
    // End:0xBD
    if((CurrentTabIndex == 1) && curRewardCount == maxRewardCount)
    {
        ToDoList_ListCtrl.DeleteAllItem();
        toDoDisable_Wnd.HideWindow();
        todoComplete_Wnd.ShowWindow();
    }
    return;
}

function LVDataRecord makeMissionRecord(int idx)
{
    local LVDataRecord Record;
    local PledgeMissionUIData missionUIData;

    // End:0x26
    if(!GetPledgeMissionData(toDoClanArray[idx].MissionID, missionUIData))
    {
        return Record;
    }
    Record.LVDataList.Length = 3;
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[1].bUseTextColor = true;
    Record.LVDataList[2].bUseTextColor = true;
    Record.LVDataList[0].TextColor = SetTextColor(missionUIData.IsRepeat);
    // End:0xC2
    if(missionUIData.IsRepeat)
    {
        Record.LVDataList[0].szData = GetSystemString(1793);        
    }
    else
    {
        Record.LVDataList[0].szData = GetSystemString(1792);
    }
    Record.LVDataList[1].TextColor = getInstanceL2Util().BrightWhite;
    // End:0x1E9
    if(getIsEventMission(toDoClanArray[idx].MissionID))
    {
        Record.LVDataList[1].hasIcon = true;
        Record.LVDataList[1].szTexture = "L2UI_CT1.Clan.ClanMission_x2Icon";
        Record.LVDataList[1].IconPosX = 8;
        Record.LVDataList[1].nTextureWidth = 24;
        Record.LVDataList[1].nTextureHeight = 24;
        Record.LVDataList[1].nTextureU = 24;
        Record.LVDataList[1].nTextureV = 24;
        Record.LVDataList[1].HiddenStringForSorting = "0" $ missionUIData.MissionName;        
    }
    else
    {
        Record.LVDataList[1].HiddenStringForSorting = "1" $ missionUIData.MissionName;
    }
    Record.LVDataList[1].szData = missionUIData.MissionName;
    Record.LVDataList[1].textAlignment = 1;
    switch(toDoClanArray[idx].curState)
    {
        // End:0x2AA
        case 3:
            Record.LVDataList[2].TextColor = getInstanceL2Util().Yellow;
            Record.LVDataList[2].szData = GetSystemString(3586);
            Record.LVDataList[2].HiddenStringForSorting = "0";
            // End:0x5BD
            break;
        // End:0x49B
        case 2:
            Record.bUseStatusBar = true;
            Record.nStatusBarIndex = 2;
            Record.LVDataList[2].nStatusBarCurrentCount = toDoClanArray[idx].progressCount;
            Record.LVDataList[2].nStatusBarMaxCount = missionUIData.GoalCount;
            Record.strStatusBarForeLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Left3";
            Record.strStatusBarForeCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Center3";
            Record.strStatusBarForeRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_Right3";
            Record.strStatusBarBackLeftTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Left3";
            Record.strStatusBarBackCenterTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Center3";
            Record.strStatusBarBackRightTex = "L2UI_CT1.Gauges.Gauge_DF_Large_Weight_bg_Right3";
            Record.nStatusBarWidth = 110;
            Record.nStatusBarHeight = 12;
            Record.LVDataList[2].HiddenStringForSorting = "1";
            // End:0x5BD
            break;
        // End:0x5B7
        case 1:
            Record.LVDataList[2].hasIcon = true;
            Record.LVDataList[2].nTextureWidth = 14;
            Record.LVDataList[2].nTextureHeight = 14;
            Record.LVDataList[2].nTextureU = 14;
            Record.LVDataList[2].nTextureV = 14;
            Record.LVDataList[2].szTexture = "L2UI_CT1.DailyMissionWnd_IconLock";
            Record.LVDataList[2].IconPosX = 28;
            Record.LVDataList[2].FirstLineOffsetX = 5;
            Record.LVDataList[2].TextColor = R;
            Record.LVDataList[2].szData = GetSystemString(3682);
            Record.LVDataList[2].HiddenStringForSorting = "2";
            // End:0x5BD
            break;
        // End:0xFFFF
        default:
            // End:0x5BD
            break;
            break;
    }
    Record.LVDataList[0].textAlignment = 2;
    Record.LVDataList[2].textAlignment = 2;
    Record.szReserved = string(missionUIData.MissionID);
    Record.nReserved1 = (idx);
    return Record;
    return;
}

function setResultEmpty()
{
    local array<PledgeMissionRewardItem> emptyRewardItems;
    local PledgeMissionCondition emptyCondition;

    MissionName_Text.SetText("");
    MissionDateName_Text.SetText("");
    IconLock_texture.HideWindow();
    setResultReward(emptyRewardItems, 0, 0, 1);
    setResultConditions(emptyCondition);
    setResultGoalCondition("", 0, 0);
    areaScroll.SetScrollPosition(0);
    areaScroll.SetScrollHeight((RewardInfoWnd_scrollarea.GetRect().nHeight + ConditionWnd_scrollarea.GetRect().nHeight) + CompleteWnd_scrollarea.GetRect().nHeight);
    return;
}

function setResultGoalCondition(string GoalDesc, int progressCount, int GoalCount)
{
    local int resultHeight;

    resultHeight = setTextFieldHight(CompleteDescriotion_Text, GoalDesc);
    CompleteWnd_scrollarea.SetWindowSize(266, (resultHeight + 53) + 7);
    Completegage_statusbar.SetPoint(progressCount, GoalCount);
    return;
}

function string setResultMakeJob(bool JobMain, bool JobDual, bool JobSub, string conditionString)
{
    local string classString;

    // End:0x1A
    if(JobMain)
    {
        classString = GetSystemString(2340);
    }
    // End:0x58
    if(JobDual)
    {
        // End:0x40
        if(classString != "")
        {
            classString = classString $ ", ";
        }
        classString = classString $ GetSystemString(2737);
    }
    // End:0x96
    if(JobSub)
    {
        // End:0x7E
        if(classString != "")
        {
            classString = classString $ ", ";
        }
        classString = classString $ GetSystemString(2339);
    }
    // End:0xB2
    if(classString != "")
    {
        addConditionSring(classString, conditionString);
    }
    return conditionString;
    return;
}

function string setResultMakeLevelString(int MinLevel, int MaxLevel, string conditionString)
{
    local string levelString;

    // End:0x25
    if(MinLevel > 0)
    {
        levelString = string(MinLevel) @ GetSystemString(859);
    }
    // End:0x6F
    if(MaxLevel > 0)
    {
        // End:0x4E
        if(levelString != "")
        {
            levelString = levelString $ " ~ ";
        }
        levelString = (levelString $ string(MaxLevel)) @ GetSystemString(3692);
    }
    // End:0xA5
    if(levelString != "")
    {
        addConditionSring((GetSystemString(2321) @ GetSystemString(537)) @ levelString, conditionString);
    }
    return conditionString;
    return;
}

function string setResultMakeDateString(int Date)
{
    local string yearStr, monthStr, dayStr, zeroString;

    zeroString = getInstanceL2Util().makeZeroString(6, (Date));
    yearStr = Mid(zeroString, 0, 2);
    monthStr = Mid(zeroString, 2, 2);
    dayStr = Mid(zeroString, 4, 2);
    return MakeFullSystemMsg(GetSystemMessage(4467), yearStr, monthStr, dayStr);
    return;
}

function string setResultMakeTimeString(int Time)
{
    local string zeroString;

    // End:0x0E
    if(Time == 0)
    {
        return "";
    }
    zeroString = getInstanceL2Util().makeZeroString(4, (Time));
    return ((" " $ Mid(zeroString, 0, 2)) $ ":") $ Mid(zeroString, 2, 4);
    return;
}

function string getDayString(array<int> AvailableDays)
{
    local int i, Len, nCount;
    local string dayStr;

    Len = AvailableDays.Length;
    // End:0x211
    if(Len > 0)
    {
        i = 0;
        J0x1E:

        // End:0x1C9 [Loop If]
        if(i < Len)
        {
            // End:0x1BF
            if(AvailableDays[i] > 0)
            {
                nCount++;
                switch(AvailableDays[i])
                {
                    // End:0x8D
                    case 1:
                        // End:0x72
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5134);
                        // End:0x1BF
                        break;
                    // End:0xC9
                    case 2:
                        // End:0xAE
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5135);
                        // End:0x1BF
                        break;
                    // End:0x105
                    case 3:
                        // End:0xEA
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5136);
                        // End:0x1BF
                        break;
                    // End:0x141
                    case 4:
                        // End:0x126
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5137);
                        // End:0x1BF
                        break;
                    // End:0x17D
                    case 5:
                        // End:0x162
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5138);
                        // End:0x1BF
                        break;
                    // End:0x1B9
                    case 6:
                        // End:0x19E
                        if(dayStr != "")
                        {
                            dayStr = dayStr $ ",";
                        }
                        dayStr = dayStr $ GetSystemString(5139);
                        // End:0x1BF
                        break;
                    // End:0xFFFF
                    default:
                        // End:0x1BF
                        break;
                        break;
                }
            }
            i++;
            // [Loop Continue]
            goto J0x1E;
        }
        // End:0x211
        if(AvailableDays[0] == 0)
        {
            nCount++;
            // End:0x1F9
            if(dayStr != "")
            {
                dayStr = dayStr $ ",";
            }
            dayStr = dayStr $ GetSystemString(5140);
        }
    }
    // End:0x23B
    if((nCount > 6) || nCount == 0)
    {
        dayStr = GetSystemString(3613);
    }
    dayStr = ("[" $ dayStr) $ "]";
    return dayStr;
    return;
}

function requestReward()
{
    local LVDataRecord Record;

    // End:0x3B
    if(ToDoList_ListCtrl.GetSelectedIndex() >= 0)
    {
        ToDoList_ListCtrl.GetSelectedRec(Record);
        RequestPledgeMissionReward(int(Record.szReserved));
    }
    return;
}

function setResultConditions(PledgeMissionCondition Condition)
{
    local int resultHeight;
    local string conditionString;

    // End:0x38
    if(Condition.PledgeLevel > 0)
    {
        addConditionSring(MakeFullSystemMsg(GetSystemMessage(4546), string(Condition.PledgeLevel)), conditionString);
    }
    // End:0x5E
    if(Condition.PledgeMasteryName != "")
    {
        addConditionSring(Condition.PledgeMasteryName, conditionString);
    }
    conditionString = setResultMakeLevelString(Condition.MinLevel, Condition.MaxLevel, conditionString);
    conditionString = setResultMakeJob(Condition.JobMain, Condition.JobDual, Condition.JobSub, conditionString);
    // End:0xF7
    if(Condition.PreMissionID > 0)
    {
        addConditionSring((("\"" $ (getMissionNameByID(Condition.PreMissionID))) $ "\"") @ GetSystemString(898), conditionString);
    }
    // End:0x1AE
    if(Condition.StartDate != 0)
    {
        addConditionSring(GetSystemString(2099), conditionString);
        // End:0x144
        if(Condition.StartTime != 0)
        {
            conditionString = conditionString $ "\\n   ";            
        }
        else
        {
            conditionString = conditionString $ " : ";
        }
        conditionString = ((((conditionString $ (setResultMakeDateString(Condition.StartDate))) $ (setResultMakeTimeString(Condition.StartTime))) @ "~") @ (setResultMakeDateString(Condition.EndDate))) $ (setResultMakeTimeString(Condition.EndTime));
    }
    // End:0x20E
    if(Condition.ActivateTime != 0)
    {
        addConditionSring(GetSystemString(3605) $ " :", conditionString);
        conditionString = ((conditionString $ (setResultMakeTimeString(Condition.ActivateTime))) @ "~") $ (setResultMakeTimeString(Condition.DeactivateTime));
    }
    // End:0x24E
    if(Condition.AvailableDays.Length > 0)
    {
        addConditionSring((GetSystemString(3693) $ " : ") $ (getDayString(Condition.AvailableDays)), conditionString);
    }
    resultHeight = setTextFieldHight(ConditionDescriotion_Text, conditionString);
    ConditionWnd_scrollarea.SetWindowSize(266, resultHeight + 30);
    return;
}

function string getMissionNameByID(int MissionID)
{
    local PledgeMissionUIData pledgeMissionUIDataOut;

    GetPledgeMissionData(MissionID, pledgeMissionUIDataOut);
    return pledgeMissionUIDataOut.MissionName;
    return;
}

function addConditionSring(string Str, out string conditionString)
{
    local string Dot;

    // End:0x25
    if(int(GetLanguage()) == 0)
    {
        Dot = "ï¿½ï¿½";        
    }
    else
    {
        Dot = "-";
    }
    // End:0x4B
    if(conditionString != "")
    {
        conditionString = conditionString $ "\\n";
    }
    conditionString = (conditionString $ Dot) $ Str;
    return;
}

function setResultReward(array<PledgeMissionRewardItem> RewardItems, int RewardPledgeNameValue, int RewardPVPPoint, int curState)
{
    local int i;

    DailyRewardItem.Clear();
    i = 0;
    J0x16:

    // End:0x41 [Loop If]
    if(i < RewardItems.Length)
    {
        setResultRewardItems(RewardItems[i]);
        i++;
        // [Loop Continue]
        goto J0x16;
    }
    ClanFameInput_Text.SetText(MakeCostString(string(RewardPledgeNameValue)));
    PrivateFameInput_Text.SetText(MakeCostString(string(RewardPVPPoint)));
    // End:0xAB
    if(curState == 3)
    {
        RewardBtn.SetButtonName(2279);
        RewardBtn.EnableWindow();        
    }
    else
    {
        RewardBtn.SetButtonName(3604);
        RewardBtn.DisableWindow();
    }
    return;
}

function setResultRewardItems(PledgeMissionRewardItem rewarditem)
{
    local ItemInfo ItemInfo;
    local ItemID ItemID;

    ItemID.ClassID = rewarditem.ItemClassID;
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(ItemID, ItemInfo);
    ItemInfo.ItemNum = (rewarditem.ItemCount);
    DailyRewardItem.AddItem(ItemInfo);
    return;
}

function setResultTitle(string Title, bool IsRepeat, int curState)
{
    MissionName_Text.SetText(Title);
    MissionDateName_Text.SetTextColor(SetTextColor(IsRepeat));
    // End:0x55
    if(IsRepeat)
    {
        MissionDateName_Text.SetText(GetSystemString(3679));        
    }
    else
    {
        MissionDateName_Text.SetText(GetSystemString(3582));
    }
    // End:0x8C
    if(curState == 1)
    {
        IconLock_texture.ShowWindow();        
    }
    else
    {
        IconLock_texture.HideWindow();
    }
    return;
}

function int FindIdx(int MissionID)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x41 [Loop If]
    if(i < toDoClanArray.Length)
    {
        // End:0x37
        if(toDoClanArray[i].MissionID == MissionID)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function int findListIndex(int idx)
{
    local int i;
    local LVDataRecord Record;

    i = 0;
    J0x07:

    // End:0x60 [Loop If]
    if(i < ToDoList_ListCtrl.GetRecordCount())
    {
        ToDoList_ListCtrl.GetRec(i, Record);
        // End:0x56
        if(__NFUN_412__(Record.nReserved1, (idx)))
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function refreshByTabIndexChage(int tabindex)
{
    // End:0x8E
    if(CurrentTabIndex != tabindex)
    {
        CurrentTabIndex = tabindex;
        setResultEmpty();
        refreshData();
        // End:0x61
        if(CurrentTabIndex == 1)
        {
            WeekMissionNum_Text.ShowWindow();
            WeekMission_Text.ShowWindow();
            HelpButton.ShowWindow();            
        }
        else
        {
            WeekMissionNum_Text.HideWindow();
            WeekMission_Text.HideWindow();
            HelpButton.HideWindow();
        }
    }
    focusNum(tabindex);
    return;
}

function Color SetTextColor(bool isRefeat)
{
    // End:0x0F
    if(isRefeat)
    {
        return V;
    }
    return Y;
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
    sNextStringWithWidth = DivideStringWithWidth(txtWnd.GetText(), nWidth);
    J0x69:

    // End:0x90 [Loop If]
    if(sNextStringWithWidth != "")
    {
        sNextStringWithWidth = NextStringWithWidth(nWidth);
        i++;
        // [Loop Continue]
        goto J0x69;
    }
    descHeight = i * (defaultHeight + 1);
    txtWnd.SetWindowSize(nWidth, descHeight);
    return descHeight;
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

function SetOptionToDo()
{
    local bool bChecked;

    bChecked = AllLevelCheckBox.IsChecked();
    SetOptionBool("UI", "TodoListClan", bChecked);
    return;
}

function loadOptionToDo()
{
    local bool bChecked;

    bChecked = GetOptionBool("UI", "TodoListClan");
    AllLevelCheckBox.SetCheck(bChecked);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}

function bool getIsEventMission(int Id)
{
    return false;
    switch(Id)
    {
        // End:0x11
        case 1001:
        // End:0x19
        case 1003:
        // End:0x21
        case 1004:
        // End:0x29
        case 1005:
        // End:0x31
        case 1007:
        // End:0x39
        case 1014:
        // End:0x41
        case 1015:
        // End:0x49
        case 1016:
        // End:0x51
        case 1017:
        // End:0x59
        case 2001:
        // End:0x61
        case 2002:
        // End:0x69
        case 2003:
        // End:0x71
        case 2004:
        // End:0x79
        case 2006:
        // End:0x83
        case 2016:
            return true;
        // End:0xFFFF
        default:
            return false;
            break;
    }    
    return;
}
