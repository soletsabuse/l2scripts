class GfxDialog extends L2UIGFxScript;

var UserInfo currentUserInfo;
var QuestTreeWnd QuestTreeWndScript;
var bool isDualMoviePlay;
var int _classID;
var string _linkageName;
var string _userName;

function OnRegisterEvent()
{
    RegisterEvent(40);
    RegisterEvent(5641);
    return;
}

function OnLoad()
{
    RegisterState(getCurrentWindowName(string(self)), "GamingState");
    QuestTreeWndScript = QuestTreeWnd(GetScript("QuestTreeWnd"));
    SetAlwaysOnTop(true);
    SetClosingOnESC();
    return;
}

function OnFlashLoaded()
{
    SetAnchor("", 5, 5, 0, 0);
    return;
}

function OnShow()
{
    PlayConsoleSound(5);
    return;
}

function OnHide()
{
    PlayConsoleSound(6);
    return;
}

function OnCallUCLogic(int logicID, string param)
{
    local string dialogName;

    ParseString(param, "Name", dialogName);
    switch(dialogName)
    {
        // End:0x46
        case "AwakeNoticeDialog":
            AwakeNoticeDialogHandler(logicID, param);
            // End:0x9D
            break;
        // End:0x70
        case "DualPayDialogStep1":
            DualPayDialogStep1(logicID, param);
            // End:0x9D
            break;
        // End:0x9A
        case "DualPayDialogStep2":
            DualPayDialogStep2(logicID, param);
            // End:0x9D
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xAF
    if(logicID == 3)
    {
        OpenL2Home();
    }
    return;
}

function DualPayDialogStep1(int logicID, string param)
{
    isDualMoviePlay = true;
    RequestShowVisionMovie();
    return;
}

function onMovieEnd()
{
    // End:0x40
    if(isDualMoviePlay)
    {
        isDualMoviePlay = false;
        showGfxDialog("dialogLinkageName", "DualPayDialogStep2", "");
    }
    return;
}

function DualPayDialogStep2(int logicID, string param)
{
    local InventoryWnd script;

    // End:0x1C
    if(logicID == 1)
    {
        OpenGivenURL(GetSystemString(3120));
    }
    script = InventoryWnd(GetScript("InventoryWnd"));
    script.SaveInventoryOrder();
    ExecQuit();
    return;
}

function AwakeNoticeDialogHandler(int logicID, string param)
{
    local string strParam;
    local int ClassID;

    GetPlayerInfo(currentUserInfo);
    // End:0x4B
    if(QuestTreeWndScript.isQuestIDSearch(10338) || (currentUserInfo.nClassID <= 147) && currentUserInfo.nClassID >= 139)
    {        
    }
    else
    {
        // End:0x5F
        if(logicID == 1)
        {
            RequestCallToChangeClass();            
        }
        else
        {
            // End:0xDC
            if(logicID == 2)
            {
                ParseInt(param, "Class", ClassID);
                ParamAdd(strParam, "Class", string(ClassID));
                ParamAdd(strParam, "Immediate", string(0));
                ParamAdd(strParam, "UserType", string(1));
                ExecuteEvent(5470, strParam);
            }
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x33
    if(Event_ID == 5641)
    {
        showGfxDialog("linkage", "LogInDialog", param);        
    }
    else
    {
        // End:0x45
        if(Event_ID == 40)
        {
            HideWindow();
        }
    }
    return;
}

function showGfxDialog(string linkageName, string Type, string param)
{
    local int ClassID;
    local string ErrorMsg;
    local int EventID;
    local array<GFxValue> args;
    local GFxValue invokeResult;

    _linkageName = Type;
    // End:0x4B
    if((Type != "AwakeNoticeDialog") && Type != "LogInDialog")
    {
        SetModal(true);        
    }
    else
    {
        SetModal(false);
    }
    // End:0xBD
    if(Type == "LogInDialog")
    {
        ParseString(param, "ErrorMsg", ErrorMsg);
        Class'Interface.UICommonAPI'.static.DialogSetID(0);
        Class'Interface.UICommonAPI'.static.DialogShow(0, 1, ErrorMsg, string(self), 450, 244, true, "");
        return;        
    }
    else
    {
        AllocGFxValues(args, 2);
        AllocGFxValue(invokeResult);
        CreateObject(args[1]);
        // End:0x1AC
        if(Type == "DualPayDialogStep1")
        {
            GetPlayerInfo(currentUserInfo);
            ParseInt(param, "Class", ClassID);
            _classID = ClassID;
            _userName = currentUserInfo.Name;
            EventID = 1;
            args[1].SetMemberString("userName", currentUserInfo.Name);
            args[1].SetMemberString(linkageName, Type);
            args[1].SetMemberInt("classID", ClassID);
            ShowWindow();            
        }
        else
        {
            // End:0x200
            if(Type == "DualPayDialogStep2")
            {
                GetPlayerInfo(currentUserInfo);
                EventID = 1;
                args[1].SetMemberString(linkageName, Type);
                ShowWindow();                
            }
            else
            {
                // End:0x30C
                if(Type == "AwakeNoticeDialog")
                {
                    // End:0x245
                    if(!GetPlayerInfo(currentUserInfo))
                    {
                        DeallocGFxValue(invokeResult);
                        DeallocGFxValues(args);
                        return;
                    }
                    // End:0x2A3
                    if(QuestTreeWndScript.isQuestIDSearch(10338) || (currentUserInfo.nClassID <= 147) && currentUserInfo.nClassID >= 139)
                    {
                        HideWindow();
                        DeallocGFxValue(invokeResult);
                        DeallocGFxValues(args);
                        return;                        
                    }
                    else
                    {
                        ParseInt(param, "Class", ClassID);
                        _classID = ClassID;
                        EventID = 1;
                        args[1].SetMemberString(linkageName, Type);
                        args[1].SetMemberInt("classID", ClassID);
                        ShowWindow();
                    }
                }
            }
        }
        args[0].SetInt(EventID);
        Invoke("onEvent", args, invokeResult);
        DeallocGFxValue(invokeResult);
        DeallocGFxValues(args);
    }
    return;
}

function OnReceivedCloseUI()
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    AllocGFxValues(args, 1);
    AllocGFxValue(invokeResult);
    Invoke("onReceivedCloseUI", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}
