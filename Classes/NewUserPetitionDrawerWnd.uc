class NewUserPetitionDrawerWnd extends UICommonAPI;

var WindowHandle Me;
var NewUserPetitionWnd m_scriptNewUserPetitionWnd;

function OnLoad()
{
    Me = GetWindowHandle("NewUserPetitionDrawerWnd");
    m_scriptNewUserPetitionWnd = NewUserPetitionWnd(GetScript("NewUserPetitionWnd"));
    return;
}
