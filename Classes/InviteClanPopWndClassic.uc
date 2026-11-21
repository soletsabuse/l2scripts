class InviteClanPopWndClassic extends UICommonAPI;

const SHOW_TYPE_ClanWnd = 1;
const SHOW_TYPE_PersonalConnectionsWnd = 2;
const SHOW_TYPE_PersonalConnectionsWndByUserName = 3;

var string m_userName;
var array<int> m_knighthoodIndex;
var int ShowType;
var WindowHandle Me;
var int friendServerID;
var int friendClanType;
var string TargetUserName;

function OnRegisterEvent()
{
    RegisterEvent(160);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    Me = GetWindowHandle("InviteClanPopWndClassic");
    m_knighthoodIndex.Length = 8;
    m_knighthoodIndex[0] = 0;
    m_knighthoodIndex[1] = 100;
    m_knighthoodIndex[2] = 200;
    m_knighthoodIndex[3] = 1001;
    m_knighthoodIndex[4] = 1002;
    m_knighthoodIndex[5] = 2001;
    m_knighthoodIndex[6] = 2002;
    m_knighthoodIndex[7] = -1;
    return;
}

function OnShow()
{
    return;
}

function showByClanWnd()
{
    Me.ShowWindow();
    ShowType = 1;
    InitializeComboBox();
    return;
}

function showByPersonalConnectionsWnd(int ServerID)
{
    Me.ShowWindow();
    ShowType = 2;
    friendServerID = ServerID;
    InitializeComboBox();
    return;
}

function showByPersonalConnectionsWndUsingUserName(string Username)
{
    Me.ShowWindow();
    ShowType = 3;
    TargetUserName = Username;
    InitializeComboBox();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x37
        case 160:
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InviteClanPopWndClassic");
            // End:0x3D
            break;
        // End:0xFFFF
        default:
            // End:0x3D
            break;
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    // End:0x93
    if(strID == "InviteClandPopOkBtn")
    {
        Debug("showType" @ string(ShowType));
        // End:0x4D
        if(ShowType == 2)
        {
            AskJoinByPersonalConnectionsWnd();            
        }
        else
        {
            // End:0x62
            if(ShowType == 3)
            {
                AskJoinByPersonalConnectionsWndByUserName();                
            }
            else
            {
                askJoin();
            }
        }
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InviteClanPopWndClassic");        
    }
    else
    {
        // End:0xDE
        if(strID == "InviteClandPopCancelBtn")
        {
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InviteClanPopWndClassic");
        }
    }
    return;
}

function askJoin()
{
    local UserInfo User;
    local int Index, knighthoodID;

    // End:0xD3
    if(GetTargetInfo(User))
    {
        // End:0xD3
        if(User.nID > 0)
        {
            Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWndClassic.ComboboxInviteClandPopWnd");
            // End:0xD3
            if(Index >= 0)
            {
                knighthoodID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWndClassic.ComboboxInviteClandPopWnd", Index);
                RequestClanAskJoin(User.nID, knighthoodID);
            }
        }
    }
    return;
}

function AskJoinByPersonalConnectionsWnd()
{
    local int Index, knighthoodID;

    // End:0xD8
    if(friendServerID > 0)
    {
        Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWndClassic.ComboboxInviteClandPopWnd");
        // End:0xD8
        if(Index >= 0)
        {
            knighthoodID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWndClassic.ComboboxInviteClandPopWnd", Index);
            Debug("knighthoodID" @ string(knighthoodID));
            RequestClanAskJoin(friendServerID, knighthoodID);
        }
    }
    return;
}

function AskJoinByPersonalConnectionsWndByUserName()
{
    local int Index, knighthoodID;

    Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWndClassic.ComboboxInviteClandPopWnd");
    // End:0xB0
    if(Index >= 0)
    {
        knighthoodID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWndClassic.ComboboxInviteClandPopWnd", Index);
        RequestClanAskJoinByName(TargetUserName, knighthoodID);
    }
    return;
}

function InitializeComboBox()
{
    local int i;
    local ClanWndClassic scriptClassic;
    local int addedCount;
    local string countnum, countnum2;
    local int cnt1, cnt2;
    local string m_sName;

    Class'NWindow.UIAPI_COMBOBOX'.static.Clear("InviteClanPopWndClassic.ComboboxInviteClandPopWnd");
    scriptClassic = ClanWndClassic(GetScript("ClanWndClassic"));
    countnum2 = "" $ string(scriptClassic.m_myClanType);
    cnt1 = Len(countnum2);
    i = 0;
    J0x91:

    // End:0x1CF [Loop If]
    if(i < 8)
    {
        countnum = "" $ string(m_knighthoodIndex[i]);
        m_sName = scriptClassic.m_memberList[i].m_sName;
        cnt2 = Len(countnum);
        // End:0x1C5
        if(m_sName != "")
        {
            // End:0x15D
            if(m_knighthoodIndex[i] == -1)
            {
                Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("InviteClanPopWndClassic.ComboboxInviteClandPopWnd", m_sName, m_knighthoodIndex[i]);
                ++addedCount;
                // [Explicit Continue]
                goto J0x1C5;
            }
            // End:0x1C5
            if(cnt1 <= cnt2)
            {
                Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("InviteClanPopWndClassic.ComboboxInviteClandPopWnd", m_sName, m_knighthoodIndex[i]);
                ++addedCount;
            }
        }
        J0x1C5:

        ++i;
        // [Loop Continue]
        goto J0x91;
    }
    // End:0x21D
    if(addedCount > 0)
    {
        Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("InviteClanPopWndClassic.ComboboxInviteClandPopWnd", 0);
    }
    return;
}
