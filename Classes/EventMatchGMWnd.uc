class EventMatchGMWnd extends UICommonAPI;

const TIMERID_CountDown = 1;
const BUTTONNAME_FenceUp = 1081;
const BUTTONNAME_FenceDown = 1082;

var HtmlHandle m_hCommandHtml;
var WindowHandle m_hEventMatchGMCommandWnd;
var WindowHandle m_hEventMatchGMFenceWnd;
var ButtonHandle m_hCreateEventMatchButton;
var ButtonHandle m_hSetTeam1LeaderButton;
var ButtonHandle m_hLockTeam1Button;
var ButtonHandle m_hSetTeam2LeaderButton;
var ButtonHandle m_hLockTeam2Button;
var ButtonHandle m_hPauseButton;
var ButtonHandle m_hStartButton;
var ButtonHandle m_hSetScoreButton;
var ButtonHandle m_hSendAnnounceButton;
var ButtonHandle m_hShowCommandWndButton;
var ButtonHandle m_hSendGameEndMsgButton;
var ButtonHandle m_hSetFenceButton;
var ButtonHandle m_hTeam1FirecrackerButton;
var ButtonHandle m_hTeam2FirecrackerButton;
var ButtonHandle Summon2Team;
var ButtonHandle SetAllHeal;
var ButtonHandle DelayReset;
var ButtonHandle Summon1Team;
var EditBoxHandle m_hTeam1NameEditBox;
var EditBoxHandle m_hTeam2NameEditBox;
var EditBoxHandle m_hTeam1LeaderNameEditBox;
var EditBoxHandle m_hTeam2LeaderNameEditBox;
var EditBoxHandle m_hOptionFileEditBox;
var EditBoxHandle m_hCommandFileEditBox;
var EditBoxHandle m_hTeam1ScoreEditBox;
var EditBoxHandle m_hTeam2ScoreEditBox;
var EditBoxHandle m_hAnnounceEditBox;
var TextBoxHandle m_hMatchIDTextBox;
var ListCtrlHandle m_hTeam1ListCtrl;
var ListCtrlHandle m_hTeam2ListCtrl;
var int m_CountDown;
var int m_MatchID;
var bool m_Team1Locked;
var bool m_Team2Locked;
var bool m_Paused;
var string m_Team1Name;
var string m_Team2Name;

function OnRegisterEvent()
{
    RegisterEvent(2180);
    RegisterEvent(2190);
    RegisterEvent(2250);
    RegisterEvent(2210);
    RegisterEvent(2211);
    return;
}

function OnLoad()
{
    GotoState('HidingState');
    // End:0x14
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x4B6
    if(1 == 0)
    {
        m_hEventMatchGMCommandWnd = GetHandle("EventMatchGMCommandWnd");
        m_hCommandHtml = HtmlHandle(GetHandle("EventMatchGMCommandWnd.HtmlCtrl"));
        m_hEventMatchGMFenceWnd = GetHandle("EventMatchGMFenceWnd");
        m_hCreateEventMatchButton = ButtonHandle(GetHandle("CreateEventMatchButton"));
        m_hSetTeam1LeaderButton = ButtonHandle(GetHandle("SetTeam1LeaderButton"));
        m_hLockTeam1Button = ButtonHandle(GetHandle("LockTeam1Button"));
        m_hSetTeam2LeaderButton = ButtonHandle(GetHandle("SetTeam2LeaderButton"));
        m_hLockTeam2Button = ButtonHandle(GetHandle("LockTeam2Button"));
        m_hPauseButton = ButtonHandle(GetHandle("PauseButton"));
        m_hStartButton = ButtonHandle(GetHandle("StartButton"));
        Summon2Team = ButtonHandle(GetHandle("Summon2Team"));
        SetAllHeal = ButtonHandle(GetHandle("SetAllHeal"));
        DelayReset = ButtonHandle(GetHandle("DelayReset"));
        Summon1Team = ButtonHandle(GetHandle("Summon1Team"));
        m_hSetScoreButton = ButtonHandle(GetHandle("SetScoreButton"));
        m_hSendAnnounceButton = ButtonHandle(GetHandle("SendAnnounceButton"));
        m_hShowCommandWndButton = ButtonHandle(GetHandle("ShowCommandWndButton"));
        m_hSendGameEndMsgButton = ButtonHandle(GetHandle("SendGameEndMsgButton"));
        m_hSetFenceButton = ButtonHandle(GetHandle("SetFenceButton"));
        m_hTeam1FirecrackerButton = ButtonHandle(GetHandle("Team1FirecrackerButton"));
        m_hTeam2FirecrackerButton = ButtonHandle(GetHandle("Team2FirecrackerButton"));
        m_hTeam1NameEditBox = EditBoxHandle(GetHandle("Team1NameEditBox"));
        m_hTeam2NameEditBox = EditBoxHandle(GetHandle("Team2NameEditBox"));
        m_hTeam1LeaderNameEditBox = EditBoxHandle(GetHandle("Team1LeaderNameEditBox"));
        m_hTeam2LeaderNameEditBox = EditBoxHandle(GetHandle("Team2LeaderNameEditBox"));
        m_hOptionFileEditBox = EditBoxHandle(GetHandle("OptionFileEditBox"));
        m_hCommandFileEditBox = EditBoxHandle(GetHandle("CommandFileEditBox"));
        m_hTeam1ScoreEditBox = EditBoxHandle(GetHandle("Team1ScoreEditBox"));
        m_hTeam2ScoreEditBox = EditBoxHandle(GetHandle("Team2ScoreEditBox"));
        m_hAnnounceEditBox = EditBoxHandle(GetHandle("AnnounceEditBox"));
        m_hMatchIDTextBox = TextBoxHandle(GetHandle("MatchIDTextBox"));
        m_hTeam1ListCtrl = ListCtrlHandle(GetHandle("Team1ListCtrl"));
        m_hTeam2ListCtrl = ListCtrlHandle(GetHandle("Team2ListCtrl"));        
    }
    else
    {
        m_hEventMatchGMCommandWnd = GetWindowHandle("EventMatchGMCommandWnd");
        m_hCommandHtml = GetHtmlHandle("EventMatchGMWnd.EventMatchGMCommandWnd.HtmlCtrl");
        m_hEventMatchGMFenceWnd = GetWindowHandle("EventMatchGMFenceWnd");
        m_hCreateEventMatchButton = GetButtonHandle("EventMatchGMWnd.CreateEventMatchButton");
        m_hSetTeam1LeaderButton = GetButtonHandle("EventMatchGMWnd.SetTeam1LeaderButton");
        m_hLockTeam1Button = GetButtonHandle("EventMatchGMWnd.LockTeam1Button");
        m_hSetTeam2LeaderButton = GetButtonHandle("EventMatchGMWnd.SetTeam2LeaderButton");
        m_hLockTeam2Button = GetButtonHandle("EventMatchGMWnd.LockTeam2Button");
        m_hPauseButton = GetButtonHandle("EventMatchGMWnd.PauseButton");
        m_hStartButton = GetButtonHandle("EventMatchGMWnd.StartButton");
        Summon2Team = GetButtonHandle("EventMatchGMWnd.Summon2Team");
        SetAllHeal = GetButtonHandle("EventMatchGMWnd.SetAllHeal");
        DelayReset = GetButtonHandle("EventMatchGMWnd.DelayReset");
        Summon1Team = GetButtonHandle("EventMatchGMWnd.Summon1Team");
        m_hSetScoreButton = GetButtonHandle("EventMatchGMWnd.SetScoreButton");
        m_hSendAnnounceButton = GetButtonHandle("EventMatchGMWnd.SendAnnounceButton");
        m_hShowCommandWndButton = GetButtonHandle("EventMatchGMWnd.ShowCommandWndButton");
        m_hSendGameEndMsgButton = GetButtonHandle("EventMatchGMWnd.SendGameEndMsgButton");
        m_hSetFenceButton = GetButtonHandle("EventMatchGMWnd.SetFenceButton");
        m_hTeam1FirecrackerButton = GetButtonHandle("EventMatchGMWnd.Team1FirecrackerButton");
        m_hTeam2FirecrackerButton = GetButtonHandle("EventMatchGMWnd.Team2FirecrackerButton");
        m_hTeam1NameEditBox = GetEditBoxHandle("EventMatchGMWnd.Team1NameEditBox");
        m_hTeam2NameEditBox = GetEditBoxHandle("EventMatchGMWnd.Team2NameEditBox");
        m_hTeam1LeaderNameEditBox = GetEditBoxHandle("EventMatchGMWnd.Team1LeaderNameEditBox");
        m_hTeam2LeaderNameEditBox = GetEditBoxHandle("EventMatchGMWnd.Team2LeaderNameEditBox");
        m_hOptionFileEditBox = GetEditBoxHandle("EventMatchGMWnd.OptionFileEditBox");
        m_hCommandFileEditBox = GetEditBoxHandle("EventMatchGMWnd.CommandFileEditBox");
        m_hTeam1ScoreEditBox = GetEditBoxHandle("EventMatchGMWnd.Team1ScoreEditBox");
        m_hTeam2ScoreEditBox = GetEditBoxHandle("EventMatchGMWnd.Team2ScoreEditBox");
        m_hAnnounceEditBox = GetEditBoxHandle("EventMatchGMWnd.AnnounceEditBox");
        m_hMatchIDTextBox = GetTextBoxHandle("EventMatchGMWnd.MatchIDTextBox");
        m_hTeam1ListCtrl = GetListCtrlHandle("EventMatchGMWnd.Team1ListCtrl");
        m_hTeam2ListCtrl = GetListCtrlHandle("EventMatchGMWnd.Team2ListCtrl");
    }
    return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
    Debug("ClickedButton");
    switch(a_ButtonHandle)
    {
        // End:0x2D
        case m_hCreateEventMatchButton:
            OnClickCreateEventMatchButton();
            // End:0x151
            break;
        // End:0x3E
        case m_hSetTeam1LeaderButton:
            OnClickSetTeam1LeaderButton();
            // End:0x151
            break;
        // End:0x4F
        case m_hLockTeam1Button:
            OnClickLockTeam1Button();
            // End:0x151
            break;
        // End:0x60
        case m_hSetTeam2LeaderButton:
            OnClickSetTeam2LeaderButton();
            // End:0x151
            break;
        // End:0x71
        case m_hLockTeam2Button:
            OnClickLockTeam2Button();
            // End:0x151
            break;
        // End:0x82
        case m_hPauseButton:
            OnClickPauseButton();
            // End:0x151
            break;
        // End:0x93
        case m_hStartButton:
            OnClickStartButton();
            // End:0x151
            break;
        // End:0xA4
        case m_hSetScoreButton:
            OnClickSetScoreButton();
            // End:0x151
            break;
        // End:0xB5
        case m_hSendAnnounceButton:
            OnClickSendAnnounceButton();
            // End:0x151
            break;
        // End:0xC6
        case m_hShowCommandWndButton:
            OnClickShowCommandWndButton();
            // End:0x151
            break;
        // End:0xD7
        case m_hSendGameEndMsgButton:
            OnClickSendGameEngMsgButton();
            // End:0x151
            break;
        // End:0xE8
        case m_hSetFenceButton:
            OnClickSetFenceButton();
            // End:0x151
            break;
        // End:0xF9
        case m_hTeam1FirecrackerButton:
            OnClickTeam1FirecrackerButton();
            // End:0x151
            break;
        // End:0x10A
        case m_hTeam2FirecrackerButton:
            OnClickTeam2FirecrackerButton();
            // End:0x151
            break;
        // End:0x11B
        case Summon2Team:
            OnClickSummon2Team();
            // End:0x151
            break;
        // End:0x12C
        case SetAllHeal:
            OnClickSetAllHeal();
            // End:0x151
            break;
        // End:0x13D
        case DelayReset:
            OnClickDelayReset();
            // End:0x151
            break;
        // End:0x14E
        case Summon1Team:
            OnClickSummon1Team();
            // End:0x151
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    Debug("EVID" @ string(a_EventID));
    switch(a_EventID)
    {
        // End:0x2D
        case 2180:
            HandleShowEventMatchGMWnd();
            // End:0x88
            break;
        // End:0x43
        case 2190:
            HandleEventMatchCreated(a_Param);
            // End:0x88
            break;
        // End:0x59
        case 2250:
            HandleEventMatchUpdateTeamInfo(a_Param);
            // End:0x88
            break;
        // End:0x6F
        case 2210:
            HandleEventMatchManage(a_Param);
            // End:0x88
            break;
        // End:0x85
        case 2211:
            HandleEventMatchPartyLeader(a_Param);
            // End:0x88
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnHide()
{
    GotoState('HidingState');
    return;
}

function OnClickCreateEventMatchButton()
{
    return;
}

function OnClickSetTeam1LeaderButton()
{
    return;
}

function OnClickLockTeam1Button()
{
    return;
}

function OnClickSetTeam2LeaderButton()
{
    return;
}

function OnClickLockTeam2Button()
{
    return;
}

function OnClickPauseButton()
{
    return;
}

function OnClickStartButton()
{
    return;
}

function OnClickSetScoreButton()
{
    return;
}

function OnClickSendAnnounceButton()
{
    return;
}

function OnClickShowCommandWndButton()
{
    local string CommandFileName;
    local int Count;
    local string HtmlString;
    local int i;
    local string CommandString;

    CommandFileName = m_hCommandFileEditBox.GetString();
    // End:0x3B
    if(CommandFileName == "")
    {
        DialogShow(1, 5, GetSystemMessage(1415), string(self));
        return;
    }
    RefreshINI(CommandFileName);
    // End:0x6F
    if(!GetINIInt("Cmd", "CmdCnt", Count, CommandFileName))
    {
        Count = 0;
    }
    HtmlString = "<html><body>";
    i = 0;
    J0x8A:

    // End:0x103 [Loop If]
    if(i < Count)
    {
        // End:0xF9
        if(GetINIString("Cmd", "Cmd" $ string(i), CommandString, CommandFileName))
        {
            HtmlString = ((((HtmlString $ "<a cmd = \"") $ CommandString) $ "\">") $ CommandString) $ "</a><br1>";
        }
        ++i;
        // [Loop Continue]
        goto J0x8A;
    }
    HtmlString = HtmlString $ "</body></html>";
    m_hEventMatchGMCommandWnd.ShowWindow();
    m_hEventMatchGMCommandWnd.SetFocus();
    m_hCommandHtml.LoadHtmlFromString(HtmlString);
    return;
}

function OnClickSendGameEngMsgButton()
{
    return;
}

function OnClickSetFenceButton()
{
    return;
}

function OnClickTeam1FirecrackerButton()
{
    return;
}

function OnClickTeam2FirecrackerButton()
{
    return;
}

function NotifyFenceInfo(Vector a_Position, int a_XLength, int a_YLength)
{
    return;
}

function HandleShowEventMatchGMWnd()
{
    return;
}

function HandleEventMatchCreated(string a_Param)
{
    return;
}

function HandleEventMatchUpdateTeamInfo(string a_Param)
{
    local int TeamID, i, PartyMemberCount;
    local LVDataRecord Record;
    local EventMatchUserData UserData;
    local ListCtrlHandle hTeamListCtrl;

    // End:0x1A7
    if(ParseInt(a_Param, "TeamID", TeamID))
    {
        PartyMemberCount = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(TeamID);
        switch(TeamID)
        {
            // End:0x84
            case 0:
                m_hLockTeam1Button.EnableWindow();
                // End:0x76
                if(0 != PartyMemberCount)
                {
                    m_hLockTeam1Button.SetButtonName(1072);
                    m_Team1Locked = true;
                }
                hTeamListCtrl = m_hTeam1ListCtrl;
                // End:0xD2
                break;
            // End:0xCC
            case 1:
                m_hLockTeam2Button.EnableWindow();
                // End:0xBE
                if(0 != PartyMemberCount)
                {
                    m_hLockTeam2Button.SetButtonName(1072);
                    m_Team2Locked = true;
                }
                hTeamListCtrl = m_hTeam2ListCtrl;
                // End:0xD2
                break;
            // End:0xFFFF
            default:
                // End:0xD2
                break;
                break;
        }
        hTeamListCtrl.DeleteAllItem();
        Record.LVDataList.Length = 3;
        i = 0;
        J0xF6:

        // End:0x1A1 [Loop If]
        if(i < PartyMemberCount)
        {
            // End:0x197
            if(Class'NWindow.EventMatchAPI'.static.GetUserData(TeamID, i, UserData))
            {
                Record.LVDataList[0].szData = UserData.Username;
                Record.LVDataList[1].szData = string(UserData.UserLv);
                Record.LVDataList[2].szData = GetClassType(UserData.UserClass);
                hTeamListCtrl.InsertRecord(Record);
            }
            ++i;
            // [Loop Continue]
            goto J0xF6;
        }
        RefreshLockStatus();
    }
    return;
}

function RefreshLockStatus()
{
    return;
}

function StartCountDown()
{
    return;
}

function bool ApplySkillRule(string a_OptionFile)
{
    local int DefaultAllow;
    local string Command;
    local int i, Count, Id;

    // End:0x44
    if(!GetINIBool("Skill", "DefaultAllow", DefaultAllow, a_OptionFile))
    {
        DialogShow(1, 5, GetSystemMessage(1425), string(self));
        return false;
    }
    Command = "//eventmatch skill_rule" @ string(m_MatchID);
    // End:0x92
    if(1 == DefaultAllow)
    {
        Command = Command @ "allow_all";        
    }
    else
    {
        Command = Command @ "deny_all";
    }
    // End:0xD9
    if(!GetINIInt("Skill", "ExpSkillCnt", Count, a_OptionFile))
    {
        Count = 0;
    }
    i = 0;
    J0xE0:

    // End:0x193 [Loop If]
    if(i < Count)
    {
        // End:0x147
        if(!GetINIInt("Skill", "ExpSkillID" $ string(i), Id, a_OptionFile))
        {
            DialogShow(1, 5, MakeFullSystemMsg(GetSystemMessage(1427), string(i)), string(self));
            return false;
        }
        // End:0x165
        if(1 == DefaultAllow)
        {
            Command = Command @ "D";            
        }
        else
        {
            Command = Command @ "A";
        }
        Command = Command $ string(Id);
        ++i;
        // [Loop Continue]
        goto J0xE0;
    }
    ExecuteCommand(Command);
    return true;
    return;
}

function bool ApplyItemRule(string a_OptionFile)
{
    local int DefaultAllow;
    local string Command;
    local int i, Count, Id;

    // End:0x43
    if(!GetINIBool("Item", "DefaultAllow", DefaultAllow, a_OptionFile))
    {
        DialogShow(1, 5, GetSystemMessage(1425), string(self));
        return false;
    }
    Command = "//eventmatch item_rule" @ string(m_MatchID);
    // End:0x90
    if(1 == DefaultAllow)
    {
        Command = Command @ "allow_all";        
    }
    else
    {
        Command = Command @ "deny_all";
    }
    // End:0xD5
    if(!GetINIInt("Item", "ExpItemCnt", Count, a_OptionFile))
    {
        Count = 0;
    }
    i = 0;
    J0xDC:

    // End:0x18D [Loop If]
    if(i < Count)
    {
        // End:0x141
        if(!GetINIInt("Item", "ExpItemID" $ string(i), Id, a_OptionFile))
        {
            DialogShow(1, 5, MakeFullSystemMsg(GetSystemMessage(1427), string(i)), string(self));
            return false;
        }
        // End:0x15F
        if(1 == DefaultAllow)
        {
            Command = Command @ "D";            
        }
        else
        {
            Command = Command @ "A";
        }
        Command = Command $ string(Id);
        ++i;
        // [Loop Continue]
        goto J0xDC;
    }
    ExecuteCommand(Command);
    return true;
    return;
}

function bool ApplyBuffRule()
{
    local string OptionFile, Command;
    local int i, Count, Level, Id;

    OptionFile = m_hOptionFileEditBox.GetString();
    // End:0x53
    if(!GetINIInt("Buff", "BuffCnt", Count, OptionFile))
    {
        DialogShow(1, 5, GetSystemMessage(1422), string(self));
        return false;
    }
    // End:0x60
    if(0 >= Count)
    {
        return true;
    }
    Command = "//eventmatch useskill" @ string(m_MatchID);
    i = 0;
    J0x8D:

    // End:0x169 [Loop If]
    if(i < Count)
    {
        // End:0xEF
        if(!GetINIInt("Buff", "BuffID" $ string(i), Id, OptionFile))
        {
            DialogShow(1, 5, MakeFullSystemMsg(GetSystemMessage(1423), string(i)), string(self));
            return false;
        }
        // End:0x142
        if(!GetINIInt("Buff", "BuffLv" $ string(i), Level, OptionFile))
        {
            DialogShow(1, 5, MakeFullSystemMsg(GetSystemMessage(1424), string(i)), string(self));
            return false;
        }
        Command = (Command @ string(Id)) @ string(Level);
        ++i;
        // [Loop Continue]
        goto J0x8D;
    }
    ExecuteCommand(Command);
    return true;
    return;
}

function bool CheckBuffRule(string a_OptionFile)
{
    local int i, Count, Level, Id;

    // End:0x3E
    if(!GetINIInt("Buff", "BuffCnt", Count, a_OptionFile))
    {
        DialogShow(1, 5, GetSystemMessage(1422), string(self));
        return false;
    }
    i = 0;
    J0x45:

    // End:0x104 [Loop If]
    if(i < Count)
    {
        // End:0xA7
        if(!GetINIInt("Buff", "BuffID" $ string(i), Id, a_OptionFile))
        {
            DialogShow(1, 5, MakeFullSystemMsg(GetSystemMessage(1423), string(i)), string(self));
            return false;
        }
        // End:0xFA
        if(!GetINIInt("Buff", "BuffLv" $ string(i), Level, a_OptionFile))
        {
            DialogShow(1, 5, MakeFullSystemMsg(GetSystemMessage(1424), string(i)), string(self));
            return false;
        }
        ++i;
        // [Loop Continue]
        goto J0x45;
    }
    return true;
    return;
}

function SetFence()
{
    // End:0x5E
    if(m_hSetFenceButton.GetButtonName() == GetSystemString(1081))
    {
        m_hSetFenceButton.SetButtonName(1082);
        ExecuteCommand(("//eventmatch fence" @ string(m_MatchID)) @ "2");        
    }
    else
    {
        // End:0xB9
        if(m_hSetFenceButton.GetButtonName() == GetSystemString(1082))
        {
            m_hSetFenceButton.SetButtonName(1081);
            ExecuteCommand(("//eventmatch fence" @ string(m_MatchID)) @ "1");
        }
    }
    return;
}

function RemoveEventMatch()
{
    m_Team1Name = "";
    m_Team2Name = "";
    ExecuteCommand("//eventmatch remove" @ string(m_MatchID));
    GotoState('WaitingState');
    return;
}

function SetScore()
{
    ExecuteCommand((("//eventmatch score" @ string(m_MatchID)) @ m_hTeam1ScoreEditBox.GetString()) @ m_hTeam2ScoreEditBox.GetString());
    return;
}

function SendAnnounce()
{
    ExecuteCommand((((("//eventmatch msg" @ string(m_MatchID)) @ string(0)) @ "\"") @ m_hAnnounceEditBox.GetString()) @ "\"");
    m_hAnnounceEditBox.Clear();
    return;
}

function SendGameEndMsg()
{
    ExecuteCommand((("//eventmatch msg" @ string(m_MatchID)) @ string(3)) @ "NULL");
    return;
}

function Firecracker(int a_TeamID)
{
    local int PartyMemberCount, i;
    local EventMatchUserData UserData;

    PartyMemberCount = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(a_TeamID);
    i = 0;
    J0x21:

    // End:0x87 [Loop If]
    if(i < PartyMemberCount)
    {
        // End:0x7D
        if(Class'NWindow.EventMatchAPI'.static.GetUserData(a_TeamID, i, UserData))
        {
            ExecuteCommand("//eventmatch firecracker" @ UserData.Username);
        }
        ++i;
        // [Loop Continue]
        goto J0x21;
    }
    return;
}

function HandleEventMatchPartyLeader(string a_Param)
{
    local int TeamIdx;
    local string Username;

    Debug("HandleEventMatchPartyLeader a_Param=" @ a_Param);
    ParseInt(a_Param, "TeamIndex", TeamIdx);
    ParseString(a_Param, "UserName", Username);
    switch(TeamIdx)
    {
        // End:0x8A
        case 1:
            m_hTeam1LeaderNameEditBox.SetString(Username);
            // End:0xA9
            break;
        // End:0xA6
        case 2:
            m_hTeam2LeaderNameEditBox.SetString(Username);
            // End:0xA9
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleEventMatchManage(string a_Param)
{
    local int MatchID, MatchStat, FenceStat;
    local string Team1Name, Team2Name;
    local int Team1Stat, Team2Stat;

    ParseInt(a_Param, "MatchID", MatchID);
    ParseInt(a_Param, "MatchStat", MatchStat);
    ParseInt(a_Param, "FenceStat", FenceStat);
    ParseString(a_Param, "Team1Name", Team1Name);
    ParseString(a_Param, "Team2Name", Team2Name);
    ParseInt(a_Param, "Team1Stat", Team1Stat);
    ParseInt(a_Param, "Team2Stat", Team2Stat);
    GotoState('WaitingState');
    SetMatchID(MatchID);
    switch(MatchStat)
    {
        // End:0xE2
        case 1:
            GotoState('CreatedState');
            // End:0x111
            break;
        // End:0xF8
        case 2:
            GotoState('GamingState');
            SetPause(false);
            // End:0x111
            break;
        // End:0x10E
        case 3:
            GotoState('GamingState');
            SetPause(true);
            // End:0x111
            break;
        // End:0xFFFF
        default:
            break;
    }
    switch(FenceStat)
    {
        // End:0x11C
        case 0:
        // End:0x137
        case 1:
            m_hSetFenceButton.SetButtonName(1081);
            // End:0x156
            break;
        // End:0x153
        case 2:
            m_hSetFenceButton.SetButtonName(1082);
            // End:0x156
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x180
    if(0 == Team1Stat)
    {
        m_hLockTeam1Button.SetButtonName(1071);
        m_Team1Locked = false;        
    }
    else
    {
        m_hLockTeam1Button.SetButtonName(1072);
        m_Team1Locked = true;
    }
    // End:0x1C6
    if(0 == Team2Stat)
    {
        m_hLockTeam2Button.SetButtonName(1071);
        m_Team2Locked = false;        
    }
    else
    {
        m_hLockTeam2Button.SetButtonName(1072);
        m_Team2Locked = true;
    }
    m_hTeam1NameEditBox.SetString(Team1Name);
    m_hTeam2NameEditBox.SetString(Team2Name);
    m_hTeam1ListCtrl.DeleteAllItem();
    m_hTeam2ListCtrl.DeleteAllItem();
    return;
}

function SetPause(bool a_Pause, optional bool a_SendToServer)
{
    // End:0x13
    if(m_Paused == a_Pause)
    {
        return;
    }
    // End:0x5F
    if(a_Pause)
    {
        m_hPauseButton.SetButtonName(1074);
        // End:0x5C
        if(a_SendToServer)
        {
            ExecuteCommand("//eventmatch pause" @ string(m_MatchID));
        }        
    }
    else
    {
        m_hPauseButton.SetButtonName(1073);
        // End:0x9F
        if(a_SendToServer)
        {
            ExecuteCommand("//eventmatch start" @ string(m_MatchID));
        }
    }
    m_Paused = a_Pause;
    return;
}

function SetMatchID(int a_MatchID)
{
    m_MatchID = a_MatchID;
    // End:0x2E
    if(-1 == m_MatchID)
    {
        m_hMatchIDTextBox.SetText("");        
    }
    else
    {
        m_hMatchIDTextBox.SetText(string(m_MatchID));
    }
    return;
}

function OnClickSummon2Team()
{
    local int i, PartyMemberCount;
    local EventMatchUserData UserData;

    PartyMemberCount = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(1);
    i = 0;
    J0x1D:

    // End:0x6F [Loop If]
    if(i < PartyMemberCount)
    {
        // End:0x65
        if(Class'NWindow.EventMatchAPI'.static.GetUserData(1, i, UserData))
        {
            ExecuteCommand("//recall" @ UserData.Username);
        }
        ++i;
        // [Loop Continue]
        goto J0x1D;
    }
    return;
}

function OnClickSetAllHeal()
{
    local int PartyMemberCount0, PartyMemberCount1;
    local EventMatchUserData UserData;
    local int i;

    PartyMemberCount0 = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(0);
    PartyMemberCount1 = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(1);
    i = 0;
    J0x33:

    // End:0x86 [Loop If]
    if(i < PartyMemberCount0)
    {
        // End:0x7C
        if(Class'NWindow.EventMatchAPI'.static.GetUserData(0, i, UserData))
        {
            ExecuteCommand("//healthy" @ UserData.Username);
        }
        ++i;
        // [Loop Continue]
        goto J0x33;
    }
    i = 0;
    J0x8D:

    // End:0xE0 [Loop If]
    if(i < PartyMemberCount1)
    {
        // End:0xD6
        if(Class'NWindow.EventMatchAPI'.static.GetUserData(1, i, UserData))
        {
            ExecuteCommand("//healthy" @ UserData.Username);
        }
        ++i;
        // [Loop Continue]
        goto J0x8D;
    }
    return;
}

function OnClickDelayReset()
{
    local int PartyMemberCount0, PartyMemberCount1;
    local EventMatchUserData UserData;
    local int i;

    PartyMemberCount0 = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(0);
    PartyMemberCount1 = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(1);
    i = 0;
    J0x33:

    // End:0xA4 [Loop If]
    if(i < PartyMemberCount0)
    {
        // End:0x9A
        if(Class'NWindow.EventMatchAPI'.static.GetUserData(0, i, UserData))
        {
            ExecuteCommand("/target" @ UserData.Username);
            ExecuteCommand("//remove_skill_delay_all");
        }
        ++i;
        // [Loop Continue]
        goto J0x33;
    }
    i = 1;
    J0xAB:

    // End:0x11C [Loop If]
    if(i < PartyMemberCount1)
    {
        // End:0x112
        if(Class'NWindow.EventMatchAPI'.static.GetUserData(1, i, UserData))
        {
            ExecuteCommand("/target" @ UserData.Username);
            ExecuteCommand("//remove_skill_delay_all");
        }
        ++i;
        // [Loop Continue]
        goto J0xAB;
    }
    return;
}

function OnClickSummon1Team()
{
    local int PartyMemberCount, i;
    local EventMatchUserData UserData;

    PartyMemberCount = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(0);
    i = 0;
    J0x1D:

    // End:0x6F [Loop If]
    if(i < PartyMemberCount)
    {
        // End:0x65
        if(Class'NWindow.EventMatchAPI'.static.GetUserData(0, i, UserData))
        {
            ExecuteCommand("//recall" @ UserData.Username);
        }
        ++i;
        // [Loop Continue]
        goto J0x1D;
    }
    return;
}

state HidingState
{
    function BeginState()
    {
        m_hOwnerWnd.HideWindow();
        return;
    }

    function EndState()
    {
        m_hOwnerWnd.ShowWindow();
        return;
    }

    function HandleShowEventMatchGMWnd()
    {
        GotoState('WaitingState');
        return;
    }
    stop;
}

state WaitingState
{
    function BeginState()
    {
        SetMatchID(-1);
        m_hTeam1NameEditBox.Clear();
        m_hTeam2NameEditBox.Clear();
        m_hTeam1LeaderNameEditBox.Clear();
        m_hTeam2LeaderNameEditBox.Clear();
        m_hLockTeam1Button.SetButtonName(1071);
        m_hLockTeam2Button.SetButtonName(1071);
        m_hTeam1ListCtrl.DeleteAllItem();
        m_hTeam2ListCtrl.DeleteAllItem();
        m_Team1Locked = false;
        m_Team2Locked = false;
        SetPause(false);
        m_hCreateEventMatchButton.SetButtonName(1068);
        m_hCreateEventMatchButton.EnableWindow();
        m_hSetTeam1LeaderButton.DisableWindow();
        m_hLockTeam1Button.DisableWindow();
        m_hSetTeam2LeaderButton.DisableWindow();
        m_hLockTeam2Button.DisableWindow();
        m_hPauseButton.DisableWindow();
        m_hStartButton.DisableWindow();
        m_hSetScoreButton.DisableWindow();
        m_hSendAnnounceButton.DisableWindow();
        m_hSendGameEndMsgButton.DisableWindow();
        m_hSetFenceButton.DisableWindow();
        m_hTeam1FirecrackerButton.DisableWindow();
        m_hTeam2FirecrackerButton.DisableWindow();
        return;
    }

    function OnClickCreateEventMatchButton()
    {
        local string Team1Name, Team2Name;

        Team1Name = m_hTeam1NameEditBox.GetString();
        // End:0x3B
        if(Team1Name == "")
        {
            DialogShow(1, 5, GetSystemMessage(1418), string(self));
            return;
        }
        Team2Name = m_hTeam2NameEditBox.GetString();
        // End:0x76
        if(Team2Name == "")
        {
            DialogShow(1, 5, GetSystemMessage(1419), string(self));
            return;
        }
        // End:0x9F
        if(Team1Name == Team2Name)
        {
            DialogShow(1, 5, GetSystemMessage(1420), string(self));
            return;
        }
        m_Team1Name = Team1Name;
        m_Team2Name = Team2Name;
        m_hEventMatchGMFenceWnd.ShowWindow();
        m_hEventMatchGMFenceWnd.SetFocus();
        return;
    }

    function NotifyFenceInfo(Vector a_Position, int a_XLength, int a_YLength)
    {
        ExecuteCommand((((((("//eventmatch create 1" @ m_Team1Name) @ m_Team2Name) @ string(int(a_Position.X))) @ string(int(a_Position.Y))) @ string(int(a_Position.Z))) @ string(a_XLength)) @ string(a_YLength));
        GotoState('CreatingState');
        return;
    }
    stop;
}

state CreatingState
{
    function BeginState()
    {
        m_hCreateEventMatchButton.SetButtonName(1099);
        m_hCreateEventMatchButton.DisableWindow();
        return;
    }

    function HandleEventMatchCreated(string a_Param)
    {
        local int MatchID;

        // End:0x2E
        if(ParseInt(a_Param, "MatchID", MatchID))
        {
            SetMatchID(MatchID);
            GotoState('CreatedState');
        }
        return;
    }
    stop;
}

state CreatedState
{
    function BeginState()
    {
        m_hCreateEventMatchButton.SetButtonName(1069);
        m_hStartButton.SetButtonName(1075);
        m_hSetFenceButton.SetButtonName(1081);
        m_hCreateEventMatchButton.EnableWindow();
        m_hSetTeam1LeaderButton.EnableWindow();
        m_hLockTeam1Button.EnableWindow();
        m_hSetTeam2LeaderButton.EnableWindow();
        m_hLockTeam2Button.EnableWindow();
        m_hPauseButton.DisableWindow();
        RefreshLockStatus();
        m_hSetScoreButton.EnableWindow();
        m_hSendAnnounceButton.EnableWindow();
        m_hSendGameEndMsgButton.EnableWindow();
        m_hSetFenceButton.EnableWindow();
        m_hTeam1FirecrackerButton.EnableWindow();
        m_hTeam2FirecrackerButton.EnableWindow();
        SetPause(false);
        return;
    }

    function OnClickCreateEventMatchButton()
    {
        RemoveEventMatch();
        return;
    }

    function OnClickSetTeam1LeaderButton()
    {
        local UserInfo targetInfo;

        // End:0x27
        if(GetTargetInfo(targetInfo))
        {
            m_hTeam1LeaderNameEditBox.SetString(targetInfo.Name);
        }
        return;
    }

    function OnClickLockTeam1Button()
    {
        local string OptionFile;

        OptionFile = m_hOptionFileEditBox.GetString();
        // End:0x7B
        if(m_Team1Locked)
        {
            ExecuteCommand(("//eventmatch unlock" @ string(m_MatchID)) @ "1");
            m_hLockTeam1Button.SetButtonName(1071);
            m_Team1Locked = false;
            m_hTeam1ListCtrl.DeleteAllItem();
            RefreshLockStatus();            
        }
        else
        {
            ExecuteCommand((("//eventmatch leader" @ string(m_MatchID)) @ "1") @ m_hTeam1LeaderNameEditBox.GetString());
            ExecuteCommand(("//eventmatch lock" @ string(m_MatchID)) @ "1");
        }
        RefreshINI(OptionFile);
        return;
    }

    function OnClickSetTeam2LeaderButton()
    {
        local UserInfo targetInfo;

        // End:0x27
        if(GetTargetInfo(targetInfo))
        {
            m_hTeam2LeaderNameEditBox.SetString(targetInfo.Name);
        }
        return;
    }

    function OnClickLockTeam2Button()
    {
        local string OptionFile;

        OptionFile = m_hOptionFileEditBox.GetString();
        // End:0x7B
        if(m_Team2Locked)
        {
            ExecuteCommand(("//eventmatch unlock" @ string(m_MatchID)) @ "2");
            m_hLockTeam2Button.SetButtonName(1071);
            m_Team2Locked = false;
            m_hTeam2ListCtrl.DeleteAllItem();
            RefreshLockStatus();            
        }
        else
        {
            ExecuteCommand((("//eventmatch leader" @ string(m_MatchID)) @ "2") @ m_hTeam2LeaderNameEditBox.GetString());
            ExecuteCommand(("//eventmatch lock" @ string(m_MatchID)) @ "2");
        }
        RefreshINI(OptionFile);
        return;
    }

    function RefreshLockStatus()
    {
        // End:0x26
        if(m_Team1Locked && m_Team2Locked)
        {
            m_hStartButton.EnableWindow();            
        }
        else
        {
            m_hStartButton.DisableWindow();
        }
        return;
    }

    function OnClickSetFenceButton()
    {
        SetFence();
        return;
    }

    function OnClickStartButton()
    {
        local string OptionFile;

        OptionFile = m_hOptionFileEditBox.GetString();
        // End:0x3B
        if(OptionFile == "")
        {
            DialogShow(1, 5, GetSystemMessage(1421), string(self));
            return;
        }
        RefreshINI(OptionFile);
        // End:0x58
        if(!ApplySkillRule(OptionFile))
        {
            return;
        }
        // End:0x6A
        if(!ApplyItemRule(OptionFile))
        {
            return;
        }
        // End:0x7C
        if(!CheckBuffRule(OptionFile))
        {
            return;
        }
        GotoState('CountDownState');
        return;
    }

    function OnClickSetScoreButton()
    {
        SetScore();
        return;
    }

    function OnClickSendAnnounceButton()
    {
        SendAnnounce();
        return;
    }

    function OnClickSendGameEngMsgButton()
    {
        SendGameEndMsg();
        return;
    }

    function OnClickTeam1FirecrackerButton()
    {
        Firecracker(0);
        return;
    }

    function OnClickTeam2FirecrackerButton()
    {
        Firecracker(1);
        return;
    }

    function OnCompleteEditBox(string a_EditBoxID)
    {
        // End:0x21
        if(a_EditBoxID == "AnnounceEditBox")
        {
            SendAnnounce();
        }
        return;
    }
    stop;
}

state CountDownState
{
    function BeginState()
    {
        m_hStartButton.DisableWindow();
        m_hStartButton.SetButtonName(1102);
        m_hOwnerWnd.SetTimer(1, 1000);
        m_CountDown = 4;
        ExecuteCommand((("//eventmatch msg" @ string(m_MatchID)) @ string(8)) @ "NULL");
        return;
    }

    function OnClickCreateEventMatchButton()
    {
        RemoveEventMatch();
        return;
    }

    function OnClickSetFenceButton()
    {
        SetFence();
        return;
    }

    function OnTimer(int a_TimerID)
    {
        switch(a_TimerID)
        {
            // End:0x199
            case 1:
                switch(m_CountDown)
                {
                    // End:0x51
                    case 4:
                        ExecuteCommand((("//eventmatch msg" @ string(m_MatchID)) @ string(7)) @ "NULL");
                        m_CountDown = 3;
                        // End:0x196
                        break;
                    // End:0x90
                    case 3:
                        ExecuteCommand((("//eventmatch msg" @ string(m_MatchID)) @ string(6)) @ "NULL");
                        m_CountDown = 2;
                        // End:0x196
                        break;
                    // End:0xCE
                    case 2:
                        ExecuteCommand((("//eventmatch msg" @ string(m_MatchID)) @ string(5)) @ "NULL");
                        m_CountDown = 1;
                        // End:0x196
                        break;
                    // End:0x10B
                    case 1:
                        ExecuteCommand((("//eventmatch msg" @ string(m_MatchID)) @ string(4)) @ "NULL");
                        m_CountDown = 0;
                        // End:0x196
                        break;
                    // End:0x175
                    case 0:
                        ExecuteCommand((("//eventmatch msg" @ string(m_MatchID)) @ string(2)) @ "NULL");
                        // End:0x14B
                        if(!ApplyBuffRule())
                        {
                            return;
                        }
                        ExecuteCommand("//eventmatch start" @ string(m_MatchID));
                        GotoState('GamingState');
                    // End:0xFFFF
                    default:
                        m_hOwnerWnd.KillTimer(1);
                        m_CountDown = -1;
                        // End:0x196
                        break;
                        break;
                }
                // End:0x19C
                break;
            // End:0xFFFF
            default:
                break;
        }
        return;
    }

    function OnClickSetScoreButton()
    {
        SetScore();
        return;
    }

    function OnClickSendAnnounceButton()
    {
        SendAnnounce();
        return;
    }

    function OnClickSendGameEngMsgButton()
    {
        SendGameEndMsg();
        return;
    }

    function OnClickTeam1FirecrackerButton()
    {
        Firecracker(0);
        return;
    }

    function OnClickTeam2FirecrackerButton()
    {
        Firecracker(1);
        return;
    }

    function OnCompleteEditBox(string a_EditBoxID)
    {
        // End:0x21
        if(a_EditBoxID == "AnnounceEditBox")
        {
            SendAnnounce();
        }
        return;
    }
    stop;
}

state GamingState
{
    function BeginState()
    {
        m_hPauseButton.SetButtonName(1073);
        m_hStartButton.SetButtonName(1076);
        m_hCreateEventMatchButton.EnableWindow();
        m_hSetTeam1LeaderButton.DisableWindow();
        m_hLockTeam1Button.DisableWindow();
        m_hSetTeam2LeaderButton.DisableWindow();
        m_hLockTeam2Button.DisableWindow();
        m_hPauseButton.EnableWindow();
        m_hStartButton.EnableWindow();
        m_hSetScoreButton.EnableWindow();
        m_hSendAnnounceButton.EnableWindow();
        m_hSendGameEndMsgButton.EnableWindow();
        m_hSetFenceButton.EnableWindow();
        m_hTeam1FirecrackerButton.EnableWindow();
        m_hTeam2FirecrackerButton.EnableWindow();
        return;
    }

    function OnClickCreateEventMatchButton()
    {
        RemoveEventMatch();
        return;
    }

    function OnClickStartButton()
    {
        ExecuteCommand("//eventmatch dispelall" @ string(m_MatchID));
        ExecuteCommand("//eventmatch end" @ string(m_MatchID));
        ExecuteCommand((("//eventmatch msg" @ string(m_MatchID)) @ string(1)) @ "NULL");
        GotoState('CreatedState');
        return;
    }

    function OnClickSetFenceButton()
    {
        SetFence();
        return;
    }

    function OnClickPauseButton()
    {
        SetPause(!m_Paused, true);
        return;
    }

    function OnClickSetScoreButton()
    {
        SetScore();
        return;
    }

    function OnClickSendAnnounceButton()
    {
        SendAnnounce();
        return;
    }

    function OnClickSendGameEngMsgButton()
    {
        SendGameEndMsg();
        return;
    }

    function OnClickTeam1FirecrackerButton()
    {
        Firecracker(0);
        return;
    }

    function OnClickTeam2FirecrackerButton()
    {
        Firecracker(1);
        return;
    }

    function OnCompleteEditBox(string a_EditBoxID)
    {
        // End:0x21
        if(a_EditBoxID == "AnnounceEditBox")
        {
            SendAnnounce();
        }
        return;
    }
    stop;
}
