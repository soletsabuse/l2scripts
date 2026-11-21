class RecipeShopWnd extends UICommonAPI;

const RECIPESHOP_MAX_ITEM_SELL = 20;

var int m_ShopItemMaxCount_Dwarf;
var int m_ShopItemMaxCount_Normal;
var int m_BookItemCount;
var int m_ShopItemCount;
var int m_BookType;
var ItemInfo m_HandleItem;
var bool isStartCraft;

function OnRegisterEvent()
{
    RegisterEvent(850);
    RegisterEvent(860);
    RegisterEvent(870);
    RegisterEvent(2070);
    RegisterEvent(1710);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    return;
}

function OnShow()
{
    PlayConsoleSound(19);
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1B
        case "btnEnd":
            closeWindow();
            // End:0xB4
            break;
        // End:0x65
        case "btnMsg":
            DialogSetEditBoxMaxLength(29);
            DialogShow(1, 2, GetSystemMessage(334), string(self));
            DialogSetID(0);
            DialogSetString(Class'NWindow.UIDATA_PLAYER'.static.GetRecipeShopMsg());
            // End:0xB4
            break;
        // End:0x81
        case "btnStart":
            StartRecipeShop();
            closeWindow();
            // End:0xB4
            break;
        // End:0x98
        case "btnMoveUp":
            HandleMoveUpItem();
            // End:0xB4
            break;
        // End:0xB1
        case "btnMoveDown":
            HandleMoveDownItem();
            // End:0xB4
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string strPrice;
    local int RecipeID, CanbeMade;
    local INT64 MakingFee, Price;

    // End:0xBE
    if(Event_ID == 850)
    {
        Clear();
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RecipeShopWnd");
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus("RecipeShopWnd");
        ParseInt(param, "Type", m_BookType);
        // End:0x98
        if(m_BookType == 1)
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle("RecipeShopWnd", 1212);            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle("RecipeShopWnd", 1213);
        }        
    }
    else
    {
        // End:0xF5
        if(Event_ID == 860)
        {
            ParseInt(param, "RecipeID", RecipeID);
            AddRecipeBookItem(RecipeID);            
        }
        else
        {
            // End:0x16C
            if(Event_ID == 870)
            {
                ParseInt(param, "RecipeID", RecipeID);
                ParseInt(param, "CanbeMade", CanbeMade);
                ParseINT64(param, "MakingFee", MakingFee);
                AddRecipeShopItem(RecipeID, CanbeMade, MakingFee);                
            }
            else
            {
                // End:0x189
                if(Event_ID == 2070)
                {
                    HandleSetMaxCount(param);                    
                }
                else
                {
                    // End:0x257
                    if(Event_ID == 1710)
                    {
                        // End:0x257
                        if(DialogIsMine())
                        {
                            // End:0x1C5
                            if((DialogGetID()) == 0)
                            {
                                Class'NWindow.RecipeAPI'.static.RequestRecipeShopMessageSet(DialogGetString());                                
                            }
                            else
                            {
                                // End:0x257
                                if((DialogGetID()) == 1)
                                {
                                    strPrice = DialogGetString();
                                    // End:0x251
                                    if(Len(strPrice) > 0)
                                    {
                                        Price = (strPrice);
                                        // End:0x236
                                        if(__NFUN_411__(Price, ("1000000000000")))
                                        {
                                            DialogSetID(2);
                                            DialogShow(1, 4, GetSystemMessage(1369), string(self));                                            
                                        }
                                        else
                                        {
                                            m_HandleItem.Price = Price;
                                            UpdateShopItem(m_HandleItem);
                                        }
                                    }
                                    ClearHandleItem();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function OnSendPacketWhenHiding()
{
    Clear();
    return;
}

function closeWindow()
{
    Clear();
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeShopWnd");
    return;
}

function OnDBClickItem(string strID, int Index)
{
    local int Max, i;
    local ItemInfo infItem, DeleteItem;

    ClearHandleItem();
    // End:0x155
    if((strID == "BookItemWnd") && m_BookItemCount > Index)
    {
        Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.BookItemWnd", Index, infItem);
        Max = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
        i = 0;
        J0x99:

        // End:0x113 [Loop If]
        if(i < Max)
        {
            // End:0x109
            if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd", i, DeleteItem))
            {
                // End:0x109
                if(IsSameClassID(DeleteItem.Id, infItem.Id))
                {
                    DeleteShopItem(infItem);
                    return;
                }
            }
            i++;
            // [Loop Continue]
            goto J0x99;
        }
        Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.BookItemWnd", Index, infItem);
        ShowShopItemAddDialog(infItem);        
    }
    else
    {
        // End:0x1BC
        if((strID == "ShopItemWnd") && m_ShopItemCount > Index)
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd", Index, infItem);
            DeleteShopItem(infItem);
        }
    }
    return;
}

function OnDropItem(string strID, ItemInfo infItem, int X, int Y)
{
    // End:0x41
    if(strID == "BookItemWnd")
    {
        // End:0x3E
        if(infItem.DragSrcName == "ShopItemWnd")
        {
            DeleteShopItem(infItem);
        }        
    }
    else
    {
        // End:0x7F
        if(strID == "ShopItemWnd")
        {
            // End:0x7F
            if(infItem.DragSrcName == "BookItemWnd")
            {
                ShowShopItemAddDialog(infItem);
            }
        }
    }
    return;
}

function Clear()
{
    ClearHandleItem();
    m_BookItemCount = 0;
    m_ShopItemCount = 0;
    UpdateShopItemCount(0);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("RecipeShopWnd.BookItemWnd");
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("RecipeShopWnd.ShopItemWnd");
    return;
}

function ClearHandleItem()
{
    local ItemInfo ItemClear;

    m_HandleItem = ItemClear;
    return;
}

function AddRecipeBookItem(int RecipeID)
{
    local ItemInfo infItem;
    local int ProductID;

    ProductID = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
    infItem.Id = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeItemID(RecipeID);
    infItem.Level = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
    infItem.Name = Class'NWindow.UIDATA_ITEM'.static.GetItemName(infItem.Id);
    infItem.Description = Class'NWindow.UIDATA_ITEM'.static.GetItemDescription(infItem.Id);
    infItem.Weight = Class'NWindow.UIDATA_ITEM'.static.GetItemWeight(infItem.Id);
    infItem.IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
    infItem.CrystalType = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeShopWnd.BookItemWnd", infItem);
    m_BookItemCount++;
    return;
}

function AddRecipeShopItem(int RecipeID, int CanbeMade, INT64 MakingFee)
{
    local ItemInfo infItem;
    local int ProductID;

    ProductID = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
    infItem.Id = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeItemID(RecipeID);
    infItem.Level = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
    infItem.Price = MakingFee;
    infItem.Reserved = CanbeMade;
    infItem.Name = Class'NWindow.UIDATA_ITEM'.static.GetItemName(infItem.Id);
    infItem.Description = Class'NWindow.UIDATA_ITEM'.static.GetItemDescription(infItem.Id);
    infItem.Weight = Class'NWindow.UIDATA_ITEM'.static.GetItemWeight(infItem.Id);
    infItem.IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
    infItem.CrystalType = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeShopWnd.ShopItemWnd", infItem);
    m_ShopItemCount++;
    UpdateShopItemCount(m_ShopItemCount);
    return;
}

function ShowShopItemAddDialog(ItemInfo AddItem)
{
    m_HandleItem = AddItem;
    DialogSetID(1);
    DialogSetParamInt64((-1));
    DialogSetDefaultOK();
    DialogShow(1, 6, GetSystemMessage(963), string(self));
    return;
}

function UpdateShopItem(ItemInfo AddItem)
{
    local int i, Max;
    local ItemInfo infItem;
    local bool bDuplicated;

    bDuplicated = false;
    Max = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
    i = 0;
    J0x3F:

    // End:0xB7 [Loop If]
    if(i < Max)
    {
        // End:0xAD
        if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd", i, infItem))
        {
            // End:0xAD
            if(IsSameClassID(AddItem.Id, infItem.Id))
            {
                bDuplicated = true;
                // [Explicit Break]
                goto J0xB7;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x3F;
    }
    J0xB7:

    // End:0x103
    if(!bDuplicated)
    {
        Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeShopWnd.ShopItemWnd", AddItem);
        m_ShopItemCount++;
        UpdateShopItemCount(m_ShopItemCount);
    }
    return;
}

function DeleteShopItem(ItemInfo DeleteItem)
{
    local int i, Max;
    local ItemInfo infItem;

    Max = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
    i = 0;
    J0x37:

    // End:0xE8 [Loop If]
    if(i < Max)
    {
        // End:0xDE
        if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd", i, infItem))
        {
            // End:0xDE
            if(IsSameClassID(DeleteItem.Id, infItem.Id))
            {
                Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("RecipeShopWnd.ShopItemWnd", i);
                m_ShopItemCount--;
                UpdateShopItemCount(m_ShopItemCount);
                // [Explicit Break]
                goto J0xE8;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x37;
    }
    J0xE8:

    return;
}

function UpdateShopItemCount(int Count)
{
    // End:0x54
    if(m_BookType == 1)
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeShopWnd.txtCount", ((("(" $ string(Count)) $ "/") $ string(m_ShopItemMaxCount_Normal)) $ ")");        
    }
    else
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeShopWnd.txtCount", ((("(" $ string(Count)) $ "/") $ string(m_ShopItemMaxCount_Dwarf)) $ ")");
    }
    return;
}

function StartRecipeShop()
{
    local int i, Max;
    local ItemInfo infItem;
    local string param;
    local INT64 Price;

    Max = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItemNum("RecipeShopWnd.ShopItemWnd");
    ParamAdd(param, "Max", string(Max));
    i = 0;
    J0x4E:

    // End:0xF4 [Loop If]
    if(i < Max)
    {
        Price = (0);
        // End:0xAD
        if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("RecipeShopWnd.ShopItemWnd", i, infItem))
        {
            Price = infItem.Price;
        }
        ParamAddItemIDWithIndex(param, infItem.Id, i);
        ParamAdd(param, "Price_" $ string(i), (Price));
        i++;
        // [Loop Continue]
        goto J0x4E;
    }
    isStartCraft = true;
    Class'NWindow.RecipeAPI'.static.RequestRecipeShopListSet(param);
    return;
}

function HandleMoveUpItem()
{
    local ItemInfo infItem;

    // End:0x3D
    if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedItem("RecipeShopWnd.ShopItemWnd", infItem))
    {
        DeleteShopItem(infItem);
    }
    return;
}

function HandleMoveDownItem()
{
    local ItemInfo infItem;

    // End:0x3D
    if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedItem("RecipeShopWnd.BookItemWnd", infItem))
    {
        ShowShopItemAddDialog(infItem);
    }
    return;
}

function OnReceivedCloseUI()
{
    closeWindow();
    return;
}

function OnHide()
{
    PlayConsoleSound(20);
    // End:0x22
    if(!isStartCraft)
    {
        Class'NWindow.RecipeAPI'.static.RequestRecipeShopManageQuit();
    }
    isStartCraft = false;
    return;
}

function HandleSetMaxCount(string param)
{
    ParseInt(param, "dwarvenRecipeShop", m_ShopItemMaxCount_Dwarf);
    ParseInt(param, "recipeShop", m_ShopItemMaxCount_Normal);
    return;
}
