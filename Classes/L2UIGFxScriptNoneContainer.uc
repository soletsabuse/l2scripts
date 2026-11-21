class L2UIGFxScriptNoneContainer extends GFxUIScript;

function AddState(string Str)
{
    RegisterState(getCurrentWindowName(string(self)), Str);
    SetStateChangeNotification();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 3411:
            handleNotifyBeforeStateChanged(a_Param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnFocus(bool bFlag, bool bTransparency)
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    Debug("onFocus !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" @ string(bFlag));
    AllocGFxValues(args, 2);
    args[0].SetBool(bFlag);
    args[1].SetBool(bTransparency);
    AllocGFxValue(invokeResult);
    Invoke("onFocusContainer", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function OnHide()
{
    invokeToFlash("onHide");
    return;
}

function OnShow()
{
    Debug((getCurrentWindowName(string(self))) @ "onShow");
    invokeToFlash("onShow");
    return;
}

function handleNotifyBeforeStateChanged(string param)
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(3411);
    CreateObject(args[1]);
    args[1].SetMemberString("state", param);
    Invoke("onEvent", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function OnReceivedCloseUI()
{
    invokeToFlash("onPressESC");
    return;
}

function OnDefaultPosition()
{
    invokeToFlash("onDefaultPosition");
    return;
}

function invokeToFlash(string invokeID)
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    AllocGFxValues(args, 1);
    Invoke(invokeID, args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

static function UIData getInstanceUIData()
{
    return UIData(GetScript("UIData"));
    return;
}

static function string getCurrentWindowName(string targetString)
{
    local array<string> ArrayStr;

    Split(targetString, ".", ArrayStr);
    return ArrayStr[1];
    return;
}

static function int Split(string strInput, string delim, out array<string> arrToken)
{
    local int arrSize;

    J0x00:
    // End:0x6F [Loop If]
    if(InStr(strInput, delim) > 0)
    {
        arrToken.Insert(arrToken.Length, 1);
        arrToken[arrToken.Length - 1] = Left(strInput, InStr(strInput, delim));
        strInput = Mid(strInput, InStr(strInput, delim) + 1);
        arrSize = arrSize + 1;
        // [Loop Continue]
        goto J0x00;
    }
    arrToken.Insert(arrToken.Length, 1);
    arrToken[arrToken.Length - 1] = strInput;
    arrSize = arrSize + 1;
    return arrSize;
    return;
}
