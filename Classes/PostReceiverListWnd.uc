class PostReceiverListWnd extends UICommonAPI;

const DIALOGID_DelFriend = 1;
const DIALOGID_ErrorFriend = 2;
const MAX_FRIEND = 128;
const MAX_PLEDGE = 220;
const MAX_POSTFRIEND = 100;
const FRIEND_TAB = 0;
const PLEDGE_TAB = 1;
const POSTFRIEND_TAB = 2;

var string m_WindowName;
var WindowHandle Me;
var TextBoxHandle Description;
var TextureHandle DescriptionGroupBox;
var TextBoxHandle ListCount;
var TabHandle TabCtrl;
var TextureHandle ListGroupBox;
var TextureHandle TabLineTop;
var TextureHandle tabBg;
var WindowHandle PostReceiverListWnd_Friends;
var ListCtrlHandle FriendsList;
var TextureHandle FriendsListDeco;
var WindowHandle PostReceiverListWnd_Clan;
var ListCtrlHandle ClanList;
var TextureHandle ClanListDeco;
var WindowHandle PostReceiverListWnd_Add;
var ListCtrlHandle AddList;
var ButtonHandle Btn_Add;
var ButtonHandle Btn_Del;
var TextureHandle AddListGroupBoxLine;
var TextureHandle AddListDeco;
var ButtonHandle CloseButton;
var WindowHandle PostReceiverListAddWnd;
var int m_selectedTab;
var string countFriend;
var string countPledge;
var string countPostFriend;
var string selectFriend;
var int NumPostFriend;
var bool bPostFriendSelect;

function OnRegisterEvent()
{
    RegisterEvent(4970);
    RegisterEvent(5000);
    RegisterEvent(4990);
    RegisterEvent(4980);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(5040);
    RegisterEvent(40);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    load();
    m_selectedTab = 0;
    selectedInit();
    return;
}

function selectedInit()
{
    selectFriend = "";
    bPostFriendSelect = false;
    return;
}

function Initialize()
{
    Me = GetWindowHandle("PostReceiverListWnd");
    Description = GetTextBoxHandle("PostReceiverListWnd.Description");
    DescriptionGroupBox = GetTextureHandle("PostReceiverListWnd.DescriptionGroupBox");
    ListCount = GetTextBoxHandle("PostReceiverListWnd.ListCount");
    TabCtrl = GetTabHandle("PostReceiverListWnd.TabCtrl");
    ListGroupBox = GetTextureHandle("PostReceiverListWnd.ListGroupBox");
    TabLineTop = GetTextureHandle("PostReceiverListWnd.TabLineTop");
    tabBg = GetTextureHandle("PostReceiverListWnd.tabBg");
    PostReceiverListWnd_Friends = GetWindowHandle("PostReceiverListWnd.PostReceiverListWnd_Friends");
    FriendsList = GetListCtrlHandle("PostReceiverListWnd.PostReceiverListWnd_Friends.FriendsList");
    FriendsListDeco = GetTextureHandle("PostReceiverListWnd.PostReceiverListWnd_Friends.FriendsListDeco");
    PostReceiverListWnd_Clan = GetWindowHandle("PostReceiverListWnd.PostReceiverListWnd_Clan");
    ClanList = GetListCtrlHandle("PostReceiverListWnd.PostReceiverListWnd_Clan.ClanList");
    ClanListDeco = GetTextureHandle("PostReceiverListWnd.PostReceiverListWnd_Clan.ClanListDeco");
    PostReceiverListWnd_Add = GetWindowHandle("PostReceiverListWnd.PostReceiverListWnd_Add");
    AddList = GetListCtrlHandle("PostReceiverListWnd.PostReceiverListWnd_Add.AddList");
    Btn_Add = GetButtonHandle("PostReceiverListWnd.PostReceiverListWnd_Add.Btn_Add");
    Btn_Del = GetButtonHandle("PostReceiverListWnd.PostReceiverListWnd_Add.Btn_Del");
    AddListGroupBoxLine = GetTextureHandle("PostReceiverListWnd.PostReceiverListWnd_Add.AddListGroupBoxLine");
    AddListDeco = GetTextureHandle("PostReceiverListWnd.PostReceiverListWnd_Add.AddListDeco");
    CloseButton = GetButtonHandle("PostReceiverListWnd.CloseButton");
    PostReceiverListAddWnd = GetWindowHandle("PostReceiverListAddWnd");
    return;
}

function load()
{
    return;
}

function OnShow()
{
    SetCount(m_selectedTab);
    Btn_Del.DisableWindow();
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1C
        case "Btn_Add":
            OnBtn_AddClick();
            // End:0x92
            break;
        // End:0x31
        case "Btn_Del":
            OnBtn_DelClick();
            // End:0x92
            break;
        // End:0x4A
        case "CloseButton":
            OnCloseButtonClick();
            // End:0x92
            break;
        // End:0x60
        case "TabCtrl0":
            setFriendCount();
            // End:0x92
            break;
        // End:0x76
        case "TabCtrl1":
            setPledgeCount();
            // End:0x92
            break;
        // End:0x8C
        case "TabCtrl2":
            setPostFrienddCount();
            // End:0x92
            break;
        // End:0xFFFF
        default:
            // End:0x92
            break;
            break;
    }
    return;
}

function setFriendCount()
{
    m_selectedTab = 0;
    SetCount(m_selectedTab);
    return;
}

function setPledgeCount()
{
    m_selectedTab = 1;
    SetCount(m_selectedTab);
    return;
}

function setPostFrienddCount()
{
    m_selectedTab = 2;
    SetCount(m_selectedTab);
    return;
}

function SetCount(int Count)
{
    switch(Count)
    {
        // End:0x22
        case 0:
            ListCount.SetText(countFriend);
            // End:0x5F
            break;
        // End:0x3D
        case 1:
            ListCount.SetText(countPledge);
            // End:0x5F
            break;
        // End:0x59
        case 2:
            ListCount.SetText(countPostFriend);
            // End:0x5F
            break;
        // End:0xFFFF
        default:
            // End:0x5F
            break;
            break;
    }
    return;
}

function OnBtn_AddClick()
{
    DisableTab();
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("PostReceiverListAddWnd.Name", "");
    PostReceiverListAddWnd.ShowWindow();
    PostReceiverListAddWnd.SetFocus();
    return;
}

function DisableTab()
{
    local ButtonHandle sendBtn;

    sendBtn = GetButtonHandle("PostWriteWnd.SendBtn");
    sendBtn.DisableWindow();
    AddList.DisableWindow();
    TabCtrl.DisableWindow();
    Btn_Add.DisableWindow();
    Btn_Del.DisableWindow();
    CloseButton.DisableWindow();
    return;
}

function EnableTab()
{
    local ButtonHandle sendBtn;

    sendBtn = GetButtonHandle("PostWriteWnd.SendBtn");
    sendBtn.EnableWindow();
    TabCtrl.EnableWindow();
    AddList.EnableWindow();
    Btn_Add.EnableWindow();
    // End:0x76
    if(bPostFriendSelect)
    {
        Btn_Del.EnableWindow();
    }
    CloseButton.EnableWindow();
    return;
}

function OnBtn_DelClick()
{
    // End:0x3E
    if(selectFriend != "")
    {
        DisableTab();
        DialogSetID(1);
        DialogShow(1, 0, MakeFullSystemMsg(GetSystemMessage(3218), selectFriend, ""), string(self));
    }
    return;
}

function HandleDialogOK()
{
    // End:0x50
    if(DialogIsMine())
    {
        switch(DialogGetID())
        {
            // End:0x33
            case 1:
                EnableTab();
                Btn_Del.DisableWindow();
                DeletePostFriend();
                // End:0x4D
                break;
            // End:0x41
            case 2:
                EnableTab();
                // End:0x4D
                break;
            // End:0xFFFF
            default:
                EnableTab();
                // End:0x4D
                break;
                break;
        }        
    }
    else
    {
        EnableTab();
    }
    return;
}

function HandleDialogCancel()
{
    // End:0x38
    if(DialogIsMine())
    {
        switch(DialogGetID())
        {
            // End:0x29
            case 1:
                EnableTab();
                AddSystemMessage(3220);
                // End:0x35
                break;
            // End:0xFFFF
            default:
                EnableTab();
                // End:0x35
                break;
                break;
        }        
    }
    else
    {
        EnableTab();
    }
    return;
}

function DeletePostFriend()
{
    local int __var15428;

    NumPostFriend = NumPostFriend - 1;
    countPostFriend = ((("(" $ string(NumPostFriend)) $ "/") $ string(100)) $ ") ";
    SetCount(2);
    __var15428 = AddList.GetSelectedIndex();
    AddList.DeleteRecord(__var15428);
    Class'NWindow.PostWndAPI'.static.RequestDeletingPostFriend(selectFriend);
    Class'NWindow.PostWndAPI'.static.RequestPostFriendList();
    selectedInit();
    return;
}

function OnCloseButtonClick()
{
    local PostWriteWnd script;

    script = PostWriteWnd(GetScript("PostWriteWnd"));
    script.SetBoolPostReceiverList(false);
    HandleRestart();
    Me.HideWindow();
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x2C
        case 4970:
            FriendsList.DeleteAllItem();
            HandleReceiveFriendList(param);
            // End:0xD8
            break;
        // End:0x51
        case 5000:
            ClanList.DeleteAllItem();
            HandleReceivePledgeMemberList(param);
            // End:0xD8
            break;
        // End:0x76
        case 4990:
            AddList.DeleteAllItem();
            HandleReceivePostFriendList(param);
            // End:0xD8
            break;
        // End:0x8C
        case 4980:
            HandleConfirmAddingPostFriend(param);
            // End:0xD8
            break;
        // End:0x9D
        case 1710:
            HandleDialogOK();
            // End:0xD8
            break;
        // End:0xAE
        case 1720:
            HandleDialogCancel();
            // End:0xD8
            break;
        // End:0xC4
        case 5040:
            HandleListCtrlLose(param);
            // End:0xD8
            break;
        // End:0xD2
        case 40:
            HandleRestart();
            // End:0xD8
            break;
        // End:0xFFFF
        default:
            // End:0xD8
            break;
            break;
    }
    return;
}

function HandleRestart()
{
    selectFriend = "";
    bPostFriendSelect = false;
    return;
}

function HandleReceiveFriendList(string param)
{
    local int __var13177, __var4126;
    local string __var13182;
    local int __var7585, __var15406;
    local LVDataRecord Record;
    local EditBoxHandle e_handle;
    local array<string> AddName;

    e_handle = GetEditBoxHandle("PostWriteWnd.ReceiverID");
    ParseInt(param, "Num", __var13177);
    countFriend = ((("(" $ string(__var13177)) $ "/") $ string(128)) $ ") ";
    __var4126 = 0;
    J0x64:

    // End:0x1EA [Loop If]
    if(__var4126 < __var13177)
    {
        ParseString(param, "Name" $ string(__var4126), __var13182);
        ParseInt(param, "FriendClass" $ string(__var4126), __var7585);
        ParseInt(param, "FriendLevel" $ string(__var4126), __var15406);
        AddName[__var4126] = __var13182;
        Record.LVDataList.Length = 3;
        Record.LVDataList[0].szData = __var13182;
        Record.LVDataList[1].szTexture = GetClassRoleIconName(__var7585);
        Record.LVDataList[1].nTextureWidth = 11;
        Record.LVDataList[1].nTextureHeight = 11;
        Record.LVDataList[1].szData = string(__var7585);
        Record.LVDataList[1].HiddenStringForSorting = string(GetClassRoleType(__var7585));
        Record.LVDataList[2].szData = string(__var15406);
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("PostReceiverListWnd.FriendsList", Record);
        __var4126++;
        // [Loop Continue]
        goto J0x64;
    }
    e_handle.FillAdditionalSearchList(AddName, 0);
    SetCount(m_selectedTab);
    return;
}

function HandleReceivePledgeMemberList(string param)
{
    local int __var13196, __var4132;
    local string __var4829;
    local int __var7609, __var15334;
    local LVDataRecord Record;
    local EditBoxHandle e_handle;
    local array<string> AddName, nameTime;

    e_handle = GetEditBoxHandle("PostWriteWnd.ReceiverID");
    ParseInt(param, "Num", __var13196);
    countPledge = ((("(" $ string(__var13196)) $ "/") $ string(220)) $ ") ";
    __var4132 = 0;
    J0x64:

    // End:0x232 [Loop If]
    if(__var4132 < __var13196)
    {
        ParseString(param, "Name" $ string(__var4132), __var4829);
        ParseInt(param, "FriendClass" $ string(__var4132), __var7609);
        ParseInt(param, "FriendLevel" $ string(__var4132), __var15334);
        // End:0x129
        if(InStr(__var4829, ";") > -1)
        {
            nameTime = Arr(__var4829, ";");
            __var4829 = nameTime[0];
            Record.nReserved2 = (int(nameTime[1]));
        }
        AddName[__var4132] = __var4829;
        Record.LVDataList.Length = 3;
        Record.LVDataList[0].szData = __var4829;
        Record.LVDataList[1].szTexture = GetClassRoleIconName(__var7609);
        Record.LVDataList[1].nTextureWidth = 11;
        Record.LVDataList[1].nTextureHeight = 11;
        Record.LVDataList[1].szData = string(__var7609);
        Record.LVDataList[1].HiddenStringForSorting = string(GetClassRoleType(__var7609));
        Record.LVDataList[2].szData = string(__var15334);
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("PostReceiverListWnd.ClanList", Record);
        __var4132++;
        // [Loop Continue]
        goto J0x64;
    }
    e_handle.FillAdditionalSearchList(AddName, 1);
    SetCount(m_selectedTab);
    return;
}

function HandleReceivePostFriendList(string param)
{
    local int __var13304, __var7434;
    local string __var13306;
    local LVDataRecord Record;
    local EditBoxHandle e_handle;
    local array<string> AddName;

    e_handle = GetEditBoxHandle("PostWriteWnd.ReceiverID");
    ParseInt(param, "Num", __var13304);
    NumPostFriend = __var13304;
    countPostFriend = ((("(" $ string(NumPostFriend)) $ "/") $ string(100)) $ ") ";
    __var7434 = 0;
    J0x6F:

    // End:0x10D [Loop If]
    if(__var7434 < __var13304)
    {
        ParseString(param, "Name" $ string(__var7434), __var13306);
        AddName[__var7434] = __var13306;
        Record.LVDataList.Length = 1;
        Record.LVDataList[0].szData = __var13306;
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("PostReceiverListWnd.AddList", Record);
        __var7434++;
        // [Loop Continue]
        goto J0x6F;
    }
    e_handle.FillAdditionalSearchList(AddName, 2);
    SetCount(m_selectedTab);
    return;
}

function HandleConfirmAddingPostFriend(string param)
{
    local string __var15155;
    local int __var4171;

    ParseString(param, "Name", __var15155);
    ParseInt(param, "Result", __var4171);
    // End:0x51
    if(__var4171 == 1)
    {
        Class'NWindow.PostWndAPI'.static.RequestPostFriendList();
        EnableTab();        
    }
    else
    {
        // End:0x83
        if(__var4171 == -1)
        {
            DialogSetID(2);
            DialogShow(1, 5, GetSystemMessage(3223), string(self));            
        }
        else
        {
            // End:0xCF
            if((__var4171 == -2) || __var4171 == 0)
            {
                DialogSetID(2);
                DialogShow(1, 5, MakeFullSystemMsg(GetSystemMessage(3215), __var15155, ""), string(self));                
            }
            else
            {
                // End:0x101
                if(__var4171 == -3)
                {
                    DialogSetID(2);
                    DialogShow(1, 5, GetSystemMessage(3222), string(self));                    
                }
                else
                {
                    // End:0x133
                    if(__var4171 == -4)
                    {
                        DialogSetID(2);
                        DialogShow(1, 5, GetSystemMessage(3216), string(self));                        
                    }
                    else
                    {
                        DialogSetID(2);
                        DialogShow(1, 5, GetSystemMessage(3217), string(self));
                    }
                }
            }
        }
    }
    return;
}

function HandleListCtrlLose(string param)
{
    local string __var15153;

    ParseString(param, "ListCtrlName", __var15153);
    // End:0x4E
    if(__var15153 == AddList.GetWindowName())
    {
        bPostFriendSelect = false;
        Btn_Del.DisableWindow();
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    local LVDataRecord Record;

    switch(ListCtrlID)
    {
        // End:0x67
        case "FriendsList":
            FriendsList.GetSelectedRec(Record);
            Class'NWindow.UIAPI_EDITBOX'.static.SetString("PostWriteWnd.ReceiverID", Record.LVDataList[0].szData);
            // End:0x126
            break;
        // End:0xC4
        case "ClanList":
            ClanList.GetSelectedRec(Record);
            Class'NWindow.UIAPI_EDITBOX'.static.SetString("PostWriteWnd.ReceiverID", Record.LVDataList[0].szData);
            // End:0x126
            break;
        // End:0x120
        case "AddList":
            AddList.GetSelectedRec(Record);
            Class'NWindow.UIAPI_EDITBOX'.static.SetString("PostWriteWnd.ReceiverID", Record.LVDataList[0].szData);
            // End:0x126
            break;
        // End:0xFFFF
        default:
            // End:0x126
            break;
            break;
    }
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    local LVDataRecord Record;

    switch(ListCtrlID)
    {
        // End:0x58
        case "AddList":
            bPostFriendSelect = true;
            Btn_Del.EnableWindow();
            AddList.GetSelectedRec(Record);
            selectFriend = Record.LVDataList[0].szData;
            // End:0x5E
            break;
        // End:0xFFFF
        default:
            // End:0x5E
            break;
            break;
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="PostReceiverListWnd"
}