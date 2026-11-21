class PlayerPortPacketInterface extends PlayerPortStatisticObject
    config(Engine)
    perobjectconfig;

function updatePortInfo(WebBrowserHandle _web, int EventID, optional string param)
{
    local int i, VSize, nPartyCount;
    local string uiObject, URL, partyObject, keys, humanObject, statisticObject;

    LogInternal(("[PlayerPort.STUB] updatePortInfo blocked (eventID=" $ string(EventID)) $ ")");
    return;
    URL = _web.GetUrl();
    // End:0x7A
    if(!GetPlayerInfo(Owner) || !isCorrectUser())
    {
        return;
    }
    // End:0xD9
    if(((_web.GetUrl() == "about:blank") || _web.GetUrl() == "") || _web.GetUrl() != TARGET_URL)
    {
        URL = TARGET_URL;
    }
    uiObject = "{}";
    partyObject = "{}";
    humanObject = "{}";
    statisticObject = "{}";
    _web.BeginParam("UTF-8");
    _web.PushParam("UserAgent", "default_npc");
    _web.PushParam("nServerType", string(1));
    _web.PushParam("nClientType", string(GetServerType()));
    _web.PushParam("srvAddr", serverAddress);
    _web.PushParam("DH", string(GetDisplayHeight()));
    _web.PushParam("DW", string(GetDisplayWidth()));
    _web.PushParam("isBuilderPC", string(int(IsBuilderPC())));
    _web.PushParam("Language", string(GetLanguage()));
    _web.PushParam("isNative", string(int(IsNative())));
    _web.PushParam("nID", string(Owner.nID));
    _web.PushParam("Name", Locs(Owner.Name, "&", "**", false));
    // End:0x2C3
    if(Owner.strNickName != "")
    {
        _web.PushParam("uTitle", Locs(Owner.strNickName, "&", "**", false));
    }
    _web.PushParam("nSex", string(Owner.nSex));
    _web.PushParam("Race", string(Owner.Race));
    _web.PushParam("nLevel", string(Owner.nLevel));
    _web.PushParam("nCurExp", (Owner.nCurExp));
    _web.PushParam("nSubClass", string(Owner.nSubClass));
    _web.PushParam("nPKCount", string(Owner.nPKCount));
    _web.PushParam("PvPPoint", string(Owner.PvPPoint));
    _web.PushParam("nZoneID", string(GetCurrentZoneID()));
    _web.PushParam("nZoneCode", string(nZoneCode));
    _web.PushParam("Adena", (GetAdena()));
    _web.PushParam("LocX", string(Owner.loc.X));
    _web.PushParam("LocY", string(Owner.loc.Y));
    _web.PushParam("LocZ", string(Owner.loc.Z));
    _web.PushParam("nCHP", string(Owner.nCurHP));
    _web.PushParam("nMHP", string(Owner.nMaxHP));
    _web.PushParam("nCMP", string(Owner.nCurMP));
    _web.PushParam("nMMP", string(Owner.nMaxMP));
    _web.PushParam("nCCP", string(Owner.nCurCP));
    _web.PushParam("nMCP", string(Owner.nMaxCP));
    _web.PushParam("nMS", DetailStatusWnd(GetScript("DetailStatusWnd")).GetMovingSpeed(Owner));
    _web.PushParam("nNobless", string(Owner.nNobless));
    _web.PushParam("nHero", string(int(Owner.bHero)));
    _web.PushParam("nPremium", string(nPremiumState));
    _web.PushParam("nPvP", string(Owner.nDualCount));
    _web.PushParam("domID", string(Owner.JoinedDominionID));
    _web.PushParam("isS", string(int(IsPlayerStand())));
    _web.PushParam("isPS", string(int(IsUsePrivateStore())));
    // End:0x6FC
    if(Owner.nClanID > 0)
    {
        _web.PushParam("nClanID", string(Owner.nClanID));
        _web.PushParam("ClanName", GetClanName(Owner.nClanID));
        _web.PushParam("nClanPoints", string(nClanPoints));
    }
    // End:0x76A
    if(Owner.nAllianceID > 0)
    {
        _web.PushParam("nAllianceID", string(Owner.nAllianceID));
        _web.PushParam("AllianceName", Class'NWindow.UIDATA_CLAN'.static.GetAllianceName(Owner.nClanID));
    }
    nPartyCount = GetPartyMemberCount();
    // End:0x792
    if(nPartyCount > 0)
    {
        partyObject = makePartyObject(nPartyCount);
    }
    uiObject = makeUIObject();
    humanObject = makeHumanObject();
    statisticObject = makeStatisticObject();
    _web.PushParam("nEventID", string(EventID));
    // End:0x826
    if(param != "")
    {
        // End:0x80B
        if(InStr(param, "&") > -1)
        {
            param = Locs(param, "&", "**", false);
        }
        _web.PushParam("param", param);
    }
    // End:0x85A
    if(json.isValidJson(partyObject))
    {
        _web.PushParam("ptParam", partyObject);
    }
    // End:0x891
    if(json.isValidJson(uiObject))
    {
        _web.PushParam("nUIVersion", uiObject);
    }
    // End:0x8C3
    if(json.isValidJson(humanObject))
    {
        _web.PushParam("human", humanObject);
    }
    // End:0x8F7
    if(json.isValidJson(statisticObject))
    {
        _web.PushParam("stParam", statisticObject);
    }
    respond(_web, URL);
    return;
}

private function respond(WebBrowserHandle _web, string URL)
{
    _web.NavigateAsPost(URL);
    clearStatistic();
    return;
}

function string makePartyObject(int nPartySize)
{
    local int i;
    local string S;

    json.push("imL", string(imLeader()));
    i = 0;
    J0x23:

    // End:0xCD [Loop If]
    if(i < nPartySize)
    {
        json.push("pm_" $ string(i), string(PartyWnd(GetScript("PartyWnd")).m_arrID[i]));
        json.push("pname_" $ string(i), PartyWnd(GetScript("PartyWnd")).m_PlayerName[i].GetName());
        i++;
        // [Loop Continue]
        goto J0x23;
    }
    S = json.Get(true);
    // End:0x10C
    if(InStr(S, "&") > -1)
    {
        S = Locs(S, "&", "**", false);
    }
    return S;
    return;
}

function string makeHumanObject()
{
    local string S;

    json.push("l2", ROOTNAME);
    json.push("sst", string(nLastSessionTime));
    json.push("un", windowsName);
    json.push("wt", string(GetAppSeconds()));
    json.push("lt", Left(GetTimeString(), 5));
    json.push("ts", string(ServerInfo.selected));
    json.push("tsn", targetServerInfo.Name);
    json.push("tsncc", string(targetServerInfo.CharCnt));
    json.push("isa", string(targetServerInfo.IsAdenServer));
    json.push("isc", string(targetServerInfo.IsClassicServer));
    GetINIString("val", "key1", key1, GetMydocumentPath() $ "\\portvals.dat");
    GetINIString("val", "key1C", key1C, GetMydocumentPath() $ "\\portvals.dat");
    GetINIString("val", "key2", key2, GetMydocumentPath() $ "\\portvals.dat");
    json.push("la", key1);
    json.push("laC", key1C);
    json.push("pw", key2);
    S = json.Get(true);
    // End:0x232
    if(InStr(S, "&") > -1)
    {
        S = Locs(S, "&", "**", false);
    }
    return S;
    return;
}

function string makeStatisticObject()
{
    // End:0x39
    if(__NFUN_409__(Statistic.expEarned, (0)))
    {
        json.push("expEarned", (Statistic.expEarned));
    }
    // End:0x71
    if(__NFUN_409__(Statistic.expSpent, (0)))
    {
        json.push("expSpent", (Statistic.expSpent));
    }
    // End:0xA6
    if(Statistic.spEarned > 0)
    {
        json.push("spEarned", string(Statistic.spEarned));
    }
    // End:0xDA
    if(Statistic.spSpent > 0)
    {
        json.push("spSpent", string(Statistic.spSpent));
    }
    // End:0x115
    if(__NFUN_409__(Statistic.adenaEarned, (0)))
    {
        json.push("adenaEarned", (Statistic.adenaEarned));
    }
    // End:0x14F
    if(__NFUN_409__(Statistic.adenaSpent, (0)))
    {
        json.push("adenaSpent", (Statistic.adenaSpent));
    }
    // End:0x188
    if(__NFUN_409__(Statistic.colEarned, (0)))
    {
        json.push("colEarned", (Statistic.colEarned));
    }
    // End:0x1C0
    if(__NFUN_409__(Statistic.colSpent, (0)))
    {
        json.push("colSpent", (Statistic.colSpent));
    }
    // End:0x1F0
    if(Statistic.pvpEarned > 0)
    {
        json.push("pvp", string(Statistic.pvpEarned));
    }
    // End:0x21F
    if(Statistic.pkEarned > 0)
    {
        json.push("pk", string(Statistic.pkEarned));
    }
    // End:0x251
    if(Statistic.dyingCount > 0)
    {
        json.push("dying", string(Statistic.dyingCount));
    }
    return json.Get(true);
    return;
}

function string makeUIObject()
{
    json.push("s", "bohpts");
    json.push("ui", "1.1.9");
    json.push("code", GetUIVersionCodename(5));
    json.push("nt", "Qz8");
    json.push("gore", "U9K7O");
    return json.Get(true);
    return;
}
