class AuctionWnd extends UICommonAPI;

const TIMER_ID = 777;
const TIMER_DELAY = 1000;
const DIALOG_ASK_AUCTION_PRICE = 321;
const DIALOG_CONFIRM_PRICE = 432;
const ADENA_OVER_FLOW = "1000000000000";

var WindowHandle Me;
var TextBoxHandle txtRemainStr;
var TextBoxHandle txtTimeHour;
var TextBoxHandle txtTimeMin;
var TextBoxHandle txtTimeSec;
var TextBoxHandle txtHighBid;
var TextBoxHandle txtMyAdenaStr;
var TextBoxHandle txtMyAdena;
var TextBoxHandle txtItemInfoStr;
var ButtonHandle BtnBid1;
var ButtonHandle BtnBid2;
var ButtonHandle BtnBid3;
var ButtonHandle BtnBid4;
var ButtonHandle BtnBidInput;
var TextBoxHandle txtHighBidStr;
var ButtonHandle btnClose;
var ButtonHandle BtnNext;
var ItemWindowHandle AuctionItem;
var TextBoxHandle txtItemName;
var TextBoxHandle txtHighBid_word;
var INT64 m_myLastBidPrice;
var INT64 m_myBidPrice;
var INT64 m_currentPrice;
var int m_auctionID;
var ItemInfo m_auctionItem;
var int bShowUI;
var int iAuctionID;
var INT64 iCurrentPrice;
var int iRemainSecond;

function OnRegisterEvent()
{
    RegisterEvent(3050);
    RegisterEvent(9570);
    RegisterEvent(1710);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    load();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("AuctionWnd");
    txtRemainStr = GetTextBoxHandle("AuctionWnd.txtRemainStr");
    txtTimeHour = GetTextBoxHandle("AuctionWnd.txtTimeHour");
    txtTimeMin = GetTextBoxHandle("AuctionWnd.txtTimeMin");
    txtTimeSec = GetTextBoxHandle("AuctionWnd.txtTimeSec");
    txtHighBid = GetTextBoxHandle("AuctionWnd.txtHighBid");
    txtMyAdenaStr = GetTextBoxHandle("AuctionWnd.txtMyAdenaStr");
    txtMyAdena = GetTextBoxHandle("AuctionWnd.txtMyAdena");
    txtItemInfoStr = GetTextBoxHandle("AuctionWnd.txtItemInfoStr");
    BtnBid1 = GetButtonHandle("AuctionWnd.BtnBid1");
    BtnBid2 = GetButtonHandle("AuctionWnd.BtnBid2");
    BtnBid3 = GetButtonHandle("AuctionWnd.BtnBid3");
    BtnBid4 = GetButtonHandle("AuctionWnd.BtnBid4");
    BtnBidInput = GetButtonHandle("AuctionWnd.BtnBidInput");
    txtHighBidStr = GetTextBoxHandle("AuctionWnd.txtHighBidStr");
    btnClose = GetButtonHandle("AuctionWnd.BtnClose");
    AuctionItem = GetItemWindowHandle("AuctionWnd.AuctionItem");
    txtItemName = GetTextBoxHandle("AuctionWnd.txtItemName");
    BtnNext = GetButtonHandle("AuctionWnd.BtnNextAuction");
    txtHighBid_word = GetTextBoxHandle("AuctionWnd.txtHighBid_word");
    return;
}

function load()
{
    return;
}

function OnEvent(int Event_ID, string param)
{
    local ItemInfo Info;

    switch(Event_ID)
    {
        // End:0x100
        case 3050:
            ParseInt(param, "ShowUI", bShowUI);
            ParseInt(param, "AuctionID", iAuctionID);
            ParseINT64(param, "CurrentPrice", iCurrentPrice);
            ParseInt(param, "RemainSecond", iRemainSecond);
            ParamToItemInfo(param, Info);
            m_currentPrice = iCurrentPrice;
            m_auctionID = iAuctionID;
            m_auctionItem = Info;
            // End:0xF7
            if(bShowUI == 1)
            {
                InsertAuctionItem();
                m_hOwnerWnd.SetTimer(777, 1000);
                Me.ShowWindow();
                Me.SetFocus();
            }
            UpdateAuctionWnd();
            // End:0x125
            break;
        // End:0x111
        case 9570:
            myUpdateAdena();
            // End:0x125
            break;
        // End:0x122
        case 1710:
            HandleDialogOK();
            // End:0x125
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x23
    if(TimerID == 777)
    {
        Class'NWindow.AuctionAPI'.static.RequestInfoItemAuction(m_auctionID);
    }
    return;
}

function InsertAuctionItem()
{
    AuctionItem.Clear();
    AuctionItem.AddItem(m_auctionItem);
    AuctionItem.SetTooltipType("Inventory");
    txtItemName.SetText(m_auctionItem.Name);
    return;
}

function OnShow()
{
    BtnNext.EnableWindow();
    BtnBid1.EnableWindow();
    BtnBid2.EnableWindow();
    BtnBid3.EnableWindow();
    BtnBid4.EnableWindow();
    BtnBidInput.EnableWindow();
    return;
}

function OnHide()
{
    Class'NWindow.UIAPI_WINDOW'.static.KillUITimer("AuctionWnd", 777);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("AuctionWnd.AuctionItem");
    return;
}

function OnClickButton(string Name)
{
    m_myBidPrice = (-1);
    switch(Name)
    {
        // End:0xD3
        case "BtnBid1":
            m_myBidPrice = __NFUN_401__(m_currentPrice, (2));
            // End:0x90
            if(__NFUN_409__(m_myBidPrice, ("1000000000000")) || __NFUN_408__(m_myBidPrice, (0)))
            {
                BtnBid1.DisableWindow();
                BtnBid1.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2157)));                
            }
            else
            {
                DialogSetID(432);
                DialogShow(1, 4, MakeFullSystemMsg(GetSystemMessage(2137), m_auctionItem.Name, MakeCostString((m_myBidPrice))), string(self));
            }
            // End:0x42A
            break;
        // End:0x1A1
        case "BtnBid2":
            m_myBidPrice = __NFUN_404__(__NFUN_403__(__NFUN_401__(m_currentPrice, (5)), (10)), m_currentPrice);
            // End:0x15E
            if(__NFUN_409__(m_myBidPrice, ("1000000000000")) || __NFUN_408__(m_myBidPrice, (0)))
            {
                BtnBid2.DisableWindow();
                BtnBid2.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2157)));                
            }
            else
            {
                DialogSetID(432);
                DialogShow(1, 4, MakeFullSystemMsg(GetSystemMessage(2137), m_auctionItem.Name, MakeCostString((m_myBidPrice))), string(self));
            }
            // End:0x42A
            break;
        // End:0x268
        case "BtnBid3":
            m_myBidPrice = __NFUN_404__(__NFUN_403__(m_currentPrice, (10)), m_currentPrice);
            // End:0x225
            if(__NFUN_409__(m_myBidPrice, ("1000000000000")) || __NFUN_408__(m_myBidPrice, (0)))
            {
                BtnBid3.DisableWindow();
                BtnBid3.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2157)));                
            }
            else
            {
                DialogSetID(432);
                DialogShow(1, 4, MakeFullSystemMsg(GetSystemMessage(2137), m_auctionItem.Name, MakeCostString((m_myBidPrice))), string(self));
            }
            // End:0x42A
            break;
        // End:0x38F
        case "BtnBid4":
            m_myBidPrice = __NFUN_404__(__NFUN_403__(__NFUN_401__(m_currentPrice, (5)), (100)), m_currentPrice);
            Debug("m_myBidPrice" @ (m_myBidPrice));
            // End:0x310
            if(__NFUN_409__(m_myBidPrice, ("1000000000000")) || __NFUN_408__(m_myBidPrice, (0)))
            {
                BtnBid4.DisableWindow();
                BtnBid4.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2157)));                
            }
            else
            {
                DialogSetID(432);
                DialogShow(1, 4, MakeFullSystemMsg(GetSystemMessage(2137), m_auctionItem.Name, MakeCostString((m_myBidPrice))), string(self));
                Debug("MakeCostString(string(m_myBidPrice) )" @ MakeCostString((m_myBidPrice)));
            }
            // End:0x42A
            break;
        // End:0x3A8
        case "BtnBidInput":
            OnBtnBidInputClick();
            // End:0x42A
            break;
        // End:0x3DF
        case "BtnClose":
            // End:0x3DC
            if(IsShowWindow("AuctionWnd"))
            {
                HideWindow("AuctionWnd");
            }
            // End:0x42A
            break;
        // End:0x427
        case "BtnFailBid":
            RequestBypassToServer("item_auction_withdraw");
            Debug("유찰금 받기 실행!");
            // End:0x42A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function myUpdateAdena()
{
    local CustomTooltip cTooltip;

    txtMyAdena.SetText(MakeCostString((GetAdena())));
    addToolTipDrawList(cTooltip, addDrawItemText((ConvertNumToTextNoAdena((GetAdena())) $ " ") $ GetSystemString(469), getInstanceL2Util().White, "", false));
    txtMyAdena.SetTooltipCustomType(cTooltip);
    return;
}

function UpdateAuctionWnd()
{
    local int temp1, m_timeHour, m_timeMin, m_timeSec;
    local string tempStr;
    local INT64 tempPrice;

    txtHighBid.SetText((MakeCostString((m_currentPrice)) $ " ") $ GetSystemString(469));
    txtHighBid.SetTextColor(GetNumericColor((m_currentPrice)));
    txtHighBid_word.SetTextColor(GetNumericColor((m_currentPrice)));
    txtHighBid_word.SetText((ConvertNumToTextNoAdena((m_currentPrice)) $ " ") $ GetSystemString(469));
    myUpdateAdena();
    m_timeSec = int(float(iRemainSecond) % float(60));
    temp1 = iRemainSecond / 60;
    m_timeHour = temp1 / 60;
    m_timeMin = int(float(temp1) % float(60));
    // End:0x130
    if(m_timeHour > 0)
    {
        // End:0x117
        if(m_timeHour < 10)
        {
            txtTimeHour.SetText("0" $ string(m_timeHour));            
        }
        else
        {
            txtTimeHour.SetText(string(m_timeHour));
        }        
    }
    else
    {
        txtTimeHour.SetText("00");
    }
    // End:0x191
    if(m_timeMin > 0)
    {
        // End:0x178
        if(m_timeMin < 10)
        {
            txtTimeMin.SetText("0" $ string(m_timeMin));            
        }
        else
        {
            txtTimeMin.SetText(string(m_timeMin));
        }        
    }
    else
    {
        txtTimeMin.SetText("00");
    }
    // End:0x1F2
    if(m_timeSec > 0)
    {
        // End:0x1D9
        if(m_timeSec < 10)
        {
            txtTimeSec.SetText("0" $ string(m_timeSec));            
        }
        else
        {
            txtTimeSec.SetText(string(m_timeSec));
        }        
    }
    else
    {
        txtTimeSec.SetText("00");
    }
    tempPrice = __NFUN_401__(m_currentPrice, (2));
    // End:0x275
    if(__NFUN_409__(tempPrice, ("1000000000000")) || __NFUN_408__(tempPrice, (0)))
    {
        BtnBid1.DisableWindow();
        BtnBid1.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2076)));        
    }
    else
    {
        // End:0x298
        if(!BtnBid1.IsEnableWindow())
        {
            BtnBid1.EnableWindow();
        }
        tempStr = MakeFullSystemMsg(GetSystemMessage(2157), MakeCostString((tempPrice)));
        BtnBid1.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "", false, ("(" $ ConvertNumToText((tempPrice))) $ ")", GetNumericColor((tempPrice)), "", true));
    }
    tempPrice = __NFUN_404__(__NFUN_403__(__NFUN_401__(m_currentPrice, (5)), (10)), m_currentPrice);
    // End:0x38E
    if(__NFUN_409__(tempPrice, ("1000000000000")) || __NFUN_408__(tempPrice, (0)))
    {
        BtnBid2.DisableWindow();
        BtnBid2.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2076)));        
    }
    else
    {
        // End:0x3B1
        if(!BtnBid2.IsEnableWindow())
        {
            BtnBid2.EnableWindow();
        }
        tempStr = MakeFullSystemMsg(GetSystemMessage(2157), MakeCostString((tempPrice)));
        BtnBid2.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "", false, ("(" $ ConvertNumToText((tempPrice))) $ ")", GetNumericColor((tempPrice)), "", true));
    }
    tempPrice = __NFUN_404__(__NFUN_403__(m_currentPrice, (10)), m_currentPrice);
    // End:0x4A0
    if(__NFUN_409__(tempPrice, ("1000000000000")) || __NFUN_408__(tempPrice, (0)))
    {
        BtnBid3.DisableWindow();
        BtnBid3.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2076)));        
    }
    else
    {
        // End:0x4C3
        if(!BtnBid3.IsEnableWindow())
        {
            BtnBid3.EnableWindow();
        }
        tempStr = MakeFullSystemMsg(GetSystemMessage(2157), MakeCostString((tempPrice)));
        BtnBid3.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "", false, ("(" $ ConvertNumToText((tempPrice))) $ ")", GetNumericColor((tempPrice)), "", true));
    }
    tempPrice = __NFUN_404__(__NFUN_403__(__NFUN_401__(m_currentPrice, (5)), (100)), m_currentPrice);
    // End:0x5B9
    if(__NFUN_409__(tempPrice, ("1000000000000")) || __NFUN_408__(tempPrice, (0)))
    {
        BtnBid4.DisableWindow();
        BtnBid4.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(2076)));        
    }
    else
    {
        // End:0x5DC
        if(!BtnBid4.IsEnableWindow())
        {
            BtnBid4.EnableWindow();
        }
        tempStr = MakeFullSystemMsg(GetSystemMessage(2157), MakeCostString((tempPrice)));
        BtnBid4.SetTooltipCustomType(MakeTooltipMultiText(tempStr, getInstanceL2Util().White, "", false, ("(" $ ConvertNumToText((tempPrice))) $ ")", GetNumericColor((tempPrice)), "", true));
    }
    // End:0x68C
    if(((m_timeHour == 0) && m_timeMin == 0) && m_timeSec == 0)
    {
        m_hOwnerWnd.KillTimer(777);
    }
    // End:0x6F1
    if(iRemainSecond == 0)
    {
        BtnBid1.DisableWindow();
        BtnBid2.DisableWindow();
        BtnBid3.DisableWindow();
        BtnBid4.DisableWindow();
        BtnBidInput.DisableWindow();
        btnClose.EnableWindow();
    }
    return;
}

function OnBtnBidInputClick()
{
    DialogSetID(321);
    DialogSetEditType("number");
    DialogSetParamInt64((-1));
    DialogSetDefaultOK();
    DialogShow(1, 6, GetSystemMessage(2138), string(self));
    return;
}

function HandleDialogOK()
{
    local int Id;

    // End:0x9D
    if(DialogIsMine())
    {
        Id = DialogGetID();
        // End:0x75
        if(Id == 321)
        {
            m_myBidPrice = (DialogGetString());
            DialogSetID(432);
            DialogShow(1, 4, MakeFullSystemMsg(GetSystemMessage(2137), m_auctionItem.Name, MakeCostString((m_myBidPrice))), string(self));            
        }
        else
        {
            // End:0x9D
            if(Id == 432)
            {
                Class'NWindow.AuctionAPI'.static.RequestBidItemAuction(m_auctionID, m_myBidPrice);
            }
        }
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    OnClickButton("BtnClose");
    return;
}
