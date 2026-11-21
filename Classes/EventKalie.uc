class EventKalie extends GFxUIScript;

const FLASH_XPOS = -190;
const FLASH_YPOS = 0;

var int currentScreenWidth;
var int currentScreenHeight;
var bool saveShow;

function OnRegisterEvent()
{
    RegisterGFxEvent(9433);
    RegisterGFxEvent(9434);
    RegisterGFxEvent(9435);
    RegisterEvent(2900);
    RegisterEvent(3410);
    RegisterEvent(40);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    RegisterState("EventKalie", "GamingState");
    SetAlwaysFullAlpha(true);
    SetHavingFocus(false);
    saveShow = false;
    return;
}

function OnShow()
{
    saveShow = true;
    return;
}

function OnFlashLoaded()
{
    local float xLoc, yLoc;
    local array<GFxValue> args;
    local GFxValue invokeResult;

    RegisterDelegateHandler(8);
    // End:0x1A
    if(IsSavedInfo())
    {
        SetGFxFromSavedInfo();        
    }
    else
    {
        AllocGFxValues(args, 2);
        AllocGFxValue(invokeResult);
        GetAnchorPointFromWindow(xLoc, yLoc, 3);
        args[0].SetInt(int(xLoc) + -190);
        args[1].SetInt(int(yLoc) + 0);
        Invoke("onMove", args, invokeResult);
        DeallocGFxValue(invokeResult);
        DeallocGFxValues(args);
    }
    setScreenResolution();
    return;
}

function setScreenResolution()
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    GetCurrentResolution(currentScreenWidth, currentScreenHeight);
    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(currentScreenWidth);
    args[1].SetInt(currentScreenHeight);
    Invoke("setCurrentResolution", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    // End:0x15
    if(Event_ID == 2900)
    {
        setScreenResolution();
    }
    // End:0x73
    if(Event_ID == 3410)
    {
        // End:0x50
        if(param == "GAMINGSTATE")
        {
            // End:0x4D
            if(saveShow == true)
            {
                SetShowWindow();
            }            
        }
        else
        {
            // End:0x70
            if(param == "CHARACTERSELECTSTATE")
            {
            }
        }        
    }
    else
    {
        // End:0xFA
        if(Event_ID == 40)
        {
            // End:0xFA
            if(saveShow)
            {
                AllocGFxValues(args, 2);
                AllocGFxValue(invokeResult);
                args[0].SetInt(9435);
                CreateObject(args[1]);
                Invoke("onEvent", args, invokeResult);
                DeallocGFxValue(invokeResult);
                DeallocGFxValues(args);
                saveShow = false;
            }
        }
    }
    return;
}

function SetShowWindow()
{
    // End:0x12
    if(IsShowWindow() == false)
    {
        ShowWindow();
    }
    return;
}

event OnMouseOut(WindowHandle W)
{
    dispatchEventToFlash_String(0, "");
    return;
}

event OnMouseOver(WindowHandle W)
{
    dispatchEventToFlash_String(1, "");
    return;
}

function dispatchEventToFlash_String(int Event_ID, string argString)
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(Event_ID);
    CreateObject(args[1]);
    args[1].SetMemberString("string", argString);
    Invoke("onEvent", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}
