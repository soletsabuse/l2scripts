class NPCBrokerAPI extends PacketsInfo;

const BUTTONS_GLOBAL_MAX_ALPHA_VALUE = 255;
const BUTTONS_GLOBAL_MIN_ALPHA_VALUE = 180;
const BUTTONS_ALPHA_SHOW_SPEED = 0.15f;
const BUTTONS_ALPHA_HIDE_SPEED = 0.2f;
const MAX_TYPE_BUTTONS = 12;
const DEFAULT_TYPE_BUTTON_WIDTH = 146;
const DEFAULT_TYPE_BUTTON_HEIGHT = 29;
const MAX_SPECIAL_TYPE_BUTTONS = 3;
const MAX_PAGE_ITEMS = 7;
const VIEWPORT_DIALOG_SYSSTRING = 7733;
const VIEWPORT_TALK_TIME = 3100;
const VIEWPORT_ANIMATION_TALK = 0;
const VIEWPORT_ANIMATION_IDLE = 2;
const ATTRIBUTE_MAX = 3;

enum BrokerButtonTypes
{
    BBT_TOTAL,                      // 0
    BBT_EQUIPMENT,                  // 1
    BBT_SUB_EQUIPMENT_WEAPON,       // 2
    BBT_SUB_EQUIPMENT_ARMOR,        // 3
    BBT_SUB_EQUIPMENT_JEWELERY,     // 4
    BBT_ENCHANTED_EQUIPMENT,        // 5
    BBT_SUB_ENCHANTED_EQUIPMENT_WEAPON,// 6
    BBT_SUB_ENCHANTED_EQUIPMENT_ARMOR,// 7
    BBT_SUB_ENCHANTED_EQUIPMENT_JEWELERY,// 8
    BBT_UNIQUE_EQUIPMENT,           // 9
    BBT_SUB_UNIQUE_EQUIPMENT_WEAPON,// 10
    BBT_SUB_UNIQUE_EQUIPMENT_ARMOR, // 11
    BBT_SUB_UNIQUE_EQUIPMENT_JEWELERY,// 12
    BBT_GENERAL_ITEM,               // 13
    BBT_SUPPLY,                     // 14
    BBT_MATERIAL,                   // 15
    BBT_SPELLBOOK,                  // 16
    BBT_RECIPE,                     // 17
    BBT_MATERIAL_PIECE,             // 18
    BBT_OTHER,                      // 19
    BBT_ATTR_EQUIPMENT,             // 20
    BBT_SUB_ATTR_EQUIPMENT_WEAPON,  // 21
    BBT_SUB_ATTR_EQUIPMENT_ARMOR,   // 22
    BBT_SUB_ATTR_EQUIPMENT_JEWELERY,// 23
    BBT_MAX                         // 24
};

enum BrokerGeneralType
{
    BGT_NONE,                       // 0
    BGT_BUY,                        // 1
    BGT_SELL,                       // 2
    BGT_MANIFACTURE,                // 3
    BGT_MAX                         // 4
};

enum WindowStateType
{
    BGT_NONE,                       // 0
    BGT_BUTTONS,                    // 1
    BGT_LIST                        // 2
};

enum BrokerSortType
{
    SORT_NONE,                      // 0
    SORT_BY_PRICE_ASC,              // 1
    SORT_BY_PRICE_DESC,             // 2
    SORT_BY_RARITY,                 // 3
    SORT_BY_TIME                    // 4
};

struct TraderItem
{
    var WindowHandle Target;
    var ItemWindowHandle item;
    var TextBoxHandle ItemName;
    var TextBoxHandle priceHeader;
    var TextBoxHandle Price;
    var TextBoxHandle Count;
    var TextBoxHandle traderHeader;
    var TextBoxHandle traderName;
    var ButtonHandle CraftTreeButton;
    var ButtonHandle RunOwnerButton;
    var TextureHandle txHighlight;
};

struct BrokerAttrItem
{
    var int nType;
    var int Value;
};

struct BrokerItemData
{
    var int ItemID;
    var INT64 Price;
    var INT64 Count;
    var BrokerAttrItem attr[3];
    var string Username;
    var int UserID;
    var int RecipeID;
    var int enchantLevel;
};

function NPCBrokerAPI.BrokerButtonTypes getButtonBrokerType(string strID)
{
    return byte(int(Right(strID, 2)) - 1);
    return;
}

function string getWindowTitleStringByGeneralType(NPCBrokerAPI.BrokerGeneralType Type)
{
    switch(Type)
    {
        // End:0x18
        case 0:
            return GetSystemString(7749);
        // End:0x29
        case 1:
            return GetSystemString(7734);
        // End:0x3A
        case 2:
            return GetSystemString(7735);
        // End:0x4E
        case 3:
            return GetSystemString(7736);
            // End:0x54
            break;
        // End:0xFFFF
        default:
            // End:0x54
            break;
            break;
    }
    return;
}

function requestBrokerMainPage(NPCBrokerAPI.BrokerGeneralType nGeneralType)
{
    // End:0x1F
    if((int(nGeneralType) < 0) || int(nGeneralType) >= 4)
    {
        return;
    }
    RequestBypassToServer("getbroker|" $ string(nGeneralType));
    return;
}

function requestBrokerSpecificList(NPCBrokerAPI.BrokerGeneralType nGeneralType, int nButtonType, int nPage, byte nSortType)
{
    // End:0x1F
    if((int(nGeneralType) < 0) || int(nGeneralType) >= 4)
    {
        return;
    }
    RequestBypassToServer((((((("getbrokerlist|" $ string(nGeneralType)) $ "|") $ string(nButtonType)) $ "|") $ string(nPage)) $ "|") $ string(nSortType));
    return;
}

function requestBrokerSearchList(string sPattern, NPCBrokerAPI.BrokerGeneralType nGeneralType, NPCBrokerAPI.BrokerButtonTypes nButtonTypes, int nPage, byte nSortType)
{
    // End:0x1F
    if((int(nGeneralType) < 0) || int(nGeneralType) >= 4)
    {
        return;
    }
    // End:0x4A
    if(Len(sPattern) < 3)
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(7761));
        return;
    }
    RequestBypassToServer((((((((("getbrokersearch|" $ string(nGeneralType)) $ "|") $ string(nButtonTypes)) $ "|") $ string(nPage)) $ "|") $ sPattern) $ "|") $ string(nSortType));
    return;
}

function requestBrokerSearchSpecificItem(int cID, NPCBrokerAPI.BrokerGeneralType nGeneralType, int nButtonType, int nPage)
{
    RequestBypassToServer((((((("getbrokeritem|" $ string(cID)) $ "|") $ string(nGeneralType)) $ "|") $ string(nButtonType)) $ "|") $ string(nPage));
    return;
}

function requestMoveToTrader(int nUserId)
{
    // End:0x0D
    if(nUserId <= 0)
    {
        return;
    }
    RequestBypassToServer("getBrokerMove|" $ string(nUserId));
    return;
}

function bool IsEnchantableItem(UIEventManager.EItemParamType Type)
{
    return (((int(Type) == 0) || int(Type) == 1) || int(Type) == 3) || int(Type) == 2;
    return;
}

function fakeSellEV_BROKER_MAIN_PAGE()
{
    return;
}

function fakeBuyEV_BROKER_MAIN_PAGE()
{
    return;
}

function fakeManifactureEV_BROKER_MAIN_PAGE()
{
    return;
}

function fakeBuySellEV_BROKER_BUYSELL_LIST()
{
    local string S, s1, s2;

    S = ((((((((((((((((((((((((((((("6378," $ string(RandRange(50000.0000000, 5000000.0000000))) $ ",") $ string(Rand(1500))) $ ",") $ string(Rand(20))) $ ",50000;6373,") $ string(RandRange(50000.0000000, 5000000.0000000))) $ ",") $ string(Rand(1500))) $ ",") $ string(Rand(20))) $ ",50000;6374,") $ string(RandRange(50000.0000000, 5000000.0000000))) $ ",") $ string(Rand(1500))) $ ",") $ string(Rand(20))) $ ",50000;6375,") $ string(RandRange(50000.0000000, 5000000.0000000))) $ ",") $ string(Rand(1500))) $ ",") $ string(Rand(20))) $ ",50000;6376,") $ string(RandRange(50000.0000000, 5000000.0000000))) $ ",") $ string(Rand(1500))) $ ",") $ string(Rand(20))) $ ",50000";
    s2 = (((((((((((";6626," $ string(RandRange(50000.0000000, 5000000.0000000))) $ ",") $ string(Rand(1500))) $ ",") $ string(Rand(20))) $ ",50000;6627,") $ string(RandRange(50000.0000000, 5000000.0000000))) $ ",") $ string(Rand(1500))) $ ",") $ string(Rand(20))) $ ",50000";
    return;
}

function fakeBuySellEV_BROKER_RECIPE_LIST()
{
    local string S, s1, s2;

    S = ((((((((((((((((((((((("272," $ string(int(RandRange(50000.0000000, 5000000.0000000)))) $ ",") $ string(10)) $ ",50000;") $ "37,") $ string(int(RandRange(50000.0000000, 5000000.0000000)))) $ ",") $ string(11)) $ ",50000;") $ "25,") $ string(int(RandRange(50000.0000000, 5000000.0000000)))) $ ",") $ string(16)) $ ",50000;") $ "907,") $ string(int(RandRange(50000.0000000, 5000000.0000000)))) $ ",") $ string(18)) $ ",50000;") $ "1463,") $ string(int(RandRange(50000.0000000, 5000000.0000000)))) $ ",") $ string(20)) $ ",50000";
    s2 = ((((((((";1467," $ string(int(RandRange(50000.0000000, 5000000.0000000)))) $ ",") $ string(24)) $ ",50000;") $ "1467,") $ string(int(RandRange(50000.0000000, 5000000.0000000)))) $ ",") $ string(23)) $ ",50000";
    return;
}
