class UIPowerToolWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle event1Btn;
var ButtonHandle event2Btn;
var ButtonHandle event3Btn;
var ButtonHandle InitBtn;
var EditBoxHandle param1Edit;
var EditBoxHandle param2Edit;
var EditBoxHandle param3Edit;
var EditBoxHandle eventNum1Edit;
var EditBoxHandle eventNum2Edit;
var EditBoxHandle eventNum3Edit;

function OnRegisterEvent()
{
    return;
}

function OnShow()
{
    loadEditByINI(1);
    loadEditByINI(2);
    loadEditByINI(3);
    return;
}

function OnHide()
{
    setEditByINI(1);
    setEditByINI(2);
    setEditByINI(3);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("UIPowerToolWnd");
    InitBtn = GetButtonHandle("UIPowerToolWnd.InitBtn");
    event1Btn = GetButtonHandle("UIPowerToolWnd.event1Btn");
    event2Btn = GetButtonHandle("UIPowerToolWnd.event2Btn");
    event3Btn = GetButtonHandle("UIPowerToolWnd.event3Btn");
    param1Edit = GetEditBoxHandle("UIPowerToolWnd.param1Edit");
    param2Edit = GetEditBoxHandle("UIPowerToolWnd.param2Edit");
    param3Edit = GetEditBoxHandle("UIPowerToolWnd.param3Edit");
    eventNum1Edit = GetEditBoxHandle("UIPowerToolWnd.eventNum1Edit");
    eventNum2Edit = GetEditBoxHandle("UIPowerToolWnd.eventNum2Edit");
    eventNum3Edit = GetEditBoxHandle("UIPowerToolWnd.eventNum3Edit");
    Me.SetWindowTitle("UIPowerTools [ EventTool ]");
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1E
        case "event1Btn":
            event1BtnClick();
            // End:0x61
            break;
        // End:0x35
        case "event2Btn":
            event2BtnClick();
            // End:0x61
            break;
        // End:0x4C
        case "event3Btn":
            event3BtnClick();
            // End:0x61
            break;
        // End:0x5E
        case "InitBtn":
            InitBtnClick();
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function event1BtnClick()
{
    ExecuteEvent(int(eventNum1Edit.GetString()), param1Edit.GetString());
    setEditByINI(1);
    return;
}

function event2BtnClick()
{
    ExecuteEvent(int(eventNum2Edit.GetString()), param2Edit.GetString());
    setEditByINI(2);
    return;
}

function event3BtnClick()
{
    ExecuteEvent(int(eventNum3Edit.GetString()), param3Edit.GetString());
    setEditByINI(3);
    return;
}

function InitBtnClick()
{
    param1Edit.SetString("");
    param2Edit.SetString("");
    param3Edit.SetString("");
    eventNum1Edit.SetString("");
    eventNum2Edit.SetString("");
    eventNum3Edit.SetString("");
    return;
}

function loadEditByINI(int Index)
{
    local string stringValue;

    stringValue = "";
    GetINIString("EventPowerToolWnd", "event" $ string(Index), stringValue, "UIDEV.ini");
    GetEditBoxHandle(("UIPowerToolWnd.param" $ string(Index)) $ "Edit").SetString(stringValue);
    GetINIString("EventPowerToolWnd", "eventNum" $ string(Index), stringValue, "UIDEV.ini");
    GetEditBoxHandle(("UIPowerToolWnd.eventNum" $ string(Index)) $ "Edit").SetString(stringValue);
    return;
}

function setEditByINI(int Index)
{
    SetINIString("EventPowerToolWnd", "event" $ string(Index), GetEditBoxHandle(("UIPowerToolWnd.param" $ string(Index)) $ "Edit").GetString(), "UIDEV.ini");
    SetINIString("EventPowerToolWnd", "eventNum" $ string(Index), GetEditBoxHandle(("UIPowerToolWnd.eventNum" $ string(Index)) $ "Edit").GetString(), "UIDEV.ini");
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("UIPowerToolWnd").HideWindow();
    return;
}
