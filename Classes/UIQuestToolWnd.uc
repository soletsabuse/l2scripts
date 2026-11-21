class UIQuestToolWnd extends UICommonAPI;

const TIMER_ID_CHANGETEXT = 10234567;
const TIMER_ID_UPDATELOCINFO = 10234568;

var WindowHandle Me;
var ListCtrlHandle questListCtrl;
var HtmlHandle QuestHtmlViewer;
var ButtonHandle searchItemBtn;
var EditBoxHandle searchEditBox;
var EditBoxHandle itemCountEditBox;
var ButtonHandle InitBtn;
var ButtonHandle getItemBtn;
var TextBoxHandle etcTextBox;
var TextBoxHandle cTextBox;
var TextBoxHandle playerLocText;
var Color Gold;
var HtmlHandle DetailInfoHtmlCtrl;
var string htmlMsg;
var string QuestDescription;
var string selectNPCName;
var int freeNum;
var int chargeNum;
var int SelectQuestID;
var int bicIconLen;
var ItemInfo ItemInfo;
var Color RedColor;
var bool apiChk;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("UIQuestToolWnd");
    questListCtrl = GetListCtrlHandle("UIQuestToolWnd.QuestListCtrl");
    QuestHtmlViewer = GetHtmlHandle("UIQuestToolWnd.QuestHtmlViewer");
    searchItemBtn = GetButtonHandle("UIQuestToolWnd.searchItemBtn");
    searchEditBox = GetEditBoxHandle("UIQuestToolWnd.searchEditBox");
    itemCountEditBox = GetEditBoxHandle("UIQuestToolWnd.itemCountEditBox");
    InitBtn = GetButtonHandle("UIQuestToolWnd.InitBtn");
    getItemBtn = GetButtonHandle("UIQuestToolWnd.getItemBtn");
    DetailInfoHtmlCtrl = GetHtmlHandle("UIQuestToolWnd.DetailInfoHtmlCtrl");
    etcTextBox = GetTextBoxHandle("UIQuestToolWnd.etcTextBox");
    cTextBox = GetTextBoxHandle("UIQuestToolWnd.cTextBox");
    playerLocText = GetTextBoxHandle("UIQuestToolWnd.playerLocText");
    Gold.R = 176;
    Gold.G = 153;
    Gold.B = 121;
    Gold.A = 100;
    return;
}

function OnTimer(int TimerID)
{
    local Vector pVec;
    local UIEventManager.ELanguageType Language;

    // End:0x27C
    if(TimerID == 10234567)
    {
        Language = GetLanguage();
        // End:0x279
        if(int(Language) == int(0))
        {
            switch(Rand(7))
            {
                // End:0x8C
                case 1:
                    cTextBox.SetText("검색한 퀘스트 목록에서 더블 클릭을 하면, 해당 퀘스트만 재검색 된다.");
                    // End:0x279
                    break;
                // End:0xDF
                case 2:
                    cTextBox.SetText("지역, 퀘스트제목, 각 단계,npc 명으로 모두 검색이 가능하다.");
                    // End:0x279
                    break;
                // End:0x132
                case 3:
                    cTextBox.SetText("QuestName-k 정보와 UIDATA_Quest API를 사용해서 만들어졌다.");
                    // End:0x279
                    break;
                // End:0x186
                case 4:
                    cTextBox.SetText("Dongland에게 후원금 및 물품을 넣으면 기능이 향상 될수 있다.");
                    // End:0x279
                    break;
                // End:0x1CB
                case 5:
                    cTextBox.SetText("(-_-)/~~~~이 글은 한글 버전에서만 보입니다~ ");
                    // End:0x279
                    break;
                // End:0x20D
                case 6:
                    cTextBox.SetText("중국 리니지2를 위한 퀘스트 검색 툴입니다.");
                    // End:0x279
                    break;
                // End:0xFFFF
                default:
                    cTextBox.SetText("아직 문제가 있는지 어떤지 테스트가 안되서 값에 버그가 있을 수 있으니 확인이 필요하다.");
                    // End:0x279
                    break;
                    break;
            }
        }        
    }
    else
    {
        // End:0x301
        if(TimerID == 10234568)
        {
            pVec = GetPlayerPosition();
            playerLocText.SetText(((((("CurrentPlayer Position" $ "\\nx") $ string(int(pVec.X))) $ " y") $ string(int(pVec.Y))) $ " z") $ string(int(pVec.Z)));
        }
    }
    return;
}

function OnShow()
{
    Me.KillTimer(10234567);
    Me.SetTimer(10234567, 10000);
    Me.KillTimer(10234568);
    Me.SetTimer(10234568, 100);
    return;
}

function OnHide()
{
    Me.KillTimer(10234567);
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x22
        case "searchItemBtn":
            OnsearchItemBtnClick();
            // End:0x97
            break;
        // End:0x37
        case "InitBtn":
            OnInitBtnClick();
            // End:0x97
            break;
        // End:0x53
        case "getQuestButton":
            getQuestButtonClick();
            // End:0x97
            break;
        // End:0x73
        case "MoveStartNPCButton":
            MoveStartNPCButtonClick();
            // End:0x97
            break;
        // End:0x94
        case "MoveTargetLocButton":
            MoveTargetLocButtonClick();
            // End:0x97
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnsearchItemBtnClick()
{
    FindAllQuest(searchEditBox.GetString());
    return;
}

function OnInitBtnClick()
{
    searchEditBox.SetString("");
    questListCtrl.DeleteAllItem();
    return;
}

function getQuestButtonClick()
{
    local int questID, nSelect;
    local LVDataRecord dataRecord;

    nSelect = questListCtrl.GetSelectedIndex();
    // End:0x93
    if(nSelect >= 0)
    {
        questListCtrl.GetSelectedRec(dataRecord);
        questID = int(dataRecord.LVDataList[0].szData);
        Debug("questID" @ string(questID));
        // End:0x93
        if(questID > 0)
        {
            ProcessChatMessage(("//setquest " $ string(questID)) $ " 1", 0);
        }
    }
    return;
}

function MoveStartNPCButtonClick()
{
    local int questID, nSelect;
    local LVDataRecord dataRecord;
    local Vector loc;

    nSelect = questListCtrl.GetSelectedIndex();
    // End:0x13A
    if(nSelect >= 0)
    {
        questListCtrl.GetSelectedRec(dataRecord);
        questID = int(dataRecord.LVDataList[0].szData);
        loc = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(questID, 1);
        // End:0x10D
        if(((loc.X + loc.Y) + loc.Z) != float(0))
        {
            Debug((("teleport -> " @ string(loc.X)) @ string(loc.Y)) @ string(loc.Z));
            ProcessChatMessage((("//teleport" @ string(loc.X)) @ string(loc.Y)) @ string(loc.Z), 0);
        }
        // End:0x13A
        if(questID <= 0)
        {
            AddSystemMessageString("questID is wrong:" @ string(questID));
        }
    }
    return;
}

function MoveTargetLocButtonClick()
{
    local int questID, nSelect, QuestLevel;
    local LVDataRecord dataRecord;
    local Vector loc;

    nSelect = questListCtrl.GetSelectedIndex();
    // End:0x153
    if(nSelect >= 0)
    {
        questListCtrl.GetSelectedRec(dataRecord);
        questID = int(dataRecord.LVDataList[0].szData);
        QuestLevel = name(dataRecord.nReserved2);
        loc = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(questID, QuestLevel);
        // End:0x153
        if(((loc.X + loc.Y) + loc.Z) != float(0))
        {
            // End:0x131
            if(questID > 0)
            {
                Debug((("teleport -> " @ string(loc.X)) @ string(loc.Y)) @ string(loc.Z));
                ProcessChatMessage((("//teleport" @ string(loc.X)) @ string(loc.Y)) @ string(loc.Z), 0);                
            }
            else
            {
                AddSystemMessageString("questID is wrong:" @ string(questID));
            }
        }
    }
    return;
}

function FindAllQuest(string a_Param)
{
    local int Id, i, NpcID;
    local string modifiedString, fullNameString, NpcName, JournalName, beforeJournalName, modifiedParam,
	    ZoneName;

    local int directQuestID;
    local Vector zoneLoc;

    questListCtrl.DeleteAllItem();
    // End:0x45
    if(int(a_Param) > 0)
    {
        a_Param = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(int(a_Param));
        directQuestID = int(a_Param);
    }
    modifiedParam = Locs(a_Param, " ", "", false);
    Id = Class'NWindow.UIDATA_QUEST'.static.GetFirstID();
    J0x6D:

    // End:0x2A3 [Loop If]
    if(-1 != Id)
    {
        fullNameString = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(Id);
        NpcID = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(Id, 1);
        NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
        i = 0;
        J0xD2:

        // End:0x28B [Loop If]
        if(i < 100)
        {
            zoneLoc = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(Id, i);
            ZoneName = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(Class'NWindow.UIDATA_QUEST'.static.GetQuestZone(Id, i));
            JournalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(Id, i);
            JournalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalNameLine(JournalName);
            modifiedString = ((fullNameString $ JournalName) $ NpcName) $ ZoneName;
            modifiedString = Locs(modifiedString, " ", "", false);
            // End:0x1B7
            if((Len(JournalName) <= 0) || i == 0)
            {
                // [Explicit Continue]
                goto J0x281;                
            }
            else
            {
                // End:0x1D8
                if((Len(JournalName) != 0) && beforeJournalName == JournalName)
                {
                    // [Explicit Continue]
                    goto J0x281;
                }
            }
            // End:0x216
            if(InStr(modifiedString, modifiedParam) != -1)
            {
                AddItem(Id, i, fullNameString, JournalName);
                beforeJournalName = JournalName;
                // [Explicit Continue]
                goto J0x281;
            }
            // End:0x281
            if(int(a_Param) > 0)
            {
                AddItem(Id, i, fullNameString, JournalName);
                JournalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(Id, i);
                JournalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalNameLine(JournalName);
                beforeJournalName = JournalName;
            }
            J0x281:

            i++;
            // [Loop Continue]
            goto J0xD2;
        }
        Id = Class'NWindow.UIDATA_QUEST'.static.GetNextID();
        // [Loop Continue]
        goto J0x6D;
    }
    return;
}

function AddItem(int nItemID, int QuestLevel, string fullNameString, string JournalName)
{
    local LVDataRecord Record;
    local string questTypeStr, LevelLimit, NpcName;
    local int QuestType, MinLevel, MaxLevel, NpcID, clearedQuestID;

    local Vector loc;
    local bool bStartLoc, bTargetLoc;

    Record.nReserved1 = (nItemID);
    Record.LVDataList.Length = 8;
    QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(nItemID, QuestLevel);
    questTypeStr = getQuestTypeString(QuestType);
    MinLevel = Class'NWindow.UIDATA_QUEST'.static.GetMinLevel(nItemID, 1);
    MaxLevel = Class'NWindow.UIDATA_QUEST'.static.GetMaxLevel(nItemID, 1);
    // End:0xBC
    if((MinLevel > 0) && MaxLevel > 0)
    {
        LevelLimit = (string(MinLevel) $ "~") $ string(MaxLevel);        
    }
    else
    {
        // End:0xE9
        if(MinLevel > 0)
        {
            LevelLimit = (string(MinLevel) $ " ") $ GetSystemString(859);            
        }
        else
        {
            LevelLimit = GetSystemString(866);
        }
    }
    Record.nReserved2 = (QuestLevel);
    Record.LVDataList[0].szData = string(nItemID);
    Record.LVDataList[1].TextColor = Gold;
    Record.LVDataList[1].bUseTextColor = true;
    Record.LVDataList[1].szData = questTypeStr;
    Record.LVDataList[2].szData = LevelLimit;
    Record.LVDataList[3].bUseTextColor = true;
    // End:0x1E6
    if(QuestLevel == 1)
    {
        Record.LVDataList[3].szData = ("[" $ fullNameString) $ "]";
        Record.LVDataList[3].TextColor = getInstanceL2Util().Yellow;        
    }
    else
    {
        Record.LVDataList[3].szData = ("   [" $ fullNameString) $ "]";
        Record.LVDataList[3].TextColor = Gold;
    }
    Record.LVDataList[3].hasIcon = true;
    Record.LVDataList[3].AttrColor.R = 170;
    Record.LVDataList[3].AttrColor.G = 170;
    Record.LVDataList[3].AttrColor.B = 170;
    Record.LVDataList[3].AttrStat[0] = Locs((("   " $ string(QuestLevel)) $ ": ") $ JournalName, "\\n", "<br1>", false);
    NpcID = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(nItemID, 1);
    NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
    Record.LVDataList[4].szData = NpcName;
    clearedQuestID = Class'NWindow.UIDATA_QUEST'.static.GetClearedQuest(nItemID, QuestLevel);
    loc = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(nItemID, QuestLevel);
    Record.LVDataList[5].szData = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(Class'NWindow.UIDATA_QUEST'.static.GetQuestZone(nItemID, QuestLevel));
    // End:0x3A3
    if((isVectorZero(loc)) == false)
    {
        bTargetLoc = true;
    }
    loc = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(nItemID, QuestLevel);
    // End:0x3DB
    if((isVectorZero(loc)) == false)
    {
        bStartLoc = true;
    }
    // End:0x40F
    if((bTargetLoc == true) && bStartLoc == true)
    {
        Record.LVDataList[6].szData = "OK";        
    }
    else
    {
        // End:0x44F
        if((bTargetLoc == true) && bStartLoc == false)
        {
            Record.LVDataList[6].szData = "No StartNPCLoc";            
        }
        else
        {
            // End:0x48D
            if((bTargetLoc == false) && bStartLoc == true)
            {
                Record.LVDataList[6].szData = "No TargetLoc";                
            }
            else
            {
                Record.LVDataList[6].szData = "No Loc(StartNpcLoc,TargetLoc)";
            }
        }
    }
    // End:0x5DC
    if(clearedQuestID > 0)
    {
        Record.LVDataList[7].bUseTextColor = true;
        Record.LVDataList[7].TextColor = Gold;
        Record.LVDataList[7].szData = (("QuestID:" $ string(clearedQuestID)) $ ": ") $ Class'NWindow.UIDATA_QUEST'.static.GetQuestName(clearedQuestID);
        Record.LVDataList[7].hasIcon = true;
        Record.LVDataList[7].AttrColor.R = 170;
        Record.LVDataList[7].AttrColor.G = 170;
        Record.LVDataList[7].AttrColor.B = 170;
        Record.LVDataList[7].AttrStat[0] = (GetSystemString(1201) $ ":") $ Class'NWindow.UIDATA_QUEST'.static.GetRequirement(nItemID, QuestLevel);
    }
    questListCtrl.InsertRecord(Record);
    return;
}

function OnRButtonClickListCtrl(string ListCtrlID, int SelectedIndex)
{
    // End:0x34
    if(ListCtrlID == "QuestListCtrl")
    {
        OnClickButton("MoveTargetLocButton");
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    local int questID, nSelect, QuestLevel;
    local LVDataRecord dataRecord;

    nSelect = questListCtrl.GetSelectedIndex();
    // End:0x90
    if(ListCtrlID == "QuestListCtrl")
    {
        // End:0x90
        if(nSelect >= 0)
        {
            questListCtrl.GetSelectedRec(dataRecord);
            questID = int(dataRecord.LVDataList[0].szData);
            QuestLevel = name(dataRecord.nReserved2);
            // End:0x90
            if(questID > 0)
            {
                FindAllQuest(string(questID));
            }
        }
    }
    return;
}

function showQuestDrawer(int questID, int Level)
{
    local int i, QuestType, MinLevel, MaxLevel;
    local string QuestParam;
    local int Max;
    local array<int> arrItemIDList, arrItemNumList, rewardIDList;
    local array<INT64> rewardNumList;
    local string JournalName, titleName, NpcName, targetString, levelText, questTypeText;

    local Vector loc, targetLoc;
    local string locHtml;
    local int NpcID, questZone;
    local string questArea, ItemNumStr, etcOutputStr;

    htmlMsg = "";
    htmlMsg = "<html><body>" $ (htmlTableAdd());
    MinLevel = Class'NWindow.UIDATA_QUEST'.static.GetMinLevel(questID, Level);
    MaxLevel = Class'NWindow.UIDATA_QUEST'.static.GetMaxLevel(questID, Level);
    NpcID = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(questID, 1);
    NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
    etcOutputStr = ((((etcOutputStr $ "NpcID :") @ string(NpcID)) $ ", npcName :") @ NpcName) $ "\\n\\n";
    QuestDescription = Class'NWindow.UIDATA_QUEST'.static.GetQuestDescription(questID, Level);
    QuestDescription = Locs(QuestDescription, "\\n", "<br1>", false);
    questZone = Class'NWindow.UIDATA_QUEST'.static.GetQuestZone(questID, 1);
    JournalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalName(questID, Level);
    JournalName = Class'NWindow.UIDATA_QUEST'.static.GetQuestJournalNameLine(JournalName);
    titleName = htmlAddText(("[" @ JournalName) @ "]", "hs10", "d4af6f");
    // End:0x1BF
    if((MaxLevel > 0) && MinLevel > 0)
    {
        levelText = (string(MinLevel) $ "~") $ string(MaxLevel);        
    }
    else
    {
        // End:0x1EC
        if(MinLevel > 0)
        {
            levelText = (string(MinLevel) $ " ") $ GetSystemString(859);            
        }
        else
        {
            levelText = GetSystemString(866);
        }
    }
    QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(questID, 1);
    // End:0x242
    if((0 <= QuestType) && QuestType <= 13)
    {
        questTypeText = getQuestTypeString(QuestType);
    }
    questTypeText = htmlfontAdd(questTypeText $ "  [");
    loc = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(questID, 1);
    etcOutputStr = (((((((etcOutputStr $ "startNpc Loc :") @ " x") $ string(int(loc.X))) $ " y") $ string(int(loc.Y))) $ " z") $ string(int(loc.Z))) $ "\\n\\n";
    // End:0x39C
    if(((loc.X == float(0)) && loc.Y == float(0)) && loc.Z == float(0))
    {
        loc = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(questID, Level);
        etcOutputStr = (((((((etcOutputStr $ "TargetLoc :") @ " x") $ string(int(loc.X))) $ " y") $ string(int(loc.Y))) $ " z") $ string(int(loc.Z))) $ "\\n\\n";        
    }
    else
    {
        targetLoc = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(questID, Level);
        etcOutputStr = (((((((etcOutputStr $ "TargetLoc :") @ " x") $ string(int(targetLoc.X))) $ " y") $ string(int(targetLoc.Y))) $ " z") $ string(int(targetLoc.Z))) $ "\\n\\n";
    }
    etcOutputStr = ((etcOutputStr $ "TargetName :") @ Class'NWindow.UIDATA_QUEST'.static.GetTargetName(questID, Level)) $ "\\n\\n";
    etcOutputStr = ((etcOutputStr $ "bOnlyMinimap :") @ string(Class'NWindow.UIDATA_QUEST'.static.IsMinimapOnly(questID, Level))) $ "\\n\\n";
    etcOutputStr = (((((((etcOutputStr $ "ZoneLoc :") @ " x") $ string(int(loc.X))) $ " y") $ string(int(loc.Y))) $ " z") $ string(int(loc.Z))) $ "\\n";
    NpcName = Locs(NpcName, " ", "!!", false);
    locHtml = (((("(" $ NpcName) $ ")") $ questArea) @ GetSystemString(7199)) $ "<br>";
    htmlMsg = (((((((htmlMsg $ titleName) $ "<br1>") $ (htmlfontAdd((GetSystemString(922) @ ":") @ levelText))) $ "<br1>") $ questTypeText) $ locHtml) $ (htmlfontAdd("]"))) $ "<br1></td></tr></table><br>";
    QuestParam = Class'NWindow.UIDATA_QUEST'.static.GetQuestItem(questID, Level);
    ParseInt(QuestParam, "Max", Max);
    arrItemIDList.Length = Max;
    arrItemNumList.Length = Max;
    i = 0;
    J0x613:

    // End:0x76F [Loop If]
    if(i < Max)
    {
        ParseInt(QuestParam, "ItemID_" $ string(i), arrItemIDList[i]);
        ParseInt(QuestParam, "ItemNum_" $ string(i), arrItemNumList[i]);
        // End:0x698
        if(arrItemNumList[i] == 0)
        {
            ItemNumStr = GetSystemString(7292);            
        }
        else
        {
            ItemNumStr = string(arrItemNumList[i]);
        }
        // End:0x716
        if((arrItemIDList[i] - 1000000) > 0)
        {
            targetString = (htmlfontAdd(((targetString $ Class'NWindow.UIDATA_NPC'.static.GetNPCName(arrItemIDList[i] - 1000000)) @ ItemNumStr) $ "NeedKill")) $ "<br1>";
            // [Explicit Continue]
            goto J0x765;
        }
        targetString = (htmlfontAdd(((targetString $ Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(arrItemIDList[i]))) @ ItemNumStr) $ "NeedItem")) $ "<br1>";
        J0x765:

        i++;
        // [Loop Continue]
        goto J0x613;
    }
    // End:0x802
    if(Max > 0)
    {
        targetString = ((((((htmlTableAdd()) $ "<font name=hs10 color=\"d4af6f\">") $ GetSystemString(7259)) $ "</font>") $ "<br1>") $ targetString) $ "<br1></td></tr></table><br>";
        htmlMsg = htmlMsg @ targetString;
    }
    rewardIDList.Remove(0, rewardIDList.Length);
    rewardNumList.Remove(0, rewardNumList.Length);
    Class'NWindow.UIDATA_QUEST'.static.GetQuestReward(questID, Level, rewardIDList, rewardNumList);
    // End:0x85B
    if(rewardIDList.Length > 0)
    {
        setRewardItem(rewardIDList, rewardNumList);
    }
    etcTextBox.SetText(etcOutputStr);
    return;
}

function setRewardItem(array<int> rewardIDList, array<INT64> rewardNumList)
{
    local int i;
    local string IconName, ItemName, rewardSmallIconHtml, rewardMsgHtml, rewardEndMsgHtml, itemText;

    local int tableIndex, smallIconIndex;
    local string addItemHtml, HtmlString;

    tableIndex = 0;
    smallIconIndex = 0;
    bicIconLen = 0;
    rewardSmallIconHtml = "<table width=280 border=0 cellpadding=0 cellspacing=2 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
    rewardMsgHtml = "<table width=280 border=0 cellpadding=0 cellspacing=2 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
    i = 0;
    J0x106:

    // End:0x17E [Loop If]
    if(i < rewardIDList.Length)
    {
        // End:0x174
        if((((rewardIDList[i] != 57) && rewardIDList[i] != 15623) && rewardIDList[i] != 15624) && rewardIDList[i] != 47130)
        {
            bicIconLen++;
        }
        i++;
        // [Loop Continue]
        goto J0x106;
    }
    // End:0xCCA
    if(rewardIDList.Length > 0)
    {
        i = 0;
        J0x191:

        // End:0xA9C [Loop If]
        if(i < rewardIDList.Length)
        {
            // End:0x232
            if(i == 0)
            {
                addItemHtml = ((((htmlTableAdd("L2UI_CT1.GroupBox.GroupBox_DF")) $ "<font color=\"ffcc00\" name=chatFontSize10>") $ GetSystemString(2006)) $ "</font>") $ "</td></tr></table>";
            }
            switch(rewardIDList[i])
            {
                // End:0x244
                case 57:
                // End:0x24C
                case 15623:
                // End:0x254
                case 15624:
                // End:0x4D4
                case 47130:
                    ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));
                    // End:0x2CE
                    if(rewardIDList[i] == 57)
                    {
                        IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_adena";
                        ItemName = GetSystemString(469);                        
                    }
                    else
                    {
                        // End:0x316
                        if(rewardIDList[i] == 15623)
                        {
                            // End:0x2EF
                            if((getLanguageNumber()) == 1)
                            {
                            }
                            IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_EXP";                            
                        }
                        else
                        {
                            // End:0x351
                            if(rewardIDList[i] == 15624)
                            {
                                IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_SP";                                
                            }
                            else
                            {
                                // End:0x389
                                if(rewardIDList[i] == 47130)
                                {
                                    IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_FP";
                                }
                            }
                        }
                    }
                    // End:0x3B1
                    if(__NFUN_412__(rewardNumList[i], (0)))
                    {
                        itemText = GetSystemString(584);                        
                    }
                    else
                    {
                        // End:0x3DC
                        if(rewardIDList[i] == 15624)
                        {
                            itemText = (rewardNumList[i]);                            
                        }
                        else
                        {
                            itemText = (rewardNumList[i]);
                        }
                    }
                    rewardSmallIconHtml = ((((((((rewardSmallIconHtml $ "<tr><td width=45 height=23 align=center valign=center><Img width=32 height=18") $ " src=\"") $ IconName) $ "\"") $ "></td><td height=23 width=246><font color=ba8860>") $ itemText) $ "</font>") @ (htmlfontAdd(ItemName))) $ "</td></tr>";
                    smallIconIndex = smallIconIndex + 1;
                    // End:0xA92
                    break;
                // End:0xFFFF
                default:
                    IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(rewardIDList[i]));
                    ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));
                    // End:0x559
                    if(__NFUN_412__(rewardNumList[i], (0)))
                    {
                        itemText = htmlfontAdd(GetSystemString(584), "ba8860");                        
                    }
                    else
                    {
                        // End:0x678
                        if(((((((((((rewardIDList[i] == 15623) || rewardIDList[i] == 15624) || rewardIDList[i] == 15625) || rewardIDList[i] == 15626) || rewardIDList[i] == 15627) || rewardIDList[i] == 15628) || rewardIDList[i] == 15629) || rewardIDList[i] == 15630) || rewardIDList[i] == 15631) || rewardIDList[i] == 15632) || rewardIDList[i] == 15633)
                        {
                            itemText = htmlfontAdd((rewardNumList[i]), "ba8860");                            
                        }
                        else
                        {
                            itemText = MakeFullSystemMsg(htmlfontAdd(GetSystemMessage(1983)), htmlfontAdd((rewardNumList[i]), "ba8860"), "");
                        }
                    }
                    // End:0x7DC
                    if(bicIconLen == 1)
                    {
                        rewardMsgHtml = ((((((((((((((((rewardMsgHtml $ "<tr><td align=center valign=center width=43 height=39><button width=32 height=32") $ " itemtooltip=\"") $ string(rewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=240 hdight=39>") $ (htmlfontAdd(ItemName))) $ "<br1>") $ itemText) $ "</td></tr>";                        
                    }
                    else
                    {
                        // End:0x80E
                        if((rewardIDList.Length > 0) && Len(ItemName) > 8)
                        {
                            ItemName = Mid(ItemName, 0, 8) $ "..";
                        }
                        // End:0x960
                        if((float(tableIndex) % float(2)) > float(0))
                        {
                            rewardMsgHtml = Mid(rewardMsgHtml, 0, Len(rewardMsgHtml) - 5);
                            rewardMsgHtml = (((((((((((((((((rewardMsgHtml $ "<td align=center valign=center width=43 height=39><button width=32 height=32") $ " itemtooltip=\"") $ string(rewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=115 hdight=39>") $ (htmlfontAdd(ItemName))) $ "<br1>") $ itemText) $ "<br1>") $ "</td></tr>";                            
                        }
                        else
                        {
                            rewardMsgHtml = (((((((((((((((((rewardMsgHtml $ (htmlTableTrAdd())) $ "<tr><td align=center valign=center width=43 height=39><button width=32 height=32") $ " itemtooltip=\"") $ string(rewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=115 hdight=39>") $ (htmlfontAdd(ItemName))) $ "<br1>") $ itemText) $ "</td></tr>";
                        }
                    }
                    tableIndex = tableIndex + 1;
                    break;
            }
            i++;
            // [Loop Continue]
            goto J0x191;
        }
        // End:0xAC1
        if(tableIndex > 0)
        {
            rewardMsgHtml = rewardMsgHtml $ "</table>";            
        }
        else
        {
            rewardMsgHtml = "";
        }
        // End:0xAEE
        if(smallIconIndex > 0)
        {
            rewardSmallIconHtml = rewardSmallIconHtml $ "</table>";            
        }
        else
        {
            rewardSmallIconHtml = "";
        }
        HtmlString = Mid(HtmlString, 6, Len(HtmlString));
        HtmlString = Mid(HtmlString, 0, Len(HtmlString) - 7);
        rewardEndMsgHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Down><tr><td width=278></td></tr></table>";
        addItemHtml = (((HtmlString $ addItemHtml) $ rewardSmallIconHtml) $ rewardMsgHtml) $ rewardEndMsgHtml;
        addItemHtml = (((("<html><body>" $ addItemHtml) $ "<br><table border=0 cellpadding=0 cellspacing=3 width=288 ><tr><td height=11 align=center valign=center></td></tr><tr><td></td></tr></table><br><br>") $ rewardEndMsgHtml) $ QuestDescription) $ "</body></html>";
        DetailInfoHtmlCtrl.LoadHtmlFromString(addItemHtml);
    }
    return;
}

function string htmlTableAdd(optional string backgroundUrl)
{
    local string htmlStr;

    // End:0x74
    if(backgroundUrl == "")
    {
        htmlStr = "<table width=279 cellpadding=0 border=0 cellspacing=3" $ "><tr><td width=4></td><td width=273>";        
    }
    else
    {
        htmlStr = ("<table width=279 cellpadding=0 border=0 cellspacing=3 background=" $ backgroundUrl) $ "><tr><td width=0></td><td width=273>";
    }
    return htmlStr;
    return;
}

function string htmlTableTrAdd()
{
    return "<tr><td width=40 ></td><td width=115 ></td><td width=40 ></td><td width=115 ></td></tr>";
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

function OnClickListCtrlRecord(string ListCtrlID)
{
    // End:0x29
    if(ListCtrlID == "QuestListCtrl")
    {
        addPinInTheMap(ListCtrlID, -1);
    }
    return;
}

function addPinInTheMap(string ListCtrlID, int SelectedIndex)
{
    local LVDataRecord Record;
    local int questID, Level;

    // End:0xA3
    if(ListCtrlID == "QuestListCtrl")
    {
        // End:0x3D
        if(SelectedIndex != -1)
        {
            questListCtrl.SetSelectedIndex(SelectedIndex, false);
        }
        questListCtrl.GetSelectedRec(Record);
        questID = name(Record.nReserved1);
        Level = name(Record.nReserved2);
        showQuestDrawer(questID, Level);
        // End:0xA3
        if(SelectedIndex == -1)
        {
            questListCtrl.SetFocus();
        }
    }
    return;
}

function int getLanguageNumber()
{
    local UIEventManager.ELanguageType Language;
    local int languageNum;

    Language = GetLanguage();
    switch(Language)
    {
        // End:0x22
        case 0:
            languageNum = 0;
            // End:0xFE
            break;
        // End:0x31
        case 1:
            languageNum = 1;
            // End:0xFE
            break;
        // End:0x41
        case 2:
            languageNum = 2;
            // End:0xFE
            break;
        // End:0x51
        case 3:
            languageNum = 3;
            // End:0xFE
            break;
        // End:0x61
        case 4:
            languageNum = 4;
            // End:0xFE
            break;
        // End:0x71
        case 5:
            languageNum = 5;
            // End:0xFE
            break;
        // End:0x81
        case 6:
            languageNum = 6;
            // End:0xFE
            break;
        // End:0x91
        case 7:
            languageNum = 7;
            // End:0xFE
            break;
        // End:0xA1
        case 8:
            languageNum = 8;
            // End:0xFE
            break;
        // End:0xB1
        case 9:
            languageNum = 9;
            // End:0xFE
            break;
        // End:0xC1
        case 10:
            languageNum = 10;
            // End:0xFE
            break;
        // End:0xD1
        case 11:
            languageNum = 11;
            // End:0xFE
            break;
        // End:0xE1
        case 12:
            languageNum = 12;
            // End:0xFE
            break;
        // End:0xF1
        case 13:
            languageNum = 13;
            // End:0xFE
            break;
        // End:0xFFFF
        default:
            languageNum = 0;
            // End:0xFE
            break;
            break;
    }
    return languageNum;
    return;
}

function OnReceivedCloseUI()
{
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x44
    if(searchEditBox.IsFocused())
    {
        // End:0x44
        if(int(nKey) == int(13))
        {
            // End:0x44
            if((trim(searchEditBox.GetString())) != "")
            {
                OnsearchItemBtnClick();
            }
        }
    }
    return;
}
