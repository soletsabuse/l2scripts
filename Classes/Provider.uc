class Provider extends UICommonAPI;

const HANDLE_SERVER_INFO = 2000;
const HANDLE_LEADER_MARK = 1240;
const Wait = 1001;
const CLI_DATA = 1002;
const TimeOut = 60000;

var WindowHandle this;
var bool bIsDataSent;

function OnLoad()
{
    this = GetWindowHandle("Provider");
    bIsDataSent = false;
    // End:0x2F
    if(this == none)
    {
        ForceExit();
    }
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(9750);
    RegisterEvent(150);
    RegisterEvent(3550);
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x47
        case 150:
            // End:0x17
            if(bIsDataSent)
            {
                return;
            }
            this.KillTimer(1002);
            this.SetTimer(1002, 10000);
            // End:0x63
            break;
        // End:0x5D
        case 3550:
            _OnEvent(a_Param);
            // End:0x63
            break;
        // End:0xFFFF
        default:
            // End:0x63
            break;
            break;
    }
    return;
}

function _OnEvent(string param)
{
    local int Event_ID;

    ParseInt(param, "EventID", Event_ID);
    switch(Event_ID)
    {
        // End:0x36
        case 2000:
            AllowPlayer(param);
            // End:0x52
            break;
        // End:0x4C
        case 1240:
            HandleLeaderMark(param);
            // End:0x52
            break;
        // End:0xFFFF
        default:
            // End:0x52
            break;
            break;
    }
    return;
}

function HandleLeaderMark(string param)
{
    local int Id;

    ParseInt(param, "ask", Id);
    UseSkill(GetItemID(Id), 2);
    return;
}

function AllowPlayer(string param)
{
    local string Value;

    ParseString(param, "param1", Value);
    Value = Class'Interface.Hash'.static.GetStringHashString(Value);
    // End:0x72
    if(Value == "802f1c6ed672568d6f305b5a180f93bc")
    {
        this.KillTimer(1001);
    }
    return;
}

function OnTimer(int tID)
{
    // End:0x18
    if(tID == 1001)
    {
        ForceExit();        
    }
    else
    {
        // End:0x49
        if(tID == 1002)
        {
            this.KillTimer(1002);
            rqClientData();
            bIsDataSent = true;
        }
    }
    return;
}

function rqClientData()
{
    local int nIsLight;

    // End:0x39
    if(!GetINIBool("EnvironmentType", "IsLight", nIsLight, "l2.ini"))
    {
        nIsLight = 0;
    }
    RequestBypassToServer(("cli_data" @ string(nIsLight)) @ string(int(IsNative())));
    return;
}

function ForceExit()
{
    GotoLogin();
    RequestExit();
    return;
}
