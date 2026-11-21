class UIEditor_PropertyController extends UICommonAPI;

var WindowHandle Me;
var WindowHandle m_CurPropertyWnd;
var PropertyControllerHandle ctlProperty;
var WindowHandle areaScroll;

function OnRegisterEvent()
{
    RegisterEvent(2920);
    RegisterEvent(2930);
    RegisterEvent(2950);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    InitHandle();
    InitControlItem();
    return;
}

function InitHandle()
{
    // End:0xA1
    if(1 == 0)
    {
        Me = GetHandle("UIEditor_PropertyController");
        ctlProperty = PropertyControllerHandle(GetHandle("UIEditor_PropertyController.ctlProperty"));
        areaScroll = GetHandle("UIEditor_PropertyController.areaScroll");        
    }
    else
    {
        Me = GetWindowHandle("UIEditor_PropertyController");
        ctlProperty = GetPropertyControllerHandle("UIEditor_PropertyController.ctlProperty");
        areaScroll = GetWindowHandle("UIEditor_PropertyController.areaScroll");
    }
    return;
}

function InitControlItem()
{
    Me.SetWindowTitle("UIEditor - PropertyManager");
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1D
    if(Event_ID == 2920)
    {
        HandleTrackerAttach(param);        
    }
    else
    {
        // End:0x35
        if(Event_ID == 2930)
        {
            HandleTrackerDetach();            
        }
        else
        {
            // End:0x4F
            if(Event_ID == 2950)
            {
                HandleEditorUpdateProperty(param);
            }
        }
    }
    return;
}

function OnPropertyControllerResize(PropertyControllerHandle a_PropertyHandle, int a_Height)
{
    // End:0x1F
    if(areaScroll != none)
    {
        areaScroll.SetScrollHeight(a_Height);
    }
    return;
}

function Clear()
{
    m_CurPropertyWnd = none;
    ctlProperty.super(UIEditor_PropertyController).Clear();
    areaScroll.SetScrollPosition(0);
    return;
}

function HandleTrackerAttach(string param)
{
    local WindowHandle TrackerWnd;

    TrackerWnd = GetTrackerAttachedWindow();
    // End:0x19
    if(TrackerWnd == none)
    {
        return;
    }
    // End:0x84
    if(TrackerWnd != m_CurPropertyWnd)
    {
        m_CurPropertyWnd = TrackerWnd;
        ctlProperty.SetProperty(TrackerWnd.GetControlType(), m_CurPropertyWnd);
        areaScroll.SetScrollHeight(ctlProperty.GetPropertyHeight());
        areaScroll.SetScrollPosition(0);
    }
    return;
}

function HandleTrackerDetach()
{
    Clear();
    return;
}

function HandleEditorUpdateProperty(string param)
{
    local string ControlName;
    local int CloneID;
    local string GroupName;
    local WindowHandle hWnd;

    ParseString(param, "ControlName", ControlName);
    // End:0x2C
    if(Len(ControlName) < 1)
    {
        return;
    }
    ParseInt(param, "CloneID", CloneID);
    hWnd = FindHandle(ControlName, none, CloneID);
    // End:0x6D
    if(hWnd != m_CurPropertyWnd)
    {
        return;
    }
    ParseString(param, "GroupName", GroupName);
    ctlProperty.UpdatePropertyGroup(GroupName);
    return;
}
