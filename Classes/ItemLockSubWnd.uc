class ItemLockSubWnd extends UICommonAPI;

const STATE_INSERT_WEAPON = "STATE_INSERT_WEAPON";
const STATE_INSERT_ENSOULSTONE = "STATE_INSERT_ENSOULSTONE";
const STATE_SELECT_ENSOUL = "STATE_SELECT_ENSOUL";
const STATE_CONFIRM_ENSOUL = "STATE_CONFIRM_ENSOUL";
const STATE_ASK_OVERWRITE = "STATE_ASK_OVERWRITE";
const STATE_RESULT = "STATE_RESULT";

var WindowHandle Me;
var ItemWindowHandle ItemLockSubWnd_Item1;
var L2Util util;
var InventoryWnd inventoryWndScript;
var ItemLockWnd ItemLockWndScript;

function Initialize()
{
    Me = GetWindowHandle("ItemLockSubWnd");
    ItemLockSubWnd_Item1 = GetItemWindowHandle("ItemLockSubWnd.ItemLockSubWnd_Item1");
    util = L2Util(GetScript("L2Util"));
    inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
    ItemLockWndScript = ItemLockWnd(GetScript("ItemLockWnd"));
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function OnShow()
{
    return;
}

function syncInventory()
{
    local int i;
    local array<ItemInfo> itemarray;

    itemarray = inventoryWndScript.getInventoryAllItemArray();
    ItemLockSubWnd_Item1.Clear();
    i = 0;
    J0x2B:

    // End:0xDC [Loop If]
    if(i < itemarray.Length)
    {
        // End:0xD2
        if(itemarray[i].bSecurityLockable)
        {
            // End:0xA4
            if(int(ItemLockWndScript.currentWindowType) == int(ItemLockWndScript.0))
            {
                // End:0xA1
                if(!itemarray[i].bSecurityLock)
                {
                    ItemLockSubWnd_Item1.AddItem(itemarray[i]);
                }
                // [Explicit Continue]
                goto J0xD2;
            }
            // End:0xD2
            if(itemarray[i].bSecurityLock)
            {
                ItemLockSubWnd_Item1.AddItem(itemarray[i]);
            }
        }
        J0xD2:

        i++;
        // [Loop Continue]
        goto J0x2B;
    }
    return;
}

function setLock(bool bLock)
{
    // End:0x1B
    if(bLock)
    {
        ItemLockSubWnd_Item1.DisableWindow();        
    }
    else
    {
        ItemLockSubWnd_Item1.EnableWindow();
    }
    return;
}

function OnRClickItem(string strID, int Index)
{
    OnDBClickItem(strID, Index);
    return;
}

function OnDBClickItem(string strID, int Index)
{
    local ItemInfo Info;

    ItemLockSubWnd_Item1.GetItem(Index, Info);
    // End:0x40
    if(IsValidItemID(Info.Id))
    {
        ItemLockWndScript.SetItemInfo(Info);
    }
    return;
}
