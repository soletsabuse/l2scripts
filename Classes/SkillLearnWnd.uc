class SkillLearnWnd extends UICommonAPI;

const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -14;
const OFFSET_Y_MPCONSUME = 3;
const OFFSET_Y_CASTRANGE = 0;
const OFFSET_Y_SP = 120;
const WINDOW_W = 300;
const WINDOW_H_MAX = 510;
const WINDOW_H_MIN = 404;

var int m_iType;
var int m_iID;
var int m_iLevel;
var int m_iSubLevel;
var WindowHandle Me;
var string m_WindowName;
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
var TextBoxHandle txtNeedItemName;
var TextBoxHandle txtNeedDualLvString;
var TextBoxHandle txtColoneDualLv;
var TextBoxHandle txtNeedDualLv;
var TextureHandle iconMP;
var TextureHandle iconUse;
var TextureHandle iconReuse;
var TextureHandle spBg;
var WindowHandle PrevSkillListBox;
var WindowHandle PrevSkillListNone;
var MagicSkillWnd MagicSkillWndScript;
var string TREENAME;
var L2Util util;

function OnRegisterEvent()
{
    RegisterEvent(2058);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    OnRegisterEvent();
    Me = GetWindowHandle("SkillLearnWnd");
    texIcon = GetTextureHandle("SkillLearnWnd.texIcon");
    iconActive = GetTextureHandle("SkillLearnWnd.iconActive");
    IconPanel = GetTextureHandle("SkillLearnWnd.IconPanel");
    txtName = GetTextBoxHandle("SkillLearnWnd.txtName");
    txtLevel = GetTextBoxHandle("SkillLearnWnd.txtLevel");
    txtMP = GetTextBoxHandle("SkillLearnWnd.txtMP");
    txtUseTime = GetTextBoxHandle("SkillLearnWnd.txtUseTime");
    txtReuseTime = GetTextBoxHandle("SkillLearnWnd.txtReuseTime");
    txtNeedChaLv = GetTextBoxHandle("SkillLearnWnd.txtNeedChaLv");
    txtNeedSP = GetTextBoxHandle("SkillLearnWnd.txtNeedSP");
    txtNeedItemString = GetTextBoxHandle("SkillLearnWnd.txtNeedItemString");
    txtNeedItemName = GetTextBoxHandle("SkillLearnWnd.txtNeedItemName");
    txtNeedDualLvString = GetTextBoxHandle("SkillLearnWnd.txtNeedDualLvString");
    txtColoneDualLv = GetTextBoxHandle("SkillLearnWnd.txtColoneDualLv");
    txtNeedDualLv = GetTextBoxHandle("SkillLearnWnd.txtNeedDualLv");
    iconMP = GetTextureHandle("SkillLearnWnd.iconMP");
    iconUse = GetTextureHandle("SkillLearnWnd.iconUse");
    iconReuse = GetTextureHandle("SkillLearnWnd.iconReuse");
    spBg = GetTextureHandle("SkillLearnWnd.spBg");
    PrevSkillListBox = GetWindowHandle("SkillLearnWnd.PrevSkillListBox");
    PrevSkillListNone = GetWindowHandle("SkillLearnWnd.PrevSkillListNone");
    util = L2Util(GetScript("L2Util"));
    MagicSkillWndScript = MagicSkillWnd(GetScript("MagicSkillWnd"));
    return;
}

function OnClickButton(string strBtnID)
{
    switch(strBtnID)
    {
        // End:0x32
        case "btnLearn":
            OnLearn();
            HideWindow("SkillLearnWnd");
            // End:0x5F
            break;
        // End:0x5C
        case "btnGoBackList":
            HideWindow("SkillLearnWnd");
            // End:0x5F
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
    local MagicSkillWnd sc;

    sc = MagicSkillWnd(GetScript("MagicSkillWnd"));
    sc.closeTreeNode();
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x2C
        case 2058:
            Me.ShowWindow();
            SkillLearningDetailInfo(param);
            // End:0x2F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnShow()
{
    HideWindow("SkillTrainInfoWnd.SubWndEnchant");
    ShowWindow("SkillTrainInfoWnd.SubWndNormal");
    // End:0x96
    if(!GetWindowHandle("MagicSkillWnd").IsShowWindow() || !MagicSkillWndScript.isSkillLearnTab())
    {
        Me.HideWindow();
    }
    return;
}

function SkillLearningDetailInfo(string param)
{
    local SkillInfo SkillInfo;
    local int Id, Level, SubLevel;
    local INT64 spConsume;
    local int requiredLevel, RequiredDualLevel;
    local UserInfo UserInfo;
    local ItemID cID;
    local int RequiredItemTotalCnt, requiredItemID, requiredItemCnt, RequiredSkillCnt, requiredSkillID, requiredSkillLevel;

    local ItemID requiredID;
    local int i;
    local string strName, strIconName, strIconPanel;

    ParseInt(param, "ID", Id);
    ParseInt(param, "Level", Level);
    ParseInt(param, "SubLevel", SubLevel);
    ParseINT64(param, "SpConsume", spConsume);
    ParseInt(param, "RequiredLevel", requiredLevel);
    ParseInt(param, "RequiredDualLevel", RequiredDualLevel);
    ParseInt(param, "RequiredItemTotalCnt", RequiredItemTotalCnt);
    ParseInt(param, "RequiredSkillCnt", RequiredSkillCnt);
    cID = GetItemID(Id);
    GetSkillInfo(Id, Level, SubLevel, SkillInfo);
    GetPlayerInfo(UserInfo);
    strName = SkillInfo.SkillName;
    strIconPanel = SkillInfo.IconPanel;
    strIconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(cID, Level, 0);
    texIcon.SetTexture(strIconName);
    // End:0x289
    if((TypeCheck(SkillInfo)) == true)
    {
        iconActive.SetTexture("l2ui_ct1.SkillWnd_DF_ListIcon_Active");
        iconMP.ShowWindow();
        iconUse.ShowWindow();
        iconReuse.ShowWindow();
        txtName.SetText(strName);
        txtLevel.SetText(string(Level));
        txtMP.SetText(string(SkillInfo.MpConsume));
        txtUseTime.SetText(util.MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime));
        txtReuseTime.SetText(util.MakeTimeString(SkillInfo.ReuseDelay));        
    }
    else
    {
        iconActive.SetTexture("l2ui_ct1.SkillWnd_DF_ListIcon_Passive");
        iconMP.HideWindow();
        iconUse.HideWindow();
        iconReuse.HideWindow();
        txtName.SetText(strName);
        txtLevel.SetText(string(Level));
        txtMP.SetText("");
        txtUseTime.SetText("");
        txtReuseTime.SetText("");
    }
    util.TreeClear(TREENAME);
    util.TreeInsertRootNode(TREENAME, "root", "");
    util.TreeInsertTextNodeItem(TREENAME, "root", Class'NWindow.UIDATA_SKILL'.static.GetDescription(cID, Level, 0));
    txtNeedChaLv.SetText(string(requiredLevel));
    // End:0x414
    if(RequiredDualLevel > 0)
    {
        txtNeedDualLvString.ShowWindow();
        txtColoneDualLv.ShowWindow();
        txtNeedDualLv.ShowWindow();
        txtNeedDualLv.SetText(string(RequiredDualLevel));        
    }
    else
    {
        txtNeedDualLvString.HideWindow();
        txtColoneDualLv.HideWindow();
        txtNeedDualLv.HideWindow();
    }
    txtNeedSP.SetText((spConsume));
    // End:0x511
    if(RequiredItemTotalCnt > 0)
    {
        i = 1;
        J0x469:

        // End:0x50E [Loop If]
        if(i <= RequiredItemTotalCnt)
        {
            ParseInt(param, "requiredItemID" $ string(i), requiredItemID);
            ParseInt(param, "requiredItemCnt" $ string(i), requiredItemCnt);
            txtNeedItemName.SetText((Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(requiredItemID)) $ " X ") $ string(requiredItemCnt));
            i++;
            // [Loop Continue]
            goto J0x469;
        }        
    }
    else
    {
        txtNeedItemName.SetText(GetSystemString(27));
    }
    // End:0x797
    if(RequiredSkillCnt > 0)
    {
        reSizeWindow(true);
        showLearningSkill(RequiredSkillCnt);
        i = 1;
        J0x54C:

        // End:0x794 [Loop If]
        if(i <= RequiredSkillCnt)
        {
            ParseInt(param, "requiredSkillID" $ string(i), requiredSkillID);
            ParseInt(param, "requiredSkillLevel" $ string(i), requiredSkillLevel);
            requiredID = GetItemID(requiredSkillID);
            GetTextureHandle("texPrevSkillIcon" $ string(i)).SetTexture(Class'NWindow.UIDATA_SKILL'.static.GetIconName(requiredID, requiredSkillLevel, 0));
            GetTextureHandle("texPrevSkillIcon" $ string(i)).SetTextureSize(32, 32);
            // End:0x6EF
            if(Class'NWindow.UIDATA_SKILL'.static.SkillIsNewOrUp(requiredID) == 0)
            {
                GetTextBoxHandle("txtPrevName" $ string(i)).SetText(Class'NWindow.UIDATA_SKILL'.static.GetName(requiredID, requiredSkillLevel, 0));
                GetTextBoxHandle("txtPrevLevel" $ string(i)).SetText(string(requiredSkillLevel));
                GetTextureHandle("texPrevSkillIconUp" $ string(i)).ShowWindow();
                // [Explicit Continue]
                goto J0x78A;
            }
            GetTextBoxHandle("txtPrevName" $ string(i)).SetText(Class'NWindow.UIDATA_SKILL'.static.GetName(requiredID, requiredSkillLevel, 0));
            GetTextBoxHandle("txtPrevLevel" $ string(i)).SetText(string(requiredSkillLevel));
            GetTextureHandle("texPrevSkillIconUp" $ string(i)).HideWindow();
            J0x78A:

            i++;
            // [Loop Continue]
            goto J0x54C;
        }        
    }
    else
    {
        reSizeWindow();
    }
    m_iType = 0;
    m_iID = Id;
    m_iLevel = Level;
    m_iSubLevel = SubLevel;
    // End:0x7D9
    if(strIconPanel == "")
    {
        strIconPanel = "";
    }
    IconPanel.SetTexture(strIconPanel);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillLearnWnd.txtSP", (UserInfo.nSP));
    return;
}

function reSizeWindow(optional bool B)
{
    // End:0x8D
    if(B == true)
    {
        PrevSkillListBox.ShowWindow();
        PrevSkillListNone.HideWindow();
        spBg.SetAnchor("SkillLearnWnd.PrevSkillListBox", "BottomLeft", "TopLeft", 0, 5);
        Me.SetWindowSize(300, 510);        
    }
    else
    {
        PrevSkillListBox.HideWindow();
        PrevSkillListNone.ShowWindow();
        spBg.SetAnchor("SkillLearnWnd.PrevSkillListNone", "BottomLeft", "TopLeft", 0, 5);
        Me.SetWindowSize(300, 404);
    }
    return;
}

function showLearningSkill(int Count)
{
    local int i;

    i = 1;
    J0x07:

    // End:0x7F [Loop If]
    if(i <= 5)
    {
        // End:0x4D
        if(i <= Count)
        {
            GetWindowHandle("PrevSkillList" $ string(i)).ShowWindow();
            // [Explicit Continue]
            goto J0x75;
        }
        GetWindowHandle("PrevSkillList" $ string(i)).HideWindow();
        J0x75:

        i++;
        // [Loop Continue]
        goto J0x07;
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
    m_WindowName="SkillLearnWnd"
    TREENAME="SkillLearnWnd.SkillTrainInfoTree"
}