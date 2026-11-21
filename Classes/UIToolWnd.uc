class UIToolWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle transBtn;
var ButtonHandle debugBtn;
var ButtonHandle uiBtn;
var ButtonHandle reloaduiBtn;
var ButtonHandle evemsgBtn;
var ButtonHandle uioffBtn;
var ButtonHandle showWBtn;
var ButtonHandle skillBtn;
var ButtonHandle killBtn;
var ButtonHandle weightBtn;
var ButtonHandle diaBtn;
var EditBoxHandle HEdit0;
var EditBoxHandle HEdit;
var EditBoxHandle NEdit;
var ListCtrlHandle WindowListCtrl;
var array<string> arrWinList;
var UIEasyLoginWnd easyLoginScript;
var WindowHandle m_dialogWnd;

function OnLoad()
{
    SetClosingOnESC();
    OnRegisterEvent();
    Me = GetWindowHandle("UIToolWnd");
    transBtn = GetButtonHandle("UIToolWnd.Tab0.transBtn");
    debugBtn = GetButtonHandle("UIToolWnd.Tab0.debugBtn");
    uiBtn = GetButtonHandle("UIToolWnd.Tab0.uiBtn");
    reloaduiBtn = GetButtonHandle("UIToolWnd.Tab0.reloaduiBtn");
    evemsgBtn = GetButtonHandle("UIToolWnd.Tab0.evemsgBtn");
    uioffBtn = GetButtonHandle("UIToolWnd.Tab0.uioffBtn");
    showWBtn = GetButtonHandle("UIToolWnd.Tab0.showWBtn");
    skillBtn = GetButtonHandle("UIToolWnd.Tab0.skillBtn");
    killBtn = GetButtonHandle("UIToolWnd.Tab0.killBtn");
    weightBtn = GetButtonHandle("UIToolWnd.Tab0.weightBtn");
    diaBtn = GetButtonHandle("UIToolWnd.Tab0.diaBtn");
    HEdit0 = GetEditBoxHandle("UIToolWnd.Tab1.HEdit0");
    HEdit = GetEditBoxHandle("UIToolWnd.Tab1.HEdit");
    NEdit = GetEditBoxHandle("UIToolWnd.Tab2.NEdit");
    WindowListCtrl = GetListCtrlHandle("UIToolWnd.Tab2.WindowListCtrl");
    easyLoginScript = UIEasyLoginWnd(GetScript("UIEasyLoginWnd"));
    setArr();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1A
        case 17:
            dialogShowTest(a_Param);
            // End:0x1D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function dialogShowTest(string param)
{
    local int nSystemString, nSystemMessage, nHtml, nWidth, nHeight;

    local string dialogStr, customIconTexture;

    ParseInt(param, "html", nHtml);
    ParseInt(param, "width", nWidth);
    ParseInt(param, "height", nHeight);
    ParseInt(param, "systemString", nSystemString);
    ParseInt(param, "systemMessage", nSystemMessage);
    ParseString(param, "string", dialogStr);
    ParseString(param, "customIconTexture", customIconTexture);
    DialogHide();
    DialogSetID(34567891);
    // End:0x108
    if(dialogStr == "")
    {
        dialogStr = GetSystemMessage(nSystemMessage);
        // End:0x108
        if(dialogStr == "")
        {
            dialogStr = GetSystemString(nSystemString);
        }
    }
    // End:0x11E
    if(nWidth == 0)
    {
        nWidth = 319;
    }
    // End:0x131
    if(nHeight == 0)
    {
        nHeight = 143;
    }
    DialogShow(1, 4, dialogStr, string(self), nWidth, nHeight, numToBool(nHtml), customIconTexture);
    return;
}

function OnHide()
{
    SetINIString("UIToolWnd", "nEdit", NEdit.GetString(), "UIDEV.ini");
    return;
}

function OnShow()
{
    local string stringValue;

    stringValue = "";
    GetINIString("UIToolWnd", "nEdit", stringValue, "UIDEV.ini");
    NEdit.SetString(stringValue);
    // End:0x91
    if(easyLoginScript.getUseEasyLogin())
    {
        GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EasyLogin On");        
    }
    else
    {
        GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EasyLogin Off");
    }
    return;
}

function OnClickButton(string a_ButtonID)
{
    local UIDebugWnd util;
    local bool bFlag;

    util = UIDebugWnd(GetScript("UIDebugWnd"));
    switch(a_ButtonID)
    {
        // End:0x39
        case "initBtn":
            initButtonClick();
            // End:0x5F0
            break;
        // End:0xBB
        case "transBtn":
            // End:0x8F
            if(transBtn.GetButtonName() == "HideOff")
            {
                ExecuteCommand("//hide off");
                transBtn.SetNameText("HideOn");                
            }
            else
            {
                ExecuteCommand("//hide on");
                transBtn.SetNameText("HideOff");
            }
            // End:0x5F0
            break;
        // End:0xDD
        case "debugBtn":
            ExecuteCommand("///uidebug");
            // End:0x5F0
            break;
        // End:0xF7
        case "uiBtn":
            ExecuteCommand("///ui");
            // End:0x5F0
            break;
        // End:0x11D
        case "reloaduiBtn":
            ExecuteCommand("///reloadui");
            // End:0x5F0
            break;
        // End:0x192
        case "evemsgBtn":
            // End:0x164
            if(evemsgBtn.GetButtonName() == "EvMsgON")
            {
                evemsgBtn.SetNameText("EvMsgOFF");                
            }
            else
            {
                evemsgBtn.SetNameText("EvMsgON");
            }
            ExecuteCommand("///eventmsg");
            // End:0x5F0
            break;
        // End:0x1BC
        case "showWBtn":
            ExecuteCommand("///show windowname");
            // End:0x5F0
            break;
        // End:0x1E5
        case "skillBtn":
            ExecuteCommand("//setskill 7029 3");
            // End:0x5F0
            break;
        // End:0x202
        case "killBtn":
            ExecuteCommand("//죽어");
            // End:0x5F0
            break;
        // End:0x28A
        case "weightBtn":
            // End:0x25C
            if(weightBtn.GetButtonName() == "WeightOFF")
            {
                ExecuteCommand("//무게 켬");
                weightBtn.SetNameText("WeightON");                
            }
            else
            {
                ExecuteCommand("//무게 끔");
                weightBtn.SetNameText("WeightOFF");
            }
            // End:0x5F0
            break;
        // End:0x2A6
        case "gfxBtn":
            ExecuteCommand("///gfx");
            // End:0x5F0
            break;
        // End:0x2CB
        case "delgfxBtn":
            ExecuteCommand("///delgfxall");
            // End:0x5F0
            break;
        // End:0x2E0
        case "loadBtn":
            loadButtonClick();
            // End:0x5F0
            break;
        // End:0x2F5
        case "htmlBtn":
            htmlButtonClick();
            // End:0x5F0
            break;
        // End:0x309
        case "winBtn":
            winButtonClick();
            // End:0x5F0
            break;
        // End:0x332
        case "shoWBBtn":
            ExecuteCommand("///show windowbox");
            // End:0x5F0
            break;
        // End:0x350
        case "allBtn":
            ExecuteCommand("//올스킬");
            // End:0x5F0
            break;
        // End:0x364
        case "evnBtn":
            MakeEventBuff2();
            // End:0x5F0
            break;
        // End:0x38B
        case "PowerTool":
            LoadWindowClick("UIPowerToolWnd");
            // End:0x5F0
            break;
        // End:0x3A9
        case "UITrace":
            util.ShowWindow();
            // End:0x5F0
            break;
        // End:0x3D6
        case "ServerHtml":
            LoadWindowClick("UIServerHtmlToolWnd");
            // End:0x5F0
            break;
        // End:0x3FB
        case "HtmlTool":
            LoadWindowClick("UIHtmlToolWnd");
            // End:0x5F0
            break;
        // End:0x422
        case "QuestTool":
            LoadWindowClick("UIQuestToolWnd");
            // End:0x5F0
            break;
        // End:0x447
        case "ItemTool":
            LoadWindowClick("UIItemToolWnd");
            // End:0x5F0
            break;
        // End:0x47D
        case "GFXTester":
            CallGFxFunction("containerHUD", "showDebugTool", "");
            // End:0x5F0
            break;
        // End:0x4A0
        case "ShowUI":
            LoadWindowClick("UIOpenToolWnd");
            // End:0x5F0
            break;
        // End:0x4BA
        case "GfxDebug":
            ExecuteEvent(18, "");
            // End:0x5F0
            break;
        // End:0x575
        case "EasyLogin":
            bFlag = easyLoginScript.getUseEasyLogin();
            // End:0x523
            if(bFlag)
            {
                GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EasyLogin Off");                
            }
            else
            {
                GetButtonHandle("UIToolWnd.Tab0.EasyLogin").SetNameText("EasyLogin On");
            }
            easyLoginScript.setUseEasyLogin(!bFlag);
            // End:0x5F0
            break;
        // End:0x59E
        case "GammaOff":
            SetOptionFloat("Video", "Gamma", 0.0000000);
            // End:0x5F0
            break;
        // End:0x5BF
        case "JobTree":
            ShowWindow("JobTreeWnd");
            // End:0x5F0
            break;
        // End:0x5ED
        case "mapSearchButton":
            toggleWindow("UISearchMapWnd", true);
            // End:0x5F0
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function LoadWindowClick(string WindowName)
{
    local WindowHandle NewWindow;

    NewWindow = GetWindowHandle(WindowName);
    NewWindow.ShowWindow();
    NewWindow.SetFocus();
    return;
}

function initButtonClick()
{
    ExecuteCommand("//투명 끔");
    ExecuteCommand("//무적 on");
    ExecuteCommand("//속도 5");
    ExecuteCommand("///uidebug");
    ExecuteCommand("///autocom");
    return;
}

function loadButtonClick()
{
    local string Str;
    local array<string> arrStr;

    Str = HEdit0.GetString();
    Split(Str, ".", arrStr);
    // End:0x53
    if(arrStr[1] != "")
    {
        ExecuteCommand("//loadhtml " $ Str);        
    }
    else
    {
        ExecuteCommand(("//loadhtml " $ Str) $ ".htm");
    }
    return;
}

function htmlButtonClick()
{
    local ItemDescWnd script;
    local string Str;
    local array<string> arrStr;

    Str = HEdit.GetString();
    Split(Str, ".", arrStr);
    script = ItemDescWnd(GetScript("ItemDescWnd"));
    // End:0x79
    if(arrStr[1] != "")
    {
        script.ShowHelp("..\\L2text\\" $ Str);        
    }
    else
    {
        script.ShowHelp(("..\\L2text\\" $ Str) $ ".htm");
    }
    return;
}

function winButtonClick()
{
    local WindowHandle NewWindow;
    local string Str;

    Str = NEdit.GetString();
    // End:0x5A
    if(Str != "")
    {
        NewWindow = GetWindowHandle(NEdit.GetString());
        NewWindow.ShowWindow();
        NewWindow.SetFocus();
    }
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    local LVDataRecord Record;

    switch(ListCtrlID)
    {
        // End:0x62
        case "WindowListCtrl":
            WindowListCtrl.GetSelectedRec(Record);
            Class'NWindow.UIAPI_EDITBOX'.static.SetString("UIToolWnd.NEdit", Record.LVDataList[0].szData);
            // End:0x65
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    local LVDataRecord Record;
    local WindowHandle NewWindow;

    switch(ListCtrlID)
    {
        // End:0x6C
        case "WindowListCtrl":
            WindowListCtrl.GetSelectedRec(Record);
            NewWindow = GetWindowHandle(Record.LVDataList[0].szData);
            NewWindow.ShowWindow();
            NewWindow.SetFocus();
            // End:0x6F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function MakeWindowList()
{
    local LVDataRecord Record;
    local int i;

    i = 0;
    J0x07:

    // End:0x79 [Loop If]
    if(i < arrWinList.Length)
    {
        Record.LVDataList.Length = 1;
        Record.LVDataList[0].szData = arrWinList[i];
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("UIToolWnd.WindowListCtrl", Record);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function MakeEventBuff2()
{
    local string strParam;
    local int i;

    ParamAdd(strParam, "ServerID", string(1229005689));
    ParamAdd(strParam, "Max", string(70));
    i = 0;
    J0x37:

    // End:0x158 [Loop If]
    if(i < 36)
    {
        ParamAdd(strParam, "ClassID_" $ string(i), string(11259));
        ParamAdd(strParam, "SkillLevel_" $ string(i), string(4));
        ParamAdd(strParam, "RemainTime_" $ string(i), string(13));
        ParamAdd(strParam, "Name_" $ string(i), "쇠약의 낙인");
        ParamAdd(strParam, "IconName_" $ string(i), "icon.skill1263");
        ParamAdd(strParam, "Description_" $ string(i), "테스트용으로 마구 찍는 디버프ㅋㅋ");
        i++;
        // [Loop Continue]
        goto J0x37;
    }
    i = 36;
    J0x160:

    // End:0x27C [Loop If]
    if(i < 70)
    {
        ParamAdd(strParam, "ClassID_" $ string(i), string(1040));
        ParamAdd(strParam, "SkillLevel_" $ string(i), string(1));
        ParamAdd(strParam, "RemainTime_" $ string(i), string(942));
        ParamAdd(strParam, "Name_" $ string(i), "실드");
        ParamAdd(strParam, "IconName_" $ string(i), "icon.skill1040");
        ParamAdd(strParam, "Description_" $ string(i), "테스트용으로 마구 찍는 디버프ㅋㅋ");
        i++;
        // [Loop Continue]
        goto J0x160;
    }
    ExecuteEvent(950, strParam);
    return;
}

function MakeEventBuff()
{
    local string strParam;
    local int i;
    local TargetStatusWnd script;

    script = TargetStatusWnd(GetScript("TargetStatusWnd"));
    script.HandleSkillCancel();
    ParamAdd(strParam, "TargetID", string(100));
    ParamAdd(strParam, "Max", string(40));
    i = 0;
    J0x65:

    // End:0xFA [Loop If]
    if(i < 10)
    {
        ParamAdd(strParam, "Level_" $ string(i), string(1));
        ParamAdd(strParam, "Sec_" $ string(i), string(100));
        ParamAdd(strParam, "Count_" $ string(i), string(1));
        ParamAdd(strParam, "OwnerShip_" $ string(i), string(1));
        i++;
        // [Loop Continue]
        goto J0x65;
    }
    ParamAdd(strParam, "ClassID_0", string(92));
    ParamAdd(strParam, "ClassID_1", string(101));
    ParamAdd(strParam, "ClassID_2", string(102));
    ParamAdd(strParam, "ClassID_3", string(105));
    ParamAdd(strParam, "ClassID_4", string(115));
    ParamAdd(strParam, "ClassID_5", string(129));
    ParamAdd(strParam, "ClassID_6", string(1069));
    ParamAdd(strParam, "ClassID_7", string(1083));
    ParamAdd(strParam, "ClassID_8", string(1160));
    ParamAdd(strParam, "ClassID_9", string(1164));
    i = 10;
    J0x212:

    // End:0x2A7 [Loop If]
    if(i < 20)
    {
        ParamAdd(strParam, "Level_" $ string(i), string(1));
        ParamAdd(strParam, "Sec_" $ string(i), string(100));
        ParamAdd(strParam, "Count_" $ string(i), string(1));
        ParamAdd(strParam, "OwnerShip_" $ string(i), string(0));
        i++;
        // [Loop Continue]
        goto J0x212;
    }
    ParamAdd(strParam, "ClassID_10", string(92));
    ParamAdd(strParam, "ClassID_11", string(101));
    ParamAdd(strParam, "ClassID_12", string(102));
    ParamAdd(strParam, "ClassID_13", string(105));
    ParamAdd(strParam, "ClassID_14", string(115));
    ParamAdd(strParam, "ClassID_15", string(129));
    ParamAdd(strParam, "ClassID_16", string(1069));
    ParamAdd(strParam, "ClassID_17", string(1083));
    ParamAdd(strParam, "ClassID_18", string(1160));
    ParamAdd(strParam, "ClassID_19", string(1164));
    i = 20;
    J0x3C9:

    // End:0x45E [Loop If]
    if(i < 30)
    {
        ParamAdd(strParam, "Level_" $ string(i), string(1));
        ParamAdd(strParam, "Sec_" $ string(i), string(10));
        ParamAdd(strParam, "Count_" $ string(i), string(1));
        ParamAdd(strParam, "OwnerShip_" $ string(i), string(1));
        i++;
        // [Loop Continue]
        goto J0x3C9;
    }
    ParamAdd(strParam, "ClassID_20", string(77));
    ParamAdd(strParam, "ClassID_21", string(78));
    ParamAdd(strParam, "ClassID_22", string(82));
    ParamAdd(strParam, "ClassID_23", string(91));
    ParamAdd(strParam, "ClassID_24", string(99));
    ParamAdd(strParam, "ClassID_25", string(112));
    ParamAdd(strParam, "ClassID_26", string(113));
    ParamAdd(strParam, "ClassID_27", string(118));
    ParamAdd(strParam, "ClassID_28", string(121));
    ParamAdd(strParam, "ClassID_29", string(137));
    i = 30;
    J0x574:

    // End:0x609 [Loop If]
    if(i < 40)
    {
        ParamAdd(strParam, "Level_" $ string(i), string(1));
        ParamAdd(strParam, "Sec_" $ string(i), string(10));
        ParamAdd(strParam, "Count_" $ string(i), string(1));
        ParamAdd(strParam, "OwnerShip_" $ string(i), string(0));
        i++;
        // [Loop Continue]
        goto J0x574;
    }
    ParamAdd(strParam, "ClassID_30", string(77));
    ParamAdd(strParam, "ClassID_31", string(78));
    ParamAdd(strParam, "ClassID_32", string(82));
    ParamAdd(strParam, "ClassID_33", string(91));
    ParamAdd(strParam, "ClassID_34", string(99));
    ParamAdd(strParam, "ClassID_35", string(112));
    ParamAdd(strParam, "ClassID_36", string(113));
    ParamAdd(strParam, "ClassID_37", string(118));
    ParamAdd(strParam, "ClassID_38", string(121));
    ParamAdd(strParam, "ClassID_39", string(137));
    ExecuteEvent(5120, strParam);
    return;
}

function setArr()
{
    local int Index;

    Index = 0;
    arrWinList[Index++] = "AbnormalStatusWnd";
    arrWinList[Index++] = "ActionWnd";
    arrWinList[Index++] = "AgeWnd";
    arrWinList[Index++] = "AITimerWnd";
    arrWinList[Index++] = "AttributeEnchantWnd";
    arrWinList[Index++] = "AttributeRemoveWnd";
    arrWinList[Index++] = "AuctionNextWnd";
    arrWinList[Index++] = "AuctionWnd";
    arrWinList[Index++] = "BenchMarkMenuWnd";
    arrWinList[Index++] = "BirthdayAlarmBtn";
    arrWinList[Index++] = "BirthdayAlarmWnd";
    arrWinList[Index++] = "BlockCounter";
    arrWinList[Index++] = "BlockCurTriggerWnd";
    arrWinList[Index++] = "BlockCurWnd";
    arrWinList[Index++] = "BlockEnterWnd";
    arrWinList[Index++] = "BoardWnd";
    arrWinList[Index++] = "CalculatorWnd";
    arrWinList[Index++] = "CharacterCreateMenuWnd";
    arrWinList[Index++] = "ChatWnd";
    arrWinList[Index++] = "ClanDrawerWnd";
    arrWinList[Index++] = "ClanWnd";
    arrWinList[Index++] = "CleftCounter";
    arrWinList[Index++] = "CleftCurTriggerWnd";
    arrWinList[Index++] = "CleftCurWnd";
    arrWinList[Index++] = "CleftEnterWnd";
    arrWinList[Index++] = "ColorNickNameWnd";
    arrWinList[Index++] = "ConsoleWnd";
    arrWinList[Index++] = "CouponEventWnd";
    arrWinList[Index++] = "DeliverWnd";
    arrWinList[Index++] = "DepthOfField";
    arrWinList[Index++] = "DetailStatusWnd";
    arrWinList[Index++] = "DialogBox";
    arrWinList[Index++] = "DominionWarInfoWnd";
    arrWinList[Index++] = "DuelManager";
    arrWinList[Index++] = "EventMatchGMFenceWnd";
    arrWinList[Index++] = "EventMatchGMMsgWnd";
    arrWinList[Index++] = "EventMatchGMWnd";
    arrWinList[Index++] = "EventMatchObserverWnd";
    arrWinList[Index++] = "EventMatchSpecialMsgWnd";
    arrWinList[Index++] = "FileListWnd";
    arrWinList[Index++] = "FileRegisterWnd";
    arrWinList[Index++] = "FileWnd";
    arrWinList[Index++] = "FishViewportWnd";
    arrWinList[Index++] = "FlightShipCtrlWnd";
    arrWinList[Index++] = "FlightTeleportWnd";
    arrWinList[Index++] = "FlightTransformCtrlWnd";
    arrWinList[Index++] = "GametipWnd";
    arrWinList[Index++] = "GMClanWnd";
    arrWinList[Index++] = "GMDetailStatusWnd";
    arrWinList[Index++] = "GMFindTreeWnd";
    arrWinList[Index++] = "GMInventoryWnd";
    arrWinList[Index++] = "GMMagicSkillWnd";
    arrWinList[Index++] = "GMQuestWnd";
    arrWinList[Index++] = "GMSnoopWnd";
    arrWinList[Index++] = "GMWarehouseWnd";
    arrWinList[Index++] = "GMWnd";
    arrWinList[Index++] = "HelpWnd";
    arrWinList[Index++] = "HelpHtmlWnd";
    arrWinList[Index++] = "HennaInfoWnd";
    arrWinList[Index++] = "HennaListWnd";
    arrWinList[Index++] = "HeroTowerWnd";
    arrWinList[Index++] = "InventoryWnd";
    arrWinList[Index++] = "InviteClanPopWnd";
    arrWinList[Index++] = "ItemDescWnd";
    arrWinList[Index++] = "ItemEnchantWnd";
    arrWinList[Index++] = "KillpointCounterWnd";
    arrWinList[Index++] = "KillpointRankTrigger";
    arrWinList[Index++] = "KillPointRankWnd";
    arrWinList[Index++] = "LoadingAniWnd";
    arrWinList[Index++] = "LoadingWnd";
    arrWinList[Index++] = "LoadingWnd_cn";
    arrWinList[Index++] = "LoadingWnd_e";
    arrWinList[Index++] = "LoadingWnd_j";
    arrWinList[Index++] = "LoadingWnd_k";
    arrWinList[Index++] = "LoadingWnd_ph";
    arrWinList[Index++] = "LoadingWnd_th";
    arrWinList[Index++] = "LoadingWnd_tw";
    arrWinList[Index++] = "LobbyMenuWnd";
    arrWinList[Index++] = "LoginMenuWnd";
    arrWinList[Index++] = "MacroEditWnd";
    arrWinList[Index++] = "MacroListWnd";
    arrWinList[Index++] = "MagicSkillDrawerWnd";
    arrWinList[Index++] = "MagicskillGuideWnd";
    arrWinList[Index++] = "MagicSkillWnd";
    arrWinList[Index++] = "MailBtnWnd";
    arrWinList[Index++] = "ManorCropInfoChangeWnd";
    arrWinList[Index++] = "ManorCropInfoSettingWnd";
    arrWinList[Index++] = "ManorCropSellChangeWnd";
    arrWinList[Index++] = "ManorCropSellWnd";
    arrWinList[Index++] = "ManorInfoWnd";
    arrWinList[Index++] = "ManorSeedInfoChangeWnd";
    arrWinList[Index++] = "ManorSeedInfoSettingWnd";
    arrWinList[Index++] = "ManorShopWnd";
    arrWinList[Index++] = "MenuWnd";
    arrWinList[Index++] = "MiniGame1Wnd";
    arrWinList[Index++] = "MinimapWnd";
    arrWinList[Index++] = "MoviePlayerWnd";
    arrWinList[Index++] = "MSViewerWnd";
    arrWinList[Index++] = "MultiSellWnd";
    arrWinList[Index++] = "NewPetitionFeedBackResultWnd";
    arrWinList[Index++] = "NewPetitionFeedBackWnd";
    arrWinList[Index++] = "NewPetitionFeedBackWnd_2nd";
    arrWinList[Index++] = "NewPetitionWnd";
    arrWinList[Index++] = "NewUserPetitionDrawerWnd";
    arrWinList[Index++] = "NewUserPetitionWnd";
    arrWinList[Index++] = "NPCDialogWnd";
    arrWinList[Index++] = "ObserverWnd";
    arrWinList[Index++] = "OlympiadBuff1Wnd";
    arrWinList[Index++] = "OlympiadBuff2Wnd";
    arrWinList[Index++] = "OlympiadBuffWnd";
    arrWinList[Index++] = "OlympiadControlWnd";
    arrWinList[Index++] = "OlympiadGuideWnd";
    arrWinList[Index++] = "OlympiadPlayer1Wnd";
    arrWinList[Index++] = "OlympiadPlayer2Wnd";
    arrWinList[Index++] = "OlympiadPlayerWnd";
    arrWinList[Index++] = "OlympiadTargetWnd";
    arrWinList[Index++] = "OnScreenMessageWnd";
    arrWinList[Index++] = "OptionWnd";
    arrWinList[Index++] = "PartyMatchMakeRoomWnd";
    arrWinList[Index++] = "PartyMatchOutWaitListWnd";
    arrWinList[Index++] = "PartyMatchRoomWnd";
    arrWinList[Index++] = "PartyMatchWaitListWnd";
    arrWinList[Index++] = "PartyMatchWnd";
    arrWinList[Index++] = "PartyMatchWndCommon";
    arrWinList[Index++] = "PartyWnd";
    arrWinList[Index++] = "PartyWndCompact";
    arrWinList[Index++] = "PartyWndOption";
    arrWinList[Index++] = "InfoWnd";
    arrWinList[Index++] = "PetitionFeedBackWnd";
    arrWinList[Index++] = "PetitionWnd";
    arrWinList[Index++] = "PetStatusWnd";
    arrWinList[Index++] = "PetWnd";
    arrWinList[Index++] = "PostBoxWnd";
    arrWinList[Index++] = "PostDetailWnd_General";
    arrWinList[Index++] = "PostDetailWnd_SafetyTrade";
    arrWinList[Index++] = "PostEffectTestWnd";
    arrWinList[Index++] = "PostReceiverListAddWnd";
    arrWinList[Index++] = "PostReceiverListWnd";
    arrWinList[Index++] = "PostWriteWnd";
    arrWinList[Index++] = "PremiumItemAlarmWnd";
    arrWinList[Index++] = "PremiumItemGetWnd";
    arrWinList[Index++] = "PrivateMarketWnd";
    arrWinList[Index++] = "PrivateShopWnd";
    arrWinList[Index++] = "ProgressBox";
    arrWinList[Index++] = "PVPCounter";
    arrWinList[Index++] = "PVPCounterTrigger";
    arrWinList[Index++] = "PVPDetailedWnd";
    arrWinList[Index++] = "QuestAlarmWnd";
    arrWinList[Index++] = "QuestBtnWnd";
    arrWinList[Index++] = "QuestHTMLWnd";
    arrWinList[Index++] = "QuestListWnd";
    arrWinList[Index++] = "QuestTreeDrawerWnd";
    arrWinList[Index++] = "QuestTreeWnd";
    arrWinList[Index++] = "RadarMapWnd";
    arrWinList[Index++] = "RadarOptionWnd";
    arrWinList[Index++] = "RecipeBookWnd";
    arrWinList[Index++] = "RecipeBuyListWnd";
    arrWinList[Index++] = "RecipeBuyManufactureWnd";
    arrWinList[Index++] = "RecipeManufactureWnd";
    arrWinList[Index++] = "RecipeShopWnd";
    arrWinList[Index++] = "RecipeTreeWnd";
    arrWinList[Index++] = "RecommendBonusHelpHtmlWnd";
    arrWinList[Index++] = "RecommendBonusWnd";
    arrWinList[Index++] = "RefineryWnd";
    arrWinList[Index++] = "ReplayListWnd";
    arrWinList[Index++] = "ReplayLogoWnd";
    arrWinList[Index++] = "ReplayLogoWnd_cn";
    arrWinList[Index++] = "ReplayLogoWnd_e";
    arrWinList[Index++] = "ReplayLogoWnd_j";
    arrWinList[Index++] = "ReplayLogoWnd_k";
    arrWinList[Index++] = "ReplayLogoWnd_ph";
    arrWinList[Index++] = "ReplayLogoWnd_th";
    arrWinList[Index++] = "ReplayLogoWnd_tw";
    arrWinList[Index++] = "RestartMenuWnd";
    arrWinList[Index++] = "SceneEditorDrawerWnd";
    arrWinList[Index++] = "SceneEditorSlideWnd";
    arrWinList[Index++] = "SceneEditorWnd";
    arrWinList[Index++] = "SeedShopWnd";
    arrWinList[Index++] = "SelectDeliverWnd";
    arrWinList[Index++] = "ShaderBuild";
    arrWinList[Index++] = "ShopWnd";
    arrWinList[Index++] = "Shortcut";
    arrWinList[Index++] = "ShortcutAssignWnd";
    arrWinList[Index++] = "ShortcutWnd";
    arrWinList[Index++] = "SiegeInfoWnd";
    arrWinList[Index++] = "SkillEnchantInfoWnd";
    arrWinList[Index++] = "SkillEnchantWnd";
    arrWinList[Index++] = "SkillTrainClanTreeWnd";
    arrWinList[Index++] = "SkillTrainInfoWnd";
    arrWinList[Index++] = "SkillTrainListWnd";
    arrWinList[Index++] = "SSAOWnd";
    arrWinList[Index++] = "SSQMainBoard";
    arrWinList[Index++] = "StatusWnd";
    arrWinList[Index++] = "SummonedStatusWnd";
    arrWinList[Index++] = "SummonedWnd";
    arrWinList[Index++] = "SystemMsgWnd";
    arrWinList[Index++] = "TargetStatusWnd";
    arrWinList[Index++] = "TeleportBookMarkDrawerWnd";
    arrWinList[Index++] = "TeleportBookMarkWnd";
    arrWinList[Index++] = "Tooltip";
    arrWinList[Index++] = "TownMapWnd";
    arrWinList[Index++] = "TradeWnd";
    arrWinList[Index++] = "TutorialBtnWnd";
    arrWinList[Index++] = "TutorialViewerWnd";
    arrWinList[Index++] = "UICommonAPI";
    arrWinList[Index++] = "UIDevWnd";
    arrWinList[Index++] = "UIEditor_ControlManager";
    arrWinList[Index++] = "UIEditor_DocumentInfo";
    arrWinList[Index++] = "UIEditor_FileManager";
    arrWinList[Index++] = "UIEditor_PropertyController";
    arrWinList[Index++] = "UIEditor_Worksheet";
    arrWinList[Index++] = "UITestWnd";
    arrWinList[Index++] = "UIToolWnd";
    arrWinList[Index++] = "UnionDetailWnd";
    arrWinList[Index++] = "UnionMatchDrawerWnd";
    arrWinList[Index++] = "UnionMatchMakeRoomWnd";
    arrWinList[Index++] = "UnionMatchWnd";
    arrWinList[Index++] = "UnionWnd";
    arrWinList[Index++] = "UnrefineryWnd";
    arrWinList[Index++] = "UserPetitionWnd";
    arrWinList[Index++] = "WarehouseWnd";
    arrWinList[Index++] = "WeatherWnd";
    arrWinList[Index++] = "XMasSealWnd";
    arrWinList[Index++] = "ZoneTitleWnd";
    arrWinList[Index++] = "PersonalConnectionsWnd";
    arrWinList[Index++] = "CharacterPasswordWnd";
    arrWinList[Index++] = "SellingAgencyWnd";
    arrWinList[Index++] = "AttendCheckWnd";
    arrWinList[Index++] = "EnsoulWnd";
    arrWinList[Index++] = "AgitDecoWnd";
    arrWinList[Index++] = "MacroPresetWnd";
    arrWinList[Index++] = "ClanGfxWnd";
    MakeWindowList();
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
    m_WindowName="UIToolWnd"
}