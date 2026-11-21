class ItemJewelEnchantWnd extends UICommonAPI;

const C_ANIMLOOPCOUNT = 1;
const TIMER_ID = 1002012;
const TIMER_DELAY = 1000;
const DLG_ID_CRASH_ALERT = 1;

var bool bEnchantbool;
var bool bEnchantedbool;
var bool isBreakable;
var WindowHandle Me;
var TextureHandle BackPattern;
var TextBoxHandle InstructionTxt;
var ItemWindowHandle EnchantJewel1;
var ItemWindowHandle EnchantJewel2;
var ItemWindowHandle EnchantedItemSlot;
var ButtonHandle EnchantBtn;
var ButtonHandle ExitBtn;
var ButtonHandle InitBtn;
var TextureHandle GroupBox2;
var TextureHandle GroupBox1;
var TextureHandle EnchantJewel1BackTex;
var TextureHandle EnchantJewel2BackTex;
var TextureHandle EnchantedJewelBackTex;
var TextureHandle DropHighlight_EnchantJewel2;
var TextureHandle DropHighlight_EnchantJewel1;
var AnimTextureHandle EnchantProgressAnim;
var ProgressCtrlHandle m_hItemEnchantWndEnchantProgress;
var ItemWindowHandle InventoryItem;
var ItemInfo continueSlot1ItemInfo;
var ItemInfo continueSlot2ItemInfo;
var TextBoxHandle WarningTxt;
var CheckBoxHandle EnchantSpeedCBox;
var ItemInfo Jewel1ItemInfo;
var ItemInfo Jewel2ItemInfo;
var bool bRequestPushOne;
var bool bRequestPushTwo;
var bool bRequestRemoveOne;
var bool bRequestRemoveTwo;
var ItemJewelEnchantSubWnd ItemJewelEnchantSubWndScript;
var ItemWindowHandle ItemJewelEnchantSubWnd_ItemWnd;

function OnLoad()
{
    SetClosingOnESC();
    Me = GetWindowHandle("ItemJewelEnchantWnd");
    ItemJewelEnchantSubWndScript = ItemJewelEnchantSubWnd(GetScript("ItemJewelEnchantSubWnd"));
    EnchantProgressAnim = GetAnimTextureHandle("ItemJewelEnchantWnd.EnchantProgressAnim");
    BackPattern = GetTextureHandle("ItemJewelEnchantWnd.BackPattern");
    InstructionTxt = GetTextBoxHandle("ItemJewelEnchantWnd.InstructionTxt");
    EnchantJewel1 = GetItemWindowHandle("ItemJewelEnchantWnd.EnchantJewel1");
    EnchantJewel2 = GetItemWindowHandle("ItemJewelEnchantWnd.EnchantJewel2");
    EnchantedItemSlot = GetItemWindowHandle("ItemJewelEnchantWnd.EnchantedItemSlot");
    EnchantBtn = GetButtonHandle("ItemJewelEnchantWnd.EnchantBtn");
    ExitBtn = GetButtonHandle("ItemJewelEnchantWnd.ExitBtn");
    InitBtn = GetButtonHandle("ItemJewelEnchantWnd.InitBtn");
    GroupBox2 = GetTextureHandle("ItemJewelEnchantWnd.Groupbox2");
    GroupBox1 = GetTextureHandle("ItemJewelEnchantWnd.Groupbox1");
    EnchantJewel1BackTex = GetTextureHandle("ItemJewelEnchantWnd.EnchantJewel1BackTex");
    EnchantJewel2BackTex = GetTextureHandle("ItemJewelEnchantWnd.EnchantJewel2BackTex");
    EnchantedJewelBackTex = GetTextureHandle("ItemJewelEnchantWnd.EnchantedJewelBackTex");
    DropHighlight_EnchantJewel2 = GetTextureHandle("ItemJewelEnchantWnd.DropHighlight_EnchantJewel2");
    DropHighlight_EnchantJewel1 = GetTextureHandle("ItemJewelEnchantWnd.DropHighlight_EnchantJewel1");
    m_hItemEnchantWndEnchantProgress = GetProgressCtrlHandle("ItemJewelEnchantWnd.EnchantProgress");
    InventoryItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
    WarningTxt = GetTextBoxHandle("ItemJewelEnchantWnd.WarningTxt");
    EnchantSpeedCBox = GetCheckBoxHandle("ItemJewelEnchantWnd.EnchantSpeedCBox");
    ItemJewelEnchantSubWnd_ItemWnd = GetItemWindowHandle("ItemJewelEnchantSubWnd.ItemJewelEnchantSubWnd_ItemWnd");
    Initialize();
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    HandleHighlight();
    HandleInstructionTxt();
    checkEnchantBtn();
    ExitBtn.SetNameText(GetSystemString(646));
    EnchantBtn.SetNameText(GetSystemString(428));
    GetWindowHandle("ItemJewelEnchantSubWnd").ShowWindow();
    InitBtn.DisableWindow();
    Initialize();
    return;
}

function Initialize()
{
    bEnchantbool = false;
    bEnchantedbool = false;
    bRequestPushOne = false;
    bRequestPushTwo = false;
    bRequestRemoveOne = false;
    bRequestRemoveTwo = false;
    loadOption();
    return;
}

function loadOption()
{
    local int currEnType;

    currEnType = GetOptionInt("Game", "JewelEnchantSpeedType");
    // End:0x47
    if(currEnType == 0)
    {
        EnchantSpeedCBox.SetCheck(false);        
    }
    else
    {
        // End:0x62
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
        // End:0x7C
        case "EnchantSpeedCBox":
            // End:0x55
            if(EnchantSpeedCBox.IsChecked())
            {
                SetOptionInt("Game", "JewelEnchantSpeedType", 1);                
            }
            else
            {
                SetOptionInt("Game", "JewelEnchantSpeedType", 0);
            }
            // End:0x82
            break;
        // End:0xFFFF
        default:
            // End:0x82
            break;
            break;
    }
    return;
}

function int getProgressSpeed()
{
    // End:0x32
    if(GetOptionInt("Game", "JewelEnchantSpeedType") == 1)
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
    // End:0x32
    if(GetOptionInt("Game", "JewelEnchantSpeedType") == 1)
    {
        return 0.3300000;        
    }
    else
    {
        return 1.5000000;
    }
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(9760);
    RegisterEvent(9770);
    RegisterEvent(9780);
    RegisterEvent(9790);
    RegisterEvent(9800);
    RegisterEvent(9810);
    RegisterEvent(9820);
    RegisterEvent(9830);
    RegisterEvent(9840);
    RegisterEvent(9850);
    RegisterEvent(9851);
    RegisterEvent(9852);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function HandleShowDialog()
{
    Class'Interface.UICommonAPI'.static.DialogSetID(1);
    Class'Interface.UICommonAPI'.static.DialogShow(1, 0, GetSystemMessage(4149), string(self));
    return;
}

function OnClickButton(string Name)
{
    local ItemID ItemID1, ItemID2;

    switch(Name)
    {
        // End:0x7C
        case "InitBtn":
            EnchantBtn.EnableWindow();
            Me.KillTimer(1002012);
            // End:0x63
            if(bEnchantedbool)
            {
                ClearAllItems();
                HandleGoToFirstStep();
                HandleHighlight();
                Class'NWindow.NewEnchantAPI'.static.RequestClose();                
            }
            else
            {
                OnDBClickItem("EnchantJewel1", 0);
            }
            // End:0x1E2
            break;
        // End:0x162
        case "EnchantBtn":
            // End:0x121
            if(bEnchantedbool)
            {
                ClearAllItems();
                HandleGoToFirstStep();
                HandleHighlight();
                ItemID1 = dropProcess(continueSlot1ItemInfo, 1, true);
                ItemID2 = dropProcess(continueSlot2ItemInfo, 2, true);
                // End:0x115
                if((ItemID1.ServerID > 0) && ItemID2.ServerID > 0)
                {
                    Class'NWindow.NewEnchantAPI'.static.RequestEnchantRetryPutItems(ItemID1.ServerID, ItemID2.ServerID);                    
                }
                else
                {
                    HandleNewEnchantRetryPutItems(false, "");
                }                
            }
            else
            {
                bEnchantbool = true;
                EnchantBtn.DisableWindow();
                // End:0x159
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
            // End:0x1E2
            break;
        // End:0x1DF
        case "ExitBtn":
            // End:0x1CD
            if(bEnchantbool)
            {
                EnchantBtn.EnableWindow();
                Me.KillTimer(1002012);
                InitBtn.EnableWindow();
                HandleGoToFirstStep();
                // End:0x1CA
                if(Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
                {
                    DialogHide();
                }                
            }
            else
            {
                Me.HideWindow();
            }
            // End:0x1E2
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function handleAddJewel1(string param)
{
    // End:0x1A
    if(!Me.IsShowWindow())
    {
        HandleEnchantShow();
    }
    EnchantJewel1.Clear();
    EnchantJewel1.AddItem(Jewel1ItemInfo);
    EnchantJewel1BackTex.HideWindow();
    bRequestPushOne = false;
    HandleHighlight();
    checkEnchantBtn();
    HandleInstructionTxt();
    continueSlot1ItemInfo = Jewel1ItemInfo;
    ItemJewelEnchantSubWndScript.refresh();
    return;
}

function handleAddJewel2(string param)
{
    EnchantJewel2.Clear();
    EnchantJewel2.AddItem(Jewel2ItemInfo);
    EnchantJewel2BackTex.HideWindow();
    continueSlot2ItemInfo = Jewel2ItemInfo;
    bRequestPushTwo = false;
    HandleHighlight();
    checkEnchantBtn();
    HandleInstructionTxt();
    ItemJewelEnchantSubWndScript.refresh();
    return;
}

function handleRemoveJewel1(string param)
{
    EnchantJewel1.Clear();
    bRequestRemoveOne = false;
    EnchantJewel1BackTex.ShowWindow();
    HandleHighlight();
    HandleInstructionTxt();
    checkEnchantBtn();
    InitBtn.DisableWindow();
    ItemJewelEnchantSubWndScript.refresh();
    return;
}

function handleRemoveJewel2(string param)
{
    EnchantJewel2.Clear();
    bRequestRemoveTwo = false;
    EnchantJewel2BackTex.ShowWindow();
    HandleHighlight();
    HandleInstructionTxt();
    WarningTxt.HideWindow();
    ItemJewelEnchantSubWndScript.refresh();
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 9760:
            handleAddJewel1(param);
            // End:0x12A
            break;
        // End:0x30
        case 9770:
            bRequestPushOne = false;
            // End:0x12A
            break;
        // End:0x46
        case 9780:
            handleAddJewel2(param);
            // End:0x12A
            break;
        // End:0x59
        case 9790:
            bRequestPushTwo = false;
            // End:0x12A
            break;
        // End:0x6F
        case 9800:
            handleRemoveJewel1(param);
            // End:0x12A
            break;
        // End:0x88
        case 9810:
            bRequestRemoveOne = false;
            checkEnchantBtn();
            // End:0x12A
            break;
        // End:0x9E
        case 9820:
            handleRemoveJewel2(param);
            // End:0x12A
            break;
        // End:0xB7
        case 9830:
            bRequestRemoveTwo = false;
            checkEnchantBtn();
            // End:0x12A
            break;
        // End:0xCD
        case 9840:
            handleEnchantSuccess(param);
            // End:0x12A
            break;
        // End:0xE3
        case 9850:
            handleEnchantFail(param);
            // End:0x12A
            break;
        // End:0xFA
        case 9851:
            HandleNewEnchantRetryPutItems(true, param);
            // End:0x12A
            break;
        // End:0x111
        case 9852:
            HandleNewEnchantRetryPutItems(false, param);
            // End:0x12A
            break;
        // End:0x11C
        case 1710:
            // End:0x12A
            break;
        // End:0x127
        case 1720:
            // End:0x12A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleNewEnchantRetryPutItems(bool bSuccess, string param)
{
    local ItemInfo emptyItemInfo;

    // End:0x1C
    if(bSuccess)
    {
        handleAddJewel1("");
        handleAddJewel2("");        
    }
    else
    {
        Jewel1ItemInfo = emptyItemInfo;
        Jewel2ItemInfo = emptyItemInfo;
        handleRemoveJewel1("");
        handleRemoveJewel2("");
    }
    // End:0x5D
    if(!hasItemInSlot(1))
    {
        ItemJewelEnchantSubWndScript.refresh();
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
    DlgID = Class'Interface.UICommonAPI'.static.DialogGetID();
    switch(DlgID)
    {
        // End:0x57
        case 1:
            HandleDlGCrashAlert(bOK);
            // End:0x5A
            break;
        // End:0xFFFF
        default:
            break;
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

function HandleInstructionTxt()
{
    local int systemMessage;
    local ItemInfo tmpItem1, tmpItem2;

    EnchantJewel1.GetItem(0, tmpItem1);
    EnchantJewel2.GetItem(0, tmpItem2);
    // End:0x64
    if((tmpItem1.Id.ServerID < 1) || tmpItem2.Id.ServerID < 1)
    {
        systemMessage = 4232;        
    }
    else
    {
        systemMessage = 4233;
    }
    InstructionTxt.SetText(GetSystemMessage(systemMessage));
    return;
}

function HandleHighlight()
{
    local ItemInfo tmpItem1, tmpItem2;

    DropHighlight_EnchantJewel1.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
    DropHighlight_EnchantJewel2.SetTexture("L2UI_ch3.RefineryWnd.refineslot2");
    EnchantJewel1.GetItem(0, tmpItem1);
    EnchantJewel2.GetItem(0, tmpItem2);
    // End:0xEC
    if((tmpItem1.Id.ServerID < 1) && tmpItem2.Id.ServerID < 1)
    {
        DropHighlight_EnchantJewel1.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");        
    }
    else
    {
        // End:0x132
        if(tmpItem1.Id.ServerID > 1)
        {
            DropHighlight_EnchantJewel2.SetTexture("L2UI_ch3.RefineryWnd.refineslot1");
        }
    }
    return;
}

function HandleGoToFirstStep()
{
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
    EnchantJewel1.DisableTick();
    EnchantJewel2.DisableTick();
    EnchantedItemSlot.DisableTick();
    EnchantedItemSlot.Clear();
    EnchantJewel1BackTex.ShowWindow();
    EnchantJewel2BackTex.ShowWindow();
    ResetUI();
    HandleHighlight();
    HandleInstructionTxt();
    checkEnchantBtn();
    ExitBtn.SetNameText(GetSystemString(646));
    EnchantBtn.SetNameText(GetSystemString(428));
    return;
}

function OnEnchantBtnClick()
{
    local Rect Item1Rect, Item2Rect, ResultRect;

    EnchantProgressAnim.SetLoopCount(1);
    EnchantProgressAnim.Stop();
    EnchantProgressAnim.Play();
    PlaySound("ItemSound3.enchant_process");
    EnchantProgressAnim.ShowWindow();
    m_hItemEnchantWndEnchantProgress.SetProgressTime(getProgressSpeed());
    m_hItemEnchantWndEnchantProgress.Start();
    Item1Rect = EnchantJewel1.GetRect();
    Item2Rect = EnchantJewel2.GetRect();
    ResultRect = EnchantedItemSlot.GetRect();
    EnchantJewel1.EnableTick();
    EnchantJewel2.EnableTick();
    EnchantJewel1.Move(ResultRect.nX - Item1Rect.nX, ResultRect.nY - Item1Rect.nY, getAnimSpeed());
    EnchantJewel2.Move(ResultRect.nX - Item2Rect.nX, ResultRect.nY - Item2Rect.nY, getAnimSpeed());
    EnchantJewel1BackTex.HideWindow();
    EnchantJewel2BackTex.HideWindow();
    EnchantedJewelBackTex.HideWindow();
    ExitBtn.SetNameText(GetSystemString(141));
    EnchantBtn.SetNameText(GetSystemString(428));
    EnchantSpeedCBox.HideWindow();
    InitBtn.DisableWindow();
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

function ProcCancel()
{
    bEnchantbool = false;
    m_hItemEnchantWndEnchantProgress.Stop();
    EnchantProgressAnim.Stop();
    return;
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
    EnchantProgressAnim.HideWindow();
    EnchantProgressAnim.Stop();
    EnchantProgressAnim.HideWindow();
    switch(a_WindowHandle)
    {
        // End:0x5F
        case EnchantProgressAnim:
            // End:0x5C
            if(bEnchantbool)
            {
                bEnchantbool = false;
                Class'NWindow.NewEnchantAPI'.static.RequestTryEnchant();
            }
            // End:0x62
            break;
        // End:0xFFFF
        default:
            break;
    }
    EnchantProgressAnim.HideWindow();
    return;
}

function HandleEnchantShow()
{
    ResetUI();
    ClearAllItems();
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function bool bRequesteEnd()
{
    return ((!bRequestPushOne && !bRequestPushTwo) && !bRequestRemoveOne) && !bRequestRemoveTwo;
    return;
}

function bool bJewelAllReady()
{
    local ItemInfo tmpItem, tmpItem2;

    EnchantJewel2.GetItem(0, tmpItem);
    // End:0x2C
    if(tmpItem.Id.ServerID < 1)
    {
        return false;
    }
    EnchantJewel1.GetItem(0, tmpItem2);
    // End:0x58
    if(tmpItem2.Id.ServerID < 1)
    {
        return false;
    }
    return true;
    return;
}

function checkEnchantBtn()
{
    local bool isEnableEnchantBtn, bNoFailResult;

    isEnableEnchantBtn = ((bRequesteEnd()) && bJewelAllReady()) && !bEnchantbool && !bEnchantedbool;
    // End:0xC4
    if(isEnableEnchantBtn)
    {
        EnchantBtn.EnableWindow();
        bNoFailResult = Class'NWindow.NewEnchantAPI'.static.IsNoFailResultEffectType(getSlotItemWindowByIndex(1), getSlotItemWindowByIndex(2));
        // End:0x98
        if(bNoFailResult == true)
        {
            WarningTxt.SetText(GetSystemMessage(4424));            
        }
        else
        {
            WarningTxt.SetText(GetSystemMessage(4234));
        }
        WarningTxt.ShowWindow();        
    }
    else
    {
        // End:0x10D
        if(((hasItemInSlot(1)) == false) && (hasItemInSlot(2)) == false)
        {
            WarningTxt.ShowWindow();
            WarningTxt.SetText(GetSystemString(3501));            
        }
        else
        {
            WarningTxt.HideWindow();
            EnchantBtn.DisableWindow();
        }
    }
    // End:0x154
    if((hasItemInSlot(1)) || hasItemInSlot(2))
    {
        InitBtn.EnableWindow();        
    }
    else
    {
        InitBtn.DisableWindow();
    }
    return;
}

function bool hasItemInSlot(int SlotIndex)
{
    local ItemInfo Info;
    local bool bFlag;

    // End:0x23
    if(SlotIndex == 1)
    {
        EnchantJewel1.GetItem(0, Info);        
    }
    else
    {
        EnchantJewel2.GetItem(0, Info);
    }
    // End:0x55
    if(Info.Id.ClassID > 0)
    {
        bFlag = true;
    }
    return bFlag;
    return;
}

function ClearAllItems()
{
    EnchantJewel1.Clear();
    EnchantJewel2.Clear();
    EnchantedItemSlot.Clear();
    return;
}

function ResetUI()
{
    EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Loading_01");
    EnchantProgressAnim.HideWindow();
    BackPattern.HideWindow();
    InstructionTxt.SetText("");
    EnchantedItemSlot.SetAnchor("ItemJewelEnchantWnd", "TopLeft", "TopLeft", 116, 90);
    EnchantedItemSlot.SetWindowSize(34, 34);
    EnchantedItemSlot.ClearAnchor();
    EnchantedItemSlot.ShowWindow();
    EnchantBtn.DisableWindow();
    EnchantSpeedCBox.ShowWindow();
    EnchantJewel1.SetAnchor("ItemJewelEnchantWnd", "TopLeft", "TopLeft", 78, 90);
    EnchantJewel1.SetWindowSize(34, 34);
    EnchantJewel1.ClearAnchor();
    EnchantJewel1.ShowWindow();
    EnchantJewel2.SetAnchor("ItemJewelEnchantWnd", "TopLeft", "TopLeft", 157, 90);
    EnchantJewel2.SetWindowSize(34, 34);
    EnchantJewel2.ClearAnchor();
    EnchantJewel2.ShowWindow();
    EnchantJewel1BackTex.SetAnchor("ItemJewelEnchantWnd", "TopLeft", "TopLeft", 77, 90);
    EnchantJewel1BackTex.ClearAnchor();
    EnchantJewel1BackTex.ShowWindow();
    EnchantJewel2BackTex.SetAnchor("ItemJewelEnchantWnd", "TopLeft", "TopLeft", 156, 90);
    EnchantJewel2BackTex.ClearAnchor();
    EnchantJewel2BackTex.ShowWindow();
    EnchantedJewelBackTex.HideWindow();
    m_hItemEnchantWndEnchantProgress.SetProgressTime(getProgressSpeed());
    m_hItemEnchantWndEnchantProgress.SetPos(0);
    m_hItemEnchantWndEnchantProgress.Reset();
    return;
}

function OnHide()
{
    Class'NWindow.NewEnchantAPI'.static.RequestClose();
    ResetUI();
    ClearAllItems();
    Initialize();
    GetWindowHandle("ItemJewelEnchantSubWnd").HideWindow();
    EnchantBtn.EnableWindow();
    Me.KillTimer(1002012);
    return;
}

function bool IsEnchantableItem(INT64 SlotBitType)
{
    return __NFUN_412__(SlotBitType, (1073741824));
    return;
}

function handleDropedItem(ItemInfo a_ItemInfo)
{
    local ItemInfo tmpJewelItemInfo1, tmpJewelItemInfo2;

    EnchantJewel1.GetItem(0, tmpJewelItemInfo1);
    EnchantJewel2.GetItem(0, tmpJewelItemInfo2);
    // End:0x54
    if((bEnchantbool || bEnchantedbool) && Me.IsShowWindow())
    {
        return;
    }
    // End:0x92
    if((IsSameItemID(tmpJewelItemInfo1.Id, a_ItemInfo.Id)) || IsSameItemID(tmpJewelItemInfo2.Id, a_ItemInfo.Id))
    {
        return;
    }
    // End:0xD6
    if(tmpJewelItemInfo1.Id.ServerID == 0)
    {
        Class'NWindow.NewEnchantAPI'.static.RequestPushOne(a_ItemInfo.Id);
        bRequestPushOne = true;
        Jewel1ItemInfo = a_ItemInfo;        
    }
    else
    {
        Class'NWindow.NewEnchantAPI'.static.RequestPushTwo(a_ItemInfo.Id);
        bRequestPushTwo = true;
        Jewel2ItemInfo = a_ItemInfo;
    }
    return;
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    local Rect rectWnd;

    // End:0x15
    if(a_ItemInfo.ItemSubType == int(4))
    {
        return;
    }
    // End:0x46
    if(a_ItemInfo.DragSrcName != "ItemJewelEnchantSubWnd_ItemWnd")
    {
        return;
    }
    rectWnd = Me.GetRect();
    // End:0x71
    if(bEnchantbool || bEnchantedbool)
    {
        return;
    }
    // End:0x10D
    if((((X > (rectWnd.nX + 9)) && X < ((rectWnd.nX + 9) + rectWnd.nWidth)) && Y > (rectWnd.nY + 39)) && Y < ((rectWnd.nY + 39) + 137))
    {
        // End:0x101
        if(hasItemInSlot(1))
        {
            dropProcess(a_ItemInfo, 2);            
        }
        else
        {
            dropProcess(a_ItemInfo, 1);
        }
    }
    return;
}

function ItemID dropProcess(ItemInfo a_ItemInfo, int SlotIndex, optional bool bNoRequestServer)
{
    local ItemInfo tmpJewelItemInfo1, tmpJewelItemInfo2;
    local ItemID emptyItemID;
    local int hasItemCount, i, selectIndex;
    local array<ItemInfo> itemInfoArray;
    local ItemInfo ServerIDItemInfo;

    // End:0x19
    if(a_ItemInfo.ItemSubType == int(4))
    {
        return emptyItemID;
    }
    // End:0x33
    if(bEnchantbool || bEnchantedbool)
    {
        return emptyItemID;
    }
    EnchantJewel1.GetItem(0, tmpJewelItemInfo1);
    EnchantJewel2.GetItem(0, tmpJewelItemInfo2);
    // End:0xA4
    if(SlotIndex == 0)
    {
        // End:0x87
        if(tmpJewelItemInfo1.Id.ClassID <= 0)
        {
            SlotIndex = 1;            
        }
        else
        {
            // End:0xA4
            if(tmpJewelItemInfo2.Id.ClassID <= 0)
            {
                SlotIndex = 2;
            }
        }
    }
    // End:0xE7
    if(IsStackableItem(a_ItemInfo.ConsumeType))
    {
        InventoryItem.GetItem(InventoryItem.FindItemByClassID(a_ItemInfo.Id), a_ItemInfo);        
    }
    else
    {
        // End:0x152
        if(SlotIndex == 1)
        {
            hasItemCount = 0;
            // End:0x133
            if(getInstanceL2Util().FindItemByServerID(a_ItemInfo.Id.ServerID, ServerIDItemInfo, getInstanceL2Util().2))
            {
                hasItemCount = 1;
            }
            a_ItemInfo = ServerIDItemInfo;
            // End:0x14F
            if(hasItemCount <= 0)
            {
                return emptyItemID;
            }            
        }
        else
        {
            // End:0x21D
            if(SlotIndex == 2)
            {
                hasItemCount = getInstanceL2Util().FindItemByClassID(a_ItemInfo.Id.ClassID, itemInfoArray, getInstanceL2Util().2);
                selectIndex = -1;
                i = 0;
                J0x1A6:

                // End:0x1F7 [Loop If]
                if(i < itemInfoArray.Length)
                {
                    // End:0x1ED
                    if(itemInfoArray[i].Id.ServerID != Jewel1ItemInfo.Id.ServerID)
                    {
                        selectIndex = i;
                        // [Explicit Break]
                        goto J0x1F7;
                    }
                    i++;
                    // [Loop Continue]
                    goto J0x1A6;
                }
                J0x1F7:

                // End:0x20C
                if(selectIndex == -1)
                {
                    return emptyItemID;
                }
                a_ItemInfo = itemInfoArray[selectIndex];
            }
        }
    }
    // End:0x271
    if(SlotIndex == 1)
    {
        // End:0x24D
        if(bNoRequestServer == false)
        {
            Class'NWindow.NewEnchantAPI'.static.RequestPushOne(a_ItemInfo.Id);
        }
        bRequestPushOne = true;
        a_ItemInfo.ItemNum = (1);
        Jewel1ItemInfo = a_ItemInfo;        
    }
    else
    {
        // End:0x2C3
        if(SlotIndex == 2)
        {
            // End:0x2A2
            if(bNoRequestServer == false)
            {
                Class'NWindow.NewEnchantAPI'.static.RequestPushTwo(a_ItemInfo.Id);
            }
            bRequestPushTwo = true;
            a_ItemInfo.ItemNum = (1);
            Jewel2ItemInfo = a_ItemInfo;
        }
    }
    return a_ItemInfo.Id;
    return;
}

function OnRClickItem(string strID, int Index)
{
    OnDBClickItem(strID, Index);
    return;
}

function OnDBClickItem(string ControlName, int Index)
{
    local ItemInfo tmpJewelItemInfo1, tmpJewelItemInfo2;

    // End:0x0B
    if(bEnchantbool)
    {
        return;
    }
    switch(ControlName)
    {
        // End:0x73
        case "EnchantJewel1":
            // End:0x73
            if(hasItemInSlot(1))
            {
                EnchantJewel1.GetItem(0, tmpJewelItemInfo1);
                bRequestRemoveOne = true;
                EnchantBtn.DisableWindow();
                Class'NWindow.NewEnchantAPI'.static.RequestRemoveOne(tmpJewelItemInfo1.Id);
            }
        // End:0xD8
        case "EnchantJewel2":
            // End:0xD5
            if(hasItemInSlot(2))
            {
                EnchantJewel2.GetItem(0, tmpJewelItemInfo2);
                bRequestRemoveTwo = true;
                EnchantBtn.DisableWindow();
                Class'NWindow.NewEnchantAPI'.static.RequestRemoveTwo(tmpJewelItemInfo2.Id);
            }
            // End:0xDB
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnDropItemSource(string strTarget, ItemInfo Info)
{
    local ItemInfo tmpJewelItemInfo1, tmpJewelItemInfo2;

    // End:0x16
    if(bEnchantbool || bEnchantedbool)
    {
        return;
    }
    // End:0xEC
    if(strTarget == "Console")
    {
        switch(Info.DragSrcName)
        {
            // End:0x8F
            case "EnchantJewel1":
                EnchantJewel1.GetItem(0, tmpJewelItemInfo1);
                bRequestRemoveOne = true;
                EnchantBtn.DisableWindow();
                Class'NWindow.NewEnchantAPI'.static.RequestRemoveOne(tmpJewelItemInfo1.Id);
                // End:0xEC
                break;
            // End:0xE9
            case "EnchantJewel2":
                EnchantJewel2.GetItem(0, tmpJewelItemInfo2);
                bRequestRemoveTwo = true;
                EnchantBtn.DisableWindow();
                Class'NWindow.NewEnchantAPI'.static.RequestRemoveTwo(tmpJewelItemInfo2.Id);
                // End:0xEC
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

function handleEnchantEnd(ItemInfo ResultItem)
{
    bEnchantedbool = true;
    WarningTxt.HideWindow();
    EnchantProgressAnim.HideWindow();
    EnchantedJewelBackTex.HideWindow();
    EnchantedItemSlot.EnableTick();
    EnchantProgressAnim.HideWindow();
    EnchantProgressAnim.SetLoopCount(1);
    EnchantProgressAnim.Stop();
    EnchantProgressAnim.Play();
    EnchantProgressAnim.ShowWindow();
    BackPattern.SetAlpha(0, 0.0000000);
    BackPattern.ShowWindow();
    BackPattern.SetAlpha(255, 2.0000000);
    EnchantedItemSlot.SetAlpha(0);
    EnchantedItemSlot.SetItem(0, ResultItem);
    EnchantedItemSlot.AddItem(ResultItem);
    EnchantedItemSlot.ShowWindow();
    EnchantedItemSlot.SetAlpha(255, 2.0000000);
    EnchantJewel1.Clear();
    EnchantJewel2.Clear();
    EnchantJewel2.HideWindow();
    EnchantJewel1.HideWindow();
    Me.SetTimer(1002012, 1000);
    EnchantBtn.SetNameText(GetSystemString(3135));
    InitBtn.EnableWindow();
    return;
}

function handleEnchantFail(string param)
{
    local ItemInfo ResultItem;
    local bool bNoFailResult, bUseGetItemNum;
    local int ResultItemClassID, ResultItemNum, FailResultItemClassID, FailResultItemNum;

    bNoFailResult = Class'NWindow.NewEnchantAPI'.static.IsNoFailResultEffectType(getSlotItemWindowByIndex(1), getSlotItemWindowByIndex(2));
    ParseInt(param, "ItemClassID", ResultItem.Id.ClassID);
    Debug("������ �������� �Ұ��ΰ�? bNoFailResult:" @ string(bNoFailResult));
    Debug("handleEnchantFail param:" @ param);
    // End:0xF7
    if(ResultItem.Id.ClassID == 0)
    {
        Me.HideWindow();
        return;
    }
    bUseGetItemNum = Class'NWindow.NewEnchantAPI'.static.GetResultItemForEnchant(getSlotItemWindowByIndex(1), getSlotItemWindowByIndex(2), ResultItemClassID, ResultItemNum, FailResultItemClassID, FailResultItemNum);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(ResultItem.Id, ResultItem);
    // End:0x1E7
    if(bNoFailResult)
    {
        EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
        PlaySound("ItemSound3.enchant_success");
        InstructionTxt.SetText(MakeFullSystemMsg(GetSystemMessage(4417), ResultItem.Name, string(FailResultItemNum)));        
    }
    else
    {
        EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
        PlaySound("ItemSound3.enchant_fail");
        InstructionTxt.SetText(MakeFullSystemMsg(GetSystemMessage(4414), ResultItem.Name, string(FailResultItemNum)));
    }
    ResultItem.ItemNum = (FailResultItemNum);
    Debug("----------------  handleEnchantFail ---------------------------------------------");
    // End:0x388
    if(ResultItem.Id.ClassID != FailResultItemClassID)
    {
        Debug("********* ���� : ���� ���� ��ũ��Ʈ ���� ���� �ٸ��ϴ� Ȯ�� ���ּ���");
    }
    Debug("bUseGetItemNum " @ string(bUseGetItemNum));
    Debug("ResultItemClassID" @ string(ResultItemClassID));
    Debug("ResultItemNum" @ string(ResultItemNum));
    Debug("FailResultItemClassID" @ string(FailResultItemClassID));
    Debug("FailResultItemNum" @ string(FailResultItemNum));
    handleEnchantEnd(ResultItem);
    return;
}

function handleEnchantSuccess(string param)
{
    local ItemInfo ResultItem;
    local bool bUseGetItemNum;
    local int ResultItemClassID, ResultItemNum, FailResultItemClassID, FailResultItemNum;

    ParseInt(param, "ItemClassID", ResultItem.Id.ClassID);
    // End:0x4D
    if(ResultItem.Id.ClassID == 0)
    {
        Me.HideWindow();
        return;
    }
    Debug(" handleEnchantSuccess param: " @ param);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(ResultItem.Id, ResultItem);
    EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
    PlaySound("ItemSound3.enchant_success");
    bUseGetItemNum = Class'NWindow.NewEnchantAPI'.static.GetResultItemForEnchant(getSlotItemWindowByIndex(1), getSlotItemWindowByIndex(2), ResultItemClassID, ResultItemNum, FailResultItemClassID, FailResultItemNum);
    ResultItem.ItemNum = (ResultItemNum);
    InstructionTxt.SetText(MakeFullSystemMsg(GetSystemMessage(4413), ResultItem.Name, string(ResultItemNum)));
    Debug("-------------  handleEnchantSuccess  ------------------------------------------------");
    Debug("bUseGetItemNum " @ string(bUseGetItemNum));
    Debug("ResultItemClassID" @ string(ResultItemClassID));
    Debug("ResultItemNum" @ string(ResultItemNum));
    Debug("FailResultItemClassID" @ string(FailResultItemClassID));
    Debug("FailResultItemNum" @ string(FailResultItemNum));
    handleEnchantEnd(ResultItem);
    return;
}

function toggleShowWindow()
{
    local ItemEnchantWnd script;

    script = ItemEnchantWnd(GetScript("ItemEnchantWnd"));
    // End:0x45
    if(Me.IsShowWindow())
    {
        Me.HideWindow();        
    }
    else
    {
        // End:0x5F
        if(!script.bIsShopping)
        {
            HandleEnchantShow();
        }
    }
    return;
}

function int getSlotItemWindowByIndex(int SlotIndex)
{
    local ItemInfo Info;

    // End:0x23
    if(SlotIndex == 1)
    {
        EnchantJewel1.GetItem(0, Info);        
    }
    else
    {
        EnchantJewel2.GetItem(0, Info);
    }
    return Info.Id.ClassID;
    return;
}

function bool isWorkingEnchant()
{
    // End:0x16
    if(bEnchantbool || bEnchantedbool)
    {
        return true;
    }
    return false;
    return;
}

function OnTimer(int TimerID)
{
    // End:0x32
    if(TimerID == 1002012)
    {
        EnchantBtn.EnableWindow();
        Me.KillTimer(1002012);
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    OnClickButton("ExitBtn");
    return;
}
