class JobTreeWnd extends L2UIGFxScript;

var int InitClassID;
var int CurrentSubjobClassID;
var int targetCurrentSubjobClassID;

function OnRegisterEvent()
{
    RegisterEvent(980);
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x15
        case 980:
            onTargetUpdate();
        // End:0xFFFF
        default:
            return;
            break;
    }
}

function OnLoad()
{
    AddState("GAMINGSTATE");
    SetContainerWindow("SkinnedWindow", 2704);
    return;
}

function getInitClassID(int currentClassID)
{
    local array<int> EnableClassIndexList;

    Class'NWindow.UIDataManager'.static.GetEnableClassIndexList(currentClassID, EnableClassIndexList);
    InitClassID = EnableClassIndexList[0];
    return;
}

function getTargetCurrentSubjobClassID()
{
    local UserInfo Info;

    // End:0x12
    if(!GetTargetInfo(Info))
    {
        return;
    }
    // End:0x53
    if(Class'NWindow.UIDATA_TARGET'.static.GetTargetID() > 0)
    {
        // End:0x43
        if(Info.bNpc)
        {
            targetCurrentSubjobClassID = -1;            
        }
        else
        {
            targetCurrentSubjobClassID = Info.nSubClass;
        }
    }
    return;
}

function onTargetUpdate()
{
    local string currentWndName;

    getTargetCurrentSubjobClassID();
    currentWndName = getCurrentWindowName(string(self));
    // End:0x27
    if(!IsShowWindow(currentWndName))
    {
        return;
    }
    CallGFxFunction(currentWndName, "changeTargetClassID", "");
    return;
}

function getCurrentSubjobClassID()
{
    local UserInfo UserInfo;

    // End:0x12
    if(!GetPlayerInfo(UserInfo))
    {
        return;
    }
    CurrentSubjobClassID = UserInfo.nSubClass;
    return;
}

function OnCallUCFunction(string funcName, string param)
{
    switch(funcName)
    {
        // End:0x2A
        case "getInitClassID":
            getInitClassID(int(param));
            // End:0xA0
            break;
        // End:0x4F
        case "getCurrentSubjobClassID":
            getCurrentSubjobClassID();
            // End:0xA0
            break;
        // End:0x7A
        case "getTargetCurrentSubjobClassID":
            getTargetCurrentSubjobClassID();
            // End:0xA0
            break;
        // End:0x9D
        case "ucExecuteCommand":
            ucExecuteCommand(param);
            // End:0xA0
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ucExecuteCommand(string param)
{
    Debug("ucExecuteCommand" @ param);
    // End:0x2D
    if(param == "")
    {
        return;
    }
    ExecuteCommand(param);
    return;
}
