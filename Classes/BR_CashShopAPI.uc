class BR_CashShopAPI extends UICommonAPI;

const CASHSHOPPAYMENTTYPE_CASH = 0;
const CASHSHOPPAYMENTTYPE_ADENA = 1;
const CASHSHOPPAYMENTTYPE_EVENTCOIN = 2;
const ITEM_INFO_WIDTH = 256;
const DRAWPANEL_ITEM_INFO_WIDTH = 208;
const DAY_SUN = 0x00000001;
const DAY_MON = 0x00000002;
const DAY_TUE = 0x00000004;
const DAY_WED = 0x00000008;
const DAY_THU = 0x00000010;
const DAY_FRI = 0x00000020;
const DAY_SAT = 0x00000040;

enum EPreItemPanelType
{
    PIPT_EVENT,                     // 0
    PIPT_SALE,                      // 1
    PIPT_NEW,                       // 2
    PIPT_STAR,                      // 3
    PIPT_MAX                        // 4
};

var DrawItemInfo m_kDrawInfoClear;
var array<string> m_UI_prime_panel_Main;
var array<string> m_UI_prime_panel_Item;
var bool m_bCoinToMoney;
var bool m_bPresent;
var float m_fCoinMoneyValue;
var array<ProductInfo> m_ProductList;
var array<ProductInfo> m_RecentList;
var array<ProductInfo> m_BasketList;
var bool m_bOpenBuyWnd;

function OnRegisterEvent()
{
    RegisterEvent(9020);
    RegisterEvent(9023);
    RegisterEvent(9025);
    RegisterEvent(9021);
    RegisterEvent(9026);
    RegisterEvent(9028);
    RegisterEvent(9027);
    RegisterEvent(9013);
    return;
}

function OnLoad()
{
    m_bCoinToMoney = IsBr_CashShopCoinToMoney();
    // End:0x22
    if(m_bCoinToMoney)
    {
        m_fCoinMoneyValue = GetBr_CashShopCoinToMoneyValue();
    }
    m_bPresent = IsBr_CashShopPresent();
    m_ProductList.Length = 0;
    m_RecentList.Length = 0;
    m_BasketList.Length = 0;
    m_bOpenBuyWnd = false;
    m_UI_prime_panel_Main.Length = ConvertPreItemPanelType(4);
    m_UI_prime_panel_Item.Length = ConvertPreItemPanelType(4);
    m_UI_prime_panel_Main[ConvertPreItemPanelType(0)] = "BranchSys3.ui.g_ui_prime_panel_event";
    m_UI_prime_panel_Main[ConvertPreItemPanelType(1)] = "BranchSys3.ui.g_ui_prime_panel_sale";
    m_UI_prime_panel_Main[ConvertPreItemPanelType(2)] = "BranchSys3.ui.g_ui_prime_panel_new";
    m_UI_prime_panel_Main[ConvertPreItemPanelType(3)] = "BranchSys3.ui.g_ui_prime_panel_best";
    m_UI_prime_panel_Item[ConvertPreItemPanelType(0)] = "BranchSys3.ui.g_ui_prime_panel_event_s";
    m_UI_prime_panel_Item[ConvertPreItemPanelType(1)] = "BranchSys3.ui.g_ui_prime_panel_sale_s";
    m_UI_prime_panel_Item[ConvertPreItemPanelType(2)] = "BranchSys3.ui.g_ui_prime_panel_new_s";
    m_UI_prime_panel_Item[ConvertPreItemPanelType(3)] = "BranchSys3.ui.g_ui_prime_panel_best_s";
    return;
}

function bool GetOpenBuyWnd()
{
    return m_bOpenBuyWnd;
    return;
}

function SetOpenBuyWnd(bool Open)
{
    m_bOpenBuyWnd = Open;
    return;
}

function ClearItemList(int allclear)
{
    // End:0x13
    if(allclear > 0)
    {
        m_ProductList.Length = 0;
    }
    return;
}

function ClearBasketItemList()
{
    local int i;

    m_BasketList.Length = 0;
    i = 0;
    J0x0F:

    // End:0x3C [Loop If]
    if(i < m_ProductList.Length)
    {
        m_ProductList[i].bMyShopBasketEnable = false;
        i++;
        // [Loop Continue]
        goto J0x0F;
    }
    return;
}

function ClearRecentList()
{
    m_RecentList.Length = 0;
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int iResult, iProductType;

    switch(Event_ID)
    {
        // End:0x1F
        case 9020:
            AddProductItem(0, param);
            // End:0x118
            break;
        // End:0x37
        case 9023:
            AddProductItemData(0, param);
            // End:0x118
            break;
        // End:0x4F
        case 9025:
            AddProductItem(1, param);
            // End:0x118
            break;
        // End:0x67
        case 9026:
            AddProductItem(2, param);
            // End:0x118
            break;
        // End:0x7F
        case 9027:
            AddProductItemData(1, param);
            // End:0x118
            break;
        // End:0x97
        case 9028:
            AddProductItemData(2, param);
            // End:0x118
            break;
        // End:0x112
        case 9021:
            ParseInt(param, "Option", iResult);
            ParseInt(param, "ProductType", iProductType);
            // End:0xE9
            if(iProductType == 0)
            {
                ClearItemList(1);                
            }
            else
            {
                // End:0xFD
                if(iProductType == 1)
                {
                    ClearRecentList();                    
                }
                else
                {
                    // End:0x10F
                    if(iProductType == 2)
                    {
                        ClearBasketItemList();
                    }
                }
            }
            // End:0x118
            break;
        // End:0xFFFF
        default:
            // End:0x118
            break;
            break;
    }
    return;
}

function array<ProductInfo> GetBasketProductList()
{
    return m_BasketList;
    return;
}

function array<ProductInfo> GetRecentProductList()
{
    return m_RecentList;
    return;
}

function int ProductListCount()
{
    return m_ProductList.Length;
    return;
}

function ProductInfo ArrayProductItem(int Index)
{
    return m_ProductList[Index];
    return;
}

function bool UpdateBasketProductItem(ButtonHandle a_ButtonHandle, int ProductID, bool BasketCheck)
{
    local int SelectedProductID;

    SetBasketProductItem(ProductID, BasketCheck);
    SelectedProductID = a_ButtonHandle.GetButtonValue();
    // End:0x33
    if(SelectedProductID < 0)
    {
        return false;
    }
    // End:0x55
    if(SelectedProductID == ProductID)
    {
        UpdateBasketProductWindow(a_ButtonHandle, BasketCheck);
        return true;
    }
    return false;
    return;
}

function DeleteBasketProductItem(int ProductID)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x56 [Loop If]
    if(i < m_BasketList.Length)
    {
        // End:0x4C
        if(m_BasketList[i].iProductID == ProductID)
        {
            m_BasketList.Remove(i, 1);
            SetBasketProductItem(ProductID, false);
            // [Explicit Break]
            goto J0x56;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x56:

    return;
}

function SetBasketProductItemData()
{
    local int i;
    local ProductInfo ProductItem;

    i = 0;
    J0x07:

    // End:0x60 [Loop If]
    if(i < m_ProductList.Length)
    {
        ProductItem = GetBasketProductItem(m_ProductList[i].iProductID);
        // End:0x56
        if(ProductItem.iProductID > 0)
        {
            m_ProductList[i].bMyShopBasketEnable = true;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function SetBasketProductItem(int Id, bool Enable)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x53 [Loop If]
    if(i < m_ProductList.Length)
    {
        // End:0x49
        if(m_ProductList[i].iProductID == Id)
        {
            m_ProductList[i].bMyShopBasketEnable = Enable;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function AddMyShopBasketProductItem(int Id)
{
    local int iCurrentIndex;
    local ProductInfo ProductItem;

    ProductItem = GetBasketProductItem(Id);
    // End:0x5E
    if(ProductItem.iProductID < 0)
    {
        ProductItem = GetProductItem(Id);
        iCurrentIndex = m_BasketList.Length;
        m_BasketList.Length = iCurrentIndex + 1;
        m_BasketList[iCurrentIndex] = ProductItem;
    }
    Debug("m_BasketList Count" $ string(m_BasketList.Length));
    return;
}

function ProductInfo GetProductItem(int Id)
{
    local int i;
    local ProductInfo ProductItem;

    ProductItem.iProductID = -1;
    i = 0;
    J0x17:

    // End:0x57 [Loop If]
    if(i < m_ProductList.Length)
    {
        // End:0x4D
        if(m_ProductList[i].iProductID == Id)
        {
            return m_ProductList[i];
        }
        i++;
        // [Loop Continue]
        goto J0x17;
    }
    return ProductItem;
    return;
}

function ProductInfo GetBasketProductItem(int Id)
{
    local int i;
    local ProductInfo ProductItem;

    ProductItem.iProductID = -1;
    i = 0;
    J0x17:

    // End:0x57 [Loop If]
    if(i < m_BasketList.Length)
    {
        // End:0x4D
        if(m_BasketList[i].iProductID == Id)
        {
            return m_BasketList[i];
        }
        i++;
        // [Loop Continue]
        goto J0x17;
    }
    return ProductItem;
    return;
}

function AddProductItem(UIEventManager.EBR_CashShopProduct Type, string param)
{
    local int iID, Category, paymenttype, itempaneltype, showtab, Price;

    local string ItemName, IconName, Desc, mainsubject;
    local int start_sale, end_sale, salepercent, MinLevel, MaxLevel, minbirthday,
	    maxbirthday, restrictionday, availablecount, day_week, start_hour,
	    start_min, end_hour, end_min, stock, max_stock,
	    iCurrentIndex;

    local ProductInfo ProductItem;

    ParseInt(param, "ID", iID);
    ParseInt(param, "Category", Category);
    ParseInt(param, "PaymentType", paymenttype);
    ParseInt(param, "ShowTab", showtab);
    ParseInt(param, "Price", Price);
    ParseInt(param, "ItemPanelType", itempaneltype);
    ParseString(param, "ItemName", ItemName);
    ParseString(param, "IconName", IconName);
    ParseInt(param, "StartSale", start_sale);
    ParseInt(param, "EndSale", end_sale);
    ParseInt(param, "DayWeek", day_week);
    ParseInt(param, "StartHour", start_hour);
    ParseInt(param, "StartMin", start_min);
    ParseInt(param, "EndHour", end_hour);
    ParseInt(param, "EndMin", end_min);
    ParseInt(param, "Stock", stock);
    ParseInt(param, "MaxStock", max_stock);
    ParseInt(param, "SalePercent", salepercent);
    ParseInt(param, "MinLevel", MinLevel);
    ParseInt(param, "MaxLevel", MaxLevel);
    ParseInt(param, "MinBirthday", minbirthday);
    ParseInt(param, "MaxBirthday", maxbirthday);
    ParseInt(param, "RestrictionDay", restrictionday);
    ParseInt(param, "AvailableCount", availablecount);
    ParseString(param, "Desc", Desc);
    ProductItem.iProductID = iID;
    ProductItem.iCategory = Category;
    ProductItem.iPaymentType = paymenttype;
    ProductItem.iShowTab = showtab;
    ProductItem.iPanel_Type = itempaneltype;
    ProductItem.iSale_Percent = salepercent;
    ProductItem.iPrice = Price;
    ProductItem.strName = ItemName;
    ProductItem.strIconName = IconName;
    ProductItem.iStartSale = start_sale;
    ProductItem.iEndSale = end_sale;
    ProductItem.iDayWeek = day_week;
    ProductItem.iStartHour = start_hour;
    ProductItem.iStartMin = start_min;
    ProductItem.iEndHour = end_hour;
    ProductItem.iEndMin = end_min;
    ProductItem.iStock = stock;
    ProductItem.iMaxStock = max_stock;
    ProductItem.bMyShopBasketEnable = false;
    ProductItem.iMinLevel = MinLevel;
    ProductItem.iMaxLevel = MaxLevel;
    ProductItem.iMinBirthday = minbirthday;
    ProductItem.iMaxBirthday = maxbirthday;
    ProductItem.iRestrictionDay = restrictionday;
    ProductItem.iAvailableCount = availablecount;
    Debug((((("===============add recent : " $ string(Type)) $ " ") $ string(iCurrentIndex)) $ ",") $ string(m_RecentList.Length));
    ProductItem.bLimited = false;
    // End:0x4E0
    if((!(((start_hour == 0) && start_min == 0) && end_hour == 23) && end_min == 59 || day_week != 127) || BR_GetDayType(end_sale, 0) < 2037)
    {
        ProductItem.bLimited = true;
    }
    ProductItem.bEnable = false;
    ProductItem.strDesc = Desc;
    // End:0x569
    if(int(Type) == int(0))
    {
        ParseString(param, "MainSubject", mainsubject);
        ProductItem.strMainSubject = mainsubject;
        iCurrentIndex = m_ProductList.Length;
        m_ProductList.Length = iCurrentIndex + 1;
        m_ProductList[iCurrentIndex] = ProductItem;        
    }
    else
    {
        // End:0x5A8
        if(int(Type) == int(1))
        {
            iCurrentIndex = m_RecentList.Length;
            m_RecentList.Length = iCurrentIndex + 1;
            m_RecentList[iCurrentIndex] = ProductItem;            
        }
        else
        {
            // End:0x5F1
            if(int(Type) == int(2))
            {
                ProductItem.bMyShopBasketEnable = true;
                iCurrentIndex = m_BasketList.Length;
                m_BasketList.Length = iCurrentIndex + 1;
                m_BasketList[iCurrentIndex] = ProductItem;
            }
        }
    }
    return;
}

function AddProductItemData(UIEventManager.EBR_CashShopProduct Type, string param)
{
    local int iID, iAmount, Weight, TRADE;
    local string Desc;
    local int iCurrentIndex, iitemIndex;
    local ProductItem item;

    ParseInt(param, "ID", iID);
    ParseInt(param, "Amount", iAmount);
    ParseInt(param, "Weight", Weight);
    ParseInt(param, "Trade", TRADE);
    ParseString(param, "Desc", Desc);
    item.iItemID = iID;
    item.iAmount = iAmount;
    item.iWeight = Weight;
    item.iTradable = TRADE;
    item.strDesc = Desc;
    // End:0x130
    if(int(Type) == int(0))
    {
        iCurrentIndex = m_ProductList.Length - 1;
        iitemIndex = m_ProductList[iCurrentIndex].itemarray.Length;
        m_ProductList[iCurrentIndex].itemarray.Length = iitemIndex + 1;
        m_ProductList[iCurrentIndex].itemarray[iitemIndex] = item;        
    }
    else
    {
        // End:0x19F
        if(int(Type) == int(1))
        {
            iCurrentIndex = m_RecentList.Length - 1;
            iitemIndex = m_RecentList[iCurrentIndex].itemarray.Length;
            m_RecentList[iCurrentIndex].itemarray.Length = iitemIndex + 1;
            m_RecentList[iCurrentIndex].itemarray[iitemIndex] = item;            
        }
        else
        {
            // End:0x20B
            if(int(Type) == int(2))
            {
                iCurrentIndex = m_BasketList.Length - 1;
                iitemIndex = m_BasketList[iCurrentIndex].itemarray.Length;
                m_BasketList[iCurrentIndex].itemarray.Length = iitemIndex + 1;
                m_BasketList[iCurrentIndex].itemarray[iitemIndex] = item;
            }
        }
    }
    return;
}

function OnBtnBuyClick(int ProductID)
{
    local string strParam;
    local ProductInfo ProductItem;

    ProductItem = GetProductItem(ProductID);
    // End:0x12D
    if(ProductItem.iProductID > 0)
    {
        ParamAdd(strParam, "ID", string(ProductID));
        ParamAdd(strParam, "Price", string(ProductItem.iPrice));
        ParamAdd(strParam, "PaymentType", string(ProductItem.iPaymentType));
        ParamAdd(strParam, "ItemName", ProductItem.strName);
        ParamAdd(strParam, "IconName", ProductItem.strIconName);
        // End:0x102
        if(m_bCoinToMoney)
        {
            ParamAdd(strParam, "CoinToMoney", string(1));
            ParamAdd(strParam, "CoinToMoneyValue", string(m_fCoinMoneyValue));            
        }
        else
        {
            ParamAdd(strParam, "CoinToMoney", string(0));
        }
        ExecuteEvent(9070, strParam);
    }
    return;
}

function OnBtnPresentClick(int ProductID)
{
    local string strParam;
    local ProductInfo ProductItem;

    ProductItem = GetProductItem(ProductID);
    // End:0x109
    if(ProductItem.iProductID > 0)
    {
        ParamAdd(strParam, "ID", string(ProductID));
        ParamAdd(strParam, "Price", string(ProductItem.iPrice));
        ParamAdd(strParam, "ItemName", ProductItem.strName);
        ParamAdd(strParam, "IconName", ProductItem.strIconName);
        // End:0xDE
        if(m_bCoinToMoney)
        {
            ParamAdd(strParam, "CoinToMoney", string(1));
            ParamAdd(strParam, "CoinToMoneyValue", string(m_fCoinMoneyValue));            
        }
        else
        {
            ParamAdd(strParam, "CoinToMoney", string(0));
        }
        ExecuteEvent(9072, strParam);
    }
    return;
}

function InitMainProductWindow(WindowHandle ItemWnd)
{
    local ButtonHandle btnCashItemIcon, btnGo;
    local TextureHandle TexPanel, TexSoldOut;
    local TextBoxHandle TextCount;

    TexPanel = TextureHandle(ItemWnd.GetChildWindow("TexPanel"));
    TexPanel.HideWindow();
    btnGo = ButtonHandle(ItemWnd.GetChildWindow("BtnGo"));
    btnGo.HideWindow();
    btnCashItemIcon = ButtonHandle(ItemWnd.GetChildWindow("EventCashItem"));
    // End:0xA6
    if(btnCashItemIcon != none)
    {
        btnCashItemIcon.HideWindow();
    }
    TexSoldOut = TextureHandle(ItemWnd.GetChildWindow("TexSoldOut"));
    TextCount = TextBoxHandle(ItemWnd.GetChildWindow("TextCount"));
    TextCount.HideWindow();
    TexSoldOut.HideWindow();
    return;
}

function SetMainProductWindow(WindowHandle ItemWnd, ProductInfo Info)
{
    local ButtonHandle btnCashItemIcon, btnGo;
    local TextureHandle TexPanel, TexSoldOut;
    local TextBoxHandle TextCount;
    local DrawPanelHandle drawpanel;
    local TextBoxHandle descdrawpanel;
    local DrawItemInfo kDrawInfo;
    local string strCount, strTemp;

    TexPanel = TextureHandle(ItemWnd.GetChildWindow("TexPanel"));
    // End:0x81
    if((Info.iPanel_Type > 0) && Info.iPanel_Type <= (ConvertPreItemPanelType(4)))
    {
        TexPanel.SetTexture(m_UI_prime_panel_Main[Info.iPanel_Type - 1]);
        TexPanel.ShowWindow();        
    }
    else
    {
        TexPanel.HideWindow();
    }
    drawpanel = DrawPanelHandle(ItemWnd.GetChildWindow("CashItemDrawPanel"));
    drawpanel.Clear();
    // End:0xD9
    if(drawpanel == none)
    {
        return;
    }
    btnGo = ButtonHandle(ItemWnd.GetChildWindow("BtnGo"));
    btnGo.SetButtonValue(Info.iProductID);
    btnGo.ShowWindow();
    btnCashItemIcon = ButtonHandle(ItemWnd.GetChildWindow("EventCashItem"));
    // End:0x1C5
    if(btnCashItemIcon != none)
    {
        btnCashItemIcon.ShowWindow();
        btnCashItemIcon.SetTexture(Info.strIconName, Info.strIconName, Info.strIconName);
        btnCashItemIcon.ClearTooltip();
        SetTooltipProductInfo(btnCashItemIcon, Info);
        btnCashItemIcon.SetTooltipCalculateSize(256);
    }
    MakeDrawPanelInfo_Desc(kDrawInfo, Info.strName, 227, 197, 80, 200);
    drawpanel.InsertDrawItem(kDrawInfo);
    strTemp = SetPaymentType(Info.iPaymentType, Info.iPrice);
    MakeDrawInfo_Text(kDrawInfo, strTemp, 220, 220, 220);
    kDrawInfo.bLineBreak = true;
    kDrawInfo.nOffSetY = 6;
    drawpanel.InsertDrawItem(kDrawInfo);
    SeTimeLimitInfo(drawpanel, Info);
    drawpanel.SetMiddleAlign(true, 200);
    descdrawpanel = TextBoxHandle(ItemWnd.GetChildWindow("TextCashItemDescDrawPanel"));
    descdrawpanel.SetText(Info.strMainSubject);
    TexSoldOut = TextureHandle(ItemWnd.GetChildWindow("TexSoldOut"));
    TextCount = TextBoxHandle(ItemWnd.GetChildWindow("TextCount"));
    // End:0x346
    if(Info.iStock < 0)
    {
        TextCount.HideWindow();
        TexSoldOut.HideWindow();        
    }
    else
    {
        // End:0x3A8
        if(Info.iStock == 0)
        {
            TexSoldOut.ShowWindow();
            TextCount.ShowWindow();
            strCount = (GetSystemString(5027) $ " : ") $ string(0);
            TextCount.SetText(strCount);            
        }
        else
        {
            TextCount.ShowWindow();
            strCount = (GetSystemString(5027) $ " : ") $ string(Info.iStock);
            TextCount.SetText(strCount);
            TexSoldOut.HideWindow();
        }
    }
    return;
}

function UpdateBasketProductWindow(ButtonHandle childBtnBasket, bool bMyShopBasketEnable)
{
    // End:0x81
    if(bMyShopBasketEnable)
    {
        childBtnBasket.SetTexture("BranchSys3.UI.button_favorite_on", "BranchSys3.UI.button_favorite_on", "BranchSys3.UI.button_favorite_on");        
    }
    else
    {
        childBtnBasket.SetTexture("BranchSys3.UI.button_favorite_off", "BranchSys3.UI.button_favorite_off", "BranchSys3.UI.button_favorite_off");
    }
    return;
}

function SetViewProductWindow(WindowHandle ItemWnd, ProductInfo Info, bool bMyShop, bool visableBasket)
{
    local ButtonHandle btnCashItemIcon, childBtnBuy, childBtnPresent, childBtnBasket;
    local TextureHandle TexPanel, TexSoldOut;
    local DrawPanelHandle drawpanel;
    local DrawItemInfo kDrawInfo;
    local TextBoxHandle TextCount, TextPoint;
    local string strCount, strTemp;

    drawpanel = DrawPanelHandle(ItemWnd.GetChildWindow("CashItemDrawPanel"));
    drawpanel.Clear();
    // End:0x49
    if(drawpanel == none)
    {
        return;
    }
    TexPanel = TextureHandle(ItemWnd.GetChildWindow("TexPanel"));
    // End:0xCA
    if((Info.iPanel_Type > 0) && Info.iPanel_Type <= (ConvertPreItemPanelType(4)))
    {
        TexPanel.SetTexture(m_UI_prime_panel_Item[Info.iPanel_Type - 1]);
        TexPanel.ShowWindow();        
    }
    else
    {
        TexPanel.HideWindow();
    }
    childBtnBuy = ButtonHandle(ItemWnd.GetChildWindow("BtnBuy"));
    childBtnBuy.SetButtonValue(Info.iProductID);
    childBtnPresent = ButtonHandle(ItemWnd.GetChildWindow("BtnPresent"));
    childBtnPresent.SetButtonValue(Info.iProductID);
    childBtnPresent.SetEnable(m_bPresent);
    // End:0x199
    if(bMyShop)
    {
        childBtnBasket = ButtonHandle(ItemWnd.GetChildWindow("BtnDelete"));        
    }
    else
    {
        childBtnBasket = ButtonHandle(ItemWnd.GetChildWindow("BtnBasket"));
    }
    childBtnBasket.SetButtonValue(Info.iProductID);
    btnCashItemIcon = ButtonHandle(ItemWnd.GetChildWindow("CashItemIcon"));
    // End:0x26A
    if(btnCashItemIcon != none)
    {
        btnCashItemIcon.SetTexture(Info.strIconName, Info.strIconName, Info.strIconName);
        btnCashItemIcon.ClearTooltip();
        SetTooltipProductInfo(btnCashItemIcon, Info);
        btnCashItemIcon.SetTooltipCalculateSize(256);
    }
    MakeDrawPanelInfo_Desc(kDrawInfo, Info.strName, 220, 220, 220, 208);
    kDrawInfo.nOffSetY = 5;
    drawpanel.InsertDrawItem(kDrawInfo);
    TextPoint = TextBoxHandle(ItemWnd.GetChildWindow("TextPoint"));
    strTemp = SetPaymentType(Info.iPaymentType, Info.iPrice);
    TextPoint.SetText(strTemp);
    TexSoldOut = TextureHandle(ItemWnd.GetChildWindow("TexSoldOut"));
    TextCount = TextBoxHandle(ItemWnd.GetChildWindow("TextCount"));
    // End:0x3AA
    if(Info.iStock < 0)
    {
        TextCount.HideWindow();
        TexSoldOut.HideWindow();
        childBtnBuy.ShowWindow();
        childBtnPresent.ShowWindow();
        childBtnBasket.ShowWindow();        
    }
    else
    {
        // End:0x439
        if(Info.iStock == 0)
        {
            TexSoldOut.ShowWindow();
            TextCount.ShowWindow();
            strCount = (GetSystemString(5027) $ " : ") $ string(0);
            TextCount.SetText(strCount);
            childBtnBuy.HideWindow();
            childBtnPresent.HideWindow();
            childBtnBasket.HideWindow();            
        }
        else
        {
            TextCount.ShowWindow();
            strCount = (GetSystemString(5027) $ " : ") $ string(Info.iStock);
            TextCount.SetText(strCount);
            TexSoldOut.HideWindow();
            childBtnBuy.ShowWindow();
            childBtnPresent.ShowWindow();
            childBtnBasket.ShowWindow();
        }
    }
    // End:0x4FB
    if(visableBasket)
    {
        childBtnBasket.ShowWindow();
        // End:0x4F8
        if(bMyShop == false)
        {
            UpdateBasketProductWindow(childBtnBasket, Info.bMyShopBasketEnable);
        }        
    }
    else
    {
        childBtnBasket.HideWindow();
    }
    SeTimeLimitInfo(drawpanel, Info);
    // End:0x54F
    if((Info.iPaymentType == 0) && Info.iAvailableCount <= 0)
    {
        childBtnPresent.SetEnable(true);        
    }
    else
    {
        childBtnPresent.SetEnable(false);
    }
    return;
}

function SeTimeLimitInfo(DrawPanelHandle wnd, ProductInfo kProductInfo)
{
    local string strTemp;
    local DrawItemInfo kDrawInfo;
    local int bTimeLimit;

    // End:0x7FD
    if(kProductInfo.iProductID >= 0)
    {
        kDrawInfo.bLineBreak = true;
        kDrawInfo.nOffSetY = 2;
        bTimeLimit = 0;
        // End:0x82
        if(!(((kProductInfo.iStartHour == 0) && kProductInfo.iStartMin == 0) && kProductInfo.iEndHour == 23) && kProductInfo.iEndMin == 59)
        {
            bTimeLimit = 1;
        }
        // End:0x11A
        if((kProductInfo.iRestrictionDay >= 1) && kProductInfo.iAvailableCount >= 1)
        {
            strTemp = MakeFullSystemMsg(GetSystemMessage(6164), string(kProductInfo.iRestrictionDay), string(kProductInfo.iAvailableCount));
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = 2;
            wnd.InsertDrawItem(kDrawInfo);            
        }
        else
        {
            // End:0x1A8
            if((kProductInfo.iRestrictionDay < 0) && kProductInfo.iAvailableCount >= 1)
            {
                strTemp = MakeFullSystemMsg(GetSystemMessage(6165), string(kProductInfo.iAvailableCount), "");
                MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                kDrawInfo.bLineBreak = true;
                kDrawInfo.nOffSetY = 2;
                wnd.InsertDrawItem(kDrawInfo);                
            }
            else
            {
                // End:0x222
                if((kProductInfo.iMinBirthday > 0) || kProductInfo.iMaxBirthday > 0)
                {
                    strTemp = GetSystemString(5149);
                    MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                    kDrawInfo.bLineBreak = true;
                    kDrawInfo.nOffSetY = 2;
                    wnd.InsertDrawItem(kDrawInfo);                    
                }
                else
                {
                    // End:0x482
                    if((kProductInfo.iMinLevel > 0) || kProductInfo.iMaxLevel > 0)
                    {
                        // End:0x303
                        if((kProductInfo.iMinLevel > 0) && kProductInfo.iMaxLevel > kProductInfo.iMinLevel)
                        {
                            strTemp = (((((("" $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537)) $ " ~ ") $ string(kProductInfo.iMaxLevel)) $ "") $ GetSystemString(537);
                            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                            kDrawInfo.bLineBreak = true;
                            kDrawInfo.nOffSetY = 2;
                            wnd.InsertDrawItem(kDrawInfo);                            
                        }
                        else
                        {
                            // End:0x38A
                            if(kProductInfo.iMinLevel == kProductInfo.iMaxLevel)
                            {
                                strTemp = (("" $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537);
                                MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                                kDrawInfo.bLineBreak = true;
                                kDrawInfo.nOffSetY = 2;
                                wnd.InsertDrawItem(kDrawInfo);                                
                            }
                            else
                            {
                                // End:0x406
                                if(kProductInfo.iMinLevel > 0)
                                {
                                    strTemp = MakeFullSystemMsg(GetSystemMessage(6170), string(kProductInfo.iMinLevel), "");
                                    MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                                    kDrawInfo.bLineBreak = true;
                                    kDrawInfo.nOffSetY = 2;
                                    wnd.InsertDrawItem(kDrawInfo);                                    
                                }
                                else
                                {
                                    // End:0x47F
                                    if(kProductInfo.iMaxLevel > 0)
                                    {
                                        strTemp = MakeFullSystemMsg(GetSystemMessage(6171), string(kProductInfo.iMaxLevel), "");
                                        MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                                        kDrawInfo.bLineBreak = true;
                                        kDrawInfo.nOffSetY = 2;
                                        wnd.InsertDrawItem(kDrawInfo);
                                    }
                                }
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x56B
                        if(bTimeLimit != 0)
                        {
                            strTemp = (((((((((("" $ (ZERO_STR(kProductInfo.iStartHour))) $ string(kProductInfo.iStartHour)) $ ":") $ (ZERO_STR(kProductInfo.iStartMin))) $ string(kProductInfo.iStartMin)) $ "~") $ (ZERO_STR(kProductInfo.iEndHour))) $ string(kProductInfo.iEndHour)) $ ":") $ (ZERO_STR(kProductInfo.iEndMin))) $ string(kProductInfo.iEndMin);
                            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                            kDrawInfo.bLineBreak = true;
                            kDrawInfo.nOffSetY = 2;
                            wnd.InsertDrawItem(kDrawInfo);                            
                        }
                        else
                        {
                            // End:0x5F3
                            if(kProductInfo.iDayWeek != 127)
                            {
                                strTemp = ((("" $ ConvertBRCashShopDayWeek(kProductInfo.iDayWeek)) $ " ") $ GetSystemString(5142)) $ "";
                                MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                                kDrawInfo.bLineBreak = true;
                                kDrawInfo.nOffSetY = 2;
                                wnd.InsertDrawItem(kDrawInfo);                                
                            }
                            else
                            {
                                // End:0x68A
                                if(BR_GetDayType(kProductInfo.iEndSale, 0) < 2037)
                                {
                                    strTemp = (("" $ BR_ConvertTimeToStr(kProductInfo.iStartSale, 2)) $ "~") $ BR_ConvertTimeToStr(kProductInfo.iEndSale, 2);
                                    MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                                    kDrawInfo.bLineBreak = true;
                                    kDrawInfo.nOffSetY = 2;
                                    wnd.InsertDrawItem(kDrawInfo);                                    
                                }
                                else
                                {
                                    // End:0x782
                                    if(kProductInfo.iStock > 0)
                                    {
                                        // End:0x6D7
                                        if(int(GetLanguage()) == int(8))
                                        {
                                            strTemp = (("" $ GetSystemString(3282)) $ ": ") $ string(kProductInfo.iMaxStock);                                            
                                        }
                                        else
                                        {
                                            // End:0x714
                                            if(int(GetLanguage()) == int(9))
                                            {
                                                strTemp = (("" $ GetSystemString(5131)) $ ": ") $ string(kProductInfo.iMaxStock);                                                
                                            }
                                            else
                                            {
                                                strTemp = (("" $ string(kProductInfo.iMaxStock)) $ "") $ GetSystemString(5131);
                                            }
                                        }
                                        MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                                        kDrawInfo.bLineBreak = true;
                                        kDrawInfo.nOffSetY = 2;
                                        wnd.InsertDrawItem(kDrawInfo);                                        
                                    }
                                    else
                                    {
                                        // End:0x7FD
                                        if(kProductInfo.iSale_Percent > 0)
                                        {
                                            strTemp = (("" $ string(kProductInfo.iSale_Percent)) $ "") $ GetSystemString(5132);
                                            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                                            kDrawInfo.bLineBreak = true;
                                            kDrawInfo.nOffSetY = 2;
                                            wnd.InsertDrawItem(kDrawInfo);
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
    return;
}

function SetTooltipProductInfo(WindowHandle wnd, ProductInfo kProductInfo)
{
    local string strTemp;
    local DrawItemInfo kDrawInfo;
    local int LimitedMarginY, bTimeLimit, i;

    MakeDrawTooltipInfo_Desc(kDrawInfo, kProductInfo.strName, 227, 197, 80);
    wnd.InsertTooltipDrawItem(kDrawInfo);
    // End:0xBB0
    if(kProductInfo.iProductID >= 0)
    {
        LimitedMarginY = 6;
        bTimeLimit = 0;
        // End:0x9F
        if(!(((kProductInfo.iStartHour == 0) && kProductInfo.iStartMin == 0) && kProductInfo.iEndHour == 23) && kProductInfo.iEndMin == 59)
        {
            bTimeLimit = 1;
        }
        // End:0x1E2
        if(kProductInfo.iMaxStock > 0)
        {
            // End:0x12E
            if((int(GetLanguage()) == int(8)) || int(GetLanguage()) == int(9))
            {
                strTemp = (((("[" $ GetSystemString(5133)) $ "] ") $ GetSystemString(5027)) $ ": ") $ string(kProductInfo.iStock);
                MakeDrawPanelInfo_Desc(kDrawInfo, strTemp, 199, 47, 44, 256);                
            }
            else
            {
                strTemp = (((((((("[" $ GetSystemString(5133)) $ "] ") $ string(kProductInfo.iMaxStock)) $ "") $ GetSystemString(5131)) $ " ") $ GetSystemString(5027)) $ ": ") $ string(kProductInfo.iStock);
                MakeDrawPanelInfo_Desc(kDrawInfo, strTemp, 199, 47, 44, 256);
            }
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertTooltipDrawItem(kDrawInfo);
            LimitedMarginY = 0;
        }
        // End:0x292
        if((kProductInfo.iRestrictionDay >= 1) && kProductInfo.iAvailableCount >= 1)
        {
            strTemp = (("[" $ GetSystemString(5150)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6164), string(kProductInfo.iRestrictionDay), string(kProductInfo.iAvailableCount));
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertTooltipDrawItem(kDrawInfo);
        }
        // End:0x338
        if((kProductInfo.iRestrictionDay < 0) && kProductInfo.iAvailableCount >= 1)
        {
            strTemp = (("[" $ GetSystemString(5150)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6165), string(kProductInfo.iAvailableCount), "");
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertTooltipDrawItem(kDrawInfo);
        }
        // End:0x5B5
        if((kProductInfo.iMinBirthday > 0) || kProductInfo.iMaxBirthday > 0)
        {
            // End:0x474
            if((kProductInfo.iMinBirthday > 0) && kProductInfo.iMaxBirthday > 0)
            {
                strTemp = (("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMinBirthday, 1);
                MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                kDrawInfo.bLineBreak = true;
                kDrawInfo.nOffSetY = LimitedMarginY;
                LimitedMarginY = 0;
                wnd.InsertTooltipDrawItem(kDrawInfo);
                strTemp = "             ~ " $ BR_ConvertTimeToStr(kProductInfo.iMaxBirthday, 1);
                MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                kDrawInfo.bLineBreak = true;
                kDrawInfo.nOffSetY = LimitedMarginY;
                LimitedMarginY = 0;
                wnd.InsertTooltipDrawItem(kDrawInfo);                
            }
            else
            {
                // End:0x516
                if(kProductInfo.iMinBirthday > 0)
                {
                    strTemp = (((("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMinBirthday, 1)) $ " ") $ GetSystemString(5153);
                    MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                    kDrawInfo.bLineBreak = true;
                    kDrawInfo.nOffSetY = LimitedMarginY;
                    LimitedMarginY = 0;
                    wnd.InsertTooltipDrawItem(kDrawInfo);                    
                }
                else
                {
                    // End:0x5B5
                    if(kProductInfo.iMaxBirthday > 0)
                    {
                        strTemp = (((("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMaxBirthday, 1)) $ " ") $ GetSystemString(1037);
                        MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                        kDrawInfo.bLineBreak = true;
                        kDrawInfo.nOffSetY = LimitedMarginY;
                        LimitedMarginY = 0;
                        wnd.InsertTooltipDrawItem(kDrawInfo);
                    }
                }
            }
        }
        // End:0x875
        if((kProductInfo.iMinLevel > 0) || kProductInfo.iMaxLevel > 0)
        {
            // End:0x6AC
            if((kProductInfo.iMinLevel > 0) && kProductInfo.iMaxLevel > kProductInfo.iMinLevel)
            {
                strTemp = (((((((("[" $ GetSystemString(5145)) $ "] ") $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537)) $ "~ ") $ string(kProductInfo.iMaxLevel)) $ "") $ GetSystemString(537);
                MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                kDrawInfo.bLineBreak = true;
                kDrawInfo.nOffSetY = LimitedMarginY;
                wnd.InsertTooltipDrawItem(kDrawInfo);                
            }
            else
            {
                // End:0x74A
                if(kProductInfo.iMinLevel == kProductInfo.iMaxLevel)
                {
                    strTemp = (((("[" $ GetSystemString(5145)) $ "] ") $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537);
                    MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                    kDrawInfo.bLineBreak = true;
                    kDrawInfo.nOffSetY = LimitedMarginY;
                    wnd.InsertTooltipDrawItem(kDrawInfo);                    
                }
                else
                {
                    // End:0x7E1
                    if(kProductInfo.iMinLevel > 0)
                    {
                        strTemp = (("[" $ GetSystemString(5145)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6170), string(kProductInfo.iMinLevel), "");
                        MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                        kDrawInfo.bLineBreak = true;
                        kDrawInfo.nOffSetY = LimitedMarginY;
                        wnd.InsertTooltipDrawItem(kDrawInfo);                        
                    }
                    else
                    {
                        // End:0x875
                        if(kProductInfo.iMaxLevel > 0)
                        {
                            strTemp = (("[" $ GetSystemString(5145)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6171), string(kProductInfo.iMaxLevel), "");
                            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                            kDrawInfo.bLineBreak = true;
                            kDrawInfo.nOffSetY = LimitedMarginY;
                            wnd.InsertTooltipDrawItem(kDrawInfo);
                        }
                    }
                }
            }
        }
        // End:0x979
        if(bTimeLimit != 0)
        {
            strTemp = (((((((((((("[" $ GetSystemString(5029)) $ "] ") $ (ZERO_STR(kProductInfo.iStartHour))) $ string(kProductInfo.iStartHour)) $ ":") $ (ZERO_STR(kProductInfo.iStartMin))) $ string(kProductInfo.iStartMin)) $ "~") $ (ZERO_STR(kProductInfo.iEndHour))) $ string(kProductInfo.iEndHour)) $ ":") $ (ZERO_STR(kProductInfo.iEndMin))) $ string(kProductInfo.iEndMin);
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertTooltipDrawItem(kDrawInfo);
            LimitedMarginY = 0;
        }
        // End:0xA06
        if(kProductInfo.iDayWeek != 127)
        {
            strTemp = (("[" $ GetSystemString(5028)) $ "] ") $ ConvertBRCashShopDayWeek(kProductInfo.iDayWeek);
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertTooltipDrawItem(kDrawInfo);
            LimitedMarginY = 0;
        }
        // End:0xA98
        if(kProductInfo.iSale_Percent > 0)
        {
            strTemp = (((("[" $ GetSystemString(5141)) $ "] ") $ string(kProductInfo.iSale_Percent)) $ "") $ GetSystemString(5132);
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertTooltipDrawItem(kDrawInfo);
        }
        // End:0xBB0
        if(BR_GetDayType(kProductInfo.iEndSale, 0) < 2037)
        {
            strTemp = (("[" $ GetSystemString(5035)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iStartSale, bTimeLimit);
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            LimitedMarginY = 0;
            wnd.InsertTooltipDrawItem(kDrawInfo);
            strTemp = "             ~ " $ BR_ConvertTimeToStr(kProductInfo.iEndSale, bTimeLimit);
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            LimitedMarginY = 0;
            wnd.InsertTooltipDrawItem(kDrawInfo);
        }
    }
    // End:0xBFE
    if(Len(kProductInfo.strDesc) > 0)
    {
        MakeDrawTooltipInfo_Desc(kDrawInfo, kProductInfo.strDesc, 220, 220, 220);
        kDrawInfo.nOffSetY = 12;
        wnd.InsertTooltipDrawItem(kDrawInfo);
    }
    // End:0xC53
    if(kProductInfo.itemarray.Length <= 1)
    {
        i = 0;
        J0xC16:

        // End:0xC50 [Loop If]
        if(i < kProductInfo.itemarray.Length)
        {
            SetTooltipProductItemInfo(wnd, kProductInfo.itemarray[i]);
            i++;
            // [Loop Continue]
            goto J0xC16;
        }        
    }
    else
    {
        SetTooltipProductItem(wnd, kProductInfo);
        MakeDrawPanelInfo_Desc(kDrawInfo, GetSystemMessage(6118), 228, 218, 188, 256);
        kDrawInfo.nOffSetY = 6;
        wnd.InsertTooltipDrawItem(kDrawInfo);
    }
    return;
}

function SetTooltipProductItem(WindowHandle wnd, ProductInfo kProductInfo)
{
    local int i;
    local ItemInfo kItemInfo;
    local DrawItemInfo kDrawInfo;
    local ProductItem item;

    MakeDrawInfo_Image(kDrawInfo, kProductInfo.strIconName, 32, 32);
    kDrawInfo.nOffSetY = 12;
    kDrawInfo.bLineBreak = true;
    wnd.InsertTooltipDrawItem(kDrawInfo);
    MakeDrawTooltipInfo_Desc(kDrawInfo, kProductInfo.strName, 227, 197, 80);
    kDrawInfo.bLineBreak = false;
    kDrawInfo.nOffSetY = 16;
    kDrawInfo.nOffSetX = 6;
    wnd.InsertTooltipDrawItem(kDrawInfo);
    MakeDrawInfo_Text(kDrawInfo, GetSystemString(5064), 220, 220, 128);
    kDrawInfo.bLineBreak = true;
    kDrawInfo.nOffSetY = 12;
    wnd.InsertTooltipDrawItem(kDrawInfo);
    i = 0;
    J0xEE:

    // End:0x1B1 [Loop If]
    if(i < kProductInfo.itemarray.Length)
    {
        item = kProductInfo.itemarray[i];
        Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(item.iItemID), kItemInfo);
        MakeDrawTooltipInfo_Desc(kDrawInfo, kItemInfo.Name, 200, 200, 200);
        kDrawInfo.bLineBreak = true;
        kDrawInfo.nOffSetX = 16;
        kDrawInfo.nOffSetY = 2;
        kDrawInfo.t_MaxWidth = 256 - 16;
        wnd.InsertTooltipDrawItem(kDrawInfo);
        i++;
        // [Loop Continue]
        goto J0xEE;
    }
    return;
}

function SetTooltipProductItemInfo(WindowHandle wnd, ProductItem item)
{
    local string strWeight, strTrade, strTemp, strNum;
    local ItemInfo kItemInfo;
    local DrawItemInfo kDrawInfo;
    local bool IsPremium;
    local int nHeight, nWidth;
    local Color NameColor;

    NameColor.R = 200;
    NameColor.G = 200;
    NameColor.B = 200;
    NameColor.A = byte(255);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(item.iItemID), kItemInfo);
    MakeDrawInfo_Image(kDrawInfo, kItemInfo.IconName, 32, 32);
    kDrawInfo.nOffSetY = 12;
    kDrawInfo.bLineBreak = true;
    wnd.InsertTooltipDrawItem(kDrawInfo);
    // End:0xFE
    if(kItemInfo.IsBRPremium == 2)
    {
        IsPremium = MakeCashItemIcon(kDrawInfo);
        // End:0xFE
        if(IsPremium == true)
        {
            kDrawInfo.nOffSetX = 6;
            kDrawInfo.nOffSetY = 16;
            wnd.InsertTooltipDrawItem(kDrawInfo);
        }
    }
    // End:0x138
    if(Len(kItemInfo.AdditionalName) > 0)
    {
        strTemp = (("" $ kItemInfo.Name) $ " ") $ kItemInfo.AdditionalName;        
    }
    else
    {
        strTemp = kItemInfo.Name;
    }
    MakeDrawTooltipInfo_Desc(kDrawInfo, strTemp, 227, 197, 80);
    kDrawInfo.bLineBreak = false;
    kDrawInfo.nOffSetY = 16;
    // End:0x191
    if(IsPremium == false)
    {
        kDrawInfo.nOffSetX = 6;
    }
    wnd.InsertTooltipDrawItem(kDrawInfo);
    // End:0x21C
    if(item.iAmount > 1)
    {
        strNum = (GetSystemString(192) $ " : ") $ string(item.iAmount);
        MakeDrawInfo_Text(kDrawInfo, strNum, 200, 200, 200);
        kDrawInfo.nOffSetY = 6;
        kDrawInfo.bLineBreak = true;
        wnd.InsertTooltipDrawItem(kDrawInfo);
    }
    strWeight = ((((GetSystemString(52) $ " : ") $ string(item.iWeight)) $ " (") $ GetSystemString(468)) $ ")";
    MakeDrawInfo_Text(kDrawInfo, strWeight, 200, 200, 200);
    // End:0x28A
    if(item.iAmount <= 1)
    {
        kDrawInfo.nOffSetY = 6;
    }
    kDrawInfo.bLineBreak = true;
    wnd.InsertTooltipDrawItem(kDrawInfo);
    // End:0x303
    if(item.iTradable == 0)
    {
        strTrade = GetSystemString(1491);
        MakeDrawInfo_Text(kDrawInfo, strTrade, 200, 200, 200);
        kDrawInfo.bLineBreak = true;
        wnd.InsertTooltipDrawItem(kDrawInfo);
    }
    // End:0x351
    if(Len(item.strDesc) > 0)
    {
        MakeDrawTooltipInfo_Desc(kDrawInfo, item.strDesc, 220, 220, 220);
        kDrawInfo.nOffSetY = 12;
        wnd.InsertTooltipDrawItem(kDrawInfo);
    }
    return;
}

function SetNewProductInfo(DrawPanelHandle wnd, int iID, int Price, string ItemName, string Desc)
{
    local ProductInfo kProductInfo;
    local string strTemp;
    local DrawItemInfo kDrawInfo;
    local int LimitedMarginY, bTimeLimit;

    MakeDrawPanelInfo_Desc(kDrawInfo, ItemName, 227, 197, 80, 256);
    wnd.InsertDrawItem(kDrawInfo);
    kProductInfo = GetProductItem(iID);
    strTemp = SetPaymentTypeDetail(kProductInfo.iPaymentType, Price);
    MakeDrawInfo_Text(kDrawInfo, strTemp, 220, 220, 220);
    kDrawInfo.bLineBreak = true;
    kDrawInfo.nOffSetY = 6;
    wnd.InsertDrawItem(kDrawInfo);
    // End:0xC20
    if(kProductInfo.iProductID >= 0)
    {
        LimitedMarginY = 6;
        bTimeLimit = 0;
        // End:0x10F
        if(!(((kProductInfo.iStartHour == 0) && kProductInfo.iStartMin == 0) && kProductInfo.iEndHour == 23) && kProductInfo.iEndMin == 59)
        {
            bTimeLimit = 1;
        }
        // End:0x252
        if(kProductInfo.iMaxStock > 0)
        {
            // End:0x19E
            if((int(GetLanguage()) == int(8)) || int(GetLanguage()) == int(9))
            {
                strTemp = (((("[" $ GetSystemString(5133)) $ "] ") $ GetSystemString(5027)) $ ": ") $ string(kProductInfo.iStock);
                MakeDrawPanelInfo_Desc(kDrawInfo, strTemp, 199, 47, 44, 256);                
            }
            else
            {
                strTemp = (((((((("[" $ GetSystemString(5133)) $ "] ") $ string(kProductInfo.iMaxStock)) $ "") $ GetSystemString(5131)) $ " ") $ GetSystemString(5027)) $ ": ") $ string(kProductInfo.iStock);
                MakeDrawPanelInfo_Desc(kDrawInfo, strTemp, 199, 47, 44, 256);
            }
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertDrawItem(kDrawInfo);
            LimitedMarginY = 0;
        }
        // End:0x302
        if((kProductInfo.iRestrictionDay >= 1) && kProductInfo.iAvailableCount >= 1)
        {
            strTemp = (("[" $ GetSystemString(5150)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6164), string(kProductInfo.iRestrictionDay), string(kProductInfo.iAvailableCount));
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertDrawItem(kDrawInfo);
        }
        // End:0x3A8
        if((kProductInfo.iRestrictionDay < 0) && kProductInfo.iAvailableCount >= 1)
        {
            strTemp = (("[" $ GetSystemString(5150)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6165), string(kProductInfo.iAvailableCount), "");
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertDrawItem(kDrawInfo);
        }
        // End:0x625
        if((kProductInfo.iMinBirthday > 0) || kProductInfo.iMaxBirthday > 0)
        {
            // End:0x4E4
            if((kProductInfo.iMinBirthday > 0) && kProductInfo.iMaxBirthday > 0)
            {
                strTemp = (("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMinBirthday, 1);
                MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                kDrawInfo.bLineBreak = true;
                kDrawInfo.nOffSetY = LimitedMarginY;
                LimitedMarginY = 0;
                wnd.InsertDrawItem(kDrawInfo);
                strTemp = "             ~ " $ BR_ConvertTimeToStr(kProductInfo.iMaxBirthday, 1);
                MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                kDrawInfo.bLineBreak = true;
                kDrawInfo.nOffSetY = LimitedMarginY;
                LimitedMarginY = 0;
                wnd.InsertDrawItem(kDrawInfo);                
            }
            else
            {
                // End:0x586
                if(kProductInfo.iMinBirthday > 0)
                {
                    strTemp = (((("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMinBirthday, 1)) $ " ") $ GetSystemString(5153);
                    MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                    kDrawInfo.bLineBreak = true;
                    kDrawInfo.nOffSetY = LimitedMarginY;
                    LimitedMarginY = 0;
                    wnd.InsertDrawItem(kDrawInfo);                    
                }
                else
                {
                    // End:0x625
                    if(kProductInfo.iMaxBirthday > 0)
                    {
                        strTemp = (((("[" $ GetSystemString(5149)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iMaxBirthday, 1)) $ " ") $ GetSystemString(1037);
                        MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                        kDrawInfo.bLineBreak = true;
                        kDrawInfo.nOffSetY = LimitedMarginY;
                        LimitedMarginY = 0;
                        wnd.InsertDrawItem(kDrawInfo);
                    }
                }
            }
        }
        // End:0x8E5
        if((kProductInfo.iMinLevel > 0) || kProductInfo.iMaxLevel > 0)
        {
            // End:0x71C
            if((kProductInfo.iMinLevel > 0) && kProductInfo.iMaxLevel > kProductInfo.iMinLevel)
            {
                strTemp = (((((((("[" $ GetSystemString(5145)) $ "] ") $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537)) $ "~ ") $ string(kProductInfo.iMaxLevel)) $ "") $ GetSystemString(537);
                MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                kDrawInfo.bLineBreak = true;
                kDrawInfo.nOffSetY = LimitedMarginY;
                wnd.InsertDrawItem(kDrawInfo);                
            }
            else
            {
                // End:0x7BA
                if(kProductInfo.iMinLevel == kProductInfo.iMaxLevel)
                {
                    strTemp = (((("[" $ GetSystemString(5145)) $ "] ") $ string(kProductInfo.iMinLevel)) $ "") $ GetSystemString(537);
                    MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                    kDrawInfo.bLineBreak = true;
                    kDrawInfo.nOffSetY = LimitedMarginY;
                    wnd.InsertDrawItem(kDrawInfo);                    
                }
                else
                {
                    // End:0x851
                    if(kProductInfo.iMinLevel > 0)
                    {
                        strTemp = (("[" $ GetSystemString(5145)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6170), string(kProductInfo.iMinLevel), "");
                        MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                        kDrawInfo.bLineBreak = true;
                        kDrawInfo.nOffSetY = LimitedMarginY;
                        wnd.InsertDrawItem(kDrawInfo);                        
                    }
                    else
                    {
                        // End:0x8E5
                        if(kProductInfo.iMaxLevel > 0)
                        {
                            strTemp = (("[" $ GetSystemString(5145)) $ "] ") $ MakeFullSystemMsg(GetSystemMessage(6171), string(kProductInfo.iMaxLevel), "");
                            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
                            kDrawInfo.bLineBreak = true;
                            kDrawInfo.nOffSetY = LimitedMarginY;
                            wnd.InsertDrawItem(kDrawInfo);
                        }
                    }
                }
            }
        }
        // End:0x9E9
        if(bTimeLimit != 0)
        {
            strTemp = (((((((((((("[" $ GetSystemString(5029)) $ "] ") $ (ZERO_STR(kProductInfo.iStartHour))) $ string(kProductInfo.iStartHour)) $ ":") $ (ZERO_STR(kProductInfo.iStartMin))) $ string(kProductInfo.iStartMin)) $ "~") $ (ZERO_STR(kProductInfo.iEndHour))) $ string(kProductInfo.iEndHour)) $ ":") $ (ZERO_STR(kProductInfo.iEndMin))) $ string(kProductInfo.iEndMin);
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertDrawItem(kDrawInfo);
            LimitedMarginY = 0;
        }
        // End:0xA76
        if(kProductInfo.iDayWeek != 127)
        {
            strTemp = (("[" $ GetSystemString(5028)) $ "] ") $ ConvertBRCashShopDayWeek(kProductInfo.iDayWeek);
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertDrawItem(kDrawInfo);
            LimitedMarginY = 0;
        }
        // End:0xB08
        if(kProductInfo.iSale_Percent > 0)
        {
            strTemp = (((("[" $ GetSystemString(5141)) $ "] ") $ string(kProductInfo.iSale_Percent)) $ "") $ GetSystemString(5132);
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            wnd.InsertDrawItem(kDrawInfo);
        }
        // End:0xC20
        if(BR_GetDayType(kProductInfo.iEndSale, 0) < 2037)
        {
            strTemp = (("[" $ GetSystemString(5035)) $ "] ") $ BR_ConvertTimeToStr(kProductInfo.iStartSale, bTimeLimit);
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            LimitedMarginY = 0;
            wnd.InsertDrawItem(kDrawInfo);
            strTemp = "             ~ " $ BR_ConvertTimeToStr(kProductInfo.iEndSale, bTimeLimit);
            MakeDrawInfo_Text(kDrawInfo, strTemp, 199, 47, 44);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetY = LimitedMarginY;
            LimitedMarginY = 0;
            wnd.InsertDrawItem(kDrawInfo);
        }
    }
    // End:0xC69
    if(Len(Desc) > 0)
    {
        MakeDrawPanelInfo_Desc(kDrawInfo, Desc, 220, 220, 220, 256);
        kDrawInfo.nOffSetY = 12;
        wnd.InsertDrawItem(kDrawInfo);
    }
    return;
}

function AddEachProductInfo(DrawPanelHandle wnd, int iID, int iAmount, string ItemName, string IconName, string Desc, int Weight, int TRADE)
{
    local string strWeight, strTrade, strTemp, strNum;
    local ItemInfo kItemInfo;
    local DrawItemInfo kDrawInfo;
    local bool IsPremium;
    local int nHeight, nWidth;
    local Color NameColor;
    local int i;

    NameColor.R = 200;
    NameColor.G = 200;
    NameColor.B = 200;
    NameColor.A = byte(255);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(iID), kItemInfo);
    MakeDrawInfo_Image(kDrawInfo, IconName, 32, 32);
    kDrawInfo.nOffSetY = 12;
    kDrawInfo.bLineBreak = true;
    wnd.InsertDrawItem(kDrawInfo);
    // End:0xF4
    if(kItemInfo.IsBRPremium == 2)
    {
        IsPremium = MakeCashItemIcon(kDrawInfo);
        // End:0xF4
        if(IsPremium == true)
        {
            kDrawInfo.nOffSetX = 6;
            kDrawInfo.nOffSetY = 16;
            wnd.InsertDrawItem(kDrawInfo);
        }
    }
    // End:0x129
    if(Len(kItemInfo.AdditionalName) > 0)
    {
        strTemp = (("" $ ItemName) $ " ") $ kItemInfo.AdditionalName;        
    }
    else
    {
        strTemp = ItemName;
    }
    MakeDrawPanelInfo_Desc(kDrawInfo, strTemp, 227, 197, 80, 256);
    kDrawInfo.bLineBreak = false;
    kDrawInfo.nOffSetY = 16;
    // End:0x182
    if(IsPremium == false)
    {
        kDrawInfo.nOffSetX = 6;
    }
    wnd.InsertDrawItem(kDrawInfo);
    // End:0x203
    if(iAmount > 1)
    {
        strNum = (GetSystemString(192) $ " : ") $ string(iAmount);
        MakeDrawInfo_Text(kDrawInfo, strNum, 200, 200, 200);
        kDrawInfo.nOffSetY = 6;
        kDrawInfo.bLineBreak = true;
        wnd.InsertDrawItem(kDrawInfo);
    }
    strWeight = ((((GetSystemString(52) $ " : ") $ string(Weight)) $ " (") $ GetSystemString(468)) $ ")";
    MakeDrawInfo_Text(kDrawInfo, strWeight, 200, 200, 200);
    // End:0x267
    if(iAmount <= 1)
    {
        kDrawInfo.nOffSetY = 6;
    }
    kDrawInfo.bLineBreak = true;
    wnd.InsertDrawItem(kDrawInfo);
    // End:0x2DB
    if(TRADE == 0)
    {
        strTrade = GetSystemString(1491);
        MakeDrawInfo_Text(kDrawInfo, strTrade, 200, 200, 200);
        kDrawInfo.bLineBreak = true;
        wnd.InsertDrawItem(kDrawInfo);
    }
    // End:0x324
    if(Len(Desc) > 0)
    {
        MakeDrawPanelInfo_Desc(kDrawInfo, Desc, 220, 220, 220, 256);
        kDrawInfo.nOffSetY = 12;
        wnd.InsertDrawItem(kDrawInfo);
    }
    // End:0x455
    if(kItemInfo.IncludeItem[0] > 0)
    {
        MakeDrawInfo_Text(kDrawInfo, GetSystemString(5064), 220, 220, 128);
        kDrawInfo.bLineBreak = true;
        kDrawInfo.nOffSetY = 12;
        wnd.InsertDrawItem(kDrawInfo);
        i = 0;
        J0x387:

        // End:0x455 [Loop If]
        if((kItemInfo.IncludeItem[i] > 0) && i < 10)
        {
            MakeDrawInfo_TextLink(kDrawInfo, kItemInfo.IncludeItem[i], 200, 200, 200);
            kDrawInfo.bLineBreak = true;
            kDrawInfo.nOffSetX = 16;
            kDrawInfo.nOffSetY = 2;
            kDrawInfo.t_MaxWidth = 256 - 16;
            wnd.InsertDrawItem(kDrawInfo);
            Debug("========id : " $ string(kItemInfo.IncludeItem[i]));
            i = i + 1;
            // [Loop Continue]
            goto J0x387;
        }
    }
    return;
}

function bool MakeCashItemIcon(out DrawItemInfo Info)
{
    local string TextureName;

    Info = m_kDrawInfoClear;
    TextureName = GetPrimeItemSymbolName();
    // End:0x8F
    if(Len(TextureName) > 0)
    {
        Info.eType = 2;
        Info.nOffSetX = 0;
        Info.nOffSetY = 0;
        Info.u_nTextureWidth = 16;
        Info.u_nTextureHeight = 16;
        Info.u_nTextureUWidth = 16;
        Info.u_nTextureUHeight = 16;
        Info.u_strTexture = TextureName;
        return true;
    }
    return false;
    return;
}

function MakeText(out DrawItemInfo Info, string Str)
{
    Info = m_kDrawInfoClear;
    Info.eType = 1;
    Info.t_bDrawOneLine = true;
    Info.t_color.R = byte(255);
    Info.t_color.G = byte(255);
    Info.t_color.B = byte(255);
    Info.t_color.A = byte(255);
    Info.t_strText = Str;
    return;
}

function MakeDrawInfo_Text(out DrawItemInfo Info, string Str, int R, int G, int B)
{
    Info = m_kDrawInfoClear;
    Info.eType = 1;
    Info.t_bDrawOneLine = true;
    Info.t_color.R = byte(R);
    Info.t_color.G = byte(G);
    Info.t_color.B = byte(B);
    Info.t_color.A = byte(255);
    Info.t_strText = Str;
    return;
}

function MakeDrawTooltipInfo_Desc(out DrawItemInfo Info, string Str, int R, int G, int B)
{
    Info = m_kDrawInfoClear;
    Info.eType = 1;
    Info.bLineBreak = true;
    Info.t_bDrawOneLine = false;
    Info.t_MaxWidth = 256;
    Info.t_color.R = byte(R);
    Info.t_color.G = byte(G);
    Info.t_color.B = byte(B);
    Info.t_color.A = byte(255);
    Info.t_strText = Str;
    return;
}

function MakeDrawPanelInfo_Desc(out DrawItemInfo Info, string Str, int R, int G, int B, int MaxWidth)
{
    Info = m_kDrawInfoClear;
    Info.eType = 1;
    Info.bLineBreak = true;
    Info.t_bDrawOneLine = false;
    Info.t_MaxWidth = MaxWidth;
    Info.t_color.R = byte(R);
    Info.t_color.G = byte(G);
    Info.t_color.B = byte(B);
    Info.t_color.A = byte(255);
    Info.t_strText = Str;
    return;
}

function bool MakeDrawInfo_Image(out DrawItemInfo Info, string TextureName, int Width, int Height)
{
    Info = m_kDrawInfoClear;
    // End:0x8F
    if(Len(TextureName) > 0)
    {
        Info.eType = 2;
        Info.nOffSetX = 0;
        Info.nOffSetY = 0;
        Info.u_nTextureWidth = Width;
        Info.u_nTextureHeight = Height;
        Info.u_nTextureUWidth = Width;
        Info.u_nTextureUHeight = Height;
        Info.u_strTexture = TextureName;
        return true;
    }
    return false;
    return;
}

function MakeDrawInfo_Blank(out DrawItemInfo Info, int Height)
{
    Info = m_kDrawInfoClear;
    Info.eType = 0;
    Info.b_nHeight = Height;
    return;
}

function MakeDrawInfo_TextLink(out DrawItemInfo Info, int Id, int R, int G, int B)
{
    Info = m_kDrawInfoClear;
    Info.eType = 4;
    Info.t_ID = Id;
    Info.t_color.R = byte(R);
    Info.t_color.G = byte(G);
    Info.t_color.B = byte(B);
    Info.t_color.A = byte(255);
    Info.t_strText = "";
    return;
}

function string ZERO_STR(int Num)
{
    // End:0x13
    if(Num < 10)
    {
        return "0";        
    }
    else
    {
        return "";
    }
    return;
}

function int ConvertPreItemPanelType(BR_CashShopAPI.EPreItemPanelType Type)
{
    // End:0x15
    if(int(Type) == int(0))
    {
        return 0;        
    }
    else
    {
        // End:0x2A
        if(int(Type) == int(1))
        {
            return 1;            
        }
        else
        {
            // End:0x40
            if(int(Type) == int(2))
            {
                return 2;                
            }
            else
            {
                // End:0x56
                if(int(Type) == int(3))
                {
                    return 3;                    
                }
                else
                {
                    // End:0x69
                    if(int(Type) == int(4))
                    {
                        return 4;
                    }
                }
            }
        }
    }
    return 0;
    return;
}

function ProductItemSort(UIEventManager.EBR_CashShopProduct ProductType, int eSortType, bool bSortDesc)
{
    local int iCount;

    // End:0x22
    if(int(ProductType) == int(0))
    {
        iCount = m_ProductList.Length - 1;        
    }
    else
    {
        // End:0x44
        if(int(ProductType) == int(1))
        {
            iCount = m_RecentList.Length - 1;            
        }
        else
        {
            // End:0x63
            if(int(ProductType) == int(2))
            {
                iCount = m_BasketList.Length - 1;
            }
        }
    }
    // End:0x94
    if(eSortType == 0)
    {
        quicksortIndex(ProductType, 0, iCount, bSortDesc);
        NewProductItemSort(bSortDesc);        
    }
    else
    {
        // End:0xCB
        if(eSortType == 1)
        {
            quicksortIndex(ProductType, 0, iCount, false);
            quicksortPrice(ProductType, 0, iCount, bSortDesc);            
        }
        else
        {
            // End:0xEE
            if(eSortType == 2)
            {
                quickSortChar(ProductType, 0, iCount, bSortDesc);
            }
        }
    }
    return;
}

function NewProductItemSort(bool bSortDesc)
{
    local int i, Size;
    local array<ProductInfo> NewProductList, TempProductList;

    i = 0;
    J0x07:

    // End:0x96 [Loop If]
    if(i < m_ProductList.Length)
    {
        // End:0x63
        if((m_ProductList[i].iPanel_Type - 1) == (ConvertPreItemPanelType(2)))
        {
            Size = NewProductList.Length + 1;
            NewProductList[Size - 1] = m_ProductList[i];
            // [Explicit Continue]
            goto J0x8C;
        }
        Size = TempProductList.Length + 1;
        TempProductList[Size - 1] = m_ProductList[i];
        J0x8C:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x14A
    if(bSortDesc)
    {
        // End:0x147
        if(NewProductList.Length > 0)
        {
            m_ProductList.Length = 0;
            i = 0;
            J0xBA:

            // End:0xFD [Loop If]
            if(i < NewProductList.Length)
            {
                Size = m_ProductList.Length + 1;
                m_ProductList[Size - 1] = NewProductList[i];
                i++;
                // [Loop Continue]
                goto J0xBA;
            }
            i = 0;
            J0x104:

            // End:0x147 [Loop If]
            if(i < TempProductList.Length)
            {
                Size = m_ProductList.Length + 1;
                m_ProductList[Size - 1] = TempProductList[i];
                i++;
                // [Loop Continue]
                goto J0x104;
            }
        }        
    }
    else
    {
        // End:0x1F2
        if(NewProductList.Length > 0)
        {
            m_ProductList.Length = 0;
            i = 0;
            J0x165:

            // End:0x1A8 [Loop If]
            if(i < TempProductList.Length)
            {
                Size = m_ProductList.Length + 1;
                m_ProductList[Size - 1] = TempProductList[i];
                i++;
                // [Loop Continue]
                goto J0x165;
            }
            i = 0;
            J0x1AF:

            // End:0x1F2 [Loop If]
            if(i < NewProductList.Length)
            {
                Size = m_ProductList.Length + 1;
                m_ProductList[Size - 1] = NewProductList[i];
                i++;
                // [Loop Continue]
                goto J0x1AF;
            }
        }
    }
    return;
}

function swap(UIEventManager.EBR_CashShopProduct ProductType, int i, int j)
{
    local ProductInfo ProductItem;

    // End:0x4C
    if(int(ProductType) == int(0))
    {
        ProductItem = m_ProductList[i];
        m_ProductList[i] = m_ProductList[j];
        m_ProductList[j] = ProductItem;        
    }
    else
    {
        // End:0x98
        if(int(ProductType) == int(1))
        {
            ProductItem = m_RecentList[i];
            m_RecentList[i] = m_RecentList[j];
            m_RecentList[j] = ProductItem;            
        }
        else
        {
            // End:0xE1
            if(int(ProductType) == int(2))
            {
                ProductItem = m_BasketList[i];
                m_BasketList[i] = m_BasketList[j];
                m_BasketList[j] = ProductItem;
            }
        }
    }
    return;
}

function int partitionIndex(UIEventManager.EBR_CashShopProduct ProductType, int Low, int High, bool Desc)
{
    local int pivot, i, j;
    local ProductInfo ProductItem;

    ProductItem = ArraySortProductItem(ProductType, Low);
    pivot = ProductItem.iProductID;
    j = Low;
    i = Low + 1;
    J0x3F:

    // End:0xDA [Loop If]
    if(i <= High)
    {
        // End:0x95
        if(Desc)
        {
            // End:0x92
            if(ArraySortProductItem(ProductType, i).iProductID > pivot)
            {
                j++;
                swap(ProductType, i, j);
            }
            // [Explicit Continue]
            goto J0xD0;
        }
        // End:0xD0
        if(ArraySortProductItem(ProductType, i).iProductID < pivot)
        {
            j++;
            swap(ProductType, i, j);
        }
        J0xD0:

        i++;
        // [Loop Continue]
        goto J0x3F;
    }
    swap(ProductType, Low, j);
    return j;
    return;
}

function quicksortIndex(UIEventManager.EBR_CashShopProduct ProductType, int Left, int Right, bool Desc)
{
    local int q;

    // End:0x17
    if((Right - Left) == 0)
    {
        return;        
    }
    else
    {
        // End:0x83
        if(Left < Right)
        {
            q = partitionIndex(ProductType, Left, Right, Desc);
            quicksortIndex(ProductType, Left, q - 1, Desc);
            quicksortIndex(ProductType, q + 1, Right, Desc);
        }
    }
    return;
}

function int partitionPrice(UIEventManager.EBR_CashShopProduct ProductType, int Low, int High, bool Desc)
{
    local int pivot, i, j;
    local ProductInfo ProductItem;

    ProductItem = ArraySortProductItem(ProductType, Low);
    pivot = ProductItem.iPrice;
    j = Low;
    i = Low + 1;
    J0x3F:

    // End:0xDA [Loop If]
    if(i <= High)
    {
        // End:0x95
        if(Desc)
        {
            // End:0x92
            if(ArraySortProductItem(ProductType, i).iPrice > pivot)
            {
                j++;
                swap(ProductType, i, j);
            }
            // [Explicit Continue]
            goto J0xD0;
        }
        // End:0xD0
        if(ArraySortProductItem(ProductType, i).iPrice < pivot)
        {
            j++;
            swap(ProductType, i, j);
        }
        J0xD0:

        i++;
        // [Loop Continue]
        goto J0x3F;
    }
    swap(ProductType, Low, j);
    return j;
    return;
}

function quicksortPrice(UIEventManager.EBR_CashShopProduct ProductType, int Left, int Right, bool Desc)
{
    local int q;

    // End:0x17
    if((Right - Left) == 0)
    {
        return;        
    }
    else
    {
        // End:0x83
        if(Left < Right)
        {
            q = partitionPrice(ProductType, Left, Right, Desc);
            quicksortPrice(ProductType, Left, q - 1, Desc);
            quicksortPrice(ProductType, q + 1, Right, Desc);
        }
    }
    return;
}

function int partitionChar(UIEventManager.EBR_CashShopProduct ProductType, int Low, int High, bool Desc)
{
    local string pivot, temp;
    local int i, j;
    local ProductInfo ProductItem;

    ProductItem = ArraySortProductItem(ProductType, Low);
    pivot = Caps(ProductItem.strName);
    j = Low;
    i = Low + 1;
    J0x41:

    // End:0xD9 [Loop If]
    if(i <= High)
    {
        temp = Caps(ArraySortProductItem(ProductType, i).strName);
        // End:0xA4
        if(Desc)
        {
            // End:0xA1
            if(temp > pivot)
            {
                j++;
                swap(ProductType, i, j);
            }
            // [Explicit Continue]
            goto J0xCF;
        }
        // End:0xCF
        if(temp < pivot)
        {
            j++;
            swap(ProductType, i, j);
        }
        J0xCF:

        i++;
        // [Loop Continue]
        goto J0x41;
    }
    swap(ProductType, Low, j);
    return j;
    return;
}

function quickSortChar(UIEventManager.EBR_CashShopProduct ProductType, int Left, int Right, bool Desc)
{
    local int q;

    // End:0x17
    if((Right - Left) == 0)
    {
        return;        
    }
    else
    {
        // End:0x83
        if(Left < Right)
        {
            q = partitionChar(ProductType, Left, Right, Desc);
            quickSortChar(ProductType, Left, q - 1, Desc);
            quickSortChar(ProductType, q + 1, Right, Desc);
        }
    }
    return;
}

function ProductInfo ArraySortProductItem(UIEventManager.EBR_CashShopProduct ProductType, int i)
{
    local ProductInfo ProductItem;

    // End:0x24
    if(int(ProductType) == int(0))
    {
        ProductItem = m_ProductList[i];        
    }
    else
    {
        // End:0x48
        if(int(ProductType) == int(1))
        {
            ProductItem = m_RecentList[i];            
        }
        else
        {
            // End:0x69
            if(int(ProductType) == int(2))
            {
                ProductItem = m_BasketList[i];
            }
        }
    }
    return ProductItem;
    return;
}

function string SetPaymentTypeDetail(int iPaymentType, int iPrice)
{
    local string strTemp;
    local float priceMoney;

    // End:0x8E
    if(iPaymentType == 0)
    {
        // End:0x5B
        if(m_bCoinToMoney)
        {
            priceMoney = float(iPrice) * m_fCoinMoneyValue;
            strTemp = (((GetSystemString(190) $ " : ") $ string(priceMoney)) $ " ") $ GetSystemString(5012);            
        }
        else
        {
            strTemp = (((GetSystemString(190) $ " : ") $ string(iPrice)) $ " ") $ GetSystemString(5012);
        }        
    }
    else
    {
        // End:0xCC
        if(iPaymentType == 1)
        {
            strTemp = (((GetSystemString(190) $ " : ") $ string(iPrice)) $ " ") $ GetSystemString(469);            
        }
        else
        {
            // End:0x108
            if(iPaymentType == 2)
            {
                strTemp = (((GetSystemString(190) $ " : ") $ string(iPrice)) $ " ") $ GetSystemString(5179);
            }
        }
    }
    return strTemp;
    return;
}

function string SetPaymentType(int iPaymentType, int iPrice)
{
    local string strTemp;
    local float priceMoney;

    // End:0x6C
    if(iPaymentType == 0)
    {
        // End:0x4A
        if(m_bCoinToMoney)
        {
            priceMoney = float(iPrice) * m_fCoinMoneyValue;
            strTemp = (string(priceMoney) $ " ") $ GetSystemString(5012);            
        }
        else
        {
            strTemp = (string(iPrice) $ " ") $ GetSystemString(5012);
        }        
    }
    else
    {
        // End:0x99
        if(iPaymentType == 1)
        {
            strTemp = (string(iPrice) $ " ") $ GetSystemString(469);            
        }
        else
        {
            // End:0xC4
            if(iPaymentType == 2)
            {
                strTemp = (string(iPrice) $ " ") $ GetSystemString(5179);
            }
        }
    }
    return strTemp;
    return;
}

function string ErrorResultBuy(int iResult)
{
    local string sysmeg;

    switch(iResult)
    {
        // End:0x0F
        case -7:
        // End:0x2B
        case -8:
            sysmeg = GetSystemMessage(6003);
            // End:0x2BE
            break;
        // End:0x47
        case -1:
            sysmeg = GetSystemMessage(6005);
            // End:0x2BE
            break;
        // End:0x4F
        case -2:
        // End:0x6B
        case -5:
            sysmeg = GetSystemMessage(6008);
            // End:0x2BE
            break;
        // End:0x87
        case -4:
            sysmeg = GetSystemMessage(6006);
            // End:0x2BE
            break;
        // End:0x8F
        case -9:
        // End:0xAB
        case -11:
            sysmeg = GetSystemMessage(6007);
            // End:0x2BE
            break;
        // End:0xC7
        case -10:
            sysmeg = GetSystemMessage(6009);
            // End:0x2BE
            break;
        // End:0xE3
        case -12:
            sysmeg = GetSystemMessage(6019);
            // End:0x2BE
            break;
        // End:0xFF
        case -13:
            sysmeg = GetSystemMessage(6020);
            // End:0x2BE
            break;
        // End:0x11B
        case -14:
            sysmeg = GetSystemMessage(350);
            // End:0x2BE
            break;
        // End:0x137
        case -17:
            sysmeg = GetSystemMessage(3002);
            // End:0x2BE
            break;
        // End:0x153
        case -18:
            sysmeg = GetSystemMessage(3019);
            // End:0x2BE
            break;
        // End:0x16F
        case -19:
            sysmeg = GetSystemMessage(2968);
            // End:0x2BE
            break;
        // End:0x18B
        case -20:
            sysmeg = GetSystemMessage(3077);
            // End:0x2BE
            break;
        // End:0x1A7
        case -21:
            sysmeg = GetSystemMessage(3082);
            // End:0x2BE
            break;
        // End:0x1C3
        case -22:
            sysmeg = GetSystemMessage(6070);
            // End:0x2BE
            break;
        // End:0x1DF
        case -23:
            sysmeg = GetSystemMessage(6098);
            // End:0x2BE
            break;
        // End:0x1FB
        case -24:
            sysmeg = GetSystemMessage(6129);
            // End:0x2BE
            break;
        // End:0x217
        case -25:
            sysmeg = GetSystemMessage(279);
            // End:0x2BE
            break;
        // End:0x233
        case -26:
            sysmeg = GetSystemMessage(6144);
            // End:0x2BE
            break;
        // End:0x24F
        case -27:
            sysmeg = GetSystemMessage(6155);
            // End:0x2BE
            break;
        // End:0x26B
        case -28:
            sysmeg = GetSystemMessage(6823);
            // End:0x2BE
            break;
        // End:0x287
        case -3:
            sysmeg = GetSystemMessage(351);
            // End:0x2BE
            break;
        // End:0x28F
        case -6:
        // End:0xFFFF
        default:
            sysmeg = (GetSystemMessage(6002) $ " errorcode:") $ string(iResult);
            // End:0x2BE
            break;
            break;
    }
    return sysmeg;
    return;
}
