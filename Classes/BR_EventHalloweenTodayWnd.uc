class BR_EventHalloweenTodayWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle ServerTextBox;
var TextBoxHandle MyTextBox;
var TextBoxHandle MsgTextBox;
var TextBoxHandle TitleTextBox;

function OnRegisterEvent()
{
    RegisterEvent(9102);
    RegisterEvent(9103);
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function OnShow()
{
    Me.SetTimer(200901, 7000);
    TitleTextBox.SetText(GetSystemMessage(2031));
    ServerTextBox.SetText("");
    MyTextBox.SetText("");
    MsgTextBox.SetText("");
    return;
}

function OnHide()
{
    Me.KillTimer(200901);
    return;
}

function OnTimer(int TimerID)
{
    // End:0x42
    if(TimerID == 200901)
    {
        // End:0x42
        if(IsShowWindow("BR_EventHalloweenTodayWnd"))
        {
            Me.HideWindow();
        }
    }
    return;
}

function Initialize()
{
    // End:0x111
    if(1 == 0)
    {
        Me = GetHandle("BR_EventHalloweenTodayWnd");
        ServerTextBox = TextBoxHandle(GetHandle("BR_EventHalloweenTodayWnd.ServerTextBox"));
        MyTextBox = TextBoxHandle(GetHandle("BR_EventHalloweenTodayWnd.MyTextBox"));
        MsgTextBox = TextBoxHandle(GetHandle("BR_EventHalloweenTodayWnd.MsgTextBox"));
        TitleTextBox = TextBoxHandle(GetHandle("BR_EventHalloweenTodayWnd.TitleTextBox"));        
    }
    else
    {
        Me = GetWindowHandle("BR_EventHalloweenTodayWnd");
        ServerTextBox = GetTextBoxHandle("BR_EventHalloweenTodayWnd.ServerTextBox");
        MyTextBox = GetTextBoxHandle("BR_EventHalloweenTodayWnd.MyTextBox");
        MsgTextBox = GetTextBoxHandle("BR_EventHalloweenTodayWnd.MsgTextBox");
        TitleTextBox = GetTextBoxHandle("BR_EventHalloweenTodayWnd.TitleTextBox");
    }
    return;
}

function OnEvent(int Event_ID, string a_Param)
{
    local int Count, bestScore, myScore;

    // End:0x10B
    if(Event_ID == 9102)
    {
        ParseInt(a_Param, "Count", Count);
        ParseInt(a_Param, "BestScore", bestScore);
        ParseInt(a_Param, "Myscore", myScore);
        Debug("EV_BR_EventRankerNowList Count: " $ string(Count));
        Debug("EV_BR_EventRankerNowList BestScore: " $ string(bestScore));
        Debug("EV_BR_EventRankerNowList Myscore: " $ string(myScore));
        SetTodayTextbox(Count, bestScore, myScore);        
    }
    else
    {
        // End:0x216
        if(Event_ID == 9103)
        {
            ParseInt(a_Param, "Count", Count);
            ParseInt(a_Param, "BestScore", bestScore);
            ParseInt(a_Param, "Myscore", myScore);
            Debug("EV_BR_EventRankerLastList Count: " $ string(Count));
            Debug("EV_BR_EventRankerLastList BestScore: " $ string(bestScore));
            Debug("EV_BR_EventRankerLastList Myscore: " $ string(myScore));
            SetLastTextbox(Count, bestScore, myScore);
        }
    }
    return;
}

function SetTodayTextbox(int Count, int bestScore, int myScore)
{
    TitleTextBox.SetText(GetSystemString(5040));
    // End:0x57
    if(bestScore >= 5)
    {
        ServerTextBox.SetText(MakeFullSystemMsg(GetSystemMessage(6023), string(bestScore), string(Count)));        
    }
    else
    {
        ServerTextBox.SetText(GetSystemMessage(6025));
    }
    // End:0xA9
    if(myScore >= 5)
    {
        MyTextBox.SetText(MakeFullSystemMsg(GetSystemMessage(6024), string(myScore), ""));        
    }
    else
    {
        MyTextBox.SetText(GetSystemMessage(6026));
    }
    // End:0xFC
    if((bestScore == myScore) && myScore >= 0)
    {
        MsgTextBox.SetText(GetSystemString(5041));        
    }
    else
    {
        MsgTextBox.SetText("");
    }
    return;
}

function SetLastTextbox(int Count, int bestScore, int myScore)
{
    TitleTextBox.SetText(GetSystemString(5039));
    // End:0x57
    if(bestScore >= 10)
    {
        ServerTextBox.SetText(MakeFullSystemMsg(GetSystemMessage(6023), string(bestScore), string(Count)));        
    }
    else
    {
        ServerTextBox.SetText(GetSystemMessage(6028));
    }
    // End:0xA9
    if(myScore >= 5)
    {
        MyTextBox.SetText(MakeFullSystemMsg(GetSystemMessage(6024), string(myScore), ""));        
    }
    else
    {
        MyTextBox.SetText(GetSystemMessage(6026));
    }
    // End:0xFD
    if((bestScore == myScore) && bestScore >= 10)
    {
        MsgTextBox.SetText(GetSystemString(5042));        
    }
    else
    {
        MsgTextBox.SetText("");
    }
    return;
}
