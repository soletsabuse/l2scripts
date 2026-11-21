class PostBoxWnd extends UICommonAPI;

const MAIL_PER_PAGE = 8;
const MAX_PAGE_NUM = 3;
const RECEIVED_WINDOW_TAB = 0;
const SENT_WINDOW_TAB = 1;
const TRADE_NORMAL = 0;
const TRADE_SAFE = 1;
const DIALOG_DELETE_SELECTED_RECEIVED_MAIL = 1111;
const DIALOG_NO_DETECTED_DELETE_RECEIVED_MAIL = 2222;
const DIALOG_DELETE_SELECTED_SENT_MAIL = 3333;
const DIALOG_NO_DETECTED_DELETE_SENT_MAIL = 4444;
const DIALOG_CONFIRM_TRADE_POST = 5555;

struct ReceivedPostMSG
{
    var int mailID;
    var string Title;
    var string senderName;
    var int TRADE;
    var int notOpend;
    var int returnAble;
    var int withItem;
    var int returnd;
    var int sentBySystem;
    var float diffTime;
    var int CheckBoxState;
};

struct SentPostMSG
{
    var int mailID;
    var string Title;
    var string receivername;
    var int TRADE;
    var int notOpend;
    var int returnAble;
    var int withItem;
    var int sentBySystem;
    var float diffTime;
    var int CheckBoxState;
};

var WindowHandle Me;
var WindowHandle ReceivePost;
var WindowHandle sendPost;
var WindowHandle PostWriteWnd;
var WindowHandle PostDetailWnd_General;
var WindowHandle PostDetailWnd_SafetyTrade;
var TabHandle TabCtrl;
var TextureHandle TexTabBg;
var TextureHandle TexTabBgLine;
var TextureHandle GroupBox;
var TextureHandle ReceiveGroupLine;
var TextureHandle ReceiveSafetyTradeIcon;
var TextureHandle ReceiveAccompanyIcon;
var TextureHandle ReceivePostListDeco;
var TextureHandle SendGroupLine;
var TextureHandle SendSafetyTradeIcon;
var TextureHandle SendAccompanyIcon;
var TextureHandle SendPostListDeco;
var TextBoxHandle ReceiveListNumber;
var TextBoxHandle SendListNumber;
var ButtonHandle ReceiveListPrevBtn;
var ButtonHandle ReceiveListNextBtn;
var ButtonHandle ReceiveDelBtn;
var ButtonHandle ReceiveAllBtn;
var ButtonHandle PostSendBtn;
var ButtonHandle SendListPrevBtn;
var ButtonHandle SendListNextBtn;
var ButtonHandle SendDelBtn;
var ButtonHandle PaymentPostSendBtn;
var ListCtrlHandle ReceivedPostList;
var ListCtrlHandle SentPostList;
var CheckBoxHandle ReceivePostCheck_all;
var CheckBoxHandle ReceivePostCheck[8];
var CheckBoxHandle SendPostCheck_all;
var CheckBoxHandle SendPostCheck[8];
var array<ReceivedPostMSG> receivedInfoList;
var array<SentPostMSG> sentInfoList;
var int ReceivedPageNum;
var int SentPageNum;
var int curReceivedPage;
var int curSentPage;
var int ReceivedPageFullCheckState[3];
var int SentPageFullCheckState[3];
var int zonetype;
var string m_WindowName;
var int checkState[8];
var Color notReadPostColor;
var Color readPostColor;
var Color tradePostColor;
var Color tradereadPostColor;

function OnRegisterEvent()
{
    RegisterEvent(4700);
    RegisterEvent(4710);
    RegisterEvent(4720);
    RegisterEvent(4730);
    RegisterEvent(4750);
    RegisterEvent(4760);
    RegisterEvent(4770);
    RegisterEvent(1710);
    RegisterEvent(4793);
    RegisterEvent(4794);
    RegisterEvent(4795);
    RegisterEvent(4796);
    RegisterEvent(4797);
    RegisterEvent(4798);
    RegisterEvent(110);
    RegisterEvent(4970);
    RegisterEvent(4980);
    RegisterEvent(4990);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x23
    if(1 == 0)
    {
        Initialize();        
    }
    else
    {
        InitializeCOD();
    }
    Me.HideWindow();
    notReadPostColor.R = 220;
    notReadPostColor.G = 220;
    notReadPostColor.B = 220;
    readPostColor.R = 130;
    readPostColor.G = 130;
    readPostColor.B = 130;
    tradePostColor.R = byte(255);
    tradePostColor.G = 114;
    tradePostColor.B = 0;
    tradereadPostColor.R = 145;
    tradereadPostColor.G = 84;
    tradereadPostColor.B = 35;
    return;
}

function Initialize()
{
    local int i;

    Me = GetHandle(m_WindowName);
    ReceivePost = GetHandle(m_WindowName $ ".ReceivePost");
    sendPost = GetHandle(m_WindowName $ ".SendPost");
    PostWriteWnd = GetHandle("PostWriteWnd");
    PostDetailWnd_General = GetHandle("PostDetailWnd_General");
    PostDetailWnd_SafetyTrade = GetHandle("PostDetailWnd_SafetyTrade");
    ReceiveListNumber = TextBoxHandle(GetHandle(m_WindowName $ ".ReceiveListNumber"));
    SendListNumber = TextBoxHandle(GetHandle(m_WindowName $ ".SendListNumber"));
    ReceivedPostList = ListCtrlHandle(GetHandle(m_WindowName $ ".ReceivePostList"));
    SentPostList = ListCtrlHandle(GetHandle(m_WindowName $ ".SendPostList"));
    TabCtrl = TabHandle(GetHandle(m_WindowName $ ".TabCtrl"));
    TexTabBg = TextureHandle(GetHandle(m_WindowName $ ".TexTabBg"));
    TexTabBgLine = TextureHandle(GetHandle(m_WindowName $ ".TexTabBgLine"));
    GroupBox = TextureHandle(GetHandle(m_WindowName $ ".groupbox"));
    ReceiveGroupLine = TextureHandle(GetHandle(m_WindowName $ ".ReceiveGroupLine"));
    ReceiveSafetyTradeIcon = TextureHandle(GetHandle(m_WindowName $ ".ReceiveSafetyTradeIcon"));
    ReceiveAccompanyIcon = TextureHandle(GetHandle(m_WindowName $ ".ReceiveAccompanyIcon"));
    ReceivePostListDeco = TextureHandle(GetHandle(m_WindowName $ ".ReceivePostListDeco"));
    SendGroupLine = TextureHandle(GetHandle(m_WindowName $ ".SendGroupLine"));
    SendSafetyTradeIcon = TextureHandle(GetHandle(m_WindowName $ ".SendSafetyTradeIcon"));
    SendAccompanyIcon = TextureHandle(GetHandle(m_WindowName $ ".SendAccompanyIcon"));
    SendPostListDeco = TextureHandle(GetHandle(m_WindowName $ ".SendPostListDeco"));
    ReceivePostCheck_all = CheckBoxHandle(GetHandle(m_WindowName $ ".ReceivePostCheck_all"));
    i = 0;
    J0x385:

    // End:0x3D6 [Loop If]
    if(i < 8)
    {
        ReceivePostCheck[i] = CheckBoxHandle(GetHandle((m_WindowName $ ".ReceivePostCheck_") $ string(i)));
        i++;
        // [Loop Continue]
        goto J0x385;
    }
    SendPostCheck_all = CheckBoxHandle(GetHandle(m_WindowName $ ".SendPostCheck_all"));
    i = 0;
    J0x409:

    // End:0x457 [Loop If]
    if(i < 8)
    {
        SendPostCheck[i] = CheckBoxHandle(GetHandle((m_WindowName $ ".SendPostCheck_") $ string(i)));
        i++;
        // [Loop Continue]
        goto J0x409;
    }
    ReceiveListPrevBtn = ButtonHandle(GetHandle(m_WindowName $ ".ReceiveListPrevBtn"));
    ReceiveListNextBtn = ButtonHandle(GetHandle(m_WindowName $ ".ReceiveListNextBtn"));
    ReceiveDelBtn = ButtonHandle(GetHandle(m_WindowName $ ".ReceiveDelBtn"));
    ReceiveAllBtn = ButtonHandle(GetHandle(m_WindowName $ ".ReceiveAllBtn"));
    PostSendBtn = ButtonHandle(GetHandle(m_WindowName $ ".PostSendBtn"));
    PaymentPostSendBtn = ButtonHandle(GetHandle(m_WindowName $ ".PaymentPostSendBtn"));
    SendListPrevBtn = ButtonHandle(GetHandle(m_WindowName $ ".SendListPrevBtn"));
    SendListNextBtn = ButtonHandle(GetHandle(m_WindowName $ ".SendListNextBtn"));
    SendDelBtn = ButtonHandle(GetHandle(m_WindowName $ ".SendDelBtn"));
    return;
}

function InitializeCOD()
{
    local int i;

    Me = GetWindowHandle(m_WindowName);
    ReceivePost = GetWindowHandle(m_WindowName $ ".ReceivePost");
    sendPost = GetWindowHandle(m_WindowName $ ".SendPost");
    PostWriteWnd = GetWindowHandle("PostWriteWnd");
    PostDetailWnd_General = GetWindowHandle("PostDetailWnd_General");
    PostDetailWnd_SafetyTrade = GetWindowHandle("PostDetailWnd_SafetyTrade");
    ReceiveListNumber = GetTextBoxHandle(m_WindowName $ ".ReceiveListNumber");
    SendListNumber = GetTextBoxHandle(m_WindowName $ ".SendListNumber");
    ReceivedPostList = GetListCtrlHandle(m_WindowName $ ".ReceivePostList");
    SentPostList = GetListCtrlHandle(m_WindowName $ ".SendPostList");
    TabCtrl = GetTabHandle(m_WindowName $ ".TabCtrl");
    TexTabBg = GetTextureHandle(m_WindowName $ ".TexTabBg");
    TexTabBgLine = GetTextureHandle(m_WindowName $ ".TexTabBgLine");
    GroupBox = GetTextureHandle(m_WindowName $ ".groupbox");
    ReceiveGroupLine = GetTextureHandle(m_WindowName $ ".ReceiveGroupLine");
    ReceiveSafetyTradeIcon = GetTextureHandle(m_WindowName $ ".ReceiveSafetyTradeIcon");
    ReceiveAccompanyIcon = GetTextureHandle(m_WindowName $ ".ReceiveAccompanyIcon");
    ReceivePostListDeco = GetTextureHandle(m_WindowName $ ".ReceivePostListDeco");
    SendGroupLine = GetTextureHandle(m_WindowName $ ".SendGroupLine");
    SendSafetyTradeIcon = GetTextureHandle(m_WindowName $ ".SendSafetyTradeIcon");
    SendAccompanyIcon = GetTextureHandle(m_WindowName $ ".SendAccompanyIcon");
    SendPostListDeco = GetTextureHandle(m_WindowName $ ".SendPostListDeco");
    ReceivePostCheck_all = GetCheckBoxHandle(m_WindowName $ ".ReceivePostCheck_all");
    i = 0;
    J0x330:

    // End:0x37C [Loop If]
    if(i < 8)
    {
        ReceivePostCheck[i] = GetCheckBoxHandle((m_WindowName $ ".ReceivePostCheck_") $ string(i));
        i++;
        // [Loop Continue]
        goto J0x330;
    }
    SendPostCheck_all = GetCheckBoxHandle(m_WindowName $ ".SendPostCheck_all");
    i = 0;
    J0x3AA:

    // End:0x3F3 [Loop If]
    if(i < 8)
    {
        SendPostCheck[i] = GetCheckBoxHandle((m_WindowName $ ".SendPostCheck_") $ string(i));
        i++;
        // [Loop Continue]
        goto J0x3AA;
    }
    ReceiveListPrevBtn = GetButtonHandle(m_WindowName $ ".ReceiveListPrevBtn");
    ReceiveListNextBtn = GetButtonHandle(m_WindowName $ ".ReceiveListNextBtn");
    ReceiveDelBtn = GetButtonHandle(m_WindowName $ ".ReceiveDelBtn");
    ReceiveAllBtn = GetButtonHandle(m_WindowName $ ".ReceiveAllBtn");
    PostSendBtn = GetButtonHandle(m_WindowName $ ".PostSendBtn");
    PaymentPostSendBtn = GetButtonHandle(m_WindowName $ ".PaymentPostSendBtn");
    SendListPrevBtn = GetButtonHandle(m_WindowName $ ".SendListPrevBtn");
    SendListNextBtn = GetButtonHandle(m_WindowName $ ".SendListNextBtn");
    SendDelBtn = GetButtonHandle(m_WindowName $ ".SendDelBtn");
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    getInstanceL2Util().checkIsPrologueGrowType(string(self));
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x12
        case 4700:
            // End:0x1F0
            break;
        // End:0x28
        case 4710:
            OnEVStartReceivedPostList(param);
            // End:0x1F0
            break;
        // End:0x3E
        case 4720:
            OnEVAddReceivedPostList(param);
            // End:0x1F0
            break;
        // End:0x4F
        case 4730:
            OnEVEndReceivedPostList();
            // End:0x1F0
            break;
        // End:0x65
        case 4750:
            OnEVStartSentPostList(param);
            // End:0x1F0
            break;
        // End:0x7B
        case 4760:
            OnEVAddSentPostList(param);
            // End:0x1F0
            break;
        // End:0x8C
        case 4770:
            OnEVEndSentPostList();
            // End:0x1F0
            break;
        // End:0x9D
        case 1710:
            OnEVDialogOk();
            // End:0x1F0
            break;
        // End:0xB3
        case 4793:
            OnDeleteReceivedPost(param);
            // End:0x1F0
            break;
        // End:0xC9
        case 4794:
            OnOpenStateReceivedPost(param);
            // End:0x1F0
            break;
        // End:0xDF
        case 4795:
            OnReceivedStateReceivedPost(param);
            // End:0x1F0
            break;
        // End:0xF5
        case 4796:
            OnDeleteSentPost(param);
            // End:0x1F0
            break;
        // End:0x10B
        case 4797:
            OnOpenStateSentPost(param);
            // End:0x1F0
            break;
        // End:0x121
        case 4798:
            OnReceivedStateSentPost(param);
            // End:0x1F0
            break;
        // End:0x1C9
        case 110:
            ParseInt(param, "ZoneCode", zonetype);
            // End:0x17C
            if(zonetype == 12)
            {
                ReceiveDelBtn.EnableWindow();
                ReceiveAllBtn.EnableWindow();
                SendDelBtn.EnableWindow();                
            }
            else
            {
                // End:0x199
                if(Me.IsShowWindow())
                {
                    AddSystemMessage(3066);
                }
                ReceiveDelBtn.DisableWindow();
                ReceiveAllBtn.DisableWindow();
                SendDelBtn.DisableWindow();
            }
            // End:0x1F0
            break;
        // End:0x1D4
        case 4970:
            // End:0x1F0
            break;
        // End:0x1DF
        case 4980:
            // End:0x1F0
            break;
        // End:0x1EA
        case 4990:
            // End:0x1F0
            break;
        // End:0xFFFF
        default:
            // End:0x1F0
            break;
            break;
    }
    return;
}

function int GetReceivedPostMailIndex(int mailID)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x41 [Loop If]
    if(i < receivedInfoList.Length)
    {
        // End:0x37
        if(receivedInfoList[i].mailID == mailID)
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

function int GetSentPostMailIndex(int mailID)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x41 [Loop If]
    if(i < sentInfoList.Length)
    {
        // End:0x37
        if(sentInfoList[i].mailID == mailID)
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

function OnDeleteReceivedPost(string param)
{
    local int mailID, mailIndex;

    ParseInt(param, "mailID", mailID);
    mailIndex = GetReceivedPostMailIndex(mailID);
    // End:0x66
    if(mailIndex >= 0)
    {
        receivedInfoList.Remove(mailIndex, 1);
        // End:0x66
        if(TabCtrl.GetTopIndex() == 0)
        {
            ReSetReceivedPostCurPage();
            ShowReceivedList(curReceivedPage);
        }
    }
    return;
}

function OnOpenStateReceivedPost(string param)
{
    local int mailID, mailIndex;

    ParseInt(param, "mailID", mailID);
    mailIndex = GetReceivedPostMailIndex(mailID);
    // End:0x66
    if(mailIndex >= 0)
    {
        receivedInfoList[mailIndex].notOpend = 0;
        // End:0x66
        if(TabCtrl.GetTopIndex() == 0)
        {
            ShowReceivedList(curReceivedPage);
        }
    }
    return;
}

function OnReceivedStateReceivedPost(string param)
{
    local int mailID, mailIndex;

    ParseInt(param, "mailID", mailID);
    mailIndex = GetReceivedPostMailIndex(mailID);
    // End:0x66
    if(mailIndex >= 0)
    {
        receivedInfoList[mailIndex].withItem = 0;
        // End:0x66
        if(TabCtrl.GetTopIndex() == 0)
        {
            ShowReceivedList(curReceivedPage);
        }
    }
    return;
}

function OnDeleteSentPost(string param)
{
    local int mailID, mailIndex;

    ParseInt(param, "mailID", mailID);
    mailIndex = GetSentPostMailIndex(mailID);
    // End:0x66
    if(mailIndex >= 0)
    {
        sentInfoList.Remove(mailIndex, 1);
        // End:0x66
        if(TabCtrl.GetTopIndex() == 1)
        {
            ReSetSentPostCurPage();
            ShowSentList(curSentPage);
        }
    }
    return;
}

function OnOpenStateSentPost(string param)
{
    local int mailID, mailIndex;

    ParseInt(param, "mailID", mailID);
    mailIndex = GetSentPostMailIndex(mailID);
    // End:0x66
    if(mailIndex >= 0)
    {
        sentInfoList[mailIndex].notOpend = 0;
        // End:0x66
        if(TabCtrl.GetTopIndex() == 1)
        {
            ShowSentList(curSentPage);
        }
    }
    return;
}

function OnReceivedStateSentPost(string param)
{
    local int mailID, mailIndex;

    ParseInt(param, "mailID", mailID);
    mailIndex = GetSentPostMailIndex(mailID);
    // End:0x66
    if(mailIndex >= 0)
    {
        sentInfoList[mailIndex].withItem = 0;
        // End:0x66
        if(TabCtrl.GetTopIndex() == 1)
        {
            ShowSentList(curSentPage);
        }
    }
    return;
}

function OnEVStartReceivedPostList(string param)
{
    local int ReceivedMailCount;

    ClearReceivedInfo();
    ParseInt(param, "ReceivedMailCount", ReceivedMailCount);
    receivedInfoList.Length = 0;
    Me.ShowWindow();
    Me.SetFocus();
    TabCtrl.SetTopOrder(0, true);
    return;
}

function OnEVAddReceivedPostList(string param)
{
    local int mailID, TRADE, notOpend, returnd, returnAble, withItem,
	    sentBySystem;

    local float diffTime;
    local string Title, senderName;
    local ReceivedPostMSG receivedMSG;

    ParseInt(param, "MailID", mailID);
    ParseString(param, "Title", Title);
    ParseString(param, "SenderName", senderName);
    ParseInt(param, "Trade", TRADE);
    ParseInt(param, "NotOpend", notOpend);
    ParseInt(param, "ReturnAble", returnAble);
    ParseInt(param, "WithItem", withItem);
    ParseInt(param, "Returnd", returnd);
    ParseInt(param, "SentBySystem", sentBySystem);
    ParseFloat(param, "DiffTime", diffTime);
    receivedMSG.mailID = mailID;
    // End:0x149
    if(returnd == 1)
    {
        receivedMSG.Title = (("[" $ GetSystemString(2090)) $ "] ") $ Title;        
    }
    else
    {
        receivedMSG.Title = Title;
    }
    receivedMSG.senderName = senderName;
    receivedMSG.TRADE = TRADE;
    receivedMSG.notOpend = notOpend;
    receivedMSG.returnAble = returnAble;
    receivedMSG.withItem = withItem;
    receivedMSG.returnd = returnd;
    receivedMSG.sentBySystem = sentBySystem;
    receivedMSG.diffTime = diffTime;
    receivedMSG.CheckBoxState = 0;
    receivedInfoList.Insert(receivedInfoList.Length, 1);
    receivedInfoList[receivedInfoList.Length - 1] = receivedMSG;
    return;
}

function reverseReceivedPostListArray()
{
    local array<ReceivedPostMSG> ArrayItem;
    local int Index, i;

    Index = receivedInfoList.Length;
    i = Index - 1;
    J0x1A:

    // End:0x57 [Loop If]
    if(i >= 0)
    {
        ArrayItem.Insert(ArrayItem.Length, 1);
        ArrayItem[ArrayItem.Length - 1] = receivedInfoList[i];
        i--;
        // [Loop Continue]
        goto J0x1A;
    }
    receivedInfoList = ArrayItem;
    return;
}

function movePaidReceivedPostToTop()
{
    local array<ReceivedPostMSG> ArrayItem;
    local int i;

    i = 0;
    J0x07:

    // End:0x5F [Loop If]
    if(i < receivedInfoList.Length)
    {
        // End:0x55
        if(receivedInfoList[i].TRADE == 1)
        {
            ArrayItem.Insert(ArrayItem.Length, 1);
            ArrayItem[ArrayItem.Length - 1] = receivedInfoList[i];
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    i = 0;
    J0x66:

    // End:0xBE [Loop If]
    if(i < receivedInfoList.Length)
    {
        // End:0xB4
        if(receivedInfoList[i].TRADE != 1)
        {
            ArrayItem.Insert(ArrayItem.Length, 1);
            ArrayItem[ArrayItem.Length - 1] = receivedInfoList[i];
        }
        i++;
        // [Loop Continue]
        goto J0x66;
    }
    receivedInfoList = ArrayItem;
    return;
}

function OnEVEndReceivedPostList()
{
    reverseReceivedPostListArray();
    movePaidReceivedPostToTop();
    ResetReceivedPostPageNum();
    curReceivedPage = 0;
    ShowReceivedList(curReceivedPage);
    return;
}

function ResetReceivedPostPageNum()
{
    ReceivedPageNum = receivedInfoList.Length / 8;
    // End:0x2D
    if((float(receivedInfoList.Length) % float(8)) != float(0))
    {
        ReceivedPageNum++;
    }
    return;
}

function ReSetReceivedPostCurPage()
{
    ResetReceivedPostPageNum();
    // End:0x23
    if(ReceivedPageNum <= curReceivedPage)
    {
        curReceivedPage = ReceivedPageNum - 1;
    }
    // End:0x35
    if(curReceivedPage < 0)
    {
        curReceivedPage = 0;
    }
    return;
}

function OnEVStartSentPostList(string param)
{
    local int SentMailCount;
    local WindowHandle m_inventoryWnd;

    // End:0x24
    if(1 == 0)
    {
        m_inventoryWnd = GetHandle("InventoryWnd");        
    }
    else
    {
        m_inventoryWnd = GetWindowHandle("InventoryWnd");
    }
    ClearSentInfo();
    ParseInt(param, "SentMailCount", SentMailCount);
    sentInfoList.Length = 0;
    Me.ShowWindow();
    TabCtrl.SetTopOrder(1, true);
    // End:0xAC
    if(m_inventoryWnd.IsShowWindow())
    {
        m_inventoryWnd.HideWindow();
    }
    return;
}

function OnEVAddSentPostList(string param)
{
    local int mailID, TRADE, notOpend, returnAble, sentBySystem, withItem;

    local float diffTime;
    local string Title, receivername;
    local SentPostMSG sentMsg;

    ParseInt(param, "MailID", mailID);
    ParseString(param, "Title", Title);
    ParseString(param, " ReceiverName", receivername);
    ParseInt(param, "Trade", TRADE);
    ParseInt(param, "NotOpend", notOpend);
    ParseInt(param, "ReturnAble", returnAble);
    ParseInt(param, "WithItem", withItem);
    ParseInt(param, "SentBySystem", sentBySystem);
    ParseFloat(param, "DiffTime", diffTime);
    sentMsg.mailID = mailID;
    sentMsg.Title = Title;
    sentMsg.receivername = receivername;
    sentMsg.TRADE = TRADE;
    sentMsg.notOpend = notOpend;
    sentMsg.returnAble = returnAble;
    sentMsg.withItem = withItem;
    sentMsg.sentBySystem = sentBySystem;
    sentMsg.diffTime = diffTime;
    sentMsg.CheckBoxState = 0;
    sentInfoList.Insert(sentInfoList.Length, 1);
    sentInfoList[sentInfoList.Length - 1] = sentMsg;
    return;
}

function reverseSendPostListArray()
{
    local array<SentPostMSG> ArrayItem;
    local int Index, i;

    Index = sentInfoList.Length;
    i = Index - 1;
    J0x1A:

    // End:0x57 [Loop If]
    if(i >= 0)
    {
        ArrayItem.Insert(ArrayItem.Length, 1);
        ArrayItem[ArrayItem.Length - 1] = sentInfoList[i];
        i--;
        // [Loop Continue]
        goto J0x1A;
    }
    sentInfoList = ArrayItem;
    return;
}

function OnEVEndSentPostList()
{
    reverseSendPostListArray();
    SentPageNum = sentInfoList.Length / 8;
    // End:0x33
    if((float(sentInfoList.Length) % float(8)) != float(0))
    {
        SentPageNum++;
    }
    curSentPage = 0;
    ShowSentList(curSentPage);
    return;
}

function ResetSentPostPageNum()
{
    SentPageNum = sentInfoList.Length / 8;
    // End:0x2D
    if((float(sentInfoList.Length) % float(8)) != float(0))
    {
        SentPageNum++;
    }
    return;
}

function ReSetSentPostCurPage()
{
    ResetSentPostPageNum();
    // End:0x23
    if(SentPageNum <= curSentPage)
    {
        curSentPage = SentPageNum - 1;
    }
    // End:0x35
    if(curSentPage < 0)
    {
        curSentPage = 0;
    }
    return;
}

function OnEVDialogOk()
{
    local int Id, Reserved;

    // End:0x8D
    if(DialogIsMine())
    {
        Id = DialogGetID();
        // End:0x3E
        if(Id == 1111)
        {
            DeleteSelectedReceivedMail();
            ClearReceivedCheckBox();
            SetAllReceivedCheckBox(curReceivedPage);            
        }
        else
        {
            // End:0x67
            if(Id == 3333)
            {
                DeleteSelectedSentMail();
                ClearSentCheckBox();
                SetAllSentCheckBox(curSentPage);                
            }
            else
            {
                // End:0x8D
                if(Id == 5555)
                {
                    Reserved = DialogGetReservedInt();
                    RequestRequestReceivedPost(Reserved);
                }
            }
        }
    }
    return;
}

function ClearReceivedCheckBox()
{
    local int i;

    ReceivePostCheck_all.SetCheck(false);
    i = 0;
    J0x17:

    // End:0x43 [Loop If]
    if(i < 8)
    {
        ReceivePostCheck[i].SetCheck(false);
        i++;
        // [Loop Continue]
        goto J0x17;
    }
    Debug("ï¿½Þ±ï¿½ï¿½ï¿½Ê±ï¿½È­ï¿½Þ¹ï¿½");
    return;
}

function ClearSentCheckBox()
{
    local int i;

    SendPostCheck_all.SetCheck(false);
    i = 0;
    J0x17:

    // End:0x43 [Loop If]
    if(i < 8)
    {
        SendPostCheck[i].SetCheck(false);
        i++;
        // [Loop Continue]
        goto J0x17;
    }
    Debug("ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ê±ï¿½È­ï¿½Þ¹ï¿½");
    return;
}

function OnClickButton(string a_ButtonID)
{
    local PostWriteWnd script;

    switch(a_ButtonID)
    {
        // End:0x35
        case "TabCtrl0":
            ClearReceivedCheckBox();
            ClearSentCheckBox();
            ShowReceivedList(curReceivedPage, true);
            RequestRequestReceivedPostList();
            // End:0x2B3
            break;
        // End:0x63
        case "TabCtrl1":
            ClearSentCheckBox();
            ClearReceivedCheckBox();
            ShowSentList(curReceivedPage, true);
            RequestRequestSentPostList();
            // End:0x2B3
            break;
        // End:0x83
        case "ReceiveListPrevBtn":
            ReceivedListPrevBtn();
            // End:0x2B3
            break;
        // End:0xA3
        case "ReceiveListNextBtn":
            ReceivedListNextBtn();
            // End:0x2B3
            break;
        // End:0xC0
        case "SendListPrevBtn":
            SentListPrevBtn();
            // End:0x2B3
            break;
        // End:0xDD
        case "SendListNextBtn":
            SentListNextBtn();
            // End:0x2B3
            break;
        // End:0x183
        case "PostSendBtn":
            // End:0x180
            if(!GetWindowHandle("PostWriteWnd").IsShowWindow())
            {
                script = PostWriteWnd(GetScript("PostWriteWnd"));
                RequestPostItemList();
                script.ClearAll();
                GetWindowHandle("PostWriteWnd").ShowWindow();
                GetWindowHandle("PostWriteWnd").SetFocus();
            }
            // End:0x2B3
            break;
        // End:0x24F
        case "PaymentPostSendBtn":
            // End:0x24C
            if(!GetWindowHandle("PostWriteWnd").IsShowWindow())
            {
                script = PostWriteWnd(GetScript("PostWriteWnd"));
                RequestPostItemList();
                script.ClearAll();
                GetWindowHandle("PostWriteWnd").ShowWindow();
                GetWindowHandle("PostWriteWnd").SetFocus();
                script.setCombobox(1);
                script.EnableSafetyAdena();
            }
            // End:0x2B3
            break;
        // End:0x26A
        case "ReceiveDelBtn":
            ViewReceiveDelDialog();
            // End:0x2B3
            break;
        // End:0x295
        case "ReceiveAllBtn":
            RequestBypassToServer("receiveallmail");
            // End:0x2B3
            break;
        // End:0x2AD
        case "SendDelBtn":
            ViewSendDelDialog();
            // End:0x2B3
            break;
        // End:0xFFFF
        default:
            // End:0x2B3
            break;
            break;
    }
    return;
}

function ViewReceiveDelDialog()
{
    local int i, deleteMSGNum;

    deleteMSGNum = 0;
    i = 0;
    J0x0E:

    // End:0x45 [Loop If]
    if(i < receivedInfoList.Length)
    {
        // End:0x3B
        if(receivedInfoList[i].CheckBoxState == 1)
        {
            deleteMSGNum++;
        }
        i++;
        // [Loop Continue]
        goto J0x0E;
    }
    // End:0x7C
    if(deleteMSGNum > 0)
    {
        DialogHide();
        DialogShow(1, 0, GetSystemMessage(3014), string(self));
        DialogSetID(1111);        
    }
    else
    {
        DialogHide();
        DialogShow(1, 5, GetSystemMessage(3015), string(self));
        DialogSetID(2222);
    }
    return;
}

function ViewSendDelDialog()
{
    local int i, deleteMSGNum;

    deleteMSGNum = 0;
    i = 0;
    J0x0E:

    // End:0x45 [Loop If]
    if(i < sentInfoList.Length)
    {
        // End:0x3B
        if(sentInfoList[i].CheckBoxState == 1)
        {
            deleteMSGNum++;
        }
        i++;
        // [Loop Continue]
        goto J0x0E;
    }
    // End:0x7C
    if(deleteMSGNum > 0)
    {
        DialogHide();
        DialogShow(1, 0, GetSystemMessage(3014), string(self));
        DialogSetID(3333);        
    }
    else
    {
        DialogHide();
        DialogShow(1, 5, GetSystemMessage(3015), string(self));
        DialogSetID(4444);
    }
    return;
}

function DeleteSelectedReceivedMail()
{
    local int i;
    local array<int> deleteReceivedList;
    local int deleteMSGNum;

    deleteMSGNum = 0;
    i = 0;
    J0x0E:

    // End:0x72 [Loop If]
    if(i < receivedInfoList.Length)
    {
        // End:0x68
        if(receivedInfoList[i].CheckBoxState == 1)
        {
            deleteReceivedList.Insert(deleteReceivedList.Length, 1);
            deleteReceivedList[deleteReceivedList.Length - 1] = receivedInfoList[i].mailID;
            deleteMSGNum++;
        }
        i++;
        // [Loop Continue]
        goto J0x0E;
    }
    // End:0x88
    if(deleteMSGNum > 0)
    {
        RequestDeleteReceivedPost(deleteReceivedList);
    }
    return;
}

function DeleteSelectedSentMail()
{
    local int i;
    local array<int> deleteSentList;
    local int deleteMSGNum;

    deleteMSGNum = 0;
    i = 0;
    J0x0E:

    // End:0x72 [Loop If]
    if(i < sentInfoList.Length)
    {
        // End:0x68
        if(sentInfoList[i].CheckBoxState == 1)
        {
            deleteSentList.Insert(deleteSentList.Length, 1);
            deleteSentList[deleteSentList.Length - 1] = sentInfoList[i].mailID;
            deleteMSGNum++;
        }
        i++;
        // [Loop Continue]
        goto J0x0E;
    }
    // End:0x88
    if(deleteMSGNum > 0)
    {
        RequestDeleteSentPost(deleteSentList);
    }
    return;
}

function ReceivedListPrevBtn()
{
    local bool changed;

    changed = true;
    curReceivedPage--;
    // End:0x29
    if(curReceivedPage < 0)
    {
        curReceivedPage = 0;
        changed = false;
    }
    // End:0x3D
    if(changed)
    {
        ShowReceivedList(curReceivedPage);
    }
    return;
}

function ReceivedListNextBtn()
{
    local bool changed;

    changed = true;
    curReceivedPage++;
    // End:0x34
    if(curReceivedPage >= ReceivedPageNum)
    {
        curReceivedPage = curReceivedPage - 1;
        changed = false;
    }
    // End:0x48
    if(changed)
    {
        ShowReceivedList(curReceivedPage);
    }
    return;
}

function SentListPrevBtn()
{
    local bool changed;

    changed = true;
    curSentPage--;
    // End:0x29
    if(curSentPage < 0)
    {
        curSentPage = 0;
        changed = false;
    }
    // End:0x3D
    if(changed)
    {
        ShowSentList(curSentPage);
    }
    return;
}

function SentListNextBtn()
{
    local bool changed;

    changed = true;
    curSentPage++;
    // End:0x34
    if(curSentPage >= SentPageNum)
    {
        curSentPage = curSentPage - 1;
        changed = false;
    }
    // End:0x48
    if(changed)
    {
        ShowSentList(curSentPage);
    }
    return;
}

function ShowReceiveListNumber()
{
    // End:0x35
    if(ReceivedPageNum > 0)
    {
        ReceiveListNumber.SetText((string(curReceivedPage + 1) $ "/") $ string(ReceivedPageNum));        
    }
    else
    {
        ReceiveListNumber.SetText("0/0");
    }
    return;
}

function ShowSendListNumber()
{
    // End:0x35
    if(SentPageNum > 0)
    {
        SendListNumber.SetText((string(curSentPage + 1) $ "/") $ string(SentPageNum));        
    }
    else
    {
        SendListNumber.SetText("0/0");
    }
    return;
}

function ShowReceivedList(int page, optional bool exceptionCheckBoxRefresh)
{
    local int i, j;
    local LVData Data[5];
    local LVDataRecord Record;
    local int Start, End;

    ReceivedPostList.ShowWindow();
    SentPostList.HideWindow();
    ReceivedPostList.DeleteAllItem();
    // End:0x9DD
    if((page >= 0) && page < ReceivedPageNum)
    {
        // End:0xAB
        if(page == (ReceivedPageNum - 1))
        {
            Start = page * 8;
            End = int(float(Start) + (float(receivedInfoList.Length) % float(8)));
            // End:0xA8
            if((float(receivedInfoList.Length) % float(8)) == float(0))
            {
                End += 8;
            }            
        }
        else
        {
            Start = page * 8;
            End = Start + 8;
        }
        Record.LVDataList.Length = 5;
        i = Start;
        J0xE2:

        // End:0x9DD [Loop If]
        if(i < End)
        {
            Data[0].szData = "";
            Data[0].nReserved1 = receivedInfoList[i].mailID;
            Data[0].nReserved2 = receivedInfoList[i].TRADE;
            Data[1].nTextureWidth = 18;
            Data[1].nTextureHeight = 12;
            // End:0x430
            if(receivedInfoList[i].notOpend == 0)
            {
                // End:0x1CE
                if(receivedInfoList[i].sentBySystem == 7)
                {
                    Data[1].szData = "";
                    Data[1].szTexture = "BranchSys3.Icon.primeshop_gift_confirmed";                    
                }
                else
                {
                    // End:0x2B6
                    if((receivedInfoList[i].TRADE == 1) && receivedInfoList[i].withItem == 1)
                    {
                        Data[1].szData = "";
                        Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_SafetyTrade_Accompany_confirmed";
                        // End:0x2B3
                        if(receivedInfoList[i].returnd == 1)
                        {
                            Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_Accompany_confirmed";
                        }                        
                    }
                    else
                    {
                        // End:0x376
                        if((receivedInfoList[i].TRADE == 1) && receivedInfoList[i].withItem == 0)
                        {
                            Data[1].szData = "";
                            Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_SafetyTrade_confirmed";
                            // End:0x373
                            if(receivedInfoList[i].returnd == 1)
                            {
                                Data[1].szTexture = "L2UI_CT1.Misc_DF_Blank";
                            }                            
                        }
                        else
                        {
                            // End:0x3F9
                            if((receivedInfoList[i].TRADE == 0) && receivedInfoList[i].withItem == 1)
                            {
                                Data[1].szData = "";
                                Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_Accompany_confirmed";                                
                            }
                            else
                            {
                                Data[1].szData = "";
                                Data[1].szTexture = "L2UI_CT1.Misc_DF_Blank";
                            }
                        }
                    }
                }                
            }
            else
            {
                // End:0x486
                if(receivedInfoList[i].sentBySystem == 7)
                {
                    Data[1].szData = "";
                    Data[1].szTexture = "BranchSys3.Icon.primeshop_gift";                    
                }
                else
                {
                    // End:0x55A
                    if((receivedInfoList[i].TRADE == 1) && receivedInfoList[i].withItem == 1)
                    {
                        Data[1].szData = "";
                        Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_SafetyTrade_Accompany";
                        // End:0x557
                        if(receivedInfoList[i].returnd == 1)
                        {
                            Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_Accompany";
                        }                        
                    }
                    else
                    {
                        // End:0x610
                        if((receivedInfoList[i].TRADE == 1) && receivedInfoList[i].withItem == 0)
                        {
                            Data[1].szData = "";
                            Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_SafetyTrade";
                            // End:0x60D
                            if(receivedInfoList[i].returnd == 1)
                            {
                                Data[1].szTexture = "L2UI_CT1.Misc_DF_Blank";
                            }                            
                        }
                        else
                        {
                            // End:0x689
                            if((receivedInfoList[i].TRADE == 0) && receivedInfoList[i].withItem == 1)
                            {
                                Data[1].szData = "";
                                Data[1].szTexture = "L2UI_CT1.POSTWND.PostWnd_DF_Icon_Accompany";                                
                            }
                            else
                            {
                                Data[1].szData = "";
                                Data[1].szTexture = "L2UI_CT1.Misc_DF_Blank";
                            }
                        }
                    }
                }
            }
            Data[2].bUseTextColor = true;
            Data[3].bUseTextColor = true;
            Data[4].bUseTextColor = true;
            // End:0x757
            if((receivedInfoList[i].notOpend == 0) && receivedInfoList[i].TRADE == 0)
            {
                Data[2].TextColor = readPostColor;
                Data[3].TextColor = readPostColor;
                Data[4].TextColor = readPostColor;                
            }
            else
            {
                // End:0x7C1
                if((receivedInfoList[i].notOpend == 1) && receivedInfoList[i].TRADE == 0)
                {
                    Data[2].TextColor = notReadPostColor;
                    Data[3].TextColor = notReadPostColor;
                    Data[4].TextColor = notReadPostColor;                    
                }
                else
                {
                    // End:0x82B
                    if((receivedInfoList[i].notOpend == 0) && receivedInfoList[i].TRADE == 1)
                    {
                        Data[2].TextColor = tradereadPostColor;
                        Data[3].TextColor = tradereadPostColor;
                        Data[4].TextColor = tradereadPostColor;                        
                    }
                    else
                    {
                        // End:0x892
                        if((receivedInfoList[i].notOpend == 1) && receivedInfoList[i].TRADE == 1)
                        {
                            Data[2].TextColor = tradePostColor;
                            Data[3].TextColor = tradePostColor;
                            Data[4].TextColor = tradePostColor;
                        }
                    }
                }
            }
            // End:0x8DC
            if((receivedInfoList[i].sentBySystem == 1) && receivedInfoList[i].returnd == 1)
            {
                Data[2].szData = GetSystemString(2073);                
            }
            else
            {
                // End:0x926
                if((receivedInfoList[i].sentBySystem == 1) && receivedInfoList[i].returnd == 0)
                {
                    Data[2].szData = GetSystemString(2211);                    
                }
                else
                {
                    Data[2].szData = receivedInfoList[i].senderName;
                }
            }
            Data[3].szData = receivedInfoList[i].Title;
            Data[4].szData = ConvertTimeToString(receivedInfoList[i].diffTime);
            j = 0;
            J0x98D:

            // End:0x9BF [Loop If]
            if(j < 5)
            {
                Record.LVDataList[j] = Data[j];
                j++;
                // [Loop Continue]
                goto J0x98D;
            }
            ReceivedPostList.InsertRecord(Record);
            i++;
            // [Loop Continue]
            goto J0xE2;
        }
    }
    ViewReceivedCheckBox(page);
    ShowReceiveListNumber();
    return;
}

function ShowSentList(int page, optional bool exceptionCheckBoxRefresh)
{
    local int i, j;
    local LVData Data[5];
    local LVDataRecord Record;
    local int Start, End;

    ReceivedPostList.HideWindow();
    SentPostList.ShowWindow();
    SentPostList.DeleteAllItem();
    // End:0x3DD
    if((page >= 0) && page < SentPageNum)
    {
        // End:0xAB
        if(page == (SentPageNum - 1))
        {
            Start = page * 8;
            End = int(float(Start) + (float(sentInfoList.Length) % float(8)));
            // End:0xA8
            if((float(sentInfoList.Length) % float(8)) == float(0))
            {
                End += 8;
            }            
        }
        else
        {
            Start = page * 8;
            End = Start + 8;
        }
        Record.LVDataList.Length = 5;
        i = Start;
        J0xE2:

        // End:0x3DD [Loop If]
        if(i < End)
        {
            Data[0].szData = "";
            Data[0].nReserved1 = sentInfoList[i].mailID;
            Data[1].nTextureWidth = 18;
            Data[1].nTextureHeight = 12;
            // End:0x191
            if(sentInfoList[i].sentBySystem == 7)
            {
                Data[1].szData = "";
                Data[1].szTexture = "BranchSys3.Icon.primeshop_gift";                
            }
            else
            {
                // End:0x20E
                if((sentInfoList[i].TRADE == 1) && sentInfoList[i].withItem == 1)
                {
                    Data[1].szData = "";
                    Data[1].szTexture = "L2UI_CT1.PostWnd_DF_Icon_SafetyTrade_Accompany";                    
                }
                else
                {
                    // End:0x281
                    if((sentInfoList[i].TRADE == 1) && sentInfoList[i].withItem == 0)
                    {
                        Data[1].szData = "";
                        Data[1].szTexture = "L2UI_CT1.PostWnd_DF_Icon_SafetyTrade";                        
                    }
                    else
                    {
                        // End:0x2F2
                        if((sentInfoList[i].TRADE == 0) && sentInfoList[i].withItem == 1)
                        {
                            Data[1].szData = "";
                            Data[1].szTexture = "L2UI_CT1.PostWnd_DF_Icon_Accompany";                            
                        }
                        else
                        {
                            Data[1].szData = "";
                            Data[1].szTexture = "L2UI_CT1.Misc_DF_Blank";
                        }
                    }
                }
            }
            Data[2].szData = sentInfoList[i].receivername;
            Data[3].szData = sentInfoList[i].Title;
            Data[4].szData = ConvertTimeToString(sentInfoList[i].diffTime);
            j = 0;
            J0x38D:

            // End:0x3BF [Loop If]
            if(j < 5)
            {
                Record.LVDataList[j] = Data[j];
                j++;
                // [Loop Continue]
                goto J0x38D;
            }
            SentPostList.InsertRecord(Record);
            i++;
            // [Loop Continue]
            goto J0xE2;
        }
    }
    ViewSentCheckBox(page);
    ShowSendListNumber();
    return;
}

function bool GetReceivedSelectedListCtrlItem(out LVDataRecord Record)
{
    local int Index;

    Index = ReceivedPostList.GetSelectedIndex();
    // End:0x3B
    if(Index >= 0)
    {
        ReceivedPostList.GetRec(Index, Record);
        return true;
    }
    return false;
    return;
}

function bool GetSentSelectedListCtrlItem(out LVDataRecord Record)
{
    local int Index;

    Index = SentPostList.GetSelectedIndex();
    // End:0x3B
    if(Index >= 0)
    {
        SentPostList.GetRec(Index, Record);
        return true;
    }
    return false;
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 5;
    // End:0xAB
    if(ListCtrlID == "ReceivePostList")
    {
        // End:0xA8
        if(GetReceivedSelectedListCtrlItem(Record))
        {
            // End:0x91
            if(Record.LVDataList[0].nReserved2 == 1)
            {
                DialogHide();
                DialogSetReservedInt(Record.LVDataList[0].nReserved1);
                DialogShow(1, 0, GetSystemMessage(3087), string(self));
                DialogSetID(5555);                
            }
            else
            {
                RequestRequestReceivedPost(Record.LVDataList[0].nReserved1);
            }
        }        
    }
    else
    {
        // End:0xE8
        if(ListCtrlID == "SendPostList")
        {
            // End:0xE8
            if(GetSentSelectedListCtrlItem(Record))
            {
                RequestRequestSentPost(Record.LVDataList[0].nReserved1);
            }
        }
    }
    return;
}

function ClearReceivedInfo()
{
    local int i;

    receivedInfoList.Length = 0;
    curReceivedPage = 0;
    ReceivePostCheck_all.SetCheck(false);
    i = 0;
    J0x26:

    // End:0x52 [Loop If]
    if(i < 8)
    {
        ReceivePostCheck[i].SetCheck(false);
        i++;
        // [Loop Continue]
        goto J0x26;
    }
    i = 0;
    J0x59:

    // End:0x7C [Loop If]
    if(i < 3)
    {
        ReceivedPageFullCheckState[i] = 0;
        i++;
        // [Loop Continue]
        goto J0x59;
    }
    return;
}

function ClearSentInfo()
{
    local int i;

    sentInfoList.Length = 0;
    curSentPage = 0;
    SendPostCheck_all.SetCheck(false);
    i = 0;
    J0x26:

    // End:0x52 [Loop If]
    if(i < 8)
    {
        SendPostCheck[i].SetCheck(false);
        i++;
        // [Loop Continue]
        goto J0x26;
    }
    i = 0;
    J0x59:

    // End:0x7C [Loop If]
    if(i < 3)
    {
        SentPageFullCheckState[i] = 0;
        i++;
        // [Loop Continue]
        goto J0x59;
    }
    return;
}

function SetReceivedCheckBox(int curPage, string strID)
{
    local int CheckBoxID, infoindex;
    local bool disCheck;

    CheckBoxID = int(Right(strID, 1));
    infoindex = (curPage * 8) + CheckBoxID;
    // End:0x53
    if(ReceivePostCheck[CheckBoxID].IsChecked())
    {
        receivedInfoList[infoindex].CheckBoxState = 1;        
    }
    else
    {
        receivedInfoList[infoindex].CheckBoxState = 0;
        disCheck = true;
    }
    ViewReceivedCheckBox(curPage);
    Debug("disCheck" @ string(disCheck));
    // End:0xB8
    if(disCheck)
    {
        ReceivePostCheck_all.SetCheck(false);
        ReceivedPageFullCheckState[curPage] = 0;
    }
    return;
}

function SetSentCheckBox(int curPage, string strID)
{
    local int CheckBoxID, infoindex;
    local bool disCheck;

    CheckBoxID = int(Right(strID, 1));
    infoindex = (curPage * 8) + CheckBoxID;
    // End:0x53
    if(SendPostCheck[CheckBoxID].IsChecked())
    {
        sentInfoList[infoindex].CheckBoxState = 1;        
    }
    else
    {
        sentInfoList[infoindex].CheckBoxState = 0;
        disCheck = true;
    }
    ViewSentCheckBox(curPage);
    // End:0x9E
    if(disCheck)
    {
        SendPostCheck_all.SetCheck(false);
        SentPageFullCheckState[curPage] = 0;
    }
    return;
}

function ViewReceivedCheckBox(int curPage)
{
    local int i, j, diableBoxCount, Start, End;

    j = 0;
    diableBoxCount = 0;
    Start = curPage * 8;
    End = (curPage + 1) * 8;
    i = 0;
    J0x36:

    // End:0x61 [Loop If]
    if(i < 8)
    {
        ReceivePostCheck[i].HideWindow();
        i++;
        // [Loop Continue]
        goto J0x36;
    }
    // End:0x90
    if(End > receivedInfoList.Length)
    {
        diableBoxCount = End - receivedInfoList.Length;
        End = receivedInfoList.Length;
    }
    i = Start;
    J0x9B:

    // End:0x143 [Loop If]
    if(i < End)
    {
        // End:0x132
        if((receivedInfoList[i].withItem == 0) && receivedInfoList[i].notOpend == 0)
        {
            ReceivePostCheck[j].ShowWindow();
            // End:0x11C
            if(receivedInfoList[i].CheckBoxState == 1)
            {
                ReceivePostCheck[j].SetCheck(true);                
            }
            else
            {
                ReceivePostCheck[j].SetCheck(false);
            }
        }
        j++;
        i++;
        // [Loop Continue]
        goto J0x9B;
    }
    // End:0x167
    if(ReceivedPageFullCheckState[curPage] == 1)
    {
        ReceivePostCheck_all.SetCheck(true);        
    }
    else
    {
        ReceivePostCheck_all.SetCheck(false);
    }
    return;
}

function ViewSentCheckBox(int curPage)
{
    local int i, j, diableBoxCount, Start, End;

    j = 0;
    diableBoxCount = 0;
    Start = curPage * 8;
    End = (curPage + 1) * 8;
    i = 0;
    J0x36:

    // End:0x61 [Loop If]
    if(i < 8)
    {
        SendPostCheck[i].HideWindow();
        i++;
        // [Loop Continue]
        goto J0x36;
    }
    // End:0x90
    if(End > sentInfoList.Length)
    {
        diableBoxCount = End - sentInfoList.Length;
        End = sentInfoList.Length;
    }
    i = Start;
    J0x9B:

    // End:0x12B [Loop If]
    if(i < End)
    {
        // End:0x11A
        if(sentInfoList[i].withItem == 0)
        {
            SendPostCheck[j].ShowWindow();
            // End:0x104
            if(sentInfoList[i].CheckBoxState == 1)
            {
                SendPostCheck[j].SetCheck(true);                
            }
            else
            {
                SendPostCheck[j].SetCheck(false);
            }
        }
        j++;
        i++;
        // [Loop Continue]
        goto J0x9B;
    }
    // End:0x14F
    if(SentPageFullCheckState[curPage] == 1)
    {
        SendPostCheck_all.SetCheck(true);        
    }
    else
    {
        SendPostCheck_all.SetCheck(false);
    }
    return;
}

function OnClickCheckBox(string strID)
{
    // End:0x2E
    if(strID == "ReceivePostCheck_all")
    {
        SetAllReceivedCheckBox(curReceivedPage);        
    }
    else
    {
        // End:0x59
        if(strID == "SendPostCheck_all")
        {
            SetAllSentCheckBox(curSentPage);            
        }
        else
        {
            // End:0x90
            if(InStr(strID, "ReceivePostCheck_") > -1)
            {
                SetReceivedCheckBox(curReceivedPage, strID);                
            }
            else
            {
                // End:0xC1
                if(InStr(strID, "SendPostCheck_") > -1)
                {
                    SetSentCheckBox(curSentPage, strID);
                }
            }
        }
    }
    return;
}

function SetAllReceivedCheckBox(int curPage)
{
    local int i, j, diableBoxCount, Start, End;

    j = 0;
    diableBoxCount = 0;
    Start = curPage * 8;
    End = (curPage + 1) * 8;
    // End:0x5E
    if(End > receivedInfoList.Length)
    {
        diableBoxCount = End - receivedInfoList.Length;
        End = receivedInfoList.Length;
    }
    // End:0x80
    if(ReceivePostCheck_all.IsChecked())
    {
        ReceivedPageFullCheckState[curPage] = 1;        
    }
    else
    {
        ReceivedPageFullCheckState[curPage] = 0;
    }
    i = Start;
    J0x98:

    // End:0x11F [Loop If]
    if(i < End)
    {
        // End:0x10E
        if((receivedInfoList[i].withItem == 0) && receivedInfoList[i].notOpend == 0)
        {
            // End:0xFC
            if(ReceivePostCheck_all.IsChecked())
            {
                receivedInfoList[i].CheckBoxState = 1;                
            }
            else
            {
                receivedInfoList[i].CheckBoxState = 0;
            }
        }
        j++;
        i++;
        // [Loop Continue]
        goto J0x98;
    }
    ViewReceivedCheckBox(curPage);
    return;
}

function SetAllSentCheckBox(int curPage)
{
    local int i, j, diableBoxCount, Start, End;

    j = 0;
    diableBoxCount = 0;
    Start = curPage * 8;
    End = (curPage + 1) * 8;
    // End:0x5E
    if(End > sentInfoList.Length)
    {
        diableBoxCount = End - sentInfoList.Length;
        End = sentInfoList.Length;
    }
    // End:0x80
    if(SendPostCheck_all.IsChecked())
    {
        SentPageFullCheckState[curPage] = 1;        
    }
    else
    {
        SentPageFullCheckState[curPage] = 0;
    }
    i = Start;
    J0x98:

    // End:0x107 [Loop If]
    if(i < End)
    {
        // End:0xF6
        if(sentInfoList[i].withItem == 0)
        {
            // End:0xE4
            if(SendPostCheck_all.IsChecked())
            {
                sentInfoList[i].CheckBoxState = 1;                
            }
            else
            {
                sentInfoList[i].CheckBoxState = 0;
            }
        }
        j++;
        i++;
        // [Loop Continue]
        goto J0x98;
    }
    ViewSentCheckBox(curPage);
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
    m_WindowName="PostBoxWnd"
}