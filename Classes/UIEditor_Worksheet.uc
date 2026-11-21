class UIEditor_Worksheet extends UICommonAPI;

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x19
    if(int(nKey) == int(46))
    {
        DeleteWindow();        
    }
    else
    {
        // End:0x2F
        if(int(nKey) == int(27))
        {
            ClearAllTracker();
        }
    }
    return;
}

function ClearAllTracker()
{
    ClearTracker();
    return;
}

function DeleteWindow()
{
    DeleteAttachedWindow();
    return;
}

function OnDropWnd(WindowHandle hTarget, WindowHandle hDropWnd, int X, int Y)
{
    local UIEditor_ControlManager script;
    local WindowHandle ContainerHandle, ParentHandle;

    // End:0x1A
    if((hTarget == none) || hDropWnd == none)
    {
        return;
    }
    ContainerHandle = hTarget;
    // End:0x91
    if(!ContainerHandle.IsControlContainer())
    {
        ParentHandle = ContainerHandle.GetParentWindowHandle();
        J0x4E:

        // End:0x86 [Loop If]
        if(ParentHandle != none)
        {
            // End:0x6E
            if(ParentHandle.IsControlContainer())
            {
                // [Explicit Break]
                goto J0x86;
            }
            ParentHandle = ParentHandle.GetParentWindowHandle();
            // [Loop Continue]
            goto J0x4E;
        }
        J0x86:

        ContainerHandle = ParentHandle;
    }
    // End:0xD9
    if(ContainerHandle == none)
    {
        DialogShow(1, 1, ("Can't Move Control to " $ hTarget.GetWindowName()) $ ".", string(self));
        return;
    }
    // End:0x134
    if(hDropWnd.ChangeParentWindow(ContainerHandle))
    {
        script = UIEditor_ControlManager(GetScript("UIEditor_ControlManager"));
        // End:0x134
        if(script != none)
        {
            script.RefreshControlList();
        }
    }
    return;
}

function OnDropItemWithHandle(WindowHandle hTarget, ItemInfo Info, int X, int Y)
{
    local UIEditor_ControlManager script;
    local string strTarget;
    local WindowHandle TargetWndHandle, ParentHandle, NewWnd;
    local UIEventManager.EXMLControlType Type;

    TargetWndHandle = hTarget;
    // End:0x18
    if(TargetWndHandle == none)
    {
        return;
    }
    strTarget = TargetWndHandle.GetWindowName();
    // End:0x99
    if(!TargetWndHandle.IsControlContainer())
    {
        ParentHandle = TargetWndHandle.GetParentWindowHandle();
        J0x56:

        // End:0x8E [Loop If]
        if(ParentHandle != none)
        {
            // End:0x76
            if(ParentHandle.IsControlContainer())
            {
                // [Explicit Break]
                goto J0x8E;
            }
            ParentHandle = ParentHandle.GetParentWindowHandle();
            // [Loop Continue]
            goto J0x56;
        }
        J0x8E:

        TargetWndHandle = ParentHandle;
    }
    // End:0xD7
    if(TargetWndHandle == none)
    {
        DialogShow(1, 1, ("Can't Drop Control to " $ strTarget) $ ".", string(self));
        return;
    }
    script = UIEditor_ControlManager(GetScript("UIEditor_ControlManager"));
    // End:0x10E
    if(script == none)
    {
        return;
    }
    Type = script.GetCurrentControlType();
    // End:0x1A6
    if(strTarget == "Worksheet")
    {
        // End:0x1A6
        if((int(Type) != int(1)) && int(Type) != int(29))
        {
            DialogShow(1, 1, "Please Drop Container Control First! (Window, ScrollArea..)", string(self));
            return;
        }
    }
    script.UpdateControlList();
    NewWnd = TargetWndHandle.AddChildWnd(Type);
    // End:0x1F9
    if(NewWnd != none)
    {
        SetDefaultValue(NewWnd, Type, strTarget, X, Y);
    }
    return;
}

function SetDefaultValue(WindowHandle NewWnd, UIEventManager.EXMLControlType Type, string strTarget, int X, int Y)
{
    local int DefaultWidth, defaultHeight;
    local ButtonHandle hButton;
    local TextBoxHandle hTextBox;
    local TextureHandle hTexture;
    local BarHandle hBar;

    DefaultWidth = 50;
    defaultHeight = 50;
    NewWnd.SetEditable(true);
    switch(Type)
    {
        // End:0x137
        case 1:
            // End:0x124
            if(strTarget == "Worksheet")
            {
                DefaultWidth = 256;
                defaultHeight = 256;
                NewWnd.SetBackTexture("Default.BlackTexture");
                NewWnd.SetXMLDocumentInfo("Created By L2UIEditor Ver1.0", "http://www.lineage2.co.kr/ui", "http://www.w3.org/2001/XMLSchema-instance", "http://www.lineage2.co.kr/ui ..\\..\\Schema.xsd");                
            }
            else
            {
                DefaultWidth = 50;
                defaultHeight = 50;
            }
            // End:0x3DD
            break;
        // End:0x1CC
        case 2:
            DefaultWidth = 76;
            defaultHeight = 23;
            hButton = ButtonHandle(NewWnd);
            hButton.SetTexture("L2UI_CH3.Button.Btn1_Normal", "L2UI_CH3.Button.Btn1_NormalOn", "L2UI_CH3.Button.Btn1_Normal_Over");
            // End:0x3DD
            break;
        // End:0x212
        case 3:
            DefaultWidth = 100;
            defaultHeight = 12;
            hTextBox = TextBoxHandle(NewWnd);
            hTextBox.SetText(hTextBox.GetWindowName());
            // End:0x3DD
            break;
        // End:0x22A
        case 4:
            DefaultWidth = 50;
            defaultHeight = 17;
            // End:0x3DD
            break;
        // End:0x267
        case 5:
            hTexture = TextureHandle(NewWnd);
            hTexture.SetTexture("Default.WhiteTexture");
            // End:0x3DD
            break;
        // End:0x26F
        case 6:
            // End:0x3DD
            break;
        // End:0x277
        case 7:
            // End:0x3DD
            break;
        // End:0x27F
        case 8:
            // End:0x3DD
            break;
        // End:0x297
        case 9:
            DefaultWidth = 80;
            defaultHeight = 12;
            // End:0x3DD
            break;
        // End:0x2AF
        case 10:
            DefaultWidth = 50;
            defaultHeight = 19;
            // End:0x3DD
            break;
        // End:0x2B7
        case 11:
            // End:0x3DD
            break;
        // End:0x2CF
        case 12:
            DefaultWidth = 50;
            defaultHeight = 50;
            // End:0x3DD
            break;
        // End:0x2D7
        case 13:
            // End:0x3DD
            break;
        // End:0x2DF
        case 14:
            // End:0x3DD
            break;
        // End:0x2F7
        case 15:
            DefaultWidth = 50;
            defaultHeight = 12;
            // End:0x3DD
            break;
        // End:0x30F
        case 16:
            DefaultWidth = 50;
            defaultHeight = 12;
            // End:0x3DD
            break;
        // End:0x317
        case 17:
            // End:0x3DD
            break;
        // End:0x31F
        case 18:
            // End:0x3DD
            break;
        // End:0x327
        case 19:
            // End:0x3DD
            break;
        // End:0x32F
        case 20:
            // End:0x3DD
            break;
        // End:0x337
        case 21:
            // End:0x3DD
            break;
        // End:0x33F
        case 22:
            // End:0x3DD
            break;
        // End:0x347
        case 23:
            // End:0x3DD
            break;
        // End:0x34F
        case 24:
            // End:0x3DD
            break;
        // End:0x367
        case 25:
            DefaultWidth = 80;
            defaultHeight = 12;
            // End:0x3DD
            break;
        // End:0x36F
        case 26:
            // End:0x3DD
            break;
        // End:0x377
        case 27:
            // End:0x3DD
            break;
        // End:0x3B2
        case 28:
            DefaultWidth = 50;
            defaultHeight = 6;
            hBar = BarHandle(NewWnd);
            hBar.SetValue(100, 25);
            // End:0x3DD
            break;
        // End:0x3BA
        case 29:
            // End:0x3DD
            break;
        // End:0x3C2
        case 30:
            // End:0x3DD
            break;
        // End:0x3CA
        case 31:
            // End:0x3DD
            break;
        // End:0x3D2
        case 32:
            // End:0x3DD
            break;
        // End:0x3DA
        case 33:
            // End:0x3DD
            break;
        // End:0xFFFF
        default:
            break;
    }
    NewWnd.SetWindowSize(DefaultWidth, defaultHeight);
    NewWnd.SetFocus();
    return;
}
