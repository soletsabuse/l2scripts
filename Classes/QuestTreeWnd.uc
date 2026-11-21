class QuestTreeWnd extends UICommonAPI;

const QUESTTREEWND_MAX_COUNT = 40;
const QUEST_WINDOW_ONE = 0;
const QUEST_WINDOW_REPEAT = 1;
const QUEST_WINDOW_EPIC = 2;
const QUEST_WINDOW_JOB = 3;
const QUEST_WINDOW_SPECIAL = 4;

struct QuestUseInfo
{
    var int questID;
    var int Level;
    var int Completed;
    var int QuestType;
    var bool bShowCompletionItem;
    var array<int> ArrNeedItemIDList;
    var array<int> ArrNeedItemNumList;
    var array<int> ArrGoalType;
    var array<int> rewardIDList;
    var array<INT64> rewardNumList;
};

var WindowHandle Me;
var TabHandle QuestTreeTab;
var TextureHandle TexTabBg;
var TextureHandle TexTabBgLine;
var TextBoxHandle txtQuestTreeTitle;
var TextBoxHandle txtQuestNum;
var TreeHandle MainTree0;
var TreeHandle MainTree1;
var TreeHandle MainTree2;
var TreeHandle MainTree3;
var TreeHandle MainTree4;
var TreeHandle CurTree;
var CheckBoxHandle chkAssignNotifier;
var CheckBoxHandle chkNpcPosBox;
var ButtonHandle btnDetailInfo;
var string ROOTNAME;
var string TREE0;
var string TREE1;
var string TREE2;
var string TREE3;
var string TREE4;
var array<QuestUseInfo> ArrQuest;
var bool bDrawBgTree;
var string beforeTreeName;
var QuestAlarmWnd scQuestAlarm;
var QuestTreeDrawerWnd scTreeDrawer;
var ButtonHandle m_btnAddAlarm;
var ButtonHandle m_btnDeleteAlarm;
var L2Util util;
var int QuestID_Alarm;
var int QuestLevel_Alarm;
var int QuestEnd_Alarm;
var int m_QuestNum;
var int m_OldQuestID;
var ListCtrlHandle ListTrackItem1;
var array<LVDataRecord> m_QuestTrackData;
var int m_TrackID;
var int m_DeleteQuestID;
var string m_DeleteNodeName;
var string m_WindowName;
var int m_recentlyQuestID;
var NoticeWnd NoticeWndScript;
var Vector currentQuestDirectTargetPos;
var string currentQuestDirectTargetString;

function OnRegisterEvent()
{
    RegisterEvent(700);
    RegisterEvent(710);
    RegisterEvent(720);
    RegisterEvent(730);
    RegisterEvent(1710);
    RegisterEvent(40);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    util = L2Util(GetScript("L2Util"));
    scQuestAlarm = QuestAlarmWnd(GetScript("QuestAlarmWnd"));
    scTreeDrawer = QuestTreeDrawerWnd(GetScript("QuestTreeDrawerWnd"));
    NoticeWndScript = NoticeWnd(GetScript("NoticeWnd"));
    CurTree = MainTree0;
    chkNpcPosBox.SetCheck(true);
    bDrawBgTree = false;
    m_QuestNum = 0;
    m_OldQuestID = 0;
    m_recentlyQuestID = 0;
    return;
}

function Initialize()
{
    Me = GetWindowHandle(m_WindowName);
    QuestTreeTab = GetTabHandle(m_WindowName $ ".QuestTreeTab");
    TexTabBg = GetTextureHandle(m_WindowName $ ".TexTabBg");
    TexTabBgLine = GetTextureHandle(m_WindowName $ ".TexTabBgLine");
    txtQuestTreeTitle = GetTextBoxHandle(m_WindowName $ ".txtQuestTreeTitle");
    txtQuestNum = GetTextBoxHandle(m_WindowName $ ".txtQuestNum");
    MainTree0 = GetTreeHandle(m_WindowName $ ".MainTree0");
    MainTree1 = GetTreeHandle(m_WindowName $ ".MainTree1");
    MainTree2 = GetTreeHandle(m_WindowName $ ".MainTree2");
    MainTree3 = GetTreeHandle(m_WindowName $ ".MainTree3");
    MainTree4 = GetTreeHandle(m_WindowName $ ".MainTree4");
    chkAssignNotifier = GetCheckBoxHandle(m_WindowName $ ".chkAssignNotifier");
    chkNpcPosBox = GetCheckBoxHandle(m_WindowName $ ".chkNpcPosBox");
    btnDetailInfo = GetButtonHandle(m_WindowName $ ".btnDetailInfo");
    m_btnAddAlarm = GetButtonHandle("QuestTreeDrawerWnd.btnAddAlarm");
    m_btnDeleteAlarm = GetButtonHandle("QuestTreeDrawerWnd.btnDeleteAlarm");
    return;
}

function OnDefaultPosition()
{
    QuestTreeTab.MergeTab(0);
    QuestTreeTab.MergeTab(1);
    QuestTreeTab.MergeTab(2);
    QuestTreeTab.MergeTab(3);
    QuestTreeTab.MergeTab(4);
    QuestTreeTab.SetTopOrder(0, true);
    return;
}

function OnShow()
{
    local bool QuestAutoAlarm;
    local string ExpandedNode;
    local int nQuestType;

    QuestTreeTab.InitTabCtrl();
    ExpandedNode = GetExpandedNode();
    nQuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(getCurQuestID(), 1);
    ShowQuestList();
    CurTree = GetTreeHandle((m_WindowName $ ".MainTree") $ string(nQuestType));
    // End:0xA4
    if(ExpandedNode != "NULL")
    {
        QuestTreeTab.SetTopOrder(nQuestType, false);
        CurTree.SetExpandedNode(ExpandedNode, true);
        CheckQuestTrackList();
    }
    QuestAutoAlarm = GetOptionBool("Game", "autoQuestAlarm");
    scQuestAlarm.UpdateOptionData();
    // End:0xF5
    if(QuestAutoAlarm == true)
    {
        chkAssignNotifier.SetCheck(true);        
    }
    else
    {
        chkAssignNotifier.SetCheck(false);
    }
    CurTree.SetFocus();
    return;
}

function ShowQuestList()
{
    Class'NWindow.QuestAPI'.static.RequestQuestList();
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x8C
        case "btnClose":
            // End:0x60
            if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("QuestTreeDrawerWnd"))
            {
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");                
            }
            else
            {
                UpdateTargetInfo();
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("QuestTreeDrawerWnd");
            }
            // End:0x139
            break;
        // End:0xA8
        case "QuestTreeTab0":
            setTabChange(0);
            // End:0x139
            break;
        // End:0xC4
        case "QuestTreeTab1":
            setTabChange(1);
            // End:0x139
            break;
        // End:0xE1
        case "QuestTreeTab2":
            setTabChange(2);
            // End:0x139
            break;
        // End:0xFE
        case "QuestTreeTab3":
            setTabChange(3);
            // End:0x139
            break;
        // End:0x11B
        case "QuestTreeTab4":
            setTabChange(4);
            // End:0x139
            break;
        // End:0x136
        case "btnDetailInfo":
            OnbtnDetailInfoClick();
            // End:0x139
            break;
        // End:0xFFFF
        default:
            break;
    }
    selectQuestTree(strID, true);
    return;
}

function selectQuestTree(string strID, bool isButtonClick)
{
    local int SplitCount;
    local array<string> arrSplit;

    // End:0x120
    if(Left(strID, 4) == ROOTNAME)
    {
        SplitCount = Split(strID, ".", arrSplit);
        // End:0x4D
        if(isButtonClick == false)
        {
            CurTree.SetExpandedNode(strID, true);
        }
        m_recentlyQuestID = 0;
        UpdateTargetInfo();
        // End:0xB3
        if((GetExpandedNode()) == "")
        {
            // End:0xB0
            if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("QuestTreeDrawerWnd"))
            {
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
            }            
        }
        else
        {
            // End:0xFA
            if(SplitCount == 2)
            {
                scTreeDrawer.showQuestDrawer(LastNodeName(int(arrSplit[1]), 1, Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(int(arrSplit[1]), 1)));                
            }
            else
            {
                // End:0x11A
                if(SplitCount == 4)
                {
                    scTreeDrawer.showQuestDrawer(strID);
                }
            }
            ButtonEnableCheck();
        }
    }
    return;
}

function setTabChange(int Select)
{
    local array<string> arrSplit;
    local int SplitCount;
    local string ExpandedNode;

    CurTree.HideWindow();
    CurTree = GetTreeHandle((m_WindowName $ ".MainTree") $ string(Select));
    GetTreeHandle((m_WindowName $ ".MainTree") $ string(Select)).ShowWindow();
    scTreeDrawer.btnGiveUpCurrentQuest.DisableWindow();
    ExpandedNode = GetExpandedNode();
    UpdateTargetInfo();
    // End:0xE3
    if(ExpandedNode == "")
    {
        // End:0xE0
        if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("QuestTreeDrawerWnd"))
        {
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
        }        
    }
    else
    {
        // End:0x17D
        if(Left(GetExpandedNode(), 4) == ROOTNAME)
        {
            SplitCount = Split(ExpandedNode, ".", arrSplit);
            // End:0x157
            if(SplitCount == 2)
            {
                scTreeDrawer.showQuestDrawer(LastNodeName(int(arrSplit[1]), 1, Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(int(arrSplit[1]), 1)));                
            }
            else
            {
                // End:0x177
                if(SplitCount == 4)
                {
                    scTreeDrawer.showQuestDrawer(ExpandedNode);
                }
            }
            ButtonEnableCheck();
        }
    }
    // End:0x1B0
    if(Select != 4)
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".txtQuestNum");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".txtQuestNum");
    }
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x21
        case "chkNpcPosBox":
            UpdateTargetInfo();
            // End:0x9B
            break;
        // End:0x98
        case "chkAssignNotifier":
            // End:0x69
            if(chkAssignNotifier.IsChecked())
            {
                SetOptionBool("Game", "autoQuestAlarm", true);                
            }
            else
            {
                SetOptionBool("Game", "autoQuestAlarm", false);
            }
            scQuestAlarm.UpdateOptionData();
            // End:0x9B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnbtnDetailInfoClick()
{
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("QuestTreeDrawerWnd");
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x18
    if(Event_ID == 700)
    {
        HandleQuestListStart();        
    }
    else
    {
        // End:0x35
        if(Event_ID == 710)
        {
            HandleQuestList(param);            
        }
        else
        {
            // End:0x59
            if(Event_ID == 720)
            {
                HandleQuestListEnd();
                InsertQuestTrackList();
                ButtonEnableCheck();                
            }
            else
            {
                // End:0x94
                if(Event_ID == 730)
                {
                    HandleQuestSetCurrentID(param);
                    CurTree.SetFocus();
                    Me.SetFocus();                    
                }
                else
                {
                    // End:0x132
                    if(Event_ID == 1710)
                    {
                        // End:0x12F
                        if(DialogIsMine())
                        {
                            // End:0x12F
                            if((DialogGetID()) == 0)
                            {
                                scQuestAlarm.DeleteQuestAlarm(m_DeleteQuestID);
                                Class'NWindow.QuestAPI'.static.RequestDestroyQuest(m_DeleteQuestID);
                                SetQuestOff();
                                CurTree.DeleteNode(m_DeleteNodeName);
                                m_DeleteQuestID = 0;
                                m_DeleteNodeName = "";
                                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");                                
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x144
                        if(Event_ID == 40)
                        {
                            SetQuestOff();
                        }
                    }
                }
            }
        }
    }
    return;
}

function curQuestExpand(int questID)
{
    m_recentlyQuestID = questID;
    return;
}

function HandleQuestListStart()
{
    initTree();
    initVars();
    return;
}

function HandleQuestList(string param)
{
    local int i, questID, Level, Completed, nQuestType;

    local string QuestParam;
    local int Max;

    ParseInt(param, "QuestID", questID);
    ParseInt(param, "Level", Level);
    ParseInt(param, "Completed", Completed);
    nQuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(questID, Level);
    ArrQuest.Insert(ArrQuest.Length, 1);
    ArrQuest[ArrQuest.Length - 1].questID = questID;
    ArrQuest[ArrQuest.Length - 1].Level = Level;
    ArrQuest[ArrQuest.Length - 1].Completed = Completed;
    ArrQuest[ArrQuest.Length - 1].QuestType = nQuestType;
    // End:0x278
    if(Completed == 0)
    {
        QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(questID, Level);
        ParseInt(QuestParam, "Max", Max);
        ArrQuest[ArrQuest.Length - 1].ArrNeedItemIDList.Length = Max;
        ArrQuest[ArrQuest.Length - 1].ArrNeedItemNumList.Length = Max;
        ArrQuest[ArrQuest.Length - 1].ArrGoalType.Length = Max;
        i = 0;
        J0x176:

        // End:0x237 [Loop If]
        if(i < Max)
        {
            ParseInt(QuestParam, "GoalID_" $ string(i), ArrQuest[ArrQuest.Length - 1].ArrNeedItemIDList[i]);
            ParseInt(QuestParam, "GoalNum_" $ string(i), ArrQuest[ArrQuest.Length - 1].ArrNeedItemNumList[i]);
            ParseInt(QuestParam, "GoalType_" $ string(i), ArrQuest[ArrQuest.Length - 1].ArrGoalType[i]);
            i++;
            // [Loop Continue]
            goto J0x176;
        }
        Class'NWindow.UIDATA_QUEST'.static.GetQuestReward(questID, Level, ArrQuest[ArrQuest.Length - 1].rewardIDList, ArrQuest[ArrQuest.Length - 1].rewardNumList);
    }
    // End:0x29A
    if(m_OldQuestID != questID)
    {
        // End:0x29A
        if(nQuestType != 4)
        {
            m_QuestNum++;
        }
    }
    m_OldQuestID = questID;
    return;
}

function bool isQuestIDSearch(int questID)
{
    local int i, questLen;
    local bool flag;

    flag = false;
    questLen = ArrQuest.Length;
    i = 0;
    J0x1B:

    // End:0x59 [Loop If]
    if(i < questLen)
    {
        // End:0x4F
        if(questID == ArrQuest[i].questID)
        {
            flag = true;
            // [Explicit Break]
            goto J0x59;
        }
        i++;
        // [Loop Continue]
        goto J0x1B;
    }
    J0x59:

    return flag;
    return;
}

function HandleQuestListEnd()
{
    local int i, j, nQuestType;

    // End:0x40
    if(m_QuestNum == 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
        scTreeDrawer.allclear();        
    }
    setTreeQuestList();
    i = 0;
    J0x4D:

    // End:0x111 [Loop If]
    if(i < ArrQuest.Length)
    {
        j = 0;
        J0x64:

        // End:0x107 [Loop If]
        if(j < 5)
        {
            // End:0xFD
            if((ArrQuest[i].questID == scQuestAlarm.QuestAlarmNameID[j]) && ArrQuest[i].Level == scQuestAlarm.QuestAlarmLevel[j])
            {
                // End:0xFD
                if(ArrQuest[i].Completed == 1)
                {
                    scQuestAlarm.DeleteQuestAlarm(scQuestAlarm.QuestAlarmNameID[j]);
                }
            }
            j++;
            // [Loop Continue]
            goto J0x64;
        }
        i++;
        // [Loop Continue]
        goto J0x4D;
    }
    j = 0;
    J0x118:

    // End:0x166 [Loop If]
    if(j < 5)
    {
        // End:0x15C
        if(scQuestAlarm.QuestAlarmNameID[j] != -1)
        {
            findNowQuestExist(scQuestAlarm.QuestAlarmNameID[j]);
        }
        j++;
        // [Loop Continue]
        goto J0x118;
    }
    UpdateQuestCount();
    // End:0x217
    if(m_recentlyQuestID != 0)
    {
        nQuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(m_recentlyQuestID, 1);
        QuestTreeTab.SetTopOrder(nQuestType, false);
        getCurTree(nQuestType);
        CurTree.SetExpandedNode("root." $ string(m_recentlyQuestID), true);
        scTreeDrawer.showQuestDrawer("root." $ string(m_recentlyQuestID));
        scTreeDrawer.showQuestDrawer(LastNodeName(m_recentlyQuestID, 1, nQuestType));
        CheckQuestTrackList();
    }
    Detele3DArrow();
    return;
}

function Detele3DArrow()
{
    local int questID;
    local Vector vTargetPos;

    questID = getCurQuestID();
    // End:0x8C
    if(questID == 0)
    {
        Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(false, false, false, "", vTargetPos, questID, 0);
        DisableAllDirIcon();
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("QuestTreeDrawerWnd");
        CallGFxFunction("RadarMapWnd", "hideQuestTargetInfo", "");        
    }
    return;
}

function findNowQuestExist(int questID)
{
    local int i;
    local bool isExist;

    i = 0;
    J0x07:

    // End:0x46 [Loop If]
    if(i < ArrQuest.Length)
    {
        // End:0x3C
        if(ArrQuest[i].questID == questID)
        {
            isExist = true;
            // [Explicit Break]
            goto J0x46;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x46:

    // End:0xA5
    if(!isExist)
    {
        scQuestAlarm.DeleteQuestAlarm(questID);
        // End:0x79
        if(int(GetReleaseMode()) == int(0))
        {            
        }
        else
        {
            // End:0xA5
            if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("NoticeWnd"))
            {
                NoticeWndScript.hideNoticeButton_QUEST();
            }
        }
    }
    return;
}

function initTree()
{
    MainTree0.Clear();
    MainTree1.Clear();
    MainTree2.Clear();
    MainTree3.Clear();
    MainTree4.Clear();
    return;
}

function initVars()
{
    m_QuestNum = 0;
    m_OldQuestID = 0;
    m_TrackID = 0;
    m_DeleteQuestID = 0;
    m_DeleteNodeName = "";
    ArrQuest.Remove(0, ArrQuest.Length);
    return;
}

function setTreeQuestList()
{
    local int i;
    local string TREENAME, QuestName, JournalName, setTreeName, strRetName;

    local LVDataRecord Record;
    local LVData data1, data2;

    i = 0;
    J0x07:

    // End:0x426 [Loop If]
    if(i < ArrQuest.Length)
    {
        TREENAME = (m_WindowName $ ".MainTree") $ string(ArrQuest[i].QuestType);
        setTreeName = (ROOTNAME $ ".") $ string(ArrQuest[i].questID);
        JournalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(ArrQuest[i].questID, ArrQuest[i].Level);
        JournalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalNameSplit(JournalName, ArrQuest[i].Completed);
        // End:0x139
        if(Class'NWindow.UIAPI_TREECTRL'.static.IsNodeNameExist(TREENAME, setTreeName))
        {
            QuestName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(ArrQuest[i].questID, ArrQuest[i].Level);
            Class'NWindow.UIAPI_TREECTRL'.static.SetNodeItemText(TREENAME, setTreeName, 0, QuestName);            
        }
        else
        {
            QuestName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(ArrQuest[i].questID, ArrQuest[i].Level);
            util.TreeInsertRootNode(TREENAME, ROOTNAME, "", 0, 4);
            util.TreeInsertExpandBtnNode(TREENAME, string(ArrQuest[i].questID), ROOTNAME);
            util.TreeInsertTextNodeItem(TREENAME, (ROOTNAME $ ".") $ string(ArrQuest[i].questID), QuestName, 5, 0, util.0, true);
            data1.nReserved1 = ArrQuest[i].questID;
            data2.nReserved2 = ArrQuest[i].Level;
            data1.nReserved3 = ArrQuest[i].QuestType;
            data1.szData = QuestName;
            Record.LVDataList[0] = data1;
            Record.LVDataList[1] = data2;
            m_QuestTrackData[m_TrackID] = Record;
            m_TrackID = m_TrackID + 1;
        }
        strRetName = QuestJournalNodeMake(TREENAME, setTreeName, ArrQuest[i].Level, ArrQuest[i].Completed);
        // End:0x322
        if(bDrawBgTree)
        {
            util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 209, 24, 4,,,, 14);            
        }
        else
        {
            util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 209, 24, 4);
        }
        bDrawBgTree = !bDrawBgTree;
        // End:0x3EB
        if(ArrQuest[i].Completed == 1)
        {
            util.TreeInsertTextNodeItem(TREENAME, strRetName, ("(" $ GetSystemString(898)) $ ")", -202, 7, util.2, true);
            util.TreeInsertTextNodeItem(TREENAME, strRetName, JournalName, 4, 7, util.1, true);
            // [Explicit Continue]
            goto J0x41C;
        }
        util.TreeInsertTextNodeItem(TREENAME, strRetName, JournalName, -202, 7, util.1, true);
        J0x41C:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function setMiniMapTrackInsert(int questID, int Level, int nQuestType)
{
    return;
}

function string QuestJournalNodeMake(string TREENAME, string parentName, int Level, int Completed)
{
    local XMLTreeNodeInfo infNode;

    infNode.strName = (("" $ string(Level)) $ ".") $ string(Completed);
    infNode.nOffSetX = 14;
    infNode.bShowButton = 0;
    infNode.bDrawBackground = 1;
    infNode.bTexBackHighlight = 0;
    infNode.nTexBackHighlightHeight = 15;
    infNode.nTexBackWidth = 211;
    infNode.nTexBackUWidth = 211;
    infNode.nTexBackOffSetX = 3;
    infNode.nTexBackOffSetY = 0;
    infNode.nTexBackOffSetBottom = 1;
    return Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(TREENAME, parentName, infNode);
    return;
}

function DirIconDest(UIEventManager.EMinimapTargetIcon Type, Vector vTargetPos, string TooltipString)
{
    local Vector emptyLoc;
    local MinimapCtrlHandle m_MiniMap;

    m_MiniMap = GetMinimapCtrlHandle("MinimapWnd.Minimap");
    // End:0x91
    if(((vTargetPos.X != float(0)) && vTargetPos.Y != float(0)) && vTargetPos.Z != float(0))
    {
        m_MiniMap.SetDirIconDest(Type, vTargetPos, TooltipString);
        currentQuestDirectTargetPos = vTargetPos;
        currentQuestDirectTargetString = TooltipString;        
    }
    else
    {
        m_MiniMap.DisableDirIcon(Type);
        currentQuestDirectTargetPos = emptyLoc;
        currentQuestDirectTargetString = "";
    }
    return;
}

function updateDirIconDest()
{
    // End:0x1E
    if(currentQuestDirectTargetString != "")
    {
        DirIconDest(0, currentQuestDirectTargetPos, currentQuestDirectTargetString);
    }
    return;
}

function Vector getCurrentQuestDirectTargetPos()
{
    return currentQuestDirectTargetPos;
    return;
}

function string getCurrentQuestDirectTargetString()
{
    return currentQuestDirectTargetString;
    return;
}

function string DirIconDestGetToolTip(int questID, int QuestLevel)
{
    local string strTooltip, strQuestName, strTargetName;

    strQuestName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(questID, QuestLevel);
    strTargetName = Class'NWindow.UIDATA_QUEST'.static.GetTargetName(questID, QuestLevel);
    strTooltip = (strTargetName $ "\\n") $ strQuestName;
    return strTooltip;
    return;
}

function UpdateTargetNoneCheckPosBox(bool ShowArrow)
{
    local array<string> arrSplit;
    local int SplitCount, questID, Level, Completed;
    local string strChildList, strTargetNode, strNodeName, strTargetName;
    local Vector vTargetPos;
    local bool bOnlyMinimap;
    local string strParam;

    strNodeName = GetExpandedNode();
    // End:0x21
    if(Len(strNodeName) < 1)
    {
        SetQuestOff();
        return;
    }
    strChildList = CurTree.GetChildNode(strNodeName);
    // End:0x78
    if(Len(strChildList) > 0)
    {
        SplitCount = Split(strChildList, "|", arrSplit);
        strTargetNode = arrSplit[SplitCount - 1];        
    }
    else
    {
        SetQuestOff();
        return;
    }
    arrSplit.Remove(0, arrSplit.Length);
    SplitCount = Split(strTargetNode, ".", arrSplit);
    questID = int(arrSplit[1]);
    // End:0xD2
    if(SplitCount == 2)
    {
        Level = 1;
        Completed = 0;        
    }
    else
    {
        // End:0xFE
        if(SplitCount == 4)
        {
            Level = int(arrSplit[2]);
            Completed = int(arrSplit[3]);
        }
    }
    // End:0x310
    if((questID > 0) && Level > 0)
    {
        strTargetName = Class'NWindow.UIDATA_QUEST'.static.GetTargetName(questID, Level);
        vTargetPos = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(questID, Level);
        ParamAdd(strParam, "X", string(vTargetPos.X));
        ParamAdd(strParam, "Y", string(vTargetPos.Y));
        ParamAdd(strParam, "Z", string(vTargetPos.Z));
        ParamAdd(strParam, "targetName", strTargetName);
        ParamAdd(strParam, "QuestID", string(questID));
        ParamAdd(strParam, "QuestLevel", string(Level));
        ParamAdd(strParam, "questName", Class'NWindow.UIDATA_QUEST'.static.GetQuestName(questID, Level));
        CallGFxFunction("RadarMapWnd", "showQuestTargetInfo", strParam);
        // End:0x30A
        if((Completed == 0) && Len(strTargetName) > 0)
        {
            bOnlyMinimap = Class'NWindow.UIDATA_QUEST'.static.IsMinimapOnly(questID, Level);
            // End:0x2BF
            if(bOnlyMinimap)
            {
                Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(true, false, false, strTargetName, vTargetPos, questID, Level);                
            }
            else
            {
                Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(true, true, ShowArrow, strTargetName, vTargetPos, questID, Level);
            }
            DirIconDest(0, vTargetPos, DirIconDestGetToolTip(questID, Level));            
        }
        else
        {
            SetQuestOff();
        }
    }
    return;
}

function UpdateTargetInfo()
{
    // End:0x1C
    if(!chkNpcPosBox.IsChecked())
    {
        SetQuestOff();
        return;
    }
    UpdateTargetNoneCheckPosBox(true);
    return;
}

function DisableAllDirIcon()
{
    local Vector emptyLoc;
    local MinimapCtrlHandle m_MiniMap;

    m_MiniMap = GetMinimapCtrlHandle("MinimapWnd.Minimap");
    m_MiniMap.DisableDirIcon(0);
    currentQuestDirectTargetPos = emptyLoc;
    currentQuestDirectTargetString = "";
    return;
}

function SetQuestOff()
{
    local Vector vVector, emptyLoc;

    Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(false, false, false, "", vVector, 0, 0);
    CallGFxFunction("RadarMapWnd", "hideQuestTargetInfo", "");
    DisableAllDirIcon();
    QuestID_Alarm = -1;
    QuestLevel_Alarm = -1;
    QuestEnd_Alarm = -1;
    m_recentlyQuestID = 0;
    currentQuestDirectTargetPos = emptyLoc;
    currentQuestDirectTargetString = "";
    return;
}

function string GetExpandedNode()
{
    local array<string> arrSplit;
    local int SplitCount;
    local string strNodeName;

    strNodeName = CurTree.super(QuestTreeWnd).GetExpandedNode("root");
    SplitCount = Split(strNodeName, "|", arrSplit);
    // End:0x4C
    if(SplitCount > 0)
    {
        strNodeName = arrSplit[0];
    }
    return strNodeName;
    return;
}

function ButtonEnableCheck()
{
    local int i, M, QuestIDSlot;
    local bool isCanBeAddAlarm, QuestAutoAlarm;

    QuestAutoAlarm = GetOptionBool("Game", "autoQuestAlarm");
    GetNodeInfo_Alarm();
    isCanBeAddAlarm = false;
    i = 0;
    J0x38:

    // End:0xE1 [Loop If]
    if(i < ArrQuest.Length)
    {
        // End:0xD7
        if(ArrQuest[i].questID == QuestID_Alarm)
        {
            // End:0x84
            if(ArrQuest[i].ArrNeedItemIDList.Length > 0)
            {
                isCanBeAddAlarm = true;
                // [Explicit Break]
                goto J0xE1;
            }
            M = 0;
            J0x8B:

            // End:0xD7 [Loop If]
            if(M < ArrQuest[i].ArrGoalType.Length)
            {
                // End:0xCD
                if(ArrQuest[i].ArrGoalType[M] == 1)
                {
                    isCanBeAddAlarm = true;
                    // [Explicit Break]
                    goto J0xD7;
                }
                M++;
                // [Loop Continue]
                goto J0x8B;
            }
        }
        J0xD7:

        i++;
        // [Loop Continue]
        goto J0x38;
    }
    J0xE1:

    QuestIDSlot = scQuestAlarm.QuestSlotIdx(QuestID_Alarm);
    // End:0x127
    if(QuestID_Alarm <= 0)
    {
        m_btnAddAlarm.DisableWindow();
        m_btnDeleteAlarm.DisableWindow();        
    }
    else
    {
        // End:0x180
        if(QuestIDSlot < 0)
        {
            // End:0x15F
            if(isCanBeAddAlarm == true)
            {
                m_btnAddAlarm.EnableWindow();
                m_btnDeleteAlarm.DisableWindow();                
            }
            else
            {
                m_btnAddAlarm.DisableWindow();
                m_btnDeleteAlarm.DisableWindow();
            }            
        }
        else
        {
            m_btnAddAlarm.DisableWindow();
            m_btnDeleteAlarm.EnableWindow();
        }
    }
    return;
}

function GetNodeInfo_Alarm()
{
    local string strNodeName, strTargetNode;
    local int i;
    local array<string> arrSplit;
    local int SplitCount;
    local string strChildList;

    strNodeName = GetExpandedNode();
    strChildList = CurTree.GetChildNode(strNodeName);
    // End:0x63
    if(Len(strChildList) > 0)
    {
        SplitCount = Split(strChildList, "|", arrSplit);
        strTargetNode = arrSplit[SplitCount - 1];        
    }
    else
    {
        SetQuestOff();
        return;
    }
    arrSplit.Remove(0, arrSplit.Length);
    SplitCount = Split(strTargetNode, ".", arrSplit);
    i = 0;
    J0x98:

    // End:0x112 [Loop If]
    if(i < SplitCount)
    {
        switch(i)
        {
            // End:0xB5
            case 0:
                // End:0x108
                break;
            // End:0xCF
            case 1:
                QuestID_Alarm = int(arrSplit[i]);
                // End:0x108
                break;
            // End:0xEA
            case 2:
                QuestLevel_Alarm = int(arrSplit[i]);
                // End:0x108
                break;
            // End:0x105
            case 2:
                QuestEnd_Alarm = int(arrSplit[i]);
                // End:0x108
                break;
            // End:0xFFFF
            default:
                break;
        }
        i++;
        // [Loop Continue]
        goto J0x98;
    }
    return;
}

function HandleDeleteAlarm()
{
    local int i;

    GetNodeInfo_Alarm();
    i = 0;
    J0x0D:

    // End:0x55 [Loop If]
    if(i < ArrQuest.Length)
    {
        // End:0x4B
        if(ArrQuest[i].questID == QuestID_Alarm)
        {
            scQuestAlarm.DeleteQuestAlarm(QuestID_Alarm);
        }
        i++;
        // [Loop Continue]
        goto J0x0D;
    }
    ButtonEnableCheck();
    return;
}

function UpdateQuestCount()
{
    txtQuestNum.SetText(((("(" $ string(m_QuestNum)) $ "/") $ string(40)) $ ")");
    return;
}

function getCurTree(int nQuestType)
{
    switch(nQuestType)
    {
        // End:0x19
        case 0:
            CurTree = MainTree0;
            // End:0x72
            break;
        // End:0x2B
        case 1:
            CurTree = MainTree1;
            // End:0x72
            break;
        // End:0x3E
        case 2:
            CurTree = MainTree2;
            // End:0x72
            break;
        // End:0x51
        case 3:
            CurTree = MainTree3;
            // End:0x72
            break;
        // End:0x64
        case 4:
            CurTree = MainTree4;
            // End:0x72
            break;
        // End:0xFFFF
        default:
            CurTree = MainTree0;
            break;
    }
    return;
}

function HandleQuestSetCurrentID(string param)
{
    local string strNodeName, strChildList;
    local int RecentlyAddedQuestID, SplitCount, nQuestType;
    local array<string> arrSplit;

    // End:0x20
    if(!ParseInt(param, "QuestID", RecentlyAddedQuestID))
    {
        return;
    }
    // End:0x151
    if(RecentlyAddedQuestID > 0)
    {
        nQuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(RecentlyAddedQuestID, 1);
        getCurTree(nQuestType);
        QuestTreeTab.SetTopOrder(nQuestType, false);
        strNodeName = "root." $ string(RecentlyAddedQuestID);
        CurTree.SetExpandedNode(strNodeName, true);
        // End:0xBC
        if(!Me.IsShowWindow())
        {
            Me.ShowWindow();
            PlayConsoleSound(5);
        }
        strChildList = CurTree.GetChildNode(strNodeName);
        // End:0x11A
        if(Len(strChildList) > 0)
        {
            SplitCount = Split(strChildList, "|", arrSplit);
            CurTree.SetExpandedNode(arrSplit[SplitCount - 1], true);
        }
        // End:0x14B
        if(Left(strNodeName, 4) == "root")
        {
            scTreeDrawer.showQuestDrawer(arrSplit[SplitCount - 1]);
        }
        UpdateTargetInfo();
    }
    return;
}

function HandleQuestSetCurrentIDfromMiniMap(int questID, int Level, int nQuestType)
{
    local string strNodeName, strChildList;
    local int RecentlyAddedQuestID, SplitCount;
    local array<string> arrSplit;

    RecentlyAddedQuestID = questID;
    getCurTree(nQuestType);
    QuestTreeTab.SetTopOrder(nQuestType, false);
    // End:0xF7
    if(RecentlyAddedQuestID > 0)
    {
        strNodeName = "root." $ string(RecentlyAddedQuestID);
        CurTree.SetExpandedNode(strNodeName, true);
        strChildList = CurTree.GetChildNode(strNodeName);
        // End:0xBF
        if(Len(strChildList) > 0)
        {
            SplitCount = Split(strChildList, "|", arrSplit);
            CurTree.SetExpandedNode(arrSplit[SplitCount - 1], true);
        }
        UpdateTargetNoneCheckPosBox(true);
        // End:0xF7
        if(Left(strNodeName, 4) == "root")
        {
            scTreeDrawer.showQuestDrawer(arrSplit[SplitCount - 1]);
        }
    }
    return;
}

function CheckQuestTrackList()
{
    local int i, questID;

    questID = getCurQuestID();
    i = 0;
    J0x13:

    // End:0x4F [Loop If]
    if(i < m_TrackID)
    {
        // End:0x45
        if(m_QuestTrackData[i].LVDataList[0].nReserved1 == questID)
        {
            return;
        }
        i++;
        // [Loop Continue]
        goto J0x13;
    }
    return;
}

function InsertQuestTrackList()
{
    local int i, questID;

    questID = getCurQuestID();
    i = 0;
    J0x13:

    // End:0x4D [Loop If]
    if(i < m_TrackID)
    {
        // End:0x43
        if(m_QuestTrackData[i].LVDataList[0].nReserved1 == questID)
        {
        }
        i++;
        // [Loop Continue]
        goto J0x13;
    }
    return;
}

function int getCurQuestID()
{
    local int questID;
    local string strNodeName;
    local int SplitCount;
    local array<string> arrSplit;

    strNodeName = GetExpandedNode();
    SplitCount = Split(strNodeName, ".", arrSplit);
    // End:0x42
    if(SplitCount > 1)
    {
        questID = int(arrSplit[1]);        
    }
    else
    {
        questID = 0;
    }
    return questID;
    return;
}

function HandleQuestCancel()
{
    local array<string> arrSplit;
    local int SplitCount;
    local string strNodeName, strDeleteQuestName, strDeleteQuestMessage;

    m_DeleteQuestID = 0;
    m_DeleteNodeName = "";
    strNodeName = GetExpandedNode();
    SplitCount = Split(strNodeName, "|", arrSplit);
    // End:0x97
    if(SplitCount > 0)
    {
        strNodeName = arrSplit[0];
        arrSplit.Remove(0, arrSplit.Length);
        SplitCount = Split(strNodeName, ".", arrSplit);
        // End:0x97
        if(SplitCount > 1)
        {
            m_DeleteQuestID = int(arrSplit[1]);
            m_DeleteNodeName = strNodeName;
        }
    }
    // End:0xD1
    if(Len(m_DeleteNodeName) < 1)
    {
        strDeleteQuestMessage = GetSystemMessage(1201);
        DialogShow(1, 5, strDeleteQuestMessage, string(self));
        DialogSetID(1);        
    }
    else
    {
        strDeleteQuestName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(m_DeleteQuestID, util.getQuestLevelForID(m_DeleteQuestID));
        strDeleteQuestMessage = MakeFullSystemMsg(GetSystemMessage(182), strDeleteQuestName, "");
        DialogShow(1, 4, strDeleteQuestMessage, string(self));
        DialogSetID(0);
    }
    return;
}

function string LastNodeName(int questID, int Level, int nQuestType)
{
    local string strNodeName, strChildList;
    local int RecentlyAddedQuestID, SplitCount;
    local array<string> arrSplit;
    local TreeHandle tempCurTree;

    tempCurTree = CurTree;
    RecentlyAddedQuestID = questID;
    getCurTree(nQuestType);
    QuestTreeTab.SetTopOrder(nQuestType, false);
    // End:0xB5
    if(RecentlyAddedQuestID > 0)
    {
        strNodeName = "root." $ string(RecentlyAddedQuestID);
        strChildList = CurTree.GetChildNode(strNodeName);
        // End:0xB5
        if(Len(strChildList) > 0)
        {
            SplitCount = Split(strChildList, "|", arrSplit);
            CurTree.SetExpandedNode(arrSplit[SplitCount - 1], true);
        }
    }
    CurTree = tempCurTree;
    return arrSplit[SplitCount - 1];
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    ROOTNAME="root"
    m_WindowName="QuestTreeWnd"
}