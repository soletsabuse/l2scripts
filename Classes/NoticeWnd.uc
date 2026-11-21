class NoticeWnd extends L2UIGFxScript;

const FLASH_XPOS = -7;
const FLASH_YPOS = -250;
const NOTICEBUTTON_DELETE = "900";
const NOTICEBUTTON_DELETEALL = "1000";
const LAYOUT_MULTILINE = "10001";
const LAYOUT_ONELINE = "10002";

enum ENoticeType
{
    TYPE_MAIL,                      // 0
    TYPE_QUEST,                     // 1
    TYPE_PREM,                      // 2
    TYPE_TUTORIAL,                  // 3
    TYPE_SKILL,                     // 4
    TYPE_CAMPAIGN,                  // 5
    TYPE_ZONE,                      // 6
    TYPE_AWAKENED,                  // 7
    TYPE_CURIOUSEHOUSE,             // 8
    TYPE_EVENTCAMPAIGN,             // 9
    TYPE_PLEDGEALARM,               // 10
    TYPE_WEBPETITIONALARM,          // 11
    TYPE_SINGLEMESHZONE,            // 12
    TYPE_PVPBLOCKCHECKER,           // 13
    TYPE_PVPCRATAECUBE,             // 14
    TYPE_PVPMATCHRECORD,            // 15
    TYPE_PVPCLEFT,                  // 16
    TYPE_PATHTOAWAKENINGALARM,      // 17
    TYPE_TODOLIST,                  // 18
    TYPE_LINEAGE2HOME,              // 19
    TYPE_KILLER,                    // 20
    TYPE_PCROOM,                    // 21
    TYPE_ATTENDANCESTAMP,           // 22
    TYPE_CHINATUTORIAL,             // 23
    TYPE_ABILITYPOINT,              // 24
    TYPE_MONSTERBOOK,               // 25
    TYPE_FACTION,                   // 26
    TYPE_AUCTION_FAIL,              // 27
    TYPE_EVENT_INFO,                // 28
    TYPE_NSHOPHOME                  // 29
};

var int RecentlyAddedQuestID;
var int HtmlString;
var int zonetype;
var export editinline array<export editinline GFxValue> args;
var export editinline GFxValue invokeResult;
var WindowHandle Me;
var WindowHandle AlarmWnd;
var MagicSkillWnd MagicSkillWndScript;
var QuestTreeWnd QuestTreeWndScript;
var UserInfo currentUserInfo;
var TabHandle m_TabCtrl;
var bool bCam;
var bool bZone;
var bool bEvent;
var bool bUseSingleMesh;
var int awakeClassID;
var int awakeImmediate;
var int currentScreenWidth;
var int currentScreenHeight;
var int PathToAwakeningAlarmType;
var int PathToAwakeningAlarmValue;
var int nUsePledgeV2Live;
var bool isPrologueGrowTypeState;
var bool isGetPremium;
//var delegate<onCollectionNotifyClick> __onCollectionNotifyClick__Delegate;

function OnRegisterEvent()
{
    RegisterEvent(2900);
    RegisterEvent(40);
    RegisterEvent(1530);
    RegisterEvent(4700);
    RegisterEvent(110);
    RegisterEvent(1520);
    RegisterEvent(3460);
    RegisterEvent(5603);
    RegisterEvent(1511);
    RegisterEvent(2059);
    RegisterEvent(5470);
    RegisterEvent(9630);
    RegisterEvent(5210);
    RegisterEvent(5250);
    RegisterEvent(5220);
    RegisterEvent(9310);
    RegisterEvent(9500);
    RegisterEvent(9540);
    RegisterEvent(9541);
    RegisterEvent(9452);
    RegisterEvent(10040);
    RegisterEvent(3890);
    RegisterEvent(3900);
    RegisterEvent(3740);
    RegisterEvent(3750);
    RegisterEvent(3500);
    RegisterEvent(3470);
    RegisterEvent(3501);
    RegisterEvent(3370);
    RegisterEvent(720);
    RegisterEvent(3410);
    RegisterEvent(320);
    RegisterGFxEvent(10450);
    RegisterEvent(180);
    RegisterEvent(3053);
    RegisterEvent(10171);
    RegisterEvent(10160);
    RegisterEvent(10140);
    RegisterEvent(5312);
    return;
}

function OnLoad()
{
    RegisterState("NoticeWnd", "GamingState");
    SetContainerHUD("none", 0);
    AddState("GAMINGSTATE");
    SetHavingFocus(false);
    SetDefaultShow(true);
    SetHUD();
    Me = GetWindowHandle("NoticeWnd");
    AlarmWnd = GetWindowHandle("PremiumItemAlarmWnd");
    MagicSkillWndScript = MagicSkillWnd(GetScript("MagicSkillWnd"));
    QuestTreeWndScript = QuestTreeWnd(GetScript("QuestTreeWnd"));
    PathToAwakeningAlarmType = 0;
    PathToAwakeningAlarmValue = 0;
    return;
}

function OnShow()
{
    checkMultiLayOut();
    return;
}

function OnFlashLoaded()
{
    checkMultiLayOut();
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    clickNoticeButton(functionName, param);
    return;
}

function clickNoticeButton(string logicIDStr, string param)
{
    local string strParam;
    local int logicID;
    local CampaignAlarmWnd campaign;
    local ZoneQuestAlarmWnd Zone;
    local GfxDialog GfxDialogScript;
    local BR_CampaignAlarmWnd br_eventcampaign;
    local int tutorialID, tutorialType;

    logicID = int(logicIDStr);
    campaign = CampaignAlarmWnd(GetScript("CampaignAlarmWnd"));
    Zone = ZoneQuestAlarmWnd(GetScript("ZoneQuestAlarmWnd"));
    br_eventcampaign = BR_CampaignAlarmWnd(GetScript("BR_CampaignAlarmWnd"));
    // End:0xB0
    if(logicID == 0)
    {
        // End:0xA2
        if(zonetype == 12)
        {
            PlayConsoleSound(5);
            RequestRequestReceivedPostList();            
        }
        else
        {
            AddSystemMessage(3066);
        }        
    }
    else
    {
        // End:0xE9
        if(logicID == 1)
        {
            ParamAdd(strParam, "QuestID", string(RecentlyAddedQuestID));
            ExecuteEvent(730, strParam);            
        }
        else
        {
            // End:0x130
            if(logicID == 2)
            {
                // End:0x127
                if(IsUseGoodsInvnentory() == false)
                {
                    // End:0x124
                    if(!AlarmWnd.IsShowWindow())
                    {
                        AlarmWnd.ShowWindow();
                    }                    
                }
                else
                {
                    HandleShowProductInventory();
                }                
            }
            else
            {
                // End:0x179
                if(logicID == 3)
                {
                    ParseInt(param, "ID", tutorialID);
                    ParseInt(param, "Type", tutorialType);
                    RequestTutorialMarkPressed(tutorialType, tutorialID);                    
                }
                else
                {
                    // End:0x197
                    if(logicID == 4)
                    {
                        MagicSkillWndScript.externalCallLearnSkill();                        
                    }
                    else
                    {
                        // End:0x1BD
                        if(logicID == 5)
                        {
                            bCam = false;
                            campaign.RaderButtonClick();                            
                        }
                        else
                        {
                            // End:0x1E3
                            if(logicID == 6)
                            {
                                bZone = false;
                                Zone.RaderButtonClick();                                
                            }
                            else
                            {
                                // End:0x261
                                if(logicID == 7)
                                {
                                    ParamAdd(strParam, "Class", string(awakeClassID));
                                    GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
                                    GfxDialogScript.showGfxDialog("dialogLinkageName", "AwakeNoticeDialog", strParam);                                    
                                }
                                else
                                {
                                    // End:0x276
                                    if(logicID == 8)
                                    {
                                        RequestCuriousHouseHtml();                                        
                                    }
                                    else
                                    {
                                        // End:0x29C
                                        if(logicID == 9)
                                        {
                                            bEvent = false;
                                            br_eventcampaign.RaderButtonClick();                                            
                                        }
                                        else
                                        {
                                            // End:0x2E6
                                            if(logicID == 10)
                                            {
                                                // End:0x2E3
                                                if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanSearch"))
                                                {
                                                    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ClanSearch");
                                                }                                                
                                            }
                                            else
                                            {
                                                // End:0x306
                                                if(logicID == 11)
                                                {
                                                    ExecuteEvent(9451);
                                                    ResponsePetitionAlarm();                                                    
                                                }
                                                else
                                                {
                                                    // End:0x356
                                                    if(logicID == 12)
                                                    {
                                                        bUseSingleMesh = !bUseSingleMesh;
                                                        SwitchSingleMeshMode(bUseSingleMesh);
                                                        // End:0x346
                                                        if(bUseSingleMesh)
                                                        {
                                                            createNoticeButton(12, 3031);                                                            
                                                        }
                                                        else
                                                        {
                                                            createNoticeButton(12, 3030);
                                                        }                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x36D
                                                        if(logicID == 13)
                                                        {
                                                            pvpButton(13);                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x384
                                                            if(logicID == 14)
                                                            {
                                                                pvpButton(14);                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x39B
                                                                if(logicID == 15)
                                                                {
                                                                    pvpButton(15);                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x3EB
                                                                    if(logicID == 17)
                                                                    {
                                                                        ParamAdd(strParam, "Type", string(PathToAwakeningAlarmType));
                                                                        ParamAdd(strParam, "Value", string(PathToAwakeningAlarmValue));
                                                                        ExecuteEvent(10010, strParam);                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x408
                                                                        if(logicID == 19)
                                                                        {
                                                                            showHideL2InGameWeb("main", "");                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x41D
                                                                            if(logicID == 24)
                                                                            {
                                                                                showHideAbilityWnd();                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x432
                                                                                if(logicID == 25)
                                                                                {
                                                                                    showhideMonsterBookWnd();                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    // End:0x44B
                                                                                    if(logicID == 26)
                                                                                    {
                                                                                        onCollectionNotifyClick();                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        // End:0x460
                                                                                        if(logicID == 27)
                                                                                        {
                                                                                            handleAuctionFail();                                                                                            
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            // End:0x516
                                                                                            if(logicID == 18)
                                                                                            {
                                                                                                // End:0x4E8
                                                                                                if(getInstanceUIData().getIsLiveServer())
                                                                                                {
                                                                                                    // End:0x4C5
                                                                                                    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ToDoListClanWnd"))
                                                                                                    {
                                                                                                        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ToDoListClanWnd");                                                                                                        
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ToDoListClanWnd");
                                                                                                    }                                                                                                    
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    // End:0x513
                                                                                                    if(getInstanceUIData().getIsClassicServer())
                                                                                                    {
                                                                                                        ExecuteEvent(20160, "forceOpen=1");
                                                                                                    }
                                                                                                }                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                // End:0x539
                                                                                                if(logicID == 28)
                                                                                                {
                                                                                                    showHideWindow("EventInfoWnd");                                                                                                    
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    // End:0x557
                                                                                                    if(logicID == 29)
                                                                                                    {
                                                                                                        showHideL2InGameWeb("nshop", "");                                                                                                        
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        // End:0x57C
                                                                                                        if(logicID == 16)
                                                                                                        {
                                                                                                            showHideWindow("PlayerGameplayWnd");
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

delegate onCollectionNotifyClick()
{
    return;
}

function handleAuctionFail()
{
    local string strParam;
    local HelpHtmlWnd script;

    script = HelpHtmlWnd(GetScript("HelpHtmlWnd"));
    ParamAdd(strParam, "FilePath", "..\\L2text\\item_auction_rule_info002.htm");
    script.HandleShowHelp(strParam);
    return;
}

function showhideMonsterBookWnd()
{
    // End:0x44
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("MonsterBookWnd"))
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MonsterBookWnd");        
    }
    else
    {
        CallGFxFunction("MonsterBookWnd", "clearSearchCondition", "");
        CallGFxFunction("MonsterBookWnd", "ChangefactionCategroy", "0");
    }
    return;
}

function showHideWindow(string WindowName)
{
    // End:0x2E
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(WindowName))
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(WindowName);        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(WindowName);
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus(WindowName);
    }
    return;
}

function showHideAbilityWnd()
{
    showHideWindow("AbilityWnd");
    return;
}

function showHideL2InGameWeb(string Category, string Message)
{
    local string strParam;

    ParamAdd(strParam, "Category", Category);
    ParamAdd(strParam, "Message", "");
    ExecuteEvent(10120, strParam);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int iEffectNumber, Level, statusInt;
    local string strParam, strTargetName;
    local Vector vTargetPos;
    local bool bOnlyMinimap;
    local GfxDialog GfxDialogScript;
    local int UserType, clanID;

    // End:0x12
    if(Event_ID == 1530)
    {        
    }
    else
    {
        // End:0x49
        if(Event_ID == 4700)
        {
            ParseInt(param, "IdxMail", iEffectNumber);
            createNoticeButton(0, 2074);            
        }
        else
        {
            // End:0x72
            if(Event_ID == 110)
            {
                ParseInt(param, "ZoneCode", zonetype);                
            }
            else
            {
                // End:0x91
                if(Event_ID == 9630)
                {
                    createNoticeButton(10, 3068);                    
                }
                else
                {
                    // End:0x32C
                    if(Event_ID == 1520)
                    {
                        ParseInt(param, "QuestID", RecentlyAddedQuestID);
                        ParseInt(param, "QuestLevel", Level);
                        ArriveShowQuest();
                        GetPlayerInfo(currentUserInfo);
                        // End:0x148
                        if((((RecentlyAddedQuestID == 10338) || (currentUserInfo.nClassID <= 181) && currentUserInfo.nClassID >= 148) || currentUserInfo.nClassID == 188) || currentUserInfo.nClassID == 189)
                        {
                            ChangeToAwakenedArrived(false);
                        }
                        // End:0x329
                        if((RecentlyAddedQuestID > 0) && Level > 0)
                        {
                            strTargetName = Class'NWindow.UIDATA_QUEST'.static.GetTargetName(RecentlyAddedQuestID, Level);
                            vTargetPos = Class'NWindow.UIDATA_QUEST'.static.GetTargetLoc(RecentlyAddedQuestID, Level);
                            ParamAdd(strParam, "X", string(vTargetPos.X));
                            ParamAdd(strParam, "Y", string(vTargetPos.Y));
                            ParamAdd(strParam, "Z", string(vTargetPos.Z));
                            ParamAdd(strParam, "targetName", strTargetName);
                            ParamAdd(strParam, "QuestID", string(RecentlyAddedQuestID));
                            ParamAdd(strParam, "QuestLevel", string(Level));
                            ParamAdd(strParam, "questName", Class'NWindow.UIDATA_QUEST'.static.GetQuestName(RecentlyAddedQuestID, Level));
                            CallGFxFunction("RadarMapWnd", "showQuestTargetInfo", strParam);
                            bOnlyMinimap = Class'NWindow.UIDATA_QUEST'.static.IsMinimapOnly(RecentlyAddedQuestID, Level);
                            QuestTreeWndScript.curQuestExpand(RecentlyAddedQuestID);
                            // End:0x303
                            if(bOnlyMinimap)
                            {
                                Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(true, false, false, strTargetName, vTargetPos, RecentlyAddedQuestID, Level);                                
                            }
                            else
                            {
                                Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(true, true, true, strTargetName, vTargetPos, RecentlyAddedQuestID, Level);
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x355
                        if((Event_ID == 3460) || Event_ID == 5603)
                        {
                            PremiumItemAlarm();                            
                        }
                        else
                        {
                            // End:0x372
                            if(Event_ID == 1511)
                            {
                                ArriveNewTutorialQuestion(param);                                
                            }
                            else
                            {
                                // End:0x38A
                                if(Event_ID == 2059)
                                {
                                    SkillLearningNewArrival();                                    
                                }
                                else
                                {
                                    // End:0x3AA
                                    if(Event_ID == 5210)
                                    {
                                        bCam = true;
                                        CampaignArrived();                                        
                                    }
                                    else
                                    {
                                        // End:0x3C2
                                        if(Event_ID == 5250)
                                        {
                                            ClearCampaignBtn();                                            
                                        }
                                        else
                                        {
                                            // End:0x3E2
                                            if(Event_ID == 5220)
                                            {
                                                bZone = true;
                                                ZoneQuestArrived();                                                
                                            }
                                            else
                                            {
                                                // End:0x402
                                                if(Event_ID == 9500)
                                                {
                                                    bEvent = true;
                                                    EventCampaignArrived();                                                    
                                                }
                                                else
                                                {
                                                    // End:0x59D
                                                    if(Event_ID == 5470)
                                                    {
                                                        ParseInt(param, "Class", awakeClassID);
                                                        ParseInt(param, "Immediate", awakeImmediate);
                                                        ParseInt(param, "UserType", UserType);
                                                        // End:0x4E3
                                                        if(UserType == 0)
                                                        {
                                                            strParam = "";
                                                            ParamAdd(strParam, "Class", string(awakeClassID));
                                                            GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
                                                            GfxDialogScript.showGfxDialog("dialogLinkageName", "DualPayDialogStep1", strParam);                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x4F1
                                                            if(awakeClassID <= 0)
                                                            {                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x593
                                                                if(awakeImmediate == 1)
                                                                {
                                                                    strParam = "";
                                                                    ParamAdd(strParam, "Class", string(awakeClassID));
                                                                    ParamAdd(strParam, "Immediate", string(awakeImmediate));
                                                                    GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
                                                                    GfxDialogScript.showGfxDialog("dialogLinkageName", "AwakeNoticeDialog", strParam);                                                                    
                                                                }
                                                                else
                                                                {
                                                                    ChangeToAwakenedArrived(true);
                                                                }
                                                            }
                                                        }                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x5C2
                                                        if(Event_ID == 40)
                                                        {
                                                            isGetPremium = false;
                                                            isPrologueGrowTypeState = false;
                                                            removeALLNoticeButton();                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x5DA
                                                            if(Event_ID == 2900)
                                                            {
                                                                checkMultiLayOut();                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x5F7
                                                                if(Event_ID == 9310)
                                                                {
                                                                    CuriousHouseHandle(param);                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x60F
                                                                    if(Event_ID == 9452)
                                                                    {
                                                                        WebPetitionReplyAlarm();                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x64F
                                                                        if(Event_ID == 9540)
                                                                        {
                                                                            bUseSingleMesh = true;
                                                                            // End:0x63F
                                                                            if(bUseSingleMesh)
                                                                            {
                                                                                createNoticeButton(12, 3031);                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                createNoticeButton(12, 3030);
                                                                            }                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x671
                                                                            if(Event_ID == 9541)
                                                                            {
                                                                                bUseSingleMesh = false;
                                                                                removeNoticeButton(12);                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x6A1
                                                                                if((Event_ID == 3890) || Event_ID == 3900)
                                                                                {
                                                                                    createNoticeButton(13, 2445);                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    // End:0x6C0
                                                                                    if(Event_ID == 3500)
                                                                                    {
                                                                                        createNoticeButton(14, 2444);                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        // End:0x719
                                                                                        if(Event_ID == 3470)
                                                                                        {
                                                                                            ParseInt(param, "Status", statusInt);
                                                                                            // End:0x702
                                                                                            if(statusInt == 0)
                                                                                            {
                                                                                                createNoticeButton(14, 2444);                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                // End:0x716
                                                                                                if(statusInt == 2)
                                                                                                {
                                                                                                    removeNoticeButton(14);
                                                                                                }
                                                                                            }                                                                                            
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            // End:0x733
                                                                                            if(Event_ID == 3501)
                                                                                            {
                                                                                                removeNoticeButton(14);                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                // End:0x792
                                                                                                if(Event_ID == 3370)
                                                                                                {
                                                                                                    ParseInt(param, "CurrentState", statusInt);
                                                                                                    // End:0x77B
                                                                                                    if(statusInt == 0)
                                                                                                    {
                                                                                                        createNoticeButton(15, 2442);                                                                                                        
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        // End:0x78F
                                                                                                        if(statusInt == 2)
                                                                                                        {
                                                                                                            removeNoticeButton(15);
                                                                                                        }
                                                                                                    }                                                                                                    
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    // End:0x7B8
                                                                                                    if(Event_ID == 720)
                                                                                                    {
                                                                                                        QuestTreeWndScript.findNowQuestExist(RecentlyAddedQuestID);                                                                                                        
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        // End:0x804
                                                                                                        if(Event_ID == 10040)
                                                                                                        {
                                                                                                            ParseInt(param, "Type", PathToAwakeningAlarmType);
                                                                                                            ParseInt(param, "Value", PathToAwakeningAlarmValue);
                                                                                                            createNoticeButton(17, 5178);                                                                                                            
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                            // End:0x841
                                                                                                            if(Event_ID == 320)
                                                                                                            {
                                                                                                                ParseInt(param, "ClanID", clanID);
                                                                                                                // End:0x83E
                                                                                                                if(clanID > 0)
                                                                                                                {
                                                                                                                    removeNoticeButton(10);
                                                                                                                }                                                                                                                
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                // End:0x881
                                                                                                                if(Event_ID == 180)
                                                                                                                {
                                                                                                                    chkAbilityPoint();
                                                                                                                    ParseInt(param, "ClanID", clanID);
                                                                                                                    // End:0x87E
                                                                                                                    if(clanID > 0)
                                                                                                                    {
                                                                                                                        removeNoticeButton(10);
                                                                                                                    }                                                                                                                    
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    // End:0x8A0
                                                                                                                    if(Event_ID == 3053)
                                                                                                                    {
                                                                                                                        createNoticeButton(27, 3500);                                                                                                                        
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        // End:0x8BF
                                                                                                                        if(Event_ID == 10171)
                                                                                                                        {
                                                                                                                            createNoticeButton(26, 3443);                                                                                                                            
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            // End:0x8DE
                                                                                                                            if(Event_ID == 10160)
                                                                                                                            {
                                                                                                                                createNoticeButton(25, 3511);                                                                                                                                
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                // End:0x90B
                                                                                                                                if(Event_ID == 10140)
                                                                                                                                {
                                                                                                                                    // End:0x908
                                                                                                                                    if(getInstanceL2Util().isClanV2())
                                                                                                                                    {
                                                                                                                                        removeNoticeButton(18);
                                                                                                                                    }                                                                                                                                    
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    // End:0x925
                                                                                                                                    if(Event_ID == 5312)
                                                                                                                                    {
                                                                                                                                        handleChangedSubjob(param);
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            }
                                                                                                                        }
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // End:0x978
    if(Event_ID == 3410)
    {
        // End:0x978
        if(param == "GAMINGSTATE")
        {
            isPrologueGrowTypeState = getInstanceL2Util().getIsPrologueGrowType();
            // End:0x978
            if(bUseL2Button())
            {
                createNoticeButton(29, 3634);
            }
        }
    }
    return;
}

function chkAbilityPoint()
{
    return;
}

function bool bUseL2Button()
{
    local UIEventManager.ELanguageType Language;
    local bool flag;

    Language = GetLanguage();
    // End:0x38
    if((int(Language) == 0) && !getInstanceUIData().getIsArenaServer())
    {
        flag = true;
    }
    return flag;
    return;
}

function toggleWindow(string WindowName)
{
    // End:0x32
    if(!GetWindowHandle(WindowName).IsShowWindow())
    {
        GetWindowHandle(WindowName).ShowWindow();        
    }
    else
    {
        GetWindowHandle(WindowName).HideWindow();
    }
    return;
}

function pvpButton(int SelectPVP)
{
    // End:0x22
    if(SelectPVP == 13)
    {
        toggleWindow("BlockCurWnd");        
    }
    else
    {
        // End:0x76
        if(SelectPVP == 14)
        {
            // End:0x5B
            if(!GetWindowHandle("KillPointRankWnd").IsShowWindow())
            {
                RequestStartShowCrataeCubeRank();
            }
            toggleWindow("KillPointRankWnd");            
        }
        else
        {
            // End:0x98
            if(SelectPVP == 15)
            {
                toggleWindow("PVPDetailedWnd");
            }
        }
    }
    return;
}

function CuriousHouseHandle(string param)
{
    local int HouseState;

    ParseInt(param, "State", HouseState);
    switch(HouseState)
    {
        // End:0x32
        case 1:
            createNoticeButton(8, 2804);
            // End:0x51
            break;
        // End:0x36
        case 0:
        // End:0x3B
        case 2:
        // End:0x4B
        case 3:
            removeNoticeButton(8);
            // End:0x51
            break;
        // End:0xFFFF
        default:
            // End:0x51
            break;
            break;
    }
    return;
}

function PledgeAlarm()
{
    createNoticeButton(10, 3068);
    return;
}

function WebPetitionReplyAlarm()
{
    createNoticeButton(11, 3109);
    return;
}

function Notice_Post_Arrived()
{
    createNoticeButton(0, 2074);
    return;
}

function ArriveShowQuest()
{
    createNoticeButton(1, 118);
    return;
}

function PremiumItemAlarm()
{
    // End:0x27
    if(IsUseGoodsInvnentory() == false)
    {
        createNoticeButton(2, 1738);
        AddSystemMessage(2313);        
    }
    else
    {
        createNoticeButton(2, 2680);
    }
    return;
}

function SkillLearningNewArrival()
{
    createNoticeButton(4, 2369);
    return;
}

function CampaignArrived()
{
    createNoticeButton(5, 2440);
    return;
}

function ZoneQuestArrived()
{
    createNoticeButton(6, 2441);
    return;
}

function EventCampaignArrived()
{
    createNoticeButton(9, 5143);
    return;
}

function EventInfoArrived()
{
    createNoticeButton(28, 3004);
    return;
}

function hideNoticeButton_EventInfo()
{
    removeNoticeButton(28);
    return;
}

function ClearCampaignBtn()
{
    // End:0x1C
    if(bCam == true)
    {
        removeNoticeButton(5);
        bCam = false;
    }
    return;
}

function ClearZoneQuestBtn()
{
    // End:0x1C
    if(bZone == true)
    {
        removeNoticeButton(6);
        bZone = false;
    }
    return;
}

function PathToAwakeningAlarm()
{
    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(17);
    CreateObject(args[1]);
    args[1].SetMemberInt("toolTipNum", 5178);
    Invoke("_root.onEvent", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function ClearBRCampaignBtn()
{
    // End:0x1C
    if(bEvent == true)
    {
        removeNoticeButton(9);
        bEvent = false;
    }
    return;
}

function ChangeToAwakenedArrived(bool bOnOff)
{
    // End:0x19
    if(bOnOff)
    {
        createNoticeButton(7, 2491);        
    }
    else
    {
        removeNoticeButton(7);
    }
    return;
}

function HandleShowProductInventory()
{
    local WindowHandle win;

    win = GetWindowHandle("ProductInventoryWnd");
    // End:0x53
    if(!win.IsShowWindow())
    {
        win.ShowWindow();
        win.SetFocus();
    }
    return;
}

function SetShowWindow()
{
    local bool bStateCheck;

    bStateCheck = GetGameStateName() == "GAMINGSTATE";
    // End:0x39
    if((IsShowWindow() == false) && bStateCheck)
    {
        ShowWindow();
    }
    return;
}

function OnEnterState(name a_PreStateName)
{
    SetShowWindow();
    return;
}

function checkMultiLayOut()
{
    local int tmpInt;

    GetINIInt("ShortcutWnd", "v", tmpInt, "WindowsInfo.ini");
    // End:0x40
    if(bool(tmpInt))
    {
        setMultiLayOut(false);        
    }
    else
    {
        setMultiLayOut(true);
    }
    return;
}

function setMultiLayOut(bool flag)
{
    // End:0x3C
    if(flag)
    {
        SetAnchor("", 9, 1, -47, -150);
        CallGFxFunction("noticeWnd", "10001", "");        
    }
    else
    {
        SetAnchor("", 9, 1, -205, -64);
        CallGFxFunction("noticeWnd", "10002", "");
    }
    return;
}

function ArriveNewTutorialQuestion(string param)
{
    local int toolTipNum;

    ParseInt(param, "toolTipNum", toolTipNum);
    // End:0x32
    if(toolTipNum <= 0)
    {
        toolTipNum = 448;
    }
    createNoticeButtonWithParam(3, toolTipNum, param);
    return;
}

function createNoticeButton(int nType, int nTooltipString)
{
    local string paramStr;

    // End:0x10
    if(checkIisPrologueGrowType(nType))
    {
        return;
    }
    // End:0x3E
    if((getInstanceL2Util().isClanV2() && IsPlayerOnWorldRaidServer()) && nType == 18)
    {
        return;
    }
    ParamAdd(paramStr, "toolTipNum", string(nTooltipString));
    CallGFxFunction("noticeWnd", string(nType), paramStr);
    return;
}

function createNoticeButtonWithParam(int nType, int nTooltipString, string paramStr)
{
    // End:0x10
    if(checkIisPrologueGrowType(nType))
    {
        return;
    }
    // End:0x3E
    if((getInstanceL2Util().isClanV2() && IsPlayerOnWorldRaidServer()) && nType == 18)
    {
        return;
    }
    ParamAdd(paramStr, "toolTipNum", string(nTooltipString));
    CallGFxFunction("noticeWnd", string(nType), paramStr);
    return;
}

function removeNoticeButton(int nType)
{
    local string paramStr;

    // End:0x3C
    if(IsShowWindow())
    {
        ParamAdd(paramStr, "type", string(nType));
        CallGFxFunction("noticeWnd", "900", paramStr);
    }
    return;
}

function removeALLNoticeButton()
{
    // End:0x22
    if(IsShowWindow())
    {
        CallGFxFunction("noticeWnd", "1000", "");
    }
    return;
}

function hideNoticeButton_QUEST()
{
    removeNoticeButton(1);
    return;
}

function hideNoticeButton_PVPBLOCKCHECKER()
{
    removeNoticeButton(13);
    return;
}

function hideNoticeButton_PVPCRATAECUBE()
{
    removeNoticeButton(14);
    return;
}

function hideNoticeButton_PVPMATCHRECORD()
{
    removeNoticeButton(15);
    return;
}

function hideNoticeButton_PVPCLEFT()
{
    removeNoticeButton(16);
    return;
}

function hideNoticeButton_CAMPAIGN()
{
    removeNoticeButton(5);
    return;
}

function hideNoticeButton_ZONE()
{
    removeNoticeButton(6);
    return;
}

function handleChangedSubjob(string param)
{
    local bool tmpIsPrologueGrowTypeState;
    local EventInfoWnd script;
    local UserInfo Info;

    tmpIsPrologueGrowTypeState = getisPrologueGrowTypeState(param);
    // End:0xC2
    if(tmpIsPrologueGrowTypeState != isPrologueGrowTypeState)
    {
        isPrologueGrowTypeState = tmpIsPrologueGrowTypeState;
        // End:0xC2
        if(!isPrologueGrowTypeState)
        {
            script = EventInfoWnd(GetScript("EventInfoWnd"));
            // End:0x72
            if(script.hasNoticeIcon)
            {
                EventInfoArrived();
            }
            // End:0x9D
            if(GetPlayerInfo(Info))
            {
                // End:0x9D
                if(Info.nClanID <= 0)
                {
                    createNoticeButton(10, 3068);
                }
            }
            // End:0xB3
            if(bUseL2Button())
            {
                createNoticeButton(29, 3634);
            }
            // End:0xC2
            if(isGetPremium)
            {
                PremiumItemAlarm();
            }
        }
    }
    return;
}

function bool getisPrologueGrowTypeState(string param)
{
    local int currentClassID;

    // End:0x32
    if(param != "")
    {
        ParseInt(param, "CurrentSubjobClassID", currentClassID);
    }
    return getInstanceL2Util().getIsPrologueGrowType(currentClassID);
    return;
}

function bool checkIisPrologueGrowType(int nType)
{
    // End:0x39
    if(isPrologueGrowTypeState)
    {
        switch(nType)
        {
            // End:0x1D
            case 2:
                isGetPremium = true;
            // End:0x22
            case 3:
            // End:0x27
            case 10:
            // End:0x2C
            case 28:
            // End:0x33
            case 29:
                return true;
            // End:0xFFFF
            default:
                // End:0x39
                break;
                break;
        }
    }
    return false;
    return;
}
