class UIConstants extends UIScript;

enum CrystalType
{
    CRT_NONE,                       // 0
    CRT_D,                          // 1
    CRT_C,                          // 2
    CRT_B,                          // 3
    CRT_A,                          // 4
    CRT_S,                          // 5
    CRT_S80,                        // 6
    CRT_S84,                        // 7
    CRT_R,                          // 8
    CRT_R95,                        // 9
    CRT_R99,                        // 10
    CRT_EVENT                       // 11
};

enum HuntingZoneType
{
    DOMINION,                       // 0
    FIELD_HUNTING_ZONE_SOLO,        // 1
    FIELD_HUNTING_ZONE_PARTY,       // 2
    INSTANCE_ZONE_SOLO,             // 3
    INSTANCE_ZONE_PARTY,            // 4
    Agit,                           // 5
    VILLAGE,                        // 6
    etc,                            // 7
    CASTLE,                         // 8
    FORTRESS,                       // 9
    FIELD_HUNTING_ZONE_PARTYWITH_SOLO,// 10
    FIELD_HUNTING_ZONE_OUT_OF_USE,  // 11
    Max                             // 12
};

enum MapServerInfoType
{
    SIEGEWARFARE,                   // 0
    SIEGEWARFARE_DIMENSION,         // 1
    RAID_DIMENSION,                 // 2
    CURSEDWEAPON_MAGICAL,           // 3
    CURSEDWEAPON_BLOOD,             // 4
    AUCTION,                        // 5
    DEFENSEWARFARE,                 // 6
    Max                             // 7
};

struct MapServerInfo
{
    var bool bUse;
    var string normalTex;
    var string pushedTex;
    var string highlightTex;
    var int nServerInfoType;
    var string TooltipString;
    var string descString;
    var string szReserved;
    var string buttonName;
    var int nRegionID;
    var int nData;
    var array<Vector> clickedLocArray;
    var int clickedLocClickCount;
};

struct sellingAgencyBuyInfo
{
    var string Name;
    var int Index;
    var array<FileNameInfo> productList;
};

struct sellingAgencyInfo
{
    var bool Completed;
    var string product;
    var int TimeOut;
    var int randTime;
    var array<string> postNames;
    var int Size;
    var string lastName;
    var array<FileNameInfo> savedProductList;
    var array<sellingAgencyBuyInfo> doneBuyInfos;
    var int Index;
};

struct RaidUIData
{
    var string raidMonsterName;
    var string raidDesc;
    var int nRaidMonsterID;
    var int nRaidMonsterLevel;
    var int nRaidMonsterZone;
    var string RaidMonsterZoneName;
    var string sortingKey;
    var int nMinLevel;
    var int nMaxLevel;
    var int nReqMinLevel;
    var int nReqMaxLevel;
    var int Id;
    var Vector nWorldLoc;
};

struct SkillTrainInfo
{
    var string strIconName;
    var string strName;
    var string strEnchantName;
    var int Id;
    var int Level;
    var int SubLevel;
    var int requiredLevel;
    var INT64 spConsume;
};

struct EnsoulStoneUIInfo
{
    var int slotType;
    var array<int> OptionId_Array;
};

struct EnsoulOptionUIInfo
{
    var int optionId;
    var int OptionStep;
    var int optionType;
    var string Name;
    var string Desc;
    var string Icontex;
    var string IconPanelTex;
    var int ExtractionItemID;
};

struct EnsoulFeeUIInfo
{
    var int nID;
    var INT64 ItemCount;
};

var string s1;
var string s2;
var string s3;
var string s4;
var string s5;
var string s6;
var string s7;
var string s8;
var string s9;
var string s10;
var string s11;
var string s12;

function GetEnsoulStoneUIInfo(ItemID IdInfo, out EnsoulStoneUIInfo eStoneInfo)
{
    local string EnsoulStoneUIInfoParam;
    local int numOfOption, optionId, i;

    Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulStoneInfo(IdInfo, EnsoulStoneUIInfoParam);
    ParseInt(EnsoulStoneUIInfoParam, "SlotType", eStoneInfo.slotType);
    ParseInt(EnsoulStoneUIInfoParam, "NumOfOption", numOfOption);
    i = 0;
    J0x5C:

    // End:0xD2 [Loop If]
    if(i < numOfOption)
    {
        ParseInt(EnsoulStoneUIInfoParam, "OptionId_" $ string(i), optionId);
        eStoneInfo.OptionId_Array.Length = eStoneInfo.OptionId_Array.Length + 1;
        eStoneInfo.OptionId_Array[eStoneInfo.OptionId_Array.Length - 1] = optionId;
        i++;
        // [Loop Continue]
        goto J0x5C;
    }
    return;
}

function GetEnsoulOptionUIInfo(int nEnsoulOptionID, out EnsoulOptionUIInfo eOptionInfo)
{
    local string ensoulOptioEachParam;

    // End:0x123
    if(nEnsoulOptionID > 0)
    {
        Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulOptionInfo(nEnsoulOptionID, ensoulOptioEachParam);
        ParseInt(ensoulOptioEachParam, "OptionType", eOptionInfo.optionType);
        ParseInt(ensoulOptioEachParam, "OptionStep", eOptionInfo.OptionStep);
        ParseString(ensoulOptioEachParam, "OptionName", eOptionInfo.Name);
        ParseString(ensoulOptioEachParam, "OptionDesc", eOptionInfo.Desc);
        ParseString(ensoulOptioEachParam, "IconTex", eOptionInfo.Icontex);
        ParseString(ensoulOptioEachParam, "IconPanelTex", eOptionInfo.IconPanelTex);
        ParseInt(ensoulOptioEachParam, "ExtractionItemID", eOptionInfo.ExtractionItemID);
        eOptionInfo.optionId = nEnsoulOptionID;        
    }
    else
    {
        Debug("Error : GetEnsoulOptionUIInfo  ->  ensoulID is wrong");
    }
    return;
}

function GetEnsoulFeeUIInfo(int CrystalType, bool bIsRefee, int slotType, int SlotIndex, out EnsoulFeeUIInfo feeInfo)
{
    local string ensoulFeeInfoParam;

    Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulFeeInfo(CrystalType, bIsRefee, slotType, SlotIndex, ensoulFeeInfoParam);
    ParseInt(ensoulFeeInfoParam, "ItemID", feeInfo.nID);
    ParseINT64(ensoulFeeInfoParam, "ItemCount", feeInfo.ItemCount);
    return;
}
