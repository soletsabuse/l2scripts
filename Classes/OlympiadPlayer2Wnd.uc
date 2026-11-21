class OlympiadPlayer2Wnd extends OlympiadPlayerWnd;

function OnLoad()
{
    SetPlayerNum(2);
    super.OnLoad();
    return;
}

function UpdateUsersInfo()
{
    // End:0x11
    if(m_IsPlayer == 1)
    {
        super.UpdateUsersInfo();
    }
    return;
}
