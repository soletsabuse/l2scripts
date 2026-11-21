class PartyWndCompact extends UICommonAPI;

const NSTATUSICON_MAXCOL = 12;
const NPARTYSTATUS_HEIGHT = 26;
const NPARTYPETSTATUS_HEIGHT = 18;
const FIRSTWND_ADD_HEIGHT = 4;
const MAX_ArrayNum = 10;

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
var bool m_partyleader;
var int m_arrID[10];
var int m_arrPetID[10];
var int m_arrSummonID[10];
var int m_arrPetIDOpen[10];
var int m_CurCount;
var int m_CurBf;
var int m_MasterID;
var VnameData m_Vname[10];
var WindowHandle m_wndTop;
var WindowHandle m_PartyOption;
var WindowHandle m_PartyStatus[10];
var TextureHandle m_ClassIcon[10];
var StatusIconHandle m_StatusIconBuff[10];
var StatusIconHandle m_StatusIconDeBuff[10];
var BarHandle m_BarCP[10];
var BarHandle m_BarHP[10];
var BarHandle m_BarMP[10];
var ButtonHandle btnBuff;
var ButtonHandle m_petButton[10];
var ButtonHandle m_petButtonTrash[10];
var WindowHandle m_PetPartyStatus[10];
var StatusIconHandle m_PetStatusIconBuff[10];
var StatusIconHandle m_PetStatusIconDeBuff[10];
var TextureHandle m_PetClassIcon[10];
var BarHandle m_PetBarHP[10];
var BarHandle m_PetBarMP[10];
var TextureHandle m_ClassIconSummon[10];
var TextureHandle m_ClassIconSummonNum[10];

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
    RegisterEvent(1182);
    RegisterEvent(1183);
    RegisterEvent(1052);
    RegisterEvent(1053);
    RegisterEvent(8000);
    return;
}

function OnLoad()
{
    local int idx;

    InitHandleCOD();
    m_bCompact = false;
    m_bBuff = false;
    m_CurBf = 0;
    m_MasterID = 0;
    idx = 0;
    J0x2B:

    // End:0x19D [Loop If]
    if(idx < 10)
    {
        m_StatusIconBuff[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 1, 3);
        m_StatusIconDeBuff[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ string(idx), "TopRight", "TopLeft", 1, 3);
        m_PetStatusIconBuff[idx].SetAnchor("PartyWndCompact.PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 1, 3);
        m_PetStatusIconDeBuff[idx].SetAnchor("PartyWndCompact.PartyStatusSummonWnd" $ string(idx), "TopRight", "TopLeft", 1, 3);
        idx++;
        // [Loop Continue]
        goto J0x2B;
    }
    m_ClassIcon[0].Move(0, 7);
    m_PartyOption.HideWindow();
    idx = 0;
    J0x1C7:

    // End:0x21B [Loop If]
    if(idx < 10)
    {
        m_PartyStatus[idx].SetDragOverTexture("L2UI_CT1.ListCtrl.ListCtrl_DF_HighLight");
        idx++;
        // [Loop Continue]
        goto J0x1C7;
    }
    ResetVName();
    return;
}

function OnHide()
{
    ResetVName();
    return;
}

function checkClassicForm()
{
    local int idx;

    idx = 0;
    J0x07:

    // End:0x5D [Loop If]
    if(idx < 10)
    {
        // End:0x3E
        if(getInstanceUIData().getIsClassicServer())
        {
            m_ClassIconSummonNum[idx].HideWindow();
            // [Explicit Continue]
            goto J0x53;
        }
        m_ClassIconSummonNum[idx].ShowWindow();
        J0x53:

        idx++;
        // [Loop Continue]
        goto J0x07;
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

function InitHandleCOD()
{
    local int idx;
    local Rect rectWnd;

    m_wndTop = GetWindowHandle("PartyWndCompact");
    m_PartyOption = GetWindowHandle("PartyWndOption");
    idx = 0;
    J0x40:

    // End:0x68E [Loop If]
    if(idx < 10)
    {
        m_PartyStatus[idx] = GetWindowHandle("PartyWndCompact.PartyStatusWnd" $ string(idx));
        m_ClassIcon[idx] = GetTextureHandle(("PartyWndCompact.PartyStatusWnd" $ string(idx)) $ ".ClassIcon");
        m_StatusIconBuff[idx] = GetStatusIconHandle(("PartyWndCompact.PartyStatusWnd" $ string(idx)) $ ".StatusIconBuff");
        m_StatusIconDeBuff[idx] = GetStatusIconHandle(("PartyWndCompact.PartyStatusWnd" $ string(idx)) $ ".StatusIconDebuff");
        m_BarCP[idx] = GetBarHandle(("PartyWndCompact.PartyStatusWnd" $ string(idx)) $ ".barCP");
        m_BarHP[idx] = GetBarHandle(("PartyWndCompact.PartyStatusWnd" $ string(idx)) $ ".barHP");
        m_BarMP[idx] = GetBarHandle(("PartyWndCompact.PartyStatusWnd" $ string(idx)) $ ".barMP");
        m_petButton[idx] = GetButtonHandle("PartyWndCompact.btnSummon" $ string(idx));
        m_petButton[idx].HideWindow();
        m_PetPartyStatus[idx] = GetWindowHandle("PartyWndCompact.PartyStatusSummonWnd" $ string(idx));
        m_PetClassIcon[idx] = GetTextureHandle(("PartyWndCompact.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIcon");
        m_PetStatusIconBuff[idx] = GetStatusIconHandle(("PartyWndCompact.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconBuff");
        m_PetStatusIconDeBuff[idx] = GetStatusIconHandle(("PartyWndCompact.PartyStatusSummonWnd" $ string(idx)) $ ".StatusIconDebuff");
        m_PetBarHP[idx] = GetBarHandle(("PartyWndCompact.PartyStatusSummonWnd" $ string(idx)) $ ".barHP");
        m_PetBarMP[idx] = GetBarHandle(("PartyWndCompact.PartyStatusSummonWnd" $ string(idx)) $ ".barMP");
        m_arrPetIDOpen[idx] = -1;
        m_arrSummonID[idx] = -1;
        m_arrID[idx] = 0;
        m_PetClassIcon[idx] = GetTextureHandle(("PartyWndCompact.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconPet");
        m_ClassIconSummon[idx] = GetTextureHandle(("PartyWndCompact.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconSummon");
        m_ClassIconSummonNum[idx] = GetTextureHandle(("PartyWndCompact.PartyStatusSummonWnd" $ string(idx)) $ ".ClassIconSummonNum");
        // End:0x630
        if(idx == 0)
        {
            rectWnd = m_PartyStatus[idx].GetRect();
            m_PartyStatus[idx].SetWindowSize(rectWnd.nWidth, rectWnd.nHeight + 4);
            m_petButton[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ string(idx), "TopLeft", "TopRight", 0, 15);
            // [Explicit Continue]
            goto J0x684;
        }
        m_petButton[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ string(idx), "TopLeft", "TopRight", 0, 2);
        J0x684:

        idx++;
        // [Loop Continue]
        goto J0x40;
    }
    btnBuff = GetButtonHandle("PartyWndCompact.btnBuff");
    return;
}

function OnShow()
{
    local int i, tmpInt;

    GetINIInt("PartyWndCompact", "a", m_CurBf, "WindowsInfo.ini");
    SetBuffButtonTooltip();
    UpdateBuff();
    GetINIInt("PartyWnd", "p", tmpInt, "WindowsInfo.ini");
    i = 0;
    J0x6C:

    // End:0xCC [Loop If]
    if(i < 9)
    {
        // End:0xA4
        if(bool(tmpInt))
        {
            // End:0xA1
            if(m_arrPetIDOpen[i] > 0)
            {
                m_arrPetIDOpen[i] = 2;
            }
            // [Explicit Continue]
            goto J0xC2;
        }
        // End:0xC2
        if(m_arrPetIDOpen[i] > 0)
        {
            m_arrPetIDOpen[i] = 1;
        }
        J0xC2:

        i++;
        // [Loop Continue]
        goto J0x6C;
    }
    Debug("onShow partyWndCompact");
    ResizeOnlyWnd();
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
                                                            // End:0x1C8
                                                            if((Event_ID == 1182) || Event_ID == 1052)
                                                            {
                                                                HandlePartySpelledListDelete(param);                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x1F6
                                                                if((Event_ID == 1183) || Event_ID == 1053)
                                                                {
                                                                    HandlePartySpelledListInsert(param);                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x20B
                                                                    if(Event_ID == 8000)
                                                                    {
                                                                        checkClassicForm();
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
    // End:0x114
    if(idx > -1)
    {
        m_Vname[idx].Id = Id;
        m_Vname[idx].UseVName = UseVName;
        m_Vname[idx].DominionIDForVName = DominionIDForVName;
        m_Vname[idx].VName = VName;
        m_Vname[idx].SummonVName = SummonVName;
    }
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
    ResizeWnd();
    return;
}

function ClearStatus(int idx)
{
    m_StatusIconBuff[idx].Clear();
    m_StatusIconDeBuff[idx].Clear();
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
    UpdateHPBar(idx + 100, 0, 0);
    UpdateMPBar(idx + 100, 0, 0);
    m_petButton[idx].HideWindow();
    m_arrPetID[idx] = -1;
    m_arrPetIDOpen[idx] = -1;
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
    local int MaxValue, CurValue, row, Col, maxrow, MaxCol;

    local StatusIconInfo Info;
    local CustomTooltip TooltipInfo, TooltipInfo2;
    local string summonToolTipStr1, summonToolTipStr2, summonTextureName;

    m_arrID[DesIndex] = m_arrID[SrcIndex];
    m_PartyStatus[SrcIndex].GetTooltipCustomType(TooltipInfo);
    m_PartyStatus[DesIndex].SetTooltipCustomType(TooltipInfo);
    m_ClassIcon[DesIndex].SetTexture(m_ClassIcon[SrcIndex].GetTextureName());
    m_ClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo2);
    m_ClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo2);
    m_BarCP[SrcIndex].GetValue(MaxValue, CurValue);
    m_BarCP[DesIndex].SetValue(MaxValue, CurValue);
    m_BarHP[SrcIndex].GetValue(MaxValue, CurValue);
    m_BarHP[DesIndex].SetValue(MaxValue, CurValue);
    m_BarMP[SrcIndex].GetValue(MaxValue, CurValue);
    m_BarMP[DesIndex].SetValue(MaxValue, CurValue);
    m_StatusIconBuff[DesIndex].Clear();
    maxrow = m_StatusIconBuff[SrcIndex].GetRowCount();
    row = 0;
    J0x19A:

    // End:0x24B [Loop If]
    if(row < maxrow)
    {
        m_StatusIconBuff[DesIndex].AddRow();
        MaxCol = m_StatusIconBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x1E5:

        // End:0x241 [Loop If]
        if(Col < MaxCol)
        {
            m_StatusIconBuff[SrcIndex].GetItem(row, Col, Info);
            m_StatusIconBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x1E5;
        }
        row++;
        // [Loop Continue]
        goto J0x19A;
    }
    m_StatusIconDeBuff[DesIndex].Clear();
    maxrow = m_StatusIconDeBuff[SrcIndex].GetRowCount();
    row = 0;
    J0x282:

    // End:0x333 [Loop If]
    if(row < maxrow)
    {
        m_StatusIconDeBuff[DesIndex].AddRow();
        MaxCol = m_StatusIconDeBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x2CD:

        // End:0x329 [Loop If]
        if(Col < MaxCol)
        {
            m_StatusIconDeBuff[SrcIndex].GetItem(row, Col, Info);
            m_StatusIconDeBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x2CD;
        }
        row++;
        // [Loop Continue]
        goto J0x282;
    }
    m_arrPetID[DesIndex] = m_arrPetID[SrcIndex];
    m_arrSummonID[DesIndex] = m_arrSummonID[SrcIndex];
    m_arrPetID[DesIndex] = m_arrPetID[SrcIndex];
    m_arrPetIDOpen[DesIndex] = m_arrPetIDOpen[SrcIndex];
    summonTextureName = m_ClassIconSummon[DesIndex].GetTextureName();
    m_ClassIconSummon[DesIndex].SetTexture(m_ClassIconSummon[SrcIndex].GetTextureName());
    m_ClassIconSummon[SrcIndex].SetTexture(summonTextureName);
    summonToolTipStr1 = m_ClassIconSummon[SrcIndex].GetTooltipText();
    summonToolTipStr2 = m_ClassIconSummon[DesIndex].GetTooltipText();
    m_ClassIconSummon[SrcIndex].SetTooltipText(summonToolTipStr2);
    m_ClassIconSummon[DesIndex].SetTooltipText(summonToolTipStr1);
    m_PetClassIcon[DesIndex].SetTexture(m_PetClassIcon[SrcIndex].GetTextureName());
    m_PetClassIcon[SrcIndex].GetTooltipCustomType(TooltipInfo);
    m_PetClassIcon[DesIndex].SetTooltipCustomType(TooltipInfo);
    m_PetBarHP[SrcIndex].GetValue(MaxValue, CurValue);
    m_PetBarHP[DesIndex].SetValue(MaxValue, CurValue);
    m_PetBarMP[SrcIndex].GetValue(MaxValue, CurValue);
    m_PetBarMP[DesIndex].SetValue(MaxValue, CurValue);
    m_PetStatusIconBuff[DesIndex].Clear();
    maxrow = m_PetStatusIconBuff[SrcIndex].GetRowCount();
    row = 0;
    J0x569:

    // End:0x61A [Loop If]
    if(row < maxrow)
    {
        m_PetStatusIconBuff[DesIndex].AddRow();
        MaxCol = m_PetStatusIconBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x5B4:

        // End:0x610 [Loop If]
        if(Col < MaxCol)
        {
            m_PetStatusIconBuff[SrcIndex].GetItem(row, Col, Info);
            m_PetStatusIconBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x5B4;
        }
        row++;
        // [Loop Continue]
        goto J0x569;
    }
    m_PetStatusIconDeBuff[DesIndex].Clear();
    maxrow = m_PetStatusIconDeBuff[SrcIndex].GetRowCount();
    row = 0;
    J0x651:

    // End:0x702 [Loop If]
    if(row < maxrow)
    {
        m_PetStatusIconDeBuff[DesIndex].AddRow();
        MaxCol = m_PetStatusIconDeBuff[SrcIndex].GetColCount(row);
        Col = 0;
        J0x69C:

        // End:0x6F8 [Loop If]
        if(Col < MaxCol)
        {
            m_PetStatusIconDeBuff[SrcIndex].GetItem(row, Col, Info);
            m_PetStatusIconDeBuff[DesIndex].AddCol(row, Info);
            Col++;
            // [Loop Continue]
            goto J0x69C;
        }
        row++;
        // [Loop Continue]
        goto J0x651;
    }
    return;
}

function ResizeOnlyWnd()
{
    local int idx;
    local Rect rectWnd;
    local bool bOption;
    local int i, OpenPetCount;
    local PartyMemberInfo PartyMemberInfo;
    local int tmpInt;

    GetINIInt("PartyWnd", "e", tmpInt, "Windowsinfo.ini");
    bOption = bool(tmpInt);
    // End:0x51F
    if(m_CurCount > 0)
    {
        idx = 0;
        J0x49:

        // End:0x441 [Loop If]
        if(idx < 10)
        {
            // End:0x3E2
            if(idx <= (m_CurCount - 1))
            {
                // End:0x147
                if(idx > 0)
                {
                    // End:0xEB
                    if(m_arrPetIDOpen[idx - 1] == 1)
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWndCompact.PartyStatusSummonWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);                        
                    }
                    else
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);
                    }
                }
                // End:0x1C5
                if(m_arrID[idx] != 0)
                {
                    // End:0x185
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
                // End:0x1EB
                if(m_arrPetIDOpen[idx] == 1)
                {
                    m_PetPartyStatus[idx].ShowWindow();
                }
                GetPartyMemberInfo(m_arrID[idx], PartyMemberInfo);
                // End:0x270
                if((PartyMemberInfo.curSummonNum > 0) || PartyMemberInfo.curHavePet)
                {
                    // End:0x243
                    if(m_arrPetIDOpen[idx] == -1)
                    {
                        m_arrPetIDOpen[idx] = 1;
                    }
                    m_PetPartyStatus[idx].ShowWindow();
                    m_petButton[idx].ShowWindow();                    
                }
                else
                {
                    m_petButton[idx].HideWindow();
                    m_PetPartyStatus[idx].HideWindow();
                    m_arrPetIDOpen[idx] = -1;
                }
                // End:0x326
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
                // End:0x3A0
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
                // [Explicit Continue]
                goto J0x437;
            }
            m_petButton[idx].HideWindow();
            m_PartyStatus[idx].SetVirtualDrag(false);
            m_PartyStatus[idx].HideWindow();
            m_PetPartyStatus[idx].HideWindow();
            J0x437:

            idx++;
            // [Loop Continue]
            goto J0x49;
        }
        OpenPetCount = 0;
        i = 0;
        J0x44F:

        // End:0x4AD [Loop If]
        if(i < 10)
        {
            // End:0x476
            if(m_arrPetIDOpen[i] == 1)
            {
                OpenPetCount++;
                // [Explicit Continue]
                goto J0x4A3;
            }
            // End:0x4A3
            if(m_PetPartyStatus[i].IsShowWindow())
            {
                m_PetPartyStatus[i].HideWindow();
            }
            J0x4A3:

            i++;
            // [Loop Continue]
            goto J0x44F;
        }
        rectWnd = m_wndTop.GetRect();
        m_wndTop.SetWindowSize(rectWnd.nWidth, ((26 * m_CurCount) + (OpenPetCount * 18)) + 4);
        m_wndTop.SetResizeFrameSize(10, ((26 * m_CurCount) + (OpenPetCount * 18)) + 4);        
    }
    else
    {
        m_wndTop.HideWindow();
        m_PetPartyStatus[idx].HideWindow();
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
    // End:0x549
    if(m_CurCount > 0)
    {
        idx = 0;
        J0x49:

        // End:0x441 [Loop If]
        if(idx < 10)
        {
            // End:0x3E2
            if(idx <= (m_CurCount - 1))
            {
                // End:0x147
                if(idx > 0)
                {
                    // End:0xEB
                    if(m_arrPetIDOpen[idx - 1] == 1)
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWndCompact.PartyStatusSummonWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);                        
                    }
                    else
                    {
                        m_PartyStatus[idx].SetAnchor("PartyWndCompact.PartyStatusWnd" $ string(idx - 1), "BottomLeft", "TopLeft", 0, -4);
                    }
                }
                // End:0x1C5
                if(m_arrID[idx] != 0)
                {
                    // End:0x185
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
                // End:0x1EB
                if(m_arrPetIDOpen[idx] == 1)
                {
                    m_PetPartyStatus[idx].ShowWindow();
                }
                GetPartyMemberInfo(m_arrID[idx], PartyMemberInfo);
                // End:0x270
                if((PartyMemberInfo.curSummonNum > 0) || PartyMemberInfo.curHavePet)
                {
                    // End:0x243
                    if(m_arrPetIDOpen[idx] == -1)
                    {
                        m_arrPetIDOpen[idx] = 1;
                    }
                    m_PetPartyStatus[idx].ShowWindow();
                    m_petButton[idx].ShowWindow();                    
                }
                else
                {
                    m_petButton[idx].HideWindow();
                    m_PetPartyStatus[idx].HideWindow();
                    m_arrPetIDOpen[idx] = -1;
                }
                // End:0x326
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
                // End:0x3A0
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
                // [Explicit Continue]
                goto J0x437;
            }
            m_petButton[idx].HideWindow();
            m_PartyStatus[idx].SetVirtualDrag(false);
            m_PartyStatus[idx].HideWindow();
            m_PetPartyStatus[idx].HideWindow();
            J0x437:

            idx++;
            // [Loop Continue]
            goto J0x49;
        }
        OpenPetCount = 0;
        i = 0;
        J0x44F:

        // End:0x4AD [Loop If]
        if(i < 10)
        {
            // End:0x476
            if(m_arrPetIDOpen[i] == 1)
            {
                OpenPetCount++;
                // [Explicit Continue]
                goto J0x4A3;
            }
            // End:0x4A3
            if(m_PetPartyStatus[i].IsShowWindow())
            {
                m_PetPartyStatus[i].HideWindow();
            }
            J0x4A3:

            i++;
            // [Loop Continue]
            goto J0x44F;
        }
        rectWnd = m_wndTop.GetRect();
        m_wndTop.SetWindowSize(rectWnd.nWidth, ((26 * m_CurCount) + (OpenPetCount * 18)) + 4);
        m_wndTop.SetResizeFrameSize(10, ((26 * m_CurCount) + (OpenPetCount * 18)) + 4);
        // End:0x537
        if(bOption)
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
        m_PetPartyStatus[idx].HideWindow();
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
    local int Id, UseVName, DominionIDForVName, SummonCount;
    local string VName, SummonVName;
    local PartyMemberInfo PartyMemberInfo;
    local PartyMemberPetInfo PartyMemberPetInfo;
    local int Index, i, summonType, summonMAXHP, summonMAXMP, summonHP,
	    summonMP, summonClassID;

    ParseInt(param, "ID", Id);
    ParseInt(param, "UseVName", UseVName);
    ParseInt(param, "DominionIDForVName", DominionIDForVName);
    ParseString(param, "VName", VName);
    ParseString(param, "SummonVName", SummonVName);
    GetPartyMemberInfo(Id, PartyMemberInfo);
    GetPartyMemberPetInfo(Id, PartyMemberPetInfo);
    // End:0x3A7
    if(Id > 0)
    {
        m_Vname[m_CurCount].Id = Id;
        m_Vname[m_CurCount].UseVName = UseVName;
        m_Vname[m_CurCount].DominionIDForVName = DominionIDForVName;
        m_Vname[m_CurCount].VName = VName;
        ExecuteEvent(980);
        m_CurCount++;
        m_arrID[m_CurCount - 1] = Id;
        UpdateStatus(m_CurCount - 1, param);
        // End:0x1FB
        if(PartyMemberInfo.curSummonNum > 0)
        {
            PartySummonProcess(Id);
            i = 0;
            J0x164:

            // End:0x1FB [Loop If]
            if(i < SummonCount)
            {
                ParseInt(param, "SummonType" $ string(i), summonType);
                ParseInt(param, "SummonClassID" $ string(i), summonClassID);
                // End:0x1F1
                if(summonType == 1)
                {
                    m_ClassIconSummon[m_CurCount - 1].SetTooltipText(GetSystemString(505));
                    // [Explicit Break]
                    goto J0x1FB;
                }
                i++;
                // [Loop Continue]
                goto J0x164;
            }
        }
        J0x1FB:

        // End:0x3A1
        if(PartyMemberInfo.curHavePet == true)
        {
            Index = FindPartyID(Id);
            ParseInt(param, "SummonCount", SummonCount);
            i = 0;
            J0x241:

            // End:0x38B [Loop If]
            if(i < SummonCount)
            {
                ParseInt(param, "SummonType" $ string(i), summonType);
                // End:0x381
                if(summonType == 2)
                {
                    ParseInt(param, "SummonMaxHP" $ string(i), summonMAXHP);
                    ParseInt(param, "SummonMaxMP" $ string(i), summonMAXMP);
                    ParseInt(param, "SummonHP" $ string(i), summonHP);
                    ParseInt(param, "SummonMP" $ string(i), summonMP);
                    ParseString(param, "SummonVName" $ string(i), SummonVName);
                    UpdateHPBar(Index + 100, summonHP, summonMAXHP);
                    UpdateMPBar(Index + 100, summonMP, summonMAXMP);
                    m_Vname[m_CurCount].SummonVName = SummonVName;
                }
                i++;
                // [Loop Continue]
                goto J0x241;
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
    local int Id, cp, maxCP, hp, MaxHP, mp,
	    maxMP, ClassID, vitality, MasterID;

    local UserInfo TargetUser;
    local CustomTooltip TooltipInfo, TooltipInfo2;
    local int UseVName, DominionIDForVName;
    local string VName, SummonVName;

    // End:0x1B
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
    ParseInt(param, "Vitality", vitality);
    UseVName = m_Vname[idx].UseVName;
    DominionIDForVName = m_Vname[idx].DominionIDForVName;
    VName = m_Vname[idx].VName;
    SummonVName = m_Vname[idx].SummonVName;
    // End:0x192
    if(ParseInt(param, "MasterID", MasterID))
    {
        m_MasterID = MasterID;
    }
    TooltipInfo.DrawList.Length = 1;
    TooltipInfo.DrawList[0].eType = 1;
    TooltipInfo.DrawList[0].t_bDrawOneLine = true;
    // End:0x26B
    if((m_MasterID > 0) && m_MasterID == Id)
    {
        // End:0x23A
        if(TargetUser.WantHideName && TargetUser.RealName != "")
        {
            TooltipInfo.DrawList[0].t_strText = ((TargetUser.Name $ "(") $ GetSystemString(408)) $ ")";            
        }
        else
        {
            TooltipInfo.DrawList[0].t_strText = ((Name $ "(") $ GetSystemString(408)) $ ")";
        }        
    }
    else
    {
        // End:0x290
        if(UseVName == 1)
        {
            TooltipInfo.DrawList[0].t_strText = VName;            
        }
        else
        {
            TooltipInfo.DrawList[0].t_strText = Name;
        }
    }
    m_PartyStatus[idx].SetTooltipCustomType(TooltipInfo);
    m_ClassIcon[idx].SetTexture(GetClassRoleIconName(ClassID));
    TooltipInfo2.DrawList.Length = 2;
    TooltipInfo2.DrawList[0].eType = 1;
    TooltipInfo2.DrawList[0].t_bDrawOneLine = true;
    // End:0x3BB
    if((m_MasterID > 0) && m_MasterID == Id)
    {
        // End:0x38A
        if(TargetUser.WantHideName && TargetUser.RealName != "")
        {
            TooltipInfo2.DrawList[0].t_strText = ((TargetUser.Name $ "(") $ GetSystemString(408)) $ ")";            
        }
        else
        {
            TooltipInfo2.DrawList[0].t_strText = ((Name $ "(") $ GetSystemString(408)) $ ")";
        }        
    }
    else
    {
        // End:0x3FB
        if(TargetUser.WantHideName && TargetUser.RealName != "")
        {
            TooltipInfo2.DrawList[0].t_strText = TargetUser.Name;            
        }
        else
        {
            TooltipInfo2.DrawList[0].t_strText = Name;
        }
    }
    TooltipInfo2.DrawList[1].eType = 1;
    TooltipInfo2.DrawList[1].nOffSetY = 2;
    TooltipInfo2.DrawList[1].t_bDrawOneLine = true;
    TooltipInfo2.DrawList[1].bLineBreak = true;
    TooltipInfo2.DrawList[1].t_strText = (GetClassRoleName(ClassID) $ " - ") $ GetClassType(ClassID);
    TooltipInfo2.DrawList[1].t_color.R = 128;
    TooltipInfo2.DrawList[1].t_color.G = 128;
    TooltipInfo2.DrawList[1].t_color.B = 128;
    TooltipInfo2.DrawList[1].t_color.A = byte(255);
    m_ClassIcon[idx].SetTooltipCustomType(TooltipInfo2);
    UpdateCPBar(idx, cp, maxCP);
    UpdateHPBar(idx, hp, MaxHP);
    UpdateMPBar(idx, mp, maxMP);
    return;
}

function HandlePartyPetAdd(string param)
{
    local int MasterID, Id, i, Type, MasterIndex;

    ParseInt(param, "Type", Type);
    // End:0x11E
    if(Type == 2)
    {
        ParseInt(param, "MasterID", MasterID);
        ParseInt(param, "ID", Id);
        // End:0x11E
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
            // End:0xEA
            if(MasterIndex == -1)
            {
                Debug("HandlePartyPetAdd ERROR - Can't find master ID");
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

    // End:0xEC
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

        // End:0xA1
        if(MasterIndex == -1)
        {
            Debug("PartySummonProcess -> ERROR - Can't find master ID");
            return;
        }
        GetPartyMemberInfo(MasterID, PartyMemberInfo);
        // End:0xD5
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
	    DeBuffCnt, DeBuffCurRow;

    local bool isPC;
    local StatusIconInfo Info;

    DeBuffCurRow = -1;
    BuffCurRow = -1;
    ParseInt(param, "ID", Id);
    // End:0x37
    if(Id < 1)
    {
        return;
    }
    idx = FindPartyID(Id);
    // End:0x88
    if(idx >= 0)
    {
        m_StatusIconBuff[idx].Clear();
        m_StatusIconDeBuff[idx].Clear();
        isPC = true;        
    }
    else
    {
        idx = FindPetID(Id);
        // End:0xD9
        if(idx >= 0)
        {
            m_PetStatusIconBuff[idx].Clear();
            m_PetStatusIconDeBuff[idx].Clear();
            isPC = false;            
        }
        else
        {
            return;
        }
    }
    Info.Size = 10;
    Info.bShow = true;
    ParseInt(param, "Max", Max);
    i = 0;
    J0x111:

    // End:0x3AE [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        // End:0x1BC
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            // [Explicit Continue]
            goto J0x3A4;
        }
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x3A4
        if(IsValidItemID(Info.Id))
        {
            Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
            // End:0x301
            if(GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0)
            {
                // End:0x2AD
                if((float(DeBuffCnt) % float(12)) == float(0))
                {
                    DeBuffCurRow++;
                    // End:0x298
                    if(isPC)
                    {
                        m_StatusIconDeBuff[idx].AddRow();                        
                    }
                    else
                    {
                        m_PetStatusIconDeBuff[idx].AddRow();
                    }
                }
                // End:0x2D8
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
                goto J0x3A4;
            }
            // End:0x353
            if((float(BuffCnt) % float(12)) == float(0))
            {
                BuffCurRow++;
                // End:0x33E
                if(isPC)
                {
                    m_StatusIconBuff[idx].AddRow();                    
                }
                else
                {
                    m_PetStatusIconBuff[idx].AddRow();
                }
            }
            // End:0x37E
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
        J0x3A4:

        i++;
        // [Loop Continue]
        goto J0x111;
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

    // End:0x25E [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x254
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
                goto J0x254;
            }
            // End:0x220
            if(isPC)
            {
                deleteBuff(m_StatusIconBuff[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
                // [Explicit Continue]
                goto J0x254;
            }
            deleteBuff(m_PetStatusIconBuff[idx], Info.Level, Info.Id.ClassID, Info.SpellerID);
        }
        J0x254:

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
    Info.Size = 10;
    Info.bShow = true;
    ParseInt(param, "Max", Max);
    i = 0;
    J0xA4:

    // End:0x333 [Loop If]
    if(i < Max)
    {
        ParseItemIDWithIndex(param, Info.Id, i);
        ParseInt(param, "Level_" $ string(i), Info.Level);
        ParseInt(param, "SubLevel_" $ string(i), Info.SubLevel);
        ParseInt(param, "Sec_" $ string(i), Info.RemainTime);
        // End:0x173
        if(Class'NWindow.UIDATA_SKILL'.static.IsToppingSkill(Info.Id, Info.Level, Info.SubLevel))
        {
            // [Explicit Continue]
            goto J0x329;
        }
        ParseInt(param, "SpellerID_" $ string(i), Info.SpellerID);
        // End:0x329
        if(IsValidItemID(Info.Id))
        {
            Info.IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(Info.Id, Info.Level, Info.SubLevel);
            Info.bHideRemainTime = true;
            // End:0x250
            if(GetDebuffType(Info.Id, Info.Level, Info.SubLevel) != 0)
            {
                // End:0x23C
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
                // End:0x26D
                if(isPC)
                {
                    tmpStatusIcon = m_StatusIconBuff[idx];                    
                }
                else
                {
                    tmpStatusIcon = m_PetStatusIconBuff[idx];
                }
            }
            deleteBuff(tmpStatusIcon, Info.Level, Info.Id.ClassID, Info.SpellerID);
            // End:0x303
            if((tmpStatusIcon.GetRowCount() == 0) || (float(tmpStatusIcon.GetColCount(tmpStatusIcon.GetRowCount() - 1)) % float(12)) == float(0))
            {
                tmpStatusIcon.AddRow();
            }
            tmpStatusIcon.AddCol(tmpStatusIcon.GetRowCount() - 1, Info);
        }
        J0x329:

        i++;
        // [Loop Continue]
        goto J0xA4;
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
    if(m_CurBf > 2)
    {
        m_CurBf = 0;
    }
    SetINIInt("PartyWndCompact", "a", m_CurBf, "WindowsInfo.ini");
    SetBuffButtonTooltip();
    switch(m_CurBf)
    {
        // End:0x81
        case 1:
            UpdateBuff();
            // End:0xA3
            break;
        // End:0x8F
        case 2:
            UpdateBuff();
            // End:0xA3
            break;
        // End:0xA0
        case 0:
            m_CurBf = 0;
            UpdateBuff();
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    local int idx;
    local PartyWnd script;

    script = PartyWnd(GetScript("PartyWnd"));
    switch(strID)
    {
        // End:0x37
        case "btnBuff":
            OnBuffButton();
            // End:0x62
            break;
        // End:0x4E
        case "btnOption":
            OnOpenPartyWndOption();
            // End:0x62
            break;
        // End:0x5F
        case "btnSummon":
            // End:0x62
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xF4
    if(InStr(strID, "btnSummon") > -1)
    {
        idx = int(Right(strID, 1));
        // End:0xCC
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
    m_PartyOption.SetAnchor("PartyWndCompact.PartyStatusWnd0", "TopRight", "TopLeft", 5, 5);
    return;
}

function OnBuffButton()
{
    m_CurBf = m_CurBf + 1;
    // End:0x21
    if(m_CurBf > 2)
    {
        m_CurBf = 0;
    }
    SetINIInt("PartyWndCompact", "a", m_CurBf, "WindowsInfo.ini");
    SetBuffButtonTooltip();
    UpdateBuff();
    return;
}

function UpdateBuff()
{
    local int idx;

    // End:0x7F
    if(m_CurBf == 1)
    {
        idx = 0;
        J0x12:

        // End:0x7C [Loop If]
        if(idx < 10)
        {
            m_StatusIconBuff[idx].ShowWindow();
            m_PetStatusIconBuff[idx].ShowWindow();
            m_StatusIconDeBuff[idx].HideWindow();
            m_PetStatusIconDeBuff[idx].HideWindow();
            idx++;
            // [Loop Continue]
            goto J0x12;
        }        
    }
    else
    {
        // End:0xFF
        if(m_CurBf == 2)
        {
            idx = 0;
            J0x92:

            // End:0xFC [Loop If]
            if(idx < 10)
            {
                m_StatusIconBuff[idx].HideWindow();
                m_PetStatusIconBuff[idx].HideWindow();
                m_StatusIconDeBuff[idx].ShowWindow();
                m_PetStatusIconDeBuff[idx].ShowWindow();
                idx++;
                // [Loop Continue]
                goto J0x92;
            }            
        }
        else
        {
            idx = 0;
            J0x106:

            // End:0x170 [Loop If]
            if(idx < 10)
            {
                m_StatusIconBuff[idx].HideWindow();
                m_PetStatusIconBuff[idx].HideWindow();
                m_StatusIconDeBuff[idx].HideWindow();
                m_PetStatusIconDeBuff[idx].HideWindow();
                idx++;
                // [Loop Continue]
                goto J0x106;
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
    // End:0x1A0
    if(X > (rectWnd.nX + 30))
    {
        // End:0x1A0
        if(GetPlayerInfo(UserInfo))
        {
            idx = GetIdx(Y - rectWnd.nY);
            rectWnd = m_PetPartyStatus[idx].GetRect();
            rectPetClassIcon = m_PetClassIcon[idx].GetRect();
            // End:0x11D
            if(IsPKMode())
            {
                // End:0xC1
                if(idx < 100)
                {
                    RequestAttack(m_arrID[idx], UserInfo.loc);                    
                }
                else
                {
                    // End:0x11A
                    if((X > rectPetClassIcon.nX) && X < ((rectWnd.nX + rectWnd.nWidth) - 10))
                    {
                        RequestAttack(m_arrPetID[idx - 100], UserInfo.loc);
                    }
                }                
            }
            else
            {
                // End:0x147
                if(idx < 100)
                {
                    RequestAction(m_arrID[idx], UserInfo.loc);                    
                }
                else
                {
                    // End:0x1A0
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
    // End:0xA1
    if(X > (rectWnd.nX + 30))
    {
        // End:0xA1
        if(GetPlayerInfo(UserInfo))
        {
            idx = GetIdx(Y - rectWnd.nY);
            // End:0x82
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

    // End:0xBB [Loop If]
    if(i < 10)
    {
        tempY = tempY - 26;
        // End:0x52
        if(i == 0)
        {
            tempY = tempY - 4;
        }
        // End:0x71
        if(tempY < 0)
        {
            idx = i;
            return idx;
            // [Explicit Continue]
            goto J0xB1;
        }
        // End:0xB1
        if(m_arrPetIDOpen[i] == 1)
        {
            tempY = tempY - 18;
            // End:0xB1
            if(tempY < 0)
            {
                idx = i + 100;
                return idx;
            }
        }
        J0xB1:

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
            // End:0x41
            break;
        // End:0x2B
        case 1:
            idx = 1497;
            // End:0x41
            break;
        // End:0x3E
        case 2:
            idx = 1498;
            // End:0x41
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
    local PartyWnd script1;

    script1 = PartyWnd(GetScript("PartyWnd"));
    dropIdx = -1;
    targetIdx = -1;
    // End:0x4B
    if((hTarget == none) || hDropWnd == none)
    {
        return;
    }
    sTargetName = hTarget.GetWindowName();
    sDropName = hDropWnd.GetWindowName();
    sTargetParent = hTarget.GetParentWindowName();
    // End:0xF6
    if(((InStr(sTargetName, "PartyStatusWnd") == -1) && InStr(sTargetParent, "PartyStatusWnd") == -1) || InStr(sDropName, "PartyStatusWnd") == -1)
    {
        return;        
    }
    else
    {
        dropIdx = int(Right(sDropName, 1));
        // End:0x13A
        if(InStr(sTargetName, "PartyStatusWnd") > -1)
        {
            targetIdx = int(Right(sTargetName, 1));            
        }
        else
        {
            targetIdx = int(Right(sTargetParent, 1));
        }
        // End:0x162
        if((dropIdx < 0) || targetIdx < 0)
        {
        }
        // End:0x213
        if(dropIdx > targetIdx)
        {
            CopyStatus(9, dropIdx);
            script1.CopyStatus(9, dropIdx);
            i = dropIdx - 1;
            J0x1A2:

            // End:0x1ED [Loop If]
            if(i > (targetIdx - 1))
            {
                CopyStatus(i + 1, i);
                script1.CopyStatus(i + 1, i);
                i--;
                // [Loop Continue]
                goto J0x1A2;
            }
            CopyStatus(targetIdx, 9);
            script1.CopyStatus(targetIdx, 9);            
        }
        else
        {
            // End:0x2C1
            if(dropIdx < targetIdx)
            {
                CopyStatus(9, dropIdx);
                script1.CopyStatus(9, dropIdx);
                i = dropIdx + 1;
                J0x253:

                // End:0x29E [Loop If]
                if(i < (targetIdx + 1))
                {
                    CopyStatus(i - 1, i);
                    script1.CopyStatus(i - 1, i);
                    i++;
                    // [Loop Continue]
                    goto J0x253;
                }
                CopyStatus(targetIdx, 9);
                script1.CopyStatus(targetIdx, 9);
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
