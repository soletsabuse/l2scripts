class AutoPotionInventoryViewer extends UICommonAPI;

var WindowHandle Me;
var ItemWindowHandle totalInven_ItemWnd;
var int baseWidth;
var int BaseHeight;
var InventoryWnd inventoryWndScript;
var TextBoxHandle InvenoryCount;
var TextBoxHandle AdenaText;
var WindowHandle ParentWindow;
var zAutoPotionWnd zAutoPotionWnd;

function OnRegisterEvent()
{
    RegisterEvent(9570);
    RegisterEvent(2070);
    RegisterEvent(2620);
    RegisterEvent(2570);
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function Initialize()
{
    local int i;

    Me = GetWindowHandle(getCurrentWindowName(string(self)));
    totalInven_ItemWnd = GetItemWindowHandle((getCurrentWindowName(string(self))) $ ".InventoryItem_ItemWnd");
    InvenoryCount = GetTextBoxHandle((getCurrentWindowName(string(self))) $ ".InventoryCount_TextBox");
    inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
    zAutoPotionWnd = zAutoPotionWnd(GetScript("AutoPotionWnd"));
    return;
}

function OnShow()
{
    syncInventory();
    return;
}

function OnDefaultPosition()
{
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int nX, int nY)
{
    Me.SetFocus();
    return;
}

event OnLButtonDblClick(WindowHandle a_WindowHandle, int X, int Y)
{
    local ItemInfo inf;

    totalInven_ItemWnd.GetSelectedItem(inf);
    // End:0x94
    if(inf.ForeTexture != "L2UI_CT1.Icon.WearPanel")
    {
        // End:0x68
        if(IsHp(inf.Id.ClassID))
        {
            PushPotionItemByType(0, inf.Id);            
        }
        else
        {
            // End:0x91
            if(IsMp(inf.Id.ClassID))
            {
                PushPotionItemByType(1, inf.Id);
            }
        }        
    }
    else
    {
        UnPushPotionItem(inf.Id);
    }
    return;
}

function UnPushPotionItem(ItemID Id)
{
    local ItemInfo tmpInf;
    local ItemID nullItemID;

    // End:0x9D
    if(zAutoPotionWnd.iHPslot.GetItem(0, tmpInf))
    {
        // End:0x9D
        if(tmpInf.Id == Id)
        {
            zAutoPotionWnd.iHP = nullItemID;
            SetOptionInt(GetMyName(), "ACP_slot_3_class", nullItemID.ClassID);
            SetOptionInt(GetMyName(), "ACP_slot_3_server", nullItemID.ServerID);
        }
    }
    // End:0x13A
    if(zAutoPotionWnd.iMPslot.GetItem(0, tmpInf))
    {
        // End:0x13A
        if(tmpInf.Id == Id)
        {
            zAutoPotionWnd.imp = nullItemID;
            SetOptionInt(GetMyName(), "ACP_slot_4_class", nullItemID.ClassID);
            SetOptionInt(GetMyName(), "ACP_slot_4_server", nullItemID.ServerID);
        }
    }
    zAutoPotionWnd.PlaceItem();
    syncInventory();
    RefreshINI("windowsinfo.ini");
    return;
}

function PushPotionItemByType(int nType, ItemID Id)
{
    local ItemInfo tmpInf;

    switch(nType)
    {
        // End:0x73
        case 0:
            zAutoPotionWnd.iHP = Id;
            SetOptionInt(GetMyName(), "ACP_slot_3_class", Id.ClassID);
            SetOptionInt(GetMyName(), "ACP_slot_3_server", Id.ServerID);
            // End:0xE5
            break;
        // End:0xDF
        case 1:
            zAutoPotionWnd.imp = Id;
            SetOptionInt(GetMyName(), "ACP_slot_4_class", Id.ClassID);
            SetOptionInt(GetMyName(), "ACP_slot_4_server", Id.ServerID);
            // End:0xE5
            break;
        // End:0xFFFF
        default:
            // End:0xE5
            break;
            break;
    }
    zAutoPotionWnd.PlaceItem();
    syncInventory();
    RefreshINI("windowsinfo.ini");
    return;
}

function PushPotionItem(ItemID Id)
{
    local ItemInfo tmpInf;

    // End:0x8B
    if(!zAutoPotionWnd.iHPslot.GetItem(0, tmpInf))
    {
        zAutoPotionWnd.iHP = Id;
        SetOptionInt(GetMyName(), "ACP_slot_3_class", Id.ClassID);
        SetOptionInt(GetMyName(), "ACP_slot_3_server", Id.ServerID);        
    }
    else
    {
        // End:0x116
        if(!zAutoPotionWnd.iMPslot.GetItem(0, tmpInf))
        {
            zAutoPotionWnd.imp = Id;
            SetOptionInt(GetMyName(), "ACP_slot_4_class", Id.ClassID);
            SetOptionInt(GetMyName(), "ACP_slot_4_server", Id.ServerID);            
        }
        else
        {
            zAutoPotionWnd.iHP = Id;
            SetOptionInt(GetMyName(), "ACP_slot_3_class", Id.ClassID);
            SetOptionInt(GetMyName(), "ACP_slot_3_server", Id.ServerID);
        }
    }
    zAutoPotionWnd.PlaceItem();
    syncInventory();
    RefreshINI("windowsinfo.ini");
    return;
}

function syncInventory()
{
    local array<ItemInfo> itemarray, equipItemArray;
    local int i;
    local ItemInfo kClearItem;

    kClearItem.IconName = "L2ui_ct1.emptyBtn";
    ClearItemID(kClearItem.Id);
    itemarray = getInstanceL2Util().SortItemArray(inventoryWndScript.getInventoryPotionsArray());
    totalInven_ItemWnd.Clear();
    i = 0;
    J0x69:

    // End:0x103 [Loop If]
    if(i < itemarray.Length)
    {
        // End:0xF9
        if(IsACPSelectableItems(itemarray[i].Id.ClassID))
        {
            // End:0xDF
            if(IsEquippedPotion(itemarray[i].Id.ClassID))
            {
                itemarray[i].ForeTexture = "L2UI_CT1.Icon.WearPanel";
            }
            totalInven_ItemWnd.AddItem(itemarray[i]);
        }
        i++;
        // [Loop Continue]
        goto J0x69;
    }
    InvenoryCount.SetText(((("(" $ string(totalInven_ItemWnd.GetItemNum())) $ "/") $ string(10)) $ ")");
    return;
}

function bool IsEquippedPotion(int ClassID)
{
    local ItemInfo tmpInf;

    // End:0x3C
    if(zAutoPotionWnd.iHPslot.GetItem(0, tmpInf))
    {
        // End:0x3C
        if(tmpInf.Id.ClassID == ClassID)
        {
            return true;
        }
    }
    // End:0x78
    if(zAutoPotionWnd.iMPslot.GetItem(0, tmpInf))
    {
        // End:0x78
        if(tmpInf.Id.ClassID == ClassID)
        {
            return true;
        }
    }
    return;
}

function bool IsACPSelectableItems(int ClassID)
{
    local ItemInfo tmpInf;

    switch(ClassID)
    {
        // End:0x0F
        case 22025:
        // End:0x17
        case 1539:
        // End:0x1F
        case 1060:
        // End:0x27
        case 1061:
        // End:0x31
        case 728:
            return true;
        // End:0xFFFF
        default:
            // End:0x37
            break;
            break;
    }
    return;
}

function bool IsHp(int ClassID)
{
    switch(ClassID)
    {
        // End:0x0F
        case 22025:
        // End:0x17
        case 1539:
        // End:0x1F
        case 1060:
        // End:0x29
        case 1061:
            return true;
        // End:0xFFFF
        default:
            // End:0x2F
            break;
            break;
    }
    return;
}

function bool IsMp(int ClassID)
{
    switch(ClassID)
    {
        // End:0x11
        case 728:
            return true;
        // End:0xFFFF
        default:
            // End:0x17
            break;
            break;
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x0F
        case 9570:
        // End:0x17
        case 2070:
        // End:0x3A
        case 2620:
            // End:0x37
            if(Me.IsShowWindow())
            {
                syncInventory();
            }
            // End:0x5A
            break;
        // End:0x54
        case 2570:
            totalInven_ItemWnd.Clear();
            // End:0x5A
            break;
        // End:0xFFFF
        default:
            // End:0x5A
            break;
            break;
    }
    return;
}
