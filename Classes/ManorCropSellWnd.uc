class ManorCropSellWnd extends UICommonAPI;

const CROP_NAME = 0;
const MANOR_NAME = 1;
const CROP_REMAIN_CNT = 2;
const CROP_PRICE = 3;
const PROCURE_TYPE = 4;
const MY_CROP_CNT = 5;
const SELL_CNT = 6;
const CROP_LEVEL = 7;
const REWARD_TYPE_1 = 8;
const REWARD_TYPE_2 = 9;
const COLUMN_CNT = 10;

var string m_WindowName;
var ListCtrlHandle m_hManorCropSellWndManorCropSellListCtrl;

function OnRegisterEvent()
{
    RegisterEvent(2640);
    RegisterEvent(2645);
    RegisterEvent(2646);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    m_hManorCropSellWndManorCropSellListCtrl = GetListCtrlHandle(m_WindowName $ ".ManorCropSellListCtrl");
    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    switch(Event_ID)
    {
        // End:0x66
        case 2640:
            // End:0x45
            if(IsShowWindow("ManorCropSellWnd"))
            {
                HideWindow("ManorCropSellWnd");                
            }
            else
            {
                DeleteAll();
                ShowWindowWithFocus("ManorCropSellWnd");
            }
            // End:0x95
            break;
        // End:0x7C
        case 2645:
            HandleAddItem(a_Param);
            // End:0x95
            break;
        // End:0x92
        case 2646:
            HandleSetCropSell(a_Param);
            // End:0x95
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function DeleteAll()
{
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorCropSellWnd.ManorCropSellListCtrl");
    return;
}

function OnDBClickListCtrlRecord(string strID)
{
    switch(strID)
    {
        // End:0x2A
        case "ManorCropSellListCtrl":
            OnChangeBtn();
            // End:0x2D
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
            // End:0x63
            break;
        // End:0x37
        case "btnSell":
            OnSellBtn();
            // End:0x63
            break;
        // End:0x60
        case "btnCancel":
            HideWindow("ManorCropSellWnd");
            // End:0x63
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnSellBtn()
{
    local int recordCount;
    local LVDataRecord Record;
    local INT64 SellCnt;
    local int CropCnt, CropNum, i;
    local string param;

    recordCount = m_hManorCropSellWndManorCropSellListCtrl.GetRecordCount();
    CropCnt = 0;
    i = 0;
    J0x23:

    // End:0x84 [Loop If]
    if(i < recordCount)
    {
        m_hManorCropSellWndManorCropSellListCtrl.GetRec(i, Record);
        SellCnt = (Record.LVDataList[6].szData);
        // End:0x7A
        if(__NFUN_409__(SellCnt, (0)))
        {
            CropCnt++;
        }
        ++i;
        // [Loop Continue]
        goto J0x23;
    }
    ParamAdd(param, "CropCnt", string(CropCnt));
    CropNum = 0;
    i = 0;
    J0xAD:

    // End:0x1B6 [Loop If]
    if(i < recordCount)
    {
        m_hManorCropSellWndManorCropSellListCtrl.GetRec(i, Record);
        SellCnt = (Record.LVDataList[6].szData);
        // End:0x100
        if(__NFUN_410__(SellCnt, (0)))
        {
            // [Explicit Continue]
            goto J0x1AC;
        }
        ParamAdd(param, "CropServerID" $ string(CropNum), (Record.nReserved3));
        ParamAdd(param, "CropID" $ string(CropNum), (Record.nReserved2));
        ParamAdd(param, "ManorID" $ string(CropNum), (Record.nReserved1));
        ParamAdd(param, "SellCount" $ string(CropNum), (SellCnt));
        CropNum++;
        J0x1AC:

        ++i;
        // [Loop Continue]
        goto J0xAD;
    }
    RequestProcureCropList(param);
    HideWindow("ManorCropSellWnd");
    return;
}

function OnChangeBtn()
{
    local LVDataRecord Record;
    local int SelectedIndex, CropID;
    local string ManorCropSellChangeWndString, param;

    SelectedIndex = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorCropSellWnd.ManorCropSellListCtrl");
    // End:0x4E
    if(SelectedIndex == -1)
    {
        return;
    }
    m_hManorCropSellWndManorCropSellListCtrl.GetSelectedRec(Record);
    CropID = name(Record.nReserved2);
    ManorCropSellChangeWndString = ("manor_menu_select?ask=9&state=" $ string(CropID)) $ "&time=0";
    RequestBypassToServer(ManorCropSellChangeWndString);
    ParamAdd(param, "CropName", Record.LVDataList[0].szData);
    ParamAdd(param, "RewardType1", Record.LVDataList[8].szData);
    ParamAdd(param, "RewardType2", Record.LVDataList[9].szData);
    ExecuteEvent(2649, param);
    return;
}

function HandleAddItem(string a_Param)
{
    local LVDataRecord Record;
    local string CropName, ManorName;
    local INT64 CropRemainCnt, CropPrice;
    local int ProcureType;
    local INT64 MyCropCnt;
    local int CropLevel;
    local string RewardType1, RewardType2;
    local int ManorID, CropID, CropServerID;

    Record.LVDataList.Length = 10;
    ParseString(a_Param, "CropName", CropName);
    ParseString(a_Param, "ManorName", ManorName);
    ParseINT64(a_Param, "CropRemainCnt", CropRemainCnt);
    ParseINT64(a_Param, "CropPrice", CropPrice);
    ParseInt(a_Param, "ProcureType", ProcureType);
    ParseINT64(a_Param, "MyCropCnt", MyCropCnt);
    ParseInt(a_Param, "CropLevel", CropLevel);
    ParseString(a_Param, "RewardType1", RewardType1);
    ParseString(a_Param, "RewardType2", RewardType2);
    ParseInt(a_Param, "ManorID", ManorID);
    ParseInt(a_Param, "CropID", CropID);
    ParseInt(a_Param, "CropServerID", CropServerID);
    Record.LVDataList[0].szData = CropName;
    Record.LVDataList[1].szData = ManorName;
    Record.LVDataList[2].szData = (CropRemainCnt);
    Record.LVDataList[3].szData = (CropPrice);
    Record.LVDataList[4].szData = string(ProcureType);
    Record.LVDataList[5].szData = (MyCropCnt);
    Record.LVDataList[6].szData = "0";
    Record.LVDataList[7].szData = string(CropLevel);
    Record.LVDataList[8].szData = RewardType1;
    Record.LVDataList[9].szData = RewardType2;
    Record.nReserved1 = (ManorID);
    Record.nReserved2 = (CropID);
    Record.nReserved3 = (CropServerID);
    Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorCropSellWnd.ManorCropSellListCtrl", Record);
    return;
}

function HandleSetCropSell(string a_Param)
{
    local string SellCntString;
    local int ManorID;
    local string ManorName, CropRemainCntString, CropPriceString, ProcureTypeString;
    local int SelectedIndex;
    local LVDataRecord Record;

    ParseString(a_Param, "SellCntString", SellCntString);
    ParseInt(a_Param, "ManorID", ManorID);
    ParseString(a_Param, "ManorName", ManorName);
    ParseString(a_Param, "CropRemainCntString", CropRemainCntString);
    ParseString(a_Param, "CropPriceString", CropPriceString);
    ParseString(a_Param, "ProcureTypeString", ProcureTypeString);
    m_hManorCropSellWndManorCropSellListCtrl.GetSelectedRec(Record);
    Record.LVDataList[1].szData = ManorName;
    Record.LVDataList[2].szData = CropRemainCntString;
    Record.LVDataList[3].szData = CropPriceString;
    Record.LVDataList[4].szData = ProcureTypeString;
    Record.LVDataList[6].szData = SellCntString;
    Record.nReserved1 = (ManorID);
    SelectedIndex = Class'NWindow.UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorCropSellWnd.ManorCropSellListCtrl");
    Class'NWindow.UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropSellWnd.ManorCropSellListCtrl", SelectedIndex, Record);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="ManorCropSellWnd"
}