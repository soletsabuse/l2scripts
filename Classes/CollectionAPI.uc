class CollectionAPI extends PacketsInfo;

const MAX_ASSIGN_SLOT = 6;
const MAX_ASSIGN_INVENTORY_SLOT = 20;
const MAX_OPTIONS = 3;
const MAX_COLLECTION_IN_LIST = 15;
const OPEN_KEY_GLOW_SWAP_MAX = 3;
const OPEN_KEY_GLOW_SWAP_ALPHA = 0.3f;
const ITEM_MATERIAL_TYPE_DRUG = 32;

enum eKeyType
{
    KT_P_WEAPON,                    // 0
    KT_M_WEAPON,                    // 1
    KT_P_ARMOR,                     // 2
    KT_SHIELD,                      // 3
    KT_JEWELERY,                    // 4
    KT_EVENT                        // 5
};

enum eStatFilterType
{
    ST_MAXCP,                       // 0
    ST_MAXHP,                       // 1
    ST_MAXMP,                       // 2
    ST_REGENCP,                     // 3
    ST_REGENHP,                     // 4
    ST_REGENMP,                     // 5
    ST_PATK,                        // 6
    ST_PDEF,                        // 7
    ST_MATK,                        // 8
    ST_MDEF,                        // 9
    ST_CAST_SPD,                    // 10
    ST_ATK_SPD,                     // 11
    ST_CRITICAL,                    // 12
    ST_EVASION,                     // 13
    ST_ACCURACY,                    // 14
    ST_SPEED,                       // 15
    ST_MAX                          // 16
};

enum eCollectionState
{
    KS_NONE,                        // 0
    KS_UNCOMPLETED,                 // 1
    KS_INPROGRESS,                  // 2
    KS_COMPLETED                    // 3
};

enum eCollectionItemState
{
    CIS_NONE,                       // 0
    CIS_UNASSIGNED,                 // 1
    CIS_ASSIGNED                    // 2
};

enum eCollectionType
{
    CT_TOTAL,                       // 0
    CT_ATTACK,                      // 1
    CT_DEFENCE,                     // 2
    CT_SUPPORT,                     // 3
    CT_SPECIAL                      // 4
};

struct _collectionSlot
{
    var int ItemID;
    var int Count;
    var int Enchant;
    var int commission;
};

struct _collectionData
{
    var CollectionAPI.eCollectionType cType;
    var int collection_id;
    var string collection_name;
    var int option_id;
    var array<int> allCollectionsItems;
    var array<_collectionSlot> Collection;
};

struct _collectionState
{
    var CollectionAPI.eCollectionState collectionState;
    var string strStatesArr;
    var array<CollectionAPI.eCollectionItemState> states;
};

struct _CollectionItem
{
    var int ItemID;
    var int Enchanted;
};

struct _StatusData
{
    var array<string> collectionDoneData;
    var array<string> itemsAddedData;
};

var array<_CollectionItem> allCollectionsItemIds;
var array<_collectionData> Collections;
var _StatusData statusData;

function string getLocalization()
{
    local bool bIsNative;

    bIsNative = GetOptionBool("Control", "IsNative");
    // End:0x44
    if(bIsNative)
    {
        return "CollectionName-ru.dat";        
    }
    else
    {
        return "CollectionName-eu.dat";
    }
    return;
}

function getCollectionData()
{
    local int i, j, k;
    local array<string> cData, optData, slotPreData, slotData;
    local string collection_name, LINE;
    local _collectionSlot collectionSlot;
    local _collectionData collectionData;
    local array<_collectionSlot> Collection;

    // End:0x27
    if(!SettingSectorBool("COLLECTION", "COLLECION_UI"))
    {
        return;
    }
    // End:0x35
    if(Collections.Length > 0)
    {
        return;
    }
    i = 1;
    J0x3C:

    // End:0x287 [Loop If]
    if(i < 1500)
    {
        GetINIString("collections", "collection_id" $ string(i), LINE, "Collection.dat");
        // End:0x9B
        if(Len(LINE) <= 0)
        {
            // [Explicit Continue]
            goto J0x27D;
        }
        cData = Arr(LINE, "	");
        collectionData.cType = getCollectionType(cData[0]);
        GetINIString("collections_name", "collection_id" $ string(i), collection_name, getLocalization());
        collectionData.collection_id = i;
        collectionData.collection_name = collection_name;
        optData = Arr(cData[1], "=");
        collectionData.option_id = int(optData[1]);
        Collection.Remove(0, Collection.Length);
        j = 2;
        J0x161:

        // End:0x25B [Loop If]
        if(j < cData.Length)
        {
            // End:0x187
            if(Len(cData[j]) <= 0)
            {
                // [Explicit Break]
                goto J0x25B;
            }
            slotPreData.Remove(0, slotPreData.Length);
            slotData.Remove(0, slotData.Length);
            slotPreData = Arr(cData[j], "=");
            // End:0x1D7
            if(InStr(slotPreData[0], "slot") <= -1)
            {
                // [Explicit Break]
                goto J0x25B;
            }
            slotData = Arr(slotPreData[1], ",");
            collectionSlot.ItemID = int(slotData[0]);
            collectionSlot.Count = int(slotData[1]);
            collectionSlot.Enchant = int(slotData[2]);
            collectionSlot.commission = int(slotData[3]);
            Collection[Collection.Length] = collectionSlot;
            j++;
            // [Loop Continue]
            goto J0x161;
        }
        J0x25B:

        collectionData.Collection = Collection;
        Collections[Collections.Length] = collectionData;
        J0x27D:

        i++;
        // [Loop Continue]
        goto J0x3C;
    }
    saveAllCollectionsItem();
    return;
}

function saveAllCollectionsItem()
{
    local int i, j, k;
    local bool bFound;
    local _CollectionItem item;

    allCollectionsItemIds.Remove(0, allCollectionsItemIds.Length);
    i = 0;
    J0x14:

    // End:0x159 [Loop If]
    if(i < Collections.Length)
    {
        j = 0;
        J0x2B:

        // End:0x14F [Loop If]
        if(j < Collections[i].Collection.Length)
        {
            bFound = false;
            k = 0;
            J0x55:

            // End:0xDC [Loop If]
            if(k < allCollectionsItemIds.Length)
            {
                // End:0xD2
                if((allCollectionsItemIds[k].ItemID == Collections[i].Collection[j].ItemID) && allCollectionsItemIds[k].Enchanted == Collections[i].Collection[j].Enchant)
                {
                    bFound = true;
                    // [Explicit Break]
                    goto J0xDC;
                }
                k++;
                // [Loop Continue]
                goto J0x55;
            }
            J0xDC:

            // End:0x145
            if(!bFound)
            {
                item.ItemID = Collections[i].Collection[j].ItemID;
                item.Enchanted = Collections[i].Collection[j].Enchant;
                allCollectionsItemIds[allCollectionsItemIds.Length] = item;
            }
            j++;
            // [Loop Continue]
            goto J0x2B;
        }
        i++;
        // [Loop Continue]
        goto J0x14;
    }
    return;
}

function array<_collectionData> GetFilteredCollectionList(array<CollectionAPI.eKeyType> ItemTypeRestriction, string searchStr, UIConstants.CrystalType cryType, CollectionAPI.eStatFilterType statFilterType, optional CollectionAPI.eCollectionType categoryFilter)
{
    local ItemInfo item;
    local UIEventManager.EItemType ItemType;
    local int i, j, k;
    local string strPattern, strDesc1, strDesc2, strDesc3;
    local Color Color, optC1, optC2, optC3;
    local string statFilterStr;
    local bool bTextFilterPassed, bTypeFilterPassed, bCryFilterPassed, bStatFitlerPassed;
    local array<_collectionData> filtredCollections;

    statFilterStr = getStatString(statFilterType);
    i = 0;
    J0x18:

    // End:0x389 [Loop If]
    if(i < Collections.Length)
    {
        // End:0x5B
        if((int(categoryFilter) != int(0)) && int(Collections[i].cType) != int(categoryFilter))
        {
            // [Explicit Continue]
            goto J0x37F;
        }
        j = 0;
        J0x62:

        // End:0x37F [Loop If]
        if(j < Collections[i].Collection.Length)
        {
            GetItemInfoByClassID(Collections[i].Collection[j].ItemID, item);
            ItemType = byte(item.ItemType);
            strPattern = Locs(GetItemNameAll(item), " ", "", false);
            getOptionsStrings(Collections[i].option_id, strDesc1, strDesc2, strDesc3, optC1, optC2, optC3);
            bTextFilterPassed = (searchStr == "") || StringMatching(strPattern @ Collections[i].collection_name, searchStr, " ");
            bCryFilterPassed = (int(cryType) == 100) || item.CrystalType == int(cryType);
            bStatFitlerPassed = ((statFilterStr == "") || StringMatching(strDesc1, statFilterStr, " ") || StringMatching(strDesc2, statFilterStr, " ")) || StringMatching(strDesc3, statFilterStr, " ");
            // End:0x1CC
            if(!bTextFilterPassed)
            {
                // [Explicit Continue]
                goto J0x375;
            }
            // End:0x1DA
            if(!bCryFilterPassed)
            {
                // [Explicit Continue]
                goto J0x375;
            }
            // End:0x1E8
            if(!bStatFitlerPassed)
            {
                // [Explicit Continue]
                goto J0x375;
            }
            bTypeFilterPassed = ItemTypeRestriction.Length == 0;
            // End:0x330
            if(!bTypeFilterPassed)
            {
                k = 0;
                J0x20A:

                // End:0x330 [Loop If]
                if(k < ItemTypeRestriction.Length)
                {
                    switch(ItemTypeRestriction[k])
                    {
                        // End:0x260
                        case 0:
                            bTypeFilterPassed = (int(ItemType) == 0) && !Class'NWindow.UIDATA_ITEM'.static.IsMagicWeapon(item.Id);
                            // End:0x31A
                            break;
                        // End:0x297
                        case 1:
                            bTypeFilterPassed = (int(ItemType) == 0) && Class'NWindow.UIDATA_ITEM'.static.IsMagicWeapon(item.Id);
                            // End:0x31A
                            break;
                        // End:0x2B0
                        case 2:
                            bTypeFilterPassed = int(ItemType) == 1;
                            // End:0x31A
                            break;
                        // End:0x2DD
                        case 3:
                            bTypeFilterPassed = (int(ItemType) == 1) && item.ShieldDefense > float(0);
                            // End:0x31A
                            break;
                        // End:0x2F7
                        case 4:
                            bTypeFilterPassed = int(ItemType) == 2;
                            // End:0x31A
                            break;
                        // End:0x314
                        case 5:
                            bTypeFilterPassed = item.MaterialType == 32;
                            // End:0x31A
                            break;
                        // End:0xFFFF
                        default:
                            // End:0x31A
                            break;
                            break;
                    }
                    // End:0x326
                    if(bTypeFilterPassed)
                    {
                        // [Explicit Break]
                        goto J0x330;
                    }
                    k++;
                    // [Loop Continue]
                    goto J0x20A;
                }
            }
            J0x330:

            // End:0x375
            if(((bTextFilterPassed && bTypeFilterPassed) && bCryFilterPassed) && bStatFitlerPassed)
            {
                filtredCollections[filtredCollections.Length] = Collections[i];
                // [Explicit Break]
                goto J0x37F;
            }
            J0x375:

            j++;
            // [Loop Continue]
            goto J0x62;
        }
        J0x37F:

        i++;
        // [Loop Continue]
        goto J0x18;
    }
    return filtredCollections;
    return;
}

function CollectionAPI.eKeyType getItemKeyType(ItemInfo item)
{
    // End:0x38
    if(item.ItemType == 0)
    {
        // End:0x32
        if(Class'NWindow.UIDATA_ITEM'.static.IsMagicWeapon(item.Id))
        {
            return 1;            
        }
        else
        {
            return 0;
        }        
    }
    else
    {
        // End:0x66
        if(item.ItemType == 1)
        {
            // End:0x60
            if(item.ShieldDefense > float(0))
            {
                return 3;                
            }
            else
            {
                return 2;
            }            
        }
        else
        {
            // End:0x7D
            if(item.ItemType == 2)
            {
                return 4;                
            }
            else
            {
                // End:0x91
                if(item.MaterialType == 32)
                {
                    return 5;
                }
            }
        }
    }
    return;
}

function CollectionAPI.eCollectionType getCollectionType(string strType)
{
    switch(strType)
    {
        // End:0x15
        case "attack":
            return 1;
        // End:0x21
        case "defence":
        // End:0x30
        case "defense":
            return 2;
        // End:0x3F
        case "support":
            return 3;
        // End:0x4E
        case "special":
            return 4;
        // End:0xFFFF
        default:
            // End:0x54
            break;
            break;
    }
    return;
}

function Texture getEnchantTexture(int Enchant)
{
    // End:0x3A
    if(Enchant > 0)
    {
        return GetTexture("L2_UI8.enchant.ench_number" $ string(Enchant - 1));
    }
    return GetTexture("L2UI_CT1.EmptyBtn");
    return;
}

function getOptionsStrings(int optid, out string str1, out string str2, out string str3, out Color c1, out Color c2, out Color c3)
{
    Class'NWindow.UIDATA_REFINERYOPTION'.static.GetOptionDescription(optid, str1, str2, str3);
    c1 = GetColor(175, 152, 120, 255);
    c2 = GetColor(175, 152, 120, 255);
    c3 = GetColor(175, 152, 120, 255);
    // End:0x90
    if(str1 == "")
    {
        str1 = GetSystemString(7862);
        c1 = GetColor(128, 128, 128, 255);
    }
    // End:0xC1
    if(str2 == "")
    {
        str2 = GetSystemString(7862);
        c2 = GetColor(128, 128, 128, 255);
    }
    // End:0xF2
    if(str3 == "")
    {
        str3 = GetSystemString(7862);
        c3 = GetColor(128, 128, 128, 255);
    }
    return;
}

function getNumericOptions(string str1, string str2, string str3, out float nVal1, out float nVal2, out float nVal3)
{
    nVal1 = ParseNumericValue(str1);
    nVal2 = ParseNumericValue(str2);
    nVal3 = ParseNumericValue(str3);
    return;
}

function float ParseNumericValue(string inputStr)
{
    local int i;
    local string numStr;
    local bool bFoundSign, bFoundDigit, bFoundDot;
    local string ch;

    i = 0;
    J0x07:

    // End:0x100 [Loop If]
    if(i < Len(inputStr))
    {
        ch = Mid(inputStr, i, 1);
        // End:0x7E
        if((((ch == "+") || ch == "-") && !bFoundSign) && !bFoundDigit)
        {
            numStr = numStr $ ch;
            bFoundSign = true;
            // [Explicit Continue]
            goto J0xF6;
        }
        // End:0xB7
        if((ch >= "0") && ch <= "9")
        {
            numStr = numStr $ ch;
            bFoundDigit = true;
            // [Explicit Continue]
            goto J0xF6;
        }
        // End:0xF6
        if(((ch == ".") && !bFoundDot) && bFoundDigit)
        {
            numStr = numStr $ ch;
            bFoundDot = true;
        }
        J0xF6:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x114
    if(numStr != "")
    {
        return float(numStr);
    }
    return 0.0000000;
    return;
}

function requestCollectionUI()
{
    RequestBypassToServer("coll_ui");
    return;
}

function requestPageCollectionsInfo(array<int> collectionIds)
{
    local int i;
    local string request;

    // End:0x5B
    if(collectionIds.Length > 0)
    {
        request = string(collectionIds[0]);
        i = 1;
        J0x22:

        // End:0x5B [Loop If]
        if(i < collectionIds.Length)
        {
            request = (request $ ",") $ string(collectionIds[i]);
            i++;
            // [Loop Continue]
            goto J0x22;
        }
    }
    RequestBypassToServer("coll_page" @ request);
    return;
}

function requestSaveItemToCollection(int collectionId, ItemInfo item)
{
    RequestBypassToServer((("coll_item_save" @ string(collectionId)) @ string(item.Id.ClassID)) @ string(item.Id.ServerID));
    return;
}

function bool isCollectionItem(ItemInfo item)
{
    local int i, j;

    i = 0;
    J0x07:

    // End:0x68 [Loop If]
    if(i < allCollectionsItemIds.Length)
    {
        // End:0x5E
        if((allCollectionsItemIds[i].ItemID == item.Id.ClassID) && allCollectionsItemIds[i].Enchanted == item.Enchanted)
        {
            return true;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function int isDisabledItem(int State)
{
    // End:0x12
    if(int(byte(State)) == 2)
    {
        return 1;
    }
    return 0;
    return;
}

function CollectionAPI.eCollectionType keyTypeToCollectionType(CollectionAPI.eKeyType KeyType)
{
    switch(KeyType)
    {
        // End:0x0C
        case 0:
        // End:0x14
        case 1:
            return 1;
        // End:0x19
        case 2:
        // End:0x1E
        case 3:
        // End:0x26
        case 4:
            return 2;
        // End:0x2E
        case 5:
            return 4;
        // End:0xFFFF
        default:
            // End:0x34
            break;
            break;
    }
    return;
}

function string getStatString(CollectionAPI.eStatFilterType Type)
{
    switch(Type)
    {
        // End:0x18
        case 0:
            return GetSystemString(7869);
        // End:0x29
        case 1:
            return GetSystemString(7870);
        // End:0x3A
        case 2:
            return GetSystemString(7870);
        // End:0x4B
        case 3:
            return GetSystemString(7871);
        // End:0x5C
        case 4:
            return GetSystemString(7872);
        // End:0x6D
        case 5:
            return GetSystemString(7873);
        // End:0x7E
        case 6:
            return GetSystemString(7874);
        // End:0x8F
        case 7:
            return GetSystemString(7875);
        // End:0xA0
        case 8:
            return GetSystemString(7876);
        // End:0xB1
        case 9:
            return GetSystemString(7877);
        // End:0xC2
        case 10:
            return GetSystemString(7878);
        // End:0xD3
        case 11:
            return GetSystemString(7879);
        // End:0xE4
        case 12:
            return GetSystemString(7880);
        // End:0xF5
        case 13:
            return GetSystemString(7881);
        // End:0x106
        case 14:
            return GetSystemString(7882);
        // End:0x117
        case 15:
            return GetSystemString(7883);
        // End:0xFFFF
        default:
            return "";
            break;
    }    
    return;
}
