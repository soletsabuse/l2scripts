class PetitionWnd extends UICommonAPI;

var ChatWindowHandle petitionchat;

function OnRegisterEvent()
{
    RegisterEvent(1920);
    RegisterEvent(1930);
    RegisterEvent(1940);
    return;
}

function OnLoad()
{
    local ListBoxHandle temp;

    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    SetFeedBackEnable(false);
    petitionchat = GetChatWindowHandle("PetitionWnd.PetitionChatWindow");
    petitionchat.SetScrollBarPosition(368, 0, 0);
    temp = GetListBoxHandle("PetitionWnd.PetitionChatWindow");
    temp.SetDrawOffset(3, 3);
    temp.SetMaxRow(200);
    return;
}

function OnHide()
{
    SetFeedBackEnable(false);
    return;
}

function SetFeedBackEnable(bool a_IsEnabled)
{
    // End:0x37
    if(a_IsEnabled)
    {
        Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PetitionWnd.FeedBackButton");        
    }
    else
    {
        Class'NWindow.UIAPI_BUTTON'.static.DisableWindow("PetitionWnd.FeedBackButton");
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x18
        case 1920:
            HandleShowPetitionWnd();
            // End:0x47
            break;
        // End:0x2E
        case 1930:
            HandlePetitionChatMessage(a_Param);
            // End:0x47
            break;
        // End:0x44
        case 1940:
            HandleEnablePetitionFeedback(a_Param);
            // End:0x47
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnCompleteEditBox(string strID)
{
    local string Message;

    switch(strID)
    {
        // End:0x63
        case "PetitionChatEditBox":
            Message = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PetitionWnd.PetitionChatEditBox");
            ProcessPetitionChatMessage(Message);
            // End:0x66
            break;
        // End:0xFFFF
        default:
            break;
    }
    Class'NWindow.UIAPI_EDITBOX'.static.Clear("PetitionWnd.PetitionChatEditBox");
    return;
}

function HandleShowPetitionWnd()
{
    // End:0x24
    if(m_hOwnerWnd.IsMinimizedWindow())
    {
        m_hOwnerWnd.NotifyAlarm();        
    }
    else
    {
        ShowWindow("PetitionWnd");
        m_hOwnerWnd.SetFocus();
    }
    return;
}

function HandlePetitionChatMessage(string a_Param)
{
    local string chatMessage;
    local Color ChatColor;
    local int tmpType;

    // End:0x7C
    if((ParseString(a_Param, "Message", chatMessage)) && ParseInt(a_Param, "SayType", tmpType))
    {
        Debug(chatMessage);
        ChatColor = GetChatColorByType(tmpType);
        Debug(string(petitionchat));
        petitionchat.AddString(chatMessage, ChatColor);
    }
    return;
}

function HandleEnablePetitionFeedback(string a_Param)
{
    local int Enable;

    // End:0x37
    if(ParseInt(a_Param, "Enable", Enable))
    {
        // End:0x30
        if(1 == Enable)
        {
            SetFeedBackEnable(true);            
        }
        else
        {
            SetFeedBackEnable(false);
        }
    }
    return;
}

function OnClickButton(string a_ControlID)
{
    switch(a_ControlID)
    {
        // End:0x23
        case "FeedBackButton":
            OnClickFeedBackButton();
            // End:0x40
            break;
        // End:0x3D
        case "CancelButton":
            OnClickCancelButton();
            // End:0x40
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickFeedBackButton()
{
    local UIScript.PetitionMethod useNewPetition;

    useNewPetition = GetPetitionMethod();
    // End:0x46
    if(int(useNewPetition) == int(1))
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("NewPetitionFeedBackWnd");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PetitionFeedBackWnd");
    }
    return;
}

function OnClickCancelButton()
{
    SetFeedBackEnable(false);
    Class'NWindow.PetitionAPI'.static.RequestPetitionCancel();
    return;
}

function Clear()
{
    local ListBoxHandle temp;

    temp = GetListBoxHandle("PetitionWnd.PetitionChatWindow");
    temp.super(PetitionWnd).Clear();
    return;
}
