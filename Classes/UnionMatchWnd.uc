class UnionMatchWnd extends PartyMatchWndCommon;

const ROOMMASTER = 1;
const UNIONLEADER = 3;
const UNIONPARTY = 4;
const WAITPARTY = 5;
const WAITNORMAL = 6;

var WindowHandle Me;
var ListCtrlHandle lstMember;
var TextBoxHandle lblNum;
var TextBoxHandle txtNum;
var TextBoxHandle lblTitle;
var TextBoxHandle txtTitle;
var TextBoxHandle lblMethod;
var TextBoxHandle txtMethod;
var TextBoxHandle lblMemberCount;
var TextBoxHandle txtMemberCount;
var TextBoxHandle lblLevelLimit;
var TextBoxHandle txtLevelLimit;
var TextListBoxHandle tlstChat;
var EditBoxHandle edChat;
var ButtonHandle btnRoomInfo;
var ButtonHandle btnUnionInfo;
var ButtonHandle btnBan;
var ButtonHandle btnInviteParty;
var ButtonHandle btnInviteUnion;
var ButtonHandle btnExit;
var TextureHandle txListTitleBg;
var TextureHandle txTitleBg;
var TextureHandle txListBg;
var TextureHandle txChatBg;
var TextBoxHandle lblListTitle;
var WindowHandle UnionMatchDrawerWnd;
var WindowHandle UnionMatchMakeRoomWnd;
var WindowHandle PartyMatchWnd;
var WindowHandle m_UnionWnd;
var string ROOM_NAME;
var int ROOM_TYPE;
var int ROOM_NUM;
var int ROOM_MINLEVEL;
var int ROOM_MAXLEVEL;
var int ROOM_ROUTING;
var int MYID;
var int MYTYPE;
var int CURMEMBER_COUNT;
var int MAXMEMBER_COUNT;
var bool I_REQUEST_EXIT;
var int m_MasterID;

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(4000);
    RegisterEvent(4030);
    RegisterEvent(4040);
    RegisterEvent(4050);
    RegisterEvent(4060);
    RegisterEvent(4070);
    RegisterEvent(1170);
    RegisterEvent(1140);
    RegisterEvent(1160);
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
    Me = GetWindowHandle("UnionMatchWnd");
    lstMember = GetListCtrlHandle("UnionMatchWnd.lstMember");
    lblNum = GetTextBoxHandle("UnionMatchWnd.lblNum");
    txtNum = GetTextBoxHandle("UnionMatchWnd.txtNum");
    lblTitle = GetTextBoxHandle("UnionMatchWnd.lblTitle");
    txtTitle = GetTextBoxHandle("UnionMatchWnd.txtTitle");
    lblMethod = GetTextBoxHandle("UnionMatchWnd.lblMethod");
    txtMethod = GetTextBoxHandle("UnionMatchWnd.txtMethod");
    lblMemberCount = GetTextBoxHandle("UnionMatchWnd.lblMemberCount");
    txtMemberCount = GetTextBoxHandle("UnionMatchWnd.txtMemberCount");
    lblLevelLimit = GetTextBoxHandle("UnionMatchWnd.lblLevelLimit");
    txtLevelLimit = GetTextBoxHandle("UnionMatchWnd.txtLevelLimit");
    tlstChat = GetTextListBoxHandle("UnionMatchWnd.tlstChat");
    edChat = GetEditBoxHandle("UnionMatchWnd.edChat");
    btnRoomInfo = GetButtonHandle("UnionMatchWnd.btnRoomInfo");
    btnUnionInfo = GetButtonHandle("UnionMatchWnd.btnUnionInfo");
    btnBan = GetButtonHandle("UnionMatchWnd.btnBan");
    btnInviteParty = GetButtonHandle("UnionMatchWnd.btnInviteParty");
    btnInviteUnion = GetButtonHandle("UnionMatchWnd.btnInviteUnion");
    btnExit = GetButtonHandle("UnionMatchWnd.btnExit");
    txListTitleBg = GetTextureHandle("UnionMatchWnd.txListTitleBg");
    txTitleBg = GetTextureHandle("UnionMatchWnd.txTitleBg");
    txListBg = GetTextureHandle("UnionMatchWnd.txListBg");
    txChatBg = GetTextureHandle("UnionMatchWnd.txChatBg");
    lblListTitle = GetTextBoxHandle("UnionMatchWnd.lblListTitle");
    m_UnionWnd = GetWindowHandle("UnionWnd");
    UnionMatchDrawerWnd = GetWindowHandle("UnionMatchDrawerWnd");
    UnionMatchMakeRoomWnd = GetWindowHandle("UnionMatchMakeRoomWnd");
    PartyMatchWnd = GetWindowHandle("PartyMatchWnd");
    return;
}

function load()
{
    CURMEMBER_COUNT = 0;
    I_REQUEST_EXIT = false;
    return;
}

function OnEvent(int EventID, string param)
{
    switch(EventID)
    {
        // End:0x1D
        case 4000:
            HandleMpccRoomInfo(param);
            // End:0x11E
            break;
        // End:0x33
        case 4030:
            HandleDismissMpccRoom(param);
            // End:0x11E
            break;
        // End:0x49
        case 4040:
            HandleManageMpccRoomMember(param);
            // End:0x11E
            break;
        // End:0x5F
        case 4050:
            HandleMpccRoomMemberStart(param);
            // End:0x11E
            break;
        // End:0x75
        case 4060:
            HandleMpccRoomMemberInfo(param);
            // End:0x11E
            break;
        // End:0x8B
        case 4070:
            HandleMpccRoomChatMessage(param);
            // End:0x11E
            break;
        // End:0xB4
        case 1160:
            Class'NWindow.PartyMatchAPI'.static.RequestDismissMpccRoom();
            Me.HideWindow();
            // End:0x11E
            break;
        // End:0xDD
        case 1170:
            Class'NWindow.PartyMatchAPI'.static.RequestDismissMpccRoom();
            Me.HideWindow();
            // End:0x11E
            break;
        // End:0x11B
        case 1710:
            // End:0x118
            if(DialogIsMine())
            {
                // End:0x118
                if((DialogGetID()) == 1)
                {
                    Class'NWindow.PartyMatchAPI'.static.RequestDismissMpccRoom();
                    Me.HideWindow();
                }
            }
            // End:0x11E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x20
        case "btnRoomInfo":
            OnbtnRoomInfoClick();
            // End:0x9E
            break;
        // End:0x3A
        case "btnUnionInfo":
            OnbtnUnionInfoClick();
            // End:0x9E
            break;
        // End:0x4E
        case "btnBan":
            OnbtnBanClick();
            // End:0x9E
            break;
        // End:0x6A
        case "btnInviteParty":
            OnbtnInvitePartyClick();
            // End:0x9E
            break;
        // End:0x86
        case "btnInviteUnion":
            OnbtnInviteUnionClick();
            // End:0x9E
            break;
        // End:0x9B
        case "btnExit":
            OnbtnExitClick();
            // End:0x9E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnShow()
{
    // End:0x21
    if(UnionMatchDrawerWnd.IsShowWindow())
    {
        Class'NWindow.PartyMatchAPI'.static.RequestMpccPartymasterList();
    }
    // End:0x42
    if(m_UnionWnd.IsShowWindow())
    {
        Class'NWindow.PartyMatchAPI'.static.RequestMpccPartymasterList();
    }
    return;
}

function OnCompleteEditBox(string strID)
{
    local string ChatMsg;

    // End:0x45
    if(strID == "edChat")
    {
        ChatMsg = edChat.GetString();
        ProcessPartyMatchChatMessage(21, ChatMsg);
        edChat.SetString("");
    }
    return;
}

function OnbtnRoomInfoClick()
{
    local UnionMatchMakeRoomWnd script;

    script = UnionMatchMakeRoomWnd(GetScript("UnionMatchMakeRoomWnd"));
    // End:0xBC
    if(script != none)
    {
        script.SetMakeType(2);
        script.SetRoomNum(ROOM_NUM);
        script.SetTitle(ROOM_NAME);
        script.SetMaxMemberCount(MAXMEMBER_COUNT);
        script.SetMinLevel(ROOM_MINLEVEL);
        script.SetMaxLevel(ROOM_MAXLEVEL);
        script.SetRoomRouting(ROOM_ROUTING);
    }
    UnionMatchMakeRoomWnd.ShowWindow();
    UnionMatchMakeRoomWnd.SetFocus();
    return;
}

function OnbtnUnionInfoClick()
{
    // End:0x35
    if(!UnionMatchDrawerWnd.IsShowWindow())
    {
        UnionMatchDrawerWnd.ShowWindow();
        Class'NWindow.PartyMatchAPI'.static.RequestMpccPartymasterList();        
    }
    else
    {
        UnionMatchDrawerWnd.HideWindow();
    }
    return;
}

function OnbtnBanClick()
{
    local int idx;
    local LVDataRecord Record;

    idx = lstMember.GetSelectedIndex();
    // End:0x22
    if(idx < 0)
    {
        return;
    }
    lstMember.GetRec(idx, Record);
    Class'NWindow.PartyMatchAPI'.static.RequestOustFromMpccRoom(Record.LVDataList[0].nReserved1);
    return;
}

function OnbtnInvitePartyClick()
{
    local int idx;
    local LVDataRecord Record;

    idx = lstMember.GetSelectedIndex();
    // End:0x22
    if(idx < 0)
    {
        return;
    }
    lstMember.GetRec(idx, Record);
    // End:0x6B
    if(Record.LVDataList[3].nReserved1 == 6)
    {
        RequestInviteParty(Record.LVDataList[0].szData);
    }
    return;
}

function OnbtnInviteUnionClick()
{
    local int idx;
    local LVDataRecord Record;

    idx = lstMember.GetSelectedIndex();
    // End:0x22
    if(idx < 0)
    {
        return;
    }
    lstMember.GetRec(idx, Record);
    // End:0x6B
    if(Record.LVDataList[3].nReserved1 == 5)
    {
        RequestInviteMpcc(Record.LVDataList[0].szData);
    }
    return;
}

function OnbtnExitClick()
{
    switch(MYTYPE)
    {
        // End:0x0B
        case 1:
        // End:0x32
        case 3:
            DialogShow(1, 0, GetSystemMessage(2993), string(self));
            DialogSetID(1);
            // End:0x70
            break;
        // End:0x49
        case 4:
            Me.HideWindow();
            // End:0x70
            break;
        // End:0x4E
        case 5:
        // End:0x6D
        case 6:
            Class'NWindow.PartyMatchAPI'.static.RequestWithdrawMpccRoom();
            I_REQUEST_EXIT = true;
            // End:0x70
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleMpccRoomInfo(string param)
{
    local Rect rectWnd;
    local L2Util util;

    util = L2Util(GetScript("L2Util"));
    ParseInt(param, "RoomNum", ROOM_NUM);
    ParseInt(param, "MaxMemberLimit", MAXMEMBER_COUNT);
    ParseInt(param, "MinLevelLimit", ROOM_MINLEVEL);
    ParseInt(param, "MaxLevelLimit", ROOM_MAXLEVEL);
    ParseInt(param, "PartyRouting", ROOM_ROUTING);
    ParseString(param, "Title", ROOM_NAME);
    // End:0xE6
    if(PartyMatchWnd.IsShowWindow())
    {
        PartyMatchWnd.HideWindow();
    }
    rectWnd = PartyMatchWnd.GetRect();
    Me.MoveTo(rectWnd.nX, rectWnd.nY);
    Me.ShowWindow();
    Me.SetFocus();
    txtNum.SetText(string(ROOM_NUM));
    txtTitle.SetText(ROOM_NAME);
    txtMethod.SetText(util.getLootingString(ROOM_ROUTING));
    txtLevelLimit.SetText((string(ROOM_MINLEVEL) $ "-") $ string(ROOM_MAXLEVEL));
    tlstChat.Clear();
    return;
}

function HandleMpccRoomChatMessage(string param)
{
    local Color ChatColor;
    local string chatMessage;
    local int tmpType;

    ParseInt(param, "SayType", tmpType);
    ParseString(param, "Msg", chatMessage);
    ChatColor = GetChatColorByType(tmpType);
    tlstChat.AddString(chatMessage, ChatColor);
    // End:0x8F
    if(Me.IsMinimizedWindow())
    {
        PlaySound("ItemSound3.Sys_party_matching");
    }
    NotifyMe();
    return;
}

function HandleDismissMpccRoom(string param)
{
    local Rect rectWnd;

    // End:0x59
    if(Me.IsShowWindow())
    {
        Me.HideWindow();
        rectWnd = Me.GetRect();
        PartyMatchWnd.MoveTo(rectWnd.nX, rectWnd.nY);
    }
    // End:0x67
    if(I_REQUEST_EXIT == false)
    {
        return;
    }
    switch(MYTYPE)
    {
        // End:0x73
        case 5:
        // End:0x99
        case 6:
            PartyMatchWnd.ShowWindow();
            PartyMatchWnd.SetFocus();
            // End:0x9C
            break;
        // End:0xFFFF
        default:
            break;
    }
    I_REQUEST_EXIT = false;
    return;
}

function HandleMpccRoomMemberStart(string param)
{
    local Rect rectWnd;
    local UserInfo MyInfo;

    MYID = 0;
    MYTYPE = 0;
    // End:0x2C
    if(GetPlayerInfo(MyInfo))
    {
        MYID = MyInfo.nID;
    }
    CURMEMBER_COUNT = 0;
    lstMember.DeleteAllItem();
    ParseInt(param, "MyPartyRoomStatus", ROOM_TYPE);
    UpdateInfoButton();
    UpdateRelationButton();
    // End:0xDE
    if(!Me.IsShowWindow())
    {
        rectWnd = PartyMatchWnd.GetRect();
        Me.MoveTo(rectWnd.nX, rectWnd.nY);
        Me.ShowWindow();
        Me.SetFocus();        
    }
    else
    {
        NotifyMe();
    }
    return;
}

function HandleMpccRoomMemberInfo(string param)
{
    local int Id;
    local string Name;
    local int Level, ClassID, partyRoomStatus;

    ParseInt(param, "ID", Id);
    ParseString(param, "Name", Name);
    ParseInt(param, "Level", Level);
    ParseInt(param, "ClassID", ClassID);
    ParseInt(param, "partyRoomStatus", partyRoomStatus);
    AddMember(Id, Name, ClassID, Level, partyRoomStatus);
    return;
}

function HandleManageMpccRoomMember(string param)
{
    local int Type, Id;
    local string Name;
    local int Level, ClassID, partyRoomStatus;

    ParseInt(param, "Type", Type);
    ParseInt(param, "ID", Id);
    switch(Type)
    {
        // End:0xBE
        case 0:
            ParseString(param, "Name", Name);
            ParseInt(param, "Level", Level);
            ParseInt(param, "ClassID", ClassID);
            ParseInt(param, "partyRoomStatus", partyRoomStatus);
            AddMember(Id, Name, ClassID, Level, partyRoomStatus);
            // End:0x161
            break;
        // End:0x14B
        case 1:
            ParseString(param, "Name", Name);
            ParseInt(param, "Level", Level);
            ParseInt(param, "ClassID", ClassID);
            ParseInt(param, "partyRoomStatus", partyRoomStatus);
            ModifyMember(Id, Name, ClassID, Level, partyRoomStatus);
            // End:0x161
            break;
        // End:0x15E
        case 2:
            RemoveMember(Id);
            // End:0x161
            break;
        // End:0xFFFF
        default:
            break;
    }
    NotifyMe();
    return;
}

function UpdateMemberCount()
{
    txtMemberCount.SetText((string(CURMEMBER_COUNT) $ "/") $ string(MAXMEMBER_COUNT));
    return;
}

function UpdateInfoButton()
{
    switch(ROOM_TYPE)
    {
        // End:0x0B
        case 1:
        // End:0x22
        case 3:
            btnRoomInfo.EnableWindow();
            // End:0x46
            break;
        // End:0x27
        case 4:
        // End:0x2C
        case 6:
        // End:0x43
        case 5:
            btnRoomInfo.DisableWindow();
            // End:0x46
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function UpdateRelationButton()
{
    local int idx;
    local LVDataRecord Record;

    btnBan.DisableWindow();
    btnInviteParty.DisableWindow();
    btnInviteUnion.DisableWindow();
    // End:0x3B
    if(ROOM_TYPE == 6)
    {
        return;
    }
    idx = lstMember.GetSelectedIndex();
    // End:0x5D
    if(idx < 0)
    {
        return;
    }
    // End:0x78
    if(idx == lstMember.GetRecordCount())
    {
        return;
    }
    lstMember.GetRec(idx, Record);
    // End:0xD4
    if(Record.LVDataList[3].nReserved1 == 5)
    {
        // End:0xD1
        if(isMaster())
        {
            btnBan.EnableWindow();
            btnInviteUnion.EnableWindow();
        }        
    }
    else
    {
        // End:0x114
        if(Record.LVDataList[3].nReserved1 == 6)
        {
            // End:0x105
            if(isMaster())
            {
                btnBan.EnableWindow();
            }
            btnInviteParty.EnableWindow();
        }
    }
    return;
}

function bool isMaster()
{
    // End:0x1B
    if((ROOM_TYPE == 3) || ROOM_TYPE == 1)
    {
        return true;
    }
    return false;
    return;
}

function NotifyMe()
{
    // End:0x21
    if(Me.IsMinimizedWindow())
    {
        Me.NotifyAlarm();
    }
    return;
}

function AddMember(int a_ID, string a_Name, int a_ClassID, int a_Level, int a_partyRoomStatus)
{
    local int idx;
    local LVDataRecord Record;

    idx = FindMember(a_ID);
    // End:0x22
    if(idx > -1)
    {
        return;
    }
    Record = makeRecord(a_ID, a_Name, a_ClassID, a_Level, a_partyRoomStatus);
    lstMember.InsertRecord(Record);
    CURMEMBER_COUNT++;
    UpdateMemberCount();
    // End:0x82
    if(a_ID == MYID)
    {
        MYTYPE = a_partyRoomStatus;
    }
    return;
}

function RemoveMember(int a_ID)
{
    local int idx;

    idx = FindMember(a_ID);
    // End:0x1E
    if(idx < 0)
    {
        return;
    }
    lstMember.DeleteRecord(idx);
    CURMEMBER_COUNT--;
    UpdateMemberCount();
    UpdateRelationButton();
    return;
}

function ModifyMember(int a_ID, string a_Name, int a_ClassID, int a_Level, int a_partyRoomStatus)
{
    local int idx;
    local LVDataRecord Record;

    idx = FindMember(a_ID);
    // End:0x1E
    if(idx < 0)
    {
        return;
    }
    Record = makeRecord(a_ID, a_Name, a_ClassID, a_Level, a_partyRoomStatus);
    lstMember.ModifyRecord(idx, Record);
    // End:0x76
    if(a_ID == MYID)
    {
        MYTYPE = a_partyRoomStatus;
    }
    UpdateRelationButton();
    return;
}

function int FindMember(int a_ID)
{
    local int i, recordCount;
    local LVDataRecord Record;

    recordCount = lstMember.GetRecordCount();
    i = 0;
    J0x1C:

    // End:0x6F [Loop If]
    if(i < recordCount)
    {
        lstMember.GetRec(i, Record);
        // End:0x65
        if(Record.LVDataList[0].nReserved1 == a_ID)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x1C;
    }
    return -1;
    return;
}

function LVDataRecord makeRecord(int a_ID, string a_Name, int a_ClassID, int a_Level, int a_partyRoomStatus)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 5;
    Record.LVDataList[0].szData = a_Name;
    Record.LVDataList[0].nReserved1 = a_ID;
    Record.LVDataList[1].szData = string(a_ClassID);
    Record.LVDataList[1].szTexture = GetClassRoleIconName(a_ClassID);
    Record.LVDataList[1].nTextureWidth = 11;
    Record.LVDataList[1].nTextureHeight = 11;
    Record.LVDataList[2].szData = GetAmbiguousLevelString(a_Level, true);
    switch(a_partyRoomStatus)
    {
        // End:0xC4
        case 1:
        // End:0xEA
        case 3:
            Record.LVDataList[3].szData = GetSystemString(2217);
            // End:0x15F
            break;
        // End:0x110
        case 4:
            Record.LVDataList[3].szData = GetSystemString(2218);
            // End:0x15F
            break;
        // End:0x136
        case 5:
            Record.LVDataList[3].szData = GetSystemString(2219);
            // End:0x15F
            break;
        // End:0x15C
        case 6:
            Record.LVDataList[3].szData = GetSystemString(2220);
            // End:0x15F
            break;
        // End:0xFFFF
        default:
            break;
    }
    Record.LVDataList[3].nReserved1 = a_partyRoomStatus;
    return Record;
    return;
}

function OnClickListCtrlRecord(string Id)
{
    // End:0x1B
    if(Id == "lstMember")
    {
        UpdateRelationButton();
    }
    return;
}
