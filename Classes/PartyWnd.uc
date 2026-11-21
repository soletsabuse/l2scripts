class PartyWnd extends UICommonAPI;

const EV_PartySpelledListDelayed = 90001;
const NSTATUSICON_MAXCOL = 12;
const NPARTYSTATUS_HEIGHT = 46;
const NPARTYPETSTATUS_HEIGHT = 18;
const SMALL_BUF_ICON_SIZE = 6;
const MAX_ArrayNum = 10;
const MAX_BUFF_ICONTYPE = 4;
const ONCLASSICFORM_OFFSET_X = 12;

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
var int lv;
var WindowHandle m_wndTop;
var WindowHandle m_PartyStatus[10];
var WindowHandle m_PartyPremiumStatus[10];
var TextBoxHandle m_Partylevel[10];
var WindowHandle m_PartyOption;
var PartyWndOption PartyOption;
var NameCtrlHandle m_PlayerName[10];
var TextureHandle m_ClassIcon[10];
var TextureHandle m_LeaderIcon[10];
var TextureHandle m_VPIcon[10];
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
var TextureHandle NoblesseTex[10];
var BarHandle m_PetBarHP[10];
var BarHandle m_PetBarMP[10];
var TextureHandle m_PetClassIcon[10];
var TextureHandle m_ClassIconSummon[10];
var TextureHandle m_ClassIconSummonNum[10];
var TextureHandle m_IsDead[10];
var TextureHandle SelectedTexture[10];
var TextureHandle RessurectBg[10];
var TextureHandle CardTex[10];
var CheckBoxHandle cNoblesse;
var CheckBoxHandle CardShow;
var CheckBoxHandle cColoredNickname;
var CheckBoxHandle cRessurectHighlight;
var int partymasteridx;
var int partysubmasteridx;
var L2Util util;
var int PartyLeaderID;
var string currentBuffButtonState;
var int iconsOffsetX;
var array<int> nobleSkills;
var EffectSwapWnd EffectSwapWnd_script;
var string LastPacketData;
var int currentMasterId;

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
    RegisterEvent(9190);
    RegisterEvent(9200);
    RegisterEvent(1182);
    RegisterEvent(1183);
    RegisterEvent(1052);
    RegisterEvent(1053);
    RegisterEvent(90001);
    RegisterEvent(8000);
    RegisterEvent(980);
    RegisterEvent(3550);
    return;
}

function checkClassicForm()
{
    local int idx;

    // End:0x0F
    if(true)
    {
        iconsOffsetX = 12;        
    }
    else
    {
        iconsOffsetX = 0;
    }
    idx = 0;
    J0x1D:

    // End:0xB0 [Loop If]
    if(idx < 10)
    {
        // End:0x7C
        if(!SettingSectorBool("VITALITY", "VitalityEnabled"))
        {
            m_VPIcon[idx].HideWindow();
            m_ClassIconSummonNum[idx].HideWindow();
            // [Explicit Continue]
            goto J0xA6;
        }
        m_VPIcon[idx].ShowWindow();
        m_ClassIconSummonNum[idx].ShowWindow();
        J0xA6:

        idx++;
        // [Loop Continue]
        goto J0x1D;
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
    nobleSkills[nobleSkills.Length] = 438;
    nobleSkills[nobleSkills.Length] = 1323;
    nobleSkills[nobleSkills.Length] = 1410;
    nobleSkills[nobleSkills.Length] = 19224;
    partymasteridx = -1;
    currentMasterId = -1;
    partysubmasteridx = -1;
    m_bCompact = false;
    m_bBuff = false;
    m_CurBf = 0;
    m_targetID = -1;
    m_LastChangeColor = -1;
    m_AmIRoomMaster = false;
    idx = 0;
    J0xC4:

    // End:0x356 [Loop If]
    if(idx < 10)
    {
        m_StatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 0, 5);
        m_StatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 0, 5);
        m_StatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 0, 5);
        m_StatusIconTriggerSkill[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 0, 5);
        m_PetStatusIconBuff[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 1, 1);
        m_PetStatusIconDeBuff[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 1, 1);
        m_PetStatusIconSongDance[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 1, 1);
        m_PetStatusIconTriggerSkill[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 1, 1);
        idx++;
        // [Loop Continue]
        goto J0xC4;
    }
    EffectSwapWnd_script = EffectSwapWnd(GetScript("EffectSwapWnd"));
    m_PartyOption.HideWindow();
    idx = 0;
    J0x38C:

    // End:0x3E0 [Loop If]
    if(idx < 10)
    {
        m_PartyStatus[idx].SetDragOverTexture("L2UI_CT1.ListCtrl.ListCtrl_DF_HighLight");
        idx++;
        // [Loop Continue]
        goto J0x38C;
    }
    ResetVName();
    ResetAutoParty();
    return;
}

function InitHandleCOD()
{
    local int idx;

    m_wndTop = GetWindowHandle("PartyWnd");
    m_PartyOption = GetWindowHandle("PartyWndOption");
    PartyOption = PartyWndOption(GetScript("PartyWndOption"));
    idx = 0;
    J0x5A:

    // End:0xA76 [Loop If]
    if(idx < 10)
    {
        m_PartyStatus[idx] = GetWindowHandle("PartyWnd.PartyStatusWnd" $ string(idx));
        m_PartyPremiumStatus[idx] = GetWindowHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".StatusWnd_LevelTextBox_back.WndLevelBackPremium");
        m_Partylevel[idx] = GetTextBoxHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".StatusWnd_LevelTextBox_back.StatusWnd_LevelTextBox");
        m_PlayerName[idx] = GetNameCtrlHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".PlayerName");
        m_ClassIcon[idx] = GetTextureHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".ClassIcon");
        NoblesseTex[idx] = GetTextureHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".NoblesseTex");
        CardTex[idx] = GetTextureHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".CardTex");
        m_LeaderIcon[idx] = GetTextureHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".LeaderIcon");
        m_VPIcon[idx] = GetTextureHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".PartyVPIcon");
        m_StatusIconBuff[idx] = GetStatusIconHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".StatusIconBuff");
        m_StatusIconDeBuff[idx] = GetStatusIconHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".StatusIconDeBuff");
        m_StatusIconSongDance[idx] = GetStatusIconHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".StatusIconSongDance");
        m_StatusIconTriggerSkill[idx] = GetStatusIconHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".StatusIconTriggerSkill");
        m_BarCP[idx] = GetBarHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".barCP");
        m_BarHP[idx] = GetBarHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".barHP");
        m_BarMP[idx] = GetBarHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".barMP");
        m_petButton[idx] = GetButtonHandle("PartyWnd.btnSummon" $ string(idx));
        m_petButton[idx].HideWindow();
        m_PetPartyStatus[idx] = GetWindowHandle("PartyWnd.PartyStatusSummonWnd" $ string(idx));
        m_PetStatusIconBuff[idx] = GetStatusIconHandle(("PartyWnd.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconBuff");
        m_PetStatusIconDeBuff[idx] = GetStatusIconHandle(("PartyWnd.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconDebuff");
        m_PetStatusIconSongDance[idx] = GetStatusIconHandle(("PartyWnd.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconSongDance");
        m_PetStatusIconTriggerSkill[idx] = GetStatusIconHandle(("PartyWnd.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconTriggerSkill");
        m_PetBarHP[idx] = GetBarHandle(("PartyWnd.PartyStatusSummonWnd" $ string(idx)) $ ".barHP");
        m_PetBarMP[idx] = GetBarHandle(("PartyWnd.PartyStatusSummonWnd" $ string(idx)) $ ".barMP");
        m_PetClassIcon[idx] = GetTextureHandle(("PartyWnd.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconPet");
        m_ClassIconSummon[idx] = GetTextureHandle(("PartyWnd.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconSummon");
        m_ClassIconSummonNum[idx] = GetTextureHandle(("PartyWnd.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconSummonNum");
        m_IsDead[idx] = GetTextureHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".IsDeadTexture");
        SelectedTexture[idx] = GetTextureHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".SelectedTexture");
        RessurectBg[idx] = GetTextureHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".RessurectBg");
        m_arrPetIDOpen[idx] = -1;
        m_arrSummonID[idx] = -1;
        m_arrID[idx] = 0;
        cNoblesse = GetCheckBoxHandle("PartyWndOption.NobleShow");
        CardShow = GetCheckBoxHandle("PartyWndOption.CardShow");
        cColoredNickname = GetCheckBoxHandle("PartyWndOption.ColoredNicknameShow");
        cRessurectHighlight = GetCheckBoxHandle("PartyWndOption.RessurectHighlightShow");
        // End:0xA1F
        if(idx == 0)
        {
            m_petButton[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx), "TopLeft", "TopRight", 0, 32);
            // [Explicit Continue]
            goto J0xA6C;
        }
        m_petButton[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx), "TopLeft", "TopRight", 0, 2);
        J0xA6C:

        idx++;
        // [Loop Continue]
        goto J0x5A;
    }
    btnBuff = GetButtonHandle("PartyWnd.btnBuff");
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
            // End:0x90
            break;
        // End:0x3F
        case 1:
            returnV = GetSystemString(2312);
            // End:0x90
            break;
        // End:0x58
        case 2:
            returnV = GetSystemString(2313);
            // End:0x90
            break;
        // End:0x71
        case 3:
            returnV = GetSystemString(2314);
            // End:0x90
            break;
        // End:0x8A
        case 4:
            returnV = GetSystemString(2315);
            // End:0x90
            break;
        // End:0xFFFF
        default:
            // End:0x90
            break;
            break;
    }
    return returnV;
    return;
}

function OnShow()
{
    local int i, tmpInt;

    GetINIInt("PartyWnd", "a", m_CurBf, "WindowsInfo.ini");
    SetBuffButtonTooltip();
    UpdateBuff();
    GetINIInt("PartyWnd", "p", tmpInt, "WindowsInfo.ini");
    i = 0;
    J0x65:

    // End:0xDA [Loop If]
    if(i < 9)
    {
        // End:0x9D
        if(bool(tmpInt))
        {
            // End:0x9A
            if(m_arrPetIDOpen[i] > 0)
            {
                m_arrPetIDOpen[i] = 2;
            }            
        }
        else
        {
            // End:0xBB
            if(m_arrPetIDOpen[i] > 0)
            {
                m_arrPetIDOpen[i] = 1;
            }
        }
        HandleNoblesseActive("idx=" $ string(i));
        i++;
        // [Loop Continue]
        goto J0x65;
    }
    PartyOption.setSettings();
    Debug("onShow partyWnd");
    resizeOnly();
    selected();
    return;
}

function OnHide()
{
    ResetVName();
    return;
}

function OnEnterState(name a_PreStateName)
{
    m_bCompact = false;
    m_bBuff = false;
    ResizeWnd();
    SetBuffButtonTooltip();
    UpdateBuff();
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1D
    if(Event_ID == 1140)
    {
        HandlePartyAddParty(param);        
    }
    else
    {
        // End:0x3A
        if(Event_ID == 1150)
        {
            HandlePartyUpdateParty(param);            
        }
        else
        {
            // End:0x57
            if(Event_ID == 1160)
            {
                HandlePartyDeleteParty(param);                
            }
            else
            {
                // End:0x6F
                if(Event_ID == 1170)
                {
                    HandlePartyDeleteAllParty();                    
                }
                else
                {
                    // End:0x9D
                    if((Event_ID == 1180) || Event_ID == 1050)
                    {
                        HandlePartySpelledList(param);                        
                    }
                    else
                    {
                        // End:0xBA
                        if(Event_ID == 1000)
                        {
                            HandleShowBuffIcon(param);                            
                        }
                        else
                        {
                            // End:0xD7
                            if(Event_ID == 3131)
                            {
                                HandlePartySummonAdd(param);                                
                            }
                            else
                            {
                                // End:0xF4
                                if(Event_ID == 3110)
                                {
                                    HandlePartyPetAdd(param);                                    
                                }
                                else
                                {
                                    // End:0x111
                                    if(Event_ID == 3132)
                                    {
                                        HandlePartySummonUpdate(param);                                        
                                    }
                                    else
                                    {
                                        // End:0x12E
                                        if(Event_ID == 3120)
                                        {
                                            HandlePartyPetUpdate(param);                                            
                                        }
                                        else
                                        {
                                            // End:0x14B
                                            if(Event_ID == 3133)
                                            {
                                                HandlePartySummonDelete(param);                                                
                                            }
                                            else
                                            {
                                                // End:0x168
                                                if(Event_ID == 3130)
                                                {
                                                    HandlePartyPetDelete(param);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x17D
                                                    if(Event_ID == 40)
                                                    {
                                                        HandleRestart();                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x19A
                                                        if(Event_ID == 1181)
                                                        {
                                                            HandlePartyRenameMember(param);                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x1B7
                                                            if(Event_ID == 9190)
                                                            {
                                                                HandleRegistPartySubstitute(param);                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x1D4
                                                                if(Event_ID == 9200)
                                                                {
                                                                    HandleDeletePartySubstitute(param);                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x202
                                                                    if((Event_ID == 1182) || Event_ID == 1052)
                                                                    {
                                                                        HandlePartySpelledListDelete(param);                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x230
                                                                        if((Event_ID == 1183) || Event_ID == 1053)
                                                                        {
                                                                            HandlePartySpelledListInsert(param);                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x248
                                                                            if(Event_ID == 8000)
                                                                            {
                                                                                checkClassicForm();                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x260
                                                                                if(Event_ID == 980)
                                                                                {
                                                                                    selected();                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    // End:0x288
                                                                                    if(Event_ID == 90001)
                                                                                    {
                                                                                        HandleNoblesseActive(param);
                                                                                        handleClubCard(param);                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        // End:0x2A2
                                                                                        if(Event_ID == 3550)
                                                                                        {
                                                                                            handleCustomPacket(param);
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

function handleCustomPacket(string param)
{
    local int EventID;

    ParseInt(param, "EventID", EventID);
    switch(EventID)
    {
        // End:0x36
        case 1080:
            handleColorNickname(param);
            // End:0x68
            break;
        // End:0x4C
        case 1081:
            handleRessurectHighlight(param);
            // End:0x68
            break;
        // End:0x62
        case 1082:
            handleClubCard(param);
            // End:0x68
            break;
        // End:0xFFFF
        default:
            // End:0x68
            break;
            break;
    }
    return;
}

function handleClubCard(string param)
{
    local int Index, sID, nCardId;
    local ItemInfo item;

    ParseInt(param, "ask", sID);
    ParseInt(param, "reply", nCardId);
    Index = FindPartyID(sID);
    // End:0x97
    if(nCardId > 0)
    {
        GetItemInfoByClassID(nCardId, item);
        CardTex[Index].SetTooltipCustomType(getItemTooltip(item));
        CardTex[Index].SetAlpha(255, 0.2000000);        
    }
    else
    {
        CardTex[Index].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7813)));
        CardTex[Index].SetAlpha(50, 0.1000000);
    }
    return;
}

function handleColorNickname(string param)
{
    local int Index, sID, nNicknameColor;
    local Color Col;

    ParseInt(param, "ask", sID);
    ParseInt(param, "reply", nNicknameColor);
    Index = FindPartyID(sID);
    switch(nNicknameColor)
    {
        // End:0x5F
        case 0:
            Col = GetColor(255, 255, 255, 255);
            // End:0x99
            break;
        // End:0x79
        case 1:
            Col = GetColor(255, 0, 255, 255);
            // End:0x99
            break;
        // End:0x93
        case 2:
            Col = GetColor(255, 0, 0, 255);
            // End:0x99
            break;
        // End:0xFFFF
        default:
            // End:0x99
            break;
            break;
    }
    m_PlayerName[Index].SetNameWithColor(m_PlayerName[Index].GetName(), 0, 2, Col);
    return;
}

function handleRessurectHighlight(string param)
{
    local int sID, nType, Index;

    ParseInt(param, "ask", sID);
    ParseInt(param, "reply", nType);
    Index = FindPartyID(sID);
    showHideRessurectHighlight(nType, Index);
    return;
}

function showHideRessurectHighlight(int N, int Index)
{
    switch(N)
    {
        // End:0x29
        case 0:
            RessurectBg[Index].SetAlpha(0, 0.1000000);
            // End:0x52
            break;
        // End:0x4C
        case 1:
            RessurectBg[Index].SetAlpha(255, 0.1500000);
            // End:0x52
            break;
        // End:0xFFFF
        default:
            // End:0x52
            break;
            break;
    }
    return;
}

function HandleNoblesseActive(string param)
{
    local int idx;

    ParseInt(param, "idx", idx);
    // End:0x2B
    if(!cNoblesse.IsChecked())
    {
        return;
    }
    // End:0x7E
    if(ReturnNoblesseActive(idx))
    {
        NoblesseTex[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7814)));
        NoblesseTex[idx].SetAlpha(255, 0.1000000);        
    }
    else
    {
        NoblesseTex[idx].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7815)));
        NoblesseTex[idx].SetAlpha(50, 0.1500000);
    }
    return;
}

function bool ReturnNoblesseActive(int idx)
{
    local int i;
    local StatusIconHandle m_StatusIcon;

    // End:0x4D
    if(FindEffectArr(GetStatusIconHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".StatusIconDebuff"), nobleSkills))
    {
        return true;
    }
    // End:0x98
    if(FindEffectArr(GetStatusIconHandle(("PartyWnd.PartyStatusWnd" $ string(idx)) $ ".StatusIconBuff"), nobleSkills))
    {
        return true;
    }
    return;
}

function bool FindEffectEx(StatusIconHandle StatusIcon, int Id)
{
    local int i, j, RowCount, ColCount;
    local StatusIconInfo Info;

    RowCount = StatusIcon.GetRowCount();
    i = 0;
    J0x1C:

    // End:0xA8 [Loop If]
    if(i < RowCount)
    {
        ColCount = StatusIcon.GetColCount(i);
        j = 0;
        J0x4C:

        // End:0x9E [Loop If]
        if(j < ColCount)
        {
            StatusIcon.GetItem(i, j, Info);
            // End:0x94
            if(Info.Id.ClassID == Id)
            {
                return true;
            }
            j++;
            // [Loop Continue]
            goto J0x4C;
        }
        i++;
        // [Loop Continue]
        goto J0x1C;
    }
    return false;
    return;
}

function bool FindEffectArr(StatusIconHandle StatusIcon, array<int> IDs)
{
    local int i, j, k, RowCount, ColCount, IDsLength;

    local StatusIconInfo Info;

    // End:0x0E
    if(IDs.Length == 0)
    {
        return false;
    }
    IDsLength = IDs.Length;
    RowCount = StatusIcon.GetRowCount();
    i = 0;
    J0x36:

    // End:0xE8 [Loop If]
    if(i < RowCount)
    {
        ColCount = StatusIcon.GetColCount(i);
        j = 0;
        J0x66:

        // End:0xDE [Loop If]
        if(j < ColCount)
        {
            StatusIcon.GetItem(i, j, Info);
            k = 0;
            J0x9A:

            // End:0xD4 [Loop If]
            if(k < IDsLength)
            {
                // End:0xCA
                if(Info.Id.ClassID == IDs[k])
                {
                    return true;
                }
                k++;
                // [Loop Continue]
                goto J0x9A;
            }
            j++;
            // [Loop Continue]
            goto J0x66;
        }
        i++;
        // [Loop Continue]
        goto J0x36;
    }
    return false;
    return;
}

function selected()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x69 [Loop If]
    if(i < 9)
    {
        // End:0x4A
        if(Class'NWindow.UIDATA_TARGET'.static.GetTargetID() == m_arrID[i])
        {
            SelectedTexture[i].ShowWindow();
            // [Explicit Continue]
            goto J0x5F;
        }
        SelectedTexture[i].HideWindow();
        J0x5F:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
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
    return;
}

function HandleRestart()
{
    Clear();
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
    m_CurCount = 0;
    m_targetID = -1;
    m_LastChangeColor = -1;
    ResizeWnd();
    return;
}

function ClearStatus(int idx)
{
    m_StatusIconBuff[idx].Clear();
    m_StatusIconDeBuff[idx].Clear();
    m_StatusIconSongDance[idx].Clear();
    m_StatusIconTriggerSkill[idx].Clear();
    m_PlayerName[idx].SetName("", 0, 2);
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
    m_arrPetIDOpen[idx] = -1;
    m_ClassIconSummon[idx].HideWindow();
    m_ClassIconSummonNum[idx].HideWindow();
    return;
}

function CopyStatus(int DesIndex, int SrcIndex)
{
    local int i;
    local string strTmp;
    local int MaxValue, CurValue, Width, Height, row, Col,
	    maxrow, MaxCol;

    local StatusIconInfo Info;
    local CustomTooltip TooltipInfo, TooltipInfo2;
    local string vpIconTextureName, vpToolTipString;

    m_arrID[DesIndex] = m_arrID[SrcIndex];
    m_PlayerName[DesIndex].SetName(m_PlayerName[SrcIndex].GetName(), 0, 2);
    m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
    m_Partylevel[DesIndex].SetText(m_Partylevel[SrcIndex].GetText());
    // End:0xDB
    if(m_PartyPremiumStatus[SrcIndex].IsShowWindow())
    {
        m_PartyPremiumStatus[SrcIndex].HideWindow();
        m_PartyPremiumStatus[DesIndex].ShowWindow();
    }
    m_ClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo);
    m_ClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo);
    m_LeaderIcon[DesIndex].SetTexture(m_LeaderIcon[SrcIndex].GetTextureName());
    m_LeaderIcon[SrcIndex].GetTooltipCustomType(TooltipInfo2);
    m_LeaderIcon[DesIndex].SetTooltipCustomType(TooltipInfo2);
    m_BarCP[SrcIndex].GetValue(MaxValue, CurValue);
    m_BarCP[DesIndex].SetValue(MaxValue, CurValue);
    m_BarHP[SrcIndex].GetValue(MaxValue, CurValue);
    m_BarHP[DesIndex].SetValue(MaxValue, CurValue);
    m_BarMP[SrcIndex].GetValue(MaxValue, CurValue);
    m_BarMP[DesIndex].SetValue(MaxValue, CurValue);
    vpIconTextureName = m_VPIcon[DesIndex].GetTextureName();
    vpToolTipString = m_VPIcon[DesIndex].GetTooltipText();
    m_VPIcon[DesIndex].SetTexture(m_VPIcon[SrcIndex].GetTextureName());
    m_VPIcon[DesIndex].SetTooltipText(m_VPIcon[SrcIndex].GetTooltipText());
    m_VPIcon[SrcIndex].SetTexture(vpIconTextureName);
    m_VPIcon[SrcIndex].SetTooltipText(vpToolTipString);
    // End:0x307
    if(AmILeader())
    {
        SetTypePositionLeader(DesIndex);
        SetTypePositionLeader(SrcIndex);        
    }
    else
    {
        SetTypePosition(DesIndex, 0);
    }
    m_StatusIconBuff[DesIndex].Clear();
    maxrow = m_StatusIconBuff[SrcIndex].GetRowCount();
    row = 0;
    J0x34A:

    // End:0x3FB [Loop If]
    if(row < maxrow)
    {
        m_StatusIconBuff[DesIndex].AddRow();
        MaxCol = m_StatusIconBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x395:

        // End:0x3F1 [Loop If]
        if(Col < MaxCol)
        {
            m_StatusIconBuff[SrcIndex].GetItem(row, Col, Info);
            m_StatusIconBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x395;
        }
        row++;
        // [Loop Continue]
        goto J0x34A;
    }
    m_StatusIconDeBuff[DesIndex].Clear();
    maxrow = m_StatusIconDeBuff[SrcIndex].GetRowCount();
    row = 0;
    J0x432:

    // End:0x4F0 [Loop If]
    if(row < maxrow)
    {
        m_StatusIconDeBuff[DesIndex].AddRow();
        MaxCol = m_StatusIconDeBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x47D:

        // End:0x4E6 [Loop If]
        if(Col < MaxCol)
        {
            m_StatusIconDeBuff[SrcIndex].GetItem(row, Col, Info);
            Info.bHideRemainTime = true;
            m_StatusIconDeBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x47D;
        }
        row++;
        // [Loop Continue]
        goto J0x432;
    }
    m_StatusIconSongDance[DesIndex].Clear();
    maxrow = m_StatusIconSongDance[SrcIndex].GetRowCount();
    row = 0;
    J0x527:

    // End:0x5D8 [Loop If]
    if(row < maxrow)
    {
        m_StatusIconSongDance[DesIndex].AddRow();
        MaxCol = m_StatusIconSongDance[SrcIndex].GetColCount(row);
        Col = 0;
        J0x572:

        // End:0x5CE [Loop If]
        if(Col < MaxCol)
        {
            m_StatusIconSongDance[SrcIndex].GetItem(row, Col, Info);
            m_StatusIconSongDance[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x572;
        }
        row++;
        // [Loop Continue]
        goto J0x527;
    }
    m_StatusIconTriggerSkill[DesIndex].Clear();
    maxrow = m_StatusIconTriggerSkill[SrcIndex].GetRowCount();
    row = 0;
    J0x60F:

    // End:0x6C0 [Loop If]
    if(row < maxrow)
    {
        m_StatusIconTriggerSkill[DesIndex].AddRow();
        MaxCol = m_StatusIconTriggerSkill[SrcIndex].GetColCount(row);
        Col = 0;
        J0x65A:

        // End:0x6B6 [Loop If]
        if(Col < MaxCol)
        {
            m_StatusIconTriggerSkill[SrcIndex].GetItem(row, Col, Info);
            m_StatusIconTriggerSkill[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x65A;
        }
        row++;
        // [Loop Continue]
        goto J0x60F;
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
    J0x7B8:

    // End:0x869 [Loop If]
    if(row < maxrow)
    {
        m_PetStatusIconBuff[DesIndex].AddRow();
        MaxCol = m_PetStatusIconBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x803:

        // End:0x85F [Loop If]
        if(Col < MaxCol)
        {
            m_PetStatusIconBuff[SrcIndex].GetItem(row, Col, Info);
            m_PetStatusIconBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x803;
        }
        row++;
        // [Loop Continue]
        goto J0x7B8;
    }
    m_PetStatusIconDeBuff[DesIndex].Clear();
    maxrow = m_PetStatusIconDeBuff[SrcIndex].GetRowCount();
    row = 0;
    J0x8A0:

    // End:0x95E [Loop If]
    if(row < maxrow)
    {
        m_PetStatusIconDeBuff[DesIndex].AddRow();
        MaxCol = m_PetStatusIconDeBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x8EB:

        // End:0x954 [Loop If]
        if(Col < MaxCol)
        {
            m_PetStatusIconDeBuff[SrcIndex].GetItem(row, Col, Info);
            Info.bHideRemainTime = true;
            m_PetStatusIconDeBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x8EB;
        }
        row++;
        // [Loop Continue]
        goto J0x8A0;
    }
    m_PetStatusIconSongDance[DesIndex].Clear();
    maxrow = m_PetStatusIconSongDance[SrcIndex].GetRowCount();
    row = 0;
    J0x995:

    // End:0xA46 [Loop If]
    if(row < maxrow)
    {
        m_PetStatusIconSongDance[DesIndex].AddRow();
        MaxCol = m_PetStatusIconSongDance[SrcIndex].GetColCount(row);
        Col = 0;
        J0x9E0:

        // End:0xA3C [Loop If]
        if(Col < MaxCol)
        {
            m_PetStatusIconSongDance[SrcIndex].GetItem(row, Col, Info);
            m_PetStatusIconSongDance[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x9E0;
        }
        row++;
        // [Loop Continue]
        goto J0x995;
    }
    m_PetStatusIconTriggerSkill[DesIndex].Clear();
    maxrow = m_PetStatusIconTriggerSkill[SrcIndex].GetRowCount();
    row = 0;
    J0xA7D:

    // End:0xB2E [Loop If]
    if(row < maxrow)
    {
        m_PetStatusIconTriggerSkill[DesIndex].AddRow();
        MaxCol = m_PetStatusIconTriggerSkill[SrcIndex].GetColCount(row);
        Col = 0;
        J0xAC8:

        // End:0xB24 [Loop If]
        if(Col < MaxCol)
        {
            m_PetStatusIconTriggerSkill[SrcIndex].GetItem(row, Col, Info);
            m_PetStatusIconTriggerSkill[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0xAC8;
        }
        row++;
        // [Loop Continue]
        goto J0xA7D;
    }
    // End:0xBDE
    if(!isCompact())
    {
        m_BarHP[SrcIndex].GetValue(MaxValue, CurValue);
        // End:0xB7B
        if(CurValue <= 1)
        {
            m_IsDead[DesIndex].ShowWindow();            
        }
        else
        {
            m_IsDead[DesIndex].HideWindow();
        }
        m_IsDead[SrcIndex].HideWindow();
        PartyOption.SaveSettings();
        HandleNoblesseActive("idx=" $ string(DesIndex));
        HandleNoblesseActive("idx=" $ string(SrcIndex));
    }
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

    GetINIInt("PartyWnd", "e", tmpInt, "Windowsinfo.ini");
    bOption = bool(tmpInt);
    // End:0x456
    if(m_CurCount > 0)
    {
        idx = 0;
        J0x49:

        // End:0x380 [Loop If]
        if(idx < 10)
        {
            // End:0x321
            if(idx <= (m_CurCount - 1))
            {
                // End:0x139
                if(idx > 0)
                {
                    // End:0xE4
                    if(m_arrPetIDOpen[idx - 1] == 1)
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);                        
                    }
                    else
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);
                    }
                }
                // End:0x1B7
                if(m_arrID[idx] != 0)
                {
                    // End:0x177
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
                // End:0x2F8
                if(((m_arrPetIDOpen[idx] == 1) && PartyMemberInfo.curSummonNum > 0) || PartyMemberInfo.curHavePet)
                {
                    m_PetPartyStatus[idx].ShowWindow();
                    // End:0x290
                    if(PartyMemberInfo.curSummonNum > 0)
                    {
                        m_ClassIconSummon[idx].ShowWindow();
                        setHideClassIconSummonNum(idx);
                        m_ClassIconSummonNum[idx].SetTexture("L2UI_ch3.PARTYWND.party_summmon_num" $ string(PartyMemberInfo.curSummonNum));                        
                    }
                    else
                    {
                        m_ClassIconSummon[idx].HideWindow();
                        m_ClassIconSummonNum[idx].HideWindow();
                    }
                    // End:0x2E0
                    if(PartyMemberInfo.curHavePet)
                    {
                        m_PetClassIcon[idx].ShowWindow();                        
                    }
                    else
                    {
                        m_PetClassIcon[idx].HideWindow();
                    }                    
                }
                else
                {
                    m_PetPartyStatus[idx].HideWindow();
                    m_arrPetIDOpen[idx] = -1;
                }
                // [Explicit Continue]
                goto J0x376;
            }
            m_petButton[idx].HideWindow();
            m_PartyStatus[idx].SetVirtualDrag(false);
            m_PartyStatus[idx].HideWindow();
            m_PetPartyStatus[idx].HideWindow();
            J0x376:

            idx++;
            // [Loop Continue]
            goto J0x49;
        }
        OpenPetCount = 0;
        i = 0;
        J0x38E:

        // End:0x3EC [Loop If]
        if(i < 10)
        {
            // End:0x3B5
            if(m_arrPetIDOpen[i] == 1)
            {
                OpenPetCount++;
                // [Explicit Continue]
                goto J0x3E2;
            }
            // End:0x3E2
            if(m_PetPartyStatus[i].IsShowWindow())
            {
                m_PetPartyStatus[i].HideWindow();
            }
            J0x3E2:

            i++;
            // [Loop Continue]
            goto J0x38E;
        }
        rectWnd = m_wndTop.GetRect();
        m_wndTop.SetWindowSize(rectWnd.nWidth, (46 * m_CurCount) + (OpenPetCount * 18));
        m_wndTop.SetResizeFrameSize(10, (46 * m_CurCount) + (OpenPetCount * 18));        
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

    GetINIInt("PartyWnd", "e", tmpInt, "Windowsinfo.ini");
    bOption = bool(tmpInt);
    // End:0x491
    if(m_CurCount > 0)
    {
        idx = 0;
        J0x49:

        // End:0x38F [Loop If]
        if(idx < 10)
        {
            // End:0x330
            if(idx <= (m_CurCount - 1))
            {
                // End:0x139
                if(idx > 0)
                {
                    // End:0xE4
                    if(m_arrPetIDOpen[idx - 1] == 1)
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWnd.PartyStatusSummonWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);                        
                    }
                    else
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);
                    }
                }
                // End:0x1B7
                if(m_arrID[idx] != 0)
                {
                    // End:0x177
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
                // End:0x307
                if((PartyMemberInfo.curSummonNum > 0) || PartyMemberInfo.curHavePet)
                {
                    // End:0x20F
                    if(m_arrPetIDOpen[idx] == -1)
                    {
                        m_arrPetIDOpen[idx] = 1;
                    }
                    m_PetPartyStatus[idx].ShowWindow();
                    // End:0x29F
                    if(PartyMemberInfo.curSummonNum > 0)
                    {
                        m_ClassIconSummon[idx].ShowWindow();
                        setHideClassIconSummonNum(idx);
                        m_ClassIconSummonNum[idx].SetTexture("L2UI_ch3.PARTYWND.party_summmon_num" $ string(PartyMemberInfo.curSummonNum));                        
                    }
                    else
                    {
                        m_ClassIconSummon[idx].HideWindow();
                        m_ClassIconSummonNum[idx].HideWindow();
                    }
                    // End:0x2EF
                    if(PartyMemberInfo.curHavePet)
                    {
                        m_PetClassIcon[idx].ShowWindow();                        
                    }
                    else
                    {
                        m_PetClassIcon[idx].HideWindow();
                    }                    
                }
                else
                {
                    m_PetPartyStatus[idx].HideWindow();
                    m_arrPetIDOpen[idx] = -1;
                }
                // [Explicit Continue]
                goto J0x385;
            }
            m_petButton[idx].HideWindow();
            m_PartyStatus[idx].SetVirtualDrag(false);
            m_PartyStatus[idx].HideWindow();
            m_PetPartyStatus[idx].HideWindow();
            J0x385:

            idx++;
            // [Loop Continue]
            goto J0x49;
        }
        OpenPetCount = 0;
        i = 0;
        J0x39D:

        // End:0x3FB [Loop If]
        if(i < 10)
        {
            // End:0x3C4
            if(m_arrPetIDOpen[i] == 1)
            {
                OpenPetCount++;
                // [Explicit Continue]
                goto J0x3F1;
            }
            // End:0x3F1
            if(m_PetPartyStatus[i].IsShowWindow())
            {
                m_PetPartyStatus[i].HideWindow();
            }
            J0x3F1:

            i++;
            // [Loop Continue]
            goto J0x39D;
        }
        rectWnd = m_wndTop.GetRect();
        m_wndTop.SetWindowSize(rectWnd.nWidth, (46 * m_CurCount) + (OpenPetCount * 18));
        m_wndTop.SetResizeFrameSize(10, (46 * m_CurCount) + (OpenPetCount * 18));
        // End:0x47F
        if(!bOption)
        {
            m_wndTop.ShowWindow();            
        }
        else
        {
            m_wndTop.HideWindow();
        }        
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

function int FindPetOrSumID(int Id)
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
    idx = 0;
    J0x3F:

    // End:0x70 [Loop If]
    if(idx < 10)
    {
        // End:0x66
        if(m_arrSummonID[idx] == Id)
        {
            return idx;
        }
        idx++;
        // [Loop Continue]
        goto J0x3F;
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
    local SummonInfo m_SummonInfo;
    local int Index, i, summonClassID, summonType, summonMAXHP, summonMAXMP,
	    summonHP, summonMP;

    ParseInt(param, "ID", Id);
    ParseInt(param, "SummonID", SummonID);
    ParseInt(param, "UseVName", UseVName);
    ParseInt(param, "DominionIDForVName", DominionIDForVName);
    ParseString(param, "SummonVName", SummonVName);
    GetPartyMemberInfo(Id, PartyMemberInfo);
    GetPartyMemberPetInfo(Id, PartyMemberPetInfo);
    // End:0x2FE
    if(Id > 0)
    {
        m_Vname[m_CurCount].Id = Id;
        m_Vname[m_CurCount].UseVName = UseVName;
        m_Vname[m_CurCount].DominionIDForVName = DominionIDForVName;
        m_Vname[m_CurCount].VName = VName;
        m_Vname[m_CurCount].SummonVName = SummonVName;
        ExecuteEvent(980);
        m_CurCount++;
        m_arrID[m_CurCount - 1] = Id;
        UpdateStatus(m_CurCount - 1, param);
        Index = FindPartyID(Id);
        // End:0x2F8
        if((PartyMemberInfo.curSummonNum > 0) || PartyMemberInfo.curHavePet == true)
        {
            PartySummonProcess(Id);
            i = 0;
            J0x1A1:

            // End:0x2F8 [Loop If]
            if(i < 1)
            {
                ParseInt(param, "SummonType" $ string(i), summonType);
                ParseInt(param, "SummonClassID" $ string(i), summonClassID);
                ParseInt(param, "SummonMaxHP" $ string(i), summonMAXHP);
                ParseInt(param, "SummonMaxMP" $ string(i), summonMAXMP);
                ParseInt(param, "SummonHP" $ string(i), summonHP);
                ParseInt(param, "SummonMP" $ string(i), summonMP);
                UpdateHPBar(Index + 100, summonHP, summonMAXHP);
                UpdateMPBar(Index + 100, summonMP, summonMAXMP);
                // End:0x2EE
                if(summonType == 1)
                {
                    m_ClassIconSummon[m_CurCount - 1].SetTooltipText(GetSystemString(505));
                    // [Explicit Break]
                    goto J0x2F8;
                }
                i++;
                // [Loop Continue]
                goto J0x1A1;
            }
        }
        J0x2F8:

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
    // End:0xA2
    if(Id > 0)
    {
        idx = FindPartyID(Id);
        // End:0xA2
        if(idx > -1)
        {
            i = idx;
            J0x4A:

            // End:0x79 [Loop If]
            if(i < (m_CurCount - 1))
            {
                CopyStatus(i, i + 1);
                i++;
                // [Loop Continue]
                goto J0x4A;
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

function UpdateStatus(int idx, string param)
{
    local string Name;
    local int MasterID, RoutingType, Id, cp, maxCP, hp,
	    MaxHP, mp, maxMP, ClassID, Level,
	    vitality;

    local UserInfo TargetUser;
    local int Width, Height;
    local array<string> DataArray;
    local int UseVName;
    local string VName;
    local int SummonCount, iSubstatus, Value, premiumStatus, isSubLeader;

    // End:0x1B
    if((idx < 0) || idx >= 10)
    {
        return;
    }
    ParseString(param, "Name", Name);
    Split(Name, ";", DataArray);
    Name = DataArray[0];
    premiumStatus = int(DataArray[1]);
    isSubLeader = int(DataArray[2]);
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
    ParseInt(param, "MasterID", PartyLeaderID);
    m_Partylevel[idx].SetText(string(Level));
    // End:0x1DE
    if(premiumStatus == 1)
    {
        m_PartyPremiumStatus[idx].ShowWindow();        
    }
    else
    {
        m_PartyPremiumStatus[idx].HideWindow();
    }
    // End:0x236
    if(!isCompact())
    {
        // End:0x221
        if(hp <= 1)
        {
            m_IsDead[idx].ShowWindow();            
        }
        else
        {
            m_IsDead[idx].HideWindow();
        }
    }
    UseVName = m_Vname[idx].UseVName;
    VName = m_Vname[idx].VName;
    // End:0x28E
    if(UseVName == 1)
    {
        m_PlayerName[idx].SetName(VName, 0, 2);        
    }
    else
    {
        m_PlayerName[idx].SetName(Name, 0, 2);
    }
    // End:0x2E3
    if(ParseInt(param, "MasterID", MasterID))
    {
        // End:0x2E3
        if(MasterID > -1)
        {
            currentMasterId = MasterID;
        }
    }
    // End:0x5B0
    if(ParseInt(param, "MasterID", MasterID))
    {
        // End:0x41D
        if((MasterID > 0) && MasterID == Id)
        {
            partymasteridx = idx;
            ParseInt(param, "RoutingType", RoutingType);
            m_LeaderIcon[idx].SetTexture("UI_BOHPTS.Party.party_leadericon");
            m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText((GetSystemString(8036) $ "\\n") $ GetRoutingString(RoutingType)));
            m_PlayerName[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx), "TopCenter", "TopCenter", 5, 9);
            GetTextSizeDefault(Name, Width, Height);            
        }
        else
        {
            // End:0x52C
            if(isSubLeader == 1)
            {
                partysubmasteridx = idx;
                ParseInt(param, "RoutingType", RoutingType);
                m_LeaderIcon[idx].SetTexture("UI_BOHPTS.Party.party_subleadericon");
                m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText((GetSystemString(8037) $ "\\n") $ GetRoutingString(RoutingType)));
                m_PlayerName[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx), "TopCenter", "TopCenter", 5, 9);
                GetTextSizeDefault(Name, Width, Height);                
            }
            else
            {
                m_LeaderIcon[idx].SetTexture("");
                m_LeaderIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(""));
                m_PlayerName[idx].SetAnchor("PartyWnd.PartyStatusWnd" $ string(idx), "TopCenter", "TopCenter", 0, 9);
            }
        }
    }
    m_ClassIcon[idx].SetTexture(GetClassRoleIconName(ClassID));
    m_ClassIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText((GetClassRoleName(ClassID) $ " - ") $ GetClassType(ClassID)));
    UpdateCPBar(idx, cp, maxCP);
    UpdateHPBar(idx, hp, MaxHP);
    UpdateMPBar(idx, mp, maxMP);
    UpdateVpIcon(idx, vitality, GetMaxVitality());
    SetPartyAutoStatus(idx, iSubstatus);
    return;
}

function SetMasterTooltip(int Lootingtype)
{
    // End:0x59
    if((partymasteridx < 10) && partymasteridx > -1)
    {
        m_LeaderIcon[partymasteridx].SetTooltipCustomType(MakeTooltipSimpleText((GetSystemString(8036) $ "\\n") $ GetRoutingString(Lootingtype)));        
    }
    else
    {
        // End:0xAF
        if((partysubmasteridx < 10) && partysubmasteridx > -1)
        {
            m_LeaderIcon[partysubmasteridx].SetTooltipCustomType(MakeTooltipSimpleText((GetSystemString(8037) $ "\\n") $ GetRoutingString(Lootingtype)));
        }
    }
    return;
}

function UpdateVpIcon(int idx, int vp, int MaxVP)
{
    local int vpStep, division;
    local string vpString;

    division = MaxVP / 4;
    // End:0x30
    if(vp > (MaxVP - division))
    {
        vpStep = 4;        
    }
    else
    {
        // End:0x6D
        if((vp <= (MaxVP - division)) && vp > (MaxVP - (division * 2)))
        {
            vpStep = 3;            
        }
        else
        {
            // End:0xAE
            if((vp <= (MaxVP - (division * 2))) && vp > (MaxVP - (division * 3)))
            {
                vpStep = 2;                
            }
            else
            {
                // End:0xEE
                if((vp <= (MaxVP - (division * 3))) && vp > (MaxVP - (division * 4)))
                {
                    vpStep = 1;                    
                }
                else
                {
                    vpStep = 0;
                }
            }
        }
    }
    m_VPIcon[idx].SetTexture("L2UI_Ct1.PartyStatusWnd_DF_VPIcon_" $ string(vpStep));
    // End:0x156
    if(vp <= 0)
    {
        vpString = GetSystemString(2496);        
    }
    else
    {
        vpString = GetSystemString(2495);
    }
    m_VPIcon[idx].SetTooltipCustomType(MakeTooltipSimpleText(vpString));
    return;
}

function HandlePartyPetAdd(string param)
{
    local int MasterID, Id, i, Type, MasterIndex;

    ParseInt(param, "Type", Type);
    // End:0x116
    if(Type == 2)
    {
        ParseInt(param, "MasterID", MasterID);
        ParseInt(param, "ID", Id);
        // End:0x116
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
            // End:0xF2
            if(!PartyOption.m_CheckHideAllPet.IsChecked())
            {
                m_arrPetIDOpen[MasterIndex] = 1;                
            }
            else
            {
                m_arrPetIDOpen[MasterIndex] = 2;
            }
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
    PartySummonProcess(MasterID);
    idx = FindSummonMasterID(MasterID);
    // End:0x9B
    if(idx > 0)
    {
        m_ClassIconSummon[idx].SetTooltipText(GetSystemString(505));
    }
    // End:0x108
    if(Type == 1)
    {
        m_arrPetID[idx] = Id;
        // End:0xE4
        if(!PartyOption.m_CheckHideAllPet.IsChecked())
        {
            m_arrPetIDOpen[idx] = 1;            
        }
        else
        {
            m_arrPetIDOpen[idx] = 2;
        }
        UpdateSummonStatus(idx, param);
        ResizeWnd();
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
    local int MasterID, Type, idx;

    ParseInt(param, "MasterID", MasterID);
    ParseInt(param, "Type", Type);
    // End:0x67
    if(Type == 1)
    {
        PartySummonProcess(MasterID);
        idx = FindSummonMasterID(MasterID);
        UpdatePetStatus(idx, param);
    }
    return;
}

function HandlePartySummonDelete(string param)
{
    local int SummonMasterID, idx;
    local PartyMemberInfo PartyMemberInfo;

    ParseInt(param, "SummonMasterID", SummonMasterID);
    // End:0xD8
    if(SummonMasterID > 0)
    {
        idx = FindSummonMasterID(SummonMasterID);
        GetPartyMemberInfo(SummonMasterID, PartyMemberInfo);
        // End:0xC7
        if(PartyMemberInfo.curSummonNum > 0)
        {
            m_ClassIconSummon[idx].ShowWindow();
            setHideClassIconSummonNum(idx);
            m_ClassIconSummonNum[idx].SetTexture("L2UI_ch3.PARTYWND.party_summmon_num" $ string(PartyMemberInfo.curSummonNum));            
        }
        else
        {
            ClearSummonStatus(idx);
        }
        ResizeWnd();
    }
    return;
}

function HandlePartySpelledList(string param)
{
    local int i, idx, Id, Max, BuffCnt, BuffCurRow,
	    DeBuffCnt, DeBuffCurRow, TriggerSkillCnt, TriggerSkillCurRow;

    local bool isPC;
    local StatusIconInfo Info;
    local PartyMemberPetInfo PartyMemberPetInfo;

    DeBuffCurRow = -1;
    BuffCurRow = -1;
    TriggerSkillCurRow = -1;
    isPC = false;
    LastPacketData = param;
    ParseInt(param, "ID", Id);
    // End:0x55
    if(Id < 1)
    {
        return;
    }
    idx = FindPartyID(Id);
    // End:0xD0
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
        // End:0x152
        if(idx >= 0)
        {
            idx = 0;
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
    // End:0x16D
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
    J0x1A3:

    // End:0x60B [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        // End:0x24E
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            // [Explicit Continue]
            goto J0x601;
        }
        ParseInt(param, "Sec_" $ string(i), Info.RemainTime);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x601
        if(IsValidItemID(Info.Id))
        {
            Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
            // End:0x3E9
            if((GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0) || EffectSwapWnd_script.getIsUsedObject(Info.Id.ClassID, 2))
            {
                Info.bHideRemainTime = true;
                // End:0x395
                if((float(DeBuffCnt) % float(12)) == float(0))
                {
                    DeBuffCurRow++;
                    // End:0x380
                    if(isPC)
                    {
                        m_StatusIconDeBuff[idx].AddRow();                        
                    }
                    else
                    {
                        m_PetStatusIconDeBuff[idx].AddRow();
                    }
                }
                // End:0x3C0
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
                goto J0x601;
            }
            // End:0x48E
            if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                // End:0x434
                if(isPC)
                {
                    m_StatusIconSongDance[idx].AddRow();                    
                }
                else
                {
                    m_PetStatusIconSongDance[idx].AddRow();
                }
                // End:0x470
                if(isPC)
                {
                    m_StatusIconSongDance[idx].AddCol(0, Info);                    
                }
                else
                {
                    m_PetStatusIconSongDance[idx].AddCol(0, Info);
                }
                // [Explicit Continue]
                goto J0x601;
            }
            // End:0x55E
            if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
            {
                // End:0x50A
                if((float(TriggerSkillCnt) % float(12)) == float(0))
                {
                    TriggerSkillCurRow++;
                    // End:0x4F5
                    if(isPC)
                    {
                        m_StatusIconTriggerSkill[idx].AddRow();                        
                    }
                    else
                    {
                        m_PetStatusIconTriggerSkill[idx].AddRow();
                    }
                }
                // End:0x535
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
                goto J0x601;
            }
            // End:0x5B0
            if((float(BuffCnt) % float(12)) == float(0))
            {
                BuffCurRow++;
                // End:0x59B
                if(isPC)
                {
                    m_StatusIconBuff[idx].AddRow();                    
                }
                else
                {
                    m_PetStatusIconBuff[idx].AddRow();
                }
            }
            // End:0x5DB
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
        J0x601:

        i++;
        // [Loop Continue]
        goto J0x1A3;
    }
    UpdateBuff();
    ExecuteEvent(90001, "idx=" $ string(idx));
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

    // End:0x456 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        // End:0x168
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            // [Explicit Continue]
            goto J0x44C;
        }
        ParseInt(param, "Sec_" $ string(i), Info.RemainTime);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x44C
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
                // End:0x2BD
                if(EffectSwapWnd_script.getIsUsedObject(Info.Id.ClassID, 2))
                {
                    // End:0x2A9
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
                    // End:0x318
                    if(IsSongDance(Info.Id, Info.Level, Info.SubLevel) == true)
                    {
                        // End:0x304
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
                        // End:0x373
                        if(IsTriggerSkill(Info.Id, Info.Level, Info.SubLevel) == true)
                        {
                            // End:0x35F
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
                            // End:0x390
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
            }
            deleteBuff(tmpStatusIcon, Info.Level, Info.Id.ClassID, Info.SpellerID);
            // End:0x426
            if((tmpStatusIcon.GetRowCount() == 0) || (float(tmpStatusIcon.GetColCount(tmpStatusIcon.GetRowCount() - 1)) % float(12)) == float(0))
            {
                tmpStatusIcon.AddRow();
            }
            tmpStatusIcon.AddCol(tmpStatusIcon.GetRowCount() - 1, Info);
        }
        J0x44C:

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
    SetINIInt("PartyWnd", "a", m_CurBf, "WindowsInfo.ini");
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
            // End:0x6D
            break;
        // End:0x56
        case "btnCompact":
            OnOpenPartyWndOption();
            // End:0x6D
            break;
        // End:0x67
        case "btnSummon":
            // End:0x6D
            break;
        // End:0xFFFF
        default:
            // End:0x6D
            break;
            break;
    }
    // End:0xFF
    if(InStr(strID, "btnSummon") > -1)
    {
        idx = int(Right(strID, 1));
        // End:0xD7
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

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
    return;
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
    m_PartyOption.SetAnchor("PartyWnd.PartyStatusWnd0", "TopRight", "TopLeft", 5, 5);
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
    SetINIInt("PartyWnd", "a", m_CurBf, "WindowsInfo.ini");
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

    // End:0x14
    if(Class'NWindow.InputAPI'.static.IsAltPressed())
    {
        return;
    }
    rectWnd = m_wndTop.GetRect();
    // End:0x1DA
    if((X > (rectWnd.nX + 13)) && X < ((rectWnd.nX + rectWnd.nWidth) - 10))
    {
        // End:0x1DA
        if(GetPlayerInfo(UserInfo))
        {
            idx = GetIdx(Y - rectWnd.nY);
            rectWnd = m_PetPartyStatus[idx].GetRect();
            rectPetClassIcon = m_PetClassIcon[idx].GetRect();
            // End:0x157
            if(IsPKMode())
            {
                // End:0xFB
                if(idx < 100)
                {
                    RequestAttack(m_arrID[idx], UserInfo.loc);                    
                }
                else
                {
                    // End:0x154
                    if((X > rectPetClassIcon.nX) && X < ((rectWnd.nX + rectWnd.nWidth) - 10))
                    {
                        RequestAttack(m_arrPetID[idx - 100], UserInfo.loc);
                    }
                }                
            }
            else
            {
                // End:0x181
                if(idx < 100)
                {
                    RequestAction(m_arrID[idx], UserInfo.loc);                    
                }
                else
                {
                    // End:0x1DA
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
        tempY = tempY - 46;
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
            // End:0x6A
            break;
        // End:0x2B
        case 1:
            idx = 1497;
            // End:0x6A
            break;
        // End:0x3E
        case 2:
            idx = 1741;
            // End:0x6A
            break;
        // End:0x51
        case 3:
            idx = 2307;
            // End:0x6A
            break;
        // End:0x64
        case 4:
            idx = 1498;
            // End:0x6A
            break;
        // End:0xFFFF
        default:
            // End:0x6A
            break;
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

function SetPartyAutoStatus(int idx, int iSubstatus)
{
    // End:0x22
    if(AmILeader())
    {
        // End:0x14
        if(iSubstatus == 0)
        {
        }
        SetTypePositionLeader(idx);        
    }
    else
    {
        // End:0x3C
        if(iSubstatus == 0)
        {
            SetTypePosition(idx, 0);            
        }
        else
        {
            SetTypePosition(idx, 1);
        }
    }
    return;
}

function SetTypePositionLeader(int idx)
{
    return;
}

function SetTypePosition(int idx, int iauto)
{
    return;
}

function ResetAutoParty()
{
    return;
}

function bool isCompact()
{
    // End:0x27
    if(m_hOwnerWnd.GetWindowName() == "PartyWndCompact")
    {
        return true;
    }
    return false;
    return;
}
