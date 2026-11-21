class GMInventoryWnd extends InventoryWnd;

const EV_MASTER_EXTENDED_INFO = 6550;

struct GMHennaInfo
{
    var int HennaID;
    var int IsActive;
    var int Period;
};

var bool bShow;
var int m_ObservingUserInvenLimit;
var INT64 m_Adena;
var bool m_HasLEar;
var bool m_HasLFinger;
var array<GMHennaInfo> m_HennaInfoList;
var GMHennaInfo m_PremiumHennaInfo;

function OnRegisterEvent()
{
    RegisterEvent(2401);
    RegisterEvent(2402);
    RegisterEvent(2403);
    RegisterEvent(2405);
    RegisterEvent(2404);
    RegisterEvent(8000);
    RegisterEvent(3550);
    return;
}

function OnLoad()
{
    local WindowHandle hCrystallizeButton, hTrashButton, hInvenWeight;

    InitHandleCOD();
    setEquipWindowHandle();
    getHandles();
    hCrystallizeButton = GetWindowHandle("GMInventoryWnd.CrystallizeButton");
    hTrashButton = GetWindowHandle("GMInventoryWnd.TrashButton");
    hInvenWeight = GetWindowHandle("GMInventoryWnd.InvenWeight");
    bShow = false;
    m_hOwnerWnd.SetWindowTitle(GetSystemString(138));
    hCrystallizeButton.HideWindow();
    hTrashButton.HideWindow();
    hInvenWeight.HideWindow();
    InitScrollBar();
    m_bCurrentState = false;
    m_selectedItemTab = 0;
    currentInvenCol = GetOptionInt("Game", "ItemInventoryCol");
    // End:0x137
    if((currentInvenCol != 9) && currentInvenCol != 12)
    {
        currentInvenCol = 9;
    }
    return;
}

function OnShow()
{
    HennaButton.HideWindow();
    setButtons();
    SetAdenaText();
    SetItemCount();
    setAhclemyOpener();
    UpdateHennaInfo();
    // End:0x5A
    if(currentInvenCol == 9)
    {
        m_InventoryItembg.ShowWindow();
        m_InventoryItembg_expand.HideWindow();        
    }
    else
    {
        // End:0x6D
        if(currentInvenCol == 12)
        {
            extendInventory(true);
        }
    }
    return;
}

function OnHide()
{
    return;
}

function ShowInventory(string a_Param)
{
    // End:0x0E
    if(a_Param == "")
    {
        return;
    }
    // End:0x37
    if(bShow)
    {
        HandleClear();
        m_hOwnerWnd.HideWindow();
        bShow = false;        
    }
    else
    {
        Class'NWindow.GMAPI'.static.RequestGMCommand(5, a_Param);
        bShow = true;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 2401:
            HandleGMObservingInventoryAddItem(a_Param);
            // End:0xA2
            break;
        // End:0x33
        case 2402:
            HandleGMObservingInventoryClear(a_Param);
            // End:0xA2
            break;
        // End:0x49
        case 2403:
            HandleGMAddHennaInfo(a_Param);
            // End:0xA2
            break;
        // End:0x5F
        case 2404:
            HandleGMUpdateHennaInfo(a_Param);
            // End:0xA2
            break;
        // End:0x75
        case 2405:
            HandleGMAddPremiumHennaInfo(a_Param);
            // End:0xA2
            break;
        // End:0x86
        case 8000:
            checkClassicForm();
            // End:0xA2
            break;
        // End:0x9C
        case 3550:
            handleCustomPacket(a_Param);
            // End:0xA2
            break;
        // End:0xFFFF
        default:
            // End:0xA2
            break;
            break;
    }
    return;
}

function handleCustomPacket(string param)
{
    local int EventID;

    ParseInt(param, "EventID", EventID);
    switch(EventID)
    {
        // End:0x36
        case 6550:
            handleMasterExtendedInfo(param);
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

function handleMasterExtendedInfo(string param)
{
    local int i;
    local string itemsLine;
    local array<string> Items;
    local ItemInfo item;

    ParseString(param, "param1", itemsLine);
    Items = Arr(itemsLine, ",");
    i = 0;
    J0x33:

    // End:0xB5 [Loop If]
    if(i < Items.Length)
    {
        m_equipItem[26 + i].Clear();
        // End:0xAB
        if((int(Items[i]) > 0) && GetItemInfoByClassID(int(Items[i]), item, false))
        {
            m_equipItem[26 + i].AddItem(item);
        }
        i++;
        // [Loop Continue]
        goto J0x33;
    }
    return;
}

function HandleGMObservingInventoryAddItem(string a_Param)
{
    HandleAddItem(a_Param);
    SetItemCount();
    return;
}

function HandleAddItem(string param)
{
    local ItemInfo Info;

    ParamToItemInfo(param, Info);
    // End:0x2C
    if(IsEquipItem(Info))
    {
        EquipItemUpdate(Info);        
    }
    else
    {
        // End:0x51
        if(IsQuestItem(Info))
        {
            m_questItem.AddItem(Info);            
        }
        else
        {
            // End:0x74
            if(IsAdena(Info.Id))
            {
                SetAdena(Info.ItemNum);
            }
            NormalInvenAddItem(Info);
        }
    }
    return;
}

function SetAdena(INT64 a_Adena)
{
    m_Adena = a_Adena;
    SetAdenaText();
    return;
}

function SetAdenaText()
{
    local string adenaString;

    adenaString = MakeCostString((m_Adena));
    m_hAdenaTextBox.SetText(adenaString);
    m_hAdenaTextBox.SetTooltipString(ConvertNumToText((m_Adena)));
    return;
}

function int GetMyInventoryLimit()
{
    return m_ObservingUserInvenLimit;
    return;
}

function HandleGMObservingInventoryClear(string a_Param)
{
    HandleClear();
    ParseInt(a_Param, "InvenLimit", m_ObservingUserInvenLimit);
    m_hOwnerWnd.ShowWindow();
    m_hOwnerWnd.SetFocus();
    return;
}

function HandleGMAddHennaInfo(string a_Param)
{
    m_HennaInfoList.Length = m_HennaInfoList.Length + 1;
    ParseInt(a_Param, "ID", m_HennaInfoList[m_HennaInfoList.Length - 1].HennaID);
    ParseInt(a_Param, "bActive", m_HennaInfoList[m_HennaInfoList.Length - 1].IsActive);
    UpdateHennaInfo();
    return;
}

function HandleGMAddPremiumHennaInfo(string a_Param)
{
    ParseInt(a_Param, "ID", m_PremiumHennaInfo.HennaID);
    ParseInt(a_Param, "bActive", m_PremiumHennaInfo.IsActive);
    ParseInt(a_Param, "Period", m_PremiumHennaInfo.Period);
    GMUpdatePremiumHennaInfo();
    return;
}

function HandleGMUpdateHennaInfo(string a_Param)
{
    m_hHennaItemWindow.Clear();
    m_HennaInfoList.Length = 0;
    m_PremiumHennaInfo.HennaID = 0;
    m_PremiumHennaInfo.IsActive = 0;
    m_PremiumHennaInfo.Period = 0;
    m_hPremiumHennaItemWindow.Clear();
    return;
}

function OnDropItem(string strTarget, ItemInfo Info, int X, int Y)
{
    return;
}

function OnDropItemSource(string strTarget, ItemInfo Info)
{
    return;
}

function OnDBClickItem(string strID, int Index)
{
    return;
}

function OnRClickItem(string strID, int Index)
{
    return;
}

function EquipItemUpdate(ItemInfo a_Info)
{
    local ItemWindowHandle hItemWnd;

    super.EquipItemUpdate(a_Info);
    switch(a_Info.SlotBitType)
    {
        // End:0x1E
        case (2):
        // End:0x25
        case (4):
        // End:0x66
        case (6):
            // End:0x55
            if(0 == m_equipItem[8].GetItemNum())
            {
                hItemWnd = m_equipItem[8];                
            }
            else
            {
                hItemWnd = m_equipItem[9];
            }
            // End:0xBB
            break;
        // End:0x6D
        case (16):
        // End:0x74
        case (32):
        // End:0xB5
        case (48):
            // End:0xA4
            if(0 == m_equipItem[13].GetItemNum())
            {
                hItemWnd = m_equipItem[13];                
            }
            else
            {
                hItemWnd = m_equipItem[14];
            }
            // End:0xBB
            break;
        // End:0xFFFF
        default:
            // End:0xBB
            break;
            break;
    }
    // End:0xE9
    if(none != hItemWnd)
    {
        hItemWnd.Clear();
        hItemWnd.AddItem(a_Info);
    }
    return;
}

function int IsLOrREar(ItemID sID)
{
    return 0;
    return;
}

function int IsLOrRFinger(ItemID sID)
{
    return 0;
    return;
}

function UpdateHennaInfo()
{
    local int i;
    local ItemInfo HennaItemInfo;

    m_hHennaItemWindow.Clear();
    m_hHennaItemWindow.SetRow(m_HennaInfoList.Length);
    i = 0;
    J0x2B:

    // End:0x11D [Loop If]
    if(i < m_HennaInfoList.Length)
    {
        // End:0x6C
        if(!Class'NWindow.UIDATA_HENNA'.static.GetItemName(m_HennaInfoList[i].HennaID, HennaItemInfo.Name))
        {
            // [Explicit Break]
            goto J0x11D;
        }
        // End:0x9D
        if(!Class'NWindow.UIDATA_HENNA'.static.GetDescription(m_HennaInfoList[i].HennaID, HennaItemInfo.Description))
        {
            // [Explicit Break]
            goto J0x11D;
        }
        // End:0xCE
        if(!Class'NWindow.UIDATA_HENNA'.static.GetIconTex(m_HennaInfoList[i].HennaID, HennaItemInfo.IconName))
        {
            // [Explicit Break]
            goto J0x11D;
        }
        // End:0xF3
        if(0 == m_HennaInfoList[i].IsActive)
        {
            HennaItemInfo.bDisabled = 1;            
        }
        else
        {
            HennaItemInfo.bDisabled = 0;
        }
        m_hHennaItemWindow.AddItem(HennaItemInfo);
        ++i;
        // [Loop Continue]
        goto J0x2B;
    }
    J0x11D:

    return;
}

function GMUpdatePremiumHennaInfo()
{
    local int HennaID;
    local ItemInfo HennaItemInfo;
    local bool hennacheck;

    m_hPremiumHennaItemWindow.Clear();
    HennaID = m_PremiumHennaInfo.HennaID;
    hennacheck = Class'NWindow.UIDATA_HENNA'.static.GetItemCheck(HennaID);
    // End:0xB5
    if(hennacheck)
    {
        HennaItemInfo.Name = Class'NWindow.UIDATA_HENNA'.static.GetItemNameS(HennaID);
        HennaItemInfo.Description = Class'NWindow.UIDATA_HENNA'.static.GetDescriptionS(HennaID);
        HennaItemInfo.IconName = Class'NWindow.UIDATA_HENNA'.static.GetIconTexS(HennaID);
        HennaItemInfo.CurrentPeriod = m_PremiumHennaInfo.Period;
    }
    // End:0xD4
    if(0 == m_PremiumHennaInfo.IsActive)
    {
        HennaItemInfo.bDisabled = 1;        
    }
    else
    {
        HennaItemInfo.bDisabled = 0;
    }
    m_hPremiumHennaItemWindow.AddItem(HennaItemInfo);
    return;
}

defaultproperties
{
    m_WindowName="GMInventoryWnd"
}