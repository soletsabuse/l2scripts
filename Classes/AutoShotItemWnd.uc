class AutoShotItemWnd extends UICommonAPI;

const ITEM_ADD = 1;
const ITEM_SET = 2;
const ITEM_CLEAR = 3;
const TIME_ID = 30021;
const TIME_DELAY = 5000;

struct slotData
{
    var bool bNoticeShow;
    var string tooltipStr;
};

var WindowHandle Me;
var WindowHandle AutoShotItemSubWnd;
var int petID;
var int SummonID;
var TextureHandle petIconTexture;
var bool hasWeapon;
var bool bSummon;
var bool bPet;
var bool bBeforeSummon;
var bool bBeforePet;
var int showNoticeNum;
var int currentSelectSoulShotWndIndex;
var ItemInfo weaponItemInfo;
var ItemInfo beforeWeaponInfo;
var ShortcutWnd ShortcutWndScript;
var array<slotData> slotArray;
var bool bFishShotAutoOff;
var bool bFishShotFirstInvLoad;

function OnRegisterEvent()
{
    RegisterEvent(20180);
    RegisterEvent(20182);
    RegisterEvent(9570);
    RegisterEvent(40);
    RegisterEvent(693);
    RegisterEvent(9750);
    RegisterEvent(2600);
    RegisterEvent(2610);
    RegisterEvent(2620);
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("AutoShotItemWnd");
    AutoShotItemSubWnd = GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd");
    ShortcutWndScript = ShortcutWnd(GetScript("ShortcutWnd"));
    Init();
    return;
}

function CustomTooltip SetTooltip(string Text)
{
    local CustomTooltip ToolTip;
    local DrawItemInfo Info;

    ToolTip.MinimumWidth = 144;
    ToolTip.DrawList.Length = 1;
    Info.eType = 1;
    Info.t_color.R = 178;
    Info.t_color.G = 190;
    Info.t_color.B = 207;
    Info.t_color.A = byte(255);
    Info.t_strText = Text;
    ToolTip.DrawList[0] = Info;
    return ToolTip;
    return;
}

function Init()
{
    local int i;
    local ItemInfo tempInfo;

    slotArray.Length = 4;
    i = 1;
    J0x10:

    // End:0x26E [Loop If]
    if(i < 5)
    {
        GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(i)).Clear();
        GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(i)).Clear();
        // End:0x186
        if((i == 1) || i == 2)
        {
            GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(i)).SetTooltipText(GetSystemMessage(6828));
            GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(i)).SetTooltipText(GetSystemMessage(6828));            
        }
        else
        {
            GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.ShotItemSlot" $ string(i)).SetTooltipText(GetSystemMessage(6829));
            GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.ShotItemSlot" $ string(i)).SetTooltipText(GetSystemMessage(6829));
        }
        slotArray[i - 1].bNoticeShow = false;
        slotArray[i - 1].tooltipStr = "";
        i++;
        // [Loop Continue]
        goto J0x10;
    }
    petID = 0;
    SummonID = 0;
    showNoticeNum = 0;
    hasWeapon = false;
    bBeforeSummon = false;
    bBeforePet = false;
    bFishShotAutoOff = false;
    bFishShotFirstInvLoad = true;
    beforeWeaponInfo = tempInfo;
    weaponItemInfo = tempInfo;
    GetWindowHandle(getSlotPath(false, 1)).HideWindow();
    GetWindowHandle(getSlotPath(true, 1)).HideWindow();
    GetWindowHandle(getSlotPath(false, 3)).HideWindow();
    GetWindowHandle(getSlotPath(true, 3)).HideWindow();
    HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
    Me.HideWindow();
    Me.KillTimer(30021);
    return;
}

function OnShow()
{
    windowPositionAutoMove();
    return;
}

function OnDefaultPosition()
{
    windowPositionAutoMove();
    checkSlotShowState();
    return;
}

function windowPositionAutoMove()
{
    // End:0x27
    if(!IsUseAutoEquipSoulShot() || GetGameStateName() != "GAMINGSTATE")
    {
        return;
    }
    GetWindowHandle("AutoShotItemWnd").ClearAnchor();
    // End:0xB8
    if(IsVertical())
    {
        GetWindowHandle("AutoShotItemWnd").SetAnchor("ShortcutWnd.ShortcutWndVertical" $ (getShortcutIndexStr()), "TopLeft", "TopRight", -1, 17);        
    }
    else
    {
        GetWindowHandle("AutoShotItemWnd").SetAnchor("ShortcutWnd.ShortcutWndHorizontal" $ (getShortcutIndexStr()), "TopLeft", "BottomLeft", 16, -1);
    }
    AutoShotItemSubWnd.HideWindow();
    return;
}

function string getShortcutIndexStr()
{
    local int nIndex;
    local string RValue;

    nIndex = ShortcutWndScript.getExpandNum();
    // End:0x2B
    if(nIndex <= 0)
    {
        RValue = "";        
    }
    else
    {
        RValue = "_" $ string(nIndex);
    }
    return RValue;
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x15
    if(getInstanceUIData().getIsArenaServer())
    {
        return;
    }
    switch(Event_ID)
    {
        // End:0x3B
        case 9750:
            bFishShotFirstInvLoad = true;
            checkSlotShowState();
            windowPositionAutoMove();
            // End:0xF3
            break;
        // End:0x51
        case 20182:
            beginSoulShotUpdateHandle(param);
            // End:0xF3
            break;
        // End:0x67
        case 20180:
            soulShotUpdateHandle(param);
            // End:0xF3
            break;
        // End:0x78
        case 9570:
            updateSoulShotSelectWindow();
            // End:0xF3
            break;
        // End:0x86
        case 40:
            Init();
            // End:0xF3
            break;
        // End:0xB0
        case 2900:
            windowPositionAutoMove();
            Me.SetTimer(30021, 5000);
            // End:0xF3
            break;
        // End:0xC1
        case 693:
            windowPositionAutoMove();
            // End:0xF3
            break;
        // End:0xC9
        case 2600:
        // End:0xDF
        case 2610:
            handleInventoryItemForFishShot(param);
            // End:0xF3
            break;
        // End:0xF0
        case 2620:
            tryFillFishShotSlot();
            // End:0xF3
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function beginSoulShotUpdateHandle(string param)
{
    local int i;

    ParamToItemInfo(param, weaponItemInfo);
    showNoticeNum = 0;
    updateSlotWeapon(weaponItemInfo);
    i = 0;
    J0x29:

    // End:0x85 [Loop If]
    if(i < 4)
    {
        slotArray[i].bNoticeShow = false;
        slotArray[i].tooltipStr = "";
        showTextureCounter(false, true, i + 1);
        showTextureCounter(false, false, i + 1);
        i++;
        // [Loop Continue]
        goto J0x29;
    }
    tryFillFishShotSlot();
    windowPositionAutoMove();
    return;
}

function handleInventoryItemForFishShot(string param)
{
    local ItemInfo evItem;

    ParamToItemInfo(param, evItem);
    // End:0xDA
    if(((evItem.Id.ClassID >= 6529) && evItem.Id.ClassID <= 6534) || (evItem.Id.ClassID >= 47557) && evItem.Id.ClassID <= 47561)
    {
        // End:0xA6
        if(evItem.bEquipped)
        {
            weaponItemInfo = evItem;
            hasWeapon = true;
            bFishShotAutoOff = false;            
        }
        else
        {
            // End:0xDA
            if(weaponItemInfo.Id.ClassID == evItem.Id.ClassID)
            {
                weaponItemInfo.Id.ClassID = 0;
            }
        }
    }
    tryFillFishShotSlot();
    return;
}

function tryFillFishShotSlot()
{
    local array<ItemInfo> infoArr;
    local ItemInfo Found, slot1Info, slot2Info;
    local int ClassID, i, rodGrade;
    local bool haveShot, slotHadFishShot, sameItem;
    local string effectPath;
    local ItemWindowHandle slotHor, slotVer;

    slotHor = getShotItemSlot(false, 1);
    slotVer = getShotItemSlot(true, 1);
    slotHadFishShot = false;
    // End:0x7A
    if((slotHor.GetItem(0, slot1Info) && slot1Info.Id.ClassID >= 6535) && slot1Info.Id.ClassID <= 6540)
    {
        slotHadFishShot = true;
    }
    ClassID = weaponItemInfo.Id.ClassID;
    // End:0xED
    if(((ClassID < 6529) || ClassID > 6534) && (ClassID < 47557) || ClassID > 47561)
    {
        // End:0xE3
        if(slotHadFishShot)
        {
            setItemSlot(1, 3);
        }
        bFishShotAutoOff = false;
        return;
    }
    rodGrade = weaponItemInfo.CrystalType;
    // End:0x125
    if((ClassID >= 47557) && ClassID <= 47561)
    {
        rodGrade = 5;
    }
    // End:0x173
    if(bFishShotFirstInvLoad)
    {
        bFishShotFirstInvLoad = false;
        // End:0x173
        if(getShotItemSlot(false, 2).GetItem(0, slot2Info) && slot2Info.Id.ClassID > 0)
        {
            setItemSlot(2, 3);
        }
    }
    haveShot = false;
    ClassID = 6535;
    J0x186:

    // End:0x29A [Loop If]
    if(ClassID <= 6540)
    {
        Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(ClassID, infoArr);
        i = 0;
        J0x1B5:

        // End:0x284 [Loop If]
        if(i < infoArr.Length)
        {
            Say((("infoArr[i].CrystalType" @ string(infoArr[i].CrystalType)) @ " weaponItemInfo.ID.ClassID ") @ string(weaponItemInfo.Id.ClassID));
            // End:0x27A
            if(__NFUN_409__(infoArr[i].ItemNum, (0)) && infoArr[i].CrystalType == rodGrade)
            {
                Found = infoArr[i];
                haveShot = true;
                // [Explicit Break]
                goto J0x284;
            }
            i++;
            // [Loop Continue]
            goto J0x1B5;
        }
        J0x284:

        // End:0x290
        if(haveShot)
        {
            // [Explicit Break]
            goto J0x29A;
        }
        ClassID++;
        // [Loop Continue]
        goto J0x186;
    }
    J0x29A:

    // End:0x2B9
    if(!haveShot)
    {
        // End:0x2B7
        if(slotHadFishShot)
        {
            setItemSlot(1, 3);
        }
        return;
    }
    Found.IsToggle = !bFishShotAutoOff;
    hasWeapon = true;
    sameItem = slotHadFishShot && slot1Info.Id.ClassID == Found.Id.ClassID;
    // End:0x361
    if(sameItem)
    {
        slotHor.SetItem(0, Found);
        slotVer.SetItem(0, Found);
        setTextureCounter(true, 1, Found.ItemNum);
        setTextureCounter(false, 1, Found.ItemNum);        
    }
    else
    {
        setItemSlot(1, 3);
        setItemSlot(1, 1, Found);
        effectPath = "AutoShotItemWnd.EffectSlot1";
        // End:0x3C0
        if(IsVertical())
        {
            effectPath = effectPath $ "_ver_AniTex";            
        }
        else
        {
            effectPath = effectPath $ "_hor_AniTex";
        }
        GetAnimTextureHandle(effectPath).Stop();
        GetAnimTextureHandle(effectPath).Play();
        // End:0x425
        if(!bFishShotAutoOff)
        {
            SoulShotSlotSelected(1, Found.Id.ClassID);
        }
    }
    GetWindowHandle(getSlotPath(IsVertical(), 1)).ShowWindow();
    return;
}

function checkSlotShowState()
{
    // End:0x27
    if(!IsUseAutoEquipSoulShot() || GetGameStateName() != "GAMINGSTATE")
    {
        return;
    }
    // End:0x56
    if(IsUseAutoEquipSoulShot())
    {
        // End:0x53
        if(!Me.IsShowWindow())
        {
            Me.ShowWindow();
        }        
    }
    else
    {
        // End:0x79
        if(Me.IsShowWindow())
        {
            Me.HideWindow();
            return;
        }
    }
    GetWindowHandle(getSlotPath(false, 1)).HideWindow();
    GetWindowHandle(getSlotPath(true, 1)).HideWindow();
    GetWindowHandle(getSlotPath(false, 3)).HideWindow();
    GetWindowHandle(getSlotPath(true, 3)).HideWindow();
    GetWindowHandle(getSlotPath(IsVertical(), 1)).ShowWindow();
    // End:0x154
    if(hasWeapon == false)
    {
        showTextureCounter(false, true, 1);
        showTextureCounter(false, true, 2);
        showTextureCounter(false, false, 1);
        showTextureCounter(false, false, 2);
        HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
    }
    // End:0x189
    if(bBeforeSummon || bBeforePet)
    {
        GetWindowHandle(getSlotPath(IsVertical(), 3)).ShowWindow();        
    }
    else
    {
        GetWindowHandle(getSlotPath(false, 3)).HideWindow();
        GetWindowHandle(getSlotPath(true, 3)).HideWindow();
        HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
    }
    return;
}

function endSoulShotUpdateHandle()
{
    local UserInfo a_UserInfo;

    // End:0x16
    if(showNoticeNum > 0)
    {
        GetPlayerInfo(a_UserInfo);
    }
    bBeforeSummon = numToBool(Class'NWindow.UIDATA_PET'.static.GetSummonNum());
    bBeforePet = Class'NWindow.UIDATA_PET'.static.IsHavePet();
    beforeWeaponInfo = weaponItemInfo;
    return;
}

function soulShotUpdateHandle(string param)
{
    local int nType, nHave, nActivate;
    local string itemCountStr, tooltipStr, gradeName;
    local int nToolTipStringMessage;
    local ItemInfo targetItemInfo, beforeTargetItemInfo;
    local bool bTwinkleEffect;
    local ItemID tempItemID;
    local string gradeString, effectPath;

    ParseInt(param, "type", nType);
    ParseInt(param, "have", nHave);
    ParseInt(param, "activate", nActivate);
    ParamToItemInfo(param, targetItemInfo);
    // End:0x92
    if((targetItemInfo.Id.ClassID >= 6535) && targetItemInfo.Id.ClassID <= 6540)
    {
        hasWeapon = true;
    }
    // End:0x107
    if((nType == 1) && targetItemInfo.Id.ClassID == 0)
    {
        // End:0x107
        if((getShotItemSlot(false, 1).GetItem(0, beforeTargetItemInfo) && beforeTargetItemInfo.Id.ClassID >= 6535) && beforeTargetItemInfo.Id.ClassID <= 6540)
        {
            return;
        }
    }
    bSummon = numToBool(Class'NWindow.UIDATA_PET'.static.GetSummonNum());
    bPet = Class'NWindow.UIDATA_PET'.static.IsHavePet();
    // End:0x801
    if(nType > -1)
    {
        bTwinkleEffect = true;
        // End:0x179
        if((nActivate == 1) || nActivate == 3)
        {
            targetItemInfo.IsToggle = true;            
        }
        else
        {
            targetItemInfo.IsToggle = false;
        }
        // End:0x1F6
        if(getShotItemSlot(false, nType).GetItem(0, beforeTargetItemInfo))
        {
            // End:0x1E6
            if(beforeTargetItemInfo.Id.ClassID == targetItemInfo.Id.ClassID)
            {
                // End:0x1E3
                if(__NFUN_409__(targetItemInfo.ItemNum, (0)))
                {
                    bTwinkleEffect = false;
                }                
            }
            else
            {
                setItemSlot(nType, 3);
            }            
        }
        else
        {
            // End:0x211
            if(__NFUN_410__(targetItemInfo.ItemNum, (0)))
            {
                bTwinkleEffect = false;
            }
        }
        // End:0x524
        if(nHave <= 0)
        {
            // End:0x3E1
            if((nType == 1) || nType == 2)
            {
                // End:0x3DE
                if(hasWeapon)
                {
                    // End:0x276
                    if(weaponItemInfo.CrystalType >= 8)
                    {
                        // End:0x268
                        if(nType == 1)
                        {
                            nToolTipStringMessage = 7388;                            
                        }
                        else
                        {
                            nToolTipStringMessage = 7389;
                        }                        
                    }
                    else
                    {
                        // End:0x28F
                        if(nType == 1)
                        {
                            nToolTipStringMessage = 7384;                            
                        }
                        else
                        {
                            nToolTipStringMessage = 7386;
                        }
                    }
                    gradeString = getInstanceL2Util().getItemGradeSystemString(weaponItemInfo.CrystalType);
                    switch(gradeString)
                    {
                        // End:0x2C9
                        case "S80":
                        // End:0x2E5
                        case "R84":
                            gradeString = GetSystemString(2617);
                            // End:0x30C
                            break;
                        // End:0x2ED
                        case "R95":
                        // End:0x309
                        case "R99":
                            gradeString = GetSystemString(2618);
                            // End:0x30C
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }
                    tooltipStr = MakeFullSystemMsg(GetSystemMessage(nToolTipStringMessage), gradeString);
                    showNoticeNum++;
                    // End:0x3AC
                    if(__NFUN_410__(beforeTargetItemInfo.ItemNum, (0)) && __NFUN_410__(targetItemInfo.ItemNum, (0)))
                    {
                        // End:0x393
                        if(beforeWeaponInfo.Id.ClassID != weaponItemInfo.Id.ClassID)
                        {
                            slotArray[nType - 1].bNoticeShow = true;                            
                        }
                        else
                        {
                            slotArray[nType - 1].bNoticeShow = false;
                        }                        
                    }
                    else
                    {
                        slotArray[nType - 1].bNoticeShow = true;
                    }
                    slotArray[nType - 1].tooltipStr = tooltipStr;                    
                }                
            }
            else
            {
                // End:0x521
                if((nType == 3) || nType == 4)
                {
                    // End:0x521
                    if(bSummon || bPet)
                    {
                        // End:0x42E
                        if(nType == 3)
                        {
                            tempItemID.ClassID = 20332;                            
                        }
                        else
                        {
                            tempItemID.ClassID = 20333;
                        }
                        gradeName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(tempItemID);
                        tooltipStr = MakeFullSystemMsg(GetSystemMessage(7385), gradeName);
                        // End:0x4E8
                        if(__NFUN_410__(beforeTargetItemInfo.ItemNum, (0)) && __NFUN_410__(targetItemInfo.ItemNum, (0)))
                        {
                            // End:0x4CF
                            if((bBeforeSummon == false) && bBeforePet == false)
                            {
                                slotArray[nType - 1].bNoticeShow = true;                                
                            }
                            else
                            {
                                slotArray[nType - 1].bNoticeShow = false;
                            }                            
                        }
                        else
                        {
                            slotArray[nType - 1].bNoticeShow = true;
                        }
                        slotArray[nType - 1].tooltipStr = tooltipStr;
                        showNoticeNum++;                        
                    }
                }
            }            
        }
        else
        {
            // End:0x647
            if((nType == 1) || nType == 2)
            {
                // End:0x63C
                if(hasWeapon)
                {
                    // End:0x639
                    if(targetItemInfo.Id.ClassID > 0)
                    {
                        // End:0x593
                        if(beforeTargetItemInfo.Id.ClassID == targetItemInfo.Id.ClassID)
                        {
                            setItemSlot(nType, 2, targetItemInfo);                            
                        }
                        else
                        {
                            setItemSlot(nType, 1, targetItemInfo);
                            effectPath = "AutoShotItemWnd.EffectSlot" $ string(nType);
                            // End:0x5F5
                            if(IsVertical())
                            {
                                effectPath = effectPath $ "_ver_AniTex";                                
                            }
                            else
                            {
                                effectPath = effectPath $ "_hor_AniTex";
                            }
                            GetAnimTextureHandle(effectPath).Stop();
                            GetAnimTextureHandle(effectPath).Play();
                        }
                    }                    
                }
                else
                {
                    bTwinkleEffect = false;
                }                
            }
            else
            {
                // End:0x790
                if((nType == 3) || nType == 4)
                {
                    // End:0x77B
                    if(bSummon || bPet)
                    {
                        // End:0x76B
                        if(targetItemInfo.Id.ClassID > 0)
                        {
                            // End:0x6C2
                            if(beforeTargetItemInfo.Id.ClassID == targetItemInfo.Id.ClassID)
                            {
                                setItemSlot(nType, 2, targetItemInfo);                                
                            }
                            else
                            {
                                setItemSlot(nType, 1, targetItemInfo);
                                effectPath = "AutoShotItemWnd.EffectSlot" $ string(nType);
                                // End:0x724
                                if(IsVertical())
                                {
                                    effectPath = effectPath $ "_ver_AniTex";                                    
                                }
                                else
                                {
                                    effectPath = effectPath $ "_hor_AniTex";
                                }
                                GetAnimTextureHandle(effectPath).Stop();
                                GetAnimTextureHandle(effectPath).Play();
                            }                            
                        }
                        else
                        {
                            setItemSlot(nType, 3);
                        }                        
                    }
                    else
                    {
                        bTwinkleEffect = false;
                        setItemSlot(nType, 3);
                    }
                }
            }
        }
        // End:0x801
        if(GetItemWindowHandle("AutoShotItemWnd.ShotItemSlot" $ string(nType)).GetItemNum() > 0)
        {
            // End:0x7EF
            if(__NFUN_409__(targetItemInfo.ItemNum, (99)))
            {
                itemCountStr = "99+";                
            }
            else
            {
                itemCountStr = (targetItemInfo.ItemNum);
            }
        }
    }
    endSoulShotUpdateHandle();
    checkSlotShowState();
    return;
}

function setItemSlot(int nType, int nItemCommand, optional ItemInfo Info)
{
    // End:0x9D
    if(nItemCommand == 1)
    {
        getShotItemSlot(false, nType).AddItem(Info);
        getShotItemSlot(true, nType).AddItem(Info);
        setTextureCounter(true, nType, Info.ItemNum);
        setTextureCounter(false, nType, Info.ItemNum);
        // End:0x9A
        if(__NFUN_410__(Info.ItemNum, (0)))
        {
            showTextureCounter(false, true, nType);
            showTextureCounter(false, false, nType);
        }        
    }
    else
    {
        // End:0x13D
        if(nItemCommand == 2)
        {
            getShotItemSlot(false, nType).SetItem(0, Info);
            getShotItemSlot(true, nType).SetItem(0, Info);
            setTextureCounter(true, nType, Info.ItemNum);
            setTextureCounter(false, nType, Info.ItemNum);
            // End:0x13A
            if(__NFUN_410__(Info.ItemNum, (0)))
            {
                showTextureCounter(false, true, nType);
                showTextureCounter(false, false, nType);
            }            
        }
        else
        {
            // End:0x18F
            if(nItemCommand == 3)
            {
                getShotItemSlot(true, nType).Clear();
                getShotItemSlot(false, nType).Clear();
                showTextureCounter(false, false, nType);
                showTextureCounter(false, true, nType);
            }
        }
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x29
    if(TimerID == 30021)
    {
        windowPositionAutoMove();
        Me.KillTimer(30021);
    }
    return;
}

function updateSlotWeapon(ItemInfo Info)
{
    weaponItemInfo = Info;
    // End:0x2B
    if(Info.Id.ClassID > 0)
    {
        hasWeapon = true;        
    }
    else
    {
        hasWeapon = false;
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo infItem, SelectItemInfo;
    local array<ItemInfo> itemInfoArray;
    local int i, wndIndex;

    // End:0x4A2
    if(Left(strID, 12) == "ShotItemSlot")
    {
        wndIndex = int(Right(strID, 1));
        // End:0xA1
        if((currentSelectSoulShotWndIndex == wndIndex) && IsShowWindow("AutoShotItemWnd.AutoShotItemSubWnd"))
        {
            currentSelectSoulShotWndIndex = -1;
            HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
            return;
        }
        currentSelectSoulShotWndIndex = wndIndex;
        // End:0x331
        if((currentSelectSoulShotWndIndex > 0) && currentSelectSoulShotWndIndex < 5)
        {
            GetAutoEquipShotList(currentSelectSoulShotWndIndex, itemInfoArray);
            ShowWindowWithFocus("AutoShotItemWnd.AutoShotItemSubWnd");
            // End:0x21B
            if(IsVertical())
            {
                GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowHor_Texture_SubWnd").HideWindow();
                GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowVer_Texture_SubWnd").ShowWindow();
                GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd").SetAnchor(((getSlotPath(IsVertical(), wndIndex)) $ ".ShotItemSlot") $ string(wndIndex), "TopRight", "TopLeft", -135, 0);                
            }
            else
            {
                GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowHor_Texture_SubWnd").ShowWindow();
                GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.ArrowVer_Texture_SubWnd").HideWindow();
                GetWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd").SetAnchor(((getSlotPath(IsVertical(), wndIndex)) $ ".ShotItemSlot") $ string(wndIndex), "TopLeft", "TopLeft", -62, -95);
            }            
        }
        else
        {
            currentSelectSoulShotWndIndex = -1;
            HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
        }
        // End:0x49F
        if(itemInfoArray.Length > 0)
        {
            // End:0x3AA
            if(getShotItemSlot(false, wndIndex).GetItemNum() > 0)
            {
                getShotItemSlot(false, wndIndex).GetItem(0, infItem);
            }
            GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd").Clear();
            i = 0;
            J0x401:

            // End:0x49F [Loop If]
            if(i < itemInfoArray.Length)
            {
                // End:0x495
                if(infItem.Id.ClassID != itemInfoArray[i].Id.ClassID)
                {
                    GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd").AddItem(itemInfoArray[i]);
                }
                i++;
                // [Loop Continue]
                goto J0x401;
            }
        }        
    }
    else
    {
        // End:0x58D
        if(strID == "AutoShotItem_ItemWnd_SubWnd")
        {
            GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd").GetItem(Index, SelectItemInfo);
            // End:0x58D
            if((SelectItemInfo.Id.ClassID > 0) && currentSelectSoulShotWndIndex != -1)
            {
                SoulShotSlotSelected(currentSelectSoulShotWndIndex, SelectItemInfo.Id.ClassID);
                HideWindow("AutoShotItemWnd.AutoShotItemSubWnd");
            }
        }
    }
    return;
}

function updateSoulShotSelectWindow()
{
    local array<ItemInfo> itemInfoArray;
    local int i;
    local ItemInfo infItem;

    // End:0x8E
    if(IsShowWindow("AutoShotItemWnd.AutoShotItemSubWnd"))
    {
        // End:0x8E
        if((currentSelectSoulShotWndIndex > 0) && currentSelectSoulShotWndIndex < 5)
        {
            GetAutoEquipShotList(currentSelectSoulShotWndIndex, itemInfoArray);
            // End:0x8E
            if(getShotItemSlot(false, currentSelectSoulShotWndIndex).GetItemNum() > 0)
            {
                getShotItemSlot(false, currentSelectSoulShotWndIndex).GetItem(0, infItem);
            }
        }
    }
    switch(currentSelectSoulShotWndIndex)
    {
        // End:0xA8
        case 1:
            GetAutoEquipShotList(1, itemInfoArray);
            // End:0xEA
            break;
        // End:0xBD
        case 2:
            GetAutoEquipShotList(2, itemInfoArray);
            // End:0xEA
            break;
        // End:0xD2
        case 3:
            GetAutoEquipShotList(3, itemInfoArray);
            // End:0xEA
            break;
        // End:0xE7
        case 4:
            GetAutoEquipShotList(4, itemInfoArray);
            // End:0xEA
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x1EB
    if(itemInfoArray.Length > 0)
    {
        GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd").Clear();
        i = 0;
        J0x14D:

        // End:0x1EB [Loop If]
        if(i < itemInfoArray.Length)
        {
            // End:0x1E1
            if(infItem.Id.ClassID != itemInfoArray[i].Id.ClassID)
            {
                GetItemWindowHandle("AutoShotItemWnd.AutoShotItemSubWnd.AutoShotItem_ItemWnd_SubWnd").AddItem(itemInfoArray[i]);
            }
            i++;
            // [Loop Continue]
            goto J0x14D;
        }
    }
    return;
}

function OnRButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
    local ItemInfo slotInfo;
    local string wndname, effectPath;

    wndname = a_WindowHandle.GetWindowName();
    // End:0x182
    if(wndname == "ShotItemSlot1")
    {
        // End:0x182
        if((getShotItemSlot(false, 1).GetItem(0, slotInfo) && slotInfo.Id.ClassID >= 6535) && slotInfo.Id.ClassID <= 6540)
        {
            bFishShotAutoOff = !bFishShotAutoOff;
            SoulShotSlotClicked(1, slotInfo.Id.ClassID);
            slotInfo.IsToggle = !bFishShotAutoOff;
            getShotItemSlot(false, 1).SetItem(0, slotInfo);
            getShotItemSlot(true, 1).SetItem(0, slotInfo);
            // End:0x180
            if(!bFishShotAutoOff)
            {
                effectPath = "AutoShotItemWnd.EffectSlot1";
                // End:0x13C
                if(IsVertical())
                {
                    effectPath = effectPath $ "_ver_AniTex";                    
                }
                else
                {
                    effectPath = effectPath $ "_hor_AniTex";
                }
                GetAnimTextureHandle(effectPath).Stop();
                GetAnimTextureHandle(effectPath).Play();
            }
            return;
        }
    }
    clickShotcutItem(a_WindowHandle, X, Y);
    return;
}

function clickShotcutItem(WindowHandle a_WindowHandle, int X, int Y)
{
    local string targetStr, targetID;
    local ItemInfo targetItemInfo;
    local int slotIdx;

    targetStr = a_WindowHandle.GetWindowName();
    targetID = Mid(targetStr, Len(targetStr) - 1, Len(targetStr));
    switch(targetID)
    {
        // End:0x40
        case "1":
        // End:0x46
        case "2":
        // End:0x4C
        case "3":
        // End:0xA0
        case "4":
            slotIdx = int(targetID);
            // End:0x9D
            if(getShotItemSlot(IsVertical(), slotIdx).GetItem(0, targetItemInfo))
            {
                SoulShotSlotClicked(slotIdx, targetItemInfo.Id.ClassID);
            }
            // End:0xA3
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ItemWindowHandle getShotItemSlot(bool IsShortcutWndVertical, int SlotIndex)
{
    local ItemWindowHandle ItemWnd;

    // End:0xE0
    if(IsShortcutWndVertical)
    {
        // End:0x79
        if(SlotIndex > 2)
        {
            ItemWnd = GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.PetSlotGroupWnd_VerWnd.ShotItemSlot" $ string(SlotIndex));            
        }
        else
        {
            ItemWnd = GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_VerWnd.WeaponSlotGroupWnd_VerWnd.ShotItemSlot" $ string(SlotIndex));
        }        
    }
    else
    {
        // End:0x150
        if(SlotIndex > 2)
        {
            ItemWnd = GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.PetSlotGroupWnd_HorWnd.ShotItemSlot" $ string(SlotIndex));            
        }
        else
        {
            ItemWnd = GetItemWindowHandle("AutoShotItemWnd.AutoShotItemWnd_HorWnd.WeaponSlotGroupWnd_HorWnd.ShotItemSlot" $ string(SlotIndex));
        }
    }
    return ItemWnd;
    return;
}

function setTextureCounter(bool IsShortcutWndVertical, int SlotIndex, INT64 Count)
{
    local string tempStr, valueStr;

    // End:0x1D
    if(__NFUN_409__(Count, (99)))
    {
        valueStr = "99+";        
    }
    else
    {
        valueStr = (Count);
    }
    showTextureCounter(false, IsShortcutWndVertical, SlotIndex);
    tempStr = getSlotPath(IsShortcutWndVertical, SlotIndex);
    switch(Len(valueStr))
    {
        // End:0x1B7
        case 3:
            showTextureCounter(true, IsShortcutWndVertical, SlotIndex);
            GetTextureHandle((((tempStr $ ".") $ "counter100_slot") $ string(SlotIndex)) $ "_texture").SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_9");
            GetTextureHandle((((tempStr $ ".") $ "counter10_slot") $ string(SlotIndex)) $ "_texture").SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_9");
            GetTextureHandle((((tempStr $ ".") $ "counter1_slot") $ string(SlotIndex)) $ "_texture").SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_Plus");
            // End:0x329
            break;
        // End:0x270
        case 2:
            GetTextureHandle((((tempStr $ ".") $ "counter10_slot") $ string(SlotIndex)) $ "_texture").ShowWindow();
            GetTextureHandle((((tempStr $ ".") $ "counter10_slot") $ string(SlotIndex)) $ "_texture").SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_" $ Left(valueStr, 1));
        // End:0x326
        case 1:
            GetTextureHandle((((tempStr $ ".") $ "counter1_slot") $ string(SlotIndex)) $ "_texture").ShowWindow();
            GetTextureHandle((((tempStr $ ".") $ "counter1_slot") $ string(SlotIndex)) $ "_texture").SetTexture("l2UI_CT1.AutoShotItemWnd.ItemCountNum_" $ Right(valueStr, 1));
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function showTextureCounter(bool bShow, bool IsShortcutWndVertical, int SlotIndex)
{
    local string tempStr;

    tempStr = getSlotPath(IsShortcutWndVertical, SlotIndex);
    // End:0xE6
    if(bShow)
    {
        GetTextureHandle((((tempStr $ ".") $ "counter1_slot") $ string(SlotIndex)) $ "_texture").ShowWindow();
        GetTextureHandle((((tempStr $ ".") $ "counter10_slot") $ string(SlotIndex)) $ "_texture").ShowWindow();
        GetTextureHandle((((tempStr $ ".") $ "counter100_slot") $ string(SlotIndex)) $ "_texture").ShowWindow();        
    }
    else
    {
        GetTextureHandle((((tempStr $ ".") $ "counter1_slot") $ string(SlotIndex)) $ "_texture").HideWindow();
        GetTextureHandle((((tempStr $ ".") $ "counter10_slot") $ string(SlotIndex)) $ "_texture").HideWindow();
        GetTextureHandle((((tempStr $ ".") $ "counter100_slot") $ string(SlotIndex)) $ "_texture").HideWindow();
    }
    return;
}

function string getSlotPath(bool IsShortcutWndVertical, int SlotIndex)
{
    local string tempStr;

    tempStr = "AutoShotItemWnd";
    // End:0xA7
    if(IsShortcutWndVertical)
    {
        tempStr = tempStr $ ".AutoShotItemWnd_VerWnd";
        // End:0x7B
        if(SlotIndex > 2)
        {
            tempStr = tempStr $ ".PetSlotGroupWnd_VerWnd";            
        }
        else
        {
            tempStr = tempStr $ ".WeaponSlotGroupWnd_VerWnd";
        }        
    }
    else
    {
        tempStr = tempStr $ ".AutoShotItemWnd_HorWnd";
        // End:0x102
        if(SlotIndex > 2)
        {
            tempStr = tempStr $ ".PetSlotGroupWnd_HorWnd";            
        }
        else
        {
            tempStr = tempStr $ ".WeaponSlotGroupWnd_HorWnd";
        }
    }
    return tempStr;
    return;
}

function bool IsVertical()
{
    return ShortcutWndScript.IsVertical();
    return;
}
