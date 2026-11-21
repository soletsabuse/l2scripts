class QuestBtnWnd extends UICommonAPI;

var bool m_bArriveShowQuest;
var int m_iEffectNumber;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    ParseInt(param, "QuestID", m_iEffectNumber);
    switch(Event_ID)
    {
        // End:0x95
        case 1520:
            ShowWindowWithFocus("QuestBtnWnd");
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("QuestBtnWnd.btnQuest");
            Class'NWindow.UIAPI_EFFECTBUTTON'.static.BeginEffect("QuestBtnWnd.btnQuest", m_iEffectNumber);
            m_bArriveShowQuest = true;
            // End:0x98
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEnterState(name a_PreStateName)
{
    // End:0x52
    if(m_bArriveShowQuest && a_PreStateName == 'NpcZoomCameraState')
    {
        ShowWindowWithFocus("QuestBtnWnd");
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("QuestBtnWnd.btnQuest");
    }
    m_bArriveShowQuest = false;
    m_iEffectNumber = 0;
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x32
        case "btnQuest":
            HideWindow("QuestBtnWnd");
            m_bArriveShowQuest = false;
            // End:0x35
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
