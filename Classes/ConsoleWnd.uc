class ConsoleWnd extends UICommonAPI;

const DLG_ID_RESTART = 0;
const DLG_ID_QUIT = 1;
const DIG_ID_ASK_COUPLEACTION = 1112;

var WindowHandle m_hSystemMenuWnd;
var DialogBox dScript;

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(4900);
    RegisterEvent(4920);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    dScript = DialogBox(GetScript("DialogBox"));
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x18
        case 1710:
            HandleDlgOk();
            // End:0x53
            break;
        // End:0x2E
        case 4900:
            HandleCoupleActionAskStart(param);
            // End:0x53
            break;
        // End:0x3F
        case 4920:
            HandleUploadAllianceCrestFile();
            // End:0x53
            break;
        // End:0x50
        case 1720:
            HandleDialogCancel();
            // End:0x53
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleDlgOk()
{
    // End:0x0D
    if(!DialogIsMine())
    {
        return;
    }
    switch(DialogGetID())
    {
        // End:0x4C
        case 1112:
            dScript.SetButtonName(1337, 1342);
            AnswerCoupleAction(DialogGetReservedInt(), 1, DialogGetReservedInt3());
            // End:0x4F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleCoupleActionAskStart(string param)
{
    local bool bOption;
    local int pActionID, pRequestUserID;
    local string Username, actionStr;

    bOption = GetOptionBool("Communication", "IsCoupleAction");
    ParseInt(param, "ActionID", pActionID);
    ParseInt(param, "requestUserID", pRequestUserID);
    // End:0x89
    if(bOption == true)
    {
        AnswerCoupleAction(pActionID, -1, pRequestUserID);        
    }
    else
    {
        // End:0xB0
        if(IsShowWindow("DialogBox"))
        {
            AnswerCoupleAction(pActionID, 0, pRequestUserID);
            return;
        }
        Username = Class'NWindow.UIDATA_USER'.static.GetUserName(pRequestUserID);
        DialogSetID(1112);
        DialogSetCancelD(1112);
        DialogSetReservedInt(pActionID);
        DialogSetReservedInt3(pRequestUserID);
        DialogSetParamInt64((10 * 1000));
        dScript.SetButtonName(184, 185);
        Class'NWindow.ActionAPI'.static.GetActionNameBySocialIndex(pActionID, actionStr);
        DialogShow(1, 7, MakeFullSystemMsg(GetSystemMessage(3118), Username, actionStr), string(self));
    }
    return;
}

function HandleDialogCancel()
{
    local bool bOption;

    dScript.SetButtonName(1337, 1342);
    // End:0x12F
    if(DialogIsMine())
    {
        // End:0x12F
        if(DialogCheckCancelByID(1112))
        {
            bOption = GetOptionBool("Communication", "IsCoupleAction");
            Debug("=====================커플액션========================================");
            Debug("==> DialogGetReservedInt() " @ string(DialogGetReservedInt()));
            Debug("==> DialogGetReservedInt3() " @ string(DialogGetReservedInt3()));
            Debug("==> Answer " @ string(0));
            AnswerCoupleAction(DialogGetReservedInt(), 0, DialogGetReservedInt3());
        }
    }
    return;
}

function HandleUploadAllianceCrestFile()
{
    local array<string> fileextarr;

    // End:0x6A
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false)
    {
        AddSystemMessage(3143);
        fileextarr.Length = 1;
        fileextarr[0] = "bmp";
        ClearFileRegisterWndFileExt();
        AddFileRegisterWndFileExt(GetSystemString(2233), fileextarr);
        FileRegisterWndShow(3);
    }
    return;
}
