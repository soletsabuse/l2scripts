class MagicSkillUseWnd extends UICommonAPI;

const MAGIC_SKILL_HIDE_LIST = 1040;
const MAGIC_SKILL_HIDE_OPEN = 1041;
const MAX_SKILL_SAVE = 50;
const MAX_BROADCAST_DISTANCE = 4500;
const UPDATE_TIMEOUT = 3500;

struct _PresetList
{
    var string PresetName;
    var array<int> PresetSkillIDs;
};

var array<_PresetList> PresetDataList;
var int currentPresetIndex;
var bool bListsPrepare;
var UserInfo MyInfo;
var string m_WindowName;
var bool bHandleNoIcon;
var array<int> HiddenSkills;
var array<int> ExceptSkills;
var array<int> SpecialSkills;
var WindowHandle Me;
var WindowHandle SelectedContainer;
var WindowHandle MagicSkillUseSaveWnd;
var TextBoxHandle CurrSaveTxt;
var TextBoxHandle MaxSaveTxt;
var ListCtrlHandle SavedList;
var ListCtrlHandle NearUsageList_Total;
var ListCtrlHandle NearUsageList_Active;
var ListCtrlHandle NearUsageList_Positive;
var ListCtrlHandle NearUsageList_Negative;
var ListCtrlHandle NearUsageList_Special;
var ListCtrlHandle NearUsageList[5];
var TextBoxHandle CountTxt[5];
var TextBoxHandle SideCountTxt[2];
var TabHandle Tab;
var TabHandle SaveTab;
var WindowHandle PresetContainer;
var ButtonHandle PresetLeftBtn;
var ButtonHandle PresetRightBtn;
var ListCtrlHandle PresetList;
var TextBoxHandle txtPresetName;
var TextBoxHandle txtPresetCount;
var ButtonHandle btnAddPreset;

function OnLoad()
{
    local int i, tmpInt;

    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    Tab = GetTabHandle(m_WindowName $ ".TabCtrl");
    SelectedContainer = GetWindowHandle(m_WindowName $ ".SelectedContainer");
    NearUsageList[0] = GetListCtrlHandle(m_WindowName $ ".NearListContainer.ListContainer.NearUsageList_Total");
    NearUsageList[1] = GetListCtrlHandle(m_WindowName $ ".NearListContainer.ListContainer.NearUsageList_Active");
    NearUsageList[2] = GetListCtrlHandle(m_WindowName $ ".NearListContainer.ListContainer.NearUsageList_Positive");
    NearUsageList[3] = GetListCtrlHandle(m_WindowName $ ".NearListContainer.ListContainer.NearUsageList_Negative");
    NearUsageList[4] = GetListCtrlHandle(m_WindowName $ ".NearListContainer.ListContainer.NearUsageList_Special");
    CountTxt[0] = GetTextBoxHandle(m_WindowName $ ".AllCountTxt");
    CountTxt[1] = GetTextBoxHandle(m_WindowName $ ".ActiveCountTxt");
    CountTxt[2] = GetTextBoxHandle(m_WindowName $ ".PositiveCountTxt");
    CountTxt[3] = GetTextBoxHandle(m_WindowName $ ".NegativeCountTxt");
    CountTxt[4] = GetTextBoxHandle(m_WindowName $ ".SpecialCountTxt");
    MagicSkillUseSaveWnd = GetWindowHandle("MagicSkillUseSaveWnd");
    PresetContainer = GetWindowHandle("MagicSkillUseSaveWnd.PresetContainer");
    PresetList = GetListCtrlHandle("MagicSkillUseSaveWnd.PresetContainer.PresetList");
    btnAddPreset = GetButtonHandle("MagicSkillUseSaveWnd.PresetContainer.btnAddPreset");
    txtPresetName = GetTextBoxHandle("MagicSkillUseSaveWnd.PresetContainer.ChangePresetContainer.txtPresetName");
    txtPresetCount = GetTextBoxHandle("MagicSkillUseSaveWnd.PresetContainer.ChangePresetContainer.txtPresetCount");
    PresetLeftBtn = GetButtonHandle("MagicSkillUseSaveWnd.PresetContainer.ChangePresetContainer.PresetLeftBtn");
    PresetRightBtn = GetButtonHandle("MagicSkillUseSaveWnd.PresetContainer.ChangePresetContainer.PresetRightBtn");
    SaveTab = GetTabHandle("MagicSkillUseSaveWnd.SavedTabCtrl");
    SavedList = GetListCtrlHandle("MagicSkillUseSaveWnd.SelectedContainer.SelectedList");
    CurrSaveTxt = GetTextBoxHandle("MagicSkillUseSaveWnd.SelectedContainer.txtHeadInfoSizeCurrent");
    MaxSaveTxt = GetTextBoxHandle("MagicSkillUseSaveWnd.SelectedContainer.txtHeadInfoSizeMax");
    SideCountTxt[0] = GetTextBoxHandle("MagicSkillUseSaveWnd.SavedCountTxt");
    SideCountTxt[1] = GetTextBoxHandle("MagicSkillUseSaveWnd.PresetCountTxt");
    i = 0;
    J0x642:

    // End:0x684 [Loop If]
    if(i < 5)
    {
        NearUsageList[i].SetSelectedSelTooltip(false);
        NearUsageList[i].SetAppearTooltipAtMouseX(true);
        i++;
        // [Loop Continue]
        goto J0x642;
    }
    SavedList.SetSelectedSelTooltip(false);
    SavedList.SetAppearTooltipAtMouseX(true);
    PresetList.SetSelectedSelTooltip(false);
    PresetList.SetAppearTooltipAtMouseX(true);
    loadMagicHideData();
    ClearAllNearLists();
    switchPreset(true, 0);
    updateSavedSize(0);
    updatePresetListStep(0);
    updateSideTabCountByType(0, 0);
    updateSideTabCountByType(1, 0);
    GetINIBool("magichide", "AddNoIconSkills", tmpInt, "MagicHideSkills.dat");
    bHandleNoIcon = bool(tmpInt);
    return;
}

function OnShow()
{
    updateMyInfo();
    Me.KillTimer(1001);
    Me.SetTimer(1001, 3500);
    return;
}

function OnHide()
{
    ClearAllNearLists();
    showHideSave(false);
    Tab.SetTopOrder(0, true);
    MagicSkillUseSaveWnd.HideWindow();
    setLock(false);
    Me.KillTimer(1001);
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(150);
    RegisterEvent(290);
    RegisterEvent(3550);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int i;

    // End:0x15
    if(Event_ID == 150)
    {
        ClearAllNearLists();        
    }
    else
    {
        // End:0x44
        if(Event_ID == 290)
        {
            // End:0x41
            if(Me.IsShowWindow())
            {
                handleMagicSkillUse(param);
            }            
        }
        else
        {
            // End:0x5E
            if(Event_ID == 3550)
            {
                HandleOnEvent(param);
            }
        }
    }
    return;
}

function HandleOnEvent(string param)
{
    local int EventID;

    ParseInt(param, "EventID", EventID);
    // End:0x36
    if(EventID == 1040)
    {
        handleSavedSkillList(param);        
    }
    else
    {
        // End:0x54
        if(EventID == 1041)
        {
            Me.ShowWindow();
        }
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    local int listIndex;

    // End:0x2A
    if(InStr(ListCtrlID, "NearUsageList_") > -1)
    {
        rqAddHideSkill();        
    }
    else
    {
        // End:0x48
        if(ListCtrlID == "SelectedList")
        {
            rqDelHideSkill();
        }
    }
    return;
}

function OnClickButton(string strID)
{
    // End:0x32
    if(strID == "HelpBtn")
    {
        ShowPage("help_effect_hide.htm");        
    }
    else
    {
        // End:0x5A
        if(strID == "PresetLeftBtn")
        {
            switchPreset(false, -1);            
        }
        else
        {
            // End:0x83
            if(strID == "PresetRightBtn")
            {
                switchPreset(true, -1);                
            }
            else
            {
                // End:0xA4
                if(strID == "btnAddPreset")
                {
                    rqAddPresetSkill();                    
                }
                else
                {
                    // End:0xDE
                    if(strID == "SavedEffectsBtn")
                    {
                        switchPreset(true, 0);
                        showHideSave(!MagicSkillUseSaveWnd.IsShowWindow());
                    }
                }
            }
        }
    }
    return;
}

function OnTimer(int TimerID)
{
    Me.KillTimer(TimerID);
    // End:0x4D
    if(TimerID == 1001)
    {
        // End:0x34
        if(!isLock())
        {
            RefreshLists();
        }
        Me.SetTimer(1001, 3500);
    }
    return;
}

function handleSavedSkillList(string param)
{
    local int i, SkillID;
    local string Param1;
    local array<string> skillsData;
    local LVDataRecord Record;
    local SkillInfo SkillInfo;

    ParseString(param, "param1", Param1);
    SavedList.DeleteAllItem();
    HiddenSkills.Remove(0, HiddenSkills.Length);
    skillsData = Arr(Param1, ";");
    Record.LVDataList.Length = 1;
    i = 0;
    J0x5C:

    // End:0x1FD [Loop If]
    if(i < skillsData.Length)
    {
        SkillID = int(skillsData[i]);
        // End:0x99
        if(!GetSkillInfo(SkillID, 1, 0, SkillInfo))
        {
            // [Explicit Continue]
            goto J0x1F3;
        }
        HiddenSkills[HiddenSkills.Length] = SkillID;
        Record.LVDataList[0].bUseTextColor = true;
        Record.LVDataList[0].TextColor = getInstanceL2Util().Yellow03;
        Record.LVDataList[0].hasIcon = true;
        Record.LVDataList[0].FirstLineOffsetX = 6;
        Record.LVDataList[0].IconPosX = 1;
        Record.LVDataList[0].nTextureWidth = 16;
        Record.LVDataList[0].nTextureHeight = 16;
        Record.LVDataList[0].nTextureU = 32;
        Record.LVDataList[0].nTextureV = 32;
        Record.LVDataList[0].szData = SkillInfo.SkillName;
        Record.LVDataList[0].szTexture = SkillInfo.TexName;
        Record.szReserved = "1";
        Record.nReserved1 = (SkillID);
        Record.nReserved2 = (1);
        Record.nReserved3 = (0);
        SavedList.InsertRecord(Record);
        J0x1F3:

        i++;
        // [Loop Continue]
        goto J0x5C;
    }
    updateSideTabCountByType(0, HiddenSkills.Length);
    updateSavedSize(HiddenSkills.Length);
    switchPreset(true, currentPresetIndex);
    return;
}

function handleMagicSkillUse(string param)
{
    local int SkillID, AttackerID, broadcastingIndex;
    local UserInfo AttackerInfo;
    local SkillInfo UsedSkillInfo;
    local ItemInfo SkillToItem;
    local LVDataRecord Record;
    local ListCtrlHandle currentList;

    // End:0x0B
    if(isLock())
    {
        return;
    }
    ParseInt(param, "SkillID", SkillID);
    // End:0x34
    if(isExceptSkill(SkillID))
    {
        return;
    }
    // End:0x44
    if(isSavedSkill(SkillID))
    {
        return;
    }
    GetSkillInfo(SkillID, 1, 0, UsedSkillInfo);
    // End:0x76
    if(!bHandleNoIcon)
    {
        // End:0x76
        if(isNoIcon(UsedSkillInfo.TexName))
        {
            return;
        }
    }
    ParseInt(param, "AttackerID", AttackerID);
    Record = getMagicUseRecord(UsedSkillInfo, AttackerID, false);
    // End:0xDA
    if(broadcastingSkillInList(SkillID, broadcastingIndex))
    {
        modifyTotalNearList(broadcastingIndex, Record);
        modifyFilterNearList(Record);        
    }
    else
    {
        addTotalNearList(Record);
        addFilterNearList(Record);
    }
    return;
}

function addTotalNearList(LVDataRecord Record)
{
    NearUsageList[0].InsertRecord(Record);
    updateTabCountByType(0, NearUsageList[0].GetRecordCount());
    return;
}

function modifyTotalNearList(int nIndex, LVDataRecord Record)
{
    NearUsageList[0].ModifyRecord(nIndex, Record);
    return;
}

function addFilterNearList(LVDataRecord Record)
{
    local int nSkillType;
    local ListCtrlHandle targetList;

    nSkillType = getSkillListType(name(Record.nReserved3));
    targetList = NearUsageList[nSkillType];
    updateTabCountByType(nSkillType, targetList.GetRecordCount());
    targetList.InsertRecord(Record);
    return;
}

function deleteFromNearLists(LVDataRecord Record)
{
    local int i, nSkillType;
    local LVDataRecord targetRecord;
    local ListCtrlHandle targetList;

    setLock(true);
    targetList = NearUsageList[0];
    i = 0;
    J0x1B:

    // End:0x8A [Loop If]
    if(i < NearUsageList[0].GetRecordCount())
    {
        targetList.GetRec(i, targetRecord);
        // End:0x80
        if(__NFUN_412__(targetRecord.nReserved1, Record.nReserved1))
        {
            targetList.DeleteRecord(i);
            // [Explicit Break]
            goto J0x8A;
        }
        i++;
        // [Loop Continue]
        goto J0x1B;
    }
    J0x8A:

    updateTabCountByType(0, targetList.GetRecordCount());
    nSkillType = getSkillListType(name(Record.nReserved3));
    targetList = NearUsageList[nSkillType];
    i = 0;
    J0xD0:

    // End:0x13D [Loop If]
    if(i < targetList.GetRecordCount())
    {
        targetList.GetRec(i, targetRecord);
        // End:0x133
        if(__NFUN_412__(targetRecord.nReserved1, Record.nReserved1))
        {
            targetList.DeleteRecord(i);
            // [Explicit Break]
            goto J0x13D;
        }
        i++;
        // [Loop Continue]
        goto J0xD0;
    }
    J0x13D:

    setLock(false);
    updateTabCountByType(nSkillType, targetList.GetRecordCount());
    return;
}

function modifyFilterNearList(LVDataRecord Record)
{
    local int i;
    local LVDataRecord targetRecord;
    local ListCtrlHandle targetList;

    targetList = NearUsageList[getSkillListType(name(Record.nReserved3))];
    i = 0;
    J0x25:

    // End:0x96 [Loop If]
    if(i < targetList.GetRecordCount())
    {
        targetList.GetRec(i, targetRecord);
        // End:0x8C
        if(__NFUN_412__(targetRecord.nReserved1, Record.nReserved1))
        {
            targetList.ModifyRecord(i, Record);
            return;
        }
        i++;
        // [Loop Continue]
        goto J0x25;
    }
    return;
}

function RefreshLists()
{
    local int i, j;
    local LVDataRecord Record;
    local UserInfo Info;
    local int vDist, currentListSize;

    setLock(true);
    updateMyInfo();
    i = 0;
    J0x14:

    // End:0x11D [Loop If]
    if(i < 5)
    {
        currentListSize = NearUsageList[i].GetRecordCount();
        // End:0x55
        if(currentListSize <= 0)
        {
            updateTabCountByType(i, 0);
            // [Explicit Continue]
            goto J0x113;
        }
        j = currentListSize - 1;
        J0x63:

        // End:0xF3 [Loop If]
        if(j >= 0)
        {
            NearUsageList[i].GetRec(j, Record);
            // End:0xE9
            if(!GetUserInfo(name(Record.nReserved2), Info) || VSize(MyInfo.loc - Info.loc) > float(4500))
            {
                NearUsageList[i].DeleteRecord(j);
            }
            j--;
            // [Loop Continue]
            goto J0x63;
        }
        updateTabCountByType(i, NearUsageList[i].GetRecordCount());
        J0x113:

        i++;
        // [Loop Continue]
        goto J0x14;
    }
    setLock(false);
    return;
}

function LVDataRecord getMagicUseRecord(SkillInfo UsedSkillInfo, int AttackerID, bool bGold)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 1;
    Record.LVDataList[0].bUseTextColor = bGold;
    Record.LVDataList[0].TextColor = getInstanceL2Util().Yellow03;
    Record.LVDataList[0].hasIcon = true;
    Record.LVDataList[0].FirstLineOffsetX = 6;
    Record.LVDataList[0].IconPosX = 1;
    Record.LVDataList[0].nTextureWidth = 22;
    Record.LVDataList[0].nTextureHeight = 22;
    Record.LVDataList[0].nTextureU = 32;
    Record.LVDataList[0].nTextureV = 32;
    Record.LVDataList[0].szData = UsedSkillInfo.SkillName;
    Record.LVDataList[0].szTexture = UsedSkillInfo.TexName;
    Record.LVDataList[0].nReserved1 = int(bGold);
    Record.szReserved = "1";
    Record.nReserved1 = (UsedSkillInfo.SkillID);
    Record.nReserved2 = (AttackerID);
    Record.nReserved3 = (UsedSkillInfo.IconType);
    return Record;
    return;
}

function updateMyInfo()
{
    GetPlayerInfo(MyInfo);
    return;
}

function int getSkillListType(int IconType)
{
    // End:0x1D
    if((IconType == 0) || IconType == 1)
    {
        return 1;        
    }
    else
    {
        // End:0x2F
        if(IconType == 2)
        {
            return 2;            
        }
        else
        {
            // End:0x41
            if(IconType == 3)
            {
                return 3;                
            }
            else
            {
                return 4;
            }
        }
    }
    return;
}

function showHideSave(bool bShow)
{
    // End:0x1D
    if(!bShow)
    {
        MagicSkillUseSaveWnd.HideWindow();        
    }
    else
    {
        SaveTab.SetTopOrder(0, true);
        MagicSkillUseSaveWnd.ShowWindow();
    }
    return;
}

function ListCtrlHandle getSelectedNearList(out LVDataRecord Record)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x5B [Loop If]
    if(i < 5)
    {
        // End:0x51
        if(NearUsageList[i].IsShowWindow())
        {
            NearUsageList[i].GetSelectedRec(Record);
            return NearUsageList[i];
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function ClearAllNearLists()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x3E [Loop If]
    if(i < 5)
    {
        NearUsageList[i].DeleteAllItem();
        updateTabCountByType(i, 0);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function updateTabCountByType(int Index, int Count)
{
    local string strCount;

    // End:0x1A
    if(Count > 99)
    {
        strCount = "99+";        
    }
    else
    {
        strCount = string(Count);
    }
    CountTxt[Index].SetText(strCount);
    return;
}

function updateSideTabCountByType(int Index, int Count)
{
    local string strCount;

    // End:0x1A
    if(Count > 99)
    {
        strCount = "99+";        
    }
    else
    {
        strCount = string(Count);
    }
    SideCountTxt[Index].SetText(string(Count));
    return;
}

function updateSavedSize(int nCurrent)
{
    local Color Color;

    // End:0x22
    if(nCurrent == 0)
    {
        Color = GetColor(255, 255, 255, 255);        
    }
    else
    {
        // End:0x45
        if(nCurrent < 50)
        {
            Color = GetColor(222, 255, 209, 255);            
        }
        else
        {
            Color = GetColor(255, 209, 209, 255);
        }
    }
    CurrSaveTxt.SetText(string(nCurrent));
    CurrSaveTxt.SetTextColor(Color);
    MaxSaveTxt.SetText(string(50));
    return;
}

function bool broadcastingSkillInList(int SkillID, optional out int Index)
{
    local int i;
    local LVDataRecord Record;

    Index = -1;
    i = 0;
    J0x12:

    // End:0x76 [Loop If]
    if(i < NearUsageList[0].GetRecordCount())
    {
        NearUsageList[0].GetRec(i, Record);
        // End:0x6C
        if(__NFUN_412__(Record.nReserved1, (SkillID)))
        {
            Index = i;
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    return;
}

function bool isNoIcon(string TexName)
{
    return TexName == "icon.skill0000";
    return;
}

function bool isExceptSkill(int SkillID)
{
    local int i;

    // End:0x11
    if(SkillID == 7029)
    {
        return true;
    }
    i = 0;
    J0x18:

    // End:0x49 [Loop If]
    if(i < ExceptSkills.Length)
    {
        // End:0x3F
        if(ExceptSkills[i] == SkillID)
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x18;
    }
    return;
}

function bool isSavedSkill(int SkillID)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(i < HiddenSkills.Length)
    {
        // End:0x2E
        if(HiddenSkills[i] == SkillID)
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function bool isSpecialSkills(int SkillID)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(i < SpecialSkills.Length)
    {
        // End:0x2E
        if(SpecialSkills[i] == SkillID)
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function rqAddPresetSkill()
{
    local int i, SkillID, newSavedSkillsCount;
    local string param;
    local LVDataRecord Record;

    newSavedSkillsCount = 0;
    i = 0;
    J0x0E:

    // End:0xAD [Loop If]
    if(i < PresetList.GetRecordCount())
    {
        PresetList.GetRec(i, Record);
        // End:0xA3
        if(Record.LVDataList[0].nReserved1 == 0)
        {
            // End:0x78
            if(param == "")
            {
                param = (Record.nReserved1);                
            }
            else
            {
                param = param @ (Record.nReserved1);
            }
            deleteFromNearLists(Record);
            newSavedSkillsCount++;
        }
        i++;
        // [Loop Continue]
        goto J0x0E;
    }
    // End:0xF9
    if((HiddenSkills.Length + newSavedSkillsCount) > 50)
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(7708));
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(7716));
        return;
    }
    // End:0x11B
    if(param != "")
    {
        RequestBypassToServer("setHsPr" @ param);
    }
    return;
}

function rqAddHideSkill()
{
    local int i, SkillID;
    local LVDataRecord targetRecord;
    local ListCtrlHandle targetList;

    // End:0x45
    if(HiddenSkills.Length >= 50)
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(7708));
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(7716));
        return;
    }
    targetList = getSelectedNearList(targetRecord);
    SkillID = name(targetRecord.nReserved1);
    RequestBypassToServer("setHs" @ string(SkillID));
    deleteFromNearLists(targetRecord);
    showHideSave(true);
    return;
}

function rqDelHideSkill()
{
    local int i;
    local LVDataRecord Record;

    SavedList.GetSelectedRec(Record);
    RequestBypassToServer("delHs" @ (Record.nReserved1));
    return;
}

function switchPreset(bool bNext, int specialIndex)
{
    local int i;
    local _PresetList targetPreset;
    local LVDataRecord Record;
    local SkillInfo SkillInfo;
    local bool bIsSavedSkill, bCanSavePreset, bButtonEnabled;

    PresetList.DeleteAllItem();
    // End:0x48
    if(PresetDataList.Length == 0)
    {
        currentPresetIndex = -1;
        txtPresetName.SetText(GetSystemString(7714));
        updatePresetSwitchButtons();
        return;
    }
    // End:0x61
    if(specialIndex >= 0)
    {
        currentPresetIndex = specialIndex;        
    }
    else
    {
        // End:0x86
        if(bNext)
        {
            currentPresetIndex = Min(currentPresetIndex + 1, PresetDataList.Length - 1);            
        }
        else
        {
            currentPresetIndex = Max(currentPresetIndex - 1, 0);
        }
    }
    targetPreset = PresetDataList[currentPresetIndex];
    txtPresetName.SetText(targetPreset.PresetName);
    i = 0;
    J0xC8:

    // End:0x15A [Loop If]
    if(i < targetPreset.PresetSkillIDs.Length)
    {
        GetSkillInfo(targetPreset.PresetSkillIDs[i], 1, 0, SkillInfo);
        bIsSavedSkill = isSavedSkill(SkillInfo.SkillID);
        // End:0x124
        if(!bIsSavedSkill)
        {
            bCanSavePreset = true;
        }
        Record = getMagicUseRecord(SkillInfo, 0, bIsSavedSkill);
        PresetList.InsertRecord(Record);
        i++;
        // [Loop Continue]
        goto J0xC8;
    }
    bButtonEnabled = bCanSavePreset && HiddenSkills.Length < 50;
    updatePresetListStep(currentPresetIndex + 1);
    updateSideTabCountByType(1, PresetDataList.Length);
    updatePresetSaveButton(bButtonEnabled);
    updatePresetSwitchButtons();
    return;
}

function updatePresetSaveButton(bool B)
{
    // End:0x1B
    if(B)
    {
        btnAddPreset.EnableWindow();        
    }
    else
    {
        btnAddPreset.DisableWindow();
    }
    return;
}

function updatePresetListStep(int Count)
{
    txtPresetCount.SetText((string(Count) $ "/") $ string(PresetDataList.Length));
    return;
}

function updatePresetSwitchButtons()
{
    // End:0x2D
    if(PresetDataList.Length == 0)
    {
        PresetRightBtn.DisableWindow();
        PresetLeftBtn.DisableWindow();        
    }
    else
    {
        // End:0x4A
        if(currentPresetIndex > 0)
        {
            PresetLeftBtn.EnableWindow();            
        }
        else
        {
            PresetLeftBtn.DisableWindow();
        }
        // End:0x7E
        if(currentPresetIndex < (PresetDataList.Length - 1))
        {
            PresetRightBtn.EnableWindow();            
        }
        else
        {
            PresetRightBtn.DisableWindow();
        }
    }
    return;
}

function clearPresetData()
{
    local array<_PresetList> tmpPresetData;

    PresetDataList = tmpPresetData;
    return;
}

function loadMagicHideData()
{
    local int i, PresetStringNameID;
    local string strLine, presetSkillsStrLine;
    local _PresetList preset, clearPreset;

    ExceptSkills = getIniArrayInt("magichide", "ExceptSkills", "MagicHideSkills.dat");
    SpecialSkills = getIniArrayInt("magichide", "SpecialSkills", "MagicHideSkills.dat");
    clearPresetData();
    i = 0;
    J0x82:

    // End:0x164 [Loop If]
    if(GetINIString("presetlist", "id" $ string(i + 1), strLine, "MagicHideSkills.dat"))
    {
        preset = clearPreset;
        ParseInt(strLine, "PresetStringNameID", PresetStringNameID);
        preset.PresetName = GetSystemString(PresetStringNameID);
        ParseString(strLine, "PresetSkills", presetSkillsStrLine);
        preset.PresetSkillIDs = arrInt(presetSkillsStrLine, ";");
        PresetDataList.Insert(i, 1);
        PresetDataList[i] = preset;
        i++;
        // [Loop Continue]
        goto J0x82;
    }
    return;
}

function setLock(bool B)
{
    bListsPrepare = B;
    return;
}

function bool isLock()
{
    return bListsPrepare;
    return;
}
