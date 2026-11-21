class PlayerGameplayWnd extends UICommonAPI;

const CMD_MAX = 9;
const RMODE_DEFAULT = 5;

enum EGameplayCommand
{
    GC_FOG,                         // 0
    GC_SKY,                         // 1
    GC_EFFECTS,                     // 2
    GC_CORONAS,                     // 3
    GC_FPS,                         // 4
    GC_HIDENAME,                    // 5
    GC_RMODE,                       // 6
    GC_FPSLIMIT,                    // 7
    GC_SKILLANIM,                   // 8
    GC_MAX                          // 9
};

var int bEnabled[9];
var string Command[9];
var string CommandName[9];
var string CommandDesc[9];
var string m_WindowName;
var bool bSessionCmdRestored;
var int nCurrentRMode;

function OnRegisterEvent()
{
    RegisterEvent(150);
    RegisterEvent(160);
    RegisterEvent(1710);
    return;
}

function OnEvent(int EventID, string param)
{
    local int Id;

    switch(EventID)
    {
        // End:0x0C
        case 150:
        // End:0x1A
        case 160:
            RestoreToggleStates();
            // End:0x55
            break;
        // End:0x4F
        case 1710:
            // End:0x4C
            if(DialogIsMine())
            {
                Id = DialogGetID();
                // End:0x4C
                if(Id == 236767867)
                {
                    clearGame();
                }
            }
            // End:0x55
            break;
        // End:0xFFFF
        default:
            // End:0x55
            break;
            break;
    }
    return;
}

function OnLoad()
{
    local int i;
    local string WindowHandle;

    m_WindowName = getCurrentWindowName(string(self));
    SetClosingOnESC();
    m_hOwnerWnd.SetAlpha(150);
    nCurrentRMode = 5;
    initStrings();
    Command[0] = "show fog";
    Command[1] = "show sky";
    Command[2] = "show particles";
    Command[3] = "show coronas";
    Command[4] = "stat fps";
    Command[5] = "hidename";
    Command[6] = "rmode";
    Command[7] = "";
    Command[8] = "";
    GetWindowHandle("PlayerGameplayWnd.Container00.ShortcutKey").SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemString(7985), "Z")));
    GetWindowHandle("PlayerGameplayWnd.Container01.ShortcutKey").SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemString(7985), "X")));
    GetWindowHandle("PlayerGameplayWnd.Container02.ShortcutKey").SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemString(7985), "C")));
    GetWindowHandle("PlayerGameplayWnd.Container03.ShortcutKey").SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemString(7985), "V")));
    GetWindowHandle("PlayerGameplayWnd.Container04.ShortcutKey").SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemString(7985), "B")));
    GetWindowHandle("PlayerGameplayWnd.Container05.ShortcutKey").SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemString(7985), "N")));
    GetWindowHandle("PlayerGameplayWnd.Container06.ShortcutKey").SetTooltipCustomType(MakeTooltipSimpleText(MakeFullSystemMsg(GetSystemString(7985), "M")));
    LoadToggleStates();
    i = 0;
    J0x334:

    // End:0x363 [Loop If]
    if(i < 9)
    {
        Initialize(i, bEnabled[i] == 1);
        i++;
        // [Loop Continue]
        goto J0x334;
    }
    // End:0x384
    if(bEnabled[7] == 1)
    {
        Class'NWindow.FpsLimitAPI'.static.SetFpsLimitEnabled(true);        
    }
    else
    {
        Class'NWindow.FpsLimitAPI'.static.SetFpsLimitEnabled(false);
    }
    // End:0x3B5
    if(bEnabled[8] == 1)
    {
        Class'NWindow.SkillAnimSwapAPI'.static.SetSkillAnimEnabled(true);        
    }
    else
    {
        Class'NWindow.SkillAnimSwapAPI'.static.SetSkillAnimEnabled(false);
    }
    return;
}

function Initialize(int Id, bool Enabled)
{
    local string ButtonHandle;

    ButtonHandle = (("PlayerGameplayWnd.Container" $ getInstanceL2Util().makeZeroString(2, (Id))) $ ".OnOffBtn") $ getInstanceL2Util().makeZeroString(2, (Id));
    // End:0xD5
    if(Enabled)
    {
        GetButtonHandle(ButtonHandle).SetTexture("L2UI_NewTex.L2PassWnd.On", "L2UI_NewTex.L2PassWnd.On", "L2UI_NewTex.L2PassWnd.On");        
    }
    else
    {
        GetButtonHandle(ButtonHandle).SetTexture("L2UI_NewTex.L2PassWnd.Off", "L2UI_NewTex.L2PassWnd.Off", "L2UI_NewTex.L2PassWnd.Off");
    }
    return;
}

function LoadToggleStates()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x46 [Loop If]
    if(i < 9)
    {
        // End:0x2F
        if(i < 4)
        {
            bEnabled[i] = 1;
            // [Explicit Continue]
            goto J0x3C;
        }
        bEnabled[i] = 0;
        J0x3C:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    GetINIInt("Cfg", "AnimMaster", bEnabled[8], "SkillFx.ini");
    i = 0;
    J0x79:

    // End:0xC2 [Loop If]
    if(i < 8)
    {
        GetINIInt("Toggles", GetToggleKey(i), bEnabled[i], "Gameplay.ini");
        i++;
        // [Loop Continue]
        goto J0x79;
    }
    return;
}

function SaveToggle(int Id)
{
    // End:0x3B
    if(Id == 8)
    {
        SetINIInt("Cfg", "AnimMaster", bEnabled[8], "SkillFx.ini");        
    }
    else
    {
        SetINIInt("Toggles", GetToggleKey(Id), bEnabled[Id], "Gameplay.ini");
    }
    return;
}

function string GetToggleKey(int Id)
{
    switch(Id)
    {
        // End:0x11
        case 0:
            return "Fog";
        // End:0x1B
        case 1:
            return "Sky";
        // End:0x2A
        case 2:
            return "Effects";
        // End:0x39
        case 3:
            return "Coronas";
        // End:0x44
        case 4:
            return "Fps";
        // End:0x54
        case 5:
            return "HideName";
        // End:0x61
        case 6:
            return "Rmode";
        // End:0x71
        case 7:
            return "FpsLimit";
        // End:0xFFFF
        default:
            return "Toggle" $ string(Id);
            break;
    }
    return;
}

function RestoreToggleStates()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x3F [Loop If]
    if(i < 4)
    {
        // End:0x35
        if(bEnabled[i] == 0)
        {
            execute(Command[i]);
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x64
    if(bEnabled[6] == 1)
    {
        nCurrentRMode = 1;
        execute("rmode", "1");
    }
    // End:0xAF
    if(!bSessionCmdRestored)
    {
        bSessionCmdRestored = true;
        // End:0x93
        if(bEnabled[4] == 1)
        {
            execute(Command[4]);
        }
        // End:0xAF
        if(bEnabled[5] == 1)
        {
            execute(Command[5]);
        }
    }
    return;
}

function OnMouseOver(WindowHandle W)
{
    m_hOwnerWnd.SetAlpha(255, 0.2500000);
    return;
}

function OnMouseOut(WindowHandle W)
{
    m_hOwnerWnd.SetAlpha(100, 0.5000000);
    return;
}

function OnClickButton(string strID)
{
    local int containerId;

    // End:0x46
    if(InStr(strID, "OnOffBtn") > -1)
    {
        containerId = int(Locs(strID, "OnOffBtn", "", true));
        toggleButton(containerId, false);        
    }
    else
    {
        // End:0x87
        if(strID == "CacheControlBtn")
        {
            DialogSetID(236767867);
            DialogShow(0, 0, GetSystemString(7947), string(self));            
        }
        else
        {
            // End:0xC4
            if(strID == "SkillFxGearBtn")
            {
                GetWindowHandle("SkillEffectWnd").ShowWindow();                
            }
            else
            {
                // End:0xDE
                if(strID == "CloseBtn")
                {
                    OnReceivedCloseUI();
                }
            }
        }
    }
    return;
}

function toggleButton(int Id, bool bOnlyButtonTexuture)
{
    local string Cmd, arg, ButtonHandle;

    ButtonHandle = (("PlayerGameplayWnd.Container" $ getInstanceL2Util().makeZeroString(2, (Id))) $ ".OnOffBtn") $ getInstanceL2Util().makeZeroString(2, (Id));
    // End:0xED
    if(bEnabled[Id] > 0)
    {
        bEnabled[Id] = 0;
        GetButtonHandle(ButtonHandle).SetTexture("L2UI_NewTex.L2PassWnd.Off", "L2UI_NewTex.L2PassWnd.Off", "L2UI_NewTex.L2PassWnd.Off");        
    }
    else
    {
        bEnabled[Id] = 1;
        GetButtonHandle(ButtonHandle).SetTexture("L2UI_NewTex.L2PassWnd.On", "L2UI_NewTex.L2PassWnd.On", "L2UI_NewTex.L2PassWnd.On");
    }
    // End:0x168
    if(bOnlyButtonTexuture)
    {
        return;
    }
    SaveToggle(Id);
    switch(Id)
    {
        // End:0x1B2
        case 7:
            // End:0x1A0
            if(bEnabled[7] == 1)
            {
                Class'NWindow.FpsLimitAPI'.static.SetFpsLimitEnabled(true);                
            }
            else
            {
                Class'NWindow.FpsLimitAPI'.static.SetFpsLimitEnabled(false);
            }
            return;
        // End:0x1EA
        case 8:
            // End:0x1D8
            if(bEnabled[8] == 1)
            {
                Class'NWindow.SkillAnimSwapAPI'.static.SetSkillAnimEnabled(true);                
            }
            else
            {
                Class'NWindow.SkillAnimSwapAPI'.static.SetSkillAnimEnabled(false);
            }
            return;
        // End:0xFFFF
        default:
            // End:0x1F0
            break;
            break;
    }
    // End:0x248
    if(Command[Id] == "rmode")
    {
        // End:0x21F
        if(bEnabled[6] == 1)
        {
            nCurrentRMode = 1;            
        }
        else
        {
            nCurrentRMode = 5;
        }
        Cmd = Command[Id];
        arg = string(nCurrentRMode);        
    }
    else
    {
        Cmd = Command[Id];
        arg = "";
    }
    execute(Cmd, arg);
    return;
}

function execute(string Cmd, optional string arg)
{
    local string Command;

    // End:0x52
    if(Left(Cmd, Len("///stat script")) == "///stat script")
    {
        // End:0x52
        if(Left(Cmd, Len("///crash")) == "///crash")
        {
            return;
        }
    }
    // End:0x73
    if(arg != "")
    {
        Command = Cmd @ arg;        
    }
    else
    {
        Command = Cmd;
    }
    Class'NWindow.UIDATA_PAWNVIEWER'.static.ExecuteCommand(Command);
    return;
}

function clearGame()
{
    execute("FLUSH");
    execute("OBJ GARBAGE");
    return;
}

function initStrings()
{
    local int i;

    CommandName[0] = GetSystemString(7928);
    CommandDesc[0] = GetSystemString(7929);
    CommandName[1] = GetSystemString(7930);
    CommandDesc[1] = GetSystemString(7931);
    CommandName[2] = GetSystemString(7932);
    CommandDesc[2] = GetSystemString(7933);
    CommandName[3] = GetSystemString(7934);
    CommandDesc[3] = GetSystemString(7935);
    CommandName[4] = GetSystemString(7936);
    CommandDesc[4] = GetSystemString(7937);
    CommandName[5] = GetSystemString(7938);
    CommandDesc[5] = GetSystemString(7939);
    CommandName[6] = GetSystemString(7940);
    CommandDesc[6] = GetSystemString(7941);
    CommandName[7] = GetSystemString(9028);
    CommandDesc[7] = GetSystemString(9029);
    CommandName[8] = GetSystemString(9030);
    CommandDesc[8] = GetSystemString(9031);
    i = 0;
    J0x16B:

    // End:0x24D [Loop If]
    if(i < 9)
    {
        GetTextBoxHandle(("PlayerGameplayWnd.Container" $ getInstanceL2Util().makeZeroString(2, (i))) $ ".CommandNameTxt").SetText(CommandName[i]);
        GetTextBoxHandle(("PlayerGameplayWnd.Container" $ getInstanceL2Util().makeZeroString(2, (i))) $ ".CommandDescTxt").SetText(CommandDesc[i]);
        i++;
        // [Loop Continue]
        goto J0x16B;
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    m_hOwnerWnd.HideWindow();
    return;
}
