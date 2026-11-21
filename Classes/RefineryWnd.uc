class RefineryWnd extends RefineryOptionAPI;

const DIALOGID_GemstoneCount = 0;
const C_ANIMLOOPCOUNT = 1;
const C_ANIMLOOPCOUNT1 = 1;
const C_ANIMLOOPCOUNT2 = 1;
const C_ANIMLOOPCOUNT3 = 1;

struct _RefineryData
{
    var ItemInfo targetItem;
    var ItemInfo StoneItem;
    var ItemInfo GemstoneItem;
    var INT64 GemstoneCount;
};

struct _ResultData
{
    var int op1;
    var int op2;
};

var _RefineryData RefineryData;
var _ResultData ResultData;
var bool bIsResultReset;
var bool isResetAvailable;
var bool isFirstAccess;
var bool IsResult;
var bool bRetryRequested;
var bool procedure1stat;
var bool procedure2stat;
var bool procedure3stat;
var bool procedure4stat;
var ItemInfo RefineItemInfo;
var ItemInfo RefinerItemInfo;
var ItemInfo GemstoneItemInfo;
var ItemInfo RefinedITemInfo;
var WindowHandle m_RefineryWnd_Main;
var WindowHandle m_RefineResultBackPattern;
var WindowHandle m_Highlight1;
var WindowHandle m_Highlight2;
var WindowHandle m_Highlight3;
var WindowHandle m_SeletedItemHighlight1;
var WindowHandle m_SeletedItemHighlight2;
var WindowHandle m_SeletedItemHighlight3;
var WindowHandle m_DragBox1;
var WindowHandle m_DragBox2;
var WindowHandle m_DragBox3;
var WindowHandle m_DragBoxResult;
var WindowHandle m_RefineAnimation;
var WindowHandle m_ResultAnimation1;
var WindowHandle m_ResultAnimation2;
var WindowHandle m_ResultAnimation3;
var AnimTextureHandle m_RefineAnim;
var AnimTextureHandle m_ResultAnim1;
var AnimTextureHandle m_ResultAnim2;
var AnimTextureHandle m_ResultAnim3;
var ButtonHandle m_OkBtn;
var ButtonHandle m_RefineryBtn;
var ItemWindowHandle m_DragboxItem1;
var ItemWindowHandle m_DragBoxItem2;
var ItemWindowHandle m_DragBoxItem3;
var ItemWindowHandle m_ResultBoxItem;
var TextBoxHandle m_InstructionText;
var TextBoxHandle m_hGemstoneNameTextBox;
var TextBoxHandle m_hGemstoneCountTextBox;
var ItemID m_TargetItemID;
var ItemID m_RefineItemID;
var ItemID m_GemStoneItemID;
var INT64 m_NecessaryGemstoneCount;
var INT64 m_GemstoneCount;
var string m_GemstoneName;
var InventoryWnd inventoryWndScript;
var WindowHandle InventoryWnd;
var ProgressCtrlHandle m_hRefineryWndRefineryProgress;

function OnRegisterEvent()
{
    RegisterEvent(40);
    RegisterEvent(2760);
    RegisterEvent(2770);
    RegisterEvent(2780);
    RegisterEvent(2790);
    RegisterEvent(2800);
    RegisterEvent(2830);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function InitHandle()
{
    m_RefineryWnd_Main = GetHandle("RefineryWnd");
    m_RefineResultBackPattern = GetHandle("RefineryWnd.BackPattern");
    m_Highlight1 = GetHandle("RefineryWnd.ItemDragBox1Wnd.DropHighlight");
    m_Highlight2 = GetHandle("RefineryWnd.ItemDragBox2Wnd.DropHighlight");
    m_Highlight3 = GetHandle("RefineryWnd.ItemDragBox3Wnd.DropHighlight");
    m_SeletedItemHighlight1 = GetHandle("RefineryWnd.ItemDragBox1Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight2 = GetHandle("RefineryWnd.ItemDragBox2Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight3 = GetHandle("RefineryWnd.ItemDragBox3Wnd.SelectedItemHighlight");
    m_DragBox1 = GetHandle("RefineryWnd.ItemDragBox1Wnd");
    m_DragBox2 = GetHandle("RefineryWnd.ItemDragBox2Wnd");
    m_DragBox3 = GetHandle("RefineryWnd.ItemDragBox3Wnd");
    m_DragBoxResult = GetHandle("RefineryWnd.ItemDragBoxResultWnd");
    m_RefineAnimation = GetHandle("RefineryWnd.RefineLoadingAnimation");
    m_ResultAnimation1 = GetHandle("RefineryWnd.RefineResultAnimation01");
    m_ResultAnimation2 = GetHandle("RefineryWnd.RefineResultAnimation02");
    m_ResultAnimation3 = GetHandle("RefineryWnd.RefineResultAnimation03");
    m_RefineAnim = AnimTextureHandle(GetHandle("RefineryWnd.RefineLoadingAnimation.RefineLoadingAnim"));
    m_ResultAnim1 = AnimTextureHandle(GetHandle("RefineryWnd.RefineResultAnimation01.RefineResult1"));
    m_ResultAnim2 = AnimTextureHandle(GetHandle("RefineryWnd.RefineResultAnimation02.RefineResult2"));
    m_ResultAnim3 = AnimTextureHandle(GetHandle("RefineryWnd.RefineResultAnimation03.RefineResult3"));
    m_DragboxItem1 = ItemWindowHandle(GetHandle("RefineryWnd.ItemDragBox1Wnd.ItemDragBox1"));
    m_DragBoxItem2 = ItemWindowHandle(GetHandle("RefineryWnd.ItemDragBox2Wnd.ItemDragBox2"));
    m_DragBoxItem3 = ItemWindowHandle(GetHandle("RefineryWnd.ItemDragBox3Wnd.ItemDragBox3"));
    m_ResultBoxItem = ItemWindowHandle(GetHandle("RefineryWnd.ItemDragBoxResultWnd.ItemRefined"));
    m_RefineryBtn = ButtonHandle(GetHandle("RefineryWnd.btnRefine"));
    m_OkBtn = ButtonHandle(GetHandle("RefineryWnd.btnClose"));
    m_InstructionText = TextBoxHandle(GetHandle("RefineryWnd.txtInstruction"));
    m_hGemstoneNameTextBox = TextBoxHandle(GetHandle("txtGemstoneName"));
    m_hGemstoneCountTextBox = TextBoxHandle(GetHandle("txtGemstoneCount"));
    InventoryWnd = GetHandle("InventoryWnd");
    return;
}

function InitHandleCOD()
{
    m_RefineryWnd_Main = GetWindowHandle("RefineryWnd");
    m_RefineResultBackPattern = GetWindowHandle("RefineryWnd.BackPattern");
    m_Highlight1 = GetWindowHandle("RefineryWnd.ItemDragBox1Wnd.DropHighlight");
    m_Highlight2 = GetWindowHandle("RefineryWnd.ItemDragBox2Wnd.DropHighlight");
    m_Highlight3 = GetWindowHandle("RefineryWnd.ItemDragBox3Wnd.DropHighlight");
    m_SeletedItemHighlight1 = GetWindowHandle("RefineryWnd.ItemDragBox1Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight2 = GetWindowHandle("RefineryWnd.ItemDragBox2Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight3 = GetWindowHandle("RefineryWnd.ItemDragBox3Wnd.SelectedItemHighlight");
    m_DragBox1 = GetWindowHandle("RefineryWnd.ItemDragBox1Wnd");
    m_DragBox2 = GetWindowHandle("RefineryWnd.ItemDragBox2Wnd");
    m_DragBox3 = GetWindowHandle("RefineryWnd.ItemDragBox3Wnd");
    m_DragBoxResult = GetWindowHandle("RefineryWnd.ItemDragBoxResultWnd");
    m_RefineAnimation = GetWindowHandle("RefineryWnd.RefineLoadingAnimation");
    m_ResultAnimation1 = GetWindowHandle("RefineryWnd.RefineResultAnimation01");
    m_ResultAnimation2 = GetWindowHandle("RefineryWnd.RefineResultAnimation02");
    m_ResultAnimation3 = GetWindowHandle("RefineryWnd.RefineResultAnimation03");
    m_RefineAnim = GetAnimTextureHandle("RefineryWnd.RefineLoadingAnimation.RefineLoadingAnim");
    m_ResultAnim1 = GetAnimTextureHandle("RefineryWnd.RefineResultAnimation01.RefineResult1");
    m_ResultAnim2 = GetAnimTextureHandle("RefineryWnd.RefineResultAnimation02.RefineResult2");
    m_ResultAnim3 = GetAnimTextureHandle("RefineryWnd.RefineResultAnimation03.RefineResult3");
    m_DragboxItem1 = GetItemWindowHandle("RefineryWnd.ItemDragBox1Wnd.ItemDragBox1");
    m_DragBoxItem2 = GetItemWindowHandle("RefineryWnd.ItemDragBox2Wnd.ItemDragBox2");
    m_DragBoxItem3 = GetItemWindowHandle("RefineryWnd.ItemDragBox3Wnd.ItemDragBox3");
    m_ResultBoxItem = GetItemWindowHandle("RefineryWnd.ItemDragBoxResultWnd.ItemRefined");
    m_RefineryBtn = GetButtonHandle("RefineryWnd.btnRefine");
    m_OkBtn = GetButtonHandle("RefineryWnd.btnClose");
    m_InstructionText = GetTextBoxHandle("RefineryWnd.txtInstruction");
    m_hGemstoneNameTextBox = GetTextBoxHandle("txtGemstoneName");
    m_hGemstoneCountTextBox = GetTextBoxHandle("txtGemstoneCount");
    InventoryWnd = GetWindowHandle("InventoryWnd");
    m_hRefineryWndRefineryProgress = GetProgressCtrlHandle("RefineryWnd.RefineryProgress");
    return;
}

function OnShow()
{
    ResetReady();
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd,UnrefineryWnd");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PetWnd");
    return;
}

function ResetBools()
{
    procedure1stat = false;
    procedure2stat = false;
    procedure3stat = false;
    procedure4stat = false;
    m_RefineAnim.Stop();
    m_ResultAnim1.Stop();
    m_ResultAnim2.Stop();
    m_ResultAnim3.Stop();
    m_hRefineryWndRefineryProgress.Reset();
    return;
}

function PushItemReset()
{
    // End:0x4B
    if(isResetAvailable)
    {
        bIsResultReset = true;
        m_DragboxItem1.SetItem(0, RefineryData.targetItem);
        OnDropItem("ItemDragBox1", RefineryData.targetItem, 0, 0);
    }
    return;
}

function PushStoneItem()
{
    // End:0x4E
    if(isResetAvailable && bIsResultReset)
    {
        m_DragBoxItem2.SetItem(0, RefineryData.StoneItem);
        OnDropItem("ItemDragBox2", RefineryData.StoneItem, 0, 0);
    }
    return;
}

function PushGemstoneItem()
{
    // End:0x4E
    if(isResetAvailable && bIsResultReset)
    {
        m_DragBoxItem3.SetItem(0, RefineryData.GemstoneItem);
        OnDropItem("ItemDragBox3", RefineryData.GemstoneItem, 0, 0);
    }
    bIsResultReset = false;
    isResetAvailable = false;
    return;
}

function OnHide()
{
    // End:0x1B
    if(m_RefineryBtn.GetButtonValue() != 1)
    {
        ResetRefineryData();
    }
    return;
}

function ResetRefineryData()
{
    local ItemID tmpItemID;

    RefineryData.targetItem.Id = tmpItemID;
    RefineryData.StoneItem.Id = tmpItemID;
    RefineryData.GemstoneItem.Id = tmpItemID;
    ResultData.op1 = -1;
    ResultData.op2 = -1;
    isFirstAccess = false;
    IsResult = false;
    bIsResultReset = false;
    isResetAvailable = false;
    bRetryRequested = false;
    m_RefineryBtn.SetButtonValue(0);
    return;
}

function ResetReady()
{
    local array<ItemInfo> Targets, Stones, GemStones;

    m_RefineryBtn.ClearTooltip();
    // End:0x17B
    if(IsResult && bRetryRequested)
    {
        Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(RefineryData.targetItem.Id.ClassID, Targets);
        Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(RefineryData.StoneItem.Id.ClassID, Stones);
        Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(RefineryData.GemstoneItem.Id.ClassID, GemStones);
        isResetAvailable = __NFUN_409__(Stones[0].ItemNum, (0)) && __NFUN_411__(GemStones[0].ItemNum, RefineryData.GemstoneCount);
        // End:0x10E
        if(__NFUN_410__(Stones[0].ItemNum, (0)))
        {
            getInstanceL2Util().showGfxScreenMessage("No more stones.");
            ResetRefineryData();
        }
        // End:0x154
        if(__NFUN_408__(GemStones[0].ItemNum, RefineryData.GemstoneCount))
        {
            getInstanceL2Util().showGfxScreenMessage("No more gemstones.");
            ResetRefineryData();
        }
        // End:0x17B
        if(isResetAvailable)
        {
            Class'NWindow.RefineryAPI'.static.RequestRefineCancel(RefineryData.targetItem.Id);
        }
    }
    bRetryRequested = false;
    m_RefineryBtn.SetNameText(GetSystemString(1477));
    IsResult = false;
    procedure1stat = false;
    procedure2stat = false;
    procedure3stat = false;
    procedure4stat = false;
    m_GemstoneName = "";
    m_RefineryWnd_Main.ShowWindow();
    m_RefineResultBackPattern.HideWindow();
    m_DragBox1.ShowWindow();
    m_DragBox2.ShowWindow();
    m_DragBox3.ShowWindow();
    m_DragBoxResult.HideWindow();
    m_RefineAnimation.HideWindow();
    m_ResultAnimation1.HideWindow();
    m_ResultAnimation2.HideWindow();
    m_ResultAnimation3.HideWindow();
    m_RefineAnim.Stop();
    m_ResultAnim1.Stop();
    m_ResultAnim2.Stop();
    m_ResultAnim3.Stop();
    m_hGemstoneNameTextBox.SetText("");
    m_hGemstoneCountTextBox.SetText("");
    m_hGemstoneCountTextBox.SetTooltipString("");
    // End:0x3AB
    if(!isFirstAccess)
    {
        m_InstructionText.SetText(GetSystemMessage(1957));
        m_Highlight1.ShowWindow();
        m_Highlight2.HideWindow();
        m_Highlight3.HideWindow();
        m_SeletedItemHighlight1.HideWindow();
        m_SeletedItemHighlight2.HideWindow();
        m_SeletedItemHighlight3.HideWindow();
        m_DragboxItem1.Clear();
        m_DragBoxItem2.Clear();
        m_DragBoxItem3.Clear();
        m_DragboxItem1.EnableWindow();
        m_DragBoxItem2.DisableWindow();
        m_DragBoxItem3.DisableWindow();
    }
    m_RefineryBtn.DisableWindow();
    m_hRefineryWndRefineryProgress.Reset();
    MoveItemBoxes(true);
    PlaySound("ItemSound2.smelting.Smelting_dragin");
    m_OkBtn.EnableWindow();
    return;
}

function ResetReadyForRestart()
{
    m_RefineryBtn.SetNameText(GetSystemString(1477));
    bRetryRequested = false;
    IsResult = false;
    procedure1stat = false;
    procedure2stat = false;
    procedure3stat = false;
    procedure4stat = false;
    m_GemstoneName = "";
    m_RefineResultBackPattern.HideWindow();
    m_DragBox1.ShowWindow();
    m_DragBox2.ShowWindow();
    m_DragBox3.ShowWindow();
    m_DragBoxResult.HideWindow();
    m_RefineAnimation.HideWindow();
    m_ResultAnimation1.HideWindow();
    m_ResultAnimation2.HideWindow();
    m_ResultAnimation3.HideWindow();
    m_RefineAnim.Stop();
    m_ResultAnim1.Stop();
    m_ResultAnim2.Stop();
    m_ResultAnim3.Stop();
    // End:0x1EE
    if(!isFirstAccess)
    {
        m_InstructionText.SetText(GetSystemMessage(1957));
        m_Highlight1.ShowWindow();
        m_Highlight2.HideWindow();
        m_Highlight3.HideWindow();
        m_SeletedItemHighlight1.HideWindow();
        m_SeletedItemHighlight2.HideWindow();
        m_SeletedItemHighlight3.HideWindow();
        m_DragboxItem1.Clear();
        m_DragBoxItem2.Clear();
        m_DragBoxItem3.Clear();
        m_DragboxItem1.EnableWindow();
        m_DragBoxItem2.DisableWindow();
        m_DragBoxItem3.DisableWindow();
    }
    m_hGemstoneNameTextBox.SetText("");
    m_hGemstoneCountTextBox.SetText("");
    m_hGemstoneCountTextBox.SetTooltipString("");
    m_RefineryBtn.DisableWindow();
    m_hRefineryWndRefineryProgress.Reset();
    MoveItemBoxes(true);
    m_OkBtn.EnableWindow();
    return;
}

function OnRefineryConfirmTargetItemResult()
{
    m_RefineResultBackPattern.HideWindow();
    m_DragBox1.ShowWindow();
    m_DragBox2.ShowWindow();
    m_DragBox3.ShowWindow();
    m_DragBoxResult.HideWindow();
    m_RefineAnimation.HideWindow();
    m_ResultAnimation1.HideWindow();
    m_ResultAnimation2.HideWindow();
    m_ResultAnimation3.HideWindow();
    procedure1stat = true;
    procedure2stat = false;
    procedure3stat = false;
    procedure4stat = false;
    m_hGemstoneNameTextBox.SetText("");
    m_hGemstoneCountTextBox.SetText("");
    m_hGemstoneCountTextBox.SetTooltipString("");
    // End:0x186
    if(!isFirstAccess)
    {
        m_InstructionText.SetText(GetSystemMessage(1958));
        m_DragboxItem1.EnableWindow();
        m_DragBoxItem2.EnableWindow();
        m_DragBoxItem3.DisableWindow();
        m_Highlight1.HideWindow();
        m_Highlight2.ShowWindow();
        m_Highlight3.HideWindow();
        m_SeletedItemHighlight1.ShowWindow();
        m_SeletedItemHighlight2.HideWindow();
        m_SeletedItemHighlight3.HideWindow();
    }
    m_RefineryBtn.DisableWindow();
    return;
}

function OnRefineryConfirmRefinerItemResult()
{
    local string GemstoneName, Instruction;

    m_RefineResultBackPattern.HideWindow();
    m_DragBox1.ShowWindow();
    m_DragBox2.ShowWindow();
    m_DragBox3.ShowWindow();
    m_DragBoxResult.HideWindow();
    m_RefineAnimation.HideWindow();
    m_ResultAnimation1.HideWindow();
    m_ResultAnimation2.HideWindow();
    m_ResultAnimation3.HideWindow();
    procedure1stat = true;
    procedure2stat = true;
    procedure3stat = false;
    procedure4stat = false;
    GemstoneName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(m_GemStoneItemID);
    m_GemstoneName = GemstoneName;
    Instruction = MakeFullSystemMsg(GetSystemMessage(1959), GemstoneName, (m_NecessaryGemstoneCount));
    // End:0x1E1
    if(!isFirstAccess)
    {
        m_hGemstoneNameTextBox.SetText(GemstoneName);
        m_hGemstoneCountTextBox.SetText(MakeCostString((m_NecessaryGemstoneCount)));
        m_hGemstoneCountTextBox.SetTooltipString(ConvertNumToTextNoAdena((m_NecessaryGemstoneCount)));
        m_InstructionText.SetText(Instruction);
        m_Highlight1.HideWindow();
        m_Highlight2.HideWindow();
        m_Highlight3.ShowWindow();
        m_SeletedItemHighlight1.ShowWindow();
        m_SeletedItemHighlight2.ShowWindow();
        m_SeletedItemHighlight3.HideWindow();
        m_DragboxItem1.EnableWindow();
        m_DragBoxItem2.EnableWindow();
        m_DragBoxItem3.EnableWindow();
    }
    m_RefineryBtn.DisableWindow();
    return;
}

function OnRefineryConfirmGemStoneResult()
{
    m_RefineResultBackPattern.HideWindow();
    m_DragBox1.ShowWindow();
    m_DragBox2.ShowWindow();
    m_DragBox3.ShowWindow();
    m_DragBoxResult.HideWindow();
    m_RefineAnimation.HideWindow();
    m_ResultAnimation1.HideWindow();
    m_ResultAnimation2.HideWindow();
    m_ResultAnimation3.HideWindow();
    // End:0xEC
    if(!isFirstAccess)
    {
        m_Highlight1.HideWindow();
        m_Highlight2.HideWindow();
        m_Highlight3.HideWindow();
        m_SeletedItemHighlight1.ShowWindow();
        m_SeletedItemHighlight2.ShowWindow();
        m_SeletedItemHighlight3.ShowWindow();
    }
    procedure1stat = true;
    procedure2stat = true;
    procedure3stat = true;
    procedure4stat = false;
    m_InstructionText.SetText(GetSystemMessage(1984));
    m_hGemstoneNameTextBox.SetText("");
    m_hGemstoneCountTextBox.SetText("");
    m_hGemstoneCountTextBox.SetTooltipString("");
    m_RefineryBtn.EnableWindow();
    m_hGemstoneCountTextBox.SetTooltipString("");
    return;
}

function OnRefineryRefineResult()
{
    m_RefineResultBackPattern.HideWindow();
    m_DragBox1.HideWindow();
    m_DragBox2.HideWindow();
    m_DragBox3.HideWindow();
    // End:0x74
    if(!isFirstAccess)
    {
        m_Highlight1.HideWindow();
        m_Highlight2.HideWindow();
        m_Highlight3.HideWindow();
    }
    MoveItemBoxes(true);
    m_DragBoxResult.ShowWindow();
    m_RefineAnimation.HideWindow();
    m_ResultAnimation1.HideWindow();
    m_ResultAnimation2.HideWindow();
    m_ResultAnimation3.HideWindow();
    procedure1stat = true;
    procedure2stat = true;
    procedure3stat = true;
    procedure4stat = true;
    m_InstructionText.SetText(GetSystemMessage(1962));
    m_hGemstoneNameTextBox.SetText("");
    m_hGemstoneCountTextBox.SetText("");
    m_hGemstoneCountTextBox.SetTooltipString("");
    return;
}

function HandleDialogOK()
{
    local int Id;

    // End:0x6B
    if(DialogIsMine())
    {
        Id = DialogGetID();
        switch(Id)
        {
            // End:0x54
            case 0:
                m_GemstoneCount = (DialogGetString());
                Class'NWindow.RefineryAPI'.static.ConfirmGemStone(m_TargetItemID, m_RefineItemID, m_GemStoneItemID, m_GemstoneCount);
                // End:0x6B
                break;
            // End:0x65
            case 10001:
                handleTryRefine();
                // End:0x6B
                break;
            // End:0xFFFF
            default:
                // End:0x6B
                break;
                break;
        }
    }
    return;
}

function HandleDialogCancel()
{
    local int Id;

    // End:0x71
    if(DialogIsMine())
    {
        Id = DialogGetID();
        switch(Id)
        {
            // End:0x54
            case 0:
                m_GemstoneCount = (DialogGetString());
                Class'NWindow.RefineryAPI'.static.ConfirmGemStone(m_TargetItemID, m_RefineItemID, m_GemStoneItemID, m_GemstoneCount);
                // End:0x71
                break;
            // End:0x6B
            case 10001:
                ResetRefineryData();
                ResetReady();
                // End:0x71
                break;
            // End:0xFFFF
            default:
                // End:0x71
                break;
                break;
        }
    }
    return;
}

function handleTryRefine()
{
    bRetryRequested = true;
    m_RefineryBtn.SetButtonValue(1);
    OnClickCancelButton();
    ShowRefineryInterface();
    return;
}

function OnClickButton(string strID)
{
    local string dialogText;

    switch(strID)
    {
        // End:0xD8
        case "btnRefine":
            // End:0x94
            if(IsResult)
            {
                // End:0x8B
                if(isWarningCondition(ResultData.op1, ResultData.op2))
                {
                    dialogText = GetRefineryText(ResultData.op1, ResultData.op2);
                    DialogSetID(10001);
                    DialogShow(0, 0, MakeFullSystemMsg(GetSystemString(7926), dialogText), string(self));
                    return;
                }
                handleTryRefine();                
            }
            else
            {
                PlaySound("Itemsound2.smelting.smelting_loding");
                m_RefineryBtn.SetButtonValue(0);
                OnClickRefineButton();
            }
            // End:0xFA
            break;
        // End:0xF4
        case "btnClose":
            ResetRefineryData();
            OnClickCancelButton();
            // End:0xFA
            break;
        // End:0xFFFF
        default:
            // End:0xFA
            break;
            break;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x24
        case 2760:
            // End:0x21
            if(procedure1stat == false)
            {
                ShowRefineryInterface();
            }
            // End:0x153
            break;
        // End:0x35
        case 2830:
            PushItemReset();
            // End:0x153
            break;
        // End:0x7C
        case 2770:
            PlaySound("ItemSound2.smelting.Smelting_dragin");
            OnTargetItemValidationResult(a_Param);
            PushStoneItem();
            // End:0x153
            break;
        // End:0xC3
        case 2780:
            PlaySound("ItemSound2.smelting.Smelting_dragin");
            OnRefinerItemValidationResult(a_Param);
            PushGemstoneItem();
            // End:0x153
            break;
        // End:0x104
        case 2790:
            PlaySound("ItemSound2.smelting.Smelting_dragin");
            OnGemstoneValidationResult(a_Param);
            // End:0x153
            break;
        // End:0x11A
        case 2800:
            OnRefineDoneResult(a_Param);
            // End:0x153
            break;
        // End:0x12B
        case 1710:
            HandleDialogOK();
            // End:0x153
            break;
        // End:0x13C
        case 1720:
            HandleDialogCancel();
            // End:0x153
            break;
        // End:0x14A
        case 40:
            ResetReadyForRestart();
            // End:0x153
            break;
        // End:0xFFFF
        default:
            // End:0x153
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x153
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x153
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x153
}

function ShowRefineryInterface()
{
    ResetReady();
    return;
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    // End:0x13
    if(a_ItemInfo.ItemSubType == 4)
    {
        return;
    }
    switch(a_WindowID)
    {
        // End:0x61
        case "ItemDragBox1":
            // End:0x5E
            if(((procedure1stat == false) && procedure2stat == false) && procedure3stat == false)
            {
                ValidateFirstItem(a_ItemInfo);
            }
            // End:0xF5
            break;
        // End:0xA8
        case "ItemDragBox2":
            // End:0xA5
            if(((procedure1stat == true) && procedure2stat == false) && procedure3stat == false)
            {
                ValidateSecondItem(a_ItemInfo);
            }
            // End:0xF5
            break;
        // End:0xEF
        case "ItemDragBox3":
            // End:0xEC
            if(((procedure1stat == true) && procedure2stat == true) && procedure3stat == false)
            {
                ValidateGemstoneItem(a_ItemInfo);
            }
            // End:0xF5
            break;
        // End:0xFFFF
        default:
            // End:0xF5
            break;
            break;
    }
    return;
}

function ValidateFirstItem(ItemInfo a_ItemInfo)
{
    RefineItemInfo = a_ItemInfo;
    m_TargetItemID = a_ItemInfo.Id;
    Class'NWindow.RefineryAPI'.static.ConfirmTargetItem(m_TargetItemID);
    return;
}

function OnTargetItemValidationResult(string a_Param)
{
    local int ItemValidationResult1;
    local ItemID scID;

    ParseItemID(a_Param, scID);
    ParseInt(a_Param, "Result", ItemValidationResult1);
    switch(ItemValidationResult1)
    {
        // End:0x92
        case 1:
            // End:0x8F
            if(IsSameServerID(scID, RefineItemInfo.Id))
            {
                // End:0x79
                if(!m_DragboxItem1.SetItem(0, RefineItemInfo))
                {
                    m_DragboxItem1.AddItem(RefineItemInfo);
                }
                RefineryData.targetItem = RefineItemInfo;
                OnRefineryConfirmTargetItemResult();
            }
            // End:0x9F
            break;
        // End:0x99
        case 0:
            // End:0x9F
            break;
        // End:0xFFFF
        default:
            // End:0x9F
            break;
            break;
    }
    return;
}

function ValidateSecondItem(ItemInfo a_ItemInfo)
{
    RefinerItemInfo = a_ItemInfo;
    m_RefineItemID = a_ItemInfo.Id;
    Class'NWindow.RefineryAPI'.static.ConfirmRefinerItem(m_TargetItemID, m_RefineItemID);
    return;
}

function OnRefinerItemValidationResult(string a_Param)
{
    local ItemID scID, GemstoneID;
    local int ItemValidationResult2;
    local INT64 RequiredGemstoneAmount;

    ParseItemID(a_Param, scID);
    ParseItemIDWithIndex(a_Param, GemstoneID, 1);
    ParseInt(a_Param, "Result", ItemValidationResult2);
    ParseINT64(a_Param, "GemStoneCount", RequiredGemstoneAmount);
    m_GemStoneItemID = GemstoneID;
    m_NecessaryGemstoneCount = RequiredGemstoneAmount;
    switch(ItemValidationResult2)
    {
        // End:0xE6
        case 1:
            // End:0xE3
            if(IsSameServerID(scID, RefinerItemInfo.Id))
            {
                RefinerItemInfo.ItemNum = (1);
                // End:0xCD
                if(!m_DragBoxItem2.SetItem(0, RefinerItemInfo))
                {
                    m_DragBoxItem2.AddItem(RefinerItemInfo);
                }
                RefineryData.StoneItem = RefinerItemInfo;
                OnRefineryConfirmRefinerItemResult();
            }
            // End:0xF3
            break;
        // End:0xED
        case 0:
            // End:0xF3
            break;
        // End:0xFFFF
        default:
            // End:0xF3
            break;
            break;
    }
    // End:0x107
    if(__NFUN_410__(m_NecessaryGemstoneCount, (0)))
    {
        OnRefineryConfirmGemStoneResult();
    }
    return;
}

function ValidateGemstoneItem(ItemInfo a_ItemInfo)
{
    GemstoneItemInfo = a_ItemInfo;
    m_GemStoneItemID = a_ItemInfo.Id;
    Debug((a_ItemInfo.AllItemCount));
    // End:0x99
    if(__NFUN_409__(a_ItemInfo.ItemNum, (0)))
    {
        // End:0x63
        if(__NFUN_410__(m_NecessaryGemstoneCount, a_ItemInfo.ItemNum))
        {
            m_GemstoneCount = m_NecessaryGemstoneCount;            
        }
        else
        {
            m_GemstoneCount = a_ItemInfo.ItemNum;
        }
        Class'NWindow.RefineryAPI'.static.ConfirmGemStone(m_TargetItemID, m_RefineItemID, m_GemStoneItemID, m_GemstoneCount);        
    }
    else
    {
        DialogSetID(0);
        DialogSetParamInt64(a_ItemInfo.ItemNum);
        DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), a_ItemInfo.Name, ""), string(self));
    }
    return;
}

function OnGemstoneValidationResult(string a_Param)
{
    local ItemID scID;
    local int ItemValidationResult3;
    local INT64 RequiredMoreGemstoneAmount, GemstoneAmountChecked;

    ParseItemID(a_Param, scID);
    ParseInt(a_Param, "Result", ItemValidationResult3);
    ParseINT64(a_Param, "NecessaryGemStoneCount", RequiredMoreGemstoneAmount);
    ParseINT64(a_Param, "GemStoneCount", GemstoneAmountChecked);
    m_GemStoneItemID = scID;
    m_NecessaryGemstoneCount = __NFUN_404__(GemstoneAmountChecked, RequiredMoreGemstoneAmount);
    RefineryData.GemstoneCount = m_NecessaryGemstoneCount;
    switch(ItemValidationResult3)
    {
        // End:0x117
        case 1:
            // End:0x114
            if(IsSameServerID(scID, GemstoneItemInfo.Id))
            {
                // End:0xFE
                if(!m_DragBoxItem3.SetItem(0, GemstoneItemInfo))
                {
                    GemstoneItemInfo.ItemNum = GemstoneAmountChecked;
                    m_DragBoxItem3.AddItem(GemstoneItemInfo);
                }
                RefineryData.GemstoneItem = GemstoneItemInfo;
                OnRefineryConfirmGemStoneResult();
            }
            // End:0x124
            break;
        // End:0x11E
        case 0:
            // End:0x124
            break;
        // End:0xFFFF
        default:
            // End:0x124
            break;
            break;
    }
    return;
}

function checkClassicSupportItem()
{
    local ItemWindowHandle InventoryItem;
    local int Index;

    ValidateFirstItem(RefineItemInfo);
    InventoryItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
    Index = InventoryItem.FindItem(RefinerItemInfo.Id);
    // End:0xD4
    if(InventoryItem.GetItem(Index, RefinerItemInfo))
    {
        ValidateSecondItem(RefinerItemInfo);
        Index = InventoryItem.FindItem(GemstoneItemInfo.Id);
        // End:0xD4
        if(InventoryItem.GetItem(Index, GemstoneItemInfo))
        {
            // End:0xD4
            if(__NFUN_411__(GemstoneItemInfo.ItemNum, m_NecessaryGemstoneCount))
            {
                ValidateGemstoneItem(GemstoneItemInfo);
            }
        }
    }
    return;
}

function OnExitState(name a_NextStateName)
{
    ResetRefineryData();
    return;
}

function OnClickCancelButton()
{
    m_RefineryWnd_Main.HideWindow();
    PlaySound("Itemsound2.smelting.smelting_dragout");
    m_hRefineryWndRefineryProgress.Stop();
    m_RefineAnim.Stop();
    m_RefineAnim.SetLoopCount(1);
    procedure1stat = false;
    procedure2stat = false;
    procedure3stat = false;
    procedure4stat = false;
    return;
}

function OnClickRefineButton()
{
    isFirstAccess = true;
    m_RefineResultBackPattern.HideWindow();
    m_DragBoxResult.HideWindow();
    m_ResultAnimation1.HideWindow();
    m_ResultAnimation2.HideWindow();
    m_ResultAnimation3.HideWindow();
    m_RefineryBtn.DisableWindow();
    m_OkBtn.DisableWindow();
    PlayRefineAnimation();
    // End:0xAF
    if(!isFirstAccess)
    {
        m_Highlight1.HideWindow();
        m_Highlight2.HideWindow();
        m_Highlight3.HideWindow();
    }
    MoveItemBoxes(false);
    return;
}

function PlayRefineAnimation()
{
    m_InstructionText.SetText("");
    m_RefineAnim.Stop();
    m_RefineAnim.SetLoopCount(1);
    m_RefineAnim.Play();
    m_hRefineryWndRefineryProgress.Start();
    return;
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
    switch(a_WindowHandle)
    {
        // End:0x0F
        case m_ResultAnim1:
        // End:0x17
        case m_ResultAnim2:
        // End:0x28
        case m_ResultAnim3:
            OnResultAnimEnd();
            // End:0x2E
            break;
        // End:0xFFFF
        default:
            // End:0x2E
            break;
            break;
    }
    return;
}

function OnProgressTimeUp(string strID)
{
    Debug("strID" @ strID);
    // End:0x72
    if(strID == "RefineryProgress")
    {
        m_RefineAnimation.HideWindow();
        m_DragBox1.HideWindow();
        m_DragBox2.HideWindow();
        m_DragBox3.HideWindow();
        OnRefineRequest();
    }
    return;
}

function OnResultAnimEnd()
{
    m_ResultAnimation1.HideWindow();
    m_ResultAnimation2.HideWindow();
    m_ResultAnimation3.HideWindow();
    return;
}

function OnRefineRequest()
{
    // End:0x6F
    if(((procedure1stat && procedure2stat) && procedure3stat) && !procedure4stat)
    {
        Class'NWindow.RefineryAPI'.static.RequestRefine(m_TargetItemID, m_RefineItemID, m_GemStoneItemID, m_NecessaryGemstoneCount);
        procedure1stat = true;
        procedure2stat = true;
        procedure3stat = true;
        procedure4stat = true;
    }
    return;
}

function OnRefineDoneResult(string a_Param)
{
    local int Option1, Option2, RefineResult, Quality;

    ParseInt(a_Param, "Option1", Option1);
    ParseInt(a_Param, "Option2", Option2);
    ParseInt(a_Param, "Result", RefineResult);
    m_hRefineryWndRefineryProgress.SetPos(0);
    m_OkBtn.EnableWindow();
    switch(RefineResult)
    {
        // End:0x1AA
        case 1:
            RefineItemInfo.RefineryOp1 = Option1;
            RefineItemInfo.RefineryOp2 = Option2;
            // End:0xC2
            if(!m_ResultBoxItem.SetItem(0, RefineItemInfo))
            {
                m_ResultBoxItem.AddItem(RefineItemInfo);
            }
            OnRefineryRefineResult();
            Quality = Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(Option2);
            // End:0xF7
            if(0 >= Quality)
            {
                Quality = 1;                
            }
            else
            {
                // End:0x10B
                if(4 < Quality)
                {
                    Quality = 4;
                }
            }
            m_RefineResultBackPattern.ShowWindow();
            m_RefineResultBackPattern.SetAlpha(0);
            m_RefineResultBackPattern.SetAlpha(255, 1.0000000);
            PlayResultAnimation(Quality);
            m_RefineryBtn.SetNameText(GetSystemString(1731));
            m_RefineryBtn.EnableWindow();
            IsResult = true;
            ResultData.op1 = Option1;
            ResultData.op2 = Option2;
            AddTooltipRefinery(RefineItemInfo);
            // End:0x1C3
            break;
        // End:0x1BD
        case 0:
            ResetRefineryData();
            OnClickCancelButton();
            // End:0x1C3
            break;
        // End:0xFFFF
        default:
            // End:0x1C3
            break;
            break;
    }
    return;
}

function AddTooltipRefinery(ItemInfo item)
{
    local string strDesc1, strDesc2, strDesc3;
    local int ColorR, ColorG, ColorB, Quality;
    local array<DrawItemInfo> drawListArr;

    // End:0x41A
    if((item.RefineryOp1 != 0) || item.RefineryOp2 != 0)
    {
        drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(GetSystemString(1490), true, false, 0, 0, 140, GetColor(255, 255, 0, 255));
        drawListArr[drawListArr.Length] = TLTP_BLANK(3);
        // End:0xBB
        if(__NFUN_412__(item.SlotBitType, (8192)))
        {
            Quality = Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp1);
            GetRefineryColor(Quality, ColorR, ColorG, ColorB);            
        }
        else
        {
            Quality = Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp2);
            GetRefineryColor(Quality, ColorR, ColorG, ColorB);
        }
        // End:0x20D
        if(item.RefineryOp1 != 0)
        {
            strDesc1 = "";
            strDesc2 = "";
            strDesc3 = "";
            // End:0x20D
            if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp1, strDesc1, strDesc2, strDesc3))
            {
                // End:0x189
                if(Len(strDesc1) > 0)
                {
                    drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(strDesc1, true, true, 0, 0, 140, GetColor(ColorR, ColorG, ColorB, 255));
                }
                // End:0x1CB
                if(Len(strDesc2) > 0)
                {
                    drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(strDesc2, true, true, 0, 0, 140, GetColor(ColorR, ColorG, ColorB, 255));
                }
                // End:0x20D
                if(Len(strDesc3) > 0)
                {
                    drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(strDesc3, true, true, 0, 0, 140, GetColor(ColorR, ColorG, ColorB, 255));
                }
            }
        }
        // End:0x25D
        if(__NFUN_412__(item.SlotBitType, (8192)))
        {
            Quality = Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp2);
            GetRefineryColor(Quality, ColorR, ColorG, ColorB);
        }
        // End:0x376
        if(item.RefineryOp2 != 0)
        {
            strDesc1 = "";
            strDesc2 = "";
            strDesc3 = "";
            // End:0x376
            if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp2, strDesc1, strDesc2, strDesc3))
            {
                // End:0x2F2
                if(Len(strDesc1) > 0)
                {
                    drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(strDesc1, true, true, 0, 0, 140, GetColor(ColorR, ColorG, ColorB, 255));
                }
                // End:0x334
                if(Len(strDesc2) > 0)
                {
                    drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(strDesc2, true, true, 0, 0, 140, GetColor(ColorR, ColorG, ColorB, 255));
                }
                // End:0x376
                if(Len(strDesc3) > 0)
                {
                    drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(strDesc3, true, true, 0, 0, 140, GetColor(ColorR, ColorG, ColorB, 255));
                }
            }
        }
        drawListArr[drawListArr.Length] = TLTP_BLANK(3);
        // End:0x3EA
        if(!getInstanceUIData().getIsClassicServer() && __NFUN_413__(item.SlotBitType, (8192)))
        {
            drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(GetSystemString(1491), true, true, 0, 0, 140, GetColor(255, 255, 0, 255));
        }
        drawListArr[drawListArr.Length] = TLTP_TEXTURE_LINE("L2ui_ch3.tooltip_line", true, true, 0, 0, 0, 0);
    }
    m_RefineryBtn.SetTooltipType("Text");
    m_RefineryBtn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
    return;
}

function string GetRefineryText(int op1, int op2)
{
    local string strDesc1, strDesc2, strDesc3, Result;

    // End:0x1B
    if((op1 == 0) && op2 == 0)
    {
        return "";
    }
    // End:0xBB
    if(op1 != 0)
    {
        // End:0xBB
        if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(op1, strDesc1, strDesc2, strDesc3))
        {
            // End:0x71
            if(Len(strDesc1) > 0)
            {
                Result = (Result $ strDesc1) $ "\\n";
            }
            // End:0x96
            if(Len(strDesc2) > 0)
            {
                Result = (Result $ strDesc2) $ "\\n";
            }
            // End:0xBB
            if(Len(strDesc3) > 0)
            {
                Result = (Result $ strDesc3) $ "\\n";
            }
        }
    }
    // End:0x15B
    if(op2 != 0)
    {
        // End:0x15B
        if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(op2, strDesc1, strDesc2, strDesc3))
        {
            // End:0x111
            if(Len(strDesc1) > 0)
            {
                Result = (Result $ strDesc1) $ "\\n";
            }
            // End:0x136
            if(Len(strDesc2) > 0)
            {
                Result = (Result $ strDesc2) $ "\\n";
            }
            // End:0x15B
            if(Len(strDesc3) > 0)
            {
                Result = (Result $ strDesc3) $ "\\n";
            }
        }
    }
    return Result;
    return;
}

function GetRefineryColor(int Quality, out int R, out int G, out int B)
{
    switch(Quality)
    {
        // End:0x26
        case 1:
            R = 187;
            G = 181;
            B = 138;
            // End:0xA7
            break;
        // End:0x46
        case 2:
            R = 132;
            G = 174;
            B = 216;
            // End:0xA7
            break;
        // End:0x66
        case 3:
            R = 193;
            G = 112;
            B = 202;
            // End:0xA7
            break;
        // End:0x86
        case 4:
            R = 225;
            G = 109;
            B = 109;
            // End:0xA7
            break;
        // End:0xFFFF
        default:
            R = 187;
            G = 181;
            B = 138;
            // End:0xA7
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A7
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A7
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A7
}

function PlayResultAnimation(int grade)
{
    m_ResultAnim1.SetLoopCount(1);
    m_ResultAnim2.SetLoopCount(1);
    m_ResultAnim3.SetLoopCount(1);
    switch(grade)
    {
        // End:0x87
        case 1:
            m_ResultAnimation1.ShowWindow();
            PlaySound("ItemSound2.smelting.smelting_finalB");
            m_ResultAnim1.Play();
            // End:0x1BC
            break;
        // End:0xD8
        case 2:
            m_ResultAnimation2.ShowWindow();
            PlaySound("ItemSound2.smelting.smelting_finalC");
            m_ResultAnim2.Play();
            // End:0x1BC
            break;
        // End:0x129
        case 3:
            m_ResultAnimation3.ShowWindow();
            PlaySound("ItemSound2.smelting.smelting_finalD");
            m_ResultAnim3.Play();
            // End:0x1BC
            break;
        // End:0x1B6
        case 4:
            m_ResultAnimation1.ShowWindow();
            m_ResultAnimation2.ShowWindow();
            m_ResultAnimation3.ShowWindow();
            PlaySound("ItemSound2.smelting.smelting_finalD");
            m_ResultAnim1.Play();
            m_ResultAnim2.Play();
            m_ResultAnim3.Play();
            // End:0x1BC
            break;
        // End:0xFFFF
        default:
            // End:0x1BC
            break;
            break;
    }
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x23
    if(1 == 0)
    {
        InitHandle();        
    }
    else
    {
        InitHandleCOD();
    }
    IsResult = false;
    bRetryRequested = false;
    procedure1stat = false;
    procedure2stat = false;
    procedure3stat = false;
    procedure4stat = false;
    m_RefineAnim.SetLoopCount(1);
    m_ResultAnim1.SetLoopCount(1);
    m_ResultAnim2.SetLoopCount(1);
    m_ResultAnim3.SetLoopCount(1);
    m_hRefineryWndRefineryProgress.SetProgressTime(60);
    m_RefineAnim.SetTimes(1.0000000);
    inventoryWndScript = InventoryWnd(GetScript("InventoryWnd"));
    return;
}

function MoveItemBoxes(bool a_Origin)
{
    local Rect Item1Rect, Item2Rect, Item3Rect, ResultRect;

    // End:0xCF
    if(a_Origin)
    {
        m_DragBox1.SetAnchor("RefineryWnd", "TopLeft", "TopLeft", 77, 51);
        m_DragBox1.ClearAnchor();
        m_DragBox2.SetAnchor("RefineryWnd", "TopLeft", "TopLeft", 157, 51);
        m_DragBox2.ClearAnchor();
        m_DragBox3.SetAnchor("RefineryWnd", "TopLeft", "TopLeft", 117, 91);
        m_DragBox3.ClearAnchor();        
    }
    else
    {
        Item1Rect = m_DragBox1.GetRect();
        Item2Rect = m_DragBox2.GetRect();
        Item3Rect = m_DragBox3.GetRect();
        ResultRect = m_DragBoxResult.GetRect();
        m_DragBox1.Move(ResultRect.nX - Item1Rect.nX, ResultRect.nY - Item1Rect.nY, 0.1000000);
        m_DragBox2.Move(ResultRect.nX - Item2Rect.nX, ResultRect.nY - Item2Rect.nY, 0.1000000);
        m_DragBox3.Move(ResultRect.nX - Item3Rect.nX, ResultRect.nY - Item3Rect.nY, 0.1000000);
    }
    return;
}

function OnReceivedCloseUI()
{
    ResetRefineryData();
    PlayConsoleSound(6);
    OnClickCancelButton();
    return;
}
