class UnionMagicSkillWnd extends UICommonAPI;

const SKILL_MAX = 9;

var string m_WindowName;
var WindowHandle Me;
var WindowHandle Skill[9];
var ItemWindowHandle SkillSlot[9];
var TextBoxHandle SkillNameTxt[9];
var TextBoxHandle AvailableTxt[9];
var TextBoxHandle TotalTxt[9];

function OnLoad()
{
    local int i;

    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    i = 0;
    J0x27:

    // End:0x15B [Loop If]
    if(i < 9)
    {
        Skill[i] = GetWindowHandle((m_WindowName $ ".Skill_00") $ string(i));
        SkillSlot[i] = GetItemWindowHandle(((m_WindowName $ ".Skill_00") $ string(i)) $ ".SkillSlot");
        SkillNameTxt[i] = GetTextBoxHandle(((m_WindowName $ ".Skill_00") $ string(i)) $ ".SkillNameTxt");
        AvailableTxt[i] = GetTextBoxHandle(((m_WindowName $ ".Skill_00") $ string(i)) $ ".AvailableTxt");
        TotalTxt[i] = GetTextBoxHandle(((m_WindowName $ ".Skill_00") $ string(i)) $ ".TotalTxt");
        i++;
        // [Loop Continue]
        goto J0x27;
    }
    return;
}

function addSkills(array<string> skillsData)
{
    local int i, j;
    local SkillInfo SkillInfo;
    local ItemInfo Info;
    local string strLine;
    local int skillIndexID, nCurrentAvailable, nTotalAvailable, SkillID, SkillLevel, SkillSubLevel;

    local array<string> skillData;
    local bool bHave;

    clearSkills();
    i = 0;
    J0x0D:

    // End:0x19A [Loop If]
    if(i < skillsData.Length)
    {
        skillData = Arr(skillsData[i], ";");
        skillIndexID = int(skillData[0]);
        nCurrentAvailable = int(skillData[1]);
        nTotalAvailable = int(skillData[2]);
        // End:0x9F
        if(!GetINIString("skillist", "id" $ string(skillIndexID), strLine, "UnionSkill.dat"))
        {
            // [Explicit Continue]
            goto J0x190;
        }
        ParseInt(strLine, "SkillID", SkillID);
        ParseInt(strLine, "skillLevel", SkillLevel);
        ParseInt(strLine, "SkillSubLevel", SkillSubLevel);
        GetSkillInfo(SkillID, SkillLevel, SkillSubLevel, SkillInfo);
        Info = getItemInfoBySkillInfo(SkillInfo, true);
        j = 0;
        J0x126:

        // End:0x190 [Loop If]
        if(j < 9)
        {
            // End:0x186
            if(!Skill[j].IsShowWindow())
            {
                updateSkillAvailability(j, Info, nCurrentAvailable, nTotalAvailable);
                Skill[j].ShowWindow();
                bHave = true;
                // [Explicit Break]
                goto J0x190;
            }
            j++;
            // [Loop Continue]
            goto J0x126;
        }
        J0x190:

        i++;
        // [Loop Continue]
        goto J0x0D;
    }
    // End:0x1B2
    if(bHave)
    {
        Me.ShowWindow();
    }
    // End:0x1D8
    if(!bHave)
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(7697));
    }
    return;
}

function updateSkillAvailability(int idx, ItemInfo Info, int nCurrentAvailable, int nTotalAvailable)
{
    local Color Color;
    local string sLockedIcon;

    // End:0x3C
    if(nCurrentAvailable == 0)
    {
        sLockedIcon = "L2UI_CT1.skillLock";
        Color = GetColor(255, 158, 158, 255);        
    }
    else
    {
        sLockedIcon = "";
        Color = GetColor(255, 215, 0, 255);
    }
    Info.IconPanel = sLockedIcon;
    AvailableTxt[idx].SetText(string(nCurrentAvailable));
    AvailableTxt[idx].SetTextColor(Color);
    TotalTxt[idx].SetText(string(nTotalAvailable));
    SkillSlot[idx].Clear();
    SkillSlot[idx].AddItem(Info);
    SkillNameTxt[idx].SetText(((Info.Name @ Info.AdditionalName) @ GetSystemString(88)) @ string(Info.Level));
    return;
}

function clearSkills()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x32 [Loop If]
    if(i < 9)
    {
        Skill[i].HideWindow();
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function handleOpen()
{
    Me.ShowWindow();
    return;
}

function HandleHide()
{
    clearSkills();
    Me.HideWindow();
    return;
}

function OnShow()
{
    return;
}

function OnHide()
{
    clearSkills();
    return;
}

function OnRegisterEvent()
{
    return;
}

function OnEvent(int Event_ID, string param)
{
    return;
}

function OnClickButton(string strID)
{
    return;
}

function OnTimer(int TimerID)
{
    return;
}
