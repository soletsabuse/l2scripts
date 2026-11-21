class MSViewerWnd extends UICommonAPI;

const SK_NORMAL = 0;
const SK_BUFF = 1;
const SK_DEBUFF = 2;
const SK_TOGGLE = 3;
const SK_SONGDANCE = 4;
const SK_PASSIVE = 5;
const SK_SEARCH = 6;
const SK_MAX = 7;

var string m_WindowName;
var ItemWindowHandle m_hItemWnd[7];
var ItemWindowHandle selectedItemWindowHandle;
var int prevSelectedSkillID;
var WindowHandle m_hWnd;
var WindowHandle m_hProfilerWnd;
var TabHandle m_hTabItemWnd;
var EditBoxHandle m_hEbSkillName;
var EditBoxHandle m_hEbSkillID;
var EditBoxHandle m_hEbSkillVisualEffect;
var EditBoxHandle m_hebSkillType;
var CheckBoxHandle m_hcbSkillCursor;
var ComboBoxHandle comboSkillLevel;
var ComboBoxHandle comboSkillSubLevel;
var TextBoxHandle m_hTxtFrontHairTexture;
var TextBoxHandle m_hTxtRearHairTexture;
var EditBoxHandle m_hEbMultiSpawnNum;
var CheckBoxHandle m_hCbMultiSpawn;
var CheckBoxHandle m_hCbMultiTarget;
var CheckBoxHandle m_hCbSimpleEmitter;

function OnRegisterEvent()
{
    RegisterEvent(4400);
    RegisterEvent(4410);
    RegisterEvent(4420);
    return;
}

function OnLoad()
{
    InitializeHandle();
    m_hWnd.SetWindowTitle("SKILL VIEWER");
    return;
}

function InitializeHandle()
{
    m_hWnd = GetWindowHandle(m_WindowName);
    m_hProfilerWnd = GetWindowHandle("MSProfilerWnd");
    m_hTabItemWnd = GetTabHandle(m_WindowName $ ".SkillTab");
    m_hItemWnd[0] = GetItemWindowHandle(m_WindowName $ ".ItemWndSkillNormal");
    m_hItemWnd[1] = GetItemWindowHandle(m_WindowName $ ".ItemWndSkillBuff");
    m_hItemWnd[2] = GetItemWindowHandle(m_WindowName $ ".ItemWndSkillDebuff");
    m_hItemWnd[3] = GetItemWindowHandle(m_WindowName $ ".ItemWndSkillToggle");
    m_hItemWnd[4] = GetItemWindowHandle(m_WindowName $ ".ItemWndSkillSongdance");
    m_hItemWnd[5] = GetItemWindowHandle(m_WindowName $ ".ItemWndSkillPassive");
    m_hItemWnd[6] = GetItemWindowHandle(m_WindowName $ ".ItemWndSkillSearch");
    m_hEbSkillName = GetEditBoxHandle(m_WindowName $ ".ebSkillName");
    m_hEbSkillID = GetEditBoxHandle(m_WindowName $ ".ebSkillID");
    m_hEbSkillVisualEffect = GetEditBoxHandle(m_WindowName $ ".ebVisualEffect");
    m_hebSkillType = GetEditBoxHandle(m_WindowName $ ".ebSkillType");
    m_hcbSkillCursor = GetCheckBoxHandle(m_WindowName $ ".cbSkillCursor");
    comboSkillLevel = GetComboBoxHandle(m_WindowName $ ".ComboBoxSkillLevel");
    comboSkillSubLevel = GetComboBoxHandle(m_WindowName $ ".ComboBoxSkillSubLevel");
    m_hEbMultiSpawnNum = GetEditBoxHandle(m_WindowName $ ".ebMultiSpawnNum");
    m_hCbMultiSpawn = GetCheckBoxHandle(m_WindowName $ ".cbMultiSpawn");
    m_hCbMultiTarget = GetCheckBoxHandle(m_WindowName $ ".cbMultiTarget");
    m_hCbSimpleEmitter = GetCheckBoxHandle(m_WindowName $ ".cbSimpleEmitter");
    m_hEbMultiSpawnNum.SetString("50");
    comboSkillLevel.AddString("1");
    comboSkillLevel.SetSelectedNum(0);
    comboSkillSubLevel.AddString("0");
    comboSkillSubLevel.SetSelectedNum(0);
    return;
}

function OnEvent(int a_EventID, string param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 4400:
            HandleAddSkill(param);
            // End:0x4B
            break;
        // End:0x37
        case 4410:
            m_hWnd.ShowWindow();
            // End:0x4B
            break;
        // End:0x48
        case 4420:
            HandleDeleteAllSkill();
            // End:0x4B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleDeleteAllSkill()
{
    m_hItemWnd[0].Clear();
    m_hItemWnd[1].Clear();
    m_hItemWnd[2].Clear();
    m_hItemWnd[3].Clear();
    m_hItemWnd[4].Clear();
    m_hItemWnd[5].Clear();
    m_hItemWnd[6].Clear();
    comboSkillLevel.Clear();
    comboSkillSubLevel.Clear();
    selectedItemWindowHandle = none;
    prevSelectedSkillID = -1;
    return;
}

function HandleAddSkill(string param)
{
    local int Type, SkillLevel, SkillSubLevel, Lock;
    local string strIconName, strSkillName, strDescription, strEnchantName, strCommand, strIconPanel;

    local ItemInfo infItem;

    ParseItemID(param, infItem.Id);
    ParseInt(param, "Type", Type);
    ParseInt(param, "Level", SkillLevel);
    ParseInt(param, "SubLevel", SkillSubLevel);
    ParseInt(param, "Lock", Lock);
    ParseString(param, "Name", strSkillName);
    ParseString(param, "IconName", strIconName);
    ParseString(param, "IconPanel", strIconPanel);
    ParseString(param, "Description", strDescription);
    ParseString(param, "AdditionalName", strEnchantName);
    ParseString(param, "Command", strCommand);
    infItem.Level = SkillLevel;
    infItem.SubLevel = SkillSubLevel;
    infItem.Name = strSkillName;
    infItem.AdditionalName = strEnchantName;
    infItem.IconName = strIconName;
    infItem.IconPanel = strIconPanel;
    infItem.Description = strDescription;
    infItem.ItemSubType = int(2);
    infItem.MacroCommand = strCommand;
    // End:0x1BD
    if(Lock > 0)
    {
        infItem.bIsLock = true;        
    }
    else
    {
        infItem.bIsLock = false;
    }
    // End:0x1FD
    if((Type >= 0) && Type < 7)
    {
        m_hItemWnd[Type].AddItem(infItem);
    }
    return;
}

function OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
    local ItemInfo Info;

    a_hItemWindow.GetItem(Index, Info);
    selectedItemWindowHandle = a_hItemWindow;
    // End:0x67
    if(prevSelectedSkillID != Info.Id.ClassID)
    {
        RefreshSkillLevel(Info.Id.ClassID);
        prevSelectedSkillID = Info.Id.ClassID;
    }
    return;
}

function OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
    OnRClickItemWithHandle(a_hItemWindow, Index);
    return;
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
    local ItemInfo Info;

    a_hItemWindow.GetItem(Index, Info);
    ExecuteSkill(Info, Info.Level, Info.SubLevel);
    return;
}

function ExecuteSkill(ItemInfo Info, int SkillLevel, int SkillSubLevel)
{
    // End:0x4E
    if(Class'NWindow.UIDATA_PAWNVIEWER'.static.IsProfilingEmitter())
    {
        DialogShow(1, 5, "분석중에는 다른 스킬을 사용할 수 없습니다.", string(self));        
    }
    else
    {
        // End:0x7E
        if(m_hProfilerWnd.IsShowWindow())
        {
            m_hProfilerWnd.ShowWindow();
            Class'NWindow.UIDATA_PAWNVIEWER'.static.ExecuteEmitterProfiling();
        }
        Class'NWindow.UIDATA_PAWNVIEWER'.static.ExecuteSkill(Info.Id.ClassID, SkillLevel, SkillSubLevel, m_hCbMultiTarget.IsChecked());
    }
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x5F
        case "cbMultiSpawn":
            // End:0x4D
            if(m_hCbMultiSpawn.IsChecked())
            {
                Class'NWindow.UIDATA_PAWNVIEWER'.static.SpawnDummyPawn(int(m_hEbMultiSpawnNum.GetString()));                
            }
            else
            {
                Class'NWindow.UIDATA_PAWNVIEWER'.static.ClearDummyPawn();
            }
            // End:0xCA
            break;
        // End:0x94
        case "cbSimpleEmitter":
            Class'NWindow.UIDATA_PAWNVIEWER'.static.SetSimpleEmitter(m_hCbSimpleEmitter.IsChecked());
            // End:0xCA
            break;
        // End:0xC7
        case "cbSkillCursor":
            Class'NWindow.UIDATA_PAWNVIEWER'.static.SetGroundSkillCursor(m_hcbSkillCursor.IsChecked());
            // End:0xCA
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x24
        case "btnSearchByName":
            processBtnSearchByName();
            // End:0xBE
            break;
        // End:0x3F
        case "btnSearchByID":
            processBtnSearchByID();
            // End:0xBE
            break;
        // End:0x64
        case "btnSearchByVisualEffect":
            processBtnSearchByVisualEffect();
            // End:0xBE
            break;
        // End:0x81
        case "btnSearchByType":
            processBtnSearchByType();
            // End:0xBE
            break;
        // End:0x9B
        case "btnProfiling":
            processBtnProfiling();
            // End:0xBE
            break;
        // End:0xBB
        case "ButtonExecuteSkill":
            processBtnExecuteSkill();
            // End:0xBE
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function processBtnExecuteSkill()
{
    local ItemInfo Info;
    local int tempIValue;
    local string tempStr;
    local int SkillLevel, SkillSubLevel;

    // End:0xC3
    if(selectedItemWindowHandle != none)
    {
        tempIValue = comboSkillLevel.GetSelectedNum();
        SkillLevel = 1;
        // End:0x5D
        if(tempIValue > -1)
        {
            tempStr = comboSkillLevel.GetString(tempIValue);
            SkillLevel = int(tempStr);
        }
        SkillSubLevel = 0;
        // End:0x9A
        if(tempIValue > -1)
        {
            tempStr = comboSkillSubLevel.GetString(tempIValue);
            SkillSubLevel = int(tempStr);
        }
        selectedItemWindowHandle.GetSelectedItem(Info);
        ExecuteSkill(Info, SkillLevel, SkillSubLevel);
    }
    return;
}

function processBtnProfiling()
{
    // End:0x33
    if(m_hProfilerWnd.IsShowWindow())
    {
        Class'NWindow.UIDATA_PAWNVIEWER'.static.StopEmitterProfiling();
        m_hProfilerWnd.HideWindow();        
    }
    else
    {
        m_hProfilerWnd.ShowWindow();
    }
    return;
}

function processBtnSearchByName()
{
    local string inputString;

    m_hItemWnd[6].Clear();
    inputString = m_hEbSkillName.GetString();
    // End:0x5A
    if(Len(inputString) > 0)
    {
        Class'NWindow.UIDATA_PAWNVIEWER'.static.AddSkillByName(inputString);
        m_hTabItemWnd.SetTopOrder(6, false);
    }
    return;
}

function processBtnSearchByID()
{
    local int Id;

    m_hItemWnd[6].Clear();
    Id = int(m_hEbSkillID.GetString());
    // End:0x5A
    if(Id > 0)
    {
        Class'NWindow.UIDATA_PAWNVIEWER'.static.AddSkillByID(Id);
        m_hTabItemWnd.SetTopOrder(6, false);
    }
    return;
}

function processBtnSearchByVisualEffect()
{
    local string visualEffect;

    m_hItemWnd[6].Clear();
    visualEffect = m_hEbSkillVisualEffect.GetString();
    // End:0x5A
    if(Len(visualEffect) > 0)
    {
        Class'NWindow.UIDATA_PAWNVIEWER'.static.AddSkillByVisualEffect(visualEffect);
        m_hTabItemWnd.SetTopOrder(6, false);
    }
    return;
}

function processBtnSearchByType()
{
    local int Type;

    m_hItemWnd[6].Clear();
    Type = int(m_hebSkillType.GetString());
    // End:0x5A
    if(Type > 0)
    {
        Class'NWindow.UIDATA_PAWNVIEWER'.static.AddSkillByType(Type);
        m_hTabItemWnd.SetTopOrder(6, false);
    }
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x55
    if(int(nKey) == int(13))
    {
        // End:0x28
        if(m_hEbSkillName == a_WindowHandle)
        {
            processBtnSearchByName();            
        }
        else
        {
            // End:0x40
            if(m_hEbSkillID == a_WindowHandle)
            {
                processBtnSearchByID();                
            }
            else
            {
                // End:0x55
                if(m_hEbSkillVisualEffect == a_WindowHandle)
                {
                    processBtnSearchByVisualEffect();
                }
            }
        }
    }
    return;
}

function RefreshSkillLevel(int SkillID)
{
    local array<int> skillLevelList, skillSubLevelList;
    local int i;

    Class'NWindow.UIDATA_PAWNVIEWER'.static.GetSkillLevelListByID(SkillID, skillLevelList, skillSubLevelList);
    comboSkillLevel.Clear();
    i = skillLevelList.Length - 1;
    J0x3C:

    // End:0x6D [Loop If]
    if(i >= 0)
    {
        comboSkillLevel.AddString(string(skillLevelList[i]));
        --i;
        // [Loop Continue]
        goto J0x3C;
    }
    comboSkillLevel.SetSelectedNum(0);
    comboSkillSubLevel.Clear();
    i = skillSubLevelList.Length - 1;
    J0x9B:

    // End:0xCC [Loop If]
    if(i >= 0)
    {
        comboSkillSubLevel.AddString(string(skillSubLevelList[i]));
        --i;
        // [Loop Continue]
        goto J0x9B;
    }
    comboSkillSubLevel.SetSelectedNum(0);
    return;
}

defaultproperties
{
    m_WindowName="MSViewerWnd"
}