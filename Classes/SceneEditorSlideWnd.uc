class SceneEditorSlideWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var WindowHandle ScreenWnd;
var WindowHandle Slide;
var WindowHandle BackSlide;
var WindowHandle CurSlide;
var WindowHandle NextSlide;
var TextureHandle SlideTexture;
var TextureHandle BackSlideTexture;
var TextureHandle CurSlideTexture;
var TextureHandle NextSlideTexture;

function OnRegisterEvent()
{
    RegisterEvent(4550);
    RegisterEvent(2900);
    return;
}

function OnLoad()
{
    Me = GetWindowHandle("SceneEditorSlideWnd");
    ScreenWnd = GetWindowHandle("SceneEditorSlideWnd.ScreenWnd");
    Slide = GetWindowHandle("SceneEditorSlideWnd.ScreenWnd.Slide");
    BackSlide = GetWindowHandle("SceneEditorSlideWnd.ScreenWnd.BackSlide");
    SlideTexture = GetTextureHandle("SceneEditorSlideWnd.ScreenWnd.Slide.SlideTexture");
    BackSlideTexture = GetTextureHandle("SceneEditorSlideWnd.ScreenWnd.BackSlide.BackSlideTexture");
    CurSlide = Slide;
    NextSlide = BackSlide;
    CurSlideTexture = SlideTexture;
    NextSlideTexture = BackSlideTexture;
    Me.SetCanBeShownDuringScene(true);
    ScreenWnd.SetCanBeShownDuringScene(true);
    Slide.SetCanBeShownDuringScene(true);
    BackSlide.SetCanBeShownDuringScene(true);
    CurSlide.SetCanBeShownDuringScene(true);
    NextSlide.SetCanBeShownDuringScene(true);
    // End:0x1F9
    if(!IsL2NetLoginState())
    {
        RegisterState("SceneEditorSlideWnd", "PawnViewerState");
    }
    CheckResolution();
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int Type, Time, Dir;
    local string TexName;
    local int USize, VSize, MoveRatio, WndRatio, ScreenWndWidth, ScreenWndHeight,
	    moveval;

    local WindowHandle TempSlide;
    local TextureHandle TempSlideTexture;

    // End:0x73B
    if(Event_ID == 4550)
    {
        ParseInt(param, "Type", Type);
        ParseInt(param, "Time", Time);
        ParseInt(param, "Dir", Dir);
        ParseString(param, "TexName", TexName);
        ParseInt(param, "USize", USize);
        ParseInt(param, "VSize", VSize);
        ParseInt(param, "MoveRatio", MoveRatio);
        ParseInt(param, "WndRatio", WndRatio);
        // End:0x165
        if((USize == 1) && VSize == 1)
        {
            Debug("SceneEditorSlideWnd Message :Apply Slide TCT_Stretch ");
            SlideTexture.SetTextureCtrlType(0);
            CurSlideTexture.SetTextureCtrlType(0);
            BackSlideTexture.SetTextureCtrlType(0);
            NextSlideTexture.SetTextureCtrlType(0);
        }
        switch(Type)
        {
            // End:0x1CD
            case 3:
                SlideTexture.SetTexture("Default.BlackTexture");
                BackSlideTexture.SetTexture("Default.BlackTexture");
                Me.ShowWindow();
                // End:0x738
                break;
            // End:0x33A
            case 4:
                // End:0x1E0
                if(Dir != 0)
                {
                    // [Explicit Continue]
                    goto J0x738;
                }
                CurSlide.SetShowAndHideAnimType(false, Dir, 1.0000000);
                CurSlide.HideWindow();
                ScreenWnd.GetWindowSize(ScreenWndWidth, ScreenWndHeight);
                NextSlide.SetWindowSize(ScreenWndWidth, ScreenWndHeight);
                NextSlideTexture.SetWindowSize(ScreenWndWidth, ScreenWndHeight);
                NextSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopLeft", "TopLeft", 0, 0);
                NextSlideTexture.SetTextureSize(USize, VSize);
                NextSlideTexture.SetTexture(TexName);
                NextSlide.SetShowAndHideAnimType(true, Dir, float(Time) / 1000.0000000);
                NextSlide.ShowWindow();
                TempSlide = CurSlide;
                CurSlide = NextSlide;
                NextSlide = TempSlide;
                TempSlideTexture = CurSlideTexture;
                CurSlideTexture = NextSlideTexture;
                NextSlideTexture = TempSlideTexture;
                // End:0x738
                break;
            // End:0x71B
            case 5:
                ScreenWnd.GetWindowSize(ScreenWndWidth, ScreenWndHeight);
                switch(Dir)
                {
                    // End:0x365
                    case 0:
                        return;
                    // End:0x3F6
                    case 1:
                        CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopLeft", "TopLeft", 0, 0);
                        CurSlide.SetWindowSize((ScreenWndWidth * WndRatio) / 100, ScreenWndHeight);
                        CurSlideTexture.SetWindowSize((ScreenWndWidth * WndRatio) / 100, ScreenWndHeight);
                        // End:0x5B9
                        break;
                    // End:0x48A
                    case 2:
                        CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopRight", "TopRight", 0, 0);
                        CurSlide.SetWindowSize((ScreenWndWidth * WndRatio) / 100, ScreenWndHeight);
                        CurSlideTexture.SetWindowSize((ScreenWndWidth * WndRatio) / 100, ScreenWndHeight);
                        // End:0x5B9
                        break;
                    // End:0x51C
                    case 3:
                        CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "TopLeft", "TopLeft", 0, 0);
                        CurSlide.SetWindowSize(ScreenWndWidth, (ScreenWndHeight * WndRatio) / 100);
                        CurSlideTexture.SetWindowSize(ScreenWndWidth, (ScreenWndHeight * WndRatio) / 100);
                        // End:0x5B9
                        break;
                    // End:0x5B4
                    case 4:
                        CurSlide.SetAnchor("SceneEditorSlideWnd.ScreenWnd", "BottomLeft", "BottomLeft", 0, 0);
                        CurSlide.SetWindowSize(ScreenWndWidth, (ScreenWndHeight * WndRatio) / 100);
                        CurSlideTexture.SetWindowSize(ScreenWndWidth, (ScreenWndHeight * WndRatio) / 100);
                        // End:0x5B9
                        break;
                    // End:0xFFFF
                    default:
                        return;
                        break;
                }
                CurSlideTexture.SetTextureSize(USize, VSize);
                CurSlideTexture.SetTexture(TexName);
                CurSlide.ClearAnchor();
                switch(Dir)
                {
                    // End:0x602
                    case 0:
                        return;
                    // End:0x649
                    case 1:
                        moveval = ((ScreenWndWidth * MoveRatio) / 100) * -1;
                        CurSlide.MoveExWithTime(moveval, 0, float(Time) / 1000.0000000);
                        // End:0x718
                        break;
                    // End:0x68A
                    case 2:
                        moveval = (ScreenWndWidth * MoveRatio) / 100;
                        CurSlide.MoveExWithTime(moveval, 0, float(Time) / 1000.0000000);
                        // End:0x718
                        break;
                    // End:0x6D2
                    case 3:
                        moveval = ((ScreenWndHeight * MoveRatio) / 100) * -1;
                        CurSlide.MoveExWithTime(0, moveval, float(Time) / 1000.0000000);
                        // End:0x718
                        break;
                    // End:0x713
                    case 4:
                        moveval = (ScreenWndHeight * MoveRatio) / 100;
                        CurSlide.MoveExWithTime(0, moveval, float(Time) / 1000.0000000);
                        // End:0x718
                        break;
                    // End:0xFFFF
                    default:
                        return;
                        break;
                }
                // End:0x738
                break;
            // End:0x732
            case 6:
                Me.HideWindow();
                // End:0x738
                break;
            // End:0xFFFF
            default:
                // End:0x738
                break;
                break;
        }
        J0x738:
        
    }
    else
    {
        // End:0x750
        if(Event_ID == 2900)
        {
            CheckResolution();
        }
    }
    return;
}

function CheckResolution()
{
    local int CurrentMaxWidth, CurrentMaxHeight;

    GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
    ScreenWnd.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
    ScreenWnd.SetAnchor("SceneEditorSlideWnd", "CenterCenter", "CenterCenter", 0, 0);
    ScreenWnd.SetWindowSizeRel43(1.0000000, 1.0000000, 0, 0);
    ScreenWnd.GetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
    Slide.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
    SlideTexture.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
    BackSlide.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
    BackSlideTexture.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
    return;
}
