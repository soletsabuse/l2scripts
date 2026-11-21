class PrivateShopWnd extends UICommonAPI;

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;
const DIALOG_ASK_PRICE = 333;
const DIALOG_CONFIRM_PRICE = 444;
const DIALOG_EDIT_SHOP_MESSAGE = 555;
const DIALOG_CONFIRM_PRICE_FINAL = 666;
const DIALOG_EDIT_BULK_SHOP_MESSAGE = 888;

enum PrivateShopType
{
    PT_NONE,                        // 0
    PT_Buy,                         // 1
    PT_Sell,                        // 2
    PT_BuyList,                     // 3
    PT_SellList                     // 4
};

var string m_WindowName;
var PrivateShopWnd.PrivateShopType m_type;
var bool m_bBulk;
var int m_merchantID;
var int m_buyMaxCount;
var int m_sellMaxCount;
var int m_curInventoryCount;
var int m_maxInventoryCount;
var int m_numPossibleSlotCount;
var PrivateShopWnd.PrivateShopType lastPrivateShopTypeSave;
var bool lastPrivateShopTypemBulk;
var bool stopSellFlag;
var ItemWindowHandle m_hPrivateShopWndTopList;
var ItemWindowHandle m_hPrivateShopWndBottomList;

function OnRegisterEvent()
{
    RegisterEvent(2120);
    RegisterEvent(2130);
    RegisterEvent(2070);
    RegisterEvent(1710);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    m_hPrivateShopWndTopList = GetItemWindowHandle("PrivateShopWnd.TopList");
    m_hPrivateShopWndBottomList = GetItemWindowHandle("PrivateShopWnd.BottomList");
    m_merchantID = 0;
    m_buyMaxCount = 0;
    m_sellMaxCount = 0;
    return;
}

function OnSendPacketWhenHiding()
{
    RequestQuit();
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    GetWindowHandle("PrivateShopWndReport").HideWindow();
    return;
}

function OnHide()
{
    local DialogBox DialogBox;

    lastPrivateShopTypeSave = m_type;
    lastPrivateShopTypemBulk = m_bBulk;
    DialogBox = DialogBox(GetScript("DialogBox"));
    // End:0x69
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("DialogBox"))
    {
        // End:0x69
        if(DialogIsMine())
        {
            DialogBox.HandleCancel();
        }
    }
    Clear();
    // End:0xB4
    if(GetWindowHandle("InventoryViewer").IsShowWindow())
    {
        GetWindowHandle("InventoryViewer").HideWindow();
    }
    return;
}

function contextMenuQuit()
{
    // End:0x1E
    if(int(lastPrivateShopTypeSave) == int(3))
    {
        ExecuteCommandFromAction("buy");        
    }
    else
    {
        // End:0x4C
        if((int(lastPrivateShopTypeSave) == int(4)) && !lastPrivateShopTypemBulk)
        {
            ExecuteCommandFromAction("vendor");            
        }
        else
        {
            // End:0x7C
            if((int(lastPrivateShopTypeSave) == int(4)) && lastPrivateShopTypemBulk)
            {
                ExecuteCommandFromAction("packagevendor");
            }
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x23
        case 2120:
            Clear();
            HandleOpenWindow(param);
            // End:0x66
            break;
        // End:0x39
        case 2130:
            HandleAddItem(param);
            // End:0x66
            break;
        // End:0x4F
        case 2070:
            HandleSetMaxCount(param);
            // End:0x66
            break;
        // End:0x60
        case 1710:
            HandleDialogOK();
            // End:0x66
            break;
        // End:0xFFFF
        default:
            // End:0x66
            break;
            break;
    }
    return;
}

function OnClickButton(string ControlName)
{
    local int Index;

    // End:0x38
    if(ControlName == "UpButton")
    {
        Index = m_hPrivateShopWndBottomList.GetSelectedNum();
        MoveItemBottomToTop(Index, false);        
    }
    else
    {
        // End:0x72
        if(ControlName == "DownButton")
        {
            Index = m_hPrivateShopWndTopList.GetSelectedNum();
            MoveItemTopToBottom(Index, false);            
        }
        else
        {
            // End:0x90
            if(ControlName == "OKButton")
            {
                HandleOKButton(true);                
            }
            else
            {
                // End:0xC5
                if(ControlName == "StopButton")
                {
                    RequestQuit();
                    HideWindow("PrivateShopWnd");                    
                }
                else
                {
                    // End:0x199
                    if(ControlName == "MessageButton")
                    {
                        DialogSetDefaultOK();
                        DialogSetEditBoxMaxLength(29);
                        DialogSetID(555);
                        DialogShow(1, 2, GetSystemMessage(334), string(self));
                        // End:0x141
                        if((int(m_type) == int(4)) && !m_bBulk)
                        {
                            DialogSetString(GetPrivateShopMessage("sell"));                            
                        }
                        else
                        {
                            // End:0x175
                            if((int(m_type) == int(4)) && m_bBulk)
                            {
                                DialogSetString(GetPrivateShopMessage("bulksell"));                                
                            }
                            else
                            {
                                // End:0x196
                                if(int(m_type) == int(3))
                                {
                                    DialogSetString(GetPrivateShopMessage("buy"));
                                }
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x1C7
                        if(ControlName == "SortButton")
                        {
                            getInstanceL2Util().SortItem(m_hPrivateShopWndTopList);                            
                        }
                        else
                        {
                            // End:0x210
                            if(ControlName == "InventoryViewerCall_Button")
                            {
                                getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle(getCurrentWindowName(string(self))), true);                                
                            }
                            else
                            {
                                // End:0x29F
                                if(ControlName == "history_Btn")
                                {
                                    // End:0x279
                                    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWndHistory"))
                                    {
                                        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PrivateShopWndHistory");                                        
                                    }
                                    else
                                    {
                                        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PrivateShopWndHistory");
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

function OnDBClickItem(string ControlName, int Index)
{
    local ItemInfo Info;

    // End:0x1AD
    if(ControlName == "TopList")
    {
        m_hPrivateShopWndTopList.GetSelectedItem(Info);
        // End:0xC0
        if((int(m_type) == int(1)) && m_bBulk == true)
        {
            // End:0x82
            if((m_hPrivateShopWndTopList.GetItemNum() <= m_numPossibleSlotCount) || IsStackableItem(Info.ConsumeType))
            {
                MoveItemTopToBottom(Index, false);                
            }
            else
            {
                // End:0xB2
                if((int(m_type) == int(2)) || int(m_type) == int(4))
                {
                    AddSystemMessage(3676);                    
                }
                else
                {
                    AddSystemMessage(3675);
                }
            }            
        }
        else
        {
            // End:0x151
            if((m_numPossibleSlotCount > m_hPrivateShopWndBottomList.GetItemNum()) || IsStackableItem(Info.ConsumeType) && int(m_type) != int(4))
            {
                // End:0x142
                if(IsStackableItem(Info.ConsumeType) && int(m_type) != int(2))
                {
                    MoveItemTopToBottom(Index, Class'NWindow.InputAPI'.static.IsAltPressed());                    
                }
                else
                {
                    MoveItemTopToBottom(Index, false);
                }                
            }
            else
            {
                // End:0x16F
                if(int(m_type) == int(3))
                {
                    AddSystemMessage(3676);                    
                }
                else
                {
                    // End:0x19F
                    if((int(m_type) == int(2)) || int(m_type) == int(4))
                    {
                        AddSystemMessage(3676);                        
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
        // End:0x1DD
        if(ControlName == "BottomList")
        {
            MoveItemBottomToTop(Index, Class'NWindow.InputAPI'.static.IsAltPressed());
        }
    }
    return;
}

function OnClickItem(string ControlName, int Index)
{
    local WindowHandle m_dialogWnd;

    m_dialogWnd = GetWindowHandle("DialogBox");
    // End:0x5C
    if(ControlName == "TopList")
    {
        // End:0x5C
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
    local int Index;

    Index = -1;
    // End:0xE4
    if((strID == "TopList") && Info.DragSrcName == "BottomList")
    {
        // End:0x7F
        if((int(m_type) == int(1)) || int(m_type) == int(4))
        {
            Index = m_hPrivateShopWndBottomList.FindItem(Info.Id);            
        }
        else
        {
            // End:0xBB
            if((int(m_type) == int(2)) || int(m_type) == int(3))
            {
                Index = m_hPrivateShopWndBottomList.FindItemWithAllProperty(Info);
            }
        }
        // End:0xE1
        if(Index >= 0)
        {
            MoveItemBottomToTop(Index, __NFUN_409__(Info.AllItemCount, (0)));
        }        
    }
    else
    {
        // End:0x331
        if((strID == "BottomList") && Info.DragSrcName == "TopList")
        {
            // End:0x158
            if((int(m_type) == int(1)) || int(m_type) == int(4))
            {
                Index = m_hPrivateShopWndTopList.FindItem(Info.Id);                
            }
            else
            {
                // End:0x194
                if((int(m_type) == int(2)) || int(m_type) == int(3))
                {
                    Index = m_hPrivateShopWndTopList.FindItemWithAllProperty(Info);
                }
            }
            // End:0x331
            if(Index >= 0)
            {
                // End:0x247
                if((int(m_type) == int(1)) && m_bBulk == true)
                {
                    // End:0x209
                    if((m_hPrivateShopWndTopList.GetItemNum() <= m_numPossibleSlotCount) || IsStackableItem(Info.ConsumeType))
                    {
                        MoveItemTopToBottom(Index, __NFUN_409__(Info.AllItemCount, (0)));                        
                    }
                    else
                    {
                        // End:0x239
                        if((int(m_type) == int(2)) || int(m_type) == int(4))
                        {
                            AddSystemMessage(3676);                            
                        }
                        else
                        {
                            AddSystemMessage(3675);
                        }
                    }                    
                }
                else
                {
                    // End:0x2D8
                    if((m_numPossibleSlotCount > m_hPrivateShopWndBottomList.GetItemNum()) || IsStackableItem(Info.ConsumeType) && int(m_type) != int(4))
                    {
                        // End:0x2C9
                        if(IsStackableItem(Info.ConsumeType) && int(m_type) != int(2))
                        {
                            MoveItemTopToBottom(Index, Class'NWindow.InputAPI'.static.IsAltPressed());                            
                        }
                        else
                        {
                            MoveItemTopToBottom(Index, false);
                        }                        
                    }
                    else
                    {
                        // End:0x2F6
                        if(int(m_type) == int(3))
                        {
                            AddSystemMessage(3676);                            
                        }
                        else
                        {
                            // End:0x326
                            if((int(m_type) == int(2)) || int(m_type) == int(4))
                            {
                                AddSystemMessage(3676);                                
                            }
                            else
                            {
                                AddSystemMessage(3675);
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function Clear()
{
    m_type = 0;
    m_merchantID = -1;
    m_bBulk = false;
    m_hPrivateShopWndTopList.super(PrivateShopWnd).Clear();
    m_hPrivateShopWndBottomList.super(PrivateShopWnd).Clear();
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceText", "0");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.PriceText", "");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.AdenaText", "0");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.AdenaText", "");
    return;
}

function RequestQuit()
{
    // End:0x1E
    if(int(m_type) == int(3))
    {
        RequestQuitPrivateShop("buy");        
    }
    else
    {
        // End:0x4A
        if((int(m_type) == int(4)) && !m_bBulk)
        {
            RequestQuitPrivateShop("sell");            
        }
        else
        {
            // End:0x75
            if((int(m_type) == int(4)) && m_bBulk)
            {
                RequestQuitPrivateShop("bulksell");
            }
        }
    }
    return;
}

function MoveItemTopToBottom(int Index, bool bAllItem)
{
    local ItemInfo Info, bottomInfo;
    local int Num, i, bottomIndex;

    // End:0x403
    if(m_hPrivateShopWndTopList.GetItem(Index, Info))
    {
        // End:0x91
        if(int(m_type) == int(4))
        {
            DialogSetID(333);
            DialogSetReservedItemID(Info.Id);
            DialogSetReservedInt3(int(bAllItem));
            DialogSetEditType("number");
            DialogSetParamInt64((-1));
            DialogSetDefaultOK();
            DialogShow(1, 6, GetSystemMessage(322), string(self));            
        }
        else
        {
            // End:0xF3
            if(int(m_type) == int(3))
            {
                DialogSetID(333);
                DialogSetReservedItemInfo(Info);
                DialogSetEditType("number");
                DialogSetParamInt64((-1));
                DialogSetDefaultOK();
                DialogShow(1, 6, GetSystemMessage(585), string(self));                
            }
            else
            {
                // End:0x403
                if((int(m_type) == int(2)) || int(m_type) == int(1))
                {
                    // End:0x139
                    if((int(m_type) == int(2)) && Info.bDisabled > 0)
                    {
                        return;
                    }
                    // End:0x1D4
                    if((int(m_type) == int(1)) && m_bBulk)
                    {
                        Num = m_hPrivateShopWndTopList.GetItemNum();
                        i = 0;
                        J0x170:

                        // End:0x1B6 [Loop If]
                        if(i < Num)
                        {
                            m_hPrivateShopWndTopList.GetItem(i, Info);
                            m_hPrivateShopWndBottomList.AddItem(Info);
                            ++i;
                            // [Loop Continue]
                            goto J0x170;
                        }
                        m_hPrivateShopWndTopList.Clear();
                        AdjustPrice();
                        AdjustCount();                        
                    }
                    else
                    {
                        // End:0x2DF
                        if((!bAllItem && IsStackableItem(Info.ConsumeType)) && __NFUN_409__(Info.ItemNum, (1)))
                        {
                            DialogSetID(111);
                            // End:0x22F
                            if(int(m_type) == int(2))
                            {
                                DialogSetReservedItemInfo(Info);                                
                            }
                            else
                            {
                                // End:0x24F
                                if(int(m_type) == int(1))
                                {
                                    DialogSetReservedItemID(Info.Id);
                                }
                            }
                            // End:0x29F
                            if(int(m_type) == int(2))
                            {
                                // End:0x28C
                                if(__NFUN_411__(Info.ItemNum, Info.Reserved64))
                                {
                                    DialogSetParamInt64(Info.Reserved64);                                    
                                }
                                else
                                {
                                    DialogSetParamInt64(Info.ItemNum);
                                }                                
                            }
                            else
                            {
                                DialogSetParamInt64(Info.ItemNum);
                            }
                            DialogSetDefaultOK();
                            DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));                            
                        }
                        else
                        {
                            // End:0x311
                            if(int(m_type) == int(1))
                            {
                                bottomIndex = m_hPrivateShopWndBottomList.FindItem(Info.Id);                                
                            }
                            else
                            {
                                // End:0x33B
                                if(int(m_type) == int(2))
                                {
                                    bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty(Info);
                                }
                            }
                            // End:0x3A7
                            if((bottomIndex >= 0) && IsStackableItem(Info.ConsumeType))
                            {
                                m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
                                __NFUN_406__(bottomInfo.ItemNum, Info.ItemNum);
                                m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);                                
                            }
                            else
                            {
                                m_hPrivateShopWndBottomList.AddItem(Info);
                            }
                            m_hPrivateShopWndTopList.DeleteItem(Index);
                            AdjustPrice();
                            AdjustCount();
                        }
                    }
                    // End:0x403
                    if((int(m_type) == int(1)) || int(m_type) == int(3))
                    {
                        AdjustWeight();
                    }
                }
            }
        }
    }
    return;
}

function MoveItemBottomToTop(int Index, bool bAllItem)
{
    local ItemInfo Info, topInfo;
    local int stringIndex, Num, i, topIndex;

    // End:0x32F
    if(m_hPrivateShopWndBottomList.GetItem(Index, Info))
    {
        // End:0xB7
        if((int(m_type) == int(1)) && m_bBulk)
        {
            Num = m_hPrivateShopWndBottomList.GetItemNum();
            i = 0;
            J0x53:

            // End:0x99 [Loop If]
            if(i < Num)
            {
                m_hPrivateShopWndBottomList.GetItem(i, Info);
                m_hPrivateShopWndTopList.AddItem(Info);
                ++i;
                // [Loop Continue]
                goto J0x53;
            }
            m_hPrivateShopWndBottomList.Clear();
            AdjustPrice();
            AdjustCount();            
        }
        else
        {
            // End:0x1E9
            if((!bAllItem && IsStackableItem(Info.ConsumeType)) && __NFUN_409__(Info.ItemNum, (1)))
            {
                DialogSetID(222);
                // End:0x129
                if((int(m_type) == int(1)) || int(m_type) == int(4))
                {
                    DialogSetReservedItemID(Info.Id);                    
                }
                else
                {
                    // End:0x156
                    if((int(m_type) == int(2)) || int(m_type) == int(3))
                    {
                        DialogSetReservedItemInfo(Info);
                    }
                }
                switch(m_type)
                {
                    // End:0x16D
                    case 4:
                        stringIndex = 72;
                        // End:0x1A6
                        break;
                    // End:0x180
                    case 3:
                        stringIndex = 571;
                        // End:0x1A6
                        break;
                    // End:0x190
                    case 2:
                        stringIndex = 72;
                        // End:0x1A6
                        break;
                    // End:0x1A0
                    case 1:
                        stringIndex = 72;
                        // End:0x1A6
                        break;
                    // End:0xFFFF
                    default:
                        // End:0x1A6
                        break;
                        break;
                }
                DialogSetParamInt64(Info.ItemNum);
                DialogSetDefaultOK();
                DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(stringIndex), Info.Name, ""), string(self));                
            }
            else
            {
                m_hPrivateShopWndBottomList.DeleteItem(Index);
                // End:0x2FB
                if(int(m_type) != int(3))
                {
                    // End:0x251
                    if((int(m_type) == int(1)) || int(m_type) == int(4))
                    {
                        topIndex = m_hPrivateShopWndTopList.FindItem(Info.Id);                        
                    }
                    else
                    {
                        // End:0x27B
                        if(int(m_type) == int(2))
                        {
                            topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(Info);
                        }
                    }
                    // End:0x2E7
                    if((topIndex >= 0) && IsStackableItem(Info.ConsumeType))
                    {
                        m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
                        __NFUN_406__(topInfo.ItemNum, Info.ItemNum);
                        m_hPrivateShopWndTopList.SetItem(topIndex, topInfo);                        
                    }
                    else
                    {
                        m_hPrivateShopWndTopList.AddItem(Info);
                    }
                }
                AdjustPrice();
                AdjustCount();
            }
        }
        // End:0x32F
        if((int(m_type) == int(1)) || int(m_type) == int(3))
        {
            AdjustWeight();
        }
    }
    return;
}

function HandleDialogOK()
{
    local int Id, bottomIndex, topIndex, i, allItem;

    local ItemInfo bottomInfo, topInfo;
    local ItemID scID;
    local ItemInfo scInfo;
    local INT64 inputNum;
    local int currentItemNum;
    local bool enableAddCurrentItemFlag;

    currentItemNum = 0;
    // End:0x12D4
    if(DialogIsMine())
    {
        Id = DialogGetID();
        inputNum = (DialogGetString());
        scID = DialogGetReservedItemID();
        DialogGetReservedItemInfo(scInfo);
        // End:0x82F
        if(int(m_type) == int(4))
        {
            // End:0x201
            if((Id == 111) && __NFUN_409__(inputNum, (0)))
            {
                topIndex = m_hPrivateShopWndTopList.FindItem(scID);
                // End:0x1F2
                if(topIndex >= 0)
                {
                    m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
                    bottomIndex = m_hPrivateShopWndBottomList.FindItem(scID);
                    m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
                    // End:0x14D
                    if((bottomIndex >= 0) && IsStackableItem(bottomInfo.ConsumeType))
                    {
                        bottomInfo.Price = DialogGetReservedInt2();
                        __NFUN_406__(bottomInfo.ItemNum, Min64(inputNum, topInfo.ItemNum));
                        m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);                        
                    }
                    else
                    {
                        bottomInfo = topInfo;
                        bottomInfo.ItemNum = Min64(inputNum, topInfo.ItemNum);
                        bottomInfo.Price = DialogGetReservedInt2();
                        m_hPrivateShopWndBottomList.AddItem(bottomInfo);
                    }
                    __NFUN_407__(topInfo.ItemNum, inputNum);
                    // End:0x1D9
                    if(__NFUN_410__(topInfo.ItemNum, (0)))
                    {
                        m_hPrivateShopWndTopList.DeleteItem(topIndex);                        
                    }
                    else
                    {
                        m_hPrivateShopWndTopList.SetItem(topIndex, topInfo);
                    }
                }
                AdjustPrice();
                AdjustCount();                
            }
            else
            {
                // End:0x38F
                if((Id == 222) && __NFUN_409__(inputNum, (0)))
                {
                    bottomIndex = m_hPrivateShopWndBottomList.FindItem(scID);
                    // End:0x380
                    if(bottomIndex >= 0)
                    {
                        m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
                        topIndex = m_hPrivateShopWndTopList.FindItem(scID);
                        // End:0x2EC
                        if((topIndex >= 0) && IsStackableItem(bottomInfo.ConsumeType))
                        {
                            m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
                            __NFUN_406__(topInfo.ItemNum, Min64(inputNum, bottomInfo.ItemNum));
                            m_hPrivateShopWndTopList.SetItem(topIndex, topInfo);                            
                        }
                        else
                        {
                            topInfo = bottomInfo;
                            topInfo.ItemNum = Min64(inputNum, bottomInfo.ItemNum);
                            m_hPrivateShopWndTopList.AddItem(topInfo);
                        }
                        __NFUN_407__(bottomInfo.ItemNum, inputNum);
                        // End:0x36C
                        if(__NFUN_409__(bottomInfo.ItemNum, (0)))
                        {
                            m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);                            
                        }
                        else
                        {
                            m_hPrivateShopWndBottomList.DeleteItem(bottomIndex);
                        }
                    }
                    AdjustPrice();
                    AdjustCount();                    
                }
                else
                {
                    // End:0x572
                    if(Id == 444)
                    {
                        topIndex = m_hPrivateShopWndTopList.FindItem(scID);
                        // End:0x56F
                        if(topIndex >= 0)
                        {
                            allItem = DialogGetReservedInt3();
                            m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
                            // End:0x486
                            if(((allItem == 0) && IsStackableItem(topInfo.ConsumeType)) && __NFUN_413__(topInfo.ItemNum, (1)))
                            {
                                DialogSetID(111);
                                // End:0x446
                                if(__NFUN_412__(topInfo.ItemNum, (0)))
                                {
                                    topInfo.ItemNum = (1);
                                }
                                DialogSetParamInt64(topInfo.ItemNum);
                                DialogSetDefaultOK();
                                DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), topInfo.Name, ""), string(self));                                
                            }
                            else
                            {
                                // End:0x49F
                                if(allItem == 0)
                                {
                                    topInfo.ItemNum = (1);
                                }
                                topInfo.Price = DialogGetReservedInt2();
                                bottomIndex = m_hPrivateShopWndBottomList.FindItem(topInfo.Id);
                                // End:0x53B
                                if((bottomIndex >= 0) && IsStackableItem(topInfo.ConsumeType))
                                {
                                    m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
                                    __NFUN_406__(topInfo.ItemNum, bottomInfo.ItemNum);
                                    m_hPrivateShopWndBottomList.SetItem(bottomIndex, topInfo);                                    
                                }
                                else
                                {
                                    m_hPrivateShopWndBottomList.AddItem(topInfo);
                                }
                                m_hPrivateShopWndTopList.DeleteItem(topIndex);
                                AdjustPrice();
                                AdjustCount();
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x7E7
                        if((Id == 333) && __NFUN_409__(inputNum, (0)))
                        {
                            topIndex = m_hPrivateShopWndTopList.FindItem(scID);
                            // End:0x7E4
                            if(topIndex >= 0)
                            {
                                m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
                                // End:0x606
                                if(__NFUN_411__(inputNum, ("1000000000000")))
                                {
                                    DialogShow(1, 5, GetSystemMessage(1369), string(self));                                    
                                }
                                else
                                {
                                    // End:0x662
                                    if(!IsProperPrice(topInfo, inputNum))
                                    {
                                        DialogSetID(444);
                                        DialogSetReservedItemID(topInfo.Id);
                                        DialogSetReservedInt2(inputNum);
                                        DialogSetDefaultOK();
                                        DialogShow(1, 4, GetSystemMessage(569), string(self));                                        
                                    }
                                    else
                                    {
                                        allItem = DialogGetReservedInt3();
                                        // End:0x6FC
                                        if((allItem == 0) && IsStackableItem(topInfo.ConsumeType))
                                        {
                                            DialogSetID(111);
                                            DialogSetReservedItemID(topInfo.Id);
                                            DialogSetReservedInt2(inputNum);
                                            DialogSetReservedInt3(allItem);
                                            DialogSetParamInt64(topInfo.ItemNum);
                                            DialogSetDefaultOK();
                                            DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), topInfo.Name, ""), string(self));                                            
                                        }
                                        else
                                        {
                                            // End:0x715
                                            if(allItem == 0)
                                            {
                                                topInfo.ItemNum = (1);
                                            }
                                            topInfo.Price = inputNum;
                                            bottomIndex = m_hPrivateShopWndBottomList.FindItem(topInfo.Id);
                                            // End:0x7B0
                                            if((bottomIndex >= 0) && IsStackableItem(topInfo.ConsumeType))
                                            {
                                                m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
                                                __NFUN_406__(topInfo.ItemNum, bottomInfo.ItemNum);
                                                m_hPrivateShopWndBottomList.SetItem(bottomIndex, topInfo);                                                
                                            }
                                            else
                                            {
                                                m_hPrivateShopWndBottomList.AddItem(topInfo);
                                            }
                                            m_hPrivateShopWndTopList.DeleteItem(topIndex);
                                            AdjustPrice();
                                            AdjustCount();
                                        }
                                    }
                                }
                            }                            
                        }
                        else
                        {
                            // End:0x82C
                            if(Id == 555)
                            {
                                // End:0x816
                                if(!m_bBulk)
                                {
                                    SetPrivateShopMessage("sell", DialogGetString());                                    
                                }
                                else
                                {
                                    SetPrivateShopMessage("bulksell", DialogGetString());
                                }
                            }
                        }
                    }
                }
            }            
        }
        else
        {
            // End:0xE18
            if(int(m_type) == int(3))
            {
                // End:0xB39
                if((Id == 111) && __NFUN_409__(inputNum, (0)))
                {
                    topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(scInfo);
                    // End:0xB24
                    if(topIndex >= 0)
                    {
                        m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
                        bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty(scInfo);
                        m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
                        // End:0x930
                        if((bottomIndex >= 0) && IsStackableItem(bottomInfo.ConsumeType))
                        {
                            bottomInfo.Price = DialogGetReservedInt2();
                            __NFUN_406__(bottomInfo.ItemNum, inputNum);
                            m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);
                            AdjustPrice();
                            return;
                        }
                        i = m_hPrivateShopWndBottomList.GetItemNum();
                        // End:0x9BF
                        if(bottomIndex >= 0)
                        {
                            i = m_hPrivateShopWndBottomList.GetItemNum();
                            J0x965:

                            // End:0x9BF [Loop If]
                            if(i >= 0)
                            {
                                m_hPrivateShopWndBottomList.GetItem(i, bottomInfo);
                                // End:0x9B5
                                if(IsSameClassID(bottomInfo.Id, scID))
                                {
                                    m_hPrivateShopWndBottomList.DeleteItem(i);
                                }
                                --i;
                                // [Loop Continue]
                                goto J0x965;
                            }
                        }
                        currentItemNum = i;
                        enableAddCurrentItemFlag = false;
                        // End:0xA42
                        if(IsStackableItem(topInfo.ConsumeType))
                        {
                            // End:0xA3F
                            if((currentItemNum + 1) <= m_buyMaxCount)
                            {
                                bottomInfo = topInfo;
                                bottomInfo.ItemNum = inputNum;
                                bottomInfo.Price = DialogGetReservedInt2();
                                m_hPrivateShopWndBottomList.AddItem(bottomInfo);
                                enableAddCurrentItemFlag = true;
                            }                            
                        }
                        else
                        {
                            // End:0xA62
                            if(currentItemNum < 0)
                            {
                                currentItemNum = m_hPrivateShopWndBottomList.GetItemNum();
                            }
                            // End:0xB00
                            if(__NFUN_410__(__NFUN_404__((currentItemNum), inputNum), (m_buyMaxCount)))
                            {
                                bottomInfo = topInfo;
                                bottomInfo.ItemNum = (1);
                                bottomInfo.Price = DialogGetReservedInt2();
                                i = 0;
                                J0xAAF:

                                // End:0xB00 [Loop If]
                                if(__NFUN_408__((i), inputNum))
                                {
                                    // End:0xAF6
                                    if(m_hPrivateShopWndBottomList.GetItemNum() < m_buyMaxCount)
                                    {
                                        m_hPrivateShopWndBottomList.AddItem(bottomInfo);
                                        enableAddCurrentItemFlag = true;
                                    }
                                    ++i;
                                    // [Loop Continue]
                                    goto J0xAAF;
                                }
                            }
                        }
                        // End:0xB24
                        if(enableAddCurrentItemFlag == false)
                        {
                            DialogShow(1, 5, GetSystemMessage(351), string(self));
                        }
                    }
                    AdjustWeight();
                    AdjustPrice();
                    AdjustCount();                    
                }
                else
                {
                    // End:0xBEB
                    if((Id == 222) && __NFUN_409__(inputNum, (0)))
                    {
                        bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty(scInfo);
                        // End:0xBE8
                        if(bottomIndex >= 0)
                        {
                            m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
                            __NFUN_407__(bottomInfo.ItemNum, inputNum);
                            // End:0xBD4
                            if(__NFUN_409__(bottomInfo.ItemNum, (0)))
                            {
                                m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);                                
                            }
                            else
                            {
                                m_hPrivateShopWndBottomList.DeleteItem(bottomIndex);
                            }
                        }                        
                    }
                    else
                    {
                        // End:0xC9F
                        if(Id == 444)
                        {
                            topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(scInfo);
                            // End:0xC90
                            if(topIndex >= 0)
                            {
                                m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
                                DialogSetID(111);
                                DialogSetReservedItemID(topInfo.Id);
                                DialogSetParamInt64(topInfo.ItemNum);
                                DialogSetDefaultOK();
                                DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(570), topInfo.Name, ""), string(self));
                            }
                            AdjustPrice();
                            AdjustCount();                            
                        }
                        else
                        {
                            // End:0xDF5
                            if((Id == 333) && __NFUN_409__(inputNum, (0)))
                            {
                                topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(scInfo);
                                // End:0xDF2
                                if(topIndex >= 0)
                                {
                                    m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
                                    // End:0xD33
                                    if(__NFUN_411__(inputNum, ("1000000000000")))
                                    {
                                        DialogShow(1, 5, GetSystemMessage(1369), string(self));                                        
                                    }
                                    else
                                    {
                                        // End:0xD8F
                                        if(!IsProperPrice(topInfo, inputNum))
                                        {
                                            DialogSetID(444);
                                            DialogSetReservedItemID(topInfo.Id);
                                            DialogSetReservedInt2(inputNum);
                                            DialogSetDefaultOK();
                                            DialogShow(1, 4, GetSystemMessage(569), string(self));                                            
                                        }
                                        else
                                        {
                                            DialogSetID(111);
                                            DialogSetReservedItemID(topInfo.Id);
                                            DialogSetReservedInt2(inputNum);
                                            DialogSetParamInt64(topInfo.ItemNum);
                                            DialogSetDefaultOK();
                                            DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(570), topInfo.Name, ""), string(self));
                                        }
                                    }
                                }                                
                            }
                            else
                            {
                                // End:0xE15
                                if(Id == 555)
                                {
                                    SetPrivateShopMessage("buy", DialogGetString());
                                }
                            }
                        }
                    }
                }                
            }
            else
            {
                // End:0x12A6
                if((int(m_type) == int(1)) || int(m_type) == int(2))
                {
                    // End:0x1087
                    if((Id == 111) && __NFUN_409__(inputNum, (0)))
                    {
                        topIndex = -1;
                        // End:0xE8E
                        if(int(m_type) == int(1))
                        {
                            topIndex = m_hPrivateShopWndTopList.FindItem(scID);                            
                        }
                        else
                        {
                            // End:0xEB8
                            if(int(m_type) == int(2))
                            {
                                topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(scInfo);
                            }
                        }
                        // End:0x1078
                        if(topIndex >= 0)
                        {
                            m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
                            // End:0xF09
                            if(int(m_type) == int(1))
                            {
                                bottomIndex = m_hPrivateShopWndBottomList.FindItem(scID);                                
                            }
                            else
                            {
                                // End:0xF33
                                if(int(m_type) == int(2))
                                {
                                    bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty(scInfo);
                                }
                            }
                            m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
                            // End:0xF9B
                            if((int(m_type) == int(2)) && __NFUN_408__(topInfo.Reserved64, __NFUN_404__(inputNum, bottomInfo.ItemNum)))
                            {
                                DialogShow(1, 5, GetSystemMessage(1036), string(self));                                
                            }
                            else
                            {
                                // End:0xFE4
                                if(bottomIndex >= 0)
                                {
                                    __NFUN_406__(bottomInfo.ItemNum, Min64(inputNum, topInfo.ItemNum));
                                    m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);                                    
                                }
                                else
                                {
                                    bottomInfo = topInfo;
                                    bottomInfo.ItemNum = Min64(inputNum, topInfo.ItemNum);
                                    m_hPrivateShopWndBottomList.AddItem(bottomInfo);
                                }
                                __NFUN_407__(topInfo.ItemNum, inputNum);
                                // End:0x105F
                                if(__NFUN_410__(topInfo.ItemNum, (0)))
                                {
                                    m_hPrivateShopWndTopList.DeleteItem(topIndex);                                    
                                }
                                else
                                {
                                    m_hPrivateShopWndTopList.SetItem(topIndex, topInfo);
                                }
                            }
                        }
                        AdjustPrice();
                        AdjustCount();                        
                    }
                    else
                    {
                        // End:0x1290
                        if((Id == 222) && __NFUN_409__(inputNum, (0)))
                        {
                            bottomIndex = -1;
                            // End:0x10DB
                            if(int(m_type) == int(1))
                            {
                                bottomIndex = m_hPrivateShopWndBottomList.FindItem(scID);                                
                            }
                            else
                            {
                                // End:0x1105
                                if(int(m_type) == int(2))
                                {
                                    bottomIndex = m_hPrivateShopWndBottomList.FindItemWithAllProperty(scInfo);
                                }
                            }
                            // End:0x1281
                            if(bottomIndex >= 0)
                            {
                                m_hPrivateShopWndBottomList.GetItem(bottomIndex, bottomInfo);
                                topIndex = -1;
                                // End:0x1161
                                if(int(m_type) == int(1))
                                {
                                    topIndex = m_hPrivateShopWndTopList.FindItem(scID);                                    
                                }
                                else
                                {
                                    // End:0x118B
                                    if(int(m_type) == int(2))
                                    {
                                        topIndex = m_hPrivateShopWndTopList.FindItemWithAllProperty(scInfo);
                                    }
                                }
                                // End:0x11ED
                                if(topIndex >= 0)
                                {
                                    m_hPrivateShopWndTopList.GetItem(topIndex, topInfo);
                                    __NFUN_406__(topInfo.ItemNum, Min64(inputNum, bottomInfo.ItemNum));
                                    m_hPrivateShopWndTopList.SetItem(topIndex, topInfo);                                    
                                }
                                else
                                {
                                    topInfo = bottomInfo;
                                    topInfo.ItemNum = Min64(inputNum, bottomInfo.ItemNum);
                                    m_hPrivateShopWndTopList.AddItem(topInfo);
                                }
                                __NFUN_407__(bottomInfo.ItemNum, inputNum);
                                // End:0x126D
                                if(__NFUN_409__(bottomInfo.ItemNum, (0)))
                                {
                                    m_hPrivateShopWndBottomList.SetItem(bottomIndex, bottomInfo);                                    
                                }
                                else
                                {
                                    m_hPrivateShopWndBottomList.DeleteItem(bottomIndex);
                                }
                            }
                            AdjustPrice();
                            AdjustCount();                            
                        }
                        else
                        {
                            // End:0x12A6
                            if(Id == 666)
                            {
                                HandleOKButton(false);
                            }
                        }
                    }
                }
            }
        }
        // End:0x12D4
        if((int(m_type) == int(1)) || int(m_type) == int(3))
        {
            AdjustWeight();
            AdjustPrice();
        }
    }
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

function HandleOpenWindow(string param)
{
    local string Type;
    local int bulk;
    local string adenaString;
    local UserInfo User;
    local INT64 Adena;

    Clear();
    ParseString(param, "type", Type);
    ParseINT64(param, "adena", Adena);
    ParseInt(param, "userID", m_merchantID);
    ParseInt(param, "bulk", bulk);
    ParseInt(param, "nInventoryItemCount", m_curInventoryCount);
    // End:0x136
    if(bulk > 0)
    {
        m_bBulk = true;
        GetTextureHandle("PrivateShopWnd.Arrow").SetTexture("L2UI_CT1.PrivateShop_DF_Arrow");
        GetTextureHandle("PrivateShopWnd.BottomListBg").SetTexture("L2UI_CT1.PrivateShop_DF_GroupBox");
        SwithBulkOnlyShop();        
    }
    else
    {
        m_bBulk = false;
        GetTextureHandle("PrivateShopWnd.Arrow").SetTexture("L2UI_CT1.ShopWnd_DF_Arrow");
        GetTextureHandle("PrivateShopWnd.BottomListBg").SetTexture("L2UI_CT1.GroupBox.GroupBox_DF");
        ResetBulkOnlyShop();
    }
    Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.MessageButton", 2331);
    switch(Type)
    {
        // End:0x247
        case "buy":
            m_type = 1;
            // End:0x244
            if(!stopSellFlag)
            {
                getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle(getCurrentWindowName(string(self))));
            }
            // End:0x2BA
            break;
        // End:0x285
        case "sell":
            m_type = 2;
            // End:0x282
            if(!stopSellFlag)
            {
                getInstanceInventoryViewer().showWindowByParentWindow(GetWindowHandle(getCurrentWindowName(string(self))));
            }
            // End:0x2BA
            break;
        // End:0x29C
        case "buyList":
            m_type = 3;
            // End:0x2BA
            break;
        // End:0x2B4
        case "sellList":
            m_type = 4;
            // End:0x2BA
            break;
        // End:0xFFFF
        default:
            // End:0x2BA
            break;
            break;
    }
    // End:0x2D3
    if(stopSellFlag)
    {
        stopSellFlag = false;
        RequestQuit();
        return;
    }
    adenaString = MakeCostString((Adena));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.AdenaText", adenaString);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.AdenaText", ConvertNumToText((Adena)));
    // End:0x38B
    if(param != "")
    {
        ShowWindow("PrivateShopWnd");
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PrivateShopWnd");
    }
    // End:0x646
    if(int(m_type) == int(3))
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.TopList", "Inventory");
        Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.BottomList", "InventoryStackableUnitPrice");
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.TopText", GetSystemString(1));
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomText", GetSystemString(502));
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceConstText", GetSystemString(142));
        Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 428);
        ShowWindow("PrivateShopWnd.BottomCountText");
        ShowWindow("PrivateShopWnd.StopButton");
        ShowWindow("PrivateShopWnd.MessageButton");
        ShowWindow("PrivateShopWnd.OKButton");
        HideWindow("PrivateShopWnd.CheckBulk");
        ShowWindow("PrivateShopWnd.history_Btn");
        Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.StopButton", 2328);
        Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 2327);
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("PrivateShopWnd", ((GetSystemString(498) $ "(") $ GetSystemString(1434)) $ ")");        
    }
    else
    {
        // End:0x9CA
        if(int(m_type) == int(4))
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.TopList", "Inventory");
            Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.BottomList", "InventoryStackableUnitPrice");
            // End:0x707
            if(bulk > 0)
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck("PrivateShopWnd.CheckBulk", true);                
            }
            else
            {
                Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck("PrivateShopWnd.CheckBulk", false);
            }
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.TopText", GetSystemString(1));
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomText", GetSystemString(137));
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceConstText", GetSystemString(143));
            Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 428);
            ShowWindow("PrivateShopWnd.BottomCountText");
            ShowWindow("PrivateShopWnd.StopButton");
            ShowWindow("PrivateShopWnd.MessageButton");
            ShowWindow("PrivateShopWnd.OKButton");
            ShowWindow("PrivateShopWnd.CheckBulk");
            ShowWindow("PrivateShopWnd.history_Btn");
            // End:0x92A
            if(bulk > 0)
            {
                Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.StopButton", 2330);
                Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 2329);                
            }
            else
            {
                Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.StopButton", 2326);
                Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 2325);
            }
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("PrivateShopWnd", ((GetSystemString(498) $ "(") $ GetSystemString(1157)) $ ")");            
        }
        else
        {
            // End:0xCB3
            if(int(m_type) == int(1))
            {
                Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.TopList", "InventoryStackableUnitPrice");
                Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.BottomList", "InventoryStackableUnitPrice");
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.TopText", GetSystemString(137));
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomText", GetSystemString(139));
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceConstText", GetSystemString(142));
                Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 140);
                ShowWindow("PrivateShopWnd.BottomCountText");
                HideWindow("PrivateShopWnd.StopButton");
                HideWindow("PrivateShopWnd.MessageButton");
                ShowWindow("PrivateShopWnd.OKButton");
                HideWindow("PrivateShopWnd.CheckBulk");
                HideWindow("PrivateShopWnd.history_Btn");
                GetUserInfo(m_merchantID, User);
                // End:0xC60
                if(bulk > 0)
                {
                    Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("PrivateShopWnd", (((GetSystemString(498) $ "(") $ GetSystemString(1198)) $ ") - ") $ User.Name);                    
                }
                else
                {
                    Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("PrivateShopWnd", (((GetSystemString(498) $ "(") $ GetSystemString(1157)) $ ") - ") $ User.Name);
                }                
            }
            else
            {
                // End:0xF3D
                if(int(m_type) == int(2))
                {
                    Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.TopList", "InventoryPrice2PrivateShop");
                    Class'NWindow.UIAPI_WINDOW'.static.SetTooltipType("PrivateShopWnd.BottomList", "InventoryStackableUnitPrice");
                    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.TopText", GetSystemString(503));
                    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomText", GetSystemString(137));
                    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceConstText", GetSystemString(143));
                    Class'NWindow.UIAPI_BUTTON'.static.SetButtonName("PrivateShopWnd.OKButton", 140);
                    ShowWindow("PrivateShopWnd.BottomCountText");
                    HideWindow("PrivateShopWnd.StopButton");
                    HideWindow("PrivateShopWnd.MessageButton");
                    ShowWindow("PrivateShopWnd.OKButton");
                    HideWindow("PrivateShopWnd.CheckBulk");
                    HideWindow("PrivateShopWnd.history_Btn");
                    GetUserInfo(m_merchantID, User);
                    Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("PrivateShopWnd", (((GetSystemString(498) $ "(") $ GetSystemString(1434)) $ ") - ") $ User.Name);
                }
            }
        }
    }
    // End:0xF4F
    if(m_bBulk)
    {
        SwithBulkOnlyShop();        
    }
    else
    {
        ResetBulkOnlyShop();
    }
    return;
}

function HandleAddItem(string param)
{
    local ItemInfo Info;
    local string Target;
    local int EnchantOption1, EnchantOption2;

    ParseString(param, "target", Target);
    ParamToItemInfo(param, Info);
    ParseInt(param, "refineryOp1", EnchantOption1);
    ParseInt(param, "refineryOp2", EnchantOption2);
    // End:0xBD
    if(Target == "topList")
    {
        // End:0xA6
        if((int(m_type) == int(2)) && __NFUN_412__(Info.ItemNum, (0)))
        {
            Info.bDisabled = 1;
        }
        m_hPrivateShopWndTopList.AddItem(Info);        
    }
    else
    {
        // End:0xE7
        if(Target == "bottomList")
        {
            m_hPrivateShopWndBottomList.AddItem(Info);
        }
    }
    AdjustPrice();
    AdjustCount();
    // End:0x11B
    if((int(m_type) == int(3)) || int(m_type) == int(1))
    {
        AdjustWeight();
    }
    return;
}

function AdjustPrice()
{
    local string Adena;
    local int Count;
    local INT64 Price, addPrice64;
    local ItemInfo Info;

    Count = m_hPrivateShopWndBottomList.GetItemNum();
    J0x15:

    // End:0x76 [Loop If]
    if(Count > 0)
    {
        m_hPrivateShopWndBottomList.GetItem(Count - 1, Info);
        addPrice64 = __NFUN_401__(Info.Price, Info.ItemNum);
        Price = __NFUN_404__(Price, addPrice64);
        --Count;
        // [Loop Continue]
        goto J0x15;
    }
    Adena = MakeCostStringINT64(Price);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.PriceText", Adena);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("PrivateShopWnd.PriceText", ConvertNumToText((Price)));
    return;
}

function INT64 getAdjustPrice()
{
    local int Count;
    local INT64 Price, addPrice64;
    local ItemInfo Info;

    Count = m_hPrivateShopWndBottomList.GetItemNum();
    J0x15:

    // End:0x76 [Loop If]
    if(Count > 0)
    {
        m_hPrivateShopWndBottomList.GetItem(Count - 1, Info);
        addPrice64 = __NFUN_401__(Info.Price, Info.ItemNum);
        Price = __NFUN_404__(Price, addPrice64);
        --Count;
        // [Loop Continue]
        goto J0x15;
    }
    return Price;
    return;
}

function AdjustCount()
{
    local int Num, maxNum;

    // End:0x81
    if(int(m_type) == int(4))
    {
        maxNum = m_sellMaxCount;
        Num = m_hPrivateShopWndBottomList.GetItemNum();
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomCountText", ((("(" $ string(Num)) $ "/") $ string(maxNum)) $ ")");        
    }
    else
    {
        // End:0x102
        if(int(m_type) == int(3))
        {
            maxNum = m_buyMaxCount;
            Num = m_hPrivateShopWndBottomList.GetItemNum();
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomCountText", ((("(" $ string(Num)) $ "/") $ string(maxNum)) $ ")");            
        }
        else
        {
            // End:0x199
            if((int(m_type) == int(1)) || int(m_type) == int(2))
            {
                Num = m_hPrivateShopWndBottomList.GetItemNum();
                maxNum = m_maxInventoryCount - m_curInventoryCount;
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PrivateShopWnd.BottomCountText", ((("(" $ string(Num)) $ "/") $ string(maxNum)) $ ")");
            }
        }
    }
    m_numPossibleSlotCount = maxNum;
    return;
}

function AdjustWeight()
{
    local int Count;
    local INT64 Weight;
    local ItemInfo Info;

    Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight("PrivateShopWnd.InvenWeight");
    Count = m_hPrivateShopWndBottomList.GetItemNum();
    Weight = (0);
    J0x49:

    // End:0x9B [Loop If]
    if(Count > 0)
    {
        m_hPrivateShopWndBottomList.GetItem(Count - 1, Info);
        __NFUN_406__(Weight, __NFUN_401__((Info.Weight), Info.ItemNum));
        --Count;
        // [Loop Continue]
        goto J0x49;
    }
    Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("PrivateShopWnd.InvenWeight", Weight);
    return;
}

function addParamEnSoul(ItemInfo Info, int itemIndex, out string param)
{
    local int i, N, Cnt;

    i = 1;
    J0x07:

    // End:0xFE [Loop If]
    if(i < 3)
    {
        Cnt = Info.EnsoulOption[i - 1].OptionArray.Length;
        ParamAdd(param, (("EnsoulOptionNum_" $ string(itemIndex)) $ "_") $ string(i), string(Cnt));
        N = 1;
        J0x74:

        // End:0xF4 [Loop If]
        if(N < (1 + Cnt))
        {
            ParamAdd(param, (((("EnsoulOptionID_" $ string(itemIndex)) $ "_") $ string(i)) $ "_") $ string(N), string(Info.EnsoulOption[i - 1].OptionArray[N - 1]));
            N++;
            // [Loop Continue]
            goto J0x74;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function HandleOKButton(bool bPriceCheck)
{
    local string param;
    local int ItemCount, itemIndex;
    local ItemInfo ItemInfo;
    local PrivateShopWndReport report;
    local INT64 nPriceAdena;

    report = PrivateShopWndReport(GetScript("PrivateShopWndReport"));
    ItemCount = m_hPrivateShopWndBottomList.GetItemNum();
    // End:0x1E5
    if(int(m_type) == int(4))
    {
        nPriceAdena = getAdjustPrice();
        // End:0x89
        if(__NFUN_408__(getInstanceUIData().getMaxAdena(), __NFUN_404__(GetAdena(), nPriceAdena)))
        {
            AddSystemMessage(4470);
            return;
        }
        // End:0xCC
        if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("PrivateShopWnd.CheckBulk"))
        {
            ParamAdd(param, "bulk", "1");            
        }
        else
        {
            ParamAdd(param, "bulk", "0");
        }
        ParamAdd(param, "num", string(ItemCount));
        itemIndex = 0;
        J0xFE:

        // End:0x1AE [Loop If]
        if(itemIndex < ItemCount)
        {
            m_hPrivateShopWndBottomList.GetItem(itemIndex, ItemInfo);
            ParamAddItemIDWithIndex(param, ItemInfo.Id, itemIndex);
            ParamAdd(param, "Count_" $ string(itemIndex), (ItemInfo.ItemNum));
            ParamAdd(param, "Price_" $ string(itemIndex), (ItemInfo.Price));
            report.externalAddItem(ItemInfo);
            ++itemIndex;
            // [Loop Continue]
            goto J0xFE;
        }
        // End:0x1CD
        if(ItemCount > 0)
        {
            report.startOpenPrivateShop(param);
        }
        SendPrivateShopList("sellList", param);        
    }
    else
    {
        // End:0x34A
        if(int(m_type) == int(1))
        {
            ParamAdd(param, "merchantID", string(m_merchantID));
            ParamAdd(param, "num", string(ItemCount));
            itemIndex = 0;
            J0x231:

            // End:0x2F5 [Loop If]
            if(itemIndex < ItemCount)
            {
                m_hPrivateShopWndBottomList.GetItem(itemIndex, ItemInfo);
                // End:0x281
                if(bPriceCheck && !IsProperPrice(ItemInfo, ItemInfo.Price))
                {
                    // [Explicit Break]
                    goto J0x2F5;
                }
                ParamAddItemIDWithIndex(param, ItemInfo.Id, itemIndex);
                ParamAdd(param, "Count_" $ string(itemIndex), (ItemInfo.ItemNum));
                ParamAdd(param, "Price_" $ string(itemIndex), (ItemInfo.Price));
                ++itemIndex;
                // [Loop Continue]
                goto J0x231;
            }
            J0x2F5:

            // End:0x337
            if(bPriceCheck && itemIndex < ItemCount)
            {
                DialogSetID(666);
                DialogShow(1, 4, GetSystemMessage(569), string(self));
                return;                
            }
            else
            {
                SendPrivateShopList("buy", param);
            }            
        }
        else
        {
            // End:0x709
            if(int(m_type) == int(3))
            {
                ParamAdd(param, "num", string(ItemCount));
                itemIndex = 0;
                J0x378:

                // End:0x6D3 [Loop If]
                if(itemIndex < ItemCount)
                {
                    m_hPrivateShopWndBottomList.GetItem(itemIndex, ItemInfo);
                    ParamAddItemIDWithIndex(param, ItemInfo.Id, itemIndex);
                    ParamAdd(param, "Enchanted_" $ string(itemIndex), string(ItemInfo.Enchanted));
                    ParamAdd(param, "Damaged_" $ string(itemIndex), string(ItemInfo.Damaged));
                    ParamAdd(param, "Count_" $ string(itemIndex), (ItemInfo.ItemNum));
                    ParamAdd(param, "Price_" $ string(itemIndex), (ItemInfo.Price));
                    ParamAdd(param, "RefineryOp1_" $ string(itemIndex), string(ItemInfo.RefineryOp1));
                    ParamAdd(param, "RefineryOp2_" $ string(itemIndex), string(ItemInfo.RefineryOp2));
                    ParamAdd(param, "LookChangeItemID_" $ string(itemIndex), string(ItemInfo.LookChangeItemID));
                    ParamAdd(param, "AttrAttackType_" $ string(itemIndex), string(ItemInfo.AttackAttributeType));
                    ParamAdd(param, "AttrAttackValue_" $ string(itemIndex), string(ItemInfo.AttackAttributeValue));
                    ParamAdd(param, "AttrDefenseValueFire_" $ string(itemIndex), string(ItemInfo.DefenseAttributeValueFire));
                    ParamAdd(param, "AttrDefenseValueWater_" $ string(itemIndex), string(ItemInfo.DefenseAttributeValueWater));
                    ParamAdd(param, "AttrDefenseValueWind_" $ string(itemIndex), string(ItemInfo.DefenseAttributeValueWind));
                    ParamAdd(param, "AttrDefenseValueEarth_" $ string(itemIndex), string(ItemInfo.DefenseAttributeValueEarth));
                    ParamAdd(param, "AttrDefenseValueHoly_" $ string(itemIndex), string(ItemInfo.DefenseAttributeValueHoly));
                    ParamAdd(param, "AttrDefenseValueUnholy_" $ string(itemIndex), string(ItemInfo.DefenseAttributeValueUnholy));
                    addParamEnSoul(ItemInfo, itemIndex, param);
                    report.externalAddItem(ItemInfo);
                    ++itemIndex;
                    // [Loop Continue]
                    goto J0x378;
                }
                // End:0x6F2
                if(ItemCount > 0)
                {
                    report.startOpenPrivateShop(param);
                }
                SendPrivateShopList("buyList", param);                
            }
            else
            {
                // End:0x966
                if(int(m_type) == int(2))
                {
                    ParamAdd(param, "merchantID", string(m_merchantID));
                    ParamAdd(param, "num", string(ItemCount));
                    itemIndex = 0;
                    J0x755:

                    // End:0x913 [Loop If]
                    if(itemIndex < ItemCount)
                    {
                        m_hPrivateShopWndBottomList.GetItem(itemIndex, ItemInfo);
                        // End:0x7A5
                        if(bPriceCheck && !IsProperPrice(ItemInfo, ItemInfo.Price))
                        {
                            // [Explicit Break]
                            goto J0x913;
                        }
                        ParamAddItemIDWithIndex(param, ItemInfo.Id, itemIndex);
                        ParamAdd(param, "Enchanted_" $ string(itemIndex), string(ItemInfo.Enchanted));
                        ParamAdd(param, "Damaged_" $ string(itemIndex), string(ItemInfo.Damaged));
                        ParamAdd(param, "Count_" $ string(itemIndex), (ItemInfo.ItemNum));
                        ParamAdd(param, "Price_" $ string(itemIndex), (ItemInfo.Price));
                        ParamAdd(param, "RefineryOp1_" $ string(itemIndex), string(ItemInfo.RefineryOp1));
                        ParamAdd(param, "RefineryOp2_" $ string(itemIndex), string(ItemInfo.RefineryOp2));
                        ParamAdd(param, "LookChangeItemID_" $ string(itemIndex), string(ItemInfo.LookChangeItemID));
                        addParamEnSoul(ItemInfo, itemIndex, param);
                        ++itemIndex;
                        // [Loop Continue]
                        goto J0x755;
                    }
                    J0x913:

                    // End:0x955
                    if(bPriceCheck && itemIndex < ItemCount)
                    {
                        DialogSetID(666);
                        DialogShow(1, 4, GetSystemMessage(569), string(self));
                        return;                        
                    }
                    else
                    {
                        SendPrivateShopList("sell", param);
                    }
                }
            }
        }
    }
    HideWindow("PrivateShopWnd");
    Clear();
    return;
}

function HandleSetMaxCount(string param)
{
    ParseInt(param, "Inventory", m_maxInventoryCount);
    ParseInt(param, "privateShopSell", m_sellMaxCount);
    ParseInt(param, "privateShopBuy", m_buyMaxCount);
    return;
}

function bool IsProperPrice(out ItemInfo Info, INT64 Price)
{
    // End:0x51
    if(__NFUN_409__(Info.DefaultPrice, (0)) && __NFUN_410__(Price, __NFUN_403__(Info.DefaultPrice, (5))) || __NFUN_411__(Price, __NFUN_401__(Info.DefaultPrice, (5))))
    {
        return false;
    }
    return true;
    return;
}

function SwithBulkOnlyShop()
{
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("PrivateShopWnd", ((GetSystemString(596) $ "(") $ GetSystemString(1198)) $ ")");
    HideWindow("PrivateShopWnd.CheckBulk");
    return;
}

function ResetBulkOnlyShop()
{
    HideWindow("PrivateShopWnd.CheckBulk");
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    RequestQuit();
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="PrivateShopWnd"
}