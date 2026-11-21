class ItemLookChangeWnd extends UICommonAPI;

const DIALOG_RESULT_SUCCESS = 303;
const DIALOG_RESULT_FAILURE = 304;
const DIALOG_ONLY_NOTICE = 5555;
const DIALOG_LOOKCHANGE_START = 4444;
const DIALOG_LOOKCHANGE_START_FINAL = 7777;
const DIALOG_RESTORELOOKCHANGE_START = 6666;
const C_ANIMLOOPCOUNT = 1;

enum EShapeShiftingWindowType
{
    SST_WindowInvalid,              // 0
    SST_WindowNormal,               // 1
    SST_WindowBlessed,              // 2
    SST_WindowFixed,                // 3
    SST_WindowRestore,              // 4
    SST_WindowMax                   // 5
};

enum EShapeWindowType
{
    SWT_InvalID,                    // 0
    SWT_Weapon,                     // 1
    SWT_Armor,                      // 2
    SWT_Hair_Accessary,             // 3
    SWT_AllItem,                    // 4
    SWT_Max                         // 5
};

var WindowHandle Me;
var TextureHandle BackPattern;
var TextBoxHandle WeaponSlotTxt;
var TextBoxHandle LookSlotTxt;
var TextBoxHandle RestoreSlotTxt;
var TextBoxHandle InstructionTxt;
var TextBoxHandle AdenaText;
var ItemWindowHandle StoneItemSlot;
var ItemWindowHandle WeaponItemSlot;
var ItemWindowHandle LookItemSlot;
var ItemWindowHandle RestoreItemSlot;
var ItemWindowHandle EnchantedItemSlot;
var ButtonHandle EnchantBtn;
var ButtonHandle ExitBtn;
var ButtonHandle OkBtn;
var TextureHandle GroupBox2;
var TextureHandle GroupBox1;
var TextureHandle StoneItemSlotBackTex;
var TextureHandle WeaponItemSlotBackTex;
var TextureHandle LookItemSlotBackTex;
var TextureHandle RestoreItemSlotBackTex;
var TextureHandle EnchantedItemSlotBackTex;
var TextureHandle DropHighlight_StoneItem;
var TextureHandle DropHighlight_WeaponItem;
var TextureHandle DropHighlight_LookItem;
var TextureHandle DropHighlight_RestoreItem;
var AnimTextureHandle EnchantProgressAnim;
var ProgressCtrlHandle m_hItemLookChangeWndEnchantProgress;
var bool bItemLookChangebool;
var bool bItemLookChangedbool;
var int mItemLookChangeType;
var INT64 mPriceAdena;
var bool bIsShopping;
var ItemInfo TempDropItemInfo;
var ItemInfo weaponItemInfo;
var ItemInfo LookWeaponItemInfo;
var ItemLookChangeWnd.EShapeShiftingWindowType eShapeShiftingWindow;
var ItemLookChangeWnd.EShapeWindowType eShapeWindow;
var bool bItemLookEnchantStart;
var InventoryWnd inventoryWndScript;

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x590
    if(1 == 0)
    {
        Me = GetHandle("ItemLookChangeWnd");
        EnchantProgressAnim = AnimTextureHandle(GetHandle("ItemLookChangeWnd.EnchantProgressAnim"));
        BackPattern = TextureHandle(GetHandle("ItemLookChangeWnd.BackPattern"));
        WeaponSlotTxt = TextBoxHandle(GetHandle("ItemLookChangeWnd.WeaponSlotTxt"));
        LookSlotTxt = TextBoxHandle(GetHandle("ItemLookChangeWnd.LookSlotTxt"));
        RestoreSlotTxt = TextBoxHandle(GetHandle("ItemLookChangeWnd.RestoreSlotTxt"));
        InstructionTxt = TextBoxHandle(GetHandle("ItemLookChangeWnd.InstructionTxt"));
        AdenaText = TextBoxHandle(GetHandle("ItemLookChangeWnd.AdenaText"));
        StoneItemSlot = ItemWindowHandle(GetHandle("ItemLookChangeWnd.StoneItemSlot"));
        WeaponItemSlot = ItemWindowHandle(GetHandle("ItemLookChangeWnd.WeaponItemSlot"));
        LookItemSlot = ItemWindowHandle(GetHandle("ItemLookChangeWnd.LookItemSlot"));
        RestoreItemSlot = ItemWindowHandle(GetHandle("ItemLookChangeWnd.RestoreItemSlot"));
        EnchantedItemSlot = ItemWindowHandle(GetHandle("ItemLookChangeWnd.EnchantedItemSlot"));
        EnchantBtn = ButtonHandle(GetHandle("ItemLookChangeWnd.EnchantBtn"));
        ExitBtn = ButtonHandle(GetHandle("ItemLookChangeWnd.ExitBtn"));
        OkBtn = ButtonHandle(GetHandle("ItemLookChangeWnd.OkBtn"));
        GroupBox2 = TextureHandle(GetHandle("ItemLookChangeWnd.Groupbox2"));
        GroupBox1 = TextureHandle(GetHandle("ItemLookChangeWnd.Groupbox1"));
        StoneItemSlotBackTex = TextureHandle(GetHandle("ItemLookChangeWnd.StoneItemSlotBackTex"));
        WeaponItemSlotBackTex = TextureHandle(GetHandle("ItemLookChangeWnd.WeaponItemSlotBackTex"));
        LookItemSlotBackTex = TextureHandle(GetHandle("ItemLookChangeWnd.LookItemSlotBackTex"));
        RestoreItemSlotBackTex = TextureHandle(GetHandle("ItemLookChangeWnd.RestoreItemSlotBackTex"));
        EnchantedItemSlotBackTex = TextureHandle(GetHandle("ItemLookChangeWnd.EnchantedItemSlotBackTex"));
        DropHighlight_StoneItem = TextureHandle(GetHandle("ItemLookChangeWnd.DropHighlight_StoneItem"));
        DropHighlight_WeaponItem = TextureHandle(GetHandle("ItemLookChangeWnd.DropHighlight_WeaponItem"));
        DropHighlight_LookItem = TextureHandle(GetHandle("ItemLookChangeWnd.DropHighlight_LookItem"));
        DropHighlight_RestoreItem = TextureHandle(GetHandle("ItemLookChangeWnd.DropHighlight_RestoreItem"));        
    }
    else
    {
        Me = GetWindowHandle("ItemLookChangeWnd");
        EnchantProgressAnim = GetAnimTextureHandle("ItemLookChangeWnd.EnchantProgressAnim");
        BackPattern = GetTextureHandle("ItemLookChangeWnd.BackPattern");
        WeaponSlotTxt = GetTextBoxHandle("ItemLookChangeWnd.WeaponSlotTxt");
        LookSlotTxt = GetTextBoxHandle("ItemLookChangeWnd.LookSlotTxt");
        RestoreSlotTxt = GetTextBoxHandle("ItemLookChangeWnd.RestoreSlotTxt");
        InstructionTxt = GetTextBoxHandle("ItemLookChangeWnd.InstructionTxt");
        AdenaText = GetTextBoxHandle("ItemLookChangeWnd.AdenaText");
        StoneItemSlot = GetItemWindowHandle("ItemLookChangeWnd.StoneItemSlot");
        WeaponItemSlot = GetItemWindowHandle("ItemLookChangeWnd.WeaponItemSlot");
        LookItemSlot = GetItemWindowHandle("ItemLookChangeWnd.LookItemSlot");
        RestoreItemSlot = GetItemWindowHandle("ItemLookChangeWnd.RestoreItemSlot");
        EnchantedItemSlot = GetItemWindowHandle("ItemLookChangeWnd.EnchantedItemSlot");
        EnchantBtn = GetButtonHandle("ItemLookChangeWnd.EnchantBtn");
        ExitBtn = GetButtonHandle("ItemLookChangeWnd.ExitBtn");
        OkBtn = GetButtonHandle("ItemLookChangeWnd.OkBtn");
        GroupBox2 = GetTextureHandle("ItemLookChangeWnd.Groupbox2");
        GroupBox1 = GetTextureHandle("ItemLookChangeWnd.Groupbox1");
        StoneItemSlotBackTex = GetTextureHandle("ItemLookChangeWnd.StoneItemSlotBackTex");
        WeaponItemSlotBackTex = GetTextureHandle("ItemLookChangeWnd.WeaponItemSlotBackTex");
        LookItemSlotBackTex = GetTextureHandle("ItemLookChangeWnd.LookItemSlotBackTex");
        RestoreItemSlotBackTex = GetTextureHandle("ItemLookChangeWnd.RestoreItemSlotBackTex");
        EnchantedItemSlotBackTex = GetTextureHandle("ItemLookChangeWnd.EnchantedItemSlotBackTex");
        DropHighlight_StoneItem = GetTextureHandle("ItemLookChangeWnd.DropHighlight_StoneItem");
        DropHighlight_WeaponItem = GetTextureHandle("ItemLookChangeWnd.DropHighlight_WeaponItem");
        DropHighlight_LookItem = GetTextureHandle("ItemLookChangeWnd.DropHighlight_LookItem");
        DropHighlight_RestoreItem = GetTextureHandle("ItemLookChangeWnd.DropHighlight_RestoreItem");
        m_hItemLookChangeWndEnchantProgress = GetProgressCtrlHandle("ItemLookChangeWnd.EnchantProgress");
    }
    Initialize();
    load();
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
    switch(DialogGetID())
    {
        // End:0x37
        case 1111:
        // End:0x3F
        case 2222:
        // End:0x47
        case 3333:
        // End:0x4F
        case 4444:
        // End:0x57
        case 5555:
        // End:0x5F
        case 6666:
        // End:0x67
        case 7777:
        // End:0x6F
        case 8888:
        // End:0x77
        case 9998:
        // End:0x7F
        case 9999:
        // End:0x90
        case 10000:
            DialogHide();
            // End:0x93
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function Initialize()
{
    mPriceAdena = (0);
    bItemLookChangebool = false;
    bItemLookChangedbool = false;
    bIsShopping = false;
    eShapeShiftingWindow = 0;
    eShapeWindow = 1;
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(9260);
    RegisterEvent(9270);
    RegisterEvent(9280);
    RegisterEvent(9290);
    RegisterEvent(9300);
    RegisterEvent(1710);
    return;
}

function load()
{
    inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int shape, ShowWindow;
    local ItemID cID;

    // End:0xC8
    if(Event_ID == 9260)
    {
        ParseInt(param, "ShapeType", shape);
        ParseInt(param, "ShapeShiftingType", ShowWindow);
        ParseItemID(param, cID);
        eShapeShiftingWindow = GetShapeShiftingType(ShowWindow);
        eShapeWindow = GetShapeType(shape);
        // End:0xB6
        if(!bIsShopping)
        {
            // End:0xA8
            if(int(eShapeShiftingWindow) == int(4))
            {
                HandleRestoreLookChangeShow(cID);                
            }
            else
            {
                HandleLookChangeShow(cID);
            }            
        }
        else
        {
            Class'NWindow.ItemLookChangeAPI'.static.RequestExCancelItemLookChange();
        }        
    }
    else
    {
        // End:0x103
        if(Event_ID == 9290)
        {
            // End:0xF5
            if(int(eShapeShiftingWindow) == int(4))
            {
                HandleRestorePutTargetItemResult(param);                
            }
            else
            {
                HandlePutTargetItemResult(param);
            }            
        }
        else
        {
            // End:0x120
            if(Event_ID == 9300)
            {
                HandletPutSupportItemResult(param);                
            }
            else
            {
                // End:0x1C1
                if(Event_ID == 9280)
                {
                    Debug("Event_ID EV_ItemLookChangeResult" @ param);
                    // End:0x195
                    if(int(eShapeShiftingWindow) == int(4))
                    {
                        Debug("SST_WindowRestore");
                        HandlerRestoreLookChangeResult(param);                        
                    }
                    else
                    {
                        Debug("HandleLookChangeResult");
                        HandleLookChangeResult(param);
                    }                    
                }
                else
                {
                    // End:0x1D9
                    if(Event_ID == 1710)
                    {
                        HandleDialogOK();                        
                    }
                    else
                    {
                        // End:0x1E8
                        if(Event_ID == 1720)
                        {
                        }
                    }
                }
            }
        }
    }
    return;
}

function ItemLookChangeWnd.EShapeShiftingWindowType GetShapeShiftingType(int ShowWindow)
{
    // End:0x11
    if(ShowWindow == 0)
    {
        return 0;        
    }
    else
    {
        // End:0x22
        if(ShowWindow == 1)
        {
            return 1;            
        }
        else
        {
            // End:0x34
            if(ShowWindow == 2)
            {
                return 2;                
            }
            else
            {
                // End:0x46
                if(ShowWindow == 3)
                {
                    return 3;                    
                }
                else
                {
                    // End:0x55
                    if(ShowWindow == 4)
                    {
                        return 4;
                    }
                }
            }
        }
    }
    return 0;
    return;
}

function ItemLookChangeWnd.EShapeWindowType GetShapeType(int ShowWindow)
{
    // End:0x11
    if(ShowWindow == 1)
    {
        return 1;        
    }
    else
    {
        // End:0x23
        if(ShowWindow == 2)
        {
            return 2;            
        }
        else
        {
            // End:0x35
            if(ShowWindow == 3)
            {
                return 3;                
            }
            else
            {
                // End:0x44
                if(ShowWindow == 4)
                {
                    return 4;
                }
            }
        }
    }
    return 0;
    return;
}

function bool HandleDialogOK()
{
    local int Id;

    // End:0xBB
    if(DialogIsMine())
    {
        Id = DialogGetID();
        // End:0x4A
        if(Id == 4444)
        {
            DialogShow(0, 0, GetSystemMessage(6114), string(self));
            DialogSetID(7777);            
        }
        else
        {
            // End:0x7B
            if(Id == 6666)
            {
                OnRestoreLookChangeStart();
                EnchantBtn.DisableWindow();
                bItemLookEnchantStart = true;
                return true;                
            }
            else
            {
                // End:0xAC
                if(Id == 7777)
                {
                    OnLookChangeStart();
                    EnchantBtn.DisableWindow();
                    bItemLookEnchantStart = true;
                    return true;                    
                }
                else
                {
                    // End:0xBB
                    if(Id == 304)
                    {
                    }
                }
            }
        }
    }
    return false;
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x10A
        case "EnchantBtn":
            DialogHide();
            // End:0x62
            if(int(eShapeShiftingWindow) == int(4))
            {
                DialogShow(0, 0, MakeFullSystemMsg(GetSystemMessage(6082), weaponItemInfo.Name), string(self));
                DialogSetID(6666);                
            }
            else
            {
                // End:0xC4
                if((int(eShapeShiftingWindow) == int(1)) || int(eShapeShiftingWindow) == int(2))
                {
                    DialogShow(0, 0, MakeFullSystemMsg(GetSystemMessage(6080), weaponItemInfo.Name, LookWeaponItemInfo.Name), string(self));
                    DialogSetID(4444);                    
                }
                else
                {
                    // End:0x107
                    if(int(eShapeShiftingWindow) == int(3))
                    {
                        DialogShow(0, 0, MakeFullSystemMsg(GetSystemMessage(6081), weaponItemInfo.Name), string(self));
                        DialogSetID(4444);
                    }
                }
            }
            // End:0x179
            break;
        // End:0x15A
        case "ExitBtn":
            // End:0x148
            if(!bItemLookChangedbool)
            {
                Class'NWindow.ItemLookChangeAPI'.static.RequestExCancelItemLookChange();
                ProcCancel();
                Me.HideWindow();                
            }
            else
            {
                Me.HideWindow();
            }
            // End:0x179
            break;
        // End:0x176
        case "OkBtn":
            Me.HideWindow();
            // End:0x179
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleLookChangeShow(ItemID cID)
{
    local ItemID cFixID;
    local ItemInfo cItemInfo;

    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, cItemInfo);
    bItemLookChangedbool = false;
    ResetUI();
    Me.ShowWindow();
    Me.SetFocus();
    ExitBtn.SetNameText(GetSystemString(646));
    EnchantBtn.SetNameText(GetSystemString(428));
    cItemInfo.ItemNum = (1);
    StoneItemSlot.SetItem(0, cItemInfo);
    StoneItemSlot.AddItem(cItemInfo);
    PlaySound("ItemSound3.enchant_input");
    mItemLookChangeType = 0;
    ItemLookChangeThreeSlot();
    // End:0x193
    if(int(eShapeShiftingWindow) == int(3))
    {
        cFixID.ClassID = cItemInfo.LookChangeIconID;
        Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cFixID, LookWeaponItemInfo);
        LookItemSlot.SetItem(0, LookWeaponItemInfo);
        LookItemSlot.AddItem(LookWeaponItemInfo);
        DropHighlight_LookItem.ShowWindow();
        DropHighlight_LookItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
        LookItemSlotBackTex.HideWindow();
    }
    // End:0x21D
    if(int(eShapeWindow) == int(1))
    {
        WeaponItemSlotBackTex.SetTexture("l2ui_ct1.ItemLookChangeWnd_SlotBg_Weapon");
        LookItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Look");        
    }
    else
    {
        // End:0x2B2
        if(int(eShapeWindow) == int(2))
        {
            WeaponItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Armor");
            LookItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_ArmorLook");            
        }
        else
        {
            WeaponItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Cap");
            LookItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_CapLook");
        }
    }
    return;
}

function HandleRestoreLookChangeShow(ItemID cID)
{
    local ItemInfo cItemInfo;

    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, cItemInfo);
    bItemLookChangedbool = false;
    ResetUI();
    Me.ShowWindow();
    Me.SetFocus();
    ExitBtn.SetNameText(GetSystemString(646));
    EnchantBtn.SetNameText(GetSystemString(428));
    cItemInfo.ItemNum = (1);
    WeaponItemSlot.SetItem(0, cItemInfo);
    WeaponItemSlot.AddItem(cItemInfo);
    PlaySound("ItemSound3.enchant_input");
    mItemLookChangeType = 0;
    RestoreLookChangeTwoSlot();
    // End:0x129
    if(int(eShapeWindow) == int(1))
    {
        RestoreItemSlotBackTex.SetTexture("l2ui_ct1.ItemLookChangeWnd_SlotBg_Weapon");        
    }
    else
    {
        // End:0x17B
        if(int(eShapeWindow) == int(2))
        {
            RestoreItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Armor");            
        }
        else
        {
            // End:0x1CB
            if(int(eShapeWindow) == int(3))
            {
                RestoreItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Cap");                
            }
            else
            {
                RestoreItemSlotBackTex.SetTexture("BranchSys3.Icon.ItemLookChangeWnd_SlotBg_Equip");
            }
        }
    }
    return;
}

function ResetUI()
{
    OkBtn.HideWindow();
    EnchantProgressAnim.HideWindow();
    EnchantProgressAnim.HideWindow();
    EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Loading_01");
    EnchantProgressAnim.HideWindow();
    ExitBtn.ShowWindow();
    EnchantBtn.ShowWindow();
    EnchantBtn.DisableWindow();
    OkBtn.HideWindow();
    WeaponItemSlot.SetAlpha(255, 0.0000000);
    StoneItemSlot.Clear();
    WeaponItemSlot.Clear();
    LookItemSlot.Clear();
    RestoreItemSlot.Clear();
    EnchantedItemSlot.Clear();
    EnchantedItemSlotBackTex.HideWindow();
    m_hItemLookChangeWndEnchantProgress.SetProgressTime(1500);
    m_hItemLookChangeWndEnchantProgress.SetPos(0);
    m_hItemLookChangeWndEnchantProgress.Reset();
    DropHighlight_WeaponItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");
    DropHighlight_LookItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");
    DropHighlight_RestoreItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");
    weaponItemInfo.Id.ClassID = 0;
    weaponItemInfo.Id.ServerID = 0;
    LookWeaponItemInfo.Id.ClassID = 0;
    LookWeaponItemInfo.Id.ServerID = 0;
    mPriceAdena = (0);
    bItemLookEnchantStart = false;
    return;
}

function ItemLookChangeThreeSlot()
{
    RestoreSlotTxt.HideWindow();
    RestoreItemSlot.HideWindow();
    RestoreItemSlotBackTex.HideWindow();
    DropHighlight_RestoreItem.HideWindow();
    StoneItemSlot.SetAnchor("ItemLookChangeWnd", "TopLeft", "TopLeft", 141, 61);
    StoneItemSlot.ClearAnchor();
    StoneItemSlot.ShowWindow();
    StoneItemSlotBackTex.ShowWindow();
    WeaponItemSlot.SetAnchor("ItemLookChangeWnd", "TopLeft", "TopLeft", 79, 107);
    WeaponItemSlot.ClearAnchor();
    WeaponItemSlot.ShowWindow();
    WeaponItemSlotBackTex.ShowWindow();
    LookItemSlot.SetAnchor("ItemLookChangeWnd", "TopLeft", "TopLeft", 203, 107);
    LookItemSlot.ClearAnchor();
    LookItemSlot.ShowWindow();
    LookItemSlotBackTex.ShowWindow();
    WeaponSlotTxt.SetText(GetSystemString(5085));
    WeaponSlotTxt.ShowWindow();
    LookSlotTxt.ShowWindow();
    DropHighlight_StoneItem.ShowWindow();
    DropHighlight_WeaponItem.ShowWindow();
    DropHighlight_LookItem.HideWindow();
    // End:0x217
    if(int(eShapeWindow) == int(1))
    {
        Me.SetWindowTitle(GetSystemString(5083));
        InstructionTxt.SetText(GetSystemString(5088));        
    }
    else
    {
        // End:0x25E
        if(int(eShapeWindow) == int(2))
        {
            Me.SetWindowTitle(GetSystemString(5102));
            InstructionTxt.SetText(GetSystemString(5104));            
        }
        else
        {
            // End:0x2A2
            if(int(eShapeWindow) == int(3))
            {
                Me.SetWindowTitle(GetSystemString(5112));
                InstructionTxt.SetText(GetSystemString(5116));
            }
        }
    }
    AdenaText.SetText((mPriceAdena));
    return;
}

function RestoreLookChangeTwoSlot()
{
    WeaponSlotTxt.HideWindow();
    LookSlotTxt.HideWindow();
    StoneItemSlot.HideWindow();
    StoneItemSlotBackTex.HideWindow();
    LookItemSlot.HideWindow();
    LookItemSlotBackTex.HideWindow();
    WeaponItemSlot.SetAnchor("ItemLookChangeWnd", "TopLeft", "TopLeft", 79, 107);
    WeaponItemSlot.ClearAnchor();
    WeaponItemSlot.ShowWindow();
    WeaponItemSlotBackTex.ShowWindow();
    RestoreItemSlot.SetAnchor("ItemLookChangeWnd", "TopLeft", "TopLeft", 203, 107);
    RestoreItemSlot.ClearAnchor();
    RestoreItemSlot.ShowWindow();
    RestoreItemSlotBackTex.ShowWindow();
    RestoreSlotTxt.ShowWindow();
    DropHighlight_RestoreItem.ShowWindow();
    DropHighlight_WeaponItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
    DropHighlight_WeaponItem.ShowWindow();
    DropHighlight_LookItem.HideWindow();
    DropHighlight_StoneItem.HideWindow();
    // End:0x1E7
    if(int(eShapeWindow) == int(1))
    {
        Me.SetWindowTitle(GetSystemString(5084));
        InstructionTxt.SetText(GetSystemString(5090));        
    }
    else
    {
        // End:0x22E
        if(int(eShapeWindow) == int(2))
        {
            Me.SetWindowTitle(GetSystemString(5103));
            InstructionTxt.SetText(GetSystemString(5105));            
        }
        else
        {
            // End:0x275
            if(int(eShapeWindow) == int(3))
            {
                Me.SetWindowTitle(GetSystemString(5113));
                InstructionTxt.SetText(GetSystemString(5117));                
            }
            else
            {
                Me.SetWindowTitle(GetSystemString(5114));
                InstructionTxt.SetText(GetSystemString(5118));
            }
        }
    }
    AdenaText.SetText((mPriceAdena));
    return;
}

function OnLookChangeStart()
{
    local Rect Item1Rect, Item2Rect, Item3Rect, ResultRect;

    EnchantProgressAnim.SetLoopCount(1);
    EnchantProgressAnim.Stop();
    EnchantProgressAnim.Play();
    PlaySound("ItemSound3.enchant_process");
    EnchantProgressAnim.ShowWindow();
    bItemLookChangebool = true;
    m_hItemLookChangeWndEnchantProgress.Start();
    Item1Rect = StoneItemSlot.GetRect();
    Item2Rect = WeaponItemSlot.GetRect();
    Item3Rect = LookItemSlot.GetRect();
    ResultRect = EnchantedItemSlot.GetRect();
    StoneItemSlot.Move(ResultRect.nX - Item1Rect.nX, ResultRect.nY - Item1Rect.nY, 1.5000000);
    WeaponItemSlot.Move(ResultRect.nX - Item2Rect.nX, ResultRect.nY - Item2Rect.nY, 1.5000000);
    LookItemSlot.Move(ResultRect.nX - Item3Rect.nX, ResultRect.nY - Item3Rect.nY, 1.5000000);
    StoneItemSlotBackTex.HideWindow();
    WeaponItemSlotBackTex.HideWindow();
    LookItemSlotBackTex.HideWindow();
    WeaponSlotTxt.HideWindow();
    LookSlotTxt.HideWindow();
    ExitBtn.SetNameText(GetSystemString(141));
    EnchantBtn.SetNameText(GetSystemString(428));
    return;
}

function ProcCancel()
{
    mPriceAdena = (0);
    eShapeShiftingWindow = 0;
    bItemLookChangebool = false;
    m_hItemLookChangeWndEnchantProgress.Stop();
    EnchantProgressAnim.Stop();
    return;
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
    EnchantProgressAnim.HideWindow();
    EnchantProgressAnim.Stop();
    EnchantProgressAnim.HideWindow();
    switch(a_WindowHandle)
    {
        // End:0x6C
        case EnchantProgressAnim:
            // End:0x69
            if(bItemLookChangebool)
            {
                bItemLookChangebool = false;
                Class'NWindow.ItemLookChangeAPI'.static.RequestItemLookChange(weaponItemInfo.Id);                
            }
            // End:0x6F
            break;
        // End:0xFFFF
        default:
            break;
    }
    EnchantProgressAnim.HideWindow();
    return;
}

function OnHide()
{
    mPriceAdena = (0);
    bItemLookChangebool = false;
    eShapeShiftingWindow = 0;
    Class'NWindow.ItemLookChangeAPI'.static.RequestExCancelItemLookChange();
    return;
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    // End:0x0B
    if(bItemLookEnchantStart)
    {
        return;
    }
    TempDropItemInfo = a_ItemInfo;
    switch(a_WindowID)
    {
        // End:0x4C
        case "WeaponItemSlot":
            Class'NWindow.ItemLookChangeAPI'.static.RequestExTryToPut_Shape_Shifting_TargetItem(a_ItemInfo.Id);
            // End:0xC6
            break;
        // End:0x93
        case "LookItemSlot":
            // End:0x90
            if(int(eShapeShiftingWindow) != int(3))
            {
                Class'NWindow.ItemLookChangeAPI'.static.RequestExTryToPut_Shape_Shifting_EnchantSupportItem(weaponItemInfo.Id, a_ItemInfo.Id);
            }
            // End:0xC6
            break;
        // End:0xC3
        case "RestoreItemSlot":
            Class'NWindow.ItemLookChangeAPI'.static.RequestExTryToPut_Shape_Shifting_TargetItem(a_ItemInfo.Id);
            // End:0xC6
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandlePutTargetItemResult(string param)
{
    local int ResultID;
    local INT64 Adena;

    ParseInt(param, "Result", ResultID);
    ParseINT64(param, "Adena", Adena);
    // End:0x66
    if(ResultID <= 0)
    {
        DialogHide();
        DialogShow(1, 5, GetSystemString(5091), string(self));
        DialogSetID(5555);        
    }
    else
    {
        weaponItemInfo = TempDropItemInfo;
        WeaponItemSlot.SetItem(0, weaponItemInfo);
        WeaponItemSlot.AddItem(weaponItemInfo);
        DropHighlight_WeaponItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
        DropHighlight_LookItem.ShowWindow();
        StoneItemSlotBackTex.HideWindow();
        WeaponItemSlotBackTex.HideWindow();
        // End:0x144
        if(int(eShapeShiftingWindow) == int(3))
        {
            EnchantBtn.EnableWindow();
            InstructionTxt.SetText(MakeFullSystemMsg(GetSystemMessage(6075), weaponItemInfo.Name));            
        }
        else
        {
            InstructionTxt.SetText(GetSystemString(5089));
        }
        mPriceAdena = Adena;
        AdenaText.SetText((mPriceAdena));
    }
    return;
}

function HandletPutSupportItemResult(string param)
{
    local string StartTxt;
    local int ResultID;

    ParseInt(param, "Result", ResultID);
    // End:0x4F
    if(ResultID <= 0)
    {
        DialogHide();
        DialogShow(1, 5, GetSystemString(5092), string(self));
        DialogSetID(5555);        
    }
    else
    {
        LookWeaponItemInfo = TempDropItemInfo;
        LookItemSlot.SetItem(0, LookWeaponItemInfo);
        LookItemSlot.AddItem(LookWeaponItemInfo);
        DropHighlight_LookItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
        StoneItemSlotBackTex.HideWindow();
        WeaponItemSlotBackTex.HideWindow();
        LookItemSlotBackTex.HideWindow();
        EnchantBtn.EnableWindow();
        // End:0x124
        if(int(eShapeShiftingWindow) == int(2))
        {
            StartTxt = MakeFullSystemMsg(GetSystemMessage(6076), weaponItemInfo.Name);            
        }
        else
        {
            StartTxt = MakeFullSystemMsg(GetSystemMessage(6075), weaponItemInfo.Name);
        }
        InstructionTxt.SetText(StartTxt);
    }
    return;
}

function HandleLookChangeResult(string param)
{
    local int IntResult, CurrentPeriod;
    local ItemID WeaponItemID, LookWeaponItemID;
    local ItemInfo cResultWeaponItemID;
    local string EndTxt;

    EnchantProgressAnim.HideWindow();
    ParseInt(param, "Result", IntResult);
    ParseInt(param, "WeaponClassID", WeaponItemID.ClassID);
    ParseInt(param, "LookWeaponClassID", LookWeaponItemID.ClassID);
    ParseInt(param, "CurrentPeriod", CurrentPeriod);
    inventoryWndScript.getInventoryItemInfo(weaponItemInfo.Id, cResultWeaponItemID);
    LookItemSlotBackTex.HideWindow();
    WeaponItemSlotBackTex.HideWindow();
    EnchantedItemSlotBackTex.HideWindow();
    LookItemSlotBackTex.HideWindow();
    EnchantBtn.HideWindow();
    ExitBtn.HideWindow();
    switch(IntResult)
    {
        // End:0x2C7
        case 0:
            bItemLookChangedbool = true;
            EnchantProgressAnim.HideWindow();
            EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
            EnchantProgressAnim.SetLoopCount(1);
            EnchantProgressAnim.Stop();
            EnchantProgressAnim.Play();
            PlaySound("ItemSound3.enchant_fail");
            EnchantProgressAnim.ShowWindow();
            BackPattern.SetAlpha(0, 0.0000000);
            BackPattern.ShowWindow();
            BackPattern.SetAlpha(255, 2.0000000);
            EnchantedItemSlot.SetAlpha(0);
            EnchantedItemSlot.Clear();
            EnchantedItemSlot.AddItem(cResultWeaponItemID);
            EnchantedItemSlot.ShowWindow();
            EnchantedItemSlot.SetAlpha(255, 2.0000000);
            EndTxt = MakeFullSystemMsg(GetSystemMessage(6078), cResultWeaponItemID.Name);
            InstructionTxt.SetText(EndTxt);
            LookItemSlot.HideWindow();
            WeaponItemSlot.HideWindow();
            StoneItemSlot.HideWindow();
            LookItemSlot.HideWindow();
            // End:0x572
            break;
        // End:0x543
        case 1:
            bItemLookChangedbool = true;
            EnchantProgressAnim.HideWindow();
            EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
            EnchantProgressAnim.SetLoopCount(1);
            EnchantProgressAnim.Stop();
            EnchantProgressAnim.Play();
            PlaySound("ItemSound3.enchant_success");
            EnchantProgressAnim.ShowWindow();
            BackPattern.SetAlpha(0, 0.0000000);
            BackPattern.ShowWindow();
            BackPattern.SetAlpha(255, 2.0000000);
            cResultWeaponItemID.CurrentPeriod = CurrentPeriod;
            cResultWeaponItemID.LookChangeItemID = LookWeaponItemID.ClassID;
            cResultWeaponItemID.LookChangeItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(LookWeaponItemID);
            // End:0x43F
            if(cResultWeaponItemID.BodyPart == 28)
            {
                cResultWeaponItemID.LookChangeIconPanel = "BranchSys3.Icon.pannel_lookChange_All";                
            }
            else
            {
                cResultWeaponItemID.LookChangeIconPanel = "BranchSys3.Icon.pannel_lookChange";
            }
            EnchantedItemSlot.SetAlpha(0);
            EnchantedItemSlot.Clear();
            EnchantedItemSlot.AddItem(cResultWeaponItemID);
            EnchantedItemSlot.ShowWindow();
            EnchantedItemSlot.SetAlpha(255, 2.0000000);
            EndTxt = MakeFullSystemMsg(GetSystemMessage(6085), cResultWeaponItemID.Name, cResultWeaponItemID.LookChangeItemName);
            InstructionTxt.SetText(EndTxt);
            LookItemSlot.HideWindow();
            WeaponItemSlot.HideWindow();
            StoneItemSlot.HideWindow();
            LookItemSlot.HideWindow();
            // End:0x572
            break;
        // End:0xFFFF
        default:
            EnchantProgressAnim.HideWindow();
            // End:0x56F
            if(!bItemLookChangedbool)
            {
                Me.HideWindow();
            }
            // End:0x572
            break;
            break;
    }
    OkBtn.ShowWindow();
    return;
}

function HandleRestorePutTargetItemResult(string param)
{
    local int ResultID;
    local INT64 Adena;

    ParseInt(param, "Result", ResultID);
    ParseINT64(param, "Adena", Adena);
    // End:0x66
    if(ResultID <= 0)
    {
        DialogHide();
        DialogShow(1, 5, GetSystemString(5093), string(self));
        DialogSetID(5555);        
    }
    else
    {
        weaponItemInfo = TempDropItemInfo;
        RestoreItemSlot.SetItem(0, weaponItemInfo);
        RestoreItemSlot.AddItem(weaponItemInfo);
        DropHighlight_RestoreItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
        RestoreItemSlotBackTex.HideWindow();
        EnchantBtn.EnableWindow();
        mPriceAdena = Adena;
        AdenaText.SetText((mPriceAdena));
    }
    return;
}

function OnRestoreLookChangeStart()
{
    local Rect Item1Rect, Item2Rect, ResultRect;

    EnchantProgressAnim.SetLoopCount(1);
    EnchantProgressAnim.Stop();
    EnchantProgressAnim.Play();
    PlaySound("ItemSound3.enchant_process");
    EnchantProgressAnim.ShowWindow();
    bItemLookChangebool = true;
    m_hItemLookChangeWndEnchantProgress.Start();
    Item1Rect = RestoreItemSlot.GetRect();
    Item2Rect = WeaponItemSlot.GetRect();
    ResultRect = EnchantedItemSlot.GetRect();
    RestoreItemSlot.Move(ResultRect.nX - Item1Rect.nX, ResultRect.nY - Item1Rect.nY, 1.5000000);
    WeaponItemSlot.Move(ResultRect.nX - Item2Rect.nX, ResultRect.nY - Item2Rect.nY, 1.5000000);
    RestoreItemSlotBackTex.HideWindow();
    WeaponItemSlotBackTex.HideWindow();
    RestoreSlotTxt.HideWindow();
    ExitBtn.SetNameText(GetSystemString(141));
    EnchantBtn.SetNameText(GetSystemString(428));
    return;
}

function HandlerRestoreLookChangeResult(string param)
{
    local int IntResult;
    local ItemID WeaponItemID;
    local ItemInfo cResultWeaponItemID;
    local string EndTxt;

    EnchantProgressAnim.HideWindow();
    ParseInt(param, "Result", IntResult);
    ParseInt(param, "WeaponClassID", WeaponItemID.ClassID);
    inventoryWndScript.getInventoryItemInfo(weaponItemInfo.Id, cResultWeaponItemID);
    EnchantBtn.HideWindow();
    ExitBtn.HideWindow();
    switch(IntResult)
    {
        // End:0x244
        case 0:
            bItemLookChangedbool = true;
            EnchantProgressAnim.HideWindow();
            EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
            EnchantProgressAnim.SetLoopCount(1);
            EnchantProgressAnim.Stop();
            EnchantProgressAnim.Play();
            PlaySound("ItemSound3.enchant_fail");
            EnchantProgressAnim.ShowWindow();
            BackPattern.SetAlpha(0, 0.0000000);
            BackPattern.ShowWindow();
            BackPattern.SetAlpha(255, 2.0000000);
            EnchantedItemSlot.SetAlpha(0);
            EnchantedItemSlot.Clear();
            EnchantedItemSlot.AddItem(cResultWeaponItemID);
            EnchantedItemSlot.ShowWindow();
            EnchantedItemSlot.SetAlpha(255, 2.0000000);
            EndTxt = MakeFullSystemMsg(GetSystemMessage(6078), cResultWeaponItemID.Name);
            InstructionTxt.SetText(EndTxt);
            LookItemSlot.HideWindow();
            WeaponItemSlot.HideWindow();
            WeaponItemSlot.HideWindow();
            RestoreItemSlot.HideWindow();
            // End:0x431
            break;
        // End:0x42E
        case 1:
            bItemLookChangedbool = true;
            EnchantProgressAnim.HideWindow();
            EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
            EnchantProgressAnim.SetLoopCount(1);
            EnchantProgressAnim.Stop();
            EnchantProgressAnim.Play();
            PlaySound("ItemSound3.enchant_success");
            EnchantProgressAnim.ShowWindow();
            BackPattern.SetAlpha(0, 0.0000000);
            BackPattern.ShowWindow();
            BackPattern.SetAlpha(255, 2.0000000);
            // End:0x34E
            if(cResultWeaponItemID.LookChangeItemID > 0)
            {
                cResultWeaponItemID.CurrentPeriod = 0;
            }
            cResultWeaponItemID.LookChangeItemID = 0;
            cResultWeaponItemID.LookChangeItemName = "";
            cResultWeaponItemID.LookChangeIconID = 0;
            cResultWeaponItemID.LookChangeIconPanel = "";
            EnchantedItemSlot.Clear();
            EnchantedItemSlot.AddItem(cResultWeaponItemID);
            EndTxt = MakeFullSystemMsg(GetSystemMessage(6086), cResultWeaponItemID.Name);
            InstructionTxt.SetText(EndTxt);
            EnchantedItemSlot.SetAlpha(0);
            EnchantedItemSlot.ShowWindow();
            EnchantedItemSlot.SetAlpha(255, 2.0000000);
            WeaponItemSlot.HideWindow();
            RestoreItemSlot.HideWindow();
            // End:0x431
            break;
        // End:0xFFFF
        default:
            break;
    }
    OkBtn.ShowWindow();
    return;
}

function SetIsShopping(bool isShopping)
{
    bIsShopping = isShopping;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    OnClickButton("ExitBtn");
    return;
}
