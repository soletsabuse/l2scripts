class AnnounceMessage extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 260;

function OnRegisterEvent()
{
    RegisterGFxEvent(540);
    return;
}

function OnLoad()
{
    RegisterState("AnnounceMessage", "GamingState");
    SetAnchor("", 2, 2, 0, 260);
    SetAlwaysFullAlpha(true);
    SetHavingFocus(false);
    SetMsgPassThrough(true);
    return;
}
