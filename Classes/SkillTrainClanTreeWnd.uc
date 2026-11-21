class SkillTrainClanTreeWnd extends UICommonAPI;

const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;
const OFFSET_Y_MPCONSUME = 3;
const OFFSET_Y_CASTRANGE = 0;
const OFFSET_Y_SP = 120;
const DISABLE_ALPHA = 100;

var int m_iType;
var int m_iID;
var int m_iLevel;
var int m_iSubLevel;
var int ClanClickedID;
var WindowHandle Me;
var TextureHandle texIcon;
var TextBoxHandle txtSkillDesc;
var TextBoxHandle txtName;
var TextBoxHandle txtLvString;
var TextBoxHandle txtLevel;
var TextBoxHandle txtOperateType;
var TextBoxHandle txtMPString;
var TextBoxHandle txtColone1;
var TextBoxHandle txtMP;
var TextBoxHandle txtCastRangeString;
var TextBoxHandle txtColoneCastRange;
var TextBoxHandle txtCastRange;
var TextBoxHandle txtNeedSPString;
var TextBoxHandle txtColone3;
var TextBoxHandle txtNeedSP;
var TextBoxHandle txtNeedItemName;
var TextBoxHandle txtSPString;
var TextBoxHandle txtSP;
var ButtonHandle btnLearn;
var ButtonHandle btnGoBackList;
var TextBoxHandle txtCondition;
var TextBoxHandle txtSelectTree;
var TextBoxHandle txtDescription;
var TextureHandle nowSpBg;
var TextureHandle texNeedItemIcon;
var TextureHandle requestBg;
var TextureHandle texSelectTree;
var TextureHandle texOutlineDown;
var TextureHandle texOutlineTopUp;
var ButtonHandle Clan_OrgIcon[8];
var TextureHandle Clan_OrgHighLight[8];

function OnRegisterEvent()
{
    RegisterEvent(2040);
    RegisterEvent(2050);
    RegisterEvent(2051);
    RegisterEvent(160);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x1D
    if(1 == 0)
    {
        InitHandle();        
    }
    else
    {
        InitHandleCOD();
    }
    load();
    Initialize();
    return;
}

function Initialize()
{
    ClanClickedID = -1;
    m_iType = -1;
    btnLearn.DisableWindow();
    return;
}

function DisableAllClanTreeWnd()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x49 [Loop If]
    if(i < 8)
    {
        Clan_OrgIcon[i].SetAlpha(100);
        Clan_OrgIcon[i].DisableWindow();
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function InitHandle()
{
    local int i;

    Me = GetHandle("SkillTrainClanTreeWnd");
    texIcon = TextureHandle(GetHandle("SkillTrainClanTreeWnd.texIcon"));
    txtSkillDesc = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtSkillDesc"));
    txtName = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtName"));
    txtLvString = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtLvString"));
    txtLevel = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtLevel"));
    txtOperateType = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtOperateType"));
    txtMPString = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtMPString"));
    txtColone1 = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtColone1"));
    txtMP = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtMP"));
    txtCastRangeString = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtCastRangeString"));
    txtColoneCastRange = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtColoneCastRange"));
    txtCastRange = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtCastRange"));
    txtNeedSPString = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtNeedSPString"));
    txtColone3 = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtColone3"));
    txtNeedSP = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtNeedSP"));
    txtNeedItemName = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtNeedItemName"));
    txtSPString = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtSPString"));
    txtSP = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtSP"));
    btnLearn = ButtonHandle(GetHandle("SkillTrainClanTreeWnd.btnLearn"));
    btnGoBackList = ButtonHandle(GetHandle("SkillTrainClanTreeWnd.btnGoBackList"));
    txtCondition = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtCondition"));
    txtSelectTree = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtSelectTree"));
    txtDescription = TextBoxHandle(GetHandle("SkillTrainClanTreeWnd.txtDescription"));
    nowSpBg = TextureHandle(GetHandle("SkillTrainClanTreeWnd.nowSpBg"));
    texNeedItemIcon = TextureHandle(GetHandle("SkillTrainClanTreeWnd.texNeedItemIcon"));
    requestBg = TextureHandle(GetHandle("SkillTrainClanTreeWnd.requestBg"));
    texSelectTree = TextureHandle(GetHandle("SkillTrainClanTreeWnd.texSelectTree"));
    texOutlineDown = TextureHandle(GetHandle("SkillTrainClanTreeWnd.texOutlineDown"));
    texOutlineTopUp = TextureHandle(GetHandle("SkillTrainClanTreeWnd.texOutlineTopUp"));
    i = 0;
    J0x61A:

    // End:0x6F3 [Loop If]
    if(i < 8)
    {
        Clan_OrgIcon[i] = ButtonHandle(GetHandle((("SkillTrainClanTreeWnd.ClanOrgIconWnd" $ string(i + 1)) $ ".texClanIcon") $ string(i + 1)));
        Clan_OrgHighLight[i] = TextureHandle(GetHandle(("SkillTrainClanTreeWnd.ClanOrgIconWnd" $ string(i + 1)) $ ".texIconHighlight"));
        ++i;
        // [Loop Continue]
        goto J0x61A;
    }
    return;
}

function InitHandleCOD()
{
    local int i;

    Me = GetWindowHandle("SkillTrainClanTreeWnd");
    texIcon = GetTextureHandle("SkillTrainClanTreeWnd.texIcon");
    txtSkillDesc = GetTextBoxHandle("SkillTrainClanTreeWnd.txtSkillDesc");
    txtName = GetTextBoxHandle("SkillTrainClanTreeWnd.txtName");
    txtLvString = GetTextBoxHandle("SkillTrainClanTreeWnd.txtLvString");
    txtLevel = GetTextBoxHandle("SkillTrainClanTreeWnd.txtLevel");
    txtOperateType = GetTextBoxHandle("SkillTrainClanTreeWnd.txtOperateType");
    txtMPString = GetTextBoxHandle("SkillTrainClanTreeWnd.txtMPString");
    txtColone1 = GetTextBoxHandle("SkillTrainClanTreeWnd.txtColone1");
    txtMP = GetTextBoxHandle("SkillTrainClanTreeWnd.txtMP");
    txtCastRangeString = GetTextBoxHandle("SkillTrainClanTreeWnd.txtCastRangeString");
    txtColoneCastRange = GetTextBoxHandle("SkillTrainClanTreeWnd.txtColoneCastRange");
    txtCastRange = GetTextBoxHandle("SkillTrainClanTreeWnd.txtCastRange");
    txtNeedSPString = GetTextBoxHandle("SkillTrainClanTreeWnd.txtNeedSPString");
    txtColone3 = GetTextBoxHandle("SkillTrainClanTreeWnd.txtColone3");
    txtNeedSP = GetTextBoxHandle("SkillTrainClanTreeWnd.txtNeedSP");
    txtNeedItemName = GetTextBoxHandle("SkillTrainClanTreeWnd.txtNeedItemName");
    txtSPString = GetTextBoxHandle("SkillTrainClanTreeWnd.txtSPString");
    txtSP = GetTextBoxHandle("SkillTrainClanTreeWnd.txtSP");
    btnLearn = GetButtonHandle("SkillTrainClanTreeWnd.btnLearn");
    btnGoBackList = GetButtonHandle("SkillTrainClanTreeWnd.btnGoBackList");
    txtCondition = GetTextBoxHandle("SkillTrainClanTreeWnd.txtCondition");
    txtSelectTree = GetTextBoxHandle("SkillTrainClanTreeWnd.txtSelectTree");
    txtDescription = GetTextBoxHandle("SkillTrainClanTreeWnd.txtDescription");
    nowSpBg = GetTextureHandle("SkillTrainClanTreeWnd.nowSpBg");
    texNeedItemIcon = GetTextureHandle("SkillTrainClanTreeWnd.texNeedItemIcon");
    requestBg = GetTextureHandle("SkillTrainClanTreeWnd.requestBg");
    texSelectTree = GetTextureHandle("SkillTrainClanTreeWnd.texSelectTree");
    texOutlineDown = GetTextureHandle("SkillTrainClanTreeWnd.texOutlineDown");
    texOutlineTopUp = GetTextureHandle("SkillTrainClanTreeWnd.texOutlineTopUp");
    i = 0;
    J0x589:

    // End:0x658 [Loop If]
    if(i < 8)
    {
        Clan_OrgIcon[i] = GetButtonHandle((("SkillTrainClanTreeWnd.ClanOrgIconWnd" $ string(i + 1)) $ ".texClanIcon") $ string(i + 1));
        Clan_OrgHighLight[i] = GetTextureHandle(("SkillTrainClanTreeWnd.ClanOrgIconWnd" $ string(i + 1)) $ ".texIconHighlight");
        ++i;
        // [Loop Continue]
        goto J0x589;
    }
    return;
}

function load()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x5E [Loop If]
    if(i < 8)
    {
        Clan_OrgHighLight[i].HideWindow();
        Clan_OrgIcon[i].SetAlpha(100);
        Clan_OrgIcon[i].HideWindow();
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnClickButton(string Name)
{
    local int temp1;

    switch(Name)
    {
        // End:0x5E
        case "btnLearn":
            OnbtnLearnClick();
            // End:0x41
            if(ClanClickedID != -1)
            {
                Clan_OrgHighLight[ClanClickedID - 1].HideWindow();
            }
            ClanClickedID = -1;
            btnLearn.DisableWindow();
            // End:0xED
            break;
        // End:0xEA
        case "btnGoBackList":
            HideWindow("SkillTrainClanTreeWnd");
            ShowWindowWithFocus("SkillTrainListWnd");
            // End:0xCD
            if(ClanClickedID != -1)
            {
                Clan_OrgHighLight[ClanClickedID - 1].HideWindow();
            }
            ClanClickedID = -1;
            btnLearn.DisableWindow();
            // End:0xED
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x1FF
    if(InStr(Name, "texClanIcon") > -1)
    {
        temp1 = int(Right(Name, 1));
        // End:0x129
        if(temp1 == 8)
        {
            return;
        }
        // End:0x1FF
        if((temp1 > 0) && temp1 < (8 + 2))
        {
            // End:0x1BE
            if((ClanClickedID < 0) || temp1 != ClanClickedID)
            {
                Clan_OrgHighLight[temp1 - 1].ShowWindow();
                // End:0x1A1
                if(ClanClickedID != -1)
                {
                    Clan_OrgHighLight[ClanClickedID - 1].HideWindow();
                }
                ClanClickedID = temp1;
                btnLearn.EnableWindow();                
            }
            else
            {
                // End:0x1FF
                if(temp1 == ClanClickedID)
                {
                    Clan_OrgHighLight[temp1 - 1].HideWindow();
                    ClanClickedID = -1;
                    btnLearn.DisableWindow();
                }
            }
        }
    }
    return;
}

function OnbtnLearnClick()
{
    local int nClanIdx;

    switch(m_iType)
    {
        // End:0x5A
        case 3:
            nClanIdx = GetClanTypeFromIndex(ClanClickedID - 1);
            RequestAcquireSkillSubClan(m_iID, m_iLevel, m_iType, nClanIdx);
            HideWindow("SkillTrainClanTreeWnd");
            // End:0x5D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int iType;
    local string strIconName, strName;
    local int iID, iLevel, iSubLevel;
    local INT64 iSPConsume, iEXPConsume;
    local string strDescription, strOperateType;
    local int iMPConsume, iCastRange;
    local INT64 iNumOfItem;
    local string strEnchantName, strEnchantDesc;
    local int iPercent;
    local ClanDrawerWnd script;

    // End:0x15
    if(getInstanceL2Util().isClanV2())
    {
        return;
    }
    switch(Event_ID)
    {
        // End:0x29F
        case 2040:
            ParseInt(param, "Type", iType);
            script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
            Class'NWindow.UIDATA_CLAN'.static.RequestClanInfo();
            script.InitializeClanInfoWnd();
            // End:0x29C
            if(iType == 3)
            {
                ParseString(param, "strIconName", strIconName);
                ParseString(param, "strName", strName);
                ParseInt(param, "iID", iID);
                ParseInt(param, "iLevel", iLevel);
                ParseInt(param, "iSubLevel", iSubLevel);
                ParseString(param, "strOperateType", strOperateType);
                ParseInt(param, "iMPConsume", iMPConsume);
                ParseInt(param, "iCastRange", iCastRange);
                ParseINT64(param, "iSPConsume", iSPConsume);
                ParseString(param, "strDescription", strDescription);
                ParseINT64(param, "iEXPConsume", iEXPConsume);
                ParseString(param, "strEnchantName", strEnchantName);
                ParseString(param, "strEnchantDesc", strEnchantDesc);
                ParseInt(param, "iPercent", iPercent);
                m_iType = iType;
                m_iID = iID;
                m_iLevel = iLevel;
                m_iSubLevel = iSubLevel;
                ShowSkillTrainClanTreeWnd();
                DisableAllClanTreeWnd();
                EnableProperClanSubWnd(iID, iLevel);
                AddSkillTrainInfo(strIconName, strName, iID, iLevel, strOperateType, iMPConsume, iCastRange, strDescription, iSPConsume, iEXPConsume, strEnchantName, strEnchantDesc, iPercent);
            }
            // End:0x38E
            break;
        // End:0x323
        case 2051:
            // End:0x320
            if(m_iType == 3)
            {
                ParseString(param, "strIconName", strIconName);
                ParseString(param, "strName", strName);
                ParseINT64(param, "iNumOfItem", iNumOfItem);
                AddSkillTrainInfoExtend(strIconName, strName, iNumOfItem);
                ShowNeedItems();
            }
            // End:0x38E
            break;
        // End:0x377
        case 2050:
            // End:0x374
            if(m_iType == 3)
            {
                // End:0x374
                if(IsShowWindow("SkillTrainClanTreeWnd"))
                {
                    HideWindow("SkillTrainClanTreeWnd");
                }
            }
            // End:0x38E
            break;
        // End:0x38B
        case 160:
            load();
            Initialize();
            // End:0x38E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function EnableProperClanSubWnd(int iID, int iLevel)
{
    local int i, nClanIdx, LearnSkillLV;

    i = 0;
    J0x07:

    // End:0xE7 [Loop If]
    if(i < 8)
    {
        nClanIdx = GetClanTypeFromIndex(i);
        LearnSkillLV = Class'NWindow.UIDATA_CLAN'.static.GetSubClanSkillLevel(iID, nClanIdx);
        // End:0x54
        if(nClanIdx == -1)
        {
            return;
        }
        // End:0x9F
        if((LearnSkillLV == -1) && iLevel == 1)
        {
            Clan_OrgIcon[i].EnableWindow();
            Clan_OrgIcon[i].SetAlpha(255);
            // [Explicit Continue]
            goto J0xDD;
        }
        // End:0xDD
        if(LearnSkillLV == (iLevel - 1))
        {
            Clan_OrgIcon[i].EnableWindow();
            Clan_OrgIcon[i].SetAlpha(255);
        }
        J0xDD:

        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function ShowSkillTrainClanTreeWnd()
{
    local UserInfo infoPlayer;

    GetPlayerInfo(infoPlayer);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle("SkillTrainClanTreeWnd", 1436);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainClanTreeWnd.txtSPString", GetSystemString(1372));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("SkillTrainClanTreeWnd.txtSP", GetClanNameValue(infoPlayer.nClanID));
    ShowWindowWithFocus("SkillTrainClanTreeWnd");
    return;
}

function AddSkillTrainInfo(string strIconName, string strName, int iID, int iLevel, string strOperateType, int iMPConsume, int iCastRange, string strDescription, INT64 iSPConsume, INT64 iEXPConsume, string strEnchantName, string strEnchantDesc, int iPercent)
{
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainClanTreeWnd.texIcon", strIconName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainClanTreeWnd.txtName", strName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("SkillTrainClanTreeWnd.txtLevel", iLevel);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainClanTreeWnd.txtOperateType", strOperateType);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("SkillTrainClanTreeWnd.txtMP", iMPConsume);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainClanTreeWnd.txtDescription", strDescription);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainClanTreeWnd.txtNeedSPString", GetSystemString(1437));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainClanTreeWnd.txtNeedSP", (iSPConsume));
    // End:0x25D
    if(iCastRange >= 0)
    {
        ShowWindow("SkillTrainClanTreeWnd.txtCastRangeString");
        ShowWindow("SkillTrainClanTreeWnd.txtColoneCastRange");
        Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("SkillTrainClanTreeWnd.txtCastRange", iCastRange);        
    }
    else
    {
        HideWindow("SkillTrainClanTreeWnd.txtCastRangeString");
        HideWindow("SkillTrainClanTreeWnd.txtColoneCastRange");
        HideWindow("SkillTrainClanTreeWnd.txtCastRange");
    }
    return;
}

function AddSkillTrainInfoExtend(string strIconName, string strName, INT64 iNumOfItem)
{
    texNeedItemIcon.SetTexture(strIconName);
    txtNeedItemName.SetText((strName $ " X ") $ (iNumOfItem));
    return;
}

function OnShow()
{
    HideWindow("SkillTrainClanTreeWnd.SubWndNormal.texNeedItemIcon");
    HideWindow("SkillTrainClanTreeWnd.SubWndNormal.txtNeedItemName");
    return;
}

function ShowNeedItems()
{
    ShowWindow("SkillTrainClanTreeWnd.texNeedItemIcon");
    ShowWindow("SkillTrainClanTreeWnd.txtNeedItemName");
    return;
}

function int GetClanTypeFromIndex(int Index)
{
    local int Type;

    // End:0x12
    if(Index == 0)
    {
        Type = 0;
    }
    // End:0x25
    if(Index == 1)
    {
        Type = 100;
    }
    // End:0x39
    if(Index == 2)
    {
        Type = 200;
    }
    // End:0x50
    if(Index == 3)
    {
        Type = 1001;
    }
    // End:0x67
    if(Index == 4)
    {
        Type = 1002;
    }
    // End:0x7E
    if(Index == 5)
    {
        Type = 2001;
    }
    // End:0x95
    if(Index == 6)
    {
        Type = 2002;
    }
    // End:0xAC
    if(Index == 7)
    {
        Type = -1;
    }
    return Type;
    return;
}
