class MovieCaptureWnd extends UICommonAPI;

const DIALOGID_OpenFolder = 7063;
const DIALOGID_Diskisfull = 7064;

var WindowHandle Me;
var WindowHandle m_hExpandWnd;
var ComboBoxHandle ComboBox1;
var ButtonHandle aBtn;
var ButtonHandle bBtn;
var ButtonHandle CloseButton;
var TextureHandle backgroundtex1;
var TextBoxHandle NCTextBox;
var array<int> ResolutionW;
var array<int> ResolutionH;

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    Initialize();
    load();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(5420);
    RegisterEvent(5430);
    RegisterEvent(5440);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(40);
    return;
}

function Initialize()
{
    Me = GetWindowHandle("MovieCaptureWnd");
    m_hExpandWnd = GetWindowHandle("MovieCaptureWnd_Expand");
    ComboBox1 = GetComboBoxHandle("MovieCaptureWnd.ComboBox1");
    CloseButton = GetButtonHandle("MovieCaptureWnd.CloseButton");
    aBtn = GetButtonHandle("MovieCaptureWnd.aBtn");
    bBtn = GetButtonHandle("MovieCaptureWnd.bBtn");
    backgroundtex1 = GetTextureHandle("MovieCaptureWnd.backgroundtex1");
    NCTextBox = GetTextBoxHandle("MovieCaptureWnd.NCTextBox");
    return;
}

function load()
{
    local string Resolution1, Resolution2;

    ResolutionW[0] = GetDisplayWidth();
    ResolutionH[0] = GetDisplayHeight();
    ResolutionW[1] = ResolutionW[0] / 2;
    ResolutionH[1] = ResolutionH[0] / 2;
    ResolutionW[2] = 640;
    ResolutionH[2] = 480;
    ResolutionW[3] = 480;
    ResolutionH[3] = 320;
    SetMovieCaptureHighQuality();
    SetMovieCaptureResolution(640, 480);
    Class'NWindow.UIAPI_COMBOBOX'.static.AddString("MovieCaptureWnd.ComboBox1", GetSystemString(2452));
    Class'NWindow.UIAPI_COMBOBOX'.static.AddString("MovieCaptureWnd.ComboBox1", GetSystemString(2453));
    Resolution1 = (string(ResolutionW[2]) $ "X") $ string(ResolutionH[2]);
    Resolution2 = (string(ResolutionW[3]) $ "X") $ string(ResolutionH[3]);
    Class'NWindow.UIAPI_COMBOBOX'.static.AddString("MovieCaptureWnd.ComboBox1", Resolution1);
    Class'NWindow.UIAPI_COMBOBOX'.static.AddString("MovieCaptureWnd.ComboBox1", Resolution2);
    Class'NWindow.UIAPI_COMBOBOX'.static.SetSelectedNum("MovieCaptureWnd.ComboBox1", 2);
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x24
        case "aBtn":
            // End:0x21
            if(!IsNowMovieCapturing())
            {
                MovieCaptureToggle();
            }
            // End:0x58
            break;
        // End:0x36
        case "bBtn":
            OpenTheFolder();
            // End:0x58
            break;
        // End:0x55
        case "CloseButton":
            Me.HideWindow();
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleDialogOK()
{
    local int dialogID;

    // End:0x3B
    if(DialogIsMine())
    {
        dialogID = DialogGetID();
        switch(dialogID)
        {
            // End:0x2D
            case 7063:
                OpenMovieCaptureDir();
                // End:0x3B
                break;
            // End:0x38
            case 7064:
                // End:0x3B
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return;
    }
}

function OpenTheFolder()
{
    DialogSetID(7063);
    DialogShow(1, 0, GetSystemMessage(3312), string(self));
    return;
}

function DiskFullMessage()
{
    local string Msg;

    Msg = MakeFullSystemMsg(GetSystemMessage(3310), GetL2Path() $ "/screenshot");
    DialogSetID(7064);
    DialogShow(1, 1, Msg, string(self));
    return;
}

function OnComboBoxItemSelected(string sName, int Index)
{
    switch(sName)
    {
        // End:0x34
        case "ComboBox1":
            SetMovieCaptureResolution(ResolutionW[Index], ResolutionH[Index]);
            // End:0x37
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x23
        case 5420:
            CaptureOnOff();
            AddSystemMessage(3309);
            // End:0xC5
            break;
        // End:0x66
        case 5440:
            CaptureOnOff();
            DiskFullMessage();
            AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(3310), GetL2Path() $ "/screenshot"));
            // End:0xC5
            break;
        // End:0xA3
        case 5430:
            CaptureOnOff();
            AddSystemMessageString(MakeFullSystemMsg(GetSystemMessage(3311), GetL2Path() $ "/screenshot"));
            // End:0xC5
            break;
        // End:0xB4
        case 1710:
            HandleDialogOK();
            // End:0xC5
            break;
        // End:0xC2
        case 40:
            HandleRestart();
            // End:0xC5
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleRestart()
{
    // End:0x0F
    if(IsNowMovieCapturing())
    {
        MovieCaptureToggle();
    }
    return;
}

function CaptureOnOff()
{
    // End:0x85
    if(IsNowMovieCapturing())
    {
        Me.HideWindow();
        m_hExpandWnd.ShowWindow();
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("MovieCaptureWnd", "MovieCaptureWnd_Expand", "TopLeft", "TopLeft", 0, 0);
        m_hExpandWnd.SetFocus();        
    }
    else
    {
        m_hExpandWnd.HideWindow();
        Me.ShowWindow();
        Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("MovieCaptureWnd_Expand", "MovieCaptureWnd", "TopLeft", "TopLeft", 0, 0);
        Me.SetFocus();
    }
    return;
}
