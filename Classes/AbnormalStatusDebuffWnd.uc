class AbnormalStatusDebuffWnd extends UICommonAPI;

const NSTATUSICON_FRAMESIZE = 12;
const NSTATUSICON_MAXCOL = 12;

var int m_DebuffRow;
var bool m_bOnCurState;
var WindowHandle Me;
var StatusIconHandle StatusIcon;
var CheckBoxHandle settingsCBox;
var AbnormalSettingsWnd AbnormalSettings;
var array<StatusIconInfo> arrDebuff;
var EffectSwapWnd EffectSwapWnd_script;
var string LastPacketData;
var int nStatusIconSize;

function OnRegisterEvent()
{
    RegisterEvent(950);
    RegisterEvent(40);
    RegisterEvent(3410);
    return;
}

function OnShow()
{
    // End:0x24
    if(StatusIcon.GetRowCount() < 1)
    {
        Me.HideWindow();
    }
    return;
}

function OnHide()
{
    AbnormalSettings.showHide(false);
    settingsCBox.SetCheck(false);
    return;
}

function OnLoad()
{
    m_DebuffRow = -1;
    m_bOnCurState = false;
    InitHandle();
    return;
}

function InitHandle()
{
    Me = GetWindowHandle("AbnormalStatusDebuffWnd");
    StatusIcon = GetStatusIconHandle("AbnormalStatusDebuffWnd.StatusIcon");
    settingsCBox = GetCheckBoxHandle("AbnormalStatusDebuffWnd.settingsCBox");
    AbnormalSettings = AbnormalSettingsWnd(GetScript("AbnormalSettingsWnd"));
    EffectSwapWnd_script = EffectSwapWnd(GetScript("EffectSwapWnd"));
    AbnormalSettings.DebuffSizeSlider.SetCurrentTick(GetOptionInt("Game", "AbnormalSize"));
    nStatusIconSize = GetOptionInt("Game", "AbnormalSize");
    // End:0x133
    if(nStatusIconSize <= 24)
    {
        nStatusIconSize = 24;
    }
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
    // End:0x38
    if(!AbnormalStatusWnd(GetScript("AbnormalStatusWnd")).separateDebuffCBox.IsChecked())
    {
        return;
    }
    switch(Event_ID)
    {
        // End:0x55
        case 950:
            HandleAddNormalStatus(param);
            // End:0x91
            break;
        // End:0x63
        case 40:
            HandleRestart();
            // End:0x91
            break;
        // End:0x8B
        case 3410:
            // End:0x88
            if(param == "GAMINGSTATE")
            {
                UpdateWindowSize();
            }
            // End:0x91
            break;
        // End:0xFFFF
        default:
            // End:0x91
            break;
            break;
    }
    return;
}

function HandleRestart()
{
    ClearAll();
    return;
}

function ClearAll()
{
    local int i, j, RowCount, ColCount;
    local StatusIconInfo Info;

    RowCount = StatusIcon.GetRowCount();
    i = 0;
    J0x1C:

    // End:0x141 [Loop If]
    if(i < RowCount)
    {
        ColCount = StatusIcon.GetColCount(i);
        j = 0;
        J0x4C:

        // End:0x137 [Loop If]
        if(j < ColCount)
        {
            StatusIcon.GetItem(i, j, Info);
            // End:0x12D
            if(((IsValidItemID(Info.Id)) && GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0) || EffectSwapWnd_script.getIsUsedObject(Info.Id.ClassID, 1))
            {
                StatusIcon.DelItem(i, j);
                j--;
                ColCount--;
                // End:0x12D
                if(StatusIcon.GetRowCount() != RowCount)
                {
                    i--;
                    RowCount--;
                    // [Explicit Break]
                    goto J0x137;
                }
            }
            j++;
            // [Loop Continue]
            goto J0x4C;
        }
        J0x137:

        i++;
        // [Loop Continue]
        goto J0x1C;
    }
    m_DebuffRow = -1;
    return;
}

function ClearTime()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x68 [Loop If]
    if(i < 12)
    {
        GetTextBoxHandle("AbnormalStatusDebuffWnd.TimeTx" $ getInstanceL2Util().makeZeroString(2, (i))).HideWindow();
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function anchorTime(int Index, int iconSize)
{
    local TextBoxHandle Box;
    local int iconActualSize, row, Col, cellX, cellY, textWidth,
	    textHeight, OffsetX, OffsetY;

    local string FontName;

    Box = GetTextBoxHandle("AbnormalStatusDebuffWnd.TimeTx" $ getInstanceL2Util().makeZeroString(2, (Index)));
    iconActualSize = iconSize;
    // End:0x65
    if(iconActualSize <= 0)
    {
        iconActualSize = 24;
    }
    row = Index / 12;
    Col = int(float(Index) % float(12));
    cellX = Col * (iconActualSize + 2);
    cellY = row * (iconActualSize + 2);
    FontName = sizeToFont(iconActualSize);
    Box.SetFontIDByName(FontName);
    GetTextSize(Box.GetText(), FontName, textWidth, textHeight);
    switch(iconActualSize)
    {
        // End:0x11C
        case 12:
            OffsetX = 16;
            OffsetY = 1;
            // End:0x1A6
            break;
        // End:0x133
        case 16:
            OffsetX = 16;
            OffsetY = 1;
            // End:0x1A6
            break;
        // End:0x14B
        case 24:
            OffsetX = 16;
            OffsetY = 2;
            // End:0x1A6
            break;
        // End:0x163
        case 32:
            OffsetX = 16;
            OffsetY = 2;
            // End:0x1A6
            break;
        // End:0x17B
        case 48:
            OffsetX = 15;
            OffsetY = 2;
            // End:0x1A6
            break;
        // End:0x192
        case 64:
            OffsetX = 15;
            OffsetY = 1;
            // End:0x1A6
            break;
        // End:0xFFFF
        default:
            OffsetX = 0;
            OffsetY = 0;
            // End:0x1A6
            break;
            break;
    }
    Box.SetAnchor(Me.GetWindowName(), "TopLeft", "TopLeft", (cellX + ((iconActualSize - textWidth) / 2)) + OffsetX, (cellY + ((iconActualSize - textHeight) / 2)) + OffsetY);
    Box.HideWindow();
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x66
        case "settingsCBox":
            // End:0x48
            if(settingsCBox.IsChecked())
            {
                ShowW("AbnormalSettingsWnd");                
            }
            else
            {
                HideW("AbnormalSettingsWnd");
            }
            // End:0x6C
            break;
        // End:0xFFFF
        default:
            // End:0x6C
            break;
            break;
    }
    return;
}

function OnTimer(int TimerID)
{
    local int Index;
    local StatusIconInfo Info;
    local TextBoxHandle Box;

    // End:0x177
    if(TimerID >= 100000000)
    {
        Me.KillTimer(TimerID);
        Index = TimerID - 100000000;
        Box = GetTextBoxHandle("AbnormalStatusDebuffWnd.TimeTx" $ getInstanceL2Util().makeZeroString(2, (Index)));
        StatusIcon.GetItem(0, Index, Info);
        // End:0xCC
        if(Info.RemainTime <= 0)
        {
            StatusIcon.DelItem(0, Index);
            Box.HideWindow();
            return;
        }
        Me.SetTimer(TimerID, 1000);
        // End:0x177
        if(Info.RemainTime < 100)
        {
            Box = GetTextBoxHandle("AbnormalStatusDebuffWnd.TimeTx" $ getInstanceL2Util().makeZeroString(2, (Index)));
            Box.SetText(string(Info.RemainTime));
            anchorTime(Index, nStatusIconSize);
            Box.ShowWindow();
        }
    }
    return;
}

function HandleAddNormalStatus(string param)
{
    local int i, Max, DeBuffCnt;
    local StatusIconInfo Info;
    local string Icon;

    arrDebuff.Remove(0, arrDebuff.Length);
    ClearAll();
    // End:0x34
    if((nStatusIconSize <= 0) || nStatusIconSize > 64)
    {
        nStatusIconSize = 24;
    }
    Info.Size = nStatusIconSize;
    Info.BackTex = "L2UI_NewTex.ToolTip.SkillGradeTooltip_BG_A";
    Info.bShow = true;
    Info.bEtcItem = false;
    Info.bShortItem = false;
    Info.bHideRemainTime = true;
    DeBuffCnt = 0;
    ParseInt(param, "Max", Max);
    LastPacketData = param;
    ClearTime();
    i = 0;
    J0xE3:

    // End:0x386 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "SkillLevel_" $ string(i), Info.Level);
        ParseInt(param, "SkillSubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "RemainTime_" $ string(i), Info.RemainTime);
        ParseString(param, "Name_" $ string(i), Info.Name);
        ParseString(param, "IconName_" $ string(i), Info.IconName);
        ParseString(param, "Description_" $ string(i), Info.Description);
        ParseInt(param, "ServerID", Info.ServerID);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x2B3
        if(nStatusIconSize >= 48)
        {
            // End:0x2B0
            if(InStr(Info.IconName, "icon.") > -1)
            {
                Icon = Locs(Info.IconName, "icon.", "iconBig.", true);
                Info.IconName = Icon;
            }            
        }
        else
        {
            // End:0x307
            if(InStr(Info.IconName, "iconBig.") > -1)
            {
                Icon = Locs(Info.IconName, "iconBig.", "icon.", true);
                Info.IconName = Icon;
            }
        }
        // End:0x37C
        if(((IsValidItemID(Info.Id)) && GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0) || EffectSwapWnd_script.getIsUsedObject(Info.Id.ClassID, 1))
        {
            arrDebuff[arrDebuff.Length] = Info;
        }
        i++;
        // [Loop Continue]
        goto J0xE3;
    }
    i = 0;
    J0x38D:

    // End:0x470 [Loop If]
    if(i < arrDebuff.Length)
    {
        // End:0x3CA
        if(m_DebuffRow == -1)
        {
            m_DebuffRow = 0;
            StatusIcon.InsertRow(m_DebuffRow);            
        }
        else
        {
            // End:0x407
            if((DeBuffCnt > 0) && (float(DeBuffCnt) % float(12)) == float(0))
            {
                m_DebuffRow++;
                StatusIcon.InsertRow(m_DebuffRow);
            }
        }
        StatusIcon.AddCol(m_DebuffRow, arrDebuff[i]);
        DeBuffCnt++;
        // End:0x466
        if(i <= 12)
        {
            Me.KillTimer(i + 100000000);
            OnTimer(i + 100000000);
        }
        i++;
        // [Loop Continue]
        goto J0x38D;
    }
    UpdateWindowSize();
    return;
}

function UpdateWindowSize()
{
    local int RowCount;
    local Rect rectWnd;

    RowCount = StatusIcon.GetRowCount();
    // End:0xC4
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
    }
    else
    {
        Me.HideWindow();
    }
    return;
}

function int showHideWindow(bool B)
{
    // End:0x1B
    if(B)
    {
        Me.ShowWindow();        
    }
    else
    {
        Me.HideWindow();
    }
    return;
}

function string sizeToFont(int nSize)
{
    switch(nSize)
    {
        // End:0x16
        case 12:
            return "timehs6";
        // End:0x25
        case 16:
            return "timehs8";
        // End:0x35
        case 24:
            return "timehs10";
        // End:0x45
        case 32:
            return "timehs12";
        // End:0x55
        case 48:
            return "timehs14";
        // End:0x65
        case 64:
            return "timehs16";
        // End:0xFFFF
        default:
            // End:0x6B
            break;
            break;
    }
    return;
}

function int GetTickFromSize(int Size)
{
    switch(Size)
    {
        // End:0x0E
        case 12:
            return 0;
        // End:0x15
        case 16:
            return 1;
        // End:0x1D
        case 24:
            return 2;
        // End:0x25
        case 32:
            return 3;
        // End:0x2D
        case 48:
            return 4;
        // End:0x35
        case 64:
            return 5;
        // End:0xFFFF
        default:
            return 2;
            break;
    }    
    return;
}
