class ArmorEnchantEffectTestWnd extends UICommonAPI;

var WindowHandle Me;
var CheckBoxHandle btnUseMask;
var CheckBoxHandle btnShowEffect;
var CheckBoxHandle btnTimeAppear;
var EditBoxHandle editFadeTime;
var EditBoxHandle editShowTime;
var EditBoxHandle editHideTime;
var EditBoxHandle editColorMaxRed;
var EditBoxHandle editColorMaxGreen;
var EditBoxHandle editColorMaxBlue;
var EditBoxHandle editColorMaxAlpha;
var EditBoxHandle editColorMinRed;
var EditBoxHandle editColorMinGreen;
var EditBoxHandle editColorMinBlue;
var EditBoxHandle editColorMinAlpha;
var SliderCtrlHandle sliderColorMaxRed;
var SliderCtrlHandle sliderColorMaxGreen;
var SliderCtrlHandle sliderColorMaxBlue;
var SliderCtrlHandle sliderColorMaxAlpha;
var SliderCtrlHandle sliderColorMinRed;
var SliderCtrlHandle sliderColorMinGreen;
var SliderCtrlHandle sliderColorMinBlue;
var SliderCtrlHandle sliderColorMinAlpha;
var EditBoxHandle editNoiseScale;
var EditBoxHandle editNoisePanSpeed;
var EditBoxHandle editNoiseRate;
var EditBoxHandle editExtrudeMeshPeak;
var EditBoxHandle editExtrudeMeshSharp;
var EditBoxHandle editExtrudeMeshScale;
var ButtonHandle btnOk;
var ButtonHandle btnCancle;
var string ini;
var bool loadedINI;

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
    ini = "ArmorEnchantEffectConfig.ini";
    loadedINI = false;
    Me = GetWindowHandle("ArmorEnchantEffectTestWnd");
    Me.SetWindowTitle("Armor Enchant Effect");
    btnUseMask = GetCheckBoxHandle("ArmorEnchantEffectTestWnd.UseMaskCheckBox");
    btnShowEffect = GetCheckBoxHandle("ArmorEnchantEffectTestWnd.ShowEffectCheckBox");
    btnTimeAppear = GetCheckBoxHandle("ArmorEnchantEffectTestWnd.TimeAppearCheckBox");
    editFadeTime = GetEditBoxHandle("ArmorEnchantEffectTestWnd.FadeTimeEditBox");
    editShowTime = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ShowTimeEditBox");
    editHideTime = GetEditBoxHandle("ArmorEnchantEffectTestWnd.HideTimeEditBox");
    editColorMaxRed = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMaxRedEditBox");
    editColorMaxGreen = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMaxGreenEditBox");
    editColorMaxBlue = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMaxBlueEditBox");
    editColorMaxAlpha = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMaxAlphaEditBox");
    editColorMinRed = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMinRedEditBox");
    editColorMinGreen = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMinGreenEditBox");
    editColorMinBlue = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMinBlueEditBox");
    editColorMinAlpha = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ColorMinAlphaEditBox");
    sliderColorMaxRed = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMaxRedSliderCtrl");
    sliderColorMaxGreen = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMaxGreenSliderCtrl");
    sliderColorMaxBlue = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMaxBlueSliderCtrl");
    sliderColorMaxAlpha = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMaxAlphaSliderCtrl");
    sliderColorMinRed = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMinRedSliderCtrl");
    sliderColorMinGreen = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMinGreenSliderCtrl");
    sliderColorMinBlue = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMinBlueSliderCtrl");
    sliderColorMinAlpha = GetSliderCtrlHandle("ArmorEnchantEffectTestWnd.ColorMinAlphaSliderCtrl");
    editNoiseScale = GetEditBoxHandle("ArmorEnchantEffectTestWnd.NoiseScaleEditBox");
    editNoisePanSpeed = GetEditBoxHandle("ArmorEnchantEffectTestWnd.NoisePanSpeedEditBox");
    editNoiseRate = GetEditBoxHandle("ArmorEnchantEffectTestWnd.NoiseRateEditBox");
    editExtrudeMeshPeak = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ExtrudeMeshPeakEditBox");
    editExtrudeMeshSharp = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ExtrudeMeshSharpEditBox");
    editExtrudeMeshScale = GetEditBoxHandle("ArmorEnchantEffectTestWnd.ExtrudeMeshScaleEditBox");
    btnOk = GetButtonHandle("ArmorEnchantEffectTestWnd.OkButton");
    btnCancle = GetButtonHandle("ArmorEnchantEffectTestWnd.CancleButton");
    InitEnchantValue();
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
        // End:0x4C
        case "ColorMaxRedEditBox":
            ivalue = int(editColorMaxRed.GetString());
            sliderColorMaxRed.SetCurrentTick(ivalue);
            // End:0x23C
            break;
        // End:0x93
        case "ColorMaxGreenEditBox":
            ivalue = int(editColorMaxGreen.GetString());
            sliderColorMaxGreen.SetCurrentTick(ivalue);
            // End:0x23C
            break;
        // End:0xD9
        case "ColorMaxBlueEditBox":
            ivalue = int(editColorMaxBlue.GetString());
            sliderColorMaxBlue.SetCurrentTick(ivalue);
            // End:0x23C
            break;
        // End:0x120
        case "ColorMaxAlphaEditBox":
            ivalue = int(editColorMaxAlpha.GetString());
            sliderColorMaxAlpha.SetCurrentTick(ivalue);
            // End:0x23C
            break;
        // End:0x165
        case "ColorMinRedEditBox":
            ivalue = int(editColorMinRed.GetString());
            sliderColorMinRed.SetCurrentTick(ivalue);
            // End:0x23C
            break;
        // End:0x1AC
        case "ColorMinGreenEditBox":
            ivalue = int(editColorMinGreen.GetString());
            sliderColorMinGreen.SetCurrentTick(ivalue);
            // End:0x23C
            break;
        // End:0x1F2
        case "ColorMinBlueEditBox":
            ivalue = int(editColorMinBlue.GetString());
            sliderColorMinBlue.SetCurrentTick(ivalue);
            // End:0x23C
            break;
        // End:0x239
        case "ColorMinAlphaEditBox":
            ivalue = int(editColorMinAlpha.GetString());
            sliderColorMinAlpha.SetCurrentTick(ivalue);
            // End:0x23C
            break;
        // End:0xFFFF
        default:
            break;
    }
    ApplyEnchantValue();
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x26
        case "OkButton":
            Me.HideWindow();
            // End:0x4C
            break;
        // End:0x49
        case "CancleButton":
            Me.HideWindow();
            // End:0x4C
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
    local string Str;

    // End:0x0E
    if(loadedINI == false)
    {
        return;
    }
    switch(strID)
    {
        // End:0x68
        case "ColorMaxRedSliderCtrl":
            ivalue = sliderColorMaxRed.GetCurrentTick();
            Str = string(ivalue);
            editColorMaxRed.SetString(Str);
            // End:0x2BA
            break;
        // End:0xBD
        case "ColorMaxGreenSliderCtrl":
            ivalue = sliderColorMaxGreen.GetCurrentTick();
            Str = string(ivalue);
            editColorMaxGreen.SetString(Str);
            // End:0x2BA
            break;
        // End:0x111
        case "ColorMaxBlueSliderCtrl":
            ivalue = sliderColorMaxBlue.GetCurrentTick();
            Str = string(ivalue);
            editColorMaxBlue.SetString(Str);
            // End:0x2BA
            break;
        // End:0x166
        case "ColorMaxAlphaSliderCtrl":
            ivalue = sliderColorMaxAlpha.GetCurrentTick();
            Str = string(ivalue);
            editColorMaxAlpha.SetString(Str);
            // End:0x2BA
            break;
        // End:0x1B9
        case "ColorMinRedSliderCtrl":
            ivalue = sliderColorMinRed.GetCurrentTick();
            Str = string(ivalue);
            editColorMinRed.SetString(Str);
            // End:0x2BA
            break;
        // End:0x20E
        case "ColorMinGreenSliderCtrl":
            ivalue = sliderColorMinGreen.GetCurrentTick();
            Str = string(ivalue);
            editColorMinGreen.SetString(Str);
            // End:0x2BA
            break;
        // End:0x262
        case "ColorMinBlueSliderCtrl":
            ivalue = sliderColorMinBlue.GetCurrentTick();
            Str = string(ivalue);
            editColorMinBlue.SetString(Str);
            // End:0x2BA
            break;
        // End:0x2B7
        case "ColorMinAlphaSliderCtrl":
            ivalue = sliderColorMinAlpha.GetCurrentTick();
            Str = string(ivalue);
            editColorMinAlpha.SetString(Str);
            // End:0x2BA
            break;
        // End:0xFFFF
        default:
            break;
    }
    ApplyEnchantValue();
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x72
        case "UseMaskCheckBox":
            SetINIBool("DISPLAY", "UseMask", btnUseMask.IsChecked(), ini);
            RefreshINI(ini);
            ExecuteCommand("///ArmorEnchant apply");
            // End:0x157
            break;
        // End:0xE3
        case "ShowEffectCheckBox":
            SetINIBool("DISPLAY", "ShowEffect", btnShowEffect.IsChecked(), ini);
            RefreshINI(ini);
            ExecuteCommand("///ArmorEnchant apply");
            // End:0x157
            break;
        // End:0x154
        case "TimeAppearCheckBox":
            SetINIBool("DISPLAY", "TimeAppear", btnTimeAppear.IsChecked(), ini);
            RefreshINI(ini);
            ExecuteCommand("///ArmorEnchant apply");
            // End:0x157
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnShow()
{
    return;
}

function InitEnchantValue()
{
    local int ivalue;
    local float fvalue;

    RefreshINI(ini);
    GetINIBool("DISPLAY", "UseMask", ivalue, ini);
    btnUseMask.SetCheck(bool(ivalue));
    GetINIBool("DISPLAY", "ShowEffect", ivalue, ini);
    btnShowEffect.SetCheck(bool(ivalue));
    GetINIBool("DISPLAY", "TimeAppear", ivalue, ini);
    btnTimeAppear.SetCheck(bool(ivalue));
    GetINIFloat("DISPLAY", "FadeTime", fvalue, ini);
    editFadeTime.SetString(string(fvalue));
    GetINIFloat("DISPLAY", "ShowTime", fvalue, ini);
    editShowTime.SetString(string(fvalue));
    GetINIFloat("DISPLAY", "HideTime", fvalue, ini);
    editHideTime.SetString(string(fvalue));
    GetINIInt("Enchant0", "ColorMax_R", ivalue, ini);
    editColorMaxRed.SetString(string(ivalue));
    GetINIInt("Enchant0", "ColorMax_G", ivalue, ini);
    editColorMaxGreen.SetString(string(ivalue));
    GetINIInt("Enchant0", "ColorMax_B", ivalue, ini);
    editColorMaxBlue.SetString(string(ivalue));
    GetINIInt("Enchant0", "ColorMax_A", ivalue, ini);
    editColorMaxAlpha.SetString(string(ivalue));
    GetINIInt("Enchant0", "ColorMin_R", ivalue, ini);
    editColorMinRed.SetString(string(ivalue));
    GetINIInt("Enchant0", "ColorMin_G", ivalue, ini);
    editColorMinGreen.SetString(string(ivalue));
    GetINIInt("Enchant0", "ColorMin_B", ivalue, ini);
    editColorMinBlue.SetString(string(ivalue));
    GetINIInt("Enchant0", "ColorMin_A", ivalue, ini);
    editColorMinAlpha.SetString(string(ivalue));
    GetINIFloat("Enchant0", "NoiseScale", fvalue, ini);
    editNoiseScale.SetString(string(fvalue));
    GetINIFloat("Enchant0", "NoisePanSpeed", fvalue, ini);
    editNoisePanSpeed.SetString(string(fvalue));
    GetINIFloat("Enchant0", "NoiseRate", fvalue, ini);
    editNoiseRate.SetString(string(fvalue));
    GetINIFloat("Enchant0", "ExtrudeMeshPeak", fvalue, ini);
    editExtrudeMeshPeak.SetString(string(fvalue));
    GetINIFloat("Enchant0", "ExtrudeMeshSharp", fvalue, ini);
    editExtrudeMeshSharp.SetString(string(fvalue));
    GetINIFloat("Enchant0", "ExtrudeMeshScale", fvalue, ini);
    editExtrudeMeshScale.SetString(string(fvalue));
    ivalue = int(editColorMaxRed.GetString());
    sliderColorMaxRed.SetCurrentTick(ivalue);
    ivalue = int(editColorMaxGreen.GetString());
    sliderColorMaxGreen.SetCurrentTick(ivalue);
    ivalue = int(editColorMaxBlue.GetString());
    sliderColorMaxBlue.SetCurrentTick(ivalue);
    ivalue = int(editColorMaxAlpha.GetString());
    sliderColorMaxAlpha.SetCurrentTick(ivalue);
    ivalue = int(editColorMinRed.GetString());
    sliderColorMinRed.SetCurrentTick(ivalue);
    ivalue = int(editColorMinGreen.GetString());
    sliderColorMinGreen.SetCurrentTick(ivalue);
    ivalue = int(editColorMinBlue.GetString());
    sliderColorMinBlue.SetCurrentTick(ivalue);
    ivalue = int(editColorMinAlpha.GetString());
    sliderColorMinAlpha.SetCurrentTick(ivalue);
    loadedINI = true;
    return;
}

function ApplyEnchantValue()
{
    local float fadeTime, ShowTime, HideTime;
    local int colorMaxRed, colorMaxGreen, colorMaxBlue, colorMaxAlpha, colorMinRed, colorMinGreen,
	    colorMinBlue, colorMinAlpha;

    local float noiseScale, noisePanSpeed, noiseRate, extrudeMeshPeak, extrudeMeshSharp, extrudeMeshScale;

    // End:0x0E
    if(loadedINI == false)
    {
        return;
    }
    fadeTime = float(editFadeTime.GetString());
    ShowTime = float(editShowTime.GetString());
    HideTime = float(editHideTime.GetString());
    colorMaxRed = int(editColorMaxRed.GetString());
    colorMaxGreen = int(editColorMaxGreen.GetString());
    colorMaxBlue = int(editColorMaxBlue.GetString());
    colorMaxAlpha = int(editColorMaxAlpha.GetString());
    colorMinRed = int(editColorMinRed.GetString());
    colorMinGreen = int(editColorMinGreen.GetString());
    colorMinBlue = int(editColorMinBlue.GetString());
    colorMinAlpha = int(editColorMinAlpha.GetString());
    noiseScale = float(editNoiseScale.GetString());
    noisePanSpeed = float(editNoisePanSpeed.GetString());
    noiseRate = float(editNoiseRate.GetString());
    extrudeMeshPeak = float(editExtrudeMeshPeak.GetString());
    extrudeMeshSharp = float(editExtrudeMeshSharp.GetString());
    extrudeMeshScale = float(editExtrudeMeshScale.GetString());
    SetINIFloat("DISPLAY", "FadeTime", fadeTime, ini);
    SetINIFloat("DISPLAY", "ShowTime", ShowTime, ini);
    SetINIFloat("DISPLAY", "HideTime", HideTime, ini);
    SetINIInt("Enchant0", "ColorMax_R", colorMaxRed, ini);
    SetINIInt("Enchant0", "ColorMax_G", colorMaxGreen, ini);
    SetINIInt("Enchant0", "ColorMax_B", colorMaxBlue, ini);
    SetINIInt("Enchant0", "ColorMax_A", colorMaxAlpha, ini);
    SetINIInt("Enchant0", "ColorMin_R", colorMinRed, ini);
    SetINIInt("Enchant0", "ColorMin_G", colorMinGreen, ini);
    SetINIInt("Enchant0", "ColorMin_B", colorMinBlue, ini);
    SetINIInt("Enchant0", "ColorMin_A", colorMinAlpha, ini);
    SetINIFloat("Enchant0", "NoiseScale", noiseScale, ini);
    SetINIFloat("Enchant0", "NoisePanSpeed", noisePanSpeed, ini);
    SetINIFloat("Enchant0", "NoiseRate", noiseRate, ini);
    SetINIFloat("Enchant0", "ExtrudeMeshPeak", extrudeMeshPeak, ini);
    SetINIFloat("Enchant0", "ExtrudeMeshSharp", extrudeMeshSharp, ini);
    SetINIFloat("Enchant0", "ExtrudeMeshScale", extrudeMeshScale, ini);
    RefreshINI(ini);
    ExecuteCommand("///ArmorEnchant apply");
    return;
}
