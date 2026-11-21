class MinimapWnd extends UICommonAPI;

const OTHER_HIGHLIGHT_ICON_INDEX = 100;
const REGIONINFO_OFFSETX = 225;
const REGIONINFO_OFFSETY = 400;
const TIMER_ID = 225;
const TIMER_DELAY = 1500;

struct HuntingZoneUIDataEx
{
    var int huntingZoneId;
    var HuntingZoneUIData huntingZoneCache;
};

var bool m_Dominion;
var string gCastleInfoParam;
var bool IsRegionsUpdated;
var array<MinimapRegionInfo> RegionData;
var bool bEraseRequest;
var int bOwnthingCount;
var int bOwnthing;
var array<int> PrevAliveRaidList;
var array<HuntingZoneUIDataEx> huntZoneDataCache;
var array<RaidUIData> RaidUIDataCache;
var array<int> raidDataKeyListCache;
var bool bLockRequest;
var string m_WindowName;
var int m_PartyMemberCount;
var int m_PartyLocIndex;
var int isNoShowMissionWindow;
var bool m_AdjustCursedLoc;
var bool GlobalCurFortressStatus;
var bool m_bShowCurrentLocation;
var bool m_bShowGameTime;
var bool bMiniMapDisabled;
var bool m_bExpandState;
var Vector BlockedLoc1;
var Vector BlockedLoc2;
var ButtonHandle Btn_Refresh;
var bool bHaveItem;
var int FortressID;
var int SiegeStatus;
var int TotalBarrackCnt;
var int GlobalCurFortressID;
var int G_ZoneID;
var int G_ZoneID2;
var string m_combocursedName;
var int m_CurContinent;
var WindowHandle MinimapDrawerWnd;
var WindowHandle m_hExpandWnd;
var WindowHandle m_hGuideWnd;
var GuideWnd GuideWnd;
var int CurrentLayer;
var int TotalLayers;
var WindowHandle Me;
var WindowHandle m_MinimapMissionWnd;
var ItemWindowHandle m_questItem;
var MinimapCtrlHandle m_MiniMap;
var ButtonHandle ReduceButton;
var TabHandle m_MapSelectTab;
var WindowHandle CleftCurTriggerWnd;
var ListCtrlHandle ListTrackItem3;
var ListCtrlHandle ListTrackItem2;
var array<int> loc_fortress;
var array<int> loc_component;
var array<int> loc_sysstr;
var array<int> loc_xloc;
var array<int> loc_yloc;
var int loc_cleftx[5];
var int loc_clefty[5];
var string loc_cleftName[5];
var string loc_cleftIcon[5];
var ButtonHandle ServerInfo01_Button;
var ButtonHandle ServerInfo02_Button;
var ButtonHandle ServerInfo03_Button;
var ButtonHandle ServerInfo04_Button;
var array<MapServerInfo> serverInfoArray;
var Vector QuestLocation;
var int DelayRequestSeedInfo;
var array<string> SeedDataforMap;
var TextureHandle TabBg_Line;
var Rect smallMapRect;
var MinimapMissionWnd MinimapMissionWndScript;
var bool bCompleteBaseElementShow;
var bool bIsTownMap;
var int nTownMapZoneID;
var MinimapCtrlHandle TeleportBookMarkWnd_MiniMap;
var array<int> aliveRaidList;

function int FortressID2ZoneNameID(int LocalID)
{
    local array<int> FortressID, ZoneNameID;
    local int i, ReturnInt;

    FortressID[0] = 422;
    FortressID[1] = 423;
    FortressID[2] = 424;
    FortressID[3] = 425;
    FortressID[4] = 426;
    FortressID[5] = 427;
    FortressID[6] = 428;
    FortressID[7] = 429;
    FortressID[8] = 430;
    FortressID[9] = 431;
    FortressID[10] = 432;
    FortressID[11] = 433;
    FortressID[12] = 434;
    FortressID[13] = 435;
    FortressID[14] = 436;
    FortressID[15] = 437;
    FortressID[16] = 438;
    FortressID[17] = 439;
    FortressID[18] = 440;
    FortressID[19] = 441;
    FortressID[20] = 442;
    ZoneNameID[0] = 101;
    ZoneNameID[1] = 102;
    ZoneNameID[2] = 103;
    ZoneNameID[3] = 104;
    ZoneNameID[4] = 105;
    ZoneNameID[5] = 106;
    ZoneNameID[6] = 107;
    ZoneNameID[7] = 108;
    ZoneNameID[8] = 109;
    ZoneNameID[9] = 110;
    ZoneNameID[10] = 111;
    ZoneNameID[11] = 112;
    ZoneNameID[12] = 113;
    ZoneNameID[13] = 114;
    ZoneNameID[14] = 115;
    ZoneNameID[15] = 116;
    ZoneNameID[16] = 117;
    ZoneNameID[17] = 118;
    ZoneNameID[18] = 119;
    ZoneNameID[19] = 120;
    ZoneNameID[20] = 121;
    ReturnInt = 0;
    i = 0;
    J0x217:

    // End:0x257 [Loop If]
    if(i < FortressID.Length)
    {
        // End:0x24D
        if(FortressID[i] == LocalID)
        {
            ReturnInt = ZoneNameID[i];
        }
        i++;
        // [Loop Continue]
        goto J0x217;
    }
    return ReturnInt;
    return;
}

function ExecuteFortressSiegeStatus(string param)
{
    local int ZoneID;

    ParseInt(param, "ZoneID", ZoneID);
    // End:0x2F
    if(ZoneID == 0)
    {
        ZoneID = GetCurrentZoneID();
    }
    DrawPeaceStatusFortressSiegeStatus(param);
    switch(ZoneID)
    {
        // End:0x49
        case 422:
        // End:0x51
        case 423:
        // End:0x59
        case 424:
        // End:0x61
        case 425:
        // End:0x69
        case 426:
        // End:0x71
        case 427:
        // End:0x79
        case 428:
        // End:0x81
        case 429:
        // End:0x89
        case 430:
        // End:0x91
        case 431:
        // End:0x99
        case 432:
        // End:0xA1
        case 433:
        // End:0xA9
        case 434:
        // End:0xB1
        case 435:
        // End:0xB9
        case 436:
        // End:0xC1
        case 437:
        // End:0xC9
        case 438:
        // End:0xD1
        case 439:
        // End:0xD9
        case 440:
        // End:0xE1
        case 441:
        // End:0xE9
        case 442:
        // End:0xF1
        case 443:
        // End:0x11E
        case 444:
            // End:0x11B
            if((FortressID2ZoneNameID(ZoneID)) != 0)
            {
                RequestFortressMapInfo(FortressID2ZoneNameID(ZoneID));
            }
            // End:0x127
            break;
        // End:0xFFFF
        default:
            // End:0x127
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x127
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x127
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x127
}

function GetLocData()
{
    loc_fortress[1] = 101;
    loc_fortress[2] = 101;
    loc_fortress[3] = 101;
    loc_fortress[4] = 101;
    loc_fortress[5] = 102;
    loc_fortress[6] = 102;
    loc_fortress[7] = 102;
    loc_fortress[8] = 102;
    loc_fortress[9] = 102;
    loc_fortress[10] = 102;
    loc_fortress[11] = 103;
    loc_fortress[12] = 103;
    loc_fortress[13] = 103;
    loc_fortress[14] = 103;
    loc_fortress[15] = 104;
    loc_fortress[16] = 104;
    loc_fortress[17] = 104;
    loc_fortress[18] = 104;
    loc_fortress[19] = 104;
    loc_fortress[20] = 104;
    loc_fortress[21] = 105;
    loc_fortress[22] = 105;
    loc_fortress[23] = 105;
    loc_fortress[24] = 105;
    loc_fortress[25] = 106;
    loc_fortress[26] = 106;
    loc_fortress[27] = 106;
    loc_fortress[28] = 106;
    loc_fortress[29] = 107;
    loc_fortress[30] = 107;
    loc_fortress[31] = 107;
    loc_fortress[32] = 107;
    loc_fortress[33] = 107;
    loc_fortress[34] = 107;
    loc_fortress[35] = 108;
    loc_fortress[36] = 108;
    loc_fortress[37] = 108;
    loc_fortress[38] = 108;
    loc_fortress[39] = 109;
    loc_fortress[40] = 109;
    loc_fortress[41] = 109;
    loc_fortress[42] = 109;
    loc_fortress[43] = 109;
    loc_fortress[44] = 109;
    loc_fortress[45] = 110;
    loc_fortress[46] = 110;
    loc_fortress[47] = 110;
    loc_fortress[48] = 110;
    loc_fortress[49] = 110;
    loc_fortress[50] = 110;
    loc_fortress[51] = 111;
    loc_fortress[52] = 111;
    loc_fortress[53] = 111;
    loc_fortress[54] = 111;
    loc_fortress[55] = 112;
    loc_fortress[56] = 112;
    loc_fortress[57] = 112;
    loc_fortress[58] = 112;
    loc_fortress[59] = 112;
    loc_fortress[60] = 112;
    loc_fortress[61] = 113;
    loc_fortress[62] = 113;
    loc_fortress[63] = 113;
    loc_fortress[64] = 113;
    loc_fortress[65] = 113;
    loc_fortress[66] = 113;
    loc_fortress[67] = 114;
    loc_fortress[68] = 114;
    loc_fortress[69] = 114;
    loc_fortress[70] = 114;
    loc_fortress[71] = 115;
    loc_fortress[72] = 115;
    loc_fortress[73] = 115;
    loc_fortress[74] = 115;
    loc_fortress[75] = 116;
    loc_fortress[76] = 116;
    loc_fortress[77] = 116;
    loc_fortress[78] = 116;
    loc_fortress[79] = 116;
    loc_fortress[80] = 116;
    loc_fortress[81] = 117;
    loc_fortress[82] = 117;
    loc_fortress[83] = 117;
    loc_fortress[84] = 117;
    loc_fortress[85] = 117;
    loc_fortress[86] = 117;
    loc_fortress[87] = 118;
    loc_fortress[88] = 118;
    loc_fortress[89] = 118;
    loc_fortress[90] = 118;
    loc_fortress[91] = 118;
    loc_fortress[92] = 118;
    loc_fortress[93] = 119;
    loc_fortress[94] = 119;
    loc_fortress[95] = 119;
    loc_fortress[96] = 119;
    loc_fortress[97] = 120;
    loc_fortress[98] = 120;
    loc_fortress[99] = 120;
    loc_fortress[100] = 120;
    loc_fortress[101] = 121;
    loc_fortress[102] = 121;
    loc_fortress[103] = 121;
    loc_fortress[104] = 121;
    loc_component[1] = 4;
    loc_component[2] = 2;
    loc_component[3] = 3;
    loc_component[4] = 1;
    loc_component[5] = 6;
    loc_component[6] = 4;
    loc_component[7] = 2;
    loc_component[8] = 3;
    loc_component[9] = 1;
    loc_component[10] = 5;
    loc_component[11] = 4;
    loc_component[12] = 2;
    loc_component[13] = 3;
    loc_component[14] = 1;
    loc_component[15] = 6;
    loc_component[16] = 4;
    loc_component[17] = 2;
    loc_component[18] = 3;
    loc_component[19] = 1;
    loc_component[20] = 5;
    loc_component[21] = 4;
    loc_component[22] = 2;
    loc_component[23] = 3;
    loc_component[24] = 1;
    loc_component[25] = 4;
    loc_component[26] = 2;
    loc_component[27] = 3;
    loc_component[28] = 1;
    loc_component[29] = 6;
    loc_component[30] = 4;
    loc_component[31] = 2;
    loc_component[32] = 3;
    loc_component[33] = 1;
    loc_component[34] = 5;
    loc_component[35] = 4;
    loc_component[36] = 2;
    loc_component[37] = 3;
    loc_component[38] = 1;
    loc_component[39] = 6;
    loc_component[40] = 4;
    loc_component[41] = 2;
    loc_component[42] = 3;
    loc_component[43] = 1;
    loc_component[44] = 5;
    loc_component[45] = 6;
    loc_component[46] = 4;
    loc_component[47] = 2;
    loc_component[48] = 3;
    loc_component[49] = 1;
    loc_component[50] = 5;
    loc_component[51] = 4;
    loc_component[52] = 2;
    loc_component[53] = 3;
    loc_component[54] = 1;
    loc_component[55] = 6;
    loc_component[56] = 4;
    loc_component[57] = 2;
    loc_component[58] = 3;
    loc_component[59] = 1;
    loc_component[60] = 5;
    loc_component[61] = 6;
    loc_component[62] = 4;
    loc_component[63] = 2;
    loc_component[64] = 3;
    loc_component[65] = 1;
    loc_component[66] = 5;
    loc_component[67] = 4;
    loc_component[68] = 2;
    loc_component[69] = 3;
    loc_component[70] = 1;
    loc_component[71] = 4;
    loc_component[72] = 2;
    loc_component[73] = 3;
    loc_component[74] = 1;
    loc_component[75] = 6;
    loc_component[76] = 4;
    loc_component[77] = 2;
    loc_component[78] = 3;
    loc_component[79] = 1;
    loc_component[80] = 5;
    loc_component[81] = 6;
    loc_component[82] = 4;
    loc_component[83] = 2;
    loc_component[84] = 3;
    loc_component[85] = 1;
    loc_component[86] = 5;
    loc_component[87] = 6;
    loc_component[88] = 4;
    loc_component[89] = 2;
    loc_component[90] = 3;
    loc_component[91] = 1;
    loc_component[92] = 5;
    loc_component[93] = 4;
    loc_component[94] = 2;
    loc_component[95] = 3;
    loc_component[96] = 1;
    loc_component[97] = 4;
    loc_component[98] = 2;
    loc_component[99] = 3;
    loc_component[100] = 1;
    loc_component[101] = 4;
    loc_component[102] = 2;
    loc_component[103] = 3;
    loc_component[104] = 1;
    loc_sysstr[1] = 1708;
    loc_sysstr[2] = 1709;
    loc_sysstr[3] = 1710;
    loc_sysstr[4] = 1711;
    loc_sysstr[5] = 1708;
    loc_sysstr[6] = 1713;
    loc_sysstr[7] = 1709;
    loc_sysstr[8] = 1710;
    loc_sysstr[9] = 1711;
    loc_sysstr[10] = 1714;
    loc_sysstr[11] = 1708;
    loc_sysstr[12] = 1709;
    loc_sysstr[13] = 1710;
    loc_sysstr[14] = 1711;
    loc_sysstr[15] = 1708;
    loc_sysstr[16] = 1713;
    loc_sysstr[17] = 1709;
    loc_sysstr[18] = 1710;
    loc_sysstr[19] = 1711;
    loc_sysstr[20] = 1714;
    loc_sysstr[21] = 1708;
    loc_sysstr[22] = 1709;
    loc_sysstr[23] = 1710;
    loc_sysstr[24] = 1711;
    loc_sysstr[25] = 1708;
    loc_sysstr[26] = 1709;
    loc_sysstr[27] = 1710;
    loc_sysstr[28] = 1711;
    loc_sysstr[29] = 1708;
    loc_sysstr[30] = 1713;
    loc_sysstr[31] = 1709;
    loc_sysstr[32] = 1710;
    loc_sysstr[33] = 1711;
    loc_sysstr[34] = 1714;
    loc_sysstr[35] = 1708;
    loc_sysstr[36] = 1709;
    loc_sysstr[37] = 1710;
    loc_sysstr[38] = 1711;
    loc_sysstr[39] = 1708;
    loc_sysstr[40] = 1713;
    loc_sysstr[41] = 1709;
    loc_sysstr[42] = 1710;
    loc_sysstr[43] = 1711;
    loc_sysstr[44] = 1714;
    loc_sysstr[45] = 1708;
    loc_sysstr[46] = 1713;
    loc_sysstr[47] = 1709;
    loc_sysstr[48] = 1710;
    loc_sysstr[49] = 1711;
    loc_sysstr[50] = 1714;
    loc_sysstr[51] = 1708;
    loc_sysstr[52] = 1709;
    loc_sysstr[53] = 1710;
    loc_sysstr[54] = 1711;
    loc_sysstr[55] = 1708;
    loc_sysstr[56] = 1713;
    loc_sysstr[57] = 1709;
    loc_sysstr[58] = 1710;
    loc_sysstr[59] = 1711;
    loc_sysstr[60] = 1714;
    loc_sysstr[61] = 1708;
    loc_sysstr[62] = 1713;
    loc_sysstr[63] = 1709;
    loc_sysstr[64] = 1710;
    loc_sysstr[65] = 1711;
    loc_sysstr[66] = 1714;
    loc_sysstr[67] = 1708;
    loc_sysstr[68] = 1709;
    loc_sysstr[69] = 1710;
    loc_sysstr[70] = 1711;
    loc_sysstr[71] = 1708;
    loc_sysstr[72] = 1709;
    loc_sysstr[73] = 1710;
    loc_sysstr[74] = 1711;
    loc_sysstr[75] = 1708;
    loc_sysstr[76] = 1713;
    loc_sysstr[77] = 1709;
    loc_sysstr[78] = 1710;
    loc_sysstr[79] = 1711;
    loc_sysstr[80] = 1714;
    loc_sysstr[81] = 1708;
    loc_sysstr[82] = 1713;
    loc_sysstr[83] = 1709;
    loc_sysstr[84] = 1710;
    loc_sysstr[85] = 1711;
    loc_sysstr[86] = 1714;
    loc_sysstr[87] = 1708;
    loc_sysstr[88] = 1713;
    loc_sysstr[89] = 1709;
    loc_sysstr[90] = 1710;
    loc_sysstr[91] = 1711;
    loc_sysstr[92] = 1714;
    loc_sysstr[93] = 1708;
    loc_sysstr[94] = 1709;
    loc_sysstr[95] = 1710;
    loc_sysstr[96] = 1711;
    loc_sysstr[97] = 1708;
    loc_sysstr[98] = 1709;
    loc_sysstr[99] = 1710;
    loc_sysstr[100] = 1711;
    loc_sysstr[101] = 1708;
    loc_sysstr[102] = 1709;
    loc_sysstr[103] = 1710;
    loc_sysstr[104] = 1711;
    loc_xloc[1] = -52818;
    loc_xloc[2] = -52128;
    loc_xloc[3] = -53944;
    loc_xloc[4] = -52435;
    loc_xloc[5] = -22625;
    loc_xloc[6] = -23992;
    loc_xloc[7] = -22992;
    loc_xloc[8] = -21520;
    loc_xloc[9] = -21328;
    loc_xloc[10] = -22728;
    loc_xloc[11] = 16621;
    loc_xloc[12] = 17984;
    loc_xloc[13] = 16016;
    loc_xloc[14] = 15152;
    loc_xloc[15] = 126079;
    loc_xloc[16] = 127209;
    loc_xloc[17] = 124299;
    loc_xloc[18] = 124768;
    loc_xloc[19] = 124768;
    loc_xloc[20] = 128048;
    loc_xloc[21] = 72814;
    loc_xloc[22] = 73788;
    loc_xloc[23] = 71264;
    loc_xloc[24] = 72400;
    loc_xloc[25] = 154848;
    loc_xloc[26] = 155576;
    loc_xloc[27] = 153328;
    loc_xloc[28] = 154704;
    loc_xloc[29] = 189930;
    loc_xloc[30] = 191056;
    loc_xloc[31] = 188160;
    loc_xloc[32] = 188626;
    loc_xloc[33] = 188624;
    loc_xloc[34] = 191846;
    loc_xloc[35] = 118472;
    loc_xloc[36] = 118880;
    loc_xloc[37] = 118560;
    loc_xloc[38] = 117216;
    loc_xloc[39] = 159088;
    loc_xloc[40] = 161066;
    loc_xloc[41] = 157968;
    loc_xloc[42] = 157312;
    loc_xloc[43] = 159664;
    loc_xloc[44] = 160194;
    loc_xloc[45] = 69860;
    loc_xloc[46] = 68289;
    loc_xloc[47] = 71248;
    loc_xloc[48] = 68688;
    loc_xloc[49] = 71264;
    loc_xloc[50] = 68101;
    loc_xloc[51] = 109423;
    loc_xloc[52] = 109600;
    loc_xloc[53] = 108223;
    loc_xloc[54] = 109856;
    loc_xloc[55] = 5542;
    loc_xloc[56] = 4794;
    loc_xloc[57] = 7006;
    loc_xloc[58] = 4384;
    loc_xloc[59] = 6528;
    loc_xloc[60] = 5246;
    loc_xloc[61] = -53232;
    loc_xloc[62] = -51075;
    loc_xloc[63] = -55791;
    loc_xloc[64] = -54168;
    loc_xloc[65] = -55248;
    loc_xloc[66] = -50913;
    loc_xloc[67] = 60296;
    loc_xloc[68] = 61864;
    loc_xloc[69] = 59436;
    loc_xloc[70] = 58480;
    loc_xloc[71] = 11537;
    loc_xloc[72] = 9472;
    loc_xloc[73] = 12829;
    loc_xloc[74] = 13184;
    loc_xloc[75] = 79297;
    loc_xloc[76] = 78915;
    loc_xloc[77] = 77262;
    loc_xloc[78] = 80929;
    loc_xloc[79] = 79440;
    loc_xloc[80] = 80755;
    loc_xloc[81] = 111366;
    loc_xloc[82] = 109150;
    loc_xloc[83] = 109872;
    loc_xloc[84] = 112601;
    loc_xloc[85] = 113481;
    loc_xloc[86] = 113929;
    loc_xloc[87] = 125246;
    loc_xloc[88] = 127398;
    loc_xloc[89] = 122688;
    loc_xloc[90] = 124305;
    loc_xloc[91] = 123232;
    loc_xloc[92] = 127632;
    loc_xloc[93] = 73070;
    loc_xloc[94] = 71392;
    loc_xloc[95] = 71542;
    loc_xloc[96] = 74288;
    loc_xloc[97] = 100645;
    loc_xloc[98] = 100688;
    loc_xloc[99] = 99484;
    loc_xloc[100] = 100752;
    loc_xloc[101] = 72195;
    loc_xloc[102] = 70189;
    loc_xloc[103] = 73831;
    loc_xloc[104] = 73680;
    loc_yloc[1] = 156512;
    loc_yloc[2] = 157752;
    loc_yloc[3] = 155433;
    loc_yloc[4] = 155188;
    loc_yloc[5] = 219799;
    loc_yloc[6] = 218883;
    loc_yloc[7] = 218160;
    loc_yloc[8] = 221504;
    loc_yloc[9] = 218864;
    loc_yloc[10] = 221746;
    loc_yloc[11] = 188124;
    loc_yloc[12] = 187536;
    loc_yloc[13] = 189520;
    loc_yloc[14] = 188128;
    loc_yloc[15] = 123550;
    loc_yloc[16] = 121785;
    loc_yloc[17] = 123614;
    loc_yloc[18] = 124640;
    loc_yloc[19] = 121856;
    loc_yloc[20] = 123344;
    loc_yloc[21] = 4327;
    loc_yloc[22] = 5479;
    loc_yloc[23] = 4144;
    loc_yloc[24] = 2896;
    loc_yloc[25] = 55344;
    loc_yloc[26] = 56592;
    loc_yloc[27] = 54848;
    loc_yloc[28] = 53856;
    loc_yloc[29] = 39808;
    loc_yloc[30] = 38179;
    loc_yloc[31] = 39920;
    loc_yloc[32] = 41066;
    loc_yloc[33] = 38240;
    loc_yloc[34] = 39764;
    loc_yloc[35] = 204952;
    loc_yloc[36] = 203568;
    loc_yloc[37] = 206560;
    loc_yloc[38] = 205648;
    loc_yloc[39] = -70272;
    loc_yloc[40] = -70241;
    loc_yloc[41] = -71659;
    loc_yloc[42] = -70640;
    loc_yloc[43] = -72224;
    loc_yloc[44] = -68688;
    loc_yloc[45] = -61364;
    loc_yloc[46] = -62354;
    loc_yloc[47] = -62352;
    loc_yloc[48] = -59648;
    loc_yloc[49] = -60512;
    loc_yloc[50] = -60816;
    loc_yloc[51] = -141204;
    loc_yloc[52] = -139735;
    loc_yloc[53] = -142209;
    loc_yloc[54] = -142640;
    loc_yloc[55] = 149751;
    loc_yloc[56] = 147528;
    loc_yloc[57] = 148242;
    loc_yloc[58] = 150992;
    loc_yloc[59] = 151872;
    loc_yloc[60] = 152319;
    loc_yloc[61] = 91297;
    loc_yloc[62] = 90317;
    loc_yloc[63] = 91856;
    loc_yloc[64] = 92604;
    loc_yloc[65] = 90496;
    loc_yloc[66] = 92259;
    loc_yloc[67] = 139508;
    loc_yloc[68] = 139257;
    loc_yloc[69] = 140834;
    loc_yloc[70] = 139648;
    loc_yloc[71] = 95056;
    loc_yloc[72] = 94992;
    loc_yloc[73] = 96214;
    loc_yloc[74] = 94928;
    loc_yloc[75] = 91077;
    loc_yloc[76] = 93374;
    loc_yloc[77] = 91704;
    loc_yloc[78] = 90510;
    loc_yloc[79] = 88752;
    loc_yloc[80] = 89002;
    loc_yloc[81] = -15077;
    loc_yloc[82] = -14331;
    loc_yloc[83] = -16624;
    loc_yloc[84] = -13933;
    loc_yloc[85] = -16058;
    loc_yloc[86] = -14801;
    loc_yloc[87] = 95204;
    loc_yloc[88] = 94229;
    loc_yloc[89] = 95760;
    loc_yloc[90] = 96528;
    loc_yloc[91] = 94400;
    loc_yloc[92] = 96240;
    loc_yloc[93] = 186048;
    loc_yloc[94] = 184720;
    loc_yloc[95] = 186410;
    loc_yloc[96] = 186912;
    loc_yloc[97] = -55318;
    loc_yloc[98] = -57440;
    loc_yloc[99] = -54027;
    loc_yloc[100] = -53664;
    loc_yloc[101] = -94701;
    loc_yloc[102] = -93935;
    loc_yloc[103] = -94119;
    loc_yloc[104] = -95456;
    loc_cleftx[0] = -211648;
    loc_cleftx[1] = -219104;
    loc_cleftx[2] = -211773;
    loc_cleftx[3] = -204849;
    loc_cleftx[4] = -223211;
    loc_cleftx[5] = -213463;
    loc_clefty[0] = 250400;
    loc_clefty[1] = 242704;
    loc_clefty[2] = 238864;
    loc_clefty[3] = 242148;
    loc_clefty[4] = 247803;
    loc_clefty[5] = 244896;
    loc_cleftName[0] = GetSystemString(2017);
    loc_cleftName[1] = GetSystemString(2017);
    loc_cleftName[2] = GetSystemString(2017);
    loc_cleftName[3] = GetSystemString(2018);
    loc_cleftName[4] = GetSystemString(2018);
    loc_cleftName[5] = GetSystemString(2019);
    loc_cleftIcon[0] = "l2ui_ct1.minimap_df_icn_machinery";
    loc_cleftIcon[1] = "l2ui_ct1.minimap_df_icn_machinery";
    loc_cleftIcon[2] = "l2ui_ct1.minimap_df_icn_machinery";
    loc_cleftIcon[3] = "l2ui_ct1.minimap_df_icn_shield";
    loc_cleftIcon[4] = "l2ui_ct1.minimap_df_icn_shield";
    loc_cleftIcon[5] = "l2ui_ct1.minimap_df_icn_machinery";
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(1780);
    RegisterEvent(520);
    RegisterEvent(1790);
    RegisterEvent(1800);
    RegisterEvent(1810);
    RegisterEvent(1820);
    RegisterEvent(1830);
    RegisterEvent(1840);
    RegisterEvent(1850);
    RegisterEvent(1860);
    RegisterEvent(2420);
    RegisterEvent(1870);
    RegisterEvent(1880);
    RegisterEvent(1890);
    RegisterEvent(2980);
    RegisterEvent(2420);
    RegisterEvent(2990);
    RegisterEvent(3201);
    RegisterEvent(3202);
    RegisterEvent(3200);
    RegisterEvent(580);
    RegisterEvent(1891);
    RegisterEvent(1892);
    RegisterEvent(150);
    RegisterEvent(2900);
    RegisterEvent(3610);
    RegisterEvent(3630);
    RegisterEvent(3640);
    RegisterEvent(3590);
    RegisterEvent(3150);
    RegisterEvent(3170);
    RegisterEvent(10180);
    RegisterEvent(4200);
    RegisterEvent(10182);
    RegisterEvent(10183);
    RegisterEvent(8000);
    RegisterEvent(10080);
    RegisterEvent(40);
    RegisterEvent(1893);
    RegisterEvent(12);
    RegisterEvent(10181);
    return;
}

function OnLoad()
{
    local Color txtVarCurLocColor;

    bOwnthing = 0;
    SetClosingOnESC();
    MinimapMissionWndScript = MinimapMissionWnd(GetScript("MinimapMissionWnd"));
    Me = GetWindowHandle("MinimapWnd");
    m_MinimapMissionWnd = GetWindowHandle("MinimapMissionWnd");
    m_questItem = GetItemWindowHandle("InventoryWnd.QuestItem");
    m_MiniMap = GetMinimapCtrlHandle("MinimapWnd.Minimap");
    ReduceButton = GetButtonHandle("MinimapWnd.btnReduce");
    m_MapSelectTab = GetTabHandle("MiniMapWnd.MapSelectTab");
    TabBg_Line = GetTextureHandle("MiniMapWnd.TabBg_Line");
    ServerInfo01_Button = GetButtonHandle("MiniMapWnd.ServerInfo01_Button");
    ServerInfo02_Button = GetButtonHandle("MiniMapWnd.ServerInfo02_Button");
    ServerInfo03_Button = GetButtonHandle("MiniMapWnd.ServerInfo03_Button");
    ServerInfo04_Button = GetButtonHandle("MiniMapWnd.ServerInfo04_Button");
    MinimapDrawerWnd = GetWindowHandle("MiniMapDrawerWnd");
    Me = GetWindowHandle("MinimapWnd");
    m_hGuideWnd = GetWindowHandle("GuideWnd");
    GuideWnd = GuideWnd(GetScript("GuideWnd"));
    m_questItem = GetItemWindowHandle("InventoryWnd.QuestItem");
    m_MiniMap = GetMinimapCtrlHandle("MinimapWnd.Minimap");
    Btn_Refresh = GetButtonHandle("MinimapWnd.Btn_Refresh");
    ReduceButton = GetButtonHandle("MinimapWnd.btnReduce");
    m_MapSelectTab = GetTabHandle("MiniMapWnd.MapSelectTab");
    ListTrackItem2 = GetListCtrlHandle("MiniMapDrawerWnd.ListTrackItem2");
    ListTrackItem3 = GetListCtrlHandle("MiniMapDrawerWnd.ListTrackItem3");
    CleftCurTriggerWnd = GetWindowHandle("CleftCurTriggerWnd");
    Btn_Refresh = GetButtonHandle("MinimapWnd.Btn_Refresh");
    TeleportBookMarkWnd_MiniMap = GetMinimapCtrlHandle("TeleportBookMarkWnd.Minimap");
    PrevAliveRaidList.Length = 1;
    PrevAliveRaidList[0] = 1;
    m_PartyLocIndex = -1;
    bLockRequest = false;
    huntZoneDataCache.Remove(0, huntZoneDataCache.Length);
    RaidUIDataCache.Remove(0, RaidUIDataCache.Length);
    raidDataKeyListCache.Remove(0, raidDataKeyListCache.Length);
    buildCaches();
    m_PartyMemberCount = GetPartyMemberCount();
    m_AdjustCursedLoc = false;
    m_bShowCurrentLocation = true;
    m_bShowGameTime = true;
    GlobalCurFortressStatus = false;
    BlockedLoc1.X = -32768.0000000;
    BlockedLoc1.Y = 32768.0000000;
    BlockedLoc2.X = 229376.0000000;
    BlockedLoc2.Y = 262144.0000000;
    bMiniMapDisabled = true;
    DrawCleftStatus();
    txtVarCurLocColor.R = 254;
    txtVarCurLocColor.G = 243;
    txtVarCurLocColor.B = 124;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("Minimapwnd.txtVarCurLoc", txtVarCurLocColor);
    initServerInfoArray();
    initServerButton();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x2A
        case 2420:
            HandleZoneTitle();
            SetCurrentLocation();
            G_ZoneID2 = GetCurrentZoneID();
            // End:0x4C5
            break;
        // End:0x40
        case 2990:
            HandleDungeonMapRefresh(a_Param);
            // End:0x4C5
            break;
        // End:0x62
        case 1780:
            G_ZoneID2 = GetCurrentZoneID();
            HandleShowMinimap(a_Param);
            // End:0x4C5
            break;
        // End:0x78
        case 520:
            HandlePartyMemberChanged(a_Param);
            // End:0x4C5
            break;
        // End:0x83
        case 1790:
            // End:0x4C5
            break;
        // End:0x99
        case 1800:
            HandleMinimapDeleteTarget(a_Param);
            // End:0x4C5
            break;
        // End:0xAA
        case 1810:
            HandleMinimapDeleteAllTarget();
            // End:0x4C5
            break;
        // End:0xBB
        case 1820:
            HandleMinimapShowQuest();
            // End:0x4C5
            break;
        // End:0xCC
        case 1830:
            HandleMinimapHideQuest();
            // End:0x4C5
            break;
        // End:0x11E
        case 1840:
            AdjustMapToPlayerPosition(true);
            G_ZoneID2 = GetCurrentZoneID();
            ParamAdd(a_Param, "ZoneID", string(G_ZoneID2));
            ExecuteFortressSiegeStatus(a_Param);
            Class'NWindow.MiniMapAPI'.static.RequestSeedPhase();
            // End:0x4C5
            break;
        // End:0x129
        case 1850:
            // End:0x4C5
            break;
        // End:0x13F
        case 1860:
            HandleCursedWeaponLoctaion(a_Param);
            // End:0x4C5
            break;
        // End:0x1A7
        case 1870:
            // End:0x16E
            if(a_Param != "")
            {
                ParseInt(a_Param, "ZoneID", nTownMapZoneID);                
            }
            else
            {
                nTownMapZoneID = 0;
            }
            bIsTownMap = true;
            ReduceButton.ShowWindow();
            ExecuteFortressSiegeStatus(a_Param);
            showAllRegionIcon(false);
            SetDirIconDest();
            // End:0x4C5
            break;
        // End:0x1D6
        case 1880:
            bIsTownMap = false;
            ReduceButton.HideWindow();
            showAllRegionIcon(true);
            SetDirIconDest();
            // End:0x4C5
            break;
        // End:0x1F5
        case 1890:
            // End:0x1F2
            if(m_bShowGameTime)
            {
                HandleUpdateGameTime(a_Param);
            }
            // End:0x4C5
            break;
        // End:0x20B
        case 2980:
            HandleMinimapTravel(a_Param);
            // End:0x4C5
            break;
        // End:0x221
        case 3201:
            HandleShowFortressMapInfo(a_Param);
            // End:0x4C5
            break;
        // End:0x237
        case 3202:
            HandleFortressMapBarrackInfo(a_Param);
            // End:0x4C5
            break;
        // End:0x266
        case 3200:
            GlobalCurFortressStatus = true;
            ParseInt(a_Param, "FortressID", GlobalCurFortressID);
            // End:0x4C5
            break;
        // End:0x28E
        case 580:
            // End:0x28B
            if(Me.IsShowWindow())
            {
                HandleChatmessage(a_Param);
            }
            // End:0x4C5
            break;
        // End:0x2C0
        case 150:
            SiegeStatus = 0;
            FortressID = 0;
            TotalBarrackCnt = 0;
            GlobalCurFortressID = 0;
            G_ZoneID = 0;
            G_ZoneID2 = 0;
            // End:0x4C5
            break;
        // End:0x2D6
        case 1891:
            ShowMultilayer(a_Param);
            // End:0x4C5
            break;
        // End:0x2E7
        case 1892:
            CloseMultilayer();
            // End:0x4C5
            break;
        // End:0x31B
        case 8000:
            Class'NWindow.UIAPI_MINIMAPCTRL'.static.ResetMinimapData("MinimapWnd.Minimap");
            checkClassicForm();
            // End:0x4C5
            break;
        // End:0x336
        case 2900:
            // End:0x333
            if(IsExpandState())
            {
                setMapSize(true);
            }
            // End:0x4C5
            break;
        // End:0x34C
        case 3610:
            HandleDominionsOwnPos(a_Param);
            // End:0x4C5
            break;
        // End:0x35D
        case 3630:
            HandleDominionWarStart();
            // End:0x4C5
            break;
        // End:0x371
        case 3640:
            HandleDominionWarEnd();
            // End:0x4C5
            break;
            // End:0x4C5
            break;
        // End:0x39D
        case 3590:
            ParseInt(a_Param, "DominionInfoCnt", bOwnthingCount);
            // End:0x4C5
            break;
        // End:0x3B3
        case 4200:
            HandleSeedMapInfo(a_Param);
            // End:0x4C5
            break;
        // End:0x3C9
        case 3150:
            LoadCastleInfo(a_Param);
            // End:0x4C5
            break;
        // End:0x3DF
        case 3170:
            LoadFortressInfo(a_Param);
            // End:0x4C5
            break;
        // End:0x3F5
        case 10180:
            LoadAgitSiegeInfo(a_Param);
            // End:0x4C5
            break;
        // End:0x430
        case 4200:
            Debug("minimap" @ "EV_ShowSeedMapInfo");
            HandleSeedMapInfo(a_Param);
            // End:0x4C5
            break;
        // End:0x446
        case 10182:
            LoadRaidServerInfo(a_Param);
            // End:0x4C5
            break;
        // End:0x45C
        case 10183:
            LoadItemAuctionStatus(a_Param);
            // End:0x4C5
            break;
        // End:0x472
        case 10080:
            loadFactionInfo(a_Param);
            // End:0x4C5
            break;
        // End:0x488
        case 1893:
            minimapAdjustViewLocationProcess(a_Param);
            // End:0x4C5
            break;
        // End:0x496
        case 40:
            resetMapData();
            // End:0x4C5
            break;
        // End:0x4A9
        case 12:
            testCode(a_Param);
            // End:0x4C5
            break;
        // End:0x4BF
        case 10181:
            updateRaidNpc(a_Param);
            // End:0x4C5
            break;
        // End:0xFFFF
        default:
            // End:0x4C5
            break;
            break;
    }
    return;
}

function updateRaidNpc(string param)
{
    local int npcCount, i, NpcID;

    ParseInt(param, "NpcCount", npcCount);
    PrevAliveRaidList = aliveRaidList;
    aliveRaidList.Remove(0, aliveRaidList.Length);
    i = 0;
    J0x39:

    // End:0x90 [Loop If]
    if(i < npcCount)
    {
        ParseInt(param, "NpcId_" $ string(i), NpcID);
        // End:0x86
        if(NpcID > 0)
        {
            aliveRaidList[aliveRaidList.Length] = NpcID;
        }
        i++;
        // [Loop Continue]
        goto J0x39;
    }
    // End:0xA5
    if(AreArraysEqual(PrevAliveRaidList, aliveRaidList))
    {
        return;
    }
    updateRaidListRecord(NpcID);
    return;
}

function bool AreArraysEqual(array<int> A, array<int> B)
{
    local int i;

    // End:0x13
    if(A.Length != B.Length)
    {
        return false;
    }
    i = 0;
    J0x1A:

    // End:0x51 [Loop If]
    if(i < A.Length)
    {
        // End:0x47
        if(A[i] != B[i])
        {
            return false;
        }
        i++;
        // [Loop Continue]
        goto J0x1A;
    }
    return true;
    return;
}

function updateRaidListRecord(int NpcID)
{
    local LVDataRecord Record;
    local array<LVDataRecord> Records;
    local int i, j, currentNpcID, Index;
    local string addStr;
    local RaidIconData currBossList;
    local array<int> currAliveBossList;

    currBossList = GuideWnd.bossList;
    currAliveBossList = aliveRaidList;
    i = 0;
    J0x26:

    // End:0xAF [Loop If]
    if(i < currBossList.RaidID.Length)
    {
        j = 0;
        J0x42:

        // End:0xA5 [Loop If]
        if(j < currAliveBossList.Length)
        {
            // End:0x9B
            if(currBossList.RaidID[i] == currAliveBossList[j])
            {
                drawMinimapRegionInfo(7, currBossList.Index[i], true, true);
                currAliveBossList.Remove(1, j);
                // [Explicit Break]
                goto J0xA5;
            }
            j++;
            // [Loop Continue]
            goto J0x42;
        }
        J0xA5:

        i++;
        // [Loop Continue]
        goto J0x26;
    }
    return;
}

function minimapAdjustViewLocationProcess(string param)
{
    local int X, Y, Z;
    local Vector loc;

    Debug("param" @ param);
    ParseInt(param, "LocX", X);
    ParseInt(param, "LocY", Y);
    ParseInt(param, "LocZ", Z);
    loc = setVector(X, Y, Z);
    SetLocContinent(loc);
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, true);
    return;
}

function testCode(string param)
{
    local int X, Y, Z;
    local Vector loc;

    ParseInt(param, "x", X);
    ParseInt(param, "y", Y);
    ParseInt(param, "z", Z);
    loc = setVector(X, Y, Z);
    SetLocContinent(loc);
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, true);
    return;
}

function loadFactionInfo(string a_Param)
{
    local array<L2UserFactionUIInfo> factionInfoListArray;
    local MinimapRegionInfo RegionInfo;
    local UserInfo pUserInfo;

    // End:0x1D
    if(Me.IsShowWindow())
    {
        GetPlayerInfo(pUserInfo);
    }
    return;
}

function HandleDominionWarStart()
{
    m_Dominion = true;
    RequestDominionInfo();
    return;
}

function HandleDominionWarEnd()
{
    local int i;

    m_MiniMap.EraseAllRegionInfo();
    m_MiniMap.DeleteAllTarget();
    showMapIconElement();
    i = 0;
    J0x2B:

    // End:0x56 [Loop If]
    if(i < RegionData.Length)
    {
        addMapIcon(RegionData[i]);
        i++;
        // [Loop Continue]
        goto J0x2B;
    }
    return;
}

function OwnthingMapping(int Index, Vector OwnLoc)
{
    local string toolTipParam;
    local MinimapRegionInfo regionInfoForMapIcon;
    local MinimapRegionIconData IconData;

    m_MiniMap.EraseRegionInfoCtrl(8, Index);
    regionInfoForMapIcon.eType = 8;
    regionInfoForMapIcon.nIndex = Index;
    ParamAdd(toolTipParam, "Type", string(8));
    ParamAdd(toolTipParam, "tooltipString", getInstanceL2Util().getCastleNameEx(Index - 10000) @ GetSystemString(2216));
    IconData = makeMapIcon(Index, true, setVector(int(OwnLoc.X), int(OwnLoc.Y), -10000));
    regionInfoForMapIcon.IconData = IconData;
    regionInfoForMapIcon.strTooltip = toolTipParam;
    addMapIcon(regionInfoForMapIcon);
    return;
}

function resetMapData()
{
    Debug("resetMapData");
    bCompleteBaseElementShow = false;
    initServerInfoArray();
    m_MiniMap.EraseAllRegionInfo();
    TeleportBookMarkWnd_MiniMap.EraseAllRegionInfo();
    return;
}

function LoadItemAuctionStatus(string param)
{
    local Vector loc;
    local int nState;
    local bool bUse;

    ParseInt(param, "State", nState);
    // End:0xA5
    if(nState > 0)
    {
        bUse = true;
        ParseFloat(param, "WorldLocX", loc.X);
        ParseFloat(param, "WorldLocY", loc.Y);
        ParseFloat(param, "WorldLocZ", loc.Z);
        Debug("Å¬ï¿½ï¿½!!!");
    }
    Debug("LoadItemAuctionStatus " @ param);
    setServerParse(5, param, bUse, loc);
    return;
}

function LoadRaidServerInfo(string param)
{
    local int nWorldRaidState, nWorldCastleSiegeState;
    local bool bUse;

    Debug("LoadRaidServerInfo Param: " @ param);
    ParseInt(param, "WorldRaidState", nWorldRaidState);
    ParseInt(param, "WorldCastleSiegeState", nWorldCastleSiegeState);
    // End:0x86
    if(nWorldRaidState > 0)
    {
        bUse = true;        
    }
    else
    {
        bUse = false;
    }
    setServerParse(2, param, bUse);
    // End:0xB7
    if(nWorldCastleSiegeState > 0)
    {
        bUse = true;        
    }
    else
    {
        bUse = false;
    }
    setServerParse(1, param, bUse);
    return;
}

function LoadAgitSiegeInfo(string param)
{
    local MinimapRegionInfo RegionInfo, emptyRegionInfo;
    local MinimapRegionIconData IconData;
    local int nRegionID;
    local string OwnerClanName, OwnerClanMasterName, OwnerClanNameToolTip, NextSiegeYear, NextSiegeMonth, NextSiegeDay,
	    NextSiegeHour, NextSiegeMin, NextSiegeSec;

    local int i, agitCount, AgitID;
    local string NextSiegeTime, agitName;

    ParseInt(param, "AgitCount", agitCount);
    i = 0;
    J0x22:

    // End:0x424 [Loop If]
    if(i < agitCount)
    {
        RegionInfo = emptyRegionInfo;
        ParseInt(param, "AgitID" $ string(i), AgitID);
        ParseString(param, "NextSiegeYear" $ string(i), NextSiegeYear);
        ParseString(param, "NextSiegeMonth" $ string(i), NextSiegeMonth);
        ParseString(param, "NextSiegeDay" $ string(i), NextSiegeDay);
        ParseString(param, "NextSiegeHour" $ string(i), NextSiegeHour);
        ParseString(param, "NextSiegeMin" $ string(i), NextSiegeMin);
        ParseString(param, "NextSiegeSec" $ string(i), NextSiegeSec);
        ParseString(param, "OwnerClanName" $ string(i), OwnerClanName);
        ParseString(param, "OwnerClanMasterName" $ string(i), OwnerClanMasterName);
        nRegionID = getInstanceL2Util().getCastleRegionIdEx(AgitID);
        agitName = getInstanceL2Util().getCastleNameEx(AgitID);
        // End:0x205
        if(OwnerClanName == "")
        {
            OwnerClanName = GetSystemString(27);
            OwnerClanNameToolTip = GetSystemMessage(2196);            
        }
        else
        {
            OwnerClanNameToolTip = MakeFullSystemMsg(GetSystemMessage(2197), OwnerClanName);
            OwnerClanName = OwnerClanName @ GetSystemString(439);
        }
        // End:0x279
        if(((NextSiegeMonth == "0") && NextSiegeYear == "70") && NextSiegeDay == "1")
        {
            NextSiegeTime = GetSystemString(584);            
        }
        else
        {
            NextSiegeMonth = string(int(NextSiegeMonth) + 1);
            NextSiegeTime = (MakeFullSystemMsg(GetSystemMessage(2203), NextSiegeMonth, NextSiegeDay) $ ", ") $ MakeFullSystemMsg(GetSystemMessage(2204), NextSiegeHour);
        }
        ParamAdd(RegionInfo.strTooltip, "AgitName", agitName);
        ParamAdd(RegionInfo.strTooltip, "Type", string(2));
        ParamAdd(RegionInfo.strTooltip, "OwnerClanName", OwnerClanName);
        ParamAdd(RegionInfo.strTooltip, "OwnerClanMasterName", OwnerClanMasterName);
        ParamAdd(RegionInfo.strTooltip, "NextSiegeTime", NextSiegeTime);
        ParamAdd(RegionInfo.strTooltip, "LocationName", GetCastleLocationName(AgitID));
        RegionInfo.nIndex = nRegionID;
        RegionInfo.eType = 2;
        RegionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
        // End:0x3F8
        if(GetMinimapRegionIconData(nRegionID, IconData))
        {
            RegionInfo.IconData = IconData;
        }
        // End:0x41A
        if(nRegionID > 0)
        {
            addMapIcon(RegionInfo, true);
            UpdateRegionData(RegionInfo);
        }
        i++;
        // [Loop Continue]
        goto J0x22;
    }
    return;
}

function LoadFortressInfo(string param)
{
    local MinimapRegionInfo RegionInfo;
    local MinimapRegionIconData IconData;
    local int nRegionID;
    local string tempStr;
    local int FortressID;
    local string OwnerClanName;
    local int SiegeState, LastOwndedTime;
    local string CastleName, Statcur, IconName;
    local int Hour, Date, Min;
    local string DateTotal;

    Hour = 0;
    Date = 0;
    Min = 0;
    ParseInt(param, "FortressID", FortressID);
    CastleName = getInstanceL2Util().getCastleNameEx(FortressID);
    ParseString(param, "OwnerClanName", OwnerClanName);
    ParseInt(param, "SiegeStatae", SiegeState);
    ParseInt(param, "LastOwnedTime", LastOwndedTime);
    // End:0xC4
    if(OwnerClanName == "")
    {
        OwnerClanName = GetSystemString(27);        
    }
    else
    {
        OwnerClanName = OwnerClanName @ GetSystemString(439);
    }
    // End:0x120
    if(SiegeState == 0)
    {
        Statcur = GetSystemString(894);
        IconName = "L2UI_CT1.ICON_DF_SIEGE_SHIELD";        
    }
    else
    {
        // End:0x160
        if(SiegeState == 1)
        {
            Statcur = GetSystemString(340);
            IconName = "L2UI_CT1.ICON_DF_SIEGE_SWORD";
        }
    }
    Min = LastOwndedTime / 60;
    Hour = Min / 60;
    Date = Hour / 24;
    // End:0x1C3
    if((Min < 60) && Min != 0)
    {
        DateTotal = string(Min) @ GetSystemString(1111);        
    }
    else
    {
        // End:0x1F9
        if((Hour < 60) && Hour != 0)
        {
            DateTotal = string(Hour) @ GetSystemString(1110);            
        }
        else
        {
            // End:0x21E
            if(Date != 0)
            {
                DateTotal = string(Date) @ GetSystemString(1109);
            }
        }
    }
    ParamAdd(RegionInfo.strTooltip, "Type", string(1));
    ParamAdd(RegionInfo.strTooltip, "CastleName", CastleName);
    ParamAdd(RegionInfo.strTooltip, "OwnerClanName", OwnerClanName);
    ParamAdd(RegionInfo.strTooltip, "SiegeState", Statcur);
    ParamAdd(RegionInfo.strTooltip, "LocationName", GetCastleLocationName(FortressID));
    ParamAdd(RegionInfo.strTooltip, "DateTotal", DateTotal);
    nRegionID = getInstanceL2Util().getCastleRegionIdEx(FortressID);
    RegionInfo.nIndex = nRegionID;
    RegionInfo.eType = 1;
    RegionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
    // End:0x35B
    if(GetMinimapRegionIconData(nRegionID, IconData))
    {
        RegionInfo.IconData = IconData;
    }
    addMapIcon(RegionInfo);
    UpdateRegionData(RegionInfo);
    return;
}

function LoadCastleInfo(string param)
{
    local int castleID;
    local string OwnerClanName, OwnerClanNameToolTip, TaxRate, NextSiegeTime, NextSiegeYear, NextSiegeMonth,
	    NextSiegeDay, NextSiegeHour, NextSiegeMin, NextSiegeSec, NextSiegeTotalTime,
	    CastleName, toolTipParam;

    local int SiegeState, castleType;
    local MinimapRegionInfo RegionInfo;
    local MinimapRegionIconData IconData;
    local int nRegionID, huntingZoneIndex;
    local bool bUse;
    local Vector tVector, emptyVector;
    local string tempStr;

    ParseInt(param, "CastleID", castleID);
    CastleName = getInstanceL2Util().getCastleNameEx(castleID);
    ParseString(param, "OwnerClanName", OwnerClanName);
    ParseString(param, "TaxRate", TaxRate);
    ParseString(param, "NextSiegeYear", NextSiegeYear);
    ParseString(param, "NextSiegeMonth", NextSiegeMonth);
    ParseString(param, "NextSiegeDay", NextSiegeDay);
    ParseString(param, "NextSiegeHour", NextSiegeHour);
    ParseString(param, "NextSiegeMin", NextSiegeMin);
    ParseString(param, "NextSiegeSec", NextSiegeSec);
    ParseString(param, "NextSiegeTime", NextSiegeTotalTime);
    ParseInt(param, "SiegeState", SiegeState);
    ParseInt(param, "CastleType", castleType);
    // End:0x1AA
    if(OwnerClanName == "")
    {
        OwnerClanName = GetSystemString(27);
        OwnerClanNameToolTip = GetSystemMessage(2196);        
    }
    else
    {
        OwnerClanNameToolTip = MakeFullSystemMsg(GetSystemMessage(2197), OwnerClanName);
        OwnerClanName = OwnerClanName @ GetSystemString(439);
    }
    // End:0x21E
    if(((NextSiegeMonth == "0") && NextSiegeYear == "70") && NextSiegeDay == "1")
    {
        NextSiegeTime = GetSystemString(584);        
    }
    else
    {
        // End:0x242
        if(int(NextSiegeTotalTime) > 0)
        {
            NextSiegeTime = BR_ConvertTimeToStr(int(NextSiegeTotalTime), 0);            
        }
        else
        {
            NextSiegeMonth = string(int(NextSiegeMonth) + 1);
            NextSiegeTime = MakeFullSystemMsg(GetSystemMessage(2203), NextSiegeMonth, NextSiegeDay);
        }
    }
    nRegionID = getInstanceL2Util().getCastleRegionIdEx(castleID);
    toolTipParam = "";
    ParamAdd(toolTipParam, "Type", string(0));
    ParamAdd(toolTipParam, "CastleName", CastleName);
    ParamAdd(toolTipParam, "LocationName", GetCastleLocationName(castleID));
    ParamAdd(toolTipParam, "OwnerClanNameToolTip", OwnerClanNameToolTip);
    ParamAdd(toolTipParam, "OwnerClanName", OwnerClanName);
    ParamAdd(toolTipParam, "NextSiegeTime", NextSiegeTime);
    ParamAdd(toolTipParam, "TaxRate", TaxRate $ "%");
    tempStr = "";
    // End:0x39D
    if(SiegeState == 0)
    {
        bUse = false;
        tempStr = GetSystemString(894);        
    }
    else
    {
        bUse = true;
        tempStr = GetSystemString(339);
    }
    ParamAdd(toolTipParam, "SiegeState", tempStr);
    tempStr = "";
    // End:0x3F9
    if(castleType == 1)
    {
        tempStr = GetSystemString(3519);        
    }
    else
    {
        // End:0x419
        if(castleType == 2)
        {
            tempStr = GetSystemString(3520);            
        }
        else
        {
            tempStr = "";
        }
    }
    ParamAdd(toolTipParam, "CastleType", tempStr);
    RegionInfo.eType = 0;
    RegionInfo.nIndex = nRegionID;
    RegionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
    RegionInfo.strDesc = CastleName;
    tVector = emptyVector;
    // End:0x4F7
    if(GetMinimapRegionIconData(nRegionID, IconData))
    {
        RegionInfo.IconData = IconData;
        tVector.X = float(IconData.nWorldLocX);
        tVector.Y = float(IconData.nWorldLocY);
        tVector.Z = float(IconData.nWorldLocZ);
    }
    RegionInfo.strTooltip = toolTipParam;
    addMapIcon(RegionInfo);
    UpdateRegionData(RegionInfo);
    setServerParse(0, CastleName, bUse, tVector, nRegionID);
    return;
}

function UpdateRegionData(MinimapRegionInfo Region)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x98 [Loop If]
    if(i < RegionData.Length)
    {
        // End:0x8E
        if(((RegionData[i].nIndex == Region.nIndex) && RegionData[i].IconData.nWorldLocX == Region.IconData.nWorldLocX) && RegionData[i].IconData.nWorldLocY == Region.IconData.nWorldLocY)
        {
            return;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    RegionData[RegionData.Length] = Region;
    return;
}

function string currentWndName()
{
    local string MapName;

    MapName = "MinimapWnd";
    return MapName;
    return;
}

function ShowMultilayer(string param)
{
    local int i;
    local string ComboboxName, ComboBoxShadowName, wndname, btnString_None, btnString_Down, btnString_Over;

    wndname = currentWndName();
    ComboBoxShadowName = wndname $ ".ComboBoxShadow";
    ComboboxName = wndname $ ".FloorComboBox";
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(ComboboxName);
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(ComboBoxShadowName);
    ParseInt(param, "CurrentLayer", CurrentLayer);
    ParseInt(param, "TotalLayers", TotalLayers);
    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(ComboboxName);
    i = 1;
    J0xC5:

    // End:0x122 [Loop If]
    if(i <= TotalLayers)
    {
        Class'NWindow.UIAPI_COMBOBOX'.static.AddString(ComboboxName, string(i) $ GetSystemString(5081));
        Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum(ComboboxName, CurrentLayer - 1);
        i++;
        // [Loop Continue]
        goto J0xC5;
    }
    btnString_None = "L2ui_ct1.Minimap.Minimap_DF_Minusbtn_Purple";
    btnString_Down = "L2ui_ct1.Minimap.Minimap_DF_Minusbtn_Purple_Down";
    btnString_Over = "L2ui_ct1.Minimap.Minimap_DF_Minusbtn_Purple_Over";
    ReduceButton.SetTexture(btnString_None, btnString_Down, btnString_Over);
    return;
}

function CloseMultilayer()
{
    local string ComboboxName, ComboBoxShadowName, wndname, btnString_None, btnString_Down, btnString_Over;

    wndname = currentWndName();
    ComboBoxShadowName = wndname $ ".ComboBoxShadow";
    ComboboxName = wndname $ ".FloorComboBox";
    Class'NWindow.UIAPI_COMBOBOX'.static.Clear(ComboboxName);
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(ComboboxName);
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(ComboBoxShadowName);
    btnString_None = "L2ui_ct1.Minimap.Minimap_df_Minusbtn_Blue";
    btnString_Down = "L2ui_ct1.Minimap.Minimap_df_Minusbtn_Blue_Down";
    btnString_Over = "L2ui_ct1.Minimap.Minimap_df_Minusbtn_Blue_Over";
    ReduceButton.SetTexture(btnString_None, btnString_Down, btnString_Over);
    return;
}

function HandleSeedMapInfo(string param)
{
    local int i, nSeedCount;
    local MinimapRegionInfo RegionInfo;
    local MinimapRegionIconData IconData;
    local string toolTipParam, HuntingZoneName;
    local int huntingZoneId, huntingZoneIndex, SeedMessageNum;
    local bool bUse;
    local HuntingZoneUIData huntingZoneData;

    // End:0x15
    if(getInstanceUIData().getIsClassicServer())
    {
        return;
    }
    ParseInt(param, "SeedCount", nSeedCount);
    i = 0;
    J0x37:

    // End:0x24F [Loop If]
    if(i < nSeedCount)
    {
        ParseInt(param, "HuntingZoneID_" $ string(i), huntingZoneId);
        ParseInt(param, "SysMsgNo_" $ string(i), SeedMessageNum);
        // End:0xB0
        if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(huntingZoneId) == false)
        {
            // [Explicit Continue]
            goto J0x245;
        }
        RegionInfo.eType = 3;
        // End:0x245
        if((huntingZoneId == 303) || huntingZoneId == 286)
        {
            Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(huntingZoneId, huntingZoneData);
            toolTipParam = "";
            ParamAdd(toolTipParam, "Type", string(RegionInfo.eType));
            ParamAdd(toolTipParam, "Index", string(huntingZoneId));
            ParamAdd(toolTipParam, "SeedMessage", GetSystemMessage(SeedMessageNum));
            RegionInfo.nIndex = huntingZoneData.nRegionID;
            RegionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
            RegionInfo.strDesc = huntingZoneData.strName;
            RegionInfo.strTooltip = toolTipParam;
            GetMinimapRegionIconData(huntingZoneData.nRegionID, IconData);
            RegionInfo.IconData = IconData;
            addMapIcon(RegionInfo, true);
            // End:0x245
            if(huntingZoneId == 286)
            {
                bUse = false;
                switch(SeedMessageNum)
                {
                    // End:0x20D
                    case 4432:
                        bUse = true;
                        // End:0x213
                        break;
                    // End:0xFFFF
                    default:
                        // End:0x213
                        break;
                        break;
                }
                setServerParse(6, GetSystemMessage(SeedMessageNum), bUse, huntingZoneData.nWorldLoc, huntingZoneData.nRegionID, SeedMessageNum);
            }
        }
        J0x245:

        i++;
        // [Loop Continue]
        goto J0x37;
    }
    DelayRequestSeedInfo = 0;
    return;
}

function HandleChatmessage(string param)
{
    local int SystemMsgIndex;

    ParseInt(param, "Index", SystemMsgIndex);
    switch(SystemMsgIndex)
    {
        // End:0x68
        case 2090:
            GlobalCurFortressStatus = true;
            // End:0x4B
            if(ReduceButton.IsShowWindow())
            {
                ExecuteFortressSiegeStatus("");                
            }
            else
            {
                // End:0x65
                if(!ReduceButton.IsShowWindow())
                {
                    RequestFortressSiegeInfo();
                }
            }
            // End:0x112
            break;
        // End:0x70
        case 2164:
        // End:0x78
        case 2165:
        // End:0xC2
        case 2166:
            GlobalCurFortressStatus = true;
            // End:0xA5
            if(ReduceButton.IsShowWindow())
            {
                ExecuteFortressSiegeStatus("");                
            }
            else
            {
                // End:0xBF
                if(!ReduceButton.IsShowWindow())
                {
                    RequestFortressSiegeInfo();
                }
            }
            // End:0x112
            break;
        // End:0x10C
        case 2183:
            GlobalCurFortressStatus = false;
            // End:0xEF
            if(ReduceButton.IsShowWindow())
            {
                ExecuteFortressSiegeStatus("");                
            }
            else
            {
                // End:0x109
                if(!ReduceButton.IsShowWindow())
                {
                    RequestFortressSiegeInfo();
                }
            }
            // End:0x112
            break;
        // End:0xFFFF
        default:
            // End:0x112
            break;
            break;
    }
    return;
}

function HandleZoneTitle()
{
    local int nZoneID;

    nZoneID = GetCurrentZoneID();
    // End:0x75
    if(IsHideMinimapZone(nZoneID))
    {
        // End:0x6A
        if(Me.IsShowWindow() && !IsBuilderPC())
        {
            Me.HideWindow();
            // End:0x5F
            if(bMiniMapDisabled)
            {
                AddSystemMessage(2205);                
            }
            else
            {
                AddSystemMessage(2207);
            }
        }
        bMiniMapDisabled = false;        
    }
    else
    {
        // End:0x8C
        if(bMiniMapDisabled == false)
        {
            AddSystemMessage(2206);
        }
        bMiniMapDisabled = true;
    }
    // End:0xFD
    if(IsHideMinimapZone_new(nZoneID))
    {
        // End:0xF2
        if(Me.IsShowWindow() && !IsBuilderPC())
        {
            Me.HideWindow();
            // End:0xE7
            if(bMiniMapDisabled)
            {
                AddSystemMessage(2205);                
            }
            else
            {
                AddSystemMessage(2207);
            }
        }
        bMiniMapDisabled = false;        
    }
    else
    {
        // End:0x114
        if(bMiniMapDisabled == false)
        {
            AddSystemMessage(2206);
        }
        bMiniMapDisabled = true;
    }
    return;
}

function HandleDungeonMapRefresh(string param)
{
    local int Index;

    ParseInt(param, "Index", Index);
    // End:0x56
    if(Index == 8888)
    {
        // End:0x56
        if(Me.IsShowWindow())
        {
            Me.HideWindow();
            Me.ShowWindow();
        }
    }
    return;
}

function FilterDungeonMap()
{
    local Vector MyPosition;

    MyPosition = GetPlayerPosition();
    // End:0xB3
    if((((MyPosition.X > BlockedLoc1.X) && MyPosition.X < BlockedLoc2.X) && MyPosition.Y > BlockedLoc1.Y) && MyPosition.Y < BlockedLoc2.Y)
    {
        // End:0xB3
        if(!IsBuilderPC())
        {
            Class'NWindow.UIAPI_MINIMAPCTRL'.static.RequestReduceBtn("MinimapWnd.Minimap");
            ReduceButton.HideWindow();
        }
    }
    return;
}

function RequestRedrawCastle()
{
    m_MiniMap.EraseRegionInfoByType(0);
    RequestAllCastleInfo();
    return;
}

function RequestRedrawFortress()
{
    m_MiniMap.EraseRegionInfoByType(1);
    RequestAllFortressInfo();
    return;
}

function RequestRedrawAllCastleType()
{
    m_MiniMap.EraseRegionInfoByType(0);
    m_MiniMap.EraseRegionInfoByType(1);
    RequestAllCastleInfo();
    RequestAllFortressInfo();
    RequestFortressSiegeInfo();
    return;
}

function OnShow()
{
    Me.KillTimer(225);
    buildCaches();
    // End:0x96
    if(!IsLockRequest())
    {
        RequestRedrawAllCastleType();
        ListTrackItem3.DeleteAllItem();
        RequestRaidRecord();
        RequestDominionInfo();
        Class'NWindow.MiniMapAPI'.static.RequestCursedWeaponList();
        Class'NWindow.MiniMapAPI'.static.RequestShowAgitSiegeInfo();
        Class'NWindow.MiniMapAPI'.static.RequestCursedWeaponLocation();
        RequestInzoneWaitingTime(false);
        HandleZoneTitle();
        SetDirIconDest();
        ContinentLoc();
        showMapIconElement();
        LockRequest(true);
    }
    Class'NWindow.AudioAPI'.static.PlaySound("interfacesound.Interface.map_open_01");
    AdjustMapToPlayerPosition(true);
    return;
}

function LockRequest(bool bLock)
{
    bLockRequest = bLock;
    Me.KillTimer(5555);
    // End:0x43
    if(bLockRequest)
    {
        Me.SetTimer(5555, 500);
    }
    return;
}

function bool IsLockRequest()
{
    return bLockRequest;
    return;
}

function OnTimer(int TimerID)
{
    // End:0x2A
    if(TimerID == 5555)
    {
        Me.KillTimer(5555);
        LockRequest(false);
    }
    // End:0x5A
    if(TimerID == 225)
    {
        m_MiniMap.EraseRegionInfoCtrl(8, 100);
        Me.KillTimer(225);
    }
    return;
}

function buildCaches()
{
    local int i;
    local HuntingZoneUIData huntingZoneData;
    local HuntingZoneUIDataEx dataEx;
    local RaidUIData raidData;
    local int recLvMin, recLvMax;

    // End:0x94
    if(huntZoneDataCache.Length <= 0)
    {
        i = 0;
        J0x13:

        // End:0x94 [Loop If]
        if(i < 1000)
        {
            // End:0x3F
            if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i) == false)
            {
                // [Explicit Continue]
                goto J0x8A;
            }
            Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
            dataEx.huntingZoneId = i;
            dataEx.huntingZoneCache = huntingZoneData;
            huntZoneDataCache[huntZoneDataCache.Length] = dataEx;
            J0x8A:

            i++;
            // [Loop Continue]
            goto J0x13;
        }
    }
    // End:0x142
    if(RaidUIDataCache.Length <= 0)
    {
        Class'NWindow.UIDATA_RAID'.static.GetRaidDataKeyList(raidDataKeyListCache);
        i = 0;
        J0xBB:

        // End:0x142 [Loop If]
        if(i < raidDataKeyListCache.Length)
        {
            Class'NWindow.UIDATA_RAID'.static.GetRaidRecommendLevel(raidDataKeyListCache[i], recLvMin, recLvMax);
            raidData = getRaidDataByIndex(raidDataKeyListCache[i]);
            raidData.nReqMinLevel = recLvMin;
            raidData.nReqMaxLevel = recLvMax;
            RaidUIDataCache[RaidUIDataCache.Length] = raidData;
            i++;
            // [Loop Continue]
            goto J0xBB;
        }
    }
    return;
}

function addMapIcon(MinimapRegionInfo RegionInfo, optional bool bUpdate)
{
    // End:0x120
    if(!isVectorZeroXYZ(float(RegionInfo.IconData.nWorldLocX), float(RegionInfo.IconData.nWorldLocX), float(RegionInfo.IconData.nWorldLocZ)))
    {
        // End:0xB5
        if(bUpdate)
        {
            m_MiniMap.UpdateRegionInfoCtrl(RegionInfo);
            switch(RegionInfo.eType)
            {
                // End:0x6C
                case 3:
                // End:0x71
                case 0:
                // End:0x76
                case 1:
                // End:0x92
                case 2:
                    TeleportBookMarkWnd_MiniMap.UpdateRegionInfoCtrl(RegionInfo);
                    // End:0x98
                    break;
                // End:0xFFFF
                default:
                    // End:0x98
                    break;
                    break;
            }
            switch(RegionInfo.eType)
            {
                // End:0xAC
                case 0:
                    // End:0xB2
                    break;
                // End:0xFFFF
                default:
                    // End:0xB2
                    break;
                    break;
            }            
        }
        else
        {
            m_MiniMap.AddRegionInfoCtrl(RegionInfo);
            switch(RegionInfo.eType)
            {
                // End:0xDA
                case 3:
                // End:0xDF
                case 0:
                // End:0xE4
                case 1:
                // End:0x100
                case 2:
                    TeleportBookMarkWnd_MiniMap.AddRegionInfoCtrl(RegionInfo);
                    // End:0x106
                    break;
                // End:0xFFFF
                default:
                    // End:0x106
                    break;
                    break;
            }
            switch(RegionInfo.eType)
            {
                // End:0x11A
                case 0:
                    // End:0x120
                    break;
                // End:0xFFFF
                default:
                    // End:0x120
                    break;
                    break;
            }
        }
    }
    return;
}

function showMapIconElement()
{
    local HuntingZoneUIData huntingZoneData;
    local int huntingZoneId;
    local MinimapRegionIconData IconData;
    local MinimapRegionInfo RegionInfo;
    local int i;
    local string toolTipParam;
    local RaidUIData raidData;
    local int recLvMin, recLvMax;
    local UserInfo pUser;

    // End:0x1CC
    if(bCompleteBaseElementShow)
    {
        m_MiniMap.EraseRegionInfoByType(6);
        m_MiniMap.EraseRegionInfoByType(5);
        m_MiniMap.EraseRegionInfoByType(7);
        i = 0;
        J0x43:

        // End:0xFF [Loop If]
        if(i < huntZoneDataCache.Length)
        {
            huntingZoneData = huntZoneDataCache[i].huntingZoneCache;
            huntingZoneId = huntZoneDataCache[i].huntingZoneId;
            // End:0xC3
            if(((huntingZoneData.nType == 1) || huntingZoneData.nType == 2) || huntingZoneData.nType == 10)
            {
                drawMinimapRegionInfo(5, i, true);
            }
            // End:0xF5
            if((huntingZoneData.nType == 3) || huntingZoneData.nType == 4)
            {
                drawMinimapRegionInfo(6, i, true);
            }
            i++;
            // [Loop Continue]
            goto J0x43;
        }
        GetPlayerInfo(pUser);
        i = 0;
        J0x111:

        // End:0x1C9 [Loop If]
        if(i < RaidUIDataCache.Length)
        {
            raidData = RaidUIDataCache[i];
            // End:0x15F
            if((tryLevelCheck(pUser.nLevel, raidData.nReqMinLevel, raidData.nReqMaxLevel)) == false)
            {
                // [Explicit Continue]
                goto J0x1BF;
            }
            // End:0x1AB
            if(((raidData.nWorldLoc.X == float(0)) && raidData.nWorldLoc.Y == float(0)) && raidData.nWorldLoc.Z == float(0))
            {
                // [Explicit Continue]
                goto J0x1BF;
            }
            drawMinimapRegionInfo(7, raidDataKeyListCache[i], false);
            J0x1BF:

            i++;
            // [Loop Continue]
            goto J0x111;
        }        
    }
    else
    {
        i = 0;
        J0x1D3:

        // End:0x3C8 [Loop If]
        if(i < huntZoneDataCache.Length)
        {
            huntingZoneData = huntZoneDataCache[i].huntingZoneCache;
            huntingZoneId = huntZoneDataCache[i].huntingZoneId;
            // End:0x222
            if(huntingZoneData.nRegionID <= 0)
            {
                // [Explicit Continue]
                goto J0x3BE;
            }
            // End:0x268
            if(((huntingZoneData.nType == 1) || huntingZoneData.nType == 2) || huntingZoneData.nType == 10)
            {
                drawMinimapRegionInfo(5, i);                
            }
            else
            {
                // End:0x29A
                if((huntingZoneData.nType == 3) || huntingZoneData.nType == 4)
                {
                    drawMinimapRegionInfo(6, i, true);
                }
            }
            // End:0x3BE
            if(huntingZoneData.nRegionID > 0)
            {
                // End:0x2C1
                if(huntingZoneData.nType == 8)
                {
                    // [Explicit Continue]
                    goto J0x3BE;                    
                }
                else
                {
                    // End:0x2E2
                    if(huntingZoneData.nType == 5)
                    {
                        RegionInfo.eType = 2;                        
                    }
                    else
                    {
                        // End:0x2F9
                        if(huntingZoneData.nType == 9)
                        {
                            // [Explicit Continue]
                            goto J0x3BE;                            
                        }
                        else
                        {
                            RegionInfo.eType = 3;
                        }
                    }
                }
                toolTipParam = "";
                ParamAdd(toolTipParam, "Type", string(RegionInfo.eType));
                ParamAdd(toolTipParam, "Index", string(huntingZoneId));
                RegionInfo.DescColor = getInstanceL2Util().ColorMinimapFont;
                RegionInfo.strDesc = huntingZoneData.strName;
                RegionInfo.strTooltip = toolTipParam;
                GetMinimapRegionIconData(huntingZoneData.nRegionID, IconData);
                RegionInfo.IconData = IconData;
                addMapIcon(RegionInfo);
                UpdateRegionData(RegionInfo);
            }
            J0x3BE:

            i++;
            // [Loop Continue]
            goto J0x1D3;
        }
        i = 0;
        J0x3CF:

        // End:0x45A [Loop If]
        if(i < RaidUIDataCache.Length)
        {
            raidData = RaidUIDataCache[i];
            // End:0x43C
            if(((raidData.nWorldLoc.X == float(0)) && raidData.nWorldLoc.Y == float(0)) && raidData.nWorldLoc.Z == float(0))
            {
                // [Explicit Continue]
                goto J0x450;
            }
            drawMinimapRegionInfo(7, raidDataKeyListCache[i], false);
            J0x450:

            i++;
            // [Loop Continue]
            goto J0x3CF;
        }
    }
    bCompleteBaseElementShow = true;
    return;
}

function SetDirIconDest()
{
    local Vector playerPos, questLoc;
    local string questTooltipStr;

    playerPos = GetPlayerPosition();
    m_MiniMap.SetDirIconDest(1, playerPos, GetSystemString(887));
    questLoc = QuestTreeWnd(GetScript("QuestTreeWnd")).getCurrentQuestDirectTargetPos();
    questTooltipStr = QuestTreeWnd(GetScript("QuestTreeWnd")).getCurrentQuestDirectTargetString();
    // End:0xA6
    if(questTooltipStr != "")
    {
        m_MiniMap.SetDirIconDest(0, questLoc, questTooltipStr);
    }
    return;
}

function ContinentLoc()
{
    local Vector MyPosition;

    MyPosition = GetPlayerPosition();
    // End:0x41
    if(m_MiniMap.GetContinent(MyPosition) == 1)
    {
        SetContinent(1);
        m_MapSelectTab.SetTopOrder(0, true);        
    }
    else
    {
        // End:0x73
        if(m_MiniMap.GetContinent(MyPosition) == 0)
        {
            SetContinent(0);
            m_MapSelectTab.SetTopOrder(1, true);
        }
    }
    return;
}

function SetCurrentLocation()
{
    local string ZoneName;

    ZoneName = GetCurrentZoneName();
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("Minimapwnd.txtVarCurLoc", ZoneName);
    return;
}

function OnHide()
{
    // End:0x37
    if(GetWindowHandle("GuideWnd").IsShowWindow())
    {
        GetWindowHandle("GuideWnd").HideWindow();
    }
    Class'NWindow.AudioAPI'.static.PlaySound("interfacesound.Interface.map_close_01");
    initServerInfoArray();
    initServerButton();
    Me.KillTimer(225);
    m_MiniMap.EraseRegionInfoCtrl(8, 100);
    return;
}

function HandlePartyMemberChanged(string a_Param)
{
    ParseInt(a_Param, "PartyMemberCount", m_PartyMemberCount);
    return;
}

function bool IsExpandState()
{
    local int W, h;

    GetWindowHandle(m_WindowName).GetWindowSize(W, h);
    // End:0x30
    if(W >= 800)
    {
        return true;
    }
    return false;
    return;
}

function HandleShowMinimap(string a_Param)
{
    // End:0x2A
    if(IsShowWindow("MinimapWnd"))
    {
        HideWindow("MinimapWnd");        
    }
    else
    {
        ShowWindowWithFocus("MinimapWnd");
    }
    return;
}

function HandleMinimapAddTarget(string a_Param)
{
    local Vector loc;

    // End:0xA7
    if(((ParseFloat(a_Param, "X", loc.X)) && ParseFloat(a_Param, "Y", loc.Y)) && ParseFloat(a_Param, "Z", loc.Z))
    {
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AddTarget("MinimapWnd.Minimap", loc);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", loc, false, false);
    }
    return;
}

function HandleMinimapDeleteTarget(string a_Param)
{
    local Vector loc;
    local int locX, locY, locZ;

    // End:0xA4
    if(((ParseInt(a_Param, "X", locX)) && ParseInt(a_Param, "Y", locY)) && ParseInt(a_Param, "Z", locZ))
    {
        loc.X = float(locX);
        loc.Y = float(locY);
        loc.Z = float(locZ);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.DeleteTarget("MinimapWnd.Minimap", loc);
    }
    return;
}

function HandleMinimapDeleteAllTarget()
{
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.DeleteAllTarget("MinimapWnd.Minimap");
    return;
}

function HandleMinimapShowQuest()
{
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.SetShowQuest("MinimapWnd.Minimap", true);
    return;
}

function HandleMinimapHideQuest()
{
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.SetShowQuest("MinimapWnd.Minimap", false);
    return;
}

function OnComboBoxItemSelected(string sName, int Index)
{
    switch(sName)
    {
        // End:0x27
        case "FloorComboBox":
            select_floor(Index);
            // End:0x2D
            break;
        // End:0xFFFF
        default:
            // End:0x2D
            break;
            break;
    }
    return;
}

function select_floor(int Index)
{
    local int tmpNum;
    local string wndname, ComboboxName;

    wndname = currentWndName();
    ComboboxName = wndname $ ".FloorComboBox";
    tmpNum = Index + 1;
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.ShowCertainLayer(wndname $ ".Minimap", tmpNum);
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum(ComboboxName, Index);
    return;
}

function OnClickButton(string a_ButtonID)
{
    switch(a_ButtonID)
    {
        // End:0x20
        case "MyLocButton":
            OnClickMyLocButton();
            // End:0x2EF
            break;
        // End:0x3C
        case "PartyLocButton":
            OnClickPartyLocButton();
            // End:0x2EF
            break;
        // End:0x12E
        case "OpenGuideWnd":
            // End:0xBF
            if(GetWindowHandle("GuideWnd").IsShowWindow())
            {
                isNoShowMissionWindow = 1;
                SetINIBool("MinimapWnd", "l", numToBool(isNoShowMissionWindow), "windowsInfo.ini");
                GetWindowHandle("GuideWnd").HideWindow();                
            }
            else
            {
                isNoShowMissionWindow = 0;
                SetINIBool("MinimapWnd", "l", numToBool(isNoShowMissionWindow), "windowsInfo.ini");
                GetWindowHandle("GuideWnd").ShowWindow();
                GetWindowHandle("GuideWnd").SetFocus();
            }
            // End:0x2EF
            break;
        // End:0x145
        case "btnReduce":
            OnClickReduceButton();
            // End:0x2EF
            break;
        // End:0x160
        case "Btn_Refresh":
            ExecuteFortressSiegeStatus("");
            // End:0x2EF
            break;
        // End:0x1D9
        case "MapSelectTab1":
            // End:0x182
            if(IsExpandState())
            {
                setMapSize(true);
            }
            SetContinent(0);
            InitializeLocation();
            Class'NWindow.UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon("MinimapWnd.Minimap");
            // End:0x1CA
            if(isActiveCursedWeapon())
            {
                Class'NWindow.MiniMapAPI'.static.RequestCursedWeaponLocation();
            }
            SetDirIconDest();
            RequestDominionInfo();
            // End:0x2EF
            break;
        // End:0x261
        case "MapSelectTab0":
            // End:0x200
            if(getInstanceUIData().getIsClassicServer())
            {
                return;
            }
            // End:0x210
            if(IsExpandState())
            {
                setMapSize(true);
            }
            SetContinent(1);
            Class'NWindow.UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon("MinimapWnd.Minimap");
            // End:0x252
            if(isActiveCursedWeapon())
            {
                Class'NWindow.MiniMapAPI'.static.RequestCursedWeaponLocation();
            }
            InitializeLocation();
            SetDirIconDest();
            // End:0x2EF
            break;
        // End:0x27B
        case "ExpandButton":
            expandMapSize();
            // End:0x2EF
            break;
        // End:0x293
        case "ServerInfo01_Button":
        // End:0x2AB
        case "ServerInfo02_Button":
        // End:0x2C3
        case "ServerInfo03_Button":
        // End:0x2E9
        case "ServerInfo04_Button":
            clickServerInfoButton(a_ButtonID);
            // End:0x2EF
            break;
        // End:0xFFFF
        default:
            // End:0x2EF
            break;
            break;
    }
    return;
}

function bool isSameContinent()
{
    return m_MiniMap.GetContinent(GetPlayerPosition()) == m_CurContinent;
    return;
}

function expandMapSize(optional bool bForceExpandSize)
{
    local int gWidth, gHeight;

    Me.GetWindowSize(gWidth, gHeight);
    Debug("bIsTownMap" @ string(bIsTownMap));
    Debug("nTownMapZoneID" @ string(nTownMapZoneID));
    Debug("GetCurrentZoneID()" @ string(GetCurrentZoneID()));
    // End:0x11E
    if(800 <= gWidth)
    {
        setMapSize(false);
        GetButtonHandle(m_WindowName $ ".ExpandButton").SetButtonName(1474);
        // End:0x11B
        if(m_MiniMap.GetContinent(GetPlayerPosition()) == m_CurContinent)
        {
            // End:0xF2
            if(!bIsTownMap)
            {
                AdjustMapToPlayerPosition(bIsTownMap);                
            }
            else
            {
                // End:0x11B
                if((nTownMapZoneID == GetCurrentZoneID()) || nTownMapZoneID == 0)
                {
                    AdjustMapToPlayerPosition(bIsTownMap);
                }
            }
        }        
    }
    else
    {
        smallMapRect = Me.GetRect();
        setMapSize(true);
        GetButtonHandle(m_WindowName $ ".ExpandButton").SetButtonName(2734);
        // End:0x1C7
        if(m_MiniMap.GetContinent(GetPlayerPosition()) == m_CurContinent)
        {
            // End:0x19E
            if(!bIsTownMap)
            {
                AdjustMapToPlayerPosition(bIsTownMap);                
            }
            else
            {
                // End:0x1C7
                if((nTownMapZoneID == GetCurrentZoneID()) || nTownMapZoneID == 0)
                {
                    AdjustMapToPlayerPosition(bIsTownMap);
                }
            }
        }
    }
    return;
}

function setMapSize(bool bBigSize)
{
    local int wSum, hSum, MoveX, MoveY;
    local Rect Rect;

    // End:0x2EE
    if(bBigSize)
    {
        Rect = Me.GetRect();
        wSum = (377 + (getExtendMapSize())) - 800;
        // End:0x60
        if(getInstanceUIData().getScreenHeight() >= 1024)
        {
            hSum = 1024;            
        }
        else
        {
            hSum = getInstanceUIData().getScreenHeight();
        }
        Me.SetWindowSize(getExtendMapSize(), hSum);
        m_MiniMap.SetWindowSize(411 + wSum, hSum - 95);
        GetTextureHandle(m_WindowName $ ".texShadowBottom").SetWindowSize(411 + wSum, 43);
        GetTextureHandle(m_WindowName $ ".TexMapStroke").SetWindowSize(413 + wSum, hSum - 93);
        GetTextureHandle(m_WindowName $ ".TexMapStrokeGrow").SetWindowSize(413 + wSum, hSum - 93);
        GetTextureHandle(m_WindowName $ ".texShadowTop").SetWindowSize(411 + wSum, 43);
        GetTextureHandle(m_WindowName $ ".TabBg").SetWindowSize(424 + wSum, hSum - 59);
        // End:0x22E
        if(getInstanceUIData().getIsClassicServer())
        {
            TabBg_Line.SetWindowSize((318 + wSum) + 86, 23);
            TabBg_Line.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 101, 31);            
        }
        else
        {
            TabBg_Line.SetWindowSize((140 + wSum) + 86, 23);
            TabBg_Line.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 193, 31);
        }
        MoveX = Rect.nX;
        MoveY = 1;
        // End:0x2D2
        if((Rect.nX + (getExtendMapSize())) > getInstanceUIData().getScreenWidth())
        {
            MoveX = getInstanceUIData().getScreenWidth() - (getExtendMapSize());
        }
        Me.MoveTo(MoveX, MoveY);        
    }
    else
    {
        Me.MoveTo(smallMapRect.nX, smallMapRect.nY);
        Me.SetWindowSize(423, 508);
        m_MiniMap.SetWindowSize(411, 413);
        GetTextureHandle(m_WindowName $ ".texShadowBottom").SetWindowSize(411, 43);
        GetTextureHandle(m_WindowName $ ".TexMapStroke").SetWindowSize(413, 415);
        GetTextureHandle(m_WindowName $ ".TexMapStrokeGrow").SetWindowSize(413, 415);
        GetTextureHandle(m_WindowName $ ".TabBg").SetWindowSize(424, 447);
        // End:0x45A
        if(getInstanceUIData().getIsClassicServer())
        {
            TabBg_Line.SetWindowSize(318 + 86, 23);
            TabBg_Line.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 101, 31);            
        }
        else
        {
            TabBg_Line.SetWindowSize(140 + 86, 23);
            TabBg_Line.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 193, 31);
        }
    }
    // End:0x4D2
    if(GetWindowHandle("GuideWnd").IsShowWindow())
    {
        GetWindowHandle("GuideWnd").SetFocus();
    }
    return;
}

function int getExtendMapSize()
{
    local int nSize;

    // End:0x21
    if(getInstanceUIData().getIsClassicServer())
    {
        nSize = 1024;        
    }
    else
    {
        // End:0x44
        if(m_MapSelectTab.GetTopIndex() == 0)
        {
            nSize = 834;            
        }
        else
        {
            nSize = 1024;
        }
    }
    return nSize;
    return;
}

function OnClickReduceButton()
{
    Debug("OnClickReduceButton");
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.RequestReduceBtn("MinimapWnd.Minimap");
    HideWindow("MinimapWnd.btnReduce");
    RequestFortressSiegeInfo();
    HandleZoneTitle();
    return;
}

function OnClickTargetButton()
{
    // End:0x12C
    if(GetQuestLocation(QuestLocation))
    {
        SetLocContinent(QuestLocation);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", QuestLocation, false);
        // End:0x91
        if(((QuestLocation.X == float(19714)) && QuestLocation.Y == float(243420)) && QuestLocation.Z == float(-205))
        {
            OnClickReduceButton();            
        }
        else
        {
            // End:0xE0
            if(((QuestLocation.X == float(8800)) && QuestLocation.Y == float(251652)) && QuestLocation.Z == float(-2032))
            {
                OnClickReduceButton();                
            }
            else
            {
                // End:0x12C
                if(((QuestLocation.X == float(27491)) && QuestLocation.Y == float(247340)) && QuestLocation.Z == float(-3256))
                {
                    OnClickReduceButton();
                }
            }
        }
    }
    return;
}

function OnClickMyLocButton()
{
    AdjustMapToPlayerPosition(true);
    return;
}

function AdjustMapToPlayerPosition(bool a_ZoomToTownMap)
{
    local Vector PlayerPosition;

    PlayerPosition = GetPlayerPosition();
    SetLocContinent(PlayerPosition);
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", PlayerPosition, a_ZoomToTownMap);
    return;
}

function OnClickPartyLocButton()
{
    local Vector PartyMemberLocation;

    m_PartyMemberCount = GetPartyMemberCount();
    // End:0x19
    if(0 == m_PartyMemberCount)
    {
        return;
    }
    m_PartyLocIndex = int(float(m_PartyLocIndex + 1) % float(m_PartyMemberCount));
    // End:0x7B
    if(GetPartyMemberLocation(m_PartyLocIndex, PartyMemberLocation))
    {
        SetLocContinent(PartyMemberLocation);
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", PartyMemberLocation, false);
    }
    return;
}

function HandleCursedWeaponLoctaion(string param)
{
    local int Num, ItemID, ItemID1, ItemID2, isowndedo, isownded1,
	    isownded2, X, Y, Z, i;

    local Vector CursedWeaponLoc1, CursedWeaponLoc2;
    local string cursedName, cursedName1, cursedName2;
    local Vector cursedWeaponLocation;
    local bool combined;

    ParseInt(param, "NUM", Num);
    // End:0x48
    if(Num == 0)
    {
        Class'NWindow.UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon("MinimapWnd.Minimap");
        return;        
    }
    else
    {
        i = 0;
        J0x4F:

        // End:0x237 [Loop If]
        if(i < Num)
        {
            ParseInt(param, "ID" $ string(i), ItemID);
            ParseString(param, "NAME" $ string(i), cursedName);
            ParseInt(param, "ISOWNED" $ string(i), isowndedo);
            ParseInt(param, "X" $ string(i), X);
            ParseInt(param, "Y" $ string(i), Y);
            ParseInt(param, "Z" $ string(i), Z);
            cursedWeaponLocation.X = float(X);
            cursedWeaponLocation.Y = float(Y);
            cursedWeaponLocation.Z = float(Z);
            Normal(cursedWeaponLocation);
            // End:0x1C6
            if(ItemID == 8190)
            {
                ItemID1 = ItemID;
                cursedName1 = cursedName;
                isownded1 = isowndedo;
                CursedWeaponLoc1.X = cursedWeaponLocation.X;
                CursedWeaponLoc1.Y = cursedWeaponLocation.Y;
                CursedWeaponLoc1.Z = cursedWeaponLocation.Z;
                Normal(CursedWeaponLoc1);
                // [Explicit Continue]
                goto J0x22D;
            }
            ItemID2 = ItemID;
            cursedName2 = cursedName;
            isownded2 = isowndedo;
            CursedWeaponLoc2.X = cursedWeaponLocation.X;
            CursedWeaponLoc2.Y = cursedWeaponLocation.Y;
            CursedWeaponLoc2.Z = cursedWeaponLocation.Z;
            Normal(CursedWeaponLoc2);
            J0x22D:

            i++;
            // [Loop Continue]
            goto J0x4F;
        }
    }
    // End:0x2DB
    if(Num == 1)
    {
        // End:0x296
        if(ItemID == 8190)
        {
            DrawCursedWeapon("MinimapWnd.Minimap", ItemID1, cursedName1, CursedWeaponLoc1, isownded1 == 0, true);
            setServerParse(3, "", true, CursedWeaponLoc1);            
        }
        else
        {
            DrawCursedWeapon("MinimapWnd.Minimap", ItemID2, cursedName2, CursedWeaponLoc2, isownded2 == 0, true);
            setServerParse(4, "", true, CursedWeaponLoc2);
        }        
    }
    else
    {
        // End:0x456
        if(Num == 2)
        {
            combined = Class'NWindow.UIAPI_MINIMAPCTRL'.static.IsOverlapped("MinimapWnd.Minimap", int(CursedWeaponLoc1.X), int(CursedWeaponLoc1.Y), int(CursedWeaponLoc2.X), int(CursedWeaponLoc2.Y));
            // End:0x3D2
            if(combined)
            {
                Class'NWindow.UIAPI_MINIMAPCTRL'.static.DrawGridIcon("MinimapWnd.Minimap", "L2UI_CH3.MiniMap.cursedmapicon00", "L2UI_CH3.MiniMap.cursedmapicon00", CursedWeaponLoc1, true, 0, -12, (cursedName1 $ "\\n") $ cursedName2);                
            }
            else
            {
                DrawCursedWeapon("MinimapWnd.Minimap", ItemID1, cursedName1, CursedWeaponLoc1, isownded1 == 0, true);
                DrawCursedWeapon("MinimapWnd.Minimap", ItemID2, cursedName2, CursedWeaponLoc2, isownded2 == 0, false);
            }
            setServerParse(3, "", true, CursedWeaponLoc1);
            setServerParse(4, "", true, CursedWeaponLoc2);
        }
    }
    return;
}

function DrawCursedWeapon(string WindowName, int ItemID, string cursedName, Vector vecLoc, bool bDropped, bool bRefresh)
{
    local string itemIconName;

    // End:0x3A
    if(ItemID == 8190)
    {
        itemIconName = "L2UI_CH3.MiniMap.cursedmapicon01";        
    }
    else
    {
        // End:0x71
        if(ItemID == 8689)
        {
            itemIconName = "L2UI_CH3.MiniMap.cursedmapicon02";
        }
    }
    // End:0x8E
    if(bDropped)
    {
        itemIconName = itemIconName $ "_drop";
    }
    Class'NWindow.UIAPI_MINIMAPCTRL'.static.DrawGridIcon(WindowName, itemIconName, "L2UI_CH3.MiniMap.cursedmapicon00", vecLoc, bRefresh, 0, -12, cursedName);
    return;
}

function HandleUpdateGameTime(string a_Param)
{
    local int GameHour, GameMinute;
    local string GameTimeString;

    ParseInt(a_Param, "GameHour", GameHour);
    ParseInt(a_Param, "GameMinute", GameMinute);
    GameTimeString = "";
    // End:0x72
    if(Me.IsShowWindow())
    {
        DelayRequestSeedInfo++;
        // End:0x72
        if(DelayRequestSeedInfo == 60)
        {
            Class'NWindow.MiniMapAPI'.static.RequestSeedPhase();
        }
    }
    SelectSunOrMoon(GameHour);
    // End:0x90
    if(GameHour == 0)
    {
        GameHour = 12;
    }
    GameTimeString = (GameTimeString $ string(GameHour)) $ " : ";
    // End:0xD3
    if(GameMinute < 10)
    {
        GameTimeString = (GameTimeString $ "0") $ string(GameMinute);        
    }
    else
    {
        GameTimeString = GameTimeString $ string(GameMinute);
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MinimapWnd.txtGameTime", GameTimeString);
    return;
}

function HandleMinimapTravel(string a_Param)
{
    local int TravelX, TravelY;

    // End:0x20
    if(!ParseInt(a_Param, "TravelX", TravelX))
    {
        return;
    }
    // End:0x40
    if(!ParseInt(a_Param, "TravelY", TravelY))
    {
        return;
    }
    ExecuteCommand(("//teleport" @ string(TravelX)) @ string(TravelY));
    return;
}

function SelectSunOrMoon(int GameHour)
{
    // End:0x50
    if((GameHour >= 6) && GameHour <= 24)
    {
        ShowWindow("MinimapWnd.texSun");
        HideWindow("MinimapWnd.texMoon");        
    }
    else
    {
        ShowWindow("MinimapWnd.texMoon");
        HideWindow("MinimapWnd.texSun");
    }
    return;
}

function DrawPeaceStatusFortressSiegeStatus(string param)
{
    local int ZoneID;

    ParseInt(param, "ZoneID", ZoneID);
    G_ZoneID = ZoneID;
    // End:0x31
    if(ZoneID == 0)
    {        
    }
    else
    {
        DrawMapBasicInfo(FortressID2ZoneNameID(ZoneID));
    }
    return;
}

function InitializeLocationByContinent()
{
    local Vector Location;

    // End:0x3E
    if(m_CurContinent == 0)
    {
        Location.X = -86916.0000000;
        Location.Y = 222183.0000000;
        Location.Z = -4656.0000000;        
    }
    else
    {
        // End:0x79
        if(m_CurContinent == 1)
        {
            Location.X = -181823.0000000;
            Location.Y = 224580.0000000;
            Location.Z = -4104.0000000;
        }
    }
    m_MiniMap.AdjustMapView(Location, false);
    return;
}

function HandleShowFortressMapInfo(string param)
{
    ParseInt(param, "FortressID", FortressID);
    ParseInt(param, "SiegeStatus", SiegeStatus);
    ParseInt(param, "TotalBarrackCnt", TotalBarrackCnt);
    // End:0x88
    if(SiegeStatus == 1)
    {
        // End:0x85
        if((FortressID2ZoneNameID(G_ZoneID2)) == FortressID)
        {
            DrawMapMainInfo(FortressID);
        }        
    }
    else
    {
        // End:0xA5
        if(SiegeStatus == 0)
        {
            Btn_Refresh.HideWindow();            
        }
        else
        {
            // End:0xBC
            if(SiegeStatus == 2)
            {
                DrawMapAfterBarrack(FortressID);
            }
        }
    }
    return;
}

function HandleFortressMapBarrackInfo(string param)
{
    local int BarrackID, BarrackStatus;
    local string DataforMap;

    // End:0xCE6
    if(SiegeStatus == 1)
    {
        ParseInt(param, "BarrackID", BarrackID);
        ParseInt(param, "BarrackStatus", BarrackStatus);
        ParamAdd(DataforMap, "Index", string(BarrackID));
        ParamAdd(DataforMap, "WorldX", BarrackID2XLoc(FortressID, BarrackID));
        ParamAdd(DataforMap, "WorldY", BarrackID2YLoc(FortressID, BarrackID));
        // End:0x672
        if((BarrackStatus == 1) && GlobalCurFortressStatus)
        {
            switch(BarrackID2Int(FortressID, BarrackID))
            {
                // End:0x198
                case 1711:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
                    // End:0x66F
                    break;
                // End:0x264
                case 1708:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Center_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Center_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Center_Disable");
                    // End:0x66F
                    break;
                // End:0x339
                case 1713:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
                    // End:0x66F
                    break;
                // End:0x402
                case 1710:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
                    // End:0x66F
                    break;
                // End:0x4D1
                case 1714:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
                    // End:0x66F
                    break;
                // End:0x59D
                case 1707:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
                    // End:0x66F
                    break;
                // End:0x669
                case 1709:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
                    // End:0x66F
                    break;
                // End:0xFFFF
                default:
                    // End:0x66F
                    break;
                    break;
            }            
        }
        else
        {
            // End:0xB95
            if((BarrackStatus == 0) && GlobalCurFortressStatus)
            {
                switch(BarrackID2Int(FortressID, BarrackID))
                {
                    // End:0x74E
                    case 1711:
                        ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Archer");
                        ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Archer");
                        ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Archer");
                        // End:0xB95
                        break;
                    // End:0x802
                    case 1708:
                        ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Center");
                        ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Center");
                        ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Center");
                        // End:0xB95
                        break;
                    // End:0x8BF
                    case 1713:
                        ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Machinery");
                        ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Machinery");
                        ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Machinery");
                        // End:0xB95
                        break;
                    // End:0x970
                    case 1710:
                        ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Magic");
                        ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Magic");
                        ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Magic");
                        // End:0xB95
                        break;
                    // End:0xA27
                    case 1714:
                        ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Officer");
                        ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Officer");
                        ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Officer");
                        // End:0xB95
                        break;
                    // End:0xADB
                    case 1707:
                        ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Prison");
                        ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Prison");
                        ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Prison");
                        // End:0xB95
                        break;
                    // End:0xB8F
                    case 1709:
                        ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Shield");
                        ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Shield");
                        ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Shield");
                        // End:0xB95
                        break;
                    // End:0xFFFF
                    default:
                        // End:0xB95
                        break;
                        break;
                }
            }
        }
        ParamAdd(DataforMap, "BtnWidth", "33");
        ParamAdd(DataforMap, "BtnHeight", "33");
        // End:0xBF0
        if(BarrackStatus == 1)
        {
            ParamAdd(DataforMap, "Description", "");            
        }
        else
        {
            // End:0xC15
            if(BarrackStatus == 0)
            {
                ParamAdd(DataforMap, "Description", "");
            }
        }
        ParamAdd(DataforMap, "DescOffsetX", "0");
        ParamAdd(DataforMap, "DescOffsetY", "0");
        // End:0xC90
        if(BarrackStatus == 1)
        {
            ParamAdd(DataforMap, "Tooltip", ((BarrackID2Text(FortressID, BarrackID)) $ "\\n") $ GetSystemString(1715));            
        }
        else
        {
            // End:0xCD2
            if(BarrackStatus == 0)
            {
                ParamAdd(DataforMap, "Tooltip", ((BarrackID2Text(FortressID, BarrackID)) $ "\\n") $ GetSystemString(1716));
            }
        }
        m_MiniMap.AddRegionInfo(DataforMap);
    }
    return;
}

function string BarrackID2XLoc(int FortressID, int BarrackID)
{
    local int i;
    local string ReturnVal;

    i = 0;
    J0x07:

    // End:0x64 [Loop If]
    if(i < loc_fortress.Length)
    {
        // End:0x5A
        if((loc_fortress[i] == FortressID) && loc_component[i] == BarrackID)
        {
            ReturnVal = string(loc_xloc[i] - 225);
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return ReturnVal;
    return;
}

function string BarrackID2YLoc(int FortressID, int BarrackID)
{
    local int i;
    local string ReturnVal;

    i = 0;
    J0x07:

    // End:0x67 [Loop If]
    if(i < loc_fortress.Length)
    {
        // End:0x5D
        if((loc_fortress[i] == FortressID) && loc_component[i] == BarrackID)
        {
            ReturnVal = string(loc_yloc[i] - 400);
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return ReturnVal;
    return;
}

function string BarrackID2Text(int FortressID, int BarrackID)
{
    local int i;
    local string returnStr;

    i = 0;
    J0x07:

    // End:0x64 [Loop If]
    if(i < loc_fortress.Length)
    {
        // End:0x5A
        if((loc_fortress[i] == FortressID) && loc_component[i] == BarrackID)
        {
            returnStr = GetSystemString(loc_sysstr[i]);
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return returnStr;
    return;
}

function int BarrackID2Int(int FortressID, int BarrackID)
{
    local int i, ReturnInt;

    i = 0;
    J0x07:

    // End:0x5E [Loop If]
    if(i < loc_fortress.Length)
    {
        // End:0x54
        if((loc_fortress[i] == FortressID) && loc_component[i] == BarrackID)
        {
            ReturnInt = loc_sysstr[i];
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return ReturnInt;
    return;
}

function DrawMapBasicInfo(int ReturnInt)
{
    local int i;
    local Vector loc;
    local string DataforMap;

    DataforMap = "";
    i = 0;
    J0x0F:

    // End:0x5F6 [Loop If]
    if(i < loc_fortress.Length)
    {
        // End:0x5EC
        if(loc_fortress[i] == ReturnInt)
        {
            DataforMap = "";
            ParamAdd(DataforMap, "Index", string(i));
            ParamAdd(DataforMap, "WorldX", string(loc_xloc[i] - 225));
            ParamAdd(DataforMap, "WorldY", string(loc_yloc[i] - 400));
            switch(loc_sysstr[i])
            {
                // End:0x161
                case 1711:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Archer");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Archer");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Archer");
                    // End:0x5D8
                    break;
                // End:0x245
                case 1708:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Center");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Center");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Center");
                    loc.X = float(loc_xloc[i]);
                    loc.Y = float(loc_yloc[i]);
                    // End:0x5D8
                    break;
                // End:0x302
                case 1713:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Machinery");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Machinery");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Machinery");
                    // End:0x5D8
                    break;
                // End:0x3B3
                case 1710:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Magic");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Magic");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Magic");
                    // End:0x5D8
                    break;
                // End:0x46A
                case 1714:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Officer");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Officer");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Officer");
                    // End:0x5D8
                    break;
                // End:0x51E
                case 1707:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Prison");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Prison");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Prison");
                    // End:0x5D8
                    break;
                // End:0x5D2
                case 1709:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Shield");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Shield");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Shield");
                    // End:0x5D8
                    break;
                // End:0xFFFF
                default:
                    // End:0x5D8
                    break;
                    break;
            }
            m_MiniMap.AddRegionInfo(DataforMap);
        }
        ++i;
        // [Loop Continue]
        goto J0x0F;
    }
    return;
}

function DrawMapAfterBarrack(int ReturnInt)
{
    local int i;
    local string DataforMap;
    local Vector loc;

    DataforMap = "";
    m_MiniMap.EraseAllRegionInfo();
    DrawMapBasicInfo(FortressID2ZoneNameID(G_ZoneID));
    i = 0;
    J0x2F:

    // End:0x692 [Loop If]
    if(i < loc_fortress.Length)
    {
        // End:0x688
        if(loc_fortress[i] == ReturnInt)
        {
            DataforMap = "";
            ParamAdd(DataforMap, "Index", string(i));
            ParamAdd(DataforMap, "WorldX", string(loc_xloc[i] - 225));
            ParamAdd(DataforMap, "WorldY", string(loc_yloc[i] - 400));
            switch(loc_sysstr[i])
            {
                // End:0x199
                case 1711:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Archer_Disable");
                    // End:0x688
                    break;
                // End:0x27D
                case 1708:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Center");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Center");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Center");
                    loc.X = float(loc_xloc[i]);
                    loc.Y = float(loc_yloc[i]);
                    // End:0x688
                    break;
                // End:0x352
                case 1713:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Machinery_Disable");
                    // End:0x688
                    break;
                // End:0x41B
                case 1710:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Magic_Disable");
                    // End:0x688
                    break;
                // End:0x4EA
                case 1714:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Officer_Disable");
                    // End:0x688
                    break;
                // End:0x5B6
                case 1707:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Prison_Disable");
                    // End:0x688
                    break;
                // End:0x682
                case 1709:
                    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
                    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
                    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Shield_Disable");
                    // End:0x688
                    break;
                // End:0xFFFF
                default:
                    // End:0x688
                    break;
                    break;
            }
        }
        ++i;
        // [Loop Continue]
        goto J0x2F;
    }
    return;
}

function DrawMapMainInfo(int ReturnInt)
{
    local int i;
    local Vector loc;
    local string DataforMap;

    DataforMap = "";
    i = 0;
    J0x0F:

    // End:0x253 [Loop If]
    if(i < loc_fortress.Length)
    {
        // End:0x249
        if((loc_fortress[i] == ReturnInt) && loc_sysstr[i] == 1708)
        {
            DataforMap = "";
            ParamAdd(DataforMap, "Index", "9");
            ParamAdd(DataforMap, "WorldX", string(loc_xloc[i] - 225));
            ParamAdd(DataforMap, "WorldY", string(loc_yloc[i] - 400));
            ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ct1.MiniMap_DF_ICN_Center");
            ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ct1.MiniMap_DF_ICN_Center");
            ParamAdd(DataforMap, "BtnTexOver", "l2ui_ct1.MiniMap_DF_ICN_Center");
            loc.X = float(loc_xloc[i]);
            loc.Y = float(loc_yloc[i]);
            ParamAdd(DataforMap, "BtnWidth", "33");
            ParamAdd(DataforMap, "BtnHeight", "33");
            ParamAdd(DataforMap, "Description", "");
            ParamAdd(DataforMap, "DescOffsetX", "-7");
            ParamAdd(DataforMap, "DescOffsetY", "7");
            ParamAdd(DataforMap, "Tooltip", GetSystemString(loc_sysstr[i]));
            m_MiniMap.AddRegionInfo(DataforMap);
        }
        ++i;
        // [Loop Continue]
        goto J0x0F;
    }
    return;
}

function HandleDominionsOwnPos(string param)
{
    local int DominionID, i, X, Y, Z;

    local string DataforMap;
    local LVDataRecord Record;
    local LVData data1, data2, data3;

    ParseInt(param, "DominionID", DominionID);
    ParseInt(param, "PosX", X);
    ParseInt(param, "PosY", Y);
    ParseInt(param, "PosZ", Z);
    DataforMap = "";
    data1.nReserved1 = DominionID;
    data2.nReserved2 = X;
    data3.nReserved3 = Y;
    data3.nReserved2 = Z;
    data1.szData = getInstanceL2Util().getCastleNameEx(DominionID);
    Record.LVDataList[0] = data1;
    Record.LVDataList[1] = data2;
    Record.LVDataList[2] = data3;
    ListTrackItem3.InsertRecord(Record);
    ParamAdd(DataforMap, "Index", string(DominionID));
    ParamAdd(DataforMap, "WorldX", string(X - 225));
    ParamAdd(DataforMap, "WorldY", string(Y - 400));
    ParamAdd(DataforMap, "Description", "");
    ParamAdd(DataforMap, "DescOffsetX", "0");
    ParamAdd(DataforMap, "DescOffsetY", "0");
    ParamAdd(DataforMap, "Tooltip", getInstanceL2Util().getCastleNameEx(DominionID) @ GetSystemString(2216));
    OwnthingMapping(DominionID + 10000, setVector(X, Y, -10000));
    bOwnthing++;
    // End:0x239
    if(bOwnthing >= bOwnthingCount)
    {
        bOwnthing = 0;
        showMapIconElement();
    }
    return;
}

function DrawCleftStatus()
{
    local int i;
    local string DataforMap;

    // End:0x1B8
    if(CleftCurTriggerWnd.IsShowWindow())
    {
        i = 0;
        J0x19:

        // End:0x1B8 [Loop If]
        if(i <= 5)
        {
            DataforMap = "";
            ParamAdd(DataforMap, "Index", "9");
            ParamAdd(DataforMap, "WorldX", string(loc_cleftx[i] - 225));
            ParamAdd(DataforMap, "WorldY", string(loc_clefty[i] - 400));
            ParamAdd(DataforMap, "BtnTexNormal", loc_cleftIcon[i]);
            ParamAdd(DataforMap, "BtnTexPushed", loc_cleftIcon[i]);
            ParamAdd(DataforMap, "BtnTexOver", loc_cleftIcon[i]);
            ParamAdd(DataforMap, "BtnWidth", "33");
            ParamAdd(DataforMap, "BtnHeight", "33");
            ParamAdd(DataforMap, "Description", "");
            ParamAdd(DataforMap, "DescOffsetX", "-7");
            ParamAdd(DataforMap, "DescOffsetY", "7");
            ParamAdd(DataforMap, "Tooltip", loc_cleftName[i]);
            m_MiniMap.AddRegionInfo(DataforMap);
            i++;
            // [Loop Continue]
            goto J0x19;
        }
    }
    return;
}

function InitializeLocation()
{
    local Vector MyPosition;

    MyPosition = GetPlayerPosition();
    // End:0x42
    if(m_MiniMap.GetContinent(MyPosition) == m_CurContinent)
    {
        m_MiniMap.AdjustMapView(MyPosition, true);        
    }
    else
    {
        InitializeLocationByContinent();
    }
    return;
}

function checkClassicForm()
{
    // End:0xD1
    if(getInstanceUIData().getIsClassicServer())
    {
        m_MapSelectTab.SetTopOrder(0, false);
        m_MapSelectTab.SetButtonDisableTexture(1, "L2UI_ct1.Misc_DF_Blank");
        m_MapSelectTab.SetButtonName(0, GetSystemString(1769));
        m_MapSelectTab.SetDisable(1, true);
        m_MapSelectTab.SetButtonName(1, "");
        TabBg_Line.SetWindowSize(318 + 86, 23);
        TabBg_Line.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 101, 31);        
    }
    else
    {
        m_MapSelectTab.SetButtonName(0, GetSystemString(1768));
        m_MapSelectTab.SetButtonName(1, GetSystemString(1769));
        m_MapSelectTab.SetDisable(1, false);
        TabBg_Line.SetWindowSize(140 + 86, 23);
        TabBg_Line.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 193, 31);
    }
    return;
}

function SetContinent(int Continent)
{
    m_CurContinent = Continent;
    m_MiniMap.super(MinimapWnd).SetContinent(m_CurContinent);
    // End:0x3E
    if(m_CurContinent == 1)
    {
        m_MapSelectTab.SetTopOrder(0, true);        
    }
    else
    {
        // End:0x5A
        if(m_CurContinent == 0)
        {
            m_MapSelectTab.SetTopOrder(1, true);
        }
    }
    // End:0x6A
    if(IsExpandState())
    {
        setMapSize(true);
    }
    return;
}

function SetLocContinent(Vector loc)
{
    m_CurContinent = m_MiniMap.GetContinent(loc);
    SetContinent(m_CurContinent);
    return;
}

function showAllRegionIcon(bool bShow)
{
    m_MiniMap.SetShowRegionInfoByType(0, bShow);
    m_MiniMap.SetShowRegionInfoByType(1, bShow);
    m_MiniMap.SetShowRegionInfoByType(2, bShow);
    m_MiniMap.SetShowRegionInfoByType(3, bShow);
    m_MiniMap.SetShowRegionInfoByType(8, bShow);
    // End:0x91
    if(bShow)
    {
        m_MiniMap.SetShowRegionInfoByType(5, true);        
    }
    else
    {
        m_MiniMap.SetShowRegionInfoByType(5, false);
    }
    // End:0xC1
    if(bShow)
    {
        m_MiniMap.SetShowRegionInfoByType(6, true);        
    }
    else
    {
        m_MiniMap.SetShowRegionInfoByType(6, false);
    }
    // End:0xF1
    if(bShow)
    {
        m_MiniMap.SetShowRegionInfoByType(7, true);        
    }
    else
    {
        m_MiniMap.SetShowRegionInfoByType(7, false);
    }
    return;
}

function showRegionIcon(int nRegionType, bool bShow)
{
    // End:0x25
    if(nRegionType == 0)
    {
        m_MiniMap.SetShowRegionInfoByType(0, bShow);        
    }
    else
    {
        // End:0x4A
        if(nRegionType == 1)
        {
            m_MiniMap.SetShowRegionInfoByType(1, bShow);            
        }
        else
        {
            // End:0x70
            if(nRegionType == 2)
            {
                m_MiniMap.SetShowRegionInfoByType(2, bShow);                
            }
            else
            {
                // End:0x96
                if(nRegionType == 3)
                {
                    m_MiniMap.SetShowRegionInfoByType(3, bShow);                    
                }
                else
                {
                    // End:0xBC
                    if(nRegionType == 8)
                    {
                        m_MiniMap.SetShowRegionInfoByType(8, bShow);                        
                    }
                    else
                    {
                        // End:0x126
                        if(nRegionType == 5)
                        {
                            m_MiniMap.SetShowRegionInfoByType(5, bShow);
                            Debug("SetShowRegionInfoByType.MRT_HuntingZone_Mission ->" @ string(bShow));                            
                        }
                        else
                        {
                            // End:0x188
                            if(nRegionType == 6)
                            {
                                m_MiniMap.SetShowRegionInfoByType(6, bShow);
                                Debug("SetShowRegionInfoByType.MRT_InstantZone ->" @ string(bShow));                                
                            }
                            else
                            {
                                // End:0x1E0
                                if(nRegionType == 7)
                                {
                                    m_MiniMap.SetShowRegionInfoByType(7, bShow);
                                    Debug("SetShowRegionInfoByType.MRT_Raid ->" @ string(bShow));
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function initServerButton()
{
    ServerInfo01_Button.HideWindow();
    ServerInfo02_Button.HideWindow();
    ServerInfo03_Button.HideWindow();
    ServerInfo04_Button.HideWindow();
    GetTextureHandle(m_WindowName $ ".texShadowTop").HideWindow();
    return;
}

function initServerInfoArray()
{
    local Vector loc;

    serverInfoArray.Remove(0, serverInfoArray.Length);
    serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_siege_i00", "L2UI_CT1.Minimap.map_siege_i00_Down", "L2UI_CT1.Minimap.map_siege_i00_Over", 0, GetSystemString(3534), "", loc);
    serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_siege_demension_i00", "L2UI_CT1.Minimap.map_siege_demension_i00_Down", "L2UI_CT1.Minimap.map_siege_demension_i00_Over", 1, GetSystemString(3535), GetSystemMessage(4), loc);
    serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_raid_demension_i00", "L2UI_CT1.Minimap.map_raid_demension_i00_Down", "L2UI_CT1.Minimap.map_raid_demension_i00_Over", 2, GetSystemString(3536), GetSystemMessage(6), loc);
    serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_cursed_weapon_i01", "L2UI_CT1.Minimap.map_cursed_weapon_i01_Down", "L2UI_CT1.Minimap.map_cursed_weapon_i01_Over", 3, MakeFullSystemMsg(GetSystemMessage(4437), GetSystemString(1464)), "", loc);
    serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_cursed_weapon_i00", "L2UI_CT1.Minimap.map_cursed_weapon_i00_Down", "L2UI_CT1.Minimap.map_cursed_weapon_i00_Over", 4, MakeFullSystemMsg(GetSystemMessage(4437), GetSystemString(1499)), "", loc);
    serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_auction_i00", "L2UI_CT1.Minimap.map_auction_i00_Down", "L2UI_CT1.Minimap.map_auction_i00_Over", 5, GetSystemString(3538), "", loc);
    serverInfoArray[serverInfoArray.Length] = setServerInfoButton(false, "L2UI_CT1.Minimap.map_siege_kserth_i00", "L2UI_CT1.Minimap.map_siege_kserth_i00_Down", "L2UI_CT1.Minimap.map_siege_kserth_i00_Over", 6, GetSystemString(3540), "", loc);
    return;
}

function MapServerInfo setServerInfoButton(bool bUse, string normalTex, string pushedTex, string highlightTex, int nServerInfoType, string TooltipString, string buttonName, Vector clickedLoc)
{
    local MapServerInfo severInfo;

    severInfo.bUse = bUse;
    severInfo.normalTex = normalTex;
    severInfo.pushedTex = pushedTex;
    severInfo.highlightTex = highlightTex;
    severInfo.nServerInfoType = nServerInfoType;
    severInfo.TooltipString = TooltipString;
    severInfo.buttonName = buttonName;
    severInfo.clickedLocClickCount = 0;
    return severInfo;
    return;
}

function setServerButton(ButtonHandle serverButton, int nServerInfoType, MapServerInfo mServerInfo)
{
    // End:0x89
    if(mServerInfo.bUse)
    {
        serverButton.ShowWindow();
        serverButton.SetTexture(mServerInfo.normalTex, mServerInfo.pushedTex, mServerInfo.highlightTex);
        serverButton.SetTooltipCustomType(MakeTooltipSimpleText(mServerInfo.TooltipString));
        serverInfoArray[nServerInfoType].buttonName = serverButton.GetWindowName();
    }
    return;
}

function bool isActiveCursedWeapon()
{
    local int i;

    i = 0;
    J0x07:

    // End:0xEE [Loop If]
    if(i < serverInfoArray.Length)
    {
        // End:0xE4
        if((serverInfoArray[i].nServerInfoType == 3) || serverInfoArray[i].nServerInfoType == 4)
        {
            // End:0xE4
            if(serverInfoArray[i].bUse)
            {
                Debug("-> ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ È°ï¿½ï¿½È­ ï¿½Ç¾ï¿½ ï¿½ï¿½ï¿½ï¿½");
                return true;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function int getServerNData(int serverInfoType)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x4C [Loop If]
    if(i < serverInfoArray.Length)
    {
        // End:0x42
        if(serverInfoArray[i].nServerInfoType == serverInfoType)
        {
            return serverInfoArray[i].nData;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return 0;
    return;
}

function clickServerInfoButton(string clickButtonName)
{
    local int i, N, clickCount, addIconX, addIconY;

    local MinimapRegionIconData IconData, emptyIconData;

    i = 0;
    J0x07:

    // End:0x4EC [Loop If]
    if(i < serverInfoArray.Length)
    {
        // End:0x4E2
        if(serverInfoArray[i].buttonName == clickButtonName)
        {
            Debug((("ï¿½ï¿½Æ° ï¿½ï¿½ï¿½ï¿½ (ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½Æ°) , ï¿½ï¿½ï¿½ï¿½Å¸ï¿½ï¿½ï¿½ï¿½?:" @ string(serverInfoArray[i].nServerInfoType)) @ ", click Array :") @ string(serverInfoArray[i].clickedLocArray.Length));
            Debug("nRegionID" @ string(serverInfoArray[i].nRegionID));
            // End:0x4DF
            if(serverInfoArray[i].clickedLocArray.Length > 0)
            {
                clickCount = serverInfoArray[i].clickedLocClickCount;
                IconData = emptyIconData;
                addIconX = 0;
                addIconY = 0;
                Debug("serverInfoArray[i].clickedLoc.x " @ string(serverInfoArray[i].clickedLocArray[clickCount].X));
                Debug("serverInfoArray[i].clickedLoc.y " @ string(serverInfoArray[i].clickedLocArray[clickCount].Y));
                Debug("serverInfoArray[i].clickedLoc.z " @ string(serverInfoArray[i].clickedLocArray[clickCount].Z));
                // End:0x484
                if(((serverInfoArray[i].clickedLocArray[clickCount].X != float(0)) || serverInfoArray[i].clickedLocArray[clickCount].Y != float(0)) || serverInfoArray[i].clickedLocArray[clickCount].Z != float(0))
                {
                    // End:0x2E1
                    if(serverInfoArray[i].nRegionID > 0)
                    {
                        GetMinimapRegionIconData(serverInfoArray[i].nRegionID, IconData);
                    }
                    // End:0x3FA
                    if((serverInfoArray[i].nServerInfoType == 3) || serverInfoArray[i].nServerInfoType == 4)
                    {
                        Debug("--> ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½Æ°ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½");
                        Class'NWindow.UIAPI_MINIMAPCTRL'.static.DeleteAllCursedWeaponIcon("MinimapWnd.Minimap");
                        Class'NWindow.MiniMapAPI'.static.RequestCursedWeaponLocation();
                        SetLocContinent(serverInfoArray[i].clickedLocArray[clickCount]);                        
                    }
                    else
                    {
                        SetLocContinent(serverInfoArray[i].clickedLocArray[clickCount]);
                        mapIconHighlight(serverInfoArray[i].clickedLocArray[clickCount], IconData, addIconX, addIconY);
                    }
                    OnClickReduceButton();
                    Class'NWindow.UIAPI_MINIMAPCTRL'.static.AdjustMapView("MinimapWnd.Minimap", serverInfoArray[i].clickedLocArray[clickCount], false);                    
                }
                else
                {
                    AddSystemMessage(4431);
                }
                // End:0x4CD
                if(serverInfoArray[i].clickedLocArray.Length > (serverInfoArray[i].clickedLocClickCount + 1))
                {
                    serverInfoArray[i].clickedLocClickCount++;                    
                }
                else
                {
                    serverInfoArray[i].clickedLocClickCount = 0;
                }
            }
            // [Explicit Break]
            goto J0x4EC;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x4EC:

    return;
}

function refreshServerInfoButton()
{
    local int i;
    local bool bUse;

    initServerButton();
    i = 0;
    J0x0D:

    // End:0x5F [Loop If]
    if(i < serverInfoArray.Length)
    {
        setServerButton(getServerInfoButton(), i, serverInfoArray[i]);
        // End:0x55
        if(serverInfoArray[i].bUse)
        {
            bUse = true;
        }
        i++;
        // [Loop Continue]
        goto J0x0D;
    }
    // End:0x91
    if(bUse)
    {
        GetTextureHandle(m_WindowName $ ".texShadowTop").ShowWindow();        
    }
    else
    {
        GetTextureHandle(m_WindowName $ ".texShadowTop").HideWindow();
    }
    return;
}

function ButtonHandle getServerInfoButton()
{
    // End:0x1A
    if(!ServerInfo01_Button.IsShowWindow())
    {
        return ServerInfo01_Button;
    }
    // End:0x34
    if(!ServerInfo02_Button.IsShowWindow())
    {
        return ServerInfo02_Button;
    }
    // End:0x4E
    if(!ServerInfo03_Button.IsShowWindow())
    {
        return ServerInfo03_Button;
    }
    // End:0x68
    if(!ServerInfo04_Button.IsShowWindow())
    {
        return ServerInfo04_Button;
    }
    Debug("MAP ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½Æ°ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ Ã¡ï¿½ï¿½ï¿½Ï´ï¿½. 4ï¿½ï¿½ ï¿½ï¿½Æ°ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½ï¿½Ï´ï¿½.");
    return ServerInfo04_Button;
    return;
}

function setServerParse(int serverInfoType, string param, bool bUse, optional Vector clickedLoc, optional int nRegionID, optional int nData)
{
    // End:0x105
    if(serverInfoType == 0)
    {
        // End:0x102
        if(bUse)
        {
            serverInfoArray[serverInfoType].bUse = true;
            // End:0x57
            if(serverInfoArray[serverInfoType].szReserved == "")
            {
                serverInfoArray[serverInfoType].szReserved = param;                
            }
            else
            {
                serverInfoArray[serverInfoType].szReserved = (serverInfoArray[serverInfoType].szReserved $ ",") $ param;
            }
            serverInfoArray[serverInfoType].TooltipString = (GetSystemString(3534) $ " : ") $ serverInfoArray[serverInfoType].szReserved;
            // End:0xDA
            if(nRegionID > 0)
            {
                serverInfoArray[serverInfoType].nRegionID = nRegionID;
            }
            serverInfoArray[serverInfoType].clickedLocArray[serverInfoArray[serverInfoType].clickedLocArray.Length] = clickedLoc;
        }        
    }
    else
    {
        // End:0x184
        if(serverInfoType == 1)
        {
            serverInfoArray[serverInfoType].bUse = bUse;
            // End:0x181
            if(bUse)
            {
                serverInfoArray[serverInfoType].clickedLocArray[0] = setVector(147461, 8000, -592);
                serverInfoArray[serverInfoType].clickedLocArray[1] = setVector(14659, -49230, -160);
            }            
        }
        else
        {
            // End:0x1D3
            if(serverInfoType == 2)
            {
                serverInfoArray[serverInfoType].bUse = bUse;
                serverInfoArray[serverInfoType].clickedLocArray[0] = setVector(116503, 75392, -2712);                
            }
            else
            {
                // End:0x212
                if(serverInfoType == 3)
                {
                    serverInfoArray[serverInfoType].bUse = bUse;
                    serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc;                    
                }
                else
                {
                    // End:0x251
                    if(serverInfoType == 4)
                    {
                        serverInfoArray[serverInfoType].bUse = bUse;
                        serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc;                        
                    }
                    else
                    {
                        // End:0x290
                        if(serverInfoType == 5)
                        {
                            serverInfoArray[serverInfoType].bUse = bUse;
                            serverInfoArray[serverInfoType].clickedLocArray[0] = clickedLoc;                            
                        }
                        else
                        {
                            // End:0x2F2
                            if(serverInfoType == 6)
                            {
                                serverInfoArray[serverInfoType].bUse = bUse;
                                serverInfoArray[serverInfoType].clickedLocArray[0] = setVector(-184750, 240723, 1568);
                                serverInfoArray[serverInfoType].nData = nData;
                            }
                        }
                    }
                }
            }
        }
    }
    refreshServerInfoButton();
    return;
}

function drawMinimapRegionInfo(UIEventManager.EMinimapRegionType nMinimapRegionType, int i, optional bool bActive, optional bool bUseUpdate)
{
    local HuntingZoneUIData huntingZoneData;
    local MinimapRegionInfo regionInfoForMapIcon;
    local string toolTipParam;
    local bool bEnableLevel;
    local UserInfo pUserInfo;
    local MinimapRegionIconData IconData;
    local RaidUIData raidData;

    Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(i, huntingZoneData);
    GetPlayerInfo(pUserInfo);
    regionInfoForMapIcon.eType = nMinimapRegionType;
    regionInfoForMapIcon.nIndex = i;
    regionInfoForMapIcon.strDesc = "";
    toolTipParam = "";
    // End:0x123
    if(int(nMinimapRegionType) == 5)
    {
        bEnableLevel = tryLevelCheck(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel);
        // End:0x120
        if(bEnableLevel)
        {
            ParamAdd(toolTipParam, "Type", string(nMinimapRegionType));
            ParamAdd(toolTipParam, "Index", string(i));
            IconData = makeMapIcon(int(nMinimapRegionType), bEnableLevel, huntingZoneData.nWorldLoc);
            regionInfoForMapIcon.IconData = IconData;
            regionInfoForMapIcon.strTooltip = toolTipParam;
            addMapIcon(regionInfoForMapIcon, bUseUpdate);
        }        
    }
    else
    {
        // End:0x20E
        if(int(nMinimapRegionType) == 6)
        {
            bEnableLevel = tryLevelCheck(pUserInfo.nLevel, huntingZoneData.nMinLevel, huntingZoneData.nMaxLevel);
            // End:0x20B
            if(bEnableLevel)
            {
                ParamAdd(toolTipParam, "Type", string(nMinimapRegionType));
                ParamAdd(toolTipParam, "Index", string(i));
                ParamAdd(toolTipParam, "Active", string(boolToNum(bActive)));
                IconData = makeMapIcon(int(nMinimapRegionType), bActive, huntingZoneData.nWorldLoc);
                regionInfoForMapIcon.IconData = IconData;
                regionInfoForMapIcon.strTooltip = toolTipParam;
                addMapIcon(regionInfoForMapIcon, bUseUpdate);
            }            
        }
        else
        {
            // End:0x307
            if(int(nMinimapRegionType) == 7)
            {
                raidData = RaidUIDataCache[i];
                bEnableLevel = tryLevelCheck(pUserInfo.nLevel, raidData.nMinLevel, raidData.nMaxLevel);
                // End:0x307
                if(bEnableLevel)
                {
                    ParamAdd(toolTipParam, "Type", string(nMinimapRegionType));
                    ParamAdd(toolTipParam, "Index", string(i));
                    ParamAdd(toolTipParam, "active", string(boolToNum(bActive)));
                    IconData = makeMapIcon(int(nMinimapRegionType), bActive, raidData.nWorldLoc);
                    regionInfoForMapIcon.IconData = IconData;
                    regionInfoForMapIcon.strTooltip = toolTipParam;
                    addMapIcon(regionInfoForMapIcon, bUseUpdate);
                }
            }
        }
    }
    return;
}

function MinimapRegionIconData makeMapIcon(int IconType, bool bActive, Vector pLoc)
{
    local MinimapRegionIconData IconData;
    local HuntingZoneUIData huntingZoneData;

    IconData.nWidth = 32;
    IconData.nHeight = 32;
    IconData.nWorldLocX = int(pLoc.X);
    IconData.nWorldLocY = int(pLoc.Y);
    IconData.nWorldLocZ = int(pLoc.Z);
    IconData.nIconOffsetX = -16;
    IconData.nIconOffsetY = -16;
    // End:0x1E2
    if(IconType == 5)
    {
        // End:0x12F
        if(bActive)
        {
            IconData.strIconNormal = "L2UI_CT1.Minimap.map_huntingzone_i00";
            IconData.strIconOver = "L2UI_CT1.Minimap.map_huntingzone_i00_Over";
            IconData.strIconPushed = "L2UI_CT1.Minimap.map_huntingzone_i00";            
        }
        else
        {
            IconData.strIconNormal = "L2UI_CT1.Minimap.map_huntingzoneInactive_i00";
            IconData.strIconOver = "L2UI_CT1.Minimap.map_huntingzoneInactive_i00_Over";
            IconData.strIconPushed = "L2UI_CT1.Minimap.map_huntingzoneInactive_i00";
        }        
    }
    else
    {
        // End:0x345
        if(IconType == 6)
        {
            // End:0x292
            if(bActive)
            {
                IconData.strIconNormal = "L2UI_CT1.Minimap.map_inzone_gate_i00";
                IconData.strIconOver = "L2UI_CT1.Minimap.map_inzone_gate_i00_Over";
                IconData.strIconPushed = "L2UI_CT1.Minimap.map_inzone_gate_i00";                
            }
            else
            {
                IconData.strIconNormal = "L2UI_CT1.Minimap.map_inzone_gateInactive_i00";
                IconData.strIconOver = "L2UI_CT1.Minimap.map_inzone_gateInactive_i00_Over";
                IconData.strIconPushed = "L2UI_CT1.Minimap.map_inzone_gateInactive_i00";
            }            
        }
        else
        {
            // End:0x499
            if(IconType == 7)
            {
                // End:0x3FB
                if(bActive)
                {
                    IconData.strIconNormal = "L2UI_CT1.Minimap.map_raid_spawning_i00";
                    IconData.strIconOver = "L2UI_CT1.Minimap.map_raid_spawning_i00_Over";
                    IconData.strIconPushed = "L2UI_CT1.Minimap.map_raid_spawning_i00";                    
                }
                else
                {
                    IconData.strIconNormal = "L2UI_CT1.Minimap.map_raid_respawn_i00";
                    IconData.strIconOver = "L2UI_CT1.Minimap.map_raid_respawn_i00_Over";
                    IconData.strIconPushed = "L2UI_CT1.Minimap.map_raid_respawn_i00";
                }                
            }
            else
            {
                // End:0x553
                if(IconType == 10081)
                {
                    IconData.strIconNormal = "L2UI_CT1.Minimap_DF_Icn_territorywar_gludio";
                    IconData.strIconOver = "L2UI_CT1.Minimap_DF_Icn_territorywar_gludio";
                    IconData.strIconPushed = "L2UI_CT1.Minimap_DF_Icn_territorywar_gludio";                    
                }
                else
                {
                    // End:0x607
                    if(IconType == 10082)
                    {
                        IconData.strIconNormal = "L2UI_CT1.Minimap_DF_Icn_territorywar_dion";
                        IconData.strIconOver = "L2UI_CT1.Minimap_DF_Icn_territorywar_dion";
                        IconData.strIconPushed = "L2UI_CT1.Minimap_DF_Icn_territorywar_dion";                        
                    }
                    else
                    {
                        // End:0x6BE
                        if(IconType == 10083)
                        {
                            IconData.strIconNormal = "L2UI_CT1.Minimap_DF_Icn_territorywar_giran";
                            IconData.strIconOver = "L2UI_CT1.Minimap_DF_Icn_territorywar_giran";
                            IconData.strIconPushed = "L2UI_CT1.Minimap_DF_Icn_territorywar_giran";                            
                        }
                        else
                        {
                            // End:0x772
                            if(IconType == 10084)
                            {
                                IconData.strIconNormal = "L2UI_CT1.Minimap_DF_Icn_territorywar_oren";
                                IconData.strIconOver = "L2UI_CT1.Minimap_DF_Icn_territorywar_oren";
                                IconData.strIconPushed = "L2UI_CT1.Minimap_DF_Icn_territorywar_oren";                                
                            }
                            else
                            {
                                // End:0x826
                                if(IconType == 10085)
                                {
                                    IconData.strIconNormal = "L2UI_CT1.Minimap_DF_Icn_territorywar_aden";
                                    IconData.strIconOver = "L2UI_CT1.Minimap_DF_Icn_territorywar_aden";
                                    IconData.strIconPushed = "L2UI_CT1.Minimap_DF_Icn_territorywar_aden";                                    
                                }
                                else
                                {
                                    // End:0x8E6
                                    if(IconType == 10086)
                                    {
                                        IconData.strIconNormal = "L2UI_CT1.Minimap_DF_Icn_territorywar_innadril";
                                        IconData.strIconOver = "L2UI_CT1.Minimap_DF_Icn_territorywar_innadril";
                                        IconData.strIconPushed = "L2UI_CT1.Minimap_DF_Icn_territorywar_innadril";                                        
                                    }
                                    else
                                    {
                                        // End:0x9A0
                                        if(IconType == 10087)
                                        {
                                            IconData.strIconNormal = "L2UI_CT1.Minimap_DF_Icn_territorywar_godard";
                                            IconData.strIconOver = "L2UI_CT1.Minimap_DF_Icn_territorywar_godard";
                                            IconData.strIconPushed = "L2UI_CT1.Minimap_DF_Icn_territorywar_godard";                                            
                                        }
                                        else
                                        {
                                            // End:0xA54
                                            if(IconType == 10088)
                                            {
                                                IconData.strIconNormal = "L2UI_CT1.Minimap_DF_Icn_territorywar_rune";
                                                IconData.strIconOver = "L2UI_CT1.Minimap_DF_Icn_territorywar_rune";
                                                IconData.strIconPushed = "L2UI_CT1.Minimap_DF_Icn_territorywar_rune";                                                
                                            }
                                            else
                                            {
                                                // End:0xB17
                                                if(IconType == 10089)
                                                {
                                                    IconData.strIconNormal = "L2UI_CT1.Minimap_DF_Icn_territorywar_schuttgart";
                                                    IconData.strIconOver = "L2UI_CT1.Minimap_DF_Icn_territorywar_schuttgart";
                                                    IconData.strIconPushed = "L2UI_CT1.Minimap_DF_Icn_territorywar_schuttgart";
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return IconData;
    return;
}

function MinimapRegionInfo makeFocusMapIcon(Vector pLoc, optional bool bEmpty)
{
    local MinimapRegionInfo regionInfoForMapIcon;
    local MinimapRegionIconData IconData;

    regionInfoForMapIcon.eType = 8;
    regionInfoForMapIcon.nIndex = 100;
    IconData.nWidth = 64;
    IconData.nHeight = 64;
    IconData.nWorldLocX = int(pLoc.X);
    IconData.nWorldLocY = int(pLoc.Y);
    IconData.nWorldLocZ = int(pLoc.Z);
    IconData.bIgnoreMouseInput = true;
    // End:0xEC
    if(bEmpty)
    {
        IconData.strIconNormal = "L2UI_CT1.EmptyBtn";
        IconData.strIconOver = "L2UI_CT1.EmptyBtn";
        IconData.strIconPushed = "L2UI_CT1.EmptyBtn";        
    }
    else
    {
        IconData.strIconNormal = "L2UI_CT1.Minimap.map_SelectAni01";
        IconData.strIconOver = "L2UI_CT1.Minimap.map_SelectAni01";
        IconData.strIconPushed = "L2UI_CT1.Minimap.map_SelectAni01";
    }
    regionInfoForMapIcon.IconData = IconData;
    return regionInfoForMapIcon;
    return;
}

function mapIconHighlightEx(Vector loc, int Type)
{
    local MinimapRegionInfo regionInfoForMapIcon;
    local string targetTexture;

    regionInfoForMapIcon.eType = 8;
    regionInfoForMapIcon.nIndex = 100;
    m_MiniMap.EraseRegionInfoCtrl(8, 100);
    switch(Type)
    {
        // End:0x11F
        case 0:
            regionInfoForMapIcon.IconData.strIconNormal = "L2UI_CT1.Minimap.map_SelectAni01";
            regionInfoForMapIcon.IconData.strIconOver = "L2UI_CT1.Minimap.map_SelectAni01";
            regionInfoForMapIcon.IconData.strIconPushed = "L2UI_CT1.Minimap.map_SelectAni01";
            regionInfoForMapIcon.IconData.nWidth = 64;
            regionInfoForMapIcon.IconData.nHeight = 64;
            regionInfoForMapIcon.IconData.nIconOffsetX = -16;
            regionInfoForMapIcon.IconData.nIconOffsetY = -16;
            // End:0x219
            break;
        // End:0x213
        case 1:
            regionInfoForMapIcon.IconData.strIconNormal = "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow";
            regionInfoForMapIcon.IconData.strIconOver = "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow";
            regionInfoForMapIcon.IconData.strIconPushed = "l2ui_ct1.MiniMap_DF_FlagIcon_Yellow";
            regionInfoForMapIcon.IconData.nWidth = 32;
            regionInfoForMapIcon.IconData.nHeight = 32;
            regionInfoForMapIcon.IconData.nIconOffsetX = -8;
            regionInfoForMapIcon.IconData.nIconOffsetY = -8;
            // End:0x219
            break;
        // End:0xFFFF
        default:
            // End:0x219
            break;
            break;
    }
    regionInfoForMapIcon.IconData.bIgnoreMouseInput = true;
    regionInfoForMapIcon.IconData.nWorldLocX = int(loc.X);
    regionInfoForMapIcon.IconData.nWorldLocY = int(loc.Y);
    regionInfoForMapIcon.IconData.nWorldLocZ = int(loc.Z);
    m_MiniMap.AddRegionInfoCtrl(regionInfoForMapIcon);
    Me.KillTimer(225);
    Me.SetTimer(225, 1500);
    return;
}

function mapIconHighlight(Vector loc, optional MinimapRegionIconData IconData, optional int addIconPosX, optional int addIconPosY)
{
    local MinimapRegionInfo regionInfoForMapIcon;

    m_MiniMap.EraseRegionInfoCtrl(8, 100);
    regionInfoForMapIcon = makeFocusMapIcon(loc);
    regionInfoForMapIcon.IconData.nIconOffsetX = (-32 + (IconData.nWidth / 2)) + addIconPosX;
    regionInfoForMapIcon.IconData.nIconOffsetY = (-32 + (IconData.nHeight / 2)) + addIconPosY;
    m_MiniMap.AddRegionInfoCtrl(regionInfoForMapIcon);
    Me.KillTimer(225);
    Me.SetTimer(225, 1500);
    return;
}

function bool IsHideMinimapZone(int nZoneID)
{
    switch(nZoneID)
    {
        // End:0x0F
        case 453:
        // End:0x17
        case 454:
        // End:0x1F
        case 455:
        // End:0x27
        case 456:
        // End:0x2F
        case 457:
        // End:0x39
        case 458:
            return true;
        // End:0xFFFF
        default:
            return false;
            break;
    }    
    return;
}

function bool IsHideMinimapZone_new(int nZoneID)
{
    switch(nZoneID)
    {
        // End:0x0F
        case 453:
        // End:0x17
        case 454:
        // End:0x1F
        case 455:
        // End:0x27
        case 456:
        // End:0x2F
        case 457:
        // End:0x39
        case 458:
            return true;
        // End:0xFFFF
        default:
            return false;
            break;
    }    
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="MinimapWnd"
}