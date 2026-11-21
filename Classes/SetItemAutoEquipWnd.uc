class SetItemAutoEquipWnd extends UICommonAPI;

const ST_ITEMS = 0;
const ST_SETTINGS = 1;
const ITEMAUTOEQUIP_SET_LIST = 1020;
const MAX_SLOT = 6;
const MAX_SETTINGS_SLOT = 5;

var WindowHandle Me;
var ItemWindowHandle RefinedItems;
var ItemWindowHandle RefinedSkills;
var WindowHandle SetItemAutoEquipInventoryWnd;
var ButtonHandle SlotLockBtn;
var SetItemAutoEquipInventoryWnd SetItemAutoEquipInventory;
var WindowHandle SettingsWnd;
var WindowHandle SettingsContainer[5];
var ItemWindowHandle SettingItem[5];
var WindowHandle MainWnd;
var WindowHandle ItemContainer[6];
var ItemWindowHandle item[6];
var InventoryWnd Inventory;

function OnRegisterEvent()
{
    RegisterEvent(150);
    RegisterEvent(3550);
    return;
}

function OnLoad()
{
    local int i;

    Me = GetWindowHandle("SetItemAutoEquipWnd");
    SettingsWnd = GetWindowHandle("SetItemAutoEquipWnd.SettingsContainer");
    MainWnd = GetWindowHandle("SetItemAutoEquipWnd.MainContainer");
    SlotLockBtn = GetButtonHandle("SetItemAutoEquipWnd.MainContainer.SettingOpen.SlotLockBtn");
    SetItemAutoEquipInventoryWnd = GetWindowHandle("SetItemAutoEquipInventoryWnd");
    SetItemAutoEquipInventory = SetItemAutoEquipInventoryWnd(GetScript("SetItemAutoEquipInventoryWnd"));
    Inventory = InventoryWnd(GetScript("InventoryWnd"));
    i = 0;
    J0x149:

    // End:0x249 [Loop If]
    if(i < 5)
    {
        SettingsContainer[i] = GetWindowHandle("SetItemAutoEquipWnd.SettingsContainer.SettingItem_" $ getInstanceL2Util().makeZeroString(2, (i)));
        SettingItem[i] = GetItemWindowHandle((("SetItemAutoEquipWnd.SettingsContainer.SettingItem_" $ getInstanceL2Util().makeZeroString(2, (i))) $ ".SetItem_") $ getInstanceL2Util().makeZeroString(2, (i)));
        i++;
        // [Loop Continue]
        goto J0x149;
    }
    i = 0;
    J0x250:

    // End:0x33D [Loop If]
    if(i < 6)
    {
        ItemContainer[i] = GetWindowHandle("SetItemAutoEquipWnd.MainContainer.SetItem_" $ getInstanceL2Util().makeZeroString(2, (i)));
        item[i] = GetItemWindowHandle((("SetItemAutoEquipWnd.MainContainer.SetItem_" $ getInstanceL2Util().makeZeroString(2, (i))) $ ".Item_") $ getInstanceL2Util().makeZeroString(2, (i)));
        i++;
        // [Loop Continue]
        goto J0x250;
    }
    setState(0);
    return;
}

function OnShow()
{
    setLock(GetOptionBool("Game", "SetItemLocked"));
    return;
}

function RqSet()
{
    local int i;
    local string param;
    local ItemInfo inf;

    param = "";
    i = 0;
    J0x0F:

    // End:0xB2 [Loop If]
    if(i < 5)
    {
        // End:0x80
        if(SettingItem[i].GetItem(0, inf))
        {
            // End:0x5F
            if(param == "")
            {
                param = string(inf.Id.ServerID);                
            }
            else
            {
                param = param @ string(inf.Id.ServerID);
            }
            // [Explicit Continue]
            goto J0xA8;
        }
        // End:0x98
        if(param == "")
        {
            param = string(0);
            // [Explicit Continue]
            goto J0xA8;
        }
        param = param @ "0";
        J0xA8:

        i++;
        // [Loop Continue]
        goto J0x0F;
    }
    RequestBypassToServer("setSet" @ param);
    return;
}

function ClearSettings()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x47 [Loop If]
    if(i < 5)
    {
        SettingItem[i].EnableWindow();
        SettingItem[i].Clear();
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function ClearMain()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x32 [Loop If]
    if(i < 6)
    {
        item[i].Clear();
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function setState(int State)
{
    switch(State)
    {
        // End:0x4E
        case 0:
            Me.SetWindowSize(235, 42);
            SettingsWnd.HideWindow();
            SetItemAutoEquipInventoryWnd.HideWindow();
            MainWnd.ShowWindow();
            // End:0xB2
            break;
        // End:0xAC
        case 1:
            Me.SetWindowSize(235, 42);
            SettingsWnd.ShowWindow();
            MainWnd.HideWindow();
            SetItemAutoEquipInventory.syncInventory(0, SettingItem[0]);
            SetItemAutoEquipInventoryWnd.ShowWindow();
            // End:0xB2
            break;
        // End:0xFFFF
        default:
            // End:0xB2
            break;
            break;
    }
    ClearSettings();
    return;
}

function showEquipInventory(int Index, ItemWindowHandle targetWindow)
{
    SetItemAutoEquipInventory.syncInventory(Index, targetWindow);
    SetItemAutoEquipInventoryWnd.ShowWindow();
    return;
}

function OnClickButton(string strID)
{
    // End:0x21
    if(strID == "SettingsBtn")
    {
        setState(1);        
    }
    else
    {
        // End:0x44
        if(strID == "SaveBtn")
        {
            RqSet();
            setState(0);            
        }
        else
        {
            // End:0x61
            if(strID == "BackBtn")
            {
                setState(0);                
            }
            else
            {
                // End:0x90
                if(strID == "SlotLockBtn")
                {
                    setLock(SlotLockBtn.GetButtonValue() == 0);
                }
            }
        }
    }
    return;
}

function setLock(bool bLock)
{
    // End:0x9E
    if(!bLock)
    {
        SlotLockBtn.SetTexture("L2UI_CH3.ShortcutWnd.joypad_unlock", "L2UI_CH3.ShortcutWnd.joypad_unlock_Down", "L2UI_CH3.ShortcutWnd.joypad_unlock");
        SlotLockBtn.SetButtonValue(0);        
    }
    else
    {
        SlotLockBtn.SetTexture("L2UI_CH3.ShortcutWnd.joypad_lock", "L2UI_CH3.ShortcutWnd.joypad_lock_Down", "L2UI_CH3.ShortcutWnd.joypad_lock");
        SlotLockBtn.SetButtonValue(1);
    }
    SetOptionBool("Game", "SetItemLocked", bool(SlotLockBtn.GetButtonValue()));
    return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local string WindowName;
    local int nIndex;
    local ItemInfo Info;

    WindowName = a_WindowHandle.GetWindowName();
    // End:0x7A
    if(InStr(WindowName, "SetItem_") > -1)
    {
        nIndex = int(Locs(WindowName, "SetItem_", "", true));
        // End:0x7A
        if(SettingItem[nIndex].IsEnableWindow())
        {
            showEquipInventory(nIndex, SettingItem[nIndex]);
        }
    }
    return;
}

function _OnEvent(string _param)
{
    local int EventID;

    ParseInt(_param, "EventID", EventID);
    switch(EventID)
    {
        // End:0x36
        case 1020:
            assignItems(_param);
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            // End:0x3C
            break;
            break;
    }
    return;
}

function assignItems(string _param)
{
    local int i;
    local array<string> Items, itemData;
    local ItemInfo chestInfo;
    local string Param1;

    ParseString(_param, "param1", Param1);
    ClearMain();
    // End:0x2C
    if(Param1 == "")
    {
        return;
    }
    Items = Arr(Param1, "|");
    // End:0x4E
    if(Items.Length <= 0)
    {
        return;
    }
    i = 0;
    J0x55:

    // End:0xC5 [Loop If]
    if(i < Items.Length)
    {
        itemData = Arr(Items[i], ";");
        Class'NWindow.UIDATA_INVENTORY'.static.FindItem(int(itemData[1]), chestInfo);
        chestInfo.Reserved = int(itemData[0]);
        SetItem(chestInfo);
        i++;
        // [Loop Continue]
        goto J0x55;
    }
    return;
}

function SetItem(ItemInfo chestInfo)
{
    local int i;
    local ItemInfo inf;

    i = 0;
    J0x07:

    // End:0x65 [Loop If]
    if(i < 6)
    {
        // End:0x5B
        if(!item[i].GetItem(0, inf))
        {
            chestInfo.ItemSubType = 1;
            item[i].AddItem(chestInfo);
            return;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function setSettigsSlot(int Index, ItemInfo Info)
{
    local ItemInfo chest, Legs;

    // End:0xC5
    if(__NFUN_412__(Info.SlotBitType, (32768)))
    {
        Info.IconIndex = 1;
        chest = Info;
        SettingItem[Index].Clear();
        SettingItem[Index].AddItem(chest);
        Legs = Info;
        Legs.IconIndex = 2;
        SettingItem[Index + 1].Clear();
        SettingItem[Index + 1].AddItem(Legs);
        SettingItem[Index + 1].DisableWindow();        
    }
    else
    {
        // End:0x166
        if(__NFUN_412__(Info.SlotBitType, (1024)))
        {
            // End:0x116
            if(!SettingItem[Index].SetItem(0, Info))
            {
                SettingItem[Index].AddItem(Info);
            }
            // End:0x163
            if(!SettingItem[Index + 1].IsEnableWindow())
            {
                SettingItem[Index + 1].Clear();
                SettingItem[Index + 1].EnableWindow();
            }            
        }
        else
        {
            // End:0x1A0
            if(!SettingItem[Index].SetItem(0, Info))
            {
                SettingItem[Index].AddItem(Info);
            }
        }
    }
    return;
}

function bool checkSlots(ItemID Id)
{
    local ItemInfo Info;
    local int i;

    i = 0;
    J0x07:

    // End:0x54 [Loop If]
    if(i < 5)
    {
        // End:0x4A
        if(SettingItem[i].GetItem(0, Info))
        {
            // End:0x4A
            if(Info.Id == Id)
            {
                return true;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnEvent(int EventID, string param)
{
    // End:0x1D
    if(EventID == 3550)
    {
        _OnEvent(param);        
    }
    else
    {
        // End:0x30
        if(EventID == 150)
        {
            setState(0);
        }
    }
    return;
}

function int GetInventoryChestId()
{
    local ItemInfo Info;

    // End:0x3D
    if(Inventory.m_equipItem[Inventory.6].GetItem(0, Info))
    {
        return Info.Id.ServerID;
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo Info;
    local int nIndex;

    // End:0x85
    if(InStr(strID, "Item_") > -1)
    {
        nIndex = int(Locs(strID, "Item_", "", true));
        item[nIndex].GetItem(0, Info);
        // End:0x68
        if(Info.Id.ServerID == (GetInventoryChestId()))
        {
            return;
        }
        RequestBypassToServer("setUse " $ string(Info.Reserved));
    }
    return;
}

function OnDropItemSource(string strTarget, ItemInfo Info)
{
    // End:0x17
    if(SlotLockBtn.GetButtonValue() == 1)
    {
        return;
    }
    // End:0x47
    if(strTarget == "Console")
    {
        RequestBypassToServer("setDel " $ string(Info.Reserved));
    }
    return;
}
