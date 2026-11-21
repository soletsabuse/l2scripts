class UserPetitionWnd extends UICommonAPI;

const MAX_PetitionCategory = 32;

var int PetitionCategoryCount;
var int PetitionCategoryTitle[32];
var string PetitionCategoryLink[32];
var HtmlHandle m_hUserPetitionWndHelpHtmlCtrl;

function OnRegisterEvent()
{
    RegisterEvent(1921);
    RegisterEvent(1221);
    return;
}

function OnLoad()
{
    local int i;

    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    m_hUserPetitionWndHelpHtmlCtrl = GetHtmlHandle("UserPetitionWnd.HelpHtmlCtrl");
    i = 0;
    J0x3E:

    // End:0x97 [Loop If]
    if(i < PetitionCategoryCount)
    {
        Class'NWindow.UIAPI_COMBOBOX'.static.SYS_AddString("UserPetitionWnd.PetitionTypeComboBox", PetitionCategoryTitle[i]);
        ++i;
        // [Loop Continue]
        goto J0x3E;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 1921:
            HandleShowUserPetitionWnd(a_Param);
            // End:0x36
            break;
        // End:0x33
        case 1221:
            HandleLoadPetitionHtml(a_Param);
            // End:0x36
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleShowUserPetitionWnd(string a_Param)
{
    local string Message;

    m_hOwnerWnd.ShowWindow();
    m_hOwnerWnd.SetFocus();
    // End:0x71
    if(ParseString(a_Param, "Message", Message))
    {
        Class'NWindow.UIAPI_MULTIEDITBOX'.static.SetString("UserPetitionWnd.PetitionMultiEdit", Message);
    }
    return;
}

function HandleLoadPetitionHtml(string a_Param)
{
    local string HtmlString;

    ParseString(a_Param, "HtmlString", HtmlString);
    // End:0x3D
    if(Len(HtmlString) > 0)
    {
        m_hUserPetitionWndHelpHtmlCtrl.LoadHtmlFromString(HtmlString);
    }
    return;
}

function OnComboBoxItemSelected(string a_ControlID, int a_SelectedIndex)
{
    // End:0x68
    if(a_ControlID == "PetitionTypeComboBox")
    {
        // End:0x59
        if(a_SelectedIndex >= 1)
        {
            m_hUserPetitionWndHelpHtmlCtrl.LoadHtml("..\\L2text\\" $ PetitionCategoryLink[a_SelectedIndex - 1]);            
        }
        else
        {
            m_hUserPetitionWndHelpHtmlCtrl.Clear();
        }
    }
    return;
}

function OnClickButton(string a_ControlID)
{
    switch(a_ControlID)
    {
        // End:0x1D
        case "OKButton":
            OnClickOKButton();
            // End:0x3A
            break;
        // End:0x37
        case "CancelButton":
            OnClickCancelButton();
            // End:0x3A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickOKButton()
{
    local string PetitionMessage;
    local int PetitionMessageLen, PetitionType;
    local string param;
    local PetitionWnd PetitionWndScript;

    PetitionType = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("UserPetitionWnd.PetitionTypeComboBox");
    PetitionMessage = Class'NWindow.UIAPI_MULTIEDITBOX'.static.GetString("UserPetitionWnd.PetitionMultiEdit");
    PetitionMessageLen = Len(PetitionMessage);
    // End:0xA6
    if(0 == PetitionType)
    {
        DialogShow(1, 1, GetSystemMessage(804), string(self));        
    }
    else
    {
        // End:0xCD
        if(5 > PetitionMessageLen)
        {
            DialogShow(1, 1, GetSystemMessage(386), string(self));            
        }
        else
        {
            // End:0xF7
            if(800 <= PetitionMessageLen)
            {
                DialogShow(1, 1, GetSystemMessage(971), string(self));                
            }
            else
            {
                Class'NWindow.PetitionAPI'.static.RequestPetition(PetitionMessage, PetitionType);
                Clear();
                HideWindow("UserPetitionWnd");
                PetitionWndScript = PetitionWnd(GetScript("PetitionWnd"));
                // End:0x206
                if(none != PetitionWndScript)
                {
                    PetitionWndScript.Clear();
                    ParamAdd(param, "Message", (GetSystemString(708) $ " : ") $ PetitionMessage);
                    ParamAdd(param, "ColorR", "220");
                    ParamAdd(param, "ColorG", "220");
                    ParamAdd(param, "ColorB", "220");
                    ParamAdd(param, "ColorA", "255");
                    PetitionWndScript.HandlePetitionChatMessage(param);
                }
            }
        }
    }
    return;
}

function OnClickCancelButton()
{
    Class'NWindow.PetitionAPI'.static.RequestPetitionCancel();
    Clear();
    HideWindow("UserPetitionWnd");
    return;
}

function Clear()
{
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("UserPetitionWnd.PetitionTypeComboBox", 0);
    Class'NWindow.UIAPI_MULTIEDITBOX'.static.SetString("UserPetitionWnd.PetitionMultiEdit", "");
    m_hUserPetitionWndHelpHtmlCtrl.super(UserPetitionWnd).Clear();
    return;
}

defaultproperties
{
    PetitionCategoryCount=9
    PetitionCategoryTitle[0]=696
    PetitionCategoryTitle[1]=697
    PetitionCategoryTitle[2]=698
    PetitionCategoryTitle[3]=699
    PetitionCategoryTitle[4]=700
    PetitionCategoryTitle[5]=701
    PetitionCategoryTitle[6]=702
    PetitionCategoryTitle[7]=703
    PetitionCategoryTitle[8]=704
    PetitionCategoryLink[0]="pet_help_move.htm"
    PetitionCategoryLink[1]="pet_help_recover.htm"
    PetitionCategoryLink[2]="pet_help_bug.htm"
    PetitionCategoryLink[3]="pet_help_quest.htm"
    PetitionCategoryLink[4]="pet_help_report.htm"
    PetitionCategoryLink[5]="pet_help_suggest.htm"
    PetitionCategoryLink[6]="pet_help_game.htm"
    PetitionCategoryLink[7]="pet_help_oprn.htm"
    PetitionCategoryLink[8]="pet_help_etc.htm"
}