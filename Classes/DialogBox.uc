class DialogBox extends UICommonAPI;

const INPUT_DEFAULT_MAXLENGTH = 64;

var int INPUT_NUMBERPAD_MAXLENGTH;
var WindowHandle m_dialogBody;
var WindowHandle m_dialogHandle;
var ButtonHandle m_okHandle;
var ButtonHandle m_cancelHandle;
var ButtonHandle m_centerHandle;
var EditBoxHandle m_editHandle;
var TextBoxHandle m_textHandle;
var string m_strTargetScript;
var string m_strEditMessage;
var UIScript.EDialogType m_type;
var int m_ID;
var INT64 m_paramInt;
var int m_reservedInt;
var INT64 m_reservedInt2;
var int m_reservedInt3;
var ItemID m_reservedItemID;
var ItemInfo m_reservedItemInfo;
var string m_reservedString;
var int m_editMaxLength;
var int m_editMaxLength_prev;
var int buttonWidth_prev;
var int buttonHeight_prev;
var int NumberPad_DefaultValue;
var INT64 NumberPad_Value;
var string strValue;
var UIScript.DialogDefaultAction m_defaultAction;
var UIScript.DialogEnterAction m_enterAction;
var ProgressCtrlHandle m_hDialogBoxDialogProgress;
var bool m_bGlobalIME;
var TextureHandle m_exclamationImage;
var HtmlHandle m_HtmlViewer;
var Rect defaultBodyRect;
var int tryCancelDialogID;
var int saveCancelDialogID;

function bool isHardCodingSystemMessage(string Message)
{
    local array<string> ArrayStr;
    local string targetString;
    local int i;

    Split(targetString, ",", ArrayStr);
    i = 0;
    J0x1A:

    // End:0x53 [Loop If]
    if(i < ArrayStr.Length)
    {
        // End:0x49
        if(GetSystemMessage(int(ArrayStr[i])) == Message)
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x1A;
    }
    return false;
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x15
    if(tryCancelDialogID > -1)
    {
        HideDialog();
    }
    return;
}

function setDialogCancelD(int targetCancelDialogID)
{
    saveCancelDialogID = targetCancelDialogID;
    return;
}

function ShowDialog(UIScript.EDialogModalType modalType, UIScript.EDialogType Style, string Message, string Target, optional int widthSizeChangeValue, optional int heightSizeChangeValue, optional bool bUseHtml)
{
    local UIEventManager.ELanguageType Language;

    // End:0x1E
    if(isHardCodingSystemMessage(Message))
    {
        bUseHtml = true;
        heightSizeChangeValue = 186;
    }
    // End:0x3E
    if(int(modalType) == 0)
    {
        m_dialogHandle.SetModal(true);        
    }
    else
    {
        // End:0x5B
        if(int(modalType) == 1)
        {
            m_dialogHandle.SetModal(false);
        }
    }
    // End:0x70
    if(tryCancelDialogID > -1)
    {
        HandleCancel();
    }
    // End:0x95
    if(saveCancelDialogID > -1)
    {
        tryCancelDialogID = saveCancelDialogID;
        saveCancelDialogID = -1;
    }
    m_dialogHandle.ShowWindow();
    SetWindowStyle(Style);
    m_dialogHandle.SetFocus();
    // End:0x13C
    if(m_editHandle.IsShowWindow())
    {
        m_editHandle.SetString("");
        m_editHandle.SetFocus();
        // End:0x12B
        if(m_editMaxLength != -1)
        {
            m_editMaxLength_prev = m_editHandle.GetMaxLength();
            m_editHandle.SetMaxLength(m_editMaxLength);            
        }
        else
        {
            m_editHandle.SetMaxLength(64);
        }
    }
    m_strTargetScript = Target;
    // End:0x194
    if((widthSizeChangeValue > 0) && heightSizeChangeValue > 0)
    {
        m_dialogHandle.SetWindowSize(widthSizeChangeValue, heightSizeChangeValue);
        m_dialogBody.SetWindowSize(widthSizeChangeValue, heightSizeChangeValue);        
    }
    else
    {
        // End:0x1DE
        if(widthSizeChangeValue > 0)
        {
            m_dialogHandle.SetWindowSize(widthSizeChangeValue, defaultBodyRect.nHeight);
            m_dialogBody.SetWindowSize(widthSizeChangeValue, defaultBodyRect.nHeight);            
        }
        else
        {
            // End:0x225
            if(heightSizeChangeValue > 0)
            {
                m_dialogHandle.SetWindowSize(defaultBodyRect.nWidth, heightSizeChangeValue);
                m_dialogBody.SetWindowSize(defaultBodyRect.nWidth, heightSizeChangeValue);
            }
        }
    }
    SetMessage(Message, bUseHtml);
    m_bGlobalIME = false;
    Language = GetLanguage();
    // End:0x270
    if((int(Language) == 2) || int(Language) == 3)
    {
        m_bGlobalIME = true;
    }
    return;
}

function bool hasPreviousCancelProcess()
{
    return tryCancelDialogID > -1;
    return;
}

function bool checkCancelDialogID(int taregetDialogID)
{
    return (tryCancelDialogID > -1) && tryCancelDialogID == taregetDialogID;
    return;
}

function HideDialog()
{
    // End:0x15
    if(tryCancelDialogID > -1)
    {
        HandleCancel();
    }
    NumberPad_DefaultValue = 0;
    INPUT_NUMBERPAD_MAXLENGTH = 15;
    SetButtonName(1337, 1342);
    m_dialogHandle.HideWindow();
    Initialize();
    setIconTexture("");
    m_exclamationImage.ShowWindow();
    return;
}

function SetDefaultAction(UIScript.DialogDefaultAction defaultAction)
{
    m_defaultAction = defaultAction;
    return;
}

function SetEnterAction(UIScript.DialogEnterAction enterAction)
{
    m_enterAction = enterAction;
    return;
}

function string GetTarget()
{
    return m_strTargetScript;
    return;
}

function string GetEditMessage()
{
    return m_strEditMessage;
    return;
}

function SetEditMessage(string strMsg)
{
    m_editHandle.SetString(strMsg);
    return;
}

function int GetID()
{
    return m_ID;
    return;
}

function setId(int Id)
{
    m_ID = Id;
    return;
}

function SetEditType(string strType)
{
    m_editHandle.super(DialogBox).SetEditType(strType);
    return;
}

function setParamInt64(INT64 param)
{
    m_paramInt = param;
    return;
}

function SetReservedStr(string Value)
{
    strValue = Value;
    return;
}

function string GetReservedStr()
{
    return strValue;
    return;
}

function SetReservedInt(int Value)
{
    m_reservedInt = Value;
    return;
}

function SetReservedInt2(INT64 Value)
{
    m_reservedInt2 = Value;
    return;
}

function SetReservedInt3(int Value)
{
    m_reservedInt3 = Value;
    return;
}

function SetReservedItemID(ItemID Id)
{
    m_reservedItemID = Id;
    return;
}

function SetReservedItemInfo(ItemInfo Info)
{
    m_reservedItemInfo = Info;
    return;
}

function SetReservedString(string Str)
{
    m_reservedString = Str;
    return;
}

function string GetReservedString()
{
    return m_reservedString;
    return;
}

function INT64 GetReservedParamInt64()
{
    return m_paramInt;
    return;
}

function int GetReservedInt()
{
    return m_reservedInt;
    return;
}

function INT64 GetReservedInt2()
{
    return m_reservedInt2;
    return;
}

function int GetReservedInt3()
{
    return m_reservedInt3;
    return;
}

function ItemID GetReservedItemID()
{
    return m_reservedItemID;
    return;
}

function GetReservedItemInfo(out ItemInfo Info)
{
    Info = m_reservedItemInfo;
    return;
}

function SetEditBoxMaxLength(int maxLength)
{
    // End:0x16
    if(maxLength >= 0)
    {
        m_editMaxLength = maxLength;
    }
    return;
}

function SetNumberPadDefaultValue(int Value)
{
    NumberPad_DefaultValue = Value;
    return;
}

function setIconTexture(string texturePath)
{
    // End:0x50
    if(texturePath == "")
    {
        m_exclamationImage.SetTexture("L2UI_ct1.Icon.ICON_DF_Exclamation");
        m_exclamationImage.ClearTooltip();        
    }
    else
    {
        m_exclamationImage.SetTexture(texturePath);
    }
    return;
}

function setIconCustomToolTip(CustomTooltip TooltipInfo)
{
    m_exclamationImage.SetTooltipType("text");
    m_exclamationImage.SetTooltipCustomType(TooltipInfo);
    return;
}

function OnLoad()
{
    INPUT_NUMBERPAD_MAXLENGTH = 15;
    SetClosingOnESC();
    m_dialogBody = GetWindowHandle("DialogBox.DialogBody");
    m_dialogHandle = GetWindowHandle("DialogBox");
    m_okHandle = GetButtonHandle("DialogBox.OKButton");
    m_cancelHandle = GetButtonHandle("DialogBox.CancelButton");
    m_centerHandle = GetButtonHandle("DialogBox.CenterOKButton");
    m_editHandle = GetEditBoxHandle("DialogBox.DialogBoxEdit");
    m_textHandle = GetTextBoxHandle("DialogBox.DialogReadingText");
    m_exclamationImage = GetTextureHandle("DialogBox.DialogBody.ExclamationImage");
    m_HtmlViewer = GetHtmlHandle("DialogBox.DialogBody.HtmlViewer");
    m_hDialogBoxDialogProgress = GetProgressCtrlHandle("DialogBox.DialogProgress");
    Initialize();
    SetButtonName(1337, 1342);
    SetMessage("Message uninitialized");
    defaultBodyRect = Class'NWindow.UIAPI_WINDOW'.static.GetRect("DialogBox.DialogBody");
    NumberPad_DefaultValue = 0;
    tryCancelDialogID = -1;
    // End:0x24B
    if(buttonWidth_prev != 0)
    {
        m_okHandle.SetWindowSize(buttonWidth_prev, buttonHeight_prev);
        m_centerHandle.SetWindowSize(buttonWidth_prev, buttonHeight_prev);
        m_cancelHandle.SetWindowSize(buttonWidth_prev, buttonHeight_prev);
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x14
        case "OKButton":
        // End:0x30
        case "CenterOKButton":
            HandleOK();
            // End:0xD9
            break;
        // End:0x4A
        case "CancelButton":
            HandleCancel();
            // End:0xD9
            break;
        // End:0x53
        case "num0":
        // End:0x5C
        case "num1":
        // End:0x65
        case "num2":
        // End:0x6E
        case "num3":
        // End:0x77
        case "num4":
        // End:0x80
        case "num5":
        // End:0x89
        case "num6":
        // End:0x92
        case "num7":
        // End:0x9B
        case "num8":
        // End:0xA4
        case "num9":
        // End:0xAF
        case "numAll":
        // End:0xB9
        case "numBS":
        // End:0xD0
        case "numC":
            HandleNumberClick(strID);
            // End:0xD9
            break;
        // End:0xFFFF
        default:
            // End:0xD9
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0D9
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0D9
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0D9
}

function OnHide()
{
    // End:0x1D
    if(int(m_type) == 7)
    {
        m_hDialogBoxDialogProgress.Stop();
    }
    SetEditType("normal");
    SetEditMessage("");
    // End:0x61
    if(m_editMaxLength != -1)
    {
        m_editMaxLength = -1;
        m_editHandle.SetMaxLength(m_editMaxLength_prev);
    }
    m_editHandle.Clear();
    NumberPad_DefaultValue = 0;
    SetButtonName(1337, 1342);
    INPUT_NUMBERPAD_MAXLENGTH = 15;
    return;
}

function OnChangeEditBox(string strID)
{
    local string strInput, strComma;
    local Color TextColor;

    // End:0x11B
    if(strID == "DialogBoxEdit")
    {
        // End:0xF2
        if(int(m_type) == 6)
        {
            m_textHandle.SetText("");
            // End:0x5B
            if(m_editMaxLength == -1)
            {
                m_editHandle.SetMaxLength(INPUT_NUMBERPAD_MAXLENGTH);
            }
            strInput = m_editHandle.GetString();
            // End:0xEF
            if(Len(strInput) > 0)
            {
                strComma = MakeCostString(strInput);
                // End:0xB0
                if(NumberPad_DefaultValue != 0)
                {
                    strInput = (__NFUN_401__(NumberPad_Value, (NumberPad_DefaultValue)));
                }
                m_textHandle.SetText(ConvertNumToTextNoAdena(strInput));
                TextColor = GetNumericColor(strComma);
                m_editHandle.SetFontColor(TextColor);
            }            
        }
        else
        {
            TextColor = GetNumericColor(MakeCostString("1"));
            m_editHandle.SetFontColor(TextColor);
        }
    }
    return;
}

function Initialize()
{
    m_strTargetScript = "";
    SetEditType("normal");
    m_paramInt = (0);
    m_reservedInt = 0;
    m_reservedInt2 = (0);
    m_editMaxLength = -1;
    SetDefaultAction(0);
    SetEnterAction(0);
    return;
}

function HideAll()
{
    m_editHandle.HideWindow();
    m_okHandle.HideWindow();
    m_cancelHandle.HideWindow();
    m_centerHandle.HideWindow();
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("DialogBox.NumberPad");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("DialogBox.DialogProgress");
    setIconTexture("");
    return;
}

function SetWindowStyle(UIScript.EDialogType Style)
{
    local Rect bodyRect, numpadRect;

    HideAll();
    bodyRect = defaultBodyRect;
    m_dialogBody.SetWindowSize(bodyRect.nWidth, bodyRect.nHeight);
    numpadRect = Class'NWindow.UIAPI_WINDOW'.static.GetRect("DialogBox.NumberPad");
    m_type = Style;
    switch(Style)
    {
        // End:0xB9
        case 0:
            m_okHandle.ShowWindow();
            m_cancelHandle.ShowWindow();
            m_dialogHandle.SetWindowSize(bodyRect.nWidth, bodyRect.nHeight);
            // End:0x38B
            break;
        // End:0xF3
        case 1:
            m_centerHandle.ShowWindow();
            m_dialogHandle.SetWindowSize(bodyRect.nWidth, bodyRect.nHeight);
            // End:0x38B
            break;
        // End:0x15C
        case 2:
            m_editHandle.ShowWindow();
            m_textHandle.SetText("");
            m_okHandle.ShowWindow();
            m_cancelHandle.ShowWindow();
            m_dialogHandle.SetWindowSize(bodyRect.nWidth, bodyRect.nHeight);
            // End:0x38B
            break;
        // End:0x1B6
        case 3:
            m_editHandle.ShowWindow();
            m_textHandle.SetText("");
            m_centerHandle.ShowWindow();
            m_dialogHandle.SetWindowSize(bodyRect.nWidth, bodyRect.nHeight);
            // End:0x38B
            break;
        // End:0x1FF
        case 4:
            m_okHandle.ShowWindow();
            m_cancelHandle.ShowWindow();
            m_dialogHandle.SetWindowSize(bodyRect.nWidth, bodyRect.nHeight);
            // End:0x38B
            break;
        // End:0x239
        case 5:
            m_centerHandle.ShowWindow();
            m_dialogHandle.SetWindowSize(bodyRect.nWidth, bodyRect.nHeight);
            // End:0x38B
            break;
        // End:0x2D7
        case 6:
            m_editHandle.ShowWindow();
            m_textHandle.SetText("");
            m_okHandle.ShowWindow();
            m_cancelHandle.ShowWindow();
            ShowWindow("DialogBox.NumberPad");
            m_dialogHandle.SetWindowSize(bodyRect.nWidth + numpadRect.nWidth, bodyRect.nHeight);
            SetEditType("number");
            // End:0x38B
            break;
        // End:0x385
        case 7:
            m_okHandle.ShowWindow();
            m_cancelHandle.ShowWindow();
            ShowWindow("DialogBox.DialogProgress");
            m_dialogHandle.SetWindowSize(bodyRect.nWidth, bodyRect.nHeight);
            // End:0x34E
            if(__NFUN_412__(m_paramInt, (0)))
            {                
            }
            else
            {
                m_hDialogBoxDialogProgress.SetProgressTime(name(m_paramInt));
                m_hDialogBoxDialogProgress.Reset();
                m_hDialogBoxDialogProgress.Start();
            }
            // End:0x38B
            break;
        // End:0xFFFF
        default:
            // End:0x38B
            break;
            break;
    }
    // End:0x3CB
    if(int(Style) == 7)
    {
        m_dialogHandle.SetAnchor("", "BottomCenter", "BottomCenter", 0, 0);        
    }
    else
    {
        m_dialogHandle.SetAnchor("", "CenterCenter", "CenterCenter", 0, 0);
    }
    return;
}

function bool isProgressBarWorking()
{
    return tryCancelDialogID > -1;
    return;
}

function SetMessage(string strMessage, optional bool bUseHtml)
{
    // End:0x6B
    if(bUseHtml)
    {
        m_exclamationImage.HideWindow();
        m_HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(strMessage));
        m_HtmlViewer.ShowWindow();
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DialogBox.DialogText", "");        
    }
    else
    {
        m_exclamationImage.ShowWindow();
        m_HtmlViewer.HideWindow();
        m_HtmlViewer.LoadHtmlFromString("");
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("DialogBox.DialogText", strMessage);
    }
    return;
}

function SetButtonName(int indexOK, optional int indexCancel)
{
    m_okHandle.super(DialogBox).SetButtonName(indexOK);
    m_centerHandle.super(DialogBox).SetButtonName(indexOK);
    // End:0x47
    if(indexCancel != 0)
    {
        m_cancelHandle.super(DialogBox).SetButtonName(indexCancel);
    }
    return;
}

function SetButtonWidthSize(int indexOK, optional int indexCancel)
{
    m_okHandle.GetWindowSize(buttonWidth_prev, buttonHeight_prev);
    m_okHandle.SetWindowSize(indexOK, buttonHeight_prev);
    m_centerHandle.SetWindowSize(indexOK, buttonHeight_prev);
    // End:0x6F
    if(indexCancel != 0)
    {
        m_cancelHandle.SetWindowSize(indexCancel, buttonHeight_prev);
    }
    return;
}

function HandleOK()
{
    // End:0x2A
    if(m_editHandle.IsShowWindow())
    {
        m_strEditMessage = m_editHandle.GetString();        
    }
    else
    {
        m_strEditMessage = "";
    }
    tryCancelDialogID = -1;
    m_dialogHandle.HideWindow();
    ExecuteEvent(1710, Mid(m_strTargetScript, InStr(m_strTargetScript, ".") + 1));
    return;
}

function HandleCancel()
{
    m_dialogHandle.HideWindow();
    ExecuteEvent(1720);
    tryCancelDialogID = -1;
    return;
}

function HandleNumberClick(string strID)
{
    local int i;
    local string sumStr, sumStrWithoutComma;

    switch(strID)
    {
        // End:0x3B
        case "num0":
            // End:0x38
            if(m_editHandle.GetString() != "")
            {
                m_editHandle.AddString("0");
            }
            // End:0x26F
            break;
        // End:0x59
        case "num1":
            m_editHandle.AddString("1");
            // End:0x26F
            break;
        // End:0x77
        case "num2":
            m_editHandle.AddString("2");
            // End:0x26F
            break;
        // End:0x95
        case "num3":
            m_editHandle.AddString("3");
            // End:0x26F
            break;
        // End:0xB3
        case "num4":
            m_editHandle.AddString("4");
            // End:0x26F
            break;
        // End:0xD1
        case "num5":
            m_editHandle.AddString("5");
            // End:0x26F
            break;
        // End:0xEF
        case "num6":
            m_editHandle.AddString("6");
            // End:0x26F
            break;
        // End:0x10D
        case "num7":
            m_editHandle.AddString("7");
            // End:0x26F
            break;
        // End:0x12B
        case "num8":
            m_editHandle.AddString("8");
            // End:0x26F
            break;
        // End:0x149
        case "num9":
            m_editHandle.AddString("9");
            // End:0x26F
            break;
        // End:0x22D
        case "numAll":
            // End:0x22A
            if(__NFUN_411__(m_paramInt, (0)))
            {
                m_editHandle.SetString((m_paramInt));
                sumStr = "";
                i = 0;
                J0x187:

                // End:0x1F6 [Loop If]
                if(i < m_editMaxLength)
                {
                    // End:0x1CC
                    if(((float(i) % float(4)) == float(3)) && i != 0)
                    {
                        sumStr = "," $ sumStr;
                        // [Explicit Continue]
                        goto J0x1EC;
                    }
                    sumStr = "9" $ sumStr;
                    sumStrWithoutComma = "9" $ sumStrWithoutComma;
                    J0x1EC:

                    i++;
                    // [Loop Continue]
                    goto J0x187;
                }
                // End:0x22A
                if(sumStr != "")
                {
                    // End:0x22A
                    if(__NFUN_408__((int(sumStrWithoutComma)), m_paramInt))
                    {
                        m_editHandle.SetString(sumStrWithoutComma);
                    }
                }
            }
            // End:0x26F
            break;
        // End:0x249
        case "numBS":
            m_editHandle.SimulateBackspace();
            // End:0x26F
            break;
        // End:0x266
        case "numC":
            m_editHandle.SetString("");
            // End:0x26F
            break;
        // End:0xFFFF
        default:
            // End:0x26F
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x26F
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x26F
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x26F
}

function OnProgressTimeUp(string strID)
{
    // End:0x20
    if(strID == "DialogProgress")
    {
        DoDefaultAction();
    }
    return;
}

function DoDefaultAction()
{
    switch(m_defaultAction)
    {
        // End:0x15
        case 1:
            HandleOK();
            // End:0x3A
            break;
        // End:0x23
        case 2:
            HandleCancel();
            // End:0x3A
            break;
        // End:0x31
        case 0:
            HandleCancel();
            // End:0x3A
            break;
        // End:0xFFFF
        default:
            // End:0x3A
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03A
    SetDefaultAction(0);
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03A
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03A
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x03A
}

function DoEnterAction()
{
    switch(m_enterAction)
    {
        // End:0x15
        case 1:
            HandleOK();
            // End:0x42
            break;
        // End:0x23
        case 2:
            HandleCancel();
            // End:0x42
            break;
        // End:0x2B
        case 3:
            // End:0x42
            break;
        // End:0x39
        case 0:
            DoDefaultAction();
            // End:0x42
            break;
        // End:0xFFFF
        default:
            // End:0x42
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x042
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x042
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x042
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x1F
    if(int(nKey) == 13)
    {
        // End:0x1F
        if(!chkIDEnterKey())
        {
            DoEnterAction();
        }
    }
    return;
}

function OnReceivedCloseUI()
{
    // End:0x14
    if(int(m_type) != 7)
    {
        HandleCancel();
    }
    return;
}

function bool chkIDEnterKey()
{
    local bool isshowcand;

    // End:0x5E
    if(m_bGlobalIME)
    {
        // End:0x5E
        if(m_editHandle.IsShowWindow())
        {
            isshowcand = m_editHandle.IsShowCandidateBox();
            Debug("DialogBox isshowcand" $ string(isshowcand));
            return isshowcand;
        }
    }
    return false;
    return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
    // End:0x17
    if(m_editHandle.IsShowWindow() == false)
    {
        return;
    }
    // End:0x48
    if((a_WindowHandle != none) && m_editHandle.IsFocused() == false)
    {
        m_editHandle.SetFocus();
    }
    return;
}

function setInputNumberpadMaxLenght(int Len)
{
    INPUT_NUMBERPAD_MAXLENGTH = Len;
    return;
}
