class StatusWnd extends UICommonAPI;

const TIMER_ID1 = 1310;
const TIMER_DELAY1 = 500;
const TIMER_ID2 = 1311;
const TIMER_DELAY2 = 20000;
const TIMER_PREM1 = 1312;
const TIMER_PREM_DELAY1 = 600;
const TIMER_PREM2 = 1313;
const TIMER_PREM_DELAY2 = 30000;
const ANIMMINALPHA = 39;
const ANIMMAXALPHA = 197;
const ANIMSPEEDFLOAT = 0.40f;
const NAVIT_TIMER_ID2 = 7001;
const NAVIT_TIMER_DELAY2 = 500;
const ULTIMATE_SKILL_POINT_BOUNDARY_LEVEL1 = 500;
const ULTIMATE_SKILL_POINT_BOUNDARY_LEVEL2 = 1000;
const ULTIMATE_SKILL_POINT_BOUNDARY_LEVEL3 = 1500;
const WINDOW_MIN_SIZE_HEIGHT = 82;
const WINDOW_MAX_SIZE_HEIGHT = 102;
const WINDOW_CLASSIC_SIZE_HEIGHT = 68;
const FINALITYSPEEDFLOAT = 0.40f;
const FINALITYSPEEDFLOAT2 = 0.20f;
const TIMER_BAR = 1410;
const TIMER_BAR_DELAY = 400;
const MaxVitalityTime = 20;

var int m_UserID;
var bool m_bReceivedUserInfo;
var int GlobalAlpha;
var bool GlobalAlphaBool;
var bool AnimTexKill;
var TextBoxHandle VPPercentTxt;
var bool isVPApplyChecked;
var bool isAfterStatusNormaEvent;
var bool isVPApply;
var int m_Vitality;
var WindowHandle Me;
var StatusBarHandle CPBar;
var StatusBarHandle HPBar;
var StatusBarHandle MPBar;
var NameCtrlHandle Username;
var TextBoxHandle StatusWnd_LevelTextBox;
var TextureHandle VitalityTex;
var StatusBarHandle VpDetailBar;
var BarHandle barFATIGUE;
var TextureHandle texNavitGaugeLeft;
var TextureHandle texNavitGaugeMid;
var TextureHandle texNavitGaugeRight;
var int m_NavitEffectRemainSec;
var int m_NavitGradeEffectFactor;
var WindowHandle FinalityGageWnd;
var BarHandle FinalityBar01;
var TextureHandle FinalityGageEff1_Left;
var TextureHandle FinalityGageEff1_Center;
var TextureHandle FinalityGageEff1_Right;
var BarHandle FinalityBar02;
var TextureHandle FinalityGageEff2_Left;
var TextureHandle FinalityGageEff2_Center;
var TextureHandle FinalityGageEff2_Right;
var BarHandle FinalityBar03;
var TextureHandle FinalityGageEff3_Left;
var TextureHandle FinalityGageEff3_Center;
var TextureHandle FinalityGageEff3_Right;
var TextureHandle StatusWndBg;
var int preFinalityLev;
var int nowFinalityLev;
var int VitalityPer20;
var int MaxVitality;
var int nVitalityExtraBonus;
var int nVitalityBonus;
var int nVitalityItemMaxRestoreCount;
var L2Util util;
var bool AnimTexKillPremium;
var int m_CurPremiumState;
var bool m_AlphaIncrese;
var WindowHandle LevelBoxTexPremium;
var TextureHandle StatusWnd_LevelTextBox_back;
var TextBoxHandle StatusWnd_LevelTextBoxAfter100;
var WindowHandle LevelWindowUnder100;
var WindowHandle LevelWindowAfter100;
var WindowHandle LevelBoxTexPremium100;

function OnRegisterEvent()
{
    RegisterEvent(70);
    RegisterEvent(180);
    RegisterEvent(191);
    RegisterEvent(201);
    RegisterEvent(211);
    RegisterEvent(221);
    RegisterEvent(231);
    RegisterEvent(241);
    RegisterEvent(5110);
    RegisterEvent(5150);
    RegisterEvent(4110);
    RegisterEvent(9080);
    RegisterEvent(8000);
    RegisterEvent(950);
    RegisterEvent(3410);
    RegisterEvent(7777);
    return;
}

function OnShow()
{
    GetButtonHandle("StatusWnd.CombatModeBtn").HideWindow();
    return;
}

function OnLoad()
{
    InitHandleCOD();
    GlobalAlpha = 0;
    GlobalAlphaBool = true;
    InitAnimation();
    FinalityBar01.SetValue(0, 0);
    FinalityBar02.SetValue(0, 0);
    FinalityBar03.SetValue(0, 0);
    preFinalityLev = 0;
    nowFinalityLev = 0;
    MaxVitality = 20000;
    LevelBoxTexPremium.HideWindow();
    LevelBoxTexPremium100.HideWindow();
    GetButtonHandle("StatusWnd.CombatModeBtn").HideWindow();
    return;
}

function InitHandleCOD()
{
    Me = GetWindowHandle("StatusWnd");
    CPBar = GetStatusBarHandle("StatusWnd.CPBar");
    HPBar = GetStatusBarHandle("StatusWnd.HPBar");
    MPBar = GetStatusBarHandle("StatusWnd.MPBar");
    Username = GetNameCtrlHandle("StatusWnd.UserName");
    StatusWnd_LevelTextBox = GetTextBoxHandle("StatusWnd.StatusWnd_LevelTextBox_back.StatusWnd_LevelTextBox");
    VitalityTex = GetTextureHandle("StatusWnd.LifeForceTex");
    VpDetailBar = GetStatusBarHandle("StatusWnd.VpDetailBar");
    FinalityGageWnd = GetWindowHandle("StatusWnd.FinalityGageWnd.FinalityGageWnd");
    FinalityBar01 = GetBarHandle("StatusWnd.FinalityGageWnd.FinalityBar01");
    FinalityGageEff1_Left = GetTextureHandle("StatusWnd.FinalityGageWnd.FinalityGageEff1_Left");
    FinalityGageEff1_Center = GetTextureHandle("StatusWnd.FinalityGageWnd.FinalityGageEff1_Center");
    FinalityGageEff1_Right = GetTextureHandle("StatusWnd.FinalityGageWnd.FinalityGageEff1_Right");
    FinalityBar02 = GetBarHandle("StatusWnd.FinalityGageWnd.FinalityBar02");
    FinalityGageEff2_Left = GetTextureHandle("StatusWnd.FinalityGageWnd.FinalityGageEff2_Left");
    FinalityGageEff2_Center = GetTextureHandle("StatusWnd.FinalityGageWnd.FinalityGageEff2_Center");
    FinalityGageEff2_Right = GetTextureHandle("StatusWnd.FinalityGageWnd.FinalityGageEff2_Right");
    FinalityBar03 = GetBarHandle("StatusWnd.FinalityGageWnd.FinalityBar03");
    FinalityGageEff3_Left = GetTextureHandle("StatusWnd.FinalityGageWnd.FinalityGageEff3_Left");
    FinalityGageEff3_Center = GetTextureHandle("StatusWnd.FinalityGageWnd.FinalityGageEff3_Center");
    FinalityGageEff3_Right = GetTextureHandle("StatusWnd.FinalityGageWnd.FinalityGageEff3_Right");
    StatusWndBg = GetTextureHandle("StatusWnd.FinalityGageWnd.StatusWndBg");
    LevelBoxTexPremium = GetWindowHandle("StatusWnd.StatusWnd_LevelTextBox_back.WndLevelBackPremium");
    LevelWindowUnder100 = GetWindowHandle("StatusWnd.StatusWnd_LevelTextBox_back");
    LevelWindowAfter100 = GetWindowHandle("StatusWnd.StatusWnd_LevelTextBox_back_lv100");
    StatusWnd_LevelTextBoxAfter100 = GetTextBoxHandle("StatusWnd.StatusWnd_LevelTextBox_back_lv100.StatusWnd_LevelTextBox");
    LevelBoxTexPremium100 = GetWindowHandle("StatusWnd.StatusWnd_LevelTextBox_back_lv100.WndLevelBackPremium_Lv100");
    VPPercentTxt = GetTextBoxHandle("StatusWnd.VPPercentTxt");
    return;
}

function OnTimer(int TimerID)
{
    // End:0x17
    if(TimerID == 1311)
    {
        AnimTexKill = true;
    }
    // End:0x2C
    if(TimerID == 7001)
    {
        OnTimerNavit();
    }
    // End:0x55
    if(TimerID == 1410)
    {
        FinalityBarSetAlpha();
        Me.KillTimer(1410);
    }
    // End:0x143
    if(TimerID == 1312)
    {
        // End:0xA4
        if(m_AlphaIncrese)
        {
            LevelBoxTexPremium.SetAlpha(197, 0.4000000);
            LevelBoxTexPremium100.SetAlpha(197, 0.4000000);
            m_AlphaIncrese = false;            
        }
        else
        {
            // End:0x143
            if(!m_AlphaIncrese)
            {
                // End:0x10F
                if(AnimTexKillPremium)
                {
                    Me.KillTimer(1312);
                    Me.KillTimer(1313);
                    LevelBoxTexPremium.SetAlpha(255, 1.0000000);
                    LevelBoxTexPremium100.SetAlpha(255, 1.0000000);                    
                }
                else
                {
                    LevelBoxTexPremium.SetAlpha(39, 0.4000000);
                    LevelBoxTexPremium100.SetAlpha(39, 0.4000000);
                }
                m_AlphaIncrese = true;
            }
        }
    }
    // End:0x15A
    if(TimerID == 1313)
    {
        AnimTexKillPremium = true;
    }
    return;
}

function FinalityBarSetAlpha()
{
    local int i;

    i = 1;
    J0x07:

    // End:0x11C [Loop If]
    if(i <= 3)
    {
        GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Left").SetAlpha(125, 0.4000000);
        GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Center").SetAlpha(125, 0.4000000);
        GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Right").SetAlpha(125, 0.4000000);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function PlayAnimation()
{
    Me.KillTimer(1310);
    Me.KillTimer(1311);
    AnimTexKill = false;
    Me.SetTimer(1310, 500);
    Me.SetTimer(1311, 20000);
    return;
}

function InitAnimation()
{
    Me.KillTimer(1310);
    Me.KillTimer(1311);
    Me.KillTimer(1312);
    Me.KillTimer(1313);
    LevelBoxTexPremium.SetAlpha(1);
    LevelBoxTexPremium100.SetAlpha(39, 0.4000000);
    return;
}

function OnEnterState(name a_PreStateName)
{
    isVPApplyChecked = false;
    m_bReceivedUserInfo = false;
    isAfterStatusNormaEvent = false;
    return;
}

function UpdateUserGauge(int Type)
{
    local UserInfo UserInfo;

    // End:0xAA
    if(GetPlayerInfo(UserInfo))
    {
        m_UserID = UserInfo.nID;
        switch(Type)
        {
            // End:0x4F
            case 0:
                HPBar.SetPoint(UserInfo.nCurHP, UserInfo.nMaxHP);
                // End:0xAA
                break;
            // End:0x79
            case 1:
                MPBar.SetPoint(UserInfo.nCurMP, UserInfo.nMaxMP);
                // End:0xAA
                break;
            // End:0xA4
            case 2:
                CPBar.SetPoint(UserInfo.nCurCP, UserInfo.nMaxCP);
                // End:0xAA
                break;
            // End:0xFFFF
            default:
                // End:0xAA
                break;
                break;
        }
    }
    return;
}

function UpdateUserInfo()
{
    local UserInfo UserInfo;
    local int vitality;

    // End:0x294
    if(GetPlayerInfo(UserInfo))
    {
        m_UserID = UserInfo.nID;
        vitality = UserInfo.nVitality;
        CPBar.SetPoint(UserInfo.nCurCP, UserInfo.nMaxCP);
        HPBar.SetPoint(UserInfo.nCurHP, UserInfo.nMaxHP);
        MPBar.SetPoint(UserInfo.nCurMP, UserInfo.nMaxMP);
        VpDetailBar.SetPoint(vitality, MaxVitality);
        DetailStatusWnd(GetScript("DetailStatusWnd")).texVP.SetPoint(vitality, MaxVitality);
        Username.SetName(UserInfo.Name, 0, 1);
        // End:0x17D
        if(Class'NWindow.UIDATA_USER'.static.IsPrologueGrowType(UserInfo.nSubClass) && !getInstanceUIData().getIsArenaServer())
        {
            // End:0x167
            if(int(GetLanguage()) == 0)
            {
                StatusWnd_LevelTextBox.SetText("ï¿½ï¿½");                
            }
            else
            {
                StatusWnd_LevelTextBox.SetText("--");
            }            
        }
        else
        {
            StatusWnd_LevelTextBox.SetInt(UserInfo.nLevel);
        }
        StatusWnd_LevelTextBoxAfter100.SetInt(UserInfo.nLevel);
        // End:0x211
        if(UserInfo.nLevel > 99)
        {
            Username.SetAnchor("StatusWnd", "TopLeft", "TopLeft", 53, 8);
            LevelWindowUnder100.HideWindow();
            LevelWindowAfter100.ShowWindow();            
        }
        else
        {
            Username.SetAnchor("StatusWnd", "TopLeft", "TopLeft", 45, 8);
            LevelWindowUnder100.ShowWindow();
            LevelWindowAfter100.HideWindow();
        }
        // End:0x279
        if(vitality != m_Vitality)
        {
            UpdateVp(vitality);
        }
        UpdateVp(vitality);
        UpdateUltimateSkillPoint(UserInfo.UltimateSkillPoint);
    }
    return;
}

function UpdateUltimateSkillPoint(int point)
{
    local int UltimateSkillLevel;
    local string ani;

    UltimateSkillLevel = GetActivityUltimateSkillLevel();
    nowFinalityLev = UltimateSkillLevel;
    // End:0x33
    if(preFinalityLev < UltimateSkillLevel)
    {
        ani = "up";        
    }
    else
    {
        // End:0x51
        if(preFinalityLev > UltimateSkillLevel)
        {
            ani = "down";            
        }
        else
        {
            // End:0x6B
            if(UltimateSkillLevel == 0)
            {
                ani = "zero";                
            }
            else
            {
                ani = "none";
            }
        }
    }
    // End:0xBF
    if(UltimateSkillLevel == 0)
    {
        FinalityBar01.SetValue(500, point);
        FinalityBar02.SetValue(0, 10);
        FinalityBar03.SetValue(0, 10);
    }
    // End:0x112
    if(UltimateSkillLevel == 1)
    {
        FinalityBar01.SetValue(10, 10);
        FinalityBar02.SetValue(500, point - 500);
        FinalityBar03.SetValue(0, 10);        
    }
    else
    {
        // End:0x167
        if(UltimateSkillLevel == 2)
        {
            FinalityBar01.SetValue(10, 10);
            FinalityBar02.SetValue(10, 10);
            FinalityBar03.SetValue(500, point - 1000);            
        }
        else
        {
            // End:0x1AC
            if(UltimateSkillLevel == 3)
            {
                FinalityBar01.SetValue(10, 10);
                FinalityBar02.SetValue(10, 10);
                FinalityBar03.SetValue(10, 10);
            }
        }
    }
    OnOffFinalityGage(ani);
    return;
}

function setInitFinalityBar()
{
    local int i;

    i = 1;
    J0x07:

    // End:0x46 [Loop If]
    if(i <= 3)
    {
        GetBarHandle("FinalityBar0" $ string(i)).SetValue(0, 0);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnOffFinalityGage(string ani)
{
    local int i;

    // End:0x43C
    if(ani == "up")
    {
        i = 1;
        J0x15:

        // End:0x439 [Loop If]
        if(i <= 3)
        {
            // End:0x333
            if((i > preFinalityLev) && i <= nowFinalityLev)
            {
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Left").ShowWindow();
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Center").ShowWindow();
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Right").ShowWindow();
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Left").SetAlpha(0);
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Center").SetAlpha(0);
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Right").SetAlpha(0);
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Left").SetAlpha(255, 0.4000000);
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Center").SetAlpha(255, 0.4000000);
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Right").SetAlpha(255, 0.4000000);
                Me.SetTimer(1410, 400);
                // [Explicit Continue]
                goto J0x42F;
            }
            // End:0x42F
            if(i > nowFinalityLev)
            {
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Left").HideWindow();
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Center").HideWindow();
                GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Right").HideWindow();
                // [Explicit Continue]
            }
            J0x42F:

            i++;
            // [Loop Continue]
            goto J0x15;
        }        
    }
    else
    {
        // End:0x588
        if(ani == "down")
        {
            i = 1;
            J0x453:

            // End:0x585 [Loop If]
            if(i <= 3)
            {
                // End:0x57B
                if((i <= preFinalityLev) && i > nowFinalityLev)
                {
                    GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Left").SetAlpha(0, 0.2000000);
                    GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Center").SetAlpha(0, 0.2000000);
                    GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Right").SetAlpha(0, 0.2000000);
                }
                i++;
                // [Loop Continue]
                goto J0x453;
            }            
        }
        else
        {
            // End:0x6A2
            if(ani == "zero")
            {
                i = 1;
                J0x59F:

                // End:0x6A2 [Loop If]
                if(i <= 3)
                {
                    GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Left").SetAlpha(0);
                    GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Center").SetAlpha(0);
                    GetTextureHandle(("StatusWnd.FinalityGageWnd.FinalityGageEff" $ string(i)) $ "_Right").SetAlpha(0);
                    i++;
                    // [Loop Continue]
                    goto J0x59F;
                }
            }
        }
    }
    preFinalityLev = nowFinalityLev;
    return;
}

function int getCurrVitalityHou(int vitality)
{
    return int(float(vitality / VitalityPer20) % float(20));
    return;
}

function int getCurrVitalityMin(int vitality)
{
    return int(float(vitality / 60) % float(60));
    return;
}

function int getCurrVitalitySec(int vitality)
{
    return int(float(vitality) % float(60));
    return;
}

function UpdateVp(int vitality)
{
    local int __var19406, __var19408, __var43714, __var43715, __var43716;

    local CustomTooltip t;
    local string __var43718;

    VpDetailBar.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemString(9005), string(m_Vitality))));
    DetailStatusWnd(GetScript("DetailStatusWnd")).texVP.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemString(9005), string(m_Vitality))));
    __var19406 = LevelOfVitality(vitality);
    __var19408 = LevelOfVitality(m_Vitality);
    m_Vitality = vitality;
    // End:0xB9
    if(vitality > 20000)
    {        
    }
    else
    {
        // End:0xCB
        if(vitality >= 17000)
        {            
        }
        else
        {
            // End:0xDD
            if(vitality >= 13000)
            {                
            }
            else
            {
                // End:0xEF
                if(vitality >= 2000)
                {                    
                }
                else
                {
                    // End:0xFE
                    if(vitality >= 240)
                    {                        
                    }
                }
            }
        }
    }
    VpDetailBar.SetPoint(vitality, MaxVitality);
    DetailStatusWnd(GetScript("DetailStatusWnd")).texVP.SetPoint(vitality, MaxVitality);
    VPPercentTxt.SetText(string(nVitalityBonus) $ "%");
    DetailStatusWnd(GetScript("DetailStatusWnd")).VPPercentTxt.SetText(string(nVitalityBonus) $ "%");
    // End:0x1BB
    if(__var19406 != __var19408)
    {
        PlayAnimation();
    }
    // End:0x1DC
    if(!isVPApplyChecked)
    {
        checkVP(vitality);
        isVPApplyChecked = true;        
    }
    else
    {
        // End:0x206
        if(isVPApply)
        {
            // End:0x203
            if(vitality == 0)
            {
                AddSystemMessage(3526);
                isVPApply = false;
            }            
        }
        else
        {
            // End:0x224
            if(vitality > 0)
            {
                AddSystemMessage(3525);
                isVPApply = true;
            }
        }
    }
    return;
}

function checkVP(int vitality)
{
    // End:0x21
    if(vitality > 0)
    {
        AddSystemMessage(3525);
        isVPApply = true;        
    }
    else
    {
        AddSystemMessage(3526);
        isVPApply = false;
    }
    return;
}

function int LevelOfVitality(int vitality)
{
    // End:0x14
    if(vitality > 20000)
    {
        return 0;        
    }
    else
    {
        // End:0x29
        if(vitality >= 17000)
        {
            return 4;            
        }
        else
        {
            // End:0x3E
            if(vitality >= 13000)
            {
                return 3;                
            }
            else
            {
                // End:0x53
                if(vitality >= 2000)
                {
                    return 2;                    
                }
                else
                {
                    // End:0x64
                    if(vitality >= 240)
                    {
                        return 1;                        
                    }
                    else
                    {
                        return 0;
                    }
                }
            }
        }
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local Rect rectWnd;

    switch(a_WindowHandle)
    {
        // End:0x0F
        case CPBar:
        // End:0x17
        case HPBar:
        // End:0x1F
        case MPBar:
        // End:0x27
        case Username:
        // End:0x2F
        case StatusWnd_LevelTextBox:
        // End:0x37
        case VpDetailBar:
        // End:0x3F
        case texNavitGaugeLeft:
        // End:0x47
        case texNavitGaugeMid:
        // End:0xA3
        case texNavitGaugeRight:
            rectWnd = a_WindowHandle.GetRect();
            // End:0xA0
            if((X > rectWnd.nX) && X < (rectWnd.nX + rectWnd.nWidth))
            {
                RequestSelfTarget();
            }
            // End:0x10D
            break;
        // End:0x107
        case Me:
            rectWnd = Me.GetRect();
            // End:0x104
            if((X > (rectWnd.nX + 13)) && X < ((rectWnd.nX + rectWnd.nWidth) - 10))
            {
                RequestSelfTarget();
            }
            // End:0x10D
            break;
        // End:0xFFFF
        default:
            // End:0x10D
            break;
            break;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local string nState;

    switch(a_EventID)
    {
        // End:0x1D
        case 160:
            InitAnimation();
            m_Vitality = 6;
            // End:0x20B
            break;
        // End:0x2B
        case 180:
            UpdateUserInfo();
            // End:0x20B
            break;
        // End:0x3F
        case 191:
            HandleUpdateGauge(a_Param, 0);
            // End:0x20B
            break;
        // End:0x53
        case 201:
            HandleUpdateGauge(a_Param, 0);
            // End:0x20B
            break;
        // End:0x67
        case 211:
            HandleUpdateGauge(a_Param, 1);
            // End:0x20B
            break;
        // End:0x7B
        case 221:
            HandleUpdateGauge(a_Param, 1);
            // End:0x20B
            break;
        // End:0x90
        case 231:
            HandleUpdateGauge(a_Param, 2);
            // End:0x20B
            break;
        // End:0xA5
        case 241:
            HandleUpdateGauge(a_Param, 2);
            // End:0x20B
            break;
        // End:0xB8
        case 70:
            HandleRegenStatus(a_Param);
            // End:0x20B
            break;
        // End:0xC3
        case 5110:
            // End:0x20B
            break;
        // End:0xD9
        case 5150:
            HandleUpdateUltimateSkillPoint(a_Param);
            // End:0x20B
            break;
        // End:0x113
        case 4110:
            // End:0x110
            if(SettingSectorBool("VITALITY", "VitalityEnabled"))
            {
                HandleVitalityEffectInfo(a_Param);
            }
            // End:0x20B
            break;
        // End:0x129
        case 9080:
            HandlePremiumState(a_Param);
            // End:0x20B
            break;
        // End:0x13A
        case 8000:
            checkClassicForm();
            // End:0x20B
            break;
        // End:0x173
        case 950:
            // End:0x170
            if(!getInstanceUIData().getIsClassicServer())
            {
                // End:0x170
                if(!isAfterStatusNormaEvent)
                {
                    isAfterStatusNormaEvent = true;
                    showSystemMsg();
                }
            }
            // End:0x20B
            break;
        // End:0x184
        case 3410:
            checkClassicForm();
            // End:0x20B
            break;
        // End:0x205
        case 7777:
            ParseString(a_Param, "state", nState);
            // End:0x1D9
            if(bool(nState))
            {
                GetButtonHandle("StatusWnd.CombatModeBtn").ShowWindow();                
            }
            else
            {
                GetButtonHandle("StatusWnd.CombatModeBtn").HideWindow();
            }
            // End:0x20B
            break;
        // End:0xFFFF
        default:
            // End:0x20B
            break;
            break;
    }
    return;
}

function checkClassicForm()
{
    local int W, h;

    Me.GetWindowSize(W, h);
    // End:0x9A
    if(!SettingSectorBool("VITALITY", "VitalityEnabled"))
    {
        VpDetailBar.HideWindow();
        Me.SetWindowSize(W, 68);
        StatusWndBg.SetWindowSizeRel(1.0000000, 0.0000000, -14, 68 + 2);
        VPPercentTxt.HideWindow();        
    }
    else
    {
        VpDetailBar.ShowWindow();
        Me.SetWindowSize(W, 82);
        StatusWndBg.SetWindowSizeRel(1.0000000, 0.0000000, -14, 82 + 2);
        VPPercentTxt.ShowWindow();
    }
    return;
}

function HandleNavitAdventEffect(string a_Param)
{
    ParseInt(a_Param, "RemainSeconds", m_NavitEffectRemainSec);
    // End:0xBE
    if(m_NavitEffectRemainSec > 0)
    {
        m_NavitGradeEffectFactor = 0;
        Me.KillTimer(7001);
        Me.SetTimer(7001, 500);
        texNavitGaugeLeft.ShowWindow();
        texNavitGaugeMid.ShowWindow();
        texNavitGaugeRight.ShowWindow();
        texNavitGaugeLeft.SetAlpha(0);
        texNavitGaugeMid.SetAlpha(0);
        texNavitGaugeRight.SetAlpha(0);        
    }
    else
    {
        Me.KillTimer(7001);
        texNavitGaugeLeft.HideWindow();
        texNavitGaugeMid.HideWindow();
        texNavitGaugeRight.HideWindow();
    }
    return;
}

function OnTimerNavit()
{
    // End:0x5A
    if((float(m_NavitGradeEffectFactor) % float(2)) == float(0))
    {
        texNavitGaugeLeft.SetAlpha(39, 0.4000000);
        texNavitGaugeMid.SetAlpha(39, 0.4000000);
        texNavitGaugeRight.SetAlpha(39, 0.4000000);        
    }
    else
    {
        texNavitGaugeLeft.SetAlpha(197, 0.4000000);
        texNavitGaugeMid.SetAlpha(197, 0.4000000);
        texNavitGaugeRight.SetAlpha(197, 0.4000000);
    }
    m_NavitGradeEffectFactor = m_NavitGradeEffectFactor + 1;
    return;
}

function HandleVitalityPointInfo(string param)
{
    local int nVitality;

    ParseInt(param, "Vitality", nVitality);
    UpdateVp(nVitality);
    return;
}

function HandleUpdateGauge(string param, int Type)
{
    local int ServerID;

    // End:0x1C
    if(!m_bReceivedUserInfo)
    {
        m_bReceivedUserInfo = true;
        UpdateUserInfo();        
    }
    else
    {
        ParseInt(param, "ServerID", ServerID);
        // End:0x50
        if(m_UserID == ServerID)
        {
            UpdateUserGauge(Type);
        }
    }
    return;
}

function HandleUpdateInfo(string param)
{
    local int ServerID;

    ParseInt(param, "ServerID", ServerID);
    // End:0x44
    if((m_UserID == ServerID) || !m_bReceivedUserInfo)
    {
        m_bReceivedUserInfo = true;
        UpdateUserInfo();
    }
    return;
}

function HandleRegenStatus(string a_Param)
{
    local int Type, Duration, ticks;
    local float amount;

    ParseInt(a_Param, "Type", Type);
    // End:0x88
    if(Type == 1)
    {
        ParseInt(a_Param, "Duration", Duration);
        ParseInt(a_Param, "Ticks", ticks);
        ParseFloat(a_Param, "Amount", amount);
        HPBar.SetRegenInfo(Duration, ticks, amount);
    }
    return;
}

function HandleUpdateUltimateSkillPoint(string param)
{
    local int ServerID, CurrentUltimateSkillPoint;

    ParseInt(param, "ServerID", ServerID);
    ParseInt(param, "CurrentUltimateSkillPoint", CurrentUltimateSkillPoint);
    UpdateUltimateSkillPoint(CurrentUltimateSkillPoint);
    return;
}

function PlayAnimationPrem()
{
    Me.KillTimer(1312);
    Me.KillTimer(1313);
    AnimTexKillPremium = false;
    Me.SetTimer(1312, 600);
    Me.SetTimer(1313, 30000);
    m_AlphaIncrese = true;
    return;
}

function HandlePremiumState(string a_Param)
{
    local int premiumstate;

    ParseInt(a_Param, "PREMIUMSTATE", premiumstate);
    // End:0x2F
    if(m_CurPremiumState == premiumstate)
    {
        return;
    }
    m_CurPremiumState = premiumstate;
    // End:0x6C
    if(m_CurPremiumState == 1)
    {
        LevelBoxTexPremium.ShowWindow();
        LevelBoxTexPremium100.ShowWindow();
        PlayAnimationPrem();        
    }
    else
    {
        LevelBoxTexPremium.HideWindow();
        LevelBoxTexPremium100.HideWindow();
        InitAnimation();
    }
    return;
}

function HandleVitalityEffectInfo(string param)
{
    local CustomTooltip t;
    local string tmpStr;
    local int nVitality, nVitalityItemRestoreCount;
    local string sSysMsgParamString, sBonusString, sExtraBonusString;

    ParseInt(param, "vitalityPoint", nVitality);
    ParseInt(param, "vitalityBonus", nVitalityBonus);
    ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
    ParseInt(param, "maxRestoreCount", nVitalityItemMaxRestoreCount);
    ParseInt(param, "vitalityExtraBonus", nVitalityExtraBonus);
    sBonusString = string(nVitalityBonus) $ "%";
    // End:0xD7
    if(nVitalityExtraBonus > 0)
    {
        sExtraBonusString = ("(+" $ string(nVitalityExtraBonus)) $ "%)";
    }
    VpDetailBar.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemString(9005), string(m_Vitality))));
    DetailStatusWnd(GetScript("DetailStatusWnd")).texVP.SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemString(9005), string(m_Vitality))));
    sSysMsgParamString = "";
    // End:0x18F
    if((isVPApply && nVitality == 0) || !isVPApply && nVitality > 0)
    {
        showSystemMsg();
    }
    return;
}

function showSystemMsg()
{
    local string sBonusString, sExtraBonusString, sSysMsgParamString;
    local UserInfo UserInfo;
    local int nVitality;
    local string sMessage;

    // End:0x12
    if(!GetPlayerInfo(UserInfo))
    {
        return;
    }
    nVitality = UserInfo.nVitality;
    sBonusString = string(nVitalityBonus) $ "%";
    // End:0x58
    if(nVitalityExtraBonus > 0)
    {
        sExtraBonusString = ("(+" $ string(nVitalityExtraBonus)) $ "%)";
    }
    // End:0x10C
    if(isAfterStatusNormaEvent)
    {
        isVPApply = nVitality > 0;
        // End:0xAE
        if(isVPApply)
        {
            isVPApply = true;
            AddSystemMessageString(MakeFullSystemMsg(GetSystemString(9006), sBonusString @ sExtraBonusString, string(m_Vitality)));            
        }
        else
        {
            ParamAdd(sSysMsgParamString, "Type", string(1));
            ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemMaxRestoreCount));
            AddSystemMessageParam(sSysMsgParamString);
            sMessage = EndSystemMessageParam(6068, true);
            AddSystemMessageString(sMessage);
            isVPApply = false;
        }
    }
    return;
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local Rect rectWnd;
    local int targetID;
    local string Username;
    local UserInfo targetUserInfo;

    rectWnd = Me.GetRect();
    targetID = m_UserID;
    // End:0x10E
    if(targetID > 0)
    {
        // End:0x10E
        if((X > rectWnd.nX) && X < (rectWnd.nX + rectWnd.nWidth))
        {
            // End:0x10E
            if((Y > rectWnd.nY) && Y < (rectWnd.nY + rectWnd.nHeight))
            {
                Username = Class'NWindow.UIDATA_USER'.static.GetUserName(targetID);
                // End:0x10E
                if(Username != "")
                {
                    // End:0xCB
                    if(GetTargetInfo(targetUserInfo))
                    {
                    }
                    // End:0xEA
                    if(targetUserInfo.nID != targetID)
                    {
                        setTargetByServerID(targetID);
                    }
                    getInstanceContextMenu().execContextEvent(Username, targetID, X, Y);
                }
            }
        }
    }
    return;
}
