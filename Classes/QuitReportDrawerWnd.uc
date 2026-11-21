class QuitReportDrawerWnd extends UICommonAPI;

var WindowHandle Me;
var ListCtrlHandle ItemListCtrl;
var ButtonHandle CloseBtn;
var int itemIndex;
var array<ItemInfo> getItemInfoArray;
var L2Util util;
var InventoryWnd inventoryWndScript;
var QuitReportWnd QuitReportWndScript;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function OnShow()
{
    updateList();
    return;
}

function OnHide()
{
    return;
}

function Initialize()
{
    Me = GetWindowHandle("QuitReportDrawerWnd");
    ItemListCtrl = GetListCtrlHandle("QuitReportDrawerWnd.InstanceDungeon_ListCtrl");
    CloseBtn = GetButtonHandle("QuitReportDrawerWnd.EnsoulInfoBtn");
    util = L2Util(GetScript("L2Util"));
    inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
    QuitReportWndScript = QuitReportWnd(GetScript("QuitReportWnd"));
    ItemListCtrl.SetSelectedSelTooltip(false);
    ItemListCtrl.SetAppearTooltipAtMouseX(true);
    Init();
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x22
        case "EnsoulInfoBtn":
            OnEnsoulInfoBtnClick();
            // End:0x25
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function externalAddItem(ItemInfo addItemInfo)
{
    // End:0x21
    if(IsStackableItem(addItemInfo.ConsumeType))
    {
        sumStackableItem(addItemInfo);        
    }
    else
    {
        getItemInfoArray.Length = getItemInfoArray.Length + 1;
        getItemInfoArray[getItemInfoArray.Length - 1] = addItemInfo;
    }
    // End:0x5E
    if(Me.IsShowWindow())
    {
        updateList();
    }
    return;
}

function int getTotalItemCount()
{
    local int adenItem, itemLen, i;

    adenItem = 0;
    itemLen = getItemInfoArray.Length;
    i = 0;
    J0x1A:

    // End:0x69 [Loop If]
    if(i < itemLen)
    {
        // End:0x5F
        if(getItemInfoArray.Length > 0)
        {
            // End:0x5F
            if(getItemInfoArray[i].Id.ClassID == 57)
            {
                adenItem = -1;
                // [Explicit Break]
                goto J0x69;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x1A;
    }
    J0x69:

    return getItemInfoArray.Length + adenItem;
    return;
}

function Init()
{
    // End:0x19
    if(getItemInfoArray.Length > 0)
    {
        getItemInfoArray.Remove(0, getItemInfoArray.Length);
    }
    itemIndex = 99999;
    ItemListCtrl.DeleteAllItem();
    return;
}

function sumStackableItem(ItemInfo addItemInfo)
{
    local int i;
    local ItemInfo beforeItemInfo;
    local bool bAdd;

    i = 0;
    J0x07:

    // End:0xF4 [Loop If]
    if(i < getItemInfoArray.Length)
    {
        // End:0xEA
        if(getItemInfoArray[i].Id.ClassID == addItemInfo.Id.ClassID)
        {
            inventoryWndScript.getInventoryItemInfo(addItemInfo.Id, beforeItemInfo, true);
            // End:0xDF
            if(__NFUN_408__(beforeItemInfo.ItemNum, addItemInfo.ItemNum))
            {
                addItemInfo.ItemNum = __NFUN_404__(getItemInfoArray[i].ItemNum, __NFUN_405__(addItemInfo.ItemNum, beforeItemInfo.ItemNum));
                getItemInfoArray.Remove(i, 1);
                getItemInfoArray.Length = getItemInfoArray.Length + 1;
                getItemInfoArray[getItemInfoArray.Length - 1] = addItemInfo;
            }
            bAdd = true;
            // [Explicit Break]
            goto J0xF4;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0xF4:

    // End:0x1C4
    if(bAdd == false)
    {
        inventoryWndScript.getInventoryItemInfo(addItemInfo.Id, beforeItemInfo, true);
        // End:0x1C4
        if(__NFUN_408__(beforeItemInfo.ItemNum, addItemInfo.ItemNum))
        {
            // End:0x17D
            if(getItemInfoArray.Length > 0)
            {
                addItemInfo.ItemNum = __NFUN_404__(getItemInfoArray[i].ItemNum, __NFUN_405__(addItemInfo.ItemNum, beforeItemInfo.ItemNum));                
            }
            else
            {
                addItemInfo.ItemNum = __NFUN_405__(addItemInfo.ItemNum, beforeItemInfo.ItemNum);
            }
            getItemInfoArray.Length = getItemInfoArray.Length + 1;
            getItemInfoArray[getItemInfoArray.Length - 1] = addItemInfo;
        }
    }
    return;
}

function updateList()
{
    local int i;

    ItemListCtrl.DeleteAllItem();
    // End:0x70
    if(getItemInfoArray.Length > 0)
    {
        i = getItemInfoArray.Length - 1;
        J0x2A:

        // End:0x70 [Loop If]
        if(i > -1)
        {
            // End:0x66
            if(getItemInfoArray[i].Id.ClassID != 57)
            {
                AddItem(getItemInfoArray[i]);
            }
            i--;
            // [Loop Continue]
            goto J0x2A;
        }
    }
    QuitReportWndScript.UpdateUserInfoHandler();
    return;
}

function AddItem(ItemInfo Info)
{
    local LVDataRecord Record;
    local string param, AdditionalName, fullNameString, itemNumEasyRead;
    local int itemNameClass;

    itemIndex--;
    fullNameString = Info.Name;
    itemNameClass = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(Info.Id);
    AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(Info.Id);
    // End:0x7F
    if(itemNameClass == 0)
    {
        fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);        
    }
    else
    {
        // End:0xA7
        if(itemNameClass == 2)
        {
            fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
        }
    }
    // End:0xD0
    if(Len(AdditionalName) > 0)
    {
        fullNameString = ((fullNameString $ "(") $ AdditionalName) $ ")";
    }
    ItemInfoToParam(Info, param);
    Record.szReserved = param;
    Record.nReserved1 = (Info.Id.ClassID);
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
    Record.LVDataList[0].HiddenStringForSorting = string(itemIndex);
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
    // End:0x3E3
    if(IsStackableItem(Info.ConsumeType))
    {
        // End:0x376
        if(__NFUN_409__(Info.ItemNum, (9999)))
        {
            itemNumEasyRead = "9999+";            
        }
        else
        {
            itemNumEasyRead = (Info.ItemNum);
        }
        Record.LVDataList[1].szData = itemNumEasyRead;
        Record.LVDataList[1].textAlignment = 2;
        Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(13, Info.ItemNum);        
    }
    else
    {
        Record.LVDataList[1].HiddenStringForSorting = util.makeZeroString(13, Info.ItemNum);
    }
    ItemListCtrl.InsertRecord(Record);
    return;
}

function OnEnsoulInfoBtnClick()
{
    QuitReportWndScript.setDrawerButtonState(true);
    Me.HideWindow();
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
