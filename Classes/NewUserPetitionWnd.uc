class NewUserPetitionWnd extends UICommonAPI;

const MAX_PetitionCategory = 100;

var ComboBoxHandle m_hFirstCategory;
var ComboBoxHandle m_hSecondCategory;
var HtmlHandle m_hDescriptionViewer;
var HtmlHandle m_hHtmlViewer;
var HtmlHandle m_hContentsViewer;
var WindowHandle Drawer;
var WindowHandle Me;
var int selectedCategoryId;
var string StartHtml;
var string EndHtml;

function OnRegisterEvent()
{
    RegisterEvent(4800);
    RegisterEvent(4810);
    RegisterEvent(4820);
    RegisterEvent(4830);
    RegisterEvent(4850);
    RegisterEvent(4840);
    return;
}

function OnLoad()
{
    selectedCategoryId = 0;
    OnRegisterEvent();
    Me = GetWindowHandle("NewUserPetitionWnd");
    Drawer = GetWindowHandle("NewUserPetitionDrawerWnd");
    m_hFirstCategory = GetComboBoxHandle("NewUserPetitionWnd.PetitionTypeComboBox_1st");
    m_hSecondCategory = GetComboBoxHandle("NewUserPetitionWnd.PetitionTypeComboBox_2nd");
    m_hDescriptionViewer = GetHtmlHandle("NewUserPetitionWnd.HelpDialogHtmlCtrl");
    m_hHtmlViewer = GetHtmlHandle("NewUserPetitionWnd.HelpHtmlCtrl");
    m_hContentsViewer = GetHtmlHandle("NewUserPetitionDrawerWnd.ContentsTextBox");
    m_hSecondCategory.DisableWindow();
    StartHtml = "<HTML><HEAD><BODY>";
    EndHtml = "</BODY></HTML>";
    return;
}

function OnHide()
{
    Clear();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x18
        case 4800:
            HandleShowNewUserPetitionWnd();
            // End:0x89
            break;
        // End:0x2E
        case 4810:
            HandleAddNewCategoryStepOne(a_Param);
            // End:0x89
            break;
        // End:0x44
        case 4820:
            HandleShowDescription(a_Param);
            // End:0x89
            break;
        // End:0x5A
        case 4830:
            HandleAddNewCategoryStepTwo(a_Param);
            // End:0x89
            break;
        // End:0x70
        case 4850:
            HandleLoadPetitionHtml(a_Param);
            // End:0x89
            break;
        // End:0x86
        case 4840:
            HandleShowNewUserPetitionContents(a_Param);
            // End:0x89
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleShowNewUserPetitionWnd()
{
    Clear();
    m_hOwnerWnd.ShowWindow();
    m_hOwnerWnd.SetFocus();
    m_hHtmlViewer.LoadHtml("..\\L2text\\newpet_help_main.htm");
    return;
}

function HandleAddNewCategoryStepOne(string a_Param)
{
    local int categoryId;
    local string categoryName;

    ParseInt(a_Param, "CategoryId_", categoryId);
    ParseString(a_Param, "CategoryName_", categoryName);
    m_hFirstCategory.AddStringWithReserved(categoryName, categoryId);
    return;
}

function HandleAddNewCategoryStepTwo(string a_Param)
{
    local int categoryId;
    local string categoryName;

    ParseInt(a_Param, "CategoryId_", categoryId);
    ParseString(a_Param, "CategoryName_", categoryName);
    m_hSecondCategory.AddStringWithReserved(categoryName, categoryId);
    return;
}

function HandleShowDescription(string a_Param)
{
    local int Num;
    local string categoryDescription;

    ParseInt(a_Param, "Count", Num);
    // End:0x50
    if(Num > 0)
    {
        m_hSecondCategory.EnableWindow();
        DialogShow(1, 1, GetSystemMessage(2992), string(self));
        selectedCategoryId = 0;
    }
    ParseString(a_Param, "CategoryDescription", categoryDescription);
    m_hDescriptionViewer.LoadHtmlFromString((StartHtml $ categoryDescription) $ EndHtml);
    return;
}

function HandleLoadPetitionHtml(string a_Param)
{
    local string HtmlString;

    ParseString(a_Param, "HtmlString", HtmlString);
    // End:0x4C
    if(Len(HtmlString) > 0)
    {
        m_hHtmlViewer.Clear();
        m_hHtmlViewer.LoadHtmlFromString(HtmlString);
    }
    return;
}

function HandleShowNewUserPetitionContents(string a_Param)
{
    local string ContentsString;

    m_hContentsViewer.Clear();
    ParseString(a_Param, "Contents", ContentsString);
    m_hContentsViewer.LoadHtmlFromString((StartHtml $ ContentsString) $ EndHtml);
    Drawer.ShowWindow();
    return;
}

function OnComboBoxItemSelected(string a_ControlID, int a_SelectedIndex)
{
    local int passingCategoryId;

    // End:0x1D4
    if(a_ControlID == "PetitionTypeComboBox_1st")
    {
        Drawer.HideWindow();
        m_hSecondCategory.DisableWindow();
        // End:0x115
        if(a_SelectedIndex >= 1)
        {
            m_hSecondCategory.Clear();
            m_hSecondCategory.AddStringWithReserved(GetSystemString(2024), 100);
            Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("NewUserPetitionWnd.PetitionTypeComboBox_2nd", 0);
            m_hDescriptionViewer.Clear();
            m_hHtmlViewer.Clear();
            passingCategoryId = m_hFirstCategory.GetReserved(a_SelectedIndex);
            selectedCategoryId = m_hFirstCategory.GetReserved(a_SelectedIndex);
            RequestShowStepTwo(passingCategoryId);            
        }
        else
        {
            selectedCategoryId = 0;
            m_hSecondCategory.Clear();
            m_hSecondCategory.AddStringWithReserved(GetSystemString(2024), 100);
            Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("NewUserPetitionWnd.PetitionTypeComboBox_2nd", 0);
            m_hDescriptionViewer.Clear();
            m_hHtmlViewer.Clear();
            m_hHtmlViewer.LoadHtml("..\\L2text\\newpet_help_main.htm");
        }        
    }
    else
    {
        // End:0x2A8
        if(a_ControlID == "PetitionTypeComboBox_2nd")
        {
            Drawer.HideWindow();
            // End:0x263
            if(a_SelectedIndex >= 1)
            {
                m_hHtmlViewer.Clear();
                passingCategoryId = m_hSecondCategory.GetReserved(a_SelectedIndex);
                selectedCategoryId = m_hSecondCategory.GetReserved(a_SelectedIndex);
                RequestShowStepThree(passingCategoryId);                
            }
            else
            {
                selectedCategoryId = 0;
                m_hHtmlViewer.Clear();
                m_hHtmlViewer.LoadHtml("..\\L2text\\newpet_help_main.htm");
            }
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
            // End:0x86
            break;
        // End:0x37
        case "CancelButton":
            OnClickCancelButton();
            // End:0x86
            break;
        // End:0x80
        case "DrawerCloseButton":
            // End:0x7D
            if(Drawer.IsShowWindow())
            {
                m_hContentsViewer.Clear();
                Drawer.HideWindow();
            }
            // End:0x86
            break;
        // End:0xFFFF
        default:
            // End:0x86
            break;
            break;
    }
    return;
}

function OnClickOKButton()
{
    local WindowHandle NewPetitionWndHandle;
    local NewPetitionWnd NewPetitionWndScript;

    // End:0x2F
    if(!Drawer.IsShowWindow())
    {
        DialogShow(1, 5, GetSystemMessage(804), string(self));        
    }
    else
    {
        NewPetitionWndHandle = GetWindowHandle("NewPetitionWnd");
        NewPetitionWndScript = NewPetitionWnd(GetScript("NewPetitionWnd"));
        NewPetitionWndScript.SetCategoryId(selectedCategoryId);
        NewPetitionWndHandle.ShowWindow();
        Clear();
        Me.HideWindow();
    }
    return;
}

function OnClickCancelButton()
{
    Clear();
    HideWindow("NewUserPetitionWnd");
    return;
}

function Clear()
{
    m_hFirstCategory.super(NewUserPetitionWnd).Clear();
    m_hSecondCategory.super(NewUserPetitionWnd).Clear();
    m_hSecondCategory.DisableWindow();
    m_hFirstCategory.AddStringWithReserved(GetSystemString(2024), 100);
    m_hSecondCategory.AddStringWithReserved(GetSystemString(2024), 100);
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("NewUserPetitionWnd.PetitionTypeComboBox_1st", 0);
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("NewUserPetitionWnd.PetitionTypeComboBox_2nd", 0);
    m_hDescriptionViewer.super(NewUserPetitionWnd).Clear();
    m_hContentsViewer.super(NewUserPetitionWnd).Clear();
    m_hHtmlViewer.super(NewUserPetitionWnd).Clear();
    Drawer.HideWindow();
    selectedCategoryId = 0;
    return;
}
