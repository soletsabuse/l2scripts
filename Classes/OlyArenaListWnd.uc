class OlyArenaListWnd extends UICommonAPI;

const TIMER_DELAY = 3000;
const TIMER_ID = 148;

struct playerExtraDataStruct
{
    var int ClassID;
    var bool bIsClanMember;
    var bool bIsHero;
};

struct playerDataStruct
{
    var int Num;
    var int arenaType;
    var int arenaState;
    var string player1Name;
    var string player2Name;
    var playerExtraDataStruct player1Ex;
    var playerExtraDataStruct player2Ex;
};

var array<playerDataStruct> playerDatas;
var string m_WindowName;
var WindowHandle Me;
var ListCtrlHandle listCtrl;
var ButtonHandle RefreshButton;
var ComboBoxHandle ClassesComboBox;
var EditBoxHandle EditBoxSearch;
var CheckBoxHandle FriendCharacterCheckBox;

function OnLoad()
{
    local int __var6315;

    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    SetClosingOnESC();
    listCtrl = GetListCtrlHandle(m_WindowName $ ".OlympiadArenaList_ListCtrl");
    ClassesComboBox = GetComboBoxHandle(m_WindowName $ ".ClassesComboBox");
    EditBoxSearch = GetEditBoxHandle(m_WindowName $ ".EditBoxSearch");
    FriendCharacterCheckBox = GetCheckBoxHandle(m_WindowName $ ".FriendCharacterCheckBox");
    RefreshButton = GetButtonHandle(m_WindowName $ ".refresh_Button");
    listCtrl.SetColumnMinimumWidth(true);
    ClassesComboBox.AddStringWithReserved(GetSystemString(2592), 0);
    __var6315 = 88;
    J0x122:

    // End:0x15D [Loop If]
    if(__var6315 < 119)
    {
        ClassesComboBox.AddStringWithReserved(GetSystemString(IsThirdClass(__var6315)), __var6315);
        __var6315++;
        // [Loop Continue]
        goto J0x122;
    }
    ClassesComboBox.AddStringWithReserved(GetSystemString(IsThirdClass(131)), 131);
    ClassesComboBox.AddStringWithReserved(GetSystemString(IsThirdClass(132)), 132);
    ClassesComboBox.AddStringWithReserved(GetSystemString(IsThirdClass(133)), 133);
    ClassesComboBox.AddStringWithReserved(GetSystemString(IsThirdClass(134)), 134);
    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    switch(Event_ID)
    {
        // End:0x2C
        case 5080:
            HandleRoomLists(a_Param);
            Me.SetFocus();
            // End:0x32
            break;
        // End:0xFFFF
        default:
            // End:0x32
            break;
            break;
    }
    return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
    switch(strID)
    {
        // End:0x29
        case "ClassesComboBox":
            HandleRoomList(playerDatas);
            // End:0x2F
            break;
        // End:0xFFFF
        default:
            // End:0x2F
            break;
            break;
    }
    return;
}

function OnChangeEditBox(string strID)
{
    local string __var31975;

    // End:0x24
    if(strID == "EditBoxSearch")
    {
        HandleRoomList(playerDatas);
    }
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x31
        case "FriendCharacterCheckBox":
            HandleRoomList(playerDatas);
            // End:0x37
            break;
        // End:0xFFFF
        default:
            // End:0x37
            break;
            break;
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    local LVDataRecord Record;

    // End:0x53
    if(listCtrl.GetSelectedIndex() >= 0)
    {
        listCtrl.GetSelectedRec(Record);
        RequestBypassToServer("olympiad_arena_view " $ (Record.nReserved1));
    }
    return;
}

function OnTimer(int TimerID)
{
    switch(TimerID)
    {
        // End:0x1E
        case 148:
            RefreshButton.EnableWindow();
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

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x30
        case "close_Button":
            GetWindowHandle(m_WindowName).HideWindow();
            // End:0x52
            break;
        // End:0x4C
        case "refresh_Button":
            HandleRefresh();
            // End:0x52
            break;
        // End:0xFFFF
        default:
            // End:0x52
            break;
            break;
    }
    return;
}

function OnHide()
{
    listCtrl.DeleteAllItem();
    return;
}

function HandleRefresh()
{
    listCtrl.DeleteAllItem();
    Class'NWindow.OlympiadAPI'.static.RequestOlympiadMatchList();
    RefreshButton.DisableWindow();
    Me.SetTimer(148, 3000);
    return;
}

function emulateOlymp()
{
    local string __var3801;
    local int __var3199, __var2607, __var2614;

    ParamAdd(__var3801, "gameNum", string(20));
    ParamAdd(__var3801, "bRemain", string(0));
    __var3199 = 0;
    J0x36:

    // End:0x22B [Loop If]
    if(__var3199 < 20)
    {
        ParamAdd(__var3801, "num_" $ string(__var3199), string(__var3199));
        ParamAdd(__var3801, "arenaType_" $ string(__var3199), string(1));
        ParamAdd(__var3801, "arenaState_" $ string(__var3199), string(Rand(2)));
        __var2607 = Rand(100);
        // End:0xCD
        if(__var2607 < 10)
        {
            __var2607 = 1;            
        }
        else
        {
            __var2607 = 0;
        }
        __var2614 = Rand(100);
        // End:0xF4
        if(__var2614 < 10)
        {
            __var2614 = 1;            
        }
        else
        {
            __var2614 = 0;
        }
        ParamAdd(__var3801, "player1Name_" $ string(__var3199), (((((("Nickname" $ string(Rand(100000))) $ ";") $ string(RandRange(88.0000000, 115.0000000))) $ ";") $ string(__var2607)) $ ";") $ string(__var2614));
        __var2607 = Rand(100);
        // End:0x187
        if(__var2607 < 10)
        {
            __var2607 = 1;            
        }
        else
        {
            __var2607 = 0;
        }
        __var2614 = Rand(100);
        // End:0x1AE
        if(__var2614 < 10)
        {
            __var2614 = 1;            
        }
        else
        {
            __var2614 = 0;
        }
        ParamAdd(__var3801, "player2Name_" $ string(__var3199), (((((("Nickname" $ string(Rand(100000))) $ ";") $ string(RandRange(88.0000000, 115.0000000))) $ ";") $ string(__var2607)) $ ";") $ string(__var2614));
        __var3199++;
        // [Loop Continue]
        goto J0x36;
    }
    HandleRoomLists(__var3801);
    return;
}

function HandleRoomLists(string a_Param)
{
    local playerDataStruct playerData;
    local playerExtraDataStruct playerDataExtra;
    local int __var17993, __var3793, __var17996;
    local string __var17998, __var18003;
    local array<string> ExtraData;

    playerDatas.Remove(0, playerDatas.Length);
    ParseInt(a_Param, "gameNum", __var17993);
    ParseInt(a_Param, "bRemain", __var17996);
    __var3793 = 0;
    J0x46:

    // End:0x224 [Loop If]
    if(__var3793 < __var17993)
    {
        ParseInt(a_Param, "num_" $ string(__var3793), playerData.Num);
        ParseInt(a_Param, "arenaType_" $ string(__var3793), playerData.arenaType);
        ParseInt(a_Param, "arenaState_" $ string(__var3793), playerData.arenaState);
        ParseString(a_Param, "player1Name_" $ string(__var3793), __var17998);
        ParseString(a_Param, "player2Name_" $ string(__var3793), __var18003);
        ExtraData = Arr(__var17998, ";");
        playerData.player1Name = ExtraData[0];
        playerDataExtra.ClassID = int(ExtraData[1]);
        playerDataExtra.bIsClanMember = bool(ExtraData[2]);
        playerDataExtra.bIsHero = bool(ExtraData[3]);
        playerData.player1Ex = playerDataExtra;
        ExtraData = Arr(__var18003, ";");
        playerData.player2Name = ExtraData[0];
        playerDataExtra.ClassID = int(ExtraData[1]);
        playerDataExtra.bIsClanMember = bool(ExtraData[2]);
        playerDataExtra.bIsHero = bool(ExtraData[3]);
        playerData.player2Ex = playerDataExtra;
        playerDatas[playerDatas.Length] = playerData;
        __var3793++;
        // [Loop Continue]
        goto J0x46;
    }
    playerDatas = ManualSort(playerDatas);
    HandleRoomList(playerDatas);
    // End:0x25A
    if(__var17996 == 0)
    {
        Me.ShowWindow();
    }
    return;
}

function HandleRoomList(array<playerDataStruct> playerDatas)
{
    local LVDataRecord Record;
    local int __var1009, __var8706;
    local string __var8707;

    listCtrl.DeleteAllItem();
    Record.LVDataList.Length = 10;
    __var8706 = ClassesComboBox.GetReserved(ClassesComboBox.GetSelectedNum());
    __var8707 = ToLower(EditBoxSearch.GetString());
    __var1009 = 0;
    J0x63:

    // End:0x5E4 [Loop If]
    if(__var1009 < playerDatas.Length)
    {
        // End:0xC1
        if(__var8706 > 0)
        {
            // End:0xC1
            if((playerDatas[__var1009].player1Ex.ClassID != __var8706) && playerDatas[__var1009].player2Ex.ClassID != __var8706)
            {
                // [Explicit Continue]
                goto J0x5DA;
            }
        }
        // End:0x118
        if(__var8707 != "")
        {
            // End:0x118
            if((InStr(ToLower(playerDatas[__var1009].player1Name), __var8707) < 0) && InStr(ToLower(playerDatas[__var1009].player2Name), __var8707) < 0)
            {
                // [Explicit Continue]
                goto J0x5DA;
            }
        }
        // End:0x165
        if(FriendCharacterCheckBox.IsChecked())
        {
            // End:0x165
            if(!playerDatas[__var1009].player1Ex.bIsClanMember && !playerDatas[__var1009].player2Ex.bIsClanMember)
            {
                // [Explicit Continue]
                goto J0x5DA;
            }
        }
        Record.nReserved1 = (playerDatas[__var1009].Num + 1);
        Record.LVDataList[0].szData = (Record.nReserved1);
        Record.LVDataList[0].textAlignment = 2;
        // End:0x200
        if(playerDatas[__var1009].arenaType < 3)
        {
            Record.LVDataList[1].szData = GetSystemString(2283 - playerDatas[__var1009].arenaType);            
        }
        else
        {
            Record.LVDataList[1].szData = "";
        }
        Record.LVDataList[1].textAlignment = 2;
        // End:0x25F
        if(playerDatas[__var1009].arenaState == 0)
        {
            Record.LVDataList[2].szData = GetSystemString(906);            
        }
        else
        {
            Record.LVDataList[2].szData = GetSystemString(1717 + playerDatas[__var1009].arenaState);
        }
        Record.LVDataList[2].textAlignment = 2;
        Record.LVDataList[3].szData = " " $ playerDatas[__var1009].player1Name;
        Record.LVDataList[3].bUseTextColor = true;
        Record.LVDataList[3].hasIcon = true;
        Record.LVDataList[3].nTextureU = 16;
        Record.LVDataList[3].nTextureV = 16;
        Record.LVDataList[3].nTextureWidth = 16;
        Record.LVDataList[3].nTextureHeight = 16;
        Record.LVDataList[3].IconPosX = 3;
        Record.LVDataList[3].szTexture = "UI_BOHPTS.icons.Class_Icon" $ string(playerDatas[__var1009].player1Ex.ClassID);
        Record.LVDataList[3].textAlignment = 1;
        Record.LVDataList[3].TextColor = getColorByType("player1", playerDatas[__var1009].player1Ex.bIsClanMember, playerDatas[__var1009].player2Ex.bIsHero);
        Record.LVDataList[3].nReserved1 = int(playerDatas[__var1009].player1Ex.bIsClanMember);
        Record.LVDataList[4].szData = " " $ playerDatas[__var1009].player2Name;
        Record.LVDataList[4].bUseTextColor = true;
        Record.LVDataList[4].hasIcon = true;
        Record.LVDataList[4].nTextureU = 16;
        Record.LVDataList[4].nTextureV = 16;
        Record.LVDataList[4].nTextureWidth = 16;
        Record.LVDataList[4].nTextureHeight = 16;
        Record.LVDataList[4].IconPosX = 3;
        Record.LVDataList[4].szTexture = "UI_BOHPTS.icons.Class_Icon" $ string(playerDatas[__var1009].player2Ex.ClassID);
        Record.LVDataList[4].textAlignment = 1;
        Record.LVDataList[4].TextColor = getColorByType("player2", playerDatas[__var1009].player2Ex.bIsClanMember, playerDatas[__var1009].player2Ex.bIsHero);
        Record.LVDataList[4].nReserved1 = int(playerDatas[__var1009].player2Ex.bIsClanMember);
        listCtrl.InsertRecord(Record);
        J0x5DA:

        __var1009++;
        // [Loop Continue]
        goto J0x63;
    }
    return;
}

private function array<playerDataStruct> ManualSort(array<playerDataStruct> Arr)
{
    local array<playerDataStruct> sortedArray;
    local int __var2625, __var11725, __var11724, __var11723;

    __var11725 = 0;
    __var2625 = 0;
    J0x0E:

    // End:0x43 [Loop If]
    if(__var2625 < Arr.Length)
    {
        // End:0x39
        if(HasClan(Arr[__var2625]))
        {
            __var11725++;
        }
        __var2625++;
        // [Loop Continue]
        goto J0x0E;
    }
    sortedArray.Length = Arr.Length;
    __var11724 = 0;
    __var11723 = __var11725;
    __var2625 = 0;
    J0x69:

    // End:0xD6 [Loop If]
    if(__var2625 < Arr.Length)
    {
        // End:0xAE
        if(HasClan(Arr[__var2625]))
        {
            sortedArray[__var11724] = Arr[__var2625];
            __var11724++;
            // [Explicit Continue]
            goto J0xCC;
        }
        sortedArray[__var11723] = Arr[__var2625];
        __var11723++;
        J0xCC:

        __var2625++;
        // [Loop Continue]
        goto J0x69;
    }
    return sortedArray;
    return;
}

private function bool HasClan(playerDataStruct A)
{
    return A.player1Ex.bIsClanMember || A.player2Ex.bIsClanMember;
    return;
}

function Color getColorByType(string Type, bool bIsClanMember, bool bIsHero)
{
    local Color C;

    // End:0x33
    if(bIsClanMember)
    {
        C.R = 200;
        C.G = 50;
        C.B = 200;        
    }
    else
    {
        // End:0x68
        if(bIsHero)
        {
            C.R = byte(255);
            C.G = 215;
            C.B = 0;            
        }
        else
        {
            // End:0xA5
            if(Type == "player1")
            {
                C.R = 238;
                C.G = 119;
                C.B = 119;                
            }
            else
            {
                // End:0xDF
                if(Type == "player2")
                {
                    C.R = 102;
                    C.G = 170;
                    C.B = 238;
                }
            }
        }
    }
    return C;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}
