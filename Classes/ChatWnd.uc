class ChatWnd extends UICommonAPI;

const CHAT_WINDOW_NORMAL = 0;
const CHAT_WINDOW_TRADE = 1;
const CHAT_WINDOW_PARTY = 2;
const CHAT_WINDOW_CLAN = 3;
const CHAT_WINDOW_ALLY = 4;
const CHAT_WINDOW_COUNT = 9;
const CHAT_WINDOW_SYSTEM = 9;
const CHAT_WINDOW_TAB_LEN = 5;
const DIALOGID_GoWeb = 1234510;
const CHAT_UNION_MAX = 35;

struct ChatFilterInfo
{
    var int bSystem;
    var int bChat;
    var int bDamage;
    var int bNormal;
    var int bShout;
    var int bClan;
    var int bParty;
    var int bTrade;
    var int bWhisper;
    var int bAlly;
    var int bUseitem;
    var int bHero;
    var int bUnion;
    var int bBattle;
    var int bNoNpcMessage;
    var int bWorldChat;
};

struct ChatUIType
{
    var int Id;
    var int UI;
};

var int m_bUseSystemMsgWnd;
var int m_bSystemMsgWnd;
var int m_bDamageOption;
var int m_bUseSystemItem;
var int m_NoNpcMessage;
var int m_bWorldChat;
var int m_bWorldChatSpeaker;
var int m_bOnlyUseSystemMsgWnd;
var int m_EditBoxHeight;
var int m_UseChatSymbol;
var int m_UseAlpha;
var int m_KeywordFilterSound;
var int m_KeywordFilterActivate;
var int m_ChatResizeOnOff;
var string m_Keyword0;
var string m_Keyword1;
var string m_Keyword2;
var string m_Keyword3;
var bool m_IsSplit0;
var bool m_IsSplit1;
var bool m_IsSplit2;
var bool m_IsSplit3;
var bool m_IsSplit4;
var array<ChatFilterInfo> m_filterInfo;
var array<string> m_sectionName;
var ChatUIType m_ChatUI[8];
var ChatUIType m_chatType;
var string URL;
var string Text;
var ChatWindowHandle NormalChat;
var ChatWindowHandle TradeChat;
var ChatWindowHandle PartyChat;
var ChatWindowHandle ClanChat;
var ChatWindowHandle AllyChat;
var ChatWindowHandle SystemMsg;
var WindowHandle TradeChatTabButton;
var WindowHandle PartyChatTabButton;
var WindowHandle ClanChatTabButton;
var WindowHandle AllyChatTabButton;
var WindowHandle UpScrollButton;
var WindowHandle DownScrollButton;
var WindowHandle SliderScrollButton;
var TabHandle ChatTabCtrl;
var EditBoxHandle ChatEditBox;
var WindowHandle m_hChatWnd;
var WindowHandle m_hSystemMsgWnd;
var WindowHandle m_hChatFontsizeWnd;
var TextureHandle m_hChatWndLanguageTexture;
var TextureHandle m_hChatWndBodyTex;
var TextureHandle m_hChatWndHeadTex;
var TextureHandle m_hChatWndBottomTex;
var TextureHandle m_hChatWndBottomTex2;
var TextureHandle m_hChatWndBottomTex3;
var TextureHandle m_hChatWndBottomTex4;
var TextureHandle m_hChatWndBottomTex5;
var ButtonHandle m_ChatFontOptionBtn;
var string lastClickChatTabName;
//var delegate<onTextComplete> __onTextComplete__Delegate;

function OnRegisterEvent()
{
    RegisterEvent(540);
    RegisterEvent(1500);
    RegisterEvent(550);
    RegisterEvent(560);
    RegisterEvent(570);
    RegisterEvent(572);
    RegisterEvent(3000);
    RegisterEvent(3010);
    RegisterEvent(150);
    RegisterEvent(160);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(555);
    RegisterEvent(2900);
    RegisterEvent(5312);
    RegisterEvent(8000);
    RegisterEvent(40);
    return;
}

function OnLoad()
{
    m_filterInfo.Length = 9 + 1;
    m_EditBoxHeight = 16;
    m_sectionName.Length = 9;
    m_sectionName[0] = "entire_tab";
    m_sectionName[1] = "pledge_tab";
    m_sectionName[2] = "party_tab";
    m_sectionName[3] = "market_tab";
    m_sectionName[4] = "ally_tab";
    m_sectionName[5] = "hero_tab";
    m_sectionName[6] = "union_tab";
    m_sectionName[7] = "shout_tab";
    m_sectionName[8] = "worldChat_tab";
    RegisterState("ChatWnd", "OlympiadObserverState");
    RegisterState("ChatWnd", "TRAININGROOMSTATE");
    InitHandleCOD();
    InitFilterInfo();
    InitScrollBarPosition();
    ChatEditBox.SetEnableTextLink(true);
    m_chatType.UI = 0;
    m_chatType.Id = -1;
    m_IsSplit0 = false;
    m_IsSplit1 = false;
    m_IsSplit2 = false;
    m_IsSplit3 = false;
    m_IsSplit4 = false;
    // End:0x1B7
    if(getInstanceUIData().getIsArenaServer())
    {
        ChatTabCtrl.RemoveTabControl(4);
        ChatTabCtrl.RemoveTabControl(3);
    }
    return;
}

function OnDefaultPosition()
{
    ChatTabCtrl.MergeTab(1);
    ChatTabCtrl.MergeTab(2);
    ChatTabCtrl.MergeTab(3);
    ChatTabCtrl.MergeTab(4);
    ChatTabCtrl.SetTopOrder(0, true);
    m_hChatWnd.SetAnchor("", "BottomLeft", "BottomLeft", 0, -18);
    HandleTabClick("ChatTabCtrl0");
    return;
}

function InitHandleCOD()
{
    NormalChat = GetChatWindowHandle("ChatWnd.NormalChat");
    TradeChat = GetChatWindowHandle("ChatWnd.TradeChat");
    PartyChat = GetChatWindowHandle("ChatWnd.PartyChat");
    ClanChat = GetChatWindowHandle("ChatWnd.ClanChat");
    AllyChat = GetChatWindowHandle("ChatWnd.AllyChat");
    SystemMsg = GetChatWindowHandle("SystemMsgWnd.SystemMsgList");
    ChatTabCtrl = GetTabHandle("ChatWnd.ChatTabCtrl");
    TradeChatTabButton = GetWindowHandle("ChatWnd.TradeChat.TabButton");
    PartyChatTabButton = GetWindowHandle("ChatWnd.PartyChat.TabButton");
    ClanChatTabButton = GetWindowHandle("ChatWnd.ClanChat.TabButton");
    AllyChatTabButton = GetWindowHandle("ChatWnd.AllyChat.TabButton");
    ChatEditBox = GetEditBoxHandle("ChatWnd.ChatEditBox");
    m_hChatFontsizeWnd = GetWindowHandle("ChatFontsizeWnd");
    m_ChatFontOptionBtn = GetButtonHandle("ChatWnd.ChatFontOptionBtn");
    m_hChatWnd = GetWindowHandle("ChatWnd");
    m_hChatWnd.EnableDynamicAlpha(true);
    TradeChat.EnableDynamicAlpha(true);
    PartyChat.EnableDynamicAlpha(true);
    ClanChat.EnableDynamicAlpha(true);
    AllyChat.EnableDynamicAlpha(true);
    SystemMsg.EnableDynamicAlpha(true);
    m_hSystemMsgWnd = GetWindowHandle("SystemMsgWnd");
    m_hChatWndLanguageTexture = GetTextureHandle("ChatWnd.LanguageTexture");
    m_hChatWndBodyTex = GetTextureHandle("ChatWnd.ChatWndBodyTex");
    m_hChatWndHeadTex = GetTextureHandle("ChatWnd.ChatWndHeadTex");
    m_hChatWndBottomTex = GetTextureHandle("ChatWnd.ChatWndBottomTex");
    m_hChatWndBottomTex2 = GetTextureHandle("ChatWnd.ChatWndBottomTex1");
    m_hChatWndBottomTex3 = GetTextureHandle("ChatWnd.ChatWndBottomTex2");
    m_hChatWndBottomTex4 = GetTextureHandle("ChatWnd.ChatWndBottomTex3");
    m_hChatWndBottomTex5 = GetTextureHandle("ChatWnd.ChatWndBottomTex4");
    return;
}

function InitScrollBarPosition()
{
    NormalChat.SetScrollBarPosition(5, 10, 2);
    TradeChat.SetScrollBarPosition(5, 10, 2);
    PartyChat.SetScrollBarPosition(5, 10, 2);
    ClanChat.SetScrollBarPosition(5, 10, 2);
    AllyChat.SetScrollBarPosition(5, 10, 2);
    return;
}

function OnCompleteEditBox(string strID)
{
    local string strInput;
    local UIEventManager.EChatType Type;
    local int spacePos;

    // End:0x23A
    if(strID == "ChatEditBox")
    {
        strInput = ChatEditBox.GetString();
        // End:0x3B
        if(Len(strInput) < 1)
        {
            return;
        }
        // End:0xBA
        if((Left(strInput, 4) == "//gm") && Len(strInput) == 4)
        {
            getInstanceL2Util().showGfxScreenMessage("'//gm' doesnt affect anymore, please, use '//gmaster'...");
            ChatEditBox.Clear();
            return;
        }
        // End:0xEA
        if(Left(strInput, Len("//gmaster")) == "//gmaster")
        {
            strInput = "//gm";
        }
        onTextComplete(strInput, 0);
        strInput = CommandShorter(strInput);
        // End:0x161
        if(InStr(strInput, "///execbps ") > -1)
        {
            spacePos = InStr(strInput, " ");
            // End:0x15E
            if(spacePos > -1)
            {
                RequestBypassToServer(Mid(strInput, spacePos + 1));
            }            
        }
        else
        {
            ProcessChatMessage(strInput, m_chatType.Id, false);
        }
        ChatEditBox.SetString("");
        m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));
        // End:0x20B
        if(bool(m_UseChatSymbol) == true)
        {
            Type = GetChatTypeByTabIndex(m_chatType.Id);
            // End:0x20B
            if(m_chatType.Id != 0)
            {
                // End:0x20B
                if((GetChatPrefix(Type)) != "~")
                {
                    ChatEditBox.AddString(GetChatPrefix(Type));
                }
            }
        }
        // End:0x23A
        if(GetChatFilterBool("Global", "EnterChatting"))
        {
            ChatEditBox.ReleaseFocus();
        }
    }
    return;
}

function Clear()
{
    ChatEditBox.super(ChatWnd).Clear();
    NormalChat.super(ChatWnd).Clear();
    PartyChat.super(ChatWnd).Clear();
    ClanChat.super(ChatWnd).Clear();
    TradeChat.super(ChatWnd).Clear();
    AllyChat.super(ChatWnd).Clear();
    SystemMsg.super(ChatWnd).Clear();
    return;
}

function SetChangeFont(int FontType)
{
    local string FontName;

    switch(FontType)
    {
        // End:0x24
        case 0:
            FontName = "chatFontSize10";
            // End:0x7E
            break;
        // End:0x41
        case 1:
            FontName = "chatFontSize11";
            // End:0x7E
            break;
        // End:0x5F
        case 2:
            FontName = "chatFontSize12";
            // End:0x7E
            break;
        // End:0xFFFF
        default:
            FontName = "chatFontSize10";
            // End:0x7E
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07E
    NormalChat.SetFontIDByName(FontName);
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07E
    TradeChat.SetFontIDByName(FontName);
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07E
    PartyChat.SetFontIDByName(FontName);
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07E
    ClanChat.SetFontIDByName(FontName);
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07E
    AllyChat.SetFontIDByName(FontName);
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07E
    SystemMsg.SetFontIDByName(FontName);
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07E
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07E
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x07E
}

function OnShow()
{
    local int FontSize, sizeW, sizeH, tempVal;
    local string isSavedString, sizeParam, isShowSystemMsgWndParam;
    local int CurrentMaxWidth, CurrentMaxHeight;
    local bool isSavedChatSize;
    local int sysW, sysH;

    m_hSystemMsgWnd.GetWindowSize(sysW, sysH);
    handleChangedSubjob("");
    GetINIString("global", "DefaultSaveOption", isSavedString, "chatfilter.ini");
    // End:0x70
    if(isSavedString == "true")
    {
        LoadINIFilterSetting();        
    }
    else
    {
        isSavedString = "true";
        SetINIString("global", "DefaultSaveOption", isSavedString, "chatfilter.ini");
        SetDefaultFilterValue();
        SaveChatFilterOption();
    }
    GetINIBool("global", "SystemMsgWnd", tempVal, "chatfilter.ini");
    m_bUseSystemMsgWnd = tempVal;
    ParamAdd(isShowSystemMsgWndParam, "visible", string(tempVal));
    // End:0x17D
    if(GetINIBool("global", "UseWorldChatSpeaker", tempVal, "chatfilter.ini"))
    {
        CallGFxFunction("worldChatBox", "IsShowSystemMsgWnd", isShowSystemMsgWndParam);
    }
    CallGFxFunction("UserAlertMessage", "IsShowSystemMsgWnd", isShowSystemMsgWndParam);
    // End:0x1CA
    if(bool(m_bUseSystemMsgWnd))
    {
        m_hSystemMsgWnd.ShowWindow();        
    }
    else
    {
        m_hSystemMsgWnd.HideWindow();
    }
    // End:0x236
    if(GetINIBool("global", "ChatResizing", tempVal, "chatfilter.ini"))
    {
        m_ChatResizeOnOff = tempVal;
        // End:0x22C
        if(bool(m_ChatResizeOnOff))
        {
            EnableChatWndResizing(false);            
        }
        else
        {
            EnableChatWndResizing(true);
        }        
    }
    else
    {
        EnableChatWndResizing(true);
    }
    HandleIMEStatusChange();
    GetAllcurrentAssignedChatTypeID();
    // End:0x2BE
    if(((GetGameStateName() != "ARENAPICKSTATE") && GetGameStateName() != "ARENAGAMINGSTATE") && GetGameStateName() != "ARENABATTLESTATE")
    {
        m_chatType.UI = 0;
        m_chatType.Id = -1;
    }
    GetINIInt("global", "ChatFontSizeSaved", FontSize, "chatfilter.ini");
    SetChangeFont(FontSize);
    // End:0x314
    if(m_UseAlpha == 0)
    {
        SetDefaultAlpha(0);        
    }
    else
    {
        SetDefaultAlpha(1);
    }
    GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
    isSavedChatSize = GetINIInt("global", "ChatSizeWidth", sizeW, "chatfilter.ini");
    isSavedChatSize = GetINIInt("global", "ChatSizeHeight", sizeH, "chatfilter.ini") && isSavedChatSize;
    // End:0x3C3
    if(sizeW < 348)
    {
        sizeW = 348;
    }
    // End:0x3D7
    if(sizeH < 188)
    {
        sizeH = 188;
    }
    // End:0x52A
    if((isSavedChatSize && sizeW <= CurrentMaxWidth) && sizeH <= (CurrentMaxHeight - 15))
    {
        m_hChatWnd.SetWindowSize(sizeW, sizeH);
        ChatEditBox.SetWindowSize(sizeW - 31, m_EditBoxHeight);
        m_hChatWndBottomTex3.SetWindowSize(sizeW - 326, 46);
        // End:0x491
        if(m_bUseSystemMsgWnd != 1)
        {
            ParamAdd(sizeParam, "w", string(sizeW));
            ParamAdd(sizeParam, "h", string(sizeH));            
        }
        else
        {
            ParamAdd(sizeParam, "w", string(sysW));
            ParamAdd(sizeParam, "h", string(sizeH + Max(0, sysH - 128)));
        }
        CallGFxFunction("UserAlertMessage", "ReceiveChatWndSize", sizeParam);
        CallGFxFunction("worldChatBox", "ReceiveChatWndSize", sizeParam);        
    }
    else
    {
        m_hChatWnd.SetWindowSize(348, 188);
        m_hChatWnd.SetResizeFrameOffset(348, 188);
        SetINIInt("global", "ChatSizeWidth", 348, "chatfilter.ini");
        SetINIInt("global", "ChatSizeHeight", 188, "chatfilter.ini");
        sysW = sysW + 348;
        sysH = sysH + 188;
        ParamAdd(sizeParam, "w", string(sysW));
        ParamAdd(sizeParam, "h", string(sysH));
        CallGFxFunction("UserAlertMessage", "ReceiveChatWndSize", sizeParam);
        CallGFxFunction("worldChatBox", "ReceiveChatWndSize", sizeParam);
    }
    m_hChatWnd.SetResizeFrameOffset(348, 188);
    setInit();
    return;
}

function setInit()
{
    InitFilterInfo();
    SetChatFilterBool("Global", "EnterChatting", GetChatFilterBool("Global", "EnterChatting"));
    return;
}

function handleFakeCallTW()
{
    local string ddqwd;
    local int i;

    ExecuteEvent(3630);
    i = 0;
    J0x12:

    // End:0xB0 [Loop If]
    if(i < 9)
    {
        ddqwd = "";
        ParamAdd(ddqwd, "DominionID", string(81 + i));
        ParamAdd(ddqwd, "PosX", string(Rand(212175)));
        ParamAdd(ddqwd, "PosY", string(Rand(35475)));
        ParamAdd(ddqwd, "PosZ", string(Rand(-4400)));
        ExecuteEvent(3610, ddqwd);
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    return;
}

function createBtn()
{
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(0, 3000);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(1, 3001);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(2, 3002);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(3, 3003);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(4, 3004);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(5, 3005);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(6, 3006);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(7, 3007);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(8, 3008);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(9, 3009);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(10, 3010);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(11, 3109);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(12, 3012);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(13, 3013);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(14, 3014);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(15, 3015);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(16, 3016);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(17, 3017);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(18, 3018);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(19, 3019);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(20, 3020);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(21, 3021);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(22, 3022);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(23, 3023);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(24, 3024);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(25, 3025);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(26, 3026);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(27, 3027);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(28, 3028);
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(29, 3029);
    return;
}

function HandlePrintShortcut()
{
    local array<ShortcutCommandItem> CommandList;
    local array<string> grouplist;
    local int i, j;

    Class'NWindow.ShortcutAPI'.static.GetGroupList(grouplist);
    i = 0;
    J0x1B:

    // End:0x7D [Loop If]
    if(i < grouplist.Length)
    {
        CommandList.Length = 0;
        Class'NWindow.ShortcutAPI'.static.GetGroupCommandList(grouplist[i], CommandList);
        j = 0;
        J0x59:

        // End:0x73 [Loop If]
        if(j < CommandList.Length)
        {
            ++j;
            // [Loop Continue]
            goto J0x59;
        }
        ++i;
        // [Loop Continue]
        goto J0x1B;
    }
    grouplist.Length = 0;
    Class'NWindow.ShortcutAPI'.static.GetActiveGroupList(grouplist);
    i = 0;
    J0xA0:

    // End:0xBA [Loop If]
    if(i < grouplist.Length)
    {
        ++i;
        // [Loop Continue]
        goto J0xA0;
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x29
    if(TimerID == 1992)
    {
        ClosePartyMatchingWnd();
        m_hChatWnd.KillTimer(1992);
    }
    return;
}

function fakeWar()
{
    local string param;
    local int i;

    i = 0;
    J0x07:

    // End:0x11E [Loop If]
    if(i < 3)
    {
        param = "";
        ParamAdd(param, "Page", "1");
        ParamAdd(param, "ClanName", "ClanName" $ string(Rand(100)));
        ParamAdd(param, "State", string(i));
        ParamAdd(param, "ProgressTimeInSec", string(RandRange(0.0000000, 604800.0000000)));
        ParamAdd(param, "Point", string(Rand(50)));
        ParamAdd(param, "PointDiff", string(Rand(15)));
        ParamAdd(param, "LeftKillCountOfEnemyToWar", string(i * 10));
        ExecuteEvent(460, param);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

static function int MakeColor(byte R, byte G, byte B, optional byte A)
{
    A = byte(255);
    return (((int(A) << 24) | (int(R) << 16)) | (int(G) << 8)) | int(B);
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x18
        case "ChatTabCtrl0":
        // End:0x29
        case "ChatTabCtrl1":
        // End:0x3A
        case "ChatTabCtrl2":
        // End:0x4B
        case "ChatTabCtrl3":
        // End:0x6A
        case "ChatTabCtrl4":
            HandleTabClick(strID);
            // End:0xFB
            break;
        // End:0xA6
        case "ChatFilterBtn":
            CallGFxFunction("OptionWnd", "showChattingOption", "");
            // End:0xFB
            break;
        // End:0xF2
        case "ChatFontOptionBtn":
            // End:0xE0
            if(m_hChatFontsizeWnd.IsShowWindow())
            {
                m_hChatFontsizeWnd.HideWindow();                
            }
            else
            {
                m_hChatFontsizeWnd.ShowWindow();
            }
            // End:0xFB
            break;
        // End:0xFFFF
        default:
            // End:0xFB
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0FB
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0FB
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0FB
}

function HandlePartyMatchWnd()
{
    local WindowHandle TaskWnd;
    local PartyMatchWnd script;
    local PartyMatchRoomWnd p2_script;

    p2_script = PartyMatchRoomWnd(GetScript("PartyMatchRoomWnd"));
    script = PartyMatchWnd(GetScript("PartyMatchWnd"));
    TaskWnd = GetWindowHandle("PartyMatchWnd");
    // End:0x7A
    if(TaskWnd.IsShowWindow())
    {
        ClosePartyMatchingWnd();        
    }
    else
    {
        TaskWnd = GetWindowHandle("PartyMatchRoomWnd");
        // End:0x115
        if(TaskWnd.IsShowWindow())
        {
            TaskWnd.HideWindow();
            TaskWnd = GetWindowHandle("PartyMatchWnd");
            p2_script.OnSendPacketWhenHiding();
            TaskWnd = GetWindowHandle("ChatWnd");
            TaskWnd.SetTimer(1992, 500);            
        }
        else
        {
            TaskWnd = GetWindowHandle("PartyMatchWnd");
            Class'NWindow.PartyMatchAPI'.static.RequestOpenPartyMatch();
        }
    }
    return;
}

function ClosePartyMatchingWnd()
{
    local WindowHandle TaskWnd;
    local PartyMatchWnd p_script;

    p_script = PartyMatchWnd(GetScript("PartyMatchWnd"));
    TaskWnd = GetWindowHandle("PartyMatchWnd");
    TaskWnd.HideWindow();
    p_script.OnSendPacketWhenHiding();
    return;
}

function OnTabSplit(string sTabButton)
{
    local ChatWindowHandle Handle;
    local int outputWidth, outputHeight;

    InitScrollBarPosition();
    switch(sTabButton)
    {
        // End:0x3F
        case "ChatTabCtrl0":
            Handle = NormalChat;
            HandleTabClick(sTabButton);
            m_IsSplit0 = true;
            // End:0x110
            break;
        // End:0x71
        case "ChatTabCtrl1":
            Handle = TradeChat;
            HandleTabClick(sTabButton);
            m_IsSplit1 = true;
            // End:0x110
            break;
        // End:0xA3
        case "ChatTabCtrl2":
            Handle = PartyChat;
            HandleTabClick(sTabButton);
            m_IsSplit2 = true;
            // End:0x110
            break;
        // End:0xD5
        case "ChatTabCtrl3":
            Handle = ClanChat;
            HandleTabClick(sTabButton);
            m_IsSplit3 = true;
            // End:0x110
            break;
        // End:0x107
        case "ChatTabCtrl4":
            Handle = AllyChat;
            HandleTabClick(sTabButton);
            m_IsSplit4 = true;
            // End:0x110
            break;
        // End:0xFFFF
        default:
            // End:0x110
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x110
    // End:0x26F
    if(Handle != none)
    {
    }/* !MISMATCHING REMOVE, tried Switch got Type:If Position:0x110! */
    Handle.SetWindowSizeRel(-1.0000000, -1.0000000, 0, 0);
    Handle.SetResizeFrameOffset(343, 139);
    Handle.GetWindowSize(outputWidth, outputHeight);
    m_hChatWndBottomTex3.SetWindowSize(outputWidth - 326, 46);
    Handle.Move(0, 4);
    Handle.SetSettledWnd(true);
    Handle.EnableTexture(true);
    // End:0x26F
    if(m_UseAlpha == 1)
    {
        Handle.SetAlpha(255, 0.0000000);
        m_hChatWndBodyTex.SetAlpha(50, 0.0000000);
        m_hChatWndHeadTex.SetAlpha(50, 0.0000000);
        m_hChatWndBottomTex.SetAlpha(50, 0.0000000);
        m_hChatWndBottomTex2.SetAlpha(50, 0.0000000);
        m_hChatWndBottomTex3.SetAlpha(50, 0.0000000);
        m_hChatWndBottomTex4.SetAlpha(50, 0.0000000);
        m_hChatWndBottomTex5.SetAlpha(50, 0.0000000);
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x26F
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x26F
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x26F
}

function OnTabMerge(string sTabButton)
{
    local ChatWindowHandle Handle;
    local Rect rectWnd;

    InitScrollBarPosition();
    switch(sTabButton)
    {
        // End:0x34
        case "ChatTabCtrl0":
            Handle = NormalChat;
            m_IsSplit0 = false;
            // End:0xD9
            break;
        // End:0x5B
        case "ChatTabCtrl1":
            Handle = TradeChat;
            m_IsSplit1 = false;
            // End:0xD9
            break;
        // End:0x82
        case "ChatTabCtrl2":
            Handle = PartyChat;
            m_IsSplit2 = false;
            // End:0xD9
            break;
        // End:0xA9
        case "ChatTabCtrl3":
            Handle = ClanChat;
            m_IsSplit3 = false;
            // End:0xD9
            break;
        // End:0xD0
        case "ChatTabCtrl4":
            Handle = AllyChat;
            m_IsSplit4 = false;
            // End:0xD9
            break;
        // End:0xFFFF
        default:
            // End:0xD9
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0D9
    // End:0x21A
    if(Handle != none)
    {
    }/* !MISMATCHING REMOVE, tried Switch got Type:If Position:0x0D9! */
    rectWnd = NormalChat.GetRect();
    Handle.MoveTo(rectWnd.nX, rectWnd.nY);
    Handle.SetSettledWnd(false);
    Handle.SetWindowSizeRel(1.0000000, 1.0000000, -5, -49);
    Handle.EnableTexture(false);
    // End:0x21A
    if(m_UseAlpha == 1)
    {
        Handle.SetAlpha(255, 0.0000000);
        m_hChatWndBodyTex.SetAlpha(255, 0.0000000);
        m_hChatWndHeadTex.SetAlpha(255, 0.0000000);
        m_hChatWndBottomTex.SetAlpha(255, 0.0000000);
        m_hChatWndBottomTex2.SetAlpha(255, 0.0000000);
        m_hChatWndBottomTex3.SetAlpha(255, 0.0000000);
        m_hChatWndBottomTex4.SetAlpha(255, 0.0000000);
        m_hChatWndBottomTex5.SetAlpha(255, 0.0000000);
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x21A
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x21A
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x21A
}

function HandleTabClick(string strID)
{
    local string strInput, strPrefix;
    local int StrLen;

    m_chatType.UI = ChatTabCtrl.GetTopIndex();
    m_chatType.Id = GetCurrentChatTypeID(m_chatType.UI);
    InitScrollBarPosition();
    lastClickChatTabName = strID;
    // End:0x1C5
    if(GetChatFilterBool("Global", "OldChatting"))
    {
        strInput = ChatEditBox.GetString();
        StrLen = Len(strInput);
        strPrefix = Left(strInput, 1);
        // End:0x149
        if(((((((((IsSameChatPrefix(8, strPrefix)) || IsSameChatPrefix(3, strPrefix)) || IsSameChatPrefix(4, strPrefix)) || IsSameChatPrefix(9, strPrefix)) || IsSameChatPrefix(17, strPrefix)) || IsSameChatPrefix(16, strPrefix)) || IsSameChatPrefix(1, strPrefix)) || IsSameChatPrefix(25, strPrefix)) || IsSameChatPrefix(20, strPrefix))
        {
            strInput = Right(strInput, StrLen - 1);
        }
        // End:0x197
        if(m_chatType.UI != 0)
        {
            strPrefix = GetChatPrefix(GetChatTypeByTabIndex(m_chatType.Id));
            // End:0x194
            if(strPrefix != "~")
            {
                strInput = strPrefix $ strInput;
            }            
        }
        else
        {
            strPrefix = "";
            strInput = strPrefix $ strInput;
        }
        ChatEditBox.SetString(strInput);
    }
    return;
}

function OnEnterState(name a_PrevStateName)
{
    // End:0x15
    if(a_PrevStateName == 'LoadingState')
    {
        Clear();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 540:
            HandleChatmessage(param);
            // End:0x1AA
            break;
        // End:0x2E
        case 1500:
            HandleIMEStatusChange();
            // End:0x1AA
            break;
        // End:0x39
        case 550:
            // End:0x1AA
            break;
        // End:0x4A
        case 570:
            HandleSetFocus();
            // End:0x1AA
            break;
        // End:0x60
        case 560:
            HandleSetString(param);
            // End:0x1AA
            break;
        // End:0x76
        case 572:
            HandleChatWndMacroCommand(param);
            // End:0x1AA
            break;
        // End:0x8C
        case 3000:
            HandleTextLinkLButtonClick(param);
            // End:0x1AA
            break;
        // End:0xA2
        case 3010:
            HandleTextLinkRButtonClick(param);
            // End:0x1AA
            break;
        // End:0xB8
        case 3620:
            HandleDominionWarChannelSet(param);
            // End:0x1AA
            break;
        // End:0xF1
        case 150:
            // End:0xEE
            if(lastClickChatTabName != "")
            {
                ChatTabCtrl.SetTopOrder(int(Right(lastClickChatTabName, 1)), true);
                HandleTabClick(lastClickChatTabName);
            }
            // End:0x1AA
            break;
        // End:0xF9
        case 40:
            // End:0x1AA
            break;
        // End:0x131
        case 8000:
            lastClickChatTabName = "";
            ChatTabCtrl.SetTopOrder(0, true);
            HandleTabClick("ChatTabCtrl0");
            // End:0x1AA
            break;
        // End:0x148
        case 160:
            ChatEditBox.ClearHistory();
            // End:0x1AA
            break;
        // End:0x159
        case 1710:
            HandleDialogOK();
            // End:0x1AA
            break;
        // End:0x164
        case 1720:
            // End:0x1AA
            break;
        // End:0x17A
        case 555:
            UpdateSize(param);
            // End:0x1AA
            break;
        // End:0x18B
        case 2900:
            UpdateResolution();
            // End:0x1AA
            break;
        // End:0x1A1
        case 5312:
            handleChangedSubjob(param);
            // End:0x1AA
            break;
        // End:0xFFFF
        default:
            // End:0x1AA
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1AA
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1AA
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1AA
}

function handleChangedSubjob(string param)
{
    local bool IsPrologueGrowType;
    local int currentClassID;

    // End:0x32
    if(param != "")
    {
        ParseInt(param, "CurrentSubjobClassID", currentClassID);
    }
    IsPrologueGrowType = getInstanceL2Util().getIsPrologueGrowType(currentClassID);
    ChatTabCtrl.SetDisable(1, IsPrologueGrowType);
    ChatTabCtrl.SetDisable(2, IsPrologueGrowType);
    ChatTabCtrl.SetDisable(3, IsPrologueGrowType);
    ChatTabCtrl.SetDisable(4, IsPrologueGrowType);
    // End:0xC3
    if(IsPrologueGrowType)
    {
        ChatTabCtrl.SetTopOrder(0, true);
    }
    return;
}

function UpdateResolution()
{
    local int CurrentMaxWidth, CurrentMaxHeight, CurrentChatWidth, CurrentChatHeight, CurrentEditBoxWidth, CurrentEditBoxHeight;

    local bool isFixedW, isFixedH;

    GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
    m_hChatWnd.GetWindowSize(CurrentChatWidth, CurrentChatHeight);
    isFixedW = CurrentChatWidth > CurrentMaxWidth;
    isFixedH = CurrentChatHeight > (CurrentMaxHeight - 15);
    // End:0x131
    if(isFixedW || isFixedH)
    {
        m_hChatWnd.SetWindowSize(348, 188);
        m_hChatWnd.SetResizeFrameOffset(348, 188);
        ChatEditBox.GetWindowSize(CurrentEditBoxWidth, CurrentEditBoxHeight);
        ChatEditBox.SetWindowSize(348 - 31, CurrentEditBoxHeight);
        SetINIInt("global", "ChatSizeWidth", 348, "chatfilter.ini");
        SetINIInt("global", "ChatSizeHeight", 188, "chatfilter.ini");
        OnDefaultPosition();
    }
    return;
}

function UpdateSize(string param)
{
    local int W, h, sizeW, resizeWidth, resizeHeight;

    local string wName, sizeParam;
    local int sysW, sysH;

    ParseInt(param, "Width", resizeWidth);
    ParseInt(param, "Height", resizeHeight);
    ParseString(param, "WindowName", wName);
    ChatEditBox.GetWindowSize(W, h);
    m_hSystemMsgWnd.GetWindowSize(sysW, sysH);
    m_hChatWndBottomTex3.SetWindowSize(resizeWidth - 326, 46);
    ChatEditBox.SetWindowSize(resizeWidth - 31, h);
    // End:0xEF
    if(m_bUseSystemMsgWnd != 1)
    {
        ParamAdd(sizeParam, "w", string(resizeWidth));
        ParamAdd(sizeParam, "h", string(resizeHeight));        
    }
    else
    {
        ParamAdd(sizeParam, "w", string(sysW));
        ParamAdd(sizeParam, "h", string(resizeHeight + Max(0, sysH - 128)));
    }
    CallGFxFunction("UserAlertMessage", "ReceiveChatWndSize", sizeParam);
    CallGFxFunction("worldChatBox", "ReceiveChatWndSize", sizeParam);
    m_hOwnerWnd.GetWindowSize(W, h);
    m_hSystemMsgWnd.GetWindowSize(sysW, sysH);
    // End:0x248
    if(wName == "ChatWnd")
    {
        SetINIInt("global", "ChatSizeWidth", resizeWidth, "chatfilter.ini");
        SetINIInt("global", "ChatSizeHeight", resizeHeight, "chatfilter.ini");
        m_hSystemMsgWnd.SetWindowSize(resizeWidth, sysH);
    }
    // End:0x270
    if(sysW < W)
    {
        m_hSystemMsgWnd.SetWindowSize(resizeWidth, sysH);
    }
    return;
}

function HandleDialogOK()
{
    // End:0x0D
    if(!DialogIsMine())
    {
        return;
    }
    switch(DialogGetID())
    {
        // End:0x2B
        case 1234510:
            OpenGivenURL(URL);
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

function HandleChatWndMacroCommand(string param)
{
    local string Command;

    // End:0x20
    if(!ParseString(param, "Command", Command))
    {
        return;
    }
    // End:0x4F
    if(InStr(Command, "/itemfind") > -1)
    {
        RequestBypassToServer("getbroker");
        return;
    }
    // End:0x7D
    if(Command == "/tacticsign5")
    {
        DoAction(GetItemID(1200));
        return;        
    }
    else
    {
        // End:0xAB
        if(Command == "/tacticsign6")
        {
            DoAction(GetItemID(1201));
            return;            
        }
        else
        {
            // End:0xD9
            if(Command == "/tacticsign7")
            {
                DoAction(GetItemID(1202));
                return;                
            }
            else
            {
                // End:0x107
                if(Command == "/tacticsign8")
                {
                    DoAction(GetItemID(1203));
                    return;                    
                }
                else
                {
                    // End:0x13B
                    if(Command == "/targettacticsign5")
                    {
                        DoAction(GetItemID(1204));
                        return;                        
                    }
                    else
                    {
                        // End:0x16F
                        if(Command == "/targettacticsign6")
                        {
                            DoAction(GetItemID(1205));
                            return;                            
                        }
                        else
                        {
                            // End:0x1A3
                            if(Command == "/targettacticsign7")
                            {
                                DoAction(GetItemID(1206));
                                return;                                
                            }
                            else
                            {
                                // End:0x1D7
                                if(Command == "/targettacticsign8")
                                {
                                    DoAction(GetItemID(1207));
                                    return;                                    
                                }
                                else
                                {
                                    // End:0x205
                                    if(Command == "/tacticsign9")
                                    {
                                        DoAction(GetItemID(1208));
                                        return;                                        
                                    }
                                    else
                                    {
                                        // End:0x234
                                        if(Command == "/tacticsign10")
                                        {
                                            DoAction(GetItemID(1209));
                                            return;                                            
                                        }
                                        else
                                        {
                                            // End:0x263
                                            if(Command == "/tacticsign11")
                                            {
                                                DoAction(GetItemID(1210));
                                                return;                                                
                                            }
                                            else
                                            {
                                                // End:0x292
                                                if(Command == "/tacticsign12")
                                                {
                                                    DoAction(GetItemID(1211));
                                                    return;                                                    
                                                }
                                                else
                                                {
                                                    // End:0x2C6
                                                    if(Command == "/targettacticsign9")
                                                    {
                                                        DoAction(GetItemID(1212));
                                                        return;                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x2FB
                                                        if(Command == "/targettacticsign10")
                                                        {
                                                            DoAction(GetItemID(1213));
                                                            return;                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x330
                                                            if(Command == "/targettacticsign11")
                                                            {
                                                                DoAction(GetItemID(1214));
                                                                return;                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x365
                                                                if(Command == "/targettacticsign12")
                                                                {
                                                                    DoAction(GetItemID(1215));
                                                                    return;                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x390
                                                                    if(Command == "/nexttarget2")
                                                                    {
                                                                        DoAction(GetItemID(92));
                                                                        return;                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x3C4
                                                                        if(Left(Command, 11) == "/useaction ")
                                                                        {
                                                                            DoAction(GetItemID(int(Mid(Command, 11))));
                                                                            return;
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
    Command = CommandShorter(Command);
    ProcessChatMessage(Command, m_chatType.Id, false);
    return;
}

function HandleChatmessage(string param)
{
    local int nTmp;
    local UIEventManager.EChatType Type;
    local UIEventManager.ESystemMsgType systemType;
    local string Text, origText, userIDString, worldChatMsg;
    local Color Color;
    local int foundID;
    local SystemMsgData SysMsgData;
    local int SysMsgIndex, relationType, TargetLevel, SayType, tempVal;

    local string sizeParam;
    local int W, h;

    ParseInt(param, "Type", nTmp);
    Type = byte(nTmp);
    SayType = nTmp;
    ParseString(param, "Msg", origText);
    // End:0x123
    if(int(Type) == 5)
    {
        ParseInt(param, "SysMsgIndex", SysMsgIndex);
        // End:0x91
        if(SysMsgIndex == -1)
        {
            Color = GetChatColorByType(SayType);            
        }
        else
        {
            // End:0xA5
            if(SysMsgIndex == 4700)
            {
                return;                
            }
            else
            {
                GetSystemMsgInfo(SysMsgIndex, SysMsgData);
                Color = SysMsgData.FontColor;
            }
        }
        ParseInt(param, "SysType", nTmp);
        systemType = byte(nTmp);
        // End:0x120
        if(int(systemType) == 10)
        {
            Color.R = 62;
            Color.G = 239;
            Color.B = 10;
        }        
    }
    else
    {
        Color = GetChatColorByType(SayType);
        systemType = 0;
    }
    Text = origText;
    // End:0x176
    if(InStr(Text, "/itemfind") > -1)
    {
        RequestBypassToServer("getbroker");
        return;
    }
    // End:0x255
    if(int(Type) == 2)
    {
        ParseString(Text, "Title", userIDString);
        ParseInt(param, "Relation", relationType);
        ParseInt(param, "Level", TargetLevel);
        // End:0x255
        if(Right(Left(userIDString, 2), 1) != "-")
        {
            CallGFxFunction("UserAlertMessage", "WhisperMessage", (((("Title=" $ userIDString) $ " RelationType=") $ string(relationType)) $ " Level=") $ string(TargetLevel));
            Class'NWindow.FlashWindowAPI'.static.FlashWindow();
        }
    }
    // End:0x26E
    if(int(Type) == 25)
    {
        // End:0x26E
        if(m_bWorldChatSpeaker == 1)
        {
        }
    }
    // End:0x2A3
    if(m_KeywordFilterActivate == 1)
    {
        foundID = ChatNotificationFilter(Text, origText, m_Keyword0, m_Keyword1, m_Keyword2, m_Keyword3);
    }
    // End:0x322
    if(CheckFilter(Type, 0, systemType))
    {
        NormalChat.AddStringToChatWindow(Text, Color);
        // End:0x322
        if(((foundID > 0) && m_KeywordFilterSound == 1) && ChatTabCtrl.GetTopIndex() == 0)
        {
            PlaySound("ItemSound3.Sys_Chat_Keyword");
        }
    }
    // End:0x3AC
    if(CheckFilter(Type, m_ChatUI[1].Id, systemType))
    {
        TradeChat.AddStringToChatWindow(Text, Color);
        // End:0x3AC
        if(((foundID > 0) && m_KeywordFilterSound == 1) && ChatTabCtrl.GetTopIndex() == 1)
        {
            PlaySound("ItemSound3.Sys_Chat_Keyword");
        }
    }
    // End:0x438
    if(CheckFilter(Type, m_ChatUI[2].Id, systemType))
    {
        PartyChat.AddStringToChatWindow(Text, Color);
        // End:0x438
        if(((foundID > 0) && m_KeywordFilterSound == 1) && ChatTabCtrl.GetTopIndex() == 2)
        {
            PlaySound("ItemSound3.Sys_Chat_Keyword");
        }
    }
    // End:0x4C4
    if(CheckFilter(Type, m_ChatUI[3].Id, systemType))
    {
        ClanChat.AddStringToChatWindow(Text, Color);
        // End:0x4C4
        if(((foundID > 0) && m_KeywordFilterSound == 1) && ChatTabCtrl.GetTopIndex() == 3)
        {
            PlaySound("ItemSound3.Sys_Chat_Keyword");
        }
    }
    // End:0x550
    if(CheckFilter(Type, m_ChatUI[4].Id, systemType))
    {
        AllyChat.AddStringToChatWindow(Text, Color);
        // End:0x550
        if(((foundID > 0) && m_KeywordFilterSound == 1) && ChatTabCtrl.GetTopIndex() == 4)
        {
            PlaySound("ItemSound3.Sys_Chat_Keyword");
        }
    }
    // End:0x5B9
    if(CheckFilter(Type, 9, systemType))
    {
        SystemMsg.AddStringToChatWindow(Text, Color);
        // End:0x5B9
        if((foundID > 0) && m_KeywordFilterSound == 1)
        {
            PlaySound("ItemSound3.Sys_Chat_Keyword");
        }
    }
    // End:0x62A
    if(int(Type) == 15)
    {
        // End:0x602
        if((foundID > 0) && m_KeywordFilterSound == 1)
        {
            PlaySound("ItemSound3.Sys_Chat_Keyword");
        }
        ParseString(param, "FilteredMsg", origText);
        ShowUnionCommanderMessgage(origText);
    }
    // End:0x71B
    if(int(Type) == 19)
    {
        // End:0x673
        if((foundID > 0) && m_KeywordFilterSound == 1)
        {
            PlaySound("ItemSound3.Sys_Chat_Keyword");
        }
        Color.R = 0;
        Color.G = byte(255);
        Color.B = byte(255);
        NormalChat.AddStringToChatWindow(Text, Color);
        TradeChat.AddStringToChatWindow(Text, Color);
        PartyChat.AddStringToChatWindow(Text, Color);
        ClanChat.AddStringToChatWindow(Text, Color);
        AllyChat.AddStringToChatWindow(Text, Color);
    }
    // End:0x734
    if(chkArenaChatting(Type))
    {
        showGfxChattingMessage(param);
    }
    return;
}

function showGfxChattingMessage(string param)
{
    local string FilteredMsg, Color;

    ParseString(param, "FilteredMsg", FilteredMsg);
    ParseString(param, "color", Color);
    param = "";
    ParamAdd(param, "Msg", FilteredMsg);
    ParamAdd(param, "type", string(getInstanceL2Util().2));
    ParamAdd(param, "textColor", Color);
    CallGFxFunction("GfxScreenMessage", "showMessage", param);
    return;
}

function bool chkArenaChatting(UIEventManager.EChatType Type)
{
    return getInstanceUIData().getIsArenaServer() && (((((((((int(Type) == 0) || int(Type) == 1) || int(Type) == 2) || int(Type) == 3) || int(Type) == 4) || int(Type) == 9) || int(Type) == 15) || int(Type) == 17) || int(Type) == 25) || int(Type) == 8;
    return;
}

function string InsertSHARPText(string Msg)
{
    local string MsgTemp, MsgTemp2;
    local int maxLength, i, maxSharpNum;

    maxLength = Len(Msg);
    maxSharpNum = 0;
    J0x14:

    // End:0x34 [Loop If]
    if(maxLength > (35 * (maxSharpNum + 1)))
    {
        maxSharpNum++;
        // [Loop Continue]
        goto J0x14;
    }
    i = 0;
    J0x3B:

    // End:0xBF [Loop If]
    if(i < maxSharpNum)
    {
        maxLength = Len(Msg);
        MsgTemp = Left(Msg, (35 * (i + 1)) + i);
        MsgTemp2 = Right(Msg, maxLength - ((35 * (i + 1)) + i));
        Msg = (MsgTemp $ "#") $ MsgTemp2;
        i++;
        // [Loop Continue]
        goto J0x3B;
    }
    return Msg;
    return;
}

function ShowUnionCommanderMessgage(string Msg)
{
    local string strParam;

    Msg = InsertSHARPText(Msg);
    // End:0x12F
    if(Len(Msg) > 0)
    {
        ParamAdd(strParam, "MsgType", string(1));
        ParamAdd(strParam, "WindowType", string(8));
        ParamAdd(strParam, "FontType", string(0));
        ParamAdd(strParam, "BackgroundType", string(0));
        ParamAdd(strParam, "LifeTime", string(5000));
        ParamAdd(strParam, "AnimationType", string(1));
        ParamAdd(strParam, "Msg", Msg);
        ParamAdd(strParam, "MsgColorR", string(255));
        ParamAdd(strParam, "MsgColorG", string(150));
        ParamAdd(strParam, "MsgColorB", string(149));
        ExecuteEvent(140, strParam);
    }
    return;
}

function ShowAnnounceMessgage(string Msg)
{
    local string strParam;

    Msg = InsertSHARPText(Msg);
    // End:0x12F
    if(Len(Msg) > 0)
    {
        ParamAdd(strParam, "MsgType", string(1));
        ParamAdd(strParam, "WindowType", string(8));
        ParamAdd(strParam, "FontType", string(1));
        ParamAdd(strParam, "BackgroundType", string(0));
        ParamAdd(strParam, "LifeTime", string(5000));
        ParamAdd(strParam, "AnimationType", string(1));
        ParamAdd(strParam, "Msg", Msg);
        ParamAdd(strParam, "MsgColorR", string(255));
        ParamAdd(strParam, "MsgColorG", string(150));
        ParamAdd(strParam, "MsgColorB", string(149));
        ExecuteEvent(140, strParam);
    }
    return;
}

function HandleIMEStatusChange()
{
    local string Texture;
    local UIEventManager.EIMEType imeType;

    imeType = GetCurrentIMELang();
    switch(imeType)
    {
        // End:0x42
        case 1:
            Texture = "L2UI_CH3.ChatWnd.Chatting_IMEkr";
            // End:0x269
            break;
        // End:0x71
        case 2:
            Texture = "L2UI_CH3.ChatWnd.Chatting_IMEen";
            // End:0x269
            break;
        // End:0xA0
        case 3:
            Texture = "L2UI_CH3.ChatWnd.Chatting_IMEjp";
            // End:0x269
            break;
        // End:0xCF
        case 4:
            Texture = "L2UI_CH3.ChatWnd.Chatting_IMEjp";
            // End:0x269
            break;
        // End:0xF3
        case 5:
            Texture = "L2UI.ChatWnd.IME_tw2";
            // End:0x269
            break;
        // End:0x117
        case 6:
            Texture = "L2UI.ChatWnd.IME_tw3";
            // End:0x269
            break;
        // End:0x13B
        case 7:
            Texture = "L2UI.ChatWnd.IME_tw1";
            // End:0x269
            break;
        // End:0x15F
        case 9:
            Texture = "L2UI.ChatWnd.IME_cn1";
            // End:0x269
            break;
        // End:0x183
        case 10:
            Texture = "L2UI.ChatWnd.IME_cn2";
            // End:0x269
            break;
        // End:0x1A7
        case 11:
            Texture = "L2UI.ChatWnd.IME_cn3";
            // End:0x269
            break;
        // End:0x1CB
        case 12:
            Texture = "L2UI.ChatWnd.IME_cn4";
            // End:0x269
            break;
        // End:0x1EF
        case 13:
            Texture = "L2UI.ChatWnd.IME_cn4";
            // End:0x269
            break;
        // End:0x212
        case 14:
            Texture = "L2UI.ChatWnd.IME_th";
            // End:0x269
            break;
        // End:0x239
        case 15:
            Texture = "BranchSys.symbol.IME_ru";
            // End:0x269
            break;
        // End:0xFFFF
        default:
            Texture = "L2UI_CH3.ChatWnd.Chatting_IMEen";
            // End:0x269
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x269
    m_hChatWndLanguageTexture.SetTexture(Texture);
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x269
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x269
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x269
}

function bool CheckFilter(UIEventManager.EChatType Type, int WindowType, UIEventManager.ESystemMsgType systemType)
{
    local int tempVal;

    // End:0x1E
    if((int(Type) == 22) || int(Type) == 23)
    {
    }
    // End:0x49
    if((!WindowType >= 0 && WindowType < 9) && WindowType != 9)
    {
        return false;
    }
    // End:0x74
    if((int(Type) == 8) && m_filterInfo[WindowType].bTrade != 0)
    {
        return true;        
    }
    else
    {
        // End:0x9E
        if((int(Type) == 0) && m_filterInfo[WindowType].bNormal != 0)
        {
            return true;            
        }
        else
        {
            // End:0xC9
            if((int(Type) == 4) && m_filterInfo[WindowType].bClan != 0)
            {
                return true;                
            }
            else
            {
                // End:0xF4
                if((int(Type) == 3) && m_filterInfo[WindowType].bParty != 0)
                {
                    return true;                    
                }
                else
                {
                    // End:0x11E
                    if((int(Type) == 1) && m_filterInfo[WindowType].bShout != 0)
                    {
                        return true;                        
                    }
                    else
                    {
                        // End:0x149
                        if((int(Type) == 2) && m_filterInfo[WindowType].bWhisper != 0)
                        {
                            return true;                            
                        }
                        else
                        {
                            // End:0x174
                            if((int(Type) == 9) && m_filterInfo[WindowType].bAlly != 0)
                            {
                                return true;                                
                            }
                            else
                            {
                                // End:0x19F
                                if((int(Type) == 17) && m_filterInfo[WindowType].bHero != 0)
                                {
                                    return true;                                    
                                }
                                else
                                {
                                    // End:0x1CA
                                    if((int(Type) == 20) && m_filterInfo[WindowType].bBattle != 0)
                                    {
                                        return true;                                        
                                    }
                                    else
                                    {
                                        // End:0x1FD
                                        if(((int(Type) == 10) || int(Type) == 18) || int(Type) == 7)
                                        {
                                            return true;                                            
                                        }
                                        else
                                        {
                                            // End:0x238
                                            if(((int(Type) == 16) || int(Type) == 15) && m_filterInfo[WindowType].bUnion != 0)
                                            {
                                                return true;                                                
                                            }
                                            else
                                            {
                                                // End:0x401
                                                if(int(Type) == 5)
                                                {
                                                    // End:0x269
                                                    if((int(systemType) == 2) || int(systemType) == 6)
                                                    {
                                                        return true;                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x317
                                                        if(WindowType == 9)
                                                        {
                                                            tempVal = m_bSystemMsgWnd;
                                                            // End:0x2B8
                                                            if(bool(tempVal))
                                                            {
                                                                // End:0x2B8
                                                                if(((int(systemType) == 1) || int(systemType) == 0) || int(systemType) == 9)
                                                                {
                                                                    return true;
                                                                }
                                                            }
                                                            tempVal = m_bDamageOption;
                                                            // End:0x2ED
                                                            if(bool(tempVal))
                                                            {
                                                                // End:0x2ED
                                                                if((int(systemType) == 3) || int(systemType) == 9)
                                                                {
                                                                    return true;
                                                                }
                                                            }
                                                            tempVal = m_bUseSystemItem;
                                                            // End:0x312
                                                            if(bool(tempVal))
                                                            {
                                                                // End:0x312
                                                                if(int(systemType) == 7)
                                                                {
                                                                    return true;
                                                                }
                                                            }
                                                            return false;                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x372
                                                            if(m_filterInfo[WindowType].bSystem != 0)
                                                            {
                                                                tempVal = m_bOnlyUseSystemMsgWnd;
                                                                // End:0x372
                                                                if(!bool(tempVal))
                                                                {
                                                                    // End:0x372
                                                                    if(((int(systemType) == 1) || int(systemType) == 0) || int(systemType) == 9)
                                                                    {
                                                                        return true;
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    // End:0x3BF
                                                    if(m_filterInfo[WindowType].bDamage != 0)
                                                    {
                                                        tempVal = m_bOnlyUseSystemMsgWnd;
                                                        // End:0x3BF
                                                        if(!bool(tempVal))
                                                        {
                                                            // End:0x3BF
                                                            if((int(systemType) == 3) || int(systemType) == 9)
                                                            {
                                                                return true;
                                                            }
                                                        }
                                                    }
                                                    // End:0x3FC
                                                    if(m_filterInfo[WindowType].bUseitem != 0)
                                                    {
                                                        tempVal = m_bOnlyUseSystemMsgWnd;
                                                        // End:0x3FC
                                                        if(!bool(tempVal))
                                                        {
                                                            // End:0x3FC
                                                            if(int(systemType) == 7)
                                                            {
                                                                return true;
                                                            }
                                                        }
                                                    }
                                                    return false;                                                    
                                                }
                                                else
                                                {
                                                    // End:0x43C
                                                    if(((int(Type) == 22) || int(Type) == 23) && m_filterInfo[WindowType].bNoNpcMessage != 0)
                                                    {
                                                        return true;                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x44F
                                                        if(int(Type) == 24)
                                                        {
                                                            return true;                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x485
                                                            if(((int(Type) == 25) && m_filterInfo[WindowType].bWorldChat != 0) && WindowType != 9)
                                                            {
                                                                return true;
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
    return false;
    return;
}

function InitFilterInfo()
{
    local int i, tempVal;
    local string tempstring;

    SetDefaultFilterValue();
    i = 0;
    J0x0D:

    // End:0x493 [Loop If]
    if(i < 9)
    {
        // End:0x60
        if(GetINIBool(m_sectionName[i], "system", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bSystem = tempVal;
        }
        // End:0xA5
        if(GetINIBool(m_sectionName[i], "chat", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bChat = tempVal;
        }
        // End:0xEC
        if(GetINIBool(m_sectionName[i], "normal", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bNormal = tempVal;
        }
        // End:0x132
        if(GetINIBool(m_sectionName[i], "shout", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bShout = tempVal;
        }
        // End:0x179
        if(GetINIBool(m_sectionName[i], "pledge", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bClan = tempVal;
        }
        // End:0x1BF
        if(GetINIBool(m_sectionName[i], "party", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bParty = tempVal;
        }
        // End:0x206
        if(GetINIBool(m_sectionName[i], "market", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bTrade = tempVal;
        }
        // End:0x24B
        if(GetINIBool(m_sectionName[i], "tell", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bWhisper = tempVal;
        }
        // End:0x292
        if(GetINIBool(m_sectionName[i], "damage", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bDamage = tempVal;
        }
        // End:0x2D7
        if(GetINIBool(m_sectionName[i], "ally", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bAlly = tempVal;
        }
        // End:0x320
        if(GetINIBool(m_sectionName[i], "useitems", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bUseitem = tempVal;
        }
        // End:0x365
        if(GetINIBool(m_sectionName[i], "hero", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bHero = tempVal;
        }
        // End:0x3AB
        if(GetINIBool(m_sectionName[i], "union", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bUnion = tempVal;
        }
        // End:0x3F2
        if(GetINIBool(m_sectionName[i], "battle", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bBattle = tempVal;
        }
        // End:0x43F
        if(GetINIBool(m_sectionName[i], "nonpcmessage", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bNoNpcMessage = tempVal;
        }
        // End:0x489
        if(GetINIBool(m_sectionName[i], "worldChat", tempVal, "chatfilter.ini"))
        {
            m_filterInfo[i].bWorldChat = tempVal;
        }
        ++i;
        // [Loop Continue]
        goto J0x0D;
    }
    SetDefaultFilterOn();
    m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));
    // End:0x502
    if(GetINIBool("global", "UseWorldChatSpeaker", tempVal, "chatfilter.ini"))
    {
        m_bWorldChatSpeaker = tempVal;
    }
    // End:0x53D
    if(GetINIBool("global", "UseAlpha", tempVal, "chatfilter.ini"))
    {
        m_UseAlpha = tempVal;
    }
    // End:0x57C
    if(GetINIBool("global", "keywordsound", tempVal, "chatfilter.ini"))
    {
        m_KeywordFilterSound = tempVal;
    }
    // End:0x5BE
    if(GetINIBool("global", "keywordactivate", tempVal, "chatfilter.ini"))
    {
        m_KeywordFilterActivate = tempVal;
    }
    // End:0x5F9
    if(GetINIString("global", "Keyword0", tempstring, "chatfilter.ini"))
    {
        m_Keyword0 = tempstring;
    }
    // End:0x634
    if(GetINIString("global", "Keyword1", tempstring, "chatfilter.ini"))
    {
        m_Keyword1 = tempstring;
    }
    // End:0x66F
    if(GetINIString("global", "Keyword2", tempstring, "chatfilter.ini"))
    {
        m_Keyword2 = tempstring;
    }
    // End:0x6AA
    if(GetINIString("global", "Keyword3", tempstring, "chatfilter.ini"))
    {
        m_Keyword3 = tempstring;
    }
    // End:0x6E9
    if(GetINIBool("global", "SystemMsgWnd", tempVal, "chatfilter.ini"))
    {
        m_bUseSystemMsgWnd = tempVal;
    }
    // End:0x728
    if(GetINIBool("global", "UseSystemMsg", tempVal, "chatfilter.ini"))
    {
        m_bSystemMsgWnd = tempVal;
    }
    // End:0x76D
    if(GetINIBool("global", "SystemMsgWndDamage", tempVal, "chatfilter.ini"))
    {
        m_bDamageOption = tempVal;
    }
    // End:0x7BA
    if(GetINIBool("global", "SystemMsgWndExpendableItem", tempVal, "chatfilter.ini"))
    {
        m_bUseSystemItem = tempVal;
    }
    // End:0x800
    if(GetINIBool("global", "OnlyUseSystemMsgWnd", tempVal, "chatfilter.ini"))
    {
        m_bOnlyUseSystemMsgWnd = tempVal;
    }
    return;
}

function SetDefaultFilterOn()
{
    m_filterInfo[1].bTrade = 1;
    m_filterInfo[2].bParty = 1;
    m_filterInfo[3].bClan = 1;
    m_filterInfo[4].bAlly = 1;
    return;
}

function SetCurrentDefaultFilterValue(int Type)
{
    switch(Type)
    {
        // End:0xEE
        case 0:
            m_filterInfo[0].bSystem = 1;
            m_filterInfo[0].bChat = 1;
            m_filterInfo[0].bNormal = 1;
            m_filterInfo[0].bShout = 1;
            m_filterInfo[0].bClan = 1;
            m_filterInfo[0].bParty = 1;
            m_filterInfo[0].bTrade = 0;
            m_filterInfo[0].bWhisper = 1;
            m_filterInfo[0].bDamage = 1;
            m_filterInfo[0].bAlly = 0;
            m_filterInfo[0].bUseitem = 0;
            m_filterInfo[0].bHero = 0;
            m_filterInfo[0].bUnion = 1;
            m_filterInfo[0].bBattle = 1;
            m_filterInfo[0].bNoNpcMessage = 0;
            m_filterInfo[0].bWorldChat = 1;
            // End:0x8A3
            break;
        // End:0x1D5
        case 1:
            m_filterInfo[1].bSystem = 1;
            m_filterInfo[1].bChat = 1;
            m_filterInfo[1].bNormal = 0;
            m_filterInfo[1].bShout = 1;
            m_filterInfo[1].bClan = 0;
            m_filterInfo[1].bParty = 0;
            m_filterInfo[1].bTrade = 1;
            m_filterInfo[1].bWhisper = 1;
            m_filterInfo[1].bDamage = 1;
            m_filterInfo[1].bAlly = 0;
            m_filterInfo[1].bUseitem = 0;
            m_filterInfo[1].bHero = 0;
            m_filterInfo[1].bUnion = 1;
            m_filterInfo[1].bBattle = 0;
            m_filterInfo[1].bNoNpcMessage = 0;
            m_filterInfo[1].bWorldChat = 0;
            // End:0x8A3
            break;
        // End:0x2CD
        case 2:
            m_filterInfo[2].bSystem = 1;
            m_filterInfo[2].bChat = 1;
            m_filterInfo[2].bNormal = 0;
            m_filterInfo[2].bShout = 1;
            m_filterInfo[2].bClan = 0;
            m_filterInfo[2].bParty = 1;
            m_filterInfo[2].bTrade = 0;
            m_filterInfo[2].bWhisper = 1;
            m_filterInfo[2].bDamage = 1;
            m_filterInfo[2].bAlly = 0;
            m_filterInfo[2].bUseitem = 0;
            m_filterInfo[2].bHero = 0;
            m_filterInfo[2].bUnion = 1;
            m_filterInfo[2].bBattle = 0;
            m_filterInfo[2].bNoNpcMessage = 0;
            m_filterInfo[2].bWorldChat = 0;
            // End:0x8A3
            break;
        // End:0x3C5
        case 3:
            m_filterInfo[3].bSystem = 1;
            m_filterInfo[3].bChat = 1;
            m_filterInfo[3].bNormal = 0;
            m_filterInfo[3].bShout = 1;
            m_filterInfo[3].bClan = 1;
            m_filterInfo[3].bParty = 0;
            m_filterInfo[3].bTrade = 0;
            m_filterInfo[3].bWhisper = 1;
            m_filterInfo[3].bDamage = 1;
            m_filterInfo[3].bAlly = 0;
            m_filterInfo[3].bUseitem = 0;
            m_filterInfo[3].bHero = 0;
            m_filterInfo[3].bUnion = 1;
            m_filterInfo[3].bBattle = 0;
            m_filterInfo[3].bNoNpcMessage = 0;
            m_filterInfo[3].bWorldChat = 0;
            // End:0x8A3
            break;
        // End:0x4BD
        case 4:
            m_filterInfo[4].bSystem = 1;
            m_filterInfo[4].bChat = 1;
            m_filterInfo[4].bNormal = 0;
            m_filterInfo[4].bShout = 1;
            m_filterInfo[4].bClan = 0;
            m_filterInfo[4].bParty = 0;
            m_filterInfo[4].bTrade = 0;
            m_filterInfo[4].bWhisper = 1;
            m_filterInfo[4].bDamage = 1;
            m_filterInfo[4].bAlly = 1;
            m_filterInfo[4].bUseitem = 0;
            m_filterInfo[4].bHero = 0;
            m_filterInfo[4].bUnion = 1;
            m_filterInfo[4].bBattle = 0;
            m_filterInfo[4].bNoNpcMessage = 0;
            m_filterInfo[4].bWorldChat = 0;
            // End:0x8A3
            break;
        // End:0x5B5
        case 5:
            m_filterInfo[5].bSystem = 1;
            m_filterInfo[5].bChat = 1;
            m_filterInfo[5].bNormal = 0;
            m_filterInfo[5].bShout = 1;
            m_filterInfo[5].bClan = 0;
            m_filterInfo[5].bParty = 0;
            m_filterInfo[5].bTrade = 0;
            m_filterInfo[5].bWhisper = 1;
            m_filterInfo[5].bDamage = 1;
            m_filterInfo[5].bAlly = 0;
            m_filterInfo[5].bUseitem = 0;
            m_filterInfo[5].bHero = 1;
            m_filterInfo[5].bUnion = 1;
            m_filterInfo[5].bBattle = 0;
            m_filterInfo[5].bNoNpcMessage = 0;
            m_filterInfo[5].bWorldChat = 0;
            // End:0x8A3
            break;
        // End:0x6AD
        case 6:
            m_filterInfo[6].bSystem = 1;
            m_filterInfo[6].bChat = 1;
            m_filterInfo[6].bNormal = 0;
            m_filterInfo[6].bShout = 1;
            m_filterInfo[6].bClan = 0;
            m_filterInfo[6].bParty = 0;
            m_filterInfo[6].bTrade = 0;
            m_filterInfo[6].bWhisper = 1;
            m_filterInfo[6].bDamage = 1;
            m_filterInfo[6].bAlly = 0;
            m_filterInfo[6].bUseitem = 0;
            m_filterInfo[6].bHero = 0;
            m_filterInfo[6].bUnion = 1;
            m_filterInfo[6].bBattle = 0;
            m_filterInfo[6].bNoNpcMessage = 0;
            m_filterInfo[6].bWorldChat = 0;
            // End:0x8A3
            break;
        // End:0x7A5
        case 7:
            m_filterInfo[7].bSystem = 1;
            m_filterInfo[7].bChat = 1;
            m_filterInfo[7].bNormal = 0;
            m_filterInfo[7].bShout = 1;
            m_filterInfo[7].bClan = 0;
            m_filterInfo[7].bParty = 0;
            m_filterInfo[7].bTrade = 0;
            m_filterInfo[7].bWhisper = 1;
            m_filterInfo[7].bDamage = 1;
            m_filterInfo[7].bAlly = 0;
            m_filterInfo[7].bUseitem = 0;
            m_filterInfo[7].bHero = 0;
            m_filterInfo[7].bUnion = 1;
            m_filterInfo[7].bBattle = 0;
            m_filterInfo[7].bNoNpcMessage = 0;
            m_filterInfo[7].bWorldChat = 0;
            // End:0x8A3
            break;
        // End:0x89D
        case 8:
            m_filterInfo[8].bSystem = 1;
            m_filterInfo[8].bChat = 0;
            m_filterInfo[8].bNormal = 0;
            m_filterInfo[8].bShout = 1;
            m_filterInfo[8].bClan = 0;
            m_filterInfo[8].bParty = 0;
            m_filterInfo[8].bTrade = 0;
            m_filterInfo[8].bWhisper = 1;
            m_filterInfo[8].bDamage = 1;
            m_filterInfo[8].bAlly = 0;
            m_filterInfo[8].bUseitem = 0;
            m_filterInfo[8].bHero = 0;
            m_filterInfo[8].bUnion = 1;
            m_filterInfo[8].bBattle = 0;
            m_filterInfo[8].bNoNpcMessage = 0;
            m_filterInfo[8].bWorldChat = 1;
            // End:0x8A3
            break;
        // End:0xFFFF
        default:
            // End:0x8A3
            break;
            break;
    }
    return;
}

function SetDefaultFilterValue()
{
    m_filterInfo[0].bSystem = 1;
    m_filterInfo[0].bChat = 1;
    m_filterInfo[0].bNormal = 1;
    m_filterInfo[0].bShout = 1;
    m_filterInfo[0].bClan = 1;
    m_filterInfo[0].bParty = 1;
    m_filterInfo[0].bTrade = 0;
    m_filterInfo[0].bWhisper = 1;
    m_filterInfo[0].bDamage = 1;
    m_filterInfo[0].bAlly = 0;
    m_filterInfo[0].bUseitem = 0;
    m_filterInfo[0].bHero = 0;
    m_filterInfo[0].bUnion = 1;
    m_filterInfo[0].bBattle = 1;
    m_filterInfo[0].bNoNpcMessage = 0;
    m_filterInfo[0].bWorldChat = 1;
    m_filterInfo[1].bSystem = 1;
    m_filterInfo[1].bChat = 1;
    m_filterInfo[1].bNormal = 0;
    m_filterInfo[1].bShout = 1;
    m_filterInfo[1].bClan = 0;
    m_filterInfo[1].bParty = 0;
    m_filterInfo[1].bTrade = 1;
    m_filterInfo[1].bWhisper = 1;
    m_filterInfo[1].bDamage = 1;
    m_filterInfo[1].bAlly = 0;
    m_filterInfo[1].bUseitem = 0;
    m_filterInfo[1].bHero = 0;
    m_filterInfo[1].bUnion = 1;
    m_filterInfo[1].bBattle = 0;
    m_filterInfo[1].bNoNpcMessage = 0;
    m_filterInfo[1].bWorldChat = 0;
    m_filterInfo[2].bSystem = 1;
    m_filterInfo[2].bChat = 1;
    m_filterInfo[2].bNormal = 0;
    m_filterInfo[2].bShout = 1;
    m_filterInfo[2].bClan = 0;
    m_filterInfo[2].bParty = 1;
    m_filterInfo[2].bTrade = 0;
    m_filterInfo[2].bWhisper = 1;
    m_filterInfo[2].bDamage = 1;
    m_filterInfo[2].bAlly = 0;
    m_filterInfo[2].bUseitem = 0;
    m_filterInfo[2].bHero = 0;
    m_filterInfo[2].bUnion = 1;
    m_filterInfo[2].bBattle = 0;
    m_filterInfo[2].bNoNpcMessage = 0;
    m_filterInfo[2].bWorldChat = 0;
    m_filterInfo[3].bSystem = 1;
    m_filterInfo[3].bChat = 1;
    m_filterInfo[3].bNormal = 0;
    m_filterInfo[3].bShout = 1;
    m_filterInfo[3].bClan = 1;
    m_filterInfo[3].bParty = 0;
    m_filterInfo[3].bTrade = 0;
    m_filterInfo[3].bWhisper = 1;
    m_filterInfo[3].bDamage = 1;
    m_filterInfo[3].bAlly = 0;
    m_filterInfo[3].bUseitem = 0;
    m_filterInfo[3].bHero = 0;
    m_filterInfo[3].bUnion = 1;
    m_filterInfo[3].bBattle = 0;
    m_filterInfo[3].bNoNpcMessage = 0;
    m_filterInfo[3].bWorldChat = 0;
    m_filterInfo[4].bSystem = 1;
    m_filterInfo[4].bChat = 1;
    m_filterInfo[4].bNormal = 0;
    m_filterInfo[4].bShout = 1;
    m_filterInfo[4].bClan = 0;
    m_filterInfo[4].bParty = 0;
    m_filterInfo[4].bTrade = 0;
    m_filterInfo[4].bWhisper = 1;
    m_filterInfo[4].bDamage = 1;
    m_filterInfo[4].bAlly = 1;
    m_filterInfo[4].bUseitem = 0;
    m_filterInfo[4].bHero = 0;
    m_filterInfo[4].bUnion = 1;
    m_filterInfo[4].bBattle = 0;
    m_filterInfo[4].bNoNpcMessage = 0;
    m_filterInfo[4].bWorldChat = 0;
    m_filterInfo[5].bSystem = 1;
    m_filterInfo[5].bChat = 0;
    m_filterInfo[5].bNormal = 0;
    m_filterInfo[5].bShout = 1;
    m_filterInfo[5].bClan = 0;
    m_filterInfo[5].bParty = 0;
    m_filterInfo[5].bTrade = 0;
    m_filterInfo[5].bWhisper = 1;
    m_filterInfo[5].bDamage = 1;
    m_filterInfo[5].bAlly = 0;
    m_filterInfo[5].bUseitem = 0;
    m_filterInfo[5].bHero = 1;
    m_filterInfo[5].bUnion = 1;
    m_filterInfo[5].bBattle = 0;
    m_filterInfo[5].bNoNpcMessage = 0;
    m_filterInfo[5].bWorldChat = 0;
    m_filterInfo[6].bSystem = 1;
    m_filterInfo[6].bChat = 0;
    m_filterInfo[6].bNormal = 0;
    m_filterInfo[6].bShout = 1;
    m_filterInfo[6].bClan = 0;
    m_filterInfo[6].bParty = 0;
    m_filterInfo[6].bTrade = 0;
    m_filterInfo[6].bWhisper = 1;
    m_filterInfo[6].bDamage = 1;
    m_filterInfo[6].bAlly = 0;
    m_filterInfo[6].bUseitem = 0;
    m_filterInfo[6].bHero = 0;
    m_filterInfo[6].bUnion = 1;
    m_filterInfo[6].bBattle = 0;
    m_filterInfo[6].bNoNpcMessage = 0;
    m_filterInfo[6].bWorldChat = 0;
    m_filterInfo[7].bSystem = 1;
    m_filterInfo[7].bChat = 0;
    m_filterInfo[7].bNormal = 0;
    m_filterInfo[7].bShout = 1;
    m_filterInfo[7].bClan = 0;
    m_filterInfo[7].bParty = 0;
    m_filterInfo[7].bTrade = 0;
    m_filterInfo[7].bWhisper = 1;
    m_filterInfo[7].bDamage = 1;
    m_filterInfo[7].bAlly = 0;
    m_filterInfo[7].bUseitem = 0;
    m_filterInfo[7].bHero = 0;
    m_filterInfo[7].bUnion = 1;
    m_filterInfo[7].bBattle = 0;
    m_filterInfo[7].bNoNpcMessage = 0;
    m_filterInfo[7].bWorldChat = 0;
    m_filterInfo[8].bSystem = 1;
    m_filterInfo[8].bChat = 0;
    m_filterInfo[8].bNormal = 0;
    m_filterInfo[8].bShout = 1;
    m_filterInfo[8].bClan = 0;
    m_filterInfo[8].bParty = 0;
    m_filterInfo[8].bTrade = 0;
    m_filterInfo[8].bWhisper = 1;
    m_filterInfo[8].bDamage = 1;
    m_filterInfo[8].bAlly = 0;
    m_filterInfo[8].bUseitem = 0;
    m_filterInfo[8].bHero = 0;
    m_filterInfo[8].bUnion = 1;
    m_filterInfo[8].bBattle = 0;
    m_filterInfo[8].bNoNpcMessage = 0;
    m_filterInfo[8].bWorldChat = 1;
    m_filterInfo[9].bSystem = 1;
    m_filterInfo[9].bChat = 1;
    m_filterInfo[9].bNormal = 0;
    m_filterInfo[9].bShout = 0;
    m_filterInfo[9].bClan = 0;
    m_filterInfo[9].bParty = 0;
    m_filterInfo[9].bTrade = 0;
    m_filterInfo[9].bWhisper = 0;
    m_filterInfo[9].bDamage = 0;
    m_filterInfo[9].bAlly = 0;
    m_filterInfo[9].bUseitem = 0;
    m_filterInfo[9].bHero = 0;
    m_filterInfo[9].bUnion = 0;
    m_filterInfo[9].bNoNpcMessage = 0;
    m_filterInfo[9].bWorldChat = 1;
    m_bWorldChatSpeaker = 1;
    m_bUseSystemMsgWnd = 1;
    m_bSystemMsgWnd = 1;
    m_bDamageOption = 1;
    m_bUseSystemItem = 0;
    m_NoNpcMessage = 0;
    m_KeywordFilterSound = 0;
    m_KeywordFilterActivate = 0;
    m_UseChatSymbol = 1;
    m_UseAlpha = 0;
    m_ChatResizeOnOff = 0;
    m_Keyword0 = "";
    m_Keyword1 = "";
    m_Keyword2 = "";
    m_Keyword3 = "";
    m_bOnlyUseSystemMsgWnd = 1;
    return;
}

function HandleSetString(string a_Param)
{
    local int IsAppend;
    local string tmpString;

    IsAppend = 0;
    ParseInt(a_Param, "IsAppend", IsAppend);
    // End:0x72
    if(ParseString(a_Param, "String", tmpString))
    {
        // End:0x5E
        if(IsAppend > 0)
        {
            ChatEditBox.AddString(tmpString);            
        }
        else
        {
            ChatEditBox.SetString(tmpString);
        }
    }
    return;
}

function HandleSetFocus()
{
    // End:0x23
    if(!ChatEditBox.IsFocused())
    {
        ChatEditBox.SetFocus();
    }
    return;
}

function Print(int Index)
{
    return;
}

function UIEventManager.EChatType GetChatTypeByTabIndex(int Index)
{
    local UIEventManager.EChatType Type;

    switch(m_chatType.Id)
    {
        // End:0x1B
        case 0:
            Type = 0;
            // End:0xA0
            break;
        // End:0x2A
        case 1:
            Type = 8;
            // End:0xA0
            break;
        // End:0x3A
        case 2:
            Type = 3;
            // End:0xA0
            break;
        // End:0x4A
        case 3:
            Type = 4;
            // End:0xA0
            break;
        // End:0x5A
        case 4:
            Type = 9;
            // End:0xA0
            break;
        // End:0x6A
        case 5:
            Type = 17;
            // End:0xA0
            break;
        // End:0x7A
        case 6:
            Type = 16;
            // End:0xA0
            break;
        // End:0x8A
        case 7:
            Type = 1;
            // End:0xA0
            break;
        // End:0x97
        case 8:
            Type = 25;
        // End:0xFFFF
        default:
            // End:0xA0
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A0
    return Type;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A0
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A0
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A0
}

function HandleTextLinkRButtonClick(string param)
{
    local string ChatMsg, Username;
    local int PosX, PosY, UserID;
    local UserInfo UserInfo;

    Debug("ï¿½ï¿½Å¬ï¿½ï¿½Param" @ param);
    ParseInt(param, "PosX", PosX);
    ParseInt(param, "PosY", PosY);
    ParseInt(param, "ID", UserID);
    ParseString(param, "ChatMsg", ChatMsg);
    ParseString(param, "Title", Username);
    GetPlayerInfo(UserInfo);
    // End:0xEF
    if(UserInfo.Name != Username)
    {
        // End:0xEF
        if(Username != "")
        {
            getInstanceContextMenu().execContextEvent(Username, UserID, PosX, PosY);
        }
    }
    return;
}

function HandleTextLinkLButtonClick(string param)
{
    local UIEventManager.ETextLinkType eType;
    local int Type, Id;
    local string Title, LinkName;

    ParseInt(param, "Type", Type);
    ParseInt(param, "ID", Id);
    ParseString(param, "Title", Title);
    ParseString(param, "LinkName", LinkName);
    eType = byte(Type);
    // End:0xAC
    if(int(eType) == 3)
    {
        // End:0x97
        if(Left(Title, 2) == "->")
        {
            Title = Mid(Title, 2);
        }
        SetChatMessage(("\"" $ Title) $ " ");
    }
    return;
}

function HandleDominionWarChannelSet(string param)
{
    local int DominionWarChannelSet;

    ParseInt(param, "DominionWarChannelSet", DominionWarChannelSet);
    // End:0x40
    if(DominionWarChannelSet == 1)
    {
        AddSystemMessage(2445);        
    }
    else
    {
        AddSystemMessage(2446);
    }
    return;
}

function ChangeTabChannel(int ChannelIndex)
{
    switch(ChannelIndex)
    {
        // End:0x32
        case 1:
            ChatTabCtrl.SetButtonName(m_chatType.UI, GetSystemString(355));
            // End:0x166
            break;
        // End:0x5B
        case 2:
            ChatTabCtrl.SetButtonName(m_chatType.UI, GetSystemString(188));
            // End:0x166
            break;
        // End:0x84
        case 3:
            ChatTabCtrl.SetButtonName(m_chatType.UI, GetSystemString(128));
            // End:0x166
            break;
        // End:0xB0
        case 4:
            ChatTabCtrl.SetButtonName(m_chatType.UI, GetSystemString(559));
            // End:0x166
            break;
        // End:0xDC
        case 5:
            ChatTabCtrl.SetButtonName(m_chatType.UI, GetSystemString(1961));
            // End:0x166
            break;
        // End:0x108
        case 6:
            ChatTabCtrl.SetButtonName(m_chatType.UI, GetSystemString(1962));
            // End:0x166
            break;
        // End:0x134
        case 7:
            ChatTabCtrl.SetButtonName(m_chatType.UI, GetSystemString(1963));
            // End:0x166
            break;
        // End:0x160
        case 8:
            ChatTabCtrl.SetButtonName(m_chatType.UI, GetSystemString(3234));
            // End:0x166
            break;
        // End:0xFFFF
        default:
            // End:0x166
            break;
            break;
    }
    AssignCurrentChatTypeID(ChannelIndex, m_chatType.UI);
    SetCurrentAssignedChatType2Ini(ChannelIndex, m_chatType.UI);
    return;
}

function SetDefaultAlpha(int Type)
{
    local int Alpha;

    // End:0x16
    if(Type == 0)
    {
        Alpha = 255;        
    }
    else
    {
        Alpha = 50;
    }
    m_hChatWndBodyTex.SetAlpha(Alpha, 0.0000000);
    m_hChatWndHeadTex.SetAlpha(Alpha, 0.0000000);
    m_hChatWndBottomTex.SetAlpha(Alpha, 0.0000000);
    m_hChatWndBottomTex2.SetAlpha(Alpha, 0.0000000);
    m_hChatWndBottomTex3.SetAlpha(Alpha, 0.0000000);
    m_hChatWndBottomTex4.SetAlpha(Alpha, 0.0000000);
    m_hChatWndBottomTex5.SetAlpha(Alpha, 0.0000000);
    // End:0xF2
    if(m_IsSplit1)
    {
        TradeChat.SetAlpha(Alpha, 0.0000000);        
    }
    else
    {
        TradeChat.SetAlpha(255, 0.0000000);
    }
    // End:0x12D
    if(m_IsSplit2)
    {
        PartyChat.SetAlpha(Alpha, 0.0000000);        
    }
    else
    {
        PartyChat.SetAlpha(255, 0.0000000);
    }
    // End:0x168
    if(m_IsSplit3)
    {
        ClanChat.SetAlpha(Alpha, 0.0000000);        
    }
    else
    {
        ClanChat.SetAlpha(255, 0.0000000);
    }
    // End:0x1A3
    if(m_IsSplit4)
    {
        AllyChat.SetAlpha(Alpha, 0.0000000);        
    }
    else
    {
        AllyChat.SetAlpha(255, 0.0000000);
    }
    return;
}

function OnMouseOver(WindowHandle W)
{
    local WindowHandle Parent, Target;
    local bool ChangeMain;

    ChangeMain = true;
    // End:0x2BB
    if(m_UseAlpha == 1)
    {
        Parent = W.GetParentWindowHandle();
        // End:0x9D
        if(m_IsSplit1)
        {
            // End:0x56
            if(W == TradeChat)
            {
                Target = W;
                ChangeMain = false;                
            }
            else
            {
                // End:0x7B
                if(Parent == TradeChat)
                {
                    Target = Parent;
                    ChangeMain = false;                    
                }
                else
                {
                    // End:0x9D
                    if(W == TradeChatTabButton)
                    {
                        Target = TradeChat;
                        ChangeMain = false;
                    }
                }
            }
        }
        // End:0x115
        if(m_IsSplit2)
        {
            // End:0xCB
            if(W == PartyChat)
            {
                Target = W;
                ChangeMain = false;                
            }
            else
            {
                // End:0xF0
                if(Parent == PartyChat)
                {
                    Target = Parent;
                    ChangeMain = false;                    
                }
                else
                {
                    // End:0x112
                    if(W == PartyChatTabButton)
                    {
                        Target = PartyChat;
                        ChangeMain = false;
                    }
                }
            }            
        }
        else
        {
            // End:0x18A
            if(m_IsSplit3)
            {
                // End:0x143
                if(W == ClanChat)
                {
                    Target = W;
                    ChangeMain = false;                    
                }
                else
                {
                    // End:0x168
                    if(Parent == ClanChat)
                    {
                        Target = Parent;
                        ChangeMain = false;                        
                    }
                    else
                    {
                        // End:0x18A
                        if(W == ClanChatTabButton)
                        {
                            Target = ClanChat;
                            ChangeMain = false;
                        }
                    }
                }
            }
        }
        // End:0x1FF
        if(m_IsSplit4)
        {
            // End:0x1B8
            if(W == AllyChat)
            {
                Target = W;
                ChangeMain = false;                
            }
            else
            {
                // End:0x1DD
                if(Parent == AllyChat)
                {
                    Target = Parent;
                    ChangeMain = false;                    
                }
                else
                {
                    // End:0x1FF
                    if(W == AllyChatTabButton)
                    {
                        Target = AllyChat;
                        ChangeMain = false;
                    }
                }
            }
        }
        // End:0x2A5
        if(ChangeMain)
        {
            m_hChatWndBodyTex.SetAlpha(255, 0.5000000);
            m_hChatWndHeadTex.SetAlpha(255, 0.5000000);
            m_hChatWndBottomTex.SetAlpha(255, 0.5000000);
            m_hChatWndBottomTex2.SetAlpha(255, 0.5000000);
            m_hChatWndBottomTex3.SetAlpha(255, 0.5000000);
            m_hChatWndBottomTex4.SetAlpha(255, 0.5000000);
            m_hChatWndBottomTex5.SetAlpha(255, 0.5000000);            
        }
        else
        {
            Target.SetAlpha(255, 0.5000000);
        }
    }
    return;
}

function OnMouseOut(WindowHandle W)
{
    local WindowHandle Parent, Target;
    local bool ChangeMain;

    ChangeMain = true;
    // End:0x2B8
    if(m_UseAlpha == 1)
    {
        Parent = W.GetParentWindowHandle();
        // End:0x9D
        if(m_IsSplit1)
        {
            // End:0x56
            if(W == TradeChat)
            {
                Target = W;
                ChangeMain = false;                
            }
            else
            {
                // End:0x7B
                if(Parent == TradeChat)
                {
                    Target = Parent;
                    ChangeMain = false;                    
                }
                else
                {
                    // End:0x9D
                    if(W == TradeChatTabButton)
                    {
                        Target = TradeChat;
                        ChangeMain = false;
                    }
                }
            }
        }
        // End:0x112
        if(m_IsSplit2)
        {
            // End:0xCB
            if(W == PartyChat)
            {
                Target = W;
                ChangeMain = false;                
            }
            else
            {
                // End:0xF0
                if(Parent == PartyChat)
                {
                    Target = Parent;
                    ChangeMain = false;                    
                }
                else
                {
                    // End:0x112
                    if(W == PartyChatTabButton)
                    {
                        Target = PartyChat;
                        ChangeMain = false;
                    }
                }
            }
        }
        // End:0x187
        if(m_IsSplit3)
        {
            // End:0x140
            if(W == ClanChat)
            {
                Target = W;
                ChangeMain = false;                
            }
            else
            {
                // End:0x165
                if(Parent == ClanChat)
                {
                    Target = Parent;
                    ChangeMain = false;                    
                }
                else
                {
                    // End:0x187
                    if(W == ClanChatTabButton)
                    {
                        Target = ClanChat;
                        ChangeMain = false;
                    }
                }
            }
        }
        // End:0x1FC
        if(m_IsSplit4)
        {
            // End:0x1B5
            if(W == AllyChat)
            {
                Target = W;
                ChangeMain = false;                
            }
            else
            {
                // End:0x1DA
                if(Parent == AllyChat)
                {
                    Target = Parent;
                    ChangeMain = false;                    
                }
                else
                {
                    // End:0x1FC
                    if(W == AllyChatTabButton)
                    {
                        Target = AllyChat;
                        ChangeMain = false;
                    }
                }
            }
        }
        // End:0x2A2
        if(ChangeMain)
        {
            m_hChatWndBodyTex.SetAlpha(50, 0.5000000);
            m_hChatWndHeadTex.SetAlpha(50, 0.5000000);
            m_hChatWndBottomTex.SetAlpha(50, 0.5000000);
            m_hChatWndBottomTex2.SetAlpha(50, 0.5000000);
            m_hChatWndBottomTex3.SetAlpha(50, 0.5000000);
            m_hChatWndBottomTex4.SetAlpha(50, 0.5000000);
            m_hChatWndBottomTex5.SetAlpha(50, 0.5000000);            
        }
        else
        {
            Target.SetAlpha(50, 0.5000000);
        }
    }
    return;
}

function SetCurrentAssignedChatType2Ini(int ChannelIndex, int ChatType)
{
    SetINIInt("global", "TabIndex" $ string(ChatType), ChannelIndex, "chatfilter.ini");
    return;
}

function GetAllcurrentAssignedChatTypeID()
{
    local int i, Index;

    SetINIInt("global", "TabIndex0", 0, "chatfilter.ini");
    i = 0;
    J0x31:

    // End:0x73 [Loop If]
    if(i < 5)
    {
        m_ChatUI[i].Id = i;
        m_ChatUI[i].UI = i;
        i++;
        // [Loop Continue]
        goto J0x31;
    }
    i = 1;
    J0x7A:

    // End:0x315 [Loop If]
    if(i < 5)
    {
        GetINIInt("global", "TabIndex" $ string(i), Index, "chatfilter.ini");
        // End:0x11E
        if((Index > 0) && i > 0)
        {
            m_ChatUI[i].UI = i;
            m_ChatUI[i].Id = Index;
            m_chatType.UI = i;
            ChangeTabChannel(Index);
            // [Explicit Continue]
            goto J0x30B;
        }
        AssignCurrentChatTypeID(i, i);
        switch(i)
        {
            // End:0x1A6
            case 1:
                m_ChatUI[1].Id = 1;
                ChatTabCtrl.SetButtonName(1, GetSystemString(355));
                SetINIInt("global", "TabIndex1", 1, "chatfilter.ini");
                m_chatType.UI = i;
                ChangeTabChannel(1);
                // End:0x30B
                break;
            // End:0x21A
            case 2:
                m_ChatUI[2].Id = 2;
                ChatTabCtrl.SetButtonName(2, GetSystemString(188));
                SetINIInt("global", "TabIndex2", 2, "chatfilter.ini");
                m_chatType.UI = i;
                ChangeTabChannel(2);
                // End:0x30B
                break;
            // End:0x28E
            case 3:
                m_ChatUI[3].Id = 3;
                ChatTabCtrl.SetButtonName(3, GetSystemString(128));
                SetINIInt("global", "TabIndex3", 3, "chatfilter.ini");
                m_chatType.UI = i;
                ChangeTabChannel(3);
                // End:0x30B
                break;
            // End:0x305
            case 4:
                m_ChatUI[4].Id = 4;
                ChatTabCtrl.SetButtonName(4, GetSystemString(559));
                SetINIInt("global", "TabIndex4", 4, "chatfilter.ini");
                m_chatType.UI = i;
                ChangeTabChannel(4);
                // End:0x30B
                break;
            // End:0xFFFF
            default:
                // End:0x30B
                break;
                break;
        }
        J0x30B:

        i++;
        // [Loop Continue]
        goto J0x7A;
    }
    return;
}

function AssignCurrentChatTypeID(int ChatTypeID, int ChatTypeUI)
{
    local int i;

    i = 1;
    J0x07:

    // End:0x50 [Loop If]
    if(i < 8)
    {
        // End:0x46
        if(m_ChatUI[i].UI == ChatTypeUI)
        {
            m_ChatUI[i].Id = ChatTypeID;
            // [Explicit Break]
            goto J0x50;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x50:

    return;
}

function int GetCurrentChatTypeID(int ChatTypeUI)
{
    local int i;

    i = 1;
    J0x07:

    // End:0x4B [Loop If]
    if(i < 8)
    {
        // End:0x41
        if(m_ChatUI[i].UI == ChatTypeUI)
        {
            return m_ChatUI[i].Id;
            // [Explicit Break]
            goto J0x4B;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x4B:

    return;
}

function setChatEditBox(string txt)
{
    ChatEditBox.SetString(txt);
    ChatEditBox.SetFocus();
    return;
}

function SaveChatFilterOption()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x396 [Loop If]
    if(i < m_sectionName.Length)
    {
        SetINIBool(m_sectionName[i], "system", bool(m_filterInfo[i].bSystem), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "damage", bool(m_filterInfo[i].bDamage), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "useitems", bool(m_filterInfo[i].bUseitem), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "chat", bool(m_filterInfo[i].bChat), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "normal", bool(m_filterInfo[i].bNormal), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "party", bool(m_filterInfo[i].bParty), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "shout", bool(m_filterInfo[i].bShout), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "market", bool(m_filterInfo[i].bTrade), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "pledge", bool(m_filterInfo[i].bClan), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "tell", bool(m_filterInfo[i].bWhisper), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "ally", bool(m_filterInfo[i].bAlly), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "hero", bool(m_filterInfo[i].bHero), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "union", bool(m_filterInfo[i].bUnion), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "nonpcmessage", bool(m_filterInfo[i].bNoNpcMessage), "chatfilter.ini");
        SetINIBool(m_sectionName[i], "worldChat", bool(m_filterInfo[i].bWorldChat), "chatfilter.ini");
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    SetINIBool("global", "OldChatting", bool(m_UseChatSymbol), "chatfilter.ini");
    SetINIBool("global", "keywordsound", bool(m_KeywordFilterSound), "chatfilter.ini");
    SetINIBool("global", "keywordactivate", bool(m_KeywordFilterActivate), "chatfilter.ini");
    SetINIBool("global", "UseAlpha", bool(m_UseAlpha), "chatfilter.ini");
    SetINIBool("global", "ChatResizing", bool(m_ChatResizeOnOff), "chatfilter.ini");
    SetINIBool("global", "SystemMsgWnd", bool(m_bUseSystemMsgWnd), "chatfilter.ini");
    SetINIBool("global", "OnlyUseSystemMsgWnd", bool(m_bOnlyUseSystemMsgWnd), "chatfilter.ini");
    SetINIBool("global", "UseSystemMsg", bool(m_bSystemMsgWnd), "chatfilter.ini");
    SetINIBool("global", "SystemMsgWndDamage", bool(m_bDamageOption), "chatfilter.ini");
    SetINIBool("global", "SystemMsgWndExpendableItem", bool(m_bUseSystemItem), "chatfilter.ini");
    SetINIBool("global", "UseWorldChatSpeaker", bool(m_bWorldChatSpeaker), "chatfilter.ini");
    SetINIString("global", "Keyword0", m_Keyword0, "chatfilter.ini");
    SetINIString("global", "Keyword1", m_Keyword1, "chatfilter.ini");
    SetINIString("global", "Keyword2", m_Keyword2, "chatfilter.ini");
    SetINIString("global", "Keyword3", m_Keyword3, "chatfilter.ini");
    // End:0x6AF
    if(bool(m_ChatResizeOnOff))
    {
        EnableChatWndResizing(false);        
    }
    else
    {
        EnableChatWndResizing(true);
    }
    return;
}

function LoadINIFilterSetting()
{
    local int tempVal, i, resultNum;

    i = 0;
    J0x07:

    // End:0x41D [Loop If]
    if(i < m_sectionName.Length)
    {
        GetINIBool(m_sectionName[i], "system", tempVal, "chatfilter.ini");
        m_filterInfo[i].bSystem = tempVal;
        GetINIBool(m_sectionName[i], "useitems", tempVal, "chatfilter.ini");
        m_filterInfo[i].bUseitem = tempVal;
        GetINIBool(m_sectionName[i], "damage", tempVal, "chatfilter.ini");
        m_filterInfo[i].bDamage = tempVal;
        GetINIBool(m_sectionName[i], "chat", tempVal, "chatfilter.ini");
        m_filterInfo[i].bChat = tempVal;
        GetINIBool(m_sectionName[i], "normal", tempVal, "chatfilter.ini");
        m_filterInfo[i].bNormal = tempVal;
        GetINIBool(m_sectionName[i], "party", tempVal, "chatfilter.ini");
        m_filterInfo[i].bParty = tempVal;
        GetINIBool(m_sectionName[i], "shout", tempVal, "chatfilter.ini");
        m_filterInfo[i].bShout = tempVal;
        GetINIBool(m_sectionName[i], "market", tempVal, "chatfilter.ini");
        m_filterInfo[i].bTrade = tempVal;
        GetINIBool(m_sectionName[i], "pledge", tempVal, "chatfilter.ini");
        m_filterInfo[i].bClan = tempVal;
        GetINIBool(m_sectionName[i], "tell", tempVal, "chatfilter.ini");
        m_filterInfo[i].bWhisper = tempVal;
        GetINIBool(m_sectionName[i], "ally", tempVal, "chatfilter.ini");
        m_filterInfo[i].bAlly = tempVal;
        GetINIBool(m_sectionName[i], "hero", tempVal, "chatfilter.ini");
        m_filterInfo[i].bHero = tempVal;
        GetINIBool(m_sectionName[i], "union", tempVal, "chatfilter.ini");
        m_filterInfo[i].bUnion = tempVal;
        GetINIBool(m_sectionName[i], "nonpcmessage", tempVal, "chatfilter.ini");
        m_filterInfo[i].bNoNpcMessage = tempVal;
        GetINIBool(m_sectionName[i], "worldChat", tempVal, "chatfilter.ini");
        m_filterInfo[i].bWorldChat = tempVal;
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    m_UseChatSymbol = int(GetChatFilterBool("Global", "OldChatting"));
    GetINIBool("global", "keywordsound", resultNum, "chatfilter.ini");
    m_KeywordFilterSound = resultNum;
    GetINIBool("global", "keywordactivate", resultNum, "chatfilter.ini");
    m_KeywordFilterActivate = resultNum;
    GetINIBool("global", "UseAlpha", resultNum, "chatfilter.ini");
    m_UseAlpha = resultNum;
    GetINIBool("global", "ChatResizing", resultNum, "chatfilter.ini");
    m_ChatResizeOnOff = resultNum;
    GetINIBool("global", "SystemMsgWnd", resultNum, "chatfilter.ini");
    m_bUseSystemMsgWnd = resultNum;
    GetINIBool("global", "OnlyUseSystemMsgWnd", resultNum, "chatfilter.ini");
    m_bOnlyUseSystemMsgWnd = resultNum;
    GetINIBool("global", "UseSystemMsg", resultNum, "chatfilter.ini");
    m_bSystemMsgWnd = resultNum;
    GetINIBool("global", "SystemMsgWndDamage", resultNum, "chatfilter.ini");
    m_bDamageOption = resultNum;
    GetINIBool("global", "SystemMsgWndExpendableItem", resultNum, "chatfilter.ini");
    m_bUseSystemItem = resultNum;
    GetINIBool("global", "UseWorldChatSpeaker", resultNum, "chatfilter.ini");
    m_bWorldChatSpeaker = resultNum;
    GetINIString("global", "Keyword0", m_Keyword0, "chatfilter.ini");
    GetINIString("global", "Keyword1", m_Keyword1, "chatfilter.ini");
    GetINIString("global", "Keyword2", m_Keyword2, "chatfilter.ini");
    GetINIString("global", "Keyword3", m_Keyword3, "chatfilter.ini");
    return;
}

delegate onTextComplete(string Text, byte bIsMacro)
{
    return;
}
