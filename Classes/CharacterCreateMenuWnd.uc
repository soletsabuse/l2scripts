class CharacterCreateMenuWnd extends L2UIGFxScript;

const DLG_ID_CREATE = 3300;
const MAX_RACE = 7;
const MAX_GENDER = 2;
const MAX_CHARACTER = 24;

var L2Util util;
var LoginSystemMessageWnd systemMessage;
var string RACE_STR[7];
var bool m_bZoomed;
var int Race;
var int Job;
var int gender;
var int HairType;
var int HairColor;
var int FaceType;
var string Name;
var bool IsCreate;
var int Id;

function int getFaceTypeMaxNum()
{
    return 3;
    return;
}

function int getHairColorMaxNum()
{
    // End:0x36
    if((RACE_STR[Race] == "KAMAEL") || RACE_STR[Race] == "ERTHEIA")
    {
        return 3;
    }
    return 4;
    return;
}

function int getHairTypeMaxNum()
{
    // End:0x29
    if((gender == 1) || RACE_STR[Race] == "ERTHEIA")
    {
        return 7;
    }
    return 5;
    return;
}

function setRandomTypes(int Id)
{
    HairType = Rand(getHairTypeMaxNum());
    HairColor = Rand(getHairColorMaxNum());
    FaceType = Rand(getFaceTypeMaxNum());
    SetCharacterStyle(Id, HairType, HairColor, FaceType);
    return;
}

function InitString()
{
    RACE_STR[0] = "HUMAN";
    RACE_STR[1] = "ELF";
    RACE_STR[2] = "DARKELF";
    RACE_STR[3] = "ORC";
    RACE_STR[4] = "DWARF";
    RACE_STR[5] = "KAMAEL";
    RACE_STR[6] = "ERTHEIA";
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(3210);
    RegisterEvent(5618);
    RegisterEvent(3410);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function OnLoad()
{
    SetContainerHUD("none", 0);
    AddState("CHARACTERCREATESTATE");
    SetAlwaysOnTop(true);
    HasTextField(true);
    InitString();
    SetAnchor("", 9, 1, 0, 0);
    util = L2Util(GetScript("L2Util"));
    systemMessage = LoginSystemMessageWnd(GetScript("LoginSystemMessageWnd"));
    return;
}

function OnHide()
{
    UnsetRotateCursor();
    CallGFxFunction("CharacterCreateMenuWnd", "EXIT", "0");
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x8F
    if(Event_ID == 3410)
    {
        // End:0x65
        if(param == "CHARACTERCREATESTATE")
        {
            Race = -1;
            CallGFxFunction("CharacterCreateMenuWnd", "ENTER", "0");            
        }
        else
        {
            CallGFxFunction("CharacterCreateMenuWnd", "EXIT", "0");
        }        
    }
    else
    {
        // End:0xCD
        if(Event_ID == 5618)
        {
            // End:0xCA
            if(GetGameStateName() == "CHARACTERCREATESTATE")
            {
                HandlecharacterNameCreatable(param);
            }            
        }
        else
        {
            // End:0xE6
            if(Event_ID == 1710)
            {
                HandleDialogResult(true);                
            }
            else
            {
                // End:0xFC
                if(Event_ID == 1720)
                {
                    HandleDialogResult(false);
                }
            }
        }
    }
    return;
}

function OnCallUCFunction(string logicID, string param)
{
    local string btnName, TargetName;

    ParseString(param, "btnName", btnName);
    switch(btnName)
    {
        // End:0x32
        case "exit":
            RequestPrevState();
            // End:0x25A
            break;
        // End:0x65
        case "confirm":
            IsCreate = false;
            ParseString(param, "Name", Name);
            handleNameConfirm();
            // End:0x25A
            break;
        // End:0x7E
        case "left":
            handleTurnLeft(int(logicID));
            // End:0x25A
            break;
        // End:0x98
        case "right":
            handleTurnRight(int(logicID));
            // End:0x25A
            break;
        // End:0xC0
        case "zoom":
            // End:0xB7
            if(logicID == "1")
            {
                zoomIn();                
            }
            else
            {
                zoomOut();
            }
            // End:0x25A
            break;
        // End:0xE3
        case "race":
            setStep1Handle(int(logicID), Job, gender);
            // End:0x25A
            break;
        // End:0x108
        case "gender":
            setStep1Handle(Race, Job, int(logicID));
            // End:0x25A
            break;
        // End:0x12A
        case "job":
            setStep1Handle(Race, int(logicID), gender);
            // End:0x25A
            break;
        // End:0x14D
        case "faceType":
            FaceType = int(logicID);
            handleSetCharacterStyle();
            // End:0x25A
            break;
        // End:0x170
        case "hairType":
            HairType = int(logicID);
            handleSetCharacterStyle();
            // End:0x25A
            break;
        // End:0x194
        case "hairColor":
            HairColor = int(logicID);
            handleSetCharacterStyle();
            // End:0x25A
            break;
        // End:0x1C6
        case "create":
            IsCreate = true;
            ParseString(param, "Name", Name);
            handleNameConfirm();
            // End:0x25A
            break;
        // End:0x201
        case "class":
            ParseString(param, "targetName", TargetName);
            classDescription(int(logicID), TargetName);
            // End:0x25A
            break;
        // End:0x224
        case "dragPoint":
            handleDragCharacter(int(logicID), param);
            // End:0x25A
            break;
        // End:0x23B
        case "ID":
            Id = int(logicID);
            // End:0x25A
            break;
        // End:0x257
        case "setRandom":
            setRandom(logicID);
            // End:0x25A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function setRandom(string param)
{
    local int nextRace, nextGender, nextJob;

    ParseInt(param, "randRace", nextRace);
    ParseInt(param, "randGender", nextGender);
    ParseInt(param, "randJob", nextJob);
    setStep1Handle(nextRace, nextJob, nextGender);
    return;
}

function handleSetCharacterStyle()
{
    SetCharacterStyle(Id, HairType, HairColor, FaceType);
    return;
}

function setStep2Handle()
{
    local string Result;

    Result = "";
    handleSetCharacterStyle();
    ParamAdd(Result, "faceType", string(FaceType));
    ParamAdd(Result, "hairType", string(HairType));
    ParamAdd(Result, "hairColor", string(HairColor));
    CallGFxFunction("CharacterCreateMenuWnd", "STEP_CHANGED_2", Result);
    return;
}

function setStep1Handle(int nextRace, int nextJob, int nextGender)
{
    local string Result;
    local array<int> initialStat;
    local bool isRaceChange;

    isRaceChange = Race != nextRace;
    Result = "";
    ShowDefaultCharacter(Id, isRaceChange);
    // End:0x48
    if(isRaceChange)
    {
        m_bZoomed = false;
        fadeInOut(nextRace);
    }
    Race = nextRace;
    Job = nextJob;
    gender = nextGender;
    // End:0x92
    if(Job > 1)
    {
        initialStat = GetClassInitialStatEx(Job, Race, gender);        
    }
    else
    {
        // End:0xD2
        if(RACE_STR[Race] == "KAMAEL")
        {
            initialStat = GetClassInitialStat(util.getInitClassID(Race, gender));            
        }
        else
        {
            initialStat = GetClassInitialStat(util.getInitClassID(Race, Job));
        }
    }
    ParamAdd(Result, "STR", string(initialStat[0]));
    ParamAdd(Result, "DEX", string(initialStat[1]));
    ParamAdd(Result, "CON", string(initialStat[2]));
    ParamAdd(Result, "INT", string(initialStat[3]));
    ParamAdd(Result, "WIT", string(initialStat[4]));
    ParamAdd(Result, "MEN", string(initialStat[5]));
    ParamAdd(Result, "LUC", string(initialStat[6]));
    ParamAdd(Result, "CHA", string(initialStat[7]));
    ParamAdd(Result, "race", string(Race));
    ParamAdd(Result, "gender", string(gender));
    ParamAdd(Result, "job", string(Job));
    ParamAdd(Result, "max_faceType", string(getFaceTypeMaxNum()));
    ParamAdd(Result, "max_hairType", string(getHairTypeMaxNum()));
    ParamAdd(Result, "max_hairColor", string(getHairColorMaxNum()));
    CallGFxFunction("CharacterCreateMenuWnd", "STEP_CHANGED_1", Result);
    setRandomTypes(Id);
    setStep2Handle();
    return;
}

function classDescription(int ClassID, string TargetName)
{
    local string Result;

    Result = "";
    ParamAdd(Result, "classID", string(ClassID));
    ParamAdd(Result, "classType", GetClassType(ClassID));
    ParamAdd(Result, "desc", GetClassDescription(ClassID));
    ParamAdd(Result, "targetName", TargetName);
    CallGFxFunction("CharacterCreateMenuWnd", "NAME_CHECK_RESULT", Result);
    return;
}

function fadeInOut(int nextRace)
{
    // End:0x2E
    if(Race == -1)
    {
        ExecLobbyEvent(RACE_STR[nextRace] $ "_FadeIn");        
    }
    else
    {
        ExecLobbyEvent(RACE_STR[Race] $ "_FadeOut");
        ExecLobbyNextEvent(RACE_STR[Race] $ "_FadeOut", RACE_STR[nextRace] $ "_FadeIn");
    }
    return;
}

function handleDragCharacter(int Speed, string param)
{
    local string Type;
    local int MaxSpeed;

    MaxSpeed = 10000;
    ParseString(param, "type", Type);
    // End:0x64
    if(((Type == "rollOver") || Type == "press") || Type == "click")
    {
        SetRotateCursor();        
    }
    else
    {
        // End:0x9C
        if((Type == "releaseOutside") || Type == "rollOut")
        {
            UnsetRotateCursor();            
        }
        else
        {
            // End:0x106
            if(Speed != 0)
            {
                Speed = Speed * 400;
                // End:0xD6
                if(Speed > MaxSpeed)
                {
                    Speed = MaxSpeed;                    
                }
                else
                {
                    // End:0xF4
                    if(Speed < -MaxSpeed)
                    {
                        Speed = -MaxSpeed;
                    }
                }
                DefaultCharacterMouseTurn(Id, float(Speed));
            }
        }
    }
    return;
}

function handleTurnLeft(int logicID)
{
    // End:0x1F
    if(logicID == 3)
    {
        DefaultCharacterTurn(Id, 6.0000000);        
    }
    else
    {
        DefaultCharacterStop(Id);
    }
    return;
}

function handleTurnRight(int logicID)
{
    // End:0x1F
    if(logicID == 3)
    {
        DefaultCharacterTurn(Id, -6.0000000);        
    }
    else
    {
        DefaultCharacterStop(Id);
    }
    return;
}

function zoomIn()
{
    ExecLobbyEvent(RACE_STR[Race] $ "_ZoomIn");
    m_bZoomed = true;
    return;
}

function zoomOut()
{
    ExecLobbyEvent(RACE_STR[Race] $ "_ZoomOut");
    m_bZoomed = false;
    return;
}

function HandleCreateCharacter(bool bOK)
{
    local int ClassID;

    // End:0x67
    if(bOK)
    {
        // End:0x23
        if(Job > 2)
        {
            ClassID = Job;            
        }
        else
        {
            ClassID = CharacterCreateGetClassType(Race, Job, gender);
        }
        RequestCreateCharacter(Name, Race, ClassID, gender, HairType, HairColor, FaceType);
    }
    return;
}

function HandlecharacterNameCreatable(string a_Param)
{
    local int CreateFailType, systemStringArr[8];

    ParseInt(a_Param, "CreateFailType", CreateFailType);
    // End:0x5E
    if(CreateFailType == -1)
    {
        // End:0x41
        if(IsCreate)
        {
            ShowCreateDialog();            
        }
        else
        {
            systemMessage.handleShowMessage(GetSystemMessage(3539));
        }        
    }
    else
    {
        systemStringArr[0] = 128;
        systemStringArr[1] = 77;
        systemStringArr[2] = 79;
        systemStringArr[3] = 80;
        systemStringArr[4] = 204;
        systemStringArr[5] = 1882;
        systemStringArr[6] = 2037;
        systemStringArr[7] = 6074;
        systemMessage.handleShowMessage(GetSystemMessage(systemStringArr[CreateFailType]));
    }
    return;
}

function ShowCreateDialog()
{
    Class'Interface.UICommonAPI'.static.DialogSetID(3300);
    Class'Interface.UICommonAPI'.static.DialogShow(0, 0, GetSystemMessage(3533), string(self));
    return;
}

function handleNameConfirm()
{
    // End:0x3B
    if((Len(Name) == 0) || !CheckNameLength(Name))
    {
        systemMessage.handleShowMessage(GetSystemMessage(80));
        return;        
    }
    else
    {
        // End:0x64
        if(!CheckValidName(Name))
        {
            systemMessage.handleShowMessage(GetSystemMessage(204));
            return;
        }
    }
    RequestCharacterNameCreatable(Name);
    return;
}

function HandleDialogResult(bool bOK)
{
    local int DlgID;

    // End:0x19
    if(!Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
    {
        return;
    }
    DlgID = Class'Interface.UICommonAPI'.static.DialogGetID();
    switch(DlgID)
    {
        // End:0x4C
        case 3300:
            HandleCreateCharacter(bOK);
            // End:0x4F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
