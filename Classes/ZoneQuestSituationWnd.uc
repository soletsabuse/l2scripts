class ZoneQuestSituationWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle ZoneQuestTitle;
var ListCtrlHandle ZoneQuestTopContributorList;
var TextBoxHandle mMyRanking;
var TextBoxHandle mMyName;
var TextBoxHandle mMyBasicContributeScore;
var TextBoxHandle mMyAdditionContributeScore;
var TextBoxHandle mMyTotalContributeScore;
var TextBoxHandle Time;
var TextBoxHandle ParticipantsCounter;

function OnRegisterEvent()
{
    RegisterEvent(5302);
    return;
}

function OnLoad()
{
    OnRegisterEvent();
    Me = GetWindowHandle("ZoneQuestSituationWnd");
    ZoneQuestTitle = GetTextBoxHandle("ZoneQuestSituationWnd.ZoneQuestTitle");
    ZoneQuestTopContributorList = GetListCtrlHandle("ZoneQuestSituationWnd.ZoneQuestTopContributorList");
    mMyRanking = GetTextBoxHandle("ZoneQuestSituationWnd.MyRanking");
    mMyName = GetTextBoxHandle("ZoneQuestSituationWnd.MyName");
    mMyBasicContributeScore = GetTextBoxHandle("ZoneQuestSituationWnd.MyBasicContributeScore");
    mMyAdditionContributeScore = GetTextBoxHandle("ZoneQuestSituationWnd.MyAdditionContributeScore");
    mMyTotalContributeScore = GetTextBoxHandle("ZoneQuestSituationWnd.MyTotalContributeScore");
    Time = GetTextBoxHandle("ZoneQuestSituationWnd.Time");
    ParticipantsCounter = GetTextBoxHandle("ZoneQuestSituationWnd.ParticipantsCounter");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 5302:
            ZoneQuestResult(param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ZoneQuestResult(string param)
{
    local LVDataRecord Record;
    local int i, Id, Step, ListCnt, MyRanking;

    local string MyName;
    local int MyStandardPoint, MyExtraPoint, MyTotalPoint;
    local string Name;
    local int StandardPoint, ExtraPoint, TotalPoint;
    local DynamicContentInfo Info;
    local Color C;

    C.R = 222;
    C.G = 196;
    C.B = 126;
    ZoneQuestTopContributorList.DeleteAllItem();
    Record.LVDataList.Length = 5;
    ParseInt(param, "ID", Id);
    ParseInt(param, "STEP", Step);
    ParseInt(param, "ListCnt", ListCnt);
    ParseInt(param, "MyRanking", MyRanking);
    ParseString(param, "MyName", MyName);
    ParseInt(param, "MyStandardPoint", MyStandardPoint);
    ParseInt(param, "MyExtraPoint", MyExtraPoint);
    ParseInt(param, "MyTotalPoint", MyTotalPoint);
    GetDynamicContentInfo(Id, Step, Info);
    mMyRanking.SetText(string(MyRanking));
    mMyName.SetText(MyName);
    mMyBasicContributeScore.SetText(string(MyStandardPoint));
    mMyAdditionContributeScore.SetText(string(MyExtraPoint));
    mMyTotalContributeScore.SetText(string(MyTotalPoint));
    ZoneQuestTitle.SetText(Info.Title);
    ZoneQuestTitle.SetTextColor(C);
    i = 0;
    J0x1CC:

    // End:0x30F [Loop If]
    if(i < ListCnt)
    {
        ParseString(param, "Name_" $ string(i), Name);
        ParseInt(param, "StandardPoint_" $ string(i), StandardPoint);
        ParseInt(param, "ExtraPoint_" $ string(i), ExtraPoint);
        ParseInt(param, "TotalPoint_" $ string(i), TotalPoint);
        Record.LVDataList[0].szData = string(i + 1);
        Record.LVDataList[1].szData = Name;
        Record.LVDataList[2].szData = string(StandardPoint);
        Record.LVDataList[3].szData = string(ExtraPoint);
        Record.LVDataList[4].szData = string(TotalPoint);
        ZoneQuestTopContributorList.InsertRecord(Record);
        i++;
        // [Loop Continue]
        goto J0x1CC;
    }
    return;
}

function showTimeCounter(string strTime, string strCounter)
{
    Time.SetText(strTime);
    ParticipantsCounter.SetText(strCounter);
    return;
}

function OnClickButton(string strID)
{
    local ZoneQuestAlarmWnd script;

    script = ZoneQuestAlarmWnd(GetScript("ZoneQuestAlarmWnd"));
    // End:0x4A
    if(strID == "CloseBtn")
    {
        Me.HideWindow();        
    }
    else
    {
        // End:0x87
        if(strID == "RewardInfoBtn")
        {
            RequestDynamicContentHtml(script.getZoneQuestID(), script.getZoneQuestSTEP());
        }
    }
    return;
}
