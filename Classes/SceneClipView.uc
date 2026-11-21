class SceneClipView extends L2UIGFxScript;

const CAPTION_FONTSIZE = 10;
const CAPTION_ADDPOSY = -5;

var int MovieID;
var int currentScreenWidth;
var int currentScreenHeight;
var int audioVolume;
var bool bIsBuilderPC;

function OnRegisterEvent()
{
    RegisterGFxEvent(5620);
    RegisterGFxEvent(5623);
    RegisterGFxEvent(5621);
    RegisterGFxEvent(5624);
    RegisterGFxEvent(5720);
    RegisterGFxEventForLoaded(2900);
    RegisterEvent(5720);
    RegisterEvent(5622);
    return;
}

function OnLoad()
{
    RegisterState("SceneClipView", "GamingState");
    SetHavingFocus(false);
    return;
}

function setSceneClipMode(bool bFullScreen)
{
    // End:0x1A
    if(bFullScreen)
    {
        SetAlwaysOnTop(true);
        SetRenderOnTop(true);        
    }
    else
    {
        SetAlwaysOnTop(false);
        SetRenderOnTop(false);
    }
    return;
}

function OnFlashLoaded()
{
    SetAnchor("", 1, 1, 0, 0);
    return;
}

function OnShow()
{
    Debug("onSHow Flash USM");
    return;
}

function OnHide()
{
    return;
}

function OnEnterState(name a_PreStateName)
{
    return;
}

function OnExitState(name a_NextStateName)
{
    return;
}

function OnDefaultPosition()
{
    return;
}

function OnCallUCFunction(string logicID, string statusStr)
{
    local int MovieID;

    MovieID = int(logicID);
    // End:0x4D
    if(statusStr == "start")
    {
        setSceneClipMode(false);
        Debug("영상 시작 - MovieID:" @ string(MovieID));        
    }
    else
    {
        // End:0x96
        if(statusStr == "finish")
        {
            Debug("영상 끝 - MovieID:" @ string(MovieID));
            FlashMoviePlayEnd(MovieID);
            HideWindow();            
        }
        else
        {
            // End:0x100
            if(statusStr == "fullScreenStart")
            {
                setSceneClipMode(true);
                Debug("풀 스크린 영상 시작 - fullScreenStart MovieID:" @ string(MovieID));
                FullScreenMovieStart();                
            }
            else
            {
                // End:0x147
                if(statusStr == "fullScreenFinish")
                {
                    Debug("풀 스크린 영상 끝");
                    FullScreenMovieEnd();
                    onMovieEnd();
                    HideWindow();
                }
            }
        }
    }
    // End:0x193
    if(logicID == "IsBuilderPC")
    {
        bIsBuilderPC = IsBuilderPC();
        Debug("Refresh IsBuilderPC" @ string(bIsBuilderPC));        
    }
    else
    {
        // End:0x1B6
        if(logicID == "soundUpdate")
        {
            audioVolume = getAudioVolume();
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int MovieID;

    // End:0x9D
    if(Event_ID == 5622)
    {
        ParseInt(param, "MovieID", MovieID);
        // End:0x74
        if(MovieID >= 0)
        {
            ShowWindow();
            Debug("Call FlashMoviePlayStart -> " @ string(MovieID));
            FlashMoviePlayStart(MovieID);            
        }
        else
        {
            Debug("Error: Wrong MovieID ");
        }
        audioVolume = getAudioVolume();
    }
    return;
}

function onMovieEnd()
{
    local GfxDialog GfxDialogScript;

    GfxDialogScript = GfxDialog(GetScript("GfxDialog"));
    GfxDialogScript.onMovieEnd();
    return;
}

function int getAudioVolume()
{
    local float fMusicVolume, fSoundVolume, fEffectVolume, fAmbientVolume, fSystemVoiceVolume, fNpcVoiceVolume,
	    fMaxVolume;

    // End:0x1F
    if(GetOptionBool("Audio", "AudioMuteOn"))
    {
        return 0;
    }
    fMusicVolume = GetOptionFloat("Audio", "MusicVolume");
    fEffectVolume = GetOptionFloat("Audio", "EffectVolume");
    fAmbientVolume = GetOptionFloat("Audio", "AmbientVolume");
    fSystemVoiceVolume = GetOptionFloat("Audio", "SystemVoiceVolume");
    fNpcVoiceVolume = GetOptionFloat("Audio", "NpcVoiceVolume");
    fSoundVolume = GetOptionFloat("Audio", "SoundVolume");
    fMaxVolume = FMax(fMusicVolume, fEffectVolume);
    fMaxVolume = FMax(fMaxVolume, fAmbientVolume);
    fMaxVolume = FMax(fMaxVolume, fSystemVoiceVolume);
    fMaxVolume = FMax(fMaxVolume, fNpcVoiceVolume);
    return int((fMaxVolume * fSoundVolume) * float(100));
    return;
}
