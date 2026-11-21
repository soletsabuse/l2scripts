class ProductInventoryDrawerWnd extends UICommonAPI;

const DIALOGID_RECIEVE = 6460;

var WindowHandle Me;
var TextBoxHandle ProductInventoryDrawerWndTitle;
var TreeHandle ProductItemName;
var TreeHandle ProductItemInfo;
var TextureHandle ProductItem;
var TextBoxHandle ProductItemDetailListTitle;
var TextBoxHandle ProductItemDetailListCounter;
var TreeHandle ProductItemDetailList;
var TextureHandle ProductItemDetailListBg;
var TextBoxHandle PresentMessageTitle;
var TextBoxHandle SenderTitle;
var NameCtrlHandle Sender;
var TreeHandle ProductItemDetailList2;
var TextBoxHandle ProductBuyInfoTitle;
var TextBoxHandle ProductBuyInfo;
var ButtonHandle RecieveBtn;
var ButtonHandle CloseBtn;
var bool bDrawBgTree;
var int goodsCondition;
var ProductInventoryWnd ProductInventory;
var L2Util util;
var int SelectItemNum;

function OnRegisterEvent()
{
    RegisterEvent(5602);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function OnLoad()
{
    Initialize();
    load();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("ProductInventoryDrawerWnd");
    ProductInventoryDrawerWndTitle = GetTextBoxHandle("ProductInventoryDrawerWnd.ProductInventoryDrawerWndTitle");
    ProductItemName = GetTreeHandle("ProductInventoryDrawerWnd.ProductItemName");
    ProductItemInfo = GetTreeHandle("ProductInventoryDrawerWnd.ProductItemInfo");
    ProductItem = GetTextureHandle("ProductInventoryDrawerWnd.ProductItem");
    ProductItemDetailListTitle = GetTextBoxHandle("ProductInventoryDrawerWnd.ProductItemDetailListTitle");
    ProductItemDetailListCounter = GetTextBoxHandle("ProductInventoryDrawerWnd.ProductItemDetailListCounter");
    ProductItemDetailList = GetTreeHandle("ProductInventoryDrawerWnd.ProductItemDetailList");
    PresentMessageTitle = GetTextBoxHandle("ProductInventoryDrawerWnd.PresentMessageTitle");
    SenderTitle = GetTextBoxHandle("ProductInventoryDrawerWnd.SenderTitle");
    Sender = GetNameCtrlHandle("ProductInventoryDrawerWnd.Sender");
    ProductItemDetailList2 = GetTreeHandle("ProductInventoryDrawerWnd.ProductItemDetailList2");
    ProductBuyInfoTitle = GetTextBoxHandle("ProductInventoryDrawerWnd.ProductBuyInfoTitle");
    ProductBuyInfo = GetTextBoxHandle("ProductInventoryDrawerWnd.ProductBuyInfo");
    RecieveBtn = GetButtonHandle("ProductInventoryDrawerWnd.RecieveBtn");
    CloseBtn = GetButtonHandle("ProductInventoryDrawerWnd.CloseBtn");
    ProductItemDetailList.SetTooltipType("Inventory");
    return;
}

function load()
{
    util = L2Util(GetScript("L2Util"));
    ProductInventory = ProductInventoryWnd(GetScript("ProductInventoryWnd"));
    Class'NWindow.UIAPI_TREECTRL'.static.ShowScrollBar("ProductInventoryDrawerWnd.ProductItemName", false);
    return;
}

function OnClickButton(string Name)
{
    local array<string> Result;

    Split(Name, ".", Result);
    switch(Name)
    {
        // End:0x32
        case "RecieveBtn":
            OnRecieveBtnClick();
            // End:0x4B
            break;
        // End:0x48
        case "CloseBtn":
            OnCloseBtnClick();
            // End:0x4B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 5602:
            OnGoodsInventroyItemDesc(param);
            // End:0x42
            break;
        // End:0x2E
        case 1710:
            HandleDialogOK();
            // End:0x42
            break;
        // End:0x3F
        case 1720:
            HandleDialogCancel();
            // End:0x42
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleDialogOK()
{
    // End:0x4F
    if(!DialogIsMine())
    {
        // End:0x4D
        if(!RecieveBtn.IsEnableWindow())
        {
            ProductInventory.SetDisableTree(true);
            RecieveBtn.EnableWindow();
            CloseBtn.EnableWindow();
        }
        return;
    }
    switch(DialogGetID())
    {
        // End:0x9B
        case 6460:
            RequestUseGoodsInventoryItem(SelectItemNum);
            ProductInventory.SetDisableTree(true);
            RecieveBtn.EnableWindow();
            CloseBtn.EnableWindow();
            // End:0x9E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleDialogCancel()
{
    // End:0x4F
    if(!DialogIsMine())
    {
        // End:0x4D
        if(!RecieveBtn.IsEnableWindow())
        {
            ProductInventory.SetDisableTree(true);
            RecieveBtn.EnableWindow();
            CloseBtn.EnableWindow();
        }
        return;
    }
    switch(DialogGetID())
    {
        // End:0x90
        case 6460:
            ProductInventory.SetDisableTree(true);
            RecieveBtn.EnableWindow();
            CloseBtn.EnableWindow();
            // End:0x93
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnGoodsInventroyItemDesc(string param)
{
    local int i, Index, goodsType, goodsIconID;
    local string goodsName, goodsDesc;
    local int goodsGift;
    local string goodsSender, goodsSenderMessage, goodsDate;
    local int gameItemCount, gameItemClassID, gameItemQuantity;
    local ItemID cID;
    local Color clr;
    local string Str;

    ParseInt(param, "index", Index);
    // End:0x28
    if(Index == -1)
    {
        return;
    }
    SelectItemNum = Index;
    ProductInventory.SetExpandedOpen(string(SelectItemNum));
    ParseInt(param, "goodsType", goodsType);
    ParseInt(param, "goodsIconID", goodsIconID);
    ParseString(param, "goodsName", goodsName);
    ParseInt(param, "goodsCondition", goodsCondition);
    ParseString(param, "goodsDesc", goodsDesc);
    ParseInt(param, "goodsGift", goodsGift);
    ParseString(param, "goodsSender", goodsSender);
    ParseString(param, "goodsSenderMessage", goodsSenderMessage);
    ParseString(param, "goodsDate", goodsDate);
    ParseInt(param, "gameItemCount", gameItemCount);
    TreeClear("ProductInventoryDrawerWnd.ProductItemDetailList");
    ShowSkillTree();
    // End:0x1E1
    if(goodsType == 0)
    {
        ProductItem.SetTexture(Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(goodsIconID)));        
    }
    else
    {
        ProductItem.SetTexture(GetGoodsIconName(goodsIconID));
    }
    util.TreeClear("ProductInventoryDrawerWnd.ProductItemName");
    util.TreeInsertRootNode("ProductInventoryDrawerWnd.ProductItemName", "root", "");
    // End:0x2EC
    if((goodsCondition == 0) || goodsCondition == 2)
    {
        util.TreeInsertTextMultiNodeItem("ProductInventoryDrawerWnd.ProductItemName", "root", goodsName, 4, -2, 38, util.0);        
    }
    else
    {
        // End:0x350
        if(goodsCondition == 1)
        {
            util.TreeInsertTextMultiNodeItem("ProductInventoryDrawerWnd.ProductItemName", "root", goodsName, 4, -2, 38, util.4);
        }
    }
    util.TreeClear("ProductInventoryDrawerWnd.ProductItemInfo");
    util.TreeInsertRootNode("ProductInventoryDrawerWnd.ProductItemInfo", "root", "");
    util.TreeInsertTextNodeItem("ProductInventoryDrawerWnd.ProductItemInfo", "root", goodsDesc);
    clr.R = 175;
    clr.G = 152;
    clr.B = 120;
    clr.A = byte(255);
    // End:0x478
    if(goodsGift == 0)
    {
        Sender.SetNameWithColor(GetSystemString(2475), 0, 1, clr);        
    }
    else
    {
        Str = Locs(goodsSender, "_", "/", true);
        Sender.SetNameWithColor(Str, 0, 1, clr);
    }
    util.TreeClear("ProductInventoryDrawerWnd.ProductItemDetailList2");
    util.TreeInsertRootNode("ProductInventoryDrawerWnd.ProductItemDetailList2", "root", "");
    util.TreeInsertTextNodeItem("ProductInventoryDrawerWnd.ProductItemDetailList2", "root", goodsSenderMessage);
    ProductBuyInfo.SetText(goodsDate);
    i = 0;
    J0x59A:

    // End:0x649 [Loop If]
    if(i < gameItemCount)
    {
        ParseInt(param, "gameItemClassID_" $ string(i), gameItemClassID);
        ParseInt(param, "gameItemQuantity_" $ string(i), gameItemQuantity);
        cID = GetItemID(gameItemClassID);
        MakeTreeNode(cID, Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID), i, gameItemClassID, gameItemQuantity);
        i++;
        // [Loop Continue]
        goto J0x59A;
    }
    ProductItemDetailListCounter.SetText(("(" $ string(gameItemCount)) $ "/10)");
    Me.ShowWindow();
    return;
}

function MakeTreeNode(ItemID cID, string goodsName, int Index, int Id, int ItemNum)
{
    local string setTreeName, TREENAME, strRetName, strItemName;

    setTreeName = "root";
    TREENAME = "ProductInventoryDrawerWnd.ProductItemDetailList";
    strRetName = util.TreeInsertItemNode(TREENAME, "" $ string(Index), setTreeName);
    // End:0xBD
    if(bDrawBgTree == true)
    {
        util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 298, 38,,,,, 14);        
    }
    else
    {
        util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 298, 38);
    }
    bDrawBgTree = !bDrawBgTree;
    util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -291, 2);
    util.TreeInsertTextureNodeItem(TREENAME, strRetName, Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID), 32, 32, -34, 3);
    strItemName = ((("" $ goodsName) $ " (") $ string(ItemNum)) $ ")";
    util.TreeInsertTextMultiNodeItem(TREENAME, strRetName, strItemName, 4, 0, 38, util.0,, Id, ItemNum);
    return;
}

function OnRecieveBtnClick()
{
    // End:0x92
    if(SelectItemNum != -1)
    {
        // End:0x36
        if((goodsCondition == 0) || goodsCondition == 2)
        {
            RequestUseGoodsInventoryItem(SelectItemNum);            
        }
        else
        {
            // End:0x92
            if(goodsCondition == 1)
            {
                ProductInventory.SetDisableTree(false);
                RecieveBtn.DisableWindow();
                CloseBtn.DisableWindow();
                DialogSetID(6460);
                DialogShow(1, 4, GetSystemMessage(3387), string(self));
            }
        }
    }
    return;
}

function OnCloseBtnClick()
{
    RequestGoodsInventoryItemDesc(-1);
    SelectItemNum = -1;
    ProductInventory.SetSelectClear();
    Me.HideWindow();
    return;
}

function TreeClear(string TREENAME)
{
    Class'NWindow.UIAPI_TREECTRL'.static.Clear(TREENAME);
    return;
}

function ShowSkillTree()
{
    util.TreeInsertRootNode("ProductInventoryDrawerWnd.ProductItemDetailList", "root", "", 0, 4);
    return;
}
