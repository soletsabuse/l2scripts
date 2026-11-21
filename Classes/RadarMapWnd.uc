class RadarMapWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(40);
    RegisterGFxEvent(110);
    RegisterGFxEvent(2420);
    RegisterGFxEvent(1780);
    RegisterGFxEvent(150);
    RegisterGFxEvent(160);
    RegisterGFxEvent(6130);
    RegisterGFxEvent(990);
    RegisterGFxEvent(1140);
    RegisterGFxEvent(1160);
    RegisterGFxEvent(1170);
    RegisterGFxEvent(1170);
    RegisterGFxEvent(1150);
    RegisterGFxEvent(6120);
    RegisterGFxEvent(1840);
    RegisterGFxEvent(40);
    RegisterGFxEvent(8600);
    RegisterGFxEvent(8610);
    return;
}

function OnLoad()
{
    RegisterState("RadarMapWnd", "GamingState");
    SetContainerHUD("none", 0);
    AddState("GAMINGSTATE");
    AddState("ARENABATTLESTATE");
    AddState("ARENAGAMINGSTATE");
    AddState("ARENAOBSERVERSTATE");
    SetDefaultShow(true);
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x87
        case "TeleportBookmarkBtn":
            // End:0x6D
            if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TeleportBookMarkWnd"))
            {
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TeleportBookMarkWnd");                
            }
            else
            {
                DoAction(Class'Interface.UICommonAPI'.static.GetItemID(64));
            }
            // End:0xA8
            break;
        // End:0xA5
        case "onClickArrowIcon":
            onClickArrowIcon();
            // End:0xA8
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function onClickArrowIcon()
{
    local MinimapWnd script;
    local string minimapWndName;

    script = MinimapWnd(GetScript("MinimapWnd"));
    minimapWndName = "MinimapWnd";
    // End:0x5C
    if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(minimapWndName))
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(minimapWndName);
    }
    script.OnClickTargetButton();
    return;
}
