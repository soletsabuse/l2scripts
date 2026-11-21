class BR_EventDefaultWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle EventDefaultBtn1;
var ButtonHandle EventDefaultBtn2;
var ButtonHandle EventDefaultBtn3;
var TextBoxHandle EventTitle;
var int EventID;

function OnRegisterEvent()
{
    RegisterEvent(9110);
    RegisterEvent(9130);
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function OnShow()
{
    local int Result;

    Result = BR_GetShowEventUI();
    // End:0x3B
    if(Result == 0)
    {
        // End:0x38
        if(Me.IsShowWindow())
        {
            Me.HideWindow();
        }        
    }
    else
    {
        // End:0x5E
        if(!Me.IsShowWindow())
        {
            Me.ShowWindow();
        }
    }
    return;
}

function Initialize()
{
    // End:0xFC
    if(1 == 0)
    {
        Me = GetHandle("BR_EventDefaultWnd");
        EventDefaultBtn1 = ButtonHandle(GetHandle("BR_EventDefaultWnd.EventDefaultBtn1"));
        EventDefaultBtn2 = ButtonHandle(GetHandle("BR_EventDefaultWnd.EventDefaultBtn2"));
        EventDefaultBtn3 = ButtonHandle(GetHandle("BR_EventDefaultWnd.EventDefaultBtn3"));
        EventTitle = TextBoxHandle(GetHandle("BR_EventDefaultWnd.EventTitle"));        
    }
    else
    {
        Me = GetWindowHandle("BR_EventDefaultWnd");
        EventDefaultBtn1 = GetButtonHandle("BR_EventDefaultWnd.EventDefaultBtn1");
        EventDefaultBtn2 = GetButtonHandle("BR_EventDefaultWnd.EventDefaultBtn2");
        EventDefaultBtn3 = GetButtonHandle("BR_EventDefaultWnd.EventDefaultBtn3");
        EventTitle = GetTextBoxHandle("BR_EventDefaultWnd.EventTitle");
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int Show;

    switch(Event_ID)
    {
        // End:0x149
        case 9110:
            EventID = 20091225;
            ParseInt(param, "Show", Show);
            ShowMyWindow(Show, 6029);
            EventTitle.SetText(GetSystemString(5046));
            EventDefaultBtn1.SetTexture("BranchSys.UI.Br_rudolf_gift_normal", "BranchSys.UI.Br_rudolf_gift_click", "BranchSys.UI.Br_rudolf_gift_over");
            EventDefaultBtn2.SetTexture("BranchSys.UI.Br_santa_gift_nomal", "BranchSys.UI.Br_santa_gift_click", "BranchSys.UI.Br_santa_gift_over");
            // End:0x188
            break;
        // End:0x185
        case 9130:
            EventID = 20100214;
            ParseInt(param, "Show", Show);
            ShowMyWindow(Show, 6037);
            // End:0x188
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ShowMyWindow(int Show, int Msg)
{
    // End:0x2F
    if(Show == 0)
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
        AddSystemMessage(Msg);
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x25
        case "EventDefaultBtn1":
            OnEventDefaultBtn1Click();
            // End:0x64
            break;
        // End:0x43
        case "EventDefaultBtn2":
            OnEventDefaultBtn2Click();
            // End:0x64
            break;
        // End:0x61
        case "EventDefaultBtn3":
            OnEventDefaultBtn3Click();
            // End:0x64
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEventDefaultBtn1Click()
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
        // End:0xBA
        if(EventID == 20091225)
        {
            ParamAdd(strParam, "FilePath", "..\\L2text\\br_xmas_2009_UI_santa000.htm");
            ParamAdd(strParam, "Title", GetSystemString(5044));            
        }
        else
        {
            // End:0x127
            if(EventID == 20100214)
            {
                ParamAdd(strParam, "FilePath", "..\\L2text\\br_valen_2010_UI_necklace000.htm");
                ParamAdd(strParam, "Title", GetSystemString(5061));
            }
        }
        ExecuteEvent(9111, strParam);
    }
    return;
}

function OnEventDefaultBtn2Click()
{
    local string strParam;

    // End:0x36
    if(IsShowWindow("BR_EventHtmlWndB"))
    {
        HideWindow("BR_EventHtmlWndB");        
    }
    else
    {
        ShowWindowWithFocus("BR_EventHtmlWndB");
        // End:0xBB
        if(EventID == 20091225)
        {
            ParamAdd(strParam, "FilePath", "..\\L2text\\br_xmas_2009_UI_rudolf000.htm");
            ParamAdd(strParam, "Title", GetSystemString(5043));            
        }
        else
        {
            // End:0x124
            if(EventID == 20100214)
            {
                ParamAdd(strParam, "FilePath", "..\\L2text\\br_valen_2010_UI_drop000.htm");
                ParamAdd(strParam, "Title", GetSystemString(5062));
            }
        }
        ExecuteEvent(9112, strParam);
    }
    return;
}

function OnEventDefaultBtn3Click()
{
    local string strParam;

    // End:0x36
    if(IsShowWindow("BR_EventHtmlWndC"))
    {
        HideWindow("BR_EventHtmlWndC");        
    }
    else
    {
        ShowWindowWithFocus("BR_EventHtmlWndC");
        // End:0xBB
        if(EventID == 20091225)
        {
            ParamAdd(strParam, "FilePath", "..\\L2text\\br_xmas_2009_UI_reward000.htm");
            ParamAdd(strParam, "Title", GetSystemString(5045));            
        }
        else
        {
            // End:0x124
            if(EventID == 20100214)
            {
                ParamAdd(strParam, "FilePath", "..\\L2text\\br_valen_2010_UI_help000.htm");
                ParamAdd(strParam, "Title", GetSystemString(5063));
            }
        }
        ExecuteEvent(9113, strParam);
    }
    return;
}
