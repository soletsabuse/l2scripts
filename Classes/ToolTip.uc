class ToolTip extends UICommonAPI;

const TOOLTIP_MINIMUM_WIDTH = 154;
const TOOLTIP_MINIMUM_SETITEM_WIDTH = 200;
const TOOLTIP_SETITEM_MAX = 3;
const TOOLTIP_LINE_HGAP = 6;
const ATTRIBUTE_FIRE = 0;
const ATTRIBUTE_WATER = 1;
const ATTRIBUTE_WIND = 2;
const ATTRIBUTE_EARTH = 3;
const ATTRIBUTE_HOLY = 4;
const ATTRIBUTE_UNHOLY = 5;
const MACROCOMMAND_MAX_COUNT = 12;

struct L2UIToolTip
{
    var UITooltip TooltipInfo;
};

var CustomTooltip m_Tooltip;
var DrawItemInfo m_Info;
var array<int> AttackAttLevel;
var array<int> AttackAttCurrValue;
var array<int> AttackAttMaxValue;
var array<int> DefAttLevel;
var array<int> DefAttCurrValue;
var array<int> DefAttMaxValue;
var int NowAttrLv;
var int NowMaxValue;
var int NowValue;
var bool BoolSelect;
var bool BSetItem;
var bool bLine;
var TextBoxHandle ItemCountText;
var L2Util util;

function OnRegisterEvent()
{
    RegisterEvent(2960);
    return;
}

function OnLoad()
{
    BoolSelect = true;
    BSetItem = false;
    util = L2Util(GetScript("L2Util"));
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 2960:
            HandleRequestTooltipInfo(param);
            // End:0x23
            break;
        // End:0xFFFF
        default:
            // End:0x23
            break;
            break;
    }
    return;
}

function setBoolSelect(bool B)
{
    BoolSelect = B;
    return;
}

function HandleRequestTooltipInfo(string param)
{
    local string TooltipType;
    local int SourceType;
    local UIEventManager.ETooltipSourceType eSourceType;

    ClearTooltip();
    // End:0x2A
    if(!ParseString(param, "TooltipType", TooltipType))
    {
        return;
    }
    // End:0x4D
    if(!ParseInt(param, "SourceType", SourceType))
    {
        return;
    }
    eSourceType = byte(SourceType);
    // End:0x7E
    if(TooltipType == "Text")
    {
        ReturnTooltip_NTT_TEXT(param, eSourceType, false);        
    }
    else
    {
        // End:0xA9
        if(TooltipType == "Description")
        {
            ReturnTooltip_NTT_TEXT(param, eSourceType, true);            
        }
        else
        {
            // End:0xD8
            if(TooltipType == "RankingClassInfo")
            {
                ReturnTooltip_NTT_RANKINGCLASSINFO(param, eSourceType);                
            }
            else
            {
                // End:0x10B
                if(TooltipType == "RankingCharacterInfo")
                {
                    ReturnTooltip_NTT_RANKINGCHARACTERINFO(param, eSourceType);                    
                }
                else
                {
                    // End:0x130
                    if(TooltipType == "Action")
                    {
                        ReturnTooltip_NTT_ACTION(param, eSourceType);                        
                    }
                    else
                    {
                        // End:0x154
                        if(TooltipType == "Macro")
                        {
                            ReturnTooltip_NTT_MACRO(param, eSourceType);                            
                        }
                        else
                        {
                            // End:0x178
                            if(TooltipType == "Skill")
                            {
                                ReturnTooltip_NTT_SKILL(param, eSourceType);                                
                            }
                            else
                            {
                                // End:0x1A1
                                if(TooltipType == "NormalItem")
                                {
                                    ReturnTooltip_NTT_NORMALITEM(param, eSourceType);                                    
                                }
                                else
                                {
                                    // End:0x1C9
                                    if(TooltipType == "HennaItem")
                                    {
                                        ReturnTooltip_NTT_HENNAITEM(param, eSourceType);                                        
                                    }
                                    else
                                    {
                                        // End:0x1EF
                                        if(TooltipType == "SetItem")
                                        {
                                            ReturnTooltip_NTT_SETITEM(param, eSourceType);                                            
                                        }
                                        else
                                        {
                                            // End:0x21F
                                            if(TooltipType == "PremiumNormalItem")
                                            {
                                                ReturnTooltip_NTT_PREMIUMNORMALITEM(param, eSourceType);                                                
                                            }
                                            else
                                            {
                                                // End:0x246
                                                if(TooltipType == "Shortcut")
                                                {
                                                    ReturnTooltip_NTT_SHORTCUT(param, eSourceType);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x273
                                                    if(TooltipType == "AbnormalStatus")
                                                    {
                                                        ReturnTooltip_NTT_ABNORMALSTATUS(param, eSourceType);                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x2A3
                                                        if(TooltipType == "RecipeManufacture")
                                                        {
                                                            ReturnTooltip_NTT_RECIPE_MANUFACTURE(param, eSourceType);                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x2C9
                                                            if(TooltipType == "Recipe")
                                                            {
                                                                ReturnTooltip_NTT_RECIPE(param, eSourceType, false);                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x2F4
                                                                if(TooltipType == "RecipePrice")
                                                                {
                                                                    ReturnTooltip_NTT_RECIPE(param, eSourceType, true);                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x466
                                                                    if(((((((((((TooltipType == "Inventory") || TooltipType == "InventoryPrice1") || TooltipType == "InventoryPrice2") || TooltipType == "InventoryPrice1HideEnchant") || TooltipType == "InventoryPrice1HideEnchantStackable") || TooltipType == "InventoryPrice2PrivateShop") || TooltipType == "InventoryWithIcon") || TooltipType == "InventoryPawnViewer") || TooltipType == "HtmlViewer") || TooltipType == "InventoryPet") || TooltipType == "EnsoulSlot")
                                                                    {
                                                                        ReturnTooltip_NTT_ITEM(param, TooltipType, eSourceType);                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x48D
                                                                        if(TooltipType == "RoomList")
                                                                        {
                                                                            ReturnTooltip_NTT_ROOMLIST(param, eSourceType);                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x4B4
                                                                            if(TooltipType == "UserList")
                                                                            {
                                                                                ReturnTooltip_NTT_USERLIST(param, eSourceType);                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x4DD
                                                                                if(TooltipType == "PartyMatch")
                                                                                {
                                                                                    ReturnTooltip_NTT_PARTYMATCH(param, eSourceType);                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    // End:0x505
                                                                                    if(TooltipType == "UnionList")
                                                                                    {
                                                                                        ReturnTooltip_NTT_UNIONLIST(param, eSourceType);                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        // End:0x52D
                                                                                        if(TooltipType == "QuestInfo")
                                                                                        {
                                                                                            ReturnTooltip_NTT_QUESTINFO(param, eSourceType);                                                                                            
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            // End:0x555
                                                                                            if(TooltipType == "QuestList")
                                                                                            {
                                                                                                ReturnTooltip_NTT_QUESTLIST(param, eSourceType);                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                // End:0x57C
                                                                                                if(TooltipType == "RaidList")
                                                                                                {
                                                                                                    ReturnTooltip_NTT_RAIDLIST(param, eSourceType);                                                                                                    
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    // End:0x5A3
                                                                                                    if(TooltipType == "ClanInfo")
                                                                                                    {
                                                                                                        ReturnTooltip_NTT_CLANINFO(param, eSourceType);                                                                                                        
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        // End:0x5CC
                                                                                                        if(TooltipType == "FriendInfo")
                                                                                                        {
                                                                                                            ReturnTooltip_NTT_FRIENDINFO(param, eSourceType);                                                                                                            
                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                            // End:0x5F6
                                                                                                            if(TooltipType == "ClanWarInfo")
                                                                                                            {
                                                                                                                ReturnTooltip_NTT_CLANWARINFO(param, eSourceType);                                                                                                                
                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                // End:0x621
                                                                                                                if(TooltipType == "SellItemList")
                                                                                                                {
                                                                                                                    ReturnTooltip_NTT_SellItemList(param, eSourceType);                                                                                                                    
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    // End:0x650
                                                                                                                    if(TooltipType == "EnsoulOptionType")
                                                                                                                    {
                                                                                                                        ReturnTooltip_NTT_EnsoulOptionList(param, eSourceType);                                                                                                                        
                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        // End:0x67F
                                                                                                                        if(TooltipType == "AgitDecoListType")
                                                                                                                        {
                                                                                                                            ReturnTooltip_NTT_AgitDecoList(param, eSourceType);                                                                                                                            
                                                                                                                        }
                                                                                                                        else
                                                                                                                        {
                                                                                                                            // End:0x6AF
                                                                                                                            if(TooltipType == "LeaderControlType")
                                                                                                                            {
                                                                                                                                ReturnTooltip_NTT_LeaderControlList(param, eSourceType);                                                                                                                                
                                                                                                                            }
                                                                                                                            else
                                                                                                                            {
                                                                                                                                // End:0x6DC
                                                                                                                                if(TooltipType == "CollectionItem")
                                                                                                                                {
                                                                                                                                    ReturnTooltip_NTT_CollectionItem(param, eSourceType);                                                                                                                                    
                                                                                                                                }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                    // End:0x703
                                                                                                                                    if(TooltipType == "PostInfo")
                                                                                                                                    {
                                                                                                                                        ReturnTooltip_NTT_POSTINFO(param, eSourceType);                                                                                                                                        
                                                                                                                                    }
                                                                                                                                    else
                                                                                                                                    {
                                                                                                                                        // End:0x7C4
                                                                                                                                        if((((((TooltipType == "ManorSeedInfo") || TooltipType == "ManorCropInfo") || TooltipType == "ManorSeedSetting") || TooltipType == "ManorCropSetting") || TooltipType == "ManorDefaultInfo") || TooltipType == "ManorCropSell")
                                                                                                                                        {
                                                                                                                                            ReturnTooltip_NTT_MANOR(param, TooltipType, eSourceType);                                                                                                                                            
                                                                                                                                        }
                                                                                                                                        else
                                                                                                                                        {
                                                                                                                                            // End:0x7EC
                                                                                                                                            if(TooltipType == "QuestItem")
                                                                                                                                            {
                                                                                                                                                ReturnTooltip_NTT_QUESTREWARDS(param, eSourceType);                                                                                                                                                
                                                                                                                                            }
                                                                                                                                            else
                                                                                                                                            {
                                                                                                                                                // End:0x816
                                                                                                                                                if(TooltipType == "GFxCardItem")
                                                                                                                                                {
                                                                                                                                                    ReturnTooltip_NTT_GFXCARD(param, eSourceType);                                                                                                                                                    
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                {
                                                                                                                                                    // End:0x841
                                                                                                                                                    if(TooltipType == "UserFakeInfo")
                                                                                                                                                    {
                                                                                                                                                        ReturnTooltip_NTT_CHAT_USERFAKEINFO(param, eSourceType);                                                                                                                                                        
                                                                                                                                                    }
                                                                                                                                                    else
                                                                                                                                                    {
                                                                                                                                                        // End:0x869
                                                                                                                                                        if(TooltipType == "LookChangeItem")
                                                                                                                                                        {
                                                                                                                                                            ReturnTooltip_NTT_LOOCKCHANGEITEM(param);                                                                                                                                                            
                                                                                                                                                        }
                                                                                                                                                        else
                                                                                                                                                        {
                                                                                                                                                            // End:0x8A5
                                                                                                                                                            if(TooltipType == "InventoryStackableUnitPrice")
                                                                                                                                                            {
                                                                                                                                                                ReturnTooltip_NTT_ITEM(param, TooltipType, 1);                                                                                                                                                                
                                                                                                                                                            }
                                                                                                                                                            else
                                                                                                                                                            {
                                                                                                                                                                // End:0x8CE
                                                                                                                                                                if(TooltipType == "RegionInfo")
                                                                                                                                                                {
                                                                                                                                                                    ReturnTooltip_NTT_MAP_REGIONINFO(param, eSourceType);                                                                                                                                                                    
                                                                                                                                                                }
                                                                                                                                                                else
                                                                                                                                                                {
                                                                                                                                                                    // End:0x8F8
                                                                                                                                                                    if(TooltipType == "GfxCustomTooltip")
                                                                                                                                                                    {
                                                                                                                                                                        ReturnTooltip_NTT_GFxTooltip(param);                                                                                                                                                                        
                                                                                                                                                                    }
                                                                                                                                                                    else
                                                                                                                                                                    {
                                                                                                                                                                        // End:0x921
                                                                                                                                                                        if(TooltipType == "privateShopHistory")
                                                                                                                                                                        {
                                                                                                                                                                            ReturnTooltip_NTT_PrivateShopHistory(param);
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

function ReturnTooltip_NTT_GFxTooltip(string param)
{
    local string Text;
    local int Count, i, R, G, B, A,
	    minWidth, W, h, UW, UH,
	    OffsetX, OffsetY, LineBreak, oneline, DrawItemType;

    ParseInt(param, "count", Count);
    ParseInt(param, "min", minWidth);
    m_Tooltip.MinimumWidth = minWidth;
    i = 0;
    J0x43:

    // End:0x37A [Loop If]
    if(i < Count)
    {
        ParseInt(param, "t_" $ string(i), DrawItemType);
        switch(byte(DrawItemType))
        {
            // End:0xAC
            case 0:
                ParseString(param, "txt_" $ string(i), Text);
                AddTooltipItemBlank(int(Text));
                // End:0x370
                break;
            // End:0x206
            case 1:
                ParseString(param, "txt_" $ string(i), Text);
                ParseInt(param, "R_" $ string(i), R);
                ParseInt(param, "G_" $ string(i), G);
                ParseInt(param, "B_" $ string(i), B);
                ParseInt(param, "A_" $ string(i), A);
                ParseInt(param, "oX_" $ string(i), OffsetX);
                ParseInt(param, "oY_" $ string(i), OffsetY);
                ParseInt(param, "lb_" $ string(i), LineBreak);
                ParseInt(param, "ol_" $ string(i), oneline);
                AddTooltipColorText(Text, GetColor(R, G, B, A), bool(LineBreak), bool(oneline), i == 0, "", OffsetX, OffsetY);
                // End:0x370
                break;
            // End:0x354
            case 2:
                ParseString(param, "textu_" $ string(i), Text);
                ParseInt(param, "w_" $ string(i), W);
                ParseInt(param, "h_" $ string(i), h);
                ParseInt(param, "uw_" $ string(i), UW);
                ParseInt(param, "uh_" $ string(i), UH);
                ParseInt(param, "oX_" $ string(i), OffsetX);
                ParseInt(param, "oY_" $ string(i), OffsetY);
                ParseInt(param, "lb_" $ string(i), LineBreak);
                ParseInt(param, "ol_" $ string(i), oneline);
                addTooltipTexture(Text, W, h, UW, UH, bool(LineBreak), bool(oneline), OffsetX, OffsetY);
                // End:0x370
                break;
            // End:0x362
            case 3:
                AddCrossLine();
                // End:0x370
                break;
            // End:0x36A
            case 4:
                // End:0x370
                break;
            // End:0xFFFF
            default:
                // End:0x370
                break;
                break;
        }
        i++;
        // [Loop Continue]
        goto J0x43;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_MAP_REGIONINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;
    local L2FactionUIData FactionData;
    local int nType, nID, nHuntingZoneType;
    local HuntingZoneUIData huntingZoneData;
    local string tmpStr, textStr, seedMessage, addStr, CastleName, OwnerClanName,
	    OwnerClanNameToolTip, NextSiegeTime, SiegeState, castleType, TaxRate,
	    DateTotal, agitName, OwnerClanMasterName, LocationName, TooltipString;

    local int Index, nActive, i, nFactionID, nFactionLevel;

    local RaidUIData pRaidUIData;
    local UIEventManager.ELanguageType Language;

    // End:0xDA6
    if(int(eSourceType) == 0)
    {
        ParseInt(param, "Type", nType);
        ParseInt(param, "Index", Index);
        ParseInt(param, "Active", nActive);
        ParseString(param, "Text", textStr);
        m_Tooltip.MinimumWidth = 154;
        // End:0x275
        if(nType == 0)
        {
            ParseString(param, "CastleName", CastleName);
            ParseString(param, "OwnerClanNameToolTip", OwnerClanNameToolTip);
            ParseString(param, "OwnerClanName", OwnerClanName);
            ParseString(param, "NextSiegeTime", NextSiegeTime);
            ParseString(param, "SiegeState", SiegeState);
            ParseString(param, "CastleType", castleType);
            ParseString(param, "TaxRate", TaxRate);
            AddTooltipColorText(CastleName, getInstanceL2Util().White, false, false, true);
            // End:0x1A2
            if(castleType != "")
            {
                AddTooltipColorText((" (" $ castleType) $ ")", getInstanceL2Util().ColorLightBrown, false, false, true);
            }
            AddCrossLine();
            AddTooltipColorText((GetSystemString(1607) $ " : ") $ OwnerClanName, getInstanceL2Util().ColorYellow, true, true, false);
            AddTooltipColorText((GetSystemString(1612) $ " : ") $ SiegeState, getInstanceL2Util().ColorYellow, true, true, false);
            AddTooltipColorText((GetSystemString(1608) $ " : ") $ TaxRate, getInstanceL2Util().ColorYellow, true, true, false);
            AddTooltipColorText((GetSystemString(1609) $ " : ") $ NextSiegeTime, getInstanceL2Util().ColorYellow, true, true, false);
            setTooltipMinimumWidth();            
        }
        else
        {
            // End:0x3FA
            if(nType == 1)
            {
                ParseString(param, "CastleName", CastleName);
                ParseString(param, "OwnerClanName", OwnerClanName);
                ParseString(param, "SiegeState", SiegeState);
                ParseString(param, "DateTotal", DateTotal);
                ParseString(param, "LocationName", LocationName);
                AddTooltipColorText((CastleName $ " | ") $ MakeFullSystemMsg(GetSystemMessage(4436), LocationName), getInstanceL2Util().White, true, true, true);
                AddCrossLine();
                AddTooltipColorText((GetSystemString(1607) $ " : ") $ OwnerClanName, getInstanceL2Util().ColorYellow, true, true, false);
                AddTooltipColorText((GetSystemString(1612) $ " : ") $ SiegeState, getInstanceL2Util().ColorYellow, true, true, false);
                // End:0x3F1
                if(DateTotal != "")
                {
                    AddTooltipColorText((GetSystemString(1615) $ " : ") $ DateTotal, getInstanceL2Util().ColorYellow, true, true, false);
                }
                setTooltipMinimumWidth();                
            }
            else
            {
                // End:0x5B1
                if(nType == 2)
                {
                    ParseString(param, "AgitName", agitName);
                    ParseString(param, "OwnerClanName", OwnerClanName);
                    ParseString(param, "OwnerClanMasterName", OwnerClanMasterName);
                    ParseString(param, "NextSiegeTime", NextSiegeTime);
                    ParseString(param, "LocationName", LocationName);
                    AddTooltipColorText((agitName $ " | ") $ MakeFullSystemMsg(GetSystemMessage(4436), LocationName), getInstanceL2Util().White, true, true, true);
                    AddCrossLine();
                    // End:0x4FD
                    if(OwnerClanName == "")
                    {
                        OwnerClanName = GetSystemString(27);
                    }
                    AddTooltipColorText((GetSystemString(1607) $ " : ") $ OwnerClanName, getInstanceL2Util().ColorYellow, true, true, false);
                    // End:0x56B
                    if(OwnerClanMasterName != "")
                    {
                        AddTooltipColorText((GetSystemString(342) $ " : ") $ OwnerClanMasterName, getInstanceL2Util().ColorYellow, true, true, false);
                    }
                    // End:0x5A8
                    if(NextSiegeTime != "")
                    {
                        AddTooltipColorText((GetSystemString(3545) $ " : ") $ NextSiegeTime, getInstanceL2Util().ColorYellow, true, true, false);
                    }
                    setTooltipMinimumWidth();                    
                }
                else
                {
                    // End:0x739
                    if((nType == 3) || nType == 5)
                    {
                        ParseString(param, "SeedMessage", seedMessage);
                        Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(Index, huntingZoneData);
                        tmpStr = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(huntingZoneData.nSearchZoneID);
                        AddTooltipColorText((huntingZoneData.strName $ " | ") $ tmpStr, getInstanceL2Util().White, true, true, true);
                        AddCrossLine();
                        // End:0x67D
                        if(seedMessage != "")
                        {
                            AddTooltipColorText(seedMessage, GetColor(255, 204, 0, 255), true, true, false);
                        }
                        // End:0x6E8
                        if((huntingZoneData.nMinLevel != 0) && huntingZoneData.nMaxLevel != 0)
                        {
                            AddTooltipColorText((((GetSystemString(922) $ " : ") $ string(huntingZoneData.nMinLevel)) $ "~") $ string(huntingZoneData.nMaxLevel), GetColor(255, 204, 0, 255), true, true, false);
                        }
                        nHuntingZoneType = huntingZoneData.nType;
                        tmpStr = getHuntingZoneTypeString(nHuntingZoneType);
                        // End:0x730
                        if(tmpStr != "")
                        {
                            AddTooltipColorText(tmpStr, GetColor(255, 204, 0, 255), true, true, false);
                        }
                        setTooltipMinimumWidth();                        
                    }
                    else
                    {
                        // End:0x92F
                        if(nType == 4)
                        {
                            ParseInt(param, "nFactionID", nFactionID);
                            ParseInt(param, "nFactionLevel", nFactionLevel);
                            GetFactionData(nFactionID, FactionData);
                            AddTooltipColorText(FactionData.strFactionName, getInstanceL2Util().White, true, true, true);
                            AddCrossLine();
                            Language = GetLanguage();
                            // End:0x837
                            if(((int(Language) == 8) || int(Language) == 9) || int(Language) == 1)
                            {
                                AddTooltipColorText((((GetSystemString(3521) $ " : ") $ GetSystemString(1328)) $ " ") $ string(nFactionLevel), GetColor(255, 204, 0, 255), true, true, false);                                
                            }
                            else
                            {
                                AddTooltipColorText(((GetSystemString(3521) $ " : ") $ string(nFactionLevel)) $ GetSystemString(1328), GetColor(255, 204, 0, 255), true, true, false);
                            }
                            // End:0x92C
                            if(FactionData.arrFactionAreaName.Length > 0)
                            {
                                AddTooltipColorText(GetSystemString(3449) $ " : ", GetColor(255, 204, 0, 255), true, true, false);
                                i = 0;
                                J0x8B5:

                                // End:0x92C [Loop If]
                                if(i < FactionData.arrFactionAreaName.Length)
                                {
                                    AddTooltipColorText(FactionData.arrFactionAreaName[i], GetColor(255, 204, 0, 255), false, true, false);
                                    // End:0x922
                                    if(i < (FactionData.arrFactionAreaName.Length - 1))
                                    {
                                        AddTooltipColorText(", ", GetColor(255, 204, 0, 255), false, true, false);
                                    }
                                    i++;
                                    // [Loop Continue]
                                    goto J0x8B5;
                                }
                            }                            
                        }
                        else
                        {
                            // End:0xAB0
                            if(nType == 7)
                            {
                                pRaidUIData = getRaidDataByIndex(Index);
                                AddTooltipColorText((pRaidUIData.raidMonsterName $ " | ") $ pRaidUIData.RaidMonsterZoneName, getInstanceL2Util().White, true, true, true);
                                AddCrossLine();
                                Language = GetLanguage();
                                // End:0xA08
                                if(((int(Language) == 8) || int(Language) == 9) || int(Language) == 1)
                                {
                                    AddTooltipColorText(MakeFullSystemMsg(GetSystemMessage(4425), (GetSystemString(537) $ " ") $ string(pRaidUIData.nRaidMonsterLevel)), GetColor(255, 204, 0, 255), true, true, false);                                    
                                }
                                else
                                {
                                    AddTooltipColorText(MakeFullSystemMsg(GetSystemMessage(4425), string(pRaidUIData.nRaidMonsterLevel) $ GetSystemString(537)), GetColor(255, 204, 0, 255), true, true, false);
                                }
                                // End:0xA67
                                if(nActive > 0)
                                {
                                    tmpStr = GetSystemString(3525);                                    
                                }
                                else
                                {
                                    tmpStr = GetSystemString(3526);
                                }
                                AddTooltipColorText((GetSystemString(3524) $ " : ") $ tmpStr, GetColor(255, 204, 0, 255), true, true, false);
                                setTooltipMinimumWidth();                                
                            }
                            else
                            {
                                // End:0xD4D
                                if(nType == 6)
                                {
                                    ParseInt(param, "Active", nActive);
                                    Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneData(Index, huntingZoneData);
                                    tmpStr = Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingZoneName(huntingZoneData.nSearchZoneID);
                                    AddTooltipColorText((huntingZoneData.strName $ " | ") $ tmpStr, getInstanceL2Util().White, true, true, true);
                                    AddCrossLine();
                                    nHuntingZoneType = huntingZoneData.nType;
                                    tmpStr = getHuntingZoneTypeString(nHuntingZoneType);
                                    // End:0xB8A
                                    if(tmpStr != "")
                                    {
                                        AddTooltipColorText(tmpStr, GetColor(255, 204, 0, 255), true, true, false);
                                    }
                                    // End:0xBF5
                                    if((huntingZoneData.nMinLevel != 0) && huntingZoneData.nMaxLevel != 0)
                                    {
                                        AddTooltipColorText((((GetSystemString(922) $ " : ") $ string(huntingZoneData.nMinLevel)) $ "~") $ string(huntingZoneData.nMaxLevel), GetColor(255, 204, 0, 255), true, true, false);
                                    }
                                    AddTooltipColorText((GetSystemString(3522) $ " : ") $ Class'NWindow.UIDATA_HUNTINGZONE'.static.GetHuntingDescription(Index), GetColor(255, 204, 0, 255), true, true, false);
                                    // End:0xD04
                                    if(huntingZoneData.arrQuestIDs.Length > 0)
                                    {
                                        AddTooltipColorText(GetSystemString(3523) $ " : ", GetColor(255, 204, 0, 255), true, true, false);
                                        i = 0;
                                        J0xC73:

                                        // End:0xD04 [Loop If]
                                        if(i < huntingZoneData.arrQuestIDs.Length)
                                        {
                                            addStr = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(huntingZoneData.arrQuestIDs[i]);
                                            AddTooltipColorText(addStr, GetColor(255, 204, 0, 255), false, true, false);
                                            // End:0xCFA
                                            if(i < (huntingZoneData.arrQuestIDs.Length - 1))
                                            {
                                                AddTooltipColorText(", ", GetColor(255, 204, 0, 255), false, true, false);
                                            }
                                            i++;
                                            // [Loop Continue]
                                            goto J0xC73;
                                        }
                                    }
                                    // End:0xD44
                                    if(nActive <= 0)
                                    {
                                        AddTooltipColorText((GetSystemString(3524) $ " : ") $ GetSystemString(5099), GetColor(255, 204, 0, 255), true, true, false);
                                    }
                                    setTooltipMinimumWidth();                                    
                                }
                                else
                                {
                                    // End:0xDA3
                                    if(nType == 8)
                                    {
                                        m_Tooltip.MinimumWidth = 154 / 4;
                                        ParseString(param, "tooltipString", TooltipString);
                                        // End:0xDA3
                                        if(TooltipString != "")
                                        {
                                            AddTooltipText(TooltipString, false, true, true);
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
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function string StripPackedNameSuffix(string S)
{
    local int semiPos, i, N;
    local string suffix, C;

    semiPos = InStr(S, ";");
    // End:0x25
    if(semiPos == -1)
    {
        return S;
    }
    // End:0x46
    if(InStr(Left(S, semiPos), " ") != -1)
    {
        return S;
    }
    suffix = Mid(S, semiPos + 1);
    N = Len(suffix);
    // End:0x79
    if(N == 0)
    {
        return S;
    }
    i = 0;
    J0x80:

    // End:0xDD [Loop If]
    if(i < N)
    {
        C = Mid(suffix, i, 1);
        // End:0xD3
        if((C != ";") && (C < "0") || C > "9")
        {
            return S;
        }
        i++;
        // [Loop Continue]
        goto J0x80;
    }
    return Left(S, semiPos);
    return;
}

function ReturnTooltip_NTT_TEXT(string param, UIEventManager.ETooltipSourceType eSourceType, bool bDesc)
{
    local string strText;
    local int Id;

    // End:0x164
    if(int(eSourceType) == 0)
    {
        // End:0x109
        if(ParseString(param, "Text", strText))
        {
            strText = StripPackedNameSuffix(strText);
            // End:0x106
            if(Len(strText) > 0)
            {
                // End:0xD0
                if(bDesc)
                {
                    m_Tooltip.MinimumWidth = 154;
                    StartItem();
                    m_Info.eType = 1;
                    m_Info.t_color.R = 178;
                    m_Info.t_color.G = 190;
                    m_Info.t_color.B = 207;
                    m_Info.t_color.A = byte(255);
                    m_Info.t_strText = strText;
                    EndItem();                    
                }
                else
                {
                    StartItem();
                    m_Info.eType = 1;
                    m_Info.t_bDrawOneLine = true;
                    m_Info.t_strText = strText;
                    EndItem();
                }
            }            
        }
        else
        {
            // End:0x161
            if(ParseInt(param, "ID", Id))
            {
                // End:0x161
                if(Id > 0)
                {
                    StartItem();
                    m_Info.eType = 1;
                    m_Info.t_bDrawOneLine = true;
                    m_Info.t_ID = Id;
                    EndItem();
                }
            }
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function CustomTooltip ReturnCustomTooltip_ITEM(string param)
{
    local CustomTooltip resultTooltip;

    ClearTooltip();
    ReturnTooltip_NTT_ITEM(param, "Inventory", 1);
    resultTooltip = m_Tooltip;
    ClearTooltip();
    return resultTooltip;
    return;
}

function bool addItemIcon(ItemInfo item, string ForeTexture)
{
    // End:0x13
    if(item.IconName == "")
    {
        return false;
    }
    StartItem();
    m_Info.eType = 2;
    m_Info.u_nTextureWidth = 34;
    m_Info.u_nTextureHeight = 34;
    m_Info.u_nTextureUWidth = 34;
    m_Info.u_nTextureUHeight = 34;
    m_Info.u_strTexture = "l2ui_ct1.ItemWindow_DF_SlotBox_Default";
    EndItem();
    StartItem();
    // End:0x10D
    if(item.Reserved != 778)
    {
        m_Info.eType = 2;
        m_Info.u_nTextureWidth = 32;
        m_Info.u_nTextureHeight = 32;
        m_Info.u_nTextureUWidth = 32;
        m_Info.u_nTextureUHeight = 32;
        m_Info.nOffSetX = -33;
        m_Info.nOffSetY = 1;        
    }
    else
    {
        m_Info.eType = 2;
        m_Info.u_nTextureWidth = 32;
        m_Info.u_nTextureHeight = 32;
        m_Info.u_nTextureUWidth = 64;
        m_Info.u_nTextureUHeight = 64;
        m_Info.nOffSetX = -33;
        m_Info.nOffSetY = 1;
    }
    m_Info.u_strTexture = item.IconName;
    EndItem();
    StartItem();
    // End:0x21E
    if(item.IconPanel == "IconBig.icon_panel.craft_panel_i00")
    {
        m_Info.eType = 2;
        m_Info.u_nTextureWidth = 32;
        m_Info.u_nTextureHeight = 32;
        m_Info.u_nTextureUWidth = 64;
        m_Info.u_nTextureUHeight = 64;
        m_Info.nOffSetX = -32;
        m_Info.nOffSetY = 1;        
    }
    else
    {
        m_Info.eType = 2;
        m_Info.u_nTextureWidth = 32;
        m_Info.u_nTextureHeight = 32;
        m_Info.u_nTextureUWidth = 32;
        m_Info.u_nTextureUHeight = 32;
        m_Info.nOffSetX = -32;
        m_Info.nOffSetY = 1;
    }
    m_Info.u_strTexture = item.IconPanel;
    EndItem();
    // End:0x331
    if((ForeTexture != "") && item.Reserved != 777)
    {
        StartItem();
        m_Info.eType = 2;
        m_Info.u_nTextureWidth = 32;
        m_Info.u_nTextureHeight = 32;
        m_Info.u_nTextureUWidth = 32;
        m_Info.u_nTextureUHeight = 32;
        m_Info.nOffSetX = -32;
        m_Info.nOffSetY = 1;
        m_Info.u_strTexture = ForeTexture;
        EndItem();
    }
    // End:0x3D3
    if(item.bSecurityLock)
    {
        StartItem();
        m_Info.eType = 2;
        m_Info.u_nTextureWidth = 32;
        m_Info.u_nTextureHeight = 32;
        m_Info.u_nTextureUWidth = 32;
        m_Info.u_nTextureUHeight = 32;
        m_Info.nOffSetX = -32;
        m_Info.nOffSetY = 1;
        m_Info.u_strTexture = "Icon.Icon_panel.ItemLock_Panel";
        EndItem();
    }
    return true;
    return;
}

function addItemIconSmallType(ItemInfo item, string ForeTexture)
{
    StartItem();
    m_Info.eType = 2;
    m_Info.u_nTextureWidth = 16;
    m_Info.u_nTextureHeight = 16;
    m_Info.u_nTextureUWidth = 32;
    m_Info.u_nTextureUHeight = 32;
    m_Info.nOffSetX = 4;
    m_Info.nOffSetY = 2;
    m_Info.u_strTexture = item.IconName;
    EndItem();
    StartItem();
    m_Info.eType = 2;
    m_Info.u_nTextureWidth = 16;
    m_Info.u_nTextureHeight = 16;
    m_Info.u_nTextureUWidth = 32;
    m_Info.u_nTextureUHeight = 32;
    m_Info.nOffSetX = -16;
    m_Info.nOffSetY = 2;
    m_Info.u_strTexture = item.IconPanel;
    EndItem();
    // End:0x181
    if(ForeTexture != "")
    {
        StartItem();
        m_Info.eType = 2;
        m_Info.u_nTextureWidth = 14;
        m_Info.u_nTextureHeight = 14;
        m_Info.u_nTextureUWidth = 32;
        m_Info.u_nTextureUHeight = 32;
        m_Info.nOffSetX = -20;
        m_Info.nOffSetY = 2;
        m_Info.u_strTexture = ForeTexture;
        EndItem();
    }
    return;
}

function addTexture(string IconName, int u_nTextureWidth, int u_nTextureHeight, int u_nTextureUWidth, int u_nTextureUHeight, optional int nOffSetX, optional int nOffSetY)
{
    StartItem();
    m_Info.eType = 2;
    m_Info.u_nTextureWidth = u_nTextureWidth;
    m_Info.u_nTextureHeight = u_nTextureHeight;
    m_Info.u_nTextureUWidth = u_nTextureUWidth;
    m_Info.u_nTextureUHeight = u_nTextureUHeight;
    m_Info.nOffSetX = nOffSetX;
    m_Info.nOffSetY = nOffSetY;
    m_Info.u_strTexture = IconName;
    EndItem();
    return;
}

function string getSlotTypeWithItemTypeString(ItemInfo item)
{
    local string SlotString, strTmp;
    local UIEventManager.EItemType EItemType;

    EItemType = byte(item.ItemType);
    SlotString = GetSlotTypeString(item.ItemType, item.SlotBitType, item.ArmorType);
    // End:0x85
    if(int(EItemType) == 0)
    {
        strTmp = GetWeaponTypeString(item.WeaponType);
        // End:0x85
        if(Len(strTmp) > 0)
        {
            SlotString = (strTmp $ " / ") $ SlotString;
        }
    }
    return SlotString;
    return;
}

function addTooltipTextureSplitLineType(string Texture, int Width, int Height, int uWidth, int uHeight, optional int OffsetX, optional int OffsetY)
{
    StartItem();
    m_Info.eType = 3;
    m_Info.t_bDrawOneLine = true;
    m_Info.bLineBreak = false;
    m_Info.u_nTextureWidth = Width;
    m_Info.u_nTextureHeight = Height;
    m_Info.nOffSetX = OffsetX;
    m_Info.nOffSetY = OffsetY;
    m_Info.u_nTextureUWidth = uWidth;
    m_Info.u_nTextureUHeight = uHeight;
    m_Info.u_strTexture = Texture;
    EndItem();
    return;
}

function AddTitleIconWithHeadLine(string Icontex, string titleStr, optional bool bDoNotAddBlank, optional bool bDoNotAddBlank2)
{
    AddTooltipItemBlank(4);
    AddCrossLine();
    addTooltipTexture(Icontex, 18, 18, 0, 0, false, false, 1, 2);
    AddTooltipColorText(titleStr, getInstanceL2Util().Gold, false, true, false, "", 4, 4);
    AddCrossLine();
    AddTooltipItemBlank(4);
    return;
}

function AddCollectionItem(ItemInfo item)
{
    // End:0x6F
    if(CollectionWnd(GetScript("CollectionWnd")).isCollectionItem(item))
    {
        AddTitleIconWithHeadLine("L2UI_NewTex.ToolTip.TooltipICON_Collection_small", GetSystemString(7916));
    }
    return;
}

function ReturnTooltip_NTT_ITEM(string param, string TooltipType, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;
    local UIEventManager.EItemType EItemType;
    local UIEventManager.EEtcItemType EEtcItemType;
    local string SlotString, strTmp;
    local int nTmp;
    local string ItemName;
    local int itemNameClass;
    local string strAdena, strAdenaComma;
    local Color AdenaColor;
    local ItemEnchantBonusValue RValue;
    local bool bMagicWeapon;
    local float fSoulShotPower, fSpiritShotPower;
    local int nEnchantedPhysicalDamageBonus, nEnchantedMagicalDamageBonus, nEnchantedMagicalDefenseBonus, nEnchantedPhysicalDefenseBonus, nEnchantedShieldDefenseBonus;

    local string ForeTexture, ItemSlotWithItemTypeStr;
    local int IsCompareItem, IsComparingEquip, nEnchantValueTextGap, nSimpleLineCountAdd, bMainIconGap;

    // End:0x2F73
    if(int(eSourceType) == 1)
    {
        ParamToItemInfo(param, item);
        ParseInt(param, "IsCompareItem", IsCompareItem);
        ParseInt(param, "IsComparingEquip", IsComparingEquip);
        // End:0x8B
        if(TooltipType == "EnsoulSlot")
        {
            // End:0x8B
            if(item.Id.ClassID <= 0)
            {
                return;
            }
        }
        GetItemBonusEnchantValue(item.Id.ClassID, item.CrystalType, item.Enchanted, item.Attribution, RValue);
        EItemType = byte(item.ItemType);
        EEtcItemType = byte(item.ItemSubType);
        nEnchantedShieldDefenseBonus = GetEnchantedShieldDefenseBonus(item.CrystalType, item.Enchanted, item.Attribution);
        nEnchantedMagicalDefenseBonus = GetEnchantedMagicalDefenseBonus(item.CrystalType, item.Enchanted, item.Attribution);
        nEnchantedPhysicalDefenseBonus = GetEnchantedPhysicalDefenseBonus(item.CrystalType, item.Enchanted, item.Attribution);
        nEnchantedPhysicalDamageBonus = GetEnchantedPhysicalDamageBonus(item.WeaponType, item.SlotBitType, item.CrystalType, item.Enchanted, item.Attribution);
        nEnchantedMagicalDamageBonus = GetEnchantedMagicalDamageBonus(item.WeaponType, item.SlotBitType, item.CrystalType, item.Enchanted, item.Attribution);
        ItemName = Class'NWindow.UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);
        itemNameClass = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(item.Id);
        ParseString(param, "ForeTexture", ForeTexture);
        // End:0x334
        if((ForeTexture == "L2UI_CT1.Icon.WearPanel") || IsCompareItem == 1)
        {
            // End:0x2F3
            if((IsComparingEquip == 1) || ForeTexture == "L2UI_CT1.Icon.WearPanel")
            {
                AddTooltipColorText(("[" $ GetSystemString(3556)) $ "]", GetColor(255, 204, 0, 255), true, true, true);
                nSimpleLineCountAdd = 2;
                AddTooltipItemBlank(0);
                AddCrossLine();                
            }
            else
            {
                AddTooltipColorText(("[" $ GetSystemString(3555)) $ "]", GetColor(153, 153, 153, 255), true, true, true);
                nSimpleLineCountAdd = 2;
                AddTooltipItemBlank(0);
                AddCrossLine();
            }
        }
        // End:0x34F
        if(addItemIcon(item, ForeTexture))
        {
            bMainIconGap = 3;
        }
        AddPrimeItemSymbol(item, true);
        // End:0x3D9
        if((TooltipType != "InventoryPrice1HideEnchant") && TooltipType != "InventoryPrice1HideEnchantStackable")
        {
            AddTooltipItemEnchant(item, true, "chatFontSize11", 6, 1);
            nEnchantValueTextGap = 3;
        }
        AddTooltipItemName(ItemName, item, itemNameClass, "chatFontSize11", bMainIconGap + nEnchantValueTextGap, 1);
        // End:0x471
        if(TooltipType != "InventoryPrice1HideEnchantStackable")
        {
            // End:0x471
            if(TooltipType != "QuestReward")
            {
                // End:0x471
                if(__NFUN_409__(item.ItemNum, (0)))
                {
                    AddTooltipItemCount(item, 0, 1);
                }
            }
        }
        AddTooltipItemGrade(item, 0, 1);
        ItemSlotWithItemTypeStr = getSlotTypeWithItemTypeString(item);
        // End:0x4DB
        if(ItemSlotWithItemTypeStr != "")
        {
            m_Tooltip.SimpleLineCount = 2 + nSimpleLineCountAdd;
            AddTooltipItemBlank(1);
            AddTooltipColorText(ItemSlotWithItemTypeStr, GetColor(176, 155, 121, 255), false, true, false, "", 38, -19);
        }
        // End:0x53B
        if((IsAdena(item.Id)) && __NFUN_409__(item.ItemNum, (0)))
        {
            m_Tooltip.SimpleLineCount = 3 + nSimpleLineCountAdd;
            AddTooltipText(("(" $ ConvertNumToText((item.ItemNum))) $ ")", true, true);
        }
        // End:0x74E
        if((TooltipType == "InventoryStackableUnitPrice") && !item.bEquipped)
        {
            strAdena = (item.Price);
            strAdenaComma = MakeCostString(strAdena);
            AdenaColor = GetNumericColor(strAdenaComma);
            // End:0x62C
            if(IsStackableItem(item.ConsumeType) && __NFUN_409__(item.ItemNum, (1)))
            {
                AddTooltipItemBlank(6);
                AddTooltipColorText(GetSystemString(2511) $ " : ", GetColor(255, 180, 0, 255), true, true, false);
                AddTooltipColorText((strAdenaComma $ " ") $ GetSystemString(469), AdenaColor, false, true,, "", 0, 0);                
            }
            else
            {
                AddTooltipItemOption(322, (strAdenaComma $ " ") $ GetSystemString(469), true, true, false,,,,, AdenaColor);
            }
            // End:0x6F1
            if(IsStackableItem(item.ConsumeType) && __NFUN_409__(item.ItemNum, (1)))
            {
                strAdena = (__NFUN_401__(item.Price, item.ItemNum));
                strAdenaComma = MakeCostString(strAdena);
                AdenaColor = GetNumericColor(strAdenaComma);
                AddTooltipItemOption(2595, (strAdenaComma $ " ") $ GetSystemString(469), true, true, false,,,,, AdenaColor);
            }
            // End:0x74E
            if(__NFUN_409__(item.Price, (0)))
            {
                AddTooltipItemOption(0, ("(" $ ConvertNumToText(strAdena)) $ ")", false, true, false);
                SetTooltipItemColor(int(AdenaColor.R), int(AdenaColor.G), int(AdenaColor.B), 0);
            }
        }
        // End:0x8B2
        if((((TooltipType == "InventoryPrice1") || TooltipType == "InventoryPrice1HideEnchant") || TooltipType == "InventoryPrice1HideEnchantStackable") && !item.bEquipped)
        {
            strAdena = (item.Price);
            strAdenaComma = MakeCostString(strAdena);
            AdenaColor = GetNumericColor(strAdenaComma);
            AddTooltipItemOption(322, (strAdenaComma $ " ") $ GetSystemString(469), true, true, false);
            m_Tooltip.SimpleLineCount = 3 + nSimpleLineCountAdd;
            // End:0x8B2
            if(__NFUN_409__(item.Price, (0)))
            {
                m_Tooltip.SimpleLineCount = 4 + nSimpleLineCountAdd;
                AddTooltipItemOption(0, ("(" $ ConvertNumToText(strAdena)) $ ")", false, true, false);
                SetTooltipItemColor(int(AdenaColor.R), int(AdenaColor.G), int(AdenaColor.B), 0);
            }
        }
        // End:0xA1A
        if((TooltipType == "InventoryPrice2") || TooltipType == "InventoryPrice2PrivateShop")
        {
            strAdena = (item.Price);
            strAdenaComma = MakeCostString(strAdena);
            AdenaColor = GetNumericColor(strAdenaComma);
            AddTooltipItemOption2(322, 468, true, true, false);
            SetTooltipItemColor(int(AdenaColor.R), int(AdenaColor.G), int(AdenaColor.B), 0);
            AddTooltipColorText(((" " $ strAdenaComma) $ " ") $ GetSystemString(469), AdenaColor, false, true,,,, 6);
            m_Tooltip.SimpleLineCount = 3 + nSimpleLineCountAdd;
            // End:0xA1A
            if(__NFUN_409__(item.Price, (0)))
            {
                m_Tooltip.SimpleLineCount = 4 + nSimpleLineCountAdd;
                AddTooltipColorText("(", AdenaColor, true, true);
                AddTooltipColorText(GetSystemString(468), AdenaColor, false, true);
                AddTooltipColorText((" " $ ConvertNumToText(strAdena)) $ ")", AdenaColor, false, true);
            }
        }
        // End:0xA82
        if(TooltipType == "InventoryPrice2PrivateShop")
        {
            // End:0xA82
            if(IsStackableItem(item.ConsumeType) && __NFUN_409__(item.Reserved64, (0)))
            {
                AddTooltipItemOption(808, (item.Reserved64), true, true, false);
            }
        }
        // End:0xAC6
        if(item.bSecurityLock)
        {
            AddTooltipColorText(GetSystemString(3775), getInstanceL2Util().HotPink, true, true,, "chatFontSize12",, 6);
        }
        AddCollectionItem(item);
        SlotString = "";
        SlotString = GetSlotTypeString(item.ItemType, item.SlotBitType, item.ArmorType);
        switch(EItemType)
        {
            // End:0x12EB
            case 0:
                // End:0xBCD
                if(RValue.PhysicalDamage != float(0))
                {
                    AddTooltipItemOption(94, string(float(GetPhysicalDamage(item.WeaponType, item.SlotBitType, item.CrystalType, item.Enchanted, int(item.pAttack), item.Attribution)) + RValue.PhysicalDamage), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                    AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 7);                    
                }
                else
                {
                    // End:0xC7A
                    if(item.pAttack != float(0))
                    {
                        AddTooltipItemOption(94, string(GetPhysicalDamage(item.WeaponType, item.SlotBitType, item.CrystalType, item.Enchanted, int(item.pAttack), item.Attribution)), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                        AddTooltipItemBonus(int(item.pAttack), nEnchantedPhysicalDamageBonus, 0, 7);
                    }
                }
                // End:0xD38
                if(RValue.MagicalDamage != float(0))
                {
                    AddTooltipItemOption(98, string(float(GetMagicalDamage(item.WeaponType, item.SlotBitType, item.CrystalType, item.Enchanted, int(item.mAttack), item.Attribution)) + RValue.MagicalDamage), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                    AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 7);                    
                }
                else
                {
                    // End:0xDE5
                    if(item.mAttack != float(0))
                    {
                        AddTooltipItemOption(98, string(GetMagicalDamage(item.WeaponType, item.SlotBitType, item.CrystalType, item.Enchanted, int(item.mAttack), item.Attribution)), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                        AddTooltipItemBonus(int(item.mAttack), nEnchantedMagicalDamageBonus, 0, 7);
                    }
                }
                AddTooltipItemOption(111, GetAttackSpeedString(int(item.pAttackSpeed)), true, true, false);
                // End:0xE5B
                if(item.pDefense > float(0))
                {
                    AddTooltipItemOption(54, string(item.pDefense), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                }
                // End:0xE84
                if(item.mDefense > float(0))
                {
                    AddTooltipItemOption(99, string(item.mDefense), true, true, false);
                }
                // End:0xEC5
                if((item.pHitRate + RValue.PhysicalHitRate) != float(0))
                {
                    AddTooltipItemOption(96, string(item.pHitRate + RValue.PhysicalHitRate), true, true, false);
                }
                // End:0xF06
                if((item.pCriRate + RValue.PhysicalCriRate) > float(0))
                {
                    AddTooltipItemOption(113, string(item.pCriRate + RValue.PhysicalCriRate), true, true, false);
                }
                // End:0xF4A
                if((item.MoveSpeed + RValue.MoveSpeed) != float(0))
                {
                    AddTooltipItemOption(432, string(item.MoveSpeed + RValue.MoveSpeed), true, true, false);
                }
                // End:0xFA3
                if(item.ShieldDefense > float(0))
                {
                    AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                }
                // End:0xFCF
                if(item.ShieldDefenseRate > float(0))
                {
                    AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
                }
                // End:0x1013
                if((item.pAvoid + RValue.PhysicalAvoid) > float(0))
                {
                    AddTooltipItemOption(2361, string(item.pAvoid + RValue.PhysicalAvoid), true, true, false);
                }
                // End:0x1057
                if((item.mAvoid + RValue.MagicalAvoid) > float(0))
                {
                    AddTooltipItemOption(2364, string(item.mAvoid + RValue.MagicalAvoid), true, true, false);
                }
                // End:0x1098
                if((item.mAttackSpeed + RValue.MagicalAttackSpeed) > float(0))
                {
                    AddTooltipItemOption(112, string(item.mAttackSpeed + RValue.MagicalAttackSpeed), true, true, false);
                }
                bMagicWeapon = Class'NWindow.UIDATA_ITEM'.static.IsMagicWeapon(item.Id);
                // End:0x10E7
                if(item.SoulshotCount > 0)
                {
                    AddTooltipItemOption(404, "X" $ string(item.SoulshotCount), true, true, false);
                }
                // End:0x1116
                if(item.SpiritshotCount > 0)
                {
                    AddTooltipItemOption(496, "X" $ string(item.SpiritshotCount), true, true, false);
                }
                // End:0x1279
                if((item.SoulshotCount > 0) || item.SpiritshotCount > 0)
                {
                    fSoulShotPower = GetSoulShotPower(item.CrystalType, item.Enchanted, item.WeaponType, bMagicWeapon);
                    fSpiritShotPower = GetSpiritShotPower(item.CrystalType, item.Enchanted, item.WeaponType, bMagicWeapon);
                    // End:0x120E
                    if(fSoulShotPower == fSpiritShotPower)
                    {
                        // End:0x120B
                        if(fSoulShotPower > float(0))
                        {
                            AddTooltipItemBlank(6);
                            AddTooltipColorText(GetSystemMessage(4297) $ " : ", GetColor(163, 163, 163, 255), true, true);
                            AddTooltipColorText(("+" $ string(fSoulShotPower)) $ "%", GetColor(238, 170, 34, 255), false, true);
                        }                        
                    }
                    else
                    {
                        AddTooltipItemBlank(6);
                        AddTooltipColorText(GetSystemMessage(4297) $ " : ", GetColor(163, 163, 163, 255), true, true);
                        AddTooltipColorText((((("+" $ string(fSoulShotPower)) $ "%") $ ", ") $ string(fSpiritShotPower)) $ "%", GetColor(238, 170, 34, 255), false, true);
                    }
                }
                // End:0x129C
                if(item.Weight == 0)
                {
                    AddTooltipItemOption(52, " 0 ", true, true, false);                    
                }
                else
                {
                    AddTooltipItemOption(52, string(item.Weight), true, true, false);
                }
                // End:0x12DD
                if(item.MpConsume != 0)
                {
                    AddTooltipItemOption(320, string(item.MpConsume), true, true, false);
                }
                AddTooltipRefinery(item);
                // End:0x2E5A
                break;
            // End:0x2737
            case 1:
                // End:0x1791
                if(__NFUN_412__(item.SlotBitType, (256)) && item.ArmorType == 4)
                {
                    // End:0x13B3
                    if(item.pDefense != float(0))
                    {
                        AddTooltipItemOption(95, string(GetPhysicalDefense(item.CrystalType, item.Enchanted, int(item.pDefense), item.Attribution)), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                        AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 7);
                    }
                    // End:0x13EE
                    if(RValue.PhysicalAvoid != float(0))
                    {
                        AddTooltipItemOption(2361, string(item.pAvoid + RValue.PhysicalAvoid), true, true, false);                        
                    }
                    else
                    {
                        // End:0x141A
                        if(item.pAvoid != float(0))
                        {
                            AddTooltipItemOption(2361, string(item.pAvoid), true, true, false);
                        }
                    }
                    // End:0x145B
                    if((item.pAttack + RValue.PhysicalDamage) > float(0))
                    {
                        AddTooltipItemOption(94, string(item.pAttack + RValue.PhysicalDamage), true, true, false);
                    }
                    // End:0x149C
                    if((item.mAttack + RValue.MagicalDamage) > float(0))
                    {
                        AddTooltipItemOption(98, string(item.mAttack + RValue.MagicalDamage), true, true, false);
                    }
                    // End:0x14DD
                    if((item.mAttackSpeed + RValue.MagicalAttackSpeed) > float(0))
                    {
                        AddTooltipItemOption(112, string(item.mAttackSpeed + RValue.MagicalAttackSpeed), true, true, false);
                    }
                    // End:0x1521
                    if((item.pHitRate + RValue.PhysicalHitRate) > float(0))
                    {
                        AddTooltipItemOption(2360, string(item.pHitRate + RValue.PhysicalHitRate), true, true, false);
                    }
                    // End:0x1565
                    if((item.mHitRate + RValue.MagicalHitRate) > float(0))
                    {
                        AddTooltipItemOption(2363, string(item.mHitRate + RValue.MagicalHitRate), true, true, false);
                    }
                    // End:0x15A9
                    if((item.pCriRate + RValue.PhysicalCriRate) > float(0))
                    {
                        AddTooltipItemOption(2362, string(item.pCriRate + RValue.PhysicalCriRate), true, true, false);
                    }
                    // End:0x15ED
                    if((item.mCriRate + RValue.MagicalCriRate) > float(0))
                    {
                        AddTooltipItemOption(2365, string(item.mCriRate + RValue.MagicalCriRate), true, true, false);
                    }
                    // End:0x1631
                    if((item.MoveSpeed + RValue.MoveSpeed) != float(0))
                    {
                        AddTooltipItemOption(432, string(item.MoveSpeed + RValue.MoveSpeed), true, true, false);
                    }
                    // End:0x168A
                    if(item.ShieldDefense > float(0))
                    {
                        AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                    }
                    // End:0x16B6
                    if(item.ShieldDefenseRate > float(0))
                    {
                        AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
                    }
                    // End:0x16FA
                    if((item.pAvoid + RValue.PhysicalAvoid) > float(0))
                    {
                        AddTooltipItemOption(2361, string(item.pAvoid + RValue.PhysicalAvoid), true, true, false);
                    }
                    // End:0x173E
                    if((item.mAvoid + RValue.MagicalAvoid) > float(0))
                    {
                        AddTooltipItemOption(2364, string(item.mAvoid + RValue.MagicalAvoid), true, true, false);
                    }
                    // End:0x1767
                    if(item.mDefense > float(0))
                    {
                        AddTooltipItemOption(99, string(item.mDefense), true, true, false);
                    }
                    // End:0x178E
                    if(item.Weight != 0)
                    {
                        AddTooltipItemOption(52, string(item.Weight), true, true, false);
                    }                    
                }
                else
                {
                    // End:0x1C35
                    if(__NFUN_412__(item.SlotBitType, (256)) || __NFUN_412__(item.SlotBitType, (128)))
                    {
                        // End:0x1857
                        if(item.ShieldDefense != float(0))
                        {
                            AddTooltipItemOption(95, string(GetShieldDefense(item.CrystalType, item.Enchanted, int(item.ShieldDefense), item.Attribution)), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                            AddTooltipItemBonus(int(item.ShieldDefense), nEnchantedShieldDefenseBonus, 0, 7);
                        }
                        // End:0x1892
                        if(RValue.PhysicalAvoid != float(0))
                        {
                            AddTooltipItemOption(2361, string(item.pAvoid + RValue.PhysicalAvoid), true, true, false);                            
                        }
                        else
                        {
                            // End:0x18BE
                            if(item.pAvoid != float(0))
                            {
                                AddTooltipItemOption(2361, string(item.pAvoid), true, true, false);
                            }
                        }
                        // End:0x1917
                        if(item.pDefense > float(0))
                        {
                            AddTooltipItemOption(54, string(item.pDefense), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                        }
                        // End:0x1940
                        if(item.mDefense > float(0))
                        {
                            AddTooltipItemOption(99, string(item.mDefense), true, true, false);
                        }
                        // End:0x1981
                        if((item.pAttack + RValue.PhysicalDamage) > float(0))
                        {
                            AddTooltipItemOption(94, string(item.pAttack + RValue.PhysicalDamage), true, true, false);
                        }
                        // End:0x19C2
                        if((item.mAttack + RValue.MagicalDamage) > float(0))
                        {
                            AddTooltipItemOption(98, string(item.mAttack + RValue.MagicalDamage), true, true, false);
                        }
                        // End:0x1A03
                        if((item.mAttackSpeed + RValue.MagicalAttackSpeed) > float(0))
                        {
                            AddTooltipItemOption(112, string(item.mAttackSpeed + RValue.MagicalAttackSpeed), true, true, false);
                        }
                        // End:0x1A47
                        if((item.pHitRate + RValue.PhysicalHitRate) > float(0))
                        {
                            AddTooltipItemOption(2360, string(item.pHitRate + RValue.PhysicalHitRate), true, true, false);
                        }
                        // End:0x1A8B
                        if((item.mHitRate + RValue.MagicalHitRate) > float(0))
                        {
                            AddTooltipItemOption(2363, string(item.mHitRate + RValue.MagicalHitRate), true, true, false);
                        }
                        // End:0x1ACF
                        if((item.pCriRate + RValue.PhysicalCriRate) > float(0))
                        {
                            AddTooltipItemOption(2362, string(item.pCriRate + RValue.PhysicalCriRate), true, true, false);
                        }
                        // End:0x1B13
                        if((item.mCriRate + RValue.MagicalCriRate) > float(0))
                        {
                            AddTooltipItemOption(2365, string(item.mCriRate + RValue.MagicalCriRate), true, true, false);
                        }
                        // End:0x1B57
                        if((item.MoveSpeed + RValue.MoveSpeed) != float(0))
                        {
                            AddTooltipItemOption(432, string(item.MoveSpeed + RValue.MoveSpeed), true, true, false);
                        }
                        // End:0x1B83
                        if(item.ShieldDefenseRate > float(0))
                        {
                            AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
                        }
                        // End:0x1BC7
                        if((item.pAvoid + RValue.PhysicalAvoid) > float(0))
                        {
                            AddTooltipItemOption(2361, string(item.pAvoid + RValue.PhysicalAvoid), true, true, false);
                        }
                        // End:0x1C0B
                        if((item.mAvoid + RValue.MagicalAvoid) > float(0))
                        {
                            AddTooltipItemOption(2364, string(item.mAvoid + RValue.MagicalAvoid), true, true, false);
                        }
                        // End:0x1C32
                        if(item.Weight != 0)
                        {
                            AddTooltipItemOption(52, string(item.Weight), true, true, false);
                        }                        
                    }
                    else
                    {
                        // End:0x21E7
                        if(IsMagicalArmor(item.Id))
                        {
                            // End:0x1CA2
                            if(item.MpBonus > 0)
                            {
                                AddTooltipItemOption(388, string(item.MpBonus), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                            }
                            // End:0x1DAB
                            if((__NFUN_412__(item.SlotBitType, (65536)) || __NFUN_412__(item.SlotBitType, (524288))) || __NFUN_412__(item.SlotBitType, (262144)))
                            {
                                // End:0x1DA8
                                if(GetPhysicalDefense(item.CrystalType, item.Enchanted, int(item.pDefense), item.Attribution) != 0)
                                {
                                    AddTooltipItemOption(95, string(GetPhysicalDefense(item.CrystalType, item.Enchanted, int(item.pDefense), item.Attribution)), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                                    AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 7);
                                }                                
                            }
                            else
                            {
                                // End:0x1E44
                                if(item.pDefense != float(0))
                                {
                                    AddTooltipItemOption(95, string(GetPhysicalDefense(item.CrystalType, item.Enchanted, int(item.pDefense), item.Attribution)), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                                    AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 7);
                                }
                                // End:0x1E9D
                                if(item.mDefense > float(0))
                                {
                                    AddTooltipItemOption(99, string(item.mDefense), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                                }
                                // End:0x1EDE
                                if((item.pAttack + RValue.PhysicalDamage) > float(0))
                                {
                                    AddTooltipItemOption(94, string(item.pAttack + RValue.PhysicalDamage), true, true, false);
                                }
                                // End:0x1F1F
                                if((item.mAttack + RValue.MagicalDamage) > float(0))
                                {
                                    AddTooltipItemOption(98, string(item.mAttack + RValue.MagicalDamage), true, true, false);
                                }
                                // End:0x1F60
                                if((item.mAttackSpeed + RValue.MagicalAttackSpeed) > float(0))
                                {
                                    AddTooltipItemOption(112, string(item.mAttackSpeed + RValue.MagicalAttackSpeed), true, true, false);
                                }
                                // End:0x1FA4
                                if((item.pHitRate + RValue.PhysicalHitRate) > float(0))
                                {
                                    AddTooltipItemOption(2360, string(item.pHitRate + RValue.PhysicalHitRate), true, true, false);
                                }
                                // End:0x1FE8
                                if((item.mHitRate + RValue.MagicalHitRate) > float(0))
                                {
                                    AddTooltipItemOption(2363, string(item.mHitRate + RValue.MagicalHitRate), true, true, false);
                                }
                                // End:0x202C
                                if((item.pCriRate + RValue.PhysicalCriRate) > float(0))
                                {
                                    AddTooltipItemOption(2362, string(item.pCriRate + RValue.PhysicalCriRate), true, true, false);
                                }
                                // End:0x2070
                                if((item.mCriRate + RValue.MagicalCriRate) > float(0))
                                {
                                    AddTooltipItemOption(2365, string(item.mCriRate + RValue.MagicalCriRate), true, true, false);
                                }
                                // End:0x20B4
                                if((item.MoveSpeed + RValue.MoveSpeed) != float(0))
                                {
                                    AddTooltipItemOption(432, string(item.MoveSpeed + RValue.MoveSpeed), true, true, false);
                                }
                                // End:0x20E0
                                if(item.ShieldDefenseRate > float(0))
                                {
                                    AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
                                }
                                // End:0x2124
                                if((item.pAvoid + RValue.PhysicalAvoid) > float(0))
                                {
                                    AddTooltipItemOption(2361, string(item.pAvoid + RValue.PhysicalAvoid), true, true, false);
                                }
                                // End:0x2168
                                if((item.mAvoid + RValue.MagicalAvoid) > float(0))
                                {
                                    AddTooltipItemOption(2364, string(item.mAvoid + RValue.MagicalAvoid), true, true, false);
                                }
                                // End:0x2191
                                if(item.ShieldDefense > float(0))
                                {
                                    AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false);
                                }
                                // End:0x21BD
                                if(item.ShieldDefenseRate > float(0))
                                {
                                    AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
                                }
                            }
                            // End:0x21E4
                            if(item.Weight != 0)
                            {
                                AddTooltipItemOption(52, string(item.Weight), true, true, false);
                            }                            
                        }
                        else
                        {
                            // End:0x22F0
                            if((__NFUN_412__(item.SlotBitType, (65536)) || __NFUN_412__(item.SlotBitType, (524288))) || __NFUN_412__(item.SlotBitType, (262144)))
                            {
                                // End:0x22ED
                                if(GetPhysicalDefense(item.CrystalType, item.Enchanted, int(item.pDefense), item.Attribution) != 0)
                                {
                                    AddTooltipItemOption(95, string(GetPhysicalDefense(item.CrystalType, item.Enchanted, int(item.pDefense), item.Attribution)), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                                    AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 7);
                                }                                
                            }
                            else
                            {
                                // End:0x2389
                                if(item.pDefense != float(0))
                                {
                                    AddTooltipItemOption(95, string(GetPhysicalDefense(item.CrystalType, item.Enchanted, int(item.pDefense), item.Attribution)), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                                    AddTooltipItemBonus(int(item.pDefense), nEnchantedPhysicalDefenseBonus, 0, 7);
                                }
                                // End:0x23E2
                                if(item.mDefense > float(0))
                                {
                                    AddTooltipItemOption(99, string(item.mDefense), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                                }
                                // End:0x2423
                                if((item.pAttack + RValue.PhysicalDamage) > float(0))
                                {
                                    AddTooltipItemOption(94, string(item.pAttack + RValue.PhysicalDamage), true, true, false);
                                }
                                // End:0x2464
                                if((item.mAttack + RValue.MagicalDamage) > float(0))
                                {
                                    AddTooltipItemOption(98, string(item.mAttack + RValue.MagicalDamage), true, true, false);
                                }
                                // End:0x24A5
                                if((item.mAttackSpeed + RValue.MagicalAttackSpeed) > float(0))
                                {
                                    AddTooltipItemOption(112, string(item.mAttackSpeed + RValue.MagicalAttackSpeed), true, true, false);
                                }
                                // End:0x24E9
                                if((item.pHitRate + RValue.PhysicalHitRate) > float(0))
                                {
                                    AddTooltipItemOption(2360, string(item.pHitRate + RValue.PhysicalHitRate), true, true, false);
                                }
                                // End:0x252D
                                if((item.mHitRate + RValue.MagicalHitRate) > float(0))
                                {
                                    AddTooltipItemOption(2363, string(item.mHitRate + RValue.MagicalHitRate), true, true, false);
                                }
                                // End:0x2571
                                if((item.pCriRate + RValue.PhysicalCriRate) > float(0))
                                {
                                    AddTooltipItemOption(2362, string(item.pCriRate + RValue.PhysicalCriRate), true, true, false);
                                }
                                // End:0x25B5
                                if((item.mCriRate + RValue.MagicalCriRate) > float(0))
                                {
                                    AddTooltipItemOption(2365, string(item.mCriRate + RValue.MagicalCriRate), true, true, false);
                                }
                                // End:0x25F9
                                if((item.MoveSpeed + RValue.MoveSpeed) != float(0))
                                {
                                    AddTooltipItemOption(432, string(item.MoveSpeed + RValue.MoveSpeed), true, true, false);
                                }
                                // End:0x2625
                                if(item.ShieldDefenseRate > float(0))
                                {
                                    AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
                                }
                                // End:0x2669
                                if((item.pAvoid + RValue.PhysicalAvoid) > float(0))
                                {
                                    AddTooltipItemOption(2361, string(item.pAvoid + RValue.PhysicalAvoid), true, true, false);
                                }
                                // End:0x26AD
                                if((item.mAvoid + RValue.MagicalAvoid) > float(0))
                                {
                                    AddTooltipItemOption(2364, string(item.mAvoid + RValue.MagicalAvoid), true, true, false);
                                }
                                // End:0x26D6
                                if(item.ShieldDefense > float(0))
                                {
                                    AddTooltipItemOption(95, string(item.ShieldDefense), true, true, false);
                                }
                                // End:0x2702
                                if(item.ShieldDefenseRate > float(0))
                                {
                                    AddTooltipItemOption(317, string(item.ShieldDefenseRate), true, true, false);
                                }
                            }
                            // End:0x2729
                            if(item.Weight != 0)
                            {
                                AddTooltipItemOption(52, string(item.Weight), true, true, false);
                            }
                        }
                    }
                }
                AddTooltipRefinery(item);
                // End:0x2E5A
                break;
            // End:0x2A1C
            case 2:
                // End:0x2767
                if(__NFUN_412__(item.SlotBitType, ("206158430208")))
                {
                    AddAgathionSkillTooltip(item);
                }
                // End:0x28B5
                if(getInstanceUIData().getIsClassicServer())
                {
                    // End:0x28B2
                    if((((__NFUN_413__(item.SlotBitType, (536870912)) && __NFUN_413__(item.SlotBitType, (1073741824))) && __NFUN_413__(item.SlotBitType, (4194304))) && __NFUN_413__(item.SlotBitType, (1048576))) && __NFUN_413__(item.SlotBitType, (2097152)))
                    {
                        // End:0x2898
                        if(GetMagicalDefense(item.CrystalType, item.Enchanted, int(item.mDefense), item.Attribution) > 0)
                        {
                            AddTooltipItemOption(99, string(GetMagicalDefense(item.CrystalType, item.Enchanted, int(item.mDefense), item.Attribution)), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                        }
                        AddTooltipItemBonus(int(item.mDefense), nEnchantedMagicalDefenseBonus, 0, 7);
                    }                    
                }
                else
                {
                    // End:0x29D4
                    if(((__NFUN_413__(item.SlotBitType, (1073741824)) && __NFUN_413__(item.SlotBitType, (4194304))) && __NFUN_413__(item.SlotBitType, (1048576))) && __NFUN_413__(item.SlotBitType, (2097152)))
                    {
                        // End:0x29BA
                        if(GetMagicalDefense(item.CrystalType, item.Enchanted, int(item.mDefense), item.Attribution) > 0)
                        {
                            AddTooltipItemOption(99, string(GetMagicalDefense(item.CrystalType, item.Enchanted, int(item.mDefense), item.Attribution)), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
                        }
                        AddTooltipItemBonus(int(item.mDefense), nEnchantedMagicalDefenseBonus, 0, 7);
                    }
                }
                // End:0x29F7
                if(item.Weight == 0)
                {
                    AddTooltipItemOption(52, " 0 ", true, true, false);                    
                }
                else
                {
                    AddTooltipItemOption(52, string(item.Weight), true, true, false);
                }
                AddTooltipRefinery(item);
                // End:0x2E5A
                break;
            // End:0x2A24
            case 3:
                // End:0x2E5A
                break;
            // End:0x2E54
            case 5:
                // End:0x2A50
                if(int(EEtcItemType) == 54)
                {
                    CardEventImgTooltip(item, "inventory");                    
                }
                else
                {
                    // End:0x2AB4
                    if(int(EEtcItemType) == 7)
                    {
                        // End:0x2A7C
                        if(item.Damaged == 0)
                        {
                            nTmp = 971;                            
                        }
                        else
                        {
                            nTmp = 970;
                        }
                        AddTooltipItemOption2(969, nTmp, true, true, false);
                        AddTooltipItemOption(88, string(item.Enchanted), true, true, false);                        
                    }
                    else
                    {
                        // End:0x2ADF
                        if(int(EEtcItemType) == 15)
                        {
                            AddTooltipItemOption(972, string(item.Enchanted), true, true, false);                            
                        }
                        else
                        {
                            // End:0x2B28
                            if(int(EEtcItemType) == 13)
                            {
                                AddTooltipItemOption(670, string(item.Blessed), true, true, false);
                                AddTooltipItemOption(671, GetLottoString(item.LookChangeItemID), true, true, false);                                
                            }
                            else
                            {
                                // End:0x2B8F
                                if(int(EEtcItemType) == 14)
                                {
                                    AddTooltipItemOption(670, string(item.Enchanted), true, true, false);
                                    AddTooltipItemOption(671, GetRaceTicketString(item.Blessed), true, true, false);
                                    AddTooltipItemOption(744, string(item.Damaged * 100), true, true, false);                                    
                                }
                                else
                                {
                                    // End:0x2E09
                                    if(item.MaxUseCount > 0)
                                    {
                                        AddCrossLine();
                                        AddTooltipItemBlank(0);
                                        AddTooltipText(("<" $ GetSystemString(3801)) $ ">", true, true);
                                        AddTooltipItemBlank(0);
                                        addTexture("l2ui_ct1.SkillWnd_DF_ListIcon_use", 12, 11, 12, 11, 3, 7);
                                        AddTooltipColorText(GetSystemString(2378) $ " : ", GetColor(163, 163, 163, 255), false, true, false, "", 0, 6);
                                        StartItem();
                                        m_Info.eType = 1;
                                        m_Info.nOffSetY = 6;
                                        m_Info.bLineBreak = false;
                                        m_Info.t_bDrawOneLine = true;
                                        m_Info.t_color = GetColor(176, 155, 121, 255);
                                        // End:0x2CB1
                                        if(item.MaxReuseDelay < float(0))
                                        {
                                            m_Info.t_strText = GetSystemString(3804);                                            
                                        }
                                        else
                                        {
                                            // End:0x2CDC
                                            if(item.RemainReuseDelay == float(0))
                                            {
                                                m_Info.t_strText = GetSystemString(3537);                                                
                                            }
                                            else
                                            {
                                                m_Info.t_strText = MakeTimeStr(int(item.RemainReuseDelay));
                                                ParamAdd(m_Info.Condition, "Type", "ReuseDelay");
                                            }
                                        }
                                        EndItem();
                                        AddTooltipItemBlank(0);
                                        addTexture("l2ui_ct1.Icon.Tooltip_CubeIcon", 12, 11, 12, 11, 3, 7);
                                        AddTooltipColorText(GetSystemString(3802) $ " : ", GetColor(163, 163, 163, 255), false, true, false, "", 0, 6);
                                        AddTooltipColorText((string(item.MaxUseCount - item.CurUseCount) $ "/") $ string(item.MaxUseCount), GetColor(176, 155, 121, 255), false, true, false, "", 0, 6);
                                        AddTooltipColorText(("  (" $ GetSystemString(3803)) $ ")", GetColor(238, 170, 34, 255), true, true);
                                        AddCrossLine();
                                        AddTooltipItemBlank(0);
                                    }
                                }
                            }
                        }
                    }
                }
                // End:0x2E51
                if(int(EEtcItemType) != 54)
                {
                    // End:0x2E3A
                    if(item.Weight == 0)
                    {
                        AddTooltipItemOption(52, " 0 ", true, true, false);                        
                    }
                    else
                    {
                        AddTooltipItemOption(52, string(item.Weight), true, true, false);
                    }
                }
                // End:0x2E5A
                break;
            // End:0xFFFF
            default:
                // End:0x2E5A
                break;
                break;
        }
        AddTooltipEventSeventhdayOfSeventhMonth(item);
        AddTooltipItemDurability(item);
        AddTooltipBR_MaxEnergy(item);
        // End:0x2EBB
        if(Len(item.Description) > 0)
        {
            AddCrossLine();
            AddTooltipItemBlank(6);
            AddTooltipColorText(item.Description, GetColor(178, 190, 207, 255), true, false);
        }
        addSetitemTooltip(item);
        AddTooltipItemQuestList(item);
        AddWeaponEnsoulOption(item);
        // End:0x2F37
        if(item.bSecurityLock)
        {
            AddCrossLine();
            AddTooltipItemOption(3805, "", true, true, false,,,, GetColor(230, 230, 230, 255));
            AddTooltipColorText(GetSystemString(3806), GetColor(178, 190, 207, 255), true, true,,,, 6);
        }
        // End:0x2F5A
        if(TooltipType != "InventoryPet")
        {
            AddTooltipItemAttributeGage(item);
        }
        AddTooltipItemWeaponLookChange(item);
        AddTooltipItemCurrentPeriod(item);        
    }
    else
    {
        return;
    }
    // End:0x2FB6
    if(TooltipType == "InventoryPawnViewer")
    {
        AddTooltipText("ID : " $ string(item.Id.ClassID), true, true);
    }
    // End:0x2FE8
    if(!IsAdena(item.Id))
    {
        addForbidItemDesc(item.Id);
        m_Tooltip.MinimumWidth = 154;
    }
    // End:0x2FFE
    if(item.CurrentPeriod > 0)
    {
        setMakeTimeStrMaxWidth();
    }
    setTooltipMinimumWidth();
    // End:0x336E
    if((IsBuilderPC()) && DebugSectorBool("debug", "tooltipdebug"))
    {
        AddCrossLine();
        AddTooltipColorText("Client ID:" @ string(item.Id.ClassID), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("Server ID:" @ string(item.Id.ServerID), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("SlotBitType:" @ (item.SlotBitType), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("Icon:" @ item.IconName, GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("IconPanel:" @ item.IconPanel, GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("LookChangeIconPanel:" @ item.LookChangeIconPanel, GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("IconIndex:" @ string(item.IconIndex), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("Refinery1:" @ string(item.RefineryOp1), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("Refinery2:" @ string(item.RefineryOp2), GetColor(255, 215, 0, 255), true, false);
        AddCrossLine();
        AddTooltipColorText("WType.ATT:" @ string(item.AttackAttributeType), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("WValue.ATT:" @ string(item.AttackAttributeValue), GetColor(255, 215, 0, 255), true, false);
        AddCrossLine();
        AddTooltipColorText("AFire.ATT:" @ string(item.DefenseAttributeValueFire), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("AWater.ATT:" @ string(item.DefenseAttributeValueWater), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("AWind.ATT:" @ string(item.DefenseAttributeValueWind), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("AEarth.ATT:" @ string(item.DefenseAttributeValueEarth), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("AHoly.ATT:" @ string(item.DefenseAttributeValueHoly), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("AUnholy.ATT:" @ string(item.DefenseAttributeValueUnholy), GetColor(255, 215, 0, 255), true, false);
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function setTooltipMinimumWidth()
{
    m_Tooltip.MinimumWidth = getMaxWidth();
    toolTipLineWidthRefresh();
    return;
}

function toolTipLineWidthRefresh()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x59 [Loop If]
    if(i < m_Tooltip.DrawList.Length)
    {
        // End:0x4F
        if(int(m_Tooltip.DrawList[i].eType) == 3)
        {
            m_Info.u_nTextureWidth = m_Tooltip.MinimumWidth;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function int getMaxWidth()
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

function bool addForbidItemDesc(ItemID pItemID)
{
    local string forbidItemDesc, enableItemDesc;
    local bool flag;

    // End:0x15
    if(getInstanceUIData().getIsClassicServer())
    {
        return false;
    }
    flag = false;
    Class'NWindow.UIDATA_ITEM'.static.GetItemDescriptionAdditionData(pItemID, forbidItemDesc, enableItemDesc);
    // End:0xB9
    if((forbidItemDesc != "") || enableItemDesc != "")
    {
        AddCrossLine();
        AddTooltipItemBlank(6);
        // End:0x8A
        if(enableItemDesc != "")
        {
            AddTooltipColorText(enableItemDesc, GetColor(158, 127, 87, 255), true, false);
        }
        // End:0xB1
        if(forbidItemDesc != "")
        {
            AddTooltipColorText(forbidItemDesc, GetColor(152, 83, 45, 200), true, false);
        }
        flag = true;
    }
    return flag;
    return;
}

function CardEventImgTooltip(ItemInfo item, optional string Sender)
{
    StartItem();
    m_Tooltip.SimpleLineCount = 1;
    EndItem();
    StartItem();
    m_Info.eType = 2;
    m_Info.u_nTextureWidth = 242;
    m_Info.u_nTextureHeight = 344;
    m_Info.u_strTexture = item.tooltipTexutre;
    EndItem();
    // End:0x145
    if(Sender == "inventory")
    {
        // End:0x145
        if((item.Id.ClassID >= 38907) && item.Id.ClassID <= 38922)
        {
            StartItem();
            m_Info.eType = 1;
            m_Info.t_bDrawOneLine = true;
            m_Info.bLineBreak = true;
            m_Info.t_color.R = byte(255);
            m_Info.t_color.G = byte(255);
            m_Info.t_color.B = byte(255);
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = GetSystemString(3218);
            EndItem();
        }
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_GFXCARD(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;
    local string ItemName;
    local int itemNameClass;

    // End:0x8F
    if(int(eSourceType) == 1)
    {
        ParamToItemInfo(param, item);
        ItemName = Class'NWindow.UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);
        itemNameClass = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(item.Id);
        AddTooltipItemName(ItemName, item, itemNameClass);
        CardEventImgTooltip(item);
    }
    return;
}

function ReturnTooltip_NTT_CHAT_USERFAKEINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    // End:0x18
    if(int(eSourceType) == 0)
    {
        ChatUserFakeInfoTooltip(param);
    }
    return;
}

function ChatUserFakeInfoTooltip(string param)
{
    local string charName;
    local int isFriend, isGM, isPledge, isAlliance, isMentoring;

    ParseString(param, "CharName", charName);
    ParseInt(param, "IsFriend", isFriend);
    ParseInt(param, "IsPledge", isPledge);
    ParseInt(param, "IsMentoring", isMentoring);
    ParseInt(param, "IsAlliance", isAlliance);
    ParseInt(param, "IsGM", isGM);
    // End:0xCA
    if(isFriend != 0)
    {
        AddTooltipItemColorOption(2273, GetSystemString(3175), 77, 255, 99, true, true, true);        
    }
    else
    {
        AddTooltipItemColorOption(2273, GetSystemString(3176), 255, 66, 66, true, true, true);
    }
    // End:0x116
    if(isPledge != 0)
    {
        AddTooltipItemColorOption(314, GetSystemString(3179), 77, 255, 99, true, true, false);        
    }
    else
    {
        AddTooltipItemColorOption(314, GetSystemString(3180), 255, 66, 66, true, true, false);
    }
    // End:0x179
    if((isMentoring != 0) && !getInstanceUIData().getIsClassicServer())
    {
        AddTooltipItemColorOption(2767, GetSystemString(3177), 77, 255, 99, true, true, false);        
    }
    else
    {
        // End:0x1AD
        if(!getInstanceUIData().getIsClassicServer())
        {
            AddTooltipItemColorOption(2767, GetSystemString(3178), 255, 66, 66, true, true, false);
        }
    }
    // End:0x1DA
    if(isAlliance != 0)
    {
        AddTooltipItemColorOption(490, GetSystemString(3181), 77, 255, 99, true, true, false);        
    }
    else
    {
        AddTooltipItemColorOption(490, GetSystemString(3182), 255, 66, 66, true, true, false);
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_MACRO(string param, UIEventManager.ETooltipSourceType eSourceType, optional bool bUseUserMacro)
{
    local ItemInfo item;
    local MacroInfo MacroInfo;
    local int idx;
    local array<string> commandArray;
    local bool bCustomMacro;

    // End:0x1F9
    if(int(eSourceType) == 1)
    {
        ParamToItemInfo(param, item);
        bCustomMacro = Class'NWindow.UIDATA_MACRO'.static.GetMacroInfo(item.Id, MacroInfo);
        // End:0x7E
        if(MacroInfo.IconSkillId > 0)
        {
            item.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(GetItemID(MacroInfo.IconSkillId), 1, 0);
        }
        addItemIcon(item, "");
        m_Tooltip.MinimumWidth = 154;
        AddTooltipText(item.Name, false, true, true, "chatFontSize11", 5, 1);
        // End:0xF0
        if(Len(item.Description) > 0)
        {
            AddTooltipColorText(item.Description, GetColor(178, 190, 207, 255), true, false);
        }
        // End:0x17E
        if((item.MacroCommand != "") && !bUseUserMacro)
        {
            StringIntoArray(item.MacroCommand, Chr(13), commandArray);
            idx = 0;
            J0x12E:

            // End:0x17B [Loop If]
            if(idx < commandArray.Length)
            {
                // End:0x171
                if(commandArray[idx] != "")
                {
                    AddTooltipColorText(commandArray[idx], GetColor(176, 155, 121, 255), true, true);
                }
                idx++;
                // [Loop Continue]
                goto J0x12E;
            }            
        }
        else
        {
            // End:0x1F6
            if(bCustomMacro)
            {
                idx = 0;
                J0x18E:

                // End:0x1F6 [Loop If]
                if(idx < 12)
                {
                    // End:0x1EC
                    if((trim(MacroInfo.CommandList[idx])) != "")
                    {
                        AddTooltipColorText(makeShortStringByPixel(MacroInfo.CommandList[idx], 300, ".."), GetColor(176, 155, 121, 255), true, true);
                    }
                    idx++;
                    // [Loop Continue]
                    goto J0x18E;
                }
            }
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_ACTION(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;

    // End:0x162
    if(int(eSourceType) == 1)
    {
        ParamToItemInfo(param, item);
        addItemIcon(item, "");
        StartItem();
        m_Info.eType = 1;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_strFontName = "chatFontSize11";
        m_Info.nOffSetX = 5;
        m_Info.nOffSetY = 0;
        m_Info.t_strText = item.Name;
        EndItem();
        AddTooltipItemBlank(6);
        // End:0x15F
        if(Len(item.Description) > 0)
        {
            m_Tooltip.MinimumWidth = 154;
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.t_bDrawOneLine = false;
            m_Info.bLineBreak = true;
            m_Info.t_color.R = 178;
            m_Info.t_color.G = 190;
            m_Info.t_color.B = 207;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = item.Description;
            EndItem();
        }        
    }
    else
    {
        return;
    }
    // End:0x223
    if((IsBuilderPC()) && DebugSectorBool("debug", "tooltipdebug"))
    {
        AddCrossLine();
        AddTooltipColorText("Client ID:" @ string(item.Id.ClassID), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("Server ID:" @ string(item.Id.ServerID), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("Icon:" @ item.IconName, GetColor(255, 215, 0, 255), true, false);
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_SKILL(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;
    local UIEventManager.EItemParamType EItemParamType;
    local int nTmp, SkillLevel, nSkillID, nSkillLevel, nSkillSubLevel;

    local string szReserved;
    local int nIsNoLevelTooltip;
    local SkillInfo SkillInfo;

    // End:0x82D
    if((int(eSourceType) == 1) || int(eSourceType) == 2)
    {
        // End:0x13C
        if(int(eSourceType) == 2)
        {
            ParseInt(param, "szReserved", nIsNoLevelTooltip);
            ParseInt(param, "nReserved1", nSkillID);
            // End:0x83
            if(nIsNoLevelTooltip == 1)
            {
                GetSkillInfo(nSkillID, 1, 0, SkillInfo);                
            }
            else
            {
                ParseInt(param, "nReserved2", nSkillLevel);
                ParseInt(param, "nReserved3", nSkillSubLevel);
                GetSkillInfo(nSkillID, nSkillLevel, nSkillSubLevel, SkillInfo);
            }
            item.Id.ClassID = SkillInfo.SkillID;
            item.Name = SkillInfo.SkillName;
            item.Description = SkillInfo.SkillDesc;
            item.Level = nSkillLevel;
            item.SubLevel = nSkillSubLevel;            
        }
        else
        {
            ParseItemID(param, item.Id);
            ParseString(param, "Name", item.Name);
            ParseString(param, "AdditionalName", item.AdditionalName);
            ParseString(param, "Description", item.Description);
            ParseInt(param, "Level", item.Level);
            ParseInt(param, "SubLevel", item.SubLevel);
            GetSkillInfo(item.Id.ClassID, item.Level, item.SubLevel, SkillInfo);
        }
        GetSkillInfo(item.Id.ClassID, item.Level, item.SubLevel, SkillInfo);
        item.IconName = SkillInfo.TexName;
        EItemParamType = byte(item.ItemType);
        SkillLevel = item.Level;
        m_Tooltip.MinimumWidth = 154;
        addItemIcon(item, "");
        StartItem();
        m_Info.eType = 1;
        m_Info.t_bDrawOneLine = true;
        m_Info.nOffSetX = 5;
        m_Info.t_strText = item.Name;
        m_Info.t_strFontName = "chatFontSize11";
        EndItem();
        // End:0x751
        if(nIsNoLevelTooltip == 0)
        {
            StartItem();
            m_Info.eType = 1;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_strFontName = "chatFontSize11";
            m_Info.t_strText = " ";
            EndItem();
            StartItem();
            m_Info.eType = 1;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = 163;
            m_Info.t_color.G = 163;
            m_Info.t_color.B = 163;
            m_Info.t_color.A = byte(255);
            m_Info.t_strFontName = "chatFontSize11";
            m_Info.t_ID = 88;
            EndItem();
            StartItem();
            m_Info.eType = 1;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = 176;
            m_Info.t_color.G = 155;
            m_Info.t_color.B = 121;
            m_Info.t_color.A = byte(255);
            m_Info.t_strFontName = "chatFontSize11";
            m_Info.t_strText = " " $ string(SkillLevel);
            EndItem();
            // End:0x553
            if(Len(item.AdditionalName) > 0)
            {
                StartItem();
                m_Info.eType = 1;
                m_Info.nOffSetX = 5;
                m_Info.t_bDrawOneLine = true;
                m_Info.t_color.R = byte(255);
                m_Info.t_color.G = 217;
                m_Info.t_color.B = 105;
                m_Info.t_color.A = byte(255);
                m_Info.t_strFontName = "chatFontSize11";
                m_Info.t_strText = item.AdditionalName;
                EndItem();
            }
            AddTooltipItemBlank(1);
            AddTooltipColorText(Class'NWindow.UIDATA_SKILL'.static.GetOperateType(item.Id, item.Level, item.SubLevel), GetColor(176, 155, 121, 255), true, true, false, "", 38, -19);
            nTmp = Class'NWindow.UIDATA_SKILL'.static.GetHpConsume(item.Id, item.Level, item.SubLevel);
            // End:0x5FA
            if(nTmp > 0)
            {
                AddTooltipItemOption(1195, string(nTmp), true, true, false);
            }
            nTmp = Class'NWindow.UIDATA_SKILL'.static.GetMpConsume(item.Id, item.Level, item.SubLevel);
            // End:0x67D
            if(nTmp > 0)
            {
                AddTooltipItemOption(320, string(nTmp), true, true, false, "chatFontSize12", 0, 0, getInstanceL2Util().BrightWhite, getInstanceL2Util().ColorYellow);
            }
            nTmp = Class'NWindow.UIDATA_SKILL'.static.GetCastRange(item.Id, item.Level, item.SubLevel);
            // End:0x6D0
            if(nTmp >= 0)
            {
                AddTooltipItemOption(321, string(nTmp), true, true, false);
            }
            // End:0x71F
            if((SkillInfo.HitTime + SkillInfo.CoolTime) > float(0))
            {
                AddTooltipItemOption(2377, util.MakeTimeString(SkillInfo.HitTime, SkillInfo.CoolTime), true, true, false);
            }
            // End:0x751
            if(SkillInfo.ReuseDelay > float(0))
            {
                AddTooltipItemOption(2378, MakeBuffTimeStr(int(SkillInfo.ReuseDelay)), true, true, false);
            }
        }
        // End:0x82A
        if(nIsNoLevelTooltip == 0)
        {
            // End:0x79C
            if(Len(item.Description) > 0)
            {
                AddCrossLine();
                AddTooltipItemBlank(6);
                AddTooltipColorText(item.Description, GetColor(178, 190, 207, 255), true, false);
            }
            // End:0x82A
            if(Len(item.AdditionalName) > 0)
            {
                AddCrossLine();
                AddTooltipItemBlank(6);
                AddTooltipColorText(GetSystemString(3350) $ " : ", GetColor(163, 163, 163, 255), true, false);
                AddTooltipColorText(item.AdditionalName, GetColor(255, 217, 105, 255), false, true);
                AddTooltipColorText(SkillInfo.EnchantDesc, GetColor(178, 190, 207, 255), true, false);
                setTooltipMinimumWidth();
            }
        }        
    }
    else
    {
        return;
    }
    // End:0x8BA
    if((IsBuilderPC()) && DebugSectorBool("debug", "tooltipdebug"))
    {
        AddCrossLine();
        AddTooltipColorText("Client ID:" @ string(item.Id.ClassID), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("Icon:" @ item.IconName, GetColor(255, 215, 0, 255), true, false);
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_ABNORMALSTATUS(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;
    local int ShowLevel;
    local UIEventManager.EItemParamType EItemParamType;
    local SkillInfo SkillInfo;
    local bool IsToppingSkill;

    // End:0x701
    if(int(eSourceType) == 1)
    {
        ParseItemID(param, item.Id);
        ParseString(param, "Name", item.Name);
        ParseString(param, "AdditionalName", item.AdditionalName);
        ParseString(param, "Description", item.Description);
        ParseInt(param, "Level", item.Level);
        ParseInt(param, "SubLevel", item.SubLevel);
        ParseInt(param, "Reserved", item.Reserved);
        IsToppingSkill = Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(item.Id, item.Level, item.SubLevel);
        GetSkillInfo(item.Id.ClassID, item.Level, item.SubLevel, SkillInfo);
        EItemParamType = byte(item.ItemType);
        m_Tooltip.MinimumWidth = 154;
        StartItem();
        m_Info.eType = 1;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_strText = item.Name;
        EndItem();
        ShowLevel = item.Level;
        // End:0x2ED
        if(!IsToppingSkill)
        {
            StartItem();
            m_Info.eType = 1;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_strText = " ";
            EndItem();
            StartItem();
            m_Info.eType = 1;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = 163;
            m_Info.t_color.G = 163;
            m_Info.t_color.B = 163;
            m_Info.t_color.A = byte(255);
            m_Info.t_ID = 88;
            EndItem();
            StartItem();
            m_Info.eType = 1;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = 176;
            m_Info.t_color.G = 155;
            m_Info.t_color.B = 121;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = " " $ string(ShowLevel);
            EndItem();
        }
        // End:0x393
        if(Len(item.AdditionalName) > 0)
        {
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetX = 5;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = byte(255);
            m_Info.t_color.G = 217;
            m_Info.t_color.B = 105;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = item.AdditionalName;
            EndItem();
        }
        // End:0x5D4
        if(item.Reserved >= 0)
        {
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.bLineBreak = true;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = 163;
            m_Info.t_color.G = 163;
            m_Info.t_color.B = 163;
            m_Info.t_color.A = byte(255);
            m_Info.t_ID = 1199;
            EndItem();
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = 163;
            m_Info.t_color.G = 163;
            m_Info.t_color.B = 163;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = " : ";
            EndItem();
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = 176;
            m_Info.t_color.G = 155;
            m_Info.t_color.B = 121;
            m_Info.t_color.A = byte(255);
            // End:0x591
            if(IsToppingSkill)
            {
                m_Info.t_strText = MakeToppingBuffTimeStr(item.Reserved);
                ParamAdd(m_Info.Condition, "Type", "ToppingRemainTime");                
            }
            else
            {
                m_Info.t_strText = MakeBuffTimeStr(item.Reserved);
                ParamAdd(m_Info.Condition, "Type", "RemainTime");
            }
            EndItem();
        }
        // End:0x678
        if(Len(item.Description) > 0)
        {
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.bLineBreak = true;
            m_Info.t_color.R = 178;
            m_Info.t_color.G = 190;
            m_Info.t_color.B = 207;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = item.Description;
            EndItem();
        }
        // End:0x6FE
        if(Len(item.AdditionalName) > 0)
        {
            AddCrossLine();
            AddTooltipColorText(GetSystemString(3350) $ " : ", GetColor(163, 163, 163, 255), true, false);
            AddTooltipColorText(item.AdditionalName, GetColor(255, 217, 105, 255), false, true);
            AddTooltipColorText(SkillInfo.EnchantDesc, GetColor(178, 190, 207, 255), true, false);
            setTooltipMinimumWidth();
        }        
    }
    else
    {
        return;
    }
    // End:0x78E
    if((IsBuilderPC()) && DebugSectorBool("debug", "tooltipdebug"))
    {
        AddCrossLine();
        AddTooltipColorText("Client ID:" @ string(item.Id.ClassID), GetColor(255, 215, 0, 255), true, false);
        AddTooltipColorText("Icon:" @ item.IconName, GetColor(255, 215, 0, 255), true, false);
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_LOOCKCHANGEITEM(string param)
{
    local string Name;

    ParseString(param, "Name", Name);
    StartItem();
    m_Info.eType = 1;
    m_Info.t_strText = Name;
    EndItem();
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_SETITEM(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;

    // End:0x166
    if(int(eSourceType) == 1)
    {
        ParseString(param, "Name", item.Name);
        ParseString(param, "Description", item.Description);
        ParseString(param, "AdditionalName", item.AdditionalName);
        ParseInt(param, "CrystalType", item.CrystalType);
        AddTooltipItemName(item.Name, item, 1);
        AddTooltipItemGrade(item);
        // End:0x163
        if(Len(item.Description) > 0)
        {
            m_Tooltip.MinimumWidth = 154;
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.bLineBreak = true;
            m_Info.t_color.R = 178;
            m_Info.t_color.G = 190;
            m_Info.t_color.B = 207;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = item.Description;
            EndItem();
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_NORMALITEM(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;

    // End:0x166
    if(int(eSourceType) == 1)
    {
        ParseString(param, "Name", item.Name);
        ParseString(param, "Description", item.Description);
        ParseString(param, "AdditionalName", item.AdditionalName);
        ParseInt(param, "CrystalType", item.CrystalType);
        AddTooltipItemName(item.Name, item, 1);
        AddTooltipItemGrade(item);
        // End:0x163
        if(Len(item.Description) > 0)
        {
            m_Tooltip.MinimumWidth = 154;
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.bLineBreak = true;
            m_Info.t_color.R = 178;
            m_Info.t_color.G = 190;
            m_Info.t_color.B = 207;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = item.Description;
            EndItem();
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_HENNAITEM(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;
    local string bottomDesc;

    // End:0x22F
    if(int(eSourceType) == 1)
    {
        ParseString(param, "Name", item.Name);
        ParseString(param, "Description", item.Description);
        ParseString(param, "AdditionalName", item.AdditionalName);
        ParseInt(param, "CrystalType", item.CrystalType);
        m_Tooltip.MinimumWidth = 154;
        // End:0xC3
        if(item.CrystalType == 100)
        {
            bottomDesc = GetSystemString(7956);            
        }
        else
        {
            bottomDesc = GetSystemString(7951);
        }
        AddTooltipItemName(item.Name, item, 1);
        AddTooltipItemGrade(item);
        // End:0x199
        if(Len(item.Description) > 0)
        {
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.bLineBreak = true;
            m_Info.t_color.R = 178;
            m_Info.t_color.G = 190;
            m_Info.t_color.B = 207;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = item.Description;
            EndItem();
        }
        AddCrossLine();
        StartItem();
        m_Info.eType = 1;
        m_Info.nOffSetY = 6;
        m_Info.t_bDrawOneLine = false;
        m_Info.t_color.R = 163;
        m_Info.t_color.G = 163;
        m_Info.t_color.B = 163;
        m_Info.t_color.A = byte(255);
        m_Info.t_strText = bottomDesc;
        EndItem();        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_PREMIUMNORMALITEM(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;

    // End:0x37F
    if(int(eSourceType) == 1)
    {
        ParseString(param, "Name", item.Name);
        ParseString(param, "Description", item.Description);
        ParseString(param, "AdditionalName", item.AdditionalName);
        ParseInt(param, "CrystalType", item.CrystalType);
        ParseInt(param, "CurrentPeriod", item.CurrentPeriod);
        AddTooltipItemName(item.Name, item, 1);
        AddTooltipItemGrade(item);
        // End:0x187
        if(Len(item.Description) > 0)
        {
            m_Tooltip.MinimumWidth = 154;
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.bLineBreak = true;
            m_Info.t_color.R = 178;
            m_Info.t_color.G = 190;
            m_Info.t_color.B = 207;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = item.Description;
            EndItem();
        }
        // End:0x37C
        if(item.CurrentPeriod > 0)
        {
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.bLineBreak = true;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = 163;
            m_Info.t_color.G = 163;
            m_Info.t_color.B = 163;
            m_Info.t_color.A = byte(255);
            m_Info.t_ID = 1199;
            EndItem();
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = 163;
            m_Info.t_color.G = 163;
            m_Info.t_color.B = 163;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = " : ";
            EndItem();
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.bLineBreak = true;
            m_Info.t_color.R = 178;
            m_Info.t_color.G = 190;
            m_Info.t_color.B = 207;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = "" $ MakeTimeStr(item.CurrentPeriod);
            ParamAdd(m_Info.Condition, "Type", "PeriodTime");
            EndItem();
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_RECIPE(string param, UIEventManager.ETooltipSourceType eSourceType, bool bShowPrice)
{
    local ItemInfo item;
    local string strAdena, strAdenaComma;
    local Color AdenaColor;

    // End:0x2DF
    if(int(eSourceType) == 1)
    {
        ParseString(param, "Name", item.Name);
        ParseString(param, "Description", item.Description);
        ParseString(param, "AdditionalName", item.AdditionalName);
        ParseInt(param, "CrystalType", item.CrystalType);
        ParseInt(param, "Weight", item.Weight);
        ParseINT64(param, "Price", item.Price);
        AddTooltipItemName(item.Name, item, 1);
        AddTooltipItemGrade(item);
        // End:0x214
        if(bShowPrice)
        {
            strAdena = (item.Price);
            strAdenaComma = MakeCostString(strAdena);
            AdenaColor = GetNumericColor(strAdenaComma);
            AddTooltipItemOption(641, strAdenaComma $ " ", true, true, false);
            SetTooltipItemColor(int(AdenaColor.R), int(AdenaColor.G), int(AdenaColor.B), 0);
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color = AdenaColor;
            m_Info.t_ID = 469;
            EndItem();
            // End:0x214
            if(strAdena != "")
            {
                AddTooltipItemOption(0, ("(" $ ConvertNumToText(strAdena)) $ ")", false, true, false);
                SetTooltipItemColor(int(AdenaColor.R), int(AdenaColor.G), int(AdenaColor.B), 0);
            }
        }
        AddTooltipItemOption(52, string(item.Weight), true, true, false);
        // End:0x2DC
        if(Len(item.Description) > 0)
        {
            m_Tooltip.MinimumWidth = 154;
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.bLineBreak = true;
            m_Info.t_color.R = 178;
            m_Info.t_color.G = 190;
            m_Info.t_color.B = 207;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = item.Description;
            EndItem();
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_SHORTCUT(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;
    local UIEventManager.EItemParamType EItemParamType;
    local UIEventManager.EShortCutItemType eShortCutType;
    local string ItemName;
    local ShortcutCommandItem commandItem;
    local int ShortcutID;
    local string strShort;
    local OptionWnd script;

    script = OptionWnd(GetScript("OptionWnd"));
    strShort = ("<" $ GetSystemString(1523)) $ ": ";
    // End:0xA37
    if(int(eSourceType) == 1)
    {
        // End:0x454
        if(BoolSelect)
        {
            ParseInt(param, "ItemSubType", item.ItemSubType);
            ParseString(param, "Name", item.Name);
            ParseInt(param, "RefineryOp1", item.RefineryOp1);
            ParseInt(param, "RefineryOp2", item.RefineryOp2);
            eShortCutType = byte(item.ItemSubType);
            ItemName = Class'NWindow.UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);
            switch(eShortCutType)
            {
                // End:0x13E
                case 1:
                    ReturnTooltip_NTT_ITEM(param, "inventory", eSourceType);
                    // End:0x1D2
                    break;
                // End:0x143
                case 2:
                // End:0x15B
                case 7:
                    ReturnTooltip_NTT_SKILL(param, eSourceType);
                    // End:0x1D2
                    break;
                // End:0x160
                case 3:
                // End:0x179
                case 4:
                    ReturnTooltip_NTT_MACRO(param, eSourceType, true);
                    // End:0x1D2
                    break;
                // End:0x17E
                case 5:
                // End:0x1C9
                case 6:
                    m_Tooltip.MinimumWidth = 154;
                    StartItem();
                    m_Info.eType = 1;
                    m_Info.t_bDrawOneLine = true;
                    m_Info.t_strText = ItemName;
                    EndItem();
                    // End:0x1D2
                    break;
                // End:0xFFFF
                default:
                    // End:0x1D2
                    break;
                    break;
            }            
        }/* !MISMATCHING REMOVE, tried Switch got Type:If Position:0x045! */
        ParseInt(param, "ShortcutID", ShortcutID);
        // End:0x257
        if(GetChatFilterBool("Global", "EnterChatting"))
        {
            Class'NWindow.ShortcutAPI'.static.GetAssignedKeyFromCommand("TempStateShortcut", "UseShortcutItem Num=" $ string(ShortcutID), commandItem);            
        }
        else
        {
            Class'NWindow.ShortcutAPI'.static.GetAssignedKeyFromCommand("GamingStateShortcut", "UseShortcutItem Num=" $ string(ShortcutID), commandItem);
        }
        // End:0x2DB
        if(commandItem.subkey1 != "")
        {
            strShort = (strShort $ script.GetUserReadableKeyName(commandItem.subkey1)) $ "+";
        }
        // End:0x317
        if(commandItem.subkey2 != "")
        {
            strShort = (strShort $ script.GetUserReadableKeyName(commandItem.subkey2)) $ "+";
        }
        // End:0x353
        if(commandItem.Key != "")
        {
            strShort = (strShort $ script.GetUserReadableKeyName(commandItem.Key)) $ ">";
        }
        // End:0x3A4
        if(((commandItem.subkey1 == "") && commandItem.subkey2 == "") && commandItem.Key == "")
        {
            strShort = (strShort $ GetSystemString(27)) $ ">";
        }
        AddTooltipItemBlank(6);
        StartItem();
        m_Info.eType = 3;
        m_Info.u_nTextureWidth = 154;
        m_Info.u_nTextureHeight = 1;
        m_Info.u_strTexture = "L2ui_ch3.tooltip_line";
        EndItem();
        // End:0x44F
        if(ItemName != "")
        {
            AddTooltipItemBlank(5);
            StartItem();
            m_Info.eType = 1;
            m_Info.t_strText = strShort;
            EndItem();
            AddTooltipItemBlank(1);
            ReturnTooltipInfo(m_Tooltip);
        }
        return;        
    }
    else
    {
        ParseItemID(param, item.Id);
        ParseString(param, "Name", item.Name);
        ParseString(param, "AdditionalName", item.AdditionalName);
        ParseInt(param, "Level", item.Level);
        ParseInt(param, "SubLevel", item.SubLevel);
        ParseInt(param, "Reserved", item.Reserved);
        ParseInt(param, "Enchanted", item.Enchanted);
        ParseInt(param, "ItemType", item.ItemType);
        ParseInt(param, "ItemSubType", item.ItemSubType);
        ParseInt(param, "CrystalType", item.CrystalType);
        ParseInt(param, "ConsumeType", item.ConsumeType);
        ParseInt(param, "RefineryOp1", item.RefineryOp1);
        ParseInt(param, "RefineryOp2", item.RefineryOp2);
        ParseINT64(param, "ItemNum", item.ItemNum);
        ParseInt(param, "MpConsume", item.MpConsume);
        ParseInt(param, "IsBRPremium", item.IsBRPremium);
        eShortCutType = byte(item.ItemSubType);
        EItemParamType = byte(item.ItemType);
        ItemName = Class'NWindow.UIDATA_ITEM'.static.GetRefineryItemName(item.Name, item.RefineryOp1, item.RefineryOp2);
        switch(eShortCutType)
        {
            // End:0x6EF
            case 1:
                AddPrimeItemSymbol(item);
                AddTooltipItemEnchant(item);
                AddTooltipItemName(ItemName, item, 1);
                AddTooltipItemGrade(item);
                AddTooltipItemCount(item);
                // End:0xA34
                break;
            // End:0x6F4
            case 2:
            // End:0x9E1
            case 7:
                StartItem();
                m_Info.eType = 1;
                m_Info.t_bDrawOneLine = true;
                m_Info.t_strText = ItemName;
                EndItem();
                StartItem();
                m_Info.eType = 1;
                m_Info.t_bDrawOneLine = true;
                m_Info.t_strText = " ";
                EndItem();
                StartItem();
                m_Info.eType = 1;
                m_Info.t_bDrawOneLine = true;
                m_Info.t_color.R = 163;
                m_Info.t_color.G = 163;
                m_Info.t_color.B = 163;
                m_Info.t_color.A = byte(255);
                m_Info.t_ID = 88;
                EndItem();
                StartItem();
                m_Info.eType = 1;
                m_Info.t_bDrawOneLine = true;
                m_Info.t_color.R = 176;
                m_Info.t_color.G = 155;
                m_Info.t_color.B = 121;
                m_Info.t_color.A = byte(255);
                m_Info.t_strText = " " $ string(item.Level);
                EndItem();
                // End:0x912
                if(Len(item.AdditionalName) > 0)
                {
                    StartItem();
                    m_Info.eType = 1;
                    m_Info.nOffSetX = 5;
                    m_Info.t_bDrawOneLine = true;
                    m_Info.t_color.R = byte(255);
                    m_Info.t_color.G = 217;
                    m_Info.t_color.B = 105;
                    m_Info.t_color.A = byte(255);
                    m_Info.t_strText = item.AdditionalName;
                    EndItem();
                }
                StartItem();
                m_Info.eType = 1;
                m_Info.nOffSetX = -4;
                m_Info.bLineBreak = true;
                m_Info.t_bDrawOneLine = true;
                m_Info.t_strText = " (";
                EndItem();
                StartItem();
                m_Info.eType = 1;
                m_Info.t_bDrawOneLine = true;
                m_Info.t_ID = 91;
                EndItem();
                StartItem();
                m_Info.eType = 1;
                m_Info.t_bDrawOneLine = true;
                m_Info.t_strText = (":" $ string(item.MpConsume)) $ ")";
                EndItem();
                // End:0xA34
                break;
            // End:0x9E6
            case 3:
            // End:0x9EB
            case 4:
            // End:0x9F0
            case 5:
            // End:0xA2E
            case 6:
                StartItem();
                m_Info.eType = 1;
                m_Info.t_bDrawOneLine = true;
                m_Info.t_strText = ItemName;
                EndItem();
                // End:0xA34
                break;
            // End:0xFFFF
            default:
                // End:0xA34
                break;
                break;
        }
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0xA37
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0xA37
    ReturnTooltipInfo(m_Tooltip);
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0xA37
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0xA37
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0xA37
}

function ReturnTooltip_NTT_RECIPE_MANUFACTURE(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local ItemInfo item;

    // End:0x1D9
    if(int(eSourceType) == 1)
    {
        ParseString(param, "Name", item.Name);
        ParseString(param, "Description", item.Description);
        ParseString(param, "AdditionalName", item.AdditionalName);
        ParseINT64(param, "Reserved64", item.Reserved64);
        ParseInt(param, "CrystalType", item.CrystalType);
        ParseINT64(param, "ItemNum", item.ItemNum);
        m_Tooltip.MinimumWidth = 154;
        AddTooltipItemName(item.Name, item, 1);
        AddTooltipItemGrade(item);
        AddTooltipItemOption(736, (item.Reserved64), true, true, false);
        AddTooltipItemOption(737, (item.ItemNum), true, true, false);
        // End:0x1D6
        if(Len(item.Description) > 0)
        {
            StartItem();
            m_Info.eType = 1;
            m_Info.nOffSetY = 6;
            m_Info.bLineBreak = true;
            m_Info.t_color.R = 178;
            m_Info.t_color.G = 190;
            m_Info.t_color.B = 207;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = item.Description;
            EndItem();
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_CollectionItem(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local int i, item_id, collection_size, option_id, item_count, item_enchant,
	    collection_state, currentItemState;

    local string szReserved, collection_name, strStates, collectionStatusStr, opt1, opt2,
	    opt3;

    local array<string> strStatesData;
    local ItemInfo clearItem, item;
    local LVDataRecord Record;
    local Color Color;
    local CollectionAPI CollectionAPI;

    // End:0x645
    if(int(eSourceType) == 2)
    {
        CollectionAPI = CollectionAPI(GetScript("CollectionAPI"));
        m_Tooltip.MinimumWidth = 200;
        ParamToRecord(param, Record);
        ParseString(param, "szReserved", szReserved);
        ParseString(param, "collection_name", collection_name);
        ParseInt(param, "collection_state", collection_state);
        ParseInt(param, "collection_size", collection_size);
        ParseInt(param, "option_id", option_id);
        ParseString(param, "opt1", opt1);
        ParseString(param, "opt2", opt2);
        ParseString(param, "opt3", opt3);
        ParseString(param, "string_states", strStates);
        strStatesData = Arr(strStates, ",");
        AddTooltipItemBlank(1);
        AddTooltipColorText(collection_name, GetColor(255, 215, 0, 255), true, false, false, "HS12");
        AddCrossLine();
        AddTooltipItemBlank(2);
        switch(collection_state)
        {
            // End:0x1C4
            case 0:
                Color = GetColor(180, 80, 80, 255);
                collectionStatusStr = GetSystemString(7855);
                // End:0x250
                break;
            // End:0x1F0
            case 1:
                Color = GetColor(160, 70, 70, 255);
                collectionStatusStr = GetSystemString(7856);
                // End:0x250
                break;
            // End:0x21D
            case 2:
                Color = GetColor(110, 140, 160, 255);
                collectionStatusStr = GetSystemString(7857);
                // End:0x250
                break;
            // End:0x24A
            case 3:
                Color = GetColor(200, 180, 120, 255);
                collectionStatusStr = GetSystemString(7858);
                // End:0x250
                break;
            // End:0xFFFF
            default:
                // End:0x250
                break;
                break;
        }
        AddTooltipColorText(GetSystemString(7853), GetColor(255, 215, 0, 255), true, false, false, "HS10");
        AddTooltipItemBlank(2);
        AddTooltipColorText(collectionStatusStr, Color, true, false, false, "HS8");
        AddTooltipItemBlank(2);
        AddCrossLine();
        AddTooltipItemBlank(2);
        AddTooltipColorText(GetSystemString(7854), GetColor(255, 215, 0, 255), true, false, false, "HS10");
        AddTooltipItemBlank(2);
        i = 0;
        J0x2E3:

        // End:0x54A [Loop If]
        if(i < collection_size)
        {
            item = clearItem;
            ParseInt(param, "collection_item_" $ string(i), item_id);
            ParseInt(param, "collection_item_count_" $ string(i), item_count);
            ParseInt(param, "collection_item_enchant_" $ string(i), item_enchant);
            GetItemInfoByClassID(item_id, item);
            item.ItemNum = (item_count);
            item.Enchanted = item_enchant;
            // End:0x409
            if(item.Enchanted > 0)
            {
                addItemIcon(item, "L2_UI8.enchant.ench_number" $ string(item.Enchanted - 1));                
            }
            else
            {
                addItemIcon(item, "");
            }
            currentItemState = int(strStatesData[i]);
            // End:0x480
            if(currentItemState == 0)
            {
                addTooltipTexture("L2UI_CT1.Itemwindow.ItemWindow_IconEnchantDisable", 32, 32, 32, 32, false, false, -32, 0);                
            }
            else
            {
                // End:0x4CD
                if(currentItemState == 1)
                {
                    addTooltipTexture("L2UI_CT1.Itemwindow.ItemWindow_IconDisable", 32, 32, 32, 32, false, false, -32, 0);
                }
            }
            AddTooltipItemName((item.Name @ "x") $ string(item_count), item, 1, "chatFontSize11", 2 + 2, 1);
            // End:0x528
            if(__NFUN_409__(item.ItemNum, (0)))
            {
                AddTooltipItemCount(item, 0, 1);
            }
            AddTooltipItemGrade(item, -4, 0);
            AddTooltipItemBlank(1);
            i++;
            // [Loop Continue]
            goto J0x2E3;
        }
        AddTooltipItemBlank(2);
        AddCrossLine();
        AddTooltipItemBlank(1);
        AddTooltipColorText(GetSystemString(7859), GetColor(255, 215, 0, 255), true, false, false, "HS10");
        // End:0x5C2
        if(Len(opt1) > 0)
        {
            AddTooltipItemBlank(1);
            AddTooltipColorText("1) " $ opt1, GetColor(255, 255, 255, 255), true, false, false, "HS8");
        }
        // End:0x5FE
        if(Len(opt2) > 0)
        {
            AddTooltipItemBlank(1);
            AddTooltipColorText("2) " $ opt2, GetColor(255, 255, 255, 255), true, false, false, "HS8");
        }
        // End:0x63A
        if(Len(opt3) > 0)
        {
            AddTooltipItemBlank(1);
            AddTooltipColorText("3) " $ opt3, GetColor(255, 255, 255, 255), true, false, false, "HS8");
        }
        AddTooltipItemBlank(2);        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function CustomTooltip ReturnTooltip_NTT_QuitReportStatExp()
{
    local int i, startIndex, RealMinuteIndex;
    local INT64 CurrExp, PrevExp, diff, PrevDiff;
    local float PercentChange;
    local string startedTimeStr, timeStr, PercentStr, sign;
    local int startHour, StartMinute, CurrentHour, CurrentMinute, TotalMinutesFromStart;

    local QuitReportWnd QuitReportWnd;
    local array<INT64> expStats;
    local CustomTooltip ClearTooltip;

    QuitReportWnd = QuitReportWnd(GetScript("QuitReportWnd"));
    expStats = QuitReportWnd.Session.expPerMenute;
    startedTimeStr = QuitReportWnd.currentTimeString;
    m_Tooltip = ClearTooltip;
    m_Tooltip.MinimumWidth = 200;
    // End:0x77
    if(expStats.Length == 0)
    {
        return m_Tooltip;
    }
    startHour = int(Left(startedTimeStr, 2));
    StartMinute = int(Mid(startedTimeStr, 3, 2));
    // End:0xBC
    if(expStats.Length > 30)
    {
        expStats.Remove(0, expStats.Length - 30);        
    }
    else
    {
        startIndex = 0;
    }
    PrevExp = (0);
    PrevDiff = (0);
    i = 0;
    J0xDC:

    // End:0x36B [Loop If]
    if(i < expStats.Length)
    {
        RealMinuteIndex = startIndex + i;
        CurrExp = expStats[i];
        diff = CurrExp;
        TotalMinutesFromStart = StartMinute + RealMinuteIndex;
        CurrentHour = startHour + (TotalMinutesFromStart / 60);
        CurrentMinute = int(float(TotalMinutesFromStart) % float(60));
        CurrentHour = int(float(CurrentHour) % float(24));
        timeStr = (Right("0" $ string(CurrentHour), 2) $ ":") $ Right("0" $ string(CurrentMinute), 2);
        // End:0x1D1
        if(__NFUN_412__(diff, (0)))
        {
            AddTooltipColorText(timeStr $ "  -", GetColor(255, 215, 0, 255), true, false, false, "HS8");
            // [Explicit Continue]
            goto J0x361;
        }
        // End:0x243
        if((i == 0) || __NFUN_412__(expStats[i - 1], (0)))
        {
            AddTooltipColorText(((timeStr $ ": +") $ MakeCostStringINT64(diff)) $ "  (100%)", GetColor(255, 215, 0, 255), true, false, false, "HS8");
            PrevDiff = diff;            
        }
        else
        {
            // End:0x271
            if(__NFUN_413__(PrevDiff, (0)))
            {
                PercentChange = (100.0000000 * (diff)) / (PrevDiff);                
            }
            else
            {
                PercentChange = 100.0000000;
            }
            // End:0x295
            if(PercentChange >= float(0))
            {
                sign = "+";                
            }
            else
            {
                sign = "";
            }
            PercentStr = string(PercentChange);
            J0x2AA:

            // End:0x2FC [Loop If]
            if(((InStr(PercentStr, ".") != -1) && Right(PercentStr, 1) == "0") || Right(PercentStr, 1) == ".")
            {
                PercentStr = Left(PercentStr, Len(PercentStr) - 1);
                // [Loop Continue]
                goto J0x2AA;
            }
            AddTooltipColorText((((((timeStr $ ": +") $ MakeCostStringINT64(diff)) $ "  (") $ sign) $ PercentStr) $ "%)", GetColor(255, 215, 0, 255), true, false, false, "HS8");
            PrevDiff = diff;
        }
        PrevExp = CurrExp;
        J0x361:

        i++;
        // [Loop Continue]
        goto J0xDC;
    }
    return m_Tooltip;
    return;
}

function CustomTooltip ReturnTooltip_NTT_QuitReportStatAdena()
{
    local int i;
    local INT64 CurrAdena, diff, PrevDiff;
    local float PercentChange;
    local string startedTimeStr, timeStr, PercentStr, sign;
    local int startHour, StartMinute, CurrentHour, CurrentMinute, MinutesFromStart;

    local QuitReportWnd QuitReportWnd;
    local array<INT64> adenaStats;
    local CustomTooltip ClearTooltip;

    QuitReportWnd = QuitReportWnd(GetScript("QuitReportWnd"));
    adenaStats = QuitReportWnd.Session.adenaPerMinute;
    startedTimeStr = QuitReportWnd.currentTimeString;
    m_Tooltip = ClearTooltip;
    m_Tooltip.MinimumWidth = 200;
    // End:0x77
    if(adenaStats.Length == 0)
    {
        return m_Tooltip;
    }
    startHour = int(Left(startedTimeStr, 2));
    StartMinute = int(Mid(startedTimeStr, 3, 2));
    // End:0xB9
    if(adenaStats.Length > 60)
    {
        adenaStats.Remove(0, adenaStats.Length - 60);
    }
    PrevDiff = (0);
    i = 0;
    J0xC9:

    // End:0x357 [Loop If]
    if(i < adenaStats.Length)
    {
        CurrAdena = adenaStats[i];
        diff = CurrAdena;
        MinutesFromStart = (StartMinute + Max(0, adenaStats.Length - 60)) + i;
        CurrentHour = startHour + (MinutesFromStart / 60);
        CurrentMinute = int(float(MinutesFromStart) % float(60));
        CurrentHour = int(float(CurrentHour) % float(24));
        timeStr = (Right("0" $ string(CurrentHour), 2) $ ":") $ Right("0" $ string(CurrentMinute), 2);
        // End:0x1BB
        if(__NFUN_412__(diff, (0)))
        {
            AddTooltipColorText(timeStr $ "  -", GetColor(255, 215, 0, 255), true, false, false, "HS8");
            // [Explicit Continue]
            goto J0x34D;
        }
        // End:0x23A
        if((i == 0) || (i > 0) && __NFUN_412__(adenaStats[i - 1], (0)))
        {
            AddTooltipColorText(((timeStr $ ": +") $ MakeCostStringINT64(diff)) $ "  (100%)", GetColor(255, 215, 0, 255), true, false, false, "HS8");
            PrevDiff = diff;
            // [Explicit Continue]
            goto J0x34D;
        }
        // End:0x268
        if(__NFUN_413__(PrevDiff, (0)))
        {
            PercentChange = (100.0000000 * (diff)) / (PrevDiff);            
        }
        else
        {
            PercentChange = 100.0000000;
        }
        // End:0x28C
        if(PercentChange >= float(0))
        {
            sign = "+";            
        }
        else
        {
            sign = "";
        }
        PercentStr = string(PercentChange);
        J0x2A1:

        // End:0x2F3 [Loop If]
        if(((InStr(PercentStr, ".") != -1) && Right(PercentStr, 1) == "0") || Right(PercentStr, 1) == ".")
        {
            PercentStr = Left(PercentStr, Len(PercentStr) - 1);
            // [Loop Continue]
            goto J0x2A1;
        }
        AddTooltipColorText((((((timeStr $ ": +") $ MakeCostStringINT64(diff)) $ "  (") $ sign) $ PercentStr) $ "%)", GetColor(255, 215, 0, 255), true, false, false, "HS8");
        PrevDiff = diff;
        J0x34D:

        i++;
        // [Loop Continue]
        goto J0xC9;
    }
    return m_Tooltip;
    return;
}

function ReturnTooltip_NTT_FRIENDINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;

    // End:0x72
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[2].szData)), true, true, true);
        // End:0x6F
        if(Record.szReserved != "")
        {
            AddTooltipItemOption(403, Record.szReserved, true, true, true);
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_CLANINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;

    // End:0x7C
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[2].szData)), true, true, true);
        // End:0x79
        if(__NFUN_409__(Record.nReserved2, (0)))
        {
            AddTooltipItemOption(7766, ConvertTimetoStr(name(Record.nReserved2)), true, true, true);
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_AgitDecoList(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;
    local int nUse, totalCnt, i, nItemID, Period;

    local string toolTipParam, Desc;
    local INT64 nitemCount;

    // End:0x39E
    if(int(eSourceType) == 2)
    {
        m_Tooltip.MinimumWidth = 154 + 30;
        ParamToRecord(param, Record);
        // End:0x8B
        if(Record.LVDataList[0].szData == GetSystemString(869))
        {
            addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3440), getInstanceL2Util().White, "", false));
            ReturnTooltipInfo(m_Tooltip);
            return;
        }
        toolTipParam = param;
        ParseInt(toolTipParam, "totalCnt", totalCnt);
        ParseInt(toolTipParam, "period", Period);
        ParseString(toolTipParam, "desc", Desc);
        nUse = Record.LVDataList[0].nReserved2;
        // End:0x138
        if(nUse > 0)
        {
            addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().BrightWhite, "", false, true));            
        }
        else
        {
            addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().White, "", false, true));
        }
        AddCrossLine();
        addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3430), getInstanceL2Util().Yellow, "", true));
        addToolTipDrawList(m_Tooltip, addDrawItemText(Desc, getInstanceL2Util().ColorDesc, "", true));
        AddTooltipItemBlank(10);
        addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3442), getInstanceL2Util().ColorYellow, "", true, true));
        i = 0;
        J0x207:

        // End:0x2E8 [Loop If]
        if(i < totalCnt)
        {
            ParseInt(toolTipParam, "item_" $ string(i), nItemID);
            ParseINT64(toolTipParam, "count_" $ string(i), nitemCount);
            addToolTipDrawList(m_Tooltip, addDrawItemBlank(5));
            addToolTipDrawList(m_Tooltip, addDrawItemText(Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(nItemID)), getInstanceL2Util().White, "", true, true));
            addToolTipDrawList(m_Tooltip, addDrawItemText("x" @ MakeCostString((nitemCount)), getInstanceL2Util().White, "", true, true));
            i++;
            // [Loop Continue]
            goto J0x207;
        }
        // End:0x31F
        if(totalCnt <= 0)
        {
            addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(27), getInstanceL2Util().White, "", true, true));
        }
        addToolTipDrawList(m_Tooltip, addDrawItemBlank(10));
        addToolTipDrawList(m_Tooltip, addDrawItemText(GetSystemString(3431), getInstanceL2Util().ColorYellow, "", true));
        addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(3418), string(Period)), getInstanceL2Util().White, "", true));        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_LeaderControlList(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;
    local string toolTipParam, Desc, Name;
    local int ClassID, Status;
    local Color Color;
    local INT64 nitemCount;

    // End:0x124
    if(int(eSourceType) == 2)
    {
        m_Tooltip.MinimumWidth = 154 + 30;
        ParamToRecord(param, Record);
        ParseString(param, "Name", Name);
        ParseInt(param, "ClassId", ClassID);
        ParseInt(param, "Status", Status);
        addToolTipDrawList(m_Tooltip, addDrawItemText(Name, getInstanceL2Util().ColorDesc, "", false, true));
        AddCrossLine();
        addToolTipDrawList(m_Tooltip, addDrawItemText((GetClassRoleName(ClassID) $ " - ") $ GetClassType(ClassID), getInstanceL2Util().ColorDesc, "", false, true));
        AddCrossLine();
        getLeaderControlTypeString(Status, Desc, Color);
        addToolTipDrawList(m_Tooltip, addDrawItemText(Desc, Color, "", true));        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_EnsoulOptionList(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local EnsoulOptionUIInfo optionInfo;
    local LVDataRecord Record;
    local int optionId;

    // End:0x1EB
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        optionId = Record.LVDataList[0].nReserved2;
        // End:0x1AF
        if(optionId > 0)
        {
            GetEnsoulOptionUIInfo(optionId, optionInfo);
            addToolTipDrawList(m_Tooltip, addDrawItemTexture(optionInfo.IconPanelTex, false, false, 2));
            addToolTipDrawList(m_Tooltip, addDrawItemTexture(optionInfo.Icontex, false, false, -16));
            addToolTipDrawList(m_Tooltip, addDrawItemText("", getInstanceL2Util().White, "", false,, 4, 2));
            // End:0x118
            if(optionInfo.OptionStep > 0)
            {
                addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), getInstanceL2Util().White, "", false));                
            }
            else
            {
                addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Name, getInstanceL2Util().White, "", false));
            }
            addToolTipDrawList(m_Tooltip, addDrawItemText(" : ", getInstanceL2Util().White, "", false));
            addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Desc, getInstanceL2Util().ColorDesc, "", false));
            addToolTipDrawList(m_Tooltip, addDrawItemBlank(1));            
        }
        else
        {
            addToolTipDrawList(m_Tooltip, addDrawItemText(Record.LVDataList[0].szData, getInstanceL2Util().White, "", false,, 4, 2));
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_SellItemList(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    // End:0x2C
    if(int(eSourceType) == 2)
    {
        ReturnTooltip_NTT_ITEM(param, "SellItemList", 1);        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_CLANWARINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;
    local int Width1, Width2, Height, toolTipLineCount;

    toolTipLineCount = 0;
    // End:0x16D
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        switch(Record.LVDataList[1].nReserved1)
        {
            // End:0x3C
            case 0:
            // End:0x120
            case 1:
                StartItem();
                m_Info.eType = 1;
                m_Info.bLineBreak = true;
                m_Info.t_strText = (GetSystemString(1108) $ ": ") $ (getSecToDateStr(Record.LVDataList[6].nReserved1, false));
                EndItem();
                StartItem();
                m_Info.eType = 1;
                m_Info.bLineBreak = true;
                m_Info.t_strText = ((((GetSystemString(2986) $ ": ") $ string(Record.LVDataList[5].nReserved1)) $ "/") $ string(Record.LVDataList[5].nReserved2)) @ GetSystemString(1013);
                EndItem();
                // End:0x16A
                break;
            // End:0x164
            case 2:
                StartItem();
                m_Info.eType = 1;
                m_Info.bLineBreak = true;
                m_Info.t_strText = GetSystemString(7986);
                EndItem();
                // End:0x16A
                break;
            // End:0xFFFF
            default:
                // End:0x16A
                break;
                break;
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_POSTINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;

    // End:0x48
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[1].szData)), true, true, true);        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_ROOMLIST(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local int i;
    local LVDataRecord Record;
    local int Len;

    m_Tooltip.MinimumWidth = 154 + 30;
    // End:0x17C
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        Len = int(Record.LVDataList[5].szData);
        i = 0;
        J0x50:

        // End:0x179 [Loop If]
        if(i < Len)
        {
            StartItem();
            m_Info.eType = 2;
            m_Info.u_nTextureWidth = 11;
            m_Info.u_nTextureHeight = 11;
            m_Info.u_strTexture = GetClassRoleIconName(Record.LVDataList[7 + i].nReserved1);
            EndItem();
            StartItem();
            m_Info.eType = 1;
            m_Info.t_bDrawOneLine = false;
            m_Info.t_color.R = 163;
            m_Info.t_color.G = 163;
            m_Info.t_color.B = 163;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = " " $ Record.LVDataList[7 + i].szData;
            EndItem();
            // End:0x16F
            if(i != (Len - 1))
            {
                AddTooltipItemBlank(2);
            }
            i++;
            // [Loop Continue]
            goto J0x50;
        }        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_PrivateShopHistory(string param)
{
    local LVDataRecord Record;

    ParamToRecord(param, Record);
    // End:0x23
    if(Record.szReserved == "")
    {
        return;
    }
    StartItem();
    m_Info.eType = 1;
    m_Info.t_color.R = byte(name(Record.nReserved1));
    m_Info.t_color.G = byte(name(Record.nReserved2));
    m_Info.t_color.B = byte(name(Record.nReserved3));
    m_Info.t_color.A = byte(255);
    m_Info.t_strText = Record.szReserved;
    EndItem();
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_USERLIST(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;

    m_Tooltip.MinimumWidth = 154 + 70;
    // End:0x18F
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[1].szData)), true, true, true);
        AddTooltipItemBlank(0);
        StartItem();
        m_Info.eType = 1;
        m_Info.t_color.R = 163;
        m_Info.t_color.G = 163;
        m_Info.t_color.B = 163;
        m_Info.t_color.A = byte(255);
        m_Info.t_strText = GetSystemString(2276) $ " : ";
        EndItem();
        StartItem();
        m_Info.eType = 1;
        m_Info.t_color.R = 176;
        m_Info.t_color.G = 155;
        m_Info.t_color.B = 121;
        m_Info.t_color.A = byte(255);
        // End:0x169
        if(Record.LVDataList[4].szData == "")
        {
            m_Info.t_strText = GetSystemString(27);            
        }
        else
        {
            m_Info.t_strText = Record.LVDataList[4].szData;
        }
        EndItem();        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_PARTYMATCH(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;

    m_Tooltip.MinimumWidth = 154 + 70;
    // End:0x18F
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        AddTooltipItemOption(391, GetClassType(int(Record.LVDataList[1].szData)), true, true, true);
        AddTooltipItemBlank(0);
        StartItem();
        m_Info.eType = 1;
        m_Info.t_color.R = 163;
        m_Info.t_color.G = 163;
        m_Info.t_color.B = 163;
        m_Info.t_color.A = byte(255);
        m_Info.t_strText = GetSystemString(2276) $ " : ";
        EndItem();
        StartItem();
        m_Info.eType = 1;
        m_Info.t_color.R = 176;
        m_Info.t_color.G = 155;
        m_Info.t_color.B = 121;
        m_Info.t_color.A = byte(255);
        // End:0x169
        if(Record.LVDataList[3].szData == "")
        {
            m_Info.t_strText = GetSystemString(27);            
        }
        else
        {
            m_Info.t_strText = Record.LVDataList[3].szData;
        }
        EndItem();        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_UNIONLIST(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;

    // End:0x41
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        AddTooltipItemOption(391, GetClassType(name(Record.nReserved2)), true, true, true);        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_QUESTLIST(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;
    local int nTmp;

    // End:0x9B
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        AddTooltipItemOption(1200, Record.LVDataList[0].szData, true, true, true);
        switch(Record.LVDataList[3].nReserved1)
        {
            // End:0x55
            case 0:
            // End:0x68
            case 2:
                nTmp = 861;
                // End:0x85
                break;
            // End:0x6C
            case 1:
            // End:0x7F
            case 3:
                nTmp = 862;
                // End:0x85
                break;
            // End:0xFFFF
            default:
                // End:0x85
                break;
                break;
        }
        AddTooltipItemOption2(1202, nTmp, true, true, false);        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_RAIDLIST(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;

    // End:0xC7
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        // End:0x32
        if(Len(Record.szReserved) < 1)
        {
            return;
        }
        m_Tooltip.MinimumWidth = 154;
        StartItem();
        m_Info.eType = 1;
        m_Info.t_bDrawOneLine = false;
        m_Info.t_color.R = 178;
        m_Info.t_color.G = 190;
        m_Info.t_color.B = 207;
        m_Info.t_color.A = byte(255);
        m_Info.t_strText = Record.szReserved;
        EndItem();        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_QUESTINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;
    local int nTmp, Width1, Width2, Height;

    // End:0x225
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        AddTooltipItemOption(1200, Record.LVDataList[0].szData, true, true, true);
        AddTooltipItemOption(1201, Record.LVDataList[1].szData, true, true, false);
        GetTextSizeDefault((GetSystemString(1200) $ " : ") $ Record.LVDataList[0].szData, Width1, Height);
        GetTextSizeDefault((GetSystemString(1201) $ " : ") $ Record.LVDataList[1].szData, Width2, Height);
        // End:0xE0
        if(Width2 > Width1)
        {
            Width1 = Width2;
        }
        // End:0xF4
        if(154 > Width1)
        {
            Width1 = 154;
        }
        m_Tooltip.MinimumWidth = Width1 + 30;
        AddTooltipItemOption(922, Record.LVDataList[2].szData, true, true, false);
        switch(Record.LVDataList[3].nReserved1)
        {
            // End:0x140
            case 0:
            // End:0x153
            case 2:
                nTmp = 861;
                // End:0x170
                break;
            // End:0x157
            case 1:
            // End:0x16A
            case 3:
                nTmp = 862;
                // End:0x170
                break;
            // End:0xFFFF
            default:
                // End:0x170
                break;
                break;
        }
        AddTooltipItemOption2(1202, nTmp, true, true, false);
        StartItem();
        m_Info.eType = 1;
        m_Info.nOffSetY = 6;
        m_Info.t_bDrawOneLine = false;
        m_Info.bLineBreak = true;
        m_Info.t_color.R = 178;
        m_Info.t_color.G = 190;
        m_Info.t_color.B = 207;
        m_Info.t_color.A = byte(255);
        m_Info.t_strText = Record.szReserved;
        EndItem();        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_MANOR(string param, string TooltipType, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;
    local int idx1, idx2, idx3;

    // End:0x1E2
    if(int(eSourceType) == 2)
    {
        ParamToRecord(param, Record);
        // End:0x52
        if(TooltipType == "ManorSeedInfo")
        {
            idx1 = 4;
            idx2 = 5;
            idx3 = 6;            
        }
        else
        {
            // End:0x86
            if(TooltipType == "ManorCropInfo")
            {
                idx1 = 5;
                idx2 = 6;
                idx3 = 7;                
            }
            else
            {
                // End:0xBD
                if(TooltipType == "ManorSeedSetting")
                {
                    idx1 = 7;
                    idx2 = 8;
                    idx3 = 9;                    
                }
                else
                {
                    // End:0xF4
                    if(TooltipType == "ManorCropSetting")
                    {
                        idx1 = 9;
                        idx2 = 10;
                        idx3 = 11;                        
                    }
                    else
                    {
                        // End:0x12A
                        if(TooltipType == "ManorDefaultInfo")
                        {
                            idx1 = 1;
                            idx2 = 4;
                            idx3 = 5;                            
                        }
                        else
                        {
                            // End:0x15B
                            if(TooltipType == "ManorCropSell")
                            {
                                idx1 = 7;
                                idx2 = 8;
                                idx3 = 9;
                            }
                        }
                    }
                }
            }
        }
        AddTooltipItemOption(0, Record.LVDataList[0].szData, false, true, true);
        AddTooltipItemOption(537, Record.LVDataList[idx1].szData, true, true, false);
        AddTooltipItemOption(1134, Record.LVDataList[idx2].szData, true, true, false);
        AddTooltipItemOption(1135, Record.LVDataList[idx3].szData, true, true, false);        
    }
    else
    {
        return;
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function ReturnTooltip_NTT_QUESTREWARDS(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    ReturnTooltip_NTT_ITEM(param, "QuestReward", eSourceType);
    return;
}

function SetTooltipItemColor(int R, int G, int B, int offset)
{
    local int idx;

    idx = (m_Tooltip.DrawList.Length - 1) - offset;
    m_Tooltip.DrawList[idx].t_color.R = byte(R);
    m_Tooltip.DrawList[idx].t_color.G = byte(G);
    m_Tooltip.DrawList[idx].t_color.B = byte(B);
    m_Tooltip.DrawList[idx].t_color.A = byte(255);
    return;
}

function int AddTooltipItemEnchant(ItemInfo item, optional bool bFirstLineWidthCount, optional string FontName, optional int OffsetX, optional int OffsetY)
{
    local int nSumWidth, sizeWidth, sizeHeight;
    local UIEventManager.EItemParamType EItemParamType;

    EItemParamType = byte(item.ItemType);
    // End:0x132
    if((item.Enchanted > 0) && IsEnchantableItem(EItemParamType))
    {
        StartItem();
        m_Info.eType = 1;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_color.R = 170;
        m_Info.t_color.G = 110;
        m_Info.t_color.B = 230;
        m_Info.t_color.A = byte(255);
        m_Info.t_strText = "+" $ string(item.Enchanted);
        m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
        m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
        m_Info.t_strFontName = FontName;
        EndItem();
        GetTextSizeDefault(m_Info.t_strText, sizeWidth, sizeHeight);
        nSumWidth = nSumWidth + sizeWidth;
    }
    return nSumWidth;
    return;
}

function AddTooltipItemName(string Name, ItemInfo item, int AddTooltipItemName, optional string FontName, optional int OffsetX, optional int OffsetY)
{
    local string tmStr;

    StartItem();
    m_Info.eType = 1;
    m_Info.t_bDrawOneLine = true;
    switch(AddTooltipItemName)
    {
        // End:0x78
        case 0:
            m_Info.t_color.R = 137;
            m_Info.t_color.G = 137;
            m_Info.t_color.B = 137;
            m_Info.t_color.A = byte(255);
            // End:0x225
            break;
        // End:0xCF
        case 1:
            m_Info.t_color.R = byte(255);
            m_Info.t_color.G = byte(255);
            m_Info.t_color.B = byte(255);
            m_Info.t_color.A = byte(255);
            // End:0x225
            break;
        // End:0x123
        case 2:
            m_Info.t_color.R = byte(255);
            m_Info.t_color.G = 251;
            m_Info.t_color.B = 4;
            m_Info.t_color.A = byte(255);
            // End:0x225
            break;
        // End:0x175
        case 3:
            m_Info.t_color.R = 240;
            m_Info.t_color.G = 68;
            m_Info.t_color.B = 68;
            m_Info.t_color.A = byte(255);
            // End:0x225
            break;
        // End:0x1C9
        case 4:
            m_Info.t_color.R = 33;
            m_Info.t_color.G = 164;
            m_Info.t_color.B = byte(255);
            m_Info.t_color.A = byte(255);
            // End:0x225
            break;
        // End:0x21F
        case 5:
            m_Info.t_color.R = byte(255);
            m_Info.t_color.G = 0;
            m_Info.t_color.B = byte(255);
            m_Info.t_color.A = byte(255);
            // End:0x225
            break;
        // End:0xFFFF
        default:
            // End:0x225
            break;
            break;
    }
    m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
    m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
    m_Info.t_strText = Name;
    m_Info.t_strFontName = FontName;
    EndItem();
    // End:0x369
    if(Len(item.AdditionalName) > 0)
    {
        StartItem();
        m_Info.eType = 1;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_color.R = byte(255);
        m_Info.t_color.G = 217;
        m_Info.t_color.B = 105;
        m_Info.t_color.A = byte(255);
        m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
        m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
        m_Info.t_strFontName = FontName;
        m_Info.t_strText = " " $ item.AdditionalName;
        EndItem();
    }
    tmStr = GetEnsoulOptionNameAll(item);
    // End:0x456
    if(Len(tmStr) > 0)
    {
        StartItem();
        m_Info.eType = 1;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_color.R = byte(255);
        m_Info.t_color.G = 217;
        m_Info.t_color.B = 105;
        m_Info.t_color.A = byte(255);
        m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
        m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
        m_Info.t_strFontName = FontName;
        m_Info.t_strText = " " $ tmStr;
        EndItem();
    }
    return;
}

function AddTooltipItemGrade(ItemInfo item, optional int OffsetX, optional int OffsetY)
{
    local string TextureName;

    TextureName = GetItemGradeTextureName(item.CrystalType);
    // End:0x123
    if(Len(TextureName) > 0)
    {
        StartItem();
        m_Info.eType = 2;
        m_Info.u_strTexture = TextureName;
        m_Info.nOffSetX = (m_Info.nOffSetX + OffsetX) + 8;
        m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
        m_Info.u_nTextureHeight = 16;
        m_Info.u_nTextureUHeight = 16;
        // End:0x103
        if((((item.CrystalType == 6) || item.CrystalType == 7) || item.CrystalType == 9) || item.CrystalType == 10)
        {
            m_Info.u_nTextureWidth = 32;
            m_Info.u_nTextureUWidth = 32;            
        }
        else
        {
            m_Info.u_nTextureWidth = 16;
            m_Info.u_nTextureUWidth = 16;
        }
        EndItem();
    }
    return;
}

function AddTooltipItemCount(ItemInfo item, optional int OffsetX, optional int OffsetY)
{
    // End:0xE3
    if(IsStackableItem(item.ConsumeType))
    {
        StartItem();
        m_Info.eType = 1;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_strText = (" (" $ MakeCostString((item.ItemNum))) $ ")";
        m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
        m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
        m_Info.t_color.R = 176;
        m_Info.t_color.G = 155;
        m_Info.t_color.B = 121;
        m_Info.t_color.A = byte(255);
        EndItem();
    }
    return;
}

function GetRefineryColor(int Quality, out int R, out int G, out int B)
{
    switch(Quality)
    {
        // End:0x26
        case 1:
            R = 187;
            G = 181;
            B = 138;
            // End:0xA7
            break;
        // End:0x46
        case 2:
            R = 132;
            G = 174;
            B = 216;
            // End:0xA7
            break;
        // End:0x66
        case 3:
            R = 193;
            G = 112;
            B = 202;
            // End:0xA7
            break;
        // End:0x86
        case 4:
            R = 225;
            G = 109;
            B = 109;
            // End:0xA7
            break;
        // End:0xFFFF
        default:
            R = 187;
            G = 181;
            B = 138;
            // End:0xA7
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A7
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A7
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0A7
}

function AddTooltipItemAttributeGage(ItemInfo item)
{
    local int i;
    local array<string> TextureName, tooltipStr;

    i = 0;
    J0x07:

    // End:0x39 [Loop If]
    if(i < 6)
    {
        TextureName[i] = "";
        tooltipStr[i] = "";
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    NowAttrLv = 0;
    NowMaxValue = 0;
    NowValue = 0;
    // End:0x487
    if(item.AttackAttributeValue > 0)
    {
        AddCrossLine();
        SetAttackAttribute(item.AttackAttributeValue, 0);
        SetAttackAttribute(item.AttackAttributeValue, 1);
        SetAttackAttribute(item.AttackAttributeValue, 2);
        SetAttackAttribute(item.AttackAttributeValue, 3);
        SetAttackAttribute(item.AttackAttributeValue, 4);
        SetAttackAttribute(item.AttackAttributeValue, 5);
        switch(item.AttackAttributeType)
        {
            // End:0x172
            case 0:
                TextureName[0] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_FIRE";
                tooltipStr[0] = ((((((((GetSystemString(1622) $ " Lv ") $ string(AttackAttLevel[0])) $ " (") $ GetSystemString(1622)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x484
                break;
            // End:0x20B
            case 1:
                TextureName[1] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WATER";
                tooltipStr[1] = ((((((((GetSystemString(1623) $ " Lv ") $ string(AttackAttLevel[1])) $ " (") $ GetSystemString(1623)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x484
                break;
            // End:0x2A7
            case 2:
                TextureName[2] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WIND";
                tooltipStr[2] = ((((((((GetSystemString(1624) $ " Lv ") $ string(AttackAttLevel[2])) $ " (") $ GetSystemString(1624)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x484
                break;
            // End:0x344
            case 3:
                TextureName[3] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_EARTH";
                tooltipStr[3] = ((((((((GetSystemString(1625) $ " Lv ") $ string(AttackAttLevel[3])) $ " (") $ GetSystemString(1625)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x484
                break;
            // End:0x3E2
            case 4:
                TextureName[4] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DIVINE";
                tooltipStr[4] = ((((((((GetSystemString(1626) $ " Lv ") $ string(AttackAttLevel[4])) $ " (") $ GetSystemString(1626)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x484
                break;
            // End:0x47E
            case 5:
                TextureName[5] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DARK";
                tooltipStr[5] = ((((((((GetSystemString(1627) $ " Lv ") $ string(AttackAttLevel[5])) $ " (") $ GetSystemString(1627)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x484
                break;
            // End:0xFFFF
            default:
                // End:0x484
                break;
                break;
        }        
    }
    else
    {
        SetDefAttribute(item.DefenseAttributeValueFire, 0);
        SetDefAttribute(item.DefenseAttributeValueWater, 1);
        SetDefAttribute(item.DefenseAttributeValueWind, 2);
        SetDefAttribute(item.DefenseAttributeValueEarth, 3);
        SetDefAttribute(item.DefenseAttributeValueHoly, 4);
        SetDefAttribute(item.DefenseAttributeValueUnholy, 5);
        // End:0x5AC
        if(item.DefenseAttributeValueFire != 0)
        {
            // End:0x51B
            if(bLine == false)
            {
                AddCrossLine();
                bLine = true;
            }
            TextureName[0] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_FIRE";
            tooltipStr[0] = ((((((((GetSystemString(1623) $ " Lv ") $ string(DefAttLevel[0])) $ " (") $ GetSystemString(1622)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueFire)) $ ")";
        }
        // End:0x668
        if(item.DefenseAttributeValueWater != 0)
        {
            // End:0x5D6
            if(bLine == false)
            {
                AddCrossLine();
                bLine = true;
            }
            TextureName[1] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WATER";
            tooltipStr[1] = ((((((((GetSystemString(1622) $ " Lv ") $ string(DefAttLevel[1])) $ " (") $ GetSystemString(1623)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueWater)) $ ")";
        }
        // End:0x726
        if(item.DefenseAttributeValueWind != 0)
        {
            // End:0x692
            if(bLine == false)
            {
                AddCrossLine();
                bLine = true;
            }
            TextureName[2] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_WIND";
            tooltipStr[2] = ((((((((GetSystemString(1625) $ " Lv ") $ string(DefAttLevel[2])) $ " (") $ GetSystemString(1624)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueWind)) $ ")";
        }
        // End:0x7E5
        if(item.DefenseAttributeValueEarth != 0)
        {
            // End:0x750
            if(bLine == false)
            {
                AddCrossLine();
                bLine = true;
            }
            TextureName[3] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_EARTH";
            tooltipStr[3] = ((((((((GetSystemString(1624) $ " Lv ") $ string(DefAttLevel[3])) $ " (") $ GetSystemString(1625)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueEarth)) $ ")";
        }
        // End:0x8A5
        if(item.DefenseAttributeValueHoly != 0)
        {
            // End:0x80F
            if(bLine == false)
            {
                AddCrossLine();
                bLine = true;
            }
            TextureName[4] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DIVINE";
            tooltipStr[4] = ((((((((GetSystemString(1627) $ " Lv ") $ string(DefAttLevel[4])) $ " (") $ GetSystemString(1626)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueHoly)) $ ")";
        }
        // End:0x963
        if(item.DefenseAttributeValueUnholy != 0)
        {
            // End:0x8CF
            if(bLine == false)
            {
                AddCrossLine();
                bLine = true;
            }
            TextureName[5] = "L2UI_CT1.Gauges.Gauge_DF_Attribute_DARK";
            tooltipStr[5] = ((((((((GetSystemString(1626) $ " Lv ") $ string(DefAttLevel[5])) $ " (") $ GetSystemString(1627)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueUnholy)) $ ")";
        }
        bLine = false;
    }
    // End:0xB5B
    if(item.AttackAttributeValue > 0)
    {
        i = 0;
        J0x982:

        // End:0xB58 [Loop If]
        if(i < 6)
        {
            // End:0x9A3
            if(tooltipStr[i] == "")
            {
                // [Explicit Continue]
                goto J0xB4E;
            }
            StartItem();
            m_Info.eType = 1;
            // End:0x9D1
            if(i == 0)
            {
                m_Info.nOffSetY = 6;                
            }
            else
            {
                m_Info.nOffSetY = 10;
            }
            m_Info.bLineBreak = true;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_strText = tooltipStr[i];
            EndItem();
            StartItem();
            m_Info.eType = 2;
            m_Info.bLineBreak = true;
            m_Info.t_bDrawOneLine = true;
            m_Info.nOffSetX = 0;
            m_Info.nOffSetY = 2;
            m_Info.u_nTextureWidth = 140;
            m_Info.u_nTextureHeight = 7;
            m_Info.u_strTexture = TextureName[i] $ "_BG";
            EndItem();
            StartItem();
            m_Info.eType = 2;
            m_Info.bLineBreak = true;
            m_Info.t_bDrawOneLine = true;
            m_Info.nOffSetX = 0;
            m_Info.nOffSetY = -7;
            m_Info.u_nTextureWidth = (AttackAttCurrValue[i] * 140) / AttackAttMaxValue[i];
            // End:0xB25
            if(m_Info.u_nTextureWidth > 140)
            {
                m_Info.u_nTextureWidth = 140;
            }
            m_Info.u_nTextureHeight = 7;
            m_Info.u_strTexture = TextureName[i];
            EndItem();
            J0xB4E:

            i++;
            // [Loop Continue]
            goto J0x982;
        }        
    }
    else
    {
        i = 0;
        J0xB62:

        // End:0xD38 [Loop If]
        if(i < 6)
        {
            // End:0xB83
            if(tooltipStr[i] == "")
            {
                // [Explicit Continue]
                goto J0xD2E;
            }
            StartItem();
            m_Info.eType = 1;
            // End:0xBB1
            if(i == 0)
            {
                m_Info.nOffSetY = 6;                
            }
            else
            {
                m_Info.nOffSetY = 10;
            }
            m_Info.bLineBreak = true;
            m_Info.t_bDrawOneLine = true;
            m_Info.t_strText = tooltipStr[i];
            EndItem();
            StartItem();
            m_Info.eType = 2;
            m_Info.bLineBreak = true;
            m_Info.t_bDrawOneLine = true;
            m_Info.nOffSetX = 0;
            m_Info.nOffSetY = 2;
            m_Info.u_nTextureWidth = 140;
            m_Info.u_nTextureHeight = 7;
            m_Info.u_strTexture = TextureName[i] $ "_BG";
            EndItem();
            StartItem();
            m_Info.eType = 2;
            m_Info.bLineBreak = true;
            m_Info.t_bDrawOneLine = true;
            m_Info.nOffSetX = 0;
            m_Info.nOffSetY = -7;
            m_Info.u_nTextureWidth = (DefAttCurrValue[i] * 140) / DefAttMaxValue[i];
            // End:0xD05
            if(m_Info.u_nTextureWidth > 140)
            {
                m_Info.u_nTextureWidth = 140;
            }
            m_Info.u_nTextureHeight = 7;
            m_Info.u_strTexture = TextureName[i];
            EndItem();
            J0xD2E:

            i++;
            // [Loop Continue]
            goto J0xB62;
        }
    }
    return;
}

function AddTooltipItemCurrentPeriod(ItemInfo item)
{
    // End:0x1A9
    if(item.CurrentPeriod > 0)
    {
        AddCrossLine();
        AddTooltipItemBlank(0);
        // End:0x5B
        if((item.LookChangeItemID > 0) && item.Id.ClassID != 4442)
        {
            AddTooltipItemOption(5144, "", true, false, false);            
        }
        else
        {
            AddTooltipItemOption(1739, "", true, false, false);
        }
        SetTooltipItemColor(255, 255, 255, 0);
        AddTooltipItemBlank(0);
        addTexture("l2ui_ct1.SkillWnd_DF_ListIcon_use", 12, 11, 12, 11, 3, 7);
        AddTooltipColorText(GetSystemString(1199) $ " : ", GetColor(163, 163, 163, 255), false, true, false, "", 0, 6);
        StartItem();
        m_Info.eType = 1;
        m_Info.nOffSetY = 6;
        m_Info.bLineBreak = false;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_color.R = 178;
        m_Info.t_color.G = 190;
        m_Info.t_color.B = 207;
        m_Info.t_color.A = byte(255);
        m_Info.t_strText = MakeTimeStr(item.CurrentPeriod);
        ParamAdd(m_Info.Condition, "Type", "PeriodTime");
        EndItem();
    }
    return;
}

function setMakeTimeStrMaxWidth()
{
    local string timeStr;
    local int Width, Height;

    timeStr = (GetSystemString(1199) $ " : ") $ MakeTimeStr(1981320);
    GetTextSizeDefault(timeStr, Width, Height);
    // End:0x5E
    if(m_Tooltip.MinimumWidth < Width)
    {
        m_Tooltip.MinimumWidth = Width;
    }
    return;
}

function AddTooltipItemWeaponLookChange(ItemInfo item)
{
    local ItemInfo tmpInfo;

    // End:0x142
    if((item.LookChangeItemID > 0) && item.Id.ClassID != 4442)
    {
        AddCrossLine();
        // End:0x8C
        if(((item.BodyPart == 25) || item.BodyPart == 26) || item.BodyPart == 10)
        {
            AddTooltipItemOption(5115, "", true, false, false,,,, GetColor(230, 230, 230, 255));            
        }
        else
        {
            // End:0xC4
            if(int(byte(item.ItemType)) == 1)
            {
                AddTooltipItemOption(5101, "", true, false, false,,,, GetColor(230, 230, 230, 255));                
            }
            else
            {
                AddTooltipItemOption(5082, "", true, false, false,,,, GetColor(230, 230, 230, 255));
            }
        }
        AddTooltipItemBlank(0);
        Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(item.LookChangeItemID), tmpInfo);
        addItemIconSmallType(tmpInfo, "");
        AddTooltipColorText(item.LookChangeItemName, GetColor(0, 255, 0, 255), false, true, false, "", 3, 3);
    }
    return;
}

function AddTooltipItemQuestList(ItemInfo item)
{
    local int i, Count, QuestType;
    local string questTypeStr;

    i = 0;
    J0x07:

    // End:0x223 [Loop If]
    if(i < 10)
    {
        // End:0x219
        if(item.RelatedQuestID[i] > 0)
        {
            questTypeStr = "";
            switch(Class'NWindow.UIDATA_QUEST'.static.GetQuestIscategory(item.RelatedQuestID[i], 1))
            {
                // End:0x6B
                case 0:
                    questTypeStr = GetSystemString(862);
                    // End:0x128
                    break;
                // End:0xD7
                case 1:
                    QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(item.RelatedQuestID[i], 1);
                    // End:0xC3
                    if((QuestType == 4) || QuestType == 5)
                    {
                        questTypeStr = GetSystemString(2788);                        
                    }
                    else
                    {
                        questTypeStr = GetSystemString(861);
                    }
                    // End:0x128
                    break;
                // End:0xF0
                case 2:
                    questTypeStr = GetSystemString(1998);
                    // End:0x128
                    break;
                // End:0x109
                case 3:
                    questTypeStr = GetSystemString(1999);
                    // End:0x128
                    break;
                // End:0x122
                case 4:
                    questTypeStr = GetSystemString(2000);
                    // End:0x128
                    break;
                // End:0xFFFF
                default:
                    // End:0x128
                    break;
                    break;
            }
            // End:0x149
            if(questTypeStr != "")
            {
                questTypeStr = ("[" $ questTypeStr) $ "]";
            }
            // End:0x219
            if(Class'NWindow.UIDATA_QUEST'.static.GetQuestName(item.RelatedQuestID[i]) != "")
            {
                // End:0x1D0
                if(Count == 0)
                {
                    StartItem();
                    m_Info.eType = 1;
                    m_Info.nOffSetY = 6;
                    m_Info.bLineBreak = true;
                    m_Info.t_bDrawOneLine = true;
                    m_Info.t_strText = GetSystemString(1721);
                    EndItem();
                }
                Count++;
                AddTooltipColorText(questTypeStr @ Class'NWindow.UIDATA_QUEST'.static.GetQuestName(item.RelatedQuestID[i]), GetColor(163, 163, 163, 255), true, true, false, "", 0, 6);
            }
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function SetAttackAttribute(int Attvalue, int Type)
{
    // End:0x46
    if(Attvalue >= 375)
    {
        AttackAttLevel[Type] = 9;
        AttackAttMaxValue[Type] = 75;
        AttackAttCurrValue[Type] = Attvalue - 375;        
    }
    else
    {
        // End:0x8C
        if(Attvalue >= 325)
        {
            AttackAttLevel[Type] = 8;
            AttackAttMaxValue[Type] = 50;
            AttackAttCurrValue[Type] = Attvalue - 325;            
        }
        else
        {
            // End:0xD2
            if(Attvalue >= 300)
            {
                AttackAttLevel[Type] = 7;
                AttackAttMaxValue[Type] = 25;
                AttackAttCurrValue[Type] = Attvalue - 300;                
            }
            else
            {
                // End:0x112
                if(Attvalue >= 225)
                {
                    AttackAttLevel[Type] = 6;
                    AttackAttMaxValue[Type] = 75;
                    AttackAttCurrValue[Type] = Attvalue - 225;                    
                }
                else
                {
                    // End:0x152
                    if(Attvalue >= 175)
                    {
                        AttackAttLevel[Type] = 5;
                        AttackAttMaxValue[Type] = 50;
                        AttackAttCurrValue[Type] = Attvalue - 175;                        
                    }
                    else
                    {
                        // End:0x192
                        if(Attvalue >= 150)
                        {
                            AttackAttLevel[Type] = 4;
                            AttackAttMaxValue[Type] = 25;
                            AttackAttCurrValue[Type] = Attvalue - 150;                            
                        }
                        else
                        {
                            // End:0x1D2
                            if(Attvalue >= 75)
                            {
                                AttackAttLevel[Type] = 3;
                                AttackAttMaxValue[Type] = 75;
                                AttackAttCurrValue[Type] = Attvalue - 75;                                
                            }
                            else
                            {
                                // End:0x212
                                if(Attvalue >= 25)
                                {
                                    AttackAttLevel[Type] = 2;
                                    AttackAttMaxValue[Type] = 50;
                                    AttackAttCurrValue[Type] = Attvalue - 25;                                    
                                }
                                else
                                {
                                    AttackAttLevel[Type] = 1;
                                    AttackAttMaxValue[Type] = 25;
                                    AttackAttCurrValue[Type] = Attvalue;
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

function SetDefAttribute(int Defvalue, int Type)
{
    // End:0x40
    if(Defvalue >= 150)
    {
        DefAttLevel[Type] = 9;
        DefAttMaxValue[Type] = 30;
        DefAttCurrValue[Type] = Defvalue - 150;        
    }
    else
    {
        // End:0x80
        if(Defvalue >= 132)
        {
            DefAttLevel[Type] = 8;
            DefAttMaxValue[Type] = 18;
            DefAttCurrValue[Type] = Defvalue - 132;            
        }
        else
        {
            // End:0xC0
            if(Defvalue >= 120)
            {
                DefAttLevel[Type] = 7;
                DefAttMaxValue[Type] = 12;
                DefAttCurrValue[Type] = Defvalue - 120;                
            }
            else
            {
                // End:0x100
                if(Defvalue >= 90)
                {
                    DefAttLevel[Type] = 6;
                    DefAttMaxValue[Type] = 30;
                    DefAttCurrValue[Type] = Defvalue - 90;                    
                }
                else
                {
                    // End:0x140
                    if(Defvalue >= 72)
                    {
                        DefAttLevel[Type] = 5;
                        DefAttMaxValue[Type] = 18;
                        DefAttCurrValue[Type] = Defvalue - 72;                        
                    }
                    else
                    {
                        // End:0x180
                        if(Defvalue >= 60)
                        {
                            DefAttLevel[Type] = 4;
                            DefAttMaxValue[Type] = 12;
                            DefAttCurrValue[Type] = Defvalue - 60;                            
                        }
                        else
                        {
                            // End:0x1C0
                            if(Defvalue >= 30)
                            {
                                DefAttLevel[Type] = 3;
                                DefAttMaxValue[Type] = 30;
                                DefAttCurrValue[Type] = Defvalue - 30;                                
                            }
                            else
                            {
                                // End:0x200
                                if(Defvalue >= 12)
                                {
                                    DefAttLevel[Type] = 2;
                                    DefAttMaxValue[Type] = 18;
                                    DefAttCurrValue[Type] = Defvalue - 12;                                    
                                }
                                else
                                {
                                    DefAttLevel[Type] = 1;
                                    DefAttMaxValue[Type] = 12;
                                    DefAttCurrValue[Type] = Defvalue;
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

function AddTooltipBR_MaxEnergy(ItemInfo item)
{
    // End:0x170
    if(item.BR_MaxEnergy > 0)
    {
        AddTooltipItemBlank(6);
        AddTooltipItemOption(5065, "", true, false, false);
        SetTooltipItemColor(255, 255, 255, 0);
        AddTooltipColorText(GetSystemString(5066), GetColor(163, 163, 163, 255), true, true);
        StartItem();
        m_Info.eType = 1;
        m_Info.t_bDrawOneLine = true;
        m_Info.bLineBreak = true;
        // End:0xED
        if((item.BR_CurrentEnergy == 0) || (item.BR_MaxEnergy / item.BR_CurrentEnergy) > 10)
        {
            m_Info.t_color.R = byte(255);
            m_Info.t_color.G = 0;
            m_Info.t_color.B = 0;            
        }
        else
        {
            m_Info.t_color.R = 176;
            m_Info.t_color.G = 155;
            m_Info.t_color.B = 121;
        }
        m_Info.t_color.A = byte(255);
        m_Info.t_strText = " ";
        ParamAdd(m_Info.Condition, "Type", "CurrentEnergy");
        EndItem();
    }
    return;
}

function AddTooltipRefinery(ItemInfo item)
{
    local string strDesc1, strDesc2, strDesc3;
    local int ColorR, ColorG, ColorB, Quality;

    // End:0x359
    if((item.RefineryOp1 != 0) || item.RefineryOp2 != 0)
    {
        AddTooltipItemBlank(2);
        AddTooltipItemOption(1490, "", true, false, false);
        SetTooltipItemColor(255, 255, 255, 0);
        AddTooltipItemBlank(2);
        // End:0xA2
        if(__NFUN_412__(item.SlotBitType, (8192)))
        {
            Quality = Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp1);
            GetRefineryColor(Quality, ColorR, ColorG, ColorB);            
        }
        else
        {
            Quality = Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp2);
            GetRefineryColor(Quality, ColorR, ColorG, ColorB);
        }
        // End:0x1C4
        if(item.RefineryOp1 != 0)
        {
            strDesc1 = "";
            strDesc2 = "";
            strDesc3 = "";
            // End:0x1C4
            if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp1, strDesc1, strDesc2, strDesc3))
            {
                // End:0x160
                if(Len(strDesc1) > 0)
                {
                    AddTooltipColorText(strDesc1, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
                }
                // End:0x192
                if(Len(strDesc2) > 0)
                {
                    AddTooltipColorText(strDesc2, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
                }
                // End:0x1C4
                if(Len(strDesc3) > 0)
                {
                    AddTooltipColorText(strDesc3, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
                }
            }
        }
        // End:0x214
        if(__NFUN_412__(item.SlotBitType, (8192)))
        {
            Quality = Class'NWindow.UIDATA_REFINERYOPTION'.static.GetQuality(item.RefineryOp2);
            GetRefineryColor(Quality, ColorR, ColorG, ColorB);
        }
        // End:0x2FD
        if(item.RefineryOp2 != 0)
        {
            strDesc1 = "";
            strDesc2 = "";
            strDesc3 = "";
            // End:0x2FD
            if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(item.RefineryOp2, strDesc1, strDesc2, strDesc3))
            {
                // End:0x299
                if(Len(strDesc1) > 0)
                {
                    AddTooltipColorText(strDesc1, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
                }
                // End:0x2CB
                if(Len(strDesc2) > 0)
                {
                    AddTooltipColorText(strDesc2, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
                }
                // End:0x2FD
                if(Len(strDesc3) > 0)
                {
                    AddTooltipColorText(strDesc3, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
                }
            }
        }
        // End:0x351
        if(!getInstanceUIData().getIsClassicServer() && __NFUN_413__(item.SlotBitType, (8192)))
        {
            AddTooltipItemOption(1491, "", true, false, false);
            SetTooltipItemColor(ColorR, ColorG, ColorB, 0);
        }
        AddTooltipItemBlank(2);
    }
    return;
}

function AddWeaponEnsoulOption(ItemInfo weaponInfo)
{
    local EnsoulOptionUIInfo optionInfo;
    local int i, N, Cnt, optionId;
    local bool bUseTitle;

    // End:0x12
    if(weaponInfo.ItemType != 0)
    {
        return;
    }
    bUseTitle = true;
    i = 1;
    J0x21:

    // End:0x247 [Loop If]
    if(i < 3)
    {
        Cnt = weaponInfo.EnsoulOption[i - 1].OptionArray.Length;
        N = 1;
        J0x53:

        // End:0x23D [Loop If]
        if(N < (1 + Cnt))
        {
            optionId = weaponInfo.EnsoulOption[i - 1].OptionArray[N - 1];
            // End:0x233
            if(optionId > 0)
            {
                // End:0xDB
                if(bUseTitle)
                {
                    AddTooltipItemBlank(6);
                    AddCrossLine();
                    AddTooltipItemBlank(5);
                    AddTooltipItemOption(3394, "", true, false, false);
                    SetTooltipItemColor(255, 255, 255, 0);
                    bUseTitle = false;
                }
                GetEnsoulOptionUIInfo(optionId, optionInfo);
                addToolTipDrawList(m_Tooltip, addDrawItemBlank(3));
                addToolTipDrawList(m_Tooltip, addDrawItemTexture(optionInfo.IconPanelTex, false, true, 2));
                addToolTipDrawList(m_Tooltip, addDrawItemTexture(optionInfo.Icontex, false, false, -16));
                addToolTipDrawList(m_Tooltip, addDrawItemText("", getInstanceL2Util().White, "", false,, 4, 2));
                // End:0x1C6
                if(optionInfo.OptionStep > 0)
                {
                    addToolTipDrawList(m_Tooltip, addDrawItemText(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), getInstanceL2Util().ColorYellow, "", false));                    
                }
                else
                {
                    addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Name, getInstanceL2Util().ColorYellow, "", false));
                }
                addToolTipDrawList(m_Tooltip, addDrawItemText(optionInfo.Desc, getInstanceL2Util().ColorGray, "", true));
                addToolTipDrawList(m_Tooltip, addDrawItemBlank(3));
            }
            N++;
            // [Loop Continue]
            goto J0x53;
        }
        i++;
        // [Loop Continue]
        goto J0x21;
    }
    return;
}

function AddTooltipEventSeventhdayOfSeventhMonth(ItemInfo item)
{
    local int useHeadTitle;

    // End:0x73
    if(((item.EnchantOption1 != 0) || item.EnchantOption2 != 0) || item.EnchantOption3 != 0)
    {
        addDescEventSeventhday(item.EnchantOption1, useHeadTitle);
        addDescEventSeventhday(item.EnchantOption2, useHeadTitle);
        addDescEventSeventhday(item.EnchantOption3, useHeadTitle);
    }
    return;
}

function addDescEventSeventhday(int nEnchantOption, out int useHeadTitle)
{
    local string strDesc1, strDesc2, strDesc3;
    local int ColorR, ColorG, ColorB;

    // End:0x16A
    if(nEnchantOption != 0)
    {
        strDesc1 = "";
        strDesc2 = "";
        strDesc3 = "";
        // End:0x16A
        if(Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(nEnchantOption, strDesc1, strDesc2, strDesc3))
        {
            // End:0xB3
            if(((Len(strDesc1) > 0) || Len(strDesc2) > 0) || Len(strDesc3) > 0)
            {
                // End:0xB3
                if(useHeadTitle == 0)
                {
                    useHeadTitle = 1;
                    AddTooltipItemBlank(6);
                    AddTooltipItemOption(2214, "", true, false, false);
                    SetTooltipItemColor(255, 255, 255, 0);
                    AddTooltipItemBlank(6);
                }
            }
            // End:0xD4
            if(nEnchantOption != 0)
            {
                GetRefineryColor(1, ColorR, ColorG, ColorB);
            }
            // End:0x106
            if(Len(strDesc1) > 0)
            {
                AddTooltipColorText(strDesc1, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
            }
            // End:0x138
            if(Len(strDesc2) > 0)
            {
                AddTooltipColorText(strDesc2, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
            }
            // End:0x16A
            if(Len(strDesc3) > 0)
            {
                AddTooltipColorText(strDesc3, GetColor(ColorR, ColorG, ColorB, 255), true, false, false);
            }
        }
    }
    return;
}

function AddTooltipItemDurability(ItemInfo item)
{
    local Color tempColor;

    // End:0xDE
    if((item.CurrentDurability >= 0) && item.Durability > 0)
    {
        AddTooltipItemBlank(6);
        AddTooltipItemOption(1492, "", true, false, false);
        SetTooltipItemColor(255, 255, 255, 0);
        AddTooltipColorText(GetSystemString(1493), GetColor(163, 163, 163, 255), true, true);
        // End:0x91
        if((item.CurrentDurability + 1) <= 5)
        {
            tempColor = GetColor(255, 0, 0, 255);            
        }
        else
        {
            tempColor = GetColor(176, 155, 121, 255);
        }
        AddTooltipColorText(((" " $ string(item.CurrentDurability)) $ "/") $ string(item.Durability), tempColor, false, true);
        AddTooltipItemBlank(6);
    }
    return;
}

function int AddPrimeItemSymbol(ItemInfo item, optional bool bFirstLineWidthCount)
{
    local int nSumWidth;
    local string TextureName;

    // End:0x17
    if(item.IsBRPremium != 2)
    {
        return nSumWidth;
    }
    TextureName = GetPrimeItemSymbolName();
    // End:0xC9
    if(Len(TextureName) > 0)
    {
        StartItem();
        m_Info.eType = 2;
        m_Info.nOffSetX = 4;
        m_Info.nOffSetY = 1;
        m_Info.u_nTextureWidth = 14;
        m_Info.u_nTextureHeight = 14;
        m_Info.u_nTextureUWidth = 14;
        m_Info.u_nTextureUHeight = 14;
        m_Info.u_strTexture = TextureName;
        EndItem();
        nSumWidth = (nSumWidth + m_Info.u_nTextureUWidth) + m_Info.nOffSetX;
    }
    return nSumWidth;
    return;
}

function addSetitemTooltip(ItemInfo item)
{
    local int i, j;
    local string strTmp;
    local ItemID tmpItemID;
    local int setId, totalNum;
    local bool IsSigil;
    local ItemInfo tmpInfo;

    // End:0x881
    if(IsValidItemID(item.Id))
    {
        SetItemLineInsert(item.Id, 0);
        AddTooltipItemBlank(4);
        i = 0;
        J0x33:

        // End:0x354 [Loop If]
        if(i < 3)
        {
            setId = 0;
            J0x46:

            // End:0x34A [Loop If]
            if(setId < Class'NWindow.UIDATA_ITEM'.static.GetSetItemNum(item.Id, i))
            {
                tmpItemID.ClassID = Class'NWindow.UIDATA_ITEM'.static.GetSetItemFirstID(item.Id, i, setId);
                // End:0x340
                if(tmpItemID.ClassID > 0)
                {
                    strTmp = Class'NWindow.UIDATA_ITEM'.static.GetItemName(tmpItemID);
                    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(tmpItemID, tmpInfo);
                    addItemIconSmallType(tmpInfo, "");
                    StartItem();
                    m_Info.eType = 1;
                    m_Info.nOffSetY = 4;
                    m_Info.bLineBreak = false;
                    m_Info.t_bDrawOneLine = false;
                    SetTooltipTextColor(100, 100, 65, 255);
                    // End:0x231
                    if(i == 0)
                    {
                        m_Info.t_strText = " " $ strTmp;
                        ParamAdd(m_Info.Condition, "SetItemNum", string(i));
                        ParamAdd(m_Info.Condition, "Type", "Equip");
                        ParamAddItemID(m_Info.Condition, item.Id);
                        ParamAdd(m_Info.Condition, "CurTypeID", string(setId));
                        ParamAdd(m_Info.Condition, "NormalColor", "100,100,65");
                        ParamAdd(m_Info.Condition, "EnableColor", "255,250,160");
                        totalNum = setId;                        
                    }
                    else
                    {
                        // End:0x333
                        if(i == 1)
                        {
                            m_Info.t_strText = "- (+) " $ strTmp;
                            ParamAdd(m_Info.Condition, "SetItemNum", string(i));
                            ParamAdd(m_Info.Condition, "Type", "Equip");
                            ParamAddItemID(m_Info.Condition, item.Id);
                            ParamAdd(m_Info.Condition, "CurTypeID", string(setId));
                            ParamAdd(m_Info.Condition, "NormalColor", "100,70,0");
                            ParamAdd(m_Info.Condition, "EnableColor", "255,180,0");
                            IsSigil = IsSigilArmor(tmpItemID);
                        }
                    }
                    EndItem();
                    AddTooltipItemBlank(1);
                }
                setId++;
                // [Loop Continue]
                goto J0x46;
            }
            i++;
            // [Loop Continue]
            goto J0x33;
        }
        i = 0;
        J0x35B:

        // End:0x6D0 [Loop If]
        if(i < 3)
        {
            j = 0;
            J0x36E:

            // End:0x6C6 [Loop If]
            if(j < Class'NWindow.UIDATA_ITEM'.static.GetSetItemPeaceEffectNum(item.Id, i))
            {
                StartItem();
                m_Info.eType = 1;
                m_Info.nOffSetY = 6;
                m_Info.bLineBreak = true;
                m_Info.t_bDrawOneLine = true;
                SetTooltipTextColor(100, 70, 0, 255);
                // End:0x415
                if(i == 0)
                {
                    m_Info.t_strText = (string(j + 2) $ GetSystemString(2345)) $ " : ";                    
                }
                else
                {
                    // End:0x4A3
                    if(i == 1)
                    {
                        // End:0x469
                        if(IsSigil == true)
                        {
                            m_Info.t_strText = (((string(totalNum + 1) $ GetSystemString(2345)) $ "+") $ GetSystemString(1987)) $ ": ";                            
                        }
                        else
                        {
                            m_Info.t_strText = (((string(totalNum + 1) $ GetSystemString(2345)) $ "+") $ GetSystemString(2346)) $ ": ";
                        }
                    }
                }
                ParamAdd(m_Info.Condition, "Type", "SetEffect");
                ParamAddItemID(m_Info.Condition, item.Id);
                ParamAdd(m_Info.Condition, "EffectID", string(i));
                ParamAdd(m_Info.Condition, "SetEffectIndex", string(j));
                ParamAdd(m_Info.Condition, "NormalColor", "100,70,0");
                ParamAdd(m_Info.Condition, "EnableColor", "255,180,0");
                EndItem();
                strTmp = Class'NWindow.UIDATA_ITEM'.static.GetSetItemPeaceEffectDescription(item.Id, i, j);
                StartItem();
                m_Info.eType = 1;
                m_Info.nOffSetY = 6;
                SetTooltipTextColor(68, 68, 68, 255);
                m_Info.t_strText = strTmp;
                ParamAdd(m_Info.Condition, "Type", "SetEffect");
                ParamAddItemID(m_Info.Condition, item.Id);
                ParamAdd(m_Info.Condition, "EffectID", string(i));
                ParamAdd(m_Info.Condition, "SetEffectIndex", string(j));
                ParamAdd(m_Info.Condition, "NormalColor", "68,68,68");
                ParamAdd(m_Info.Condition, "EnableColor", "170,170,170");
                EndItem();
                j++;
                // [Loop Continue]
                goto J0x36E;
            }
            i++;
            // [Loop Continue]
            goto J0x35B;
        }
        j = 0;
        J0x6D7:

        // End:0x881 [Loop If]
        if(j < Class'NWindow.UIDATA_ITEM'.static.GetItemSetEnchantEffectNum(item.Id))
        {
            strTmp = Class'NWindow.UIDATA_ITEM'.static.GetSetItemEnchantEffectDescription(item.Id, j);
            // End:0x877
            if(Len(strTmp) > 0)
            {
                StartItem();
                m_Info.eType = 1;
                m_Info.nOffSetY = 6;
                m_Info.bLineBreak = true;
                m_Info.t_color.R = 110;
                m_Info.t_color.G = 140;
                m_Info.t_color.B = 170;
                m_Info.t_color.A = byte(255);
                m_Info.t_strText = strTmp;
                ParamAdd(m_Info.Condition, "Type", "EnchantEffect");
                ParamAddItemID(m_Info.Condition, item.Id);
                ParamAdd(m_Info.Condition, "NormalColor", "74,92,104");
                ParamAdd(m_Info.Condition, "EnableColor", "110,140,170");
                ParamAdd(m_Info.Condition, "SetEnchantEffectIndex", string(j));
                EndItem();
            }
            j++;
            // [Loop Continue]
            goto J0x6D7;
        }
    }
    return;
}

function SetItemLineInsert(ItemID Id, int setId)
{
    // End:0x94
    if(Class'NWindow.UIDATA_ITEM'.static.GetSetItemPeaceEffectNum(Id, setId) != 0)
    {
        BSetItem = true;
        AddCrossLine();
        StartItem();
        m_Info.eType = 1;
        m_Info.nOffSetY = 6;
        m_Info.bLineBreak = true;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_strText = GetSystemString(2347);
        SetTooltipTextColor(230, 230, 230, 255);
        EndItem();        
    }
    else
    {
        BSetItem = false;
    }
    return;
}

function string getSecToDateStr(int Sec, bool onlyDayFlag)
{
    local string returnStr;
    local int RemainSec, m_timeDay, m_timeHour, m_timeMin;
    local string hourStr, MinStr, dayStr;

    m_timeDay = Sec / 86400;
    RemainSec = int(float(Sec) % float(86400));
    m_timeHour = RemainSec / 3600;
    m_timeMin = int(float(RemainSec / 60) % float(60));
    returnStr = "";
    // End:0x94
    if(m_timeDay > 0)
    {
        dayStr = string(m_timeDay) $ GetSystemString(1109);
        returnStr = returnStr $ dayStr;
    }
    // End:0x150
    if(onlyDayFlag == false)
    {
        // End:0xBC
        if(returnStr != "")
        {
            returnStr = returnStr $ " ";
        }
        // End:0xDD
        if(m_timeHour < 10)
        {
            hourStr = "0" $ string(m_timeHour);            
        }
        else
        {
            hourStr = string(m_timeHour);
        }
        // End:0x10B
        if(m_timeMin < 10)
        {
            MinStr = "0" $ string(m_timeMin);            
        }
        else
        {
            MinStr = string(m_timeMin);
        }
        returnStr = ((((returnStr $ hourStr) $ GetSystemString(1110)) $ " ") $ MinStr) $ GetSystemString(1111);
    }
    return returnStr;
    return;
}

function string getWarSituationString(int warSituation)
{
    local string returnStr;

    switch(warSituation)
    {
        // End:0x26
        case 0:
            returnStr = returnStr $ GetSystemString(2355);
            // End:0xAB
            break;
        // End:0x45
        case 1:
            returnStr = returnStr $ GetSystemString(2354);
            // End:0xAB
            break;
        // End:0x65
        case 2:
            returnStr = returnStr $ GetSystemString(2353);
            // End:0xAB
            break;
        // End:0x85
        case 3:
            returnStr = returnStr $ GetSystemString(2352);
            // End:0xAB
            break;
        // End:0xA5
        case 4:
            returnStr = returnStr $ GetSystemString(2351);
            // End:0xAB
            break;
        // End:0xFFFF
        default:
            // End:0xAB
            break;
            break;
    }
    return returnStr;
    return;
}

function bool IsEnchantableItem(UIEventManager.EItemParamType Type)
{
    return (((int(Type) == 0) || int(Type) == 1) || int(Type) == 3) || int(Type) == 2;
    return;
}

function ClearTooltip()
{
    m_Tooltip.SimpleLineCount = 0;
    m_Tooltip.MinimumWidth = 0;
    m_Tooltip.DrawList.Remove(0, m_Tooltip.DrawList.Length);
    return;
}

function StartItem()
{
    local DrawItemInfo infoClear;

    m_Info = infoClear;
    return;
}

function EndItem()
{
    m_Tooltip.DrawList.Length = m_Tooltip.DrawList.Length + 1;
    m_Tooltip.DrawList[m_Tooltip.DrawList.Length - 1] = m_Info;
    return;
}

function SetTooltipTextColor(int R, int G, int B, int A)
{
    m_Info.t_color.R = byte(R);
    m_Info.t_color.G = byte(G);
    m_Info.t_color.B = byte(B);
    m_Info.t_color.A = byte(A);
    return;
}

function SetTooltipText(string strDesc, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine)
{
    m_Info.eType = 1;
    // End:0x25
    if(!isFirstLine)
    {
        m_Info.nOffSetY = 6;
    }
    m_Info.t_strText = strDesc;
    m_Info.bLineBreak = bLineBreak;
    m_Info.t_bDrawOneLine = t_bDrawOneLine;
    return;
}

function AddCrossLine(optional int minimum_width)
{
    AddTooltipItemBlank(4);
    StartItem();
    m_Info.eType = 3;
    // End:0x39
    if(minimum_width > 0)
    {
        m_Info.u_nTextureWidth = minimum_width;        
    }
    else
    {
        m_Info.u_nTextureWidth = 154;
    }
    m_Info.u_nTextureHeight = 1;
    m_Info.u_strTexture = "L2ui_ch3.tooltip_line";
    EndItem();
    AddTooltipItemBlank(4);
    return;
}

function AddTooltipText(string strDesc, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine, optional string FontName, optional int OffsetX, optional int OffsetY)
{
    StartItem();
    m_Info.eType = 1;
    // End:0x2B
    if(!isFirstLine)
    {
        m_Info.nOffSetY = 6;
    }
    m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
    m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
    m_Info.t_strFontName = FontName;
    m_Info.t_strText = strDesc;
    m_Info.bLineBreak = bLineBreak;
    m_Info.t_bDrawOneLine = t_bDrawOneLine;
    EndItem();
    return;
}

function AddTooltipColorText(string strDesc, Color TextColor, bool bLineBreak, bool t_bDrawOneLine, optional bool isFirstLine, optional string FontName, optional int OffsetX, optional int OffsetY)
{
    StartItem();
    m_Info.eType = 1;
    // End:0x2B
    if(!isFirstLine)
    {
        m_Info.nOffSetY = 6;
    }
    m_Info.bLineBreak = bLineBreak;
    m_Info.t_bDrawOneLine = t_bDrawOneLine;
    m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
    m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
    m_Info.t_strFontName = FontName;
    m_Info.t_color = TextColor;
    m_Info.t_strText = strDesc;
    m_Info.nOffSetX = OffsetX;
    m_Info.nOffSetY = OffsetY;
    EndItem();
    return;
}

function AddAgathionSkillTooltip(ItemInfo Info)
{
    local array<SkillInfo> mainSkillList, subSkillList;
    local int i;
    local Color titleColor, DescColor;

    GetAgathionMainSkillList(Info.Id.ClassID, Info.Enchanted, mainSkillList);
    GetAgathionSubSkillList(Info.Id.ClassID, Info.Enchanted, subSkillList);
    // End:0x1C7
    if(mainSkillList.Length > 0)
    {
        // End:0xDB
        if((GetAgathionIndex(Info.Id)) == 0)
        {
            titleColor.R = byte(255);
            titleColor.G = 153;
            titleColor.B = 153;
            titleColor.A = byte(255);
            DescColor.R = 153;
            DescColor.G = 153;
            DescColor.B = 153;
            DescColor.A = byte(255);            
        }
        else
        {
            titleColor.R = 100;
            titleColor.G = 70;
            titleColor.B = 70;
            titleColor.A = byte(255);
            DescColor.R = 68;
            DescColor.G = 68;
            DescColor.B = 68;
            DescColor.A = byte(255);
        }
        AddTooltipItemBlank(4);
        AddTooltipColorText(GetSystemString(3640), titleColor, true, false);
        AddTooltipItemBlank(2);
        i = 0;
        J0x176:

        // End:0x1C7 [Loop If]
        if(i < mainSkillList.Length)
        {
            AddTooltipColorText(" - ", DescColor, true, false);
            AddTooltipColorText(mainSkillList[i].SkillDesc, DescColor, false, false);
            AddTooltipItemBlank(2);
            i++;
            // [Loop Continue]
            goto J0x176;
        }
    }
    // End:0x35E
    if(subSkillList.Length > 0)
    {
        // End:0x272
        if(((GetAgathionIndex(Info.Id)) > 0) || (GetAgathionIndex(Info.Id)) == 0)
        {
            titleColor.R = byte(255);
            titleColor.G = 153;
            titleColor.B = 153;
            titleColor.A = byte(255);
            DescColor.R = 153;
            DescColor.G = 153;
            DescColor.B = 153;
            DescColor.A = byte(255);            
        }
        else
        {
            titleColor.R = 100;
            titleColor.G = 70;
            titleColor.B = 70;
            titleColor.A = byte(255);
            DescColor.R = 68;
            DescColor.G = 68;
            DescColor.B = 68;
            DescColor.A = byte(255);
        }
        AddTooltipItemBlank(4);
        AddTooltipColorText(GetSystemString(3641), titleColor, true, false);
        AddTooltipItemBlank(2);
        i = 0;
        J0x30D:

        // End:0x35E [Loop If]
        if(i < subSkillList.Length)
        {
            AddTooltipColorText(" - ", DescColor, true, false);
            AddTooltipColorText(subSkillList[i].SkillDesc, DescColor, false, false);
            AddTooltipItemBlank(2);
            i++;
            // [Loop Continue]
            goto J0x30D;
        }
    }
    return;
}

function AddTooltipItemBlank(int Height)
{
    StartItem();
    m_Info.eType = 0;
    m_Info.b_nHeight = Height;
    EndItem();
    return;
}

function AddTooltipSimpleText(string strText, optional int OffsetX, optional int OffsetY)
{
    StartItem();
    m_Info.eType = 1;
    m_Info.t_bDrawOneLine = true;
    m_Info.t_strText = strText;
    m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
    m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
    EndItem();
    return;
}

function AddTooltipItemOption(int TitleID, string content, bool bTitle, bool bContent, bool isFirstLine, optional string FontName, optional int OffsetX, optional int OffsetY, optional Color titleTextColor, optional Color contentTextColor)
{
    // End:0x157
    if(bTitle)
    {
        StartItem();
        m_Info.eType = 1;
        // End:0x34
        if(!isFirstLine)
        {
            m_Info.nOffSetY = 6;
        }
        m_Info.bLineBreak = true;
        m_Info.t_bDrawOneLine = true;
        // End:0xE9
        if((((int(titleTextColor.R) == 0) && int(titleTextColor.G) == 0) && int(titleTextColor.B) == 0) && int(titleTextColor.A) == 0)
        {
            m_Info.t_color.R = 163;
            m_Info.t_color.G = 163;
            m_Info.t_color.B = 163;
            m_Info.t_color.A = byte(255);            
        }
        else
        {
            m_Info.t_color = titleTextColor;
        }
        m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
        m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
        m_Info.t_strFontName = FontName;
        m_Info.t_ID = TitleID;
        EndItem();
    }
    // End:0x410
    if(content != "0")
    {
        // End:0x410
        if(bContent)
        {
            // End:0x2B7
            if(bTitle)
            {
                StartItem();
                m_Info.eType = 1;
                // End:0x1A1
                if(!isFirstLine)
                {
                    m_Info.nOffSetY = 6;
                }
                m_Info.t_bDrawOneLine = true;
                // End:0x249
                if((((int(titleTextColor.R) == 0) && int(titleTextColor.G) == 0) && int(titleTextColor.B) == 0) && int(titleTextColor.A) == 0)
                {
                    m_Info.t_color.R = 163;
                    m_Info.t_color.G = 163;
                    m_Info.t_color.B = 163;
                    m_Info.t_color.A = byte(255);                    
                }
                else
                {
                    m_Info.t_color = titleTextColor;
                }
                m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
                m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
                m_Info.t_strFontName = FontName;
                m_Info.t_strText = " : ";
                EndItem();
            }
            StartItem();
            m_Info.eType = 1;
            // End:0x2E2
            if(!isFirstLine)
            {
                m_Info.nOffSetY = 6;
            }
            // End:0x2FA
            if(!bTitle)
            {
                m_Info.bLineBreak = true;
            }
            m_Info.t_bDrawOneLine = true;
            // End:0x3A2
            if((((int(contentTextColor.R) == 0) && int(contentTextColor.G) == 0) && int(contentTextColor.B) == 0) && int(contentTextColor.A) == 0)
            {
                m_Info.t_color.R = 176;
                m_Info.t_color.G = 155;
                m_Info.t_color.B = 121;
                m_Info.t_color.A = byte(255);                
            }
            else
            {
                m_Info.t_color = contentTextColor;
            }
            m_Info.nOffSetX = m_Info.nOffSetX + OffsetX;
            m_Info.nOffSetY = m_Info.nOffSetY + OffsetY;
            m_Info.t_strFontName = FontName;
            m_Info.t_strText = content;
            EndItem();
        }
    }
    return;
}

function AddTooltipItemOptionString(string TitleContent, string content, bool bTitle, bool bContent, bool isFirstLine)
{
    // End:0xAE
    if(bTitle)
    {
        StartItem();
        m_Info.eType = 1;
        // End:0x34
        if(!isFirstLine)
        {
            m_Info.nOffSetY = 6;
        }
        m_Info.bLineBreak = true;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_color.R = 163;
        m_Info.t_color.G = 163;
        m_Info.t_color.B = 163;
        m_Info.t_color.A = byte(255);
        m_Info.t_strText = TitleContent;
        EndItem();
    }
    // End:0x215
    if(content != "0")
    {
        // End:0x215
        if(bContent)
        {
            // End:0x165
            if(bTitle)
            {
                StartItem();
                m_Info.eType = 1;
                // End:0xF8
                if(!isFirstLine)
                {
                    m_Info.nOffSetY = 6;
                }
                m_Info.t_bDrawOneLine = true;
                m_Info.t_color.R = 163;
                m_Info.t_color.G = 163;
                m_Info.t_color.B = 163;
                m_Info.t_color.A = byte(255);
                m_Info.t_strText = " : ";
                EndItem();
            }
            StartItem();
            m_Info.eType = 1;
            // End:0x190
            if(!isFirstLine)
            {
                m_Info.nOffSetY = 6;
            }
            // End:0x1A8
            if(!bTitle)
            {
                m_Info.bLineBreak = true;
            }
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = 176;
            m_Info.t_color.G = 155;
            m_Info.t_color.B = 121;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = content;
            EndItem();
        }
    }
    return;
}

function AddTooltipItemOption2(int TitleID, int ContentID, bool bTitle, bool bContent, bool isFirstLine)
{
    // End:0xAE
    if(bTitle)
    {
        StartItem();
        m_Info.eType = 1;
        // End:0x34
        if(!isFirstLine)
        {
            m_Info.nOffSetY = 6;
        }
        m_Info.bLineBreak = true;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_color.R = 163;
        m_Info.t_color.G = 163;
        m_Info.t_color.B = 163;
        m_Info.t_color.A = byte(255);
        m_Info.t_ID = TitleID;
        EndItem();
    }
    // End:0x208
    if(bContent)
    {
        // End:0x158
        if(bTitle)
        {
            StartItem();
            m_Info.eType = 1;
            // End:0xEB
            if(!isFirstLine)
            {
                m_Info.nOffSetY = 6;
            }
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = 163;
            m_Info.t_color.G = 163;
            m_Info.t_color.B = 163;
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = " : ";
            EndItem();
        }
        StartItem();
        m_Info.eType = 1;
        // End:0x183
        if(!isFirstLine)
        {
            m_Info.nOffSetY = 6;
        }
        // End:0x19B
        if(!bTitle)
        {
            m_Info.bLineBreak = true;
        }
        m_Info.t_bDrawOneLine = true;
        m_Info.t_color.R = 176;
        m_Info.t_color.G = 155;
        m_Info.t_color.B = 121;
        m_Info.t_color.A = byte(255);
        m_Info.t_ID = ContentID;
        EndItem();
    }
    return;
}

function AddTooltipItemColorOption(int TitleID, string content, int R, int G, int B, bool bTitle, bool bContent, bool isFirstLine)
{
    // End:0xAE
    if(bTitle)
    {
        StartItem();
        m_Info.eType = 1;
        // End:0x34
        if(!isFirstLine)
        {
            m_Info.nOffSetY = 6;
        }
        m_Info.bLineBreak = true;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_color.R = 163;
        m_Info.t_color.G = 163;
        m_Info.t_color.B = 163;
        m_Info.t_color.A = byte(255);
        m_Info.t_ID = TitleID;
        EndItem();
    }
    // End:0x233
    if(content != "0")
    {
        // End:0x233
        if(bContent)
        {
            // End:0x174
            if(bTitle)
            {
                StartItem();
                m_Info.eType = 1;
                // End:0xF8
                if(!isFirstLine)
                {
                    m_Info.nOffSetY = 6;
                }
                m_Info.t_bDrawOneLine = true;
                m_Info.t_color.R = byte(R);
                m_Info.t_color.G = byte(G);
                m_Info.t_color.B = byte(B);
                m_Info.t_color.A = byte(255);
                m_Info.t_strText = " : ";
                EndItem();
            }
            StartItem();
            m_Info.eType = 1;
            // End:0x19F
            if(!isFirstLine)
            {
                m_Info.nOffSetY = 6;
            }
            // End:0x1B7
            if(!bTitle)
            {
                m_Info.bLineBreak = true;
            }
            m_Info.t_bDrawOneLine = true;
            m_Info.t_color.R = byte(R);
            m_Info.t_color.G = byte(G);
            m_Info.t_color.B = byte(B);
            m_Info.t_color.A = byte(255);
            m_Info.t_strText = content;
            EndItem();
        }
    }
    return;
}

function AddTooltipItemBonus(int nBasic, int nBonus, optional int OffsetX, optional int OffsetY)
{
    // End:0x95
    if(nBonus > 0)
    {
        AddTooltipColorText((" (" $ string(nBasic)) $ " ", GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
        AddTooltipColorText("+" $ string(nBonus), GetColor(238, 170, 34, 255), false, true, false, "", OffsetX, OffsetY);
        AddTooltipColorText(")", GetColor(176, 155, 121, 255), false, true, false, "", OffsetX, OffsetY);
    }
    return;
}

function addTooltipTexture(string Texture, int Width, int Height, int uWidth, int uHeight, optional bool oneline, optional bool bLineBreak, optional int OffsetX, optional int OffsetY)
{
    StartItem();
    m_Info.eType = 2;
    m_Info.t_bDrawOneLine = oneline;
    m_Info.bLineBreak = bLineBreak;
    m_Info.u_nTextureWidth = Width;
    m_Info.u_nTextureHeight = Height;
    m_Info.nOffSetX = OffsetX;
    m_Info.nOffSetY = OffsetY;
    m_Info.u_nTextureUWidth = uWidth;
    m_Info.u_nTextureUHeight = uHeight;
    m_Info.u_strTexture = Texture;
    EndItem();
    return;
}

function string GetAttributeIcon(int nAttributeType)
{
    local string rStr;

    switch(nAttributeType)
    {
        // End:0x41
        case 0:
            rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_fire";
            // End:0x171
            break;
        // End:0x7C
        case 1:
            rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_water";
            // End:0x171
            break;
        // End:0xB7
        case 2:
            rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_wind";
            // End:0x171
            break;
        // End:0xF3
        case 3:
            rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_earth";
            // End:0x171
            break;
        // End:0x130
        case 4:
            rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_Sacred";
            // End:0x171
            break;
        // End:0x16B
        case 5:
            rStr = "L2UI_CT1.ToolTip.Tooltip_AttributeIcon_dark";
            // End:0x171
            break;
        // End:0xFFFF
        default:
            // End:0x171
            break;
            break;
    }
    return rStr;
    return;
}

function ReturnTooltip_NTT_RANKINGCHARACTERINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;
    local string charName, RaceName, ClassName, ClanName;
    local int CharacterLevel;
    local Color LevelColor, TextColor;
    local int RewardSkillID;
    local SkillInfo RewardSkillInfo;
    local string RewardTitle;

    // End:0x158
    if(int(eSourceType) == int(2))
    {
        ParamToRecord(param, Record);
        charName = Record.szReserved;
        CharacterLevel = name(Record.nReserved1);
        // End:0xB3
        if(Record.LVDataList.Length > 2)
        {
            // End:0x78
            if(charName == "")
            {
                charName = Record.LVDataList[2].szData;
            }
            // End:0x9B
            if(CharacterLevel == 0)
            {
                CharacterLevel = Record.LVDataList[2].nReserved1;
            }
            RaceName = Record.LVDataList[2].szReserved;
        }
        // End:0xDD
        if(Record.LVDataList.Length > 3)
        {
            ClassName = Record.LVDataList[3].szReserved;
        }
        // End:0x12B
        if(Record.LVDataList.Length > 4)
        {
            ClanName = Record.LVDataList[4].szReserved;
            // End:0x12B
            if(ClanName == "")
            {
                ClanName = Record.LVDataList[4].szData;
            }
        }
        // End:0x155
        if(Record.LVDataList.Length > 5)
        {
            RewardSkillID = Record.LVDataList[5].nReserved1;
        }        
    }
    else
    {
        ParseString(param, "Name", charName);
        ParseInt(param, "Level", CharacterLevel);
        ParseString(param, "RaceName", RaceName);
        ParseString(param, "ClassName", ClassName);
        ParseString(param, "ClanName", ClanName);
    }
    // End:0x1E2
    if(charName == "")
    {
        return;
    }
    LevelColor = GetColor(255, 217, 105, 255);
    TextColor = GetColor(178, 190, 207, 255);
    m_Tooltip.MinimumWidth = 150;
    AddTooltipColorText("Lv." $ string(CharacterLevel), LevelColor, false, true, true);
    AddTooltipColorText(" " $ charName, GetColor(220, 220, 220, 255), true, true, true);
    AddCrossLine(150);
    AddTooltipColorText("Race : " $ RaceName, TextColor, true, true, true);
    AddTooltipColorText("Class : " $ ClassName, TextColor, true, true, false);
    AddTooltipColorText("Clan : " $ ClanName, TextColor, true, true, false);
    // End:0x339
    if((RewardSkillID > 0) && GetSkillInfo(RewardSkillID, 1, 0, RewardSkillInfo))
    {
        RewardTitle = GetRankingRewardTitle(RewardSkillID);
        // End:0x306
        if(RewardTitle == "")
        {
            RewardTitle = RewardSkillInfo.SkillName;
        }
        AddCrossLine(150);
        AddTooltipColorText(RewardTitle, LevelColor, true, true, false);
        AddTooltipColorText(RewardSkillInfo.SkillDesc, TextColor, true, false, false);
    }
    ReturnTooltipInfo(m_Tooltip);
    return;
}

function string GetRankingRewardTitle(int SkillID)
{
    local int Rank, SuffixStringID;

    switch(SkillID)
    {
        // End:0x24
        case 64403:
            Rank = 1;
            SuffixStringID = 9034;
            // End:0xBF
            break;
        // End:0x42
        case 64402:
            Rank = 2;
            SuffixStringID = 9034;
            // End:0xBF
            break;
        // End:0x60
        case 64401:
            Rank = 3;
            SuffixStringID = 9034;
            // End:0xBF
            break;
        // End:0x7D
        case 64406:
            Rank = 1;
            SuffixStringID = 9035;
            // End:0xBF
            break;
        // End:0x9B
        case 64405:
            Rank = 2;
            SuffixStringID = 9035;
            // End:0xBF
            break;
        // End:0xB9
        case 64404:
            Rank = 3;
            SuffixStringID = 9035;
            // End:0xBF
            break;
        // End:0xFFFF
        default:
            return "";
            break;
    }
    return (GetSystemString(9033) @ string(Rank)) @ GetSystemString(SuffixStringID);
    return;
}

function ReturnTooltip_NTT_RANKINGCLASSINFO(string param, UIEventManager.ETooltipSourceType eSourceType)
{
    local LVDataRecord Record;

    // End:0x12
    if(int(eSourceType) != int(2))
    {
        return;
    }
    ParamToRecord(param, Record);
    // End:0x9F
    if((Record.LVDataList.Length > 4) && Record.LVDataList[4].szReserved != "")
    {
        StartItem();
        m_Info.eType = 1;
        m_Info.t_bDrawOneLine = true;
        m_Info.t_strText = Record.LVDataList[4].szReserved;
        EndItem();
        ReturnTooltipInfo(m_Tooltip);
        return;
    }
    // End:0xCE
    if((Record.LVDataList.Length <= 3) || Record.LVDataList[3].szReserved == "")
    {
        return;
    }
    StartItem();
    m_Info.eType = 1;
    m_Info.t_bDrawOneLine = true;
    m_Info.t_strText = Record.LVDataList[3].szReserved;
    EndItem();
    ReturnTooltipInfo(m_Tooltip);
    return;
}
