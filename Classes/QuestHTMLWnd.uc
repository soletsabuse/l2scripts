class QuestHTMLWnd extends UICommonAPI;

const HTML_WIDTH = 400;
const TABLEBG_WIDTH = 272;

var WindowHandle Me;
var HtmlHandle m_hHtmlViewer;
var bool m_bDrawBg;
var bool m_bPressCloseButton;
var bool m_bReShowWndMode;
var bool m_bReShowQuestHtmlWnd;
var string HtmlString;
var int htmlWidth;
var int bicIconLen;

function OnRegisterEvent()
{
    RegisterEvent(3323);
    RegisterEvent(3324);
    RegisterEvent(3322);
    RegisterEvent(3321);
    RegisterEvent(150);
    RegisterEvent(160);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    OnRegisterEvent();
    Me = GetWindowHandle("QuestHTMLWnd");
    m_hHtmlViewer = GetHtmlHandle("QuestHTMLWnd.HtmlViewer");
    return;
}

function OnShow()
{
    getInstanceL2Util().syncWindowLoc(getCurrentWindowName(string(self)), "QuestHTMLWnd,NPCDialogWnd");
    return;
}

function OnHide()
{
    ProcCloseQuestHTMLWnd();
    getInstanceL2Util().syncWindowLocAuto("QuestHTMLWnd,NPCDialogWnd");
    return;
}

function OnDefaultPosition()
{
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x18
        case 3323:
            ShowQuestHTMLWnd();
            // End:0x8E
            break;
        // End:0x29
        case 3324:
            HideQuestHTMLWnd();
            // End:0x8E
            break;
        // End:0x59
        case 3322:
            Me.SetWindowTitle(GetSystemString(444));
            HandleLoadHtmlFromString(param);
            // End:0x8E
            break;
        // End:0x6F
        case 3321:
            HandleQuestIDLoadHtmlFromString(param);
            // End:0x8E
            break;
        // End:0x8B
        case 19:
            m_hHtmlViewer.LoadHtmlFromString(param);
            // End:0x8E
            break;
        // End:0xFFFF
        default:
            break;
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

function HandleQuestIDLoadHtmlFromString(string param)
{
    local int questID;
    local array<int> rewardIDList;
    local array<INT64> rewardNumList;
    local int i;
    local string addItemHtml, IconName, itemText, ItemName, rewardSmallIconHtml, rewardMsgHtml,
	    rewardEndMsgHtml;

    local int tableIndex, smallIconIndex;

    ParseInt(param, "QuestID", questID);
    Class'NWindow.UIDATA_QUEST'.static.GetQuestReward(questID, 1, rewardIDList, rewardNumList);
    tableIndex = 0;
    smallIconIndex = 0;
    bicIconLen = 0;
    rewardSmallIconHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
    i = 0;
    J0xC9:

    // End:0x141 [Loop If]
    if(i < rewardIDList.Length)
    {
        // End:0x137
        if((((rewardIDList[i] != 57) && rewardIDList[i] != 15623) && rewardIDList[i] != 15624) && rewardIDList[i] != 47130)
        {
            bicIconLen++;
        }
        i++;
        // [Loop Continue]
        goto J0xC9;
    }
    // End:0x1C4
    if(bicIconLen == 1)
    {
        rewardMsgHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";        
    }
    else
    {
        rewardMsgHtml = "<table width=278 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Center>";
    }
    // End:0xF5A
    if(rewardIDList.Length > 0)
    {
        i = 0;
        J0x24C:

        // End:0xD2D [Loop If]
        if(i < rewardIDList.Length)
        {
            // End:0x2F5
            if(i == 0)
            {
                addItemHtml = (((("<br>" $ (htmlTableAdd("L2UI_CT1.GroupBox.GroupBox_DF"))) $ "<font color=\"ffcc00\" name=chatFontSize10>") $ GetSystemString(2006)) $ "</font>") $ "</td></tr></table>";
            }
            switch(rewardIDList[i])
            {
                // End:0x307
                case 57:
                // End:0x30F
                case 15623:
                // End:0x317
                case 15624:
                // End:0x5A3
                case 47130:
                    ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));
                    // End:0x391
                    if(rewardIDList[i] == 57)
                    {
                        IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_adena";
                        ItemName = GetSystemString(469);                        
                    }
                    else
                    {
                        // End:0x3D9
                        if(rewardIDList[i] == 15623)
                        {
                            // End:0x3B2
                            if((getLanguageNumber()) == 1)
                            {
                            }
                            IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_EXP";                            
                        }
                        else
                        {
                            // End:0x414
                            if(rewardIDList[i] == 15624)
                            {
                                IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_SP";                                
                            }
                            else
                            {
                                // End:0x44C
                                if(rewardIDList[i] == 47130)
                                {
                                    IconName = "L2UI_CT1.HtmlWnd.HTMLWnd_FP";
                                }
                            }
                        }
                    }
                    // End:0x474
                    if(__NFUN_412__(rewardNumList[i], (0)))
                    {
                        itemText = GetSystemString(584);                        
                    }
                    else
                    {
                        // End:0x4A5
                        if(rewardIDList[i] == 15624)
                        {
                            itemText = MakeCostString((rewardNumList[i]));                            
                        }
                        else
                        {
                            itemText = MakeCostString((rewardNumList[i]));
                        }
                    }
                    rewardSmallIconHtml = ((((((((rewardSmallIconHtml $ "<tr><td width=38 height=22 align=center valign=center><Img width=32 height=16") $ " src=\"") $ IconName) $ "\"") $ "></td><td height=22 width=236><font color=ba8860>") $ itemText) $ "</font>") @ (htmlfontAdd(ItemName))) $ "</td></tr>";
                    smallIconIndex = smallIconIndex + 1;
                    // End:0xD23
                    break;
                // End:0xFFFF
                default:
                    IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(rewardIDList[i]));
                    ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));
                    // End:0x628
                    if(__NFUN_412__(rewardNumList[i], (0)))
                    {
                        itemText = htmlfontAdd(GetSystemString(584), "ba8860");                        
                    }
                    else
                    {
                        // End:0x74D
                        if(((((((((((rewardIDList[i] == 15623) || rewardIDList[i] == 15624) || rewardIDList[i] == 15625) || rewardIDList[i] == 15626) || rewardIDList[i] == 15627) || rewardIDList[i] == 15628) || rewardIDList[i] == 15629) || rewardIDList[i] == 15630) || rewardIDList[i] == 15631) || rewardIDList[i] == 15632) || rewardIDList[i] == 15633)
                        {
                            itemText = htmlfontAdd(MakeCostString((rewardNumList[i])), "ba8860");                            
                        }
                        else
                        {
                            itemText = MakeFullSystemMsg(htmlfontAdd(GetSystemMessage(1983)), htmlfontAdd(MakeCostString((rewardNumList[i])), "ba8860"), "");
                        }
                    }
                    // End:0xBA8
                    if((getLanguageNumber()) == 0)
                    {
                        // End:0x8FD
                        if(bicIconLen == 1)
                        {
                            rewardMsgHtml = (((((((((((((((((rewardMsgHtml $ "<tr>") $ "<td width=2 height=32></td><td align=center valign=center width=32 height=32><button width=32 height=32") $ " itemtooltip=\"") $ string(rewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=1 height=32></td><td width=234 height=32>") $ (htmlfontAdd(ItemName))) $ "<br1>") $ itemText) $ "</td></tr>";                            
                        }
                        else
                        {
                            // End:0x92F
                            if((rewardIDList.Length > 0) && Len(ItemName) > 8)
                            {
                                ItemName = Mid(ItemName, 0, 8) $ "..";
                            }
                            // End:0xA81
                            if((float(tableIndex) % float(2)) > float(0))
                            {
                                rewardMsgHtml = Mid(rewardMsgHtml, 0, Len(rewardMsgHtml) - 5);
                                rewardMsgHtml = (((((((((((((((((rewardMsgHtml $ "<td align=center valign=center width=32 height=32><button width=32 height=32") $ " itemtooltip=\"") $ string(rewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></td><td width=110 height=32></button>") $ (htmlfontAdd(ItemName))) $ "<br1>") $ itemText) $ "<br1>") $ "</td></tr>";                                
                            }
                            else
                            {
                                rewardMsgHtml = (((((((((((((((((rewardMsgHtml $ (htmlTableTrAdd())) $ "<tr><td align=center valign=center width=32 height=32><button width=32 height=32") $ " itemtooltip=\"") $ string(rewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=110 height=32>") $ (htmlfontAdd(ItemName))) $ "<br1>") $ itemText) $ "</td></tr>";
                            }
                        }                        
                    }
                    else
                    {
                        ItemName = makeShortStringByPixel(ItemName, 230, "..");
                        rewardMsgHtml = (((((((((((((((((rewardMsgHtml $ "<tr>") $ "<td width=2 height=32></td><td align=center valign=center width=32 height=32><button width=32 height=32") $ " itemtooltip=\"") $ string(rewardIDList[i])) $ "\"") $ " back=\"") $ IconName) $ "\"") $ " high=\"") $ IconName) $ "\"") $ " fore=\"") $ IconName) $ "\"></button></td><td width=1 height=32></td><td width=234 height=32>") $ (htmlfontAdd(ItemName))) $ "<br1>") $ itemText) $ "</td></tr>";
                    }
                    tableIndex = tableIndex + 1;
                    break;
            }
            i++;
            // [Loop Continue]
            goto J0x24C;
        }
        // End:0xD52
        if(tableIndex > 0)
        {
            rewardMsgHtml = rewardMsgHtml $ "</table>";            
        }
        else
        {
            rewardMsgHtml = "";
        }
        // End:0xD7F
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
        // End:0xE5B
        if(bicIconLen == 1)
        {
            rewardEndMsgHtml = "<table width=277 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Down><tr><td width=277></td></tr></table>";            
        }
        else
        {
            rewardEndMsgHtml = "<table width=277 border=0 cellpadding=0 cellspacing=1 background=L2UI_CT1.HtmlWnd.HTMLWnd_GroupBox_DF_Down><tr><td width=277></td></tr></table>";
        }
        addItemHtml = (((HtmlString $ addItemHtml) $ rewardSmallIconHtml) $ rewardMsgHtml) $ rewardEndMsgHtml;
        addItemHtml = ("<html><body>" $ addItemHtml) $ "</body></html>";
        m_hHtmlViewer.LoadHtmlFromString(addItemHtml);
    }
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function string htmlTableAdd(optional string backgroundUrl)
{
    local string htmlStr;

    // End:0x63
    if(backgroundUrl == "")
    {
        htmlStr = "<table width=278 cellpadding=0 border=0 cellspacing=1" $ "><tr><td width=278>";        
    }
    else
    {
        htmlStr = ("<table width=278 cellpadding=0 border=0 cellspacing=1 background=" $ backgroundUrl) $ "><tr><td width=272>";
    }
    return htmlStr;
    return;
}

function string htmlTableTrAdd()
{
    return "<tr><td width=46 ></td><td width=115 ></td><td width=46 ></td><td width=115 ></td></tr>";
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

function OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
    // End:0x15
    if(a_HtmlHandle == m_hHtmlViewer)
    {
        HideQuestHTMLWnd();
    }
    return;
}

function HandleLoadHtmlFromString(string param)
{
    ParseString(param, "HTMLString", HtmlString);
    m_hHtmlViewer.LoadHtmlFromString(HtmlString);
    return;
}

function ShowQuestHTMLWnd()
{
    ExecuteEvent(3280);
    Me.ShowWindow();
    Me.SetFocus();
    m_bReShowQuestHtmlWnd = true;
    return;
}

function HideQuestHTMLWnd()
{
    Me.HideWindow();
    m_bReShowQuestHtmlWnd = false;
    return;
}

function OnClickButton(string Name)
{
    PressCloseButton();
    return;
}

function OnExitState(name a_NextStateName)
{
    // End:0x1D
    if(a_NextStateName == 'NpcZoomCameraState')
    {
        Clear();
        m_bReShowWndMode = true;
    }
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x1B
    if(a_PreStateName == 'NpcZoomCameraState')
    {
        ReShowQuestHTMLWnd();
        Clear();
    }
    return;
}

function Clear()
{
    m_bReShowWndMode = false;
    m_bPressCloseButton = false;
    m_bReShowQuestHtmlWnd = false;
    return;
}

function PressCloseButton()
{
    // End:0x11
    if(m_bReShowWndMode)
    {
        m_bPressCloseButton = true;
    }
    return;
}

function ProcCloseQuestHTMLWnd()
{
    // End:0x2D
    if((m_bPressCloseButton && m_bReShowWndMode) && m_bReShowQuestHtmlWnd)
    {
        m_bReShowWndMode = false;
        RequestFinishNPCZoomCamera();
    }
    return;
}

function ReShowQuestHTMLWnd()
{
    // End:0x1A
    if(m_bReShowWndMode && m_bReShowQuestHtmlWnd)
    {
        ShowQuestHTMLWnd();
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    PressCloseButton();
    GetWindowHandle("QuestHTMLWnd").HideWindow();
    return;
}
