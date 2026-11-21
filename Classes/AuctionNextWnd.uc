class AuctionNextWnd extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle AuctionNextItem;
var TextBoxHandle txtItemName;
var TextBoxHandle AuctionNextTime;
var TextureHandle GroupBox_AuctionNextTime;
var ButtonHandle btnClose;
var HtmlHandle HtmlViewer;

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("AuctionNextWnd");
    txtItemName = GetTextBoxHandle("AuctionNextWnd.txtItemName");
    AuctionNextTime = GetTextBoxHandle("AuctionNextWnd.AuctionNextTime");
    AuctionNextItem = GetItemWindowHandle("AuctionNextWnd.AuctionNextItem");
    btnClose = GetButtonHandle("AuctionNextWnd.BtnClose");
    HtmlViewer = GetHtmlHandle("AuctionNextWnd.HtmlViewer");
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(3051);
    RegisterEvent(3052);
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1D
        case "BtnClose":
            OnBtnCloseClick();
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnBtnCloseClick()
{
    Me.HideWindow();
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x45
        case 3051:
            Debug("EV_ITEM_AUCTION_NEXT_INFO" @ param);
            HandleAuctionNextInfo(param);
            // End:0x8B
            break;
        // End:0x88
        case 3052:
            Debug("EV_ITEM_AUCTION_NEXT_NOTEXIST" @ param);
            HandleAuctionNextInfo(param, true);
            // End:0x8B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleAuctionNextInfo(string param, optional bool bNoItem)
{
    local int startYear, startMon, startDay, startMin, startHour;

    local INT64 startPrice;
    local ItemInfo Info;

    Debug("HandleAuctionNextInfo param = " $ param);
    Me.ShowWindow();
    Me.SetFocus();
    ParseInt(param, "startTimeYear", startYear);
    ParseInt(param, "startTimeMonth", startMon);
    ParseInt(param, "startTimeDay", startDay);
    ParseInt(param, "startTimeHour", startHour);
    ParseInt(param, "startTimeMinute", startMin);
    ParseINT64(param, "startPrice", startPrice);
    // End:0x1B0
    if(bNoItem)
    {
        Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(15625), Info);
        AuctionNextItem.Clear();
        AuctionNextItem.AddItem(Info);
        AuctionNextItem.ClearTooltip();
        AuctionNextItem.SetTooltipType("text");
        txtItemName.SetText(GetSystemString(584));
        HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(GetSystemString(3552)));        
    }
    else
    {
        ParamToItemInfo(param, Info);
        AuctionNextItem.Clear();
        AuctionNextItem.AddItem(Info);
        AuctionNextItem.SetTooltipType("Inventory");
        txtItemName.SetText(Info.Name);
        HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(Info.Description));
    }
    // End:0x293
    if(startMin >= 10)
    {
        AuctionNextTime.SetText((((((((string(startYear) $ "/") $ string(startMon)) $ "/") $ string(startDay)) $ "  ") $ string(startHour)) $ ":") $ string(startMin));        
    }
    else
    {
        // End:0x300
        if((startMin < 10) || startMin >= 0)
        {
            AuctionNextTime.SetText(((((((((string(startYear) $ "/") $ string(startMon)) $ "/") $ string(startDay)) $ "  ") $ string(startHour)) $ ":") $ "0") $ string(startMin));
        }
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("AuctionNextWnd").HideWindow();
    return;
}
