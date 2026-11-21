class UICommonAPI extends UIConstants;

const GMCOMMAND_ClanWarehouseInfo = 7;
const DialogType_Item = 8;
const EV_USER_CharacterSelectionChanged = 50000;
const EV_NextTarget = 3520;
const NEXT_TARGET_SERVER_COMMAND = "mybirthday";
const EV_CombatModeON = 5420;
const EV_CombatModeOFF = 5430;
const EV_OPTION_CHANGE = 1060;
const CLASS_MAX = 119;

enum eLeaderControlType
{
    LCT_NOAFFECT,                   // 0
    LCT_ACCEPTED,                   // 1
    LCT_DECLINED                    // 2
};

enum _FileHandler
{
    FH_NONE,                        // 0
    FH_PLEDGE_CREST_UPLOAD,         // 1
    FH_PLEDGE_EMBLEM_UPLOAD,        // 2
    FH_ALLIANCE_CREST_UPLOAD,       // 3
    FH_WEBBROWSER_FILE_UPLOAD,      // 4
    FH_MAX                          // 5
};

struct sCastleName
{
    var int Id;
    var string Name;
    var int region_id;
    var Vector loc;
};

var int nDebugVal;

function FileRegisterWndShow(UICommonAPI._FileHandler filehandlertype)
{
    local FileRegisterWnd script;

    script = FileRegisterWnd(GetScript("FileRegisterWnd"));
    script.ShowFileRegisterWnd(filehandlertype);
    return;
}

function AddFileRegisterWndFileExt(string Str, array<string> strArray)
{
    local FileRegisterWnd script;

    script = FileRegisterWnd(GetScript("FileRegisterWnd"));
    script.AddFileExt(Str, strArray);
    return;
}

function ClearFileRegisterWndFileExt()
{
    local FileRegisterWnd script;

    script = FileRegisterWnd(GetScript("FileRegisterWnd"));
    script.ClearFileExt();
    return;
}

function FileRegisterWndHide()
{
    local FileRegisterWnd script;

    script = FileRegisterWnd(GetScript("FileRegisterWnd"));
    script.HideFileRegisterWnd();
    return;
}

static function DialogShow(UIScript.EDialogModalType modalType, UIScript.EDialogType dialogType, string strMessage, string strControlName, optional int dialogWeight, optional int dialogHeight, optional bool bUseHtml, optional string customIconTexture)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.ShowDialog(modalType, dialogType, strMessage, strControlName, dialogWeight, dialogHeight, bUseHtml);
    // End:0x6F
    if(customIconTexture != "")
    {
        script.setIconTexture(customIconTexture);
    }
    return;
}

static function DialogSetCancelD(int targetCancelDialogID)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.setDialogCancelD(targetCancelDialogID);
    return;
}

static function DialogSetButtonName(int indexOK, optional int indexCancel)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetButtonName(indexOK, indexCancel);
    return;
}

static function DialogSetButtonWidthSize(int indexOK, optional int indexCancel)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetButtonWidthSize(indexOK, indexCancel);
    return;
}

static function DialogShowWithResize(UIScript.EDialogModalType modalType, UIScript.EDialogType dialogType, string strMessage, int changeWidth, int changeHeight, string strControlName)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.ShowDialog(modalType, dialogType, strMessage, strControlName, changeWidth, changeHeight);
    return;
}

static function DialogHide()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.HideDialog();
    return;
}

static function DialogSetDefaultOK()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetDefaultAction(1);
    return;
}

static function DialogSetDefaultCancle()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetDefaultAction(2);
    return;
}

static function DialogSetEnterDoNothing()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetEnterAction(3);
    return;
}

static function DialogSetEnterOK()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetEnterAction(1);
    return;
}

static function DialogSetEnterCancle()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetEnterAction(2);
    return;
}

function bool DialogIsMine()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    // End:0x35
    if(script.GetTarget() == string(self))
    {
        return true;
    }
    return false;
    return;
}

function bool DialogHasPreviousCancelProcess()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    return script.hasPreviousCancelProcess();
    return;
}

function bool DialogCheckCancelByID(int targetDialogID)
{
    local DialogBox script;

    script = DialogBox(GetScript("dialogbox"));
    return script.checkCancelDialogID(targetDialogID);
    return;
}

static function bool DialogIsOwnedBy(string Owner)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    // End:0x37
    if(script.GetTarget() == Owner)
    {
        return true;
    }
    return false;
    return;
}

static function DialogSetID(int Id)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.setId(Id);
    return;
}

static function DialogSetEditType(string strType)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetEditType(strType);
    return;
}

static function string DialogGetString()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    return script.GetEditMessage();
    return;
}

static function DialogSetString(string strInput)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetEditMessage(strInput);
    return;
}

static function int DialogGetID()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    return script.GetID();
    return;
}

static function DialogSetStr(string Value)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetReservedStr(Value);
    return;
}

static function string DialogGetStr()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    return script.GetReservedStr();
    return;
}

static function DialogSetParamInt64(INT64 param)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.setParamInt64(param);
    return;
}

static function DialogSetReservedInt(int Value)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetReservedInt(Value);
    return;
}

static function DialogSetReservedInt2(INT64 Value)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetReservedInt2(Value);
    return;
}

static function DialogSetReservedInt3(int Value)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetReservedInt3(Value);
    return;
}

static function DialogSetReservedItemID(ItemID Id)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetReservedItemID(Id);
    return;
}

static function DialogSetReservedItemInfo(ItemInfo Info)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetReservedItemInfo(Info);
    return;
}

static function int DialogGetReservedInt()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    return script.GetReservedInt();
    return;
}

static function INT64 DialogGetReservedInt2()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    return script.GetReservedInt2();
    return;
}

static function int DialogGetReservedInt3()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    return script.GetReservedInt3();
    return;
}

static function ItemID DialogGetReservedItemID()
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    return script.GetReservedItemID();
    return;
}

static function DialogGetReservedItemInfo(out ItemInfo Info)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.GetReservedItemInfo(Info);
    return;
}

static function DialogSetEditBoxMaxLength(int maxLength)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.SetEditBoxMaxLength(maxLength);
    return;
}

static function DialogSetIconTexture(string iconTextureStr)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.setIconTexture(iconTextureStr);
    return;
}

static function DialogSetIconCustomToolTip(CustomTooltip TooltipInfo)
{
    local DialogBox script;

    script = DialogBox(GetScript("DialogBox"));
    script.setIconCustomToolTip(TooltipInfo);
    return;
}

static function int Split(string strInput, string delim, out array<string> arrToken)
{
    local int arrSize;

    J0x00:
    // End:0x6F [Loop If]
    if(InStr(strInput, delim) > 0)
    {
        arrToken.Insert(arrToken.Length, 1);
        arrToken[arrToken.Length - 1] = Left(strInput, InStr(strInput, delim));
        strInput = Mid(strInput, InStr(strInput, delim) + 1);
        arrSize = arrSize + 1;
        // [Loop Continue]
        goto J0x00;
    }
    arrToken.Insert(arrToken.Length, 1);
    arrToken[arrToken.Length - 1] = strInput;
    arrSize = arrSize + 1;
    return arrSize;
    return;
}

function ShowWindow(string a_ControlID)
{
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(a_ControlID);
    return;
}

function toggleWindow(string a_ControlID, optional bool bFocus, optional bool bUseOpenCloseSound)
{
    // End:0x3F
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(a_ControlID))
    {
        // End:0x28
        if(bUseOpenCloseSound)
        {
            PlayConsoleSound(6);
        }
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(a_ControlID);        
    }
    else
    {
        // End:0x50
        if(bUseOpenCloseSound)
        {
            PlayConsoleSound(6);
        }
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(a_ControlID);
        // End:0x81
        if(bFocus)
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetFocus(a_ControlID);
        }
    }
    return;
}

function ShowWindowWithFocus(string a_ControlID)
{
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(a_ControlID);
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus(a_ControlID);
    return;
}

static function string reverseString(coerce string Str)
{
    local string reverseStr;
    local int i;

    i = Len(Str) - 1;
    J0x10:

    // End:0x3F [Loop If]
    if(i >= 0)
    {
        reverseStr = reverseStr $ Mid(Str, i, 1);
        --i;
        // [Loop Continue]
        goto J0x10;
    }
    return reverseStr;
    return;
}

static function string trim(string S)
{
    local int i;

    // End:0x13
    if(Len(S) == 0)
    {
        return S;
    }
    i = 0;
    J0x1A:

    // End:0x50 [Loop If]
    if((Mid(S, i, 1) == " ") || Mid(S, i, 1) == "t")
    {
        ++i;
        // [Loop Continue]
        goto J0x1A;
    }
    S = Right(S, Len(S) - i);
    // End:0x7E
    if(Len(S) == 0)
    {
        return S;
    }
    i = Len(S) - 1;
    J0x8E:

    // End:0xC4 [Loop If]
    if((Mid(S, i, 1) == " ") || Mid(S, i, 1) == "t")
    {
        --i;
        // [Loop Continue]
        goto J0x8E;
    }
    S = Left(S, i + 1);
    return S;
    return;
}

static function string deleteEnter(string S)
{
    local int i;

    // End:0x13
    if(Len(S) == 0)
    {
        return S;
    }
    i = 0;
    J0x1A:

    // End:0x52 [Loop If]
    if((Mid(S, i, 1) == Chr(13)) || Mid(S, i, 1) == Chr(10))
    {
        ++i;
        // [Loop Continue]
        goto J0x1A;
    }
    S = Right(S, Len(S) - i);
    // End:0x80
    if(Len(S) == 0)
    {
        return S;
    }
    i = Len(S) - 1;
    J0x90:

    // End:0xC8 [Loop If]
    if((Mid(S, i, 1) == Chr(13)) || Mid(S, i, 1) == Chr(10))
    {
        --i;
        // [Loop Continue]
        goto J0x90;
    }
    S = Left(S, i + 1);
    return S;
    return;
}

static function int InStrFromBack(string S, string t)
{
    local string reverseStr;
    local int i;

    reverseStr = reverseString(S);
    i = InStr(reverseStr, t);
    // End:0x43
    if(i >= 0)
    {
        return (Len(S) - 1) - i;        
    }
    else
    {
        return i;
    }
    return;
}

function HideWindow(string a_ControlID)
{
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(a_ControlID);
    return;
}

function bool IsShowWindow(string a_ControlID)
{
    return Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(a_ControlID);
    return;
}

function ParamToItemInfo(string param, out ItemInfo Info)
{
    local int tmpInt, i, N, Cnt;

    ParseItemID(param, Info.Id);
    ParseInt(param, "level", Info.Level);
    ParseString(param, "name", Info.Name);
    ParseString(param, "additionalName", Info.AdditionalName);
    ParseString(param, "iconName", Info.IconName);
    ParseString(param, "iconPanel", Info.IconPanel);
    ParseString(param, "description", Info.Description);
    ParseInt(param, "itemType", Info.ItemType);
    ParseINT64(param, "itemNum", Info.ItemNum);
    ParseINT64(param, "slotBitType", Info.SlotBitType);
    ParseInt(param, "enchanted", Info.Enchanted);
    ParseInt(param, "blessed", Info.Blessed);
    ParseInt(param, "damaged", Info.Damaged);
    // End:0x1BD
    if(ParseInt(param, "equipped", tmpInt))
    {
        Info.bEquipped = bool(tmpInt);
    }
    ParseINT64(param, "price", Info.Price);
    ParseInt(param, "reserved", Info.Reserved);
    ParseINT64(param, "reserved64", Info.Reserved64);
    ParseINT64(param, "defaultPrice", Info.DefaultPrice);
    ParseInt(param, "refineryOp1", Info.RefineryOp1);
    ParseInt(param, "refineryOp2", Info.RefineryOp2);
    ParseInt(param, "currentDurability", Info.CurrentDurability);
    ParseInt(param, "CurrentPeriod", Info.CurrentPeriod);
    ParseInt(param, "disabled", Info.bDisabled);
    ParseInt(param, "enchantOption1", Info.EnchantOption1);
    ParseInt(param, "enchantOption2", Info.EnchantOption2);
    ParseInt(param, "enchantOption3", Info.EnchantOption3);
    ParseInt(param, "weight", Info.Weight);
    ParseInt(param, "materialType", Info.MaterialType);
    ParseInt(param, "weaponType", Info.WeaponType);
    ParseFloat(param, "pDefense", Info.pDefense);
    ParseFloat(param, "mDefense", Info.mDefense);
    ParseFloat(param, "pAttack", Info.pAttack);
    ParseFloat(param, "mAttack", Info.mAttack);
    ParseFloat(param, "pAttackSpeed", Info.pAttackSpeed);
    ParseFloat(param, "mAttackSpeed", Info.mAttackSpeed);
    ParseFloat(param, "pHitRate", Info.pHitRate);
    ParseFloat(param, "mHitRate", Info.mHitRate);
    ParseFloat(param, "pCriRate", Info.pCriRate);
    ParseFloat(param, "mCriRate", Info.mCriRate);
    ParseFloat(param, "MoveSpeed", Info.MoveSpeed);
    ParseFloat(param, "ShieldDefense", Info.ShieldDefense);
    ParseFloat(param, "ShieldDefenseRate", Info.ShieldDefenseRate);
    ParseFloat(param, "pAvoid", Info.pAvoid);
    ParseFloat(param, "mAvoid", Info.mAvoid);
    ParseInt(param, "enchant_bonus", Info.enchant_bonus);
    ParseINT64(param, "n64DefaultPriceFromScript", Info.n64DefaultPriceFromScript);
    ParseInt(param, "durability", Info.Durability);
    ParseInt(param, "crystalType", Info.CrystalType);
    ParseInt(param, "randomDamage", Info.RandomDamage);
    ParseInt(param, "mpConsume", Info.MpConsume);
    ParseInt(param, "soulshotCount", Info.SoulshotCount);
    ParseInt(param, "spiritshotCount", Info.SpiritshotCount);
    ParseInt(param, "armorType", Info.ArmorType);
    ParseInt(param, "mpBonus", Info.MpBonus);
    ParseInt(param, "bodyPart", Info.BodyPart);
    ParseInt(param, "consumeType", Info.ConsumeType);
    ParseInt(param, "ItemSubType", Info.ItemSubType);
    ParseString(param, "iconNameEx1", Info.IconNameEx1);
    ParseString(param, "iconNameEx2", Info.IconNameEx2);
    ParseString(param, "iconNameEx3", Info.IconNameEx3);
    ParseString(param, "iconNameEx4", Info.IconNameEx4);
    // End:0x817
    if(ParseInt(param, "arrow", tmpInt))
    {
        Info.bArrow = bool(tmpInt);
    }
    // End:0x845
    if(ParseInt(param, "recipe", tmpInt))
    {
        Info.bRecipe = bool(tmpInt);
    }
    ParseInt(param, "AttackAttributeType", Info.AttackAttributeType);
    ParseInt(param, "AttackAttributeValue", Info.AttackAttributeValue);
    ParseInt(param, "DefenseAttributeValueFire", Info.DefenseAttributeValueFire);
    ParseInt(param, "DefenseAttributeValueWater", Info.DefenseAttributeValueWater);
    ParseInt(param, "DefenseAttributeValueWind", Info.DefenseAttributeValueWind);
    ParseInt(param, "DefenseAttributeValueEarth", Info.DefenseAttributeValueEarth);
    ParseInt(param, "DefenseAttributeValueHoly", Info.DefenseAttributeValueHoly);
    ParseInt(param, "DefenseAttributeValueUnholy", Info.DefenseAttributeValueUnholy);
    tmpInt = 0;
    ParseInt(param, "RelatedQuestCnt", tmpInt);
    // End:0xA45
    if(tmpInt > 0)
    {
        i = 0;
        J0x9F8:

        // End:0xA45 [Loop If]
        if(i < tmpInt)
        {
            ParseInt(param, "RelatedQuestID" $ string(i), Info.RelatedQuestID[i]);
            ++i;
            // [Loop Continue]
            goto J0x9F8;
        }
    }
    ParseInt(param, "attribution", Info.Attribution);
    ParseInt(param, "propertyparams", Info.PropertyParams);
    ParseInt(param, "IsBRPremium", Info.IsBRPremium);
    ParseInt(param, "BR_CurrentEnergy", Info.BR_CurrentEnergy);
    ParseInt(param, "BR_MaxEnergy", Info.BR_MaxEnergy);
    ParseInt(param, "LookChangeIconID", Info.LookChangeIconID);
    ParseInt(param, "LookChangeItemID", Info.LookChangeItemID);
    ParseString(param, "LookChangeItemName", Info.LookChangeItemName);
    ParseString(param, "LookChangeIconPanel", Info.LookChangeIconPanel);
    Info.LookChangeIconPanel = EnchantOrCountIcon(Info);
    ParseInt(param, "Order", Info.ORDER);
    ParseInt(param, "PopMsgNum", Info.PopMsgNum);
    ParseString(param, "tooltipTexutre", Info.tooltipTexutre);
    i = 1;
    J0xC17:

    // End:0xCF9 [Loop If]
    if(i < 3)
    {
        ParseInt(param, "EnsoulOptionNum_" $ string(i), Cnt);
        Info.EnsoulOption[i - 1].OptionArray.Length = Cnt;
        N = 1;
        J0xC74:

        // End:0xCEF [Loop If]
        if(N < (1 + Cnt))
        {
            ParseInt(param, (("EnsoulOptionID_" $ string(i)) $ "_") $ string(N), tmpInt);
            Info.EnsoulOption[i - 1].OptionArray[N - 1] = tmpInt;
            N++;
            // [Loop Continue]
            goto J0xC74;
        }
        i++;
        // [Loop Continue]
        goto J0xC17;
    }
    ParseString(param, "MacroCommand", Info.MacroCommand);
    // End:0xD50
    if(ParseInt(param, "SecurityLock", tmpInt))
    {
        Info.bSecurityLock = bool(tmpInt);
    }
    // End:0xD88
    if(ParseInt(param, "SecurityLockable", tmpInt))
    {
        Info.bSecurityLockable = bool(tmpInt);
    }
    ParseInt(param, "CurUseCount", Info.CurUseCount);
    ParseInt(param, "MaxUseCount", Info.MaxUseCount);
    ParseFloat(param, "MaxReuseDelay", Info.MaxReuseDelay);
    ParseFloat(param, "RemainReuseDelay", Info.RemainReuseDelay);
    ParseFloat(param, "ReceivedAppSec", Info.ReceivedAppSec);
    return;
}

function ItemInfoToParam(ItemInfo Info, out string param)
{
    local int i;

    ParamAdd(param, "ClassID", string(Info.Id.ClassID));
    ParamAdd(param, "ServerID", string(Info.Id.ServerID));
    ParamAdd(param, "level", string(Info.Level));
    ParamAdd(param, "name", Info.Name);
    ParamAdd(param, "additionalName", Info.AdditionalName);
    ParamAdd(param, "iconName", Info.IconName);
    ParamAdd(param, "iconPanel", Info.IconPanel);
    ParamAdd(param, "description", Info.Description);
    ParamAdd(param, "itemType", string(Info.ItemType));
    ParamAddINT64(param, "itemNum", Info.ItemNum);
    ParamAddINT64(param, "slotBitType", Info.SlotBitType);
    ParamAdd(param, "enchanted", string(Info.Enchanted));
    ParamAdd(param, "blessed", string(Info.Blessed));
    ParamAdd(param, "damaged", string(Info.Damaged));
    ParamAdd(param, "equipped", string(Info.bEquipped));
    ParamAddINT64(param, "price", Info.Price);
    ParamAdd(param, "reserved", string(Info.Reserved));
    ParamAddINT64(param, "reserved64", Info.Reserved64);
    ParamAddINT64(param, "defaultPrice", Info.DefaultPrice);
    ParamAdd(param, "refineryOp1", string(Info.RefineryOp1));
    ParamAdd(param, "refineryOp2", string(Info.RefineryOp2));
    ParamAdd(param, "currentDurability", string(Info.CurrentDurability));
    ParamAdd(param, "CurrentPeriod", string(Info.CurrentPeriod));
    ParamAdd(param, "disabled", string(Info.bDisabled));
    ParamAdd(param, "enchantOption1", string(Info.EnchantOption1));
    ParamAdd(param, "enchantOption2", string(Info.EnchantOption2));
    ParamAdd(param, "enchantOption3", string(Info.EnchantOption3));
    ParamAdd(param, "weight", string(Info.Weight));
    ParamAdd(param, "materialType", string(Info.MaterialType));
    ParamAdd(param, "weaponType", string(Info.WeaponType));
    ParamAdd(param, "pDefense", string(Info.pDefense));
    ParamAdd(param, "mDefense", string(Info.mDefense));
    ParamAdd(param, "pAttack", string(Info.pAttack));
    ParamAdd(param, "mAttack", string(Info.mAttack));
    ParamAdd(param, "pAttackSpeed", string(Info.pAttackSpeed));
    ParamAdd(param, "mAttackSpeed", string(Info.mAttackSpeed));
    ParamAdd(param, "pHitRate", string(Info.pHitRate));
    ParamAdd(param, "mHitRate", string(Info.mHitRate));
    ParamAdd(param, "pCriRate", string(Info.pCriRate));
    ParamAdd(param, "mCriRate", string(Info.mCriRate));
    ParamAdd(param, "MoveSpeed", string(Info.MoveSpeed));
    ParamAdd(param, "ShieldDefense", string(Info.ShieldDefense));
    ParamAdd(param, "ShieldDefenseRate", string(Info.ShieldDefenseRate));
    ParamAdd(param, "pAvoid", string(Info.pAvoid));
    ParamAdd(param, "mAvoid", string(Info.mAvoid));
    ParamAdd(param, "enchant_bonus", string(Info.enchant_bonus));
    ParamAddINT64(param, "n64DefaultPriceFromScript", Info.n64DefaultPriceFromScript);
    ParamAdd(param, "durability", string(Info.Durability));
    ParamAdd(param, "crystalType", string(Info.CrystalType));
    ParamAdd(param, "randomDamage", string(Info.RandomDamage));
    ParamAdd(param, "mpConsume", string(Info.MpConsume));
    ParamAdd(param, "soulshotCount", string(Info.SoulshotCount));
    ParamAdd(param, "spiritshotCount", string(Info.SpiritshotCount));
    ParamAdd(param, "armorType", string(Info.ArmorType));
    ParamAdd(param, "mpBonus", string(Info.MpBonus));
    ParamAdd(param, "bodyPart", string(Info.BodyPart));
    ParamAdd(param, "consumeType", string(Info.ConsumeType));
    ParamAdd(param, "ItemSubType", string(Info.ItemSubType));
    ParamAdd(param, "iconNameEx1", Info.IconNameEx1);
    ParamAdd(param, "iconNameEx2", Info.IconNameEx2);
    ParamAdd(param, "iconNameEx3", Info.IconNameEx3);
    ParamAdd(param, "iconNameEx4", Info.IconNameEx4);
    ParamAdd(param, "arrow", string(Info.bArrow));
    ParamAdd(param, "recipe", string(Info.bRecipe));
    ParamAdd(param, "AttackAttributeType", string(Info.AttackAttributeType));
    ParamAdd(param, "AttackAttributeValue", string(Info.AttackAttributeValue));
    ParamAdd(param, "DefenseAttributeValueFire", string(Info.DefenseAttributeValueFire));
    ParamAdd(param, "DefenseAttributeValueWater", string(Info.DefenseAttributeValueWater));
    ParamAdd(param, "DefenseAttributeValueWind", string(Info.DefenseAttributeValueWind));
    ParamAdd(param, "DefenseAttributeValueEarth", string(Info.DefenseAttributeValueEarth));
    ParamAdd(param, "DefenseAttributeValueHoly", string(Info.DefenseAttributeValueHoly));
    ParamAdd(param, "DefenseAttributeValueUnholy", string(Info.DefenseAttributeValueUnholy));
    ParamAdd(param, "RelatedQuestCnt", string(10));
    i = 0;
    J0xA59:

    // End:0xAA5 [Loop If]
    if(i < 10)
    {
        ParamAdd(param, "RelatedQuestID" $ string(i), string(Info.RelatedQuestID[i]));
        ++i;
        // [Loop Continue]
        goto J0xA59;
    }
    ParamAdd(param, "attribution", string(Info.Attribution));
    ParamAdd(param, "propertyparams", string(Info.PropertyParams));
    ParamAdd(param, "IsBRPremium", string(Info.IsBRPremium));
    ParamAdd(param, "BR_CurrentEnergy", string(Info.BR_CurrentEnergy));
    ParamAdd(param, "BR_MaxEnergy", string(Info.BR_MaxEnergy));
    ParamAdd(param, "LookChangeIconID", string(Info.LookChangeIconID));
    ParamAdd(param, "LookChangeItemID", string(Info.LookChangeItemID));
    ParamAdd(param, "LookChangeItemName", Info.LookChangeItemName);
    ParamAdd(param, "LookChangeIconPanel", Info.LookChangeIconPanel);
    ParamAdd(param, "Order", string(Info.ORDER));
    ParamAdd(param, "PopMsgNum", string(Info.PopMsgNum));
    ParamAdd(param, "tooltipTexutre", Info.tooltipTexutre);
    addParamEnsoulOptionInfo(Info, param);
    ParamAdd(param, "MacroCommand", Info.MacroCommand);
    ParamAdd(param, "SecurityLockable", string(Info.bSecurityLockable));
    ParamAdd(param, "SecurityLock", string(Info.bSecurityLock));
    ParamAdd(param, "CurUseCount", string(Info.CurUseCount));
    ParamAdd(param, "MaxUseCount", string(Info.MaxUseCount));
    ParamAdd(param, "MaxReuseDelay", string(Info.MaxReuseDelay));
    ParamAdd(param, "RemainReuseDelay", string(Info.RemainReuseDelay));
    ParamAdd(param, "ReceivedAppSec", string(Info.ReceivedAppSec));
    return;
}

function ParamToRecord(string param, out LVDataRecord Record)
{
    local int idx, MaxColumn;

    ParseString(param, "szReserved", Record.szReserved);
    ParseINT64(param, "nReserved1", Record.nReserved1);
    ParseINT64(param, "nReserved2", Record.nReserved2);
    ParseINT64(param, "nReserved3", Record.nReserved3);
    ParseInt(param, "MaxColumn", MaxColumn);
    Record.LVDataList.Length = MaxColumn;
    idx = 0;
    J0xB7:

    // End:0x1DA [Loop If]
    if(idx < MaxColumn)
    {
        ParseString(param, "szData_" $ string(idx), Record.LVDataList[idx].szData);
        ParseString(param, "szReserved_" $ string(idx), Record.LVDataList[idx].szReserved);
        ParseInt(param, "nReserved1_" $ string(idx), Record.LVDataList[idx].nReserved1);
        ParseInt(param, "nReserved2_" $ string(idx), Record.LVDataList[idx].nReserved2);
        ParseInt(param, "nReserved3_" $ string(idx), Record.LVDataList[idx].nReserved3);
        idx++;
        // [Loop Continue]
        goto J0xB7;
    }
    return;
}

function CustomTooltip MakeTooltipSimpleText(string Text, optional int toolTipWidth)
{
    local CustomTooltip ToolTip;
    local DrawItemInfo Info;
    local bool oneline;

    oneline = true;
    // End:0x1B
    if(toolTipWidth > 0)
    {
        oneline = false;
    }
    ToolTip.DrawList.Length = 1;
    ToolTip.MinimumWidth = toolTipWidth;
    Info.eType = 1;
    Info.t_bDrawOneLine = oneline;
    Info.t_strText = Text;
    ToolTip.DrawList[0] = Info;
    return ToolTip;
    return;
}

function CustomTooltip MakeTooltipSimpleColorText(string Text, Color TextColor, optional string FontName, optional int toolTipWidth)
{
    local CustomTooltip ToolTip;
    local bool oneline;

    oneline = true;
    // End:0x1B
    if(toolTipWidth > 0)
    {
        oneline = false;
    }
    ToolTip.MinimumWidth = toolTipWidth;
    ToolTip.DrawList[0] = addDrawItemText(Text, TextColor, FontName, oneline);
    return ToolTip;
    return;
}

function CustomTooltip MakeTooltipMultiText(string line1text, Color text1Color, optional string font1Name, optional bool bLine1Break, optional string line2text, optional Color text2Color, optional string font2Name, optional bool bLine2Break, optional string line3text, optional Color text3Color, optional string font3Name, optional bool bLine3Break, optional int toolTipWidth)
{
    local CustomTooltip ToolTip;
    local int countLength, textWidth, textHeight, maxTextWidth;

    countLength = 0;
    // End:0x26
    if(font1Name == "")
    {
        font1Name = "GameDefault";
    }
    // End:0x45
    if(font2Name == "")
    {
        font2Name = "GameDefault";
    }
    // End:0x64
    if(font3Name == "")
    {
        font3Name = "GameDefault";
    }
    // End:0xAB
    if(line1text != "")
    {
        countLength++;
        GetTextSize(line1text, font1Name, textWidth, textHeight);
        // End:0xAB
        if(textWidth > maxTextWidth)
        {
            maxTextWidth = textWidth;
        }
    }
    // End:0xF2
    if(line2text != "")
    {
        countLength++;
        GetTextSize(line2text, font2Name, textWidth, textHeight);
        // End:0xF2
        if(textWidth > maxTextWidth)
        {
            maxTextWidth = textWidth;
        }
    }
    // End:0x139
    if(line3text != "")
    {
        countLength++;
        GetTextSize(line3text, font3Name, textWidth, textHeight);
        // End:0x139
        if(textWidth > maxTextWidth)
        {
            maxTextWidth = textWidth;
        }
    }
    ToolTip.DrawList.Length = countLength;
    // End:0x168
    if(toolTipWidth > 0)
    {
        ToolTip.MinimumWidth = toolTipWidth;        
    }
    else
    {
        ToolTip.MinimumWidth = maxTextWidth + 1;
    }
    // End:0x1AF
    if(line1text != "")
    {
        ToolTip.DrawList[0] = addDrawItemText(line1text, text1Color, font1Name, bLine1Break);
    }
    // End:0x1E3
    if(line2text != "")
    {
        ToolTip.DrawList[1] = addDrawItemText(line2text, text2Color, font2Name, bLine2Break);
    }
    // End:0x218
    if(line3text != "")
    {
        ToolTip.DrawList[2] = addDrawItemText(line3text, text3Color, font3Name, bLine3Break);
    }
    return ToolTip;
    return;
}

function DrawItemInfo addDrawItemText(string Text, Color TextColor, optional string FontName, optional bool bLineBreak, optional bool oneline, optional int OffsetX, optional int OffsetY)
{
    local DrawItemInfo Info;

    Info.eType = 1;
    Info.t_color.R = TextColor.R;
    Info.t_color.G = TextColor.G;
    Info.t_color.B = TextColor.B;
    Info.t_color.A = TextColor.A;
    Info.t_strText = Text;
    Info.t_bDrawOneLine = oneline;
    Info.bLineBreak = bLineBreak;
    Info.nOffSetX = OffsetX;
    Info.nOffSetY = OffsetY;
    return Info;
    return;
}

function DrawItemInfo addDrawItemTexture(string Texture, optional bool oneline, optional bool bLineBreak, optional int OffsetX, optional int OffsetY)
{
    local DrawItemInfo Info;

    Info.eType = 2;
    Info.t_bDrawOneLine = oneline;
    Info.bLineBreak = bLineBreak;
    Info.u_nTextureWidth = 16;
    Info.u_nTextureHeight = 16;
    Info.nOffSetX = OffsetX;
    Info.nOffSetY = OffsetY;
    Info.u_nTextureUWidth = 32;
    Info.u_nTextureUHeight = 32;
    Info.u_strTexture = Texture;
    return Info;
    return;
}

function DrawItemInfo addDrawItemBlank(int Height)
{
    local DrawItemInfo Info;

    Info.eType = 0;
    Info.b_nHeight = Height;
    return Info;
    return;
}

function addToolTipDrawList(out CustomTooltip cTooltip, DrawItemInfo DrawItemInfoElement)
{
    cTooltip.DrawList[cTooltip.DrawList.Length] = DrawItemInfoElement;
    return;
}

function WebBrowserHandle getMe(string Path, byte Type)
{
    local string fullPath;

    fullPath = (m_hOwnerWnd.m_WindowNameWithFullPath $ ".") $ Path;
    return GetWebBrowserHandle(fullPath);
    return;
}

static function bool IsValidItemID(ItemID Id)
{
    // End:0x24
    if((Id.ClassID < 1) && Id.ServerID < 1)
    {
        return false;
    }
    return true;
    return;
}

static function ItemID GetItemID(int Id)
{
    local ItemID cID;

    cID.ClassID = Id;
    return cID;
    return;
}

function bool ParseItemID(string param, out ItemID Id)
{
    local bool bRet1, bRet2;

    bRet1 = ParseInt(param, "ClassID", Id.ClassID);
    bRet2 = ParseInt(param, "ServerID", Id.ServerID);
    return bRet1 || bRet2;
    return;
}

function bool ParseItemIDWithIndex(string param, out ItemID Id, int idx)
{
    local bool bRet1, bRet2;

    bRet1 = ParseInt(param, "ClassID_" $ string(idx), Id.ClassID);
    bRet2 = ParseInt(param, "ServerID_" $ string(idx), Id.ServerID);
    return bRet1 || bRet2;
    return;
}

function ParamAddItemID(out string param, ItemID Id)
{
    // End:0x30
    if(Id.ClassID > 0)
    {
        ParamAdd(param, "ClassID", string(Id.ClassID));
    }
    // End:0x61
    if(Id.ServerID > 0)
    {
        ParamAdd(param, "ServerID", string(Id.ServerID));
    }
    return;
}

function ParamAddItemIDWithIndex(out string param, ItemID Id, int idx)
{
    // End:0x3A
    if(Id.ClassID > 0)
    {
        ParamAdd(param, "ClassID_" $ string(idx), string(Id.ClassID));
    }
    // End:0x75
    if(Id.ServerID > 0)
    {
        ParamAdd(param, "ServerID_" $ string(idx), string(Id.ServerID));
    }
    return;
}

static function ClearItemID(out ItemID Id)
{
    Id.ClassID = -1;
    Id.ServerID = -1;
    return;
}

static function bool IsSameItemID(ItemID Src, ItemID des)
{
    // End:0x36
    if((Src.ClassID == des.ClassID) && Src.ServerID == des.ServerID)
    {
        return true;
    }
    return false;
    return;
}

static function bool IsSameClassID(ItemID Src, ItemID des)
{
    // End:0x1B
    if(Src.ClassID == des.ClassID)
    {
        return true;
    }
    return false;
    return;
}

static function bool IsSameServerID(ItemID Src, ItemID des)
{
    // End:0x1B
    if(Src.ServerID == des.ServerID)
    {
        return true;
    }
    return false;
    return;
}

static function bool IsAdena(ItemID Id)
{
    // End:0x13
    if(Id.ClassID == 57)
    {
        return true;
    }
    return false;
    return;
}

function string GetPrimeItemSymbolName()
{
    return "BranchSys.ui.primeitem_symbol";
    return;
}

static function string getCurrentWindowName(string targetString)
{
    local array<string> ArrayStr;

    Split(targetString, ".", ArrayStr);
    return ArrayStr[1];
    return;
}

static function string getOwnerWindowName(string targetString)
{
    local array<string> ArrayStr;

    Split(targetString, ".", ArrayStr);
    return ArrayStr[ArrayStr.Length - 2];
    return;
}

static function L2Util getInstanceL2Util()
{
    local L2Util script;

    script = L2Util(GetScript("L2Util"));
    return script;
    return;
}

static function InventoryViewer getInstanceInventoryViewer()
{
    local InventoryViewer script;

    script = InventoryViewer(GetScript("InventoryViewer"));
    return script;
    return;
}

static function UIData getInstanceUIData()
{
    local UIData script;

    script = UIData(GetScript("UIData"));
    return script;
    return;
}

static function NoticeWnd getInstanceNoticeWnd()
{
    local NoticeWnd script;

    script = NoticeWnd(GetScript("NoticeWnd"));
    return script;
    return;
}

static function ContextMenu getInstanceContextMenu()
{
    local ContextMenu script;

    script = ContextMenu(GetScript("ContextMenu"));
    return script;
    return;
}

function int getRollIconNum(UIEventManager.EClassRoleType rollType)
{
    switch(rollType)
    {
        // End:0x0F
        case 1:
            return 3;
        // End:0x17
        case 2:
            return 8;
        // End:0x1E
        case 3:
            return 1;
        // End:0x26
        case 4:
            return 2;
        // End:0x2E
        case 5:
            return 5;
        // End:0x36
        case 6:
            return 7;
        // End:0x3E
        case 7:
            return 4;
        // End:0x46
        case 8:
            return 6;
        // End:0x4D
        case 9:
            return 1;
        // End:0xFFFF
        default:
            return 1;
            break;
    }    
    return;
}

function string GetClassRoleIconName(int ClassID)
{
    local int degree;
    local UIEventManager.EClassRoleType rollType;

    rollType = GetClassRoleType(ClassID);
    degree = GetClassTransferDegree(ClassID);
    // End:0x3A
    if(int(rollType) == 9)
    {
        degree = 1;        
    }
    else
    {
        // End:0x4E
        if(degree > 4)
        {
            degree = 4;
        }
    }
    return (("L2UI_CH3.PartyWnd.party_styleicon" $ string(degree)) $ "_") $ string(getRollIconNum(rollType));
    return;
}

function string GetClassArenaRoleIconName(int ClassID)
{
    local UIEventManager.EClassRoleType rollType;

    rollType = GetClassRoleType(ClassID);
    // End:0x42
    if(int(rollType) == 9)
    {
        return "L2UI.TheArena.party_styleicon1_1";
    }
    return "L2UI.TheArena.party_styleicon4_" $ string(getRollIconNum(GetClassRoleType(ClassID)));
    return;
}

function Color GetNumericColor(coerce string strCommaAdena)
{
    local Color ResultColor;
    local int L, comma_num, i;

    ResultColor.R = 220;
    ResultColor.G = 220;
    ResultColor.B = 220;
    ResultColor.A = byte(255);
    L = Len(strCommaAdena);
    i = 0;
    J0x4A:

    // End:0x7F [Loop If]
    if(i < L)
    {
        // End:0x75
        if(Mid(strCommaAdena, i, 1) == ",")
        {
            ++comma_num;
        }
        ++i;
        // [Loop Continue]
        goto J0x4A;
    }
    L -= comma_num;
    // End:0x9D
    if(L < 5)
    {
        return ResultColor;
    }
    L = L - 5;
    switch(L)
    {
        // End:0xE5
        case 0:
            ResultColor.R = 105;
            ResultColor.G = byte(255);
            ResultColor.B = byte(255);
            // End:0x245
            break;
        // End:0x117
        case 1:
            ResultColor.R = byte(255);
            ResultColor.G = 128;
            ResultColor.B = byte(255);
            // End:0x245
            break;
        // End:0x14A
        case 2:
            ResultColor.R = byte(255);
            ResultColor.G = byte(255);
            ResultColor.B = 0;
            // End:0x245
            break;
        // End:0x17B
        case 3:
            ResultColor.R = 0;
            ResultColor.G = byte(255);
            ResultColor.B = 0;
            // End:0x245
            break;
        // End:0x1AC
        case 4:
            ResultColor.R = byte(255);
            ResultColor.G = 140;
            ResultColor.B = 0;
            // End:0x245
            break;
        // End:0x1DD
        case 5:
            ResultColor.R = 0;
            ResultColor.G = 110;
            ResultColor.B = byte(255);
            // End:0x245
            break;
        // End:0x20E
        case 6:
            ResultColor.R = byte(255);
            ResultColor.G = 0;
            ResultColor.B = 0;
            // End:0x245
            break;
        // End:0x23F
        case 7:
            ResultColor.R = 150;
            ResultColor.G = 110;
            ResultColor.B = byte(255);
            // End:0x245
            break;
        // End:0xFFFF
        default:
            // End:0x245
            break;
            break;
    }
    return ResultColor;
    return;
}

function string htmlSetHtmlStart(string targetHtml)
{
    return ("<html><body>" $ targetHtml) $ "</body></html>";
    return;
}

function string htmlAddItemButton(int nItemID, int nWidth, int nHeight)
{
    local string itemTexture, addItemHtml;
    local ItemID cItemID;

    cItemID.ClassID = nItemID;
    itemTexture = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cItemID);
    addItemHtml = (((((((((((((("<button width=" $ string(nWidth)) $ " height=") $ string(nHeight)) $ " itemtooltip=\"") $ string(nItemID)) $ "\"") $ " High=\"") $ itemTexture) $ "\"") $ " back=\"") $ itemTexture) $ "\"") $ " fore=\"") $ itemTexture) $ "\"> ";
    return addItemHtml;
    return;
}

function string htmlAddButton(string buttonText, string actionParam, optional int nWidth, optional int nHeight, optional int buttonAddWidth, optional int buttonAddHeight, optional string textStyle, optional string FontName, optional string FontColor, optional string backTexture, optional string highTexture, optional string ForeTexture)
{
    local string resultHtml, addHtml;
    local int textSizeWidth, textSizeHeight;

    // End:0x2A
    if(Len(FontName) > 0)
    {
        GetTextSize(buttonText, FontName, textSizeWidth, textSizeHeight);        
    }
    else
    {
        GetTextSize(buttonText, "GameDefault", textSizeWidth, textSizeHeight);
    }
    // End:0x7D
    if(nWidth > 0)
    {
        addHtml = ((addHtml $ "width=") $ string(nWidth)) $ " ";        
    }
    else
    {
        addHtml = ((addHtml $ "width=") $ string(textSizeWidth + buttonAddWidth)) $ " ";
    }
    // End:0xD9
    if(nHeight > 0)
    {
        addHtml = ((addHtml $ "height=") $ string(nHeight)) $ " ";        
    }
    else
    {
        addHtml = ((addHtml $ "height=") $ string(textSizeHeight + buttonAddHeight)) $ " ";
    }
    // End:0x138
    if(Len(textStyle) > 0)
    {
        addHtml = ((addHtml $ "textstyle=\"") $ textStyle) $ "\" ";
    }
    // End:0x16B
    if(Len(FontName) > 0)
    {
        addHtml = ((addHtml $ "fontName=\"") $ FontName) $ "\" ";
    }
    // End:0x19F
    if(Len(FontColor) > 0)
    {
        addHtml = ((addHtml $ "fontColor=\"") $ FontColor) $ "\" ";
    }
    // End:0x1D1
    if(Len(backTexture) > 0)
    {
        addHtml = ((addHtml $ "back=\"") $ backTexture) $ "\" ";        
    }
    else
    {
        addHtml = addHtml $ "back=\"L2UI_CT1.Button_DF_Down\" ";
    }
    // End:0x231
    if(Len(highTexture) > 0)
    {
        addHtml = ((addHtml $ "high=\"") $ highTexture) $ "\" ";        
    }
    else
    {
        addHtml = addHtml $ "high=\"L2UI_CT1.Button_DF_Over\" ";
    }
    // End:0x291
    if(Len(ForeTexture) > 0)
    {
        addHtml = ((addHtml $ "fore=\"") $ ForeTexture) $ "\" ";        
    }
    else
    {
        addHtml = addHtml $ "fore=\"L2UI_CT1.Button_DF\" ";
    }
    // End:0x2EB
    if(Len(actionParam) > 0)
    {
        addHtml = ((addHtml $ "action=\"") $ actionParam) $ "\" ";
    }
    resultHtml = ((("<button value=\"" $ buttonText) $ "\" ") $ addHtml) $ "> ";
    return resultHtml;
    return;
}

function string htmlAddImg(string strTexture, int nWidth, int nHeight)
{
    local string addItemHtml;

    addItemHtml = ((((("<img src=\"" $ strTexture) $ "\" width=") $ string(nWidth)) $ " height=") $ string(nHeight)) $ ">";
    return addItemHtml;
    return;
}

function string htmlAddLineImg(optional int lineWidth)
{
    // End:0x47
    if(lineWidth > 0)
    {
        return ("<img src=\"L2UI.SquareWhite\" width=" $ string(lineWidth)) $ " height=1>";
    }
    return "<img src=\"L2UI.SquareWhite\" width=270 height=1>";
    return;
}

function string htmlAddText(string strText, string FontName, optional string FontColor)
{
    local string targetHtml, addItemHtml;

    // End:0x2A
    if(Len(FontColor) > 0)
    {
        addItemHtml = (" color=\"" $ FontColor) $ "\" ";
    }
    targetHtml = ((((("<font name=\"" $ FontName) $ "\"") $ addItemHtml) $ ">") $ strText) $ "</font>";
    return targetHtml;
    return;
}

function string htmlUrlLinkText(string strText, string URL)
{
    local string targetHtml;

    targetHtml = (((("<a action=\"url " $ URL) $ "\"") $ ">") $ strText) $ "</a>";
    return targetHtml;
    return;
}

function string htmlSetTable(out string targetHtml, int border, int Width, int Height, string BackGroundTexture, int cellPadding, int cellspacing)
{
    targetHtml = ((((((((((((("<table width=" $ string(Width)) $ " height=") $ string(Height)) $ " border=") $ string(border)) $ " cellpadding=") $ string(cellPadding)) $ " cellspacing=") $ string(cellspacing)) $ " background=\"") $ BackGroundTexture) $ "\">") $ targetHtml) $ "</table>";
    return targetHtml;
    return;
}

function string htmlSetTableTR(out string targetHtml)
{
    targetHtml = ("<tr> " $ targetHtml) $ "</tr>";
    return targetHtml;
    return;
}

function string htmlAddTableTD(string strText, string alignStr, string vAlignStr, int Width, int Height, optional string BackGroundTexture, optional bool bWidthFix)
{
    local string addItemHtml;

    // End:0x28
    if(Len(alignStr) > 0)
    {
        addItemHtml = (" align=" $ alignStr) $ " ";
    }
    // End:0x58
    if(Len(vAlignStr) > 0)
    {
        addItemHtml = ((" valign=" $ vAlignStr) $ " ") $ addItemHtml;
    }
    // End:0x96
    if(bWidthFix)
    {
        // End:0x93
        if(Width > 0)
        {
            addItemHtml = ((" fixwidth=" $ string(Width)) $ " ") $ addItemHtml;
        }        
    }
    else
    {
        // End:0xC5
        if(Width > 0)
        {
            addItemHtml = ((" width=" $ string(Width)) $ " ") $ addItemHtml;
        }
    }
    // End:0xF5
    if(Height > 0)
    {
        addItemHtml = ((" height=" $ string(Height)) $ " ") $ addItemHtml;
    }
    // End:0x12B
    if(Len(BackGroundTexture) > 0)
    {
        addItemHtml = ((" background=\"" $ BackGroundTexture) $ "\" ") $ addItemHtml;
    }
    return ((("<td " $ addItemHtml) $ ">") $ strText) $ "</td>";
    return;
}

function string getQuestTypeString(int nQuestType)
{
    local string returnStr;

    switch(nQuestType)
    {
        // End:0x1F
        case 0:
            returnStr = GetSystemString(1795);
            // End:0x171
            break;
        // End:0x37
        case 1:
            returnStr = GetSystemString(7285);
            // End:0x171
            break;
        // End:0x50
        case 2:
            returnStr = GetSystemString(7286);
            // End:0x171
            break;
        // End:0x69
        case 3:
            returnStr = GetSystemString(7287);
            // End:0x171
            break;
        // End:0x82
        case 4:
            returnStr = GetSystemString(7288);
            // End:0x171
            break;
        // End:0x9B
        case 5:
            returnStr = GetSystemString(7276);
            // End:0x171
            break;
        // End:0xB4
        case 6:
            returnStr = GetSystemString(7277);
            // End:0x171
            break;
        // End:0xCD
        case 8:
            returnStr = GetSystemString(7278);
            // End:0x171
            break;
        // End:0xE6
        case 7:
            returnStr = GetSystemString(7279);
            // End:0x171
            break;
        // End:0xFF
        case 9:
            returnStr = GetSystemString(7280);
            // End:0x171
            break;
        // End:0x118
        case 10:
            returnStr = GetSystemString(7281);
            // End:0x171
            break;
        // End:0x131
        case 11:
            returnStr = GetSystemString(7282);
            // End:0x171
            break;
        // End:0x14A
        case 12:
            returnStr = GetSystemString(7283);
            // End:0x171
            break;
        // End:0x163
        case 13:
            returnStr = GetSystemString(7284);
            // End:0x171
            break;
        // End:0xFFFF
        default:
            returnStr = "";
            // End:0x171
            break;
            break;
    }
    return returnStr;
    return;
}

function string makeShortString(string targetString, int maxChar, string dotString)
{
    local string rStr;

    // End:0x2E
    if(Len(targetString) > maxChar)
    {
        rStr = Mid(targetString, 0, maxChar) $ dotString;        
    }
    else
    {
        rStr = targetString;
    }
    return rStr;
    return;
}

function string makeShortStringByPixel(string targetString, int maxPixel, string dotString, optional string FontName)
{
    local string fixedText, tempStr;
    local int textWidth, textHeight, dotWidth, dotHeight, i;

    // End:0x1F
    if(FontName == "")
    {
        FontName = "GameDefault";
    }
    GetTextSize(dotString, FontName, dotWidth, dotHeight);
    GetTextSize(targetString, FontName, textWidth, textHeight);
    // End:0x70
    if(textWidth <= maxPixel)
    {
        fixedText = targetString;        
    }
    else
    {
        fixedText = targetString;
        i = 0;
        J0x82:

        // End:0xF5 [Loop If]
        if(i < Len(targetString))
        {
            tempStr = Mid(targetString, 0, i);
            GetTextSize(tempStr, FontName, textWidth, textHeight);
            // End:0xEB
            if(maxPixel < (textWidth + dotWidth))
            {
                fixedText = tempStr $ dotString;
                // [Explicit Break]
                goto J0xF5;
            }
            i++;
            // [Loop Continue]
            goto J0x82;
        }
    }
    J0xF5:

    return fixedText;
    return;
}

function bool isVectorZero(Vector loc)
{
    // End:0x3F
    if(((loc.X == float(0)) && loc.Y == float(0)) && loc.Z == float(0))
    {
        return true;        
    }
    else
    {
        return false;
    }
    return;
}

function setTargetByServerID(int ServerID)
{
    local UserInfo UserInfo;

    // End:0x32
    if(ServerID != -1)
    {
        // End:0x32
        if(GetPlayerInfo(UserInfo))
        {
            RequestAction(ServerID, UserInfo.loc);
        }
    }
    return;
}

function bool numToBool(int bNum)
{
    // End:0x10
    if(bNum > 0)
    {
        return true;        
    }
    else
    {
        return false;
    }
    return;
}

function int boolToNum(bool Num)
{
    // End:0x0E
    if(Num)
    {
        return 1;        
    }
    else
    {
        return 0;
    }
    return;
}

function Color GetColor(int R, int G, int B, int A)
{
    local Color tColor;

    tColor.R = byte(R);
    tColor.G = byte(G);
    tColor.B = byte(B);
    tColor.A = byte(A);
    return tColor;
    return;
}

function string GetItemNameWithAdditional(ItemInfo Info)
{
    local string FullName, addStr;

    // End:0x2C
    if(Len(FullName) > 0)
    {
        FullName = (FullName $ " ") $ Info.Name;        
    }
    else
    {
        FullName = Info.Name;
    }
    // End:0x6A
    if(Len(Info.AdditionalName) > 0)
    {
        addStr = (addStr $ " ") $ Info.AdditionalName;
    }
    FullName = FullName $ addStr;
    return FullName;
    return;
}

function string GetItemNameAllBySeverID(int ServerID)
{
    local ItemInfo Info;
    local string itemNameStr;

    Class'NWindow.UIDATA_INVENTORY'.static.FindItem(ServerID, Info);
    itemNameStr = GetItemNameAll(Info);
    Debug("itemNameStr:::::  " @ itemNameStr);
    return itemNameStr;
    return;
}

function string GetItemNameAll(ItemInfo Info, optional bool bWithoutEnchant)
{
    local string ensoulOptionAllName, FullName, addStr;

    ensoulOptionAllName = GetEnsoulOptionNameAll(Info);
    // End:0x43
    if(!bWithoutEnchant)
    {
        // End:0x43
        if(Info.Enchanted > 0)
        {
            FullName = "+" $ string(Info.Enchanted);
        }
    }
    // End:0x6F
    if(Len(FullName) > 0)
    {
        FullName = (FullName $ " ") $ Info.Name;        
    }
    else
    {
        FullName = Info.Name;
    }
    // End:0xAD
    if(Len(Info.AdditionalName) > 0)
    {
        addStr = (addStr $ " ") $ Info.AdditionalName;
    }
    // End:0xD1
    if(Len(ensoulOptionAllName) > 0)
    {
        addStr = (addStr $ " ") $ ensoulOptionAllName;
    }
    FullName = FullName $ addStr;
    return FullName;
    return;
}

function string GetEnsoulOptionNameAll(ItemInfo weaponInfo)
{
    local EnsoulOptionUIInfo eOptionInfo;
    local int i, N, Cnt, optionId;
    local string allName;

    i = 1;
    J0x07:

    // End:0xF0 [Loop If]
    if(i < 3)
    {
        Cnt = weaponInfo.EnsoulOption[i - 1].OptionArray.Length;
        N = 1;
        J0x39:

        // End:0xE6 [Loop If]
        if(N < (1 + Cnt))
        {
            optionId = weaponInfo.EnsoulOption[i - 1].OptionArray[N - 1];
            // End:0x80
            if(optionId <= 0)
            {
                // [Explicit Continue]
                goto J0xDC;
            }
            GetEnsoulOptionUIInfo(optionId, eOptionInfo);
            // End:0xDC
            if(eOptionInfo.Name != "")
            {
                // End:0xC0
                if(allName == "")
                {
                    allName = eOptionInfo.Name;
                    // [Explicit Continue]
                    goto J0xDC;
                }
                allName = (allName $ "/") $ eOptionInfo.Name;
            }
            J0xDC:

            N++;
            // [Loop Continue]
            goto J0x39;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return allName;
    return;
}

function bool hasEnsoulOption(ItemInfo weaponInfo)
{
    local EnsoulOptionUIInfo eOptionInfo;
    local int i, N, Cnt, optionId;

    i = 1;
    J0x07:

    // End:0xA9 [Loop If]
    if(i < 3)
    {
        Cnt = weaponInfo.EnsoulOption[i - 1].OptionArray.Length;
        N = 1;
        J0x39:

        // End:0x9F [Loop If]
        if(N < (1 + Cnt))
        {
            optionId = weaponInfo.EnsoulOption[i - 1].OptionArray[N - 1];
            GetEnsoulOptionUIInfo(optionId, eOptionInfo);
            // End:0x95
            if(eOptionInfo.Name != "")
            {
                return true;
            }
            N++;
            // [Loop Continue]
            goto J0x39;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function addParamEnsoulOptionInfo(ItemInfo Info, out string param)
{
    local int i, N, Cnt;

    i = 1;
    J0x07:

    // End:0xE2 [Loop If]
    if(i < 3)
    {
        Cnt = Info.EnsoulOption[i - 1].OptionArray.Length;
        ParamAdd(param, "EnsoulOptionNum_" $ string(i), string(Cnt));
        N = 1;
        J0x66:

        // End:0xD8 [Loop If]
        if(N < (1 + Cnt))
        {
            ParamAdd(param, (("EnsoulOptionID_" $ string(i)) $ "_") $ string(N), string(Info.EnsoulOption[i - 1].OptionArray[N - 1]));
            N++;
            // [Loop Continue]
            goto J0x66;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function addEnsoulInfoToItemInfoByParamString(string param, out ItemInfo Info)
{
    local int i, N, Cnt, tmpInt;

    i = 1;
    J0x07:

    // End:0xE9 [Loop If]
    if(i < 3)
    {
        ParseInt(param, "EnsoulOptionNum_" $ string(i), Cnt);
        Info.EnsoulOption[i - 1].OptionArray.Length = Cnt;
        N = 1;
        J0x64:

        // End:0xDF [Loop If]
        if(N < (1 + Cnt))
        {
            ParseInt(param, (("EnsoulOptionID_" $ string(i)) $ "_") $ string(N), tmpInt);
            Info.EnsoulOption[i - 1].OptionArray[N - 1] = tmpInt;
            N++;
            // [Loop Continue]
            goto J0x64;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function string maxCountLimitString(INT64 Count, INT64 maxCount, string returnStr)
{
    local string RValue;

    // End:0x1E
    if(__NFUN_409__(Count, maxCount))
    {
        RValue = returnStr;        
    }
    else
    {
        RValue = (Count);
    }
    return RValue;
    return;
}

function string getStringDayAndTime(int tmpTime)
{
    local int tmpDay, tmpHou, tmpMin;
    local string timeStr;
    local int minToHou, minToDay;

    minToHou = 60;
    minToDay = minToHou * 24;
    tmpMin = tmpTime / 60;
    // End:0xBD
    if(tmpMin > minToDay)
    {
        tmpHou = tmpMin / 60;
        tmpDay = tmpHou / 24;
        tmpHou = tmpHou - (tmpDay * 24);
        // End:0x9C
        if(tmpHou != 0)
        {
            timeStr = MakeFullSystemMsg(GetSystemMessage(3503), string(tmpDay), string(tmpHou));            
        }
        else
        {
            timeStr = MakeFullSystemMsg(GetSystemMessage(3418), string(tmpDay));
        }        
    }
    else
    {
        // End:0x142
        if(tmpMin > 60)
        {
            tmpHou = tmpMin / 60;
            tmpMin = tmpMin - (tmpHou * 60);
            // End:0x121
            if(tmpMin != 0)
            {
                timeStr = MakeFullSystemMsg(GetSystemMessage(3304), string(tmpHou), string(tmpMin));                
            }
            else
            {
                timeStr = MakeFullSystemMsg(GetSystemMessage(3406), string(tmpHou));
            }            
        }
        else
        {
            timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(tmpMin));
        }
    }
    return timeStr;
    return;
}

function bool isAreaState()
{
    local string stateStr;
    local bool bReturn;

    stateStr = GetGameStateName();
    // End:0x51
    if((stateStr == "ARENAGAMINGSTATE") || stateStr == "ARENABATTLESTATE")
    {
        bReturn = true;        
    }
    else
    {
        bReturn = false;
    }
    return bReturn;
    return;
}

function string getHuntingZoneTypeString(int nHuntingZoneType)
{
    local string tmpStr;

    // End:0x1F
    if(nHuntingZoneType == 0)
    {
        tmpStr = GetSystemString(1312);        
    }
    else
    {
        // End:0x3E
        if(nHuntingZoneType == 1)
        {
            tmpStr = GetSystemString(3517);            
        }
        else
        {
            // End:0x5E
            if(nHuntingZoneType == 2)
            {
                tmpStr = GetSystemString(3518);                
            }
            else
            {
                // End:0x7E
                if(nHuntingZoneType == 3)
                {
                    tmpStr = GetSystemString(3542);                    
                }
                else
                {
                    // End:0x9E
                    if(nHuntingZoneType == 4)
                    {
                        tmpStr = GetSystemString(3543);                        
                    }
                    else
                    {
                        // End:0xBE
                        if(nHuntingZoneType == 5)
                        {
                            tmpStr = GetSystemString(1317);                            
                        }
                        else
                        {
                            // End:0xDE
                            if(nHuntingZoneType == 6)
                            {
                                tmpStr = GetSystemString(1270);                                
                            }
                            else
                            {
                                // End:0xFE
                                if(nHuntingZoneType == 7)
                                {
                                    tmpStr = GetSystemString(7299);                                    
                                }
                                else
                                {
                                    // End:0x11E
                                    if(nHuntingZoneType == 8)
                                    {
                                        tmpStr = GetSystemString(3546);                                        
                                    }
                                    else
                                    {
                                        // End:0x13E
                                        if(nHuntingZoneType == 9)
                                        {
                                            tmpStr = GetSystemString(3547);                                            
                                        }
                                        else
                                        {
                                            // End:0x15B
                                            if(nHuntingZoneType == 10)
                                            {
                                                tmpStr = GetSystemString(3548);
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
    return tmpStr;
    return;
}

function string getRaidZoneName(int search_zoneid)
{
    local string HuntingZoneName;
    local int i;

    i = 0;
    J0x07:

    // End:0x89 [Loop If]
    if(i < 500)
    {
        // End:0x7F
        if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
        {
            // End:0x7F
            if(Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneType(i) == 0)
            {
                // End:0x7F
                if(Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZone(i) == search_zoneid)
                {
                    HuntingZoneName = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i);
                }
            }
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return HuntingZoneName;
    return;
}

function bool IsValidDataForHuntingZoneUIData(HuntingZoneUIData Info)
{
    // End:0x91
    if((((((((Info.strName == "") && Info.nType == 0) && Info.nMinLevel == 0) && Info.nMaxLevel == 0) && Info.nMinLevel == 0) && Info.nSearchZoneID == 0) && Info.nRegionID == 0) && Info.nNpcID == 0)
    {
        return false;
    }
    return true;
    return;
}

function bool tryLevelCheck(int UserLevel, int MinLevel, int MaxLevel)
{
    // End:0x22
    if((UserLevel >= MinLevel) && UserLevel <= MaxLevel)
    {
        return true;
    }
    return false;
    return;
}

function bool isVectorZeroXYZ(float X, float Y, float Z)
{
    // End:0x2D
    if(((X == float(0)) && Y == float(0)) && Z == float(0))
    {
        return true;
    }
    return false;
    return;
}

function int getHuntingZoneIndexByName(string HuntingZoneName)
{
    local int i, R;

    R = -1;
    i = 0;
    J0x12:

    // End:0x6E [Loop If]
    if(i < 500)
    {
        // End:0x64
        if(Class'NWindow.UIDATA_HUNTINGZONE'.static.IsValidData(i))
        {
            // End:0x64
            if(Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(i) == HuntingZoneName)
            {
                R = i;
                // [Explicit Break]
                goto J0x6E;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    J0x6E:

    return R;
    return;
}

function RaidUIData getRaidDataByIndex(int Index)
{
    local RaidUIData pRaidUIData;

    // End:0x129
    if(Class'NWindow.UIDATA_RAID'.static.IsValidData(Index))
    {
        pRaidUIData.Id = Index;
        pRaidUIData.nRaidMonsterID = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterID(Index);
        pRaidUIData.nRaidMonsterLevel = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterLevel(Index);
        pRaidUIData.nRaidMonsterZone = Class'NWindow.UIDATA_RAID'.static.GetRaidMonsterZone(Index);
        pRaidUIData.raidDesc = Class'NWindow.UIDATA_RAID'.static.GetRaidDescription(Index);
        pRaidUIData.raidMonsterName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(pRaidUIData.nRaidMonsterID);
        pRaidUIData.nWorldLoc = Class'NWindow.UIDATA_RAID'.static.GetRaidLoc(Index);
        pRaidUIData.RaidMonsterZoneName = getRaidZoneName(pRaidUIData.nRaidMonsterZone);
        Class'NWindow.UIDATA_RAID'.static.GetRaidRecommendLevel(Index, pRaidUIData.nMinLevel, pRaidUIData.nMaxLevel);
    }
    return pRaidUIData;
    return;
}

function Vector setVector(int X, int Y, int Z)
{
    local Vector loc;

    loc.X = float(X);
    loc.Y = float(Y);
    loc.Z = float(Z);
    return loc;
    return;
}

function bool bfm()
{
    return (IsBuilderPC()) || DebugSectorBool("debug", "bfm");
    return;
}

function Say(coerce string Text, optional bool bWithGfx)
{
    // End:0x4F
    if((bfm()) && DebugSectorBool("debug", "chatdebug"))
    {
        AddSystemMessageString(Text);
        // End:0x4F
        if(bWithGfx)
        {
            getInstanceL2Util().showGfxScreenMessage(Text);
        }
    }
    return;
}

function fDebug(coerce string Text)
{
    // End:0x4D
    if((IsBuilderPC()) && DebugSectorBool("debug", "flashdebug"))
    {
        UIDebugWnd(GetScript("UIDebugWnd")).SendFlashDebug(Text);
    }
    return;
}

function iniSet(string val, optional string dbgFile)
{
    local string file;

    // End:0x7E
    if((IsBuilderPC()) && DebugSectorBool("debug", "logdebug"))
    {
        file = "debug.ini";
        // End:0x4D
        if(dbgFile != "")
        {
            file = dbgFile;
        }
        nDebugVal++;
        SetINIString("values", string(nDebugVal), val, file);
        RefreshINI(file);
    }
    return;
}

function iniSet2(string val, optional string dbgFile)
{
    local string file;

    // End:0x73
    if(DebugSectorBool("debug", "logdebug"))
    {
        file = "debug.ini";
        // End:0x42
        if(dbgFile != "")
        {
            file = dbgFile;
        }
        nDebugVal++;
        SetINIString("values", string(nDebugVal), val, file);
        RefreshINI(file);
    }
    return;
}

function iniSetNB(string val)
{
    return;
}

function string GetCustomServerSuffix()
{
    switch(GetOptionInt("L2", "CustomServerType"))
    {
        // End:0x27
        case 1:
            return "x7";
        // End:0x35
        case 2:
            return "x20old";
        // End:0x40
        case 3:
            return "x20";
        // End:0x4C
        case 4:
            return "x500";
        // End:0x51
        case 5:
        // End:0x5F
        case 6:
            return "x20new";
        // End:0xFFFF
        default:
            return "";
            break;
    }
    return;
}

function string ApplyCustomServerSuffix(string baseFile)
{
    local string suffix;
    local int i, lastDot;

    suffix = GetCustomServerSuffix();
    // End:0x1E
    if(suffix == "")
    {
        return baseFile;
    }
    lastDot = -1;
    i = 0;
    J0x30:

    // End:0x6B [Loop If]
    if(i < Len(baseFile))
    {
        // End:0x61
        if(Mid(baseFile, i, 1) == ".")
        {
            lastDot = i;
        }
        i++;
        // [Loop Continue]
        goto J0x30;
    }
    // End:0x88
    if(lastDot < 0)
    {
        return (baseFile $ "-") $ suffix;
    }
    return ((Left(baseFile, lastDot) $ "-") $ suffix) $ Mid(baseFile, lastDot);
    return;
}

function bool GetINIStringPrefixed(string section, string Key, out string Value, string baseFile)
{
    local string prefixed;

    prefixed = ApplyCustomServerSuffix(baseFile);
    // End:0x41
    if((prefixed != baseFile) && GetINIString(section, Key, Value, prefixed))
    {
        return true;
    }
    return GetINIString(section, Key, Value, baseFile);
    return;
}

function bool GetINIIntPrefixed(string section, string Key, out int Value, string baseFile)
{
    local string prefixed;

    prefixed = ApplyCustomServerSuffix(baseFile);
    // End:0x41
    if((prefixed != baseFile) && GetINIInt(section, Key, Value, prefixed))
    {
        return true;
    }
    return GetINIInt(section, Key, Value, baseFile);
    return;
}

function bool GetINIBoolPrefixed(string section, string Key, out int Value, string baseFile)
{
    local string prefixed;

    prefixed = ApplyCustomServerSuffix(baseFile);
    // End:0x41
    if((prefixed != baseFile) && GetINIBool(section, Key, Value, prefixed))
    {
        return true;
    }
    return GetINIBool(section, Key, Value, baseFile);
    return;
}

function RefreshINIPrefixed(string baseFile)
{
    local string prefixed;

    prefixed = ApplyCustomServerSuffix(baseFile);
    // End:0x2B
    if(prefixed != baseFile)
    {
        RefreshINI(prefixed);
    }
    RefreshINI(baseFile);
    return;
}

function int SettingSectorInt(string bLock, string Field)
{
    local int B;

    GetINIIntPrefixed(bLock, Field, B, "settings.ini");
    return B;
    return;
}

function string SettingSectorStr(string bLock, string Field)
{
    local string B;

    GetINIStringPrefixed(bLock, Field, B, "settings.ini");
    return B;
    return;
}

function bool DebugSectorBool(string bLock, string Field)
{
    local int B;

    GetINIBool(bLock, Field, B, "dbg.ini");
    return bool(B);
    return;
}

function bool SettingSectorBool(string bLock, string Field)
{
    local int B;

    GetINIBoolPrefixed(bLock, Field, B, "settings.ini");
    return bool(B);
    return;
}

function string GetSectorString(string bLock, string Field)
{
    local string B;

    // End:0x1D
    if(IsBuilderPC())
    {
        RefreshINIPrefixed("settings.ini");
    }
    GetINIStringPrefixed(bLock, Field, B, "settings.ini");
    return B;
    return;
}

function array<int> getIniArrayInt(string bLock, string Field, string ini)
{
    local string strLine;
    local array<int> Array;

    GetINIString(bLock, Field, strLine, ini);
    Array = arrInt(strLine, ";");
    return Array;
    return;
}

function string ReturnChatEditBoxStr()
{
    local string S;

    S = GetEditBoxHandle("ChatWnd.ChatEditBox").GetString();
    return GetEditBoxHandle("ChatWnd.ChatEditBox").GetString();
    return;
}

function int ReturnChatEditBoxInt()
{
    local string S;

    S = GetEditBoxHandle("ChatWnd.ChatEditBox").GetString();
    return int(S);
    return;
}

function int ReturnChatEditBoxFloat()
{
    local string S;

    S = GetEditBoxHandle("ChatWnd.ChatEditBox").GetString();
    return int(float(S));
    return;
}

function ShowW(string a_ControlID)
{
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(a_ControlID);
    return;
}

function HideW(string a_ControlID)
{
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(a_ControlID);
    return;
}

function FocusW(string a_ControlID)
{
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus(a_ControlID);
    return;
}

function bool IsShow(string a_ControlID)
{
    // End:0x1C
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(a_ControlID))
    {
        return true;        
    }
    else
    {
        return false;
    }
    return;
}

function array<string> Arr(string Str, string delim, optional out int q)
{
    local int i;
    local array<string> tmp;

    // End:0x13
    if(Len(Str) < 1)
    {
        return tmp;
    }
    // End:0x48
    if(Left(Str, Len(delim)) == delim)
    {
        Str = Left(Str, Len(Str) - Len(delim));
    }
    // End:0x75
    if(InStr(Str, delim) < 0)
    {
        tmp.Length = 1;
        tmp[0] = Str;
        return tmp;
    }
    q = Split(Str, delim, tmp);
    return tmp;
    return;
}

function array<int> arrInt(string Str, string delim, optional int q)
{
    local array<string> tmp;
    local array<int> tmpInt;
    local int i;

    // End:0x13
    if(Len(Str) < 1)
    {
        return tmpInt;
    }
    q = Split(Str, delim, tmp);
    i = 0;
    J0x35:

    // End:0x68 [Loop If]
    if(i < tmp.Length)
    {
        tmpInt[i] = int(tmp[i]);
        i++;
        // [Loop Continue]
        goto J0x35;
    }
    return tmpInt;
    return;
}

function array<string> MergeArray(array<string> FirstArr, array<string> SecondArr)
{
    local int i, ByNull, FirstLen, SecondLen;

    ByNull = 0;
    // End:0x19
    if(SecondArr.Length <= 0)
    {
        return FirstArr;
    }
    FirstLen = FirstArr.Length;
    SecondLen = SecondArr.Length;
    i = FirstLen;
    J0x3C:

    // End:0x7A [Loop If]
    if(i < (FirstLen + SecondLen))
    {
        FirstArr[i] = SecondArr[ByNull];
        ByNull++;
        i++;
        // [Loop Continue]
        goto J0x3C;
    }
    return FirstArr;
    return;
}

function array<string> ReturnArray(array<string> Arr)
{
    local int i;
    local array<string> tmp;

    i = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(i < Arr.Length)
    {
        tmp[i] = Arr[i];
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return tmp;
    return;
}

function array<ItemInfo> RemoveEquippedItemFromArray(array<ItemInfo> ItemArr)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x41 [Loop If]
    if(i < ItemArr.Length)
    {
        // End:0x37
        if(ItemArr[i].bEquipped)
        {
            ItemArr.Remove(i, 1);
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return ItemArr;
    return;
}

function int DistToVector(Vector loc)
{
    local Vector MyPosition;
    local int Distance, distX, distY;

    MyPosition = GetPlayerPosition();
    distX = int(loc.X - MyPosition.X);
    distY = int(loc.Y - MyPosition.Y);
    Distance = int(Sqrt(float(distX * distX) + float(distY * distY)));
    return Distance;
    return;
}

function INT64 getInventoryItemNumByClassID(int nItemID)
{
    local array<ItemInfo> itemInfoArray;
    local INT64 ItemCount;

    Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(nItemID, itemInfoArray);
    // End:0x5D
    if(itemInfoArray.Length > 0)
    {
        // End:0x4F
        if(IsStackableItem(itemInfoArray[0].ConsumeType))
        {
            ItemCount = itemInfoArray[0].ItemNum;            
        }
        else
        {
            ItemCount = (itemInfoArray.Length);
        }
    }
    return ItemCount;
    return;
}

function bool IsRealPlayer()
{
    local bool bIsServerObject, bIsVehicle;
    local UserInfo Info, Player;

    GetTargetInfo(Info);
    GetPlayerInfo(Player);
    bIsServerObject = Class'NWindow.UIDATA_TARGET'.static.IsServerObject();
    bIsVehicle = Class'NWindow.UIDATA_TARGET'.static.IsVehicle();
    // End:0x80
    if(((!Info.bNpc && !Info.bPet) && !bIsServerObject) && !bIsVehicle)
    {
        return true;
    }
    return false;
    return;
}

function AnimTextureLoopPlay(string controlPath, string texturePath, int playLoopCount)
{
    GetAnimTextureHandle(controlPath).SetTexture(texturePath);
    GetAnimTextureHandle(controlPath).ShowWindow();
    GetAnimTextureHandle(controlPath).SetLoopCount(playLoopCount);
    GetAnimTextureHandle(controlPath).Stop();
    GetAnimTextureHandle(controlPath).Play();
    return;
}

function AnimTextureStop(AnimTextureHandle animTexture, optional bool bHide)
{
    // End:0x18
    if(bHide)
    {
        animTexture.HideWindow();
    }
    animTexture.Stop();
    return;
}

function AnimTexturePlay(AnimTextureHandle animTexture, optional bool bShow, optional int playLoopCount)
{
    // End:0x18
    if(bShow)
    {
        animTexture.ShowWindow();
    }
    // End:0x2E
    if(playLoopCount <= 0)
    {
        playLoopCount = 999999;
    }
    animTexture.SetLoopCount(playLoopCount);
    animTexture.Stop();
    animTexture.Play();
    return;
}

function CustomTooltip MakeTooltipMultiTextByArray(array<DrawItemInfo> drawItemInfoArr, optional int toolTipWidth)
{
    local CustomTooltip ToolTip;

    ToolTip.DrawList = drawItemInfoArr;
    // End:0x2B
    if(toolTipWidth > 0)
    {
        ToolTip.MinimumWidth = toolTipWidth;
    }
    return ToolTip;
    return;
}

function string getTimeToHourMinOrMinSecStr(int Sec)
{
    local string returnStr;
    local int m_timeHour, m_timeMin, m_timeSec;

    m_timeHour = Sec / 3600;
    m_timeMin = int(float(Sec) % float(3600 / 60));
    m_timeSec = int(float(Sec) % float(60));
    // End:0xDC
    if(m_timeHour >= 1)
    {
        // End:0x6F
        if(m_timeHour < 10)
        {
            returnStr = "0" $ string(m_timeHour);            
        }
        else
        {
            returnStr = string(m_timeHour);
        }
        returnStr = returnStr $ "h ";
        // End:0xB5
        if(m_timeMin < 10)
        {
            returnStr = (returnStr $ "0") $ string(m_timeMin);            
        }
        else
        {
            returnStr = returnStr $ string(m_timeMin);
        }
        returnStr = returnStr $ "m";        
    }
    else
    {
        // End:0xFD
        if(m_timeMin < 10)
        {
            returnStr = "0" $ string(m_timeMin);            
        }
        else
        {
            returnStr = string(m_timeMin);
        }
        returnStr = returnStr $ "m ";
        // End:0x143
        if(m_timeSec < 10)
        {
            returnStr = (returnStr $ "0") $ string(m_timeSec);            
        }
        else
        {
            returnStr = returnStr $ string(m_timeSec);
        }
        returnStr = returnStr $ "s";
    }
    return returnStr;
    return;
}

function string getSecToTimeStr(int Sec)
{
    local string returnStr;
    local int RemainSec, m_timeHour, m_timeMin, m_timeSec;

    m_timeHour = Sec / 3600;
    RemainSec = int(float(Sec) % float(3600));
    m_timeMin = RemainSec / 60;
    m_timeSec = int(float(RemainSec) % float(60));
    returnStr = "";
    // End:0x77
    if(m_timeHour < 10)
    {
        returnStr = "0" $ string(m_timeHour);        
    }
    else
    {
        returnStr = string(m_timeHour);
    }
    // End:0xAD
    if(m_timeMin < 10)
    {
        returnStr = (returnStr $ ":0") $ string(m_timeMin);        
    }
    else
    {
        returnStr = (returnStr $ ":") $ string(m_timeMin);
    }
    // End:0xEF
    if(m_timeSec < 10)
    {
        returnStr = (returnStr $ ":0") $ string(m_timeSec);        
    }
    else
    {
        returnStr = (returnStr $ ":") $ string(m_timeSec);
    }
    return returnStr;
    return;
}

function string getSecToTimeStrFull(int Sec)
{
    local string returnStr;
    local int RemainSec, m_timeHour, m_timeMin, m_timeSec;

    m_timeHour = Sec / 3600;
    RemainSec = int(float(Sec) % float(3600));
    m_timeMin = RemainSec / 60;
    m_timeSec = int(float(RemainSec) % float(60));
    returnStr = "";
    // End:0x77
    if(m_timeHour < 10)
    {
        returnStr = "0" $ string(m_timeHour);        
    }
    else
    {
        returnStr = string(m_timeHour);
    }
    // End:0xB3
    if(m_timeMin < 10)
    {
        returnStr = (returnStr $ " Hours 0") $ string(m_timeMin);        
    }
    else
    {
        returnStr = (returnStr $ " Hours ") $ string(m_timeMin);
    }
    // End:0x10E
    if(m_timeSec < 10)
    {
        returnStr = ((returnStr $ " Minutes 0") $ string(m_timeSec)) @ "Seconds";        
    }
    else
    {
        returnStr = ((returnStr $ " Minutes ") $ string(m_timeSec)) @ "Seconds";
    }
    return returnStr;
    return;
}

function string getSecToDateStr(int Sec, bool onlyDayFlag)
{
    local string returnStr;
    local int RemainSec, m_timeDay, m_timeHour, m_timeMin;

    m_timeDay = Sec / 86400;
    RemainSec = int(float(Sec) % float(86400));
    m_timeHour = (RemainSec / 60) / 60;
    m_timeMin = int(float(RemainSec / 60) % float(60));
    returnStr = "";
    // End:0x83
    if(m_timeDay > 0)
    {
        returnStr = string(m_timeDay) $ GetSystemString(1109);
    }
    // End:0x168
    if(onlyDayFlag == false)
    {
        // End:0xAB
        if(returnStr != "")
        {
            returnStr = returnStr $ "/";
        }
        // End:0xF5
        if(m_timeHour > 0)
        {
            // End:0xDE
            if(m_timeHour < 10)
            {
                returnStr = (returnStr $ "0") $ string(m_timeHour);                
            }
            else
            {
                returnStr = returnStr $ string(m_timeHour);
            }            
        }
        else
        {
            returnStr = returnStr $ "00";
        }
        // End:0x156
        if(m_timeMin > 0)
        {
            // End:0x13A
            if(m_timeMin < 10)
            {
                returnStr = (returnStr $ ":0") $ string(m_timeMin);                
            }
            else
            {
                returnStr = (returnStr $ ":") $ string(m_timeMin);
            }            
        }
        else
        {
            returnStr = returnStr $ ":00";
        }
    }
    return returnStr;
    return;
}

function ini(int vars)
{
    switch(vars)
    {
        // End:0x37
        case 0:
            RefreshINI("WindowsInfo.ini");
            RefreshINI("Option.ini");
            // End:0x75
            break;
        // End:0x50
        case 1:
            RefreshINI("Option.ini");
            // End:0x75
            break;
        // End:0x6F
        case 2:
            RefreshINI("WindowsInfo.ini");
            // End:0x75
            break;
        // End:0xFFFF
        default:
            // End:0x75
            break;
            break;
    }
    return;
}

function DrawItemInfo TLTP_TEXTURE_LINE(string texture_name, bool oneline, bool LineBreak, int X, int Y, int UW, int UH)
{
    local DrawItemInfo Info;

    Info.t_MaxWidth = 140;
    Info.eType = 2;
    Info.nOffSetX = X;
    Info.nOffSetY = Y;
    Info.t_bDrawOneLine = oneline;
    Info.bLineBreak = LineBreak;
    Info.u_nTextureUWidth = UW;
    Info.u_nTextureUHeight = UH;
    Info.u_nTextureWidth = UW;
    Info.u_nTextureHeight = UH;
    Info.u_strTexture = texture_name;
    return Info;
    return;
}

function DrawItemInfo TLTP_TEXT_LINE(string Text, bool oneline, bool LineBreak, int X, int Y, int MaxW)
{
    local DrawItemInfo Info;

    Info.t_MaxWidth = MaxW;
    Info.eType = 1;
    Info.t_strText = Text;
    Info.t_bDrawOneLine = oneline;
    Info.bLineBreak = LineBreak;
    Info.nOffSetX = X;
    Info.nOffSetY = Y;
    Info.t_color.R = byte(255);
    Info.t_color.G = byte(255);
    Info.t_color.B = byte(255);
    Info.t_color.A = byte(255);
    return Info;
    return;
}

function DrawItemInfo TLTP_COLOR_TEXT_LINE(string Text, bool oneline, bool LineBreak, int X, int Y, int MaxW, Color Col)
{
    local DrawItemInfo Info;

    Info.t_MaxWidth = MaxW;
    Info.eType = 1;
    Info.t_strText = Text;
    Info.t_bDrawOneLine = oneline;
    Info.bLineBreak = LineBreak;
    Info.nOffSetX = X;
    Info.nOffSetY = Y;
    Info.t_color.R = Col.R;
    Info.t_color.G = Col.G;
    Info.t_color.B = Col.B;
    Info.t_color.A = byte(255);
    return Info;
    return;
}

function DrawItemInfo TLTP_BLANK(int Height)
{
    local DrawItemInfo Info;

    Info.eType = 0;
    Info.b_nHeight = Height;
    return;
}

function CustomTooltip SmallCPSlider(int Percent, int bpercent, int hppercent, int mppercent, int mp2percent)
{
    local CustomTooltip ToolTip;

    ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_TEXTURE_LINE("small_icon.etc_cp_potion_i01", true, true, 2, 0, 16, 16);
    // End:0xA5
    if(bpercent > 0)
    {
        ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_COLOR_TEXT_LINE((GetSystemString(15006) @ string(bpercent)) $ "%", true, false, 5, 1, ToolTip.MinimumWidth, GetColor(206, 191, 100, 255));        
    }
    else
    {
        ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_COLOR_TEXT_LINE(GetSystemString(15005), true, false, 5, 1, ToolTip.MinimumWidth, GetColor(185, 185, 18, 2555));
    }
    ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_TEXTURE_LINE("small_icon.etc_cp_potion_i00", true, true, 2, 0, 16, 16);
    // End:0x192
    if(Percent > 0)
    {
        ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_COLOR_TEXT_LINE((GetSystemString(15006) @ string(Percent)) $ "%", true, false, 5, 1, ToolTip.MinimumWidth, GetColor(206, 191, 100, 255));        
    }
    else
    {
        ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_COLOR_TEXT_LINE(GetSystemString(15005), true, false, 5, 1, ToolTip.MinimumWidth, GetColor(185, 185, 185, 255));
    }
    ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_TEXTURE_LINE("small_icon.etc_reagent_white_i00", true, true, 2, 0, 16, 16);
    // End:0x280
    if(hppercent > 0)
    {
        ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_COLOR_TEXT_LINE((GetSystemString(15007) @ string(hppercent)) $ "%", true, false, 5, 1, ToolTip.MinimumWidth, GetColor(255, 100, 100, 255));        
    }
    else
    {
        ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_COLOR_TEXT_LINE(GetSystemString(15005), true, false, 5, 1, ToolTip.MinimumWidth, GetColor(185, 185, 185, 255));
    }
    ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_TEXTURE_LINE("small_icon.etc_reagent_blue_i00", true, true, 2, 0, 16, 16);
    // End:0x36D
    if(mppercent > 0)
    {
        ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_COLOR_TEXT_LINE((GetSystemString(15008) @ string(mppercent)) $ "%", true, false, 5, 1, ToolTip.MinimumWidth, GetColor(75, 115, 250, 255));        
    }
    else
    {
        ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_COLOR_TEXT_LINE(GetSystemString(15005), true, false, 5, 1, ToolTip.MinimumWidth, GetColor(185, 185, 185, 255));
    }
    ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_TEXTURE_LINE("small_icon.etc_potion_blue_i00", true, true, 2, 0, 16, 16);
    // End:0x459
    if(mp2percent > 0)
    {
        ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_COLOR_TEXT_LINE((GetSystemString(15008) @ string(mp2percent)) $ "%", true, false, 5, 1, ToolTip.MinimumWidth, GetColor(75, 115, 250, 255));        
    }
    else
    {
        ToolTip.DrawList[ToolTip.DrawList.Length] = TLTP_COLOR_TEXT_LINE(GetSystemString(15005), true, false, 5, 1, ToolTip.MinimumWidth, GetColor(185, 185, 185, 255));
    }
    return ToolTip;
    return;
}

function INT64 OwnItem(ItemWindowHandle ItemWnd, ItemID Id)
{
    local int idx;
    local ItemInfo Info;

    idx = ItemWnd.FindItem(Id);
    ItemWnd.GetItem(idx, Info);
    // End:0x54
    if(__NFUN_409__(Info.ItemNum, (0)))
    {
        return Info.ItemNum;        
    }
    else
    {
        return (0);
    }
    return;
}

function GetSetEx(string a_ItemWindow, string a_SetItemWindow, ItemID Id, optional int Clear, optional ItemInfo out_iteminfo)
{
    local int IndexTmp;
    local ItemInfo InfoTmp;

    IndexTmp = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(a_ItemWindow, Id);
    // End:0x8F
    if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem(a_ItemWindow, IndexTmp, InfoTmp))
    {
        // End:0x5F
        if(Clear == 1)
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear(a_SetItemWindow);
        }
        // End:0x84
        if(a_SetItemWindow != "")
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(a_SetItemWindow, InfoTmp);
        }
        out_iteminfo = InfoTmp;
    }
    return;
}

function bool IsACPSelectableItems(int ClassID)
{
    switch(ClassID)
    {
        // End:0x0F
        case 22025:
        // End:0x17
        case 1539:
        // End:0x1F
        case 1060:
        // End:0x27
        case 1061:
        // End:0x31
        case 728:
            return true;
        // End:0xFFFF
        default:
            // End:0x37
            break;
            break;
    }
    return;
}

function bool isCrafter()
{
    return Class'NWindow.UIDATA_PLAYER'.static.HasCrystallizeAbility();
    return;
}

function bool IsKamael()
{
    local UserInfo Info;

    GetPlayerInfo(Info);
    return Info.Race == 5;
    return;
}

function bool IsSoulConsumer()
{
    local UserInfo Info;

    GetPlayerInfo(Info);
    return (Info.nSubClass >= 123) && Info.nSubClass <= 136;
    return;
}

function bool getIsEnergyConsumer()
{
    local UserInfo Info;

    GetPlayerInfo(Info);
    switch(Info.nSubClass)
    {
        // End:0x1B
        case 1:
        // End:0x20
        case 2:
        // End:0x25
        case 47:
        // End:0x2A
        case 48:
        // End:0x2F
        case 88:
        // End:0x36
        case 114:
            return true;
        // End:0xFFFF
        default:
            return false;
            break;
    }    
    return;
}

function bool getIsSpecialSlotPlayer()
{
    return (getIsEnergyConsumer()) || IsSoulConsumer();
    return;
}

function string GetMyName()
{
    local UserInfo Info;

    GetPlayerInfo(Info);
    return Info.Name;
    return;
}

function int GetAbs(int Num)
{
    // End:0x13
    if(Num < 0)
    {
        return -Num;
    }
    return Num;
    return;
}

function string EnchantOrCountIcon(ItemInfo Info)
{
    // End:0x68
    if(!Ignore(Info.Id))
    {
        // End:0x68
        if((Info.Enchanted > 0) && __NFUN_409__(Info.SlotBitType, (0)))
        {
            return "L2_UI8.enchant.ench_number" $ string(Info.Enchanted - 1);
        }
    }
    return;
}

function bool Ignore(ItemID Id)
{
    switch(Id.ClassID)
    {
        // End:0x16
        case 57:
            return true;
            // End:0x1C
            break;
        // End:0xFFFF
        default:
            // End:0x1C
            break;
            break;
    }
    return false;
    return;
}

function ItemInfo getItemInfoBySkillInfo(SkillInfo rSkilInfo, optional bool bFull)
{
    local ItemInfo infItem;

    infItem.Id.ClassID = rSkilInfo.SkillID;
    // End:0x9A
    if(bFull)
    {
        infItem.Level = rSkilInfo.SkillLevel;
        infItem.SubLevel = rSkilInfo.SkillSubLevel;
        // End:0x75
        if(rSkilInfo.SkillSubLevel > 0)
        {
            infItem.AdditionalName = rSkilInfo.EnchantName;            
        }
        else
        {
            infItem.AdditionalName = "";
        }
        infItem.ItemType = rSkilInfo.OperateType;        
    }
    else
    {
        infItem.Level = 1;
        infItem.SubLevel = 0;
        infItem.ItemType = 1;
    }
    infItem.Name = rSkilInfo.SkillName;
    infItem.IconName = rSkilInfo.TexName;
    infItem.IconPanel = rSkilInfo.IconPanel;
    infItem.Description = rSkilInfo.SkillDesc;
    infItem.ItemSubType = 2;
    return infItem;
    return;
}

function int IsThirdClass(int nSubClass)
{
    switch(nSubClass)
    {
        // End:0x12
        case 88:
            return 1159;
        // End:0x1D
        case 89:
            return 1160;
        // End:0x28
        case 90:
            return 1161;
        // End:0x33
        case 91:
            return 1162;
        // End:0x3E
        case 92:
            return 1163;
        // End:0x49
        case 93:
            return 1164;
        // End:0x54
        case 94:
            return 1165;
        // End:0x5F
        case 95:
            return 1166;
        // End:0x6A
        case 96:
            return 1167;
        // End:0x75
        case 97:
            return 1168;
        // End:0x80
        case 98:
            return 1169;
        // End:0x8B
        case 99:
            return 1170;
        // End:0x96
        case 100:
            return 1171;
        // End:0xA1
        case 101:
            return 1172;
        // End:0xAC
        case 102:
            return 1173;
        // End:0xB7
        case 103:
            return 1174;
        // End:0xC2
        case 104:
            return 1175;
        // End:0xCD
        case 105:
            return 1176;
        // End:0xD8
        case 106:
            return 1177;
        // End:0xE3
        case 107:
            return 1178;
        // End:0xEE
        case 108:
            return 1179;
        // End:0xF9
        case 109:
            return 1180;
        // End:0x104
        case 110:
            return 1181;
        // End:0x10F
        case 111:
            return 1182;
        // End:0x11A
        case 112:
            return 1183;
        // End:0x125
        case 113:
            return 1184;
        // End:0x130
        case 114:
            return 1185;
        // End:0x13B
        case 115:
            return 1186;
        // End:0x146
        case 116:
            return 1187;
        // End:0x151
        case 117:
            return 1188;
        // End:0x15C
        case 118:
            return 1189;
        // End:0x167
        case 131:
            return 1569;
        // End:0x172
        case 132:
            return 1570;
        // End:0x17D
        case 133:
            return 1571;
        // End:0x188
        case 134:
            return 1572;
        // End:0xFFFF
        default:
            // End:0x18E
            break;
            break;
    }
    return;
}

function array<int> getAutoEquipSlot(int Index)
{
    local array<int> bitTypes;

    switch(Index)
    {
        // End:0x18
        case 0:
            bitTypes[0] = 64;
            // End:0x7E
            break;
        // End:0x39
        case 1:
            bitTypes[0] = 1024;
            bitTypes[1] = 32768;
            // End:0x7E
            break;
        // End:0x4E
        case 2:
            bitTypes[0] = 2048;
            // End:0x7E
            break;
        // End:0x63
        case 3:
            bitTypes[0] = 512;
            // End:0x7E
            break;
        // End:0x78
        case 4:
            bitTypes[0] = 4096;
            // End:0x7E
            break;
        // End:0xFFFF
        default:
            // End:0x7E
            break;
            break;
    }
    return bitTypes;
    return;
}

function string convertDamageToString(int nDam)
{
    local float Value;
    local string suffix;

    // End:0x31
    if(nDam >= 1000000000)
    {
        Value = float(nDam) / 1000000000.0000000;
        suffix = "kkk";        
    }
    else
    {
        // End:0x61
        if(nDam >= 1000000)
        {
            Value = float(nDam) / 1000000.0000000;
            suffix = "kk";            
        }
        else
        {
            // End:0x90
            if(nDam >= 1000)
            {
                Value = float(nDam) / 1000.0000000;
                suffix = "k";                
            }
            else
            {
                return string(nDam);
            }
        }
    }
    return (CutFloatDecimalPlaces(Value, 1)) $ suffix;
    return;
}

function string CutFloatDecimalPlaces(float Probability, optional int decimalplaces)
{
    local string probStr, finalStr;

    probStr = string(Probability);
    finalStr = Left(probStr, Len(probStr) - 1);
    // End:0x4E
    if(Right(finalStr, 2) == ".0")
    {
        finalStr = Left(finalStr, Len(finalStr) - 2);
    }
    return finalStr;
    return;
}

function SendFake(coerce string EvID, coerce optional string ASK, coerce optional string Reply, coerce optional string P1, coerce optional string P2, coerce optional string p3, coerce optional string p4, coerce optional string p5, coerce optional string p6)
{
    local string strParam;

    ParamAdd(strParam, "EventID", EvID);
    ParamAdd(strParam, "ask", ASK);
    ParamAdd(strParam, "reply", Reply);
    ParamAdd(strParam, "Param1", P1);
    ParamAdd(strParam, "Param2", P2);
    ParamAdd(strParam, "Param3", p3);
    ParamAdd(strParam, "Param4", p4);
    ParamAdd(strParam, "Param5", p5);
    ParamAdd(strParam, "Param6", p6);
    ExecuteEvent(3550, strParam);
    return;
}

function ShowPage(string page)
{
    local NPCDialogWnd DialogWnd;

    DialogWnd = NPCDialogWnd(GetScript("NPCDialogWnd"));
    DialogWnd.m_hHtmlViewer.LoadHtml((("..\\" $ (getL2TextPath())) $ "\\") $ page);
    DialogWnd.ShowNPCDialogWnd();
    return;
}

function string getL2TextPath()
{
    switch(GetLanguage())
    {
        // End:0x0D
        case 9:
        // End:0x1B
        case 1:
            return "L2text";
        // End:0x2C
        case 8:
            return "L2text_ru";
        // End:0xFFFF
        default:
            return "L2text";
            break;
    }    
    return;
}

function string PackData(array<int> Data)
{
    local array<byte> ByteBuffer;
    local int i;

    i = 0;
    J0x07:

    // End:0x90 [Loop If]
    if(i < Data.Length)
    {
        // End:0x86
        if((Data[i] >= 0) && Data[i] <= 65535)
        {
            ByteBuffer[ByteBuffer.Length] = byte(int(byte(Data[i] >> 8)) & 255);
            ByteBuffer[ByteBuffer.Length] = byte(Data[i] & 255);
            // [Explicit Continue]
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return BytesToBase64(ByteBuffer);
    return;
}

function string BytesToBase64(array<byte> Bytes)
{
    local string Result;
    local int i, Length, Group;
    local array<byte> Base64Table;

    Base64Table.Length = 64;
    i = 0;
    J0x10:

    // End:0x58 [Loop If]
    if(i < 26)
    {
        Base64Table[i] = byte(65 + i);
        Base64Table[i + 26] = byte(97 + i);
        i++;
        // [Loop Continue]
        goto J0x10;
    }
    i = 0;
    J0x5F:

    // End:0x90 [Loop If]
    if(i < 10)
    {
        Base64Table[i + 52] = byte(48 + i);
        i++;
        // [Loop Continue]
        goto J0x5F;
    }
    Base64Table[62] = 43;
    Base64Table[63] = 47;
    Length = Bytes.Length;
    i = 0;
    J0xB9:

    // End:0x1FC [Loop If]
    if(i < Length)
    {
        Group = 0;
        // End:0xFC
        if(i < Length)
        {
            Group = (Group << 8) + int(Bytes[i]);
        }
        // End:0x12F
        if((i + 1) < Length)
        {
            Group = (Group << 8) + int(Bytes[i + 1]);
        }
        // End:0x164
        if((i + 2) < Length)
        {
            Group = (Group << 8) + int(Bytes[i + 2]);
        }
        Result = Result $ Chr(int(Base64Table[(Group >> 18) & 63]));
        Result = Result $ Chr(int(Base64Table[(Group >> 12) & 63]));
        Result = Result $ Chr(int(Base64Table[(Group >> 6) & 63]));
        Result = Result $ Chr(int(Base64Table[Group & 63]));
        i += 3;
        // [Loop Continue]
        goto J0xB9;
    }
    // End:0x232
    if((float(Length) % float(3)) == float(1))
    {
        Result = Left(Result, Len(Result) - 2) $ "==";        
    }
    else
    {
        // End:0x264
        if((float(Length) % float(3)) == float(2))
        {
            Result = Left(Result, Len(Result) - 1) $ "=";
        }
    }
    return Result;
    return;
}

function bool FirstTimeParam(string bLock, string param)
{
    local bool B;

    B = GetOptionBool(bLock, param);
    // End:0x35
    if(!B)
    {
        SetOptionBool(bLock, param, true);
        return false;
    }
    return;
}

function string GetClassRoleIconNameBig(int ClassID)
{
    local int degree;
    local UIEventManager.EClassRoleType rollType;

    rollType = GetClassRoleType(ClassID);
    degree = GetClassTransferDegree(ClassID);
    // End:0x3A
    if(int(rollType) == 9)
    {
        degree = 1;        
    }
    else
    {
        // End:0x4E
        if(degree > 4)
        {
            degree = 4;
        }
    }
    return ((("L2UI_CH3.PartyWnd.party_styleicon" $ string(degree)) $ "_") $ string(getRollIconNum(rollType))) $ "_Big";
    return;
}

function setCustomToolTipMinimumWidth(out CustomTooltip m_Tooltip)
{
    m_Tooltip.MinimumWidth = customToolTipGetMaxWidth(m_Tooltip);
    customToolTipLineWidthRefresh(m_Tooltip);
    return;
}

function int customToolTipGetMaxWidth(CustomTooltip m_Tooltip)
{
    local int i, Width, Height, MaxWidth, tmpWidth;

    MaxWidth = m_Tooltip.MinimumWidth;
    i = 0;
    J0x17:

    // End:0x1C7 [Loop If]
    if(i < m_Tooltip.DrawList.Length)
    {
        // End:0xD7
        if((int(m_Tooltip.DrawList[i].eType) == 1) || int(m_Tooltip.DrawList[i].eType) == 4)
        {
            // End:0xD4
            if(m_Tooltip.DrawList[i].t_bDrawOneLine)
            {
                GetTextSizeDefault(m_Tooltip.DrawList[i].t_strText, Width, Height);
                // End:0xD4
                if(!m_Tooltip.DrawList[i].bLineBreak)
                {
                    Width = Width + tmpWidth;
                }
            }            
        }
        else
        {
            // End:0x176
            if((int(m_Tooltip.DrawList[i].eType) == 2) || int(m_Tooltip.DrawList[i].eType) == 3)
            {
                // End:0x176
                if(m_Tooltip.DrawList[i].t_bDrawOneLine)
                {
                    Width = m_Tooltip.DrawList[i].u_nTextureWidth;
                    // End:0x176
                    if(!m_Tooltip.DrawList[i].bLineBreak)
                    {
                        Width = tmpWidth + Width;
                    }
                }
            }
        }
        Width = Width + m_Tooltip.DrawList[i].nOffSetX;
        // End:0x1B2
        if(Width > MaxWidth)
        {
            MaxWidth = Width;
        }
        tmpWidth = Width;
        i++;
        // [Loop Continue]
        goto J0x17;
    }
    return MaxWidth;
    return;
}

function customToolTipLineWidthRefresh(out CustomTooltip m_Tooltip)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x64 [Loop If]
    if(i < m_Tooltip.DrawList.Length)
    {
        // End:0x5A
        if(int(m_Tooltip.DrawList[i].eType) == 3)
        {
            m_Tooltip.DrawList[i].u_nTextureWidth = m_Tooltip.MinimumWidth;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function string makeZeroString(int StrLen, INT64 Num)
{
    local int i;
    local string sum;

    sum = (Num);
    i = 0;
    J0x14:

    // End:0x54 [Loop If]
    if(i < StrLen)
    {
        // End:0x3A
        if(Len(sum) >= StrLen)
        {
            // [Explicit Break]
            goto J0x54;
            // [Explicit Continue]
            goto J0x4A;
        }
        sum = "0" $ sum;
        J0x4A:

        i++;
        // [Loop Continue]
        goto J0x14;
    }
    J0x54:

    return sum;
    return;
}

function string CommandShorter(string Comma)
{
    local int i;
    local string returnComma;
    local array<string> commaWords;

    // End:0xBB
    if(Left(Comma, 1) == "/")
    {
        Split(Comma, " ", commaWords);
        commaWords[0] = SettingSectorStr("COMMAND_SHORTER", Right(commaWords[0], Len(commaWords[0]) - 1));
        // End:0xBB
        if(commaWords[0] != "")
        {
            returnComma = "/" $ commaWords[0];
            i = 1;
            J0x7E:

            // End:0xB5 [Loop If]
            if(i < commaWords.Length)
            {
                returnComma = (returnComma $ " ") $ commaWords[i];
                i++;
                // [Loop Continue]
                goto J0x7E;
            }
            return returnComma;
        }
    }
    return Comma;
    return;
}

static function bool GetItemInfoByClassID(int Id, out ItemInfo Info, optional bool bBigIcon)
{
    local ItemID cID;

    cID.ClassID = Id;
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cID, Info);
    // End:0x6B
    if(bBigIcon)
    {
        Info.Reserved = 778;
        Info.IconName = Locs(Info.IconName, "icon.", "IconBig.", true);
    }
    return Len(Info.IconName) > 0;
    return;
}

function setBigIcon(out ItemInfo item)
{
    item.Reserved = 778;
    item.IconName = Locs(item.IconName, "icon.", "IconBig.", true);
    return;
}

function CustomTooltip getItemTooltip(ItemInfo item)
{
    local CustomTooltip ToolTip;
    local string itemInfoParam;

    ItemInfoToParam(item, itemInfoParam);
    ParamAdd(itemInfoParam, "SourceType", string(1));
    ParamAdd(itemInfoParam, "TooltipType", "Inventory");
    ParamAdd(itemInfoParam, "IsCompareItem", string(0));
    ParamAdd(itemInfoParam, "UseSimpleTooltip", string(0));
    ParamAdd(itemInfoParam, "IsSelectMode", string(1));
    ToolTip = ToolTip(GetScript("Tooltip")).ReturnCustomTooltip_ITEM(itemInfoParam);
    return ToolTip;
    return;
}

function GetNextClass(int ClassID, out array<int> next_classes)
{
    next_classes.Length = 3;
    switch(ClassID)
    {
        // End:0x35
        case 0:
            next_classes[0] = 1;
            next_classes[1] = 4;
            next_classes[2] = 7;
            // End:0x5BB
            break;
        // End:0x50
        case 1:
            next_classes[0] = 2;
            next_classes[1] = 3;
            // End:0x5BB
            break;
        // End:0x6C
        case 4:
            next_classes[0] = 5;
            next_classes[1] = 6;
            // End:0x5BB
            break;
        // End:0x88
        case 7:
            next_classes[0] = 8;
            next_classes[1] = 9;
            // End:0x5BB
            break;
        // End:0x9A
        case 2:
            next_classes[0] = 88;
            // End:0x5BB
            break;
        // End:0xAC
        case 3:
            next_classes[0] = 89;
            // End:0x5BB
            break;
        // End:0xBE
        case 5:
            next_classes[0] = 90;
            // End:0x5BB
            break;
        // End:0xD0
        case 6:
            next_classes[0] = 91;
            // End:0x5BB
            break;
        // End:0xE2
        case 8:
            next_classes[0] = 93;
            // End:0x5BB
            break;
        // End:0xF4
        case 9:
            next_classes[0] = 92;
            // End:0x5BB
            break;
        // End:0x110
        case 10:
            next_classes[0] = 11;
            next_classes[1] = 15;
            // End:0x5BB
            break;
        // End:0x137
        case 11:
            next_classes[0] = 12;
            next_classes[1] = 13;
            next_classes[2] = 14;
            // End:0x5BB
            break;
        // End:0x153
        case 15:
            next_classes[0] = 16;
            next_classes[1] = 17;
            // End:0x5BB
            break;
        // End:0x165
        case 12:
            next_classes[0] = 94;
            // End:0x5BB
            break;
        // End:0x177
        case 13:
            next_classes[0] = 95;
            // End:0x5BB
            break;
        // End:0x189
        case 14:
            next_classes[0] = 96;
            // End:0x5BB
            break;
        // End:0x19B
        case 16:
            next_classes[0] = 97;
            // End:0x5BB
            break;
        // End:0x1AD
        case 17:
            next_classes[0] = 98;
            // End:0x5BB
            break;
        // End:0x1C9
        case 18:
            next_classes[0] = 19;
            next_classes[1] = 22;
            // End:0x5BB
            break;
        // End:0x1E5
        case 19:
            next_classes[0] = 20;
            next_classes[1] = 21;
            // End:0x5BB
            break;
        // End:0x201
        case 22:
            next_classes[0] = 23;
            next_classes[1] = 24;
            // End:0x5BB
            break;
        // End:0x213
        case 20:
            next_classes[0] = 99;
            // End:0x5BB
            break;
        // End:0x225
        case 21:
            next_classes[0] = 100;
            // End:0x5BB
            break;
        // End:0x237
        case 23:
            next_classes[0] = 101;
            // End:0x5BB
            break;
        // End:0x249
        case 24:
            next_classes[0] = 102;
            // End:0x5BB
            break;
        // End:0x265
        case 25:
            next_classes[0] = 26;
            next_classes[1] = 29;
            // End:0x5BB
            break;
        // End:0x281
        case 26:
            next_classes[0] = 27;
            next_classes[1] = 28;
            // End:0x5BB
            break;
        // End:0x293
        case 29:
            next_classes[0] = 30;
            // End:0x5BB
            break;
        // End:0x2A5
        case 27:
            next_classes[0] = 103;
            // End:0x5BB
            break;
        // End:0x2B7
        case 28:
            next_classes[0] = 104;
            // End:0x5BB
            break;
        // End:0x2C9
        case 30:
            next_classes[0] = 105;
            // End:0x5BB
            break;
        // End:0x2E5
        case 31:
            next_classes[0] = 32;
            next_classes[1] = 35;
            // End:0x5BB
            break;
        // End:0x301
        case 32:
            next_classes[0] = 33;
            next_classes[1] = 34;
            // End:0x5BB
            break;
        // End:0x31D
        case 35:
            next_classes[0] = 36;
            next_classes[1] = 37;
            // End:0x5BB
            break;
        // End:0x32F
        case 33:
            next_classes[0] = 106;
            // End:0x5BB
            break;
        // End:0x341
        case 34:
            next_classes[0] = 107;
            // End:0x5BB
            break;
        // End:0x353
        case 36:
            next_classes[0] = 108;
            // End:0x5BB
            break;
        // End:0x365
        case 37:
            next_classes[0] = 109;
            // End:0x5BB
            break;
        // End:0x381
        case 38:
            next_classes[0] = 39;
            next_classes[1] = 42;
            // End:0x5BB
            break;
        // End:0x39D
        case 39:
            next_classes[0] = 40;
            next_classes[1] = 41;
            // End:0x5BB
            break;
        // End:0x3AF
        case 42:
            next_classes[0] = 43;
            // End:0x5BB
            break;
        // End:0x3C1
        case 40:
            next_classes[0] = 110;
            // End:0x5BB
            break;
        // End:0x3D3
        case 41:
            next_classes[0] = 111;
            // End:0x5BB
            break;
        // End:0x3E5
        case 43:
            next_classes[0] = 112;
            // End:0x5BB
            break;
        // End:0x401
        case 44:
            next_classes[0] = 45;
            next_classes[1] = 47;
            // End:0x5BB
            break;
        // End:0x413
        case 45:
            next_classes[0] = 46;
            // End:0x5BB
            break;
        // End:0x425
        case 47:
            next_classes[0] = 48;
            // End:0x5BB
            break;
        // End:0x437
        case 46:
            next_classes[0] = 113;
            // End:0x5BB
            break;
        // End:0x449
        case 48:
            next_classes[0] = 114;
            // End:0x5BB
            break;
        // End:0x45B
        case 49:
            next_classes[0] = 50;
            // End:0x5BB
            break;
        // End:0x477
        case 50:
            next_classes[0] = 51;
            next_classes[1] = 52;
            // End:0x5BB
            break;
        // End:0x489
        case 51:
            next_classes[0] = 115;
            // End:0x5BB
            break;
        // End:0x49B
        case 52:
            next_classes[0] = 116;
            // End:0x5BB
            break;
        // End:0x4B7
        case 53:
            next_classes[0] = 54;
            next_classes[1] = 56;
            // End:0x5BB
            break;
        // End:0x4C9
        case 54:
            next_classes[0] = 55;
            // End:0x5BB
            break;
        // End:0x4DB
        case 56:
            next_classes[0] = 57;
            // End:0x5BB
            break;
        // End:0x4ED
        case 55:
            next_classes[0] = 117;
            // End:0x5BB
            break;
        // End:0x4FF
        case 57:
            next_classes[0] = 118;
            // End:0x5BB
            break;
        // End:0x511
        case 123:
            next_classes[0] = 125;
            // End:0x5BB
            break;
        // End:0x52D
        case 125:
            next_classes[0] = 127;
            next_classes[1] = 128;
            // End:0x5BB
            break;
        // End:0x53F
        case 127:
            next_classes[0] = 131;
            // End:0x5BB
            break;
        // End:0x551
        case 128:
            next_classes[0] = 132;
            // End:0x5BB
            break;
        // End:0x563
        case 124:
            next_classes[0] = 126;
            // End:0x5BB
            break;
        // End:0x57F
        case 126:
            next_classes[0] = 129;
            next_classes[1] = 130;
            // End:0x5BB
            break;
        // End:0x591
        case 130:
            next_classes[0] = 134;
            // End:0x5BB
            break;
        // End:0x5A3
        case 129:
            next_classes[0] = 133;
            // End:0x5BB
            break;
        // End:0x5B5
        case 135:
            next_classes[0] = 136;
            // End:0x5BB
            break;
        // End:0xFFFF
        default:
            // End:0x5BB
            break;
            break;
    }
    return;
}

function setEnchanted(int Enchant, out ItemInfo item)
{
    // End:0x69
    if(Enchant > 0)
    {
        item.Enchanted = Enchant;
        item.LookChangeIconPanel = "IconBig.icon_panel.enchant_panel_" $ getInstanceL2Util().makeZeroString(2, (item.Enchanted));
    }
    return;
}

function insertListText(out LVData Data, string Text, bool use_color, Color Color)
{
    Data.szData = Text;
    Data.bUseTextColor = use_color;
    Data.TextColor = Color;
    return;
}

function insertListTexture(out LVData Data, int W, int h, int UW, int UH, string Texture, int icon_pos, int line_offset, coerce string for_sorting)
{
    Data.hasIcon = true;
    Data.nTextureWidth = W;
    Data.nTextureHeight = h;
    Data.nTextureU = UW;
    Data.nTextureV = UH;
    Data.szTexture = Texture;
    Data.IconPosX = icon_pos;
    Data.FirstLineOffsetX = line_offset;
    Data.HiddenStringForSorting = for_sorting;
    return;
}

function insertListBackTexture(out LVData Data, int W, int h, int X, int Y, string Texture)
{
    Data.iconBackTexName = Texture;
    Data.backTexOffsetXFromIconPosX = X;
    Data.backTexOffsetYFromIconPosY = Y;
    Data.backTexWidth = W;
    Data.backTexHeight = h;
    Data.backTexUL = W;
    Data.backTexVL = h;
    return;
}

function ItemInfo getSkillToItemInfo(SkillInfo rSkilInfo)
{
    local ItemInfo infItem;

    infItem.Id.ClassID = rSkilInfo.SkillID;
    infItem.Level = rSkilInfo.SkillLevel;
    infItem.SubLevel = rSkilInfo.SkillSubLevel;
    infItem.Name = rSkilInfo.SkillName;
    infItem.IconName = rSkilInfo.TexName;
    infItem.IconPanel = rSkilInfo.IconPanel;
    infItem.Description = rSkilInfo.SkillDesc;
    infItem.ItemType = rSkilInfo.OperateType;
    return infItem;
    return;
}

function string GetCurrentEffectParam(StatusIconHandle Handle, optional StatusIconHandle subHandle)
{
    local string param;
    local StatusIconInfo Info;
    local AbnormalStatusWnd AbnormalStatusWnd;
    local int i, j, RowCount, ColCount, Index;

    param = "";
    Index = 0;
    AbnormalStatusWnd = AbnormalStatusWnd(GetScript("AbnormalStatusWnd"));
    RowCount = Handle.GetRowCount();
    i = 0;
    J0x4F:

    // End:0x232 [Loop If]
    if(i < RowCount)
    {
        ColCount = Handle.GetColCount(i);
        j = 0;
        J0x7F:

        // End:0x228 [Loop If]
        if(j < ColCount)
        {
            Handle.GetItem(i, j, Info);
            // End:0xCD
            if(Info.bEtcItem || Info.bShortItem)
            {
                // [Explicit Continue]
                goto J0x21E;
            }
            ParamAddItemIDWithIndex(param, Info.Id, Index);
            ParamAdd(param, "SkillLevel_" $ string(Index), string(Info.Level));
            ParamAdd(param, "SkillSubLevel_" $ string(Index), string(Info.SubLevel));
            ParamAdd(param, "RemainTime_" $ string(Index), string(Info.RemainTime));
            ParamAdd(param, "Name_" $ string(Index), Info.Name);
            ParamAdd(param, "IconName_" $ string(Index), Info.IconName);
            ParamAdd(param, "Description_" $ string(Index), Info.Description);
            ParamAdd(param, "SpellerID_" $ string(Index), string(Info.SpellerID));
            Index++;
            J0x21E:

            j++;
            // [Loop Continue]
            goto J0x7F;
        }
        i++;
        // [Loop Continue]
        goto J0x4F;
    }
    // End:0x43C
    if(subHandle != none)
    {
        RowCount = subHandle.GetRowCount();
        i = 0;
        J0x259:

        // End:0x43C [Loop If]
        if(i < RowCount)
        {
            ColCount = subHandle.GetColCount(i);
            j = 0;
            J0x289:

            // End:0x432 [Loop If]
            if(j < ColCount)
            {
                subHandle.GetItem(i, j, Info);
                // End:0x2D7
                if(Info.bEtcItem || Info.bShortItem)
                {
                    // [Explicit Continue]
                    goto J0x428;
                }
                ParamAddItemIDWithIndex(param, Info.Id, Index);
                ParamAdd(param, "SkillLevel_" $ string(Index), string(Info.Level));
                ParamAdd(param, "SkillSubLevel_" $ string(Index), string(Info.SubLevel));
                ParamAdd(param, "RemainTime_" $ string(Index), string(Info.RemainTime));
                ParamAdd(param, "Name_" $ string(Index), Info.Name);
                ParamAdd(param, "IconName_" $ string(Index), Info.IconName);
                ParamAdd(param, "Description_" $ string(Index), Info.Description);
                ParamAdd(param, "SpellerID_" $ string(Index), string(Info.SpellerID));
                Index++;
                J0x428:

                j++;
                // [Loop Continue]
                goto J0x289;
            }
            i++;
            // [Loop Continue]
            goto J0x259;
        }
    }
    ParamAdd(param, "Max", string(Index));
    return param;
    return;
}

function getLeaderControlTypeString(int nStatus, out string Desc, out Color Color)
{
    switch(nStatus)
    {
        // End:0x34
        case 0:
            Desc = GetSystemString(7963);
            Color = getInstanceL2Util().Gray;
            // End:0x95
            break;
        // End:0x61
        case 1:
            Desc = GetSystemString(7964);
            Color = getInstanceL2Util().ColorYellow;
            // End:0x95
            break;
        // End:0x8F
        case 2:
            Desc = GetSystemString(7965);
            Color = getInstanceL2Util().DRed;
            // End:0x95
            break;
        // End:0xFFFF
        default:
            // End:0x95
            break;
            break;
    }
    return;
}

function getLeaderControlTypeTexture(int nStatus, out string Tex)
{
    switch(nStatus)
    {
        // End:0x36
        case 0:
            Tex = "UI_BOHPTS.LeaderControl.noAffect";
            // End:0x9B
            break;
        // End:0x65
        case 1:
            Tex = "UI_BOHPTS.LeaderControl.accepted";
            // End:0x9B
            break;
        // End:0x95
        case 2:
            Tex = "UI_BOHPTS.LeaderControl.declined";
            // End:0x9B
            break;
        // End:0xFFFF
        default:
            // End:0x9B
            break;
            break;
    }
    return;
}

function Vector getHuntingCoord(string Name)
{
    local Vector loc;

    switch(Name)
    {
        // End:0x48
        case "DiTerr":
            loc.X = 0.0000000;
            loc.Y = 0.0000000;
            loc.Z = 0.0000000;
            return loc;
        // End:0x87
        case "Exec":
            loc.X = 50568.0000000;
            loc.Y = 152408.0000000;
            loc.Z = -2656.0000000;
            return loc;
        // End:0xCA
        case "Partisan":
            loc.X = 50081.0000000;
            loc.Y = 116859.0000000;
            loc.Z = -2176.0000000;
            return loc;
        // End:0x10B
        case "CrumaM":
            loc.X = 5106.0000000;
            loc.Y = 126916.0000000;
            loc.Z = -3664.0000000;
            return loc;
        // End:0x14B
        case "Cruma":
            loc.X = 17225.0000000;
            loc.Y = 114173.0000000;
            loc.Z = -3440.0000000;
            return loc;
        // End:0x18C
        case "Mandra":
            loc.X = 38291.0000000;
            loc.Y = 148029.0000000;
            loc.Z = -3696.0000000;
            return loc;
        // End:0x1CB
        case "Dion":
            loc.X = 15472.0000000;
            loc.Y = 142880.0000000;
            loc.Z = -2699.0000000;
            return loc;
        // End:0x20D
        case "FloranV":
            loc.X = 17308.0000000;
            loc.Y = 170368.0000000;
            loc.Z = -3495.0000000;
            return loc;
        // End:0x24D
        case "DionC":
            loc.X = 22310.0000000;
            loc.Y = 155917.0000000;
            loc.Z = -2952.0000000;
            return loc;
        // End:0x28D
        case "Tanor":
            loc.X = 58316.0000000;
            loc.Y = 163851.0000000;
            loc.Z = -2816.0000000;
            return loc;
        // End:0x2CB
        case "Bee":
            loc.X = 34475.0000000;
            loc.Y = 188095.0000000;
            loc.Z = -2976.0000000;
            return loc;
        // End:0x30F
        case "DionHills":
            loc.X = 29928.0000000;
            loc.Y = 151415.0000000;
            loc.Z = 2392.0000000;
            return loc;
        // End:0x354
        case "FloranFarm":
            loc.X = 10610.0000000;
            loc.Y = 156322.0000000;
            loc.Z = -2472.0000000;
            return loc;
        // End:0x399
        case "PlainsDion":
            loc.X = 630.0000000;
            loc.Y = 179184.0000000;
            loc.Z = -3720.0000000;
            return loc;
        // End:0x3DA
        case "Resist":
            loc.X = 43962.0000000;
            loc.Y = 108861.0000000;
            loc.Z = -2032.0000000;
            return loc;
        // End:0x41E
        case "GiranTerr":
            loc.X = 0.0000000;
            loc.Y = 0.0000000;
            loc.Z = 0.0000000;
            return loc;
        // End:0x45F
        case "Hardin":
            loc.X = 105918.0000000;
            loc.Y = 109759.0000000;
            loc.Z = -3170.0000000;
            return loc;
        // End:0x49C
        case "DV":
            loc.X = 73024.0000000;
            loc.Y = 118485.0000000;
            loc.Z = -3720.0000000;
            return loc;
        // End:0x4DB
        case "Anth":
            loc.X = 131557.0000000;
            loc.Y = 114509.0000000;
            loc.Z = -3712.0000000;
            return loc;
        // End:0x51E
        case "AnthNest":
            loc.X = 177160.0000000;
            loc.Y = 114922.0000000;
            loc.Z = -7704.0000000;
            return loc;
        // End:0x562
        case "DeathPass":
            loc.X = 67933.0000000;
            loc.Y = 117045.0000000;
            loc.Z = -3544.0000000;
            return loc;
        // End:0x5A6
        case "PirateTun":
            loc.X = 41528.0000000;
            loc.Y = 198358.0000000;
            loc.Z = -4648.0000000;
            return loc;
        // End:0x5EA
        case "DevilIsle":
            loc.X = 43408.0000000;
            loc.Y = 206881.0000000;
            loc.Z = -3752.0000000;
            return loc;
        // End:0x62B
        case "GiranH":
            loc.X = 47938.0000000;
            loc.Y = 186864.0000000;
            loc.Z = -3420.0000000;
            return loc;
        // End:0x66B
        case "Giran":
            loc.X = 83475.0000000;
            loc.Y = 147966.0000000;
            loc.Z = -3404.0000000;
            return loc;
        // End:0x6AC
        case "GiranA":
            loc.X = 73579.0000000;
            loc.Y = 142709.0000000;
            loc.Z = -3768.0000000;
            return loc;
        // End:0x6ED
        case "GiranC":
            loc.X = 112077.0000000;
            loc.Y = 144869.0000000;
            loc.Z = -2824.0000000;
            return loc;
        // End:0x72D
        case "Breka":
            loc.X = 85546.0000000;
            loc.Y = 131328.0000000;
            loc.Z = -3672.0000000;
            return loc;
        // End:0x76E
        case "Gorgon":
            loc.X = 113553.0000000;
            loc.Y = 134813.0000000;
            loc.Z = -3540.0000000;
            return loc;
        // End:0x7B0
        case "GluTerr":
            loc.X = 0.0000000;
            loc.Y = 0.0000000;
            loc.Z = 0.0000000;
            return loc;
        // End:0x7EE
        case "RoD":
            loc.X = -19120.0000000;
            loc.Y = 136816.0000000;
            loc.Z = -3762.0000000;
            return loc;
        // End:0x82C
        case "RoA":
            loc.X = -42628.0000000;
            loc.Y = 119766.0000000;
            loc.Z = -3528.0000000;
            return loc;
        // End:0x86C
        case "Waste":
            loc.X = -16526.0000000;
            loc.Y = 208032.0000000;
            loc.Z = -3664.0000000;
            return loc;
        // End:0x8AE
        case "AntNest":
            loc.X = -9959.0000000;
            loc.Y = 176184.0000000;
            loc.Z = -4160.0000000;
            return loc;
        // End:0x8EF
        case "Gludin":
            loc.X = -80684.0000000;
            loc.Y = 149770.0000000;
            loc.Z = -3043.0000000;
            return loc;
        // End:0x931
        case "GludinH":
            loc.X = -91101.0000000;
            loc.Y = 150344.0000000;
            loc.Z = -3624.0000000;
            return loc;
        // End:0x972
        case "Gludio":
            loc.X = -12787.0000000;
            loc.Y = 122779.0000000;
            loc.Z = -3114.0000000;
            return loc;
        // End:0x9B6
        case "AbandCamp":
            loc.X = -49853.0000000;
            loc.Y = 147089.0000000;
            loc.Z = -2784.0000000;
            return loc;
        // End:0x9F8
        case "OrcBarr":
            loc.X = -89763.0000000;
            loc.Y = 105359.0000000;
            loc.Z = -3576.0000000;
            return loc;
        // End:0xA3D
        case "ForgottenT":
            loc.X = -53001.0000000;
            loc.Y = 191425.0000000;
            loc.Z = -3568.0000000;
            return loc;
        // End:0xA80
        case "Fellmere":
            loc.X = -57798.0000000;
            loc.Y = 127629.0000000;
            loc.Z = -2928.0000000;
            return loc;
        // End:0xAC2
        case "GludinA":
            loc.X = -87328.0000000;
            loc.Y = 142266.0000000;
            loc.Z = -3640.0000000;
            return loc;
        // End:0xB04
        case "GludioC":
            loc.X = -18341.0000000;
            loc.Y = 113946.0000000;
            loc.Z = -1268.0000000;
            return loc;
        // End:0xB44
        case "Windy":
            loc.X = -88539.0000000;
            loc.Y = 83389.0000000;
            loc.Z = -2864.0000000;
            return loc;
        // End:0xB86
        case "RedRock":
            loc.X = -44829.0000000;
            loc.Y = 188171.0000000;
            loc.Z = -3256.0000000;
            return loc;
        // End:0xBC6
        case "Langk":
            loc.X = -44763.0000000;
            loc.Y = 203497.0000000;
            loc.Z = -3592.0000000;
            return loc;
        // End:0xC07
        case "Maille":
            loc.X = -25283.0000000;
            loc.Y = 106820.0000000;
            loc.Z = -3416.0000000;
            return loc;
        // End:0xC44
        case "TI":
            loc.X = -84141.0000000;
            loc.Y = 244623.0000000;
            loc.Z = -3729.0000000;
            return loc;
        // End:0xC82
        case "TIV":
            loc.X = -114358.0000000;
            loc.Y = 255884.0000000;
            loc.Z = -1512.0000000;
            return loc;
        // End:0xCC7
        case "FellmereHG":
            loc.X = -63736.0000000;
            loc.Y = 101522.0000000;
            loc.Z = -3552.0000000;
            return loc;
        // End:0xD0A
        case "Windmill":
            loc.X = -75437.0000000;
            loc.Y = 168800.0000000;
            loc.Z = -3632.0000000;
            return loc;
        // End:0xD4C
        case "RoABend":
            loc.X = -50174.0000000;
            loc.Y = 129303.0000000;
            loc.Z = -2912.0000000;
            return loc;
        // End:0xD8D
        case "EvilHG":
            loc.X = -6989.0000000;
            loc.Y = 109503.0000000;
            loc.Z = -3040.0000000;
            return loc;
        // End:0xDCF
        case "RoDEntr":
            loc.X = -36652.0000000;
            loc.Y = 135591.0000000;
            loc.Z = -3160.0000000;
            return loc;
        // End:0xE13
        case "Windawood":
            loc.X = -28327.0000000;
            loc.Y = 155125.0000000;
            loc.Z = -3496.0000000;
            return loc;
        // End:0xE55
        case "OlMahum":
            loc.X = -6661.0000000;
            loc.Y = 201880.0000000;
            loc.Z = -3632.0000000;
            return loc;
        // End:0xE96
        case "AntInc":
            loc.X = -26489.0000000;
            loc.Y = 195307.0000000;
            loc.Z = -3928.0000000;
            return loc;
        // End:0xED8
        case "Singing":
            loc.X = -111728.0000000;
            loc.Y = 244330.0000000;
            loc.Z = -3448.0000000;
            return loc;
        // End:0xF1A
        case "Neutral":
            loc.X = -10612.0000000;
            loc.Y = 75881.0000000;
            loc.Z = -3592.0000000;
            return loc;
        // End:0xF5D
        case "OrenTerr":
            loc.X = 0.0000000;
            loc.Y = 0.0000000;
            loc.Z = 0.0000000;
            return loc;
        // End:0xF9E
        case "ElvenF":
            loc.X = 21362.0000000;
            loc.Y = 51122.0000000;
            loc.Z = -3688.0000000;
            return loc;
        // End:0xFE3
        case "MotherTree":
            loc.X = 50953.0000000;
            loc.Y = 42105.0000000;
            loc.Z = -3480.0000000;
            return loc;
        // End:0x1020
        case "EV":
            loc.X = 46951.0000000;
            loc.Y = 51550.0000000;
            loc.Z = -2976.0000000;
            return loc;
        // End:0x1064
        case "ElvenFort":
            loc.X = 29294.0000000;
            loc.Y = 74968.0000000;
            loc.Z = -3776.0000000;
            return loc;
        // End:0x10A3
        case "Iris":
            loc.X = 51469.0000000;
            loc.Y = 82600.0000000;
            loc.Z = -3312.0000000;
            return loc;
        // End:0x10E3
        case "DarkF":
            loc.X = -22224.0000000;
            loc.Y = 14168.0000000;
            loc.Z = -3232.0000000;
            return loc;
        // End:0x1125
        case "ShilenT":
            loc.X = 25934.0000000;
            loc.Y = 11037.0000000;
            loc.Z = -3720.0000000;
            return loc;
        // End:0x1162
        case "DE":
            loc.X = 9709.0000000;
            loc.Y = 15566.0000000;
            loc.Z = -4500.0000000;
            return loc;
        // End:0x11A5
        case "DarkArts":
            loc.X = -47543.0000000;
            loc.Y = 58478.0000000;
            loc.Z = -3336.0000000;
            return loc;
        // End:0x11E5
        case "Swamp":
            loc.X = -21966.0000000;
            loc.Y = 40544.0000000;
            loc.Z = -3192.0000000;
            return loc;
        // End:0x1226
        case "AltarR":
            loc.X = -44566.0000000;
            loc.Y = 77508.0000000;
            loc.Z = -3736.0000000;
            return loc;
        // End:0x1267
        case "Spores":
            loc.X = 64328.0000000;
            loc.Y = 26803.0000000;
            loc.Z = -3768.0000000;
            return loc;
        // End:0x12AA
        case "BanditSH":
            loc.X = 87091.0000000;
            loc.Y = -20354.0000000;
            loc.Z = -2072.0000000;
            return loc;
        // End:0x12EA
        case "Ivory":
            loc.X = 85391.0000000;
            loc.Y = 16228.0000000;
            loc.Z = -3640.0000000;
            return loc;
        // End:0x1329
        case "Oren":
            loc.X = 82971.0000000;
            loc.Y = 53207.0000000;
            loc.Z = -1470.0000000;
            return loc;
        // End:0x1369
        case "OrenC":
            loc.X = 78189.0000000;
            loc.Y = 36936.0000000;
            loc.Z = -2560.0000000;
            return loc;
        // End:0x13AB
        case "LizardP":
            loc.X = 87252.0000000;
            loc.Y = 85514.0000000;
            loc.Z = -3103.0000000;
            return loc;
        // End:0x13EF
        case "Skyshadow":
            loc.X = 89914.0000000;
            loc.Y = 46276.0000000;
            loc.Z = -3616.0000000;
            return loc;
        // End:0x1431
        case "ShilenG":
            loc.X = 23863.0000000;
            loc.Y = 11068.0000000;
            loc.Z = -3720.0000000;
            return loc;
        // End:0x1475
        case "BlackRock":
            loc.X = -29466.0000000;
            loc.Y = 66678.0000000;
            loc.Z = -3496.0000000;
            return loc;
        // End:0x14B7
        case "SpiderN":
            loc.X = -61095.0000000;
            loc.Y = 75104.0000000;
            loc.Z = -3383.0000000;
            return loc;
        // End:0x14F7
        case "Timak":
            loc.X = 67097.0000000;
            loc.Y = 68815.0000000;
            loc.Z = -3648.0000000;
            return loc;
        // End:0x1537
        case "EvilF":
            loc.X = 93218.0000000;
            loc.Y = 16969.0000000;
            loc.Z = -3904.0000000;
            return loc;
        // End:0x1578
        case "Outlaw":
            loc.X = 91539.0000000;
            loc.Y = -12204.0000000;
            loc.Z = -2440.0000000;
            return loc;
        // End:0x15B8
        case "Misty":
            loc.X = 61740.0000000;
            loc.Y = 94946.0000000;
            loc.Z = -1488.0000000;
            return loc;
        // End:0x15FC
        case "Starlight":
            loc.X = 58502.0000000;
            loc.Y = 53453.0000000;
            loc.Z = -3624.0000000;
            return loc;
        // End:0x163D
        case "Undine":
            loc.X = -7233.0000000;
            loc.Y = 57006.0000000;
            loc.Z = -3520.0000000;
            return loc;
        // End:0x1681
        case "GodsFalls":
            loc.X = 70456.0000000;
            loc.Y = 6591.0000000;
            loc.Z = -3632.0000000;
            return loc;
        // End:0x16C4
        case "AdenTerr":
            loc.X = 0.0000000;
            loc.Y = 0.0000000;
            loc.Z = 0.0000000;
            return loc;
        // End:0x1702
        case "TOI":
            loc.X = 114649.0000000;
            loc.Y = 11115.0000000;
            loc.Z = -5120.0000000;
            return loc;
        // End:0x1744
        case "Blazing":
            loc.X = 155310.0000000;
            loc.Y = -16339.0000000;
            loc.Z = -3320.0000000;
            return loc;
        // End:0x1786
        case "DevastC":
            loc.X = 178358.0000000;
            loc.Y = -14192.0000000;
            loc.Z = -2256.0000000;
            return loc;
        // End:0x17CA
        case "Forbidden":
            loc.X = 188611.0000000;
            loc.Y = 20588.0000000;
            loc.Z = -3696.0000000;
            return loc;
        // End:0x180B
        case "GiantC":
            loc.X = 181737.0000000;
            loc.Y = 46469.0000000;
            loc.Z = -4276.0000000;
            return loc;
        // End:0x1850
        case "EnchValley":
            loc.X = 124904.0000000;
            loc.Y = 61992.0000000;
            loc.Z = -3973.0000000;
            return loc;
        // End:0x1893
        case "Cemetery":
            loc.X = 167047.0000000;
            loc.Y = 20304.0000000;
            loc.Z = -3328.0000000;
            return loc;
        // End:0x18D5
        case "Mirrors":
            loc.X = 142065.0000000;
            loc.Y = 81300.0000000;
            loc.Z = -3000.0000000;
            return loc;
        // End:0x1916
        case "Anghel":
            loc.X = 166182.0000000;
            loc.Y = 91560.0000000;
            loc.Z = -3168.0000000;
            return loc;
        // End:0x1955
        case "Aden":
            loc.X = 146783.0000000;
            loc.Y = 25808.0000000;
            loc.Z = -2000.0000000;
            return loc;
        // End:0x1992
        case "HV":
            loc.X = 117088.0000000;
            loc.Y = 76931.0000000;
            loc.Z = -2670.0000000;
            return loc;
        // End:0x19D5
        case "Coliseum":
            loc.X = 146440.0000000;
            loc.Y = 46723.0000000;
            loc.Z = -3400.0000000;
            return loc;
        // End:0x1A15
        case "AdenC":
            loc.X = 147461.0000000;
            loc.Y = 9898.0000000;
            loc.Z = -592.0000000;
            return loc;
        // End:0x1A59
        case "AncientBG":
            loc.X = 106517.0000000;
            loc.Y = -2871.0000000;
            loc.Z = -3454.0000000;
            return loc;
        // End:0x1A9C
        case "Forsaken":
            loc.X = 168217.0000000;
            loc.Y = 37990.0000000;
            loc.Z = -4072.0000000;
            return loc;
        // End:0x1ADE
        case "SilentV":
            loc.X = 170838.0000000;
            loc.Y = 55776.0000000;
            loc.Z = -5280.0000000;
            return loc;
        // End:0x1B21
        case "HuntersV":
            loc.X = 114306.0000000;
            loc.Y = 86573.0000000;
            loc.Z = -3112.0000000;
            return loc;
        // End:0x1B61
        case "Glory":
            loc.X = 135580.0000000;
            loc.Y = 19467.0000000;
            loc.Z = -3424.0000000;
            return loc;
        // End:0x1BA4
        case "Massacre":
            loc.X = 183543.0000000;
            loc.Y = -14974.0000000;
            loc.Z = -2768.0000000;
            return loc;
        // End:0x1BE6
        case "WarTorn":
            loc.X = 156898.0000000;
            loc.Y = 11217.0000000;
            loc.Z = -4032.0000000;
            return loc;
        // End:0x1C2D
        case "InnadrilTerr":
            loc.X = 0.0000000;
            loc.Y = 0.0000000;
            loc.Z = 0.0000000;
            return loc;
        // End:0x1C6F
        case "Silence":
            loc.X = 91088.0000000;
            loc.Y = 182384.0000000;
            loc.Z = -3192.0000000;
            return loc;
        // End:0x1CB2
        case "Whispers":
            loc.X = 74592.0000000;
            loc.Y = 207656.0000000;
            loc.Z = -3032.0000000;
            return loc;
        // End:0x1CF0
        case "Eva":
            loc.X = 84413.0000000;
            loc.Y = 234334.0000000;
            loc.Z = -3656.0000000;
            return loc;
        // End:0x1D35
        case "AlligatorI":
            loc.X = 115583.0000000;
            loc.Y = 192261.0000000;
            loc.Z = -3488.0000000;
            return loc;
        // End:0x1D75
        case "Heine":
            loc.X = 111455.0000000;
            loc.Y = 219400.0000000;
            loc.Z = -3546.0000000;
            return loc;
        // End:0x1DB9
        case "InnadrilC":
            loc.X = 115988.0000000;
            loc.Y = 246899.0000000;
            loc.Z = -976.0000000;
            return loc;
        // End:0x1DFE
        case "AlligatorB":
            loc.X = 116267.0000000;
            loc.Y = 201177.0000000;
            loc.Z = -3432.0000000;
            return loc;
        // End:0x1E3E
        case "DionA":
            loc.X = 12443.0000000;
            loc.Y = 183467.0000000;
            loc.Z = -3560.0000000;
            return loc;
        // End:0x1E80
        case "Paagrio":
            loc.X = -55699.0000000;
            loc.Y = -114967.0000000;
            loc.Z = 2528.0000000;
            return loc;
        // End:0x1EBF
        case "OrcV":
            loc.X = -45158.0000000;
            loc.Y = -112583.0000000;
            loc.Z = -236.0000000;
            return loc;
        // End:0x1F03
        case "ImmortalP":
            loc.X = -8830.0000000;
            loc.Y = -119289.0000000;
            loc.Z = 424.0000000;
            return loc;
        // End:0x1F47
        case "CaveTrial":
            loc.X = 9340.0000000;
            loc.Y = -112509.0000000;
            loc.Z = -2536.0000000;
            return loc;
        // End:0x1F8A
        case "FrozenWF":
            loc.X = 8652.0000000;
            loc.Y = -139941.0000000;
            loc.Z = -1144.0000000;
            return loc;
        // End:0x1FCC
        case "HeroesV":
            loc.X = -39347.0000000;
            loc.Y = -107274.0000000;
            loc.Z = -2072.0000000;
            return loc;
        // End:0x2010
        case "ImmortalN":
            loc.X = -10983.0000000;
            loc.Y = -117484.0000000;
            loc.Z = -2464.0000000;
            return loc;
        // End:0x2054
        case "ImmortalS":
            loc.X = -4190.0000000;
            loc.Y = -80040.0000000;
            loc.Z = -2696.0000000;
            return loc;
        // End:0x2099
        case "SchuttTerr":
            loc.X = 0.0000000;
            loc.Y = 0.0000000;
            loc.Z = 0.0000000;
            return loc;
        // End:0x20DC
        case "DwarvenV":
            loc.X = 115120.0000000;
            loc.Y = -178224.0000000;
            loc.Z = -917.0000000;
            return loc;
        // End:0x211F
        case "MithrilM":
            loc.X = 171946.0000000;
            loc.Y = -173352.0000000;
            loc.Z = 3440.0000000;
            return loc;
        // End:0x2162
        case "IceQueen":
            loc.X = 102728.0000000;
            loc.Y = -126242.0000000;
            loc.Z = -2840.0000000;
            return loc;
        // End:0x21A4
        case "SchuttC":
            loc.X = 77630.0000000;
            loc.Y = -150885.0000000;
            loc.Z = 368.0000000;
            return loc;
        // End:0x21E5
        case "Schutt":
            loc.X = 87056.0000000;
            loc.Y = -143472.0000000;
            loc.Z = -1296.0000000;
            return loc;
        // End:0x222A
        case "HotSprings":
            loc.X = 144880.0000000;
            loc.Y = -113468.0000000;
            loc.Z = -2560.0000000;
            return loc;
        // End:0x226C
        case "Goddard":
            loc.X = 148024.0000000;
            loc.Y = -55281.0000000;
            loc.Z = -2728.0000000;
            return loc;
        // End:0x22AF
        case "GoddardC":
            loc.X = 147450.0000000;
            loc.Y = -47331.0000000;
            loc.Z = -496.0000000;
            return loc;
        // End:0x22ED
        case "FOG":
            loc.X = 168902.0000000;
            loc.Y = -116703.0000000;
            loc.Z = -2417.0000000;
            return loc;
        // End:0x232F
        case "Valakas":
            loc.X = 215378.0000000;
            loc.Y = -116635.0000000;
            loc.Z = -1608.0000000;
            return loc;
        // End:0x2372
        case "KetraOut":
            loc.X = 146990.0000000;
            loc.Y = -67128.0000000;
            loc.Z = -3640.0000000;
            return loc;
        // End:0x23B5
        case "VarkaOut":
            loc.X = 125740.0000000;
            loc.Y = -40864.0000000;
            loc.Z = -3736.0000000;
            return loc;
        // End:0x23F4
        case "Rune":
            loc.X = 43835.0000000;
            loc.Y = -47749.0000000;
            loc.Z = -792.0000000;
            return loc;
        // End:0x2434
        case "RuneC":
            loc.X = 14659.0000000;
            loc.Y = -49230.0000000;
            loc.Z = -160.0000000;
            return loc;
        // End:0x2478
        case "BeastFarm":
            loc.X = 43805.0000000;
            loc.Y = -88010.0000000;
            loc.Z = -2780.0000000;
            return loc;
        // End:0x24BA
        case "Stakato":
            loc.X = 90134.0000000;
            loc.Y = -45130.0000000;
            loc.Z = -2168.0000000;
            return loc;
        // End:0x24FD
        case "Primeval":
            loc.X = 8480.0000000;
            loc.Y = -14624.0000000;
            loc.Z = -3693.0000000;
            return loc;
        // End:0x253F
        case "Sailren":
            loc.X = 26240.0000000;
            loc.Y = -7840.0000000;
            loc.Z = -1972.0000000;
            return loc;
        // End:0x257D
        case "IoP":
            loc.X = 149371.0000000;
            loc.Y = 184097.0000000;
            loc.Z = -3736.0000000;
            return loc;
        // End:0xFFFF
        default:
            // End:0x2583
            break;
            break;
    }
    return;
}

function LVDataRecord getLvTexture(Texture t, LVDataRecord rec, int i, int X, int Y, int W, int h, int U, int V)
{
    rec.LVDataList[0].arrTexture[i].objTex = t;
    rec.LVDataList[0].arrTexture[i].X = X;
    rec.LVDataList[0].arrTexture[i].Y = Y;
    rec.LVDataList[0].arrTexture[i].Width = W;
    rec.LVDataList[0].arrTexture[i].Height = h;
    rec.LVDataList[0].arrTexture[i].U = U;
    rec.LVDataList[0].arrTexture[i].V = V;
    return rec;
    return;
}

function string ToLowerByLanguage(string Text)
{
    switch(GetLanguage())
    {
        // End:0x19
        case 8:
            return RussianToLower(Text);
        // End:0x24
        case 0:
            return Text;
        // End:0xFFFF
        default:
            return ToLower(Text);
            break;
    }    
    return;
}

function string RussianToLower(string S)
{
    local string Result;
    local int i, CharCode;
    local string Char;

    i = 0;
    J0x07:

    // End:0xA4 [Loop If]
    if(i < Len(S))
    {
        Char = Mid(S, i, 1);
        CharCode = Asc(Char);
        // End:0x6C
        if((CharCode >= 1040) && CharCode <= 1071)
        {
            Char = Chr(CharCode + 32);            
        }
        else
        {
            // End:0x88
            if(CharCode == 1025)
            {
                Char = Chr(1105);
            }
        }
        Result = Result $ Char;
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return Result;
    return;
}

function fakeCC(optional bool B)
{
    local string param, partyLeaderName;
    local int i, j, memberCnt, specialID;
    local string Name;
    local UserInfo Player;

    GetWindowHandle("UnionWnd").ShowWindow();
    GetWindowHandle("UnionWnd").SetFocus();
    UnionWnd(GetScript("UnionWnd")).m_bChOpened = true;
    specialID = 9599;
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnBan");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnOut");
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnadenacalculate");
    // End:0xE7
    if(Rand(3) == 2)
    {
        Name = "WWWWWW";        
    }
    else
    {
        // End:0x107
        if(Rand(3) == 1)
        {
            Name = "WWWWWWWWWWW";            
        }
        else
        {
            // End:0x129
            if(Rand(3) == 0)
            {
                Name = "WWWWWWWWWWWWWWWW";
            }
        }
    }
    // End:0x150
    if(B)
    {
        GetPlayerInfo(Player);
        Name = Player.Name;        
    }
    else
    {
        Name = (((((Name $ ";") $ string(Rand(50))) $ ";") $ string(Rand(1000))) $ ";") $ string(Rand(1000));
    }
    ParamAdd(param, "OwnerName", Name);
    ParamAdd(param, "RoutingType", string(Rand(2)));
    ParamAdd(param, "PartyNum", "25");
    ParamAdd(param, "PartyMemberNum", "100");
    UnionWnd(GetScript("UnionWnd")).HandleCommandChannelInfo(param);
    i = 0;
    J0x225:

    // End:0x3A4 [Loop If]
    if(i < 25)
    {
        param = "";
        // End:0x273
        if(i == 0)
        {
            partyLeaderName = "CCLeader";
            ParamAdd(param, "MasterID", string(specialID));            
        }
        else
        {
            // End:0x2AC
            if((float(i) % float(2)) == float(0))
            {
                partyLeaderName = "LongLongName16ch" $ string(i);                
            }
            else
            {
                partyLeaderName = "PartyLeader" $ string(i);
            }
            ParamAdd(param, "MasterID", string(Rand(10000) + 1000));
        }
        ParamAdd(param, "MasterName", (((((((partyLeaderName $ ";") $ string(Rand(1000))) $ ";") $ string(Rand(1000))) $ ";") $ string(RandRange(15.0000000, 2000000.0000000))) $ ";") $ string(RandRange(15.0000000, 2000000.0000000)));
        ParamAdd(param, "PartyNum", string(Rand(9)));
        UnionWnd(GetScript("UnionWnd")).HandleCommandChannelPartyList(param);
        i++;
        // [Loop Continue]
        goto J0x225;
    }
    param = "";
    memberCnt = 9;
    ParamAdd(param, "MemberCount", string(memberCnt));
    i = 0;
    J0x3DA:

    // End:0x569 [Loop If]
    if(i < memberCnt)
    {
        ParamAdd(param, "ClassID_" $ string(i), string(RandRange(90.0000000, 115.0000000)));
        // End:0x469
        if(i == 0)
        {
            partyLeaderName = "PartyLeader" @ string(i);
            ParamAdd(param, "ServerID_" $ string(i), string(specialID));            
        }
        else
        {
            // End:0x4A2
            if((float(i) % float(2)) == float(0))
            {
                partyLeaderName = "LongLongName16ch" $ string(i);                
            }
            else
            {
                partyLeaderName = "PartyMember" @ string(i);
            }
            ParamAdd(param, "ServerID_" $ string(i), string(Rand(10000) + 10000));
        }
        ParamAdd(param, "Name_" $ string(i), (((((((partyLeaderName $ ";") $ string(Rand(1000))) $ ";") $ string(Rand(1000))) $ ";") $ string(RandRange(15.0000000, 2000000.0000000))) $ ";") $ string(RandRange(15.0000000, 2000000.0000000)));
        i++;
        // [Loop Continue]
        goto J0x3DA;
    }
    UnionDetailWnd(GetScript("UnionDetailWnd")).HandleCommandChannelPartyMember(param);
    SendFake(string(UnionWnd(GetScript("UnionWnd")).1030), string(0), string(0), "1;15;25", "", "", "", "", "");
    return;
}

function GetServerInfo()
{
    RequestBypassToServer("getTargetServerInfo");
    return;
}

function Color GetGearScoreTierColor(INT64 GearScore)
{
    local Color C;

    C.A = byte(255);
    // End:0x50
    if(__NFUN_411__(GearScore, (58000)))
    {
        C.R = byte(255);
        C.G = byte(224);
        C.B = byte(0);        
    }
    else
    {
        // End:0x92
        if(__NFUN_411__(GearScore, (51500)))
        {
            C.R = byte(255);
            C.G = byte(176);
            C.B = byte(30);            
        }
        else
        {
            // End:0xD4
            if(__NFUN_411__(GearScore, (46500)))
            {
                C.R = byte(255);
                C.G = byte(110);
                C.B = byte(18);                
            }
            else
            {
                // End:0x116
                if(__NFUN_411__(GearScore, (41500)))
                {
                    C.R = byte(224);
                    C.G = byte(30);
                    C.B = byte(43);                    
                }
                else
                {
                    // End:0x158
                    if(__NFUN_411__(GearScore, (36500)))
                    {
                        C.R = byte(255);
                        C.G = byte(107);
                        C.B = byte(87);                        
                    }
                    else
                    {
                        // End:0x19A
                        if(__NFUN_411__(GearScore, (32000)))
                        {
                            C.R = byte(192);
                            C.G = byte(24);
                            C.B = byte(96);                            
                        }
                        else
                        {
                            // End:0x1DC
                            if(__NFUN_411__(GearScore, (27500)))
                            {
                                C.R = byte(244);
                                C.G = byte(91);
                                C.B = byte(208);                                
                            }
                            else
                            {
                                // End:0x21E
                                if(__NFUN_411__(GearScore, (23500)))
                                {
                                    C.R = byte(178);
                                    C.G = byte(60);
                                    C.B = byte(240);                                    
                                }
                                else
                                {
                                    // End:0x260
                                    if(__NFUN_411__(GearScore, (19500)))
                                    {
                                        C.R = byte(74);
                                        C.G = byte(71);
                                        C.B = byte(230);                                        
                                    }
                                    else
                                    {
                                        // End:0x2A2
                                        if(__NFUN_411__(GearScore, (15500)))
                                        {
                                            C.R = byte(51);
                                            C.G = byte(166);
                                            C.B = byte(255);                                            
                                        }
                                        else
                                        {
                                            // End:0x2E4
                                            if(__NFUN_411__(GearScore, (12000)))
                                            {
                                                C.R = byte(6);
                                                C.G = byte(184);
                                                C.B = byte(158);                                                
                                            }
                                            else
                                            {
                                                // End:0x326
                                                if(__NFUN_411__(GearScore, (8500)))
                                                {
                                                    C.R = byte(91);
                                                    C.G = byte(217);
                                                    C.B = byte(46);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x368
                                                    if(__NFUN_411__(GearScore, (5500)))
                                                    {
                                                        C.R = byte(103);
                                                        C.G = byte(112);
                                                        C.B = byte(130);                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x3AA
                                                        if(__NFUN_411__(GearScore, (2500)))
                                                        {
                                                            C.R = byte(152);
                                                            C.G = byte(161);
                                                            C.B = byte(174);                                                            
                                                        }
                                                        else
                                                        {
                                                            C.R = byte(236);
                                                            C.G = byte(239);
                                                            C.B = byte(243);
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
    return C;
    return;
}
