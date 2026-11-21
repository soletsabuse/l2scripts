class ClanSearchAPI extends PacketsInfo;

const LIST_ALL = 100;
const MAX_MULTIEDIT_SIZE = 100;
const MAX_REQUESTORS = 50;
const SORT_MAX = 7;
const ACADEMY = -1;
const FREE_INVITE_DIALOG_ID = 1111220;

enum eSort
{
    Asc,                            // 0
    Desc                            // 1
};

enum eSortType
{
    Name,                           // 0
    Leader,                         // 1
    Level,                          // 2
    KNIGHTHOOD_TYPE,                // 3
    MEMBER_COUNT,                   // 4
    FRIENDSHIP_TYPE,                // 5
    INVITE_TYPE                     // 6
};

enum eAcademySortType
{
    Name,                           // 0
    Leader,                         // 1
    Level,                          // 2
    NOT_USED,                       // 3
    MEMBER_COUNT,                   // 4
    INVITE_TYPE,                    // 5
    Price                           // 6
};

enum eWindowState
{
    WS_CLAN,                        // 0
    WS_ACADEMY,                     // 1
    WS_MYCLAN                       // 2
};

enum eMyListState
{
    MLS_ADD,                        // 0
    MLS_CHANGE                      // 1
};

enum eClanSearchFriendshipType
{
    CST_PVP,                        // 0
    CST_PVE,                        // 1
    CST_PVPPVE,                     // 2
    CST_RELAX,                      // 3
    CST_MAX                         // 4
};

enum eSearchState
{
    ST_BY_CLAN_NAME,                // 0
    ST_BY_CLAN_LEADER_NAME          // 1
};

enum eClanRequestType
{
    CRT_REQUEST,                    // 0
    CRT_FREE,                       // 1
    CRT_MAX                         // 2
};

enum eAskJoinState
{
    AJS_OPEN,                       // 0
    AJS_WRITE,                      // 1
    AJS_REMOVE_REQUEST,             // 2
    AJS_MYCLAN                      // 3
};

enum eRequestorAction
{
    RA_DECLINE,                     // 0
    RA_JOIN                         // 1
};

enum eHeadTab
{
    HT_CLANS,                       // 0
    HT_ACADEMY,                     // 1
    HT_MYCLAN                       // 2
};

struct sClanListInfo
{
    var int nAskJoinRequestClanId;
    var int nAskJoinRequestAcademyId;
    var string askJoinRequestClanAbout;
    var string askJoinRequestAcademyAbout;
    var INT64 askJoinAcademyPrice;
};

struct sClanListData
{
    var int clanID;
    var int allyId;
    var string ClanName;
    var string alyName;
    var string LeaderName;
    var int knighthood;
    var int Level;
    var int Count;
    var ClanSearchAPI.eClanSearchFriendshipType clanType;
    var ClanSearchAPI.eClanRequestType clanRequestType;
    var int baseId;
    var int hallId;
    var int ServerID;
    var int cIconId;
    var int aIconId;
};

struct sAcademyListData
{
    var int clanID;
    var int allyId;
    var string ClanName;
    var string alyName;
    var string LeaderName;
    var int Level;
    var int Count;
    var ClanSearchAPI.eClanRequestType clanRequestType;
    var int baseId;
    var int hallId;
    var INT64 academyPrice;
    var int ServerID;
    var int cIconId;
    var int aIconId;
};

struct sSocials
{
    var string tg;
    var string ds;
};

struct sClanListDetailData
{
    var int Position;
    var int reputation;
    var int averageLevel;
    var int pvp;
    var int pk;
    var int nNobles;
    var int nHeroes;
    var string Description;
    var sSocials Socials;
};

struct sClanWarListData
{
    var string ClanName;
    var int State;
    var int progressTimeInSec;
    var int point;
    var int pointDiff;
    var int leftKillCountOfEnemyToWar;
};

struct sRequestor
{
    var string Name;
    var int objId;
    var int ClassID;
    var int Level;
    var bool bIsAcademyRequest;
};

var sClanListInfo ClanListInfo;
var array<sClanListData> ClanListData;
var array<sAcademyListData> AcademyListData;
var sClanListDetailData ClanListDetailInfo;

function string getFriendShipTypeString(ClanSearchAPI.eClanSearchFriendshipType Type)
{
    switch(Type)
    {
        // End:0x18
        case 0:
            return GetSystemString(8001);
        // End:0x29
        case 1:
            return GetSystemString(8002);
        // End:0x3A
        case 2:
            return GetSystemString(8003);
        // End:0x4B
        case 3:
            return GetSystemString(8004);
        // End:0xFFFF
        default:
            // End:0x51
            break;
            break;
    }
    return;
}

function Color GetFriendshipTypeColor(ClanSearchAPI.eClanSearchFriendshipType Type)
{
    switch(Type)
    {
        // End:0x1B
        case 1:
            return GetColor(100, 220, 160, 255);
        // End:0x2F
        case 0:
            return GetColor(255, 110, 110, 255);
        // End:0x43
        case 2:
            return GetColor(180, 140, 255, 255);
        // End:0x57
        case 3:
            return GetColor(255, 210, 120, 255);
        // End:0xFFFF
        default:
            return GetColor(180, 180, 180, 255);
            break;
    }    
    return;
}

function string getInviteTypeString(ClanSearchAPI.eClanRequestType Type)
{
    switch(Type)
    {
        // End:0x18
        case 0:
            return GetSystemString(8005);
        // End:0x29
        case 1:
            return GetSystemString(8006);
        // End:0xFFFF
        default:
            // End:0x2F
            break;
            break;
    }
    return;
}

function Color GetInviteTypeColor(ClanSearchAPI.eClanRequestType Type)
{
    switch(Type)
    {
        // End:0x1B
        case 0:
            return GetColor(135, 100, 255, 255);
        // End:0x2F
        case 1:
            return GetColor(100, 220, 160, 255);
        // End:0xFFFF
        default:
            return GetColor(160, 160, 160, 255);
            break;
    }    
    return;
}

function bool getImClanLeader()
{
    local ClanWnd Clan;
    local UserInfo Player;

    GetPlayerInfo(Player);
    Clan = ClanWnd(GetScript("ClanWnd"));
    return Player.Name == Class'NWindow.UIAPI_TEXTBOX'.static.GetText("ClanWnd.ClanMasterNameText");
    return;
}

function bool getImAcademyUser()
{
    local UserInfo Player;

    GetPlayerInfo(Player);
    // End:0x1E
    if(Player.nLevel > 40)
    {
        return false;
    }
    // End:0x36
    if(GetClassTransferDegree(Player.nSubClass) > 1)
    {
        return false;
    }
    // End:0x48
    if(Player.nClanID > 0)
    {
        return false;
    }
    return true;
    return;
}

function bool getIsMyClan(int nClanID)
{
    local UserInfo Player;

    GetPlayerInfo(Player);
    return Player.nClanID == nClanID;
    return;
}

function int getKnighthoodToIndex(int nKnighthood)
{
    switch(nKnighthood)
    {
        // End:0x0D
        case 0:
            return 0;
        // End:0x14
        case 100:
            return 1;
        // End:0x1C
        case 200:
            return 2;
        // End:0x27
        case 1001:
            return 3;
        // End:0x32
        case 1002:
            return 4;
        // End:0x3D
        case 2001:
            return 5;
        // End:0x48
        case 2002:
            return 6;
        // End:0x53
        case -1:
            return 7;
        // End:0xFFFF
        default:
            // End:0x59
            break;
            break;
    }
    return;
}

function string GetClanTypeNameFromIndex(int Index)
{
    local string Type;

    // End:0x1C
    if(Index == 0)
    {
        Type = GetSystemString(1399);
    }
    // End:0x39
    if(Index == 100)
    {
        Type = GetSystemString(1400);
    }
    // End:0x56
    if(Index == 200)
    {
        Type = GetSystemString(1401);
    }
    // End:0x76
    if(Index == 1001)
    {
        Type = GetSystemString(1402);
    }
    // End:0x96
    if(Index == 1002)
    {
        Type = GetSystemString(1403);
    }
    // End:0xB6
    if(Index == 2001)
    {
        Type = GetSystemString(1404);
    }
    // End:0xD6
    if(Index == 2002)
    {
        Type = GetSystemString(1405);
    }
    // End:0xF6
    if(Index == -1)
    {
        Type = GetSystemString(1452);
    }
    return Type;
    return;
}

function evRqClanSearchSystem(int nPage, int clanLv, int clanType, int sortType, int nSort, int searchType, string LINE)
{
    RequestBypassToServer((((((("clanSearch Open" @ string(nPage)) @ string(clanLv)) @ string(clanType)) @ string(sortType)) @ string(nSort)) @ string(searchType)) @ LINE);
    return;
}

function evRqClanSearchSystem_a(int nPage, int clanLv, int clanType, int sortType, int nSort, int searchType, string LINE)
{
    RequestBypassToServer((((((("clanSearch OpenA" @ string(nPage)) @ string(clanLv)) @ string(clanType)) @ string(sortType)) @ string(nSort)) @ string(searchType)) @ LINE);
    return;
}

function evRqClanSearchSystemDetail(int clanID)
{
    RequestBypassToServer("clanSearch Detail" @ string(clanID));
    return;
}

function evRqClanSearchSystemDetailA(int clanID)
{
    RequestBypassToServer("clanSearch DetailA" @ string(clanID));
    return;
}

function evRqClanSearchSystemClanJoin(int clanID)
{
    RequestBypassToServer("clanSearch Join" @ string(clanID));
    return;
}

function evRqClanSearchSystemAcademyJoin(int clanID)
{
    RequestBypassToServer("clanSearch JoinA" @ string(clanID));
    return;
}

function evRqClanSearchSystemClanAskJoin(int clanID, string about)
{
    RequestBypassToServer(("clanSearch AskJoin" @ string(clanID)) @ about);
    return;
}

function evRqClanSearchSystemAcademyAskJoin(int clanID, string about)
{
    RequestBypassToServer(("clanSearch AskJoinA" @ string(clanID)) @ about);
    return;
}

function evRqClanSearchSystemClanCancelAskJoin(int clanID)
{
    RequestBypassToServer("clanSearch CancelJoin" @ string(clanID));
    return;
}

function evRqClanSearchSystemAcademyCancelAskJoin(int clanID)
{
    RequestBypassToServer("clanSearch CancelJoinA" @ string(clanID));
    return;
}

function evRqClanSearchSystemClanWar(int nPage, int clanID)
{
    RequestBypassToServer(("clanSearch ClanWar" @ string(nPage)) @ string(clanID));
    return;
}

function evRqClanSearchSystemClanSkill(int clanID)
{
    RequestBypassToServer("clanSearch ClanSkill" @ string(clanID));
    return;
}

function evRqClanSearchSystemClanList(int nPage, int clanID)
{
    RequestBypassToServer(("clanSearch ClanList" @ string(nPage)) @ string(clanID));
    return;
}

function evRqClanSearchMyClanInfo()
{
    RequestBypassToServer("clanSearch MyInfo");
    return;
}

function evRqClanSearchMyAcademyInfo()
{
    RequestBypassToServer("clanSearch MyInfoA");
    return;
}

function evRqClanSearchMyClanInfoRequestorAbout(int requestorId)
{
    RequestBypassToServer("clanSearch RqInfo" @ string(requestorId));
    return;
}

function evRqClanSearchMyClanInfoRequestorAction(int requestorId, int nResult)
{
    RequestBypassToServer(("clanSearch AskJoinResult" @ string(requestorId)) @ string(nResult));
    return;
}

function evRqClanSearchMyClanAdd(int clanType, int inviteType, int knighthood, string tgName, string dsName, string about)
{
    RequestBypassToServer(((((("clanSearch MyClanAdd" @ string(clanType)) @ string(inviteType)) @ string(knighthood)) @ tgName) @ dsName) @ about);
    return;
}

function evRqClanSearchMyAcademyAdd(int inviteType, string Price, string about)
{
    RequestBypassToServer((("clanSearch MyAcademyAdd" @ string(inviteType)) @ Price) @ about);
    return;
}

function evRqClanSearchMyClanRemove()
{
    RequestBypassToServer("clanSearch MyClanRemove");
    return;
}

function evRqClanSearchMyAcademyRemove()
{
    RequestBypassToServer("clanSearch MyAcademyRemove");
    return;
}

function getMyClanInfo()
{
    Class'NWindow.UIDATA_CLAN'.static.RequestClanInfo();
    return;
}

function string getCurrentName()
{
    local UserInfo P;

    GetPlayerInfo(P);
    return P.Name;
    return;
}

function array<string> getEmptyArray()
{
    local array<string> tmp;

    return tmp;
    return;
}
