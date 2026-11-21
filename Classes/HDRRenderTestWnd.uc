class HDRRenderTestWnd extends UICommonAPI;

const TICK_INTERVAL = 10000.0f;

var WindowHandle Me;
var CheckBoxHandle btnUse;
var CheckBoxHandle btnPreview;
var EditBoxHandle editExposure;
var EditBoxHandle editGamma;
var EditBoxHandle editAvgLumMin;
var EditBoxHandle editAvgLumMax;
var SliderCtrlHandle sliderExposure;
var SliderCtrlHandle sliderGamma;
var SliderCtrlHandle sliderAvgLumMin;
var SliderCtrlHandle sliderAvgLumMax;
var ButtonHandle btnOk;
var ButtonHandle btnCancle;
var bool PreUseHDR;
var float PreExposure;
var float PreGamma;
var float PreAvgLumMin;
var float PreAvgLumMax;

function OnRegisterEvent()
{
    RegisterEvent(5050);
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
    Me = GetWindowHandle("HDRRenderTestWnd");
    Me.SetWindowTitle("HDR Conversion");
    btnUse = GetCheckBoxHandle("HDRRenderTestWnd.UseCheckBox");
    btnPreview = GetCheckBoxHandle("HDRRenderTestWnd.PreviewCheckBox");
    editExposure = GetEditBoxHandle("HDRRenderTestWnd.ExposureEditBox");
    editGamma = GetEditBoxHandle("HDRRenderTestWnd.GammaEditBox");
    editAvgLumMin = GetEditBoxHandle("HDRRenderTestWnd.AvgLumMinEditBox");
    editAvgLumMax = GetEditBoxHandle("HDRRenderTestWnd.AvgLumMaxEditBox");
    sliderExposure = GetSliderCtrlHandle("HDRRenderTestWnd.ExposureSliderCtrl");
    sliderGamma = GetSliderCtrlHandle("HDRRenderTestWnd.GammaSliderCtrl");
    sliderAvgLumMin = GetSliderCtrlHandle("HDRRenderTestWnd.AvgLumMinSliderCtrl");
    sliderAvgLumMax = GetSliderCtrlHandle("HDRRenderTestWnd.AvgLumMaxSliderCtrl");
    btnOk = GetButtonHandle("HDRRenderTestWnd.OkButton");
    btnCancle = GetButtonHandle("HDRRenderTestWnd.CancleButton");
    PreExposure = 0.0000000;
    PreGamma = 0.0000000;
    PreAvgLumMin = 0.0000000;
    PreAvgLumMax = 0.0000000;
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int useHDR;
    local float exposure, Gamma, avgLumMin, avgLumMax;

    // End:0xE6
    if(Event_ID == 5050)
    {
        ParseInt(param, "UseHDR", useHDR);
        ParseFloat(param, "FinalCoef", exposure);
        ParseFloat(param, "GrayLum", Gamma);
        ParseFloat(param, "ClampMin", avgLumMin);
        ParseFloat(param, "ClampMax", avgLumMax);
        InitHDRValue(bool(useHDR), exposure, Gamma, avgLumMin, avgLumMax);
        btnUse.SetCheck(true);
        btnPreview.SetCheck(true);
        Me.ShowWindow();
        SetUseHDRRenderEffect(true);
    }
    return;
}

function OnCompleteEditBox(string strID)
{
    local float Value;
    local int Tick;

    switch(strID)
    {
        // End:0x5D
        case "ExposureEditBox":
            Value = float(editExposure.GetString());
            Tick = int(Value * 10000.0000000);
            sliderExposure.SetCurrentTick(Tick);
            // End:0x161
            break;
        // End:0xB0
        case "GammaEditBox":
            Value = float(editGamma.GetString());
            Tick = int(Value * 10000.0000000);
            sliderGamma.SetCurrentTick(Tick);
            // End:0x161
            break;
        // End:0x107
        case "AvgLumMinEditBox":
            Value = float(editAvgLumMin.GetString());
            Tick = int(Value * 10000.0000000);
            sliderAvgLumMin.SetCurrentTick(Tick);
            // End:0x161
            break;
        // End:0x15E
        case "AvgLumMaxEditBox":
            Value = float(editAvgLumMax.GetString());
            Tick = int(Value * 10000.0000000);
            sliderAvgLumMax.SetCurrentTick(Tick);
            // End:0x161
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x179
    if(btnPreview.IsChecked())
    {
        ApplyHDRValue();
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x2C
        case "OkButton":
            ApplyHDRValue();
            Me.HideWindow();
            // End:0x58
            break;
        // End:0x55
        case "CancleButton":
            RestoreHDRValue();
            Me.HideWindow();
            // End:0x58
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
    local float Value;
    local string Str;

    switch(strID)
    {
        // End:0x60
        case "ExposureSliderCtrl":
            Value = float(sliderExposure.GetCurrentTick()) / 10000.0000000;
            Str = string(Value);
            editExposure.SetString(Str);
            // End:0x16D
            break;
        // End:0xB6
        case "GammaSliderCtrl":
            Value = float(sliderGamma.GetCurrentTick()) / 10000.0000000;
            Str = string(Value);
            editGamma.SetString(Str);
            // End:0x16D
            break;
        // End:0x110
        case "AvgLumMinSliderCtrl":
            Value = float(sliderAvgLumMin.GetCurrentTick()) / 10000.0000000;
            Str = string(Value);
            editAvgLumMin.SetString(Str);
            // End:0x16D
            break;
        // End:0x16A
        case "AvgLumMaxSliderCtrl":
            Value = float(sliderAvgLumMax.GetCurrentTick()) / 10000.0000000;
            Str = string(Value);
            editAvgLumMax.SetString(Str);
            // End:0x16D
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x185
    if(btnPreview.IsChecked())
    {
        ApplyHDRValue();
    }
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x2F
        case "UseCheckBox":
            SetUseHDRRenderEffect(btnUse.IsChecked());
            // End:0x32
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x4A
    if(btnPreview.IsChecked())
    {
        ApplyHDRValue();
    }
    return;
}

function RestoreHDRValue()
{
    SetUseHDRRenderEffect(PreUseHDR);
    SetHDRRenderVal(PreExposure, PreGamma, PreAvgLumMin, PreAvgLumMax);
    return;
}

function InitHDRValue(bool useHDR, float exposure, float Gamma, float avgLumMin, float avgLumMax)
{
    PreUseHDR = useHDR;
    PreExposure = exposure;
    PreGamma = Gamma;
    PreAvgLumMin = avgLumMin;
    PreAvgLumMax = avgLumMax;
    editExposure.SetString(string(PreExposure));
    editGamma.SetString(string(PreGamma));
    editAvgLumMin.SetString(string(PreAvgLumMin));
    editAvgLumMax.SetString(string(PreAvgLumMax));
    sliderExposure.SetCurrentTick(int(PreExposure * 10000.0000000));
    sliderGamma.SetCurrentTick(int(PreGamma * 10000.0000000));
    sliderAvgLumMin.SetCurrentTick(int(PreAvgLumMin * 10000.0000000));
    sliderAvgLumMax.SetCurrentTick(int(PreAvgLumMax * 10000.0000000));
    return;
}

function ApplyHDRValue()
{
    local float exposure, Gamma, avgLumMin, avgLumMax;

    exposure = float(editExposure.GetString());
    Gamma = float(editGamma.GetString());
    avgLumMin = float(editAvgLumMin.GetString());
    avgLumMax = float(editAvgLumMax.GetString());
    SetHDRRenderVal(exposure, Gamma, avgLumMin, avgLumMax);
    return;
}
