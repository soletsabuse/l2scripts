class ItemLockWnd extends UICommonAPI;

const C_ANIMLOOPCOUNT = 1;

enum WindowType
{
    Lock,                           // 0
    UNLOCK,                         // 1
    Error                           // 2
};

enum StateStep
{
    Start,                          // 0
    READY,                          // 1
    POPUP,                          // 2
    Progress,                       // 3
    End                             // 4
};

var WindowHandle Me;
var TextBoxHandle Instruction_Txt;
var TextBoxHandle ItemName_Txt;
var TextBoxHandle ItemLockPaperTitle_txt;
var TextBoxHandle ItemUnLockPaperTitle_txt;
var TextBoxHandle ItemLockPaperinput_txt;
var ItemWindowHandle ItemLock_ItemWindow;
var ProgressCtrlHandle itemLock_Progress;
var ProgressCtrlHandle itemUnLock_Progress;
var ProgressCtrlHandle currentProgress;
var ButtonHandle ItemLockBtn;
var WindowHandle ItemLockAlert_Wnd;
var WindowHandle DisableWnd;
var WindowHandle SubWnd;
var ItemLockSubWnd ItemLockSubWndScript;
var TextureHandle DropHighlight_ItemLock_AniPanel;
var ItemLockWnd.WindowType currentWindowType;
var ItemLockWnd.StateStep CurrentState;
var int currentScrollItemClassID;
var INT64 currentScrollNum;
var InventoryWnd inventoryWndScript;

function Initialize()
{
    CurrentState = 0;
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Me = GetWindowHandle("ItemLockWnd");
    Instruction_Txt = GetTextBoxHandle("ItemLockWnd.Instruction_Txt");
    ItemName_Txt = GetTextBoxHandle("ItemLockWnd.ItemName_Txt");
    ItemLockPaperTitle_txt = GetTextBoxHandle("ItemLockWnd.ItemLockPaperTitle_txt");
    ItemUnLockPaperTitle_txt = GetTextBoxHandle("ItemLockWnd.ItemUnLockPaperTitle_txt");
    ItemLock_ItemWindow = GetItemWindowHandle("ItemLockWnd.ItemLock_ItemWindow");
    itemLock_Progress = GetProgressCtrlHandle("ItemLockWnd.itemLock_Progress");
    itemUnLock_Progress = GetProgressCtrlHandle("ItemLockWnd.itemUnLock_Progress");
    ItemLockBtn = GetButtonHandle("ItemLockWnd.ItemLockBtn");
    DisableWnd = GetWindowHandle("ItemLockWnd.DisableWnd");
    ItemLockAlert_Wnd = GetWindowHandle("ItemLockWnd.ItemLockAlert_Wnd");
    ItemLockPaperinput_txt = GetTextBoxHandle("ItemLockWnd.ItemLockPaperinput_txt");
    SubWnd = GetWindowHandle("ItemLockSubWnd");
    ItemLockSubWndScript = ItemLockSubWnd(GetScript("ItemLockSubWnd"));
    DropHighlight_ItemLock_AniPanel = GetTextureHandle("ItemLockWnd.DropHighlight_ItemLock_AniPanel");
    inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
    // End:0x2CC
    if(getInstanceUIData().getIsClassicServer())
    {
        GetButtonHandle("ItemLockWnd.BtnWindowHelp").HideWindow();
    }
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(11000);
    RegisterEvent(11010);
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    Initialize();
    setWindowByType();
    handleState();
    SubWnd.ShowWindow();
    return;
}

function OnHide()
{
    switch(currentWindowType)
    {
        // End:0x15
        case 0:
            RequestLockedItemCancel();
            // End:0x26
            break;
        // End:0x23
        case 1:
            RequestUnlockedItemCancel();
            // End:0x26
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x6D
        case "ItemLockBtn":
            switch(CurrentState)
            {
                // End:0x49
                case 1:
                    // End:0x3E
                    if(int(currentWindowType) == int(0))
                    {
                        CurrentState = 2;                        
                    }
                    else
                    {
                        CurrentState = 3;
                    }
                    // End:0x6A
                    break;
                // End:0x59
                case 3:
                    CurrentState = 1;
                    // End:0x6A
                    break;
                // End:0x67
                case 4:
                    scrollItemReuse();
                    // End:0x6A
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0xDD
            break;
        // End:0x91
        case "AlertWnd_Confirm_Btn":
            CurrentState = 3;
            // End:0xDD
            break;
        // End:0xB3
        case "AlertWnd_Close_Btn":
            CurrentState = 1;
            // End:0xDD
            break;
        // End:0xDA
        case "BtnWindowHelp":
            ExecuteEvent(1210, "131");
            return;
            // End:0xDD
            break;
        // End:0xFFFF
        default:
            break;
    }
    handleState();
    return;
}

function scrollItemReuse()
{
    local ItemInfo outinfo;
    local ItemID Id;

    Id.ClassID = currentScrollItemClassID;
    inventoryWndScript.getInventoryItemInfo(Id, outinfo, true);
    RequestUseItem(outinfo.Id);
    return;
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    // End:0x27
    if(a_ItemInfo.DragSrcName != "ItemLockSubWnd_Item1")
    {
        return;
    }
    SetItemInfo(a_ItemInfo);
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 11000:
            setShow(param);
            // End:0x3C
            break;
        // End:0x39
        case 11010:
            handleResult(param);
            handleState();
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnProgressTimeUp(string strID)
{
    switch(strID)
    {
        // End:0x3B
        case "itemLock_Progress":
            RequestLockedItem(getCurrentItemServerID());
            ItemLockBtn.DisableWindow();
            // End:0x74
            break;
        // End:0x71
        case "itemUnLock_Progress":
            RequestUnlockedItem(getCurrentItemServerID());
            ItemLockBtn.DisableWindow();
            // End:0x74
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function setScrollNum(int ClassID)
{
    currentScrollNum = inventoryWndScript.getItemCountByClassID(ClassID);
    // End:0x49
    if(__NFUN_412__(currentScrollNum, (0)))
    {
        ItemLockPaperinput_txt.SetTextColor(getInstanceL2Util().DRed);        
    }
    else
    {
        ItemLockPaperinput_txt.SetTextColor(getInstanceL2Util().White);
    }
    ItemLockPaperinput_txt.SetText((currentScrollNum));
    return;
}

function SetItemInfo(ItemInfo a_ItemInfo)
{
    // End:0x24
    if((int(CurrentState) != int(0)) && int(CurrentState) != int(1))
    {
        return;
    }
    ItemLock_ItemWindow.SetItem(0, a_ItemInfo);
    ItemLock_ItemWindow.AddItem(a_ItemInfo);
    ItemName_Txt.SetText(GetItemNameAll(a_ItemInfo));
    DropHighlight_ItemLock_AniPanel.HideWindow();
    CurrentState = 1;
    handleState();
    return;
}

function setShow(string param)
{
    local string LockType;

    ParseString(param, "LockType", LockType);
    switch(LockType)
    {
        // End:0x45
        case "Error":
            currentWindowType = 2;
            Me.HideWindow();
            // End:0xC0
            break;
        // End:0x82
        case "UnLock":
            currentWindowType = 1;
            // End:0x70
            if(Me.IsShowWindow())
            {
                OnShow();
            }
            Me.ShowWindow();
            // End:0xC0
            break;
        // End:0xBD
        case "Lock":
            currentWindowType = 0;
            // End:0xAB
            if(Me.IsShowWindow())
            {
                OnShow();
            }
            Me.ShowWindow();
            // End:0xC0
            break;
        // End:0xFFFF
        default:
            break;
    }
    ParseInt(param, "ScrollItemClassID", currentScrollItemClassID);
    setScrollNum(currentScrollItemClassID);
    return;
}

function handleClearItem()
{
    ItemLock_ItemWindow.Clear();
    ItemName_Txt.SetText("");
    DropHighlight_ItemLock_AniPanel.ShowWindow();
    return;
}

function setWindowByType()
{
    // End:0x7D
    if(int(currentWindowType) == int(0))
    {
        itemUnLock_Progress.HideWindow();
        Me.SetWindowTitle(GetSystemString(3770));
        ItemLockPaperTitle_txt.SetText(GetSystemString(3772));
        ItemLockPaperTitle_txt.SetTextColor(GetColor(255, 153, 0, 255));
        currentProgress = itemLock_Progress;        
    }
    else
    {
        itemLock_Progress.HideWindow();
        Me.SetWindowTitle(GetSystemString(3771));
        ItemLockPaperTitle_txt.SetText(GetSystemString(3773));
        ItemUnLockPaperTitle_txt.ShowWindow();
        ItemLockPaperTitle_txt.SetTextColor(GetColor(136, 255, 255, 255));
        currentProgress = itemUnLock_Progress;
    }
    currentProgress.ShowWindow();
    return;
}

function handleState()
{
    setWindowByState();
    setButtonByState();
    setWindowInstruction();
    return;
}

function setWindowByState()
{
    switch(CurrentState)
    {
        // End:0x37
        case 0:
            hideAlert();
            handleClearItem();
            ItemLockSubWndScript.syncInventory();
            ItemLockSubWndScript.setLock(false);
        // End:0x64
        case 1:
            currentProgress.Reset();
            hideAlert();
            ItemLockSubWndScript.setLock(false);
            // End:0x10E
            break;
        // End:0x72
        case 2:
            showAlert();
            // End:0x10E
            break;
        // End:0xE4
        case 3:
            ItemLockSubWndScript.setLock(true);
            PlaySound("ItemSound3.enchant_process");
            currentProgress.SetProgressTime(1500);
            currentProgress.Reset();
            currentProgress.Start();
            hideAlert();
            // End:0x10E
            break;
        // End:0x10B
        case 4:
            ItemLockSubWndScript.syncInventory();
            ItemLockSubWndScript.setLock(true);
            // End:0x10E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function setButtonByState()
{
    local int buttonString;

    // End:0xA3
    if(int(currentWindowType) == int(0))
    {
        switch(CurrentState)
        {
            // End:0x39
            case 0:
                buttonString = 3774;
                ItemLockBtn.DisableWindow();
                // End:0xA0
                break;
            // End:0x5B
            case 1:
                buttonString = 3774;
                ItemLockBtn.EnableWindow();
                // End:0xA0
                break;
            // End:0x6B
            case 3:
                buttonString = 141;
                // End:0xA0
                break;
            // End:0x9B
            case 4:
                buttonString = 1731;
                // End:0x98
                if(__NFUN_409__(currentScrollNum, (0)))
                {
                    ItemLockBtn.EnableWindow();
                }
                // End:0xA0
                break;
            // End:0xFFFF
            default:
                return;
                break;
        }        
    }
    else
    {
        switch(CurrentState)
        {
            // End:0xCC
            case 0:
                buttonString = 3808;
                ItemLockBtn.DisableWindow();
                // End:0x133
                break;
            // End:0xEE
            case 1:
                buttonString = 3808;
                ItemLockBtn.EnableWindow();
                // End:0x133
                break;
            // End:0xFE
            case 3:
                buttonString = 141;
                // End:0x133
                break;
            // End:0x12E
            case 4:
                buttonString = 1731;
                // End:0x12B
                if(__NFUN_409__(currentScrollNum, (0)))
                {
                    ItemLockBtn.EnableWindow();
                }
                // End:0x133
                break;
            // End:0xFFFF
            default:
                return;
                break;
        }
    }
    ItemLockBtn.SetButtonName(buttonString);
    return;
}

function setWindowInstruction()
{
    local int systemMessage;

    // End:0x58
    if(int(currentWindowType) == int(0))
    {
        switch(CurrentState)
        {
            // End:0x2A
            case 0:
                systemMessage = 5129;
                // End:0x55
                break;
            // End:0x3D
            case 1:
                systemMessage = 5130;
                // End:0x55
                break;
            // End:0x50
            case 4:
                systemMessage = 5121;
                // End:0x55
                break;
            // End:0xFFFF
            default:
                return;
                break;
        }        
    }
    else
    {
        switch(CurrentState)
        {
            // End:0x72
            case 0:
                systemMessage = 5132;
                // End:0x9D
                break;
            // End:0x85
            case 1:
                systemMessage = 5133;
                // End:0x9D
                break;
            // End:0x98
            case 4:
                systemMessage = 5122;
                // End:0x9D
                break;
            // End:0xFFFF
            default:
                return;
                break;
        }
    }
    Instruction_Txt.SetText(GetSystemMessage(systemMessage));
    return;
}

function showAlert()
{
    DisableWnd.ShowWindow();
    ItemLockAlert_Wnd.ShowWindow();
    return;
}

function hideAlert()
{
    DisableWnd.HideWindow();
    ItemLockAlert_Wnd.HideWindow();
    return;
}

function int getCurrentItemServerID()
{
    local ItemInfo Info;

    ItemLock_ItemWindow.GetItem(0, Info);
    // End:0x38
    if(IsValidItemID(Info.Id))
    {
        return Info.Id.ServerID;
    }
    return -1;
    return;
}

function handleResult(string param)
{
    local int Result;
    local ItemInfo Info;

    ParseInt(param, "Result", Result);
    // End:0x35
    if(Result == 0)
    {
        Me.HideWindow();        
    }
    else
    {
        ItemLock_ItemWindow.GetItem(0, Info);
        Info.bSecurityLock = int(currentWindowType) == int(0);
        ItemLock_ItemWindow.SetItem(0, Info);
        ItemLock_ItemWindow.AddItem(Info);
        switch(currentWindowType)
        {
            // End:0xA6
            case 0:
                AddSystemMessage(5121);
                // End:0xBC
                break;
            // End:0xB9
            case 1:
                AddSystemMessage(5122);
                // End:0xBC
                break;
            // End:0xFFFF
            default:
                break;
        }
        setScrollNum(currentScrollItemClassID);
        PlaySound("ItemSound3.enchant_success");
        CurrentState = 4;
    }
    return;
}

function RequestLockedItem(int TargetItemID)
{
    Class'NWindow.EnchantAPI'.static.RequestLockedItem(TargetItemID);
    return;
}

function RequestUnlockedItem(int TargetItemID)
{
    Class'NWindow.EnchantAPI'.static.RequestUnlockedItem(TargetItemID);
    return;
}

function RequestUnlockedItemCancel()
{
    Class'NWindow.EnchantAPI'.static.RequestUnlockedItemCancel();
    return;
}

function RequestLockedItemCancel()
{
    Class'NWindow.EnchantAPI'.static.RequestLockedItemCancel();
    return;
}

function toggleShowWindow()
{
    // End:0x24
    if(Me.IsShowWindow())
    {
        Me.HideWindow();        
    }
    else
    {
        Me.ShowWindow();
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("ItemLockWnd").HideWindow();
    return;
}
