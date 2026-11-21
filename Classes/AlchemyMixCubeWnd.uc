class AlchemyMixCubeWnd extends L2UIGFxScript;

const DIALOG_ALCHEMYMIXCUBEWND = 10000;

function OnRegisterEvent()
{
    RegisterGFxEvent(9870);
    RegisterGFxEvent(9875);
    RegisterGFxEvent(9910);
    RegisterGFxEvent(9920);
    RegisterGFxEvent(9880);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x18
        case 1710:
            HandleDialogOK();
            // End:0x2C
            break;
        // End:0x29
        case 1720:
            HandleDialogCancel();
            // End:0x2C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    local DialogBox dScript;

    switch(functionName)
    {
        // End:0x2C
        case "openDialogNumpad":
            openDialogNumpad((param));
            // End:0x8A
            break;
        // End:0x87
        case "cloasDialogNumPad":
            dScript = DialogBox(GetScript("DialogBox"));
            // End:0x84
            if(dScript.GetTarget() == string(self))
            {
                dScript.HideDialog();
            }
            // End:0x8A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function openDialogNumpad(INT64 Adena)
{
    Class'Interface.UICommonAPI'.static.DialogSetID(10000);
    Class'Interface.UICommonAPI'.static.DialogSetEditType("number");
    Class'Interface.UICommonAPI'.static.DialogSetParamInt64(Adena);
    Class'Interface.UICommonAPI'.static.DialogSetDefaultOK();
    Class'Interface.UICommonAPI'.static.DialogShow(1, 6, GetSystemMessage(4262), string(self));
    return;
}

function HandleDialogCancel()
{
    return;
}

function HandleDialogOK()
{
    local INT64 inputNum;
    local int Id;

    // End:0x19
    if(!Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
    {
        return;
    }
    Id = Class'Interface.UICommonAPI'.static.DialogGetID();
    // End:0x84
    if(Id == 10000)
    {
        inputNum = (Class'Interface.UICommonAPI'.static.DialogGetString());
        CallGFxFunction("AlchemyMixCubeWnd", "HandleDialogOK", (inputNum));
    }
    return;
}

function OnLoad()
{
    RegisterState("AlchemyMixCubeWnd", "GamingState");
    SetContainerWindow("SkinnedWindow", 3302);
    AddState("GAMINGSTATE");
    return;
}

function OnShow()
{
    local L2Util util;

    util = L2Util(GetScript("L2Util"));
    util.ItemRelationWindowHide("AlchemyMixCubeWnd", "InventoryWnd");
    return;
}
