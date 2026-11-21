class ManorCropInfoChangeWnd extends UICommonAPI;

var INT64 m_MinCropPrice;
var INT64 m_MaxCropPrice;
var INT64 m_TomorrowLimit;

function OnRegisterEvent()
{
    RegisterEvent(2670);
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
        case 2670:
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
    local string CropName;
    local INT64 TomorrowVolumeOfBuy, TomorrowLimit, TomorrowPrice;
    local int TomorrowProcure;
    local INT64 MinCropPrice, MaxCropPrice;
    local string TomorrowLimitString;

    ParseString(a_Param, "CropName", CropName);
    ParseINT64(a_Param, "TomorrowVolumeOfBuy", TomorrowVolumeOfBuy);
    ParseINT64(a_Param, "TomorrowLimit", TomorrowLimit);
    ParseINT64(a_Param, "TomorrowPrice", TomorrowPrice);
    ParseInt(a_Param, "TomorrowProcure", TomorrowProcure);
    ParseINT64(a_Param, "MinCropPrice", MinCropPrice);
    ParseINT64(a_Param, "MaxCropPrice", MaxCropPrice);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorCropInfoChangeWnd.txtCropName", CropName);
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("ManorCropInfoChangeWnd.ebTomorrowAmountOfPurchase", (TomorrowVolumeOfBuy));
    m_TomorrowLimit = TomorrowLimit;
    TomorrowLimitString = MakeCostString((TomorrowLimit));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorCropInfoChangeWnd.txtVarTomorrowPurchaseLimit", TomorrowLimitString);
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("ManorCropInfoChangeWnd.ebTomorrowPurchasePrice", (TomorrowPrice));
    // End:0x219
    if(TomorrowProcure == 0)
    {
        TomorrowProcure = 1;
    }
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("ManorCropInfoChangeWnd.cbTomorrowReward", TomorrowProcure - 1);
    m_MinCropPrice = MinCropPrice;
    m_MaxCropPrice = MaxCropPrice;
    ShowWindowWithFocus("ManorCropInfoChangeWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ManorCropInfoChangeWnd.ebTomorrowAmountOfPurchase");
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
            HideWindow("ManorCropInfoChangeWnd");
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
    local INT64 InputTomorrowAmountOfPurchase, InputTomorrowPurchasePrice;
    local int InputTomorrowProcure;
    local string Procure;
    local int selectedNum;
    local string ParamString;

    InputTomorrowAmountOfPurchase = (Class'NWindow.UIAPI_EDITBOX'.static.GetString("ManorCropInfoChangeWnd.ebTomorrowAmountOfPurchase"));
    InputTomorrowPurchasePrice = (Class'NWindow.UIAPI_EDITBOX'.static.GetString("ManorCropInfoChangeWnd.ebTomorrowPurchasePrice"));
    // End:0xC6
    if(__NFUN_408__(InputTomorrowAmountOfPurchase, (0)) || __NFUN_409__(InputTomorrowAmountOfPurchase, m_TomorrowLimit))
    {
        ShowErrorDialog((0), m_TomorrowLimit, 1560);
        return;
    }
    // End:0x10F
    if(__NFUN_413__(InputTomorrowAmountOfPurchase, (0)) && __NFUN_408__(InputTomorrowPurchasePrice, m_MinCropPrice) || __NFUN_409__(InputTomorrowPurchasePrice, m_MaxCropPrice))
    {
        ShowErrorDialog(m_MinCropPrice, m_MaxCropPrice, 1559);
        return;
    }
    selectedNum = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("ManorCropInfoChangeWnd.cbTomorrowReward");
    Procure = Class'NWindow.UIAPI_COMBOBOX'.static.GetString("ManorCropInfoChangeWnd.cbTomorrowReward", selectedNum);
    InputTomorrowProcure = int(Procure);
    ParamAdd(ParamString, "TomorrowAmountOfPurchase", (InputTomorrowAmountOfPurchase));
    ParamAdd(ParamString, "TomorrowPurchasePrice", (InputTomorrowPurchasePrice));
    ParamAdd(ParamString, "TomorrowProcure", string(InputTomorrowProcure));
    ExecuteEvent(2668, ParamString);
    HideWindow("ManorCropInfoChangeWnd");
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
