class UnionDetailWnd extends UICommonAPI;

const MAX_PARTY_PLAYER = 9;

var int m_MasterID;
var int nPartyTotalKill;
var int nPartyTotalDeath;
var string m_WindowName;
var WindowHandle Me;
var TextBoxHandle txtMasterName;
var TextBoxHandle txtPartyInfo;
var TextBoxHandle txtPartyEfficiency;
var ListCtrlHandle lstPartyMember;
var UnionWnd Union;

function OnRegisterEvent()
{
    RegisterEvent(1420);
    return;
}

function OnLoad()
{
    Me = GetWindowHandle(m_WindowName);
    txtMasterName = GetTextBoxHandle(m_WindowName $ ".txtMasterName");
    txtPartyInfo = GetTextBoxHandle(m_WindowName $ ".txtPartyInfo");
    txtPartyEfficiency = GetTextBoxHandle(m_WindowName $ ".txtPartyEfficiency");
    lstPartyMember = GetListCtrlHandle(m_WindowName $ ".lstPartyMember");
    Union = UnionWnd(GetScript("UnionWnd"));
    lstPartyMember.SetSelectedSelTooltip(false);
    lstPartyMember.SetAppearTooltipAtMouseX(true);
    nPartyTotalKill = 0;
    nPartyTotalDeath = 0;
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1A
    if(Event_ID == 1420)
    {
        HandleCommandChannelPartyMember(param);
    }
    return;
}

function SetMasterInfo(string masterName, int MasterID)
{
    txtMasterName.SetText(masterName);
    m_MasterID = MasterID;
    return;
}

function int GetMasterID()
{
    return m_MasterID;
    return;
}

function Clear()
{
    lstPartyMember.DeleteAllItem();
    txtMasterName.SetText("");
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1D
        case "btnClose":
            OnCloseClick();
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

function OnCloseClick()
{
    Me.HideWindow();
    return;
}

function OnDBClickListCtrlRecord(string strID)
{
    local UserInfo UserInfo;
    local LVDataRecord Record;
    local int ServerID;

    // End:0x8F
    if(strID == "lstPartyMember")
    {
        lstPartyMember.GetSelectedRec(Record);
        ServerID = name(Record.nReserved1);
        // End:0x8F
        if(ServerID > 0)
        {
            // End:0x8F
            if(GetPlayerInfo(UserInfo))
            {
                // End:0x7A
                if(IsPKMode())
                {
                    RequestAttack(ServerID, UserInfo.loc);                    
                }
                else
                {
                    RequestAction(ServerID, UserInfo.loc);
                }
            }
        }
    }
    return;
}

function HandleCommandChannelPartyMember(string param)
{
    local LVDataRecord Record, clearRecord;
    local string Name, strParam;
    local int idx, MemberCount, ClassID, ServerID, nKillCnt, nDeathCnt,
	    nPvPDamage, nPvEDamage;

    local array<string> strData;

    lstPartyMember.DeleteAllItem();
    nPartyTotalKill = 0;
    nPartyTotalDeath = 0;
    ParseInt(param, "MemberCount", MemberCount);
    idx = 0;
    J0x41:

    // End:0x38B [Loop If]
    if(idx < MemberCount)
    {
        ParseString(param, "Name_" $ string(idx), strParam);
        ParseInt(param, "ClassID_" $ string(idx), ClassID);
        ParseInt(param, "ServerID_" $ string(idx), ServerID);
        strData = Arr(strParam, ";");
        Name = strData[0];
        nKillCnt = int(strData[1]);
        nDeathCnt = int(strData[2]);
        nPvPDamage = int(strData[3]);
        nPvEDamage = int(strData[4]);
        nPartyTotalKill += nKillCnt;
        nPartyTotalDeath += nDeathCnt;
        // End:0x381
        if(Len(Name) > 0)
        {
            Record = clearRecord;
            Record.LVDataList.Length = 6;
            Record.nReserved1 = (ServerID);
            Record.nReserved2 = (ClassID);
            Record.LVDataList[0].bUseTextColor = ServerID == m_MasterID;
            Record.LVDataList[0].TextColor = getInstanceL2Util().Yellow03;
            Record.LVDataList[0].hasIcon = true;
            Record.LVDataList[0].FirstLineOffsetX = 6;
            Record.LVDataList[0].IconPosX = 1;
            Record.LVDataList[0].nTextureWidth = 16;
            Record.LVDataList[0].nTextureHeight = 16;
            Record.LVDataList[0].nTextureU = 16;
            Record.LVDataList[0].nTextureV = 16;
            Record.LVDataList[0].szData = string(ClassID);
            Record.LVDataList[0].szTexture = "UI_BOHPTS.icons.Class_Icon" $ string(ClassID);
            Record.LVDataList[0].szData = Name;
            Record.LVDataList[1].szData = string(nKillCnt);
            Record.LVDataList[1].textAlignment = 2;
            Record.LVDataList[2].szData = string(nDeathCnt);
            Record.LVDataList[2].textAlignment = 2;
            Record.LVDataList[3].szData = convertDamageToString(nPvPDamage);
            Record.LVDataList[3].textAlignment = 2;
            Record.LVDataList[4].szData = convertDamageToString(nPvEDamage);
            Record.LVDataList[4].textAlignment = 2;
            lstPartyMember.InsertRecord(Record);
        }
        idx++;
        // [Loop Continue]
        goto J0x41;
    }
    Union.UpdatePartyMemberCount(m_MasterID, MemberCount);
    UpdateCountInfo();
    return;
}

function UpdateCountInfo()
{
    txtPartyInfo.SetText((((GetSystemString(7686) @ string(lstPartyMember.GetRecordCount())) $ " / ") $ string(9)) @ GetSystemString(7674));
    txtPartyEfficiency.SetText((((string(nPartyTotalKill) @ GetSystemString(7688)) @ "/") @ string(nPartyTotalDeath)) @ GetSystemString(7689));
    return;
}

defaultproperties
{
    m_WindowName="UnionDetailWnd"
}