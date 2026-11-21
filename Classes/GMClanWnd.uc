class GMClanWnd extends ClanWnd;

var bool bShow;

function OnRegisterEvent()
{
    RegisterEvent(2380);
    RegisterEvent(2390);
    RegisterEvent(2400);
    return;
}

function load()
{
    bShow = false;
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanMemInfoBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanMemAuthBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanBoardBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanInfoBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanPenaltyBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanQuitBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarInfoBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarDeclareBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanWarCancleBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanAskJoinBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanAuthEditBtn");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("GMClanWnd.ClanTitleManageBtn");
    return;
}

function OnShow()
{
    return;
}

function OnHide()
{
    return;
}

function ShowClan(string a_Param)
{
    // End:0x0E
    if(a_Param == "")
    {
        return;
    }
    // End:0x37
    if(bShow)
    {
        Clear();
        m_hOwnerWnd.HideWindow();
        bShow = false;        
    }
    else
    {
        HandleGMObservingClan("");
        Class'NWindow.GMAPI'.static.RequestGMCommand(2, a_Param);
        bShow = true;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 2380:
            HandleGMObservingClan(a_Param);
            // End:0x47
            break;
        // End:0x2E
        case 2390:
            HandleGMObservingClanMemberStart();
            // End:0x47
            break;
        // End:0x44
        case 2400:
            HandleGMObservingClanMember(a_Param);
            // End:0x47
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleGMObservingClan(string a_Param)
{
    m_hOwnerWnd.ShowWindow();
    m_hOwnerWnd.SetFocus();
    Clear();
    HandleClanInfo(a_Param);
    return;
}

function HandleGMObservingClanMemberStart()
{
    return;
}

function HandleGMObservingClanMember(string a_Param)
{
    HandleAddClanMember(a_Param);
    return;
}

defaultproperties
{
    m_WindowName="GMClanWnd"
}