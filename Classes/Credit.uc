class Credit extends L2UIGFxScript;

const FLASH_WIDTH = 800;
const FLASH_HEIGHT = 600;

var int currentScreenWidth;
var int currentScreenHeight;

function OnRegisterEvent()
{
    RegisterGFxEventForLoaded(2900);
    RegisterGFxEvent(5710);
    return;
}

function OnLoad()
{
    RegisterState("Credit", "CreditState");
    SetDefaultShow(true);
    return;
}

function OnFlashLoaded()
{
    SetAnchor("", 1, 1, 0, 0);
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    return;
}

function OnCallUCLogic(int logicID, string param)
{
    // End:0x21
    if(logicID == 1)
    {
        // End:0x21
        if(param == "exit")
        {
            EndCredit();
        }
    }
    return;
}
