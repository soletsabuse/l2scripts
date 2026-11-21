class ArmyTrainingCenterWnd extends GFxUIScript;

const TIMER_ID_Sec = 10012;
const TIMER_ID_Min = 10013;
const TIMER_DELAY = 60000;

var int nRemainSecondTime;

function OnRegisterEvent()
{
    RegisterEvent(3410);
    RegisterEvent(10034);
    RegisterGFxEvent(10031);
    RegisterGFxEvent(180);
    return;
}

function OnLoad()
{
    RegisterState("ArmyTrainingCenterWnd", "TRAININGROOMSTATE");
    SetContainer("ContainerWindow");
    SetAnchor("", 5, 5, 0, 0);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x9C
    if(Event_ID == 3410)
    {
        // End:0x74
        if(param != "TRAININGROOMSTATE")
        {
            CallGFxFunction("ArmyTrainingCenterWnd", "StateOut", "");
            HideWindow();
            KillTimer(10012);
            KillTimer(10013);            
        }
        else
        {
            CallGFxFunction("ArmyTrainingCenterWnd", "StateIn", "");
        }
    }
    // End:0x119
    if(Event_ID == 10034)
    {
        ParseInt(param, "MaxTime", nRemainSecondTime);
        // End:0x119
        if(nRemainSecondTime > 0)
        {
            nRemainSecondTime = int(float(nRemainSecondTime) % float(60));
            // End:0x109
            if(nRemainSecondTime > 0)
            {
                SetTimer(10012, nRemainSecondTime * 1000);                
            }
            else
            {
                SetTimer(10013, 60000);
            }
        }
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x76
    if((TimerID == 10012) || TimerID == 10013)
    {
        CallGFxFunction("ArmyTrainingCenterWnd", "TimerUpdate", "");
        // End:0x76
        if(TimerID == 10012)
        {
            KillTimer(10012);
            SetTimer(10013, 60000);
        }
    }
    return;
}

function ClearTimer(int TimerID)
{
    // End:0x1D
    if(TimerID == 10012)
    {
        KillTimer(10012);        
    }
    else
    {
        // End:0x37
        if(TimerID == 10013)
        {
            KillTimer(10013);
        }
    }
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x0F
        case "":
            // End:0x12
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
