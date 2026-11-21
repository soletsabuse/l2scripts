class AlterSkill extends L2UIGFxScript;

const FLASH_WIDTH = 800;
const FLASH_HEIGHT = 600;

var int currentScreenWidth;
var int currentScreenHeight;

function OnRegisterEvent()
{
    RegisterEvent(5130);
    RegisterGFxEvent(5130);
    RegisterGFxEvent(5131);
    RegisterGFxEvent(5132);
    RegisterGFxEvent(40);
    return;
}

function OnLoad()
{
    RegisterState("AlterSkill", "GamingState");
    SetContainerHUD("none", 0);
    AddState("GAMINGSTATE");
    SetDefaultShow(true);
    SetHavingFocus(false);
    SetAnchor("", 9, 1, 0, 0);
    return;
}

function OnShow()
{
    return;
}

function OnFlashLoaded()
{
    RegisterDelegateHandler(2);
    return;
}

function OnHide()
{
    return;
}

function OnCallUCLogic(int logicID, string param)
{
    // End:0x17
    if(logicID == 1)
    {
        SetNextFocus();
        HideWindow();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string mainKey;

    // End:0x56
    if(Event_ID == 5130)
    {
        ParseString(param, "mainKey", mainKey);
        CallGFxFunction("AlterSkill", "setShowShortKey", string(mainKey != ""));
    }
    return;
}

function bool bFlag(int nflag)
{
    // End:0x10
    if(nflag > 0)
    {
        return true;        
    }
    else
    {
        return false;
    }
    return;
}

function int getSkillIconType(int skill_id)
{
    local int returnV;

    returnV = 1;
    switch(skill_id)
    {
        // End:0x12
        case 0:
        // End:0x16
        case 1:
        // End:0x25
        case 2:
            returnV = 1;
            // End:0x42
            break;
        // End:0x2A
        case 3:
        // End:0x2F
        case 4:
        // End:0x3F
        case 5:
            returnV = 2;
            // End:0x42
            break;
        // End:0xFFFF
        default:
            break;
    }
    return returnV;
    return;
}
