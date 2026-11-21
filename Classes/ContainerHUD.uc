class ContainerHUD extends GFxUIScript;

var string registedState;

function OnLoad()
{
    SetClosingOnESC();
    SetDefaultShow(true);
    SetHUD();
    SetAlwaysOnBack(true);
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(3411);
    RegisterGFxEvent(2900);
    RegisterGFxEvent(6200);
    RegisterGFxEvent(1710);
    RegisterGFxEvent(1720);
    RegisterGFxEvent(9570);
    RegisterGFxEvent(9570);
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x23
        case "focusContainer":
            SetFocus();
            // End:0x26
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnFlashLoaded()
{
    local GFxValue l2SysStringTranslator, obj;

    RegisterDelegateHandler(16);
    RegisterDelegateHandler(3);
    RegisterDelegateHandler(13);
    RegisterDelegateHandler(3);
    RegisterDelegateHandler(10);
    RegisterDelegateHandler(9);
    RegisterDelegateHandler(11);
    RegisterDelegateHandler(19);
    RegisterDelegateHandler(24);
    RegisterDelegateHandler(2);
    RegisterDelegateHandler(26);
    RegisterDelegateHandler(28);
    AllocGFxValue(l2SysStringTranslator);
    AllocGFxValue(obj);
    GetFunction(l2SysStringTranslator, 1);
    obj.SetMemberValue("getTranslatedString", l2SysStringTranslator);
    DeallocGFxValue(l2SysStringTranslator);
    DeallocGFxValue(obj);
    return;
}

function OnFocus(bool bFlag, bool bTransparency)
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    AllocGFxValues(args, 2);
    args[0].SetBool(bFlag);
    args[1].SetBool(bTransparency);
    AllocGFxValue(invokeResult);
    Invoke("onFocusContainer", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
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
