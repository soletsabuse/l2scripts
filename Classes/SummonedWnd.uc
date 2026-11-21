class SummonedWnd extends UICommonAPI;

const summonMaxNum = 4;
const summonpintMinPoint = 2;

struct summonedSlot
{
    var string Name;
    var int ServerID;
    var int ClassID;
    var int Level;
};

var WindowHandle Me;
var WindowHandle SummonedWnd_Status;
var TextBoxHandle txtLvHead;
var TextBoxHandle txtLvName;
var TextBoxHandle txtHeadFight;
var TextBoxHandle txtHeadPhysicalAttack;
var TextBoxHandle txtHeadPhysicalDefense;
var TextBoxHandle txtHeadHitRate;
var TextBoxHandle txtHeadPhysicalAvoid;
var TextBoxHandle txtHeadCriticalRate;
var TextBoxHandle txtHeadPhysicalAttackSpeed;
var TextBoxHandle txtHeadMovingSpeed;
var TextBoxHandle txtHeadSoulShot;
var TextBoxHandle txtHeadMagicalAttack;
var TextBoxHandle txtHeadMagicDefense;
var TextBoxHandle txtHeadMagicHit;
var TextBoxHandle txtHeadMagicAvoid;
var TextBoxHandle txtHeadMagicCritical;
var TextBoxHandle txtHeadMagicCastingSpeed;
var TextBoxHandle txtHeadSoulShotCosume1;
var TextBoxHandle txtHeadSoulShotCosume2;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtMagicHit;
var TextBoxHandle txtMagicAvoid;
var TextBoxHandle txtMagicCritical;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSoulShotCosume1;
var TextBoxHandle txtSoulShotCosume2;
var TextureHandle BackTex1;
var TextureHandle BackTex2;
var TextureHandle BackTex3;
var TextureHandle DividerLine;
var TextureHandle DividerLine2;
var TextureHandle SummonedFace;
var TextureHandle SummonedSlotOutline;
var WindowHandle SummonedWnd_Action;
var WindowHandle SummonedWnd_Action1;
var ItemWindowHandle SummonedActionWnd_Before;
var TextureHandle BackTexAction1_Before;
var WindowHandle SummonedWnd_Action2;
var TextBoxHandle txtHeadDirect;
var TextBoxHandle txtHeadPolicy;
var TextBoxHandle txtHeadSkill;
var ItemWindowHandle SummonedActionWnd;
var ItemWindowHandle SummonedActionWnd2;
var ItemWindowHandle SummonedActionWnd3;
var TextureHandle BackTexAction1;
var TextureHandle BackTexAction2;
var TextureHandle BackTexAction3;
var BarHandle barHP_1;
var BarHandle barHP_2;
var BarHandle barHP_3;
var BarHandle barHP_4;
var BarHandle barMP_1;
var BarHandle barMP_2;
var BarHandle barMP_3;
var BarHandle barMP_4;
var StatusBarHandle barSummonPoint;
var TextureHandle SummonedGroupBox1;
var TextureHandle SummonedGroupBox2;
var TextureHandle SummonedGroupBox3;
var TextureHandle SummonedGroupBox4;
var TextureHandle SummonedGroupBox5;
var TextureHandle SummonedSlotNone1;
var TextureHandle SummonedSlotNone2;
var TextureHandle SummonedSlotNone3;
var TextureHandle SummonedSlotNone4;
var TextureHandle SummonedSlotBlank1;
var TextureHandle SummonedSlotBlank2;
var TextureHandle SummonedSlotBlank3;
var TextureHandle SummonedSlotBlank4;
var TextureHandle SummonedFace1;
var TextureHandle SummonedFace2;
var TextureHandle SummonedFace3;
var TextureHandle SummonedFace4;
var TextureHandle SummonedSlotOutline1;
var TextureHandle SummonedSlotOutline2;
var TextureHandle SummonedSlotOutline3;
var TextureHandle SummonedSlotOutline4;
var ButtonHandle btnBar_1;
var ButtonHandle btnBar_2;
var ButtonHandle btnBar_3;
var ButtonHandle btnBar_4;
var TextBoxHandle txtHeadSummonPoint;
var TabHandle TabCtrl;
var TextureHandle TabLineTop;
var TextureHandle tabBg1;
var L2Util util;
var int summonServerID;
var bool bAwakeStateFlag;
var int selectedSlotIndex;
var summonedSlot summonedSlotArray[4];
var int currentSummonPolicy;

function OnRegisterEvent()
{
    RegisterEvent(251);
    RegisterEvent(1090);
    RegisterEvent(1131);
    RegisterEvent(1311);
    RegisterEvent(1340);
    RegisterEvent(1350);
    RegisterEvent(1120);
    RegisterEvent(1900);
    RegisterEvent(9140);
    RegisterEvent(40);
    RegisterEvent(980);
    RegisterEvent(1351);
    RegisterEvent(1352);
    RegisterEvent(1132);
    RegisterEvent(190);
    RegisterEvent(210);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int ServerID, currentHP, currentMP, SlotIndex;

    // End:0x0E
    if(DebugConditions(Event_ID))
    {
    }
    // End:0x26
    if(Event_ID == 980)
    {
        HandleTargetUpdate();        
    }
    else
    {
        // End:0x38
        if(Event_ID == 9140)
        {            
        }
        else
        {
            // End:0x4A
            if(Event_ID == 1351)
            {                
            }
            else
            {
                // End:0x5C
                if(Event_ID == 1340)
                {                    
                }
                else
                {
                    // End:0x79
                    if(Event_ID == 1352)
                    {
                        HandleActionSummonedList(param);                        
                    }
                    else
                    {
                        // End:0x96
                        if(Event_ID == 1350)
                        {
                            HandleActionSummonedList(param);                            
                        }
                        else
                        {
                            // End:0xEF
                            if(Event_ID == 251)
                            {
                                // End:0xBC
                                if(GetGameStateName() != "GAMINGSTATE")
                                {
                                    return;
                                }
                                ParseInt(param, "ServerID", ServerID);
                                // End:0xEC
                                if(ServerID != 0)
                                {
                                    HandleSummonInfoUpdate(ServerID);
                                }                                
                            }
                            else
                            {
                                // End:0x175
                                if(Event_ID == 190)
                                {
                                    ParseInt(param, "ServerID", ServerID);
                                    ParseInt(param, "CurrentHP", currentHP);
                                    // End:0x172
                                    if(ServerID != 0)
                                    {
                                        SlotIndex = GetIsSummonedSlotIndex(ServerID);
                                        // End:0x15D
                                        if(SlotIndex == -1)
                                        {
                                            return;
                                        }
                                        setStatusBarHP(SlotIndex, currentHP, ServerID);
                                    }                                    
                                }
                                else
                                {
                                    // End:0x1FB
                                    if(Event_ID == 210)
                                    {
                                        ParseInt(param, "ServerID", ServerID);
                                        ParseInt(param, "CurrentMP", currentMP);
                                        // End:0x1F8
                                        if(ServerID != 0)
                                        {
                                            SlotIndex = GetIsSummonedSlotIndex(ServerID);
                                            // End:0x1E3
                                            if(SlotIndex == -1)
                                            {
                                                return;
                                            }
                                            setStatusBarMP(SlotIndex, currentMP, ServerID);
                                        }                                        
                                    }
                                    else
                                    {
                                        // End:0x20D
                                        if(Event_ID == 1120)
                                        {                                            
                                        }
                                        else
                                        {
                                            // End:0x225
                                            if(Event_ID == 1131)
                                            {
                                                HandleSummonedStatusClose();                                                
                                            }
                                            else
                                            {
                                                // End:0x23D
                                                if(Event_ID == 1090)
                                                {
                                                    HandleSummonShow();                                                    
                                                }
                                                else
                                                {
                                                    // End:0x24F
                                                    if(Event_ID == 1900)
                                                    {                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x261
                                                        if(Event_ID == 1311)
                                                        {                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x276
                                                            if(Event_ID == 40)
                                                            {
                                                                Restart();                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x290
                                                                if(Event_ID == 1132)
                                                                {
                                                                    HandleSummonedDelete(param);
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

function OnLoad()
{
    local int i;

    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    util = L2Util(GetScript("L2Util"));
    Initialize();
    currentSummonPolicy = -1;
    i = 1;
    J0x44:

    // End:0xEE [Loop If]
    if(i <= 4)
    {
        GetTextureHandle("SummonedWnd.SummonedSlotOutline" $ string(i)).HideWindow();
        GetBarHandle("SummonedWnd.barHP_" $ string(i)).HideWindow();
        GetBarHandle("SummonedWnd.barMP_" $ string(i)).HideWindow();
        i++;
        // [Loop Continue]
        goto J0x44;
    }
    txtHeadSoulShotCosume1.SetText(GetSystemString(404));
    txtHeadSoulShotCosume2.SetText(GetSystemString(496));
    return;
}

function Initialize()
{
    Me = GetWindowHandle("SummonedWnd");
    SummonedWnd_Status = GetWindowHandle("SummonedWnd.SummonedWnd_Status");
    txtLvHead = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtLvHead");
    txtLvName = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtLvName");
    txtHeadFight = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadFight");
    txtHeadPhysicalAttack = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadPhysicalAttack");
    txtHeadPhysicalDefense = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadPhysicalDefense");
    txtHeadHitRate = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadHitRate");
    txtHeadPhysicalAvoid = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadPhysicalAvoid");
    txtHeadCriticalRate = GetTextBoxHandle("SummonedWnd.1.txtHeadCriticalRate");
    txtHeadPhysicalAttackSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadPhysicalAttackSpeed");
    txtHeadMovingSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMovingSpeed");
    txtHeadSoulShot = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadSoulShot");
    txtHeadMagicalAttack = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicalAttack");
    txtHeadMagicDefense = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicDefense");
    txtHeadMagicHit = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicHit");
    txtHeadMagicAvoid = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicAvoid");
    txtHeadMagicCritical = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicCritical");
    txtHeadMagicCastingSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadMagicCastingSpeed");
    txtHeadSoulShotCosume1 = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadSoulShotCosume1");
    txtHeadSoulShotCosume2 = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHeadSoulShotCosume2");
    txtPhysicalAttack = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtPhysicalAttack");
    txtPhysicalDefense = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtPhysicalDefense");
    txtHitRate = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtHitRate");
    txtPhysicalAvoid = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtPhysicalAvoid");
    txtCriticalRate = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtCriticalRate");
    txtPhysicalAttackSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtPhysicalAttackSpeed");
    txtMovingSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMovingSpeed");
    txtMagicalAttack = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicalAttack");
    txtMagicDefense = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicDefense");
    txtMagicHit = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicHit");
    txtMagicAvoid = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicAvoid");
    txtMagicCritical = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicCritical");
    txtMagicCastingSpeed = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtMagicCastingSpeed");
    txtSoulShotCosume1 = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtSoulShotCosume1");
    txtSoulShotCosume2 = GetTextBoxHandle("SummonedWnd.SummonedWnd_Status.txtSoulShotCosume2");
    BackTex1 = GetTextureHandle("SummonedWnd.SummonedWnd_Status.BackTex1");
    BackTex2 = GetTextureHandle("SummonedWnd.SummonedWnd_Status.BackTex2");
    BackTex3 = GetTextureHandle("SummonedWnd.SummonedWnd_Status.BackTex3");
    DividerLine = GetTextureHandle("SummonedWnd.SummonedWnd_Status.DividerLine");
    DividerLine2 = GetTextureHandle("SummonedWnd.SummonedWnd_Status.DividerLine2");
    SummonedFace = GetTextureHandle("SummonedWnd.SummonedWnd_Status.SummonedFace");
    SummonedSlotOutline = GetTextureHandle("SummonedWnd.SummonedWnd_Status.SummonedSlotOutline");
    SummonedWnd_Action = GetWindowHandle("SummonedWnd.SummonedWnd_Action");
    SummonedWnd_Action1 = GetWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action1");
    BackTexAction1_Before = GetTextureHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action1.BackTexAction1_Before");
    SummonedWnd_Action2 = GetWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2");
    txtHeadDirect = GetTextBoxHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.txtHeadDirect");
    txtHeadPolicy = GetTextBoxHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.txtHeadPolicy");
    txtHeadSkill = GetTextBoxHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.txtHeadSkill");
    SummonedActionWnd_Before = GetItemWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action1.SummonedActionWnd_Before");
    SummonedActionWnd = GetItemWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd");
    SummonedActionWnd2 = GetItemWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd2");
    SummonedActionWnd3 = GetItemWindowHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd3");
    BackTexAction1 = GetTextureHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction1");
    BackTexAction2 = GetTextureHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction2");
    BackTexAction3 = GetTextureHandle("SummonedWnd.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction3");
    barHP_1 = GetBarHandle("SummonedWnd.barHP_1");
    barHP_2 = GetBarHandle("SummonedWnd.barHP_2");
    barHP_3 = GetBarHandle("SummonedWnd.barHP_3");
    barHP_4 = GetBarHandle("SummonedWnd.barHP_4");
    barMP_1 = GetBarHandle("SummonedWnd.barMP_1");
    barMP_2 = GetBarHandle("SummonedWnd.barMP_2");
    barMP_3 = GetBarHandle("SummonedWnd.barMP_3");
    barMP_4 = GetBarHandle("SummonedWnd.barMP_4");
    SummonedGroupBox1 = GetTextureHandle("SummonedWnd.SummonedGroupBox1");
    SummonedGroupBox2 = GetTextureHandle("SummonedWnd.SummonedGroupBox2");
    SummonedGroupBox3 = GetTextureHandle("SummonedWnd.SummonedGroupBox3");
    SummonedGroupBox4 = GetTextureHandle("SummonedWnd.SummonedGroupBox4");
    SummonedGroupBox5 = GetTextureHandle("SummonedWnd.SummonedGroupBox5");
    SummonedSlotNone1 = GetTextureHandle("SummonedWnd.SummonedSlotNone1");
    SummonedSlotNone2 = GetTextureHandle("SummonedWnd.SummonedSlotNone2");
    SummonedSlotNone3 = GetTextureHandle("SummonedWnd.SummonedSlotNone3");
    SummonedSlotNone4 = GetTextureHandle("SummonedWnd.SummonedSlotNone4");
    SummonedSlotBlank1 = GetTextureHandle("SummonedWnd.SummonedSlotBlank1");
    SummonedSlotBlank2 = GetTextureHandle("SummonedWnd.SummonedSlotBlank2");
    SummonedSlotBlank3 = GetTextureHandle("SummonedWnd.SummonedSlotBlank3");
    SummonedSlotBlank4 = GetTextureHandle("SummonedWnd.SummonedSlotBlank4");
    SummonedFace1 = GetTextureHandle("SummonedWnd.SummonedFace1");
    SummonedFace2 = GetTextureHandle("SummonedWnd.SummonedFace2");
    SummonedFace3 = GetTextureHandle("SummonedWnd.SummonedFace3");
    SummonedFace4 = GetTextureHandle("SummonedWnd.SummonedFace4");
    SummonedSlotOutline1 = GetTextureHandle("SummonedWnd.SummonedSlotOutline1");
    SummonedSlotOutline2 = GetTextureHandle("SummonedWnd.SummonedSlotOutline2");
    SummonedSlotOutline3 = GetTextureHandle("SummonedWnd.SummonedSlotOutline3");
    SummonedSlotOutline4 = GetTextureHandle("SummonedWnd.SummonedSlotOutline4");
    btnBar_1 = GetButtonHandle("SummonedWnd.btnBar_1");
    btnBar_2 = GetButtonHandle("SummonedWnd.btnBar_2");
    btnBar_3 = GetButtonHandle("SummonedWnd.btnBar_3");
    btnBar_4 = GetButtonHandle("SummonedWnd.btnBar_4");
    txtHeadSummonPoint = GetTextBoxHandle("SummonedWnd.txtHeadSummonPoint");
    TabCtrl = GetTabHandle("SummonedWnd.TabCtrl");
    TabLineTop = GetTextureHandle("SummonedWnd.TabLineTop");
    tabBg1 = GetTextureHandle("SummonedWnd.tabBg1");
    barSummonPoint = GetStatusBarHandle("SummonedWnd.barSummonPoint");
    bAwakeStateFlag = false;
    initSlot();
    return;
}

function initSlot()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x97 [Loop If]
    if(i < 4)
    {
        summonedSlotArray[i].ServerID = -1;
        GetBarHandle("SummonedWnd.barHP_" $ string(i + 1)).SetValue(0, 0);
        GetBarHandle("SummonedWnd.barMP_" $ string(i + 1)).SetValue(0, 0);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnShow()
{
    return;
}

function bool DebugConditions(int Event_ID)
{
    local array<int> conditoins;
    local int i;

    conditoins[0] = 1120;
    conditoins[1] = 1350;
    i = 0;
    J0x21:

    // End:0x52 [Loop If]
    if(i < conditoins.Length)
    {
        // End:0x48
        if(conditoins[i] == Event_ID)
        {
            return false;
        }
        i++;
        // [Loop Continue]
        goto J0x21;
    }
    return true;
    return;
}

function Restart()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x33 [Loop If]
    if(i < 4)
    {
        summonedSlotArray[i].ServerID = -1;
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo infItem;

    // End:0x1B4
    if(Index > -1)
    {
        switch(strID)
        {
            // End:0x62
            case "SummonedActionWnd_Before":
                // End:0x5F
                if(SummonedActionWnd_Before.GetItem(Index, infItem))
                {
                    DoAction(infItem.Id);
                }
                // End:0x1B4
                break;
            // End:0xA7
            case "SummonedActionWnd":
                // End:0xA4
                if(SummonedActionWnd.GetItem(Index, infItem))
                {
                    DoAction(infItem.Id);
                }
                // End:0x1B4
                break;
            // End:0x16B
            case "SummonedActionWnd2":
                // End:0x168
                if(SummonedActionWnd2.GetItem(Index, infItem))
                {
                    Debug("index" @ string(Index));
                    Debug("currentSummonPolicy" @ string(currentSummonPolicy));
                    // End:0x168
                    if(Index != currentSummonPolicy)
                    {
                        SummonedActionWnd2.SetToggleEffect(Index, true);
                        SummonedActionWnd2.SetToggleEffect(currentSummonPolicy, false);
                        currentSummonPolicy = Index;
                        DoAction(infItem.Id);
                    }
                }
                // End:0x1B4
                break;
            // End:0x1B1
            case "SummonedActionWnd3":
                // End:0x1AE
                if(SummonedActionWnd3.GetItem(Index, infItem))
                {
                    DoAction(infItem.Id);
                }
                // End:0x1B4
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

function HandleTargetUpdate()
{
    local int ServerID;

    ServerID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
    // End:0x40
    if((GetIsSummonedSlotIndex(ServerID)) != -1)
    {
        setInformation(ServerID);
        setbtnBarSelection(ServerID);
    }
    return;
}

function setTargetSummon(int Num)
{
    local UserInfo UserInfo;
    local int ServerID;

    ServerID = summonedSlotArray[Num].ServerID;
    // End:0x48
    if(ServerID != -1)
    {
        // End:0x48
        if(GetPlayerInfo(UserInfo))
        {
            RequestAction(ServerID, UserInfo.loc);
        }
    }
    return;
}

function HandleSummonedStatusClose()
{
    local int usedSummonPoint, SummonablePoint, i;

    PlayConsoleSound(6);
    Me.HideWindow();
    i = 0;
    J0x1E:

    // End:0x3F [Loop If]
    if(i < 4)
    {
        deleteSlotbyIndex(i);
        i++;
        // [Loop Continue]
        goto J0x1E;
    }
    GetSummonPoint(usedSummonPoint, SummonablePoint);
    barSummonPoint.SetPoint(SummonablePoint - usedSummonPoint, SummonablePoint);
    ClearActionWnd();
    setInformation(-1);
    setbtnBarSelection(-1);
    currentSummonPolicy = -1;
    return;
}

function HandleSummonShow()
{
    PlayConsoleSound(5);
    // End:0x3B
    if(!getInstanceUIData().getIsClassicServer())
    {
        Me.ShowWindow();
        Me.SetFocus();
    }
    return;
}

function HandleSummonedDelete(string param)
{
    local int ServerID, SlotIndex, nextSlotIndex, usedSummonPoint, SummonablePoint;

    ParseInt(param, "serverID", ServerID);
    // End:0xE0
    if(bAwakeStateFlag)
    {
        SlotIndex = GetIsSummonedSlotIndex(ServerID);
        nextSlotIndex = getNextSummonedSlotIndex(SlotIndex);
        // End:0xE0
        if(nextSlotIndex != -1)
        {
            SummonedActionWnd3.Clear();
            Class'NWindow.ActionAPI'.static.RequestSummonedAllSkillActionList();
            setInformation(summonedSlotArray[nextSlotIndex].ServerID);
            setbtnBarSelection(summonedSlotArray[nextSlotIndex].ServerID);
            GetSummonPoint(usedSummonPoint, SummonablePoint);
            barSummonPoint.SetPoint(SummonablePoint - usedSummonPoint, SummonablePoint);
            deleteSlotbyIndex(SlotIndex);
            setSummonedSlotNone(false);
        }
    }
    return;
}

function bool isLock()
{
    local int usedSummonPoint, SummonablePoint;

    GetSummonPoint(usedSummonPoint, SummonablePoint);
    // End:0x32
    if(((SummonablePoint - usedSummonPoint) < 2) || usedSummonPoint == 0)
    {
        return true;
    }
    return false;
    return;
}

function setSummonedSlotNone(bool Lock)
{
    local string hidePath, showPath;
    local int i;

    // End:0x55
    if(Lock)
    {
        hidePath = "SummonedWnd.SummonedSlotBlank";
        showPath = "SummonedWnd.SummonedSlotNone";        
    }
    else
    {
        hidePath = "SummonedWnd.SummonedSlotNone";
        showPath = "SummonedWnd.SummonedSlotBlank";
    }
    i = 1;
    J0xA5:

    // End:0xF7 [Loop If]
    if(i <= 4)
    {
        GetTextureHandle(hidePath $ string(i)).HideWindow();
        GetTextureHandle(showPath $ string(i)).ShowWindow();
        i++;
        // [Loop Continue]
        goto J0xA5;
    }
    return;
}

function deleteSlotbyIndex(int SlotIndex)
{
    local TextureHandle SummonedFace;

    GetButtonHandle("SummonedWnd.btnBar_" $ string(SlotIndex + 1)).ClearTooltip();
    summonedSlotArray[SlotIndex].ServerID = -1;
    SummonedFace = GetTextureHandle("SummonedWnd.SummonedFace" $ string(SlotIndex + 1));
    SummonedFace.SetTexture("");
    GetTextureHandle("SummonedWnd.SummonedSlotOutline" $ string(SlotIndex + 1)).HideWindow();
    GetBarHandle("SummonedWnd.barHP_" $ string(SlotIndex + 1)).HideWindow();
    GetBarHandle("SummonedWnd.barMP_" $ string(SlotIndex + 1)).HideWindow();
    return;
}

function HandleSummonInfoUpdate(int ServerID)
{
    local int hp, MaxHP, mp, maxMP, ClassID;

    local string Name;
    local int Level, SummonablePoint, usedSummonPoint;
    local SummonInfo Info;
    local int SlotIndex;
    local TextureHandle SummonedFace;

    // End:0x319
    if(GetSummonInfo(ServerID, Info))
    {
        ClassID = Info.nClassID;
        Name = Info.Name;
        Level = Info.nLevel;
        hp = Info.nCurHP;
        MaxHP = Info.nMaxHP;
        mp = Info.nCurMP;
        maxMP = Info.nMaxMP;
        // End:0x90
        if(ClassID <= 0)
        {
            return;
        }
        SlotIndex = GetIsSummonedSlotIndex(ServerID);
        // End:0x1FA
        if(SlotIndex == -1)
        {
            SlotIndex = getSummonedSlotIndex();
            SummonedFace = GetTextureHandle("SummonedWnd.SummonedFace" $ string(SlotIndex + 1));
            SummonedFace.SetTexture(Class'NWindow.UIDATA_NPC'.static.GetNPCIconName(ClassID));
            SummonedFace.SetTextureSize(32, 32);
            GetTextureHandle("SummonedWnd.SummonedSlotOutline" $ string(SlotIndex + 1)).ShowWindow();
            GetBarHandle("SummonedWnd.barHP_" $ string(SlotIndex + 1)).ShowWindow();
            GetBarHandle("SummonedWnd.barMP_" $ string(SlotIndex + 1)).ShowWindow();
            summonedSlotArray[SlotIndex].ServerID = ServerID;
            Class'NWindow.ActionAPI'.static.RequestSummonedCommonActionList(ServerID);
            Class'NWindow.ActionAPI'.static.RequestSummonedAllSkillActionList();
        }
        // End:0x214
        if(SlotIndex == selectedSlotIndex)
        {
            setInformation(ServerID);
        }
        GetSummonPoint(usedSummonPoint, SummonablePoint);
        barSummonPoint.SetPoint(SummonablePoint - usedSummonPoint, SummonablePoint);
        setSummonedSlotNone(isLock());
        GetBarHandle("SummonedWnd.barHP_" $ string(SlotIndex + 1)).SetValue(MaxHP, hp);
        GetBarHandle("SummonedWnd.barMP_" $ string(SlotIndex + 1)).SetValue(maxMP, mp);
        GetButtonHandle("SummonedWnd.btnBar_" $ string(SlotIndex + 1)).SetTooltipCustomType(setHpMpToolTips(Level, Name, MaxHP, hp, maxMP, mp));
    }
    return;
}

function setStatusBarHP(int SlotIndex, int CurHP, int ServerID)
{
    local SummonInfo Info;
    local string Name;
    local int Level, MaxHP, mp, maxMP;

    // End:0x12C
    if(GetSummonInfo(ServerID, Info))
    {
        MaxHP = Info.nMaxHP;
        maxMP = Info.nMaxMP;
        mp = Info.nCurMP;
        Name = Info.Name;
        Level = Info.nLevel;
        GetBarHandle("SummonedWnd.barHP_" $ string(SlotIndex + 1)).SetValue(MaxHP, CurHP);
        GetBarHandle("SummonedWnd.barMP_" $ string(SlotIndex + 1)).SetValue(maxMP, mp);
        GetButtonHandle("SummonedWnd.btnBar_" $ string(SlotIndex + 1)).SetTooltipCustomType(setHpMpToolTips(Level, Name, MaxHP, CurHP, maxMP, mp));
    }
    return;
}

function setStatusBarMP(int SlotIndex, int curMP, int ServerID)
{
    local SummonInfo Info;
    local string Name;
    local int Level, MaxHP, hp, maxMP;

    // End:0x12C
    if(GetSummonInfo(ServerID, Info))
    {
        MaxHP = Info.nMaxHP;
        maxMP = Info.nMaxMP;
        hp = Info.nCurHP;
        Name = Info.Name;
        Level = Info.nLevel;
        GetBarHandle("SummonedWnd.barHP_" $ string(SlotIndex + 1)).SetValue(MaxHP, hp);
        GetBarHandle("SummonedWnd.barMP_" $ string(SlotIndex + 1)).SetValue(maxMP, curMP);
        GetButtonHandle("SummonedWnd.btnBar_" $ string(SlotIndex + 1)).SetTooltipCustomType(setHpMpToolTips(Level, Name, MaxHP, hp, maxMP, curMP));
    }
    return;
}

function setbtnBarSelection(int ServerID)
{
    local ButtonHandle btnBAr;
    local string btnString_None, btnString_Over, btnString_Down;
    local int SlotIndex, i;

    btnString_None = "L2UI_ct1.Summoned.Summoned_DF_SelectBtn";
    btnString_Over = "L2UI_ct1.Summoned.Summoned_DF_SelectBtn_Over";
    btnString_Down = "L2UI_ct1.Summoned.Summoned_DF_SelectBtn_Down";
    selectedSlotIndex = -1;
    i = 1;
    J0xA9:

    // End:0x107 [Loop If]
    if(i <= 4)
    {
        btnBAr = GetButtonHandle("SummonedWnd.btnBar_" $ string(i));
        btnBAr.SetTexture(btnString_None, btnString_Down, btnString_Over);
        i++;
        // [Loop Continue]
        goto J0xA9;
    }
    // End:0x1AD
    if(ServerID > 0)
    {
        SlotIndex = GetIsSummonedSlotIndex(ServerID);
        btnBAr = GetButtonHandle("SummonedWnd.btnBar_" $ string(SlotIndex + 1));
        btnString_None = "L2UI_ct1.Summoned.Summoned_DF_SelectBtn_Down";
        btnBAr.SetTexture(btnString_None, btnString_Down, btnString_Over);
        selectedSlotIndex = SlotIndex;
    }
    return;
}

function int getNextSummonedSlotIndex(int SlotIndex)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x57 [Loop If]
    if(i < 4)
    {
        SlotIndex++;
        // End:0x2D
        if(SlotIndex == 4)
        {
            SlotIndex = 0;
        }
        // End:0x4D
        if(summonedSlotArray[SlotIndex].ServerID != -1)
        {
            return SlotIndex;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function int getSummonedSlotIndex()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x3D [Loop If]
    if(i < 4)
    {
        // End:0x33
        if(summonedSlotArray[i].ServerID == -1)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function int GetIsSummonedSlotIndex(int ServerID)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x3D [Loop If]
    if(i < 4)
    {
        // End:0x33
        if(summonedSlotArray[i].ServerID == ServerID)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function ClearActionWnd()
{
    SummonedActionWnd.Clear();
    SummonedActionWnd2.Clear();
    SummonedActionWnd3.Clear();
    SummonedActionWnd_Before.Clear();
    return;
}

function HandleActionSummonedList(string param)
{
    local UserInfo UserInfo;
    local int tmpID, tmp;
    local UIEventManager.EActionCategory Type;
    local string strActionName, strIconName, strDescription, strCommand;
    local ItemInfo infItem;
    local int usedSummonPoint, SummonablePoint;

    ParseItemID(param, infItem.Id);
    ParseInt(param, "Type", tmp);
    ParseString(param, "Name", strActionName);
    ParseString(param, "IconName", strIconName);
    ParseString(param, "Description", strDescription);
    ParseString(param, "Command", strCommand);
    infItem.Name = strActionName;
    infItem.IconName = strIconName;
    infItem.Description = strDescription;
    infItem.ItemSubType = int(3);
    infItem.MacroCommand = strCommand;
    infItem.ReuseDelayShareGroupID = -1;
    GetPlayerInfo(UserInfo);
    GetSummonPoint(usedSummonPoint, SummonablePoint);
    // End:0x13F
    if(usedSummonPoint > 0)
    {
        SummonedWnd_Action2.ShowWindow();
        SummonedWnd_Action1.HideWindow();
        bAwakeStateFlag = true;        
    }
    else
    {
        SummonedWnd_Action1.ShowWindow();
        SummonedWnd_Action2.HideWindow();
        bAwakeStateFlag = false;
    }
    Type = byte(tmp);
    // End:0x1CF
    if(bAwakeStateFlag == false)
    {
        tmpID = SummonedActionWnd_Before.FindItem(infItem.Id);
        // End:0x1CC
        if(int(Type) == int(6))
        {
            // End:0x1CC
            if(tmpID < 0)
            {
                SummonedActionWnd_Before.AddItem(infItem);
            }
        }        
    }
    else
    {
        // End:0x220
        if(int(Type) == int(7))
        {
            tmpID = SummonedActionWnd.FindItem(infItem.Id);
            // End:0x21D
            if(tmpID < 0)
            {
                SummonedActionWnd.AddItem(infItem);
            }            
        }
        else
        {
            // End:0x2B4
            if(int(Type) == int(8))
            {
                tmpID = SummonedActionWnd2.FindItem(infItem.Id);
                // End:0x26E
                if(tmpID < 0)
                {
                    SummonedActionWnd2.AddItem(infItem);
                }
                // End:0x2B1
                if(currentSummonPolicy == -1)
                {
                    // End:0x2B1
                    if(SummonedActionWnd2.GetItem(0, infItem))
                    {
                        currentSummonPolicy = 0;
                        SummonedActionWnd2.SetToggleEffect(currentSummonPolicy, true);
                    }
                }                
            }
            else
            {
                // End:0x302
                if(int(Type) == int(10))
                {
                    tmpID = SummonedActionWnd3.FindItem(infItem.Id);
                    // End:0x302
                    if(tmpID < 0)
                    {
                        SummonedActionWnd3.AddItem(infItem);
                    }
                }
            }
        }
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1E
        case "btnBar_1":
            setTargetSummon(0);
            // End:0x68
            break;
        // End:0x35
        case "btnBar_2":
            setTargetSummon(1);
            // End:0x68
            break;
        // End:0x4D
        case "btnBar_3":
            setTargetSummon(2);
            // End:0x68
            break;
        // End:0x65
        case "btnBar_4":
            setTargetSummon(3);
            // End:0x68
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function setInformation(int ServerID)
{
    local string Name;
    local int Level, ClassID, PhysicalAttack, PhysicalDefense, HitRate, CriticalRate,
	    PhysicalAttackSpeed, MagicalAttack, MagicDefense, PhysicalAvoid, MovingSpeed,
	    MagicCastingSpeed, SoulShotCosume, SpiritShotConsume, MagicalHitRate, MagicalAvoid,
	    MagicalCritical;

    local SummonInfo Info;

    // End:0x2D8
    if(GetSummonInfo(ServerID, Info))
    {
        Name = Info.Name;
        Level = Info.nLevel;
        ClassID = Info.nClassID;
        PhysicalAttack = Info.nPhysicalAttack;
        PhysicalDefense = Info.nPhysicalDefense;
        HitRate = Info.nHitRate;
        CriticalRate = Info.nCriticalRate;
        PhysicalAttackSpeed = Info.nPhysicalAttackSpeed;
        MagicalAttack = Info.nMagicalAttack;
        MagicDefense = Info.nMagicDefense;
        PhysicalAvoid = Info.nPhysicalAvoid;
        MovingSpeed = Info.nMovingSpeed;
        MagicCastingSpeed = Info.nMagicCastingSpeed;
        SoulShotCosume = Info.nSoulShotCosume;
        SpiritShotConsume = Info.nSpiritShotConsume;
        MagicalHitRate = Info.nMagicalHitRate;
        MagicalAvoid = Info.nMagicalAvoid;
        MagicalCritical = Info.nMagicalCritical;
        SummonedFace.SetTexture(Class'NWindow.UIDATA_NPC'.static.GetNPCIconName(ClassID));
        SummonedFace.SetTextureSize(32, 32);
        txtLvName.SetText((string(Level) $ " ") $ Name);
        txtPhysicalAttack.SetText(string(PhysicalAttack));
        txtPhysicalDefense.SetText(string(PhysicalDefense));
        txtHitRate.SetText(string(HitRate));
        txtCriticalRate.SetText(string(CriticalRate));
        txtPhysicalAttackSpeed.SetText(string(PhysicalAttackSpeed));
        txtMagicalAttack.SetText(string(MagicalAttack));
        txtMagicDefense.SetText(string(MagicDefense));
        txtPhysicalAvoid.SetText(string(PhysicalAvoid));
        txtMovingSpeed.SetText(string(MovingSpeed));
        txtMagicCastingSpeed.SetText(string(MagicCastingSpeed));
        txtMagicHit.SetText(string(MagicalHitRate));
        txtMagicAvoid.SetText(string(MagicalAvoid));
        txtMagicCritical.SetText(string(MagicalCritical));
        txtSoulShotCosume1.SetText(string(SoulShotCosume));
        txtSoulShotCosume2.SetText(string(SpiritShotConsume));        
    }
    else
    {
        SoulShotCosume = 0;
        SpiritShotConsume = 0;
        txtLvName.SetText("");
        txtPhysicalAttack.SetText("");
        txtPhysicalDefense.SetText("");
        txtHitRate.SetText("");
        txtCriticalRate.SetText("");
        txtPhysicalAttackSpeed.SetText("");
        txtMagicalAttack.SetText("");
        txtMagicDefense.SetText("");
        txtPhysicalAvoid.SetText("");
        txtMovingSpeed.SetText("");
        txtMagicCastingSpeed.SetText("");
        txtSoulShotCosume1.SetText(string(SoulShotCosume));
        txtSoulShotCosume2.SetText(string(SpiritShotConsume));
    }
    return;
}

function CustomTooltip setHpMpToolTips(int Level, string Name, int MaxHP, int currentHP, int maxMP, int currentMP)
{
    local CustomTooltip m_Tooltip;

    m_Tooltip.DrawList.Length = 8;
    m_Tooltip.DrawList[0].t_bDrawOneLine = true;
    m_Tooltip.DrawList[0].eType = 1;
    m_Tooltip.DrawList[0].t_strText = "Lv ";
    m_Tooltip.DrawList[1].t_bDrawOneLine = true;
    m_Tooltip.DrawList[1].eType = 1;
    m_Tooltip.DrawList[1].t_color.R = 175;
    m_Tooltip.DrawList[1].t_color.G = 152;
    m_Tooltip.DrawList[1].t_color.B = 120;
    m_Tooltip.DrawList[1].t_color.A = byte(255);
    m_Tooltip.DrawList[1].t_strText = (string(Level) $ " ") $ Name;
    m_Tooltip.DrawList[2].t_bDrawOneLine = true;
    m_Tooltip.DrawList[2].eType = 1;
    m_Tooltip.DrawList[2].bLineBreak = true;
    m_Tooltip.DrawList[2].t_strText = "HP: ";
    m_Tooltip.DrawList[3].t_bDrawOneLine = true;
    m_Tooltip.DrawList[3].eType = 1;
    m_Tooltip.DrawList[3].t_color.R = 175;
    m_Tooltip.DrawList[3].t_color.G = 152;
    m_Tooltip.DrawList[3].t_color.B = 120;
    m_Tooltip.DrawList[3].t_color.A = byte(255);
    m_Tooltip.DrawList[3].t_strText = string(currentHP);
    m_Tooltip.DrawList[4].t_bDrawOneLine = true;
    m_Tooltip.DrawList[4].eType = 1;
    m_Tooltip.DrawList[4].t_strText = (" / " $ string(MaxHP)) $ "  ";
    m_Tooltip.DrawList[5].eType = 1;
    m_Tooltip.DrawList[5].bLineBreak = true;
    m_Tooltip.DrawList[5].t_strText = "MP: ";
    m_Tooltip.DrawList[6].t_bDrawOneLine = true;
    m_Tooltip.DrawList[6].eType = 1;
    m_Tooltip.DrawList[6].t_color.R = 175;
    m_Tooltip.DrawList[6].t_color.G = 152;
    m_Tooltip.DrawList[6].t_color.B = 120;
    m_Tooltip.DrawList[6].t_color.A = byte(255);
    m_Tooltip.DrawList[6].t_strText = string(currentMP);
    m_Tooltip.DrawList[7].t_bDrawOneLine = true;
    m_Tooltip.DrawList[7].eType = 1;
    m_Tooltip.DrawList[7].t_strText = " / " $ string(maxMP);
    return m_Tooltip;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("SummonedWnd").HideWindow();
    return;
}
