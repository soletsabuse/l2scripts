class PrivateMarketWnd extends UICommonAPI;

var WindowHandle Me;
var ListCtrlHandle m_hBuyListCtrlHandle;

function OnRegisterEvent()
{
    RegisterEvent(4860);
    RegisterEvent(4861);
    return;
}

function OnLoad()
{
    OnRegisterEvent();
    Me = GetWindowHandle("PrivateMarketWnd");
    m_hBuyListCtrlHandle = GetListCtrlHandle("PrivateMarketWnd.BuyList");
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function OnHide()
{
    Clear();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x36
        case 4860:
            Clear();
            Me.ShowWindow();
            Me.SetFocus();
            // End:0x4F
            break;
        // End:0x4C
        case 4861:
            HandleAddPrivateMarketList(a_Param);
            // End:0x4F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string a_ControlID)
{
    // End:0x26
    if(a_ControlID == "btnClose")
    {
        Me.HideWindow();        
    }
    else
    {
        // End:0x48
        if(a_ControlID == "btnRefresh")
        {
            Clear();
            RefreshPrivateMarketInfo();
        }
    }
    return;
}

function OnDBClickListCtrlRecord(string a_ListCtrlID)
{
    local LVDataRecord selectedRecord;

    // End:0x39
    if(a_ListCtrlID == "BuyList")
    {
        m_hBuyListCtrlHandle.GetSelectedRec(selectedRecord);
        RequestMoveToMerchant(name(selectedRecord.nReserved2));
    }
    return;
}

function Clear()
{
    ClearAllPrivateMarketInfo();
    DeleteAllRecords();
    return;
}

function HandleAddPrivateMarketList(string param)
{
    local string merchantName, ItemName;
    local int ItemID, merchantId;
    local INT64 Price;
    local string priceString;
    local LVDataRecord Record;
    local LVData merchantNameData, itemNameData, priceData;

    ParseString(param, "merchantName", merchantName);
    ParseString(param, "itemName", ItemName);
    ParseInt(param, "itemId", ItemID);
    ParseInt(param, "merchantId", merchantId);
    ParseINT64(param, "price", Price);
    merchantNameData.szData = merchantName;
    itemNameData.szData = ItemName;
    priceString = MakeCostString((Price));
    priceData.szData = priceString;
    Record.nReserved1 = (ItemID);
    Record.nReserved2 = (merchantId);
    Record.LVDataList[0] = merchantNameData;
    Record.LVDataList[1] = itemNameData;
    Record.LVDataList[2] = priceData;
    m_hBuyListCtrlHandle.InsertRecord(Record);
    return;
}

function DeleteAllRecords()
{
    m_hBuyListCtrlHandle.DeleteAllItem();
    return;
}
