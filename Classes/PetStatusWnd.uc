class PetStatusWnd extends UICommonAPI;

const NSTATUSICON_MAXCOL = 12;

var bool m_bBuff;
var bool m_bShow;
var int m_PetID;
var int m_CurBf;
var bool m_bPetload;
var WindowHandle Me;
var BarHandle barFATIGUE;
var BarHandle barMP;
var BarHandle barHP;
var NameCtrlHandle PetName;
var ButtonHandle btnBuff;
var WindowHandle BackTex;
var StatusIconHandle m_StatusIconBuff;
var StatusIconHandle m_StatusIconDeBuff;
var StatusIconHandle m_StatusIconSongDance;
var StatusIconHandle m_StatusIconTriggerSkill;
var StatusIconHandle BufIcon;
var StatusIconHandle DebufIcon;
var StatusIconHandle SongDanceIcon;
var StatusIconHandle TriggerSkillIcon;
var EffectSwapWnd EffectSwapWnd_script;
var WindowHandle EffectSwapWnd;
var string LastPacketData;

function OnRegisterEvent()
{
    RegisterEvent(40);
    RegisterEvent(250);
    RegisterEvent(1000);
    RegisterEvent(1040);
    RegisterEvent(1050);
    RegisterEvent(1130);
    RegisterEvent(190);
    RegisterEvent(210);
    RegisterEvent(1052);
    RegisterEvent(1053);
    return;
}

function OnLoad()
{
    m_bPetload = false;
    // End:0x18
    if(1 == 0)
    {
        Initialize();        
    }
    else
    {
        InitializeCOD();
    }
    load();
    return;
}

function Initialize()
{
    BufIcon = GetStatusIconHandle("PetStatusWnd.StatusIconBuff");
    DebufIcon = GetStatusIconHandle("PetStatusWnd.StatusIconDeBuff");
    SongDanceIcon = GetStatusIconHandle("PetStatusWnd.StatusIconSongDance");
    TriggerSkillIcon = GetStatusIconHandle("PetStatusWnd.StatusIconTriggerSkill");
    Me = GetHandle("PetStatusWnd");
    barFATIGUE = BarHandle(GetHandle("PetStatusWnd.barFATIGUE"));
    barMP = BarHandle(GetHandle("PetStatusWnd.barMP"));
    barHP = BarHandle(GetHandle("PetStatusWnd.barHP"));
    PetName = NameCtrlHandle(GetHandle("PetStatusWnd.PetName"));
    btnBuff = ButtonHandle(GetHandle("PetStatusWnd.btnBuff"));
    BackTex = GetHandle("PetStatusWnd.BackTex");
    m_StatusIconBuff = StatusIconHandle(GetHandle("PetStatusWnd.StatusIconBuff"));
    m_StatusIconDeBuff = StatusIconHandle(GetHandle("PetStatusWnd.StatusIconDeBuff"));
    m_StatusIconSongDance = StatusIconHandle(GetHandle("PetStatusWnd.StatusIconSongDance"));
    m_StatusIconTriggerSkill = StatusIconHandle(GetHandle("PetStatusWnd.StatusIconTriggerSkill"));
    m_CurBf = 1;
    return;
}

function InitializeCOD()
{
    BufIcon = GetStatusIconHandle("PetStatusWnd.StatusIconBuff");
    DebufIcon = GetStatusIconHandle("PetStatusWnd.StatusIconDeBuff");
    SongDanceIcon = GetStatusIconHandle("PetStatusWnd.StatusIconSongDance");
    TriggerSkillIcon = GetStatusIconHandle("PetStatusWnd.StatusIconTriggerSkill");
    Me = GetWindowHandle("PetStatusWnd");
    barFATIGUE = GetBarHandle("PetStatusWnd.barFATIGUE");
    barMP = GetBarHandle("PetStatusWnd.barMP");
    barHP = GetBarHandle("PetStatusWnd.barHP");
    PetName = GetNameCtrlHandle("PetStatusWnd.PetName");
    btnBuff = GetButtonHandle("PetStatusWnd.btnBuff");
    BackTex = GetWindowHandle("PetStatusWnd.BackTex");
    m_StatusIconBuff = GetStatusIconHandle("PetStatusWnd.StatusIconBuff");
    m_StatusIconDeBuff = GetStatusIconHandle("PetStatusWnd.StatusIconDeBuff");
    m_StatusIconSongDance = GetStatusIconHandle("PetStatusWnd.StatusIconSongDance");
    m_StatusIconTriggerSkill = GetStatusIconHandle("PetStatusWnd.StatusIconTriggerSkill");
    m_CurBf = 1;
    EffectSwapWnd_script = EffectSwapWnd(GetScript("EffectSwapWnd"));
    EffectSwapWnd = GetWindowHandle("EffectSwapWnd");
    return;
}

function load()
{
    m_CurBf = 1;
    SetBuffButtonTooltip();
    m_bShow = false;
    m_bBuff = false;
    return;
}

function OnShow()
{
    local PetInfo PetInfo;

    GetPetInfo(PetInfo);
    // End:0x2D
    if(PetInfo.nServerID < 0)
    {
        Me.HideWindow();        
    }
    else
    {
        m_bShow = true;
    }
    return;
}

function OnHide()
{
    m_bShow = false;
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x18
    if(m_bPetload)
    {
        Me.ShowWindow();
    }
    m_bBuff = false;
    GetINIInt("PetStatusWnd", "a", m_CurBf, "WindowsInfo.ini");
    SetBuffButtonTooltip();
    UpdateBuff();
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
                // End:0x69
                if(Event_ID == 1130)
                {
                    HandlePetStatusClose();
                    m_bPetload = false;                    
                }
                else
                {
                    // End:0xA3
                    if(Event_ID == 1040)
                    {
                        // End:0x92
                        if(GetGameStateName() != "GAMINGSTATE")
                        {
                            return;
                        }
                        HandlePetStatusShow();
                        m_bPetload = true;                        
                    }
                    else
                    {
                        // End:0xC0
                        if(Event_ID == 1000)
                        {
                            HandleShowBuffIcon(param);                            
                        }
                        else
                        {
                            // End:0xDD
                            if(Event_ID == 1050)
                            {
                                HandlePetStatusSpelledList(param);                                
                            }
                            else
                            {
                                // End:0xFA
                                if(Event_ID == 1052)
                                {
                                    HandlePetStatusSpelledListDelete(param);                                    
                                }
                                else
                                {
                                    // End:0x117
                                    if(Event_ID == 1053)
                                    {
                                        HandlePetStatusSpelledListInsert(param);                                        
                                    }
                                    else
                                    {
                                        // End:0x12B
                                        if(Event_ID == 40)
                                        {
                                            m_bPetload = false;
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

function Clear()
{
    m_StatusIconBuff.super(PetStatusWnd).Clear();
    m_StatusIconDeBuff.super(PetStatusWnd).Clear();
    m_StatusIconSongDance.super(PetStatusWnd).Clear();
    m_StatusIconTriggerSkill.super(PetStatusWnd).Clear();
    PetName.SetName("", 0, 1);
    barHP.SetValue(0, 0);
    barMP.SetValue(0, 0);
    barFATIGUE.SetValue(0, 0);
    Me.HideWindow();
    return;
}

function HandlePetStatusClose()
{
    Me.HideWindow();
    PlayConsoleSound(6);
    Debug("ï¿½ï¿½ ui ï¿½ï¿½ï¿½ï¿½");
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
            barMP.SetValue(maxMP, mp);
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
            barHP.SetValue(MaxHP, hp);
        }
    }
    return;
}

function HandlePetInfoUpdate()
{
    local string Name;
    local int hp, MaxHP, mp, maxMP, Fatigue, MaxFatigue;

    local PetInfo Info;

    m_PetID = 0;
    // End:0x95
    if(GetPetInfo(Info))
    {
        m_PetID = Info.nServerID;
        Name = Info.Name;
        hp = Info.nCurHP;
        mp = Info.nCurMP;
        Fatigue = Info.nFatigue;
        MaxHP = Info.nMaxHP;
        maxMP = Info.nMaxMP;
        MaxFatigue = Info.nMaxFatigue;
    }
    PetName.SetName(Name, 0, 1);
    barHP.SetValue(MaxHP, hp);
    barMP.SetValue(maxMP, mp);
    barFATIGUE.SetValue(MaxFatigue, Fatigue);
    return;
}

function HandlePetStatusShow()
{
    Clear();
    Me.ShowWindow();
    Me.SetFocus();
    Debug("ï¿½ï¿½ uiï¿½ï¿½ï¿½ï¿½ ");
    return;
}

function HandlePetStatusSpelledList(string param)
{
    local int i, Id, Max, BuffCnt, BuffCurRow, DeBuffCnt,
	    DeBuffCurRow, SongDanceCnt, SongDanceCurRow, TriggerSkillCnt, TriggerSkillCurRow;

    local StatusIconInfo Info;

    DeBuffCurRow = -1;
    BuffCurRow = -1;
    SongDanceCurRow = -1;
    TriggerSkillCurRow = -1;
    LastPacketData = param;
    ParseInt(param, "ID", Id);
    // End:0x69
    if((Id < 1) || m_PetID != Id)
    {
        return;
    }
    m_StatusIconBuff.Clear();
    m_StatusIconDeBuff.Clear();
    m_StatusIconSongDance.Clear();
    m_StatusIconTriggerSkill.Clear();
    Info.Size = 16;
    Info.bShow = true;
    ParseInt(param, "Max", Max);
    i = 0;
    J0xDB:

    // End:0x40E [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        // End:0x186
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            // [Explicit Continue]
            goto J0x404;
        }
        ParseInt(param, "Sec_" $ string(i), Info.RemainTime);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x404
        if(IsValidItemID(Info.Id))
        {
            Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
            Info.bHideRemainTime = true;
            // End:0x2C9
            if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0) || EffectSwapWnd_script.getIsUsedObject(Info.Id.ClassID, 3))
            {
                // End:0x2A6
                if((float(DeBuffCnt) % float(12)) == float(0))
                {
                    DeBuffCurRow++;
                    m_StatusIconDeBuff.AddRow();
                }
                m_StatusIconDeBuff.AddCol(DeBuffCurRow, Info);
                DeBuffCnt++;
                // [Explicit Continue]
                goto J0x404;
            }
            // End:0x341
            if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                // End:0x31E
                if((float(SongDanceCnt) % float(12)) == float(0))
                {
                    SongDanceCurRow++;
                    m_StatusIconSongDance.AddRow();
                }
                m_StatusIconSongDance.AddCol(SongDanceCurRow, Info);
                SongDanceCnt++;
                // [Explicit Continue]
                goto J0x404;
            }
            // End:0x3B9
            if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                // End:0x396
                if((float(TriggerSkillCnt) % float(12)) == float(0))
                {
                    TriggerSkillCurRow++;
                    m_StatusIconTriggerSkill.AddRow();
                }
                m_StatusIconTriggerSkill.AddCol(TriggerSkillCurRow, Info);
                TriggerSkillCnt++;
                // [Explicit Continue]
                goto J0x404;
            }
            // End:0x3E4
            if((float(BuffCnt) % float(12)) == float(0))
            {
                BuffCurRow++;
                m_StatusIconBuff.AddRow();
            }
            m_StatusIconBuff.AddCol(BuffCurRow, Info);
            BuffCnt++;
        }
        J0x404:

        i++;
        // [Loop Continue]
        goto J0xDB;
    }
    UpdateBuff();
    return;
}

function HandlePetStatusSpelledListDelete(string param)
{
    local int i, Id, Max;
    local StatusIconInfo Info;

    ParseInt(param, "ID", Id);
    // End:0x32
    if((Id < 1) || m_PetID != Id)
    {
        return;
    }
    ParseInt(param, "Max", Max);
    i = 0;
    J0x4E:

    // End:0x24C [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x242
        if(IsValidItemID(Info.Id))
        {
            // End:0x15E
            if(GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0)
            {
                deleteBuff(m_StatusIconDeBuff, Info.Level, Info.Id.ClassID, Info.SpellerID);
                // [Explicit Continue]
                goto J0x242;
            }
            // End:0x1B9
            if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                deleteBuff(m_StatusIconSongDance, Info.Level, Info.Id.ClassID, Info.SpellerID);
                // [Explicit Continue]
                goto J0x242;
            }
            // End:0x214
            if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                deleteBuff(m_StatusIconTriggerSkill, Info.Level, Info.Id.ClassID, Info.SpellerID);
                // [Explicit Continue]
                goto J0x242;
            }
            deleteBuff(m_StatusIconBuff, Info.Level, Info.Id.ClassID, Info.SpellerID);
        }
        J0x242:

        i++;
        // [Loop Continue]
        goto J0x4E;
    }
    UpdateBuff();
    return;
}

function deleteBuff(StatusIconHandle tmpStatusIcon, int Level, int ClassID, int SpellerID)
{
    local int row, Col;
    local StatusIconInfo Info;

    row = 0;
    J0x07:

    // End:0xE7 [Loop If]
    if(row < tmpStatusIcon.GetRowCount())
    {
        Col = 0;
        J0x27:

        // End:0xDD [Loop If]
        if(Col < tmpStatusIcon.GetColCount(row))
        {
            tmpStatusIcon.GetItem(row, Col, Info);
            // End:0xD3
            if(((Info.Id.ClassID == ClassID) && Info.Level == Level) && Info.SpellerID == SpellerID)
            {
                tmpStatusIcon.DelItem(row, Col);
                refreshPostion(tmpStatusIcon, row);
                return;
            }
            Col++;
            // [Loop Continue]
            goto J0x27;
        }
        row++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function refreshPostion(StatusIconHandle tmpStatusIcon, int deletedRow)
{
    local int row;
    local StatusIconInfo Info;

    row = deletedRow;
    J0x0B:

    // End:0x7F [Loop If]
    if(row < (tmpStatusIcon.GetRowCount() - 1))
    {
        tmpStatusIcon.GetItem(row + 1, 0, Info);
        tmpStatusIcon.AddCol(row, Info);
        tmpStatusIcon.DelItem(row + 1, 0);
        row++;
        // [Loop Continue]
        goto J0x0B;
    }
    return;
}

function HandlePetStatusSpelledListInsert(string param)
{
    local int i, Id, Max;
    local StatusIconInfo Info;
    local StatusIconHandle tmpStatusIcon;

    ParseInt(param, "ID", Id);
    // End:0x32
    if((Id < 1) || m_PetID != Id)
    {
        return;
    }
    Info.Size = 16;
    Info.bShow = true;
    ParseInt(param, "Max", Max);
    i = 0;
    J0x68:

    // End:0x300 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "Sec_" $ string(i), Info.RemainTime);
        // End:0x137
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            // [Explicit Continue]
            goto J0x2F6;
        }
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        Info.bHideRemainTime = true;
        // End:0x2F6
        if(IsValidItemID(Info.Id))
        {
            Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
            Info.bHideRemainTime = true;
            // End:0x1FE
            if(GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0)
            {
                tmpStatusIcon = m_StatusIconDeBuff;                
            }
            else
            {
                // End:0x236
                if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
                {
                    tmpStatusIcon = m_StatusIconSongDance;                    
                }
                else
                {
                    // End:0x26E
                    if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
                    {
                        tmpStatusIcon = m_StatusIconTriggerSkill;                        
                    }
                    else
                    {
                        tmpStatusIcon = m_StatusIconBuff;
                    }
                }
            }
            // End:0x2D0
            if((tmpStatusIcon.GetRowCount() == 0) || (float(tmpStatusIcon.GetColCount(tmpStatusIcon.GetRowCount() - 1)) % float(12)) == float(0))
            {
                tmpStatusIcon.AddRow();
            }
            tmpStatusIcon.AddCol(tmpStatusIcon.GetRowCount() - 1, Info);
        }
        J0x2F6:

        i++;
        // [Loop Continue]
        goto J0x68;
    }
    UpdateBuff();
    return;
}

function HandleShowBuffIcon(string param)
{
    local int nShow;

    ParseInt(param, "Show", nShow);
    // End:0x2A
    if(nShow == 1)
    {
        UpdateBuff();        
    }
    else
    {
        UpdateBuff();
    }
    return;
}

function UpdateBuff()
{
    // End:0x4A
    if(m_CurBf == 1)
    {
        m_StatusIconBuff.ShowWindow();
        m_StatusIconDeBuff.ShowWindow();
        m_StatusIconSongDance.HideWindow();
        m_StatusIconTriggerSkill.HideWindow();        
    }
    else
    {
        // End:0x95
        if(m_CurBf == 2)
        {
            m_StatusIconBuff.HideWindow();
            m_StatusIconDeBuff.HideWindow();
            m_StatusIconSongDance.ShowWindow();
            m_StatusIconTriggerSkill.HideWindow();            
        }
        else
        {
            // End:0xE0
            if(m_CurBf == 3)
            {
                m_StatusIconBuff.HideWindow();
                m_StatusIconDeBuff.HideWindow();
                m_StatusIconSongDance.HideWindow();
                m_StatusIconTriggerSkill.ShowWindow();                
            }
            else
            {
                m_StatusIconBuff.HideWindow();
                m_StatusIconDeBuff.HideWindow();
                m_StatusIconSongDance.HideWindow();
                m_StatusIconTriggerSkill.HideWindow();
            }
        }
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local Rect rectWnd;
    local UserInfo UserInfo;

    // End:0x21
    if(a_WindowHandle.GetWindowName() == "btnOption")
    {
        return;
    }
    rectWnd = Me.GetRect();
    // End:0x97
    if((X > (rectWnd.nX + 13)) && X < ((rectWnd.nX + rectWnd.nWidth) - 10))
    {
        // End:0x97
        if(GetPlayerInfo(UserInfo))
        {
            RequestAction(m_PetID, UserInfo.loc);
        }
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1C
        case "btnBuff":
            OnBuffButton();
            // End:0x44
            break;
        // End:0x3E
        case "btnOption":
            EffectSwapWnd_script.handlePage(3);
            // End:0x44
            break;
        // End:0xFFFF
        default:
            // End:0x44
            break;
            break;
    }
    return;
}

function OnBuffButton()
{
    m_CurBf = m_CurBf + 1;
    // End:0x21
    if(m_CurBf > 3)
    {
        m_CurBf = 0;
    }
    SetINIInt("PetStatusWnd", "a", m_CurBf, "WindowsInfo.ini");
    SetBuffButtonTooltip();
    UpdateBuff();
    return;
}

function SetBuffButtonTooltip()
{
    local int idx;

    switch(m_CurBf)
    {
        // End:0x19
        case 0:
            idx = 2221;
            // End:0x57
            break;
        // End:0x2B
        case 1:
            idx = 1741;
            // End:0x57
            break;
        // End:0x3E
        case 2:
            idx = 2307;
            // End:0x57
            break;
        // End:0x51
        case 3:
            idx = 1498;
            // End:0x57
            break;
        // End:0xFFFF
        default:
            // End:0x57
            break;
            break;
    }
    btnBuff.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(idx)));
    return;
}

function OnClickItem(string strID, int Index)
{
    local int row, Col;
    local StatusIconInfo Info;
    local SkillInfo SkillInfo;
    local StatusIconHandle StatusIcon;

    Col = Index / 10;
    row = Index - (Col * 10);
    // End:0x51
    if(InStr(strID, "StatusIconBuff") > -1)
    {
        StatusIcon = BufIcon;
    }
    // End:0x7F
    if(InStr(strID, "StatusIconDeBuff") > -1)
    {
        StatusIcon = DebufIcon;
    }
    // End:0xB0
    if(InStr(strID, "StatusIconSongDance") > -1)
    {
        StatusIcon = SongDanceIcon;
    }
    // End:0xE4
    if(InStr(strID, "StatusIconTriggerSkill") > -1)
    {
        StatusIcon = TriggerSkillIcon;
    }
    StatusIcon.GetItem(row, Col, Info);
    // End:0x137
    if(!GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
    {
        return;
    }
    // End:0x229
    if((((InStr(strID, "StatusIconBuff") > -1) || InStr(strID, "StatusIconDeBuff") > -1) || InStr(strID, "StatusIconSongDance") > -1) || InStr(strID, "StatusIconTriggerSkill") > -1)
    {
        // End:0x21E
        if((SkillInfo.Debuff == 0) && SkillInfo.OperateType == 1)
        {
            RequestDispel(m_PetID, Info.Id, Info.Level, Info.SubLevel);            
        }
        else
        {
            AddSystemMessage(2318);
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
    targetID = m_PetID;
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
