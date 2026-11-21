class PostDetailWnd_SafetyTrade extends UICommonAPI;

const DIALOG_RECEIVE_TRADE_POST = 1111;
const DIALOG_RETURN_POST = 2222;

var WindowHandle Me;
var WindowHandle General;
var TextBoxHandle Title_SenderID;
var TextBoxHandle SenderID;
var TextBoxHandle PostType;
var TextBoxHandle PostTitle;
var TextListBoxHandle PostContents;
var TextBoxHandle WeightText;
var TextBoxHandle SafetyTradeAdenaText;
var INT64 ReceivedTradeAdena;
var ButtonHandle ReceiveBtn;
var ButtonHandle ReturnBtn;
var ButtonHandle SendCancelBtn;
var ButtonHandle ReplyBtn;
var ButtonHandle AddBtn;
var ItemWindowHandle AccompanyItem;
var int TRADE;
var int returnd;
var int mailID;
var int totalWeight;
var int returnAble;
var int sentBySystem;
var Color impactcolor;

function OnRegisterEvent()
{
    RegisterEvent(4740);
    RegisterEvent(4741);
    RegisterEvent(4742);
    RegisterEvent(4780);
    RegisterEvent(4781);
    RegisterEvent(4782);
    RegisterEvent(1710);
    RegisterEvent(110);
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
    totalWeight = 0;
    impactcolor.R = byte(255);
    impactcolor.G = 114;
    impactcolor.B = 0;
    return;
}

function OnShow()
{
    // End:0x21
    if(General.IsShowWindow())
    {
        General.HideWindow();
    }
    return;
}

function Initialize()
{
    Me = GetHandle("PostDetailWnd_SafetyTrade");
    General = GetHandle("PostDetailWnd_General");
    Title_SenderID = TextBoxHandle(GetHandle("PostDetailWnd_SafetyTrade.Title_SenderID"));
    SenderID = TextBoxHandle(GetHandle("PostDetailWnd_SafetyTrade.SenderID"));
    PostType = TextBoxHandle(GetHandle("PostDetailWnd_SafetyTrade.PostType"));
    PostTitle = TextBoxHandle(GetHandle("PostDetailWnd_SafetyTrade.PostTitle"));
    PostContents = TextListBoxHandle(GetHandle("PostDetailWnd_SafetyTrade.PostContents"));
    WeightText = TextBoxHandle(GetHandle("PostDetailWnd_SafetyTrade.WeightText"));
    SafetyTradeAdenaText = TextBoxHandle(GetHandle("PostDetailWnd_SafetyTrade.SafetyTradeAdenaText"));
    ReceiveBtn = ButtonHandle(GetHandle("PostDetailWnd_SafetyTrade.ReceiveBtn"));
    ReturnBtn = ButtonHandle(GetHandle("PostDetailWnd_SafetyTrade.ReternBtn"));
    SendCancelBtn = ButtonHandle(GetHandle("PostDetailWnd_SafetyTrade.SendCancelBtn"));
    ReplyBtn = ButtonHandle(GetHandle("PostDetailWnd_SafetyTrade.ReplyBtn"));
    AddBtn = ButtonHandle(GetHandle("PostDetailWnd_SafetyTrade.AddBtn"));
    AccompanyItem = ItemWindowHandle(GetHandle("PostDetailWnd_SafetyTrade.AccompanyItem"));
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("PostDetailWnd_SafetyTrade");
    General = GetWindowHandle("PostDetailWnd_General");
    Title_SenderID = GetTextBoxHandle("PostDetailWnd_SafetyTrade.Title_SenderID");
    SenderID = GetTextBoxHandle("PostDetailWnd_SafetyTrade.SenderID");
    PostType = GetTextBoxHandle("PostDetailWnd_SafetyTrade.PostType");
    PostTitle = GetTextBoxHandle("PostDetailWnd_SafetyTrade.PostTitle");
    PostContents = GetTextListBoxHandle("PostDetailWnd_SafetyTrade.PostContents");
    WeightText = GetTextBoxHandle("PostDetailWnd_SafetyTrade.WeightText");
    SafetyTradeAdenaText = GetTextBoxHandle("PostDetailWnd_SafetyTrade.SafetyTradeAdenaText");
    ReceiveBtn = GetButtonHandle("PostDetailWnd_SafetyTrade.ReceiveBtn");
    ReturnBtn = GetButtonHandle("PostDetailWnd_SafetyTrade.ReternBtn");
    SendCancelBtn = GetButtonHandle("PostDetailWnd_SafetyTrade.SendCancelBtn");
    ReplyBtn = GetButtonHandle("PostDetailWnd_SafetyTrade.ReplyBtn");
    AddBtn = GetButtonHandle("PostDetailWnd_SafetyTrade.AddBtn");
    AccompanyItem = GetItemWindowHandle("PostDetailWnd_SafetyTrade.AccompanyItem");
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int zonetype;

    switch(Event_ID)
    {
        // End:0x1D
        case 4740:
            OnEVReplyReceivedPostStart(param);
            // End:0x165
            break;
        // End:0x33
        case 4741:
            OnEVReplyReceivedPostAddItem(param);
            // End:0x165
            break;
        // End:0x49
        case 4742:
            OnEVReplyReceivedPostEnd(param);
            // End:0x165
            break;
        // End:0x5F
        case 4780:
            OnEVReplySentPostStart(param);
            // End:0x165
            break;
        // End:0x75
        case 4781:
            OnEVReplySentPostAddItem(param);
            // End:0x165
            break;
        // End:0x8B
        case 4782:
            OnEVReplySentPostEnd(param);
            // End:0x165
            break;
        // End:0x9C
        case 1710:
            HandleDialogOK();
            // End:0x165
            break;
        // End:0x162
        case 110:
            ParseInt(param, "ZoneCode", zonetype);
            // End:0x106
            if(zonetype == 12)
            {
                SendCancelBtn.EnableWindow();
                ReceiveBtn.EnableWindow();
                ReturnBtn.EnableWindow();
                ReplyBtn.EnableWindow();                
            }
            else
            {
                // End:0x123
                if(Me.IsShowWindow())
                {
                    AddSystemMessage(3066);
                }
                SendCancelBtn.DisableWindow();
                ReceiveBtn.DisableWindow();
                ReturnBtn.DisableWindow();
                ReplyBtn.DisableWindow();
            }
            // End:0x165
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEVReplyReceivedPostStart(string param)
{
    ClearAll();
    ParseInt(param, "trade", TRADE);
    ParseInt(param, "Returnd", returnd);
    // End:0xB3
    if((returnd == 0) && TRADE == 1)
    {
        Me.SetWindowTitle(GetSystemString(2075));
        ReceiveBtn.HideWindow();
        ReturnBtn.HideWindow();
        SendCancelBtn.HideWindow();
        Me.ShowWindow();
        Me.SetFocus();
    }
    totalWeight = 0;
    return;
}

function OnEVReplyReceivedPostAddItem(string param)
{
    local ItemInfo Info;

    // End:0x7E
    if((returnd == 0) && TRADE == 1)
    {
        ParamToItemInfo(param, Info);
        AccompanyItem.AddItem(Info);
        totalWeight += (Info.Weight * name(Info.ItemNum));
        // End:0x7E
        if(!ReceiveBtn.IsShowWindow())
        {
            ReceiveBtn.ShowWindow();
        }
    }
    return;
}

function OnEVReplyReceivedPostEnd(string param)
{
    local string senderName, Title, contents, fixedtitle;
    local int SendId;
    local string NpcName;
    local CustomTooltip cTooltip;

    // End:0x545
    if((returnd == 0) && TRADE == 1)
    {
        ParseInt(param, "MailID", mailID);
        ParseString(param, "SenderName", senderName);
        ParseInt(param, "SenderId", SendId);
        ParseString(param, "Title", Title);
        ParseString(param, "Content", contents);
        ParseINT64(param, "TradeMoney", ReceivedTradeAdena);
        ParseInt(param, "ReturnAble", returnAble);
        ParseInt(param, "Sentbysystem", sentBySystem);
        PostType.SetTextColor(impactcolor);
        PostType.SetText(GetSystemString(2072));
        fixedtitle = DivideStringWithWidth(Title, 380);
        // End:0x151
        if(fixedtitle != Title)
        {
            fixedtitle = fixedtitle $ "...";
        }
        PostTitle.SetText(fixedtitle);
        PostContents.AddString(contents, GetChatColorByType(0));
        PostContents.SetTextListBoxScrollPosition(0);
        Title_SenderID.SetText(GetSystemString(2078));
        SafetyTradeAdenaText.SetTextColor(impactcolor);
        SafetyTradeAdenaText.SetText(MakeCostString((ReceivedTradeAdena)));
        addToolTipDrawList(cTooltip, addDrawItemText((ConvertNumToTextNoAdena((ReceivedTradeAdena)) $ " ") $ GetSystemString(469), getInstanceL2Util().White, "", false));
        SafetyTradeAdenaText.SetTooltipCustomType(cTooltip);
        // End:0x268
        if(AccompanyItem.GetItemNum() != 0)
        {
            // End:0x268
            if(!ReceiveBtn.IsShowWindow())
            {
                ReceiveBtn.ShowWindow();
            }
        }
        // End:0x2E6
        if(returnAble == 1)
        {
            // End:0x2D4
            if(ReceiveBtn.IsShowWindow())
            {
                ReceiveBtn.SetAnchor("PostDetailWnd_SafetyTrade", "BottomCenter", "BottomRight", -1, -4);
            }
            ReturnBtn.ShowWindow();            
        }
        else
        {
            // End:0x344
            if(ReceiveBtn.IsShowWindow())
            {
                ReceiveBtn.SetAnchor("PostDetailWnd_SafetyTrade", "BottomCenter", "BottomCenter", 0, -4);
            }
            ReturnBtn.HideWindow();
        }
        // End:0x410
        if(sentBySystem == 1)
        {
            // End:0x386
            if(returnd == 1)
            {
                SenderID.SetText(GetSystemString(2073));                
            }
            else
            {
                SenderID.SetText(GetSystemString(2211));
            }
            // End:0x3FE
            if(ReceiveBtn.IsShowWindow())
            {
                ReceiveBtn.SetAnchor("PostDetailWnd_SafetyTrade", "BottomCenter", "BottomCenter", 0, -4);
            }
            ReturnBtn.HideWindow();            
        }
        else
        {
            // End:0x471
            if(sentBySystem == 2)
            {
                NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(SendId);
                // End:0x45A
                if(Len(NpcName) > 0)
                {
                    SenderID.SetText(NpcName);                    
                }
                else
                {
                    SenderID.SetText(senderName);
                }                
            }
            else
            {
                SenderID.SetText(senderName);
            }
        }
        // End:0x4A2
        if(sentBySystem == 1)
        {
            ReplyBtn.HideWindow();            
        }
        else
        {
            ReplyBtn.ShowWindow();
        }
        // End:0x52F
        if(AccompanyItem.GetItemNum() == 0)
        {
            // End:0x520
            if(ReceiveBtn.IsShowWindow())
            {
                ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
            }
            ReturnBtn.HideWindow();
        }
        WeightText.SetText(string(totalWeight));
    }
    return;
}

function OnEVReplySentPostStart(string param)
{
    ClearAll();
    ParseInt(param, "trade", TRADE);
    // End:0x8D
    if(TRADE == 1)
    {
        Me.SetWindowTitle(GetSystemString(2076));
        ReceiveBtn.HideWindow();
        ReturnBtn.HideWindow();
        SendCancelBtn.HideWindow();
        Me.ShowWindow();
        Me.SetFocus();
    }
    return;
}

function OnEVReplySentPostAddItem(string param)
{
    local ItemInfo Info;

    // End:0x2F
    if(TRADE == 1)
    {
        ParamToItemInfo(param, Info);
        AccompanyItem.AddItem(Info);
    }
    return;
}

function OnEVReplySentPostEnd(string param)
{
    local string receivername, Title, contents;
    local INT64 tradeMoney;
    local int notOpend;
    local string fixedtitle;
    local CustomTooltip cTooltip;

    // End:0x262
    if(TRADE == 1)
    {
        ParseInt(param, "MailID", mailID);
        ParseString(param, "ReceiverName", receivername);
        ParseString(param, "Title", Title);
        ParseString(param, "Content", contents);
        ParseINT64(param, "TradeMoney", tradeMoney);
        ParseInt(param, "NotOpend", notOpend);
        PostType.SetTextColor(impactcolor);
        PostType.SetText(GetSystemString(2072));
        fixedtitle = DivideStringWithWidth(Title, 380);
        // End:0x10C
        if(fixedtitle != Title)
        {
            fixedtitle = fixedtitle $ "...";
        }
        PostTitle.SetText(fixedtitle);
        Title_SenderID.SetText(GetSystemString(2087));
        PostContents.AddString(contents, GetChatColorByType(0));
        PostContents.SetTextListBoxScrollPosition(0);
        SenderID.SetText(receivername);
        ReceiveBtn.HideWindow();
        ReturnBtn.HideWindow();
        ReplyBtn.HideWindow();
        SafetyTradeAdenaText.SetTextColor(impactcolor);
        SafetyTradeAdenaText.SetText(MakeCostString((tradeMoney)));
        addToolTipDrawList(cTooltip, addDrawItemText((ConvertNumToTextNoAdena((tradeMoney)) $ " ") $ GetSystemString(469), getInstanceL2Util().White, "", false));
        SafetyTradeAdenaText.SetTooltipCustomType(cTooltip);
        // End:0x253
        if(AccompanyItem.GetItemNum() != 0)
        {
            SendCancelBtn.ShowWindow();            
        }
        else
        {
            SendCancelBtn.HideWindow();
        }
    }
    return;
}

function ClearAll()
{
    SenderID.SetText("");
    PostType.SetTextColor(impactcolor);
    PostType.SetText(GetSystemString(2072));
    PostTitle.SetText("");
    PostContents.Clear();
    WeightText.SetText("0");
    SafetyTradeAdenaText.SetTextColor(impactcolor);
    SafetyTradeAdenaText.SetText("0");
    SafetyTradeAdenaText.ClearTooltip();
    ReceiveBtn.HideWindow();
    ReturnBtn.HideWindow();
    SendCancelBtn.HideWindow();
    AccompanyItem.Clear();
    return;
}

function OnClickButton(string a_ButtonID)
{
    switch(a_ButtonID)
    {
        // End:0x99
        case "ReceiveBtn":
            // End:0x7C
            if((returnd == 0) && TRADE == 1)
            {
                DialogHide();
                DialogShow(1, 0, MakeFullSystemMsg(GetSystemMessage(3086), SenderID.GetText(), ConvertNumToText((ReceivedTradeAdena))), string(self));
                DialogSetID(1111);                
            }
            else
            {
                RequestReceivePost(mailID);
                Me.HideWindow();
            }
            // End:0x154
            break;
        // End:0xF8
        case "ReternBtn":
            // End:0xF5
            if(((returnd == 0) && TRADE == 1) && returnAble == 1)
            {
                DialogHide();
                DialogShow(1, 0, GetSystemMessage(3069), string(self));
                DialogSetID(2222);
            }
            // End:0x154
            break;
        // End:0x127
        case "SendCancelBtn":
            RequestCancelSentPost(mailID);
            Me.HideWindow();
            // End:0x154
            break;
        // End:0x13D
        case "ReplyBtn":
            HandleReplyBtn();
            // End:0x154
            break;
        // End:0x151
        case "AddBtn":
            HandleAddBtn();
            // End:0x154
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleDialogOK()
{
    local int Id;

    // End:0x6A
    if(DialogIsMine())
    {
        Id = DialogGetID();
        // End:0x41
        if(Id == 1111)
        {
            RequestReceivePost(mailID);
            Me.HideWindow();            
        }
        else
        {
            // End:0x6A
            if(Id == 2222)
            {
                RequestRejectPost(mailID);
                Me.HideWindow();
            }
        }
    }
    return;
}

function HandleReplyBtn()
{
    local PostWriteWnd script;
    local string Title;

    // End:0x81
    if(returnd != 1)
    {
        RequestPostItemList();
        script = PostWriteWnd(GetScript("PostWriteWnd"));
        Me.HideWindow();
        Title = "[Re]" $ PostTitle.GetText();
        script.SetPostWriteWnd(SenderID.GetText(), Title, "");
    }
    return;
}

function HandleAddBtn()
{
    Class'NWindow.PostWndAPI'.static.RequestAddingPostFriend(SenderID.GetText());
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("PostDetailWnd_SafetyTrade").HideWindow();
    return;
}
