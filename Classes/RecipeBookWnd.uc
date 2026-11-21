class RecipeBookWnd extends UICommonAPI;

var string m_WindowName;
var int m_itemCount;
var array<ItemID> m_arrItemID;
var int m_BookType;
var int m_ItemMaxCount_Dwarf;
var int m_ItemMaxCount_Normal;
var ItemID m_DeleteItemID;

function OnRegisterEvent()
{
    RegisterEvent(820);
    RegisterEvent(830);
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
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int RecipeAddBookItem;
    local Rect rectWnd;

    // End:0x166
    if(Event_ID == 820)
    {
        Clear();
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RecipeBookWnd");
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus("RecipeBookWnd");
        // End:0xF2
        if(IsShowWindow("RecipeManufactureWnd"))
        {
            rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect("RecipeManufactureWnd");
            Class'NWindow.UIAPI_WINDOW'.static.MoveTo("RecipeBookWnd", rectWnd.nX, rectWnd.nY);
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeManufactureWnd");
        }
        ParseInt(param, "Type", m_BookType);
        // End:0x139
        if(m_BookType == 1)
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle("RecipeBookWnd", 1214);            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle("RecipeBookWnd", 1215);
        }
        SetItemCount(0);        
    }
    else
    {
        // End:0x19D
        if(Event_ID == 830)
        {
            ParseInt(param, "RecipeID", RecipeAddBookItem);
            AddRecipeBookItem(RecipeAddBookItem);            
        }
        else
        {
            // End:0x1F1
            if(Event_ID == 2070)
            {
                ParseInt(param, "recipe", m_ItemMaxCount_Normal);
                ParseInt(param, "dwarvenRecipe", m_ItemMaxCount_Dwarf);
                SetItemCount(m_itemCount);                
            }
            else
            {
                // End:0x21D
                if(Event_ID == 1710)
                {
                    // End:0x21D
                    if(DialogIsMine())
                    {
                        Class'NWindow.RecipeAPI'.static.RequestRecipeItemDelete(m_DeleteItemID);
                    }
                }
            }
        }
    }
    return;
}

function OnDBClickItem(string strID, int Index)
{
    // End:0x41
    if((strID == "RecipeItem") && m_itemCount > Index)
    {
        Class'NWindow.RecipeAPI'.static.RequestRecipeItemMakeInfo(m_arrItemID[Index]);
    }
    return;
}

function OnDropItem(string strID, ItemInfo infItem, int X, int Y)
{
    // End:0x1F
    if(strID == "btnTrash")
    {
        DeleteItem(infItem);
    }
    return;
}

function OnClickButton(string strID)
{
    local ItemInfo infItem;

    switch(strID)
    {
        // End:0x53
        case "btnTrash":
            // End:0x50
            if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedItem("RecipeBookWnd.RecipeItem", infItem))
            {
                DeleteItem(infItem);
            }
            // End:0x56
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function Clear()
{
    SetItemCount(0);
    m_arrItemID.Remove(0, m_arrItemID.Length);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("RecipeBookWnd.RecipeItem");
    return;
}

function AddRecipeBookItem(int RecipeID)
{
    local ItemInfo infItem;
    local int ProductID;

    ProductID = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
    infItem.Id = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeItemID(RecipeID);
    infItem.Level = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
    infItem.ItemSubType = int(5);
    infItem.Name = Class'NWindow.UIDATA_ITEM'.static.GetItemName(infItem.Id);
    infItem.Description = Class'NWindow.UIDATA_ITEM'.static.GetItemDescription(infItem.Id);
    infItem.Weight = Class'NWindow.UIDATA_ITEM'.static.GetItemWeight(infItem.Id);
    infItem.IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
    infItem.CrystalType = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeBookWnd.RecipeItem", infItem);
    m_arrItemID.Insert(m_arrItemID.Length, 1);
    m_arrItemID[m_arrItemID.Length - 1] = infItem.Id;
    m_itemCount++;
    SetItemCount(m_itemCount);
    return;
}

function SetItemCount(int maxCount)
{
    local int nTmp;

    m_itemCount = maxCount;
    // End:0x24
    if(m_BookType == 1)
    {
        nTmp = m_ItemMaxCount_Normal;        
    }
    else
    {
        nTmp = m_ItemMaxCount_Dwarf;
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeBookWnd.txtCount", ((("(" $ string(m_itemCount)) $ "/") $ string(nTmp)) $ ")");
    return;
}

function DeleteItem(ItemInfo infItem)
{
    local string strMsg;

    strMsg = MakeFullSystemMsg(GetSystemMessage(74), infItem.Name, "");
    m_DeleteItemID = infItem.Id;
    DialogShow(1, 4, strMsg, string(self));
    return;
}

function OnHide()
{
    PlayConsoleSound(20);
    return;
}

function OnReceivedCloseUI()
{
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="RecipeBookWnd"
}