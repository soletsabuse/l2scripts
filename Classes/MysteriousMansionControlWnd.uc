class MysteriousMansionControlWnd extends UIScript;

var WindowHandle Me;
var ButtonHandle btnRecord;
var ButtonHandle btnGuide;
var ButtonHandle btnOtherGame;
var ButtonHandle btnStop;
var WindowHandle OlympiadGuideWnd;

function OnLoad()
{
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("MysteriousMansionControlWnd");
    btnRecord = GetButtonHandle("MysteriousMansionControlWnd.btnRecord");
    btnGuide = GetButtonHandle("MysteriousMansionControlWnd.btnGuide");
    btnOtherGame = GetButtonHandle("MysteriousMansionControlWnd.btnOtherGame");
    btnStop = GetButtonHandle("MysteriousMansionControlWnd.btnStop");
    OlympiadGuideWnd = GetWindowHandle("OlympiadGuideWnd");
    return;
}

function OnShow()
{
    local OlympiadGuideWnd script;

    script = OlympiadGuideWnd(GetScript("OlympiadGuideWnd"));
    script.MysteriousMansionShow();
    return;
}

function OnHide()
{
    local OlympiadGuideWnd script;

    script = OlympiadGuideWnd(GetScript("OlympiadGuideWnd"));
    script.MysteriousMansionHide();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(5020);
    RegisterEvent(5021);
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x26
        case 5020:
            btnRecord.SetButtonName(2301);
            // End:0x48
            break;
        // End:0x45
        case 5021:
            btnRecord.SetButtonName(2300);
            // End:0x48
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1C
        case "btnStop":
            RequestLeaveObservingCuriousHouse();
            // End:0x66
            break;
        // End:0x36
        case "btnOtherGame":
            RequestObservingListCuriousHouse();
            // End:0x66
            break;
        // End:0x4D
        case "btnRecord":
            ToggleReplayRec();
            // End:0x66
            break;
        // End:0x63
        case "btnGuide":
            showGuidWnd();
            // End:0x66
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function showGuidWnd()
{
    local OlympiadGuideWnd script;

    script = OlympiadGuideWnd(GetScript("OlympiadGuideWnd"));
    script.OpenCloseGuide();
    return;
}
