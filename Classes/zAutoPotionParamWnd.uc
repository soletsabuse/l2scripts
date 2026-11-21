class zAutoPotionParamWnd extends UICommonAPI;

var WindowHandle Me;
var int cp_step;
var int bcp_step;
var int hp_step;
var int mp_step;
var int mp2_step;
var SliderCtrlHandle cp;
var SliderCtrlHandle bCP;
var SliderCtrlHandle hp;
var SliderCtrlHandle mp;
var SliderCtrlHandle MP2;
var TextBoxHandle CPTxt;
var TextBoxHandle bCPTxt;
var TextBoxHandle HPTxt;
var TextBoxHandle MPTxt;
var TextBoxHandle MP2Txt;
var StatusBarHandle bCPBar;
var StatusBarHandle CPBar;
var StatusBarHandle HPBar;
var StatusBarHandle MPBar;

function OnLoad()
{
    Me = GetWindowHandle("AutoPotionParamWnd");
    cp = GetSliderCtrlHandle("AutoPotionParamWnd.CP");
    bCP = GetSliderCtrlHandle("AutoPotionParamWnd.bCP");
    hp = GetSliderCtrlHandle("AutoPotionParamWnd.HP");
    mp = GetSliderCtrlHandle("AutoPotionParamWnd.MP");
    MP2 = GetSliderCtrlHandle("AutoPotionParamWnd.MP2");
    CPTxt = GetTextBoxHandle("AutoPotionParamWnd.CPPercentTxt");
    bCPTxt = GetTextBoxHandle("AutoPotionParamWnd.bCPPercentTxt");
    HPTxt = GetTextBoxHandle("AutoPotionParamWnd.HPPercentTxt");
    MPTxt = GetTextBoxHandle("AutoPotionParamWnd.MPPercentTxt");
    MP2Txt = GetTextBoxHandle("AutoPotionParamWnd.MP2PercentTxt");
    bCPBar = GetStatusBarHandle("AutoPotionParamWnd.bCPBar");
    CPBar = GetStatusBarHandle("AutoPotionParamWnd.CPBar");
    HPBar = GetStatusBarHandle("AutoPotionParamWnd.HPBar");
    MPBar = GetStatusBarHandle("AutoPotionParamWnd.MPBar");
    SetClosingOnESC();
    return;
}

function OnShow()
{
    InitSliders();
    CheckForm();
    GetWindowHandle("AutoPotionInventoryViewer").ShowWindow();
    return;
}

function CheckForm()
{
    // End:0x3B
    if(false)
    {
        Me.SetWindowSize(244, 285);
        MP2.ShowWindow();
        MP2Txt.ShowWindow();        
    }
    else
    {
        Me.SetWindowSize(244, 260);
        MP2.HideWindow();
        MP2Txt.HideWindow();
    }
    return;
}

function OnHide()
{
    InitSliders();
    GetWindowHandle("AutoPotionInventoryViewer").HideWindow();
    return;
}

function OnClickButton(string a_strID)
{
    switch(a_strID)
    {
        // End:0x1F
        case "SaveButton":
            SavePercent();
            // End:0x44
            break;
        // End:0x3E
        case "btnClose":
            Me.HideWindow();
            // End:0x44
            break;
        // End:0xFFFF
        default:
            // End:0x44
            break;
            break;
    }
    return;
}

function InitSliders()
{
    cp_step = GetOptionInt(GetMyName(), "50CP_PER");
    bcp_step = GetOptionInt(GetMyName(), "200CP_PER");
    hp_step = GetOptionInt(GetMyName(), "HP_PER");
    mp_step = GetOptionInt(GetMyName(), "MP_PER");
    mp2_step = GetOptionInt(GetMyName(), "MP2_PER");
    // End:0xAA
    if(cp_step == 0)
    {
        CPTxt.SetText("Off");        
    }
    else
    {
        CPTxt.SetText(string(cp_step) $ "%");
    }
    // End:0xE7
    if(bcp_step == 0)
    {
        bCPTxt.SetText("Off");        
    }
    else
    {
        bCPTxt.SetText(string(bcp_step) $ "%");
    }
    // End:0x124
    if(hp_step == 0)
    {
        HPTxt.SetText("Off");        
    }
    else
    {
        HPTxt.SetText(string(hp_step) $ "%");
    }
    // End:0x161
    if(mp_step == 0)
    {
        MPTxt.SetText("Off");        
    }
    else
    {
        MPTxt.SetText(string(mp_step) $ "%");
    }
    // End:0x19E
    if(mp2_step == 0)
    {
        MP2Txt.SetText("Off");        
    }
    else
    {
        MP2Txt.SetText(string(mp2_step) $ "%");
    }
    CPBar.SetPoint(cp_step, 100);
    bCPBar.SetPoint(bcp_step, 100);
    HPBar.SetPoint(hp_step, 100);
    MPBar.SetPoint(mp_step, 100);
    Class'NWindow.UIAPI_SLIDERCTRL'.static.SetCurrentTick("AutoPotionParamWnd.CP", cp_step);
    Class'NWindow.UIAPI_SLIDERCTRL'.static.SetCurrentTick("AutoPotionParamWnd.bCP", bcp_step);
    Class'NWindow.UIAPI_SLIDERCTRL'.static.SetCurrentTick("AutoPotionParamWnd.HP", hp_step);
    Class'NWindow.UIAPI_SLIDERCTRL'.static.SetCurrentTick("AutoPotionParamWnd.MP", mp_step);
    Class'NWindow.UIAPI_SLIDERCTRL'.static.SetCurrentTick("AutoPotionParamWnd.MP2", mp2_step);
    return;
}

function OnModifyCurrentTickSliderCtrl(string Name, int Step)
{
    switch(Name)
    {
        // End:0x6F
        case "CP":
            cp_step = Step;
            // End:0x3B
            if(cp_step == 0)
            {
                CPTxt.SetText("Off");                
            }
            else
            {
                CPTxt.SetText(string(cp_step) $ "%");
            }
            CPBar.SetPoint(cp_step, 100);
            // End:0x200
            break;
        // End:0xD8
        case "bCP":
            bcp_step = Step;
            // End:0xA4
            if(bcp_step == 0)
            {
                bCPTxt.SetText("Off");                
            }
            else
            {
                bCPTxt.SetText(string(bcp_step) $ "%");
            }
            bCPBar.SetPoint(bcp_step, 100);
            // End:0x200
            break;
        // End:0x140
        case "HP":
            hp_step = Step;
            // End:0x10C
            if(hp_step == 0)
            {
                HPTxt.SetText("Off");                
            }
            else
            {
                HPTxt.SetText(string(hp_step) $ "%");
            }
            HPBar.SetPoint(hp_step, 100);
            // End:0x200
            break;
        // End:0x1A8
        case "MP":
            mp_step = Step;
            // End:0x174
            if(mp_step == 0)
            {
                MPTxt.SetText("Off");                
            }
            else
            {
                MPTxt.SetText(string(mp_step) $ "%");
            }
            MPBar.SetPoint(mp_step, 100);
            // End:0x200
            break;
        // End:0x1FA
        case "MP2":
            mp2_step = Step;
            // End:0x1DD
            if(mp2_step == 0)
            {
                MP2Txt.SetText("Off");                
            }
            else
            {
                MP2Txt.SetText(string(mp2_step * 5));
            }
            // End:0x200
            break;
        // End:0xFFFF
        default:
            // End:0x200
            break;
            break;
    }
    return;
}

function SavePercent()
{
    SetOptionInt(GetMyName(), "50CP_PER", cp_step);
    SetOptionInt(GetMyName(), "200CP_PER", bcp_step);
    SetOptionInt(GetMyName(), "HP_PER", hp_step);
    SetOptionInt(GetMyName(), "MP_PER", mp_step);
    SetOptionInt(GetMyName(), "MP2_PER", mp2_step);
    ini(1);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    Me.HideWindow();
    return;
}
