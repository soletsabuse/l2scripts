class ItemJewelEnchantSubWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle SlotBg1_Texture;
var ItemWindowHandle ItemJewelEnchantSubWnd_ItemWnd;
var array<ItemInfo> itemInfoArray;
var ItemJewelEnchantWnd ItemJewelEnchantWndScript;
var L2Util util;
//var delegate<OnSortCompare> __OnSortCompare__Delegate;

function OnRegisterEvent()
{
    RegisterEvent(9570);
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function OnShow()
{
    refresh();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("ItemJewelEnchantSubWnd");
    ItemJewelEnchantSubWnd_ItemWnd = GetItemWindowHandle("ItemJewelEnchantSubWnd.ItemJewelEnchantSubWnd_ItemWnd");
    util = L2Util(GetScript("L2Util"));
    ItemJewelEnchantWndScript = ItemJewelEnchantWnd(GetScript("ItemJewelEnchantWnd"));
    return;
}

function OnRClickItem(string strID, int Index)
{
    OnDBClickItem(strID, Index);
    return;
}

function OnDBClickItem(string ControlName, int Index)
{
    local ItemInfo Info;

    ItemJewelEnchantSubWnd_ItemWnd.GetItem(Index, Info);
    // End:0x43
    if(Info.Id.ClassID > 0)
    {
        ItemJewelEnchantWndScript.dropProcess(Info, 0);
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x3B
        case 9570:
            // End:0x38
            if(Me.IsShowWindow())
            {
                Debug("refresh! ");
                refresh();
            }
            // End:0x3E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function int getSlotClassID(int nClassID)
{
    local int nValue;

    // End:0x19
    if(nClassID > 0)
    {
        nValue = nClassID;        
    }
    else
    {
        nValue = -1;
    }
    return nValue;
    return;
}

function setDescTextBox(bool bShowMessage)
{
    GetTextBoxHandle("ItemJewelEnchantSubWnd.DescriptionMsgWnd.descTextBox").SetText(GetSystemMessage(4222));
    // End:0x97
    if(bShowMessage)
    {
        GetWindowHandle("ItemJewelEnchantSubWnd.DescriptionMsgWnd").ShowWindow();        
    }
    else
    {
        GetWindowHandle("ItemJewelEnchantSubWnd.DescriptionMsgWnd").HideWindow();
    }
    return;
}

delegate int OnSortCompare(ItemInfo A, ItemInfo B)
{
    // End:0x2C
    if(A.Id.ClassID > B.Id.ClassID)
    {
        return -1;        
    }
    else
    {
        return 0;
    }
    return;
}

function refresh()
{
    local int i, slot1_ClassID, slot2_ClassID;
    local bool bSlot1Dec, bSlot2Dec, bIsWorkingEnchant;

    bSlot1Dec = true;
    bSlot2Dec = true;
    slot1_ClassID = ItemJewelEnchantWndScript.getSlotItemWindowByIndex(1);
    slot2_ClassID = ItemJewelEnchantWndScript.getSlotItemWindowByIndex(2);
    bIsWorkingEnchant = ItemJewelEnchantWndScript.isWorkingEnchant();
    Class'NWindow.NewEnchantAPI'.static.GetMaterialItemForEnchantFromInven(getSlotClassID(slot1_ClassID), -1, itemInfoArray);
    itemInfoArray = util.SortItemArray(itemInfoArray);
    Debug("ItemInfoArray Length: " @ string(itemInfoArray.Length));
    Debug("getSlotClassID(slot1_ClassID)" @ string(getSlotClassID(slot1_ClassID)));
    Debug("getSlotClassID(slot2_ClassID)" @ string(getSlotClassID(slot2_ClassID)));
    ItemJewelEnchantSubWnd_ItemWnd.Clear();
    i = 0;
    J0x137:

    // End:0x2B6 [Loop If]
    if(i < itemInfoArray.Length)
    {
        // End:0x243
        if(bIsWorkingEnchant == false)
        {
            // End:0x1CB
            if((itemInfoArray[i].Id.ClassID == slot1_ClassID) && bSlot1Dec)
            {
                // End:0x1C0
                if(IsStackableItem(itemInfoArray[i].ConsumeType))
                {
                    itemInfoArray[i].ItemNum = __NFUN_405__(itemInfoArray[i].ItemNum, (1));                    
                }
                else
                {
                    bSlot1Dec = false;
                    // [Explicit Continue]
                    goto J0x2AC;
                }
            }
            // End:0x243
            if((itemInfoArray[i].Id.ClassID == slot2_ClassID) && bSlot2Dec)
            {
                // End:0x238
                if(IsStackableItem(itemInfoArray[i].ConsumeType))
                {
                    itemInfoArray[i].ItemNum = __NFUN_405__(itemInfoArray[i].ItemNum, (1));                    
                }
                else
                {
                    bSlot2Dec = false;
                    // [Explicit Continue]
                    goto J0x2AC;
                }
            }
        }
        // End:0x292
        if(IsStackableItem(itemInfoArray[i].ConsumeType))
        {
            // End:0x28F
            if(__NFUN_409__(itemInfoArray[i].ItemNum, (0)))
            {
                ItemJewelEnchantSubWnd_ItemWnd.AddItem(itemInfoArray[i]);
            }
            // [Explicit Continue]
            goto J0x2AC;
        }
        ItemJewelEnchantSubWnd_ItemWnd.AddItem(itemInfoArray[i]);
        J0x2AC:

        i++;
        // [Loop Continue]
        goto J0x137;
    }
    // End:0x2D5
    if(ItemJewelEnchantSubWnd_ItemWnd.GetItemNum() <= 0)
    {
        setDescTextBox(true);        
    }
    else
    {
        setDescTextBox(false);
    }
    return;
}

function int getSubIvenItemNum()
{
    return ItemJewelEnchantSubWnd_ItemWnd.GetItemNum();
    return;
}

function int getIndexSubIvenItem(int ClassID)
{
    local ItemInfo Info;
    local int ItemNum, i;

    ItemNum = ItemJewelEnchantSubWnd_ItemWnd.GetItemNum();
    i = 0;
    J0x1C:

    // End:0x6D [Loop If]
    if(i < ItemNum)
    {
        ItemJewelEnchantSubWnd_ItemWnd.GetItem(i, Info);
        // End:0x63
        if(Info.Id.ClassID == ClassID)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x1C;
    }
    return -1;
    return;
}

function OnHide()
{
    ItemJewelEnchantSubWnd_ItemWnd.Clear();
    setDescTextBox(false);
    return;
}
