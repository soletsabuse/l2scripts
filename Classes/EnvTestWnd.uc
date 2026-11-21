class EnvTestWnd extends UICommonAPI;

const TICK_INTERVAL = 200.0f;

var WindowHandle Me;
var SliderCtrlHandle sliderTerrainAmbR;
var SliderCtrlHandle sliderTerrainAmbG;
var SliderCtrlHandle sliderTerrainAmbB;
var SliderCtrlHandle sliderStaticMeshAmbR;
var SliderCtrlHandle sliderStaticMeshAmbG;
var SliderCtrlHandle sliderStaticMeshAmbB;
var SliderCtrlHandle sliderBspAmbR;
var SliderCtrlHandle sliderBspAmbG;
var SliderCtrlHandle sliderBspAmbB;
var SliderCtrlHandle sliderActorAmbR;
var SliderCtrlHandle sliderActorAmbG;
var SliderCtrlHandle sliderActorAmbB;
var SliderCtrlHandle sliderSkyBoxColorR;
var SliderCtrlHandle sliderSkyBoxColorG;
var SliderCtrlHandle sliderSkyBoxColorB;
var SliderCtrlHandle sliderSkyBspAmbR;
var SliderCtrlHandle sliderSkyBspAmbG;
var SliderCtrlHandle sliderSkyBspAmbB;
var SliderCtrlHandle sliderGodRaySize;
var SliderCtrlHandle sliderGodRayBrightness;
var SliderCtrlHandle sliderGodRayEmit;
var SliderCtrlHandle sliderHsvActorLightHue;
var SliderCtrlHandle sliderHsvActorLightSat;
var SliderCtrlHandle sliderHsvActorLightBri;
var SliderCtrlHandle sliderHsvStaticMeshLightHue;
var SliderCtrlHandle sliderHsvStaticMeshLightSat;
var SliderCtrlHandle sliderHsvStaticMeshLightBri;
var SliderCtrlHandle sliderHsvTerrainLightHue;
var SliderCtrlHandle sliderHsvTerrainLightSat;
var SliderCtrlHandle sliderHsvTerrainLightBri;
var SliderCtrlHandle sliderGammaSettingContrast;
var SliderCtrlHandle sliderGammaSettingBrightness;
var SliderCtrlHandle sliderGammaSettingGamma;
var TextBoxHandle txtTerrainAmb;
var TextBoxHandle txtStaticMeshAmb;
var TextBoxHandle txtBspAmb;
var TextBoxHandle txtActorAmb;
var TextBoxHandle txtSkyBoxColor;
var TextBoxHandle txtSkyBspAmb;
var TextBoxHandle txtGodRay;
var TextBoxHandle txtHsvActorLight;
var TextBoxHandle txtHsvStaticMeshLight;
var TextBoxHandle txtHsvTerrainLight;
var TextBoxHandle txtGammaSetting;
var CheckBoxHandle checkBoxTerrainAmb;
var CheckBoxHandle checkBoxStaticMeshAmb;
var CheckBoxHandle checkBoxBspAmb;
var CheckBoxHandle checkBoxActorAmb;
var CheckBoxHandle checkBoxSkyBoxColor;
var CheckBoxHandle checkBoxSkyBspAmb;
var CheckBoxHandle checkBoxGodRay;
var CheckBoxHandle checkHsvActorLight;
var CheckBoxHandle checkHsvStaticMeshLight;
var CheckBoxHandle checkHsvTerrainLight;
var CheckBoxHandle checkBoxGammaSetting;
var CheckBoxHandle checkBoxWindowDefaultGamma;
var CheckBoxHandle checkBoxGammaCorrection;
var Color terrainAmbColor;
var Color staticMeshAmbColor;
var Color bspAmbColor;
var Color actorAmbColor;
var Color skyBoxColor;
var Color skyBspAmbColor;
var Color HsvActorLightColor;
var Color HsvStaticMeshLightColor;
var Color HsvTerrainLightColor;
var SliderCtrlHandle sliderLightMapIntensity;
var SliderCtrlHandle sliderLightMapIntensity2;
var TextBoxHandle txtLightMapIntensity;
var TextBoxHandle txtLightMapIntensity2;
var float LightMapIntensity;
var float LightMapIntensity2;
var CheckBoxHandle checkBoxLightMapIntensity;
var CheckBoxHandle checkBoxLightMapIntensity2;
var float GodRaySize;
var float GodRayBrightness;
var float GodRayEmit;
var float GammaCorrectionBrightness;
var float GammaCorrectionContrast;
var float GammaCorrectionGamma;
var SliderCtrlHandle sliderSetTime;
var TextBoxHandle txtSetTime;
var CheckBoxHandle checkBoxSetTime;

function OnRegisterEvent()
{
    RegisterEvent(9250);
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
    Me = GetWindowHandle("EnvTestWnd");
    Me.SetWindowTitle("Env Test");
    sliderTerrainAmbR = GetSliderCtrlHandle("EnvTestWnd.TerrainAmbRSliderCtrl");
    sliderTerrainAmbG = GetSliderCtrlHandle("EnvTestWnd.TerrainAmbGSliderCtrl");
    sliderTerrainAmbB = GetSliderCtrlHandle("EnvTestWnd.TerrainAmbBSliderCtrl");
    sliderStaticMeshAmbR = GetSliderCtrlHandle("EnvTestWnd.StaticMeshAmbRSliderCtrl");
    sliderStaticMeshAmbG = GetSliderCtrlHandle("EnvTestWnd.StaticMeshAmbGSliderCtrl");
    sliderStaticMeshAmbB = GetSliderCtrlHandle("EnvTestWnd.StaticMeshAmbBSliderCtrl");
    sliderBspAmbR = GetSliderCtrlHandle("EnvTestWnd.BspAmbRSliderCtrl");
    sliderBspAmbG = GetSliderCtrlHandle("EnvTestWnd.BspAmbGSliderCtrl");
    sliderBspAmbB = GetSliderCtrlHandle("EnvTestWnd.BspAmbBSliderCtrl");
    sliderActorAmbR = GetSliderCtrlHandle("EnvTestWnd.ActorAmbRSliderCtrl");
    sliderActorAmbG = GetSliderCtrlHandle("EnvTestWnd.ActorAmbGSliderCtrl");
    sliderActorAmbB = GetSliderCtrlHandle("EnvTestWnd.ActorAmbBSliderCtrl");
    sliderSkyBoxColorR = GetSliderCtrlHandle("EnvTestWnd.SkyBoxColorRSliderCtrl");
    sliderSkyBoxColorG = GetSliderCtrlHandle("EnvTestWnd.SkyBoxColorGSliderCtrl");
    sliderSkyBoxColorB = GetSliderCtrlHandle("EnvTestWnd.SkyBoxColorBSliderCtrl");
    sliderSkyBspAmbR = GetSliderCtrlHandle("EnvTestWnd.SkyBspAmbRSliderCtrl");
    sliderSkyBspAmbG = GetSliderCtrlHandle("EnvTestWnd.SkyBspAmbGSliderCtrl");
    sliderSkyBspAmbB = GetSliderCtrlHandle("EnvTestWnd.SkyBspAmbBSliderCtrl");
    sliderGodRaySize = GetSliderCtrlHandle("EnvTestWnd.GodRaySizeSliderCtrl");
    sliderGodRayBrightness = GetSliderCtrlHandle("EnvTestWnd.GodRayBrightnessSliderCtrl");
    sliderGodRayEmit = GetSliderCtrlHandle("EnvTestWnd.GodRayEmitSliderCtrl");
    sliderHsvActorLightHue = GetSliderCtrlHandle("EnvTestWnd.HSVActorLightHueSliderCtrl");
    sliderHsvActorLightSat = GetSliderCtrlHandle("EnvTestWnd.HSVActorLightSatSliderCtrl");
    sliderHsvActorLightBri = GetSliderCtrlHandle("EnvTestWnd.HSVActorLightBriSliderCtrl");
    sliderHsvStaticMeshLightHue = GetSliderCtrlHandle("EnvTestWnd.HSVStaticMeshLightHueSliderCtrl");
    sliderHsvStaticMeshLightSat = GetSliderCtrlHandle("EnvTestWnd.HSVStaticMeshLightSatSliderCtrl");
    sliderHsvStaticMeshLightBri = GetSliderCtrlHandle("EnvTestWnd.HSVStaticMeshLightBriSliderCtrl");
    sliderHsvTerrainLightHue = GetSliderCtrlHandle("EnvTestWnd.HSVTerrainLightHueSliderCtrl");
    sliderHsvTerrainLightSat = GetSliderCtrlHandle("EnvTestWnd.HSVTerrainLightSatSliderCtrl");
    sliderHsvTerrainLightBri = GetSliderCtrlHandle("EnvTestWnd.HSVTerrainLightBriSliderCtrl");
    sliderGammaSettingContrast = GetSliderCtrlHandle("EnvTestWnd.GammaSettingContrastSliderCtrl");
    sliderGammaSettingBrightness = GetSliderCtrlHandle("EnvTestWnd.GammaSettingBrightnessSliderCtrl");
    sliderGammaSettingGamma = GetSliderCtrlHandle("EnvTestWnd.GammaSettingGammaSliderCtrl");
    txtTerrainAmb = GetTextBoxHandle("EnvTestWnd.TerrainAmbTextBox");
    txtStaticMeshAmb = GetTextBoxHandle("EnvTestWnd.StaticMeshAmbTextBox");
    txtBspAmb = GetTextBoxHandle("EnvTestWnd.BspAmbTextBox");
    txtActorAmb = GetTextBoxHandle("EnvTestWnd.ActorAmbTextBox");
    txtSkyBoxColor = GetTextBoxHandle("EnvTestWnd.SkyBoxColorTextBox");
    txtSkyBspAmb = GetTextBoxHandle("EnvTestWnd.SkyBspAmbTextBox");
    txtGodRay = GetTextBoxHandle("EnvTestWnd.GodRayTextBox");
    txtHsvActorLight = GetTextBoxHandle("EnvTestWnd.HSVActorLightTextBox");
    txtHsvStaticMeshLight = GetTextBoxHandle("EnvTestWnd.HSVStaticMeshLightTextBox");
    txtHsvTerrainLight = GetTextBoxHandle("EnvTestWnd.HSVTerrainLightTextBox");
    txtGammaSetting = GetTextBoxHandle("EnvTestWnd.GammaTextBox");
    checkBoxTerrainAmb = GetCheckBoxHandle("EnvTestWnd.EnableTerrainAmbientCheckBox");
    checkBoxStaticMeshAmb = GetCheckBoxHandle("EnvTestWnd.EnableStaticMeshAmbientCheckBox");
    checkBoxBspAmb = GetCheckBoxHandle("EnvTestWnd.EnableBspAmbientCheckBox");
    checkBoxActorAmb = GetCheckBoxHandle("EnvTestWnd.EnableActorAmbientCheckBox");
    checkBoxSkyBoxColor = GetCheckBoxHandle("EnvTestWnd.EnableSkyBoxColorCheckBox");
    checkBoxSkyBspAmb = GetCheckBoxHandle("EnvTestWnd.EnableSkyBspAmbCheckBox");
    checkHsvActorLight = GetCheckBoxHandle("EnvTestWnd.HSVActorLightCheckBox");
    checkHsvStaticMeshLight = GetCheckBoxHandle("EnvTestWnd.HSVStaticMeshLightCheckBox");
    checkHsvTerrainLight = GetCheckBoxHandle("EnvTestWnd.HSVTerrainLightCheckBox");
    checkBoxGammaSetting = GetCheckBoxHandle("EnvTestWnd.CheckBoxGammaSetting");
    checkBoxWindowDefaultGamma = GetCheckBoxHandle("EnvTestWnd.checkBoxWindowDefaultGamma");
    checkBoxGammaCorrection = GetCheckBoxHandle("EnvTestWnd.checkBoxGammaCorrection");
    sliderLightMapIntensity = GetSliderCtrlHandle("EnvTestWnd.sliderLightMapIntensity");
    txtLightMapIntensity = GetTextBoxHandle("EnvTestWnd.txtLightMapIntensity");
    LightMapIntensity = 1.0000000;
    sliderLightMapIntensity2 = GetSliderCtrlHandle("EnvTestWnd.sliderLightMapIntensity2");
    txtLightMapIntensity2 = GetTextBoxHandle("EnvTestWnd.txtLightMapIntensity2");
    LightMapIntensity2 = 1.0000000;
    checkBoxLightMapIntensity = GetCheckBoxHandle("EnvTestWnd.checkBoxLightMapIntensity");
    checkBoxLightMapIntensity2 = GetCheckBoxHandle("EnvTestWnd.checkBoxLightMapIntensity2");
    checkBoxGodRay = GetCheckBoxHandle("EnvTestWnd.CheckBoxGodRay");
    sliderSetTime = GetSliderCtrlHandle("EnvTestWnd.sliderSetTime");
    txtSetTime = GetTextBoxHandle("EnvTestWnd.txtSetTime");
    checkBoxSetTime = GetCheckBoxHandle("EnvTestWnd.checkBoxSetTime");
    GodRaySize = 1.0000000;
    GodRayBrightness = 1.0000000;
    GodRayEmit = 2.5000000;
    GammaCorrectionBrightness = 0.5000000;
    GammaCorrectionContrast = 0.5000000;
    GammaCorrectionGamma = 1.0000000;
    return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
    local string Str;
    local float ftime;

    switch(strID)
    {
        // End:0x21
        case "TerrainAmbRSliderCtrl":
        // End:0x3B
        case "TerrainAmbGSliderCtrl":
        // End:0x10C
        case "TerrainAmbBSliderCtrl":
            terrainAmbColor.R = byte(sliderTerrainAmbR.GetCurrentTick());
            terrainAmbColor.G = byte(sliderTerrainAmbG.GetCurrentTick());
            terrainAmbColor.B = byte(sliderTerrainAmbB.GetCurrentTick());
            txtTerrainAmb.SetText((((((("R:" $ string(terrainAmbColor.R)) $ "\\n") $ "G:") $ string(terrainAmbColor.G)) $ "\\n") $ "B:") $ string(terrainAmbColor.B));
            SetTestTerrainAmbientColor(terrainAmbColor);
            // End:0xD14
            break;
        // End:0x129
        case "StaticMeshAmbRSliderCtrl":
        // End:0x146
        case "StaticMeshAmbGSliderCtrl":
        // End:0x21A
        case "StaticMeshAmbBSliderCtrl":
            staticMeshAmbColor.R = byte(sliderStaticMeshAmbR.GetCurrentTick());
            staticMeshAmbColor.G = byte(sliderStaticMeshAmbG.GetCurrentTick());
            staticMeshAmbColor.B = byte(sliderStaticMeshAmbB.GetCurrentTick());
            txtStaticMeshAmb.SetText((((((("R:" $ string(staticMeshAmbColor.R)) $ "\\n") $ "G:") $ string(staticMeshAmbColor.G)) $ "\\n") $ "B:") $ string(staticMeshAmbColor.B));
            SetTestStaticMeshAmbientColor(staticMeshAmbColor);
            // End:0xD14
            break;
        // End:0x230
        case "BspAmbRSliderCtrl":
        // End:0x246
        case "BspAmbGSliderCtrl":
        // End:0x313
        case "BspAmbBSliderCtrl":
            bspAmbColor.R = byte(sliderBspAmbR.GetCurrentTick());
            bspAmbColor.G = byte(sliderBspAmbG.GetCurrentTick());
            bspAmbColor.B = byte(sliderBspAmbB.GetCurrentTick());
            txtBspAmb.SetText((((((("R:" $ string(bspAmbColor.R)) $ "\\n") $ "G:") $ string(bspAmbColor.G)) $ "\\n") $ "B:") $ string(bspAmbColor.B));
            SetTestBspAmbientColor(bspAmbColor);
            // End:0xD14
            break;
        // End:0x32B
        case "ActorAmbRSliderCtrl":
        // End:0x343
        case "ActorAmbGSliderCtrl":
        // End:0x412
        case "ActorAmbBSliderCtrl":
            actorAmbColor.R = byte(sliderActorAmbR.GetCurrentTick());
            actorAmbColor.G = byte(sliderActorAmbG.GetCurrentTick());
            actorAmbColor.B = byte(sliderActorAmbB.GetCurrentTick());
            txtActorAmb.SetText((((((("R:" $ string(actorAmbColor.R)) $ "\\n") $ "G:") $ string(actorAmbColor.G)) $ "\\n") $ "B:") $ string(actorAmbColor.B));
            SetTestActorAmbientColor(actorAmbColor);
            // End:0xD14
            break;
        // End:0x42D
        case "SkyBoxColorRSliderCtrl":
        // End:0x448
        case "SkyBoxColorGSliderCtrl":
        // End:0x51A
        case "SkyBoxColorBSliderCtrl":
            skyBoxColor.R = byte(sliderSkyBoxColorR.GetCurrentTick());
            skyBoxColor.G = byte(sliderSkyBoxColorG.GetCurrentTick());
            skyBoxColor.B = byte(sliderSkyBoxColorB.GetCurrentTick());
            txtSkyBoxColor.SetText((((((("R:" $ string(skyBoxColor.R)) $ "\\n") $ "G:") $ string(skyBoxColor.G)) $ "\\n") $ "B:") $ string(skyBoxColor.B));
            SetTestSkyBoxColor(skyBoxColor);
            // End:0xD14
            break;
        // End:0x533
        case "SkyBspAmbRSliderCtrl":
        // End:0x54C
        case "SkyBspAmbGSliderCtrl":
        // End:0x61C
        case "SkyBspAmbBSliderCtrl":
            skyBspAmbColor.R = byte(sliderSkyBspAmbR.GetCurrentTick());
            skyBspAmbColor.G = byte(sliderSkyBspAmbG.GetCurrentTick());
            skyBspAmbColor.B = byte(sliderSkyBspAmbB.GetCurrentTick());
            txtSkyBspAmb.SetText((((((("R:" $ string(skyBspAmbColor.R)) $ "\\n") $ "G:") $ string(skyBspAmbColor.G)) $ "\\n") $ "B:") $ string(skyBspAmbColor.B));
            SetTestSkyBspAmbientColor(skyBspAmbColor);
            // End:0xD14
            break;
        // End:0x635
        case "GodRaySizeSliderCtrl":
        // End:0x654
        case "GodRayBrightnessSliderCtrl":
        // End:0x74D
        case "GodRayEmitSliderCtrl":
            GodRaySize = (float(sliderGodRaySize.GetCurrentTick()) / 200.0000000) + 0.1000000;
            GodRayBrightness = (float(sliderGodRayBrightness.GetCurrentTick()) / 200.0000000) + 0.1000000;
            GodRayEmit = (float(sliderGodRayEmit.GetCurrentTick()) / 200.0000000) + 0.1000000;
            txtGodRay.SetText((((((("SunSize :" $ string(GodRaySize)) $ "\\n") $ "Brightness:") $ string(GodRayBrightness)) $ "\\n") $ "Emit:") $ string(GodRayEmit));
            SetTestGodRayOption(GodRaySize, GodRayBrightness, GodRayEmit);
            // End:0xD14
            break;
        // End:0x769
        case "sliderLightMapIntensity":
        // End:0x823
        case "sliderLightMapIntensity2":
            LightMapIntensity = float(sliderLightMapIntensity.GetCurrentTick()) / 200.0000000;
            Str = string(LightMapIntensity);
            txtLightMapIntensity.SetText(Str @ "배");
            LightMapIntensity2 = float(sliderLightMapIntensity2.GetCurrentTick()) / 200.0000000;
            Str = string(LightMapIntensity2);
            txtLightMapIntensity2.SetText(Str @ "배");
            SetTestBeastLightMapIntensity(LightMapIntensity, LightMapIntensity2);
            // End:0xD14
            break;
        // End:0x890
        case "sliderSetTime":
            // End:0x88D
            if(checkBoxSetTime.IsChecked())
            {
                ftime = float(sliderSetTime.GetCurrentTick()) / 10.0000000;
                SetEnvTime(ftime);
                txtSetTime.SetText(string(ftime) @ " 시");
            }
            // End:0xD14
            break;
        // End:0x8AF
        case "HSVActorLightHueSliderCtrl":
        // End:0x8CE
        case "HSVActorLightSatSliderCtrl":
        // End:0x9A4
        case "HSVActorLightBriSliderCtrl":
            HsvActorLightColor.R = byte(sliderHsvActorLightHue.GetCurrentTick());
            HsvActorLightColor.G = byte(sliderHsvActorLightSat.GetCurrentTick());
            HsvActorLightColor.B = byte(sliderHsvActorLightBri.GetCurrentTick());
            txtHsvActorLight.SetText((((((("H:" $ string(HsvActorLightColor.R)) $ "\\n") $ "S:") $ string(HsvActorLightColor.G)) $ "\\n") $ "V:") $ string(HsvActorLightColor.B));
            SetTestHsvActorLightColor(HsvActorLightColor);
            // End:0xD14
            break;
        // End:0x9C8
        case "HSVStaticMeshLightHueSliderCtrl":
        // End:0x9EC
        case "HSVStaticMeshLightSatSliderCtrl":
        // End:0xAC7
        case "HSVStaticMeshLightBriSliderCtrl":
            HsvStaticMeshLightColor.R = byte(sliderHsvStaticMeshLightHue.GetCurrentTick());
            HsvStaticMeshLightColor.G = byte(sliderHsvStaticMeshLightSat.GetCurrentTick());
            HsvStaticMeshLightColor.B = byte(sliderHsvStaticMeshLightBri.GetCurrentTick());
            txtHsvStaticMeshLight.SetText((((((("H:" $ string(HsvStaticMeshLightColor.R)) $ "\\n") $ "S:") $ string(HsvStaticMeshLightColor.G)) $ "\\n") $ "V:") $ string(HsvStaticMeshLightColor.B));
            SetTestHsvStaticMeshLightColor(HsvStaticMeshLightColor);
            // End:0xD14
            break;
        // End:0xAE8
        case "HSVTerrainLightHueSliderCtrl":
        // End:0xB09
        case "HSVTerrainLightSatSliderCtrl":
        // End:0xBE1
        case "HSVTerrainLightBriSliderCtrl":
            HsvTerrainLightColor.R = byte(sliderHsvTerrainLightHue.GetCurrentTick());
            HsvTerrainLightColor.G = byte(sliderHsvTerrainLightSat.GetCurrentTick());
            HsvTerrainLightColor.B = byte(sliderHsvTerrainLightBri.GetCurrentTick());
            txtHsvTerrainLight.SetText((((((("H:" $ string(HsvTerrainLightColor.R)) $ "\\n") $ "S:") $ string(HsvTerrainLightColor.G)) $ "\\n") $ "V:") $ string(HsvTerrainLightColor.B));
            SetTestHsvTerrainLightColor(HsvTerrainLightColor);
            // End:0xD14
            break;
        // End:0xC04
        case "GammaSettingContrastSliderCtrl":
        // End:0xC29
        case "GammaSettingBrightnessSliderCtrl":
        // End:0xD11
        case "GammaSettingGammaSliderCtrl":
            GammaCorrectionBrightness = float(sliderGammaSettingBrightness.GetCurrentTick()) / 256.0000000;
            GammaCorrectionContrast = float(sliderGammaSettingContrast.GetCurrentTick()) / 128.0000000;
            GammaCorrectionGamma = (float(sliderGammaSettingGamma.GetCurrentTick()) / 128.0000000) + 0.5000000;
            txtGammaSetting.SetText((((((("대비:" $ string(GammaCorrectionContrast)) $ "\\n") $ "밝기:") $ string(GammaCorrectionBrightness)) $ "\\n") $ "감마:") $ string(GammaCorrectionGamma));
            SetTestGammaSetting(GammaCorrectionBrightness, GammaCorrectionContrast, GammaCorrectionGamma);
            // End:0xD14
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickCheckBox(string strID)
{
    // End:0x40
    if(strID == "EnableTerrainAmbientCheckBox")
    {
        SetEnableTerrainAmbient(checkBoxTerrainAmb.IsChecked());        
    }
    else
    {
        // End:0x83
        if(strID == "EnableStaticMeshAmbientCheckBox")
        {
            SetEnableStaticMeshAmbient(checkBoxStaticMeshAmb.IsChecked());            
        }
        else
        {
            // End:0xBF
            if(strID == "EnableBspAmbientCheckBox")
            {
                SetEnableBspAmbient(checkBoxBspAmb.IsChecked());                
            }
            else
            {
                // End:0xFD
                if(strID == "EnableActorAmbientCheckBox")
                {
                    SetEnableActorAmbient(checkBoxActorAmb.IsChecked());                    
                }
                else
                {
                    // End:0x13A
                    if(strID == "EnableSkyBoxColorCheckBox")
                    {
                        SetEnableSkyBoxColor(checkBoxSkyBoxColor.IsChecked());                        
                    }
                    else
                    {
                        // End:0x175
                        if(strID == "EnableSkyBspAmbCheckBox")
                        {
                            SetEnableSkyBspAmbient(checkBoxSkyBspAmb.IsChecked());                            
                        }
                        else
                        {
                            // End:0x1B2
                            if(strID == "checkBoxLightMapIntensity")
                            {
                                SetEnableLightMapIntensity(checkBoxLightMapIntensity.IsChecked());                                
                            }
                            else
                            {
                                // End:0x1E4
                                if(strID == "checkBoxGodRay")
                                {
                                    SetEnableGodRay(checkBoxGodRay.IsChecked());                                    
                                }
                                else
                                {
                                    // End:0x21D
                                    if(strID == "HSVActorLightCheckBox")
                                    {
                                        SetEnableHsvActorLight(checkHsvActorLight.IsChecked());                                        
                                    }
                                    else
                                    {
                                        // End:0x25B
                                        if(strID == "HSVStaticMeshLightCheckBox")
                                        {
                                            SetEnableHsvStaticMeshLight(checkHsvStaticMeshLight.IsChecked());                                            
                                        }
                                        else
                                        {
                                            // End:0x296
                                            if(strID == "HSVTerrainLightCheckBox")
                                            {
                                                SetEnableHsvTerrainLight(checkHsvTerrainLight.IsChecked());                                                
                                            }
                                            else
                                            {
                                                // End:0x2CE
                                                if(strID == "CheckBoxGammaSetting")
                                                {
                                                    SetEnableGammaSetting(checkBoxGammaSetting.IsChecked());                                                    
                                                }
                                                else
                                                {
                                                    // End:0x30C
                                                    if(strID == "CheckBoxWindowDefaultGamma")
                                                    {
                                                        SetEnableWindowDefaultGamma(checkBoxWindowDefaultGamma.IsChecked());                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x344
                                                        if(strID == "CheckBoxGammaCorrection")
                                                        {
                                                            SetEnableGammaCorrection(checkBoxGammaCorrection.IsChecked());
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

function OnEvent(int Event_ID, string param)
{
    // End:0x1E
    if(Event_ID == 9250)
    {
        Me.ShowWindow();
    }
    return;
}
