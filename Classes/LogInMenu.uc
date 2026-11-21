class LogInMenu extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;
const DLG_ID_WAITING = 100021;

var array<GFxValue> args;
var GFxValue invokeResult;
var L2Util util;
var DialogBox dScript;
var int currentScreenWidth;
var int currentScreenHeight;

function OnRegisterEvent()
{
    RegisterEvent(5630);
    RegisterEvent(2900);
    RegisterEvent(3410);
    RegisterEvent(5651);
    RegisterEvent(1710);
    return;
}

function OnLoad()
{
    SetHavingFocus(false);
    SetContainer("ContainerHUD");
    SetAnchor("", 7, 7, 0, 0);
    dScript = DialogBox(GetScript("DialogBox"));
    L2Util(GetScript("L2Util")).getCastleNameExData();
    CollectionWnd(GetScript("CollectionWnd")).getCollectionData();
    return;
}

function OnShow()
{
    return;
}

function OnFlashLoaded()
{
    SendCurrLanguage();
    return;
}

function OnFocus(bool bFlag, bool bTransparency)
{
    return;
}

function OnHide()
{
    return;
}

function OnCallUCFunction(string logicID, string param)
{
    local string strParam;

    // End:0x9A
    if(logicID == "0")
    {
        // End:0x67
        if((IsNative() == false) && (getLanguageNum()) == 5)
        {
            ParamAdd(strParam, "ErrorMsg", MakeFullSystemMsg(GetSystemMessage(6090), GetSystemMessage(6088), GetSystemMessage(6089)));            
        }
        else
        {
            ParamAdd(strParam, "ErrorMsg", GetSystemMessage(5019));
        }
        ExecuteEvent(5641, strParam);        
    }
    else
    {
        // End:0x134
        if(logicID == "1")
        {
            // End:0x101
            if((IsNative() == false) && (getLanguageNum()) == 5)
            {
                ParamAdd(strParam, "ErrorMsg", MakeFullSystemMsg(GetSystemMessage(6087), GetSystemMessage(6088), GetSystemMessage(6089)));                
            }
            else
            {
                ParamAdd(strParam, "ErrorMsg", GetSystemMessage(5020));
            }
            ExecuteEvent(5641, strParam);            
        }
        else
        {
            // End:0x14A
            if(logicID == "2")
            {
                OpenL2Home();                
            }
            else
            {
                // End:0x160
                if(logicID == "3")
                {
                    StartCredit();                    
                }
                else
                {
                    // End:0x189
                    if(logicID == "4")
                    {
                        SetUIState("ReplaySelectState");                        
                    }
                    else
                    {
                        // End:0x19F
                        if(logicID == "5")
                        {
                            HandleShowOptionWnd();                            
                        }
                        else
                        {
                            // End:0x1DC
                            if(logicID == "6")
                            {
                                ParamAdd(strParam, "ErrorMsg", GetSystemMessage(4082));
                                ExecuteEvent(5641, strParam);
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x2A
    if(Event_ID == 5630)
    {
        // End:0x27
        if(IsShowWindow() == false)
        {
            ShowWindow();
            SendScreenSize();
        }        
    }
    else
    {
        // End:0x42
        if(Event_ID == 2900)
        {
            SendScreenSize();            
        }
        else
        {
            // End:0x103
            if(Event_ID == 3410)
            {
                switch(param)
                {
                    // End:0x71
                    case "LoginState":
                        SendSetButtonVisible(true);
                        // End:0x100
                        break;
                    // End:0x87
                    case "ReplaySelectState":
                    // End:0x9A
                    case "LOGINWAITSTATE":
                    // End:0xAB
                    case "EULAMSGSTATE":
                    // End:0xBF
                    case "SERVERLISTSTATE":
                    // End:0xD4
                    case "PIAgreementState":
                    // End:0xF7
                    case "LOGINWAITSTATE":
                        ShowWindow();
                        SendSetButtonVisible(false);
                        // End:0x100
                        break;
                    // End:0xFFFF
                    default:
                        HideWindow();
                        break;
                }                
            }
            else
            {
                // End:0x120
                if(Event_ID == 5651)
                {
                    waitingProcess(param);                    
                }
                else
                {
                    // End:0x19C
                    if(Event_ID == 1710)
                    {
                        // End:0x14A
                        if(!dScript.GetTarget() == string(self))
                        {
                            return;
                        }
                        switch(dScript.GetID())
                        {
                            // End:0x199
                            case 100021:
                                Debug("LoginState->" @ param);
                                CancelWaitingQueueTicket();
                                SetUIState("LoginState");
                                // End:0x19C
                                break;
                            // End:0xFFFF
                            default:
                                break;
                        }
                    }
                    else
                    {
                    }
                }
            }
        }
        return;
    }
}

function waitingProcess(string param)
{
    local int nResult, nWaiterCount;
    local string MessageString;

    ParseInt(param, "nResult", nResult);
    ParseInt(param, "nWaiterCount", nWaiterCount);
    MessageString = "";
    Debug("waitingProcess param" @ param);
    dScript.HideDialog();
    // End:0xFA
    if((nResult == 1) && nWaiterCount > 0)
    {
        MessageString = MakeFullSystemMsg(GetSystemMessage(6830), string(nWaiterCount));
        // End:0xF7
        if(Len(MessageString) > 0)
        {
            dScript.ShowDialog(0, 5, MessageString, string(self));
            dScript.setId(100021);
            dScript.SetButtonName(1342);
        }        
    }
    else
    {
        // End:0x115
        if((nResult == 1) && nWaiterCount == 0)
        {            
        }
        else
        {
            MessageString = MakeFullSystemMsg(GetSystemMessage(7203), string(nWaiterCount));
            dScript.ShowDialog(0, 5, MessageString, string(self));
            dScript.setId(100021);
        }
    }
    return;
}

function SendSetButtonVisible(bool B)
{
    CallGFxFunction("LogInMenu", "SendSetButtonVisible", "bool=" $ string(B));
    return;
}

function SendCurrLanguage()
{
    local int languageNum;

    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(51);
    CreateObject(args[1]);
    languageNum = getLanguageNum();
    // End:0x66
    if((IsNative() == false) && (getLanguageNum()) == 5)
    {
        languageNum = 1;
    }
    CallGFxFunction("LogInMenu", "SendCurrLanguage", "language=" $ string(languageNum));
    args[1].SetMemberInt("language", languageNum);
    Invoke("_root.onEvent", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function int getLanguageNum()
{
    local UIEventManager.ELanguageType Language;

    Language = GetLanguage();
    return int(Language);
    return;
}

function SendScreenSize()
{
    GetCurrentResolution(currentScreenWidth, currentScreenHeight);
    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(100);
    CreateObject(args[1]);
    args[1].SetMemberInt("screenW", currentScreenWidth);
    CallGFxFunction("LogInMenu", "SendScreenSize", "w=" $ string(currentScreenWidth));
    Invoke("_root.onEvent", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function HandleShowOptionWnd()
{
    local OptionWnd win;

    win = OptionWnd(GetScript("OptionWnd"));
    win.ToggleOpenMeWnd(false);
    return;
}
