class UIData extends UICommonAPI;

const NEW_PARTY_MAXCOUNT = 7;
const MAXLV2DISPLAY = 85;
const HUNTINGZONE_MAXCOUNT = 500;
const RAID_MAXCOUNT = 500;
const ROLETYPEMAX = 9;

var int currentScreenWidth;
var int currentScreenHeight;
var string roleTypeStr;
var string classDescription;
var UserInfo prevUserInfo;
var UserInfo currUserInfo;
var int MAXLV;
var INT64 adenaCount;
var int pcCafePoint;
var int clanNameValue;
var int tmpDataInt;
var string tmpDataString;
var bool tmpDataBoolean;

function OnLoad()
{
    updateCurrentResolution();
    MAXLV = GetMaxLevel();
    return;
}

function INT64 getMaxAdena()
{
    return ("999999999999");
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(2900);
    RegisterEvent(8000);
    RegisterEvent(1910);
    RegisterEvent(180);
    RegisterEvent(320);
    RegisterEvent(182);
    return;
}

function bool getIsLiveServer()
{
    return GetServerType() == 1;
    return;
}

function bool getIsClassicServer()
{
    return GetServerType() == 2;
    return;
}

function bool getIsArenaServer()
{
    return GetServerType() == 3;
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x18
        case 2900:
            updateCurrentResolution();
            // End:0x7D
            break;
        // End:0x3D
        case 8000:
            MAXLV = GetMaxLevel();
            clanNameValue = 0;
            pcCafePoint = 0;
            // End:0x7D
            break;
        // End:0x53
        case 1910:
            pcCafePointInfoHandler(param);
            // End:0x7D
            break;
        // End:0x69
        case 320:
            updateClanInfoHandler(param);
            // End:0x7D
            break;
        // End:0x77
        case 182:
            swapPrevUserInfo();
            // End:0x7D
            break;
        // End:0xFFFF
        default:
            // End:0x7D
            break;
            break;
    }
    return;
}

function swapPrevUserInfo()
{
    prevUserInfo = currUserInfo;
    GetPlayerInfo(currUserInfo);
    return;
}

function bool isPawnChanged()
{
    return prevUserInfo.m_bPawnChanged != currUserInfo.m_bPawnChanged;
    return;
}

function bool isMount()
{
    // End:0x10
    if(currUserInfo.m_bPawnChanged)
    {
        return false;
    }
    return (prevUserInfo.nTransformID == 0) && currUserInfo.nTransformID > 0;
    return;
}

function bool isDismoust()
{
    // End:0x10
    if(currUserInfo.m_bPawnChanged)
    {
        return false;
    }
    return (prevUserInfo.nTransformID > 0) && currUserInfo.nTransformID == 0;
    return;
}

function bool isLevelUP()
{
    return prevUserInfo.nLevel < currUserInfo.nLevel;
    return;
}

function bool isLevelDown()
{
    return prevUserInfo.nLevel > currUserInfo.nLevel;
    return;
}

function updateClanInfoHandler(string param)
{
    ParseInt(param, "ClanNameValue", clanNameValue);
    return;
}

function pcCafePointInfoHandler(string param)
{
    ParseInt(param, "TotalPoint", pcCafePoint);
    return;
}

function int getCurrentClanNameValue()
{
    return clanNameValue;
    return;
}

function int getCurrentPcCafePoint()
{
    return pcCafePoint;
    return;
}

function setPcCafePoint(int point)
{
    pcCafePoint = point;
    return;
}

function setCurrentClanNameValue(int point)
{
    clanNameValue = point;
    return;
}

function updateCurrentResolution()
{
    GetCurrentResolution(currentScreenWidth, currentScreenHeight);
    return;
}

function int getScreenWidth()
{
    // End:0x11
    if(currentScreenWidth <= 0)
    {
        updateCurrentResolution();
    }
    return currentScreenWidth;
    return;
}

function int getScreenHeight()
{
    // End:0x11
    if(currentScreenWidth <= 0)
    {
        updateCurrentResolution();
    }
    return currentScreenHeight;
    return;
}

function setRoleTypeStr(int ClassID)
{
    roleTypeStr = GetClassRoleName(ClassID);
    return;
}

function OnCallUCFunction(string Id, string param)
{
    switch(Id)
    {
        // End:0x2A
        case "setRoleTypeStr":
            setRoleTypeStr(int(param));
            // End:0x96
            break;
        // End:0x58
        case "GetClassDescription":
            classDescription = GetClassDescription(int(param));
            // End:0x96
            break;
        // End:0x74
        case "setUCData":
            tmpDataString = param;
            // End:0x96
            break;
        // End:0x90
        case "getUCData":
            getData(param);
            // End:0x96
            break;
        // End:0xFFFF
        default:
            // End:0x96
            break;
            break;
    }
    return;
}

function getData(string DataName)
{
    switch(DataName)
    {
        // End:0x28
        case "GameStateName":
            tmpDataString = GetGameStateName();
            // End:0x1FB
            break;
        // End:0x44
        case "nNobless":
            tmpDataInt = getMyNobless();
            // End:0x1FB
            break;
        // End:0x5E
        case "bHero":
            tmpDataBoolean = getbHero();
            // End:0x1FB
            break;
        // End:0x85
        case "roleIconName":
            tmpDataString = GetClassRoleIconName(int(tmpDataString));
            // End:0x1FB
            break;
        // End:0xB1
        case "arenaRoleIconName":
            tmpDataString = GetClassArenaRoleIconName(int(tmpDataString));
            // End:0x1FB
            break;
        // End:0xE3
        case "ClassRoleNameByRole":
            tmpDataString = GetClassRoleNameByRole(int(byte(int(tmpDataString))));
            // End:0x1FB
            break;
        // End:0x112
        case "GetUserName":
            tmpDataString = Class'NWindow.UIDATA_USER'.static.GetUserName(int(tmpDataString));
            // End:0x1FB
            break;
        // End:0x143
        case "GetPartyMemberLocationWithID":
            setGetPartyMemberLocationWithID(int(tmpDataString));
            // End:0x1FB
            break;
        // End:0x175
        case "GetItemNameAllBySeverID":
            tmpDataString = GetItemNameAllBySeverID(int(tmpDataString));
            // End:0x1FB
            break;
        // End:0x1A7
        case "GetItemGradeTextureName":
            tmpDataString = GetItemGradeTextureName(int(tmpDataString));
            // End:0x1FB
            break;
        // End:0x1CC
        case "GetIsFriend":
            tmpDataBoolean = isFriend(tmpDataString);
            // End:0x1FB
            break;
        // End:0x1F5
        case "GetUIUserPremiumLevel":
            tmpDataInt = GetUIUserPremiumLevel();
            // End:0x1FB
            break;
        // End:0xFFFF
        default:
            // End:0x1FB
            break;
            break;
    }
    return;
}

function bool isFriend(string Name)
{
    local PersonalConnectionsWnd personalConnectionsWndScript;
    local L2Util l2utilScript;

    personalConnectionsWndScript = PersonalConnectionsWnd(GetScript("PersonalConnectionsWnd"));
    l2utilScript = L2Util(GetScript("L2Util"));
    return l2utilScript.ctrlListSearchByName(personalConnectionsWndScript.FriendList, Name) != -1;
    return;
}

function setGetPartyMemberLocationWithID(int a_PartyMemberSID)
{
    local Vector a_Location;

    // End:0x6B
    if(GetPartyMemberLocationWithID(int(tmpDataString), a_Location))
    {
        tmpDataString = "";
        ParamAdd(tmpDataString, "x", string(a_Location.X));
        ParamAdd(tmpDataString, "y", string(a_Location.Y));
        ParamAdd(tmpDataString, "z", string(a_Location.Z));
    }
    return;
}

function int getMyNobless()
{
    local UserInfo Info;

    // End:0x16
    if(!GetPlayerInfo(Info))
    {
        return -1;
    }
    return Info.nNobless;
    return;
}

function bool getbHero()
{
    local UserInfo Info;

    // End:0x12
    if(!GetPlayerInfo(Info))
    {
        return false;
    }
    return Info.bHero;
    return;
}
