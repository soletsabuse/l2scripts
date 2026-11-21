class OlympiadBuffWnd extends UICommonAPI;

const NSTATUSICON_FRAMESIZE = 12;
const NSTATUSICON_MAXCOL = 12;

var int m_PlayerNum;
var int m_PlayerID;
var string m_WindowName;

function SetPlayerNum(int PlayerNum)
{
    m_PlayerNum = PlayerNum;
    m_WindowName = ("OlympiadBuff" $ string(PlayerNum)) $ "Wnd";
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(930);
    RegisterEvent(940);
    RegisterEvent(910);
    return;
}

function OnLoad()
{
    return;
}

function OnEnterState(name a_PreStateName)
{
    Clear();
    m_PlayerID = 0;
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1D
    if(Event_ID == 930)
    {
        HandleBuffShow(param);        
    }
    else
    {
        // End:0x3A
        if(Event_ID == 940)
        {
            HandleBuffInfo(param);            
        }
        else
        {
            // End:0x56
            if(Event_ID == 910)
            {
                Clear();
                m_PlayerID = 0;
            }
        }
    }
    return;
}

function Clear()
{
    Class'NWindow.UIAPI_STATUSICONCTRL'.static.Clear(m_WindowName $ ".StatusIcon");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName);
    return;
}

function HandleBuffShow(string param)
{
    local int PlayerNum;

    ParseInt(param, "PlayerNum", PlayerNum);
    // End:0x39
    if((m_PlayerNum != PlayerNum) || PlayerNum < 1)
    {
        return;
    }
    ParseInt(param, "PlayerID", m_PlayerID);
    return;
}

function HandleBuffInfo(string param)
{
    local int PlayerID, i, Max, CurRow;
    local StatusIconInfo Info;
    local Rect rectWnd;
    local int numOfBuff;

    ParseInt(param, "PlayerID", PlayerID);
    // End:0x38
    if((m_PlayerID != PlayerID) || PlayerID < 1)
    {
        return;
    }
    Clear();
    CurRow = -1;
    ParseInt(param, "Max", Max);
    i = 0;
    J0x65:

    // End:0x2A9 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "SkillLevel_" $ string(i), Info.Level);
        ParseInt(param, "SkillSubLevel_" $ string(i), Info.SubLevel);
        // End:0x11A
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            // [Explicit Continue]
            goto J0x29F;
        }
        // End:0x159
        if((float(numOfBuff) % float(12)) == float(0))
        {
            Class'NWindow.UIAPI_STATUSICONCTRL'.static.AddRow(m_WindowName $ ".StatusIcon");
            CurRow++;
        }
        ParseInt(param, "RemainTime_" $ string(i), Info.RemainTime);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        ParseString(param, "Name_" $ string(i), Info.Name);
        ParseString(param, "IconName_" $ string(i), Info.IconName);
        ParseString(param, "Description_" $ string(i), Info.Description);
        Info.Size = 24;
        Info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
        Info.bShow = true;
        Class'NWindow.UIAPI_STATUSICONCTRL'.static.AddCol(m_WindowName $ ".StatusIcon", CurRow, Info);
        numOfBuff++;
        J0x29F:

        i++;
        // [Loop Continue]
        goto J0x65;
    }
    // End:0x33D
    if(Max > 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName);
        rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect(m_WindowName $ ".StatusIcon");
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize(m_WindowName, rectWnd.nWidth + 12, rectWnd.nHeight);
        Class'NWindow.UIAPI_WINDOW'.static.SetFrameSize(m_WindowName, 12, rectWnd.nHeight);
    }
    return;
}
