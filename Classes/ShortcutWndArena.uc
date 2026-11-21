class ShortcutWndArena extends UICommonAPI;

const MAX_Page = 2;
const MAX_ShortcutPerPage = 12;
const SKILLID_NONE = 0;
const SKILLID_ADD = 1;
const SKILLID_UPDATE = 2;
const SKILLID_REMOVE = 3;

var WindowHandle Me;
var AnimTextureHandle SlotEffect_Ani;
var AnimTextureHandle PlusEffect_Ani;
var array<int> skillShortIDs;
var array<int> skillClassIDs;
var int currentUpgraeSkillID;
var string upgradeSkillShortcutName;

function OnRegisterEvent()
{
    RegisterEvent(630);
    RegisterEvent(640);
    RegisterEvent(650);
    RegisterEvent(91);
    RegisterEvent(693);
    RegisterEvent(5090);
    RegisterEvent(5091);
    return;
}

function OnLoad()
{
    local ToolTip script;

    // End:0x17
    if(!getInstanceUIData().getIsArenaServer())
    {
        return;
    }
    script = ToolTip(GetScript("Tooltip"));
    script.setBoolSelect(true);
    Me = GetWindowHandle("ShortcutWndArena");
    SlotEffect_Ani = GetAnimTextureHandle("ShortcutWndArena.SlotEffect_Ani");
    PlusEffect_Ani = GetAnimTextureHandle("ShortcutWndArena.PlusEffect_Ani");
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    // End:0x17
    if(!getInstanceUIData().getIsArenaServer())
    {
        return;
    }
    switch(a_EventID)
    {
        // End:0x31
        case 91:
            ExecuteShortcutCommandBySlot(a_Param);
            // End:0xD2
            break;
        // End:0x47
        case 640:
            HandleShortcutPageUpdate(a_Param);
            // End:0xD2
            break;
        // End:0x5D
        case 630:
            HandleShortcutUpdate(a_Param);
            // End:0xD2
            break;
        // End:0x8E
        case 650:
            HandleShortcutClear();
            Class'NWindow.ShortcutAPI'.static.SetShortcutPage(0);
            Class'NWindow.ShortcutAPI'.static.SetShortcutPage(1);
            // End:0xD2
            break;
        // End:0x96
        case 693:
        // End:0x9E
        case 5090:
        // End:0xCF
        case 5091:
            ClearAllShortcutItemTooltip();
            Class'NWindow.ShortcutAPI'.static.SetShortcutPage(0);
            Class'NWindow.ShortcutAPI'.static.SetShortcutPage(1);
            // End:0xD2
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnCallUCFunction(string Id, string param)
{
    handleSkillUpgrade(int(param));
    return;
}

function skillUpgradeHide()
{
    SlotEffect_Ani.HideWindow();
    PlusEffect_Ani.HideWindow();
    return;
}

function skillUpgradeShow(string shortcutName)
{
    SlotEffect_Ani.ShowWindow();
    PlusEffect_Ani.ShowWindow();
    setAnchorShortcut(shortcutName);
    upgradeSkillShortcutName = shortcutName;
    return;
}

function handleSkillUpgrade(int ClassID)
{
    local int idx;

    currentUpgraeSkillID = ClassID;
    idx = getSkillShortcutIdxByClassID(currentUpgraeSkillID);
    // End:0x45
    if((currentUpgraeSkillID == -1) || idx == -1)
    {
        skillUpgradeHide();        
    }
    else
    {
        skillUpgradeShow(handleGetShortcutName(skillShortIDs[idx]));
    }
    return;
}

function setAnchorShortcut(string shortcutName)
{
    SlotEffect_Ani.Play();
    PlusEffect_Ani.SetLoopCount(999);
    PlusEffect_Ani.Play();
    SlotEffect_Ani.SetAnchor(shortcutName, "CenterCenter", "CenterCenter", 0, 0);
    PlusEffect_Ani.SetAnchor(shortcutName, "CenterCenter", "CenterCenter", 0, 0);
    return;
}

function string handleGetShortcutName(int nShortcutID)
{
    local string shortcutName;
    local int shortcutLine, nShortcutNum;

    nShortcutNum = int(float(nShortcutID) % float(12)) + 1;
    shortcutLine = nShortcutID / 12;
    shortcutName = (getShortcutPathName(shortcutLine)) $ string(nShortcutNum);
    return shortcutName;
    return;
}

function string getShortcutPathName(int shortcutLine)
{
    return ("ShortcutWndArena.ShortcutWndHorizontalArena_" $ string(shortcutLine)) $ ".Shortcut";
    return;
}

function int getSkillShortcutHandleType(int idx, UIEventManager.EShortCutItemType ShortcutType)
{
    local bool isSkillID;

    isSkillID = int(2) == int(ShortcutType);
    // End:0x30
    if(isSkillID && idx == -1)
    {
        return 1;
    }
    // End:0x3C
    if(isSkillID)
    {
        return 2;
    }
    // End:0x4E
    if(idx != -1)
    {
        return 3;
    }
    return 0;
    return;
}

function setSkillID(string param, int nShortcutID, string shortcutName)
{
    local int ClassID, idx, ShortcutType, Type;
    local bool isUpgradeSkill;

    ParseInt(param, "ShortcutType", ShortcutType);
    idx = getSkillArrIndexByShortcutID(nShortcutID);
    Type = getSkillShortcutHandleType(idx, byte(ShortcutType));
    ParseInt(param, "ClassID", ClassID);
    isUpgradeSkill = currentUpgraeSkillID == ClassID;
    switch(Type)
    {
        // End:0xA5
        case 1:
            skillIDAdd(nShortcutID, ClassID);
            // End:0xA2
            if(isUpgradeSkill)
            {
                skillUpgradeShow(shortcutName);
            }
            // End:0xEC
            break;
        // End:0xD6
        case 2:
            skillIDUpdate(nShortcutID, ClassID, idx);
            // End:0xD3
            if(isUpgradeSkill)
            {
                skillUpgradeShow(shortcutName);
            }
            // End:0xEC
            break;
        // End:0xE9
        case 3:
            skillIDRemove(idx);
            // End:0xEC
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function int getSkillShortcutIdxByClassID(int ClassID)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x3C [Loop If]
    if(i < skillClassIDs.Length)
    {
        // End:0x32
        if(skillClassIDs[i] == ClassID)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function int getSkillArrIndexByShortcutID(int ShortcutID)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x3C [Loop If]
    if(i < skillShortIDs.Length)
    {
        // End:0x32
        if(skillShortIDs[i] == ShortcutID)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function skillIDRemove(int idx)
{
    local bool isUpgradeSkill, isMineSkill;

    isUpgradeSkill = skillClassIDs[idx] == currentUpgraeSkillID;
    isMineSkill = upgradeSkillShortcutName == (handleGetShortcutName(skillShortIDs[idx]));
    skillClassIDs.Remove(idx, 1);
    skillShortIDs.Remove(idx, 1);
    // End:0xA2
    if(isUpgradeSkill)
    {
        idx = getSkillShortcutIdxByClassID(currentUpgraeSkillID);
        // End:0x82
        if(idx == -1)
        {
            skillUpgradeHide();            
        }
        else
        {
            // End:0xA2
            if(isMineSkill)
            {
                skillUpgradeShow(handleGetShortcutName(skillShortIDs[idx]));
            }
        }
    }
    return;
}

function skillIDUpdate(int ShortcutID, int ClassID, int idx)
{
    skillShortIDs[idx] = ShortcutID;
    skillClassIDs[idx] = ClassID;
    return;
}

function skillIDAdd(int ShortcutID, int ClassID)
{
    local int idx;

    idx = skillClassIDs.Length;
    skillShortIDs.Length = idx + 1;
    skillClassIDs.Length = skillShortIDs.Length;
    skillShortIDs[idx] = ShortcutID;
    skillClassIDs[idx] = ClassID;
    return;
}

function ClearAllShortcutItemTooltip()
{
    Me.ClearAllChildShortcutItemTooltip();
    return;
}

function HandleShortcutPageUpdate(string param)
{
    local int i, nstartShortcutID, ShortcutPage;
    local string shortcutPath;

    // End:0xA5
    if(ParseInt(param, "ShortcutPage", ShortcutPage))
    {
        // End:0x3C
        if((0 > ShortcutPage) || 2 <= ShortcutPage)
        {
            return;
        }
        shortcutPath = getShortcutPathName(ShortcutPage);
        nstartShortcutID = ShortcutPage * 12;
        i = 0;
        J0x63:

        // End:0xA5 [Loop If]
        if(i < 12)
        {
            Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(shortcutPath $ string(i + 1), nstartShortcutID + i);
            ++i;
            // [Loop Continue]
            goto J0x63;
        }
    }
    return;
}

function HandleShortcutUpdate(string param)
{
    local int nShortcutID;
    local string shortcutName;

    ParseInt(param, "ShortcutID", nShortcutID);
    // End:0x3B
    if((nShortcutID < 0) || nShortcutID >= (12 * 2))
    {
        return;
    }
    shortcutName = handleGetShortcutName(nShortcutID);
    Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut(shortcutName, nShortcutID);
    setSkillID(param, nShortcutID, shortcutName);
    return;
}

function HandleShortcutClear()
{
    local int i;

    skillClassIDs.Length = 0;
    skillShortIDs.Length = 0;
    currentUpgraeSkillID = -1;
    skillUpgradeHide();
    i = 0;
    J0x28:

    // End:0xE4 [Loop If]
    if(i < 12)
    {
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWndArena.ShortcutWndHorizontalArena_0.Shortcut" $ string(i + 1));
        Class'NWindow.UIAPI_SHORTCUTITEMWINDOW'.static.Clear("ShortcutWndArena.ShortcutWndHorizontalArena_1.Shortcut" $ string(i + 1));
        ++i;
        // [Loop Continue]
        goto J0x28;
    }
    return;
}

function ExecuteShortcutCommandBySlot(string param)
{
    local int Slot;

    ParseInt(param, "Slot", Slot);
    // End:0x3C
    if(Me.IsShowWindow())
    {
        Class'NWindow.ShortcutAPI'.static.ExecuteShortcutBySlot(Slot);
    }
    return;
}
