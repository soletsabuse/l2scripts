class PetitionFeedBackWnd extends UICommonAPI;

const MAX_FEEDBACK_STRING_LENGTH = 512;
const FEEBACKRATE_VeryGood = 0;
const FEEBACKRATE_Good = 1;
const FEEBACKRATE_Normal = 2;
const FEEBACKRATE_Bad = 3;
const FEEBACKRATE_VeryBad = 4;

function OnLoad()
{
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    return;
}

function OnHide()
{
    ExecuteEvent(1940, "Enable=0");
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

function OnClickOKButton()
{
    local string SelectedRadioButtonName;
    local int FeedbackRate;
    local string FeedbackMessage;

    SelectedRadioButtonName = Class'NWindow.UIAPI_WINDOW'.static.GetSelectedRadioButtonName("PetitionFeedBackWnd", 1);
    switch(SelectedRadioButtonName)
    {
        // End:0x49
        case "VeryGood":
            FeedbackRate = 0;
            // End:0x9F
            break;
        // End:0x5C
        case "Good":
            FeedbackRate = 1;
            // End:0x9F
            break;
        // End:0x72
        case "Normal":
            FeedbackRate = 2;
            // End:0x9F
            break;
        // End:0x85
        case "Bad":
            FeedbackRate = 3;
            // End:0x9F
            break;
        // End:0x9C
        case "VeryBad":
            FeedbackRate = 4;
            // End:0x9F
            break;
        // End:0xFFFF
        default:
            break;
    }
    FeedbackMessage = Class'NWindow.UIAPI_MULTIEDITBOX'.static.GetString("PetitionFeedBackWnd.MultiEdit");
    // End:0xEF
    if(Len(FeedbackMessage) > 512)
    {
        AddSystemMessageString(FeedbackMessage);
    }
    Class'NWindow.PetitionAPI'.static.RequestPetitionFeedBack(FeedbackRate, FeedbackMessage);
    HideWindow("PetitionFeedBackWnd");
    return;
}
