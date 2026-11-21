class LogInLoading extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

var array<GFxValue> args;
var GFxValue invokeResult;
var int CurrEventID;
var L2Util util;

function OnRegisterEvent()
{
    RegisterEvent(5660);
    RegisterEvent(5661);
    RegisterEvent(5670);
    RegisterEvent(5671);
    RegisterEvent(3410);
    return;
}

function OnLoad()
{
    RegisterState("LogInLoading", "LOGINWAITSTATE");
    RegisterState("LogInLoading", "TelephoneAuthState");
    SetAnchor("", 9, 1, 0, 0);
    SetContainer("ContainerHUD");
    SetAlwaysOnTop(true);
    CurrEventID = 0;
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
    local string cardNum;

    // End:0x51
    if(logicID == "0")
    {
        ParseString(param, "cardNum", cardNum);
        // End:0x43
        if(CurrEventID == 5671)
        {
            RequestGoogleOtpLogin(cardNum);            
        }
        else
        {
            RequestSecurityCardLogin(param);
        }        
    }
    else
    {
        // End:0x7F
        if(logicID == "1")
        {
            // End:0x76
            if(CurrEventID == 5671)
            {
                RequestExit();                
            }
            else
            {
                RequestCardKeyLoginCancel();
            }            
        }
        else
        {
            // End:0x92
            if(logicID == "2")
            {
                StopLogin();
            }
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x2F
    if(Event_ID == 5660)
    {
        // End:0x2C
        if(IsShowWindow() == false)
        {
            ShowWindow();
            SendLoading(param);
        }        
    }
    else
    {
        // End:0x5B
        if(Event_ID == 5661)
        {
            // End:0x5B
            if(IsShowWindow() == false)
            {
                ShowWindow();
                SendTelephoneWait(param);
            }
        }
    }
    // End:0x87
    if(Event_ID == 5670)
    {
        // End:0x87
        if(IsShowWindow() == false)
        {
            ShowWindow();
            SendSecurityCard(param);
        }
    }
    // End:0xB2
    if(Event_ID == 5671)
    {
        CurrEventID = Event_ID;
        ShowWindow();
        SendSecurityCard(param);
    }
    // End:0xF7
    if(Event_ID == 3410)
    {
        CallGFxFunction("LogInLoading", "StateChange", "state=" $ param);
        HideWindow();
    }
    return;
}

function SendLoading(string param)
{
    local string Msg;

    ParseString(param, "WaitMsg", Msg);
    CallGFxFunction("LogInLoading", "SendLoading", "eventID=0 msg=" $ Msg);
    return;
}

function SendTelephoneWait(string param)
{
    local string Msg;

    ParseString(param, "WaitMsg", Msg);
    CallGFxFunction("LogInLoading", "SendTelephoneWait", "eventID=5 msg=" $ Msg);
    return;
}

function SendSecurityCard(string param)
{
    local string Msg;

    ParseString(param, "msg", Msg);
    CallGFxFunction("LogInLoading", "SendSecurityCard", "eventID=10 msg=" $ Msg);
    return;
}
