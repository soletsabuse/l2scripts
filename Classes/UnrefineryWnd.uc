class UnrefineryWnd extends UICommonAPI;

var WindowHandle m_UnRefineryWnd_Main;
var WindowHandle m_ItemtoUnRefineWnd;
var WindowHandle m_ItemtoUnRefineAnim;
var WindowHandle m_hSelectedItemHighlight;
var WindowHandle m_ResultAnimation1;
var bool IsResult;
var TextBoxHandle m_InstructionText;
var TextBoxHandle m_AdenaText;
var ButtonHandle m_hUnrefineButton;
var ButtonHandle m_OkBtn;
var ItemWindowHandle m_ItemDragBox;
var ProgressCtrlHandle m_UnRefineryProgress;
var ItemInfo CurrentItem;
var INT64 m_Adena;
var ProgressCtrlHandle m_hUnrefineryWndUnRefineryProgress;
var RefineryWnd RefineryWnd;

function OnRegisterEvent()
{
    RegisterEvent(2810);
    RegisterEvent(2820);
    RegisterEvent(2830);
    RegisterEvent(1710);
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
    // End:0x1C7
    if(1 == 0)
    {
        m_ResultAnimation1 = GetHandle("UnrefineryWnd.RefineResultAnimation01");
        m_UnRefineryWnd_Main = GetHandle("UnrefineryWnd");
        m_UnRefineryProgress = ProgressCtrlHandle(GetHandle("UnRefineryProgress"));
        m_ItemtoUnRefineWnd = GetHandle("Itemtounrefine");
        m_ItemtoUnRefineAnim = GetHandle("ItemtounrefineAnim");
        m_hSelectedItemHighlight = GetHandle("SelectedItemHighlight");
        m_ItemDragBox = ItemWindowHandle(GetHandle("UnRefineryWnd.Itemtounrefine.ItemUnrefine"));
        m_InstructionText = TextBoxHandle(GetHandle("UnrefineryWnd.txtInstruction"));
        m_AdenaText = TextBoxHandle(GetHandle("UnrefineryWnd.txtAdenaInstruction"));
        m_hUnrefineButton = ButtonHandle(GetHandle("btnUnRefine"));
        m_OkBtn = ButtonHandle(GetHandle("btnClose"));        
    }
    else
    {
        m_ResultAnimation1 = GetWindowHandle("UnrefineryWnd.RefineResultAnimation01");
        m_UnRefineryWnd_Main = GetWindowHandle("UnrefineryWnd");
        m_UnRefineryProgress = GetProgressCtrlHandle("UnRefineryProgress");
        m_ItemtoUnRefineWnd = GetWindowHandle("Itemtounrefine");
        m_ItemtoUnRefineAnim = GetWindowHandle("ItemtounrefineAnim");
        m_hSelectedItemHighlight = GetWindowHandle("SelectedItemHighlight");
        m_ItemDragBox = GetItemWindowHandle("UnRefineryWnd.Itemtounrefine.ItemUnrefine");
        m_InstructionText = GetTextBoxHandle("UnrefineryWnd.txtInstruction");
        m_AdenaText = GetTextBoxHandle("UnrefineryWnd.txtAdenaInstruction");
        m_hUnrefineButton = GetButtonHandle("btnUnRefine");
        m_OkBtn = GetButtonHandle("btnClose");
        m_hUnrefineryWndUnRefineryProgress = GetProgressCtrlHandle("UnrefineryWnd.UnRefineryProgress");
    }
    RefineryWnd = RefineryWnd(GetScript("RefineryWnd"));
    return;
}

function OnShow()
{
    ResetReady();
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd,RefineryWnd");
    return;
}

function ResetReady()
{
    IsResult = false;
    m_UnRefineryWnd_Main.ShowWindow();
    m_ItemtoUnRefineWnd.ShowWindow();
    m_ItemtoUnRefineAnim.ShowWindow();
    m_hSelectedItemHighlight.HideWindow();
    m_ResultAnimation1.HideWindow();
    m_UnRefineryProgress.SetProgressTime(2000);
    m_UnRefineryProgress.Reset();
    m_hUnrefineButton.DisableWindow();
    m_ItemDragBox.Clear();
    m_InstructionText.SetText(GetSystemMessage(1963));
    SetAdenaText("0");
    m_AdenaText.SetTooltipString("");
    PlaySound("ItemSound2.smelting.Smelting_dragin");
    m_OkBtn.EnableWindow();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x43
        case 2810:
            PlaySound("ItemSound2.smelting.Smelting_dragin");
            ResetReady();
            // End:0xDF
            break;
        // End:0x84
        case 2820:
            PlaySound("ItemSound2.smelting.Smelting_dragin");
            OnTargetItemValidationResult(a_Param);
            // End:0xDF
            break;
        // End:0xC5
        case 2830:
            PlaySound("ItemSound2.smelting.smelting_finalA");
            OnUnRefineDoneResult(a_Param);
            // End:0xDF
            break;
        // End:0xD6
        case 1710:
            HandleDialogOK();
            // End:0xDF
            break;
        // End:0xFFFF
        default:
            // End:0xDF
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0DF
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0DF
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0DF
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    switch(a_WindowID)
    {
        // End:0x26
        case "ItemUnrefine":
            ValidateItem(a_ItemInfo);
            // End:0x2C
            break;
        // End:0xFFFF
        default:
            // End:0x2C
            break;
            break;
    }
    return;
}

function ValidateItem(ItemInfo a_ItemInfo)
{
    CurrentItem = a_ItemInfo;
    Class'NWindow.RefineryAPI'.static.ConfirmCancelItem(a_ItemInfo.Id);
    return;
}

function OnTargetItemValidationResult(string a_Param)
{
    local int ItemServerID, ItemClassID, Option1, Option2, ItemValidationResult;

    local string AdenaText;

    ParseInt(a_Param, "CancelItemServerID", ItemServerID);
    ParseInt(a_Param, "CancelItemClassID", ItemClassID);
    ParseInt(a_Param, "Option1", Option1);
    ParseInt(a_Param, "Option2", Option2);
    ParseINT64(a_Param, "Adena", m_Adena);
    ParseInt(a_Param, "Result", ItemValidationResult);
    switch(ItemValidationResult)
    {
        // End:0x173
        case 1:
            m_hUnrefineButton.EnableWindow();
            // End:0xF0
            if(!m_ItemDragBox.SetItem(0, CurrentItem))
            {
                m_ItemDragBox.AddItem(CurrentItem);
            }
            AdenaText = MakeCostStringINT64(m_Adena);
            SetAdenaText(AdenaText);
            m_ItemtoUnRefineAnim.HideWindow();
            m_hSelectedItemHighlight.ShowWindow();
            m_InstructionText.SetText("");
            // End:0x170
            if((checkAdena()) == false)
            {
                m_hUnrefineButton.DisableWindow();
                m_InstructionText.SetText(GetSystemMessage(279));
            }
            // End:0x186
            break;
        // End:0x180
        case 0:
            ResetReady();
            // End:0x186
            break;
        // End:0xFFFF
        default:
            // End:0x186
            break;
            break;
    }
    return;
}

function SetAdenaText(string a_AdenaText)
{
    local string AdenaText;

    AdenaText = ConvertNumToText(a_AdenaText);
    m_AdenaText.SetText(a_AdenaText @ GetSystemString(469));
    m_AdenaText.SetTextColor(GetNumericColor(a_AdenaText));
    // End:0x6D
    if(int(a_AdenaText) == 0)
    {
        m_AdenaText.SetTooltipString("");        
    }
    else
    {
        m_AdenaText.SetTooltipString(AdenaText);
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x4C
        case "btnUnRefine":
            // End:0x43
            if(IsResult)
            {
                m_hUnrefineButton.SetNameText(GetSystemString(1479));
                ResetReady();                
            }
            else
            {
                OnClickUnRefineButton();
            }
            // End:0xAC
            break;
        // End:0xA6
        case "btnClose":
            m_UnRefineryProgress.Reset();
            PlaySound("Itemsound2.smelting.smelting_dragout");
            m_UnRefineryWnd_Main.HideWindow();
            // End:0xAC
            break;
        // End:0xFFFF
        default:
            // End:0xAC
            break;
            break;
    }
    return;
}

function OnClickUnRefineButton()
{
    local INT64 diff, CurAdena;
    local string dialogText;

    CurAdena = GetAdena();
    diff = __NFUN_405__(CurAdena, m_Adena);
    // End:0xD2
    if(__NFUN_411__(diff, (0)))
    {
        dialogText = ((GetSystemString(1478) $ ":\\n") $ CurrentItem.Name) $ "\\n\\n";
        // End:0x9A
        if(RefineryWnd != none)
        {
            dialogText = (dialogText $ RefineryWnd.GetRefineryText(CurrentItem.RefineryOp1, CurrentItem.RefineryOp2)) $ "\\n";
        }
        dialogText = dialogText $ GetSystemString(7846);
        DialogSetID(10002);
        DialogShow(0, 0, dialogText, string(self));        
    }
    else
    {
        DialogShow(1, 1, GetSystemMessage(279), string(self));
    }
    return;
}

function HandleDialogOK()
{
    // End:0x33
    if((DialogIsMine()) && (DialogGetID()) == 10002)
    {
        // End:0x33
        if(m_UnRefineryWnd_Main.IsShowWindow())
        {
            StartUnRefine();
        }
    }
    return;
}

function StartUnRefine()
{
    local INT64 diff, CurAdena;

    CurAdena = GetAdena();
    diff = __NFUN_405__(CurAdena, m_Adena);
    // End:0x97
    if(__NFUN_411__(diff, (0)))
    {
        m_hUnrefineButton.DisableWindow();
        m_UnRefineryProgress.Start();
        m_ResultAnimation1.ShowWindow();
        PlaySound("ItemSound2.smelting.smelting_loding");
        m_OkBtn.DisableWindow();        
    }
    else
    {
        DialogShow(1, 1, GetSystemMessage(279), string(self));
    }
    return;
}

function bool checkAdena()
{
    local INT64 diff, CurAdena;

    CurAdena = GetAdena();
    diff = __NFUN_405__(CurAdena, m_Adena);
    // End:0x32
    if(__NFUN_411__(diff, (0)))
    {
        return true;        
    }
    else
    {
        return false;
    }
    return;
}

function PlayProgressiveBar()
{
    m_hUnrefineryWndUnRefineryProgress.Start();
    return;
}

function OnUnRefineRequest()
{
    RefineryWnd.IsResult = false;
    RefineryWnd.bIsResultReset = false;
    RefineryWnd.isResetAvailable = false;
    Class'NWindow.RefineryAPI'.static.RequestRefineCancel(CurrentItem.Id);
    return;
}

function OnUnRefineDoneResult(string a_Param)
{
    local int UnRefineResult;

    IsResult = true;
    ParseInt(a_Param, "Result", UnRefineResult);
    m_OkBtn.EnableWindow();
    m_hUnrefineryWndUnRefineryProgress.SetPos(0);
    Debug("UnRefineResult" @ string(UnRefineResult));
    switch(UnRefineResult)
    {
        // End:0x107
        case 1:
            CurrentItem.RefineryOp1 = 0;
            CurrentItem.RefineryOp2 = 0;
            // End:0xAF
            if(!m_ItemDragBox.SetItem(0, CurrentItem))
            {
                m_ItemDragBox.AddItem(CurrentItem);
            }
            m_InstructionText.SetText(MakeFullSystemMsg(GetSystemMessage(1965), CurrentItem.Name, ""));
            m_hUnrefineButton.SetNameText(GetSystemString(1731));
            m_hUnrefineButton.EnableWindow();
            // End:0x132
            break;
        // End:0x12C
        case 0:
            m_hUnrefineButton.EnableWindow();
            m_UnRefineryWnd_Main.HideWindow();
            // End:0x132
            break;
        // End:0xFFFF
        default:
            // End:0x132
            break;
            break;
    }
    return;
}

function OnProgressTimeUp(string strID)
{
    // End:0x24
    if(strID == "UnRefineryProgress")
    {
        OnUnRefineRequest();
    }
    return;
}

function OnReceivedCloseUI()
{
    OnClickButton("btnClose");
    return;
}
