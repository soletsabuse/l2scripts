class EventMatchSpecialMsgWnd extends UICommonAPI;

const TIMERID_Hide = 1;

var TextureHandle MessageTex;

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
    // End:0x30
    if(1 == 0)
    {
        MessageTex = TextureHandle(GetHandle("MsgTex"));        
    }
    else
    {
        MessageTex = GetTextureHandle("MsgTex");
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
        // End:0x2D
        case 1:
            m_hOwnerWnd.HideWindow();
            m_hOwnerWnd.KillTimer(1);
            // End:0x33
            break;
        // End:0xFFFF
        default:
            // End:0x33
            break;
            break;
    }
    return;
}

function HandleEventMatchGMMessage(string a_Param)
{
    local int Type;
    local string Message, TextureName;

    ParseInt(a_Param, "Type", Type);
    ParseString(a_Param, "Message", Message);
    switch(byte(Type))
    {
        // End:0x6C
        case 1:
            TextureName = "L2UI_CH3.BroadcastObs.br_msg1_finish";
            // End:0x1DE
            break;
        // End:0x9F
        case 2:
            TextureName = "L2UI_CH3.BroadcastObs.br_msg1_start";
            // End:0x1DE
            break;
        // End:0xD5
        case 3:
            TextureName = "L2UI_CH3.BroadcastObs.br_msg1_gameover";
            // End:0x1DE
            break;
        // End:0x109
        case 4:
            TextureName = "L2UI_CH3.BroadcastObs.br_msg1_count1";
            // End:0x1DE
            break;
        // End:0x13D
        case 5:
            TextureName = "L2UI_CH3.BroadcastObs.br_msg1_count2";
            // End:0x1DE
            break;
        // End:0x171
        case 6:
            TextureName = "L2UI_CH3.BroadcastObs.br_msg1_count3";
            // End:0x1DE
            break;
        // End:0x1A5
        case 7:
            TextureName = "L2UI_CH3.BroadcastObs.br_msg1_count4";
            // End:0x1DE
            break;
        // End:0x1D9
        case 8:
            TextureName = "L2UI_CH3.BroadcastObs.br_msg1_count5";
            // End:0x1DE
            break;
        // End:0xFFFF
        default:
            return;
            break;
    }
    MessageTex.SetTexture(TextureName);
    m_hOwnerWnd.ShowWindow();
    m_hOwnerWnd.KillTimer(1);
    m_hOwnerWnd.SetTimer(1, 5000);
    return;
}
