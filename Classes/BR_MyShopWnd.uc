class BR_MyShopWnd extends UICommonAPI;

const DIALOG_PRODUCT_QUANTITY = 351;
const DIALOG_CLOSED_SHOP = 352;
const DIALOG_BASKET_ALL_CLEAR = 353;
const ITEM_INFO_WIDTH = 256;
const PAGE_MAX = 5;

var int m_iCurrentHeight;
var DrawItemInfo m_kDrawInfoClear;
var array<ProductInfo> m_CurrentProductList;
var int m_nCurrentTabPage;
var int m_iCurrentTabTotalPage;
var bool m_bCoinToMoney;
var float m_fCoinMoneyValue;
var int m_iCurrentTab;
var WindowHandle Me;
var TabHandle TabCategory;
var array<WindowHandle> BR_MyShop_Item;
var ButtonHandle BtnClear;
var TextBoxHandle TextViewPageNum;
var BR_CashShopAPI m_CashShopAPI;

function OnRegisterEvent()
{
    RegisterEvent(9032);
    RegisterEvent(9033);
    RegisterEvent(9021);
    RegisterEvent(9013);
    RegisterEvent(9014);
    RegisterEvent(1710);
    return;
}

function OnLoad()
{
    RegisterState("BR_MyShopWnd", "TRAININGROOMSTATE");
    // End:0x34
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    InitHandle();
    Initialize();
    return;
}

function InitHandle()
{
    // End:0x189
    if(1 == 0)
    {
        Me = GetHandle("BR_MyShopWnd");
        BtnClear = ButtonHandle(GetHandle("BR_MyShopWnd.BtnClear"));
        TabCategory = TabHandle(GetHandle("BR_MyShopWnd.TabCategory"));
        BR_MyShop_Item.Length = 5;
        BR_MyShop_Item[0] = GetHandle("BR_MyShopWnd.CashItemData_1");
        BR_MyShop_Item[1] = GetHandle("BR_MyShopWnd.CashItemData_2");
        BR_MyShop_Item[2] = GetHandle("BR_MyShopWnd.CashItemData_3");
        BR_MyShop_Item[3] = GetHandle("BR_MyShopWnd.CashItemData_4");
        BR_MyShop_Item[4] = GetHandle("BR_MyShopWnd.CashItemData_5");
        TextViewPageNum = TextBoxHandle(GetHandle("BR_MyShopWnd.TextViewPageNum"));        
    }
    else
    {
        Me = GetWindowHandle("BR_MyShopWnd");
        BtnClear = GetButtonHandle("BR_MyShopWnd.BtnClear");
        TabCategory = GetTabHandle("BR_MyShopWnd.TabCategory");
        BR_MyShop_Item.Length = 5;
        BR_MyShop_Item[0] = GetWindowHandle("BR_MyShopWnd.CashItemData_1");
        BR_MyShop_Item[1] = GetWindowHandle("BR_MyShopWnd.CashItemData_2");
        BR_MyShop_Item[2] = GetWindowHandle("BR_MyShopWnd.CashItemData_3");
        BR_MyShop_Item[3] = GetWindowHandle("BR_MyShopWnd.CashItemData_4");
        BR_MyShop_Item[4] = GetWindowHandle("BR_MyShopWnd.CashItemData_5");
        TextViewPageNum = GetTextBoxHandle("BR_MyShopWnd.TextViewPageNum");
    }
    return;
}

function Initialize()
{
    m_iCurrentTab = 0;
    m_bCoinToMoney = IsBr_CashShopCoinToMoney();
    // End:0x29
    if(m_bCoinToMoney)
    {
        m_fCoinMoneyValue = GetBr_CashShopCoinToMoneyValue();
    }
    m_CurrentProductList.Length = 0;
    m_nCurrentTabPage = 0;
    m_iCurrentTabTotalPage = 0;
    TabCategory.SetButtonName(2, "");
    TabCategory.SetDisable(2, true);
    TabCategory.SetButtonDisableTexture(2, "L2UI_CT1.tab.Tab_DF_Bg_line");
    m_CashShopAPI = BR_CashShopAPI(GetScript("BR_CashShopAPI"));
    return;
}

function selectedInit()
{
    m_CashShopAPI.ClearBasketItemList();
    m_CashShopAPI.ClearRecentList();
    RequestBR_ProductList(1);
    RequestBR_ProductList(2);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int iResult, ProductID;

    switch(Event_ID)
    {
        // End:0x1D
        case 9032:
            HandleAddBasketProduct(param);
            // End:0x125
            break;
        // End:0x49
        case 9013:
            // End:0x46
            if(m_iCurrentTab == 1)
            {
                OnTabList(m_CashShopAPI.GetRecentProductList(), true);
            }
            // End:0x125
            break;
        // End:0x75
        case 9014:
            // End:0x72
            if(m_iCurrentTab == 0)
            {
                OnTabList(m_CashShopAPI.GetBasketProductList(), false);
            }
            // End:0x125
            break;
        // End:0xB2
        case 9021:
            ParseInt(param, "Option", iResult);
            // End:0xAF
            if(iResult == -1)
            {
                PrepareProductList(iResult);
            }
            // End:0x125
            break;
        // End:0x111
        case 9033:
            ParseInt(param, "ID", ProductID);
            RequestBR_DeleteBasketProductInfo(ProductID);
            m_CashShopAPI.DeleteBasketProductItem(ProductID);
            // End:0x10E
            if(m_iCurrentTab == 0)
            {
                OnTabList(m_CashShopAPI.GetBasketProductList(), false);
            }
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

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
    local int SelectedProductID;
    local string btnName;

    // End:0x0D
    if(a_ButtonHandle == none)
    {
        return;
    }
    // End:0x21
    if(m_CashShopAPI.GetOpenBuyWnd())
    {
        return;
    }
    btnName = a_ButtonHandle.GetWindowName();
    SelectedProductID = a_ButtonHandle.GetButtonValue();
    // End:0x58
    if(SelectedProductID < 0)
    {
        return;
    }
    switch(btnName)
    {
        // End:0xB0
        case "BtnBuy":
            Debug("OnClickButtonWithHandle BtnBuy" $ string(SelectedProductID));
            m_CashShopAPI.OnBtnBuyClick(SelectedProductID);
            // End:0x15A
            break;
        // End:0x109
        case "BtnPresent":
            Debug("OnClickButtonWithHandle BtnPresent" $ string(SelectedProductID));
            m_CashShopAPI.OnBtnPresentClick(SelectedProductID);
            // End:0x15A
            break;
        // End:0x157
        case "BtnDelete":
            Debug("OnClickButtonWithHandle BtnDelete" $ string(SelectedProductID));
            OnBtnDeleteClick(SelectedProductID);
            // End:0x15A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x2D
        case "BtnClear":
            OnBtnClear();
            Debug("BtnClear");
            // End:0x1A1
            break;
        // End:0x6F
        case "BtnViewPreEnd":
            // End:0x57
            if(m_nCurrentTabPage > 1)
            {
                m_nCurrentTabPage = 1;
                SetViewProductList();
            }
            Debug("BtnViewPreEnd");
            // End:0x1A1
            break;
        // End:0xB2
        case "BtnViewPre":
            // End:0x9D
            if(m_nCurrentTabPage > 1)
            {
                m_nCurrentTabPage = m_nCurrentTabPage - 1;
                SetViewProductList();
            }
            Debug("BtnViewPre");
            // End:0x1A1
            break;
        // End:0xFB
        case "BtnViewNext":
            // End:0xE5
            if(m_nCurrentTabPage < m_iCurrentTabTotalPage)
            {
                m_nCurrentTabPage = m_nCurrentTabPage + 1;
                SetViewProductList();
            }
            Debug("BtnViewNext");
            // End:0x1A1
            break;
        // End:0x147
        case "BtnViewNextEnd":
            // End:0x12E
            if(m_nCurrentTabPage != m_iCurrentTabTotalPage)
            {
                m_nCurrentTabPage = m_iCurrentTabTotalPage;
                SetViewProductList();
            }
            Debug("BtnViewNextEnd");
            // End:0x1A1
            break;
        // End:0x171
        case "TabCategory0":
            OnTabList(m_CashShopAPI.GetBasketProductList(), false);
            // End:0x1A1
            break;
        // End:0x19B
        case "TabCategory1":
            OnTabList(m_CashShopAPI.GetRecentProductList(), true);
            // End:0x1A1
            break;
        // End:0xFFFF
        default:
            // End:0x1A1
            break;
            break;
    }
    return;
}

function ClearItemList()
{
    local int i;

    m_CurrentProductList.Length = 0;
    i = 0;
    J0x0F:

    // End:0x3A [Loop If]
    if(i < 5)
    {
        BR_MyShop_Item[i].HideWindow();
        i++;
        // [Loop Continue]
        goto J0x0F;
    }
    return;
}

function HandleAddBasketProduct(string param)
{
    local int ProductID;

    ParseInt(param, "ID", ProductID);
    m_CashShopAPI.AddMyShopBasketProductItem(ProductID);
    RequestBR_AddBasketProductInfo(ProductID);
    // End:0x66
    if(Me.IsShowWindow())
    {
        // End:0x66
        if(m_iCurrentTab == 0)
        {
            OnTabList(m_CashShopAPI.GetBasketProductList(), false);
        }
    }
    return;
}

function HandleDialogOK()
{
    local int Id, Num;
    local WindowHandle m_BuyWnd;

    // End:0xE2
    if(DialogIsMine())
    {
        Id = DialogGetID();
        Num = int(DialogGetString());
        // End:0x77
        if(Id == 353)
        {
            // End:0x74
            if(m_iCurrentTab == 0)
            {
                RequestBR_DeleteBasketProductInfo(0);
                m_CashShopAPI.ClearBasketItemList();
                OnTabList(m_CashShopAPI.GetBasketProductList(), false);
                ExecuteEvent(9035);
            }            
        }
        else
        {
            // End:0xE2
            if(Id == 352)
            {
                m_BuyWnd = GetWindowHandle("BR_BuyingWnd");
                // End:0xC1
                if(m_BuyWnd.IsShowWindow())
                {
                    m_BuyWnd.HideWindow();
                }
                // End:0xE2
                if(m_hOwnerWnd.IsShowWindow())
                {
                    m_hOwnerWnd.HideWindow();
                }
            }
        }
    }
    return;
}

function PrepareProductList(int iOption)
{
    local WindowHandle m_NewBuyWnd;

    ClearItemList();
    // End:0x92
    if(iOption == -1)
    {
        m_NewBuyWnd = GetWindowHandle("BR_NewBuyingWnd");
        // End:0x92
        if(m_hOwnerWnd.IsShowWindow() || m_NewBuyWnd.IsShowWindow())
        {
            DialogSetID(352);
            DialogSetDefaultOK();
            DialogShow(0, 4, MakeFullSystemMsg(GetSystemMessage(1474), GetSystemString(5021)), string(self));
        }
    }
    return;
}

function OnTabList(array<ProductInfo> productList, bool Desc)
{
    local int currentindex, i, TotalPage;

    ClearItemList();
    m_iCurrentTab = TabCategory.GetTopIndex();
    Debug("OnTabList" $ string(productList.Length));
    i = 0;
    J0x3D:

    // End:0x8D [Loop If]
    if(i < productList.Length)
    {
        m_CurrentProductList.Length = m_CurrentProductList.Length + 1;
        currentindex = m_CurrentProductList.Length - 1;
        m_CurrentProductList[currentindex] = productList[i];
        i++;
        // [Loop Continue]
        goto J0x3D;
    }
    Debug("OnTabList CurrentProductList" $ string(m_CurrentProductList.Length));
    // End:0xD8
    if(productList.Length <= 0)
    {
        m_nCurrentTabPage = 1;
        m_iCurrentTabTotalPage = 1;        
    }
    else
    {
        TotalPage = int(float(m_CurrentProductList.Length) % float(5));
        // End:0x10F
        if(TotalPage > 0)
        {
            m_iCurrentTabTotalPage = (m_CurrentProductList.Length / 5) + 1;            
        }
        else
        {
            m_iCurrentTabTotalPage = m_CurrentProductList.Length / 5;
        }
        m_nCurrentTabPage = 1;
    }
    // End:0x143
    if(m_iCurrentTab == 1)
    {
        BtnClear.HideWindow();        
    }
    else
    {
        BtnClear.ShowWindow();
    }
    SetViewProductList();
    return;
}

function SetViewProductList()
{
    local int i, j;
    local ProductInfo Info;
    local bool visableDelete;

    // End:0x16
    if(m_iCurrentTab == 1)
    {
        visableDelete = false;        
    }
    else
    {
        visableDelete = true;
    }
    Debug("OnTabList m_iCurrentTab" $ string(m_iCurrentTab));
    j = 0;
    i = (m_nCurrentTabPage - 1) * 5;
    J0x5F:

    // End:0xF4 [Loop If]
    if(i < (m_nCurrentTabPage * 5))
    {
        BR_MyShop_Item[j].HideWindow();
        // End:0xE3
        if(i < m_CurrentProductList.Length)
        {
            Info = m_CurrentProductList[i];
            m_CashShopAPI.SetViewProductWindow(BR_MyShop_Item[j], Info, true, visableDelete);
            BR_MyShop_Item[j].ShowWindow();
        }
        j++;
        i++;
        // [Loop Continue]
        goto J0x5F;
    }
    TextViewPageNum.SetText((("" $ string(m_nCurrentTabPage)) $ "/") $ string(m_iCurrentTabTotalPage));
    return;
}

function OnBtnClear()
{
    // End:0x14
    if(m_CashShopAPI.GetOpenBuyWnd())
    {
        return;
    }
    DialogSetID(353);
    DialogSetDefaultOK();
    DialogShow(0, 4, GetSystemMessage(6115), string(self));
    return;
}

function OnBtnDeleteClick(int ProductID)
{
    local string strParam;

    m_CashShopAPI.DeleteBasketProductItem(ProductID);
    RequestBR_DeleteBasketProductInfo(ProductID);
    ParamAdd(strParam, "ID", string(ProductID));
    ExecuteEvent(9034, strParam);
    // End:0x78
    if(m_iCurrentTab == 0)
    {
        // End:0x78
        if(Me.IsShowWindow())
        {
            OnTabList(m_CashShopAPI.GetBasketProductList(), false);
        }
    }
    return;
}
