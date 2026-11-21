class SkillTrainInfoWnd extends UICommonAPI;

const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;
const OFFSET_Y_MPCONSUME = 3;
const OFFSET_Y_CASTRANGE = 0;
const OFFSET_Y_SP = 120;
const SKILLTYPE_ALCHEMYSKILL = 140;

var int m_iType;
var int m_iID;
var int m_iLevel;
var int m_iSubLevel;
var TreeHandle SkillTrainInfoTree;
var L2Util util;
var string TREENAME;

function OnRegisterEvent()
{
    RegisterEvent(2040);
    RegisterEvent(2050);
    RegisterEvent(2051);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    util = L2Util(GetScript("L2Util"));
    return;
}

function OnClickButton(string strBtnID)
{
    switch(strBtnID)
    {
        // End:0x1D
        case "btnLearn":
            OnLearn();
            // End:0x4E
            break;
        // End:0x4B
        case "btnGoBackList":
            ShowWindowWithFocus("SkillTrainListWnd");
            // End:0x4E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnLearn()
{
    RequestAcquireSkill(m_iID, m_iLevel, m_iSubLevel, m_iType);
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

    switch(Event_ID)
    {
        // End:0x256
        case 2040:
            ParseInt(param, "Type", iType);
            m_iType = iType;
            // End:0x3E
            if(m_iType == 140)
            {
                return;
            }
            // End:0x4C
            if(m_iType == 3)
            {
                return;
            }
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
            ShowSkillTrainInfoWnd();
            AddSkillTrainInfo(strIconName, strName, iID, iLevel, iSubLevel, strOperateType, iMPConsume, iCastRange, strDescription, iSPConsume, iEXPConsume, strEnchantName, strEnchantDesc, iPercent);
            // End:0x349
            break;
        // End:0x2EA
        case 2051:
            // End:0x26C
            if(m_iType == 140)
            {
                return;
            }
            // End:0x27A
            if(m_iType == 3)
            {
                return;
            }
            ParseString(param, "strIconName", strIconName);
            ParseString(param, "strName", strName);
            ParseINT64(param, "iNumOfItem", iNumOfItem);
            AddSkillTrainInfoExtend(strIconName, strName, iNumOfItem);
            ShowNeedItems();
            // End:0x349
            break;
        // End:0x346
        case 2050:
            // End:0x300
            if(m_iType == 140)
            {
                return;
            }
            // End:0x30E
            if(m_iType == 3)
            {
                return;
            }
            // End:0x343
            if(IsShowWindow("SkillTrainInfoWnd"))
            {
                HideWindow("SkillTrainInfoWnd");
            }
            // End:0x349
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ShowSkillTrainInfoWnd()
{
    local int iWindowTitle, iSPIdx;
    local UserInfo infoPlayer;
    local INT64 iPlayerSP;

    GetPlayerInfo(infoPlayer);
    switch(m_iType)
    {
        // End:0x17
        case 2:
        // End:0xF3
        case 3:
            HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
            HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
            HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIconSlot");
            iWindowTitle = 1436;
            iSPIdx = 1372;
            iPlayerSP = (GetClanNameValue(infoPlayer.nClanID));
            // End:0x11C
            break;
        // End:0xFFFF
        default:
            iWindowTitle = 477;
            iSPIdx = 92;
            iPlayerSP = infoPlayer.nSP;
            // End:0x11C
            break;
            break;
    }
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle("SkillTrainInfoWnd", iWindowTitle);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtSPString", GetSystemString(iSPIdx));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtSP", (iPlayerSP));
    ShowWindowWithFocus("SkillTrainInfoWnd");
    return;
}

function AddSkillTrainInfo(string strIconName, string strName, int iID, int iLevel, int iSubLevel, string strOperateType, int iMPConsume, int iCastRange, string strDescription, INT64 iSPConsume, INT64 iEXPConsume, string strEnchantName, string strEnchantDesc, int iPercent)
{
    local SkillInfo SkillInfo;
    local string strIconPanel;

    GetSkillInfo(iID, iLevel, iSubLevel, SkillInfo);
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.texIcon", strIconName);
    // End:0x6D
    if(SkillInfo.IconPanel != "")
    {
        strIconPanel = SkillInfo.IconPanel;        
    }
    else
    {
        strIconPanel = "";
    }
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.IconPanel", strIconPanel);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtName", strName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtLevel", iLevel);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtOperateType", strOperateType);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtMP", iMPConsume);
    util.TreeClear(TREENAME);
    util.TreeInsertRootNode(TREENAME, "root", "");
    util.TreeInsertTextNodeItem(TREENAME, "root", strDescription);
    switch(m_iType)
    {
        // End:0x1C3
        case 2:
        // End:0x215
        case 3:
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(1437));
            // End:0x265
            break;
        // End:0xFFFF
        default:
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(365));
            // End:0x265
            break;
            break;
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSP", (iSPConsume));
    // End:0x365
    if(iCastRange >= 0)
    {
        ShowWindow("SkillTrainInfoWnd.txtCastRangeString");
        ShowWindow("SkillTrainInfoWnd.txtColoneCastRange");
        ShowWindow("SkillTrainInfoWnd.txtCastRange");
        Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtCastRange", iCastRange);        
    }
    else
    {
        HideWindow("SkillTrainInfoWnd.txtCastRangeString");
        HideWindow("SkillTrainInfoWnd.txtColoneCastRange");
        HideWindow("SkillTrainInfoWnd.txtCastRange");
    }
    return;
}

function AddSkillTrainInfoExtend(string strIconName, string strName, INT64 iNumOfItem)
{
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon", strIconName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName", (strName $ " X ") $ (iNumOfItem));
    return;
}

function OnShow()
{
    HideWindow("SkillTrainInfoWnd.SubWndEnchant");
    ShowWindow("SkillTrainInfoWnd.SubWndNormal");
    HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
    HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
    HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIconSlot");
    ShowWindow("SkillTrainListWnd.txtSPString");
    ShowWindow("SkillTrainListWnd.txtSP");
    // End:0x16C
    if(IsShowWindow("SkillTrainListWnd"))
    {
        HideWindow("SkillTrainListWnd");
    }
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("SkillTrainInfoWnd", "SkillTrainListWnd", "TopLeft", "TopLeft", 0, 0);
    return;
}

function ShowNeedItems()
{
    ShowWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
    ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("SkillTrainInfoWnd").HideWindow();
    return;
}

defaultproperties
{
    TREENAME="SkillTrainInfoWnd.SubWndNormal.SkillTrainInfoTree"
}