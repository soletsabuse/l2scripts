class BR_CampaignAlarmWnd extends UICommonAPI;

const MAX_COUNT = 6;
const TIMER_ID = 501;
const TIMER_DELAY = 5000;

var WindowHandle Me;
var ButtonHandle CampaignInfoButton;
var TextBoxHandle CampaignTitle;
var TextBoxHandle TimeTitle;
var TextBoxHandle Time;
var ButtonHandle Resultbtn;
var TextureHandle Divider;
var BarHandle GoalGage1;
var BarHandle GoalGage2;
var BarHandle GoalGage3;
var BarHandle GoalGage4;
var BarHandle GoalGage5;
var BarHandle GoalGage6;
var array<BarHandle> arrStatus;
var TextBoxHandle GoalTitle1;
var TextBoxHandle GoalTitle2;
var TextBoxHandle GoalTitle3;
var TextBoxHandle GoalTitle4;
var TextBoxHandle GoalTitle5;
var TextBoxHandle GoalTitle6;
var array<TextBoxHandle> arrGoalTitle;
var bool bAccpept;
var int Mid;
var int mSTEP;
var int mGoalGroupID;
var int Mstate;
var L2Util util;

function OnRegisterEvent()
{
    RegisterEvent(9500);
    RegisterEvent(9510);
    RegisterEvent(9520);
    RegisterEvent(40);
    return;
}

function OnLoad()
{
    Me = GetWindowHandle("BR_CampaignAlarmWnd");
    Resultbtn = GetButtonHandle("BR_CampaignAlarmWnd.Resultbtn");
    Divider = GetTextureHandle("BR_CampaignAlarmWnd.Divider");
    CampaignTitle = GetTextBoxHandle("BR_CampaignAlarmWnd.CampaignTitle");
    TimeTitle = GetTextBoxHandle("BR_CampaignAlarmWnd.TimeTitle");
    Time = GetTextBoxHandle("BR_CampaignAlarmWnd.Time");
    GoalGage1 = GetBarHandle("BR_CampaignAlarmWnd.GoalGage1");
    GoalGage2 = GetBarHandle("BR_CampaignAlarmWnd.GoalGage2");
    GoalGage3 = GetBarHandle("BR_CampaignAlarmWnd.GoalGage3");
    GoalGage4 = GetBarHandle("BR_CampaignAlarmWnd.GoalGage4");
    GoalGage5 = GetBarHandle("BR_CampaignAlarmWnd.GoalGage5");
    GoalGage6 = GetBarHandle("BR_CampaignAlarmWnd.GoalGage6");
    GoalTitle1 = GetTextBoxHandle("BR_CampaignAlarmWnd.GoalTitle1");
    GoalTitle2 = GetTextBoxHandle("BR_CampaignAlarmWnd.GoalTitle2");
    GoalTitle3 = GetTextBoxHandle("BR_CampaignAlarmWnd.GoalTitle3");
    GoalTitle4 = GetTextBoxHandle("BR_CampaignAlarmWnd.GoalTitle4");
    GoalTitle5 = GetTextBoxHandle("BR_CampaignAlarmWnd.GoalTitle5");
    GoalTitle6 = GetTextBoxHandle("BR_CampaignAlarmWnd.GoalTitle6");
    util = L2Util(GetScript("L2Util"));
    arrStatus.Length = 6;
    arrGoalTitle.Length = 6;
    arrStatus[0] = GoalGage1;
    arrStatus[1] = GoalGage2;
    arrStatus[2] = GoalGage3;
    arrStatus[3] = GoalGage4;
    arrStatus[4] = GoalGage5;
    arrStatus[5] = GoalGage6;
    arrGoalTitle[0] = GoalTitle1;
    arrGoalTitle[1] = GoalTitle2;
    arrGoalTitle[2] = GoalTitle3;
    arrGoalTitle[3] = GoalTitle4;
    arrGoalTitle[4] = GoalTitle5;
    arrGoalTitle[5] = GoalTitle6;
    OnRegisterEvent();
    return;
}

function OnClickButton(string strID)
{
    // End:0x36
    if(strID == "CampaignInfoButton")
    {
        RequestEventCampaignHtml(Mid, mSTEP, mGoalGroupID);        
    }
    else
    {
        // End:0x63
        if(strID == "Resultbtn")
        {
            RequestEventCampaignHtml(Mid, mSTEP, mGoalGroupID);            
        }
        else
        {
            // End:0x89
            if(strID == "CloseButton")
            {
                Me.HideWindow();
            }
        }
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x24
    if(TimerID == 501)
    {
        RequestEventCampaignProgressInfo(Mid, mSTEP, mGoalGroupID);
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 9500:
            CampaignArrived(param);
            // End:0x5A
            break;
        // End:0x33
        case 9510:
            CampaignProgressInfo(param);
            // End:0x5A
            break;
        // End:0x49
        case 9520:
            CampaignFinish(param);
            // End:0x5A
            break;
        // End:0x57
        case 40:
            initCampaign();
            // End:0x5A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function initCampaign()
{
    bAccpept = false;
    Me.KillTimer(501);
    return;
}

function CampaignArrived(string param)
{
    local int Id, Step, GoalGroupID;

    initCampaign();
    ParseInt(param, "ID", Id);
    ParseInt(param, "STEP", Step);
    ParseInt(param, "GOALGROUPID", GoalGroupID);
    Mid = Id;
    mSTEP = Step;
    mGoalGroupID = GoalGroupID;
    Mstate = 0;
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RadarMapWnd.BR_CampaignBtn");
    Class'NWindow.UIAPI_EFFECTBUTTON'.static.BeginEffect("RadarMapWnd.BR_CampaignBtn", 0);
    return;
}

function CampaignProgressInfo(string param)
{
    local int i, Id, Step, GoalGroupID, State, GoalCnt,
	    ParticipantsCnt, RemainTimeInSec, CurValue, GoalValue;

    local EventContentInfo Info;
    local NoticeWnd notice;

    // End:0x67
    if(bAccpept == false)
    {
        notice = NoticeWnd(GetScript("NoticeWnd"));
        notice.ClearBRCampaignBtn();
        Me.ShowWindow();
        bAccpept = true;
        Me.SetTimer(501, 5000);
    }
    ParseInt(param, "ID", Id);
    ParseInt(param, "STEP", Step);
    ParseInt(param, "GOALGROUPID", GoalGroupID);
    ParseInt(param, "STATE", State);
    ParseInt(param, "GoalCnt", GoalCnt);
    ParseInt(param, "ParticipantsCnt", ParticipantsCnt);
    ParseInt(param, "RemainTimeInSec", RemainTimeInSec);
    Mid = Id;
    mSTEP = Step;
    mGoalGroupID = GoalGroupID;
    Mstate = State;
    GetEventContentInfo(Id, Step, GoalGroupID, Info);
    Time.SetText(util.TimeNumberToHangulHourMin(RemainTimeInSec));
    SetWindowSize(GoalCnt, State);
    setWindowShow(GoalCnt, Info);
    i = 0;
    J0x1B0:

    // End:0x231 [Loop If]
    if(i < GoalCnt)
    {
        ParseInt(param, "CurValue_" $ string(i), CurValue);
        ParseInt(param, "GoalValue_" $ string(i), GoalValue);
        arrStatus[i].SetValue(GoalValue, CurValue);
        i++;
        // [Loop Continue]
        goto J0x1B0;
    }
    return;
}

function CampaignFinish(string param)
{
    local int Id, Step, GoalGroupID;

    ParseInt(param, "ID", Id);
    ParseInt(param, "STEP", Step);
    ParseInt(param, "GOALGROUPID", GoalGroupID);
    Mid = Id;
    mSTEP = Step;
    Mstate = 0;
    mGoalGroupID = GoalGroupID;
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RadarMapWnd.BR_CampaignBtn");
    Me.HideWindow();
    initCampaign();
    return;
}

function SetWindowSize(int Count, int State)
{
    local int Size, h;

    switch(State)
    {
        // End:0x67
        case 1:
            Size = 93;
            h = Size + (33 * (Count - 1));
            TimeTitle.SetText(GetSystemString(1108));
            Resultbtn.HideWindow();
            Divider.HideWindow();
            // End:0x1C9
            break;
        // End:0xDC
        case 2:
            Size = 125;
            h = Size + (33 * (Count - 1));
            TimeTitle.SetText(GetSystemString(2423));
            Resultbtn.SetButtonName(2279);
            Resultbtn.ShowWindow();
            Divider.ShowWindow();
            // End:0x1C9
            break;
        // End:0x151
        case 3:
            Size = 125;
            h = Size + (33 * (Count - 1));
            TimeTitle.SetText(GetSystemString(2423));
            Resultbtn.SetButtonName(2426);
            Resultbtn.ShowWindow();
            Divider.ShowWindow();
            // End:0x1C9
            break;
        // End:0x1C6
        case 4:
            Size = 125;
            h = Size + (33 * (Count - 1));
            TimeTitle.SetText(GetSystemString(2424));
            Resultbtn.SetButtonName(2425);
            Resultbtn.ShowWindow();
            Divider.ShowWindow();
            // End:0x1C9
            break;
        // End:0xFFFF
        default:
            break;
    }
    Me.super(BR_CampaignAlarmWnd).SetWindowSize(213, h);
    return;
}

function setWindowShow(int Count, EventContentInfo Info)
{
    local int i;

    CampaignTitle.SetText(Info.Name);
    CampaignTitle.SetTextEllipsisWidth(160);
    CampaignTitle.SetTooltipString(Info.ToolTip);
    i = 0;
    J0x4A:

    // End:0xF1 [Loop If]
    if(i < 6)
    {
        // End:0xBD
        if(i < Count)
        {
            arrGoalTitle[i].ShowWindow();
            arrGoalTitle[i].SetText("- " $ Info.GoalDescription[i]);
            arrStatus[i].ShowWindow();
            // [Explicit Continue]
            goto J0xE7;
        }
        arrGoalTitle[i].HideWindow();
        arrStatus[i].HideWindow();
        J0xE7:

        i++;
        // [Loop Continue]
        goto J0x4A;
    }
    return;
}

function RaderButtonClick()
{
    // End:0x23
    if(Mstate == 0)
    {
        RequestEventCampaignHtml(Mid, mSTEP, mGoalGroupID);        
    }
    else
    {
        // End:0x49
        if(!Me.IsShowWindow())
        {
            Me.ShowWindow();            
        }
        else
        {
            Me.HideWindow();
        }
    }
    return;
}

function int getCampaignState()
{
    return Mstate;
    return;
}
