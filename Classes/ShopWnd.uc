class ShopWnd extends UICommonAPI;

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const DIALOG_PREVIEW = 333;
const REFUND_ITEM = 444;

enum ShopType
{
    ShopNone,                       // 0
    ShopBuy,                        // 1
    ShopSell,                       // 2
    ShopPreview,                    // 3
    ShopRefund                      // 4
};

var int m_merchantID;
var int m_NpcID;
var bool m_isCompleteTransaction;
var INT64 m_currentPrice;
var INT64 m_UserAdena;
var string m_WindowName;
var int m_maxInventoryCount;
var int m_curInventoryCount;
var int m_numPossibleSlotCount;
var ShopWnd.ShopType m_LastShopType;
var ShopWnd.ShopType m_shopType;
var WindowHandle Me;
var TabHandle m_TransactionTabHandle;
var TabHandle m_PreviewTabHandle;
var ItemWindowHandle m_BuyTopListHandle;
var ItemWindowHandle m_SellTopListHandle;
var ItemWindowHandle m_RefundTopListHandle;
var ItemWindowHandle m_BuyBottomListHandle;
var ItemWindowHandle m_SellBottomListHandle;
var ItemWindowHandle m_RefundBottomListHandle;
var ItemWindowHandle m_PreviewTopListHandle;
var ItemWindowHandle m_PreviewBottomListHandle;
var TextureHandle m_TexTransactionBGLine;
var TextureHandle m_TexPreviewBGLine;
var TextureHandle m_TexRefundSlotBG;
var TextureHandle m_TexBuySellSlotBG;
var TextureHandle m_TexPreviewSlotBG;
var TextBoxHandle m_PriceConstTextBoxHandle;
var TextBoxHandle m_PriceTextBoxHandle;
var TextBoxHandle m_AdenaTextBoxHandle;
var TextBoxHandle m_BottomTextBoxHandle;
var TextBoxHandle m_TopTextBoxHandle;
var TextBoxHandle m_ShopWndItemCountHandle;
var ButtonHandle m_OkButtonHandle;
var ButtonHandle m_CancelButtonHandle;
var WindowHandle m_itemEnchantWndHandle;
var ItemEnchantWnd m_itemEnchantWndScript;

function OnRegisterEvent()
{
    RegisterEvent(2080);
    RegisterEvent(2090);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(2081);
    RegisterEvent(2070);
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle(getCurrentWindowName(string(self))));
    return;
}

function OnLButtonUp(WindowHandle a_WindowHandle, int nX, int nY)
{
    // End:0x97
    if(GetWindowHandle("InventoryViewer").IsShowWindow())
    {
        GetWindowHandle("InventoryViewer").SetFocus();
        GetWindowHandle(getCurrentWindowName(string(self))).SetFocus();
        // End:0x97
        if(GetWindowHandle("DialogBox").IsShowWindow())
        {
            GetWindowHandle("DialogBox").SetFocus();
        }
    }
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    OnRegisterEvent();
    Me = GetWindowHandle("ShopWnd");
    m_TransactionTabHandle = GetTabHandle("ShopWnd.TransactionSelectTab");
    m_PreviewTabHandle = GetTabHandle("ShopWnd.PreviewSelectTab");
    m_BuyTopListHandle = GetItemWindowHandle("ShopWnd.BuyTopList");
    m_SellTopListHandle = GetItemWindowHandle("ShopWnd.SellTopList");
    m_RefundTopListHandle = GetItemWindowHandle("ShopWnd.RefundTopList");
    m_BuyTopListHandle.SetTooltipType("InventoryPrice1HideEnchantStackable");
    m_SellTopListHandle.SetTooltipType("InventoryPrice2");
    m_RefundTopListHandle.SetTooltipType("InventoryPrice1");
    m_BuyBottomListHandle = GetItemWindowHandle("ShopWnd.BuyBottomList");
    m_SellBottomListHandle = GetItemWindowHandle("ShopWnd.SellBottomList");
    m_RefundBottomListHandle = GetItemWindowHandle("ShopWnd.RefundBottomList");
    m_BuyBottomListHandle.SetTooltipType("InventoryStackableUnitPrice");
    m_SellBottomListHandle.SetTooltipType("InventoryStackableUnitPrice");
    m_RefundBottomListHandle.SetTooltipType("InventoryPrice1");
    m_PreviewTopListHandle = GetItemWindowHandle("ShopWnd.PreviewTopList");
    m_PreviewBottomListHandle = GetItemWindowHandle("ShopWnd.PreviewBottomList");
    m_TexTransactionBGLine = GetTextureHandle("ShopWnd.TransactionSelectTabBgLine");
    m_TexPreviewBGLine = GetTextureHandle("ShopWnd.Sell_TexTabBgLine");
    m_TexRefundSlotBG = GetTextureHandle("ShopWnd.RefundItemListBg");
    m_TexBuySellSlotBG = GetTextureHandle("ShopWnd.Buy_TopSlotListBg");
    m_TexPreviewSlotBG = GetTextureHandle("ShopWnd.Sell_TopSlotListBg");
    m_PriceConstTextBoxHandle = GetTextBoxHandle("ShopWnd.PriceConstText");
    m_PriceTextBoxHandle = GetTextBoxHandle("ShopWnd.PriceText");
    m_AdenaTextBoxHandle = GetTextBoxHandle("ShopWnd.AdenaText");
    m_BottomTextBoxHandle = GetTextBoxHandle("ShopWnd.BottomText");
    m_TopTextBoxHandle = GetTextBoxHandle("ShopWnd.TopText");
    m_ShopWndItemCountHandle = GetTextBoxHandle("ShopWnd.ItemCount");
    m_OkButtonHandle = GetButtonHandle("ShopWnd.OKButton");
    m_CancelButtonHandle = GetButtonHandle("ShopWnd.CancelButton");
    m_isCompleteTransaction = false;
    m_LastShopType = 0;
    m_itemEnchantWndHandle = GetWindowHandle("ItemEnchantWnd");
    m_itemEnchantWndScript = ItemEnchantWnd(GetScript("ItemEnchantWnd"));
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 2080:
            HandleOpenWindow(param);
            // End:0x8F
            break;
        // End:0x33
        case 2090:
            HandleAddItem(param);
            // End:0x8F
            break;
        // End:0x4B
        case 1710:
            setEnableWindow(true);
            HandleDialogOK();
            // End:0x8F
            break;
        // End:0x5D
        case 1720:
            setEnableWindow(true);
            // End:0x8F
            break;
        // End:0x73
        case 2081:
            HandleEndTransactionList(param);
            // End:0x8F
            break;
        // End:0x89
        case 2070:
            HandleSetMaxCount(param);
            // End:0x8F
            break;
        // End:0xFFFF
        default:
            // End:0x8F
            break;
            break;
    }
    return;
}

function OnClickButton(string ControlName)
{
    local int Index, bottomIndex, topIndex;
    local ItemInfo deleteItemInfo, addItemInfo;

    // End:0xB0
    if(ControlName == "UpButton")
    {
        // End:0x3C
        if(int(m_shopType) == int(1))
        {
            Index = m_BuyBottomListHandle.GetSelectedNum();            
        }
        else
        {
            // End:0x64
            if(int(m_shopType) == int(2))
            {
                Index = m_SellBottomListHandle.GetSelectedNum();                
            }
            else
            {
                // End:0x8C
                if(int(m_shopType) == int(4))
                {
                    Index = m_RefundBottomListHandle.GetSelectedNum();                    
                }
                else
                {
                    Index = m_PreviewBottomListHandle.GetSelectedNum();
                }
            }
        }
        MoveItemBottomToTop(Index, false);        
    }
    else
    {
        // End:0x162
        if(ControlName == "DownButton")
        {
            // End:0xEE
            if(int(m_shopType) == int(1))
            {
                Index = m_BuyTopListHandle.GetSelectedNum();                
            }
            else
            {
                // End:0x116
                if(int(m_shopType) == int(2))
                {
                    Index = m_SellTopListHandle.GetSelectedNum();                    
                }
                else
                {
                    // End:0x13E
                    if(int(m_shopType) == int(4))
                    {
                        Index = m_RefundTopListHandle.GetSelectedNum();                        
                    }
                    else
                    {
                        Index = m_PreviewTopListHandle.GetSelectedNum();
                    }
                }
            }
            MoveItemTopToBottom(Index, false);            
        }
        else
        {
            // End:0x1A2
            if(ControlName == "OKButton")
            {
                setEnableWindow(true);
                HandleOKButton();
                Debug("--OKButton" @ string(m_isCompleteTransaction));                
            }
            else
            {
                // End:0x1CF
                if(ControlName == "CancelButton")
                {
                    setEnableWindow(true);
                    HideWindow(m_WindowName);                    
                }
                else
                {
                    // End:0x54B
                    if(ControlName == "TransactionSelectTab0")
                    {
                        Debug("TransactionSelectTab0");
                        // End:0x222
                        if(int(m_shopType) == int(1))
                        {
                            return;                            
                        }
                        else
                        {
                            // End:0x366
                            if(int(m_shopType) == int(2))
                            {
                                bottomIndex = m_SellBottomListHandle.GetItemNum();
                                // End:0x33F
                                if(bottomIndex != 0)
                                {
                                    Index = 0;
                                    J0x259:

                                    // End:0x33F [Loop If]
                                    if(Index < bottomIndex)
                                    {
                                        m_SellBottomListHandle.GetItem(Index, deleteItemInfo);
                                        // End:0x321
                                        if(IsStackableItem(deleteItemInfo.ConsumeType))
                                        {
                                            topIndex = m_SellTopListHandle.FindItem(deleteItemInfo.Id);
                                            m_SellTopListHandle.GetItem(topIndex, addItemInfo);
                                            // End:0x30A
                                            if(topIndex >= 0)
                                            {
                                                __NFUN_406__(addItemInfo.ItemNum, deleteItemInfo.ItemNum);
                                                m_SellTopListHandle.SetItem(topIndex, addItemInfo);                                                
                                            }
                                            else
                                            {
                                                m_SellTopListHandle.AddItem(deleteItemInfo);
                                            }
                                            // [Explicit Continue]
                                            goto J0x335;
                                        }
                                        m_SellTopListHandle.AddItem(deleteItemInfo);
                                        J0x335:

                                        ++Index;
                                        // [Loop Continue]
                                        goto J0x259;
                                    }
                                }
                                Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName $ ".InvenWeight");                                
                            }
                            else
                            {
                                // End:0x407
                                if(int(m_shopType) == int(4))
                                {
                                    bottomIndex = m_RefundBottomListHandle.GetItemNum();
                                    // End:0x3E3
                                    if(bottomIndex != 0)
                                    {
                                        Index = 0;
                                        J0x39D:

                                        // End:0x3E3 [Loop If]
                                        if(Index < bottomIndex)
                                        {
                                            m_RefundBottomListHandle.GetItem(Index, deleteItemInfo);
                                            m_RefundTopListHandle.AddItem(deleteItemInfo);
                                            ++Index;
                                            // [Loop Continue]
                                            goto J0x39D;
                                        }
                                    }
                                    Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName $ ".InvenWeight");
                                }
                            }
                        }
                        m_currentPrice = (0);
                        m_SellBottomListHandle.Clear();
                        m_RefundBottomListHandle.Clear();
                        m_PriceTextBoxHandle.SetText("0");
                        m_PriceTextBoxHandle.SetTooltipString("");
                        m_TexBuySellSlotBG.ShowWindow();
                        m_TexPreviewSlotBG.HideWindow();
                        m_TexRefundSlotBG.HideWindow();
                        m_BuyTopListHandle.ShowWindow();
                        m_SellTopListHandle.HideWindow();
                        m_RefundTopListHandle.HideWindow();
                        m_BuyBottomListHandle.ShowWindow();
                        m_SellBottomListHandle.HideWindow();
                        m_RefundBottomListHandle.HideWindow();
                        m_OkButtonHandle.SetNameText(GetSystemString(1434));
                        m_BottomTextBoxHandle.SetText(GetSystemString(139));
                        m_PriceConstTextBoxHandle.SetText(GetSystemString(142));
                        m_TopTextBoxHandle.SetText(GetSystemString(2323));
                        m_shopType = 1;
                        UpdateItemCount();                        
                    }
                    else
                    {
                        // End:0x849
                        if(ControlName == "TransactionSelectTab1")
                        {
                            // End:0x581
                            if(int(m_shopType) == int(2))
                            {
                                return;                                
                            }
                            else
                            {
                                // End:0x63D
                                if(int(m_shopType) == int(1))
                                {
                                    bottomIndex = m_BuyBottomListHandle.GetItemNum();
                                    // End:0x5EA
                                    if(bottomIndex != 0)
                                    {
                                        Index = 0;
                                        J0x5B8:

                                        // End:0x5EA [Loop If]
                                        if(Index < bottomIndex)
                                        {
                                            m_BuyBottomListHandle.GetItem(Index, deleteItemInfo);
                                            ++Index;
                                            // [Loop Continue]
                                            goto J0x5B8;
                                        }
                                    }
                                    m_TopTextBoxHandle.SetText(GetSystemString(138));
                                    getInstanceL2Util().SortItem(m_SellTopListHandle);
                                    Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName $ ".InvenWeight");                                    
                                }
                                else
                                {
                                    // End:0x708
                                    if(int(m_shopType) == int(4))
                                    {
                                        bottomIndex = m_RefundBottomListHandle.GetItemNum();
                                        // End:0x6BA
                                        if(bottomIndex != 0)
                                        {
                                            Index = 0;
                                            J0x674:

                                            // End:0x6BA [Loop If]
                                            if(Index < bottomIndex)
                                            {
                                                m_RefundBottomListHandle.GetItem(Index, deleteItemInfo);
                                                m_RefundTopListHandle.AddItem(deleteItemInfo);
                                                ++Index;
                                                // [Loop Continue]
                                                goto J0x674;
                                            }
                                        }
                                        getInstanceL2Util().SortItem(m_SellTopListHandle);
                                        getInstanceL2Util().SortItem(m_RefundTopListHandle);
                                        Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName $ ".InvenWeight");
                                    }
                                }
                            }
                            m_TopTextBoxHandle.SetText(GetSystemString(138));
                            m_currentPrice = (0);
                            m_BuyBottomListHandle.Clear();
                            m_RefundBottomListHandle.Clear();
                            m_PriceTextBoxHandle.SetText("0");
                            m_PriceTextBoxHandle.SetTooltipString("");
                            m_TexBuySellSlotBG.ShowWindow();
                            m_TexPreviewSlotBG.HideWindow();
                            m_TexRefundSlotBG.HideWindow();
                            m_BuyTopListHandle.HideWindow();
                            m_SellTopListHandle.ShowWindow();
                            m_RefundTopListHandle.HideWindow();
                            m_BuyBottomListHandle.HideWindow();
                            m_SellBottomListHandle.ShowWindow();
                            m_RefundBottomListHandle.HideWindow();
                            m_OkButtonHandle.SetNameText(GetSystemString(1157));
                            m_BottomTextBoxHandle.SetText(GetSystemString(137));
                            m_PriceConstTextBoxHandle.SetText(GetSystemString(143));
                            m_shopType = 2;
                            UpdateItemCount();                            
                        }
                        else
                        {
                            // End:0xB9A
                            if(ControlName == "TransactionSelectTab2")
                            {
                                // End:0x87F
                                if(int(m_shopType) == int(4))
                                {
                                    return;                                    
                                }
                                else
                                {
                                    // End:0x9C3
                                    if(int(m_shopType) == int(2))
                                    {
                                        bottomIndex = m_SellBottomListHandle.GetItemNum();
                                        // End:0x99C
                                        if(bottomIndex != 0)
                                        {
                                            Index = 0;
                                            J0x8B6:

                                            // End:0x99C [Loop If]
                                            if(Index < bottomIndex)
                                            {
                                                m_SellBottomListHandle.GetItem(Index, deleteItemInfo);
                                                // End:0x97E
                                                if(IsStackableItem(deleteItemInfo.ConsumeType))
                                                {
                                                    topIndex = m_SellTopListHandle.FindItem(deleteItemInfo.Id);
                                                    m_SellTopListHandle.GetItem(topIndex, addItemInfo);
                                                    // End:0x967
                                                    if(topIndex >= 0)
                                                    {
                                                        __NFUN_406__(addItemInfo.ItemNum, deleteItemInfo.ItemNum);
                                                        m_SellTopListHandle.SetItem(topIndex, addItemInfo);                                                        
                                                    }
                                                    else
                                                    {
                                                        m_SellTopListHandle.AddItem(deleteItemInfo);
                                                    }
                                                    // [Explicit Continue]
                                                    goto J0x992;
                                                }
                                                m_SellTopListHandle.AddItem(deleteItemInfo);
                                                J0x992:

                                                ++Index;
                                                // [Loop Continue]
                                                goto J0x8B6;
                                            }
                                        }
                                        Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName $ ".InvenWeight");                                        
                                    }
                                    else
                                    {
                                        // End:0xA50
                                        if(int(m_shopType) == int(1))
                                        {
                                            bottomIndex = m_BuyBottomListHandle.GetItemNum();
                                            // End:0xA2C
                                            if(bottomIndex != 0)
                                            {
                                                Index = 0;
                                                J0x9FA:

                                                // End:0xA2C [Loop If]
                                                if(Index < bottomIndex)
                                                {
                                                    m_BuyBottomListHandle.GetItem(Index, deleteItemInfo);
                                                    ++Index;
                                                    // [Loop Continue]
                                                    goto J0x9FA;
                                                }
                                            }
                                            Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName $ ".InvenWeight");
                                        }
                                    }
                                }
                                m_currentPrice = (0);
                                m_BuyBottomListHandle.Clear();
                                m_SellBottomListHandle.Clear();
                                m_PriceTextBoxHandle.SetText("0");
                                m_PriceTextBoxHandle.SetTooltipString("");
                                m_TexBuySellSlotBG.HideWindow();
                                m_TexPreviewSlotBG.HideWindow();
                                m_TexRefundSlotBG.ShowWindow();
                                m_BuyTopListHandle.HideWindow();
                                m_SellTopListHandle.HideWindow();
                                m_RefundTopListHandle.ShowWindow();
                                m_BuyBottomListHandle.HideWindow();
                                m_SellBottomListHandle.HideWindow();
                                m_RefundBottomListHandle.ShowWindow();
                                m_OkButtonHandle.SetNameText(GetSystemString(2028));
                                m_BottomTextBoxHandle.SetText(GetSystemString(2205));
                                m_PriceConstTextBoxHandle.SetText(GetSystemString(2206));
                                m_TopTextBoxHandle.SetText(GetSystemString(2324));
                                m_shopType = 4;
                                UpdateItemCount();                                
                            }
                            else
                            {
                                // End:0xBE0
                                if(ControlName == "InventoryViewerCall_Button")
                                {
                                    getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle(getCurrentWindowName(string(self))), true);
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

function OnDBClickItem(string ControlName, int Index)
{
    local ItemInfo Info;

    // End:0x11C
    if((((ControlName == "BuyTopList") || ControlName == "RefundTopList") || ControlName == "SellTopList") || ControlName == "PreviewTopList")
    {
        // End:0x119
        if(Index >= 0)
        {
            // End:0x9E
            if(int(m_shopType) == int(2))
            {
                MoveItemTopToBottom(Index, Class'NWindow.InputAPI'.static.IsAltPressed());                
            }
            else
            {
                // End:0xBD
                if(int(m_shopType) == int(3))
                {
                    MoveItemTopToBottom(Index, false);                    
                }
                else
                {
                    m_BuyTopListHandle.GetSelectedItem(Info);
                    // End:0x10E
                    if((m_BuyBottomListHandle.GetItemNum() < m_numPossibleSlotCount) || IsStackableItem(Info.ConsumeType))
                    {
                        MoveItemTopToBottom(Index, false);                        
                    }
                    else
                    {
                        AddSystemMessage(3675);
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x166
        if((ControlName == "RefundBottomList") || ControlName == "PreviewBottomList")
        {
            MoveItemBottomToTop(Index, false);            
        }
        else
        {
            // End:0x1B5
            if((ControlName == "BuyBottomList") || ControlName == "SellBottomList")
            {
                MoveItemBottomToTop(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
            }
        }
    }
    return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
    local int Index;

    // End:0x148
    if(int(m_shopType) == int(1))
    {
        // End:0x8E
        if((strID == "BuyTopList") && Info.DragSrcName == "BuyBottomList")
        {
            Index = m_BuyBottomListHandle.FindItem(Info.Id);
            // End:0x8B
            if(Index >= 0)
            {
                MoveItemBottomToTop(Index, __NFUN_409__(Info.AllItemCount, (0)));
            }            
        }
        else
        {
            // End:0x145
            if((strID == "BuyBottomList") && Info.DragSrcName == "BuyTopList")
            {
                Index = m_BuyTopListHandle.FindItem(Info.Id);
                // End:0x145
                if(Index >= 0)
                {
                    // End:0x13A
                    if((m_BuyBottomListHandle.GetItemNum() < m_numPossibleSlotCount) || IsStackableItem(Info.ConsumeType))
                    {
                        MoveItemTopToBottom(Index, __NFUN_409__(Info.AllItemCount, (0)));                        
                    }
                    else
                    {
                        AddSystemMessage(3675);
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x258
        if(int(m_shopType) == int(2))
        {
            // End:0x1D8
            if((strID == "SellTopList") && Info.DragSrcName == "SellBottomList")
            {
                Index = m_SellBottomListHandle.FindItem(Info.Id);
                // End:0x1D5
                if(Index >= 0)
                {
                    MoveItemBottomToTop(Index, __NFUN_409__(Info.AllItemCount, (0)));
                }                
            }
            else
            {
                // End:0x255
                if((strID == "SellBottomList") && Info.DragSrcName == "SellTopList")
                {
                    Index = m_SellTopListHandle.FindItem(Info.Id);
                    // End:0x255
                    if(Index >= 0)
                    {
                        MoveItemTopToBottom(Index, __NFUN_409__(Info.AllItemCount, (0)));
                    }
                }
            }            
        }
        else
        {
            // End:0x3AC
            if(int(m_shopType) == int(4))
            {
                // End:0x2EC
                if((strID == "RefundTopList") && Info.DragSrcName == "RefundBottomList")
                {
                    Index = m_RefundBottomListHandle.FindItem(Info.Id);
                    // End:0x2E9
                    if(Index >= 0)
                    {
                        MoveItemBottomToTop(Index, __NFUN_409__(Info.AllItemCount, (0)));
                    }                    
                }
                else
                {
                    // End:0x3A9
                    if((strID == "RefundBottomList") && Info.DragSrcName == "RefundTopList")
                    {
                        Index = m_RefundTopListHandle.FindItem(Info.Id);
                        // End:0x3A9
                        if(Index >= 0)
                        {
                            // End:0x39E
                            if((m_BuyBottomListHandle.GetItemNum() < m_numPossibleSlotCount) || IsStackableItem(Info.ConsumeType))
                            {
                                MoveItemTopToBottom(Index, __NFUN_409__(Info.AllItemCount, (0)));                                
                            }
                            else
                            {
                                AddSystemMessage(3675);
                            }
                        }
                    }
                }                
            }
            else
            {
                // End:0x4C5
                if(int(m_shopType) == int(3))
                {
                    // End:0x442
                    if((strID == "PreviewTopList") && Info.DragSrcName == "PreviewBottomList")
                    {
                        Index = m_PreviewBottomListHandle.FindItem(Info.Id);
                        // End:0x43F
                        if(Index >= 0)
                        {
                            MoveItemBottomToTop(Index, __NFUN_409__(Info.AllItemCount, (0)));
                        }                        
                    }
                    else
                    {
                        // End:0x4C5
                        if((strID == "PreviewBottomList") && Info.DragSrcName == "PreviewTopList")
                        {
                            Index = m_PreviewTopListHandle.FindItem(Info.Id);
                            // End:0x4C5
                            if(Index >= 0)
                            {
                                MoveItemTopToBottom(Index, __NFUN_409__(Info.AllItemCount, (0)));
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function OnHide()
{
    m_LastShopType = 0;
    // End:0x1E
    if(int(m_shopType) != int(3))
    {
        RequestBuySellUIClose();
    }
    Clear();
    m_isCompleteTransaction = false;
    m_itemEnchantWndScript.SetIsShopping(false);
    // End:0x81
    if(GetWindowHandle("InventoryViewer").IsShowWindow())
    {
        GetWindowHandle("InventoryViewer").HideWindow();
    }
    return;
}

function Clear()
{
    m_shopType = 0;
    m_merchantID = -1;
    m_NpcID = -1;
    m_currentPrice = (0);
    m_BuyTopListHandle.super(ShopWnd).Clear();
    m_SellTopListHandle.super(ShopWnd).Clear();
    m_RefundTopListHandle.super(ShopWnd).Clear();
    m_BuyBottomListHandle.super(ShopWnd).Clear();
    m_SellBottomListHandle.super(ShopWnd).Clear();
    m_RefundBottomListHandle.super(ShopWnd).Clear();
    m_PreviewTopListHandle.super(ShopWnd).Clear();
    m_PreviewBottomListHandle.super(ShopWnd).Clear();
    m_PriceTextBoxHandle.SetText("0");
    m_PriceTextBoxHandle.SetTooltipString("");
    m_AdenaTextBoxHandle.SetText("0");
    m_AdenaTextBoxHandle.SetTooltipString("");
    Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName $ ".InvenWeight");
    m_TransactionTabHandle.InitTabCtrl();
    return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
    local int bottomIndex;
    local ItemInfo Info, bottomInfo;

    // End:0x0D
    if(Index < 0)
    {
        return;
    }
    // End:0x39
    if(int(m_shopType) == int(1))
    {
        m_BuyTopListHandle.GetItem(Index, Info);        
    }
    else
    {
        // End:0x65
        if(int(m_shopType) == int(2))
        {
            m_SellTopListHandle.GetItem(Index, Info);            
        }
        else
        {
            // End:0x91
            if(int(m_shopType) == int(4))
            {
                m_RefundTopListHandle.GetItem(Index, Info);                
            }
            else
            {
                // End:0xBA
                if(int(m_shopType) == int(3))
                {
                    m_PreviewTopListHandle.GetItem(Index, Info);
                }
            }
        }
    }
    // End:0x186
    if(((!bAllItem && IsStackableItem(Info.ConsumeType)) && __NFUN_413__(Info.ItemNum, (1))) && int(m_shopType) != int(4))
    {
        setEnableWindow(false);
        DialogSetID(111);
        DialogSetReservedItemID(Info.Id);
        DialogSetDefaultOK();
        // End:0x149
        if(int(m_shopType) == int(2))
        {
            DialogSetParamInt64(Info.ItemNum);            
        }
        else
        {
            DialogSetParamInt64((-1));
        }
        DialogSetDefaultOK();
        DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));        
    }
    else
    {
        Info.bShowCount = false;
        // End:0x205
        if(int(m_shopType) == int(1))
        {
            Info.ItemNum = (1);
            m_BuyBottomListHandle.AddItem(Info);
            Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Info.ItemNum));            
        }
        else
        {
            // End:0x308
            if(int(m_shopType) == int(2))
            {
                bottomIndex = m_SellBottomListHandle.FindItem(Info.Id);
                // End:0x2A0
                if((bottomIndex >= 0) && IsStackableItem(Info.ConsumeType))
                {
                    m_SellBottomListHandle.GetItem(bottomIndex, bottomInfo);
                    __NFUN_406__(bottomInfo.ItemNum, Info.ItemNum);
                    m_SellBottomListHandle.SetItem(bottomIndex, bottomInfo);                    
                }
                else
                {
                    m_SellBottomListHandle.AddItem(Info);
                }
                Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Info.ItemNum));
                m_SellTopListHandle.DeleteItem(Index);                
            }
            else
            {
                // End:0x390
                if(int(m_shopType) == int(4))
                {
                    Info.Reserved = 444;
                    m_RefundTopListHandle.DeleteItem(Index);
                    m_RefundBottomListHandle.AddItem(Info);
                    Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Info.ItemNum));                    
                }
                else
                {
                    // End:0x3E1
                    if(int(m_shopType) == int(3))
                    {
                        bottomIndex = m_PreviewBottomListHandle.FindItem(Info.Id);
                        Info.ItemNum = (1);
                        m_PreviewBottomListHandle.AddItem(Info);
                    }
                }
            }
        }
        // End:0x415
        if(Info.Reserved != 444)
        {
            AddPrice(__NFUN_401__(Info.Price, Info.ItemNum));            
        }
        else
        {
            AddPrice(Info.Price);
        }
    }
    UpdateItemCount();
    return;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
    local ItemInfo Info, info2;
    local int bottomIndex;

    // End:0x0D
    if(Index < 0)
    {
        return;
    }
    // End:0x39
    if(int(m_shopType) == int(1))
    {
        m_BuyBottomListHandle.GetItem(Index, Info);        
    }
    else
    {
        // End:0x65
        if(int(m_shopType) == int(2))
        {
            m_SellBottomListHandle.GetItem(Index, Info);            
        }
        else
        {
            // End:0x91
            if(int(m_shopType) == int(4))
            {
                m_RefundBottomListHandle.GetItem(Index, Info);                
            }
            else
            {
                // End:0xBA
                if(int(m_shopType) == int(3))
                {
                    m_PreviewBottomListHandle.GetItem(Index, Info);
                }
            }
        }
    }
    // End:0x16A
    if(((!bAllItem && IsStackableItem(Info.ConsumeType)) && __NFUN_413__(Info.ItemNum, (1))) && Info.Reserved != 444)
    {
        setEnableWindow(false);
        DialogSetID(222);
        DialogSetDefaultOK();
        DialogSetReservedItemID(Info.Id);
        DialogSetParamInt64(Info.ItemNum);
        DialogSetDefaultOK();
        DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));        
    }
    else
    {
        // End:0x1CE
        if(int(m_shopType) == int(1))
        {
            m_BuyBottomListHandle.DeleteItem(Index);
            Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Info.ItemNum));            
        }
        else
        {
            // End:0x2C0
            if(int(m_shopType) == int(2))
            {
                m_SellBottomListHandle.DeleteItem(Index);
                bottomIndex = m_SellTopListHandle.FindItem(Info.Id);
                // End:0x237
                if(bottomIndex == -1)
                {
                    m_SellTopListHandle.AddItem(Info);                    
                }
                else
                {
                    m_SellTopListHandle.GetItem(bottomIndex, info2);
                    __NFUN_406__(info2.ItemNum, Info.ItemNum);
                    m_SellTopListHandle.SetItem(bottomIndex, info2);
                }
                Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Info.ItemNum));                
            }
            else
            {
                // End:0x34C
                if(int(m_shopType) == int(4))
                {
                    m_RefundBottomListHandle.DeleteItem(Index);
                    // End:0x30C
                    if(Info.Reserved == 444)
                    {
                        m_RefundTopListHandle.AddItem(Info);
                    }
                    Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Info.ItemNum));                    
                }
                else
                {
                    // End:0x370
                    if(int(m_shopType) == int(3))
                    {
                        m_PreviewBottomListHandle.DeleteItem(Index);
                    }
                }
            }
        }
        // End:0x3A7
        if(Info.Reserved != 444)
        {
            AddPrice(__NFUN_401__(__NFUN_400__(Info.Price), Info.ItemNum));            
        }
        else
        {
            AddPrice(__NFUN_400__(Info.Price));
        }
    }
    UpdateItemCount();
    return;
}

function HandleDialogOK()
{
    local int Id, Index, topIndex;
    local INT64 Num;
    local ItemInfo Info, topInfo;
    local string param;
    local ItemID cID;

    // End:0xA40
    if(DialogIsMine())
    {
        Id = DialogGetID();
        Num = (DialogGetString());
        cID = DialogGetReservedItemID();
        // End:0x4FD
        if((Id == 111) && __NFUN_409__(Num, (0)))
        {
            // End:0x78
            if(int(m_shopType) == int(1))
            {
                topIndex = m_BuyTopListHandle.FindItem(cID);                
            }
            else
            {
                // End:0xA5
                if(int(m_shopType) == int(2))
                {
                    topIndex = m_SellTopListHandle.FindItem(cID);                    
                }
                else
                {
                    // End:0xD2
                    if(int(m_shopType) == int(4))
                    {
                        topIndex = m_RefundTopListHandle.FindItem(cID);                        
                    }
                    else
                    {
                        // End:0xFC
                        if(int(m_shopType) == int(3))
                        {
                            topIndex = m_PreviewTopListHandle.FindItem(cID);
                        }
                    }
                }
            }
            // End:0x4FA
            if(topIndex >= 0)
            {
                // End:0x243
                if(int(m_shopType) == int(1))
                {
                    m_BuyTopListHandle.GetItem(topIndex, topInfo);
                    Index = m_BuyBottomListHandle.FindItem(cID);
                    // End:0x1B4
                    if(Index >= 0)
                    {
                        m_BuyBottomListHandle.GetItem(Index, Info);
                        __NFUN_406__(Info.ItemNum, Num);
                        m_BuyBottomListHandle.SetItem(Index, Info);
                        AddPrice(__NFUN_401__(Num, Info.Price));                        
                    }
                    else
                    {
                        Info = topInfo;
                        Info.ItemNum = Num;
                        Info.bShowCount = false;
                        m_BuyBottomListHandle.AddItem(Info);
                        AddPrice(__NFUN_401__(Num, Info.Price));
                    }
                    Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Num));                    
                }
                else
                {
                    // End:0x3F9
                    if(int(m_shopType) == int(2))
                    {
                        m_SellTopListHandle.GetItem(topIndex, topInfo);
                        // End:0x291
                        if(__NFUN_408__(topInfo.ItemNum, Num))
                        {
                            Num = topInfo.ItemNum;
                        }
                        Index = m_SellBottomListHandle.FindItem(cID);
                        // End:0x315
                        if(Index >= 0)
                        {
                            m_SellBottomListHandle.GetItem(Index, Info);
                            __NFUN_406__(Info.ItemNum, Num);
                            m_SellBottomListHandle.SetItem(Index, Info);
                            AddPrice(__NFUN_401__(Num, Info.Price));                            
                        }
                        else
                        {
                            Info = topInfo;
                            Info.ItemNum = Num;
                            Info.bShowCount = false;
                            m_SellBottomListHandle.AddItem(Info);
                            AddPrice(__NFUN_401__(Num, Info.Price));
                        }
                        __NFUN_407__(topInfo.ItemNum, Num);
                        // End:0x3A5
                        if(__NFUN_410__(topInfo.ItemNum, (0)))
                        {
                            m_SellTopListHandle.DeleteItem(topIndex);                            
                        }
                        else
                        {
                            m_SellTopListHandle.SetItem(topIndex, topInfo);
                        }
                        Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Num));                        
                    }
                    else
                    {
                        // End:0x4FA
                        if(int(m_shopType) == int(3))
                        {
                            m_PreviewTopListHandle.GetItem(topIndex, topInfo);
                            Index = m_PreviewBottomListHandle.FindItem(cID);
                            // End:0x4A6
                            if(Index >= 0)
                            {
                                m_PreviewBottomListHandle.GetItem(Index, Info);
                                __NFUN_406__(Info.ItemNum, Num);
                                m_PreviewBottomListHandle.SetItem(Index, Info);
                                AddPrice(__NFUN_401__(Num, Info.Price));                                
                            }
                            else
                            {
                                Info = topInfo;
                                Info.ItemNum = Num;
                                Info.bShowCount = false;
                                m_PreviewBottomListHandle.AddItem(Info);
                                AddPrice(__NFUN_401__(Num, Info.Price));
                            }
                        }
                    }
                }
            }            
        }
        else
        {
            // End:0x950
            if((Id == 222) && __NFUN_409__(Num, (0)))
            {
                // End:0x541
                if(int(m_shopType) == int(1))
                {
                    Index = m_BuyBottomListHandle.GetSelectedNum();                    
                }
                else
                {
                    // End:0x569
                    if(int(m_shopType) == int(2))
                    {
                        Index = m_SellBottomListHandle.GetSelectedNum();                        
                    }
                    else
                    {
                        // End:0x591
                        if(int(m_shopType) == int(4))
                        {
                            Index = m_RefundBottomListHandle.GetSelectedNum();                            
                        }
                        else
                        {
                            // End:0x5B6
                            if(int(m_shopType) == int(3))
                            {
                                Index = m_PreviewBottomListHandle.GetSelectedNum();
                            }
                        }
                    }
                }
                // End:0x94D
                if(Index >= 0)
                {
                    // End:0x6C0
                    if(int(m_shopType) == int(1))
                    {
                        m_BuyBottomListHandle.GetItem(Index, Info);
                        __NFUN_407__(Info.ItemNum, Num);
                        // End:0x62B
                        if(__NFUN_409__(Info.ItemNum, (0)))
                        {
                            m_BuyBottomListHandle.SetItem(Index, Info);                            
                        }
                        else
                        {
                            m_BuyBottomListHandle.DeleteItem(Index);
                        }
                        Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Num));
                        // End:0x6A2
                        if(__NFUN_410__(Info.ItemNum, (0)))
                        {
                            Num = __NFUN_404__(Info.ItemNum, Num);
                        }
                        AddPrice(__NFUN_401__(__NFUN_400__(Num), Info.Price));                        
                    }
                    else
                    {
                        // End:0x889
                        if(int(m_shopType) == int(2))
                        {
                            m_SellBottomListHandle.GetItem(Index, Info);
                            // End:0x70E
                            if(__NFUN_408__(Info.ItemNum, Num))
                            {
                                Num = Info.ItemNum;
                            }
                            __NFUN_407__(Info.ItemNum, Num);
                            // End:0x74F
                            if(__NFUN_409__(Info.ItemNum, (0)))
                            {
                                m_SellBottomListHandle.SetItem(Index, Info);                                
                            }
                            else
                            {
                                m_SellBottomListHandle.DeleteItem(Index);
                            }
                            topIndex = m_SellTopListHandle.FindItem(cID);
                            // End:0x7E4
                            if((topIndex >= 0) && IsStackableItem(Info.ConsumeType))
                            {
                                m_SellTopListHandle.GetItem(topIndex, topInfo);
                                __NFUN_406__(topInfo.ItemNum, Num);
                                m_SellTopListHandle.SetItem(topIndex, topInfo);                                
                            }
                            else
                            {
                                Info.ItemNum = Num;
                                m_SellTopListHandle.AddItem(Info);
                            }
                            // End:0x833
                            if(__NFUN_410__(Info.ItemNum, (0)))
                            {
                                Num = __NFUN_404__(Info.ItemNum, Num);
                            }
                            AddPrice(__NFUN_401__(__NFUN_400__(Num), Info.Price));
                            Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Num));                            
                        }
                        else
                        {
                            // End:0x94D
                            if(int(m_shopType) == int(3))
                            {
                                m_PreviewBottomListHandle.GetItem(Index, Info);
                                __NFUN_407__(Info.ItemNum, Num);
                                // End:0x8F3
                                if(__NFUN_409__(Info.ItemNum, (0)))
                                {
                                    m_PreviewBottomListHandle.SetItem(Index, Info);                                    
                                }
                                else
                                {
                                    m_PreviewBottomListHandle.DeleteItem(Index);
                                }
                                // End:0x932
                                if(__NFUN_410__(Info.ItemNum, (0)))
                                {
                                    Num = __NFUN_404__(Info.ItemNum, Num);
                                }
                                AddPrice(__NFUN_401__(__NFUN_400__(Num), Info.Price));
                            }
                        }
                    }
                }                
            }
            else
            {
                // End:0xA3A
                if(Id == 333)
                {
                    Num = (m_PreviewBottomListHandle.GetItemNum());
                    // End:0xA3A
                    if(__NFUN_409__(Num, (0)))
                    {
                        ParamAdd(param, "merchant", string(m_merchantID));
                        ParamAdd(param, "npc", string(m_NpcID));
                        ParamAdd(param, "num", (Num));
                        Index = 0;
                        J0x9D5:

                        // End:0xA24 [Loop If]
                        if(__NFUN_408__((Index), Num))
                        {
                            m_PreviewBottomListHandle.GetItem(Index, Info);
                            ParamAddItemIDWithIndex(param, Info.Id, Index);
                            ++Index;
                            // [Loop Continue]
                            goto J0x9D5;
                        }
                        RequestPreviewItem(param);
                        HideWindow(m_WindowName);
                    }
                }
            }
        }
        UpdateItemCount();
    }
    return;
}

function HandleOpenWindow(string param)
{
    local string Type;
    local INT64 Adena;
    local string adenaString;

    ParseString(param, "type", Type);
    m_TopTextBoxHandle.SetText(GetSystemString(2323));
    // End:0x113
    if(Type == "buy")
    {
        Clear();
        ParseInt(param, "merchant", m_merchantID);
        ParseINT64(param, "adena", Adena);
        adenaString = MakeCostString((Adena));
        m_AdenaTextBoxHandle.SetText(adenaString);
        m_AdenaTextBoxHandle.SetTooltipString(ConvertNumToText((Adena)));
        m_UserAdena = Adena;
        ParseInt(param, "nInventoryItemCount", m_curInventoryCount);
        ShowWindow(m_WindowName);
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_WindowName);
        m_shopType = 1;        
    }
    else
    {
        // End:0x153
        if(Type == "sell")
        {
            m_shopType = 2;
            ParseInt(param, "nInventoryItemCount", m_curInventoryCount);            
        }
        else
        {
            // End:0x195
            if(Type == "refund")
            {
                m_shopType = 4;
                ParseInt(param, "nInventoryItemCount", m_curInventoryCount);                
            }
            else
            {
                // End:0x24C
                if(Type == "preview")
                {
                    Clear();
                    ParseInt(param, "merchant", m_merchantID);
                    ParseINT64(param, "adena", Adena);
                    adenaString = MakeCostString((Adena));
                    m_AdenaTextBoxHandle.SetText(adenaString);
                    m_AdenaTextBoxHandle.SetTooltipString(ConvertNumToText((Adena)));
                    ShowWindow(m_WindowName);
                    Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_WindowName);
                    m_shopType = 3;                    
                }
                else
                {
                    m_shopType = 0;
                }
            }
        }
    }
    // End:0x390
    if(int(m_shopType) == int(1))
    {
        m_TexTransactionBGLine.ShowWindow();
        m_TexPreviewBGLine.HideWindow();
        m_TexRefundSlotBG.HideWindow();
        m_TexBuySellSlotBG.ShowWindow();
        m_TexPreviewSlotBG.HideWindow();
        m_TransactionTabHandle.ShowWindow();
        m_PreviewTabHandle.HideWindow();
        m_BuyTopListHandle.ShowWindow();
        m_SellTopListHandle.HideWindow();
        m_RefundTopListHandle.HideWindow();
        m_PreviewTopListHandle.HideWindow();
        m_BuyBottomListHandle.ShowWindow();
        m_SellBottomListHandle.HideWindow();
        m_RefundBottomListHandle.HideWindow();
        m_PreviewBottomListHandle.HideWindow();
        m_OkButtonHandle.SetNameText(GetSystemString(1434));
        m_BottomTextBoxHandle.SetText(GetSystemString(139));
        m_PriceConstTextBoxHandle.SetText(GetSystemString(142));        
    }
    else
    {
        // End:0x4E4
        if(int(m_shopType) == int(3))
        {
            ParseInt(param, "npc", m_NpcID);
            m_TexTransactionBGLine.HideWindow();
            m_TexPreviewBGLine.ShowWindow();
            m_TexRefundSlotBG.HideWindow();
            m_TexBuySellSlotBG.HideWindow();
            m_TexPreviewSlotBG.ShowWindow();
            m_TransactionTabHandle.HideWindow();
            m_PreviewTabHandle.ShowWindow();
            m_BuyTopListHandle.HideWindow();
            m_SellTopListHandle.HideWindow();
            m_RefundTopListHandle.HideWindow();
            m_PreviewTopListHandle.ShowWindow();
            m_BuyBottomListHandle.HideWindow();
            m_SellBottomListHandle.HideWindow();
            m_RefundBottomListHandle.HideWindow();
            m_PreviewBottomListHandle.ShowWindow();
            m_OkButtonHandle.SetNameText(GetSystemString(1337));
            m_BottomTextBoxHandle.SetText(GetSystemString(812));
            m_PriceConstTextBoxHandle.SetText(GetSystemString(813));
        }
    }
    UpdateItemCount();
    // End:0x514
    if(m_itemEnchantWndHandle.IsShowWindow())
    {
        m_itemEnchantWndScript.OnClickButton("ExitBtn");
    }
    m_itemEnchantWndScript.SetIsShopping(true);
    return;
}

function HandleAddItem(string param)
{
    local ItemInfo Info;

    ParamToItemInfo(param, Info);
    // End:0x42
    if((int(m_shopType) == int(1)) && __NFUN_409__(Info.ItemNum, (0)))
    {
        Info.bShowCount = true;
    }
    // End:0x69
    if(int(m_shopType) == int(1))
    {
        m_BuyTopListHandle.AddItem(Info);        
    }
    else
    {
        // End:0x90
        if(int(m_shopType) == int(2))
        {
            m_SellTopListHandle.AddItem(Info);            
        }
        else
        {
            // End:0xB7
            if(int(m_shopType) == int(4))
            {
                m_RefundTopListHandle.AddItem(Info);                
            }
            else
            {
                // End:0xDB
                if(int(m_shopType) == int(3))
                {
                    m_PreviewTopListHandle.AddItem(Info);
                }
            }
        }
    }
    return;
}

function AddPrice(INT64 Price)
{
    local string Adena;

    m_currentPrice = __NFUN_404__(m_currentPrice, Price);
    Adena = MakeCostStringINT64(m_currentPrice);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".PriceText", Adena);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".PriceText", ConvertNumToText((m_currentPrice)));
    return;
}

function HandleOKButton()
{
    local string param;
    local int topCount, bottomCount, topIndex, bottomIndex;
    local ItemInfo topInfo, bottomInfo;
    local INT64 limitedItemCount;

    // End:0x0B
    if(m_isCompleteTransaction)
    {
        return;
    }
    m_LastShopType = m_shopType;
    // End:0x16E
    if(int(m_shopType) == int(1))
    {
        topCount = m_BuyTopListHandle.GetItemNum();
        topIndex = 0;
        J0x42:

        // End:0x13C [Loop If]
        if(topIndex < topCount)
        {
            m_BuyTopListHandle.GetItem(topIndex, topInfo);
            // End:0x132
            if(__NFUN_409__(topInfo.ItemNum, (0)))
            {
                limitedItemCount = (0);
                bottomCount = m_BuyBottomListHandle.GetItemNum();
                bottomIndex = 0;
                J0xA2:

                // End:0x103 [Loop If]
                if(bottomIndex < bottomCount)
                {
                    m_BuyBottomListHandle.GetItem(bottomIndex, bottomInfo);
                    // End:0xF9
                    if(IsSameClassID(bottomInfo.Id, topInfo.Id))
                    {
                        __NFUN_406__(limitedItemCount, bottomInfo.ItemNum);
                    }
                    ++bottomIndex;
                    // [Loop Continue]
                    goto J0xA2;
                }
                // End:0x132
                if(__NFUN_409__(limitedItemCount, topInfo.ItemNum))
                {
                    DialogShow(1, 4, GetSystemMessage(1338), string(self));
                    return;
                }
            }
            ++topIndex;
            // [Loop Continue]
            goto J0x42;
        }
        // End:0x16E
        if(__NFUN_409__(m_currentPrice, m_UserAdena))
        {
            DialogShow(0, 1, GetSystemMessage(279), string(self));
            m_isCompleteTransaction = false;
            return;
        }
    }
    // End:0x277
    if(int(m_shopType) == int(1))
    {
        bottomCount = m_BuyBottomListHandle.GetItemNum();
        // End:0x274
        if(bottomCount > 0)
        {
            ParamAdd(param, "merchant", string(m_merchantID));
            ParamAdd(param, "num", string(bottomCount));
            bottomIndex = 0;
            J0x1D8:

            // End:0x261 [Loop If]
            if(bottomIndex < bottomCount)
            {
                m_BuyBottomListHandle.GetItem(bottomIndex, bottomInfo);
                ParamAdd(param, "ClassID_" $ string(bottomIndex), string(bottomInfo.Id.ClassID));
                ParamAdd(param, "Count_" $ string(bottomIndex), (bottomInfo.ItemNum));
                ++bottomIndex;
                // [Loop Continue]
                goto J0x1D8;
            }
            RequestBuyItem(param);
            m_isCompleteTransaction = true;
        }        
    }
    else
    {
        // End:0x36B
        if(int(m_shopType) == int(2))
        {
            bottomCount = m_SellBottomListHandle.GetItemNum();
            // End:0x368
            if(bottomCount > 0)
            {
                ParamAdd(param, "merchant", string(m_merchantID));
                ParamAdd(param, "num", string(bottomCount));
                bottomIndex = 0;
                J0x2E1:

                // End:0x355 [Loop If]
                if(bottomIndex < bottomCount)
                {
                    m_SellBottomListHandle.GetItem(bottomIndex, bottomInfo);
                    ParamAddItemIDWithIndex(param, bottomInfo.Id, bottomIndex);
                    ParamAdd(param, "Count_" $ string(bottomIndex), (bottomInfo.ItemNum));
                    ++bottomIndex;
                    // [Loop Continue]
                    goto J0x2E1;
                }
                RequestSellItem(param);
                m_isCompleteTransaction = true;
            }            
        }
        else
        {
            // End:0x47C
            if(int(m_shopType) == int(4))
            {
                bottomCount = m_RefundBottomListHandle.GetItemNum();
                // End:0x479
                if(bottomCount > 0)
                {
                    ParamAdd(param, "merchant", string(m_merchantID));
                    ParamAdd(param, "num", string(bottomCount));
                    bottomIndex = 0;
                    J0x3D5:

                    // End:0x434 [Loop If]
                    if(bottomIndex < bottomCount)
                    {
                        m_RefundBottomListHandle.GetItem(bottomIndex, bottomInfo);
                        ParamAdd(param, "index_" $ string(bottomIndex), string(bottomInfo.Id.ServerID));
                        ++bottomIndex;
                        // [Loop Continue]
                        goto J0x3D5;
                    }
                    // End:0x466
                    if(__NFUN_409__(m_currentPrice, m_UserAdena))
                    {
                        DialogShow(0, 1, GetSystemMessage(279), string(self));
                        m_isCompleteTransaction = false;
                        return;
                    }
                    RequestRefundItem(param);
                    m_isCompleteTransaction = true;
                }                
            }
            else
            {
                // End:0x4CF
                if(int(m_shopType) == int(3))
                {
                    bottomCount = m_PreviewBottomListHandle.GetItemNum();
                    // End:0x4CF
                    if(bottomCount > 0)
                    {
                        DialogSetID(333);
                        DialogShow(1, 4, GetSystemMessage(1157), string(self));
                    }
                }
            }
        }
    }
    return;
}

function HandleEndTransactionList(string param)
{
    local int WindowOpenType;

    ParseInt(param, "type", WindowOpenType);
    // End:0x12F
    if(int(m_LastShopType) == int(2))
    {
        m_TransactionTabHandle.SetTopOrder(1, false);
        m_shopType = 2;
        m_BuyBottomListHandle.Clear();
        m_RefundBottomListHandle.Clear();
        m_TexBuySellSlotBG.ShowWindow();
        m_TexPreviewSlotBG.HideWindow();
        m_TexRefundSlotBG.HideWindow();
        m_BuyTopListHandle.HideWindow();
        m_SellTopListHandle.ShowWindow();
        m_RefundTopListHandle.HideWindow();
        m_BuyBottomListHandle.HideWindow();
        m_SellBottomListHandle.ShowWindow();
        m_RefundBottomListHandle.HideWindow();
        m_OkButtonHandle.SetNameText(GetSystemString(1157));
        m_BottomTextBoxHandle.SetText(GetSystemString(137));
        m_PriceConstTextBoxHandle.SetText(GetSystemString(143));        
    }
    else
    {
        // End:0x272
        if(int(m_LastShopType) == int(4))
        {
            m_TransactionTabHandle.SetTopOrder(2, false);
            m_shopType = 4;
            m_BuyBottomListHandle.Clear();
            m_SellBottomListHandle.Clear();
            m_PriceTextBoxHandle.SetText("0");
            m_PriceTextBoxHandle.SetTooltipString("");
            m_TexBuySellSlotBG.HideWindow();
            m_TexPreviewSlotBG.HideWindow();
            m_TexRefundSlotBG.ShowWindow();
            m_BuyTopListHandle.HideWindow();
            m_SellTopListHandle.HideWindow();
            m_RefundTopListHandle.ShowWindow();
            m_BuyBottomListHandle.HideWindow();
            m_SellBottomListHandle.HideWindow();
            m_RefundBottomListHandle.ShowWindow();
            m_OkButtonHandle.SetNameText(GetSystemString(2028));
            m_BottomTextBoxHandle.SetText(GetSystemString(2205));
            m_PriceConstTextBoxHandle.SetText(GetSystemString(2206));            
        }
        else
        {
            m_shopType = 1;
        }
    }
    // End:0x3B1
    if(WindowOpenType == 0)
    {
        m_TransactionTabHandle.SetTopOrder(0, false);
        m_shopType = 1;
        m_SellBottomListHandle.Clear();
        m_RefundBottomListHandle.Clear();
        m_PriceTextBoxHandle.SetText("0");
        m_PriceTextBoxHandle.SetTooltipString("");
        m_TexBuySellSlotBG.ShowWindow();
        m_TexPreviewSlotBG.HideWindow();
        m_TexRefundSlotBG.HideWindow();
        m_BuyTopListHandle.ShowWindow();
        m_SellTopListHandle.HideWindow();
        m_RefundTopListHandle.HideWindow();
        m_BuyBottomListHandle.ShowWindow();
        m_SellBottomListHandle.HideWindow();
        m_RefundBottomListHandle.HideWindow();
        m_OkButtonHandle.SetNameText(GetSystemString(1434));
        m_BottomTextBoxHandle.SetText(GetSystemString(139));
        m_PriceConstTextBoxHandle.SetText(GetSystemString(142));        
    }
    else
    {
        // End:0x3E0
        if(WindowOpenType == 2)
        {
            DialogShow(0, 1, GetSystemMessage(279), string(self));
            m_isCompleteTransaction = false;            
        }
        else
        {
            // End:0x40F
            if(WindowOpenType == 3)
            {
                DialogShow(0, 1, GetSystemMessage(352), string(self));
                m_isCompleteTransaction = false;                
            }
            else
            {
                // End:0x446
                if((WindowOpenType == 1) && m_isCompleteTransaction)
                {
                    AddSystemMessage(3092);
                    m_isCompleteTransaction = false;
                    HideWindow(m_WindowName);                    
                }
                else
                {
                    m_isCompleteTransaction = false;
                }
            }
        }
    }
    return;
}

function setEnableWindow(bool flag)
{
    // End:0x1B
    if(flag)
    {
        Me.EnableWindow();        
    }
    else
    {
        Me.DisableWindow();
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

function HandleSetMaxCount(string param)
{
    ParseInt(param, "Inventory", m_maxInventoryCount);
    return;
}

function UpdateItemCount()
{
    local int iPossibleInvenCount, iTradeListCount;

    // End:0x3A
    if(int(m_shopType) == int(1))
    {
        iTradeListCount = m_BuyBottomListHandle.GetItemNum();
        iPossibleInvenCount = m_maxInventoryCount - m_curInventoryCount;        
    }
    else
    {
        // End:0x74
        if(int(m_shopType) == int(2))
        {
            iTradeListCount = m_SellBottomListHandle.GetItemNum();
            iPossibleInvenCount = m_maxInventoryCount - m_curInventoryCount;            
        }
        else
        {
            // End:0xAE
            if(int(m_shopType) == int(4))
            {
                iTradeListCount = m_RefundBottomListHandle.GetItemNum();
                iPossibleInvenCount = m_maxInventoryCount - m_curInventoryCount;                
            }
            else
            {
                iTradeListCount = m_PreviewBottomListHandle.GetItemNum();
                iPossibleInvenCount = 0;
            }
        }
    }
    m_numPossibleSlotCount = iPossibleInvenCount;
    // End:0x108
    if(int(m_shopType) == int(3))
    {
        m_ShopWndItemCountHandle.SetText(("(" $ string(iTradeListCount)) $ ")");        
    }
    else
    {
        switch(m_TransactionTabHandle.GetTopIndex())
        {
            // End:0x14E
            case 0:
                m_ShopWndItemCountHandle.SetText(((("(" $ string(iTradeListCount)) $ "/") $ string(iPossibleInvenCount)) $ ")");
                // End:0x1AE
                break;
            // End:0x175
            case 1:
                m_ShopWndItemCountHandle.SetText(("(" $ string(iTradeListCount)) $ ")");
                // End:0x1AE
                break;
            // End:0x1AB
            case 2:
                m_ShopWndItemCountHandle.SetText(((("(" $ string(iTradeListCount)) $ "/") $ string(iPossibleInvenCount)) $ ")");
                // End:0x1AE
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    return;
}

defaultproperties
{
    m_WindowName="ShopWnd"
}