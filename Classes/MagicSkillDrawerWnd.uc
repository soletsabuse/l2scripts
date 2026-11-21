class MagicSkillDrawerWnd extends UICommonAPI;

const MIN_ENCHANT_LEVEL = 1;
const MAX_ENCHANT_LEVEL = 30;
const SKILL_ENCHANT_NUM = 9;
const ENCHANT_TYPE_NUM = 3;
const ENCHANT_START = -1;
const ENCHANT_NORMAL = 0;
const ENCHANT_SAFETY = 1;
const ENCHANT_UNTRAIN = 2;
const ENCHANT_ROUTE_CHANGE = 3;
const ENCHANT_PASS_TICKET = 4;
const ENCHANT_MATERIAL_NUM = 3;
const DIALOGID_ResearchClick = 0;
const ENCHANT_TYPE_UINT = 1000;

var Color White;
var string m_WindowName;
var WindowHandle Me;
var WindowHandle MagicskillGuideWnd;
var TextureHandle ResearchSkill;
var ItemWindowHandle ResearchSkillIcon;
var TextureHandle ResearchSkillIconSlotBg;
var TextBoxHandle ResearchSkillTitle;
var NameCtrlHandle ResearchSkillName;
var TextBoxHandle ResearchSkillDesc;
var TextBoxHandle ResearchSkillLv;
var ItemWindowHandle ExpectationSkillIcon;
var TextureHandle ExpectationSkillIconSlotBg;
var TextBoxHandle ExpectationSkillTitle;
var TextBoxHandle ExpectationSkillRoot;
var TextBoxHandle ExpectationSkillDesc;
var TextBoxHandle SucessProbablity;
var ItemWindowHandle ResearchRootIcon[9];
var ButtonHandle ResearchRootBTN[9];
var TextBoxHandle ResearchRootText[9];
var TextBoxHandle ResearchRootText2[9];
var int ResearchRootID[9];
var int ResearchRootSubLevel[9];
var string ResearchRootSkillIconName[9];
var string ResearchRootSkillName[9];
var TextBoxHandle ResearchRootTitle;
var TextureHandle ResearchRootSlotBg;
var CheckBoxHandle enchatTypeRadioBtn[3];
var TextBoxHandle EnchantMaterialTitle;
var TextBoxHandle EnchantMaterialName;
var TextBoxHandle EnchantMaterialInfo[3];
var TextBoxHandle EnchantMaterialInfo2;
var ItemWindowHandle EnchantMaterialIcon;
var TextureHandle EnchantMaterialIconBg;
var TextBoxHandle ResearchGuideTitle;
var TextBoxHandle ResearchGuideDesc;
var CharacterViewportWindowHandle ObjectViewport;
var ButtonHandle btnGuide;
var ButtonHandle btnResearch;
var ButtonHandle btnClose;
var TextureHandle ResearchSkillBg;
var TextureHandle ExpectationSkillBg;
var TextureHandle ResearchRootBg;
var TextureHandle ResearchMaterialIconBg;
var TextureHandle ResearchGuideBg;
var TextBoxHandle txtMySpStr;
var TextBoxHandle txtMySp;
var TextureHandle MyAdenaIcon;
var TextBoxHandle txtMyAdenaStr;
var TextBoxHandle txtMyAdena;
var AnimTextureHandle EnchantProgressAnim;
var int curEnchantType;
var int EnchantState;
var TextureHandle ResearchRoot_Select_1_0Y;
var TextureHandle ResearchRoot_Select_1_0B;
var int enableTrain;
var TextureHandle ResearchSkillSelectbox;
var TextureHandle ResearchRootSelectbox;
var int curSkillID;
var int curLevel;
var int curSubLevel;
var int curWantedSkillID;
var int curWantedSubLevel;
var int curIndex;
var INT64 needSPConsume;
var INT64 needAdena;
var bool isHiding;

function setMagicSkillItemsType(bool isOn)
{
    local MagicSkillWnd script_a;
    local int i;

    script_a = MagicSkillWnd(GetScript("MagicSkillWnd"));
    i = 0;
    J0x27:

    // End:0x92 [Loop If]
    if(i < script_a.8)
    {
        // End:0x68
        if(isOn)
        {
            script_a.m_Item[i].SetIconDrawType(1);
            // [Explicit Continue]
            goto J0x88;
        }
        script_a.m_Item[i].SetIconDrawType(0);
        J0x88:

        i++;
        // [Loop Continue]
        goto J0x27;
    }
    return;
}

function OnLoad()
{
    White.R = 250;
    White.G = 250;
    White.B = 250;
    White.A = byte(255);
    Initialize();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(2064);
    RegisterEvent(2065);
    RegisterEvent(2067);
    RegisterEvent(4600);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(180);
    RegisterEvent(2610);
    RegisterEvent(2620);
    return;
}

function Initialize()
{
    local int i;

    Me = GetWindowHandle(m_WindowName);
    MagicskillGuideWnd = GetWindowHandle("MagicskillGuideWnd");
    ResearchSkill = GetTextureHandle(m_WindowName $ ".ResearchSkill");
    ResearchSkillIcon = GetItemWindowHandle(m_WindowName $ ".ResearchSkillWnd.ResearchSkillIcon");
    ResearchSkillIconSlotBg = GetTextureHandle(m_WindowName $ ".ResearchSkillWnd.ResearchSkillIconSlotBg");
    ResearchSkillTitle = GetTextBoxHandle(m_WindowName $ ".ResearchSkillWnd.ResearchSkillTitle");
    ResearchSkillName = GetNameCtrlHandle(m_WindowName $ ".ResearchSkillWnd.ResearchSkillName");
    ResearchSkillDesc = GetTextBoxHandle(m_WindowName $ ".ResearchSkillWnd.ResearchSkillDesc");
    ResearchSkillLv = GetTextBoxHandle(m_WindowName $ ".ResearchSkillWnd.ResearchSkillLv");
    ExpectationSkillIcon = GetItemWindowHandle(m_WindowName $ ".ResearchSkillWnd.ExpectationSkillIcon");
    ExpectationSkillIconSlotBg = GetTextureHandle(m_WindowName $ ".ResearchSkillWnd.ExpectationSkillIconSlotBg");
    ExpectationSkillTitle = GetTextBoxHandle(m_WindowName $ ".ResearchSkillWnd.ExpectationSkillTitle");
    ExpectationSkillRoot = GetTextBoxHandle(m_WindowName $ ".ResearchSkillWnd.ExpectationSkillRoot");
    ExpectationSkillDesc = GetTextBoxHandle(m_WindowName $ ".ResearchSkillWnd.ExpectationSkillDesc");
    SucessProbablity = GetTextBoxHandle(m_WindowName $ ".ResearchSkillWnd.SucessProbablity");
    i = 0;
    J0x315:

    // End:0x405 [Loop If]
    if(i < 9)
    {
        ResearchRootIcon[i] = GetItemWindowHandle((m_WindowName $ ".ResearchRootIcon_") $ string(i));
        ResearchRootBTN[i] = GetButtonHandle((m_WindowName $ ".ResearchRootBTN") $ string(i));
        ResearchRootText[i] = GetTextBoxHandle((m_WindowName $ ".ResearchRootText") $ string(i));
        ResearchRootText2[i] = GetTextBoxHandle(((m_WindowName $ ".ResearchRootText") $ string(i)) $ "_1");
        i++;
        // [Loop Continue]
        goto J0x315;
    }
    ResearchRoot_Select_1_0Y = GetTextureHandle(m_WindowName $ ".ResearchRoot_Select_1_0Y");
    ResearchRoot_Select_1_0B = GetTextureHandle(m_WindowName $ ".ResearchRoot_Select_1_0B");
    ResearchRootTitle = GetTextBoxHandle(m_WindowName $ ".ResearchRootTitle");
    ResearchRootSlotBg = GetTextureHandle(m_WindowName $ ".ResearchRootSlotBg");
    enchatTypeRadioBtn[0] = GetCheckBoxHandle(m_WindowName $ ".NormalEnchant");
    enchatTypeRadioBtn[1] = GetCheckBoxHandle(m_WindowName $ ".SafeEnchant");
    enchatTypeRadioBtn[2] = GetCheckBoxHandle(m_WindowName $ ".PassEnchant");
    EnchantMaterialTitle = GetTextBoxHandle(m_WindowName $ ".EnchantMaterialTitle");
    i = 0;
    J0x54D:

    // End:0x59C [Loop If]
    if(i < 3)
    {
        EnchantMaterialInfo[i] = GetTextBoxHandle((m_WindowName $ ".EnchantMaterialInfo_") $ string(i));
        i++;
        // [Loop Continue]
        goto J0x54D;
    }
    EnchantMaterialName = GetTextBoxHandle(m_WindowName $ ".EnchantMaterialName_0");
    EnchantMaterialIcon = GetItemWindowHandle(m_WindowName $ ".EnchantMaterialIcon_0");
    EnchantMaterialIconBg = GetTextureHandle(m_WindowName $ ".EnchantMaterialIconBg_0");
    EnchantMaterialInfo2 = GetTextBoxHandle(m_WindowName $ ".EnchantMaterialInfo2");
    ResearchGuideTitle = GetTextBoxHandle(m_WindowName $ ".ResearchGuideTitle");
    ResearchGuideDesc = GetTextBoxHandle(m_WindowName $ ".ResearchGuideDesc");
    ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".ObjectViewport");
    btnGuide = GetButtonHandle(m_WindowName $ ".btnGuide");
    btnResearch = GetButtonHandle(m_WindowName $ ".btnResearch");
    btnClose = GetButtonHandle(m_WindowName $ ".btnClose");
    ResearchSkillBg = GetTextureHandle(m_WindowName $ ".ResearchSkillBg");
    ExpectationSkillBg = GetTextureHandle(m_WindowName $ ".ExpectationSkillBg");
    ResearchRootBg = GetTextureHandle(m_WindowName $ ".ResearchRootBg");
    ResearchMaterialIconBg = GetTextureHandle(m_WindowName $ ".ResearchMaterialIconBg");
    ResearchGuideBg = GetTextureHandle(m_WindowName $ ".ResearchGuideBg");
    txtMySpStr = GetTextBoxHandle(m_WindowName $ ".txtMySpStr");
    txtMySp = GetTextBoxHandle(m_WindowName $ ".txtMySp");
    txtMyAdenaStr = GetTextBoxHandle(m_WindowName $ ".txtMyAdenaStr");
    txtMyAdena = GetTextBoxHandle(m_WindowName $ ".txtMyAdena");
    MyAdenaIcon = GetTextureHandle(m_WindowName $ ".MyAdenaIcon");
    EnchantProgressAnim = GetAnimTextureHandle(m_WindowName $ ".EnchantProgressAnim");
    ResearchSkillSelectbox = GetTextureHandle(m_WindowName $ ".ResearchSkillWnd.ResearchSkillSelectbox");
    ResearchRootSelectbox = GetTextureHandle(m_WindowName $ ".ResearchRootSelectbox");
    EnchantProgressAnim.HideWindow();
    setRadioTooltip(enchatTypeRadioBtn[0], 3357);
    setRadioTooltip(enchatTypeRadioBtn[1], 3358);
    setRadioTooltip(enchatTypeRadioBtn[2], 3359);
    enchatTypeRadioBtn[2].SetCheck(false);
    enchatTypeRadioBtn[2].HideWindow();
    return;
}

function setRadioTooltip(CheckBoxHandle radioBtn, int strNum)
{
    local CustomTooltip t;
    local L2Util util;

    t.MinimumWidth = 125;
    util = L2Util(GetScript("L2Util"));
    util.setCustomTooltip(t);
    util.ToopTipMinWidth(220);
    util.ToopTipInsertText(GetSystemString(strNum), false, true, util.0, 0, 0);
    radioBtn.SetTooltipCustomType(util.getCustomTooltip());
    return;
}

function OnDrawerShowFinished()
{
    isHiding = false;
    setMagicSkillItemsType(true);
    return;
}

function OnClickButton(string Name)
{
    local int rootID;

    // End:0x3D
    if(InStr(Name, "ResearchRootBTN") > -1)
    {
        rootID = int(Right(Name, 1));
        OnResearchRootBTNClick(rootID);
    }
    switch(Name)
    {
        // End:0x5A
        case "btnGuide":
            OnbtnGuideClick();
            // End:0x8F
            break;
        // End:0x73
        case "btnResearch":
            OnbtnResearchClick();
            // End:0x8F
            break;
        // End:0x89
        case "btnClose":
            OnBtnCloseClick();
            // End:0x8F
            break;
        // End:0xFFFF
        default:
            // End:0x8F
            break;
            break;
    }
    return;
}

function byRadioButton(string strID)
{
    local int checkNum;

    checkNum = -1;
    switch(strID)
    {
        // End:0x35
        case "NormalEnchant":
            EnchantState = 0;
            checkNum = 0;
            // End:0x7F
            break;
        // End:0x56
        case "SafeEnchant":
            EnchantState = 1;
            checkNum = 1;
            // End:0x7F
            break;
        // End:0x79
        case "PassEnchant":
            EnchantState = 4;
            checkNum = 2;
            // End:0x7F
            break;
        // End:0xFFFF
        default:
            // End:0x7F
            break;
            break;
    }
    enchatTypeRadioBtn[0].SetCheck(false);
    enchatTypeRadioBtn[1].SetCheck(false);
    enchatTypeRadioBtn[2].SetCheck(false);
    // End:0xDB
    if(checkNum != -1)
    {
        enchatTypeRadioBtn[checkNum].SetCheck(true);
    }
    return;
}

function setTextByEnchantType()
{
    local string btnResearchLabel, GuideDesc;

    btnResearch.EnableWindow();
    // End:0x49
    if(enchatTypeRadioBtn[2].IsChecked())
    {
        btnResearchLabel = GetSystemString(3112);
        GuideDesc = GetSystemString(3111);        
    }
    else
    {
        // End:0x82
        if(enchatTypeRadioBtn[1].IsChecked())
        {
            btnResearchLabel = GetSystemString(2069);
            GuideDesc = GetSystemString(2050);            
        }
        else
        {
            // End:0xBB
            if(enchatTypeRadioBtn[0].IsChecked())
            {
                btnResearchLabel = GetSystemString(2070);
                GuideDesc = GetSystemString(2051);                
            }
            else
            {
                // End:0x119
                if((enableTrain == 0) && (curSubLevel / 1000) == (curWantedSubLevel / 1000))
                {
                    btnResearchLabel = GetSystemString(2070);
                    GuideDesc = GetSystemString(3354);
                    btnResearch.DisableWindow();                    
                }
                else
                {
                    btnResearchLabel = GetSystemString(2068);
                    GuideDesc = GetSystemString(2052);
                }
            }
        }
    }
    btnResearch.SetNameText(btnResearchLabel);
    ResearchGuideDesc.SetText(GuideDesc);
    return;
}

function OnClickCheckBox(string strID)
{
    byRadioButton(strID);
    RequestExEnchantSkillInfoDetail(EnchantState, curWantedSkillID, curLevel, curWantedSubLevel);
    return;
}

function setRadioBtnsByEnchantStep()
{
    local bool canUseBtns;

    // End:0x91
    if((EnchantState == -1) && enableTrain == 1)
    {
        // End:0x46
        if(enchatTypeRadioBtn[1].IsChecked())
        {
            byRadioButton("SafeEnchant");            
        }
        else
        {
            // End:0x71
            if(enchatTypeRadioBtn[2].IsChecked())
            {
                byRadioButton("PassEnchant");                
            }
            else
            {
                byRadioButton("NormalEnchant");
            }
        }
        canUseBtns = true;        
    }
    else
    {
        // End:0xCD
        if((enableTrain == 0) && (curSubLevel / 1000) == (curWantedSubLevel / 1000))
        {
            EnchantState = 0;
            byRadioButton("");            
        }
        else
        {
            // End:0x10A
            if(((curSubLevel / 1000) != (curWantedSubLevel / 1000)) && curSubLevel > 0)
            {
                byRadioButton("");
                EnchantState = 3;                
            }
            else
            {
                // End:0x12B
                if(EnchantState == 3)
                {
                    byRadioButton("NormalEnchant");
                }
                canUseBtns = true;
            }
        }
    }
    // End:0x173
    if(canUseBtns)
    {
        enchatTypeRadioBtn[0].EnableWindow();
        enchatTypeRadioBtn[1].EnableWindow();
        enchatTypeRadioBtn[2].EnableWindow();        
    }
    else
    {
        enchatTypeRadioBtn[0].DisableWindow();
        enchatTypeRadioBtn[1].DisableWindow();
        enchatTypeRadioBtn[2].DisableWindow();
    }
    return;
}

function OnResearchRootBTNClick(int Index)
{
    local int infoID, infoSublevel;

    // End:0x1E
    if(curEnchantType == (ResearchRootSubLevel[Index] / 1000))
    {
        return;
    }
    // End:0x60
    if(((curSubLevel / 1000) == (ResearchRootSubLevel[Index] / 1000)) || curSubLevel == 0)
    {
        ResearchRoot_Select_1_0Y.HideWindow();        
    }
    else
    {
        ResearchRoot_Select_1_0Y.ShowWindow();
    }
    ResearchRoot_Select_1_0B.ClearAnchor();
    ResearchRoot_Select_1_0B.SetAnchor("MagicSkillDrawerWnd.ResearchRootBTN" $ string(Index), "TopLeft", "TopLeft", 0, 0);
    ResearchRoot_Select_1_0B.ShowWindow();
    infoSublevel = ResearchRootSubLevel[Index];
    infoID = ResearchRootID[Index];
    curWantedSkillID = infoID;
    curWantedSubLevel = infoSublevel;
    SucessProbablity.SetText("");
    SucessProbablity.HideWindow();
    setRadioBtnsByEnchantStep();
    RequestExEnchantSkillInfoDetail(EnchantState, curWantedSkillID, curLevel, curWantedSubLevel);
    return;
}

function OnbtnGuideClick()
{
    // End:0x24
    if(MagicskillGuideWnd.IsShowWindow())
    {
        MagicskillGuideWnd.HideWindow();        
    }
    else
    {
        MagicskillGuideWnd.ShowWindow();
        MagicskillGuideWnd.SetFocus();
    }
    return;
}

function OnbtnResearchClick()
{
    btnResearch.DisableWindow();
    RequestExEnchantSkill(EnchantState, curWantedSkillID, curLevel, curWantedSubLevel);
    return;
}

function OnBtnCloseClick()
{
    local MagicSkillWnd script_a;

    script_a = MagicSkillWnd(GetScript("MagicSkillWnd"));
    script_a.RequestSkillList();
    Me.HideWindow();
    isHiding = true;
    setMagicSkillItemsType(false);
    SkillInfoClear();
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 2064:
            OnEVSkillEnchantInfoWndShow(param);
            // End:0xE2
            break;
        // End:0x33
        case 2065:
            OnEVSkillEnchantInfoWndAddSkill(param);
            // End:0xE2
            break;
        // End:0x49
        case 2067:
            OnEVSkillEnchantInfoWndAddExtendInfo(param);
            // End:0xE2
            break;
        // End:0x5F
        case 4600:
            OnEVSkillEnchantResult(param);
            // End:0xE2
            break;
        // End:0x70
        case 1710:
            HandleDialogOK();
            // End:0xE2
            break;
        // End:0x81
        case 1720:
            HandleDialogCancel();
            // End:0xE2
            break;
        // End:0xA5
        case 180:
            // End:0x9C
            if(!Me.IsShowWindow())
            {
                return;
            }
            SetSpInfo();
            // End:0xE2
            break;
        // End:0xAD
        case 2610:
        // End:0xDC
        case 2620:
            // End:0xCB
            if(!Me.IsShowWindow())
            {
                return;
            }
            SetAdenaInfo((GetAdena()));
            // End:0xE2
            break;
        // End:0xFFFF
        default:
            // End:0xE2
            break;
            break;
    }
    return;
}

function SetSpInfo()
{
    txtMySp.SetText(MakeCostString((GetuserSP())));
    txtMySp.SetTooltipString(ConvertNumToTextNoAdena((GetuserSP())));
    // End:0x74
    if(__NFUN_409__(needSPConsume, GetuserSP()))
    {
        ResearchGuideDesc.SetText(GetSystemString(3361));
        btnResearch.DisableWindow();
    }
    return;
}

function SetAdenaInfo(string Adena)
{
    txtMyAdena.SetText(MakeCostString(Adena));
    txtMyAdena.SetText(MakeCostString(Adena));
    txtMyAdena.SetTooltipString(ConvertNumToText(Adena));
    txtMyAdenaStr.SetText(GetSystemString(469));
    // End:0xA3
    if(__NFUN_409__(needAdena, (Adena)))
    {
        ResearchGuideDesc.SetText(GetSystemString(3361));
        btnResearch.DisableWindow();
    }
    return;
}

function HandleDialogOK()
{
    // End:0x0D
    if(!DialogIsMine())
    {
        return;
    }
    switch(DialogGetID())
    {
        // End:0x45
        case 0:
            btnResearch.DisableWindow();
            RequestExEnchantSkill(EnchantState, curWantedSkillID, curLevel, curWantedSubLevel);
            // End:0x4B
            break;
        // End:0xFFFF
        default:
            // End:0x4B
            break;
            break;
    }
    return;
}

function HandleDialogCancel()
{
    // End:0x0D
    if(!DialogIsMine())
    {
        return;
    }
    return;
}

function OnEVSkillEnchantInfoWndShow(string param)
{
    local int Count, SkillID, CurSkillLevel, CurSkillSubLevel;
    local ItemInfo Info;

    ParseInt(param, "EnableTrain", enableTrain);
    ParseInt(param, "Count", Count);
    ParseInt(param, "SkillID", SkillID);
    ParseInt(param, "CurSkillLevel", CurSkillLevel);
    ParseInt(param, "CurSkillSubLevel", CurSkillSubLevel);
    Info.Id.ClassID = curSkillID;
    Info.Level = CurSkillLevel;
    Info.SubLevel = CurSkillSubLevel;
    // End:0xF7
    if((IsShowWindow("MagicSkillWnd")) && !isHiding)
    {
        Me.ShowWindow();
    }
    SkillInfoClear();
    SetCurSkillInfo(Info);
    curSkillID = SkillID;
    curLevel = CurSkillLevel;
    curSubLevel = CurSkillSubLevel;
    // End:0x16E
    if(enableTrain == 0)
    {
        ResearchGuideDesc.SetText("");
        ResearchGuideDesc.SetText(GetSystemString(2041));
        SucessProbablity.HideWindow();
    }
    ResearchGuideDesc.SetText(GetSystemString(2043));
    Me.SetFocus();
    return;
}

function OnShow()
{
    SetAdenaSpInfo();
    return;
}

function SetAdenaSpInfo()
{
    SetSpInfo();
    SetAdenaInfo((GetAdena()));
    return;
}

function OnDrawerHideFinished()
{
    isHiding = false;
    OnTextureAnimEnd(EnchantProgressAnim);
    // End:0x36
    if(DialogIsMine())
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("DialogBox");
    }
    return;
}

function OnHide()
{
    // End:0x23
    if(DialogIsMine())
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("DialogBox");
    }
    return;
}

function SkillInfoClear()
{
    local int i;

    ResearchSkillIcon.Clear();
    ResearchSkillName.SetNameWithColor("", 0, 1, White);
    ResearchSkillDesc.SetText("");
    ResearchSkillLv.SetText("");
    ExpectationSkillIcon.Clear();
    ExpectationSkillRoot.SetText("");
    ExpectationSkillDesc.SetText("");
    SucessProbablity.SetText("");
    ResearchRoot_Select_1_0Y.HideWindow();
    ResearchRoot_Select_1_0B.HideWindow();
    i = 0;
    J0xB2:

    // End:0x13D [Loop If]
    if(i < 9)
    {
        ResearchRootIcon[i].Clear();
        ResearchRootBTN[i].DisableWindow();
        ResearchRootText[i].SetText("");
        ResearchRootText2[i].SetText("");
        ResearchRootBTN[i].SetTooltipCustomType(MakeTooltipSimpleText(""));
        i++;
        // [Loop Continue]
        goto J0xB2;
    }
    EnchantMaterialName.SetText("");
    EnchantMaterialIcon.Clear();
    i = 0;
    J0x164:

    // End:0x191 [Loop If]
    if(i < 3)
    {
        EnchantMaterialInfo[i].SetText("");
        i++;
        // [Loop Continue]
        goto J0x164;
    }
    EnchantMaterialInfo2.SetText("");
    ResearchRoot_Select_1_0B.HideWindow();
    ResearchGuideDesc.SetText((GetSystemString(2048) $ "\\n") $ GetSystemString(2049));
    btnResearch.SetNameText(GetSystemString(2070));
    btnResearch.DisableWindow();
    enchatTypeRadioBtn[0].DisableWindow();
    enchatTypeRadioBtn[1].DisableWindow();
    enchatTypeRadioBtn[2].DisableWindow();
    curSkillID = 0;
    curLevel = 0;
    curSubLevel = 0;
    curWantedSkillID = 0;
    curWantedSubLevel = 0;
    curIndex = -1;
    EnchantState = -1;
    curEnchantType = -1;
    ResearchRootSelectbox.HideWindow();
    ResearchSkillSelectbox.ShowWindow();
    return;
}

function string getEnchantSkillName(ItemID ItemID, int iLevel, int iSubLevel)
{
    local string enchantSkillName;
    local int iLength;

    enchantSkillName = Class'NWindow.UIDATA_SKILL'.static.GetEnchantName(ItemID, iLevel, ((iSubLevel / 1000) * 1000) + 1);
    iLength = Len(enchantSkillName) - 3;
    // End:0x63
    if(iLength > 0)
    {
        enchantSkillName = Right(enchantSkillName, iLength);
    }
    return enchantSkillName;
    return;
}

function setBTNTooltip(int Index, ItemID ItemID, int iLevel, int iSubLevel)
{
    local CustomTooltip t;
    local L2Util util;
    local string strSkillName;
    local SkillInfo SkillInfo;
    local string changeTitle;

    t.MinimumWidth = 125;
    util = L2Util(GetScript("L2Util"));
    util.setCustomTooltip(t);
    util.ToopTipMinWidth(200);
    // End:0x13A
    if(curSubLevel > 0)
    {
        GetSkillInfo(curSkillID, curLevel, curSubLevel, SkillInfo);
        strSkillName = Class'NWindow.UIDATA_SKILL'.static.GetEnchantName(ItemID, curLevel, curSubLevel);
        util.ToopTipInsertText(GetSystemString(3352), false, true, util.3, 0, 0);
        util.ToopTipInsertText(strSkillName, false, true, util.0, 0, 6);
        util.ToopTipInsertText(SkillInfo.EnchantDesc, false, true, util.0, 0, 0);
        util.TooltipInsertItemBlank(6);
        util.TooltipInsertItemLine();
        util.TooltipInsertItemBlank(3);
    }
    // End:0x175
    if(curSubLevel == iSubLevel)
    {
        util.ToopTipInsertText(GetSystemString(3356), false, true, util.0, 0, 0);        
    }
    else
    {
        // End:0x1B3
        if(((iSubLevel / 1000) == (curSubLevel / 1000)) || curSubLevel == 0)
        {
            changeTitle = GetSystemString(3353);            
        }
        else
        {
            changeTitle = GetSystemString(3360);
        }
        GetSkillInfo(curSkillID, curLevel, iSubLevel, SkillInfo);
        strSkillName = Class'NWindow.UIDATA_SKILL'.static.GetEnchantName(ItemID, iLevel, iSubLevel);
        util.ToopTipInsertText(changeTitle, false, true, util.6, 0, 0);
        util.ToopTipInsertText(strSkillName, false, true, util.0, 0, 0);
        util.ToopTipInsertText(SkillInfo.EnchantDesc, false, true, util.0, 0, 0);
    }
    ResearchRootBTN[Index].SetTooltipCustomType(util.getCustomTooltip());
    return;
}

function OnEVSkillEnchantInfoWndAddSkill(string param)
{
    local int iID;
    local ItemID ItemID;
    local int iLevel, iSubLevel;
    local string strSkillIconName, strSkillName;
    local ItemInfo Info;
    local int Index;

    ParseInt(param, "iID", iID);
    ParseInt(param, "iLevel", iLevel);
    ParseInt(param, "iSubLevel", iSubLevel);
    ParseString(param, "strSkillIconName", strSkillIconName);
    ParseString(param, "strSkillName", strSkillName);
    ItemID.ClassID = iID;
    strSkillIconName = Class'NWindow.UIDATA_SKILL'.static.GetEnchantIcon(ItemID, iLevel, iSubLevel);
    strSkillName = Class'NWindow.UIDATA_SKILL'.static.GetEnchantName(ItemID, iLevel, iSubLevel);
    curIndex++;
    // End:0xF5
    if(curIndex >= 9)
    {
        return;
    }
    Index = curIndex;
    ResearchRootID[Index] = iID;
    ResearchRootSubLevel[Index] = iSubLevel;
    ResearchRootSkillIconName[Index] = "l2ui_ct1.SkillWnd_DF_Icon_Enchant_" $ strSkillIconName;
    ResearchRootSkillName[Index] = strSkillName;
    Info.IconName = ResearchRootSkillIconName[Index];
    ResearchRootIcon[Index].Clear();
    ResearchRootIcon[Index].AddItem(Info);
    ResearchRootText[Index].SetText(makeShortStringByPixel(getEnchantSkillName(ItemID, iLevel, iSubLevel), 144, ".."));
    SucessProbablity.HideWindow();
    setBTNTooltip(Index, ItemID, iLevel, iSubLevel);
    // End:0x32B
    if((curSubLevel / 1000) == (iSubLevel / 1000))
    {
        ResearchRoot_Select_1_0Y.ClearAnchor();
        ResearchRoot_Select_1_0Y.SetAnchor("MagicSkillDrawerWnd.ResearchRootBTN" $ string(Index), "TopLeft", "TopLeft", 0, 0);
        ResearchRoot_Select_1_0Y.ShowWindow();
        ResearchRootText[Index].SetAnchor("MagicSkillDrawerWnd.ResearchRootBTN" $ string(Index), "TopLeft", "TopLeft", 44, 7);
        ResearchRootText2[Index].SetText(("(" $ GetSystemString(3351)) $ ")");
        OnResearchRootBTNClick(Index);        
    }
    else
    {
        ResearchRootText[Index].SetAnchor("MagicSkillDrawerWnd.ResearchRootBTN" $ string(Index), "TopLeft", "TopLeft", 44, 16);
    }
    ResearchRootBTN[Index].EnableWindow();
    return;
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
    EnchantProgressAnim.HideWindow();
    EnchantProgressAnim.Stop();
    EnchantProgressAnim.HideWindow();
    switch(a_WindowHandle)
    {
        // End:0x3F
        case EnchantProgressAnim:
            // End:0x45
            break;
        // End:0xFFFF
        default:
            // End:0x45
            break;
            break;
    }
    return;
}

function OnEVSkillEnchantResult(string param)
{
    local int iSuccess;

    ParseInt(param, "success", iSuccess);
    // End:0x13D
    if(iSuccess == 1)
    {
        EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
        EnchantProgressAnim.ShowWindow();
        EnchantProgressAnim.SetLoopCount(1);
        EnchantProgressAnim.Stop();
        EnchantProgressAnim.SetTimes(0.8000000);
        EnchantProgressAnim.Play();
        // End:0xEB
        if(getInstanceUIData().getIsArenaServer())
        {
            PlaySound("ItemSound3.arena_skill_powerup");            
        }
        else
        {
            PlaySound("ItemSound3.enchant_success");
        }
        ResearchGuideDesc.SetText((GetSystemString(2054) $ "\\n") $ GetSystemString(2055));        
    }
    else
    {
        EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
        EnchantProgressAnim.ShowWindow();
        EnchantProgressAnim.SetLoopCount(1);
        EnchantProgressAnim.Stop();
        EnchantProgressAnim.Play();
        PlaySound("ItemSound3.enchant_fail");
        ResearchGuideDesc.SetText((GetSystemString(2062) $ "\\n") $ GetSystemString(2063));
    }
    return;
}

function OnEVSkillEnchantInfoWndAddExtendInfo(string param)
{
    local int SkillID, Level, SubLevel;
    local INT64 spConsume;
    local int Percent, ItemClassID[2];
    local string strItemIconName[2], strItemName[2], strSkillIconName, strSkillName;
    local int ItemSort, ItemNum[2], i, adenaID, haguinID, haguinItemID;

    // End:0x11
    if(EnchantState == -1)
    {
        return;
    }
    ResearchRootSelectbox.HideWindow();
    ParseInt(param, "SkillID", SkillID);
    ParseInt(param, "Level", Level);
    ParseInt(param, "SubLevel", SubLevel);
    ParseInt(param, "Percent", Percent);
    ParseInt(param, "ItemSort", ItemSort);
    i = 0;
    J0xA4:

    // End:0x171 [Loop If]
    if(i < ItemSort)
    {
        ParseInt(param, "ItemClassID_" $ string(i), ItemClassID[i]);
        ParseString(param, "strItemIconName_" $ string(i), strItemIconName[i]);
        ParseString(param, "strItemName_" $ string(i), strItemName[i]);
        ParseInt(param, "ItemNum_" $ string(i), ItemNum[i]);
        i++;
        // [Loop Continue]
        goto J0xA4;
    }
    // End:0x190
    if(ItemClassID[0] == 57)
    {
        adenaID = 0;
        haguinID = 1;        
    }
    else
    {
        adenaID = 1;
        haguinID = 0;
    }
    haguinItemID = ItemClassID[haguinID];
    ParseString(param, "strSkillIconName", strSkillIconName);
    ParseString(param, "strSkillName", strSkillName);
    ParseINT64(param, "SPConsume", spConsume);
    SetAfterSkillInfo(EnchantState, SkillID, Level, SubLevel, strSkillIconName, strSkillName);
    setTextByEnchantType();
    // End:0x2AB
    if(curSubLevel == SubLevel)
    {
        EnchantMaterialName.SetText("");
        EnchantMaterialIcon.Clear();
        i = 0;
        J0x26A:

        // End:0x297 [Loop If]
        if(i < 3)
        {
            EnchantMaterialInfo[i].SetText("");
            i++;
            // [Loop Continue]
            goto J0x26A;
        }
        EnchantMaterialInfo2.SetText("");        
    }
    else
    {
        SetEnchantConsumeInfo(haguinItemID, ItemNum[haguinID], strItemIconName[adenaID], strItemName[adenaID], ItemNum[adenaID], spConsume, Percent, EnchantState);
    }
    return;
}

function SetCurSkillInfo(ItemInfo Info)
{
    local SkillInfo SkillInfo;

    curSkillID = Info.Id.ClassID;
    curLevel = Info.Level;
    curSubLevel = Info.SubLevel;
    GetSkillInfo(curSkillID, curLevel, curSubLevel, SkillInfo);
    Info.Name = SkillInfo.SkillName;
    Info.Level = SkillInfo.SkillLevel;
    Info.SubLevel = SkillInfo.SkillSubLevel;
    Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
    Info.Description = SkillInfo.SkillDesc;
    Info.AdditionalName = SkillInfo.EnchantName;
    Info.IconPanel = SkillInfo.IconPanel;
    Info.ItemSubType = 2;
    ResearchSkillLv.SetText(GetSystemString(88) @ string(SkillInfo.SkillLevel));
    ResearchSkillName.SetNameWithColor(makeShortStringByPixel(SkillInfo.SkillName, 154, ".."), 0, 1, White);
    // End:0x192
    if(Info.SubLevel == 0)
    {
        ResearchSkillDesc.SetText(GetSystemString(2040));        
    }
    else
    {
        ResearchSkillDesc.SetText(GetSystemString(2207));
    }
    ResearchSkillIcon.Clear();
    ResearchSkillIcon.AddItem(Info);
    ResearchSkillSelectbox.HideWindow();
    ResearchRootSelectbox.ShowWindow();
    return;
}

function SetAfterSkillInfo(int EnchantState, int SkillID, int Level, int SubLevel, string strSkillIconName, string strSkillName)
{
    local SkillInfo SkillInfo;
    local ItemInfo Info;

    Info.Id.ClassID = SkillID;
    Info.Level = Level;
    Info.SubLevel = SubLevel;
    Info.IconName = "l2ui_ct1.SkillWnd_DF_Icon_Enchant_" $ Class'NWindow.UIDATA_SKILL'.static.GetEnchantIcon(Info.Id, Level, SubLevel);
    Info.Name = Class'NWindow.UIDATA_SKILL'.static.GetEnchantName(Info.Id, Level, SubLevel);
    GetSkillInfo(SkillID, Level, SubLevel, SkillInfo);
    ExpectationSkillIcon.Clear();
    ExpectationSkillIcon.AddItem(Info);
    ExpectationSkillRoot.SetText(makeShortStringByPixel(SkillInfo.EnchantName, 154, ".."));
    // End:0x145
    if(curSubLevel == SubLevel)
    {
        ExpectationSkillDesc.SetText(GetSystemString(3356));        
    }
    else
    {
        ExpectationSkillDesc.SetText(SkillInfo.EnchantDesc);
    }
    curEnchantType = SubLevel / 1000;
    // End:0x1A5
    if(EnchantState == 3)
    {
        // End:0x1A5
        if(curLevel == curWantedSubLevel)
        {
            ExpectationSkillDesc.SetText(GetSystemString(2210));
        }
    }
    return;
}

function SetEnchantConsumeInfo(int haguinClassID, int codexNum, string adenaIconName, string adenaName, int adenaNum, INT64 spConsume, int Percent, int EnchantState)
{
    local ItemID haguinID;
    local ItemInfo info_a, info_b, Info_c;
    local int i;
    local Color EnchantMaterialInfo2Color;
    local ItemWindowHandle InventoryItem;
    local ItemInfo SupportInfo;

    haguinID.ClassID = haguinClassID;
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(haguinID, info_a);
    InventoryItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
    InventoryItem.GetItem(InventoryItem.FindItem(haguinID), SupportInfo);
    info_b.IconName = adenaIconName;
    info_b.Name = adenaName;
    Info_c.IconName = "icon.etc_i.etc_sp_point_i00";
    Info_c.Name = "SP";
    // End:0x1FD
    if(EnchantState == 0)
    {
        EnchantMaterialName.SetText(makeShortStringByPixel(info_a.Name, 158, ".."));
        EnchantMaterialInfo[0].SetText(GetSystemString(1514) @ string(codexNum));
        EnchantMaterialInfo2.SetText(("(" $ (SupportInfo.ItemNum)) $ ")");
        EnchantMaterialIcon.Clear();
        EnchantMaterialIcon.AddItem(info_a);
        EnchantMaterialInfo[2].SetText(MakeCostString(string(adenaNum)));
        EnchantMaterialInfo[1].SetText(MakeCostString((spConsume)));
        SucessProbablity.ShowWindow();
        SucessProbablity.SetText("");
        SucessProbablity.SetText((GetSystemString(642) @ string(Percent)) @ GetSystemString(2042));        
    }
    else
    {
        // End:0x32A
        if(EnchantState == 1)
        {
            EnchantMaterialName.SetText(makeShortStringByPixel(info_a.Name, 158, ".."));
            EnchantMaterialInfo[0].SetText(GetSystemString(1514) @ string(codexNum));
            EnchantMaterialInfo2.SetText(("(" $ (SupportInfo.ItemNum)) $ ")");
            EnchantMaterialIcon.Clear();
            EnchantMaterialIcon.AddItem(info_a);
            EnchantMaterialInfo[1].SetText(MakeCostString((spConsume)));
            EnchantMaterialInfo[2].SetText(MakeCostString(string(adenaNum)));
            SucessProbablity.ShowWindow();
            SucessProbablity.SetText("");
            SucessProbablity.SetText((GetSystemString(642) @ string(Percent)) @ GetSystemString(2042));            
        }
        else
        {
            // End:0x458
            if(EnchantState == 4)
            {
                EnchantMaterialName.SetText(makeShortStringByPixel(info_a.Name, 158, ".."));
                EnchantMaterialInfo[0].SetText(GetSystemString(1514) @ string(codexNum));
                EnchantMaterialInfo2.SetText(("(" $ (SupportInfo.ItemNum)) $ ")");
                EnchantMaterialIcon.Clear();
                EnchantMaterialIcon.AddItem(info_a);
                EnchantMaterialInfo[1].SetText(MakeCostString((spConsume)));
                EnchantMaterialInfo[2].SetText(MakeCostString(string(adenaNum)));
                SucessProbablity.ShowWindow();
                SucessProbablity.SetText("");
                SucessProbablity.SetText((GetSystemString(642) @ string(Percent)) @ GetSystemString(2042));                
            }
            else
            {
                // End:0x5CA
                if(EnchantState == 3)
                {
                    // End:0x4DB
                    if(curLevel == curWantedSubLevel)
                    {
                        i = 0;
                        J0x47A:

                        // End:0x4A7 [Loop If]
                        if(i < 3)
                        {
                            EnchantMaterialInfo[i].SetText("");
                            i++;
                            // [Loop Continue]
                            goto J0x47A;
                        }
                        EnchantMaterialName.SetText("");
                        EnchantMaterialInfo2.SetText("");
                        EnchantMaterialIcon.Clear();                        
                    }
                    else
                    {
                        EnchantMaterialName.SetText(makeShortStringByPixel(info_a.Name, 158, ".."));
                        EnchantMaterialInfo[0].SetText(GetSystemString(1514) @ string(codexNum));
                        EnchantMaterialInfo2.SetText(("(" $ (SupportInfo.ItemNum)) $ ")");
                        EnchantMaterialIcon.Clear();
                        EnchantMaterialIcon.AddItem(info_a);
                        EnchantMaterialInfo[1].SetText(MakeCostString((spConsume)));
                        EnchantMaterialInfo[2].SetText(MakeCostString(string(adenaNum)));
                        SucessProbablity.SetText("");
                        SucessProbablity.HideWindow();
                    }
                }
            }
        }
    }
    // End:0x60D
    if(__NFUN_408__(SupportInfo.ItemNum, (codexNum)))
    {
        EnchantMaterialInfo2Color.R = byte(255);
        EnchantMaterialInfo2Color.G = 111;
        EnchantMaterialInfo2Color.B = 111;        
    }
    else
    {
        EnchantMaterialInfo2Color.R = 111;
        EnchantMaterialInfo2Color.G = 111;
        EnchantMaterialInfo2Color.B = byte(255);
    }
    EnchantMaterialInfo2.SetTextColor(EnchantMaterialInfo2Color);
    // End:0x6B2
    if((__NFUN_408__(SupportInfo.ItemNum, (codexNum)) || __NFUN_409__(spConsume, GetuserSP())) || __NFUN_409__((adenaNum), GetAdena()))
    {
        ResearchGuideDesc.SetText(GetSystemString(3361));
        btnResearch.DisableWindow();
    }
    needSPConsume = spConsume;
    needAdena = (adenaNum);
    return;
}

function INT64 GetuserSP()
{
    local UserInfo infoPlayer;
    local INT64 iPlayerSP;

    GetPlayerInfo(infoPlayer);
    iPlayerSP = infoPlayer.nSP;
    return iPlayerSP;
    return;
}

function handleSetCurrentSkill(ItemInfo a_ItemInfo)
{
    // End:0x31
    if((a_ItemInfo.Id.ClassID == curSkillID) && curLevel == a_ItemInfo.Level)
    {
        return;
    }
    // End:0x6F
    if(a_ItemInfo.bDisabled > 0)
    {
        SkillInfoClear();
        ResearchGuideDesc.SetText(GetSystemString(2041));
        AddSystemMessage(3070);        
    }
    else
    {
        SkillInfoClear();
        byRadioButton("");
        RequestExEnchantSkillInfo(a_ItemInfo.Id.ClassID, a_ItemInfo.Level, a_ItemInfo.SubLevel);
        SetCurSkillInfo(a_ItemInfo);
    }
    return;
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    local string DragSrcName;

    RequestSkillList();
    DragSrcName = Left(a_ItemInfo.DragSrcName, 10);
    // End:0x53
    if((DragSrcName == "PSkillItem") || DragSrcName == "ASkillItem")
    {
        handleSetCurrentSkill(a_ItemInfo);
    }
    return;
}

defaultproperties
{
    m_WindowName="MagicSkillDrawerWnd"
}