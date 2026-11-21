class ManorShopWnd extends SeedShopWnd;

var InventoryWnd inventoryWndScript;

function OnRegisterEvent()
{
    RegisterEvent(2680);
    RegisterEvent(2690);
    RegisterEvent(1710);
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
    inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x23
        case 2680:
            HandleOpenWindow(param);
            updateInventoryItemCountText();
            // End:0x5C
            break;
        // End:0x3F
        case 2690:
            HandleAddItem(param);
            updateInventoryItemCountText();
            // End:0x5C
            break;
        // End:0x56
        case 1710:
            HandleDialogOK();
            updateInventoryItemCountText();
            // End:0x5C
            break;
        // End:0xFFFF
        default:
            // End:0x5C
            break;
            break;
    }
    return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
    local int bottomIndex;
    local ItemInfo Info, bottomInfo;

    // End:0x423
    if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".TopList", Index, Info))
    {
        // End:0xEC
        if((!bAllItem && IsStackableItem(Info.ConsumeType)) && __NFUN_413__(Info.ItemNum, (1)))
        {
            DialogSetID(111);
            DialogSetReservedItemID(Info.Id);
            // End:0xAF
            if((int(m_shopType) == int(2)) || int(m_shopType) == int(1))
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
            // End:0x220
            if(int(m_shopType) == int(2))
            {
                bottomIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".BottomList", Info.Id);
                // End:0x1D0
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
                // End:0x38D
                if(int(m_shopType) == int(1))
                {
                    bottomIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(m_WindowName $ ".BottomList", Info.Id);
                    // End:0x2F7
                    if((bottomIndex >= 0) && IsStackableItem(Info.ConsumeType))
                    {
                        Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(m_WindowName $ ".BottomList", bottomIndex, bottomInfo);
                        __NFUN_406__(bottomInfo.ItemNum, Info.ItemNum);
                        Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem(m_WindowName $ ".BottomList", bottomIndex, bottomInfo);                        
                    }
                    else
                    {
                        Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(m_WindowName $ ".BottomList", Info);
                        Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight(m_WindowName $ ".InvenWeight", __NFUN_401__((Info.Weight), Info.ItemNum));
                    }
                    // End:0x38A
                    if(bAllItem)
                    {
                        Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem(m_WindowName $ ".TopList", Index);
                    }                    
                }
                else
                {
                    // End:0x406
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

function HandleOpenWindow(string param)
{
    super.HandleOpenWindow(param);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 738);
    Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType(m_WindowName $ ".TopList", "InventoryPrice1HideEnchant");
    return;
}

function HandleAddItem(string param)
{
    local ItemInfo Info;

    ParamToItemInfo(param, Info);
    Info.bShowCount = false;
    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(m_WindowName $ ".TopList", Info);
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
        RequestBuySeed(param);        
    }
    else
    {
        // End:0x33E
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
        }
        else
        {
            // End:0x37C
            if(int(m_shopType) == int(3))
            {
                // End:0x37C
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

function updateInventoryItemCountText()
{
    local int Count, invenCount;

    Count = inventoryWndScript.getCurrentInventoryItemCount();
    invenCount = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum(m_WindowName $ ".BottomList");
    GetTextBoxHandle(m_WindowName $ ".ItemCount").SetText(((("(" $ string(invenCount)) $ "/") $ string(Count)) $ ")");
    return;
}

function OnReceivedCloseUI()
{
    Clear();
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="ManorShopWnd"
}