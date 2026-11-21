class SeedShopWnd extends UICommonAPI;

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const DIALOG_PREVIEW = 333;

enum ShopType
{
    ShopNone,                       // 0
    ShopBuy,                        // 1
    ShopSell,                       // 2
    ShopPreview                     // 3
};

var string m_WindowName;
var SeedShopWnd.ShopType m_shopType;
var int m_merchantID;
var int m_NpcID;
var INT64 m_currentPrice;

function OnRegisterEvent()
{
    RegisterEvent(2080);
    RegisterEvent(2090);
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
    return;
}

function Clear()
{
    m_shopType = 0;
    m_merchantID = -1;
    m_NpcID = -1;
    m_currentPrice = (0);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear(m_WindowName $ ".TopList");
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear(m_WindowName $ ".BottomList");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".PriceText", "0");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".PriceText", "");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", "0");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", "");
    Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight(m_WindowName $ ".InvenWeight");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 2080:
            HandleOpenWindow(param);
            // End:0x4A
            break;
        // End:0x33
        case 2090:
            HandleAddItem(param);
            // End:0x4A
            break;
        // End:0x44
        case 1710:
            HandleDialogOK();
            // End:0x4A
            break;
        // End:0xFFFF
        default:
            // End:0x4A
            break;
            break;
    }
    return;
}

function OnClickButton(string ControlName)
{
    local int Index;

    // End:0x4C
    if(ControlName == "UpButton")
    {
        Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedNum(m_WindowName $ ".BottomList");
        MoveItemBottomToTop(Index, false);        
    }
    else
    {
        // End:0x97
        if(ControlName == "DownButton")
        {
            Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedNum(m_WindowName $ ".TopList");
            MoveItemTopToBottom(Index, false);            
        }
        else
        {
            // End:0xB4
            if(ControlName == "OKButton")
            {
                HandleOKButton();                
            }
            else
            {
                // End:0xDD
                if(ControlName == "CancelButton")
                {
                    Clear();
                    HideWindow(m_WindowName);
                }
            }
        }
    }
    return;
}

function OnDBClickItem(string ControlName, int Index)
{
    // End:0x22
    if(ControlName == "TopList")
    {
        MoveItemTopToBottom(Index, false);        
    }
    else
    {
        // End:0x52
        if(ControlName == "BottomList")
        {
            MoveItemBottomToTop(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
        }
    }
    return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
    local int Index;

    // End:0x8C
    if((strID == "TopList") && Info.DragSrcName == "BottomList")
    {
        Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".BottomList", Info.Id);
        // End:0x89
        if(Index >= 0)
        {
            MoveItemBottomToTop(Index, __NFUN_409__(Info.AllItemCount, (0)));
        }        
    }
    else
    {
        // End:0x112
        if((strID == "BottomList") && Info.DragSrcName == "TopList")
        {
            Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".TopList", Info.Id);
            // End:0x112
            if(Index >= 0)
            {
                MoveItemTopToBottom(Index, __NFUN_409__(Info.AllItemCount, (0)));
            }
        }
    }
    return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
    local int bottomIndex;
    local ItemInfo Info, bottomInfo;

    // End:0x330
    if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".TopList", Index, Info))
    {
        // End:0xE0
        if((!bAllItem && IsStackableItem(Info.ConsumeType)) && __NFUN_413__(Info.ItemNum, (1)))
        {
            DialogSetID(111);
            DialogSetReservedItemID(Info.Id);
            DialogSetDefaultOK();
            // End:0xA3
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
            // End:0x214
            if(int(m_shopType) == int(2))
            {
                bottomIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".BottomList", Info.Id);
                // End:0x1C4
                if((bottomIndex >= 0) && IsStackableItem(Info.ConsumeType))
                {
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".BottomList", bottomIndex, bottomInfo);
                    __NFUN_406__(bottomInfo.ItemNum, Info.ItemNum);
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem(m_WindowName $ ".BottomList", bottomIndex, bottomInfo);                    
                }
                else
                {
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(m_WindowName $ ".BottomList", Info);
                }
                Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem(m_WindowName $ ".TopList", Index);                
            }
            else
            {
                // End:0x29A
                if(int(m_shopType) == int(1))
                {
                    Info.ItemNum = (1);
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(m_WindowName $ ".BottomList", Info);
                    Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Info.ItemNum));                    
                }
                else
                {
                    // End:0x313
                    if(int(m_shopType) == int(3))
                    {
                        bottomIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".BottomList", Info.Id);
                        Info.ItemNum = (1);
                        Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(m_WindowName $ ".BottomList", Info);
                    }
                }
            }
            AddPrice(__NFUN_401__(Info.Price, Info.ItemNum));
        }
    }
    return;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
    local ItemInfo Info, info2;
    local int bottomIndex;

    // End:0x23D
    if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".BottomList", Index, Info))
    {
        // End:0xC3
        if((!bAllItem && IsStackableItem(Info.ConsumeType)) && __NFUN_413__(Info.ItemNum, (1)))
        {
            DialogSetID(222);
            DialogSetDefaultOK();
            DialogSetReservedItemID(Info.Id);
            DialogSetParamInt64(Info.ItemNum);
            DialogSetDefaultOK();
            DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));            
        }
        else
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem(m_WindowName $ ".BottomList", Index);
            // End:0x1D0
            if(int(m_shopType) == int(2))
            {
                bottomIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".TopList", Info.Id);
                // End:0x162
                if(bottomIndex == -1)
                {
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(m_WindowName $ ".TopList", Info);                    
                }
                else
                {
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".TopList", bottomIndex, info2);
                    __NFUN_406__(info2.ItemNum, Info.ItemNum);
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem(m_WindowName $ ".TopList", bottomIndex, info2);
                }                
            }
            else
            {
                // End:0x21D
                if(int(m_shopType) == int(1))
                {
                    Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Info.ItemNum));
                }
            }
            AddPrice(__NFUN_401__(__NFUN_400__(Info.Price), Info.ItemNum));
        }
    }
    return;
}

function HandleDialogOK()
{
    local int Id, Index, topIndex;
    local INT64 Num;
    local ItemInfo Info, topInfo;
    local string param;
    local ItemID cID;

    // End:0x670
    if(DialogIsMine())
    {
        Id = DialogGetID();
        Num = (DialogGetString());
        cID = DialogGetReservedItemID();
        // End:0x2DD
        if((Id == 111) && __NFUN_409__(Num, (0)))
        {
            topIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".TopList", cID);
            // End:0x2DA
            if(topIndex >= 0)
            {
                Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".TopList", topIndex, topInfo);
                // End:0xE0
                if(int(m_shopType) == int(2))
                {
                    // End:0xE0
                    if(__NFUN_408__(topInfo.ItemNum, Num))
                    {
                        Num = topInfo.ItemNum;
                    }
                }
                Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".BottomList", cID);
                // End:0x1A0
                if(Index >= 0)
                {
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".BottomList", Index, Info);
                    __NFUN_406__(Info.ItemNum, Num);
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem(m_WindowName $ ".BottomList", Index, Info);
                    AddPrice(__NFUN_401__(Num, Info.Price));                    
                }
                else
                {
                    Info = topInfo;
                    Info.ItemNum = Num;
                    Info.bShowCount = false;
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(m_WindowName $ ".BottomList", Info);
                    AddPrice(__NFUN_401__(Num, Info.Price));
                }
                // End:0x292
                if(int(m_shopType) == int(2))
                {
                    __NFUN_407__(topInfo.ItemNum, Num);
                    // End:0x265
                    if(__NFUN_410__(topInfo.ItemNum, (0)))
                    {
                        Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem(m_WindowName $ ".TopList", topIndex);                        
                    }
                    else
                    {
                        Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem(m_WindowName $ ".TopList", topIndex, topInfo);
                    }                    
                }
                else
                {
                    // End:0x2DA
                    if(int(m_shopType) == int(1))
                    {
                        Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Num));
                    }
                }
            }            
        }
        else
        {
            // End:0x569
            if((Id == 222) && __NFUN_409__(Num, (0)))
            {
                Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".BottomList", cID);
                // End:0x566
                if(Index >= 0)
                {
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".BottomList", Index, Info);
                    __NFUN_407__(Info.ItemNum, Num);
                    // End:0x3B4
                    if(__NFUN_409__(Info.ItemNum, (0)))
                    {
                        Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem(m_WindowName $ ".BottomList", Index, Info);                        
                    }
                    else
                    {
                        Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem(m_WindowName $ ".BottomList", Index);
                    }
                    // End:0x4D8
                    if(int(m_shopType) == int(2))
                    {
                        topIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".TopList", cID);
                        // End:0x4A0
                        if((topIndex >= 0) && IsStackableItem(Info.ConsumeType))
                        {
                            Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".TopList", topIndex, topInfo);
                            __NFUN_406__(topInfo.ItemNum, Num);
                            Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem(m_WindowName $ ".TopList", topIndex, topInfo);                            
                        }
                        else
                        {
                            Info.ItemNum = Num;
                            Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(m_WindowName $ ".TopList", Info);
                        }                        
                    }
                    else
                    {
                        // End:0x520
                        if(int(m_shopType) == int(1))
                        {
                            Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Num));
                        }
                    }
                    // End:0x54B
                    if(__NFUN_410__(Info.ItemNum, (0)))
                    {
                        Num = __NFUN_404__(Info.ItemNum, Num);
                    }
                    AddPrice(__NFUN_401__(__NFUN_400__(Num), Info.Price));
                }                
            }
            else
            {
                // End:0x670
                if(Id == 333)
                {
                    Num = (Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum(m_WindowName $ ".BottomList"));
                    // End:0x670
                    if(__NFUN_409__(Num, (0)))
                    {
                        ParamAdd(param, "merchant", string(m_merchantID));
                        ParamAdd(param, "npc", string(m_NpcID));
                        ParamAdd(param, "num", (Num));
                        Index = 0;
                        J0x602:

                        // End:0x665 [Loop If]
                        if(__NFUN_408__((Index), Num))
                        {
                            Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".BottomList", Index, Info);
                            ParamAddItemIDWithIndex(param, Info.Id, Index);
                            ++Index;
                            // [Loop Continue]
                            goto J0x602;
                        }
                        RequestPreviewItem(param);
                    }
                }
            }
        }
    }
    return;
}

function HandleOpenWindow(string param)
{
    local string Type;
    local INT64 Adena;
    local string adenaString;
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
    Clear();
    ParseString(param, "type", Type);
    ParseInt(param, "merchant", m_merchantID);
    ParseINT64(param, "adena", Adena);
    // End:0xA5
    if(Type == "buy")
    {
        m_shopType = 1;        
    }
    else
    {
        // End:0xC0
        if(Type == "sell")
        {
            m_shopType = 2;            
        }
        else
        {
            // End:0xDE
            if(Type == "preview")
            {
                m_shopType = 3;                
            }
            else
            {
                m_shopType = 0;
            }
        }
    }
    adenaString = MakeCostString((Adena));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", adenaString);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", ConvertNumToText((Adena)));
    ShowWindow(m_WindowName);
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_WindowName);
    // End:0x291
    if(Type == "buy")
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType(m_WindowName $ ".TopList", "InventoryPrice1HideEnchantStackable");
        Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType(m_WindowName $ ".BottomList", "InventoryPrice1");
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 136);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".TopText", GetSystemString(137));
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".BottomText", GetSystemString(139));
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".PriceConstText", GetSystemString(142));        
    }
    else
    {
        // End:0x3A1
        if(Type == "sell")
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType(m_WindowName $ ".TopList", "InventoryPrice2");
            Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType(m_WindowName $ ".BottomList", "InventoryPrice2");
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 136);
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".TopText", GetSystemString(138));
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".BottomText", GetSystemString(137));
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".PriceConstText", GetSystemString(143));            
        }
        else
        {
            // End:0x4E6
            if(Type == "preview")
            {
                ParseInt(param, "npc", m_NpcID);
                Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType(m_WindowName $ ".TopList", "InventoryPrice1HideEnchantStackable");
                Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType(m_WindowName $ ".BottomList", "InventoryPrice1");
                Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 847);
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".TopText", GetSystemString(811));
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".BottomText", GetSystemString(812));
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".PriceConstText", GetSystemString(813));
            }
        }
    }
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
    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(m_WindowName $ ".TopList", Info);
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

    bottomCount = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum(m_WindowName $ ".BottomList");
    // End:0x269
    if(int(m_shopType) == int(1))
    {
        topCount = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum(m_WindowName $ ".TopList");
        topIndex = 0;
        J0x66:

        // End:0x199 [Loop If]
        if(topIndex < topCount)
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".TopList", topIndex, topInfo);
            // End:0x18F
            if(__NFUN_409__(topInfo.ItemNum, (0)))
            {
                limitedItemCount = (0);
                bottomCount = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum(m_WindowName $ ".BottomList");
                bottomIndex = 0;
                J0xEB:

                // End:0x160 [Loop If]
                if(bottomIndex < bottomCount)
                {
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".BottomList", bottomIndex, bottomInfo);
                    // End:0x156
                    if(IsSameClassID(bottomInfo.Id, topInfo.Id))
                    {
                        __NFUN_406__(limitedItemCount, bottomInfo.ItemNum);
                    }
                    ++bottomIndex;
                    // [Loop Continue]
                    goto J0xEB;
                }
                // End:0x18F
                if(__NFUN_409__(limitedItemCount, topInfo.ItemNum))
                {
                    DialogShow(1, 4, GetSystemMessage(1338), string(self));
                    return;
                }
            }
            ++topIndex;
            // [Loop Continue]
            goto J0x66;
        }
        ParamAdd(param, "merchant", string(m_merchantID));
        ParamAdd(param, "num", string(bottomCount));
        bottomIndex = 0;
        J0x1D3:

        // End:0x25B [Loop If]
        if(bottomIndex < bottomCount)
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".BottomList", bottomIndex, bottomInfo);
            ParamAddItemIDWithIndex(param, bottomInfo.Id, bottomIndex);
            ParamAdd(param, "Count_" $ string(bottomIndex), (bottomInfo.ItemNum));
            ++bottomIndex;
            // [Loop Continue]
            goto J0x1D3;
        }
        RequestBuyItem(param);        
    }
    else
    {
        // End:0x349
        if(int(m_shopType) == int(2))
        {
            ParamAdd(param, "merchant", string(m_merchantID));
            ParamAdd(param, "num", string(bottomCount));
            bottomIndex = 0;
            J0x2B3:

            // End:0x33B [Loop If]
            if(bottomIndex < bottomCount)
            {
                Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".BottomList", bottomIndex, bottomInfo);
                ParamAddItemIDWithIndex(param, bottomInfo.Id, bottomIndex);
                ParamAdd(param, "Count_" $ string(bottomIndex), (bottomInfo.ItemNum));
                ++bottomIndex;
                // [Loop Continue]
                goto J0x2B3;
            }
            RequestSellItem(param);            
        }
        else
        {
            // End:0x387
            if(int(m_shopType) == int(3))
            {
                // End:0x387
                if(bottomCount > 0)
                {
                    DialogSetID(333);
                    DialogShow(1, 4, GetSystemMessage(1157), string(self));
                }
            }
        }
    }
    HideWindow(m_WindowName);
    return;
}

defaultproperties
{
    m_WindowName="ShopWnd"
}