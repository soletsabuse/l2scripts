class BR_EventFireWnd extends UICommonAPI;

var int BuffOnOff;
var int Today;
var int Per;
var WindowHandle Me;
var ButtonHandle EventFireBtn1;
var ButtonHandle EventFireBtn2;
var TextureHandle NCTextureRed;
var TextureHandle NCTextureBack;
var WindowHandle GaugeToolTip;
var TextBoxHandle EventFireTitle;

function OnRegisterEvent()
{
    RegisterEvent(9090);
    RegisterEvent(9091);
    return;
}

function OnLoad()
{
    Initialize();
    load();
    return;
}

function Initialize()
{
    // End:0xE0
    if(1 == 0)
    {
        Me = GetHandle("BR_EventFireWnd");
        EventFireBtn1 = ButtonHandle(GetHandle("BR_EventFireWnd.EventFireBtn1"));
        EventFireBtn2 = ButtonHandle(GetHandle("BR_EventFireWnd.EventFireBtn2"));
        NCTextureRed = TextureHandle(GetHandle("BR_EventFireWnd.NCTextureRed"));
        GaugeToolTip = GetHandle("BR_EventFireWnd.GaugeToolTip");        
    }
    else
    {
        Me = GetWindowHandle("BR_EventFireWnd");
        EventFireBtn1 = GetButtonHandle("BR_EventFireWnd.EventFireBtn1");
        EventFireBtn2 = GetButtonHandle("BR_EventFireWnd.EventFireBtn2");
        NCTextureRed = GetTextureHandle("BR_EventFireWnd.NCTextureRed");
        GaugeToolTip = GetWindowHandle("BR_EventFireWnd.GaugeToolTip");
    }
    BuffOnOff = 0;
    Today = 0;
    Per = 0;
    return;
}

function load()
{
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local int eState, Day, Percent, Type, Value, bstate,
	    EndTime;

    switch(a_EventID)
    {
        // End:0x71
        case 9090:
            ParseInt(a_Param, "EventState", eState);
            ParseInt(a_Param, "Day", Day);
            ParseInt(a_Param, "Percent", Percent);
            FireEventWndShow(eState, Day, Percent);
            // End:0xF6
            break;
        // End:0xF3
        case 9091:
            ParseInt(a_Param, "Type", Type);
            ParseInt(a_Param, "Value", Value);
            ParseInt(a_Param, "State", bstate);
            ParseInt(a_Param, "Endtime", EndTime);
            FireEventBuff(Type, Value, bstate, EndTime);
            // End:0xF6
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function FireEventBuff(int Type, int Value, int bstate, int EndTime)
{
    local string ParamString;

    // End:0x211
    if(bstate == 1)
    {
        BuffOnOff = 1;
        EventFireBtn1.SetTexture("BranchSys.UI.present_normal", "BranchSys.UI.present_normal", "BranchSys.UI.present_normal");
        // End:0xD2
        if(Type == 1)
        {
            EventFireBtn1.SetTooltipCustomType(SetTooltip(MakeFullSystemMsg(GetSystemMessage(6014), MakeFullSystemMsg(GetSystemMessage(6012), string(Value), "%"), ConvertTimetoStr(EndTime))));            
        }
        else
        {
            // End:0x1C5
            if(Type == 2)
            {
                // End:0x12C
                if(Value == 20573)
                {
                    EventFireBtn1.SetTooltipCustomType(SetTooltip(MakeFullSystemMsg(GetSystemMessage(6015), ConvertTimetoStr(EndTime), GetSystemString(5024))));                    
                }
                else
                {
                    // End:0x17A
                    if(Value == 20574)
                    {
                        EventFireBtn1.SetTooltipCustomType(SetTooltip(MakeFullSystemMsg(GetSystemMessage(6015), ConvertTimetoStr(EndTime), GetSystemString(5025))));                        
                    }
                    else
                    {
                        // End:0x1C5
                        if(Value == 20575)
                        {
                            EventFireBtn1.SetTooltipCustomType(SetTooltip(MakeFullSystemMsg(GetSystemMessage(6015), ConvertTimetoStr(EndTime), GetSystemString(5026))));
                        }
                    }
                }
            }
        }
        ParamAdd(ParamString, "Type", string(int(0)));
        ParamAdd(ParamString, "param1", string(Today));
        AddSystemMessageParam(ParamString);
        EndSystemMessageParam(6017, false);        
    }
    else
    {
        // End:0x324
        if(bstate == 0)
        {
            // End:0x270
            if(BuffOnOff == 1)
            {
                ParamAdd(ParamString, "Type", string(int(0)));
                ParamAdd(ParamString, "param1", string(Today));
                AddSystemMessageParam(ParamString);
                EndSystemMessageParam(6018, false);
            }
            BuffOnOff = 0;
            EventFireBtn1.SetTexture("BranchSys.UI.present_disable", "BranchSys.UI.present_disable", "BranchSys.UI.present_disable");
            // End:0x31E
            if(Per == 100)
            {
                EventFireBtn1.SetTooltipCustomType(SetTooltip(MakeFullSystemMsg(GetSystemMessage(6018), string(Today), "")));                
            }
            else
            {
                FireEventButton();
            }
        }
    }
    return;
}

function FireEventWndShow(int eState, int Day, int Percent)
{
    // End:0x2F
    if(eState == 0)
    {
        // End:0x2C
        if(Me.IsShowWindow())
        {
            Me.HideWindow();
        }        
    }
    else
    {
        // End:0x52
        if(!Me.IsShowWindow())
        {
            Me.ShowWindow();
        }
        Per = Percent;
        // End:0xB3
        if(Today == 0)
        {
            Today = Day;
            GaugeToolTip.SetTooltipCustomType(SetTooltip(MakeFullSystemMsg(GetSystemMessage(6016), string(Today), "")));
            // End:0xB3
            if(BuffOnOff == 0)
            {
                FireEventButton();
            }
        }
        // End:0x109
        if(Percent == 0)
        {
            Today = Day;
            GaugeToolTip.SetTooltipCustomType(SetTooltip(MakeFullSystemMsg(GetSystemMessage(6016), string(Today), "")));
            // End:0x109
            if(BuffOnOff == 0)
            {
                FireEventButton();
            }
        }
        FireEventGauge(Percent);
    }
    return;
}

function FireEventButton()
{
    local int addexp;

    // End:0x42
    if(Today == 6)
    {
        EventFireBtn1.SetTooltipCustomType(SetTooltip(MakeFullSystemMsg(GetSystemMessage(6013), GetSystemString(5024), "")));        
    }
    else
    {
        // End:0x84
        if(Today == 10)
        {
            EventFireBtn1.SetTooltipCustomType(SetTooltip(MakeFullSystemMsg(GetSystemMessage(6013), GetSystemString(5025), "")));            
        }
        else
        {
            // End:0xC6
            if(Today == 14)
            {
                EventFireBtn1.SetTooltipCustomType(SetTooltip(MakeFullSystemMsg(GetSystemMessage(6013), GetSystemString(5026), "")));                
            }
            else
            {
                // End:0xF8
                if(((Today == 1) || Today == 2) || Today == 3)
                {
                    addexp = 10;                    
                }
                else
                {
                    // End:0x10F
                    if(Today == 4)
                    {
                        addexp = 15;                        
                    }
                    else
                    {
                        // End:0x134
                        if((Today == 5) || Today == 7)
                        {
                            addexp = 20;                            
                        }
                        else
                        {
                            // End:0x159
                            if((Today == 8) || Today == 9)
                            {
                                addexp = 25;                                
                            }
                            else
                            {
                                // End:0x17E
                                if((Today == 11) || Today == 12)
                                {
                                    addexp = 30;                                    
                                }
                                else
                                {
                                    // End:0x192
                                    if(Today == 13)
                                    {
                                        addexp = 40;
                                    }
                                }
                            }
                        }
                    }
                }
                EventFireBtn1.SetTooltipCustomType(SetTooltip(MakeFullSystemMsg(GetSystemMessage(6013), MakeFullSystemMsg(GetSystemMessage(6012), string(addexp), "%"), "")));
            }
        }
    }
    return;
}

function FireEventGauge(int Percent)
{
    // End:0x15
    if(Percent < 0)
    {
        Percent = 0;        
    }
    else
    {
        // End:0x29
        if(Percent > 100)
        {
            Percent = 100;
        }
    }
    // End:0x5B
    if((Percent == 0) || Percent == 100)
    {
        NCTextureRed.SetWindowSize(Percent, 14);        
    }
    else
    {
        NCTextureRed.SetWindowSize(((Percent / 10) * 9) + 3, 14);
    }
    return;
}

function CustomTooltip SetTooltip(string Text)
{
    local CustomTooltip ToolTip;
    local DrawItemInfo Info;

    ToolTip.MinimumWidth = 144;
    ToolTip.DrawList.Length = 1;
    Info.eType = 1;
    Info.t_bDrawOneLine = true;
    Info.t_color.R = 178;
    Info.t_color.G = 190;
    Info.t_color.B = 207;
    Info.t_color.A = byte(255);
    Info.t_strText = Text;
    ToolTip.DrawList[0] = Info;
    return ToolTip;
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x22
        case "EventFireBtn1":
            OnEventFireBtn1Click();
            // End:0x40
            break;
        // End:0x3D
        case "EventFireBtn2":
            OnEventFireBtn2Click();
            // End:0x40
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEventFireBtn1Click()
{
    return;
}

function OnEventFireBtn2Click()
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
        ParamAdd(strParam, "FilePath", "..\\L2text\\br_eventfire_help.htm");
        ParamAdd(strParam, "Title", GetSystemString(5023));
        ExecuteEvent(9111, strParam);
    }
    return;
}
