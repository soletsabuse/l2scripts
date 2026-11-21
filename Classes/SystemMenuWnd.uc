class SystemMenuWnd extends UICommonAPI;

const DIALOGID_Gohome = 0;

var string m_WindowName;
var WindowHandle m_hOptionWnd;
var WindowHandle m_hUserPetitionWnd;
var WindowHandle m_hNewUserPetitionWnd;
var WindowHandle m_hMovieCaptureWnd;
var WindowHandle m_hArchiveViewWnd;
var WindowHandle m_hMovieCaptureWnd_Expand;
var WindowHandle PostBoxWnd;
var WindowHandle W24HzWnd;
var TextBoxHandle m_hTbBBS;
var TextBoxHandle m_hTbMacro;
var int IsPeaceZone;

function OnRegisterEvent()
{
    RegisterEvent(1900);
    RegisterEvent(110);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x14C
    if(1 == 0)
    {
        m_hArchiveViewWnd = GetHandle("ArchiveViewWnd");
        m_hMovieCaptureWnd = GetHandle("MovieCaptureWnd");
        m_hMovieCaptureWnd_Expand = GetHandle("MovieCaptureWnd_Expand");
        m_hOptionWnd = GetHandle("OptionWnd");
        m_hUserPetitionWnd = GetHandle("UserPetitionWnd");
        m_hNewUserPetitionWnd = GetHandle("NewUserPetitionWnd");
        m_hTbBBS = TextBoxHandle(GetHandle("SystemMenuWnd.txtBBS"));
        m_hTbMacro = TextBoxHandle(GetHandle("SystemMenuWnd.txtMacro"));
        PostBoxWnd = GetHandle("PostBoxWnd");
        W24HzWnd = GetHandle("W24HzWnd");        
    }
    else
    {
        m_hArchiveViewWnd = GetWindowHandle("ArchiveViewWnd");
        m_hMovieCaptureWnd = GetWindowHandle("MovieCaptureWnd");
        m_hMovieCaptureWnd_Expand = GetWindowHandle("MovieCaptureWnd_Expand");
        m_hOptionWnd = GetWindowHandle("OptionWnd");
        m_hUserPetitionWnd = GetWindowHandle("UserPetitionWnd");
        m_hNewUserPetitionWnd = GetWindowHandle("NewUserPetitionWnd");
        m_hTbBBS = GetTextBoxHandle("SystemMenuWnd.txtBBS");
        m_hTbMacro = GetTextBoxHandle("SystemMenuWnd.txtMacro");
        PostBoxWnd = GetWindowHandle("PostBoxWnd");
        W24HzWnd = GetWindowHandle("W24HzWnd");
    }
    SetMenuString();
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1F
        case "btnArchive":
            HandlebtnArchive();
            // End:0x150
            break;
        // End:0x43
        case "btnPersonalConnections":
            HandlePersonalConnectionsWnd();
            // End:0x150
            break;
        // End:0x58
        case "btnPost":
            HandleShowPostBoxWnd();
            // End:0x150
            break;
        // End:0x6C
        case "btnBBS":
            HandleShowBoardWnd();
            // End:0x150
            break;
        // End:0x82
        case "btnMacro":
            HandleShowMacroListWnd();
            // End:0x150
            break;
        // End:0x9F
        case "btnMovieCapture":
            HandleShowMovieCaptureWnd();
            // End:0x150
            break;
        // End:0xB8
        case "btnHelpHtml":
            HandleShowHelpHtmlWnd();
            // End:0x150
            break;
        // End:0xCD
        case "btn24hz":
            W24HzShowWnd();
            // End:0x150
            break;
        // End:0xE6
        case "btnPetition":
            HandleShowPetitionBegin();
            // End:0x150
            break;
        // End:0xFD
        case "btnOption":
            HandleShowOptionWnd();
            // End:0x150
            break;
        // End:0x116
        case "btnHomepage":
            linkHomePage();
            // End:0x150
            break;
        // End:0x133
        case "btnRestart":
            ExecuteEvent(3350);
            // End:0x150
            break;
        // End:0x14D
        case "btnQuit":
            ExecuteEvent(3340);
            // End:0x150
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandlebtnArchive()
{
    Debug("HandlebtnArchive button clicked");
    ExecuteEvent(5590);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int zonetype;

    // End:0x18
    if(Event_ID == 1900)
    {
        SetMenuString();        
    }
    else
    {
        // End:0x5E
        if(Event_ID == 110)
        {
            ParseInt(param, "ZoneCode", zonetype);
            // End:0x54
            if(zonetype == 12)
            {
                IsPeaceZone = 1;                
            }
            else
            {
                IsPeaceZone = 0;
            }            
        }
        else
        {
            // End:0x76
            if(Event_ID == 1710)
            {
                HandleDialogOK();                
            }
            else
            {
                // End:0x85
                if(Event_ID == 1720)
                {
                }
            }
        }
    }
    return;
}

function HandlePersonalConnectionsWnd()
{
    // End:0x56
    if(GetWindowHandle("PersonalConnectionsWnd").IsShowWindow())
    {
        GetWindowHandle("PersonalConnectionsWnd").HideWindow();        
    }
    else
    {
        GetWindowHandle("PersonalConnectionsWnd").ShowWindow();
        GetWindowHandle("PersonalConnectionsWnd").SetFocus();
    }
    return;
}

function linkHomePage()
{
    DialogSetID(0);
    DialogShow(1, 0, GetSystemMessage(3208), string(self));
    return;
}

function HandleDialogOK()
{
    // End:0x0D
    if(!DialogIsMine())
    {
        return;
    }
    switch(DialogGetID())
    {
        // End:0x22
        case 0:
            OpenL2Home();
            // End:0x25
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function W24HzShowWnd()
{
    // End:0x2C
    if(W24HzWnd.IsShowWindow())
    {
        PlayConsoleSound(6);
        W24HzWnd.HideWindow();        
    }
    else
    {
        PlayConsoleSound(5);
        W24HzWnd.ShowWindow();
        W24HzWnd.SetFocus();
    }
    return;
}

function HandleShowPostBoxWnd()
{
    // End:0x24
    if(PostBoxWnd.IsShowWindow())
    {
        PostBoxWnd.HideWindow();        
    }
    else
    {
        RequestRequestReceivedPostList();
        // End:0x40
        if(IsPeaceZone == 0)
        {
            AddSystemMessage(3066);
        }
    }
    return;
}

function HandleShowBoardWnd()
{
    local string strParam;

    ParamAdd(strParam, "Init", "1");
    ExecuteEvent(1190, strParam);
    return;
}

function HandleShowHelpHtmlWnd()
{
    local AgeWnd script1;
    local string strParam;

    ParamAdd(strParam, "FilePath", "..\\L2text\\help.htm");
    ExecuteEvent(1210, strParam);
    script1 = AgeWnd(GetScript("AgeWnd"));
    // End:0x76
    if(script1.bBlock == false)
    {
        script1.startAge();
    }
    return;
}

function HandleShowMacroListWnd()
{
    ExecuteEvent(1230);
    return;
}

function HandleShowMovieCaptureWnd()
{
    local bool tmpBool;

    tmpBool = IsNowMovieCapturing();
    // End:0x7A
    if(tmpBool)
    {
        m_hMovieCaptureWnd.HideWindow();
        // End:0x51
        if(m_hMovieCaptureWnd_Expand.IsShowWindow())
        {
            PlayConsoleSound(6);
            m_hMovieCaptureWnd_Expand.HideWindow();            
        }
        else
        {
            PlayConsoleSound(5);
            m_hMovieCaptureWnd_Expand.ShowWindow();
            m_hMovieCaptureWnd_Expand.SetFocus();
        }        
    }
    else
    {
        // End:0xA6
        if(m_hMovieCaptureWnd.IsShowWindow())
        {
            PlayConsoleSound(6);
            m_hMovieCaptureWnd.HideWindow();            
        }
        else
        {
            PlayConsoleSound(5);
            m_hMovieCaptureWnd.ShowWindow();
            m_hMovieCaptureWnd.SetFocus();
        }
    }
    return;
}

function HandleShowPetitionBegin()
{
    local WindowHandle win, win1, win2;
    local UIScript.PetitionMethod useNewPetition;

    win = GetWindowHandle("NewUserPetitionWnd");
    win1 = GetWindowHandle("UserPetitionWnd");
    win2 = GetWindowHandle("WebPetitionWnd");
    useNewPetition = GetPetitionMethod();
    // End:0xB2
    if(int(useNewPetition) == int(1))
    {
        // End:0xA1
        if(win.IsShowWindow())
        {
            PlayConsoleSound(6);
            win.HideWindow();            
        }
        else
        {
            PlayConsoleSound(5);
            RequestShowPetitionAsMethod();
        }        
    }
    else
    {
        // End:0x117
        if(int(useNewPetition) == int(0))
        {
            // End:0xEE
            if(win1.IsShowWindow())
            {
                PlayConsoleSound(6);
                win1.HideWindow();                
            }
            else
            {
                PlayConsoleSound(5);
                win1.ShowWindow();
                win1.SetFocus();
            }            
        }
        else
        {
            // End:0x161
            if(int(useNewPetition) == int(2))
            {
                // End:0x153
                if(win2.IsShowWindow())
                {
                    PlayConsoleSound(6);
                    win2.HideWindow();                    
                }
                else
                {
                    PlayConsoleSound(5);
                    RequestShowPetitionAsMethod();
                }
            }
        }
    }
    return;
}

function HandleShowOptionWnd()
{
    // End:0x2C
    if(m_hOptionWnd.IsShowWindow())
    {
        PlayConsoleSound(6);
        m_hOptionWnd.HideWindow();        
    }
    else
    {
        PlayConsoleSound(5);
        m_hOptionWnd.ShowWindow();
        m_hOptionWnd.SetFocus();
    }
    return;
}

function SetMenuString()
{
    m_hTbBBS.SetText(GetSystemString(387) $ "(Alt+B)");
    m_hTbMacro.SetText(GetSystemString(711) $ "(Alt+R)");
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="SystemMenuWnd"
}