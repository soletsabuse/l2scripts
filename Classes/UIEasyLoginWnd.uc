class UIEasyLoginWnd extends UICommonAPI;

const ACCOUNT_COUNT = 200;

var WindowHandle Me;
var ListCtrlHandle IDList;
var ButtonHandle loginButton;
var ButtonHandle addButton;
var ButtonHandle editButton;
var ButtonHandle delButton;
var ButtonHandle managerButton;
var TextBoxHandle descTxt;
var EditBoxHandle idEditBox;
var EditBoxHandle pwEditBox;
var EditBoxHandle labelEditBox;
var CheckBoxHandle showOnLoginScreenCheckBox;
var CheckBoxHandle hideLoginCheckBox;
var string lastKeyValue;
var bool isEditMode;
var string Password;

function OnRegisterEvent()
{
    RegisterEvent(5630);
    RegisterEvent(3410);
    return;
}

function OnLoad()
{
    RegisterState("LogIn", "LoginState");
    Initialize();
    return;
}

function OnShow()
{
    showOnLoginScreenCheckBox.SetCheck(getUseEasyLogin());
    hideLoginCheckBox.SetCheck(getHideLogin());
    loadListByINI();
    IDList.SetFocus();
    // End:0x60
    if(DebugSectorBool("debug", "autologin"))
    {
        OnLoginButtonClickHandler();
    }
    // End:0x86
    if((GetUIState()) != "LOGINSTATE")
    {
        Me.HideWindow();
    }
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x77
    if(int(nKey) == 9)
    {
        // End:0x32
        if(labelEditBox.IsFocused())
        {
            idEditBox.SetFocus();            
        }
        else
        {
            // End:0x56
            if(idEditBox.IsFocused())
            {
                pwEditBox.SetFocus();                
            }
            else
            {
                // End:0x77
                if(pwEditBox.IsFocused())
                {
                    labelEditBox.SetFocus();
                }
            }
        }
    }
    // End:0x85
    if(int(nKey) == 18)
    {
    }
    return;
}

function ToggleOpenMeWnd()
{
    return;
}

function OnCallUCFunction(string Id, string param)
{
    switch(Id)
    {
        // End:0x1E
        case "ToggleOpenMeWnd":
            // End:0x24
            break;
        // End:0xFFFF
        default:
            // End:0x24
            break;
            break;
    }
    return;
}

function GetSelectedRecord()
{
    local LVDataRecord Record;

    isEditMode = true;
    addButton.SetButtonName(658);
    IDList.GetSelectedRec(Record);
    idEditBox.SetString(Record.LVDataList[1].HiddenStringForSorting);
    pwEditBox.SetString(Record.LVDataList[1].szReserved);
    labelEditBox.SetString(Record.LVDataList[0].szData);
    labelEditBox.SetFocus();
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x18
    if(Event_ID == 5630)
    {
        checkAndShowEasyLogin();        
    }
    else
    {
        // End:0x85
        if((Event_ID == 3410) && DebugSectorBool("debug", "autologinshow"))
        {
            switch(param)
            {
                // End:0x70
                case "LoginState":
                    Me.ShowWindow();
                    // End:0x85
                    break;
                // End:0xFFFF
                default:
                    Me.HideWindow();
                    // End:0x85
                    break;
                    break;
            }
        }
    }
    return;
}

function Initialize()
{
    Me = GetWindowHandle("UIEasyLoginWnd");
    IDList = GetListCtrlHandle("UIEasyLoginWnd.idList");
    loginButton = GetButtonHandle("UIEasyLoginWnd.loginButton");
    addButton = GetButtonHandle("UIEasyLoginWnd.addButton");
    delButton = GetButtonHandle("UIEasyLoginWnd.delButton");
    managerButton = GetButtonHandle("UIEasyLoginWnd.managerButton");
    descTxt = GetTextBoxHandle("UIEasyLoginWnd.descTxt");
    idEditBox = GetEditBoxHandle("UIEasyLoginWnd.idEditBox");
    pwEditBox = GetEditBoxHandle("UIEasyLoginWnd.pwEditBox");
    labelEditBox = GetEditBoxHandle("UIEasyLoginWnd.labelEditBox");
    showOnLoginScreenCheckBox = GetCheckBoxHandle("UIEasyLoginWnd.showOnLoginScreenBox");
    hideLoginCheckBox = GetCheckBoxHandle("UIEasyLoginWnd.hideLoginCheckBox");
    Me.SetWindowTitle("auth");
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x20
        case "loginButton":
            OnLoginButtonClickHandler();
            // End:0x87
            break;
        // End:0x37
        case "addButton":
            OnAddButtonClickHandler();
            // End:0x87
            break;
        // End:0x4E
        case "delButton":
            OnDelButtonClickHandler();
            // End:0x87
            break;
        // End:0x69
        case "managerButton":
            OnManagerButtonClickHandler();
            // End:0x87
            break;
        // End:0x81
        case "editButton":
            GetSelectedRecord();
            // End:0x87
            break;
        // End:0xFFFF
        default:
            // End:0x87
            break;
            break;
    }
    return;
}

function OnChangeEditBox(string strID)
{
    local string __var46765;

    // End:0x2A
    if(strID == "pwEditBox")
    {
        Password = pwEditBox.GetString();
    }
    return;
}

function AddList(string Id, string pw, string Label)
{
    local int __var6867;
    local bool __var19684;
    local LVDataRecord tmpRecord, Record;

    __var6867 = 0;
    J0x07:

    // End:0x69 [Loop If]
    if(__var6867 < IDList.GetRecordCount())
    {
        IDList.GetRec(__var6867, tmpRecord);
        // End:0x5F
        if(tmpRecord.LVDataList[1].HiddenStringForSorting == Id)
        {
            __var19684 = true;
            // [Explicit Break]
            goto J0x69;
        }
        __var6867++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x69:

    Record.LVDataList.Length = 2;
    Record.LVDataList[0].szData = Label;
    Record.LVDataList[0].FirstLineOffsetX = 3;
    Record.LVDataList[1].szData = Id;
    Record.LVDataList[1].FirstLineOffsetX = 3;
    Record.LVDataList[1].HiddenStringForSorting = Id;
    Record.LVDataList[1].szReserved = pw;
    // End:0x120
    if(__var19684)
    {
        IDList.ModifyRecord(__var6867, Record);        
    }
    else
    {
        IDList.InsertRecord(Record);
    }
    // End:0x186
    if(isEditMode)
    {
        isEditMode = false;
        addButton.SetButtonName(654);
        idEditBox.Clear();
        pwEditBox.Clear();
        labelEditBox.Clear();
    }
    return;
}

function OnAddButtonClickHandler()
{
    local int __var46775;
    local LVDataRecord Record;

    // End:0x61
    if((idEditBox.GetString() != "") && pwEditBox.GetString() != "")
    {
        AddList(idEditBox.GetString(), pwEditBox.GetString(), labelEditBox.GetString());
    }
    writeIniFull();
    return;
}

function OnEditButtonClickHandler()
{
    local int __var10609;
    local LVDataRecord Record;

    __var10609 = IDList.GetSelectedIndex();
    IDList.GetRec(__var10609, Record);
    IDList.DeleteRecord(__var10609);
    AddList(idEditBox.GetString(), pwEditBox.GetString(), labelEditBox.GetString());
    writeIniFull();
    loadListByINI();
    IDList.SetSelectedIndex(IDList.GetRecordCount(), true);
    return;
}

function OnDelButtonClickHandler()
{
    local int idx;

    idx = IDList.GetSelectedIndex();
    // End:0x3E
    if(idx > -1)
    {
        IDList.DeleteRecord(idx);
        writeIniFull();
    }
    return;
}

function OnManagerButtonClickHandler(optional bool bUseBasicUI)
{
    local int W, h;

    Me.GetWindowSize(W, h);
    // End:0x182
    if((W > 400) || bUseBasicUI)
    {
        Me.SetWindowSize(240, 377);
        descTxt.HideWindow();
        addButton.HideWindow();
        idEditBox.HideWindow();
        pwEditBox.HideWindow();
        labelEditBox.HideWindow();
        GetTextBoxHandle("UIEasyLoginWnd.idTxt").HideWindow();
        GetTextBoxHandle("UIEasyLoginWnd.pwTxt").HideWindow();
        GetTextBoxHandle("UIEasyLoginWnd.labelTxt").HideWindow();
        GetTextBoxHandle("UIEasyLoginWnd.descTxt").HideWindow();
        GetTextureHandle("UIEasyLoginWnd.ListBG1").HideWindow();
        showOnLoginScreenCheckBox.HideWindow();
        hideLoginCheckBox.HideWindow();
        isEditMode = false;        
    }
    else
    {
        Me.SetWindowSize(580, 377);
        descTxt.ShowWindow();
        addButton.ShowWindow();
        idEditBox.ShowWindow();
        pwEditBox.ShowWindow();
        labelEditBox.ShowWindow();
        GetTextBoxHandle("UIEasyLoginWnd.idTxt").ShowWindow();
        GetTextBoxHandle("UIEasyLoginWnd.pwTxt").ShowWindow();
        GetTextBoxHandle("UIEasyLoginWnd.labelTxt").ShowWindow();
        GetTextBoxHandle("UIEasyLoginWnd.descTxt").ShowWindow();
        GetTextureHandle("UIEasyLoginWnd.ListBG1").ShowWindow();
        showOnLoginScreenCheckBox.ShowWindow();
        hideLoginCheckBox.ShowWindow();
        isEditMode = true;
    }
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x38
        case "showOnLoginScreenBox":
            setUseEasyLogin(showOnLoginScreenCheckBox.IsChecked());
            // End:0x72
            break;
        // End:0x6C
        case "hideLoginCheckBox":
            setHideLogin(hideLoginCheckBox.IsChecked());
            loadListByINI();
            // End:0x72
            break;
        // End:0xFFFF
        default:
            // End:0x72
            break;
            break;
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    // End:0x18
    if(ListCtrlID == "idList")
    {
        OnLoginButtonClickHandler();
    }
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    return;
}

function setUseEasyLogin(bool flag)
{
    SetINIString("L2_EASYLOGIN", "showOnStart", string(boolToNum(flag)), "../auth.ini");
    return;
}

function bool getUseEasyLogin()
{
    local string stringValue;

    GetINIString("L2_EASYLOGIN", "showOnStart", stringValue, "../auth.ini");
    return numToBool(int(stringValue));
    return;
}

function setHideLogin(bool flag)
{
    SetINIString("L2_EASYLOGIN", "hideLogin", string(boolToNum(flag)), "../auth.ini");
    return;
}

function bool getHideLogin()
{
    local string __var19499;

    GetINIString("L2_EASYLOGIN", "hideLogin", __var19499, "../auth.ini");
    return numToBool(int(__var19499));
    return;
}

function OnLoginButtonClickHandler()
{
    local LVDataRecord Record;

    IDList.GetSelectedRec(Record);
    // End:0xCD
    if(Record.LVDataList[1].HiddenStringForSorting != "")
    {
        Login(GetScript("LogIn")).OnCallUCFunction("setLogin", ((("ID=" $ Record.LVDataList[1].HiddenStringForSorting) $ " ") $ "pass=") $ Record.LVDataList[1].szReserved);
        SetINIString("L2_EASYLOGIN", "lastLoginIndex", string(IDList.GetSelectedIndex()), "../auth.ini");
    }
    return;
}

function checkAndShowEasyLogin()
{
    return;
}

function writeIniFull()
{
    local string __var9583, __var9569, __var9557;
    local int __var3566;
    local LVDataRecord Record;

    __var3566 = 1;
    J0x07:

    // End:0x175 [Loop If]
    if(__var3566 < 200)
    {
        __var9583 = "";
        __var9569 = "";
        __var9557 = "";
        // End:0xA8
        if(IDList.GetRecordCount() >= __var3566)
        {
            IDList.GetRec(__var3566 - 1, Record);
            __var9583 = Record.LVDataList[1].HiddenStringForSorting;
            __var9569 = Record.LVDataList[1].szReserved;
            __var9557 = Record.LVDataList[0].szData;            
        }
        else
        {
            __var9583 = "";
            __var9569 = "";
            __var9557 = "";
        }
        SetINIString("L2_EASYLOGIN", string(__var3566) $ "_id", __var9583, "../auth.ini");
        SetINIString("L2_EASYLOGIN", string(__var3566) $ "_password", __var9569, "../auth.ini");
        SetINIString("L2_EASYLOGIN", string(__var3566) $ "_description", __var9557, "../auth.ini");
        __var3566++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function loadListByINI()
{
    local string Id, pw, __var10739, listIndex;
    local int i;

    IDList.DeleteAllItem();
    i = 1;
    J0x16:

    // End:0x11E [Loop If]
    if(i < 200)
    {
        Id = "";
        pw = "";
        __var10739 = "";
        GetINIString("L2_EASYLOGIN", string(i) $ "_id", Id, "../auth.ini");
        GetINIString("L2_EASYLOGIN", string(i) $ "_password", pw, "../auth.ini");
        GetINIString("L2_EASYLOGIN", string(i) $ "_description", __var10739, "../auth.ini");
        // End:0x114
        if((Id != "") && pw != "")
        {
            AddList(Id, pw, __var10739);
        }
        i++;
        // [Loop Continue]
        goto J0x16;
    }
    GetINIString("L2_EASYLOGIN", "lastLoginIndex", listIndex, "../auth.ini");
    IDList.SetSelectedIndex(int(listIndex), true);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
