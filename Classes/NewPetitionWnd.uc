class NewPetitionWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle m_hTitleEditBox;
var MultiEditBoxHandle m_hContentsEditBox;
var int m_categoryId;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    OnRegisterEvent();
    Me = GetWindowHandle("NewPetitionWnd");
    m_hTitleEditBox = GetTextBoxHandle("NewPetitionWnd.PetitionGuideText");
    m_hContentsEditBox = GetMultiEditBoxHandle("NewPetitionWnd.PetitionMultiEdit");
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function OnShow()
{
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function OnHide()
{
    Clear();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    return;
}

function OnClickButton(string a_ControlID)
{
    switch(a_ControlID)
    {
        // End:0x23
        case "FeedBackButton":
            OnClickOKButton();
            // End:0x43
            break;
        // End:0x3D
        case "CancelButton":
            OnClickCancelButton();
            // End:0x43
            break;
        // End:0xFFFF
        default:
            // End:0x43
            break;
            break;
    }
    return;
}

function Clear()
{
    m_hContentsEditBox.SetString("");
    return;
}

function OnClickOKButton()
{
    local int ContentsMessageLen;
    local string ContentsMessage, param;
    local PetitionWnd PetitionWndScript;

    ContentsMessageLen = 0;
    ContentsMessage = m_hContentsEditBox.GetString();
    ContentsMessageLen = Len(ContentsMessage);
    // End:0x50
    if(15 > ContentsMessageLen)
    {
        DialogShow(1, 1, GetSystemMessage(2991), string(self));        
    }
    else
    {
        // End:0x7A
        if(800 <= ContentsMessageLen)
        {
            DialogShow(1, 1, GetSystemMessage(971), string(self));            
        }
        else
        {
            Class'NWindow.PetitionAPI'.static.RequestPetition(ContentsMessage, m_categoryId);
            Clear();
            HideWindow("NewPetitionWnd");
            PetitionWndScript = PetitionWnd(GetScript("PetitionWnd"));
            // End:0x188
            if(none != PetitionWndScript)
            {
                PetitionWndScript.Clear();
                ParamAdd(param, "Message", (GetSystemString(708) $ " : ") $ ContentsMessage);
                ParamAdd(param, "ColorR", "220");
                ParamAdd(param, "ColorG", "220");
                ParamAdd(param, "ColorB", "220");
                ParamAdd(param, "ColorA", "255");
                PetitionWndScript.HandlePetitionChatMessage(param);
            }
        }
    }
    return;
}

function OnClickCancelButton()
{
    Clear();
    Me.HideWindow();
    return;
}

function SetCategoryId(int categoryId)
{
    m_categoryId = categoryId;
    return;
}

function OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
    // End:0x16
    if(int(Key) == int(27))
    {
        OnClickCancelButton();
    }
    return;
}
