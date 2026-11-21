class BR_CashShopReceiverListAddWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle BtnAdd;
var ButtonHandle btnCancel;
var EditBoxHandle eName;
var TextBoxHandle Description;
var TextureHandle GroupBox;
var bool bOpenCashShopReceiverListAddWnd;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    Initialize();
    load();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("BR_CashShopReceiverListAddWnd");
    BtnAdd = GetButtonHandle("BR_CashShopReceiverListAddWnd.BtnAdd");
    btnCancel = GetButtonHandle("BR_CashShopReceiverListAddWnd.BtnCancel");
    eName = GetEditBoxHandle("BR_CashShopReceiverListAddWnd.Name");
    Description = GetTextBoxHandle("BR_CashShopReceiverListAddWnd.Description");
    GroupBox = GetTextureHandle("BR_CashShopReceiverListAddWnd.GroupBox");
    return;
}

function load()
{
    return;
}

function OnHide()
{
    local BR_NewCashShopReceiverListWnd script;

    script = BR_NewCashShopReceiverListWnd(GetScript("BR_NewCashShopReceiverListWnd"));
    script.selectedInit();
    script.EnableTab();
    eName.SetString("");
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1B
        case "BtnAdd":
            OnBtnAddClick();
            // End:0x35
            break;
        // End:0x32
        case "BtnCancel":
            OnbtnCancelClick();
            // End:0x35
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnBtnAddClick()
{
    local UserInfo UserInfo;
    local string Username, AddName;

    AddName = eName.GetString();
    // End:0x33
    if(GetPlayerInfo(UserInfo))
    {
        Username = UserInfo.Name;
    }
    // End:0xD0
    if(eName.GetString() != "")
    {
        // End:0x73
        if(Username == AddName)
        {
            DialogShow(1, 5, GetSystemMessage(3221), string(self));            
        }
        else
        {
            // End:0x9C
            if(SearchPostFriend(AddName))
            {
                DialogShow(1, 5, GetSystemMessage(3216), string(self));                
            }
            else
            {
                Class'NWindow.PostWndAPI'.static.RequestAddingPostFriend(AddName);
                Me.HideWindow();
            }
            eName.SetString("");
        }
    }
    return;
}

function bool SearchPostFriend(string S)
{
    local int i, Count;
    local LVDataRecord Record;
    local ListCtrlHandle AddList;

    AddList = GetListCtrlHandle("BR_NewCashShopReceiverListWnd.BR_NewCashShopReceiverListWnd_Add.AddList");
    Count = Class'NWindow.UIAPI_LISTCTRL'.static.GetRecordCount("BR_NewCashShopReceiverListWnd.AddList");
    i = 0;
    J0x98:

    // End:0xE7 [Loop If]
    if(i < Count)
    {
        AddList.GetRec(i, Record);
        // End:0xDD
        if(S == Record.LVDataList[0].szData)
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x98;
    }
    return false;
    return;
}

function OnbtnCancelClick()
{
    local BR_NewCashShopReceiverListWnd script;

    script = BR_NewCashShopReceiverListWnd(GetScript("BR_NewCashShopReceiverListWnd"));
    script.selectedInit();
    script.EnableTab();
    Me.HideWindow();
    eName.SetString("");
    return;
}
