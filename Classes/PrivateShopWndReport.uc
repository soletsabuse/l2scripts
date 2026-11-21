class PrivateShopWndReport extends UICommonAPI;

const STRINGNUM_SALE_TITLE = 500;
const STRINGNUM_BUY_TITLE = 499;
const STRINGNUM_SALE_BULK_TITLE = 1273;

var WindowHandle Me;
var L2Util util;
var ListCtrlHandle ItemList_ListCtrl;
var ButtonHandle Edit_Btn;
var ButtonHandle StopSell_Btn;
var ButtonHandle EditorSetting_Btn;
var ButtonHandle history_Btn;
var array<ItemInfo> getItemInfoArray;
var array<INT64> getItemNumArray;
var array<int> buyItemServerIDArray;
var array<INT64> buyItemNumArray;
var array<string> buyUserNameArray;
var InventoryWnd inventoryWndScript;
var EditBoxHandle SignEditInput_Edit;
var TextBoxHandle SignEditInput_Txt;
var TextBoxHandle SignEditInput_guide;
var TextBoxHandle privateShopTitle_Txt;
var TextBoxHandle Benefit_Input1_Txt;
var TextBoxHandle Benefit_Input2_Txt;
var TextBoxHandle BenefitTitle1_Txt;
var TextBoxHandle BenefitTitle2_Txt;
var PrivateShopWnd privateShopScript;
var string messagetype;
var PrivateShopWndHistory PrivateShopWndHistoryScript;

function OnRegisterEvent()
{
    RegisterEvent(2610);
    RegisterEvent(10220);
    RegisterEvent(10221);
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function OnShow()
{
    messagetype = getCurrentMessageType();
    Edit_Btn.EnableWindow();
    updateList();
    setPrivateShopMessageText();
    Me.SetFocus();
    return;
}

function OnHide()
{
    Init();
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x34
        case "StopSell_Btn":
            // End:0x34
            if(!checkShoppingEnd())
            {
                privateShopScript.stopSellFlag = true;
            }
        // End:0x4A
        case "Edit_Btn":
            handleQuit();
            // End:0x85
            break;
        // End:0x63
        case "history_Btn":
            Onhistory_BtnClick();
            // End:0x85
            break;
        // End:0x82
        case "EditorSetting_Btn":
            togglePrivateShopEditor();
            // End:0x85
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    // End:0x26
    if((a_WindowHandle == SignEditInput_guide) || a_WindowHandle == SignEditInput_Txt)
    {
        showPrivateShopEditor();
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    // End:0x16
    if(!Me.IsShowWindow())
    {
        return;
    }
    switch(a_EventID)
    {
        // End:0x3F
        case 2610:
            // End:0x3C
            if(buyItemServerIDArray.Length > 0)
            {
                handleinventoryUpdateResult(a_Param);
            }
            // End:0x6E
            break;
        // End:0x55
        case 10220:
            handleBuyResult(a_Param);
            // End:0x6E
            break;
        // End:0x6B
        case 10221:
            handleSellingResult(a_Param);
            // End:0x6E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function Initialize()
{
    Me = GetWindowHandle("PrivateShopWndReport");
    ItemList_ListCtrl = GetListCtrlHandle("PrivateShopWndReport.ItemList_ListCtrl");
    StopSell_Btn = GetButtonHandle("PrivateShopWndReport.StopSell_Btn");
    Edit_Btn = GetButtonHandle("PrivateShopWndReport.Edit_Btn");
    history_Btn = GetButtonHandle("PrivateShopWndReport.history_Btn");
    EditorSetting_Btn = GetButtonHandle("PrivateShopWndReport.EditorSetting_Btn");
    util = L2Util(GetScript("L2Util"));
    inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
    privateShopTitle_Txt = GetTextBoxHandle("PrivateShopWndReport.privateShopTitle_Txt");
    SignEditInput_Txt = GetTextBoxHandle("PrivateShopWndReport.SignEditInput_Txt");
    SignEditInput_guide = GetTextBoxHandle("PrivateShopWndReport.SignEditInput_guide");
    SignEditInput_Edit = GetEditBoxHandle("PrivateShopWndReport.SignEditInput_Edit");
    Benefit_Input1_Txt = GetTextBoxHandle("PrivateShopWndReport.Benefit_Input1_Txt");
    Benefit_Input2_Txt = GetTextBoxHandle("PrivateShopWndReport.Benefit_Input2_Txt");
    BenefitTitle1_Txt = GetTextBoxHandle("PrivateShopWndReport.BenefitTitle1_Txt");
    BenefitTitle2_Txt = GetTextBoxHandle("PrivateShopWndReport.BenefitTitle2_Txt");
    PrivateShopWndHistoryScript = PrivateShopWndHistory(GetScript("PrivateShopWndHistory"));
    ItemList_ListCtrl.SetSelectedSelTooltip(false);
    ItemList_ListCtrl.SetAppearTooltipAtMouseX(true);
    privateShopScript = PrivateShopWnd(GetScript("PrivateShopWnd"));
    SignEditInput_guide.SetText(GetSystemMessage(334));
    Init();
    return;
}

function Init()
{
    getItemInfoArray.Length = 0;
    getItemNumArray.Length = 0;
    buyItemServerIDArray.Length = 0;
    buyItemNumArray.Length = 0;
    buyUserNameArray.Length = 0;
    ItemList_ListCtrl.DeleteAllItem();
    hidePrivateShopwEditor();
    return;
}

function handleBuyResult(string param)
{
    local int ServerID;
    local INT64 amount;
    local string Username;

    ParseInt(param, "ItemID", ServerID);
    buyItemServerIDArray.Length = buyItemServerIDArray.Length + 1;
    buyItemServerIDArray[buyItemServerIDArray.Length - 1] = ServerID;
    ParseINT64(param, "Amount", amount);
    buyItemNumArray.Length = buyItemNumArray.Length + 1;
    buyItemNumArray[buyItemNumArray.Length - 1] = amount;
    ParseString(param, "CharName", Username);
    buyUserNameArray.Length = buyUserNameArray.Length + 1;
    buyUserNameArray[buyUserNameArray.Length - 1] = Username;
    return;
}

function handleSellingResult(string param)
{
    local int ServerID;
    local INT64 amount;
    local string Username;

    ParseInt(param, "ItemID", ServerID);
    ParseINT64(param, "Amount", amount);
    ParseString(param, "CharName", Username);
    findNModifyRecord(ServerID, amount, Username);
    return;
}

function handleinventoryUpdateResult(string param)
{
    local int Count, i, Index;
    local ItemInfo updatedItemInfo;
    local LVDataRecord Record;
    local bool IsSame, isStackable;

    ParamToItemInfo(param, updatedItemInfo);
    i = 0;
    J0x17:

    // End:0x1F5 [Loop If]
    if(i < buyItemServerIDArray.Length)
    {
        // End:0x1EB
        if(buyItemServerIDArray[i] == updatedItemInfo.Id.ServerID)
        {
            Count = 0;
            J0x4D:

            // End:0x1EB [Loop If]
            if(Count < ItemList_ListCtrl.GetRecordCount())
            {
                ItemList_ListCtrl.GetRec(Count, Record);
                Index = name(Record.nReserved3);
                // End:0x1E1
                if(__NFUN_413__(getItemNumArray[Index], getItemInfoArray[Index].ItemNum))
                {
                    isStackable = IsStackableItem(updatedItemInfo.ConsumeType);
                    // End:0x123
                    if(updatedItemInfo.Id.ClassID == getItemInfoArray[Index].Id.ClassID)
                    {
                        // End:0x106
                        if(isStackable)
                        {
                            IsSame = true;                            
                        }
                        else
                        {
                            IsSame = compareItem(getItemInfoArray[Index], updatedItemInfo);
                        }
                    }
                    // End:0x1E1
                    if(IsSame)
                    {
                        Record = getModifyRecord(Record, buyItemNumArray[i]);
                        ItemList_ListCtrl.ModifyRecord(Count, Record);
                        PrivateShopWndHistoryScript.addHistory(Record.LVDataList[0].szData, isStackable, buyItemNumArray[i], buyUserNameArray[i]);
                        setCurrentTotalPrice();
                        buyItemServerIDArray.Remove(i, 1);
                        buyItemNumArray.Remove(i, 1);
                        buyUserNameArray.Remove(i, 1);
                        // End:0x1DF
                        if(checkShoppingEnd())
                        {
                            Edit_Btn.DisableWindow();
                        }
                        return;
                    }
                }
                Count++;
                // [Loop Continue]
                goto J0x4D;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x17;
    }
    return;
}

function LVDataRecord getModifyRecord(LVDataRecord Record, INT64 amount)
{
    local int Index;

    Index = name(Record.nReserved3);
    getItemNumArray[Index] = __NFUN_404__(getItemNumArray[Index], amount);
    Record.LVDataList[0] = makeItemNameRecord(Record, getItemNumArray[Index]);
    Record.LVDataList[1] = makeItemNumRecord(Record, getItemNumArray[Index]);
    Record.LVDataList[2] = makeItemPriceRecord(Record, getItemNumArray[Index]);
    Record.LVDataList[3] = makeItemTotalPrice(Record, getItemNumArray[Index]);
    return Record;
    return;
}

function findNModifyRecord(int ServerID, INT64 amount, string Username)
{
    local int Count;
    local LVDataRecord Record;

    getBuyItemInfo(ServerID);
    Count = 0;
    J0x12:

    // End:0xF1 [Loop If]
    if(Count < ItemList_ListCtrl.GetRecordCount())
    {
        ItemList_ListCtrl.GetRec(Count, Record);
        // End:0xE7
        if(__NFUN_412__(Record.nReserved1, (ServerID)))
        {
            Record = getModifyRecord(Record, amount);
            ItemList_ListCtrl.ModifyRecord(Count, Record);
            PrivateShopWndHistoryScript.addHistory(Record.LVDataList[0].szData, Record.LVDataList[2].hasIcon, amount, Username);
            setCurrentTotalPrice();
            // End:0xE5
            if(checkShoppingEnd())
            {
                Edit_Btn.DisableWindow();
            }
            return;
        }
        Count++;
        // [Loop Continue]
        goto J0x12;
    }
    return;
}

function getBuyItemInfo(int ServerID)
{
    local ItemInfo ResourceInfo;
    local ItemID pItemID;

    pItemID.ServerID = ServerID;
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(pItemID, ResourceInfo);
    return;
}

function startOpenPrivateShop(string param)
{
    Me.ShowWindow();
    return;
}

function string getCurrentMessageType()
{
    switch(privateShopScript.m_type)
    {
        // End:0x3F
        case 4:
            // End:0x35
            if(privateShopScript.m_bBulk)
            {
                return "bulksell";                
            }
            else
            {
                return "sell";
            }
            // End:0x50
            break;
        // End:0x4D
        case 3:
            return "buy";
            // End:0x50
            break;
        // End:0xFFFF
        default:
            break;
    }
    return "";
    return;
}

function handleGuideMessage()
{
    // End:0x28
    if(SignEditInput_Txt.GetText() == "")
    {
        SignEditInput_guide.ShowWindow();        
    }
    else
    {
        SignEditInput_guide.HideWindow();
    }
    return;
}

function togglePrivateShopEditor()
{
    // End:0x90
    if(SignEditInput_Edit.IsShowWindow())
    {
        // End:0x87
        if(((GetPrivateShopMessage(messagetype)) != SignEditInput_Edit.GetString()) && "" != SignEditInput_Edit.GetString())
        {
            SetPrivateShopMessage(messagetype, SignEditInput_Edit.GetString());
            SignEditInput_Txt.SetText(SignEditInput_Edit.GetString());
            handleGuideMessage();
        }
        hidePrivateShopwEditor();        
    }
    else
    {
        showPrivateShopEditor();
    }
    return;
}

function showPrivateShopEditor()
{
    SignEditInput_Txt.HideWindow();
    SignEditInput_Edit.ShowWindow();
    SignEditInput_Edit.SetString(GetPrivateShopMessage(messagetype));
    SignEditInput_Edit.SetFocus();
    SignEditInput_guide.HideWindow();
    EditorSetting_Btn.SetTexture("L2UI_CT1.Button.completeBtn_df", "L2UI_CT1.Button.completeBtn_down", "L2UI_CT1.Button.completeBtn_over");
    return;
}

function hidePrivateShopwEditor()
{
    SignEditInput_Txt.ShowWindow();
    SignEditInput_Edit.HideWindow();
    EditorSetting_Btn.SetTexture("L2UI_CT1.Button.SettingBtn_n", "L2UI_CT1.Button.SettingBtn_d", "L2UI_CT1.Button.SettingBtn_o");
    return;
}

function setPrivateShopMessageText()
{
    local string shopTitle;
    local Color messageColor;

    switch(messagetype)
    {
        // End:0x9C
        case "bulksell":
            messageColor = GetColor(255, 119, 119, 255);
            shopTitle = GetSystemString(1273);
            ItemList_ListCtrl.SetColumnString(2, 2502);
            ItemList_ListCtrl.SetColumnString(3, 3591);
            BenefitTitle1_Txt.SetText(GetSystemString(3593));
            BenefitTitle2_Txt.SetText(GetSystemString(3595));
            // End:0x1C0
            break;
        // End:0x12D
        case "sell":
            messageColor = GetColor(221, 119, 238, 255);
            shopTitle = GetSystemString(500);
            ItemList_ListCtrl.SetColumnString(2, 2502);
            ItemList_ListCtrl.SetColumnString(3, 3591);
            BenefitTitle1_Txt.SetText(GetSystemString(3593));
            BenefitTitle2_Txt.SetText(GetSystemString(3595));
            // End:0x1C0
            break;
        // End:0x1BD
        case "buy":
            messageColor = GetColor(170, 204, 17, 255);
            shopTitle = GetSystemString(499);
            ItemList_ListCtrl.SetColumnString(2, 3590);
            ItemList_ListCtrl.SetColumnString(3, 3592);
            BenefitTitle1_Txt.SetText(GetSystemString(3594));
            BenefitTitle2_Txt.SetText(GetSystemString(3596));
            // End:0x1C0
            break;
        // End:0xFFFF
        default:
            break;
    }
    privateShopTitle_Txt.SetText(shopTitle);
    privateShopTitle_Txt.SetTextColor(messageColor);
    SignEditInput_Txt.SetTextColor(messageColor);
    SignEditInput_Txt.SetText(GetPrivateShopMessage(messagetype));
    handleGuideMessage();
    return;
}

function externalAddItem(ItemInfo addItemInfo)
{
    local int Len, i;

    // End:0xB3
    if(int(privateShopScript.m_type) == int(3))
    {
        // End:0xB3
        if(!IsStackableItem(addItemInfo.ConsumeType))
        {
            i = 0;
            J0x35:

            // End:0xB3 [Loop If]
            if(i < getItemInfoArray.Length)
            {
                // End:0xA9
                if(getItemInfoArray[i].Id.ClassID == addItemInfo.Id.ClassID)
                {
                    // End:0xA9
                    if(compareItem(getItemInfoArray[i], addItemInfo))
                    {
                        // End:0xA9
                        if(__NFUN_413__(addItemInfo.Price, getItemInfoArray[i].Price))
                        {
                            return;
                        }
                    }
                }
                i++;
                // [Loop Continue]
                goto J0x35;
            }
        }
    }
    Len = getItemInfoArray.Length + 1;
    getItemInfoArray.Length = Len;
    getItemInfoArray[Len - 1] = addItemInfo;
    getItemNumArray.Length = Len;
    getItemNumArray[Len - 1] = (0);
    // End:0x118
    if(Me.IsShowWindow())
    {
        updateList();
    }
    return;
}

function updateList()
{
    local int i;

    ItemList_ListCtrl.DeleteAllItem();
    // End:0x63
    if(getItemInfoArray.Length > 0)
    {
        i = 0;
        J0x22:

        // End:0x63 [Loop If]
        if(i < getItemInfoArray.Length)
        {
            // End:0x59
            if(getItemInfoArray[i].Id.ClassID != 57)
            {
                AddItem(i);
            }
            i++;
            // [Loop Continue]
            goto J0x22;
        }
    }
    setCurrentTotalPrice();
    return;
}

function setCurrentTotalPrice()
{
    local int Count, Index;
    local INT64 ItemNum, Price, currentPrice, totalprice;
    local LVDataRecord Record;

    currentPrice = (0);
    totalprice = (0);
    Count = 0;
    J0x19:

    // End:0x14D [Loop If]
    if(Count < ItemList_ListCtrl.GetRecordCount())
    {
        ItemList_ListCtrl.GetRec(Count, Record);
        Index = name(Record.nReserved3);
        Price = getItemInfoArray[Index].Price;
        ItemNum = Record.nReserved2;
        __NFUN_406__(currentPrice, __NFUN_401__(getItemNumArray[Index], Price));
        __NFUN_406__(totalprice, __NFUN_401__(ItemNum, Price));
        Benefit_Input1_Txt.SetText(ConvertNumToTextNoAdena((currentPrice)));
        Benefit_Input2_Txt.SetText(ConvertNumToTextNoAdena((__NFUN_405__(totalprice, currentPrice))));
        // End:0x11B
        if(Benefit_Input1_Txt.GetText() == "")
        {
            Benefit_Input1_Txt.SetText("0");
        }
        // End:0x143
        if(Benefit_Input2_Txt.GetText() == "")
        {
            Benefit_Input2_Txt.SetText("0");
        }
        Count++;
        // [Loop Continue]
        goto J0x19;
    }
    return;
}

function LVData makeItemTotalPrice(LVDataRecord Record, INT64 ItemNum)
{
    local INT64 Price, totalprice;
    local string costString;

    Price = getItemInfoArray[name(Record.nReserved3)].Price;
    totalprice = __NFUN_401__(Price, ItemNum);
    costString = MakeCostString((totalprice));
    Record.LVDataList[3].bUseTextColor = true;
    // End:0x91
    if(__NFUN_412__(ItemNum, Record.nReserved2))
    {
        Record.LVDataList[3].TextColor = GetColor(120, 120, 120, 255);        
    }
    else
    {
        Record.LVDataList[3].TextColor = GetNumericColor(costString);
    }
    Record.LVDataList[3].szData = ConvertNumToTextNoAdena((totalprice));
    return Record.LVDataList[3];
    return;
}

function LVData makeItemPriceRecord(LVDataRecord Record, INT64 ItemNum)
{
    local INT64 Price, remainingItemNum, remainingItemPrice;
    local string remainingString;

    // End:0x70
    if(__NFUN_412__(ItemNum, Record.nReserved2))
    {
        Record.LVDataList[2].bUseTextColor = true;
        Record.LVDataList[2].TextColor = GetColor(120, 120, 120, 255);
        Record.LVDataList[2].AttrColor = Record.LVDataList[2].TextColor;
    }
    // End:0x126
    if(Record.LVDataList[2].hasIcon)
    {
        Price = getItemInfoArray[name(Record.nReserved3)].Price;
        remainingItemNum = __NFUN_405__(Record.nReserved2, ItemNum);
        remainingItemPrice = __NFUN_401__(remainingItemNum, Price);
        // End:0xE8
        if(__NFUN_412__(remainingItemNum, (0)))
        {
            remainingString = "0";            
        }
        else
        {
            remainingString = ConvertNumToTextNoAdena((remainingItemPrice));
        }
        Record.LVDataList[2].AttrStat[0] = MakeFullSystemMsg(GetSystemMessage(3657), remainingString);
    }
    return Record.LVDataList[2];
    return;
}

function LVData makeItemNumRecord(LVDataRecord Record, INT64 ItemNum)
{
    local string itemNumEasyRead;

    // End:0x27
    if(__NFUN_409__(Record.nReserved2, (9999)))
    {
        itemNumEasyRead = "9999+";        
    }
    else
    {
        itemNumEasyRead = (Record.nReserved2);
    }
    // End:0x5E
    if(__NFUN_409__(ItemNum, Record.nReserved2))
    {
        ItemNum = Record.nReserved2;
    }
    Record.LVDataList[1].szData = ((__NFUN_405__(Record.nReserved2, ItemNum)) $ "/") $ itemNumEasyRead;
    // End:0x14F
    if(__NFUN_412__(ItemNum, Record.nReserved2))
    {
        Record.LVDataList[1].bUseTextColor = true;
        Record.LVDataList[1].TextColor = GetColor(120, 120, 120, 255);
        Record.LVDataList[1].AttrColor = Record.LVDataList[1].TextColor;
        // End:0x12D
        if(messagetype == "buy")
        {
            Record.LVDataList[1].AttrStat[0] = GetSystemString(3621);            
        }
        else
        {
            Record.LVDataList[1].AttrStat[0] = GetSystemString(3616);
        }        
    }
    else
    {
        // End:0x18E
        if(messagetype == "buy")
        {
            Record.LVDataList[1].AttrStat[0] = (GetSystemString(1434) $ ":") $ (ItemNum);            
        }
        else
        {
            Record.LVDataList[1].AttrStat[0] = (GetSystemString(1157) $ ":") $ (ItemNum);
        }
    }
    return Record.LVDataList[1];
    return;
}

function LVData makeItemNameRecord(LVDataRecord Record, INT64 ItemNum)
{
    // End:0xF4
    if(__NFUN_412__(ItemNum, Record.nReserved2))
    {
        Record.LVDataList[0].bUseTextColor = true;
        Record.LVDataList[0].TextColor = GetColor(120, 120, 120, 255);
        Record.LVDataList[0].iconPanelName = "L2UI_CT1.Windows.WindowDisable_BG";
        Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
        Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
        Record.LVDataList[0].panelWidth = 32;
        Record.LVDataList[0].panelHeight = 32;
        Record.LVDataList[0].panelUL = 8;
        Record.LVDataList[0].panelVL = 8;
    }
    return Record.LVDataList[0];
    return;
}

function LVDataRecord makeRecord(int Index)
{
    local LVDataRecord Record;
    local string param, fullNameString, costString;
    local ItemInfo Info;

    Info = getItemInfoArray[Index];
    fullNameString = GetItemNameAll(Info);
    ItemInfoToParam(Info, param);
    Record.szReserved = param;
    Record.nReserved1 = (Info.Id.ServerID);
    Record.nReserved2 = Info.ItemNum;
    Record.nReserved3 = (Index);
    Record.LVDataList.Length = 4;
    Record.LVDataList[0].szData = fullNameString;
    Record.LVDataList[0].hasIcon = true;
    Record.LVDataList[0].nTextureWidth = 32;
    Record.LVDataList[0].nTextureHeight = 32;
    Record.LVDataList[0].nTextureU = 32;
    Record.LVDataList[0].nTextureV = 32;
    Record.LVDataList[0].szTexture = Info.IconName;
    Record.LVDataList[0].IconPosX = 10;
    Record.LVDataList[0].FirstLineOffsetX = 6;
    Record.LVDataList[0].HiddenStringForSorting = fullNameString;
    Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
    Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
    Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
    Record.LVDataList[0].backTexWidth = 36;
    Record.LVDataList[0].backTexHeight = 36;
    Record.LVDataList[0].backTexUL = 36;
    Record.LVDataList[0].backTexVL = 36;
    Record.LVDataList[0].iconPanelName = Info.IconPanel;
    Record.LVDataList[0].panelOffsetXFromIconPosX = 0;
    Record.LVDataList[0].panelOffsetYFromIconPosY = 0;
    Record.LVDataList[0].panelWidth = 32;
    Record.LVDataList[0].panelHeight = 32;
    Record.LVDataList[0].panelUL = 32;
    Record.LVDataList[0].panelVL = 32;
    Record.LVDataList[1].hasIcon = true;
    Record.LVDataList[1].AttrColor = GetColor(170, 170, 170, 255);
    Record.LVDataList[1].textAlignment = 2;
    Record.LVDataList[1] = makeItemNumRecord(Record, getItemNumArray[Index]);
    costString = MakeCostString((Info.Price));
    Record.LVDataList[2].szData = ConvertNumToTextNoAdena((Info.Price));
    Record.LVDataList[2].bUseTextColor = true;
    Record.LVDataList[2].TextColor = GetNumericColor(costString);
    Record.LVDataList[2].textAlignment = 3;
    Record.LVDataList[2].HiddenStringForSorting = util.makeZeroString(20, Info.Price);
    // End:0x474
    if(IsStackableItem(Info.ConsumeType))
    {
        Record.LVDataList[2].hasIcon = true;
        Record.LVDataList[2].AttrColor = GetColor(170, 170, 170, 255);
        Record.LVDataList[2].AttrStat[0] = MakeFullSystemMsg(GetSystemMessage(3657), ConvertNumToTextNoAdena((__NFUN_401__(Info.Price, Info.ItemNum))));
        Record.LVDataList[2].textAlignment = 3;
    }
    costString = MakeCostString((__NFUN_401__(Info.Price, getItemNumArray[Index])));
    Record.LVDataList[3].bUseTextColor = true;
    Record.LVDataList[3].TextColor = GetNumericColor(costString);
    Record.LVDataList[3].szData = costString;
    Record.LVDataList[3].textAlignment = 3;
    return Record;
    return;
}

function AddItem(int Index)
{
    ItemList_ListCtrl.InsertRecord(makeRecord(Index));
    return;
}

function bool checkShoppingEnd()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x44 [Loop If]
    if(i < getItemInfoArray.Length)
    {
        // End:0x3A
        if(__NFUN_413__(getItemNumArray[i], getItemInfoArray[i].ItemNum))
        {
            return false;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return true;
    return;
}

function Onhistory_BtnClick()
{
    // End:0x52
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWndHistory"))
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PrivateShopWndHistory");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PrivateShopWndHistory");
    }
    return;
}

function handleQuit()
{
    // End:0x1D
    if(!checkShoppingEnd())
    {
        privateShopScript.contextMenuQuit();        
    }
    else
    {
        // End:0x36
        if(!IsPlayerStand())
        {
            ExecuteCommand("/stand");
        }
    }
    Me.HideWindow();
    return;
}

function bool compareItem(ItemInfo info1, ItemInfo info2)
{
    // End:0x176
    if((((((((((((((info1.Enchanted != info2.Enchanted) || info1.Damaged != info2.Damaged) || info1.RefineryOp1 != info2.RefineryOp1) || info1.RefineryOp2 != info2.RefineryOp2) || info1.LookChangeItemID != info2.LookChangeItemID) || info1.AttackAttributeType != info2.AttackAttributeType) || info1.AttackAttributeValue != info2.AttackAttributeValue) || info1.DefenseAttributeValueFire != info2.DefenseAttributeValueFire) || info1.DefenseAttributeValueWater != info2.DefenseAttributeValueWater) || info1.DefenseAttributeValueWind != info2.DefenseAttributeValueWind) || info1.DefenseAttributeValueEarth != info2.DefenseAttributeValueEarth) || info1.DefenseAttributeValueHoly != info2.DefenseAttributeValueHoly) || info1.DefenseAttributeValueUnholy != info2.DefenseAttributeValueUnholy) || !compareParamEnSoul(info1, info2))
    {
        return false;
    }
    return true;
    return;
}

function bool compareParamEnSoul(ItemInfo info1, ItemInfo info2)
{
    local int i, N, Cnt;

    i = 1;
    J0x07:

    // End:0xCD [Loop If]
    if(i < 3)
    {
        Cnt = info1.EnsoulOption[i - 1].OptionArray.Length;
        // End:0x57
        if(Cnt != info2.EnsoulOption[i - 1].OptionArray.Length)
        {
            return false;
        }
        N = 1;
        J0x5E:

        // End:0xC3 [Loop If]
        if(N < (1 + Cnt))
        {
            // End:0xB9
            if(info1.EnsoulOption[i - 1].OptionArray[N - 1] != info2.EnsoulOption[i - 1].OptionArray[N - 1])
            {
                return false;
            }
            N++;
            // [Loop Continue]
            goto J0x5E;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return true;
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x41
    if(SignEditInput_Edit.IsFocused())
    {
        // End:0x2B
        if(int(nKey) == int(13))
        {
            togglePrivateShopEditor();            
        }
        else
        {
            // End:0x41
            if(int(nKey) == int(27))
            {
                hidePrivateShopwEditor();
            }
        }
    }
    return;
}
