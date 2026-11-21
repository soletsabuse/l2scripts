class WarehouseWnd extends UICommonAPI;

const KEEPING_PRICE = 30;
const DEFAULT_MAX_COUNT = 200;
const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;

enum WarehouseCategory
{
    WC_None,                        // 0
    WC_Private,                     // 1
    WC_Clan,                        // 2
    WC_Castle,                      // 3
    WC_Etc                          // 4
};

enum WarehouseType
{
    WT_Deposit,                     // 0
    WT_Withdraw                     // 1
};

var WarehouseWnd.WarehouseCategory m_category;
var WarehouseWnd.WarehouseType m_type;
var int m_maxPrivateCount;
var int m_maxInventoryCount;
var int m_curWarehouseCount;
var int m_curInventoryCount;
var int m_numPossibleSlotCount;
var string m_WindowName;
var ItemWindowHandle m_topList;
var ItemWindowHandle m_bottomList;
var WindowHandle m_dialogWnd;
var array<int> hasStackableItemArray;

function addHasStackableItemArray(int ClassID)
{
    // End:0x27
    if((findHasStackableItemArray(ClassID)) == -1)
    {
        hasStackableItemArray[hasStackableItemArray.Length] = ClassID;
    }
    return;
}

function int findHasStackableItemArray(int ClassID)
{
    local int i, returnV;

    returnV = -1;
    i = 0;
    J0x12:

    // End:0x4F [Loop If]
    if(i < hasStackableItemArray.Length)
    {
        // End:0x45
        if(hasStackableItemArray[i] == ClassID)
        {
            returnV = i;
            // [Explicit Break]
            goto J0x4F;
        }
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    J0x4F:

    return returnV;
    return;
}

function removeHasStackableItemArray(int ClassID)
{
    local int Index;

    Index = findHasStackableItemArray(ClassID);
    // End:0x2C
    if(Index != -1)
    {
        hasStackableItemArray.Remove(Index, 1);
    }
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(2100);
    RegisterEvent(2110);
    RegisterEvent(2111);
    RegisterEvent(2070);
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
    InitHandle();
    return;
}

function OnShow()
{
    hasStackableItemArray.Remove(0, hasStackableItemArray.Length);
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    PlayConsoleSound(5);
    return;
}

function OnHide()
{
    PlayConsoleSound(6);
    hasStackableItemArray.Remove(0, hasStackableItemArray.Length);
    return;
}

function InitHandle()
{
    // End:0x68
    if(1 == 0)
    {
        m_dialogWnd = GetHandle("DialogBox");
        m_topList = ItemWindowHandle(GetHandle(m_WindowName $ ".TopList"));
        m_bottomList = ItemWindowHandle(GetHandle(m_WindowName $ ".BottomList"));        
    }
    else
    {
        m_dialogWnd = GetWindowHandle("DialogBox");
        m_topList = GetItemWindowHandle(m_WindowName $ ".TopList");
        m_bottomList = GetItemWindowHandle(m_WindowName $ ".BottomList");
    }
    return;
}

function Clear()
{
    m_type = 0;
    m_category = 0;
    m_topList.super(WarehouseWnd).Clear();
    m_bottomList.super(WarehouseWnd).Clear();
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".PriceText", "0");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".PriceText", "");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", "0");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", "");
    Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight("WarehouseWnd.InvenWeight");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 2100:
            HandleOpenWindow(param);
            // End:0x76
            break;
        // End:0x33
        case 2110:
            HandleAddItem(param);
            // End:0x76
            break;
        // End:0x49
        case 2111:
            HandleDeleteItem(param);
            // End:0x76
            break;
        // End:0x5F
        case 2070:
            HandleSetMaxCount(param);
            // End:0x76
            break;
        // End:0x70
        case 1710:
            HandleDialogOK();
            // End:0x76
            break;
        // End:0xFFFF
        default:
            // End:0x76
            break;
            break;
    }
    return;
}

function OnClickButton(string ControlName)
{
    // End:0x1D
    if(ControlName == "OKButton")
    {
        HandleOKButton();        
    }
    else
    {
        // End:0x49
        if(ControlName == "CancelButton")
        {
            Clear();
            HideWindow(m_WindowName);            
        }
        else
        {
            // End:0x74
            if(ControlName == "SortButton")
            {
                getInstanceL2Util().SortItem(m_topList);
            }
        }
    }
    return;
}

function bool HasStackableItemCheck(int Category, int ItemClassID)
{
    local bool bReturn;

    bReturn = false;
    // End:0x6F
    if(int(m_type) == int(0))
    {
        bReturn = HasStackableItemInWareHouse(Category, ItemClassID);
        Debug((("HasStackableItemInWareHouse " @ string(Category)) @ " , ") @ string(ItemClassID));        
    }
    else
    {
        bReturn = HasStackableItemInInventory(Category, ItemClassID);
        Debug((("HasStackableItemInInventory " @ string(Category)) @ " , ") @ string(ItemClassID));
    }
    return bReturn;
    return;
}

function OnDBClickItem(string ControlName, int Index)
{
    local ItemInfo Info;
    local int nitemCount;

    // End:0x13B
    if(ControlName == "TopList")
    {
        // End:0x138
        if(Index >= 0)
        {
            m_topList.GetSelectedItem(Info);
            Debug("hasStackableItemArray.Length" @ string(hasStackableItemArray.Length));
            // End:0x95
            if(m_bottomList.GetItemNum() > 0)
            {
                nitemCount = m_bottomList.GetItemNum() - hasStackableItemArray.Length;                
            }
            else
            {
                nitemCount = 0;
            }
            // End:0x10F
            if((m_numPossibleSlotCount > nitemCount) || ((HasStackableItemCheck(int(m_category), Info.Id.ClassID)) && IsStackableItem(Info.ConsumeType)) && m_numPossibleSlotCount >= nitemCount)
            {
                MoveItemTopToBottom(Index, Class'NWindow.InputAPI'.static.IsAltPressed());                
            }
            else
            {
                // End:0x12D
                if(int(m_type) == int(0))
                {
                    AddSystemMessage(3674);                    
                }
                else
                {
                    AddSystemMessage(3675);
                }
            }
        }        
    }
    else
    {
        // End:0x16B
        if(ControlName == "BottomList")
        {
            MoveItemBottomToTop(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
        }
    }
    return;
}

function OnClickItem(string ControlName, int Index)
{
    // End:0x45
    if(ControlName == "TopList")
    {
        // End:0x45
        if((DialogIsMine()) && m_dialogWnd.IsShowWindow())
        {
            DialogHide();
            m_dialogWnd.HideWindow();
        }
    }
    return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
    local int Index, nitemCount;

    // End:0x73
    if((strID == "TopList") && Info.DragSrcName == "BottomList")
    {
        Index = m_bottomList.FindItemWithAllProperty(Info);
        // End:0x70
        if(Index >= 0)
        {
            MoveItemBottomToTop(Index, __NFUN_409__(Info.AllItemCount, (0)));
        }        
    }
    else
    {
        // End:0x1A1
        if((strID == "BottomList") && Info.DragSrcName == "TopList")
        {
            Index = m_topList.FindItemWithAllProperty(Info);
            // End:0xF2
            if(m_bottomList.GetItemNum() > 0)
            {
                nitemCount = m_bottomList.GetItemNum() - hasStackableItemArray.Length;                
            }
            else
            {
                nitemCount = 0;
            }
            // End:0x1A1
            if(Index >= 0)
            {
                // End:0x178
                if((m_numPossibleSlotCount > nitemCount) || ((HasStackableItemCheck(int(m_category), Info.Id.ClassID)) && IsStackableItem(Info.ConsumeType)) && m_numPossibleSlotCount >= nitemCount)
                {
                    MoveItemTopToBottom(Index, __NFUN_409__(Info.AllItemCount, (0)));                    
                }
                else
                {
                    // End:0x196
                    if(int(m_type) == int(0))
                    {
                        AddSystemMessage(3674);                        
                    }
                    else
                    {
                        AddSystemMessage(3675);
                    }
                }
            }
        }
    }
    return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
    local ItemInfo topInfo, bottomInfo;
    local int bottomIndex;

    // End:0x247
    if(m_topList.GetItem(Index, topInfo))
    {
        // End:0xA9
        if((!bAllItem && IsStackableItem(topInfo.ConsumeType)) && __NFUN_409__(topInfo.ItemNum, (1)))
        {
            DialogSetID(111);
            DialogSetReservedItemID(topInfo.Id);
            DialogSetParamInt64(topInfo.ItemNum);
            DialogSetDefaultOK();
            DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), topInfo.Name, ""), string(self));            
        }
        else
        {
            bottomIndex = m_bottomList.FindItem(topInfo.Id);
            // End:0x138
            if((bottomIndex != -1) && IsStackableItem(topInfo.ConsumeType))
            {
                m_bottomList.GetItem(bottomIndex, bottomInfo);
                __NFUN_406__(bottomInfo.ItemNum, topInfo.ItemNum);
                m_bottomList.SetItem(bottomIndex, bottomInfo);                
            }
            else
            {
                m_bottomList.AddItem(topInfo);
            }
            m_topList.DeleteItem(Index);
            // End:0x1B5
            if(int(m_type) == int(1))
            {
                Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("WarehouseWnd.InvenWeight", __NFUN_401__(topInfo.ItemNum, (topInfo.Weight)));                
            }
            else
            {
                // End:0x207
                if(int(m_type) == int(0))
                {
                    Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("WarehouseWnd.InvenWeight", __NFUN_401__(topInfo.ItemNum, (topInfo.Weight)));
                }
            }
            // End:0x23B
            if(HasStackableItemCheck(int(m_category), topInfo.Id.ClassID))
            {
                addHasStackableItemArray(topInfo.Id.ClassID);
            }
            AdjustPrice();
            AdjustCount();
        }
    }
    return;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
    local ItemInfo bottomInfo, topInfo;
    local int topIndex;

    // End:0x247
    if(m_bottomList.GetItem(Index, bottomInfo))
    {
        // End:0xA9
        if((!bAllItem && IsStackableItem(bottomInfo.ConsumeType)) && __NFUN_409__(bottomInfo.ItemNum, (1)))
        {
            DialogSetID(222);
            DialogSetReservedItemID(bottomInfo.Id);
            DialogSetParamInt64(bottomInfo.ItemNum);
            DialogSetDefaultOK();
            DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), bottomInfo.Name, ""), string(self));            
        }
        else
        {
            topIndex = m_topList.FindItem(bottomInfo.Id);
            // End:0x138
            if((topIndex != -1) && IsStackableItem(bottomInfo.ConsumeType))
            {
                m_topList.GetItem(topIndex, topInfo);
                __NFUN_406__(topInfo.ItemNum, bottomInfo.ItemNum);
                m_topList.SetItem(topIndex, topInfo);                
            }
            else
            {
                m_topList.AddItem(bottomInfo);
            }
            m_bottomList.DeleteItem(Index);
            // End:0x1B5
            if(int(m_type) == int(1))
            {
                Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("WarehouseWnd.InvenWeight", __NFUN_401__(bottomInfo.ItemNum, (bottomInfo.Weight)));                
            }
            else
            {
                // End:0x207
                if(int(m_type) == int(0))
                {
                    Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("WarehouseWnd.InvenWeight", __NFUN_401__(bottomInfo.ItemNum, (bottomInfo.Weight)));
                }
            }
            // End:0x23B
            if((findHasStackableItemArray(bottomInfo.Id.ClassID)) != -1)
            {
                removeHasStackableItemArray(bottomInfo.Id.ClassID);
            }
            AdjustPrice();
            AdjustCount();
        }
    }
    return;
}

function HandleDialogOK()
{
    local int Id, Index, topIndex;
    local INT64 Num;
    local ItemInfo Info, topInfo;
    local ItemID cID;

    // End:0x4C1
    if(DialogIsMine())
    {
        Id = DialogGetID();
        Num = (DialogGetString());
        cID = DialogGetReservedItemID();
        // End:0x275
        if((Id == 111) && __NFUN_409__(Num, (0)))
        {
            topIndex = m_topList.FindItem(cID);
            // End:0x272
            if(topIndex >= 0)
            {
                m_topList.GetItem(topIndex, topInfo);
                Num = Min64(Num, topInfo.ItemNum);
                Index = m_bottomList.FindItem(cID);
                // End:0x110
                if(Index >= 0)
                {
                    m_bottomList.GetItem(Index, Info);
                    __NFUN_406__(Info.ItemNum, Num);
                    m_bottomList.SetItem(Index, Info);                    
                }
                else
                {
                    Info = topInfo;
                    Info.ItemNum = Num;
                    Info.bShowCount = false;
                    m_bottomList.AddItem(Info);
                }
                // End:0x19C
                if(int(m_type) == int(1))
                {
                    Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("WarehouseWnd.InvenWeight", __NFUN_401__(Num, (Info.Weight)));                    
                }
                else
                {
                    // End:0x1E9
                    if(int(m_type) == int(0))
                    {
                        Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("WarehouseWnd.InvenWeight", __NFUN_401__(Num, (Info.Weight)));
                    }
                }
                __NFUN_407__(topInfo.ItemNum, Num);
                // End:0x225
                if(__NFUN_410__(topInfo.ItemNum, (0)))
                {
                    m_topList.DeleteItem(topIndex);                    
                }
                else
                {
                    m_topList.SetItem(topIndex, topInfo);
                }
                // End:0x272
                if(HasStackableItemCheck(int(m_category), topInfo.Id.ClassID))
                {
                    addHasStackableItemArray(topInfo.Id.ClassID);
                }
            }            
        }
        else
        {
            // End:0x4B5
            if((Id == 222) && __NFUN_409__(Num, (0)))
            {
                Index = m_bottomList.FindItem(cID);
                // End:0x4B5
                if(Index >= 0)
                {
                    m_bottomList.GetItem(Index, Info);
                    Num = Min64(Num, Info.ItemNum);
                    __NFUN_407__(Info.ItemNum, Num);
                    // End:0x32B
                    if(__NFUN_409__(Info.ItemNum, (0)))
                    {
                        m_bottomList.SetItem(Index, Info);                        
                    }
                    else
                    {
                        // End:0x35F
                        if((findHasStackableItemArray(Info.Id.ClassID)) != -1)
                        {
                            removeHasStackableItemArray(Info.Id.ClassID);
                        }
                        m_bottomList.DeleteItem(Index);
                    }
                    topIndex = m_topList.FindItem(cID);
                    // End:0x3F4
                    if((topIndex >= 0) && IsStackableItem(Info.ConsumeType))
                    {
                        m_topList.GetItem(topIndex, topInfo);
                        __NFUN_406__(topInfo.ItemNum, Num);
                        m_topList.SetItem(topIndex, topInfo);                        
                    }
                    else
                    {
                        Info.ItemNum = Num;
                        m_topList.AddItem(Info);
                    }
                    // End:0x468
                    if(int(m_type) == int(1))
                    {
                        Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("WarehouseWnd.InvenWeight", __NFUN_401__(Num, (Info.Weight)));                        
                    }
                    else
                    {
                        // End:0x4B5
                        if(int(m_type) == int(0))
                        {
                            Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("WarehouseWnd.InvenWeight", __NFUN_401__(Num, (Info.Weight)));
                        }
                    }
                }
            }
        }
        AdjustPrice();
        AdjustCount();
    }
    return;
}

function HandleOpenWindow(string param)
{
    local string Type;
    local int tmpInt, ItemCount;
    local string adenaString;
    local WindowHandle m_inventoryWnd;
    local INT64 Adena;

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
    ParseInt(param, "category", tmpInt);
    m_category = byte(tmpInt);
    ParseINT64(param, "adena", Adena);
    ParseInt(param, "itemCount", ItemCount);
    switch(m_category)
    {
        // End:0xDB
        case 1:
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 1216);
            // End:0x141
            break;
        // End:0xFC
        case 2:
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 1217);
            // End:0x141
            break;
        // End:0x11D
        case 3:
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 1218);
            // End:0x141
            break;
        // End:0x13B
        case 4:
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle(m_WindowName, 131);
            // End:0x141
            break;
        // End:0xFFFF
        default:
            // End:0x141
            break;
            break;
    }
    // End:0x16A
    if(Type == "deposit")
    {
        m_type = 0;
        m_curWarehouseCount = ItemCount;        
    }
    else
    {
        // End:0x191
        if(Type == "withdraw")
        {
            m_type = 1;
            m_curInventoryCount = ItemCount;
        }
    }
    adenaString = MakeCostString((Adena));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".AdenaText", adenaString);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".AdenaText", ConvertNumToText((Adena)));
    ShowWindow(m_WindowName);
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_WindowName);
    // End:0x27F
    if(int(m_type) == int(0))
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".TopText", GetSystemString(138));
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".BottomText", GetSystemString(132));        
    }
    else
    {
        // End:0x2E2
        if(int(m_type) == int(1))
        {
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".TopText", GetSystemString(132));
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".BottomText", GetSystemString(133));
        }
    }
    AdjustCount();
    ShowWindow(m_WindowName $ ".BottomCountText");
    return;
}

function HandleAddItem(string param)
{
    local ItemInfo Info;

    ParamToItemInfo(param, Info);
    m_topList.AddItem(Info);
    AdjustCount();
    return;
}

function HandleDeleteItem(string param)
{
    local int Index;
    local ItemInfo Info;

    ParamToItemInfo(param, Info);
    Index = m_topList.FindItem(Info.Id);
    // End:0x52
    if(Index != -1)
    {
        m_topList.DeleteItem(Index);
    }
    Index = m_bottomList.FindItem(Info.Id);
    // End:0x94
    if(Index != -1)
    {
        m_bottomList.DeleteItem(Index);
    }
    AdjustCount();
    return;
}

function AdjustPrice()
{
    local string Adena;
    local int Count;

    // End:0x96
    if(int(m_type) == int(0))
    {
        Count = m_bottomList.GetItemNum();
        Adena = MakeCostString(string(Count * 30));
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".PriceText", Adena);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString(m_WindowName $ ".PriceText", ConvertNumToText(string(Count * 30)));
    }
    return;
}

function AdjustCount()
{
    local int Num, maxNum, numPossibleSlot;

    // End:0x1E
    if(int(m_category) == int(1))
    {
        maxNum = m_maxPrivateCount;        
    }
    else
    {
        maxNum = 200;
    }
    // End:0xC1
    if(int(m_type) == int(0))
    {
        Num = m_bottomList.GetItemNum();
        numPossibleSlot = maxNum - m_curWarehouseCount;
        // End:0x6F
        if(numPossibleSlot < 0)
        {
            numPossibleSlot = 0;
        }
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".BottomCountText", ((("(" $ string(Num - hasStackableItemArray.Length)) $ "/") $ string(numPossibleSlot)) $ ")");        
    }
    else
    {
        // End:0x159
        if(int(m_type) == int(1))
        {
            Num = m_bottomList.GetItemNum();
            numPossibleSlot = m_maxInventoryCount - m_curInventoryCount;
            // End:0x10A
            if(numPossibleSlot < 0)
            {
                numPossibleSlot = 0;
            }
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(m_WindowName $ ".BottomCountText", ((("(" $ string(Num - hasStackableItemArray.Length)) $ "/") $ string(numPossibleSlot)) $ ")");
        }
    }
    m_numPossibleSlotCount = numPossibleSlot;
    return;
}

function HandleOKButton()
{
    local string param;
    local int bottomCount, bottomIndex;
    local ItemInfo bottomInfo;

    bottomCount = m_bottomList.GetItemNum();
    // End:0xD0
    if(int(m_type) == int(0))
    {
        ParamAdd(param, "num", string(bottomCount));
        bottomIndex = 0;
        J0x43:

        // End:0xC2 [Loop If]
        if(bottomIndex < bottomCount)
        {
            m_bottomList.GetItem(bottomIndex, bottomInfo);
            ParamAdd(param, "dbID" $ string(bottomIndex), string(bottomInfo.Reserved));
            ParamAdd(param, "count" $ string(bottomIndex), (bottomInfo.ItemNum));
            ++bottomIndex;
            // [Loop Continue]
            goto J0x43;
        }
        RequestWarehouseDeposit(param);        
    }
    else
    {
        // End:0x188
        if(int(m_type) == int(1))
        {
            ParamAdd(param, "num", string(bottomCount));
            bottomIndex = 0;
            J0xFE:

            // End:0x17D [Loop If]
            if(bottomIndex < bottomCount)
            {
                m_bottomList.GetItem(bottomIndex, bottomInfo);
                ParamAdd(param, "dbID" $ string(bottomIndex), string(bottomInfo.Reserved));
                ParamAdd(param, "count" $ string(bottomIndex), (bottomInfo.ItemNum));
                ++bottomIndex;
                // [Loop Continue]
                goto J0xFE;
            }
            RequestWarehouseWithdraw(param);
        }
    }
    RequestItemList();
    HideWindow(m_WindowName);
    return;
}

function HandleSetMaxCount(string param)
{
    ParseInt(param, "warehousePrivate", m_maxPrivateCount);
    ParseInt(param, "Inventory", m_maxInventoryCount);
    return;
}

function OnReceivedCloseUI()
{
    GetWindowHandle("WarehouseWnd").HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="WarehouseWnd"
}