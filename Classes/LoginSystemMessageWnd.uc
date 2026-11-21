class LoginSystemMessageWnd extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

var bool isFlashLoaded;
var array<string> stateArr;

function OnRegisterEvent()
{
    RegisterEvent(3410);
    RegisterEvent(581);
    RegisterEvent(9740);
    return;
}

function OnLoad()
{
    local int i;

    SetAnchor("", 9, 1, 0, 0);
    stateArr[0] = "PIAGREEMENTSTATE";
    stateArr[1] = "EULAMSGSTATE";
    stateArr[2] = "SERVERLISTSTATE";
    stateArr[3] = "CHARACTERSELECTSTATE";
    stateArr[4] = "CHARACTERCREATESTATE";
    i = 0;
    J0x9D:

    // End:0xDF [Loop If]
    if(i < stateArr.Length)
    {
        RegisterState("loginSystemMessageWnd", stateArr[i]);
        i++;
        // [Loop Continue]
        goto J0x9D;
    }
    SetHavingFocus(false);
    SetHUD();
    SetContainer("ContainerHUD");
    SetDefaultShow(true);
    SetAlwaysFullAlpha(true);
    SetMsgPassThrough(true);
    isFlashLoaded = false;
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

function beforeFlashLoadedEvent()
{
    return;
}

function OnHide()
{
    return;
}

function handleShowMessage(string systemMessage)
{
    dispatchEventToFlash_String(3, systemMessage);
    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    local string Msg;

    switch(Event_ID)
    {
        // End:0x1D
        case 3410:
            HandleStateChange(a_Param);
            // End:0x65
            break;
        // End:0x4C
        case 581:
            ParseString(a_Param, "Message", Msg);
            handleShowMessage(Msg);
            // End:0x65
            break;
        // End:0x62
        case 9740:
            handleShowDeleteFail(a_Param);
            // End:0x65
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function handleShowDeleteFail(string a_Param)
{
    local int Type, msgInt;
    local string systemMessage;

    ParseInt(a_Param, "type", Type);
    switch(Type)
    {
        // End:0x29
        case int(0):
            return;
            // End:0xBF
            break;
        // End:0x3E
        case int(1):
            msgInt = 306;
            // End:0xBF
            break;
        // End:0x53
        case int(2):
            msgInt = 541;
            // End:0xBF
            break;
        // End:0x68
        case int(3):
            msgInt = 540;
            // End:0xBF
            break;
        // End:0x7D
        case int(4):
            msgInt = 3091;
            // End:0xBF
            break;
        // End:0x92
        case int(5):
            msgInt = 3529;
            // End:0xBF
            break;
        // End:0xA7
        case int(6):
            msgInt = 3716;
            // End:0xBF
            break;
        // End:0xBC
        case int(8):
            msgInt = 4198;
            // End:0xBF
            break;
        // End:0xFFFF
        default:
            break;
    }
    systemMessage = GetSystemMessage(msgInt);
    dispatchEventToFlash_String(3, systemMessage);
    return;
}

function HandleStateChange(string a_Param)
{
    local int stateNum, titleSystemInt[5];

    titleSystemInt[0] = 2686;
    titleSystemInt[1] = 2686;
    titleSystemInt[2] = 2693;
    titleSystemInt[3] = 157;
    titleSystemInt[4] = 158;
    stateNum = chkState(a_Param);
    // End:0x73
    if(stateNum != -1)
    {
        dispatchEventToFlash_Int(1, titleSystemInt[stateNum]);        
    }
    else
    {
        dispatchEventToFlash_Int(2, -1);
    }
    return;
}

function int chkState(string State)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x3C [Loop If]
    if(i < stateArr.Length)
    {
        // End:0x32
        if(State == stateArr[i])
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function handleShowKindOfAccount(string a_Param)
{
    local int premiumLevel, kindOfAccount[20];

    kindOfAccount[0] = 5097;
    kindOfAccount[1] = 5098;
    ParseInt(a_Param, "premiumLevel", premiumLevel);
    dispatchEventToFlash_Int(4, kindOfAccount[premiumLevel]);
    return;
}

function dispatchEventToFlash_String(int Event_ID, string argString)
{
    CallGFxFunction("LoginSystemMessageWnd", "logSystemMsgFunc", (("eventID=" $ string(Event_ID)) @ "string=") $ argString);
    return;
}

function dispatchEventToFlash_Int(int Event_ID, int argInt)
{
    CallGFxFunction("LoginSystemMessageWnd", "logSystemMsgFunc", (("eventID=" $ string(Event_ID)) @ "num=") $ string(argInt));
    return;
}
