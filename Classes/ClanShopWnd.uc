class ClanShopWnd extends UICommonAPI;

const DIALOG_ASK_PRICE = 10111;
const TIMER_CLICK = 99902;
const TIMER_DELAYC = 3000;

struct ClanItemInfo
{
    var LVDataRecord Record;
    var int sort0;
    var int sort1;
};

var WindowHandle Me;
var TextureHandle EditBtnImg_texture;
var ButtonHandle ClanShopEdit_Button;
var WindowHandle ClanShopListWnd;
var CheckBoxHandle LockVeiw_checkBox;
var TextureHandle ClanShopListListDeco_texture;
var ListCtrlHandle ClanShop_ListCtrl;
var TextureHandle ClanShopListWndBG_Texture;
var TextureHandle ClanShopListBG_Texture;
var WindowHandle ClanShopItemInfoWnd;
var TextBoxHandle ItemInfo_Text;
var TextBoxHandle NeedItem_Text;
var TextBoxHandle ExchangeNum_Text;
var TextBoxHandle ClanItemName_text;
var TextBoxHandle ClanItemDescription_text;
var WindowHandle NeededItem_Wnd;
var TextureHandle NeededItem_SlotBg1_Texture;
var TextureHandle NeededItem_SlotBg2_Texture;
var ItemWindowHandle NeededItem_Item1_ItemWnd;
var ItemWindowHandle NeededItem_Item2_ItemWnd;
var TextBoxHandle NeededItem_Item1Title_text;
var TextBoxHandle NeededItem_Item1Num_text;
var TextBoxHandle NeededItem_Item1MyNum_text;
var TextBoxHandle NeededItem_Item2Title_text;
var TextBoxHandle NeededItem_Item2Num_text;
var TextBoxHandle NeededItem_Item2MyNum_text;
var EditBoxHandle ItemCount_EditBox;
var TextureHandle ItemInfoBg_Texture;
var TextureHandle NeededItemBg_Texture;
var TextureHandle ExchangeItemBg_Texture;
var TextureHandle ExchangeItemBg_Divider1;
var TextureHandle ExchangeItemBg_Divider2;
var ButtonHandle Clear_Button;
var ButtonHandle ExChange_Button;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var WindowHandle DisableWnd;
var WindowHandle DescriptionMsgWnd;
var TextBoxHandle DescriptionMsg_Text;
var ButtonHandle Refresh_Button;
var ButtonHandle Close_Button;
var TextBoxHandle ItemNum_TextBox;
var WindowHandle ClanShopConfirm_ResultWnd;
var WindowHandle ClanShopSuccess_ResultWnd;
var WindowHandle ClanShopFails_ResultWnd;
var int listTotalCount;
var int endCount;
var array<ClanItemInfo> itemListArray;
var L2Util util;
var ItemInfo SelectItemInfo;
//var delegate<OnSortCompare> __OnSortCompare__Delegate;

function OnRegisterEvent()
{
    RegisterEvent(10730);
    RegisterEvent(10810);
    RegisterEvent(10820);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function OnLoad()
{
    Initialize();
    load();
    SetClosingOnESC();
    return;
}

function Initialize()
{
    local ButtonHandle OK_Button;

    OK_Button = GetButtonHandle("ClanShopWnd.ClanShopConfirm_ResultWnd.OK_Button");
    OK_Button.SetNameText(GetSystemString(2517));
    Me = GetWindowHandle("ClanShopWnd");
    EditBtnImg_texture = GetTextureHandle("ClanShopWnd.EditBtnImg_texture");
    ClanShopEdit_Button = GetButtonHandle("ClanShopWnd.ClanShopEdit_Button");
    ClanShopListWnd = GetWindowHandle("ClanShopWnd.ClanShopListWnd");
    LockVeiw_checkBox = GetCheckBoxHandle("ClanShopWnd.ClanShopListWnd.LockVeiw_checkBox");
    ClanShopListListDeco_texture = GetTextureHandle("ClanShopWnd.ClanShopListWnd.ClanShopListListDeco_texture");
    ClanShop_ListCtrl = GetListCtrlHandle("ClanShopWnd.ClanShopListWnd.ClanShop_ListCtrl");
    ClanShopListWndBG_Texture = GetTextureHandle("ClanShopWnd.ClanShopListWnd.ClanShopListWndBG_Texture");
    ClanShopListBG_Texture = GetTextureHandle("ClanShopWnd.ClanShopListWnd.ClanShopListBG_Texture");
    ClanShopItemInfoWnd = GetWindowHandle("ClanShopWnd.ClanShopItemInfoWnd");
    ItemInfo_Text = GetTextBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.ItemInfo_Text");
    NeedItem_Text = GetTextBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.NeedItem_Text");
    ExchangeNum_Text = GetTextBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.ExchangeNum_Text");
    ClanItemName_text = GetTextBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.ClanItemName_text");
    ClanItemDescription_text = GetTextBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.ClanItemDescription_text");
    NeededItem_Wnd = GetWindowHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd");
    NeededItem_SlotBg1_Texture = GetTextureHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_SlotBg1_Texture");
    NeededItem_SlotBg2_Texture = GetTextureHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_SlotBg2_Texture");
    NeededItem_Item1_ItemWnd = GetItemWindowHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1_ItemWnd");
    NeededItem_Item2_ItemWnd = GetItemWindowHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2_ItemWnd");
    NeededItem_Item1Title_text = GetTextBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1Title_text");
    NeededItem_Item1Num_text = GetTextBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1Num_text");
    NeededItem_Item1MyNum_text = GetTextBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1MyNum_text");
    NeededItem_Item2Title_text = GetTextBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2Title_text");
    NeededItem_Item2Num_text = GetTextBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2Num_text");
    NeededItem_Item2MyNum_text = GetTextBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2MyNum_text");
    ItemCount_EditBox = GetEditBoxHandle("ClanShopWnd.ClanShopItemInfoWnd.ItemCount_EditBox");
    ItemInfoBg_Texture = GetTextureHandle("ClanShopWnd.ClanShopItemInfoWnd.ItemInfoBg_Texture");
    NeededItemBg_Texture = GetTextureHandle("ClanShopWnd.ClanShopItemInfoWnd.NeededItemBg_Texture");
    ExchangeItemBg_Texture = GetTextureHandle("ClanShopWnd.ClanShopItemInfoWnd.ExchangeItemBg_Texture");
    ExchangeItemBg_Divider1 = GetTextureHandle("ClanShopWnd.ClanShopItemInfoWnd.ExchangeItemBg_Divider1");
    ExchangeItemBg_Divider2 = GetTextureHandle("ClanShopWnd.ClanShopItemInfoWnd.ExchangeItemBg_Divider2");
    Clear_Button = GetButtonHandle("ClanShopWnd.ClanShopItemInfoWnd.Clear_Button");
    ExChange_Button = GetButtonHandle("ClanShopWnd.ClanShopItemInfoWnd.ExChange_Button");
    MultiSell_Up_Button = GetButtonHandle("ClanShopWnd.ClanShopItemInfoWnd.MultiSell_Up_Button");
    MultiSell_Down_Button = GetButtonHandle("ClanShopWnd.ClanShopItemInfoWnd.MultiSell_Down_Button");
    MultiSell_Input_Button = GetButtonHandle("ClanShopWnd.ClanShopItemInfoWnd.MultiSell_Input_Button");
    DisableWnd = GetWindowHandle("ClanShopWnd.DisableWnd");
    DescriptionMsgWnd = GetWindowHandle("ClanShopWnd.DescriptionMsgWnd");
    DescriptionMsg_Text = GetTextBoxHandle("ClanShopWnd.DescriptionMsgWnd.DescriptionMsg_Text");
    Refresh_Button = GetButtonHandle("ClanShopWnd.Refresh_Button");
    Close_Button = GetButtonHandle("ClanShopWnd.Close_Button");
    ClanShopConfirm_ResultWnd = GetWindowHandle("ClanShopWnd.ClanShopConfirm_ResultWnd");
    ItemNum_TextBox = GetTextBoxHandle("ClanShopWnd.ClanShopConfirm_ResultWnd.ItemNum_TextBox");
    ClanShopSuccess_ResultWnd = GetWindowHandle("ClanShopWnd.ClanShopSuccess_ResultWnd");
    ClanShopFails_ResultWnd = GetWindowHandle("ClanShopWnd.ClanShopFails_ResultWnd");
    util = L2Util(GetScript("L2Util"));
    ClanShop_ListCtrl.SetSelectedSelTooltip(false);
    ClanShop_ListCtrl.SetAppearTooltipAtMouseX(true);
    return;
}

function load()
{
    return;
}

function OnShow()
{
    RequestPledgeItemList();
    ItemCount_EditBox.SetString("1");
    return;
}

function OnHide()
{
    ClearAll();
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int nResult;

    Debug("debuftest OnEvent------>>>>> " @ string(Event_ID));
    // End:0x5E
    if(Event_ID == 10730)
    {
        ClearAll();
        ParseInt(param, "nCount", listTotalCount);        
    }
    else
    {
        // End:0x7B
        if(Event_ID == 10810)
        {
            ItemListInfo(param);            
        }
        else
        {
            // End:0xEF
            if(Event_ID == 10820)
            {
                Debug(("debuftest OnEvent " @ string(Event_ID)) @ param);
                ParseInt(param, "nResult", nResult);
                // End:0xE1
                if(nResult == 0)
                {
                    SetSuccessWnd();                    
                }
                else
                {
                    SetFailWnd(nResult);
                }                
            }
            else
            {
                // End:0x108
                if(Event_ID == 1710)
                {
                    HandleDialogOK(true);                    
                }
                else
                {
                    // End:0x11E
                    if(Event_ID == 1720)
                    {
                        HandleDialogOK(false);
                    }
                }
            }
        }
    }
    return;
}

function SetSuccessWnd()
{
    local ItemWindowHandle Result_ItemWnd;
    local TextBoxHandle ItemName_TextBox, Discription_TextBox;

    Result_ItemWnd = GetItemWindowHandle("ClanShopWnd.ClanShopSuccess_ResultWnd.Result_ItemWnd");
    ItemName_TextBox = GetTextBoxHandle("ClanShopWnd.ClanShopSuccess_ResultWnd.ItemName_TextBox");
    Discription_TextBox = GetTextBoxHandle("ClanShopWnd.ClanShopSuccess_ResultWnd.Discription_TextBox");
    Result_ItemWnd.Clear();
    Result_ItemWnd.AddItem(SelectItemInfo);
    ItemName_TextBox.SetText(GetItemNameAll(SelectItemInfo));
    Discription_TextBox.SetText(GetSystemMessage(4570));
    ClanShopSuccess_ResultWnd.ShowWindow();
    return;
}

function SetFailWnd(int N)
{
    local TextBoxHandle Discription_TextBox;

    Discription_TextBox = GetTextBoxHandle("ClanShopWnd.ClanShopFails_ResultWnd.Discription_TextBox");
    // End:0x6E
    if(N == 2)
    {
        Discription_TextBox.SetText(GetSystemMessage(3721));        
    }
    else
    {
        // End:0xA8
        if((N == -2) || N == 3)
        {
            Discription_TextBox.SetText(GetSystemMessage(4692));            
        }
        else
        {
            // End:0xD1
            if(N == 4)
            {
                Discription_TextBox.SetText(GetSystemMessage(1285));                
            }
            else
            {
                Discription_TextBox.SetText(GetSystemMessage(4559));
            }
        }
    }
    ClanShopFails_ResultWnd.ShowWindow();
    return;
}

function ClearAll()
{
    endCount = 0;
    itemListArray.Remove(0, itemListArray.Length);
    ClanShop_ListCtrl.DeleteAllItem();
    ClanShopConfirm_ResultWnd.HideWindow();
    ClanShopSuccess_ResultWnd.HideWindow();
    ClanShopFails_ResultWnd.HideWindow();
    DisableWnd.HideWindow();
    ItemCount_EditBox.ShowWindow();
    return;
}

function ItemListInfo(string param)
{
    makeRecord(param);
    endCount++;
    // End:0x27
    if(endCount == listTotalCount)
    {
        ItemListInfoEnd();
    }
    return;
}

function ItemListInfoEnd()
{
    local int i, N;

    ClanShop_ListCtrl.DeleteAllItem();
    i = 0;
    J0x16:

    // End:0x99 [Loop If]
    if(i < itemListArray.Length)
    {
        // End:0x5A
        if(LockVeiw_checkBox.IsChecked())
        {
            ClanShop_ListCtrl.InsertRecord(itemListArray[i].Record);
            // [Explicit Continue]
            goto J0x8F;
        }
        // End:0x8F
        if(itemListArray[i].sort0 != 0)
        {
            ClanShop_ListCtrl.InsertRecord(itemListArray[i].Record);
        }
        J0x8F:

        i++;
        // [Loop Continue]
        goto J0x16;
    }
    N = findItemIndex(SelectItemInfo);
    // End:0xCD
    if(N > 0)
    {
        ClanShop_ListCtrl.SetSelectedIndex(N, true);        
    }
    else
    {
        ClanShop_ListCtrl.SetSelectedIndex(0, true);
    }
    OnClickListCtrlRecord("ClanShop_ListCtrl");
    return;
}

function int findItemIndex(ItemInfo Info)
{
    local int i, N;

    N = -1;
    i = 0;
    J0x12:

    // End:0x63 [Loop If]
    if(i < itemListArray.Length)
    {
        // End:0x59
        if(__NFUN_412__((Info.Id.ServerID), itemListArray[i].Record.nReserved1))
        {
            N = i;
        }
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    return N;
    return;
}

function makeRecord(string param)
{
    local LVDataRecord Record;
    local string fullNameString;
    local ItemInfo Info;
    local string MaxQuantity;
    local int RemainQuantity, RemainResetTime, Status, RemainActivateTime;

    ParseString(param, "MaxQuantity", MaxQuantity);
    ParseInt(param, "RemainQuantity", RemainQuantity);
    ParseInt(param, "RemainResetTime", RemainResetTime);
    ParseInt(param, "RemainActivateTime", RemainActivateTime);
    ParseInt(param, "Status", Status);
    ParamToItemInfo(param, Info);
    fullNameString = GetItemNameAll(Info);
    ItemInfoToParam(Info, param);
    Record.szReserved = param;
    Record.nReserved1 = (Info.Id.ServerID);
    Record.nReserved2 = Info.ItemNum;
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
    Record.LVDataList[0].HiddenStringForSorting = string(Status);
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
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[0].AttrIconTexArray.Length = 1;
    Record.LVDataList[0].AttrIconTexArray[0].X = 0;
    Record.LVDataList[0].AttrIconTexArray[0].Y = 2;
    Record.LVDataList[0].AttrIconTexArray[0].Width = 14;
    Record.LVDataList[0].AttrIconTexArray[0].Height = 14;
    Record.LVDataList[0].AttrIconTexArray[0].U = 0;
    Record.LVDataList[0].AttrIconTexArray[0].V = 0;
    Record.LVDataList[0].AttrIconTexArray[0].UL = 14;
    Record.LVDataList[0].AttrIconTexArray[0].VL = 14;
    Record.LVDataList[0].AttrIconTexArray[0].objTex = GetTexture("L2UI_CT1.SkillWnd.SkillWnd_DF_ListIcon_Use");
    // End:0x51B
    if(Status == 0)
    {
        Record.LVDataList[0].TextColor = util.DarkGray;
        Record.LVDataList[0].AttrColor = util.ColorGray;
        Record.LVDataList[0].AttrStat[0] = GetSystemMessage(4566);
        Record.LVDataList[0].foreTextureName = "L2UI_CT1.Icon.ItemLock";        
    }
    else
    {
        // End:0x588
        if(Status == 1)
        {
            Record.LVDataList[0].TextColor = util.DarkGray;
            Record.LVDataList[0].AttrColor = util.DRed;
            Record.LVDataList[0].AttrStat[0] = GetSystemMessage(4564);            
        }
        else
        {
            Record.LVDataList[0].TextColor = util.BWhite;
            Record.LVDataList[0].AttrColor = util.DRed;
            // End:0x615
            if(RemainActivateTime <= 0)
            {
                Record.LVDataList[0].AttrColor = GetColor(119, 255, 178, 255);
                Record.LVDataList[0].AttrStat[0] = GetSystemMessage(4565);                
            }
            else
            {
                Record.LVDataList[0].AttrColor = util.Yellow03;
                Record.LVDataList[0].AttrStat[0] = getTimeStringBySec(RemainActivateTime);
            }
        }
    }
    Record.LVDataList[1].hasIcon = true;
    Record.LVDataList[1].bUseTextColor = true;
    Record.LVDataList[1].TextColor = util.DarkGray;
    Record.LVDataList[1].AttrColor = util.DarkGray;
    // End:0x74C
    if(MaxQuantity == "0")
    {
        // End:0x715
        if(Status == 2)
        {
            Record.LVDataList[1].TextColor = GetColor(119, 255, 178, 255);
            Record.LVDataList[1].AttrColor = GetColor(211, 211, 211, 255);
        }
        Record.LVDataList[1].szData = GetSystemMessage(4565);
        Record.LVDataList[1].AttrStat[0] = "-";        
    }
    else
    {
        // End:0x798
        if(Status == 2)
        {
            Record.LVDataList[1].TextColor = GetColor(170, 153, 119, 255);
            Record.LVDataList[1].AttrColor = GetColor(211, 211, 211, 255);
        }
        Record.LVDataList[1].szData = (string(RemainQuantity) $ "/") $ MaxQuantity;
        Record.LVDataList[1].AttrStat[0] = getTimeStringBySec2(RemainResetTime);
    }
    Record.LVDataList[1].AttrIconTexArray.Length = 1;
    Record.LVDataList[1].AttrIconTexArray[0].X = 0;
    Record.LVDataList[1].AttrIconTexArray[0].Y = 2;
    Record.LVDataList[1].AttrIconTexArray[0].Width = 14;
    Record.LVDataList[1].AttrIconTexArray[0].Height = 14;
    Record.LVDataList[1].AttrIconTexArray[0].U = 0;
    Record.LVDataList[1].AttrIconTexArray[0].V = 0;
    Record.LVDataList[1].AttrIconTexArray[0].UL = 14;
    Record.LVDataList[1].AttrIconTexArray[0].VL = 14;
    Record.LVDataList[1].AttrIconTexArray[0].objTex = GetTexture("L2UI_CT1.SkillWnd.SkillWnd_DF_ListIcon_Reuse");
    itemListArray.Insert(itemListArray.Length, 1);
    itemListArray[itemListArray.Length - 1].Record = Record;
    itemListArray[itemListArray.Length - 1].sort0 = Status;
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    local string param, ActivatePledgeLevel;
    local ItemInfo Info;
    local int SellNameValue, ActivateNameValue, ActivateMasteryID;
    local UserInfo infoPlayer;
    local INT64 ActivatePrice, SellPrice;
    local int Status;

    GetPlayerInfo(infoPlayer);
    param = getParam();
    Debug(param);
    ParamToItemInfo(param, Info);
    SelectItemInfo = Info;
    ParseInt(param, "SellNameValue", SellNameValue);
    ParseInt(param, "ActivateMasteryID", ActivateMasteryID);
    ParseInt(param, "ActivateNameValue", ActivateNameValue);
    ParseINT64(param, "ActivatePrice", ActivatePrice);
    ParseINT64(param, "SellPrice", SellPrice);
    ParseInt(param, "Status", Status);
    ParseString(param, "ActivatePledgeLevel", ActivatePledgeLevel);
    Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.Clear("ClanShopWnd.multiSellItemInfo");
    // End:0x187
    if(param != "")
    {
        Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("ClanShopWnd.multiSellItemInfo", 0, Info);
    }
    NeededItem_Item1Num_text.SetText("x" @ MakeCostString(string(SellNameValue)));
    NeededItem_Item1MyNum_text.SetTextColor(util.BLUE01);
    NeededItem_Item1MyNum_text.SetText(("(" $ MakeCostString(string(infoPlayer.PvPPoint))) $ ")");
    NeededItem_Item2Num_text.SetText("x" @ MakeCostString((SellPrice)));
    NeededItem_Item2MyNum_text.SetTextColor(util.BLUE01);
    NeededItem_Item2MyNum_text.SetText(("(" $ MakeCostString(GetAdenaStr())) $ ")");
    setEditStateItemCount();
    itemCountTextEditEnable(IsStackableItem(Info.ConsumeType));
    updateListData();
    return;
}

function updateListData()
{
    local CustomTooltip t;
    local string param;
    local int Status, SellNameValue;
    local INT64 SellPrice;
    local UserInfo infoPlayer;
    local bool bLine;

    bLine = false;
    GetPlayerInfo(infoPlayer);
    param = getParam();
    ParseInt(param, "SellNameValue", SellNameValue);
    ParseINT64(param, "SellPrice", SellPrice);
    ParseInt(param, "Status", Status);
    util.setCustomTooltip(t);
    util.ToopTipMinWidth(10);
    // End:0xB4
    if(Status == 2)
    {
        ExChange_Button.EnableWindow();        
    }
    else
    {
        // End:0x107
        if(Status == 1)
        {
            util.ToopTipInsertText(GetSystemString(3753), true, false, util.4);
            bLine = true;
            ExChange_Button.DisableWindow();
            itemCountTextEditEnable(false);            
        }
        else
        {
            // End:0x157
            if(Status == 0)
            {
                util.ToopTipInsertText(GetSystemString(3754), true, false, util.4);
                bLine = true;
                ExChange_Button.DisableWindow();
                itemCountTextEditEnable(false);
            }
        }
    }
    // End:0x261
    if((SellNameValue * int(ItemCount_EditBox.GetString())) > infoPlayer.PvPPoint)
    {
        NeededItem_Item1MyNum_text.SetTextColor(util.DRed);
        // End:0x1DD
        if(bLine)
        {
            util.TooltipInsertItemBlank(2);
            util.TooltipInsertItemLine();
            util.TooltipInsertItemBlank(4);
            bLine = false;
        }
        util.ToopTipInsertText(GetSystemString(3672) $ " ", true, true, util.1);
        util.ToopTipInsertText(MakeCostString(string((SellNameValue * int(ItemCount_EditBox.GetString())) - infoPlayer.PvPPoint)) @ GetSystemString(3752), true, false, util.5);        
    }
    else
    {
        NeededItem_Item1MyNum_text.SetTextColor(util.BLUE01);
    }
    // End:0x388
    if(__NFUN_409__(__NFUN_401__(SellPrice, (int(ItemCount_EditBox.GetString()))), GetAdena()))
    {
        NeededItem_Item2MyNum_text.SetTextColor(util.DRed);
        // End:0x304
        if(bLine)
        {
            util.TooltipInsertItemBlank(2);
            util.TooltipInsertItemLine();
            util.TooltipInsertItemBlank(4);
            bLine = false;
        }
        util.ToopTipInsertText(GetSystemString(469) $ " ", true, true, util.1);
        util.ToopTipInsertText(MakeCostString((__NFUN_405__(__NFUN_401__(SellPrice, (int(ItemCount_EditBox.GetString()))), GetAdena()))) @ GetSystemString(3752), true, false, util.5);        
    }
    else
    {
        NeededItem_Item2MyNum_text.SetTextColor(util.BLUE01);
    }
    ExChange_Button.SetTooltipCustomType(util.getCustomTooltip());
    return;
}

function itemCountTextEditEnable(bool bEnable)
{
    // End:0x57
    if(bEnable)
    {
        ItemCount_EditBox.EnableWindow();
        MultiSell_Up_Button.EnableWindow();
        MultiSell_Down_Button.EnableWindow();
        MultiSell_Input_Button.EnableWindow();
        Clear_Button.EnableWindow();        
    }
    else
    {
        ItemCount_EditBox.DisableWindow();
        MultiSell_Up_Button.DisableWindow();
        MultiSell_Down_Button.DisableWindow();
        MultiSell_Input_Button.DisableWindow();
        Clear_Button.DisableWindow();
    }
    return;
}

function setEditStateItemCount()
{
    ItemCount_EditBox.SetString("1");
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x26
        case "LockVeiw_checkBox":
            ItemListInfoEnd();
            // End:0x29
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    Debug("name--->" $ Name);
    switch(Name)
    {
        // End:0x3B
        case "ExChange_Button":
            OnExChange_ButtonClick();
            // End:0x190
            break;
        // End:0x57
        case "Refresh_Button":
            OnRefresh_ButtonClick();
            // End:0x190
            break;
        // End:0x71
        case "Close_Button":
            OnClose_ButtonClick();
            // End:0x190
            break;
        // End:0x88
        case "OK_Button":
            OnOK_ButtonClick();
            // End:0x190
            break;
        // End:0xA3
        case "Cancel_Button":
            OnCancel_ButtonClick();
            // End:0x190
            break;
        // End:0xBF
        case "Success_Button":
            OnSuccess_ButtonClick();
            // End:0x190
            break;
        // End:0xD8
        case "Fail_Button":
            OnFail_ButtonClick();
            // End:0x190
            break;
        // End:0xF9
        case "ClanShopEdit_Button":
            OnClanShopEdit_ButtonClick();
            // End:0x190
            break;
        // End:0x11D
        case "MultiSell_Input_Button":
            OnPriceEditBtnHandler();
            // End:0x190
            break;
        // End:0x13E
        case "MultiSell_Up_Button":
            OnMultiSell_Up_ButtonClick();
            // End:0x190
            break;
        // End:0x161
        case "MultiSell_Down_Button":
            OnMultiSell_Down_ButtonClick();
            // End:0x190
            break;
        // End:0x18D
        case "Clear_Button":
            ItemCount_EditBox.SetString("1");
            updateCost();
            // End:0x190
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnExChange_ButtonClick()
{
    DisableWnd.ShowWindow();
    DisableWnd.SetFocus();
    ClanShopConfirm_ResultWnd.ShowWindow();
    setResultWnd();
    ItemCount_EditBox.HideWindow();
    return;
}

function setResultWnd()
{
    local string param, fullNameString;
    local ItemInfo Info;
    local ItemWindowHandle Result_ItemWnd;
    local TextBoxHandle ItemName_TextBox, FameNum_TextBox, AdenaNum_TextBox, Discription_TextBox, FameTitle_TextBox;

    local int SellNameValue;
    local INT64 SellPrice;

    param = getParam();
    ParamToItemInfo(param, Info);
    ParseInt(param, "SellNameValue", SellNameValue);
    ParseINT64(param, "SellPrice", SellPrice);
    fullNameString = GetItemNameAll(Info);
    Result_ItemWnd = GetItemWindowHandle("ClanShopWnd.ClanShopConfirm_ResultWnd.Result_ItemWnd");
    ItemName_TextBox = GetTextBoxHandle("ClanShopWnd.ClanShopConfirm_ResultWnd.ItemName_TextBox");
    FameNum_TextBox = GetTextBoxHandle("ClanShopWnd.ClanShopConfirm_ResultWnd.FameNum_TextBox");
    AdenaNum_TextBox = GetTextBoxHandle("ClanShopWnd.ClanShopConfirm_ResultWnd.AdenaNum_TextBox");
    Discription_TextBox = GetTextBoxHandle("ClanShopWnd.ClanShopConfirm_ResultWnd.Discription_TextBox");
    FameTitle_TextBox = GetTextBoxHandle("ClanShopWnd.ClanShopConfirm_ResultWnd.FameTitle_TextBox");
    Result_ItemWnd.Clear();
    Result_ItemWnd.AddItem(Info);
    ItemName_TextBox.SetText(fullNameString);
    FameNum_TextBox.SetText(MakeCostString(string(SellNameValue * int(ItemCount_EditBox.GetString()))));
    AdenaNum_TextBox.SetText(MakeCostString((__NFUN_401__(SellPrice, (int(ItemCount_EditBox.GetString()))))));
    FameTitle_TextBox.SetText(GetSystemString(3672));
    Discription_TextBox.SetText(GetSystemMessage(4569));
    ItemNum_TextBox.SetText("x" $ ItemCount_EditBox.GetString());
    return;
}

function OnRefresh_ButtonClick()
{
    RequestPledgeItemList();
    Me.SetTimer(99902, 3000);
    Refresh_Button.DisableWindow();
    return;
}

function OnTimer(int TimerID)
{
    // End:0x32
    if(TimerID == 99902)
    {
        Refresh_Button.EnableWindow();
        Me.KillTimer(99902);
    }
    return;
}

function OnClose_ButtonClick()
{
    OnReceivedCloseUI();
    return;
}

function OnOK_ButtonClick()
{
    local ItemInfo Info;
    local LVDataRecord Record;
    local string param;

    ClanShop_ListCtrl.GetSelectedRec(Record);
    param = Record.szReserved;
    ParamToItemInfo(param, Info);
    Debug("구매하자---->" @ ItemCount_EditBox.GetString());
    RequestPledgeItemBuy(Info.Id.ClassID, int(ItemCount_EditBox.GetString()));
    ClanShopConfirm_ResultWnd.HideWindow();
    return;
}

function OnCancel_ButtonClick()
{
    DisableWnd.HideWindow();
    ItemCount_EditBox.ShowWindow();
    ClanShopConfirm_ResultWnd.HideWindow();
    return;
}

function OnSuccess_ButtonClick()
{
    DisableWnd.HideWindow();
    ClanShopSuccess_ResultWnd.HideWindow();
    ItemCount_EditBox.ShowWindow();
    RequestPledgeItemList();
    return;
}

function OnFail_ButtonClick()
{
    DisableWnd.HideWindow();
    ClanShopFails_ResultWnd.HideWindow();
    ItemCount_EditBox.ShowWindow();
    RequestPledgeItemList();
    return;
}

function OnClanShopEdit_ButtonClick()
{
    ShowWindow("ClanShopEditWnd");
    GetWindowHandle("ClanShopEditWnd").SetFocus();
    return;
}

function OnMultiSell_Up_ButtonClick()
{
    local string numStr;
    local int Count;

    numStr = ItemCount_EditBox.GetString();
    Count = int(numStr);
    // End:0x56
    if(checkEnableExchange(Count + 1))
    {
        Count++;
        ItemCount_EditBox.SetString(string(Count));
        updateCost();
    }
    return;
}

function OnMultiSell_Down_ButtonClick()
{
    local string numStr;
    local int Count;

    numStr = ItemCount_EditBox.GetString();
    Count = int(numStr);
    // End:0x50
    if(Count > 1)
    {
        Count--;
        ItemCount_EditBox.SetString(string(Count));
        updateCost();
    }
    return;
}

function bool checkEnableExchange(int tryExchangeCount)
{
    local bool bHasItem;

    bHasItem = true;
    return bHasItem;
    return;
}

function OnPriceEditBtnHandler()
{
    local ItemInfo Info;

    DisableWnd.ShowWindow();
    DisableWnd.SetFocus();
    DialogSetID(10111);
    DialogSetEditBoxMaxLength(6);
    DialogSetCancelD(10111);
    DialogSetReservedItemID(Info.Id);
    DialogSetEditType("number");
    DialogSetParamInt64((-1));
    DialogSetDefaultOK();
    DialogShow(1, 6, GetSystemMessage(4362), string(self));
    return;
}

function HandleDialogOK(bool bOK)
{
    local int Id;
    local INT64 inputNum;

    // End:0x8F
    if(DialogIsMine())
    {
        DisableWnd.HideWindow();
        Id = DialogGetID();
        // End:0x80
        if(bOK)
        {
            // End:0x7D
            if(Id == 10111)
            {
                inputNum = (DialogGetString());
                // End:0x61
                if(__NFUN_410__(inputNum, (0)))
                {
                    inputNum = (1);
                }
                ItemCount_EditBox.SetString((inputNum));
                updateCost();
            }            
        }
        else
        {
            DisableWnd.HideWindow();
        }
    }
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x41
    if(ItemCount_EditBox.IsFocused())
    {
        // End:0x3B
        if(ItemCount_EditBox.GetString() == "0")
        {
            ItemCount_EditBox.SetString("1");
        }
        updateCost();
    }
    return;
}

function LVDataRecord getSelectRecord()
{
    local LVDataRecord Record;

    ClanShop_ListCtrl.GetSelectedRec(Record);
    return Record;
    return;
}

function string getParam()
{
    local LVDataRecord Record;
    local string param;

    Record = getSelectRecord();
    param = Record.szReserved;
    return param;
    return;
}

function updateCost()
{
    local string param;
    local int SellNameValue;
    local INT64 SellPrice;

    param = getParam();
    ParseInt(param, "SellNameValue", SellNameValue);
    ParseINT64(param, "SellPrice", SellPrice);
    NeededItem_Item1Num_text.SetText("x" @ MakeCostString(string(SellNameValue * int(ItemCount_EditBox.GetString()))));
    NeededItem_Item2Num_text.SetText("x" @ MakeCostString((__NFUN_401__(SellPrice, (int(ItemCount_EditBox.GetString()))))));
    updateListData();
    return;
}

function string getTimeStringBySec(int Sec)
{
    local int timeTemp, timeTemp0, timeTemp1;
    local string returnStr;

    // End:0x12
    if(Sec < 0)
    {
        Sec = 0;
    }
    returnStr = "";
    timeTemp = ((Sec / 60) / 60) / 24;
    timeTemp0 = (Sec / 60) / 60;
    timeTemp1 = Sec / 60;
    // End:0xAD
    if(timeTemp > 0)
    {
        returnStr = MakeFullSystemMsg(GetSystemMessage(4466), string(timeTemp), string(int(float((Sec / 60) / 60) % float(24))), string(int(float(Sec / 60) % float(60))));        
    }
    else
    {
        // End:0xEE
        if(timeTemp0 > 0)
        {
            returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp0), string(int(float(Sec / 60) % float(60))));            
        }
        else
        {
            // End:0x11A
            if(timeTemp1 > 0)
            {
                returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp1));                
            }
            else
            {
                returnStr = MakeFullSystemMsg(GetSystemMessage(4360), string(1));
            }
        }
    }
    return returnStr;
    return;
}

function string getTimeStringBySec2(int Sec)
{
    local int timeTemp, timeTemp0;
    local string returnStr;

    // End:0x12
    if(Sec < 0)
    {
        Sec = 0;
    }
    returnStr = "";
    timeTemp = (Sec / 60) / 60;
    timeTemp0 = Sec / 60;
    // End:0x7D
    if(timeTemp > 0)
    {
        returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp), string(int(float(Sec / 60) % float(60))));        
    }
    else
    {
        // End:0xA9
        if(timeTemp0 > 0)
        {
            returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp0));            
        }
        else
        {
            returnStr = MakeFullSystemMsg(GetSystemMessage(4360), string(1));
        }
    }
    return returnStr;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}

delegate int OnSortCompare(ClanItemInfo A, ClanItemInfo B)
{
    // End:0x22
    if(A.sort0 < B.sort0)
    {
        return -1;        
    }
    else
    {
        return 0;
    }
    return;
}
