class TokenTradeWnd extends UICommonAPI;

const DelaySelectedTimerID = 12131212;
const DelayTimer = 50;
const TOKENSELLWND_DIALOG_OK = 1124;

struct MultiSellInfo
{
    var int MultiSellInfoID;
    var int MultiSellType;
    var INT64 NeededItemNum;
    var ItemInfo ResultItemInfo;
    var array<ItemInfo> OutputItemInfoList;
    var array<ItemInfo> InputItemInfoList;
    var array<int> Per;
    var array<string> param;
};

var WindowHandle Me;
var ButtonHandle TradeBtn;
var ButtonHandle CancelBtn;
var TextBoxHandle ItemTypeText;
var TextBoxHandle TradePossibleText;
var TextBoxHandle ItemExplainText;
var TreeHandle ItemTypeTree;
var TreeHandle NeedItemTree;
var ListCtrlHandle TradePossibleListCtrl;
var TextureHandle NeedItemIcon;
var L2Util util;
var array<MultiSellInfo> m_MultiSellInfoList;
var int m_MultiSellGroupID;
var int m_nSelectedMultiSellInfoIndex;
var int m_nCurrentMultiSellInfoIndex;
var int lastSelectNitemID;
var int lastSelectIndex;

function OnRegisterEvent()
{
    RegisterEvent(2531);
    RegisterEvent(2536);
    RegisterEvent(2541);
    RegisterEvent(2551);
    RegisterEvent(2561);
    RegisterEvent(9570);
    RegisterEvent(1710);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    load();
    return;
}

function OnShow()
{
    Me.KillTimer(12131212);
    lastSelectNitemID = 0;
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    return;
}

function Initialize()
{
    Me = GetWindowHandle("TokenTradeWnd");
    TradeBtn = GetButtonHandle("TokenTradeWnd.TradeBtn");
    CancelBtn = GetButtonHandle("TokenTradeWnd.CancelBtn");
    ItemTypeText = GetTextBoxHandle("TokenTradeWnd.ItemTypeText");
    TradePossibleText = GetTextBoxHandle("TokenTradeWnd.TradePossibleText");
    ItemExplainText = GetTextBoxHandle("TokenTradeWnd.ItemExplainText");
    ItemTypeTree = GetTreeHandle("TokenTradeWnd.ItemTypeTree");
    NeedItemTree = GetTreeHandle("TokenTradeWnd.NeedItemTree");
    TradePossibleListCtrl = GetListCtrlHandle("TokenTradeWnd.TradePossibleListCtrl");
    NeedItemIcon = GetTextureHandle("TokenTradeWnd.NeedItemIcon");
    TradePossibleListCtrl.SetSelectedSelTooltip(false);
    TradePossibleListCtrl.SetAppearTooltipAtMouseX(true);
    return;
}

function load()
{
    util = L2Util(GetScript("L2Util"));
    return;
}

function OnClickButton(string strID)
{
    local array<string> Result;
    local string treelist;

    treelist = Left(strID, 4);
    // End:0x2C
    if(strID == "TradeBtn")
    {
        OnTradeBtnClick();        
    }
    else
    {
        // End:0x47
        if(strID == "CancelBtn")
        {
            OnCancelBtnClick();
        }
    }
    // End:0x79
    if(treelist == "Root")
    {
        Split(strID, ".", Result);
        SelectChangeItem(int(Result[1]));
    }
    return;
}

function OnTradeBtnClick()
{
    local array<string> Result;
    local string treelist;
    local int SelectedIndex;

    treelist = Class'NWindow.UIAPI_TREECTRL'.static.GetExpandedNode("TokenTradeWnd.ItemTypeTree", "Root");
    Split(treelist, ".", Result);
    // End:0xBD
    if(treelist != "")
    {
        SelectedIndex = int(Result[1]);
        DialogSetReservedInt(SelectedIndex);
        DialogSetReservedInt2((1));
        DialogSetID(1124);
        DialogShow(1, 4, GetSystemMessage(1383), string(self));
        m_nSelectedMultiSellInfoIndex = SelectedIndex;
        lastSelectNitemID = m_MultiSellInfoList[m_nSelectedMultiSellInfoIndex].MultiSellInfoID;
    }
    return;
}

function OnCancelBtnClick()
{
    Clear();
    Me.HideWindow();
    return;
}

function OnHide()
{
    Me.KillTimer(12131212);
    lastSelectNitemID = 0;
    return;
}

function HandleDialogOK()
{
    local string param;
    local int SelectedIndex;

    // End:0x2FF
    if(DialogIsMine())
    {
        SelectedIndex = DialogGetReservedInt();
        // End:0x27
        if(SelectedIndex >= m_MultiSellInfoList.Length)
        {
            return;
        }
        ParamAdd(param, "MultiSellGroupID", string(m_MultiSellGroupID));
        ParamAdd(param, "MultiSellInfoID", string(m_MultiSellInfoList[SelectedIndex].MultiSellInfoID));
        ParamAdd(param, "ItemCount", (DialogGetReservedInt2()));
        ParamAdd(param, "Enchant", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.Enchanted));
        ParamAdd(param, "RefineryOp1", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp1));
        ParamAdd(param, "RefineryOp2", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp2));
        ParamAdd(param, "AttrAttackType", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeType));
        ParamAdd(param, "AttrAttackValue", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeValue));
        ParamAdd(param, "AttrDefenseValueFire", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueFire));
        ParamAdd(param, "AttrDefenseValueWater", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWater));
        ParamAdd(param, "AttrDefenseValueWind", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWind));
        ParamAdd(param, "AttrDefenseValueEarth", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueEarth));
        ParamAdd(param, "AttrDefenseValueHoly", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueHoly));
        ParamAdd(param, "AttrDefenseValueUnholy", string(m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueUnholy));
        addParamEnsoulOptionInfo(m_MultiSellInfoList[SelectedIndex].ResultItemInfo, param);
        RequestMultiSellChoose(param);
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 2531:
            HandleMultiSellInfoListBegin(param);
            // End:0xB4
            break;
        // End:0x33
        case 2536:
            HandleMultiSellResultItemInfo(param);
            // End:0xB4
            break;
        // End:0x49
        case 2541:
            HandelMultiSellOutputItemInfo(param);
            // End:0xB4
            break;
        // End:0x5F
        case 2551:
            HandelMultiSellInputItemInfo(param);
            // End:0xB4
            break;
        // End:0x75
        case 2561:
            HandleMultiSellInfoListEnd(param);
            // End:0xB4
            break;
        // End:0x86
        case 1710:
            HandleDialogOK();
            // End:0xB4
            break;
        // End:0xAE
        case 9570:
            // End:0xAB
            if(Me.IsShowWindow())
            {
                needItemUpdate(lastSelectIndex);
            }
            // End:0xB4
            break;
        // End:0xFFFF
        default:
            // End:0xB4
            break;
            break;
    }
    return;
}

function HandleMultiSellInfoListBegin(string param)
{
    Clear();
    ParseInt(param, "MultiSellGroupID", m_MultiSellGroupID);
    return;
}

function HandleMultiSellResultItemInfo(string param)
{
    local int nMultiSellInfoID, nBuyType;
    local ItemInfo Info;
    local int ensoulNormalSlot, ensoulBmSlot;

    ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
    ParseInt(param, "BuyType", nBuyType);
    ParseInt(param, "Enchant", Info.Enchanted);
    ParseInt(param, "RefineryOp1", Info.RefineryOp1);
    ParseInt(param, "RefineryOp2", Info.RefineryOp2);
    ParseInt(param, "AttrAttackType", Info.AttackAttributeType);
    ParseInt(param, "AttrAttackValue", Info.AttackAttributeValue);
    ParseInt(param, "AttrDefenseValueFire", Info.DefenseAttributeValueFire);
    ParseInt(param, "AttrDefenseValueWater", Info.DefenseAttributeValueWater);
    ParseInt(param, "AttrDefenseValueWind", Info.DefenseAttributeValueWind);
    ParseInt(param, "AttrDefenseValueEarth", Info.DefenseAttributeValueEarth);
    ParseInt(param, "AttrDefenseValueHoly", Info.DefenseAttributeValueHoly);
    ParseInt(param, "AttrDefenseValueUnholy", Info.DefenseAttributeValueUnholy);
    ParseInt(param, "EnsoulOptionNum_" $ string(2), ensoulBmSlot);
    ParseInt(param, "EnsoulOptionNum_" $ string(1), ensoulNormalSlot);
    addEnsoulInfo(2, ensoulBmSlot, param, Info);
    addEnsoulInfo(1, ensoulNormalSlot, param, Info);
    m_nCurrentMultiSellInfoIndex = m_MultiSellInfoList.Length;
    m_MultiSellInfoList.Length = m_nCurrentMultiSellInfoIndex + 1;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID = nMultiSellInfoID;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellType = nBuyType;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].ResultItemInfo = Info;
    return;
}

function HandelMultiSellOutputItemInfo(string param)
{
    local int nMultiSellInfoID, nCurrentOutputItemInfoIndex;
    local ItemInfo Info;
    local int nItemClassID, Per, ensoulNormalSlot, ensoulBmSlot;

    ParseItemID(param, Info.Id);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
    ParseInt(param, "ClassID", nItemClassID);
    ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
    ParseINT64(param, "SlotBitType", Info.SlotBitType);
    ParseInt(param, "ItemType", Info.ItemType);
    ParseINT64(param, "ItemCount", Info.ItemNum);
    ParseInt(param, "Enchant", Info.Enchanted);
    ParseInt(param, "RefineryOp1", Info.RefineryOp1);
    ParseInt(param, "RefineryOp2", Info.RefineryOp2);
    ParseInt(param, "AttrAttackType", Info.AttackAttributeType);
    ParseInt(param, "AttrAttackValue", Info.AttackAttributeValue);
    ParseInt(param, "AttrDefenseValueFire", Info.DefenseAttributeValueFire);
    ParseInt(param, "AttrDefenseValueWater", Info.DefenseAttributeValueWater);
    ParseInt(param, "AttrDefenseValueWind", Info.DefenseAttributeValueWind);
    ParseInt(param, "AttrDefenseValueEarth", Info.DefenseAttributeValueEarth);
    ParseInt(param, "AttrDefenseValueHoly", Info.DefenseAttributeValueHoly);
    ParseInt(param, "AttrDefenseValueUnholy", Info.DefenseAttributeValueUnholy);
    ParseInt(param, "Attribution", Info.Attribution);
    ParseInt(param, "Probability", Per);
    ParseInt(param, "EnsoulOptionNum_" $ string(2), ensoulBmSlot);
    ParseInt(param, "EnsoulOptionNum_" $ string(1), ensoulNormalSlot);
    addEnsoulInfo(2, ensoulBmSlot, param, Info);
    addEnsoulInfo(1, ensoulNormalSlot, param, Info);
    // End:0x358
    if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
    {
        return;
    }
    // End:0x3C6
    if(nItemClassID == -300)
    {
        Info.Name = GetSystemString(102);
        Info.IconName = "icon.pvp_point_i00";
        Info.Enchanted = 0;
        Info.ItemType = -1;
        Info.Id.ClassID = 0;
    }
    // End:0x3EB
    if(0 < Info.Durability)
    {
        Info.CurrentDurability = Info.Durability;
    }
    nCurrentOutputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].Per.Length = nCurrentOutputItemInfoIndex + 1;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].Per[nCurrentOutputItemInfoIndex] = Per;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].param.Length = nCurrentOutputItemInfoIndex + 1;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].param[nCurrentOutputItemInfoIndex] = param;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length = nCurrentOutputItemInfoIndex + 1;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = Info;
    return;
}

function HandelMultiSellInputItemInfo(string param)
{
    local int nMultiSellInfoID, nCurrentInputItemInfoIndex, nItemClassID;
    local ItemInfo Info;
    local int ensoulNormalSlot, ensoulBmSlot;

    ParseItemID(param, Info.Id);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Info.Id, Info);
    ParseInt(param, "MultiSellInfoID", nMultiSellInfoID);
    ParseInt(param, "ClassID", nItemClassID);
    ParseInt(param, "ItemType", Info.ItemType);
    ParseINT64(param, "ItemCount", Info.ItemNum);
    ParseInt(param, "Enchant", Info.Enchanted);
    ParseInt(param, "RefineryOp1", Info.RefineryOp1);
    ParseInt(param, "RefineryOp2", Info.RefineryOp2);
    ParseInt(param, "AttrAttackType", Info.AttackAttributeType);
    ParseInt(param, "AttrAttackValue", Info.AttackAttributeValue);
    ParseInt(param, "AttrDefenseValueFire", Info.DefenseAttributeValueFire);
    ParseInt(param, "AttrDefenseValueWater", Info.DefenseAttributeValueWater);
    ParseInt(param, "AttrDefenseValueWind", Info.DefenseAttributeValueWind);
    ParseInt(param, "AttrDefenseValueEarth", Info.DefenseAttributeValueEarth);
    ParseInt(param, "AttrDefenseValueHoly", Info.DefenseAttributeValueHoly);
    ParseInt(param, "AttrDefenseValueUnholy", Info.DefenseAttributeValueUnholy);
    ParseInt(param, "Attribution", Info.Attribution);
    ParseInt(param, "EnsoulOptionNum_" $ string(2), ensoulBmSlot);
    ParseInt(param, "EnsoulOptionNum_" $ string(1), ensoulNormalSlot);
    addEnsoulInfo(2, ensoulBmSlot, param, Info);
    addEnsoulInfo(1, ensoulNormalSlot, param, Info);
    // End:0x319
    if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
    {
        return;
    }
    // End:0x37F
    if(nItemClassID == -100)
    {
        Info.Name = GetSystemString(1277);
        Info.IconName = GetPcCafeItemIconPackageName();
        Info.Enchanted = 0;
        Info.ItemType = -1;
        Info.Id.ClassID = 0;        
    }
    else
    {
        // End:0x405
        if(nItemClassID == -200)
        {
            Info.Name = GetSystemString(1311);
            Info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
            Info.Enchanted = 0;
            Info.ItemType = -1;
            Info.Id.ClassID = 0;            
        }
        else
        {
            // End:0x476
            if(nItemClassID == -300)
            {
                Info.Name = GetSystemString(102);
                Info.IconName = "icon.pvp_point_i00";
                Info.Enchanted = 0;
                Info.ItemType = -1;
                Info.Id.ClassID = 0;                
            }
            else
            {
                Info.Name = Class'NWindow.UIDATA_ITEM'.static.GetItemName(Info.Id);
            }
        }
    }
    Info.ItemType = Class'NWindow.UIDATA_ITEM'.static.GetItemDataType(Info.Id);
    Info.CrystalType = Class'NWindow.UIDATA_ITEM'.static.GetItemCrystalType(Info.Id);
    // End:0x53E
    if(nItemClassID != -400)
    {
        nCurrentInputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length;
        m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length = nCurrentInputItemInfoIndex + 1;
        m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList[nCurrentInputItemInfoIndex] = Info;
    }
    return;
}

function HandleMultiSellInfoListEnd(string param)
{
    local WindowHandle m_inventoryWnd;

    m_inventoryWnd = GetWindowHandle("InventoryWnd");
    // End:0x3B
    if(m_inventoryWnd.IsShowWindow())
    {
        m_inventoryWnd.HideWindow();
    }
    ShowWindow("TokenTradeWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("TokenTradeWnd");
    ShowItemList();
    return;
}

function ShowItemList()
{
    local ItemInfo Info;
    local int i;
    local string TREENAME;
    local bool bDrawBgTree;
    local string setTreeName, strRetName, itemAllName;

    TREENAME = "TokenTradeWnd.ItemTypeTree";
    TreeClear(TREENAME);
    util.TreeInsertRootNode(TREENAME, "Root", "", 0, 0);
    setTreeName = "Root";
    i = 0;
    J0x5E:

    // End:0x298 [Loop If]
    if(i < m_MultiSellInfoList.Length)
    {
        Info = m_MultiSellInfoList[i].OutputItemInfoList[0];
        strRetName = util.TreeInsertItemTooltipSimpleNode(TREENAME, string(i), setTreeName, -7, 0, 38, 0, 30, 38);
        // End:0x103
        if(bDrawBgTree)
        {
            util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 245, 38,,,,, 14);            
        }
        else
        {
            util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 245, 38);
        }
        bDrawBgTree = !bDrawBgTree;
        util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -244, 2);
        util.TreeInsertTextureNodeItem(TREENAME, strRetName, Info.IconName, 32, 32, -34, 3);
        // End:0x212
        if(Info.Enchanted > 0)
        {
            itemAllName = ((("+" $ string(Info.Enchanted)) @ Info.Name) @ Info.AdditionalName) @ (GetEnsoulOptionNameAll(Info));            
        }
        else
        {
            itemAllName = (Info.Name @ Info.AdditionalName) @ (GetEnsoulOptionNameAll(Info));
        }
        util.TreeInsertTextMultiNodeItem(TREENAME, strRetName, itemAllName, 4, 0, 38, util.0);
        // End:0x28E
        if(lastSelectNitemID == m_MultiSellInfoList[i].MultiSellInfoID)
        {
            lastSelectIndex = i;
        }
        ++i;
        // [Loop Continue]
        goto J0x5E;
    }
    // End:0x2E9
    if((lastSelectNitemID > 0) && lastSelectIndex > 0)
    {
        ItemTypeTree.SetExpandedNode("Root." $ string(lastSelectIndex), true);
        Me.SetTimer(12131212, 50);        
    }
    else
    {
        ItemTypeTree.SetExpandedNode("Root.0", true);
        SelectChangeItem(0);
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x2E
    if(TimerID == 12131212)
    {
        SelectChangeItem(lastSelectIndex);
        Me.KillTimer(12131212);
    }
    return;
}

function SelectChangeItem(int Num)
{
    local ItemInfo Info;
    local LVDataRecord Record;
    local string strParam;
    local int i, ensoulBmSlot, ensoulNormalSlot;
    local string enchantedStr;

    TradePossibleListCtrl.DeleteAllItem();
    i = 1;
    J0x16:

    // End:0x85F [Loop If]
    if(i < m_MultiSellInfoList[Num].OutputItemInfoList.Length)
    {
        Info = m_MultiSellInfoList[Num].OutputItemInfoList[i];
        // End:0x68
        if(Info.Enchanted <= 0)
        {
            enchantedStr = "";            
        }
        else
        {
            enchantedStr = ("+" $ string(Info.Enchanted)) $ " ";
        }
        strParam = m_MultiSellInfoList[Num].param[i];
        ParamAdd(strParam, "name", Info.Name);
        ParamAdd(strParam, "WeaponType", string(Info.WeaponType));
        ParamAdd(strParam, "Enchanted", string(Info.Enchanted));
        ParamAdd(strParam, "Weight", string(Info.Weight));
        ParamAdd(strParam, "Description", Info.Description);
        ParamAdd(strParam, "IconName", Info.IconName);
        ParamAdd(strParam, "SoulshotCount", string(Info.SoulshotCount));
        ParamAdd(strParam, "SpiritshotCount", string(Info.SpiritshotCount));
        ParamAdd(strParam, "CrystalType", string(Info.CrystalType));
        ParamAdd(strParam, "AdditionalName", Info.AdditionalName);
        ParamAdd(strParam, "pAttack", string(Info.pAttack));
        ParamAdd(strParam, "mAttack", string(Info.mAttack));
        ParamAdd(strParam, "pCriRate", string(Info.pCriRate));
        ParamAdd(strParam, "mCriRate", string(Info.mCriRate));
        ParamAdd(strParam, "pAttackSpeed", string(Info.pAttackSpeed));
        ParamAdd(strParam, "mAttackSpeed", string(Info.mAttackSpeed));
        ParamAdd(strParam, "pDefense", string(Info.pDefense));
        ParamAdd(strParam, "ShieldDefense", string(Info.ShieldDefense));
        ParamAdd(strParam, "pAvoid", string(Info.pAvoid));
        ParamAdd(strParam, "ArmorType", string(Info.ArmorType));
        ParamAdd(strParam, "mDefense", string(Info.mDefense));
        ParamAdd(strParam, "Attribution", string(Info.Attribution));
        ParseInt(strParam, "EnsoulOptionNum_" $ string(2), ensoulBmSlot);
        ParseInt(strParam, "EnsoulOptionNum_" $ string(1), ensoulNormalSlot);
        addEnsoulInfo(2, ensoulBmSlot, strParam, Info);
        addEnsoulInfo(1, ensoulNormalSlot, strParam, Info);
        Record.szReserved = strParam;
        Record.LVDataList.Length = 2;
        // End:0x485
        if(Info.Enchanted > 0)
        {
            Record.LVDataList[0].szData = ((("+" $ string(Info.Enchanted)) @ Info.Name) @ Info.AdditionalName) @ (GetEnsoulOptionNameAll(Info));            
        }
        else
        {
            Record.LVDataList[0].szData = (Info.Name @ Info.AdditionalName) @ (GetEnsoulOptionNameAll(Info));
        }
        Record.LVDataList[0].hasIcon = true;
        Record.LVDataList[0].nTextureWidth = 32;
        Record.LVDataList[0].nTextureHeight = 32;
        Record.LVDataList[0].nTextureU = 32;
        Record.LVDataList[0].nTextureV = 32;
        Record.LVDataList[0].szTexture = Info.IconName;
        Record.LVDataList[0].IconPosX = 4;
        Record.LVDataList[0].FirstLineOffsetX = 6;
        Record.LVDataList[0].iconBackTexName = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
        Record.LVDataList[0].backTexOffsetXFromIconPosX = -2;
        Record.LVDataList[0].backTexOffsetYFromIconPosY = -1;
        Record.LVDataList[0].backTexWidth = 36;
        Record.LVDataList[0].backTexHeight = 36;
        Record.LVDataList[0].backTexUL = 36;
        Record.LVDataList[0].backTexVL = 36;
        Record.LVDataList[0].AttrColor.R = 170;
        Record.LVDataList[0].AttrColor.G = 170;
        Record.LVDataList[0].AttrColor.B = 170;
        Record.LVDataList[0].AttrStat[0] = "x" $ (Info.ItemNum);
        Record.LVDataList[1].bUseTextColor = true;
        // End:0x6FB
        if(m_MultiSellInfoList[Num].Per[i] > 30)
        {
            Record.LVDataList[1].TextColor = util.Token0;
            Record.LVDataList[1].szData = GetSystemString(1234);            
        }
        else
        {
            // End:0x774
            if((m_MultiSellInfoList[Num].Per[i] <= 30) && m_MultiSellInfoList[Num].Per[i] >= 11)
            {
                Record.LVDataList[1].TextColor = util.Token1;
                Record.LVDataList[1].szData = GetSystemString(225);                
            }
            else
            {
                // End:0x7F0
                if((m_MultiSellInfoList[Num].Per[i] <= 10) && m_MultiSellInfoList[Num].Per[i] >= 5)
                {
                    Record.LVDataList[1].TextColor = util.Token2;
                    Record.LVDataList[1].szData = GetSystemString(1236);                    
                }
                else
                {
                    Record.LVDataList[1].TextColor = util.Token3;
                    Record.LVDataList[1].szData = GetSystemString(1237);
                }
            }
        }
        Record.LVDataList[1].textAlignment = 2;
        TradePossibleListCtrl.InsertRecord(Record);
        ++i;
        // [Loop Continue]
        goto J0x16;
    }
    needItemUpdate(Num);
    return;
}

function needItemUpdate(int Num)
{
    local bool bDrawBgTree;
    local string TREENAME, setTreeName, strRetName, strNeed;
    local ItemInfo infoNeed, tempInfo;
    local int i;

    TREENAME = "TokenTradeWnd.NeedItemTree";
    TreeClear(TREENAME);
    util.TreeInsertRootNode(TREENAME, "Need", "", 0, 2);
    setTreeName = "Need";
    i = 0;
    J0x5F:

    // End:0x475 [Loop If]
    if(i < m_MultiSellInfoList[Num].InputItemInfoList.Length)
    {
        infoNeed = m_MultiSellInfoList[Num].InputItemInfoList[i];
        strRetName = util.TreeInsertItemNode(TREENAME, string(i), setTreeName, false, -6, -2);
        // End:0x114
        if(bDrawBgTree)
        {
            util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 545, 38,,,,, 14);            
        }
        else
        {
            util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 545, 38);
        }
        bDrawBgTree = !bDrawBgTree;
        util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -538, 2);
        switch(infoNeed.Id.ClassID)
        {
            // End:0x299
            case 57:
                util.TreeInsertTextureNodeItem(TREENAME, strRetName, infoNeed.IconName, 32, 32, -34, 3);
                util.TreeInsertTextNodeItem(TREENAME, strRetName, infoNeed.Name, 5, 6, util.0, true);
                strNeed = (((("x" $ (infoNeed.ItemNum)) $ " / ") $ GetSystemString(2035)) $ " ") $ (GetInventoryItemCount(infoNeed.Id));
                util.TreeInsertTextNodeItem(TREENAME, strRetName, strNeed, 48, -18, util.1,, true);
                // End:0x46B
                break;
            // End:0xFFFF
            default:
                util.TreeInsertTextureNodeItem(TREENAME, strRetName, infoNeed.IconName, 32, 32, -34, 3);
                Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(infoNeed.Id.ClassID), tempInfo);
                Debug("tempInfo.IconPanel:" @ string(infoNeed.Id.ClassID));
                Debug("tempInfo.IconPanel:" @ tempInfo.IconPanel);
                // End:0x3A6
                if(tempInfo.IconPanel != "")
                {
                    util.TreeInsertTextureNodeItem(TREENAME, strRetName, tempInfo.IconPanel, 32, 32, -34, 3);
                    Debug("패널 적용 :" @ tempInfo.IconPanel);
                }
                util.TreeInsertTextNodeItem(TREENAME, strRetName, infoNeed.Name @ infoNeed.AdditionalName, 5, 6, util.0, true,, infoNeed.Id.ClassID);
                strNeed = (((("x" $ (infoNeed.ItemNum)) $ " / ") $ GetSystemString(2035)) $ " ") $ (GetInventoryItemCount(infoNeed.Id));
                util.TreeInsertTextNodeItem(TREENAME, strRetName, strNeed, 48, -18, util.1,, true);
                break;
        }
        ++i;
        // [Loop Continue]
        goto J0x5F;
    }
    return;
}

function TreeClear(string Str)
{
    Class'NWindow.UIAPI_TREECTRL'.static.Clear(Str);
    return;
}

function Clear()
{
    TreeClear("TokenTradeWnd.ItemTypeTree");
    TreeClear("TokenTradeWnd.NeedItemTree");
    TradePossibleListCtrl.DeleteAllItem();
    m_nCurrentMultiSellInfoIndex = 0;
    m_MultiSellInfoList.Length = 0;
    m_MultiSellGroupID = 0;
    return;
}

function addEnsoulInfo(int slotType, int SlotCount, string param, out ItemInfo Info)
{
    local int N, nEOptionID;

    N = 1;
    J0x07:

    // End:0x82 [Loop If]
    if(N < (SlotCount + 1))
    {
        ParseInt(param, (("EnsoulOptionID_" $ string(slotType)) $ "_") $ string(N), nEOptionID);
        Info.EnsoulOption[slotType - 1].OptionArray[N - 1] = nEOptionID;
        N++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    OnCancelBtnClick();
    return;
}
