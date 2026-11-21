class WeatherWnd extends UICommonAPI;

var WindowHandle WindowHandle;
var ComboBoxHandle WeatherSortCombo;
var ComboBoxHandle SortCombo;
var ComboBoxHandle EmitterPosCombo;
var TextBoxHandle EmitterPosText;
var EditBoxHandle ParticleWeightEdit;
var EditBoxHandle ParticleSpeedEdit;
var TextBoxHandle ParticleEmitterNumText;
var TextBoxHandle ParticleEmitterNum1Text;
var EditBoxHandle ParticleEmitterNumEdit;
var ButtonHandle SetButton;
var ButtonHandle InitializeButton;
var ButtonHandle DeleteButton;
var int WeatherType;
var int MethodType;

function OnLoad()
{
    InitHandle();
    WeatherSortCombo.Clear();
    WeatherSortCombo.AddStringWithReserved("비", 0);
    WeatherSortCombo.AddStringWithReserved("눈", 1);
    WeatherSortCombo.AddStringWithReserved("비+눈", 2);
    SortCombo.Clear();
    SortCombo.AddStringWithReserved("파티클", 0);
    SortCombo.AddStringWithReserved("매쉬", 1);
    SortCombo.AddStringWithReserved("파티클+매쉬", 2);
    EmitterPosCombo.Clear();
    EmitterPosCombo.AddStringWithReserved("캐릭터에 Attach", 0);
    EmitterPosCombo.AddStringWithReserved("카메라에 Attach", 1);
    ParticleWeightEdit.SetString("1");
    ParticleSpeedEdit.SetString("1");
    ParticleEmitterNumEdit.SetString("1");
    WeatherSortCombo.SetSelectedNum(0);
    SortCombo.SetSelectedNum(0);
    EmitterPosCombo.SetSelectedNum(0);
    WeatherType = 0;
    MethodType = 0;
    return;
}

function InitHandle()
{
    WindowHandle = GetWindowHandle("WeatherWnd");
    WeatherSortCombo = GetComboBoxHandle("WeatherWnd.WeatherSortCombo");
    SortCombo = GetComboBoxHandle("WeatherWnd.SortCombo");
    EmitterPosCombo = GetComboBoxHandle("WeatherWnd.EmitterPosCombo");
    EmitterPosText = GetTextBoxHandle("WeatherWnd.EmitterPosText");
    ParticleWeightEdit = GetEditBoxHandle("WeatherWnd.ParticleWeightEdit");
    ParticleSpeedEdit = GetEditBoxHandle("WeatherWnd.ParticleSpeedEdit");
    ParticleEmitterNumEdit = GetEditBoxHandle("WeatherWnd.ParticleEmitterNumEdit");
    ParticleEmitterNumText = GetTextBoxHandle("WeatherWnd.ParticleEmitterNumText");
    ParticleEmitterNum1Text = GetTextBoxHandle("WeatherWnd.ParticleEmitterNum1Text");
    SetButton = GetButtonHandle("WeatherWnd.SetButton");
    InitializeButton = GetButtonHandle("WeatherWnd.InitializeButton");
    DeleteButton = GetButtonHandle("WeatherWnd.DeleteButton");
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(5010);
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x21
        case 5010:
            WindowHandle.ShowWindow();
            // End:0x24
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnComboBoxItemSelected(string a_ControlID, int a_SelectedIndex)
{
    // End:0x2A
    if(a_ControlID == "WeatherSortCombo")
    {
        WeatherType = a_SelectedIndex;        
    }
    else
    {
        // End:0x153
        if(a_ControlID == "SortCombo")
        {
            MethodType = a_SelectedIndex;
            // End:0xA3
            if(a_SelectedIndex == 0)
            {
                ParticleEmitterNumEdit.ShowWindow();
                ParticleEmitterNumText.ShowWindow();
                ParticleEmitterNum1Text.ShowWindow();
                EmitterPosText.ShowWindow();
                EmitterPosCombo.ShowWindow();                
            }
            else
            {
                // End:0xFC
                if(a_SelectedIndex == 1)
                {
                    ParticleEmitterNumEdit.HideWindow();
                    ParticleEmitterNumText.HideWindow();
                    ParticleEmitterNum1Text.HideWindow();
                    EmitterPosText.HideWindow();
                    EmitterPosCombo.HideWindow();                    
                }
                else
                {
                    // End:0x153
                    if(a_SelectedIndex == 2)
                    {
                        ParticleEmitterNumEdit.ShowWindow();
                        ParticleEmitterNumText.ShowWindow();
                        ParticleEmitterNum1Text.ShowWindow();
                        EmitterPosText.ShowWindow();
                        EmitterPosCombo.ShowWindow();
                    }
                }
            }
        }
    }
    return;
}

function OnClickButton(string a_ControlID)
{
    switch(a_ControlID)
    {
        // End:0x1E
        case "SetButton":
            SetWeatherButton();
            // End:0x59
            break;
        // End:0x42
        case "InitializeButton":
            RequestDeleteRainEffect();
            RequestDeleteSnowEffect();
            // End:0x59
            break;
        // End:0x56
        case "DeleteButton":
            // End:0x59
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function SetWeatherButton()
{
    // End:0x8C
    if(WeatherType == 0)
    {
        RequestDeleteRainEffect();
        RequestCreateRainEffect(MethodType, EmitterPosCombo.GetSelectedNum());
        RequestSetRainWeight(float(ParticleWeightEdit.GetString()));
        RequestSetRainSpeed(float(ParticleSpeedEdit.GetString()));
        // End:0x89
        if((MethodType == 0) || MethodType == 2)
        {
            RequestSetRainEmitterParticleNum(float(ParticleEmitterNumEdit.GetString()));
        }        
    }
    else
    {
        // End:0x118
        if(WeatherType == 1)
        {
            RequestDeleteSnowEffect();
            RequestCreateSnowEffect(MethodType, EmitterPosCombo.GetSelectedNum());
            RequestSetSnowWeight(float(ParticleWeightEdit.GetString()));
            RequestSetSnowSpeed(float(ParticleSpeedEdit.GetString()));
            // End:0x115
            if((MethodType == 0) || MethodType == 2)
            {
                RequestSetSnowEmitterParticleNum(float(ParticleEmitterNumEdit.GetString()));
            }            
        }
        else
        {
            // End:0x220
            if(WeatherType == 2)
            {
                RequestDeleteRainEffect();
                RequestCreateRainEffect(MethodType, EmitterPosCombo.GetSelectedNum());
                RequestSetRainWeight(float(ParticleWeightEdit.GetString()));
                RequestSetRainSpeed(float(ParticleSpeedEdit.GetString()));
                // End:0x1A2
                if((MethodType == 0) || MethodType == 2)
                {
                    RequestSetRainEmitterParticleNum(float(ParticleEmitterNumEdit.GetString()));
                }
                RequestDeleteSnowEffect();
                RequestCreateSnowEffect(MethodType, EmitterPosCombo.GetSelectedNum());
                RequestSetSnowWeight(float(ParticleWeightEdit.GetString()));
                RequestSetSnowSpeed(float(ParticleSpeedEdit.GetString()));
                // End:0x220
                if((MethodType == 0) || MethodType == 2)
                {
                    RequestSetSnowEmitterParticleNum(float(ParticleEmitterNumEdit.GetString()));
                }
            }
        }
    }
    return;
}
