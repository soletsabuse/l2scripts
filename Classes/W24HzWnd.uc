class W24HzWnd extends UICommonAPI;

const DIALOGID_Install24hz = 2424;
const DIALOGID_FullWindow = 2425;
const defaultVolume = 0.4f;

var WindowHandle Me;
var ButtonHandle PlayerChangeButton;
var ButtonHandle CloseButton;
var ButtonHandle PlayControlButton_Next;
var ButtonHandle PlayControlButton_Pre;
var ButtonHandle PlayControlButton;
var SliderCtrlHandle W24HzVolumeSliderCtrl;
var TextBoxHandle MusicName;
var TextureHandle PlayTypeIcon;
var ButtonHandle ChannelControlBtn_Pre;
var ButtonHandle ChannelControlBtn_Next;
var TextBoxHandle ChannelName;
var CheckBoxHandle BackGroundMusicControl;
var int IsRadiomode;
var string CurrentPlayListName;
var int IsEnablePlayListPrevButton;
var int IsEnablePlayListNextButton;
var string CurrentPlaySongName;
var int IsEnableSongPrevButton;
var int IsenableSongNextButton;
var int IsPlayingNow;
var int Volume;
var float saved_BGMVolume;
var bool bConnected;
var bool bfullConfirmOK;
var L2Util util;

function OnLoad()
{
    OnRegisterEvent();
    Initialize();
    load();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(5460);
    RegisterEvent(5463);
    RegisterEvent(5464);
    RegisterEvent(5465);
    RegisterEvent(5462);
    RegisterEvent(5461);
    RegisterEvent(1710);
    return;
}

function Initialize()
{
    Me = GetWindowHandle("W24HzWnd");
    PlayerChangeButton = GetButtonHandle("W24HzWnd.PlayerChangeButton");
    CloseButton = GetButtonHandle("W24HzWnd.CloseButton");
    PlayControlButton_Next = GetButtonHandle("W24HzWnd.PlayControlButton_Next");
    PlayControlButton_Pre = GetButtonHandle("W24HzWnd.PlayControlButton_Pre");
    PlayControlButton = GetButtonHandle("W24HzWnd.PlayControlButton");
    MusicName = GetTextBoxHandle("W24HzWnd.MusicName");
    PlayTypeIcon = GetTextureHandle("W24HzWnd.PlayTypeIcon");
    ChannelControlBtn_Pre = GetButtonHandle("W24HzWnd.ChannelControlBtn_Pre");
    ChannelControlBtn_Next = GetButtonHandle("W24HzWnd.ChannelControlBtn_Next");
    ChannelName = GetTextBoxHandle("W24HzWnd.ChannelName");
    BackGroundMusicControl = GetCheckBoxHandle("W24HzWnd.BackGroundMusicControl");
    util = L2Util(GetScript("L2Util"));
    return;
}

function load()
{
    bConnected = false;
    CurrentPlaySongName = "Now loading...... ";
    CurrentPlayListName = "Now loading ";
    MusicName.SetTextEllipsisWidth(110);
    ChannelName.SetTextEllipsisWidth(94);
    setMusicName(CurrentPlaySongName);
    setChannelName(CurrentPlayListName);
    return;
}

function setMusicName(string song_Name)
{
    MusicName.SetText(song_Name);
    MusicName.SetTooltipString(song_Name);
    return;
}

function setChannelName(string channel_Name)
{
    ChannelName.SetText(channel_Name);
    ChannelName.SetTooltipString(channel_Name);
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 5460:
            HandleL224hzGetInfo(a_Param);
            // End:0xB3
            break;
        // End:0x2E
        case 5462:
            Handle24HzAlreadyConnected();
            // End:0xB3
            break;
        // End:0x3F
        case 5461:
            Handle24HzDisConnected();
            // End:0xB3
            break;
        // End:0x50
        case 5463:
            FileCorrupted();
            // End:0xB3
            break;
        // End:0x61
        case 5464:
            WebCertificationNotRespond();
            // End:0xB3
            break;
        // End:0x9F
        case 5465:
            // End:0x8D
            if(Me.IsShowWindow())
            {
                Me.HideWindow();                
            }
            else
            {
                Me.ShowWindow();
            }
            // End:0xB3
            break;
        // End:0xB0
        case 1710:
            HandleDialogOK();
            // End:0xB3
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function Handle24HzAlreadyConnected()
{
    bfullConfirmOK = false;
    bConnected = false;
    Me.HideWindow();
    DialogSetID(0);
    DialogShow(1, 1, GetSystemMessage(3508), string(self));
    return;
}

function Handle24HzDisConnected()
{
    bfullConfirmOK = false;
    bConnected = false;
    Me.HideWindow();
    DialogSetID(0);
    DialogShow(1, 1, GetSystemMessage(3509), string(self));
    return;
}

function FileCorrupted()
{
    bfullConfirmOK = false;
    bConnected = false;
    Me.HideWindow();
    DialogSetID(2424);
    DialogSetEnterDoNothing();
    DialogShow(1, 0, GetSystemMessage(3293), string(self));
    return;
}

function HandleDialogOK()
{
    // End:0x0D
    if(!DialogIsMine())
    {
        return;
    }
    switch(DialogGetID())
    {
        // End:0x26
        case 2424:
            L224hzLeadInstall();
            // End:0x41
            break;
        // End:0x37
        case 2425:
            HandleSetWindowMode();
            // End:0x41
            break;
        // End:0x3E
        case 0:
            // End:0x41
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleSetWindowMode()
{
    bfullConfirmOK = true;
    Me.ShowWindow();
    return;
}

function WebCertificationNotRespond()
{
    bfullConfirmOK = false;
    bConnected = false;
    Me.HideWindow();
    DialogSetID(0);
    DialogShow(1, 4, GetSystemMessage(3474), string(self));
    return;
}

function OnShow()
{
    // End:0x56
    if(!L224hzIsInstall())
    {
        bfullConfirmOK = false;
        bConnected = false;
        DialogSetID(2424);
        DialogSetEnterDoNothing();
        DialogShow(1, 0, GetSystemMessage(3293), string(self));
        Me.HideWindow();        
    }
    else
    {
        // End:0xB4
        if(((IsFullScreen()) && !bConnected) && !bfullConfirmOK)
        {
            DialogSetID(2425);
            DialogSetEnterDoNothing();
            DialogShow(1, 0, GetSystemMessage(3665), string(self));
            Me.HideWindow();            
        }
        else
        {
            // End:0xD0
            if(!bConnected)
            {
                bConnected = true;
                L224hzTurnOn();                
            }
            else
            {
                L224hzGetInfo();
            }
        }
    }
    muteCheckBoxControlonShow();
    return;
}

function TryConnect()
{
    return;
}

function HandleL224hzGetInfo(string a_Param)
{
    ParseInt(a_Param, "IsRadiomode", IsRadiomode);
    setRadioOrList();
    ParseInt(a_Param, "IsEnablePlayListPrevButton", IsEnablePlayListPrevButton);
    ParseInt(a_Param, "IsEnablePlayListNextButton", IsEnablePlayListNextButton);
    // End:0xAB
    if(IsRadiomode == 0)
    {
        setButtonEnabledOrNot(1, ChannelControlBtn_Pre, 2417);
        setButtonEnabledOrNot(1, ChannelControlBtn_Next, 2421);        
    }
    else
    {
        setButtonEnabledOrNot(1, ChannelControlBtn_Pre, 2415);
        setButtonEnabledOrNot(1, ChannelControlBtn_Next, 2416);
    }
    ParseInt(a_Param, "IsEnableSongPrevButton", IsEnableSongPrevButton);
    setButtonEnabledOrNot(IsEnableSongPrevButton, PlayControlButton_Pre, 2413);
    ParseInt(a_Param, "IsenableSongNextButton", IsenableSongNextButton);
    setButtonEnabledOrNot(IsenableSongNextButton, PlayControlButton_Next, 2414);
    ParseString(a_Param, "CurrentPlayListName", CurrentPlayListName);
    setChannelName(CurrentPlayListName);
    ParseString(a_Param, "CurrentPlaySongName", CurrentPlaySongName);
    setMusicName(CurrentPlaySongName);
    ParseInt(a_Param, "IsPlayingNow", IsPlayingNow);
    setPlayButton();
    ParseInt(a_Param, "Volume", Volume);
    setVolumeSlider();
    return;
}

function setButtonEnabledOrNot(int tmpNum, ButtonHandle tmpBtn, int TooltipString)
{
    local CustomTooltip t;

    util.setCustomTooltip(t);
    util.ToopTipInsertText(GetSystemString(TooltipString), true, true);
    // End:0x62
    if(tmpNum == 0)
    {
        util.ToopTipInsertText(GetSystemString(2418), true, true, util.1);
    }
    tmpBtn.SetTooltipCustomType(util.getCustomTooltip());
    return;
}

function setVolumeSlider()
{
    local int tmpInt;

    tmpInt = 100 - Volume;
    // End:0x7C
    if(Class'NWindow.UIAPI_SLIDERCTRL'.static.GetCurrentTick("W24HzWnd.W24HzVolumeSliderCtrl") != tmpInt)
    {
        Class'NWindow.UIAPI_SLIDERCTRL'.static.SetCurrentTick("W24HzWnd.W24HzVolumeSliderCtrl", tmpInt);
    }
    return;
}

function HandleW24HzVolumeSliderCtrl(int iCurrentTick)
{
    local int tmpInt;

    tmpInt = 100 - iCurrentTick;
    L224hzSetVolume(tmpInt);
    return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
    switch(strID)
    {
        // End:0x2F
        case "W24HzVolumeSliderCtrl":
            HandleW24HzVolumeSliderCtrl(iCurrentTick);
            // End:0x32
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickCheckBox(string strID)
{
    switch(strID)
    {
        // End:0x2B
        case "BackGroundMusicControl":
            BackGroundMusicControlHandle();
            // End:0x2E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string a_Name)
{
    switch(a_Name)
    {
        // End:0x27
        case "PlayerChangeButton":
            L224hzToggleMode();
            // End:0xF0
            break;
        // End:0x40
        case "CloseButton":
            CloseButtonHandle();
            // End:0xF0
            break;
        // End:0x64
        case "PlayControlButton_Next":
            L224hzPlayNextSong();
            // End:0xF0
            break;
        // End:0x87
        case "PlayControlButton_Pre":
            L224hzPlayPrevSong();
            // End:0xF0
            break;
        // End:0xA6
        case "PlayControlButton":
            PlayControlButtonHandle();
            // End:0xF0
            break;
        // End:0xC9
        case "ChannelControlBtn_Pre":
            L224hzPlayPrevList();
            // End:0xF0
            break;
        // End:0xED
        case "ChannelControlBtn_Next":
            L224hzPlayNextList();
            // End:0xF0
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function setRadioOrList()
{
    local string btnString_None, btnString_Over, btnString_Down, Curr_state1, Curr_state2;

    local int SystemString1, SystemString2;

    // End:0x3F
    if(IsRadiomode == 1)
    {
        Curr_state1 = "Player";
        Curr_state2 = "Radio";
        SystemString1 = 2403;
        SystemString2 = 2404;        
    }
    else
    {
        Curr_state1 = "Radio";
        Curr_state2 = "Player";
        SystemString1 = 2402;
        SystemString2 = 2405;
    }
    PlayerChangeButton.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(SystemString1)));
    btnString_None = "L2UI_ct1.24Hz.24Hz_DF_PlayerChangeBtn_" $ Curr_state1;
    btnString_Over = ("L2UI_ct1.24Hz.24Hz_DF_PlayerChangeBtn_" $ Curr_state1) $ "_over";
    btnString_Down = ("L2UI_ct1.24Hz.24Hz_DF_PlayerChangeBtn_" $ Curr_state1) $ "_down";
    PlayerChangeButton.SetTexture(btnString_None, btnString_Down, btnString_Over);
    PlayTypeIcon.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(SystemString2)));
    PlayTypeIcon.SetTexture("L2UI_ct1.24Hz_DF_Icon_PlayType_" $ Curr_state2);
    return;
}

function setPlayButton()
{
    local string btnString_None, btnString_Over, btnString_Down, Curr_state;
    local int SystemString;

    // End:0x25
    if(IsPlayingNow == 1)
    {
        Curr_state = "Stop";
        SystemString = 2420;        
    }
    else
    {
        Curr_state = "Play";
        SystemString = 2419;
    }
    PlayControlButton.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(SystemString)));
    btnString_None = "L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_" $ Curr_state;
    btnString_Over = ("L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_" $ Curr_state) $ "_Over";
    btnString_Down = ("L2UI_ct1.24Hz.24Hz_DF_PlayControlBtn_" $ Curr_state) $ "_Down";
    PlayControlButton.SetTexture(btnString_None, btnString_Down, btnString_Over);
    return;
}

function PlayControlButtonHandle()
{
    // End:0x14
    if(IsPlayingNow == 1)
    {
        L224hzStop();        
    }
    else
    {
        L224hzPlay();
    }
    return;
}

function CloseButtonHandle()
{
    Me.HideWindow();
    return;
}

function muteCheckBoxControlonShow()
{
    local float currVolume;

    currVolume = GetOptionFloat("Audio", "MusicVolume");
    // End:0x63
    if(currVolume > 0.0100000)
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck("W24HzWnd.BackGroundMusicControl", false);        
    }
    else
    {
        Class'NWindow.UIAPI_CHECKBOX'.static.SetCheck("W24HzWnd.BackGroundMusicControl", true);
    }
    return;
}

function BackGroundMusicControlHandle()
{
    local float tmpVol;

    // End:0x69
    if(Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("W24HzWnd.BackGroundMusicControl"))
    {
        PlayConsoleSound(6);
        saved_BGMVolume = GetOptionFloat("Audio", "MusicVolume");
        tmpVol = 0.0000000;        
    }
    else
    {
        PlayConsoleSound(5);
        // End:0x8E
        if(saved_BGMVolume > 0.0100000)
        {
            tmpVol = saved_BGMVolume;            
        }
        else
        {
            tmpVol = 0.4000000;
        }
    }
    SetOptionFloat("Audio", "MusicVolume", tmpVol);
    setVolumeSliderCtrlofOptionWnd(tmpVol);
    return;
}

function setVolumeSliderCtrlofOptionWnd(float tmpVol)
{
    local int iMusicVolume;

    // End:0x2A
    if((0.0000000 <= tmpVol) && tmpVol < 0.2000000)
    {
        iMusicVolume = 0;        
    }
    else
    {
        // End:0x43
        if(tmpVol < 0.4000000)
        {
            iMusicVolume = 1;            
        }
        else
        {
            // End:0x5D
            if(tmpVol < 0.6000000)
            {
                iMusicVolume = 2;                
            }
            else
            {
                // End:0x77
                if(tmpVol < 0.8000000)
                {
                    iMusicVolume = 3;                    
                }
                else
                {
                    // End:0x91
                    if(tmpVol < 1.0000000)
                    {
                        iMusicVolume = 4;                        
                    }
                    else
                    {
                        // End:0xA8
                        if(1.0000000 <= tmpVol)
                        {
                            iMusicVolume = 5;
                        }
                    }
                }
            }
        }
    }
    Class'NWindow.UIAPI_SLIDERCTRL'.static.SetCurrentTick("OptionWnd.MusicVolumeSliderCtrl", iMusicVolume);
    return;
}
