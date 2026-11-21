class OlympiadControlWnd extends UIScript;

var WindowHandle Me;
var ButtonHandle btnRecord;
var ButtonHandle btnGuide;
var ButtonHandle btnOtherGame;
var ButtonHandle btnStop;
var WindowHandle OlympiadGuideWnd;

function OnLoad()
{
    Initialize();
    load();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("OlympiadControlWnd");
    btnRecord = GetButtonHandle("OlympiadControlWnd.btnRecord");
    btnGuide = GetButtonHandle("OlympiadControlWnd.btnGuide");
    btnOtherGame = GetButtonHandle("OlympiadControlWnd.btnOtherGame");
    btnStop = GetButtonHandle("OlympiadControlWnd.btnStop");
    OlympiadGuideWnd = GetWindowHandle("OlympiadGuideWnd");
    return;
}

function load()
{
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
    local OlympiadGuideWnd script;

    switch(strID)
    {
        // End:0x25
        case "btnStop":
            Class'NWindow.OlympiadAPI'.static.RequestOlympiadObserverEnd();
            // End:0xA4
            break;
        // End:0x48
        case "btnOtherGame":
            Class'NWindow.OlympiadAPI'.static.RequestOlympiadMatchList();
            // End:0xA4
            break;
        // End:0x5F
        case "btnRecord":
            ToggleReplayRec();
            // End:0xA4
            break;
        // End:0xA1
        case "btnGuide":
            script = OlympiadGuideWnd(GetScript("OlympiadGuideWnd"));
            script.OpenCloseGuide();
            // End:0xA4
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
