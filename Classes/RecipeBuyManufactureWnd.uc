class RecipeBuyManufactureWnd extends UICommonAPI;

const RECIPEWND_MAX_MP_WIDTH = 165.0f;
const CRYSTAL_TYPE_WIDTH = 14;
const CRYSTAL_TYPE_HEIGHT = 14;
const DIALOG_STACKABLE_ITEM_REMOVE = 1230;
const DIALOG_STACKABLE_ITEM_ADD = 1240;
const DIALOG_100PER_CHECK = 1250;

var string m_WindowName;
var int m_merchantID;
var int m_RecipeID;
var int m_SuccessRate;
var INT64 m_Adena;
var int m_MaxMP;
var int m_CurrRate;
var BarHandle MPBar;
var ItemWindowHandle m_TributeItemWnd;
var TextBoxHandle m_offeringRateTextBox;
var int m_offering;
var ItemWindowHandle m_ItemWnd;

function OnRegisterEvent()
{
    RegisterEvent(800);
    RegisterEvent(210);
    RegisterEvent(211);
    RegisterEvent(2600);
    RegisterEvent(2610);
    RegisterEvent(1710);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    MPBar = GetBarHandle("RecipeBuyManufactureWnd.barMp");
    m_ItemWnd = GetItemWindowHandle(m_WindowName $ ".ItemWnd");
    m_TributeItemWnd = GetItemWindowHandle(m_WindowName $ ".TributeWnd.TributeItemWnd");
    m_offeringRateTextBox = GetTextBoxHandle(m_WindowName $ ".txtOfferingRate");
    GetTextBoxHandle(m_WindowName $ ".txtOffering").SetText(GetSystemString(654) $ GetSystemString(642));
    return;
}

function OnEvent(int Event_ID, string param)
{
    local Rect rectWnd;
    local int ServerID, MPValue, merchantId, RecipeID, currentMP, maxMP,
	    MakingResult;

    local INT64 Adena;

    // End:0x1F1
    if(Event_ID == 800)
    {
        Clear();
        // End:0xB4
        if(IsShowWindow("RecipeBuyListWnd"))
        {
            rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect("RecipeBuyListWnd");
            Class'NWindow.UIAPI_WINDOW'.static.MoveTo("RecipeBuyManufactureWnd", rectWnd.nX, rectWnd.nY);
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeBuyListWnd");
        }
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RecipeBuyManufactureWnd");
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus("RecipeBuyManufactureWnd");
        ParseInt(param, "MerchantID", merchantId);
        ParseInt(param, "RecipeID", RecipeID);
        ParseInt(param, "CurrentMP", currentMP);
        ParseInt(param, "MaxMP", maxMP);
        ParseInt(param, "MakingResult", MakingResult);
        ParseINT64(param, "Adena", Adena);
        ParseInt(param, "UseOffering", m_offering);
        ReceiveRecipeShopSellList(merchantId, RecipeID, currentMP, maxMP, MakingResult, Adena);
        setTributeWnd();
        setOfferingRate();        
    }
    else
    {
        // End:0x26A
        if((Event_ID == 210) || Event_ID == 211)
        {
            ParseInt(param, "ServerID", ServerID);
            ParseInt(param, "CurrentMP", MPValue);
            // End:0x267
            if((m_merchantID == ServerID) && m_merchantID > 0)
            {
                SetMPBar(MPValue);
            }            
        }
        else
        {
            // End:0x298
            if((Event_ID == 2600) || Event_ID == 2610)
            {
                HandleInventoryItem(param);                
            }
            else
            {
                // End:0x2AD
                if(Event_ID == 1710)
                {
                    HandleDialogOK();
                }
            }
        }
    }
    return;
}

function HandleDialogOK()
{
    local ItemInfo scInfo;
    local INT64 inputNum;
    local int tributeID;
    local ItemInfo tributeItemInfo;
    local bool allItemMove;
    local int Id;

    // End:0x1D9
    if(DialogIsMine())
    {
        Id = DialogGetID();
        // End:0x1C4
        if((Id == 1230) || Id == 1240)
        {
            DialogGetReservedItemInfo(scInfo);
            inputNum = (DialogGetString());
            // End:0x5E
            if(__NFUN_410__(inputNum, (0)))
            {
                return;
            }
            // End:0x8B
            if(__NFUN_411__(inputNum, scInfo.ItemNum))
            {
                inputNum = scInfo.ItemNum;
                allItemMove = true;
            }
            tributeID = m_TributeItemWnd.FindItem(scInfo.Id);
            // End:0x107
            if(Id == 1230)
            {
                // End:0xD9
                if(allItemMove)
                {
                    m_TributeItemWnd.DeleteItem(tributeID);                    
                }
                else
                {
                    __NFUN_407__(scInfo.ItemNum, inputNum);
                    m_TributeItemWnd.SetItem(tributeID, scInfo);
                }                
            }
            else
            {
                // End:0x1BB
                if(Id == 1240)
                {
                    // End:0x197
                    if(tributeID >= 0)
                    {
                        m_TributeItemWnd.GetItem(tributeID, tributeItemInfo);
                        __NFUN_406__(tributeItemInfo.ItemNum, inputNum);
                        // End:0x17B
                        if(__NFUN_408__(scInfo.ItemNum, tributeItemInfo.ItemNum))
                        {
                            tributeItemInfo.ItemNum = scInfo.ItemNum;
                        }
                        m_TributeItemWnd.SetItem(tributeID, tributeItemInfo);                        
                    }
                    else
                    {
                        scInfo.ItemNum = inputNum;
                        m_TributeItemWnd.AddItem(scInfo);
                    }
                }
            }
            setOfferingRate();            
        }
        else
        {
            // End:0x1D9
            if(Id == 1250)
            {
                ManufactureWidthTribute();
            }
        }
    }
    return;
}

function bool isShowDialogOnMoveStackableItem(ItemInfo infItem)
{
    // End:0x3E
    if(IsStackableItem(infItem.ConsumeType) && __NFUN_413__(infItem.ItemNum, (1)))
    {
        // End:0x3E
        if(!Class'NWindow.InputAPI'.static.IsAltPressed())
        {
            return true;
        }
    }
    return false;
    return;
}

function deleteTributeItem(ItemInfo infItem)
{
    local int tributeItemID;

    tributeItemID = m_TributeItemWnd.FindItem(infItem.Id);
    // End:0x40
    if(isShowDialogOnMoveStackableItem(infItem))
    {
        showStackItemDialog(1230, infItem);        
    }
    else
    {
        m_TributeItemWnd.DeleteItem(tributeItemID);
        setOfferingRate();
    }
    return;
}

function showStackItemDialog(int Id, ItemInfo infItem)
{
    local string SystemMsg;

    DialogSetID(Id);
    // End:0x2E
    if(Id == 1230)
    {
        SystemMsg = GetSystemMessage(6193);        
    }
    else
    {
        // End:0x51
        if(Id == 1240)
        {
            SystemMsg = GetSystemMessage(6192);            
        }
        else
        {
            SystemMsg = GetSystemMessage(72);
        }
    }
    DialogSetReservedItemInfo(infItem);
    DialogSetParamInt64(infItem.ItemNum);
    DialogShow(1, 6, MakeFullSystemMsg(SystemMsg, infItem.Name, ""), string(self));
    return;
}

function handleRemoveItem(ItemWindowHandle a_hItemWindow, int Index)
{
    local ItemInfo Info;

    // End:0x20
    if(!a_hItemWindow.GetItem(Index, Info))
    {
        return;
    }
    switch(a_hItemWindow.GetWindowName())
    {
        // End:0x52
        case "TributeItemWnd":
            deleteTributeItem(Info);
            // End:0x55
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
    handleRemoveItem(a_hItemWindow, Index);
    return;
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
    handleRemoveItem(a_hItemWindow, Index);
    return;
}

function OnDropItemSource(string strTarget, ItemInfo Info)
{
    // End:0x43
    if(strTarget == "Console")
    {
        switch(Info.DragSrcName)
        {
            // End:0x40
            case "TributeItemWnd":
                deleteTributeItem(Info);
                // End:0x43
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return;
    }
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    local int tributeID;
    local ItemInfo tributeItemInfo;

    // End:0xEB
    if(!((((((a_ItemInfo.DragSrcName == "InventoryItem") || a_ItemInfo.DragSrcName == "InventoryItem_1") || a_ItemInfo.DragSrcName == "InventoryItem_2") || a_ItemInfo.DragSrcName == "InventoryItem_3") || a_ItemInfo.DragSrcName == "InventoryItem_4") || a_ItemInfo.DragSrcName == "PetInvenWnd") || -1 != InStr(a_ItemInfo.DragSrcName, "EquipItem"))
    {
        return;
    }
    // End:0x114
    if(a_ItemInfo.DragSrcName == "PetInvenWnd")
    {
        AddSystemMessage(6184);
        return;
    }
    // End:0x298
    if(a_WindowID == "TributeItemWnd")
    {
        // End:0x16F
        if(!Class'NWindow.UIDATA_RECIPE'.static.IsOfferingItem(a_ItemInfo.Id, true))
        {
            // End:0x16F
            if(!IsAdena(a_ItemInfo.Id))
            {
                AddSystemMessage(6190);
                return;
            }
        }
        // End:0x192
        if(m_TributeItemWnd.GetItemNum() == 12)
        {
            AddSystemMessage(6191);
            return;
        }
        a_ItemInfo.ItemNum = getMaxTributeItemNum(a_ItemInfo);
        // End:0x1E9
        if(__NFUN_410__(a_ItemInfo.ItemNum, (0)))
        {
            // End:0x1DC
            if(IsAdena(a_ItemInfo.Id))
            {
                AddSystemMessage(4157);                
            }
            else
            {
                AddSystemMessage(341);
            }
            return;
        }
        // End:0x20A
        if(isShowDialogOnMoveStackableItem(a_ItemInfo))
        {
            showStackItemDialog(1240, a_ItemInfo);            
        }
        else
        {
            tributeID = m_TributeItemWnd.FindItem(a_ItemInfo.Id);
            // End:0x27E
            if(tributeID >= 0)
            {
                m_TributeItemWnd.GetItem(tributeID, tributeItemInfo);
                tributeItemInfo.ItemNum = a_ItemInfo.ItemNum;
                m_TributeItemWnd.SetItem(tributeID, tributeItemInfo);                
            }
            else
            {
                m_TributeItemWnd.AddItem(a_ItemInfo);
            }
            setOfferingRate();
        }
    }
    return;
}

function setOfferingRateString(INT64 OfferingRate)
{
    local string strTmp;
    local L2Util util;
    local Color offeringRateColor;

    util = L2Util(GetScript("L2Util"));
    strTmp = (OfferingRate) $ "%";
    // End:0x85
    if(__NFUN_410__((100 - m_SuccessRate), OfferingRate))
    {
        strTmp = strTmp $ GetSystemString(2610);
        offeringRateColor.R = byte(255);
        offeringRateColor.G = 102;
        offeringRateColor.B = 102;        
    }
    else
    {
        offeringRateColor = util.Yellow03;
    }
    m_offeringRateTextBox.SetTextColor(offeringRateColor);
    m_offeringRateTextBox.SetText(strTmp);
    return;
}

function setOfferingRate()
{
    local INT64 totalDefaultPrice;
    local int i;
    local ItemInfo tributeItemInfo;

    totalDefaultPrice = (0);
    i = 0;
    J0x10:

    // End:0x6B [Loop If]
    if(i < m_TributeItemWnd.GetItemNum())
    {
        m_TributeItemWnd.GetItem(i, tributeItemInfo);
        __NFUN_406__(totalDefaultPrice, __NFUN_401__(tributeItemInfo.ItemNum, tributeItemInfo.n64DefaultPriceFromScript));
        i++;
        // [Loop Continue]
        goto J0x10;
    }
    m_CurrRate = RefreshRecipeOfferingRate(totalDefaultPrice, true);
    setOfferingRateString((m_CurrRate));
    return;
}

function setTributeWnd()
{
    // End:0xCD
    if(m_offering > 0)
    {
        GetWindowHandle(m_WindowName $ ".TributeWnd").ShowWindow();
        GetWindowHandle(m_WindowName).SetWindowSize(254, 537);
        GetTextureHandle(m_WindowName $ ".RecipeBg").SetWindowSize(241, 107);
        GetTextBoxHandle(m_WindowName $ ".txtOffering").ShowWindow();
        GetTextBoxHandle(m_WindowName $ ".txtOfferMid").ShowWindow();
        m_offeringRateTextBox.ShowWindow();        
    }
    else
    {
        GetWindowHandle(m_WindowName $ ".TributeWnd").HideWindow();
        GetWindowHandle(m_WindowName).SetWindowSize(254, 407);
        GetTextureHandle(m_WindowName $ ".RecipeBg").SetWindowSize(241, 92);
        GetTextBoxHandle(m_WindowName $ ".txtOffering").HideWindow();
        GetTextBoxHandle(m_WindowName $ ".txtOfferMid").HideWindow();
        m_offeringRateTextBox.HideWindow();
    }
    return;
}

function INT64 getMaxTributeItemNum(ItemInfo tributeItem)
{
    local ItemInfo infItem;
    local int idx;
    local INT64 needNum;

    needNum = (0);
    idx = m_ItemWnd.FindItemByClassID(tributeItem.Id);
    // End:0x63
    if(idx > -1)
    {
        m_ItemWnd.GetItem(idx, infItem);
        needNum = infItem.Reserved64;        
    }
    else
    {
        // End:0x81
        if(IsAdena(tributeItem.Id))
        {
            needNum = m_Adena;
        }
    }
    return __NFUN_405__(tributeItem.ItemNum, needNum);
    return;
}

function ManufactureWidthTribute()
{
    local array<OfferingItemList> tributeItemList;
    local int i;
    local ItemInfo tributeItem;

    tributeItemList.Length = m_TributeItemWnd.GetItemNum();
    i = 0;
    J0x1D:

    // End:0x8B [Loop If]
    if(i < tributeItemList.Length)
    {
        m_TributeItemWnd.GetItem(i, tributeItem);
        tributeItemList[i].nItemID = tributeItem.Id.ServerID;
        tributeItemList[i].nAmount = tributeItem.ItemNum;
        i++;
        // [Loop Continue]
        goto J0x1D;
    }
    Class'NWindow.RecipeAPI'.static.RequestRecipeShopMakeDo(m_merchantID, m_RecipeID, m_Adena, m_TributeItemWnd.GetItemNum(), tributeItemList);
    return;
}

function OnClickButton(string strID)
{
    local string param;
    local Rect rectWnd;
    local string SystemMsg;
    local int nDefaultRate;

    switch(strID)
    {
        // End:0x1D
        case "btnClose":
            closeWindow();
            // End:0x1DD
            break;
        // End:0x95
        case "btnPrev":
            Class'NWindow.RecipeAPI'.static.RequestRecipeShopSellList(m_merchantID);
            rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect(m_WindowName);
            Class'NWindow.UIAPI_WINDOW'.static.MoveTo("RecipeBuyListWnd", rectWnd.nX, rectWnd.nY);
            closeWindow();
            // End:0x1DD
            break;
        // End:0x137
        case "btnRecipeTree":
            // End:0xE9
            if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("RecipeTreeWnd"))
            {
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");                
            }
            else
            {
                ParamAdd(param, "RecipeID", string(m_RecipeID));
                ParamAdd(param, "SuccessRate", string(m_SuccessRate));
                ExecuteEvent(810, param);
            }
            // End:0x1DD
            break;
        // End:0x1DA
        case "btnManufacture":
            // End:0x1B9
            if(m_offering > 0)
            {
                DialogSetID(1250);
                SystemMsg = GetSystemMessage(6206);
                nDefaultRate = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeSuccessRate(m_RecipeID);
                nDefaultRate += m_CurrRate;
                DialogShow(0, 0, MakeFullSystemMsg(SystemMsg, string(nDefaultRate)), string(self));                
            }
            else
            {
                Class'NWindow.RecipeAPI'.static.RequestRecipeShopMakeDo(m_merchantID, m_RecipeID, m_Adena);
            }
            // End:0x1DD
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function closeWindow()
{
    Clear();
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeBuyManufactureWnd");
    PlayConsoleSound(6);
    return;
}

function Clear()
{
    m_merchantID = 0;
    m_RecipeID = 0;
    m_SuccessRate = 0;
    m_Adena = (0);
    m_MaxMP = 0;
    m_ItemWnd.super(RecipeBuyManufactureWnd).Clear();
    // End:0x53
    if(!IsShowWindow(m_WindowName))
    {
        m_TributeItemWnd.super(RecipeBuyManufactureWnd).Clear();
    }
    m_offering = 0;
    return;
}

function ReceiveRecipeShopSellList(int merchantId, int RecipeID, int currentMP, int maxMP, int MakingResult, INT64 Adena)
{
    local int i;
    local string strTmp;
    local int nTmp, nTmp2, ProductID, ProductNum;
    local string ItemName, param;
    local ItemInfo infItem, NewItem;

    m_merchantID = merchantId;
    m_RecipeID = RecipeID;
    m_SuccessRate = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
    m_Adena = Adena;
    m_MaxMP = maxMP;
    strTmp = (GetSystemString(663) $ " - ") $ Class'NWindow.UIDATA_USER'.static.GetUserName(merchantId);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("RecipeBuyManufactureWnd", strTmp);
    ProductID = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ProductID), NewItem);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("RecipeBuyManufactureWnd.texItem");
    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeBuyManufactureWnd.texItem", NewItem);
    nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
    strTmp = GetItemGradeTextureName(nTmp);
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("RecipeBuyManufactureWnd.texGrade", strTmp);
    // End:0x217
    if((((nTmp == int(6)) || nTmp == int(9)) || nTmp == int(10)) || nTmp == int(11))
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("RecipeManufactureWnd.texGrade", 14 * 2, 14);        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("RecipeManufactureWnd.texGrade", 14, 14);
    }
    ItemName = MakeFullItemName(ProductID);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtName", ItemName);
    nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMPConsume", "" $ string(nTmp));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtSuccessRate", string(m_SuccessRate) $ "%");
    ProductNum = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductNum(RecipeID);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtResultValue", "" $ string(ProductNum));
    SetMPBar(currentMP);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtCountValue", "" $ (GetInventoryItemCount(GetItemID(ProductID))));
    strTmp = "";
    // End:0x414
    if(MakingResult == 0)
    {
        strTmp = MakeFullSystemMsg(GetSystemMessage(960), ItemName, "");        
    }
    else
    {
        // End:0x446
        if(MakingResult == 1)
        {
            strTmp = MakeFullSystemMsg(GetSystemMessage(959), ItemName, "" $ string(ProductNum));
        }
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMsg", strTmp);
    param = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeMaterialItem(RecipeID);
    ParseInt(param, "Count", nTmp);
    i = 0;
    J0x4B2:

    // End:0x5CD [Loop If]
    if(i < nTmp)
    {
        ParseInt(param, "ID_" $ string(i), nTmp2);
        infItem.Id = GetItemID(nTmp2);
        Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(nTmp2), infItem);
        ParseINT64(param, "NeededNum_" $ string(i), infItem.Reserved64);
        infItem.ItemNum = GetInventoryItemCount(infItem.Id);
        // End:0x582
        if(__NFUN_409__(infItem.Reserved64, infItem.ItemNum))
        {
            infItem.bDisabled = 1;            
        }
        else
        {
            infItem.bDisabled = 0;
        }
        Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeBuyManufactureWnd.ItemWnd", infItem);
        i++;
        // [Loop Continue]
        goto J0x4B2;
    }
    return;
}

function SetMPBar(int currentMP)
{
    MPBar.SetValue(m_MaxMP, currentMP);
    return;
}

function HandleInventoryItem(string param)
{
    local ItemID cID;
    local int idx;
    local ItemInfo infItem;
    local INT64 invenItemCount, needNum;
    local string Type;

    // End:0x12
    if(!IsShowWindow(m_WindowName))
    {
        return;
    }
    // End:0x215
    if(ParseItemID(param, cID))
    {
        needNum = (0);
        idx = m_ItemWnd.FindItemByClassID(cID);
        // End:0xE9
        if(idx > -1)
        {
            m_ItemWnd.GetItem(idx, infItem);
            infItem.ItemNum = GetInventoryItemCount(infItem.Id);
            // End:0xB4
            if(__NFUN_409__(infItem.Reserved64, infItem.ItemNum))
            {
                infItem.bDisabled = 1;                
            }
            else
            {
                infItem.bDisabled = 0;
            }
            m_ItemWnd.SetItem(idx, infItem);
            needNum = infItem.Reserved64;
        }
        idx = m_TributeItemWnd.FindItem(cID);
        // End:0x215
        if(idx > -1)
        {
            ParseString(param, "type", Type);
            m_TributeItemWnd.GetItem(idx, infItem);
            // End:0x1D7
            if(Type == "update")
            {
                invenItemCount = __NFUN_405__(GetInventoryItemCount(infItem.Id), needNum);
                // End:0x196
                if(__NFUN_410__(invenItemCount, (0)))
                {
                    m_TributeItemWnd.DeleteItem(idx);                    
                }
                else
                {
                    // End:0x1D4
                    if(__NFUN_408__(invenItemCount, infItem.ItemNum))
                    {
                        infItem.ItemNum = invenItemCount;
                        m_TributeItemWnd.SetItem(idx, infItem);
                    }
                }                
            }
            else
            {
                // End:0x200
                if(Type == "delete")
                {
                    m_TributeItemWnd.DeleteItem(idx);                    
                }
                else
                {
                    // End:0x20F
                    if(Type == "add")
                    {
                    }
                }
            }
            setOfferingRate();
        }
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("RecipeBuyManufactureWnd").HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="RecipeBuyManufactureWnd"
}