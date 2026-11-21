class InviteClanPopWnd extends UICommonAPI;

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
    Me = GetWindowHandle("InviteClanPopWnd");
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
        // End:0x30
        case 160:
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");
            // End:0x36
            break;
        // End:0xFFFF
        default:
            // End:0x36
            break;
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    // End:0x73
    if(strID == "InviteClandPopOkBtn")
    {
        // End:0x34
        if(ShowType == 2)
        {
            AskJoinByPersonalConnectionsWnd();            
        }
        else
        {
            // End:0x49
            if(ShowType == 3)
            {
                AskJoinByPersonalConnectionsWndByUserName();                
            }
            else
            {
                askJoin();
            }
        }
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");        
    }
    else
    {
        // End:0xB7
        if(strID == "InviteClandPopCancelBtn")
        {
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("InviteClanPopWnd");
        }
    }
    return;
}

function askJoin()
{
    local UserInfo User;
    local int Index, knighthoodID;

    // End:0xC5
    if(GetTargetInfo(User))
    {
        // End:0xC5
        if(User.nID > 0)
        {
            Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd");
            // End:0xC5
            if(Index >= 0)
            {
                knighthoodID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", Index);
                RequestClanAskJoin(User.nID, knighthoodID);
            }
        }
    }
    return;
}

function AskJoinByPersonalConnectionsWnd()
{
    local int Index, knighthoodID;

    // End:0xAD
    if(friendServerID > 0)
    {
        Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd");
        // End:0xAD
        if(Index >= 0)
        {
            knighthoodID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", Index);
            RequestClanAskJoin(friendServerID, knighthoodID);
        }
    }
    return;
}

function AskJoinByPersonalConnectionsWndByUserName()
{
    local int Index, knighthoodID;

    Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd");
    // End:0xA2
    if(Index >= 0)
    {
        knighthoodID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", Index);
        RequestClanAskJoinByName(TargetUserName, knighthoodID);
    }
    return;
}

function InitializeComboBox()
{
    local int i;
    local ClanWnd script;
    local int addedCount;
    local string countnum, countnum2;
    local int cnt1, cnt2;
    local string m_sName;

    Class'NWindow.UIAPI_COMBOBOX'.static.Clear("InviteClanPopWnd.ComboboxInviteClandPopWnd");
    script = ClanWnd(GetScript("ClanWnd"));
    countnum2 = "" $ string(script.m_myClanType);
    cnt1 = Len(countnum2);
    i = 0;
    J0x83:

    // End:0x1B3 [Loop If]
    if(i < 8)
    {
        countnum = "" $ string(m_knighthoodIndex[i]);
        m_sName = script.m_memberList[i].m_sName;
        cnt2 = Len(countnum);
        // End:0x1A9
        if(m_sName != "")
        {
            // End:0x148
            if(m_knighthoodIndex[i] == -1)
            {
                Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", m_sName, m_knighthoodIndex[i]);
                ++addedCount;
                // [Explicit Continue]
                goto J0x1A9;
            }
            // End:0x1A9
            if(cnt1 <= cnt2)
            {
                Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("InviteClanPopWnd.ComboboxInviteClandPopWnd", m_sName, m_knighthoodIndex[i]);
                ++addedCount;
            }
        }
        J0x1A9:

        ++i;
        // [Loop Continue]
        goto J0x83;
    }
    // End:0x1FA
    if(addedCount > 0)
    {
        Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("InviteClanPopWnd.ComboboxInviteClandPopWnd", 0);
    }
    return;
}
