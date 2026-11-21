class SetItemAutoEquipInventoryWnd extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle totalInven_ItemWnd;
var TextBoxHandle InvenoryCount;
var TextBoxHandle Inventory_Title_TextBox;
var WindowHandle ParentWindow;
var SetItemAutoEquipWnd SetItemAutoEquip;
var int nCurrentSlotIndex;
//var delegate<OnSortNameCompare> __OnSortNameCompare__Delegate;

function OnLoad()
{
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle(getCurrentWindowName(string(self)));
    totalInven_ItemWnd = GetItemWindowHandle((getCurrentWindowName(string(self))) $ ".InventoryItem_ItemWnd");
    InvenoryCount = GetTextBoxHandle((getCurrentWindowName(string(self))) $ ".InventoryCount_TextBox");
    Inventory_Title_TextBox = GetTextBoxHandle((getCurrentWindowName(string(self))) $ ".Inventory_Title_TextBox");
    SetItemAutoEquip = SetItemAutoEquipWnd(GetScript("SetItemAutoEquipWnd"));
    SetDisable(false);
    return;
}

function SetDisable(bool B)
{
    // End:0x09
    if(B)
    {
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int nX, int nY)
{
    ParentWindow.SetFocus();
    Me.SetFocus();
    return;
}

function OnClickButton(string strID)
{
    return;
}

function syncInventory(int SlotIndex, optional ItemWindowHandle targetWindow)
{
    local array<ItemInfo> itemarray;
    local int i, j, cryType, ItemType, addItemType, ArmorType,
	    nMaxEnchant;

    local ItemID currentTargetItem;
    local bool bSkip;
    local string SlotString;
    local array<int> bitTypes;

    nCurrentSlotIndex = SlotIndex;
    bitTypes = getAutoEquipSlot(SlotIndex);
    Class'NWindow.UIDATA_INVENTORY'.static.GetAllItem(itemarray);
    totalInven_ItemWnd.Clear();
    i = 0;
    J0x46:

    // End:0x159 [Loop If]
    if(i < itemarray.Length)
    {
        // End:0x7B
        if(SetItemAutoEquip.checkSlots(itemarray[i].Id))
        {
            // [Explicit Continue]
            goto J0x14F;
        }
        bSkip = true;
        j = 0;
        J0x8A:

        // End:0xD2 [Loop If]
        if(j < bitTypes.Length)
        {
            // End:0xC8
            if(__NFUN_412__((bitTypes[j]), itemarray[i].SlotBitType))
            {
                bSkip = false;
                // [Explicit Break]
                goto J0xD2;
            }
            j++;
            // [Loop Continue]
            goto J0x8A;
        }
        J0xD2:

        // End:0xDE
        if(bSkip)
        {
            // [Explicit Continue]
            goto J0x14F;
        }
        // End:0x135
        if(itemarray[i].bEquipped && itemarray[i].ForeTexture == "")
        {
            itemarray[i].ForeTexture = "L2UI_CT1.Icon.WearPanel";
        }
        totalInven_ItemWnd.AddItem(itemarray[i]);
        J0x14F:

        i++;
        // [Loop Continue]
        goto J0x46;
    }
    InvenoryCount.SetText("x" $ string(totalInven_ItemWnd.GetItemNum()));
    // End:0x1DF
    if(targetWindow != none)
    {
        Me.SetAnchor("SetItemAutoEquipWnd." $ targetWindow.GetWindowName(), "TopRight", "BottomLeft", -16, -9);
    }
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

    totalInven_ItemWnd.GetItem(Index, Info);
    // End:0x7C
    if(Info.Id.ServerID > 0)
    {
        // End:0x63
        if(Info.ForeTexture == "L2UI_CT1.Icon.WearPanel")
        {
            Info.ForeTexture = "";
        }
        SetItemAutoEquip.setSettigsSlot(nCurrentSlotIndex, Info);
    }
    syncInventory(nCurrentSlotIndex);
    return;
}

function OnHide()
{
    totalInven_ItemWnd.Clear();
    nCurrentSlotIndex = -1;
    return;
}

delegate int OnSortNameCompare(ItemInfo A, ItemInfo B)
{
    // End:0x29
    if(A.Id.ClassID < B.Id.ClassID)
    {
        return -1;
    }
    return 0;
    return;
}
