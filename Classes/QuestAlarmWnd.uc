class QuestAlarmWnd extends UICommonAPI;

const EXPEND_CONTRACT_GAP = 37;
const CONTRACT_WIN_WIDTH = 213;
const EXPEND_WIN_WIDTH = 250;
const CONTRACT_QUEST_NAME_WIDTH = 198;
const EXPEND_QUEST_NAME_WIDTH = 235;
const CONTRACT_ITEM_NAME_WIDTH = 113;
const EXPEND_ITEM_NAME_WIDTH = 150;
const QUEST_ITEM_NUM_DEFAULT = 85;
const TEXT_HEIGHT = 18;
const WINDOW_HEIGHT_MARGIN = 10;
const MAX_ITEM = 5;
const MAX_QUEST = 5;
const MAX_QUEST_ALL = 25;

var bool isClickedAdd;
var int m_NumOfQuest;
var int i;
var int j;
var Color Gold;
var Color White;
var Color Gray;
var WindowHandle Me;
var ButtonHandle btnClose;
var WindowHandle QuestWnd[5];
var NameCtrlHandle QuestAlarmName[5];
var int QuestAlarmNameID[5];
var NameCtrlHandle QuestItemName[25];
var int QuestItemNameID[25];
var TextBoxHandle QuestItemNum[25];
var INT64 QuestItemNumInt[25];
var int QuestAlarmLevel[5];
var int MonsterQuestID;
var array<int> MonsterNpcId;
var array<int> QuestStringType;
var array<int> MonsterNumOfKillMonsters;
var QuestTreeWnd scQuestTree;
var QuestTreeDrawerWnd scQuestTreeDrawer;
var bool bOptionQuestAlarm;
var L2Util util;

function OnRegisterEvent()
{
    RegisterEvent(160);
    RegisterEvent(3060);
    RegisterEvent(3070);
    RegisterEvent(4931);
    RegisterEvent(4930);
    RegisterEvent(4932);
    RegisterEvent(2600);
    RegisterEvent(2610);
    RegisterEvent(710);
    return;
}

function OnLoad()
{
    OnRegisterEvent();
    Initialize();
    load();
    InitData();
    FitWindowSize();
    scQuestTree = QuestTreeWnd(GetScript("QuestTreeWnd"));
    scQuestTreeDrawer = QuestTreeDrawerWnd(GetScript("QuestTreeDrawerWnd"));
    util = L2Util(GetScript("L2Util"));
    return;
}

function OnDefaultPosition()
{
    local WindowHandle InfoWnd;
    local Rect infoRectWnd, MeRectWnd;
    local int currentScreenWidth, currentScreenHeight;

    // End:0x16
    if(!Me.IsShowWindow())
    {
        return;
    }
    GetCurrentResolution(currentScreenWidth, currentScreenHeight);
    InfoWnd = GetWindowHandle("InfoWnd");
    infoRectWnd = InfoWnd.GetRect();
    MeRectWnd = Me.GetRect();
    Me.MoveTo((currentScreenWidth - 3) - MeRectWnd.nWidth, (212 + 5) + infoRectWnd.nHeight);
    return;
}

function Initialize()
{
    Me = GetWindowHandle("QuestAlarmWnd");
    btnClose = GetButtonHandle("QuestAlarmWnd.btnClose");
    i = 0;
    J0x46:

    // End:0x22E [Loop If]
    if(i < 5)
    {
        QuestWnd[i] = GetWindowHandle("QuestAlarmWnd.QuestWnd" $ string(i + 1));
        QuestAlarmName[i] = GetNameCtrlHandle(("QuestAlarmWnd.QuestWnd" $ string(i + 1)) $ ".QuestAlarmName1");
        j = 0;
        J0xD9:

        // End:0x224 [Loop If]
        if(j < 5)
        {
            QuestItemName[(i * 5) + j] = GetNameCtrlHandle((("QuestAlarmWnd.QuestWnd" $ string(i + 1)) $ ".QuestItemName") $ string(j + 1));
            QuestItemNum[(i * 5) + j] = GetTextBoxHandle((("QuestAlarmWnd.QuestWnd" $ string(i + 1)) $ ".QuestItemNum") $ string(j + 1));
            QuestItemNum[(i * 5) + j].SetAnchor((("QuestAlarmWnd.QuestWnd" $ string(i + 1)) $ ".QuestItemName") $ string(j + 1), "TopRight", "TopLeft", 3, 0);
            j++;
            // [Loop Continue]
            goto J0xD9;
        }
        i++;
        // [Loop Continue]
        goto J0x46;
    }
    bOptionQuestAlarm = GetOptionBool("Game", "autoQuestAlarm");
    return;
}

function load()
{
    Gold.R = 175;
    Gold.G = 152;
    Gold.B = 120;
    Gold.A = byte(255);
    White.R = 250;
    White.G = 250;
    White.B = 250;
    White.A = byte(255);
    Gray.R = 135;
    Gray.G = 135;
    Gray.B = 135;
    Gray.A = byte(255);
    return;
}

function InitData()
{
    i = 0;
    J0x07:

    // End:0xCA [Loop If]
    if(i < 5)
    {
        QuestAlarmNameID[i] = -1;
        QuestAlarmName[i].SetName("", 0, 1);
        j = 0;
        J0x46:

        // End:0xC0 [Loop If]
        if(j < 5)
        {
            QuestItemNameID[(i * 5) + j] = -1;
            QuestItemName[(i * 5) + j].SetName("", 0, 1);
            QuestItemNum[(i * 5) + j].SetText("");
            j++;
            // [Loop Continue]
            goto J0x46;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    m_NumOfQuest = 0;
    isClickedAdd = false;
    bOptionQuestAlarm = GetOptionBool("Game", "autoQuestAlarm");
    return;
}

function UpdateOptionData()
{
    bOptionQuestAlarm = GetOptionBool("Game", "autoQuestAlarm");
    return;
}

function HandleQuestList(string param)
{
    local int i, questID, Level, needQuestItemNum, NeedItemID, Completed,
	    GoalType;

    local string QuestParam, alarmTitleStr;
    local int Max, Count;
    local bool oneCall;

    ParseInt(param, "QuestID", questID);
    ParseInt(param, "Level", Level);
    ParseInt(param, "Completed", Completed);
    Count = 0;
    oneCall = false;
    // End:0x24D
    if(Completed == 0)
    {
        // End:0x73
        if(bOptionQuestAlarm == true)
        {
            return;
        }
        QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(questID, Level);
        ParseInt(QuestParam, "Max", Max);
        i = 0;
        J0xAE:

        // End:0x24D [Loop If]
        if(i < Max)
        {
            ParseInt(QuestParam, "GoalID_" $ string(i), NeedItemID);
            ParseInt(QuestParam, "GoalNum_" $ string(i), needQuestItemNum);
            ParseInt(QuestParam, "GoalType_" $ string(i), GoalType);
            // End:0x150
            if(GoalType == 1)
            {
                alarmTitleStr = GetNpcString(NeedItemID);
                Count = needQuestItemNum;                
            }
            else
            {
                // End:0x1A0
                if(NeedItemID >= 1000000)
                {
                    alarmTitleStr = (Class'NWindow.UIDATA_NPC'.static.GetNPCName(NeedItemID - 1000000) $ " ") $ GetSystemString(2240);
                    Count = needQuestItemNum;                    
                }
                else
                {
                    alarmTitleStr = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(NeedItemID));
                    Count = name(GetInventoryItemCount(GetItemID(NeedItemID)));
                }
            }
            // End:0x224
            if(bOptionQuestAlarm == false)
            {
                AddQuestAlarmNew(questID, Class'NWindow.UIDATA_QUEST'.static.GetQuestName(questID, Level), NeedItemID, alarmTitleStr, Count, (needQuestItemNum), Level);
            }
            // End:0x243
            if(oneCall == false)
            {
                oneCall = true;
                RequestAddExpandQuestAlarm(questID);
            }
            i++;
            // [Loop Continue]
            goto J0xAE;
        }
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local int ClassID, questID, NpcID, numOfKillMonsters, isStringType;

    switch(a_EventID)
    {
        // End:0x4E
        case 710:
            ParseInt(a_Param, "QuestID", questID);
            // End:0x4B
            if(scQuestTree.m_recentlyQuestID == questID)
            {
                HandleQuestList(a_Param);
            }
            // End:0x1EA
            break;
        // End:0x59
        case 3070:
            // End:0x1EA
            break;
        // End:0x67
        case 160:
            InitData();
            // End:0x1EA
            break;
        // End:0xA0
        case 4931:
            MonsterQuestID = 0;
            MonsterNpcId.Remove(0, MonsterNpcId.Length);
            QuestStringType.Remove(0, QuestStringType.Length);
            MonsterNumOfKillMonsters.Remove(0, MonsterNumOfKillMonsters.Length);
            // End:0x1EA
            break;
        // End:0x195
        case 4930:
            ParseInt(a_Param, "questId", questID);
            ParseInt(a_Param, "npcId", NpcID);
            ParseInt(a_Param, "numOfKillMonsters", numOfKillMonsters);
            ParseInt(a_Param, "type", isStringType);
            // End:0x131
            if((NpcID == -1) && numOfKillMonsters == -1)
            {
            }
            MonsterQuestID = questID;
            // End:0x153
            if(NpcID == -1)
            {
                MonsterZeroCount();
                return;
            }
            MonsterNpcId.Insert(0, 1);
            MonsterNpcId[0] = NpcID;
            MonsterNumOfKillMonsters.Insert(0, 1);
            MonsterNumOfKillMonsters[0] = numOfKillMonsters;
            QuestStringType.Insert(0, 1);
            QuestStringType[0] = isStringType;
            // End:0x1EA
            break;
        // End:0x1A6
        case 4932:
            MonsterCountUpdate();
            // End:0x1EA
            break;
        // End:0x1E7
        case 2610:
            // End:0x1E4
            if(Me.IsShowWindow())
            {
                ParseInt(a_Param, "classID", ClassID);
                UpdateItemCount(ClassID);
            }
            // End:0x1EA
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function MonsterCountUpdate()
{
    local int i, j, k, Count, isStringType;

    i = 0;
    J0x07:

    // End:0x12F [Loop If]
    if(i < scQuestTree.ArrQuest.Length)
    {
        j = 0;
        J0x27:

        // End:0x125 [Loop If]
        if(j < scQuestTree.ArrQuest[i].ArrNeedItemIDList.Length)
        {
            // End:0x11B
            if(MonsterQuestID == scQuestTree.ArrQuest[i].questID)
            {
                Count = 0;
                k = 0;
                J0x7C:

                // End:0xE7 [Loop If]
                if(k < MonsterNpcId.Length)
                {
                    // End:0xDD
                    if(MonsterNpcId[k] == scQuestTree.ArrQuest[i].ArrNeedItemIDList[j])
                    {
                        Count = MonsterNumOfKillMonsters[k];
                        isStringType = QuestStringType[k];
                    }
                    k++;
                    // [Loop Continue]
                    goto J0x7C;
                }
                CountKillMonsterUpdate(MonsterQuestID, scQuestTree.ArrQuest[i].ArrNeedItemIDList[j], Count, isStringType);
            }
            j++;
            // [Loop Continue]
            goto J0x27;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function MonsterZeroCount()
{
    local int i, j, setLevel, GoalType;
    local string QuestParam;

    i = 0;
    J0x07:

    // End:0x10F [Loop If]
    if(i < scQuestTree.ArrQuest.Length)
    {
        j = 0;
        J0x27:

        // End:0x105 [Loop If]
        if(j < scQuestTree.ArrQuest[i].ArrNeedItemIDList.Length)
        {
            // End:0xFB
            if(MonsterQuestID == scQuestTree.ArrQuest[i].questID)
            {
                setLevel = util.getQuestLevelForID(MonsterQuestID);
                QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(MonsterQuestID, setLevel);
                ParseInt(QuestParam, "GoalType_" $ string(j), GoalType);
                CountKillMonsterUpdate(MonsterQuestID, scQuestTree.ArrQuest[i].ArrNeedItemIDList[j], 0, GoalType);
            }
            j++;
            // [Loop Continue]
            goto J0x27;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function CountKillMonsterUpdate(int questID, int NpcID, int numOfKillMonsters, int isStringType)
{
    local int i, Max;
    local array<int> needQuestItemID, needQuestItemNum;
    local string QuestParam;
    local int setLevel;
    local string Goalname;
    local int Count, GoalType;

    setLevel = util.getQuestLevelForID(questID);
    QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(questID, setLevel);
    ParseInt(QuestParam, "Max", Max);
    needQuestItemID.Length = Max;
    needQuestItemNum.Length = Max;
    i = 0;
    J0x6D:

    // End:0x296 [Loop If]
    if(i < Max)
    {
        ParseInt(QuestParam, "GoalID_" $ string(i), needQuestItemID[i]);
        ParseInt(QuestParam, "GoalNum_" $ string(i), needQuestItemNum[i]);
        ParseInt(QuestParam, "GoalType_" $ string(i), GoalType);
        // End:0x28C
        if(NpcID == needQuestItemID[i])
        {
            Goalname = "";
            // End:0x15C
            if(GoalType == 1)
            {
                UpdateAlarmItem(needQuestItemID[i], (numOfKillMonsters));
                // End:0x14E
                if(Goalname == "")
                {
                    Goalname = GetNpcString(NpcID);
                }
                Count = numOfKillMonsters;                
            }
            else
            {
                // End:0x1E4
                if((needQuestItemID[i] - 1000000) > 0)
                {
                    UpdateAlarmItem(needQuestItemID[i], (numOfKillMonsters), questID);
                    // End:0x1D6
                    if(Goalname == "")
                    {
                        Goalname = (Class'NWindow.UIDATA_NPC'.static.GetNPCName(needQuestItemID[i] - 1000000) $ " ") $ GetSystemString(2240);
                    }
                    Count = numOfKillMonsters;                    
                }
                else
                {
                    // End:0x216
                    if(Goalname == "")
                    {
                        Goalname = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(needQuestItemID[i]));
                    }
                    Count = name(GetInventoryItemCount(GetItemID(needQuestItemID[i])));
                }
            }
            // End:0x28C
            if(bOptionQuestAlarm == false)
            {
                AddQuestAlarmNew(questID, Class'NWindow.UIDATA_QUEST'.static.GetQuestName(questID, setLevel), needQuestItemID[i], Goalname, Count, (needQuestItemNum[i]), setLevel);
            }
        }
        i++;
        // [Loop Continue]
        goto J0x6D;
    }
    scQuestTree.ButtonEnableCheck();
    return;
}

function UpdateItemCount(int ClassID, optional INT64 a_ItemCount)
{
    local int i, j, k;
    local INT64 ItemCount;
    local int localQuestID, localQuestLv;
    local string Goalname;
    local ItemID ItemID;
    local bool isAddedQuest;

    isAddedQuest = false;
    i = 0;
    J0x0F:

    // End:0x2AB [Loop If]
    if(i < scQuestTree.ArrQuest.Length)
    {
        j = 0;
        J0x2F:

        // End:0x2A1 [Loop If]
        if(j < scQuestTree.ArrQuest[i].ArrNeedItemIDList.Length)
        {
            // End:0x297
            if(scQuestTree.ArrQuest[i].ArrGoalType[j] == 0)
            {
                // End:0x242
                if(ClassID == scQuestTree.ArrQuest[i].ArrNeedItemIDList[j])
                {
                    localQuestID = scQuestTree.ArrQuest[i].questID;
                    localQuestLv = scQuestTree.ArrQuest[i].Level;
                    isAddedQuest = true;
                    k = 0;
                    J0xEE:

                    // End:0x242 [Loop If]
                    if(k < scQuestTree.ArrQuest[i].ArrNeedItemIDList.Length)
                    {
                        // End:0x238
                        if(scQuestTree.ArrQuest[i].ArrGoalType[k] == 0)
                        {
                            ItemID = GetItemID(scQuestTree.ArrQuest[i].ArrNeedItemIDList[k]);
                            ItemCount = GetInventoryItemCount(ItemID);
                            UpdateAlarmItem(scQuestTree.ArrQuest[i].ArrNeedItemIDList[k], ItemCount);
                            Goalname = Class'NWindow.UIDATA_ITEM'.static.GetItemName(ItemID);
                            // End:0x238
                            if(bOptionQuestAlarm == false)
                            {
                                AddQuestAlarmNew(localQuestID, Class'NWindow.UIDATA_QUEST'.static.GetQuestName(localQuestID, localQuestLv), scQuestTree.ArrQuest[i].ArrNeedItemIDList[k], Goalname, name(ItemCount), (scQuestTree.ArrQuest[i].ArrNeedItemNumList[k]), localQuestLv);
                            }
                        }
                        k++;
                        // [Loop Continue]
                        goto J0xEE;
                    }
                }
                // End:0x297
                if(isAddedQuest)
                {
                    // End:0x286
                    if(IsThereDiffQuestType(i))
                    {
                        // End:0x286
                        if(GetOptionBool("Game", "autoQuestAlarm") == false)
                        {
                            RequestAddExpandQuestAlarm(localQuestID);
                        }
                    }
                    scQuestTree.ButtonEnableCheck();
                    return;
                }
            }
            j++;
            // [Loop Continue]
            goto J0x2F;
        }
        i++;
        // [Loop Continue]
        goto J0x0F;
    }
    return;
}

function bool IsThereDiffQuestType(int QuestNum)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x87 [Loop If]
    if(i < scQuestTree.ArrQuest[QuestNum].ArrNeedItemIDList.Length)
    {
        // End:0x52
        if(scQuestTree.ArrQuest[QuestNum].ArrGoalType[i] == 1)
        {
            return true;
        }
        // End:0x7D
        if(scQuestTree.ArrQuest[QuestNum].ArrNeedItemIDList[i] >= 1000000)
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1D
        case "btnClose":
            OnBtnCloseClick();
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnBtnCloseClick()
{
    InitData();
    // End:0x27
    if(Me.IsShowWindow())
    {
        Me.HideWindow();
    }
    return;
}

function ExpendWindowSize()
{
    local int Height;
    local string tempStr;
    local int nWidth, nHeight;

    Me.GetWindowSize(i, Height);
    Me.SetWindowSize(250, Height);
    i = 0;
    J0x36:

    // End:0xA0 [Loop If]
    if(i < 5)
    {
        QuestWnd[i].GetWindowSize(j, Height);
        QuestWnd[i].SetWindowSize(235, Height);
        QuestAlarmName[i].SetWindowSize(235, 18);
        i++;
        // [Loop Continue]
        goto J0x36;
    }
    i = 0;
    J0xA7:

    // End:0x13F [Loop If]
    if(i < 25)
    {
        tempStr = QuestItemName[i].GetName();
        GetTextSizeDefault(tempStr, nWidth, nHeight);
        // End:0x11C
        if((nWidth < 150) && nWidth > 5)
        {
            QuestItemName[i].SetWindowSize(nWidth, 18);
            // [Explicit Continue]
            goto J0x135;
        }
        QuestItemName[i].SetWindowSize(150, 18);
        J0x135:

        i++;
        // [Loop Continue]
        goto J0xA7;
    }
    Me.MoveEx(213 - 250, 0);
    return;
}

function FitWindowSize()
{
    local int Width, Height, totalHeight, oneWinHeight;

    totalHeight = 0;
    m_NumOfQuest = 0;
    i = 0;
    J0x15:

    // End:0x15C [Loop If]
    if(i < 5)
    {
        // End:0x66
        if(QuestAlarmNameID[i] == -1)
        {
            // End:0x63
            if(QuestWnd[i].IsShowWindow())
            {
                QuestWnd[i].HideWindow();
            }
            // [Explicit Continue]
            goto J0x152;
        }
        m_NumOfQuest++;
        // End:0x9C
        if(!QuestWnd[i].IsShowWindow())
        {
            QuestWnd[i].ShowWindow();
        }
        oneWinHeight = 0;
        oneWinHeight = oneWinHeight + 18;
        j = 0;
        J0xB9:

        // End:0xFE [Loop If]
        if(j < 5)
        {
            // End:0xF4
            if(QuestItemNameID[(i * 5) + j] != -1)
            {
                oneWinHeight = oneWinHeight + 18;
            }
            j++;
            // [Loop Continue]
            goto J0xB9;
        }
        totalHeight = (totalHeight + oneWinHeight) + 10;
        QuestWnd[i].GetWindowSize(Width, Height);
        QuestWnd[i].SetWindowSize(Width, oneWinHeight);
        J0x152:

        i++;
        // [Loop Continue]
        goto J0x15;
    }
    // End:0x18B
    if(m_NumOfQuest == 0)
    {
        // End:0x188
        if(Me.IsShowWindow())
        {
            Me.HideWindow();
        }        
    }
    else
    {
        Me.GetWindowSize(Width, Height);
        Me.SetWindowSize(Width, totalHeight);
        // End:0x1E0
        if(!Me.IsShowWindow())
        {
            Me.ShowWindow();
        }
    }
    return;
}

function AddQuestAlarmNew(int questID, string QuestName, int ItemID, string ItemName, int ItemCount, INT64 ItemNum, int Level)
{
    local int idx, idxItem, idxItemSomeID;
    local string tempStr;
    local Color tmpColor;

    // End:0x0E
    if(ItemName == "")
    {
        return;
    }
    idx = QuestSlotIdx(questID);
    // End:0xB2
    if(idx == -1)
    {
        idx = FindEmptyQuestSlot();
        // End:0x6D
        if(idx == -1)
        {
            // End:0x60
            if(isClickedAdd == true)
            {
                AddSystemMessage(2279);
            }
            isClickedAdd = false;
            return;            
        }
        else
        {
            QuestAlarmName[idx].SetNameWithColor(QuestName, 0, 1, Gold);
            QuestAlarmNameID[idx] = questID;
            QuestAlarmLevel[idx] = Level;
        }
    }
    idxItem = FindEmptyItemSlot(idx);
    // End:0xD7
    if(idxItem == -1)
    {
        return;        
    }
    else
    {
        idxItemSomeID = QuestItemSlotIdx(idx, ItemID);
        // End:0x28B
        if(idxItemSomeID == -1)
        {
            // End:0x118
            if(__NFUN_408__(ItemNum, (0)))
            {
                ItemNum = __NFUN_400__(ItemNum);
            }
            tempStr = "- " $ ItemName;
            // End:0x159
            if(__NFUN_408__((ItemCount), ItemNum) || __NFUN_412__(ItemNum, (0)))
            {
                tmpColor = White;                
            }
            else
            {
                tmpColor = Gray;
            }
            QuestItemName[(idx * 5) + idxItem].SetNameWithColor(tempStr, 0, 1, tmpColor);
            QuestItemNum[(idx * 5) + idxItem].SetTextColor(tmpColor);
            // End:0x1F9
            if(__NFUN_412__(ItemNum, (0)))
            {
                QuestItemNum[(idx * 5) + idxItem].SetText(("(" $ string(ItemCount)) $ ")");                
            }
            else
            {
                QuestItemNum[(idx * 5) + idxItem].SetText(((("(" $ string(ItemCount)) $ "/") $ (ItemNum)) $ ")");
            }
            QuestItemNameID[(idx * 5) + idxItem] = ItemID;
            QuestItemNumInt[(idx * 5) + idxItem] = ItemNum;
            setItemWindowSize((idx * 5) + idxItem, tempStr);
        }
    }
    FitWindowSize();
    return;
}

function setItemWindowSize(int Index, string tmpStr)
{
    local int nWidth, nWidth2, nHeight;
    local Rect myRectWnd;
    local int OffsetX;

    OffsetX = 25;
    myRectWnd = Me.GetRect();
    GetTextSizeDefault(tmpStr, nWidth, nHeight);
    GetTextSizeDefault(QuestItemNum[Index].GetText(), nWidth2, nHeight);
    QuestItemNum[Index].GetWindowSize(nWidth2, nHeight);
    // End:0xB6
    if(((nWidth + nWidth2) + OffsetX) > myRectWnd.nWidth)
    {
        nWidth = (myRectWnd.nWidth - nWidth2) - OffsetX;
    }
    QuestItemName[Index].SetWindowSize(nWidth, nHeight);
    return;
}

function CustomTooltip getQuestToolTip(int questID, int Level)
{
    local CustomTooltip m_Tooltip;
    local string questDesc, trimStr, huntingStr, tempStr, JournalName;

    local Vector questZoneLoc;
    local int questZoneID, tooltipLine;

    questZoneLoc = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(questID, Level);
    questZoneID = Class'NWindow.UIDATA_QUEST'.static.GetQuestZone(questID, Level);
    JournalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(questID, Level);
    questDesc = Class'NWindow.UIDATA_QUEST'.static.GetQuestDescription(questID, Level);
    trimStr = trim(questDesc);
    questDesc = Locs(questDesc, "\\n", " ", false);
    huntingStr = cutTheStr(questDesc, GetSystemString(3318), true);
    tempStr = cutTheStr(questDesc, GetSystemString(3318), false);
    // End:0xF4
    if(Len(tempStr) > 0)
    {
        questDesc = tempStr;
    }
    // End:0x10C
    if(Len(huntingStr) > 0)
    {
        tooltipLine = 4;        
    }
    else
    {
        tooltipLine = 3;
    }
    // End:0x38C
    if(Len(questDesc) > 0)
    {
        m_Tooltip.DrawList.Length = tooltipLine;
        m_Tooltip.MinimumWidth = 230;
        m_Tooltip.DrawList[0].eType = 1;
        m_Tooltip.DrawList[0].t_color.R = byte(255);
        m_Tooltip.DrawList[0].t_color.G = byte(255);
        m_Tooltip.DrawList[0].t_color.B = byte(255);
        m_Tooltip.DrawList[0].t_color.A = byte(255);
        m_Tooltip.DrawList[0].t_strText = JournalName;
        m_Tooltip.DrawList[1].eType = 0;
        m_Tooltip.DrawList[1].b_nHeight = 3;
        m_Tooltip.DrawList[2].eType = 1;
        m_Tooltip.DrawList[2].nOffSetY = 4;
        m_Tooltip.DrawList[2].bLineBreak = true;
        m_Tooltip.DrawList[2].t_color.R = 178;
        m_Tooltip.DrawList[2].t_color.G = 190;
        m_Tooltip.DrawList[2].t_color.B = 207;
        m_Tooltip.DrawList[2].t_color.A = byte(255);
        m_Tooltip.DrawList[2].t_strText = questDesc;
        // End:0x38C
        if(tooltipLine > 3)
        {
            m_Tooltip.DrawList[3].eType = 1;
            m_Tooltip.DrawList[3].nOffSetY = 10;
            m_Tooltip.DrawList[3].bLineBreak = true;
            m_Tooltip.DrawList[3].t_color.R = 211;
            m_Tooltip.DrawList[3].t_color.G = 30;
            m_Tooltip.DrawList[3].t_color.B = 30;
            m_Tooltip.DrawList[3].t_color.A = byte(255);
            m_Tooltip.DrawList[3].t_strText = huntingStr;
        }
    }
    return m_Tooltip;
    return;
}

function string TrimRight(string S)
{
    S = Left(S, Len(S) - 1);
    return S;
    return;
}

function string cutTheStr(string S, string t, bool cutStringEnd)
{
    local int i;

    i = InStr(S, t);
    // End:0x27
    if(i <= -1)
    {
        return "";        
    }
    else
    {
        // End:0x47
        if(cutStringEnd)
        {
            return Mid(S, i, Len(S));            
        }
        else
        {
            return Mid(S, 0, i);
        }
    }
    return;
}

function DeleteQuestAlarm(int questID)
{
    local int idx;
    local Color tempColor;
    local int nWidth, nHeight;

    idx = QuestSlotIdx(questID);
    // End:0x25
    if(idx == -1)
    {
        return;        
    }
    else
    {
        i = idx + 1;
        J0x33:

        // End:0x264 [Loop If]
        if(i < 5)
        {
            QuestAlarmName[i - 1].SetNameWithColor(QuestAlarmName[i].GetName(), 0, 1, Gold);
            QuestAlarmNameID[i - 1] = QuestAlarmNameID[i];
            QuestAlarmLevel[i - 1] = QuestAlarmLevel[i];
            j = 0;
            J0xB0:

            // End:0x25A [Loop If]
            if(j < 5)
            {
                tempColor = QuestItemNum[(i * 5) + j].GetTextColor();
                QuestItemName[((i - 1) * 5) + j].SetNameWithColor(QuestItemName[(i * 5) + j].GetName(), 0, 1, tempColor);
                QuestItemName[(i * 5) + j].GetWindowSize(nWidth, nHeight);
                QuestItemName[((i - 1) * 5) + j].SetWindowSize(nWidth, nHeight);
                QuestItemNameID[((i - 1) * 5) + j] = QuestItemNameID[(i * 5) + j];
                QuestItemNum[((i - 1) * 5) + j].SetText(QuestItemNum[(i * 5) + j].GetText());
                QuestItemNum[((i - 1) * 5) + j].SetTextColor(tempColor);
                QuestItemNumInt[((i - 1) * 5) + j] = QuestItemNumInt[(i * 5) + j];
                j++;
                // [Loop Continue]
                goto J0xB0;
            }
            i++;
            // [Loop Continue]
            goto J0x33;
        }
        idx = 5 - 1;
        QuestAlarmName[idx].SetName("", 0, 1);
        QuestAlarmNameID[idx] = -1;
        QuestAlarmLevel[idx] = -1;
        j = 0;
        J0x2B3:

        // End:0x34B [Loop If]
        if(j < 5)
        {
            QuestItemName[(idx * 5) + j].SetName("", 0, 1);
            QuestItemNameID[(idx * 5) + j] = -1;
            QuestItemNum[(idx * 5) + j].SetText("");
            QuestItemNumInt[(idx * 5) + j] = (-1);
            j++;
            // [Loop Continue]
            goto J0x2B3;
        }
    }
    FitWindowSize();
    return;
}

function UpdateAlarmItem(int ItemID, INT64 Count, optional int questID)
{
    local string NameTemp1;
    local INT64 counts;

    i = 0;
    J0x07:

    // End:0x1F7 [Loop If]
    if(i < 25)
    {
        // End:0x1ED
        if((QuestItemNameID[i] == ItemID) && ((questID == QuestAlarmNameID[i]) || questID == 0) || QuestAlarmNameID[i] == -1)
        {
            // End:0x8E
            if(__NFUN_408__(QuestItemNumInt[i], (0)))
            {
                counts = __NFUN_400__(QuestItemNumInt[i]);                
            }
            else
            {
                counts = QuestItemNumInt[i];
            }
            // End:0x11A
            if(__NFUN_408__(Count, counts) || __NFUN_412__(counts, (0)))
            {
                NameTemp1 = QuestItemName[i].GetName();
                QuestItemName[i].SetNameWithColor(NameTemp1, 0, 1, White);
                QuestItemNum[i].SetTextColor(White);                
            }
            else
            {
                NameTemp1 = QuestItemName[i].GetName();
                QuestItemName[i].SetNameWithColor(NameTemp1, 0, 1, Gray);
                QuestItemNum[i].SetTextColor(Gray);
            }
            // End:0x1A9
            if(__NFUN_412__(counts, (0)))
            {
                QuestItemNum[i].SetText(("(" $ (Count)) $ ")");                
            }
            else
            {
                QuestItemNum[i].SetText(((("(" $ (Count)) $ "/") $ (counts)) $ ")");
            }
            setItemWindowSize(i, NameTemp1);
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function UpdateAlarmExpand(int NpcID, int Count)
{
    local string NameTemp1;

    i = 0;
    J0x07:

    // End:0x18C [Loop If]
    if(i < 25)
    {
        // End:0x182
        if(QuestItemNameID[i] == NpcID)
        {
            // End:0xB1
            if(__NFUN_408__((Count), QuestItemNumInt[i]) || __NFUN_412__(QuestItemNumInt[i], (0)))
            {
                NameTemp1 = QuestItemName[i].GetName();
                QuestItemName[i].SetNameWithColor(NameTemp1, 0, 1, White);
                QuestItemNum[i].SetTextColor(White);                
            }
            else
            {
                NameTemp1 = QuestItemName[i].GetName();
                QuestItemName[i].SetNameWithColor(NameTemp1, 0, 1, Gray);
                QuestItemNum[i].SetTextColor(Gray);
            }
            // End:0x147
            if(__NFUN_412__(QuestItemNumInt[i], (0)))
            {
                QuestItemNum[i].SetText((" (" $ string(Count)) $ ")");
                // [Explicit Continue]
                goto J0x182;
            }
            QuestItemNum[i].SetText((((" (" $ string(Count)) $ "/") $ (QuestItemNumInt[i])) $ ")");
        }
        J0x182:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function int FindEmptyQuestSlot()
{
    local int slotID;

    slotID = -1;
    i = 0;
    J0x12:

    // End:0x4B [Loop If]
    if(i < 5)
    {
        // End:0x41
        if(QuestAlarmNameID[i] == -1)
        {
            slotID = i;
            // [Explicit Break]
            goto J0x4B;
        }
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    J0x4B:

    return slotID;
    return;
}

function int QuestSlotIdx(int questID)
{
    local int slotID;

    slotID = -1;
    i = 0;
    J0x12:

    // End:0x4B [Loop If]
    if(i < 5)
    {
        // End:0x41
        if(QuestAlarmNameID[i] == questID)
        {
            slotID = i;
            // [Explicit Break]
            goto J0x4B;
        }
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    J0x4B:

    return slotID;
    return;
}

function int FindEmptyItemSlot(int QuestIdx)
{
    local int itemSlotID;

    itemSlotID = -1;
    i = 0;
    J0x12:

    // End:0x56 [Loop If]
    if(i < 5)
    {
        // End:0x4C
        if(QuestItemNameID[(QuestIdx * 5) + i] == -1)
        {
            itemSlotID = i;
            // [Explicit Break]
            goto J0x56;
        }
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    J0x56:

    return itemSlotID;
    return;
}

function int QuestItemSlotIdx(int QuestIdx, int ItemID)
{
    local int itemSlotID;

    itemSlotID = -1;
    i = 0;
    J0x12:

    // End:0x56 [Loop If]
    if(i < 5)
    {
        // End:0x4C
        if(QuestItemNameID[(QuestIdx * 5) + i] == ItemID)
        {
            itemSlotID = i;
            // [Explicit Break]
            goto J0x56;
        }
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    J0x56:

    return itemSlotID;
    return;
}
