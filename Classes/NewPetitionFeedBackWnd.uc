class NewPetitionFeedBackWnd extends UICommonAPI;

const MAX_FEEDBACK_STRING_LENGTH = 512;
const FEEBACKRATE_VeryGood = 0;
const FEEBACKRATE_Good = 1;
const FEEBACKRATE_Normal = 2;
const FEEBACKRATE_Bad = 3;
const FEEBACKRATE_VeryBad = 4;

var WindowHandle Me;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    Me = GetWindowHandle("NewPetitionFeedBackWnd");
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function OnShow()
{
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function OnHide()
{
    ExecuteEvent(1940, "Enable=0");
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
    local string SelectedRadioButtonName;
    local int FeedbackRate;
    local string FeedbackMessage;
    local NewPetitionFeedBackWnd_2nd newPetitionFeedBackWnd_2ndScript;

    FeedbackMessage = "";
    newPetitionFeedBackWnd_2ndScript = NewPetitionFeedBackWnd_2nd(GetScript("NewPetitionFeedBackWnd_2nd"));
    SelectedRadioButtonName = Class'NWindow.UIAPI_WINDOW'.static.GetSelectedRadioButtonName("NewPetitionFeedBackWnd", 1);
    switch(SelectedRadioButtonName)
    {
        // End:0x81
        case "VeryGood":
            FeedbackRate = 0;
            // End:0xD7
            break;
        // End:0x94
        case "Good":
            FeedbackRate = 1;
            // End:0xD7
            break;
        // End:0xAA
        case "Normal":
            FeedbackRate = 2;
            // End:0xD7
            break;
        // End:0xBD
        case "Bad":
            FeedbackRate = 3;
            // End:0xD7
            break;
        // End:0xD4
        case "VeryBad":
            FeedbackRate = 4;
            // End:0xD7
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x143
    if(((FeedbackRate == 2) || FeedbackRate == 3) || FeedbackRate == 4)
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("NewPetitionFeedBackResultWnd");
        newPetitionFeedBackWnd_2ndScript.SetSelectedRadioButton(FeedbackRate);        
    }
    else
    {
        Class'NWindow.PetitionAPI'.static.RequestPetitionFeedBack(FeedbackRate, FeedbackMessage);
    }
    HideWindow("NewPetitionFeedBackWnd");
    return;
}

function OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
    // End:0x40
    if(int(Key) == int(27))
    {
        PlayConsoleSound(6);
        GetWindowHandle("NewPetitionFeedBackWnd").HideWindow();
    }
    return;
}
