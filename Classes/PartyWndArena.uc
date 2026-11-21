class PartyWndArena extends UICommonAPI;

const NSTATUSICON_MAXCOL = 12;
const NPARTYSTATUS_HEIGHT = 47;
const NPARTYPETSTATUS_HEIGHT = 18;
const SMALL_BUF_ICON_SIZE = 6;
const MAX_ArrayNum = 10;
const MAX_BUFF_ICONTYPE = 4;
const ONCLASSICFORM_OFFSET_X = 12;
const ONAREAFORM_OFFSET_X = 3;

struct VnameData
{
    var int Id;
    var int UseVName;
    var int DominionIDForVName;
    var string VName;
    var string SummonVName;
};

var bool m_bCompact;
var bool m_bBuff;
var int m_arrID[10];
var int m_arrPetID[10];
var int m_arrSummonID[10];
var int m_arrPetIDOpen[10];
var int m_CurCount;
var int m_CurBf;
var int m_targetID;
var int m_LastChangeColor;
var VnameData m_Vname[10];
var bool m_AmIRoomMaster;
var WindowHandle m_wndTop;
var WindowHandle m_PartyStatus[10];
var WindowHandle m_PartyOption;
var NameCtrlHandle m_PlayerName[10];
var TextureHandle m_ClassIcon[10];
var TextureHandle m_LeaderIcon[10];
var TextureHandle m_VPIcon[10];
var TextureHandle m_IsDead[10];
var StatusIconHandle m_StatusIconBuff[10];
var StatusIconHandle m_StatusIconDeBuff[10];
var StatusIconHandle m_StatusIconSongDance[10];
var StatusIconHandle m_StatusIconTriggerSkill[10];
var BarHandle m_BarCP[10];
var BarHandle m_BarHP[10];
var BarHandle m_BarMP[10];
var ButtonHandle btnBuff;
var ButtonHandle m_petButton[10];
var ButtonHandle m_petButtonTrash[10];
var WindowHandle m_PetPartyStatus[10];
var StatusIconHandle m_PetStatusIconBuff[10];
var StatusIconHandle m_PetStatusIconDeBuff[10];
var StatusIconHandle m_PetStatusIconSongDance[10];
var StatusIconHandle m_PetStatusIconTriggerSkill[10];
var BarHandle m_PetBarHP[10];
var BarHandle m_PetBarMP[10];
var TextureHandle m_PetClassIcon[10];
var TextureHandle m_ClassIconSummon[10];
var TextureHandle m_ClassIconSummonNum[10];
var int partymasteridx;
var L2Util util;
var int PartyLeaderID;
var string currentBuffButtonState;
var int iconsOffsetX;
var array<int> m_arrMatchGroupMember;
var int currentindex;
var int matchGroupCount;
var int partyCount;

function OnRegisterEvent()
{
    RegisterEvent(1000);
    RegisterEvent(1140);
    RegisterEvent(1150);
    RegisterEvent(1160);
    RegisterEvent(1170);
    RegisterEvent(1180);
    RegisterEvent(1181);
    RegisterEvent(3131);
    RegisterEvent(3132);
    RegisterEvent(3133);
    RegisterEvent(3110);
    RegisterEvent(3120);
    RegisterEvent(3130);
    RegisterEvent(1050);
    RegisterEvent(40);
    RegisterEvent(980);
    RegisterEvent(9190);
    RegisterEvent(9200);
    RegisterEvent(1182);
    RegisterEvent(1183);
    RegisterEvent(1052);
    RegisterEvent(1053);
    RegisterEvent(8000);
    RegisterEvent(3410);
    return;
}

function checkClassicForm()
{
    local int idx;

    // End:0x1E
    if(getInstanceUIData().getIsClassicServer())
    {
        iconsOffsetX = 12;        
    }
    else
    {
        // End:0x3C
        if(getInstanceUIData().getIsArenaServer())
        {
            iconsOffsetX = 3;            
        }
        else
        {
            iconsOffsetX = 0;
        }
    }
    idx = 0;
    J0x4A:

    // End:0x138 [Loop If]
    if(idx < 10)
    {
        // End:0xAB
        if(getInstanceUIData().getIsClassicServer() || getInstanceUIData().getIsArenaServer())
        {
            m_VPIcon[idx].HideWindow();
            m_ClassIconSummonNum[idx].HideWindow();            
        }
        else
        {
            m_VPIcon[idx].ShowWindow();
            m_ClassIconSummonNum[idx].ShowWindow();
        }
        m_LeaderIcon[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ string(idx), "TopLeft", "TopLeft", 30 - iconsOffsetX, 8);
        idx++;
        // [Loop Continue]
        goto J0x4A;
    }
    return;
}

function setHideClassIconSummonNum(int idx)
{
    // End:0x2B
    if(getInstanceUIData().getIsClassicServer())
    {
        m_ClassIconSummonNum[idx].HideWindow();        
    }
    else
    {
        m_ClassIconSummonNum[idx].ShowWindow();
    }
    return;
}

function OnLoad()
{
    local int idx;

    util = L2Util(GetScript("L2Util"));
    InitHandleCOD();
    partymasteridx = -1;
    m_bCompact = false;
    m_bBuff = false;
    m_CurBf = 0;
    m_targetID = -1;
    m_LastChangeColor = -1;
    m_AmIRoomMaster = false;
    idx = 0;
    J0x66:

    // End:0x320 [Loop If]
    if(idx < 10)
    {
        m_StatusIconBuff[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 0, 5);
        m_StatusIconDeBuff[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 0, 5);
        m_StatusIconSongDance[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 0, 5);
        m_StatusIconTriggerSkill[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 0, 5);
        m_PetStatusIconBuff[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 1, 1);
        m_PetStatusIconDeBuff[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 1, 1);
        m_PetStatusIconSongDance[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 1, 1);
        m_PetStatusIconTriggerSkill[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 1, 1);
        idx++;
        // [Loop Continue]
        goto J0x66;
    }
    m_PartyOption.HideWindow();
    idx = 0;
    J0x336:

    // End:0x38A [Loop If]
    if(idx < 10)
    {
        m_PartyStatus[idx].SetDragOverTexture("L2UI_CT1.ListCtrl.ListCtrl_DF_HighLight");
        idx++;
        // [Loop Continue]
        goto J0x336;
    }
    ResetVName();
    m_arrMatchGroupMember.Length = 0;
    return;
}

function InitHandleCOD()
{
    local int idx;

    m_wndTop = GetWindowHandle("PartyWndArena");
    m_PartyOption = GetWindowHandle("PartyWndOption");
    idx = 0;
    J0x3E:

    // End:0x84B [Loop If]
    if(idx < 10)
    {
        m_PartyStatus[idx] = GetWindowHandle("PartyWndArena.PartyStatusWnd" $ string(idx));
        m_PlayerName[idx] = GetNameCtrlHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".PlayerName");
        m_ClassIcon[idx] = GetTextureHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".ClassIcon");
        m_LeaderIcon[idx] = GetTextureHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".LeaderIcon");
        m_VPIcon[idx] = GetTextureHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".PartyVPIcon");
        m_IsDead[idx] = GetTextureHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".IsDeadTexture");
        m_StatusIconBuff[idx] = GetStatusIconHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".StatusIconBuff");
        m_StatusIconDeBuff[idx] = GetStatusIconHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".StatusIconDeBuff");
        m_StatusIconSongDance[idx] = GetStatusIconHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".StatusIconSongDance");
        m_StatusIconTriggerSkill[idx] = GetStatusIconHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".StatusIconTriggerSkill");
        m_BarCP[idx] = GetBarHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".barCP");
        m_BarHP[idx] = GetBarHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".barHP");
        m_BarMP[idx] = GetBarHandle(("PartyWndArena.PartyStatusWnd" $ string(idx)) $ ".barMP");
        m_petButton[idx] = GetButtonHandle("PartyWndArena.btnSummon" $ string(idx));
        m_petButton[idx].HideWindow();
        m_PetPartyStatus[idx] = GetWindowHandle("PartyWndArena.PartyStatusSummonWnd" $ string(idx));
        m_PetStatusIconBuff[idx] = GetStatusIconHandle(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconBuff");
        m_PetStatusIconDeBuff[idx] = GetStatusIconHandle(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconDebuff");
        m_PetStatusIconSongDance[idx] = GetStatusIconHandle(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconSongDance");
        m_PetStatusIconTriggerSkill[idx] = GetStatusIconHandle(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconTriggerSkill");
        m_PetBarHP[idx] = GetBarHandle(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".barHP");
        m_PetBarMP[idx] = GetBarHandle(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".barMP");
        m_PetClassIcon[idx] = GetTextureHandle(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconPet");
        m_ClassIconSummon[idx] = GetTextureHandle(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconSummon");
        m_ClassIconSummonNum[idx] = GetTextureHandle(("PartyWndArena.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconSummonNum");
        m_arrPetIDOpen[idx] = -1;
        m_arrSummonID[idx] = -1;
        m_arrID[idx] = 0;
        // End:0x7EF
        if(idx == 0)
        {
            m_petButton[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ string(idx), "TopLeft", "TopRight", 0, 32);
            // [Explicit Continue]
            goto J0x841;
        }
        m_petButton[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ string(idx), "TopLeft", "TopRight", 0, 2);
        J0x841:

        idx++;
        // [Loop Continue]
        goto J0x3E;
    }
    btnBuff = GetButtonHandle("PartyWndArena.btnBuff");
    return;
}

function string getSummonSortString(int typeN)
{
    local string returnV;

    returnV = "";
    switch(typeN)
    {
        // End:0x27
        case 0:
            returnV = GetSystemString(2311);
            // End:0x8D
            break;
        // End:0x3F
        case 1:
            returnV = GetSystemString(2312);
            // End:0x8D
            break;
        // End:0x58
        case 2:
            returnV = GetSystemString(2313);
            // End:0x8D
            break;
        // End:0x71
        case 3:
            returnV = GetSystemString(2314);
            // End:0x8D
            break;
        // End:0x8A
        case 4:
            returnV = GetSystemString(2315);
            // End:0x8D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return returnV;
    return;
}

function OnShow()
{
    local int i, tmpInt;

    GetINIInt("PartyWndArena", "a", m_CurBf, "WindowsInfo.ini");
    SetBuffButtonTooltip();
    UpdateBuff();
    GetINIInt("PartyWndArena", "p", tmpInt, "WindowsInfo.ini");
    i = 0;
    J0x6F:

    // End:0xCF [Loop If]
    if(i < 9)
    {
        // End:0xA7
        if(bool(tmpInt))
        {
            // End:0xA4
            if(m_arrPetIDOpen[i] > 0)
            {
                m_arrPetIDOpen[i] = 2;
            }
            // [Explicit Continue]
            goto J0xC5;
        }
        // End:0xC5
        if(m_arrPetIDOpen[i] > 0)
        {
            m_arrPetIDOpen[i] = 1;
        }
        J0xC5:

        i++;
        // [Loop Continue]
        goto J0x6F;
    }
    resizeOnly();
    return;
}

function OnHide()
{
    ResetVName();
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x0E
    if((isAreaState()) == false)
    {
        return;
    }
    m_bCompact = false;
    m_bBuff = false;
    ResizeWnd();
    SetBuffButtonTooltip();
    UpdateBuff();
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x0E
    if((isAreaState()) == false)
    {
        return;
    }
    // End:0x2B
    if(Event_ID == 1140)
    {
        HandlePartyAddParty(param);        
    }
    else
    {
        // End:0x48
        if(Event_ID == 1150)
        {
            HandlePartyUpdateParty(param);            
        }
        else
        {
            // End:0x65
            if(Event_ID == 1160)
            {
                HandlePartyDeleteParty(param);                
            }
            else
            {
                // End:0x7D
                if(Event_ID == 1170)
                {
                    HandlePartyDeleteAllParty();                    
                }
                else
                {
                    // End:0xAB
                    if((Event_ID == 1180) || Event_ID == 1050)
                    {
                        HandlePartySpelledList(param);                        
                    }
                    else
                    {
                        // End:0xC8
                        if(Event_ID == 1000)
                        {
                            HandleShowBuffIcon(param);                            
                        }
                        else
                        {
                            // End:0xE5
                            if(Event_ID == 3131)
                            {
                                HandlePartySummonAdd(param);                                
                            }
                            else
                            {
                                // End:0x102
                                if(Event_ID == 3110)
                                {
                                    HandlePartyPetAdd(param);                                    
                                }
                                else
                                {
                                    // End:0x11F
                                    if(Event_ID == 3132)
                                    {
                                        HandlePartySummonUpdate(param);                                        
                                    }
                                    else
                                    {
                                        // End:0x13C
                                        if(Event_ID == 3120)
                                        {
                                            HandlePartyPetUpdate(param);                                            
                                        }
                                        else
                                        {
                                            // End:0x159
                                            if(Event_ID == 3133)
                                            {
                                                HandlePartySummonDelete(param);                                                
                                            }
                                            else
                                            {
                                                // End:0x176
                                                if(Event_ID == 3130)
                                                {
                                                    HandlePartyPetDelete(param);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x18B
                                                    if(Event_ID == 40)
                                                    {
                                                        HandleRestart();                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x1A3
                                                        if(Event_ID == 980)
                                                        {
                                                            HandleCheckTarget();                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x1C0
                                                            if(Event_ID == 1181)
                                                            {
                                                                HandlePartyRenameMember(param);                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x1DD
                                                                if(Event_ID == 9190)
                                                                {
                                                                    HandleRegistPartySubstitute(param);                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x1FA
                                                                    if(Event_ID == 9200)
                                                                    {
                                                                        HandleDeletePartySubstitute(param);                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x228
                                                                        if((Event_ID == 1182) || Event_ID == 1052)
                                                                        {
                                                                            HandlePartySpelledListDelete(param);                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x256
                                                                            if((Event_ID == 1183) || Event_ID == 1053)
                                                                            {
                                                                                HandlePartySpelledListInsert(param);                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x26E
                                                                                if(Event_ID == 8000)
                                                                                {
                                                                                    checkClassicForm();                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    // End:0x2B6
                                                                                    if(Event_ID == 3410)
                                                                                    {
                                                                                        // End:0x2B6
                                                                                        if((param == "ARENABATTLESTATE") && m_arrMatchGroupMember.Length > 0)
                                                                                        {
                                                                                            m_wndTop.ShowWindow();
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

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x44
        case "addGroupMember":
            m_arrMatchGroupMember.Length = m_arrMatchGroupMember.Length + 1;
            m_arrMatchGroupMember[m_arrMatchGroupMember.Length - 1] = int(param);
            // End:0x67
            break;
        // End:0x64
        case "resetGroupMember":
            m_arrMatchGroupMember.Length = 0;
            // End:0x67
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function bool isMatchGroupMember(int Id)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(i < m_arrMatchGroupMember.Length)
    {
        // End:0x2E
        if(m_arrMatchGroupMember[i] == Id)
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

function HandlePartyRenameMember(string param)
{
    local int idx, Id, UseVName, DominionIDForVName;
    local string VName, SummonVName;

    ParseInt(param, "ID", Id);
    ParseInt(param, "UseVName", UseVName);
    ParseInt(param, "DominionIDForVName", DominionIDForVName);
    ParseString(param, "VName", VName);
    ParseString(param, "SummonVName", SummonVName);
    idx = GetVNameIndexByID(Id);
    // End:0x11F
    if(idx > -1)
    {
        m_Vname[idx].Id = Id;
        m_Vname[idx].UseVName = UseVName;
        m_Vname[idx].DominionIDForVName = DominionIDForVName;
        m_Vname[idx].VName = VName;
        m_Vname[idx].SummonVName = SummonVName;
        ExecuteEvent(980);
    }
    return;
}

function HandleCheckTarget()
{
    local int idx;

    idx = -1;
    m_targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
    // End:0x3C
    if(m_targetID > 0)
    {
        idx = FindPartyID(m_targetID);
    }
    // End:0xB8
    if(m_LastChangeColor != -1)
    {
        m_PartyStatus[m_LastChangeColor].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Darker");
        m_targetID = -1;
        m_LastChangeColor = -1;
    }
    // End:0x127
    if(idx != -1)
    {
        m_LastChangeColor = idx;
        m_PartyStatus[idx].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Over");
    }
    return;
}

function HandleRestart()
{
    Clear();
    return;
}

function ClearTargetHighLight()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x74 [Loop If]
    if(i < 10)
    {
        m_PartyStatus[i].SetBackTexture("L2UI_CT1.Windows.Windows_DF_Small_Vertical_SizeControl_Bg_Darker");
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    m_LastChangeColor = -1;
    return;
}

function Clear()
{
    local int idx;

    idx = 0;
    J0x07:

    // End:0x4F [Loop If]
    if(idx < 10)
    {
        ClearStatus(idx);
        ClearPetStatus(idx);
        ClearSummonStatus(idx);
        m_arrSummonID[idx] = -1;
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    currentindex = 0;
    matchGroupCount = 0;
    partyCount = 0;
    m_CurCount = 0;
    m_targetID = -1;
    m_LastChangeColor = -1;
    ResizeWnd();
    ClearTargetHighLight();
    return;
}

function ClearStatus(int idx)
{
    m_StatusIconBuff[idx].Clear();
    m_StatusIconDeBuff[idx].Clear();
    m_StatusIconSongDance[idx].Clear();
    m_StatusIconTriggerSkill[idx].Clear();
    m_PlayerName[idx].SetName("", 0, 1);
    m_LeaderIcon[idx].SetTexture("");
    m_ClassIcon[idx].SetTexture("");
    UpdateCPBar(idx, 0, 0);
    UpdateHPBar(idx, 0, 0);
    UpdateMPBar(idx, 0, 0);
    m_arrID[idx] = 0;
    return;
}

function ClearPetStatus(int idx)
{
    m_PetStatusIconBuff[idx].Clear();
    m_PetStatusIconDeBuff[idx].Clear();
    m_PetStatusIconSongDance[idx].Clear();
    m_PetStatusIconTriggerSkill[idx].Clear();
    m_PetClassIcon[idx].HideWindow();
    UpdateHPBar(idx + 100, 0, 0);
    UpdateMPBar(idx + 100, 0, 0);
    m_arrPetID[idx] = -1;
    m_arrPetIDOpen[idx] = -1;
    m_arrSummonID[idx] = -1;
    return;
}

function ClearSummonStatus(int idx)
{
    m_arrSummonID[idx] = -1;
    m_ClassIconSummon[idx].HideWindow();
    m_ClassIconSummonNum[idx].HideWindow();
    return;
}

function CopyStatus(int DesIndex, int SrcIndex)
{
    local string strTmp;
    local int MaxValue, CurValue, Width, Height, row, Col,
	    maxrow, MaxCol;

    local StatusIconInfo Info;
    local CustomTooltip TooltipInfo, TooltipInfo2;
    local string vpIconTextureName, vpToolTipString;
    local Color NameColor;

    m_arrID[DesIndex] = m_arrID[SrcIndex];
    m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
    m_ClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo);
    m_ClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo);
    strTmp = m_LeaderIcon[SrcIndex].GetTextureName();
    m_LeaderIcon[DesIndex].SetTexture(strTmp);
    // End:0xFC
    if(Len(strTmp) > 0)
    {
        strTmp = m_PlayerName[DesIndex].GetName();
        GetTextSizeDefault(strTmp, Width, Height);
        m_LeaderIcon[DesIndex].ShowWindow();
    }
    m_LeaderIcon[SrcIndex].GetTooltipCustomType(TooltipInfo2);
    m_LeaderIcon[DesIndex].SetTooltipCustomType(TooltipInfo2);
    m_BarCP[SrcIndex].GetValue(MaxValue, CurValue);
    m_BarCP[DesIndex].SetValue(MaxValue, CurValue);
    m_BarMP[SrcIndex].GetValue(MaxValue, CurValue);
    m_BarMP[DesIndex].SetValue(MaxValue, CurValue);
    m_BarHP[SrcIndex].GetValue(MaxValue, CurValue);
    m_BarHP[DesIndex].SetValue(MaxValue, CurValue);
    // End:0x20D
    if(CurValue == 0)
    {
        m_IsDead[DesIndex].ShowWindow();        
    }
    else
    {
        m_IsDead[DesIndex].HideWindow();
    }
    // End:0x271
    if(isMatchGroupMember(m_arrID[DesIndex]))
    {
        NameColor.R = 238;
        NameColor.G = 170;
        NameColor.B = byte(255);
        NameColor.A = byte(255);        
    }
    else
    {
        NameColor = util.White;
    }
    m_PlayerName[DesIndex].SetNameWithColor(m_PlayerName[SrcIndex].GetName(), 0, 1, NameColor);
    vpIconTextureName = m_VPIcon[DesIndex].GetTextureName();
    vpToolTipString = m_VPIcon[DesIndex].GetTooltipText();
    m_VPIcon[DesIndex].SetTexture(m_VPIcon[SrcIndex].GetTextureName());
    m_VPIcon[DesIndex].SetTooltipText(m_VPIcon[SrcIndex].GetTooltipText());
    m_VPIcon[SrcIndex].SetTexture(vpIconTextureName);
    m_VPIcon[SrcIndex].SetTooltipText(vpToolTipString);
    m_StatusIconBuff[DesIndex].Clear();
    maxrow = m_StatusIconBuff[SrcIndex].GetRowCount();
    row = 0;
    J0x3AD:

    // End:0x45E [Loop If]
    if(row < maxrow)
    {
        m_StatusIconBuff[DesIndex].AddRow();
        MaxCol = m_StatusIconBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x3F8:

        // End:0x454 [Loop If]
        if(Col < MaxCol)
        {
            m_StatusIconBuff[SrcIndex].GetItem(row, Col, Info);
            m_StatusIconBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x3F8;
        }
        row++;
        // [Loop Continue]
        goto J0x3AD;
    }
    m_StatusIconDeBuff[DesIndex].Clear();
    maxrow = m_StatusIconDeBuff[SrcIndex].GetRowCount();
    row = 0;
    J0x495:

    // End:0x553 [Loop If]
    if(row < maxrow)
    {
        m_StatusIconDeBuff[DesIndex].AddRow();
        MaxCol = m_StatusIconDeBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x4E0:

        // End:0x549 [Loop If]
        if(Col < MaxCol)
        {
            m_StatusIconDeBuff[SrcIndex].GetItem(row, Col, Info);
            Info.bHideRemainTime = true;
            m_StatusIconDeBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x4E0;
        }
        row++;
        // [Loop Continue]
        goto J0x495;
    }
    m_StatusIconSongDance[DesIndex].Clear();
    maxrow = m_StatusIconSongDance[SrcIndex].GetRowCount();
    row = 0;
    J0x58A:

    // End:0x63B [Loop If]
    if(row < maxrow)
    {
        m_StatusIconSongDance[DesIndex].AddRow();
        MaxCol = m_StatusIconSongDance[SrcIndex].GetColCount(row);
        Col = 0;
        J0x5D5:

        // End:0x631 [Loop If]
        if(Col < MaxCol)
        {
            m_StatusIconSongDance[SrcIndex].GetItem(row, Col, Info);
            m_StatusIconSongDance[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x5D5;
        }
        row++;
        // [Loop Continue]
        goto J0x58A;
    }
    m_StatusIconTriggerSkill[DesIndex].Clear();
    maxrow = m_StatusIconTriggerSkill[SrcIndex].GetRowCount();
    row = 0;
    J0x672:

    // End:0x723 [Loop If]
    if(row < maxrow)
    {
        m_StatusIconTriggerSkill[DesIndex].AddRow();
        MaxCol = m_StatusIconTriggerSkill[SrcIndex].GetColCount(row);
        Col = 0;
        J0x6BD:

        // End:0x719 [Loop If]
        if(Col < MaxCol)
        {
            m_StatusIconTriggerSkill[SrcIndex].GetItem(row, Col, Info);
            m_StatusIconTriggerSkill[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x6BD;
        }
        row++;
        // [Loop Continue]
        goto J0x672;
    }
    m_arrPetID[DesIndex] = m_arrPetID[SrcIndex];
    m_arrSummonID[DesIndex] = m_arrSummonID[SrcIndex];
    m_arrPetIDOpen[DesIndex] = m_arrPetIDOpen[SrcIndex];
    m_PetBarHP[SrcIndex].GetValue(MaxValue, CurValue);
    m_PetBarHP[DesIndex].SetValue(MaxValue, CurValue);
    m_PetBarMP[SrcIndex].GetValue(MaxValue, CurValue);
    m_PetBarMP[DesIndex].SetValue(MaxValue, CurValue);
    m_PetStatusIconBuff[DesIndex].Clear();
    maxrow = m_PetStatusIconBuff[SrcIndex].GetRowCount();
    row = 0;
    J0x81B:

    // End:0x8CC [Loop If]
    if(row < maxrow)
    {
        m_PetStatusIconBuff[DesIndex].AddRow();
        MaxCol = m_PetStatusIconBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x866:

        // End:0x8C2 [Loop If]
        if(Col < MaxCol)
        {
            m_PetStatusIconBuff[SrcIndex].GetItem(row, Col, Info);
            m_PetStatusIconBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x866;
        }
        row++;
        // [Loop Continue]
        goto J0x81B;
    }
    m_PetStatusIconDeBuff[DesIndex].Clear();
    maxrow = m_PetStatusIconDeBuff[SrcIndex].GetRowCount();
    row = 0;
    J0x903:

    // End:0x9C1 [Loop If]
    if(row < maxrow)
    {
        m_PetStatusIconDeBuff[DesIndex].AddRow();
        MaxCol = m_PetStatusIconDeBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x94E:

        // End:0x9B7 [Loop If]
        if(Col < MaxCol)
        {
            m_PetStatusIconDeBuff[SrcIndex].GetItem(row, Col, Info);
            Info.bHideRemainTime = true;
            m_PetStatusIconDeBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x94E;
        }
        row++;
        // [Loop Continue]
        goto J0x903;
    }
    m_PetStatusIconSongDance[DesIndex].Clear();
    maxrow = m_PetStatusIconSongDance[SrcIndex].GetRowCount();
    row = 0;
    J0x9F8:

    // End:0xAA9 [Loop If]
    if(row < maxrow)
    {
        m_PetStatusIconSongDance[DesIndex].AddRow();
        MaxCol = m_PetStatusIconSongDance[SrcIndex].GetColCount(row);
        Col = 0;
        J0xA43:

        // End:0xA9F [Loop If]
        if(Col < MaxCol)
        {
            m_PetStatusIconSongDance[SrcIndex].GetItem(row, Col, Info);
            m_PetStatusIconSongDance[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0xA43;
        }
        row++;
        // [Loop Continue]
        goto J0x9F8;
    }
    m_PetStatusIconTriggerSkill[DesIndex].Clear();
    maxrow = m_PetStatusIconTriggerSkill[SrcIndex].GetRowCount();
    row = 0;
    J0xAE0:

    // End:0xB91 [Loop If]
    if(row < maxrow)
    {
        m_PetStatusIconTriggerSkill[DesIndex].AddRow();
        MaxCol = m_PetStatusIconTriggerSkill[SrcIndex].GetColCount(row);
        Col = 0;
        J0xB2B:

        // End:0xB87 [Loop If]
        if(Col < MaxCol)
        {
            m_PetStatusIconTriggerSkill[SrcIndex].GetItem(row, Col, Info);
            m_PetStatusIconTriggerSkill[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0xB2B;
        }
        row++;
        // [Loop Continue]
        goto J0xAE0;
    }
    ClearTargetHighLight();
    HandleCheckTarget();
    return;
}

function resizeOnly()
{
    local int idx;
    local Rect rectWnd;
    local bool bOption;
    local int i, OpenPetCount;
    local PartyMemberInfo PartyMemberInfo;
    local int tmpInt;

    GetINIInt("PartyWndArena", "e", tmpInt, "Windowsinfo.ini");
    bOption = bool(tmpInt);
    // End:0x4CD
    if(m_CurCount > 0)
    {
        idx = 0;
        J0x4E:

        // End:0x3F7 [Loop If]
        if(idx < 10)
        {
            // End:0x398
            if(idx <= (m_CurCount - 1))
            {
                // End:0x148
                if(idx > 0)
                {
                    // End:0xEE
                    if(m_arrPetIDOpen[idx - 1] == 1)
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);                        
                    }
                    else
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);
                    }
                }
                // End:0x1C6
                if(m_arrID[idx] != 0)
                {
                    // End:0x186
                    if(m_arrPetIDOpen[idx] > -1)
                    {
                        m_petButton[idx].ShowWindow();                        
                    }
                    else
                    {
                        m_petButton[idx].HideWindow();
                    }
                    m_PartyStatus[idx].SetVirtualDrag(true);
                    m_PartyStatus[idx].ShowWindow();
                }
                GetPartyMemberInfo(m_arrID[idx], PartyMemberInfo);
                // End:0x36F
                if((PartyMemberInfo.curSummonNum > 0) || PartyMemberInfo.curHavePet)
                {
                    // End:0x21E
                    if(m_arrPetIDOpen[idx] == -1)
                    {
                        m_arrPetIDOpen[idx] = 1;
                    }
                    m_PetPartyStatus[idx].ShowWindow();
                    // End:0x2B3
                    if(PartyMemberInfo.curSummonNum > 0)
                    {
                        m_ClassIconSummon[idx].ShowWindow();
                        setHideClassIconSummonNum(idx);
                        m_ClassIconSummonNum[idx].SetTexture("L2UI_ch3.PartyWndArena.party_summmon_num" $ string(PartyMemberInfo.curSummonNum));                        
                    }
                    else
                    {
                        m_ClassIconSummon[idx].HideWindow();
                        m_ClassIconSummonNum[idx].HideWindow();
                    }
                    // End:0x32D
                    if(PartyMemberInfo.curHavePet)
                    {
                        m_PetBarMP[idx].ShowWindow();
                        m_PetBarHP[idx].ShowWindow();
                        m_PetClassIcon[idx].ShowWindow();                        
                    }
                    else
                    {
                        m_PetBarMP[idx].HideWindow();
                        m_PetBarHP[idx].HideWindow();
                        m_PetClassIcon[idx].HideWindow();
                    }                    
                }
                else
                {
                    m_PetPartyStatus[idx].HideWindow();
                    m_arrPetIDOpen[idx] = -1;
                }
                // [Explicit Continue]
                goto J0x3ED;
            }
            m_petButton[idx].HideWindow();
            m_PartyStatus[idx].SetVirtualDrag(false);
            m_PartyStatus[idx].HideWindow();
            m_PetPartyStatus[idx].HideWindow();
            J0x3ED:

            idx++;
            // [Loop Continue]
            goto J0x4E;
        }
        OpenPetCount = 0;
        i = 0;
        J0x405:

        // End:0x463 [Loop If]
        if(i < 10)
        {
            // End:0x42C
            if(m_arrPetIDOpen[i] == 1)
            {
                OpenPetCount++;
                // [Explicit Continue]
                goto J0x459;
            }
            // End:0x459
            if(m_PetPartyStatus[i].IsShowWindow())
            {
                m_PetPartyStatus[i].HideWindow();
            }
            J0x459:

            i++;
            // [Loop Continue]
            goto J0x405;
        }
        rectWnd = m_wndTop.GetRect();
        m_wndTop.SetWindowSize(rectWnd.nWidth, (47 * m_CurCount) + (OpenPetCount * 18));
        m_wndTop.SetResizeFrameSize(10, (47 * m_CurCount) + (OpenPetCount * 18));        
    }
    else
    {
        m_wndTop.HideWindow();
    }
    return;
}

function ResizeWnd()
{
    local int idx;
    local Rect rectWnd;
    local bool bOption;
    local int i, OpenPetCount;
    local PartyMemberInfo PartyMemberInfo;
    local int tmpInt;

    GetINIInt("PartyWndArena", "e", tmpInt, "Windowsinfo.ini");
    bOption = bool(tmpInt);
    // End:0x4DC
    if(m_CurCount > 0)
    {
        idx = 0;
        J0x4E:

        // End:0x3F7 [Loop If]
        if(idx < 10)
        {
            // End:0x398
            if(idx <= (m_CurCount - 1))
            {
                // End:0x148
                if(idx > 0)
                {
                    // End:0xEE
                    if(m_arrPetIDOpen[idx - 1] == 1)
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWndArena.PartyStatusSummonWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);                        
                    }
                    else
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWndArena.PartyStatusWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);
                    }
                }
                // End:0x1C6
                if(m_arrID[idx] != 0)
                {
                    // End:0x186
                    if(m_arrPetIDOpen[idx] > -1)
                    {
                        m_petButton[idx].ShowWindow();                        
                    }
                    else
                    {
                        m_petButton[idx].HideWindow();
                    }
                    m_PartyStatus[idx].SetVirtualDrag(true);
                    m_PartyStatus[idx].ShowWindow();
                }
                GetPartyMemberInfo(m_arrID[idx], PartyMemberInfo);
                // End:0x36F
                if((PartyMemberInfo.curSummonNum > 0) || PartyMemberInfo.curHavePet)
                {
                    // End:0x21E
                    if(m_arrPetIDOpen[idx] == -1)
                    {
                        m_arrPetIDOpen[idx] = 1;
                    }
                    m_PetPartyStatus[idx].ShowWindow();
                    // End:0x2B3
                    if(PartyMemberInfo.curSummonNum > 0)
                    {
                        m_ClassIconSummon[idx].ShowWindow();
                        setHideClassIconSummonNum(idx);
                        m_ClassIconSummonNum[idx].SetTexture("L2UI_ch3.PartyWndArena.party_summmon_num" $ string(PartyMemberInfo.curSummonNum));                        
                    }
                    else
                    {
                        m_ClassIconSummon[idx].HideWindow();
                        m_ClassIconSummonNum[idx].HideWindow();
                    }
                    // End:0x32D
                    if(PartyMemberInfo.curHavePet)
                    {
                        m_PetBarMP[idx].ShowWindow();
                        m_PetBarHP[idx].ShowWindow();
                        m_PetClassIcon[idx].ShowWindow();                        
                    }
                    else
                    {
                        m_PetBarMP[idx].HideWindow();
                        m_PetBarHP[idx].HideWindow();
                        m_PetClassIcon[idx].HideWindow();
                    }                    
                }
                else
                {
                    m_PetPartyStatus[idx].HideWindow();
                    m_arrPetIDOpen[idx] = -1;
                }
                // [Explicit Continue]
                goto J0x3ED;
            }
            m_petButton[idx].HideWindow();
            m_PartyStatus[idx].SetVirtualDrag(false);
            m_PartyStatus[idx].HideWindow();
            m_PetPartyStatus[idx].HideWindow();
            J0x3ED:

            idx++;
            // [Loop Continue]
            goto J0x4E;
        }
        OpenPetCount = 0;
        i = 0;
        J0x405:

        // End:0x463 [Loop If]
        if(i < 10)
        {
            // End:0x42C
            if(m_arrPetIDOpen[i] == 1)
            {
                OpenPetCount++;
                // [Explicit Continue]
                goto J0x459;
            }
            // End:0x459
            if(m_PetPartyStatus[i].IsShowWindow())
            {
                m_PetPartyStatus[i].HideWindow();
            }
            J0x459:

            i++;
            // [Loop Continue]
            goto J0x405;
        }
        rectWnd = m_wndTop.GetRect();
        m_wndTop.SetWindowSize(rectWnd.nWidth, (47 * m_CurCount) + (OpenPetCount * 18));
        m_wndTop.SetResizeFrameSize(10, (47 * m_CurCount) + (OpenPetCount * 18));
        m_wndTop.ShowWindow();        
    }
    else
    {
        m_wndTop.HideWindow();
    }
    return;
}

function int FindPartyID(int Id)
{
    local int idx;

    idx = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(idx < 10)
    {
        // End:0x2E
        if(m_arrID[idx] == Id)
        {
            return idx;
        }
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function int FindPetID(int Id)
{
    local int idx;

    idx = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(idx < 10)
    {
        // End:0x2E
        if(m_arrPetID[idx] == Id)
        {
            return idx;
        }
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function int FindSummonMasterID(int Id)
{
    local int idx;

    idx = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(idx < 10)
    {
        // End:0x2E
        if(m_arrSummonID[idx] == Id)
        {
            return idx;
        }
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function HandlePartyAddParty(string param)
{
    local int Id, SummonID, UseVName, DominionIDForVName, SummonCount;

    local string VName, SummonVName;
    local PartyMemberInfo PartyMemberInfo;
    local PartyMemberPetInfo PartyMemberPetInfo;
    local int Index, i, summonClassID, summonType, summonMAXHP, summonMAXMP,
	    summonHP, summonMP;

    ParseInt(param, "ID", Id);
    ParseInt(param, "SummonID", SummonID);
    ParseInt(param, "UseVName", UseVName);
    ParseInt(param, "DominionIDForVName", DominionIDForVName);
    ParseString(param, "SummonVName", SummonVName);
    GetPartyMemberInfo(Id, PartyMemberInfo);
    GetPartyMemberPetInfo(Id, PartyMemberPetInfo);
    // End:0x3B8
    if(Id > 0)
    {
        // End:0xD7
        if(isMatchGroupMember(Id))
        {
            currentindex = matchGroupCount;
            matchGroupCount++;            
        }
        else
        {
            currentindex = m_arrMatchGroupMember.Length + partyCount;
            partyCount++;
        }
        m_CurCount++;
        m_Vname[currentindex].Id = Id;
        m_Vname[currentindex].UseVName = UseVName;
        m_Vname[currentindex].DominionIDForVName = DominionIDForVName;
        m_Vname[currentindex].VName = VName;
        m_Vname[currentindex].SummonVName = SummonVName;
        ExecuteEvent(980);
        m_arrID[currentindex] = Id;
        UpdateStatus(currentindex, param);
        // End:0x248
        if(PartyMemberInfo.curSummonNum > 0)
        {
            PartySummonProcess(Id);
            i = 0;
            J0x1B4:

            // End:0x248 [Loop If]
            if(i < SummonCount)
            {
                ParseInt(param, "SummonType" $ string(i), summonType);
                ParseInt(param, "SummonClassID" $ string(i), summonClassID);
                // End:0x23E
                if(summonType == 1)
                {
                    m_ClassIconSummon[currentindex].SetTooltipText(GetSystemString(505));
                    // [Explicit Break]
                    goto J0x248;
                }
                i++;
                // [Loop Continue]
                goto J0x1B4;
            }
        }
        J0x248:

        // End:0x3B2
        if(PartyMemberInfo.curHavePet == true)
        {
            Index = FindPartyID(Id);
            ParseInt(param, "SummonCount", SummonCount);
            i = 0;
            J0x28E:

            // End:0x39C [Loop If]
            if(i < SummonCount)
            {
                ParseInt(param, "SummonType" $ string(i), summonType);
                // End:0x392
                if(summonType == 2)
                {
                    ParseInt(param, "SummonMaxHP" $ string(i), summonMAXHP);
                    ParseInt(param, "SummonMaxMP" $ string(i), summonMAXMP);
                    ParseInt(param, "SummonHP" $ string(i), summonHP);
                    ParseInt(param, "SummonMP" $ string(i), summonMP);
                    UpdateHPBar(Index + 100, summonHP, summonMAXHP);
                    UpdateMPBar(Index + 100, summonMP, summonMAXMP);
                }
                i++;
                // [Loop Continue]
                goto J0x28E;
            }
            m_arrPetID[Index] = PartyMemberPetInfo.petID;
        }
        ResizeWnd();
    }
    return;
}

function HandlePartyUpdateParty(string param)
{
    local int Id, idx;

    ParseInt(param, "ID", Id);
    // End:0x40
    if(Id > 0)
    {
        idx = FindPartyID(Id);
        UpdateStatus(idx, param);
    }
    return;
}

function HandlePartyDeleteParty(string param)
{
    local int Id, idx, i;

    ParseInt(param, "ID", Id);
    // End:0xC1
    if(Id > 0)
    {
        idx = FindPartyID(Id);
        // End:0xC1
        if(idx > -1)
        {
            // End:0x57
            if(isMatchGroupMember(Id))
            {
                matchGroupCount--;                
            }
            else
            {
                partyCount--;
            }
            i = idx;
            J0x69:

            // End:0x98 [Loop If]
            if(i < (m_CurCount - 1))
            {
                CopyStatus(i, i + 1);
                i++;
                // [Loop Continue]
                goto J0x69;
            }
            ClearStatus(m_CurCount - 1);
            ClearPetStatus(m_CurCount - 1);
            m_CurCount--;
            ResizeWnd();
        }
    }
    return;
}

function HandlePartyDeleteAllParty()
{
    Clear();
    return;
}

function SetMasterTooltip(int Lootingtype)
{
    // End:0x43
    if((partymasteridx < 10) && partymasteridx > -1)
    {
        m_LeaderIcon[partymasteridx].SetTooltipCustomType(MakeTooltipSimpleText(GetRoutingString(Lootingtype)));
    }
    return;
}

function UpdateStatus(int idx, string param)
{
    local string Name;
    local int Id, cp, maxCP, hp, MaxHP, mp,
	    maxMP, ClassID, Level, vitality;

    local UserInfo TargetUser;
    local int UseVName;
    local string VName;
    local int SummonCount, iSubstatus;
    local Color NameColor;

    ParseInt(param, "SubStitute", iSubstatus);
    // End:0x37
    if((idx < 0) || idx >= 10)
    {
        return;
    }
    ParseString(param, "Name", Name);
    ParseInt(param, "ID", Id);
    GetUserInfo(Id, TargetUser);
    ParseInt(param, "CurCP", cp);
    ParseInt(param, "MaxCP", maxCP);
    ParseInt(param, "CurHP", hp);
    ParseInt(param, "MaxHP", MaxHP);
    ParseInt(param, "CurMP", mp);
    ParseInt(param, "MaxMP", maxMP);
    ParseInt(param, "ClassID", ClassID);
    ParseInt(param, "Level", Level);
    ParseInt(param, "Vitality", vitality);
    ParseInt(param, "SummonCount", SummonCount);
    // End:0x1AB
    if(isMatchGroupMember(Id))
    {
        NameColor.R = 238;
        NameColor.G = 170;
        NameColor.B = byte(255);
        NameColor.A = byte(255);        
    }
    else
    {
        NameColor = util.White;
    }
    // End:0x1E2
    if(hp == 0)
    {
        m_IsDead[idx].ShowWindow();        
    }
    else
    {
        m_IsDead[idx].HideWindow();
    }
    UseVName = m_Vname[idx].UseVName;
    VName = m_Vname[idx].VName;
    // End:0x254
    if(UseVName == 1)
    {
        m_PlayerName[idx].SetNameWithColor(VName, 0, 1, NameColor);        
    }
    else
    {
        m_PlayerName[idx].SetNameWithColor(Name, 0, 1, NameColor);
    }
    m_ClassIcon[idx].SetTexture(GetClassArenaRoleIconName(ClassID));
    m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText((GetClassRoleName(ClassID) $ " - ") $ GetClassType(ClassID)));
    UpdateCPBar(idx, cp, maxCP);
    UpdateHPBar(idx, hp, MaxHP);
    UpdateMPBar(idx, mp, maxMP);
    return;
}

function HandlePartyPetAdd(string param)
{
    local int MasterID, Id, i, Type, MasterIndex;

    ParseInt(param, "Type", Type);
    // End:0xE8
    if(Type == 2)
    {
        ParseInt(param, "MasterID", MasterID);
        ParseInt(param, "ID", Id);
        // End:0xE8
        if(MasterID > 0)
        {
            MasterIndex = -1;
            i = 0;
            J0x6D:

            // End:0xA3 [Loop If]
            if(i < 10)
            {
                // End:0x99
                if(m_arrID[i] == MasterID)
                {
                    MasterIndex = i;
                }
                i++;
                // [Loop Continue]
                goto J0x6D;
            }
            // End:0xB4
            if(MasterIndex == -1)
            {
                return;
            }
            m_arrPetID[MasterIndex] = Id;
            m_arrPetIDOpen[MasterIndex] = 1;
            UpdatePetStatus(MasterIndex, param);
            ResizeWnd();
        }
    }
    return;
}

function HandlePartyPetUpdate(string param)
{
    local int Id, idx, Type;

    ParseInt(param, "Type", Type);
    ParseInt(param, "ID", Id);
    // End:0x57
    if(Type == 2)
    {
        idx = FindPetID(Id);
        UpdatePetStatus(idx, param);
    }
    return;
}

function HandlePartyPetDelete(string param)
{
    local int SummonID, idx;

    ParseInt(param, "SummonID", SummonID);
    // End:0x56
    if(SummonID > 0)
    {
        idx = FindPetID(SummonID);
        // End:0x56
        if(idx > -1)
        {
            ClearPetStatus(idx);
            ResizeWnd();
        }
    }
    return;
}

function UpdatePetStatus(int idx, string param)
{
    local int Id, ClassID, Type, MasterID, hp, MaxHP,
	    mp, maxMP, Level;

    // End:0x1B
    if((idx < 0) || idx >= 10)
    {
        return;
    }
    ParseInt(param, "ID", Id);
    ParseInt(param, "ClassID", ClassID);
    ParseInt(param, "Type", Type);
    ParseInt(param, "MasterID", MasterID);
    ParseInt(param, "HP", hp);
    ParseInt(param, "MaxHP", MaxHP);
    ParseInt(param, "MP", mp);
    ParseInt(param, "MaxMP", maxMP);
    ParseInt(param, "Level", Level);
    UpdateHPBar(idx + 100, hp, MaxHP);
    UpdateMPBar(idx + 100, mp, maxMP);
    return;
}

function HandlePartySummonAdd(string param)
{
    local int MasterID, Id, idx, Type;
    local SummonInfo m_SummonInfo;

    ParseInt(param, "Type", Type);
    ParseInt(param, "MasterID", MasterID);
    ParseInt(param, "ID", Id);
    GetSummonInfo(Id, m_SummonInfo);
    idx = FindSummonMasterID(MasterID);
    // End:0x90
    if(idx > 0)
    {
        m_ClassIconSummon[idx].SetTooltipText(GetSystemString(505));
    }
    // End:0xA6
    if(Type == 1)
    {
        PartySummonProcess(MasterID);
    }
    return;
}

function PartySummonProcess(int MasterID)
{
    local int i, MasterIndex;
    local PartyMemberInfo PartyMemberInfo;

    // End:0xB2
    if(MasterID > 0)
    {
        MasterIndex = -1;
        i = 0;
        J0x1D:

        // End:0x56 [Loop If]
        if(i < 10)
        {
            // End:0x4C
            if(m_arrID[i] == MasterID)
            {
                MasterIndex = i;
                // [Explicit Break]
                goto J0x56;
            }
            i++;
            // [Loop Continue]
            goto J0x1D;
        }
        J0x56:

        // End:0x67
        if(MasterIndex == -1)
        {
            return;
        }
        GetPartyMemberInfo(MasterID, PartyMemberInfo);
        // End:0x9B
        if(PartyMemberInfo.curSummonNum > 0)
        {
            m_arrSummonID[MasterIndex] = MasterID;            
        }
        else
        {
            m_arrSummonID[MasterIndex] = -1;
        }
        ResizeWnd();
    }
    return;
}

function HandlePartySummonUpdate(string param)
{
    local int MasterID, Type;

    ParseInt(param, "MasterID", MasterID);
    ParseInt(param, "Type", Type);
    // End:0x46
    if(Type == 1)
    {
        PartySummonProcess(MasterID);
    }
    return;
}

function HandlePartySummonDelete(string param)
{
    local int SummonMasterID, idx;
    local PartyMemberInfo PartyMemberInfo;

    ParseInt(param, "SummonMasterID", SummonMasterID);
    // End:0xDD
    if(SummonMasterID > 0)
    {
        idx = FindSummonMasterID(SummonMasterID);
        GetPartyMemberInfo(SummonMasterID, PartyMemberInfo);
        // End:0xCC
        if(PartyMemberInfo.curSummonNum > 0)
        {
            m_ClassIconSummon[idx].ShowWindow();
            setHideClassIconSummonNum(idx);
            m_ClassIconSummonNum[idx].SetTexture("L2UI_ch3.PartyWndArena.party_summmon_num" $ string(PartyMemberInfo.curSummonNum));            
        }
        else
        {
            ClearSummonStatus(idx);
        }
        ResizeWnd();
    }
    return;
}

function UpdateSummonStatus(int idx, string param)
{
    local int Id, ClassID, Type, MasterID, hp, MaxHP,
	    mp, maxMP, Level;

    // End:0x1B
    if((idx < 0) || idx >= 10)
    {
        return;
    }
    ParseInt(param, "ID", Id);
    ParseInt(param, "ClassID", ClassID);
    ParseInt(param, "Type", Type);
    ParseInt(param, "MasterID", MasterID);
    ParseInt(param, "HP", hp);
    ParseInt(param, "MaxHP", MaxHP);
    ParseInt(param, "MP", mp);
    ParseInt(param, "MaxMP", maxMP);
    ParseInt(param, "Level", Level);
    return;
}

function HandlePartySpelledList(string param)
{
    local int i, idx, Id, Max, BuffCnt, BuffCurRow,
	    DeBuffCnt, DeBuffCurRow, TriggerSkillCnt, TriggerSkillCurRow;

    local bool isPC;
    local StatusIconInfo Info;

    DeBuffCurRow = -1;
    BuffCurRow = -1;
    TriggerSkillCurRow = -1;
    isPC = false;
    ParseInt(param, "ID", Id);
    // End:0x4A
    if(Id < 1)
    {
        return;
    }
    idx = FindPartyID(Id);
    // End:0xC5
    if(idx >= 0)
    {
        m_StatusIconBuff[idx].Clear();
        m_StatusIconDeBuff[idx].Clear();
        m_StatusIconSongDance[idx].Clear();
        m_StatusIconTriggerSkill[idx].Clear();
        isPC = true;        
    }
    else
    {
        idx = FindPetID(Id);
        // End:0x140
        if(idx >= 0)
        {
            m_PetStatusIconBuff[idx].Clear();
            m_PetStatusIconDeBuff[idx].Clear();
            m_PetStatusIconSongDance[idx].Clear();
            m_PetStatusIconTriggerSkill[idx].Clear();
            isPC = false;            
        }
        else
        {
            return;
        }
    }
    // End:0x15B
    if(isPC)
    {
        Info.Size = 16;        
    }
    else
    {
        Info.Size = 10;
    }
    Info.bShow = true;
    ParseInt(param, "Max", Max);
    i = 0;
    J0x191:

    // End:0x5D4 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        // End:0x23C
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            // [Explicit Continue]
            goto J0x5CA;
        }
        ParseInt(param, "Sec_" $ string(i), Info.RemainTime);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x5CA
        if(IsValidItemID(Info.Id))
        {
            Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
            // End:0x3B2
            if(GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0)
            {
                Info.bHideRemainTime = true;
                // End:0x35E
                if((float(DeBuffCnt) % float(12)) == float(0))
                {
                    DeBuffCurRow++;
                    // End:0x349
                    if(isPC)
                    {
                        m_StatusIconDeBuff[idx].AddRow();                        
                    }
                    else
                    {
                        m_PetStatusIconDeBuff[idx].AddRow();
                    }
                }
                // End:0x389
                if(isPC)
                {
                    m_StatusIconDeBuff[idx].AddCol(DeBuffCurRow, Info);                    
                }
                else
                {
                    m_PetStatusIconDeBuff[idx].AddCol(DeBuffCurRow, Info);
                }
                DeBuffCnt++;
                // [Explicit Continue]
                goto J0x5CA;
            }
            // End:0x457
            if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                // End:0x3FD
                if(isPC)
                {
                    m_StatusIconSongDance[idx].AddRow();                    
                }
                else
                {
                    m_PetStatusIconSongDance[idx].AddRow();
                }
                // End:0x439
                if(isPC)
                {
                    m_StatusIconSongDance[idx].AddCol(0, Info);                    
                }
                else
                {
                    m_PetStatusIconSongDance[idx].AddCol(0, Info);
                }
                // [Explicit Continue]
                goto J0x5CA;
            }
            // End:0x527
            if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                // End:0x4D3
                if((float(TriggerSkillCnt) % float(12)) == float(0))
                {
                    TriggerSkillCurRow++;
                    // End:0x4BE
                    if(isPC)
                    {
                        m_StatusIconTriggerSkill[idx].AddRow();                        
                    }
                    else
                    {
                        m_PetStatusIconTriggerSkill[idx].AddRow();
                    }
                }
                // End:0x4FE
                if(isPC)
                {
                    m_StatusIconTriggerSkill[idx].AddCol(TriggerSkillCurRow, Info);                    
                }
                else
                {
                    m_PetStatusIconTriggerSkill[idx].AddCol(TriggerSkillCurRow, Info);
                }
                TriggerSkillCnt++;
                // [Explicit Continue]
                goto J0x5CA;
            }
            // End:0x579
            if((float(BuffCnt) % float(12)) == float(0))
            {
                BuffCurRow++;
                // End:0x564
                if(isPC)
                {
                    m_StatusIconBuff[idx].AddRow();                    
                }
                else
                {
                    m_PetStatusIconBuff[idx].AddRow();
                }
            }
            // End:0x5A4
            if(isPC)
            {
                m_StatusIconBuff[idx].AddCol(BuffCurRow, Info);                
            }
            else
            {
                m_PetStatusIconBuff[idx].AddCol(BuffCurRow, Info);
            }
            BuffCnt++;
        }
        J0x5CA:

        i++;
        // [Loop Continue]
        goto J0x191;
    }
    UpdateBuff();
    return;
}

function HandlePartySpelledListDelete(string param)
{
    local int i, idx, Id, Max;
    local StatusIconInfo Info;
    local bool isPC;

    ParseInt(param, "ID", Id);
    // End:0x21
    if(Id < 1)
    {
        return;
    }
    idx = FindPartyID(Id);
    // End:0x59
    if(idx < 0)
    {
        isPC = false;
        idx = FindPetID(Id);        
    }
    else
    {
        isPC = true;
    }
    // End:0x6E
    if(idx < 0)
    {
        return;
    }
    ParseInt(param, "Max", Max);
    i = 0;
    J0x8A:

    // End:0x3A0 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x396
        if(IsValidItemID(Info.Id))
        {
            // End:0x1E0
            if(GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0)
            {
                // End:0x1A9
                if(isPC)
                {
                    deleteBuff(m_StatusIconDeBuff[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);                    
                }
                else
                {
                    deleteBuff(m_PetStatusIconDeBuff[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
                }
                // [Explicit Continue]
                goto J0x396;
            }
            // End:0x281
            if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                // End:0x24A
                if(isPC)
                {
                    deleteBuff(m_StatusIconSongDance[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);                    
                }
                else
                {
                    deleteBuff(m_PetStatusIconSongDance[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
                }
                // [Explicit Continue]
                goto J0x396;
            }
            // End:0x322
            if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                // End:0x2EB
                if(isPC)
                {
                    deleteBuff(m_StatusIconTriggerSkill[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);                    
                }
                else
                {
                    deleteBuff(m_PetStatusIconTriggerSkill[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
                }
                // [Explicit Continue]
                goto J0x396;
            }
            // End:0x362
            if(isPC)
            {
                deleteBuff(m_StatusIconBuff[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
                // [Explicit Continue]
                goto J0x396;
            }
            deleteBuff(m_PetStatusIconBuff[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
        }
        J0x396:

        i++;
        // [Loop Continue]
        goto J0x8A;
    }
    UpdateBuff();
    return;
}

function deleteBuff(StatusIconHandle tmpStatusIcon, int Level, int ClassID, int SpellerID)
{
    local int row, Col;
    local StatusIconInfo Info;

    row = 0;
    J0x07:

    // End:0xE7 [Loop If]
    if(row < tmpStatusIcon.GetRowCount())
    {
        Col = 0;
        J0x27:

        // End:0xDD [Loop If]
        if(Col < tmpStatusIcon.GetColCount(row))
        {
            tmpStatusIcon.GetItem(row, Col, Info);
            // End:0xD3
            if(((Info.Id.ClassID == ClassID) && Info.Level == Level) && Info.SpellerID == SpellerID)
            {
                tmpStatusIcon.DelItem(row, Col);
                refreshPostion(tmpStatusIcon, row);
                return;
            }
            Col++;
            // [Loop Continue]
            goto J0x27;
        }
        row++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function refreshPostion(StatusIconHandle tmpStatusIcon, int deletedRow)
{
    local int row;
    local StatusIconInfo Info;

    row = deletedRow;
    J0x0B:

    // End:0x7F [Loop If]
    if(row < (tmpStatusIcon.GetRowCount() - 1))
    {
        tmpStatusIcon.GetItem(row + 1, 0, Info);
        tmpStatusIcon.AddCol(row, Info);
        tmpStatusIcon.DelItem(row + 1, 0);
        row++;
        // [Loop Continue]
        goto J0x0B;
    }
    return;
}

function HandlePartySpelledListInsert(string param)
{
    local int i, idx, Id, Max;
    local StatusIconInfo Info;
    local StatusIconHandle tmpStatusIcon;
    local bool isPC;

    ParseInt(param, "ID", Id);
    // End:0x21
    if(Id < 1)
    {
        return;
    }
    idx = FindPartyID(Id);
    // End:0x59
    if(idx < 0)
    {
        isPC = false;
        idx = FindPetID(Id);        
    }
    else
    {
        isPC = true;
    }
    // End:0x6E
    if(idx < 0)
    {
        return;
    }
    // End:0x87
    if(isPC)
    {
        Info.Size = 16;        
    }
    else
    {
        Info.Size = 10;
    }
    Info.bShow = true;
    ParseInt(param, "Max", Max);
    i = 0;
    J0xBD:

    // End:0x402 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        // End:0x168
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            // [Explicit Continue]
            goto J0x3F8;
        }
        ParseInt(param, "Sec_" $ string(i), Info.RemainTime);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x3F8
        if(IsValidItemID(Info.Id))
        {
            Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
            Info.bHideRemainTime = true;
            // End:0x269
            if(GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0)
            {
                // End:0x255
                if(isPC)
                {
                    tmpStatusIcon = m_StatusIconDeBuff[idx];                    
                }
                else
                {
                    tmpStatusIcon = m_PetStatusIconDeBuff[idx];
                }                
            }
            else
            {
                // End:0x2C4
                if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
                {
                    // End:0x2B0
                    if(isPC)
                    {
                        tmpStatusIcon = m_StatusIconSongDance[idx];                        
                    }
                    else
                    {
                        tmpStatusIcon = m_PetStatusIconSongDance[idx];
                    }                    
                }
                else
                {
                    // End:0x31F
                    if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
                    {
                        // End:0x30B
                        if(isPC)
                        {
                            tmpStatusIcon = m_StatusIconTriggerSkill[idx];                            
                        }
                        else
                        {
                            tmpStatusIcon = m_PetStatusIconTriggerSkill[idx];
                        }                        
                    }
                    else
                    {
                        // End:0x33C
                        if(isPC)
                        {
                            tmpStatusIcon = m_StatusIconBuff[idx];                            
                        }
                        else
                        {
                            tmpStatusIcon = m_PetStatusIconBuff[idx];
                        }
                    }
                }
            }
            deleteBuff(tmpStatusIcon, Info.Level, Info.Id.ClassID, Info.SpellerID);
            // End:0x3D2
            if((tmpStatusIcon.GetRowCount() == 0) || (float(tmpStatusIcon.GetColCount(tmpStatusIcon.GetRowCount() - 1)) % float(12)) == float(0))
            {
                tmpStatusIcon.AddRow();
            }
            tmpStatusIcon.AddCol(tmpStatusIcon.GetRowCount() - 1, Info);
        }
        J0x3F8:

        i++;
        // [Loop Continue]
        goto J0xBD;
    }
    UpdateBuff();
    return;
}

function HandleShowBuffIcon(string param)
{
    local int nShow;

    ParseInt(param, "Show", nShow);
    m_CurBf = m_CurBf + 1;
    // End:0x37
    if(m_CurBf > 4)
    {
        m_CurBf = 0;
    }
    SetINIInt("PartyWndArena", "a", m_CurBf, "WindowsInfo.ini");
    SetBuffButtonTooltip();
    UpdateBuff();
    return;
}

function OnClickButton(string strID)
{
    local int idx;
    local PartyWndCompact script;

    script = PartyWndCompact(GetScript("PartyWndCompact"));
    switch(strID)
    {
        // End:0x3E
        case "btnBuff":
            OnBuffButton();
            // End:0x6A
            break;
        // End:0x56
        case "btnCompact":
            OnOpenPartyWndOption();
            // End:0x6A
            break;
        // End:0x67
        case "btnSummon":
            // End:0x6A
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xFC
    if(InStr(strID, "btnSummon") > -1)
    {
        idx = int(Right(strID, 1));
        // End:0xD4
        if(m_PetPartyStatus[idx].IsShowWindow())
        {
            m_PetPartyStatus[idx].HideWindow();
            m_arrPetIDOpen[idx] = 2;            
        }
        else
        {
            m_PetPartyStatus[idx].ShowWindow();
            m_arrPetIDOpen[idx] = 1;
        }
        ResizeWnd();
    }
    return;
}

function OnOpenPartyWndOption()
{
    local int i;
    local PartyWndOption script;

    script = PartyWndOption(GetScript("PartyWndOption"));
    i = 0;
    J0x28:

    // End:0x5E [Loop If]
    if(i < 10)
    {
        script.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
        i++;
        // [Loop Continue]
        goto J0x28;
    }
    script.ShowPartyWndOption();
    m_PartyOption.SetAnchor("PartyWndArena.PartyStatusWnd0", "TopRight", "TopLeft", 5, 5);
    return;
}

function OnBuffButton()
{
    m_CurBf = m_CurBf + 1;
    // End:0x21
    if(m_CurBf > 4)
    {
        m_CurBf = 0;
    }
    SetINIInt("PartyWndArena", "a", m_CurBf, "WindowsInfo.ini");
    SetBuffButtonTooltip();
    UpdateBuff();
    return;
}

function UpdateBuff()
{
    local int idx;

    // End:0xD3
    if(m_CurBf == 1)
    {
        idx = 0;
        J0x12:

        // End:0xD0 [Loop If]
        if(idx < 10)
        {
            m_StatusIconBuff[idx].ShowWindow();
            m_PetStatusIconBuff[idx].ShowWindow();
            m_StatusIconDeBuff[idx].HideWindow();
            m_PetStatusIconDeBuff[idx].HideWindow();
            m_StatusIconSongDance[idx].HideWindow();
            m_PetStatusIconSongDance[idx].HideWindow();
            m_StatusIconTriggerSkill[idx].HideWindow();
            m_PetStatusIconTriggerSkill[idx].HideWindow();
            idx++;
            // [Loop Continue]
            goto J0x12;
        }        
    }
    else
    {
        // End:0x1A7
        if(m_CurBf == 2)
        {
            idx = 0;
            J0xE6:

            // End:0x1A4 [Loop If]
            if(idx < 10)
            {
                m_StatusIconBuff[idx].HideWindow();
                m_PetStatusIconBuff[idx].HideWindow();
                m_StatusIconDeBuff[idx].ShowWindow();
                m_PetStatusIconDeBuff[idx].ShowWindow();
                m_StatusIconSongDance[idx].HideWindow();
                m_PetStatusIconSongDance[idx].HideWindow();
                m_StatusIconTriggerSkill[idx].HideWindow();
                m_PetStatusIconTriggerSkill[idx].HideWindow();
                idx++;
                // [Loop Continue]
                goto J0xE6;
            }            
        }
        else
        {
            // End:0x27B
            if(m_CurBf == 3)
            {
                idx = 0;
                J0x1BA:

                // End:0x278 [Loop If]
                if(idx < 10)
                {
                    m_StatusIconBuff[idx].HideWindow();
                    m_PetStatusIconBuff[idx].HideWindow();
                    m_StatusIconDeBuff[idx].HideWindow();
                    m_PetStatusIconDeBuff[idx].HideWindow();
                    m_StatusIconSongDance[idx].ShowWindow();
                    m_PetStatusIconSongDance[idx].ShowWindow();
                    m_StatusIconTriggerSkill[idx].HideWindow();
                    m_PetStatusIconTriggerSkill[idx].HideWindow();
                    idx++;
                    // [Loop Continue]
                    goto J0x1BA;
                }                
            }
            else
            {
                // End:0x34F
                if(m_CurBf == 4)
                {
                    idx = 0;
                    J0x28E:

                    // End:0x34C [Loop If]
                    if(idx < 10)
                    {
                        m_StatusIconBuff[idx].HideWindow();
                        m_PetStatusIconBuff[idx].HideWindow();
                        m_StatusIconDeBuff[idx].HideWindow();
                        m_PetStatusIconDeBuff[idx].HideWindow();
                        m_StatusIconSongDance[idx].HideWindow();
                        m_PetStatusIconSongDance[idx].HideWindow();
                        m_StatusIconTriggerSkill[idx].ShowWindow();
                        m_PetStatusIconTriggerSkill[idx].ShowWindow();
                        idx++;
                        // [Loop Continue]
                        goto J0x28E;
                    }                    
                }
                else
                {
                    idx = 0;
                    J0x356:

                    // End:0x414 [Loop If]
                    if(idx < 10)
                    {
                        m_StatusIconBuff[idx].HideWindow();
                        m_PetStatusIconBuff[idx].HideWindow();
                        m_StatusIconDeBuff[idx].HideWindow();
                        m_PetStatusIconDeBuff[idx].HideWindow();
                        m_StatusIconSongDance[idx].HideWindow();
                        m_PetStatusIconSongDance[idx].HideWindow();
                        m_StatusIconTriggerSkill[idx].HideWindow();
                        m_PetStatusIconTriggerSkill[idx].HideWindow();
                        idx++;
                        // [Loop Continue]
                        goto J0x356;
                    }
                }
            }
        }
    }
    return;
}

function UpdateCPBar(int idx, int Value, int MaxValue)
{
    m_BarCP[idx].SetValue(MaxValue, Value);
    return;
}

function UpdateHPBar(int idx, int Value, int MaxValue)
{
    // End:0x2E
    if(idx < 100)
    {
        m_BarHP[idx].SetValue(MaxValue, Value);        
    }
    else
    {
        m_PetBarHP[idx - 100].SetValue(MaxValue, Value);
    }
    return;
}

function UpdateMPBar(int idx, int Value, int MaxValue)
{
    // End:0x2E
    if(idx < 100)
    {
        m_BarMP[idx].SetValue(MaxValue, Value);        
    }
    else
    {
        m_PetBarMP[idx - 100].SetValue(MaxValue, Value);
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local Rect rectWnd, rectPetClassIcon;
    local UserInfo UserInfo;
    local int idx;

    rectWnd = m_wndTop.GetRect();
    // End:0x1C6
    if((X > (rectWnd.nX + 13)) && X < ((rectWnd.nX + rectWnd.nWidth) - 10))
    {
        // End:0x1C6
        if(GetPlayerInfo(UserInfo))
        {
            idx = GetIdx(Y - rectWnd.nY);
            rectWnd = m_PetPartyStatus[idx].GetRect();
            rectPetClassIcon = m_PetClassIcon[idx].GetRect();
            // End:0x143
            if(IsPKMode())
            {
                // End:0xE7
                if(idx < 100)
                {
                    RequestAttack(m_arrID[idx], UserInfo.loc);                    
                }
                else
                {
                    // End:0x140
                    if((X > rectPetClassIcon.nX) && X < ((rectWnd.nX + rectWnd.nWidth) - 10))
                    {
                        RequestAttack(m_arrPetID[idx - 100], UserInfo.loc);
                    }
                }                
            }
            else
            {
                // End:0x16D
                if(idx < 100)
                {
                    RequestAction(m_arrID[idx], UserInfo.loc);                    
                }
                else
                {
                    // End:0x1C6
                    if((X > rectPetClassIcon.nX) && X < ((rectWnd.nX + rectWnd.nWidth) - 10))
                    {
                        RequestAction(m_arrPetID[idx - 100], UserInfo.loc);
                    }
                }
            }
        }
    }
    return;
}

function OnRButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local Rect rectWnd;
    local UserInfo UserInfo;
    local int idx;

    rectWnd = m_wndTop.GetRect();
    // End:0xC7
    if((X > (rectWnd.nX + 13)) && X < ((rectWnd.nX + rectWnd.nWidth) - 10))
    {
        // End:0xC7
        if(GetPlayerInfo(UserInfo))
        {
            idx = GetIdx(Y - rectWnd.nY);
            // End:0xA8
            if(idx < 100)
            {
                RequestAssist(m_arrID[idx], UserInfo.loc);                
            }
            else
            {
                RequestAssist(m_arrPetID[idx - 100], UserInfo.loc);
            }
        }
    }
    return;
}

function int GetIdx(int Y)
{
    local int tempY, i, idx;

    idx = -1;
    tempY = Y;
    i = 0;
    J0x1D:

    // End:0xA1 [Loop If]
    if(i < 10)
    {
        tempY = tempY - 47;
        // End:0x57
        if(tempY < 0)
        {
            idx = i;
            return idx;
            // [Explicit Continue]
            goto J0x97;
        }
        // End:0x97
        if(m_arrPetIDOpen[i] == 1)
        {
            tempY = tempY - 18;
            // End:0x97
            if(tempY < 0)
            {
                idx = i + 100;
                return idx;
            }
        }
        J0x97:

        i++;
        // [Loop Continue]
        goto J0x1D;
    }
    return idx;
    return;
}

function SetBuffButtonTooltip()
{
    local int idx;

    switch(m_CurBf)
    {
        // End:0x19
        case 0:
            idx = 1496;
            // End:0x67
            break;
        // End:0x2B
        case 1:
            idx = 1497;
            // End:0x67
            break;
        // End:0x3E
        case 2:
            idx = 1741;
            // End:0x67
            break;
        // End:0x51
        case 3:
            idx = 2307;
            // End:0x67
            break;
        // End:0x64
        case 4:
            idx = 1498;
            // End:0x67
            break;
        // End:0xFFFF
        default:
            break;
    }
    btnBuff.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(idx)));
    return;
}

function OnDropWnd(WindowHandle hTarget, WindowHandle hDropWnd, int X, int Y)
{
    local string sTargetName, sDropName, sTargetParent;
    local int dropIdx, targetIdx, i;
    local PartyWndCompact script2;

    script2 = PartyWndCompact(GetScript("PartyWndCompact"));
    dropIdx = -1;
    targetIdx = -1;
    // End:0x52
    if((hTarget == none) || hDropWnd == none)
    {
        return;
    }
    sTargetName = hTarget.GetWindowName();
    sDropName = hDropWnd.GetWindowName();
    sTargetParent = hTarget.GetParentWindowName();
    // End:0xFD
    if(((InStr(sTargetName, "PartyStatusWnd") == -1) && InStr(sTargetParent, "PartyStatusWnd") == -1) || InStr(sDropName, "PartyStatusWnd") == -1)
    {
        return;        
    }
    else
    {
        dropIdx = int(Right(sDropName, 1));
        // End:0x141
        if(InStr(sTargetName, "PartyStatusWnd") > -1)
        {
            targetIdx = int(Right(sTargetName, 1));            
        }
        else
        {
            targetIdx = int(Right(sTargetParent, 1));
        }
        // End:0x169
        if((dropIdx < 0) || targetIdx < 0)
        {
        }
        // End:0x21A
        if(dropIdx > targetIdx)
        {
            CopyStatus(9, dropIdx);
            script2.CopyStatus(9, dropIdx);
            i = dropIdx - 1;
            J0x1A9:

            // End:0x1F4 [Loop If]
            if(i > (targetIdx - 1))
            {
                CopyStatus(i + 1, i);
                script2.CopyStatus(i + 1, i);
                i--;
                // [Loop Continue]
                goto J0x1A9;
            }
            CopyStatus(targetIdx, 9);
            script2.CopyStatus(targetIdx, 9);            
        }
        else
        {
            // End:0x2C8
            if(dropIdx < targetIdx)
            {
                CopyStatus(9, dropIdx);
                script2.CopyStatus(9, dropIdx);
                i = dropIdx + 1;
                J0x25A:

                // End:0x2A5 [Loop If]
                if(i < (targetIdx + 1))
                {
                    CopyStatus(i - 1, i);
                    script2.CopyStatus(i - 1, i);
                    i++;
                    // [Loop Continue]
                    goto J0x25A;
                }
                CopyStatus(targetIdx, 9);
                script2.CopyStatus(targetIdx, 9);
            }
        }
        ClearStatus(9);
        ClearPetStatus(9);
        Class'NWindow.UIDATA_PARTY'.static.MovePartyMember(dropIdx, targetIdx);
        ResizeWnd();
    }
    return;
}

function int GetVNameIndexByID(int Id)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x3D [Loop If]
    if(i < 10)
    {
        // End:0x33
        if(m_Vname[i].Id == Id)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function ResetVName()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x7D [Loop If]
    if(i < 10)
    {
        m_Vname[i].Id = i;
        m_Vname[i].UseVName = 0;
        m_Vname[i].DominionIDForVName = 0;
        m_Vname[i].VName = "";
        m_Vname[i].SummonVName = "";
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function HandleRegistPartySubstitute(string param)
{
    local int iOK, iUserID;

    ParseInt(param, "OK", iOK);
    ParseInt(param, "UserID", iUserID);
    return;
}

function HandleDeletePartySubstitute(string param)
{
    local int iOK, iUserID;

    ParseInt(param, "OK", iOK);
    ParseInt(param, "UserID", iUserID);
    return;
}
