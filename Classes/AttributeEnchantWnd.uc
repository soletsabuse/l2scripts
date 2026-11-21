class AttributeEnchantWnd extends UICommonAPI;

const DIALOG_ASK_ITEM_COUNT = 55555;
const DIALOG_ENCHANT_COMPLETE = 55556;

var WindowHandle Me;
var WindowHandle DisableWnd;
var ItemWindowHandle ItemWnd;
var ItemWindowHandle InventoryItemHandle;
var TextBoxHandle TextBox;
var TextBoxHandle ItemCountTextBox;
var ButtonHandle OKButton;
var ButtonHandle AttributeCountEditBtn;
var ItemInfo SelectItemInfo;
var ItemInfo ResourceInfo;
var int ScrollCID;
var INT64 LoopEnchantItemCount;
var INT64 ResourceItemCount;
var int ItemClassID;
var EditBoxHandle AttributeCountEditBox;

function OnRegisterEvent()
{
    RegisterEvent(2893);
    RegisterEvent(2865);
    RegisterEvent(2894);
    RegisterEvent(2895);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    DisableWnd = GetWindowHandle("AttributeEnchantWnd.DisableWnd");
    Me = GetWindowHandle("AttributeEnchantWnd");
    ItemWnd = GetItemWindowHandle("AttributeEnchantWnd.ItemWnd");
    TextBox = GetTextBoxHandle("AttributeEnchantWnd.txtScrollName");
    OKButton = GetButtonHandle("AttributeEnchantWnd.btnOK");
    AttributeCountEditBtn = GetButtonHandle("AttributeEnchantWnd.AttributeCountEditBtn");
    AttributeCountEditBox = GetEditBoxHandle("AttributeEnchantWnd.AttributeCountEditBox");
    InventoryItemHandle = GetItemWindowHandle("InventoryWnd.InventoryItem");
    ItemCountTextBox = GetTextBoxHandle("AttributeEnchantWnd.itemCountTxt");
    AttributeCountEditBox.SetMaxLength(6);
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x57
    if(Event_ID == 2893)
    {
        // End:0x49
        if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AttributeRemoveWnd"))
        {
            AddSystemMessage(3161);
            OnCancelClick();            
        }
        else
        {
            HandleAttributeEnchantShow(param);
        }        
    }
    else
    {
        // End:0x6F
        if(Event_ID == 2865)
        {
            HandleAttributeEnchantHide();            
        }
        else
        {
            // End:0x8C
            if(Event_ID == 2894)
            {
                HandleAttributeEnchantItemList(param);                
            }
            else
            {
                // End:0xA9
                if(Event_ID == 2895)
                {
                    HandleAttributeEnchantResult(param);                    
                }
                else
                {
                    // End:0xC1
                    if(Event_ID == 1710)
                    {
                        HandleDialogOK();                        
                    }
                    else
                    {
                        // End:0xD6
                        if(Event_ID == 1720)
                        {
                            HandleDialogCancel();
                        }
                    }
                }
            }
        }
    }
    return;
}

function HandleDialogOK()
{
    local int Id;
    local ItemID scID;
    local ItemInfo scInfo;
    local INT64 inputNum;

    // End:0xA0
    if(DialogIsMine())
    {
        Id = DialogGetID();
        inputNum = (DialogGetString());
        // End:0x3E
        if(__NFUN_408__(ResourceItemCount, inputNum))
        {
            inputNum = ResourceItemCount;
        }
        scID = DialogGetReservedItemID();
        DialogGetReservedItemInfo(scInfo);
        // End:0xA0
        if(Id == 55555)
        {
            AttributeCountEditBox.SetString((inputNum));
            // End:0x95
            if(__NFUN_408__(ResourceItemCount, inputNum))
            {
                inputNum = ResourceItemCount;
            }
            LoopEnchantItemCount = inputNum;
        }
    }
    DisableCurrentWindow(false);
    return;
}

function HandleDialogCancel()
{
    // End:0x10
    if(DialogIsMine())
    {
        DisableCurrentWindow(false);
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    // End:0x22
    if(strID == "ItemWnd")
    {
        OKButton.EnableWindow();
    }
    return;
}

function OnClickButton(string strID)
{
    local INT64 ItemCount;

    ItemCount = (AttributeCountEditBox.GetString());
    switch(strID)
    {
        // End:0x80
        case "btnOK":
            DisableCurrentWindow(true);
            // End:0x56
            if(__NFUN_408__(ResourceItemCount, (AttributeCountEditBox.GetString())))
            {
                ItemCount = ResourceItemCount;
            }
            AttributeCountEditBox.SetString((ItemCount));
            LoopEnchantItemCount = ItemCount;
            OnOkClickProgress();
            // End:0xBD
            break;
        // End:0x97
        case "btnCancel":
            OnCancelClick();
            // End:0xBD
            break;
        // End:0xBA
        case "AttributeCountEditBtn":
            CountBtnClick();
            // End:0xBD
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function CountBtnClick()
{
    local ItemInfo Info;

    // End:0x9C
    if(ItemWnd.GetItemNum() > 0)
    {
        ItemWnd.GetItem(0, Info);
        DialogSetID(55555);
        DialogSetReservedItemID(Info.Id);
        DialogSetEditType("number");
        DialogSetEditBoxMaxLength(6);
        DialogSetParamInt64(ResourceItemCount);
        DialogSetDefaultOK();
        Debug(GetSystemMessage(4142));
        DialogShow(1, 6, GetSystemMessage(4142), string(self));
        DisableCurrentWindow(true);
    }
    return;
}

function OnOkClickProgress()
{
    local ProgressBox script;

    ItemWnd.GetSelectedItem(SelectItemInfo);
    // End:0x16C
    if(SelectItemInfo.Id.ClassID != 0)
    {
        // End:0x57
        if(IsShowWindow("ItemEnchantWnd"))
        {
            AddSystemMessage(2188);
            DisableCurrentWindow(false);            
        }
        else
        {
            // End:0xE0
            if(SelectItemInfo.Reserved != 0)
            {
                // End:0x82
                if(SelectItemInfo.Reserved == 1)
                {
                    AddSystemMessage(3117);
                }
                // End:0x9E
                if(SelectItemInfo.Reserved == 2)
                {
                    AddSystemMessage(3154);
                }
                // End:0xBA
                if(SelectItemInfo.Reserved == 4)
                {
                    AddSystemMessage(3153);
                }
                // End:0xD6
                if(SelectItemInfo.Reserved == 6)
                {
                    AddSystemMessage(3155);
                }
                DisableCurrentWindow(false);                
            }
            else
            {
                script = ProgressBox(GetScript("ProgressBox"));
                script.Initialize();
                script.ShowDialog(MakeFullSystemMsg(GetSystemMessage(4140), ResourceInfo.Name, (LoopEnchantItemCount), SelectItemInfo.Name), "AttributeEnchantWnd", 2000, ResourceInfo, SelectItemInfo);
            }
        }
    }
    return;
}

function OnOKClick()
{
    Class'NWindow.EnchantAPI'.static.RequestEnchantItemAttribute(SelectItemInfo.Id, LoopEnchantItemCount);
    return;
}

function OnCancelClick()
{
    local ItemID Id;

    Id = GetItemID(-1);
    Class'NWindow.EnchantAPI'.static.RequestEnchantItemAttribute(Id, LoopEnchantItemCount);
    Me.HideWindow();
    Clear();
    return;
}

function Clear()
{
    ItemWnd.super(AttributeEnchantWnd).Clear();
    return;
}

function HandleAttributeEnchantShow(string param)
{
    local ItemID cID;
    local INT64 Count;

    Clear();
    ParseItemID(param, cID);
    ParseINT64(param, "ItemCount", Count);
    ResourceItemCount = Count;
    ScrollCID = cID.ClassID;
    TextBox.SetText(Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID));
    ItemClassID = cID.ClassID;
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, ResourceInfo);
    ItemCountTextBox.SetText("x");
    AttributeCountEditBox.SetString("1");
    OKButton.DisableWindow();
    Me.ShowWindow();
    Me.SetFocus();
    DisableCurrentWindow(false);
    return;
}

function DisableCurrentWindow(bool bFlag)
{
    // End:0x2A
    if(bFlag)
    {
        DisableWnd.EnableWindow();
        DisableWnd.ShowWindow();        
    }
    else
    {
        DisableWnd.DisableWindow();
        DisableWnd.HideWindow();
    }
    return;
}

function HandleAttributeEnchantHide()
{
    return;
}

function HandleAttributeEnchantItemList(string param)
{
    local ItemInfo infItem;
    local int Ispossible;

    ParseInt(param, "Ispossible", Ispossible);
    ParamToItemInfo(param, infItem);
    infItem.Reserved = Ispossible;
    // End:0xEA
    if(((((!infItem.bSecurityLock && infItem.CrystalType > 2) && infItem.ShieldDefense == float(0)) && __NFUN_413__(infItem.SlotBitType, (268435456))) && infItem.ArmorType != 4) && __NFUN_413__(infItem.SlotBitType, (1)))
    {
        // End:0xD6
        if(Ispossible == 0)
        {
            ItemWnd.AddItem(infItem);            
        }
        else
        {
            ItemWnd.AddItemWithFaded(infItem);
        }
    }
    return;
}

function string GetPropString(int Id)
{
    switch(Id)
    {
        // End:0x1E
        case 9546:
            return GetSystemString(2753);
            // End:0x94
            break;
        // End:0x35
        case 9547:
            return GetSystemString(2754);
            // End:0x94
            break;
        // End:0x4C
        case 9549:
            return GetSystemString(2755);
            // End:0x94
            break;
        // End:0x63
        case 9548:
            return GetSystemString(2756);
            // End:0x94
            break;
        // End:0x7A
        case 9551:
            return GetSystemString(2757);
            // End:0x94
            break;
        // End:0x91
        case 9550:
            return GetSystemString(2758);
            // End:0x94
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleAttributeEnchantResult(string param)
{
    local int Result, isWeapon, attrType, beforeAttrValue, afterAttrValue, failCount;

    local INT64 successCount;
    local ItemInfo iInfo;

    ParseInt(param, "Result", Result);
    ParseInt(param, "IsWeapon", isWeapon);
    ParseInt(param, "AttrType", attrType);
    ParseInt(param, "BeforeAttrValue", beforeAttrValue);
    ParseInt(param, "AfterAttrValue", afterAttrValue);
    ParseInt(param, "FailCount", failCount);
    ParseINT64(param, "SuccessCount", successCount);
    InventoryItemHandle.GetItem(InventoryItemHandle.FindItem(ResourceInfo.Id), iInfo);
    // End:0x16A
    if(Result != 2)
    {
        DialogSetID(55556);
        DialogShowWithResize(1, 1, MakeFullSystemMsg(GetSystemMessage(4141), ResourceInfo.Name, (LoopEnchantItemCount), (successCount), string(failCount), (__NFUN_405__(LoopEnchantItemCount, __NFUN_404__(successCount, (failCount))))), -1, 260, string(self));
    }
    DisableCurrentWindow(false);
    Me.HideWindow();
    Clear();
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    HandleAttributeEnchantHide();
    OnCancelClick();
    return;
}
