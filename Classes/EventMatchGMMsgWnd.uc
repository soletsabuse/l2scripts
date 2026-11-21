class EventMatchGMMsgWnd extends UICommonAPI;

const TIMERID_Hide = 1;

var TextBoxHandle MessageTextBox;

function OnRegisterEvent()
{
    RegisterEvent(2270);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x34
    if(1 == 0)
    {
        MessageTextBox = TextBoxHandle(GetHandle("MsgTextBox"));        
    }
    else
    {
        MessageTextBox = GetTextBoxHandle("MsgTextBox");
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 2270:
            HandleEventMatchGMMessage(a_Param);
            // End:0x23
            break;
        // End:0xFFFF
        default:
            // End:0x23
            break;
            break;
    }
    return;
}

function OnTimer(int a_TimerID)
{
    switch(a_TimerID)
    {
        // End:0x3E
        case 1:
            m_hOwnerWnd.HideWindow();
            MessageTextBox.SetText("");
            m_hOwnerWnd.KillTimer(1);
            // End:0x44
            break;
        // End:0xFFFF
        default:
            // End:0x44
            break;
            break;
    }
    return;
}

function HandleEventMatchGMMessage(string a_Param)
{
    local int Type;
    local string Message;

    ParseInt(a_Param, "Type", Type);
    ParseString(a_Param, "Message", Message);
    switch(byte(Type))
    {
        // End:0x88
        case 0:
            m_hOwnerWnd.ShowWindow();
            MessageTextBox.SetText(Message);
            m_hOwnerWnd.KillTimer(1);
            m_hOwnerWnd.SetTimer(1, 5000);
            // End:0x8E
            break;
        // End:0xFFFF
        default:
            // End:0x8E
            break;
            break;
    }
    return;
}
