class ManorSeedInfoSettingWnd extends UICommonAPI;

const SEED_NAME = 0;
const TODAY_VOLUME_OF_SALES = 1;
const TODAY_PRICE = 2;
const TOMORROW_VOLUME_OF_SALES = 3;
const TOMORROW_PRICE = 4;
const MINIMUM_CROP_PRICE = 5;
const MAXIMUM_CROP_PRICE = 6;
const SEED_LEVEL = 7;
const REWARD_TYPE_1 = 8;
const REWARD_TYPE_2 = 9;
const COLUMN_CNT = 10;
const DIALOG_ID_STOP = 555;
const DIALOG_ID_SETTODAY = 666;

var int m_ManorID;
var INT64 m_SumOfDefaultPrice;
var string m_WindowName;
var ListCtrlHandle m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl;

function OnRegisterEvent()
{
    RegisterEvent(2656);
    RegisterEvent(2657);
    RegisterEvent(2658);
    RegisterEvent(2659);
    RegisterEvent(1710);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    m_ManorID = -1;
    m_SumOfDefaultPrice = (0);
    m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl = GetListCtrlHandle(m_WindowName $ ".ManorSeedInfoSettingListCtrl");
    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 2656:
            handleShow(a_Param);
            // End:0x8D
            break;
        // End:0x33
        case 2657:
            HandleAddItem(a_Param);
            // End:0x8D
            break;
        // End:0x63
        case 2658:
            CalculateSumOfDefaultPrice();
            ShowWindowWithFocus("ManorSeedInfoSettingWnd");
            // End:0x8D
            break;
        // End:0x79
        case 2659:
            HandleChangeValue(a_Param);
            // End:0x8D
            break;
        // End:0x8A
        case 1710:
            HandleDialogOK();
            // End:0x8D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleDialogOK()
{
    local int dialogID;

    // End:0x0D
    if(!DialogIsMine())
    {
        return;
    }
    dialogID = DialogGetID();
    switch(dialogID)
    {
        // End:0x31
        case 555:
            HandleStop();
            // End:0x45
            break;
        // End:0x42
        case 666:
            HandleSetToday();
            // End:0x45
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleStop()
{
    local int i, RecordCnt;
    local LVDataRecord Record, recordClear;

    RecordCnt = m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();
    i = 0;
    J0x1C:

    // End:0x9E [Loop If]
    if(i < RecordCnt)
    {
        Record = recordClear;
        m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, Record);
        Record.LVDataList[3].szData = "0";
        Record.LVDataList[4].szData = "0";
        m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.ModifyRecord(i, Record);
        ++i;
        // [Loop Continue]
        goto J0x1C;
    }
    CalculateSumOfDefaultPrice();
    return;
}

function HandleSetToday()
{
    local int i, RecordCnt;
    local LVDataRecord Record, recordClear;

    RecordCnt = m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();
    i = 0;
    J0x1C:

    // End:0xBB [Loop If]
    if(i < RecordCnt)
    {
        Record = recordClear;
        m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, Record);
        Record.LVDataList[3].szData = Record.LVDataList[1].szData;
        Record.LVDataList[4].szData = Record.LVDataList[2].szData;
        m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.ModifyRecord(i, Record);
        ++i;
        // [Loop Continue]
        goto J0x1C;
    }
    CalculateSumOfDefaultPrice();
    return;
}

function handleShow(string a_Param)
{
    local int ManorID;
    local string ManorName;

    ParseInt(a_Param, "ManorID", ManorID);
    ParseString(a_Param, "ManorName", ManorName);
    m_ManorID = ManorID;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoSettingWnd.txtManorName", ManorName);
    DeleteAll();
    return;
}

function HandleChangeValue(string a_Param)
{
    local INT64 TomorrowSalesVolume, TomorrowPrice;
    local LVDataRecord Record;
    local int SelectedIndex;

    ParseINT64(a_Param, "TomorrowSalesVolume", TomorrowSalesVolume);
    ParseINT64(a_Param, "TomorrowPrice", TomorrowPrice);
    SelectedIndex = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl");
    m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetSelectedRec(Record);
    Record.LVDataList[3].szData = (TomorrowSalesVolume);
    Record.LVDataList[4].szData = (TomorrowPrice);
    Class'NWindow.UIAPI_LISTCTRL'.static.ModifyRecord("ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl", SelectedIndex, Record);
    CalculateSumOfDefaultPrice();
    return;
}

function DeleteAll()
{
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl");
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    switch(ListCtrlID)
    {
        // End:0x5B
        case "ManorSeedInfoSettingListCtrl":
            // End:0x58
            if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ManorSeedInfoChangeWnd"))
            {
                OnChangeBtn();
            }
            // End:0x5E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnDBClickListCtrlRecord(string strID)
{
    switch(strID)
    {
        // End:0x31
        case "ManorSeedInfoSettingListCtrl":
            OnChangeBtn();
            // End:0x34
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x22
        case "btnChangeSell":
            OnChangeBtn();
            // End:0xD0
            break;
        // End:0x58
        case "btnSetToday":
            DialogSetID(666);
            DialogShow(1, 4, GetSystemMessage(1601), string(self));
            // End:0xD0
            break;
        // End:0x8A
        case "btnStop":
            DialogSetID(555);
            DialogShow(1, 4, GetSystemMessage(1600), string(self));
            // End:0xD0
            break;
        // End:0x9D
        case "btnOk":
            OnOk();
            // End:0xD0
            break;
        // End:0xCD
        case "btnCancel":
            HideWindow("ManorSeedInfoSettingWnd");
            // End:0xD0
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnOk()
{
    local int recordCount;
    local LVDataRecord Record, recordClear;
    local int i;
    local string param;

    recordCount = m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();
    ParamAdd(param, "ManorID", string(m_ManorID));
    ParamAdd(param, "SeedCnt", string(recordCount));
    i = 0;
    J0x52:

    // End:0x127 [Loop If]
    if(i < recordCount)
    {
        Record = recordClear;
        m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, Record);
        ParamAdd(param, "SeedID" $ string(i), (Record.nReserved1));
        ParamAdd(param, "TomorrowSalesVolume" $ string(i), Record.LVDataList[3].szData);
        ParamAdd(param, "TomorrowPrice" $ string(i), Record.LVDataList[4].szData);
        ++i;
        // [Loop Continue]
        goto J0x52;
    }
    RequestSetSeed(param);
    HideWindow("ManorSeedInfoSettingWnd");
    return;
}

function OnChangeBtn()
{
    local LVDataRecord Record;
    local string param;

    // End:0x2C
    if(m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetSelectedIndex() == -1)
    {
        AddSystemMessageString(GetSystemMessage(326));
        return;
    }
    m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetSelectedRec(Record);
    ParamAdd(param, "SeedName", Record.LVDataList[0].szData);
    ParamAdd(param, "TomorrowVolumeOfSales", Record.LVDataList[3].szData);
    ParamAdd(param, "TomorrowLimit", (Record.nReserved2));
    ParamAdd(param, "TomorrowPrice", Record.LVDataList[4].szData);
    ParamAdd(param, "MinCropPrice", Record.LVDataList[5].szData);
    ParamAdd(param, "MaxCropPrice", Record.LVDataList[6].szData);
    ExecuteEvent(2660, param);
    return;
}

function HandleAddItem(string a_Param)
{
    local LVDataRecord Record;
    local int SeedID;
    local string SeedName;
    local int TodaySeedTotalCnt;
    local INT64 TodaySeedPrice, NextSeedTotalCnt, NextSeedPrice;
    local int MinCropPrice, MaxCropPrice, SeedLevel;
    local string RewardType1, RewardType2;
    local INT64 MaxSeedTotalCnt;
    local int DefaultSeedPrice;

    ParseInt(a_Param, "SeedID", SeedID);
    ParseString(a_Param, "SeedName", SeedName);
    ParseInt(a_Param, "TodaySeedTotalCnt", TodaySeedTotalCnt);
    ParseINT64(a_Param, "TodaySeedPrice", TodaySeedPrice);
    ParseINT64(a_Param, "TodayNextSeedTotalCnt", NextSeedTotalCnt);
    ParseINT64(a_Param, "NextSeedPrice", NextSeedPrice);
    ParseInt(a_Param, "MinCropPrice", MinCropPrice);
    ParseInt(a_Param, "MaxCropPrice", MaxCropPrice);
    ParseInt(a_Param, "SeedLevel", SeedLevel);
    ParseString(a_Param, "RewardType1", RewardType1);
    ParseString(a_Param, "RewardType2", RewardType2);
    ParseINT64(a_Param, "MaxSeedTotalCnt", MaxSeedTotalCnt);
    ParseInt(a_Param, "DefaultSeedPrice", DefaultSeedPrice);
    Record.LVDataList.Length = 10;
    Record.LVDataList[0].szData = SeedName;
    Record.LVDataList[1].szData = string(TodaySeedTotalCnt);
    Record.LVDataList[2].szData = (TodaySeedPrice);
    Record.LVDataList[3].szData = (NextSeedTotalCnt);
    Record.LVDataList[4].szData = (NextSeedPrice);
    Record.LVDataList[5].szData = string(MinCropPrice);
    Record.LVDataList[6].szData = string(MaxCropPrice);
    Record.LVDataList[7].szData = string(SeedLevel);
    Record.LVDataList[8].szData = RewardType1;
    Record.LVDataList[9].szData = RewardType2;
    Record.nReserved1 = (SeedID);
    Record.nReserved2 = MaxSeedTotalCnt;
    Record.nReserved3 = (DefaultSeedPrice);
    Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl", Record);
    return;
}

function CalculateSumOfDefaultPrice()
{
    local LVDataRecord Record, recordClear;
    local int ItemCnt, i;
    local INT64 tmpMulti;
    local string adenaString;

    m_SumOfDefaultPrice = (0);
    ItemCnt = m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();
    i = 0;
    J0x25:

    // End:0x96 [Loop If]
    if(i < ItemCnt)
    {
        Record = recordClear;
        m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, Record);
        tmpMulti = __NFUN_401__(Record.nReserved3, (Record.LVDataList[3].szData));
        __NFUN_406__(m_SumOfDefaultPrice, tmpMulti);
        ++i;
        // [Loop Continue]
        goto J0x25;
    }
    adenaString = MakeCostString((m_SumOfDefaultPrice));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoSettingWnd.txtVarNextTotalExpense", adenaString);
    return;
}

defaultproperties
{
    m_WindowName="ManorSeedInfoSettingWnd"
}