class OnScreenMessageWnd extends UIScript;

enum Mstate
{
    FADE_IN,                        // 0
    FADE_MIDDLE,                    // 1
    FADE_OUT,                       // 2
    FADE_NONE                       // 3
};

var string currentwnd1;
var bool onshowstat1;
var bool onshowstat2;
var int timerset1;
var int globalAlphavalue1;
var int globalAlphavalue2;
var int globalDuration;
var int droprate;
var int moveval;
var int moveval2;
var string MovedWndName;
var int m_TimerCount;
var WindowHandle OnScreenMessageWnd1;
var WindowHandle OnScreenMessageWnd2;
var WindowHandle handlearr[10];
var int AlphaValues[10];
var int DropValues[10];
var int LifeTimes[10];
var OnScreenMessageWnd.Mstate states[10];

function resetByIdx(int idx)
{
    m_hOwnerWnd.KillTimer(idx);
    AlphaValues[idx] = 0;
    DropValues[idx] = 0;
    LifeTimes[idx] = 0;
    states[idx] = 3;
    return;
}

function initAll()
{
    local int idx;

    idx = 1;
    J0x07:

    // End:0x95 [Loop If]
    if(idx < 10)
    {
        handlearr[idx] = GetWindowHandle("OnScreenMessageWnd" $ string(idx));
        AlphaValues[idx] = 0;
        DropValues[idx] = 0;
        LifeTimes[idx] = 0;
        states[idx] = 3;
        m_hOwnerWnd.KillTimer(idx);
        idx++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(140);
    RegisterEvent(141);
    RegisterEvent(580);
    RegisterEvent(9230);
    RegisterEvent(160);
    return;
}

function OnLoad()
{
    initAll();
    OnScreenMessageWnd1 = GetWindowHandle("OnScreenMessageWnd1");
    OnScreenMessageWnd2 = GetWindowHandle("OnScreenMessageWnd2");
    GetWindowHandle("OnScreenMessageWnd1").SetCanBeShownDuringScene(true);
    GetWindowHandle("OnScreenMessageWnd2").SetCanBeShownDuringScene(true);
    GetWindowHandle("OnScreenMessageWnd3").SetCanBeShownDuringScene(true);
    GetWindowHandle("OnScreenMessageWnd4").SetCanBeShownDuringScene(true);
    GetWindowHandle("OnScreenMessageWnd5").SetCanBeShownDuringScene(true);
    GetWindowHandle("OnScreenMessageWnd6").SetCanBeShownDuringScene(true);
    GetWindowHandle("OnScreenMessageWnd7").SetCanBeShownDuringScene(true);
    GetWindowHandle("OnScreenMessageWnd8").SetCanBeShownDuringScene(true);
    GetWindowHandle("OnScreenMessageWnd9").SetCanBeShownDuringScene(true);
    globalAlphavalue1 = 0;
    globalAlphavalue2 = 255;
    currentwnd1 = "";
    onshowstat1 = false;
    onshowstat2 = false;
    timerset1 = 0;
    moveval = 0;
    moveval2 = 0;
    globalAlphavalue1 = 0;
    globalAlphavalue2 = 255;
    m_TimerCount = 0;
    return;
}

function OnTimer(int TimerID)
{
    local int idx;

    idx = TimerID;
    // End:0xBD
    if(int(states[idx]) == int(0))
    {
        AlphaValues[idx] += DropValues[idx];
        // End:0x9A
        if(AlphaValues[idx] >= 255)
        {
            AlphaValues[idx] = 255;
            states[idx] = 1;
            m_hOwnerWnd.KillTimer(idx);
            m_hOwnerWnd.SetTimer(idx, LifeTimes[idx]);
        }
        handlearr[idx].SetAlpha(AlphaValues[idx]);        
    }
    else
    {
        // End:0x10E
        if(int(states[idx]) == int(1))
        {
            states[idx] = 2;
            m_hOwnerWnd.KillTimer(idx);
            m_hOwnerWnd.SetTimer(idx, 30);            
        }
        else
        {
            // End:0x1B4
            if(int(states[idx]) == int(2))
            {
                AlphaValues[idx] -= DropValues[idx];
                // End:0x191
                if(AlphaValues[idx] <= 0)
                {
                    AlphaValues[idx] = 0;
                    states[idx] = 3;
                    m_hOwnerWnd.KillTimer(idx);
                    handlearr[idx].HideWindow();
                }
                handlearr[idx].SetAlpha(AlphaValues[idx]);                
            }
            else
            {
                // End:0x1CA
                if(int(states[idx]) == int(3))
                {
                }
            }
        }
    }
    return;
}

function OnHide()
{
    return;
}

function ResetAllMessage()
{
    local int i;
    local Color DefaultColor;
    local string wndname;

    DefaultColor.R = byte(255);
    DefaultColor.G = byte(255);
    DefaultColor.B = byte(255);
    globalAlphavalue1 = 0;
    globalAlphavalue2 = 255;
    currentwnd1 = "";
    onshowstat1 = false;
    onshowstat2 = false;
    OnScreenMessageWnd1.HideWindow();
    OnScreenMessageWnd2.HideWindow();
    i = 1;
    J0x79:

    // End:0x1E4 [Loop If]
    if(i <= 8)
    {
        wndname = "OnScreenMessageWnd" $ string(i);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((wndname $ ".TextBox") $ string(i), DefaultColor);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(((wndname $ ".TextBox") $ string(i)) $ "-1", DefaultColor);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(((wndname $ ".TextBox") $ string(i)) $ "-2", DefaultColor);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor((wndname $ ".TextBoxsm") $ string(i), DefaultColor);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(((wndname $ ".TextBoxsm") $ string(i)) $ "-1", DefaultColor);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(((wndname $ ".TextBoxsm") $ string(i)) $ "-2", DefaultColor);
        ++i;
        // [Loop Continue]
        goto J0x79;
    }
    return;
}

function ShowMsg(int WndNum, string TextValue, int Duration, int Animation, int FontType, int BackgroundType, int ColorR, int ColorG, int ColorB, optional bool bUseNpcZoom)
{
    local string wndname, TextBoxName, TextBoxName2, TextBoxName3, TextValue1, TextValue2,
	    TextValue3, CurText, SmallBoxName1, SmallBoxName2, SmallBoxName3;

    local Color FontColor;
    local int i, j, LengthTotal, TotalLength, TextOffsetTotal1;

    FontColor.R = byte(ColorR);
    FontColor.G = byte(ColorG);
    FontColor.B = byte(ColorB);
    TextValue1 = "";
    TextValue2 = "";
    TextValue3 = "";
    j = 1;
    TotalLength = Len(TextValue);
    i = 1;
    J0x69:

    // End:0x13C [Loop If]
    if(i <= TotalLength)
    {
        LengthTotal = Len(TextValue) - 1;
        CurText = Left(TextValue, 1);
        TextValue = Right(TextValue, LengthTotal);
        // End:0xC0
        if(CurText == "`")
        {
            CurText = "";
            // [Explicit Continue]
            goto J0x132;
        }
        // End:0xDF
        if(CurText == "#")
        {
            CurText = "";
            j++;
            // [Explicit Continue]
            goto J0x132;
        }
        // End:0xFF
        if(j == 1)
        {
            TextValue1 = TextValue1 $ CurText;
            // [Explicit Continue]
            goto J0x132;
        }
        // End:0x120
        if(j == 2)
        {
            TextValue2 = TextValue2 $ CurText;
            // [Explicit Continue]
            goto J0x132;
        }
        TextValue3 = TextValue3 $ CurText;
        J0x132:

        ++i;
        // [Loop Continue]
        goto J0x69;
    }
    wndname = "OnScreenMessageWnd" $ string(WndNum);
    TextBoxName = (wndname $ ".TextBox") $ string(WndNum);
    TextBoxName2 = ((wndname $ ".TextBox") $ string(WndNum)) $ "-1";
    TextBoxName3 = ((wndname $ ".TextBox") $ string(WndNum)) $ "-2";
    SmallBoxName1 = (wndname $ ".TextBoxsm") $ string(WndNum);
    SmallBoxName2 = ((wndname $ ".TextBoxsm") $ string(WndNum)) $ "-1";
    SmallBoxName3 = ((wndname $ ".TextBoxsm") $ string(WndNum)) $ "-2";
    currentwnd1 = wndname;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(TextBoxName, FontColor);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(TextBoxName2, FontColor);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(TextBoxName3, FontColor);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(SmallBoxName1, FontColor);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(SmallBoxName2, FontColor);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor(SmallBoxName3, FontColor);
    // End:0x377
    if(FontType == 0)
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(currentwnd1);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName, TextValue1);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName2, TextValue2);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName3, TextValue3);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(SmallBoxName1, "");
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText(SmallBoxName2, "");        
    }
    else
    {
        // End:0x423
        if(FontType == 1)
        {
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(currentwnd1);
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName, "");
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName2, "");
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(TextBoxName3, "");
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(SmallBoxName1, TextValue1);
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(SmallBoxName2, TextValue2);
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText(SmallBoxName3, TextValue3);
        }
    }
    // End:0x4B3
    if(WndNum == 2)
    {
        // End:0x43A
        if(moveval != 0)
        {
        }
        MovedWndName = wndname;
        moveval2 = (TextOffsetTotal1 / 2) * 29;
        // End:0x48B
        if(BackgroundType == 1)
        {
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(MovedWndName $ ".texturetype1");            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(MovedWndName $ ".texturetype1");
        }        
    }
    else
    {
        // End:0x4D8
        if(WndNum == 5)
        {
            // End:0x4CA
            if(moveval != 0)
            {
            }
            MovedWndName = wndname;            
        }
        else
        {
            // End:0x4FD
            if(WndNum == 7)
            {
                // End:0x4EF
                if(moveval != 0)
                {
                }
                MovedWndName = wndname;                
            }
            else
            {
                moveval = 0;
            }
        }
    }
    onshowstat1 = true;
    onshowstat2 = false;
    globalDuration = Duration;
    switch(Animation)
    {
        // End:0x535
        case 0:
            droprate = 255;
            // End:0x577
            break;
        // End:0x544
        case 1:
            droprate = 25;
            // End:0x577
            break;
        // End:0x554
        case 11:
            droprate = 15;
            // End:0x577
            break;
        // End:0x564
        case 12:
            droprate = 25;
            // End:0x577
            break;
        // End:0x574
        case 13:
            droprate = 35;
            // End:0x577
            break;
        // End:0xFFFF
        default:
            break;
    }
    resetByIdx(WndNum);
    DropValues[WndNum] = droprate;
    states[WndNum] = 0;
    // End:0x5D3
    if(!bUseNpcZoom)
    {
        LifeTimes[WndNum] = Duration;
        m_hOwnerWnd.SetTimer(WndNum, 30);
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local int MsgType, MsgNo, WindowType, FontSize, FontType, msgcolor,
	    msgcolorR, msgcolorG, msgcolorB, shadowtype, BackgroundType,
	    Lifetime, AnimationType, SystemMsgIndex;

    local string MsgText, ParamString1, ParamString2;

    // End:0x200
    if(a_EventID == 140)
    {
        ParseInt(a_Param, "MsgType", MsgType);
        ParseInt(a_Param, "MsgNo", MsgNo);
        ParseInt(a_Param, "WindowType", WindowType);
        ParseInt(a_Param, "FontSize", FontSize);
        ParseInt(a_Param, "FontType", FontType);
        ParseInt(a_Param, "MsgColor", msgcolor);
        // End:0xCE
        if(!ParseInt(a_Param, "MsgColorR", msgcolorR))
        {
            msgcolorR = 255;
        }
        // End:0xF6
        if(!ParseInt(a_Param, "MsgColorG", msgcolorG))
        {
            msgcolorG = 255;
        }
        // End:0x11E
        if(!ParseInt(a_Param, "MsgColorB", msgcolorB))
        {
            msgcolorB = 255;
        }
        ParseInt(a_Param, "ShadowType", shadowtype);
        ParseInt(a_Param, "BackgroundType", BackgroundType);
        ParseInt(a_Param, "LifeTime", Lifetime);
        ParseInt(a_Param, "AnimationType", AnimationType);
        ParseString(a_Param, "Msg", MsgText);
        ResetAllMessage();
        // End:0x1CA
        if(MsgType == 0)
        {
            MsgText = GetSystemMessage(MsgNo);
        }
        ShowMsg(WindowType, MsgText, Lifetime, AnimationType, FontType, BackgroundType, msgcolorR, msgcolorG, msgcolorB);        
    }
    else
    {
        // End:0x482
        if(a_EventID == 141)
        {
            ParseInt(a_Param, "MsgType", MsgType);
            ParseInt(a_Param, "MsgNo", MsgNo);
            ParseInt(a_Param, "WindowType", WindowType);
            ParseInt(a_Param, "FontSize", FontSize);
            ParseInt(a_Param, "FontType", FontType);
            // End:0x2FD
            if(ParseInt(a_Param, "MsgColor", msgcolor))
            {
                // End:0x2BF
                if(msgcolor == 0)
                {
                    msgcolor = 16777215;
                }
                msgcolorR = (msgcolor & 16711680) >> 16;
                msgcolorG = (msgcolor & 65280) >> 8;
                msgcolorB = msgcolor & 255;                
            }
            else
            {
                // End:0x325
                if(!ParseInt(a_Param, "MsgColorR", msgcolorR))
                {
                    msgcolorR = 255;
                }
                // End:0x34D
                if(!ParseInt(a_Param, "MsgColorG", msgcolorG))
                {
                    msgcolorG = 255;
                }
                // End:0x375
                if(!ParseInt(a_Param, "MsgColorB", msgcolorB))
                {
                    msgcolorB = 255;
                }
            }
            ParseInt(a_Param, "ShadowType", shadowtype);
            ParseInt(a_Param, "BackgroundType", BackgroundType);
            ParseInt(a_Param, "LifeTime", Lifetime);
            ParseInt(a_Param, "AnimationType", AnimationType);
            ParseString(a_Param, "Msg", MsgText);
            ResetAllMessage();
            switch(MsgType)
            {
                // End:0x424
                case 0:
                    MsgText = GetSystemMessage(MsgNo);
                    // End:0x44B
                    break;
                // End:0x42B
                case 1:
                    // End:0x44B
                    break;
                // End:0x445
                case 2:
                    MsgText = MsgText $ "...";
                    // End:0x44B
                    break;
                // End:0xFFFF
                default:
                    // End:0x44B
                    break;
                    break;
            }
            ShowMsg(WindowType, MsgText, Lifetime, AnimationType, FontType, BackgroundType, msgcolorR, msgcolorG, msgcolorB, true);            
        }
        else
        {
            // End:0x4F0
            if(a_EventID == 580)
            {
                ParseInt(a_Param, "Index", SystemMsgIndex);
                ParseString(a_Param, "Param1", ParamString1);
                ParseString(a_Param, "Param2", ParamString2);
                ValidateSystemMsg(SystemMsgIndex, ParamString1, ParamString2);                
            }
            else
            {
                // End:0x505
                if(a_EventID == 160)
                {
                    Clear();                    
                }
                else
                {
                    // End:0x5CD
                    if(a_EventID == 9230)
                    {
                        ParseString(a_Param, "string", ParamString1);
                        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("OnScreenMessageWnd2.TextBox2", "");
                        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("OnScreenMessageWnd2.TextBox2-1", ParamString1);
                        // End:0x5AD
                        if(ParamString1 == "")
                        {
                            OnScreenMessageWnd2.HideWindow();                            
                        }
                        else
                        {
                            OnScreenMessageWnd2.SetAlpha(255);
                            OnScreenMessageWnd2.ShowWindow();
                        }
                    }
                }
            }
        }
    }
    return;
}

function Clear()
{
    initAll();
    globalAlphavalue1 = 0;
    globalAlphavalue2 = 255;
    currentwnd1 = "";
    onshowstat1 = false;
    onshowstat2 = false;
    timerset1 = 0;
    moveval = 0;
    moveval2 = 0;
    globalAlphavalue1 = 0;
    globalAlphavalue2 = 255;
    m_TimerCount = 0;
    OnScreenMessageWnd1.HideWindow();
    return;
}

function ValidateSystemMsg(int Index, string StringTxt1, string StringTxt2)
{
    local SystemMsgData SystemMsgCurrent;
    local int WindowType, FontType, BackgroundType, Lifetime, AnimationType;

    local string MsgText;
    local Color TextColor;

    GetSystemMsgInfo(Index, SystemMsgCurrent);
    // End:0x1CE
    if(SystemMsgCurrent.WindowType != 0)
    {
        WindowType = SystemMsgCurrent.WindowType;
        MsgText = SystemMsgCurrent.OnScrMsg;
        MsgText = MakeFullSystemMsg(MsgText, StringTxt1, StringTxt2);
        Lifetime = SystemMsgCurrent.Lifetime * 1000;
        AnimationType = SystemMsgCurrent.AnimationType;
        FontType = SystemMsgCurrent.FontType;
        BackgroundType = SystemMsgCurrent.BackgroundType;
        TextColor = SystemMsgCurrent.FontColor;
        // End:0x11C
        if(((int(TextColor.R) == 0) && int(TextColor.G) == 0) && int(TextColor.B) == 0)
        {
            TextColor.R = byte(255);
            TextColor.G = byte(255);
            TextColor.B = byte(255);            
        }
        else
        {
            // End:0x186
            if(((int(TextColor.R) == 176) && int(TextColor.G) == 155) && int(TextColor.B) == 121)
            {
                TextColor.R = byte(255);
                TextColor.G = byte(255);
                TextColor.B = byte(255);
            }
        }
        ShowMsg(WindowType, MsgText, Lifetime, AnimationType, FontType, BackgroundType, int(TextColor.R), int(TextColor.G), int(TextColor.B));
    }
    return;
}
