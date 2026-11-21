class ContextMenu extends L2UIGFxScript;

const SPECIALTYPE_CHAT_ADDBLOCK = 1;
const ACHIEVEMENT = 1;
const PRIVATESHOP_SELL = 2;
const PRIVATESHOP_ALLSELL = 3;
const PRIVATESHOP_BUY = 4;
const PRIVATESHOP_CLOSE = 5;
const TRANSFORM_CANCEL = 6;
const INSTANCEZONE_HISTORY = 7;
const ASSIST = 8;
const WHISPER = 9;
const INVITE_CLAN = 10;
const INVITE_FRIEND = 11;
const INVITE_PARTY = 12;
const TARGET_TOKEN1 = 13;
const TARGET_TOKEN2 = 14;
const TARGET_TOKEN3 = 15;
const TARGET_TOKEN4 = 16;
const PET_ACTION_RIDE = 17;
const PET_ACTION_CHANGE_MOVEMODE = 18;
const PET_ACTION_RETURN = 19;
const SUMMON_DISPOSITION_PASSIVE = 20;
const SUMMON_DISPOSITION_DEFENSE = 21;
const SUMMON_RETURN = 25;
const GETOFF = 22;
const TRADE = 23;
const Title = 24;
const LINE = 10000;
const PARTY_BREAK_UP = 26;
const PARTY_LEAVE = 27;
const PARTY_BANISH = 28;
const PARTY_LEADER_CHANGE = 29;
const MANUFACTURE_COMMON = 30;
const MANUFACTURE_DWARF = 31;
const TRANSFORM_RIDE_CANCEL = 32;
const BLOCKLIST_AD = 33;
const BLOCKLIST_BADMANNER = 34;

struct ContextMenuInfo
{
    var string Name;
    var int Id;
    var int X;
    var int Y;
};

var InviteClanPopWnd InviteClanPopWndScript;
var InviteClanPopWndClassic InviteClanPopWndClassicScript;
var TargetStatusWnd TargetStatusWndScript;
var PrivateShopWnd PrivateShopWndScript;
var SummonedWnd SummonedWndScript;
var ContextMenuInfo m_contextMenuInfo;

function OnRegisterEvent()
{
    RegisterGFxEvent(9860);
    RegisterEvent(40);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x12
    if(Event_ID == 40)
    {
        clearInfo();
    }
    return;
}

function OnLoad()
{
    RegisterState("ContextMenu", "GamingState");
    SetHavingFocus(false);
    SetAnchor("", 1, 1, 0, 0);
    SetDefaultShow(true);
    PrivateShopWndScript = PrivateShopWnd(GetScript("PrivateShopWnd"));
    InviteClanPopWndScript = InviteClanPopWnd(GetScript("InviteClanPopWnd"));
    InviteClanPopWndClassicScript = InviteClanPopWndClassic(GetScript("InviteClanPopWndClassic"));
    SummonedWndScript = SummonedWnd(GetScript("SummonedWnd"));
    TargetStatusWndScript = TargetStatusWnd(GetScript("TargetStatusWnd"));
    return;
}

function OnFlashLoaded()
{
    SetRenderOnTop(true);
    return;
}

function OnHide()
{
    clearInfo();
    SetHavingFocus(false);
    return;
}

function execContextEvent(string creatureName, int CreatureID, int locX, int locY, optional int specialType, optional string etcParam)
{
    local string strParam;

    ParamAdd(strParam, "ID", string(CreatureID));
    ParamAdd(strParam, "Name", creatureName);
    ParamAdd(strParam, "X", string(locX));
    ParamAdd(strParam, "Y", string(locY));
    ParamAdd(strParam, "SpecialType", string(specialType));
    ParamAdd(strParam, "EtcParam", etcParam);
    ExecuteEvent(9860, strParam);
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x28
        case "processCommand":
            processCommand(param);
            // End:0x52
            break;
        // End:0x4F
        case "contextMenuEventInfo":
            saveInfo(param);
            // End:0x52
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function saveInfo(string param)
{
    ParseString(param, "Name", m_contextMenuInfo.Name);
    ParseInt(param, "ID", m_contextMenuInfo.Id);
    ParseInt(param, "X", m_contextMenuInfo.X);
    ParseInt(param, "Y", m_contextMenuInfo.Y);
    return;
}

function clearInfo()
{
    m_contextMenuInfo.Name = "";
    m_contextMenuInfo.Id = 0;
    m_contextMenuInfo.X = 0;
    m_contextMenuInfo.Y = 0;
    return;
}

function ContextMenuInfo getContextEventInfo()
{
    return m_contextMenuInfo;
    return;
}

function makeContextMenu()
{
    // End:0x3E
    if(m_contextMenuInfo.Id > 0)
    {
        execContextEvent(m_contextMenuInfo.Name, m_contextMenuInfo.Id, m_contextMenuInfo.X, m_contextMenuInfo.Y);
    }
    return;
}

function processCommand(string param)
{
    local int menuItemType, targetID;
    local string Username;
    local UserInfo targetUserInfo;
    local ItemInfo SkillInfo;
    local string ChatMsg;

    ParseInt(param, "menuItemType", menuItemType);
    ParseInt(param, "ID", targetID);
    ParseString(param, "Name", Username);
    ParseString(param, "ChatMsg", ChatMsg);
    switch(menuItemType)
    {
        // End:0x6F
        case 1:
            // End:0x4CF
            break;
        // End:0x85
        case 2:
            ExecuteCommandFromAction("vendor");
            // End:0x4CF
            break;
        // End:0xA2
        case 3:
            ExecuteCommandFromAction("packagevendor");
            // End:0x4CF
            break;
        // End:0xB5
        case 4:
            ExecuteCommandFromAction("buy");
            // End:0x4CF
            break;
        // End:0xCC
        case 5:
            PrivateShopWndScript.contextMenuQuit();
            // End:0x4CF
            break;
        // End:0x10E
        case 32:
            SkillInfo.Id.ClassID = 9210;
            SkillInfo.Id.ServerID = 0;
            UseSkill(SkillInfo.Id, int(2));
            // End:0x4CF
            break;
        // End:0x150
        case 6:
            SkillInfo.Id.ClassID = 619;
            SkillInfo.Id.ServerID = 0;
            UseSkill(SkillInfo.Id, int(2));
            // End:0x4CF
            break;
        // End:0x15E
        case 7:
            RequestInzoneWaitingTime();
            // End:0x4CF
            break;
        // End:0x18B
        case 8:
            GetUserInfo(targetID, targetUserInfo);
            RequestAssist(targetID, targetUserInfo.loc);
            // End:0x4CF
            break;
        // End:0x19E
        case 9:
            whisperToUser(Username);
            // End:0x4CF
            break;
        // End:0x228
        case 10:
            // End:0x1EF
            if(getInstanceUIData().getIsClassicServer())
            {
                // End:0x1D8
                if(getInstanceL2Util().isClanV2())
                {
                    RequestClanAskJoinByName(Username, 0);                    
                }
                else
                {
                    InviteClanPopWndClassicScript.showByPersonalConnectionsWndUsingUserName(Username);
                }                
            }
            else
            {
                // End:0x211
                if(getInstanceL2Util().isClanV2())
                {
                    RequestClanAskJoinByName(Username, 0);                    
                }
                else
                {
                    InviteClanPopWndScript.showByPersonalConnectionsWndUsingUserName(Username);
                }
            }
            // End:0x4CF
            break;
        // End:0x244
        case 11:
            Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(Username);
            // End:0x4CF
            break;
        // End:0x257
        case 12:
            RequestInviteParty(Username);
            // End:0x4CF
            break;
        // End:0x274
        case 13:
            ExecuteCommandFromAction("tacticalsign1");
            // End:0x4CF
            break;
        // End:0x291
        case 14:
            ExecuteCommandFromAction("tacticalsign2");
            // End:0x4CF
            break;
        // End:0x2AE
        case 15:
            ExecuteCommandFromAction("tacticalsign3");
            // End:0x4CF
            break;
        // End:0x2CB
        case 16:
            ExecuteCommandFromAction("tacticalsign4");
            // End:0x4CF
            break;
        // End:0x2E8
        case 17:
            ExecuteCommandFromAction("mountdismount");
            // End:0x4CF
            break;
        // End:0x2FF
        case 18:
            ExecuteCommandFromAction("pethold");
            // End:0x4CF
            break;
        // End:0x318
        case 19:
            ExecuteCommandFromAction("petrevert");
            // End:0x4CF
            break;
        // End:0x33A
        case 20:
            DoAction(Class'Interface.UICommonAPI'.static.GetItemID(1104));
            // End:0x4CF
            break;
        // End:0x35C
        case 21:
            DoAction(Class'Interface.UICommonAPI'.static.GetItemID(1103));
            // End:0x4CF
            break;
        // End:0x374
        case 25:
            ExecuteCommandFromAction("unsummon");
            // End:0x4CF
            break;
        // End:0x389
        case 23:
            ExecuteCommandFromAction("trade");
            // End:0x4CF
            break;
        // End:0x3A6
        case 22:
            ExecuteCommandFromAction("mountdismount");
            // End:0x4CF
            break;
        // End:0x3AE
        case 26:
            // End:0x4CF
            break;
        // End:0x3C8
        case 27:
            ExecuteCommandFromAction("partyleave");
            // End:0x4CF
            break;
        // End:0x3E4
        case 28:
            ExecuteCommandFromAction("partydismiss");
            // End:0x4CF
            break;
        // End:0x400
        case 29:
            ExecuteCommandFromAction("leaderchange");
            // End:0x4CF
            break;
        // End:0x41C
        case 30:
            ExecuteCommandFromAction("manufacture2");
            // End:0x4CF
            break;
        // End:0x437
        case 31:
            ExecuteCommandFromAction("manufacture");
            // End:0x4CF
            break;
        // End:0x48F
        case 33:
            RequestBlockListForAD(Username, ChatMsg);
            Debug("-> RequestBlockListForAD" @ Username);
            Debug("-> chatMsg" @ ChatMsg);
            // End:0x4CF
            break;
        // End:0x4CC
        case 34:
            Debug("-> RequestAddBlock" @ Username);
            Class'NWindow.PersonalConnectionAPI'.static.RequestAddBlock(Username);
            // End:0x4CF
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function whisperToUser(string Username)
{
    local ChatWnd chatWndScript;

    // End:0x44
    if(Username != "")
    {
        chatWndScript = ChatWnd(GetScript("ChatWnd"));
        chatWndScript.setChatEditBox(("\"" $ Username) $ " ");
    }
    return;
}

function bool isShowContextMenu()
{
    local bool bShow;
    local array<GFxValue> args;
    local GFxValue invokeResult;

    AllocGFxValues(args, 1);
    args[0].SetBool(false);
    AllocGFxValue(invokeResult);
    Invoke("_root.isShowContextMenu", args, invokeResult);
    bShow = invokeResult.GetBool();
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return bShow;
    return;
}

function OnFocus(bool bFlag, bool bTransparency)
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    AllocGFxValues(args, 2);
    args[0].SetBool(bFlag);
    args[1].SetBool(bTransparency);
    AllocGFxValue(invokeResult);
    Invoke("_root.onFocus", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    // End:0x8D
    if(!bFlag)
    {
        SetHavingFocus(false);
    }
    return;
}
