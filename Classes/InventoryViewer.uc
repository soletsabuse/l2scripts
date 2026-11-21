class InventoryViewer extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle totalInven_ItemWnd;
var int baseWidth;
var int BaseHeight;
var InventoryWnd inventoryWndScript;
var TextBoxHandle InvenoryCount;
var TextBoxHandle AdenaText;
var WindowHandle ParentWindow;

function OnRegisterEvent()
{
    RegisterEvent(2570);
    RegisterEvent(9570);
    RegisterEvent(2070);
    return;
}

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
    AdenaText = GetTextBoxHandle((getCurrentWindowName(string(self))) $ ".AdenaText");
    inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
    return;
}

function OnDefaultPosition()
{
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int nX, int nY)
{
    ParentWindow.SetFocus();
    Me.SetFocus();
    return;
}

function showWindowByParentWindow(WindowHandle pWnd, optional bool bToggleShow)
{
    ParentWindow = pWnd;
    getInstanceL2Util().windowAnchorToSide(pWnd, Me, 2, 29);
    // End:0x6D
    if(!Me.IsShowWindow())
    {
        Me.ShowWindow();
        Me.SetFocus();
        pWnd.SetFocus();        
    }
    else
    {
        // End:0x85
        if(bToggleShow)
        {
            Me.HideWindow();
        }
    }
    return;
}

function SetAdenaText()
{
    local string adenaString;

    adenaString = MakeCostString((GetAdena()));
    AdenaText.SetText(adenaString);
    AdenaText.SetTooltipString(ConvertNumToText((GetAdena())));
    return;
}

function OnShow()
{
    SetAdenaText();
    SetItemCount();
    syncInventory();
    return;
}

function OnClickButton(string strID)
{
    // End:0x26
    if(strID == "CloseButton")
    {
        Me.HideWindow();
    }
    return;
}

function SetItemCount()
{
    local int limit, Count;

    Count = inventoryWndScript.m_NormalInvenCount + inventoryWndScript.EquipItemGetItemNum();
    limit = inventoryWndScript.GetMyInventoryLimit();
    InvenoryCount.SetText(((("(" $ string(Count)) $ "/") $ string(limit)) $ ")");
    getInstanceL2Util().ItemboxUpdate(totalInven_ItemWnd, limit);
    return;
}

function syncInventory()
{
    local array<ItemInfo> itemarray, equipItemArray;
    local int i;
    local ItemInfo kClearItem;

    kClearItem.IconName = "L2ui_ct1.emptyBtn";
    ClearItemID(kClearItem.Id);
    itemarray = getInstanceL2Util().SortItemArray(inventoryWndScript.getInventoryAllItemArray(true));
    equipItemArray = getInstanceL2Util().SortItemArray(inventoryWndScript.getInventoryEquipItemArray());
    i = 0;
    J0x80:

    // End:0xE3 [Loop If]
    if(i < equipItemArray.Length)
    {
        equipItemArray[i].ForeTexture = "L2UI_CT1.Icon.WearPanel";
        totalInven_ItemWnd.SetItem(i, equipItemArray[i]);
        i++;
        // [Loop Continue]
        goto J0x80;
    }
    i = 0;
    J0xEA:

    // End:0x12B [Loop If]
    if(i < itemarray.Length)
    {
        totalInven_ItemWnd.SetItem(i + equipItemArray.Length, itemarray[i]);
        i++;
        // [Loop Continue]
        goto J0xEA;
    }
    i = equipItemArray.Length + itemarray.Length;
    J0x13F:

    // End:0x17B [Loop If]
    if(i < inventoryWndScript.GetMyInventoryLimit())
    {
        totalInven_ItemWnd.SetItem(i, kClearItem);
        i++;
        // [Loop Continue]
        goto J0x13F;
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x0F
        case 9570:
        // End:0x3E
        case 2070:
            // End:0x3B
            if(Me.IsShowWindow())
            {
                SetAdenaText();
                SetItemCount();
                syncInventory();
            }
            // End:0x5B
            break;
        // End:0x58
        case 2570:
            totalInven_ItemWnd.Clear();
            // End:0x5B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
