class DeliverWnd extends UICommonAPI;

const DIALOG_TOP_TO_BOTTOM = 111;
const DIALOG_BOTTOM_TO_TOP = 222;

var int m_targetID;

function OnRegisterEvent()
{
    RegisterEvent(2160);
    RegisterEvent(2170);
    RegisterEvent(1710);
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
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
    return;
}

function Clear()
{
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("DeliverWnd.TopList");
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("DeliverWnd.BottomList");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DeliverWnd.PriceText", "0");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("DeliverWnd.PriceText", "");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DeliverWnd.AdenaText", "0");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("DeliverWnd.AdenaText", "");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 2160:
            HandleOpenWindow(param);
            // End:0x4A
            break;
        // End:0x33
        case 2170:
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

    // End:0x51
    if(ControlName == "UpButton")
    {
        Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedNum("DeliverWnd.BottomList");
        MoveItemBottomToTop(Index, (0));        
    }
    else
    {
        // End:0xA1
        if(ControlName == "DownButton")
        {
            Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedNum("DeliverWnd.TopList");
            MoveItemTopToBottom(Index, (0));            
        }
        else
        {
            // End:0xBE
            if(ControlName == "OKButton")
            {
                HandleOKButton();                
            }
            else
            {
                // End:0xEE
                if(ControlName == "CancelButton")
                {
                    Clear();
                    HideWindow("DeliverWnd");
                }
            }
        }
    }
    return;
}

function OnDBClickItem(string ControlName, int Index)
{
    // End:0x24
    if(ControlName == "TopList")
    {
        MoveItemTopToBottom(Index, (0));        
    }
    else
    {
        // End:0x48
        if(ControlName == "BottomList")
        {
            MoveItemBottomToTop(Index, (0));
        }
    }
    return;
}

function OnClickItem(string ControlName, int Index)
{
    local WindowHandle m_dialogWnd;

    // End:0x21
    if(1 == 0)
    {
        m_dialogWnd = GetHandle("DialogBox");        
    }
    else
    {
        m_dialogWnd = GetWindowHandle("DialogBox");
    }
    // End:0x7D
    if(ControlName == "TopList")
    {
        // End:0x7D
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

    // End:0x89
    if((strID == "TopList") && Info.DragSrcName == "BottomList")
    {
        Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.BottomList", Info.Id);
        // End:0x86
        if(Index >= 0)
        {
            MoveItemBottomToTop(Index, Info.AllItemCount);
        }        
    }
    else
    {
        // End:0x10C
        if((strID == "BottomList") && Info.DragSrcName == "TopList")
        {
            Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.TopList", Info.Id);
            // End:0x10C
            if(Index >= 0)
            {
                MoveItemTopToBottom(Index, Info.AllItemCount);
            }
        }
    }
    return;
}

function MoveItemTopToBottom(int Index, INT64 AllItemCount)
{
    local ItemInfo Info;

    // End:0x150
    if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.TopList", Index, Info))
    {
        // End:0xDC
        if(IsStackableItem(Info.ConsumeType) && __NFUN_409__(Info.ItemNum, (1)))
        {
            // End:0x84
            if(__NFUN_409__(AllItemCount, (0)))
            {
                ItemTopToBottom(Info.Id, AllItemCount);
                AdjustPrice();                
            }
            else
            {
                DialogSetID(111);
                DialogSetReservedItemID(Info.Id);
                DialogSetParamInt64(Info.ItemNum);
                DialogSetDefaultOK();
                DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));
            }            
        }
        else
        {
            Info.ItemNum = (1);
            Info.bShowCount = false;
            Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("DeliverWnd.BottomList", Info);
            Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("DeliverWnd.TopList", Index);
            AdjustPrice();
        }
    }
    return;
}

function MoveItemBottomToTop(int Index, INT64 AllItemCount)
{
    local ItemInfo Info;

    // End:0x138
    if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.BottomList", Index, Info))
    {
        // End:0xDF
        if(IsStackableItem(Info.ConsumeType) && __NFUN_409__(Info.ItemNum, (1)))
        {
            // End:0x87
            if(__NFUN_409__(AllItemCount, (0)))
            {
                ItemBottomToTop(Info.Id, AllItemCount);
                AdjustPrice();                
            }
            else
            {
                DialogSetID(222);
                DialogSetReservedItemID(Info.Id);
                DialogSetParamInt64(Info.ItemNum);
                DialogSetDefaultOK();
                DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));
            }            
        }
        else
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("DeliverWnd.BottomList", Index);
            Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("DeliverWnd.TopList", Info);
            AdjustPrice();
        }
    }
    return;
}

function HandleDialogOK()
{
    local int Id;
    local INT64 Num;
    local ItemID cID;

    // End:0x90
    if(DialogIsMine())
    {
        Id = DialogGetID();
        Num = (DialogGetString());
        cID = DialogGetReservedItemID();
        // End:0x5E
        if((Id == 111) && __NFUN_409__(Num, (0)))
        {
            ItemTopToBottom(cID, Num);            
        }
        else
        {
            // End:0x8A
            if((Id == 222) && __NFUN_409__(Num, (0)))
            {
                ItemBottomToTop(cID, Num);
            }
        }
        AdjustPrice();
    }
    return;
}

function ItemTopToBottom(ItemID cID, INT64 Num)
{
    local int Index, topIndex;
    local ItemInfo Info, topInfo;

    topIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.TopList", cID);
    // End:0x1E7
    if(topIndex >= 0)
    {
        Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.TopList", topIndex, topInfo);
        Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.BottomList", cID);
        // End:0x117
        if(Index >= 0)
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.BottomList", Index, Info);
            __NFUN_406__(Info.ItemNum, Num);
            Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem("DeliverWnd.BottomList", Index, Info);            
        }
        else
        {
            Info = topInfo;
            Info.ItemNum = Num;
            Info.bShowCount = false;
            Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("DeliverWnd.BottomList", Info);
        }
        __NFUN_407__(topInfo.ItemNum, Num);
        // End:0x1BA
        if(__NFUN_410__(topInfo.ItemNum, (0)))
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("DeliverWnd.TopList", topIndex);            
        }
        else
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem("DeliverWnd.TopList", topIndex, topInfo);
        }
    }
    return;
}

function ItemBottomToTop(ItemID cID, INT64 Num)
{
    local int Index, topIndex;
    local ItemInfo Info, topInfo;

    Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.BottomList", cID);
    // End:0x1E4
    if(Index >= 0)
    {
        Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.BottomList", Index, Info);
        __NFUN_407__(Info.ItemNum, Num);
        // End:0xC4
        if(__NFUN_409__(Info.ItemNum, (0)))
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem("DeliverWnd.BottomList", Index, Info);            
        }
        else
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("DeliverWnd.BottomList", Index);
        }
        topIndex = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("DeliverWnd.TopList", cID);
        // End:0x1AC
        if((topIndex >= 0) && IsStackableItem(Info.ConsumeType))
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.TopList", topIndex, topInfo);
            __NFUN_406__(topInfo.ItemNum, Num);
            Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem("DeliverWnd.TopList", topIndex, topInfo);            
        }
        else
        {
            Info.ItemNum = Num;
            Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("DeliverWnd.TopList", Info);
        }
    }
    return;
}

function HandleOpenWindow(string param)
{
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
    ParseINT64(param, "adena", Adena);
    ParseInt(param, "destinationID", m_targetID);
    adenaString = MakeCostString((Adena));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DeliverWnd.AdenaText", adenaString);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("DeliverWnd.AdenaText", ConvertNumToText((Adena)));
    ShowWindow("DeliverWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("DeliverWnd");
    return;
}

function HandleAddItem(string param)
{
    local ItemInfo Info;

    ParamToItemInfo(param, Info);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("DeliverWnd.TopList", Info);
    return;
}

function AdjustPrice()
{
    local string Adena;
    local int Count;

    Count = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("DeliverWnd.BottomList");
    Adena = MakeCostString(string(Count * 1000));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DeliverWnd.PriceText", Adena);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("DeliverWnd.PriceText", ConvertNumToText(string(Count * 1000)));
    return;
}

function HandleOKButton()
{
    local string param;
    local int Count, Index;
    local ItemInfo ItemInfo;

    Count = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("DeliverWnd.BottomList");
    ParamAdd(param, "targetID", string(m_targetID));
    ParamAdd(param, "num", string(Count));
    Index = 0;
    J0x66:

    // End:0xFC [Loop If]
    if(Index < Count)
    {
        Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("DeliverWnd.BottomList", Index, ItemInfo);
        ParamAdd(param, "dbID" $ string(Index), string(ItemInfo.Reserved));
        ParamAdd(param, "count" $ string(Index), (ItemInfo.ItemNum));
        ++Index;
        // [Loop Continue]
        goto J0x66;
    }
    RequestPackageSend(param);
    HideWindow("DeliverWnd");
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    OnClickButton("CancelButton");
    return;
}
