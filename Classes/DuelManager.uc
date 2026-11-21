class DuelManager extends UICommonAPI;

const DIALOG_ASK_START = 1111;
const MAX_PARTY_NUM = 9;
const NDUELSTATUS_HEIGHT = 46;

var int m_memberInfo[9];
var WindowHandle m_TopWnd;
var WindowHandle m_StatusWnd[9];
var NameCtrlHandle m_PlayerName[9];
var TextureHandle m_ClassIcon[9];
var BarHandle m_BarCP[9];
var BarHandle m_BarHP[9];
var BarHandle m_BarMP[9];
var bool m_bDuelState;

function OnRegisterEvent()
{
    RegisterEvent(2700);
    RegisterEvent(2710);
    RegisterEvent(2720);
    RegisterEvent(2730);
    RegisterEvent(2740);
    RegisterEvent(2750);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(920);
    RegisterEvent(910);
    return;
}

function OnLoad()
{
    local int idx;

    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x1EB
    if(1 == 0)
    {
        m_TopWnd = GetHandle("DuelManager");
        idx = 0;
        J0x34:

        // End:0x1E8 [Loop If]
        if(idx < 9)
        {
            m_StatusWnd[idx] = GetHandle("DuelManager.PartyStatusWnd" $ string(idx));
            m_PlayerName[idx] = NameCtrlHandle(GetHandle(("DuelManager.PartyStatusWnd" $ string(idx)) $ ".PlayerName"));
            m_ClassIcon[idx] = TextureHandle(GetHandle(("DuelManager.PartyStatusWnd" $ string(idx)) $ ".ClassIcon"));
            m_BarCP[idx] = BarHandle(GetHandle(("DuelManager.PartyStatusWnd" $ string(idx)) $ ".barCP"));
            m_BarHP[idx] = BarHandle(GetHandle(("DuelManager.PartyStatusWnd" $ string(idx)) $ ".barHP"));
            m_BarMP[idx] = BarHandle(GetHandle(("DuelManager.PartyStatusWnd" $ string(idx)) $ ".barMP"));
            idx++;
            // [Loop Continue]
            goto J0x34;
        }        
    }
    else
    {
        m_TopWnd = GetWindowHandle("DuelManager");
        idx = 0;
        J0x20B:

        // End:0x3A6 [Loop If]
        if(idx < 9)
        {
            m_StatusWnd[idx] = GetWindowHandle("DuelManager.PartyStatusWnd" $ string(idx));
            m_PlayerName[idx] = GetNameCtrlHandle(("DuelManager.PartyStatusWnd" $ string(idx)) $ ".PlayerName");
            m_ClassIcon[idx] = GetTextureHandle(("DuelManager.PartyStatusWnd" $ string(idx)) $ ".ClassIcon");
            m_BarCP[idx] = GetBarHandle(("DuelManager.PartyStatusWnd" $ string(idx)) $ ".barCP");
            m_BarHP[idx] = GetBarHandle(("DuelManager.PartyStatusWnd" $ string(idx)) $ ".barHP");
            m_BarMP[idx] = GetBarHandle(("DuelManager.PartyStatusWnd" $ string(idx)) $ ".barMP");
            idx++;
            // [Loop Continue]
            goto J0x20B;
        }
    }
    Clear();
    m_bDuelState = false;
    return;
}

function OnEvent(int EventID, string param)
{
    local Color White;

    White.R = byte(255);
    White.G = byte(255);
    White.B = byte(255);
    switch(EventID)
    {
        // End:0x4A
        case 2700:
            HandleDuelAskStart(param);
            // End:0x100
            break;
        // End:0x5D
        case 2710:
            m_bDuelState = true;
            // End:0x100
            break;
        // End:0x68
        case 2720:
            // End:0x100
            break;
        // End:0x90
        case 2730:
            m_bDuelState = false;
            Clear();
            m_TopWnd.HideWindow();
            // End:0x100
            break;
        // End:0xA6
        case 2740:
            HandleUpdateUserInfo(param);
            // End:0x100
            break;
        // End:0xB1
        case 2750:
            // End:0x100
            break;
        // End:0xC2
        case 1710:
            HandleDialogOK();
            // End:0x100
            break;
        // End:0xD3
        case 1720:
            HandleDialogCancel();
            // End:0x100
            break;
        // End:0xE9
        case 920:
            HandleOlympiadUserInfo(param);
            // End:0x100
            break;
        // End:0xFA
        case 910:
            HandleOlympiadEnd();
            // End:0x100
            break;
        // End:0xFFFF
        default:
            // End:0x100
            break;
            break;
    }
    return;
}

function HandleDuelAskStart(string param)
{
    local string sName;
    local int Type, messageNum;
    local bool bOption;

    bOption = GetOptionBool("Communication", "IsRejectingDuel");
    ParseString(param, "userName", sName);
    ParseInt(param, "type", Type);
    // End:0x84
    if(bOption == true)
    {
        RequestDuelAnswerStart(Type, int(bOption), -1);        
    }
    else
    {
        // End:0xAE
        if(IsShowWindow("DialogBox"))
        {
            RequestDuelAnswerStart(Type, int(bOption), 0);
            return;
        }
        // End:0xC7
        if(Type == 0)
        {
            messageNum = 1938;            
        }
        else
        {
            // End:0xDD
            if(Type == 1)
            {
                messageNum = 1939;
            }
        }
        DialogSetReservedInt(Type);
        DialogSetParamInt64((10 * 1000));
        DialogSetID(1111);
        DialogSetCancelD(1111);
        DialogShow(1, 7, MakeFullSystemMsg(GetSystemMessage(messageNum), sName), string(self));
    }
    return;
}

function HandleOlympiadUserInfo(string param)
{
    local int i, playNum, IsPlayer, PlayerID, m_ClassID;

    local string m_name;
    local int m_MaxHP, m_CurHP, m_MaxCP, m_CurCP;
    local string FakeEventParam;

    ParseInt(param, "TotalCount", playNum);
    // End:0x270
    if(playNum > 0)
    {
        i = 0;
        J0x2E:

        // End:0x270 [Loop If]
        if(i < playNum)
        {
            ParseInt(param, "PlayerNum_" $ string(i), IsPlayer);
            ParseInt(param, "ID_" $ string(i), PlayerID);
            ParseString(param, "Name_" $ string(i), m_name);
            ParseInt(param, "ClassID_" $ string(i), m_ClassID);
            ParseInt(param, "MaxHP_" $ string(i), m_MaxHP);
            ParseInt(param, "CurHP_" $ string(i), m_CurHP);
            ParseInt(param, "MaxCP_" $ string(i), m_MaxCP);
            ParseInt(param, "CurCP_" $ string(i), m_CurCP);
            // End:0x266
            if(IsPlayer == 0)
            {
                FakeEventParam = "";
                ParamAdd(FakeEventParam, "userName", "m_Name");
                ParamAdd(FakeEventParam, "ID", string(PlayerID));
                ParamAdd(FakeEventParam, "class", string(m_ClassID));
                ParamAdd(FakeEventParam, "level", string(75));
                ParamAdd(FakeEventParam, "currentHP", string(m_CurHP));
                ParamAdd(FakeEventParam, "maxHP", string(m_MaxHP));
                ParamAdd(FakeEventParam, "currentMP", string(0));
                ParamAdd(FakeEventParam, "maxMP", string(0));
                ParamAdd(FakeEventParam, "currentCP", string(m_CurCP));
                ParamAdd(FakeEventParam, "maxCP", string(m_MaxCP));
                ExecuteEvent(2740, FakeEventParam);
            }
            i++;
            // [Loop Continue]
            goto J0x2E;
        }
    }
    return;
}

function HandleOlympiadEnd()
{
    ExecuteEvent(2730);
    return;
}

function HandleDialogOK()
{
    local int dialogID;
    local bool bOption;

    // End:0x66
    if(DialogIsMine())
    {
        dialogID = DialogGetID();
        // End:0x66
        if(dialogID == 1111)
        {
            bOption = GetOptionBool("Communication", "IsRejectingDuel");
            RequestDuelAnswerStart(DialogGetReservedInt(), int(bOption), 1);
        }
    }
    return;
}

function HandleDialogCancel()
{
    local bool bOption;

    // End:0x59
    if(DialogIsMine())
    {
        // End:0x59
        if(DialogCheckCancelByID(1111))
        {
            bOption = GetOptionBool("Communication", "IsRejectingDuel");
            RequestDuelAnswerStart(DialogGetReservedInt(), int(bOption), 0);
        }
    }
    return;
}

function HandleUpdateUserInfo(string param)
{
    local string sName;
    local int Id, ClassID, Level, currentHP, MaxHP, currentMP,
	    maxMP, currentCP, maxCP, i;

    local bool bFound;

    // End:0x0D
    if(!m_bDuelState)
    {
        return;
    }
    ParseString(param, "userName", sName);
    ParseInt(param, "ID", Id);
    ParseInt(param, "class", ClassID);
    ParseInt(param, "level", Level);
    ParseInt(param, "currentHP", currentHP);
    ParseInt(param, "maxHP", MaxHP);
    ParseInt(param, "currentMP", currentMP);
    ParseInt(param, "maxMP", maxMP);
    ParseInt(param, "currentCP", currentCP);
    ParseInt(param, "maxCP", maxCP);
    bFound = false;
    i = 0;
    J0x10E:

    // End:0x15B [Loop If]
    if(i < 9)
    {
        // End:0x14E
        if(m_memberInfo[i] != 0)
        {
            // End:0x14B
            if(Id == m_memberInfo[i])
            {
                bFound = true;
                // [Explicit Break]
                goto J0x15B;
            }
            // [Explicit Continue]
            goto J0x151;
        }
        // [Explicit Break]
        goto J0x15B;
        J0x151:

        ++i;
        // [Loop Continue]
        goto J0x10E;
    }
    J0x15B:

    // End:0x19A
    if(!bFound)
    {
        m_memberInfo[i] = Id;
        m_StatusWnd[i].ShowWindow();
        Resize(i + 1);
    }
    m_TopWnd.ShowWindow();
    m_PlayerName[i].SetName(sName, 0, 2);
    m_ClassIcon[i].SetTexture(GetClassRoleIconName(ClassID));
    m_ClassIcon[i].SetTooltipCustomType(MakeTooltipSimpleText((GetClassRoleName(ClassID) $ " - ") $ GetClassType(ClassID)));
    m_BarCP[i].SetValue(maxCP, currentCP);
    m_BarHP[i].SetValue(MaxHP, currentHP);
    m_BarMP[i].SetValue(maxMP, currentMP);
    return;
}

function Clear()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x3F [Loop If]
    if(i < 9)
    {
        m_StatusWnd[i].HideWindow();
        m_memberInfo[i] = 0;
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function Resize(int Count)
{
    local Rect entireRect, statusWndRect;

    entireRect = m_TopWnd.GetRect();
    statusWndRect = m_StatusWnd[0].GetRect();
    m_TopWnd.SetWindowSize(entireRect.nWidth, statusWndRect.nHeight * Count);
    m_TopWnd.SetResizeFrameSize(10, statusWndRect.nHeight * Count);
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local Rect rectWnd;
    local int idx;

    rectWnd = m_TopWnd.GetRect();
    // End:0x59
    if(X > (rectWnd.nX + 13))
    {
        idx = (Y - rectWnd.nY) / 46;
        RequestTargetUser(m_memberInfo[idx]);
    }
    return;
}
