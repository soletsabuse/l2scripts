class OlympiadPlayerWnd extends UICommonAPI;

const MAX_OLYMPIAD_USER_NUM = 3;
const MAX_OLYMPIAD_TEAM_NUM = 2;
const MAX_OLYMPIAD_SKILL_MSG = 5;
const MAX_OLYMPIAD_ALLSKILL_MSG = 15;
const CONTRACT_HEIGHT = 44;
const EXPAND_HEIGHT = 124;
const NSTATUSICON_FRAMESIZE = 12;
const NSTATUSICON_MAXCOL = 12;

struct OlympiadUserInfo
{
    var int m_TeamID;
    var int m_ID;
    var string m_name;
    var int m_ClassID;
    var int m_MaxHP;
    var int m_CurHP;
    var int m_MaxCP;
    var int m_CurCP;
    var int m_MsgWnd;
};

var WindowHandle Me;
var ButtonHandle btnExpand;
var ButtonHandle btnContract;
var WindowHandle m_StatusWnd[3];
var WindowHandle m_MsgWnd[3];
var NameCtrlHandle m_PlayerName[3];
var TextureHandle m_ClassIcon[3];
var BarHandle m_BarCP[3];
var BarHandle m_BarHP[3];
var TextBoxHandle m_TextBoxHandle[15];
var string m_Msg[15];
var StatusIconHandle StatusIcon[3];
var int m_PlayerNum;
var string m_WindowName;
var string m_BuffWindowName;
var bool m_Expand;
var int m_TotalCount;
var int m_MyTeamCount;
var int m_MsgStartLine[3];
var int m_MsgNextStartLine[3];
var int m_MyTeamNum;
var int m_IsPlayer;
var bool mFound;
var Color Red;
var Color Blue;
var OlympiadUserInfo UserInfo[3];

function SetPlayerNum(int PlayerNum)
{
    m_PlayerNum = PlayerNum;
    m_WindowName = ("OlympiadPlayer" $ string(m_PlayerNum)) $ "Wnd";
    m_BuffWindowName = ("OlympiadBuff" $ string(m_PlayerNum)) $ "Wnd";
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(920);
    RegisterEvent(910);
    RegisterEvent(290);
    RegisterEvent(280);
    RegisterEvent(930);
    RegisterEvent(940);
    return;
}

function OnLoad()
{
    local int i, j;

    mFound = true;
    Me = GetWindowHandle(m_WindowName);
    i = 0;
    J0x20:

    // End:0x23B [Loop If]
    if(i < 3)
    {
        m_StatusWnd[i] = GetWindowHandle((m_WindowName $ ".TargetWnd") $ string(i));
        m_MsgWnd[i] = GetWindowHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".SysMsgWnd");
        j = 0;
        J0x9D:

        // End:0x10E [Loop If]
        if(j < 5)
        {
            m_TextBoxHandle[(i * 5) + j] = GetTextBoxHandle(((((m_WindowName $ ".TargetWnd") $ string(i)) $ ".SysMsgWnd") $ ".txtMsg") $ string(j));
            j++;
            // [Loop Continue]
            goto J0x9D;
        }
        m_PlayerName[i] = GetNameCtrlHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".PlayerName");
        m_ClassIcon[i] = GetTextureHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".ClassIcon");
        m_BarCP[i] = GetBarHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".barCP");
        m_BarHP[i] = GetBarHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".barHP");
        StatusIcon[i] = GetStatusIconHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".BuffWnd");
        i++;
        // [Loop Continue]
        goto J0x20;
    }
    btnExpand = GetButtonHandle(m_WindowName $ ".btnExpand");
    btnContract = GetButtonHandle(m_WindowName $ ".btnContract");
    i = 0;
    J0x282:

    // End:0x2DE [Loop If]
    if(i < 3)
    {
        StatusIcon[i].SetAnchor((m_WindowName $ ".TargetWnd") $ string(i), "TopRight", "TopLeft", 1, 1);
        i++;
        // [Loop Continue]
        goto J0x282;
    }
    SetExpandMode(false);
    SetColor();
    return;
}

function SetColor()
{
    Red.R = 238;
    Red.G = 119;
    Red.B = 119;
    Red.A = byte(255);
    Blue.R = 102;
    Blue.G = 170;
    Blue.B = 238;
    Blue.A = byte(255);
    return;
}

function OnEnterState(name a_PreStateName)
{
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1D
    if(Event_ID == 920)
    {
        HandleUserInfo(param);        
    }
    else
    {
        // End:0x3A
        if(Event_ID == 290)
        {
            handleMagicSkillUse(param);            
        }
        else
        {
            // End:0x57
            if(Event_ID == 280)
            {
                HandleAttack(param);                
            }
            else
            {
                // End:0x69
                if(Event_ID == 930)
                {                    
                }
                else
                {
                    // End:0x86
                    if(Event_ID == 940)
                    {
                        HandleBuffInfo(param);                        
                    }
                    else
                    {
                        // End:0x9B
                        if(Event_ID == 910)
                        {
                            Clear();
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
    local int i;

    i = 0;
    J0x07:

    // End:0xD5 [Loop If]
    if(i < 3)
    {
        UserInfo[i].m_TeamID = 0;
        UserInfo[i].m_ID = 0;
        UserInfo[i].m_name = "";
        UserInfo[i].m_ClassID = 0;
        UserInfo[i].m_MaxHP = 0;
        UserInfo[i].m_CurHP = 0;
        UserInfo[i].m_MaxCP = 0;
        UserInfo[i].m_CurCP = 0;
        UserInfo[i].m_MsgWnd = 0;
        StatusIcon[i].super(OlympiadPlayerWnd).Clear();
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    i = 0;
    J0xDC:

    // End:0x100 [Loop If]
    if(i < 15)
    {
        m_Msg[i] = "";
        i++;
        // [Loop Continue]
        goto J0xDC;
    }
    i = 0;
    J0x107:

    // End:0x12A [Loop If]
    if(i < 3)
    {
        UpdateMsg(i, "");
        i++;
        // [Loop Continue]
        goto J0x107;
    }
    Me.HideWindow();
    return;
}

function Initialize()
{
    local int i;

    i = 0;
    J0x07:

    // End:0xEA [Loop If]
    if(i < 3)
    {
        UserInfo[i].m_TeamID = 0;
        UserInfo[i].m_ID = 0;
        UserInfo[i].m_name = "";
        UserInfo[i].m_ClassID = 0;
        UserInfo[i].m_MaxHP = 0;
        UserInfo[i].m_CurHP = 0;
        UserInfo[i].m_MaxCP = 0;
        UserInfo[i].m_CurCP = 0;
        UserInfo[i].m_MsgWnd = 0;
        StatusIcon[i].Clear();
        m_MsgStartLine[i] = 15 * i;
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    i = 0;
    J0xF1:

    // End:0x115 [Loop If]
    if(i < 15)
    {
        m_Msg[i] = "";
        i++;
        // [Loop Continue]
        goto J0xF1;
    }
    i = 0;
    J0x11C:

    // End:0x13F [Loop If]
    if(i < 3)
    {
        UpdateMsg(i, "");
        i++;
        // [Loop Continue]
        goto J0x11C;
    }
    return;
}

function OnShow()
{
    Initialize();
    return;
}

function HandleBuffInfo(string param)
{
    local int Id, i, j, Max, CurRow;

    local StatusIconInfo Info;
    local int numOfBuff;

    ParseInt(param, "PlayerID", Id);
    i = 0;
    J0x21:

    // End:0x64 [Loop If]
    if(i < m_MyTeamCount)
    {
        // End:0x5A
        if((Id < 1) || Id == UserInfo[i].m_ID)
        {
            // [Explicit Break]
            goto J0x64;
        }
        i++;
        // [Loop Continue]
        goto J0x21;
    }
    J0x64:

    // End:0x2E9
    if(i != m_MyTeamCount)
    {
        StatusIcon[i].Clear();
        CurRow = -1;
        ParseInt(param, "Max", Max);
        numOfBuff = 0;
        j = 0;
        J0xB6:

        // End:0x2DE [Loop If]
        if(j < Max)
        {
            ParseItemIDWithIndex(param, Info.Id, j);
            ParseInt(param, "SkillLevel_" $ string(j), Info.Level);
            ParseInt(param, "SkillSubLevel_" $ string(j), Info.SubLevel);
            // End:0x16B
            if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
            {
                // [Explicit Continue]
                goto J0x2D4;
            }
            // End:0x19C
            if((float(numOfBuff) % float(12)) == float(0))
            {
                StatusIcon[i].AddRow();
                CurRow++;
            }
            ParseInt(param, "RemainTime_" $ string(j), Info.RemainTime);
            ParseInt(param, "SpellerID_" $ string(j), Info.SpellerID);
            ParseString(param, "Name_" $ string(j), Info.Name);
            ParseString(param, "IconName_" $ string(j), Info.IconName);
            ParseString(param, "Description_" $ string(j), Info.Description);
            Info.Size = 16;
            Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
            Info.bShow = true;
            StatusIcon[i].AddCol(CurRow, Info);
            numOfBuff++;
            J0x2D4:

            j++;
            // [Loop Continue]
            goto J0xB6;
        }
        // End:0x2E9
        if(Max > 0)
        {
        }
    }
    return;
}

function HandleUserInfo(string param)
{
    local int i, TeamID, PlayerID, m_ClassID;
    local string m_name;
    local int m_MaxHP, m_CurHP, m_MaxCP, m_CurCP, m_MsgWnd, m_UserInfoIdx;

    ParseInt(param, "IsPlayer", m_IsPlayer);
    // End:0x27
    if(m_IsPlayer != 1)
    {
        return;
    }
    ParseInt(param, "TotalCount", m_TotalCount);
    m_MyTeamCount = m_TotalCount / 2;
    // End:0x2B3
    if((m_TotalCount == 2) || m_TotalCount == 6)
    {
        m_UserInfoIdx = 0;
        i = 0;
        J0x7A:

        // End:0x29E [Loop If]
        if(i < m_TotalCount)
        {
            ParseInt(param, "PlayerNum_" $ string(i), TeamID);
            // End:0xC0
            if(TeamID != m_PlayerNum)
            {
                // [Explicit Continue]
                goto J0x294;
            }
            ParseInt(param, "ID_" $ string(i), PlayerID);
            ParseString(param, "Name_" $ string(i), m_name);
            ParseInt(param, "ClassID_" $ string(i), m_ClassID);
            ParseInt(param, "MaxHP_" $ string(i), m_MaxHP);
            ParseInt(param, "CurHP_" $ string(i), m_CurHP);
            ParseInt(param, "MaxCP_" $ string(i), m_MaxCP);
            ParseInt(param, "CurCP_" $ string(i), m_CurCP);
            ParseInt(param, "SysMsg_" $ string(i), m_MsgWnd);
            UserInfo[m_UserInfoIdx].m_TeamID = TeamID;
            UserInfo[m_UserInfoIdx].m_ID = PlayerID;
            UserInfo[m_UserInfoIdx].m_name = m_name;
            UserInfo[m_UserInfoIdx].m_ClassID = m_ClassID;
            UserInfo[m_UserInfoIdx].m_MaxHP = m_MaxHP;
            UserInfo[m_UserInfoIdx].m_CurHP = m_CurHP;
            UserInfo[m_UserInfoIdx].m_MaxCP = m_MaxCP;
            UserInfo[m_UserInfoIdx].m_CurCP = m_CurCP;
            UserInfo[m_UserInfoIdx].m_MsgWnd = m_MsgWnd;
            m_UserInfoIdx++;
            J0x294:

            i++;
            // [Loop Continue]
            goto J0x7A;
        }
        Resize(m_TotalCount / 2);
        UpdateUsersInfo();
    }
    return;
}

function handleMagicSkillUse(string param)
{
    local int Id, SkillID, i;
    local string paramsend, strMsg;

    // End:0x16
    if(!Me.IsShowWindow())
    {
        return;
    }
    ParseInt(param, "AttackerID", Id);
    i = 0;
    J0x39:

    // End:0x7C [Loop If]
    if(i < m_MyTeamCount)
    {
        // End:0x72
        if((Id < 1) || Id == UserInfo[i].m_ID)
        {
            // [Explicit Break]
            goto J0x7C;
        }
        i++;
        // [Loop Continue]
        goto J0x39;
    }
    J0x7C:

    // End:0x127
    if(i != m_MyTeamCount)
    {
        ParseInt(param, "SkillID", SkillID);
        // End:0xB6
        if(!isSkill(SkillID))
        {
            return;
        }
        ParamAdd(paramsend, "Type", string(int(4)));
        ParamAdd(paramsend, "param1", string(SkillID));
        ParamAdd(paramsend, "param2", "1");
        AddSystemMessageParam(paramsend);
        strMsg = EndSystemMessageParam(46, true);
        UpdateMsg(i, strMsg);
    }
    return;
}

function bool isSkill(int SkillID)
{
    // End:0x21
    if((SkillID > 0) && SkillID < 1900)
    {
        return true;        
    }
    else
    {
        // End:0x43
        if((SkillID > 10000) && SkillID < 12000)
        {
            return true;
        }
    }
    return false;
    return;
}

function HandleAttack(string param)
{
    local int AttackerID;
    local string AttackerName;
    local int DefenderID, Critical, Miss, ShieldDefense, i;

    local string paramsend, strMsg;

    ParseInt(param, "AttackerID", AttackerID);
    ParseString(param, "AttackerName", AttackerName);
    ParseInt(param, "DefenderID", DefenderID);
    ParseInt(param, "Critical", Critical);
    ParseInt(param, "Miss", Miss);
    ParseInt(param, "ShieldDefense", ShieldDefense);
    i = 0;
    J0xAC:

    // End:0x1B9 [Loop If]
    if(i < m_MyTeamCount)
    {
        // End:0x103
        if((AttackerID > 0) && AttackerID == UserInfo[i].m_ID)
        {
            // End:0x100
            if(Critical > 0)
            {
                UpdateMsg(i, GetSystemMessage(44));
            }
            // [Explicit Continue]
            goto J0x1AF;
        }
        // End:0x1AF
        if((DefenderID > 0) && DefenderID == UserInfo[i].m_ID)
        {
            // End:0x191
            if(Miss > 0)
            {
                ParamAdd(paramsend, "Type", string(int(0)));
                ParamAdd(paramsend, "param1", AttackerName);
                AddSystemMessageParam(paramsend);
                strMsg = EndSystemMessageParam(42, true);
                UpdateMsg(i, strMsg);
                // [Explicit Continue]
                goto J0x1AF;
            }
            // End:0x1AF
            if(ShieldDefense > 0)
            {
                UpdateMsg(i, GetSystemMessage(111));
            }
        }
        J0x1AF:

        i++;
        // [Loop Continue]
        goto J0xAC;
    }
    return;
}

function UpdateMsg(int Userindex, string strMsg)
{
    local int i, CurPos, BoxPos;

    m_MsgStartLine[Userindex] = int(float(Userindex * 5) + (float(m_MsgNextStartLine[Userindex]) % float(5)));
    m_Msg[m_MsgStartLine[Userindex]] = strMsg;
    m_MsgNextStartLine[Userindex] = m_MsgStartLine[Userindex] + 1;
    i = 0;
    J0x66:

    // End:0xE8 [Loop If]
    if(i < 5)
    {
        CurPos = int(float(Userindex * 5) + (float(m_MsgStartLine[Userindex] + i) % float(5)));
        BoxPos = (((Userindex * 5) + 5) - 1) - i;
        m_TextBoxHandle[BoxPos].SetText(m_Msg[CurPos]);
        i++;
        // [Loop Continue]
        goto J0x66;
    }
    return;
}

function UpdateUsersInfo()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x2B [Loop If]
    if(i < m_MyTeamCount)
    {
        UpdateUserInfo(i);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    Me.ShowWindow();
    return;
}

function UpdateUserInfo(int Index)
{
    // End:0x3C
    if(m_PlayerNum == 1)
    {
        m_PlayerName[Index].SetNameWithColor(UserInfo[Index].m_name, 0, 2, Blue);        
    }
    else
    {
        m_PlayerName[Index].SetNameWithColor(UserInfo[Index].m_name, 0, 2, Red);
    }
    // End:0xB8
    if(UserInfo[Index].m_MaxCP > 0)
    {
        m_BarCP[Index].SetValue(UserInfo[Index].m_MaxCP, UserInfo[Index].m_CurCP);        
    }
    else
    {
        m_BarCP[Index].SetValue(0, 0);
    }
    // End:0x11D
    if(UserInfo[Index].m_MaxHP > 0)
    {
        m_BarHP[Index].SetValue(UserInfo[Index].m_MaxHP, UserInfo[Index].m_CurHP);        
    }
    else
    {
        m_BarHP[Index].SetValue(0, 0);
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1F
        case "btnExpand":
            SetExpandMode(false);
            // End:0x3C
            break;
        // End:0x39
        case "btnContract":
            SetExpandMode(true);
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function SetExpandMode(bool bExpand)
{
    local Rect rectWnd, rectBuffWnd;
    local int nWndWidth, nWndHeight;

    Me.GetWindowSize(nWndWidth, nWndHeight);
    // End:0x9B
    if(bExpand)
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".BackTex");
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".SysMsgWnd");
        btnExpand.ShowWindow();
        btnContract.HideWindow();
        Me.SetWindowSize(nWndWidth, 124);        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".SysMsgWnd");
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".BackTex");
        btnExpand.HideWindow();
        btnContract.ShowWindow();
        Me.SetWindowSize(nWndWidth, 44);
    }
    rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect(m_WindowName);
    rectBuffWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect(m_BuffWindowName);
    // End:0x1A6
    if(!bExpand)
    {
        // End:0x1A3
        if(((rectWnd.nY + 46) == rectBuffWnd.nY) || (rectWnd.nY + 47) == rectBuffWnd.nY)
        {
            Class'NWindow.UIAPI_WINDOW'.static.MoveEx(m_BuffWindowName, 0, 80);
        }        
    }
    else
    {
        // End:0x1FC
        if(((rectWnd.nY + 126) == rectBuffWnd.nY) || (rectWnd.nY + 127) == rectBuffWnd.nY)
        {
            Class'NWindow.UIAPI_WINDOW'.static.MoveEx(m_BuffWindowName, 0, -80);
        }
    }
    return;
}

function Resize(int Count)
{
    local Rect entireRect, statusWndRect, msgWndRect;

    entireRect = Me.GetRect();
    statusWndRect = m_StatusWnd[0].GetRect();
    msgWndRect = m_MsgWnd[0].GetRect();
    Me.SetWindowSize(entireRect.nWidth, ((statusWndRect.nHeight + msgWndRect.nHeight) - 8) * Count);
    Me.SetResizeFrameSize(10, ((statusWndRect.nHeight + msgWndRect.nHeight) - 8) * Count);
    // End:0x126
    if(m_TotalCount == 2)
    {
        m_StatusWnd[0].ShowWindow();
        m_StatusWnd[1].HideWindow();
        m_StatusWnd[2].HideWindow();
        m_MsgWnd[0].ShowWindow();
        m_MsgWnd[1].HideWindow();
        m_MsgWnd[2].HideWindow();        
    }
    else
    {
        // End:0x19A
        if(m_TotalCount == 6)
        {
            m_StatusWnd[0].ShowWindow();
            m_StatusWnd[1].ShowWindow();
            m_StatusWnd[2].ShowWindow();
            m_MsgWnd[0].ShowWindow();
            m_MsgWnd[1].ShowWindow();
            m_MsgWnd[2].ShowWindow();
        }
    }
    return;
}
