class PostDetailWnd_General extends UICommonAPI;

const DIALOG_RETURN_POST = 1111;
const DIALOG_NOTIFY_SEND_CANCLE_PRIMESHOP = 2222;

var WindowHandle Me;
var WindowHandle SafetyTrade;
var TextBoxHandle Title_SenderID;
var TextBoxHandle SenderID;
var TextBoxHandle PostType;
var TextBoxHandle PostTitle;
var TextListBoxHandle PostContents;
var TextBoxHandle WeightText;
var ButtonHandle SendCancelBtn;
var ButtonHandle ReceiveBtn;
var ButtonHandle ReturnBtn;
var ButtonHandle ReplyBtn;
var ButtonHandle AddBtn;
var ItemWindowHandle AccompanyItem;
var int TRADE;
var int returnd;
var int mailID;
var int totalWeight;
var int returnAble;
var int sentBySystem;

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
    return;
}

function OnShow()
{
    // End:0x21
    if(SafetyTrade.IsShowWindow())
    {
        SafetyTrade.HideWindow();
    }
    return;
}

function Initialize()
{
    Me = GetHandle("PostDetailWnd_General");
    SafetyTrade = GetHandle("PostDetailWnd_SafetyTrade");
    Title_SenderID = TextBoxHandle(GetHandle("PostDetailWnd_General.Title_SenderID"));
    SenderID = TextBoxHandle(GetHandle("PostDetailWnd_General.SenderID"));
    PostType = TextBoxHandle(GetHandle("PostDetailWnd_General.PostType"));
    PostTitle = TextBoxHandle(GetHandle("PostDetailWnd_General.PostTitle"));
    PostContents = TextListBoxHandle(GetHandle("PostDetailWnd_General.PostContents"));
    WeightText = TextBoxHandle(GetHandle("PostDetailWnd_General.WeightText"));
    SendCancelBtn = ButtonHandle(GetHandle("PostDetailWnd_General.SendCancelBtn"));
    ReceiveBtn = ButtonHandle(GetHandle("PostDetailWnd_General.ReceiveBtn"));
    ReturnBtn = ButtonHandle(GetHandle("PostDetailWnd_General.ReternBtn"));
    ReplyBtn = ButtonHandle(GetHandle("PostDetailWnd_General.ReplyBtn"));
    AddBtn = ButtonHandle(GetHandle("PostDetailWnd_General.AddBtn"));
    AccompanyItem = ItemWindowHandle(GetHandle("PostDetailWnd_General.AccompanyItem"));
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("PostDetailWnd_General.PostDetailWnd_General");
    SafetyTrade = GetWindowHandle("PostDetailWnd_SafetyTrade");
    Title_SenderID = GetTextBoxHandle("PostDetailWnd_General.Title_SenderID");
    SenderID = GetTextBoxHandle("PostDetailWnd_General.SenderID");
    PostType = GetTextBoxHandle("PostDetailWnd_General.PostType");
    PostTitle = GetTextBoxHandle("PostDetailWnd_General.PostTitle");
    PostContents = GetTextListBoxHandle("PostDetailWnd_General.PostContents");
    WeightText = GetTextBoxHandle("PostDetailWnd_General.WeightText");
    SendCancelBtn = GetButtonHandle("PostDetailWnd_General.SendCancelBtn");
    ReceiveBtn = GetButtonHandle("PostDetailWnd_General.ReceiveBtn");
    ReturnBtn = GetButtonHandle("PostDetailWnd_General.ReternBtn");
    ReplyBtn = GetButtonHandle("PostDetailWnd_General.ReplyBtn");
    AddBtn = GetButtonHandle("PostDetailWnd_General.AddBtn");
    AccompanyItem = GetItemWindowHandle("PostDetailWnd_General.AccompanyItem");
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
            // End:0x147
            break;
        // End:0x33
        case 4741:
            OnEVReplyReceivedPostAddItem(param);
            // End:0x147
            break;
        // End:0x49
        case 4742:
            OnEVReplyReceivedPostEnd(param);
            // End:0x147
            break;
        // End:0x5F
        case 4780:
            OnEVReplySentPostStart(param);
            // End:0x147
            break;
        // End:0x75
        case 4781:
            OnEVReplySentPostAddItem(param);
            // End:0x147
            break;
        // End:0x8B
        case 4782:
            OnEVReplySentPostEnd(param);
            // End:0x147
            break;
        // End:0x9C
        case 1710:
            HandleDialogOK();
            // End:0x147
            break;
        // End:0x144
        case 110:
            ParseInt(param, "ZoneCode", zonetype);
            // End:0xF7
            if(zonetype == 12)
            {
                SendCancelBtn.EnableWindow();
                ReceiveBtn.EnableWindow();
                ReturnBtn.EnableWindow();                
            }
            else
            {
                // End:0x114
                if(Me.IsShowWindow())
                {
                    AddSystemMessage(3066);
                }
                SendCancelBtn.DisableWindow();
                ReceiveBtn.DisableWindow();
                ReturnBtn.DisableWindow();
            }
            // End:0x147
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
    if((returnd == 1) || TRADE == 0)
    {
        Me.SetWindowTitle(GetSystemString(2075));
        ReceiveBtn.HideWindow();
        ReturnBtn.ShowWindow();
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

    // End:0x5B
    if((returnd == 1) || TRADE == 0)
    {
        ParamToItemInfo(param, Info);
        AccompanyItem.AddItem(Info);
        totalWeight += (Info.Weight * name(Info.ItemNum));
    }
    return;
}

function string addComma(bool bComma, string Text)
{
    // End:0x15
    if(bComma)
    {
        return ", " $ Text;
    }
    return Text;
    return;
}

function OnEVReplyReceivedPostEnd(string param)
{
    local string senderName, Title, contents;
    local INT64 tradeMoney;
    local string fixedtitle;
    local int SendId, contentSystemMsgID, ClassID, Enchant;
    local string NpcName;
    local int titleSystemMsgId, valueFire, valueWater, valueWind, valueEarth, valueHoly,
	    valueUnholy;

    local bool isAttribute;
    local string attStr;
    local ItemID cItemID;
    local ItemInfo cItemInfo;

    Title_SenderID.SetText(GetSystemString(2078));
    // End:0xD51
    if((returnd == 1) || TRADE == 0)
    {
        ParseInt(param, "MailID", mailID);
        ParseString(param, "SenderName", senderName);
        ParseInt(param, "SenderId", SendId);
        ParseString(param, "Title", Title);
        ParseInt(param, "TitleSystemMsgId", titleSystemMsgId);
        ParseString(param, "Content", contents);
        ParseInt(param, "ContentSystemMsgID", contentSystemMsgID);
        ParseInt(param, "ClassID", ClassID);
        ParseInt(param, "Enchant", Enchant);
        ParseINT64(param, "TradeMoney", tradeMoney);
        ParseInt(param, "ReturnAble", returnAble);
        ParseInt(param, "Sentbysystem", sentBySystem);
        ParseInt(param, "attrFire", valueFire);
        ParseInt(param, "attrWater", valueWater);
        ParseInt(param, "attrWind", valueWind);
        ParseInt(param, "attrEarth", valueEarth);
        ParseInt(param, "attrHoly", valueHoly);
        ParseInt(param, "attrUnholy", valueUnholy);
        // End:0x247
        if(sentBySystem == 7)
        {
            PostType.SetText(GetSystemString(5080));            
        }
        else
        {
            PostType.SetText(GetSystemString(2071));
        }
        // End:0x28C
        if((sentBySystem == 4) || sentBySystem == 5)
        {
            Title = GetSystemMessage(titleSystemMsgId);
        }
        fixedtitle = DivideStringWithWidth(Title, 380);
        // End:0x2C3
        if(fixedtitle != Title)
        {
            fixedtitle = fixedtitle $ "...";
        }
        // End:0x308
        if(returnd == 1)
        {
            fixedtitle = (("[" $ GetSystemString(2090)) $ "] ") $ fixedtitle;
            PostTitle.SetText(fixedtitle);            
        }
        else
        {
            PostTitle.SetText(fixedtitle);
        }
        isAttribute = false;
        // End:0x344
        if(sentBySystem == 4)
        {
            contents = GetSystemMessage(contentSystemMsgID);            
        }
        else
        {
            // End:0x8CD
            if(sentBySystem == 5)
            {
                cItemID.ClassID = ClassID;
                Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cItemID, cItemInfo);
                // End:0x5D3
                if(cItemInfo.ItemType == int(0))
                {
                    // End:0x3B5
                    if(Enchant > 0)
                    {
                        contents = (("+" $ string(Enchant)) $ " ") $ contents;
                    }
                    contents = ((contents $ "( ") $ GetSystemString(1596)) $ ": ";
                    // End:0x419
                    if(valueFire > 0)
                    {
                        attStr = attStr $ (addComma(isAttribute, GetSystemString(1622) $ string(valueFire)));
                        isAttribute = true;
                    }
                    // End:0x459
                    if(valueWater > 0)
                    {
                        attStr = attStr $ (addComma(isAttribute, GetSystemString(1623) $ string(valueWater)));
                        isAttribute = true;
                    }
                    // End:0x499
                    if(valueWind > 0)
                    {
                        attStr = attStr $ (addComma(isAttribute, GetSystemString(1624) $ string(valueWind)));
                        isAttribute = true;
                    }
                    // End:0x4D9
                    if(valueEarth > 0)
                    {
                        attStr = attStr $ (addComma(isAttribute, GetSystemString(1625) $ string(valueEarth)));
                        isAttribute = true;
                    }
                    // End:0x519
                    if(valueHoly > 0)
                    {
                        attStr = attStr $ (addComma(isAttribute, GetSystemString(1626) $ string(valueHoly)));
                        isAttribute = true;
                    }
                    // End:0x559
                    if(valueUnholy > 0)
                    {
                        attStr = attStr $ (addComma(isAttribute, GetSystemString(1627) $ string(valueUnholy)));
                        isAttribute = true;
                    }
                    // End:0x59C
                    if((((((valueFire + valueWater) + valueWind) + valueEarth) + valueHoly) + valueUnholy) <= 0)
                    {
                        attStr = attStr $ GetSystemString(27);
                    }
                    contents = (contents $ attStr) $ " )";
                    contents = MakeFullSystemMsg(GetSystemMessage(contentSystemMsgID), contents);                    
                }
                else
                {
                    // End:0x8B1
                    if(cItemInfo.ItemType == int(1))
                    {
                        // End:0x60F
                        if(Enchant > 0)
                        {
                            contents = (("+" $ string(Enchant)) $ " ") $ contents;
                        }
                        contents = ((contents $ "( ") $ GetSystemString(1596)) $ ": ";
                        // End:0x689
                        if(valueFire > 0)
                        {
                            attStr = attStr $ (addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1622) $ " ") $ string(valueFire)));
                            isAttribute = true;
                        }
                        // End:0x6DF
                        if(valueWater > 0)
                        {
                            attStr = attStr $ (addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1623) $ " ") $ string(valueWater)));
                            isAttribute = true;
                        }
                        // End:0x735
                        if(valueWind > 0)
                        {
                            attStr = attStr $ (addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1624) $ " ") $ string(valueWind)));
                            isAttribute = true;
                        }
                        // End:0x78B
                        if(valueEarth > 0)
                        {
                            attStr = attStr $ (addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1625) $ " ") $ string(valueEarth)));
                            isAttribute = true;
                        }
                        // End:0x7E1
                        if(valueHoly > 0)
                        {
                            attStr = attStr $ (addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1626) $ " ") $ string(valueHoly)));
                            isAttribute = true;
                        }
                        // End:0x837
                        if(valueUnholy > 0)
                        {
                            attStr = attStr $ (addComma(isAttribute, MakeFullSystemMsg(GetSystemMessage(2215), GetSystemString(1627) $ " ") $ string(valueUnholy)));
                            isAttribute = true;
                        }
                        // End:0x87A
                        if((((((valueFire + valueWater) + valueWind) + valueEarth) + valueHoly) + valueUnholy) <= 0)
                        {
                            attStr = attStr $ GetSystemString(27);
                        }
                        contents = (contents $ attStr) $ " )";
                        contents = MakeFullSystemMsg(GetSystemMessage(contentSystemMsgID), contents);                        
                    }
                    else
                    {
                        contents = MakeFullSystemMsg(GetSystemMessage(contentSystemMsgID), contents);
                    }
                }
            }
        }
        PostContents.AddString(contents, GetChatColorByType(0));
        PostContents.SetTextListBoxScrollPosition(0);
        // End:0x930
        if(AccompanyItem.GetItemNum() != 0)
        {
            // End:0x930
            if(!ReceiveBtn.IsShowWindow())
            {
                ReceiveBtn.ShowWindow();
            }
        }
        // End:0x9AA
        if(returnAble == 1)
        {
            // End:0x998
            if(ReceiveBtn.IsShowWindow())
            {
                ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomRight", -1, -4);
            }
            ReturnBtn.ShowWindow();            
        }
        else
        {
            // End:0xA04
            if(ReceiveBtn.IsShowWindow())
            {
                ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
            }
            ReturnBtn.HideWindow();
        }
        // End:0xA63
        if(sentBySystem == 1)
        {
            // End:0xA46
            if(returnd == 1)
            {
                SenderID.SetText(GetSystemString(2073));                
            }
            else
            {
                SenderID.SetText(GetSystemString(2211));
            }            
        }
        else
        {
            // End:0xAAD
            if(sentBySystem == 2)
            {
                NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(SendId);
                // End:0xAAA
                if(Len(NpcName) > 0)
                {
                    SenderID.SetText(NpcName);
                }                
            }
            else
            {
                // End:0xAD6
                if(sentBySystem == 3)
                {
                    SenderID.SetText(GetSystemString(2316));                    
                }
                else
                {
                    // End:0xB17
                    if((sentBySystem == 4) || sentBySystem == 5)
                    {
                        SenderID.SetText(GetSystemString(Class'NWindow.ConsignmentSaleAPI'.static.GetCommissionSellerID()));                        
                    }
                    else
                    {
                        // End:0xBAE
                        if(sentBySystem == 6)
                        {
                            SendId = Class'NWindow.UIDATA_NPC'.static.GetMentoringNPCId();
                            // End:0xB81
                            if(SendId > 0)
                            {
                                NpcName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(SendId);
                                // End:0xB7E
                                if(Len(NpcName) > 0)
                                {
                                    SenderID.SetText(NpcName);
                                }                                
                            }
                            else
                            {
                                Debug("Error : 'SendId' is wrong" @ string(SendId));
                            }                            
                        }
                        else
                        {
                            SenderID.SetText(senderName);
                        }
                    }
                }
            }
        }
        // End:0xC72
        if((((sentBySystem == 1) || sentBySystem == 3) || sentBySystem == 5) || sentBySystem == 6)
        {
            // End:0xC51
            if(ReceiveBtn.IsShowWindow())
            {
                ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
            }
            ReturnBtn.HideWindow();
            ReplyBtn.HideWindow();            
        }
        else
        {
            ReplyBtn.EnableWindow();
            ReplyBtn.ShowWindow();
        }
        // End:0xD0E
        if(AccompanyItem.GetItemNum() == 0)
        {
            // End:0xCFF
            if(ReceiveBtn.IsShowWindow())
            {
                ReceiveBtn.SetAnchor("PostDetailWnd_General", "BottomCenter", "BottomCenter", 0, -4);
            }
            ReturnBtn.HideWindow();
        }
        // End:0xD2C
        if(sentBySystem == 9)
        {
            AddBtn.DisableWindow();            
        }
        else
        {
            AddBtn.EnableWindow();
        }
        WeightText.SetText(string(totalWeight));
    }
    return;
}

function OnEVReplySentPostStart(string param)
{
    ClearAll();
    ParseInt(param, "trade", TRADE);
    ParseInt(param, "Sentbysystem", sentBySystem);
    // End:0xBA
    if(TRADE == 0)
    {
        Me.SetWindowTitle(GetSystemString(2076));
        ReceiveBtn.HideWindow();
        ReturnBtn.HideWindow();
        SendCancelBtn.ShowWindow();
        ReplyBtn.HideWindow();
        Me.ShowWindow();
        Me.SetFocus();
    }
    // End:0xD8
    if(sentBySystem == 7)
    {
        AddBtn.HideWindow();        
    }
    else
    {
        AddBtn.ShowWindow();
    }
    return;
}

function OnEVReplySentPostAddItem(string param)
{
    local ItemInfo Info;

    // End:0x56
    if(TRADE == 0)
    {
        ParamToItemInfo(param, Info);
        AccompanyItem.AddItem(Info);
        Debug("OnEVReplySentPostAddItem" @ param);
    }
    return;
}

function OnEVReplySentPostEnd(string param)
{
    local string receivername, Title, contents;
    local INT64 tradeMoney;
    local int notOpend;
    local string fixedtitle;

    ParseInt(param, "Sentbysystem", sentBySystem);
    // End:0x200
    if(TRADE == 0)
    {
        ParseInt(param, "MailID", mailID);
        ParseString(param, "ReceiverName", receivername);
        ParseString(param, "Title", Title);
        ParseString(param, "Content", contents);
        ParseINT64(param, "TradeMoney", tradeMoney);
        ParseInt(param, "NotOpend", notOpend);
        ParseInt(param, "Sentbysystem", sentBySystem);
        // End:0x10C
        if(sentBySystem == 7)
        {
            PostType.SetText(GetSystemString(5080));            
        }
        else
        {
            PostType.SetText(GetSystemString(2071));
        }
        fixedtitle = DivideStringWithWidth(Title, 380);
        // End:0x15D
        if(fixedtitle != Title)
        {
            fixedtitle = fixedtitle $ "...";
        }
        PostTitle.SetText(fixedtitle);
        Title_SenderID.SetText(GetSystemString(2087));
        PostContents.AddString(contents, GetChatColorByType(0));
        PostContents.SetTextListBoxScrollPosition(0);
        SenderID.SetText(receivername);
        // End:0x1F1
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
    PostType.SetText(GetSystemString(2071));
    PostTitle.SetText("");
    PostContents.Clear();
    WeightText.SetText("0");
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
        // End:0x33
        case "ReceiveBtn":
            RequestReceivePost(mailID);
            Me.HideWindow();
            // End:0x126
            break;
        // End:0x92
        case "ReternBtn":
            // End:0x8F
            if((returnd == 1) || (TRADE == 0) && returnAble == 1)
            {
                DialogHide();
                DialogShow(1, 0, GetSystemMessage(3063), string(self));
                DialogSetID(1111);
            }
            // End:0x126
            break;
        // End:0xF9
        case "SendCancelBtn":
            // End:0xDC
            if(sentBySystem == 7)
            {
                DialogHide();
                DialogShow(1, 0, GetSystemMessage(6066), string(self));
                DialogSetID(2222);                
            }
            else
            {
                RequestCancelSentPost(mailID);
                Me.HideWindow();
            }
            // End:0x126
            break;
        // End:0x10F
        case "ReplyBtn":
            HandleReplyBtn();
            // End:0x126
            break;
        // End:0x123
        case "AddBtn":
            HandleAddBtn();
            // End:0x126
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
            RequestRejectPost(mailID);
            Me.HideWindow();            
        }
        else
        {
            // End:0x6A
            if(Id == 2222)
            {
                RequestCancelSentPost(mailID);
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
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PostDetailWnd_General");
    return;
}
