class MagicSkillWnd extends UICommonAPI;

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
const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -17;

struct SubjobInfo
{
    var int Id;
    var int ClassID;
    var int Level;
    var int Type;
};

var WindowHandle m_wndTop;
var WindowHandle m_wndSkillDrawWnd;
var WindowHandle m_wndName[8];
var TextBoxHandle m_NameStr[8];
var TextureHandle m_NameBtn[8];
var TextureHandle m_ItemBg[8];
var WindowHandle m_wnd[8];
var ItemWindowHandle m_Item[8];
var ButtonHandle m_HiddenBtn[8];
var WindowHandle areaScroll;
var WindowHandle m_wndName_p[6];
var TextBoxHandle m_NameStr_p[6];
var TextureHandle m_NameBtn_p[6];
var TextureHandle m_ItemBg_p[6];
var WindowHandle m_wnd_p[6];
var ItemWindowHandle m_Item_p[6];
var ButtonHandle m_HiddenBtn_p[6];
var WindowHandle areaScroll_p;
var bool m_bShow;
var string m_WindowName;
var int m_bExistSkill[8];
var int nScrollHeight;
var int m_bExistSkill_p[6];
var int nScrollHeight_p;
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
var string beforeTreeName;
var AnimTextureHandle TexTabLightActive;
var AnimTextureHandle TexTabLightPassive;
var TreeHandle m_UITree;
var ButtonHandle ResearchButton;
var array<string> treeNodeNameNewSkillArray;
var array<string> treeNodeNameLevelUpArray;
var string clickedTreeNodeName;
var int clickedTreeNodeIndex;
var WindowHandle SkillTrainInfoWndScript;
var int levelUpSkillIndex;
var int newSkillIndex;
var array<SubjobInfo> subjobInfoArray;
var SubjobInfo beforeSubjobInfo;
var bool isDualClass;
var int mainLevel;
var int dualLevel;
var int currentType;

function OnRegisterEvent()
{
    RegisterEvent(1280);
    RegisterEvent(1290);
    RegisterEvent(1900);
    RegisterEvent(2064);
    RegisterEvent(5360);
    RegisterEvent(2055);
    RegisterEvent(2056);
    RegisterEvent(2057);
    RegisterEvent(1291);
    RegisterEvent(2059);
    RegisterEvent(5310);
    RegisterEvent(5311);
    RegisterEvent(5312);
    RegisterEvent(180);
    RegisterEvent(8000);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    InitHandle();
    util = L2Util(GetScript("L2Util"));
    SkillTrainInfoWndScript = GetWindowHandle("SkillLearnWnd");
    m_bShow = false;
    // End:0x6A
    if(getInstanceUIData().getIsArenaServer())
    {
        ResearchButton.HideWindow();
    }
    return;
}

function InitHandle()
{
    local int i;

    m_UITree = GetTreeHandle("MagicSkillWnd.SkillTrainTree");
    m_wndTop = GetWindowHandle(m_WindowName);
    Drawer = GetWindowHandle("MagicSkillDrawerWnd");
    areaScroll = GetWindowHandle(m_WindowName $ ".ASkillScroll");
    areaScroll_p = GetWindowHandle(m_WindowName $ ".PSkillScroll");
    TexTabLightActive = GetAnimTextureHandle("MagicSkillWnd.TexTabLightActive");
    TexTabLightPassive = GetAnimTextureHandle("MagicSkillWnd.TexTabLightPassive");
    ResearchButton = GetButtonHandle("MagicSkillWnd.ResearchButton");
    i = 0;
    J0x12C:

    // End:0x348 [Loop If]
    if(i < 8)
    {
        m_wndName[i] = GetWindowHandle((m_WindowName $ ".ASkill.ASkillName") $ string(i));
        m_wnd[i] = GetWindowHandle((m_WindowName $ ".ASkill.ASkill") $ string(i));
        m_NameStr[i] = GetTextBoxHandle((((m_WindowName $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillNameStr") $ string(i));
        m_NameBtn[i] = GetTextureHandle((((m_WindowName $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillBtn") $ string(i));
        m_Item[i] = GetItemWindowHandle((((m_WindowName $ ".ASkill.ASkill") $ string(i)) $ ".ASkillItem") $ string(i));
        m_ItemBg[i] = GetTextureHandle((((m_WindowName $ ".ASkill.ASkill") $ string(i)) $ ".ASkillSlotBg") $ string(i));
        m_HiddenBtn[i] = GetButtonHandle((((m_WindowName $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillHiddenBtn") $ string(i));
        m_HiddenBtn[i].SetAlpha(255);
        i++;
        // [Loop Continue]
        goto J0x12C;
    }
    i = 0;
    J0x34F:

    // End:0x56B [Loop If]
    if(i < 6)
    {
        m_wndName_p[i] = GetWindowHandle((m_WindowName $ ".PSkill.PSkillName") $ string(i));
        m_wnd_p[i] = GetWindowHandle((m_WindowName $ ".PSkill.PSkill") $ string(i));
        m_NameStr_p[i] = GetTextBoxHandle((((m_WindowName $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillNameStr") $ string(i));
        m_NameBtn_p[i] = GetTextureHandle((((m_WindowName $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillBtn") $ string(i));
        m_Item_p[i] = GetItemWindowHandle((((m_WindowName $ ".PSkill.PSkill") $ string(i)) $ ".PSkillItem") $ string(i));
        m_ItemBg_p[i] = GetTextureHandle((((m_WindowName $ ".PSkill.PSkill") $ string(i)) $ ".PSkillSlotBg") $ string(i));
        m_HiddenBtn_p[i] = GetButtonHandle((((m_WindowName $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillHiddenBtn") $ string(i));
        m_HiddenBtn_p[i].SetAlpha(255);
        i++;
        // [Loop Continue]
        goto J0x34F;
    }
    TexTabLightActive.HideWindow();
    TexTabLightPassive.HideWindow();
    return;
}

function OnShow()
{
    clickedTreeNodeName = "";
    clickedTreeNodeIndex = -1;
    RequestSkillList();
    m_bShow = true;
    return;
}

function OnHide()
{
    m_bShow = false;
    MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).setMagicSkillItemsType(false);
    MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).OnTextureAnimEnd(MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).EnchantProgressAnim);
    // End:0xD3
    if(Drawer.IsShowWindow())
    {
        Drawer.HideWindow();
        MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).isHiding = true;
    }
    SkillTrainInfoWndScript.HideWindow();
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int NewSkillID;
    local SkillInfo SkillInfo;
    local UserInfo UserInfo;

    // End:0x18
    if(Event_ID == 1280)
    {
        HandleSkillListStart();        
    }
    else
    {
        // End:0x6B
        if(Event_ID == 180)
        {
            GetPlayerInfo(UserInfo);
            // End:0x4D
            if(currentType == 0)
            {
                mainLevel = UserInfo.nLevel;                
            }
            else
            {
                // End:0x68
                if(currentType == 1)
                {
                    dualLevel = UserInfo.nLevel;
                }
            }            
        }
        else
        {
            // End:0x8D
            if(Event_ID == 5310)
            {
                updateSubjobInfo(param, Event_ID);                
            }
            else
            {
                // End:0xAF
                if(Event_ID == 5311)
                {
                    updateSubjobInfo(param, Event_ID);                    
                }
                else
                {
                    // End:0xFA
                    if(Event_ID == 5312)
                    {
                        updateSubjobInfo(param, Event_ID);
                        ExecuteEvent(3280);
                        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MagicSkillWnd");                        
                    }
                    else
                    {
                        // End:0x117
                        if(Event_ID == 1290)
                        {
                            HandleSkillList(param);                            
                        }
                        else
                        {
                            // End:0x12F
                            if(Event_ID == 1900)
                            {
                                HandleLanguageChanged();                                
                            }
                            else
                            {
                                // End:0x147
                                if(Event_ID == 5360)
                                {
                                    ApplySkillAvailability();                                    
                                }
                                else
                                {
                                    // End:0x18D
                                    if(Event_ID == 2055)
                                    {
                                        TreeClear();
                                        ShowSkillTree();
                                        levelUpSkillIndex = 0;
                                        newSkillIndex = 0;
                                        treeNodeNameNewSkillArray.Remove(0, treeNodeNameNewSkillArray.Length);
                                        treeNodeNameLevelUpArray.Remove(0, treeNodeNameLevelUpArray.Length);                                        
                                    }
                                    else
                                    {
                                        // End:0x1AA
                                        if(Event_ID == 2056)
                                        {
                                            AddSkillTrainListItem(param);                                            
                                        }
                                        else
                                        {
                                            // End:0x28F
                                            if(Event_ID == 1291)
                                            {
                                                ComputeItemWndHeight();
                                                ComputeItemWndAnchor();
                                                ParseInt(param, "NewSkillID", NewSkillID);
                                                GetSkillInfo(NewSkillID, 1, 0, SkillInfo);
                                                // End:0x28C
                                                if(NewSkillID != 0)
                                                {
                                                    // End:0x24F
                                                    if((TypeCheck(SkillInfo)) == true)
                                                    {
                                                        TexTabLightActive.ShowWindow();
                                                        TexTabLightActive.SetLoopCount(1);
                                                        TexTabLightActive.Stop();
                                                        TexTabLightActive.Play();                                                        
                                                    }
                                                    else
                                                    {
                                                        TexTabLightPassive.ShowWindow();
                                                        TexTabLightPassive.SetLoopCount(1);
                                                        TexTabLightPassive.Stop();
                                                        TexTabLightPassive.Play();
                                                    }
                                                }                                                
                                            }
                                            else
                                            {
                                                // End:0x2A7
                                                if(Event_ID == 2059)
                                                {
                                                    RequestSkillList();                                                    
                                                }
                                                else
                                                {
                                                    // End:0x375
                                                    if(Event_ID == 2057)
                                                    {
                                                        switch(Left(clickedTreeNodeName, 15))
                                                        {
                                                            // End:0x320
                                                            case "root.SKILLLIST1":
                                                                // End:0x31D
                                                                if((treeNodeNameNewSkillArray.Length - 1) >= clickedTreeNodeIndex)
                                                                {
                                                                    beforeTreeName = treeNodeNameNewSkillArray[clickedTreeNodeIndex];
                                                                    // End:0x31D
                                                                    if((treeNodeNameNewSkillArray.Length - 1) != clickedTreeNodeIndex)
                                                                    {
                                                                        OnClickButton(treeNodeNameNewSkillArray[clickedTreeNodeIndex]);
                                                                    }
                                                                }
                                                                // End:0x372
                                                                break;
                                                            // End:0x36C
                                                            case "root.SKILLLIST2":
                                                                // End:0x369
                                                                if((treeNodeNameLevelUpArray.Length - 1) >= clickedTreeNodeIndex)
                                                                {
                                                                    beforeTreeName = treeNodeNameLevelUpArray[clickedTreeNodeIndex];
                                                                    OnClickButton(treeNodeNameLevelUpArray[clickedTreeNodeIndex]);
                                                                }
                                                                // End:0x372
                                                                break;
                                                            // End:0xFFFF
                                                            default:
                                                                // End:0x372
                                                                break;
                                                                break;
                                                        }                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x38A
                                                        if(Event_ID == 8000)
                                                        {
                                                            checkClassicForm();
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

function checkClassicForm()
{
    // End:0x2A
    if(getInstanceUIData().getIsClassicServer())
    {
        ResearchButton.SetButtonName(646);        
    }
    else
    {
        ResearchButton.SetButtonName(2070);
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo infItem;
    local int groupID;
    local MagicSkillDrawerWnd script_a;

    // End:0xC9
    if((InStr(strID, "ASkillItem") > -1) && Index > -1)
    {
        groupID = int(Right(strID, 1));
        // End:0xC9
        if(m_Item[groupID].GetItem(Index, infItem))
        {
            // End:0xAF
            if(Drawer.IsShowWindow())
            {
                script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));
                script_a.handleSetCurrentSkill(infItem);                
            }
            else
            {
                UseSkill(infItem.Id, infItem.ItemSubType);
            }
        }
    }
    return;
}

function OnClickButton(string strID)
{
    local int i, Index, nWndWidth, nWndHeight;
    local MagicSkillDrawerWnd script_a;
    local array<string> Result;
    local string treelist;
    local array<string> SkillIDLevel;

    Index = int(Right(strID, 1));
    treelist = Left(strID, 4);
    // End:0x305
    if(InStr(strID, "ASkillHiddenBtn") > -1)
    {
        // End:0x193
        if(m_bExistSkill[Index] == 1)
        {
            m_wnd[Index].GetWindowSize(nWndWidth, nWndHeight);
            nScrollHeight = (nScrollHeight - nWndHeight) - 3;
            m_NameBtn[Index].SetTexture("l2ui_ch3.QuestWnd.QuestWndPlusBtn");
            m_bExistSkill[Index] = 2;
            m_wnd[Index].HideWindow();
            // End:0x190
            if(Index < 8)
            {
                i = Index + 1;
                J0xFC:

                // End:0x190 [Loop If]
                if(i < 8)
                {
                    // End:0x186
                    if(m_bExistSkill[i] > 0)
                    {
                        m_wndName[i].ClearAnchor();
                        m_wndName[i].SetAnchor((m_WindowName $ ".ASkill.ASkillName") $ string(Index), "BottomCenter", "TopCenter", 0, 5);
                        // [Explicit Break]
                        goto J0x190;
                    }
                    i++;
                    // [Loop Continue]
                    goto J0xFC;
                }
            }
            J0x190:
            
        }
        else
        {
            // End:0x2EE
            if(m_bExistSkill[Index] == 2)
            {
                m_wnd[Index].GetWindowSize(nWndWidth, nWndHeight);
                nScrollHeight = (nScrollHeight + nWndHeight) + 3;
                m_NameBtn[Index].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
                m_bExistSkill[Index] = 1;
                m_wnd[Index].ShowWindow();
                // End:0x2EE
                if(Index < 8)
                {
                    i = Index + 1;
                    J0x24F:

                    // End:0x2EE [Loop If]
                    if(i < 8)
                    {
                        // End:0x2E4
                        if(m_bExistSkill[i] > 0)
                        {
                            m_wndName[i].ClearAnchor();
                            m_wndName[i].SetAnchor((m_WindowName $ ".ASkill.ASkillName") $ string(Index), "BottomCenter", "TopCenter", 0, (nWndHeight + 3) + 5);
                            // [Explicit Break]
                            goto J0x2EE;
                        }
                        i++;
                        // [Loop Continue]
                        goto J0x24F;
                    }
                }
            }
        }
        J0x2EE:

        areaScroll.SetScrollHeight(nScrollHeight);        
    }
    else
    {
        // End:0x5EB
        if(InStr(strID, "PSkillHiddenBtn") > -1)
        {
            // End:0x479
            if(m_bExistSkill_p[Index] == 1)
            {
                m_wnd_p[Index].GetWindowSize(nWndWidth, nWndHeight);
                nScrollHeight_p = (nScrollHeight_p - nWndHeight) - 3;
                m_NameBtn_p[Index].SetTexture("l2ui_ch3.QuestWnd.QuestWndPlusBtn");
                m_bExistSkill_p[Index] = 2;
                m_wnd_p[Index].HideWindow();
                // End:0x476
                if(Index < 6)
                {
                    i = Index + 1;
                    J0x3E2:

                    // End:0x476 [Loop If]
                    if(i < 6)
                    {
                        // End:0x46C
                        if(m_bExistSkill_p[i] > 0)
                        {
                            m_wndName_p[i].ClearAnchor();
                            m_wndName_p[i].SetAnchor((m_WindowName $ ".PSkill.PSkillName") $ string(Index), "BottomCenter", "TopCenter", 0, 5);
                            // [Explicit Break]
                            goto J0x476;
                        }
                        i++;
                        // [Loop Continue]
                        goto J0x3E2;
                    }
                }
                J0x476:
                
            }
            else
            {
                // End:0x5D4
                if(m_bExistSkill_p[Index] == 2)
                {
                    m_wnd_p[Index].GetWindowSize(nWndWidth, nWndHeight);
                    nScrollHeight_p = (nScrollHeight_p + nWndHeight) + 3;
                    m_NameBtn_p[Index].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
                    m_bExistSkill_p[Index] = 1;
                    m_wnd_p[Index].ShowWindow();
                    // End:0x5D4
                    if(Index < 6)
                    {
                        i = Index + 1;
                        J0x535:

                        // End:0x5D4 [Loop If]
                        if(i < 6)
                        {
                            // End:0x5CA
                            if(m_bExistSkill_p[i] > 0)
                            {
                                m_wndName_p[i].ClearAnchor();
                                m_wndName_p[i].SetAnchor((m_WindowName $ ".PSkill.PSkillName") $ string(Index), "BottomCenter", "TopCenter", 0, (nWndHeight + 3) + 5);
                                // [Explicit Break]
                                goto J0x5D4;
                            }
                            i++;
                            // [Loop Continue]
                            goto J0x535;
                        }
                    }
                }
            }
            J0x5D4:

            areaScroll_p.SetScrollHeight(nScrollHeight_p);            
        }
        else
        {
            // End:0x703
            if(strID == "ResearchButton")
            {
                // End:0x639
                if(getInstanceUIData().getIsClassicServer())
                {
                    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MagicSkillWnd");                    
                }
                else
                {
                    script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));
                    // End:0x6B9
                    if(Drawer.IsShowWindow())
                    {
                        Drawer.HideWindow();
                        script_a.isHiding = true;
                        script_a.setMagicSkillItemsType(false);
                        script_a.SkillInfoClear();
                        RequestSkillList();                        
                    }
                    else
                    {
                        Drawer.ShowWindow();
                        script_a.SkillInfoClear();
                        script_a.txtMySp.SetText(MakeCostString((GetuserSP())));
                        RequestSkillList();
                    }
                }
            }
        }
    }
    // End:0x82D
    if(treelist == ROOTNAME)
    {
        Split(strID, ".", Result);
        // End:0x82D
        if(Result.Length > 2)
        {
            // End:0x7A0
            if((Result[1] == LIST1) || Result[1] == LIST2)
            {
                // End:0x77D
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
            // End:0x82D
            if((Result[1] == LIST1) || Result[1] == LIST2)
            {
                Split(Result[2], ",", SkillIDLevel);
                clickedTreeNodeName = strID;
                clickedTreeNodeIndex = int(SkillIDLevel[2]);
                RequestAcquireSkillInfo(int(SkillIDLevel[0]), int(SkillIDLevel[1]), int(SkillIDLevel[3]), 0);
            }
        }
    }
    // End:0x886
    if(strID == "TabCtrl0")
    {
        // End:0x865
        if(!getInstanceUIData().getIsArenaServer())
        {
            ResearchButton.ShowWindow();
        }
        TexTabLightActive.HideWindow();
        SkillTrainInfoWndScript.HideWindow();        
    }
    else
    {
        // End:0x8DF
        if(strID == "TabCtrl1")
        {
            // End:0x8BE
            if(!getInstanceUIData().getIsArenaServer())
            {
                ResearchButton.ShowWindow();
            }
            TexTabLightPassive.HideWindow();
            SkillTrainInfoWndScript.HideWindow();            
        }
        else
        {
            // End:0x9AA
            if(strID == "TabCtrl2")
            {
                // End:0x99B
                if(Drawer.IsShowWindow())
                {
                    Drawer.HideWindow();
                    MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).isHiding = true;
                    MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).SkillInfoClear();
                    MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd")).setMagicSkillItemsType(false);
                    RequestSkillList();
                }
                ResearchButton.HideWindow();
            }
        }
    }
    return;
}

function HandleLanguageChanged()
{
    RequestSkillList();
    return;
}

function ApplySkillAvailability()
{
    local int i, j, ItemNum, Id, Level, SubLevel,
	    SkillDisabled;

    i = 0;
    J0x07:

    // End:0xD3 [Loop If]
    if(i < 8)
    {
        ItemNum = m_Item[i].GetItemNum();
        j = 0;
        J0x35:

        // End:0xC9 [Loop If]
        if(j < ItemNum)
        {
            m_Item[i].GetItemIdLevel(j, Id, Level, SubLevel);
            // End:0xBF
            if((Id > 0) && Level > 0)
            {
                SkillDisabled = GetSkillAvailability(Id, Level, SubLevel);
                m_Item[i].SetItemSkillDisabled(j, SkillDisabled);
            }
            ++j;
            // [Loop Continue]
            goto J0x35;
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    i = 8;
    J0xDB:

    // End:0x1B3 [Loop If]
    if(i < 14)
    {
        ItemNum = m_Item_p[i - 8].GetItemNum();
        j = 0;
        J0x10D:

        // End:0x1A9 [Loop If]
        if(j < ItemNum)
        {
            m_Item_p[i - 8].GetItemIdLevel(j, Id, Level, SubLevel);
            // End:0x19F
            if((Id > 0) && Level > 0)
            {
                SkillDisabled = GetSkillAvailability(Id, Level, SubLevel);
                m_Item_p[i - 8].SetItemSkillDisabled(j, SkillDisabled);
            }
            ++j;
            // [Loop Continue]
            goto J0x10D;
        }
        ++i;
        // [Loop Continue]
        goto J0xDB;
    }
    return;
}

function HandleSkillListStart()
{
    Clear();
    return;
}

function Clear()
{
    local int i;

    i = 0;
    J0x07:

    // End:0xA2 [Loop If]
    if(i < 8)
    {
        m_bExistSkill[i] = 0;
        m_NameBtn[i].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
        m_wnd[i].HideWindow();
        m_wndName[i].HideWindow();
        m_Item[i].super(MagicSkillWnd).Clear();
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    i = 0;
    J0xA9:

    // End:0x144 [Loop If]
    if(i < 6)
    {
        m_bExistSkill_p[i] = 0;
        m_NameBtn_p[i].SetTexture("l2ui_ch3.QuestWnd.QuestWndMinusBtn");
        m_wnd_p[i].HideWindow();
        m_wndName_p[i].HideWindow();
        m_Item_p[i].super(MagicSkillWnd).Clear();
        i++;
        // [Loop Continue]
        goto J0xA9;
    }
    return;
}

function HandleSkillList(string param)
{
    local int tmp, SkillLevel, SkillSubLevel, Lock;
    local string strIconName, strSkillName, strDescription, strEnchantName, strCommand, strIconPanel;

    local int iCanEnchant, ReuseDelayShareGroupID, iSkillDisabled;
    local ItemInfo infItem;

    ParseItemID(param, infItem.Id);
    // End:0x81
    if((((infItem.Id.ClassID == 52000) || infItem.Id.ClassID == 52001) || infItem.Id.ClassID == 52002) || infItem.Id.ClassID == 52003)
    {
        return;
    }
    ParseInt(param, "Type", tmp);
    ParseInt(param, "Level", SkillLevel);
    ParseInt(param, "SubLevel", SkillSubLevel);
    ParseInt(param, "Lock", Lock);
    ParseString(param, "Name", strSkillName);
    ParseString(param, "IconName", strIconName);
    ParseString(param, "IconPanel", strIconPanel);
    ParseString(param, "Description", strDescription);
    ParseString(param, "EnchantName", strEnchantName);
    ParseString(param, "Command", strCommand);
    ParseInt(param, "CanEnchant", iCanEnchant);
    ParseInt(param, "ReuseDelayShareGroupID", ReuseDelayShareGroupID);
    ParseInt(param, "iSkillDisabled", iSkillDisabled);
    infItem.Level = SkillLevel;
    infItem.SubLevel = SkillSubLevel;
    infItem.Name = strSkillName;
    infItem.AdditionalName = strEnchantName;
    infItem.IconName = strIconName;
    infItem.IconPanel = strIconPanel;
    infItem.Description = strDescription;
    infItem.ItemSubType = 2;
    infItem.MacroCommand = strCommand;
    infItem.ReuseDelayShareGroupID = ReuseDelayShareGroupID;
    infItem.iSkillDisabled = iSkillDisabled;
    // End:0x2A8
    if(Lock > 0)
    {
        infItem.bIsLock = true;        
    }
    else
    {
        infItem.bIsLock = false;
    }
    infItem.Reserved = iCanEnchant;
    // End:0x2FD
    if(Drawer.IsShowWindow())
    {
        // End:0x2F1
        if(iCanEnchant > 0)
        {
            infItem.bDisabled = 0;            
        }
        else
        {
            infItem.bDisabled = 1;
        }
    }
    GroupingSkill(infItem.Id.ClassID, SkillLevel, SkillSubLevel, infItem);
    return;
}

function ComputeItemWndHeight()
{
    local int i, nItemNum, nItemWndHeight, nWndWidth;

    nScrollHeight = 0;
    i = 0;
    J0x0E:

    // End:0x1B0 [Loop If]
    if(i < 8)
    {
        nItemNum = m_Item[i].GetItemNum();
        // End:0x8A
        if(nItemNum < 1)
        {
            m_bExistSkill[i] = 0;
            m_wnd[i].GetWindowSize(nWndWidth, nItemWndHeight);
            m_wnd[i].SetWindowSize(nWndWidth, 0);
            // [Explicit Continue]
            goto J0x1A6;
        }
        m_bExistSkill[i] = 1;
        nItemWndHeight = (((((nItemNum - 1) / 7) + 1) * 32) + (((nItemNum - 1) / 7) * 4)) + 12;
        m_wnd[i].SetWindowSize(260, nItemWndHeight);
        m_ItemBg[i].SetWindowSize(252, nItemWndHeight - 8);
        m_Item[i].SetRow(((nItemNum - 1) / 7) + 2);
        // End:0x159
        if(!m_wnd[i].IsShowWindow())
        {
            m_wnd[i].ShowWindow();
        }
        // End:0x188
        if(!m_wndName[i].IsShowWindow())
        {
            m_wndName[i].ShowWindow();
        }
        nScrollHeight = (((nScrollHeight + 5) + 20) + 3) + nItemWndHeight;
        J0x1A6:

        i++;
        // [Loop Continue]
        goto J0x0E;
    }
    // End:0x1D6
    if(areaScroll.IsShowWindow())
    {
        areaScroll.SetScrollHeight(nScrollHeight);
    }
    // End:0x1FA
    if(!areaScroll.IsShowWindow())
    {
        areaScroll.SetScrollPosition(0);
    }
    nScrollHeight_p = 0;
    i = 0;
    J0x208:

    // End:0x3AA [Loop If]
    if(i < 6)
    {
        nItemNum = m_Item_p[i].GetItemNum();
        // End:0x284
        if(nItemNum < 1)
        {
            m_bExistSkill_p[i] = 0;
            m_wnd_p[i].GetWindowSize(nWndWidth, nItemWndHeight);
            m_wnd_p[i].SetWindowSize(nWndWidth, 0);
            // [Explicit Continue]
            goto J0x3A0;
        }
        m_bExistSkill_p[i] = 1;
        nItemWndHeight = (((((nItemNum - 1) / 7) + 1) * 32) + (((nItemNum - 1) / 7) * 4)) + 12;
        m_wnd_p[i].SetWindowSize(260, nItemWndHeight);
        m_ItemBg_p[i].SetWindowSize(252, nItemWndHeight - 8);
        m_Item_p[i].SetRow(((nItemNum - 1) / 7) + 2);
        // End:0x353
        if(!m_wnd_p[i].IsShowWindow())
        {
            m_wnd_p[i].ShowWindow();
        }
        // End:0x382
        if(!m_wndName_p[i].IsShowWindow())
        {
            m_wndName_p[i].ShowWindow();
        }
        nScrollHeight_p = (((nScrollHeight_p + 5) + 20) + 3) + nItemWndHeight;
        J0x3A0:

        i++;
        // [Loop Continue]
        goto J0x208;
    }
    // End:0x3D0
    if(areaScroll_p.IsShowWindow())
    {
        areaScroll_p.SetScrollHeight(nScrollHeight_p);
    }
    // End:0x3F4
    if(!areaScroll_p.IsShowWindow())
    {
        areaScroll_p.SetScrollPosition(0);
    }
    return;
}

function ComputeItemWndAnchor()
{
    local int i, j, nWndWidth, nWndHeight;

    areaScroll.SetScrollPosition(0);
    // End:0xA4
    if(m_bExistSkill[0] == 0)
    {
        i = 1;
        J0x24:

        // End:0xA4 [Loop If]
        if(i < 8)
        {
            // End:0x9A
            if(m_bExistSkill[i] > 0)
            {
                m_wndName[i].SetAnchor(m_WindowName $ ".ASkillScroll", "TopLeft", "TopLeft", 5, 4);
                m_wndName[i].ClearAnchor();
                // [Explicit Break]
                goto J0xA4;
            }
            i++;
            // [Loop Continue]
            goto J0x24;
        }
    }
    J0xA4:

    i = 0;
    J0xAB:

    // End:0x207 [Loop If]
    if(i < 8)
    {
        // End:0x1FD
        if(m_bExistSkill[i] > 0)
        {
            j = i + 1;
            J0xD6:

            // End:0x1FD [Loop If]
            if(j < 8)
            {
                // End:0x1F3
                if(m_bExistSkill[j] > 0)
                {
                    // End:0x189
                    if(m_bExistSkill[i] == 1)
                    {
                        m_wnd[i].GetWindowSize(nWndWidth, nWndHeight);
                        m_wndName[j].SetAnchor((m_WindowName $ ".ASkill.ASkillName") $ string(i), "BottomCenter", "TopCenter", 0, (nWndHeight + 3) + 5);
                        // [Explicit Break]
                        goto J0x1FD;
                        // [Explicit Continue]
                        goto J0x1F3;
                    }
                    // End:0x1F3
                    if(m_bExistSkill[i] == 2)
                    {
                        m_wndName[j].SetAnchor((m_WindowName $ ".ASkill.ASkillName") $ string(i), "BottomCenter", "TopCenter", 0, 5);
                        // [Explicit Break]
                        goto J0x1FD;
                    }
                }
                J0x1F3:

                j++;
                // [Loop Continue]
                goto J0xD6;
            }
        }
        J0x1FD:

        i++;
        // [Loop Continue]
        goto J0xAB;
    }
    // End:0x29B
    if(m_bExistSkill_p[0] == 0)
    {
        i = 1;
        J0x21B:

        // End:0x29B [Loop If]
        if(i < 6)
        {
            // End:0x291
            if(m_bExistSkill_p[i] > 0)
            {
                m_wndName_p[i].SetAnchor(m_WindowName $ ".PSkillScroll", "TopLeft", "TopLeft", 5, 4);
                m_wndName_p[i].ClearAnchor();
                // [Explicit Break]
                goto J0x29B;
            }
            i++;
            // [Loop Continue]
            goto J0x21B;
        }
    }
    J0x29B:

    i = 0;
    J0x2A2:

    // End:0x3FE [Loop If]
    if(i < 6)
    {
        // End:0x3F4
        if(m_bExistSkill_p[i] > 0)
        {
            j = i + 1;
            J0x2CD:

            // End:0x3F4 [Loop If]
            if(j < 6)
            {
                // End:0x3EA
                if(m_bExistSkill_p[j] > 0)
                {
                    // End:0x380
                    if(m_bExistSkill_p[i] == 1)
                    {
                        m_wnd_p[i].GetWindowSize(nWndWidth, nWndHeight);
                        m_wndName_p[j].SetAnchor((m_WindowName $ ".PSkill.PSkillName") $ string(i), "BottomCenter", "TopCenter", 0, (nWndHeight + 3) + 5);
                        // [Explicit Break]
                        goto J0x3F4;
                        // [Explicit Continue]
                        goto J0x3EA;
                    }
                    // End:0x3EA
                    if(m_bExistSkill_p[i] == 2)
                    {
                        m_wndName_p[j].SetAnchor((m_WindowName $ ".PSkill.PSkillName") $ string(i), "BottomCenter", "TopCenter", 0, 5);
                        // [Explicit Break]
                        goto J0x3F4;
                    }
                }
                J0x3EA:

                j++;
                // [Loop Continue]
                goto J0x2CD;
            }
        }
        J0x3F4:

        i++;
        // [Loop Continue]
        goto J0x2A2;
    }
    return;
}

function GroupingSkill(int SkillID, int SkillLevel, int SkillSubLevel, ItemInfo infItem)
{
    local SkillInfo Info;

    // End:0x21
    if(!GetSkillInfo(SkillID, SkillLevel, SkillSubLevel, Info))
    {
        return;
    }
    switch(Info.IconType)
    {
        // End:0x31
        case 0:
        // End:0x35
        case 1:
        // End:0x3A
        case 2:
        // End:0x3F
        case 3:
        // End:0x44
        case 4:
        // End:0x49
        case 5:
        // End:0x4E
        case 6:
        // End:0x75
        case 7:
            m_Item[Info.IconType].AddItem(infItem);
            // End:0xEE
            break;
        // End:0xA1
        case 8:
            infItem.ItemSubType = 7;
            m_Item[6].AddItem(infItem);
            // End:0xEE
            break;
        // End:0xA6
        case 11:
        // End:0xAB
        case 12:
        // End:0xB0
        case 13:
        // End:0xB5
        case 14:
        // End:0xBA
        case 15:
        // End:0xE5
        case 16:
            m_Item_p[Info.IconType - 11].AddItem(infItem);
            // End:0xEE
            break;
        // End:0xFFFF
        default:
            // End:0xEE
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0EE
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0EE
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0EE
}

function bool IsHeroSkillID(int SkillID)
{
    switch(SkillID)
    {
        // End:0x0F
        case 395:
        // End:0x17
        case 396:
        // End:0x1F
        case 1374:
        // End:0x27
        case 1375:
        // End:0x31
        case 1376:
            return true;
        // End:0xFFFF
        default:
            return false;
            break;
    }    
    return;
}

function bool IsItemSkillID(int SkillID)
{
    switch(SkillID)
    {
        // End:0xFFFF
        default:
            return false;
            break;
    }    
    return;
}

function bool IsChangeSkillID(int SkillID)
{
    switch(SkillID)
    {
        // End:0xFFFF
        default:
            return false;
            break;
    }    
    return;
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    local MagicSkillDrawerWnd script_a;
    local string DragSrcName;

    script_a = MagicSkillDrawerWnd(GetScript("MagicSkillDrawerWnd"));
    DragSrcName = Left(a_ItemInfo.DragSrcName, 10);
    switch(a_WindowID)
    {
        // End:0x172
        case "ResearchButton":
            // End:0x6A
            if(getInstanceUIData().getIsClassicServer())
            {                
            }
            else
            {
                // End:0x16F
                if((DragSrcName == "PSkillItem") || DragSrcName == "ASkillItem")
                {
                    // End:0x106
                    if(a_ItemInfo.Reserved == 0)
                    {
                        RequestSkillList();
                        script_a.SkillInfoClear();
                        script_a.SetAdenaSpInfo();
                        script_a.ResearchGuideDesc.SetText(GetSystemString(2041));
                        script_a.AddSystemMessage(3070);                        
                    }
                    else
                    {
                        RequestExEnchantSkillInfo(a_ItemInfo.Id.ClassID, a_ItemInfo.Level, a_ItemInfo.SubLevel);
                        script_a.SetCurSkillInfo(a_ItemInfo);
                        script_a.txtMySp.SetText(MakeCostString((GetuserSP())));
                        RequestSkillList();
                    }
                }
            }
            // End:0x178
            break;
        // End:0xFFFF
        default:
            // End:0x178
            break;
            break;
    }
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

function updateSubjobInfo(string param, int Event_ID)
{
    local int Count, i, CurrentSubjobClassID;
    local UserInfo myUserInfo;
    local int Race;

    isDualClass = false;
    GetPlayerInfo(myUserInfo);
    ParseInt(param, "Count", Count);
    ParseInt(param, "currentSubjobClassID", CurrentSubjobClassID);
    // End:0x69
    if(subjobInfoArray.Length > 0)
    {
        subjobInfoArray.Remove(0, subjobInfoArray.Length);
    }
    ParseInt(param, "Race", Race);
    i = 0;
    J0x86:

    // End:0x190 [Loop If]
    if(i < Count)
    {
        subjobInfoArray.Insert(subjobInfoArray.Length, 1);
        ParseInt(param, "SubjobClassID_" $ string(i), subjobInfoArray[i].ClassID);
        ParseInt(param, "SubjobID_" $ string(i), subjobInfoArray[i].Id);
        ParseInt(param, "SubjobLevel_" $ string(i), subjobInfoArray[i].Level);
        ParseInt(param, "SubjobType_" $ string(i), subjobInfoArray[i].Type);
        // End:0x186
        if(subjobInfoArray[i].Type == 1)
        {
            isDualClass = true;
        }
        i++;
        // [Loop Continue]
        goto J0x86;
    }
    i = 0;
    J0x197:

    // End:0x23B [Loop If]
    if(i < Count)
    {
        // End:0x1D5
        if(subjobInfoArray[i].Type == 0)
        {
            mainLevel = subjobInfoArray[i].Level;            
        }
        else
        {
            // End:0x201
            if(subjobInfoArray[i].Type == 1)
            {
                dualLevel = subjobInfoArray[i].Level;
            }
        }
        // End:0x231
        if(CurrentSubjobClassID == subjobInfoArray[i].ClassID)
        {
            currentType = subjobInfoArray[i].Type;
        }
        i++;
        // [Loop Continue]
        goto J0x197;
    }
    return;
}

function AddSkillTrainListItem(string param)
{
    local SkillInfo SkillInfo;
    local int Id, Level, SubLevel;
    local INT64 spConsume;
    local int requiredLevel, RequiredDualLevel;
    local UserInfo UserInfo;
    local ItemID cID;
    local string strRetName;
    local CustomTooltip t;
    local string strName, strIconName, setTreeName, panelName;
    local int currentMainLevel, currentDualLevel, _currentMainLevel, _currentDualLevel, IsNewSkill;

    ParseInt(param, "ID", Id);
    ParseInt(param, "Level", Level);
    ParseInt(param, "SubLevel", SubLevel);
    ParseINT64(param, "SpConsume", spConsume);
    ParseInt(param, "RequiredLevel", requiredLevel);
    ParseInt(param, "RequiredDualLevel", RequiredDualLevel);
    ParseInt(param, "IsNewSkill", IsNewSkill);
    cID = GetItemID(Id);
    GetSkillInfo(Id, Level, SubLevel, SkillInfo);
    GetPlayerInfo(UserInfo);
    strName = SkillInfo.SkillName;
    strIconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(cID, Level, SubLevel);
    panelName = SkillInfo.IconPanel;
    util.setCustomTooltip(t);
    util.ToopTipMinWidth(200);
    MakeSkillToolTip(strName, cID, Level, SubLevel, param);
    // End:0x1A0
    if(RequiredDualLevel > 0)
    {
        currentMainLevel = mainLevel;
        currentDualLevel = dualLevel;        
    }
    else
    {
        currentMainLevel = UserInfo.nLevel;
        currentDualLevel = UserInfo.nLevel;
    }
    // End:0xD27
    if((requiredLevel <= currentMainLevel) && RequiredDualLevel <= currentDualLevel)
    {
        // End:0x758
        if(IsNewSkill == 1)
        {
            setTreeName = (ROOTNAME $ ".") $ LIST1;
            strRetName = util.TreeInsertItemTooltipNode(TREENAME, (((((("" $ string(Id)) $ ",") $ string(Level)) $ ",") $ string(newSkillIndex)) $ ",") $ string(SubLevel), setTreeName, -7, 0, 38, 0, 30, 38, util.getCustomTooltip());
            treeNodeNameNewSkillArray[newSkillIndex] = strRetName;
            newSkillIndex++;
            // End:0x2D7
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
            // End:0x3D5
            if(SkillInfo.IconPanel != "")
            {
                util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, panelName, 32, 32, -32, 4 - 1);
            }
            // End:0x671
            if((TypeCheck(SkillInfo)) == true)
            {
                util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -33, 4 - 2);
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.0, true);
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, util.1, true, true);
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, util.2);
                util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_MP", 15, 15, 5, -17 + 1);
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(SkillInfo.MpConsume), 0, -17, util.1);
                util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_use", 15, 15, 5, -17 + 1);
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime), 0, -17, util.1);
                util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_Reuse", 15, 15, 5, -17 + 1);
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(SkillInfo.ReuseDelay), 0, -17, util.1);                
            }
            else
            {
                util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -33, 4 - 2);
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.0, true);
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, util.1, true, true);
                util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, util.2);
            }            
        }
        else
        {
            // End:0x77C
            if(RequiredDualLevel > 0)
            {
                _currentMainLevel = mainLevel;
                _currentDualLevel = dualLevel;                
            }
            else
            {
                _currentMainLevel = UserInfo.nLevel;
                _currentDualLevel = UserInfo.nLevel;
            }
            // End:0xD24
            if((requiredLevel <= _currentMainLevel) && RequiredDualLevel <= _currentDualLevel)
            {
                setTreeName = (ROOTNAME $ ".") $ LIST2;
                strRetName = util.TreeInsertItemTooltipNode(TREENAME, (((((("" $ string(Id)) $ ",") $ string(Level)) $ ",") $ string(levelUpSkillIndex)) $ ",") $ string(SubLevel), setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomTooltip());
                treeNodeNameLevelUpArray[levelUpSkillIndex] = strRetName;
                levelUpSkillIndex++;
                // End:0x8A8
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
                // End:0x9A6
                if(SkillInfo.IconPanel != "")
                {
                    util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, panelName, 32, 32, -32, 4 - 1);
                }
                // End:0xC41
                if((TypeCheck(SkillInfo)) == true)
                {
                    util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Active", 32, 32, -34, 4 - 1);
                    util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.0, true);
                    util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, util.1, true, true);
                    util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, util.2);
                    util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_MP", 15, 15, 5, -17 + 1);
                    util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(SkillInfo.MpConsume), 0, -17, util.1);
                    util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_use", 15, 15, 5, -17 + 1);
                    util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime), 0, -17, util.1);
                    util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "L2UI_CT1.SkillWnd_DF_ListIcon_Reuse", 15, 15, 5, -17 + 1);
                    util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, util.MakeTimeString(SkillInfo.ReuseDelay), 0, -17, util.1);                    
                }
                else
                {
                    util.TreeHandleInsertTextureNodeItem(m_UITree, strRetName, "l2ui_ct1.SkillWnd_DF_ListIcon_Passive", 32, 32, -34, 4 - 1);
                    util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, strName, 5, 5, util.0, true);
                    util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, GetSystemString(88), 46, -17, util.1, true, true);
                    util.TreeHandleInsertTextNodeItem(m_UITree, strRetName, string(Level), 2, -17, util.2);
                }
            }
        }        
    }
    else
    {
        setTreeName = (ROOTNAME $ ".") $ LIST3;
        strRetName = util.TreeInsertItemTooltipNode(TREENAME, (("" $ string(Id)) $ ",") $ string(Level), setTreeName, -7, 0, 38, 0, 32, 38, util.getCustomTooltip());
        // End:0xDDF
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
        // End:0xF49
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

function MakeSkillToolTip(string strName, ItemID Id, int Level, int SubLevel, string param)
{
    local SkillInfo SkillInfo;
    local int SkillID, requiredLevel, RequiredDualLevel, RequiredItemTotalCnt, requiredItemID, requiredItemCnt;

    local INT64 RequiredSkillCnt;
    local int requiredSkillID, requiredSkillLevel;
    local ItemID requiredID;
    local int i, nTmp;

    // End:0x0D
    if(!m_bShow)
    {
        return;
    }
    ParseInt(param, "ID", SkillID);
    GetSkillInfo(SkillID, Level, SubLevel, SkillInfo);
    ParseInt(param, "RequiredLevel", requiredLevel);
    ParseInt(param, "RequiredDualLevel", RequiredDualLevel);
    ParseInt(param, "RequiredItemTotalCnt", RequiredItemTotalCnt);
    ParseINT64(param, "RequiredSkillCnt", RequiredSkillCnt);
    util.ToopTipInsertText(strName, true);
    util.ToopTipInsertText(" " $ GetSystemString(88), true, false, util.1);
    util.ToopTipInsertText(" " $ string(Level), true, false, util.2);
    util.ToopTipInsertText(Class'NWindow.UIDATA_SKILL'.static.GetOperateType(Id, Level, SubLevel), true, true, util.2, 0, 6);
    util.TooltipInsertItemBlank(6);
    nTmp = Class'NWindow.UIDATA_SKILL'.static.GetHpConsume(Id, Level, SubLevel);
    // End:0x1E0
    if(nTmp > 0)
    {
        util.TwoWordCombineColon(GetSystemString(1195), string(nTmp), util.1, util.2, true);
    }
    nTmp = Class'NWindow.UIDATA_SKILL'.static.GetMpConsume(Id, Level, SubLevel);
    // End:0x247
    if(nTmp > 0)
    {
        util.TwoWordCombineColon(GetSystemString(320), string(nTmp), util.1, util.2, true);
    }
    nTmp = Class'NWindow.UIDATA_SKILL'.static.GetCastRange(Id, Level, SubLevel);
    // End:0x2AE
    if(nTmp >= 0)
    {
        util.TwoWordCombineColon(GetSystemString(321), string(nTmp), util.1, util.2, true);
    }
    // End:0x330
    if(Class'NWindow.UIDATA_SKILL'.static.GetOperateType(Id, Level, SubLevel) == GetSystemString(311))
    {
        util.TwoWordCombineColon(GetSystemString(2377), util.MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime), util.1, util.2, true);
    }
    // End:0x3A8
    if(Class'NWindow.UIDATA_SKILL'.static.GetOperateType(Id, Level, SubLevel) == GetSystemString(311))
    {
        util.TwoWordCombineColon(GetSystemString(2378), util.MakeTimeString(SkillInfo.ReuseDelay), util.1, util.2, true);
    }
    util.ToopTipInsertText(Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, Level, SubLevel), false, true, util.1, 0, 6);
    util.TooltipInsertItemBlank(6);
    util.TooltipInsertItemLine();
    util.TooltipInsertItemBlank(3);
    util.ToopTipInsertText(("<" $ GetSystemString(2375)) $ ">", true, true);
    util.TwoWordCombineColon(GetSystemString(2381), string(requiredLevel), util.1, util.2, true);
    // End:0x4B7
    if(RequiredDualLevel > 0)
    {
        util.TwoWordCombineColon(GetSystemString(2969), string(RequiredDualLevel), util.1, util.2, true);
    }
    // End:0x5B2
    if(RequiredItemTotalCnt > 0)
    {
        util.TooltipInsertItemBlank(6);
        util.ToopTipInsertText(("<" $ GetSystemString(2380)) $ ">", true, true);
        i = 1;
        J0x500:

        // End:0x5B2 [Loop If]
        if(i <= RequiredItemTotalCnt)
        {
            ParseInt(param, "requiredItemID" $ string(i), requiredItemID);
            ParseInt(param, "requiredItemCnt" $ string(i), requiredItemCnt);
            util.ToopTipInsertText((Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(requiredItemID)) $ " X ") $ string(requiredItemCnt), false, true, util.2);
            i++;
            // [Loop Continue]
            goto J0x500;
        }
    }
    // End:0x777
    if(__NFUN_409__(RequiredSkillCnt, (0)))
    {
        util.TooltipInsertItemBlank(6);
        util.ToopTipInsertText(("<" $ GetSystemString(2376)) $ ">", true);
        i = 1;
        J0x5FD:

        // End:0x777 [Loop If]
        if(__NFUN_410__((i), RequiredSkillCnt))
        {
            ParseInt(param, "requiredSkillID" $ string(i), requiredSkillID);
            ParseInt(param, "requiredSkillLevel" $ string(i), requiredSkillLevel);
            requiredID = GetItemID(requiredSkillID);
            util.TooltipInsertItemBlank(3);
            util.ToopTipInsertTexture(Class'NWindow.UIDATA_SKILL'.static.GetIconName(requiredID, requiredSkillLevel, 0), true, true);
            // End:0x73F
            if(Class'NWindow.UIDATA_SKILL'.static.SkillIsNewOrUp(requiredID) == 0)
            {
                util.ToopTipInsertTexture("l2ui_ct1.ItemWindow_IconDisable",,, -16);
                util.ToopTipInsertText(Class'NWindow.UIDATA_SKILL'.static.GetName(requiredID, requiredSkillLevel, 0), true, false, util.1, 5);
                // [Explicit Continue]
                goto J0x76D;
            }
            util.ToopTipInsertText(Class'NWindow.UIDATA_SKILL'.static.GetName(requiredID, requiredSkillLevel, 0), true, false,, 5);
            J0x76D:

            i++;
            // [Loop Continue]
            goto J0x5FD;
        }
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
            // End:0x48
            break;
        // End:0xFFFF
        default:
            // End:0x48
            break;
            break;
    }
    return B;
    return;
}

function externalCallLearnSkill()
{
    m_wndTop.ShowWindow();
    m_wndTop.SetFocus();
    GetTabHandle("MagicSkillWnd.TabCtrl").SetTopOrder(2, false);
    OnClickButton("TabCtrl2");
    return;
}

function bool isSkillLearnTab()
{
    return GetTabHandle("MagicSkillWnd.TabCtrl").GetTopIndex() == 2;
    return;
}

function closeTreeNode()
{
    m_UITree.SetExpandedNode(beforeTreeName, false);
    beforeTreeName = "";
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
    m_WindowName="MagicSkillWnd"
    TREENAME="MagicSkillWnd.SkillTrainTree"
    ROOTNAME="root"
    LIST1="SKILLLIST1"
    LIST2="SKILLLIST2"
    LIST3="SKILLLIST3"
}