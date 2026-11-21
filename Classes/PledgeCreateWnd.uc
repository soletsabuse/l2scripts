class PledgeCreateWnd extends UICommonAPI;

var WindowHandle Me;
var EditBoxHandle PledgeNameInput_Edit;
var ButtonHandle PledgeCreateBtn_Button;

function OnRegisterEvent()
{
    RegisterEvent(10800);
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
    Me = GetWindowHandle("PledgeCreateWnd");
    PledgeNameInput_Edit = GetEditBoxHandle("PledgeCreateWnd.PledgeNameInput_Edit");
    PledgeCreateBtn_Button = GetButtonHandle("PledgeCreateWnd.PledgeCreateBtn_Button");
    GetTextBoxHandle("PledgeCreateWnd.CreateConditionTitle_text").SetText((((GetSystemString(3763) $ " : ") $ GetSystemString(2381)) $ "10 ") $ GetSystemString(3692));
    return;
}

function OnShow()
{
    PledgeNameInput_Edit.SetString("");
    PledgeNameInput_Edit.SetFocus();
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1E
    if(Event_ID == 10800)
    {
        Me.ShowWindow();
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x2B
        case "PledgeCreateBtn_Button":
            OnPledgeCreateBtn_ButtonClick();
            // End:0x57
            break;
        // End:0x54
        case "WndBTNHelp_Button":
            ExecuteEvent(1210, "147");
            // End:0x57
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnPledgeCreateBtn_ButtonClick()
{
    local string ClanName;

    ClanName = PledgeNameInput_Edit.GetString();
    // End:0x3B
    if(ClanName != "")
    {
        RequestCreatePledge(ClanName);
        Me.HideWindow();
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
