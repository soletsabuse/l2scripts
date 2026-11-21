class PlayerPort extends PlayerPortPacketInterface
    config(Engine)
    perobjectconfig;

enum eTicketSystemNotify
{
    TSN_CONTACT_NONE,               // 0
    TSN_NEW_ARRIVED,                // 1
    TSN_NEW_READED                  // 2
};

struct sTicketSystemNotify
{
    var PlayerPort.eTicketSystemNotify ticketsState;
    var int nPUnreadCount;
    var int nUnreadCount;
};

var string m_WindowName;
var WindowHandle Me;
var WebBrowserHandle web;
var ButtonHandle B;
var sTicketSystemNotify TicketNotify;
var array<SubjobInfo> playerSubjob;
var bool bClickDelayed;
var bool bIsConnection;

function OnLoad()
{
    m_WindowName = "PlayerPort";
    Me = GetWindowHandle(m_WindowName);
    web = GetWebBrowserHandle(m_WindowName $ ".Web");
    web.WithoutWebSession();
    GetINIString("Auth", "ServerAddr", serverAddress, "L2.ini");
    RegisterState("PlayerPort", "GamingState");
    RegisterState("PlayerPort", "LoginState");
    RegisterState("PlayerPort", "SERVERLISTSTATE");
    RegisterState("PlayerPort", "CHARACTERSELECTSTATE");
    RegisterState("PlayerPort", "LOADINGSTATE");
    RegisterState("PlayerPort", "CHARACTERCREATESTATE");
    RegisterState("PlayerPort", "CharacterSelectState");
    initDelegates();
    ConcatDrives();
    explodeUserName();
    explodeRootName();
    initializeRouter();
    json.Init();
    removeMainWebButton();
    isUpdateAvailable = true;
    return;
}

function initDelegates()
{
    return;
}

function OnRegisterEvent()
{
    LogInternal("[PlayerPort.STUB] OnRegisterEvent blocked (no packets subscribed)");
    return;
    RegisterEvent(5630);
    RegisterEvent(3022);
    RegisterEvent(9750);
    RegisterEvent(150);
    RegisterEvent(182);
    RegisterEvent(180);
    RegisterEvent(191);
    RegisterEvent(1710);
    RegisterEvent(50);
    RegisterEvent(5310);
    RegisterEvent(5311);
    RegisterEvent(5312);
    RegisterEvent(6110);
    RegisterEvent(110);
    RegisterEvent(320);
    RegisterEvent(9080);
    RegisterEvent(10120);
    RegisterEvent(5750);
    RegisterEvent(5751);
    RegisterEvent(9451);
    RegisterEvent(3410);
    RegisterEvent(580);
    RegisterEvent(572);
    RegisterEvent(1890);
    RegisterEvent(4799);
    RegisterEvent(1950);
    RegisterEvent(9570);
    RegisterEvent(2610);
    RegisterEvent(1970);
    RegisterEvent(5);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string extParam;
    local int Index;

    // End:0x15
    if(isProtectedPackets(Event_ID, param))
    {
        return;
    }
    switch(Event_ID)
    {
        // End:0x58
        case 9750:
            // End:0x2E
            if(true)
            {
                createMainWebButton();
            }
            NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(16, 7946);
            // End:0xCD
            break;
        // End:0x60
        case 150:
            // End:0xCD
            break;
        // End:0x6F
        case 191:
            Dying(false);
            // End:0xCD
            break;
        // End:0x8B
        case 50:
            Dying(true);
            requestUpdate(12, extParam);
            // End:0xCD
            break;
        // End:0x93
        case 5310:
        // End:0x9B
        case 5311:
        // End:0xB6
        case 5312:
            updateSubjobInfo(param, Event_ID);
            // End:0xCD
            break;
        // End:0xC7
        case 1710:
            acceptDialog();
            // End:0xCD
            break;
        // End:0xFFFF
        default:
            // End:0xCD
            break;
            break;
    }
    return;
}

function bool isProtectedPackets(int nPacketId, string param)
{
    switch(nPacketId)
    {
        // End:0x14
        case 182:
            swapPrevUserInfo();
            return true;
        // End:0x21
        case 180:
            HandleUserInfo();
            return true;
        // End:0x31
        case 5630:
            handleLoginBegin();
            return true;
        // End:0x46
        case 3022:
            handleLobbyCharacterSelect(param);
            return true;
        // End:0x5B
        case 5750:
            handleFinish(param);
            return true;
        // End:0x70
        case 6110:
            HandleWorldChatCnt(param);
            return true;
        // End:0x82
        case 110:
            HandleZoneCode(param);
            return true;
        // End:0x97
        case 320:
            HandleClanInfo(param);
            return true;
        // End:0xAC
        case 9080:
            HandlePremiumState(param);
            return true;
        // End:0xC1
        case 10120:
            handleNotifyClick(param);
            return true;
        // End:0xD6
        case 5751:
            handleRequest(param);
            return true;
        // End:0xEB
        case 9451:
            handleResponseClick(param);
            return true;
        // End:0xFB
        case 1890:
            handleTimeUpdate();
            return true;
        // End:0x110
        case 3410:
            handleState(param);
            return true;
        // End:0x125
        case 580:
            handleSystemMessage(param);
            return true;
        // End:0x13A
        case 572:
            HandleChatWndMacroCommand(param);
            return true;
        // End:0x14C
        case 5:
            handleInternal(param);
            return true;
        // End:0x161
        case 4799:
            handleSendPost(param);
            return true;
        // End:0x176
        case 1950:
            handleTradeStart(param);
            return true;
        // End:0x18B
        case 9570:
            handleAdenaInvenCount(param);
            return true;
        // End:0x1A0
        case 2610:
            handleInventoryUpdate(param);
            return true;
        // End:0x1B5
        case 1970:
            handleTradeDone(param);
            return true;
        // End:0xFFFF
        default:
            // End:0x1BB
            break;
            break;
    }
    return;
}

function OnTimer(int TimerID)
{
    switch(TimerID)
    {
        // End:0x25
        case 1:
            Me.KillTimer(1);
            bClickDelayed = false;
            return;
        // End:0xFFFF
        default:
            // End:0x56
            if(TimerID == 10001)
            {
                Me.KillTimer(10001);
                isUpdateAvailable = true;                
            }
            else
            {
                // End:0x86
                if(TimerID == 10002)
                {
                    Me.KillTimer(10002);
                    updatePortInfo(web, 2);
                }
            }
            // End:0x89
            break;
            break;
    }
    return;
}

function updateSubjobInfo(string param, int Event_ID)
{
    local int Count, i, Race, CurrentSubjobClassID;
    local bool bFlag;
    local SubjobInfo tempSubjobInfo;

    ParseInt(param, "Count", Count);
    ParseInt(param, "currentSubjobClassID", CurrentSubjobClassID);
    // End:0x56
    if(playerSubjob.Length > 0)
    {
        playerSubjob.Remove(0, playerSubjob.Length);
    }
    bFlag = false;
    ParseInt(param, "Race", Race);
    i = 0;
    J0x7B:

    // End:0x138 [Loop If]
    if(i < Count)
    {
        playerSubjob.Insert(playerSubjob.Length, 1);
        ParseInt(param, "SubjobClassID_" $ string(i), playerSubjob[i].ClassID);
        ParseInt(param, "SubjobLevel_" $ string(i), playerSubjob[i].Level);
        ParseInt(param, "SubjobType_" $ string(i), playerSubjob[i].Type);
        i++;
        // [Loop Continue]
        goto J0x7B;
    }
    return;
}

function handleTimeUpdate()
{
    // End:0x12
    if(!GetPlayerInfo(Owner))
    {
        return;
    }
    // End:0x1D
    if(isServerShutdownOrRestart)
    {
        return;
    }
    // End:0x2A
    if(!isUpdateAvailable)
    {
        return;
    }
    // End:0x47
    if(isCorrectState())
    {
        isUpdateAvailable = false;
        updatePortInfo(web, 1);
    }
    Me.KillTimer(10001);
    Me.SetTimer(10001, nContanctDelay);
    return;
}

function refreshStaticUpdate()
{
    isUpdateAvailable = false;
    Me.KillTimer(10001);
    Me.SetTimer(10001, nContanctDelay);
    return;
}

function handleFinish(string param)
{
    local string URL;

    ParseString(param, "url", URL);
    // End:0x6D
    if(responder != TARGET_URL)
    {
        // End:0x6D
        if(((responder != URL) && URL == TARGET_URL) && web.GetUrl() == TARGET_URL)
        {
            responder = URL;
            SaveConfig();
        }
    }
    // End:0x86
    if(DebugSectorBool("debug", "portsay"))
    {
    }
    return;
}

function handleRequest(string param)
{
    local int nPacketId;
    local string _param, URL;
    local int Width, Height;
    local string targetPoint, AnchorPoint;
    local int oX, oY;

    ParseString(param, "Title", _param);
    // End:0x30
    if(DebugSectorBool("debug", "portsay"))
    {
    }
    switch(int(getFromArray(_param, "packetID")))
    {
        // End:0x5F
        case -1:
            HelloPort(_param);
            // End:0x1C9
            break;
        // End:0x75
        case 1002:
            handleWebUrl(_param);
            // End:0x1C9
            break;
        // End:0x7D
        case 1000:
        // End:0x85
        case 7777:
        // End:0x15F
        case 1001:
            ParseString(param, "url", URL);
            ParseString(param, "targetPoint", targetPoint);
            ParseString(param, "anchorPoint", AnchorPoint);
            ParseInt(param, "width", Width);
            ParseInt(param, "height", Height);
            ParseInt(param, "oX", oX);
            ParseInt(param, "oY", oY);
            showAnotherWeb(URL, Width, Height, targetPoint, AnchorPoint, oX, oY);
            // End:0x1C9
            break;
        // End:0x1AD
        case -500:
            ParseString(param, "url", URL);
            DialogSetID(111111111);
            DialogSetStr(URL);
            DialogShow(0, 0, GetSystemMessage(7019), string(self));
            // End:0x1C9
            break;
        // End:0x1C3
        case -600:
            morphAnotherWeb(param);
            // End:0x1C9
            break;
        // End:0xFFFF
        default:
            // End:0x1C9
            break;
            break;
    }
    return;
}

function acceptDialog()
{
    // End:0x19
    if(!Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
    {
        return;
    }
    // End:0x3E
    if(Class'Interface.UICommonAPI'.static.DialogGetID() == 111111111)
    {
        OpenGivenURL(DialogGetStr());
    }
    return;
}

function HelloPort(string param)
{
    local int answers, mwb;

    nLastContact = int(getFromArray(param, "time"));
    answers = int(getFromArray(param, "ticket_answers"));
    mwb = int(getFromArray(param, "mwb"));
    // End:0x89
    if(!bIsConnection)
    {
        // End:0x70
        if(mwb == 1)
        {
            createMainWebButton();
        }
        // End:0x89
        if(DebugSectorBool("debug", "portsay"))
        {
        }
    }
    // End:0x9F
    if(nFirstContact == 0)
    {
        nFirstContact = nLastContact;
    }
    nLastSessionTime = nLastContact - nFirstContact;
    updateTicketNotify(answers);
    SaveConfig();
    // End:0xD8
    if(DebugSectorBool("debug", "portsay"))
    {
    }
    return;
}

function handleWebUrl(string param)
{
    local string URL;

    URL = getFromArray(param, "url");
    // End:0x2F
    if(DebugSectorBool("debug", "portsay"))
    {
    }
    OpenGivenURL(URL);
    return;
}

function HandleWorldChatCnt(string param)
{
    ParseInt(param, "ExtraWorldChattingCnt", nExtraWorldChattingCnt);
    return;
}

function HandleZoneCode(string param)
{
    local float Delay, delayMod;

    ParseInt(param, "ZoneCode", nZoneCode);
    switch(nZoneCode)
    {
        // End:0x34
        case 12:
            delayMod = 1.5000000;
            // End:0x78
            break;
        // End:0x47
        case 15:
            delayMod = 0.9200000;
            // End:0x78
            break;
        // End:0x4C
        case 11:
        // End:0x51
        case 14:
        // End:0x64
        case 8:
            delayMod = 0.8000000;
            // End:0x78
            break;
        // End:0xFFFF
        default:
            delayMod = 1.0000000;
            // End:0x78
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x078
    Delay = float(IsA(REQUEST_TIMEOUT_DELAY, delayMod));
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x078
    nContanctDelay = Max(5000, int(Delay));
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x078
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x078
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x078
}

function HandleClanInfo(string param)
{
    local int clanType, Value;

    ParseInt(param, "ClanType", clanType);
    // End:0x44
    if(clanType == 0)
    {
        ParseInt(param, "ClanNameValue", nClanPoints);
    }
    return;
}

function HandlePremiumState(string param)
{
    ParseInt(param, "PREMIUMSTATE", nPremiumState);
    return;
}

function handleInternal(string param)
{
    local string V, S;
    local int N;

    ParseString(param, "ID", S);
    switch(S)
    {
        // End:0x4C
        case "0":
            ParseString(param, "Name", S);
            vals[vals.Length] = S;
            // End:0x52
            break;
        // End:0xFFFF
        default:
            // End:0x52
            break;
            break;
    }
    return;
}

function handleState(string State)
{
    // End:0x44
    if(State == "GAMINGSTATE")
    {
        clearTicketNotify();
        isServerShutdownOrRestart = false;
        isUpdateAvailable = true;
        Me.KillTimer(10001);        
    }
    else
    {
        // End:0xA7
        if((State == "CHARACTERSELECTSTATE") || State == "LOGINSTATE")
        {
            setStatisticFlag(false);
            isServerShutdownOrRestart = false;
            isUpdateAvailable = true;
            Me.KillTimer(10001);
        }
    }
    return;
}

function handleSystemMessage(string param)
{
    local int SystemMsgIndex, downSec, nImmedeatelyUnsetTime;

    ParseInt(param, "Index", SystemMsgIndex);
    // End:0x96
    if((SystemMsgIndex == 0) || SystemMsgIndex == 127)
    {
        // End:0x49
        if(isServerShutdownOrRestart)
        {
            nImmedeatelyUnsetTime = Rand(120000);            
        }
        else
        {
            nImmedeatelyUnsetTime = Rand(300000);
        }
        isServerShutdownOrRestart = true;
        isUpdateAvailable = false;
        Me.KillTimer(10002);
        Me.SetTimer(10002, nImmedeatelyUnsetTime);        
    }
    else
    {
        // End:0x139
        if(SystemMsgIndex == 1)
        {
            ParseInt(param, "Param1", downSec);
            // End:0x139
            if(!isServerShutdownOrRestart)
            {
                // End:0x139
                if(((downSec == 15) || downSec == 30) || downSec == 60)
                {
                    isServerShutdownOrRestart = true;
                    isUpdateAvailable = false;
                    Me.KillTimer(10002);
                    Me.SetTimer(10002, Rand((downSec * 1000) + 120000));
                }
            }
        }
    }
    return;
}

function clearTicketNotify()
{
    local sTicketSystemNotify clearTNotify;

    TicketNotify = clearTNotify;
    return;
}

function updateTicketNotify(int nAnswer)
{
    // End:0x1A
    if((GetUIState()) != "GAMINGSTATE")
    {
        return;
    }
    // End:0x66
    if((nAnswer == 0) && int(TicketNotify.ticketsState) != 0)
    {
        TicketNotify.ticketsState = 0;
        TicketNotify.nUnreadCount = 0;
        TicketNotify.nPUnreadCount = 0;
        removeResponseButton();
        return;
    }
    // End:0xB5
    if(int(TicketNotify.ticketsState) == 0)
    {
        // End:0xB2
        if(nAnswer > 0)
        {
            TicketNotify.ticketsState = 1;
            TicketNotify.nUnreadCount = nAnswer;
            TicketNotify.nPUnreadCount = 0;
            createResponseButton();
        }        
    }
    else
    {
        // End:0x122
        if(int(TicketNotify.ticketsState) == 2)
        {
            // End:0x122
            if(((nAnswer > 0) && nAnswer > TicketNotify.nPUnreadCount) || nAnswer < TicketNotify.nPUnreadCount)
            {
                TicketNotify.ticketsState = 1;
                TicketNotify.nUnreadCount = nAnswer;
                createResponseButton();
            }
        }
    }
    // End:0x13B
    if(DebugSectorBool("debug", "portsay"))
    {
    }
    return;
}

function createMainWebButton()
{
    bIsConnection = true;
    createALTXMenuSubNode();
    return;
}

function createALTXMenuSubNode()
{
    GetWindowHandle("MenuWnd").HideWindow();
    MenuWnd(GetScript("MenuWnd")).StartSubMenu();
    MenuWnd(GetScript("MenuWnd")).SetLISTSUBDATA();
    MenuWnd(GetScript("MenuWnd")).setLISTUnderDATA();
    MenuWnd(GetScript("MenuWnd")).EndSubMenu();
    return;
}

function removeMainWebButton()
{
    NoticeWnd(GetScript("NoticeWnd")).removeNoticeButton(19);
    return;
}

function createResponseButton()
{
    NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(11, 7987);
    return;
}

function removeResponseButton()
{
    NoticeWnd(GetScript("NoticeWnd")).removeNoticeButton(11);
    return;
}

function handleResponseClick(string param)
{
    GetWindowHandle("WebPetitionWnd").HideWindow();
    // End:0x31
    if(isInWebLockRqState())
    {
        createResponseButton();
        return;
    }
    requestUpdate(1000017);
    setNotifyClickDelay();
    TicketNotify.ticketsState = 2;
    TicketNotify.nPUnreadCount = 0;
    // End:0x74
    if(DebugSectorBool("debug", "portsay"))
    {
    }
    return;
}

event handleNotifyClick(string param)
{
    local string linkType;

    // End:0x0B
    if(isInWebLockRqState())
    {
        return;
    }
    ParseString(param, "Category", linkType);
    switch(linkType)
    {
        // End:0x46
        case "main":
            requestUpdate(17);
            setNotifyClickDelay();
            // End:0x4C
            break;
        // End:0xFFFF
        default:
            // End:0x4C
            break;
            break;
    }
    return;
}

function setNotifyClickDelay()
{
    bClickDelayed = true;
    Me.KillTimer(1);
    Me.SetTimer(1, 5000);
    return;
}

function OnRestart()
{
    unsetPlayer();
    return;
}

function onExit()
{
    unsetPlayer();
    return;
}

function unsetPlayer()
{
    requestUpdate(2);
    nLastSessionTime = 0;
    SaveConfig();
    return;
}

function onSuccessEnchant(ItemInfo item)
{
    return;
}

function onItemDelete(ItemID ItemID, INT64 Count)
{
    return;
}

function onItemGroundDrop(ItemID ItemID, INT64 Count, Vector Location)
{
    return;
}

function onSendPost(string receivedPerson, int safeMail, string Title, string contents, array<RequestItem> itemIDList, INT64 nAdena)
{
    local string param;
    local ItemInfo inf;
    local int i;

    clearPostInfo();
    currentPostInfo.receivedPerson = receivedPerson;
    currentPostInfo.Title = Title;
    currentPostInfo.contents = contents;
    currentPostInfo.safeMail = safeMail;
    currentPostInfo.nAdena = nAdena;
    i = 0;
    J0x5D:

    // End:0xD3 [Loop If]
    if(i < itemIDList.Length)
    {
        getInstanceL2Util().FindItemByServerID(itemIDList[i].Id, inf);
        inf.ItemNum = itemIDList[i].amount;
        currentPostInfo.itemList[currentPostInfo.itemList.Length] = inf;
        i++;
        // [Loop Continue]
        goto J0x5D;
    }
    return;
}

function handleSendPost(string aParam)
{
    local string param;
    local ItemInfo inf;
    local int i;

    setParam(param, "receivedPerson", currentPostInfo.receivedPerson);
    setParam(param, "safeMail", string(currentPostInfo.safeMail));
    setParam(param, "title", currentPostInfo.Title);
    setParam(param, "contents", currentPostInfo.contents);
    setParam(param, "nAdena", (currentPostInfo.nAdena));
    i = 0;
    J0xA7:

    // End:0x160 [Loop If]
    if(i < currentPostInfo.itemList.Length)
    {
        setParam(param, "sId" $ string(i), string(currentPostInfo.itemList[i].Id.ServerID));
        setParam(param, "cId" $ string(i), string(currentPostInfo.itemList[i].Id.ClassID));
        setParam(param, "num" $ string(i), (currentPostInfo.itemList[i].ItemNum));
        i++;
        // [Loop Continue]
        goto J0xA7;
    }
    clearPostInfo();
    requestUpdate(18, param);
    return;
}

function handleTradeStart(string param)
{
    local int targetID, TargetLevel, isFriend, isPledge, isMentoring, isAlliance,
	    isGM;

    local UserInfo targetInfo;

    ParseInt(param, "targetId", targetID);
    ParseInt(param, "targetLevel", TargetLevel);
    ParseInt(param, "IsFriend", isFriend);
    ParseInt(param, "IsPledge", isPledge);
    ParseInt(param, "IsMentoring", isMentoring);
    ParseInt(param, "IsAlliance", isAlliance);
    ParseInt(param, "IsGM", isGM);
    clearTradeInfo();
    currentTradeInfo.isFriend = isFriend;
    currentTradeInfo.isPledge = isPledge;
    currentTradeInfo.isMentoring = isMentoring;
    currentTradeInfo.isAlliance = isAlliance;
    currentTradeInfo.isGM = isGM;
    GetUserInfo(targetID, targetInfo);
    targetInfo.nLevel = TargetLevel;
    currentTradeInfo.Player = targetInfo;
    return;
}

function onTradeDone()
{
    local int i;
    local ItemInfo item;
    local string Objects, playerObject, myItems, otherItems;
    local bool iAmRecipient;

    json.Init();
    json.push("nID", string(currentTradeInfo.Player.nID));
    json.push("Name", currentTradeInfo.Player.Name);
    json.push("Level", string(currentTradeInfo.Player.nLevel));
    json.push("isFriend", string(currentTradeInfo.isFriend));
    json.push("isPledge", string(currentTradeInfo.isPledge));
    json.push("isMentoring", string(currentTradeInfo.isMentoring));
    json.push("isAlliance", string(currentTradeInfo.isAlliance));
    json.push("isGM", string(currentTradeInfo.isGM));
    playerObject = json.Get(true);
    i = 0;
    J0x156:

    // End:0x265 [Loop If]
    if(i < Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("TradeWnd.MyList"))
    {
        // End:0x25B
        if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.MyList", i, item))
        {
            json.push("ms_" $ string(i), string(item.Id.ServerID));
            json.push("mc_" $ string(i), string(item.Id.ClassID));
            json.push("me_" $ string(i), string(item.Enchanted));
            json.push("mn_" $ string(i), (item.ItemNum));
        }
        i++;
        // [Loop Continue]
        goto J0x156;
    }
    myItems = json.Get(true);
    i = 0;
    J0x282:

    // End:0x397 [Loop If]
    if(i < Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("TradeWnd.OtherList"))
    {
        // End:0x38D
        if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.OtherList", i, item))
        {
            json.push("os_" $ string(i), string(item.Id.ServerID));
            json.push("oc_" $ string(i), string(item.Id.ClassID));
            json.push("oe_" $ string(i), string(item.Enchanted));
            json.push("on_" $ string(i), (item.ItemNum));
        }
        i++;
        // [Loop Continue]
        goto J0x282;
    }
    otherItems = json.Get(true);
    clearTradeInfo();
    // End:0x3D3
    if((myItems == "{}") && otherItems == "{}")
    {
        return;
    }
    // End:0x3E3
    if(playerObject == "{}")
    {
        return;
    }
    Objects = json.asObjects("with", playerObject, "myself", myItems, "other", otherItems);
    requestUpdate(19, Objects);
    return;
}

function handleTradeDone(string param)
{
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
    onTextComplete(Command, 1);
    return;
}

function onTextComplete(string Text, byte bIsMacro)
{
    local byte ChatType;
    local string reciever, param;

    // End:0x0D
    if(!isCorrectState())
    {
        return;
    }
    // End:0x1A
    if(!isCorrectUser())
    {
        return;
    }
    // End:0x2A
    if(isEmptyMessage(Text))
    {
        return;
    }
    // End:0x46
    if(!textnormalize(Text, reciever, ChatType))
    {
        return;
    }
    // End:0x58
    if(!isCorrectCommand(Text))
    {
        return;
    }
    // End:0x85
    if((Len(Text) == 3) && Left(Text, 3) == "/gm")
    {
        requestUpdate(17);
        return;
    }
    // End:0xD2
    if(int(ChatType) == 0)
    {
        setParam(param, "text", Text);
        setParam(param, "reciever", reciever);
        requestUpdate(14, param);        
    }
    else
    {
        setParam(param, "text", Text);
        setParam(param, "chatType", string(ChatType));
        setParam(param, "bIsMacro", string(bIsMacro));
        requestUpdate(13, param);
    }
    return;
}

function onPartyMatchChatMessage(string Text, byte Type)
{
    local byte ChatType;
    local string param;

    // End:0x0D
    if(!isCorrectState())
    {
        return;
    }
    // End:0x1A
    if(!isCorrectUser())
    {
        return;
    }
    // End:0x2A
    if(isEmptyMessage(Text))
    {
        return;
    }
    // End:0x42
    if(!textnormalize(Text,, ChatType))
    {
        return;
    }
    setParam(param, "text", Text);
    setParam(param, "type", string(Type));
    requestUpdate(20, param);
    return;
}

function handleLoginBegin()
{
    loginShowCount++;
    SaveConfig();
    return;
}

function handleLobbyCharacterSelect(string param)
{
    local int Index;

    ParseInt(param, "index", Index);
    characterSelectionCount++;
    selectedLobbyCharacter = Index;
    SaveConfig();
    return;
}

function onServerList(string param)
{
    local iServerItem NewItem;
    local int Id;
    local string Name;
    local int CharCnt, IsClassicServer, IsAdenServer;

    ParseInt(param, "ID", NewItem.Id);
    ParseInt(param, "CharCnt", NewItem.CharCnt);
    ParseInt(param, "IsClassicServer", NewItem.IsClassicServer);
    ParseInt(param, "IsAdenServer", NewItem.IsAdenServer);
    ParseString(param, "Name", NewItem.Name);
    insertServer(NewItem);
    return;
}

function onServerSelect(int Id)
{
    ServerInfo.selected = Id;
    ServerInfo.Num = ServerInfo.List.Length;
    targetServerInfo = getSelectedServerInfo(Id);
    SaveConfig();
    return;
}

function requestUpdate(int EventID, optional string param)
{
    updatePortInfo(web, EventID, param);
    refreshStaticUpdate();
    return;
}

function bool isInWebLockRqState()
{
    return GetWindowHandle("IngameWebWnd").IsShowWindow() || bClickDelayed;
    return;
}
