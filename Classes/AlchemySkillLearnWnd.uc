class AlchemySkillLearnWnd extends UICommonAPI;

const SKILLTYPE_ALCHEMYSKILL = 140;
const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;
const OFFSET_Y_MPCONSUME = 3;
const OFFSET_Y_CASTRANGE = 0;
const OFFSET_Y_SP = 120;
const WINDOW_W = 304;
const WINDOW_H_MAX = 510;
const WINDOW_H_MIN = 276;

var int m_iType;
var int m_iID;
var int m_iLevel;
var int m_iSubLevel;
var WindowHandle Me;
var AlchemySkillWnd alchemySkillWndScript;
var string m_WindowName;
var Color colorItemName;
var TextureHandle texIcon;
var TextureHandle iconActive;
var TextureHandle IconPanel;
var TextBoxHandle txtName;
var TextBoxHandle txtLevel;
var TextBoxHandle txtMP;
var TextBoxHandle txtUseTime;
var TextBoxHandle txtReuseTime;
var TreeHandle SkillTrainInfoTree;
var TextBoxHandle txtNeedChaLv;
var TextBoxHandle txtNeedSP;
var TextBoxHandle txtNeedItemString;
var NameCtrlHandle txtNeedItemName;
var TextBoxHandle txtNeedDualLvString;
var TextBoxHandle txtColoneDualLv;
var TextBoxHandle txtNeedDualLv;
var TextureHandle iconMP;
var TextureHandle iconUse;
var TextureHandle iconReuse;
var WindowHandle PrevSkillListBox;
var WindowHandle PrevSkillListNone;
var string TREENAME;
var L2Util util;

function OnRegisterEvent()
{
    RegisterEvent(2040);
    RegisterEvent(2051);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    OnRegisterEvent();
    Me = GetWindowHandle("AlchemySkillLearnWnd");
    texIcon = GetTextureHandle("AlchemySkillLearnWnd.texIcon");
    iconActive = GetTextureHandle("AlchemySkillLearnWnd.iconActive");
    IconPanel = GetTextureHandle("AlchemySkillLearnWnd.IconPanel");
    txtName = GetTextBoxHandle("AlchemySkillLearnWnd.txtName");
    txtLevel = GetTextBoxHandle("AlchemySkillLearnWnd.txtLevel");
    txtMP = GetTextBoxHandle("AlchemySkillLearnWnd.txtMP");
    txtUseTime = GetTextBoxHandle("AlchemySkillLearnWnd.txtUseTime");
    txtReuseTime = GetTextBoxHandle("AlchemySkillLearnWnd.txtReuseTime");
    txtNeedChaLv = GetTextBoxHandle("AlchemySkillLearnWnd.txtNeedChaLv");
    txtNeedSP = GetTextBoxHandle("AlchemySkillLearnWnd.txtNeedSP");
    txtNeedItemString = GetTextBoxHandle("AlchemySkillLearnWnd.txtNeedItemString");
    txtNeedItemName = GetNameCtrlHandle("AlchemySkillLearnWnd.txtNeedItemName");
    txtNeedDualLvString = GetTextBoxHandle("AlchemySkillLearnWnd.txtNeedDualLvString");
    txtColoneDualLv = GetTextBoxHandle("AlchemySkillLearnWnd.txtColoneDualLv");
    txtNeedDualLv = GetTextBoxHandle("AlchemySkillLearnWnd.txtNeedDualLv");
    iconMP = GetTextureHandle("AlchemySkillLearnWnd.iconMP");
    iconUse = GetTextureHandle("AlchemySkillLearnWnd.iconUse");
    iconReuse = GetTextureHandle("AlchemySkillLearnWnd.iconReuse");
    PrevSkillListBox = GetWindowHandle("AlchemySkillLearnWnd.PrevSkillListBox");
    PrevSkillListNone = GetWindowHandle("AlchemySkillLearnWnd.PrevSkillListNone");
    util = L2Util(GetScript("L2Util"));
    alchemySkillWndScript = AlchemySkillWnd(GetScript("AlchemySkillWnd"));
    txtNeedDualLv.HideWindow();
    txtNeedDualLvString.HideWindow();
    txtColoneDualLv.HideWindow();
    txtMP.HideWindow();
    txtUseTime.HideWindow();
    txtUseTime.HideWindow();
    txtReuseTime.HideWindow();
    iconMP.HideWindow();
    iconUse.HideWindow();
    iconReuse.HideWindow();
    iconActive.HideWindow();
    colorItemName.R = 175;
    colorItemName.G = 152;
    colorItemName.B = 120;
    return;
}

function OnClickButton(string strBtnID)
{
    switch(strBtnID)
    {
        // End:0x39
        case "btnLearn":
            OnLearn();
            HideWindow("AlchemySkillLearnWnd");
            // End:0x6D
            break;
        // End:0x6A
        case "btnGoBackList":
            HideWindow("AlchemySkillLearnWnd");
            // End:0x6D
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

function OnHide()
{
    m_iType = -1;
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string strIconName, strName;
    local INT64 iNumOfItem;
    local int iType, iID, iLevel, iSubLevel;

    switch(Event_ID)
    {
        // End:0x106
        case 2040:
            ParseInt(param, "Type", iType);
            // End:0x103
            if(iType == 140)
            {
                ParseInt(param, "iID", iID);
                ParseInt(param, "iLevel", iLevel);
                ParseInt(param, "iSubLevel", iSubLevel);
                m_iType = iType;
                m_iID = iID;
                m_iLevel = iLevel;
                m_iSubLevel = iSubLevel;
                Me.ShowWindow();
                Me.SetFocus();
                SkillLearningDetailInfo(param);
                // End:0x103
                if(!GetWindowHandle("AlchemySkillWnd").IsShowWindow())
                {
                    Me.HideWindow();
                }
            }
            // End:0x1B3
            break;
        // End:0x1A5
        case 2051:
            // End:0x1A2
            if(m_iType == 140)
            {
                ParseString(param, "strIconName", strIconName);
                ParseString(param, "strName", strName);
                ParseINT64(param, "iNumOfItem", iNumOfItem);
                AddSkillTrainInfoExtend(strIconName, strName, iNumOfItem);
                GetWindowHandle("AlchemySkillWnd").SetFocus();
            }
            // End:0x1B3
            break;
        // End:0x1B0
        case 2050:
            // End:0x1B3
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function AddSkillTrainInfo(string strIconName, string strName, int iID, int iLevel, string strOperateType, int iMPConsume, int iCastRange, string strDescription, int iSPConsume, INT64 iEXPConsume, string strEnchantName, string strEnchantDesc, int iPercent)
{
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("AlchemySkillLearnWnd.SkillTrainTreeWnd_List1.texIcon", strIconName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("AlchemySkillLearnWnd.SkillTrainTreeWnd_List1.txtName", strName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("AlchemySkillLearnWnd.SkillTrainTreeWnd_List1.txtLevel", iLevel);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("AlchemySkillLearnWnd.SkillTrainTreeWnd_List1.txtMP", iMPConsume);
    return;
}

function AddSkillTrainInfoExtend(string strIconName, string strName, INT64 iNumOfItem)
{
    // End:0x4C
    if(GetSystemString(469) == strName)
    {
        txtNeedItemName.SetNameWithColor(MakeFullSystemMsg(GetSystemMessage(2932), MakeCostStringINT64(iNumOfItem)), 0, 1, colorItemName);        
    }
    else
    {
        txtNeedItemName.SetNameWithColor(strName @ MakeFullSystemMsg(GetSystemMessage(1983), MakeCostStringINT64(iNumOfItem)), 0, 1, colorItemName);
    }
    return;
}

function OnShow()
{
    // End:0x35
    if(!GetWindowHandle("AlchemySkillWnd").IsShowWindow())
    {
        Me.HideWindow();
    }
    return;
}

function ShowNeedItems()
{
    return;
}

function SkillLearningDetailInfo(string param)
{
    local SkillInfo SkillInfo;
    local int Id, Level, SubLevel;
    local INT64 spConsume;
    local int requiredLevel;
    local UserInfo UserInfo;
    local ItemID cID;
    local string strName, strIconName, strIconPanel;

    ParseInt(param, "iID", Id);
    ParseInt(param, "iLevel", Level);
    ParseInt(param, "iSubLevel", SubLevel);
    ParseINT64(param, "iSPConsume", spConsume);
    requiredLevel = alchemySkillWndScript.getSkillRequestLevel(Id, Level);
    // End:0xBA
    if(requiredLevel == -1)
    {
        GetWindowHandle("AlchemySkillLearnWnd").HideWindow();
        return;
    }
    cID = GetItemID(Id);
    GetSkillInfo(Id, Level, SubLevel, SkillInfo);
    GetPlayerInfo(UserInfo);
    strName = SkillInfo.SkillName;
    strIconPanel = SkillInfo.IconPanel;
    strIconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(cID, Level, SubLevel);
    texIcon.SetTexture(strIconName);
    // End:0x17F
    if(GetAlchemySkillGradeType(Id, Level) == 4)
    {
        txtName.SetTextColor(util.Yellow03);        
    }
    else
    {
        txtName.SetTextColor(util.BrightWhite);
    }
    txtName.SetText(strName);
    txtLevel.SetText(string(Level));
    util.TreeClear(TREENAME);
    util.TreeInsertRootNode(TREENAME, "root", "");
    util.TreeInsertTextNodeItem(TREENAME, "root", Class'NWindow.UIDATA_SKILL'.static.GetDescription(cID, Level, 0));
    txtNeedChaLv.SetText(string(requiredLevel));
    reSizeWindow();
    // End:0x25A
    if(strIconPanel == "")
    {
        strIconPanel = "";
    }
    IconPanel.SetTexture(strIconPanel);
    return;
}

function reSizeWindow(optional bool B)
{
    // End:0x28
    if(B == true)
    {
        Me.SetWindowSize(304, 510);        
    }
    else
    {
        Me.SetWindowSize(304, 276);
    }
    return;
}

function bool TypeCheck(SkillInfo Info)
{
    local bool B;

    switch(Info.IconType)
    {
        // End:0x10
        case 0:
        // End:0x14
        case 1:
        // End:0x19
        case 2:
        // End:0x1E
        case 3:
        // End:0x23
        case 4:
        // End:0x28
        case 5:
        // End:0x2D
        case 6:
        // End:0x32
        case 7:
        // End:0x42
        case 8:
            B = true;
            // End:0x45
            break;
        // End:0xFFFF
        default:
            break;
    }
    return B;
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
    m_WindowName="AlchemySkillLearnWnd"
    TREENAME="AlchemySkillLearnWnd.SkillTrainInfoTree"
}