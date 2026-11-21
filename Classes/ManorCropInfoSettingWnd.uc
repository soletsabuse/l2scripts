class ManorCropInfoSettingWnd extends UICommonAPI;

const CROP_NAME = 0;
const TODAY_CROP_TOTOAL_CNT = 1;
const TODAY_CROP_PRICE = 2;
const TODAY_PROCURE_TYPE = 3;
const NEXT_CROP_TOTAL_CNT = 4;
const NEXT_CROP_PRICE = 5;
const NEXT_PROCURE_TYPE = 6;
const MIN_CROP_PRICE = 7;
const MAX_CROP_PRICE = 8;
const CROP_LELEL = 9;
const REWARD_TYPE_1 = 10;
const REWARD_TYPE_2 = 11;
const COLUMN_CNT = 12;
const DIALOG_ID_STOP = 777;
const DIALOG_ID_SETTODAY = 888;

var int m_ManorID;
var INT64 m_SumOfDefaultPrice;
var string m_WindowName;
var ListCtrlHandle m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl;

function OnRegisterEvent()
{
    RegisterEvent(2665);
    RegisterEvent(2666);
    RegisterEvent(2667);
    RegisterEvent(2668);
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
    m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl = GetListCtrlHandle(m_WindowName $ ".ManorCropInfoSettingListCtrl");
    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 2665:
            handleShow(a_Param);
            // End:0x8D
            break;
        // End:0x33
        case 2666:
            HandleAddItem(a_Param);
            // End:0x8D
            break;
        // End:0x63
        case 2667:
            CalculateSumOfDefaultPrice();
            ShowWindowWithFocus("ManorCropInfoSettingWnd");
            // End:0x8D
            break;
        // End:0x79
        case 2668:
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
        case 777:
            HandleStop();
            // End:0x45
            break;
        // End:0x42
        case 888:
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

    RecordCnt = m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();
    i = 0;
    J0x1C:

    // End:0xEA [Loop If]
    if(i < RecordCnt)
    {
        Record = recordClear;
        m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec(i, Record);
        Record.LVDataList[4].szData = "0";
        Record.LVDataList[5].szData = "0";
        Record.LVDataList[6].szData = "0";
        Class'NWindow.UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", i, Record);
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

    RecordCnt = m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();
    i = 0;
    J0x1C:

    // End:0x116 [Loop If]
    if(i < RecordCnt)
    {
        Record = recordClear;
        m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec(i, Record);
        Record.LVDataList[4].szData = Record.LVDataList[1].szData;
        Record.LVDataList[5].szData = Record.LVDataList[2].szData;
        Record.LVDataList[6].szData = Record.LVDataList[3].szData;
        Class'NWindow.UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", i, Record);
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
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorCropInfoSettingWnd.txtManorName", ManorName);
    DeleteAll();
    return;
}

function DeleteAll()
{
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl");
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    switch(ListCtrlID)
    {
        // End:0x5B
        case "ManorCropInfoSettingListCtrl":
            // End:0x58
            if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ManorCropInfoChangeWnd"))
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
        case "ManorCropInfoSettingListCtrl":
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
            // End:0xEF
            break;
        // End:0x58
        case "btnSetToday":
            DialogSetID(888);
            DialogShow(1, 4, GetSystemMessage(1601), string(self));
            // End:0xEF
            break;
        // End:0x8A
        case "btnStop":
            DialogSetID(777);
            DialogShow(1, 4, GetSystemMessage(1600), string(self));
            // End:0xEF
            break;
        // End:0xBC
        case "btnOk":
            OnOk();
            HideWindow("ManorCropInfoSettingWnd");
            // End:0xEF
            break;
        // End:0xEC
        case "btnCancel":
            HideWindow("ManorCropInfoSettingWnd");
            // End:0xEF
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

    recordCount = m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();
    ParamAdd(param, "ManorID", string(m_ManorID));
    ParamAdd(param, "CropCnt", string(recordCount));
    i = 0;
    J0x52:

    // End:0x145 [Loop If]
    if(i < recordCount)
    {
        Record = recordClear;
        m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec(i, Record);
        ParamAdd(param, "CropID" $ string(i), (Record.nReserved1));
        ParamAdd(param, "BuyCnt" $ string(i), Record.LVDataList[4].szData);
        ParamAdd(param, "Price" $ string(i), Record.LVDataList[5].szData);
        ParamAdd(param, "ProcureType" $ string(i), Record.LVDataList[6].szData);
        ++i;
        // [Loop Continue]
        goto J0x52;
    }
    RequestSetCrop(param);
    return;
}

function HandleAddItem(string a_Param)
{
    local LVDataRecord Record;
    local int CropID;
    local string CropName;
    local INT64 TodayCropTotalCnt, TodayCropPrice;
    local int TodayProcureType;
    local INT64 NextCropTotalCnt, NextCropPrice;
    local int NextProcureType, MinCropPrice, MaxCropPrice, CropLevel;
    local string RewardType1, RewardType2;
    local int MaxCropTotalCnt, DefaultCropPrice;

    ParseInt(a_Param, "CropID", CropID);
    ParseString(a_Param, "CropName", CropName);
    ParseINT64(a_Param, "TodayCropTotalCnt", TodayCropTotalCnt);
    ParseINT64(a_Param, "TodayCropPrice", TodayCropPrice);
    ParseInt(a_Param, "TodayProcureType", TodayProcureType);
    ParseINT64(a_Param, "NextCropTotalCnt", NextCropTotalCnt);
    ParseINT64(a_Param, "NextCropPrice", NextCropPrice);
    ParseInt(a_Param, "NextProcureType", NextProcureType);
    ParseInt(a_Param, "MinCropPrice", MinCropPrice);
    ParseInt(a_Param, "MaxCropPrice", MaxCropPrice);
    ParseInt(a_Param, "CropLevel", CropLevel);
    ParseString(a_Param, "RewardType1", RewardType1);
    ParseString(a_Param, "RewardType2", RewardType2);
    ParseInt(a_Param, "MaxCropTotalCnt", MaxCropTotalCnt);
    ParseInt(a_Param, "DefaultCropPrice", DefaultCropPrice);
    Record.LVDataList.Length = 12;
    Record.LVDataList[0].szData = CropName;
    Record.LVDataList[1].szData = (TodayCropTotalCnt);
    Record.LVDataList[2].szData = (TodayCropPrice);
    Record.LVDataList[3].szData = string(TodayProcureType);
    Record.LVDataList[4].szData = (NextCropTotalCnt);
    Record.LVDataList[5].szData = (NextCropPrice);
    Record.LVDataList[6].szData = string(NextProcureType);
    Record.LVDataList[7].szData = string(MinCropPrice);
    Record.LVDataList[8].szData = string(MaxCropPrice);
    Record.LVDataList[9].szData = string(CropLevel);
    Record.LVDataList[10].szData = RewardType1;
    Record.LVDataList[11].szData = RewardType2;
    Record.nReserved1 = (CropID);
    Record.nReserved2 = (MaxCropTotalCnt);
    Record.nReserved3 = (DefaultCropPrice);
    Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", Record);
    return;
}

function CalculateSumOfDefaultPrice()
{
    local LVDataRecord Record, recordClear;
    local int ItemCnt, i;
    local INT64 tmpMulti;
    local string adenaString;

    m_SumOfDefaultPrice = (0);
    ItemCnt = m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();
    i = 0;
    J0x25:

    // End:0xA0 [Loop If]
    if(i < ItemCnt)
    {
        Record = recordClear;
        m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec(i, Record);
        tmpMulti = __NFUN_401__((Record.LVDataList[5].szData), (Record.LVDataList[4].szData));
        __NFUN_406__(m_SumOfDefaultPrice, tmpMulti);
        ++i;
        // [Loop Continue]
        goto J0x25;
    }
    adenaString = MakeCostString((m_SumOfDefaultPrice));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorCropInfoSettingWnd.txtVarNextTotalExpense", adenaString);
    return;
}

function OnChangeBtn()
{
    local LVDataRecord Record;
    local string param;

    // End:0x2C
    if(m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetSelectedIndex() == -1)
    {
        AddSystemMessageString(GetSystemMessage(326));
        return;
    }
    m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetSelectedRec(Record);
    ParamAdd(param, "CropName", Record.LVDataList[0].szData);
    ParamAdd(param, "TomorrowVolumeOfBuy", Record.LVDataList[4].szData);
    ParamAdd(param, "TomorrowLimit", (Record.nReserved2));
    ParamAdd(param, "TomorrowPrice", Record.LVDataList[5].szData);
    ParamAdd(param, "TomorrowProcure", Record.LVDataList[6].szData);
    ParamAdd(param, "MinCropPrice", Record.LVDataList[7].szData);
    ParamAdd(param, "MaxCropPrice", Record.LVDataList[8].szData);
    ExecuteEvent(2670, param);
    return;
}

function HandleChangeValue(string a_Param)
{
    local INT64 TomorrowAmountOfPurchase, TomorrowPurchasePrice;
    local int TomorrowProcure;
    local LVDataRecord Record;
    local int SelectedIndex;

    ParseINT64(a_Param, "TomorrowAmountOfPurchase", TomorrowAmountOfPurchase);
    ParseINT64(a_Param, "TomorrowPurchasePrice", TomorrowPurchasePrice);
    ParseInt(a_Param, "TomorrowProcure", TomorrowProcure);
    SelectedIndex = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl");
    m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetSelectedRec(Record);
    Record.LVDataList[4].szData = (TomorrowAmountOfPurchase);
    Record.LVDataList[5].szData = (TomorrowPurchasePrice);
    Record.LVDataList[6].szData = string(TomorrowProcure);
    Class'NWindow.UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", SelectedIndex, Record);
    CalculateSumOfDefaultPrice();
    return;
}

defaultproperties
{
    m_WindowName="ManorCropInfoSettingWnd"
}