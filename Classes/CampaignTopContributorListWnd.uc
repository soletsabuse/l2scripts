class CampaignTopContributorListWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle CampaignTitle;
var ListCtrlHandle CampaignTopContributorList;

function OnRegisterEvent()
{
    RegisterEvent(5301);
    return;
}

function OnLoad()
{
    OnRegisterEvent();
    Me = GetWindowHandle("CampaignTopContributorListWnd");
    CampaignTitle = GetTextBoxHandle("CampaignTopContributorListWnd.CampaignTitle");
    CampaignTopContributorList = GetListCtrlHandle("CampaignTopContributorListWnd.CampaignTopContributorList");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 5301:
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
    local int i, Id, Step, ListCnt;
    local string Name;
    local DynamicContentInfo Info;
    local Color C;

    C.R = 222;
    C.G = 196;
    C.B = 126;
    CampaignTopContributorList.DeleteAllItem();
    Record.LVDataList.Length = 1;
    ParseInt(param, "ID", Id);
    ParseInt(param, "STEP", Step);
    ParseInt(param, "ListCnt", ListCnt);
    GetDynamicContentInfo(Id, Step, Info);
    CampaignTitle.SetText(Info.Title);
    CampaignTitle.SetTextColor(C);
    i = 0;
    J0xCF:

    // End:0x133 [Loop If]
    if(i < ListCnt)
    {
        ParseString(param, "Name_" $ string(i), Name);
        Record.LVDataList[0].szData = Name;
        CampaignTopContributorList.InsertRecord(Record);
        i++;
        // [Loop Continue]
        goto J0xCF;
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
