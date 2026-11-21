class AutomaticPlay extends UICommonAPI;

const AP_AUTOPLAY_SETTINGS = 1001;
const TIMER_ID_FARM = 1;
const TIMER_DELAY_FARM = 1000;
const TEX_PATH = "UI_BOHPTS.AutoFarm.";
const STR_ON = 227;
const STR_OFF = 228;
const STR_PVP = 453;
const STR_ASSIST = 9071;
const STR_FIXED = 9072;
const STR_MANNER = 9073;
const STR_PICKUP = 9074;
const STR_CHAMPIONS = 9075;
const STR_RANGE = 9076;
const STR_SKILLS = 9077;
const STR_PURCHASE = 9078;

struct _AutoplayData
{
    var int bEnabled;
    var int bCombatMode;
    var int bPickup;
    var int bMannerMode;
    var int bNextTargetMode;
};

var _AutoplayData AutoPlayData;
var Rect rectWndLDowned;
var WindowHandle Me;
var WindowHandle AutomaticPlayWnd;
var AnimTextureHandle AutoTargetAllON_ToggleEffect_Anim;
var ButtonHandle TargetPickupToggle_BTN;
var ButtonHandle TargetMannerToggle_BTN;
var ButtonHandle Combat_BTN;
var WindowHandle AutoTargetAllON_Win;
var WindowHandle AutoTargetAllOFF_Win;
var ButtonHandle AutoTargetAll_BTN;
var ButtonHandle WinMinBTN;
var bool autotarget_bShortTarget;
var bool autotarget_bIsPickupOn;
var bool autotarget_bIsMannerModeOn;
var bool bButtonDrag;
var int OffsetX;
var int OffsetY;
var TextureHandle AutoAllIcon_On;
var TextureHandle AutoAllIcon_Off;
var TextureHandle OrbitArcOff;
var TextureHandle OrbitArcOn;
var TextureHandle TimerPlateOff;
var TextureHandle TimerPlateOn;
var TextBoxHandle TimerText;
var ButtonHandle ZoneBtn;
var ButtonHandle SkillsBtn;
var ButtonHandle PurchaseBtn;
var ButtonHandle FixedBtn;
var ButtonHandle PartyAssistBtn;
var ButtonHandle RaidsBtn;
var array<ButtonHandle> RingButtons;
var bool bZoneOpened;
var bool bFixedOn;
var bool bAssistOn;
var bool bRaidsOn;
var int FarmTimeLeft;
var int FarmElapsed;
var int FarmRange;
var int FarmRangeMin;
var int FarmRangeMax;
var bool bFarmInfoReceived;
var FarmRangeRing RangeRing;
var bool bRangePreview;
var int ShownRange;
var bool bKeepPointKnown;
var Vector KeepPoint;
var bool bRingEnabled;
var int RingRange;

function OnRegisterEvent()
{
    RegisterEvent(150);
    RegisterEvent(9750);
    RegisterEvent(3550);
    RegisterEvent(40);
    RegisterEvent(160);
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function Initialize()
{
    local int nRingOff;

    Me = GetWindowHandle("AutomaticPlay");
    AutomaticPlayWnd = GetWindowHandle("AutomaticPlay.AutomaticPlayWnd");
    AutoTargetAllON_ToggleEffect_Anim = GetAnimTextureHandle("AutomaticPlay.AutomaticPlayWnd.AutoTargetAllON_Win.ToggleEffect_Anim");
    AutoTargetAllON_Win = GetWindowHandle("AutomaticPlay.AutomaticPlayWnd.AutoTargetAllON_Win");
    TargetPickupToggle_BTN = GetButtonHandle("AutomaticPlay.AutomaticPlayWnd.TargetPickupToggle_BTN");
    TargetMannerToggle_BTN = GetButtonHandle("AutomaticPlay.AutomaticPlayWnd.TargetMannerToggle_BTN");
    AutoTargetAllOFF_Win = GetWindowHandle("AutomaticPlay.AutomaticPlayWnd.AutoTargetAllOFF_Win");
    AutoTargetAll_BTN = GetButtonHandle("AutomaticPlay.AutomaticPlayWnd.AutoTargetAll_BTN");
    Combat_BTN = GetButtonHandle("AutomaticPlay.AutomaticPlayWnd.Combat_BTN");
    WinMinBTN = GetButtonHandle("AutomaticPlay.AutomaticPlayWnd.WinMinBTN");
    AutoAllIcon_On = GetTextureHandle("AutomaticPlay.AutomaticPlayWnd.AutoTargetAllON_Win.AutoAllIcon_On_texture");
    AutoAllIcon_Off = GetTextureHandle("AutomaticPlay.AutomaticPlayWnd.AutoTargetAllOFF_Win.AutoAllIcon_Off_texture");
    OrbitArcOff = GetTextureHandle("AutomaticPlay.AutomaticPlayWnd.OrbitArcOff");
    OrbitArcOn = GetTextureHandle("AutomaticPlay.AutomaticPlayWnd.OrbitArcOn");
    TimerPlateOff = GetTextureHandle("AutomaticPlay.AutomaticPlayWnd.TimerPlateOff");
    TimerPlateOn = GetTextureHandle("AutomaticPlay.AutomaticPlayWnd.TimerPlateOn");
    TimerText = GetTextBoxHandle("AutomaticPlay.AutomaticPlayWnd.TimerText");
    ZoneBtn = GetButtonHandle("AutomaticPlay.AutomaticPlayWnd.ZoneBtn");
    SkillsBtn = GetButtonHandle("AutomaticPlay.AutomaticPlayWnd.SkillsBtn");
    PurchaseBtn = GetButtonHandle("AutomaticPlay.AutomaticPlayWnd.PurchaseBtn");
    FixedBtn = GetButtonHandle("AutomaticPlay.AutomaticPlayWnd.FixedBtn");
    PartyAssistBtn = GetButtonHandle("AutomaticPlay.AutomaticPlayWnd.PartyAssistBtn");
    RaidsBtn = GetButtonHandle("AutomaticPlay.AutomaticPlayWnd.RaidsBtn");
    RingButtons[RingButtons.Length] = Combat_BTN;
    RingButtons[RingButtons.Length] = TargetPickupToggle_BTN;
    RingButtons[RingButtons.Length] = TargetMannerToggle_BTN;
    RingButtons[RingButtons.Length] = FixedBtn;
    RingButtons[RingButtons.Length] = PartyAssistBtn;
    RingButtons[RingButtons.Length] = RaidsBtn;
    RingButtons[RingButtons.Length] = ZoneBtn;
    RingButtons[RingButtons.Length] = SkillsBtn;
    RingButtons[RingButtons.Length] = PurchaseBtn;
    SetButtonTooltip(SkillsBtn, GetSystemString(9077));
    SetButtonTooltip(PurchaseBtn, GetSystemString(9078));
    SetButtonTooltip(WinMinBTN, GetSystemString(3960));
    SetRangeTooltip();
    GetINIBool("AutomaticPlay", "ringOff", nRingOff, "windowsInfo.ini");
    bRingEnabled = nRingOff == 0;
    updateElements(9, 0, 0, 0, 0);
    UpdateModeButtons();
    UpdateTimeState();
    UpdateTimerText();
    return;
}

function AutoPlayRangeWnd GetRangeWnd()
{
    return AutoPlayRangeWnd(GetScript("AutoPlayRangeWnd"));
    return;
}

function OnShow()
{
    OptionIniLoad();
    return;
}

function OnHide()
{
    GetRangeWnd().HideRange();
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x4C
        case 150:
            // End:0x3A
            if(GetOptionBool("SideBar", "Autoplay"))
            {
                Me.ShowWindow();                
            }
            else
            {
                Me.HideWindow();
            }
            // End:0x7B
            break;
        // End:0x62
        case 3550:
            _OnEvent(param);
            // End:0x7B
            break;
        // End:0x67
        case 40:
        // End:0x75
        case 160:
            ForgetRangeRing();
            // End:0x7B
            break;
        // End:0xFFFF
        default:
            // End:0x7B
            break;
            break;
    }
    return;
}

function _OnEvent(string _param)
{
    local int EventID;

    ParseInt(_param, "EventID", EventID);
    // End:0x33
    if(EventID == 1001)
    {
        requestAutoPlaySettings(_param);
    }
    return;
}

function requestAutoPlaySettings(string params)
{
    local string FarmInfo, Modes;
    local int WasEnabled;

    WasEnabled = AutoPlayData.bEnabled;
    ParseInt(params, "ask", AutoPlayData.bEnabled);
    ParseInt(params, "reply", AutoPlayData.bCombatMode);
    ParseInt(params, "Param1", AutoPlayData.bPickup);
    ParseInt(params, "Param2", AutoPlayData.bNextTargetMode);
    ParseInt(params, "Param3", AutoPlayData.bMannerMode);
    // End:0xC3
    if(ParseString(params, "Param3", Modes))
    {
        ApplyModes(Modes);
    }
    // End:0xF7
    if((ParseString(params, "Param5", FarmInfo)) && FarmInfo != "")
    {
        ApplyFarmInfo(FarmInfo);
    }
    // End:0x112
    if(AutoPlayData.bEnabled != WasEnabled)
    {
        FarmElapsed = 0;
    }
    // End:0x137
    if((WasEnabled == 1) && AutoPlayData.bEnabled == 0)
    {
        bRangePreview = false;
    }
    updateElements(AutoPlayData.bEnabled, AutoPlayData.bCombatMode, AutoPlayData.bPickup, AutoPlayData.bNextTargetMode, AutoPlayData.bMannerMode);
    UpdateFarmTimer();
    UpdateRangeRing();
    SetOptionBool("SideBar", "AutoplayEnabled", bool(AutoPlayData.bEnabled));
    EssenceMainDesc(GetScript("EssenceMainDesc")).CheckByType(3);
    return;
}

function ApplyModes(string Modes)
{
    local array<string> Parts;

    Split(Modes, ",", Parts);
    // End:0x32
    if(Parts.Length > 1)
    {
        bRaidsOn = Parts[1] == "1";
    }
    // End:0x67
    if(Parts.Length > 3)
    {
        bAssistOn = Parts[2] == "1";
        bFixedOn = Parts[3] == "1";
    }
    UpdateModeButtons();
    return;
}

function ApplyFarmInfo(string FarmInfo)
{
    local array<string> Parts;

    Split(FarmInfo, ",", Parts);
    // End:0x22
    if(Parts.Length < 4)
    {
        return;
    }
    FarmTimeLeft = int(Parts[0]);
    FarmRange = int(Parts[1]);
    FarmRangeMin = int(Parts[2]);
    FarmRangeMax = int(Parts[3]);
    bKeepPointKnown = Parts.Length >= 7;
    // End:0xB9
    if(bKeepPointKnown)
    {
        KeepPoint.X = float(Parts[4]);
        KeepPoint.Y = float(Parts[5]);
        KeepPoint.Z = float(Parts[6]);
    }
    // End:0xCF
    if(!bRangePreview)
    {
        ShownRange = FarmRange;
    }
    bFarmInfoReceived = true;
    GetRangeWnd().SetRangeInfo(FarmRange, FarmRangeMin, FarmRangeMax);
    SetRangeTooltip();
    UpdateTimeState();
    return;
}

function UpdateFarmTimer()
{
    Me.KillTimer(1);
    // End:0x42
    if((AutoPlayData.bEnabled == 1) && FarmTimeLeft != 0)
    {
        Me.SetTimer(1, 1000);
    }
    UpdateTimerText();
    return;
}

event OnTimer(int TimerID)
{
    // End:0x0D
    if(TimerID != 1)
    {
        return;
    }
    // End:0x29
    if(FarmTimeLeft < 0)
    {
        FarmElapsed = FarmElapsed + 1;        
    }
    else
    {
        // End:0x42
        if(FarmTimeLeft > 0)
        {
            FarmTimeLeft = FarmTimeLeft - 1;
        }
    }
    // End:0x63
    if(FarmTimeLeft == 0)
    {
        Me.KillTimer(1);
        UpdateTimeState();
    }
    UpdateTimerText();
    return;
}

function UpdateTimerText()
{
    // End:0x28
    if(FarmTimeLeft < 0)
    {
        TimerText.SetText(FormatFarmTime(FarmElapsed));        
    }
    else
    {
        TimerText.SetText(FormatFarmTime(FarmTimeLeft));
    }
    return;
}

function UpdateTimeState()
{
    // End:0xC6
    if(FarmTimeLeft != 0)
    {
        TimerPlateOn.ShowWindow();
        TimerPlateOff.HideWindow();
        TimerText.SetTextColor(GetColor(243, 228, 192, 255));
        PurchaseBtn.SetTexture("UI_BOHPTS.AutoFarm." $ "PurchaseOn", "UI_BOHPTS.AutoFarm." $ "PurchaseOn", "UI_BOHPTS.AutoFarm." $ "PurchaseOn_Over");        
    }
    else
    {
        TimerPlateOff.ShowWindow();
        TimerPlateOn.HideWindow();
        TimerText.SetTextColor(GetColor(142, 138, 128, 255));
        PurchaseBtn.SetTexture("UI_BOHPTS.AutoFarm." $ "PurchaseOff", "UI_BOHPTS.AutoFarm." $ "PurchaseOff", "UI_BOHPTS.AutoFarm." $ "PurchaseOff_Over");
    }
    return;
}

function string FormatFarmTime(int Sec)
{
    return ((((TwoDigits(Sec / 3600)) $ ":") $ (TwoDigits(int(float(Sec) % float(3600)) / 60))) $ ":") $ (TwoDigits(int(float(Sec) % float(60))));
    return;
}

function string TwoDigits(int Value)
{
    // End:0x19
    if(Value < 10)
    {
        return "0" $ string(Value);
    }
    return string(Value);
    return;
}

function SetEnabled(int Value)
{
    // End:0x38
    if(Value == 1)
    {
        AnimTexturePlay(AutoTargetAllON_ToggleEffect_Anim, true);
        AutoTargetAllON_Win.ShowWindow();
        AutoTargetAllOFF_Win.HideWindow();        
    }
    else
    {
        AnimTextureStop(AutoTargetAllON_ToggleEffect_Anim, true);
        AutoTargetAllON_Win.HideWindow();
        AutoTargetAllOFF_Win.ShowWindow();
    }
    UpdateOrbit();
    SetStateTooltip(AutoTargetAll_BTN, 7665, 7666, Value == 1);
    return;
}

function UpdateOrbit()
{
    // End:0x35
    if(WinMinBTN.GetButtonValue() == 1)
    {
        OrbitArcOff.HideWindow();
        OrbitArcOn.HideWindow();
        return;
    }
    // End:0x66
    if(AutoPlayData.bEnabled == 1)
    {
        OrbitArcOn.ShowWindow();
        OrbitArcOff.HideWindow();        
    }
    else
    {
        OrbitArcOff.ShowWindow();
        OrbitArcOn.HideWindow();
    }
    return;
}

function SetLogoHover(bool bHover)
{
    // End:0x73
    if(bHover)
    {
        AutoAllIcon_On.SetTexture("UI_BOHPTS.AutoFarm." $ "LogoOn_Over");
        AutoAllIcon_Off.SetTexture("UI_BOHPTS.AutoFarm." $ "LogoOff_Over");        
    }
    else
    {
        AutoAllIcon_On.SetTexture("UI_BOHPTS.AutoFarm." $ "LogoOn");
        AutoAllIcon_Off.SetTexture("UI_BOHPTS.AutoFarm." $ "LogoOff");
    }
    return;
}

function SetCombat(int Value)
{
    // End:0x9C
    if(Value == 1)
    {
        Combat_BTN.SetTexture("UI_BOHPTS.AutoFarm." $ "CombatBTNON_Normal", "UI_BOHPTS.AutoFarm." $ "CombatBTNON_Normal", "UI_BOHPTS.AutoFarm." $ "CombatBTNON_Over");        
    }
    else
    {
        Combat_BTN.SetTexture("UI_BOHPTS.AutoFarm." $ "CombatBTNOff_Normal", "UI_BOHPTS.AutoFarm." $ "CombatBTNOff_Normal", "UI_BOHPTS.AutoFarm." $ "CombatBTNOff_Over");
    }
    setCombatTooltip();
    return;
}

function SetPickup(int Value)
{
    // End:0x93
    if(Value == 1)
    {
        TargetPickupToggle_BTN.SetTexture("UI_BOHPTS.AutoFarm." $ "GetBTNON_Normal", "UI_BOHPTS.AutoFarm." $ "GetBTNON_Normal", "UI_BOHPTS.AutoFarm." $ "GetBTNON_Over");        
    }
    else
    {
        TargetPickupToggle_BTN.SetTexture("UI_BOHPTS.AutoFarm." $ "GetBTNOff_Normal", "UI_BOHPTS.AutoFarm." $ "GetBTNOff_Normal", "UI_BOHPTS.AutoFarm." $ "GetBTNOff_Over");
    }
    Autotarget_PickupSetCusomTooltip();
    return;
}

function SetManner(int Value)
{
    // End:0x9C
    if(Value == 1)
    {
        TargetMannerToggle_BTN.SetTexture("UI_BOHPTS.AutoFarm." $ "MannerBTNON_Normal", "UI_BOHPTS.AutoFarm." $ "MannerBTNON_Normal", "UI_BOHPTS.AutoFarm." $ "MannerBTNON_Over");        
    }
    else
    {
        TargetMannerToggle_BTN.SetTexture("UI_BOHPTS.AutoFarm." $ "MannerBTNOff_Normal", "UI_BOHPTS.AutoFarm." $ "MannerBTNOff_Normal", "UI_BOHPTS.AutoFarm." $ "MannerBTNOff_Over");
    }
    Autotarget_MannerModeSetCusomTooltip();
    return;
}

function updateElements(int _bEnabled, int bCombatMode, int bPickup, int bNextTargetMode, int bMannerMode)
{
    SetEnabled(_bEnabled);
    SetCombat(bCombatMode);
    SetPickup(bPickup);
    SetManner(bMannerMode);
    return;
}

function UpdateModeButtons()
{
    SetToggleTexture(FixedBtn, "FixedBTN_ShotD_NormalOFF", "FixedBTN_ShotD_OverOFF", "FixedBTN_ShotD_NormalON", "FixedBTN_ShotD_OverON", bFixedOn);
    SetToggleTexture(PartyAssistBtn, "AssistOff", "AssistOff_Over", "AssistOn", "AssistOn_Over", bAssistOn);
    SetToggleTexture(RaidsBtn, "RaidsBTN_ShotD_NormalOFF", "RaidsBTN_ShotD_OverOFF", "RaidsBTN_ShotD_NormalON", "RaidsBTN_ShotD_OverON", bRaidsOn);
    SetToggleTexture(ZoneBtn, "ZoneBTN_ShotD_NormalOFF", "ZoneBTN_ShotD_OverOFF", "ZoneBTN_ShotD_NormalON", "ZoneBTN_ShotD_OverON", bZoneOpened);
    SetToggleTooltip(FixedBtn, 9072, bFixedOn, getInstanceL2Util().Yellow, getInstanceL2Util().Gray);
    SetToggleTooltip(PartyAssistBtn, 9071, bAssistOn, getInstanceL2Util().Yellow, getInstanceL2Util().Gray);
    SetToggleTooltip(RaidsBtn, 9075, bRaidsOn, getInstanceL2Util().Yellow, getInstanceL2Util().Gray);
    return;
}

function SetToggleTexture(ButtonHandle Btn, string OffNormal, string OffOver, string OnNormal, string OnOver, bool bOn)
{
    // End:0x6F
    if(bOn)
    {
        Btn.SetTexture("UI_BOHPTS.AutoFarm." $ OnNormal, "UI_BOHPTS.AutoFarm." $ OnNormal, "UI_BOHPTS.AutoFarm." $ OnOver);        
    }
    else
    {
        Btn.SetTexture("UI_BOHPTS.AutoFarm." $ OffNormal, "UI_BOHPTS.AutoFarm." $ OffNormal, "UI_BOHPTS.AutoFarm." $ OffOver);
    }
    return;
}

function SetZoneOpened(bool bOpened)
{
    bZoneOpened = bOpened;
    UpdateModeButtons();
    // End:0x26
    if(!bOpened)
    {
        bRangePreview = false;
    }
    UpdateRangeRing();
    return;
}

function StopRangePreview()
{
    bRangePreview = false;
    UpdateRangeRing();
    return;
}

function bool IsRingEnabled()
{
    return bRingEnabled;
    return;
}

function SetRingEnabled(bool bOn)
{
    bRingEnabled = bOn;
    SetINIBool("AutomaticPlay", "ringOff", !bOn, "windowsInfo.ini");
    UpdateRangeRing();
    return;
}

function PreviewRange(int Range)
{
    ShownRange = Range;
    bRangePreview = true;
    UpdateRangeRing();
    return;
}

function UpdateRangeRing()
{
    local PlayerController pc;
    local bool bFixed;
    local Vector Center;

    pc = GetLocalController();
    // End:0x86
    if((RangeRing != none) && RangeRing.bDeleteMe || (pc != none) && RangeRing.XLevel != pc.XLevel)
    {
        // End:0x7F
        if(!RangeRing.bDeleteMe)
        {
            RangeRing.SetShown(false);
        }
        RangeRing = none;
    }
    // End:0xC5
    if((!bRingEnabled || ShownRange <= 0) || !(AutoPlayData.bEnabled == 1) || bRangePreview)
    {
        HideRangeRing();
        return;
    }
    // End:0xD2
    if(pc == none)
    {
        return;
    }
    bFixed = bFixedOn && bKeepPointKnown;
    // End:0x124
    if(bFixed)
    {
        Center = KeepPoint;
        Center.Z += pc.Pawn.CollisionHeight;        
    }
    else
    {
        Center = pc.Pawn.Location;
    }
    // End:0x1B7
    if(RangeRing == none)
    {
        Class'Interface.FarmRangeRing'.static.SetSpawnRange(float(ShownRange));
        RangeRing = pc.__NFUN_278__(Class'Interface.FarmRangeRing',,, Class'Interface.FarmRangeRing'.static.RingLocation(Center, float(ShownRange)));
        // End:0x1A3
        if(RangeRing == none)
        {
            return;
        }
        RingRange = ShownRange;
        StopStaleRings();        
    }
    else
    {
        // End:0x1E7
        if(RingRange != ShownRange)
        {
            RangeRing.SetRange(float(ShownRange));
            RingRange = ShownRange;
        }
    }
    // End:0x207
    if(bFixed)
    {
        RangeRing.PlaceAt(Center);        
    }
    else
    {
        RangeRing.FollowPlayer(pc);
    }
    RangeRing.SetShown(true);
    return;
}

function HideRangeRing()
{
    // End:0x31
    if((RangeRing != none) && !RangeRing.bDeleteMe)
    {
        RangeRing.SetShown(false);
    }
    return;
}

function ForgetRangeRing()
{
    HideRangeRing();
    RangeRing = none;
    RingRange = 0;
    return;
}

function StopStaleRings()
{
    local int i;
    local PlayerController pc;
    local FarmRangeRing R;
    local ParticleProjector P;
    local ProjectedEmitter E;

    // End:0x0D
    if(RangeRing == none)
    {
        return;
    }
    i = 0;
    J0x14:

    // End:0x17B [Loop If]
    if(i < 8)
    {
        pc = Class'NWindow.WorldAPI'.static.GetPlayerController(i);
        // End:0x48
        if(pc == none)
        {
            // [Explicit Break]
            goto J0x17B;
        }
        // End:0x73
        if(pc.bDeleteMe || pc.XLevel == none)
        {
            // [Explicit Continue]
            goto J0x171;
        }
        // End:0xD6
        foreach pc.DynamicActors(Class'Interface.FarmRangeRing', R)
        {
            // End:0xD5
            if(((R != RangeRing) && !R.bDeleteMe) && R.bShown)
            {
                R.SetShown(false);
            }            
        }        
        // End:0x170
        foreach pc.DynamicActors(Class'Engine.ParticleProjector', P)
        {
            E = P.ProjectedEmitter;
            // End:0x16F
            if((((E != none) && E.bDeleteMe) && E.__NFUN_303__('FarmRangeRing')) && P.ProjTexture != none)
            {
                P.ProjTexture = none;
                P.DetachProjector(true);
            }            
        }        
        J0x171:

        i++;
        // [Loop Continue]
        goto J0x14;
    }
    J0x17B:

    return;
}

function PlayerController GetLocalController()
{
    local int i;
    local PlayerController pc, Found;
    local Vector mYPos;
    local float dist, bestDist;

    mYPos = GetPlayerPosition();
    // End:0x10C
    if(VSize(mYPos) > 1.0000000)
    {
        i = 0;
        J0x24:

        // End:0xFB [Loop If]
        if(i < 8)
        {
            pc = Class'NWindow.WorldAPI'.static.GetPlayerController(i);
            // End:0x58
            if(pc == none)
            {
                // [Explicit Break]
                goto J0xFB;
            }
            // End:0x99
            if((pc.bDeleteMe || pc.XLevel == none) || pc.Pawn == none)
            {
                // [Explicit Continue]
                goto J0xF1;
            }
            dist = VSize(pc.Pawn.Location - mYPos);
            // End:0xF1
            if((Found == none) || dist < bestDist)
            {
                Found = pc;
                bestDist = dist;
            }
            J0xF1:

            i++;
            // [Loop Continue]
            goto J0x24;
        }
        J0xFB:

        // End:0x10C
        if(Found != none)
        {
            return Found;
        }
    }
    i = 0;
    J0x113:

    // End:0x1C2 [Loop If]
    if(i < 8)
    {
        pc = Class'NWindow.WorldAPI'.static.GetPlayerController(i);
        // End:0x147
        if(pc == none)
        {
            // [Explicit Break]
            goto J0x1C2;
        }
        // End:0x188
        if((pc.bDeleteMe || pc.XLevel == none) || pc.Pawn == none)
        {
            // [Explicit Continue]
            goto J0x1B8;
        }
        // End:0x1A2
        if(pc.Player != none)
        {
            return pc;
        }
        // End:0x1B8
        if(Found == none)
        {
            Found = pc;
        }
        J0x1B8:

        i++;
        // [Loop Continue]
        goto J0x113;
    }
    J0x1C2:

    return Found;
    return;
}

function OnClickButton(string Name)
{
    // End:0x0B
    if(CheckDrag())
    {
        return;
    }
    switch(Name)
    {
        // End:0x31
        case "ZoneBtn":
            GetRangeWnd().ToggleRange();
            // End:0x3BE
            break;
        // End:0xC0
        case "TargetPickupToggle_BTN":
            AutoPlayData.bPickup = _invert(AutoPlayData.bPickup);
            ShowToggleMessage(9074, AutoPlayData.bPickup == 1);
            updateElements(AutoPlayData.bEnabled, AutoPlayData.bCombatMode, AutoPlayData.bPickup, AutoPlayData.bNextTargetMode, AutoPlayData.bMannerMode);
            RQ_AUTOPLAY_BYPASS();
            // End:0x3BE
            break;
        // End:0x14F
        case "TargetMannerToggle_BTN":
            AutoPlayData.bMannerMode = _invert(AutoPlayData.bMannerMode);
            ShowToggleMessage(9073, AutoPlayData.bMannerMode == 1);
            updateElements(AutoPlayData.bEnabled, AutoPlayData.bCombatMode, AutoPlayData.bPickup, AutoPlayData.bNextTargetMode, AutoPlayData.bMannerMode);
            RQ_AUTOPLAY_BYPASS();
            // End:0x3BE
            break;
        // End:0x220
        case "AutoTargetAll_BTN":
            AutoPlayData.bEnabled = _invert(AutoPlayData.bEnabled);
            // End:0x1AE
            if(AutoPlayData.bEnabled == 1)
            {
                getInstanceL2Util().showGfxScreenMessage(GetSystemString(7665));                
            }
            else
            {
                getInstanceL2Util().showGfxScreenMessage(GetSystemString(7666));
            }
            updateElements(AutoPlayData.bEnabled, AutoPlayData.bCombatMode, AutoPlayData.bPickup, AutoPlayData.bNextTargetMode, AutoPlayData.bMannerMode);
            RQ_AUTOPLAY_BYPASS();
            // End:0x21D
            if(AutoPlayData.bEnabled == 0)
            {
                StopRangePreview();
            }
            // End:0x3BE
            break;
        // End:0x2A3
        case "Combat_BTN":
            AutoPlayData.bCombatMode = _invert(AutoPlayData.bCombatMode);
            ShowToggleMessage(453, AutoPlayData.bCombatMode == 1);
            updateElements(AutoPlayData.bEnabled, AutoPlayData.bCombatMode, AutoPlayData.bPickup, AutoPlayData.bNextTargetMode, AutoPlayData.bMannerMode);
            RQ_AUTOPLAY_BYPASS();
            // End:0x3BE
            break;
        // End:0x2BA
        case "WinMinBTN":
            WinMinMax();
            // End:0x3BE
            break;
        // End:0x2DD
        case "SkillsBtn":
            RequestBypassToServer("apsettings");
            // End:0x3BE
            break;
        // End:0x2FE
        case "PurchaseBtn":
            RequestBypassToServer("aptime");
            // End:0x3BE
            break;
        // End:0x33A
        case "FixedBtn":
            bFixedOn = !bFixedOn;
            ShowToggleMessage(9072, bFixedOn);
            UpdateModeButtons();
            RQ_AUTOPLAY_BYPASS();
            // End:0x3BE
            break;
        // End:0x37C
        case "PartyAssistBtn":
            bAssistOn = !bAssistOn;
            ShowToggleMessage(9071, bAssistOn);
            UpdateModeButtons();
            RQ_AUTOPLAY_BYPASS();
            // End:0x3BE
            break;
        // End:0x3B8
        case "RaidsBtn":
            bRaidsOn = !bRaidsOn;
            ShowToggleMessage(9075, bRaidsOn);
            UpdateModeButtons();
            RQ_AUTOPLAY_BYPASS();
            // End:0x3BE
            break;
        // End:0xFFFF
        default:
            // End:0x3BE
            break;
            break;
    }
    return;
}

function int _invert(int i)
{
    return i ^ 1;
    return;
}

function string GetAutoplayValue()
{
    return ((((((((string(AutoPlayData.bEnabled) $ " ") $ string(AutoPlayData.bCombatMode)) $ " ") $ string(AutoPlayData.bPickup)) $ " ") $ string(AutoPlayData.bNextTargetMode)) $ " ") $ string(AutoPlayData.bMannerMode)) $ (GetModesValue());
    return;
}

function string GetModesValue()
{
    return ((((" " $ string(boolToNum(bRaidsOn))) $ " ") $ string(boolToNum(bAssistOn))) $ " ") $ string(boolToNum(bFixedOn));
    return;
}

function RQ_AUTOPLAY_BYPASS()
{
    RequestBypassToServer("ap " $ (GetAutoplayValue()));
    return;
}

function WinMinMax()
{
    // End:0x1E
    if(WinMinBTN.GetButtonValue() == 0)
    {
        SetMin();        
    }
    else
    {
        SetMax();
    }
    return;
}

function SetMin()
{
    local int i;

    SetINIBool("AutomaticPlay", "min", true, "windowsInfo.ini");
    WinMinBTN.SetButtonValue(1);
    WinMinBTN.SetTexture("UI_BOHPTS.AutoFarm." $ "WinExpandButton_Normal", "UI_BOHPTS.AutoFarm." $ "WinExpandButton_Down", "UI_BOHPTS.AutoFarm." $ "WinExpandButton_Over");
    SetButtonTooltip(WinMinBTN, GetSystemString(3965));
    i = 0;
    J0xF1:

    // End:0x120 [Loop If]
    if(i < RingButtons.Length)
    {
        RingButtons[i].HideWindow();
        i++;
        // [Loop Continue]
        goto J0xF1;
    }
    UpdateOrbit();
    GetRangeWnd().HideRange();
    return;
}

function SetMax()
{
    local int i;

    SetINIBool("AutomaticPlay", "min", false, "windowsInfo.ini");
    WinMinBTN.SetButtonValue(0);
    WinMinBTN.SetTexture("UI_BOHPTS.AutoFarm." $ "WinMinButton_Normal", "UI_BOHPTS.AutoFarm." $ "WinMinButton_Down", "UI_BOHPTS.AutoFarm." $ "WinMinButton_Over");
    SetButtonTooltip(WinMinBTN, GetSystemString(3960));
    i = 0;
    J0xE8:

    // End:0x117 [Loop If]
    if(i < RingButtons.Length)
    {
        RingButtons[i].ShowWindow();
        i++;
        // [Loop Continue]
        goto J0xE8;
    }
    UpdateOrbit();
    return;
}

function OptionIniLoad()
{
    local int nLongTarget, nIsPickupOn, nIsMannerModeOn;

    GetINIBool("AutomaticPlay", "a", nLongTarget, "windowsInfo.ini");
    GetINIBool("AutomaticPlay", "e", nIsPickupOn, "windowsInfo.ini");
    GetINIBool("AutomaticPlay", "p", nIsMannerModeOn, "windowsInfo.ini");
    autotarget_bIsPickupOn = numToBool(nIsPickupOn);
    autotarget_bShortTarget = !numToBool(nLongTarget);
    autotarget_bIsMannerModeOn = numToBool(nIsMannerModeOn);
    return;
}

function SetButtonTooltip(ButtonHandle Btn, string Text)
{
    local array<DrawItemInfo> drawListArr;

    Btn.ClearTooltip();
    Btn.SetTooltipType("text");
    drawListArr[drawListArr.Length] = addDrawItemText(Text, getInstanceL2Util().White, "", true, true);
    Btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
    return;
}

function SetStateTooltip(ButtonHandle Btn, int OnId, int OffId, bool bOn)
{
    local array<DrawItemInfo> drawListArr;
    local Color OnColor, OffColor;

    Btn.ClearTooltip();
    Btn.SetTooltipType("text");
    OnColor = getInstanceL2Util().Gray;
    OffColor = getInstanceL2Util().Gray;
    // End:0x6F
    if(bOn)
    {
        OnColor = getInstanceL2Util().Yellow;        
    }
    else
    {
        OffColor = getInstanceL2Util().Yellow;
    }
    drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(OnId), OnColor, "", true, true);
    drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(OffId), OffColor, "", true, true);
    Btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
    return;
}

function SetToggleTooltip(ButtonHandle Btn, int NameID, bool bOn, Color HiColor, Color LoColor)
{
    local array<DrawItemInfo> drawListArr;
    local Color OnColor, OffColor;
    local string Title;

    Btn.ClearTooltip();
    Btn.SetTooltipType("text");
    Title = GetSystemString(NameID) $ ": ";
    OnColor = LoColor;
    OffColor = LoColor;
    // End:0x68
    if(bOn)
    {
        OnColor = HiColor;        
    }
    else
    {
        OffColor = HiColor;
    }
    drawListArr[drawListArr.Length] = addDrawItemText(Title $ GetSystemString(227), OnColor, "", true, true);
    drawListArr[drawListArr.Length] = addDrawItemText(Title $ GetSystemString(228), OffColor, "", true, true);
    Btn.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
    return;
}

function ShowToggleMessage(int NameID, bool bOn)
{
    // End:0x37
    if(bOn)
    {
        getInstanceL2Util().showGfxScreenMessage((GetSystemString(NameID) $ ": ") $ GetSystemString(227));        
    }
    else
    {
        getInstanceL2Util().showGfxScreenMessage((GetSystemString(NameID) $ ": ") $ GetSystemString(228));
    }
    return;
}

function SetRangeTooltip()
{
    // End:0x31
    if(bFarmInfoReceived)
    {
        SetButtonTooltip(ZoneBtn, (GetSystemString(9076) $ ": ") $ string(FarmRange));        
    }
    else
    {
        SetButtonTooltip(ZoneBtn, GetSystemString(9076));
    }
    return;
}

function setCombatTooltip()
{
    SetToggleTooltip(Combat_BTN, 453, AutoPlayData.bCombatMode > 0, getInstanceL2Util().DRed, getInstanceL2Util().White);
    return;
}

function Autotarget_PickupSetCusomTooltip()
{
    SetToggleTooltip(TargetPickupToggle_BTN, 9074, AutoPlayData.bPickup == 1, getInstanceL2Util().Yellow, getInstanceL2Util().Gray);
    return;
}

function Autotarget_MannerModeSetCusomTooltip()
{
    SetToggleTooltip(TargetMannerToggle_BTN, 9073, AutoPlayData.bMannerMode == 1, getInstanceL2Util().Yellow, getInstanceL2Util().Gray);
    return;
}

event OnMouseOver(WindowHandle a_WindowHandle)
{
    // End:0x16
    if(a_WindowHandle == AutoTargetAll_BTN)
    {
        SetLogoHover(true);
    }
    return;
}

event OnMouseOut(WindowHandle a_WindowHandle)
{
    // End:0x16
    if(a_WindowHandle == AutoTargetAll_BTN)
    {
        SetLogoHover(false);
    }
    return;
}

event OnMouseMove(WindowHandle a_WindowHandle, int X, int Y)
{
    local Rect rectWnd;

    switch(a_WindowHandle)
    {
        // End:0x0F
        case TargetPickupToggle_BTN:
        // End:0x17
        case TargetMannerToggle_BTN:
        // End:0x1F
        case AutoTargetAllOFF_Win:
        // End:0x27
        case AutoTargetAll_BTN:
        // End:0x2F
        case Combat_BTN:
        // End:0x37
        case WinMinBTN:
        // End:0x3F
        case ZoneBtn:
        // End:0x47
        case SkillsBtn:
        // End:0x4F
        case PurchaseBtn:
        // End:0x57
        case FixedBtn:
        // End:0x5F
        case PartyAssistBtn:
        // End:0xAE
        case RaidsBtn:
            // End:0xAB
            if(bButtonDrag)
            {
                Me.SetAnchor("", "TopLeft", "TopLeft", X - OffsetX, Y - OffsetY);
            }
            // End:0xB4
            break;
        // End:0xFFFF
        default:
            // End:0xB4
            break;
            break;
    }
    return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local Rect tmpRect;

    switch(a_WindowHandle)
    {
        // End:0x0F
        case TargetPickupToggle_BTN:
        // End:0x17
        case TargetMannerToggle_BTN:
        // End:0x1F
        case AutoTargetAllOFF_Win:
        // End:0x27
        case AutoTargetAll_BTN:
        // End:0x2F
        case Combat_BTN:
        // End:0x37
        case WinMinBTN:
        // End:0x3F
        case ZoneBtn:
        // End:0x47
        case SkillsBtn:
        // End:0x4F
        case PurchaseBtn:
        // End:0x57
        case FixedBtn:
        // End:0x5F
        case PartyAssistBtn:
        // End:0xB5
        case RaidsBtn:
            bButtonDrag = true;
            rectWndLDowned = Me.GetRect();
            OffsetX = X - rectWndLDowned.nX;
            OffsetY = Y - rectWndLDowned.nY;
            // End:0xBB
            break;
        // End:0xFFFF
        default:
            // End:0xBB
            break;
            break;
    }
    return;
}

event OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
    bButtonDrag = false;
    Me.ClearAnchor();
    return;
}

function bool CheckDrag()
{
    local Rect rectWnd;

    rectWnd = Me.GetRect();
    return ((GetAbs(rectWndLDowned.nX - rectWnd.nX)) > 5) || (GetAbs(rectWndLDowned.nY - rectWnd.nY)) > 5;
    return;
}
