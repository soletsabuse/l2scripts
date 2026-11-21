class InstancedZoneHistoryWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterEvent(5860);
    return;
}

function OnLoad()
{
    SetContainerWindow("SkinnedWindow", 2668);
    AddState("GAMINGSTATE");
    return;
}

function OnCallUCFunction(string logicID, string param)
{
    switch(logicID)
    {
        // End:0x2D
        case "RequestInzoneWaitingTime":
            RequestInzoneWaitingTime();
            // End:0x30
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local int nShowWindow;

    switch(a_EventID)
    {
        // End:0x6B
        case 5860:
            ParseInt(a_Param, "ShowWindow", nShowWindow);
            // End:0x68
            if(nShowWindow > 0)
            {
                a_Param = handleInzoneWaitingInfo(a_Param);
                CallGFxFunction(getCurrentWindowName(string(self)), "WaitingInfo", a_Param);
            }
            // End:0x6E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function string handleInzoneWaitingInfo(string param)
{
    local int currentInzoneID, sizeOfBlockedInzone, blockedInzoneID, blockedInzoneLeftSeconds;
    local string currentInzoneName, blockedInzoneName, LeftTime;
    local int i;
    local string strParam;

    ParseInt(param, "currentInzoneID", currentInzoneID);
    currentInzoneName = GetInZoneNameWithZoneID(currentInzoneID);
    // End:0x57
    if(currentInzoneName == "Invalid inzone ID")
    {
        currentInzoneName = "";
    }
    ParamAdd(strParam, "currentInzoneName", currentInzoneName);
    ParseInt(param, "sizeOfBlockedInzone", sizeOfBlockedInzone);
    ParamAdd(strParam, "sizeOfBlockedInzone", string(sizeOfBlockedInzone));
    i = 0;
    J0xCD:

    // End:0x1F6 [Loop If]
    if(i < sizeOfBlockedInzone)
    {
        ParseInt(param, "blockedInzoneID_" $ string(i), blockedInzoneID);
        ParseInt(param, "blockedInzoneLeftSeconds_" $ string(i), blockedInzoneLeftSeconds);
        blockedInzoneName = GetInZoneNameWithZoneID(blockedInzoneID);
        LeftTime = setTimeString(blockedInzoneLeftSeconds);
        ParamAdd(strParam, "blockedInzoneName_" $ string(i), blockedInzoneName);
        ParamAdd(strParam, "blockedInzoneTimeString_" $ string(i), LeftTime);
        ParamAdd(strParam, "blockedInzoneTime_" $ string(i), string(blockedInzoneLeftSeconds));
        i++;
        // [Loop Continue]
        goto J0xCD;
    }
    return strParam;
    return;
}

function string setTimeString(int tmpTime)
{
    local string timeStr;
    local int timeHour, timeMin;

    // End:0x45
    if(tmpTime < 60)
    {
        timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(1));
        timeStr = MakeFullSystemMsg(GetSystemMessage(3408), timeStr);        
    }
    else
    {
        // End:0x84
        if(tmpTime < 3600)
        {
            tmpTime = tmpTime / 60;
            timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(tmpTime));            
        }
        else
        {
            timeHour = tmpTime / 3600;
            timeMin = (tmpTime - (timeHour * 3600)) / 60;
            // End:0xF9
            if(timeMin > 0)
            {
                timeStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeHour)) @ MakeFullSystemMsg(GetSystemMessage(3390), string(timeMin));                
            }
            else
            {
                timeStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeHour));
            }
        }
    }
    return timeStr;
    return;
}
