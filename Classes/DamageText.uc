class DamageText extends GFxUIScript;

const FLASH_WIDTH = 800;
const FLASH_HEIGHT = 600;

enum EDamageTextType
{
    NOMAKE,                         // 0
    NormalAttack,                   // 1
    ConsecutiveAttack,              // 2
    Critical,                       // 3
    OverHit,                        // 4
    RecoverHP,                      // 5
    RecoverMP,                      // 6
    GetSP,                          // 7
    GetExp,                         // 8
    MagicDefiance,                  // 9
    ShieldGuard,                    // 10
    Dodge,                          // 11
    Immune,                         // 12
    SkillHit,                       // 13
    etc                             // 14
};

var int currentScreenWidth;
var int currentScreenHeight;

function OnRegisterEvent()
{
    RegisterEvent(5370);
    RegisterEvent(5371);
    return;
}

function OnLoad()
{
    RegisterState("DamageText", "GamingState");
    SetAnchor("", 1, 1, 0, 0);
    return;
}

function OnShow()
{
    return;
}

function OnFlashLoaded()
{
    RegisterDelegateHandler(4);
    SetAlwaysFullAlpha(true);
    IgnoreUIEvent(true);
    return;
}

function OnHide()
{
    return;
}

function OnCallUCLogic(int logicID, string param)
{
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string clipName;
    local int UnitType, xLoc, yLoc, valueType, Value, bCritical,
	    bOverHit, bMagicDefense, bShieldDefense, bMiss, bContinuousAttack,
	    bImmune, bSkillHit;

    local array<GFxValue> args;
    local GFxValue invokeResult;
    local int nID;

    GetCurrentResolution(currentScreenWidth, currentScreenHeight);
    // End:0x1EF
    if(Event_ID == 5370)
    {
        ShowWindow();
        ParseInt(param, "clipName", nID);
        clipName = string(nID);
        ParseInt(param, "unitType", UnitType);
        ParseInt(param, "valueType", valueType);
        ParseInt(param, "value", Value);
        ParseInt(param, "bCritical", bCritical);
        ParseInt(param, "bOverHit", bOverHit);
        ParseInt(param, "bMagicDefense", bMagicDefense);
        ParseInt(param, "bShieldDefense", bShieldDefense);
        ParseInt(param, "bMiss", bMiss);
        ParseInt(param, "bContinuousAttack", bContinuousAttack);
        ParseInt(param, "bImmune", bImmune);
        ParseInt(param, "bSkillHit", bSkillHit);
        ParseInt(param, "x", xLoc);
        ParseInt(param, "y", yLoc);
        conditionalDamageText(clipName, UnitType, xLoc, yLoc, valueType, Value, bCritical, bOverHit, bMagicDefense, bShieldDefense, bMiss, bContinuousAttack, bImmune, bSkillHit);        
    }
    else
    {
        // End:0x310
        if(Event_ID == 5371)
        {
            ShowWindow();
            ParseInt(param, "clipName", nID);
            clipName = string(nID);
            ParseInt(param, "x", xLoc);
            ParseInt(param, "y", yLoc);
            AllocGFxValues(args, 2);
            AllocGFxValue(invokeResult);
            args[0].SetInt(2);
            CreateObject(args[1]);
            args[1].SetMemberString("clipName", clipName);
            args[1].SetMemberInt("x", xLoc);
            args[1].SetMemberInt("y", yLoc);
            Invoke("_root.onEvent", args, invokeResult);
            DeallocGFxValue(invokeResult);
            DeallocGFxValues(args);
        }
    }
    return;
}

function makeDamageText(string clipName, int UnitType, int textType, int xLoc, int yLoc, string messageStr)
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    // End:0x12F
    if(textType != -1)
    {
        AllocGFxValues(args, 2);
        AllocGFxValue(invokeResult);
        args[0].SetInt(1);
        CreateObject(args[1]);
        args[1].SetMemberString("clipName", clipName);
        args[1].SetMemberInt("unitType", UnitType);
        args[1].SetMemberInt("textType", textType);
        args[1].SetMemberInt("x", xLoc);
        args[1].SetMemberInt("y", yLoc);
        args[1].SetMemberString("messageStr", messageStr);
        Invoke("_root.onEvent", args, invokeResult);
        DeallocGFxValue(invokeResult);
        DeallocGFxValues(args);
    }
    return;
}

function conditionalDamageText(string clipName, int UnitType, int xLoc, int yLoc, int valueType, int Value, int bCritical, int bOverHit, int bMagicDefense, int bShieldDefense, int bMiss, int bContinuousAttack, int bImmune, int bSkillHit)
{
    local int damageTextType;

    damageTextType = -1;
    // End:0x6D
    if(valueType == 3)
    {
        // End:0x2F
        if(Value >= 0)
        {
            damageTextType = int(5);            
        }
        else
        {
            damageTextType = int(1);
        }
        // End:0x6A
        if(Value != 0)
        {
            makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
        }        
    }
    else
    {
        // End:0x86
        if(valueType == 4)
        {
            damageTextType = int(6);            
        }
        else
        {
            // End:0x9E
            if(valueType == 1)
            {
                damageTextType = int(7);                
            }
            else
            {
                // End:0xB4
                if(valueType == 2)
                {
                    damageTextType = int(8);
                }
            }
        }
    }
    // End:0xF3
    if((Value > 0) && valueType != 3)
    {
        makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
    }
    // End:0x12E
    if(bContinuousAttack == 1)
    {
        damageTextType = int(2);
        makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
    }
    // End:0x169
    if(bOverHit == 1)
    {
        damageTextType = int(4);
        makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
    }
    // End:0x1A4
    if(bCritical == 1)
    {
        damageTextType = int(3);
        makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
    }
    // End:0x1DF
    if(bMagicDefense == 1)
    {
        damageTextType = int(9);
        makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
    }
    // End:0x21A
    if(bShieldDefense == 1)
    {
        damageTextType = int(10);
        makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
    }
    // End:0x255
    if(bMiss == 1)
    {
        damageTextType = int(11);
        makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
    }
    // End:0x290
    if(bImmune == 1)
    {
        damageTextType = int(12);
        makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
    }
    // End:0x2CB
    if(bSkillHit != 0)
    {
        damageTextType = int(13);
        makeDamageText(clipName, UnitType, damageTextType, xLoc, yLoc, string(Value));
    }
    return;
}
