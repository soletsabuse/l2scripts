class MysteriousMansionMenuWnd extends UICommonAPI;

const DIALOG_LEAVE_MYSTERIOUSMANSION = 99001;

var bool bChecked2;
var bool bChecked3;
var bool bChecked4;
var bool bChecked5;

function OnLoad()
{
    Initialize();
    load();
    return;
}

function Initialize()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    return;
}

function load()
{
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(9320);
    RegisterEvent(9330);
    RegisterEvent(40);
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x18
        case 9320:
            handleCuriousHouseEnter();
            // End:0x48
            break;
        // End:0x29
        case 9330:
            handleCuriousHouseLeave();
            // End:0x48
            break;
        // End:0x3A
        case 1710:
            HandleDialogOK();
            // End:0x48
            break;
        // End:0x45
        case 1720:
            // End:0x48
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function handleCuriousHouseEnter()
{
    setShow("MysteriousMansionMenuWnd");
    setHide("RadarMapWnd");
    setHide("Menu");
    bChecked2 = GetOptionBool("ScreenInfo", "GroupName");
    bChecked3 = GetOptionBool("ScreenInfo", "PledgeMemberName");
    bChecked4 = GetOptionBool("ScreenInfo", "PartyMemberName");
    bChecked5 = GetOptionBool("ScreenInfo", "OtherPCName");
    SetOptionBool("ScreenInfo", "GroupName", true);
    SetOptionBool("ScreenInfo", "PledgeMemberName", true);
    SetOptionBool("ScreenInfo", "PartyMemberName", true);
    SetOptionBool("ScreenInfo", "OtherPCName", true);
    return;
}

function handleCuriousHouseLeave()
{
    setHide("MysteriousMansionMenuWnd");
    setShow("RadarMapWnd");
    setShow("Menu");
    SetOptionBool("ScreenInfo", "GroupName", bChecked2);
    SetOptionBool("ScreenInfo", "PledgeMemberName", bChecked3);
    SetOptionBool("ScreenInfo", "PartyMemberName", bChecked4);
    SetOptionBool("ScreenInfo", "OtherPCName", bChecked5);
    return;
}

function setShow(string WindowName)
{
    // End:0x2D
    if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(WindowName))
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(WindowName);
    }
    return;
}

function setHide(string WindowName)
{
    // End:0x2B
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(WindowName))
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(WindowName);
    }
    return;
}

function HandleDialogOK()
{
    // End:0x1F
    if(DialogIsMine())
    {
        // End:0x1F
        if((DialogGetID()) == 99001)
        {
            RequestLeaveCuriousHouse();
        }
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x39
        case "btnQuit":
            DialogSetID(99001);
            DialogShow(1, 0, GetSystemMessage(3756), string(self));
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
