class GMMagicSkillWnd extends MagicSkillWnd;

var bool bShow;

function OnRegisterEvent()
{
    RegisterEvent(2300);
    RegisterEvent(2310);
    return;
}

function OnLoad()
{
    local int i;

    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x4E4
    if(1 == 0)
    {
        m_wndTop = GetHandle(m_WindowName);
        areaScroll = GetHandle(m_WindowName $ ".ASkillScroll");
        areaScroll_p = GetHandle(m_WindowName $ ".PSkillScroll");
        i = 0;
        J0x70:

        // End:0x2A5 [Loop If]
        if(i < 8)
        {
            m_wndName[i] = GetHandle((m_WindowName $ ".ASkill.ASkillName") $ string(i));
            m_wnd[i] = GetHandle((m_WindowName $ ".ASkill.ASkill") $ string(i));
            m_NameStr[i] = TextBoxHandle(GetHandle((((m_WindowName $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillNameStr") $ string(i)));
            m_NameBtn[i] = TextureHandle(GetHandle((((m_WindowName $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillBtn") $ string(i)));
            m_Item[i] = ItemWindowHandle(GetHandle((((m_WindowName $ ".ASkill.ASkill") $ string(i)) $ ".ASkillItem") $ string(i)));
            m_ItemBg[i] = TextureHandle(GetHandle((((m_WindowName $ ".ASkill.ASkill") $ string(i)) $ ".ASkillSlotBg") $ string(i)));
            m_HiddenBtn[i] = ButtonHandle(GetHandle((((m_WindowName $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillHiddenBtn") $ string(i)));
            m_HiddenBtn[i].SetAlpha(255);
            i++;
            // [Loop Continue]
            goto J0x70;
        }
        i = 0;
        J0x2AC:

        // End:0x4E1 [Loop If]
        if(i < 6)
        {
            m_wndName_p[i] = GetHandle((m_WindowName $ ".PSkill.PSkillName") $ string(i));
            m_wnd_p[i] = GetHandle((m_WindowName $ ".PSkill.PSkill") $ string(i));
            m_NameStr_p[i] = TextBoxHandle(GetHandle((((m_WindowName $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillNameStr") $ string(i)));
            m_NameBtn_p[i] = TextureHandle(GetHandle((((m_WindowName $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillBtn") $ string(i)));
            m_Item_p[i] = ItemWindowHandle(GetHandle((((m_WindowName $ ".PSkill.PSkill") $ string(i)) $ ".PSkillItem") $ string(i)));
            m_ItemBg_p[i] = TextureHandle(GetHandle((((m_WindowName $ ".PSkill.PSkill") $ string(i)) $ ".PSkillSlotBg") $ string(i)));
            m_HiddenBtn_p[i] = ButtonHandle(GetHandle((((m_WindowName $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillHiddenBtn") $ string(i)));
            m_HiddenBtn_p[i].SetAlpha(255);
            i++;
            // [Loop Continue]
            goto J0x2AC;
        }        
    }
    else
    {
        m_wndTop = GetWindowHandle(m_WindowName);
        areaScroll = GetWindowHandle(m_WindowName $ ".ASkillScroll");
        areaScroll_p = GetWindowHandle(m_WindowName $ ".PSkillScroll");
        i = 0;
        J0x540:

        // End:0x75C [Loop If]
        if(i < 8)
        {
            m_wndName[i] = GetWindowHandle((m_WindowName $ ".ASkill.ASkillName") $ string(i));
            m_wnd[i] = GetWindowHandle((m_WindowName $ ".ASkill.ASkill") $ string(i));
            m_NameStr[i] = GetTextBoxHandle((((m_WindowName $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillNameStr") $ string(i));
            m_NameBtn[i] = GetTextureHandle((((m_WindowName $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillBtn") $ string(i));
            m_Item[i] = GetItemWindowHandle((((m_WindowName $ ".ASkill.ASkill") $ string(i)) $ ".ASkillItem") $ string(i));
            m_ItemBg[i] = GetTextureHandle((((m_WindowName $ ".ASkill.ASkill") $ string(i)) $ ".ASkillSlotBg") $ string(i));
            m_HiddenBtn[i] = GetButtonHandle((((m_WindowName $ ".ASkill.ASkillName") $ string(i)) $ ".ASkillHiddenBtn") $ string(i));
            m_HiddenBtn[i].SetAlpha(255);
            i++;
            // [Loop Continue]
            goto J0x540;
        }
        i = 0;
        J0x763:

        // End:0x97F [Loop If]
        if(i < 6)
        {
            m_wndName_p[i] = GetWindowHandle((m_WindowName $ ".PSkill.PSkillName") $ string(i));
            m_wnd_p[i] = GetWindowHandle((m_WindowName $ ".PSkill.PSkill") $ string(i));
            m_NameStr_p[i] = GetTextBoxHandle((((m_WindowName $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillNameStr") $ string(i));
            m_NameBtn_p[i] = GetTextureHandle((((m_WindowName $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillBtn") $ string(i));
            m_Item_p[i] = GetItemWindowHandle((((m_WindowName $ ".PSkill.PSkill") $ string(i)) $ ".PSkillItem") $ string(i));
            m_ItemBg_p[i] = GetTextureHandle((((m_WindowName $ ".PSkill.PSkill") $ string(i)) $ ".PSkillSlotBg") $ string(i));
            m_HiddenBtn_p[i] = GetButtonHandle((((m_WindowName $ ".PSkill.PSkillName") $ string(i)) $ ".PSkillHiddenBtn") $ string(i));
            m_HiddenBtn_p[i].SetAlpha(255);
            i++;
            // [Loop Continue]
            goto J0x763;
        }
    }
    bShow = false;
    return;
}

function OnShow()
{
    return;
}

function OnHide()
{
    return;
}

function ShowMagicSkill(string a_Param)
{
    // End:0x0E
    if(a_Param == "")
    {
        return;
    }
    // End:0x37
    if(bShow)
    {
        Clear();
        m_hOwnerWnd.HideWindow();
        bShow = false;        
    }
    else
    {
        Class'NWindow.GMAPI'.static.RequestGMCommand(3, a_Param);
        bShow = true;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x18
        case 2300:
            HadleGMObservingSkillListStart();
            // End:0x34
            break;
        // End:0x2E
        case 2310:
            HadleGMObservingSkillList(a_Param);
            // End:0x34
            break;
        // End:0xFFFF
        default:
            // End:0x34
            break;
            break;
    }
    return;
}

function HadleGMObservingSkillListStart()
{
    Clear();
    m_hOwnerWnd.ShowWindow();
    m_hOwnerWnd.SetFocus();
    return;
}

function HadleGMObservingSkillList(string a_Param)
{
    HandleSkillList(a_Param);
    ComputeItemWndHeight();
    ComputeItemWndAnchor();
    return;
}

function OnClickItem(string strID, int Index)
{
    return;
}

defaultproperties
{
    m_WindowName="GMMagicSkillWnd"
}