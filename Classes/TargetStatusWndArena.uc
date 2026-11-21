class TargetStatusWndArena extends TargetStatusWnd;

function OnEvent(int Event_ID, string param)
{
    // End:0x17
    if(!getInstanceUIData().getIsArenaServer())
    {
        return;
    }
    // End:0x41
    if(Event_ID == 980)
    {
        // End:0x38
        if(m_rotated)
        {
            OnRotateReset();            
        }
        else
        {
            HandleTargetUpdate();
        }        
    }
    else
    {
        // End:0x59
        if(Event_ID == 990)
        {
            HandleTargetHideWindow();            
        }
        else
        {
            // End:0x76
            if(Event_ID == 300)
            {
                HandleReceiveTargetLevelDiff(param);                
            }
            else
            {
                // End:0x9F
                if((Event_ID == 190) || Event_ID == 191)
                {
                    HandleUpdateGauge(param, 0);                    
                }
                else
                {
                    // End:0xC8
                    if((Event_ID == 200) || Event_ID == 201)
                    {
                        HandleUpdateGauge(param, 0);                        
                    }
                    else
                    {
                        // End:0xF1
                        if((Event_ID == 210) || Event_ID == 211)
                        {
                            HandleUpdateGauge(param, 1);                            
                        }
                        else
                        {
                            // End:0x11A
                            if((Event_ID == 220) || Event_ID == 221)
                            {
                                HandleUpdateGauge(param, 1);                                
                            }
                            else
                            {
                                // End:0x137
                                if(Event_ID == 5120)
                                {
                                    HandleTargetSpelledList(param);                                    
                                }
                                else
                                {
                                    // End:0x154
                                    if(Event_ID == 981)
                                    {
                                        HandleTargetSkillInfo(param);                                        
                                    }
                                    else
                                    {
                                        // End:0x16C
                                        if(Event_ID == 982)
                                        {
                                            HandleSkillCancel();                                            
                                        }
                                        else
                                        {
                                            // End:0x181
                                            if(Event_ID == 160)
                                            {
                                                RequestTargetCancel();                                                
                                            }
                                            else
                                            {
                                                // End:0x1AF
                                                if(Event_ID == 150)
                                                {
                                                    // End:0x1AC
                                                    if(bIsShowBackup)
                                                    {
                                                        // End:0x1AC
                                                        if(m_TargetIDBackup > 0)
                                                        {
                                                            RequestTargetUser(m_TargetIDBackup);
                                                        }
                                                    }                                                    
                                                }
                                                else
                                                {
                                                    // End:0x1DF
                                                    if(Event_ID == 161)
                                                    {
                                                        bIsShowBackup = Me.IsShowWindow();
                                                        m_TargetIDBackup = m_targetID;                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x1FE
                                                        if(Event_ID == 40)
                                                        {
                                                            bIsShowBackup = false;
                                                            m_TargetIDBackup = -1;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function setJobTexture(int nClassID)
{
    local string userTexStr;

    userTexStr = GetClassArenaRoleIconName(nClassID);
    // End:0x7F
    if(Class'NWindow.UIDATA_TARGET'.static.IsNpc())
    {
        texMark.HideWindow();
        Username.SetWindowSizeRel(1.0000000, 0.0000000, -33, 14);
        Username.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 18, 8);        
    }
    else
    {
        texMark.ShowWindow();
        texMark.SetTexture(userTexStr);
        texMark.SetTooltipCustomType(MakeTooltipSimpleText((GetClassRoleName(nClassID) $ " - ") $ GetClassType(nClassID)));
        Username.SetWindowSizeRel(1.0000000, 0.0000000, -54, 14);
        Username.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 36, 8);
    }
    return;
}

function setChangeNameColor(UserInfo Info, string Name)
{
    local Color TargetNameColor;

    RankName.HideWindow();
    // End:0x48
    if(Class'NWindow.UIDATA_TARGET'.static.IsCanBeAttacked())
    {
        Username.SetNameWithColor(Name, 0, 2, GetColor(255, 0, 0, 255));        
    }
    else
    {
        // End:0x82
        if(Class'NWindow.UIDATA_TARGET'.static.IsNpc())
        {
            Username.SetNameWithColor(Name, 0, 2, GetColor(235, 205, 0, 255));            
        }
        else
        {
            // End:0xD9
            if(PartyWnd(GetScript("PartyWnd")).FindPartyID(m_targetID) != -1)
            {
                Username.SetNameWithColor(Name, 0, 2, GetColor(2, 255, 2, 255));                
            }
            else
            {
                TargetNameColor = GetTargetNameColor(m_TargetLevel);
                Username.SetNameWithColor(Name, 0, 2, TargetNameColor);
            }
        }
    }
    return;
}

function HandleTargetUpdate()
{
    local Rect rectWnd;
    local string strTmp;
    local int targetID, PlayerID, petID, clanType, clanNameValue;

    local bool bIsServerObject, bIsHPShowableNPC, bIsVehicle;
    local string Name, NameRank;
    local Color TargetNameColor;
    local int ServerObjectNameID;
    local Actor.EL2ObjectType ServerObjectType;
    local Vehicle VehicleActor;
    local string DriverName;
    local bool bShowHPBar, bShowMPBar, bShowPledgeInfo, bShowPledgeTex, bShowPledgeAllianceTex;

    local string PledgeName, PledgeAllianceName;
    local Texture PledgeCrestTexture, PledgeAllianceCrestTexture;
    local Color PledgeNameColor, PledgeAllianceNameColor;
    local bool bShowNpcInfo;
    local array<int> arrNpcInfo;
    local bool IsTargetChanged, WantHideName;
    local UserInfo Info;
    local PetInfo PetInfo;
    local Color WhiteColor;

    WhiteColor.R = 0;
    WhiteColor.G = 0;
    WhiteColor.B = 0;
    targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
    // End:0x6A
    if(targetID < 1)
    {
        // End:0x59
        if(m_rotated)
        {
            OnRotateClose();            
        }
        else
        {
            Me.HideWindow();
        }
        return;
    }
    // End:0x81
    if(m_targetID != targetID)
    {
        IsTargetChanged = true;
    }
    m_targetID = targetID;
    GetTargetInfo(Info);
    // End:0x117
    if(Info.TacticSign == 0)
    {
        Username.SetWindowSizeRel(1.0000000, 0.0000000, -33, 14);
        Username.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 18, 8);
        setJobTexture(Info.nSubClass);
        texMark.SetWindowSize(32, 32);        
    }
    else
    {
        texMark.ShowWindow();
        texMark.SetTexture("l2ui_Ct1.TargetStatusWnd_DF_mark_0" $ string(Info.TacticSign));
        texMark.SetWindowSize(16, 16);
        Username.SetWindowSizeRel(1.0000000, 0.0000000, -54, 14);
        Username.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 36, 8);
    }
    WantHideName = Info.WantHideName;
    rectWnd = Me.GetRect();
    PledgeName = GetSystemString(431);
    PledgeAllianceName = GetSystemString(591);
    PledgeNameColor.R = 128;
    PledgeNameColor.G = 128;
    PledgeNameColor.B = 128;
    PledgeAllianceNameColor.R = 128;
    PledgeAllianceNameColor.G = 128;
    PledgeAllianceNameColor.B = 128;
    TargetNameColor = GetTargetNameColor(m_TargetLevel);
    bIsServerObject = Class'NWindow.UIDATA_TARGET'.static.IsServerObject();
    bIsVehicle = Class'NWindow.UIDATA_TARGET'.static.IsVehicle();
    // End:0x3F3
    if(bIsServerObject)
    {
        ServerObjectType = Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectType(m_targetID);
        // End:0x2E7
        if(int(ServerObjectType) == int(4))
        {
            Name = GetSystemString(1966);
            NameRank = "";            
        }
        else
        {
            // End:0x31C
            if(int(ServerObjectType) == int(5))
            {
                Name = Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectName(m_targetID);
                NameRank = "";                
            }
            else
            {
                ServerObjectNameID = Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectNameID(m_targetID);
                // End:0x363
                if(ServerObjectNameID > 0)
                {
                    Name = Class'NWindow.UIDATA_STATICOBJECT'.static.GetStaticObjectName(ServerObjectNameID);
                    NameRank = "";
                }
            }
        }
        Username.SetName(Name, 0, 2);
        RankName.SetName(NameRank, 0, 2);
        // End:0x3F0
        if(int(ServerObjectType) == int(1))
        {
            // End:0x3F0
            if(Class'NWindow.UIDATA_STATICOBJECT'.static.GetStaticObjectShowHP(m_targetID))
            {
                bShowHPBar = true;
                UpdateHPBar(Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectHP(m_targetID), Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectMaxHP(m_targetID));
            }
        }        
    }
    else
    {
        // End:0x4B5
        if(bIsVehicle)
        {
            HandleTargetHideWindow();
            return;
            Username.SetName("AirShip", 0, 2);
            VehicleActor = Vehicle(Class'NWindow.UIDATA_TARGET'.static.GetTargetActor());
            // End:0x4B2
            if(VehicleActor != none)
            {
                // End:0x47C
                if(VehicleActor.DriverID > 0)
                {
                    DriverName = Class'NWindow.UIDATA_USER'.static.GetUserName(VehicleActor.DriverID);
                }
                // End:0x49A
                if(Len(DriverName) < 1)
                {
                    DriverName = GetSystemString(1967);
                }
                RankName.SetName(DriverName, 0, 2);
            }            
        }
        else
        {
            // End:0x695
            if(Len(Info.Name) < 1)
            {
                Name = Class'NWindow.UIDATA_PARTY'.static.GetMemberVirtualName(m_targetID);
                // End:0x507
                if(Name == "")
                {
                    Name = Class'NWindow.UIDATA_PARTY'.static.GetMemberName(m_targetID);
                }
                NameRank = "";
                Username.SetName(Name, 0, 2);
                RankName.SetName(NameRank, 0, 2);
                // End:0x5D8
                if(Class'NWindow.UIDATA_PARTY'.static.GetMemberTacticalSign(m_targetID) == 0)
                {
                    texMark.HideWindow();
                    Username.SetWindowSizeRel(1.0000000, 0.0000000, -33, 14);
                    Username.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 18, 8);
                    setJobTexture(Info.nSubClass);
                    texMark.SetWindowSize(32, 32);                    
                }
                else
                {
                    texMark.ShowWindow();
                    texMark.SetTexture("l2ui_Ct1.TargetStatusWnd_DF_mark_0" $ string(Class'NWindow.UIDATA_PARTY'.static.GetMemberTacticalSign(m_targetID) - 1));
                    texMark.SetWindowSize(16, 16);
                    Username.SetWindowSizeRel(1.0000000, 0.0000000, -54, 14);
                    Username.SetAnchor(m_WindowName, "TopLeft", "TopLeft", 36, 8);
                }                
            }
            else
            {
                PlayerID = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerID();
                GetPetInfo(PetInfo);
                petID = Info.nID;
                bIsHPShowableNPC = Class'NWindow.UIDATA_TARGET'.static.IsHPShowableNPC();
                // End:0x8DB
                if(((((Info.bNpc && !Info.bPet) && bIsHPShowableNPC) || (PlayerID > 0) && m_targetID == PlayerID) || (Info.bNpc && Info.bPet) && m_targetID == petID) || Info.bNpc && bIsHPShowableNPC)
                {
                    // End:0x805
                    if(IsAllWhiteID(Info.nClassID))
                    {
                        Name = Info.Name;
                        NameRank = "";
                        Username.SetName(Name, 0, 2);
                        RankName.SetName(NameRank, 0, 2);
                        // End:0x802
                        if(!IsNoBarID(Info.nClassID))
                        {
                            bShowHPBar = true;
                            UpdateHPBar(Info.nCurHP, Info.nMaxHP);
                        }                        
                    }
                    else
                    {
                        Name = Info.Name;
                        NameRank = "";
                        Username.SetNameWithColor(Name, 0, 2, TargetNameColor);
                        RankName.SetName(NameRank, 0, 2);
                        // End:0x884
                        if(Info.nMaxHP > 0)
                        {
                            bShowHPBar = true;
                            UpdateHPBar(Info.nCurHP, Info.nMaxHP);
                        }
                        // End:0x8D8
                        if(!Info.bNpc && !Info.bPet)
                        {
                            // End:0x8D8
                            if(Info.nMaxMP > 0)
                            {
                                bShowMPBar = true;
                                UpdateMPBar(Info.nCurMP, Info.nMaxMP);
                            }
                        }
                    }                    
                }
                else
                {
                    Name = Info.Name;
                    // End:0x903
                    if(WantHideName)
                    {
                        RankName.HideWindow();
                    }
                    // End:0x924
                    if(Info.bNpc)
                    {
                        NameRank = "";
                        g_NameStr = "";                        
                    }
                    else
                    {
                        g_NameStr = Name;
                        Username.SetName(Name, 0, 2);
                        // End:0x979
                        if(Info.nMaxHP > 0)
                        {
                            bShowHPBar = true;
                            UpdateHPBar(Info.nCurHP, Info.nMaxHP);
                        }
                        // End:0x9BB
                        if(!Info.bPet)
                        {
                            // End:0x9BB
                            if(Info.nMaxMP > 0)
                            {
                                bShowMPBar = true;
                                UpdateMPBar(Info.nCurMP, Info.nMaxMP);
                            }
                        }
                    }
                }
                // End:0xC61
                if(m_bExpand)
                {
                    // End:0xA24
                    if(Info.bNpc && 0 >= Info.nMasterID)
                    {
                        // End:0xA21
                        if(Class'NWindow.UIDATA_NPC'.static.GetNpcProperty(Info.nClassID, arrNpcInfo))
                        {
                            bShowNpcInfo = true;
                            // End:0xA21
                            if(IsTargetChanged)
                            {
                                UpdateNpcInfoTree(arrNpcInfo);
                            }
                        }                        
                    }
                    else
                    {
                        bShowPledgeInfo = true;
                        // End:0xC61
                        if(Info.nClanID > 0)
                        {
                            PledgeName = Class'NWindow.UIDATA_CLAN'.static.GetName(Info.nClanID);
                            PledgeNameColor.R = 176;
                            PledgeNameColor.G = 152;
                            PledgeNameColor.B = 121;
                            // End:0xB73
                            if(((PledgeName != "") && Class'NWindow.UIDATA_USER'.static.GetClanType(m_targetID, clanType)) && Class'NWindow.UIDATA_CLAN'.static.GetNameValue(Info.nClanID, clanNameValue))
                            {
                                // End:0xB08
                                if(clanType == -1)
                                {
                                    PledgeNameColor.R = 209;
                                    PledgeNameColor.G = 167;
                                    PledgeNameColor.B = 2;                                    
                                }
                                else
                                {
                                    // End:0xB3F
                                    if(clanNameValue > 0)
                                    {
                                        PledgeNameColor.R = 0;
                                        PledgeNameColor.G = 130;
                                        PledgeNameColor.B = byte(255);                                        
                                    }
                                    else
                                    {
                                        // End:0xB73
                                        if(clanNameValue < 0)
                                        {
                                            PledgeNameColor.R = byte(255);
                                            PledgeNameColor.G = 0;
                                            PledgeNameColor.B = 0;
                                        }
                                    }
                                }
                            }
                            // End:0xBB3
                            if(Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(Info.nClanID, PledgeCrestTexture))
                            {
                                bShowPledgeTex = true;
                                texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);                                
                            }
                            else
                            {
                                bShowPledgeTex = false;
                            }
                            strTmp = Class'NWindow.UIDATA_CLAN'.static.GetAllianceName(Info.nClanID);
                            // End:0xC61
                            if(Len(strTmp) > 0)
                            {
                                PledgeAllianceName = strTmp;
                                PledgeAllianceNameColor.R = 176;
                                PledgeAllianceNameColor.G = 155;
                                PledgeAllianceNameColor.B = 121;
                                // End:0xC59
                                if(Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(Info.nClanID, PledgeAllianceCrestTexture))
                                {
                                    bShowPledgeAllianceTex = true;
                                    texPledgeAllianceCrest.SetTextureWithObject(PledgeAllianceCrestTexture);                                    
                                }
                                else
                                {
                                    bShowPledgeAllianceTex = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    // End:0xCC1
    if(!Me.IsShowWindow() && GetGameStateName() != "SPECIALCAMERASTATE")
    {
        Me.ShowWindow();
        Me.SetFocus();
        SetExpandMode(m_bExpand, false);
    }
    // End:0xD32
    if(ContextMenu(GetScript("ContextMenu")).getContextEventInfo().Id > 0)
    {
        ContextMenu(GetScript("ContextMenu")).makeContextMenu();
        ContextMenu(GetScript("ContextMenu")).clearInfo();
    }
    // End:0xD4D
    if(bShowHPBar)
    {
        barHP.ShowWindow();        
    }
    else
    {
        barHP.HideWindow();
    }
    // End:0xD77
    if(bShowMPBar)
    {
        barMP.ShowWindow();        
    }
    else
    {
        barMP.HideWindow();
    }
    // End:0xD9E
    if(Info.nClanID < 0)
    {
        bShowPledgeInfo = false;
    }
    // End:0xFBF
    if(bShowPledgeInfo)
    {
        // End:0xF62
        if(!WantHideName && GetGameStateName() != "SPECIALCAMERASTATE")
        {
            txtPledge.ShowWindow();
            txtAlliance.ShowWindow();
            txtPledgeName.ShowWindow();
            txtPledgeAllianceName.ShowWindow();
            txtPledgeName.SetText(PledgeName);
            txtPledgeAllianceName.SetText(PledgeAllianceName);
            txtPledgeName.SetTextColor(PledgeNameColor);
            txtPledgeAllianceName.SetTextColor(PledgeAllianceNameColor);
            // End:0xEA5
            if(bShowPledgeTex)
            {
                texPledgeCrest.ShowWindow();
                txtPledgeName.MoveTo(rectWnd.nX + 63, rectWnd.nY + 43);                
            }
            else
            {
                texPledgeCrest.HideWindow();
                txtPledgeName.MoveTo(rectWnd.nX + 45, rectWnd.nY + 43);
            }
            // End:0xF25
            if(bShowPledgeAllianceTex)
            {
                texPledgeAllianceCrest.ShowWindow();
                txtPledgeAllianceName.MoveTo(rectWnd.nX + 63, rectWnd.nY + 59);                
            }
            else
            {
                texPledgeAllianceCrest.HideWindow();
                txtPledgeAllianceName.MoveTo(rectWnd.nX + 45, rectWnd.nY + 59);
            }            
        }
        else
        {
            txtPledge.HideWindow();
            txtAlliance.HideWindow();
            txtPledgeName.HideWindow();
            txtPledgeAllianceName.HideWindow();
            texPledgeCrest.HideWindow();
            texPledgeAllianceCrest.HideWindow();
        }        
    }
    else
    {
        txtPledge.HideWindow();
        txtAlliance.HideWindow();
        txtPledgeName.HideWindow();
        txtPledgeAllianceName.HideWindow();
        texPledgeCrest.HideWindow();
        texPledgeAllianceCrest.HideWindow();
    }
    // End:0x1065
    if(bShowNpcInfo && GetGameStateName() != "SPECIALCAMERASTATE")
    {
        NpcInfo.ShowWindow();
        NpcInfo.ShowScrollBar(false);        
    }
    else
    {
        NpcInfo.HideWindow();
    }
    setChangeNameColor(Info, Name);
    return;
}

function OnDefaultPosition()
{
    local string stateName;

    stateName = GetGameStateName();
    switch(stateName)
    {
        // End:0x28
        case "ARENAGAMINGSTATE":
        // End:0x3B
        case "ARENAPICKSTATE":
        // End:0x89
        case "ARENABATTLESTATE":
            Me.SetAnchor("", "TopCenter", "TopCenter", 0, 90);
            Me.ClearAnchor();
        // End:0xFFFF
        default:
            return;
            break;
    }
}

defaultproperties
{
    m_WindowName="TargetStatusWndArena"
}