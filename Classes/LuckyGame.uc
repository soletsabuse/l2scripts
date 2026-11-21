class LuckyGame extends GFxUIScript;

const DIALOG_LUCKYGAME = 200001;
const DIALOG_RESULTFAIL = 200002;

function OnRegisterEvent()
{
    RegisterGFxEvent(10022);
    RegisterGFxEvent(10023);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterGFxEvent(20143);
    RegisterGFxEvent(20144);
    RegisterGFxEvent(20145);
    RegisterGFxEvent(9050);
    return;
}

function OnLoad()
{
    RegisterState("LuckyGame", "GamingState");
    SetContainer("ContainerWindow");
    SetAnchor("", 5, 5, 0, 0);
    SetHavingFocus(false);
    return;
}

function OnFlashLoaded()
{
    return;
}

function OnShow()
{
    local L2Util util;

    util = L2Util(GetScript("L2Util"));
    util.ItemRelationWindowHide("LuckyGame");
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x18
        case 1710:
            HandleDialogOK();
            // End:0x26
            break;
        // End:0x23
        case 1720:
            // End:0x26
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function closeDialogNumpad()
{
    local DialogBox dScript;

    dScript = DialogBox(GetScript("DialogBox"));
    // End:0x42
    if(dScript.GetTarget() == string(self))
    {
        dScript.HideDialog();
    }
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x26
        case "closeDialogNumpad":
            closeDialogNumpad();
            // End:0x96
            break;
        // End:0x4B
        case "openDialogNumpad":
            openDialogNumpad((param));
            // End:0x96
            break;
        // End:0x93
        case "showDialogMessage":
            Class'Interface.UICommonAPI'.static.DialogSetID(200002);
            Class'Interface.UICommonAPI'.static.DialogShow(1, 1, param, string(self));
            // End:0x96
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function openDialogNumpad(INT64 Adena)
{
    Class'Interface.UICommonAPI'.static.DialogSetID(200001);
    Class'Interface.UICommonAPI'.static.DialogSetEditType("number");
    Class'Interface.UICommonAPI'.static.DialogSetParamInt64(Adena);
    Class'Interface.UICommonAPI'.static.DialogSetDefaultOK();
    Class'Interface.UICommonAPI'.static.DialogShow(1, 6, GetSystemString(5174), string(self));
    return;
}

function HandleDialogOK()
{
    local INT64 inputNum;
    local int Id;
    local string strParam;

    // End:0x19
    if(!Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
    {
        return;
    }
    Id = Class'Interface.UICommonAPI'.static.DialogGetID();
    switch(Id)
    {
        // End:0xBC
        case 200001:
            inputNum = (Class'Interface.UICommonAPI'.static.DialogGetString());
            ParamAdd(strParam, "Type", "DIALOG_LUCKYGAME");
            ParamAdd(strParam, "inputNum", (inputNum));
            CallGFxFunction("LuckyGame", "HandleDialogOK", strParam);
            // End:0x114
            break;
        // End:0x111
        case 200002:
            ParamAdd(strParam, "Type", "DIALOG_RESULTFAIL");
            CallGFxFunction("LuckyGame", "HandleDialogOK", strParam);
            // End:0x114
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
