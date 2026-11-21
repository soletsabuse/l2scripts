class ErtheiaTestWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle armorEnchantWindowHandle;
var ButtonHandle btnHide;
var ButtonHandle btnShowEdgeEffectWnd;
var EditBoxHandle editBlendingTime;
var EditBoxHandle editAlpha;
var EditBoxHandle editGray;
var SliderCtrlHandle sliderAlpha;
var SliderCtrlHandle sliderGray;
var EditBoxHandle editOffsetPercentage;
var SliderCtrlHandle sliderOffsetPercentage;
var EditBoxHandle editFistScale;
var SliderCtrlHandle sliderFistScale;
var ButtonHandle btnApply;
var ButtonHandle btnCancel;
var string ini;
var bool loadedINI;
var bool bHidden;
var string sectionEdgeEffect;
var string sectionWeapon;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    Initialize();
    return;
}

function Initialize()
{
    ini = "ErtheiaTestConfig.ini";
    loadedINI = false;
    bHidden = false;
    sectionEdgeEffect = "EdgeEffect";
    sectionWeapon = "Weapon";
    Me = GetWindowHandle("ErtheiaTestWnd");
    Me.SetWindowTitle("Ertheia Test");
    armorEnchantWindowHandle = GetWindowHandle("ArmorEnchantEffectTestWnd");
    btnHide = GetButtonHandle("ErtheiaTestWnd.ButtonHide");
    btnShowEdgeEffectWnd = GetButtonHandle("ErtheiaTestWnd.ButtonShowEdgeEffectWnd");
    editBlendingTime = GetEditBoxHandle("ErtheiaTestWnd.EditBoxBlendingTime");
    editAlpha = GetEditBoxHandle("ErtheiaTestWnd.EditBoxAlpha");
    editGray = GetEditBoxHandle("ErtheiaTestWnd.EditBoxGray");
    sliderAlpha = GetSliderCtrlHandle("ErtheiaTestWnd.SliderCtrlAlpha");
    sliderGray = GetSliderCtrlHandle("ErtheiaTestWnd.SliderCtrlGray");
    editOffsetPercentage = GetEditBoxHandle("ErtheiaTestWnd.EditBoxOffsetPercentage");
    sliderOffsetPercentage = GetSliderCtrlHandle("ErtheiaTestWnd.SliderCtrlOffsetPercentage");
    editFistScale = GetEditBoxHandle("ErtheiaTestWnd.EditBoxFistScale");
    sliderFistScale = GetSliderCtrlHandle("ErtheiaTestWnd.SliderCtrlFistScale");
    btnApply = GetButtonHandle("ErtheiaTestWnd.ApplyButton");
    btnCancel = GetButtonHandle("ErtheiaTestWnd.CancelButton");
    initValue();
    return;
}

function OnEvent(int Event_ID, string param)
{
    return;
}

function OnCompleteEditBox(string strID)
{
    local int ivalue;

    switch(strID)
    {
        // End:0x46
        case "EditBoxAlpha":
            ivalue = int(editAlpha.GetString());
            sliderAlpha.SetCurrentTick(ivalue);
            // End:0x11C
            break;
        // End:0x84
        case "EditBoxGray":
            ivalue = int(editGray.GetString());
            sliderGray.SetCurrentTick(ivalue);
            // End:0x11C
            break;
        // End:0xCE
        case "EditBoxOffsetPercentage":
            ivalue = int(editOffsetPercentage.GetString());
            sliderOffsetPercentage.SetCurrentTick(ivalue);
            // End:0x11C
            break;
        // End:0x119
        case "EditBoxFistScale":
            ivalue = int(float(editFistScale.GetString()) * float(100));
            sliderFistScale.SetCurrentTick(ivalue);
            // End:0x11C
            break;
        // End:0xFFFF
        default:
            break;
    }
    ApplyValue();
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x90
        case "ButtonHide":
            // End:0x55
            if(bHidden)
            {
                bHidden = false;
                btnHide.SetNameText("은신");
                ExecuteCommand("///da type=116");                
            }
            else
            {
                bHidden = true;
                btnHide.SetNameText("은신 해제");
                ExecuteCommand("///aa type=116");
            }
            // End:0x121
            break;
        // End:0xE2
        case "ButtonShowEdgeEffectWnd":
            // End:0xD0
            if(armorEnchantWindowHandle.IsShowWindow())
            {
                armorEnchantWindowHandle.HideWindow();                
            }
            else
            {
                armorEnchantWindowHandle.ShowWindow();
            }
            // End:0x121
            break;
        // End:0xFB
        case "ApplyButton":
            ApplyValue();
            // End:0x121
            break;
        // End:0x11E
        case "CancelButton":
            Me.HideWindow();
            // End:0x121
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
    local int ivalue;
    local float fvalue;
    local string Str;

    // End:0x0E
    if(loadedINI == false)
    {
        return;
    }
    switch(strID)
    {
        // End:0x62
        case "SliderCtrlAlpha":
            ivalue = sliderAlpha.GetCurrentTick();
            Str = string(ivalue);
            editAlpha.SetString(Str);
            // End:0x163
            break;
        // End:0xAE
        case "SliderCtrlGray":
            ivalue = sliderGray.GetCurrentTick();
            Str = string(ivalue);
            editGray.SetString(Str);
            // End:0x163
            break;
        // End:0x106
        case "SliderCtrlOffsetPercentage":
            ivalue = sliderOffsetPercentage.GetCurrentTick();
            Str = string(ivalue);
            editOffsetPercentage.SetString(Str);
            // End:0x163
            break;
        // End:0x160
        case "SliderCtrlFistScale":
            fvalue = float(sliderFistScale.GetCurrentTick()) / 100.0000000;
            Str = string(fvalue);
            editFistScale.SetString(Str);
            // End:0x163
            break;
        // End:0xFFFF
        default:
            break;
    }
    ApplyValue();
    return;
}

function OnShow()
{
    return;
}

function initValue()
{
    local int ivalue;
    local float fvalue;

    RefreshINI(ini);
    GetINIFloat(sectionEdgeEffect, "BlendingTime", fvalue, ini);
    editBlendingTime.SetString(string(fvalue));
    GetINIInt(sectionEdgeEffect, "Alpha", ivalue, ini);
    editAlpha.SetString(string(ivalue));
    GetINIInt(sectionEdgeEffect, "Gray", ivalue, ini);
    editGray.SetString(string(ivalue));
    ivalue = int(editAlpha.GetString());
    sliderAlpha.SetCurrentTick(ivalue);
    ivalue = int(editGray.GetString());
    sliderGray.SetCurrentTick(ivalue);
    // End:0x131
    if(!GetINIInt(sectionWeapon, "OffsetPercentage", ivalue, ini))
    {
        ivalue = 45;
    }
    editOffsetPercentage.SetString(string(ivalue));
    ivalue = int(editOffsetPercentage.GetString());
    sliderOffsetPercentage.SetCurrentTick(ivalue);
    // End:0x1A2
    if(!GetINIFloat(sectionWeapon, "FistScale", fvalue, ini))
    {
        fvalue = 1.0000000;
    }
    editFistScale.SetString(string(fvalue));
    ivalue = int(float(editFistScale.GetString()) * float(100));
    sliderFistScale.SetCurrentTick(ivalue);
    loadedINI = true;
    return;
}

function ApplyValue()
{
    local float BlendingTime;
    local int alphavalue, grayValue, staffOffsetPercentage;
    local float fistScale;

    // End:0x0E
    if(loadedINI == false)
    {
        return;
    }
    BlendingTime = float(editBlendingTime.GetString());
    alphavalue = int(editAlpha.GetString());
    grayValue = int(editGray.GetString());
    staffOffsetPercentage = int(editOffsetPercentage.GetString());
    fistScale = float(editFistScale.GetString());
    SetINIFloat(sectionEdgeEffect, "BlendingTime", BlendingTime, ini);
    SetINIInt(sectionEdgeEffect, "Alpha", alphavalue, ini);
    SetINIInt(sectionEdgeEffect, "Gray", grayValue, ini);
    SetINIInt(sectionWeapon, "OffsetPercentage", staffOffsetPercentage, ini);
    SetINIFloat(sectionWeapon, "FistScale", fistScale, ini);
    RefreshINI(ini);
    return;
}
