class HeroTowerWnd extends PacketsInfo;

struct sHeroInfo
{
    var array<int> point;
    var array<int> gamesNum;
    var array<int> winrate;
};

var sHeroInfo allHeroInfo;
var int m_IDofHero;
var bool isWroldOlympiad;
var string m_WindowName;
var WindowHandle Me;
var ListCtrlHandle m_hLstHero;
var ListCtrlHandle lstHeroBig;

function OnRegisterEvent()
{
    RegisterEvent(880);
    RegisterEvent(3550);
    return;
}

function switchView(bool B)
{
    // End:0x43
    if(B)
    {
        m_hLstHero.HideWindow();
        lstHeroBig.ShowWindow();
        Me.SetWindowSize(601, 732);        
    }
    else
    {
        m_hLstHero.ShowWindow();
        lstHeroBig.HideWindow();
        Me.SetWindowSize(601, 319);
    }
    SetOptionInt("Game", "BigHeroTower", int(B));
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Me = GetWindowHandle("HeroTowerWnd");
    m_hLstHero = GetListCtrlHandle(m_WindowName $ ".lstHero");
    lstHeroBig = GetListCtrlHandle(m_WindowName $ ".lstHeroBig");
    switchView(bool(GetOptionInt("Game", "BigHeroTower")));
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int UseClassicOlympiad;

    // End:0xB1
    if(Event_ID == 880)
    {
        isWroldOlympiad = getInstanceUIData().getIsClassicServer();
        GetINIBool("Localize", "UseClassicOlympiad", UseClassicOlympiad, "L2.ini");
        // End:0x6F
        if(isWroldOlympiad && UseClassicOlympiad == 0)
        {
            return;
        }
        Clear();
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName);
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus(m_WindowName);
        HandleCheckAmIHero();
        HandleHeroShowList(param);        
    }
    else
    {
        // End:0xCB
        if(Event_ID == 3550)
        {
            _OnEvent(param);
        }
    }
    return;
}

function _OnEvent(string param)
{
    local int Event_ID;

    ParseInt(param, "EventID", Event_ID);
    switch(Event_ID)
    {
        // End:0x36
        case 1400:
            handleTowerInfo(param);
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            // End:0x3C
            break;
            break;
    }
    return;
}

function OnDBClickListCtrlRecord(string strID)
{
    switch(strID)
    {
        // End:0x13
        case "lstHero":
        // End:0x2B
        case "lstHeroBig":
            HandleShowDiary();
            // End:0x31
            break;
        // End:0xFFFF
        default:
            // End:0x31
            break;
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x21
        case "btnShowDiary":
            HandleShowDiary();
            // End:0xD5
            break;
        // End:0x82
        case "btnReg":
            Class'NWindow.HeroTowerAPI'.static.RequestWriteHeroWords(Class'NWindow.UIAPI_EDITBOX'.static.GetString(m_WindowName $ ".txtDiary"));
            Class'NWindow.UIAPI_EDITBOX'.static.SetString(m_WindowName $ ".txtDiary", "");
            // End:0xD5
            break;
        // End:0x9A
        case "btnHistory":
            HandleShowHistory();
            // End:0xD5
            break;
        // End:0xCF
        case "btnSwitch":
            switchView(!bool(GetOptionInt("Game", "BigHeroTower")));
            // End:0xD5
            break;
        // End:0xFFFF
        default:
            // End:0xD5
            break;
            break;
    }
    return;
}

function HandleShowDiary()
{
    local LVDataRecord Record;
    local string strTmp;

    m_hLstHero.GetSelectedRec(Record);
    // End:0x60
    if(__NFUN_409__(Record.nReserved1, (0)))
    {
        strTmp = ("_diary?class=" $ (Record.nReserved1)) $ "&page=1";
        RequestBypassToServer(strTmp);
    }
    return;
}

function HandleShowHistory()
{
    local LVDataRecord Record;

    // End:0x17
    if(m_hLstHero.GetSelectedIndex() < 0)
    {
        return;
    }
    m_hLstHero.GetSelectedRec(Record);
    Class'NWindow.HeroTowerAPI'.static.RequestHeroMatchRecord(name(Record.nReserved1));
    return;
}

function HandleCheckAmIHero()
{
    local bool bHero;

    bHero = Class'NWindow.UIDATA_PLAYER'.static.IsHero();
    // End:0x62
    if(bHero)
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".txtDiary");
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(m_WindowName $ ".btnReg");        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".txtDiary");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName $ ".btnReg");
    }
    return;
}

function Clear()
{
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName $ ".lstHero");
    Class'NWindow.UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName $ ".lstHeroBig");
    Class'NWindow.UIAPI_EDITBOX'.static.SetString(m_WindowName $ ".txtDiary", "");
    return;
}

function emulateOlymp()
{
    local string param;
    local int i;

    ParamAdd(param, "Max", string(35));
    Clear();
    i = 0;
    J0x21:

    // End:0x160 [Loop If]
    if(i < 35)
    {
        ParamAdd(param, "Name_" $ string(i), ((((((("Nickname" $ ";") $ string(RandRange(1.0000000, 500.0000000))) $ ";") $ string(110)) $ ";") $ string(Rand(200))) $ ";") $ string(Rand(100)));
        ParamAdd(param, "ClassId_" $ string(i), string(110));
        ParamAdd(param, "PledgeName_" $ string(i), "Pledge");
        ParamAdd(param, "PledgeName_" $ string(i), "Pledge");
        ParamAdd(param, "AllianceName_" $ string(i), "Alliance");
        ParamAdd(param, "WinCount_" $ string(i), string(Rand(100)));
        i++;
        // [Loop Continue]
        goto J0x21;
    }
    HandleHeroShowList(param);
    return;
}

function handleTowerInfo(string param)
{
    local int i;
    local string strRecords;
    local array<string> allInfo, PlayerInfo;
    local sHeroInfo heroInfo;
    local int n1, n2;
    local string strpoints, strgames, strwinrates;
    local array<string> Points, games, winrates;
    local int point, ClassID, gamesNum, winrate;

    ParseString(param, "param1", strpoints);
    ParseString(param, "param2", strgames);
    ParseString(param, "param3", strwinrates);
    Points = Arr(strpoints, ",");
    games = Arr(strgames, ",");
    winrates = Arr(strwinrates, ",");
    allHeroInfo.point.Remove(0, allHeroInfo.point.Length);
    allHeroInfo.gamesNum.Remove(0, allHeroInfo.gamesNum.Length);
    allHeroInfo.winrate.Remove(0, allHeroInfo.winrate.Length);
    i = 0;
    J0xD0:

    // End:0x156 [Loop If]
    if(i < Points.Length)
    {
        allHeroInfo.point[allHeroInfo.point.Length] = int(Points[i]);
        allHeroInfo.gamesNum[allHeroInfo.gamesNum.Length] = int(games[i]);
        allHeroInfo.winrate[allHeroInfo.winrate.Length] = int(winrates[i]);
        i++;
        // [Loop Continue]
        goto J0xD0;
    }
    return;
}

function HandleHeroShowList(string param)
{
    local int i, nMax;
    local string strName;
    local int ClassID;
    local string strPledgeName;
    local int PledgeCrestID;
    local string strAllianceName;
    local int AllianceCrestID, WinCount, pointsCount, GamesCount, winrate;

    local Texture texPledge, texAlliance;
    local LVDataRecord Record, recordClear;
    local array<string> ExtraData;
    local int counterNum;

    ParseInt(param, "Max", nMax);
    i = 0;
    J0x1C:

    // End:0xBB9 [Loop If]
    if(i < nMax)
    {
        strName = "";
        ClassID = 0;
        strPledgeName = "";
        PledgeCrestID = 0;
        strAllianceName = "";
        AllianceCrestID = 0;
        WinCount = 0;
        pointsCount = 0;
        GamesCount = 0;
        winrate = 0;
        ParseString(param, "Name_" $ string(i), strName);
        ParseInt(param, "ClassId_" $ string(i), ClassID);
        ParseString(param, "PledgeName_" $ string(i), strPledgeName);
        ParseString(param, "AllianceName_" $ string(i), strAllianceName);
        ParseInt(param, "WinCount_" $ string(i), WinCount);
        ParseInt(param, "PledgeCrestId_" $ string(i), PledgeCrestID);
        ParseInt(param, "AllianceCrestId_" $ string(i), AllianceCrestID);
        // End:0x1D4
        if(allHeroInfo.point.Length == nMax)
        {
            pointsCount = allHeroInfo.point[i];
            GamesCount = allHeroInfo.gamesNum[i];
            winrate = allHeroInfo.winrate[i];
        }
        texPledge = GetTexture((("Crest.pledge_crest_" $ string(getInstanceL2Util().getServerId())) $ "_") $ string(PledgeCrestID));
        texAlliance = GetTexture((("Crest.ally_crest_" $ string(getInstanceL2Util().getServerId())) $ "_") $ string(AllianceCrestID));
        Record = recordClear;
        Record.LVDataList.Length = 10;
        Record.LVDataList[0].FirstLineOffsetX = 3;
        Record.LVDataList[0].szData = strName;
        Record.LVDataList[1].szData = " " $ GetClassType(ClassID);
        Record.LVDataList[1].hasIcon = true;
        Record.LVDataList[1].nTextureU = 16;
        Record.LVDataList[1].nTextureV = 16;
        Record.LVDataList[1].nTextureWidth = 16;
        Record.LVDataList[1].nTextureHeight = 16;
        Record.LVDataList[1].IconPosX = 3;
        Record.LVDataList[1].szTexture = "UI_BOHPTS.icons.Class_Icon" $ string(ClassID);
        Record.LVDataList[2].IconPosX = 3;
        Record.LVDataList[2].FirstLineOffsetX = 3;
        Record.LVDataList[2].szData = strPledgeName;
        // End:0x649
        if((AllianceCrestID > 0) && PledgeCrestID > 0)
        {
            Record.LVDataList[2].arrTexture.Length = 3;
            Record.LVDataList[2].arrTexture[0].objTex = texAlliance;
            Record.LVDataList[2].arrTexture[0].X = 10;
            Record.LVDataList[2].arrTexture[0].Y = 0;
            Record.LVDataList[2].arrTexture[0].Width = 8;
            Record.LVDataList[2].arrTexture[0].Height = 12;
            Record.LVDataList[2].arrTexture[0].U = 0;
            Record.LVDataList[2].arrTexture[0].V = 4;
            Record.LVDataList[2].arrTexture[1].objTex = texPledge;
            Record.LVDataList[2].arrTexture[1].X = 18;
            Record.LVDataList[2].arrTexture[1].Y = 0;
            Record.LVDataList[2].arrTexture[1].Width = 16;
            Record.LVDataList[2].arrTexture[1].Height = 12;
            Record.LVDataList[2].arrTexture[1].U = 0;
            Record.LVDataList[2].arrTexture[1].V = 4;
            Record.LVDataList[2].arrTexture[2].objTex = GetTexture("L2UI_CT1.EmptyBtn");
            Record.LVDataList[2].arrTexture[2].X = 0;
            Record.LVDataList[2].arrTexture[2].Y = 0;
            Record.LVDataList[2].arrTexture[2].Width = 10;
            Record.LVDataList[2].arrTexture[2].Height = 12;
            Record.LVDataList[2].arrTexture[2].U = 0;
            Record.LVDataList[2].arrTexture[2].V = 4;            
        }
        else
        {
            // End:0x80A
            if(AllianceCrestID > 0)
            {
                Record.LVDataList[2].arrTexture.Length = 2;
                Record.LVDataList[2].arrTexture[0].objTex = texAlliance;
                Record.LVDataList[2].arrTexture[0].X = 10;
                Record.LVDataList[2].arrTexture[0].Y = 0;
                Record.LVDataList[2].arrTexture[0].Width = 8;
                Record.LVDataList[2].arrTexture[0].Height = 12;
                Record.LVDataList[2].arrTexture[0].U = 0;
                Record.LVDataList[2].arrTexture[0].V = 4;
                Record.LVDataList[2].arrTexture[1].objTex = GetTexture("L2UI_CT1.EmptyBtn");
                Record.LVDataList[2].arrTexture[1].X = 0;
                Record.LVDataList[2].arrTexture[1].Y = 0;
                Record.LVDataList[2].arrTexture[1].Width = 10;
                Record.LVDataList[2].arrTexture[1].Height = 12;
                Record.LVDataList[2].arrTexture[1].U = 0;
                Record.LVDataList[2].arrTexture[1].V = 4;                
            }
            else
            {
                // End:0x9C8
                if(PledgeCrestID > 0)
                {
                    Record.LVDataList[2].arrTexture.Length = 2;
                    Record.LVDataList[2].arrTexture[0].objTex = texPledge;
                    Record.LVDataList[2].arrTexture[0].X = 10;
                    Record.LVDataList[2].arrTexture[0].Y = 0;
                    Record.LVDataList[2].arrTexture[0].Width = 16;
                    Record.LVDataList[2].arrTexture[0].Height = 12;
                    Record.LVDataList[2].arrTexture[0].U = 0;
                    Record.LVDataList[2].arrTexture[0].V = 4;
                    Record.LVDataList[2].arrTexture[1].objTex = GetTexture("L2UI_CT1.EmptyBtn");
                    Record.LVDataList[2].arrTexture[1].X = 0;
                    Record.LVDataList[2].arrTexture[1].Y = 0;
                    Record.LVDataList[2].arrTexture[1].Width = 10;
                    Record.LVDataList[2].arrTexture[1].Height = 12;
                    Record.LVDataList[2].arrTexture[1].U = 0;
                    Record.LVDataList[2].arrTexture[1].V = 4;
                }
            }
        }
        Record.LVDataList[3].FirstLineOffsetX = 3;
        Record.LVDataList[3].szData = string(pointsCount);
        Record.LVDataList[3].HiddenStringForSorting = makeZeroString(20, (pointsCount));
        Record.LVDataList[3].textAlignment = 2;
        Record.LVDataList[4].FirstLineOffsetX = 3;
        Record.LVDataList[4].szData = string(GamesCount);
        Record.LVDataList[4].HiddenStringForSorting = makeZeroString(20, (GamesCount));
        Record.LVDataList[4].textAlignment = 2;
        Record.LVDataList[5].FirstLineOffsetX = 3;
        Record.LVDataList[5].HiddenStringForSorting = makeZeroString(20, (winrate));
        Record.LVDataList[5].szData = string(winrate) $ "%";
        Record.LVDataList[6].FirstLineOffsetX = 3;
        Record.LVDataList[6].szData = string(WinCount);
        Record.LVDataList[6].HiddenStringForSorting = makeZeroString(20, (WinCount));
        Record.LVDataList[6].textAlignment = 2;
        Record.nReserved1 = (ClassID);
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName $ ".lstHero", Record);
        Class'NWindow.UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName $ ".lstHeroBig", Record);
        i++;
        // [Loop Continue]
        goto J0x1C;
    }
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
    m_WindowName="HeroTowerWnd"
}