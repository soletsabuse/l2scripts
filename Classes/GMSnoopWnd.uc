class GMSnoopWnd extends UICommonAPI;

const MAX_GMSnoop = 4;

var int m_SnoopIDList[4];
var WindowHandle m_hSnoopWndList[4];
var TextListBoxHandle m_hSnoopChatWndList[4];
var ButtonHandle m_hCancelButtonList[4];
var CheckBoxHandle m_hCheckBox[28];

function OnRegisterEvent()
{
    RegisterEvent(2410);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x1D
    if(1 == 0)
    {
        InitHandle();        
    }
    else
    {
        InitHandleCOD();
    }
    ClearAllSnoop();
    return;
}

function InitHandle()
{
    local int i, j;

    i = 0;
    J0x07:

    // End:0x12F [Loop If]
    if(i < 4)
    {
        m_hSnoopWndList[i] = GetHandle("SnoopWnd" $ string(i + 1));
        m_hSnoopChatWndList[i] = TextListBoxHandle(GetHandle(("SnoopWnd" $ string(i + 1)) $ ".Chat"));
        m_hCancelButtonList[i] = ButtonHandle(GetHandle(("GMSnoopWnd.SnoopWnd" $ string(i + 1)) $ ".CancelButton"));
        j = 0;
        J0xC1:

        // End:0x125 [Loop If]
        if(j < 7)
        {
            m_hCheckBox[(i * 7) + j] = CheckBoxHandle(GetHandle((("SnoopWnd" $ string(i + 1)) $ ".CheckBox") $ string(j)));
            ++j;
            // [Loop Continue]
            goto J0xC1;
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function InitHandleCOD()
{
    local int i, j;

    i = 0;
    J0x07:

    // End:0x120 [Loop If]
    if(i < 4)
    {
        m_hSnoopWndList[i] = GetWindowHandle("SnoopWnd" $ string(i + 1));
        m_hSnoopChatWndList[i] = GetTextListBoxHandle(("SnoopWnd" $ string(i + 1)) $ ".Chat");
        m_hCancelButtonList[i] = GetButtonHandle(("GMSnoopWnd.SnoopWnd" $ string(i + 1)) $ ".CancelButton");
        j = 0;
        J0xB7:

        // End:0x116 [Loop If]
        if(j < 7)
        {
            m_hCheckBox[(i * 7) + j] = GetCheckBoxHandle((("SnoopWnd" $ string(i + 1)) $ ".CheckBox") $ string(j));
            ++j;
            // [Loop Continue]
            goto J0xB7;
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnShow()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x32 [Loop If]
    if(i < 4)
    {
        m_hSnoopWndList[i].HideWindow();
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnHide()
{
    return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x57 [Loop If]
    if(i < 4)
    {
        // End:0x4D
        if(a_ButtonHandle == m_hCancelButtonList[i])
        {
            Class'NWindow.GMAPI'.static.RequestSnoopEnd(m_SnoopIDList[i]);
            ClearSnoop(i);
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 2410:
            HandleGMSnoop(a_Param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleGMSnoop(string a_Param)
{
    local int SnoopID;
    local string SnoopName;
    local int CreatureID, Type, SnoopIndex;
    local string CharacterName, chatMessage;
    local WindowHandle hSnoopWnd;
    local TextListBoxHandle hSnoopChatWnd;

    ParseInt(a_Param, "SnoopID", SnoopID);
    ParseString(a_Param, "SnoopName", SnoopName);
    // End:0x72
    if(!GetSnoopWnd(SnoopID, hSnoopWnd, hSnoopChatWnd, SnoopIndex, SnoopName))
    {
        DialogShow(1, 1, GetSystemMessage(802), string(self));
        return;
    }
    ParseString(a_Param, "CharacterName", CharacterName);
    ParseInt(a_Param, "CreatureID", CreatureID);
    ParseInt(a_Param, "Type", Type);
    ParseString(a_Param, "ChatMessage", chatMessage);
    // End:0x103
    if(!m_hOwnerWnd.IsShowWindow())
    {
        m_hOwnerWnd.ShowWindow();
    }
    hSnoopWnd.ShowWindow();
    // End:0x155
    if(!IsFiltered(byte(Type), SnoopIndex))
    {
        hSnoopChatWnd.AddString((CharacterName $ ": ") $ chatMessage, GetChatColorByType(Type));
    }
    return;
}

function ClearAllSnoop()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x28 [Loop If]
    if(i < 4)
    {
        ClearSnoop(i);
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function ClearSnoop(int a_SnoopIndex)
{
    local int i;
    local bool AllHidden;

    // End:0x0D
    if(0 > a_SnoopIndex)
    {
        return;
    }
    // End:0x1B
    if(4 <= a_SnoopIndex)
    {
        return;
    }
    m_hSnoopChatWndList[a_SnoopIndex].Clear();
    m_SnoopIDList[a_SnoopIndex] = -1;
    m_hSnoopWndList[a_SnoopIndex].HideWindow();
    AllHidden = true;
    i = 0;
    J0x65:

    // End:0x9B [Loop If]
    if(i < 4)
    {
        // End:0x91
        if(-1 != m_SnoopIDList[i])
        {
            AllHidden = false;
            // [Explicit Break]
            goto J0x9B;
        }
        ++i;
        // [Loop Continue]
        goto J0x65;
    }
    J0x9B:

    // End:0xB3
    if(AllHidden)
    {
        m_hOwnerWnd.HideWindow();
    }
    return;
}

function bool GetSnoopWnd(int a_SnoopID, out WindowHandle a_hSnoopWnd, out TextListBoxHandle a_hSnoopChatWnd, out int a_SnoopIndex, string a_CharacterName)
{
    local int SnoopIndex;

    SnoopIndex = GetSnoopIndexByID(a_SnoopID);
    // End:0x4F
    if(-1 != SnoopIndex)
    {
        a_hSnoopWnd = m_hSnoopWndList[SnoopIndex];
        a_hSnoopChatWnd = m_hSnoopChatWndList[SnoopIndex];
        a_SnoopIndex = SnoopIndex;
        return true;
    }
    SnoopIndex = GetSnoopIndexByID(-1);
    // End:0xD7
    if(-1 != SnoopIndex)
    {
        m_SnoopIDList[SnoopIndex] = a_SnoopID;
        a_hSnoopWnd = m_hSnoopWndList[SnoopIndex];
        a_hSnoopChatWnd = m_hSnoopChatWndList[SnoopIndex];
        a_SnoopIndex = SnoopIndex;
        a_hSnoopWnd.SetWindowTitle((GetSystemString(693) $ " - ") $ a_CharacterName);
        return true;
    }
    return false;
    return;
}

function int GetSnoopIndexByID(int a_SnoopID)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(i < 4)
    {
        // End:0x2E
        if(a_SnoopID == m_SnoopIDList[i])
        {
            return i;
        }
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function bool IsFiltered(UIEventManager.EChatType a_Type, int a_SnoopIndex)
{
    switch(a_Type)
    {
        // End:0x2D
        case 8:
            // End:0x2A
            if(m_hCheckBox[a_SnoopIndex * 7].IsChecked())
            {
                return false;
            }
            // End:0x12B
            break;
        // End:0x56
        case 4:
            // End:0x53
            if(m_hCheckBox[(a_SnoopIndex * 7) + 1].IsChecked())
            {
                return false;
            }
            // End:0x12B
            break;
        // End:0x80
        case 3:
            // End:0x7D
            if(m_hCheckBox[(a_SnoopIndex * 7) + 2].IsChecked())
            {
                return false;
            }
            // End:0x12B
            break;
        // End:0xAA
        case 1:
            // End:0xA7
            if(m_hCheckBox[(a_SnoopIndex * 7) + 3].IsChecked())
            {
                return false;
            }
            // End:0x12B
            break;
        // End:0xD4
        case 2:
            // End:0xD1
            if(m_hCheckBox[(a_SnoopIndex * 7) + 4].IsChecked())
            {
                return false;
            }
            // End:0x12B
            break;
        // End:0xFE
        case 0:
            // End:0xFB
            if(m_hCheckBox[(a_SnoopIndex * 7) + 5].IsChecked())
            {
                return false;
            }
            // End:0x12B
            break;
        // End:0x128
        case 9:
            // End:0x125
            if(m_hCheckBox[(a_SnoopIndex * 7) + 6].IsChecked())
            {
                return false;
            }
            // End:0x12B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return true;
    return;
}
