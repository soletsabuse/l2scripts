class AlchemySkillWnd extends UICommonAPI;

const Skill_MAX_COUNT = 24;
const Skill_GROUP_COUNT = 8;
const SKILL_COL_COUNT = 7;
const Skill_GROUP_COUNT_P = 6;
const SKILL_ITEMWND_WIDTH = 260;
const SKILL_SLOTBG_WIDTH = 252;
const TOP_MARGIN = 5;
const NAME_WND_HEIGHT = 20;
const BETWEEN_NAME_ITEM = 3;
const SKILL_NORMAL = 0;
const SKILL_BUF = 1;
const SKILL_DEBUF = 2;
const SKILL_TOGGLE = 3;
const SKILL_SONG_DANCE = 4;
const SKILL_ITEM = 5;
const SKILL_HERO = 6;
const SKILL_CHANGE = 7;
const SKILLTYPE_ALCHEMYSKILL = 140;
const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -17;

var WindowHandle m_wndTop;
var WindowHandle m_wndSkillDrawWnd;
var bool m_bShow;
var string m_WindowName;
var int currentUserLevel;
var WindowHandle Drawer;
var L2Util util;
var bool bDrawBgTree1;
var bool bDrawBgTree2;
var bool bDrawBgTree3;
var string TREENAME;
var string ROOTNAME;
var string LIST1;
var string LIST2;
var string LIST3;
var int selectedRequestLevel;
var int totalSkillCount;
var int addCount;
var string beforeTreeName;
var int nScrollHeight;
var TreeHandle m_UITree;
var array<string> treeNodeNameNewSkillArray;
var array<string> treeNodeNameLevelUpArray;
var string clickedTreeNodeName;
var array<SkillTrainInfo> skillTrainInfoArray;
var int clickedTreeNodeIndex;
var WindowHandle SkillTrainInfoWndScript;
var int levelUpSkillIndex;
var int newSkillIndex;
var UserInfo PlayerInfo;
var bool bRefreshSelect;
var int mainLevel;

function OnRegisterEvent()
{
    RegisterEvent(2010);
    RegisterEvent(2030);
    RegisterEvent(180);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    OnRegisterEvent();
    InitHandle();
    util = L2Util(GetScript("L2Util"));
    SkillTrainInfoWndScript = GetWindowHandle("AlchemySkillLearnWnd");
    m_bShow = false;
    return;
}

function InitHandle()
{
    m_UITree = GetTreeHandle("AlchemySkillWnd.SkillTrainTree");
    return;
}

function OnShow()
{
    GetPlayerInfo(PlayerInfo);
    currentUserLevel = PlayerInfo.nLevel;
    clickedTreeNodeName = "";
    clickedTreeNodeIndex = -1;
    m_bShow = true;
    return;
}

function OnHide()
{
    m_bShow = false;
    // End:0x57
    if(GetWindowHandle("AlchemySkillLearnWnd").IsShowWindow())
    {
        GetWindowHandle("AlchemySkillLearnWnd").HideWindow();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int iType;

    switch(Event_ID)
    {
        // End:0x120
        case 2010:
            ParseInt(param, "Type", iType);
            // End:0x11D
            if(iType == 140)
            {
                ParseInt(param, "Count", totalSkillCount);
                // End:0x86
                if(totalSkillCount == 0)
                {
                    // End:0x84
                    if(IsShowWindow("AlchemySkillWnd"))
                    {
                        HideWindow("AlchemySkillWnd");
                    }
                    return;
                }
                GetPlayerInfo(PlayerInfo);
                currentUserLevel = PlayerInfo.nLevel;
                TreeClear();
                ShowSkillTree();
                levelUpSkillIndex = 0;
                newSkillIndex = 0;
                bRefreshSelect = false;
                treeNodeNameNewSkillArray.Remove(0, treeNodeNameNewSkillArray.Length);
                treeNodeNameLevelUpArray.Remove(0, treeNodeNameLevelUpArray.Length);
                skillTrainInfoArray.Remove(0, skillTrainInfoArray.Length);
                // End:0x11D
                if(!IsShowWindow("AlchemySkillWnd"))
                {
                    ShowWindow("AlchemySkillWnd");
                }
            }
            // End:0x1E2
            break;
        // End:0x177
        case 2030:
            Debug("스킬 추가" @ param);
            ParseInt(param, "iType", iType);
            // End:0x174
            if(iType == 140)
            {
                AddSkillTrainListItem(param);
                buildTree();
            }
            // End:0x1E2
            break;
        // End:0x1DF
        case 180:
            GetPlayerInfo(PlayerInfo);
            // End:0x1CC
            if(currentUserLevel != PlayerInfo.nLevel)
            {
                // End:0x1CC
                if(IsShowWindow("AlchemySkillWnd"))
                {
                    HideWindow("AlchemySkillWnd");
                }
            }
            currentUserLevel = PlayerInfo.nLevel;
            // End:0x1E2
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function buildTree()
{
    local int i;
    local bool bGetInfo;

    // End:0x125
    if(skillTrainInfoArray.Length >= totalSkillCount)
    {
        quickSortChar(0, skillTrainInfoArray.Length - 1, false);
        i = 0;
        J0x28:

        // End:0x125 [Loop If]
        if(i < skillTrainInfoArray.Length)
        {
            createTreeNode(skillTrainInfoArray[i]);
            switch(Left(clickedTreeNodeName, 15))
            {
                // End:0xB6
                case "root.SKILLLIST1":
                    // End:0xB3
                    if((bGetInfo == false) && (treeNodeNameNewSkillArray.Length - 1) >= clickedTreeNodeIndex)
                    {
                        beforeTreeName = treeNodeNameNewSkillArray[clickedTreeNodeIndex];
                        OnClickButton(treeNodeNameNewSkillArray[clickedTreeNodeIndex]);
                        bGetInfo = true;
                    }
                    // End:0x11B
                    break;
                // End:0x118
                case "root.SKILLLIST2":
                    // End:0x115
                    if((bGetInfo == false) && (treeNodeNameLevelUpArray.Length - 1) >= clickedTreeNodeIndex)
                    {
                        beforeTreeName = treeNodeNameLevelUpArray[clickedTreeNodeIndex];
                        OnClickButton(treeNodeNameLevelUpArray[clickedTreeNodeIndex]);
                        bGetInfo = true;
                    }
                    // End:0x11B
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            i++;
            // [Loop Continue]
            goto J0x28;
        }
    }
    return;
}

function OnClickButton(string strID)
{
    local array<string> Result;
    local string treelist;
    local array<string> SkillIDLevel;

    treelist = Left(strID, 4);
    // End:0x159
    if(treelist == ROOTNAME)
    {
        Split(strID, ".", Result);
        // End:0x159
        if(Result.Length > 2)
        {
            // End:0xAC
            if((Result[1] == LIST1) || Result[1] == LIST2)
            {
                // End:0x89
                if(beforeTreeName != strID)
                {
                    m_UITree.SetExpandedNode(beforeTreeName, false);                    
                }
                else
                {
                    m_UITree.SetExpandedNode(beforeTreeName, true);
                }
                beforeTreeName = strID;                
            }
            else
            {
                m_UITree.SetExpandedNode(strID, false);
            }
            // End:0x159
            if((Result[1] == LIST1) || Result[1] == LIST2)
            {
                Split(Result[2], ",", SkillIDLevel);
                clickedTreeNodeName = strID;
                clickedTreeNodeIndex = int(SkillIDLevel[2]);
                Debug("-------> RequestAcquireSkillInfo");
                RequestAcquireSkillInfo(int(SkillIDLevel[0]), int(SkillIDLevel[1]), 0, 140);
            }
        }
    }
    return;
}

function TreeClear()
{
    Class'NWindow.UIAPI_TREECTRL'.static.Clear(TREENAME);
    return;
}

function ShowSkillTree()
{
    util.TreeHandleInsertRootNode(m_UITree, ROOTNAME, "", 0, 4);
    util.TreeHandleInsertExpandBtnNode(m_UITree, LIST1, ROOTNAME);
    util.TreeHandleInsertTextNodeItem(m_UITree, (ROOTNAME $ ".") $ LIST1, GetSystemString(2370), 5, 0, util.0, true);
    util.TreeHandleInsertExpandBtnNode(m_UITree, LIST2, ROOTNAME);
    util.TreeHandleInsertTextNodeItem(m_UITree, (ROOTNAME $ ".") $ LIST2, GetSystemString(2371), 5, 0, util.0, true);
    util.TreeHandleInsertExpandBtnNode(m_UITree, LIST3, ROOTNAME);
    util.TreeHandleInsertTextNodeItem(m_UITree, (ROOTNAME $ ".") $ LIST3, GetSystemString(2372), 5, 0, util.0, true);
    m_UITree.SetExpandedNode((ROOTNAME $ ".") $ LIST1, true);
    m_UITree.SetExpandedNode((ROOTNAME $ ".") $ LIST2, true);
    m_UITree.SetExpandedNode((ROOTNAME $ ".") $ LIST3, true);
    return;
}

function int getSkillRequestLevel(int nSkillID, int nSkillLevel)
{
    local int i, RValue;

    RValue = -1;
    i = 0;
    J0x12:

    // End:0x7B [Loop If]
    if(i < skillTrainInfoArray.Length)
    {
        // End:0x71
        if((skillTrainInfoArray[i].Id == nSkillID) && skillTrainInfoArray[i].Level == nSkillLevel)
        {
            RValue = skillTrainInfoArray[i].requiredLevel;
            // [Explicit Break]
            goto J0x7B;
        }
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    J0x7B:

    return RValue;
    return;
}

function AddSkillTrainListItem(string param)
{
    local int Id, Level, SubLevel;
    local INT64 spConsume;
    local int requiredLevel;
    local string strName, strIconName, strEnchantName;
    local SkillTrainInfo Info;

    ParseString(param, "strIconName", strIconName);
    ParseString(param, "strName", strName);
    ParseString(param, "strEnchantName", strEnchantName);
    ParseInt(param, "iID", Id);
    ParseInt(param, "iLevel", Level);
    ParseInt(param, "iSubLevel", SubLevel);
    ParseInt(param, "iRequiredLevel", requiredLevel);
    ParseINT64(param, "iSPConsume", spConsume);
    // End:0xE7
    if(Id <= 0)
    {
        return;
    }
    addCount++;
    Info.Id = Id;
    Info.Level = Level;
    Info.SubLevel = SubLevel;
    Info.spConsume = spConsume;
    Info.requiredLevel = requiredLevel;
    Info.strName = strName;
    Info.strIconName = strIconName;
    Info.strEnchantName = strEnchantName;
    skillTrainInfoArray[skillTrainInfoArray.Length] = Info;
    return;
}

function createTreeNode(SkillTrainInfo Info)
{
    local SkillInfo SkillInfo;
    local string setTreeName, panelName;
    local int Level, Id, requiredLevel;
    local string strName, strIconName;
    local UserInfo UserInfo;
    local ItemID cID;
    local string strRetName;
    local CustomTooltip t;
    local bool isMaster;

    Id = Info.Id;
    requiredLevel = Info.requiredLevel;
    cID = GetItemID(Info.Id);
    GetSkillInfo(Info.Id, Info.Level, Info.SubLevel, SkillInfo);
    GetPlayerInfo(UserInfo);
    strName = SkillInfo.SkillName;
    strIconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(cID, Info.Level, Info.SubLevel);
    panelName = SkillInfo.IconPanel;
    Level = Info.Level;
    util.setCustomTooltip(t);
    util.ToopTipMinWidth(200);
    MakeSkillToolTip(strName, cID, Level, Info);
    // End:0x129
    if(GetAlchemySkillGradeType(Id, Level) == 4)
    {
        isMaster = true;        
    }
    else
    {
        isMaster = false;
    }
    // End:0x6C0
    if(requiredLevel <= PlayerInfo.nLevel)
    {
        // End:0x3FE
        if(Level == 1)
        {
            setTreeName = (ROOTNAME $ ".") $ LIST1;
            strRetName = util.TreeInsertItemTooltipNode(TREENAME, (((("" $ string(Id)) $ ",") $ string(Level)) $ ",") $ string(newSkillIndex), setTreeName, -7, 0, 38, 0, 30, 38, util.getCustomTooltip());
            treeNodeNameNewSkillArray[newSkillIndex] = strRetName;
            newSkillIndex++;
            // End:0x22E
            if(bDrawBgTree1)
            {
                util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 262, 38,,,,, 14);                
            }
            else
            {
                util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 262, 38);
            }
            bDrawBgTree1 = !bDrawBgTree1;
            util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
            util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, strIconName, 32, 32, -34, 4 - 1);
            // End:0x32C
            if(SkillInfo.IconPanel != "")
            {
                util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, panelName, 32, 32, -32, 4 - 1);
            }
            // End:0x366
            if(isMaster)
            {
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.12, true);                
            }
            else
            {
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.0, true);
            }
            util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, util.1, true, true);
            util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, util.2);            
        }
        else
        {
            // End:0x6BD
            if(requiredLevel <= PlayerInfo.nLevel)
            {
                setTreeName = (ROOTNAME $ ".") $ LIST2;
                strRetName = util.TreeInsertItemTooltipNode(TREENAME, (((("" $ string(Id)) $ ",") $ string(Level)) $ ",") $ string(levelUpSkillIndex), setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomTooltip());
                treeNodeNameLevelUpArray[levelUpSkillIndex] = strRetName;
                levelUpSkillIndex++;
                // End:0x4F0
                if(bDrawBgTree2)
                {
                    util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 257, 38,,,,, 14);                    
                }
                else
                {
                    util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 257, 38);
                }
                bDrawBgTree2 = !bDrawBgTree2;
                util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
                util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, strIconName, 32, 32, -34, 4 - 1);
                // End:0x5EE
                if(SkillInfo.IconPanel != "")
                {
                    util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, panelName, 32, 32, -32, 4 - 1);
                }
                // End:0x628
                if(isMaster)
                {
                    util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.12, true);                    
                }
                else
                {
                    util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.0, true);
                }
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, util.1, true, true);
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, util.2);
            }
        }        
    }
    else
    {
        setTreeName = (ROOTNAME $ ".") $ LIST3;
        strRetName = util.TreeInsertItemTooltipNode(TREENAME, (("" $ string(Id)) $ ",") $ string(Level), setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomTooltip());
        // End:0x778
        if(bDrawBgTree3)
        {
            util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CH3.etc.textbackline", 257, 38,,,,, 14);            
        }
        else
        {
            util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.EmptyBtn", 257, 38);
        }
        bDrawBgTree3 = !bDrawBgTree3;
        util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -251, 2);
        util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, strIconName, 32, 32, -34, 4 - 1);
        util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.ItemWindow_IconDisable", 32, 32, -32, 4 - 1);
        // End:0x8E2
        if((TypeCheck(SkillInfo)) == true)
        {
            util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -34, 4 - 1);            
        }
        else
        {
            util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -34, 4 - 1);
        }
        util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.0, true);
        util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(2381) $ " : ", 46, -17, util.1, true, true);
        util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(requiredLevel), 2, -17, util.3);
    }
    return;
}

function MakeSkillToolTip(string strName, ItemID Id, int Level, SkillTrainInfo pSkillTrainInfo)
{
    local SkillInfo SkillInfo;
    local int SkillID, requiredLevel, nTmp;

    // End:0x0D
    if(!m_bShow)
    {
        return;
    }
    SkillID = pSkillTrainInfo.Id;
    requiredLevel = pSkillTrainInfo.requiredLevel;
    GetSkillInfo(SkillID, Level, 0, SkillInfo);
    // End:0x7E
    if(GetAlchemySkillGradeType(SkillID, Level) == 4)
    {
        util.ToopTipInsertText(strName, true, false, util.4);        
    }
    else
    {
        util.ToopTipInsertText(strName, true, false, util.0);
    }
    util.ToopTipInsertText(" " $ GetSystemString(88), true, false, util.1);
    util.ToopTipInsertText(" " $ string(Level), true, false, util.2);
    util.ToopTipInsertText(Class'NWindow.UIDATA_SKILL'.static.GetOperateType(Id, Level, 0), true, true, util.2, 0, 6);
    util.TooltipInsertItemBlank(6);
    nTmp = Class'NWindow.UIDATA_SKILL'.static.GetHpConsume(Id, Level, 0);
    // End:0x19D
    if(nTmp > 0)
    {
        util.TwoWordCombineColon(GetSystemString(1195), string(nTmp), util.1, util.2, true);
    }
    nTmp = Class'NWindow.UIDATA_SKILL'.static.GetMpConsume(Id, Level, 0);
    // End:0x200
    if(nTmp > 0)
    {
        util.TwoWordCombineColon(GetSystemString(320), string(nTmp), util.1, util.2, true);
    }
    util.ToopTipInsertText(Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, Level, 0), false, true, util.1, 0, 6);
    util.TooltipInsertItemBlank(6);
    util.TooltipInsertItemLine();
    util.TooltipInsertItemBlank(3);
    util.ToopTipInsertText(("<" $ GetSystemString(2375)) $ ">", true, true);
    util.TwoWordCombineColon(GetSystemString(2381), string(requiredLevel), util.1, util.2, true);
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

function closeTreeNode()
{
    m_UITree.SetExpandedNode(beforeTreeName, false);
    beforeTreeName = "";
    return;
}

function quickSortChar(int Left, int Right, bool Desc)
{
    local int q;

    // End:0x17
    if((Right - Left) == 0)
    {
        return;        
    }
    else
    {
        // End:0x74
        if(Left < Right)
        {
            q = partitionChar(Left, Right, Desc);
            quickSortChar(Left, q - 1, Desc);
            quickSortChar(q + 1, Right, Desc);
        }
    }
    return;
}

function int partitionChar(int Low, int High, bool Desc)
{
    local string pivot, temp;
    local int i, j;

    pivot = Caps(string(skillTrainInfoArray[Low].Level));
    j = Low;
    i = Low + 1;
    J0x33:

    // End:0xBE [Loop If]
    if(i <= High)
    {
        temp = Caps(string(skillTrainInfoArray[i].Level));
        // End:0x8E
        if(Desc)
        {
            // End:0x8B
            if(temp > pivot)
            {
                j++;
                swap(i, j);
            }
            // [Explicit Continue]
            goto J0xB4;
        }
        // End:0xB4
        if(temp < pivot)
        {
            j++;
            swap(i, j);
        }
        J0xB4:

        i++;
        // [Loop Continue]
        goto J0x33;
    }
    swap(Low, j);
    return j;
    return;
}

function swap(int i, int j)
{
    local SkillTrainInfo Info;

    Info = skillTrainInfoArray[i];
    skillTrainInfoArray[i] = skillTrainInfoArray[j];
    skillTrainInfoArray[j] = Info;
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
    m_WindowName="AlchemySkillWnd"
    TREENAME="AlchemySkillWnd.SkillTrainTree"
    ROOTNAME="root"
    LIST1="SKILLLIST1"
    LIST2="SKILLLIST2"
    LIST3="SKILLLIST3"
}