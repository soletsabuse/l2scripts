class ItemUpgrade extends L2UIGFxScriptNoneContainer;

function OnRegisterEvent()
{
    RegisterEvent(40);
    RegisterEvent(18);
    RegisterGFxEvent(10190);
    RegisterGFxEvent(10191);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    RegisterState("ItemUpgrade", "GamingState");
    SetAnchor("", 5, 5, 0, 0);
    return;
}

function OnShow()
{
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("CardDrawEventWnd");
    super.OnShow();
    L2Util(GetScript("L2Util")).ItemRelationWindowHide(getCurrentWindowName(string(self)));
    return;
}

function OnFlashLoaded()
{
    RegisterDelegateHandler(31);
    RegisterDelegateHandler(3);
    RegisterDelegateHandler(0);
    RegisterDelegateHandler(32);
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    local string strParam;

    switch(functionName)
    {
        // End:0x61
        case "OpenHelpHTML":
            ParamAdd(strParam, "FilePath", "..\\L2text\\help_item_upgrade.htm");
            ExecuteEvent(1210, strParam);
            // End:0x64
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
