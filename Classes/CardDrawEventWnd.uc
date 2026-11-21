class CardDrawEventWnd extends L2UIGFxScriptNoneContainer;

var string gameTryCount;
var InventoryWnd inventoryWndScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(10240);
    RegisterGFxEvent(10250);
    RegisterGFxEvent(10260);
    RegisterGFxEvent(10270);
    RegisterGFxEvent(10280);
    return;
}

function OnCallUCFunction(string Id, string param)
{
    switch(Id)
    {
        // End:0x39
        case "getItemCount":
            gameTryCount = (inventoryWndScript.getItemCountByClassID(int(param)));
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnShow()
{
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ItemUpgrade");
    super.OnShow();
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    AddState("GAMINGSTATE");
    inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
    return;
}

function OnFlashLoaded()
{
    RegisterDelegateHandler(34);
    RegisterDelegateHandler(32);
    return;
}
