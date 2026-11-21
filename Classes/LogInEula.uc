class LogInEula extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

var array<GFxValue> args;
var GFxValue invokeResult;
var int currentScreenWidth;
var int currentScreenHeight;
var L2Util util;
var int selectedType;

function OnRegisterEvent()
{
    RegisterEvent(5680);
    RegisterEvent(5681);
    RegisterEvent(2900);
    RegisterEvent(5641);
    return;
}

function OnLoad()
{
    RegisterState("LogInEula", "EULAMSGSTATE");
    SetContainer("ContainerHUD");
    SetAlwaysOnTop(true);
    SetAnchor("", 9, 1, 0, 0);
    return;
}

function OnShow()
{
    return;
}

function OnFlashLoaded()
{
    return;
}

function OnHide()
{
    return;
}

function OnFocus(bool bFlag, bool bTransparency)
{
    return;
}

function OnCallUCFunction(string logicID, string param)
{
    // End:0x24
    if(logicID == "0")
    {
        selectedType = int(param);
        EulaAgree(true);        
    }
    else
    {
        // End:0x38
        if(logicID == "1")
        {
            EulaAgree(false);
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string Eula1, Eula2;

    // End:0x2A
    if(Event_ID == 5680)
    {
        // End:0x27
        if(IsShowWindow() == false)
        {
            ShowWindow();
            SendEula();
        }        
    }
    else
    {
        // End:0x92
        if(Event_ID == 5681)
        {
            // End:0x8F
            if(IsShowWindow() == false)
            {
                ParseString(param, "EulaTxt1", Eula1);
                ParseString(param, "EulaTxt2", Eula2);
                ShowWindow();
                SendChinaEula(Eula1, Eula2);
            }            
        }
        else
        {
            // End:0xA7
            if(Event_ID == 2900)
            {
                SendScreenSize();
            }
        }
    }
    return;
}

function SendEula()
{
    CallGFxFunction("LoginEula", "SendEula", "");
    SendScreenSize();
    return;
}

function SendChinaEula(string Eula1, string Eula2)
{
    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(1);
    CreateObject(args[1]);
    args[1].SetMemberString("Eula1", Eula1);
    args[1].SetMemberString("Eula2", Eula2);
    Invoke("_root.onEvent", args, invokeResult);
    CallGFxFunction("LoginEula", "SendChinaEula", (("Eula1=" $ Eula1) @ "Eula2=") $ Eula2);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    SendScreenSize();
    return;
}

function SendScreenSize()
{
    GetCurrentResolution(currentScreenWidth, currentScreenHeight);
    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(100);
    CreateObject(args[1]);
    args[1].SetMemberInt("screenW", currentScreenWidth);
    args[1].SetMemberInt("screenH", currentScreenHeight);
    Invoke("_root.onEvent", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}
