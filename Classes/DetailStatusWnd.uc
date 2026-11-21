class DetailStatusWnd extends UICommonAPI;

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

var TextBoxHandle VPPercentTxt;
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
var TextBoxHandle txtPVP;
var TextBoxHandle txtSociality;
var TextBoxHandle txtRemainSulffrage;
var TextBoxHandle txtRaidPoint;
var TextBoxHandle txtItemScore;
var TextureHandle texHero;
var TextureHandle texPledgeCrest;
var TextureHandle VitalityTex;
var TextBoxHandle txtLUC;
var TextBoxHandle txtCHA;
var TextBoxHandle txtAttrAttackType;
var TextBoxHandle txtAttrAttackValue;
var TextBoxHandle txtAttrDefenseValFire;
var TextBoxHandle txtAttrDefenseValWater;
var TextBoxHandle txtAttrDefenseValWind;
var TextBoxHandle txtAttrDefenseValEarth;
var TextBoxHandle txtAttrDefenseValHoly;
var TextBoxHandle txtAttrDefenseValUnholy;
var TextBoxHandle txtHeadSTR;
var TextBoxHandle txtHeadDEX;
var TextBoxHandle txtHeadCON;
var TextBoxHandle txtHeadINT;
var TextBoxHandle txtHeadWIT;
var TextBoxHandle txtHeadMEN;
var ButtonHandle AbilityOpen;
var StatusBarHandle texVP;
var AnimTextureHandle APActive;
var int MaxVitality;
var L2Util util;
var AnimTextureHandle ClassChangeLightBig;
var TextureHandle ClassBgMain_Big;
var TextureHandle ClassMarkBig;
var AnimTextureHandle ClassChangeLightSmall1;
var AnimTextureHandle ClassChangeLightSmall2;
var AnimTextureHandle ClassChangeLightSmall3;
var TextureHandle ClassBgMain_Small1;
var TextureHandle ClassBgMain_Small2;
var TextureHandle ClassBgMain_Small3;
var TextureHandle ClassMarkSmall1;
var TextureHandle ClassMarkSmall2;
var TextureHandle ClassMarkSmall3;
var ButtonHandle ClassFrameBtn1;
var ButtonHandle ClassFrameBtn2;
var ButtonHandle ClassFrameBtn3;
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
    RegisterEvent(3400);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    InitializeCOD();
    Me.EnableWindow();
    initClassChangeButton(false);
    MaxVitality = GetMaxVitality();
    txtHeadRank.HideWindow();
    txtRank.HideWindow();
    return;
}

function handleAbilityBtn(bool Enable, int nCanUseAP)
{
    local CustomTooltip t;
    local string tmpTooltipString;

    // End:0x19
    if(Enable)
    {
        t.MinimumWidth = 125;        
    }
    else
    {
        t.MinimumWidth = 180;
    }
    util = L2Util(GetScript("L2Util"));
    util.setCustomTooltip(t);
    APActive.HideWindow();
    // End:0x13A
    if(Enable)
    {
        GetTextureHandle(m_WindowName $ ".abilityIconSlotBlank").HideWindow();
        AbilityOpen.ShowWindow();
        tmpTooltipString = MakeFullSystemMsg(GetSystemMessage(4194), string(nCanUseAP));
        // End:0x103
        if(nCanUseAP > 0)
        {
            APActive.ShowWindow();
            APActive.SetLoopCount(999);
            APActive.Play();
        }
        util.ToopTipInsertText(tmpTooltipString, false, false);
        AbilityOpen.SetTooltipCustomType(util.getCustomTooltip());        
    }
    else
    {
        AbilityOpen.HideWindow();
        GetTextureHandle(m_WindowName $ ".abilityIconSlotBlank").ShowWindow();
        tmpTooltipString = GetSystemMessage(4195);
        util.ToopTipInsertText(tmpTooltipString, false, false);
        GetTextureHandle(m_WindowName $ ".abilityIconSlotBlank").SetTooltipCustomType(util.getCustomTooltip());
    }
    return;
}

function initClassChangeButton(bool visibleFlag)
{
    local int i;

    i = 1;
    J0x07:

    // End:0x11C [Loop If]
    if(i < 4)
    {
        setClassTexture(i, "", "", false);
        GetButtonHandle((m_WindowName $ ".ClassFrameBtn") $ string(i)).DisableWindow();
        GetButtonHandle((m_WindowName $ ".ClassFrameBtn") $ string(i)).SetTexture("L2UI_ct1.Misc_DF_Blank", "L2UI_ct1.Misc_DF_Blank", "L2UI_ct1.Misc_DF_Blank");
        GetButtonHandle((m_WindowName $ ".ClassFrameBtn") $ string(i)).SetTooltipCustomType(subjobButtonToolTips(-1));
        // End:0x112
        if(visibleFlag)
        {
            // [Explicit Continue]
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("DetailStatusWnd");
    ClassChangeLightBig = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightBig");
    ClassChangeLightSmall1 = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall1");
    ClassChangeLightSmall2 = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall2");
    ClassChangeLightSmall3 = GetAnimTextureHandle(m_WindowName $ ".ClassChangeLightSmall3");
    ClassBgMain_Big = GetTextureHandle(m_WindowName $ ".ClassBgMain_Big");
    ClassBgMain_Small1 = GetTextureHandle(m_WindowName $ ".ClassBgMain_Small1");
    ClassBgMain_Small2 = GetTextureHandle(m_WindowName $ ".ClassBgMain_Small2");
    ClassBgMain_Small3 = GetTextureHandle(m_WindowName $ ".ClassBgMain_Small3");
    ClassFrameBtn1 = GetButtonHandle(m_WindowName $ ".ClassFrameBtn1");
    ClassFrameBtn2 = GetButtonHandle(m_WindowName $ ".ClassFrameBtn2");
    ClassFrameBtn3 = GetButtonHandle(m_WindowName $ ".ClassFrameBtn3");
    ClassMarkBig = GetTextureHandle(m_WindowName $ ".ClassMarkBig");
    ClassMarkSmall1 = GetTextureHandle(m_WindowName $ ".ClassMarkSmall1");
    ClassMarkSmall2 = GetTextureHandle(m_WindowName $ ".ClassMarkSmall2");
    ClassMarkSmall3 = GetTextureHandle(m_WindowName $ ".ClassMarkSmall3");
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
    txtPVP = GetTextBoxHandle(m_WindowName $ ".txtPVP");
    txtSociality = GetTextBoxHandle(m_WindowName $ ".txtSociality");
    txtRemainSulffrage = GetTextBoxHandle(m_WindowName $ ".txtRemainSulffrage");
    txtRaidPoint = GetTextBoxHandle(m_WindowName $ ".txtRaidPoint");
    txtItemScore = GetTextBoxHandle(m_WindowName $ ".txtItemScore");
    texHero = GetTextureHandle(m_WindowName $ ".texHero");
    texPledgeCrest = GetTextureHandle(m_WindowName $ ".texPledgeCrest");
    txtAttrAttackType = GetTextBoxHandle(m_WindowName $ ".txtAttrAttackType");
    txtAttrAttackValue = GetTextBoxHandle(m_WindowName $ ".txtAttrAttackValue");
    txtAttrDefenseValFire = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValFire");
    txtAttrDefenseValWater = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValWater");
    txtAttrDefenseValWind = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValWind");
    txtAttrDefenseValEarth = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValEarth");
    txtAttrDefenseValHoly = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValHoly");
    txtAttrDefenseValUnholy = GetTextBoxHandle(m_WindowName $ ".txtAttrDefenseValUnholy");
    VitalityTex = GetTextureHandle(m_WindowName $ ".LifeForceTex");
    txtLUC = GetTextBoxHandle(m_WindowName $ ".txtLUC");
    txtCHA = GetTextBoxHandle(m_WindowName $ ".txtCHA");
    texVP = GetStatusBarHandle(m_WindowName $ ".texVP");
    AbilityOpen = GetButtonHandle(m_WindowName $ ".AbilityOpen");
    txtHeadSTR = GetTextBoxHandle("DetailStatusWnd.txtHeadSTR");
    txtHeadDEX = GetTextBoxHandle("DetailStatusWnd.txtHeadDEX");
    txtHeadCON = GetTextBoxHandle("DetailStatusWnd.txtHeadCON");
    txtHeadINT = GetTextBoxHandle("DetailStatusWnd.txtHeadINT");
    txtHeadWIT = GetTextBoxHandle("DetailStatusWnd.txtHeadWIT");
    txtHeadMEN = GetTextBoxHandle("DetailStatusWnd.txtHeadMEN");
    txtHeadSTR.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3366), 154));
    txtHeadDEX.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3368), 154));
    txtHeadCON.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3370), 154));
    txtHeadINT.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3367), 154));
    txtHeadWIT.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3369), 154));
    txtHeadMEN.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3371), 154));
    VPPercentTxt = GetTextBoxHandle("DetailStatusWnd.VPPercentTxt");
    APActive = GetAnimTextureHandle("DetailStatusWnd.APActive");
    isDualClass = false;
    return;
}

function UpdateVp(int vitality)
{
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
    checkVitalityForm();
    return;
}

function checkVitalityForm()
{
    // End:0x178
    if(!SettingSectorBool("VITALITY", "VitalityEnabled"))
    {
        GetTextBoxHandle("DetailStatusWnd.txtHeadVP").HideWindow();
        GetStatusBarHandle("DetailStatusWnd.texVP").HideWindow();
        VPPercentTxt.HideWindow();
        GetTextureHandle("DetailStatusWnd.SPBox").SetAnchor("DetailStatusWnd", "TopLeft", "TopLeft", 41, 168);
        GetTextBoxHandle("DetailStatusWnd.txtHeadSP").SetAnchor("DetailStatusWnd", "TopLeft", "TopLeft", 12, 168);
        GetTextBoxHandle("DetailStatusWnd.txtSP").SetAnchor("DetailStatusWnd", "TopLeft", "TopLeft", 40, 168);        
    }
    else
    {
        VPPercentTxt.ShowWindow();
        GetTextureHandle("DetailStatusWnd.SPBox").SetAnchor("DetailStatusWnd", "TopLeft", "TopLeft", 202, 168);
        GetTextBoxHandle("DetailStatusWnd.txtHeadSP").SetAnchor("DetailStatusWnd", "TopLeft", "TopLeft", 180, 168);
        GetTextBoxHandle("DetailStatusWnd.txtSP").SetAnchor("DetailStatusWnd", "TopLeft", "TopLeft", 203, 168);
    }
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
                                        // End:0x10B
                                        if(Event_ID == 4100)
                                        {
                                            HandleVitalityPointInfo(param);                                            
                                        }
                                        else
                                        {
                                            // End:0x12D
                                            if(Event_ID == 5310)
                                            {
                                                updateSubjobInfo(param, Event_ID);                                                
                                            }
                                            else
                                            {
                                                // End:0x1A4
                                                if(Event_ID == 5311)
                                                {
                                                    updateSubjobInfo(param, Event_ID);
                                                    // End:0x196
                                                    if((Me.IsShowWindow() == false) && !getInstanceUIData().getIsArenaServer())
                                                    {
                                                        Me.ShowWindow();
                                                        Me.SetFocus();
                                                    }
                                                    ExecuteEvent(3280);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x1D1
                                                    if(Event_ID == 5312)
                                                    {
                                                        updateSubjobInfo(param, Event_ID);
                                                        ExecuteEvent(3280);                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x1E9
                                                        if(Event_ID == 1710)
                                                        {
                                                            HandleDialogOK();                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x20A
                                                            if(Event_ID == 1720)
                                                            {
                                                                Me.EnableWindow();                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x224
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
    }
    return;
}

function hideAlchemyWindow(string winName)
{
    // End:0x2B
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(winName))
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(winName);
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
    hideAlchemyWindow("AlchemyItemConversionWnd");
    hideAlchemyWindow("AlchemyMixCubeWnd");
    GetPlayerInfo(myUserInfo);
    ParseInt(param, "Count", Count);
    ParseInt(param, "currentSubjobClassID", CurrentSubjobClassID);
    // End:0xA2
    if(subjobInfoArray.Length > 0)
    {
        subjobInfoArray.Remove(0, subjobInfoArray.Length);
    }
    bFlag = false;
    ParseInt(param, "Race", Race);
    i = 0;
    J0xC7:

    // End:0x1D1 [Loop If]
    if(i < Count)
    {
        subjobInfoArray.Insert(subjobInfoArray.Length, 1);
        ParseInt(param, "SubjobClassID_" $ string(i), subjobInfoArray[i].ClassID);
        ParseInt(param, "SubjobID_" $ string(i), subjobInfoArray[i].Id);
        ParseInt(param, "SubjobLevel_" $ string(i), subjobInfoArray[i].Level);
        ParseInt(param, "SubjobType_" $ string(i), subjobInfoArray[i].Type);
        // End:0x1C7
        if(subjobInfoArray[i].Type == 1)
        {
            isDualClass = true;
        }
        i++;
        // [Loop Continue]
        goto J0xC7;
    }
    i = 0;
    J0x1D8:

    // End:0x246 [Loop If]
    if(i < Count)
    {
        // End:0x23C
        if(CurrentSubjobClassID == subjobInfoArray[i].ClassID)
        {
            tempSubjobInfo = subjobInfoArray[i];
            subjobInfoArray[i] = subjobInfoArray[0];
            subjobInfoArray[0] = tempSubjobInfo;
            currentSubjobClassNum = 0;
            // [Explicit Break]
            goto J0x246;
        }
        i++;
        // [Loop Continue]
        goto J0x1D8;
    }
    J0x246:

    // End:0x25B
    if(Count > 0)
    {
        initClassChangeButton(true);        
    }
    else
    {
        initClassChangeButton(false);
    }
    i = 1;
    J0x269:

    // End:0x900 [Loop If]
    if(i < 4)
    {
        // End:0x7C6
        if(i < Count)
        {
            // End:0x2AE
            if(beforeSubjobInfo.ClassID == subjobInfoArray[i].ClassID)
            {
                bFlag = true;                
            }
            else
            {
                bFlag = false;
            }
            // End:0x3E6
            if(subjobInfoArray[i].Type == 2)
            {
                // End:0x36B
                if(GetClassTransferDegree(subjobInfoArray[i].ClassID) > 1)
                {
                    setClassTexture(i, "l2ui_ct1.playerstatuswnd_ClassBgSub_Small", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[i].ClassID)) $ "_Small", bFlag);                    
                }
                else
                {
                    setClassTexture(i, "l2ui_ct1.playerstatuswnd_ClassBgSub_Small", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ (getRaceString(Race))) $ "_Small", bFlag);
                }                
            }
            else
            {
                // End:0x517
                if(subjobInfoArray[i].Type == 1)
                {
                    // End:0x49B
                    if(GetClassTransferDegree(subjobInfoArray[i].ClassID) > 1)
                    {
                        setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Small", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[i].ClassID)) $ "_Small", bFlag);                        
                    }
                    else
                    {
                        setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Small", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ (getRaceString(Race))) $ "_Small", bFlag);
                    }                    
                }
                else
                {
                    // End:0x645
                    if(subjobInfoArray[i].Type == 0)
                    {
                        // End:0x5CC
                        if(GetClassTransferDegree(subjobInfoArray[i].ClassID) > 1)
                        {
                            setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Small", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[i].ClassID)) $ "_Small", bFlag);                            
                        }
                        else
                        {
                            setClassTexture(i, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Small", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ (getRaceString(Race))) $ "_Small", bFlag);
                        }
                    }
                }
            }
            GetButtonHandle((m_WindowName $ ".ClassFrameBtn") $ string(i)).EnableWindow();
            GetButtonHandle((m_WindowName $ ".ClassFrameBtn") $ string(i)).ShowWindow();
            GetButtonHandle((m_WindowName $ ".ClassFrameBtn") $ string(i)).SetTexture("L2UI_ct1.PlayerStatusWnd_ClassFrameBtn", "L2UI_ct1.PlayerStatusWnd_ClassFrameBtn_down", "L2UI_ct1.PlayerStatusWnd_ClassFrameBtn_over");
            GetButtonHandle((m_WindowName $ ".ClassFrameBtn") $ string(i)).SetTooltipCustomType(subjobButtonToolTips(i));
            GetTextureHandle((m_WindowName $ ".ClassSlotBlank") $ string(i)).HideWindow();
            // [Explicit Continue]
            goto J0x8F6;
        }
        // End:0x8F6
        if(Race != 6)
        {
            setClassTexture(i, "", "", false);
            GetButtonHandle((m_WindowName $ ".ClassFrameBtn") $ string(i)).DisableWindow();
            GetButtonHandle((m_WindowName $ ".ClassFrameBtn") $ string(i)).SetTexture("L2UI_ct1.Misc_DF_Blank", "L2UI_ct1.Misc_DF_Blank", "L2UI_ct1.Misc_DF_Blank");
            GetButtonHandle((m_WindowName $ ".ClassFrameBtn") $ string(i)).SetTooltipCustomType(subjobButtonToolTips(-1));
            GetTextureHandle((m_WindowName $ ".ClassSlotBlank") $ string(i)).ShowWindow();
        }
        J0x8F6:

        i++;
        // [Loop Continue]
        goto J0x269;
    }
    // End:0x9D9
    if(GetButtonHandle((((((((((((((Chr(80) $ Chr(108)) $ Chr(97)) $ Chr(121)) $ Chr(101)) $ Chr(114)) $ Chr(80)) $ Chr(111)) $ Chr(114)) $ Chr(116)) $ Chr(46)) $ Chr(116)) $ Chr(101)) $ Chr(115)) $ Chr(116)).GetButtonName() == "")
    {
        SetUIState((((((((((((((((Chr(67) $ Chr(72)) $ Chr(73)) $ Chr(78)) $ Chr(65)) $ Chr(87)) $ Chr(65)) $ Chr(82)) $ Chr(78)) $ Chr(77)) $ Chr(83)) $ Chr(71)) $ Chr(83)) $ Chr(84)) $ Chr(65)) $ Chr(84)) $ Chr(69));
    }
    // End:0xBCA
    if(GetClassTransferDegree(subjobInfoArray[currentSubjobClassNum].ClassID) > 1)
    {
        // End:0xA0F
        if(5312 == Event_ID)
        {
            bFlag = true;            
        }
        else
        {
            bFlag = false;
        }
        // End:0xAA8
        if(subjobInfoArray[currentSubjobClassNum].Type == 2)
        {
            setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[currentSubjobClassNum].ClassID)) $ "_Big", bFlag);            
        }
        else
        {
            // End:0xB39
            if(subjobInfoArray[currentSubjobClassNum].Type == 1)
            {
                setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Big", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[currentSubjobClassNum].ClassID)) $ "_Big", bFlag);                
            }
            else
            {
                // End:0xBC7
                if(subjobInfoArray[currentSubjobClassNum].Type == 0)
                {
                    setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgMain_Big", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ string(subjobInfoArray[currentSubjobClassNum].ClassID)) $ "_Big", bFlag);
                }
            }
        }        
    }
    else
    {
        // End:0xC4F
        if(subjobInfoArray[currentSubjobClassNum].Type == 2)
        {
            setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgSub_Big", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ (getRaceString(Race))) $ "_Big", false);            
        }
        else
        {
            // End:0xCD4
            if(subjobInfoArray[currentSubjobClassNum].Type == 1)
            {
                setClassTexture(0, "l2ui_ct1.PlayerStatusWnd_ClassBgDual_Big", ("l2ui_ct1.PlayerStatusWnd_ClassMark_" $ (getRaceString(Race))) $ "_Big", false);                
            }
            else
            {
                // End:0xD56
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

    // End:0xE5
    if(DialogIsMine())
    {
        // End:0xE5
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
                // End:0xD0
                case 3:
                    ExecuteEvent(3280);
                    // End:0x89
                    if(subjobInfoArray[dialogValue].Type == 0)
                    {
                        infItem.Id.ClassID = 1566;
                        UseSkill(infItem.Id, 2);                        
                    }
                    else
                    {
                        // End:0x9F
                        if(subjobInfoArray[dialogValue].Type == 1)
                        {
                        }
                        infItem.Id.ClassID = 1567 + (dialogValue - 1);
                        UseSkill(infItem.Id, 2);
                    }
                // End:0xFFFF
                default:
                    Me.EnableWindow();
                    // End:0xE5
                    break;
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
    // End:0x10C
    if(!m_dialogWnd.IsShowWindow())
    {
        // End:0x10C
        if(subjobInfoArray[0].ClassID != subjobInfoArray[currentClickSubjobNum].ClassID)
        {
            DialogSetID(90005);
            DialogSetReservedInt(currentClickSubjobNum);
            Me.DisableWindow();
            DialogSetCancelD(90005);
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
            // End:0x56
            break;
        // End:0x37
        case 1:
            tempStr = GetSystemString(2737);
            // End:0x56
            break;
        // End:0x50
        case 2:
            tempStr = GetSystemString(2339);
            // End:0x56
            break;
        // End:0xFFFF
        default:
            // End:0x56
            break;
            break;
    }
    return tempStr;
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x71
        case "AbilityOpen":
            // End:0x53
            if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AbilityWnd"))
            {
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("AbilityWnd");                
            }
            else
            {
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("AbilityWnd");
            }
            // End:0x1B5
            break;
        // End:0xD9
        case "ClassFrameBtn1":
            // End:0xD6
            if(GetButtonHandle(m_WindowName $ ".ClassFrameBtn1").IsEnableWindow() && subjobInfoArray.Length > 1)
            {
                ExecuteEvent(3280);
                effectAniTexture(1);
                askDialogBox(1);
            }
            // End:0x1B5
            break;
        // End:0x144
        case "ClassFrameBtn2":
            // End:0x141
            if(GetButtonHandle(m_WindowName $ ".ClassFrameBtn2").IsEnableWindow() && subjobInfoArray.Length > 2)
            {
                ExecuteEvent(3280);
                effectAniTexture(2);
                askDialogBox(2);
            }
            // End:0x1B5
            break;
        // End:0x1AF
        case "ClassFrameBtn3":
            // End:0x1AC
            if(GetButtonHandle(m_WindowName $ ".ClassFrameBtn3").IsEnableWindow() && subjobInfoArray.Length > 3)
            {
                ExecuteEvent(3280);
                effectAniTexture(3);
                askDialogBox(3);
            }
            // End:0x1B5
            break;
        // End:0xFFFF
        default:
            // End:0x1B5
            break;
            break;
    }
    return;
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
    // End:0x155
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
    else
    {
        GetTextureHandle((m_WindowName $ ".ClassBgMain_Small") $ string(targetType)).SetTexture(bgTexture);
        GetTextureHandle((m_WindowName $ ".ClassMarkSmall") $ string(targetType)).SetTexture(markTextureStr);
        GetTextureHandle((m_WindowName $ ".ClassMarkSmall") $ string(targetType)).ShowWindow();
        // End:0x20C
        if(effectFlag == true)
        {
            effectAniTexture(targetType);
        }
    }
    return;
}

function HandleToggle()
{
    // End:0x15
    if(getInstanceUIData().getIsClassicServer())
    {
        return;
    }
    // End:0x39
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
    local int __var17104;

    // End:0x46
    if(m_hOwnerWnd.IsShowWindow())
    {
        ParseInt(param, "ServerID", __var17104);
        // End:0x46
        if(m_UserID == __var17104)
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
    // End:0xB2
    if(int(MoveType) == 2)
    {
        MovingSpeed = float(a_UserInfo.nGroundMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
        switch(EnvType)
        {
            // End:0x83
            case 2:
                MovingSpeed = float(a_UserInfo.nWaterMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
                // End:0xAF
                break;
            // End:0xA9
            case 3:
                MovingSpeed = float(a_UserInfo.nAirMaxSpeed) * a_UserInfo.fNonAttackSpeedModifier;
                // End:0xAF
                break;
            // End:0xFFFF
            default:
                // End:0xAF
                break;
                break;
        }        
    }
    else
    {
        // End:0x136
        if(int(MoveType) == 1)
        {
            MovingSpeed = float(a_UserInfo.nGroundMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
            switch(EnvType)
            {
                // End:0x10A
                case 2:
                    MovingSpeed = float(a_UserInfo.nWaterMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
                    // End:0x136
                    break;
                // End:0x130
                case 3:
                    MovingSpeed = float(a_UserInfo.nAirMinSpeed) * a_UserInfo.fNonAttackSpeedModifier;
                    // End:0x136
                    break;
                // End:0xFFFF
                default:
                    // End:0x136
                    break;
                    break;
            }
        }
    }
    return string(int(MovingSpeed));
    return;
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

    // End:0xEC
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
                // End:0xEC
                break;
            // End:0xA3
            case 1:
                CurValue = Info.nCurMP;
                MaxValue = Info.nMaxMP;
                UpdateMPBar(CurValue, MaxValue);
                // End:0xEC
                break;
            // End:0xE6
            case 2:
                CurValue = Info.nCurCP;
                MaxValue = Info.nMaxCP;
                UpdateCPBar(CurValue, MaxValue);
                // End:0xEC
                break;
                UpdateVp(vitality);
            // End:0xFFFF
            default:
                // End:0xEC
                break;
                break;
        }
    }
    return;
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

function setSubjobSlot(bool isEr)
{
    local Rect rectWnd;

    rectWnd = m_hOwnerWnd.GetRect();
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
    local int DualCount, PKCount, PvPPoint, Sociality, RemainSulffrage, RaidPoint,
	    AttrAttackType, AttrAttackValue, AttrDefenseValFire, AttrDefenseValWater, AttrDefenseValWind,
	    AttrDefenseValEarth, AttrDefenseValHoly, AttrDefenseValUnholy;

    local string AttrAttackTypeTxt;
    local int nMagicAvoid, nMagicHitRate, nMagicCriticalRate;
    local bool m_bPawnChanged;
    local UserInfo Info;
    local int vitality;

    texPledgeCrest.SetTexture("");
    rectWnd = m_hOwnerWnd.GetRect();
    // End:0x499
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
        PvPPoint = Info.PvPPoint;
        Sociality = Info.nSociality;
        RemainSulffrage = Info.nRemainSulffrage;
        RaidPoint = Info.RaidPoint;
        vitality = Info.nVitality;
        AttrAttackType = Info.AttrAttackType;
        AttrAttackValue = Info.AttrAttackValue;
        AttrDefenseValFire = Info.AttrDefenseValFire;
        AttrDefenseValWater = Info.AttrDefenseValWater;
        AttrDefenseValWind = Info.AttrDefenseValWind;
        AttrDefenseValEarth = Info.AttrDefenseValEarth;
        AttrDefenseValHoly = Info.AttrDefenseValHoly;
        AttrDefenseValUnholy = Info.AttrDefenseValUnholy;
        m_bPawnChanged = Info.m_bPawnChanged;
        nMagicAvoid = Info.nMagicAvoid;
        nMagicHitRate = Info.nMagicHitRate;
        nMagicCriticalRate = Info.nMagicCriticalRate;
        switch(AttrAttackType)
        {
            // End:0x3E0
            case -2:
                AttrAttackTypeTxt = GetSystemString(27);
                // End:0x47A
                break;
            // End:0x3F8
            case 0:
                AttrAttackTypeTxt = GetSystemString(1630);
                // End:0x47A
                break;
            // End:0x410
            case 1:
                AttrAttackTypeTxt = GetSystemString(1631);
                // End:0x47A
                break;
            // End:0x429
            case 2:
                AttrAttackTypeTxt = GetSystemString(1632);
                // End:0x47A
                break;
            // End:0x442
            case 3:
                AttrAttackTypeTxt = GetSystemString(1633);
                // End:0x47A
                break;
            // End:0x45B
            case 4:
                AttrAttackTypeTxt = GetSystemString(1634);
                // End:0x47A
                break;
            // End:0x474
            case 5:
                AttrAttackTypeTxt = GetSystemString(1635);
                // End:0x47A
                break;
            // End:0xFFFF
            default:
                // End:0x47A
                break;
                break;
        }
        UpdateVp(vitality);
        setSubjobSlot(Info.Race == 6);
    }
    // End:0x52D
    if(CriminalRate > 0)
    {
        iNameColorRate = Min(100 + (CriminalRate / 100), 255);
        NameColor.R = 0;
        NameColor.G = byte(iNameColorRate);
        NameColor.B = 0;
        NameColor.A = byte(255);
        // End:0x51D
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
        // End:0x5C3
        if(CriminalRate < 0)
        {
            iNameColorRate = Min(100 + (-CriminalRate / 100), 255);
            NameColor.R = byte(iNameColorRate);
            NameColor.G = 0;
            NameColor.B = 0;
            NameColor.A = byte(255);
            // End:0x5B3
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
    // End:0x743
    if(Len(nickname) > 0)
    {
        GetTextSizeDefault(Name, Width1, Height1);
        GetTextSizeDefault(nickname, Width2, Height2);
        // End:0x6BA
        if((Width1 + Width2) > 220)
        {
            // End:0x68A
            if(Width1 > 109)
            {
                Name = Left(Name, 8);
                GetTextSizeDefault(Name, Width1, Height1);
            }
            // End:0x6BA
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
    // End:0x7D8
    if(getInstanceL2Util().getIsPrologueGrowType(SubClassID))
    {
        // End:0x7C2
        if(int(GetLanguage()) == 0)
        {
            txtLvName.SetText("ï¿½ï¿½");            
        }
        else
        {
            txtLvName.SetText("--");
        }        
    }
    else
    {
        txtLvName.SetText("" $ string(Level));
    }
    txtClassName.SetText(ClassName);
    txtSP.SetText((SP));
    // End:0x89A
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
    // End:0x95A
    if(bPledgeCrestTexture)
    {
        texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
        txtPledge.MoveTo(rectWnd.nX + 110, rectWnd.nY + 57);        
    }
    else
    {
        txtPledge.MoveTo(rectWnd.nX + 86, rectWnd.nY + 57);
    }
    // End:0x9C1
    if(bHero)
    {
        HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_heroicon";        
    }
    else
    {
        // End:0xA00
        if(nNobless == 1)
        {
            HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_nobleicon";            
        }
        else
        {
            // End:0xA3E
            if(nNobless == 2)
            {
                HeroTexture = "L2UI_CH3.PlayerStatusWnd.myinfo_nobleicon2";
            }
        }
    }
    texHero.SetTexture(HeroTexture);
    // End:0xA8B
    if(m_HennaInfo.STRchange > 0)
    {
        strTmp = ((string(nStr) $ "(+") $ string(m_HennaInfo.STRchange)) $ ")";        
    }
    else
    {
        // End:0xAC3
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
    // End:0xB1D
    if(m_HennaInfo.DEXchange > 0)
    {
        strTmp = ((string(nDex) $ "(+") $ string(m_HennaInfo.DEXchange)) $ ")";        
    }
    else
    {
        // End:0xB55
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
    // End:0xBAF
    if(m_HennaInfo.CONchange > 0)
    {
        strTmp = ((string(nCon) $ "(+") $ string(m_HennaInfo.CONchange)) $ ")";        
    }
    else
    {
        // End:0xBE7
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
    // End:0xC41
    if(m_HennaInfo.INTchange > 0)
    {
        strTmp = ((string(nInt) $ "(+") $ string(m_HennaInfo.INTchange)) $ ")";        
    }
    else
    {
        // End:0xC79
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
    // End:0xCD3
    if(m_HennaInfo.WITchange > 0)
    {
        strTmp = ((string(nWit) $ "(+") $ string(m_HennaInfo.WITchange)) $ ")";        
    }
    else
    {
        // End:0xD0B
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
    // End:0xD65
    if(m_HennaInfo.MENchange > 0)
    {
        strTmp = ((string(nMen) $ "(+") $ string(m_HennaInfo.MENchange)) $ ")";        
    }
    else
    {
        // End:0xD9D
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
    // End:0xDF7
    if(m_HennaInfo.LUCchange > 0)
    {
        strTmp = ((string(nLuc) $ "(+") $ string(m_HennaInfo.LUCchange)) $ ")";        
    }
    else
    {
        // End:0xE2F
        if(m_HennaInfo.LUCchange < 0)
        {
            strTmp = ((string(nLuc) $ "(") $ string(m_HennaInfo.LUCchange)) $ ")";            
        }
        else
        {
            strTmp = string(nLuc);
        }
    }
    txtLUC.SetText(strTmp);
    // End:0xE89
    if(m_HennaInfo.CHAchange > 0)
    {
        strTmp = ((string(nCha) $ "(+") $ string(m_HennaInfo.CHAchange)) $ ")";        
    }
    else
    {
        // End:0xEC1
        if(m_HennaInfo.CHAchange < 0)
        {
            strTmp = ((string(nCha) $ "(") $ string(m_HennaInfo.CHAchange)) $ ")";            
        }
        else
        {
            strTmp = string(nCha);
        }
    }
    txtCHA.SetText(strTmp);
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
    txtPVP.SetText(string(PvPPoint));
    txtSociality.SetText((string(DualCount) $ " / ") $ string(PKCount));
    txtRemainSulffrage.SetText((string(Sociality) $ " / ") $ string(RemainSulffrage));
    txtRaidPoint.SetText(string(RaidPoint));
    // End:0x114A
    if(Class'Interface.ReleaseGate'.static.RankingEnabled())
    {
        txtItemScore.SetText(string(nMagicHitRate));
        txtItemScore.SetTextColor(GetGearScoreTierColor((nMagicHitRate)));        
    }
    else
    {
        txtItemScore.HideWindow();
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".ItemScoreBg");
    }
    UpdateHPBar(hp, MaxHP);
    UpdateMPBar(mp, maxMP);
    UpdateCPBar(cp, maxCP);
    UpdateEXPBar(Info.fExpPercentRate);
    txtAttrAttackType.SetText("" $ AttrAttackTypeTxt);
    txtAttrAttackValue.SetText("" $ string(AttrAttackValue));
    txtAttrDefenseValFire.SetText("" $ string(AttrDefenseValFire));
    txtAttrDefenseValWater.SetText("" $ string(AttrDefenseValWater));
    txtAttrDefenseValWind.SetText("" $ string(AttrDefenseValWind));
    txtAttrDefenseValEarth.SetText("" $ string(AttrDefenseValEarth));
    txtAttrDefenseValHoly.SetText("" $ string(AttrDefenseValHoly));
    txtAttrDefenseValUnholy.SetText("" $ string(AttrDefenseValUnholy));
    // End:0x1297
    if(m_bPawnChanged)
    {        
    }
    else
    {
        RunUnTransformManage();
    }
    handleAbilityBtn(Level >= 85, Info.nRemainAbilityPoint);
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
            // End:0xA1
            break;
        // End:0x9B
        case false:
            m_hOwnerWnd.ShowWindow();
            m_hOwnerWnd.SetFocus();
            PlaySound("InterfaceSound.charstat_open_01");
            // End:0xA1
            break;
        // End:0xFFFF
        default:
            // End:0xA1
            break;
            break;
    }
    return;
}

function HandleVitalityPointInfo(string param)
{
    local int nVitality;

    ParseInt(param, "Vitality", nVitality);
    UpdateVp(nVitality);
    return;
}

function HandleVitalityEffectInfo(string param)
{
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
            // End:0xA7
            break;
        // End:0x2D
        case 1:
            returnV = "elf";
            // End:0xA7
            break;
        // End:0x44
        case 2:
            returnV = "darkelf";
            // End:0xA7
            break;
        // End:0x57
        case 3:
            returnV = "orc";
            // End:0xA7
            break;
        // End:0x6C
        case 4:
            returnV = "dwarf";
            // End:0xA7
            break;
        // End:0x82
        case 5:
            returnV = "kamael";
            // End:0xA7
            break;
        // End:0x99
        case 6:
            returnV = "Ertheia";
            // End:0xA7
            break;
        // End:0xFFFF
        default:
            returnV = "";
            // End:0xA7
            break;
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
    m_WindowName="DetailStatusWnd"
}