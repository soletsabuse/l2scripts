class EnsoulExtractWnd extends UICommonAPI;

const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;
const TREENAME = "EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl";
const ITEMNAME_TOTAL_WIDTH = 240;
const ROOTNAME = "root";

var WindowHandle Me;
var WindowHandle DisableWnd;
var TextureHandle EnsoulGroupbox1_Texture;
var TextureHandle EnsoulGroupbox2_Texture;
var TextBoxHandle EnsoulExtractDiscription_TextBox;
var WindowHandle EnsoulExtractProgressWnd;
var ProgressCtrlHandle EnsoulProgressWnd_ProgressBar;
var TextBoxHandle EnsoulProgressWnd_Title_TextBox;
var WindowHandle EnsoulExtractDefaultWnd;
var ButtonHandle EnsoulExtractDefaultWnd_extract1_Button;
var ButtonHandle EnsoulExtractDefaultWnd_extract2_Button;
var ButtonHandle EnsoulExtractDefaultWnd_extract3_Button;
var ButtonHandle EnsoulExtract_Btn;
var TextureHandle EnsoulExtractDefaultWnd_Select1_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Select2_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Groupbox1_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Groupbox2_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Step1_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Step2_Texture;
var TextureHandle EnsoulExtractDefaultWnd_BM_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg1_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg2_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg3_Texture;
var TextureHandle EnsoulExtractDefaultWnd_SlotBg4_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Divider1;
var TextureHandle EnsoulExtractDefaultWnd_Divider2;
var TextureHandle EnsoulExtractDefaultWnd_Divider3;
var TextureHandle EnsoulExtractDefaultWnd_Step1block_Texture;
var TextureHandle EnsoulExtractDefaultWnd_Step2block_Texture;
var TextureHandle EnsoulExtractDefaultWnd_BMblock_Texture;
var ItemWindowHandle EnsoulExtractDefaultWnd_Item1_ItemWnd;
var ItemWindowHandle EnsoulExtractDefaultWnd_Item2_ItemWnd;
var ItemWindowHandle EnsoulExtractDefaultWnd_Item3_ItemWnd;
var ItemWindowHandle EnsoulExtractDefaultWnd_ItemBM_ItemWnd;
var TextBoxHandle EnsoulExtractDefaultWnd_TitleWeapon_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_WeaponName_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_TitleSoul_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_SoulName1_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_Soul1_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_SoulName2_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_Soul2_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_SoulName3_TextBox;
var TextBoxHandle EnsoulExtractDefaultWnd_Soul3_TextBox;
var WindowHandle EnsoulExtractResultWnd;
var ButtonHandle EnsoulExtractInfo_Button;
var ButtonHandle EnsoulOK_Btn;
var ButtonHandle EnsoulCancel_Btn;
var TextureHandle ExtractResultWnd_Groupbox1_Texture;
var TextureHandle ExtractResultWnd_Divider_Texture;
var TextureHandle ExtractResultWnd_ListGroupbox1_Texture;
var TextureHandle ExtractResultWnd_SlotBg1_Texture;
var ItemWindowHandle ExtractResultWnd_ITEM_ItemWnd;
var TextBoxHandle ExtractResultWnd_Title_TextBox;
var TextBoxHandle ExtractResultWnd_Name_TextBox;
var TextBoxHandle ExtractResultWnd_notice_TextBox;
var TextBoxHandle ExtractResultWnd_ChargeTitle_TextBox;
var TreeHandle NeededItem_TreeCtrl;
var WindowHandle EnsoulExtractWnd_ResultWnd;
var ItemWindowHandle EnsoulExtractSubWnd_WeaponItemWindow;
var ItemWindowHandle EnsoulExtractSubWnd_EnsoulItemWindow;
var AnimTextureHandle EnsoulProgress_AnimTex;
var L2Util util;
var EnsoulExtractSubWnd EnsoulExtractSubWndScript;
var InventoryWnd inventoryWndScript;
var int normalSlotCount;
var int bmSlotCount;
var int currentSlotIndex;
var int currentSlotType;
var EnsoulOptionUIInfo ensoulOptionInfoSlot1;
var EnsoulOptionUIInfo ensoulOptionInfoSlot2;
var EnsoulOptionUIInfo ensoulOptionInfoSlotBM;

function OnRegisterEvent()
{
    RegisterEvent(10062);
    RegisterEvent(10063);
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    GetWindowHandle("EnsoulExtractSubWnd").ShowWindow();
    initProcess();
    return;
}

function initProcess()
{
    DisableWnd.HideWindow();
    EnsoulExtractDefaultWnd_Select1_Texture.ShowWindow();
    EnsoulExtractDefaultWnd_Select2_Texture.HideWindow();
    getItemSlotWindow(0).Clear();
    EnsoulExtractDefaultWnd_WeaponName_TextBox.SetTooltipType("");
    EnsoulExtractDefaultWnd_WeaponName_TextBox.ClearTooltip();
    EnsoulExtractDefaultWnd_WeaponName_TextBox.SetText("");
    EnsoulExtractDefaultWnd_extract1_Button.HideWindow();
    EnsoulExtractDefaultWnd_extract2_Button.HideWindow();
    EnsoulExtractDefaultWnd_extract3_Button.HideWindow();
    clearEnsoulStoneSlot();
    EnsoulExtractProgressWnd.HideWindow();
    EnsoulExtractDefaultWnd.ShowWindow();
    EnsoulExtractResultWnd.HideWindow();
    EnsoulExtractWnd_ResultWnd.HideWindow();
    EnsoulExtractSubWndScript.setLock(false);
    EnsoulExtractSubWndScript.syncInventory();
    EnsoulExtractDiscription_TextBox.ShowWindow();
    EnsoulExtractDiscription_TextBox.SetText(GetSystemString(3496));
    return;
}

function OnHide()
{
    GetWindowHandle("EnsoulExtractSubWnd").HideWindow();
    initProcess();
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    load();
    return;
}

function Initialize()
{
    util = L2Util(GetScript("L2Util"));
    inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
    EnsoulExtractSubWndScript = EnsoulExtractSubWnd(GetScript("EnsoulExtractSubWnd"));
    Me = GetWindowHandle("EnsoulExtractWnd");
    EnsoulProgress_AnimTex = GetAnimTextureHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.EnsoulProgress_AnimTex");
    DisableWnd = GetWindowHandle("EnsoulExtractWnd.DisableWnd");
    EnsoulGroupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulGroupbox1_Texture");
    EnsoulGroupbox2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulGroupbox2_Texture");
    EnsoulExtractDiscription_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDiscription_TextBox");
    EnsoulExtractProgressWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractProgressWnd");
    EnsoulProgressWnd_ProgressBar = GetProgressCtrlHandle("EnsoulExtractWnd.EnsoulExtractProgressWnd.EnsoulProgressWnd_ProgressBar");
    EnsoulProgressWnd_Title_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractProgressWnd.EnsoulProgressWnd_Title_TextBox");
    EnsoulExtractDefaultWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd");
    EnsoulExtractDefaultWnd_extract1_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_extract1_Button");
    EnsoulExtractDefaultWnd_extract2_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_extract2_Button");
    EnsoulExtractDefaultWnd_extract3_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_extract3_Button");
    EnsoulExtractInfo_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractInfo_Button");
    EnsoulExtract_Btn = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtract_Btn");
    EnsoulExtractDefaultWnd_Select1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Select1_Texture");
    EnsoulExtractDefaultWnd_Select2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Select2_Texture");
    EnsoulExtractDefaultWnd_Groupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Groupbox1_Texture");
    EnsoulExtractDefaultWnd_Groupbox2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Groupbox2_Texture");
    EnsoulExtractDefaultWnd_Step1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step1_Texture");
    EnsoulExtractDefaultWnd_Step2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step2_Texture");
    EnsoulExtractDefaultWnd_BM_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_BM_Texture");
    EnsoulExtractDefaultWnd_SlotBg1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg1_Texture");
    EnsoulExtractDefaultWnd_SlotBg2_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg2_Texture");
    EnsoulExtractDefaultWnd_SlotBg3_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg3_Texture");
    EnsoulExtractDefaultWnd_SlotBg4_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SlotBg4_Texture");
    EnsoulExtractDefaultWnd_Divider1 = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Divider1");
    EnsoulExtractDefaultWnd_Divider2 = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Divider2");
    EnsoulExtractDefaultWnd_Divider3 = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Divider3");
    EnsoulExtractDefaultWnd_Step1block_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step1block_Texture");
    EnsoulExtractDefaultWnd_Step2block_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Step2block_Texture");
    EnsoulExtractDefaultWnd_BMblock_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_BMblock_Texture");
    EnsoulExtractDefaultWnd_Item1_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Item1_ItemWnd");
    EnsoulExtractDefaultWnd_Item2_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Item2_ItemWnd");
    EnsoulExtractDefaultWnd_Item3_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Item3_ItemWnd");
    EnsoulExtractDefaultWnd_ItemBM_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_ItemBM_ItemWnd");
    EnsoulExtractDefaultWnd_TitleWeapon_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_TitleWeapon_TextBox");
    EnsoulExtractDefaultWnd_WeaponName_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_WeaponName_TextBox");
    EnsoulExtractDefaultWnd_TitleSoul_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_TitleSoul_TextBox");
    EnsoulExtractDefaultWnd_SoulName1_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SoulName1_TextBox");
    EnsoulExtractDefaultWnd_Soul1_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Soul1_TextBox");
    EnsoulExtractDefaultWnd_SoulName2_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SoulName2_TextBox");
    EnsoulExtractDefaultWnd_Soul2_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Soul2_TextBox");
    EnsoulExtractDefaultWnd_SoulName3_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_SoulName3_TextBox");
    EnsoulExtractDefaultWnd_Soul3_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractDefaultWnd.EnsoulExtractDefaultWnd_Soul3_TextBox");
    EnsoulExtractResultWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractResultWnd");
    EnsoulExtractInfo_Button = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.EnsoulExtractInfo_Button");
    EnsoulOK_Btn = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.EnsoulOK_Btn");
    EnsoulCancel_Btn = GetButtonHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.EnsoulCancel_Btn");
    ExtractResultWnd_Groupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Groupbox1_Texture");
    ExtractResultWnd_Divider_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Divider_Texture");
    ExtractResultWnd_ListGroupbox1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_ListGroupbox1_Texture");
    ExtractResultWnd_SlotBg1_Texture = GetTextureHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_SlotBg1_Texture");
    ExtractResultWnd_ITEM_ItemWnd = GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_ITEM_ItemWnd");
    ExtractResultWnd_Title_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Title_TextBox");
    ExtractResultWnd_Name_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_Name_TextBox");
    ExtractResultWnd_notice_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_notice_TextBox");
    ExtractResultWnd_ChargeTitle_TextBox = GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.ExtractResultWnd_ChargeTitle_TextBox");
    NeededItem_TreeCtrl = GetTreeHandle("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl");
    EnsoulExtractWnd_ResultWnd = GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd");
    EnsoulExtractSubWnd_WeaponItemWindow = GetItemWindowHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Item1");
    EnsoulExtractSubWnd_EnsoulItemWindow = GetItemWindowHandle("EnsoulExtractSubWnd.EnsoulSubWnd_Item2");
    GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.OK_Button").HideWindow();
    GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Cancel_Button").HideWindow();
    GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.singleOK_Button").ShowWindow();
    return;
}

function load()
{
    return;
}

function OnEvent(int Event_ID, string param)
{
    Debug((("Inven Event ID :" $ string(Event_ID)) $ " ") $ param);
    Debug("Inven Event ID :" $ string(Event_ID));
    switch(Event_ID)
    {
        // End:0x6F
        case 10062:
            Me.ShowWindow();
            // End:0xB0
            break;
        // End:0xAD
        case 10063:
            Debug("EV_EnsoulExtractionResult" @ param);
            showResult(param);
            // End:0xB0
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x3D
        case "EnsoulExtractDefaultWnd_extract1_Button":
            showConfirm(1);
            // End:0x181
            break;
        // End:0x74
        case "EnsoulExtractDefaultWnd_extract2_Button":
            showConfirm(2);
            // End:0x181
            break;
        // End:0xAB
        case "EnsoulExtractDefaultWnd_extract3_Button":
            showConfirm(3);
            // End:0x181
            break;
        // End:0xD1
        case "EnsoulExtractInfo_Button":
            helpButtonClick();
            // End:0x181
            break;
        // End:0x112
        case "EnsoulExtract_Btn":
            Me.HideWindow();
            Debug("EnsoulExtract_Btn");
            // End:0x181
            break;
        // End:0x12C
        case "EnsoulOK_Btn":
            OnEnsoulOK_BtnClick();
            // End:0x181
            break;
        // End:0x14A
        case "EnsoulCancel_Btn":
            OnEnsoulCancel_BtnClick();
            // End:0x181
            break;
        // End:0x17E
        case "singleOK_Button":
            Debug("singleOK_Button");
            initProcess();
            // End:0x181
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function showConfirm(int SlotIndex)
{
    local ItemInfo ensoulItemInfo, weaponInfo;
    local string ensoulFeeInfoParam;
    local int slotType;

    Debug("slotIndex" @ string(SlotIndex));
    DisableWnd.HideWindow();
    EnsoulExtractDefaultWnd.HideWindow();
    EnsoulExtractWnd_ResultWnd.HideWindow();
    EnsoulExtractSubWndScript.setLock(true);
    EnsoulExtractResultWnd.ShowWindow();
    EnsoulExtractDiscription_TextBox.SetText(GetSystemString(3497));
    ensoulItemInfo = getltemInfoBySlotIndex(SlotIndex);
    Debug("ensoulItemInfo.Id.ClassID : " @ string(ensoulItemInfo.Id.ClassID));
    // End:0x124
    if(ensoulItemInfo.IconName != "")
    {
        ExtractResultWnd_ITEM_ItemWnd.Clear();
        ExtractResultWnd_ITEM_ItemWnd.AddItem(ensoulItemInfo);
        setEnsoulSlotText(SlotIndex, getEnsoulOptionInfoBySlotIndex(SlotIndex),, "", util.ColorLightBrown, true);
    }
    weaponInfo = getltemInfoBySlotIndex(0);
    // End:0x154
    if((SlotIndex == 1) || SlotIndex == 2)
    {
        slotType = 1;        
    }
    else
    {
        slotType = 2;
    }
    currentSlotIndex = SlotIndex;
    currentSlotType = slotType;
    Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulExtractionFeeInfo(weaponInfo.CrystalType, slotType, ensoulFeeInfoParam);
    setTreeNeedItemInfo(ensoulFeeInfoParam);
    return;
}

function setTreeNeedItemInfo(string ensoulFeeInfoParam)
{
    local ItemInfo feeItemInfo;
    local int nFeeItemNum, nFeeItemID, i;
    local INT64 nFeeItemCount;
    local ItemInfo InvenFeeItemInfo;

    ParseInt(ensoulFeeInfoParam, "FeeItemCount", nFeeItemNum);
    util.TreeClear("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl");
    util.TreeInsertRootNode("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", "root", "", 0, 4);
    EnsoulOK_Btn.EnableWindow();
    EnsoulExtractDiscription_TextBox.SetText(GetSystemString(3496));
    i = 1;
    J0xF1:

    // End:0x195 [Loop If]
    if(i < (nFeeItemNum + 1))
    {
        ParseInt(ensoulFeeInfoParam, "ItemID_" $ string(i), nFeeItemID);
        ParseINT64(ensoulFeeInfoParam, "ItemCount_" $ string(i), nFeeItemCount);
        Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(nFeeItemID), feeItemInfo);
        addTreeNode("LIST" $ string(i + 1), feeItemInfo, nFeeItemCount);
        i++;
        // [Loop Continue]
        goto J0xF1;
    }
    inventoryWndScript.getInventoryItemInfo(GetItemID(nFeeItemID), InvenFeeItemInfo);
    return;
}

function bool addTreeNode(string nodeLine, ItemInfo Info, INT64 needItemCount)
{
    local ItemInfo InvenItemInfo;
    local string strRetName, gradeTextureName;
    local int textHeight;
    local string enchantedStr, ItemName, AdditionalName, stackableAddStr, shortItemName, ensoulOptionAllName;

    local int enchantedStr_width, additionalName_width, stackableAddStr_width, ensoulOptionAllName_width, gradeTextureName_width;

    local INT64 hasNum;
    local bool bHasItem;
    local array<ItemInfo> itemInfoArray;
    local int ItemCount;

    gradeTextureName = GetItemGradeTextureName(Info.CrystalType);
    // End:0x85
    if(Len(gradeTextureName) > 0)
    {
        gradeTextureName_width = 16;
        // End:0x85
        if((((Info.CrystalType == int(6)) || Info.CrystalType == int(7)) || Info.CrystalType == int(9)) || Info.CrystalType == int(10))
        {
            gradeTextureName_width = 32;
        }
    }
    stackableAddStr = "x1";
    GetTextSizeDefault(stackableAddStr, stackableAddStr_width, textHeight);
    // End:0xCB
    if(Info.Enchanted > 0)
    {
        enchantedStr = "+" $ string(Info.Enchanted);
    }
    GetTextSizeDefault(enchantedStr, enchantedStr_width, textHeight);
    ensoulOptionAllName = GetEnsoulOptionNameAll(Info);
    GetTextSizeDefault(ensoulOptionAllName, ensoulOptionAllName_width, textHeight);
    AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(Info.Id);
    GetTextSizeDefault(AdditionalName, additionalName_width, textHeight);
    ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(Info.Id);
    // End:0x175
    if(ItemName == "")
    {
        ItemName = Info.Name;
    }
    shortItemName = makeShortStringByPixel(ItemName, 240 - (((stackableAddStr_width + additionalName_width) + gradeTextureName_width) + 7), "..");
    strRetName = ("root" $ ".") $ nodeLine;
    util.TreeInsertItemTooltipSimpleNode("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", nodeLine, "root", -7, 0, 38, 0, 32, 38, GetItemNameAll(Info));
    util.TreeInsertTextureNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, "L2UI_CT1.EmptyBtn", 257, 38);
    util.TreeInsertTextureNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
    util.TreeInsertTextureNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, Info.IconName, 32, 32, -34, 4 - 1);
    util.TreeInsertTextureNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, Info.IconPanel, 32, 32, -32, 4 - 1);
    // End:0x467
    if(enchantedStr != "")
    {
        util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, enchantedStr, 7, 5, util.0, true);
    }
    util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, shortItemName, 5, 5, util.0, true);
    // End:0x53F
    if(ensoulOptionAllName != "")
    {
        util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, ensoulOptionAllName, 5, 5, util.4, true);
    }
    // End:0x5B1
    if(AdditionalName != "")
    {
        util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, AdditionalName, 5, 5, util.4, true);
    }
    // End:0x61D
    if(gradeTextureName_width > 0)
    {
        util.TreeInsertTextureNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, gradeTextureName, gradeTextureName_width, 16, 2, 5);
    }
    util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, "x " $ MakeCostString((needItemCount)), 45, -14, util.2, false, true);
    ItemCount = Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(Info.Id.ClassID, itemInfoArray);
    // End:0x71F
    if(ItemCount > 0)
    {
        InvenItemInfo = itemInfoArray[0];
        // End:0x6F7
        if(!IsStackableItem(InvenItemInfo.ConsumeType))
        {
            hasNum = (1);            
        }
        else
        {
            hasNum = InvenItemInfo.ItemNum;
        }
        // End:0x71F
        if(__NFUN_411__(hasNum, needItemCount))
        {
            bHasItem = true;
        }
    }
    // End:0x7B7
    if(bHasItem)
    {
        // End:0x7B4
        if(__NFUN_413__(hasNum, (-1)))
        {
            util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, ("(" $ MakeCostString((hasNum))) $ ")", 4, -14, util.7);
        }        
    }
    else
    {
        util.TreeInsertTextNodeItem("EnsoulExtractWnd.EnsoulExtractResultWnd.NeededItem_TreeCtrl", strRetName, ("(" $ MakeCostString((hasNum))) $ ")", 4, -14, util.3);
        EnsoulOK_Btn.DisableWindow();
        EnsoulExtractDiscription_TextBox.SetText(MakeFullSystemMsg(GetSystemMessage(1473), GetSystemString(3494)));
    }
    return bHasItem;
    return;
}

function helpButtonClick()
{
    local string strParam;

    ParamAdd(strParam, "FilePath", "..\\L2text_Classic\\blacksmith_ensoul_extract_help_classic.htm");
    Debug("OnHelpBtnClick:" @ strParam);
    ExecuteEvent(1210, strParam);
    return;
}

function OnEnsoulExtract_BtnClick()
{
    return;
}

function OnEnsoulOK_BtnClick()
{
    EnsoulExtractProgressWnd.ShowWindow();
    EnsoulProgressWnd_ProgressBar.Reset();
    EnsoulProgressWnd_ProgressBar.SetProgressTime(1500);
    EnsoulProgressWnd_ProgressBar.Start();
    PlaySound("ItemSound3.enchant_process");
    EnsoulExtractDiscription_TextBox.HideWindow();
    Debug("해제 시도 EnsoulOK_Btn");
    return;
}

function OnProgressTimeUp(string strID)
{
    Debug("strID" @ strID);
    // End:0xA0
    if(strID == "EnsoulProgressWnd_ProgressBar")
    {
        // End:0xA0
        if(Me.IsShowWindow())
        {
            DisableWnd.ShowWindow();
            Debug("EnsoulProgressWnd_ProgressBar 창 열기");
            EnsoulExtractProgressWnd.HideWindow();
            requestItemEnsoulProcess();
        }
    }
    return;
}

function requestItemEnsoulProcess()
{
    local string param;

    param = makeRequestEnsoulExtractionParam();
    Class'NWindow.EnsoulAPI'.static.RequestItemExtraction(param);
    Debug(" 실행 --- class'EnsoulAPI'.static.RequestItemExtraction() --> param: " @ param);
    return;
}

function string makeRequestEnsoulExtractionParam()
{
    local string param;
    local int targetWeaponServerID, SlotIndex;

    targetWeaponServerID = getltemInfoBySlotIndex(0).Id.ServerID;
    // End:0x2D
    if(2 == currentSlotType)
    {
        SlotIndex = 1;        
    }
    else
    {
        SlotIndex = currentSlotIndex;
    }
    ParamAdd(param, "TargetItemID", string(targetWeaponServerID));
    ParamAdd(param, "SlotType", string(currentSlotType));
    ParamAdd(param, "SlotIndex", string(SlotIndex));
    return param;
    return;
}

function OnEnsoulCancel_BtnClick()
{
    initProcess();
    StopSound("ItemSound3.enchant_process");
    return;
}

function showResult(string param)
{
    local int resultValue, i, N, EnsoulOptionNum, nEOptionID;

    local ItemInfo weaponInfo;

    getItemSlotWindow(0).GetItem(0, weaponInfo);
    i = 1;
    J0x1E:

    // End:0xE1 [Loop If]
    if(i < 3)
    {
        ParseInt(param, "EnsoulOptionNum_" $ string(i), EnsoulOptionNum);
        N = 1;
        J0x5C:

        // End:0xD7 [Loop If]
        if(N < (1 + EnsoulOptionNum))
        {
            ParseInt(param, (("EnsoulOptionID_" $ string(i)) $ "_") $ string(N), nEOptionID);
            weaponInfo.EnsoulOption[i - 1].OptionArray[N - 1] = nEOptionID;
            N++;
            // [Loop Continue]
            goto J0x5C;
        }
        i++;
        // [Loop Continue]
        goto J0x1E;
    }
    DisableWnd.SetFocus();
    DisableWnd.ShowWindow();
    DisableWnd.SetFocus();
    EnsoulExtractWnd_ResultWnd.ShowWindow();
    ParseInt(param, "ExtractionResult", resultValue);
    // End:0x159
    if(resultValue > 0)
    {
        confirmResultEnsoulOption(true, weaponInfo);        
    }
    else
    {
        confirmResultEnsoulOption(false, weaponInfo);
    }
    return;
}

function confirmResultEnsoulOption(bool bSuccess, ItemInfo Info)
{
    local ItemInfo tempInfo;

    // End:0x30C
    if(bSuccess)
    {
        Debug("애니 돌리기");
        EnsoulExtractWnd_ResultWnd.SetWindowSize(233, 200);
        GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.OK_Button").HideWindow();
        GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Cancel_Button").HideWindow();
        GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.singleOK_Button").ShowWindow();
        EnsoulProgress_AnimTex.SetLoopCount(1);
        EnsoulProgress_AnimTex.Stop();
        EnsoulProgress_AnimTex.Play();
        PlaySound("ItemSound3.enchant_success");
        EnsoulProgress_AnimTex.ShowWindow();
        GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").Clear();
        GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").ClearTooltip();
        GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").AddItem(Info);
        GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").SetTooltipType("Inventory");
        GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Discription_TextBox").SetText(GetSystemString(3498));        
    }
    else
    {
        PlaySound("ItemSound3.enchant_fail");
        EnsoulExtractWnd_ResultWnd.SetWindowSize(233, 250);
        tempInfo.IconName = "L2UI_ct1.Icon.ICON_DF_Exclamation";
        GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.OK_Button").HideWindow();
        GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Cancel_Button").HideWindow();
        GetWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.singleOK_Button").ShowWindow();
        EnsoulProgress_AnimTex.Stop();
        EnsoulProgress_AnimTex.HideWindow();
        GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").ShowWindow();
        GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").Clear();
        GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").AddItem(tempInfo);
        GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").SetTooltipType("");
        GetItemWindowHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Result_ItemWnd").ClearTooltip();
        GetTextBoxHandle("EnsoulExtractWnd.EnsoulExtractWnd_ResultWnd.Discription_TextBox").SetText(GetSystemMessage(3646));
    }
    return;
}

function OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle)
{
    switch(a_AnimTextureHandle.GetWindowName())
    {
        // End:0x3E
        case "EnsoulProgress_AnimTex":
            a_AnimTextureHandle.HideWindow();
            // End:0x41
            break;
        // End:0xFFFF
        default:
            break;
    }
    Debug("---------------------OnTextureAnimEnd : " @ a_AnimTextureHandle.GetWindowName());
    return;
}

function InsertWeapon(ItemInfo Info)
{
    local string FullName;

    PlaySound("ItemSound3.enchant_input");
    // End:0x35
    if(Info.ItemType != int(0))
    {
        return;
    }
    EnsoulExtractDefaultWnd_Step1block_Texture.ShowWindow();
    EnsoulExtractDefaultWnd_Step2block_Texture.ShowWindow();
    EnsoulExtractDefaultWnd_BMblock_Texture.ShowWindow();
    EnsoulExtractDefaultWnd_extract1_Button.HideWindow();
    EnsoulExtractDefaultWnd_extract2_Button.HideWindow();
    EnsoulExtractDefaultWnd_extract3_Button.HideWindow();
    // End:0xE0
    if(EnsoulExtractDefaultWnd_Item1_ItemWnd.GetItemNum() > 0)
    {
        util.ItemWIndow_ItemMoveByIndex(getItemSlotWindow(0), EnsoulExtractSubWnd_WeaponItemWindow, 0);
        EnsoulExtractDefaultWnd_WeaponName_TextBox.SetTooltipType("");
        EnsoulExtractDefaultWnd_WeaponName_TextBox.ClearTooltip();
    }
    util.ItemWIndow_ItemMoveByItemID(EnsoulExtractSubWnd_WeaponItemWindow, getItemSlotWindow(0), Info.Id);
    // End:0x1E1
    if(Info.Id.ClassID > 0)
    {
        EnsoulExtractDefaultWnd_Select1_Texture.HideWindow();
        EnsoulExtractDefaultWnd_Select1_Texture.ShowWindow();
        normalSlotCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(Info.Id, 1);
        bmSlotCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(Info.Id, 2);
        EnsoulExtractDefaultWnd_SlotBg1_Texture.HideWindow();
        EnsoulExtractDefaultWnd_SlotBg2_Texture.HideWindow();
        EnsoulExtractDefaultWnd_SlotBg3_Texture.HideWindow();
        FullName = GetItemNameAll(Info);
        util.textBox_setToolTipWithShortString(EnsoulExtractDefaultWnd_WeaponName_TextBox, FullName);
        clearEnsoulStoneSlot();
        applyWeaponEnsoulInfo(Info);
    }
    setWeaponEnsoulOptionSlot(Info);
    return;
}

function applyWeaponEnsoulInfo(ItemInfo Info)
{
    local int N, i, Cnt, optionId, rIndex;

    local EnsoulOptionUIInfo optionInfo;
    local ItemInfo esInfo;

    Debug("초기화 applyWeaponEnsoulInfo");
    i = 1;
    J0x2B:

    // End:0x3D6 [Loop If]
    if(i < 3)
    {
        Cnt = Info.EnsoulOption[i - 1].OptionArray.Length;
        N = 1;
        J0x5D:

        // End:0x3CC [Loop If]
        if(N < (1 + Cnt))
        {
            optionId = Info.EnsoulOption[i - 1].OptionArray[N - 1];
            // End:0xB4
            if(optionId > 0)
            {
                GetEnsoulOptionUIInfo(optionId, optionInfo);                
            }
            else
            {
                // [Explicit Continue]
                goto J0x3C2;
            }
            // End:0x3C2
            if(optionId > 0)
            {
                // End:0xD9
                if(i == 2)
                {
                    rIndex = 3;                    
                }
                else
                {
                    rIndex = N;
                }
                esInfo.IconName = optionInfo.Icontex;
                // End:0x2E7
                if(i == 1)
                {
                    // End:0x215
                    if(N == 1)
                    {
                        Debug("optionInfo.ExtractionItemID :::: " @ string(optionInfo.ExtractionItemID));
                        // End:0x212
                        if(getItemSlotWindow(1).GetItemNum() == 0)
                        {
                            ensoulOptionInfoSlot1 = optionInfo;
                            getItemSlotWindow(1).AddItem(esInfo);
                            setEnsoulSlotText(1, optionInfo,, "", util.ColorLightBrown);
                            EnsoulExtractDefaultWnd_SlotBg1_Texture.ShowWindow();
                            EnsoulExtractDefaultWnd_extract1_Button.ShowWindow();
                            // End:0x1EF
                            if(optionInfo.ExtractionItemID == 0)
                            {
                                EnsoulExtractDefaultWnd_extract1_Button.SetButtonName(460);
                                EnsoulExtractDefaultWnd_extract1_Button.DisableWindow();                                
                            }
                            else
                            {
                                EnsoulExtractDefaultWnd_extract1_Button.SetButtonName(3492);
                                EnsoulExtractDefaultWnd_extract1_Button.EnableWindow();
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x2E4
                        if(getItemSlotWindow(2).GetItemNum() == 0)
                        {
                            ensoulOptionInfoSlot2 = optionInfo;
                            getItemSlotWindow(2).AddItem(esInfo);
                            setEnsoulSlotText(2, optionInfo,, "", util.ColorLightBrown);
                            EnsoulExtractDefaultWnd_SlotBg2_Texture.ShowWindow();
                            EnsoulExtractDefaultWnd_extract2_Button.ShowWindow();
                            // End:0x2C1
                            if(optionInfo.ExtractionItemID == 0)
                            {
                                EnsoulExtractDefaultWnd_extract2_Button.DisableWindow();
                                EnsoulExtractDefaultWnd_extract2_Button.SetButtonName(460);                                
                            }
                            else
                            {
                                EnsoulExtractDefaultWnd_extract2_Button.SetButtonName(3492);
                                EnsoulExtractDefaultWnd_extract2_Button.EnableWindow();
                            }
                        }
                    }
                    // [Explicit Continue]
                    goto J0x3C2;
                }
                // End:0x3C2
                if(i == 2)
                {
                    ensoulOptionInfoSlotBM = optionInfo;
                    // End:0x3C2
                    if(getItemSlotWindow(3).GetItemNum() == 0)
                    {
                        getItemSlotWindow(3).AddItem(esInfo);
                        setEnsoulSlotText(3, optionInfo,, "", util.ColorLightBrown);
                        EnsoulExtractDefaultWnd_SlotBg3_Texture.ShowWindow();
                        EnsoulExtractDefaultWnd_extract3_Button.ShowWindow();
                        // End:0x39F
                        if(optionInfo.ExtractionItemID == 0)
                        {
                            EnsoulExtractDefaultWnd_extract3_Button.SetButtonName(460);
                            EnsoulExtractDefaultWnd_extract3_Button.DisableWindow();
                            // [Explicit Continue]
                            goto J0x3C2;
                        }
                        EnsoulExtractDefaultWnd_extract3_Button.SetButtonName(3492);
                        EnsoulExtractDefaultWnd_extract3_Button.EnableWindow();
                    }
                }
            }
            J0x3C2:

            N++;
            // [Loop Continue]
            goto J0x5D;
        }
        i++;
        // [Loop Continue]
        goto J0x2B;
    }
    return;
}

function setEnsoulSlotText(int SlotIndex, EnsoulOptionUIInfo eOptionInfo, optional bool bDelete, optional string applyAddString, optional Color applyColor, optional bool bConfirmWnd)
{
    local TextBoxHandle soulNameTextBox, soulDescTextBox;
    local CustomTooltip cTooltip;

    // End:0x7A
    if(bConfirmWnd == false)
    {
        // End:0x30
        if(SlotIndex == 1)
        {
            soulNameTextBox = EnsoulExtractDefaultWnd_SoulName1_TextBox;
            soulDescTextBox = EnsoulExtractDefaultWnd_Soul1_TextBox;            
        }
        else
        {
            // End:0x55
            if(SlotIndex == 2)
            {
                soulNameTextBox = EnsoulExtractDefaultWnd_SoulName2_TextBox;
                soulDescTextBox = EnsoulExtractDefaultWnd_Soul2_TextBox;                
            }
            else
            {
                // End:0x77
                if(SlotIndex == 3)
                {
                    soulNameTextBox = EnsoulExtractDefaultWnd_SoulName3_TextBox;
                    soulDescTextBox = EnsoulExtractDefaultWnd_Soul3_TextBox;
                }
            }
        }        
    }
    else
    {
        soulNameTextBox = ExtractResultWnd_Name_TextBox;
        soulDescTextBox = ExtractResultWnd_notice_TextBox;
    }
    // End:0xDE
    if(((int(applyColor.R) != 0) && int(applyColor.G) != 0) && int(applyColor.B) != 0)
    {
        soulNameTextBox.SetTextColor(applyColor);
    }
    // End:0x100
    if(bDelete)
    {
        textBoxClear(soulNameTextBox);
        textBoxClear(soulDescTextBox);        
    }
    else
    {
        // End:0x155
        if(eOptionInfo.OptionStep > 0)
        {
            util.textBox_setToolTipWithShortString(soulNameTextBox, MakeFullSystemMsg(GetSystemMessage(4347), applyAddString $ eOptionInfo.Name, string(eOptionInfo.OptionStep)));            
        }
        else
        {
            util.textBox_setToolTipWithShortString(soulNameTextBox, applyAddString $ eOptionInfo.Name);
        }
        util.textBox_setToolTipWithShortString(soulDescTextBox, eOptionInfo.Desc);
        addToolTipDrawList(cTooltip, addDrawItemTexture(eOptionInfo.IconPanelTex, false, false, 2));
        addToolTipDrawList(cTooltip, addDrawItemTexture(eOptionInfo.Icontex, false, false, -16));
        addToolTipDrawList(cTooltip, addDrawItemText(eOptionInfo.Name, util.White, "", false));
        addToolTipDrawList(cTooltip, addDrawItemText(" : ", util.White, "", false));
        addToolTipDrawList(cTooltip, addDrawItemText(eOptionInfo.Desc, util.ColorDesc, "", false));
        addToolTipDrawList(cTooltip, addDrawItemBlank(1));
        soulDescTextBox.SetTooltipType("text");
        soulDescTextBox.SetTooltipCustomType(cTooltip);
    }
    return;
}

function clearEnsoulStoneSlot()
{
    getItemSlotWindow(1).Clear();
    getItemSlotWindow(2).Clear();
    getItemSlotWindow(3).Clear();
    textBoxClear(EnsoulExtractDefaultWnd_Soul1_TextBox);
    textBoxClear(EnsoulExtractDefaultWnd_Soul2_TextBox);
    textBoxClear(EnsoulExtractDefaultWnd_Soul3_TextBox);
    textBoxClear(EnsoulExtractDefaultWnd_SoulName1_TextBox);
    textBoxClear(EnsoulExtractDefaultWnd_SoulName2_TextBox);
    textBoxClear(EnsoulExtractDefaultWnd_SoulName3_TextBox);
    return;
}

function EnsoulOptionUIInfo getEnsoulOptionInfoBySlotIndex(int SlotIndex)
{
    local EnsoulOptionUIInfo enInfo;

    // End:0x19
    if(SlotIndex == 1)
    {
        enInfo = ensoulOptionInfoSlot1;        
    }
    else
    {
        // End:0x33
        if(SlotIndex == 2)
        {
            enInfo = ensoulOptionInfoSlot2;            
        }
        else
        {
            // End:0x4D
            if(SlotIndex == 3)
            {
                enInfo = ensoulOptionInfoSlotBM;                
            }
            else
            {
                Debug("Error (getEnsoulOptionInfoBySlotIndex) : Index is " @ string(SlotIndex));
            }
        }
    }
    return enInfo;
    return;
}

function ItemWindowHandle getItemSlotWindow(int SlotIndex)
{
    local ItemWindowHandle targetItemWndow;

    // End:0x19
    if(SlotIndex == 0)
    {
        targetItemWndow = EnsoulExtractDefaultWnd_Item1_ItemWnd;        
    }
    else
    {
        // End:0x32
        if(SlotIndex == 1)
        {
            targetItemWndow = EnsoulExtractDefaultWnd_Item2_ItemWnd;            
        }
        else
        {
            // End:0x4C
            if(SlotIndex == 2)
            {
                targetItemWndow = EnsoulExtractDefaultWnd_Item3_ItemWnd;                
            }
            else
            {
                // End:0x66
                if(SlotIndex == 3)
                {
                    targetItemWndow = EnsoulExtractDefaultWnd_ItemBM_ItemWnd;                    
                }
                else
                {
                    Debug("Error (getItemSlotWindow) : Index is " @ string(SlotIndex));
                }
            }
        }
    }
    return targetItemWndow;
    return;
}

function ItemInfo getltemInfoBySlotIndex(int SlotIndex)
{
    local ItemInfo tm;

    getItemSlotWindow(SlotIndex).GetItem(0, tm);
    return tm;
    return;
}

function setWeaponEnsoulOptionSlot(ItemInfo tempInfo)
{
    local int N;

    N = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, 1);
    // End:0x3D
    if(N == 1)
    {
        EnsoulExtractDefaultWnd_Step1block_Texture.HideWindow();        
    }
    else
    {
        // End:0x67
        if(N == 2)
        {
            EnsoulExtractDefaultWnd_Step1block_Texture.HideWindow();
            EnsoulExtractDefaultWnd_Step2block_Texture.HideWindow();
        }
    }
    N = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, 2);
    // End:0xA2
    if(N > 0)
    {
        EnsoulExtractDefaultWnd_BMblock_Texture.HideWindow();
    }
    return;
}

function bool externalCheckUsingItem(ItemInfo Info)
{
    local ItemInfo innerItemInfo;
    local bool RValue;

    // End:0x52
    if(getItemSlotWindow(0).GetItemNum() > 0)
    {
        getItemSlotWindow(0).GetItem(0, innerItemInfo);
        // End:0x52
        if(innerItemInfo.Id == Info.Id)
        {
            RValue = true;
        }
    }
    return RValue;
    return;
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    local Rect rectWnd;

    rectWnd = Me.GetRect();
    // End:0x60
    if((a_ItemInfo.DragSrcName == "EnsoulSubWnd_Item1") || a_ItemInfo.DragSrcName == "EnsoulSubWnd_Item2")
    {        
    }
    else
    {
        return;
    }
    // End:0xDB
    if((((X > rectWnd.nX) && X < (rectWnd.nX + rectWnd.nWidth)) && Y > rectWnd.nY) && Y < (rectWnd.nY + rectWnd.nHeight))
    {
        InsertWeapon(a_ItemInfo);
    }
    return;
}

function textBoxClear(TextBoxHandle txtBox)
{
    txtBox.SetText("");
    txtBox.SetTooltipType("");
    txtBox.SetText("");
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
