class SummonedStatusWnd extends UICommonAPI;

const SUMMON_MAXCOUNT = 1;
const StatusWnd_SIZE_HEIGHT = 50;
const NSTATUSICON_MAXCOL = 12;

var WindowHandle Me;
var ButtonHandle btnBuff;
var WindowHandle SummonedStatusWnd1;
var WindowHandle SummonedStatusWnd2;
var WindowHandle SummonedStatusWnd3;
var WindowHandle SummonedStatusWnd4;
var NameCtrlHandle PetName;
var TextureHandle ClassIconSummon;
var BarHandle barHP_1;
var BarHandle barMP_1;
var StatusIconHandle m_StatusIconBuff[2];
var StatusIconHandle m_StatusIconDeBuff[2];
var StatusIconHandle m_StatusIconSongDance[2];
var StatusIconHandle m_StatusIconTriggerSkill[2];
var L2Util util;
var int summonedServerID[2];
var int m_CurBf;
var bool m_IsSummonedStatusShowEvent;
var EffectSwapWnd EffectSwapWnd_script;
var WindowHandle EffectSwapWnd;
var string LastPacketData;

function OnRegisterEvent()
{
    RegisterEvent(1100);
    RegisterEvent(1131);
    RegisterEvent(251);
    RegisterEvent(1110);
    RegisterEvent(1112);
    RegisterEvent(1113);
    RegisterEvent(1132);
    RegisterEvent(40);
    RegisterEvent(190);
    RegisterEvent(210);
    return;
}

function OnShow()
{
    return;
}

function OnHide()
{
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    util = L2Util(GetScript("L2Util"));
    m_IsSummonedStatusShowEvent = false;
    Initialize();
    return;
}

function Initialize()
{
    local int i;

    Me = GetWindowHandle("SummonedStatusWnd");
    btnBuff = GetButtonHandle("SummonedStatusWnd.btnBuff");
    SummonedStatusWnd1 = GetWindowHandle("SummonedStatusWnd.SummonedStatusWnd1");
    SummonedStatusWnd2 = GetWindowHandle("SummonedStatusWnd.SummonedStatusWnd2");
    SummonedStatusWnd3 = GetWindowHandle("SummonedStatusWnd.SummonedStatusWnd3");
    SummonedStatusWnd4 = GetWindowHandle("SummonedStatusWnd.SummonedStatusWnd4");
    PetName = GetNameCtrlHandle("SummonedStatusWnd.SummonedStatusWnd1.PetName");
    ClassIconSummon = GetTextureHandle("SummonedStatusWnd.SummonedStatusWnd1.ClassIconSummon");
    barHP_1 = GetBarHandle("SummonedStatusWnd.SummonedStatusWnd1.barHP_1");
    barMP_1 = GetBarHandle("SummonedStatusWnd.SummonedStatusWnd1.barMP_1");
    i = 0;
    J0x205:

    // End:0x3B1 [Loop If]
    if(i < 1)
    {
        m_StatusIconBuff[i] = GetStatusIconHandle((("SummonedStatusWnd.SummonedStatusWnd" $ string(i + 1)) $ ".StatusIconBuff") $ string(i + 1));
        m_StatusIconDeBuff[i] = GetStatusIconHandle((("SummonedStatusWnd.SummonedStatusWnd" $ string(i + 1)) $ ".StatusIconDebuff") $ string(i + 1));
        m_StatusIconSongDance[i] = GetStatusIconHandle((("SummonedStatusWnd.SummonedStatusWnd" $ string(i + 1)) $ ".StatusIconSongDance") $ string(i + 1));
        m_StatusIconTriggerSkill[i] = GetStatusIconHandle((("SummonedStatusWnd.SummonedStatusWnd" $ string(i + 1)) $ ".StatusIconTriggerSkill") $ string(i + 1));
        i++;
        // [Loop Continue]
        goto J0x205;
    }
    EffectSwapWnd_script = EffectSwapWnd(GetScript("EffectSwapWnd"));
    EffectSwapWnd = GetWindowHandle("EffectSwapWnd");
    clearBar();
    m_CurBf = 1;
    SetBuffButtonTooltip();
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x29
    if(m_IsSummonedStatusShowEvent)
    {
        // End:0x29
        if(summonedServerID[0] != -1)
        {
            Me.ShowWindow();
        }
    }
    GetINIInt("SummonedStatusWnd", "a", m_CurBf, "WindowsInfo.ini");
    SetBuffButtonTooltip();
    UpdateBuff(0);
    UpdateBuff(1);
    UpdateBuff(2);
    UpdateBuff(3);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int ServerID, currentHP, currentMP, SlotIndex;

    // End:0x81
    if(Event_ID == 190)
    {
        ParseInt(param, "ServerID", ServerID);
        ParseInt(param, "CurrentHP", currentHP);
        // End:0x7E
        if(ServerID != 0)
        {
            SlotIndex = GetIsSummonedSlotIndex(ServerID);
            // End:0x6E
            if(SlotIndex == -1)
            {
                return;
            }
            setStatusBarHP(SlotIndex, currentHP);
        }        
    }
    else
    {
        // End:0x102
        if(Event_ID == 210)
        {
            ParseInt(param, "ServerID", ServerID);
            ParseInt(param, "CurrentMP", currentMP);
            // End:0xFF
            if(ServerID != 0)
            {
                SlotIndex = GetIsSummonedSlotIndex(ServerID);
                // End:0xEF
                if(SlotIndex == -1)
                {
                    return;
                }
                setStatusBarMP(SlotIndex, currentMP);
            }            
        }
        else
        {
            // End:0x134
            if(Event_ID == 1100)
            {
                // End:0x12B
                if(GetGameStateName() != "GAMINGSTATE")
                {
                    return;
                }
                HandleSummonedStatusShow();                
            }
            else
            {
                // End:0x14C
                if(Event_ID == 1131)
                {
                    HandleSummonedStatusClose();                    
                }
                else
                {
                    // End:0x1A5
                    if(Event_ID == 251)
                    {
                        // End:0x172
                        if(GetGameStateName() != "GAMINGSTATE")
                        {
                            return;
                        }
                        ParseInt(param, "ServerID", ServerID);
                        // End:0x1A2
                        if(ServerID != 0)
                        {
                            HandleSummonInfoUpdate(ServerID);
                        }                        
                    }
                    else
                    {
                        // End:0x1C2
                        if(Event_ID == 1110)
                        {
                            HandleSummonedStatusSpelledList(param);                            
                        }
                        else
                        {
                            // End:0x1DF
                            if(Event_ID == 1112)
                            {
                                HandleSummonedStatusSpelledListDelete(param);                                
                            }
                            else
                            {
                                // End:0x1FC
                                if(Event_ID == 1113)
                                {
                                    HandleSummonedStatusSpelledListInsert(param);                                    
                                }
                                else
                                {
                                    // End:0x219
                                    if(Event_ID == 1132)
                                    {
                                        HandleSummonedDelete(param);                                        
                                    }
                                    else
                                    {
                                        // End:0x22B
                                        if(Event_ID == 40)
                                        {
                                            Restart();
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

function Restart()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x2D [Loop If]
    if(i < 1)
    {
        summonedServerID[i] = -1;
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
    local string btnName;

    btnName = a_ButtonHandle.GetWindowName();
    switch(btnName)
    {
        // End:0x31
        case "btnBuff":
            OnBuffButton();
            // End:0x37
            break;
        // End:0xFFFF
        default:
            // End:0x37
            break;
            break;
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local Rect rectWnd;
    local UserInfo UserInfo;
    local int ServerID, Num;
    local string WindowName;
    local WindowHandle hParent;

    rectWnd = Me.GetRect();
    // End:0x12A
    if((X > (rectWnd.nX + 14)) && X < ((rectWnd.nX + rectWnd.nWidth) - 20))
    {
        WindowName = a_WindowHandle.GetWindowName();
        // End:0x12A
        if(WindowName != "")
        {
            // End:0xBF
            if(Left(WindowName, 17) != "SummonedStatusWnd")
            {
                hParent = a_WindowHandle.GetParentWindowHandle();
                WindowName = hParent.GetWindowName();
            }
            Num = int(Right(WindowName, 1)) - 1;
            ServerID = summonedServerID[Num];
            // End:0x12A
            if(ServerID != -1)
            {
                // End:0x115
                if(GetPlayerInfo(UserInfo))
                {
                    RequestAction(ServerID, UserInfo.loc);
                }
                Debug("OnLButtonDown");
            }
        }
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x29
        case "btnOption":
            EffectSwapWnd_script.handlePage(3);
            // End:0x2F
            break;
        // End:0xFFFF
        default:
            // End:0x2F
            break;
            break;
    }
    return;
}

function HandleSummonedDelete(string param)
{
    local int ServerID, curreSlotIndex, firstSlotIndex;

    ParseInt(param, "serverID", ServerID);
    curreSlotIndex = GetIsSummonedSlotIndex(ServerID);
    // End:0x83
    if(curreSlotIndex > -1)
    {
        firstSlotIndex = getSummonedSlotIndex();
        // End:0x72
        if(firstSlotIndex > 1)
        {
            delStatus(curreSlotIndex, firstSlotIndex);
            reSizeWindow(firstSlotIndex - 1);            
        }
        else
        {
            summonedServerID[curreSlotIndex] = -1;
        }
    }
    return;
}

function HandleSummonedStatusClose()
{
    m_IsSummonedStatusShowEvent = false;
    clearBar();
    Me.HideWindow();
    PlayConsoleSound(6);
    return;
}

function HandleSummonedStatusShow()
{
    m_IsSummonedStatusShowEvent = true;
    Me.ShowWindow();
    return;
}

function int GetIsSummonedSlotIndex(int ServerID)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x37 [Loop If]
    if(i < 1)
    {
        // End:0x2D
        if(summonedServerID[i] == ServerID)
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

function int getSummonedSlotIndex()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x37 [Loop If]
    if(i < 1)
    {
        // End:0x2D
        if(summonedServerID[i] == -1)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return 1;
    return;
}

function clearBar()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x6E [Loop If]
    if(i < 1)
    {
        GetWindowHandle("SummonedStatusWnd.SummonedStatusWnd" $ string(i + 1)).HideWindow();
        summonedServerID[i] = -1;
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function HandleSummonedStatusSpelledList(string param)
{
    local int curreSlotIndex, i, Id, Max, BuffCnt, BuffCurRow,
	    DeBuffCnt, DeBuffCurRow, SongDanceCnt, SongDanceCurRow, TriggerSkillCnt,
	    TriggerSkillCurRow;

    local StatusIconInfo Info;

    ParseInt(param, "ID", Id);
    curreSlotIndex = GetIsSummonedSlotIndex(Id);
    DeBuffCurRow = -1;
    BuffCurRow = -1;
    SongDanceCurRow = -1;
    TriggerSkillCurRow = -1;
    LastPacketData = param;
    ParseInt(param, "ID", Id);
    Info.ServerID = Id;
    // End:0x8D
    if(curreSlotIndex < 0)
    {
        return;
    }
    m_StatusIconBuff[curreSlotIndex].Clear();
    m_StatusIconDeBuff[curreSlotIndex].Clear();
    m_StatusIconSongDance[curreSlotIndex].Clear();
    m_StatusIconTriggerSkill[curreSlotIndex].Clear();
    Info.Size = 16;
    Info.bShow = true;
    ParseInt(param, "Max", Max);
    i = 0;
    J0x117:

    // End:0x4B8 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "Sec_" $ string(i), Info.RemainTime);
        // End:0x1E6
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            // [Explicit Continue]
            goto J0x4AE;
        }
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x4AE
        if(IsValidItemID(Info.Id))
        {
            Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
            Info.bHideRemainTime = true;
            // End:0x363
            if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0) || EffectSwapWnd_script.getIsUsedObject(Info.Id.ClassID, 3))
            {
                // End:0x306
                if(EffectSwapWnd_script.getIsUsedObject(Info.Id.ClassID, 3))
                {
                    Info.BackTex = "L2UI_CT1.Buff.DeBuffFrame_16";                    
                }
                else
                {
                    Info.BackTex = "";
                }
                // End:0x33A
                if(DeBuffCnt == 0)
                {
                    DeBuffCurRow++;
                    m_StatusIconDeBuff[curreSlotIndex].AddRow();
                }
                m_StatusIconDeBuff[curreSlotIndex].AddCol(DeBuffCurRow, Info);
                DeBuffCnt++;
                // [Explicit Continue]
                goto J0x4AE;
            }
            // End:0x3DD
            if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                // End:0x3B4
                if(SongDanceCnt == 0)
                {
                    SongDanceCurRow++;
                    m_StatusIconSongDance[curreSlotIndex].AddRow();
                }
                m_StatusIconSongDance[curreSlotIndex].AddCol(SongDanceCurRow, Info);
                SongDanceCnt++;
                // [Explicit Continue]
                goto J0x4AE;
            }
            // End:0x457
            if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                // End:0x42E
                if(TriggerSkillCnt == 0)
                {
                    TriggerSkillCurRow++;
                    m_StatusIconTriggerSkill[curreSlotIndex].AddRow();
                }
                m_StatusIconTriggerSkill[curreSlotIndex].AddCol(TriggerSkillCurRow, Info);
                TriggerSkillCnt++;
                // [Explicit Continue]
                goto J0x4AE;
            }
            // End:0x488
            if((float(BuffCnt) % float(12)) == float(0))
            {
                BuffCurRow++;
                m_StatusIconBuff[curreSlotIndex].AddRow();
            }
            m_StatusIconBuff[curreSlotIndex].AddCol(BuffCurRow, Info);
            BuffCnt++;
        }
        J0x4AE:

        i++;
        // [Loop Continue]
        goto J0x117;
    }
    UpdateBuff(curreSlotIndex);
    return;
}

function HandleSummonedStatusSpelledListDelete(string param)
{
    local int i, Id, Max;
    local StatusIconInfo Info;
    local int curreSlotIndex;

    ParseInt(param, "ID", Id);
    curreSlotIndex = GetIsSummonedSlotIndex(Id);
    // End:0x32
    if(curreSlotIndex < 0)
    {
        return;
    }
    Info.ServerID = Id;
    ParseInt(param, "Max", Max);
    i = 0;
    J0x5E:

    // End:0x274 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x26A
        if(IsValidItemID(Info.Id))
        {
            // End:0x174
            if(GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0)
            {
                deleteBuff(m_StatusIconDeBuff[curreSlotIndex], Info.Level, Info.Id.ClassID, Info.SpellerID);
                // [Explicit Continue]
                goto J0x26A;
            }
            // End:0x1D5
            if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                deleteBuff(m_StatusIconSongDance[curreSlotIndex], Info.Level, Info.Id.ClassID, Info.SpellerID);
                // [Explicit Continue]
                goto J0x26A;
            }
            // End:0x236
            if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                deleteBuff(m_StatusIconTriggerSkill[curreSlotIndex], Info.Level, Info.Id.ClassID, Info.SpellerID);
                // [Explicit Continue]
                goto J0x26A;
            }
            deleteBuff(m_StatusIconBuff[curreSlotIndex], Info.Level, Info.Id.ClassID, Info.SpellerID);
        }
        J0x26A:

        i++;
        // [Loop Continue]
        goto J0x5E;
    }
    UpdateBuff(curreSlotIndex);
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

function copySpelledList(int fromIndex, int toIndex)
{
    local int row, Col;
    local StatusIconInfo Info;

    m_StatusIconDeBuff[toIndex].Clear();
    row = 0;
    J0x1C:

    // End:0xD2 [Loop If]
    if(row < m_StatusIconDeBuff[fromIndex].GetRowCount())
    {
        m_StatusIconDeBuff[toIndex].AddRow();
        Col = 0;
        J0x57:

        // End:0xC8 [Loop If]
        if(Col < m_StatusIconDeBuff[fromIndex].GetColCount(row))
        {
            m_StatusIconDeBuff[fromIndex].GetItem(row, Col, Info);
            m_StatusIconDeBuff[toIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x57;
        }
        row++;
        // [Loop Continue]
        goto J0x1C;
    }
    m_StatusIconSongDance[toIndex].Clear();
    row = 0;
    J0xEE:

    // End:0x1A4 [Loop If]
    if(row < m_StatusIconSongDance[fromIndex].GetRowCount())
    {
        m_StatusIconSongDance[toIndex].AddRow();
        Col = 0;
        J0x129:

        // End:0x19A [Loop If]
        if(Col < m_StatusIconSongDance[fromIndex].GetColCount(row))
        {
            m_StatusIconSongDance[fromIndex].GetItem(row, Col, Info);
            m_StatusIconSongDance[toIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x129;
        }
        row++;
        // [Loop Continue]
        goto J0xEE;
    }
    m_StatusIconTriggerSkill[toIndex].Clear();
    row = 0;
    J0x1C0:

    // End:0x276 [Loop If]
    if(row < m_StatusIconTriggerSkill[fromIndex].GetRowCount())
    {
        m_StatusIconTriggerSkill[toIndex].AddRow();
        Col = 0;
        J0x1FB:

        // End:0x26C [Loop If]
        if(Col < m_StatusIconTriggerSkill[fromIndex].GetColCount(row))
        {
            m_StatusIconTriggerSkill[fromIndex].GetItem(row, Col, Info);
            m_StatusIconTriggerSkill[toIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x1FB;
        }
        row++;
        // [Loop Continue]
        goto J0x1C0;
    }
    m_StatusIconBuff[toIndex].Clear();
    row = 0;
    J0x292:

    // End:0x348 [Loop If]
    if(row < m_StatusIconBuff[fromIndex].GetRowCount())
    {
        m_StatusIconBuff[toIndex].AddRow();
        Col = 0;
        J0x2CD:

        // End:0x33E [Loop If]
        if(Col < m_StatusIconBuff[fromIndex].GetColCount(row))
        {
            m_StatusIconBuff[fromIndex].GetItem(row, Col, Info);
            m_StatusIconBuff[toIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x2CD;
        }
        row++;
        // [Loop Continue]
        goto J0x292;
    }
    return;
}

function HandleSummonedStatusSpelledListInsert(string param)
{
    local int i, Id, Max;
    local StatusIconInfo Info;
    local StatusIconHandle tmpStatusIcon;
    local int curreSlotIndex;

    ParseInt(param, "ID", Id);
    curreSlotIndex = GetIsSummonedSlotIndex(Id);
    // End:0x32
    if(curreSlotIndex < 0)
    {
        return;
    }
    Info.ServerID = Id;
    Info.Size = 16;
    Info.bShow = true;
    ParseInt(param, "Max", Max);
    i = 0;
    J0x78:

    // End:0x2E8 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "Sec_" $ string(i), Info.RemainTime);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        Info.bHideRemainTime = true;
        // End:0x2DE
        if(IsValidItemID(Info.Id))
        {
            Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
            // End:0x1D4
            if(GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0)
            {
                tmpStatusIcon = m_StatusIconDeBuff[curreSlotIndex];                
            }
            else
            {
                // End:0x212
                if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
                {
                    tmpStatusIcon = m_StatusIconSongDance[curreSlotIndex];                    
                }
                else
                {
                    // End:0x250
                    if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
                    {
                        tmpStatusIcon = m_StatusIconTriggerSkill[curreSlotIndex];                        
                    }
                    else
                    {
                        tmpStatusIcon = m_StatusIconBuff[curreSlotIndex];
                    }
                }
            }
            // End:0x2B8
            if((tmpStatusIcon.GetRowCount() == 0) || (float(tmpStatusIcon.GetColCount(tmpStatusIcon.GetRowCount() - 1)) % float(12)) == float(0))
            {
                tmpStatusIcon.AddRow();
            }
            tmpStatusIcon.AddCol(tmpStatusIcon.GetRowCount() - 1, Info);
        }
        i++;
        // [Loop Continue]
        goto J0x78;
    }
    UpdateBuff(curreSlotIndex);
    return;
}

function UpdateBuff(int curreSlotIndex)
{
    // End:0x62
    if(m_CurBf == 1)
    {
        m_StatusIconBuff[curreSlotIndex].ShowWindow();
        m_StatusIconDeBuff[curreSlotIndex].ShowWindow();
        m_StatusIconSongDance[curreSlotIndex].HideWindow();
        m_StatusIconTriggerSkill[curreSlotIndex].HideWindow();        
    }
    else
    {
        // End:0xC5
        if(m_CurBf == 2)
        {
            m_StatusIconBuff[curreSlotIndex].HideWindow();
            m_StatusIconDeBuff[curreSlotIndex].HideWindow();
            m_StatusIconSongDance[curreSlotIndex].ShowWindow();
            m_StatusIconTriggerSkill[curreSlotIndex].HideWindow();            
        }
        else
        {
            // End:0x128
            if(m_CurBf == 3)
            {
                m_StatusIconBuff[curreSlotIndex].HideWindow();
                m_StatusIconDeBuff[curreSlotIndex].HideWindow();
                m_StatusIconSongDance[curreSlotIndex].HideWindow();
                m_StatusIconTriggerSkill[curreSlotIndex].ShowWindow();                
            }
            else
            {
                m_StatusIconBuff[curreSlotIndex].HideWindow();
                m_StatusIconDeBuff[curreSlotIndex].HideWindow();
                m_StatusIconSongDance[curreSlotIndex].HideWindow();
                m_StatusIconTriggerSkill[curreSlotIndex].HideWindow();
            }
        }
    }
    return;
}

function HandleShowBuffIcon(string param)
{
    local int nShow;

    ParseInt(param, "Show", nShow);
    // End:0x42
    if(nShow == 1)
    {
        UpdateBuff(0);
        UpdateBuff(1);
        UpdateBuff(2);
        UpdateBuff(3);        
    }
    else
    {
        UpdateBuff(0);
        UpdateBuff(1);
        UpdateBuff(2);
        UpdateBuff(3);
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
    SetINIInt("SummonedStatusWnd", "a", m_CurBf, "WindowsInfo.ini");
    SetBuffButtonTooltip();
    UpdateBuff(0);
    UpdateBuff(1);
    UpdateBuff(2);
    UpdateBuff(3);
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

function HandleSummonInfoUpdate(int ServerID)
{
    local SummonInfo Info;
    local int SlotIndex;

    // End:0x68
    if(GetSummonInfo(ServerID, Info))
    {
        SlotIndex = GetIsSummonedSlotIndex(ServerID);
        // End:0x5D
        if(SlotIndex == -1)
        {
            SlotIndex = getSummonedSlotIndex();
            inputStatus(SlotIndex, ServerID);
            reSizeWindow(SlotIndex + 1);
        }
        setStatusBar(SlotIndex);
    }
    return;
}

function delStatus(int SlotIndex, int firstSlotIndex)
{
    local int i;

    i = SlotIndex;
    J0x0B:

    // End:0x5F [Loop If]
    if(i < (firstSlotIndex - 1))
    {
        summonedServerID[i] = summonedServerID[i + 1];
        copySpelledList(i + 1, i);
        setStatusBar(i);
        i++;
        // [Loop Continue]
        goto J0x0B;
    }
    GetWindowHandle("SummonedStatusWnd.SummonedStatusWnd" $ string(firstSlotIndex)).HideWindow();
    summonedServerID[firstSlotIndex - 1] = -1;
    return;
}

function reSizeWindow(int firstSlotIndex)
{
    local int W, h, h2;

    h2 = MeHeight(firstSlotIndex);
    Me.GetWindowSize(W, h);
    Me.SetWindowSize(W, h2);
    Me.SetResizeFrameSize(10, h2);
    return;
}

function int MeHeight(int SlotIndex)
{
    return 50 * SlotIndex;
    return;
}

function inputStatus(int SlotIndex, int ServerID)
{
    summonedServerID[SlotIndex] = ServerID;
    GetWindowHandle("SummonedStatusWnd.SummonedStatusWnd" $ string(SlotIndex + 1)).ShowWindow();
    return;
}

function setStatusBar(int SlotIndex)
{
    local int ServerID;
    local SummonInfo Info;
    local int hp, MaxHP, mp, maxMP;
    local string Name;

    ServerID = summonedServerID[SlotIndex];
    // End:0x154
    if(GetSummonInfo(ServerID, Info))
    {
        hp = Info.nCurHP;
        MaxHP = Info.nMaxHP;
        mp = Info.nCurMP;
        maxMP = Info.nMaxMP;
        Name = Info.Name;
        GetNameCtrlHandle(("SummonedStatusWnd.SummonedStatusWnd" $ string(SlotIndex + 1)) $ ".PetName").SetName(Name, 0, 1);
        GetBarHandle(("SummonedStatusWnd" $ string(SlotIndex + 1)) $ ".barHP_1").SetValue(MaxHP, hp);
        GetBarHandle(("SummonedStatusWnd" $ string(SlotIndex + 1)) $ ".barMP_1").SetValue(maxMP, mp);
    }
    return;
}

function setStatusBarHP(int SlotIndex, int CurHP)
{
    local int ServerID;
    local SummonInfo Info;
    local int MaxHP;

    ServerID = summonedServerID[SlotIndex];
    // End:0x79
    if(GetSummonInfo(ServerID, Info))
    {
        MaxHP = Info.nMaxHP;
        GetBarHandle(("SummonedStatusWnd" $ string(SlotIndex + 1)) $ ".barHP_1").SetValue(MaxHP, CurHP);
    }
    return;
}

function setStatusBarMP(int SlotIndex, int curMP)
{
    local int ServerID;
    local SummonInfo Info;
    local int maxMP;

    ServerID = summonedServerID[SlotIndex];
    // End:0x79
    if(GetSummonInfo(ServerID, Info))
    {
        maxMP = Info.nMaxMP;
        GetBarHandle(("SummonedStatusWnd" $ string(SlotIndex + 1)) $ ".barMP_1").SetValue(maxMP, curMP);
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    local int row, Col;
    local StatusIconInfo Info;
    local SkillInfo SkillInfo;
    local StatusIconHandle StatusIcon;
    local string tmpNum;

    Col = Index / 10;
    row = Index - (Col * 10);
    tmpNum = Right(strID, 1);
    StatusIcon = GetStatusIconHandle((("SummonedStatusWnd.SummonedStatusWnd" $ tmpNum) $ ".") $ strID);
    StatusIcon.GetItem(row, Col, Info);
    // End:0xCA
    if(!GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
    {
        return;
    }
    // End:0x1DD
    if((((InStr(strID, "StatusIconBuff" $ tmpNum) > -1) || InStr(strID, "StatusIconDeBuff" $ tmpNum) > -1) || InStr(strID, "StatusIconSongDance" $ tmpNum) > -1) || InStr(strID, "StatusIconTriggerSkill" $ tmpNum) > -1)
    {
        // End:0x1D2
        if((SkillInfo.Debuff == 0) && SkillInfo.OperateType == 1)
        {
            RequestDispel(Info.ServerID, Info.Id, Info.Level, Info.SubLevel);            
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
    local string Username;
    local UserInfo targetUserInfo;
    local int ServerID, Num;
    local string WindowName;
    local WindowHandle hParent;

    rectWnd = Me.GetRect();
    // End:0x1C0
    if((X > rectWnd.nX) && X < (rectWnd.nX + rectWnd.nWidth))
    {
        // End:0x1C0
        if((Y > rectWnd.nY) && Y < (rectWnd.nY + rectWnd.nHeight))
        {
            WindowName = a_WindowHandle.GetWindowName();
            // End:0x111
            if(WindowName != "")
            {
                // End:0xED
                if(Left(WindowName, 17) != "SummonedStatusWnd")
                {
                    hParent = a_WindowHandle.GetParentWindowHandle();
                    WindowName = hParent.GetWindowName();
                }
                Num = int(Right(WindowName, 1)) - 1;
                ServerID = summonedServerID[Num];
            }
            // End:0x1C0
            if(ServerID > 0)
            {
                Username = Class'NWindow.UIDATA_USER'.static.GetUserName(ServerID);
                // End:0x193
                if(Username != "")
                {
                    // End:0x150
                    if(GetTargetInfo(targetUserInfo))
                    {
                    }
                    // End:0x16F
                    if(targetUserInfo.nID != ServerID)
                    {
                        setTargetByServerID(ServerID);
                    }
                    getInstanceContextMenu().execContextEvent(Username, ServerID, X, Y);
                }
                Debug("ï¿½ï¿½ Å¬ï¿½ï¿½ " @ Username);
            }
        }
    }
    return;
}
