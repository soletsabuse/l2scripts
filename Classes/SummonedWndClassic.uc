class SummonedWndClassic extends UICommonAPI;

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
var StatusBarHandle barHP;
var StatusBarHandle barMP;
var ButtonHandle btnBAr;
var TabHandle TabCtrl;
var TextureHandle TabLineTop;
var TextureHandle tabBg1;
var L2Util util;
var int summonServerID;
var bool bAwakeStateFlag;
var int selectedSlotIndex;
var int summonedServerID;
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
                                // End:0x164
                                if(Event_ID == 190)
                                {
                                    ParseInt(param, "ServerID", ServerID);
                                    ParseInt(param, "CurrentHP", currentHP);
                                    // End:0x161
                                    if(ServerID != 0)
                                    {
                                        // End:0x14C
                                        if(summonedServerID != ServerID)
                                        {
                                            return;
                                        }
                                        setStatusBarHP(SlotIndex, currentHP, ServerID);
                                    }                                    
                                }
                                else
                                {
                                    // End:0x1D9
                                    if(Event_ID == 210)
                                    {
                                        ParseInt(param, "ServerID", ServerID);
                                        ParseInt(param, "CurrentMP", currentMP);
                                        // End:0x1D6
                                        if(ServerID != 0)
                                        {
                                            // End:0x1C1
                                            if(summonedServerID != ServerID)
                                            {
                                                return;
                                            }
                                            setStatusBarMP(SlotIndex, currentMP, ServerID);
                                        }                                        
                                    }
                                    else
                                    {
                                        // End:0x1EB
                                        if(Event_ID == 1120)
                                        {                                            
                                        }
                                        else
                                        {
                                            // End:0x203
                                            if(Event_ID == 1131)
                                            {
                                                HandleSummonedStatusClose();                                                
                                            }
                                            else
                                            {
                                                // End:0x21B
                                                if(Event_ID == 1090)
                                                {
                                                    HandleSummonShow();                                                    
                                                }
                                                else
                                                {
                                                    // End:0x22D
                                                    if(Event_ID == 1900)
                                                    {                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x23F
                                                        if(Event_ID == 1311)
                                                        {                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x254
                                                            if(Event_ID == 40)
                                                            {
                                                                Restart();                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x26E
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
    SetClosingOnESC();
    util = L2Util(GetScript("L2Util"));
    Initialize();
    currentSummonPolicy = -1;
    txtHeadSoulShotCosume1.SetText(GetSystemString(404));
    txtHeadSoulShotCosume2.SetText(GetSystemString(496));
    return;
}

function Initialize()
{
    Me = GetWindowHandle("SummonedWndClassic");
    SummonedWnd_Status = GetWindowHandle("SummonedWndClassic.SummonedWnd_Status");
    txtLvHead = GetTextBoxHandle("SummonedWndClassic.txtLvHead");
    txtLvName = GetTextBoxHandle("SummonedWndClassic.txtLvName");
    txtHeadFight = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadFight");
    txtHeadPhysicalAttack = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalAttack");
    txtHeadPhysicalDefense = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalDefense");
    txtHeadHitRate = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadHitRate");
    txtHeadPhysicalAvoid = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalAvoid");
    txtHeadCriticalRate = GetTextBoxHandle("SummonedWndClassic.1.txtHeadCriticalRate");
    txtHeadPhysicalAttackSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadPhysicalAttackSpeed");
    txtHeadMovingSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMovingSpeed");
    txtHeadSoulShot = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadSoulShot");
    txtHeadMagicalAttack = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicalAttack");
    txtHeadMagicDefense = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicDefense");
    txtHeadMagicHit = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicHit");
    txtHeadMagicAvoid = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicAvoid");
    txtHeadMagicCritical = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicCritical");
    txtHeadMagicCastingSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadMagicCastingSpeed");
    txtHeadSoulShotCosume1 = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadSoulShotCosume1");
    txtHeadSoulShotCosume2 = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHeadSoulShotCosume2");
    txtPhysicalAttack = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtPhysicalAttack");
    txtPhysicalDefense = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtPhysicalDefense");
    txtHitRate = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtHitRate");
    txtPhysicalAvoid = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtPhysicalAvoid");
    txtCriticalRate = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtCriticalRate");
    txtPhysicalAttackSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtPhysicalAttackSpeed");
    txtMovingSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMovingSpeed");
    txtMagicalAttack = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicalAttack");
    txtMagicDefense = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicDefense");
    txtMagicHit = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicHit");
    txtMagicAvoid = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicAvoid");
    txtMagicCritical = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicCritical");
    txtMagicCastingSpeed = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtMagicCastingSpeed");
    txtSoulShotCosume1 = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtSoulShotCosume1");
    txtSoulShotCosume2 = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Status.txtSoulShotCosume2");
    BackTex1 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.BackTex1");
    BackTex2 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.BackTex2");
    BackTex3 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.BackTex3");
    DividerLine = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.DividerLine");
    DividerLine2 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.DividerLine2");
    SummonedFace = GetTextureHandle("SummonedWndClassic.SummonedFace");
    SummonedSlotOutline = GetTextureHandle("SummonedWndClassic.SummonedWnd_Status.SummonedSlotOutline");
    SummonedWnd_Action = GetWindowHandle("SummonedWndClassic.SummonedWnd_Action");
    SummonedWnd_Action1 = GetWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action1");
    BackTexAction1_Before = GetTextureHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action1.BackTexAction1_Before");
    SummonedWnd_Action2 = GetWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2");
    txtHeadDirect = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.txtHeadDirect");
    txtHeadPolicy = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.txtHeadPolicy");
    txtHeadSkill = GetTextBoxHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.txtHeadSkill");
    SummonedActionWnd_Before = GetItemWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action1.SummonedActionWnd_Before");
    SummonedActionWnd = GetItemWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd");
    SummonedActionWnd2 = GetItemWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd2");
    SummonedActionWnd3 = GetItemWindowHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.SummonedActionWnd3");
    BackTexAction1 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction1");
    BackTexAction2 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction2");
    BackTexAction3 = GetTextureHandle("SummonedWndClassic.SummonedWnd_Action.SummonedWnd_Action2.BackTexAction3");
    barHP = GetStatusBarHandle("SummonedWndClassic.barHP");
    barMP = GetStatusBarHandle("SummonedWndClassic.barMP");
    btnBAr = GetButtonHandle("SummonedWndClassic.btnBar");
    TabCtrl = GetTabHandle("SummonedWndClassic.TabCtrl");
    TabLineTop = GetTextureHandle("SummonedWndClassic.TabLineTop");
    tabBg1 = GetTextureHandle("SummonedWndClassic.tabBg1");
    bAwakeStateFlag = false;
    initSlot();
    return;
}

function initSlot()
{
    barHP.SetPoint(0, 0);
    barMP.SetPoint(0, 0);
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
    summonedServerID = -1;
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
    // End:0x2F
    if(summonedServerID == ServerID)
    {
        setInformation(ServerID);
    }
    return;
}

function setTargetSummon()
{
    local UserInfo UserInfo;

    // End:0x32
    if(summonedServerID != -1)
    {
        // End:0x32
        if(GetPlayerInfo(UserInfo))
        {
            RequestAction(summonedServerID, UserInfo.loc);
        }
    }
    return;
}

function HandleSummonedStatusClose()
{
    local int usedSummonPoint, SummonablePoint;

    PlayConsoleSound(6);
    Me.HideWindow();
    deleteSlot();
    GetSummonPoint(usedSummonPoint, SummonablePoint);
    ClearActionWnd();
    setInformation(-1);
    currentSummonPolicy = -1;
    return;
}

function HandleSummonShow()
{
    PlayConsoleSound(5);
    // End:0x39
    if(getInstanceUIData().getIsClassicServer())
    {
        Me.ShowWindow();
        Me.SetFocus();
    }
    return;
}

function HandleSummonedDelete(string param)
{
    local int ServerID;

    ParseInt(param, "serverID", ServerID);
    // End:0x47
    if(bAwakeStateFlag)
    {
        // End:0x47
        if(summonedServerID == ServerID)
        {
            SummonedActionWnd3.Clear();
            deleteSlot();
        }
    }
    return;
}

function deleteSlot()
{
    btnBAr.ClearTooltip();
    summonedServerID = -1;
    return;
}

function HandleSummonInfoUpdate(int ServerID)
{
    local int hp, MaxHP, mp, maxMP, ClassID;

    local string Name;
    local int Level;
    local SummonInfo Info;

    // End:0x16F
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
        summonedServerID = ServerID;
        SummonedFace.SetTexture(Class'NWindow.UIDATA_NPC'.static.GetNPCIconName(ClassID));
        SummonedFace.SetTextureSize(32, 32);
        summonedServerID = ServerID;
        Class'NWindow.ActionAPI'.static.RequestSummonedCommonActionList(ServerID);
        Class'NWindow.ActionAPI'.static.RequestSummonedAllSkillActionList();
        setInformation(ServerID);
        barHP.SetPoint(hp, MaxHP);
        barMP.SetPoint(mp, maxMP);
        btnBAr.SetTooltipCustomType(setHpMpToolTips(Level, Name, MaxHP, hp, maxMP, mp));
    }
    return;
}

function setStatusBarHP(int SlotIndex, int CurHP, int ServerID)
{
    local SummonInfo Info;
    local string Name;
    local int Level, MaxHP, mp, maxMP;

    // End:0xC8
    if(GetSummonInfo(ServerID, Info))
    {
        MaxHP = Info.nMaxHP;
        maxMP = Info.nMaxMP;
        mp = Info.nCurMP;
        Name = Info.Name;
        Level = Info.nLevel;
        barHP.SetPoint(CurHP, MaxHP);
        barMP.SetPoint(mp, maxMP);
        btnBAr.SetTooltipCustomType(setHpMpToolTips(Level, Name, MaxHP, CurHP, maxMP, mp));
    }
    return;
}

function setStatusBarMP(int SlotIndex, int curMP, int ServerID)
{
    local SummonInfo Info;
    local string Name;
    local int Level, MaxHP, hp, maxMP;

    // End:0xC8
    if(GetSummonInfo(ServerID, Info))
    {
        MaxHP = Info.nMaxHP;
        maxMP = Info.nMaxMP;
        hp = Info.nCurHP;
        Name = Info.Name;
        Level = Info.nLevel;
        barHP.SetPoint(hp, MaxHP);
        barMP.SetPoint(curMP, maxMP);
        btnBAr.SetTooltipCustomType(setHpMpToolTips(Level, Name, MaxHP, hp, maxMP, curMP));
    }
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
        // End:0x1B
        case "btnBar":
            setTargetSummon();
            // End:0x1E
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
    GetWindowHandle("SummonedWndClassic").HideWindow();
    return;
}
