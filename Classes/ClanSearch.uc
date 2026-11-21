class ClanSearch extends L2UIGFxScript;

var int clanID;

function OnRegisterEvent()
{
    RegisterGFxEvent(9620);
    RegisterGFxEvent(9621);
    RegisterGFxEvent(9600);
    RegisterGFxEvent(9601);
    RegisterGFxEvent(9580);
    RegisterGFxEvent(9581);
    RegisterGFxEvent(9590);
    RegisterGFxEvent(9582);
    RegisterGFxEvent(9583);
    RegisterGFxEvent(9610);
    RegisterGFxEvent(9591);
    RegisterGFxEvent(9640);
    RegisterGFxEvent(340);
    RegisterGFxEvent(10520);
    RegisterGFxEvent(430);
    RegisterGFxEvent(10510);
    RegisterGFxEvent(40);
    RegisterGFxEvent(420);
    RegisterGFxEvent(10470);
    return;
}

function OnShow()
{
    getInstanceL2Util().checkIsPrologueGrowType(string(self));
    HideWindow();
    GetWindowHandle("ClanSearchWnd").ShowWindow();
    return;
}

function OnLoad()
{
    SetContainerWindow("SkinnedWindow", 3068);
    AddState("GAMINGSTATE");
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x1E
        case "getClanID":
            getClanID();
            // End:0x79
            break;
        // End:0x39
        case "sendPost":
            sendPost(param);
            // End:0x79
            break;
        // End:0x59
        case "whisperToUser":
            whisperToUser(param);
            // End:0x79
            break;
        // End:0x73
        case "askJoin":
            askJoin(param);
            // End:0x79
            break;
        // End:0xFFFF
        default:
            // End:0x79
            break;
            break;
    }
    return;
}

function getClanID()
{
    local UserInfo UserInfo;

    // End:0x1E
    if(GetPlayerInfo(UserInfo))
    {
        clanID = UserInfo.nClanID;
    }
    return;
}

function sendPost(string Username)
{
    local PostBoxWnd postBoxWndScript;
    local PostWriteWnd postWriteWndScript;

    // End:0x78
    if(Username != "")
    {
        postBoxWndScript = PostBoxWnd(GetScript("PostBoxWnd"));
        postWriteWndScript = PostWriteWnd(GetScript("PostWriteWnd"));
        postBoxWndScript.OnClickButton("PostSendBtn");
        postWriteWndScript.toWrite(Username);
    }
    return;
}

function whisperToUser(string Username)
{
    local ChatWnd chatWndScript;

    // End:0x44
    if(Username != "")
    {
        chatWndScript = ChatWnd(GetScript("ChatWnd"));
        chatWndScript.setChatEditBox(("\"" $ Username) $ " ");
    }
    return;
}

function askJoin(string UserID)
{
    local int nID;
    local InviteClanPopWnd InviteClanPopWndScript;
    local InviteClanPopWndClassic InviteClanPopWndClassicScript;

    nID = int(UserID);
    // End:0x99
    if(nID > 0)
    {
        // End:0x67
        if(getInstanceUIData().getIsClassicServer())
        {
            InviteClanPopWndClassicScript = InviteClanPopWndClassic(GetScript("InviteClanPopWndClassic"));
            InviteClanPopWndClassicScript.showByClanWnd();            
        }
        else
        {
            InviteClanPopWndScript = InviteClanPopWnd(GetScript("InviteClanPopWnd"));
            InviteClanPopWndScript.showByClanWnd();
        }
    }
    return;
}
