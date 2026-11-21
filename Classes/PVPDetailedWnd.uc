class PVPDetailedWnd extends UIScript;

var WindowHandle Me;
var TextBoxHandle CountA;
var TextBoxHandle CountB;
var TextBoxHandle PartyNameA;
var TextBoxHandle PartyNameB;
var TextBoxHandle PartyNameADesktop;
var TextBoxHandle PartyNameBDesktop;
var ListCtrlHandle PKListA;
var ListCtrlHandle PKListB;
var ButtonHandle btnClose;
var TextureHandle ResultA;
var TextureHandle ResultB;
var TextureHandle ResultBWin;
var TextureHandle PKListAGroupBox;
var TextureHandle PKListBGroupBox;
var TextBoxHandle TimerCountTitle;
var TextBoxHandle TimerCount;
var int TotalCountA;
var int TotalCountB;

function OnRegisterEvent()
{
    RegisterEvent(3370);
    RegisterEvent(3380);
    RegisterEvent(3390);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x1D
    if(1 == 0)
    {
        Initialize();        
    }
    else
    {
        InitializeCOD();
    }
    Me.HideWindow();
    ResetUI();
    return;
}

function OnShow()
{
    local Color A, B, Gold;

    A.R = 114;
    A.G = 173;
    A.B = byte(255);
    B.R = 254;
    B.G = 151;
    B.B = 66;
    Gold.R = 176;
    Gold.G = 153;
    Gold.B = 121;
    CountA.SetTextColor(A);
    CountB.SetTextColor(B);
    PartyNameA.SetTextColor(Gold);
    PartyNameB.SetTextColor(Gold);
    return;
}

function Initialize()
{
    Me = GetHandle("PVPDetailedWnd");
    CountA = TextBoxHandle(GetHandle("CountA"));
    CountB = TextBoxHandle(GetHandle("CountB"));
    PartyNameA = TextBoxHandle(GetHandle("PartyNameA"));
    PartyNameB = TextBoxHandle(GetHandle("PartyNameB"));
    PKListA = ListCtrlHandle(GetHandle("PKListA"));
    PKListB = ListCtrlHandle(GetHandle("PKListB"));
    btnClose = ButtonHandle(GetHandle("btnClose"));
    ResultA = TextureHandle(GetHandle("ResultA"));
    ResultB = TextureHandle(GetHandle("ResultB"));
    ResultBWin = TextureHandle(GetHandle("ResultBWin"));
    PKListAGroupBox = TextureHandle(GetHandle("PKListAGroupBox"));
    PKListBGroupBox = TextureHandle(GetHandle("PKListBGroupBox"));
    PartyNameADesktop = TextBoxHandle(GetHandle("PVPCounter.PartyNameA"));
    PartyNameBDesktop = TextBoxHandle(GetHandle("PVPCounter.PartyNameB"));
    TimerCountTitle = TextBoxHandle(GetHandle("TimerCountTitle"));
    TimerCount = TextBoxHandle(GetHandle("TimerCount"));
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("PVPDetailedWnd");
    CountA = GetTextBoxHandle("CountA");
    CountB = GetTextBoxHandle("CountB");
    PartyNameA = GetTextBoxHandle("PartyNameA");
    PartyNameB = GetTextBoxHandle("PartyNameB");
    PKListA = GetListCtrlHandle("PKListA");
    PKListB = GetListCtrlHandle("PKListB");
    btnClose = GetButtonHandle("btnClose");
    ResultA = GetTextureHandle("ResultA");
    ResultB = GetTextureHandle("ResultB");
    ResultBWin = GetTextureHandle("ResultBWin");
    PKListAGroupBox = GetTextureHandle("PKListAGroupBox");
    PKListBGroupBox = GetTextureHandle("PKListBGroupBox");
    PartyNameADesktop = GetTextBoxHandle("PVPCounter.PartyNameA");
    PartyNameBDesktop = GetTextBoxHandle("PVPCounter.PartyNameB");
    TimerCountTitle = GetTextBoxHandle("TimerCountTitle");
    TimerCount = GetTextBoxHandle("TimerCount");
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 3370:
            HandlePVPMatchRecord(a_Param);
            // End:0x4C
            break;
        // End:0x33
        case 3380:
            HandlePVPMatchRecordEachUserInfo(a_Param);
            // End:0x4C
            break;
        // End:0x49
        case 3390:
            HandlePVPMatchUserDie(a_Param);
            // End:0x4C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandlePVPMatchRecord(string param)
{
    local int CurrentState, BlueTeamTotalKillCnt, RedTeamTotalKillCnt, WinnerIndex, LoserIndex;

    ParseInt(param, "CurrentState", CurrentState);
    ParseInt(param, "BlueTeamTotalKillCnt", BlueTeamTotalKillCnt);
    ParseInt(param, "RedTeamTotalKillCnt", RedTeamTotalKillCnt);
    ParseInt(param, "WinnerIndex", WinnerIndex);
    ParseInt(param, "LoserIndex", LoserIndex);
    TotalCountA = 0;
    TotalCountB = 0;
    switch(CurrentState)
    {
        // End:0xE2
        case 0:
            ResetUI();
            PKListA.DeleteAllItem();
            PKListB.DeleteAllItem();
            // End:0x1A7
            break;
        // End:0x133
        case 1:
            CountA.SetText(string(BlueTeamTotalKillCnt));
            CountB.SetText(string(RedTeamTotalKillCnt));
            PKListA.DeleteAllItem();
            PKListB.DeleteAllItem();
            // End:0x1A7
            break;
        // End:0x1A4
        case 2:
            PKListA.DeleteAllItem();
            PKListB.DeleteAllItem();
            CountA.SetText(string(BlueTeamTotalKillCnt));
            CountB.SetText(string(RedTeamTotalKillCnt));
            Me.ShowWindow();
            FinalCount(WinnerIndex, LoserIndex);
            // End:0x1A7
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandlePVPMatchRecordEachUserInfo(string param)
{
    local int Team;
    local string PlayerName;
    local int KillCnt, DeathCnt;
    local LVDataRecord Record;
    local LVData data1, data2, data3;

    ParseInt(param, "Team", Team);
    ParseInt(param, "KillCnt", KillCnt);
    ParseInt(param, "DeathCnt", DeathCnt);
    ParseString(param, "PlayerName", PlayerName);
    // End:0x156
    if(Team == 1)
    {
        // End:0xB6
        if(TotalCountA == 0)
        {
            PartyNameADesktop.SetText(MakeFullSystemMsg(GetSystemMessage(2277), PlayerName, ""));
            PartyNameA.SetText(PlayerName);
        }
        data1.nReserved1 = TotalCountA;
        data1.szData = PlayerName;
        data2.szData = string(KillCnt);
        data3.szData = string(DeathCnt);
        Record.LVDataList[0] = data1;
        Record.LVDataList[1] = data2;
        Record.LVDataList[2] = data3;
        PKListA.InsertRecord(Record);
        TotalCountA = TotalCountA + 1;        
    }
    else
    {
        // End:0x245
        if(Team == 2)
        {
            // End:0x1A8
            if(TotalCountB == 0)
            {
                PartyNameBDesktop.SetText(MakeFullSystemMsg(GetSystemMessage(2277), PlayerName, ""));
                PartyNameB.SetText(PlayerName);
            }
            data1.nReserved1 = TotalCountB;
            data1.szData = PlayerName;
            data2.szData = string(KillCnt);
            data3.szData = string(DeathCnt);
            Record.LVDataList[0] = data1;
            Record.LVDataList[1] = data2;
            Record.LVDataList[2] = data3;
            PKListB.InsertRecord(Record);
            TotalCountB = TotalCountB + 1;
        }
    }
    return;
}

function HandlePVPMatchUserDie(string param)
{
    local int BlueTeamKillCnt, RedTeamKillCnt;

    ParseInt(param, "BlueTeamKillCnt", BlueTeamKillCnt);
    ParseInt(param, "RedTeamKillCnt", RedTeamKillCnt);
    UpdateCurrentStat(BlueTeamKillCnt, RedTeamKillCnt);
    RequestPVPMatchRecord();
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x26
        case "btnClose":
            Me.HideWindow();
            // End:0x29
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ResetUI()
{
    PartyNameA.SetText("");
    PartyNameB.SetText("");
    PKListA.DeleteAllItem();
    PKListB.DeleteAllItem();
    ResultA.HideWindow();
    ResultB.HideWindow();
    ResultBWin.HideWindow();
    PartyNameADesktop.SetText("");
    PartyNameBDesktop.SetText("");
    return;
}

function FinalCount(int WinnerIndex, int LoserIndex)
{
    TimerCountTitle.HideWindow();
    TimerCount.HideWindow();
    // End:0xAF
    if((WinnerIndex == 1) && LoserIndex == 2)
    {
        ResultA.SetTexture("L2UI_CT1.PVP_DF_Result_Win");
        ResultB.SetTexture("L2UI_CT1.PVP_DF_Result_Lose");
        ResultA.ShowWindow();
        ResultB.ShowWindow();        
    }
    else
    {
        // End:0x140
        if((WinnerIndex == 2) && LoserIndex == 1)
        {
            ResultA.SetTexture("L2UI_CT1.PVP_DF_Result_Lose");
            ResultBWin.SetTexture("L2UI_CT1.PVP_DF_Result_Win");
            ResultA.ShowWindow();
            ResultBWin.ShowWindow();            
        }
        else
        {
            // End:0x185
            if((WinnerIndex == 0) && LoserIndex == 0)
            {
                ResultA.HideWindow();
                ResultB.HideWindow();
                ResultBWin.HideWindow();
            }
        }
    }
    return;
}

function UpdateCurrentStat(int BlueCountInt, int RedCountInt)
{
    CountA.SetText(string(BlueCountInt));
    CountB.SetText(string(RedCountInt));
    return;
}
