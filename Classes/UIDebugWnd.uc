class UIDebugWnd extends GFxUIScript;

var array<GFxValue> args;
var GFxValue invokeResult;
var bool bShow;

function OnRegisterEvent()
{
    RegisterEvent(5580);
    return;
}

function OnLoad()
{
    RegisterState("UIDebugWnd", "GamingState");
    return;
}

function OnShow()
{
    bShow = true;
    return;
}

function OnFlashLoaded()
{
    return;
}

function OnHide()
{
    bShow = false;
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x26
    if(Event_ID == 5580)
    {
        // End:0x26
        if(bShow == true)
        {
            SendFlashDebug(param);
        }
    }
    return;
}

function SendFlashDebug(string param)
{
    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(0);
    CreateObject(args[1]);
    args[1].SetMemberString("Trace", param);
    Invoke("_root.onEvent", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}
