class SiegeReportWnd extends UICommonAPI;

const TIME_ID = 2001114;
const TIME_DELAY = 1000;

var WindowHandle Me;
var TextureHandle GroupBoxBg1_Texture;
var TextureHandle GroupBoxBg2_Texture;
var TextBoxHandle SiegeReportDiscription_text;
var WindowHandle MonthRankingNo1Wnd;
var TextBoxHandle MonthRankingNo1Wnd_Title_text;
var TextBoxHandle MonthRankingNo1Wnd_Name_text;
var TextureHandle MonthWnd_PledgeCrest_texture;
var TextureHandle MonthWnd_PledgeAllianceCrest_texture;
var WindowHandle LastMonthRankingNo1Wnd;
var TextBoxHandle LastMonthRankingNo1Wnd_Title_text;
var TextBoxHandle LastMonthRankingNo1Wnd_Name_text;
var TextureHandle LastMonthWnd_PledgeCrest_texture;
var TextureHandle LastMonthWnd_PledgeAllianceCrest_texture;
var TextureHandle LastMonthWnd_Deco_texture;
var WindowHandle EmblemRankingWnd;
var TextureHandle EmblemRankingWnd_texture;
var WindowHandle WeekRankingWnd;
var TextBoxHandle n1WeekRanking_Title_text;
var TextBoxHandle n1WeekRanking_Name_text;
var TextureHandle n1WeekRanking_PledgeCrest_texture;
var TextureHandle n1WeekRanking_PledgeAllianceCrest_texture;
var TextureHandle n1WeekRanking_GroupBox_texture;
var TextureHandle n1WeekRanking_Divider_Texture;
var TextureHandle n1WeekRanking_Block_texture;
var TextBoxHandle n2WeekRanking_Title_text;
var TextBoxHandle n2WeekRanking_Name_text;
var TextureHandle n2WeekRanking_PledgeCrest_texture;
var TextureHandle n2WeekRanking_PledgeAllianceCrest_texture;
var TextureHandle n2WeekRanking_GroupBox_texture;
var TextureHandle n2WeekRanking_Divider_Texture;
var TextureHandle n2WeekRanking_Block_texture;
var TextBoxHandle n3WeekRanking_Title_text;
var TextBoxHandle n3WeekRanking_Name_text;
var TextureHandle n3WeekRanking_PledgeCrest_texture;
var TextureHandle n3WeekRanking_PledgeAllianceCrest_texture;
var TextureHandle n3WeekRanking_GroupBox_texture;
var TextureHandle n3WeekRanking_Divider_Texture;
var TextureHandle n3WeekRanking_Block_texture;
var TextBoxHandle n4WeekRanking_Title_text;
var TextBoxHandle n4WeekRanking_Name_text;
var TextureHandle n4WeekRanking_PledgeCrest_texture;
var TextureHandle n4WeekRanking_PledgeAllianceCrest_texture;
var TextureHandle n4WeekRanking_GroupBox_texture;
var TextureHandle n4WeekRanking_Block_texture;
var TextBoxHandle n5WeekRanking_Title_text;
var TextBoxHandle n5WeekRanking_Name_text;
var TextureHandle n5WeekRanking_PledgeCrest_texture;
var TextureHandle n5WeekRanking_PledgeAllianceCrest_texture;
var TextureHandle n5WeekRanking_GroupBox_texture;
var TextureHandle n5WeekRanking_Block_texture;
var TextureHandle n5WeekRanking_Divider_Texture;
var TextureHandle n5WeekRanking_Flag_texture;
var ButtonHandle CloseButton;
var ButtonHandle GetButton;
var int nSeasonCastleID;
var int nChoiceSeason;
var string refreshCastleWarSeasonResultStr;

function OnRegisterEvent()
{
    RegisterEvent(10070);
    RegisterEvent(10071);
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function OnHide()
{
    Me.KillTimer(2001114);
    return;
}

function Initialize()
{
    Me = GetWindowHandle("SiegeReportWnd");
    GroupBoxBg1_Texture = GetTextureHandle("SiegeReportWnd.GroupBoxBg1_Texture");
    GroupBoxBg2_Texture = GetTextureHandle("SiegeReportWnd.GroupBoxBg2_Texture");
    SiegeReportDiscription_text = GetTextBoxHandle("SiegeReportWnd.SiegeReportDiscription_text");
    MonthRankingNo1Wnd = GetWindowHandle("SiegeReportWnd.MonthRankingNo1Wnd");
    MonthRankingNo1Wnd_Title_text = GetTextBoxHandle("SiegeReportWnd.MonthRankingNo1Wnd.MonthRankingNo1Wnd_Title_text");
    MonthRankingNo1Wnd_Name_text = GetTextBoxHandle("SiegeReportWnd.MonthRankingNo1Wnd.MonthRankingNo1Wnd_Name_text");
    MonthWnd_PledgeCrest_texture = GetTextureHandle("SiegeReportWnd.MonthRankingNo1Wnd.MonthWnd_PledgeCrest_texture");
    MonthWnd_PledgeAllianceCrest_texture = GetTextureHandle("SiegeReportWnd.MonthRankingNo1Wnd.MonthWnd_PledgeAllianceCrest_texture");
    LastMonthRankingNo1Wnd = GetWindowHandle("SiegeReportWnd.LastMonthRankingNo1Wnd");
    LastMonthRankingNo1Wnd_Title_text = GetTextBoxHandle("SiegeReportWnd.LastMonthRankingNo1Wnd.LastMonthRankingNo1Wnd_Title_text");
    LastMonthRankingNo1Wnd_Name_text = GetTextBoxHandle("SiegeReportWnd.LastMonthRankingNo1Wnd.LastMonthRankingNo1Wnd_Name_text");
    LastMonthWnd_PledgeCrest_texture = GetTextureHandle("SiegeReportWnd.LastMonthRankingNo1Wnd.LastMonthWnd_PledgeCrest_texture");
    LastMonthWnd_PledgeAllianceCrest_texture = GetTextureHandle("SiegeReportWnd.LastMonthRankingNo1Wnd.LastMonthWnd_PledgeAllianceCrest_texture");
    LastMonthWnd_Deco_texture = GetTextureHandle("SiegeReportWnd.LastMonthRankingNo1Wnd.LastMonthWnd_Deco_texture");
    EmblemRankingWnd = GetWindowHandle("SiegeReportWnd.EmblemRankingWnd");
    EmblemRankingWnd_texture = GetTextureHandle("SiegeReportWnd.EmblemRankingWnd.EmblemRankingWnd_texture");
    WeekRankingWnd = GetWindowHandle("SiegeReportWnd.WeekRankingWnd");
    n1WeekRanking_Title_text = GetTextBoxHandle("SiegeReportWnd.WeekRankingWnd.n1WeekRanking_Title_text");
    n1WeekRanking_Name_text = GetTextBoxHandle("SiegeReportWnd.WeekRankingWnd.n1WeekRanking_Name_text");
    n1WeekRanking_PledgeCrest_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n1WeekRanking_PledgeCrest_texture");
    n1WeekRanking_PledgeAllianceCrest_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n1WeekRanking_PledgeAllianceCrest_texture");
    n1WeekRanking_GroupBox_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n1WeekRanking_GroupBox_texture");
    n1WeekRanking_Divider_Texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n1WeekRanking_Divider_Texture");
    n1WeekRanking_Block_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n1WeekRanking_Block_texture");
    n2WeekRanking_Title_text = GetTextBoxHandle("SiegeReportWnd.WeekRankingWnd.n2WeekRanking_Title_text");
    n2WeekRanking_Name_text = GetTextBoxHandle("SiegeReportWnd.WeekRankingWnd.n2WeekRanking_Name_text");
    n2WeekRanking_PledgeCrest_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n2WeekRanking_PledgeCrest_texture");
    n2WeekRanking_PledgeAllianceCrest_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n2WeekRanking_PledgeAllianceCrest_texture");
    n2WeekRanking_GroupBox_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n2WeekRanking_GroupBox_texture");
    n2WeekRanking_Divider_Texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n2WeekRanking_Divider_Texture");
    n2WeekRanking_Block_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n2WeekRanking_Block_texture");
    n3WeekRanking_Title_text = GetTextBoxHandle("SiegeReportWnd.WeekRankingWnd.n3WeekRanking_Title_text");
    n3WeekRanking_Name_text = GetTextBoxHandle("SiegeReportWnd.WeekRankingWnd.n3WeekRanking_Name_text");
    n3WeekRanking_PledgeCrest_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n3WeekRanking_PledgeCrest_texture");
    n3WeekRanking_PledgeAllianceCrest_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n3WeekRanking_PledgeAllianceCrest_texture");
    n3WeekRanking_GroupBox_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n3WeekRanking_GroupBox_texture");
    n3WeekRanking_Divider_Texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n3WeekRanking_Divider_Texture");
    n3WeekRanking_Block_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n3WeekRanking_Block_texture");
    n4WeekRanking_Title_text = GetTextBoxHandle("SiegeReportWnd.WeekRankingWnd.n4WeekRanking_Title_text");
    n4WeekRanking_Name_text = GetTextBoxHandle("SiegeReportWnd.WeekRankingWnd.n4WeekRanking_Name_text");
    n4WeekRanking_PledgeCrest_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n4WeekRanking_PledgeCrest_texture");
    n4WeekRanking_PledgeAllianceCrest_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n4WeekRanking_PledgeAllianceCrest_texture");
    n4WeekRanking_GroupBox_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n4WeekRanking_GroupBox_texture");
    n4WeekRanking_Block_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n4WeekRanking_Block_texture");
    n5WeekRanking_Title_text = GetTextBoxHandle("SiegeReportWnd.WeekRankingWnd.n5WeekRanking_Title_text");
    n5WeekRanking_Name_text = GetTextBoxHandle("SiegeReportWnd.WeekRankingWnd.n5WeekRanking_Name_text");
    n5WeekRanking_PledgeCrest_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n5WeekRanking_PledgeCrest_texture");
    n5WeekRanking_PledgeAllianceCrest_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n5WeekRanking_PledgeAllianceCrest_texture");
    n5WeekRanking_GroupBox_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n5WeekRanking_GroupBox_texture");
    n5WeekRanking_Block_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n5WeekRanking_Block_texture");
    n5WeekRanking_Divider_Texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n5WeekRanking_Flag_texture");
    n5WeekRanking_Flag_texture = GetTextureHandle("SiegeReportWnd.WeekRankingWnd.n5WeekRanking_Flag_texture");
    CloseButton = GetButtonHandle("SiegeReportWnd.CloseButton");
    GetButton = GetButtonHandle("SiegeReportWnd.GetButton");
    return;
}

function OnTimer(int TimerID)
{
    // End:0x2F
    if(TimerID == 2001114)
    {
        CastleWarSeasonResultHandler(refreshCastleWarSeasonResultStr, true);
        Me.KillTimer(2001114);
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x50
    if(Event_ID == 10070)
    {
        refreshCastleWarSeasonResultStr = param;
        CastleWarSeasonResultHandler(param);
        Debug("EV_CastleWarSeasonResult:" @ param);        
    }
    else
    {
        // End:0x92
        if(Event_ID == 10071)
        {
            CastleWarSeasonRewardHandler(param);
            Debug("EV_CastleWarSeasonReward:" @ param);
        }
    }
    return;
}

function CastleWarSeasonResultHandler(string param, optional bool bIgnoreTexUpdate)
{
    local string seasonWinPledgeName;
    local int seasonCount, N, nWeek, nButtonType, nSeasonWinPledgeID, nSeasonWinAllianceID,
	    nSeasonMaxCount;

    local bool bShowEmble;

    nSeasonCastleID = 0;
    ParseInt(param, "SeasonMaxCount", nSeasonMaxCount);
    // End:0x67
    if((nSeasonMaxCount <= 4) && nSeasonMaxCount > 0)
    {
        Me.SetWindowSize(328, 473 - 69);
        showLastWeekGroup(false);        
    }
    else
    {
        Me.SetWindowSize(328, 477);
        showLastWeekGroup(true);
    }
    ParseInt(param, "ChoiceSeason", nChoiceSeason);
    ParseString(param, "SeasonWinPledgeName", seasonWinPledgeName);
    ParseInt(param, "SeasonWinPledgeID", nSeasonWinPledgeID);
    ParseInt(param, "SeasonWinAllianceID", nSeasonWinAllianceID);
    setMonthlyWinnerInfo(seasonWinPledgeName, nSeasonWinPledgeID, nSeasonWinAllianceID, bIgnoreTexUpdate);
    ParseInt(param, "SeasonCount", seasonCount);
    bShowEmble = true;
    N = 1;
    J0x159:

    // End:0x25A [Loop If]
    if(N <= nSeasonMaxCount)
    {
        ParseString(param, "WeekWinPledgeName_" $ string(N), seasonWinPledgeName);
        ParseInt(param, "WeekNum_" $ string(N), nWeek);
        ParseInt(param, "WeekWinPledgeID_" $ string(N), nSeasonWinPledgeID);
        ParseInt(param, "WeekWinAllianceID_" $ string(N), nSeasonWinAllianceID);
        setWeekWinnerInfo(N, seasonWinPledgeName, nSeasonWinPledgeID, nSeasonWinAllianceID, seasonCount < N, bIgnoreTexUpdate);
        // End:0x250
        if(seasonWinPledgeName != "")
        {
            bShowEmble = false;
        }
        N++;
        // [Loop Continue]
        goto J0x159;
    }
    ParseInt(param, "ButtonType", nButtonType);
    ParseInt(param, "SeasonCastleID", nSeasonCastleID);
    // End:0x2BE
    if(nChoiceSeason > 0)
    {
        Me.SetWindowTitle(GetSystemString(3408));        
    }
    else
    {
        Me.SetWindowTitle(GetSystemString(3407));
    }
    // End:0x304
    if(nButtonType == 0)
    {
        CloseButton.ShowWindow();
        GetButton.HideWindow();        
    }
    else
    {
        CloseButton.HideWindow();
        GetButton.ShowWindow();
    }
    // End:0x396
    if(bShowEmble)
    {
        // End:0x366
        if(nChoiceSeason == 0)
        {
            SiegeReportDiscription_text.ShowWindow();
            MonthRankingNo1Wnd.HideWindow();
            LastMonthRankingNo1Wnd.HideWindow();            
        }
        else
        {
            SiegeReportDiscription_text.HideWindow();
        }
        EmblemRankingWnd.ShowWindow();
        WeekRankingWnd.HideWindow();        
    }
    else
    {
        SiegeReportDiscription_text.HideWindow();
        EmblemRankingWnd.HideWindow();
        WeekRankingWnd.ShowWindow();
    }
    Me.ShowWindow();
    Me.SetFocus();
    // End:0x419
    if(!bIgnoreTexUpdate)
    {
        Me.KillTimer(2001114);
        Me.SetTimer(2001114, 1000);
    }
    return;
}

function setWeekWinnerInfo(int nWeek, string winnerName, int PledgeCrestID, int AllianceCrestID, bool showBlock, optional bool bIgnoreTexUpdate)
{
    local Texture texPledge, texAlliance;
    local bool bPledge, bAlliance;

    // End:0x56
    if((nWeek <= 0) || nWeek > 5)
    {
        Debug("SigeReportWnd : nWeek가 1~5 값이 아닙니다." @ string(nWeek));
        return;
    }
    // End:0xB9
    if(showBlock)
    {
        GetTextureHandle(("SiegeReportWnd.WeekRankingWnd.n" $ string(nWeek)) $ "WeekRanking_Block_texture").ShowWindow();        
    }
    else
    {
        GetTextureHandle(("SiegeReportWnd.WeekRankingWnd.n" $ string(nWeek)) $ "WeekRanking_Block_texture").HideWindow();
    }
    // End:0x17F
    if(winnerName == "")
    {
        GetTextBoxHandle(("SiegeReportWnd.WeekRankingWnd.n" $ string(nWeek)) $ "WeekRanking_Name_text").SetText(GetSystemString(3416));
        return;        
    }
    else
    {
        GetTextBoxHandle(("SiegeReportWnd.WeekRankingWnd.n" $ string(nWeek)) $ "WeekRanking_Name_text").SetText(winnerName);
    }
    bPledge = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(PledgeCrestID, texPledge);
    bAlliance = Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(PledgeCrestID, texAlliance);
    // End:0x285
    if(bPledge)
    {
        GetTextureHandle(("SiegeReportWnd.WeekRankingWnd.n" $ string(nWeek)) $ "WeekRanking_PledgeCrest_texture").SetTextureWithObject(texPledge);        
    }
    else
    {
        // End:0x2A1
        if(!bIgnoreTexUpdate)
        {
            texPledge = GetPledgeCrestTexFromPledgeCrestID(PledgeCrestID);
        }
    }
    // End:0x317
    if(bAlliance)
    {
        GetTextureHandle(("SiegeReportWnd.WeekRankingWnd.n" $ string(nWeek)) $ "WeekRanking_PledgeAllianceCrest_texture").SetTextureWithObject(texAlliance);        
    }
    else
    {
        // End:0x333
        if(!bIgnoreTexUpdate)
        {
            texAlliance = GetAllianceCrestTexFromAllianceCrestID(AllianceCrestID);
        }
    }
    return;
}

function showLastWeekGroup(bool bShow)
{
    // End:0x84
    if(bShow)
    {
        n5WeekRanking_Title_text.ShowWindow();
        n5WeekRanking_Name_text.ShowWindow();
        n5WeekRanking_PledgeCrest_texture.ShowWindow();
        n5WeekRanking_PledgeAllianceCrest_texture.ShowWindow();
        n5WeekRanking_GroupBox_texture.ShowWindow();
        n5WeekRanking_Block_texture.ShowWindow();
        n5WeekRanking_Divider_Texture.ShowWindow();
        n5WeekRanking_Flag_texture.ShowWindow();        
    }
    else
    {
        n5WeekRanking_Title_text.HideWindow();
        n5WeekRanking_Name_text.HideWindow();
        n5WeekRanking_PledgeCrest_texture.HideWindow();
        n5WeekRanking_PledgeAllianceCrest_texture.HideWindow();
        n5WeekRanking_GroupBox_texture.HideWindow();
        n5WeekRanking_Block_texture.HideWindow();
        n5WeekRanking_Divider_Texture.HideWindow();
        n5WeekRanking_Flag_texture.HideWindow();
    }
    return;
}

function setMonthlyWinnerInfo(string winnerName, int PledgeCrestID, int AllianceCrestID, optional bool bIgnoreTexUpdate)
{
    local Texture texPledge, texAlliance;
    local bool bPledge, bAlliance;

    bPledge = Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(PledgeCrestID, texPledge);
    bAlliance = Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(PledgeCrestID, texAlliance);
    // End:0x121
    if(nChoiceSeason == 0)
    {
        MonthRankingNo1Wnd.ShowWindow();
        LastMonthRankingNo1Wnd.HideWindow();
        // End:0x92
        if(winnerName == "")
        {
            MonthRankingNo1Wnd_Name_text.SetText(GetSystemString(3416));            
        }
        else
        {
            MonthRankingNo1Wnd_Name_text.SetText(winnerName);
        }
        // End:0xC6
        if(bPledge)
        {
            MonthWnd_PledgeCrest_texture.SetTextureWithObject(texPledge);            
        }
        else
        {
            // End:0xE2
            if(!bIgnoreTexUpdate)
            {
                texPledge = GetPledgeCrestTexFromPledgeCrestID(PledgeCrestID);
            }
        }
        // End:0x102
        if(bAlliance)
        {
            MonthWnd_PledgeAllianceCrest_texture.SetTextureWithObject(texAlliance);            
        }
        else
        {
            // End:0x11E
            if(!bIgnoreTexUpdate)
            {
                texAlliance = GetAllianceCrestTexFromAllianceCrestID(AllianceCrestID);
            }
        }        
    }
    else
    {
        MonthRankingNo1Wnd.HideWindow();
        LastMonthRankingNo1Wnd.ShowWindow();
        // End:0x168
        if(winnerName == "")
        {
            LastMonthRankingNo1Wnd_Name_text.SetText(GetSystemString(3416));            
        }
        else
        {
            LastMonthRankingNo1Wnd_Name_text.SetText(winnerName);
        }
        // End:0x19C
        if(bPledge)
        {
            LastMonthWnd_PledgeCrest_texture.SetTextureWithObject(texPledge);            
        }
        else
        {
            // End:0x1B8
            if(!bIgnoreTexUpdate)
            {
                texPledge = GetPledgeCrestTexFromPledgeCrestID(PledgeCrestID);
            }
        }
        // End:0x1D8
        if(bAlliance)
        {
            LastMonthWnd_PledgeAllianceCrest_texture.SetTextureWithObject(texAlliance);            
        }
        else
        {
            // End:0x1F4
            if(!bIgnoreTexUpdate)
            {
                texAlliance = GetAllianceCrestTexFromAllianceCrestID(AllianceCrestID);
            }
        }
    }
    return;
}

function CastleWarSeasonRewardHandler(string paramStr)
{
    local int nResult;

    ParseInt(paramStr, "Result", nResult);
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x20
        case "CloseButton":
            OnCloseButtonClick();
            // End:0x3A
            break;
        // End:0x37
        case "GetButton":
            OnGetButtonClick();
            // End:0x3A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnCloseButtonClick()
{
    Me.HideWindow();
    return;
}

function OnGetButtonClick()
{
    // End:0x19
    if(nSeasonCastleID > 0)
    {
        RequestCastleWarSeasonReward(nSeasonCastleID);        
    }
    else
    {
        Debug("nSeasonCastleID 정보가 0과 같거나 작습니다.");
    }
    Me.HideWindow();
    return;
}
