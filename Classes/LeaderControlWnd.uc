class LeaderControlWnd extends PacketsInfo;

const SHAKEID_ME = 101;

struct ePartyControl
{
    var int UserID;
    var int Status;
};

var string m_WindowName;
var array<ePartyControl> PartyControl;
var int nCurrentProgressTime;
var PartyWnd Party;
var L2UITween l2UITweenScript;
var WindowHandle Me;
var WindowHandle ResultWnd;
var TextBoxHandle ResultHeadTxt;
var ListCtrlHandle PartyList;
var ProgressCtrlHandle ReadyProgress;
var TextBoxHandle ProgressInfoTxt;
var ButtonHandle StartBtn;
var ButtonHandle CloseBtn;
var CharacterViewportWindowHandle Viewport;
var TextBoxHandle acceptedCount;
var TextBoxHandle declinedCount;
var TextBoxHandle noAffectCount;
//var delegate<OnSortCompare> __OnSortCompare__Delegate;

function OnLoad()
{
    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    ResultWnd = GetWindowHandle(m_WindowName $ ".PartyListWnd.ResultWnd");
    ResultHeadTxt = GetTextBoxHandle(m_WindowName $ ".PartyListWnd.ResultWnd.ResultHeadTxt");
    PartyList = GetListCtrlHandle(m_WindowName $ ".PartyListWnd.PartyList");
    ReadyProgress = GetProgressCtrlHandle(m_WindowName $ ".PartyListWnd.ReadyProgress");
    StartBtn = GetButtonHandle(m_WindowName $ ".StartBtn");
    CloseBtn = GetButtonHandle(m_WindowName $ ".CloseBtn");
    ProgressInfoTxt = GetTextBoxHandle(m_WindowName $ ".PartyListWnd.ProgressInfoTxt");
    acceptedCount = GetTextBoxHandle(m_WindowName $ ".PartyListWnd.AcceptedWnd.AcceptedCntTxt");
    declinedCount = GetTextBoxHandle(m_WindowName $ ".PartyListWnd.AcceptedWnd.DeclinedCntTxt");
    noAffectCount = GetTextBoxHandle(m_WindowName $ ".PartyListWnd.AcceptedWnd.NoAffectCntTxt");
    Viewport = GetCharacterViewportWindowHandle(m_WindowName $ ".SeekerWnd.Viewport");
    PartyList.SetSelectedSelTooltip(false);
    PartyList.SetAppearTooltipAtMouseX(true);
    l2UITweenScript = L2UITween(GetScript("l2UITween"));
    Party = PartyWnd(GetScript("PartyWnd"));
    ResetUI();
    return;
}

function lockButtomButtons(bool B)
{
    // End:0x2A
    if(B)
    {
        StartBtn.DisableWindow();
        CloseBtn.DisableWindow();        
    }
    else
    {
        StartBtn.EnableWindow();
        CloseBtn.EnableWindow();
    }
    return;
}

function OnShow()
{
    return;
}

function OnHide()
{
    ResetUI();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(3550);
    RegisterEvent(1140);
    RegisterEvent(1160);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1A
    if(Event_ID == 3550)
    {
        handleCustomPacket(param);
    }
    return;
}

function OnClickButton(string strID)
{
    local int i;

    // End:0x25
    if(strID == "test1")
    {
        SendFake(string(1220), string(10));        
    }
    else
    {
        // End:0x53
        if(strID == "test2")
        {
            SendFake(string(1221), string(268634605), string(Rand(3)));            
        }
        else
        {
            // End:0x88
            if(strID == "test3")
            {
                SendFake(string(1222), string(1));
                SendFake(string(1225), string(10));                
            }
            else
            {
                // End:0xA5
                if(strID == "StartBtn")
                {
                    evRqStartPartyControl();                    
                }
                else
                {
                    // End:0xD3
                    if(strID == "ResetBtn")
                    {
                        ResetUI();
                        SendFake(string(1220), string(10));                        
                    }
                    else
                    {
                        // End:0xF6
                        if(strID == "CloseBtn")
                        {
                            Me.HideWindow();
                        }
                    }
                }
            }
        }
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x15
    if(TimerID == 1001)
    {
        updateTextProgress();
    }
    return;
}

function OnProgressTimeUp(string strID)
{
    // End:0x1F
    if(strID == "ReadyProgress")
    {
        handleTimeUp();
    }
    return;
}

function handleCustomPacket(string param)
{
    local int EventID;

    ParseInt(param, "EventID", EventID);
    switch(EventID)
    {
        // End:0x36
        case 1220:
            handleControlInfo(param);
            // End:0x68
            break;
        // End:0x4C
        case 1221:
            handlePartyUserUpdate(param);
            // End:0x68
            break;
        // End:0x62
        case 1222:
            handleStartRequest(param);
            // End:0x68
            break;
        // End:0xFFFF
        default:
            // End:0x68
            break;
            break;
    }
    return;
}

function initParty()
{
    local int i, nPartyCount, nPlayerId;

    nPartyCount = GetPartyMemberCount();
    // End:0x19
    if(nPartyCount <= 0)
    {
        return;
    }
    PartyControl.Remove(0, PartyControl.Length);
    PartyControl.Length = nPartyCount;
    i = 0;
    J0x39:

    // End:0x89 [Loop If]
    if(i < nPartyCount)
    {
        PartyControl[i].UserID = Party.m_arrID[i];
        PartyControl[i].Status = 0;
        i++;
        // [Loop Continue]
        goto J0x39;
    }
    loadParty();
    return;
}

function handleControlInfo(string param)
{
    ParseInt(param, "ask", nCurrentProgressTime);
    // End:0x48
    if(nCurrentProgressTime > 0)
    {
        toggleResult(false);
        initProgress();
        initParty();
        updateUI();
        Me.ShowWindow();
    }
    return;
}

function handlePartyUserUpdate(string param)
{
    local int nUserId, nStatus;

    ParseInt(param, "ask", nUserId);
    ParseInt(param, "reply", nStatus);
    updateUserStatus(nUserId, nStatus);
    updateUI();
    loadParty();
    // End:0x5D
    if(isAllPlayerAnswerToRequest())
    {
        deleteProgress();
        handleTimeUp();
    }
    switch(nStatus)
    {
        // End:0x77
        case 2:
            declinedNotify(nUserId);
            // End:0x7D
            break;
        // End:0xFFFF
        default:
            // End:0x7D
            break;
            break;
    }
    return;
}

function handleStartRequest(string param)
{
    local int nResult;

    ParseInt(param, "ask", nResult);
    // End:0x26
    if(nResult == 1)
    {
        startProgress();
    }
    return;
}

function loadParty()
{
    local int i;

    PartyList.DeleteAllItem();
    i = 0;
    J0x16:

    // End:0x65 [Loop If]
    if(i < PartyControl.Length)
    {
        PartyList.InsertRecord(getPartyRecord(PartyControl[i].UserID, PartyControl[i].Status));
        i++;
        // [Loop Continue]
        goto J0x16;
    }
    return;
}

function updateUI()
{
    local int i, A, D, N;

    A = 0;
    D = 0;
    N = 0;
    i = 0;
    J0x1C:

    // End:0x79 [Loop If]
    if(i < PartyControl.Length)
    {
        switch(PartyControl[i].Status)
        {
            // End:0x4C
            case 0:
                N++;
                // End:0x6F
                break;
            // End:0x5A
            case 1:
                A++;
                // End:0x6F
                break;
            // End:0x69
            case 2:
                D++;
                // End:0x6F
                break;
            // End:0xFFFF
            default:
                // End:0x6F
                break;
                break;
        }
        i++;
        // [Loop Continue]
        goto J0x1C;
    }
    acceptedCount.SetText(string(A));
    declinedCount.SetText(string(D));
    noAffectCount.SetText(string(N));
    return;
}

function ResetUI()
{
    PartyControl.Length = 0;
    nCurrentProgressTime = 0;
    Me.KillTimer(1001);
    l2UITweenScript.StopShake(m_WindowName, 101);
    PartyList.DeleteAllItem();
    ReadyProgress.Reset();
    ReadyProgress.Stop();
    ReadyProgress.SetProgressTime(10000);
    ResultWnd.HideWindow();
    ResultHeadTxt.SetText("N/A");
    ProgressInfoTxt.SetText("N/A");
    acceptedCount.SetText("0");
    declinedCount.SetText("0");
    noAffectCount.SetText("0");
    lockButtomButtons(false);
    return;
}

function initProgress()
{
    Me.KillTimer(1001);
    ReadyProgress.Reset();
    ReadyProgress.SetProgressTime(nCurrentProgressTime * 1000);
    ProgressInfoTxt.SetText(string(nCurrentProgressTime) @ GetSystemString(5184));
    return;
}

function startProgress()
{
    Me.KillTimer(1001);
    Me.SetTimer(1001, 1000);
    lockButtomButtons(true);
    ReadyProgress.Start();
    return;
}

function updateTextProgress()
{
    Me.KillTimer(1001);
    nCurrentProgressTime--;
    // End:0x28
    if(nCurrentProgressTime < 0)
    {
        return;
    }
    Me.SetTimer(1001, 1000);
    ProgressInfoTxt.SetText(string(nCurrentProgressTime) @ GetSystemString(5184));
    return;
}

function deleteProgress()
{
    Me.KillTimer(1001);
    ReadyProgress.Stop();
    return;
}

function declinedNotify(int UserID)
{
    local string Username;

    Username = GetUserName(UserID);
    MakeShakeTween();
    AddSystemMessageString(MakeFullSystemMsg(GetSystemString(7969), Username));
    getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemString(7969), Username));
    return;
}

function handleTimeUp()
{
    local array<int> vals;
    local int nSysStringId, nResultSysStringId;

    deleteProgress();
    vals = getStatusCount();
    // End:0x3D
    if(vals[1] == PartyControl.Length)
    {
        nSysStringId = 7972;
        nResultSysStringId = 7983;        
    }
    else
    {
        // End:0x64
        if(vals[2] > 0)
        {
            nSysStringId = 7970;
            nResultSysStringId = 7984;            
        }
        else
        {
            // End:0x87
            if(vals[0] > 0)
            {
                nSysStringId = 7971;
                nResultSysStringId = 7984;
            }
        }
    }
    AddSystemMessageString(GetSystemString(nSysStringId));
    getInstanceL2Util().showGfxScreenMessage(GetSystemString(nSysStringId));
    toggleResult(true, nResultSysStringId);
    ProgressInfoTxt.SetText(GetSystemString(7982));
    return;
}

function updateUserStatus(int UserID, int Status)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x51 [Loop If]
    if(i < PartyControl.Length)
    {
        // End:0x47
        if(PartyControl[i].UserID == UserID)
        {
            PartyControl[i].Status = Status;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    SortPartyByStatus();
    return;
}

function SortPartyByStatus()
{
    local int i, j;
    local ePartyControl temp;

    i = PartyControl.Length - 1;
    J0x0F:

    // End:0xB7 [Loop If]
    if(i > 0)
    {
        j = 0;
        J0x21:

        // End:0xAD [Loop If]
        if(j < i)
        {
            // End:0xA3
            if((getSortByStatus(PartyControl[j].Status)) < (getSortByStatus(PartyControl[j + 1].Status)))
            {
                temp = PartyControl[j];
                PartyControl[j] = PartyControl[j + 1];
                PartyControl[j + 1] = temp;
            }
            j++;
            // [Loop Continue]
            goto J0x21;
        }
        i--;
        // [Loop Continue]
        goto J0x0F;
    }
    return;
}

function string getSortByStatus(int nStatus)
{
    local int nSort;

    switch(nStatus)
    {
        // End:0x16
        case 0:
            nSort = 100;
            // End:0x41
            break;
        // End:0x28
        case 1:
            nSort = 10000;
            // End:0x41
            break;
        // End:0x3B
        case 2:
            nSort = 1000;
            // End:0x41
            break;
        // End:0xFFFF
        default:
            // End:0x41
            break;
            break;
    }
    return getInstanceL2Util().makeZeroString(20, (nSort));
    return;
}

function toggleResult(bool bShow, optional int nStringId)
{
    // End:0x35
    if(bShow)
    {
        ResultWnd.ShowWindow();
        ResultHeadTxt.SetText(GetSystemString(nStringId));        
    }
    else
    {
        ResultWnd.HideWindow();
    }
    return;
}

function LVDataRecord getPartyRecord(int UserID, int Status)
{
    local LVDataRecord Record;
    local string param, Name, Desc;
    local int ClassID;
    local Color Color;
    local PartyMemberInfo PartyMemberInfo;

    GetPartyMemberInfo(UserID, PartyMemberInfo);
    // End:0x50
    if(InStr(PartyMemberInfo.Name, ";") > -1)
    {
        PartyMemberInfo.Name = Left(PartyMemberInfo.Name, Len(PartyMemberInfo.Name) - 2);
    }
    Name = PartyMemberInfo.Name;
    ClassID = PartyMemberInfo.ClassID;
    Record.LVDataList.Length = 4;
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[1].bUseTextColor = true;
    Record.LVDataList[2].bUseTextColor = true;
    getLeaderControlTypeString(Status, Desc, Color);
    Record.LVDataList[0].hasIcon = true;
    Record.LVDataList[0].AttrIconTexArray.Length = 1;
    Record.LVDataList[0].AttrIconTexArray[0].X = 0;
    Record.LVDataList[0].AttrIconTexArray[0].Y = -22;
    Record.LVDataList[0].AttrIconTexArray[0].Width = 32;
    Record.LVDataList[0].AttrIconTexArray[0].Height = 32;
    Record.LVDataList[0].AttrIconTexArray[0].U = 0;
    Record.LVDataList[0].AttrIconTexArray[0].V = 0;
    Record.LVDataList[0].AttrIconTexArray[0].UL = 32;
    Record.LVDataList[0].AttrIconTexArray[0].VL = 32;
    Record.LVDataList[0].AttrIconTexArray[0].objTex = GetTexture(("L2UI_CT1.PlayerStatusWnd.PlayerStatusWnd_ClassMark_" $ string(ClassID)) $ "_Big");
    Record.LVDataList[0].AttrColor = Color;
    Record.LVDataList[0].AttrStat[0] = " ";
    Record.LVDataList[1].hasIcon = true;
    Record.LVDataList[1].AttrIconTexArray.Length = 2;
    Record.LVDataList[1].AttrIconTexArray[0].X = 5;
    Record.LVDataList[1].AttrIconTexArray[0].Y = -10;
    Record.LVDataList[1].AttrIconTexArray[0].Width = 0;
    Record.LVDataList[1].AttrIconTexArray[0].Height = 32;
    Record.LVDataList[1].AttrIconTexArray[0].U = 0;
    Record.LVDataList[1].AttrIconTexArray[0].V = 0;
    Record.LVDataList[1].AttrIconTexArray[0].UL = 0;
    Record.LVDataList[1].AttrIconTexArray[0].VL = 32;
    Record.LVDataList[1].AttrIconTexArray[0].objTex = GetTexture("");
    Record.LVDataList[1].AttrColor = Color;
    Record.LVDataList[1].AttrStat[0] = Name;
    Record.LVDataList[1].AttrStat[1] = GetClassType(ClassID);
    Record.LVDataList[2].hasIcon = true;
    Record.LVDataList[2].nTextureWidth = 14;
    Record.LVDataList[2].nTextureHeight = 14;
    Record.LVDataList[2].nTextureU = 14;
    Record.LVDataList[2].nTextureV = 14;
    getLeaderControlTypeTexture(Status, Record.LVDataList[2].szTexture);
    Record.LVDataList[2].IconPosX = 14;
    Record.LVDataList[2].FirstLineOffsetX = 5;
    Record.LVDataList[2].HiddenStringForSorting = getSortByStatus(Status);
    Record.nReserved1 = (UserID);
    Record.nReserved2 = (Status);
    ParamAdd(Record.szReserved, "Name", PartyMemberInfo.Name);
    ParamAdd(Record.szReserved, "ClassId", string(ClassID));
    ParamAdd(Record.szReserved, "Status", string(Status));
    return Record;
    return;
}

function string GetUserName(int UserID)
{
    local LVDataRecord Record;
    local int i;

    i = 0;
    J0x07:

    // End:0x6E [Loop If]
    if(i < PartyList.GetRecordCount())
    {
        PartyList.GetRec(i, Record);
        // End:0x64
        if(__NFUN_412__(Record.nReserved1, (UserID)))
        {
            return Record.LVDataList[1].AttrStat[0];
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function bool isAllPlayerAnswerToRequest()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x39 [Loop If]
    if(i < PartyControl.Length)
    {
        // End:0x2F
        if(PartyControl[i].Status == 0)
        {
            return false;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return true;
    return;
}

function array<int> getStatusCount()
{
    local int i, val;
    local array<int> vals;

    vals.Length = 3;
    vals[0] = 0;
    vals[1] = 0;
    vals[2] = 0;
    i = 0;
    J0x2C:

    // End:0x5E [Loop If]
    if(i < PartyControl.Length)
    {
        vals[PartyControl[i].Status]++;
        i++;
        // [Loop Continue]
        goto J0x2C;
    }
    return vals;
    return;
}

function MakeShakeTween()
{
    local ShakeObject shakeObj;

    shakeObj.Owner = m_WindowName;
    shakeObj.Target = Me;
    shakeObj.Duration = 75.0000000;
    shakeObj.shakeSize = 5.0000000;
    shakeObj.direction = l2UITweenScript.1;
    shakeObj.Id = 101;
    l2UITweenScript.StartShakeObject(shakeObj);
    return;
}

function evRqStartPartyControl()
{
    RequestBypassToServer("leader_control start");
    return;
}

delegate int OnSortCompare(ePartyControl A, ePartyControl B)
{
    // End:0x22
    if(A.Status > B.Status)
    {
        return -1;        
    }
    else
    {
        return 0;
    }
    return;
}
