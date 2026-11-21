class ArenaMatchGroupWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(8200);
    RegisterGFxEvent(8210);
    RegisterGFxEvent(8220);
    RegisterGFxEvent(8230);
    RegisterGFxEvent(980);
    RegisterGFxEvent(5391);
    RegisterGFxEvent(5392);
    RegisterGFxEvent(40);
    return;
}

function OnLoad()
{
    AddState("ARENAGAMINGSTATE");
    SetDefaultShow(true);
    SetContainerWindow("SimpleDragWindow", 0);
    SetHavingFocus(false);
    return;
}

function OnFlashLoaded()
{
    SetAnchor("", 1, 1, 0, 356);
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x2C
        case "addFriend":
            Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(param);
            // End:0x2F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
