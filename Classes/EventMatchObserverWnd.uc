class EventMatchObserverWnd extends UICommonAPI;

const TIMERID_Show = 1;
const TIMERID_Msg = 2;

enum EMessageMode
{
    MESSAGEMODE_Normal,             // 0
    MESSAGEMODE_LeftRight,          // 1
    MESSAGEMODE_Off                 // 2
};

struct SkillMsgInfo
{
    var int AttackerTeamID;
    var int AttackerUserID;
    var string AttackerName;
    var int DefenderTeamID;
    var int DefenderUserID;
    var string DefenderName;
    var string SkillName;
};

var int m_Score1;
var int m_Score2;
var string m_TeamName1;
var string m_TeamName2;
var int m_SelectedUserID[2];
var bool m_ClassOrName;
var WindowHandle m_hTopWnd;
var WindowHandle m_hPlayerWnd[2];
var BarHandle m_hPlayerCPBar[2];
var BarHandle m_hPlayerHPBar[2];
var BarHandle m_hPlayerMPBar[2];
var TextureHandle m_hplayerback1_[2];
var TextureHandle m_hplayerback2_[2];
var TextureHandle m_hplayerback3_[2];
var TextBoxHandle m_hPlayerLvClassTextBox[2];
var TextBoxHandle m_hPlayerNameTextBox[2];
var WindowHandle m_hPlayerBuffCoverWnd[2];
var StatusIconHandle m_hPlayerBuffWnd[2];
var WindowHandle m_hParty1Wnd;
var WindowHandle m_hParty1MemberWnd[9];
var TextBoxHandle m_hParty1MemberNameTextBox[9];
var TextBoxHandle m_hParty1MemberClassTextBox[9];
var BarHandle m_hParty1MemberHPBar[9];
var BarHandle m_hParty1MemberCPBar[9];
var BarHandle m_hParty1MemberMPBar[9];
var WindowHandle m_hParty1MemberSelectedTex[9];
var TextureHandle m_hParty1NumberTex[9];
var TextureHandle m_hparty1back1_[9];
var TextureHandle m_hparty1back2_[9];
var TextureHandle m_hparty1back3_[9];
var WindowHandle m_hParty2Wnd;
var WindowHandle m_hParty2MemberWnd[9];
var TextBoxHandle m_hParty2MemberNameTextBox[9];
var TextBoxHandle m_hParty2MemberClassTextBox[9];
var BarHandle m_hParty2MemberHPBar[9];
var BarHandle m_hParty2MemberCPBar[9];
var BarHandle m_hParty2MemberMPBar[9];
var WindowHandle m_hParty2MemberSelectedTex[9];
var TextureHandle m_hParty2NumberTex[9];
var TextureHandle m_hparty2back1_[9];
var TextureHandle m_hparty2back2_[9];
var TextureHandle m_hparty2back3_[9];
var TextBoxHandle m_hTeamName1TextBox;
var TextBoxHandle m_hTeamName2TextBox;
var TextureHandle m_hScore1Tex;
var TextureHandle m_hScore2Tex;
var WindowHandle m_hMsgLeftWnd[6];
var TextBoxHandle m_hMsgLeftAttackerTextBox[6];
var TextBoxHandle m_hMsgLeftDefenderTextBox[6];
var TextBoxHandle m_hMsgLeftSkillTextBox[6];
var WindowHandle m_hMsgRightWnd[6];
var TextBoxHandle m_hMsgRightAttackerTextBox[6];
var TextBoxHandle m_hMsgRightDefenderTextBox[6];
var TextBoxHandle m_hMsgRightSkillTextBox[6];
var WindowHandle m_hMsgWnd;
var string m_WindowName;
var WindowHandle m_hObserverEndWnd;
var int m_Party1UserIDList[9];
var int m_Party2UserIDList[9];
var int m_MsgStartIndex;
var int m_Team1MsgStartIndex;
var int m_Team2MsgStartIndex;
var SkillMsgInfo m_MsgList[6];
var SkillMsgInfo m_Team1MsgList[6];
var SkillMsgInfo m_Team2MsgList[6];
var EventMatchObserverWnd.EMessageMode m_MsgMode;
var int m_MatchID;

function OnRegisterEvent()
{
    RegisterEvent(2220);
    RegisterEvent(2240);
    RegisterEvent(2230);
    RegisterEvent(2250);
    RegisterEvent(2260);
    RegisterEvent(290);
    RegisterEvent(90);
    return;
}

function OnLoad()
{
    InitHandleCOD();
    m_MatchID = 0;
    return;
}

function InitHandleCOD()
{
    local int i;

    m_hTopWnd = GetWindowHandle("TopWnd");
    m_hTeamName1TextBox = GetTextBoxHandle("TopWnd.TeamName1");
    m_hTeamName2TextBox = GetTextBoxHandle("TopWnd.TeamName2");
    m_hScore1Tex = GetTextureHandle("TopWnd.Score1Tex");
    m_hScore2Tex = GetTextureHandle("TopWnd.Score2Tex");
    i = 0;
    J0x93:

    // End:0x2F7 [Loop If]
    if(i < 2)
    {
        m_hPlayerWnd[i] = GetWindowHandle(("Player" $ string(i + 1)) $ "Wnd");
        m_hPlayerCPBar[i] = GetBarHandle(("Player" $ string(i + 1)) $ "Wnd.CPBar");
        m_hPlayerHPBar[i] = GetBarHandle(("Player" $ string(i + 1)) $ "Wnd.HPBar");
        m_hPlayerMPBar[i] = GetBarHandle(("Player" $ string(i + 1)) $ "Wnd.MPBar");
        m_hPlayerLvClassTextBox[i] = GetTextBoxHandle(("Player" $ string(i + 1)) $ "Wnd.LvClassTextBox");
        m_hPlayerNameTextBox[i] = GetTextBoxHandle(("Player" $ string(i + 1)) $ "Wnd.NameTextBox");
        m_hPlayerBuffCoverWnd[i] = GetWindowHandle(("Player" $ string(i + 1)) $ "BuffWnd");
        m_hPlayerBuffWnd[i] = GetStatusIconHandle(("Player" $ string(i + 1)) $ "BuffWnd.StatusIconCtrl");
        m_hplayerback1_[i] = GetTextureHandle(("Player" $ string(i + 1)) $ "Wnd.BackTex1");
        m_hplayerback2_[i] = GetTextureHandle(("Player" $ string(i + 1)) $ "Wnd.BackTex2");
        m_hplayerback3_[i] = GetTextureHandle(("Player" $ string(i + 1)) $ "Wnd.BackTex3");
        ++i;
        // [Loop Continue]
        goto J0x93;
    }
    m_hParty1Wnd = GetWindowHandle("Party1Wnd");
    i = 0;
    J0x315:

    // End:0x60D [Loop If]
    if(i < 9)
    {
        m_hParty1MemberWnd[i] = GetWindowHandle(("Party1Wnd.PartyMember" $ string(i + 1)) $ "Wnd");
        m_hParty1MemberNameTextBox[i] = GetTextBoxHandle(("Party1Wnd.PartyMember" $ string(i + 1)) $ "Wnd.Name");
        m_hParty1MemberClassTextBox[i] = GetTextBoxHandle(("Party1Wnd.PartyMember" $ string(i + 1)) $ "Wnd.Class");
        m_hParty1MemberHPBar[i] = GetBarHandle(("Party1Wnd.PartyMember" $ string(i + 1)) $ "Wnd.HPBar");
        m_hParty1MemberCPBar[i] = GetBarHandle(("Party1Wnd.PartyMember" $ string(i + 1)) $ "Wnd.CPBar");
        m_hParty1MemberMPBar[i] = GetBarHandle(("Party1Wnd.PartyMember" $ string(i + 1)) $ "Wnd.MPBar");
        m_hParty1MemberSelectedTex[i] = GetWindowHandle(("Party1Wnd.PartyMember" $ string(i + 1)) $ "Wnd.SelectedTex");
        m_hParty1NumberTex[i] = GetTextureHandle(("Party1Wnd.PartyMember" $ string(i + 1)) $ "Wnd.NumberTex");
        m_hparty1back1_[i] = GetTextureHandle(("Party1Wnd.PartyMember" $ string(i + 1)) $ "Wnd.BackTex1");
        m_hparty1back2_[i] = GetTextureHandle(("Party1Wnd.PartyMember" $ string(i + 1)) $ "Wnd.BackTex2");
        m_hparty1back3_[i] = GetTextureHandle(("Party1Wnd.PartyMember" $ string(i + 1)) $ "Wnd.BackTex3");
        ++i;
        // [Loop Continue]
        goto J0x315;
    }
    m_hParty2Wnd = GetWindowHandle("Party2Wnd");
    i = 0;
    J0x62B:

    // End:0x92E [Loop If]
    if(i < 9)
    {
        m_hParty2MemberWnd[i] = GetWindowHandle(("Party2Wnd.PartyMember" $ string(i + 1)) $ "Wnd2");
        m_hParty2MemberNameTextBox[i] = GetTextBoxHandle(("Party2Wnd.PartyMember" $ string(i + 1)) $ "Wnd2.Name");
        m_hParty2MemberClassTextBox[i] = GetTextBoxHandle(("Party2Wnd.PartyMember" $ string(i + 1)) $ "Wnd2.Class");
        m_hParty2MemberHPBar[i] = GetBarHandle(("Party2Wnd.PartyMember" $ string(i + 1)) $ "Wnd2.HPBar");
        m_hParty2MemberCPBar[i] = GetBarHandle(("Party2Wnd.PartyMember" $ string(i + 1)) $ "Wnd2.CPBar");
        m_hParty2MemberMPBar[i] = GetBarHandle(("Party2Wnd.PartyMember" $ string(i + 1)) $ "Wnd2.MPBar");
        m_hParty2MemberSelectedTex[i] = GetWindowHandle(("Party2Wnd.PartyMember" $ string(i + 1)) $ "Wnd2.SelectedTex");
        m_hParty2NumberTex[i] = GetTextureHandle(("Party2Wnd.PartyMember" $ string(i + 1)) $ "Wnd2.NumberTex");
        m_hparty2back1_[i] = GetTextureHandle(("Party2Wnd.PartyMember" $ string(i + 1)) $ "Wnd2.BackTex1");
        m_hparty2back2_[i] = GetTextureHandle(("Party2Wnd.PartyMember" $ string(i + 1)) $ "Wnd2.BackTex2");
        m_hparty2back3_[i] = GetTextureHandle(("Party2Wnd.PartyMember" $ string(i + 1)) $ "Wnd2.BackTex3");
        ++i;
        // [Loop Continue]
        goto J0x62B;
    }
    i = 0;
    J0x935:

    // End:0xB7A [Loop If]
    if(i < 6)
    {
        m_hMsgLeftWnd[i] = GetWindowHandle("MsgWnd.MsgLeft.Msg" $ string(i + 1));
        m_hMsgRightWnd[i] = GetWindowHandle(("MsgWnd.MsgRight.Msg" $ string(i + 1)) $ "R");
        m_hMsgLeftAttackerTextBox[i] = GetTextBoxHandle((("MsgWnd.MsgLeft.Msg" $ string(i + 1)) $ ".Attacker") $ string(i + 1));
        m_hMsgLeftDefenderTextBox[i] = GetTextBoxHandle((("MsgWnd.MsgLeft.Msg" $ string(i + 1)) $ ".Defender") $ string(i + 1));
        m_hMsgLeftSkillTextBox[i] = GetTextBoxHandle((("MsgWnd.MsgLeft.Msg" $ string(i + 1)) $ ".Skill") $ string(i + 1));
        m_hMsgRightAttackerTextBox[i] = GetTextBoxHandle((("MsgWnd.MsgRight.Msg" $ string(i + 1)) $ "R.AttackerR") $ string(i + 1));
        m_hMsgRightDefenderTextBox[i] = GetTextBoxHandle((("MsgWnd.MsgRight.Msg" $ string(i + 1)) $ "R.DefenderR") $ string(i + 1));
        m_hMsgRightSkillTextBox[i] = GetTextBoxHandle((("MsgWnd.MsgRight.Msg" $ string(i + 1)) $ "R.SkillR") $ string(i + 1));
        ++i;
        // [Loop Continue]
        goto J0x935;
    }
    m_hMsgWnd = GetWindowHandle(m_WindowName $ ".MsgWnd");
    m_hObserverEndWnd = GetWindowHandle(m_WindowName $ ".UserObserverEndWnd");
    return;
}

function OnEnterState(name a_PreStateName)
{
    UpdateScore();
    UpdateTeamName();
    UpdateTeamInfo(0);
    UpdateTeamInfo(1);
    ClearMsg();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 2220:
            HandleStartEventMatchObserver(a_Param);
            // End:0x9A
            break;
        // End:0x2E
        case 2240:
            UpdateScore();
            // End:0x9A
            break;
        // End:0x3F
        case 2230:
            UpdateTeamName();
            // End:0x9A
            break;
        // End:0x55
        case 2250:
            HandleEventMatchUpdateTeamInfo(a_Param);
            // End:0x9A
            break;
        // End:0x6B
        case 2260:
            HandleEventMatchUpdateUserInfo(a_Param);
            // End:0x9A
            break;
        // End:0x81
        case 290:
            HandleReceiveMagicSkillUse(a_Param);
            // End:0x9A
            break;
        // End:0x94
        case 90:
            HandleShortcutCommand(a_Param);
            // End:0x9A
            break;
        // End:0xFFFF
        default:
            // End:0x9A
            break;
            break;
    }
    return;
}

function OnTimer(int a_TimerID)
{
    local int i;

    switch(a_TimerID)
    {
        // End:0x2D
        case 1:
            m_hOwnerWnd.KillTimer(1);
            m_hTopWnd.HideWindow();
            // End:0x129
            break;
        // End:0x126
        case 2:
            i = 0;
            J0x39:

            // End:0x123 [Loop If]
            if(i < 6)
            {
                // End:0xAF
                if(m_hMsgLeftWnd[i].IsShowWindow() && 0 != m_hMsgLeftWnd[i].GetAlpha())
                {
                    m_hMsgLeftWnd[i].SetAlpha(255);
                    m_hMsgLeftWnd[i].SetAlpha(0, 2.0000000);
                    // [Explicit Break]
                    goto J0x123;
                }
                // End:0x119
                if(m_hMsgRightWnd[i].IsShowWindow() && 0 != m_hMsgRightWnd[i].GetAlpha())
                {
                    m_hMsgRightWnd[i].SetAlpha(255);
                    m_hMsgRightWnd[i].SetAlpha(0, 2.0000000);
                    // [Explicit Break]
                    goto J0x123;
                }
                ++i;
                // [Loop Continue]
                goto J0x39;
            }
            J0x123:

            // End:0x129
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x48 [Loop If]
    if(i < 9)
    {
        // End:0x3E
        if(a_WindowHandle.IsChildOf(m_hParty1MemberWnd[i]))
        {
            SetSelectedUser(0, i);
            return;
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    i = 0;
    J0x4F:

    // End:0x90 [Loop If]
    if(i < 9)
    {
        // End:0x86
        if(a_WindowHandle.IsChildOf(m_hParty2MemberWnd[i]))
        {
            SetSelectedUser(1, i);
            return;
        }
        ++i;
        // [Loop Continue]
        goto J0x4F;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x2A
        case "btnStop":
            Class'NWindow.EventMatchAPI'.static.RequestEventMatchObserverEnd(m_MatchID);
            // End:0x2D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleStartEventMatchObserver(string a_Param)
{
    local int builder, MatchID;

    ParseInt(a_Param, "Builder", builder);
    // End:0x6A
    if(builder == 2)
    {
        m_hMsgWnd.HideWindow();
        m_hObserverEndWnd.ShowWindow();
        ParseInt(a_Param, "MatchID", MatchID);
        m_MatchID = MatchID;        
    }
    else
    {
        m_hObserverEndWnd.HideWindow();
        m_hMsgWnd.ShowWindow();
    }
    return;
}

function HandleEventMatchUpdateTeamInfo(string a_Param)
{
    local int TeamID;

    // End:0x26
    if(ParseInt(a_Param, "TeamID", TeamID))
    {
        UpdateTeamInfo(TeamID);
    }
    return;
}

function HandleEventMatchUpdateUserInfo(string a_Param)
{
    local int UserID, TeamID;

    ParseInt(a_Param, "UserID", UserID);
    ParseInt(a_Param, "TeamID", TeamID);
    UpdateUserInfo(TeamID, UserID);
    return;
}

function HandleReceiveMagicSkillUse(string a_Param)
{
    local int AttackerID, DefenderID, SkillID;
    local UserInfo AttackerInfo, DefenderInfo;
    local SkillInfo UsedSkillInfo;
    local int AttackerTeamID, AttackerUserID, DefenderTeamID, DefenderUserID;

    // End:0x24
    if(!IsShowWindow("EventMatchObserverWnd"))
    {
        return;
    }
    // End:0x47
    if(!ParseInt(a_Param, "AttackerID", AttackerID))
    {
        return;
    }
    // End:0x6A
    if(!ParseInt(a_Param, "DefenderID", DefenderID))
    {
        return;
    }
    // End:0x8A
    if(!ParseInt(a_Param, "SkillID", SkillID))
    {
        return;
    }
    // End:0xA6
    if(!GetTeamUserID(AttackerID, AttackerTeamID, AttackerUserID))
    {
        return;
    }
    // End:0xC2
    if(!GetTeamUserID(DefenderID, DefenderTeamID, DefenderUserID))
    {
        return;
    }
    // End:0xD9
    if(!GetUserInfo(AttackerID, AttackerInfo))
    {
        return;
    }
    // End:0xF0
    if(!GetUserInfo(DefenderID, DefenderInfo))
    {
        return;
    }
    // End:0x109
    if(!GetSkillInfo(SkillID, 1, 0, UsedSkillInfo))
    {
        return;
    }
    AddSkillMsg(AttackerTeamID, AttackerUserID, AttackerInfo.Name, DefenderTeamID, DefenderUserID, DefenderInfo.Name, UsedSkillInfo.SkillName);
    return;
}

function HandleShortcutCommand(string a_Param)
{
    local string Command;
    local bool Draggable;

    // End:0x3A6
    if(ParseString(a_Param, "Command", Command))
    {
        switch(Command)
        {
            // End:0xA3
            case "EventMatchShowPartyWindow":
                // End:0x74
                if(m_hParty1Wnd.IsShowWindow())
                {
                    m_hParty1Wnd.HideWindow();
                    m_hParty2Wnd.HideWindow();                    
                }
                else
                {
                    m_hParty1Wnd.ShowWindow();
                    m_hParty2Wnd.ShowWindow();
                    UpdateTeamInfo(0);
                    UpdateTeamInfo(1);
                }
                // End:0x3A6
                break;
            // End:0x16B
            case "EventMatchLockPosition":
                Draggable = m_hPlayerWnd[0].IsDraggable();
                m_hPlayerWnd[0].SetDraggable(!Draggable);
                m_hPlayerWnd[1].SetDraggable(!Draggable);
                m_hPlayerBuffCoverWnd[0].SetDraggable(!Draggable);
                m_hPlayerBuffCoverWnd[1].SetDraggable(!Draggable);
                m_hParty1Wnd.SetDraggable(!Draggable);
                m_hParty2Wnd.SetDraggable(!Draggable);
                // End:0x3A6
                break;
            // End:0x2F9
            case "EventMatchInitPosition":
                m_hPlayerWnd[0].SetAnchor("", "TopLeft", "TopLeft", 0, 98);
                m_hPlayerWnd[0].ClearAnchor();
                m_hPlayerWnd[1].SetAnchor("", "TopRight", "TopRight", 0, 98);
                m_hPlayerWnd[1].ClearAnchor();
                m_hPlayerBuffCoverWnd[0].SetAnchor("Player1Wnd", "BottomLeft", "TopLeft", 0, 0);
                m_hPlayerBuffCoverWnd[0].ClearAnchor();
                m_hPlayerBuffCoverWnd[1].SetAnchor("Player2Wnd", "BottomLeft", "TopLeft", 0, 0);
                m_hPlayerBuffCoverWnd[1].ClearAnchor();
                m_hParty1Wnd.SetAnchor("", "TopLeft", "TopLeft", 0, 340);
                m_hParty1Wnd.ClearAnchor();
                m_hParty2Wnd.SetAnchor("", "TopRight", "TopRight", 0, 340);
                m_hParty2Wnd.ClearAnchor();
                // End:0x3A6
                break;
            // End:0x335
            case "EventMatchToggleShowClassOrName":
                m_ClassOrName = !m_ClassOrName;
                RefreshClassOrName();
                // End:0x3A6
                break;
            // End:0x3A3
            case "EventMatchSwitchMessageMode":
                switch(m_MsgMode)
                {
                    // End:0x36C
                    case 0:
                        m_MsgMode = 1;
                        // End:0x39A
                        break;
                    // End:0x37C
                    case 1:
                        m_MsgMode = 2;
                        // End:0x39A
                        break;
                    // End:0x38C
                    case 2:
                        m_MsgMode = 0;
                        // End:0x39A
                        break;
                    // End:0xFFFF
                    default:
                        m_MsgMode = 0;
                        // End:0x39A
                        break;
                        break;
                }
                UpdateSkillMsg();
                // End:0x3A6
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

function RefreshClassOrName()
{
    local int i;

    // End:0x7D
    if(m_ClassOrName)
    {
        i = 0;
        J0x10:

        // End:0x7A [Loop If]
        if(i < 9)
        {
            m_hParty1MemberNameTextBox[i].HideWindow();
            m_hParty2MemberNameTextBox[i].HideWindow();
            m_hParty1MemberClassTextBox[i].ShowWindow();
            m_hParty2MemberClassTextBox[i].ShowWindow();
            ++i;
            // [Loop Continue]
            goto J0x10;
        }        
    }
    else
    {
        i = 0;
        J0x84:

        // End:0xEE [Loop If]
        if(i < 9)
        {
            m_hParty1MemberNameTextBox[i].ShowWindow();
            m_hParty2MemberNameTextBox[i].ShowWindow();
            m_hParty1MemberClassTextBox[i].HideWindow();
            m_hParty2MemberClassTextBox[i].HideWindow();
            ++i;
            // [Loop Continue]
            goto J0x84;
        }
    }
    return;
}

function UpdateTeamName()
{
    m_TeamName1 = Class'NWindow.EventMatchAPI'.static.GetTeamName(0);
    m_TeamName2 = Class'NWindow.EventMatchAPI'.static.GetTeamName(1);
    m_hTeamName1TextBox.SetText(m_TeamName1);
    m_hTeamName2TextBox.SetText(m_TeamName2);
    return;
}

function UpdateTeamInfo(int a_TeamID)
{
    local int i, PartyMemberCount;

    // End:0x1A
    if((0 != a_TeamID) && 1 != a_TeamID)
    {
        return;
    }
    PartyMemberCount = Class'NWindow.EventMatchAPI'.static.GetPartyMemberCount(a_TeamID);
    switch(a_TeamID)
    {
        // End:0xD1
        case 0:
            m_hParty1Wnd.SetWindowSize(280, 70 * PartyMemberCount);
            i = 0;
            J0x63:

            // End:0xCE [Loop If]
            if(i < 9)
            {
                // End:0xA2
                if(i < PartyMemberCount)
                {
                    m_hParty1MemberWnd[i].ShowWindow();
                    UpdateUserInfo(0, i);
                    // [Explicit Continue]
                    goto J0xC4;
                }
                m_hParty1MemberWnd[i].HideWindow();
                m_Party1UserIDList[i] = 0;
                J0xC4:

                ++i;
                // [Loop Continue]
                goto J0x63;
            }
            // End:0x16A
            break;
        // End:0x167
        case 1:
            m_hParty2Wnd.SetWindowSize(280, 70 * PartyMemberCount);
            i = 0;
            J0xF9:

            // End:0x164 [Loop If]
            if(i < 9)
            {
                // End:0x138
                if(i < PartyMemberCount)
                {
                    m_hParty2MemberWnd[i].ShowWindow();
                    UpdateUserInfo(1, i);
                    // [Explicit Continue]
                    goto J0x15A;
                }
                m_hParty2MemberWnd[i].HideWindow();
                m_Party2UserIDList[i] = 0;
                J0x15A:

                ++i;
                // [Loop Continue]
                goto J0xF9;
            }
            // End:0x16A
            break;
        // End:0xFFFF
        default:
            break;
    }
    SetSelectedUser(a_TeamID, -1);
    RefreshClassOrName();
    return;
}

function UpdateScore()
{
    m_Score1 = Class'NWindow.EventMatchAPI'.static.GetScore(0);
    m_Score2 = Class'NWindow.EventMatchAPI'.static.GetScore(1);
    m_hScore1Tex.SetTexture("L2UI_CH3.BroadcastObs.br_score" $ string(m_Score1));
    m_hScore2Tex.SetTexture("L2UI_CH3.BroadcastObs.br_score" $ string(m_Score2));
    m_hTopWnd.ShowWindow();
    m_hOwnerWnd.SetTimer(1, 7000);
    return;
}

function UpdateUserInfo(int a_TeamID, int a_UserID)
{
    local int i, CurRow;
    local EventMatchUserData UserData;
    local StatusIconInfo Info;
    local SkillInfo TheSkillInfo;
    local int Width, Height, buffLengthMax;

    // End:0xB3E
    if(Class'NWindow.EventMatchAPI'.static.GetUserData(a_TeamID, a_UserID, UserData))
    {
        switch(a_TeamID)
        {
            // End:0x3CB
            case 0:
                // End:0x1FC
                if(UserData.HPNow == 0)
                {
                    m_Party1UserIDList[a_UserID] = UserData.UserID;
                    m_hParty1MemberNameTextBox[a_UserID].SetText(UserData.Username);
                    m_hParty1MemberClassTextBox[a_UserID].SetText(GetClassType(UserData.UserClass));
                    m_hParty1MemberHPBar[a_UserID].SetValue(UserData.HPMax, UserData.HPNow);
                    m_hParty1MemberCPBar[a_UserID].SetValue(UserData.CPMax, UserData.CPNow);
                    m_hParty1MemberMPBar[a_UserID].SetValue(UserData.MPMax, UserData.MPNow);
                    m_hParty1NumberTex[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party_x");
                    m_hparty1back1_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back1");
                    m_hparty1back2_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back2");
                    m_hparty1back3_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back3");                    
                }
                else
                {
                    m_Party1UserIDList[a_UserID] = UserData.UserID;
                    m_hParty1MemberNameTextBox[a_UserID].SetText(UserData.Username);
                    m_hParty1MemberClassTextBox[a_UserID].SetText(GetClassType(UserData.UserClass));
                    m_hParty1MemberHPBar[a_UserID].SetValue(UserData.HPMax, UserData.HPNow);
                    m_hParty1MemberCPBar[a_UserID].SetValue(UserData.CPMax, UserData.CPNow);
                    m_hParty1MemberMPBar[a_UserID].SetValue(UserData.MPMax, UserData.MPNow);
                    m_hParty1NumberTex[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_" $ string(a_UserID + 1));
                    m_hparty1back1_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back1");
                    m_hparty1back2_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back2");
                    m_hparty1back3_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back3");
                }
                // End:0x717
                break;
            // End:0x714
            case 1:
                // End:0x545
                if(UserData.HPNow == 0)
                {
                    m_hParty2MemberHPBar[a_UserID].SetValue(UserData.HPMax, UserData.HPNow);
                    m_hParty2MemberCPBar[a_UserID].SetValue(UserData.CPMax, UserData.CPNow);
                    m_hParty2MemberMPBar[a_UserID].SetValue(UserData.MPMax, UserData.MPNow);
                    m_hParty2NumberTex[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party_x");
                    m_hparty2back1_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back1");
                    m_hparty2back2_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back2");
                    m_hparty2back3_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_dead2_back3");                    
                }
                else
                {
                    m_Party2UserIDList[a_UserID] = UserData.UserID;
                    m_hParty2MemberNameTextBox[a_UserID].SetText(UserData.Username);
                    m_hParty2MemberClassTextBox[a_UserID].SetText(GetClassType(UserData.UserClass));
                    m_hParty2MemberHPBar[a_UserID].SetValue(UserData.HPMax, UserData.HPNow);
                    m_hParty2MemberCPBar[a_UserID].SetValue(UserData.CPMax, UserData.CPNow);
                    m_hParty2MemberMPBar[a_UserID].SetValue(UserData.MPMax, UserData.MPNow);
                    m_hParty2NumberTex[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party1_" $ string(a_UserID + 1));
                    m_hparty2back1_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back1");
                    m_hparty2back2_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back2");
                    m_hparty2back3_[a_UserID].SetTexture("L2UI_CH3.BroadcastObs.br_party2_back3");
                }
                // End:0x717
                break;
            // End:0xFFFF
            default:
                break;
        }
        // End:0xB3B
        if(IsSelectedUser(a_TeamID, a_UserID))
        {
            m_hPlayerNameTextBox[a_TeamID].SetText(UserData.Username);
            m_hPlayerLvClassTextBox[a_TeamID].SetText((("Lv" $ string(UserData.UserLv)) $ " ") $ GetClassType(UserData.UserClass));
            m_hPlayerHPBar[a_TeamID].SetValue(UserData.HPMax, UserData.HPNow);
            m_hPlayerCPBar[a_TeamID].SetValue(UserData.CPMax, UserData.CPNow);
            m_hPlayerMPBar[a_TeamID].SetValue(UserData.MPMax, UserData.MPNow);
            // End:0x8C6
            if(UserData.HPNow == 0)
            {
                m_hplayerback1_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_dead1_back1");
                m_hplayerback2_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_dead1_back2");
                m_hplayerback3_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_dead1_back3");                
            }
            else
            {
                m_hplayerback1_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_party1_back1");
                m_hplayerback2_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_party1_back2");
                m_hplayerback3_[a_TeamID].SetTexture("L2UI_CH3.BroadcastObs.br_party1_back3");
            }
            m_hPlayerBuffWnd[a_TeamID].Clear();
            CurRow = -1;
            buffLengthMax = UserData.BuffIDList.Length;
            // End:0x9BF
            if(buffLengthMax > 24)
            {
                buffLengthMax = 24;
            }
            i = 0;
            J0x9C6:

            // End:0xAFD [Loop If]
            if(i < buffLengthMax)
            {
                // End:0xA06
                if(float(0) == (float(i) % float(12)))
                {
                    CurRow++;
                    m_hPlayerBuffWnd[a_TeamID].AddRow();
                }
                // End:0xAF3
                if(GetSkillInfo(UserData.BuffIDList[i], 1, 0, TheSkillInfo))
                {
                    Info.Size = 10;
                    Info.Id = GetItemID(UserData.BuffIDList[i]);
                    Info.Level = 1;
                    Info.RemainTime = UserData.BuffRemainList[i];
                    Info.IconName = TheSkillInfo.TexName;
                    Info.Name = TheSkillInfo.SkillName;
                    Info.Description = TheSkillInfo.SkillDesc;
                    Info.bShow = true;
                    Info.Size = 22;
                    m_hPlayerBuffWnd[a_TeamID].AddCol(CurRow, Info);
                }
                ++i;
                // [Loop Continue]
                goto J0x9C6;
            }
            m_hPlayerBuffWnd[a_TeamID].GetWindowSize(Width, Height);
            m_hPlayerBuffCoverWnd[a_TeamID].SetWindowSize(Width, Height);
        }        
    }
    return;
}

function SetSelectedUser(int a_TeamID, int a_UserID)
{
    local int i;

    switch(a_TeamID)
    {
        // End:0x67
        case 0:
            i = 0;
            J0x12:

            // End:0x64 [Loop If]
            if(i < 9)
            {
                // End:0x45
                if(i == a_UserID)
                {
                    m_hParty1MemberSelectedTex[i].ShowWindow();
                    // [Explicit Continue]
                    goto J0x5A;
                }
                m_hParty1MemberSelectedTex[i].HideWindow();
                J0x5A:

                ++i;
                // [Loop Continue]
                goto J0x12;
            }
            // End:0xCA
            break;
        // End:0xC7
        case 1:
            i = 0;
            J0x72:

            // End:0xC4 [Loop If]
            if(i < 9)
            {
                // End:0xA5
                if(i == a_UserID)
                {
                    m_hParty2MemberSelectedTex[i].ShowWindow();
                    // [Explicit Continue]
                    goto J0xBA;
                }
                m_hParty2MemberSelectedTex[i].HideWindow();
                J0xBA:

                ++i;
                // [Loop Continue]
                goto J0x72;
            }
            // End:0xCA
            break;
        // End:0xFFFF
        default:
            break;
    }
    m_SelectedUserID[a_TeamID] = a_UserID;
    // End:0x175
    if(-1 == a_UserID)
    {
        m_hPlayerNameTextBox[a_TeamID].SetText("");
        m_hPlayerLvClassTextBox[a_TeamID].SetText("");
        m_hPlayerHPBar[a_TeamID].SetValue(0, 0);
        m_hPlayerCPBar[a_TeamID].SetValue(0, 0);
        m_hPlayerMPBar[a_TeamID].SetValue(0, 0);
        m_hPlayerBuffCoverWnd[a_TeamID].HideWindow();        
    }
    else
    {
        Class'NWindow.EventMatchAPI'.static.SetSelectedUser(a_TeamID, a_UserID);
        m_hPlayerBuffCoverWnd[a_TeamID].ShowWindow();
        UpdateUserInfo(a_TeamID, a_UserID);
    }
    return;
}

function bool IsSelectedUser(int a_TeamID, int a_UserID)
{
    // End:0x1A
    if((0 != a_TeamID) && 1 != a_TeamID)
    {
        return false;
    }
    // End:0x31
    if(m_SelectedUserID[a_TeamID] != a_UserID)
    {
        return false;
    }
    return true;
    return;
}

function ClearMsg()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x47 [Loop If]
    if(i < 6)
    {
        m_hMsgLeftWnd[i].HideWindow();
        m_hMsgRightWnd[i].HideWindow();
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function bool GetTeamUserID(int a_UserClassID, out int a_TeamID, out int a_UserID)
{
    local int i;

    // End:0x0D
    if(0 == a_UserClassID)
    {
        return false;
    }
    i = 0;
    J0x14:

    // End:0x53 [Loop If]
    if(i < 9)
    {
        // End:0x49
        if(m_Party1UserIDList[i] == a_UserClassID)
        {
            a_TeamID = 0;
            a_UserID = i;
            return true;
        }
        ++i;
        // [Loop Continue]
        goto J0x14;
    }
    i = 0;
    J0x5A:

    // End:0x99 [Loop If]
    if(i < 9)
    {
        // End:0x8F
        if(m_Party2UserIDList[i] == a_UserClassID)
        {
            a_TeamID = 1;
            a_UserID = i;
            return true;
        }
        ++i;
        // [Loop Continue]
        goto J0x5A;
    }
    return;
}

function AddSkillMsg(int a_AttackerTeamID, int a_AttackerUserID, string a_AttackerName, int a_DefenderTeamID, int a_DefenderUserID, string a_DefenderName, string a_SkillName)
{
    m_MsgList[m_MsgStartIndex].AttackerTeamID = a_AttackerTeamID;
    m_MsgList[m_MsgStartIndex].AttackerUserID = a_AttackerUserID;
    m_MsgList[m_MsgStartIndex].AttackerName = a_AttackerName;
    m_MsgList[m_MsgStartIndex].DefenderTeamID = a_DefenderTeamID;
    m_MsgList[m_MsgStartIndex].DefenderUserID = a_DefenderUserID;
    m_MsgList[m_MsgStartIndex].DefenderName = a_DefenderName;
    m_MsgList[m_MsgStartIndex].SkillName = a_SkillName;
    m_MsgStartIndex = int(float(m_MsgStartIndex + 1) % float(6));
    // End:0x172
    if(0 == a_AttackerTeamID)
    {
        m_Team1MsgList[m_Team1MsgStartIndex].AttackerTeamID = a_AttackerTeamID;
        m_Team1MsgList[m_Team1MsgStartIndex].AttackerUserID = a_AttackerUserID;
        m_Team1MsgList[m_Team1MsgStartIndex].AttackerName = a_AttackerName;
        m_Team1MsgList[m_Team1MsgStartIndex].DefenderTeamID = a_DefenderTeamID;
        m_Team1MsgList[m_Team1MsgStartIndex].DefenderUserID = a_DefenderUserID;
        m_Team1MsgList[m_Team1MsgStartIndex].DefenderName = a_DefenderName;
        m_Team1MsgList[m_Team1MsgStartIndex].SkillName = a_SkillName;
        m_Team1MsgStartIndex = int(float(m_Team1MsgStartIndex + 1) % float(6));        
    }
    else
    {
        m_Team2MsgList[m_Team2MsgStartIndex].AttackerTeamID = a_AttackerTeamID;
        m_Team2MsgList[m_Team2MsgStartIndex].AttackerUserID = a_AttackerUserID;
        m_Team2MsgList[m_Team2MsgStartIndex].AttackerName = a_AttackerName;
        m_Team2MsgList[m_Team2MsgStartIndex].DefenderTeamID = a_DefenderTeamID;
        m_Team2MsgList[m_Team2MsgStartIndex].DefenderUserID = a_DefenderUserID;
        m_Team2MsgList[m_Team2MsgStartIndex].DefenderName = a_DefenderName;
        m_Team2MsgList[m_Team2MsgStartIndex].SkillName = a_SkillName;
        m_Team2MsgStartIndex = int(float(m_Team2MsgStartIndex + 1) % float(6));
    }
    UpdateSkillMsg();
    return;
}

function UpdateSkillMsg()
{
    local int i, SkillMsgIndex;
    local Color Team1Color, Team2Color;

    Team1Color.R = 220;
    Team1Color.G = 220;
    Team1Color.B = 220;
    Team2Color.R = byte(255);
    Team2Color.G = 55;
    Team2Color.B = 55;
    switch(m_MsgMode)
    {
        // End:0x25C
        case 0:
            i = 0;
            J0x63:

            // End:0x8E [Loop If]
            if(i < 6)
            {
                m_hMsgRightWnd[i].HideWindow();
                ++i;
                // [Loop Continue]
                goto J0x63;
            }
            i = 0;
            J0x95:

            // End:0x259 [Loop If]
            if(i < 6)
            {
                SkillMsgIndex = int(float(m_MsgStartIndex + i) % float(6));
                // End:0xEC
                if(m_MsgList[SkillMsgIndex].AttackerName == "")
                {
                    m_hMsgLeftWnd[i].HideWindow();
                    // [Explicit Continue]
                    goto J0x24F;
                }
                m_hMsgLeftAttackerTextBox[i].SetText(string(m_MsgList[SkillMsgIndex].AttackerUserID + 1) $ m_MsgList[SkillMsgIndex].AttackerName);
                m_hMsgLeftDefenderTextBox[i].SetText(string(m_MsgList[SkillMsgIndex].DefenderUserID + 1) $ m_MsgList[SkillMsgIndex].DefenderName);
                m_hMsgLeftSkillTextBox[i].SetText(m_MsgList[SkillMsgIndex].SkillName);
                // End:0x1BC
                if(0 == m_MsgList[SkillMsgIndex].AttackerTeamID)
                {
                    m_hMsgLeftAttackerTextBox[i].SetTextColor(Team1Color);                    
                }
                else
                {
                    m_hMsgLeftAttackerTextBox[i].SetTextColor(Team2Color);
                }
                // End:0x209
                if(0 == m_MsgList[SkillMsgIndex].DefenderTeamID)
                {
                    m_hMsgLeftDefenderTextBox[i].SetTextColor(Team1Color);                    
                }
                else
                {
                    m_hMsgLeftDefenderTextBox[i].SetTextColor(Team2Color);
                }
                m_hMsgLeftWnd[i].ShowWindow();
                m_hMsgLeftWnd[i].SetAlpha(255);
                J0x24F:

                ++i;
                // [Loop Continue]
                goto J0x95;
            }
            // End:0x59E
            break;
        // End:0x54C
        case 1:
            i = 0;
            J0x268:

            // End:0x3D5 [Loop If]
            if(i < 6)
            {
                SkillMsgIndex = int(float(m_Team1MsgStartIndex + i) % float(6));
                // End:0x2BF
                if(m_Team1MsgList[SkillMsgIndex].AttackerName == "")
                {
                    m_hMsgLeftWnd[i].HideWindow();
                    // [Explicit Continue]
                    goto J0x3CB;
                }
                m_hMsgLeftAttackerTextBox[i].SetText(string(m_Team1MsgList[SkillMsgIndex].AttackerUserID + 1));
                m_hMsgLeftDefenderTextBox[i].SetText(string(m_Team1MsgList[SkillMsgIndex].DefenderUserID + 1));
                m_hMsgLeftSkillTextBox[i].SetText(m_Team1MsgList[SkillMsgIndex].SkillName);
                m_hMsgLeftAttackerTextBox[i].SetTextColor(Team1Color);
                // End:0x385
                if(0 == m_Team1MsgList[SkillMsgIndex].DefenderTeamID)
                {
                    m_hMsgLeftDefenderTextBox[i].SetTextColor(Team1Color);                    
                }
                else
                {
                    m_hMsgLeftDefenderTextBox[i].SetTextColor(Team2Color);
                }
                m_hMsgLeftWnd[i].ShowWindow();
                m_hMsgLeftWnd[i].SetAlpha(255);
                J0x3CB:

                ++i;
                // [Loop Continue]
                goto J0x268;
            }
            i = 0;
            J0x3DC:

            // End:0x549 [Loop If]
            if(i < 6)
            {
                SkillMsgIndex = int(float(m_MsgStartIndex + i) % float(6));
                // End:0x433
                if(m_Team2MsgList[SkillMsgIndex].AttackerName == "")
                {
                    m_hMsgRightWnd[i].HideWindow();
                    // [Explicit Continue]
                    goto J0x53F;
                }
                m_hMsgRightAttackerTextBox[i].SetText(string(m_Team2MsgList[SkillMsgIndex].AttackerUserID + 1));
                m_hMsgRightDefenderTextBox[i].SetText(string(m_Team2MsgList[SkillMsgIndex].DefenderUserID + 1));
                m_hMsgRightSkillTextBox[i].SetText(m_Team2MsgList[SkillMsgIndex].SkillName);
                m_hMsgRightAttackerTextBox[i].SetTextColor(Team2Color);
                // End:0x4F9
                if(0 == m_Team2MsgList[SkillMsgIndex].DefenderTeamID)
                {
                    m_hMsgRightDefenderTextBox[i].SetTextColor(Team1Color);                    
                }
                else
                {
                    m_hMsgRightDefenderTextBox[i].SetTextColor(Team2Color);
                }
                m_hMsgRightWnd[i].ShowWindow();
                m_hMsgRightWnd[i].SetAlpha(255);
                J0x53F:

                ++i;
                // [Loop Continue]
                goto J0x3DC;
            }
            // End:0x59E
            break;
        // End:0x59B
        case 2:
            i = 0;
            J0x558:

            // End:0x598 [Loop If]
            if(i < 6)
            {
                m_hMsgLeftWnd[i].HideWindow();
                m_hMsgRightWnd[i].HideWindow();
                ++i;
                // [Loop Continue]
                goto J0x558;
            }
            // End:0x59E
            break;
        // End:0xFFFF
        default:
            break;
    }
    m_hOwnerWnd.KillTimer(2);
    m_hOwnerWnd.SetTimer(2, 14000);
    return;
}

defaultproperties
{
    m_WindowName="EventMatchObserverWnd"
}