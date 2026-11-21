class RadioWnd extends UICommonAPI;

var WindowHandle m_hWnd;
var ButtonHandle m_btnPlay;
var ButtonHandle m_btnStop;
var SliderCtrlHandle m_sldVolume;
var TextBoxHandle m_txtStatus;
var TextBoxHandle m_txtVolume;
var EditBoxHandle m_edtUrl;
var string m_defaultUrl;
var int currentVolume;
var bool bIsPlaying;
var bool bIsLoaded;

function OnRegisterEvent()
{
    RegisterEvent(1710);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    m_hWnd = GetWindowHandle("RadioWnd");
    m_btnPlay = GetButtonHandle("RadioWnd.btnPlay");
    m_btnStop = GetButtonHandle("RadioWnd.btnStop");
    m_sldVolume = GetSliderCtrlHandle("RadioWnd.sldVolume");
    m_txtStatus = GetTextBoxHandle("RadioWnd.txtStatus");
    m_txtVolume = GetTextBoxHandle("RadioWnd.txtVolume");
    m_edtUrl = GetEditBoxHandle("RadioWnd.edtUrl");
    m_defaultUrl = "http://pokefm.live/live";
    preloadVolume();
    bIsLoaded = true;
    return;
}

function preloadVolume()
{
    currentVolume = getVolume();
    Class'NWindow.RadioAPI'.static.SetRadioVolume(currentVolume);
    m_edtUrl.SetString(m_defaultUrl);
    m_sldVolume.SetCurrentTick(currentVolume);
    setTextVolume();
    return;
}

function setTextVolume()
{
    m_txtVolume.SetText(string(currentVolume));
    // End:0x3B
    if(currentVolume <= 0)
    {
        m_txtVolume.SetText(GetSystemString(8067));
    }
    return;
}

function OnShow()
{
    EssenceMainDesc(GetScript("EssenceMainDesc")).CheckByType(4);
    preloadVolume();
    return;
}

function OnHide()
{
    EssenceMainDesc(GetScript("EssenceMainDesc")).CheckByType(4);
    return;
}

function bool inPlaying()
{
    return Class'NWindow.RadioAPI'.static.IsRadioPlaying();
    return;
}

function OnEvent(int EventID, string param)
{
    // End:0x15
    if(EventID == 1710)
    {
        HandleDialogOK();
    }
    return;
}

function HandleDialogOK()
{
    // End:0x2E
    if(DialogIsMine())
    {
        switch(DialogGetID())
        {
            // End:0x28
            case -1773790776:
                OpenGivenURL(DialogGetStr());
                // End:0x2E
                break;
            // End:0xFFFF
            default:
                // End:0x2E
                break;
                break;
        }
    }
    return;
}

function OnClickButton(string strID)
{
    local string URL, W;

    // End:0xA5
    if(strID == "btnPlay")
    {
        // End:0x80
        if(!inPlaying())
        {
            // End:0x3E
            if(m_edtUrl != none)
            {
                URL = m_edtUrl.GetString();
            }
            // End:0x62
            if(Len(URL) > 0)
            {
                Class'NWindow.RadioAPI'.static.PlayRadio(URL);                
            }
            else
            {
                Class'NWindow.RadioAPI'.static.PlayRadio(m_defaultUrl);
            }
            setPlayButton(true);            
        }
        else
        {
            Class'NWindow.RadioAPI'.static.StopRadio();
            setPlayButton(false);
        }
        bIsPlaying = !bIsPlaying;
    }
    // End:0x128
    if(strID == "BOHRadioTGBtn")
    {
        W = SettingSectorStr("RADIO", "TELEGRAM_WEB");
        // End:0xEF
        if(Len(W) <= 5)
        {
            return;
        }
        DialogSetID(-1773790776);
        DialogSetStr(W);
        DialogShow(1, 0, MakeFullSystemMsg(GetSystemString(8073), W), string(self));
    }
    // End:0x1A9
    if(strID == "BOHRadioWebBtn")
    {
        W = SettingSectorStr("RADIO", "OTHER_WEB");
        // End:0x170
        if(Len(W) <= 5)
        {
            return;
        }
        DialogSetID(-1773790776);
        DialogSetStr(W);
        DialogShow(1, 0, MakeFullSystemMsg(GetSystemString(8073), W), string(self));
    }
    return;
}

event OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
    // End:0x2D
    if(strID == "sldVolume")
    {
        // End:0x22
        if(!bIsLoaded)
        {
            return;
        }
        setVolume(iCurrentTick);
    }
    return;
}

function setPlayButton(bool bIsPlay)
{
    local string btnString_None, btnString_Over, btnString_Down, Curr_state;
    local int SystemString;

    // End:0x23
    if(bIsPlay)
    {
        Curr_state = "Stop";
        SystemString = 2420;        
    }
    else
    {
        Curr_state = "Play";
        SystemString = 2419;
    }
    m_btnPlay.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(SystemString)));
    btnString_None = "L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_" $ Curr_state;
    btnString_Over = ("L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_" $ Curr_state) $ "_Over";
    btnString_Down = ("L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_" $ Curr_state) $ "_Down";
    m_btnPlay.SetTexture(btnString_None, btnString_Down, btnString_Over);
    return;
}

function setVolume(int vol)
{
    // End:0xA1
    if(vol != currentVolume)
    {
        currentVolume = vol;
        // End:0x57
        if((float(vol) % float(10)) == float(0))
        {
            getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemString(8066), string(vol)));
        }
        Class'NWindow.RadioAPI'.static.SetRadioVolume(vol);
        setTextVolume();
        SetOptionInt("Game", "RadioVolume", vol);
        RefreshINI("Option.ini");
    }
    return;
}

function int getVolume()
{
    return GetOptionInt("Game", "RadioVolume");
    return;
}
