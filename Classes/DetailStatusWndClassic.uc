class DetailStatusWndClassic extends UICommonAPI;

const DIALOG_DetailStatusWnd = 90005;
const NSTATUS_SMALLBARSIZE = 85;
const NSTATUS_BARHEIGHT = 12;

struct SubjobInfo
{
    var int Id;
    var int ClassID;
    var int Level;
    var int Type;
};

var string m_WindowName;
var int m_UserID;
var HennaInfo m_HennaInfo;
var WindowHandle Me;
var TextBoxHandle txtClassName;
var TextBoxHandle txtSP;
var TextBoxHandle txtName1;
var TextBoxHandle txtName2;
var TextBoxHandle txtHeadPledge;
var TextBoxHandle txtPledge;
var TextBoxHandle txtLvHead;
var TextBoxHandle txtLvName;
var TextBoxHandle txtHeadRank;
var TextBoxHandle txtRank;
var StatusBarHandle texHP;
var StatusBarHandle texMP;
var StatusBarHandle texExp;
var StatusBarHandle texCP;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtGmMoving;
var TextBoxHandle txtHeadMovingSpeed;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtHeadMagicCastingSpeed;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSTR;
var TextBoxHandle txtDEX;
var TextBoxHandle txtCON;
var TextBoxHandle txtINT;
var TextBoxHandle txtWIT;
var TextBoxHandle txtMEN;
var TextBoxHandle txtCriminalRate;
var TextBoxHandle txtSociality;
var TextBoxHandle txtRemainSulffrage;
var TextBoxHandle txtRaidPoint;
var TextureHandle texPledgeCrest;
var TextureHandle VitalityTex;
var int MaxVitality;
var int nCanUseAP;
var L2Util util;
var TextBoxHandle txtHeadSTR;
var TextBoxHandle txtHeadDEX;
var TextBoxHandle txtHeadCON;
var TextBoxHandle txtHeadINT;
var TextBoxHandle txtHeadWIT;
var TextBoxHandle txtHeadMEN;
var AnimTextureHandle ClassChangeLightBig;
var TextureHandle ClassBgMain_Big;
var TextureHandle ClassMarkBig;
var array<SubjobInfo> subjobInfoArray;
var SubjobInfo beforeSubjobInfo;
var int currentSubjobClassNum;
var bool isDualClass;
var int Race;

function OnRegisterEvent()
{
    RegisterEvent(180);
    RegisterEvent(260);
    RegisterEvent(191);
    RegisterEvent(201);
    RegisterEvent(211);
    RegisterEvent(221);
    RegisterEvent(231);
    RegisterEvent(241);
    RegisterEvent(4100);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(5310);
    RegisterEvent(5311);
    RegisterEvent(5312);
    RegisterEvent(4110);
    RegisterEvent(3400);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    InitializeCOD();
    Me.EnableWindow();
    MaxVitality = GetMaxVitality();
    nCanUseAP = 0;
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("DetailStatusWndClassic");
    ClassMarkBig = GetTextureHandle(m_WindowName $ ".ClassMarkBig");
    txtClassName = GetTextBoxHandle(m_WindowName $ ".txtClassName");
    txtSP = GetTextBoxHandle(m_WindowName $ ".txtSP");
    txtName1 = GetTextBoxHandle(m_WindowName $ ".txtName1");
    txtName2 = GetTextBoxHandle(m_WindowName $ ".txtName2");
    txtHeadPledge = GetTextBoxHandle(m_WindowName $ ".txtHeadPledge");
    txtPledge = GetTextBoxHandle(m_WindowName $ ".txtPledge");
    txtLvHead = GetTextBoxHandle(m_WindowName $ ".txtLvHead");
    txtLvName = GetTextBoxHandle(m_WindowName $ ".txtLvName");
    txtHeadRank = GetTextBoxHandle(m_WindowName $ ".txtHeadRank");
    txtRank = GetTextBoxHandle(m_WindowName $ ".txtRank");
    texHP = GetStatusBarHandle(m_WindowName $ ".texHP");
    texMP = GetStatusBarHandle(m_WindowName $ ".texMP");
    texExp = GetStatusBarHandle(m_WindowName $ ".texExp");
    texCP = GetStatusBarHandle(m_WindowName $ ".texCP");
    txtPhysicalAttack = GetTextBoxHandle(m_WindowName $ ".txtPhysicalAttack");
    txtPhysicalDefense = GetTextBoxHandle(m_WindowName $ ".txtPhysicalDefense");
    txtHitRate = GetTextBoxHandle(m_WindowName $ ".txtHitRate");
    txtCriticalRate = GetTextBoxHandle(m_WindowName $ ".txtCriticalRate");
    txtPhysicalAttackSpeed = GetTextBoxHandle(m_WindowName $ ".txtPhysicalAttackSpeed");
    txtMagicalAttack = GetTextBoxHandle(m_WindowName $ ".txtMagicalAttack");
    txtMagicDefense = GetTextBoxHandle(m_WindowName $ ".txtMagicDefense");
    txtPhysicalAvoid = GetTextBoxHandle(m_WindowName $ ".txtPhysicalAvoid");
    txtGmMoving = GetTextBoxHandle(m_WindowName $ ".txtGmMoving");
    txtMovingSpeed = GetTextBoxHandle(m_WindowName $ ".txtMovingSpeed");
    txtMagicCastingSpeed = GetTextBoxHandle(m_WindowName $ ".txtMagicCastingSpeed");
    txtHeadMovingSpeed = GetTextBoxHandle(m_WindowName $ ".txtHeadMovingSpeed");
    txtHeadMagicCastingSpeed = GetTextBoxHandle(m_WindowName $ ".txtHeadMagicCastingSpeed");
    txtSTR = GetTextBoxHandle(m_WindowName $ ".txtSTR");
    txtDEX = GetTextBoxHandle(m_WindowName $ ".txtDEX");
    txtCON = GetTextBoxHandle(m_WindowName $ ".txtCON");
    txtINT = GetTextBoxHandle(m_WindowName $ ".txtINT");
    txtWIT = GetTextBoxHandle(m_WindowName $ ".txtWIT");
    txtMEN = GetTextBoxHandle(m_WindowName $ ".txtMEN");
    txtCriminalRate = GetTextBoxHandle(m_WindowName $ ".txtCriminalRate");
    txtSociality = GetTextBoxHandle(m_WindowName $ ".txtSociality");
    txtRemainSulffrage = GetTextBoxHandle(m_WindowName $ ".txtRemainSulffrage");
    txtRaidPoint = GetTextBoxHandle(m_WindowName $ ".txtRaidPoint");
    texPledgeCrest = GetTextureHandle(m_WindowName $ ".texPledgeCrest");
    VitalityTex = GetTextureHandle(m_WindowName $ ".LifeForceTex");
    isDualClass = false;
    txtHeadSTR = GetTextBoxHandle(m_WindowName $ ".txtHeadSTR");
    txtHeadDEX = GetTextBoxHandle(m_WindowName $ ".txtHeadDEX");
    txtHeadCON = GetTextBoxHandle(m_WindowName $ ".txtHeadCON");
    txtHeadINT = GetTextBoxHandle(m_WindowName $ ".txtHeadINT");
    txtHeadWIT = GetTextBoxHandle(m_WindowName $ ".txtHeadWIT");
    txtHeadMEN = GetTextBoxHandle(m_WindowName $ ".txtHeadMEN");
    txtHeadSTR.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3366), 154));
    txtHeadDEX.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3368), 154));
    txtHeadCON.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3370), 154));
    txtHeadINT.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3367), 154));
    txtHeadWIT.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3369), 154));
    txtHeadMEN.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3371), 154));
    return;
}

function OnEnterState(name a_PreStateName)
{
    HandleUpdateUserInfo();
    return;
}

function OnShow()
{
    HandleUpdateUserInfo();
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x15
    if(Event_ID == 180)
    {
        HandleUpdateUserInfo();        
    }
    else
    {
        // End:0x32
        if(Event_ID == 260)
        {
            HandleUpdateHennaInfo(param);            
        }
        else
        {
            // End:0x4D
            if(Event_ID == 191)
            {
                HandleUpdateStatusGauge(param, 0);                
            }
            else
            {
                // End:0x68
                if(Event_ID == 201)
                {
                    HandleUpdateStatusGauge(param, 0);                    
                }
                else
                {
                    // End:0x83
                    if(Event_ID == 211)
                    {
                        HandleUpdateStatusGauge(param, 1);                        
                    }
                    else
                    {
                        // End:0x9E
                        if(Event_ID == 221)
                        {
                            HandleUpdateStatusGauge(param, 1);                            
                        }
                        else
                        {
                            // End:0xBA
                            if(Event_ID == 231)
                            {
                                HandleUpdateStatusGauge(param, 2);                                
                            }
                            else
                            {
                                // End:0xD6
                                if(Event_ID == 241)
                                {
                                    HandleUpdateStatusGauge(param, 2);                                    
                                }
                                else
                                {
                                    // End:0xEE
                                    if(Event_ID == 3400)
                                    {
                                        HandleToggle();                                        
                                    }
                                    else
                                    {
                                        // End:0x110
                                        if(Event_ID == 5310)
                                        {
                                            updateSubjobInfo(param, Event_ID);                                            
                                        }
                                        else
                                        {
                                            // End:0x132
                                            if(Event_ID == 5311)
                                            {
                                                updateSubjobInfo(param, Event_ID);                                                
                                            }
                                            else
                                            {
                                                // End:0x15F
                                                if(Event_ID == 5312)
                                                {
                                                    updateSubjobInfo(param, Event_ID);
                                                    ExecuteEvent(3280);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x177
                                                    if(Event_ID == 1710)
                                                    {
                                                        HandleDialogOK();                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x198
                                                        if(Event_ID == 1720)
                                                        {
                                                            Me.EnableWindow();                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x1B2
                                                            if(Event_ID == 4110)
                                                            {
                                                                HandleVitalityEffectInfo(param);
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
    }
    return;
}

function updateSubjobInfo(string param, int Event_ID)
{
    local int Count, i, CurrentSubjobClassID;
    local UserInfo myUserInfo;
    local bool bFlag;
    local SubjobInfo tempSubjobInfo;

    isDualClass = false;
    GetPlayerInfo(myUserInfo);
    ParseInt(param, "Count", Count);
    ParseInt(param, "currentSubjobClassID", CurrentSubjobClassID);
    // End:0x69
    if(subjobInfoArray.Length > 0)
    {
        subjobInfoArray.Remove(0, subjobInfoArray.Length);
    }
    bFlag = false;
    ParseInt(param, "Race", Race);
    i = 0;
    J0x8E:

    // End:0x198 [Loop If]
    if(i < Count)
    {
        subjobInfoArray.Insert(subjobInfoArray.Length, 1);
        ParseInt(param, "SubjobClassID_" $ string(i), subjobInfoArray[i].ClassID);
        ParseInt(param, "SubjobID_" $ string(i), subjobInfoArray[i].Id);
        ParseInt(param, "SubjobLevel_" $ string(i), subjobInfoArray[i].Level);
        ParseInt(param, "SubjobType_" $ string(i), subjobInfoArray[i].Type);
        // End:0x18E
        if(subjobInfoArray[i].Type == 1)
        {
            isDualClass = true;
        }
        i++;
        // [Loop Continue]
        goto J0x8E;
    }
    i = 0;
    J0x19F:

    // End:0x20D [Loop If]
    if(i < Count)
    {
        // End:0x203
        if(CurrentSubjobClassID == subjobInfoArray[i].ClassID)
        {
            tempSubjobInfo = subjobInfoArray[i];
            subjobInfoArray[i] = subjobInfoArray[0];
            subjobInfoArray[0] = tempSubjobInfo;
            currentSubjobClassNum = 0;
            // [Explicit Break]
            goto J0x20D;
        }
        i++;
        // [Loop Continue]
        goto J0x19F;
    }
    J0x20D:

    i = 1;
    J0x214:

    // End:0x27A [Loop If]
    if(i < 4)
    {
        // End:0x264
        if(i < Count)
        {
            // End:0x259
            if(beforeSubjobInfo.ClassID == subjobInfoArray[i].ClassID)
            {
                bFlag = true;                
            }
            else
            {
                bFlag = false;
            }
            // [Explicit Continue]
            goto J0x270;
        }
        // End:0x270
        if(Race != 6)
        {
        }
        J0x270:

        i++;
        // [Loop Continue]
        goto J0x214;
    }
    // End:0x46B
    if(GetClassTransferDegree(subjobInfoArray[currentSubjobClassNum].ClassID) > 1)
    {
        // End:0x2B0
        if(5312 == Event_ID)
        {
            bFlag = true;            
        }
        else
        {
            bFlag = false;
        }
        // End:0x349
        if(subjobInfoArray[currentSubjobClassNum].Type == 2)
        {
            setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[currentSubjobClassNum].ClassID)) $ "_Big", bFlag);            
        }
        else
        {
            // End:0x3DA
            if(subjobInfoArray[currentSubjobClassNum].Type == 1)
            {
                setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Big", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[currentSubjobClassNum].ClassID)) $ "_Big", bFlag);                
            }
            else
            {
                // End:0x468
                if(subjobInfoArray[currentSubjobClassNum].Type == 0)
                {
                    setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[currentSubjobClassNum].ClassID)) $ "_Big", bFlag);
                }
            }
        }        
    }
    else
    {
        // End:0x4F0
        if(subjobInfoArray[currentSubjobClassNum].Type == 2)
        {
            setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ (getRaceString(Race))) $ "_Big", false);            
        }
        else
        {
            // End:0x575
            if(subjobInfoArray[currentSubjobClassNum].Type == 1)
            {
                setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Big", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ (getRaceString(Race))) $ "_Big", false);                
            }
            else
            {
                // End:0x5F7
                if(subjobInfoArray[currentSubjobClassNum].Type == 0)
                {
                    setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ (getRaceString(Race))) $ "_Big", false);
                }
            }
        }
    }
    beforeSubjobInfo = subjobInfoArray[currentSubjobClassNum];
    return;
}

function HandleDialogOK()
{
    local int dialogValue;
    local ItemInfo infItem;

    // End:0xE6
    if(DialogIsMine())
    {
        // End:0xE6
        if((DialogGetID()) == 90005)
        {
            dialogValue = DialogGetReservedInt();
            switch(dialogValue)
            {
                // End:0x30
                case 0:
                // End:0x34
                case 1:
                // End:0x39
                case 2:
                // End:0xD4
                case 3:
                    ExecuteEvent(3280);
                    // End:0x8B
                    if(subjobInfoArray[dialogValue].Type == 0)
                    {
                        infItem.Id.ClassID = 1566;
                        UseSkill(infItem.Id, int(2));                        
                    }
                    else
                    {
                        // End:0xA1
                        if(subjobInfoArray[dialogValue].Type == 1)
                        {
                        }
                        infItem.Id.ClassID = 1567 + (dialogValue - 1);
                        UseSkill(infItem.Id, int(2));
                    }
                // End:0xFFFF
                default:
                    Me.EnableWindow();
                    break;
                }
        }
    }
    return;
}

function askDialogBox(int currentClickSubjobNum)
{
    local WindowHandle m_dialogWnd;

    m_dialogWnd = GetWindowHandle("DialogBox");
    // End:0x101
    if(!m_dialogWnd.IsShowWindow())
    {
        // End:0x101
        if(subjobInfoArray[0].ClassID != subjobInfoArray[currentClickSubjobNum].ClassID)
        {
            DialogSetID(90005);
            DialogSetReservedInt(currentClickSubjobNum);
            Me.DisableWindow();
            DialogShow(1, 4, MakeFullSystemMsg(GetSystemMessage(3280), ((("<" $ GetClassType(subjobInfoArray[0].ClassID)) $ "> ") $ (getSubjobTypeStr(subjobInfoArray[0].Type))) $ "", ((("<" $ GetClassType(subjobInfoArray[currentClickSubjobNum].ClassID)) $ "> ") $ (getSubjobTypeStr(subjobInfoArray[currentClickSubjobNum].Type))) $ ""), string(self));
        }
    }
    return;
}

function string getSubjobTypeStr(int nType)
{
    local string tempStr;

    switch(nType)
    {
        // End:0x1F
        case 0:
            tempStr = GetSystemString(2340);
            // End:0x53
            break;
        // End:0x37
        case 1:
            tempStr = GetSystemString(2737);
            // End:0x53
            break;
        // End:0x50
        case 2:
            tempStr = GetSystemString(2339);
            // End:0x53
            break;
        // End:0xFFFF
        default:
            break;
    }
    return tempStr;
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0xFFFF
        default:
            return;
            break;
    }
}

function effectAniTexture(int targetType)
{
    GetAnimTextureHandle((m_WindowName $ ".ClassChangeLightSmall") $ string(targetType)).SetTexture("l2ui_ct1.PlayerStatusWnd_ClassChangeLightSmall_00");
    GetAnimTextureHandle((m_WindowName $ ".ClassChangeLightSmall") $ string(targetType)).ShowWindow();
    GetAnimTextureHandle((m_WindowName $ ".ClassChangeLightSmall") $ string(targetType)).SetLoopCount(1);
    GetAnimTextureHandle((m_WindowName $ ".ClassChangeLightSmall") $ string(targetType)).Stop();
    GetAnimTextureHandle((m_WindowName $ ".ClassChangeLightSmall") $ string(targetType)).Play();
    return;
}

function setClassTexture(int targetType, string bgTexture, string markTextureStr, bool effectFlag)
{
    // End:0x152
    if(targetType == 0)
    {
        ClassBgMain_Big.SetTexture(bgTexture);
        ClassMarkBig.SetTexture(markTextureStr);
        // End:0x152
        if(effectFlag == true)
        {
            GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").SetTexture("l2ui_ct1.PlayerStatusWnd_ClassChangeLightBig_00");
            GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").ShowWindow();
            GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").SetLoopCount(1);
            GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").Stop();
            GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig").Play();
        }
    }
    return;
}

function HandleToggle()
{
    // End:0x17
    if(!getInstanceUIData().getIsClassicServer())
    {
        return;
    }
    // End:0x3B
    if(m_hOwnerWnd.IsShowWindow())
    {
        m_hOwnerWnd.HideWindow();        
    }
    else
    {
        m_hOwnerWnd.ShowWindow();
        m_hOwnerWnd.SetFocus();
    }
    return;
}

function HandleUpdateStatusGauge(string param, int Type)
{
    local int ServerID;

    // End:0x46
    if(m_hOwnerWnd.IsShowWindow())
    {
        ParseInt(param, "ServerID", ServerID);
        // End:0x46
        if(m_UserID == ServerID)
        {
            HandleUpdateUserGauge(Type);
        }
    }
    return;
}

function HandleUpdateHennaInfo(string param)
{
    ParseInt(param, "HennaID", m_HennaInfo.HennaID);
    ParseInt(param, "ClassID", m_HennaInfo.ClassID);
    ParseInt(param, "Num", m_HennaInfo.Num);
    ParseInt(param, "Fee", m_HennaInfo.Fee);
    ParseInt(param, "CanUse", m_HennaInfo.CanUse);
    ParseInt(param, "INTnow", m_HennaInfo.INTnow);
    ParseInt(param, "INTchange", m_HennaInfo.INTchange);
    ParseInt(param, "STRnow", m_HennaInfo.STRnow);
    ParseInt(param, "STRchange", m_HennaInfo.STRchange);
    ParseInt(param, "CONnow", m_HennaInfo.CONnow);
    ParseInt(param, "CONchange", m_HennaInfo.CONchange);
    ParseInt(param, "MENnow", m_HennaInfo.MENnow);
    ParseInt(param, "MENchange", m_HennaInfo.MENchange);
    ParseInt(param, "DEXnow", m_HennaInfo.DEXnow);
    ParseInt(param, "DEXchange", m_HennaInfo.DEXchange);
    ParseInt(param, "WITnow", m_HennaInfo.WITnow);
    ParseInt(param, "WITchange", m_HennaInfo.WITchange);
    ParseInt(param, "LUCnow", m_HennaInfo.LUCnow);
    ParseInt(param, "LUCchange", m_HennaInfo.LUCchange);
    ParseInt(param, "CHAnow", m_HennaInfo.CHAnow);
    ParseInt(param, "CHAchange", m_HennaInfo.CHAchange);
    return;
}

function bool GetMyUserInfo(out UserInfo a_MyUserInfo)
{
    return GetPlayerInfo(a_MyUserInfo);
    return;
}

function string GetMovingSpeed(UserInfo a_UserInfo)
{
    local float MovingSpeed;
    local UIEventManager.EMoveType MoveType;
    local UIEventManager.EEnvType EnvType;

    MoveType = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerMoveType();
    EnvType = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerEnvironment();
    // End:0xB1
    if(int(MoveType) == int(2))
    {
        MovingSpeed = float(a_UserInfo.nGroundMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
        switch(EnvType)
        {
            // End:0x85
            case 2:
                MovingSpeed = float(a_UserInfo.nWaterMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
                // End:0xAE
                break;
            // End:0xAB
            case 3:
                MovingSpeed = float(a_UserInfo.nAirMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
                // End:0xAE
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        // End:0x135
        if(int(MoveType) == int(1))
        {
            MovingSpeed = float(a_UserInfo.nGroundMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
            switch(EnvType)
            {
                // End:0x10C
                case 2:
                    MovingSpeed = float(a_UserInfo.nWaterMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
                    // End:0x135
                    break;
                // End:0x132
                case 3:
                    MovingSpeed = float(a_UserInfo.nAirMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
                    // End:0x135
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
        }
        return string(int(MovingSpeed));
        return;
    }
}

function float GetMyExpRate()
{
    return Class'NWindow.UIDATA_PLAYER'.static.GetPlayerEXPRate() * 100.0000000;
    return;
}

function HandleUpdateUserGauge(int Type)
{
    local int CurValue, MaxValue, vitality;
    local UserInfo Info;

    // End:0xDE
    if(GetMyUserInfo(Info))
    {
        vitality = Info.nVitality;
        m_UserID = Info.nID;
        switch(Type)
        {
            // End:0x6C
            case 0:
                CurValue = Info.nCurHP;
                MaxValue = Info.nMaxHP;
                UpdateHPBar(CurValue, MaxValue);
                // End:0xDE
                break;
            // End:0xA3
            case 1:
                CurValue = Info.nCurMP;
                MaxValue = Info.nMaxMP;
                UpdateMPBar(CurValue, MaxValue);
                // End:0xDE
                break;
            // End:0xDB
            case 2:
                CurValue = Info.nCurCP;
                MaxValue = Info.nMaxCP;
                UpdateCPBar(CurValue, MaxValue);
                // End:0xDE
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return;
    }
}

function HandleUpdateUserInfo()
{
    // End:0x18
    if(m_hOwnerWnd.IsShowWindow())
    {
        UpdateInterface();
    }
    return;
}

function UpdateInterface()
{
    local Rect rectWnd;
    local int Width1, Height1, Width2, Height2;
    local string Name, nickname;
    local Color NameColor, NicknameColor;
    local int SubClassID;
    local string ClassName, UserRank;
    local int hp, MaxHP, mp, maxMP, cp, maxCP;

    local INT64 SP;
    local int Level, PledgeID;
    local string PledgeName;
    local Texture PledgeCrestTexture;
    local bool bPledgeCrestTexture;
    local Color PledgeNameColor;
    local string HeroTexture;
    local bool bHero;
    local int nNobless, nStr, nDex, nCon, nInt, nWit,
	    nMen;

    local string strTmp;
    local int nLuc, nCha, PhysicalAttack, PhysicalDefense, HitRate, CriticalRate,
	    PhysicalAttackSpeed, MagicalAttack, MagicDefense, PhysicalAvoid;

    local string MovingSpeed;
    local int MagicCastingSpeed, CriminalRate, iNameColorRate;
    local string strCriminalRate;
    local int DualCount, PKCount, Sociality, RemainSulffrage, RaidPoint, AttrAttackType,
	    nMagicAvoid, nMagicHitRate, nMagicCriticalRate;

    local bool m_bPawnChanged;
    local UserInfo Info;

    texPledgeCrest.SetTexture("");
    rectWnd = m_hOwnerWnd.GetRect();
    // End:0x330
    if(GetMyUserInfo(Info))
    {
        m_UserID = Info.nID;
        Name = Info.Name;
        nickname = Info.strNickName;
        SubClassID = Info.nSubClass;
        ClassName = GetClassType(SubClassID);
        SP = Info.nSP;
        Level = Info.nLevel;
        UserRank = GetUserRankString(Info.nUserRank);
        hp = Info.nCurHP;
        MaxHP = Info.nMaxHP;
        mp = Info.nCurMP;
        maxMP = Info.nMaxMP;
        cp = Info.nCurCP;
        maxCP = Info.nMaxCP;
        PledgeID = Info.nClanID;
        bHero = Info.bHero;
        nNobless = Info.nNobless;
        NicknameColor = Info.NicknameColor;
        nStr = Info.nStr;
        nDex = Info.nDex;
        nCon = Info.nCon;
        nInt = Info.nInt;
        nWit = Info.nWit;
        nMen = Info.nMen;
        nLuc = Info.nLuc;
        nCha = Info.nCha;
        PhysicalAttack = Info.nPhysicalAttack;
        PhysicalDefense = Info.nPhysicalDefense;
        HitRate = Info.nHitRate;
        CriticalRate = Info.nCriticalRate;
        PhysicalAttackSpeed = Info.nPhysicalAttackSpeed;
        MagicalAttack = Info.nMagicalAttack;
        MagicDefense = Info.nMagicDefense;
        PhysicalAvoid = Info.nPhysicalAvoid;
        MagicCastingSpeed = Info.nMagicCastingSpeed;
        MovingSpeed = GetMovingSpeed(Info);
        CriminalRate = Info.nCriminalRate;
        DualCount = Info.nDualCount;
        PKCount = Info.nPKCount;
        Sociality = Info.nSociality;
        RemainSulffrage = Info.nRemainSulffrage;
        RaidPoint = Info.RaidPoint;
        AttrAttackType = Info.AttrAttackType;
        m_bPawnChanged = Info.m_bPawnChanged;
        nMagicAvoid = Info.nMagicAvoid;
        nMagicHitRate = Info.nMagicHitRate;
        nMagicCriticalRate = Info.nMagicCriticalRate;
    }
    // End:0x3C4
    if(CriminalRate > 0)
    {
        iNameColorRate = Min(100 + (CriminalRate / 100), 255);
        NameColor.R = 0;
        NameColor.G = byte(iNameColorRate);
        NameColor.B = 0;
        NameColor.A = byte(255);
        // End:0x3B4
        if(CriminalRate > 999999)
        {
            strCriminalRate = string(999999) $ " (+)";            
        }
        else
        {
            strCriminalRate = string(CriminalRate);
        }        
    }
    else
    {
        // End:0x45A
        if(CriminalRate < 0)
        {
            iNameColorRate = Min(100 + (-CriminalRate / 100), 255);
            NameColor.R = byte(iNameColorRate);
            NameColor.G = 0;
            NameColor.B = 0;
            NameColor.A = byte(255);
            // End:0x44A
            if(CriminalRate < -999999)
            {
                strCriminalRate = string(-999999) $ " (+)";                
            }
            else
            {
                strCriminalRate = string(CriminalRate);
            }            
        }
        else
        {
            NameColor.R = byte(255);
            NameColor.G = byte(255);
            NameColor.B = byte(255);
            NameColor.A = byte(255);
            strCriminalRate = "" $ string(CriminalRate);
        }
    }
    // End:0x5DA
    if(Len(nickname) > 0)
    {
        GetTextSizeDefault(Name, Width1, Height1);
        GetTextSizeDefault(nickname, Width2, Height2);
        // End:0x551
        if((Width1 + Width2) > 220)
        {
            // End:0x521
            if(Width1 > 109)
            {
                Name = Left(Name, 8);
                GetTextSizeDefault(Name, Width1, Height1);
            }
            // End:0x551
            if(Width2 > 109)
            {
                nickname = Left(nickname, 8);
                GetTextSizeDefault(nickname, Width2, Height2);
            }
        }
        txtName1.SetText(nickname);
        txtName1.SetTextColor(NicknameColor);
        txtName2.SetText(Name);
        txtName2.SetTextColor(NameColor);
        txtName2.MoveTo(((rectWnd.nX + 15) + Width2) + 47, rectWnd.nY + 41);        
    }
    else
    {
        txtName1.SetText(Name);
        txtName1.SetTextColor(NameColor);
        txtName2.SetText("");
    }
    txtLvName.SetText("" $ string(Level));
    txtClassName.SetText(ClassName);
    txtRank.SetText(UserRank);
    txtSP.SetText((SP));
    // End:0x6E9
    if(PledgeID > 0)
    {
        bPledgeCrestTexture = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(PledgeID, PledgeCrestTexture);
        PledgeName = Class'NWindow.UIDATA_CLAN'.static.GetName(PledgeID);
        PledgeNameColor.R = 176;
        PledgeNameColor.G = 155;
        PledgeNameColor.B = 121;
        PledgeNameColor.A = byte(255);        
    }
    else
    {
        PledgeName = GetSystemString(431);
        PledgeNameColor.R = byte(255);
        PledgeNameColor.G = byte(255);
        PledgeNameColor.B = byte(255);
        PledgeNameColor.A = byte(255);
    }
    txtPledge.SetText(PledgeName);
    txtPledge.SetTextColor(PledgeNameColor);
    // End:0x7A9
    if(bPledgeCrestTexture)
    {
        texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
        txtPledge.MoveTo(rectWnd.nX + 110, rectWnd.nY + 57);        
    }
    else
    {
        txtPledge.MoveTo(rectWnd.nX + 86, rectWnd.nY + 57);
    }
    // End:0x810
    if(bHero)
    {
        HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_heroicon";        
    }
    else
    {
        // End:0x84F
        if(nNobless == 1)
        {
            HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_nobleicon";            
        }
        else
        {
            // End:0x88D
            if(nNobless == 2)
            {
                HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_nobleicon2";
            }
        }
    }
    // End:0x8C6
    if(m_HennaInfo.STRchange > 0)
    {
        strTmp = ((string(nStr) $ "(+") $ string(m_HennaInfo.STRchange)) $ ")";        
    }
    else
    {
        // End:0x8FE
        if(m_HennaInfo.STRchange < 0)
        {
            strTmp = ((string(nStr) $ "(") $ string(m_HennaInfo.STRchange)) $ ")";            
        }
        else
        {
            strTmp = string(nStr);
        }
    }
    txtSTR.SetText(strTmp);
    // End:0x958
    if(m_HennaInfo.DEXchange > 0)
    {
        strTmp = ((string(nDex) $ "(+") $ string(m_HennaInfo.DEXchange)) $ ")";        
    }
    else
    {
        // End:0x990
        if(m_HennaInfo.DEXchange < 0)
        {
            strTmp = ((string(nDex) $ "(") $ string(m_HennaInfo.DEXchange)) $ ")";            
        }
        else
        {
            strTmp = string(nDex);
        }
    }
    txtDEX.SetText(strTmp);
    // End:0x9EA
    if(m_HennaInfo.CONchange > 0)
    {
        strTmp = ((string(nCon) $ "(+") $ string(m_HennaInfo.CONchange)) $ ")";        
    }
    else
    {
        // End:0xA22
        if(m_HennaInfo.CONchange < 0)
        {
            strTmp = ((string(nCon) $ "(") $ string(m_HennaInfo.CONchange)) $ ")";            
        }
        else
        {
            strTmp = string(nCon);
        }
    }
    txtCON.SetText(strTmp);
    // End:0xA7C
    if(m_HennaInfo.INTchange > 0)
    {
        strTmp = ((string(nInt) $ "(+") $ string(m_HennaInfo.INTchange)) $ ")";        
    }
    else
    {
        // End:0xAB4
        if(m_HennaInfo.INTchange < 0)
        {
            strTmp = ((string(nInt) $ "(") $ string(m_HennaInfo.INTchange)) $ ")";            
        }
        else
        {
            strTmp = string(nInt);
        }
    }
    txtINT.SetText(strTmp);
    // End:0xB0E
    if(m_HennaInfo.WITchange > 0)
    {
        strTmp = ((string(nWit) $ "(+") $ string(m_HennaInfo.WITchange)) $ ")";        
    }
    else
    {
        // End:0xB46
        if(m_HennaInfo.WITchange < 0)
        {
            strTmp = ((string(nWit) $ "(") $ string(m_HennaInfo.WITchange)) $ ")";            
        }
        else
        {
            strTmp = string(nWit);
        }
    }
    txtWIT.SetText(strTmp);
    // End:0xBA0
    if(m_HennaInfo.MENchange > 0)
    {
        strTmp = ((string(nMen) $ "(+") $ string(m_HennaInfo.MENchange)) $ ")";        
    }
    else
    {
        // End:0xBD8
        if(m_HennaInfo.MENchange < 0)
        {
            strTmp = ((string(nMen) $ "(") $ string(m_HennaInfo.MENchange)) $ ")";            
        }
        else
        {
            strTmp = string(nMen);
        }
    }
    txtMEN.SetText(strTmp);
    // End:0xC32
    if(m_HennaInfo.LUCchange > 0)
    {
        strTmp = ((string(nLuc) $ "(+") $ string(m_HennaInfo.LUCchange)) $ ")";        
    }
    else
    {
        // End:0xC6A
        if(m_HennaInfo.LUCchange < 0)
        {
            strTmp = ((string(nLuc) $ "(") $ string(m_HennaInfo.LUCchange)) $ ")";            
        }
        else
        {
            strTmp = string(nLuc);
        }
    }
    // End:0xCB0
    if(m_HennaInfo.CHAchange > 0)
    {
        strTmp = ((string(nCha) $ "(+") $ string(m_HennaInfo.CHAchange)) $ ")";        
    }
    else
    {
        // End:0xCE8
        if(m_HennaInfo.CHAchange < 0)
        {
            strTmp = ((string(nCha) $ "(") $ string(m_HennaInfo.CHAchange)) $ ")";            
        }
        else
        {
            strTmp = string(nCha);
        }
    }
    nMagicAvoid = Info.nMagicAvoid;
    nMagicHitRate = Info.nMagicHitRate;
    nMagicCriticalRate = Info.nMagicCriticalRate;
    GetTextBoxHandle(m_WindowName $ ".txtMagicAvoid").SetText(string(nMagicAvoid));
    GetTextBoxHandle(m_WindowName $ ".txtMagicHit").SetText(string(nMagicHitRate));
    GetTextBoxHandle(m_WindowName $ ".txtMagicCritical").SetText(string(nMagicCriticalRate));
    txtPhysicalAttack.SetText(string(PhysicalAttack));
    txtPhysicalDefense.SetText(string(PhysicalDefense));
    txtHitRate.SetText(string(HitRate));
    txtCriticalRate.SetText(string(CriticalRate));
    txtPhysicalAttackSpeed.SetText(string(PhysicalAttackSpeed));
    txtMagicalAttack.SetText(string(MagicalAttack));
    txtMagicDefense.SetText(string(MagicDefense));
    txtPhysicalAvoid.SetText(string(PhysicalAvoid));
    txtMovingSpeed.SetText(MovingSpeed);
    txtMagicCastingSpeed.SetText(string(MagicCastingSpeed));
    txtCriminalRate.SetText(strCriminalRate);
    txtSociality.SetText((string(DualCount) $ " / ") $ string(PKCount));
    txtRemainSulffrage.SetText((string(Sociality) $ " / ") $ string(RemainSulffrage));
    txtRaidPoint.SetText(string(RaidPoint));
    UpdateHPBar(hp, MaxHP);
    UpdateMPBar(mp, maxMP);
    UpdateCPBar(cp, maxCP);
    UpdateEXPBar(Info.fExpPercentRate);
    // End:0xF4C
    if(m_bPawnChanged)
    {        
    }
    else
    {
        RunUnTransformManage();
    }
    return;
}

function UpdateHPBar(int Value, int MaxValue)
{
    texHP.SetPoint(Value, MaxValue);
    return;
}

function UpdateMPBar(int Value, int MaxValue)
{
    texMP.SetPoint(Value, MaxValue);
    return;
}

function UpdateEXPBar(float ExpPercent)
{
    texExp.SetPointExpPercentRate(ExpPercent);
    return;
}

function UpdateCPBar(int Value, int MaxValue)
{
    texCP.SetPoint(Value, MaxValue);
    return;
}

function ToggleOpenCharInfoWnd()
{
    switch(m_hOwnerWnd.IsShowWindow())
    {
        // End:0x4F
        case true:
            m_hOwnerWnd.HideWindow();
            PlaySound("InterfaceSound.charstat_close_01");
            // End:0x9E
            break;
        // End:0x9B
        case false:
            m_hOwnerWnd.ShowWindow();
            m_hOwnerWnd.SetFocus();
            PlaySound("InterfaceSound.charstat_open_01");
            // End:0x9E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleVitalityEffectInfo(string param)
{
    local CustomTooltip t;
    local string tmpStr, sSysMsgParamString;
    local int nVitality, nVitalityBonus, nVitalityItemRestoreCount;

    ParseInt(param, "vitalityPoint", nVitality);
    ParseInt(param, "vitalityBonus", nVitalityBonus);
    ParseInt(param, "restoreCount", nVitalityItemRestoreCount);
    util = L2Util(GetScript("L2Util"));
    util.setCustomTooltip(t);
    util.ToopTipInsertText(GetSystemString(2494), true, false);
    // End:0x179
    if(nVitality <= 0)
    {
        tmpStr = GetSystemString(2496);
        util.ToopTipInsertText(tmpStr, true, false, util.1);
        tmpStr = ", ";
        util.ToopTipInsertText(tmpStr, true, false);
        sSysMsgParamString = "";
        tmpStr = "";
        ParamAdd(sSysMsgParamString, "Type", string(int(1)));
        ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemRestoreCount));
        AddSystemMessageParam(sSysMsgParamString);
        tmpStr = EndSystemMessageParam(6073, true);
        util.ToopTipInsertText(tmpStr, true, false);        
    }
    else
    {
        sSysMsgParamString = "";
        tmpStr = "";
        ParamAdd(sSysMsgParamString, "Type", string(int(1)));
        ParamAdd(sSysMsgParamString, "param1", string(nVitalityBonus));
        AddSystemMessageParam(sSysMsgParamString);
        tmpStr = EndSystemMessageParam(6072, true);
        util.ToopTipInsertText(tmpStr, true, false);
        tmpStr = " ";
        util.ToopTipInsertText(tmpStr, true, false);
        tmpStr = "";
        sSysMsgParamString = "";
        ParamAdd(sSysMsgParamString, "Type", string(int(1)));
        ParamAdd(sSysMsgParamString, "param1", string(nVitalityItemRestoreCount));
        AddSystemMessageParam(sSysMsgParamString);
        tmpStr = EndSystemMessageParam(6073, true);
        util.ToopTipInsertText(tmpStr, true, false);
    }
    return;
}

function RunTransformManage()
{
    return;
}

function RunUnTransformManage()
{
    return;
}

function CustomTooltip subjobButtonToolTips(int targetType)
{
    local CustomTooltip m_Tooltip;
    local int subjobSlotStringNum;

    // End:0xE5
    if(targetType == -1)
    {
        m_Tooltip.DrawList.Length = 1;
        m_Tooltip.MinimumWidth = 210;
        m_Tooltip.DrawList[0].eType = 1;
        m_Tooltip.DrawList[0].t_color.R = 220;
        m_Tooltip.DrawList[0].t_color.G = 220;
        m_Tooltip.DrawList[0].t_color.B = 220;
        m_Tooltip.DrawList[0].t_color.A = byte(255);
        subjobSlotStringNum = 2342;
        // End:0xC5
        if(Race == 6)
        {
            subjobSlotStringNum = 3315;
        }
        m_Tooltip.DrawList[0].t_strText = GetSystemString(subjobSlotStringNum);        
    }
    else
    {
        m_Tooltip.DrawList.Length = 5;
        m_Tooltip.MinimumWidth = 214;
        m_Tooltip.DrawList[0].eType = 1;
        m_Tooltip.DrawList[0].t_color.R = 170;
        m_Tooltip.DrawList[0].t_color.G = 170;
        m_Tooltip.DrawList[0].t_color.B = 170;
        m_Tooltip.DrawList[0].t_color.A = byte(255);
        m_Tooltip.DrawList[0].t_strText = "Lv";
        m_Tooltip.DrawList[1].eType = 1;
        m_Tooltip.DrawList[1].t_color.R = 175;
        m_Tooltip.DrawList[1].t_color.G = 152;
        m_Tooltip.DrawList[1].t_color.B = 120;
        m_Tooltip.DrawList[1].t_color.A = byte(255);
        m_Tooltip.DrawList[1].t_strText = string(subjobInfoArray[targetType].Level) @ GetClassType(subjobInfoArray[targetType].ClassID);
        m_Tooltip.DrawList[2].eType = 1;
        m_Tooltip.DrawList[2].t_color.R = 170;
        m_Tooltip.DrawList[2].t_color.G = 170;
        m_Tooltip.DrawList[2].t_color.B = 170;
        m_Tooltip.DrawList[2].t_color.A = byte(255);
        // End:0x308
        if(subjobInfoArray[targetType].Type == 2)
        {
            m_Tooltip.DrawList[2].t_strText = (" (" $ GetSystemString(2341)) $ ")";            
        }
        else
        {
            // End:0x34A
            if(subjobInfoArray[targetType].Type == 1)
            {
                m_Tooltip.DrawList[2].t_strText = (" (" $ GetSystemString(2739)) $ ")";                
            }
            else
            {
                m_Tooltip.DrawList[2].t_strText = (" (" $ GetSystemString(2738)) $ ")";
            }
        }
        m_Tooltip.DrawList[3].eType = 1;
        m_Tooltip.DrawList[3].bLineBreak = true;
        m_Tooltip.DrawList[3].t_color.R = 220;
        m_Tooltip.DrawList[3].t_color.G = 220;
        m_Tooltip.DrawList[3].t_color.B = 220;
        m_Tooltip.DrawList[3].t_color.A = byte(255);
        m_Tooltip.DrawList[3].t_strText = GetSystemString(2343);
        m_Tooltip.DrawList[4].eType = 1;
        // End:0x4FF
        if((subjobInfoArray[targetType].Type == 2) && isDualClass == false)
        {
            m_Tooltip.DrawList[4].bLineBreak = true;
            m_Tooltip.DrawList[4].t_color.R = 110;
            m_Tooltip.DrawList[4].t_color.G = 140;
            m_Tooltip.DrawList[4].t_color.B = 170;
            m_Tooltip.DrawList[4].t_color.A = byte(255);
            m_Tooltip.DrawList[4].t_strText = GetSystemString(2344);            
        }
        else
        {
            m_Tooltip.DrawList[4].t_strText = "";
        }
    }
    return m_Tooltip;
    return;
}

function string getRaceString(int nRace)
{
    local string returnV;

    switch(nRace)
    {
        // End:0x1B
        case 0:
            returnV = "human";
            // End:0xA4
            break;
        // End:0x2D
        case 1:
            returnV = "elf";
            // End:0xA4
            break;
        // End:0x44
        case 2:
            returnV = "darkelf";
            // End:0xA4
            break;
        // End:0x57
        case 3:
            returnV = "orc";
            // End:0xA4
            break;
        // End:0x6C
        case 4:
            returnV = "dwarf";
            // End:0xA4
            break;
        // End:0x82
        case 5:
            returnV = "kamael";
            // End:0xA4
            break;
        // End:0x99
        case 6:
            returnV = "Ertheia";
            // End:0xA4
            break;
        // End:0xFFFF
        default:
            returnV = "";
            break;
    }
    return returnV;
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
    m_WindowName="DetailStatusWndClassic"
}