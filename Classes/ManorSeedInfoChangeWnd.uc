class ManorSeedInfoChangeWnd extends UICommonAPI;

var INT64 m_MinCropPrice;
var INT64 m_MaxCropPrice;
var INT64 m_TomorrowLimit;

function OnRegisterEvent()
{
    RegisterEvent(2660);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 2660:
            handleShow(a_Param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function handleShow(string a_Param)
{
    local string SeedName;
    local INT64 TomorrowVolumeOfSales, TomorrowLimit, TomorrowPrice, MinCropPrice, MaxCropPrice;

    local string TomorrowLimitString;

    ParseString(a_Param, "SeedName", SeedName);
    ParseINT64(a_Param, "TomorrowVolumeOfSales", TomorrowVolumeOfSales);
    ParseINT64(a_Param, "TomorrowLimit", TomorrowLimit);
    ParseINT64(a_Param, "TomorrowPrice", TomorrowPrice);
    ParseINT64(a_Param, "MinCropPrice", MinCropPrice);
    ParseINT64(a_Param, "MaxCropPrice", MaxCropPrice);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoChangeWnd.txtSeedName", SeedName);
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("ManorSeedInfoChangeWnd.ebTomorrowSalesVolume", (TomorrowVolumeOfSales));
    m_TomorrowLimit = TomorrowLimit;
    TomorrowLimitString = MakeCostString((TomorrowLimit));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoChangeWnd.txtVarTomorrowLimit", TomorrowLimitString);
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("ManorSeedInfoChangeWnd.ebTomorrowPrice", (TomorrowPrice));
    m_MinCropPrice = MinCropPrice;
    m_MaxCropPrice = MaxCropPrice;
    ShowWindowWithFocus("ManorSeedInfoChangeWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ManorSeedInfoChangeWnd.ebTomorrowSalesVolume");
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1A
        case "btnOk":
            OnClickBtnOk();
            // End:0x4C
            break;
        // End:0x49
        case "btnCancel":
            HideWindow("ManorSeedInfoChangeWnd");
            // End:0x4C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickBtnOk()
{
    local INT64 InputTomorrowSalesVolume, InputTomorrowPrice;
    local string ParamString;

    InputTomorrowSalesVolume = (Class'NWindow.UIAPI_EDITBOX'.static.GetString("ManorSeedInfoChangeWnd.ebTomorrowSalesVolume"));
    InputTomorrowPrice = (Class'NWindow.UIAPI_EDITBOX'.static.GetString("ManorSeedInfoChangeWnd.ebTomorrowPrice"));
    // End:0xB9
    if(__NFUN_408__(InputTomorrowSalesVolume, (0)) || __NFUN_409__(InputTomorrowSalesVolume, m_TomorrowLimit))
    {
        ShowErrorDialog((0), m_TomorrowLimit, 1558);
        return;
    }
    // End:0x102
    if(__NFUN_413__(InputTomorrowSalesVolume, (0)) && __NFUN_408__(InputTomorrowPrice, m_MinCropPrice) || __NFUN_409__(InputTomorrowPrice, m_MaxCropPrice))
    {
        ShowErrorDialog(m_MinCropPrice, m_MaxCropPrice, 1557);
        return;
    }
    ParamAdd(ParamString, "TomorrowSalesVolume", (InputTomorrowSalesVolume));
    ParamAdd(ParamString, "TomorrowPrice", (InputTomorrowPrice));
    ExecuteEvent(2659, ParamString);
    HideWindow("ManorSeedInfoChangeWnd");
    return;
}

function ShowErrorDialog(INT64 MinValue, INT64 MaxValue, int SystemStringIdx)
{
    local string ParamString, Message;

    ParamAdd(ParamString, "Type", string(int(1)));
    ParamAdd(ParamString, "param1", (MinValue));
    AddSystemMessageParam(ParamString);
    ParamString = "";
    ParamAdd(ParamString, "Type", string(int(1)));
    ParamAdd(ParamString, "param1", (MaxValue));
    AddSystemMessageParam(ParamString);
    Message = EndSystemMessageParam(SystemStringIdx, true);
    DialogShow(1, 5, Message, string(self));
    return;
}
