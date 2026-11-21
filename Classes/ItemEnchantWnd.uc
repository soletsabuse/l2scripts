class ItemEnchantWnd extends UICommonAPI;

const C_ANIMLOOPCOUNT = 1;
const DLG_ID_CRASH_ALERT = 1;

var bool bEnchantbool;
var bool bEnchantedbool;
var int mEnchantLevel;
var INT64 mEnchantItemType;
var bool bIsShopping;
var bool isBreakable;
var WindowHandle Me;
var TextureHandle BackPattern;
var TextBoxHandle InstructionTxt;
var ItemWindowHandle EnchantScriptSlot;
var ItemWindowHandle EnchantItemSlot;
var ItemWindowHandle CloverItemSlot;
var ItemWindowHandle EnchantedItemSlot;
var ButtonHandle EnchantBtn;
var ButtonHandle ExitBtn;
var TextureHandle GroupBox2;
var TextureHandle GroupBox1;
var TextureHandle EnchantScriptSlotBackTex;
var TextureHandle EnchantItemSlotBackTex;
var TextureHandle CloverItemSlotBackTex;
var TextureHandle EnchantedItemSlotBackTex;
var TextureHandle DropHighlight_enchantitem;
var TextureHandle DropHighlight_enchantscript;
var TextureHandle DropHighlight_CloverItem;
var AnimTextureHandle EnchantProgressAnim;
var ProgressCtrlHandle m_hItemEnchantWndEnchantProgress;
var ItemWindowHandle InventoryItem;
var TextBoxHandle WarningTxt;
var CheckBoxHandle EnchantSpeedCBox;
var ItemInfo SelectItemInfo;
var ItemInfo SelectHelperItemInfo;
var ItemInfo scrolltemInfo;
var ItemInfo tempSelectItemInfo;
var ItemInfo tempSelectHelperItemInfo;
var ItemInfo tempscrolltemInfo;
var int ScrollCID;
var bool bRequestScroll;
var bool bRequestEnchant;
var bool bRequestSupport;
var bool bRequestRemoveSupport;
var int uiType;
//var delegate<onSuccessEnchant> __onSuccessEnchant__Delegate;

function OnLoad()
{
    SetClosingOnESC();
    Me = GetWindowHandle("ItemEnchantWnd");
    EnchantProgressAnim = GetAnimTextureHandle("ItemEnchantWnd.EnchantProgressAnim");
    BackPattern = GetTextureHandle("ItemEnchantWnd.BackPattern");
    InstructionTxt = GetTextBoxHandle("ItemEnchantWnd.InstructionTxt");
    EnchantScriptSlot = GetItemWindowHandle("ItemEnchantWnd.EnchantScriptSlot");
    EnchantItemSlot = GetItemWindowHandle("ItemEnchantWnd.EnchantItemSlot");
    CloverItemSlot = GetItemWindowHandle("ItemEnchantWnd.CloverItemSlot");
    EnchantedItemSlot = GetItemWindowHandle("ItemEnchantWnd.EnchantedItemSlot");
    EnchantBtn = GetButtonHandle("ItemEnchantWnd.EnchantBtn");
    ExitBtn = GetButtonHandle("ItemEnchantWnd.ExitBtn");
    GroupBox2 = GetTextureHandle("ItemEnchantWnd.Groupbox2");
    GroupBox1 = GetTextureHandle("ItemEnchantWnd.Groupbox1");
    EnchantScriptSlotBackTex = GetTextureHandle("ItemEnchantWnd.EnchantScriptSlotBackTex");
    EnchantItemSlotBackTex = GetTextureHandle("ItemEnchantWnd.EnchantItemSlotBackTex");
    CloverItemSlotBackTex = GetTextureHandle("ItemEnchantWnd.CloverItemSlotBackTex");
    EnchantedItemSlotBackTex = GetTextureHandle("ItemEnchantWnd.EnchantedItemSlotBackTex");
    DropHighlight_enchantitem = GetTextureHandle("ItemEnchantWnd.DropHighlight_enchantitem");
    DropHighlight_enchantscript = GetTextureHandle("ItemEnchantWnd.DropHighlight_enchantscript");
    DropHighlight_CloverItem = GetTextureHandle("ItemEnchantWnd.DropHighlight_CloverItem");
    m_hItemEnchantWndEnchantProgress = GetProgressCtrlHandle("ItemEnchantWnd.EnchantProgress");
    InventoryItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
    WarningTxt = GetTextBoxHandle("ItemEnchantWnd.WarningTxt");
    EnchantSpeedCBox = GetCheckBoxHandle("ItemEnchantWnd.EnchantSpeedCBox");
    Class'NWindow.EnchantAPI'.static.RequestExCancelEnchantItem();
    Initialize();
    return;
}

function loadOption()
{
    local int currEnType;

    currEnType = GetOptionInt("Game", "EnchantSpeedType");
    // End:0x42
    if(currEnType == 0)
    {
        EnchantSpeedCBox.SetCheck(false);        
    }
    else
    {
        // End:0x5D
        if(currEnType == 1)
        {
            EnchantSpeedCBox.SetCheck(true);
        }
    }
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x72
        case "EnchantSpeedCBox":
            // End:0x50
            if(EnchantSpeedCBox.IsChecked())
            {
                SetOptionInt("Game", "EnchantSpeedType", 1);                
            }
            else
            {
                SetOptionInt("Game", "EnchantSpeedType", 0);
            }
            // End:0x78
            break;
        // End:0xFFFF
        default:
            // End:0x78
            break;
            break;
    }
    return;
}

function int getProgressSpeed()
{
    // End:0x2D
    if(GetOptionInt("Game", "EnchantSpeedType") == 1)
    {
        return 300;        
    }
    else
    {
        return 1500;
    }
    return;
}

function float getAnimSpeed()
{
    // End:0x2D
    if(GetOptionInt("Game", "EnchantSpeedType") == 1)
    {
        return 0.3300000;        
    }
    else
    {
        return 1.5000000;
    }
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
    WarningTxt.HideWindow();
    switch(DialogGetID())
    {
        // End:0x46
        case 1111:
        // End:0x4E
        case 2222:
        // End:0x56
        case 3333:
        // End:0x5E
        case 4444:
        // End:0x66
        case 5555:
        // End:0x6E
        case 6666:
        // End:0x76
        case 7777:
        // End:0x7E
        case 8888:
        // End:0x86
        case 9998:
        // End:0x8E
        case 9999:
        // End:0x9F
        case 10000:
            DialogHide();
            // End:0xA5
            break;
        // End:0xFFFF
        default:
            // End:0xA5
            break;
            break;
    }
    return;
}

function Initialize()
{
    bEnchantbool = false;
    bEnchantedbool = false;
    bIsShopping = false;
    load();
    loadOption();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(2860);
    RegisterEvent(2865);
    RegisterEvent(2870);
    RegisterEvent(2880);
    RegisterEvent(2881);
    RegisterEvent(2882);
    RegisterEvent(2883);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function load()
{
    return;
}

function HandleShowDialog()
{
    Class'Interface.UICommonAPI'.static.DialogSetID(1);
    DialogSetCancelD(1);
    // End:0x44
    if(isAGScrollState())
    {
        Class'Interface.UICommonAPI'.static.DialogShow(1, 0, GetSystemMessage(4507), string(self));        
    }
    else
    {
        Class'Interface.UICommonAPI'.static.DialogShow(1, 0, GetSystemMessage(4149), string(self));
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x6F
        case "EnchantBtn":
            checkEventWarningText();
            // End:0x2E
            if(bEnchantedbool)
            {
                HandleGoToFirstStep();                
            }
            else
            {
                bEnchantbool = true;
                EnchantBtn.DisableWindow();
                // End:0x66
                if(isBreakable)
                {
                    HandleShowDialog();
                    ExitBtn.DisableWindow();                    
                }
                else
                {
                    OnEnchantBtnClick();
                }
            }
            // End:0xC0
            break;
        // End:0xBA
        case "ExitBtn":
            // End:0xA8
            if(bEnchantbool)
            {
                HandleGoToFirstStep();
                // End:0xA5
                if(Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
                {
                    DialogHide();
                }                
            }
            else
            {
                Class'NWindow.EnchantAPI'.static.RequestExCancelEnchantItem();
            }
            // End:0xC0
            break;
        // End:0xFFFF
        default:
            // End:0xC0
            break;
            break;
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x3A
    if(Event_ID == 2860)
    {
        // End:0x28
        if(!bIsShopping)
        {
            HandleEnchantShow(param);            
        }
        else
        {
            Class'NWindow.EnchantAPI'.static.RequestExCancelEnchantItem();
        }        
    }
    else
    {
        // End:0x57
        if(Event_ID == 2870)
        {
            HandleEnchantResult(param);            
        }
        else
        {
            // End:0x74
            if(Event_ID == 2880)
            {
                HandlePutTargetItemResult(param);                
            }
            else
            {
                // End:0x91
                if(Event_ID == 2881)
                {
                    HandlePutSupportItemResult(param);                    
                }
                else
                {
                    // End:0xA9
                    if(Event_ID == 2883)
                    {
                        removeSupportItm();                        
                    }
                    else
                    {
                        // End:0xC6
                        if(Event_ID == 2882)
                        {
                            HandlePutScrollResult(param);                            
                        }
                        else
                        {
                            // End:0xDF
                            if(Event_ID == 1710)
                            {
                                HandleDialogResult(true);                                
                            }
                            else
                            {
                                // End:0xF5
                                if(Event_ID == 1720)
                                {
                                    HandleDialogResult(false);
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

function HandleDialogResult(bool bOK)
{
    local int DlgID;

    // End:0x19
    if(!Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
    {
        return;
    }
    Me.SetFocus();
    // End:0x69
    if(bOK)
    {
        DlgID = Class'Interface.UICommonAPI'.static.DialogGetID();
        switch(DlgID)
        {
            // End:0x60
            case 1:
                HandleDlGCrashAlert(bOK);
                // End:0x66
                break;
            // End:0xFFFF
            default:
                // End:0x66
                break;
                break;
        }        
    }
    else
    {
        // End:0x7F
        if(DialogCheckCancelByID(1))
        {
            HandleDlGCrashAlert(bOK);
        }
    }
    return;
}

function HandleDlGCrashAlert(bool bOK)
{
    ExitBtn.EnableWindow();
    // End:0x21
    if(bOK)
    {
        OnEnchantBtnClick();        
    }
    else
    {
        bEnchantbool = false;
        EnchantBtn.EnableWindow();
    }
    return;
}

function bool isAGScrollState()
{
    // End:0x0D
    if(uiType == 1)
    {
        return true;
    }
    return false;
    return;
}

function bool isAGScrollType(UIEventManager.EEtcItemType Type)
{
    // End:0x40
    if((((int(Type) == 63) || int(Type) == 64) || int(Type) == 65) || int(Type) == 66)
    {
        return true;
    }
    return false;
    return;
}

function setTitleByItemType(UIEventManager.EEtcItemType Type)
{
    // End:0x62
    if((((int(Type) == 63) || int(Type) == 64) || int(Type) == 65) || int(Type) == 66)
    {
        Me.SetWindowTitle(GetSystemString(3639));
        uiType = 1;        
    }
    else
    {
        Me.SetWindowTitle(GetSystemString(1220));
        uiType = 0;
    }
    return;
}

function int getFailStringNum(UIEventManager.EEtcItemType Type)
{
    // End:0x47
    if((((int(Type) == 19) || int(Type) == 20) || int(Type) == 56) || int(Type) == 57)
    {
        return 4143;        
    }
    else
    {
        // End:0x6E
        if((int(Type) == 21) || int(Type) == 22)
        {
            return 4144;            
        }
        else
        {
            // End:0x95
            if((int(Type) == 30) || int(Type) == 31)
            {
                return -1;                
            }
            else
            {
                // End:0xBC
                if((int(Type) == 32) || int(Type) == 33)
                {
                    return 4145;                    
                }
                else
                {
                    // End:0xE3
                    if((int(Type) == 63) || int(Type) == 65)
                    {
                        return 4506;                        
                    }
                    else
                    {
                        // End:0xFA
                        if(int(Type) == 64)
                        {
                            return 4508;                            
                        }
                        else
                        {
                            // End:0x10E
                            if(int(Type) == 66)
                            {
                                return 4509;
                            }
                        }
                    }
                }
            }
        }
    }
    return -1;
    return;
}

function checkWarningTxt()
{
    local bool isCanUseSupportMinLv, isNot100PerSuccess;
    local UIEventManager.EEtcItemType EEtcItemType;
    local int failStringNum;

    WarningTxt.HideWindow();
    EEtcItemType = byte(scrolltemInfo.ItemSubType);
    isCanUseSupportMinLv = mEnchantLevel > (getEnchantedItemMini());
    isNot100PerSuccess = true;
    failStringNum = getFailStringNum(EEtcItemType);
    // End:0x9B
    if(scrolltemInfo.Id.ClassID == 28766)
    {
        WarningTxt.SetText(GetSystemMessage(4145));
        WarningTxt.ShowWindow();
        isBreakable = false;        
    }
    else
    {
        // End:0x11E
        if(((scrolltemInfo.Id.ClassID == 70885) || scrolltemInfo.Id.ClassID == 70886) || scrolltemInfo.Id.ClassID == 70887)
        {
            WarningTxt.SetText(GetSystemMessage(4278));
            WarningTxt.ShowWindow();
            isBreakable = false;            
        }
        else
        {
            // End:0x16C
            if((isCanUseSupportMinLv && isNot100PerSuccess) && failStringNum != -1)
            {
                WarningTxt.SetText(GetSystemMessage(failStringNum));
                WarningTxt.ShowWindow();
            }
        }
    }
    return;
}

function int getEnchantedItemMini()
{
    local int EnchantedItemMini;

    // End:0x1D
    if(__NFUN_412__(mEnchantItemType, (32768)))
    {
        EnchantedItemMini = 3;        
    }
    else
    {
        EnchantedItemMini = 2;
    }
    return EnchantedItemMini;
    return;
}

function bool getIsBreakable()
{
    local UIEventManager.EEtcItemType EEtcItemType;
    local bool isCanUseSupportMinLv;

    EEtcItemType = byte(scrolltemInfo.ItemSubType);
    isCanUseSupportMinLv = mEnchantLevel > (getEnchantedItemMini());
    // End:0x92
    if((((SelectItemInfo.Id.ClassID == 29704) || SelectItemInfo.Id.ClassID == 29705) || SelectItemInfo.Id.ClassID == 29706) || SelectItemInfo.Id.ClassID == 29707)
    {
        return true;
    }
    return (isCanUseSupportMinLv && ((((int(EEtcItemType) == 19) || int(EEtcItemType) == 20) || int(EEtcItemType) == 56) || int(EEtcItemType) == 57) || int(EEtcItemType) == 63) || int(EEtcItemType) == 65;
    return;
}

function handleCloverSlot()
{
    local bool isCanUseSupportMinLv, bEnableCloverSlot;
    local ItemInfo invenSupportInfo;

    getEnchantedItemMini();
    checkWarningTxt();
    isCanUseSupportMinLv = mEnchantLevel > (getEnchantedItemMini());
    isBreakable = getIsBreakable();
    // End:0x7F
    if(isCanUseSupportMinLv)
    {
        // End:0x77
        if(getInstanceUIData().getIsClassicServer())
        {
            bEnableCloverSlot = (checkEnableCloverSlotClassic(ScrollCID)) && !isAGScrollType(byte(scrolltemInfo.ItemSubType));            
        }
        else
        {
            bEnableCloverSlot = true;
        }
    }
    // End:0x114
    if(bEnableCloverSlot)
    {
        EnableCloverSlot();
        InventoryItem.GetItem(InventoryItem.FindItem(SelectHelperItemInfo.Id), invenSupportInfo);
        // End:0x10B
        if(__NFUN_409__(invenSupportInfo.ItemNum, (0)))
        {
            bRequestSupport = true;
            EnchantBtn.DisableWindow();
            Class'NWindow.EnchantAPI'.static.RequestExTryToPutEnchantSupportItem(invenSupportInfo.Id, SelectItemInfo.Id);            
        }
        else
        {
            RequestExRemoveEnchantSupportItem();
        }        
    }
    else
    {
        DisableCloverSlot();
    }
    return;
}

function HandleInstructionTxt()
{
    local int systemMessage;

    // End:0x21
    if(__NFUN_408__(scrolltemInfo.ItemNum, (1)))
    {
        systemMessage = 4146;        
    }
    else
    {
        // End:0x65
        if(__NFUN_408__(SelectItemInfo.ItemNum, (1)))
        {
            // End:0x57
            if(isAGScrollType(byte(scrolltemInfo.ItemSubType)))
            {
                systemMessage = 4504;                
            }
            else
            {
                systemMessage = 2339;
            }            
        }
        else
        {
            // End:0xAE
            if(CloverItemSlot.IsShowWindow())
            {
                // End:0x97
                if(__NFUN_412__(mEnchantItemType, (32768)))
                {
                    systemMessage = 3149;                    
                }
                else
                {
                    // End:0xA0
                    if(isAGScrollState())
                    {
                    }
                    systemMessage = 2940;
                }                
            }
            else
            {
                // End:0xC5
                if(isAGScrollState())
                {
                    systemMessage = 4505;                    
                }
                else
                {
                    systemMessage = 2341;
                }
            }
        }
    }
    InstructionTxt.SetText(GetSystemMessage(systemMessage));
    return;
}

function HandleHighlight()
{
    DropHighlight_enchantitem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
    DropHighlight_enchantscript.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
    DropHighlight_CloverItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
    // End:0xDA
    if(__NFUN_408__(scrolltemInfo.ItemNum, (1)))
    {
        DropHighlight_enchantitem.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");        
    }
    else
    {
        // End:0x121
        if(__NFUN_408__(SelectItemInfo.ItemNum, (1)))
        {
            DropHighlight_enchantscript.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");            
        }
        else
        {
            // End:0x165
            if(__NFUN_408__(SelectHelperItemInfo.ItemNum, (1)))
            {
                DropHighlight_CloverItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");
            }
        }
    }
    return;
}

function HandlePutTargetItemResult(string param)
{
    local int ResultID;

    ParseInt(param, "Result", ResultID);
    bRequestEnchant = false;
    // End:0x2E
    if(ResultID == 0)
    {        
    }
    else
    {
        SelectItemInfo = tempSelectItemInfo;
        EnchantItemSlot.SetItem(0, SelectItemInfo);
        EnchantItemSlot.AddItem(SelectItemInfo);
        handleCloverSlot();
        HandleHighlight();
        HandleInstructionTxt();
        EnchantScriptSlotBackTex.HideWindow();
        EnchantItemSlotBackTex.HideWindow();
    }
    checkEnchantBtn();
    return;
}

function HandlePutScrollResult(string param)
{
    local int ResultID;

    ParseInt(param, "Result", ResultID);
    bRequestScroll = false;
    // End:0x2E
    if(ResultID == 0)
    {        
    }
    else
    {
        scrolltemInfo = tempscrolltemInfo;
        scrolltemInfo.bShowCount = true;
        EnchantScriptSlot.Clear();
        EnchantScriptSlot.SetItem(0, scrolltemInfo);
        EnchantScriptSlot.AddItem(scrolltemInfo);
        ScrollCID = scrolltemInfo.Id.ClassID;
        handleCloverSlot();
        EnchantScriptSlotBackTex.HideWindow();
        PlaySound("ItemSound3.enchant_input");
        HandlecheckisMatchScrollSupport(byte(scrolltemInfo.ItemSubType), byte(SelectHelperItemInfo.ItemSubType));
        HandleHighlight();
        HandleInstructionTxt();
        setTitleByItemType(byte(scrolltemInfo.ItemSubType));
    }
    checkEnchantBtn();
    return;
}

function HandlePutSupportItemResult(string param)
{
    local int ResultID;
    local ItemInfo invenSupportInfo;

    ParseInt(param, "Result", ResultID);
    bRequestSupport = false;
    // End:0x34
    if(ResultID == 0)
    {
        RequestExRemoveEnchantSupportItem();        
    }
    else
    {
        SelectHelperItemInfo = tempSelectHelperItemInfo;
        SelectHelperItemInfo.bShowCount = true;
        InventoryItem.GetItem(InventoryItem.FindItem(SelectHelperItemInfo.Id), invenSupportInfo);
        SelectHelperItemInfo.ItemNum = invenSupportInfo.ItemNum;
        CloverItemSlot.SetItem(0, SelectHelperItemInfo);
        CloverItemSlot.AddItem(SelectHelperItemInfo);
        CloverItemSlotBackTex.HideWindow();
        HandlecheckisMatchScrollSupport(byte(scrolltemInfo.ItemSubType), byte(SelectHelperItemInfo.ItemSubType));
        isBreakable = getIsBreakable();
        HandleHighlight();
        checkWarningTxt();
        checkEventWarningText();
    }
    checkEnchantBtn();
    return;
}

function HandlecheckisMatchScrollSupport(UIEventManager.EEtcItemType scrollSubType, UIEventManager.EEtcItemType supportSubType)
{
    local bool bool1, bool2;

    // End:0x15
    if(__NFUN_408__(SelectHelperItemInfo.ItemNum, (1)))
    {
        return;
    }
    bool1 = (int(supportSubType) == 52) || int(supportSubType) == 53;
    bool2 = (int(scrollSubType) == 21) || int(scrollSubType) == 22;
    // End:0xB5
    if(!bool1 && !bool2)
    {
        bool1 = (int(supportSubType) == 58) || int(supportSubType) == 59;
        bool2 = (int(scrollSubType) == 56) || int(scrollSubType) == 57;
    }
    // End:0xC6
    if(bool1 != bool2)
    {
    }
    return;
}

function removeSupportItm()
{
    local ItemInfo EmptyInfo;

    bRequestRemoveSupport = false;
    SelectHelperItemInfo = EmptyInfo;
    CloverItemSlot.Clear();
    HandleHighlight();
    isBreakable = getIsBreakable();
    checkWarningTxt();
    checkEventWarningText();
    HandleInstructionTxt();
    checkEnchantBtn();
    return;
}

function HandleGoToFirstStep()
{
    local ItemInfo invenScrollInfo, invenSupportInfo;

    ProcCancel();
    EnchantSpeedCBox.ShowWindow();
    EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Loading_01");
    EnchantProgressAnim.HideWindow();
    BackPattern.HideWindow();
    InstructionTxt.SetText("");
    m_hItemEnchantWndEnchantProgress.SetProgressTime(getProgressSpeed());
    m_hItemEnchantWndEnchantProgress.SetPos(0);
    m_hItemEnchantWndEnchantProgress.Reset();
    bEnchantbool = false;
    bEnchantedbool = false;
    EnchantScriptSlot.DisableTick();
    EnchantItemSlot.DisableTick();
    CloverItemSlot.DisableTick();
    EnchantedItemSlot.DisableTick();
    EnchantedItemSlot.Clear();
    InventoryItem.GetItem(InventoryItem.FindItem(scrolltemInfo.Id), invenScrollInfo);
    scrolltemInfo.ItemNum = invenScrollInfo.ItemNum;
    ScrollCID = scrolltemInfo.Id.ClassID;
    // End:0x19E
    if(__NFUN_412__(scrolltemInfo.ItemNum, (0)))
    {
        EnchantScriptSlot.Clear();
        DisableCloverSlot();
        EnchantScriptSlotBackTex.ShowWindow();        
    }
    else
    {
        handleCloverSlot();
        EnchantScriptSlot.SetItem(0, scrolltemInfo);
        InventoryItem.GetItem(InventoryItem.FindItem(SelectHelperItemInfo.Id), invenSupportInfo);
        SelectHelperItemInfo.ItemNum = invenSupportInfo.ItemNum;
        // End:0x220
        if(__NFUN_412__(SelectHelperItemInfo.ItemNum, (0)))
        {
            Class'NWindow.EnchantAPI'.static.RequestExRemoveEnchantSupportItem();            
        }
        else
        {
            CloverItemSlot.SetItem(0, invenSupportInfo);
        }
    }
    HandleHighlight();
    HandleInstructionTxt();
    checkEnchantBtn();
    ExitBtn.SetNameText(GetSystemString(646));
    EnchantBtn.SetNameText(GetSystemString(428));
    checkEventWarningText();
    return;
}

function OnEnchantBtnClick()
{
    local Rect Item1Rect, Item2Rect, Item3Rect, ResultRect;

    EnchantProgressAnim.SetLoopCount(1);
    EnchantProgressAnim.Stop();
    EnchantProgressAnim.Play();
    PlaySound("ItemSound3.enchant_process");
    EnchantProgressAnim.ShowWindow();
    DropHighlight_enchantitem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
    DropHighlight_enchantscript.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
    DropHighlight_CloverItem.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
    m_hItemEnchantWndEnchantProgress.SetProgressTime(getProgressSpeed());
    m_hItemEnchantWndEnchantProgress.Start();
    Item1Rect = EnchantScriptSlot.GetRect();
    Item2Rect = EnchantItemSlot.GetRect();
    Item3Rect = CloverItemSlot.GetRect();
    ResultRect = EnchantedItemSlot.GetRect();
    EnchantScriptSlot.EnableTick();
    EnchantItemSlot.EnableTick();
    CloverItemSlot.EnableTick();
    EnchantScriptSlot.Move(ResultRect.nX - Item1Rect.nX, ResultRect.nY - Item1Rect.nY, getAnimSpeed());
    EnchantItemSlot.Move(ResultRect.nX - Item2Rect.nX, ResultRect.nY - Item2Rect.nY, getAnimSpeed());
    CloverItemSlot.Move(ResultRect.nX - Item3Rect.nX, ResultRect.nY - Item3Rect.nY, getAnimSpeed());
    CloverItemSlotBackTex.HideWindow();
    EnchantItemSlotBackTex.HideWindow();
    EnchantedItemSlotBackTex.HideWindow();
    CloverItemSlotBackTex.HideWindow();
    ExitBtn.SetNameText(GetSystemString(141));
    EnchantBtn.SetNameText(GetSystemString(428));
    EnchantSpeedCBox.HideWindow();
    return;
}

function ProcCancel()
{
    bEnchantbool = false;
    m_hItemEnchantWndEnchantProgress.Stop();
    EnchantProgressAnim.Stop();
    return;
}

function OnProgressTimeUp(string strID)
{
    // End:0x26
    if(strID == "EnchantProgress")
    {
        OnTextureAnimEnd(EnchantProgressAnim);
    }
    return;
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
    EnchantProgressAnim.HideWindow();
    EnchantProgressAnim.Stop();
    EnchantProgressAnim.HideWindow();
    switch(a_WindowHandle)
    {
        // End:0x73
        case EnchantProgressAnim:
            // End:0x70
            if(bEnchantbool)
            {
                bEnchantbool = false;
                Class'NWindow.EnchantAPI'.static.RequestEnchantItem(SelectItemInfo.Id, SelectHelperItemInfo.Id);
            }
            // End:0x79
            break;
        // End:0xFFFF
        default:
            // End:0x79
            break;
            break;
    }
    EnchantProgressAnim.HideWindow();
    return;
}

function HandleEnchantShow(string param)
{
    local ItemID cID;
    local ItemInfo invenInfo, EmptyInfo;
    local int InvenItemID;

    SelectItemInfo = EmptyInfo;
    SelectHelperItemInfo = EmptyInfo;
    DropHighlight_enchantscript.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");
    ParseItemID(param, cID);
    ScrollCID = cID.ClassID;
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, scrolltemInfo);
    scrolltemInfo.ItemNum = GetInventoryItemCount(cID);
    scrolltemInfo.bShowCount = true;
    bEnchantedbool = false;
    ResetUI();
    Me.ShowWindow();
    Me.SetFocus();
    ExitBtn.SetNameText(GetSystemString(646));
    EnchantBtn.SetNameText(GetSystemString(428));
    bRequestScroll = false;
    EnchantScriptSlot.SetItem(0, scrolltemInfo);
    EnchantScriptSlot.AddItem(scrolltemInfo);
    PlaySound("ItemSound3.enchant_input");
    HandleInstructionTxt();
    mEnchantLevel = 0;
    DropHighlight_CloverItem.HideWindow();
    setTitleByItemType(byte(scrolltemInfo.ItemSubType));
    return;
}

function checkEnchantBtn()
{
    local bool isEnableEnchantBtn;

    isEnableEnchantBtn = ((((((!bRequestScroll && !bRequestEnchant) && !bRequestSupport) && !bRequestRemoveSupport) && __NFUN_409__(SelectItemInfo.ItemNum, (0))) && __NFUN_409__(scrolltemInfo.ItemNum, (0))) && !bEnchantbool) && !bEnchantedbool;
    // End:0x95
    if(isEnableEnchantBtn)
    {
        EnchantBtn.EnableWindow();        
    }
    else
    {
        EnchantBtn.DisableWindow();
    }
    return;
}

function ResetUI()
{
    EnchantProgressAnim.HideWindow();
    EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Loading_01");
    EnchantProgressAnim.HideWindow();
    BackPattern.HideWindow();
    InstructionTxt.SetText("");
    EnchantedItemSlot.Clear();
    EnchantedItemSlot.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 116, 90);
    EnchantedItemSlot.SetWindowSize(34, 34);
    EnchantedItemSlot.ClearAnchor();
    EnchantedItemSlot.ShowWindow();
    EnchantBtn.DisableWindow();
    EnchantSpeedCBox.ShowWindow();
    EnchantItemSlot.SetAlpha(255, 0.0000000);
    EnchantScriptSlot.Clear();
    EnchantScriptSlot.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 78, 90);
    EnchantScriptSlot.SetWindowSize(34, 34);
    EnchantScriptSlot.ClearAnchor();
    EnchantScriptSlot.ShowWindow();
    EnchantItemSlot.Clear();
    EnchantItemSlot.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 157, 90);
    EnchantItemSlot.SetWindowSize(34, 34);
    EnchantItemSlot.ClearAnchor();
    EnchantItemSlot.ShowWindow();
    CloverItemSlot.Clear();
    EnchantScriptSlotBackTex.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 77, 90);
    EnchantScriptSlotBackTex.ClearAnchor();
    EnchantScriptSlotBackTex.ShowWindow();
    EnchantItemSlotBackTex.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 156, 90);
    EnchantItemSlotBackTex.ClearAnchor();
    EnchantItemSlotBackTex.ShowWindow();
    CloverItemSlot.Clear();
    CloverItemSlot.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 116, 100);
    CloverItemSlot.SetWindowSize(34, 34);
    CloverItemSlot.ClearAnchor();
    CloverItemSlotBackTex.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 115, 100);
    CloverItemSlotBackTex.ClearAnchor();
    EnchantedItemSlotBackTex.HideWindow();
    CloverItemSlotBackTex.HideWindow();
    CloverItemSlot.HideWindow();
    bRequestScroll = false;
    bRequestEnchant = false;
    bRequestSupport = false;
    bRequestRemoveSupport = false;
    m_hItemEnchantWndEnchantProgress.SetProgressTime(getProgressSpeed());
    m_hItemEnchantWndEnchantProgress.SetPos(0);
    m_hItemEnchantWndEnchantProgress.Reset();
    return;
}

function EnableCloverSlot()
{
    EnchantScriptSlot.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 78, 60);
    EnchantScriptSlot.SetWindowSize(34, 34);
    EnchantScriptSlot.ClearAnchor();
    EnchantScriptSlot.ShowWindow();
    EnchantItemSlot.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 157, 60);
    EnchantItemSlot.SetWindowSize(34, 34);
    EnchantItemSlot.ClearAnchor();
    EnchantItemSlot.ShowWindow();
    CloverItemSlot.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 116, 100);
    CloverItemSlot.ClearAnchor();
    CloverItemSlot.ShowWindow();
    CloverItemSlotBackTex.ShowWindow();
    DropHighlight_CloverItem.ShowWindow();
    return;
}

function DisableCloverSlot()
{
    EnchantScriptSlot.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 78, 90);
    EnchantScriptSlot.SetWindowSize(34, 34);
    EnchantScriptSlot.ClearAnchor();
    EnchantScriptSlot.ShowWindow();
    EnchantItemSlot.SetAnchor("ItemEnchantWnd", "TopLeft", "TopLeft", 157, 90);
    EnchantItemSlot.SetWindowSize(34, 34);
    EnchantItemSlot.ClearAnchor();
    EnchantItemSlot.ShowWindow();
    CloverItemSlot.Clear();
    CloverItemSlot.HideWindow();
    CloverItemSlotBackTex.HideWindow();
    DropHighlight_CloverItem.HideWindow();
    RequestExRemoveEnchantSupportItem();
    return;
}

function RequestExRemoveEnchantSupportItem()
{
    bRequestRemoveSupport = true;
    EnchantBtn.DisableWindow();
    Class'NWindow.EnchantAPI'.static.RequestExRemoveEnchantSupportItem();
    return;
}

function OnHide()
{
    bEnchantbool = false;
    // End:0x23
    if(Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
    {
        DialogHide();
    }
    Class'NWindow.EnchantAPI'.static.RequestExCancelEnchantItem();
    return;
}

function bool IsEnchantableItem(UIEventManager.EItemParamType Type)
{
    return (((int(Type) == 0) || int(Type) == 1) || int(Type) == 3) || int(Type) == 2;
    return;
}

function bool isIncPropItem(UIEventManager.EEtcItemType Type)
{
    return (((((int(Type) == 29) || int(Type) == 28) || int(Type) == 52) || int(Type) == 53) || int(Type) == 58) || int(Type) == 59;
    return;
}

function bool isEnchantScroll(UIEventManager.EEtcItemType Type)
{
    return (((((((((((((int(Type) == 19) || int(Type) == 20) || int(Type) == 21) || int(Type) == 22) || int(Type) == 30) || int(Type) == 31) || int(Type) == 32) || int(Type) == 33) || int(Type) == 56) || int(Type) == 57) || int(Type) == 63) || int(Type) == 64) || int(Type) == 65) || int(Type) == 66;
    return;
}

function OnDBClickItem(string ControlName, int Index)
{
    // End:0x0B
    if(bEnchantbool)
    {
        return;
    }
    // End:0x2B
    if(ControlName == "CloverItemSlot")
    {
        RequestExRemoveEnchantSupportItem();
    }
    return;
}

function OnDropItemSource(string strTarget, ItemInfo Info)
{
    // End:0x16
    if(bEnchantbool || bEnchantedbool)
    {
        return;
    }
    // End:0x57
    if(strTarget == "Console")
    {
        switch(Info.DragSrcName)
        {
            // End:0x51
            case "CloverItemSlot":
                RequestExRemoveEnchantSupportItem();
                // End:0x57
                break;
            // End:0xFFFF
            default:
                // End:0x57
                break;
                break;
        }
    }
    return;
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    local Rect rectWnd;
    local UIEventManager.EItemParamType EItemParamType;
    local ItemInfo tmpInf;

    // End:0x16
    if(bEnchantbool || bEnchantedbool)
    {
        return;
    }
    rectWnd = Me.GetRect();
    // End:0x2B5
    if((((X > (rectWnd.nX + 9)) && X < ((rectWnd.nX + 9) + 246)) && Y > (rectWnd.nY + 39)) && Y < ((rectWnd.nY + 39) + 137))
    {
        InventoryItem.GetItem(InventoryItem.FindItem(a_ItemInfo.Id), a_ItemInfo);
        EItemParamType = byte(a_ItemInfo.ItemType);
        // End:0x144
        if(IsEnchantableItem(EItemParamType))
        {
            tempSelectItemInfo = a_ItemInfo;
            mEnchantLevel = a_ItemInfo.Enchanted;
            mEnchantItemType = a_ItemInfo.SlotBitType;
            bRequestEnchant = true;
            EnchantBtn.DisableWindow();
            Class'NWindow.EnchantAPI'.static.RequestExTryToPutEnchantTargetItem(a_ItemInfo.Id);            
        }
        else
        {
            // End:0x2AA
            if(int(byte(a_ItemInfo.ItemType)) == 5)
            {
                // End:0x1F9
                if(isEnchantScroll(byte(a_ItemInfo.ItemSubType)))
                {
                    // End:0x188
                    if(EnchantScriptSlot.GetItem(0, tmpInf))
                    {
                        return;
                    }
                    // End:0x1F6
                    if(true)
                    {
                        // End:0x1B1
                        if(scrolltemInfo.Id.ClassID == a_ItemInfo.Id.ClassID)
                        {
                            return;
                        }
                        tempscrolltemInfo = a_ItemInfo;
                        bRequestScroll = true;
                        EnchantBtn.DisableWindow();
                        Class'NWindow.EnchantAPI'.static.RequestExAddEnchantScrollItem(SelectItemInfo.Id, a_ItemInfo.Id);
                    }                    
                }
                else
                {
                    // End:0x29C
                    if(isIncPropItem(byte(a_ItemInfo.ItemSubType)))
                    {
                        // End:0x22F
                        if(!CloverItemSlot.IsShowWindow())
                        {
                            AddSystemMessage(6094);
                            return;
                        }
                        // End:0x254
                        if(SelectHelperItemInfo.Id.ClassID == a_ItemInfo.Id.ClassID)
                        {
                            return;
                        }
                        bRequestSupport = true;
                        EnchantBtn.DisableWindow();
                        tempSelectHelperItemInfo = a_ItemInfo;
                        Class'NWindow.EnchantAPI'.static.RequestExTryToPutEnchantSupportItem(a_ItemInfo.Id, SelectItemInfo.Id);                        
                    }
                    else
                    {
                        AddSystemMessage(6094);
                    }
                }                
            }
            else
            {
                AddSystemMessage(6094);
            }
        }
    }
    return;
}

function bool checkEnableCloverSlotClassic(int ScrollCID)
{
    local UIEventManager.EEtcItemType EEtcItemType;

    EEtcItemType = byte(scrolltemInfo.ItemSubType);
    // End:0x22
    if(int(EEtcItemType) != 20)
    {
        return false;
    }
    switch(ScrollCID)
    {
        // End:0x31
        case 90494:
        // End:0x39
        case 49469:
        // End:0x41
        case 90995:
        // End:0x49
        case 70885:
        // End:0x51
        case 70886:
        // End:0x59
        case 70887:
        // End:0x63
        case 71124:
            return false;
        // End:0xFFFF
        default:
            return true;
            break;
    }    
    return;
}

function bool CheckEnableCloverSlot(int Id)
{
    return true;
    switch(Id)
    {
        // End:0x11
        case 22018:
        // End:0x19
        case 22019:
        // End:0x21
        case 20521:
        // End:0x29
        case 22427:
        // End:0x31
        case 22020:
        // End:0x39
        case 22021:
        // End:0x41
        case 20522:
        // End:0x49
        case 22430:
        // End:0x51
        case 22014:
        // End:0x59
        case 22015:
        // End:0x61
        case 22016:
        // End:0x69
        case 22017:
        // End:0x71
        case 20519:
        // End:0x79
        case 20520:
        // End:0x81
        case 22426:
        // End:0x89
        case 22429:
        // End:0x91
        case 23342:
        // End:0x99
        case 23343:
        // End:0xA1
        case 23344:
        // End:0xA9
        case 23345:
        // End:0xB1
        case 23731:
        // End:0xB9
        case 23732:
        // End:0xC1
        case 23733:
        // End:0xC9
        case 23734:
        // End:0xD1
        case 23735:
        // End:0xD9
        case 23736:
        // End:0xE1
        case 23737:
        // End:0xE9
        case 23738:
        // End:0xF1
        case 23739:
        // End:0xF9
        case 23740:
        // End:0x101
        case 23741:
        // End:0x109
        case 23742:
        // End:0x111
        case 37803:
        // End:0x119
        case 28593:
        // End:0x121
        case 28594:
        // End:0x12B
        case 28595:
            return false;
        // End:0xFFFF
        default:
            return true;
            break;
    }    
    return;
}

function bool CheckScrollType(int Id)
{
    switch(Id)
    {
        // End:0x0F
        case 21581:
        // End:0x17
        case 21582:
        // End:0x1F
        case 21707:
        // End:0x27
        case 22221:
        // End:0x2F
        case 22222:
        // End:0x37
        case 22223:
        // End:0x3F
        case 22224:
        // End:0x47
        case 22225:
        // End:0x4F
        case 22226:
        // End:0x57
        case 22227:
        // End:0x5F
        case 22228:
        // End:0x67
        case 22229:
        // End:0x6F
        case 22230:
        // End:0x77
        case 33478:
        // End:0x7F
        case 33479:
        // End:0x87
        case 33455:
        // End:0x8F
        case 33456:
        // End:0x97
        case 33457:
        // End:0x9F
        case 33458:
        // End:0xA7
        case 33459:
        // End:0xAF
        case 33460:
        // End:0xB7
        case 33461:
        // End:0xBF
        case 33462:
        // End:0xC7
        case 33463:
        // End:0xCF
        case 33464:
        // End:0xD7
        case 33818:
        // End:0xDF
        case 34627:
        // End:0xE7
        case 33838:
        // End:0xEF
        case 33839:
        // End:0xF7
        case 33840:
        // End:0xFF
        case 33841:
        // End:0x107
        case 33842:
        // End:0x10F
        case 33843:
        // End:0x117
        case 33844:
        // End:0x11F
        case 33845:
        // End:0x127
        case 33846:
        // End:0x12F
        case 33847:
        // End:0x137
        case 33848:
        // End:0x13F
        case 33849:
        // End:0x147
        case 47392:
        // End:0x14F
        case 47804:
        // End:0x157
        case 47805:
        // End:0x15F
        case 48211:
        // End:0x167
        case 28593:
        // End:0x16F
        case 28594:
        // End:0x177
        case 28595:
        // End:0x17F
        case 28766:
        // End:0x187
        case 48498:
        // End:0x18F
        case 48264:
        // End:0x197
        case 48265:
        // End:0x19F
        case 90995:
        // End:0x1AC
        case 29163:
            return true;
            // End:0x1B4
            break;
        // End:0xFFFF
        default:
            return false;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1B4
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1B4
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1B4
}

function checkEventWarningText()
{
    switch(SelectHelperItemInfo.Id.ClassID)
    {
        // End:0x19
        case 40232:
        // End:0x3E
        case 40233:
            WarningTxt.SetText(GetSystemMessage(4278));
            // End:0x295
            break;
        // End:0x46
        case 23784:
        // End:0x4E
        case 39465:
        // End:0x56
        case 39464:
        // End:0x5E
        case 90480:
        // End:0x66
        case 90481:
        // End:0x6E
        case 90482:
        // End:0x9B
        case 90483:
            WarningTxt.SetText(GetSystemMessage(4144));
            isBreakable = false;
            // End:0x295
            break;
        // End:0xA3
        case 23783:
        // End:0xAB
        case 23784:
        // End:0xB3
        case 23785:
        // End:0xBB
        case 23786:
        // End:0xC3
        case 23787:
        // End:0xCB
        case 23788:
        // End:0xD3
        case 23789:
        // End:0xDB
        case 23790:
        // End:0xE3
        case 23791:
        // End:0xEB
        case 23792:
        // End:0xF3
        case 23793:
        // End:0xFB
        case 23794:
        // End:0x103
        case 23795:
        // End:0x10B
        case 23796:
        // End:0x113
        case 23797:
        // End:0x135
        case 23798:
            WarningTxt.HideWindow();
            isBreakable = false;
            // End:0x295
            break;
        // End:0x13D
        case 45416:
        // End:0x145
        case 45417:
        // End:0x14D
        case 45418:
        // End:0x155
        case 45419:
        // End:0x15D
        case 45420:
        // End:0x18A
        case 45421:
            WarningTxt.SetText(GetSystemMessage(4298));
            isBreakable = false;
            // End:0x295
            break;
        // End:0x192
        case 45422:
        // End:0x19A
        case 45423:
        // End:0x1A2
        case 45424:
        // End:0x1AA
        case 45425:
        // End:0x1B2
        case 45426:
        // End:0x1BA
        case 45427:
        // End:0x1C2
        case 47575:
        // End:0x1CA
        case 47576:
        // End:0x1D2
        case 47577:
        // End:0x1DA
        case 47622:
        // End:0x1E2
        case 47623:
        // End:0x1EA
        case 47624:
        // End:0x1F2
        case 28425:
        // End:0x1FA
        case 28426:
        // End:0x202
        case 28427:
        // End:0x20A
        case 28428:
        // End:0x212
        case 28429:
        // End:0x21A
        case 28430:
        // End:0x222
        case 90484:
        // End:0x22A
        case 90485:
        // End:0x232
        case 90486:
        // End:0x23A
        case 90487:
        // End:0x242
        case 28425:
        // End:0x24A
        case 28426:
        // End:0x252
        case 28427:
        // End:0x25A
        case 28428:
        // End:0x262
        case 28429:
        // End:0x28F
        case 28430:
            WarningTxt.SetText(GetSystemMessage(4278));
            isBreakable = false;
            // End:0x295
            break;
        // End:0xFFFF
        default:
            // End:0x295
            break;
            break;
    }
    return;
}

delegate onSuccessEnchant(ItemInfo item)
{
    return;
}

function HandleEnchantResult(string param)
{
    local int IntResult;
    local ItemID ItemID;
    local INT64 Count;
    local int CountInt;
    local ItemInfo ResultItem;
    local string EndTxt;
    local int EnchantValue, EnchantOption1, EnchantOption2, EnchantOption3;
    local ItemInfo EmptyItem, invenScrollInfo, invenSupportInfo;

    WarningTxt.HideWindow();
    EnchantProgressAnim.HideWindow();
    ParseInt(param, "Result", IntResult);
    ParseItemID(param, ItemID);
    ParseINT64(param, "Count", Count);
    ParseInt(param, "Count", CountInt);
    ParseInt(param, "EnchantValue", EnchantValue);
    ParseInt(param, "EnchantOption1", EnchantOption1);
    ParseInt(param, "EnchantOption2", EnchantOption2);
    ParseInt(param, "EnchantOption3", EnchantOption3);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(ItemID, ResultItem);
    EnchantItemSlotBackTex.HideWindow();
    EnchantedItemSlotBackTex.HideWindow();
    CloverItemSlotBackTex.HideWindow();
    EnchantBtn.DisableWindow();
    EnchantedItemSlot.Clear();
    EnchantedItemSlot.EnableTick();
    switch(IntResult)
    {
        // End:0x4C9
        case 0:
            bEnchantedbool = true;
            EnchantProgressAnim.HideWindow();
            EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
            EnchantProgressAnim.SetLoopCount(1);
            EnchantProgressAnim.Stop();
            EnchantProgressAnim.Play();
            PlaySound("ItemSound3.enchant_success");
            EnchantProgressAnim.ShowWindow();
            BackPattern.SetAlpha(0, 0.0000000);
            BackPattern.ShowWindow();
            BackPattern.SetAlpha(255, 2.0000000);
            SelectItemInfo.Enchanted = EnchantValue;
            mEnchantLevel = EnchantValue;
            SelectItemInfo.EnchantOption1 = EnchantOption1;
            SelectItemInfo.EnchantOption2 = EnchantOption2;
            SelectItemInfo.EnchantOption3 = EnchantOption3;
            SelectItemInfo.LookChangeIconPanel = EnchantOrCountIcon(SelectItemInfo);
            EnchantItemSlot.SetItem(0, SelectItemInfo);
            EnchantedItemSlot.SetItem(0, SelectItemInfo);
            EnchantedItemSlot.AddItem(SelectItemInfo);
            // End:0x33B
            if(isAGScrollState())
            {
                EndTxt = MakeFullSystemMsg(GetSystemMessage(4513), ("+" $ string(SelectItemInfo.Enchanted)) @ SelectItemInfo.Name, "");                
            }
            else
            {
                EndTxt = MakeFullSystemMsg(GetSystemMessage(2342), ("+" $ string(SelectItemInfo.Enchanted)) @ SelectItemInfo.Name, "");
            }
            InstructionTxt.SetText(EndTxt);
            EnchantedItemSlot.SetAlpha(0);
            EnchantedItemSlot.ShowWindow();
            EnchantedItemSlot.SetAlpha(255, 2.0000000);
            CloverItemSlot.HideWindow();
            EnchantItemSlot.HideWindow();
            EnchantScriptSlot.HideWindow();
            CloverItemSlot.HideWindow();
            EnchantBtn.EnableWindow();
            EnchantBtn.SetNameText(GetSystemString(3135));
            InventoryItem.GetItem(InventoryItem.FindItem(scrolltemInfo.Id), invenScrollInfo);
            InventoryItem.GetItem(InventoryItem.FindItem(SelectHelperItemInfo.Id), invenSupportInfo);
            // End:0x498
            if(__NFUN_408__(invenScrollInfo.ItemNum, (2)))
            {
                scrolltemInfo = EmptyItem;
            }
            // End:0x4B7
            if(__NFUN_408__(invenSupportInfo.ItemNum, (2)))
            {
                SelectHelperItemInfo = EmptyItem;
            }
            onSuccessEnchant(SelectItemInfo);
            // End:0x1011
            break;
        // End:0x6CE
        case 1:
            bEnchantedbool = true;
            EnchantProgressAnim.HideWindow();
            EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
            EnchantProgressAnim.SetLoopCount(1);
            EnchantProgressAnim.Stop();
            EnchantProgressAnim.Play();
            PlaySound("ItemSound3.enchant_fail");
            EnchantProgressAnim.ShowWindow();
            BackPattern.SetAlpha(0, 0.0000000);
            BackPattern.ShowWindow();
            BackPattern.SetAlpha(255, 2.0000000);
            // End:0x636
            if(ResultItem.Id.ClassID > 0)
            {
                ResultItem.ItemNum = Count;
                EnchantedItemSlot.SetAlpha(0);
                EnchantedItemSlot.SetItem(0, ResultItem);
                EnchantedItemSlot.AddItem(ResultItem);
                EnchantedItemSlot.ShowWindow();
                EnchantedItemSlot.SetAlpha(255, 2.0000000);
            }
            // End:0x653
            if(isAGScrollState())
            {
                EndTxt = GetSystemMessage(4511);                
            }
            else
            {
                EndTxt = MakeFullSystemMsg(GetSystemMessage(2343), ResultItem.Name, string(CountInt));
            }
            InstructionTxt.SetText(EndTxt);
            CloverItemSlot.HideWindow();
            EnchantItemSlot.HideWindow();
            EnchantScriptSlot.HideWindow();
            CloverItemSlot.HideWindow();
            // End:0x1011
            break;
        // End:0x6F4
        case 2:
            EnchantProgressAnim.HideWindow();
            Me.HideWindow();
            // End:0x1011
            break;
        // End:0x935
        case 3:
            bEnchantedbool = true;
            EnchantProgressAnim.HideWindow();
            EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
            EnchantProgressAnim.SetLoopCount(1);
            EnchantProgressAnim.Stop();
            EnchantProgressAnim.Play();
            PlaySound("ItemSound3.enchant_fail");
            EnchantProgressAnim.ShowWindow();
            BackPattern.SetAlpha(0, 0.0000000);
            BackPattern.ShowWindow();
            BackPattern.SetAlpha(255, 2.0000000);
            ResultItem.ItemNum = (1);
            EnchantedItemSlot.SetAlpha(0);
            SelectItemInfo.Enchanted = EnchantValue;
            SelectItemInfo.EnchantOption1 = EnchantOption1;
            SelectItemInfo.EnchantOption2 = EnchantOption2;
            SelectItemInfo.EnchantOption3 = EnchantOption3;
            SelectItemInfo.LookChangeIconPanel = EnchantOrCountIcon(SelectItemInfo);
            EnchantedItemSlot.SetItem(0, SelectItemInfo);
            EnchantedItemSlot.AddItem(SelectItemInfo);
            EnchantedItemSlot.ShowWindow();
            EnchantedItemSlot.SetAlpha(255, 2.0000000);
            // End:0x8BE
            if(isAGScrollState())
            {
                EndTxt = GetSystemMessage(4511);                
            }
            else
            {
                EndTxt = MakeFullSystemMsg(GetSystemMessage(2343), SelectItemInfo.Name, "1");
            }
            InstructionTxt.SetText(EndTxt);
            CloverItemSlot.HideWindow();
            EnchantItemSlot.HideWindow();
            EnchantScriptSlot.HideWindow();
            CloverItemSlot.HideWindow();
            // End:0x1011
            break;
        // End:0xB13
        case 4:
            bEnchantedbool = true;
            EnchantProgressAnim.HideWindow();
            EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
            EnchantProgressAnim.SetLoopCount(1);
            EnchantProgressAnim.Stop();
            EnchantProgressAnim.Play();
            PlaySound("ItemSound3.enchant_fail");
            EnchantProgressAnim.ShowWindow();
            BackPattern.SetAlpha(0, 0.0000000);
            BackPattern.ShowWindow();
            BackPattern.SetAlpha(255, 2.0000000);
            // End:0xA92
            if(ResultItem.Id.ClassID > 0)
            {
                ResultItem.ItemNum = (0);
                EnchantedItemSlot.SetAlpha(0);
                EnchantedItemSlot.SetItem(0, ResultItem);
                EnchantedItemSlot.AddItem(ResultItem);
                EnchantedItemSlot.SetAlpha(255, 2.0000000);
            }
            // End:0xAAF
            if(isAGScrollState())
            {
                EndTxt = GetSystemMessage(4511);                
            }
            else
            {
                EndTxt = MakeFullSystemMsg(GetSystemMessage(64), SelectItemInfo.Name, "");
            }
            InstructionTxt.SetText(EndTxt);
            CloverItemSlot.HideWindow();
            EnchantItemSlot.HideWindow();
            EnchantScriptSlot.HideWindow();
            // End:0x1011
            break;
        // End:0xD01
        case 5:
            bEnchantedbool = true;
            EnchantProgressAnim.HideWindow();
            EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
            EnchantProgressAnim.SetLoopCount(1);
            EnchantProgressAnim.Stop();
            EnchantProgressAnim.Play();
            PlaySound("ItemSound3.enchant_fail");
            EnchantProgressAnim.ShowWindow();
            BackPattern.SetAlpha(0, 0.0000000);
            BackPattern.ShowWindow();
            BackPattern.SetAlpha(255, 2.0000000);
            SelectItemInfo.LookChangeIconPanel = EnchantOrCountIcon(SelectItemInfo);
            ResultItem.ItemNum = (1);
            EnchantedItemSlot.SetAlpha(0);
            EnchantedItemSlot.SetItem(0, SelectItemInfo);
            EnchantedItemSlot.AddItem(SelectItemInfo);
            EnchantedItemSlot.ShowWindow();
            EnchantedItemSlot.SetAlpha(255, 2.0000000);
            // End:0xC9D
            if(isAGScrollState())
            {
                EndTxt = GetSystemMessage(4509);                
            }
            else
            {
                EndTxt = GetSystemMessage(6004);
            }
            InstructionTxt.SetText(EndTxt);
            CloverItemSlot.HideWindow();
            EnchantItemSlot.HideWindow();
            EnchantScriptSlot.HideWindow();
            CloverItemSlot.HideWindow();
            // End:0x1011
            break;
        // End:0x100B
        case 6:
            bEnchantedbool = true;
            EnchantProgressAnim.HideWindow();
            EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
            EnchantProgressAnim.SetLoopCount(1);
            EnchantProgressAnim.Stop();
            EnchantProgressAnim.Play();
            PlaySound("ItemSound3.enchant_fail");
            EnchantProgressAnim.ShowWindow();
            BackPattern.SetAlpha(0, 0.0000000);
            BackPattern.ShowWindow();
            BackPattern.SetAlpha(255, 2.0000000);
            SelectItemInfo.Enchanted = EnchantValue;
            mEnchantLevel = EnchantValue;
            SelectItemInfo.EnchantOption1 = EnchantOption1;
            SelectItemInfo.EnchantOption2 = EnchantOption2;
            SelectItemInfo.EnchantOption3 = EnchantOption3;
            SelectItemInfo.LookChangeIconPanel = EnchantOrCountIcon(SelectItemInfo);
            EnchantItemSlot.SetItem(0, SelectItemInfo);
            EnchantedItemSlot.SetItem(0, SelectItemInfo);
            EnchantedItemSlot.AddItem(SelectItemInfo);
            EndTxt = MakeFullSystemMsg(GetSystemMessage(2343), ("+" $ string(SelectItemInfo.Enchanted)) @ SelectItemInfo.Name, "1");
            InstructionTxt.SetText(EndTxt);
            EnchantedItemSlot.SetAlpha(0);
            EnchantedItemSlot.ShowWindow();
            EnchantedItemSlot.SetAlpha(255, 2.0000000);
            CloverItemSlot.HideWindow();
            EnchantItemSlot.HideWindow();
            EnchantScriptSlot.HideWindow();
            CloverItemSlot.HideWindow();
            EnchantBtn.EnableWindow();
            EnchantBtn.SetNameText(GetSystemString(3135));
            InventoryItem.GetItem(InventoryItem.FindItem(scrolltemInfo.Id), invenScrollInfo);
            InventoryItem.GetItem(InventoryItem.FindItem(SelectHelperItemInfo.Id), invenSupportInfo);
            // End:0xFE9
            if(__NFUN_408__(invenScrollInfo.ItemNum, (2)))
            {
                scrolltemInfo = EmptyItem;
            }
            // End:0x1008
            if(__NFUN_408__(invenSupportInfo.ItemNum, (2)))
            {
                SelectHelperItemInfo = EmptyItem;
            }
            // End:0x1011
            break;
        // End:0xFFFF
        default:
            // End:0x1011
            break;
            break;
    }
    ExitBtn.SetNameText(GetSystemString(646));
    ExitBtn.EnableWindow();
    return;
}

function SetIsShopping(bool isShopping)
{
    bIsShopping = isShopping;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    OnClickButton("ExitBtn");
    return;
}
