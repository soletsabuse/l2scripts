class PersonalConnectionsDrawerWnd extends UICommonAPI;

const MAX_MEMO_LENGTH = 50;

var WindowHandle Me;
var WindowHandle AddWnd;
var TextBoxHandle AddWndTitle;
var TabHandle AddWndTab;
var TextureHandle AddListTabBgLine;
var TextureHandle AddListTabBg;
var WindowHandle NameEnterWnd;
var TextBoxHandle NameEnter_Description;
var TextBoxHandle NameEnterTitle;
var EditBoxHandle NameEnterEditbox;
var TextureHandle DecoGroupBox;
var WindowHandle ClanListWnd;
var TextBoxHandle ClanList_Description;
var TextureHandle ClanListDeco;
var ListCtrlHandle ClanList;
var TextureHandle ClanListGroupBox;
var WindowHandle InzoneTreeWnd;
var TextBoxHandle InzoneTree_Description;
var TreeHandle InzoneTree;
var TextureHandle InzoneClanListGroupBox;
var ButtonHandle AddListBtn;
var ButtonHandle CloseBtn;
var TextureHandle DescriptionGroupBox;
var WindowHandle DetailInfoWnd;
var WindowHandle MenteeSearchWnd;
var MultiEditBoxHandle MemoContents;
var ButtonHandle MemoEnterBtn;
var TextureHandle texPledgeCrest;
var TextureHandle texPledgeAllianceCrest;
var ButtonHandle AddMenteeBtn;
var ButtonHandle WhisperMenteeBtn;
var ButtonHandle CloseMenteeBtn;
var ButtonHandle RefreshMenteeBtn;
var ButtonHandle BackwardBtn;
var ButtonHandle ForwardBtn;
var TextBoxHandle MenteeCount;
var ComboBoxHandle LevelComboBox;
var ListCtrlHandle MenteeList;
var PersonalConnectionsWnd personalConnectionsWndScript;
var int menTeeListCurrentPageCount;
var int menTeeListTotalPage;
var L2Util util;
var string beforeSelectedTreePath;
var string inzoneSelectedParam;
var string selectTreeNodeStr;
var TextBoxHandle NameEnterLimit;
var TextBoxHandle NameEnterLimitTime;

function OnRegisterEvent()
{
    RegisterEvent(40);
    RegisterEvent(420);
    RegisterEvent(400);
    RegisterEvent(440);
    RegisterEvent(450);
    RegisterEvent(320);
    RegisterEvent(330);
    RegisterEvent(410);
    RegisterEvent(5000);
    RegisterEvent(5410);
    RegisterEvent(5830);
    RegisterEvent(5840);
    RegisterEvent(5850);
    RegisterEvent(5810);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    load();
    util = L2Util(GetScript("L2Util"));
    LevelComboBox.AddString(GetSystemString(2780));
    LevelComboBox.AddString(GetSystemString(2781));
    LevelComboBox.AddString(GetSystemString(2782));
    LevelComboBox.AddString(GetSystemString(2783));
    menTeeListTotalPage = 1;
    menTeeListCurrentPageCount = 1;
    return;
}

function mentorMenteeListStartHandle(string param)
{
    local int DisableTimeInSec;

    ParseInt(param, "DisableTimeInSec", DisableTimeInSec);
    // End:0x52
    if(DisableTimeInSec == 0)
    {
        NameEnterLimit.SetText("");
        NameEnterLimitTime.SetText("");        
    }
    else
    {
        NameEnterLimit.SetText(GetSystemMessage(3902));
        NameEnterLimitTime.SetText(makeNameEnterLimitTime(DisableTimeInSec));
    }
    return;
}

function string makeNameEnterLimitTime(int DisableTimeInSec)
{
    local string tmpStr;
    local int CurDay, Totday, Curhou, Tothou, CurMin, Totmin,
	    Totsec;

    Totsec = DisableTimeInSec;
    // End:0x50
    if(Totsec < 60)
    {
        tmpStr = MakeFullSystemMsg(GetSystemMessage(3390), "1");
        tmpStr = MakeFullSystemMsg(GetSystemMessage(3408), tmpStr);        
    }
    else
    {
        Totmin = Totsec / 60;
        CurMin = int(float(Totmin) % float(60));
        Tothou = Totmin / 60;
        Curhou = int(float(Tothou) % float(24));
        Totday = Tothou / 24;
        CurDay = int(float(Totday) % float(24));
        // End:0xE6
        if(Tothou >= 24)
        {
            tmpStr = MakeFullSystemMsg(GetSystemMessage(3418), string(CurDay));
        }
        // End:0x123
        if((Tothou > 0) && Curhou != 0)
        {
            tmpStr = tmpStr @ MakeFullSystemMsg(GetSystemMessage(3406), string(Curhou));
        }
        // End:0x153
        if(CurMin != 0)
        {
            tmpStr = tmpStr @ MakeFullSystemMsg(GetSystemMessage(3390), string(CurMin));
        }
    }
    tmpStr = GetSystemString(1108) @ tmpStr;
    return tmpStr;
    return;
}

function OnShow()
{
    // End:0x78
    if(getInstanceL2Util().isClanV2())
    {
        Class'NWindow.PostWndAPI'.static.RequestPledgeMemberList();
        GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListReset_Btn").ShowWindow();        
    }
    else
    {
        Class'NWindow.UIDATA_CLAN'.static.RequestClanInfo();
        GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListReset_Btn").HideWindow();
    }
    // End:0xFE
    if(!getInstanceUIData().getIsArenaServer())
    {
        Class'NWindow.PersonalConnectionAPI'.static.RequestInzonePartyInfoHistory();
    }
    texPledgeCrest.HideWindow();
    texPledgeAllianceCrest.HideWindow();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("PersonalConnectionsDrawerWnd");
    NameEnterLimit = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimit");
    NameEnterLimitTime = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterLimitTime");
    AddWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd");
    AddWndTitle = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.AddWndTitle");
    AddWndTab = GetTabHandle("PersonalConnectionsDrawerWnd.AddWnd.AddWndTab");
    AddListTabBgLine = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.AddListTabBgLine");
    AddListTabBg = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.AddListTabBg");
    NameEnterWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd");
    NameEnter_Description = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.NameEnter_Description");
    NameEnterTitle = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.NameEnterTitle");
    NameEnterEditbox = GetEditBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.NameEnterEditbox");
    DecoGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.NameEnterWnd.DecoGroupBox");
    ClanListWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd");
    ClanList_Description = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanList_Description");
    ClanListDeco = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListDeco");
    ClanList = GetListCtrlHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanList");
    ClanListGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.ClanListWnd.ClanListGroupBox");
    InzoneClanListGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.ClanListGroupBox");
    InzoneTreeWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd");
    InzoneTree_Description = GetTextBoxHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.InzoneTree_Description");
    InzoneTree = GetTreeHandle("PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.InzoneTree");
    AddListBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.AddListBtn");
    CloseBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.AddWnd.CloseBtn");
    DescriptionGroupBox = GetTextureHandle("PersonalConnectionsDrawerWnd.AddWnd.DescriptionGroupBox");
    DetailInfoWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd");
    MenteeSearchWnd = GetWindowHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd");
    MemoContents = GetMultiEditBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.MemoContents");
    MemoEnterBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.MemoEnterBtn");
    texPledgeCrest = GetTextureHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.texPledgeCrest");
    texPledgeAllianceCrest = GetTextureHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.texPledgeAllianceCrest");
    AddMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.AddMenteeBtn");
    WhisperMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.WhisperMenteeBtn");
    CloseMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.CloseMenteeBtn");
    RefreshMenteeBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.RefreshMenteeBtn");
    BackwardBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.BackwardBtn");
    ForwardBtn = GetButtonHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.ForwardBtn");
    MenteeCount = GetTextBoxHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.MenteeCount");
    LevelComboBox = GetComboBoxHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.LevelComboBox");
    MenteeList = GetListCtrlHandle("PersonalConnectionsDrawerWnd.MenteeSearchWnd.MenteeList");
    personalConnectionsWndScript = PersonalConnectionsWnd(GetScript("PersonalConnectionsWnd"));
    MemoContents.SetMaxSizeOfText(50);
    GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BlockInfoText").HideWindow();
    beforeSelectedTreePath = "";
    // End:0xB90
    if(getInstanceUIData().getIsArenaServer())
    {
        AddWndTab.RemoveTabControl(2);
        AddWndTab.RemoveTabControl(1);
        AddListTabBgLine.SetWindowSize(182, 24);
    }
    return;
}

function load()
{
    return;
}

function OnClickButton(string Name)
{
    local LVDataRecord Record;
    local string tempStr;

    switch(Name)
    {
        // End:0x2F
        case "ClanListReset_Btn":
            Class'NWindow.PostWndAPI'.static.RequestPledgeMemberList();
            // End:0x2CA
            break;
        // End:0x47
        case "AddListBtn":
            OnAddListBtnClick();
            // End:0x2CA
            break;
        // End:0x5A
        case "CloseMenteeBtn":
        // End:0x70
        case "CloseBtn":
            OnCloseBtnClick();
            // End:0x2CA
            break;
        // End:0x8A
        case "MemoEnterBtn":
            memoEnterBtnHandler();
            // End:0x2CA
            break;
        // End:0x99
        case "AddWndTab0":
        // End:0xA8
        case "AddWndTab1":
        // End:0x192
        case "AddWndTab2":
            // End:0x171
            if(personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex() == 2)
            {
                // End:0x141
                if(AddWndTab.GetTopIndex() == 2)
                {
                    InzoneTreeWnd.HideWindow();
                    MenteeSearchWnd.ShowWindow();
                    AddListBtn.HideWindow();
                    CloseBtn.HideWindow();
                    callMenTeeList(LevelComboBox.GetSelectedNum(), 1);                    
                }
                else
                {
                    MenteeSearchWnd.HideWindow();
                    AddListBtn.ShowWindow();
                    CloseBtn.ShowWindow();
                }                
            }
            else
            {
                AddListBtn.ShowWindow();
                CloseBtn.ShowWindow();
            }
            // End:0x2CA
            break;
        // End:0x1C0
        case "RefreshMenteeBtn":
            callMenTeeList(LevelComboBox.GetSelectedNum(), 1);
            // End:0x2CA
            break;
        // End:0x1F0
        case "BackwardBtn":
            callMenTeeList(LevelComboBox.GetSelectedNum(), menTeeListCurrentPageCount - 1);
            // End:0x2CA
            break;
        // End:0x21F
        case "ForwardBtn":
            callMenTeeList(LevelComboBox.GetSelectedNum(), menTeeListCurrentPageCount + 1);
            // End:0x2CA
            break;
        // End:0x249
        case "WhisperMenteeBtn":
            OnDBClickListCtrlRecord("MenteeList");
            // End:0x2CA
            break;
        // End:0x2C7
        case "AddMenteeBtn":
            MenteeList.GetSelectedRec(Record);
            // End:0x296
            if(Record.LVDataList.Length > 0)
            {
                tempStr = Record.LVDataList[0].szData;
            }
            // End:0x2B9
            if(tempStr != "")
            {
                Class'NWindow.PersonalConnectionAPI'.static.RequestMenteeAdd(tempStr);                
            }
            else
            {
                AddSystemMessage(3314);
            }
            // End:0x2CA
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x387
    if(Left(Name, 4) == "root")
    {
        // End:0x362
        if(13 < Len(Name))
        {
            // End:0x32A
            if(beforeSelectedTreePath != Name)
            {
                // End:0x30A
                if(beforeSelectedTreePath == "")
                {                    
                }
                else
                {
                    InzoneTree.SetExpandedNode(beforeSelectedTreePath, false);
                    selectTreeNodeStr = "";
                }                
            }
            else
            {
                InzoneTree.SetExpandedNode(beforeSelectedTreePath, true);
            }
            ParseString(inzoneSelectedParam, Name, selectTreeNodeStr);
            beforeSelectedTreePath = Name;            
        }
        else
        {
            InzoneTree.SetExpandedNode(beforeSelectedTreePath, false);
            beforeSelectedTreePath = "";
            selectTreeNodeStr = "";
        }
    }
    return;
}

function treeSelectHandler()
{
    return;
}

function memoEnterBtnHandler()
{
    local string Username;
    local int parentTabIndex;

    Username = GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetNameText").GetText();
    // End:0xFA
    if(MemoContents.GetString() != "")
    {
        // End:0xFA
        if(MemoContents.GetTotalSizeOfText() <= 50)
        {
            parentTabIndex = personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex();
            // End:0xCC
            if(parentTabIndex == 0)
            {
                Class'NWindow.PersonalConnectionAPI'.static.RequestUpdateFriendMemo(Username, MemoContents.GetString());                
            }
            else
            {
                Class'NWindow.PersonalConnectionAPI'.static.RequestUpdateBlockMemo(Username, MemoContents.GetString());
            }
            AddSystemMessage(3332);
        }
    }
    return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
    switch(strID)
    {
        // End:0x28
        case "LevelComboBox":
            callMenTeeList(IndexID, 1);
            // End:0x2B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function callMenTeeList(int comboLevelIndex, int nChangePage)
{
    // End:0x1A
    if(nChangePage > menTeeListTotalPage)
    {
        nChangePage = menTeeListTotalPage;
    }
    // End:0x30
    if(nChangePage < 1)
    {
        nChangePage = menTeeListTotalPage;
    }
    switch(comboLevelIndex)
    {
        // End:0x4C
        case 0:
            RequestMenteeWaitingList(nChangePage, 1, 85);
            // End:0x92
            break;
        // End:0x61
        case 1:
            RequestMenteeWaitingList(nChangePage, 1, 40);
            // End:0x92
            break;
        // End:0x78
        case 2:
            RequestMenteeWaitingList(nChangePage, 41, 70);
            // End:0x92
            break;
        // End:0x8F
        case 3:
            RequestMenteeWaitingList(nChangePage, 71, 85);
            // End:0x92
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    // End:0x14
    if(ListCtrlID == "ClanList")
    {
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    local int tabindex;
    local string tempStr;
    local ChatWnd chatWndScript;
    local LVDataRecord Record;

    tabindex = AddWndTab.GetTopIndex();
    // End:0x9A
    if(ListCtrlID == "MenteeList")
    {
        MenteeList.GetSelectedRec(Record);
        tempStr = Record.LVDataList[0].szData;
        // End:0x9A
        if(tempStr != "")
        {
            chatWndScript = ChatWnd(GetScript("ChatWnd"));
            chatWndScript.setChatEditBox(("\"" $ tempStr) $ " ");
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x15
        case 40:
            restartHandler();
            // End:0x153
            break;
        // End:0x2B
        case 5000:
            HandleReceivePledgeMemberList(param);
            // End:0x153
            break;
        // End:0x33
        case 320:
        // End:0x59
        case 420:
            // End:0x56
            if(!getInstanceL2Util().isClanV2())
            {
                clanMemberInfoListEmptyHandle();
            }
            // End:0x153
            break;
        // End:0x61
        case 400:
        // End:0x8C
        case 410:
            // End:0x89
            if(!getInstanceL2Util().isClanV2())
            {
                clanMemberAddedHandle(param);
            }
            // End:0x153
            break;
        // End:0xB7
        case 440:
            // End:0xB4
            if(!getInstanceL2Util().isClanV2())
            {
                clanMemberInfoUpdateHandle(param);
            }
            // End:0x153
            break;
        // End:0xE2
        case 450:
            // End:0xDF
            if(!getInstanceL2Util().isClanV2())
            {
                clanMemberRemovedHandle(param);
            }
            // End:0x153
            break;
        // End:0xF8
        case 5410:
            InzonePartyHistoryUpdateHandler(param);
            // End:0x153
            break;
        // End:0x10E
        case 5830:
            menteeWaitingListStartHandle(param);
            // End:0x153
            break;
        // End:0x124
        case 5840:
            menteeWaitingListHandle(param);
            // End:0x153
            break;
        // End:0x13A
        case 5850:
            menteeWaitingListEndHandle(param);
            // End:0x153
            break;
        // End:0x150
        case 5810:
            mentorMenteeListStartHandle(param);
            // End:0x153
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function menteeWaitingListStartHandle(string param)
{
    local int currentPageCount, TotalPage;

    ParseInt(param, "CurPage", currentPageCount);
    ParseInt(param, "TotalPage", TotalPage);
    // End:0x4F
    if((currentPageCount <= 0) || TotalPage <= 0)
    {        
    }
    else
    {
        menTeeListCurrentPageCount = currentPageCount;
        menTeeListTotalPage = TotalPage;
        MenteeList.DeleteAllItem();
        MenteeCount.SetText((string(menTeeListCurrentPageCount) $ "/") $ string(menTeeListTotalPage));
        // End:0xB9
        if(menTeeListTotalPage <= menTeeListCurrentPageCount)
        {
            ForwardBtn.DisableWindow();            
        }
        else
        {
            ForwardBtn.EnableWindow();
        }
        // End:0xE5
        if(menTeeListCurrentPageCount <= 1)
        {
            BackwardBtn.DisableWindow();            
        }
        else
        {
            BackwardBtn.EnableWindow();
        }
    }
    return;
}

function menteeWaitingListHandle(string param)
{
    local LVDataRecord Record;

    setMenteeMemberRecord(Record, param);
    MenteeList.InsertRecord(Record);
    return;
}

function menteeWaitingListEndHandle(string param)
{
    return;
}

function setMenteeMemberRecord(out LVDataRecord Record, string param)
{
    local string Name, levelString;
    local int ClassID, Level, Status;

    Record.LVDataList.Length = 4;
    ParseString(param, "Name", Name);
    ParseInt(param, "Class", ClassID);
    ParseInt(param, "Level", Level);
    // End:0x75
    if(Status < 1)
    {
        ParseInt(param, "Status", Status);
    }
    // End:0xA2
    if((Level >= 1) && Level <= 40)
    {
        levelString = GetSystemString(2789);        
    }
    else
    {
        // End:0xD0
        if((Level >= 41) && Level <= 70)
        {
            levelString = GetSystemString(2790);            
        }
        else
        {
            // End:0xFB
            if((Level >= 71) && Level <= 85)
            {
                levelString = GetSystemString(2791);
            }
        }
    }
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[0].TextColor = util.BrightWhite;
    Record.LVDataList[1].bUseTextColor = true;
    Record.LVDataList[1].TextColor = util.BrightWhite;
    Record.LVDataList[0].szData = Name;
    Record.LVDataList[1].szData = levelString;
    Record.LVDataList[1].textAlignment = 2;
    Record.LVDataList[2].szData = string(ClassID);
    Record.LVDataList[2].szTexture = GetClassRoleIconName(ClassID);
    Record.LVDataList[2].HiddenStringForSorting = string(GetClassRoleType(ClassID));
    Record.LVDataList[2].nTextureWidth = 11;
    Record.LVDataList[2].nTextureHeight = 11;
    Record.nReserved1 = (0);
    return;
}

function restartHandler()
{
    OnShow();
    clanMemberInfoListEmptyHandle();
    return;
}

function OnAddListBtnClick()
{
    local int tabindex;
    local string tempStr;

    tabindex = AddWndTab.GetTopIndex();
    // End:0xE5
    if(tabindex == 0)
    {
        // End:0xD7
        if(NameEnterEditbox.GetString() != "")
        {
            switch(personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
            {
                // End:0x75
                case 0:
                    Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(NameEnterEditbox.GetString());
                    // End:0xC3
                    break;
                // End:0x9A
                case 1:
                    Class'NWindow.PersonalConnectionAPI'.static.RequestAddBlock(NameEnterEditbox.GetString());
                    // End:0xC3
                    break;
                // End:0xC0
                case 2:
                    Class'NWindow.PersonalConnectionAPI'.static.RequestMenteeAdd(NameEnterEditbox.GetString());
                    // End:0xC3
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            NameEnterEditbox.SetString("");            
        }
        else
        {
            AddSystemMessage(3718);
        }        
    }
    else
    {
        // End:0x188
        if(tabindex == 1)
        {
            tempStr = getUserNameByList();
            // End:0x17A
            if(tempStr != "")
            {
                switch(personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
                {
                    // End:0x13D
                    case 0:
                        Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(tempStr);
                        // End:0x177
                        break;
                    // End:0x158
                    case 1:
                        Class'NWindow.PersonalConnectionAPI'.static.RequestAddBlock(tempStr);
                        // End:0x177
                        break;
                    // End:0x174
                    case 2:
                        Class'NWindow.PersonalConnectionAPI'.static.RequestMenteeAdd(tempStr);
                        // End:0x177
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }                
            }
            else
            {
                AddSystemMessage(3314);
            }            
        }
        else
        {
            // End:0x21D
            if(tabindex == 2)
            {
                // End:0x212
                if(selectTreeNodeStr != "")
                {
                    switch(personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
                    {
                        // End:0x1D5
                        case 0:
                            Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(selectTreeNodeStr);
                            // End:0x20F
                            break;
                        // End:0x1F0
                        case 1:
                            Class'NWindow.PersonalConnectionAPI'.static.RequestAddBlock(selectTreeNodeStr);
                            // End:0x20F
                            break;
                        // End:0x20C
                        case 2:
                            Class'NWindow.PersonalConnectionAPI'.static.RequestMenteeAdd(selectTreeNodeStr);
                            // End:0x20F
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }                    
                }
                else
                {
                    AddSystemMessage(3314);
                }
            }
        }
    }
    return;
}

function OnCloseBtnClick()
{
    Me.HideWindow();
    return;
}

function HandleReceivePledgeMemberList(string param)
{
    local int Num, i;
    local string strName;
    local int ClanClass, ClanLevel, logon;
    local LVDataRecord Record;
    local array<string> AddName;

    // End:0x17
    if(!getInstanceL2Util().isClanV2())
    {
        return;
    }
    ParseInt(param, "Num", Num);
    ClanList.DeleteAllItem();
    i = 0;
    J0x42:

    // End:0x388 [Loop If]
    if(i < Num)
    {
        ParseString(param, "Name" $ string(i), strName);
        ParseInt(param, "FriendClass" $ string(i), ClanClass);
        ParseInt(param, "FriendLevel" $ string(i), ClanLevel);
        ParseInt(param, "FriendLogon" $ string(i), logon);
        AddName[i] = strName;
        Record.LVDataList.Length = 4;
        // End:0x177
        if(logon > 0)
        {
            Record.LVDataList[0].bUseTextColor = true;
            Record.LVDataList[0].TextColor = util.BrightWhite;
            Record.LVDataList[1].bUseTextColor = true;
            Record.LVDataList[1].TextColor = util.BrightWhite;            
        }
        else
        {
            Record.LVDataList[0].bUseTextColor = true;
            Record.LVDataList[0].TextColor = util.White;
            Record.LVDataList[1].bUseTextColor = true;
            Record.LVDataList[1].TextColor = util.White;
        }
        Record.LVDataList[0].szData = strName;
        Record.LVDataList[1].szData = string(ClanLevel);
        Record.LVDataList[2].szTexture = GetClassRoleIconName(ClanClass);
        Record.LVDataList[2].nTextureWidth = 11;
        Record.LVDataList[2].nTextureHeight = 11;
        Record.LVDataList[2].szData = string(ClanClass);
        Record.LVDataList[2].HiddenStringForSorting = string(GetClassRoleType(ClanClass));
        Record.LVDataList[3].nTextureWidth = 31;
        Record.LVDataList[3].nTextureHeight = 11;
        // End:0x319
        if(logon > 0)
        {
            Record.LVDataList[3].szData = "1";
            Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";            
        }
        else
        {
            Record.LVDataList[3].szData = "0";
            Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
        }
        ClanList.InsertRecord(Record);
        i++;
        // [Loop Continue]
        goto J0x42;
    }
    return;
}

function setClanMemberRecord(out LVDataRecord Record, string param)
{
    local string Name;
    local int ClassID, Level, Status;

    Record.LVDataList.Length = 4;
    ParseString(param, "Name", Name);
    ParseInt(param, "Class", ClassID);
    ParseInt(param, "Level", Level);
    ParseInt(param, "ID", Status);
    // End:0x89
    if(Status < 1)
    {
        ParseInt(param, "Status", Status);
    }
    // End:0xFF
    if(Status > 0)
    {
        Record.LVDataList[0].bUseTextColor = true;
        Record.LVDataList[0].TextColor = util.BrightWhite;
        Record.LVDataList[1].bUseTextColor = true;
        Record.LVDataList[1].TextColor = util.BrightWhite;        
    }
    else
    {
        Record.LVDataList[0].bUseTextColor = true;
        Record.LVDataList[0].TextColor = util.White;
        Record.LVDataList[1].bUseTextColor = true;
        Record.LVDataList[1].TextColor = util.White;
    }
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
    // End:0x2AF
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

function clanMemberAddedV2Handle(string param)
{
    local LVDataRecord Record;

    setClanMemberRecord(Record, param);
    ClanList.InsertRecord(Record);
    return;
}

function clanMemberInfoListEmptyHandle()
{
    ClanList.DeleteAllItem();
    return;
}

function clanMemberAddedHandle(string param)
{
    local LVDataRecord Record;

    setClanMemberRecord(Record, param);
    ClanList.InsertRecord(Record);
    return;
}

function clanMemberRemovedHandle(string param)
{
    local string Name;
    local int i;

    ParseString(param, "Name", Name);
    i = util.ctrlListSearchByName(ClanList, Name);
    // End:0x58
    if(i != -1)
    {
        ClanList.DeleteRecord(i);
    }
    return;
}

function clanMemberInfoUpdateHandle(string param)
{
    local LVDataRecord Record, tempRecord;
    local string Name;
    local int i;

    ParseString(param, "Name", Name);
    setClanMemberRecord(Record, param);
    i = 0;
    J0x2D:

    // End:0xA0 [Loop If]
    if(i < ClanList.GetRecordCount())
    {
        ClanList.GetRec(i, tempRecord);
        // End:0x96
        if(tempRecord.LVDataList[0].szData == Name)
        {
            ClanList.ModifyRecord(i, Record);
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

function InzonePartyHistoryUpdateHandler(string param)
{
    local string strRetName, TREENAME, ROOTNAME;
    local int NumberOfInzoneParty, NumberOfPartyMember, InzoneTypeID, InzoneUseTimeYear, InzoneUseTimeMonth, InzoneUseTimeDay,
	    InzoneClassID, InzoneStatus, inzoneCount, PartyMemberCount;

    local string inzoneName, inzoneMemberName, listName, inzoneDate;

    TREENAME = "PersonalConnectionsDrawerWnd.AddWnd.InzoneTreeWnd.InzoneTree";
    ROOTNAME = "root";
    // End:0x71
    if(selectTreeNodeStr != "")
    {
        InzoneTree.SetExpandedNode(selectTreeNodeStr, false);
    }
    // End:0x92
    if(beforeSelectedTreePath != "")
    {
        InzoneTree.SetExpandedNode(beforeSelectedTreePath, false);
    }
    InzoneTree.Clear();
    listName = "";
    inzoneName = "";
    inzoneDate = "";
    inzoneMemberName = "";
    inzoneSelectedParam = "";
    ParseInt(param, "NumberOfInzoneParty", NumberOfInzoneParty);
    util.TreeInsertRootNode(TREENAME, ROOTNAME, "", 0, 4);
    inzoneCount = 0;
    J0x113:

    // End:0x5C2 [Loop If]
    if(inzoneCount < NumberOfInzoneParty)
    {
        ParseInt(param, "NumberOfPartyMember" $ string(inzoneCount), NumberOfPartyMember);
        ParseInt(param, "InzoneUseTimeYear" $ string(inzoneCount), InzoneUseTimeYear);
        ParseInt(param, "InzoneUseTimeMonth" $ string(inzoneCount), InzoneUseTimeMonth);
        ParseInt(param, "InzoneUseTimeDay" $ string(inzoneCount), InzoneUseTimeDay);
        ParseInt(param, "InzoneTypeID" $ string(inzoneCount), InzoneTypeID);
        // End:0x2EA
        if(NumberOfInzoneParty > 0)
        {
            listName = "list" $ string(inzoneCount);
            inzoneName = GetInZoneNameWithZoneID(InzoneTypeID);
            inzoneDate = ("(" $ MakeFullSystemMsg(GetSystemMessage(2203), string(InzoneUseTimeMonth), string(InzoneUseTimeDay))) $ ")";
            util.TreeInsertExpandBtnNode(TREENAME, listName, ROOTNAME);
            listName = (ROOTNAME $ ".") $ listName;
            util.TreeInsertTextNodeItem(TREENAME, listName, inzoneName, 5, 0, util.0, true);
            util.TreeInsertTextNodeItem(TREENAME, listName, inzoneDate, 5, 0, util.2, true);
        }
        PartyMemberCount = 0;
        J0x2F1:

        // End:0x5B8 [Loop If]
        if(PartyMemberCount < NumberOfPartyMember)
        {
            ParseString(param, (("Inzone" $ string(inzoneCount)) $ "_Name") $ string(PartyMemberCount), inzoneMemberName);
            ParseInt(param, (("Inzone" $ string(inzoneCount)) $ "_ClassID") $ string(PartyMemberCount), InzoneClassID);
            ParseInt(param, (("Inzone" $ string(inzoneCount)) $ "_Status") $ string(PartyMemberCount), InzoneStatus);
            util.setCustomTooltip(getJobToolTip(InzoneClassID));
            strRetName = util.TreeInsertItemTooltipNode(TREENAME, "member" $ string(PartyMemberCount), listName, -7, 0, 20, 0, 32, 20, util.getCustomTooltip());
            inzoneSelectedParam = (((inzoneSelectedParam $ " ") $ strRetName) $ "=") $ inzoneMemberName;
            // End:0x481
            if((float(PartyMemberCount) % float(2)) == float(0))
            {
                util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 257, 18, 16, 0,,, 14);                
            }
            else
            {
                util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 257, 18, 16, 0,,, 14);
            }
            util.TreeInsertTextureNodeItem(TREENAME, strRetName, GetClassRoleIconName(InzoneClassID), 11, 11, -108, 3);
            // End:0x540
            if(InzoneStatus > 0)
            {
                util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CH3.BloodHoodWnd.BloodHood_Logon", 31, 11, 25, 3);                
            }
            else
            {
                util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff", 31, 11, 25, 3);
            }
            util.TreeInsertTextNodeItem(TREENAME, strRetName, inzoneMemberName, -211, 2);
            PartyMemberCount++;
            // [Loop Continue]
            goto J0x2F1;
        }
        inzoneCount++;
        // [Loop Continue]
        goto J0x113;
    }
    return;
}

function string getUserNameByList()
{
    local LVDataRecord Record;
    local int tabindex, SelectedIndex;
    local string returnStr;

    returnStr = "";
    tabindex = AddWndTab.GetTopIndex();
    // End:0x7A
    if(tabindex == 1)
    {
        SelectedIndex = ClanList.GetSelectedIndex();
        // End:0x77
        if(SelectedIndex != -1)
        {
            ClanList.GetSelectedRec(Record);
            returnStr = Record.LVDataList[0].szData;
        }        
    }
    else
    {
        // End:0x89
        if(tabindex == 2)
        {            
        }
        else
        {
            AddSystemMessage(3314);
        }
    }
    return returnStr;
    return;
}

function showSelectWindow(string WindowName)
{
    AddWnd.HideWindow();
    NameEnterWnd.HideWindow();
    ClanListWnd.HideWindow();
    InzoneTreeWnd.HideWindow();
    DetailInfoWnd.HideWindow();
    MenteeSearchWnd.HideWindow();
    AddListBtn.ShowWindow();
    CloseBtn.ShowWindow();
    switch(WindowName)
    {
        // End:0xBC
        case "AddWnd":
            AddWnd.ShowWindow();
            AddWndTab.SetTopOrder(0, false);
            NameEnterEditbox.SetFocus();
            // End:0x1A7
            break;
        // End:0xDF
        case "NameEnterWnd":
            NameEnterWnd.ShowWindow();
            // End:0x1A7
            break;
        // End:0x112
        case "ClanListWnd":
            ClanListWnd.ShowWindow();
            AddWndTab.SetTopOrder(1, false);
            // End:0x1A7
            break;
        // End:0x148
        case "InzoneTreeWnd":
            InzoneTreeWnd.ShowWindow();
            AddWndTab.SetTopOrder(2, false);
            // End:0x1A7
            break;
        // End:0x16C
        case "DetailInfoWnd":
            DetailInfoWnd.ShowWindow();
            // End:0x1A7
            break;
        // End:0x1A4
        case "MenteeSearchWnd":
            MenteeSearchWnd.ShowWindow();
            AddWndTab.SetTopOrder(2, false);
            // End:0x1A7
            break;
        // End:0xFFFF
        default:
            break;
    }
    switch(personalConnectionsWndScript.ConnectionsListSelectTab.GetTopIndex())
    {
        // End:0x1E4
        case 0:
            AddWndTab.SetButtonName(2, GetSystemString(2392));
            // End:0x22E
            break;
        // End:0x207
        case 1:
            AddWndTab.SetButtonName(2, GetSystemString(2392));
            // End:0x22E
            break;
        // End:0x22B
        case 2:
            AddWndTab.SetButtonName(2, GetSystemString(2784));
            // End:0x22E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function setDetailInfo(string Name, int Level, int ClassID, int PledgeCrestID, int AllianceCrestID, int birthMonth, int birthDay, int logoutDiffSeconds, string memo)
{
    local Texture texPledge, texAlliance;
    local string PledgeName, allianceName, classTypeStr;
    local bool bPledge, bAlliance;
    local Rect rectWnd;

    rectWnd = DetailInfoWnd.GetRect();
    GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetNameText").SetText(Name);
    // End:0x48F
    if(((((((Level + ClassID) + PledgeCrestID) + AllianceCrestID) + birthMonth) + birthDay) + logoutDiffSeconds) == 0)
    {
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BlockInfoText").ShowWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetStatusText").SetText(GetSystemString(2394));
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Level").SetText("");
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.job").SetText("");
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").SetText("");
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").SetText("");
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDay").SetText("");
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnect").SetText("");
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.LevelTitle").HideWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.JobTitle").HideWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.ClanTitle").HideWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.UnionTitle").HideWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDayTitle").HideWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnectTitle").HideWindow();        
    }
    else
    {
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BlockInfoText").HideWindow();
        PledgeName = Class'NWindow.UIDATA_CLAN'.static.GetName(PledgeCrestID);
        allianceName = Class'NWindow.UIDATA_CLAN'.static.GetAllianceName(PledgeCrestID);
        texPledge = GetPledgeCrestTexFromPledgeCrestID(PledgeCrestID);
        texAlliance = GetAllianceCrestTexFromAllianceCrestID(AllianceCrestID);
        classTypeStr = GetClassType(ClassID);
        bPledge = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(PledgeCrestID, texPledge);
        bAlliance = Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(PledgeCrestID, texAlliance);
        texPledgeCrest.SetTextureWithObject(texPledge);
        texPledgeAllianceCrest.SetTextureWithObject(texAlliance);
        texPledgeCrest.HideWindow();
        texPledgeAllianceCrest.HideWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").ClearAnchor();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").ClearAnchor();
        // End:0x6C5
        if(bPledge)
        {
            texPledgeCrest.ShowWindow();
            GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").MoveTo(rectWnd.nX + 118, (rectWnd.nY + 156) + 4);            
        }
        else
        {
            texPledgeCrest.HideWindow();
            GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").MoveTo(rectWnd.nX + 98, (rectWnd.nY + 156) + 4);
        }
        // End:0x7B2
        if(bAlliance)
        {
            texPledgeAllianceCrest.ShowWindow();
            GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").MoveTo(rectWnd.nX + 110, (rectWnd.nY + 178) + 4);            
        }
        else
        {
            texPledgeAllianceCrest.HideWindow();
            GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").MoveTo(rectWnd.nX + 98, (rectWnd.nY + 178) + 4);
        }
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Level").SetText(string(Level));
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.job").SetText(classTypeStr);
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Clan").SetText(PledgeName);
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.Union").SetText(allianceName);
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDay").SetText(MakeFullSystemMsg(GetSystemMessage(2203), string(birthMonth), string(birthDay)));
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.LevelTitle").ShowWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.JobTitle").ShowWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.ClanTitle").ShowWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.UnionTitle").ShowWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.BirthDayTitle").ShowWindow();
        GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnectTitle").ShowWindow();
        // End:0xC11
        if(logoutDiffSeconds <= -1)
        {
            GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetStatusText").SetText(GetSystemString(347));
            GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnect").SetText(GetSystemString(2401));            
        }
        else
        {
            GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.TargetStatusText").SetText(GetSystemString(348));
            GetTextBoxHandle("PersonalConnectionsDrawerWnd.DetailInfoWnd.FinalConnect").SetText(getConnectInfoTimeMessage(logoutDiffSeconds / 60));
        }
    }
    MemoContents.SetString(memo);
    return;
}

function string getConnectInfoTimeMessage(int Minute)
{
    local string returnStr;
    local int Value;

    returnStr = "";
    // End:0x35
    if(Minute < 60)
    {
        returnStr = MakeFullSystemMsg(GetSystemMessage(3294), string(Minute));        
    }
    else
    {
        // End:0x75
        if(Minute < (60 * 24))
        {
            Value = Minute / 60;
            returnStr = MakeFullSystemMsg(GetSystemMessage(3295), string(Value));            
        }
        else
        {
            // End:0xBD
            if(Minute < ((60 * 24) * 30))
            {
                Value = (Minute / 60) / 24;
                returnStr = MakeFullSystemMsg(GetSystemMessage(3296), string(Value));                
            }
            else
            {
                // End:0x10C
                if(Minute < ((60 * 24) * 365))
                {
                    Value = ((Minute / 60) / 24) / 30;
                    returnStr = MakeFullSystemMsg(GetSystemMessage(3297), string(Value));                    
                }
                else
                {
                    // End:0x158
                    if(Minute > ((60 * 24) * 365))
                    {
                        Value = ((Minute / 60) / 24) / 30;
                        returnStr = MakeFullSystemMsg(GetSystemMessage(3297), string(Value));
                    }
                }
            }
        }
    }
    return returnStr;
    return;
}

function CustomTooltip getJobToolTip(int Job)
{
    local CustomTooltip m_Tooltip;

    m_Tooltip.DrawList.Length = 1;
    m_Tooltip.DrawList[0].eType = 1;
    m_Tooltip.DrawList[0].t_strText = (GetSystemString(391) $ " : ") $ GetClassType(Job);
    return m_Tooltip;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("PersonalConnectionsDrawerWnd").HideWindow();
    return;
}
