class NewPetitionFeedBackResultWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle m_hResultTextBoxHandle;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    Me = GetWindowHandle("NewPetitionFeedBackResultWnd");
    m_hResultTextBoxHandle = GetTextBoxHandle("NewPetitionFeedBackResultWnd.PetitionFeedBackResultText");
    Me.ShowWindow();
    Me.SetFocus();
    m_hResultTextBoxHandle.SetText(GetSystemMessage(3004));
    return;
}

function OnShow()
{
    Me.SetFocus();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    return;
}

function OnClickButton(string a_ControlID)
{
    switch(a_ControlID)
    {
        // End:0x1D
        case "OKButton":
            OnClickOKButton();
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function Clear()
{
    return;
}

function OnClickOKButton()
{
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("NewPetitionFeedBackWnd_2nd");
    HideWindow("NewPetitionFeedBackResultWnd");
    return;
}
