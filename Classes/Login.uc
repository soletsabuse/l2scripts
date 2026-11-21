class Login extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

var array<GFxValue> args;
var GFxValue invokeResult;
var string logInID;
var L2Util util;

function OnRegisterEvent()
{
    RegisterEvent(5630);
    RegisterEvent(5640);
    RegisterEvent(5650);
    RegisterEvent(5700);
    return;
}

function OnLoad()
{
    RegisterState("LogIn", "LoginState");
    SetContainer("ContainerHUD");
    SetHUD();
    SetAlwaysOnTop(true);
    logInID = "";
    HasTextField(false);
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

function OnCallUCFunction(string funcName, string param)
{
    local string Id, Pass;
    local int ncopt;
    local string delString;
    local int i;
    local string URL;

    switch(funcName)
    {
        // End:0x1B3
        case "setLogin":
            ParseString(param, "ID", Id);
            SaveLastLoginID(Id);
            ParseString(param, "pass", Pass);
            ParseInt(param, "ncopt", ncopt);
            RequestLogin(Id, Pass, ncopt);
            delString = "";
            i = 0;
            J0x84:

            // End:0xAF [Loop If]
            if(i < Len(param))
            {
                delString = delString $ "*";
                i++;
                // [Loop Continue]
                goto J0x84;
            }
            param = delString;
            delString = "";
            i = 0;
            J0xC9:

            // End:0xF4 [Loop If]
            if(i < Len(Pass))
            {
                delString = delString $ "*";
                i++;
                // [Loop Continue]
                goto J0xC9;
            }
            Pass = delString;
            delString = "";
            i = 0;
            J0x10E:

            // End:0x139 [Loop If]
            if(i < Len(Id))
            {
                delString = delString $ "*";
                i++;
                // [Loop Continue]
                goto J0x10E;
            }
            Id = delString;
            delString = "";
            i = 0;
            J0x153:

            // End:0x180 [Loop If]
            if(i < Len(string(ncopt)))
            {
                delString = delString $ "0";
                i++;
                // [Loop Continue]
                goto J0x153;
            }
            ncopt = int(delString);
            param = "";
            Id = "";
            Pass = "";
            ncopt = -1;
            // End:0x1F2
            break;
        // End:0x1C4
        case "out":
            RefuseLogin();
            // End:0x1F2
            break;
        // End:0x1EF
        case "openURL":
            URL = GetSystemString(5192);
            OpenGivenURL(URL);
            // End:0x1F2
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string ErrorMsg;

    // End:0x32
    if(Event_ID == 5630)
    {
        // End:0x2F
        if(IsShowWindow() == false)
        {
            ShowWindow();
            FlashInit();
            SendErrorMsg("");
        }        
    }
    else
    {
        // End:0x4A
        if(Event_ID == 5650)
        {
            SendLogInSuccess();            
        }
        else
        {
            // End:0x7E
            if(Event_ID == 5640)
            {
                ParseString(param, "ErrorMsg", ErrorMsg);
                SendErrorMsg(ErrorMsg);
            }
        }
    }
    return;
}

function FlashInit()
{
    local string param;

    param = makeVar2Str("logInID", GetLastLoginID());
    param = param @ (makeVar2Str("isOTP", string(IsUseOTP())));
    param = param @ (makeVar2Str("optMsg", GetSystemMessage(5068)));
    param = param @ (makeVar2Str("isUseEMailAccount", string(IsUseEMailAccount())));
    CallGFxFunction("LogIn", "flashInit", param);
    return;
}

function string makeVar2Str(string varName, string vars)
{
    return (varName $ "=") $ vars;
    return;
}

function SendLogInSuccess()
{
    HideWindow();
    CallGFxFunction("LogIn", "loginSuccess", "");
    return;
}

function SendErrorMsg(string ErrorMsg)
{
    CallGFxFunction("LogIn", "ErrorMsg", ErrorMsg);
    return;
}

event OnMouseOver(WindowHandle W)
{
    return;
}

event OnMouseOut(WindowHandle W)
{
    ForceToMoveMousePos(0.0000000, 0.0000000);
    return;
}
