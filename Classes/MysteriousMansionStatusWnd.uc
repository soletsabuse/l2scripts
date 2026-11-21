class MysteriousMansionStatusWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9340);
    RegisterGFxEvent(9341);
    RegisterGFxEvent(9350);
    RegisterGFxEvent(9342);
    RegisterEvent(9360);
    RegisterGFxEvent(9330);
    return;
}

function OnLoad()
{
    RegisterState("MysteriousMansionStatusWnd", "GamingState");
    SetContainerWindow("SimpleDragWindow", 0);
    AddState("GAMINGSTATE");
    return;
}

function OnDefaultPosition()
{
    CallGFxFunction(getCurrentWindowName(string(self)), "OnDefaultPosition", "");
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    local int ServerID;
    local UserInfo UserInfo;

    ServerID = int(param);
    switch(functionName)
    {
        // End:0x5C
        case "targetAction":
            // End:0x59
            if(ServerID != -1)
            {
                // End:0x59
                if(GetPlayerInfo(UserInfo))
                {
                    RequestAction(int(param), UserInfo.loc);
                }
            }
            // End:0x5F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 9360:
            handleRemainTime(a_Param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function handleRemainTime(string a_Param)
{
    local string strParam;
    local int RemainTimeInSec;

    ParseInt(a_Param, "RemainTimeInSec", RemainTimeInSec);
    ParamAdd(strParam, "EventID", string(4));
    ParamAdd(strParam, "Param2", string(RemainTimeInSec));
    ParamAdd(strParam, "Param4", GetSystemString(1108));
    ExecuteEvent(3550, strParam);
    return;
}
