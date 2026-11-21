class AdenaDistributionWnd extends L2UIGFxScript;

const DIALOG_ADENADISTRIBUTTE = 200001;

var ItemWindowHandle InventoryItem;

function OnRegisterEvent()
{
    RegisterGFxEvent(180);
    RegisterGFxEvent(40);
    RegisterGFxEvent(9570);
    RegisterGFxEvent(9690);
    RegisterGFxEvent(9700);
    RegisterGFxEvent(9710);
    RegisterGFxEvent(4918);
    RegisterGFxEvent(1380);
    RegisterGFxEvent(4915);
    RegisterGFxEvent(4919);
    RegisterGFxEvent(1170);
    RegisterGFxEvent(1140);
    RegisterGFxEvent(1160);
    RegisterGFxEvent(1370);
    RegisterGFxEvent(1360);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function OnLoad()
{
    RegisterState("AdenaDistributionWnd", "GamingState");
    SetContainerWindow("SkinnedWindow", 0);
    InventoryItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
    return;
}

function OnShow()
{
    local L2Util util;

    util = L2Util(GetScript("L2Util"));
    util.ItemRelationWindowHide("AdenaDistributionWnd");
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
    local int Index;
    local ItemInfo Info;

    switch(functionName)
    {
        // End:0x2C
        case "openDialogNumpad":
            openDialogNumpad((param));
            // End:0x100
            break;
        // End:0xCD
        case "getAdenaServerID":
            Info.Id.ClassID = 57;
            Index = InventoryItem.FindItem(Info.Id);
            // End:0xCA
            if(InventoryItem.GetItem(Index, Info))
            {
                CallGFxFunction("AdenaDistributionWnd", "AdenaServerID", string(Info.Id.ServerID));
            }
            // End:0x100
            break;
        // End:0xFD
        case "RequestCommandChannelInfo":
            Class'NWindow.CommandChannelAPI'.static.RequestCommandChannelInfo();
            // End:0x100
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
    Class'Interface.UICommonAPI'.static.DialogShow(1, 6, GetSystemString(3138), string(self));
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
    // End:0x87
    if(Id == 200001)
    {
        inputNum = (Class'Interface.UICommonAPI'.static.DialogGetString());
        CallGFxFunction("AdenaDistributionWnd", "HandleDialogOK", (inputNum));
    }
    return;
}
