class ArmyTrainingCenterBottomWnd extends GFxUIScript;

const DIALOG_ASK_TRAINING_OUT = 66666;

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(3410);
    return;
}

function OnLoad()
{
    RegisterState("ArmyTrainingCenterBottomWnd", "TRAININGROOMSTATE");
    SetContainer("ContainerWindow");
    SetDefaultShow(true);
    SetAnchor("", 9, 1, 0, 0);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x18
    if(Event_ID == 1710)
    {
        HandleDialogOK();        
    }
    else
    {
        // End:0x2A
        if(Event_ID == 1720)
        {            
        }
        else
        {
            // End:0x65
            if(Event_ID == 3410)
            {
                // End:0x5F
                if(param == "TRAININGROOMSTATE")
                {
                    ShowWindow();                    
                }
                else
                {
                    HideWindow();
                }
            }
        }
    }
    return;
}

function HandleDialogOK()
{
    local int Id;
    local DialogBox script;
    local ArmyTrainingCenterWnd armyScript;

    script = DialogBox(GetScript("DialogBox"));
    armyScript = ArmyTrainingCenterWnd(GetScript("ArmyTrainingCenterWnd"));
    Id = script.GetID();
    // End:0xDD
    if(script.GetTarget() == string(self))
    {
        // End:0xDD
        if(Id == 66666)
        {
            CallGFxFunction("ArmyTrainingCenterBottomWnd", "TrainingRoomOut", "");
            armyScript.ClearTimer(10012);
            armyScript.ClearTimer(10013);
        }
    }
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    switch(functionName)
    {
        // End:0x75
        case "ShowDialogTrainingOut":
            script.setId(66666);
            script.ShowDialog(0, 0, GetSystemString(5155), string(self));
            // End:0xB1
            break;
        // End:0x90
        case "GameQuit":
            ExecuteEvent(3340);
            // End:0xB1
            break;
        // End:0xAE
        case "GameRestart":
            ExecuteEvent(3350);
            // End:0xB1
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
