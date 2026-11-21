class BR_EventHalloweenWnd extends UICommonAPI;

var WindowHandle Me;
var WindowHandle Today;
var int WindowState;

function OnRegisterEvent()
{
    RegisterEvent(9101);
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function Initialize()
{
    // End:0x53
    if(1 == 0)
    {
        Me = GetHandle("BR_EventHalloweenWnd");
        Today = GetHandle("BR_EventHalloweenTodayWnd");        
    }
    else
    {
        Me = GetWindowHandle("BR_EventHalloweenWnd");
        Today = GetWindowHandle("BR_EventHalloweenTodayWnd");
    }
    WindowState = 0;
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int Show;

    switch(Event_ID)
    {
        // End:0x82
        case 9101:
            ParseInt(param, "Show", Show);
            // End:0x54
            if(Show == 0)
            {
                // End:0x51
                if(Me.IsShowWindow())
                {
                    Me.HideWindow();
                }                
            }
            else
            {
                // End:0x77
                if(!Me.IsShowWindow())
                {
                    Me.ShowWindow();
                }
                AddSystemMessage(6027);
            }
        // End:0xFFFF
        default:
            return;
            break;
    }
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x2A
        case "EventHalloweenBtn1":
            OnEventHalloBtnRankClick(2, 1);
            // End:0x70
            break;
        // End:0x4D
        case "EventHalloweenBtn2":
            OnEventHalloBtnRankClick(1, 2);
            // End:0x70
            break;
        // End:0x6D
        case "EventHalloweenBtn3":
            OnEventHalloBtnHelpClick();
            // End:0x70
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEventHalloBtnRankClick(int Me, int Other)
{
    // End:0xBC
    if(IsShowWindow("BR_EventHalloweenTodayWnd"))
    {
        // End:0x5E
        if(WindowState == Me)
        {
            HideWindow("BR_EventHalloweenTodayWnd");
            WindowState = 0;            
        }
        else
        {
            // End:0xB9
            if(WindowState == Other)
            {
                Today.KillTimer(200901);
                RequestBR_EventRankerList(20091031, Me - 1, 1);
                WindowState = Me;
                Today.SetTimer(200901, 7000);
            }
        }        
    }
    else
    {
        RequestBR_EventRankerList(20091031, Me - 1, 1);
        ShowWindowWithFocus("BR_EventHalloweenTodayWnd");
        WindowState = Me;
    }
    return;
}

function OnEventHalloBtnHelpClick()
{
    local string strParam;

    // End:0x36
    if(IsShowWindow("BR_EventHtmlWndA"))
    {
        HideWindow("BR_EventHtmlWndA");        
    }
    else
    {
        ShowWindowWithFocus("BR_EventHtmlWndA");
        ParamAdd(strParam, "FilePath", "..\\L2text\\br_eventhalloween000.htm");
        ParamAdd(strParam, "Title", GetSystemString(5036));
        ExecuteEvent(9111, strParam);
    }
    return;
}
