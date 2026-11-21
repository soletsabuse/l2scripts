class ClanPledgeBonusDrawerWnd extends UICommonAPI;

const ACCESS_TYPE = 0;
const HUNT_TYPE = 1;

var WindowHandle Me;
var ItemWindowHandle JoinYesterdayBonus_Item_ItemWnd;
var ItemWindowHandle HuntYesterdayBonus_Item_ItemWnd;
var string JoinWndPath;
var string HuntWndPath;
var bool hasPledgeBonusList;
var string m_WindowName;
var int accessBonusMax;
var int huntBonusMax;

function OnRegisterEvent()
{
    RegisterEvent(20190);
    RegisterEvent(20191);
    RegisterEvent(20193);
    RegisterEvent(20192);
    RegisterEvent(40);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function Initialize()
{
    JoinWndPath = m_WindowName $ ".JoinBonusWnd";
    HuntWndPath = m_WindowName $ ".HuntBonusWnd";
    Me = GetWindowHandle(m_WindowName);
    JoinYesterdayBonus_Item_ItemWnd = GetItemWindowHandle(m_WindowName $ ".JoinBonusWnd.JoinYesterdayBonus_Item_ItemWnd");
    HuntYesterdayBonus_Item_ItemWnd = GetItemWindowHandle(m_WindowName $ ".HuntBonusWnd.HuntYesterdayBonus_Item_ItemWnd");
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

function OnEvent(int a_EventID, string param)
{
    // End:0x15
    if(getInstanceUIData().getIsClassicServer())
    {
        return;
    }
    switch(a_EventID)
    {
        // End:0x55
        case 20190:
            // End:0x47
            if(!Me.IsShowWindow())
            {
                Me.ShowWindow();
            }
            PledgeBonusOpenHandler(param);
            // End:0xC8
            break;
        // End:0x6B
        case 20191:
            PledgeBonusListHandler(param);
            // End:0xC8
            break;
        // End:0x8D
        case 20192:
            hasPledgeBonusList = false;
            Me.HideWindow();
            // End:0xC8
            break;
        // End:0xA3
        case 20193:
            PlegeBonusUpdate(param);
            // End:0xC8
            break;
        // End:0xC2
        case 40:
            hasPledgeBonusList = false;
            Me.HideWindow();
            // End:0xC8
            break;
        // End:0xFFFF
        default:
            // End:0xC8
            break;
            break;
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
    ParseInt(param, "AccessBonusMax", AccessRewardType);
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
    // End:0x274
    if(accessRewardID > 0)
    {
        // End:0x232
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
    // End:0x40E
    if(accessRewardID > 0)
    {
        // End:0x385
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
    // End:0x572
    if(huntRewardID > 0)
    {
        // End:0x530
        if(AccessRewardType == 1)
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
    // End:0x686
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
    // End:0x74D
    if(accessBtnActive > 0)
    {
        GetButtonHandle(JoinWndPath $ ".Clan1_ManageBtn").EnableWindow();        
    }
    else
    {
        GetButtonHandle(JoinWndPath $ ".Clan1_ManageBtn").DisableWindow();
    }
    // End:0x7AD
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
    local float maxStep;
    local int nProgressStep;
    local float fProgressStep;
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
    maxStep = float(nMax / 4);
    nLevel = int((float(nCur) / maxStep) + float(1));
    nProgressStep = int(maxStep / float(3));
    fProgressStep = maxStep / float(3);
    fProgress = (float(nCur) % maxStep) / fProgressStep;
    nProgress = appCeil(fProgress);
    i = 1;
    J0xCD:

    // End:0x305 [Loop If]
    if(i < 5)
    {
        N = 1;
        J0xE0:

        // End:0x251 [Loop If]
        if(N < 4)
        {
            taretPath = ((((stateWnd $ arrowTexture) $ string(i)) $ "_") $ string(N)) $ "_disable_Texture";
            // End:0x17E
            if((i == nLevel) && N < nProgress)
            {
                GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_normal");
                // [Explicit Continue]
                goto J0x247;
            }
            // End:0x1C2
            if(i < nLevel)
            {
                GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_normal");
                // [Explicit Continue]
                goto J0x247;
            }
            // End:0x214
            if((i == nLevel) && N == nProgress)
            {
                GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_get");
                // [Explicit Continue]
                goto J0x247;
            }
            GetTextureHandle(taretPath).SetTexture("l2ui_ct1.PledgeArrow_disable");
            J0x247:

            N++;
            // [Loop Continue]
            goto J0xE0;
        }
        taretPath = (((stateWnd $ ".") $ "PledgeSelectPanel0") $ string(i)) $ "_ani";
        GetAnimTextureHandle(taretPath).Stop();
        GetAnimTextureHandle(taretPath).Pause();
        GetAnimTextureHandle(taretPath).HideWindow();
        // End:0x2EA
        if(nLevel > i)
        {
            setEnablePledgeBonus(bonusType, i, true);
            // [Explicit Continue]
            goto J0x2FB;
        }
        setEnablePledgeBonus(bonusType, i, false);
        J0x2FB:

        i++;
        // [Loop Continue]
        goto J0xCD;
    }
    // End:0x38E
    if(nLevel > 1)
    {
        taretPath = (((stateWnd $ ".") $ "PledgeSelectPanel0") $ string(nLevel - 1)) $ "_ani";
        GetAnimTextureHandle(taretPath).SetLoopCount(9999999);
        GetAnimTextureHandle(taretPath).ShowWindow();
        GetAnimTextureHandle(taretPath).Play();
    }
    // End:0x3A8
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
            // End:0xB1
            break;
        // End:0x43
        case "FrameResetButton":
            OnFrameResetButtonClick();
            // End:0xB1
            break;
        // End:0x59
        case "CloseBtn":
            OnCloseBtnClick();
            // End:0xB1
            break;
        // End:0x76
        case "Clan1_ManageBtn":
            OnClan1_ManageBtnClick();
            // End:0xB1
            break;
        // End:0x93
        case "Clan2_ManageBtn":
            OnClan2_ManageBtnClick();
            // End:0xB1
            break;
        // End:0xAB
        case "HelpButton":
            OnHelpBtnClick();
            // End:0xB1
            break;
        // End:0xFFFF
        default:
            // End:0xB1
            break;
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

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="ClanPledgeBonusDrawerWnd"
}