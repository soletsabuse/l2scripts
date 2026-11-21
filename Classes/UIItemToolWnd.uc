class UIItemToolWnd extends UICommonAPI;

const DELAY1_ID = 102001;
const DELAY2_ID = 102002;

var WindowHandle Me;
var ListCtrlHandle ItemListCtrl;
var ComboBoxHandle ItemTypeComboBox;
var ComboBoxHandle ItemGradeComboBox;
var ComboBoxHandle ItemOptionComboBox;
var ComboBoxHandle ItemOption2ComboBox;
var ButtonHandle searchItemBtn;
var ButtonHandle getItemBtn;
var EditBoxHandle searchEditBox;
var EditBoxHandle itemCountEditBox;
var EditBoxHandle descViewEditBox;
var TextBoxHandle ItemDescTextBox;
var ButtonHandle InitBtn;
var L2Util util;
var int iconPanelTotalCount;
var ItemInfo targetItemInfo;
var ItemID cID;
var int searchItemID;
var int filterItemType;
var ItemInfo tmItemInfo;
var string fullNameString;
var string modifiedString;
var string modifiedParam;
var int ItemCrystalType;
var bool useTick;
var bool switchBool;
var array<int> SlotBitType;

function OnRegisterEvent()
{
    RegisterEvent(540);
    return;
}

function OnShow()
{
    Me.DisableTick();
    useTick = false;
    Me.SetWindowTitle("UIPowerTools [ ItemTool ]");
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    util = L2Util(GetScript("L2Util"));
    Initialize();
    return;
}

function Initialize()
{
    local int i;

    Me = GetWindowHandle("UIItemToolWnd");
    ItemListCtrl = GetListCtrlHandle("UIItemToolWnd.itemListCtrl");
    searchItemBtn = GetButtonHandle("UIItemToolWnd.searchItemBtn");
    getItemBtn = GetButtonHandle("UIItemToolWnd.getItemBtn");
    ItemTypeComboBox = GetComboBoxHandle("UIItemToolWnd.ItemTypeComboBox");
    ItemGradeComboBox = GetComboBoxHandle("UIItemToolWnd.ItemGradeComboBox");
    ItemOptionComboBox = GetComboBoxHandle("UIItemToolWnd.ItemOptionComboBox");
    ItemOption2ComboBox = GetComboBoxHandle("UIItemToolWnd.ItemOption2ComboBox");
    searchEditBox = GetEditBoxHandle("UIItemToolWnd.searchEditBox");
    itemCountEditBox = GetEditBoxHandle("UIItemToolWnd.itemCountEditBox");
    descViewEditBox = GetEditBoxHandle("UIItemToolWnd.descViewEditBox");
    InitBtn = GetButtonHandle("UIItemToolWnd.InitBtn");
    ItemDescTextBox = GetTextBoxHandle("UIItemToolWnd.ItemDescTextBox");
    ItemTypeComboBox.Clear();
    ItemTypeComboBox.AddString("ITEM_WEAPON");
    ItemTypeComboBox.AddString("ITEM_ARMOR");
    ItemTypeComboBox.AddString("ITEM_ACCESSARY");
    ItemTypeComboBox.AddString("ITEM_QUESTITEM");
    ItemTypeComboBox.AddString("ITEM_ASSET");
    ItemTypeComboBox.AddString("ITEM_ETCITEM");
    ItemTypeComboBox.AddString("Total");
    ItemTypeComboBox.SetSelectedNum(6);
    ItemGradeComboBox.Clear();
    i = 0;
    J0x30F:

    // End:0x348 [Loop If]
    if(i < 11)
    {
        ItemGradeComboBox.AddString(util.getItemGradeSystemString(i));
        i++;
        // [Loop Continue]
        goto J0x30F;
    }
    ItemGradeComboBox.AddString("Total");
    ItemGradeComboBox.SetSelectedNum(11);
    itemCountEditBox.SetString("1");
    ItemListCtrl.SetSelectedSelTooltip(false);
    ItemListCtrl.SetAppearTooltipAtMouseX(true);
    inputSlotBitType();
    setOptionComboBoxString(ItemGradeComboBox.GetSelectedNum());
    setOptionComboBox2String(ItemGradeComboBox.GetSelectedNum());
    Me.SetWindowTitle("UIPowerTools [ ItemTool ]");
    return;
}

function inputSlotBitType()
{
    SlotBitType.Length = 28;
    SlotBitType[0] = 1;
    SlotBitType[1] = 2;
    SlotBitType[2] = 4;
    SlotBitType[3] = 6;
    SlotBitType[4] = 8;
    SlotBitType[5] = 16;
    SlotBitType[6] = 32;
    SlotBitType[7] = 48;
    SlotBitType[8] = 64;
    SlotBitType[9] = 128;
    SlotBitType[10] = 256;
    SlotBitType[11] = 512;
    SlotBitType[12] = 1024;
    SlotBitType[13] = 2048;
    SlotBitType[14] = 4096;
    SlotBitType[15] = 8192;
    SlotBitType[16] = 16384;
    SlotBitType[17] = 32768;
    SlotBitType[18] = 65536;
    SlotBitType[19] = 131072;
    SlotBitType[20] = 262144;
    SlotBitType[21] = 524288;
    SlotBitType[22] = 1048576;
    SlotBitType[23] = 2097152;
    SlotBitType[24] = 4194304;
    SlotBitType[25] = 268435456;
    SlotBitType[26] = 536870912;
    SlotBitType[27] = 1073741824;
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x22
        case "searchItemBtn":
            OnsearchItemBtnClick();
            // End:0x58
            break;
        // End:0x3A
        case "getItemBtn":
            OnGetItemBtnClick();
            // End:0x58
            break;
        // End:0x55
        case "InitBtn":
            Initialize();
            OnInitBtnClick();
            // End:0x58
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function debugItem(INT64 cID)
{
    local ItemInfo tmItemInfo;
    local ItemID cItemID;

    cItemID.ClassID = name(cID);
    // End:0x69
    if(Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cItemID, tmItemInfo))
    {
        Debug((("debugItem" @ (tmItemInfo.SlotBitType)) @ string(tmItemInfo.ArmorType)) @ string(tmItemInfo.BodyPart));
    }
    return;
}

function OnGetItemBtnClick()
{
    local LVDataRecord Record;
    local int nitemCount;

    nitemCount = 1;
    // End:0x35
    if(int(itemCountEditBox.GetString()) > 1)
    {
        nitemCount = int(itemCountEditBox.GetString());
    }
    ItemListCtrl.GetSelectedRec(Record);
    debugItem(Record.nReserved1);
    ProcessChatMessage((("//summon" @ (Record.nReserved1)) $ " ") $ string(nitemCount), 0);
    return;
}

function OnsearchItemBtnClick()
{
    FindAllItem(searchEditBox.GetString());
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    local LVDataRecord Record;
    local ItemID cItemID;
    local ItemInfo ItemInfo;

    // End:0x8D
    if(ListCtrlID == "itemListCtrl")
    {
        ItemListCtrl.GetSelectedRec(Record);
        cItemID.ClassID = name(Record.nReserved1);
        // End:0x8D
        if(Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cItemID, ItemInfo))
        {
            descViewEditBox.SetString(ItemInfo.Description $ "n");
            descViewEditBox.SetEditable(false);
        }
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    // End:0x1E
    if(ListCtrlID == "itemListCtrl")
    {
        OnGetItemBtnClick();
    }
    return;
}

function OnInitBtnClick()
{
    FindAllItem("Init");
    return;
}

function FindAllItem(string a_Param)
{
    ItemListCtrl.DeleteAllItem();
    // End:0x21
    if(a_Param == "Init")
    {
        return;
    }
    searchItemID = int(a_Param);
    // End:0x74
    if(int(a_Param) > 0)
    {
        cID.ClassID = searchItemID;
        // End:0x74
        if(Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, tmItemInfo))
        {
            AddItem(tmItemInfo);
            return;
        }
    }
    searchItemID = 0;
    modifiedParam = Locs(a_Param, " ", "", false);
    cID = Class'NWindow.UIDATA_ITEM'.static.GetFirstID();
    searchItemID = 0;
    useTick = true;
    Me.EnableTick();
    return;
}

function bool compareSubType(ItemInfo Info)
{
    local bool isTotal, isTotal2, Condition, condition2;
    local int Reserved, reserved2;

    isTotal = ItemOptionComboBox.GetSelectedNum() == (ItemOptionComboBox.GetNumOfItems() - 1);
    isTotal2 = ItemOption2ComboBox.GetSelectedNum() == (ItemOption2ComboBox.GetNumOfItems() - 1);
    Reserved = ItemOptionComboBox.GetReserved(ItemOptionComboBox.GetSelectedNum());
    reserved2 = ItemOption2ComboBox.GetReserved(ItemOption2ComboBox.GetSelectedNum());
    switch(Info.ItemType)
    {
        // End:0x115
        case int(0):
            Condition = Reserved == Info.WeaponType;
            condition2 = ItemOption2ComboBox.GetString(ItemOption2ComboBox.GetSelectedNum()) == GetSlotTypeString(Info.ItemType, Info.SlotBitType, Info.WeaponType);
            // End:0x1E5
            break;
        // End:0x182
        case int(1):
            Condition = ItemOptionComboBox.GetString(ItemOptionComboBox.GetSelectedNum()) == GetSlotTypeString(Info.ItemType, Info.SlotBitType, Info.ArmorType);
            condition2 = reserved2 == Info.ArmorType;
            // End:0x1E5
            break;
        // End:0x1AF
        case int(2):
            Condition = __NFUN_412__((Reserved), Info.SlotBitType);
            condition2 = true;
            // End:0x1E5
            break;
        // End:0x1DD
        case int(5):
            Condition = Reserved == int(byte(Info.ItemSubType));
            condition2 = true;
            // End:0x1E5
            break;
        // End:0xFFFF
        default:
            return true;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1E5
    return (isTotal || Condition) && isTotal2 || condition2;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1E5
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1E5
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1E5
}

function setWeaponOptionComboBox(ComboBoxHandle comboBox)
{
    local int i;
    local string comboBoxString;

    i = 0;
    J0x07:

    // End:0x43 [Loop If]
    if(i < 100)
    {
        comboBoxString = GetWeaponTypeString(i);
        chkNAddString(comboBoxString, comboBox, i);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function setArmorOptionComboBox(ComboBoxHandle comboBox)
{
    setSlotTypeStringByItemType(int(1), comboBox);
    return;
}

function setAccessaryComboBox(ComboBoxHandle comboBox)
{
    setSlotTypeStringByItemType(int(2), comboBox);
    return;
}

function setSlotTypeStringByItemType(int ItemType, ComboBoxHandle comboBox)
{
    local int i, k;
    local string comboBoxString;

    i = 0;
    J0x07:

    // End:0x7C [Loop If]
    if(i < 100)
    {
        k = 0;
        J0x1A:

        // End:0x72 [Loop If]
        if(k < SlotBitType.Length)
        {
            comboBoxString = GetSlotTypeString(ItemType, (SlotBitType[k]), i);
            chkNAddString(comboBoxString, comboBox, SlotBitType[k]);
            k++;
            // [Loop Continue]
            goto J0x1A;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function setEtcitemComboBox(ComboBoxHandle comboBox)
{
    local int i;

    chkNAddString("NONE", comboBox, i++);
    chkNAddString("SCROLL", comboBox, i++);
    chkNAddString("ARROW", comboBox, i++);
    chkNAddString("POTION", comboBox, i++);
    chkNAddString("SPELLBOOK", comboBox, i++);
    chkNAddString("RECIPE", comboBox, i++);
    chkNAddString("MATERIAL", comboBox, i++);
    chkNAddString("PET_COLLAR", comboBox, i++);
    chkNAddString("CASTLE_GUARD", comboBox, i++);
    chkNAddString("DYE", comboBox, i++);
    chkNAddString("SEED", comboBox, i++);
    chkNAddString("SEED2", comboBox, i++);
    chkNAddString("HARVEST", comboBox, i++);
    chkNAddString("LOTTO", comboBox, i++);
    chkNAddString("RACE_TICKET", comboBox, i++);
    chkNAddString("TICKET_OF_LORD", comboBox, i++);
    chkNAddString("LURE", comboBox, i++);
    chkNAddString("CROP", comboBox, i++);
    chkNAddString("MATURECROP", comboBox, i++);
    chkNAddString("ENCHT_WP", comboBox, i++);
    chkNAddString("ENCHT_AM", comboBox, i++);
    chkNAddString("BLESS_ENCHT_WP", comboBox, i++);
    chkNAddString("BLESS_ENCHT_AM", comboBox, i++);
    chkNAddString("COUPON", comboBox, i++);
    chkNAddString("ELIXIR", comboBox, i++);
    chkNAddString("ENCHT_ATTR", comboBox, i++);
    chkNAddString("ENCHT_ATTR_CURSED", comboBox, i++);
    chkNAddString("BOLT", comboBox, i++);
    chkNAddString("ENCHT_ATTR_INC_PROP_ENCHT_WP", comboBox, i++);
    chkNAddString("ENCHT_ATTR_INC_PROP_ENCHT_AM", comboBox, i++);
    chkNAddString("ENCHT_ATTR_CRYSTAL_ENCHANT_AM", comboBox, i++);
    chkNAddString("ENCHT_ATTR_CRYSTAL_ENCHANT_WP", comboBox, i++);
    chkNAddString("ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_AM", comboBox, i++);
    chkNAddString("ENCHT_ATTR_ANCIENT_CRYSTAL_ENCHANT_WP", comboBox, i++);
    chkNAddString("ENCHT_ATTR_RUNE", comboBox, i++);
    chkNAddString("ENCHT_ATTRT_RUNE_SELECT", comboBox, i++);
    chkNAddString("TELEPORTBOOKMARK", comboBox, i++);
    chkNAddString("CHANGE_ATTR", comboBox, i++);
    chkNAddString("SOULSHOT", comboBox, i++);
    chkNAddString("SHAPE_SHIFTING_WP", comboBox, i++);
    chkNAddString("BLESS_SHAPE_SHIFTING_WP", comboBox, i++);
    chkNAddString("SHAPE_SHIFTING_WP_FIXED", comboBox, i++);
    chkNAddString("SHAPE_SHIFTING_AM", comboBox, i++);
    chkNAddString("BLESS_SHAPE_SHIFTING_AM", comboBox, i++);
    chkNAddString("SHAPE_SHIFTING_AM_FIXED", comboBox, i++);
    chkNAddString("SHAPE_SHIFTING_HAIRACC", comboBox, i++);
    chkNAddString("BLESS_SHAPE_SHIFTING_HAIRACC", comboBox, i++);
    chkNAddString("SHAPE_SHIFTING_HAIRACC_FIXED", comboBox, i++);
    chkNAddString("RESTORE_SHAPE_SHIFTING_WP", comboBox, i++);
    chkNAddString("RESTORE_SHAPE_SHIFTING_AM", comboBox, i++);
    chkNAddString("RESTORE_SHAPE_SHIFTING_HAIRACC", comboBox, i++);
    chkNAddString("RESTORE_SHAPE_SHIFTING_ALLITEM", comboBox, i++);
    chkNAddString("BLESS_INC_PROP_ENCHT_WP", comboBox, i++);
    chkNAddString("BLESS_INC_PROP_ENCHT_AM", comboBox, i++);
    chkNAddString("CARD_EVENT", comboBox, i++);
    chkNAddString("SHAPE_SHIFTING_ALLITEM_FIXED", comboBox, i++);
    chkNAddString("MULTI_ENCHT_WP", comboBox, i++);
    chkNAddString("MULTI_ENCHT_AM", comboBox, i++);
    chkNAddString("MULTI_INC_PROB_ENCHT_WP", comboBox, i++);
    chkNAddString("MULTI_INC_PROB_ENCHT_AM", comboBox, i++);
    chkNAddString("ENSOUL_STONE", comboBox, i++);
    return;
}

function setOptionComboBoxString(int selectedID)
{
    ItemOptionComboBox.Clear();
    switch(selectedID)
    {
        // End:0x2B
        case int(0):
            setWeaponOptionComboBox(ItemOptionComboBox);
            // End:0x84
            break;
        // End:0x40
        case int(1):
            setArmorOptionComboBox(ItemOptionComboBox);
            // End:0x84
            break;
        // End:0x55
        case int(2):
            setAccessaryComboBox(ItemOptionComboBox);
            // End:0x84
            break;
        // End:0x5F
        case int(3):
            // End:0x84
            break;
        // End:0x69
        case int(4):
            // End:0x84
            break;
        // End:0x7E
        case int(5):
            setEtcitemComboBox(ItemOptionComboBox);
            // End:0x84
            break;
        // End:0xFFFF
        default:
            // End:0x84
            break;
            break;
    }
    ItemOptionComboBox.AddString("Total");
    ItemOptionComboBox.SetSelectedNum(ItemOptionComboBox.GetNumOfItems() - 1);
    return;
}

function setWeaponOption2ComboBox(ComboBoxHandle comboBox)
{
    setSlotTypeStringByItemType(int(0), comboBox);
    return;
}

function setArmorOption2ComboBox(ComboBoxHandle comboBox)
{
    comboBox.AddStringWithReserved(GetSystemString(441), 0);
    comboBox.AddStringWithReserved(GetSystemString(245), 1);
    comboBox.AddStringWithReserved(GetSystemString(246), 2);
    comboBox.AddStringWithReserved(GetSystemString(244), 3);
    comboBox.AddStringWithReserved(GetSystemString(1987), 4);
    return;
}

function setOptionComboBox2String(int selectedID)
{
    ItemOption2ComboBox.Clear();
    switch(selectedID)
    {
        // End:0x2B
        case int(0):
            setWeaponOption2ComboBox(ItemOption2ComboBox);
            // End:0x65
            break;
        // End:0x40
        case int(1):
            setArmorOption2ComboBox(ItemOption2ComboBox);
            // End:0x65
            break;
        // End:0x47
        case int(2):
        // End:0x4E
        case int(3):
        // End:0x55
        case int(4):
        // End:0x5F
        case int(5):
            // End:0x65
            break;
        // End:0xFFFF
        default:
            // End:0x65
            break;
            break;
    }
    ItemOption2ComboBox.AddString("Total");
    ItemOption2ComboBox.SetSelectedNum(ItemOption2ComboBox.GetNumOfItems() - 1);
    return;
}

function chkNAddString(string tmpString, ComboBoxHandle tmpCombox, int reversed)
{
    local int i;

    // End:0x0E
    if(tmpString == "")
    {
        return;
    }
    i = 0;
    J0x15:

    // End:0x58 [Loop If]
    if(i < tmpCombox.GetNumOfItems())
    {
        // End:0x4E
        if(tmpCombox.GetString(i) == tmpString)
        {
            return;
        }
        i++;
        // [Loop Continue]
        goto J0x15;
    }
    tmpCombox.AddStringWithReserved(tmpString, reversed);
    return;
}

function tickProcess()
{
    local int ItemType, CrystalType;

    // End:0x53
    if(!IsValidItemID(cID))
    {
        Me.DisableTick();
        useTick = false;
        Me.SetWindowTitle("UIPowerTools [ ItemTool ]");
        return;
    }
    ItemType = ItemTypeComboBox.GetSelectedNum();
    // End:0x7F
    if(ItemType == 6)
    {
        ItemType = -1;
    }
    CrystalType = ItemGradeComboBox.GetSelectedNum();
    // End:0xAB
    if(CrystalType == 11)
    {
        CrystalType = -1;
    }
    cID = Class'NWindow.UIDATA_ITEM'.static.FindNextID(modifiedParam, ItemType, CrystalType);
    // End:0x118
    if(cID.ClassID >= 0)
    {
        Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, tmItemInfo);
        // End:0x111
        if(compareSubType(tmItemInfo))
        {
            AddItem(tmItemInfo);
        }
        searchItemID++;
    }
    return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
    switch(strID)
    {
        // End:0xC7
        case "ItemTypeComboBox":
            setOptionComboBoxString(IndexID);
            setOptionComboBox2String(IndexID);
            // End:0x59
            if(ItemOptionComboBox.GetNumOfItems() > 1)
            {
                ItemOptionComboBox.ShowWindow();                
            }
            else
            {
                ItemOptionComboBox.HideWindow();
            }
            // End:0xA2
            if(ItemOption2ComboBox.GetNumOfItems() > 1)
            {
                ItemOptionComboBox.SetWindowSize(107, 19);
                ItemOption2ComboBox.ShowWindow();                
            }
            else
            {
                ItemOptionComboBox.SetWindowSize(180, 19);
                ItemOption2ComboBox.HideWindow();
            }
            // End:0xCA
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnTick()
{
    local int i;

    // End:0x51
    if(switchBool == false)
    {
        Me.SetWindowTitle("UIPowerTools [ ItemTool ]  - Searching.. ");
        switchBool = true;        
    }
    else
    {
        Me.SetWindowTitle("UIPowerTools [ ItemTool ]  + Searching.... ");
        switchBool = false;
    }
    i = 0;
    J0x9C:

    // End:0xC9 [Loop If]
    if(i < 300)
    {
        // End:0xB9
        if(!useTick)
        {
            // [Explicit Break]
            goto J0xC9;
        }
        tickProcess();
        i++;
        // [Loop Continue]
        goto J0x9C;
    }
    J0xC9:

    return;
}

function AddItem(ItemInfo Info)
{
    local LVDataRecord Record;
    local string param, AdditionalName, fullNameString;
    local int itemNameClass;

    fullNameString = Info.Name;
    itemNameClass = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(Info.Id);
    AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(Info.Id);
    // End:0x78
    if(itemNameClass == 0)
    {
        fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);        
    }
    else
    {
        // End:0xA0
        if(itemNameClass == 2)
        {
            fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
        }
    }
    // End:0xC9
    if(Len(AdditionalName) > 0)
    {
        fullNameString = ((fullNameString $ "(") $ AdditionalName) $ ")";
    }
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfoString(Info.Id.ClassID, param);
    Record.szReserved = param;
    Record.nReserved1 = (Info.Id.ClassID);
    Record.LVDataList.Length = 5;
    Record.LVDataList[0].szData = fullNameString;
    Record.LVDataList[0].hasIcon = true;
    Record.LVDataList[0].nTextureWidth = 32;
    Record.LVDataList[0].nTextureHeight = 32;
    Record.LVDataList[0].nTextureU = 32;
    Record.LVDataList[0].nTextureV = 32;
    Record.LVDataList[0].szTexture = Info.IconName;
    Record.LVDataList[0].IconPosX = 10;
    Record.LVDataList[0].FirstLineOffsetX = 6;
    Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
    Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
    Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
    Record.LVDataList[0].backTexWidth = 36;
    Record.LVDataList[0].backTexHeight = 36;
    Record.LVDataList[0].backTexUL = 36;
    Record.LVDataList[0].backTexVL = 36;
    // End:0x2B5
    if(Info.IconPanel != "")
    {
        iconPanelTotalCount++;
    }
    Record.LVDataList[0].iconPanelName = Info.IconPanel;
    Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
    Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
    Record.LVDataList[0].panelWidth = 32;
    Record.LVDataList[0].panelHeight = 32;
    Record.LVDataList[0].panelUL = 32;
    Record.LVDataList[0].panelVL = 32;
    // End:0x3B2
    if(((Info.ItemType == int(0)) || Info.ItemType == int(2)) || Info.ItemType == int(1))
    {
        Record.LVDataList[1].szData = util.getItemGradeSystemString(Info.CrystalType);        
    }
    else
    {
        // End:0x3F0
        if(Info.CrystalType != 0)
        {
            Record.LVDataList[1].szData = util.getItemGradeSystemString(Info.CrystalType);            
        }
        else
        {
            Record.LVDataList[1].szData = "-";
        }
    }
    Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(6, (Info.CrystalType));
    Record.LVDataList[1].textAlignment = 1;
    switch(Info.ItemType)
    {
        // End:0x536
        case int(0):
            ItemListCtrl.SetColumnString(2, 55);
            ItemListCtrl.SetColumnString(3, 98);
            Record.LVDataList[2].szData = string(GetPhysicalDamage(Info.WeaponType, Info.SlotBitType, Info.CrystalType, Info.Enchanted, int(Info.pAttack), Info.Attribution));
            Record.LVDataList[3].szData = string(GetMagicalDamage(Info.WeaponType, Info.SlotBitType, Info.CrystalType, Info.Enchanted, int(Info.mAttack), Info.Attribution));
            // End:0x66B
            break;
        // End:0x5B4
        case int(1):
            ItemListCtrl.SetColumnString(2, 54);
            ItemListCtrl.SetColumnString(3, 99);
            Record.LVDataList[2].szData = string(int(Info.pDefense + Info.ShieldDefense));
            Record.LVDataList[3].szData = string(int(Info.mDefense));
            // End:0x66B
            break;
        // End:0x632
        case int(2):
            ItemListCtrl.SetColumnString(2, 54);
            ItemListCtrl.SetColumnString(3, 99);
            Record.LVDataList[2].szData = string(int(Info.pDefense + Info.ShieldDefense));
            Record.LVDataList[3].szData = string(int(Info.mDefense));
            // End:0x66B
            break;
        // End:0x668
        case int(5):
            Record.LVDataList[2].szData = string(0);
            Record.LVDataList[3].szData = string(0);
            // End:0x66B
            break;
        // End:0xFFFF
        default:
            break;
    }
    Record.LVDataList[2].textAlignment = 3;
    Record.LVDataList[3].textAlignment = 3;
    Record.LVDataList[4].szData = string(Info.Id.ClassID);
    Record.LVDataList[4].textAlignment = 1;
    ItemListCtrl.InsertRecord(Record);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("UIItemToolWnd").HideWindow();
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x44
    if(searchEditBox.IsFocused())
    {
        // End:0x44
        if(int(nKey) == int(13))
        {
            // End:0x44
            if((trim(searchEditBox.GetString())) != "")
            {
                OnsearchItemBtnClick();
            }
        }
    }
    return;
}
