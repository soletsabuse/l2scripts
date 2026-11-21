class OlympiadTargetWnd extends UIScript;

const MAX_OLYMPIAD_USER_NUM = 3;

var WindowHandle Me;
var WindowHandle m_TargetWnd[3];
var BarHandle m_BarCP[3];
var BarHandle m_BarHP[3];
var NameCtrlHandle m_PlayerName[3];
var int m_PlayerNum;
var int m_ID[3];
var string m_name[3];
var int m_ClassID[3];
var int m_MaxHP[3];
var int m_CurHP[3];
var int m_MaxCP[3];
var int m_CurCP[3];
var int m_TotalCount;
var int m_MyTeamCount;
var string m_WindowName;

function OnRegisterEvent()
{
    RegisterEvent(900);
    RegisterEvent(920);
    RegisterEvent(910);
    return;
}

function OnLoad()
{
    local int i;

    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x12F
    if(1 == 0)
    {
        Me = GetHandle(m_WindowName);
        i = 0;
        J0x2C:

        // End:0x12C [Loop If]
        if(i < 3)
        {
            m_TargetWnd[i] = GetHandle((m_WindowName $ ".TargetWnd") $ string(i));
            m_BarCP[i] = BarHandle(GetHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".barcp"));
            m_BarHP[i] = BarHandle(GetHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".barhp"));
            m_PlayerName[i] = NameCtrlHandle(GetHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".PlayerName"));
            i++;
            // [Loop Continue]
            goto J0x2C;
        }        
    }
    else
    {
        Me = GetWindowHandle(m_WindowName);
        i = 0;
        J0x147:

        // End:0x238 [Loop If]
        if(i < 3)
        {
            m_TargetWnd[i] = GetWindowHandle((m_WindowName $ ".TargetWnd") $ string(i));
            m_BarCP[i] = GetBarHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".barcp");
            m_BarHP[i] = GetBarHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".barhp");
            m_PlayerName[i] = GetNameCtrlHandle(((m_WindowName $ ".TargetWnd") $ string(i)) $ ".PlayerName");
            i++;
            // [Loop Continue]
            goto J0x147;
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x33
    if(Event_ID == 900)
    {
        Clear();
        ParseInt(param, "PlayerNum", m_PlayerNum);        
    }
    else
    {
        // End:0x56
        if(Event_ID == 920)
        {
            HandleUserInfo(param);
            UpdateStatus();            
        }
        else
        {
            // End:0x71
            if(Event_ID == 910)
            {
                Clear();
                HideAllWindow();
            }
        }
    }
    return;
}

function OnEnterState(name a_PreStateName)
{
    Clear();
    return;
}

function Clear()
{
    local int i;

    m_PlayerNum = 0;
    i = 0;
    J0x0E:

    // End:0x80 [Loop If]
    if(i < 3)
    {
        m_ID[i] = 0;
        m_name[i] = "";
        m_ClassID[i] = 0;
        m_MaxHP[i] = 0;
        m_CurHP[i] = 0;
        m_MaxCP[i] = 0;
        m_CurCP[i] = 0;
        i++;
        // [Loop Continue]
        goto J0x0E;
    }
    UpdateStatus();
    HideAllWindow();
    return;
}

function HandleUserInfo(string param)
{
    local int IsPlayer, PlayerNum, i, m_UserInfoIdx, MyTeamNum;

    ParseInt(param, "IsPlayer", IsPlayer);
    // End:0x27
    if(IsPlayer != 0)
    {
        return;
    }
    ParseInt(param, "TotalCount", m_TotalCount);
    m_MyTeamCount = m_TotalCount / 2;
    ParseInt(param, "MyTeamNum", MyTeamNum);
    m_UserInfoIdx = 0;
    i = 0;
    J0x7B:

    // End:0x1E1 [Loop If]
    if(i < m_TotalCount)
    {
        ParseInt(param, "PlayerNum_" $ string(i), PlayerNum);
        // End:0xC1
        if(PlayerNum == MyTeamNum)
        {
            // [Explicit Continue]
            goto J0x1D7;
        }
        ParseInt(param, "ID_" $ string(i), m_ID[m_UserInfoIdx]);
        ParseString(param, "Name_" $ string(i), m_name[m_UserInfoIdx]);
        ParseInt(param, "ClassID_" $ string(i), m_ClassID[m_UserInfoIdx]);
        ParseInt(param, "MaxHP_" $ string(i), m_MaxHP[m_UserInfoIdx]);
        ParseInt(param, "CurHP_" $ string(i), m_CurHP[m_UserInfoIdx]);
        ParseInt(param, "MaxCP_" $ string(i), m_MaxCP[m_UserInfoIdx]);
        ParseInt(param, "CurCP_" $ string(i), m_CurCP[m_UserInfoIdx]);
        m_UserInfoIdx++;
        J0x1D7:

        i++;
        // [Loop Continue]
        goto J0x7B;
    }
    ShowWindowCtrl(m_MyTeamCount);
    return;
}

function UpdateStatus()
{
    local int i;

    i = 0;
    J0x07:

    // End:0xF0 [Loop If]
    if(i < m_MyTeamCount)
    {
        m_PlayerName[i].SetName(m_name[i], 0, 2);
        // End:0x79
        if(m_MaxCP[i] > 0)
        {
            m_BarCP[i].SetValue(m_MaxCP[i], m_CurCP[i]);            
        }
        else
        {
            m_BarCP[i].SetValue(0, 0);
        }
        // End:0xCF
        if(m_MaxHP[i] > 0)
        {
            m_BarHP[i].SetValue(m_MaxHP[i], m_CurHP[i]);
            // [Explicit Continue]
            goto J0xE6;
        }
        m_BarHP[i].SetValue(0, 0);
        J0xE6:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function ShowWindowCtrl(int Count)
{
    local int i;
    local Rect entireRect;

    entireRect = Me.GetRect();
    Me.ShowWindow();
    // End:0x102
    if(Count == 1)
    {
        m_TargetWnd[0].ShowWindow();
        m_BarCP[0].ShowWindow();
        m_BarHP[0].ShowWindow();
        m_PlayerName[0].ShowWindow();
        i = 1;
        J0x7A:

        // End:0xE4 [Loop If]
        if(i < 3)
        {
            m_TargetWnd[i].HideWindow();
            m_BarCP[i].HideWindow();
            m_BarHP[i].HideWindow();
            m_PlayerName[i].HideWindow();
            i++;
            // [Loop Continue]
            goto J0x7A;
        }
        Me.SetWindowSize(entireRect.nWidth, 44);        
    }
    else
    {
        i = 0;
        J0x109:

        // End:0x176 [Loop If]
        if(i < Count)
        {
            m_TargetWnd[i].ShowWindow();
            m_BarCP[i].ShowWindow();
            m_BarHP[i].ShowWindow();
            m_PlayerName[i].ShowWindow();
            i++;
            // [Loop Continue]
            goto J0x109;
        }
    }
    // End:0x19D
    if(Count == 3)
    {
        Me.SetWindowSize(entireRect.nWidth, 160);
    }
    return;
}

function HideAllWindow()
{
    local int i;

    Me.HideWindow();
    i = 0;
    J0x16:

    // End:0x80 [Loop If]
    if(i < 3)
    {
        m_TargetWnd[i].HideWindow();
        m_BarCP[i].HideWindow();
        m_BarHP[i].HideWindow();
        m_PlayerName[i].HideWindow();
        i++;
        // [Loop Continue]
        goto J0x16;
    }
    return;
}

defaultproperties
{
    m_WindowName="OlympiadTargetWnd"
}