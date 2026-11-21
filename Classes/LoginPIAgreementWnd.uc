class LoginPIAgreementWnd extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

var array<GFxValue> args;
var GFxValue invokeResult;
var int currentScreenWidth;
var int currentScreenHeight;
var L2Util util;

function OnRegisterEvent()
{
    return;
}

function OnFlashLoaded()
{
    return;
}

function OnShow()
{
    AllocGFxValues(args, 1);
    AllocGFxValue(invokeResult);
    args[0].SetInt(0);
    Invoke("_root.onEvent", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function OnLoad()
{
    RegisterState("LoginPIAgreementWnd", "PIAgreementState");
    SetAlwaysOnTop(true);
    SetAnchor("", 9, 1, 0, 0);
    SetDefaultShow(true);
    SetContainer("ContainerHUD");
    return;
}
