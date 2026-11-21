class PostReceiverListAddWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle BtnAdd;
var ButtonHandle btnCancel;
var EditBoxHandle eName;
var TextBoxHandle Description;
var TextureHandle GroupBox;
var bool bOpenPostReceiverListAddWnd;

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
    Me = GetWindowHandle("PostReceiverListAddWnd");
    BtnAdd = GetButtonHandle("PostReceiverListAddWnd.BtnAdd");
    btnCancel = GetButtonHandle("PostReceiverListAddWnd.BtnCancel");
    eName = GetEditBoxHandle("PostReceiverListAddWnd.Name");
    Description = GetTextBoxHandle("PostReceiverListAddWnd.Description");
    GroupBox = GetTextureHandle("PostReceiverListAddWnd.GroupBox");
    return;
}

function load()
{
    return;
}

function OnHide()
{
    local PostReceiverListWnd script;

    script = PostReceiverListWnd(GetScript("PostReceiverListWnd"));
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

    AddList = GetListCtrlHandle("PostReceiverListWnd.PostReceiverListWnd_Add.AddList");
    Count = Class'NWindow.UIAPI_LISTCTRL'.static.GetRecordCount("PostReceiverListWnd.AddList");
    i = 0;
    J0x7A:

    // End:0xCD [Loop If]
    if(i < Count)
    {
        AddList.GetRec(i, Record);
        // End:0xC3
        if(Caps(S) == Caps(Record.LVDataList[0].szData))
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x7A;
    }
    return false;
    return;
}

function OnbtnCancelClick()
{
    local PostReceiverListWnd script;

    script = PostReceiverListWnd(GetScript("PostReceiverListWnd"));
    script.selectedInit();
    script.EnableTab();
    Me.HideWindow();
    eName.SetString("");
    return;
}
