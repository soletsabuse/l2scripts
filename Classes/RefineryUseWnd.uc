class RefineryUseWnd extends UICommonAPI;

const REFINERY_ASSINED_ITEMS = 1010;
const MAX_SLOT = 12;

var int dropIndex;
var WindowHandle Me;
var ButtonHandle SlotLockBtn;
var ItemWindowHandle RefinedItems;
var ItemWindowHandle RefinedSkills;
var WindowHandle ItemContainer[12];
var ItemWindowHandle item[12];
var TextureHandle ItemSmallIcon[12];

function OnRegisterEvent()
{
    RegisterEvent(3550);
    return;
}

function OnLoad()
{
    local int i;

    Me = GetWindowHandle("RefineryUseWnd");
    SlotLockBtn = GetButtonHandle("RefineryUseWnd.SlotLockBtn");
    i = 0;
    J0x4B:

    // End:0x193 [Loop If]
    if(i < 12)
    {
        ItemContainer[i] = GetWindowHandle("RefineryUseWnd.RefineryUse_" $ getInstanceL2Util().makeZeroString(2, (i)));
        item[i] = GetItemWindowHandle((("RefineryUseWnd.RefineryUse_" $ getInstanceL2Util().makeZeroString(2, (i))) $ ".Item_") $ getInstanceL2Util().makeZeroString(2, (i)));
        ItemSmallIcon[i] = GetTextureHandle((("RefineryUseWnd.RefineryUse_" $ getInstanceL2Util().makeZeroString(2, (i))) $ ".StoneSkillIcon_") $ getInstanceL2Util().makeZeroString(2, (i)));
        i++;
        // [Loop Continue]
        goto J0x4B;
    }
    Clear();
    return;
}

function OnShow()
{
    setLock(GetOptionBool("Game", "RefineryItemLocked"));
    return;
}

function _OnEvent(string _param)
{
    local int EventID;

    ParseInt(_param, "EventID", EventID);
    switch(EventID)
    {
        // End:0x36
        case 1010:
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
    local ItemInfo weaponItemInfo;
    local SkillInfo stoneSkillInfo;
    local string Param1;

    Clear();
    ParseString(_param, "param1", Param1);
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

    // End:0xD6 [Loop If]
    if(i < Items.Length)
    {
        itemData = Arr(Items[i], ";");
        Class'NWindow.UIDATA_INVENTORY'.static.FindItem(int(itemData[0]), weaponItemInfo);
        GetSkillInfo(int(itemData[1]), 1, 0, stoneSkillInfo);
        SetItem(weaponItemInfo, stoneSkillInfo, int(itemData[2]));
        i++;
        // [Loop Continue]
        goto J0x55;
    }
    ShowSlots(true);
    return;
}

function SetItem(ItemInfo weaponInfo, SkillInfo stoneSkillInfo, int Index)
{
    local int i;
    local ItemInfo inf;

    item[Index].AddItem(weaponInfo);
    ItemSmallIcon[Index].SetTexture(stoneSkillInfo.TexName);
    return;
}

function ShowSlots(bool bMoreSlots)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x55 [Loop If]
    if(i < 12)
    {
        ItemContainer[i].ShowWindow();
        // End:0x4B
        if((i >= ((12 / 2) - 1)) && !bMoreSlots)
        {
            // [Explicit Break]
            goto J0x55;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x55:

    // End:0x74
    if(bMoreSlots)
    {
        Me.SetWindowSize(271, 84);
    }
    return;
}

function Clear()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x71 [Loop If]
    if(i < 12)
    {
        // End:0x3B
        if((i + 1) > (12 / 2))
        {
            ItemContainer[i].HideWindow();
        }
        item[i].super(RefineryUseWnd).Clear();
        ItemSmallIcon[i].SetTexture("");
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    Me.SetWindowSize(271, 84 / 2);
    return;
}

function OnEvent(int EventID, string param)
{
    // End:0x1A
    if(EventID == 3550)
    {
        _OnEvent(param);
    }
    return;
}

function OnClickButton(string strID)
{
    // End:0x2F
    if(strID == "SlotLockBtn")
    {
        setLock(SlotLockBtn.GetButtonValue() == 0);
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
    SetOptionBool("Game", "RefineryItemLocked", bool(SlotLockBtn.GetButtonValue()));
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo Info;
    local int nIndex;

    // End:0x6E
    if(InStr(strID, "Item_") > -1)
    {
        nIndex = int(Locs(strID, "Item_", "", true));
        item[nIndex].GetItem(0, Info);
        RequestBypassToServer("refUse " $ string(Info.Id.ServerID));
    }
    return;
}

function OnDragItemStart(string a_WindowID, ItemInfo infItem)
{
    local int Index;
    local ItemInfo tmpInfo;

    // End:0x31
    if(InStr(a_WindowID, "Item_") > -1)
    {
        Index = int(Locs(a_WindowID, "Item_", "", true));
    }
    return;
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    local int Index;
    local ItemInfo tmpInfo;

    // End:0x5B
    if(InStr(a_WindowID, "Item_") > -1)
    {
        Index = int(Locs(a_WindowID, "Item_", "", true));
        RequestBypassToServer(("refSet" @ string(Index)) @ string(a_ItemInfo.Id.ServerID));
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
    // End:0x4C
    if(strTarget == "Console")
    {
        RequestBypassToServer("refDel " $ string(Info.Id.ServerID));
    }
    return;
}

function bool isAlreadyInList(int ServerID)
{
    local int i;
    local ItemInfo tmpInfo;

    i = 0;
    J0x07:

    // End:0x56 [Loop If]
    if(i < 12)
    {
        // End:0x4C
        if(item[i].GetItem(0, tmpInfo))
        {
            // End:0x4C
            if(tmpInfo.Id.ServerID == ServerID)
            {
                return true;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}
