class PersonalConnectionsWnd extends UICommonAPI;

const FRIENDLIST_LIMIT = 128;
const BLOCKLIST_LIMIT = 512;
const MENTEE_LIST_LIMIT = 3;
const MENTOR_LIST_LIMIT = 1;
const DIALOG_PersonalConnectionFriendListRemove = 90007;
const DIALOG_PersonalConnectionBlockListRemove = 90008;
const DIALOG_PersonalConnectionMenteeListRemove = 90020;
const DIALOG_PersonalConnectionConfirmMentee = 90021;

struct relationMemberInfo
{
    var string Name;
    var int UserID;
    var int ClassID;
    var int Level;
    var bool bOnline;
};

var WindowHandle Me;
var PersonalConnectionsDrawerWnd m_PersonalConnectionsDrawerWnd;
var TabHandle ConnectionsListSelectTab;
var TextureHandle ConnectionsListSelectTabBgLine;
var TextureHandle TexTabBg;
var TextBoxHandle ListTitle;
var TextBoxHandle ListCount;
var ButtonHandle ListPlusBtn;
var ButtonHandle ListMinusBtn;
var ButtonHandle ListBlockBtn;
var TextureHandle ListDeco;
var ListCtrlHandle FriendList;
var ListCtrlHandle BlockList;
var ListCtrlHandle MentoringList;
var TextureHandle GroupBox1;
var TextureHandle GroupBox2;
var ButtonHandle InvitePartyBtn;
var ButtonHandle SendPostBtn;
var ButtonHandle InviteClanBtn;
var ButtonHandle WhisperBtn;
var ButtonHandle DetailInfoBtn;
var ButtonHandle OneOnOneTalkBtn;
var int selectedFriendListIndex;
var int selectedBlockListIndex;
var int nClanJoin;
var L2Util util;
var int mentorMenTeeRole;
var TextBoxHandle GuideTitle;
var TextBoxHandle Guide;
var TextureHandle GroupBox_MentoringList1;
var TextureHandle GroupBox_MentoringList2;
var TextureHandle GroupBox_FriendBlockList;
var UserInfo myUserInfo;
var TextBoxHandle NameEnterLimit;
var TextBoxHandle NameEnterLimitTime;
var string MentorName;
var array<relationMemberInfo> friendListArray;
var array<relationMemberInfo> clanListArray;
var array<relationMemberInfo> blockListArray;

function OnRegisterEvent()
{
    RegisterEvent(40);
    RegisterEvent(340);
    RegisterEvent(5400);
    RegisterEvent(5401);
    RegisterEvent(5402);
    RegisterEvent(5403);
    RegisterEvent(5404);
    RegisterEvent(5390);
    RegisterEvent(5391);
    RegisterEvent(5392);
    RegisterEvent(5393);
    RegisterEvent(5394);
    RegisterEvent(5411);
    RegisterEvent(9220);
    RegisterEvent(5800);
    RegisterEvent(5810);
    RegisterEvent(5820);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(8000);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    util = L2Util(GetScript("L2Util"));
    Initialize();
    load();
    ConnectionsListSelectTab.SetDisable(2, true);
    selectedFriendListIndex = -1;
    selectedBlockListIndex = -1;
    GetPlayerInfo(myUserInfo);
    return;
}

function OnShow()
{
    MentorName = "";
    Class'NWindow.PersonalConnectionAPI'.static.RequestFriendInfoList();
    Class'NWindow.PersonalConnectionAPI'.static.RequestBlockInfoList();
    // End:0x4A
    if(!getInstanceUIData().getIsArenaServer())
    {
        Class'NWindow.PersonalConnectionAPI'.static.RequestMentorList();
    }
    GetPlayerInfo(myUserInfo);
    listTextUpdate();
    checkClanButtonState();
    // End:0x98
    if(ConnectionsListSelectTab.GetTopIndex() == 2)
    {
        GuideTitle.ShowWindow();
        Guide.ShowWindow();        
    }
    else
    {
        GuideTitle.HideWindow();
        Guide.HideWindow();
    }
    return;
}

function checkClassicForm()
{
    // End:0x88
    if(getInstanceUIData().getIsClassicServer())
    {
        ConnectionsListSelectTab.SetTopOrder(0, false);
        ConnectionsListSelectTab.SetButtonDisableTexture(2, "L2UI_ct1.Misc_DF_Blank");
        ConnectionsListSelectTab.SetDisable(2, true);
        ConnectionsListSelectTab.SetButtonName(2, "");
        ConnectionsListSelectTabBgLine.SetWindowSize(137, 24);        
    }
    else
    {
        // End:0x11A
        if(getInstanceUIData().getIsArenaServer())
        {
            ConnectionsListSelectTab.RemoveTabControl(2);
            ConnectionsListSelectTabBgLine.SetWindowSize(137, 24);
            OneOnOneTalkBtn.SetAnchor("PersonalConnectionsWnd.InviteClanBtn", "TopLeft", "TopLeft", 0, 0);
            InviteClanBtn.HideWindow();            
        }
        else
        {
            ConnectionsListSelectTab.SetButtonName(2, GetSystemString(2767));
            ConnectionsListSelectTab.SetDisable(2, false);
            ConnectionsListSelectTabBgLine.SetWindowSize(74, 24);
        }
    }
    return;
}

function Initialize()
{
    Me = GetWindowHandle("PersonalConnectionsWnd");
    m_PersonalConnectionsDrawerWnd = PersonalConnectionsDrawerWnd(GetScript("PersonalConnectionsDrawerWnd"));
    ConnectionsListSelectTab = GetTabHandle("PersonalConnectionsWnd.ConnectionsListSelectTab");
    ConnectionsListSelectTabBgLine = GetTextureHandle("PersonalConnectionsWnd.ConnectionsListSelectTabBgLine");
    TexTabBg = GetTextureHandle("PersonalConnectionsWnd.TexTabBg");
    ListDeco = GetTextureHandle("PersonalConnectionsWnd.ListDeco");
    ListTitle = GetTextBoxHandle("PersonalConnectionsWnd.ListTitle");
    ListCount = GetTextBoxHandle("PersonalConnectionsWnd.ListCount");
    ListPlusBtn = GetButtonHandle("PersonalConnectionsWnd.ListPlusBtn");
    ListMinusBtn = GetButtonHandle("PersonalConnectionsWnd.ListMinusBtn");
    ListBlockBtn = GetButtonHandle("PersonalConnectionsWnd.ListBlockBtn");
    FriendList = GetListCtrlHandle("PersonalConnectionsWnd.FriendList");
    BlockList = GetListCtrlHandle("PersonalConnectionsWnd.BlockList");
    MentoringList = GetListCtrlHandle("PersonalConnectionsWnd.MentoringList");
    GroupBox1 = GetTextureHandle("PersonalConnectionsWnd.GroupBox1");
    GroupBox2 = GetTextureHandle("PersonalConnectionsWnd.GroupBox2");
    InvitePartyBtn = GetButtonHandle("PersonalConnectionsWnd.InvitePartyBtn");
    SendPostBtn = GetButtonHandle("PersonalConnectionsWnd.SendPostBtn");
    InviteClanBtn = GetButtonHandle("PersonalConnectionsWnd.InviteClanBtn");
    WhisperBtn = GetButtonHandle("PersonalConnectionsWnd.WhisperBtn");
    DetailInfoBtn = GetButtonHandle("PersonalConnectionsWnd.DetailInfoBtn");
    OneOnOneTalkBtn = GetButtonHandle("PersonalConnectionsWnd.OneOnOneTalkBtn");
    GuideTitle = GetTextBoxHandle("PersonalConnectionsWnd.GuideTitle");
    Guide = GetTextBoxHandle("PersonalConnectionsWnd.Guide");
    NameEnterLimit = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimit");
    NameEnterLimitTime = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimitTime");
    GroupBox_MentoringList1 = GetTextureHandle("PersonalConnectionsWnd.GroupBox_MentoringList1");
    GroupBox_MentoringList2 = GetTextureHandle("PersonalConnectionsWnd.GroupBox_MentoringList2");
    GroupBox_FriendBlockList = GetTextureHandle("PersonalConnectionsWnd.GroupBox_FriendBlockList");
    GuideTitle.HideWindow();
    Guide.HideWindow();
    setTextureVisible(0);
    GuideTitle.SetText(GetSystemString(2773));
    Guide.SetText(GetSystemString(2770));
    listTextUpdate();
    return;
}

function load()
{
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x15
        case 40:
            restartHandler();
            // End:0x203
            break;
        // End:0x4A
        case 340:
            Debug("EV_ClanMyAuth : " @ param);
            HandleClanMyAuth(param);
            // End:0x203
            break;
        // End:0x5B
        case 5390:
            friendInfoListEmptyHandle();
            // End:0x203
            break;
        // End:0x75
        case 5411:
            Me.ShowWindow();
            // End:0x203
            break;
        // End:0x91
        case 5391:
            friendAddedHandle(param);
            listTextUpdate();
            // End:0x203
            break;
        // End:0xAD
        case 5392:
            friendRemovedHandle(param);
            listTextUpdate();
            // End:0x203
            break;
        // End:0xC9
        case 5393:
            friendInfoUpdateHandle(param);
            listTextUpdate();
            // End:0x203
            break;
        // End:0xE5
        case 5394:
            userDetailInfoUpdateHandle(param);
            listTextUpdate();
            // End:0x203
            break;
        // End:0xFF
        case 5400:
            BlockList.DeleteAllItem();
            // End:0x203
            break;
        // End:0x11B
        case 5401:
            blockAddedHandler(param);
            listTextUpdate();
            // End:0x203
            break;
        // End:0x137
        case 5403:
            blockInfoUpdateHandler(param);
            listTextUpdate();
            // End:0x203
            break;
        // End:0x153
        case 5404:
            blockDetailInfoUpdateHandler(param);
            listTextUpdate();
            // End:0x203
            break;
        // End:0x16F
        case 5402:
            blockRemovedHandler(param);
            listTextUpdate();
            // End:0x203
            break;
        // End:0x17A
        case 5410:
            // End:0x203
            break;
        // End:0x185
        case 9220:
            // End:0x203
            break;
        // End:0x196
        case 1710:
            HandleDialogOK();
            // End:0x203
            break;
        // End:0x1A7
        case 1720:
            HandleDialogCancel();
            // End:0x203
            break;
        // End:0x1BD
        case 5810:
            mentorMenteeListStartHandler(param);
            // End:0x203
            break;
        // End:0x1D9
        case 5820:
            menTorMenTeeAddedHandle(param);
            listTextUpdate();
            // End:0x203
            break;
        // End:0x1EF
        case 5800:
            conFirmMenteeDialogHandler(param);
            // End:0x203
            break;
        // End:0x200
        case 8000:
            checkClassicForm();
            // End:0x203
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function setTextureVisible(int tabindex)
{
    switch(tabindex)
    {
        // End:0x0B
        case 0:
        // End:0x5D
        case 1:
            GroupBox_MentoringList1.DisableWindow();
            GroupBox_MentoringList2.DisableWindow();
            GroupBox_FriendBlockList.ShowWindow();
            NameEnterLimit.HideWindow();
            NameEnterLimitTime.HideWindow();
            // End:0xB3
            break;
        // End:0xB0
        case 2:
            GroupBox_MentoringList1.ShowWindow();
            GroupBox_MentoringList2.ShowWindow();
            GroupBox_FriendBlockList.DisableWindow();
            NameEnterLimit.ShowWindow();
            NameEnterLimitTime.ShowWindow();
            // End:0xB3
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function mentorMenteeListStartHandler(string param)
{
    GetPlayerInfo(myUserInfo);
    MentoringList.DeleteAllItem();
    ParseInt(param, "Role", mentorMenTeeRole);
    switch(mentorMenTeeRole)
    {
        // End:0xA0
        case 0:
            // End:0x7A
            if((myUserInfo.nLevel >= 85) && GetClassTransferDegree(myUserInfo.nSubClass) > 3)
            {
                ConnectionsListSelectTab.SetDisable(2, false);                
            }
            else
            {
                ConnectionsListSelectTab.SetDisable(2, true);
                ConnectionsListSelectTab.SetTopOrder(0, false);
            }
            // End:0x101
            break;
        // End:0xB9
        case 1:
            ConnectionsListSelectTab.SetDisable(2, false);
            // End:0x101
            break;
        // End:0xD3
        case 2:
            ConnectionsListSelectTab.SetDisable(2, false);
            // End:0x101
            break;
        // End:0xFFFF
        default:
            Debug("Error : mentorMenTeeRole :" @ string(mentorMenTeeRole));
            break;
    }
    listTextUpdate();
    return;
}

function menTorMenTeeAddedHandle(string param)
{
    local LVDataRecord Record;

    setListRecord(Record, param);
    MentoringList.InsertRecord(Record);
    return;
}

function conFirmMenteeDialogHandler(string param)
{
    askDialog(90021, param);
    return;
}

function restartHandler()
{
    subWindowClose();
    buttonsEnabled(true);
    ConnectionsListSelectTab.SetTopOrder(0, false);
    OnShow();
    return;
}

function notifyImportedCrestImageHandler(string param)
{
    OnClickListCtrlRecord("FriendList");
    return;
}

function setListRecord(out LVDataRecord Record, string param)
{
    local string Name, memo;
    local int ClassID, Level, Status;
    local Color TextColor;

    Record.LVDataList.Length = 4;
    ParseString(param, "Name", Name);
    ParseString(param, "memo", memo);
    ParseInt(param, "ClassID", ClassID);
    ParseInt(param, "Level", Level);
    ParseInt(param, "Status", Status);
    TextColor = util.White;
    // End:0xB8
    if(Status == 1)
    {
        TextColor = util.BrightWhite;        
    }
    else
    {
        // End:0xDB
        if(Status == 2)
        {
            TextColor = util.PowderPink;            
        }
        else
        {
            // End:0xFB
            if(Status == 3)
            {
                TextColor = util.HotPink;
            }
        }
    }
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[0].TextColor = TextColor;
    Record.LVDataList[1].bUseTextColor = true;
    Record.LVDataList[1].TextColor = TextColor;
    Record.szReserved = memo;
    Record.LVDataList[0].szData = Name;
    Record.LVDataList[1].szData = string(Level);
    Record.LVDataList[2].szData = string(ClassID);
    Record.LVDataList[2].szTexture = GetClassRoleIconName(ClassID);
    Record.LVDataList[2].HiddenStringForSorting = string(GetClassRoleType(ClassID));
    Record.LVDataList[2].nTextureWidth = 11;
    Record.LVDataList[2].nTextureHeight = 11;
    Record.LVDataList[3].nTextureWidth = 31;
    Record.LVDataList[3].nTextureHeight = 11;
    Record.nReserved1 = (0);
    // End:0x2A9
    if(Status > 0)
    {
        Record.LVDataList[3].szData = "1";
        Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";        
    }
    else
    {
        Record.LVDataList[3].szData = "0";
        Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
    }
    return;
}

function friendInfoListEmptyHandle()
{
    FriendList.DeleteAllItem();
    return;
}

function friendAddedHandle(string param)
{
    local LVDataRecord Record;

    setListRecord(Record, param);
    FriendList.InsertRecord(Record);
    return;
}

function friendRemovedHandle(string param)
{
    local string Name;
    local int i;

    ParseString(param, "Name", Name);
    i = util.ctrlListSearchByName(FriendList, Name);
    // End:0x58
    if(i != -1)
    {
        FriendList.DeleteRecord(i);
    }
    // End:0x76
    if(FriendList.GetRecordCount() <= 0)
    {
        subWindowClose();        
    }
    else
    {
        // End:0xBB
        if(FriendList.GetSelectedIndex() == FriendList.GetRecordCount())
        {
            FriendList.SetSelectedIndex(FriendList.GetSelectedIndex() - 1, false);
        }
        OnClickListCtrlRecord("FriendList");
    }
    return;
}

function friendInfoUpdateHandle(string param)
{
    local LVDataRecord Record, tempRecord;
    local string Name;
    local int i;

    FriendList.ClearTooltip();
    ParseString(param, "Name", Name);
    setListRecord(Record, param);
    i = 0;
    J0x3C:

    // End:0xAF [Loop If]
    if(i < FriendList.GetRecordCount())
    {
        FriendList.GetRec(i, tempRecord);
        // End:0xA5
        if(tempRecord.LVDataList[0].szData == Name)
        {
            FriendList.ModifyRecord(i, Record);
            // [Explicit Break]
            goto J0xAF;
        }
        i++;
        // [Loop Continue]
        goto J0x3C;
    }
    J0xAF:

    return;
}

function userDetailInfoUpdateHandle(string param)
{
    local string Name, memo;
    local int ClassID, Level, Status, PledgeID, allianceID, birthMonth,
	    birthDay, logoutDiffSeconds;

    ParseString(param, "Name", Name);
    ParseString(param, "memo", memo);
    ParseInt(param, "ClassID", ClassID);
    ParseInt(param, "Level", Level);
    ParseInt(param, "Status", Status);
    ParseInt(param, "pledgeID", PledgeID);
    ParseInt(param, "allianceID", allianceID);
    ParseInt(param, "birthMonth", birthMonth);
    ParseInt(param, "birthDay", birthDay);
    ParseInt(param, "logoutDiffSeconds", logoutDiffSeconds);
    m_PersonalConnectionsDrawerWnd.setDetailInfo(Name, Level, ClassID, PledgeID, allianceID, birthMonth, birthDay, logoutDiffSeconds, memo);
    return;
}

function setBlockRecord(out LVDataRecord Record, string param)
{
    local string Name, memo;

    Record.LVDataList.Length = 1;
    ParseString(param, "Name", Name);
    ParseString(param, "memo", memo);
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[0].szData = Name;
    Record.LVDataList[0].TextColor = util.Gold;
    Record.nReserved1 = (0);
    return;
}

function blockInfoListEmptyHandler()
{
    BlockList.DeleteAllItem();
    return;
}

function blockAddedHandler(string param)
{
    local LVDataRecord Record;

    setBlockRecord(Record, param);
    BlockList.InsertRecord(Record);
    return;
}

function blockRemovedHandler(string param)
{
    local string Name;
    local int i;

    ParseString(param, "Name", Name);
    i = util.ctrlListSearchByName(BlockList, Name);
    // End:0x58
    if(i != -1)
    {
        BlockList.DeleteRecord(i);
    }
    // End:0x76
    if(BlockList.GetRecordCount() <= 0)
    {
        subWindowClose();        
    }
    else
    {
        // End:0xBB
        if(BlockList.GetSelectedIndex() == BlockList.GetRecordCount())
        {
            BlockList.SetSelectedIndex(BlockList.GetSelectedIndex() - 1, false);
        }
        OnClickListCtrlRecord("BlockList");
    }
    return;
}

function blockInfoUpdateHandler(string param)
{
    local LVDataRecord Record, tempRecord;
    local string Name;
    local int i;

    ParseString(param, "Name", Name);
    setBlockRecord(Record, param);
    i = 0;
    J0x2D:

    // End:0xA0 [Loop If]
    if(i < BlockList.GetRecordCount())
    {
        BlockList.GetRec(i, tempRecord);
        // End:0x96
        if(tempRecord.LVDataList[0].szData == Name)
        {
            BlockList.ModifyRecord(i, Record);
            // [Explicit Break]
            goto J0xA0;
        }
        i++;
        // [Loop Continue]
        goto J0x2D;
    }
    J0xA0:

    return;
}

function blockDetailInfoUpdateHandler(string param)
{
    local string Name, memo;

    ParseString(param, "Name", Name);
    ParseString(param, "memo", memo);
    m_PersonalConnectionsDrawerWnd.setDetailInfo(Name, 0, 0, 0, 0, 0, 0, 0, memo);
    return;
}

function askDialog(int dialogID, optional string mParam)
{
    local int ClassID, Level;
    local LVDataRecord Record;

    // End:0x2B
    if(IsShowWindow("DialogBox"))
    {
        Class'NWindow.PersonalConnectionAPI'.static.ConfirmMenteeAdd(MentorName, 0);
        return;
    }
    DialogSetID(dialogID);
    // End:0x6C
    if(90007 == dialogID)
    {
        DialogShow(1, 0, MakeFullSystemMsg(GetSystemMessage(3307), getUserNameByList()), string(self));        
    }
    else
    {
        // End:0xA2
        if(90008 == dialogID)
        {
            DialogShow(1, 0, MakeFullSystemMsg(GetSystemMessage(3708), getUserNameByList()), string(self));            
        }
        else
        {
            // End:0xEC
            if(90020 == dialogID)
            {
                MentoringList.GetSelectedRec(Record);
                DialogShow(1, 0, MakeFullSystemMsg(GetSystemMessage(3711), getUserNameByList()), string(self));                
            }
            else
            {
                // End:0x19E
                if(90021 == dialogID)
                {
                    ParseString(mParam, "MentorName", MentorName);
                    ParseInt(mParam, "ClassID", ClassID);
                    ParseInt(mParam, "Level", Level);
                    DialogSetCancelD(90021);
                    DialogSetParamInt64((10 * 1000));
                    DialogSetDefaultCancle();
                    DialogShow(1, 7, MakeFullSystemMsg(GetSystemMessage(3690), MentorName, GetClassType(ClassID), string(Level)), string(self));
                }
            }
        }
    }
    return;
}

function HandleDialogOK()
{
    local int dialogID, mCode;
    local string Username;

    // End:0x121
    if(DialogIsMine())
    {
        dialogID = DialogGetID();
        // End:0x53
        if(90007 == dialogID)
        {
            Username = getUserNameByList();
            // End:0x50
            if(Username != "")
            {
                Class'NWindow.PersonalConnectionAPI'.static.RequestRemoveFriend(Username);
            }            
        }
        else
        {
            // End:0x91
            if(90008 == dialogID)
            {
                Username = getUserNameByList();
                // End:0x8E
                if(Username != "")
                {
                    Class'NWindow.PersonalConnectionAPI'.static.RequestRemoveBlock(Username);
                }                
            }
            else
            {
                // End:0xFD
                if(90020 == dialogID)
                {
                    Username = getUserNameByList();
                    // End:0xFA
                    if((Username != "") && mentorMenTeeRole != 0)
                    {
                        // End:0xDA
                        if(mentorMenTeeRole == 1)
                        {
                            mCode = 1;                            
                        }
                        else
                        {
                            mCode = 0;
                        }
                        Class'NWindow.PersonalConnectionAPI'.static.RequestMentorCancel(mCode, Username);
                    }                    
                }
                else
                {
                    // End:0x121
                    if(90021 == dialogID)
                    {
                        Class'NWindow.PersonalConnectionAPI'.static.ConfirmMenteeAdd(MentorName, 1);
                    }
                }
            }
        }
    }
    return;
}

function HandleDialogCancel()
{
    local int dialogID;

    // End:0x38
    if(DialogIsMine())
    {
        dialogID = DialogGetID();
        // End:0x38
        if(DialogCheckCancelByID(90021))
        {
            Class'NWindow.PersonalConnectionAPI'.static.ConfirmMenteeAdd(MentorName, 0);
        }
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    local int tabindex;

    tabindex = ConnectionsListSelectTab.GetTopIndex();
    // End:0x29
    if(tabindex == 0)
    {
        OnOneOnOneTalkBtnClick();        
    }
    else
    {
        // End:0x3D
        if(tabindex == 1)
        {
            onDetailInfoBtnClick();            
        }
        else
        {
            // End:0x4F
            if(tabindex == 2)
            {
                OnOneOnOneTalkBtnClick();
            }
        }
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x20
        case "ListPlusBtn":
            OnListPlusBtnClick();
            // End:0x293
            break;
        // End:0x3A
        case "ListMinusBtn":
            OnListMinusBtnClick();
            // End:0x293
            break;
        // End:0x54
        case "ListBlockBtn":
            OnListBlockBtnClick();
            // End:0x293
            break;
        // End:0x70
        case "InvitePartyBtn":
            OnInvitePartyBtnClick();
            // End:0x293
            break;
        // End:0x89
        case "SendPostBtn":
            OnSendPostBtnClick();
            // End:0x293
            break;
        // End:0xA4
        case "InviteClanBtn":
            OnInviteClanBtnClick();
            // End:0x293
            break;
        // End:0xBC
        case "WhisperBtn":
            OnWhisperBtnClick();
            // End:0x293
            break;
        // End:0xD7
        case "DetailInfoBtn":
            onDetailInfoBtnClick();
            // End:0x293
            break;
        // End:0xF4
        case "OneOnOneTalkBtn":
            OnOneOnOneTalkBtnClick();
            // End:0x293
            break;
        // End:0x162
        case "ConnectionsListSelectTab0":
            subWindowClose();
            buttonsEnabled(true);
            listTextUpdate();
            checkClanButtonState();
            GuideTitle.HideWindow();
            Guide.HideWindow();
            ListPlusBtn.ShowWindow();
            setTextureVisible(0);
            // End:0x293
            break;
        // End:0x1D9
        case "ConnectionsListSelectTab1":
            subWindowClose();
            buttonsEnabled(false);
            listTextUpdate();
            DetailInfoBtn.EnableWindow();
            GuideTitle.HideWindow();
            Guide.HideWindow();
            ListPlusBtn.ShowWindow();
            setTextureVisible(1);
            // End:0x293
            break;
        // End:0x290
        case "ConnectionsListSelectTab2":
            subWindowClose();
            buttonsEnabled(true);
            listTextUpdate();
            checkClanButtonState();
            GuideTitle.ShowWindow();
            Guide.ShowWindow();
            // End:0x258
            if((mentorMenTeeRole == 0) || mentorMenTeeRole == 1)
            {
                ListPlusBtn.ShowWindow();                
            }
            else
            {
                ListPlusBtn.HideWindow();
            }
            OneOnOneTalkBtn.EnableWindow();
            DetailInfoBtn.DisableWindow();
            setTextureVisible(2);
            // End:0x293
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function listTextUpdate()
{
    local int tabindex, mCount;

    tabindex = ConnectionsListSelectTab.GetTopIndex();
    // End:0x72
    if(tabindex == 0)
    {
        ListTitle.SetText(GetSystemString(2385));
        ListCount.SetText(((("(" $ string(FriendList.GetRecordCount())) $ "/") $ string(128)) $ ")");        
    }
    else
    {
        // End:0xD2
        if(tabindex == 1)
        {
            ListTitle.SetText(GetSystemString(2384));
            ListCount.SetText(((("(" $ string(BlockList.GetRecordCount())) $ "/") $ string(512)) $ ")");            
        }
        else
        {
            // End:0x183
            if(tabindex == 2)
            {
                // End:0x11B
                if((mentorMenTeeRole == 1) || mentorMenTeeRole == 0)
                {
                    mCount = 3;
                    ListTitle.SetText(GetSystemString(2774));                    
                }
                else
                {
                    // End:0x14B
                    if(mentorMenTeeRole == 2)
                    {
                        mCount = 1;
                        ListTitle.SetText(GetSystemString(2768));                        
                    }
                }
                ListCount.SetText(((("(" $ string(MentoringList.GetRecordCount())) $ "/") $ string(mCount)) $ ")");
            }
        }
    }
    return;
}

function checkEnabledButton(ListCtrlHandle List)
{
    // End:0x1F
    if(List.GetRecordCount() > 0)
    {
        buttonsEnabled(true);        
    }
    else
    {
        buttonsEnabled(false);
    }
    return;
}

function OnListPlusBtnClick()
{
    sideWindowOpen("AddWnd");
    return;
}

function OnListMinusBtnClick()
{
    local int tabindex;
    local string tempStr;

    tempStr = getUserNameByList();
    // End:0x76
    if(tempStr != "")
    {
        tabindex = ConnectionsListSelectTab.GetTopIndex();
        // End:0x46
        if(tabindex == 0)
        {
            askDialog(90007);            
        }
        else
        {
            // End:0x5F
            if(tabindex == 1)
            {
                askDialog(90008);                
            }
            else
            {
                // End:0x76
                if(tabindex == 2)
                {
                    askDialog(90020);
                }
            }
        }
    }
    return;
}

function OnListBlockBtnClick()
{
    return;
}

function OnInvitePartyBtnClick()
{
    local string tempStr;

    tempStr = getUserNameByList();
    // End:0x4D
    if(tempStr != "")
    {
        // End:0x42
        if(getInstanceUIData().getIsArenaServer())
        {
            Class'NWindow.ArenaAPI'.static.RequestMatchGroupAsk(tempStr);            
        }
        else
        {
            RequestInviteParty(tempStr);
        }
    }
    return;
}

function OnSendPostBtnClick()
{
    local PostBoxWnd postBoxWndScript;
    local PostWriteWnd postWriteWndScript;
    local string tempStr;

    tempStr = getUserNameByList();
    // End:0x84
    if(tempStr != "")
    {
        postBoxWndScript = PostBoxWnd(GetScript("PostBoxWnd"));
        postWriteWndScript = PostWriteWnd(GetScript("PostWriteWnd"));
        postBoxWndScript.OnClickButton("PostSendBtn");
        postWriteWndScript.toWrite(tempStr);
    }
    return;
}

function OnInviteClanBtnClick()
{
    local UserInfo Info;
    local string tempStr;
    local LVDataRecord Record;
    local InviteClanPopWnd InviteClanPopWndScript;
    local InviteClanPopWndClassic InviteClanPopWndClassicScript;
    local int tabindex;

    tabindex = ConnectionsListSelectTab.GetTopIndex();
    tempStr = getUserNameByList();
    // End:0x11B
    if(tempStr != "")
    {
        // End:0x11B
        if(GetPlayerInfo(Info))
        {
            // End:0x5D
            if(tabindex == 0)
            {
                FriendList.GetSelectedRec(Record);                
            }
            else
            {
                // End:0x7D
                if(tabindex == 2)
                {
                    MentoringList.GetSelectedRec(Record);
                }
            }
            // End:0xAB
            if(Record.LVDataList[3].szData != "1")
            {
                AddSystemMessageString(GetSystemMessage(3473));                
            }
            else
            {
                // End:0x11B
                if(Info.nClanID > 0)
                {
                    // End:0x10F
                    if(getInstanceUIData().getIsClassicServer())
                    {
                        InviteClanPopWndClassicScript = InviteClanPopWndClassic(GetScript("InviteClanPopWndClassic"));
                        InviteClanPopWndClassicScript.showByPersonalConnectionsWndUsingUserName(tempStr);                        
                    }
                    else
                    {
                        RequestClanAskJoinByName(tempStr, 0);
                    }
                }
            }
        }
    }
    return;
}

function askJoin()
{
    local UserInfo User;

    // End:0x7D
    if(GetTargetInfo(User))
    {
        // End:0x7D
        if(User.nID > 0)
        {
            // End:0x5C
            if(getInstanceUIData().getIsClassicServer())
            {
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("InviteClanPopWndClassic");                
            }
            else
            {
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("InviteClanPopWnd");
            }
        }
    }
    return;
}

function HandleClanMyAuth(string a_Param)
{
    local int nClanMaster;

    ParseInt(a_Param, "Join", nClanJoin);
    ParseInt(a_Param, "ClanMaster", nClanMaster);
    // End:0x54
    if((nClanMaster == 1) || nClanJoin == 1)
    {
        nClanJoin = 1;        
    }
    else
    {
        nClanJoin = 0;
    }
    checkClanButtonState();
    return;
}

function OnWhisperBtnClick()
{
    local ChatWnd chatWndScript;
    local string tempStr;

    tempStr = getUserNameByList();
    // End:0x50
    if(tempStr != "")
    {
        chatWndScript = ChatWnd(GetScript("ChatWnd"));
        chatWndScript.setChatEditBox(("\"" $ tempStr) $ " ");
    }
    return;
}

function onDetailInfoBtnClick()
{
    // End:0x96
    if((getUserNameByList()) != "")
    {
        // End:0x7B
        if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
        {
            // End:0x72
            if(!m_PersonalConnectionsDrawerWnd.DetailInfoWnd.IsShowWindow())
            {
                sideWindowOpen("DetailInfoWnd");                
            }
            else
            {
                subWindowClose();
            }            
        }
        else
        {
            sideWindowOpen("DetailInfoWnd");
        }
        RequestDetailInfo();
    }
    return;
}

function OnOneOnOneTalkBtnClick()
{
    local LVDataRecord Record;
    local int tabindex;
    local string Username;

    Username = getUserNameByList();
    tabindex = ConnectionsListSelectTab.GetTopIndex();
    // End:0xDF
    if(Username != "")
    {
        // End:0x4F
        if(tabindex == 0)
        {
            FriendList.GetSelectedRec(Record);            
        }
        else
        {
            // End:0x6F
            if(tabindex == 2)
            {
                MentoringList.GetSelectedRec(Record);
            }
        }
        // End:0xC6
        if(Record.LVDataList[3].szData == "1")
        {
            Debug("-> RequestFriendChat -:" @ Username);
            Class'NWindow.PersonalConnectionAPI'.static.RequestFriendChat(Username);            
        }
        else
        {
            AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(3), Username));
        }
    }
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    // End:0x7E
    if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
    {
        // End:0x7E
        if(ConnectionsListSelectTab.GetTopIndex() != 2)
        {
            // End:0x78
            if(!m_PersonalConnectionsDrawerWnd.DetailInfoWnd.IsShowWindow())
            {
                sideWindowOpen("DetailInfoWnd");
            }
            RequestDetailInfo();
        }
    }
    return;
}

function RequestDetailInfo()
{
    local string tempStr;
    local int tabindex;

    tempStr = getUserNameByList();
    tabindex = ConnectionsListSelectTab.GetTopIndex();
    // End:0x63
    if(tempStr != "")
    {
        // End:0x4F
        if(tabindex == 0)
        {
            Class'NWindow.PersonalConnectionAPI'.static.RequestFriendDetailInfo(tempStr);            
        }
        else
        {
            Class'NWindow.PersonalConnectionAPI'.static.RequestBlockDetailInfo(tempStr);
        }
    }
    return;
}

function string getUserNameByList()
{
    local LVDataRecord Record;
    local int tabindex;
    local string returnStr;

    returnStr = "";
    tabindex = ConnectionsListSelectTab.GetTopIndex();
    // End:0x6F
    if(tabindex == 0)
    {
        // End:0x6C
        if(FriendList.GetSelectedIndex() != -1)
        {
            FriendList.GetSelectedRec(Record);
            returnStr = Record.LVDataList[0].szData;
        }        
    }
    else
    {
        // End:0xC1
        if(tabindex == 1)
        {
            // End:0xBE
            if(BlockList.GetSelectedIndex() != -1)
            {
                BlockList.GetSelectedRec(Record);
                returnStr = Record.LVDataList[0].szData;
            }            
        }
        else
        {
            // End:0x111
            if(tabindex == 2)
            {
                // End:0x111
                if(MentoringList.GetSelectedIndex() != -1)
                {
                    MentoringList.GetSelectedRec(Record);
                    returnStr = Record.LVDataList[0].szData;
                }
            }
        }
    }
    // End:0x128
    if(returnStr == "")
    {
        AddSystemMessage(3314);
    }
    return returnStr;
    return;
}

function OnCallUCFunction(string funcName, string param)
{
    // End:0x50
    if(funcName == "checkInviteClanByGfxCallFunction")
    {
        // End:0x43
        if(param == "1")
        {
            nClanJoin = 1;            
        }
        else
        {
            nClanJoin = 0;
        }
        checkClanButtonState();
    }
    return;
}

function checkClanButtonState()
{
    local UserInfo UserInfo;

    // End:0x7C
    if(GetPlayerInfo(UserInfo))
    {
        // End:0x30
        if(UserInfo.nClanID == 0)
        {
            InviteClanBtn.DisableWindow();            
        }
        else
        {
            switch(ConnectionsListSelectTab.GetTopIndex())
            {
                // End:0x45
                case 0:
                // End:0x79
                case 2:
                    // End:0x67
                    if(nClanJoin == 0)
                    {
                        InviteClanBtn.DisableWindow();                        
                    }
                    else
                    {
                        InviteClanBtn.EnableWindow();
                    }
                    // End:0x7C
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
    }
    else
    {
        return;
    }
}

function getMyClanInfo()
{
    return;
}

function buttonsEnabled(bool bFlag)
{
    // End:0x66
    if(bFlag)
    {
        InvitePartyBtn.EnableWindow();
        SendPostBtn.EnableWindow();
        InviteClanBtn.EnableWindow();
        WhisperBtn.EnableWindow();
        DetailInfoBtn.EnableWindow();
        OneOnOneTalkBtn.EnableWindow();        
    }
    else
    {
        InvitePartyBtn.DisableWindow();
        SendPostBtn.DisableWindow();
        InviteClanBtn.DisableWindow();
        WhisperBtn.DisableWindow();
        DetailInfoBtn.DisableWindow();
        OneOnOneTalkBtn.DisableWindow();
    }
    return;
}

function removeAllArrayItems(out array<relationMemberInfo> pArray)
{
    // End:0x19
    if(pArray.Length > 0)
    {
        pArray.Remove(0, pArray.Length);
    }
    return;
}

function removeArrayItem(out array<relationMemberInfo> pArray, int deleteItemIndex)
{
    // End:0x1C
    if(pArray.Length > deleteItemIndex)
    {
        pArray.Remove(deleteItemIndex, 1);
    }
    return;
}

function sideWindowOpen(string sideWindowName)
{
    local WindowHandle sideWindowHandler;

    sideWindowHandler = GetWindowHandle("PersonalConnectionsDrawerWnd." $ sideWindowName);
    // End:0xBB
    if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
    {
        // End:0xA4
        if(sideWindowHandler.IsShowWindow())
        {
            m_PersonalConnectionsDrawerWnd.HideWindow("PersonalConnectionsDrawerWnd");            
        }
        else
        {
            m_PersonalConnectionsDrawerWnd.showSelectWindow(sideWindowName);
        }        
    }
    else
    {
        m_PersonalConnectionsDrawerWnd.ShowWindow("PersonalConnectionsDrawerWnd");
        m_PersonalConnectionsDrawerWnd.showSelectWindow(sideWindowName);
    }
    return;
}

function subWindowClose()
{
    // End:0x5D
    if(m_PersonalConnectionsDrawerWnd.IsShowWindow("PersonalConnectionsDrawerWnd"))
    {
        m_PersonalConnectionsDrawerWnd.HideWindow("PersonalConnectionsDrawerWnd");
    }
    return;
}

function CustomTooltip getMemoToolTip(int Job, string memo)
{
    local CustomTooltip m_Tooltip;

    m_Tooltip.DrawList.Length = 2;
    m_Tooltip.MinimumWidth = 160;
    m_Tooltip.DrawList[0].eType = 1;
    m_Tooltip.DrawList[0].t_strText = (GetSystemString(391) $ " : ") $ GetClassType(Job);
    m_Tooltip.DrawList[1].eType = 1;
    m_Tooltip.DrawList[1].t_color.R = 175;
    m_Tooltip.DrawList[1].t_color.G = 152;
    m_Tooltip.DrawList[1].t_color.B = 120;
    m_Tooltip.DrawList[1].t_color.A = byte(255);
    m_Tooltip.DrawList[1].t_strText = memo;
    return m_Tooltip;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("PersonalConnectionsWnd").HideWindow();
    return;
}
