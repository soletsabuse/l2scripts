class AutoPlayRangeWnd extends UICommonAPI;

const RANGE_STEP = 100;
const STR_RANGE = 9076;
const STR_SHOW_RING = 9079;
const TIMER_ID_APPLY = 1;
const TIMER_DELAY_APPLY = 500;

var WindowHandle Me;
var SliderCtrlHandle RangeSlider;
var TextBoxHandle TitleText;
var TextBoxHandle LimitText;
var CheckBoxHandle ShowRingCheck;
var int RangeMin;
var int RangeMax;
var int RangeValue;
var bool bSettingSlider;
var bool bApplyPending;

function OnLoad()
{
    Me = GetWindowHandle("AutoPlayRangeWnd");
    RangeSlider = GetSliderCtrlHandle("AutoPlayRangeWnd.RangeSlider");
    TitleText = GetTextBoxHandle("AutoPlayRangeWnd.TitleText");
    LimitText = GetTextBoxHandle("AutoPlayRangeWnd.LimitText");
    ShowRingCheck = GetCheckBoxHandle("AutoPlayRangeWnd.ShowRingCheck");
    ShowRingCheck.SetTitle(GetSystemString(9079));
    RangeMin = 100;
    RangeMax = 2000;
    RangeValue = 2000;
    UpdateSlider();
    return;
}

function SetRangeInfo(int Range, int MinRange, int MaxRange)
{
    RangeMin = MinRange;
    RangeMax = Max(MaxRange, MinRange);
    // End:0x3C
    if(!Me.IsShowWindow())
    {
        RangeValue = Range;
    }
    UpdateSlider();
    return;
}

function UpdateSlider()
{
    bSettingSlider = true;
    RangeSlider.SetTotalTickCount(((RangeMax - RangeMin) / 100) + 1);
    RangeSlider.SetCurrentTick((Clamp(RangeValue, RangeMin, RangeMax) - RangeMin) / 100);
    bSettingSlider = false;
    LimitText.SetText((((((GetSystemString(1043) $ "/") $ GetSystemString(1044)) $ ": ") $ string(RangeMin)) $ " - ") $ string(RangeMax));
    UpdateTitle();
    return;
}

function UpdateTitle()
{
    TitleText.SetText((GetSystemString(9076) $ ": ") $ string(RangeValue));
    return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
    // End:0x24
    if((strID != "RangeSlider") || bSettingSlider)
    {
        return;
    }
    RangeValue = Min(RangeMin + (iCurrentTick * 100), RangeMax);
    UpdateTitle();
    AutomaticPlay(GetScript("AutomaticPlay")).PreviewRange(RangeValue);
    bApplyPending = true;
    Me.KillTimer(1);
    Me.SetTimer(1, 500);
    return;
}

event OnTimer(int TimerID)
{
    // End:0x0D
    if(TimerID != 1)
    {
        return;
    }
    ApplyRange();
    return;
}

function OnShow()
{
    ShowRingCheck.SetCheck(AutomaticPlay(GetScript("AutomaticPlay")).IsRingEnabled());
    AutomaticPlay(GetScript("AutomaticPlay")).SetZoneOpened(true);
    return;
}

function OnClickCheckBox(string strID)
{
    // End:0x4C
    if(strID == "ShowRingCheck")
    {
        AutomaticPlay(GetScript("AutomaticPlay")).SetRingEnabled(ShowRingCheck.IsChecked());
    }
    return;
}

function OnHide()
{
    ApplyRange();
    AutomaticPlay(GetScript("AutomaticPlay")).SetZoneOpened(false);
    return;
}

function ApplyRange()
{
    Me.KillTimer(1);
    // End:0x1D
    if(!bApplyPending)
    {
        return;
    }
    bApplyPending = false;
    RequestBypassToServer("aprange " $ string(RangeValue));
    return;
}

function ToggleRange()
{
    // End:0x23
    if(Me.IsShowWindow())
    {
        Me.HideWindow();
        return;
    }
    Me.ShowWindow();
    return;
}

function HideRange()
{
    // End:0x21
    if(Me.IsShowWindow())
    {
        Me.HideWindow();
    }
    return;
}
