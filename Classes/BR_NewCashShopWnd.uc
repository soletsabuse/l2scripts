class BR_NewCashShopWnd extends UICommonAPI;

const TIMER_EVENT_ID = 1410;
const TIMER_EVENT_DELAY = 10000;
const TIMER_SCROLL_ID = 1411;
const TIMER_SCROLL_DELAY = 100;
const DIALOG_CLOSED_SHOP = 352;
const DIALOG_MYSHOP_BASKET = 353;
const FEE_OFFSET_Y_EQUIP = -18;
const ITEM_INFO_LEFT_MARGIN = 10;
const ITEM_INFO_BLANK_HEIGHT = 10;
const PAGE_MAX = 10;
const TAB_MASK = 0;
const TAB_CATEGORY = 1;
const TAB_RECENT = 2;
const PRODUCT_TAB_ADVERTISING = 0x00000001;
const PRODUCT_TAB_RECOMMEND = 0x00000002;
const PRODUCT_TAB_POPULAR = 0x00000004;

enum EPrItemSortType
{
    PR_ITEM_INDEX,                  // 0
    PR_ITEM_PRICE,                  // 1
    PR_ITEM_NAME                    // 2
};

struct ViewProductInfo
{
    var int iCategory;
    var int iShowTab;
    var int iTabType;
    var string strTitleName;
};

var DrawItemInfo m_kDrawInfoClear;
var bool m_bInitMainRand;
var bool m_bInitHandle;
var bool m_bSetFocusChange;
var array<ViewProductInfo> m_ViewProductInfo;
var array<int> m_CurrentProductList;
var int m_nCurrentTabPage;
var int m_iCurrentTabTotalPage;
var array<int> m_MainGoodProductList;
var int m_nMainGoodTabPage;
var int m_iMainGoodTabTotalPage;
var array<int> m_MainStarProductList;
var int m_nMainStarTabPage;
var int m_iMainStarTabTotalPage;
var array<int> m_EventProductList;
var int m_nMainEventTabPage;
var int m_iCurrentTab;
var int m_iAllItemTab;
var bool m_bInConfirm;
var bool m_bSortDesc;
var bool m_bCoinToMoney;
var float m_fCoinMoneyValue;
var bool m_bSearch;
var bool m_bInitOpen;
var bool m_bMainDisable;
var int m_scrollheight;
var BR_CashShopAPI m_CashShopAPI;
var WindowHandle Me;
var EditBoxHandle EditItemSearch;
var ButtonHandle BtnItemSearch;
var ButtonHandle BtnItemIndexSort;
var ButtonHandle BtnItemPointSort;
var ButtonHandle BtnItemNameSort;
var TabHandle TabCategory;
var ButtonHandle BtnCashCharge;
var TextBoxHandle TextCurrentCash;
var TextureHandle TexCategoryUpper;
var WindowHandle ScrollItemInfo;
var WindowHandle Drawer;
var WindowHandle BR_MainCashShopTab;
var WindowHandle BR_ViewCashShopTab;
var WindowHandle BR_MainCashShopTab_Main;
var array<WindowHandle> BR_MainGoodCashShopTab_Item;
var array<WindowHandle> BR_MainStarCashShopTab_Item;
var array<WindowHandle> BR_ViewCashShopTab_Item;
var TextBoxHandle TextViewPageNum;
var TextBoxHandle EventPageNum;
var TextBoxHandle GoodPageNum;
var TextBoxHandle StarPageNum;
var WindowHandle BR_MyShopWnd;
var bool bOpenMyShopReceiverWnd;

function OnRegisterEvent()
{
    RegisterEvent(9010);
    RegisterEvent(9022);
    RegisterEvent(9014);
    RegisterEvent(9050);
    RegisterEvent(9051);
    RegisterEvent(9070);
    RegisterEvent(9071);
    RegisterEvent(9011);
    RegisterEvent(9012);
    RegisterEvent(9016);
    RegisterEvent(9072);
    RegisterEvent(9073);
    RegisterEvent(9034);
    RegisterEvent(9035);
    RegisterEvent(1710);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    bOpenMyShopReceiverWnd = false;
    m_bInitMainRand = false;
    m_bInitHandle = false;
    RegisterState("BR_NewCashShopWnd", "TRAININGROOMSTATE");
    InitHandle();
    Initialize();
    return;
}

function InitHandle()
{
    // End:0x877
    if(1 == 0)
    {
        Me = GetHandle("BR_NewCashShopWnd");
        EditItemSearch = EditBoxHandle(GetHandle("BR_NewCashShopWnd.EditItemSearch"));
        BtnItemSearch = ButtonHandle(GetHandle("BR_NewCashShopWnd.BtnItemSearch"));
        BtnItemIndexSort = ButtonHandle(GetHandle("BR_NewCashShopWnd.BtnItemIndexSort"));
        BtnItemPointSort = ButtonHandle(GetHandle("BR_NewCashShopWnd.BtnItemPointSort"));
        BtnItemNameSort = ButtonHandle(GetHandle("BR_NewCashShopWnd.BtnItemNameSort"));
        TabCategory = TabHandle(GetHandle("BR_NewCashShopWnd.TabCategory"));
        BtnCashCharge = ButtonHandle(GetHandle("BR_NewCashShopWnd.BtnCashCharge"));
        TextCurrentCash = TextBoxHandle(GetHandle("BR_NewCashShopWnd.TextCurrentCash"));
        TexCategoryUpper = TextureHandle(GetHandle("BR_NewCashShopWnd.TexCategoryUpper"));
        ScrollItemInfo = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.ScrollItemInfo");
        Drawer = GetHandle("PopupWnd");
        BR_MyShopWnd = GetHandle("BR_MyShopWnd");
        BR_MainCashShopTab = GetHandle("BR_NewCashShopWnd.BR_MainCashShopTab");
        BR_ViewCashShopTab = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab");
        BR_MainCashShopTab_Main = GetHandle("BR_NewCashShopWnd.BR_MainCashShopTab.BR_MainCashShopTab_Main");
        EventPageNum = TextBoxHandle(GetHandle("BR_NewCashShopWnd.BR_MainCashShopTab.BR_MainCashShopTab_Main.EventPageNum"));
        GoodPageNum = TextBoxHandle(GetHandle("BR_NewCashShopWnd.BR_MainCashShopTab.GoodPageNum"));
        StarPageNum = TextBoxHandle(GetHandle("BR_NewCashShopWnd.BR_MainCashShopTab.StarPageNum"));
        BR_MainGoodCashShopTab_Item.Length = 3;
        BR_MainGoodCashShopTab_Item[0] = GetHandle("BR_NewCashShopWnd.BR_MainCashShopTab.GoodItem1");
        BR_MainGoodCashShopTab_Item[1] = GetHandle("BR_NewCashShopWnd.BR_MainCashShopTab.GoodItem2");
        BR_MainGoodCashShopTab_Item[2] = GetHandle("BR_NewCashShopWnd.BR_MainCashShopTab.GoodItem3");
        BR_MainStarCashShopTab_Item.Length = 3;
        BR_MainStarCashShopTab_Item[0] = GetHandle("BR_NewCashShopWnd.BR_MainCashShopTab.StarItem1");
        BR_MainStarCashShopTab_Item[1] = GetHandle("BR_NewCashShopWnd.BR_MainCashShopTab.StarItem2");
        BR_MainStarCashShopTab_Item[2] = GetHandle("BR_NewCashShopWnd.BR_MainCashShopTab.StarItem3");
        BR_ViewCashShopTab_Item.Length = 10;
        BR_ViewCashShopTab_Item[0] = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_1");
        BR_ViewCashShopTab_Item[1] = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_2");
        BR_ViewCashShopTab_Item[2] = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_3");
        BR_ViewCashShopTab_Item[3] = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_4");
        BR_ViewCashShopTab_Item[4] = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_5");
        BR_ViewCashShopTab_Item[5] = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_6");
        BR_ViewCashShopTab_Item[6] = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_7");
        BR_ViewCashShopTab_Item[7] = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_8");
        BR_ViewCashShopTab_Item[8] = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_9");
        BR_ViewCashShopTab_Item[9] = GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_10");
        TextViewPageNum = TextBoxHandle(GetHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.TextViewPageNum"));        
    }
    else
    {
        Me = GetWindowHandle("BR_NewCashShopWnd");
        EditItemSearch = GetEditBoxHandle("BR_NewCashShopWnd.EditItemSearch");
        BtnItemSearch = GetButtonHandle("BR_NewCashShopWnd.BtnItemSearch");
        BtnItemIndexSort = GetButtonHandle("BR_NewCashShopWnd.BtnItemIndexSort");
        BtnItemPointSort = GetButtonHandle("BR_NewCashShopWnd.BtnItemPointSort");
        BtnItemNameSort = GetButtonHandle("BR_NewCashShopWnd.BtnItemNameSort");
        TabCategory = GetTabHandle("BR_NewCashShopWnd.TabCategory");
        BtnCashCharge = GetButtonHandle("BR_NewCashShopWnd.BtnCashCharge");
        TextCurrentCash = GetTextBoxHandle("BR_NewCashShopWnd.TextCurrentCash");
        TexCategoryUpper = GetTextureHandle("BR_NewCashShopWnd.TexCategoryUpper");
        ScrollItemInfo = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.ScrollItemInfo");
        Drawer = GetWindowHandle("PopupWnd");
        BR_MyShopWnd = GetWindowHandle("BR_MyShopWnd");
        BR_MainCashShopTab = GetWindowHandle("BR_NewCashShopWnd.BR_MainCashShopTab");
        BR_ViewCashShopTab = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab");
        BR_MainCashShopTab_Main = GetWindowHandle("BR_NewCashShopWnd.BR_MainCashShopTab.BR_MainCashShopTab_Main");
        EventPageNum = GetTextBoxHandle("BR_NewCashShopWnd.BR_MainCashShopTab.BR_MainCashShopTab_Main.EventPageNum");
        GoodPageNum = GetTextBoxHandle("BR_NewCashShopWnd.BR_MainCashShopTab.GoodPageNum");
        StarPageNum = GetTextBoxHandle("BR_NewCashShopWnd.BR_MainCashShopTab.StarPageNum");
        BR_MainGoodCashShopTab_Item.Length = 3;
        BR_MainGoodCashShopTab_Item[0] = GetWindowHandle("BR_NewCashShopWnd.BR_MainCashShopTab.GoodItem1");
        BR_MainGoodCashShopTab_Item[1] = GetWindowHandle("BR_NewCashShopWnd.BR_MainCashShopTab.GoodItem2");
        BR_MainGoodCashShopTab_Item[2] = GetWindowHandle("BR_NewCashShopWnd.BR_MainCashShopTab.GoodItem3");
        BR_MainStarCashShopTab_Item.Length = 3;
        BR_MainStarCashShopTab_Item[0] = GetWindowHandle("BR_NewCashShopWnd.BR_MainCashShopTab.StarItem1");
        BR_MainStarCashShopTab_Item[1] = GetWindowHandle("BR_NewCashShopWnd.BR_MainCashShopTab.StarItem2");
        BR_MainStarCashShopTab_Item[2] = GetWindowHandle("BR_NewCashShopWnd.BR_MainCashShopTab.StarItem3");
        BR_ViewCashShopTab_Item.Length = 10;
        BR_ViewCashShopTab_Item[0] = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_1");
        BR_ViewCashShopTab_Item[1] = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_2");
        BR_ViewCashShopTab_Item[2] = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_3");
        BR_ViewCashShopTab_Item[3] = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_4");
        BR_ViewCashShopTab_Item[4] = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_5");
        BR_ViewCashShopTab_Item[5] = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_6");
        BR_ViewCashShopTab_Item[6] = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_7");
        BR_ViewCashShopTab_Item[7] = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_8");
        BR_ViewCashShopTab_Item[8] = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_9");
        BR_ViewCashShopTab_Item[9] = GetWindowHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.CashItemData_10");
        TextViewPageNum = GetTextBoxHandle("BR_NewCashShopWnd.BR_ViewCashShopTab.TextViewPageNum");
    }
    return;
}

function ClickPopupItemList(int ProductID, int showtab)
{
    return;
}

function Initialize()
{
    m_bInConfirm = false;
    m_bSortDesc = false;
    m_bSearch = false;
    m_bCoinToMoney = IsBr_CashShopCoinToMoney();
    // End:0x3A
    if(m_bCoinToMoney)
    {
        m_fCoinMoneyValue = GetBr_CashShopCoinToMoneyValue();
    }
    m_bMainDisable = IsBr_CashShopMainDisable();
    // End:0x7C
    if(m_bMainDisable)
    {
        m_iCurrentTab = 1;
        TabCategory.SetDisable(0, true);
        TabCategory.SetTopOrder(1, false);        
    }
    else
    {
        m_iCurrentTab = 0;
    }
    clearItemInfo();
    m_ViewProductInfo.Length = 7;
    m_ViewProductInfo[0].iCategory = 0;
    m_ViewProductInfo[0].iShowTab = 0;
    m_ViewProductInfo[0].iTabType = 0;
    m_ViewProductInfo[0].strTitleName = GetSystemString(5119);
    m_ViewProductInfo[1].iCategory = 0;
    m_ViewProductInfo[1].iShowTab = 0;
    m_ViewProductInfo[1].iTabType = 0;
    m_ViewProductInfo[1].strTitleName = GetSystemString(5002);
    m_iAllItemTab = 1;
    m_ViewProductInfo[2].iCategory = 3;
    m_ViewProductInfo[2].iShowTab = 0;
    m_ViewProductInfo[2].iTabType = 1;
    m_ViewProductInfo[2].strTitleName = GetSystemString(5007);
    m_ViewProductInfo[3].iCategory = 1;
    m_ViewProductInfo[3].iShowTab = 0;
    m_ViewProductInfo[3].iTabType = 1;
    m_ViewProductInfo[3].strTitleName = GetSystemString(5005);
    m_ViewProductInfo[4].iCategory = 2;
    m_ViewProductInfo[4].iShowTab = 0;
    m_ViewProductInfo[4].iTabType = 1;
    m_ViewProductInfo[4].strTitleName = GetSystemString(5006);
    m_ViewProductInfo[5].iCategory = 4;
    m_ViewProductInfo[5].iShowTab = 0;
    m_ViewProductInfo[5].iTabType = 1;
    m_ViewProductInfo[5].strTitleName = GetSystemString(5008);
    m_ViewProductInfo[6].iCategory = 5;
    m_ViewProductInfo[6].iShowTab = 0;
    m_ViewProductInfo[6].iTabType = 1;
    m_ViewProductInfo[6].strTitleName = GetSystemString(5009);
    SetTabCategory();
    RemoveTabCateroy(7);
    RemoveTabCateroy(8);
    BR_MainCashShopTab_Main.ShowWindow();
    BR_MainCashShopTab.ShowWindow();
    BR_ViewCashShopTab.HideWindow();
    BR_ViewCashShopTab_Item[0].ShowWindow();
    BR_ViewCashShopTab_Item[1].ShowWindow();
    BR_ViewCashShopTab_Item[2].ShowWindow();
    BR_ViewCashShopTab_Item[3].ShowWindow();
    BR_ViewCashShopTab_Item[4].ShowWindow();
    BR_ViewCashShopTab_Item[5].ShowWindow();
    BR_ViewCashShopTab_Item[6].ShowWindow();
    BR_ViewCashShopTab_Item[7].ShowWindow();
    BR_ViewCashShopTab_Item[8].ShowWindow();
    BR_ViewCashShopTab_Item[9].ShowWindow();
    m_CurrentProductList.Length = 0;
    m_nCurrentTabPage = 1;
    m_iCurrentTabTotalPage = 1;
    m_nMainGoodTabPage = 1;
    m_iMainGoodTabTotalPage = 1;
    m_nMainStarTabPage = 1;
    m_iMainStarTabTotalPage = 1;
    m_nMainEventTabPage = 1;
    m_CashShopAPI = BR_CashShopAPI(GetScript("BR_CashShopAPI"));
    Me.KillTimer(1410);
    Me.KillTimer(1411);
    TextViewPageNum.SetText("");
    EventPageNum.SetText("");
    GoodPageNum.SetText("");
    StarPageNum.SetText("");
    m_CashShopAPI.InitMainProductWindow(BR_MainCashShopTab_Main);
    m_bInitOpen = true;
    m_bInitHandle = true;
    m_bSetFocusChange = false;
    return;
}

function SetTabCategory()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x5A [Loop If]
    if(i < m_ViewProductInfo.Length)
    {
        TabCategory.SetButtonName(i, m_ViewProductInfo[i].strTitleName);
        TabCategory.SetDisable(i, false);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function AddTabCateroy(string param)
{
    local int Index, Category, tabType, showtab, nameindex;

    ParseInt(param, "Category", Category);
    ParseInt(param, "TabType", tabType);
    ParseInt(param, "ShowTab", showtab);
    ParseInt(param, "NameIndex", nameindex);
    m_ViewProductInfo.Length = m_ViewProductInfo.Length + 1;
    Index = m_ViewProductInfo.Length - 1;
    m_ViewProductInfo[Index].iCategory = Category;
    m_ViewProductInfo[Index].iTabType = tabType;
    m_ViewProductInfo[Index].iShowTab = showtab;
    m_ViewProductInfo[Index].strTitleName = GetSystemString(nameindex);
    // End:0x107
    if((tabType == 0) && Category == 0)
    {
        m_iAllItemTab = Index;
    }
    return;
}

function RemoveTabCateroy(int Index)
{
    TabCategory.SetButtonName(Index, "");
    TabCategory.SetDisable(Index, true);
    TabCategory.SetButtonDisableTexture(Index, "L2UI_CT1.tab.Tab_DF_Bg_line");
    return;
}

function OnEvent(int Event_ID, string param)
{
    local INT64 iGamePoint;
    local int iResult, i;

    switch(Event_ID)
    {
        // End:0x18
        case 9010:
            HandleToggleWindow();
            // End:0x2A1
            break;
        // End:0x2E
        case 9011:
            AddTabCateroy(param);
            // End:0x2A1
            break;
        // End:0x5B
        case 9012:
            ParseInt(param, "Index", i);
            RemoveTabCateroy(i);
            // End:0x2A1
            break;
        // End:0x6E
        case 9016:
            m_ViewProductInfo.Length = 0;
            // End:0x2A1
            break;
        // End:0x14E
        case 9022:
            m_CashShopAPI.ProductItemSort(0, 0, true);
            AddMainProductItem();
            // End:0x120
            if(m_bInitOpen)
            {
                m_bInitOpen = false;
                // End:0xF2
                if(((m_EventProductList.Length == 0) && m_MainGoodProductList.Length == 0) && m_MainStarProductList.Length == 0)
                {
                    TabCategory.SetTopOrder(1, false);
                    OnTabCategory(TabCategory.GetTopIndex(), false);                    
                }
                else
                {
                    // End:0x107
                    if(m_iCurrentTab == 0)
                    {
                        OnTabMain(false);                        
                    }
                    else
                    {
                        OnTabCategory(TabCategory.GetTopIndex(), false);
                    }
                }                
            }
            else
            {
                // End:0x135
                if(m_iCurrentTab == 0)
                {
                    OnTabMain(false);                    
                }
                else
                {
                    OnTabCategory(TabCategory.GetTopIndex(), false);
                }
            }
            // End:0x2A1
            break;
        // End:0x16F
        case 9014:
            m_CashShopAPI.SetBasketProductItemData();
            UpdateCurrentBasketViewProductList(false);
            // End:0x2A1
            break;
        // End:0x1A0
        case 9050:
            ParseINT64(param, "GamePoint", iGamePoint);
            SetGamePoint(iGamePoint);
            // End:0x2A1
            break;
        // End:0x1C9
        case 9070:
            m_CashShopAPI.SetOpenBuyWnd(true);
            m_bInConfirm = true;
            HandleToggleWindow();
            // End:0x2A1
            break;
        // End:0x1F8
        case 9071:
            m_CashShopAPI.SetOpenBuyWnd(false);
            m_bInConfirm = false;
            clearItemInfo();
            HandleToggleWindow();
            // End:0x2A1
            break;
        // End:0x221
        case 9072:
            m_CashShopAPI.SetOpenBuyWnd(true);
            m_bInConfirm = true;
            HandleToggleWindow();
            // End:0x2A1
            break;
        // End:0x250
        case 9073:
            m_CashShopAPI.SetOpenBuyWnd(false);
            m_bInConfirm = false;
            clearItemInfo();
            HandleToggleWindow();
            // End:0x2A1
            break;
        // End:0x27B
        case 9034:
            ParseInt(param, "ID", iResult);
            UpdateBasketViewProductList(iResult, false);
            // End:0x2A1
            break;
        // End:0x28D
        case 9035:
            UpdateCurrentBasketViewProductList(true);
            // End:0x2A1
            break;
        // End:0x29E
        case 1710:
            HandleDialogOK();
            // End:0x2A1
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
            // End:0x1A8
            break;
        // End:0x109
        case "BtnPresent":
            Debug("OnClickButtonWithHandle BtnPresent" $ string(SelectedProductID));
            m_CashShopAPI.OnBtnPresentClick(SelectedProductID);
            // End:0x1A8
            break;
        // End:0x15C
        case "BtnBasket":
            Debug("OnClickButtonWithHandle BtnBasket" $ string(SelectedProductID));
            OnBtnBasketClick(a_ButtonHandle, SelectedProductID);
            // End:0x1A8
            break;
        // End:0x1A2
        case "BtnGo":
            OnBtnGoClick(SelectedProductID);
            Debug("OnClickButtonWithHandle BtnGo" $ string(SelectedProductID));
            // End:0x1A8
            break;
        // End:0xFFFF
        default:
            // End:0x1A8
            break;
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x31
        case "BtnItemSearch":
            OnBtnItemSearchClick(EditItemSearch.GetString());
            // End:0x4EC
            break;
        // End:0x51
        case "BtnItemIndexSort":
            OnBtnItemSortClick(0);
            // End:0x4EC
            break;
        // End:0x71
        case "BtnItemPointSort":
            OnBtnItemSortClick(1);
            // End:0x4EC
            break;
        // End:0x90
        case "BtnItemNameSort":
            OnBtnItemSortClick(2);
            // End:0x4EC
            break;
        // End:0xAB
        case "BtnCashCharge":
            OnBtnCashChargeClick();
            // End:0x4EC
            break;
        // End:0xC2
        case "BtnMyShop":
            OnMyShopButton();
            // End:0x4EC
            break;
        // End:0x122
        case "BtnViewPreEnd":
            // End:0x10A
            if(m_nCurrentTabPage > 1)
            {
                m_nCurrentTabPage = 1;
                SetViewProductList();
                ScrollItemInfo.SetScrollPosition(500 * (m_nCurrentTabPage - 1));
            }
            Debug("BtnViewPreEnd");
            // End:0x4EC
            break;
        // End:0x183
        case "BtnViewPre":
            // End:0x16E
            if(m_nCurrentTabPage > 1)
            {
                m_nCurrentTabPage = m_nCurrentTabPage - 1;
                SetViewProductList();
                ScrollItemInfo.SetScrollPosition(500 * (m_nCurrentTabPage - 1));
            }
            Debug("BtnViewPre");
            // End:0x4EC
            break;
        // End:0x1EA
        case "BtnViewNext":
            // End:0x1D4
            if(m_nCurrentTabPage < m_iCurrentTabTotalPage)
            {
                m_nCurrentTabPage = m_nCurrentTabPage + 1;
                SetViewProductList();
                ScrollItemInfo.SetScrollPosition(500 * (m_nCurrentTabPage - 1));
            }
            Debug("BtnViewNext");
            // End:0x4EC
            break;
        // End:0x254
        case "BtnViewNextEnd":
            // End:0x23B
            if(m_nCurrentTabPage != m_iCurrentTabTotalPage)
            {
                m_nCurrentTabPage = m_iCurrentTabTotalPage;
                SetViewProductList();
                ScrollItemInfo.SetScrollPosition(500 * (m_nCurrentTabPage - 1));
            }
            Debug("BtnViewNextEnd");
            // End:0x4EC
            break;
        // End:0x295
        case "BtnEventPre":
            SetMainEventViewProductList(false);
            Me.KillTimer(1410);
            Debug("BtnEventPre");
            // End:0x4EC
            break;
        // End:0x2D8
        case "BtnEventNext":
            SetMainEventViewProductList(true);
            Me.KillTimer(1410);
            Debug("BtnEventNext");
            // End:0x4EC
            break;
        // End:0x31B
        case "BtnGoodPre":
            // End:0x306
            if(m_nMainGoodTabPage > 1)
            {
                m_nMainGoodTabPage = m_nMainGoodTabPage - 1;
                SetMainGoodViewProductList();
            }
            Debug("BtnGoodPre");
            // End:0x4EC
            break;
        // End:0x364
        case "BtnGoodNext":
            // End:0x34E
            if(m_nMainGoodTabPage < m_iMainGoodTabTotalPage)
            {
                m_nMainGoodTabPage = m_nMainGoodTabPage + 1;
                SetMainGoodViewProductList();
            }
            Debug("BtnGoodNext");
            // End:0x4EC
            break;
        // End:0x3A7
        case "BtnStarPre":
            // End:0x392
            if(m_nMainStarTabPage > 1)
            {
                m_nMainStarTabPage = m_nMainStarTabPage - 1;
                SetMainStarViewProductList();
            }
            Debug("BtnStarPre");
            // End:0x4EC
            break;
        // End:0x3F0
        case "BtnStarNext":
            // End:0x3DA
            if(m_nMainStarTabPage < m_iMainStarTabTotalPage)
            {
                m_nMainStarTabPage = m_nMainStarTabPage + 1;
                SetMainStarViewProductList();
            }
            Debug("BtnStarNext");
            // End:0x4EC
            break;
        // End:0x413
        case "TabCategory0":
            OnTabMain(true);
            m_bSetFocusChange = true;
            // End:0x4EC
            break;
        // End:0x424
        case "TabCategory1":
        // End:0x435
        case "TabCategory2":
        // End:0x446
        case "TabCategory3":
        // End:0x457
        case "TabCategory4":
        // End:0x468
        case "TabCategory5":
        // End:0x479
        case "TabCategory6":
        // End:0x48A
        case "TabCategory7":
        // End:0x4E6
        case "TabCategory8":
            // End:0x4B7
            if(m_ViewProductInfo.Length <= TabCategory.GetTopIndex())
            {
                return;
            }
            m_nCurrentTabPage = 1;
            m_iCurrentTabTotalPage = 1;
            OnTabCategory(TabCategory.GetTopIndex(), true);
            m_bSetFocusChange = true;
            // End:0x4EC
            break;
        // End:0xFFFF
        default:
            // End:0x4EC
            break;
            break;
    }
    return;
}

function SetBoolMyShop(bool B)
{
    bOpenMyShopReceiverWnd = B;
    // End:0x28
    if(bOpenMyShopReceiverWnd == false)
    {
        BR_MyShopWnd.HideWindow();
    }
    return;
}

function OnMyShopButton()
{
    local BR_MyShopWnd script;

    bOpenMyShopReceiverWnd = !bOpenMyShopReceiverWnd;
    Debug("OnReceiverMyShopButton OpenMyShopWnd" $ string(bOpenMyShopReceiverWnd));
    // End:0x8E
    if(bOpenMyShopReceiverWnd)
    {
        script = BR_MyShopWnd(GetScript("BR_MyShopWnd"));
        script.selectedInit();
        BR_MyShopWnd.ShowWindow();        
    }
    else
    {
        BR_MyShopWnd.HideWindow();
    }
    return;
}

function OnHide()
{
    Drawer.KillTimer(2009);
    // End:0x36
    if(IsShowWindow("PopupWnd"))
    {
        Drawer.HideWindow();
    }
    Me.KillTimer(1411);
    return;
}

function SetGamePoint(INT64 iGamePoint)
{
    local string strGamePoint;

    // End:0x45
    if(m_bCoinToMoney)
    {
        strGamePoint = "" $ string((iGamePoint) * m_fCoinMoneyValue);
        strGamePoint = strGamePoint;
        TextCurrentCash.SetText(strGamePoint);        
    }
    else
    {
        strGamePoint = "" $ (iGamePoint);
        strGamePoint = MakeCostString(strGamePoint);
        TextCurrentCash.SetText(strGamePoint);
    }
    return;
}

function ClearItemList(int allclear)
{
    // End:0x46
    if(allclear > 0)
    {
        m_MainGoodProductList.Length = 0;
        m_MainStarProductList.Length = 0;
        m_EventProductList.Length = 0;
        m_nMainGoodTabPage = 1;
        m_iMainGoodTabTotalPage = 1;
        m_nMainStarTabPage = 1;
        m_iMainStarTabTotalPage = 1;
        m_nMainEventTabPage = 1;
    }
    m_CashShopAPI.ClearItemList(allclear);
    m_CurrentProductList.Length = 0;
    return;
}

function clearItemInfo()
{
    EditItemSearch.SetString("");
    return;
}

function HandleToggleWindow()
{
    // End:0x37
    if(m_bInConfirm == false)
    {
        ShowCashShopWnd();
        RequestBR_GamePoint();
        RequestBR_ProductList(0);
        RequestBR_ProductList(2);
        RequestBR_ProductList(1);
        ClearItemList(1);
    }
    return;
}

function HandleDialogOK()
{
    local int Id, Num;
    local WindowHandle m_NewBuyWnd;

    // End:0x91
    if(DialogIsMine())
    {
        Id = DialogGetID();
        Num = int(DialogGetString());
        // End:0x91
        if(Id == 352)
        {
            m_NewBuyWnd = GetWindowHandle("BR_NewBuyingWnd");
            // End:0x70
            if(m_NewBuyWnd.IsShowWindow())
            {
                m_NewBuyWnd.HideWindow();
            }
            // End:0x91
            if(m_hOwnerWnd.IsShowWindow())
            {
                m_hOwnerWnd.HideWindow();
            }
        }
    }
    return;
}

function OnTabMain(bool tabbuttonClieck)
{
    local int TotalPage;

    BR_MainCashShopTab.ShowWindow();
    BR_ViewCashShopTab.HideWindow();
    BtnItemIndexSort.HideWindow();
    BtnItemPointSort.HideWindow();
    BtnItemNameSort.HideWindow();
    m_iCurrentTab = 0;
    TotalPage = int(float(m_MainGoodProductList.Length) % float(3));
    // End:0x89
    if(TotalPage > 0)
    {
        m_iMainGoodTabTotalPage = (m_MainGoodProductList.Length / 3) + 1;        
    }
    else
    {
        m_iMainGoodTabTotalPage = m_MainGoodProductList.Length / 3;
    }
    TotalPage = int(float(m_MainStarProductList.Length) % float(3));
    // End:0xD0
    if(TotalPage > 0)
    {
        m_iMainStarTabTotalPage = (m_MainStarProductList.Length / 3) + 1;        
    }
    else
    {
        m_iMainStarTabTotalPage = m_MainStarProductList.Length / 3;
    }
    // End:0x160
    if(tabbuttonClieck || m_bInitMainRand == false)
    {
        m_bInitMainRand = true;
        m_nMainGoodTabPage = Rand(m_iMainGoodTabTotalPage);
        // End:0x11E
        if(m_nMainGoodTabPage <= 0)
        {
            m_nMainGoodTabPage = 1;
        }
        m_nMainStarTabPage = Rand(m_iMainStarTabTotalPage);
        // End:0x13D
        if(m_nMainStarTabPage <= 0)
        {
            m_nMainStarTabPage = 1;
        }
        m_nMainEventTabPage = Rand(m_EventProductList.Length);
        // End:0x15D
        if(m_nMainEventTabPage <= 0)
        {
            m_nMainEventTabPage = 1;
        }        
    }
    else
    {
        // End:0x17A
        if(m_nMainGoodTabPage > m_iMainStarTabTotalPage)
        {
            m_nMainGoodTabPage = m_iMainStarTabTotalPage;
        }
        // End:0x194
        if(m_nMainStarTabPage > m_iMainStarTabTotalPage)
        {
            m_nMainStarTabPage = m_iMainStarTabTotalPage;
        }
        // End:0x1AF
        if(m_nMainEventTabPage > m_iMainStarTabTotalPage)
        {
            m_nMainEventTabPage = m_EventProductList.Length;
        }
    }
    Debug("m_MainGoodProductList:" $ string(m_MainGoodProductList.Length));
    Debug("m_MainStarProductList:" $ string(m_MainStarProductList.Length));
    Debug("m_EventProductList:" $ string(m_EventProductList.Length));
    SetMainEventViewProductList(false);
    SetMainGoodViewProductList();
    SetMainStarViewProductList();
    Me.KillTimer(1410);
    Me.SetTimer(1410, 10000);
    return;
}

function SetMainEventViewProductList(bool bNext)
{
    local ProductInfo Info;

    // End:0x0E
    if(m_EventProductList.Length <= 0)
    {
        return;
    }
    // End:0x42
    if(bNext)
    {
        // End:0x31
        if(m_nMainEventTabPage >= m_EventProductList.Length)
        {
            m_nMainEventTabPage = 1;            
        }
        else
        {
            m_nMainEventTabPage = m_nMainEventTabPage + 1;
        }        
    }
    else
    {
        // End:0x5C
        if(m_nMainEventTabPage <= 1)
        {
            m_nMainEventTabPage = m_EventProductList.Length;            
        }
        else
        {
            m_nMainEventTabPage = m_nMainEventTabPage - 1;
        }
    }
    Info = m_CashShopAPI.GetProductItem(m_EventProductList[m_nMainEventTabPage - 1]);
    EventPageNum.SetText((("" $ string(m_nMainEventTabPage)) $ "/") $ string(m_EventProductList.Length));
    m_CashShopAPI.SetMainProductWindow(BR_MainCashShopTab_Main, Info);
    return;
}

function SetMainGoodViewProductList()
{
    local int i, j;
    local ProductInfo Info;

    // End:0x0E
    if(m_MainGoodProductList.Length <= 0)
    {
        return;
    }
    j = 0;
    i = (m_nMainGoodTabPage - 1) * 3;
    J0x27:

    // End:0xC6 [Loop If]
    if(i < (m_nMainGoodTabPage * 3))
    {
        BR_MainGoodCashShopTab_Item[j].HideWindow();
        // End:0xB5
        if(i < m_MainGoodProductList.Length)
        {
            Info = m_CashShopAPI.GetProductItem(m_MainGoodProductList[i]);
            m_CashShopAPI.SetViewProductWindow(BR_MainGoodCashShopTab_Item[j], Info, false, true);
            BR_MainGoodCashShopTab_Item[j].ShowWindow();
        }
        j++;
        i++;
        // [Loop Continue]
        goto J0x27;
    }
    GoodPageNum.SetText((("" $ string(m_nMainGoodTabPage)) $ "/") $ string(m_iMainGoodTabTotalPage));
    return;
}

function SetMainStarViewProductList()
{
    local int i, j;
    local ProductInfo Info;

    // End:0x0E
    if(m_MainStarProductList.Length <= 0)
    {
        return;
    }
    j = 0;
    i = (m_nMainStarTabPage - 1) * 3;
    J0x27:

    // End:0xC6 [Loop If]
    if(i < (m_nMainStarTabPage * 3))
    {
        BR_MainStarCashShopTab_Item[j].HideWindow();
        // End:0xB5
        if(i < m_MainStarProductList.Length)
        {
            Info = m_CashShopAPI.GetProductItem(m_MainStarProductList[i]);
            m_CashShopAPI.SetViewProductWindow(BR_MainStarCashShopTab_Item[j], Info, false, true);
            BR_MainStarCashShopTab_Item[j].ShowWindow();
        }
        j++;
        i++;
        // [Loop Continue]
        goto J0x27;
    }
    StarPageNum.SetText((("" $ string(m_nMainStarTabPage)) $ "/") $ string(m_iMainStarTabTotalPage));
    return;
}

function OnTabCategory(int tabindex, bool tabbuttonClieck)
{
    BR_MainCashShopTab.HideWindow();
    BR_ViewCashShopTab.ShowWindow();
    BtnItemIndexSort.ShowWindow();
    BtnItemPointSort.ShowWindow();
    BtnItemNameSort.ShowWindow();
    m_iCurrentTab = tabindex;
    AddFilteredProductListAll(tabbuttonClieck);
    ScrollItemInfo.SetScrollHeight(500 * m_iCurrentTabTotalPage);
    ScrollItemInfo.SetScrollUnit(500, true);
    ScrollItemInfo.SetScrollPosition(500 * (m_nCurrentTabPage - 1));
    return;
}

function OnBtnGoClick(int Id)
{
    local int Index;

    // End:0x0D
    if(Id <= 0)
    {
        return;
    }
    TabCategory.SetTopOrder(m_iAllItemTab, false);
    OnTabCategory(m_iAllItemTab, true);
    ClearItemList(0);
    m_CurrentProductList.Length = 0;
    m_CurrentProductList.Length = m_CurrentProductList.Length + 1;
    Index = m_CurrentProductList.Length - 1;
    m_CurrentProductList[Index] = Id;
    m_nCurrentTabPage = 1;
    m_iCurrentTabTotalPage = 1;
    ScrollItemInfo.SetScrollHeight(500 * m_iCurrentTabTotalPage);
    ScrollItemInfo.SetScrollUnit(500, true);
    SetViewProductList();
    return;
}

function OnBtnItemSearchClick(string strSearch)
{
    local int TotalPage;

    // End:0x14
    if((ItemSearchClick(strSearch, true)) == false)
    {
        return;
    }
    Debug("OnBtnItemSearchClick " $ strSearch);
    TabCategory.SetTopOrder(m_iAllItemTab, false);
    OnTabCategory(m_iAllItemTab, true);
    ItemSearchClick(strSearch, false);
    TotalPage = int(float(m_CurrentProductList.Length) % float(10));
    // End:0x9C
    if(TotalPage > 0)
    {
        m_iCurrentTabTotalPage = (m_CurrentProductList.Length / 10) + 1;        
    }
    else
    {
        m_iCurrentTabTotalPage = m_CurrentProductList.Length / 10;
    }
    m_nCurrentTabPage = 1;
    ScrollItemInfo.SetScrollHeight(500 * m_iCurrentTabTotalPage);
    ScrollItemInfo.SetScrollUnit(500, true);
    SetViewProductList();
    return;
}

function bool ItemSearchClick(string strSearch, bool bCheck)
{
    local int i, Index, searchcount;
    local ProductInfo ProductItem;

    searchcount = 0;
    // End:0x15
    if(strSearch == "")
    {
        return false;
    }
    // End:0x28
    if(bCheck == false)
    {
        ClearItemList(0);
    }
    strSearch = ToLower(strSearch);
    i = 0;
    J0x40:

    // End:0x102 [Loop If]
    if(i < m_CashShopAPI.ProductListCount())
    {
        ProductItem = m_CashShopAPI.ArrayProductItem(i);
        // End:0xF8
        if(InStr(ToLower(ProductItem.strName), strSearch) > -1)
        {
            // End:0xBC
            if(bCheck)
            {
                Debug("ItemSearchClick ok");
                return true;
                // [Explicit Continue]
                goto J0xF8;
            }
            m_CurrentProductList.Length = m_CurrentProductList.Length + 1;
            Index = m_CurrentProductList.Length - 1;
            m_CurrentProductList[Index] = ProductItem.iProductID;
            searchcount++;
        }
        J0xF8:

        i++;
        // [Loop Continue]
        goto J0x40;
    }
    // End:0x132
    if(searchcount > 0)
    {
        Debug("ItemSearchClick ok" $ string(searchcount));
        return true;
    }
    return false;
    return;
}

function OnBtnItemSortClick(BR_NewCashShopWnd.EPrItemSortType eType)
{
    m_bSortDesc = !m_bSortDesc;
    // End:0x3A
    if(int(eType) == int(0))
    {
        m_CashShopAPI.ProductItemSort(0, 0, m_bSortDesc);        
    }
    else
    {
        // End:0x65
        if(int(eType) == int(1))
        {
            m_CashShopAPI.ProductItemSort(0, 1, m_bSortDesc);            
        }
        else
        {
            // End:0x8E
            if(int(eType) == int(2))
            {
                m_CashShopAPI.ProductItemSort(0, 2, m_bSortDesc);
            }
        }
    }
    AddFilteredProductListAll(true);
    return;
}

function OnBtnBasketClick(ButtonHandle a_ButtonHandle, int ProductID)
{
    local string strParam;
    local ProductInfo ProductItem;

    // End:0xF1
    if(ProductID > 0)
    {
        ProductItem = m_CashShopAPI.GetProductItem(ProductID);
        // End:0x76
        if(ProductItem.bMyShopBasketEnable)
        {
            m_CashShopAPI.UpdateBasketProductItem(a_ButtonHandle, ProductID, false);
            ParamAdd(strParam, "ID", string(ProductID));
            ExecuteEvent(9033, strParam);            
        }
        else
        {
            m_CashShopAPI.UpdateBasketProductItem(a_ButtonHandle, ProductID, true);
            DialogSetID(353);
            DialogSetDefaultOK();
            DialogShow(0, 1, MakeFullSystemMsg(GetSystemMessage(6116), ProductItem.strName, ""), string(self));
            ParamAdd(strParam, "ID", string(ProductID));
            ExecuteEvent(9032, strParam);
        }
    }
    return;
}

function OnBtnCashChargeClick()
{
    // End:0x14
    if(m_CashShopAPI.GetOpenBuyWnd())
    {
        return;
    }
    // End:0x26
    if(IsUseSteam())
    {
        CashShopCoinChargeForSteam();        
    }
    else
    {
        ShowCashChargeWebSite();
    }
    RequestBR_GamePoint();
    return;
}

function ShowCashShopWnd()
{
    local WindowHandle m_inventoryWnd;

    // End:0x0F
    if(RequestBr_CashShopCateoryIndex())
    {
        SetTabCategory();
    }
    m_inventoryWnd = GetWindowHandle("InventoryWnd");
    ShowWindow("BR_NewCashShopWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("BR_NewCashShopWnd");
    PlaySound("InterfaceSound.inventory_open_01");
    // End:0xAD
    if(m_inventoryWnd.IsShowWindow())
    {
        m_inventoryWnd.HideWindow();
    }
    m_CashShopAPI.SetOpenBuyWnd(false);
    Me.KillTimer(1411);
    Me.SetTimer(1411, 100);
    return;
}

function bool CheckTabIndex(int Category, int showtab)
{
    local int iCurIndex;

    // End:0x1C
    if(m_ViewProductInfo[m_iCurrentTab].iTabType == 2)
    {
        return true;        
    }
    else
    {
        // End:0xB2
        if(m_ViewProductInfo[m_iCurrentTab].iTabType == 0)
        {
            // End:0x4A
            if(m_ViewProductInfo[m_iCurrentTab].iCategory == 0)
            {
                return true;
            }
            iCurIndex = showtab & m_ViewProductInfo[m_iCurrentTab].iShowTab;
            Debug((("Check : showtab=" $ string(showtab)) $ ", index=") $ string(iCurIndex));
            // End:0xAD
            if(iCurIndex == 0)
            {
                return false;                
            }
            else
            {
                return true;
            }            
        }
        else
        {
            // End:0xE9
            if(m_ViewProductInfo[m_iCurrentTab].iTabType == 1)
            {
                // End:0xE7
                if(m_ViewProductInfo[m_iCurrentTab].iCategory == Category)
                {
                    return true;                    
                }
                else
                {
                    return false;
                }
            }
        }
    }
    return false;
    return;
}

function AddFilteredProductListAll(bool tabbuttonClieck)
{
    local int i, TotalPage;

    ClearItemList(0);
    i = 0;
    J0x0E:

    // End:0x4B [Loop If]
    if(i < m_CashShopAPI.ProductListCount())
    {
        AddFilteredProductCurrenrtList(m_CashShopAPI.ArrayProductItem(i));
        i++;
        // [Loop Continue]
        goto J0x0E;
    }
    TotalPage = int(float(m_CurrentProductList.Length) % float(10));
    // End:0x82
    if(TotalPage > 0)
    {
        m_iCurrentTabTotalPage = (m_CurrentProductList.Length / 10) + 1;        
    }
    else
    {
        m_iCurrentTabTotalPage = m_CurrentProductList.Length / 10;
    }
    // End:0xA2
    if(tabbuttonClieck)
    {
        m_nCurrentTabPage = 1;
    }
    SetViewProductList();
    return;
}

function AddFilteredProductCurrenrtList(ProductInfo Info)
{
    local int Index;

    // End:0x22
    if((CheckTabIndex(Info.iCategory, Info.iShowTab)) == false)
    {
        return;
    }
    m_CurrentProductList.Length = m_CurrentProductList.Length + 1;
    Index = m_CurrentProductList.Length - 1;
    m_CurrentProductList[Index] = Info.iProductID;
    return;
}

function SetViewProductList()
{
    local int i, j;
    local ProductInfo Info;

    j = 0;
    i = (m_nCurrentTabPage - 1) * 10;
    J0x19:

    // End:0xB8 [Loop If]
    if(i < (m_nCurrentTabPage * 10))
    {
        BR_ViewCashShopTab_Item[j].HideWindow();
        // End:0xA7
        if(i < m_CurrentProductList.Length)
        {
            Info = m_CashShopAPI.GetProductItem(m_CurrentProductList[i]);
            m_CashShopAPI.SetViewProductWindow(BR_ViewCashShopTab_Item[j], Info, false, true);
            BR_ViewCashShopTab_Item[j].ShowWindow();
        }
        j++;
        i++;
        // [Loop Continue]
        goto J0x19;
    }
    TextViewPageNum.SetText((("" $ string(m_nCurrentTabPage)) $ "/") $ string(m_iCurrentTabTotalPage));
    m_scrollheight = 0;
    return;
}

function UpdateCurrentBasketViewProductList(bool AllDelete)
{
    local int i;
    local ProductInfo Info;
    local ButtonHandle childBtnBasket;

    i = 0;
    J0x07:

    // End:0xDD [Loop If]
    if(i < m_CurrentProductList.Length)
    {
        // End:0x63
        if(AllDelete)
        {
            childBtnBasket = ButtonHandle(BR_ViewCashShopTab_Item[i].GetChildWindow("BtnBasket"));
            m_CashShopAPI.UpdateBasketProductWindow(childBtnBasket, false);
            // [Explicit Continue]
            goto J0xD3;
        }
        Info = m_CashShopAPI.GetBasketProductItem(m_CurrentProductList[i]);
        // End:0xD3
        if(Info.iProductID > 0)
        {
            childBtnBasket = ButtonHandle(BR_ViewCashShopTab_Item[i].GetChildWindow("BtnBasket"));
            m_CashShopAPI.UpdateBasketProductWindow(childBtnBasket, true);
        }
        J0xD3:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0xEB
    if(m_MainGoodProductList.Length <= 0)
    {
        return;
    }
    i = 0;
    J0xF2:

    // End:0x1C4 [Loop If]
    if(i < 3)
    {
        // End:0x14A
        if(AllDelete)
        {
            childBtnBasket = ButtonHandle(BR_MainGoodCashShopTab_Item[i].GetChildWindow("BtnBasket"));
            m_CashShopAPI.UpdateBasketProductWindow(childBtnBasket, false);
            // [Explicit Continue]
            goto J0x1BA;
        }
        Info = m_CashShopAPI.GetBasketProductItem(m_MainGoodProductList[i]);
        // End:0x1BA
        if(Info.iProductID > 0)
        {
            childBtnBasket = ButtonHandle(BR_MainGoodCashShopTab_Item[i].GetChildWindow("BtnBasket"));
            m_CashShopAPI.UpdateBasketProductWindow(childBtnBasket, true);
        }
        J0x1BA:

        i++;
        // [Loop Continue]
        goto J0xF2;
    }
    // End:0x1D2
    if(m_MainStarProductList.Length <= 0)
    {
        return;
    }
    i = 0;
    J0x1D9:

    // End:0x2AB [Loop If]
    if(i < 3)
    {
        // End:0x231
        if(AllDelete)
        {
            childBtnBasket = ButtonHandle(BR_MainStarCashShopTab_Item[i].GetChildWindow("BtnBasket"));
            m_CashShopAPI.UpdateBasketProductWindow(childBtnBasket, false);
            // [Explicit Continue]
            goto J0x2A1;
        }
        Info = m_CashShopAPI.GetBasketProductItem(m_MainStarProductList[i]);
        // End:0x2A1
        if(Info.iProductID > 0)
        {
            childBtnBasket = ButtonHandle(BR_MainStarCashShopTab_Item[i].GetChildWindow("BtnBasket"));
            m_CashShopAPI.UpdateBasketProductWindow(childBtnBasket, true);
        }
        J0x2A1:

        i++;
        // [Loop Continue]
        goto J0x1D9;
    }
    return;
}

function UpdateBasketViewProductList(int ProductID, bool BasketCheck)
{
    local int i;
    local bool succ;
    local ButtonHandle childBtnBasket;

    // End:0x163
    if(m_iCurrentTab == 0)
    {
        // End:0x19
        if(m_MainGoodProductList.Length <= 0)
        {
            return;
        }
        i = 0;
        J0x20:

        // End:0xB6 [Loop If]
        if(i < 3)
        {
            childBtnBasket = ButtonHandle(BR_MainGoodCashShopTab_Item[i].GetChildWindow("BtnBasket"));
            // End:0x7A
            if(ProductID == 0)
            {
                m_CashShopAPI.UpdateBasketProductWindow(childBtnBasket, false);
                // [Explicit Continue]
                goto J0xAC;
            }
            succ = m_CashShopAPI.UpdateBasketProductItem(childBtnBasket, ProductID, BasketCheck);
            // End:0xAC
            if(succ)
            {
                // [Explicit Break]
                goto J0xB6;
            }
            J0xAC:

            i++;
            // [Loop Continue]
            goto J0x20;
        }
        J0xB6:

        // End:0xC4
        if(m_MainStarProductList.Length <= 0)
        {
            return;
        }
        i = 0;
        J0xCB:

        // End:0x160 [Loop If]
        if(i < 3)
        {
            childBtnBasket = ButtonHandle(BR_MainStarCashShopTab_Item[i].GetChildWindow("BtnBasket"));
            // End:0x125
            if(ProductID == 0)
            {
                m_CashShopAPI.UpdateBasketProductWindow(childBtnBasket, false);
                // [Explicit Continue]
                goto J0x156;
            }
            succ = m_CashShopAPI.UpdateBasketProductItem(childBtnBasket, ProductID, BasketCheck);
            // End:0x156
            if(succ)
            {
                return;
            }
            J0x156:

            i++;
            // [Loop Continue]
            goto J0xCB;
        }        
    }
    else
    {
        i = 0;
        J0x16A:

        // End:0x1FF [Loop If]
        if(i < 10)
        {
            childBtnBasket = ButtonHandle(BR_ViewCashShopTab_Item[i].GetChildWindow("BtnBasket"));
            // End:0x1C4
            if(ProductID == 0)
            {
                m_CashShopAPI.UpdateBasketProductWindow(childBtnBasket, false);
                // [Explicit Continue]
                goto J0x1F5;
            }
            succ = m_CashShopAPI.UpdateBasketProductItem(childBtnBasket, ProductID, BasketCheck);
            // End:0x1F5
            if(succ)
            {
                return;
            }
            J0x1F5:

            i++;
            // [Loop Continue]
            goto J0x16A;
        }
    }
    return;
}

function AddMainProductItem()
{
    local int i, flag, iMainGoodCurrentIndex, iMainStarCurrentIndex, iEventCurrentIndex;

    local ProductInfo ProductItem;

    m_EventProductList.Length = 0;
    m_MainGoodProductList.Length = 0;
    m_MainStarProductList.Length = 0;
    i = 0;
    J0x1F:

    // End:0x205 [Loop If]
    if(i < m_CashShopAPI.ProductListCount())
    {
        ProductItem = m_CashShopAPI.ArrayProductItem(i);
        flag = ProductItem.iShowTab & 1;
        Debug("AddMainProductItem PRODUCT_TAB_ADVERTISING flag" $ string(flag));
        // End:0xE1
        if(flag > 0)
        {
            iEventCurrentIndex = m_EventProductList.Length;
            m_EventProductList.Length = iEventCurrentIndex + 1;
            m_EventProductList[iEventCurrentIndex] = ProductItem.iProductID;
        }
        flag = ProductItem.iShowTab & 2;
        Debug("AddMainProductItem PRODUCT_TAB_RECOMMEND flag" $ string(flag));
        // End:0x16F
        if(flag > 0)
        {
            iMainGoodCurrentIndex = m_MainGoodProductList.Length;
            m_MainGoodProductList.Length = iMainGoodCurrentIndex + 1;
            m_MainGoodProductList[iMainGoodCurrentIndex] = ProductItem.iProductID;
        }
        flag = ProductItem.iShowTab & 4;
        Debug("AddMainProductItem PRODUCT_TAB_POPULAR flag" $ string(flag));
        // End:0x1FB
        if(flag > 0)
        {
            iMainStarCurrentIndex = m_MainStarProductList.Length;
            m_MainStarProductList.Length = iMainStarCurrentIndex + 1;
            m_MainStarProductList[iMainStarCurrentIndex] = ProductItem.iProductID;
        }
        i++;
        // [Loop Continue]
        goto J0x1F;
    }
    return;
}

function OnTimer(int TimerID)
{
    local int Height;

    // End:0x48
    if(m_bInitHandle && m_bSetFocusChange)
    {
        // End:0x31
        if(m_iCurrentTab == 0)
        {
            BR_MainCashShopTab.SetFocus();            
        }
        else
        {
            BR_ViewCashShopTab.SetFocus();
        }
        m_bSetFocusChange = false;
    }
    // End:0x61
    if(TimerID == 1410)
    {
        SetMainEventViewProductList(true);        
    }
    else
    {
        // End:0x137
        if(TimerID == 1411)
        {
            Height = ScrollItemInfo.GetScrollHeight() / 495;
            Debug("scrollheight" $ string(Height));
            // End:0x137
            if((Height + 1) != m_nCurrentTabPage)
            {
                // End:0x106
                if((Height + 1) > m_nCurrentTabPage)
                {
                    // End:0xF0
                    if(m_nCurrentTabPage < m_iCurrentTabTotalPage)
                    {
                        m_nCurrentTabPage = m_nCurrentTabPage + 1;
                        SetViewProductList();
                    }
                    Debug("BtnViewNext");                    
                }
                else
                {
                    // End:0x125
                    if(m_nCurrentTabPage > 1)
                    {
                        m_nCurrentTabPage = m_nCurrentTabPage - 1;
                        SetViewProductList();
                    }
                    Debug("BtnViewPre");
                }
            }
        }
    }
    return;
}
