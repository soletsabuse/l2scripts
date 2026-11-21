class QuestTreeDrawerWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle GroupBox_Title;
var TextureHandle GroupBox_DescriptionTree;
var TextureHandle GroupBox_DescriptionTreeLarge;
var TextureHandle GroupBox_ItemTree;
var TextureHandle GroupBox_RewardItemTree;
var TextBoxHandle txtQuestTitle;
var TextBoxHandle txtRecommandedLevel;
var TextBoxHandle txtRecommandedLevelText;
var TextBoxHandle txtQuestType;
var TreeHandle QuestDescriptionTree;
var TreeHandle QuestDescriptionLargeTree;
var TextBoxHandle txtQuestItemTitle;
var TextBoxHandle txtQuestRewardItemTreeTitle;
var TreeHandle QuestItemTree;
var TreeHandle QuestRewardItemTree;
var ButtonHandle btnGiveUpCurrentQuest;
var ButtonHandle btnAddAlarm;
var ButtonHandle btnClose;
var ButtonHandle btnDeleteAlarm;
var L2Util util;
var int SelectQuestID;
var int SelectLevel;
var int SelectCompleted;
var array<int> SelectarrItemID;
var array<int> SelectarrItemNumList;
var array<int> SelectarrGoalType;
var QuestAlarmWnd m_scriptAlarm;
var QuestTreeWnd scQuestTree;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    Initialize();
    load();
    util = L2Util(GetScript("L2Util"));
    m_scriptAlarm = QuestAlarmWnd(GetScript("QuestAlarmWnd"));
    scQuestTree = QuestTreeWnd(GetScript("QuestTreeWnd"));
    btnAddAlarm.DisableWindow();
    btnDeleteAlarm.DisableWindow();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("QuestTreeDrawerWnd");
    GroupBox_Title = GetTextureHandle("QuestTreeDrawerWnd.GroupBox_Title");
    GroupBox_DescriptionTree = GetTextureHandle("QuestTreeDrawerWnd.GroupBox_DescriptionTree");
    GroupBox_DescriptionTreeLarge = GetTextureHandle("QuestTreeDrawerWnd.GroupBox_DescriptionTreeLarge");
    GroupBox_ItemTree = GetTextureHandle("QuestTreeDrawerWnd.GroupBox_ItemTree");
    GroupBox_RewardItemTree = GetTextureHandle("QuestTreeDrawerWnd.GroupBox_RewardItemTree");
    txtQuestTitle = GetTextBoxHandle("QuestTreeDrawerWnd.txtQuestTitle");
    txtRecommandedLevel = GetTextBoxHandle("QuestTreeDrawerWnd.txtRecommandedLevel");
    txtRecommandedLevelText = GetTextBoxHandle("QuestTreeDrawerWnd.txtRecommandedLevelText");
    txtQuestType = GetTextBoxHandle("QuestTreeDrawerWnd.txtQuestType");
    QuestDescriptionTree = GetTreeHandle("QuestTreeDrawerWnd.QuestDescriptionTree");
    QuestDescriptionLargeTree = GetTreeHandle("QuestTreeDrawerWnd.QuestDescriptionLargeTree");
    txtQuestItemTitle = GetTextBoxHandle("QuestTreeDrawerWnd.txtQuestItemTitle");
    txtQuestRewardItemTreeTitle = GetTextBoxHandle("QuestTreeDrawerWnd.txtQuestRewardItemTreeTitle");
    QuestItemTree = GetTreeHandle("QuestTreeDrawerWnd.QuestItemTree");
    QuestRewardItemTree = GetTreeHandle("QuestTreeDrawerWnd.QuestRewardItemTree");
    btnGiveUpCurrentQuest = GetButtonHandle("QuestTreeDrawerWnd.btnGiveUpCurrentQuest");
    btnAddAlarm = GetButtonHandle("QuestTreeDrawerWnd.btnAddAlarm");
    btnClose = GetButtonHandle("QuestTreeDrawerWnd.btnClose");
    btnDeleteAlarm = GetButtonHandle("QuestTreeDrawerWnd.btnDeleteAlarm");
    return;
}

function load()
{
    return;
}

function OnEvent(int EventID, string param)
{
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x2A
        case "btnGiveUpCurrentQuest":
            OnbtnGiveUpCurrentQuestClick();
            // End:0x78
            break;
        // End:0x43
        case "btnAddAlarm":
            OnbtnAddAlarmClick();
            // End:0x78
            break;
        // End:0x59
        case "btnClose":
            OnBtnCloseClick();
            // End:0x78
            break;
        // End:0x75
        case "btnDeleteAlarm":
            OnbtnDeleteAlarmClick();
            // End:0x78
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnbtnGiveUpCurrentQuestClick()
{
    local QuestTreeWnd script;

    script = QuestTreeWnd(GetScript("QuestTreeWnd"));
    script.HandleQuestCancel();
    return;
}

function OnbtnAddAlarmClick()
{
    local int i, Count;
    local string alarmTitleStr;

    // End:0x4E
    if(SelectarrItemID.Length > 0)
    {
        Debug("Call --> RequestAddExpandQuestAlarm : " $ string(SelectQuestID));
        RequestAddExpandQuestAlarm(SelectQuestID);
    }
    i = 0;
    J0x55:

    // End:0x1AE [Loop If]
    if(i < SelectarrItemID.Length)
    {
        alarmTitleStr = "";
        // End:0xA9
        if(SelectarrGoalType[i] == 1)
        {
            alarmTitleStr = GetNpcString(SelectarrItemID[i]);
            Count = SelectarrItemNumList[i];            
        }
        else
        {
            // End:0x10B
            if(SelectarrItemID[i] >= 1000000)
            {
                alarmTitleStr = (Class'NWindow.UIDATA_NPC'.static.GetNPCName(SelectarrItemID[i] - 1000000) $ " ") $ GetSystemString(2240);
                Count = SelectarrItemNumList[i];                
            }
            else
            {
                alarmTitleStr = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(SelectarrItemID[i]));
                Count = name(GetInventoryItemCount(GetItemID(SelectarrItemID[i])));
            }
        }
        m_scriptAlarm.AddQuestAlarmNew(SelectQuestID, Class'NWindow.UIDATA_QUEST'.static.GetQuestName(SelectQuestID, SelectLevel), SelectarrItemID[i], alarmTitleStr, Count, (SelectarrItemNumList[i]), SelectLevel);
        i++;
        // [Loop Continue]
        goto J0x55;
    }
    scQuestTree.ButtonEnableCheck();
    return;
}

function OnBtnCloseClick()
{
    Me.HideWindow();
    return;
}

function OnbtnDeleteAlarmClick()
{
    scQuestTree.HandleDeleteAlarm();
    return;
}

function showQuestDrawer(string Str)
{
    local int i, SplitCount;
    local array<string> arrSplit;
    local int questID, Level, Completed, QuestType, Type, MinLevel,
	    MaxLevle;

    local string QuestDescription, QuestParam;
    local int Max;
    local array<int> arrItemIDList, arrItemNumList;
    local bool bShowCompletionItem;
    local array<int> rewardIDList;
    local array<INT64> rewardNumList;
    local string JournalName;
    local bool bQuest;
    local array<int> ArrGoalType;

    bQuest = false;
    // End:0x2B
    if(!Me.IsShowWindow())
    {
        Me.ShowWindow();
    }
    btnGiveUpCurrentQuest.EnableWindow();
    SplitCount = Split(Str, ".", arrSplit);
    questID = int(arrSplit[1]);
    // End:0x7F
    if(SplitCount == 2)
    {
        Level = 1;
        Completed = 0;        
    }
    else
    {
        // End:0xAB
        if(SplitCount == 4)
        {
            Level = int(arrSplit[2]);
            Completed = int(arrSplit[3]);
        }
    }
    MinLevel = Class'NWindow.UIDATA_QUEST'.static.GetMinLevel(questID, Level);
    MaxLevle = Class'NWindow.UIDATA_QUEST'.static.GetMaxLevel(questID, Level);
    QuestDescription = Class'NWindow.UIDATA_QUEST'.static.GetQuestDescription(questID, Level);
    JournalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(questID, Level);
    JournalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalNameLine(JournalName);
    txtQuestTitle.SetText(JournalName);
    txtRecommandedLevel.SetTextColor(util.White);
    txtRecommandedLevel.SetText(GetSystemString(922) @ ":");
    txtRecommandedLevelText.SetTextColor(util.Token1);
    // End:0x1ED
    if((MaxLevle > 0) && MinLevel > 0)
    {
        txtRecommandedLevelText.SetText((string(MinLevel) $ "~") $ string(MaxLevle));        
    }
    else
    {
        // End:0x223
        if(MinLevel > 0)
        {
            txtRecommandedLevelText.SetText((string(MinLevel) $ " ") $ GetSystemString(859));            
        }
        else
        {
            txtRecommandedLevelText.SetText(GetSystemString(866));
        }
    }
    QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(questID, Level);
    txtQuestType.SetTextColor(util.White);
    switch(QuestType)
    {
        // End:0x2A1
        case 0:
            txtQuestType.SetText(GetSystemString(862));
            // End:0x381
            break;
        // End:0x318
        case 1:
            Type = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(questID, Level);
            // End:0x2FB
            if((Type == 4) || Type == 5)
            {
                txtQuestType.SetText(GetSystemString(2788));                
            }
            else
            {
                txtQuestType.SetText(GetSystemString(861));
            }
            // End:0x381
            break;
        // End:0x33A
        case 2:
            txtQuestType.SetText(GetSystemString(1998));
            // End:0x381
            break;
        // End:0x35C
        case 3:
            txtQuestType.SetText(GetSystemString(1999));
            // End:0x381
            break;
        // End:0x37E
        case 4:
            txtQuestType.SetText(GetSystemString(2000));
            // End:0x381
            break;
        // End:0xFFFF
        default:
            break;
    }
    QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(questID, Level);
    ParseInt(QuestParam, "Max", Max);
    arrItemIDList.Length = Max;
    arrItemNumList.Length = Max;
    ArrGoalType.Length = Max;
    i = 0;
    J0x3E0:

    // End:0x4A4 [Loop If]
    if(i < Max)
    {
        ParseInt(QuestParam, "GoalID_" $ string(i), arrItemIDList[i]);
        ParseInt(QuestParam, "GoalNum_" $ string(i), arrItemNumList[i]);
        ParseInt(QuestParam, "GoalType_" $ string(i), ArrGoalType[i]);
        // End:0x49A
        if((arrItemIDList[i] < 1000000) && ArrGoalType[i] != 1)
        {
            bQuest = true;
        }
        i++;
        // [Loop Continue]
        goto J0x3E0;
    }
    rewardIDList.Remove(0, rewardIDList.Length);
    rewardNumList.Remove(0, rewardNumList.Length);
    Class'NWindow.UIDATA_QUEST'.static.GetQuestReward(questID, Level, rewardIDList, rewardNumList);
    util.TreeClear("QuestTreeDrawerWnd.QuestDescriptionTree");
    util.TreeClear("QuestTreeDrawerWnd.QuestDescriptionLargeTree");
    util.TreeInsertRootNode("QuestTreeDrawerWnd.QuestDescriptionTree", "root", "");
    util.TreeInsertRootNode("QuestTreeDrawerWnd.QuestDescriptionLargeTree", "root", "");
    // End:0x690
    if(Max != 0)
    {
        // End:0x643
        if(!bQuest)
        {
            setQuestItemShow(false);
            util.TreeInsertTextNodeItem("QuestTreeDrawerWnd.QuestDescriptionLargeTree", "root", QuestDescription);            
        }
        else
        {
            setQuestItemShow(true);
            util.TreeInsertTextNodeItem("QuestTreeDrawerWnd.QuestDescriptionTree", "root", QuestDescription);
        }        
    }
    else
    {
        setQuestItemShow(false);
        util.TreeInsertTextNodeItem("QuestTreeDrawerWnd.QuestDescriptionLargeTree", "root", QuestDescription);
    }
    // End:0x738
    if(Max > 0)
    {
        // End:0x738
        if(bQuest)
        {
            bShowCompletionItem = Class'NWindow.UIDATA_QUEST'.static.IsShowableItemNumQuest(questID, Level);
            setQuestItem(Completed, Max, arrItemIDList, arrItemNumList, bShowCompletionItem, ArrGoalType);
        }
    }
    // End:0x754
    if(rewardIDList.Length > 0)
    {
        setRewardItem(rewardIDList, rewardNumList);
    }
    selectQuestLastCall(questID);
    return;
}

function setQuestItem(int Completed, int Count, array<int> IDList, array<int> ItemNum, bool bShowCompletionItem, array<int> ArrGoalType)
{
    local int i;
    local string TREENAME, setTreeName, strRetName;
    local bool bDrawBgTreeQuestItem;
    local string IconName, ItemName;

    TREENAME = "QuestTreeDrawerWnd.QuestItemTree";
    TreeClear(TREENAME);
    bDrawBgTreeQuestItem = false;
    util.TreeInsertRootNode(TREENAME, "List", "", 0, 2);
    setTreeName = "List";
    i = 0;
    J0x6D:

    // End:0x4C5 [Loop If]
    if(i < Count)
    {
        // End:0x4BB
        if(ArrGoalType[i] == 0)
        {
            // End:0x4BB
            if(IDList[i] < 1000000)
            {
                strRetName = util.TreeInsertItemNode(TREENAME, string(i), setTreeName, false, -4, -2);
                IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(IDList[i]));
                ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(IDList[i]));
                // End:0x16B
                if(!bDrawBgTreeQuestItem)
                {
                    util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 244, 38,,,,, 14);                    
                }
                else
                {
                    util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 244, 38);
                }
                bDrawBgTreeQuestItem = !bDrawBgTreeQuestItem;
                util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -238, 2);
                util.TreeInsertTextureNodeItem(TREENAME, strRetName, IconName, 32, 32, -34, 3);
                util.TreeInsertTextNodeItem(TREENAME, strRetName, ItemName, 5, 6, util.0, true,, IDList[i]);
                // End:0x327
                if(ItemNum[i] > 0)
                {
                    // End:0x2E0
                    if((Completed > 0) && bShowCompletionItem)
                    {
                        util.TreeInsertTextNodeItem(TREENAME, strRetName, ((("(" $ GetSystemString(898)) $ "/") $ string(ItemNum[i])) $ ")", 48, -18, util.2,, true);                        
                    }
                    else
                    {
                        util.TreeInsertTextNodeItem(TREENAME, strRetName, ("(" $ string(ItemNum[i])) $ ")", 48, -18, util.2,, true);
                    }
                    // [Explicit Continue]
                    goto J0x4BB;
                }
                // End:0x3EA
                if(ItemNum[i] == 0)
                {
                    // End:0x3A5
                    if((Completed > 0) && bShowCompletionItem)
                    {
                        util.TreeInsertTextNodeItem(TREENAME, strRetName, ((("(" $ GetSystemString(898)) $ "/") $ GetSystemString(858)) $ ")", 48, -18, util.2,, true);                        
                    }
                    else
                    {
                        util.TreeInsertTextNodeItem(TREENAME, strRetName, ("(" $ GetSystemString(858)) $ ")", 48, -18, util.2,, true);
                    }
                    // [Explicit Continue]
                    goto J0x4BB;
                }
                // End:0x468
                if((Completed > 0) && bShowCompletionItem)
                {
                    util.TreeInsertTextNodeItem(TREENAME, strRetName, (((("(" $ GetSystemString(898)) $ "/") $ string(-ItemNum[i])) $ GetSystemString(859)) $ ")", 48, -18, util.2,, true);
                    // [Explicit Continue]
                    goto J0x4BB;
                }
                util.TreeInsertTextNodeItem(TREENAME, strRetName, (("(" $ string(-ItemNum[i])) $ GetSystemString(859)) $ ")", 48, -18, util.2,, true);
            }
        }
        J0x4BB:

        i++;
        // [Loop Continue]
        goto J0x6D;
    }
    return;
}

function setRewardItem(array<int> rewardIDList, array<INT64> rewardNumList)
{
    local int i;
    local string TREENAME, setTreeName, strRetName;
    local bool bDrawBgTreeReward;
    local string IconName, ItemName;

    TREENAME = "QuestTreeDrawerWnd.QuestRewardItemTree";
    TreeClear(TREENAME);
    bDrawBgTreeReward = false;
    util.TreeInsertRootNode(TREENAME, "List", "", 0, 2);
    setTreeName = "List";
    i = 0;
    J0x73:

    // End:0x584 [Loop If]
    if(i < rewardIDList.Length)
    {
        strRetName = util.TreeInsertItemNode(TREENAME, string(i), setTreeName, false, -4, -2);
        // End:0x100
        if(!bDrawBgTreeReward)
        {
            util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 244, 38,,,,, 14);            
        }
        else
        {
            util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 244, 38);
        }
        bDrawBgTreeReward = !bDrawBgTreeReward;
        util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -238, 2);
        switch(rewardIDList[i])
        {
            // End:0x2CE
            case 57:
                IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(57));
                ItemName = GetSystemString(469);
                util.TreeInsertTextureNodeItem(TREENAME, strRetName, IconName, 32, 32, -34, 3);
                util.TreeInsertTextNodeItem(TREENAME, strRetName, ItemName, 5, 6, util.0, true);
                // End:0x278
                if(__NFUN_412__(rewardNumList[i], (0)))
                {
                    util.TreeInsertTextNodeItem(TREENAME, strRetName, GetSystemString(584), 48, -18, util.2,, true);                    
                }
                else
                {
                    util.TreeInsertTextNodeItem(TREENAME, strRetName, MakeFullSystemMsg(GetSystemMessage(2932), MakeCostString((rewardNumList[i])), ""), 48, -18, util.2,, true);
                }
                // End:0x57A
                break;
            // End:0xFFFF
            default:
                IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(rewardIDList[i]));
                ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));
                util.TreeInsertTextureNodeItem(TREENAME, strRetName, IconName, 32, 32, -34, 3);
                util.TreeInsertTextNodeItem(TREENAME, strRetName, ItemName, 5, 6, util.0, true,, rewardIDList[i]);
                // End:0x3CF
                if(__NFUN_412__(rewardNumList[i], (0)))
                {
                    util.TreeInsertTextNodeItem(TREENAME, strRetName, GetSystemString(584), 48, -18, util.2,, true);                    
                }
                else
                {
                    // End:0x524
                    if((((((((((((rewardIDList[i] == 15623) || rewardIDList[i] == 15624) || rewardIDList[i] == 15625) || rewardIDList[i] == 15626) || rewardIDList[i] == 15627) || rewardIDList[i] == 15628) || rewardIDList[i] == 15629) || rewardIDList[i] == 15630) || rewardIDList[i] == 15631) || rewardIDList[i] == 15632) || rewardIDList[i] == 15633) || rewardIDList[i] == 47130)
                    {
                        util.TreeInsertTextNodeItem(TREENAME, strRetName, MakeCostString((rewardNumList[i])), 48, -18, util.2,, true);                        
                    }
                    else
                    {
                        util.TreeInsertTextNodeItem(TREENAME, strRetName, MakeFullSystemMsg(GetSystemMessage(1983), MakeCostString((rewardNumList[i])), ""), 48, -18, util.2,, true);
                    }
                }
                // End:0x57A
                break;
                break;
        }
        i++;
        // [Loop Continue]
        goto J0x73;
    }
    return;
}

function setQuestItemShow(bool B)
{
    // End:0x66
    if(B)
    {
        QuestDescriptionLargeTree.HideWindow();
        QuestDescriptionTree.ShowWindow();
        txtQuestItemTitle.ShowWindow();
        GroupBox_DescriptionTree.ShowWindow();
        GroupBox_ItemTree.ShowWindow();
        QuestItemTree.ShowWindow();        
    }
    else
    {
        QuestDescriptionTree.HideWindow();
        QuestDescriptionLargeTree.ShowWindow();
        txtQuestItemTitle.HideWindow();
        QuestItemTree.HideWindow();
        GroupBox_DescriptionTree.HideWindow();
        GroupBox_ItemTree.HideWindow();
    }
    return;
}

function TreeClear(string Str)
{
    Class'NWindow.UIAPI_TREECTRL'.static.Clear(Str);
    return;
}

function selectQuestLastCall(int selectQuest)
{
    local int Level, i;
    local string QuestParam;
    local int Max;
    local array<int> arrItemIDList, arrItemNumList, ArrGoalType;

    Level = 0;
    Level = util.getQuestLevelForID(selectQuest);
    QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(selectQuest, Level);
    ParseInt(QuestParam, "Max", Max);
    arrItemIDList.Length = Max;
    arrItemNumList.Length = Max;
    ArrGoalType.Length = Max;
    i = 0;
    J0x80:

    // End:0x114 [Loop If]
    if(i < Max)
    {
        ParseInt(QuestParam, "GoalID_" $ string(i), arrItemIDList[i]);
        ParseInt(QuestParam, "GoalNum_" $ string(i), arrItemNumList[i]);
        ParseInt(QuestParam, "GoalType_" $ string(i), ArrGoalType[i]);
        i++;
        // [Loop Continue]
        goto J0x80;
    }
    SelectQuestID = selectQuest;
    SelectLevel = Level;
    SelectarrItemID = arrItemIDList;
    SelectarrItemNumList = arrItemNumList;
    SelectarrGoalType = ArrGoalType;
    return;
}

function OnHide()
{
    allclear();
    return;
}

function allclear()
{
    util.TreeClear("QuestTreeDrawerWnd.QuestItemTree");
    util.TreeClear("QuestTreeDrawerWnd.QuestRewardItemTree");
    util.TreeClear("QuestTreeDrawerWnd.QuestDescriptionTree");
    util.TreeClear("QuestTreeDrawerWnd.QuestDescriptionLargeTree");
    txtQuestTitle.SetText("");
    txtRecommandedLevel.SetText("");
    txtRecommandedLevelText.SetText("");
    txtQuestType.SetText("");
    btnGiveUpCurrentQuest.DisableWindow();
    return;
}
