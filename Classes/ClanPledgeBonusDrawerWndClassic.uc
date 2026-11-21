class ClanPledgeBonusDrawerWndClassic extends UICommonAPI;

const ACCESS_TYPE = 0;
const HUNT_TYPE = 1;

var WindowHandle Me;
var ItemWindowHandle JoinYesterdayBonus_Item_ItemWnd;
var ItemWindowHandle HuntYesterdayBonus_Item_ItemWnd;
var string JoinWndPath;
var string HuntWndPath;
var bool hasPledgeBonusList;
var string m_WindowName;
var string m_ClanPledgeRaidWindowName;
var int accessBonusMax;
var int huntBonusMax;

function OnRegisterEvent()
{
    RegisterEvent(20190);
    RegisterEvent(20191);
    RegisterEvent(20193);
    RegisterEvent(20192);
    RegisterEvent(40);
    RegisterEvent(20194);
    return;
}

function OnLoad()
{
    local string strStep;

    SetClosingOnESC();
    Initialize();
    strStep = (GetSystemString(898) @ GetSystemString(2980)) @ ":";
    // End:0x69
    if((int(GetLanguage()) == int(8)) || int(GetLanguage()) == int(9))
    {
        strStep = GetSystemString(3655) @ ":";
    }
    GetTextBoxHandle((((m_WindowName $ ".") $ m_ClanPledgeRaidWindowName) $ ".") $ "ClanRaidStageTitle_Text").SetText(strStep);
    return;
}

function Initialize()
{
    Me = GetWindowHandle(m_WindowName);
    JoinWndPath = m_WindowName $ ".ClanPledgeBonus_Window.JoinBonusWnd";
    HuntWndPath = m_WindowName $ ".ClanPledgeBonus_Window.HuntBonusWnd";
    JoinYesterdayBonus_Item_ItemWnd = GetItemWindowHandle(m_WindowName $ ".ClanPledgeBonus_Window.JoinBonusWnd.JoinYesterdayBonus_Item_ItemWnd");
    HuntYesterdayBonus_Item_ItemWnd = GetItemWindowHandle(m_WindowName $ ".ClanPledgeBonus_Window.HuntBonusWnd.HuntYesterdayBonus_Item_ItemWnd");
    hasPledgeBonusList = false;
    return;
}

function OnShow()
{
    // End:0x6A
    if(getInstanceUIData().getIsClassicServer())
    {
        // End:0x67
        if(GetWindowHandle("ClanDrawerWndClassic").IsShowWindow())
        {
            ClanDrawerWndClassic(GetScript("ClanDrawerWndClassic")).HideClanWindow();
        }        
    }
    else
    {
        // End:0xB0
        if(GetWindowHandle("ClanDrawerWnd").IsShowWindow())
        {
            ClanDrawerWnd(GetScript("ClanDrawerWnd")).HideClanWindow();
        }
    }
    return;
}

function PlegeBonusUpdate(string param)
{
    local int missionType, currPoint;

    // End:0x192
    if(Me.IsShowWindow())
    {
        ParseInt(param, "MissionType", missionType);
        ParseInt(param, "CurrPoint", currPoint);
        // End:0xF5
        if(missionType == 1)
        {
            // End:0xF2
            if(huntBonusMax > 0)
            {
                GetTextBoxHandle(HuntWndPath $ ".HuntBonus_MemberCount1_Text").SetText(string(currPoint));
                GetTextBoxHandle(HuntWndPath $ ".HuntBonus_MemberCount2_Text").SetText("/" $ string(huntBonusMax));
                setStateProgress(missionType, huntBonusMax, currPoint);
            }            
        }
        else
        {
            // End:0x192
            if(accessBonusMax > 0)
            {
                GetTextBoxHandle(JoinWndPath $ ".JoinBonus_MemberCount1_Text").SetText(string(currPoint));
                GetTextBoxHandle(JoinWndPath $ ".JoinBonus_MemberCount2_Text").SetText("/" $ string(accessBonusMax));
                setStateProgress(missionType, accessBonusMax, currPoint);
            }
        }
    }
    return;
}

function PledgeBonusOpenHandler(string param)
{
    local int accessBonusCurr, accessRewardID, accessRewardSkillLV, accessBtnActive, huntBonusCurr, huntRewardID,
	    huntRewardLV, huntBtnActive;

    local SkillInfo accessBonusSkillInfo, huntRewardSkillInfo;
    local ItemInfo accessBonusItemInfo, huntRewardItemInfo;
    local int AccessRewardType, HuntRewardType;

    // End:0x23
    if(!Me.IsShowWindow())
    {
        Me.ShowWindow();
    }
    ParseInt(param, "AccessRewardType", AccessRewardType);
    ParseInt(param, "AccessBonusMax", accessBonusMax);
    ParseInt(param, "AccessBonusCurr", accessBonusCurr);
    ParseInt(param, "AccessRewardID", accessRewardID);
    ParseInt(param, "AccessRewardLV", accessRewardSkillLV);
    ParseInt(param, "AccessBtnActive", accessBtnActive);
    ParseInt(param, "HuntRewardType", HuntRewardType);
    ParseInt(param, "HuntBonusMax", huntBonusMax);
    ParseInt(param, "HuntBonusCurr", huntBonusCurr);
    ParseInt(param, "HuntRewardID", huntRewardID);
    ParseInt(param, "HuntRewardLV", huntRewardLV);
    ParseInt(param, "HuntBtnActive", huntBtnActive);
    JoinYesterdayBonus_Item_ItemWnd.Clear();
    JoinYesterdayBonus_Item_ItemWnd.ClearTooltip();
    JoinYesterdayBonus_Item_ItemWnd.SetTooltipType("");
    // End:0x276
    if(accessRewardID > 0)
    {
        // End:0x234
        if(AccessRewardType == 1)
        {
            Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(accessRewardID), accessBonusItemInfo);
            JoinYesterdayBonus_Item_ItemWnd.AddItem(accessBonusItemInfo);
            JoinYesterdayBonus_Item_ItemWnd.SetTooltipType("Inventory");            
        }
        else
        {
            GetSkillInfo(accessRewardID, 1, 0, accessBonusSkillInfo);
            JoinYesterdayBonus_Item_ItemWnd.AddItem(getItemInfoBySkillInfo(accessBonusSkillInfo));
            JoinYesterdayBonus_Item_ItemWnd.SetTooltipType("Skill");
        }
    }
    GetTextBoxHandle(JoinWndPath $ ".JoinBonus_MemberCount1_Text").SetText(string(accessBonusCurr));
    GetTextBoxHandle(JoinWndPath $ ".JoinBonus_MemberCount2_Text").SetText("/" $ string(accessBonusMax));
    // End:0x410
    if(accessRewardID > 0)
    {
        // End:0x387
        if(AccessRewardType == 1)
        {
            GetTextBoxHandle(JoinWndPath $ ".JoinYesterdayBonusLV_Text").SetText("");
            GetNameCtrlHandle(JoinWndPath $ ".JoinYesterdaydayBonusName_Text").SetName(accessBonusItemInfo.Name, 0, 1);            
        }
        else
        {
            GetTextBoxHandle(JoinWndPath $ ".JoinYesterdayBonusLV_Text").SetText("Lv" $ string(accessRewardSkillLV));
            GetNameCtrlHandle(JoinWndPath $ ".JoinYesterdaydayBonusName_Text").SetName(accessBonusSkillInfo.SkillName, 0, 1);
        }        
    }
    else
    {
        GetTextBoxHandle(JoinWndPath $ ".JoinYesterdayBonusLV_Text").SetText("");
        GetNameCtrlHandle(JoinWndPath $ ".JoinYesterdaydayBonusName_Text").SetName(GetSystemString(5852), 0, 1);
    }
    setStateProgress(0, accessBonusMax, accessBonusCurr);
    HuntYesterdayBonus_Item_ItemWnd.Clear();
    HuntYesterdayBonus_Item_ItemWnd.ClearTooltip();
    HuntYesterdayBonus_Item_ItemWnd.SetTooltipType("");
    // End:0x574
    if(huntRewardID > 0)
    {
        // End:0x532
        if(HuntRewardType == 1)
        {
            Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(huntRewardID), huntRewardItemInfo);
            HuntYesterdayBonus_Item_ItemWnd.AddItem(huntRewardItemInfo);
            HuntYesterdayBonus_Item_ItemWnd.SetTooltipType("Inventory");            
        }
        else
        {
            GetSkillInfo(huntRewardID, 1, 0, huntRewardSkillInfo);
            HuntYesterdayBonus_Item_ItemWnd.AddItem(getItemInfoBySkillInfo(huntRewardSkillInfo));
            HuntYesterdayBonus_Item_ItemWnd.SetTooltipType("Skill");
        }
    }
    GetTextBoxHandle(HuntWndPath $ ".HuntBonus_MemberCount1_Text").SetText(string(huntBonusCurr));
    GetTextBoxHandle(HuntWndPath $ ".HuntBonus_MemberCount2_Text").SetText("/" $ string(huntBonusMax));
    // End:0x688
    if(huntRewardLV > 0)
    {
        GetTextBoxHandle(HuntWndPath $ ".HuntYesterdaydayBonusLV_Text").SetText("Lv" $ string(huntRewardLV));
        GetNameCtrlHandle(HuntWndPath $ ".HuntYesterdaydayBonusName_Text").SetName(huntRewardItemInfo.Name, 0, 1);        
    }
    else
    {
        GetTextBoxHandle(HuntWndPath $ ".HuntYesterdaydayBonusLV_Text").SetText("");
        GetNameCtrlHandle(HuntWndPath $ ".HuntYesterdaydayBonusName_Text").SetName(GetSystemString(5852), 0, 1);
    }
    setStateProgress(1, huntBonusMax, huntBonusCurr);
    // End:0x74F
    if(accessBtnActive > 0)
    {
        GetButtonHandle(JoinWndPath $ ".Clan1_ManageBtn").EnableWindow();        
    }
    else
    {
        GetButtonHandle(JoinWndPath $ ".Clan1_ManageBtn").DisableWindow();
    }
    // End:0x7AF
    if(huntBtnActive > 0)
    {
        GetButtonHandle(HuntWndPath $ ".Clan2_ManageBtn").EnableWindow();        
    }
    else
    {
        GetButtonHandle(HuntWndPath $ ".Clan2_ManageBtn").DisableWindow();
    }
    return;
}

function setStateProgress(int bonusType, int nMax, int nCur)
{
    local string taretPath, arrowTexture, stateWnd;
    local float maxStep, fProgressStep;
    local int nLevel, nProgress;
    local float fProgress;
    local int i, N;

    // End:0x2D
    if(bonusType == 0)
    {
        stateWnd = JoinWndPath;
        arrowTexture = ".PledgeArrow";        
    }
    else
    {
        stateWnd = HuntWndPath;
        arrowTexture = ".HuntArrow";
    }
    maxStep = float(nMax) / float(4);
    nLevel = int(float(nCur) / maxStep) + 1;
    fProgressStep = maxStep / float(3);
    fProgress = (float(nCur) % maxStep) / fProgressStep;
    nProgress = appCeil(fProgress);
    i = 1;
    J0xBA:

    // End:0x2F2 [Loop If]
    if(i < 5)
    {
        N = 1;
        J0xCD:

        // End:0x23E [Loop If]
        if(N < 4)
        {
            taretPath = ((((stateWnd $ arrowTexture) $ string(i)) $ "_") $ string(N)) $ "_disable_Texture";
            // End:0x16B
            if((i == nLevel) && N < nProgress)
            {
                GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_normal");
                // [Explicit Continue]
                goto J0x234;
            }
            // End:0x1AF
            if(i < nLevel)
            {
                GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_normal");
                // [Explicit Continue]
                goto J0x234;
            }
            // End:0x201
            if((i == nLevel) && N == nProgress)
            {
                GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_get");
                // [Explicit Continue]
                goto J0x234;
            }
            GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_disable");
            J0x234:

            N++;
            // [Loop Continue]
            goto J0xCD;
        }
        taretPath = (((stateWnd $ ".") $ "PledgeSelectPanel0") $ string(i)) $ "_ani";
        GetAnimTextureHandle(taretPath).Stop();
        GetAnimTextureHandle(taretPath).Pause();
        GetAnimTextureHandle(taretPath).HideWindow();
        // End:0x2D7
        if(nLevel > i)
        {
            setEnablePledgeBonus(bonusType, i, true);
            // [Explicit Continue]
            goto J0x2E8;
        }
        setEnablePledgeBonus(bonusType, i, false);
        J0x2E8:

        i++;
        // [Loop Continue]
        goto J0xBA;
    }
    // End:0x37B
    if(nLevel > 1)
    {
        taretPath = (((stateWnd $ ".") $ "PledgeSelectPanel0") $ string(nLevel - 1)) $ "_ani";
        GetAnimTextureHandle(taretPath).SetLoopCount(9999999);
        GetAnimTextureHandle(taretPath).ShowWindow();
        GetAnimTextureHandle(taretPath).Play();
    }
    // End:0x395
    if(nCur > 0)
    {
        setEnableFlagTexture(bonusType, true);        
    }
    else
    {
        setEnableFlagTexture(bonusType, false);
    }
    return;
}

function setEnableFlagTexture(int bonusType, bool bFlag)
{
    local string stateWnd;

    // End:0x19
    if(bonusType == 0)
    {
        stateWnd = JoinWndPath;        
    }
    else
    {
        stateWnd = HuntWndPath;
    }
    // End:0x7B
    if(bFlag)
    {
        GetTextureHandle(stateWnd $ ".PledgeflagIcon2_texture").SetTexture("L2UI_CT1.PledgeflagIcon3");        
    }
    else
    {
        GetTextureHandle(stateWnd $ ".PledgeflagIcon2_texture").SetTexture("L2UI_CT1.PledgeflagIcon2");
    }
    return;
}

function bool hasPoint(float Num)
{
    local string temp;
    local array<string> Result;

    temp = string(Num);
    Split(temp, ".", Result);
    return int(Result[1]) > 0;
    return;
}

function addItemSlot(ItemWindowHandle ItemWnd, ItemInfo pIteminfo)
{
    ItemWnd.Clear();
    ItemWnd.AddItem(pIteminfo);
    return;
}

function PledgeBonusListHandler(string param)
{
    local int accessReward, huntReward;
    local SkillInfo mSkillInfo, tempSkillInfo;
    local ItemInfo mItemInfo, tempItemInfo;
    local int i, accessType, huntType;

    ParseInt(param, "AccessType", accessType);
    ParseInt(param, "HuntType", huntType);
    hasPledgeBonusList = true;
    i = 1;
    J0x45:

    // End:0x4C5 [Loop If]
    if(i < 5)
    {
        ParseInt(param, "AccessReward" $ string(i), accessReward);
        ParseInt(param, "HuntReward" $ string(i), huntReward);
        GetItemWindowHandle(((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin").Clear();
        GetItemWindowHandle(((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin").ClearTooltip();
        GetItemWindowHandle(((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin").SetTooltipType("");
        GetItemWindowHandle(((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin").Clear();
        GetItemWindowHandle(((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin").ClearTooltip();
        GetItemWindowHandle(((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin").SetTooltipType("");
        // End:0x2B0
        if(accessType == 1)
        {
            // End:0x2AD
            if(accessReward > 0)
            {
                mItemInfo = tempItemInfo;
                Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(accessReward), mItemInfo);
                addItemSlot(GetItemWindowHandle(((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin"), mItemInfo);
                GetItemWindowHandle(((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin").SetTooltipType("Inventory");
            }            
        }
        else
        {
            // End:0x356
            if(accessReward > 0)
            {
                mSkillInfo = tempSkillInfo;
                GetSkillInfo(accessReward, 1, 0, mSkillInfo);
                addItemSlot(GetItemWindowHandle(((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin"), getItemInfoBySkillInfo(mSkillInfo));
                GetItemWindowHandle(((JoinWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin").SetTooltipType("Skill");
            }
        }
        // End:0x415
        if(huntType == 1)
        {
            // End:0x412
            if(huntReward > 0)
            {
                mItemInfo = tempItemInfo;
                Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(huntReward), mItemInfo);
                addItemSlot(GetItemWindowHandle(((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin"), mItemInfo);
                GetItemWindowHandle(((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin").SetTooltipType("Inventory");
            }
            // [Explicit Continue]
            goto J0x4BB;
        }
        // End:0x4BB
        if(huntReward > 0)
        {
            mSkillInfo = tempSkillInfo;
            GetSkillInfo(huntReward, 1, 0, mSkillInfo);
            addItemSlot(GetItemWindowHandle(((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin"), getItemInfoBySkillInfo(mSkillInfo));
            GetItemWindowHandle(((HuntWndPath $ ".BonusItem") $ string(i)) $ "_ItemWin").SetTooltipType("Skill");
        }
        J0x4BB:

        i++;
        // [Loop Continue]
        goto J0x45;
    }
    return;
}

function setEnablePledgeBonus(int bonusType, int Index, bool bEnable)
{
    local ItemInfo Info;
    local string wndPath;

    // End:0x19
    if(bonusType == 0)
    {
        wndPath = JoinWndPath;        
    }
    else
    {
        wndPath = HuntWndPath;
    }
    // End:0x154
    if(GetItemWindowHandle(((wndPath $ ".BonusItem") $ string(Index)) $ "_ItemWin").GetItemNum() > 0)
    {
        GetItemWindowHandle(((wndPath $ ".BonusItem") $ string(Index)) $ "_ItemWin").GetItem(0, Info);
        GetItemWindowHandle(((wndPath $ ".BonusItem") $ string(Index)) $ "_ItemWin").Clear();
        // End:0xF1
        if(bEnable)
        {
            Info.ForeTexture = "";            
        }
        else
        {
            Info.ForeTexture = "L2UI_CT1.WindowDisable_BG";
        }
        GetItemWindowHandle(((wndPath $ ".BonusItem") $ string(Index)) $ "_ItemWin").AddItem(Info);
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x25
        case "FrameCloseButton":
            OnFrameCloseButtonClick();
            // End:0xC4
            break;
        // End:0x43
        case "FrameResetButton":
            OnFrameResetButtonClick();
            // End:0xC4
            break;
        // End:0x50
        case "CloseBtn":
        // End:0x6F
        case "ClanRaid_CloseBtn":
            OnCloseBtnClick();
            // End:0xC4
            break;
        // End:0x8C
        case "Clan1_ManageBtn":
            OnClan1_ManageBtnClick();
            // End:0xC4
            break;
        // End:0xA9
        case "Clan2_ManageBtn":
            OnClan2_ManageBtnClick();
            // End:0xC4
            break;
        // End:0xC1
        case "HelpButton":
            OnHelpBtnClick();
            // End:0xC4
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnHelpBtnClick()
{
    local string strParam;

    ParamAdd(strParam, "FilePath", "..\\L2text\\Pledge_help001.htm");
    ExecuteEvent(1210, strParam);
    return;
}

function OnFrameCloseButtonClick()
{
    Me.HideWindow();
    return;
}

function OnFrameResetButtonClick()
{
    PledgeBonusOpen();
    return;
}

function OnCloseBtnClick()
{
    Me.HideWindow();
    return;
}

function OnClan1_ManageBtnClick()
{
    PlaySound("ItemSound3.sys_bonus_login");
    PledgeBonusReward(0);
    return;
}

function OnClan2_ManageBtnClick()
{
    PlaySound("ItemSound3.sys_bonus_hunt");
    PledgeBonusReward(1);
    return;
}

function bool getHasPledgeBonusList()
{
    return hasPledgeBonusList;
    return;
}

function setRaidSkill(int Index, int SkillID, int SkillLevel, int lastRaidPhase)
{
    local string WindowName;
    local SkillInfo SkillInfo;
    local ItemInfo Info;
    local ItemID cID;
    local int activeLevel, levelGap;

    // End:0x1D
    if(!GetSkillInfo(SkillID, SkillLevel, 0, SkillInfo))
    {
        return;
    }
    WindowName = (((((m_WindowName $ ".") $ m_ClanPledgeRaidWindowName) $ ".") $ "Stage0") $ string(Index)) $ "_Window";
    cID.ClassID = SkillID;
    Info.Id = cID;
    Info.Level = SkillLevel;
    Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Info.Id, Info.Level, 0);
    Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, 0);
    Info.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Info.Id, Info.Level, 0);
    Info.AdditionalName = Class'NWindow.UIDATA_SKILL'.static.GetEnchantName(Info.Id, Info.Level, 0);
    activeLevel = (Index + 1) * 5;
    GetTextBoxHandle(WindowName $ ".StageLvNum_text").SetText(string(activeLevel));
    GetTextBoxHandle(WindowName $ ".Skill_Name_text").SetText(Info.Name);
    GetTextBoxHandle(WindowName $ ".Skill_LvNum_text").SetText(string(SkillLevel));
    GetWindowHandle(WindowName).SetTooltipType("text");
    levelGap = lastRaidPhase - activeLevel;
    // End:0x33F
    if(levelGap >= 5)
    {
        GetTextureHandle(WindowName $ ".FlagComplete_Icon").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeFlagCompleteIcon");
        GetTextureHandle(WindowName $ ".StageComplete_Icon").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeStageComplete_Icon");
        GetTextureHandle(WindowName $ ".PledgeSelectPanel").SetTexture("L2UI_CT1.EmptyBtn");
        GetWindowHandle(WindowName).SetTooltipText("");
        Info.bDisabled = 0;        
    }
    else
    {
        // End:0x48C
        if(levelGap >= 0)
        {
            GetTextureHandle(WindowName $ ".FlagComplete_Icon").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeFlagProcessingIcon");
            GetTextureHandle(WindowName $ ".StageComplete_Icon").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeStageProcessing_Icon");
            GetTextureHandle(WindowName $ ".PledgeSelectPanel").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeSelectPanel");
            GetWindowHandle(WindowName).SetTooltipText(GetSystemString(3351));
            Info.bDisabled = 0;            
        }
        else
        {
            GetTextureHandle(WindowName $ ".FlagComplete_Icon").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeFlagLockIcon");
            GetTextureHandle(WindowName $ ".StageComplete_Icon").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeStageLock_Icon");
            GetTextureHandle(WindowName $ ".PledgeSelectPanel").SetTexture("L2UI_CT1.PledgeBonusWnd.PledgeCover");
            GetWindowHandle(WindowName).SetTooltipText(GetSystemString(2496));
        }
    }
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear(WindowName $ ".StageSkill_ItemWnd");
    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(WindowName $ ".StageSkill_ItemWnd", Info);
    return;
}

function handleSetRaidSkillInfos(string param)
{
    local int i, skillCount, SkillID, skillLv, lastRaidPhase;

    ParseInt(param, "SkillCount", skillCount);
    ParseInt(param, "LastRaidPhase", lastRaidPhase);
    i = 0;
    J0x42:

    // End:0xBB [Loop If]
    if(i < skillCount)
    {
        ParseInt(param, "SkillID_" $ string(i), SkillID);
        ParseInt(param, "SkillLV_" $ string(i), skillLv);
        setRaidSkill(i, SkillID, skillLv, lastRaidPhase);
        i++;
        // [Loop Continue]
        goto J0x42;
    }
    // End:0x10F
    if(lastRaidPhase == 0)
    {
        GetTextBoxHandle((((m_WindowName $ ".") $ m_ClanPledgeRaidWindowName) $ ".") $ "ClanRaidMyStage_Text").SetText(GetSystemString(27));        
    }
    else
    {
        GetTextBoxHandle((((m_WindowName $ ".") $ m_ClanPledgeRaidWindowName) $ ".") $ "ClanRaidMyStage_Text").SetText(GetSystemString(88) @ string(lastRaidPhase));
    }
    return;
}

function OnEvent(int a_EventID, string param)
{
    // End:0x17
    if(!getInstanceUIData().getIsClassicServer())
    {
        return;
    }
    switch(a_EventID)
    {
        // End:0x57
        case 20190:
            // End:0x49
            if(!Me.IsShowWindow())
            {
                Me.ShowWindow();
            }
            PledgeBonusOpenHandler(param);
            // End:0xFF
            break;
        // End:0x8F
        case 20191:
            Debug("EV_PledgeBonusList " @ param);
            PledgeBonusListHandler(param);
            // End:0xFF
            break;
        // End:0xB1
        case 20192:
            hasPledgeBonusList = false;
            Me.HideWindow();
            // End:0xFF
            break;
        // End:0xC7
        case 20193:
            PlegeBonusUpdate(param);
            // End:0xFF
            break;
        // End:0xE6
        case 40:
            hasPledgeBonusList = false;
            Me.HideWindow();
            // End:0xFF
            break;
        // End:0xFC
        case 20194:
            handleSetRaidSkillInfos(param);
            // End:0xFF
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="ClanPledgeBonusDrawerWndClassic"
    m_ClanPledgeRaidWindowName="ClanPledgeRaid_Window"
}