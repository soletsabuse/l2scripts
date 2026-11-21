class CleftCurWnd extends UICommonAPI;

const TeamA_ID = 0;
const TeamB_ID = 1;

var WindowHandle Me;
var TextBoxHandle CountA;
var TextBoxHandle CountB;
var TextBoxHandle TeamATitle;
var TextBoxHandle TeamBTitle;
var TextBoxHandle CATATitle;
var TextBoxHandle CATBTitle;
var TextBoxHandle CATA;
var TextBoxHandle CATB;
var TextBoxHandle TeamATotalTitle;
var TextBoxHandle TeamBTotalTitle;
var TextBoxHandle TeamATotal;
var TextBoxHandle TeamBTotal;
var ListCtrlHandle TeamAList;
var ListCtrlHandle TeamBList;
var ButtonHandle btnClose;
var ButtonHandle btnExit;
var TextureHandle ResultA;
var TextureHandle ResultB;
var TextureHandle ResultBWin;
var TextureHandle TeamAListGroupBox;
var TextureHandle TeamBListGroupBox;
var TextBoxHandle RemainSecTitle;
var TextBoxHandle RemainSec;
var int TotalCountA;
var int TotalCountB;
var WindowHandle CleftCurTriggerWnd;
var WindowHandle CleftCounter;
var int CurCATAID;
var int CurCATBID;
var NoticeWnd NoticeWndScript;

function OnRegisterEvent()
{
    RegisterEvent(3700);
    RegisterEvent(3740);
    RegisterEvent(3750);
    RegisterEvent(3760);
    RegisterEvent(3710);
    RegisterEvent(3720);
    return;
}

function OnLoad()
{
    InitializeCOD();
    Me.HideWindow();
    ResetUI();
    NoticeWndScript = NoticeWnd(GetScript("NoticeWnd"));
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("CleftCurWnd");
    CountA = GetTextBoxHandle("CleftCurWnd.CountA");
    CountB = GetTextBoxHandle("CleftCurWnd.CountB");
    TeamATitle = GetTextBoxHandle("CleftCurWnd.TeamATitle");
    TeamBTitle = GetTextBoxHandle("CleftCurWnd.TeamBTitle");
    CATATitle = GetTextBoxHandle("CleftCurWnd.CATATitle");
    CATBTitle = GetTextBoxHandle("CleftCurWnd.CATBTitle");
    CATA = GetTextBoxHandle("CleftCurWnd.CATA");
    CATB = GetTextBoxHandle("CleftCurWnd.CATB");
    TeamATotalTitle = GetTextBoxHandle("CleftCurWnd.TeamATotalTitle");
    TeamBTotalTitle = GetTextBoxHandle("CleftCurWnd.TeamBTotalTitle");
    TeamATotal = GetTextBoxHandle("CleftCurWnd.TeamATotal");
    TeamBTotal = GetTextBoxHandle("CleftCurWnd.TeamBTotal");
    RemainSecTitle = GetTextBoxHandle("CleftCurWnd.RemainSecTitle");
    RemainSec = GetTextBoxHandle("CleftCurWnd.RemainSec1");
    TeamAList = GetListCtrlHandle("CleftCurWnd.TeamAList");
    TeamBList = GetListCtrlHandle("CleftCurWnd.TeamBList");
    btnClose = GetButtonHandle("CleftCurWnd.btnClose");
    btnExit = GetButtonHandle("CleftCurWnd.btnExit");
    ResultA = GetTextureHandle("CleftCurWnd.ResultA");
    ResultB = GetTextureHandle("CleftCurWnd.ResultB");
    ResultBWin = GetTextureHandle("CleftCurWnd.ResultBWin");
    TeamAListGroupBox = GetTextureHandle("CleftCurWnd.TeamAListGroupBox");
    TeamBListGroupBox = GetTextureHandle("CleftCurWnd.TeamBListGroupBox");
    CleftCurTriggerWnd = GetWindowHandle("CleftCurTriggerWnd");
    CleftCounter = GetWindowHandle("CleftCounter");
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x18
        case 3700:
            HandleCleftListStart();
            // End:0x89
            break;
        // End:0x2E
        case 3740:
            HandleCleftStateTeam(a_Param);
            // End:0x89
            break;
        // End:0x44
        case 3750:
            HandleCleftStatePlayer(a_Param);
            // End:0x89
            break;
        // End:0x5A
        case 3760:
            HandleCleftStateResult(a_Param);
            // End:0x89
            break;
        // End:0x70
        case 3710:
            HandleCleftListAdd(a_Param);
            // End:0x89
            break;
        // End:0x86
        case 3720:
            HandleCleftListRemove(a_Param);
            // End:0x89
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleCleftListStart()
{
    ResetUI();
    return;
}

function HandleCleftStateTeam(string param)
{
    local int TeamID, TeamPoint, CATID;
    local string CATNAME;
    local int RemainSec;
    local string ParamString, Message;

    CleftCounter.ShowWindow();
    ParseInt(param, "TeamID", TeamID);
    ParseInt(param, "TeamPoint", TeamPoint);
    ParseInt(param, "CATID", CATID);
    ParseString(param, "CATNAME", CATNAME);
    ParseInt(param, "RemainSec", RemainSec);
    // End:0x140
    if(TeamID == 0)
    {
        // End:0x10B
        if((CATID != CurCATAID) && CATID > 0)
        {
            ParamAdd(ParamString, "Type", string(int(0)));
            ParamAdd(ParamString, "param1", CATNAME);
            AddSystemMessageParam(ParamString);
            Message = EndSystemMessageParam(2755, true);
            AddSystemMessageString(Message);
        }
        CurCATAID = CATID;
        CATA.SetText(CATNAME);
        CountA.SetText(string(TeamPoint));
    }
    // End:0x1F3
    if(TeamID == 1)
    {
        // End:0x1BE
        if((CATID != CurCATBID) && CATID > 0)
        {
            ParamAdd(ParamString, "Type", string(int(0)));
            ParamAdd(ParamString, "param1", CATNAME);
            AddSystemMessageParam(ParamString);
            Message = EndSystemMessageParam(2755, true);
            AddSystemMessageString(Message);
        }
        CurCATBID = CATID;
        CATB.SetText(CATNAME);
        CountB.SetText(string(TeamPoint));
    }
    return;
}

function HandleCleftStatePlayer(string param)
{
    local int TeamID, PlayerID, KillCount, DeathCount, CleftTowerCount, TowerType,
	    RemainSec, Count;

    local string PlayerName;
    local LVDataRecord Record1, Record2;

    CleftCounter.ShowWindow();
    ParseInt(param, "TeamID", TeamID);
    ParseInt(param, "PlayerID", PlayerID);
    ParseInt(param, "KillCount", KillCount);
    ParseInt(param, "DeathCount", DeathCount);
    ParseInt(param, "CleftTowerCount", CleftTowerCount);
    ParseInt(param, "TowerType", TowerType);
    ParseInt(param, "RemainSec", RemainSec);
    // End:0x1BE
    if(TeamID == 0)
    {
        PlayerName = Class'NWindow.UIDATA_USER'.static.GetUserName(PlayerID);
        Count = 0;
        J0xFB:

        // End:0x1BB [Loop If]
        if(Count < TeamAList.GetRecordCount())
        {
            TeamAList.GetRec(Count, Record1);
            // End:0x1B1
            if(PlayerID == Record1.LVDataList[0].nReserved2)
            {
                Record1.LVDataList[1].szData = string(CleftTowerCount);
                Record1.LVDataList[2].szData = string(KillCount);
                Record1.LVDataList[3].szData = string(DeathCount);
                TeamAList.ModifyRecord(Count, Record1);
                // [Explicit Break]
                goto J0x1BB;
            }
            Count++;
            // [Loop Continue]
            goto J0xFB;
        }
        J0x1BB:
        
    }
    else
    {
        // End:0x2AA
        if(TeamID == 1)
        {
            PlayerName = Class'NWindow.UIDATA_USER'.static.GetUserName(PlayerID);
            Count = 0;
            J0x1EA:

            // End:0x2AA [Loop If]
            if(Count < TeamBList.GetRecordCount())
            {
                TeamBList.GetRec(Count, Record2);
                // End:0x2A0
                if(PlayerID == Record2.LVDataList[0].nReserved2)
                {
                    Record2.LVDataList[1].szData = string(CleftTowerCount);
                    Record2.LVDataList[2].szData = string(KillCount);
                    Record2.LVDataList[3].szData = string(DeathCount);
                    TeamBList.ModifyRecord(Count, Record2);
                    // [Explicit Break]
                    goto J0x2AA;
                }
                Count++;
                // [Loop Continue]
                goto J0x1EA;
            }
        }
    }
    J0x2AA:

    return;
}

function HandleCleftStateResult(string param)
{
    local int WinTeamId;

    ParseInt(param, "WinTeamId", WinTeamId);
    getInstanceNoticeWnd().hideNoticeButton_PVPCLEFT();
    NoticeWndScript.removeNoticeButton(int(NoticeWndScript.16));
    CleftCounter.HideWindow();
    // End:0x79
    if(!Me.IsShowWindow())
    {
        Me.ShowWindow();
    }
    AddSystemMessage(2425);
    // End:0x112
    if(WinTeamId == 0)
    {
        ResultA.SetTexture("L2UI_CT1.PVP_DF_Result_Win");
        ResultB.SetTexture("L2UI_CT1.PVP_DF_Result_Lose");
        ResultA.ShowWindow();
        ResultB.ShowWindow();
        AddSystemMessage(2428);        
    }
    else
    {
        // End:0x19D
        if(WinTeamId == 1)
        {
            ResultA.SetTexture("L2UI_CT1.PVP_DF_Result_Lose");
            ResultBWin.SetTexture("L2UI_CT1.PVP_DF_Result_Win");
            ResultA.ShowWindow();
            ResultBWin.ShowWindow();
            AddSystemMessage(2427);
        }
    }
    return;
}

function HandleCleftListAdd(string param)
{
    local int TeamID, PlayerID;
    local string PlayerName;
    local int Index;
    local LVData data1, data2, data3, data4;
    local LVDataRecord Record1, Record2;

    ParseInt(param, "TeamID", TeamID);
    ParseInt(param, "PlayerID", PlayerID);
    ParseString(param, "PlayerName", PlayerName);
    // End:0x167
    if(TeamID == 0)
    {
        Index = TeamAList.GetRecordCount();
        data1.nReserved1 = TeamID;
        data1.nReserved2 = PlayerID;
        data1.nReserved3 = Index;
        data1.szData = PlayerName;
        data2.szData = "0";
        data3.szData = "0";
        data4.szData = "0";
        Record1.LVDataList.Length = 4;
        Record1.LVDataList[0] = data1;
        Record1.LVDataList[1] = data2;
        Record1.LVDataList[2] = data3;
        Record1.LVDataList[3] = data4;
        TeamAList.InsertRecord(Record1);
        TeamATotal.SetText(string(TeamAList.GetRecordCount()));        
    }
    else
    {
        // End:0x27D
        if(TeamID == 1)
        {
            Index = TeamBList.GetRecordCount();
            data1.nReserved1 = TeamID;
            data1.nReserved2 = PlayerID;
            data1.nReserved3 = Index;
            data1.szData = PlayerName;
            data2.szData = "0";
            data3.szData = "0";
            data4.szData = "0";
            Record1.LVDataList.Length = 4;
            Record2.LVDataList[0] = data1;
            Record2.LVDataList[1] = data2;
            Record2.LVDataList[2] = data3;
            Record2.LVDataList[3] = data4;
            TeamBList.InsertRecord(Record2);
            TeamBTotal.SetText(string(TeamBList.GetRecordCount()));
        }
    }
    return;
}

function HandleCleftListRemove(string param)
{
    local int TeamID, PlayerID, Count;
    local LVDataRecord Record1, Record2;

    ParseInt(param, "TeamID", TeamID);
    ParseInt(param, "PlayerID", PlayerID);
    // End:0xDA
    if(TeamID == 0)
    {
        Count = 0;
        J0x44:

        // End:0xDA [Loop If]
        if(Count < TeamAList.GetRecordCount())
        {
            TeamAList.GetRec(Count, Record1);
            // End:0xD0
            if(PlayerID == Record1.LVDataList[0].nReserved2)
            {
                // End:0xD0
                if(Count >= 0)
                {
                    TeamAList.DeleteRecord(Count);
                    TeamATotal.SetText(string(TeamAList.GetRecordCount()));
                }
            }
            Count++;
            // [Loop Continue]
            goto J0x44;
        }
    }
    // End:0x182
    if(TeamID == 1)
    {
        Count = 0;
        J0xEC:

        // End:0x182 [Loop If]
        if(Count < TeamBList.GetRecordCount())
        {
            TeamBList.GetRec(Count, Record2);
            // End:0x178
            if(PlayerID == Record2.LVDataList[0].nReserved2)
            {
                // End:0x178
                if(Count >= 0)
                {
                    TeamBList.DeleteRecord(Count);
                    TeamBTotal.SetText(string(TeamBList.GetRecordCount()));
                }
            }
            Count++;
            // [Loop Continue]
            goto J0xEC;
        }
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x26
        case "btnClose":
            Me.HideWindow();
            // End:0x96
            break;
        // End:0x93
        case "btnExit":
            Class'NWindow.TeamMatchAPI'.static.RequestExCleftEnter(-1);
            getInstanceNoticeWnd().hideNoticeButton_PVPCLEFT();
            NoticeWndScript.removeNoticeButton(int(NoticeWndScript.16));
            CleftCounter.HideWindow();
            Me.HideWindow();
            // End:0x96
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ResetUI()
{
    TeamAList.DeleteAllItem();
    TeamBList.DeleteAllItem();
    ResultA.HideWindow();
    ResultB.HideWindow();
    ResultBWin.HideWindow();
    return;
}
