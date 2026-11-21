class AgeWnd extends UICommonAPI;

const TIMER_ID = 148;
const TIMER_DELAY = 5000;
const TIMER_ID2 = 149;
const TIMER_DELAY2 = 600000;

var WindowHandle Me;
var TextureHandle AgeTex;
var WindowHandle HelpHtmlWnd;
var string Texture15;
var string Texture18;
var string TextureFree;
var string HelpTexture15;
var string HelpTexture18;
var string HelpTextureFree;
var bool bBlock;

function OnRegisterEvent()
{
    RegisterEvent(170);
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
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x4B
    if(1 == 0)
    {
        Me = GetHandle("AgeWnd");
        AgeTex = TextureHandle(GetHandle("AgeWnd.AgeTex"));        
    }
    else
    {
        Me = GetWindowHandle("AgeWnd");
        AgeTex = GetTextureHandle("AgeWnd.AgeTex");
    }
    bBlock = false;
    return;
}

function load()
{
    Texture15 = "L2Font.Skins.kr_rated_15";
    Texture18 = "L2Font.Skins.kr_rated_18";
    TextureFree = "";
    HelpTexture15 = "L2Font.Skins.Help_Age_15";
    HelpTexture18 = "L2Font.Skins.Help_Age_18";
    HelpTextureFree = "";
    return;
}

function OnEnterState(name a_PrevStateName)
{
    // End:0x20
    if(a_PrevStateName == 'LoadingState')
    {
        // End:0x20
        if(!bBlock)
        {
            startAge();
        }
    }
    return;
}

function startAge()
{
    Me.ShowWindow();
    AgeTex.ShowWindow();
    Me.SetTimer(148, 5000);
    bBlock = true;
    Me.SetTimer(149, 600000);
    return;
}

function OnTimer(int TimerID)
{
    // End:0x2F
    if(TimerID == 148)
    {
        Me.HideWindow();
        Me.KillTimer(148);        
    }
    else
    {
        // End:0x54
        if(TimerID == 149)
        {
            bBlock = false;
            Me.KillTimer(149);
        }
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local int ServerAgeLimitInt;
    local UIEventManager.EServerAgeLimit ServerAgeLimit;
    local int GlobalVersion;

    // End:0xDA
    if(a_EventID == 170)
    {
        ParseInt(a_Param, "ServerAgeLimit", ServerAgeLimitInt);
        ParseInt(a_Param, "GlobalVersion", GlobalVersion);
        // End:0x60
        if(GlobalVersion > 0)
        {
            bBlock = true;
            return;
        }
        ServerAgeLimit = byte(ServerAgeLimitInt);
        switch(ServerAgeLimit)
        {
            // End:0x90
            case 0:
                AgeTex.SetTexture(Texture15);
                // End:0xDA
                break;
            // End:0xAC
            case 1:
                AgeTex.SetTexture(Texture18);
                // End:0xDA
                break;
            // End:0xB1
            case 2:
            // End:0xFFFF
            default:
                AgeTex.SetTexture(TextureFree);
                AgeTex.HideWindow();
                // End:0xDA
                break;
                break;
        }
    }
    return;
}
