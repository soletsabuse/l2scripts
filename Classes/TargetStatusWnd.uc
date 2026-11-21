class TargetStatusWnd extends UICommonAPI;

const TimerValue1 = 1351;
const TimerValue2 = 6346;
const TimerValue3 = 4858;
const TimerValue4 = 7337;
const TimerValue5 = 3474;
const TimerValue6 = 5269;
const TimerValue7 = 5270;
const TimerValue8 = 5271;
const TimerValue9 = 5272;
const CONTRACT_HEIGHT = 46;
const EXPAND_HEIGHT = 76;
const EXPAND_HEIGHT_WITH_GEAR_SCORE = 91;
const MOCK_TARGET_GEAR_SCORE = 985000;
const BUFF_SIZE_BIG = 24;
const BUFF_SIZE_SMALL = 16;

var bool m_bExpand;
var int m_TargetLevel;
var int m_targetID;
var bool m_rotated;
var bool m_bShow;
var string g_NameStr;
var Vector targetLoc;
var WindowHandle Me1;
var WindowHandle Me2;
var WindowHandle Me;
var BarHandle barMP;
var BarHandle barHP;
var TextBoxHandle txtPledgeAllianceName;
var TextureHandle texPledgeAllianceCrest;
var TextBoxHandle txtAlliance;
var TextBoxHandle txtPledgeName;
var TextureHandle texPledgeCrest;
var TextBoxHandle txtPledge;
var TextBoxHandle txtGearScore;
var TextBoxHandle txtGearScoreValue;
var NameCtrlHandle RankName;
var NameCtrlHandle Username;
var ButtonHandle btnClose;
var TreeHandle NpcInfo;
var ButtonHandle btnExpand;
var ButtonHandle btnContract;
var WindowHandle TargetStatusBuff1Wnd;
var WindowHandle TargetStatusBuff2Wnd;
var WindowHandle BuffWnd;
var ButtonHandle btnBuffMoreView1;
var ButtonHandle btnBuffMoreView2;
var int yPosView2;
var StatusIconHandle StatusIcons;
var array<StatusIconInfo> arrMyBuff;
var array<StatusIconInfo> arrOtherBuff;
var array<StatusIconInfo> arrMyDebuff;
var array<StatusIconInfo> arrOtherDebuff;
var int LineCount;
var string strSelectTarget;
var ProgressCtrlHandle barSkillProgress1;
var NameCtrlHandle skillProgressName1;
var TextureHandle barSkillProgressEff1_Left;
var TextureHandle barSkillProgressEff1_Center;
var TextureHandle barSkillProgressEff1_Right;
var ProgressCtrlHandle barSkillProgress2;
var NameCtrlHandle skillProgressName2;
var TextureHandle barSkillProgressEff2_Left;
var TextureHandle barSkillProgressEff2_Center;
var TextureHandle barSkillProgressEff2_Right;
var TextureHandle texMark;
var bool bIsShowBackup;
var int m_TargetIDBackup;
var string m_WindowName;
var INT64 m_TargetGearScore;
var bool m_bTargetGearScoreReceived;
var bool m_bUseMockTargetGearScore;

function OnRegisterEvent()
{
    RegisterEvent(980);
    RegisterEvent(990);
    RegisterEvent(190);
    RegisterEvent(210);
    RegisterEvent(200);
    RegisterEvent(220);
    RegisterEvent(191);
    RegisterEvent(211);
    RegisterEvent(201);
    RegisterEvent(221);
    RegisterEvent(300);
    RegisterEvent(5120);
    RegisterEvent(981);
    RegisterEvent(982);
    RegisterEvent(160);
    RegisterEvent(150);
    RegisterEvent(161);
    RegisterEvent(40);
    return;
}

function OnLoad()
{
    local bool nOption;

    SetClosingOnESC();
    InitializeCOD();
    OnShowProcess();
    load();
    nOption = GetOptionBool("ScreenInfo", "SkillCastingBox");
    nOption = GetOptionBool("ScreenInfo", "StrangeStateBox");
    StateBoxShow(nOption);
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle(m_WindowName);
    barMP = GetBarHandle(m_WindowName $ ".barMP");
    barHP = GetBarHandle(m_WindowName $ ".barHP");
    txtPledgeAllianceName = GetTextBoxHandle(m_WindowName $ ".txtPledgeAllianceName");
    texPledgeAllianceCrest = GetTextureHandle(m_WindowName $ ".texPledgeAllianceCrest");
    txtAlliance = GetTextBoxHandle(m_WindowName $ ".txtAlliance");
    txtPledgeName = GetTextBoxHandle(m_WindowName $ ".txtPledgeName");
    texPledgeCrest = GetTextureHandle(m_WindowName $ ".texPledgeCrest");
    txtPledge = GetTextBoxHandle(m_WindowName $ ".txtPledge");
    txtGearScore = GetTextBoxHandle(m_WindowName $ ".txtGearScore");
    txtGearScoreValue = GetTextBoxHandle(m_WindowName $ ".txtGearScoreValue");
    RankName = GetNameCtrlHandle(m_WindowName $ ".RankName");
    Username = GetNameCtrlHandle(m_WindowName $ ".UserName");
    btnClose = GetButtonHandle(m_WindowName $ ".btnClose");
    NpcInfo = GetTreeHandle(m_WindowName $ ".NpcInfo");
    Me1 = GetWindowHandle(m_WindowName);
    btnExpand = GetButtonHandle(m_WindowName $ ".btnExpand");
    btnContract = GetButtonHandle(m_WindowName $ ".btnContract");
    BuffWnd = GetWindowHandle(m_WindowName $ ".BuffWnd");
    TargetStatusBuff1Wnd = GetWindowHandle("TargetStatusBuff1Wnd");
    TargetStatusBuff2Wnd = GetWindowHandle("TargetStatusBuff2Wnd");
    StatusIcons = GetStatusIconHandle(m_WindowName $ ".BuffWnd.StatusIcons");
    btnBuffMoreView1 = GetButtonHandle(m_WindowName $ ".BuffWnd.btnBuffMoreView1");
    btnBuffMoreView2 = GetButtonHandle(m_WindowName $ ".BuffWnd.btnBuffMoreView2");
    barSkillProgress1 = GetProgressCtrlHandle(m_WindowName $ ".SkillProgressWnd1.barSkillProgress1");
    skillProgressName1 = GetNameCtrlHandle(m_WindowName $ ".SkillProgressWnd1.SkillProgressName1");
    barSkillProgressEff1_Left = GetTextureHandle(m_WindowName $ ".SkillProgressWnd1.barSkillProgressEff1_Left");
    barSkillProgressEff1_Center = GetTextureHandle(m_WindowName $ ".SkillProgressWnd1.barSkillProgressEff1_Center");
    barSkillProgressEff1_Right = GetTextureHandle(m_WindowName $ ".SkillProgressWnd1.barSkillProgressEff1_Right");
    barSkillProgress2 = GetProgressCtrlHandle(m_WindowName $ ".SkillProgressWnd2.barSkillProgress2");
    skillProgressName2 = GetNameCtrlHandle(m_WindowName $ ".SkillProgressWnd2.SkillProgressName2");
    barSkillProgressEff2_Left = GetTextureHandle(m_WindowName $ ".SkillProgressWnd2.barSkillProgressEff2_Left");
    barSkillProgressEff2_Center = GetTextureHandle(m_WindowName $ ".SkillProgressWnd2.barSkillProgressEff2_Center");
    barSkillProgressEff2_Right = GetTextureHandle(m_WindowName $ ".SkillProgressWnd2.barSkillProgressEff2_Right");
    texMark = GetTextureHandle(m_WindowName $ ".texMark");
    return;
}

function load()
{
    SetExpandMode(false, false);
    g_NameStr = "";
    m_bShow = false;
    m_targetID = -1;
    m_rotated = false;
    skillBarVisible(false, 1);
    showBuffMoreBtn(false, 1);
    skillBarVisible(false, 2);
    showBuffMoreBtn(false, 2);
    yPosView2 = 0;
    strSelectTarget = "Friendly";
    return;
}

function OnShowProcess()
{
    return;
}

function OnRotate1()
{
    Me2.SetAlpha(0);
    Me2.ShowWindow();
    Me.SetTimer(1351, 150);
    return;
}

function OnRotate2()
{
    Me1.SetAlpha(0);
    Me1.ShowWindow();
    Me.SetTimer(6346, 150);
    return;
}

function OnRotateClose()
{
    // End:0x54
    if(GetGameStateName() != "SPECIALCAMERASTATE")
    {
        Me1.SetAlpha(0);
        Me1.ShowWindow();
        Me.SetTimer(3474, 150);
    }
    return;
}

function OnRotateReset()
{
    Me1.ShowWindow();
    Me2.HideWindow();
    Me1.SetAlpha(255);
    Me2.SetAlpha(0);
    m_rotated = false;
    HandleTargetUpdate();
    return;
}

function OnTimer(int TimerID)
{
    // End:0x62
    if(TimerID == 1351)
    {
        Me.KillTimer(1351);
        Me2.SetAlpha(255, 0.4000000);
        Me1.SetAlpha(0);
        Me.SetTimer(4858, 300);
    }
    // End:0x9C
    if(TimerID == 4858)
    {
        Me.KillTimer(4858);
        Me1.HideWindow();
        m_rotated = true;
    }
    // End:0xFE
    if(TimerID == 6346)
    {
        Me.KillTimer(6346);
        Me1.SetAlpha(255, 0.4000000);
        Me2.SetAlpha(0);
        Me.SetTimer(7337, 300);
    }
    // End:0x138
    if(TimerID == 7337)
    {
        Me.KillTimer(7337);
        Me2.HideWindow();
        m_rotated = false;
    }
    // End:0x19A
    if(TimerID == 3474)
    {
        Me.KillTimer(3474);
        Me1.SetAlpha(255, 0.4000000);
        Me2.SetAlpha(0);
        Me.SetTimer(5269, 300);
    }
    // End:0x1E3
    if(TimerID == 5269)
    {
        Me.KillTimer(5269);
        Me2.HideWindow();
        Me1.HideWindow();
        m_rotated = false;
    }
    // End:0x20E
    if(TimerID == 5270)
    {
        Me.KillTimer(5270);
        skillBarVisible(false, 1);
    }
    // End:0x23A
    if(TimerID == 5271)
    {
        Me.KillTimer(5271);
        skillBarVisible(false, 2);
    }
    // End:0x26E
    if(TimerID == 5272)
    {
        Me.KillTimer(5272);
        skillBarVisible(false, 1);
        skillBarVisible(false, 2);
    }
    return;
}

function OnShow()
{
    m_bShow = true;
    return;
}

function OnHide()
{
    m_bShow = false;
    g_NameStr = "";
    m_targetID = 0;
    return;
}

function OnEnterState(name a_PreStateName)
{
    local int tmpInt;

    GetINIInt("TargetStatusWnd", "e", tmpInt, "WindowsInfo.ini");
    m_bExpand = bool(tmpInt);
    SetExpandMode(m_bExpand, true);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x2A
    if(Event_ID == 980)
    {
        // End:0x21
        if(m_rotated)
        {
            OnRotateReset();            
        }
        else
        {
            HandleTargetUpdate();
        }        
    }
    else
    {
        // End:0x42
        if(Event_ID == 990)
        {
            HandleTargetHideWindow();            
        }
        else
        {
            // End:0x5F
            if(Event_ID == 300)
            {
                HandleReceiveTargetLevelDiff(param);                
            }
            else
            {
                // End:0x88
                if((Event_ID == 190) || Event_ID == 191)
                {
                    HandleUpdateGauge(param, 0);                    
                }
                else
                {
                    // End:0xB1
                    if((Event_ID == 200) || Event_ID == 201)
                    {
                        HandleUpdateGauge(param, 0);                        
                    }
                    else
                    {
                        // End:0xDA
                        if((Event_ID == 210) || Event_ID == 211)
                        {
                            HandleUpdateGauge(param, 1);                            
                        }
                        else
                        {
                            // End:0x103
                            if((Event_ID == 220) || Event_ID == 221)
                            {
                                HandleUpdateGauge(param, 1);                                
                            }
                            else
                            {
                                // End:0x120
                                if(Event_ID == 5120)
                                {
                                    HandleTargetSpelledList(param);                                    
                                }
                                else
                                {
                                    // End:0x13D
                                    if(Event_ID == 981)
                                    {
                                        HandleTargetSkillInfo(param);                                        
                                    }
                                    else
                                    {
                                        // End:0x155
                                        if(Event_ID == 982)
                                        {
                                            HandleSkillCancel();                                            
                                        }
                                        else
                                        {
                                            // End:0x16A
                                            if(Event_ID == 160)
                                            {
                                                RequestTargetCancel();                                                
                                            }
                                            else
                                            {
                                                // End:0x198
                                                if(Event_ID == 150)
                                                {
                                                    // End:0x195
                                                    if(bIsShowBackup)
                                                    {
                                                        // End:0x195
                                                        if(m_TargetIDBackup > 0)
                                                        {
                                                            RequestTargetUser(m_TargetIDBackup);
                                                        }
                                                    }                                                    
                                                }
                                                else
                                                {
                                                    // End:0x1CE
                                                    if(Event_ID == 161)
                                                    {
                                                        bIsShowBackup = Me.IsShowWindow();
                                                        m_TargetIDBackup = m_targetID;
                                                        RequestTargetCancel();                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x1ED
                                                        if(Event_ID == 40)
                                                        {
                                                            bIsShowBackup = false;
                                                            m_TargetIDBackup = -1;
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
        }
    }
    return;
}

function HandleTargetHideWindow()
{
    // End:0x12
    if(m_rotated)
    {
        OnRotateClose();        
    }
    else
    {
        Me.HideWindow();
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1D
        case "btnClose":
            OnCloseButton();
            // End:0x8D
            break;
        // End:0x38
        case "RotateButton1":
            OnRotate1();
            // End:0x8D
            break;
        // End:0x53
        case "RotateButton2":
            OnRotate2();
            // End:0x8D
            break;
        // End:0x6C
        case "btnExpand":
            SetExpandMode(false, true);
            // End:0x8D
            break;
        // End:0x87
        case "btnContract":
            SetExpandMode(true, true);
            // End:0x8D
            break;
        // End:0xFFFF
        default:
            // End:0x8D
            break;
            break;
    }
    return;
}

function OnCloseButton()
{
    RequestTargetCancel();
    PlayConsoleSound(6);
    return;
}

function HandleUpdateGauge(string param, int Type)
{
    local int ServerID;

    // End:0x3D
    if(m_bShow)
    {
        ParseInt(param, "ServerID", ServerID);
        // End:0x3D
        if(m_targetID == ServerID)
        {
            HandleTargetUpdateGauge(Type);
        }
    }
    return;
}

function HandleReceiveTargetLevelDiff(string param)
{
    ParseInt(param, "LevelDiff", m_TargetLevel);
    HandleTargetUpdate();
    return;
}

function HandleTargetUpdateGauge(int Type)
{
    local UserInfo Info;
    local int targetID;

    targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
    // End:0x43
    if(targetID < 1)
    {
        // End:0x32
        if(m_rotated)
        {
            OnRotateClose();            
        }
        else
        {
            Me.HideWindow();
        }
        return;
    }
    m_targetID = targetID;
    GetTargetInfo(Info);
    switch(Type)
    {
        // End:0x81
        case 0:
            UpdateHPBar(Info.nCurHP, Info.nMaxHP);
            // End:0xA8
            break;
        // End:0xA2
        case 1:
            UpdateMPBar(Info.nCurMP, Info.nMaxMP);
            // End:0xA8
            break;
        // End:0xFFFF
        default:
            // End:0xA8
            break;
            break;
    }
    return;
}

function ResetTargetGearScore()
{
    m_TargetGearScore = (0);
    m_bTargetGearScoreReceived = false;
    return;
}

function HandleTargetGearScoreInfo(string param)
{
    local int ServerID;
    local INT64 GearScore;

    // End:0x21
    if(!ParseInt(param, "ServerID", ServerID))
    {
        return;
    }
    // End:0x32
    if(ServerID != m_targetID)
    {
        return;
    }
    // End:0x66
    if(ParseINT64(param, "GearScore", GearScore))
    {
        m_TargetGearScore = GearScore;
        m_bTargetGearScoreReceived = true;        
    }
    else
    {
        // End:0x9C
        if(ParseINT64(param, "BattlePower", GearScore))
        {
            m_TargetGearScore = GearScore;
            m_bTargetGearScoreReceived = true;            
        }
        else
        {
            ResetTargetGearScore();
        }
    }
    HandleTargetUpdate();
    return;
}

function bool ShouldShowTargetGearScore(UserInfo Info)
{
    // End:0x16
    if(!Class'Interface.ReleaseGate'.static.RankingEnabled())
    {
        return false;
    }
    // End:0x57
    if(((Info.bNpc || Info.bPet) || Class'NWindow.UIDATA_TARGET'.static.IsNpc()) || m_targetID <= 0)
    {
        return false;
    }
    // End:0x72
    if(m_targetID == Class'NWindow.UIDATA_PLAYER'.static.GetPlayerID())
    {
        return false;
    }
    // End:0x9A
    if(Class'NWindow.UIDATA_TARGET'.static.IsServerObject() || Class'NWindow.UIDATA_TARGET'.static.IsVehicle())
    {
        return false;
    }
    return true;
    return;
}

function UpdateTargetStatusExpandHeight(bool bShowTargetGearScore)
{
    local int nWndWidth, nWndHeight;

    // End:0x0D
    if(!m_bExpand)
    {
        return;
    }
    Me.GetWindowSize(nWndWidth, nWndHeight);
    // End:0x48
    if(bShowTargetGearScore)
    {
        Me.SetWindowSize(nWndWidth, 91);        
    }
    else
    {
        Me.SetWindowSize(nWndWidth, 76);
    }
    return;
}

function int GetTargetStatusExpandHeight()
{
    local int targetID;
    local UserInfo Info;

    targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
    // End:0x3C
    if(targetID > 0)
    {
        GetTargetInfo(Info);
        // End:0x3C
        if(ShouldShowTargetGearScore(Info))
        {
            return 91;
        }
    }
    return 76;
    return;
}

function INT64 GetTargetGearScoreForDisplay(UserInfo Info)
{
    return (Info.nMaxMP);
    return;
}

function INT64 GetMockTargetGearScore(UserInfo Info)
{
    // End:0x12
    if(Info.bNpc)
    {
        return (0);
    }
    return (985000);
    return;
}

function string GetTargetGearScoreDisplayText(INT64 GearScore)
{
    // End:0x1C
    if(__NFUN_409__(GearScore, (0)))
    {
        return ": " $ (GearScore);
    }
    return ": -";
    return;
}

function Color GetTargetGearScoreColor(INT64 GearScore)
{
    local Color GearScoreColor;

    // End:0x1A
    if(__NFUN_409__(GearScore, (0)))
    {
        return GetGearScoreTierColor(GearScore);
    }
    GearScoreColor.R = 128;
    GearScoreColor.G = 128;
    GearScoreColor.B = 128;
    GearScoreColor.A = byte(255);
    return GearScoreColor;
    return;
}

function DumpTargetGS(UserInfo Info)
{
    Say(((((("== TARGET " $ Info.Name) $ " id=") $ string(Info.nID)) $ " npc=") $ string(Info.bNpc)) $ " ==");
    Say((((((("luc=" $ string(Info.nLuc)) $ " cha=") $ string(Info.nCha)) $ " atkT=") $ string(Info.AttrAttackType)) $ " atkV=") $ string(Info.AttrAttackValue));
    Say((((((("dFire=" $ string(Info.AttrDefenseValFire)) $ " dWat=") $ string(Info.AttrDefenseValWater)) $ " dWind=") $ string(Info.AttrDefenseValWind)) $ " dEar=") $ string(Info.AttrDefenseValEarth));
    Say((((((("dHoly=" $ string(Info.AttrDefenseValHoly)) $ " dUnh=") $ string(Info.AttrDefenseValUnholy)) $ " tr=") $ string(Info.nTransformID)) $ " inv=") $ string(Info.nInvenLimit));
    Say((((((("pvpR=" $ string(Info.PvPPointRestrain)) $ " pvp=") $ string(Info.PvPPoint)) $ " raid=") $ string(Info.RaidPoint)) $ " crim=") $ string(Info.nCriminalRate));
    Say((((((("vit=" $ string(Info.nVitality)) $ " vitB=") $ string(Info.nVitalBonus)) $ " vitI=") $ string(Info.nVitalItem)) $ " mid=") $ string(Info.nMasterID));
    Say((((((((("tal=" $ string(Info.nTalismanNum)) $ " jew=") $ string(Info.nJewelNum)) $ " agM=") $ string(Info.nAgathionMainNum)) $ " agS=") $ string(Info.nAgathionSubNum)) $ " fa=") $ string(Info.nFullArmor));
    Say((((((("dom=" $ string(Info.JoinedDominionID)) $ " domV=") $ string(Info.DominionIDForVirtualName)) $ " ult=") $ string(Info.UltimateSkillPoint)) $ " ap=") $ string(Info.nRemainAbilityPoint));
    Say((((((((("rank=" $ string(Info.nUserRank)) $ " dual=") $ string(Info.nDualCount)) $ " pk=") $ string(Info.nPKCount)) $ " soc=") $ string(Info.nSociality)) $ " suf=") $ string(Info.nRemainSulffrage));
    return;
}

function HandleTargetUpdate()
{
    local Rect rectWnd;
    local string strTmp;
    local int targetID, PlayerID, petID, clanType, clanNameValue;

    local bool bIsServerObject, bIsHPShowableNPC, bIsVehicle;
    local string Name, NameRank;
    local Color TargetNameColor;
    local int ServerObjectNameID;
    local Actor.EL2ObjectType ServerObjectType;
    local Vehicle VehicleActor;
    local string DriverName;
    local bool bShowHPBar, bShowMPBar, bShowPledgeInfo, bShowPledgeTex, bShowPledgeAllianceTex;

    local string PledgeName, PledgeAllianceName;
    local Texture PledgeCrestTexture, PledgeAllianceCrestTexture;
    local Color PledgeNameColor, PledgeAllianceNameColor;
    local bool bShowNpcInfo;
    local array<int> arrNpcInfo;
    local bool IsTargetChanged, WantHideName;
    local UserInfo Info;
    local PetInfo PetInfo;
    local Color WhiteColor;
    local int PledgeTxtLen, PledgeAllianceTxtLen;
    local Rect textRect;
    local array<string> PartyMemberNameData;
    local bool bShowTargetGearScore;
    local INT64 TargetGearScore;
    local string TargetGearScoreText;
    local Color TargetGearScoreColor;
    local int PledgeInfoY, AllianceInfoY;

    WhiteColor.R = 0;
    WhiteColor.G = 0;
    WhiteColor.B = 0;
    targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
    // End:0x6A
    if(targetID < 1)
    {
        // End:0x59
        if(m_rotated)
        {
            OnRotateClose();            
        }
        else
        {
            Me.HideWindow();
        }
        return;
    }
    // End:0x87
    if(m_targetID != targetID)
    {
        IsTargetChanged = true;
        ResetTargetGearScore();
    }
    m_targetID = targetID;
    GetTargetInfo(Info);
    // End:0xC3
    if(IsTargetChanged && !Info.bNpc)
    {
        DumpTargetGS(Info);
    }
    // End:0x12F
    if(Info.TacticSign == 0)
    {
        texMark.HideWindow();
        Username.SetWindowSizeRel(1.0000000, 0.0000000, -33, 14);
        Username.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 18, 8);        
    }
    else
    {
        texMark.ShowWindow();
        texMark.SetTexture("l2ui_Ct1.TargetStatusWnd_DF_mark_" $ (makeZeroString(2, (Info.TacticSign))));
        Username.SetWindowSizeRel(1.0000000, 0.0000000, -54, 14);
        Username.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 36, 8);
    }
    WantHideName = Info.WantHideName;
    rectWnd = Me.GetRect();
    PledgeName = GetSystemString(431);
    PledgeAllianceName = GetSystemString(591);
    PledgeNameColor.R = 128;
    PledgeNameColor.G = 128;
    PledgeNameColor.B = 128;
    PledgeAllianceNameColor.R = 128;
    PledgeAllianceNameColor.G = 128;
    PledgeAllianceNameColor.B = 128;
    bShowTargetGearScore = ShouldShowTargetGearScore(Info);
    // End:0x2C8
    if(bShowTargetGearScore)
    {
        TargetGearScore = GetTargetGearScoreForDisplay(Info);
        TargetGearScoreText = GetTargetGearScoreDisplayText(TargetGearScore);
        TargetGearScoreColor = GetTargetGearScoreColor(TargetGearScore);
        PledgeInfoY = 58;
        AllianceInfoY = 74;        
    }
    else
    {
        PledgeInfoY = 43;
        AllianceInfoY = 59;
    }
    UpdateTargetStatusExpandHeight(bShowTargetGearScore);
    TargetNameColor = GetTargetNameColor(m_TargetLevel);
    bIsServerObject = Class'NWindow.UIDATA_TARGET'.static.IsServerObject();
    bIsVehicle = Class'NWindow.UIDATA_TARGET'.static.IsVehicle();
    // End:0x4A1
    if(bIsServerObject)
    {
        ServerObjectType = Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectType(m_targetID);
        // End:0x36E
        if(int(ServerObjectType) == 4)
        {
            Name = GetSystemString(1966);
            NameRank = "";            
        }
        else
        {
            // End:0x3A1
            if(int(ServerObjectType) == 5)
            {
                Name = Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectName(m_targetID);
                NameRank = "";                
            }
            else
            {
                ServerObjectNameID = Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectNameID(m_targetID);
                // End:0x3E8
                if(ServerObjectNameID > 0)
                {
                    Name = Class'NWindow.UIDATA_STATICOBJECT'.static.GetStaticObjectName(ServerObjectNameID);
                    NameRank = "";
                }
            }
        }
        // End:0x414
        if(IsBuilderPC())
        {
            Name = ((Name @ "[") $ string(Info.nID)) $ "]";
        }
        Username.SetName(Name, 0, 2);
        RankName.SetName(NameRank, 0, 2);
        // End:0x49E
        if(int(ServerObjectType) == 1)
        {
            // End:0x49E
            if(Class'NWindow.UIDATA_STATICOBJECT'.static.GetStaticObjectShowHP(m_targetID))
            {
                bShowHPBar = true;
                UpdateHPBar(Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectHP(m_targetID), Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectMaxHP(m_targetID));
            }
        }        
    }
    else
    {
        // End:0x58F
        if(bIsVehicle)
        {
            HandleTargetHideWindow();
            return;
            // End:0x4DE
            if(IsBuilderPC())
            {
                Name = ((Name @ "[") $ string(Info.nID)) $ "]";
            }
            Username.SetName("AirShip", 0, 2);
            VehicleActor = Vehicle(Class'NWindow.UIDATA_TARGET'.static.GetTargetActor());
            // End:0x58C
            if(VehicleActor != none)
            {
                // End:0x556
                if(VehicleActor.DriverID > 0)
                {
                    DriverName = Class'NWindow.UIDATA_USER'.static.GetUserName(VehicleActor.DriverID);
                }
                // End:0x574
                if(Len(DriverName) < 1)
                {
                    DriverName = GetSystemString(1967);
                }
                RankName.SetName(DriverName, 0, 2);
            }            
        }
        else
        {
            // End:0x7AB
            if(Len(Info.Name) < 1)
            {
                Name = Class'NWindow.UIDATA_PARTY'.static.GetMemberVirtualName(m_targetID);
                // End:0x615
                if(Name == "")
                {
                    Name = Class'NWindow.UIDATA_PARTY'.static.GetMemberName(m_targetID);
                    // End:0x615
                    if(InStr(Name, ";") > -1)
                    {
                        Split(Name, ";", PartyMemberNameData);
                        Name = PartyMemberNameData[0];
                    }
                }
                NameRank = "";
                // End:0x65B
                if((IsBuilderPC()) && Info.nID > 0)
                {
                    Name = ((Name @ "[") $ string(Info.nID)) $ "]";
                }
                Username.SetName(Name, 0, 2);
                RankName.SetName(NameRank, 0, 2);
                // End:0x701
                if(Class'NWindow.UIDATA_PARTY'.static.GetMemberTacticalSign(m_targetID) == 0)
                {
                    texMark.HideWindow();
                    Username.SetWindowSizeRel(1.0000000, 0.0000000, -33, 14);
                    Username.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 18, 8);                    
                }
                else
                {
                    texMark.ShowWindow();
                    texMark.SetTexture("l2ui_Ct1.TargetStatusWnd_DF_mark_0" $ string(Class'NWindow.UIDATA_PARTY'.static.GetMemberTacticalSign(m_targetID) - 1));
                    Username.SetWindowSizeRel(1.0000000, 0.0000000, -54, 14);
                    Username.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 36, 8);
                }                
            }
            else
            {
                PlayerID = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerID();
                GetPetInfo(PetInfo);
                petID = Info.nID;
                bIsHPShowableNPC = Class'NWindow.UIDATA_TARGET'.static.IsHPShowableNPC();
                // End:0xA1D
                if(((((Info.bNpc && !Info.bPet) && bIsHPShowableNPC) || (PlayerID > 0) && m_targetID == PlayerID) || (Info.bNpc && Info.bPet) && m_targetID == petID) || Info.bNpc && bIsHPShowableNPC)
                {
                    // End:0x947
                    if(IsAllWhiteID(Info.nClassID))
                    {
                        Name = Info.Name;
                        NameRank = "";
                        // End:0x8DD
                        if(IsBuilderPC())
                        {
                            Name = ((Name @ "[") $ string(Info.nID)) $ "]";
                        }
                        Username.SetName(Name, 0, 2);
                        RankName.SetName(NameRank, 0, 2);
                        // End:0x944
                        if(!IsNoBarID(Info.nClassID))
                        {
                            bShowHPBar = true;
                            UpdateHPBar(Info.nCurHP, Info.nMaxHP);
                        }                        
                    }
                    else
                    {
                        Name = Info.Name;
                        NameRank = "";
                        Username.SetNameWithColor(Name, 0, 2, TargetNameColor);
                        RankName.SetName(NameRank, 0, 2);
                        // End:0x9C6
                        if(Info.nMaxHP > 0)
                        {
                            bShowHPBar = true;
                            UpdateHPBar(Info.nCurHP, Info.nMaxHP);
                        }
                        // End:0xA1A
                        if(!Info.bNpc && !Info.bPet)
                        {
                            // End:0xA1A
                            if(Info.nMaxMP > 0)
                            {
                                bShowMPBar = true;
                                UpdateMPBar(Info.nCurMP, Info.nMaxMP);
                            }
                        }
                    }                    
                }
                else
                {
                    Name = Info.Name;
                    // End:0xA45
                    if(WantHideName)
                    {
                        RankName.HideWindow();
                    }
                    // End:0xA66
                    if(Info.bNpc)
                    {
                        NameRank = "";
                        g_NameStr = "";                        
                    }
                    else
                    {
                        // End:0xA92
                        if(getInstanceUIData().getIsLiveServer())
                        {
                            NameRank = GetClassType(Info.nSubClass);                            
                        }
                        else
                        {
                            NameRank = GetUserRankString(Info.nUserRank);
                        }
                        g_NameStr = Name;
                    }
                    // End:0xADF
                    if(IsBuilderPC())
                    {
                        Name = ((Name @ "[") $ string(Info.nID)) $ "]";
                    }
                    Username.SetName(Name, 0, 2);
                    RankName.SetName(NameRank, 0, 2);
                }
                // End:0xDB5
                if(m_bExpand)
                {
                    // End:0xB78
                    if(Info.bNpc && 0 >= Info.nMasterID)
                    {
                        // End:0xB75
                        if(Class'NWindow.UIDATA_NPC'.static.GetNpcProperty(Info.nClassID, arrNpcInfo))
                        {
                            bShowNpcInfo = true;
                            // End:0xB75
                            if(IsTargetChanged)
                            {
                                UpdateNpcInfoTree(arrNpcInfo);
                            }
                        }                        
                    }
                    else
                    {
                        bShowPledgeInfo = true;
                        // End:0xDB5
                        if(Info.nClanID > 0)
                        {
                            PledgeName = Class'NWindow.UIDATA_CLAN'.static.GetName(Info.nClanID);
                            PledgeNameColor.R = 176;
                            PledgeNameColor.G = 152;
                            PledgeNameColor.B = 121;
                            // End:0xCC7
                            if(((PledgeName != "") && Class'NWindow.UIDATA_USER'.static.GetClanType(m_targetID, clanType)) && Class'NWindow.UIDATA_CLAN'.static.GetNameValue(Info.nClanID, clanNameValue))
                            {
                                // End:0xC5C
                                if(clanType == -1)
                                {
                                    PledgeNameColor.R = 209;
                                    PledgeNameColor.G = 167;
                                    PledgeNameColor.B = 2;                                    
                                }
                                else
                                {
                                    // End:0xC93
                                    if(clanNameValue > 0)
                                    {
                                        PledgeNameColor.R = 0;
                                        PledgeNameColor.G = 130;
                                        PledgeNameColor.B = byte(255);                                        
                                    }
                                    else
                                    {
                                        // End:0xCC7
                                        if(clanNameValue < 0)
                                        {
                                            PledgeNameColor.R = byte(255);
                                            PledgeNameColor.G = 0;
                                            PledgeNameColor.B = 0;
                                        }
                                    }
                                }
                            }
                            // End:0xD07
                            if(Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(Info.nClanID, PledgeCrestTexture))
                            {
                                bShowPledgeTex = true;
                                texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);                                
                            }
                            else
                            {
                                bShowPledgeTex = false;
                            }
                            strTmp = Class'NWindow.UIDATA_CLAN'.static.GetAllianceName(Info.nClanID);
                            // End:0xDB5
                            if(Len(strTmp) > 0)
                            {
                                PledgeAllianceName = strTmp;
                                PledgeAllianceNameColor.R = 176;
                                PledgeAllianceNameColor.G = 155;
                                PledgeAllianceNameColor.B = 121;
                                // End:0xDAD
                                if(Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(Info.nClanID, PledgeAllianceCrestTexture))
                                {
                                    bShowPledgeAllianceTex = true;
                                    texPledgeAllianceCrest.SetTextureWithObject(PledgeAllianceCrestTexture);                                    
                                }
                                else
                                {
                                    bShowPledgeAllianceTex = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // End:0xE15
    if(!Me.IsShowWindow() && GetGameStateName() != "SPECIALCAMERASTATE")
    {
        Me.ShowWindow();
        Me.SetFocus();
        SetExpandMode(m_bExpand, false);
    }
    // End:0xE86
    if(ContextMenu(GetScript("ContextMenu")).getContextEventInfo().Id > 0)
    {
        ContextMenu(GetScript("ContextMenu")).makeContextMenu();
        ContextMenu(GetScript("ContextMenu")).clearInfo();
    }
    // End:0xEC2
    if(bShowHPBar && GetGameStateName() != "SPECIALCAMERASTATE")
    {
        barHP.ShowWindow();        
    }
    else
    {
        barHP.HideWindow();
    }
    // End:0xF0D
    if(bShowMPBar && GetGameStateName() != "SPECIALCAMERASTATE")
    {
        barMP.ShowWindow();        
    }
    else
    {
        barMP.HideWindow();
    }
    // End:0xF34
    if(Info.nClanID < 0)
    {
        bShowPledgeInfo = false;
    }
    // End:0x1391
    if(bShowPledgeInfo)
    {
        // End:0x1316
        if(!WantHideName && GetGameStateName() != "SPECIALCAMERASTATE")
        {
            txtPledge.ShowWindow();
            txtAlliance.ShowWindow();
            txtPledgeName.ShowWindow();
            txtPledgeAllianceName.ShowWindow();
            txtPledgeName.SetText(PledgeName);
            txtPledgeAllianceName.SetText(PledgeAllianceName);
            txtPledgeName.SetTextColor(PledgeNameColor);
            txtPledgeAllianceName.SetTextColor(PledgeAllianceNameColor);
            txtPledge.MoveTo(rectWnd.nX + 21, rectWnd.nY + PledgeInfoY);
            txtAlliance.MoveTo(rectWnd.nX + 21, rectWnd.nY + AllianceInfoY);
            // End:0x111A
            if(bShowTargetGearScore)
            {
                txtGearScore.ShowWindow();
                txtGearScoreValue.ShowWindow();
                txtGearScore.MoveTo(rectWnd.nX + 21, rectWnd.nY + 43);
                txtGearScoreValue.SetText(TargetGearScoreText);
                txtGearScoreValue.SetTextColor(TargetGearScoreColor);
                textRect = txtGearScore.GetRect();
                txtGearScoreValue.MoveTo((textRect.nX + textRect.nWidth) + 2, rectWnd.nY + 43);                
            }
            else
            {
                txtGearScore.HideWindow();
                txtGearScoreValue.HideWindow();
            }
            textRect = txtPledge.GetRect();
            // End:0x11DE
            if(bShowPledgeTex)
            {
                texPledgeCrest.ShowWindow();
                texPledgeCrest.MoveTo((textRect.nX + textRect.nWidth) + 1, (rectWnd.nY + PledgeInfoY) + 1);
                txtPledgeName.MoveTo((textRect.nX + textRect.nWidth) + 18, rectWnd.nY + PledgeInfoY);                
            }
            else
            {
                texPledgeCrest.HideWindow();
                txtPledgeName.MoveTo((textRect.nX + textRect.nWidth) + 2, rectWnd.nY + PledgeInfoY);
            }
            textRect = txtAlliance.GetRect();
            // End:0x12CA
            if(bShowPledgeAllianceTex)
            {
                texPledgeAllianceCrest.ShowWindow();
                texPledgeAllianceCrest.MoveTo((textRect.nX + textRect.nWidth) + 1, rectWnd.nY + AllianceInfoY);
                txtPledgeAllianceName.MoveTo((textRect.nX + textRect.nWidth) + 10, rectWnd.nY + AllianceInfoY);                
            }
            else
            {
                texPledgeAllianceCrest.HideWindow();
                txtPledgeAllianceName.MoveTo((textRect.nX + textRect.nWidth) + 2, rectWnd.nY + AllianceInfoY);
            }            
        }
        else
        {
            txtPledge.HideWindow();
            txtAlliance.HideWindow();
            txtPledgeName.HideWindow();
            txtPledgeAllianceName.HideWindow();
            txtGearScore.HideWindow();
            txtGearScoreValue.HideWindow();
            texPledgeCrest.HideWindow();
            texPledgeAllianceCrest.HideWindow();
        }        
    }
    else
    {
        txtPledge.HideWindow();
        txtAlliance.HideWindow();
        txtPledgeName.HideWindow();
        txtPledgeAllianceName.HideWindow();
        txtGearScore.HideWindow();
        txtGearScoreValue.HideWindow();
        texPledgeCrest.HideWindow();
        texPledgeAllianceCrest.HideWindow();
    }
    // End:0x1455
    if(bShowNpcInfo && GetGameStateName() != "SPECIALCAMERASTATE")
    {
        NpcInfo.ShowWindow();
        NpcInfo.ShowScrollBar(false);        
    }
    else
    {
        NpcInfo.HideWindow();
    }
    return;
}

function Color GetTargetNameColor(int TargetLevelDiff)
{
    local Color OutColor;
    local UserInfo UserInfo;
    local int myLevel;

    GetPlayerInfo(UserInfo);
    myLevel = UserInfo.nLevel;
    OutColor.A = byte(255);
    // End:0x614
    if(getInstanceUIData().getIsClassicServer() || getInstanceUIData().getIsArenaServer())
    {
        // End:0x23E
        if(myLevel < 78)
        {
            // End:0x99
            if(TargetLevelDiff <= -11)
            {
                OutColor.R = byte(255);
                OutColor.G = 0;
                OutColor.B = 0;                
            }
            else
            {
                // End:0xE5
                if((TargetLevelDiff > -11) && TargetLevelDiff <= -6)
                {
                    OutColor.R = byte(255);
                    OutColor.G = 145;
                    OutColor.B = 145;                    
                }
                else
                {
                    // End:0x12F
                    if((TargetLevelDiff > -6) && TargetLevelDiff <= -3)
                    {
                        OutColor.R = 250;
                        OutColor.G = 254;
                        OutColor.B = 145;                        
                    }
                    else
                    {
                        // End:0x17C
                        if((TargetLevelDiff > -3) && TargetLevelDiff <= 2)
                        {
                            OutColor.R = byte(255);
                            OutColor.G = byte(255);
                            OutColor.B = byte(255);                            
                        }
                        else
                        {
                            // End:0x1C2
                            if((TargetLevelDiff > 2) && TargetLevelDiff <= 5)
                            {
                                OutColor.R = 162;
                                OutColor.G = byte(255);
                                OutColor.B = 171;                                
                            }
                            else
                            {
                                // End:0x206
                                if((TargetLevelDiff > 5) && TargetLevelDiff <= 10)
                                {
                                    OutColor.R = 162;
                                    OutColor.G = 168;
                                    OutColor.B = 252;                                    
                                }
                                else
                                {
                                    // End:0x23B
                                    if(TargetLevelDiff > 10)
                                    {
                                        OutColor.R = 0;
                                        OutColor.G = 0;
                                        OutColor.B = byte(255);
                                    }
                                }
                            }
                        }
                    }
                }
            }            
        }
        else
        {
            // End:0x436
            if((myLevel >= 78) && myLevel < 85)
            {
                // End:0x293
                if(TargetLevelDiff <= -11)
                {
                    OutColor.R = byte(255);
                    OutColor.G = 0;
                    OutColor.B = 0;                    
                }
                else
                {
                    // End:0x2DF
                    if((TargetLevelDiff > -11) && TargetLevelDiff <= -4)
                    {
                        OutColor.R = byte(255);
                        OutColor.G = 145;
                        OutColor.B = 145;                        
                    }
                    else
                    {
                        // End:0x329
                        if((TargetLevelDiff > -4) && TargetLevelDiff <= -2)
                        {
                            OutColor.R = 250;
                            OutColor.G = 254;
                            OutColor.B = 145;                            
                        }
                        else
                        {
                            // End:0x375
                            if((TargetLevelDiff > -2) && TargetLevelDiff <= 1)
                            {
                                OutColor.R = byte(255);
                                OutColor.G = byte(255);
                                OutColor.B = byte(255);                                
                            }
                            else
                            {
                                // End:0x3BA
                                if((TargetLevelDiff > 1) && TargetLevelDiff <= 3)
                                {
                                    OutColor.R = 162;
                                    OutColor.G = byte(255);
                                    OutColor.B = 171;                                    
                                }
                                else
                                {
                                    // End:0x3FE
                                    if((TargetLevelDiff > 3) && TargetLevelDiff <= 10)
                                    {
                                        OutColor.R = 162;
                                        OutColor.G = 168;
                                        OutColor.B = 252;                                        
                                    }
                                    else
                                    {
                                        // End:0x433
                                        if(TargetLevelDiff > 10)
                                        {
                                            OutColor.R = 0;
                                            OutColor.G = 0;
                                            OutColor.B = byte(255);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }                
            }
            else
            {
                // End:0x471
                if(TargetLevelDiff <= -11)
                {
                    OutColor.R = byte(255);
                    OutColor.G = 0;
                    OutColor.B = 0;                    
                }
                else
                {
                    // End:0x4BD
                    if((TargetLevelDiff > -11) && TargetLevelDiff <= -3)
                    {
                        OutColor.R = byte(255);
                        OutColor.G = 145;
                        OutColor.B = 145;                        
                    }
                    else
                    {
                        // End:0x507
                        if((TargetLevelDiff > -3) && TargetLevelDiff <= -2)
                        {
                            OutColor.R = 250;
                            OutColor.G = 254;
                            OutColor.B = 145;                            
                        }
                        else
                        {
                            // End:0x553
                            if((TargetLevelDiff > -2) && TargetLevelDiff <= 1)
                            {
                                OutColor.R = byte(255);
                                OutColor.G = byte(255);
                                OutColor.B = byte(255);                                
                            }
                            else
                            {
                                // End:0x598
                                if((TargetLevelDiff > 1) && TargetLevelDiff <= 2)
                                {
                                    OutColor.R = 162;
                                    OutColor.G = byte(255);
                                    OutColor.B = 171;                                    
                                }
                                else
                                {
                                    // End:0x5DC
                                    if((TargetLevelDiff > 2) && TargetLevelDiff <= 10)
                                    {
                                        OutColor.R = 162;
                                        OutColor.G = 168;
                                        OutColor.B = 252;                                        
                                    }
                                    else
                                    {
                                        // End:0x611
                                        if(TargetLevelDiff > 10)
                                        {
                                            OutColor.R = 0;
                                            OutColor.G = 0;
                                            OutColor.B = byte(255);
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
    else
    {
        // End:0x64F
        if(TargetLevelDiff <= -11)
        {
            OutColor.R = byte(255);
            OutColor.G = 0;
            OutColor.B = 0;            
        }
        else
        {
            // End:0x69B
            if((TargetLevelDiff > -11) && TargetLevelDiff <= -6)
            {
                OutColor.R = byte(255);
                OutColor.G = 145;
                OutColor.B = 145;                
            }
            else
            {
                // End:0x6E5
                if((TargetLevelDiff > -6) && TargetLevelDiff <= -3)
                {
                    OutColor.R = 250;
                    OutColor.G = 254;
                    OutColor.B = 145;                    
                }
                else
                {
                    // End:0x732
                    if((TargetLevelDiff > -3) && TargetLevelDiff <= 2)
                    {
                        OutColor.R = byte(255);
                        OutColor.G = byte(255);
                        OutColor.B = byte(255);                        
                    }
                    else
                    {
                        // End:0x778
                        if((TargetLevelDiff > 2) && TargetLevelDiff <= 5)
                        {
                            OutColor.R = 162;
                            OutColor.G = byte(255);
                            OutColor.B = 171;                            
                        }
                        else
                        {
                            // End:0x7BC
                            if((TargetLevelDiff > 5) && TargetLevelDiff <= 10)
                            {
                                OutColor.R = 162;
                                OutColor.G = 168;
                                OutColor.B = 252;                                
                            }
                            else
                            {
                                // End:0x7F1
                                if(TargetLevelDiff > 10)
                                {
                                    OutColor.R = 0;
                                    OutColor.G = 0;
                                    OutColor.B = byte(255);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return OutColor;
    return;
}

function SetExpandMode(bool bExpand, bool bUseTargetUpdate)
{
    local int nWndWidth, nWndHeight;

    Me.GetWindowSize(nWndWidth, nWndHeight);
    m_bExpand = bExpand;
    // End:0x40
    if(bUseTargetUpdate)
    {
        m_targetID = -1;
        HandleTargetUpdate();
    }
    // End:0xC2
    if(bExpand)
    {
        btnExpand.ShowWindow();
        btnContract.HideWindow();
        Me.SetWindowSize(nWndWidth, GetTargetStatusExpandHeight());
        barSkillProgressEff1_Center.SetWindowSizeRel(1.0000000, 0.4000000, -35, 0);
        barSkillProgressEff2_Center.SetWindowSizeRel(1.0000000, 0.4000000, -35, 0);        
    }
    else
    {
        btnExpand.HideWindow();
        btnContract.ShowWindow();
        Me.SetWindowSize(nWndWidth, 46);
        barSkillProgressEff1_Center.SetWindowSizeRel(1.0000000, 0.7000000, -35, 0);
        barSkillProgressEff2_Center.SetWindowSizeRel(1.0000000, 0.7000000, -35, 0);
    }
    SetINIInt("TargetStatusWnd", "e", int(bExpand), "WindowsInfo.ini");
    return;
}

function UpdateHPBar(int hp, int MaxHP)
{
    // End:0x5F
    if(MaxHP > 0)
    {
        barHP.SetValue(MaxHP, hp);
        barHP.SetTooltipCustomType(MakeTooltipSimpleText((MakeCostString(string(hp)) $ " / ") $ MakeCostString(string(MaxHP))));        
    }
    else
    {
        barHP.HideWindow();
    }
    return;
}

function UpdateMPBar(int mp, int maxMP)
{
    // End:0x27
    if(maxMP > 0)
    {
        barMP.SetValue(maxMP, mp);        
    }
    else
    {
        barMP.HideWindow();
    }
    return;
}

function UpdateNpcInfoTree(array<int> arrNpcInfo)
{
    local int i, SkillID, SkillLevel;
    local string strNodeName;
    local XMLTreeNodeInfo infNode;
    local XMLTreeNodeItemInfo infNodeItem;
    local XMLTreeNodeInfo infNodeClear;
    local XMLTreeNodeItemInfo infNodeItemClear;

    NpcInfo.Clear();
    infNode.strName = "root";
    strNodeName = NpcInfo.InsertNode("", infNode);
    // End:0x4B
    if(Len(strNodeName) < 1)
    {
        return;
    }
    i = 0;
    J0x52:

    // End:0x264 [Loop If]
    if(i < arrNpcInfo.Length)
    {
        SkillID = arrNpcInfo[i];
        SkillLevel = arrNpcInfo[i + 1];
        infNode = infNodeClear;
        infNode.nOffSetX = int(float(i / 2) % float(8)) * 18;
        // End:0xF7
        if((float(i / 2) % float(8)) == float(0))
        {
            // End:0xE8
            if(i > 0)
            {
                infNode.nOffSetY = 3;                
            }
            else
            {
                infNode.nOffSetY = 0;
            }            
        }
        else
        {
            infNode.nOffSetY = -15;
        }
        infNode.strName = "" $ string(i / 2);
        infNode.bShowButton = 0;
        infNode.ToolTip = SetNpcInfoTooltip(SkillID, SkillLevel);
        strNodeName = NpcInfo.InsertNode("root", infNode);
        // End:0x1A7
        if(Len(strNodeName) < 1)
        {
            LogInternal("ERROR: Can't insert node. Name: " $ infNode.strName);
            return;
        }
        infNode.ToolTip.DrawList.Remove(0, infNode.ToolTip.DrawList.Length);
        infNodeItem = infNodeItemClear;
        infNodeItem.eType = 2;
        infNodeItem.u_nTextureWidth = 15;
        infNodeItem.u_nTextureHeight = 15;
        infNodeItem.u_nTextureUWidth = 32;
        infNodeItem.u_nTextureUHeight = 32;
        infNodeItem.u_strTexture = Class'NWindow.UIDATA_SKILL'.static.GetIconName(GetItemID(SkillID), SkillLevel, 0);
        NpcInfo.InsertNodeItem(strNodeName, infNodeItem);
        i += 2;
        // [Loop Continue]
        goto J0x52;
    }
    return;
}

function CustomTooltip SetNpcInfoTooltip(int Id, int Level)
{
    local CustomTooltip ToolTip;
    local DrawItemInfo Info, infoClear;
    local ItemInfo item;
    local ItemID cID;

    cID = GetItemID(Id);
    item.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(cID, Level, 0);
    item.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(cID, Level, 0);
    ToolTip.DrawList.Length = 1;
    Info = infoClear;
    Info.eType = 1;
    Info.t_bDrawOneLine = true;
    Info.t_strText = item.Name;
    ToolTip.DrawList[0] = Info;
    // End:0x184
    if(Len(item.Description) > 0)
    {
        ToolTip.MinimumWidth = 144;
        ToolTip.DrawList.Length = 2;
        Info = infoClear;
        Info.eType = 1;
        Info.nOffSetY = 6;
        Info.bLineBreak = true;
        Info.t_color.R = 178;
        Info.t_color.G = 190;
        Info.t_color.B = 207;
        Info.t_color.A = byte(255);
        Info.t_strText = item.Description;
        ToolTip.DrawList[1] = Info;
    }
    return ToolTip;
    return;
}

function bool IsAllWhiteID(int m_targetID)
{
    local bool bIsAllWhiteName;

    bIsAllWhiteName = false;
    switch(m_targetID)
    {
        // End:0x17
        case 12775:
        // End:0x1F
        case 12776:
        // End:0x27
        case 12778:
        // End:0x2F
        case 12779:
        // End:0x37
        case 13016:
        // End:0x3F
        case 13017:
        // End:0x47
        case 13031:
        // End:0x4F
        case 13032:
        // End:0x57
        case 13033:
        // End:0x5F
        case 13034:
        // End:0x67
        case 13035:
        // End:0x6F
        case 13036:
        // End:0x77
        case 13098:
        // End:0x7F
        case 13120:
        // End:0x87
        case 13121:
        // End:0x8F
        case 13122:
        // End:0x97
        case 13123:
        // End:0x9F
        case 13124:
        // End:0xA7
        case 13271:
        // End:0xAF
        case 13272:
        // End:0xB7
        case 13273:
        // End:0xBF
        case 13274:
        // End:0xC7
        case 13275:
        // End:0xCF
        case 13276:
        // End:0xD7
        case 13277:
        // End:0xDF
        case 13278:
        // End:0xE7
        case 13187:
        // End:0xEF
        case 13188:
        // End:0xF7
        case 13189:
        // End:0xFF
        case 13190:
        // End:0x107
        case 13191:
        // End:0x10F
        case 13192:
        // End:0x117
        case 13286:
        // End:0x11F
        case 13287:
        // End:0x127
        case 13288:
        // End:0x12F
        case 13289:
        // End:0x137
        case 13290:
        // End:0x13F
        case 13291:
        // End:0x147
        case 13292:
        // End:0x14F
        case 13342:
        // End:0x157
        case 13343:
        // End:0x15F
        case 13344:
        // End:0x167
        case 13345:
        // End:0x16F
        case 13346:
        // End:0x177
        case 13347:
        // End:0x17F
        case 13348:
        // End:0x187
        case 13349:
        // End:0x18F
        case 13400:
        // End:0x197
        case 13401:
        // End:0x19F
        case 13402:
        // End:0x1A7
        case 13404:
        // End:0x1AF
        case 13405:
        // End:0x1B7
        case 13406:
        // End:0x1BF
        case 26089:
        // End:0x1C7
        case 13419:
        // End:0x1CF
        case 13420:
        // End:0x1D7
        case 13421:
        // End:0x1DF
        case 13422:
        // End:0x1E7
        case 26091:
        // End:0x1EF
        case 26248:
        // End:0x1F7
        case 13551:
        // End:0x20A
        case 13552:
            bIsAllWhiteName = true;
            // End:0x210
            break;
        // End:0xFFFF
        default:
            // End:0x210
            break;
            break;
    }
    return bIsAllWhiteName;
    return;
}

function bool IsNoBarID(int m_targetID)
{
    local bool bIsNoBarName;

    bIsNoBarName = false;
    switch(m_targetID)
    {
        // End:0x17
        case 13036:
        // End:0x2A
        case 13098:
            bIsNoBarName = true;
            // End:0x30
            break;
        // End:0xFFFF
        default:
            // End:0x30
            break;
            break;
    }
    return bIsNoBarName;
    return;
}

function HandleTargetSpelledList(string param)
{
    local int i, Max, B, targetID;
    local StatusIconInfo Info;

    ClearAll();
    ParseInt(param, "ID", targetID);
    ParseInt(param, "Max", Max);
    i = 0;
    J0x36:

    // End:0x228 [Loop If]
    if(i < Max)
    {
        ParseInt(param, "ClassID_" $ string(i), Info.Id.ClassID);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        // End:0xF4
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            // [Explicit Continue]
            goto J0x21E;
        }
        ParseInt(param, "Sec_" $ string(i), Info.RemainTime);
        ParseInt(param, "OwnerShip_" $ string(i), B);
        Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, Info.SubLevel);
        Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
        Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, Info.SubLevel);
        // End:0x200
        if(B == 0)
        {
            Info.bOwnership = false;            
        }
        else
        {
            Info.bOwnership = true;
        }
        Info = SelectTexture(Info);
        J0x21E:

        i++;
        // [Loop Continue]
        goto J0x36;
    }
    MyBuffDraw();
    OtherBuffDraw();
    MyDebuffDraw();
    OtherDebuffDraw();
    moveBuffWndMoreView2();
    return;
}

function MyBuffDraw()
{
    local int i, Length;
    local array<StatusIconInfo> temp;
    local TargetStatusBuff1Wnd script;

    script = TargetStatusBuff1Wnd(GetScript("TargetStatusBuff1Wnd"));
    script.ResetBuffIcon();
    Length = arrMyBuff.Length;
    // End:0xBB
    if((Length > 0) && Length < 9)
    {
        showBuffMoreBtn(false, 1);
        StatusIcons.AddRow();
        i = 0;
        J0x79:

        // End:0xB1 [Loop If]
        if(i < Length)
        {
            StatusIcons.AddCol(LineCount, arrMyBuff[i]);
            i++;
            // [Loop Continue]
            goto J0x79;
        }
        LineCount++;        
    }
    else
    {
        // End:0x176
        if(Length >= 9)
        {
            showBuffMoreBtn(true, 1);
            StatusIcons.AddRow();
            i = 0;
            J0xE5:

            // End:0x15B [Loop If]
            if(i < Length)
            {
                // End:0x129
                if(i > (Length - 9))
                {
                    StatusIcons.AddCol(LineCount, arrMyBuff[i]);
                    // [Explicit Continue]
                    goto J0x151;
                }
                temp.Insert(temp.Length, 1);
                temp[temp.Length - 1] = arrMyBuff[i];
                J0x151:

                i++;
                // [Loop Continue]
                goto J0xE5;
            }
            script.showBuff(temp);
            LineCount++;
        }
    }
    return;
}

function OtherBuffDraw()
{
    local int i;

    // End:0x89
    if(arrOtherBuff.Length > 0)
    {
        StatusIcons.AddRow();
        i = 0;
        J0x22:

        // End:0x82 [Loop If]
        if(i < arrOtherBuff.Length)
        {
            // End:0x78
            if(i > (arrOtherBuff.Length - 13))
            {
                arrOtherBuff[i].bHideRemainTime = true;
                StatusIcons.AddCol(LineCount, arrOtherBuff[i]);
            }
            i++;
            // [Loop Continue]
            goto J0x22;
        }
        LineCount++;
    }
    return;
}

function MyDebuffDraw()
{
    local int i, Length;
    local array<StatusIconInfo> temp;
    local TargetStatusBuff2Wnd script;

    script = TargetStatusBuff2Wnd(GetScript("TargetStatusBuff2Wnd"));
    script.ResetBuffIcon();
    Length = arrMyDebuff.Length;
    // End:0xBC
    if((Length > 0) && Length < 9)
    {
        showBuffMoreBtn(false, 2);
        StatusIcons.AddRow();
        i = 0;
        J0x7A:

        // End:0xB2 [Loop If]
        if(i < Length)
        {
            StatusIcons.AddCol(LineCount, arrMyDebuff[i]);
            i++;
            // [Loop Continue]
            goto J0x7A;
        }
        LineCount++;        
    }
    else
    {
        // End:0x178
        if(Length >= 9)
        {
            showBuffMoreBtn(true, 2);
            StatusIcons.AddRow();
            i = 0;
            J0xE7:

            // End:0x15D [Loop If]
            if(i < Length)
            {
                // End:0x12B
                if(i > (Length - 9))
                {
                    StatusIcons.AddCol(LineCount, arrMyDebuff[i]);
                    // [Explicit Continue]
                    goto J0x153;
                }
                temp.Insert(temp.Length, 1);
                temp[temp.Length - 1] = arrMyDebuff[i];
                J0x153:

                i++;
                // [Loop Continue]
                goto J0xE7;
            }
            script.showBuff(temp);
            LineCount++;
        }
    }
    return;
}

function OtherDebuffDraw()
{
    local int i, Num;

    Num = 0;
    // End:0xB9
    if(arrOtherDebuff.Length > 0)
    {
        StatusIcons.AddRow();
        i = 0;
        J0x29:

        // End:0xB2 [Loop If]
        if(i < arrOtherDebuff.Length)
        {
            // End:0xA8
            if(i > (arrOtherDebuff.Length - 25))
            {
                // End:0x6F
                if(Num == 12)
                {
                    StatusIcons.AddRow();
                    LineCount++;
                }
                Num++;
                arrOtherDebuff[i].bHideRemainTime = true;
                StatusIcons.AddCol(LineCount, arrOtherDebuff[i]);
            }
            i++;
            // [Loop Continue]
            goto J0x29;
        }
        LineCount++;
    }
    return;
}

function ClearAll()
{
    LineCount = 0;
    showBuffMoreBtn(false, 1);
    showBuffMoreBtn(false, 2);
    ResetArray();
    ResetBuffIcon();
    return;
}

function ResetArray()
{
    arrMyBuff.Remove(0, arrMyBuff.Length);
    arrOtherBuff.Remove(0, arrOtherBuff.Length);
    arrMyDebuff.Remove(0, arrMyDebuff.Length);
    arrOtherDebuff.Remove(0, arrOtherDebuff.Length);
    return;
}

function ResetBuffIcon()
{
    StatusIcons.Clear();
    return;
}

function StatusIconInfo SelectTexture(StatusIconInfo Info)
{
    Info.bShow = true;
    // End:0xFB
    if(GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0)
    {
        // End:0xA0
        if(Info.bOwnership)
        {
            Info.Size = 24;
            Info.BackTex = "L2UI_CT1.Buff.DeBuffFrame_24";
            arrMyDebuff.Insert(arrMyDebuff.Length, 1);
            arrMyDebuff[arrMyDebuff.Length - 1] = Info;            
        }
        else
        {
            Info.Size = 16;
            Info.BackTex = "L2UI_CT1.Buff.DeBuffFrame_16";
            arrOtherDebuff.Insert(arrOtherDebuff.Length, 1);
            arrOtherDebuff[arrOtherDebuff.Length - 1] = Info;
        }        
    }
    else
    {
        // End:0x1E9
        if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
        {
            // End:0x18E
            if(Info.bOwnership)
            {
                Info.Size = 24;
                Info.BackTex = "L2UI_CT1.Buff.BuffFrame_24_3";
                arrMyBuff.Insert(arrMyBuff.Length, 1);
                arrMyBuff[arrMyBuff.Length - 1] = Info;                
            }
            else
            {
                Info.Size = 16;
                Info.BackTex = "L2UI_CT1.Buff.BuffFrame_16_3";
                arrOtherBuff.Insert(arrOtherBuff.Length, 1);
                arrOtherBuff[arrOtherBuff.Length - 1] = Info;
            }            
        }
        else
        {
            // End:0x2D7
            if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                // End:0x27C
                if(Info.bOwnership)
                {
                    Info.Size = 24;
                    Info.BackTex = "L2UI_CT1.Buff.BuffFrame_24_2";
                    arrMyBuff.Insert(arrMyBuff.Length, 1);
                    arrMyBuff[arrMyBuff.Length - 1] = Info;                    
                }
                else
                {
                    Info.Size = 16;
                    Info.BackTex = "L2UI_CT1.Buff.BuffFrame_16_2";
                    arrOtherBuff.Insert(arrOtherBuff.Length, 1);
                    arrOtherBuff[arrOtherBuff.Length - 1] = Info;
                }                
            }
            else
            {
                // End:0x340
                if(Info.bOwnership)
                {
                    Info.Size = 24;
                    Info.BackTex = "L2UI_CT1.Buff.BuffFrame_24_1";
                    arrMyBuff.Insert(arrMyBuff.Length, 1);
                    arrMyBuff[arrMyBuff.Length - 1] = Info;                    
                }
                else
                {
                    Info.Size = 16;
                    Info.BackTex = "L2UI_CT1.Buff.BuffFrame_16_1";
                    arrOtherBuff.Insert(arrOtherBuff.Length, 1);
                    arrOtherBuff[arrOtherBuff.Length - 1] = Info;
                }
            }
        }
    }
    return Info;
    return;
}

function showBuffMoreBtn(bool B, int N)
{
    // End:0x49
    if(B == true)
    {
        GetButtonHandle((m_WindowName $ ".BuffWnd.btnBuffMoreView") $ string(N)).ShowWindow();        
    }
    else
    {
        GetButtonHandle((m_WindowName $ ".BuffWnd.btnBuffMoreView") $ string(N)).HideWindow();
    }
    return;
}

function moveBuffWndMoreView2()
{
    // End:0x17
    if(arrMyBuff.Length > 0)
    {
        yPosView2 = 26;        
    }
    else
    {
        yPosView2 = 0;
    }
    // End:0x39
    if(arrOtherBuff.Length > 0)
    {
        yPosView2 = yPosView2 + 18;
    }
    btnBuffMoreView2.MoveTo(BuffWnd.GetRect().nX, BuffWnd.GetRect().nY + yPosView2);
    return;
}

event OnMouseOver(WindowHandle W)
{
    // End:0x21
    if(btnBuffMoreView1 == W)
    {
        TargetStatusBuff1Wnd.ShowWindow();        
    }
    else
    {
        // End:0x3F
        if(btnBuffMoreView2 == W)
        {
            TargetStatusBuff2Wnd.ShowWindow();
        }
    }
    return;
}

event OnMouseOut(WindowHandle W)
{
    // End:0x21
    if(btnBuffMoreView1 == W)
    {
        TargetStatusBuff1Wnd.HideWindow();        
    }
    else
    {
        // End:0x3F
        if(btnBuffMoreView2 == W)
        {
            TargetStatusBuff2Wnd.HideWindow();
        }
    }
    return;
}

function HandleTargetSkillInfo(string param)
{
    local int bIsHostile, bUseSlot1;
    local float fTotalTimeSlot1, fElapsedTimeSlot1;
    local string SkillNameSlot1;
    local int Resistcast1, bUseSlot2;
    local float fTotalTimeSlot2, fElapsedTimeSlot2;
    local string SkillNameSlot2;
    local int Resistcast2;
    local Color White, Red;

    Red.R = byte(255);
    Red.G = 0;
    Red.B = 0;
    Red.A = byte(255);
    White.R = byte(255);
    White.G = byte(255);
    White.B = byte(255);
    White.A = byte(255);
    ParseInt(param, "bIsHostile", bIsHostile);
    // End:0xAE
    if(bIsHostile == 0)
    {
        strSelectTarget = "Friendly";        
    }
    else
    {
        strSelectTarget = "Enemy";
    }
    ParseInt(param, "bUseSlot1", bUseSlot1);
    ParseFloat(param, "fTotalTimeSlot1", fTotalTimeSlot1);
    ParseFloat(param, "fElapsedTimeSlot1", fElapsedTimeSlot1);
    ParseString(param, "SkillNameSlot1", SkillNameSlot1);
    ParseInt(param, "ResistCast1", Resistcast1);
    ParseInt(param, "bUseSlot2", bUseSlot2);
    ParseFloat(param, "fTotalTimeSlot2", fTotalTimeSlot2);
    ParseFloat(param, "fElapsedTimeSlot2", fElapsedTimeSlot2);
    ParseString(param, "SkillNameSlot2", SkillNameSlot2);
    ParseInt(param, "ResistCast2", Resistcast2);
    // End:0x21E
    if(GetOptionBool("ScreenInfo", "SkillCastingBox") == false)
    {
        return;
    }
    // End:0x2DC
    if(bUseSlot1 != 0)
    {
        // End:0x2D9
        if(fTotalTimeSlot1 > float(0))
        {
            Me.KillTimer(5270);
            Me.KillTimer(5272);
            SetTextureBar("Progress", 1);
            SetEffectTexture("Progress", 1);
            showSkillSlot(fTotalTimeSlot1, fElapsedTimeSlot1, 1);
            // End:0x2BC
            if(Resistcast1 == 1)
            {
                skillProgressName1.SetNameWithColor(SkillNameSlot1, 0, 2, Red);                
            }
            else
            {
                skillProgressName1.SetNameWithColor(SkillNameSlot1, 0, 2, White);
            }
        }        
    }
    else
    {
        skillBarVisible(false, 1);
        barSkillProgress1.Reset();
    }
    // End:0x3B4
    if(bUseSlot2 != 0)
    {
        // End:0x3B1
        if(fTotalTimeSlot1 > float(0))
        {
            Me.KillTimer(5271);
            Me.KillTimer(5272);
            SetTextureBar("Progress", 2);
            SetEffectTexture("Progress", 2);
            showSkillSlot(fTotalTimeSlot2, fElapsedTimeSlot2, 2);
            // End:0x394
            if(Resistcast2 == 1)
            {
                skillProgressName2.SetNameWithColor(SkillNameSlot2, 0, 2, Red);                
            }
            else
            {
                skillProgressName2.SetNameWithColor(SkillNameSlot2, 0, 2, White);
            }
        }        
    }
    else
    {
        skillBarVisible(false, 2);
        barSkillProgress2.Reset();
    }
    return;
}

function showSkillSlot(float total, float elapsed, int Slot)
{
    skillBarVisible(true, Slot);
    GetProgressCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot)).Stop();
    GetProgressCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot)).Reset();
    GetProgressCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot)).SetProgressTime(int(total));
    GetProgressCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot)).SetPos(int(total - elapsed));
    GetProgressCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot)).Start();
    return;
}

function OnProgressTimeUp(string strID)
{
    // End:0x59
    if(strID == "barSkillProgress1")
    {
        SetTextureBar("Success", 1);
        SetEffectTexture("Success", 1);
        Me.SetTimer(5270, 1000);        
    }
    else
    {
        // End:0xB1
        if(strID == "barSkillProgress2")
        {
            SetTextureBar("Success", 2);
            SetEffectTexture("Success", 2);
            Me.SetTimer(5271, 1000);
        }
    }
    return;
}

function HandleSkillCancel()
{
    SetTextureBar("Failed", 1);
    SetEffectTexture("Failed", 1);
    barSkillProgress1.Stop();
    SetTextureBar("Failed", 2);
    SetEffectTexture("Failed", 2);
    barSkillProgress2.Stop();
    Me.SetTimer(5272, 1000);
    return;
}

function skillBarVisible(bool flag, int Slot)
{
    // End:0x1E0
    if(flag == true)
    {
        GetNameCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "skillProgressName") $ string(Slot)).ShowWindow();
        GetProgressCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot)).ShowWindow();
        GetTextureHandle((((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Left").ShowWindow();
        GetTextureHandle((((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Center").ShowWindow();
        GetTextureHandle((((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Right").ShowWindow();        
    }
    else
    {
        // End:0x1FD
        if(Slot == 1)
        {
            barSkillProgress1.Reset();            
        }
        else
        {
            barSkillProgress2.Reset();
        }
        GetNameCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "skillProgressName") $ string(Slot)).HideWindow();
        GetProgressCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot)).HideWindow();
        GetProgressCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot)).Reset();
        GetTextureHandle((((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Left").HideWindow();
        GetTextureHandle((((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Center").HideWindow();
        GetTextureHandle((((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Right").HideWindow();
    }
    return;
}

function SetTextureBar(string stateString, int Slot)
{
    GetProgressCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot)).SetBackTex(((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Bg_Left", ((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Bg_Center", ((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Bg_Right");
    GetProgressCtrlHandle(((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgress") $ string(Slot)).SetBarTex(((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Gage_Left", ((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Gage_Center", ((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Gage_Right");
    return;
}

function SetEffectTexture(string stateString, int Slot)
{
    GetTextureHandle((((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Left").SetTexture(((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Eff_Left");
    GetTextureHandle((((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Center").SetTexture(((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Eff_Center");
    GetTextureHandle((((((m_WindowName $ ".SkillProgressWnd") $ string(Slot)) $ ".") $ "barSkillProgressEff") $ string(Slot)) $ "_Right").SetTexture(((("L2UI_ct1.SkillOperate_DF_" $ strSelectTarget) $ "_") $ stateString) $ "_Eff_Right");
    return;
}

function StateBoxShow(bool B)
{
    // End:0x1E
    if(B == true)
    {
        BuffWnd.ShowWindow();        
    }
    else
    {
        BuffWnd.HideWindow();
    }
    return;
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local Rect rectWnd;
    local int targetID;
    local string Username;
    local UserInfo MyInfo;

    rectWnd = Me.GetRect();
    targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
    // End:0xF6
    if(targetID > 0)
    {
        GetPlayerInfo(MyInfo);
        // End:0xF6
        if((X > rectWnd.nX) && X < (rectWnd.nX + rectWnd.nWidth))
        {
            // End:0xF6
            if((Y > rectWnd.nY) && Y < (rectWnd.nY + rectWnd.nHeight))
            {
                Username = Class'NWindow.UIDATA_USER'.static.GetUserName(targetID);
                // End:0xF6
                if(Username != "")
                {
                    getInstanceContextMenu().execContextEvent(Username, targetID, X, Y);
                }
            }
        }
    }
    return;
}

function int GetTargetID()
{
    return m_targetID;
    return;
}

function OnReceivedCloseUI()
{
    OnCloseButton();
    return;
}

defaultproperties
{
    m_WindowName="TargetStatusWnd"
    m_bUseMockTargetGearScore=true
}