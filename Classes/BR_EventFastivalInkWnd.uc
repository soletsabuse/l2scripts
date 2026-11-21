class BR_EventFastivalInkWnd extends UICommonAPI;

var int MaxEnergy;
var int CurrentEnergy;
var WindowHandle Me;
var TextureHandle EventInkTex;
var TextureHandle EventInkTexBG;
var ButtonHandle HelpButton;
var StatusBarHandle GoalGage1;
var StatusBarHandle GoalGage2;
var StatusBarHandle GoalGageMax;
var bool m_showInk;

function OnRegisterEvent()
{
    RegisterEvent(10000);
    RegisterEvent(10001);
    RegisterEvent(3410);
    return;
}

function OnLoad()
{
    Initialize();
    load();
    return;
}

function Initialize()
{
    // End:0x15A
    if(1 == 0)
    {
        Me = GetHandle("BR_EventFastivalInkWnd");
        EventInkTex = TextureHandle(GetHandle("BR_EventFastivalInkWnd.EventInkTex"));
        EventInkTexBG = TextureHandle(GetHandle("BR_EventFastivalInkWnd.EventInkTexBG"));
        HelpButton = ButtonHandle(GetHandle("BR_EventFastivalInkWnd.HelpButton"));
        GoalGage1 = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGage1");
        GoalGage2 = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGage2");
        GoalGageMax = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGageMax");        
    }
    else
    {
        Me = GetWindowHandle("BR_EventFastivalInkWnd");
        EventInkTex = GetTextureHandle("BR_EventFastivalInkWnd.EventInkTex");
        EventInkTexBG = GetTextureHandle("BR_EventFastivalInkWnd.EventInkTexBG");
        HelpButton = GetButtonHandle("BR_EventFastivalInkWnd.HelpButton");
        GoalGage1 = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGage1");
        GoalGage2 = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGage2");
        GoalGageMax = GetStatusBarHandle("BR_EventFastivalInkWnd.GoalGageMax");
    }
    MaxEnergy = 10000;
    CurrentEnergy = 0;
    GoalGageMax.SetPointExpPercentRate(1.0000000);
    GoalGageMax.HideWindow();
    Me.HideWindow();
    EventInkTexBG.HideWindow();
    m_showInk = false;
    return;
}

function load()
{
    HelpButton.SetTooltipCustomType(SetTooltip(GetSystemString(5148)));
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local int iEnergy;

    switch(a_EventID)
    {
        // End:0x35
        case 10000:
            ParseInt(a_Param, "Energy", iEnergy);
            EventInkWndShow(iEnergy);
            // End:0x66
            break;
        // End:0x63
        case 10001:
            ParseInt(a_Param, "Energy", iEnergy);
            FireEventGauge(iEnergy);
            // End:0x66
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xBB
    if(a_EventID == 3410)
    {
        // End:0xBB
        if(a_Param == "GAMINGSTATE")
        {
            // End:0xBB
            if(m_showInk == true)
            {
                // End:0xBB
                if(!Me.IsShowWindow())
                {
                    Me.ShowWindow();
                }
            }
        }
    }
    return;
}

function EventInkWndShow(int iMaxEnergy)
{
    // End:0x23
    if(!Me.IsShowWindow())
    {
        Me.ShowWindow();
    }
    MaxEnergy = iMaxEnergy;
    GoalGage1.SetPointExpPercentRate(0.0000000);
    GoalGage2.SetPointExpPercentRate(0.0000000);
    m_showInk = true;
    return;
}

function FireEventGauge(int iEnergy)
{
    local float convertpercent;

    CurrentEnergy = iEnergy;
    convertpercent = float(CurrentEnergy) / float(MaxEnergy);
    // End:0xB7
    if(convertpercent >= 1.0000000)
    {
        GoalGage1.SetPointExpPercentRate(1.0000000);
        EventInkTex.SetTexture("BranchSys3.icon1.g_ev_invite_ink_03");
        GoalGage1.HideWindow();
        GoalGage2.HideWindow();
        GoalGageMax.ShowWindow();
        EventInkTexBG.ShowWindow();        
    }
    else
    {
        // End:0x12F
        if(convertpercent >= 0.1429000)
        {
            EventInkTex.SetTexture("BranchSys3.icon1.g_ev_invite_ink_02");
            GoalGage2.ShowWindow();
            GoalGage1.HideWindow();
            GoalGage2.SetPointExpPercentRate(convertpercent);            
        }
        else
        {
            EventInkTex.SetTexture("BranchSys3.icon1.g_ev_invite_ink_01");
            GoalGage1.ShowWindow();
            GoalGage2.HideWindow();
            GoalGage1.SetPointExpPercentRate(convertpercent);
        }
        GoalGageMax.HideWindow();
        EventInkTexBG.HideWindow();
    }
    return;
}

function CustomTooltip SetTooltip(string Text)
{
    local CustomTooltip ToolTip;
    local DrawItemInfo Info;

    ToolTip.MinimumWidth = 144;
    ToolTip.DrawList.Length = 1;
    Info.eType = 1;
    Info.t_bDrawOneLine = true;
    Info.t_color.R = 178;
    Info.t_color.G = 190;
    Info.t_color.B = 207;
    Info.t_color.A = byte(255);
    Info.t_strText = Text;
    ToolTip.DrawList[0] = Info;
    return ToolTip;
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1F
        case "HelpButton":
            OnHelpButtonClick();
            // End:0x22
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEventFireBtn1Click()
{
    return;
}

function OnHelpButtonClick()
{
    return;
}
