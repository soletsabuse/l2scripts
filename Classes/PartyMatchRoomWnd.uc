class PartyMatchRoomWnd extends PartyMatchWndCommon;

var int RoomNumber;
var int CurPartyMemberCount;
var int MaxPartyMemberCount;
var int MinLevel;
var int MaxLevel;
var int LootingMethodID;
var int MyMembershipType;
var string RoomTitle;
var bool m_bPartyMatchRoomStart;
var bool m_bRequestExitPartyRoom;
var string m_WindowName;
var ListCtrlHandle m_hPartyMatchRoomWndPartyMemberListCtrl;

function OnRegisterEvent()
{
    RegisterEvent(40);
    RegisterEvent(1550);
    RegisterEvent(1560);
    RegisterEvent(1580);
    RegisterEvent(1590);
    RegisterEvent(1600);
    RegisterEvent(1630);
    return;
}

function OnLoad()
{
    m_bPartyMatchRoomStart = false;
    m_bRequestExitPartyRoom = false;
    m_hPartyMatchRoomWndPartyMemberListCtrl = GetListCtrlHandle(m_WindowName $ ".PartyMemberListCtrl");
    MyMembershipType = -1;
    return;
}

function OnSendPacketWhenHiding()
{
    local PartyMatchWnd script;

    script = PartyMatchWnd(GetScript("PartyMatchWnd"));
    // End:0x5A
    if(script != none)
    {
        script.CompletelyQuitPartyMatching = 1;
        script.SetWaitListWnd(false);
        script.ShowHideWaitListWnd();
    }
    ExitPartyRoom();
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x4D
    if(m_bPartyMatchRoomStart)
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyMatchRoomWnd");
    }
    return;
}

function OnEvent(int a_EventID, string param)
{
    switch(a_EventID)
    {
        // End:0x7B
        case 1630:
            // End:0x56
            if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
            {
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
            }
            Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyMatchRoomWnd");
            // End:0xF5
            break;
        // End:0x91
        case 1550:
            HandlePartyMatchRoomStart(param);
            // End:0xF5
            break;
        // End:0xA2
        case 1560:
            HandlePartyMatchRoomClose();
            // End:0xF5
            break;
        // End:0xB8
        case 1580:
            HandlePartyMatchRoomMember(param);
            // End:0xF5
            break;
        // End:0xCE
        case 1590:
            HandlePartyMatchRoomMemberUpdate(param);
            // End:0xF5
            break;
        // End:0xE4
        case 1600:
            HandlePartyMatchChatMessage(param);
            // End:0xF5
            break;
        // End:0xF2
        case 40:
            HandleRestart();
            // End:0xF5
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleRestart()
{
    m_bPartyMatchRoomStart = false;
    return;
}

function ExitPartyRoom()
{
    m_bRequestExitPartyRoom = true;
    switch(MyMembershipType)
    {
        // End:0x13
        case 0:
        // End:0x2F
        case 2:
            Class'NWindow.PartyMatchAPI'.static.RequestWithdrawPartyRoom(RoomNumber);
            // End:0x4D
            break;
        // End:0x4A
        case 1:
            Class'NWindow.PartyMatchAPI'.static.RequestDismissPartyRoom(RoomNumber);
            // End:0x4D
            break;
        // End:0xFFFF
        default:
            break;
    }
    MyMembershipType = -1;
    return;
}

function OnShow()
{
    CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onShow windowName=PartyMatchRoomWnd");
    return;
}

function OnMinimize()
{
    CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onMinimize");
    return;
}

function HandlePartyMatchRoomStart(string param)
{
    local Rect rectWnd;
    local PartyMatchWnd script;

    script = PartyMatchWnd(GetScript("PartyMatchWnd"));
    script.SetIsInParty(true);
    ParseInt(param, "RoomNum", RoomNumber);
    ParseInt(param, "MaxMember", MaxPartyMemberCount);
    ParseInt(param, "MinLevel", MinLevel);
    ParseInt(param, "MaxLevel", MaxLevel);
    ParseInt(param, "LootingMethodID", LootingMethodID);
    ParseString(param, "RoomName", RoomTitle);
    updateData();
    lootingMethodUpdate();
    m_bPartyMatchRoomStart = true;
    Class'NWindow.UIAPI_TEXTLISTBOX'.static.Clear("PartyMatchRoomWnd.PartyRoomChatWindow");
    // End:0x17D
    if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
    {
        CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");        
    }
    else
    {
        rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect("PartyMatchWnd");
        Class'NWindow.UIAPI_WINDOW'.static.MoveTo("PartyMatchRoomWnd", rectWnd.nX, rectWnd.nY);
        UpdateWaitListWnd();
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyMatchRoomWnd");
    }
    return;
}

function UpdateWaitListWnd()
{
    local string strName;
    local int roleIndex;
    local PartyMatchWnd script;

    script = PartyMatchWnd(GetScript("PartyMatchWnd"));
    // End:0xBA
    if(script != none)
    {
        // End:0xBA
        if(script.IsShowWaitListWnd())
        {
            strName = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchWaitListWnd.Name");
            roleIndex = GetComboBoxHandle("PartyMatchWaitListWnd.Job").GetSelectedNum();
            RequestPartyMatchWaitList(1, MinLevel, MaxLevel, roleIndex, strName);
        }
    }
    return;
}

function OnHide()
{
    CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=onHide");
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PartyMatchMakeRoomWnd");
    return;
}

function HandlePartyMatchRoomClose()
{
    local PartyMatchWnd script;
    local PartyMatchMakeRoomWnd script2;
    local PartyWnd Script3;

    script = PartyMatchWnd(GetScript("PartyMatchWnd"));
    script.SetIsInParty(false);
    Script3 = PartyWnd(GetScript("PartyWnd"));
    Script3.m_AmIRoomMaster = false;
    m_bPartyMatchRoomStart = false;
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PartyMatchRoomWnd");
    // End:0x10B
    if(m_bRequestExitPartyRoom)
    {
        script = PartyMatchWnd(GetScript("PartyMatchWnd"));
        // End:0xC9
        if(script != none)
        {
            script.OnRefreshBtnClick();
        }
        script2 = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));
        // End:0x10B
        if(script2 != none)
        {
            script2.OnCancelButtonClick();
        }
    }
    m_bRequestExitPartyRoom = false;
    return;
}

function UpdateMyMembershipType()
{
    local PartyWnd script;
    local PartyMatchWaitListWnd script2;

    script = PartyWnd(GetScript("PartyWnd"));
    script2 = PartyMatchWaitListWnd(GetScript("PartyMatchWaitListWnd"));
    switch(MyMembershipType)
    {
        // End:0x4E
        case 0:
        // End:0x112
        case 2:
            Class'NWindow.UIAPI_BUTTON'.static.DisableWindow("PartyMatchRoomWnd.RoomSettingButton");
            Class'NWindow.UIAPI_BUTTON'.static.DisableWindow("PartyMatchRoomWnd.BanButton");
            Class'NWindow.UIAPI_BUTTON'.static.DisableWindow("PartyMatchRoomWnd.InviteButton");
            Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.ExitButton");
            // End:0x1E9
            break;
        // End:0x1E6
        case 1:
            script.m_AmIRoomMaster = true;
            Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.RoomSettingButton");
            Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.BanButton");
            Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.InviteButton");
            Class'NWindow.UIAPI_BUTTON'.static.EnableWindow("PartyMatchRoomWnd.ExitButton");
            // End:0x1E9
            break;
        // End:0xFFFF
        default:
            break;
    }
    script2.UpdateMyMembershipType(MyMembershipType);
    return;
}

function HandlePartyMatchRoomMember(string param)
{
    local int i, ClassID, Level, MemberID;
    local string memberName;
    local int MembershipType;
    local PartyMatchWaitListWnd script;
    local int RestrictZoneCnt;
    local string RestrictZoneID;
    local int temp, j;

    script = PartyMatchWaitListWnd(GetScript("PartyMatchWaitListWnd"));
    ParseInt(param, "MyMembershipType", MyMembershipType);
    UpdateMyMembershipType();
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("PartyMatchRoomWnd.PartyMemberListCtrl");
    ParseInt(param, "MemberCount", CurPartyMemberCount);
    i = 0;
    J0xAA:

    // End:0x271 [Loop If]
    if(i < CurPartyMemberCount)
    {
        ParseInt(param, "MemberID_" $ string(i), MemberID);
        ParseString(param, "MemberName_" $ string(i), memberName);
        ParseInt(param, "ClassID_" $ string(i), ClassID);
        ParseInt(param, "Level_" $ string(i), Level);
        ParseInt(param, "MembershipType_" $ string(i), MembershipType);
        ParseInt(param, "RestrictZoneCnt_" $ string(i), RestrictZoneCnt);
        // End:0x1AF
        if(RestrictZoneCnt == 0)
        {
            RestrictZoneID = "";
        }
        j = 0;
        J0x1B6:

        // End:0x243 [Loop If]
        if(j < RestrictZoneCnt)
        {
            ParseInt(param, (("RestrictZoneID_" $ string(i)) $ "_") $ string(j), temp);
            // End:0x228
            if(j != 0)
            {
                RestrictZoneID = (RestrictZoneID $ ",") $ GetInZoneNameWithZoneID(temp);
                // [Explicit Continue]
                goto J0x239;
            }
            RestrictZoneID = GetInZoneNameWithZoneID(temp);
            J0x239:

            j++;
            // [Loop Continue]
            goto J0x1B6;
        }
        AddMember(MemberID, memberName, ClassID, Level, MembershipType, RestrictZoneID);
        ++i;
        // [Loop Continue]
        goto J0xAA;
    }
    updateData();
    // End:0x2D4
    if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
    {
        CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");
    }
    // End:0x321
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PartyMatchRoomWnd.PartyMatchWaitListWnd") == true)
    {
        script.OnRefreshButtonClick();
    }
    return;
}

function AddMember(int a_MemberID, string a_MemberName, int a_ClassID, int a_Level, int a_MembershipType, string a_RestrictZoneID)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 5;
    Record.LVDataList[0].nReserved1 = a_MemberID;
    Record.LVDataList[0].szData = a_MemberName;
    Record.LVDataList[1].szData = string(a_ClassID);
    Record.LVDataList[1].szTexture = GetClassRoleIconName(a_ClassID);
    Record.LVDataList[1].nTextureWidth = 11;
    Record.LVDataList[1].nTextureHeight = 11;
    Record.LVDataList[2].szData = GetAmbiguousLevelString(a_Level, true);
    switch(a_MembershipType)
    {
        // End:0xE5
        case 0:
            Record.LVDataList[3].szData = GetSystemString(1061);
            // End:0x133
            break;
        // End:0x10A
        case 1:
            Record.LVDataList[3].szData = GetSystemString(1062);
            // End:0x133
            break;
        // End:0x130
        case 2:
            Record.LVDataList[3].szData = GetSystemString(1063);
            // End:0x133
            break;
        // End:0xFFFF
        default:
            break;
    }
    Record.LVDataList[4].szData = a_RestrictZoneID;
    Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("PartyMatchRoomWnd.PartyMemberListCtrl", Record);
    return;
}

function RemoveMember(int a_MemberID)
{
    local int recordCount, i;
    local LVDataRecord Record;

    recordCount = m_hPartyMatchRoomWndPartyMemberListCtrl.GetRecordCount();
    i = 0;
    J0x1C:

    // End:0x80 [Loop If]
    if(i < recordCount)
    {
        m_hPartyMatchRoomWndPartyMemberListCtrl.GetRec(i, Record);
        // End:0x76
        if(Record.LVDataList[0].nReserved1 == a_MemberID)
        {
            m_hPartyMatchRoomWndPartyMemberListCtrl.DeleteRecord(i);
            // [Explicit Break]
            goto J0x80;
        }
        ++i;
        // [Loop Continue]
        goto J0x1C;
    }
    J0x80:

    return;
}

function HandlePartyMatchRoomMemberUpdate(string param)
{
    local int UpdateType, MemberID;
    local string memberName;
    local int ClassID, Level, MembershipType;
    local UserInfo PlayerInfo;
    local PartyMatchWaitListWnd script;
    local int RestrictZoneCnt;
    local string RestrictZoneID;
    local int temp, i;

    script = PartyMatchWaitListWnd(GetScript("PartyMatchWaitListWnd"));
    ParseInt(param, "UpdateType", UpdateType);
    ParseInt(param, "MemberID", MemberID);
    switch(UpdateType)
    {
        // End:0x1C4
        case 0:
            ParseString(param, "MemberName", memberName);
            ParseInt(param, "ClassID", ClassID);
            ParseInt(param, "Level", Level);
            ParseInt(param, "MembershipType", MembershipType);
            ParseInt(param, "RestrictZoneCnt", RestrictZoneCnt);
            // End:0x109
            if(RestrictZoneCnt == 0)
            {
                RestrictZoneID = "";
            }
            i = 0;
            J0x110:

            // End:0x18F [Loop If]
            if(i < RestrictZoneCnt)
            {
                ParseInt(param, "RestrictZoneID_" $ string(i), temp);
                // End:0x174
                if(i != 0)
                {
                    RestrictZoneID = (RestrictZoneID $ ",") $ GetInZoneNameWithZoneID(temp);
                    // [Explicit Continue]
                    goto J0x185;
                }
                RestrictZoneID = GetInZoneNameWithZoneID(temp);
                J0x185:

                i++;
                // [Loop Continue]
                goto J0x110;
            }
            AddMember(MemberID, memberName, ClassID, Level, MembershipType, RestrictZoneID);
            CurPartyMemberCount = CurPartyMemberCount + 1;
            // End:0x360
            break;
        // End:0x33C
        case 1:
            ParseString(param, "MemberName", memberName);
            ParseInt(param, "ClassID", ClassID);
            ParseInt(param, "Level", Level);
            ParseInt(param, "MembershipType", MembershipType);
            ParseInt(param, "RestrictZoneCnt", RestrictZoneCnt);
            // End:0x268
            if(RestrictZoneCnt == 0)
            {
                RestrictZoneID = "";
            }
            i = 0;
            J0x26F:

            // End:0x2EE [Loop If]
            if(i < RestrictZoneCnt)
            {
                ParseInt(param, "RestrictZoneID_" $ string(i), temp);
                // End:0x2D3
                if(i != 0)
                {
                    RestrictZoneID = (RestrictZoneID $ ",") $ GetInZoneNameWithZoneID(temp);
                    // [Explicit Continue]
                    goto J0x2E4;
                }
                RestrictZoneID = GetInZoneNameWithZoneID(temp);
                J0x2E4:

                i++;
                // [Loop Continue]
                goto J0x26F;
            }
            RemoveMember(MemberID);
            CurPartyMemberCount = CurPartyMemberCount - 1;
            AddMember(MemberID, memberName, ClassID, Level, MembershipType, RestrictZoneID);
            CurPartyMemberCount = CurPartyMemberCount + 1;
            // End:0x360
            break;
        // End:0x35D
        case 2:
            RemoveMember(MemberID);
            CurPartyMemberCount = CurPartyMemberCount - 1;
            // End:0x360
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x393
    if(GetPlayerInfo(PlayerInfo))
    {
        // End:0x393
        if(PlayerInfo.nID == MemberID)
        {
            MyMembershipType = MembershipType;
            UpdateMyMembershipType();
        }
    }
    // End:0x3F0
    if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
    {
        CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");
    }
    updateData();
    // End:0x443
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PartyMatchRoomWnd.PartyMatchWaitListWnd") == true)
    {
        script.OnRefreshButtonClick();
    }
    return;
}

function HandlePartyMatchChatMessage(string param)
{
    local Color ChatColor;
    local string chatMessage;
    local int tmpType;

    ParseString(param, "Msg", chatMessage);
    ParseInt(param, "SayType", tmpType);
    ChatColor = GetChatColorByType(tmpType);
    Class'NWindow.UIAPI_TEXTLISTBOX'.static.AddString("PartyMatchRoomWnd.PartyRoomChatWindow", chatMessage, ChatColor);
    // End:0x101
    if(Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("PartyMatchRoomWnd"))
    {
        PlaySound("ItemSound3.Sys_party_matching");
        CallGFxFunction("ExpBar", "PartyMatchWndGFxEvent", "state=highlightOn");
    }
    return;
}

function updateData()
{
    local int minNum, maxNum;
    local PartyMatchMakeRoomWnd partyMatchMakeRoomWndHandle;

    partyMatchMakeRoomWndHandle = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.RoomNumber", string(RoomNumber));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.RoomTitle", RoomTitle);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.PartyMemberCount", (string(CurPartyMemberCount) $ "/") $ string(MaxPartyMemberCount));
    // End:0x12D
    if(getInstanceUIData().getIsClassicServer())
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LevelLimit", (string(MinLevel) $ "-") $ string(MaxLevel));        
    }
    else
    {
        switch(MyMembershipType)
        {
            // End:0x138
            case 0:
            // End:0x200
            case 2:
                // End:0x168
                if(MinLevel >= getInstanceUIData().MAXLV)
                {
                    MinLevel = getInstanceUIData().85;
                }
                // End:0x193
                if(MaxLevel >= getInstanceUIData().MAXLV)
                {
                    MaxLevel = getInstanceUIData().85;
                }
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LevelLimit", (string(MinLevel) $ "-") $ string(MaxLevel));
                partyMatchMakeRoomWndHandle.SetMaxLevel(MaxLevel);
                partyMatchMakeRoomWndHandle.SetMinLevel(MinLevel);
                // End:0x331
                break;
            // End:0x32E
            case 1:
                // End:0x22F
                if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PartyMatchMakeRoomWnd"))
                {
                    return;
                }
                minNum = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox"));
                maxNum = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox"));
                // End:0x2BD
                if(minNum == 0)
                {
                    minNum = 1;
                }
                // End:0x2CF
                if(maxNum == 0)
                {
                    maxNum = 1;
                }
                // End:0x2E9
                if(minNum > maxNum)
                {
                    maxNum = minNum;
                }
                Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LevelLimit", (string(minNum) $ "-") $ string(maxNum));
                // End:0x331
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    return;
}

function lootingMethodUpdate()
{
    local L2Util util;

    util = L2Util(GetScript("L2Util"));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("PartyMatchRoomWnd.LootingMethod", util.getLootingString(LootingMethodID));
    return;
}

function OnClickButton(string a_strButtonName)
{
    switch(a_strButtonName)
    {
        // End:0x23
        case "WaitListButton":
            OnWaitListButtonClick();
            // End:0x8E
            break;
        // End:0x42
        case "RoomSettingButton":
            OnRoomSettingButtonClick();
            // End:0x8E
            break;
        // End:0x59
        case "BanButton":
            OnBanButtonClick();
            // End:0x8E
            break;
        // End:0x73
        case "InviteButton":
            OnInviteButtonClick();
            // End:0x8E
            break;
        // End:0x8B
        case "ExitButton":
            OnExitButtonClick();
            // End:0x8E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnWaitListButtonClick()
{
    local PartyMatchWnd script;

    script = PartyMatchWnd(GetScript("PartyMatchWnd"));
    // End:0x40
    if(script != none)
    {
        script.ToggleWaitListWnd();
        UpdateWaitListWnd();
    }
    return;
}

function OnRoomSettingButtonClick()
{
    local PartyMatchMakeRoomWnd script;
    local int minNum, maxNum;

    script = PartyMatchMakeRoomWnd(GetScript("PartyMatchMakeRoomWnd"));
    // End:0x1A9
    if(script != none)
    {
        script.InviteState = script.2;
        script.SetRoomNumber(RoomNumber);
        script.SetTitle(RoomTitle);
        script.SetMaxPartyMemberCount(MaxPartyMemberCount);
        // End:0xC7
        if(getInstanceUIData().getIsClassicServer())
        {
            script.SetMinLevel(MinLevel);
            script.SetMaxLevel(MaxLevel);            
        }
        else
        {
            minNum = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MinLevelEditBox"));
            maxNum = int(Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchMakeRoomWnd.MaxLevelEditBox"));
            // End:0x155
            if(minNum == 0)
            {
                minNum = 1;
            }
            // End:0x167
            if(maxNum == 0)
            {
                maxNum = 1;
            }
            // End:0x181
            if(minNum > maxNum)
            {
                maxNum = minNum;
            }
            script.SetMinLevel(minNum);
            script.SetMaxLevel(maxNum);
        }
    }
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("PartyMatchMakeRoomWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyMatchMakeRoomWnd");
    return;
}

function OnBanButtonClick()
{
    local LVDataRecord Record;

    m_hPartyMatchRoomWndPartyMemberListCtrl.GetSelectedRec(Record);
    Class'NWindow.PartyMatchAPI'.static.RequestBanFromPartyRoom(Record.LVDataList[0].nReserved1);
    return;
}

function OnInviteButtonClick()
{
    local LVDataRecord Record;

    m_hPartyMatchRoomWndPartyMemberListCtrl.GetSelectedRec(Record);
    RequestInviteParty(Record.LVDataList[0].szData);
    return;
}

function OnExitButtonClick()
{
    ExitPartyRoom();
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("PartyMatchRoomWnd");
    return;
}

function OnCompleteEditBox(string strID)
{
    local string ChatMsg;

    // End:0xA3
    if(strID == "PartyRoomChatEditBox")
    {
        ChatMsg = Class'NWindow.UIAPI_EDITBOX'.static.GetString("PartyMatchRoomWnd.PartyRoomChatEditBox");
        ProcessPartyMatchChatMessage(14, ChatMsg);
        Class'NWindow.UIAPI_EDITBOX'.static.SetString("PartyMatchRoomWnd.PartyRoomChatEditBox", "");
    }
    return;
}

function OnChatMarkedEditBox(string strID)
{
    local Color ChatColor;

    // End:0x9C
    if(strID == "PartyRoomChatEditBox")
    {
        ChatColor.R = 176;
        ChatColor.G = 155;
        ChatColor.B = 121;
        ChatColor.A = byte(255);
        Class'NWindow.UIAPI_TEXTLISTBOX'.static.AddString("PartyMatchRoomWnd.PartyRoomChatWindow", GetSystemMessage(966), ChatColor);
    }
    return;
}

defaultproperties
{
    m_WindowName="PartyMatchRoomWnd"
}