class PartySearchRequestWnd extends PacketsInfo;

const EV_PARTY_SEARCH_REQUEST = 1130;
const EV_PARTY_SEARCH_CLOSE = 1131;
const EV_PARTY_SEARCH_CLAN = 1132;
const TIMER_COUNTDOWN = 1001;

var string m_WindowName;
var int nCurrentProgressTime;
var WindowHandle Me;
var TextureHandle FaceIcon;
var TextureHandle ClassIcon;
var TextBoxHandle NickTxt;
var TextBoxHandle LevelTxt;
var TextBoxHandle ClassTxt;
var TextBoxHandle PremiumTxt;
var TextBoxHandle PremiumValTxt;
var TextureHandle ClanCrest;
var TextBoxHandle ClanTxt;
var TextBoxHandle GsTxt;
var ProgressCtrlHandle ReadyProgress;
var TextBoxHandle ProgressInfoTxt;

function OnLoad()
{
    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    FaceIcon = GetTextureHandle(m_WindowName $ ".DialogBody.FaceIcon");
    ClassIcon = GetTextureHandle(m_WindowName $ ".DialogBody.ClassIcon");
    NickTxt = GetTextBoxHandle(m_WindowName $ ".DialogBody.NickTxt");
    LevelTxt = GetTextBoxHandle(m_WindowName $ ".DialogBody.LevelTxt");
    ClassTxt = GetTextBoxHandle(m_WindowName $ ".DialogBody.ClassTxt");
    PremiumTxt = GetTextBoxHandle(m_WindowName $ ".DialogBody.PremiumTxt");
    PremiumValTxt = GetTextBoxHandle(m_WindowName $ ".DialogBody.PremiumValTxt");
    ClanCrest = GetTextureHandle(m_WindowName $ ".DialogBody.ClanCrest");
    ClanTxt = GetTextBoxHandle(m_WindowName $ ".DialogBody.ClanTxt");
    GsTxt = GetTextBoxHandle(m_WindowName $ ".DialogBody.GsTxt");
    ReadyProgress = GetProgressCtrlHandle(m_WindowName $ ".DialogBody.ReadyProgress");
    ProgressInfoTxt = GetTextBoxHandle(m_WindowName $ ".DialogBody.ProgressInfoTxt");
    return;
}

function OnShow()
{
    return;
}

function OnHide()
{
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(3550);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1A
    if(Event_ID == 3550)
    {
        handleCustomPacket(param);
    }
    return;
}

function handleCustomPacket(string param)
{
    local int EventID;

    ParseInt(param, "EventID", EventID);
    switch(EventID)
    {
        // End:0x36
        case 1130:
            handleRequest(param);
            // End:0x63
            break;
        // End:0x4C
        case 1132:
            handleClan(param);
            // End:0x63
            break;
        // End:0x5D
        case 1131:
            closeWindow();
            // End:0x63
            break;
        // End:0xFFFF
        default:
            // End:0x63
            break;
            break;
    }
    return;
}

function handleRequest(string param)
{
    local int nTimeout, nClassID, nGs, nPacked, nPremium, nSep;

    local string sNick, sLevel, sClass, sPremium, sFaceIcon;

    local Color cPremium;

    ParseInt(param, "ask", nGs);
    ParseInt(param, "reply", nPacked);
    ParseString(param, "param1", sNick);
    ParseString(param, "param2", sLevel);
    ParseString(param, "param3", sClass);
    ParseString(param, "param5", sPremium);
    ParseString(param, "param6", sFaceIcon);
    nPremium = nPacked / 10000000;
    nPacked = int(float(nPacked) % float(10000000));
    nClassID = nPacked / 1000;
    nTimeout = int(float(nPacked) % float(1000));
    // End:0x10B
    if(nTimeout <= 0)
    {
        nTimeout = 10;
    }
    // End:0x13E
    if(Len(sFaceIcon) > 0)
    {
        FaceIcon.SetTexture(sFaceIcon);
        FaceIcon.ShowWindow();        
    }
    else
    {
        FaceIcon.HideWindow();
    }
    ClassIcon.SetTexture("UI_BOHPTS.icons.Class_Icon" $ string(nClassID));
    NickTxt.SetText(sNick);
    LevelTxt.SetText(sLevel);
    ClassTxt.SetText(sClass);
    nSep = InStr(sPremium, "|");
    // End:0x214
    if(nSep >= 0)
    {
        PremiumTxt.SetText(Left(sPremium, nSep));
        PremiumValTxt.SetText(Mid(sPremium, nSep + 1));        
    }
    else
    {
        PremiumTxt.SetText(sPremium);
        PremiumValTxt.SetText("");
    }
    cPremium.A = byte(255);
    // End:0x283
    if(nPremium > 0)
    {
        cPremium.R = byte(64);
        cPremium.G = byte(216);
        cPremium.B = byte(96);        
    }
    else
    {
        cPremium.R = byte(228);
        cPremium.G = byte(202);
        cPremium.B = byte(127);
    }
    PremiumValTxt.SetTextColor(cPremium);
    hideClan();
    // End:0x321
    if(nGs > 0)
    {
        GsTxt.SetText("GS: " $ string(nGs));
        GsTxt.SetTextColor(GetGearScoreTierColor((nGs)));
        GsTxt.ShowWindow();        
    }
    else
    {
        GsTxt.SetText("");
        GsTxt.HideWindow();
    }
    nCurrentProgressTime = nTimeout;
    initProgress();
    startProgress();
    Me.ShowWindow();
    return;
}

function handleClan(string param)
{
    local int nClanID;
    local string sClanLine;

    ParseInt(param, "ask", nClanID);
    ParseString(param, "param1", sClanLine);
    // End:0x4F
    if((nClanID <= 0) || Len(sClanLine) <= 0)
    {
        hideClan();
        return;
    }
    ClanTxt.SetText(sClanLine);
    ClanTxt.ShowWindow();
    ClanCrest.SetTextureWithClanCrest(nClanID);
    ClanCrest.ShowWindow();
    return;
}

function hideClan()
{
    ClanTxt.SetText("");
    ClanTxt.HideWindow();
    ClanCrest.HideWindow();
    return;
}

function OnClickButton(string strID)
{
    // End:0x27
    if(strID == "OKButton")
    {
        RequestBypassToServer("psjoin 1");        
    }
    else
    {
        // End:0x4F
        if(strID == "CancelButton")
        {
            RequestBypassToServer("psjoin 0");
        }
    }
    closeWindow();
    return;
}

function OnProgressTimeUp(string strID)
{
    // End:0x1F
    if(strID == "ReadyProgress")
    {
        closeWindow();
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x15
    if(TimerID == 1001)
    {
        updateTextProgress();
    }
    return;
}

function initProgress()
{
    Me.KillTimer(1001);
    ReadyProgress.Reset();
    ReadyProgress.SetProgressTime(nCurrentProgressTime * 1000);
    ProgressInfoTxt.SetText(string(nCurrentProgressTime) @ GetSystemString(5184));
    return;
}

function startProgress()
{
    Me.KillTimer(1001);
    Me.SetTimer(1001, 1000);
    ReadyProgress.Start();
    return;
}

function updateTextProgress()
{
    Me.KillTimer(1001);
    nCurrentProgressTime--;
    // End:0x28
    if(nCurrentProgressTime < 0)
    {
        return;
    }
    Me.SetTimer(1001, 1000);
    ProgressInfoTxt.SetText(string(nCurrentProgressTime) @ GetSystemString(5184));
    return;
}

function closeWindow()
{
    Me.KillTimer(1001);
    ReadyProgress.Stop();
    Me.HideWindow();
    return;
}
