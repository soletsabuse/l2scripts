class CleftEnterWnd extends UIScript;

const TeamA_ID = 0;
const TeamB_ID = 1;

var WindowHandle Me;
var TextBoxHandle ARemainStaff;
var TextBoxHandle BRemainStaff;
var TextBoxHandle TeamATitle;
var TextBoxHandle TeamBTitle;
var TextBoxHandle TeamATotalStaff;
var TextBoxHandle TeamBTotalStaff;
var ListCtrlHandle TeamAList;
var ListCtrlHandle TeamBList;
var TextureHandle TeamAGroupBox;
var TextureHandle TeamBGroupBox;
var ButtonHandle btnExit;
var int m_MinMember;
var bool m_exitbool;
var int m_UserID;

function OnRegisterEvent()
{
    RegisterEvent(3700);
    RegisterEvent(3710);
    RegisterEvent(3720);
    RegisterEvent(3730);
    RegisterEvent(3690);
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
    return;
}

function Initialize()
{
    Me = GetHandle("CleftEnterWnd");
    ARemainStaff = TextBoxHandle(GetHandle("ARemainStaff"));
    BRemainStaff = TextBoxHandle(GetHandle("BRemainStaff"));
    TeamATitle = TextBoxHandle(GetHandle("TeamATitle"));
    TeamBTitle = TextBoxHandle(GetHandle("TeamBTitle"));
    TeamATotalStaff = TextBoxHandle(GetHandle("TeamATotalStaff"));
    TeamBTotalStaff = TextBoxHandle(GetHandle("TeamBTotalStaff"));
    TeamAList = ListCtrlHandle(GetHandle("CleftEnterWnd.TeamAList"));
    TeamBList = ListCtrlHandle(GetHandle("CleftEnterWnd.TeamBList"));
    TeamAGroupBox = TextureHandle(GetHandle("TeamAGroupBox"));
    TeamBGroupBox = TextureHandle(GetHandle("TeamBGroupBox"));
    btnExit = ButtonHandle(GetHandle("btnExit"));
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("CleftEnterWnd");
    ARemainStaff = GetTextBoxHandle("CleftEnterWnd.ARemainStaff");
    BRemainStaff = GetTextBoxHandle("CleftEnterWnd.BRemainStaff");
    TeamATitle = GetTextBoxHandle("CleftEnterWnd.TeamATitle");
    TeamBTitle = GetTextBoxHandle("CleftEnterWnd.TeamBTitle");
    TeamATotalStaff = GetTextBoxHandle("CleftEnterWnd.TeamATotalStaff");
    TeamBTotalStaff = GetTextBoxHandle("CleftEnterWnd.TeamBTotalStaff");
    TeamAList = GetListCtrlHandle("CleftEnterWnd.TeamAList");
    TeamBList = GetListCtrlHandle("CleftEnterWnd.TeamBList");
    TeamAGroupBox = GetTextureHandle("CleftEnterWnd.TeamAGroupBox");
    TeamBGroupBox = GetTextureHandle("CleftEnterWnd.TeamBGroupBox");
    btnExit = GetButtonHandle("CleftEnterWnd.btnExit");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 3700:
            HandleCleftListStart(param);
            // End:0x73
            break;
        // End:0x33
        case 3710:
            HandleCleftListAdd(param);
            // End:0x73
            break;
        // End:0x49
        case 3720:
            HandleCleftListRemove(param);
            // End:0x73
            break;
        // End:0x5A
        case 3730:
            HandleCleftListClose();
            // End:0x73
            break;
        // End:0x70
        case 3690:
            HandleCleftListInfo(param);
            // End:0x73
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
    TeamATotalStaff.SetText("0");
    TeamBList.DeleteAllItem();
    TeamBTotalStaff.SetText("0");
    return;
}

function HandleCleftListStart(string param)
{
    local int ShowUI;

    ParseInt(param, "ShowUI", ShowUI);
    ResetUI();
    // End:0x38
    if(ShowUI != 0)
    {
        Me.ShowWindow();
    }
    return;
}

function HandleCleftListAdd(string param)
{
    local int TeamID, PlayerID;
    local string PlayerName;
    local LVData data1, data2;
    local LVDataRecord Record1, Record2;
    local UserInfo Info;

    ParseInt(param, "TeamID", TeamID);
    ParseInt(param, "PlayerID", PlayerID);
    ParseString(param, "PlayerName", PlayerName);
    // End:0x6C
    if(GetMyUserInfo(Info))
    {
        m_UserID = Info.nID;
    }
    // End:0x117
    if(TeamID == 0)
    {
        data1.nReserved1 = TeamID;
        data1.nReserved2 = PlayerID;
        data1.szData = PlayerName;
        Record1.LVDataList.Length = 1;
        Record1.LVDataList[0] = data1;
        TeamAList.InsertRecord(Record1);
        TeamATotalStaff.SetText(string(TeamAList.GetRecordCount()));
        // End:0x114
        if(PlayerID == m_UserID)
        {
            AddSystemMessage(2416);
        }        
    }
    else
    {
        // End:0x1BF
        if(TeamID == 1)
        {
            data2.nReserved1 = TeamID;
            data2.nReserved2 = PlayerID;
            data2.szData = PlayerName;
            Record2.LVDataList.Length = 1;
            Record2.LVDataList[0] = data2;
            TeamBList.InsertRecord(Record2);
            TeamBTotalStaff.SetText(string(TeamBList.GetRecordCount()));
            // End:0x1BF
            if(PlayerID == m_UserID)
            {
                AddSystemMessage(2415);
            }
        }
    }
    UpdateNeedMember();
    return;
}

function HandleCleftListRemove(string param)
{
    local int Count, TeamID, PlayerID;
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
                    TeamATotalStaff.SetText(string(TeamAList.GetRecordCount()));
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
                    TeamBTotalStaff.SetText(string(TeamBList.GetRecordCount()));
                }
            }
            Count++;
            // [Loop Continue]
            goto J0xEC;
        }
    }
    UpdateNeedMember();
    return;
}

function HandleCleftListClose()
{
    m_exitbool = true;
    Me.HideWindow();
    return;
}

function HandleCleftListInfo(string param)
{
    local int MinMemberCount, bBalancedMatch;

    ParseInt(param, "MinMemberCount", MinMemberCount);
    ParseInt(param, "bBalancedMatch", bBalancedMatch);
    m_MinMember = MinMemberCount;
    UpdateNeedMember();
    return;
}

function UpdateNeedMember()
{
    local int Count, Remain;

    Count = TeamAList.GetRecordCount();
    // End:0x2E
    if(Count >= m_MinMember)
    {
        Remain = 0;        
    }
    else
    {
        // End:0x4F
        if(Count < m_MinMember)
        {
            Remain = m_MinMember - Count;
        }
    }
    ARemainStaff.SetText(string(Remain));
    Count = TeamBList.GetRecordCount();
    // End:0x93
    if(Count >= m_MinMember)
    {
        Remain = 0;        
    }
    else
    {
        // End:0xB4
        if(Count < m_MinMember)
        {
            Remain = m_MinMember - Count;
        }
    }
    BRemainStaff.SetText(string(Remain));
    return;
}

function OnLButtonUp(WindowHandle WindowHandle, int X, int Y)
{
    switch(WindowHandle)
    {
        // End:0x22
        case TeamAList:
            Class'NWindow.TeamMatchAPI'.static.RequestExCleftEnter(0);
            // End:0x40
            break;
        // End:0x3D
        case TeamBList:
            Class'NWindow.TeamMatchAPI'.static.RequestExCleftEnter(1);
            // End:0x40
            break;
        // End:0xFFFF
        default:
            break;
    }
    TeamATotalStaff.SetText(string(TeamAList.GetRecordCount()));
    TeamBTotalStaff.SetText(string(TeamBList.GetRecordCount()));
    return;
}

function OnClickButton(string ButtonID)
{
    switch(ButtonID)
    {
        // End:0x25
        case "btnExit":
            Me.HideWindow();
            // End:0x28
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnHide()
{
    // End:0x30
    if(!m_exitbool)
    {
        Class'NWindow.TeamMatchAPI'.static.RequestExCleftEnter(-1);
        AddSystemMessage(2418);
        ResetUI();
    }
    m_exitbool = false;
    return;
}

function bool GetMyUserInfo(out UserInfo a_MyUserInfo)
{
    return GetPlayerInfo(a_MyUserInfo);
    return;
}
