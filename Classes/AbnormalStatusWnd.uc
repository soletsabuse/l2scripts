class AbnormalStatusWnd extends UICommonAPI;

const NSTATUSICON_FRAMESIZE = 12;
const NSTATUSICON_MAXCOL = 12;

var int m_NormalStatusRow;
var int m_DebuffRow;
var int m_EtcStatusRow;
var int m_ShortStatusRow;
var int m_SongDanceStatusRow;
var int m_TriggerSkillRow;
var bool m_bOnCurState;
var WindowHandle Me;
var StatusIconHandle StatusIcon;
var EffectSwapWnd EffectSwapWnd_script;
var WindowHandle EffectSwapWnd;
var CheckBoxHandle swapEffectCBox;
var CheckBoxHandle separateDebuffCBox;
var int custom_SingleBuffBar;
var string LastPacketData;

function OnRegisterEvent()
{
    RegisterEvent(950);
    RegisterEvent(960);
    RegisterEvent(970);
    RegisterEvent(40);
    RegisterEvent(310);
    RegisterEvent(1900);
    RegisterEvent(3410);
    return;
}

function OnLoad()
{
    m_DebuffRow = -1;
    m_NormalStatusRow = -1;
    m_EtcStatusRow = -1;
    m_ShortStatusRow = -1;
    m_SongDanceStatusRow = -1;
    m_TriggerSkillRow = -1;
    m_bOnCurState = false;
    InitHandle();
    return;
}

function InitHandle()
{
    Me = GetWindowHandle("AbnormalStatusWnd");
    StatusIcon = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon");
    swapEffectCBox = GetCheckBoxHandle("AbnormalStatusWnd.swapEffectCBox");
    separateDebuffCBox = GetCheckBoxHandle("AbnormalStatusWnd.separateDebuffCBox");
    separateDebuffCBox.SetCheck(GetOptionBool("Game", "DebuffSeparate"));
    separateDebuffCBox.ShowWindow();
    EffectSwapWnd_script = EffectSwapWnd(GetScript("EffectSwapWnd"));
    EffectSwapWnd = GetWindowHandle("EffectSwapWnd");
    return;
}

function OnEnterState(name a_PreStateName)
{
    m_bOnCurState = true;
    UpdateWindowSize();
    return;
}

function OnExitState(name a_NextStateName)
{
    m_bOnCurState = false;
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1D
    if(Event_ID == 950)
    {
        HandleAddNormalStatus(param);        
    }
    else
    {
        // End:0x3A
        if(Event_ID == 960)
        {
            HandleAddEtcStatus(param);            
        }
        else
        {
            // End:0x57
            if(Event_ID == 970)
            {
                HandleAddShortStatus(param);                
            }
            else
            {
                // End:0x6C
                if(Event_ID == 40)
                {
                    HandleRestart();                    
                }
                else
                {
                    // End:0x84
                    if(Event_ID == 310)
                    {
                        HandleShowReplayQuitDialogBox();                        
                    }
                    else
                    {
                        // End:0x99
                        if(Event_ID == 1900)
                        {
                            HandleLanguageChanged();
                        }
                    }
                }
            }
        }
    }
    // End:0xC5
    if(Event_ID == 3410)
    {
        // End:0xC5
        if(param == "GAMINGSTATE")
        {
            UpdateWindowSize();
        }
    }
    return;
}

function HandleRestart()
{
    ClearAll();
    return;
}

function HandleShowReplayQuitDialogBox()
{
    Me.HideWindow();
    return;
}

function OnShow()
{
    local int RowCount;

    RowCount = StatusIcon.GetRowCount();
    // End:0x2F
    if(RowCount < 1)
    {
        Me.HideWindow();
    }
    return;
}

function ClearStatus(bool bEtcItem, bool bShortItem)
{
    local int i, j, RowCount, RowCountTmp, ColCount;

    local StatusIconInfo Info;

    // End:0x46
    if((bEtcItem == false) && bShortItem == false)
    {
        m_NormalStatusRow = -1;
        m_SongDanceStatusRow = -1;
        m_DebuffRow = -1;
        m_TriggerSkillRow = -1;
    }
    // End:0x76
    if((bEtcItem == true) && bShortItem == false)
    {
        m_EtcStatusRow = -1;
        m_ShortStatusRow = -1;
    }
    // End:0x9B
    if((bEtcItem == false) && bShortItem == true)
    {
        m_ShortStatusRow = -1;
    }
    RowCount = StatusIcon.GetRowCount();
    i = 0;
    J0xB7:

    // End:0x1C2 [Loop If]
    if(i < RowCount)
    {
        ColCount = StatusIcon.GetColCount(i);
        j = 0;
        J0xE7:

        // End:0x1B8 [Loop If]
        if(j < ColCount)
        {
            StatusIcon.GetItem(i, j, Info);
            // End:0x1AE
            if(IsValidItemID(Info.Id))
            {
                // End:0x1AE
                if((Info.bEtcItem == bEtcItem) && Info.bShortItem == bShortItem)
                {
                    StatusIcon.DelItem(i, j);
                    j--;
                    ColCount--;
                    RowCountTmp = StatusIcon.GetRowCount();
                    // End:0x1AE
                    if(RowCountTmp != RowCount)
                    {
                        i--;
                        RowCount--;
                    }
                }
            }
            j++;
            // [Loop Continue]
            goto J0xE7;
        }
        i++;
        // [Loop Continue]
        goto J0xB7;
    }
    return;
}

function ClearAll()
{
    ClearStatus(false, false);
    ClearStatus(true, false);
    ClearStatus(false, true);
    return;
}

function handleArenaSeal(int ClassID, string Name, int Level)
{
    local string param;

    // End:0x86
    if(ClassID == 30799)
    {
        param = "";
        ParamAdd(param, "classID", string(ClassID));
        ParamAdd(param, "Name", Name);
        ParamAdd(param, "Level", string(Level));
        CallGFxFunction("ArenaScoreBoardHUD", "seal", param);
    }
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x51
        case "swapEffectCBox":
            // End:0x3F
            if(swapEffectCBox.IsChecked())
            {
                EffectSwapWnd_script.handlePage(1);                
            }
            else
            {
                EffectSwapWnd_script.handleOpen();
            }
            // End:0x1A4
            break;
        // End:0x19E
        case "separateDebuffCBox":
            // End:0xC7
            if(separateDebuffCBox.IsChecked())
            {
                AbnormalStatusDebuffWnd(GetScript("AbnormalStatusDebuffWnd")).HandleAddNormalStatus(GetCurrentEffectParam(StatusIcon));
                HandleAddNormalStatus(GetCurrentEffectParam(StatusIcon));                
            }
            else
            {
                HandleAddNormalStatus(GetCurrentEffectParam(StatusIcon, AbnormalStatusDebuffWnd(GetScript("AbnormalStatusDebuffWnd")).StatusIcon));
                AbnormalStatusDebuffWnd(GetScript("AbnormalStatusDebuffWnd")).ClearAll();
            }
            SetOptionBool("Game", "DebuffSeparate", separateDebuffCBox.IsChecked());
            AbnormalStatusDebuffWnd(GetScript("AbnormalStatusDebuffWnd")).showHideWindow(separateDebuffCBox.IsChecked());
            // End:0x1A4
            break;
        // End:0xFFFF
        default:
            // End:0x1A4
            break;
            break;
    }
    return;
}

function HandleAddNormalStatus(string param)
{
    local int i, Max, BuffCnt, DeBuffCnt;
    local string str1, str2;
    local StatusIconInfo Info;
    local int TriggerBuffCount;
    local string Icon;
    local array<StatusIconInfo> arrSongDance, arrTriggerSkill, arrDebuff, arrBuff;

    LastPacketData = param;
    ClearStatus(false, false);
    Info.Size = 24;
    Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
    Info.bShow = true;
    Info.bEtcItem = false;
    Info.bShortItem = false;
    BuffCnt = 0;
    DeBuffCnt = 0;
    TriggerBuffCount = 0;
    ParseInt(param, "ServerID", Info.ServerID);
    ParseInt(param, "Max", Max);
    i = 0;
    J0xC0:

    // End:0x3FB [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "SkillLevel_" $ string(i), Info.Level);
        ParseInt(param, "SkillSubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "RemainTime_" $ string(i), Info.RemainTime);
        ParseString(param, "Name_" $ string(i), Info.Name);
        ParseString(param, "IconName_" $ string(i), Info.IconName);
        ParseString(param, "Description_" $ string(i), Info.Description);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x24D
        if(getInstanceUIData().getIsArenaServer())
        {
            handleArenaSeal(Info.Id.ClassID, Info.Name, Info.Level);
        }
        // End:0x3F1
        if(IsValidItemID(Info.Id))
        {
            // End:0x2AA
            if(EffectSwapWnd_script.getIsUsedObject(Info.Id.ClassID, 1))
            {
                arrDebuff.Length = arrDebuff.Length + 1;
                arrDebuff[arrDebuff.Length - 1] = Info;
                // [Explicit Continue]
                goto J0x3F1;
            }
            // End:0x2F9
            if(IsSongDance(Info.Id, Info.Level, Info.SubLevel))
            {
                arrSongDance.Length = arrSongDance.Length + 1;
                arrSongDance[arrSongDance.Length - 1] = Info;
                // [Explicit Continue]
                goto J0x3F1;
            }
            // End:0x348
            if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel))
            {
                arrTriggerSkill.Length = arrTriggerSkill.Length + 1;
                arrTriggerSkill[arrTriggerSkill.Length - 1] = Info;
                // [Explicit Continue]
                goto J0x3F1;
            }
            // End:0x39A
            if(GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0)
            {
                arrDebuff.Length = arrDebuff.Length + 1;
                arrDebuff[arrDebuff.Length - 1] = Info;
                // [Explicit Continue]
                goto J0x3F1;
            }
            // End:0x3F1
            if(!Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
            {
                arrBuff.Length = arrBuff.Length + 1;
                arrBuff[arrBuff.Length - 1] = Info;
            }
        }
        J0x3F1:

        i++;
        // [Loop Continue]
        goto J0xC0;
    }
    i = 0;
    J0x402:

    // End:0x482 [Loop If]
    if(i < arrSongDance.Length)
    {
        // End:0x459
        if(m_SongDanceStatusRow == -1)
        {
            m_SongDanceStatusRow = m_NormalStatusRow + 1;
            StatusIcon.InsertRow(m_SongDanceStatusRow);
            // End:0x459
            if(m_DebuffRow > -1)
            {
                m_DebuffRow++;
            }
        }
        StatusIcon.AddCol(m_SongDanceStatusRow, arrSongDance[i]);
        i++;
        // [Loop Continue]
        goto J0x402;
    }
    i = 0;
    J0x489:

    // End:0x5B9 [Loop If]
    if(i < arrTriggerSkill.Length)
    {
        // End:0x4F4
        if((m_TriggerSkillRow == -1) && m_SongDanceStatusRow == -1)
        {
            m_TriggerSkillRow = m_NormalStatusRow + 1;
            StatusIcon.InsertRow(m_TriggerSkillRow);
            // End:0x4F1
            if(m_DebuffRow > -1)
            {
                m_DebuffRow++;
            }            
        }
        else
        {
            // End:0x54C
            if((m_TriggerSkillRow == -1) && m_SongDanceStatusRow > -1)
            {
                m_TriggerSkillRow = m_SongDanceStatusRow + 1;
                StatusIcon.InsertRow(m_TriggerSkillRow);
                // End:0x54C
                if(m_DebuffRow > -1)
                {
                    m_DebuffRow++;
                }
            }
        }
        // End:0x589
        if(TriggerBuffCount == 12)
        {
            m_TriggerSkillRow++;
            StatusIcon.InsertRow(m_TriggerSkillRow);
            // End:0x589
            if(m_DebuffRow > -1)
            {
                m_DebuffRow++;
            }
        }
        StatusIcon.AddCol(m_TriggerSkillRow, arrTriggerSkill[i]);
        TriggerBuffCount++;
        i++;
        // [Loop Continue]
        goto J0x489;
    }
    // End:0x7A4
    if(!separateDebuffCBox.IsChecked())
    {
        i = 0;
        J0x5D4:

        // End:0x7A4 [Loop If]
        if(i < arrDebuff.Length)
        {
            // End:0x63A
            if(((m_DebuffRow == -1) && m_SongDanceStatusRow == -1) && m_TriggerSkillRow == -1)
            {
                m_DebuffRow = m_NormalStatusRow + 1;
                StatusIcon.InsertRow(m_DebuffRow);                
            }
            else
            {
                // End:0x690
                if(((m_DebuffRow == -1) && m_SongDanceStatusRow > -1) && m_TriggerSkillRow == -1)
                {
                    m_DebuffRow = m_SongDanceStatusRow + 1;
                    StatusIcon.InsertRow(m_DebuffRow);                    
                }
                else
                {
                    // End:0x6E6
                    if(((m_DebuffRow == -1) && m_SongDanceStatusRow == -1) && m_TriggerSkillRow > -1)
                    {
                        m_DebuffRow = m_TriggerSkillRow + 1;
                        StatusIcon.InsertRow(m_DebuffRow);                        
                    }
                    else
                    {
                        // End:0x739
                        if(((m_DebuffRow == -1) && m_SongDanceStatusRow > -1) && m_TriggerSkillRow > -1)
                        {
                            m_DebuffRow = m_TriggerSkillRow + 1;
                            StatusIcon.InsertRow(m_DebuffRow);
                        }
                    }
                }
            }
            // End:0x774
            if(DeBuffCnt != 0)
            {
                // End:0x774
                if((float(DeBuffCnt) % float(12)) == float(0))
                {
                    m_DebuffRow++;
                    StatusIcon.InsertRow(m_DebuffRow);
                }
            }
            StatusIcon.AddCol(m_DebuffRow, arrDebuff[i]);
            DeBuffCnt++;
            i++;
            // [Loop Continue]
            goto J0x5D4;
        }
    }
    i = 0;
    J0x7AB:

    // End:0x81B [Loop If]
    if(i < arrBuff.Length)
    {
        // End:0x7EB
        if((float(BuffCnt) % float(12)) == float(0))
        {
            m_NormalStatusRow++;
            StatusIcon.InsertRow(m_NormalStatusRow);
        }
        StatusIcon.AddCol(m_NormalStatusRow, arrBuff[i]);
        BuffCnt++;
        i++;
        // [Loop Continue]
        goto J0x7AB;
    }
    // End:0x88F
    if(m_EtcStatusRow > -1)
    {
        m_EtcStatusRow = m_NormalStatusRow + 1;
        // End:0x855
        if(m_SongDanceStatusRow > -1)
        {
            m_EtcStatusRow = m_SongDanceStatusRow + 1;
        }
        // End:0x872
        if(m_TriggerSkillRow > -1)
        {
            m_EtcStatusRow = m_TriggerSkillRow + 1;
        }
        // End:0x88F
        if(m_DebuffRow > -1)
        {
            m_EtcStatusRow = m_DebuffRow + 1;
        }
    }
    // End:0x903
    if(m_ShortStatusRow > -1)
    {
        m_ShortStatusRow = m_NormalStatusRow + 1;
        // End:0x8C9
        if(m_SongDanceStatusRow > -1)
        {
            m_ShortStatusRow = m_SongDanceStatusRow + 1;
        }
        // End:0x8E6
        if(m_TriggerSkillRow > -1)
        {
            m_ShortStatusRow = m_TriggerSkillRow + 1;
        }
        // End:0x903
        if(m_DebuffRow > -1)
        {
            m_ShortStatusRow = m_DebuffRow + 1;
        }
    }
    UpdateWindowSize();
    return;
}

function HandleAddEtcStatus(string param)
{
    local int i, Max, BuffCnt, CurRow;
    local bool bNewRow;
    local StatusIconInfo Info;

    ClearStatus(true, false);
    Info.Size = 24;
    Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
    Info.bShow = true;
    Info.bEtcItem = true;
    Info.bShortItem = false;
    // End:0x8A
    if(m_ShortStatusRow > -1)
    {
        bNewRow = false;
        CurRow = m_ShortStatusRow;        
    }
    else
    {
        bNewRow = true;
        CurRow = m_NormalStatusRow;
        // End:0xB3
        if(m_SongDanceStatusRow > -1)
        {
            CurRow++;
        }
        // End:0xC9
        if(m_DebuffRow > -1)
        {
            CurRow++;
        }
        // End:0xDF
        if(m_TriggerSkillRow > -1)
        {
            CurRow++;
        }
    }
    BuffCnt = 0;
    ParseInt(param, "Max", Max);
    i = 0;
    J0x102:

    // End:0x276 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "SkillLevel_" $ string(i), Info.Level);
        ParseInt(param, "RemainTime_" $ string(i), Info.RemainTime);
        ParseString(param, "Name_" $ string(i), Info.Name);
        ParseString(param, "IconName_" $ string(i), Info.IconName);
        ParseString(param, "Description_" $ string(i), Info.Description);
        // End:0x26C
        if(IsValidItemID(Info.Id))
        {
            // End:0x241
            if(bNewRow)
            {
                bNewRow = !bNewRow;
                CurRow++;
                StatusIcon.InsertRow(CurRow);
            }
            StatusIcon.AddCol(CurRow, Info);
            m_EtcStatusRow = CurRow;
            BuffCnt++;
        }
        i++;
        // [Loop Continue]
        goto J0x102;
    }
    UpdateWindowSize();
    return;
}

function HandleAddShortStatus(string param)
{
    local int i, Max, BuffCnt, CurRow, CurCol;

    local bool bNewRow;
    local StatusIconInfo Info;

    ClearStatus(false, true);
    Info.Size = 24;
    Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
    Info.bShow = true;
    Info.bEtcItem = false;
    Info.bShortItem = true;
    CurCol = -1;
    // End:0x95
    if(m_EtcStatusRow > -1)
    {
        bNewRow = false;
        CurRow = m_EtcStatusRow;        
    }
    else
    {
        bNewRow = true;
        CurRow = m_NormalStatusRow;
        // End:0xC2
        if(m_SongDanceStatusRow > -1)
        {
            CurRow = m_SongDanceStatusRow;
        }
        // End:0xDC
        if(m_TriggerSkillRow > -1)
        {
            CurRow = m_TriggerSkillRow;
        }
        // End:0xF6
        if(m_DebuffRow > -1)
        {
            CurRow = m_DebuffRow;
        }
    }
    BuffCnt = 0;
    ParseInt(param, "Max", Max);
    i = 0;
    J0x119:

    // End:0x2C7 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "SkillLevel_" $ string(i), Info.Level);
        ParseInt(param, "SkillSubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "RemainTime_" $ string(i), Info.RemainTime);
        ParseString(param, "Name_" $ string(i), Info.Name);
        ParseString(param, "IconName_" $ string(i), Info.IconName);
        ParseString(param, "Description_" $ string(i), Info.Description);
        // End:0x2BD
        if(IsValidItemID(Info.Id))
        {
            // End:0x286
            if(bNewRow)
            {
                bNewRow = !bNewRow;
                CurRow++;
                StatusIcon.InsertRow(CurRow);
            }
            CurCol++;
            StatusIcon.InsertCol(CurRow, CurCol, Info);
            m_ShortStatusRow = CurRow;
            BuffCnt++;
        }
        i++;
        // [Loop Continue]
        goto J0x119;
    }
    UpdateWindowSize();
    return;
}

function UpdateWindowSize()
{
    local int RowCount;
    local Rect rectWnd;

    RowCount = StatusIcon.GetRowCount();
    // End:0x101
    if(RowCount > 0)
    {
        // End:0x5B
        if(m_bOnCurState && GetGameStateName() != "TRAININGROOMSTATE")
        {
            Me.ShowWindow();            
        }
        else
        {
            Me.HideWindow();
        }
        rectWnd = StatusIcon.GetRect();
        Me.SetWindowSize(rectWnd.nWidth + 12, rectWnd.nHeight);
        Me.SetFrameSize(12, rectWnd.nHeight);
        separateDebuffCBox.SetAnchor("AbnormalStatusWnd", "BottomLeft", "TopLeft", 0, -9);        
    }
    else
    {
        Me.HideWindow();
    }
    return;
}

function HandleLanguageChanged()
{
    local int i, j, RowCount, ColCount;
    local StatusIconInfo Info;

    RowCount = StatusIcon.GetRowCount();
    i = 0;
    J0x1C:

    // End:0x12E [Loop If]
    if(i < RowCount)
    {
        ColCount = StatusIcon.GetColCount(i);
        j = 0;
        J0x4C:

        // End:0x124 [Loop If]
        if(j < ColCount)
        {
            StatusIcon.GetItem(i, j, Info);
            // End:0x11A
            if(IsValidItemID(Info.Id))
            {
                Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, Info.SubLevel);
                Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, Info.SubLevel);
                StatusIcon.SetItem(i, j, Info);
            }
            j++;
            // [Loop Continue]
            goto J0x4C;
        }
        i++;
        // [Loop Continue]
        goto J0x1C;
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    local int row, Col;
    local StatusIconInfo Info;
    local SkillInfo SkillInfo;

    Col = Index / 10;
    row = Index - (Col * 10);
    StatusIcon.GetItem(row, Col, Info);
    // End:0x78
    if(!GetSkillInfo(Info.Id.ClassID, Info.Level, Info.SubLevel, SkillInfo))
    {
        return;
    }
    // End:0xF3
    if(InStr(strID, "StatusIcon") > -1)
    {
        // End:0xE8
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

function addEffectInList(int ClassID, int Level)
{
    local int row, Col, RowCount, ColCount;
    local StatusIconInfo Info;
    local bool bFound;

    RowCount = StatusIcon.GetRowCount();
    row = 0;
    J0x1C:

    // End:0xBD [Loop If]
    if(row < RowCount)
    {
        ColCount = StatusIcon.GetColCount(row);
        Col = 0;
        J0x4C:

        // End:0xA7 [Loop If]
        if(Col < ColCount)
        {
            StatusIcon.GetItem(row, Col, Info);
            // End:0x9D
            if(Info.Id.ClassID == ClassID)
            {
                bFound = true;
                // [Explicit Break]
                goto J0xA7;
            }
            Col++;
            // [Loop Continue]
            goto J0x4C;
        }
        J0xA7:

        // End:0xB3
        if(bFound)
        {
            // [Explicit Break]
            goto J0xBD;
        }
        row++;
        // [Loop Continue]
        goto J0x1C;
    }
    J0xBD:

    // End:0x226
    if(!bFound)
    {
        Info.Id.ClassID = ClassID;
        Info.Level = Level;
        Info.SubLevel = 0;
        Info.RemainTime = 10000;
        Info.Name = "Combat Mode";
        Info.IconName = "UI_BOHPTS.Icons.Action097";
        Info.Description = "Combat Mode ON";
        Info.Size = 24;
        Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
        Info.bShow = true;
        Info.bEtcItem = false;
        Info.bShortItem = true;
        Info.ServerID = -1;
        // End:0x207
        if(m_ShortStatusRow == -1)
        {
            m_ShortStatusRow = StatusIcon.GetRowCount();
            StatusIcon.InsertRow(m_ShortStatusRow);
        }
        StatusIcon.AddCol(m_ShortStatusRow, Info);
        UpdateWindowSize();
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x28
        case "btnOption":
            EffectSwapWnd_script.handlePage(1);
            // End:0x2E
            break;
        // End:0xFFFF
        default:
            // End:0x2E
            break;
            break;
    }
    return;
}
