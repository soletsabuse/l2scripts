class ToolTipWnd extends GFxUIScript;

var int currentScreenWidth;
var int currentScreenHeight;

function OnRegisterEvent()
{
    RegisterEvent(2900);
    RegisterEvent(3410);
    return;
}

function OnLoad()
{
    RegisterState("toolTipWnd", "LoginState");
    SetHUD();
    SetAnchor("", 1, 1, 0, 0);
    return;
}

function OnShow()
{
    return;
}

function OnFlashLoaded()
{
    SetRenderOnTop(true);
    SetAlwaysFullAlpha(true);
    IgnoreUIEvent(true);
    SetHavingFocus(false);
    setScreenResolution();
    return;
}

function setScreenResolution()
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    // End:0x11
    if(!IsShowWindow())
    {
        ShowWindow();
    }
    GetCurrentResolution(currentScreenWidth, currentScreenHeight);
    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(currentScreenWidth);
    args[1].SetInt(currentScreenHeight);
    Invoke("_root.setCurrentResolution", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function OnHide()
{
    return;
}

function OnCallUCLogic(int logicID, string param)
{
    // End:0x1A
    if(logicID == 1)
    {
        Debug("생성");        
    }
    else
    {
        // End:0x32
        if(logicID == 2)
        {
            Debug("삭제");
        }
    }
    return;
}

function externalCall(int nType, string objectString)
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    Debug("------------------------->>>>>>>>>>>>");
    Debug("type :" @ string(nType));
    Debug("obj  : " @ objectString);
    ShowWindow();
    setScreenResolution();
    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(nType);
    CreateObject(args[1]);
    args[1].SetMemberString("objectData", objectString);
    Invoke("_root.onEvent", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x18
    if(Event_ID == 2900)
    {
        setScreenResolution();        
    }
    else
    {
        // End:0x38
        if(Event_ID == 3410)
        {
            // End:0x38
            if(!IsShowWindow())
            {
                ShowWindow();
            }
        }
    }
    return;
}
