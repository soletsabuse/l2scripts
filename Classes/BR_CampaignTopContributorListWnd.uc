class BR_CampaignTopContributorListWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle CampaignTitle;
var ListCtrlHandle CampaignTopContributorList;

function OnRegisterEvent()
{
    RegisterEvent(9530);
    return;
}

function OnLoad()
{
    OnRegisterEvent();
    Me = GetWindowHandle("BR_CampaignTopContributorListWnd");
    CampaignTitle = GetTextBoxHandle("BR_CampaignTopContributorListWnd.CampaignTitle");
    CampaignTopContributorList = GetListCtrlHandle("BR_CampaignTopContributorListWnd.CampaignTopContributorList");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 9530:
            CampaignResult(param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function CampaignResult(string param)
{
    local LVDataRecord Record;
    local int i, Id, Step, GoalGroupID, ListCnt;

    local string Name;
    local EventContentInfo Info;
    local Color C;

    C.R = 222;
    C.G = 196;
    C.B = 126;
    CampaignTopContributorList.DeleteAllItem();
    Record.LVDataList.Length = 1;
    ParseInt(param, "ID", Id);
    ParseInt(param, "STEP", Step);
    ParseInt(param, "GOALGROUPID", GoalGroupID);
    ParseInt(param, "ListCnt", ListCnt);
    GetEventContentInfo(Id, Step, GoalGroupID, Info);
    CampaignTitle.SetText(Info.Title);
    CampaignTitle.SetTextColor(C);
    i = 0;
    J0xF1:

    // End:0x155 [Loop If]
    if(i < ListCnt)
    {
        ParseString(param, "Name_" $ string(i), Name);
        Record.LVDataList[0].szData = Name;
        CampaignTopContributorList.InsertRecord(Record);
        i++;
        // [Loop Continue]
        goto J0xF1;
    }
    Me.ShowWindow();
    return;
}

function OnClickButton(string strID)
{
    // End:0x22
    if(strID == "btnExit")
    {
        Me.HideWindow();
    }
    return;
}
