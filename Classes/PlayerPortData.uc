class PlayerPortData extends Hash
    abstract
    config(Engine)
    perobjectconfig;

const UI_VERSION = "1.1.9";
const UI_CODENAME_INDEX = 5;
const TargetServer = 1;
const SHOW_NOTICE_UI = true;

var globalconfig string PlayerPortVersion;
var globalconfig int nLastSessionTime;
var globalconfig int nLastContact;
var globalconfig int nVersion;
var globalconfig int loginShowCount;
var globalconfig int characterSelectionCount;
var globalconfig int selectedLobbyCharacter;
var globalconfig int nServerRouteResponderId;
var globalconfig int nServerRouteResponderRange;
var globalconfig bool bImDied;
var string responder;
var string key1;
var string key1C;
var string key2;
var string TARGET_URL;
var int nFirstContact;
var int nContanctDelay;

function initializeRouter()
{
    return;
}
