class HeroTowerWndWorld extends HeroTowerWnd;

var bool isWroldOlympiad;
var ListCtrlHandle m_hLstHero;

function OnRegisterEvent()
{
    RegisterEvent(880);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int UseClassicOlympiad;

    // End:0xAA
    if(Event_ID == 880)
    {
        isWroldOlympiad = getInstanceUIData().getIsClassicServer();
        GetINIBool("Localize", "UseClassicOlympiad", UseClassicOlympiad, "L2.ini");
        // End:0x71
        if(!isWroldOlympiad || UseClassicOlympiad == 1)
        {
            return;
        }
        Clear();
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName);
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_WindowName);
        HandleHeroShowList(param);
    }
    return;
}

function OnDBClickListCtrlRecord(string strID)
{
    switch(strID)
    {
        // End:0x1C
        case "lstHero":
            HandleShowHistory();
            // End:0x1F
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
        // End:0x1F
        case "btnHistory":
            HandleShowHistory();
            // End:0x22
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function Clear()
{
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName $ ".lstHero");
    return;
}

function HandleHeroShowList(string param)
{
    local int i, nMax;
    local string strName;
    local int ClassID;
    local string strPledgeName;
    local int WinCount;
    local Texture texPledge, texAlliance;
    local LVDataRecord Record, recordClear;
    local string ServerName;

    ParseInt(param, "Max", nMax);
    i = 0;
    J0x1C:

    // End:0x1D4 [Loop If]
    if(i < nMax)
    {
        strName = "";
        ClassID = 0;
        strPledgeName = "";
        WinCount = 0;
        ParseString(param, "ServerName_" $ string(i), ServerName);
        ParseString(param, "Name_" $ string(i), strName);
        ParseInt(param, "ClassId_" $ string(i), ClassID);
        ParseString(param, "PledgeName_" $ string(i), strPledgeName);
        ParseInt(param, "WinCount_" $ string(i), WinCount);
        Record = recordClear;
        Record.LVDataList.Length = 5;
        Record.LVDataList[0].szData = ServerName;
        Record.LVDataList[1].szData = strName;
        Record.LVDataList[2].szData = GetClassType(ClassID);
        Record.LVDataList[3].szData = strPledgeName;
        Record.LVDataList[4].szData = string(WinCount);
        Record.nReserved1 = (ClassID);
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName $ ".lstHero", Record);
        i++;
        // [Loop Continue]
        goto J0x1C;
    }
    return;
}

defaultproperties
{
    m_WindowName="HeroTowerWndWorld"
}