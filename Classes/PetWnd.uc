class PetWnd extends UICommonAPI;

const PET_EQUIPPEDTEXTURE_NAME = "l2ui_ch3.PetWnd.petitem_click";
const DIALOG_PETNAME = 1111;
const DIALOG_GIVEITEMTOPET = 2222;
const NPET_SMALLBARSIZE = 85;
const NPET_LARGEBARSIZE = 206;
const NPET_BARHEIGHT = 12;
const PET_EVOLUTIONIZED_ID = 1210114602;

var string m_WindowName;
var int m_PetID;
var bool m_bShowNameBtn;
var string m_LastInputPetName;
var int EvolutionizedAction;
var WindowHandle Me;
var StatusBarHandle texPetHP;
var StatusBarHandle texPetMP;
var StatusBarHandle texPetExp;
var StatusBarHandle texPetFatigue;
var ButtonHandle btnName;
var TextBoxHandle txtPetSP;
var TextBoxHandle txtLvName;
var TextBoxHandle txtPhysicalAttack;
var TextBoxHandle txtPhysicalDefense;
var TextBoxHandle txtHitRate;
var TextBoxHandle txtCriticalRate;
var TextBoxHandle txtPhysicalAttackSpeed;
var TextBoxHandle txtSoulShotCosume;
var TextBoxHandle txtMagicalAttack;
var TextBoxHandle txtMagicDefense;
var TextBoxHandle txtPhysicalAvoid;
var TextBoxHandle txtMovingSpeed;
var TextBoxHandle txtMagicCastingSpeed;
var TextBoxHandle txtSpiritShotConsume;
var TextBoxHandle txtMagicHit;
var TextBoxHandle txtMagicAvoid;
var TextBoxHandle txtMagicCritical;
var ItemWindowHandle PetActionWnd;
var ItemWindowHandle PetInvenWnd;

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(250);
    RegisterEvent(1010);
    RegisterEvent(1020);
    RegisterEvent(1030);
    RegisterEvent(1130);
    RegisterEvent(1311);
    RegisterEvent(1320);
    RegisterEvent(1330);
    RegisterEvent(1060);
    RegisterEvent(1070);
    RegisterEvent(1080);
    RegisterEvent(1900);
    RegisterEvent(190);
    RegisterEvent(210);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x23
    if(1 == 0)
    {
        InitHandle();        
    }
    else
    {
        InitHandleCOD();
    }
    m_bShowNameBtn = true;
    EvolutionizedAction = 0;
    return;
}

function InitHandle()
{
    Me = GetHandle("PetWnd");
    btnName = ButtonHandle(GetHandle("PetWnd.btnName"));
    texPetHP = StatusBarHandle(GetHandle("PetWnd.texPetHP"));
    texPetMP = StatusBarHandle(GetHandle("PetWnd.texPetMP"));
    texPetExp = StatusBarHandle(GetHandle("PetWnd.texPetExp"));
    texPetFatigue = StatusBarHandle(GetHandle("PetWnd.texPetFatigue"));
    txtPetSP = TextBoxHandle(GetHandle("PetWnd.txtPetSP"));
    txtLvName = TextBoxHandle(GetHandle("PetWnd.txtLvName"));
    txtPhysicalAttack = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtPhysicalAttack"));
    txtPhysicalDefense = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtPhysicalDefense"));
    txtHitRate = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtHitRate"));
    txtCriticalRate = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtCriticalRate"));
    txtPhysicalAttackSpeed = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtPhysicalAttackSpeed"));
    txtSoulShotCosume = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtSoulShotCosume"));
    txtMagicalAttack = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMagicalAttack"));
    txtMagicDefense = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMagicDefense"));
    txtPhysicalAvoid = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtPhysicalAvoid"));
    txtMovingSpeed = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMovingSpeed"));
    txtMagicCastingSpeed = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMagicCastingSpeed"));
    txtSpiritShotConsume = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtSpiritShotConsume"));
    txtMagicHit = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMagicHit"));
    txtMagicAvoid = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtPhysicalAvoid"));
    txtMagicCritical = TextBoxHandle(GetHandle("PetWnd.PetWnd_Status.txtMagicCritical"));
    PetActionWnd = ItemWindowHandle(GetHandle("PetWnd.PetWnd_Action.PetActionWnd"));
    PetInvenWnd = ItemWindowHandle(GetHandle("PetWnd.PetWnd_Inventory.PetInvenWnd"));
    return;
}

function InitHandleCOD()
{
    Me = GetWindowHandle("PetWnd");
    btnName = GetButtonHandle("PetWnd.btnName");
    texPetHP = GetStatusBarHandle("PetWnd.texPetHP");
    texPetMP = GetStatusBarHandle("PetWnd.texPetMP");
    texPetExp = GetStatusBarHandle("PetWnd.texPetExp");
    texPetFatigue = GetStatusBarHandle("PetWnd.texPetFatigue");
    txtPetSP = GetTextBoxHandle("PetWnd.txtPetSP");
    txtLvName = GetTextBoxHandle("PetWnd.txtLvName");
    txtPhysicalAttack = GetTextBoxHandle("PetWnd.PetWnd_Status.txtPhysicalAttack");
    txtPhysicalDefense = GetTextBoxHandle("PetWnd.PetWnd_Status.txtPhysicalDefense");
    txtHitRate = GetTextBoxHandle("PetWnd.PetWnd_Status.txtHitRate");
    txtCriticalRate = GetTextBoxHandle("PetWnd.PetWnd_Status.txtCriticalRate");
    txtPhysicalAttackSpeed = GetTextBoxHandle("PetWnd.PetWnd_Status.txtPhysicalAttackSpeed");
    txtSoulShotCosume = GetTextBoxHandle("PetWnd.PetWnd_Status.txtSoulShotCosume");
    txtMagicalAttack = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicalAttack");
    txtMagicDefense = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicDefense");
    txtPhysicalAvoid = GetTextBoxHandle("PetWnd.PetWnd_Status.txtPhysicalAvoid");
    txtMovingSpeed = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMovingSpeed");
    txtMagicCastingSpeed = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicCastingSpeed");
    txtSpiritShotConsume = GetTextBoxHandle("PetWnd.PetWnd_Status.txtSpiritShotConsume");
    txtMagicHit = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicHit");
    txtMagicAvoid = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicAvoid");
    txtMagicCritical = GetTextBoxHandle("PetWnd.PetWnd_Status.txtMagicCritical");
    PetActionWnd = GetItemWindowHandle("PetWnd.PetWnd_Action.PetActionWnd");
    PetInvenWnd = GetItemWindowHandle("PetWnd.PetWnd_Inventory.PetInvenWnd");
    return;
}

function OnShow()
{
    Class'NWindow.PetAPI'.static.RequestPetInventoryItemList();
    Class'NWindow.ActionAPI'.static.RequestPetActionList();
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RefineryWnd");
    return;
}

function OnDropItem(string strTarget, ItemInfo Info, int X, int Y)
{
    local InventoryWnd script;

    script = InventoryWnd(GetScript("InventoryWnd"));
    // End:0x12D
    if((strTarget == "PetInvenWnd") && script.getInventoryItemWndName(Info.DragSrcName) == true)
    {
        // End:0x111
        if(IsStackableItem(Info.ConsumeType) && __NFUN_409__(Info.ItemNum, (1)))
        {
            // End:0xB8
            if(__NFUN_409__(Info.AllItemCount, (0)))
            {
                Class'NWindow.PetAPI'.static.RequestGiveItemToPet(Info.Id, Info.AllItemCount);                
            }
            else
            {
                DialogSetID(2222);
                DialogSetReservedItemID(Info.Id);
                DialogSetParamInt64(Info.ItemNum);
                DialogSetDefaultOK();
                DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), Info.Name), string(self));
            }            
        }
        else
        {
            Class'NWindow.PetAPI'.static.RequestGiveItemToPet(Info.Id, (1));
        }
    }
    return;
}

function HandleLanguageChanged()
{
    Class'NWindow.PetAPI'.static.RequestPetInventoryItemList();
    Class'NWindow.ActionAPI'.static.RequestPetActionList();
    return;
}

function OnHide()
{
    // End:0x0F
    if(DialogIsMine())
    {
        DialogHide();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x15
    if(Event_ID == 250)
    {
        HandlePetInfoUpdate();        
    }
    else
    {
        // End:0x2F
        if(Event_ID == 190)
        {
            UpdatePetHP(param);            
        }
        else
        {
            // End:0x49
            if(Event_ID == 210)
            {
                UpdatePetMP(param);                
            }
            else
            {
                // End:0x61
                if(Event_ID == 1130)
                {
                    HandlePetStatusClose();                    
                }
                else
                {
                    // End:0x7F
                    if(Event_ID == 1010)
                    {
                        HandlePetInfoUpdate();
                        HandlePetShow();                        
                    }
                    else
                    {
                        // End:0x9C
                        if(Event_ID == 1020)
                        {
                            HandlePetShowNameBtn(param);                            
                        }
                        else
                        {
                            // End:0xB9
                            if(Event_ID == 1030)
                            {
                                HandleRegPetName(param);                                
                            }
                            else
                            {
                                // End:0xD1
                                if(Event_ID == 1710)
                                {
                                    HandleDialogOK();                                    
                                }
                                else
                                {
                                    // End:0xE9
                                    if(Event_ID == 1320)
                                    {
                                        HandleActionPetListStart();                                        
                                    }
                                    else
                                    {
                                        // End:0x106
                                        if(Event_ID == 1330)
                                        {
                                            HandleActionPetList(param);                                            
                                        }
                                        else
                                        {
                                            // End:0x11E
                                            if(Event_ID == 1060)
                                            {
                                                HandlePetInventoryItemStart();                                                
                                            }
                                            else
                                            {
                                                // End:0x13B
                                                if(Event_ID == 1070)
                                                {
                                                    HandlePetInventoryItemList(param);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x158
                                                    if(Event_ID == 1080)
                                                    {
                                                        HandlePetInventoryItemUpdate(param);                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x170
                                                        if(Event_ID == 1900)
                                                        {
                                                            HandleLanguageChanged();                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x18E
                                                            if(Event_ID == 1311)
                                                            {
                                                                Class'NWindow.ActionAPI'.static.RequestPetActionList();
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

function HandleDialogOK()
{
    local int Id;
    local ItemID sID;
    local INT64 Number;

    // End:0x80
    if(DialogIsMine())
    {
        Id = DialogGetID();
        sID = DialogGetReservedItemID();
        Number = (DialogGetString());
        // End:0x58
        if(Id == 1111)
        {
            m_LastInputPetName = DialogGetString();
            RequestChangePetName(m_LastInputPetName);            
        }
        else
        {
            // End:0x80
            if(Id == 2222)
            {
                Class'NWindow.PetAPI'.static.RequestGiveItemToPet(sID, Number);
            }
        }
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1C
        case "btnName":
            OnNameClick();
            // End:0x1F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnNameClick()
{
    DialogSetID(1111);
    DialogSetDefaultOK();
    DialogShow(1, 2, GetSystemMessage(535), string(self));
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo infItem;

    // End:0x55
    if((strID == "PetActionWnd") && Index > -1)
    {
        // End:0x55
        if(PetActionWnd.GetItem(Index, infItem))
        {
            DoAction(infItem.Id);
        }
    }
    return;
}

function OnDBClickItem(string strID, int Index)
{
    local ItemInfo infItem;

    // End:0x5D
    if((strID == "PetInvenWnd") && Index > -1)
    {
        // End:0x5D
        if(PetInvenWnd.GetItem(Index, infItem))
        {
            Class'NWindow.PetAPI'.static.RequestPetUseItem(infItem.Id);
        }
    }
    return;
}

function OnRClickItem(string strID, int Index)
{
    local ItemInfo infItem;

    // End:0x5D
    if((strID == "PetInvenWnd") && Index > -1)
    {
        // End:0x5D
        if(PetInvenWnd.GetItem(Index, infItem))
        {
            Class'NWindow.PetAPI'.static.RequestPetUseItem(infItem.Id);
        }
    }
    return;
}

function Clear()
{
    txtLvName.SetText("");
    txtPetSP.SetText("0");
    texPetHP.SetPoint(0, 0);
    texPetMP.SetPoint(0, 0);
    texPetExp.SetPointPercent((0), (0), (0));
    texPetFatigue.SetPointPercent((0), (0), (0));
    return;
}

function ClearActionWnd()
{
    PetActionWnd.Clear();
    return;
}

function ClearInvenWnd()
{
    PetInvenWnd.Clear();
    return;
}

function HandleRegPetName(string param)
{
    local int MsgNo;

    ParseInt(param, "ErrMsgNo", MsgNo);
    AddSystemMessage(MsgNo);
    DialogSetDefaultOK();
    DialogShow(1, 2, GetSystemMessage(535), string(self));
    // End:0x5A
    if(MsgNo == 80)
    {
        DialogSetString(m_LastInputPetName);
    }
    return;
}

function HandlePetShowNameBtn(string param)
{
    local int ShowFlag;

    ParseInt(param, "Show", ShowFlag);
    // End:0x2B
    if(ShowFlag == 1)
    {
        SetVisibleNameBtn(true);        
    }
    else
    {
        SetVisibleNameBtn(false);
    }
    return;
}

function SetVisibleNameBtn(bool bShow)
{
    // End:0x1B
    if(bShow)
    {
        btnName.ShowWindow();        
    }
    else
    {
        btnName.HideWindow();
    }
    m_bShowNameBtn = bShow;
    return;
}

function HandlePetStatusClose()
{
    Me.HideWindow();
    PlayConsoleSound(6);
    return;
}

function UpdatePetMP(string param)
{
    local int ServerID, currentMP, mp, maxMP;
    local PetInfo Info;

    ParseInt(param, "ServerID", ServerID);
    ParseInt(param, "CurrentMP", currentMP);
    // End:0x8B
    if(GetPetInfo(Info))
    {
        // End:0x8B
        if(ServerID == Info.nServerID)
        {
            mp = currentMP;
            maxMP = Info.nMaxMP;
            texPetMP.SetPoint(mp, maxMP);
        }
    }
    return;
}

function UpdatePetHP(string param)
{
    local int ServerID, currentHP, hp, MaxHP;
    local PetInfo Info;

    ParseInt(param, "ServerID", ServerID);
    ParseInt(param, "CurrentHP", currentHP);
    // End:0x8B
    if(GetPetInfo(Info))
    {
        // End:0x8B
        if(ServerID == Info.nServerID)
        {
            hp = currentHP;
            MaxHP = Info.nMaxHP;
            texPetHP.SetPoint(hp, MaxHP);
        }
    }
    return;
}

function HandlePetInfoUpdate()
{
    local string Name;
    local int hp, MaxHP, mp, maxMP, Fatigue, MaxFatigue;

    local INT64 SP;
    local int Level, PhysicalAttack, PhysicalDefense, HitRate, CriticalRate, PhysicalAttackSpeed,
	    MagicalAttack, MagicDefense, PhysicalAvoid, MovingSpeed, MagicCastingSpeed,
	    SoulShotCosume, SpiritShotConsume, nEvolutionID, MagicalHitRate, MagicalAvoid,
	    MagicalCritical;

    local INT64 nCurExp, nMinExp, nMaxExp;
    local PetInfo Info;

    // End:0x16
    if(!Me.IsShowWindow())
    {
        return;
    }
    // End:0x207
    if(GetPetInfo(Info))
    {
        // End:0x37
        if(Info.PetOrSummoned != 2)
        {
            return;
        }
        m_PetID = Info.nServerID;
        Name = Info.Name;
        SP = Info.nSP;
        Level = Info.nLevel;
        hp = Info.nCurHP;
        MaxHP = Info.nMaxHP;
        mp = Info.nCurMP;
        maxMP = Info.nMaxMP;
        Fatigue = Info.nFatigue;
        MaxFatigue = Info.nMaxFatigue;
        nCurExp = Info.nCurExp;
        nMinExp = Info.nMinExp;
        nMaxExp = Info.nMaxExp;
        nEvolutionID = Info.nEvolutionID;
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
    }
    txtLvName.SetText((string(Level) $ " ") $ Name);
    txtPetSP.SetText((SP));
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
    txtSoulShotCosume.SetText(string(SoulShotCosume));
    txtSpiritShotConsume.SetText(string(SpiritShotConsume));
    txtMagicHit.SetText(string(MagicalHitRate));
    txtMagicAvoid.SetText(string(MagicalAvoid));
    txtMagicCritical.SetText(string(MagicalCritical));
    texPetHP.SetPoint(hp, MaxHP);
    texPetMP.SetPoint(mp, maxMP);
    texPetExp.SetPointPercent(nCurExp, nMinExp, nMaxExp);
    texPetFatigue.SetPointPercent((Fatigue), (0), (MaxFatigue));
    EvolutionizedAction = nEvolutionID;
    return;
}

function HandlePetShow()
{
    Clear();
    PlayConsoleSound(5);
    Me.ShowWindow();
    Me.SetFocus();
    HandlePetInfoUpdate();
    SetVisibleNameBtn(m_bShowNameBtn);
    return;
}

function HandleActionPetListStart()
{
    HandlePetInfoUpdate();
    ClearActionWnd();
    return;
}

function HandleActionPetList(string param)
{
    local int tmp;
    local UIEventManager.EActionCategory Type;
    local string strActionName, strIconName, strDescription, strCommand;
    local int intClassID;
    local ItemInfo infItem;

    ParseItemID(param, infItem.Id);
    ParseInt(param, "Type", tmp);
    ParseString(param, "Name", strActionName);
    ParseString(param, "IconName", strIconName);
    ParseString(param, "Description", strDescription);
    ParseString(param, "Command", strCommand);
    ParseInt(param, "ClassID", intClassID);
    infItem.Name = strActionName;
    infItem.IconName = strIconName;
    infItem.Description = strDescription;
    infItem.ItemSubType = int(3);
    infItem.MacroCommand = strCommand;
    Type = byte(tmp);
    // End:0x219
    if(int(Type) == int(5))
    {
        switch(EvolutionizedAction)
        {
            // End:0x14B
            case 2:
                // End:0x134
                if(intClassID == 1044)
                {                    
                }
                else
                {
                    PetActionWnd.AddItem(infItem);
                }
                // End:0x219
                break;
            // End:0x189
            case 1:
                // End:0x172
                if((intClassID == 1042) || intClassID == 1044)
                {                    
                }
                else
                {
                    PetActionWnd.AddItem(infItem);
                }
                // End:0x219
                break;
            // End:0x1FA
            case 0:
                // End:0x1E3
                if(((((intClassID == 1042) || intClassID == 1043) || intClassID == 1044) || intClassID == 1045) || intClassID == 1046)
                {                    
                }
                else
                {
                    PetActionWnd.AddItem(infItem);
                }
                // End:0x219
                break;
            // End:0x216
            case 3:
                PetActionWnd.AddItem(infItem);
                // End:0x219
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

function HandlePetInventoryItemStart()
{
    ClearInvenWnd();
    return;
}

function HandlePetInventoryItemList(string param)
{
    local ItemInfo infItem;

    ParamToItemInfo(param, infItem);
    // End:0x48
    if(infItem.bEquipped)
    {
        infItem.ForeTexture = "l2ui_ch3.PetWnd.petitem_click";
    }
    PetInvenWnd.AddItem(infItem);
    return;
}

function HandlePetInventoryItemUpdate(string param)
{
    local ItemInfo infItem;
    local int tmp, Index;
    local UIEventManager.EInventoryUpdateType WorkType;

    ParamToItemInfo(param, infItem);
    ParseInt(param, "WorkType", tmp);
    WorkType = byte(tmp);
    // End:0x4E
    if(!IsValidItemID(infItem.Id))
    {
        return;
    }
    // End:0x86
    if(infItem.bEquipped)
    {
        infItem.ForeTexture = "l2ui_ch3.PetWnd.petitem_click";
    }
    switch(WorkType)
    {
        // End:0xA9
        case 1:
            PetInvenWnd.AddItem(infItem);
            // End:0x141
            break;
        // End:0xF6
        case 2:
            Index = PetInvenWnd.FindItem(infItem.Id);
            // End:0xDA
            if(Index < 0)
            {
                return;
            }
            PetInvenWnd.SetItem(Index, infItem);
            // End:0x141
            break;
        // End:0x13E
        case 3:
            Index = PetInvenWnd.FindItem(infItem.Id);
            // End:0x127
            if(Index < 0)
            {
                return;
            }
            PetInvenWnd.DeleteItem(Index);
            // End:0x141
            break;
        // End:0xFFFF
        default:
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
    m_WindowName="PetWnd"
}