class MysteriousMansionRoomListWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9390);
    RegisterGFxEvent(9391);
    RegisterGFxEvent(9392);
    return;
}

function OnLoad()
{
    RegisterState(getCurrentWindowName(string(self)), "GAMINGSTATE");
    RegisterState(getCurrentWindowName(string(self)), "CuriousHouseObserverState");
    SetContainerWindow("SkinnedWindow", 2809);
    AddState("GAMINGSTATE");
    AddState("CuriousHouseObserverState");
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x38
        case "RequestObservingCuriousHouse":
            RequestObservingCuriousHouse(int(param));
            // End:0x50
            break;
        // End:0x4D
        case "refresh":
            RequestObservingListCuriousHouse();
            // End:0x50
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
