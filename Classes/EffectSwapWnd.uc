class EffectSwapWnd extends UICommonAPI;

struct EffectGroup
{
    var array<ItemInfo> Effects;
};

struct _SwappedObjectsInfos
{
    var array<EffectGroup> SwapInfo;
};

struct _ToggleCache
{
    var array<int> Toggles;
};

struct _UsedEffect
{
    var int EffectID;
    var int page;
};

var WindowHandle Me;
var ItemWindowHandle EffectList;
var TextBoxHandle EffectSwapTypeTxt;
var TextBoxHandle EffectSwapTypeDescTxt;
var AbnormalStatusWnd AbnormalStatusWnd;
var SummonedStatusWnd SummonedStatusWnd;
var PetStatusWnd PetStatusWnd;
var PartyWnd PartyWnd;
var Paginator Paginator;
var int currentPage;
var array<_SwappedObjectsInfos> SwappedObjectsInfo;
var array<_ToggleCache> ToggleCache;
var array<_UsedEffect> UsedEffects;
var bool bPrevDebuffRowState;

function OnRegisterEvent()
{
    // End:0x23
    if(DebugSectorBool("debug", "noloadeffswpwnd"))
    {
        return;
    }
    RegisterEvent(9750);
    RegisterEvent(150);
    return;
}

function OnEvent(int EventID, string Str)
{
    // End:0x23
    if(DebugSectorBool("debug", "noloadeffswpwnd"))
    {
        return;
    }
    // End:0x39
    if(EventID == 9750)
    {
        setPage(1);
    }
    // End:0x58
    if(EventID == 150)
    {
        cacheEffectGroups();
        loadUsedObjects();
        setPage(1);
    }
    return;
}

function OnLoad()
{
    // End:0x23
    if(DebugSectorBool("debug", "noloadeffswpwnd"))
    {
        return;
    }
    Me = GetWindowHandle("EffectSwapWnd");
    EffectList = GetItemWindowHandle("EffectSwapWnd.EffectListWnd.EffectList");
    EffectSwapTypeTxt = GetTextBoxHandle("EffectSwapWnd.EffectSwapTypeTxt");
    EffectSwapTypeDescTxt = GetTextBoxHandle("EffectSwapWnd.EffectSwapTypeDescTxt");
    AbnormalStatusWnd = AbnormalStatusWnd(GetScript("AbnormalStatusWnd"));
    PartyWnd = PartyWnd(GetScript("PartyWnd"));
    SummonedStatusWnd = SummonedStatusWnd(GetScript("SummonedStatusWnd"));
    PetStatusWnd = PetStatusWnd(GetScript("PetStatusWnd"));
    currentPage = 1;
    initPaginator();
    return;
}

function OnShow()
{
    // End:0x5F
    if(AbnormalStatusWnd.separateDebuffCBox.IsChecked())
    {
        bPrevDebuffRowState = true;
        AbnormalStatusWnd.separateDebuffCBox.SetCheck(false);
        AbnormalStatusWnd.OnClickCheckBox("separateDebuffCBox");
    }
    AbnormalStatusWnd.separateDebuffCBox.HideWindow();
    AbnormalStatusWnd.swapEffectCBox.SetCheck(true);
    return;
}

function OnHide()
{
    // End:0x4A
    if(bPrevDebuffRowState)
    {
        AbnormalStatusWnd.separateDebuffCBox.SetCheck(bPrevDebuffRowState);
        AbnormalStatusWnd.OnClickCheckBox("separateDebuffCBox");
    }
    AbnormalStatusWnd.separateDebuffCBox.ShowWindow();
    AbnormalStatusWnd.swapEffectCBox.SetCheck(false);
    return;
}

function initPaginator()
{
    Paginator = new Class'Interface.Paginator';
    Paginator.SetPaginatorElement(GetTextBoxHandle(""), GetTextBoxHandle(""), GetButtonHandle("EffectSwapWnd.NextBtn"), GetButtonHandle("EffectSwapWnd.PrevBtn"), GetButtonHandle(""), GetButtonHandle(""));
    Paginator.__onPageNext__Delegate = handlePageNext;
    Paginator.__onPagePrev__Delegate = handlePagePrev;
    Paginator.setPages(1, 3);
    return;
}

function cacheEffectGroups()
{
    local int i, j, page;
    local string configEffects;
    local array<string> grouplist, strEffectList;
    local SkillInfo SkillInf;
    local ItemInfo ItemInf;
    local array<ItemInfo> groupEffects;

    SwappedObjectsInfo.Length = 0;
    ToggleCache.Length = 3;
    UsedEffects.Length = 0;
    EffectList.Clear();
    page = 1;
    J0x2F:

    // End:0x292 [Loop If]
    if(page <= 3)
    {
        currentPage = page;
        GetINIString(getIniTypeStringName(), "EFFECT_LIST", configEffects, "AbnormalEffect.dat");
        grouplist = Arr(configEffects, ";");
        // End:0xAA
        if(SwappedObjectsInfo.Length < grouplist.Length)
        {
            SwappedObjectsInfo.Length = grouplist.Length;
        }
        ToggleCache[page - 1].Toggles.Length = grouplist.Length;
        i = 0;
        J0xCC:

        // End:0x288 [Loop If]
        if(i < grouplist.Length)
        {
            strEffectList = Arr(grouplist[i], ",");
            groupEffects.Length = 0;
            j = 0;
            J0x105:

            // End:0x1E6 [Loop If]
            if(j < strEffectList.Length)
            {
                // End:0x1DC
                if(int(strEffectList[j]) > 0)
                {
                    GetSkillInfo(int(strEffectList[j]), 1, 0, SkillInf);
                    ItemInf.Id = GetItemID(SkillInf.SkillID);
                    ItemInf.Name = SkillInf.SkillName;
                    ItemInf.Level = SkillInf.SkillLevel;
                    ItemInf.SubLevel = 0;
                    ItemInf.Description = SkillInf.SkillDesc;
                    ItemInf.IconName = SkillInf.TexName;
                    ItemInf.ItemSubType = 2;
                    groupEffects[groupEffects.Length] = ItemInf;
                }
                j++;
                // [Loop Continue]
                goto J0x105;
            }
            // End:0x212
            if(SwappedObjectsInfo[i].SwapInfo.Length < 3)
            {
                SwappedObjectsInfo[i].SwapInfo.Length = 3;
            }
            SwappedObjectsInfo[i].SwapInfo[page - 1].Effects = groupEffects;
            // End:0x27E
            if(((page == 1) && groupEffects.Length > 0) && groupEffects[0].Id.ClassID > 0)
            {
                EffectList.AddItem(groupEffects[0]);
            }
            i++;
            // [Loop Continue]
            goto J0xCC;
        }
        page++;
        // [Loop Continue]
        goto J0x2F;
    }
    return;
}

function handlePage(int nPage)
{
    setPage(nPage);
    handleOpen(true);
    return;
}

function setPage(int nPage)
{
    local int i;

    currentPage = nPage;
    Paginator.setPages(currentPage, 3);
    updateUI();
    EffectList.Clear();
    i = 0;
    J0x3D:

    // End:0xDD [Loop If]
    if(i < SwappedObjectsInfo.Length)
    {
        // End:0xD3
        if((SwappedObjectsInfo[i].SwapInfo[currentPage - 1].Effects.Length > 0) && SwappedObjectsInfo[i].SwapInfo[currentPage - 1].Effects[0].Id.ClassID > 0)
        {
            EffectList.AddItem(SwappedObjectsInfo[i].SwapInfo[currentPage - 1].Effects[0]);
        }
        i++;
        // [Loop Continue]
        goto J0x3D;
    }
    return;
}

function handleOpen(optional bool bForceOpen)
{
    // End:0x1A
    if(bForceOpen)
    {
        Me.ShowWindow();
        return;
    }
    // End:0x3E
    if(Me.IsShowWindow())
    {
        Me.HideWindow();        
    }
    else
    {
        Me.ShowWindow();
    }
    return;
}

function OnClickButton(string bID)
{
    switch(bID)
    {
        // End:0x25
        case "SaveBtn":
            Me.HideWindow();
            // End:0x67
            break;
        // End:0x43
        case "NextBtn":
            Paginator.setNextPage();
            // End:0x67
            break;
        // End:0x61
        case "PrevBtn":
            Paginator.setPrevPage();
            // End:0x67
            break;
        // End:0xFFFF
        default:
            // End:0x67
            break;
            break;
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    disableSeparatedDebuff();
    setToggle(!bool(ToggleCache[currentPage - 1].Toggles[Index]), Index);
    updateCurrentEffectLists();
    saveUsedObjects();
    return;
}

function disableSeparatedDebuff()
{
    return;
}

function handlePageNext()
{
    currentPage = Paginator.getCurrentPage();
    setPage(currentPage);
    updateUI();
    return;
}

function handlePagePrev()
{
    currentPage = Paginator.getCurrentPage();
    setPage(currentPage);
    updateUI();
    return;
}

function updateUI()
{
    EffectSwapTypeTxt.SetAlpha(0);
    EffectSwapTypeDescTxt.SetAlpha(0);
    EffectSwapTypeTxt.SetAlpha(255, 0.1500000);
    EffectSwapTypeDescTxt.SetAlpha(255, 0.1500000);
    EffectSwapTypeTxt.SetText(getStringTypeName(currentPage));
    EffectSwapTypeDescTxt.SetText(getStringTypeDesc(currentPage));
    return;
}

function setToggle(bool bToggle, int Index)
{
    local int i, effectCount;

    ToggleCache[currentPage - 1].Toggles[Index] = int(bToggle);
    effectCount = SwappedObjectsInfo[Index].SwapInfo[currentPage - 1].Effects.Length;
    i = 0;
    J0x4E:

    // End:0xD7 [Loop If]
    if(i < effectCount)
    {
        SwappedObjectsInfo[Index].SwapInfo[currentPage - 1].Effects[i].IsToggle = bToggle;
        setEffectUsed(SwappedObjectsInfo[Index].SwapInfo[currentPage - 1].Effects[i].Id.ClassID, currentPage, bToggle);
        i++;
        // [Loop Continue]
        goto J0x4E;
    }
    // End:0x116
    if(effectCount > 0)
    {
        EffectList.SetItem(Index, SwappedObjectsInfo[Index].SwapInfo[currentPage - 1].Effects[0]);
    }
    return;
}

function loadUsedObjects()
{
    local int i, j, page, objectsLength, groupCount, effectCount;

    local bool bToggle;
    local array<string> usedGroups;

    page = 1;
    J0x07:

    // End:0x242 [Loop If]
    if(page <= 3)
    {
        objectsLength = GetOptionInt("SwapEffect" $ string(page), "Length");
        usedGroups = Arr(GetOptionString("SwapEffect" $ string(page), "Groups"), ";");
        // End:0xA6
        if(ToggleCache[page - 1].Toggles.Length < objectsLength)
        {
            ToggleCache[page - 1].Toggles.Length = objectsLength;
        }
        groupCount = Min(objectsLength, SwappedObjectsInfo.Length);
        i = 0;
        J0xC0:

        // End:0x238 [Loop If]
        if(i < groupCount)
        {
            // End:0xF0
            if(SwappedObjectsInfo[i].SwapInfo.Length <= (page - 1))
            {
                // [Explicit Continue]
                goto J0x22E;
            }
            effectCount = SwappedObjectsInfo[i].SwapInfo[page - 1].Effects.Length;
            // End:0x123
            if(effectCount == 0)
            {
                // [Explicit Continue]
                goto J0x22E;
            }
            bToggle = bool(int(usedGroups[i]));
            ToggleCache[page - 1].Toggles[i] = int(bToggle);
            j = 0;
            J0x162:

            // End:0x1EB [Loop If]
            if(j < effectCount)
            {
                SwappedObjectsInfo[i].SwapInfo[page - 1].Effects[j].IsToggle = bToggle;
                setEffectUsed(SwappedObjectsInfo[i].SwapInfo[page - 1].Effects[j].Id.ClassID, page, bToggle);
                j++;
                // [Loop Continue]
                goto J0x162;
            }
            // End:0x22E
            if(page == currentPage)
            {
                EffectList.SetItem(i, SwappedObjectsInfo[i].SwapInfo[page - 1].Effects[0]);
            }
            J0x22E:

            i++;
            // [Loop Continue]
            goto J0xC0;
        }
        page++;
        // [Loop Continue]
        goto J0x07;
    }
    updateCurrentEffectLists();
    return;
}

function bool getIsUsedObject(int Id, int page)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x59 [Loop If]
    if(i < UsedEffects.Length)
    {
        // End:0x4F
        if((UsedEffects[i].EffectID == Id) && UsedEffects[i].page == page)
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function setEffectUsed(int EffectID, int page, bool bUsed)
{
    local int i;
    local _UsedEffect usedEffect;

    i = 0;
    J0x07:

    // End:0x70 [Loop If]
    if(i < UsedEffects.Length)
    {
        // End:0x66
        if((UsedEffects[i].EffectID == EffectID) && UsedEffects[i].page == page)
        {
            // End:0x64
            if(!bUsed)
            {
                UsedEffects.Remove(i, 1);
            }
            return;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0xAB
    if(bUsed)
    {
        usedEffect.EffectID = EffectID;
        usedEffect.page = page;
        UsedEffects[UsedEffects.Length] = usedEffect;
    }
    return;
}

function bool isPageSkillsActive(int page)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x76 [Loop If]
    if(i < ToggleCache[page - 1].Toggles.Length)
    {
        // End:0x6C
        if((SwappedObjectsInfo[i].SwapInfo[page - 1].Effects.Length > 0) && bool(ToggleCache[page - 1].Toggles[i]))
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function updateCurrentEffectLists()
{
    // End:0x43
    if(GetWindowHandle("AbnormalStatusWnd").IsShowWindow())
    {
        AbnormalStatusWnd.HandleAddNormalStatus(AbnormalStatusWnd.LastPacketData);
    }
    // End:0x7D
    if(GetWindowHandle("PartyWnd").IsShowWindow())
    {
        PartyWnd.HandlePartySpelledList(PartyWnd.LastPacketData);
    }
    // End:0xC0
    if(GetWindowHandle("SummonedStatusWnd").IsShowWindow())
    {
        SummonedStatusWnd.HandleSummonedStatusSpelledList(SummonedStatusWnd.LastPacketData);
    }
    // End:0xFE
    if(GetWindowHandle("PetStatusWnd").IsShowWindow())
    {
        PetStatusWnd.HandlePetStatusSpelledList(PetStatusWnd.LastPacketData);
    }
    return;
}

function clearUsedObjects()
{
    local int i, page;

    page = 1;
    J0x07:

    // End:0x7E [Loop If]
    if(page <= 3)
    {
        i = 0;
        J0x1A:

        // End:0x74 [Loop If]
        if(i < GetOptionInt("SwapEffect" $ string(page), "Length"))
        {
            SetOptionInt("SwapEffect" $ string(page), string(i), 0);
            i++;
            // [Loop Continue]
            goto J0x1A;
        }
        page++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function saveUsedObjects()
{
    local int i, page;
    local string usedGroups;

    clearUsedObjects();
    page = 1;
    J0x0D:

    // End:0x160 [Loop If]
    if(page <= 3)
    {
        SetOptionInt("SwapEffect" $ string(page), "Length", SwappedObjectsInfo.Length);
        usedGroups = "";
        i = 0;
        J0x51:

        // End:0x12E [Loop If]
        if(i < SwappedObjectsInfo.Length)
        {
            // End:0x124
            if((SwappedObjectsInfo[i].SwapInfo.Length > (page - 1)) && SwappedObjectsInfo[i].SwapInfo[page - 1].Effects.Length > 0)
            {
                SetOptionInt("SwapEffect" $ string(page), string(i), ToggleCache[page - 1].Toggles[i]);
                // End:0xFC
                if(i > 0)
                {
                    usedGroups = usedGroups $ ";";
                }
                usedGroups = usedGroups $ string(ToggleCache[page - 1].Toggles[i]);
            }
            i++;
            // [Loop Continue]
            goto J0x51;
        }
        SetOptionString("SwapEffect" $ string(page), "Groups", usedGroups);
        page++;
        // [Loop Continue]
        goto J0x0D;
    }
    return;
}

function string getIniTypeStringName()
{
    switch(currentPage)
    {
        // End:0x1C
        case 1:
            return "SWAP_CHARACTER";
        // End:0x2E
        case 2:
            return "SWAP_PARTY";
        // End:0x44
        case 3:
            return "SWAP_PETSUMMON";
        // End:0xFFFF
        default:
            // End:0x4A
            break;
            break;
    }
    return;
}

function string getStringTypeName(int nPage)
{
    switch(nPage)
    {
        // End:0x17
        case 1:
            return GetSystemString(7918);
        // End:0x28
        case 2:
            return GetSystemString(7919);
        // End:0x39
        case 3:
            return GetSystemString(7920);
        // End:0xFFFF
        default:
            // End:0x3F
            break;
            break;
    }
    return;
}

function string getStringTypeDesc(int nPage)
{
    switch(nPage)
    {
        // End:0x17
        case 1:
            return GetSystemString(7921);
        // End:0x28
        case 2:
            return GetSystemString(7922);
        // End:0x39
        case 3:
            return GetSystemString(7923);
        // End:0xFFFF
        default:
            // End:0x3F
            break;
            break;
    }
    return;
}
