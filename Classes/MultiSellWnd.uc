class MultiSellWnd extends PacketsInfo;

const DIALOG_ASK_PRICE = 1123;
const MULTISELLWND_DIALOG_OK = 1122;
const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;
const TREENAME = "MultiSellWnd.NeededItem_TreeCtrl";
const ROOTNAME = "root";
const ITEMNAME_TOTAL_WIDTH = 240;
const TIMER_UPDATE_ID = 1235552;
const TIMER_UPDATEDELAY = 10;

struct SCurrentMultisellExInfo
{
    var int __var3687;
    var int __var18628;
};

struct MultiSellInfo
{
    var int MultiSellInfoID;
    var int MultiSellType;
    var INT64 NeededItemNum;
    var ItemInfo ResultItemInfo;
    var array<ItemInfo> OutputItemInfoList;
    var array<ItemInfo> InputItemInfoList;
};

struct NoStackableItemData
{
    var int ClassID;
    var INT64 Count;
};

struct multiSellData
{
    var int pcCafePoint;
    var int clanPoint;
    var int PvPPoint;
    var int RaidPoint;
    var INT64 Adena;
};

var array<SCurrentMultisellExInfo> __var1861;
var int __var5842;
var WindowHandle Me;
var TextBoxHandle ItemInfo_Text;
var TextBoxHandle NeedItem_Text;
var TextBoxHandle ExchangeNum_Text;
var TextBoxHandle DescriptionMsg_Text;
var TabHandle MultiSellTab;
var WindowHandle MultisellTabTotalWnd;
var ItemWindowHandle MultisellTabTotalWnd_ItemWindow;
var ListCtrlHandle MultisellTabTotalWnd_ListCtrl;
var WindowHandle MultisellTabEnableWnd;
var ItemWindowHandle MultisellTabEnableWnd_ItemWindow;
var ListCtrlHandle MultisellTabEnableWnd_ListCtrl;
var WindowHandle DisableWnd;
var EditBoxHandle Search_EditBox;
var EditBoxHandle ItemCount_EditBox;
var TreeHandle NeededItem_TreeCtrl;
var ButtonHandle InventoryViewerCall_Button;
var ButtonHandle Search_Button;
var ButtonHandle Refrash_Button;
var ButtonHandle Clear_Button;
var ButtonHandle ExChange_Button;
var ButtonHandle Close_Button;
var ButtonHandle IconTabIcon_Button;
var ButtonHandle ListTabIcon_Button;
var ButtonHandle MultiSell_Up_Button;
var ButtonHandle MultiSell_Down_Button;
var ButtonHandle MultiSell_Input_Button;
var array<MultiSellInfo> m_MultiSellInfoList;
var int m_MultiSellGroupID;
var int m_nSelectedMultiSellInfoIndex;
var int m_nCurrentMultiSellInfoIndex;
var UserInfo PlayerInfo;
var multiSellData mData;
var L2Util util;
var UIData UIDataScript;
var bool bFirstAdd;
var bool bClose;
var int nShowAll;
var int nRepeat;
var int nKeepEnchant;
var int nRepeatTimeCurrentInputItemInfoIndex;
var ItemInfo lastSelectItemInfo;
var string dialogMessage;
var bool useTick;
var int tickIndex;
var int tickItemListIndex;
var string searchStr;
var bool searchMode;
var bool bForceUpdate;
var int bShowVariationItem;
var array<string> PreviewMultisellIDs;
var bool bIsPreviewMultisell;

function OnRegisterEvent()
{
    RegisterEvent(2530);
    RegisterEvent(2535);
    RegisterEvent(2540);
    RegisterEvent(2550);
    RegisterEvent(2560);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(2565);
    RegisterEvent(9570);
    RegisterEvent(3550);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int nX, int nY)
{
    // End:0x97
    if(GetWindowHandle("InventoryViewer").IsShowWindow())
    {
        GetWindowHandle("InventoryViewer").SetFocus();
        GetWindowHandle(getCurrentWindowName(string(self))).SetFocus();
        // End:0x97
        if(GetWindowHandle("DialogBox").IsShowWindow())
        {
            GetWindowHandle("DialogBox").SetFocus();
        }
    }
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    getInstanceInventoryViewer().showWindowByParentWindow(Me);
    bFirstAdd = true;
    Search_EditBox.SetString("");
    ItemCount_EditBox.SetString("1");
    disableWindowWithText(false, "");
    DisableWnd.HideWindow();
    return;
}

function OnHide()
{
    local ItemInfo nullInfo;

    lastSelectItemInfo = nullInfo;
    bClose = false;
    Me.DisableTick();
    useTick = false;
    // End:0x39
    if(DialogIsMine())
    {
        DialogHide();
    }
    Me.KillTimer(1235552);
    iniListWithItemWindow();
    // End:0x98
    if(GetWindowHandle("InventoryViewer").IsShowWindow())
    {
        GetWindowHandle("InventoryViewer").HideWindow();
    }
    return;
}

function Initialize()
{
    util = L2Util(GetScript("L2Util"));
    UIDataScript = UIData(GetScript("UIData"));
    Me = GetWindowHandle("MultiSellWnd");
    DisableWnd = GetWindowHandle("MultiSellWnd.DisableWnd");
    ItemInfo_Text = GetTextBoxHandle("MultiSellWnd.ItemInfo_Text");
    NeedItem_Text = GetTextBoxHandle("MultiSellWnd.NeedItem_Text");
    ExchangeNum_Text = GetTextBoxHandle("MultiSellWnd.ExchangeNum_Text");
    DescriptionMsg_Text = GetTextBoxHandle("MultiSellWnd.DescriptionMsgWnd.DescriptionMsg_Text");
    MultiSellTab = GetTabHandle("MultiSellWnd.MultiSellTab");
    MultisellTabTotalWnd = GetWindowHandle("MultiSellWnd.MultisellTabTotalWnd");
    MultisellTabTotalWnd_ListCtrl = GetListCtrlHandle("MultiSellWnd.MultisellTabTotalWnd.MultisellTabTotalWnd_ListCtrl");
    MultisellTabTotalWnd_ItemWindow = GetItemWindowHandle("MultiSellWnd.MultisellTabTotalWnd.MultisellTabTotalWnd_ItemWindow");
    MultisellTabEnableWnd = GetWindowHandle("MultiSellWnd.MultisellTabEnableWnd");
    MultisellTabEnableWnd_ListCtrl = GetListCtrlHandle("MultiSellWnd.MultisellTabEnableWnd.MultisellTabEnableWnd_ListCtrl");
    MultisellTabEnableWnd_ItemWindow = GetItemWindowHandle("MultiSellWnd.MultisellTabEnableWnd.MultisellTabEnableWnd_ItemWindow");
    Search_EditBox = GetEditBoxHandle("MultiSellWnd.Search_EditBox");
    ItemCount_EditBox = GetEditBoxHandle("MultiSellWnd.ItemCount_EditBox");
    NeededItem_TreeCtrl = GetTreeHandle("MultiSellWnd.NeededItem_TreeCtrl");
    Search_Button = GetButtonHandle("MultiSellWnd.Search_Button");
    Refrash_Button = GetButtonHandle("MultiSellWnd.Refrash_Button");
    Clear_Button = GetButtonHandle("MultiSellWnd.Clear_Button");
    ExChange_Button = GetButtonHandle("MultiSellWnd.ExChange_Button");
    Close_Button = GetButtonHandle("MultiSellWnd.Close_Button");
    IconTabIcon_Button = GetButtonHandle("MultiSellWnd.IconTabIcon_Button");
    ListTabIcon_Button = GetButtonHandle("MultiSellWnd.ListTabIcon_Button");
    MultiSell_Up_Button = GetButtonHandle("MultiSellWnd.MultiSell_Up_Button");
    MultiSell_Down_Button = GetButtonHandle("MultiSellWnd.MultiSell_Down_Button");
    MultiSell_Input_Button = GetButtonHandle("MultiSellWnd.MultiSell_Input_Button");
    InventoryViewerCall_Button = GetButtonHandle("MultiSellWnd.InventoryViewerCall_Button");
    MultisellTabTotalWnd_ListCtrl.SetSelectedSelTooltip(false);
    MultisellTabTotalWnd_ListCtrl.SetAppearTooltipAtMouseX(true);
    MultisellTabEnableWnd_ListCtrl.SetSelectedSelTooltip(false);
    MultisellTabEnableWnd_ListCtrl.SetAppearTooltipAtMouseX(true);
    IconTabIcon_Button.SetTooltipText(GetSystemString(3397));
    ListTabIcon_Button.SetTooltipText(GetSystemString(3397));
    toggleListWithIconWindow(true);
    PreviewMultisellIDs = Arr(GetSectorString("MULTISELL", "PREVIEW_MULTISELL_IDS"), ",");
    return;
}

function toggleListWithIconWindow(optional bool bInit)
{
    // End:0x27
    if(bInit)
    {
        IconTabIcon_Button.HideWindow();
        ListTabIcon_Button.ShowWindow();
    }
    // End:0x2BB
    if(ListTabIcon_Button.IsShowWindow())
    {
        IconTabIcon_Button.ShowWindow();
        ListTabIcon_Button.HideWindow();
        MultisellTabTotalWnd_ItemWindow.HideWindow();
        MultisellTabTotalWnd_ListCtrl.ShowWindow();
        MultisellTabEnableWnd_ItemWindow.HideWindow();
        MultisellTabEnableWnd_ListCtrl.ShowWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg1_Texture_MultisellTabIconWnd").HideWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg2_Texture_MultisellTabIconWnd").HideWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg1_Texture_MultisellTabIconWnd").HideWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg2_Texture_MultisellTabIconWnd").HideWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listGroupBg_Texture_MultisellTabIistWnd").ShowWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listGroupBg_Texture_MultisellTabIistWnd").ShowWindow();        
    }
    else
    {
        IconTabIcon_Button.HideWindow();
        ListTabIcon_Button.ShowWindow();
        MultisellTabTotalWnd_ListCtrl.HideWindow();
        MultisellTabTotalWnd_ItemWindow.ShowWindow();
        MultisellTabEnableWnd_ListCtrl.HideWindow();
        MultisellTabEnableWnd_ItemWindow.ShowWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg1_Texture_MultisellTabIconWnd").ShowWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listSlotBg2_Texture_MultisellTabIconWnd").ShowWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg1_Texture_MultisellTabIconWnd").ShowWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listSlotBg2_Texture_MultisellTabIconWnd").ShowWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabEnableWnd.listGroupBg_Texture_MultisellTabIistWnd").HideWindow();
        GetTextureHandle("MultiSellWnd.MultisellTabTotalWnd.listGroupBg_Texture_MultisellTabIistWnd").HideWindow();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x71
        case 2530:
            Debug("ï¿½ï¿½ï¿½ï¿½: EV_MultiSellInfoListBegin" @ param);
            // End:0x67
            if(!bClose)
            {
                HandleMultiSellInfoListBegin(param);
            }
            __var5842 = 0;
            // End:0x1C6
            break;
        // End:0x92
        case 2535:
            // End:0x8F
            if(!bClose)
            {
                HandleMultiSellResultItemInfo(param);
            }
            // End:0x1C6
            break;
        // End:0xBA
        case 2540:
            // End:0xB0
            if(!bClose)
            {
                HandelMultiSellOutputItemInfo(param);
            }
            __var5842++;
            // End:0x1C6
            break;
        // End:0xDB
        case 2550:
            // End:0xD8
            if(!bClose)
            {
                HandelMultiSellInputItemInfo(param);
            }
            // End:0x1C6
            break;
        // End:0x144
        case 2560:
            __var5842 = 0;
            Me.DisableTick();
            useTick = false;
            Me.KillTimer(1235552);
            // End:0x130
            if(bClose)
            {
                Me.HideWindow();                
            }
            else
            {
                HandleMultiSellInfoListEnd(param);
                ShowItemList();
            }
            // End:0x1C6
            break;
        // End:0x156
        case 1710:
            HandleDialogOK(true);
            // End:0x1C6
            break;
        // End:0x168
        case 1720:
            HandleDialogOK(false);
            // End:0x1C6
            break;
        // End:0x17E
        case 2565:
            HandleMultiSellResult(param);
            // End:0x1C6
            break;
        // End:0x1A7
        case 9570:
            // End:0x1A4
            if(Me.IsShowWindow())
            {
                updateMultiSellData();
                updateUIControl();
            }
            // End:0x1C6
            break;
        // End:0x1BD
        case 3550:
            testZZZ(param);
            // End:0x1C6
            break;
        // End:0xFFFF
        default:
            // End:0x1C6
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1C6
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1C6
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1C6
}

function testZZZ(string __var18742)
{
    local int __var18746;

    ParseInt(__var18742, "EventID", __var18746);
    switch(__var18746)
    {
        // End:0x36
        case 1500:
            testDDD(__var18742);
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            // End:0x3C
            break;
            break;
    }
    return;
}

function testDDD(string __var18750)
{
    local int __var6029;
    local string __var18756, __var18760;
    local array<string> Min, Max;
    local SCurrentMultisellExInfo __var11157;

    ParseString(__var18750, "param1", __var18756);
    ParseString(__var18750, "param2", __var18760);
    Min = Arr(__var18756, ",");
    Max = Arr(__var18760, ",");
    __var1861.Remove(0, __var1861.Length);
    __var6029 = 0;
    J0x6C:

    // End:0xC8 [Loop If]
    if(__var6029 < Min.Length)
    {
        __var11157.__var3687 = int(Min[__var6029]);
        __var11157.__var18628 = int(Max[__var6029]);
        __var1861[__var1861.Length] = __var11157;
        __var6029++;
        // [Loop Continue]
        goto J0x6C;
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x54
    if(TimerID == 1235552)
    {
        Me.DisableTick();
        useTick = false;
        // End:0x3A
        if(isExchangeWindowState())
        {
            setSelectItem(lastSelectItemInfo);
        }
        updateUIControl();
        Me.KillTimer(1235552);
    }
    return;
}

function ClearAll()
{
    Me.KillTimer(1235552);
    m_nCurrentMultiSellInfoIndex = 0;
    m_MultiSellInfoList.Length = 0;
    m_MultiSellGroupID = 0;
    ItemCount_EditBox.SetString("1");
    disableWindowWithText(false, "");
    DisableWnd.HideWindow();
    iniListWithItemWindow();
    return;
}

function iniListWithItemWindow()
{
    ItemCount_EditBox.SetString("1");
    MultisellTabTotalWnd_ListCtrl.DeleteAllItem();
    MultisellTabTotalWnd_ItemWindow.Clear();
    MultisellTabEnableWnd_ItemWindow.Clear();
    MultisellTabEnableWnd_ListCtrl.DeleteAllItem();
    Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.multiSellItemInfo");
    NeededItem_TreeCtrl.Clear();
    return;
}

function HandleMultiSellInfoListBegin(string param)
{
    local ItemInfo nullInfo;

    bShowVariationItem = 0;
    ParseInt(param, "ShowAll", nShowAll);
    ParseInt(param, "Repeat", nRepeat);
    ParseInt(param, "ShowVariationItem", bShowVariationItem);
    ParseInt(param, "KeepEnchant", nKeepEnchant);
    // End:0xA0
    if(!nRepeat == 1 && nShowAll == 1)
    {
        bFirstAdd = true;
        ClearAll();
    }
    // End:0xB6
    if(nRepeat == 0)
    {
        lastSelectItemInfo = nullInfo;
    }
    ParseInt(param, "MultiSellGroupID", m_MultiSellGroupID);
    bIsPreviewMultisell = isPreviewMultisell();
    // End:0x11A
    if(bIsPreviewMultisell)
    {
        GetTextBoxHandle("MultisellWnd.PreviewTxt").ShowWindow();        
    }
    else
    {
        GetTextBoxHandle("MultisellWnd.PreviewTxt").HideWindow();
    }
    // End:0x15D
    if(nRepeat == 1)
    {
        m_nCurrentMultiSellInfoIndex = 0;
        m_MultiSellInfoList.Length = 0;
    }
    return;
}

function HandleMultiSellResult(string param)
{
    local int Success;

    Debug("--------HandleMultiSellResult param" @ param);
    // End:0x15F
    if(Me.IsShowWindow())
    {
        Me.DisableTick();
        useTick = false;
        Me.KillTimer(1235552);
        // End:0xEB
        if((dialogMessage == GetSystemMessage(4363)) && (hasExceptionMultiSellID()) == false)
        {
            Debug("ï¿½ï¿½Æ¼ï¿½ï¿½ ï¿½Ý±ï¿½ ï¿½ï¿½ï¿½ï¿½");
            bClose = true;            
        }
        else
        {
            ParseInt(param, "Success", Success);
            getCurrentSelectedItemInfo(lastSelectItemInfo);
            updateMultiSellData(param);
            bClose = false;
            Debug("ï¿½ï¿½Æ¼ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½");
        }
    }
    return;
}

function bool hasExceptionMultiSellID()
{
    local bool bFlag;

    switch(m_MultiSellGroupID)
    {
        // End:0x17
        case 903:
            bFlag = true;
        // End:0x27
        case 2196:
            bFlag = true;
        // End:0xFFFF
        default:
            return bFlag;
            break;
    }    
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
    m_MultiSellInfoList.Length = m_MultiSellInfoList.Length + 1;
    nRepeatTimeCurrentInputItemInfoIndex = 0;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID = nMultiSellInfoID;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellType = nBuyType;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].ResultItemInfo = Info;
    return;
}

function HandelMultiSellOutputItemInfo(string param)
{
    local int nMultiSellInfoID, nCurrentOutputItemInfoIndex;
    local ItemInfo Info;
    local int nItemClassID, __var34810, __var34809, __var34807, __var34806;

    local bool __var34801;

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
    Info.BR_CurrentEnergy = __var1861[__var5842].__var3687;
    Info.BR_MaxEnergy = __var1861[__var5842].__var18628;
    // End:0x2D3
    if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
    {
        return;
    }
    // End:0x339
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
        // End:0x3BF
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
            // End:0x430
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
                // End:0x4AA
                if(nItemClassID == -500)
                {
                    Info.Name = GetSystemString(3183);
                    Info.IconName = "icon.etc_i.etc_rp_point_i00";
                    Info.Enchanted = 0;
                    Info.ItemType = -1;
                    Info.Id.ClassID = 0;
                }
            }
        }
    }
    // End:0x4CF
    if(0 < Info.Durability)
    {
        Info.CurrentDurability = Info.Durability;
    }
    nCurrentOutputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length = nCurrentOutputItemInfoIndex + 1;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = Info;
    m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex].Reserved = m_nCurrentMultiSellInfoIndex;
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
    ParseInt(param, "EnsoulOptionNum_" $ string(2), ensoulBmSlot);
    ParseInt(param, "EnsoulOptionNum_" $ string(1), ensoulNormalSlot);
    addEnsoulInfo(2, ensoulBmSlot, param, Info);
    addEnsoulInfo(1, ensoulNormalSlot, param, Info);
    // End:0x2F7
    if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
    {
        return;
    }
    // End:0x35D
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
        // End:0x3E3
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
            // End:0x454
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
                // End:0x4D1
                if(nItemClassID == -500)
                {
                    Info.Name = GetSystemString(3183);
                    Info.IconName = "icon.etc_i.etc_rp_point_i00";
                    Info.Enchanted = 0;
                    Info.ItemType = -1;
                    Info.Id.ClassID = 0;                    
                }
                else
                {
                    Info.Name = Class'NWindow.UIDATA_ITEM'.static.GetItemName(Info.Id);
                    Info.IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(Info.Id);
                }
            }
        }
    }
    Info.CrystalType = Class'NWindow.UIDATA_ITEM'.static.GetItemCrystalType(Info.Id);
    // End:0x599
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
    // End:0x23
    if(!Me.IsShowWindow())
    {
        Me.ShowWindow();
    }
    updateMultiSellData();
    return;
}

function OnTick()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x1AF [Loop If]
    if(i < 50)
    {
        tickItemAdd();
        tickItemListIndex++;
        // End:0x1A5
        if(tickItemListIndex >= m_MultiSellInfoList.Length)
        {
            Me.DisableTick();
            useTick = false;
            Debug("ï¿½ï¿½ï¿½ï¿½ bForceUpdate" @ string(bForceUpdate));
            bFirstAdd = false;
            bForceUpdate = false;
            // End:0x12E
            if(searchMode)
            {
                // End:0xED
                if(MultiSellTab.GetTopIndex() == 0)
                {
                    // End:0xE1
                    if(MultisellTabTotalWnd_ItemWindow.GetItemNum() <= 0)
                    {
                        disableWindowWithText(true, MakeFullSystemMsg(GetSystemMessage(4356), searchStr));                        
                    }
                    else
                    {
                        disableWindowWithText(false, "");
                    }                    
                }
                else
                {
                    // End:0x122
                    if(MultisellTabEnableWnd_ItemWindow.GetItemNum() <= 0)
                    {
                        disableWindowWithText(true, MakeFullSystemMsg(GetSystemMessage(4356), searchStr));                        
                    }
                    else
                    {
                        disableWindowWithText(false, "");
                    }
                }                
            }
            else
            {
                // End:0x16F
                if((MultiSellTab.GetTopIndex() == 1) && MultisellTabEnableWnd_ItemWindow.GetItemNum() <= 0)
                {
                    disableWindowWithText(true, GetSystemMessage(4357));                    
                }
                else
                {
                    disableWindowWithText(false, "");
                }
            }
            Me.KillTimer(1235552);
            Me.SetTimer(1235552, 10);
            // [Explicit Break]
            goto J0x1AF;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x1AF:

    return;
}

function tickItemAdd()
{
    local int i;
    local ItemInfo Info;
    local string fullNameString;
    local array<NoStackableItemData> NoStackableItemDataArray;
    local bool bNoExchange, bCheck;
    local int arrayIndex, N;

    i = tickItemListIndex;
    // End:0x398
    if(m_MultiSellInfoList.Length > i)
    {
        Info = m_MultiSellInfoList[i].OutputItemInfoList[0];
        // End:0x62
        if(bFirstAdd || isExchangeWindowState())
        {
            Search_EditBox.AddNameToAdditionalSearchList(Info.Name, 3);
        }
        fullNameString = GetItemNameAll(Info);
        // End:0x398
        if(((findMatchString(fullNameString, searchStr)) != -1) || searchMode == false)
        {
            bNoExchange = false;
            NoStackableItemDataArray.Length = 0;
            N = 0;
            J0xB2:

            // End:0x207 [Loop If]
            if(N < m_MultiSellInfoList[i].InputItemInfoList.Length)
            {
                // End:0x193
                if(IsStackableItem(m_MultiSellInfoList[i].InputItemInfoList[N].ConsumeType))
                {
                    bCheck = compareWithInven(m_MultiSellInfoList[i].InputItemInfoList[N]);
                    Debug("ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½.. bCheck" @ string(bCheck));                    
                }
                else
                {
                    arrayIndex = getNoStackableItemCountArrayIndex(m_MultiSellInfoList[i].InputItemInfoList[N], NoStackableItemDataArray, true);
                    bCheck = compareWithInven(m_MultiSellInfoList[i].InputItemInfoList[N], NoStackableItemDataArray[arrayIndex]);
                }
                // End:0x1FD
                if(bCheck == false)
                {
                    bNoExchange = true;
                }
                N++;
                // [Loop Continue]
                goto J0xB2;
            }
            // End:0x22F
            if(Info.BR_MaxEnergy > 0)
            {
                // End:0x22F
                if(Info.BR_CurrentEnergy == 0)
                {
                    bNoExchange = true;
                }
            }
            // End:0x298
            if(!bNoExchange)
            {
                Info.ForeTexture = "L2UI_CT1.SellablePanel";
                MultisellTabEnableWnd_ItemWindow.AddItem(Info);
                addItem_ListCtrl(MultisellTabEnableWnd_ListCtrl, Info, m_MultiSellInfoList[i].OutputItemInfoList.Length > 1);                
            }
            else
            {
                Info.ForeTexture = "Icon.icon_panel.ItemLock_Panel";
                MultisellTabEnableWnd_ItemWindow.AddItem(Info);
                addItem_ListCtrl(MultisellTabEnableWnd_ListCtrl, Info, m_MultiSellInfoList[i].OutputItemInfoList.Length > 1);
            }
            // End:0x34A
            if(bFirstAdd || bForceUpdate)
            {
                MultisellTabTotalWnd_ItemWindow.AddItem(Info);
                addItem_ListCtrl(MultisellTabTotalWnd_ListCtrl, Info, m_MultiSellInfoList[i].OutputItemInfoList.Length > 1);                
            }
            else
            {
                // End:0x398
                if((isExchangeWindowState()) == false)
                {
                    MultisellTabTotalWnd_ItemWindow.SetItem(i, Info);
                    setItem_ListCtrl(MultisellTabTotalWnd_ListCtrl, i, Info, m_MultiSellInfoList[i].OutputItemInfoList.Length > 1);
                }
            }
        }
    }
    return;
}

function ShowItemList()
{
    searchStr = Search_EditBox.GetString();
    // End:0x61
    if(searchStr != "")
    {
        searchMode = true;
        bFirstAdd = true;
        Debug("ï¿½Ë»ï¿½ï¿½ï¿½ï¿½ On");        
    }
    else
    {
        searchMode = false;
        Debug("ï¿½ï¿½Ã¼ ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ On");
    }
    setButtonEnable(false);
    Debug("searchMode: " @ string(searchMode));
    Debug("bFirstAdd: " @ string(bFirstAdd));
    Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.multiSellItemInfo");
    NeededItem_TreeCtrl.Clear();
    // End:0x1E8
    if(bFirstAdd || bForceUpdate)
    {
        Debug("-------> ï¿½ï¿½ï¿½ï¿½Æ®, ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ ï¿½Ê±ï¿½È­");
        iniListWithItemWindow();
        Search_EditBox.ClearAdditionalSearchList(3);
    }
    // End:0x2AE
    if(isExchangeWindowState())
    {
        Debug("-------> ï¿½ï¿½È¯ ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ ï¿½Ê±ï¿½È­");
        ItemCount_EditBox.SetString("1");
        MultisellTabEnableWnd_ItemWindow.Clear();
        MultisellTabEnableWnd_ListCtrl.DeleteAllItem();
    }
    tickItemListIndex = 0;
    useTick = true;
    Me.EnableTick();
    return;
}

function bool isExchangeWindowState()
{
    return (MultiSellTab.GetTopIndex() == 1) || bForceUpdate;
    return;
}

function disableWindowWithText(bool bShow, string msgTxt)
{
    // End:0x50
    if(bShow)
    {
        DescriptionMsg_Text.SetText(msgTxt);
        GetWindowHandle("MultiSellWnd.DescriptionMsgWnd").ShowWindow();        
    }
    else
    {
        GetWindowHandle("MultiSellWnd.DescriptionMsgWnd").HideWindow();
    }
    return;
}

function bool compareWithInven(ItemInfo Info, optional NoStackableItemData noStackableItemDataInfo)
{
    local ItemInfo InvenItemInfo;
    local bool flag;
    local int hasItemCount;
    local array<ItemInfo> itemInfoArr;

    // End:0x36
    if(Info.IconName == (GetPcCafeItemIconPackageName()))
    {
        // End:0x33
        if(__NFUN_411__((mData.pcCafePoint), Info.ItemNum))
        {
            return true;
        }        
    }
    else
    {
        // End:0x8C
        if(Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00")
        {
            // End:0x89
            if(__NFUN_411__((mData.clanPoint), Info.ItemNum))
            {
                return true;
            }            
        }
        else
        {
            // End:0xD0
            if(Info.IconName == "icon.pvp_point_i00")
            {
                // End:0xCD
                if(__NFUN_411__((mData.PvPPoint), Info.ItemNum))
                {
                    return true;
                }                
            }
            else
            {
                // End:0x11D
                if(Info.IconName == "icon.etc_i.etc_rp_point_i00")
                {
                    // End:0x11A
                    if(__NFUN_411__((mData.RaidPoint), Info.ItemNum))
                    {
                        return true;
                    }                    
                }
                else
                {
                    // End:0x1EC
                    if(Info.Id.ClassID > 0)
                    {
                        itemInfoArr.Length = 0;
                        hasItemCount = getInstanceL2Util().FindItemByClassID(Info.Id.ClassID, itemInfoArr, getInstanceL2Util().2);
                        // End:0x1EC
                        if(hasItemCount > 0)
                        {
                            InvenItemInfo = itemInfoArr[0];
                            // End:0x1BA
                            if(IsStackableItem(InvenItemInfo.ConsumeType))
                            {
                                // End:0x1B7
                                if(__NFUN_411__(InvenItemInfo.ItemNum, Info.ItemNum))
                                {
                                    return true;
                                }                                
                            }
                            else
                            {
                                // End:0x1E5
                                if(noStackableItemDataInfo.ClassID > 0)
                                {
                                    // End:0x1E5
                                    if(__NFUN_409__(noStackableItemDataInfo.Count, (0)))
                                    {
                                        flag = true;
                                    }
                                }
                                return flag;
                            }
                        }
                    }
                }
            }
        }
    }
    return false;
    return;
}

function addItem_ListCtrl(ListCtrlHandle ItemListCtrl, ItemInfo Info, optional bool bSet)
{
    local LVDataRecord Record;
    local string param, fullNameString;
    local bool __var11078;

    fullNameString = GetItemNameAll(Info);
    ItemInfoToParam(Info, param);
    Record.szReserved = param;
    Record.nReserved1 = (Info.Id.ClassID);
    Record.LVDataList.Length = 3;
    // End:0xD3
    if(IsStackableItem(Info.ConsumeType))
    {
        fullNameString = makeShortStringByPixel(fullNameString, 212, "..");
        // End:0xBE
        if(__NFUN_409__(Info.ItemNum, (0)))
        {
            fullNameString = ((fullNameString $ "(") $ (Info.ItemNum)) $ ")";            
        }
        else
        {
            fullNameString = fullNameString $ "(1)";
        }        
    }
    else
    {
        fullNameString = makeShortStringByPixel(fullNameString, 215, "..");
    }
    // End:0x115
    if(bSet)
    {
        fullNameString = ((fullNameString @ "(") $ GetSystemString(7651)) $ ")";
    }
    ItemInfoToParam(Info, param);
    Record.szReserved = param;
    Record.LVDataList[0].szData = fullNameString;
    Record.LVDataList[0].hasIcon = true;
    Record.LVDataList[0].nTextureWidth = 32;
    Record.LVDataList[0].nTextureHeight = 32;
    Record.LVDataList[0].nTextureU = 32;
    Record.LVDataList[0].nTextureV = 32;
    Record.LVDataList[0].szTexture = Info.IconName;
    Record.LVDataList[0].IconPosX = 10;
    Record.LVDataList[0].FirstLineOffsetX = 6;
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
    Record.LVDataList[0].foreTextureName = Info.ForeTexture;
    __var11078 = Info.BR_MaxEnergy > 0;
    // End:0x410
    if(__var11078)
    {
        Record.LVDataList[1].textAlignment = 1;
        Record.LVDataList[1].bUseTextColor = true;
        Record.LVDataList[1].TextColor = GetColorByValue(Info.BR_CurrentEnergy, Info.BR_MaxEnergy);
        Record.LVDataList[1].szData = (string(Info.BR_CurrentEnergy) $ "/") $ string(Info.BR_MaxEnergy);
        Record.LVDataList[1].FirstLineOffsetX = 2;
    }
    ItemListCtrl.InsertRecord(Record);
    return;
}

function Color GetColorByValue(int cur, int Max)
{
    local float __var9291;
    local Color C;

    // End:0x12
    if(Max <= 0)
    {
        Max = 1;
    }
    __var9291 = FClamp(float(cur / Max), 0.0000000, 1.0000000);
    C.R = byte(80 + IsA(175, 1.0000000 - __var9291));
    C.G = byte(255 - IsA(195, 1.0000000 - __var9291));
    C.B = byte(80 - IsA(40, 1.0000000 - __var9291));
    C.A = byte(255);
    return C;
    return;
}

function setItem_ListCtrl(ListCtrlHandle ItemListCtrl, int sindex, ItemInfo Info, optional bool bSet)
{
    local LVDataRecord Record;
    local string param, fullNameString;
    local bool __var18970;

    fullNameString = GetItemNameAll(Info);
    ItemInfoToParam(Info, param);
    Record.szReserved = param;
    Record.nReserved1 = (Info.Id.ClassID);
    Record.LVDataList.Length = 3;
    // End:0xD3
    if(IsStackableItem(Info.ConsumeType))
    {
        fullNameString = makeShortStringByPixel(fullNameString, 212, "..");
        // End:0xBE
        if(__NFUN_409__(Info.ItemNum, (0)))
        {
            fullNameString = ((fullNameString $ "(") $ (Info.ItemNum)) $ ")";            
        }
        else
        {
            fullNameString = fullNameString $ "(1)";
        }        
    }
    else
    {
        fullNameString = makeShortStringByPixel(fullNameString, 230, "..");
    }
    // End:0x115
    if(bSet)
    {
        fullNameString = ((fullNameString @ "(") $ GetSystemString(7651)) $ ")";
    }
    ItemInfoToParam(Info, param);
    Record.szReserved = param;
    Record.LVDataList[0].szData = fullNameString;
    Record.LVDataList[0].hasIcon = true;
    Record.LVDataList[0].nTextureWidth = 32;
    Record.LVDataList[0].nTextureHeight = 32;
    Record.LVDataList[0].nTextureU = 32;
    Record.LVDataList[0].nTextureV = 32;
    Record.LVDataList[0].szTexture = Info.IconName;
    Record.LVDataList[0].IconPosX = 10;
    Record.LVDataList[0].FirstLineOffsetX = 6;
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
    Record.LVDataList[0].foreTextureName = Info.ForeTexture;
    __var18970 = Info.BR_MaxEnergy > 0;
    // End:0x410
    if(__var18970)
    {
        Record.LVDataList[1].textAlignment = 1;
        Record.LVDataList[1].bUseTextColor = true;
        Record.LVDataList[1].TextColor = GetColorByValue(Info.BR_CurrentEnergy, Info.BR_MaxEnergy);
        Record.LVDataList[1].szData = (string(Info.BR_CurrentEnergy) $ "/") $ string(Info.BR_MaxEnergy);
        Record.LVDataList[1].FirstLineOffsetX = 2;
    }
    Record.LVDataList[1].FirstLineOffsetX = 2;
    ItemListCtrl.ModifyRecord(sindex, Record);
    return;
}

function updateMultiSellData(optional string serverUpdateParam)
{
    local int nPointCount, nPoint, nType, N;

    GetPlayerInfo(PlayerInfo);
    ParseInt(serverUpdateParam, "NumPoint", nPointCount);
    N = 0;
    J0x2C:

    // End:0x158 [Loop If]
    if(N < nPointCount)
    {
        ParseInt(serverUpdateParam, "Type" $ string(N), nType);
        ParseInt(serverUpdateParam, "Point" $ string(N), nPoint);
        // End:0x9C
        if(-500 == nType)
        {
            mData.PvPPoint = nPoint;
            // [Explicit Continue]
            goto J0x14E;
        }
        // End:0xBE
        if(-300 == nType)
        {
            mData.PvPPoint = nPoint;
            // [Explicit Continue]
            goto J0x14E;
        }
        // End:0xF4
        if(-200 == nType)
        {
            mData.clanPoint = nPoint;
            UIDataScript.setCurrentClanNameValue(nPoint);
            // [Explicit Continue]
            goto J0x14E;
        }
        // End:0x14E
        if(-100 == nType)
        {
            mData.pcCafePoint = nPoint;
            UIDataScript.setPcCafePoint(nPoint);
            Debug("mData.pcCafePoint" @ string(mData.pcCafePoint));
        }
        J0x14E:

        N++;
        // [Loop Continue]
        goto J0x2C;
    }
    // End:0x1C1
    if(nPointCount <= 0)
    {
        mData.PvPPoint = PlayerInfo.PvPPoint;
        mData.RaidPoint = PlayerInfo.RaidPoint;
        mData.pcCafePoint = UIDataScript.getCurrentPcCafePoint();
        mData.clanPoint = UIDataScript.getCurrentClanNameValue();
    }
    return;
}

function HandleDialogOK(bool bOK)
{
    local string param;
    local int SelectedIndex, Id, tryExchangeCount;
    local INT64 inputNum;

    // End:0x3F2
    if(DialogIsMine())
    {
        DisableWnd.HideWindow();
        Id = DialogGetID();
        // End:0x3E3
        if(bOK)
        {
            // End:0x80
            if(Id == 1123)
            {
                inputNum = (DialogGetString());
                // End:0x61
                if(__NFUN_410__(inputNum, (0)))
                {
                    inputNum = (1);
                }
                ItemCount_EditBox.SetString((inputNum));
                setTreeNeedItemInfo();                
            }
            else
            {
                tryExchangeCount = int(ItemCount_EditBox.GetString());
                ItemCount_EditBox.SetString("1");
                setTreeNeedItemInfo();
                SelectedIndex = DialogGetReservedInt();
                // End:0xCD
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
                decrementLimit(m_nSelectedMultiSellInfoIndex, name(DialogGetReservedInt2()));
                Debug("RequestMultiSellChoose : " @ param);
                RequestMultiSellChoose(param);
            }            
        }
        else
        {
            DisableWnd.HideWindow();
        }
    }
    return;
}

function decrementLimit(int Index, int Count)
{
    local int __var34745;
    local ItemInfo rItemInfo;

    __var1861[Index].__var3687 = __var1861[Index].__var3687 - Count;
    MultisellTabTotalWnd_ItemWindow.GetSelectedItem(rItemInfo);
    rItemInfo.BR_CurrentEnergy = __var1861[Index].__var3687;
    m_MultiSellInfoList[Index].OutputItemInfoList[0].BR_CurrentEnergy = __var1861[Index].__var3687;
    MultisellTabTotalWnd_ItemWindow.SetItem(Index, rItemInfo);
    setItem_ListCtrl(MultisellTabTotalWnd_ListCtrl, Index, rItemInfo, false);
    MultisellTabEnableWnd_ItemWindow.SetItem(getEnabledIndex(rItemInfo), rItemInfo);
    setItem_ListCtrl(MultisellTabEnableWnd_ListCtrl, getEnabledIndex(rItemInfo), rItemInfo, false);
    return;
}

function int getEnabledIndex(ItemInfo item)
{
    local int i;
    local ItemInfo rItemInfo;

    i = 0;
    J0x07:

    // End:0x88 [Loop If]
    if(i < MultisellTabEnableWnd_ItemWindow.GetItemNum())
    {
        MultisellTabEnableWnd_ItemWindow.GetItem(i, rItemInfo);
        // End:0x7E
        if((item.Id.ClassID == rItemInfo.Id.ClassID) && __NFUN_412__(item.ItemNum, rItemInfo.ItemNum))
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnDBClickItem(string Name, int Index)
{
    // End:0x5F
    if((Name == "MultisellTabTotalWnd_ItemWindow") || Name == "MultisellTabEnableWnd_ItemWindow")
    {
        OnExChange_ButtonClick();
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    // End:0x18
    if(Me.IsShowWindow())
    {
        OnExChange_ButtonClick();
    }
    return;
}

function bool isPreviewMultisell()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x3A [Loop If]
    if(i < PreviewMultisellIDs.Length)
    {
        // End:0x30
        if(m_MultiSellGroupID == int(PreviewMultisellIDs[i]))
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    // End:0x63
    if(strID == "MultisellTabTotalWnd_ItemWindow")
    {
        updateMultiSellData();
        MultisellTabTotalWnd_ListCtrl.SetSelectedIndex(Index, true);
        Me.KillTimer(1235552);
        updateUIControl();        
    }
    else
    {
        // End:0xC4
        if(strID == "MultisellTabEnableWnd_ItemWindow")
        {
            updateMultiSellData();
            MultisellTabEnableWnd_ListCtrl.SetSelectedIndex(Index, true);
            Me.KillTimer(1235552);
            updateUIControl();
        }
    }
    requestPreview();
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    switch(ListCtrlID)
    {
        // End:0x6A
        case "MultisellTabTotalWnd_ListCtrl":
            updateMultiSellData();
            MultisellTabTotalWnd_ItemWindow.SetSelectedNum(MultisellTabTotalWnd_ListCtrl.GetSelectedIndex());
            Me.KillTimer(1235552);
            updateUIControl();
            // End:0xD4
            break;
        // End:0xCE
        case "MultisellTabEnableWnd_ListCtrl":
            updateMultiSellData();
            MultisellTabEnableWnd_ItemWindow.SetSelectedNum(MultisellTabEnableWnd_ListCtrl.GetSelectedIndex());
            Me.KillTimer(1235552);
            updateUIControl();
            // End:0xD4
            break;
        // End:0xFFFF
        default:
            // End:0xD4
            break;
            break;
    }
    requestPreview();
    return;
}

function requestPreview()
{
    local ItemInfo Info;

    // End:0x16
    if(!Class'NWindow.InputAPI'.static.IsAltPressed())
    {
        return;
    }
    // End:0x23
    if(!bIsPreviewMultisell)
    {
        return;
    }
    MultisellTabTotalWnd_ItemWindow.GetItem(MultisellTabTotalWnd_ItemWindow.GetSelectedNum(), Info);
    RequestBypassToServer("pri" @ string(Info.Id.ClassID));
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x3F
        case "InventoryViewerCall_Button":
            getInstanceInventoryViewer().showWindowByParentWindow(Me, true);
            // End:0x23B
            break;
        // End:0x5A
        case "Search_Button":
            OnSearch_ButtonClick();
            // End:0x23B
            break;
        // End:0x76
        case "Refrash_Button":
            OnRefrash_ButtonClick();
            // End:0x23B
            break;
        // End:0x90
        case "Clear_Button":
            OnClear_ButtonClick();
            // End:0x23B
            break;
        // End:0xAD
        case "ExChange_Button":
            OnExChange_ButtonClick();
            // End:0x23B
            break;
        // End:0xC7
        case "Close_Button":
            OnClose_ButtonClick();
            // End:0x23B
            break;
        // End:0xDE
        case "IconTabIcon_Button":
        // End:0xFE
        case "ListTabIcon_Button":
            toggleListWithIconWindow();
            // End:0x23B
            break;
        // End:0x11F
        case "MultiSell_Up_Button":
            OnMultiSell_Up_ButtonClick();
            // End:0x23B
            break;
        // End:0x148
        case "MultiSell_Down_Button":
            updateMultiSellData();
            OnMultiSell_Down_ButtonClick();
            // End:0x23B
            break;
        // End:0x172
        case "MultiSell_Input_Button":
            updateMultiSellData();
            OnPriceEditBtnHandler();
            // End:0x23B
            break;
        // End:0x1F2
        case "MultiSellTab0":
            MultiSellTab.SetTopOrder(0, true);
            disableWindowWithText(false, "");
            // End:0x1DB
            if((Search_EditBox.GetString() == "") && MultisellTabTotalWnd_ItemWindow.GetItemNum() != m_MultiSellInfoList.Length)
            {
                bForceUpdate = true;                
            }
            else
            {
                bForceUpdate = false;
            }
            ShowItemList();
            updateUIControl();
            // End:0x23B
            break;
        // End:0x235
        case "MultiSellTab1":
            MultiSellTab.SetTopOrder(1, true);
            disableWindowWithText(false, "");
            bForceUpdate = false;
            ShowItemList();
            updateUIControl();
            // End:0x23B
            break;
        // End:0xFFFF
        default:
            // End:0x23B
            break;
            break;
    }
    return;
}

function OnExChange_ButtonClick()
{
    local int i, SelectedIndex, inputItemLen;
    local INT64 ItemNum;
    local ItemInfo rItemInfo, inputItemInfo;
    local bool hasEItemcheck;

    // End:0x1D3
    if(getCurrentSelectedItemInfo(rItemInfo))
    {
        SelectedIndex = rItemInfo.Reserved;
        ItemNum = (ItemCount_EditBox.GetString());
        inputItemLen = m_MultiSellInfoList[SelectedIndex].InputItemInfoList.Length;
        i = 0;
        J0x53:

        // End:0xD6 [Loop If]
        if(i < inputItemLen)
        {
            inputItemInfo = m_MultiSellInfoList[SelectedIndex].InputItemInfoList[i];
            // End:0xCC
            if(((inputItemInfo.ItemType == 0) || inputItemInfo.ItemType == 1) || inputItemInfo.ItemType == 2)
            {
                // End:0xCC
                if((isPointType(inputItemInfo)) == false)
                {
                    hasEItemcheck = true;
                }
            }
            i++;
            // [Loop Continue]
            goto J0x53;
        }
        // End:0x12B
        if((rItemInfo.BR_CurrentEnergy == 0) && rItemInfo.BR_MaxEnergy > 0)
        {
            dialogMessage = GetSystemString(9004);
            AddSystemMessageString(dialogMessage);
            getInstanceL2Util().showGfxScreenMessage(dialogMessage);
            return;
        }
        // End:0x148
        if(hasEItemcheck)
        {
            dialogMessage = GetSystemMessage(4363);            
        }
        else
        {
            dialogMessage = GetSystemMessage(1383);
        }
        // End:0x1D3
        if(SelectedIndex >= 0)
        {
            DisableWnd.ShowWindow();
            DisableWnd.SetFocus();
            DialogSetReservedInt(SelectedIndex);
            DialogSetReservedInt2(ItemNum);
            DialogSetID(1122);
            DialogSetCancelD(1122);
            DialogSetString("");
            DialogShow(1, 4, dialogMessage, string(self));
            m_nSelectedMultiSellInfoIndex = SelectedIndex;
        }
    }
    return;
}

function OnPriceEditBtnHandler()
{
    local ItemInfo Info;

    DisableWnd.ShowWindow();
    DisableWnd.SetFocus();
    DialogSetID(1123);
    DialogSetEditBoxMaxLength(6);
    DialogSetCancelD(1123);
    DialogSetReservedItemID(Info.Id);
    DialogSetEditType("number");
    DialogSetParamInt64((-1));
    DialogSetDefaultOK();
    DialogShow(1, 6, GetSystemMessage(4362), string(self));
    return;
}

function OnSearch_ButtonClick()
{
    local string searchStr;

    searchStr = Search_EditBox.GetString();
    // End:0x2A
    if(searchStr == "")
    {
        OnRefrash_ButtonClick();        
    }
    else
    {
        ShowItemList();
    }
    return;
}

function OnRefrash_ButtonClick()
{
    ItemCount_EditBox.SetString("1");
    disableWindowWithText(false, "");
    DisableWnd.HideWindow();
    bForceUpdate = true;
    Search_EditBox.SetString("");
    updateMultiSellData();
    ShowItemList();
    updateUIControl();
    return;
}

function OnClear_ButtonClick()
{
    ItemCount_EditBox.SetString("1");
    updateMultiSellData();
    updateItemInfo();
    setTreeNeedItemInfo();
    return;
}

function OnClose_ButtonClick()
{
    Me.HideWindow();
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
        setTreeNeedItemInfo();
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
        setTreeNeedItemInfo();
    }
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    local string mainKey;

    // End:0x46
    if(Search_EditBox.IsFocused())
    {
        mainKey = Class'NWindow.InputAPI'.static.GetKeyString(nKey);
        // End:0x43
        if(mainKey == "ENTER")
        {
            ShowItemList();
        }        
    }
    else
    {
        // End:0x9D
        if(ItemCount_EditBox.IsFocused())
        {
            // End:0x81
            if(ItemCount_EditBox.GetString() == "0")
            {
                ItemCount_EditBox.SetString("1");
            }
            // End:0x9D
            if(ItemCount_EditBox.GetString() != "")
            {
                setTreeNeedItemInfo();
            }
        }
    }
    return;
}

function updateUIControl()
{
    setEditStateItemCount();
    updateItemInfo();
    setTreeNeedItemInfo();
    return;
}

function updateItemInfo()
{
    local int i, Index;
    local ItemInfo rItemInfo;

    // End:0x2E3
    if(getCurrentSelectedItemInfo(rItemInfo))
    {
        Index = rItemInfo.Reserved;
        // End:0x2F
        if(Index <= -1)
        {
            return;
        }
        Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.multiSellItemInfo");
        // End:0x2E3
        if((Index >= 0) && Index < m_MultiSellInfoList.Length)
        {
            i = 0;
            J0x82:

            // End:0x2E3 [Loop If]
            if(i < m_MultiSellInfoList[Index].OutputItemInfoList.Length)
            {
                Class'NWindow.UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("MultiSellWnd.multiSellItemInfo", i, m_MultiSellInfoList[Index].OutputItemInfoList[i]);
                // End:0x215
                if(m_MultiSellInfoList[Index].OutputItemInfoList[i].IconName == "icon.pvp_point_i00")
                {
                    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MultiSellWnd.PointItemName");
                    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MultiSellWnd.txtPointItemDescription");
                    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.PointItemName", (GetSystemString(102) $ "x") $ (m_MultiSellInfoList[Index].OutputItemInfoList[i].ItemNum));
                    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.txtPointItemDescription", GetSystemMessage(2334));
                    // [Explicit Continue]
                    goto J0x2D9;
                }
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MultiSellWnd.PointItemName");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MultiSellWnd.txtPointItemDescription");
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.PointItemName", "");
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.txtPointItemDescription", "");
                J0x2D9:

                i++;
                // [Loop Continue]
                goto J0x82;
            }
        }
    }
    return;
}

function int getIndexArray(int ClassID, out array<NoStackableItemData> NoStackableItemDataArray)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x41 [Loop If]
    if(i < NoStackableItemDataArray.Length)
    {
        // End:0x37
        if(NoStackableItemDataArray[i].ClassID == ClassID)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function int getNoStackableItemCountArrayIndex(ItemInfo inputItemInfo, out array<NoStackableItemData> NoStackableItemDataArray, optional bool onlyUNLOCKTYPE)
{
    local int arrayIndex, nClassID;
    local INT64 noStackableNeedItemNum;
    local array<ItemInfo> hasItemInfoArray;

    // End:0x159
    if(!IsStackableItem(inputItemInfo.ConsumeType))
    {
        nClassID = inputItemInfo.Id.ClassID;
        // End:0x62
        if(onlyUNLOCKTYPE)
        {
            noStackableNeedItemNum = (util.FindItemByClassID(nClassID, hasItemInfoArray, util.2));            
        }
        else
        {
            noStackableNeedItemNum = (Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(nClassID, hasItemInfoArray));
        }
        arrayIndex = getIndexArray(nClassID, NoStackableItemDataArray);
        // End:0x119
        if(arrayIndex == -1)
        {
            NoStackableItemDataArray.Length = NoStackableItemDataArray.Length + 1;
            // End:0xF8
            if(NoStackableItemDataArray.Length > 0)
            {
                NoStackableItemDataArray[NoStackableItemDataArray.Length - 1].ClassID = nClassID;
                NoStackableItemDataArray[NoStackableItemDataArray.Length - 1].Count = noStackableNeedItemNum;
            }
            // End:0x116
            if(arrayIndex == -1)
            {
                arrayIndex = NoStackableItemDataArray.Length - 1;
            }            
        }
        else
        {
            // End:0x159
            if(__NFUN_409__(NoStackableItemDataArray[arrayIndex].Count, (0)))
            {
                NoStackableItemDataArray[arrayIndex].Count = __NFUN_405__(NoStackableItemDataArray[arrayIndex].Count, (1));
            }
        }
    }
    return arrayIndex;
    return;
}

function setTreeNeedItemInfo()
{
    local int i, Index, arrayIndex;
    local bool __var4530, __var5551, __var34650, __var34649;
    local int __var3607;
    local ItemInfo rItemInfo;
    local array<NoStackableItemData> NoStackableItemDataArray;

    // End:0x593
    if(getCurrentSelectedItemInfo(rItemInfo))
    {
        Index = rItemInfo.Reserved;
        // End:0x2F
        if(Index <= -1)
        {
            return;
        }
        util.TreeClear("MultiSellWnd.NeededItem_TreeCtrl");
        util.TreeInsertRootNode("MultiSellWnd.NeededItem_TreeCtrl", "root", "", 0, 4);
        itemCountTextEditEnable(true);
        // End:0xBF
        if(!IsStackableItem(rItemInfo.ConsumeType))
        {
            itemCountTextEditEnable(false);
        }
        // End:0x25F
        if((Index >= 0) && Index < m_MultiSellInfoList.Length)
        {
            i = 0;
            J0xE3:

            // End:0x25F [Loop If]
            if(i < m_MultiSellInfoList[Index].InputItemInfoList.Length)
            {
                // End:0x153
                if(IsStackableItem(m_MultiSellInfoList[Index].InputItemInfoList[i].ConsumeType))
                {
                    addTreeNode("LIST" $ string(i + 1), m_MultiSellInfoList[Index].InputItemInfoList[i]);                    
                }
                else
                {
                    arrayIndex = getNoStackableItemCountArrayIndex(m_MultiSellInfoList[Index].InputItemInfoList[i], NoStackableItemDataArray, true);
                    // End:0x1CA
                    if(arrayIndex == -1)
                    {
                        addTreeNode("LIST" $ string(i + 1), m_MultiSellInfoList[Index].InputItemInfoList[i], NoStackableItemDataArray[NoStackableItemDataArray.Length - 1]);                        
                    }
                    else
                    {
                        addTreeNode("LIST" $ string(i + 1), m_MultiSellInfoList[Index].InputItemInfoList[i], NoStackableItemDataArray[arrayIndex]);
                    }
                }
                // End:0x255
                if((IsStackableItem(m_MultiSellInfoList[Index].InputItemInfoList[i].ConsumeType) == false) && (isPointType(m_MultiSellInfoList[Index].InputItemInfoList[i])) == false)
                {
                    itemCountTextEditEnable(false);
                }
                i++;
                // [Loop Continue]
                goto J0xE3;
            }
        }
        __var4530 = false;
        __var3607 = int(ItemCount_EditBox.GetString());
        // End:0x2A9
        if(rItemInfo.BR_MaxEnergy > 0)
        {
            __var4530 = rItemInfo.BR_CurrentEnergy >= __var3607;            
        }
        else
        {
            __var4530 = true;
        }
        // End:0x587
        if(__var4530)
        {
            i = 0;
            J0x2C1:

            // End:0x587 [Loop If]
            if(i < m_MultiSellInfoList[Index].InputItemInfoList.Length)
            {
                // End:0x355
                if(m_MultiSellInfoList[Index].InputItemInfoList[i].Id.ClassID > 0)
                {
                    __var5551 = __NFUN_411__(GetInventoryItemCount(m_MultiSellInfoList[Index].InputItemInfoList[i].Id), __NFUN_401__(m_MultiSellInfoList[Index].InputItemInfoList[i].ItemNum, (__var3607)));                    
                }
                else
                {
                    // End:0x3C9
                    if(m_MultiSellInfoList[Index].InputItemInfoList[i].IconName == (GetPcCafeItemIconPackageName()))
                    {
                        __var5551 = __NFUN_411__(getHasItemOrPointCount(m_MultiSellInfoList[Index].InputItemInfoList[i]), __NFUN_401__(m_MultiSellInfoList[Index].InputItemInfoList[i].ItemNum, (__var3607)));                        
                    }
                    else
                    {
                        // End:0x45D
                        if(m_MultiSellInfoList[Index].InputItemInfoList[i].IconName == "icon.etc_i.etc_bloodpledge_point_i00")
                        {
                            __var5551 = __NFUN_411__(getHasItemOrPointCount(m_MultiSellInfoList[Index].InputItemInfoList[i]), __NFUN_401__(m_MultiSellInfoList[Index].InputItemInfoList[i].ItemNum, (__var3607)));                            
                        }
                        else
                        {
                            // End:0x4DF
                            if(m_MultiSellInfoList[Index].InputItemInfoList[i].IconName == "icon.pvp_point_i00")
                            {
                                __var5551 = __NFUN_411__(getHasItemOrPointCount(m_MultiSellInfoList[Index].InputItemInfoList[i]), __NFUN_401__(m_MultiSellInfoList[Index].InputItemInfoList[i].ItemNum, (__var3607)));                                
                            }
                            else
                            {
                                // End:0x567
                                if(m_MultiSellInfoList[Index].InputItemInfoList[i].IconName == "icon.etc_i.etc_rp_point_i00")
                                {
                                    __var5551 = __NFUN_411__(getHasItemOrPointCount(m_MultiSellInfoList[Index].InputItemInfoList[i]), __NFUN_401__(m_MultiSellInfoList[Index].InputItemInfoList[i].ItemNum, (__var3607)));
                                }
                            }
                        }
                    }
                }
                // End:0x57D
                if(!__var5551)
                {
                    __var4530 = false;
                    // [Explicit Break]
                    goto J0x587;
                }
                i++;
                // [Loop Continue]
                goto J0x2C1;
            }
        }
        J0x587:

        setButtonEnable(__var4530);
    }
    return;
}

function bool checkEnableExchange(int tryExchangeCount)
{
    local int i, Index;
    local bool bHasItem;
    local ItemInfo rItemInfo, Info;

    getCurrentSelectedItemInfo(rItemInfo);
    Index = rItemInfo.Reserved;
    // End:0x2C
    if(Index <= -1)
    {
        return false;
    }
    bHasItem = true;
    // End:0xD7
    if((Index >= 0) && Index < m_MultiSellInfoList.Length)
    {
        i = 0;
        J0x58:

        // End:0xD7 [Loop If]
        if(i < m_MultiSellInfoList[Index].InputItemInfoList.Length)
        {
            Info = m_MultiSellInfoList[Index].InputItemInfoList[i];
            // End:0xCD
            if(__NFUN_409__(__NFUN_401__(Info.ItemNum, (tryExchangeCount)), getHasItemOrPointCount(m_MultiSellInfoList[Index].InputItemInfoList[i])))
            {
                bHasItem = false;
            }
            i++;
            // [Loop Continue]
            goto J0x58;
        }
    }
    return bHasItem;
    return;
}

function bool isPointType(ItemInfo Info)
{
    local bool RValue;

    // End:0x20
    if(Info.IconName == (GetPcCafeItemIconPackageName()))
    {
        RValue = true;        
    }
    else
    {
        // End:0x60
        if(Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00")
        {
            RValue = true;            
        }
        else
        {
            // End:0x8E
            if(Info.IconName == "icon.pvp_point_i00")
            {
                RValue = true;                
            }
            else
            {
                // End:0xC2
                if(Info.IconName == "icon.etc_i.etc_rp_point_i00")
                {
                    RValue = true;
                }
            }
        }
    }
    return RValue;
    return;
}

function INT64 getHasItemOrPointCount(ItemInfo Info)
{
    local INT64 hasNum;
    local array<ItemInfo> itemInfoArray;
    local int ItemCount;

    // End:0x2A
    if(Info.IconName == (GetPcCafeItemIconPackageName()))
    {
        hasNum = (mData.pcCafePoint);        
    }
    else
    {
        // End:0x74
        if(Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00")
        {
            hasNum = (mData.clanPoint);            
        }
        else
        {
            // End:0xAC
            if(Info.IconName == "icon.pvp_point_i00")
            {
                hasNum = (mData.PvPPoint);                
            }
            else
            {
                // End:0xED
                if(Info.IconName == "icon.etc_i.etc_rp_point_i00")
                {
                    hasNum = (mData.RaidPoint);                    
                }
                else
                {
                    ItemCount = Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(Info.Id.ClassID, itemInfoArray);
                    // End:0x133
                    if(ItemCount > 0)
                    {
                        hasNum = itemInfoArray[0].ItemNum;
                    }
                }
            }
        }
    }
    return hasNum;
    return;
}

function bool addTreeNode(string nodeLine, ItemInfo Info, optional NoStackableItemData noStackableItemDataInfo)
{
    local ItemInfo InvenItemInfo;
    local string strRetName, gradeTextureName;
    local int textHeight;
    local string enchantedStr, ItemName, AdditionalName, stackableAddStr, shortItemName, ensoulOptionAllName;

    local int enchantedStr_width, additionalName_width, stackableAddStr_width, ensoulOptionAllName_width, gradeTextureName_width;

    local INT64 hasNum;
    local bool bHasItem;
    local int tryExchangeCount;
    local array<ItemInfo> itemInfoArray;
    local int ItemCount;

    tryExchangeCount = int(ItemCount_EditBox.GetString());
    gradeTextureName = GetItemGradeTextureName(Info.CrystalType);
    // End:0x94
    if(Len(gradeTextureName) > 0)
    {
        gradeTextureName_width = 16;
        // End:0x94
        if((((Info.CrystalType == 6) || Info.CrystalType == 7) || Info.CrystalType == 9) || Info.CrystalType == 10)
        {
            gradeTextureName_width = 32;
        }
    }
    stackableAddStr = "x1";
    GetTextSizeDefault(stackableAddStr, stackableAddStr_width, textHeight);
    // End:0xDA
    if(Info.Enchanted > 0)
    {
        enchantedStr = "+" $ string(Info.Enchanted);
    }
    GetTextSizeDefault(enchantedStr, enchantedStr_width, textHeight);
    ensoulOptionAllName = GetEnsoulOptionNameAll(Info);
    GetTextSizeDefault(ensoulOptionAllName, ensoulOptionAllName_width, textHeight);
    AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(Info.Id);
    GetTextSizeDefault(AdditionalName, additionalName_width, textHeight);
    ItemName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(Info.Id);
    // End:0x184
    if(ItemName == "")
    {
        ItemName = Info.Name;
    }
    shortItemName = makeShortStringByPixel(ItemName, 240 - (((stackableAddStr_width + additionalName_width) + gradeTextureName_width) + 7), "..");
    strRetName = ("root" $ ".") $ nodeLine;
    util.TreeInsertItemTooltipSimpleNode("MultiSellWnd.NeededItem_TreeCtrl", nodeLine, "root", -7, 0, 38, 0, 32, 38, GetItemNameAll(Info));
    util.TreeInsertTextureNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, "L2UI_CT1.EmptyBtn", 257, 38);
    util.TreeInsertTextureNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
    util.TreeInsertTextureNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, Info.IconName, 32, 32, -34, 4 - 1);
    util.TreeInsertTextureNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, Info.IconPanel, 32, 32, -32, 4 - 1);
    // End:0x3D4
    if(enchantedStr != "")
    {
        util.TreeInsertTextNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, enchantedStr, 7, 5, util.0, true);
    }
    util.TreeInsertTextNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, shortItemName, 5, 5, util.0, true);
    // End:0x476
    if(ensoulOptionAllName != "")
    {
        util.TreeInsertTextNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, ensoulOptionAllName, 5, 5, util.4, true);
    }
    // End:0x4CD
    if(AdditionalName != "")
    {
        util.TreeInsertTextNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, AdditionalName, 5, 5, util.4, true);
    }
    // End:0x51E
    if(gradeTextureName_width > 0)
    {
        util.TreeInsertTextureNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, gradeTextureName, gradeTextureName_width, 16, 2, 5);
    }
    util.TreeInsertTextNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, "x " $ MakeCostString((__NFUN_401__(Info.ItemNum, (tryExchangeCount)))), 45, -14, util.2, false, true);
    // End:0x5DB
    if(Info.IconName == (GetPcCafeItemIconPackageName()))
    {
        hasNum = (mData.pcCafePoint);
        // End:0x5D8
        if(__NFUN_411__(hasNum, __NFUN_401__(Info.ItemNum, (tryExchangeCount))))
        {
            bHasItem = true;
        }        
    }
    else
    {
        // End:0x64C
        if(Info.IconName == "icon.etc_i.etc_bloodpledge_point_i00")
        {
            hasNum = (mData.clanPoint);
            // End:0x649
            if(__NFUN_411__(hasNum, __NFUN_401__(Info.ItemNum, (tryExchangeCount))))
            {
                bHasItem = true;
            }            
        }
        else
        {
            // End:0x6AB
            if(Info.IconName == "icon.pvp_point_i00")
            {
                hasNum = (mData.PvPPoint);
                // End:0x6A8
                if(__NFUN_411__(hasNum, __NFUN_401__(Info.ItemNum, (tryExchangeCount))))
                {
                    bHasItem = true;
                }                
            }
            else
            {
                // End:0x713
                if(Info.IconName == "icon.etc_i.etc_rp_point_i00")
                {
                    hasNum = (mData.RaidPoint);
                    // End:0x710
                    if(__NFUN_411__(hasNum, __NFUN_401__(Info.ItemNum, (tryExchangeCount))))
                    {
                        bHasItem = true;
                    }                    
                }
                else
                {
                    ItemCount = util.FindItemByClassID(Info.Id.ClassID, itemInfoArray, util.2);
                    // End:0x7DA
                    if(ItemCount > 0)
                    {
                        InvenItemInfo = itemInfoArray[0];
                        // End:0x7A3
                        if(!IsStackableItem(InvenItemInfo.ConsumeType))
                        {
                            // End:0x7A0
                            if(noStackableItemDataInfo.ClassID > 0)
                            {
                                // End:0x7A0
                                if(__NFUN_409__(noStackableItemDataInfo.Count, (0)))
                                {
                                    hasNum = (1);
                                }
                            }                            
                        }
                        else
                        {
                            hasNum = InvenItemInfo.ItemNum;
                        }
                        // End:0x7DA
                        if(__NFUN_411__(hasNum, __NFUN_401__(Info.ItemNum, (tryExchangeCount))))
                        {
                            bHasItem = true;
                        }
                    }
                }
            }
        }
    }
    // End:0x857
    if(bHasItem)
    {
        // End:0x854
        if(__NFUN_413__(hasNum, (-1)))
        {
            util.TreeInsertTextNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, ("(" $ MakeCostString((hasNum))) $ ")", 4, -14, util.7);
        }        
    }
    else
    {
        util.TreeInsertTextNodeItem("MultiSellWnd.NeededItem_TreeCtrl", strRetName, ("(" $ MakeCostString((hasNum))) $ ")", 4, -14, util.3);
    }
    return bHasItem;
    return;
}

function itemCountTextEditEnable(bool bEnable)
{
    // End:0x57
    if(bEnable)
    {
        MultiSell_Input_Button.EnableWindow();
        ItemCount_EditBox.EnableWindow();
        MultiSell_Up_Button.EnableWindow();
        MultiSell_Down_Button.EnableWindow();
        MultiSell_Input_Button.EnableWindow();        
    }
    else
    {
        MultiSell_Input_Button.DisableWindow();
        ItemCount_EditBox.DisableWindow();
        MultiSell_Up_Button.DisableWindow();
        MultiSell_Down_Button.DisableWindow();
        MultiSell_Input_Button.DisableWindow();
    }
    return;
}

function bool getCurrentSelectedItemInfo(out ItemInfo rItemInfo)
{
    local bool bFlag;

    // End:0x33
    if(MultiSellTab.GetTopIndex() == 0)
    {
        bFlag = MultisellTabTotalWnd_ItemWindow.GetSelectedItem(rItemInfo);        
    }
    else
    {
        bFlag = MultisellTabEnableWnd_ItemWindow.GetSelectedItem(rItemInfo);
    }
    return bFlag;
    return;
}

function int getCurrentSelectedIndex()
{
    local int RValue;

    RValue = -1;
    // End:0x38
    if(MultiSellTab.GetTopIndex() == 0)
    {
        RValue = MultisellTabTotalWnd_ItemWindow.GetSelectedNum();        
    }
    else
    {
        RValue = MultisellTabEnableWnd_ItemWindow.GetSelectedNum();
    }
    return RValue;
    return;
}

function setSelectItem(ItemInfo Info)
{
    local int lastSelectedIndex, N;
    local ItemInfo tempInfo;

    lastSelectedIndex = Info.Reserved;
    // End:0x23
    if(Info.Name == "")
    {
        return;
    }
    // End:0xBE
    if(MultiSellTab.GetTopIndex() == 0)
    {
        N = 0;
        J0x3F:

        // End:0xBB [Loop If]
        if(N < MultisellTabTotalWnd_ItemWindow.GetItemNum())
        {
            MultisellTabTotalWnd_ItemWindow.GetItem(N, tempInfo);
            // End:0xB1
            if(tempInfo.Reserved == lastSelectedIndex)
            {
                MultisellTabTotalWnd_ItemWindow.SetSelectedNum(N);
                MultisellTabTotalWnd_ListCtrl.SetSelectedIndex(N, true);
                // [Explicit Break]
                goto J0xBB;
            }
            N++;
            // [Loop Continue]
            goto J0x3F;
        }
        J0xBB:
        
    }
    else
    {
        N = 0;
        J0xC5:

        // End:0x141 [Loop If]
        if(N < MultisellTabEnableWnd_ItemWindow.GetItemNum())
        {
            MultisellTabEnableWnd_ItemWindow.GetItem(N, tempInfo);
            // End:0x137
            if(tempInfo.Reserved == lastSelectedIndex)
            {
                MultisellTabEnableWnd_ItemWindow.SetSelectedNum(N);
                MultisellTabEnableWnd_ListCtrl.SetSelectedIndex(N, true);
                // [Explicit Break]
                goto J0x141;
            }
            N++;
            // [Loop Continue]
            goto J0xC5;
        }
    }
    J0x141:

    return;
}

function int findMatchString(string targetStr, string a_Param)
{
    local array<string> modifiedParamArr;
    local int i;
    local string delim, modifiedString;
    local int _inStr;
    local string strTemp1, strTemp2;

    modifiedString = Locs(targetStr, " ", "", false);
    delim = " ";
    _inStr = InStr(a_Param, delim);
    J0x2E:

    // End:0x90 [Loop If]
    if(_inStr > -1)
    {
        modifiedParamArr.Insert(modifiedParamArr.Length, 1);
        modifiedParamArr[modifiedParamArr.Length - 1] = Left(a_Param, _inStr);
        a_Param = Mid(a_Param, _inStr + 1);
        _inStr = InStr(a_Param, delim);
        // [Loop Continue]
        goto J0x2E;
    }
    modifiedParamArr.Insert(modifiedParamArr.Length, 1);
    modifiedParamArr[modifiedParamArr.Length - 1] = a_Param;
    i = 0;
    J0xB9:

    // End:0x124 [Loop If]
    if(i < modifiedParamArr.Length)
    {
        strTemp1 = Caps(modifiedString);
        strTemp2 = Caps(modifiedParamArr[i]);
        // End:0x11A
        if((InStr(strTemp1, strTemp2) == -1) && modifiedParamArr[i] != " ")
        {
            return -1;
        }
        i++;
        // [Loop Continue]
        goto J0xB9;
    }
    return 1;
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

function setEditStateItemCount()
{
    ItemCount_EditBox.SetString("1");
    return;
}

function setButtonEnable(bool bEnable)
{
    // End:0x2A
    if(bEnable)
    {
        ExChange_Button.EnableWindow();
        Clear_Button.EnableWindow();        
    }
    else
    {
        ExChange_Button.DisableWindow();
        Clear_Button.DisableWindow();
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
