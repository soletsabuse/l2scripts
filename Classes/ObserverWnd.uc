class ObserverWnd extends UICommonAPI;

var bool m_bObserverMode;

function OnRegisterEvent()
{
    RegisterEvent(2450);
    RegisterEvent(2460);
    RegisterEvent(150);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    m_bObserverMode = false;
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x2D
        case 2450:
            m_bObserverMode = true;
            ShowWindow("ObserverWnd");
            // End:0x7A
            break;
        // End:0x53
        case 2460:
            m_bObserverMode = false;
            HideWindow("ObserverWnd");
            // End:0x7A
            break;
        // End:0x77
        case 150:
            // End:0x74
            if(m_bObserverMode)
            {
                ShowWindow("ObserverWnd");
            }
            // End:0x7A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1B
        case "BtnEnd":
            RequestObserverModeEnd();
            // End:0x1E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
