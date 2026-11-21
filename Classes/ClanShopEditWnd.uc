class ClanShopEditWnd extends UICommonAPI;

const TIMER_CLICK = 99904;
const TIMER_DELAYC = 3000;

struct ClanItemInfo
{
    var LVDataRecord Record;
    var int sort0;
    var int sort1;
};

var WindowHandle Me;
var TextureHandle EditBtnImg_texture;
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
var WindowHandle LockCancel_Wnd;
var TextBoxHandle clanLVTitle_text;
var TextBoxHandle clanLVNum_text;
var TextBoxHandle clanAttributeTitle_text;
var TextBoxHandle clanAttributeNum_text;
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
var TextureHandle ItemInfoBg_Texture;
var TextureHandle LockCancelBg_Texture;
var TextureHandle NeededItemBg_Texture;
var ButtonHandle ExChange_Button;
var WindowHandle DisableWnd;
var WindowHandle DescriptionMsgWnd;
var TextBoxHandle DescriptionMsg_Text;
var ButtonHandle Refresh_Button;
var ButtonHandle Close_Button;
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
    RegisterEvent(10740);
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
    Me = GetWindowHandle("ClanShopEditWnd");
    EditBtnImg_texture = GetTextureHandle("ClanShopEditWnd.EditBtnImg_texture");
    ClanShopListWnd = GetWindowHandle("ClanShopEditWnd.ClanShopListWnd");
    LockVeiw_checkBox = GetCheckBoxHandle("ClanShopEditWnd.ClanShopListWnd.LockVeiw_checkBox");
    ClanShopListListDeco_texture = GetTextureHandle("ClanShopEditWnd.ClanShopListWnd.ClanShopListListDeco_texture");
    ClanShop_ListCtrl = GetListCtrlHandle("ClanShopEditWnd.ClanShopListWnd.ClanShop_ListCtrl");
    ClanShopListWndBG_Texture = GetTextureHandle("ClanShopEditWnd.ClanShopListWnd.ClanShopListWndBG_Texture");
    ClanShopListBG_Texture = GetTextureHandle("ClanShopEditWnd.ClanShopListWnd.ClanShopListBG_Texture");
    ClanShopItemInfoWnd = GetWindowHandle("ClanShopEditWnd.ClanShopItemInfoWnd");
    ItemInfo_Text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.ItemInfo_Text");
    NeedItem_Text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeedItem_Text");
    ExchangeNum_Text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.ExchangeNum_Text");
    ClanItemName_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.ClanItemName_text");
    ClanItemDescription_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.ClanItemDescription_text");
    LockCancel_Wnd = GetWindowHandle("ClanShopEditWnd.ClanShopItemInfoWnd.LockCancel_Wnd");
    clanLVTitle_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.LockCancel_Wnd.clanLVTitle_text");
    clanLVNum_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.LockCancel_Wnd.clanLVNum_text");
    clanAttributeTitle_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.LockCancel_Wnd.clanAttributeTitle_text");
    clanAttributeNum_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.LockCancel_Wnd.clanAttributeNum_text");
    NeededItem_Wnd = GetWindowHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd");
    NeededItem_SlotBg1_Texture = GetTextureHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_SlotBg1_Texture");
    NeededItem_SlotBg2_Texture = GetTextureHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_SlotBg2_Texture");
    NeededItem_Item1_ItemWnd = GetItemWindowHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1_ItemWnd");
    NeededItem_Item2_ItemWnd = GetItemWindowHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2_ItemWnd");
    NeededItem_Item1Title_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1Title_text");
    NeededItem_Item1Num_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1Num_text");
    NeededItem_Item1MyNum_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item1MyNum_text");
    NeededItem_Item2Title_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2Title_text");
    NeededItem_Item2Num_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2Num_text");
    NeededItem_Item2MyNum_text = GetTextBoxHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItem_Wnd.NeededItem_Item2MyNum_text");
    ItemInfoBg_Texture = GetTextureHandle("ClanShopEditWnd.ClanShopItemInfoWnd.ItemInfoBg_Texture");
    LockCancelBg_Texture = GetTextureHandle("ClanShopEditWnd.ClanShopItemInfoWnd.LockCancelBg_Texture");
    NeededItemBg_Texture = GetTextureHandle("ClanShopEditWnd.ClanShopItemInfoWnd.NeededItemBg_Texture");
    ExChange_Button = GetButtonHandle("ClanShopEditWnd.ClanShopItemInfoWnd.ExChange_Button");
    DisableWnd = GetWindowHandle("ClanShopEditWnd.DisableWnd");
    DescriptionMsgWnd = GetWindowHandle("ClanShopEditWnd.DescriptionMsgWnd");
    DescriptionMsg_Text = GetTextBoxHandle("ClanShopEditWnd.DescriptionMsgWnd.DescriptionMsg_Text");
    Refresh_Button = GetButtonHandle("ClanShopEditWnd.Refresh_Button");
    Close_Button = GetButtonHandle("ClanShopEditWnd.Close_Button");
    ClanShopConfirm_ResultWnd = GetWindowHandle("ClanShopEditWnd.ClanShopConfirm_ResultWnd");
    ClanShopSuccess_ResultWnd = GetWindowHandle("ClanShopEditWnd.ClanShopSuccess_ResultWnd");
    ClanShopFails_ResultWnd = GetWindowHandle("ClanShopEditWnd.ClanShopFails_ResultWnd");
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

    // End:0x30
    if(Event_ID == 10730)
    {
        ClearAll();
        ParseInt(param, "nCount", listTotalCount);        
    }
    else
    {
        // End:0x4D
        if(Event_ID == 10810)
        {
            ItemListInfo(param);            
        }
        else
        {
            // End:0x11B
            if(Event_ID == 10740)
            {
                Debug(("debuftest OnEvent " @ string(Event_ID)) @ param);
                ParseInt(param, "nResult", nResult);
                // End:0x101
                if(nResult == 0)
                {
                    Debug("¼º°ø!~~~~~~~~~~~~~~~~~~~~~~~!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!");
                    SetSuccessWnd();                    
                }
                else
                {
                    SetFailWnd(nResult);
                    ClanShopFails_ResultWnd.ShowWindow();
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

    Result_ItemWnd = GetItemWindowHandle("ClanShopEditWnd.ClanShopSuccess_ResultWnd.Result_ItemWnd");
    ItemName_TextBox = GetTextBoxHandle("ClanShopEditWnd.ClanShopSuccess_ResultWnd.ItemName_TextBox");
    Discription_TextBox = GetTextBoxHandle("ClanShopEditWnd.ClanShopSuccess_ResultWnd.Discription_TextBox");
    Result_ItemWnd.Clear();
    Result_ItemWnd.AddItem(SelectItemInfo);
    ItemName_TextBox.SetText(GetItemNameAll(SelectItemInfo));
    Discription_TextBox.SetText(GetSystemMessage(4568));
    ClanShopSuccess_ResultWnd.ShowWindow();
    return;
}

function SetFailWnd(int N)
{
    local TextBoxHandle Discription_TextBox;

    Discription_TextBox = GetTextBoxHandle("ClanShopEditWnd.ClanShopFails_ResultWnd.Discription_TextBox");
    // End:0x72
    if(N == 3)
    {
        Discription_TextBox.SetText(GetSystemMessage(4690));        
    }
    else
    {
        // End:0x9B
        if(N == 4)
        {
            Discription_TextBox.SetText(GetSystemMessage(3721));            
        }
        else
        {
            // End:0xD8
            if((N == -3) || N == -4)
            {
                Discription_TextBox.SetText(GetSystemMessage(4691));                
            }
            else
            {
                Discription_TextBox.SetText(GetSystemMessage(4559));
            }
        }
    }
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
            Record.LVDataList[0].AttrColor = GetColor(255, 102, 102, 255);
            Record.LVDataList[0].AttrStat[0] = GetSystemMessage(4564);            
        }
        else
        {
            Record.LVDataList[0].TextColor = util.BWhite;
            Record.LVDataList[0].AttrColor = util.DRed;
            // End:0x615
            if(RemainActivateTime == 0)
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
    local LVDataRecord Record;
    local string param, ActivatePledgeLevel;
    local ItemInfo Info;
    local int SellPrice, SellNameValue, ActivateNameValue, ActivateMasteryID;
    local UserInfo infoPlayer;
    local INT64 iPlayerSP, ActivatePrice;
    local int Status;

    GetPlayerInfo(infoPlayer);
    iPlayerSP = (GetClanNameValue(infoPlayer.nClanID));
    ClanShop_ListCtrl.GetSelectedRec(Record);
    param = Record.szReserved;
    Debug(param);
    ParamToItemInfo(param, Info);
    SelectItemInfo = Info;
    ParseInt(param, "SellPrice", SellPrice);
    ParseInt(param, "SellNameValue", SellNameValue);
    ParseInt(param, "ActivateMasteryID", ActivateMasteryID);
    ParseInt(param, "ActivateNameValue", ActivateNameValue);
    ParseINT64(param, "ActivatePrice", ActivatePrice);
    ParseInt(param, "Status", Status);
    ParseString(param, "ActivatePledgeLevel", ActivatePledgeLevel);
    Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.Clear("ClanShopEditWnd.multiSellItemInfo");
    // End:0x1BF
    if(param != "")
    {
        Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("ClanShopEditWnd.multiSellItemInfo", 0, Info);
    }
    clanLVNum_text.SetText(ActivatePledgeLevel @ GetSystemString(859));
    // End:0x208
    if(ActivateMasteryID == 0)
    {
        clanAttributeNum_text.SetText(GetSystemString(3744));        
    }
    else
    {
        clanAttributeNum_text.SetText(GetPledgeMasteryName(ActivateMasteryID) @ GetSystemString(859));
    }
    NeededItem_Item1Num_text.SetText("x" @ MakeCostString(string(ActivateNameValue)));
    NeededItem_Item2Num_text.SetText("x" @ MakeCostString((ActivatePrice)));
    // End:0x28E
    if(Status == 1)
    {
        ExChange_Button.EnableWindow();        
    }
    else
    {
        ExChange_Button.DisableWindow();
    }
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
            // End:0xDB
            break;
        // End:0x57
        case "Refresh_Button":
            OnRefresh_ButtonClick();
            // End:0xDB
            break;
        // End:0x71
        case "Close_Button":
            OnClose_ButtonClick();
            // End:0xDB
            break;
        // End:0x88
        case "OK_Button":
            OnOK_ButtonClick();
            // End:0xDB
            break;
        // End:0xA3
        case "Cancel_Button":
            OnCancel_ButtonClick();
            // End:0xDB
            break;
        // End:0xBF
        case "Success_Button":
            OnSuccess_ButtonClick();
            // End:0xDB
            break;
        // End:0xD8
        case "Fail_Button":
            OnFail_ButtonClick();
            // End:0xDB
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
    return;
}

function setResultWnd()
{
    local string param, fullNameString;
    local LVDataRecord Record;
    local ItemInfo Info;
    local ItemWindowHandle Result_ItemWnd;
    local TextBoxHandle ItemName_TextBox, FameNum_TextBox, AdenaNum_TextBox, Discription_TextBox;
    local int ActivateNameValue;
    local INT64 ActivatePrice;

    ClanShop_ListCtrl.GetSelectedRec(Record);
    param = Record.szReserved;
    ParamToItemInfo(param, Info);
    ParseInt(param, "ActivateNameValue", ActivateNameValue);
    ParseINT64(param, "ActivatePrice", ActivatePrice);
    fullNameString = GetItemNameAll(Info);
    Result_ItemWnd = GetItemWindowHandle("ClanShopEditWnd.ClanShopConfirm_ResultWnd.Result_ItemWnd");
    ItemName_TextBox = GetTextBoxHandle("ClanShopEditWnd.ClanShopConfirm_ResultWnd.ItemName_TextBox");
    FameNum_TextBox = GetTextBoxHandle("ClanShopEditWnd.ClanShopConfirm_ResultWnd.FameNum_TextBox");
    AdenaNum_TextBox = GetTextBoxHandle("ClanShopEditWnd.ClanShopConfirm_ResultWnd.AdenaNum_TextBox");
    Discription_TextBox = GetTextBoxHandle("ClanShopEditWnd.ClanShopConfirm_ResultWnd.Discription_TextBox");
    Result_ItemWnd.Clear();
    Result_ItemWnd.AddItem(Info);
    ItemName_TextBox.SetText(fullNameString);
    FameNum_TextBox.SetText(MakeCostString(string(ActivateNameValue)));
    AdenaNum_TextBox.SetText(MakeCostString((ActivatePrice)));
    Discription_TextBox.SetText(GetSystemMessage(4567));
    return;
}

function OnRefresh_ButtonClick()
{
    RequestPledgeItemList();
    Me.SetTimer(99904, 3000);
    Refresh_Button.DisableWindow();
    return;
}

function OnTimer(int TimerID)
{
    // End:0x32
    if(TimerID == 99904)
    {
        Refresh_Button.EnableWindow();
        Me.KillTimer(99904);
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
    RequestPledgeItemActivate(Info.Id.ClassID);
    ClanShopConfirm_ResultWnd.HideWindow();
    return;
}

function OnCancel_ButtonClick()
{
    DisableWnd.HideWindow();
    ClanShopConfirm_ResultWnd.HideWindow();
    return;
}

function OnSuccess_ButtonClick()
{
    DisableWnd.HideWindow();
    ClanShopSuccess_ResultWnd.HideWindow();
    RequestPledgeItemList();
    return;
}

function OnFail_ButtonClick()
{
    DisableWnd.HideWindow();
    ClanShopFails_ResultWnd.HideWindow();
    RequestPledgeItemList();
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
