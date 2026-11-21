class ManorInfoWnd extends UICommonAPI;

const SEED_NAME = 0;
const SEED_REMAIN_CNT = 1;
const SEED_TOTLAL_CNT = 2;
const SEED_PRICE = 3;
const SEED_LEVEL = 4;
const SEED_REWARD_TYPE_1 = 5;
const SEED_REWARD_TYPE_2 = 6;
const SEED_MAX_COLUMN = 7;
const CROP_NAME = 0;
const CROP_REMAIN_CNT = 1;
const CROP_TOTLAL_CNT = 2;
const CROP_PRICE = 3;
const CROP_PROCURE_TYPE = 4;
const CROP_LEVEL = 5;
const CROP_REWARD_TYPE_1 = 6;
const CROP_REWARD_TYPE_2 = 7;
const CROP_MAX_COLUMN = 8;
const DEFAULT_CROP_NAME = 0;
const DEFAULT_CROP_LEVEL = 1;
const DEFAULT_SEED_PRICE = 2;
const DEFAULT_CROP_PRICE = 3;
const DEFAULT_REWARD_TYPE_1 = 4;
const DEFAULT_REWARD_TYPE_2 = 5;
const DEFAULT_MAX_COLUMN = 6;

var string m_WindowName;
var bool m_bTime;
var int m_MerchantOrChamberlain;
var int m_ManorID;
var int m_MyManorID;
var TabHandle m_hManorInfoWndManorInfoTabCtrl;

function OnRegisterEvent()
{
    RegisterEvent(2650);
    RegisterEvent(2652);
    RegisterEvent(2654);
    RegisterEvent(2651);
    RegisterEvent(2653);
    RegisterEvent(2655);
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
    m_hManorInfoWndManorInfoTabCtrl = GetTabHandle("ManorInfoWnd.ManorInfoTabCtrl");
    m_MerchantOrChamberlain = 0;
    m_ManorID = -1;
    m_MyManorID = -1;
    m_bTime = false;
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 2650:
            HandleSeedInfoShow(a_Param);
            // End:0x8E
            break;
        // End:0x33
        case 2651:
            HandleSeedAdd(a_Param);
            // End:0x8E
            break;
        // End:0x49
        case 2652:
            HandleCropInfoShow(a_Param);
            // End:0x8E
            break;
        // End:0x5F
        case 2653:
            HandleCropAdd(a_Param);
            // End:0x8E
            break;
        // End:0x75
        case 2654:
            HandleDefaultInfoShow(a_Param);
            // End:0x8E
            break;
        // End:0x8B
        case 2655:
            HandleDefaultAdd(a_Param);
            // End:0x8E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleSeedInfoShow(string a_Param)
{
    local int MerchantOrChamberlain, NumOfManor, i, ManorID;
    local string ManorName, ParamString, Message;
    local int ManorCnt;
    local string MyManorName;

    ParseInt(a_Param, "MerchantOrChamberlain", MerchantOrChamberlain);
    ParseInt(a_Param, "ManorID", ManorID);
    ParseString(a_Param, "ManorName", ManorName);
    m_MerchantOrChamberlain = MerchantOrChamberlain;
    m_ManorID = ManorID;
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorInfoWnd.SeedInfoWnd.SeedInfoListCtrl");
    Class'NWindow.UIAPI_COMBOBOX'.static.Clear("ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo");
    i = 0;
    J0xF3:

    // End:0x16F [Loop If]
    if(i < GetManorCount())
    {
        ManorID = GetManorIDInManorList(i);
        Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo", GetManorNameInManorList(i), ManorID);
        ++i;
        // [Loop Continue]
        goto J0xF3;
    }
    NumOfManor = Class'NWindow.UIAPI_COMBOBOX'.static.GetNumOfItems("ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo");
    i = 0;
    J0x1BD:

    // End:0x26F [Loop If]
    if(i < NumOfManor)
    {
        // End:0x265
        if(m_ManorID == Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo", i))
        {
            Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo", i);
            // [Explicit Break]
            goto J0x26F;
        }
        ++i;
        // [Loop Continue]
        goto J0x1BD;
    }
    J0x26F:

    // End:0x293
    if(!IsShowWindow("ManorInfoWnd"))
    {
        m_MyManorID = m_ManorID;
    }
    // End:0x2CC
    if(MerchantOrChamberlain == 1)
    {
        HideWindow("ManorInfoWnd.SeedInfoWnd.btnBuySeed");        
    }
    else
    {
        ShowWindow("ManorInfoWnd.SeedInfoWnd.btnBuySeed");
        ManorCnt = GetManorCount();
        i = 0;
        J0x30A:

        // End:0x34C [Loop If]
        if(i < ManorCnt)
        {
            // End:0x342
            if(m_MyManorID == GetManorIDInManorList(i))
            {
                MyManorName = GetManorNameInManorList(i);
                // [Explicit Break]
                goto J0x34C;
            }
            ++i;
            // [Loop Continue]
            goto J0x30A;
        }
        J0x34C:

        ParamAdd(ParamString, "Type", string(int(0)));
        ParamAdd(ParamString, "param1", MyManorName);
        AddSystemMessageParam(ParamString);
        Message = EndSystemMessageParam(1605, true);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ManorInfoWnd.SeedInfoWnd.txtNotice", Message);
    }
    ShowWindowWithFocus("ManorInfoWnd");
    HideWindow("ManorInfoWnd.CropInfoWnd");
    HideWindow("ManorInfoWnd.DefaultInfoWnd");
    m_hManorInfoWndManorInfoTabCtrl.SetTopOrder(0, false);
    // End:0x4C3
    if(!IsShowWindow("ManorInfoWnd.SeedInfoWnd"))
    {
        Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo", -1);
        ShowWindowWithFocus("ManorInfoWnd.SeedInfoWnd");
    }
    return;
}

function HandleSeedAdd(string a_Param)
{
    local int SeedID;
    local string SeedName;
    local INT64 SeedRemainCnt, SeedTotalCnt, SeedPrice;
    local int SeedLevel;
    local string RewardType1, RewardType2;
    local LVDataRecord Record;

    ParseInt(a_Param, "SeedID", SeedID);
    ParseString(a_Param, "SeedName", SeedName);
    ParseINT64(a_Param, "SeedRemainCnt", SeedRemainCnt);
    ParseINT64(a_Param, "SeedTotalCnt", SeedTotalCnt);
    ParseINT64(a_Param, "SeedPrice", SeedPrice);
    ParseInt(a_Param, "SeedLevel", SeedLevel);
    ParseString(a_Param, "RewardType1", RewardType1);
    ParseString(a_Param, "RewardType2", RewardType2);
    Record.LVDataList.Length = 7;
    Record.LVDataList[0].szData = SeedName;
    Record.LVDataList[1].szData = (SeedRemainCnt);
    Record.LVDataList[2].szData = (SeedTotalCnt);
    Record.LVDataList[3].szData = (SeedPrice);
    Record.LVDataList[4].szData = string(SeedLevel);
    Record.LVDataList[5].szData = RewardType1;
    Record.LVDataList[6].szData = RewardType2;
    Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorInfoWnd.SeedInfoWnd.SeedInfoListCtrl", Record);
    return;
}

function HandleCropInfoShow(string a_Param)
{
    local int MerchantOrChamberlain, NumOfManor, i, ManorID;

    ParseInt(a_Param, "MerchantOrChamberlain", MerchantOrChamberlain);
    ParseInt(a_Param, "ManorID", ManorID);
    m_MerchantOrChamberlain = MerchantOrChamberlain;
    m_ManorID = ManorID;
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorInfoWnd.CropInfoWnd.CropInfoListCtrl");
    Class'NWindow.UIAPI_COMBOBOX'.static.Clear("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo");
    i = 0;
    J0xD8:

    // End:0x154 [Loop If]
    if(i < GetManorCount())
    {
        ManorID = GetManorIDInManorList(i);
        Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo", GetManorNameInManorList(i), ManorID);
        ++i;
        // [Loop Continue]
        goto J0xD8;
    }
    NumOfManor = Class'NWindow.UIAPI_COMBOBOX'.static.GetNumOfItems("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo");
    i = 0;
    J0x1A2:

    // End:0x254 [Loop If]
    if(i < NumOfManor)
    {
        // End:0x24A
        if(m_ManorID == Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo", i))
        {
            Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo", i);
            // [Explicit Break]
            goto J0x254;
        }
        ++i;
        // [Loop Continue]
        goto J0x1A2;
    }
    J0x254:

    // End:0x28E
    if(MerchantOrChamberlain == 1)
    {
        HideWindow("ManorInfoWnd.CropInfoWnd.btnSellCrop");        
    }
    else
    {
        ShowWindow("ManorInfoWnd.CropInfoWnd.btnSellCrop");
    }
    // End:0x36F
    if(!IsShowWindow("ManorInfoWnd.CropInfoWnd"))
    {
        ShowWindowWithFocus("ManorInfoWnd.CropInfoWnd");
        // End:0x32C
        if(!IsShowWindow("ManorInfoWnd"))
        {
            ShowWindow("ManorInfoWnd");
        }
        HideWindow("ManorInfoWnd.SeedInfoWnd");
        HideWindow("ManorInfoWnd.DefaultInfoWnd");
    }
    return;
}

function HandleCropAdd(string a_Param)
{
    local int CropID;
    local string CropName;
    local INT64 CropRemainCnt, CropTotalCnt, CropPrice;
    local int ProcureType, CropLevel;
    local string RewardType1, RewardType2;
    local LVDataRecord Record;

    ParseInt(a_Param, "CropID", CropID);
    ParseString(a_Param, "CropName", CropName);
    ParseINT64(a_Param, "CropRemainCnt", CropRemainCnt);
    ParseINT64(a_Param, "CropTotalCnt", CropTotalCnt);
    ParseINT64(a_Param, "CropPrice", CropPrice);
    ParseInt(a_Param, "ProcureType", ProcureType);
    ParseInt(a_Param, "CropLevel", CropLevel);
    ParseString(a_Param, "RewardType1", RewardType1);
    ParseString(a_Param, "RewardType2", RewardType2);
    Record.LVDataList.Length = 8;
    Record.LVDataList[0].szData = CropName;
    Record.LVDataList[1].szData = (CropRemainCnt);
    Record.LVDataList[2].szData = (CropTotalCnt);
    Record.LVDataList[3].szData = (CropPrice);
    Record.LVDataList[4].szData = string(ProcureType);
    Record.LVDataList[5].szData = string(CropLevel);
    Record.LVDataList[6].szData = RewardType1;
    Record.LVDataList[7].szData = RewardType2;
    Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorInfoWnd.CropInfoWnd.CropInfoListCtrl", Record);
    return;
}

function HandleDefaultInfoShow(string a_Param)
{
    local int MerchantOrChamberlain;

    ParseInt(a_Param, "MerchantOrChamberlain", MerchantOrChamberlain);
    m_MerchantOrChamberlain = MerchantOrChamberlain;
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem("ManorInfoWnd.DefaultInfoWnd.DefaultInfoListCtrl");
    // End:0xDD
    if(MerchantOrChamberlain == 1)
    {
        HideWindow("ManorInfoWnd.DefaultInfoWnd.btnSellCrop");
        HideWindow("ManorInfoWnd.DefaultInfoWnd.btnBuySeed");        
    }
    else
    {
        ShowWindow("ManorInfoWnd.DefaultInfoWnd.btnSellCrop");
        ShowWindow("ManorInfoWnd.DefaultInfoWnd.btnBuySeed");
    }
    ShowWindowWithFocus("ManorInfoWnd");
    ShowWindowWithFocus("ManorInfoWnd.DefaultInfoWnd");
    m_hManorInfoWndManorInfoTabCtrl.SetTopOrder(2, false);
    HideWindow("ManorInfoWnd.SeedInfoWnd");
    HideWindow("ManorInfoWnd.CropInfoWnd");
    return;
}

function HandleDefaultAdd(string a_Param)
{
    local int CropID;
    local string CropName;
    local int CropLevel, SeedPrice, CropPrice;
    local string RewardType1, RewardType2;
    local LVDataRecord Record;

    ParseInt(a_Param, "CropID", CropID);
    ParseString(a_Param, "CropName", CropName);
    ParseInt(a_Param, "CropLevel", CropLevel);
    ParseInt(a_Param, "SeedPrice", SeedPrice);
    ParseInt(a_Param, "CropPrice", CropPrice);
    ParseString(a_Param, "RewardType1", RewardType1);
    ParseString(a_Param, "RewardType2", RewardType2);
    Record.LVDataList.Length = 6;
    Record.LVDataList[0].szData = CropName;
    Record.LVDataList[1].szData = string(CropLevel);
    Record.LVDataList[2].szData = string(SeedPrice);
    Record.LVDataList[3].szData = string(CropPrice);
    Record.LVDataList[4].szData = RewardType1;
    Record.LVDataList[5].szData = RewardType2;
    Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord("ManorInfoWnd.DefaultInfoWnd.DefaultInfoListCtrl", Record);
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x48
        case "btnBuySeed":
            RequestBypassToServer("manor_menu_select?ask=1&state=-1&time=0");
            // End:0x127
            break;
        // End:0x8A
        case "btnSellCrop":
            RequestBypassToServer("manor_menu_select?ask=2&state=-1&time=0");
            // End:0x127
            break;
        // End:0xB3
        case "ManorInfoTabCtrl0":
            OnClickInfoTab("SeedInfo");
            // End:0x127
            break;
        // End:0xDC
        case "ManorInfoTabCtrl1":
            OnClickInfoTab("CropInfo");
            // End:0x127
            break;
        // End:0x124
        case "ManorInfoTabCtrl2":
            RequestBypassToServer("manor_menu_select?ask=5&state=-1&time=0");
            // End:0x127
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickInfoTab(string TabName)
{
    local int SelectedManorID, SelectedTime;
    local string RequestString, PreString;
    local int Index;
    local string ManorComboBoxName, TimeComboBoxName;

    switch(TabName)
    {
        // End:0xA6
        case "SeedInfo":
            PreString = "manor_menu_select?ask=3&state=";
            ManorComboBoxName = "ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo";
            TimeComboBoxName = "ManorInfoWnd.SeedInfoWnd.cbTimeInSeedInfo";
            // End:0x148
            break;
        // End:0x145
        case "CropInfo":
            PreString = "manor_menu_select?ask=4&state=";
            ManorComboBoxName = "ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo";
            TimeComboBoxName = "ManorInfoWnd.CropInfoWnd.cbTimeInCropInfo";
            // End:0x148
            break;
        // End:0xFFFF
        default:
            break;
    }
    Index = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(ManorComboBoxName);
    SelectedManorID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(ManorComboBoxName, Index);
    SelectedTime = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(TimeComboBoxName);
    // End:0x1CB
    if((TabName == "CropInfo") && SelectedManorID == -1)
    {
        SelectedManorID = m_MyManorID;
    }
    // End:0x20B
    if(SelectedManorID != 0)
    {
        RequestString = ((PreString $ string(SelectedManorID)) $ "&time=") $ string(SelectedTime);
        RequestBypassToServer(RequestString);        
    }
    return;
}

function OnComboBoxItemSelected(string sName, int Index)
{
    switch(sName)
    {
        // End:0x43
        case "cbManorSelectInSeedInfo":
            m_bTime = false;
            RequestSelectedData("SeedInfo", Index);
            // End:0xEC
            break;
        // End:0x78
        case "cbTimeInSeedInfo":
            m_bTime = true;
            RequestSelectedData("SeedInfo", Index);
            // End:0xEC
            break;
        // End:0xB4
        case "cbManorSelectInCropInfo":
            m_bTime = false;
            RequestSelectedData("CropInfo", Index);
            // End:0xEC
            break;
        // End:0xE9
        case "cbTimeInCropInfo":
            m_bTime = true;
            RequestSelectedData("CropInfo", Index);
            // End:0xEC
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function RequestSelectedData(string WindowName, int Index)
{
    local int ManorID;
    local string RequestString, PreString;
    local int Time;
    local string ManorComboBoxName, TimeComboBoxName;

    // End:0xA6
    if(WindowName == "SeedInfo")
    {
        PreString = "manor_menu_select?ask=3&state=";
        ManorComboBoxName = "ManorInfoWnd.SeedInfoWnd.cbManorSelectInSeedInfo";
        TimeComboBoxName = "ManorInfoWnd.SeedInfoWnd.cbTimeInSeedInfo";        
    }
    else
    {
        PreString = "manor_menu_select?ask=4&state=";
        ManorComboBoxName = "ManorInfoWnd.CropInfoWnd.cbManorSelectInCropInfo";
        TimeComboBoxName = "ManorInfoWnd.CropInfoWnd.cbTimeInCropInfo";
    }
    // End:0x166
    if(m_bTime)
    {
        ManorID = m_ManorID;
        Time = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(TimeComboBoxName);        
    }
    else
    {
        ManorID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved(ManorComboBoxName, Index);
        Time = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum(TimeComboBoxName);
    }
    // End:0x1D1
    if(ManorID > 0)
    {
        RequestString = ((PreString $ string(ManorID)) $ "&time=") $ string(Time);
    }
    RequestBypassToServer(RequestString);
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
    m_WindowName="ManorInfoWnd"
}