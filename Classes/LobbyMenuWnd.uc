class LobbyMenuWnd extends L2UIGFxScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;
const DLG_ID_DELETE = 0;
const DLG_ID_RESTORE = 1;
const DLG_ID_DormantUserCoupon = 3;

var int currentScreenWidth;
var int currentScreenHeight;
var int selectedNum;
var int maxCharacterNum;
var bool isDeleting;
var int nVitalityBonus;
var int nVitalityItemRestoreCount;
var bool isStarting;
var bool isPrologueGrowSelected;

function OnRegisterEvent()
{
    RegisterEvent(3021);
    RegisterEvent(3022);
    RegisterEvent(3023);
    RegisterEvent(3025);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(3026);
    RegisterEvent(3024);
    RegisterEvent(3410);
    RegisterEvent(3027);
    RegisterEvent(4120);
    RegisterEvent(3029);
    RegisterGFxEvent(20240);
    return;
}

function OnLoad()
{
    RegisterState("lobbyMenuWnd", "CHARACTERSELECTSTATE");
    SetContainerWindow("none", 0);
    SetAnchor("", 9, 1, 0, 0);
    maxCharacterNum = 0;
    Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 0);
    return;
}

function OnShow()
{
    isStarting = false;
    SetFocus();
    // End:0x58
    if((GetUIUserPremiumLevel() <= 0) && !getInstanceUIData().getIsClassicServer())
    {
        // End:0x58
        if(GetLanguageCustom() != 2)
        {
            CallGFxFunction("LobbyMenuWnd", "12", "");
        }
    }
    return;
}

function int getLanguageNum()
{
    local UIEventManager.ELanguageType Language;

    Language = GetLanguage();
    return int(Language);
    return;
}

function OnCallUCFunction(string logicID, string param)
{
    local string btnName;

    ParseString(param, "btnName", btnName);
    switch(btnName)
    {
        // End:0x41
        case "startBtn":
            // End:0x3E
            if(!isDeleting)
            {
                OnClickStartButton();
            }
            // End:0x126
            break;
        // End:0x5F
        case "prev":
            // End:0x5C
            if(!isDeleting)
            {
                onClickPrevNext(false);
            }
            // End:0x126
            break;
        // End:0x7D
        case "next":
            // End:0x7A
            if(!isDeleting)
            {
                onClickPrevNext(true);
            }
            // End:0x126
            break;
        // End:0x94
        case "createBtn":
            CreateNewCharacter();
            // End:0x126
            break;
        // End:0xB6
        case "deleteBtn":
            // End:0xB3
            if(!isDeleting)
            {
                OnClickDeleteCharacter();
            }
            // End:0x126
            break;
        // End:0xCC
        case "loginBtn":
            GotoLogin();
            // End:0x126
            break;
        // End:0xF4
        case "restoreBtn":
            // End:0xF1
            if(!isDeleting)
            {
                ShowRestoreDialog(selectedNum);
            }
            // End:0x126
            break;
        // End:0x120
        case "isPrologueGrowSelected":
            isPrologueGrowSelected = bool(logicID);
            // End:0x126
            break;
        // End:0xFFFF
        default:
            // End:0x126
            break;
            break;
    }
    return;
}

function OnClickDeleteCharacter()
{
    local string Msg;
    local UserInfo Info;

    // End:0x0B
    if(isStarting)
    {
        return;
    }
    // End:0x2B
    if((IsScheduledToDeleteCharacter(selectedNum)) || IsDisciplineCharacter(selectedNum))
    {
        return;
    }
    // End:0x42
    if(!GetSelectedCharacterInfo(selectedNum, Info))
    {
        return;
    }
    // End:0x72
    if(GetUIUserPremiumLevel() > 0)
    {
        Msg = MakeFullSystemMsg(GetSystemMessage(4076), Info.Name);        
    }
    else
    {
        // End:0xA4
        if(IsActivateCharacter(selectedNum))
        {
            Msg = MakeFullSystemMsg(GetSystemMessage(4075), Info.Name);            
        }
        else
        {
            Msg = MakeFullSystemMsg(GetSystemMessage(4076), Info.Name);
        }
    }
    ShowDeleteDialog(selectedNum, Msg);
    return;
}

function ShowDeleteDialog(int Index, string Msg)
{
    Class'Interface.UICommonAPI'.static.DialogSetID(0);
    Class'Interface.UICommonAPI'.static.DialogSetReservedInt(Index);
    Class'Interface.UICommonAPI'.static.DialogShow(0, 0, Msg, string(self));
    return;
}

function OnClickStartButton()
{
    // End:0x1F
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("DialogBox"))
    {
        return;
    }
    // End:0x3F
    if((IsScheduledToDeleteCharacter(selectedNum)) || IsDisciplineCharacter(selectedNum))
    {
        return;
    }
    isStarting = true;
    PlaySoundUntilEnd("InterfaceSound.game_start");
    StartGame(selectedNum);
    return;
}

function bool isLiveServer()
{
    local string Message;

    // End:0x17
    if(!getInstanceUIData().getIsClassicServer())
    {
        return false;
    }
    ParamAdd(Message, "Message", GetSystemMessage(4304));
    switch(GetReleaseMode())
    {
        // End:0x58
        case 3:
            ExecuteEvent(581, Message);
            return true;
            // End:0x76
            break;
        // End:0x60
        case 0:
            // End:0x76
            break;
        // End:0x68
        case 1:
            // End:0x76
            break;
        // End:0x70
        case 2:
            // End:0x76
            break;
        // End:0xFFFF
        default:
            // End:0x76
            break;
            break;
    }
    return false;
    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    switch(Event_ID)
    {
        // End:0xB1
        case 3410:
            // End:0x5D
            if(a_Param == "CHARACTERSELECTSTATE")
            {
                // End:0x5A
                if(IsShowWindow() == false)
                {
                    ShowWindow();
                    CallGFxFunction("LobbyMenuWnd", "1", "");
                }                
            }
            else
            {
                CallGFxFunction("LobbyMenuWnd", "2", "");
                HideWindow();
                Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 0);
            }
            // End:0x25F
            break;
        // End:0xC3
        case 3021:
            maxCharacterNum++;
            // End:0x25F
            break;
        // End:0xF9
        case 3022:
            SetFocus();
            CallGFxFunction("LobbyMenuWnd", "11", "");
            HandleCharacterSelect(a_Param);
            // End:0x25F
            break;
        // End:0x137
        case 3023:
            CallGFxFunction("LobbyMenuWnd", "9", "string=" $ GetSystemMessage(5060));
            ResetCharacterSelectWindow();
            // End:0x25F
            break;
        // End:0x14D
        case 3025:
            HandleSetRestoreButton(a_Param);
            // End:0x25F
            break;
        // End:0x15F
        case 1710:
            HandleDialogResult(true);
            // End:0x25F
            break;
        // End:0x171
        case 1720:
            HandleDialogResult(false);
            // End:0x25F
            break;
        // End:0x203
        case 3026:
            SetSelectedCharacter(selectedNum);
            // End:0x1CE
            if(selectedNum > -1)
            {
                Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 255, 0.5000000);                
            }
            else
            {
                Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 0);
            }
            // End:0x25F
            break;
        // End:0x21F
        case 3024:
            // End:0x21C
            if(!isDeleting)
            {
                OnClickStartButton();
            }
            // End:0x25F
            break;
        // End:0x232
        case 3027:
            isDeleting = false;
            // End:0x25F
            break;
        // End:0x248
        case 4120:
            HandleVitalityEffectInfoParam(a_Param);
            // End:0x25F
            break;
        // End:0x259
        case 3029:
            HandleLobbyShowDormantUserCouponWnd();
            // End:0x25F
            break;
        // End:0xFFFF
        default:
            // End:0x25F
            break;
            break;
    }
    return;
}

function HandleLobbyShowDormantUserCouponWnd()
{
    local DialogBox script;

    Class'Interface.UICommonAPI'.static.DialogSetID(3);
    script = DialogBox(GetScript("DialogBox"));
    script.SetButtonName(3160, 1342);
    Class'Interface.UICommonAPI'.static.DialogShowWithResize(0, 0, GetSystemMessage(4090), 0, 225, string(self));
    return;
}

function int getBonusPercent(int nVitality)
{
    local int __var4283;

    // End:0x23
    if((nVitality >= 0) && nVitality <= 240)
    {
        __var4283 = 0;        
    }
    else
    {
        // End:0x4B
        if((nVitality >= 241) && nVitality <= 5000)
        {
            __var4283 = 25;            
        }
        else
        {
            // End:0x76
            if((nVitality >= 5001) && nVitality <= 10000)
            {
                __var4283 = 50;                
            }
            else
            {
                // End:0xA1
                if((nVitality >= 10001) && nVitality <= 15000)
                {
                    __var4283 = 75;                    
                }
                else
                {
                    // End:0xCC
                    if((nVitality >= 15001) && nVitality <= 20000)
                    {
                        __var4283 = 100;                        
                    }
                    else
                    {
                        __var4283 = 0;
                    }
                }
            }
        }
    }
    return __var4283;
    return;
}

function HandleVitalityEffectInfoParam(string a_Param)
{
    local string VitalityMessage1, Result;
    local UserInfo Info;

    ParseInt(a_Param, "vitalityBonus", nVitalityBonus);
    ParseInt(a_Param, "vitalItemCount", nVitalityItemRestoreCount);
    // End:0x13F
    if((SettingSectorBool("VITALITY", "VitalityEnabled")) && GetSelectedCharacterInfo(selectedNum, Info))
    {
        VitalityMessage1 = string(Info.nVitality);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("LobbyPercentViewWnd.VPPercentTxt", string(getBonusPercent(Info.nVitality)) $ "%");
        Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 255, 0.5000000);        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 0);
    }
    Result = Result $ (setParamString("vitalityBonus", string(nVitalityBonus)));
    Result = Result @ (setParamString("vitalItemCount", string(nVitalityItemRestoreCount)));
    Result = Result @ (setParamString("VitalityMessage1", VitalityMessage1));
    Result = Result @ (setParamString("VitalityMessage2", ""));
    CallGFxFunction("LobbyMenuWnd", "10", Result);
    return;
}

function bool SettingSectorBool(string bLock, string Field)
{
    local int __var20093;

    L2Util(GetScript("L2Util")).GetINIBoolPrefixed(bLock, Field, __var20093, "settings.ini");
    return bool(__var20093);
    return;
}

function string setParamString(string paramName, string vars)
{
    local string Result;

    Result = (paramName $ "=") $ vars;
    return Result;
    return;
}

function string setParamInt(string paramName, int vars)
{
    local string Result;

    Result = (paramName $ "=") $ string(vars);
    return Result;
    return;
}

function string setParamInt64(string paramName, INT64 vars)
{
    local string Result;

    Result = (paramName $ "=") $ (vars);
    return Result;
    return;
}

function setParams(int Index)
{
    local UserInfo Info;
    local int toDeleteChar, IsDisciplineChar;
    local string Result;

    // End:0x2C0
    if(GetSelectedCharacterInfo(Index, Info))
    {
        // End:0x2B
        if(IsScheduledToDeleteCharacter(Index))
        {
            toDeleteChar = 1;            
        }
        else
        {
            toDeleteChar = 0;
        }
        // End:0x4A
        if(IsDisciplineCharacter(Index))
        {
            IsDisciplineChar = 1;            
        }
        else
        {
            IsDisciplineChar = 0;
        }
        Result = Result $ (setParamInt("toDeleteChar", toDeleteChar));
        Result = Result @ (setParamInt("IsDisciplineChar", IsDisciplineChar));
        Result = Result @ (setParamInt("index", Index));
        Result = Result @ (setParamString("Name", Info.Name));
        Result = Result @ (setParamInt("LV", Info.nLevel));
        Result = Result @ (setParamString("SC", GetClassType(Info.nSubClass)));
        Result = Result @ (setParamInt64("SP", Info.nSP));
        Result = Result @ (setParamInt("CR", Info.nCriminalRate));
        Result = Result @ (setParamInt("HP", Info.nCurHP));
        Result = Result @ (setParamInt("maxHP", Info.nMaxHP));
        Result = Result @ (setParamInt("MP", Info.nCurMP));
        Result = Result @ (setParamInt("maxMP", Info.nMaxMP));
        Result = Result @ (setParamString("EXP", string(Info.fExpPercentRate * float(10000))));
        Result = Result @ (setParamInt("VP", Info.nVitality));
        Result = Result @ (setParamInt("maxVP", 20000));
        Result = Result @ (setParamInt("classID", Info.nSubClass));
        CallGFxFunction("LobbyMenuWnd", "8", Result);
        HandleVitalityEffectInfo(Info.nVitalBonus, Info.nVitalItem);
    }
    return;
}

function HandleVitalityEffectInfo(int nVitalBonus, int nVitalItem)
{
    local string VitalityMessage1, Result;
    local UserInfo Info;

    VitalityMessage1 = GetSystemString(2495);
    // End:0x111
    if((SettingSectorBool("VITALITY", "VitalityEnabled")) && GetSelectedCharacterInfo(selectedNum, Info))
    {
        VitalityMessage1 = string(Info.nVitality);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("LobbyPercentViewWnd.VPPercentTxt", string(getBonusPercent(Info.nVitality)) $ "%");
        Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 0);
        Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 255, 0.5000000);        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 0);
    }
    Result = Result $ (setParamString("VitalityMessage1", VitalityMessage1));
    Result = Result @ (setParamString("VitalityMessage2", ""));
    CallGFxFunction("LobbyMenuWnd", "10", Result);
    return;
}

function HandleCharacterSelect(string param)
{
    local int Index;

    ParseInt(param, "index", Index);
    // End:0x28
    if(Index == -1)
    {
        return;
    }
    onCharacterSelectChanged(Index);
    return;
}

function bool checkSelectEnable()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x32 [Loop If]
    if(i < maxCharacterNum)
    {
        // End:0x28
        if(!IsDisciplineCharacter(selectedNum))
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function int setEnableSelectedNum()
{
    // End:0x1C
    if(selectedNum < 0)
    {
        selectedNum = maxCharacterNum - 1;        
    }
    else
    {
        // End:0x32
        if(selectedNum >= maxCharacterNum)
        {
            selectedNum = 0;
        }
    }
    return selectedNum;
    return;
}

function onClickPrevNext(bool isNext)
{
    local int Id;

    // End:0x98
    if(maxCharacterNum > 1)
    {
        // End:0x26
        if(isNext)
        {
            selectedNum++;
            Id = 7;            
        }
        else
        {
            selectedNum--;
            Id = 6;
        }
        setEnableSelectedNum();
        CallGFxFunction("LobbyMenuWnd", "11", "");
        RequestCharacterSelect(selectedNum);
        CallGFxFunction("LobbyMenuWnd", string(Id), "string=" $ string(selectedNum));
        setParams(selectedNum);
    }
    return;
}

function onCharacterSelectChanged(int Index)
{
    local UserInfo Info;
    local int toDeleteChar;

    RequestCharacterSelect(Index);
    // End:0x3D
    if(GetSelectedCharacterInfo(Index, Info))
    {
        // End:0x36
        if(IsScheduledToDeleteCharacter(Index))
        {
            toDeleteChar = 1;            
        }
        else
        {
            toDeleteChar = 0;
        }
    }
    // End:0xEF
    if(selectedNum != Index)
    {
        // End:0xA1
        if(selectedNum > Index)
        {
            CallGFxFunction("LobbyMenuWnd", "6", (("string=" $ string(Index)) @ "toDeleteChar=") $ string(toDeleteChar));            
        }
        else
        {
            CallGFxFunction("LobbyMenuWnd", "7", (("string=" $ string(Index)) @ "toDeleteChar=") $ string(toDeleteChar));
        }
        selectedNum = Index;
    }
    // End:0x158
    if(SettingSectorBool("VITALITY", "VitalityEnabled"))
    {
        // End:0x155
        if(Index > -1)
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 255);
        }        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetAlpha("LobbyPercentViewWnd.VPPercentTxt", 0);
    }
    setParams(Index);
    return;
}

function HandleSetRestoreButton(string param)
{
    local string Type;

    ParseString(param, "Type", Type);
    CallGFxFunction("LobbyMenuWnd", "5", "string=" $ Type);
    return;
}

function HandleShowDialog(string param)
{
    local string Type;
    local int SelectedCharacter;

    ParseString(param, "Type", Type);
    switch(Type)
    {
        // End:0x5A
        case "restore":
            ParseInt(param, "SelectedCharacter", SelectedCharacter);
            ShowRestoreDialog(SelectedCharacter);
            // End:0x60
            break;
        // End:0xFFFF
        default:
            // End:0x60
            break;
            break;
    }
    return;
}

function ShowRestoreDialog(int SelectedCharacter)
{
    Class'Interface.UICommonAPI'.static.DialogSetID(1);
    Class'Interface.UICommonAPI'.static.DialogSetReservedInt(SelectedCharacter);
    Class'Interface.UICommonAPI'.static.DialogShow(1, 0, GetSystemMessage(1555), string(self));
    return;
}

function HandleDialogResult(bool bOK)
{
    local int DlgID, Reserved;

    // End:0x19
    if(!Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
    {
        return;
    }
    DlgID = Class'Interface.UICommonAPI'.static.DialogGetID();
    Reserved = Class'Interface.UICommonAPI'.static.DialogGetReservedInt();
    switch(DlgID)
    {
        // End:0x62
        case 1:
            HandleDialogRestore(bOK, Reserved);
            // End:0x94
            break;
        // End:0x7A
        case 0:
            HandleDialogDelete(bOK, Reserved);
            // End:0x94
            break;
        // End:0x8E
        case 3:
            HandleDormantUserCoupon(bOK);
            // End:0x94
            break;
        // End:0xFFFF
        default:
            // End:0x94
            break;
            break;
    }
    return;
}

function HandleDormantUserCoupon(bool bOK)
{
    // End:0x20
    if(bOK)
    {
        OpenGivenURL(GetSystemString(3119));
        GotoLogin();
    }
    return;
}

function HandleDialogRestore(bool bOK, int SelectedCharacter)
{
    // End:0x14
    if(bOK)
    {
        RequestRestoreCharacter(SelectedCharacter);
    }
    RequestCharacterSelect(SelectedCharacter);
    return;
}

function HandleDialogDelete(bool bOK, int SelectedCharacter)
{
    // End:0x1C
    if(bOK)
    {
        isDeleting = true;
        RequestDeleteCharacter(SelectedCharacter);
    }
    return;
}

function ResetCharacterSelectWindow()
{
    selectedNum = -1;
    CallGFxFunction("LobbyMenuWnd", "6", "string=-1");
    maxCharacterNum = 0;
    return;
}
