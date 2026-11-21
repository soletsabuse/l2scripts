class LoginServerSelect extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

var array<int> arrID;
var array<int> arrAgeLimit;
var int currentScreenWidth;
var int currentScreenHeight;
var int selectedServerType;

function int GetCustomServerType(int ServerID)
{
    // End:0x1F
    if((ServerID >= 0) && ServerID <= 10)
    {
        return 3;        
    }
    else
    {
        // End:0x3F
        if((ServerID >= 11) && ServerID <= 20)
        {
            return 2;            
        }
        else
        {
            // End:0x5F
            if((ServerID >= 21) && ServerID <= 30)
            {
                return 4;                
            }
            else
            {
                // End:0x7E
                if((ServerID >= 31) && ServerID <= 40)
                {
                    return 1;                    
                }
                else
                {
                    // End:0x9E
                    if((ServerID >= 41) && ServerID <= 50)
                    {
                        return 5;                        
                    }
                    else
                    {
                        // End:0xBB
                        if((ServerID >= 51) && ServerID <= 60)
                        {
                            return 6;
                        }
                    }
                }
            }
        }
    }
    return 0;
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(5690);
    RegisterEvent(5691);
    RegisterEvent(5692);
    RegisterEvent(2900);
    return;
}

function OnLoad()
{
    RegisterState("loginServerSelect", "SERVERLISTSTATE");
    SetContainer("ContainerHUD");
    SetHUD();
    SetAlwaysOnTop(true);
    SetAnchor("", 9, 1, 0, 0);
    return;
}

function int getLanguageNum()
{
    local UIEventManager.ELanguageType Language;

    Language = GetLanguage();
    return int(Language);
    return;
}

function OnShow()
{
    return;
}

function OnFlashLoaded()
{
    checkWarnimgMode();
    return;
}

function checkWarnimgMode()
{
    local string Msg;

    // End:0x1D
    if((getLanguageNum()) == 0)
    {
        Msg = GetSystemMessage(5070);
    }
    CallGFxFunction("LoginServerSelect", "showWarningMode", Msg);
    return;
}

function OnHide()
{
    return;
}

function OnCallUCFunction(string funcName, string param)
{
    local int severNum;
    local string strParam;

    switch(funcName)
    {
        // End:0x73
        case "selectServer":
            ParseInt(param, "serverNum", severNum);
            FindAge(severNum);
            SetOptionInt("L2", "CustomServerType", GetCustomServerType(severNum));
            RequestLoginServer(severNum);
            // End:0x102
            break;
        // End:0x93
        case "selectServerCancle":
            GotoLogin();
            // End:0x102
            break;
        // End:0xAF
        case "sortServerList":
            RequestSortedServerInfo();
            // End:0x102
            break;
        // End:0xFF
        case "showHelp":
            ParamAdd(strParam, "FilePath", "..\\L2text\\server_help.htm");
            ExecuteEvent(1210, strParam);
            // End:0x102
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function FindAge(int ServerID)
{
    local int i, intAge;
    local string strParam;

    i = 0;
    J0x07:

    // End:0xC9 [Loop If]
    if(i < arrID.Length)
    {
        // End:0xBF
        if(ServerID == arrID[i])
        {
            // End:0x48
            if(arrAgeLimit[i] == 15)
            {
                intAge = 0;                
            }
            else
            {
                // End:0x64
                if(arrAgeLimit[i] == 18)
                {
                    intAge = 1;                    
                }
                else
                {
                    intAge = 1;
                }
            }
            ParamAdd(strParam, "ServerAgeLimit", string(intAge));
            ParamAdd(strParam, "GlobalVersion", string(getLanguageNum()));
            ExecuteEvent(170, strParam);
            // [Explicit Break]
            goto J0xC9;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0xC9:

    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    switch(Event_ID)
    {
        // End:0x5F
        case 5690:
            // End:0x21
            if(IsShowWindow() == false)
            {
                ShowWindow();
            }
            arrID.Length = 0;
            arrAgeLimit.Length = 0;
            selectedServerType = LogInEula(GetScript("LogInEula")).selectedType;
            sendServerListStart();
            // End:0x89
            break;
        // End:0x75
        case 5691:
            handleServerList(a_Param);
            // End:0x89
            break;
        // End:0x86
        case 5692:
            sendServerListEnd();
            // End:0x89
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function handleServerList(string a_Param)
{
    local int Id, AgeLimit, IsWorldRaidServer;

    ParseInt(a_Param, "IsWorldRaidServer", IsWorldRaidServer);
    // End:0x30
    if(IsWorldRaidServer == 1)
    {
        return;
    }
    ParseInt(a_Param, "ID", Id);
    // End:0x68
    if((selectedServerType > 0) && (GetCustomServerType(Id)) != selectedServerType)
    {
        return;
    }
    arrID.Length = arrID.Length + 1;
    arrID[arrID.Length - 1] = Id;
    ParseInt(a_Param, "AgeLimit", AgeLimit);
    arrAgeLimit.Length = arrAgeLimit.Length + 1;
    arrAgeLimit[arrAgeLimit.Length - 1] = AgeLimit;
    CallGFxFunction("LoginServerSelect", "sendServerList", a_Param);
    return;
}

function sendServerListStart()
{
    local string param;

    arrID.Length = 0;
    arrAgeLimit.Length = 0;
    param = makeVar2Str("IsChinaClient", string(IsChinaClient()));
    param = param @ (makeVar2Str("PkString", GetChinaPkString()));
    CallGFxFunction("LoginServerSelect", "sendServerListStart", param);
    return;
}

function string makeVar2Str(string varName, string vars)
{
    return (varName $ "=") $ vars;
    return;
}

function sendServerListEnd()
{
    CallGFxFunction("LoginServerSelect", "sendServerListEnd", "");
    return;
}
