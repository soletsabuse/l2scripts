class BeautyShop extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = 0;

var int currentScreenWidth;
var int currentScreenHeight;

function OnRegisterEvent()
{
    RegisterGFxEvent(9440);
    RegisterGFxEvent(9441);
    RegisterGFxEvent(9443);
    RegisterGFxEvent(9445);
    RegisterGFxEvent(9444);
    RegisterGFxEvent(9442);
    RegisterGFxEvent(9447);
    RegisterGFxEvent(9446);
    RegisterGFxEvent(9448);
    RegisterGFxEventForLoaded(2900);
    RegisterGFxEvent(9449);
    return;
}

function OnLoad()
{
    RegisterState("BeautyShop", "BeautyShopState");
    SetAnchor("", 1, 1, 0, 0);
    return;
}

function OnFlashLoaded()
{
    RegisterDelegateHandler(12);
    return;
}
