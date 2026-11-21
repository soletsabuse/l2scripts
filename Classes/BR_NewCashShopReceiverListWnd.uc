class BR_NewCashShopReceiverListWnd extends UICommonAPI;

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
var WindowHandle BR_NewCashShopReceiverListWnd_Friends;
var ListCtrlHandle FriendsList;
var TextureHandle FriendsListDeco;
var WindowHandle BR_NewCashShopReceiverListWnd_Clan;
var ListCtrlHandle ClanList;
var TextureHandle ClanListDeco;
var WindowHandle BR_NewCashShopReceiverListWnd_Add;
var ListCtrlHandle AddList;
var ButtonHandle Btn_Add;
var ButtonHandle Btn_Del;
var TextureHandle AddListGroupBoxLine;
var TextureHandle AddListDeco;
var ButtonHandle CloseButton;
var WindowHandle BR_CashShopReceiverListAddWnd;
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
    RegisterState("BR_NewCashShopReceiverListWnd", "TRAININGROOMSTATE");
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
    Me = GetWindowHandle("BR_NewCashShopReceiverListWnd");
    Description = GetTextBoxHandle("BR_NewCashShopReceiverListWnd.Description");
    DescriptionGroupBox = GetTextureHandle("BR_NewCashShopReceiverListWnd.DescriptionGroupBox");
    ListCount = GetTextBoxHandle("BR_NewCashShopReceiverListWnd.ListCount");
    TabCtrl = GetTabHandle("BR_NewCashShopReceiverListWnd.TabCtrl");
    ListGroupBox = GetTextureHandle("BR_NewCashShopReceiverListWnd.ListGroupBox");
    TabLineTop = GetTextureHandle("BR_NewCashShopReceiverListWnd.TabLineTop");
    tabBg = GetTextureHandle("BR_NewCashShopReceiverListWnd.tabBg");
    BR_NewCashShopReceiverListWnd_Friends = GetWindowHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Friends");
    FriendsList = GetListCtrlHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Friends.FriendsList");
    FriendsListDeco = GetTextureHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Friends.FriendsListDeco");
    BR_NewCashShopReceiverListWnd_Clan = GetWindowHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Clan");
    ClanList = GetListCtrlHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Clan.ClanList");
    ClanListDeco = GetTextureHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Clan.ClanListDeco");
    BR_NewCashShopReceiverListWnd_Add = GetWindowHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add");
    AddList = GetListCtrlHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add.AddList");
    Btn_Add = GetButtonHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add.Btn_Add");
    Btn_Del = GetButtonHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add.Btn_Del");
    AddListGroupBoxLine = GetTextureHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add.AddListGroupBoxLine");
    AddListDeco = GetTextureHandle("BR_NewCashShopReceiverListWnd.BR_CashShopReceiverListWnd_Add.AddListDeco");
    CloseButton = GetButtonHandle("BR_NewCashShopReceiverListWnd.CloseButton");
    BR_CashShopReceiverListAddWnd = GetWindowHandle("BR_CashShopReceiverListAddWnd");
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
            // End:0x8F
            break;
        // End:0x31
        case "Btn_Del":
            OnBtn_DelClick();
            // End:0x8F
            break;
        // End:0x4A
        case "CloseButton":
            OnCloseButtonClick();
            // End:0x8F
            break;
        // End:0x60
        case "TabCtrl0":
            setFriendCount();
            // End:0x8F
            break;
        // End:0x76
        case "TabCtrl1":
            setPledgeCount();
            // End:0x8F
            break;
        // End:0x8C
        case "TabCtrl2":
            setPostFrienddCount();
            // End:0x8F
            break;
        // End:0xFFFF
        default:
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
            // End:0x5C
            break;
        // End:0x3D
        case 1:
            ListCount.SetText(countPledge);
            // End:0x5C
            break;
        // End:0x59
        case 2:
            ListCount.SetText(countPostFriend);
            // End:0x5C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnBtn_AddClick()
{
    DisableTab();
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("BR_CashShopReceiverListAddWnd.Name", "");
    BR_CashShopReceiverListAddWnd.ShowWindow();
    BR_CashShopReceiverListAddWnd.SetFocus();
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
    local int i;

    NumPostFriend = NumPostFriend - 1;
    countPostFriend = ((("(" $ string(NumPostFriend)) $ "/") $ string(100)) $ ") ";
    SetCount(2);
    i = AddList.GetSelectedIndex();
    AddList.DeleteRecord(i);
    Class'NWindow.PostWndAPI'.static.RequestDeletingPostFriend(selectFriend);
    Class'NWindow.PostWndAPI'.static.RequestPostFriendList();
    selectedInit();
    return;
}

function OnCloseButtonClick()
{
    local BR_NewPresentBuyingWnd script;

    script = BR_NewPresentBuyingWnd(GetScript("BR_NewPresentBuyingWnd"));
    script.SetBoolCashShopReceiverList(false);
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
            // End:0xD5
            break;
        // End:0x51
        case 5000:
            ClanList.DeleteAllItem();
            HandleReceivePledgeMemberList(param);
            // End:0xD5
            break;
        // End:0x76
        case 4990:
            AddList.DeleteAllItem();
            HandleReceivePostFriendList(param);
            // End:0xD5
            break;
        // End:0x8C
        case 4980:
            HandleConfirmAddingPostFriend(param);
            // End:0xD5
            break;
        // End:0x9D
        case 1710:
            HandleDialogOK();
            // End:0xD5
            break;
        // End:0xAE
        case 1720:
            HandleDialogCancel();
            // End:0xD5
            break;
        // End:0xC4
        case 5040:
            HandleListCtrlLose(param);
            // End:0xD5
            break;
        // End:0xD2
        case 40:
            HandleRestart();
            // End:0xD5
            break;
        // End:0xFFFF
        default:
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
    local int Num, i;
    local string strName;
    local int FriendClass, FriendLevel;
    local LVDataRecord Record;
    local EditBoxHandle e_handle;
    local array<string> AddName;

    e_handle = GetEditBoxHandle("BR_NewPresentBuyingWnd.ReceiverID");
    ParseInt(param, "Num", Num);
    countFriend = ((("(" $ string(Num)) $ "/") $ string(128)) $ ") ";
    i = 0;
    J0x6E:

    // End:0x1DF [Loop If]
    if(i < Num)
    {
        ParseString(param, "Name" $ string(i), strName);
        ParseInt(param, "FriendClass" $ string(i), FriendClass);
        ParseInt(param, "FriendLevel" $ string(i), FriendLevel);
        AddName[i] = strName;
        Record.LVDataList.Length = 3;
        Record.LVDataList[0].szData = strName;
        Record.LVDataList[1].szTexture = GetClassRoleIconName(FriendClass);
        Record.LVDataList[1].nTextureWidth = 11;
        Record.LVDataList[1].nTextureHeight = 11;
        Record.LVDataList[1].szData = string(FriendClass);
        Record.LVDataList[2].szData = string(FriendLevel);
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("BR_NewCashShopReceiverListWnd.FriendsList", Record);
        i++;
        // [Loop Continue]
        goto J0x6E;
    }
    e_handle.FillAdditionalSearchList(AddName, 0);
    SetCount(m_selectedTab);
    return;
}

function HandleReceivePledgeMemberList(string param)
{
    local int Num, i;
    local string strName;
    local int ClanClass, ClanLevel;
    local LVDataRecord Record;
    local EditBoxHandle e_handle;
    local array<string> AddName;

    e_handle = GetEditBoxHandle("BR_NewPresentBuyingWnd.ReceiverID");
    ParseInt(param, "Num", Num);
    countPledge = ((("(" $ string(Num)) $ "/") $ string(220)) $ ") ";
    i = 0;
    J0x6E:

    // End:0x1DC [Loop If]
    if(i < Num)
    {
        ParseString(param, "Name" $ string(i), strName);
        ParseInt(param, "FriendClass" $ string(i), ClanClass);
        ParseInt(param, "FriendLevel" $ string(i), ClanLevel);
        AddName[i] = strName;
        Record.LVDataList.Length = 3;
        Record.LVDataList[0].szData = strName;
        Record.LVDataList[1].szTexture = GetClassRoleIconName(ClanClass);
        Record.LVDataList[1].nTextureWidth = 11;
        Record.LVDataList[1].nTextureHeight = 11;
        Record.LVDataList[1].szData = string(ClanClass);
        Record.LVDataList[2].szData = string(ClanLevel);
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("BR_NewCashShopReceiverListWnd.ClanList", Record);
        i++;
        // [Loop Continue]
        goto J0x6E;
    }
    e_handle.FillAdditionalSearchList(AddName, 1);
    SetCount(m_selectedTab);
    return;
}

function HandleReceivePostFriendList(string param)
{
    local int Num, i;
    local string strName;
    local LVDataRecord Record;
    local EditBoxHandle e_handle;
    local array<string> AddName;

    e_handle = GetEditBoxHandle("BR_NewPresentBuyingWnd.ReceiverID");
    ParseInt(param, "Num", Num);
    NumPostFriend = Num;
    countPostFriend = ((("(" $ string(NumPostFriend)) $ "/") $ string(100)) $ ") ";
    i = 0;
    J0x79:

    // End:0x121 [Loop If]
    if(i < Num)
    {
        ParseString(param, "Name" $ string(i), strName);
        AddName[i] = strName;
        Record.LVDataList.Length = 1;
        Record.LVDataList[0].szData = strName;
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("BR_NewCashShopReceiverListWnd.AddList", Record);
        i++;
        // [Loop Continue]
        goto J0x79;
    }
    e_handle.FillAdditionalSearchList(AddName, 2);
    SetCount(m_selectedTab);
    return;
}

function HandleConfirmAddingPostFriend(string param)
{
    local string strName;
    local int Result;

    ParseString(param, "Name", strName);
    ParseInt(param, "Result", Result);
    // End:0x51
    if(Result == 1)
    {
        Class'NWindow.PostWndAPI'.static.RequestPostFriendList();
        EnableTab();        
    }
    else
    {
        // End:0x83
        if(Result == -1)
        {
            DialogSetID(2);
            DialogShow(1, 5, GetSystemMessage(3223), string(self));            
        }
        else
        {
            // End:0xCF
            if((Result == -2) || Result == 0)
            {
                DialogSetID(2);
                DialogShow(1, 5, MakeFullSystemMsg(GetSystemMessage(3215), strName, ""), string(self));                
            }
            else
            {
                // End:0x101
                if(Result == -3)
                {
                    DialogSetID(2);
                    DialogShow(1, 5, GetSystemMessage(3222), string(self));                    
                }
                else
                {
                    // End:0x133
                    if(Result == -4)
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
    local string ListCtrlName;

    ParseString(param, "ListCtrlName", ListCtrlName);
    // End:0x4E
    if(ListCtrlName == AddList.GetWindowName())
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
        // End:0x71
        case "FriendsList":
            FriendsList.GetSelectedRec(Record);
            Class'NWindow.UIAPI_EDITBOX'.static.SetString("BR_NewPresentBuyingWnd.ReceiverID", Record.LVDataList[0].szData);
            // End:0x141
            break;
        // End:0xD8
        case "ClanList":
            ClanList.GetSelectedRec(Record);
            Class'NWindow.UIAPI_EDITBOX'.static.SetString("BR_NewPresentBuyingWnd.ReceiverID", Record.LVDataList[0].szData);
            // End:0x141
            break;
        // End:0x13E
        case "AddList":
            AddList.GetSelectedRec(Record);
            Class'NWindow.UIAPI_EDITBOX'.static.SetString("BR_NewPresentBuyingWnd.ReceiverID", Record.LVDataList[0].szData);
            // End:0x141
            break;
        // End:0xFFFF
        default:
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
            // End:0x5B
            break;
        // End:0xFFFF
        default:
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
    m_WindowName="BR_NewCashShopReceiverListWnd"
}