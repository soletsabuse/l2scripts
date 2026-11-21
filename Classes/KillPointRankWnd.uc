class KillPointRankWnd extends UIScript;

struct KillPointWndData
{
    var string Name;
    var int KillPoint;
};

var KillPointWndData m_KillPointData[25];
var WindowHandle Me;
var TextBoxHandle TopRatedPCName;
var TextBoxHandle TopRatedKillPC;
var ListCtrlHandle RankingListLeft;
var ListCtrlHandle RankingListRight;
var NameCtrlHandle NameCtrl;
var int m_Count;

function OnRegisterEvent()
{
    RegisterEvent(3470);
    RegisterEvent(3480);
    RegisterEvent(3490);
    RegisterEvent(3500);
    RegisterEvent(3501);
    return;
}

function OnLoad()
{
    // End:0x118
    if(1 == 0)
    {
        Me = GetHandle("KillPointRankWnd");
        TopRatedPCName = TextBoxHandle(GetHandle("KillPointRankWnd.TopRatedPCName"));
        TopRatedKillPC = TextBoxHandle(GetHandle("KillPointRankWnd.TopRatedKillPC"));
        RankingListLeft = ListCtrlHandle(GetHandle("KillPointRankWnd.RankingListLeft"));
        RankingListRight = ListCtrlHandle(GetHandle("KillPointRankWnd.RankingListRight"));
        NameCtrl = NameCtrlHandle(GetHandle("StatusWnd.UserName"));        
    }
    else
    {
        Me = GetWindowHandle("KillPointRankWnd");
        TopRatedPCName = GetTextBoxHandle("KillPointRankWnd.TopRatedPCName");
        TopRatedKillPC = GetTextBoxHandle("KillPointRankWnd.TopRatedKillPC");
        RankingListLeft = GetListCtrlHandle("KillPointRankWnd.RankingListLeft");
        RankingListRight = GetListCtrlHandle("KillPointRankWnd.RankingListRight");
        NameCtrl = GetNameCtrlHandle("StatusWnd.UserName");
    }
    return;
}

function OnShow()
{
    RequestStartShowCrataeCubeRank();
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int statusInt;
    local string Name;
    local int KillPoint;

    Debug("Event_ID" @ string(Event_ID));
    switch(Event_ID)
    {
        // End:0x3F
        case 3500:
            // End:0x3C
            if(!Me.IsShowWindow())
            {
            }
            // End:0x1B3
            break;
        // End:0xC8
        case 3480:
            Debug("update list" @ param);
            ParseString(param, "Name", Name);
            ParseInt(param, "KillPoint", KillPoint);
            m_KillPointData[m_Count].Name = Name;
            m_KillPointData[m_Count].KillPoint = KillPoint;
            m_Count++;
            // End:0x1B3
            break;
        // End:0x185
        case 3470:
            Debug("EV_CrataeCubeRecordItem" @ param);
            ParseInt(param, "Status", statusInt);
            m_Count = 0;
            Debug("update start");
            switch(statusInt)
            {
                // End:0x146
                case 0:
                    Me.ShowWindow();
                    // End:0x182
                    break;
                // End:0x168
                case 1:
                    m_Count = 0;
                    Debug("update start");
                    // End:0x182
                    break;
                // End:0x17F
                case 2:
                    Me.ShowWindow();
                    // End:0x182
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x1B3
            break;
        // End:0x196
        case 3490:
            InsertKillPoint();
            // End:0x1B3
            break;
        // End:0x1B0
        case 3501:
            Me.HideWindow();
            // End:0x1B3
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    // End:0x23
    if(Name == "btnClose")
    {
        Me.HideWindow();
    }
    return;
}

function OnHide()
{
    RequestStopShowCrataeCubeRank();
    return;
}

function InsertKillPoint()
{
    local int i;
    local LVDataRecord Record;
    local LVData data1, data2, data3;

    RankingListLeft.DeleteAllItem();
    RankingListRight.DeleteAllItem();
    TopRatedPCName.SetText((("1" @ GetSystemString(1375)) @ " ") @ m_KillPointData[0].Name);
    TopRatedKillPC.SetText("Kill Point : " @ string(m_KillPointData[0].KillPoint));
    i = 1;
    J0x85:

    // End:0x1B2 [Loop If]
    if(i < 13)
    {
        data1.szData = string(i + 1);
        data2.szData = m_KillPointData[i].Name;
        // End:0x114
        if((m_KillPointData[i].KillPoint < 9999) && m_KillPointData[i].Name != "")
        {
            data3.szData = string(m_KillPointData[i].KillPoint);            
        }
        else
        {
            data3.szData = "";
        }
        Record.LVDataList[0] = data1;
        Record.LVDataList[1] = data2;
        Record.LVDataList[2] = data3;
        RankingListLeft.InsertRecord(Record);
        // End:0x1A8
        if(m_KillPointData[i].Name == NameCtrl.GetName())
        {
            RankingListLeft.SetSelectedIndex(i - 1, true);
        }
        i++;
        // [Loop Continue]
        goto J0x85;
    }
    i = 13;
    J0x1BA:

    // End:0x2E8 [Loop If]
    if(i < 25)
    {
        data1.szData = string(i + 1);
        data2.szData = m_KillPointData[i].Name;
        // End:0x249
        if((m_KillPointData[i].KillPoint < 9999) && m_KillPointData[i].Name != "")
        {
            data3.szData = string(m_KillPointData[i].KillPoint);            
        }
        else
        {
            data3.szData = "";
        }
        Record.LVDataList[0] = data1;
        Record.LVDataList[1] = data2;
        Record.LVDataList[2] = data3;
        RankingListRight.InsertRecord(Record);
        // End:0x2DE
        if(m_KillPointData[i].Name == NameCtrl.GetName())
        {
            RankingListRight.SetSelectedIndex(i - 13, true);
        }
        i++;
        // [Loop Continue]
        goto J0x1BA;
    }
    i = 0;
    J0x2EF:

    // End:0x32E [Loop If]
    if(i < 25)
    {
        m_KillPointData[i].Name = "";
        m_KillPointData[i].KillPoint = 9999;
        i++;
        // [Loop Continue]
        goto J0x2EF;
    }
    m_Count = 0;
    return;
}
