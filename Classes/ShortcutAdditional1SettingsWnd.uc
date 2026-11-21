class ShortcutAdditional1SettingsWnd extends UICommonAPI;

var WindowHandle Me;
var SliderCtrlHandle ViewSlider;
var ShortcutAdditional1Wnd ShortcutAdditional1Wnd;

function OnLoad()
{
    Me = GetWindowHandle("ShortcutAdditional1SettingsWnd");
    ViewSlider = GetSliderCtrlHandle("ShortcutAdditional1SettingsWnd.View");
    ShortcutAdditional1Wnd = ShortcutAdditional1Wnd(GetScript("ShortcutAdditional1Wnd"));
    return;
}

function OnModifyCurrentTickSliderCtrl(string Name, int Step)
{
    switch(Name)
    {
        // End:0x31
        case "View":
            ShortcutAdditional1Wnd.changeView(ViewSlider.GetCurrentTick());
            // End:0x37
            break;
        // End:0xFFFF
        default:
            // End:0x37
            break;
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    // End:0x23
    if(strID == "btnClose")
    {
        Me.HideWindow();
    }
    return;
}
