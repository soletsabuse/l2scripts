class MSProfilerWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var MSViewerWnd m_scriptMSViewerWnd;
var TextBoxHandle m_hTxtFrameRate;
var TextBoxHandle m_hTxtMaxEmitterNum;
var TextBoxHandle m_hTxtMaxEmitterParticleNum;
var ListCtrlHandle m_hListEmitterCycle;
var Color Gold;
var Color Red;
var Color Orange;
var Color Green;
var Color White;

function OnLoad()
{
    Me = GetWindowHandle(m_WindowName);
    m_scriptMSViewerWnd = MSViewerWnd(GetScript("MSViewerWnd"));
    m_hTxtFrameRate = GetTextBoxHandle(m_WindowName $ ".txtFrameRate");
    m_hTxtMaxEmitterNum = GetTextBoxHandle(m_WindowName $ ".txtMaxEmitterNum");
    m_hTxtMaxEmitterParticleNum = GetTextBoxHandle(m_WindowName $ ".txtMaxEmitterParticleNum");
    m_hListEmitterCycle = GetListCtrlHandle(m_WindowName $ ".listEmitterCycle");
    Gold.R = 176;
    Gold.G = 153;
    Gold.B = 121;
    Red.R = byte(255);
    Red.G = 0;
    Red.B = 0;
    Orange.R = byte(255);
    Orange.G = 127;
    Orange.B = 39;
    Green.R = 0;
    Green.G = byte(255);
    Green.B = 0;
    White.R = byte(255);
    White.G = byte(255);
    White.B = byte(255);
    m_hOwnerWnd.EnableTick();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(4430);
    RegisterEvent(4431);
    return;
}

function ComputeFrameRateOverload(float frameRate, int targetNum)
{
    local float overload, stableload;

    overload = 0.2000000 + (0.1000000 * float(targetNum));
    stableload = 0.1000000 + (0.0500000 * float(targetNum));
    // End:0x5C
    if(frameRate > overload)
    {
        m_hTxtFrameRate.SetTextColor(Red);        
    }
    else
    {
        // End:0x82
        if(frameRate > stableload)
        {
            m_hTxtFrameRate.SetTextColor(Orange);            
        }
        else
        {
            m_hTxtFrameRate.SetTextColor(Green);
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local float frameRate;
    local int maxEmitterNum, maxEmitterParticleNum, targetNum, emitterNum, i;

    local string emitterName;
    local int emitterParticleNum;
    local float emitterAvgFrameRate, emitterMaxFrameRate;
    local LVDataRecord Record;

    Record.LVDataList.Length = 4;
    // End:0x31B
    if(Event_ID == 4430)
    {
        ParseFloat(param, "FrameRate", frameRate);
        ParseInt(param, "TargetNum", targetNum);
        m_hTxtFrameRate.SetText(string(frameRate));
        ComputeFrameRateOverload(frameRate, targetNum);
        ParseInt(param, "MaxEmitterNum", maxEmitterNum);
        m_hTxtMaxEmitterNum.SetText(string(maxEmitterNum));
        ParseInt(param, "MaxEmitterParticleNum", maxEmitterParticleNum);
        m_hTxtMaxEmitterParticleNum.SetText(string(maxEmitterParticleNum));
        ParseInt(param, "EmitterNum", emitterNum);
        i = 0;
        J0x10E:

        // End:0x31B [Loop If]
        if(i < emitterNum)
        {
            ParseString(param, "EmitterName_" $ string(i), emitterName);
            ParseInt(param, "EmitterParticleNum_" $ string(i), emitterParticleNum);
            ParseFloat(param, "AvgEmitterFrameRate_" $ string(i), emitterAvgFrameRate);
            ParseFloat(param, "MaxEmitterFrameRate_" $ string(i), emitterMaxFrameRate);
            Record.LVDataList[0].bUseTextColor = true;
            Record.LVDataList[0].szData = emitterName;
            Record.LVDataList[0].TextColor = Gold;
            Record.LVDataList[1].szData = string(emitterParticleNum);
            Record.LVDataList[1].TextColor = Gold;
            // End:0x290
            if(frameRate > float(0))
            {
                Record.LVDataList[2].szData = ((string(emitterAvgFrameRate) $ "(") $ string(int((emitterAvgFrameRate / frameRate) * 100.0000000))) $ "%)";                
            }
            else
            {
                Record.LVDataList[2].szData = string(emitterAvgFrameRate) $ "(##%)";
            }
            Record.LVDataList[2].TextColor = Gold;
            Record.LVDataList[3].szData = string(emitterMaxFrameRate);
            Record.LVDataList[3].TextColor = Gold;
            m_hListEmitterCycle.InsertRecord(Record);
            ++i;
            // [Loop Continue]
            goto J0x10E;
        }
    }
    // End:0x330
    if(Event_ID == 4431)
    {
        ClearProfilingData();
    }
    return;
}

function ClearProfilingData()
{
    m_hTxtFrameRate.SetText("분석중");
    m_hTxtFrameRate.SetTextColor(White);
    m_hTxtMaxEmitterNum.SetText("분석중");
    m_hTxtMaxEmitterNum.SetTextColor(White);
    m_hTxtMaxEmitterParticleNum.SetText("분석중");
    m_hTxtMaxEmitterParticleNum.SetTextColor(White);
    m_hListEmitterCycle.DeleteAllItem();
    return;
}

function OnShow()
{
    ClearProfilingData();
    return;
}

function OnTick()
{
    // End:0x21
    if(Me.IsShowWindow())
    {
        Class'NWindow.UIDATA_PAWNVIEWER'.static.UpdateEmitterProfiling();
    }
    return;
}

defaultproperties
{
    m_WindowName="MSProfilerWnd"
}