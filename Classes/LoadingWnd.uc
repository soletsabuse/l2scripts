class LoadingWnd extends UICommonAPI;

var string LoadingTexture18;
var string LoadingTextureFree;
var string tipImgTexture;
var TextureHandle blackbillboard;
var TextureHandle loadingtexture;
var TextureHandle reviewTexture;
var string defaultBackgroundTextureStr;
var string defaultBackgroundTextureStr_Classic;
var string defaultBackgroundTextureStr_Arena;

function OnRegisterEvent()
{
    RegisterEvent(170);
    RegisterEvent(2900);
    RegisterEvent(8000);
    return;
}

function OnLoad()
{
    blackbillboard = GetTextureHandle("LoadingWnd.BlackBackTex");
    loadingtexture = GetTextureHandle("LoadingWnd.BackTex");
    reviewTexture = GetTextureHandle("LoadingWnd.ReviewTex");
    reviewTexture.SetTexture(LoadingTextureFree);
    CheckResolution();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local int ServerAgeLimitInt;
    local UIEventManager.EServerAgeLimit ServerAgeLimit;

    // End:0x81
    if(a_EventID == 170)
    {
        // End:0x7E
        if(ParseInt(a_Param, "ServerAgeLimit", ServerAgeLimitInt))
        {
            ServerAgeLimit = byte(ServerAgeLimitInt);
            switch(ServerAgeLimit)
            {
                // End:0x5F
                case 1:
                    reviewTexture.SetTexture(LoadingTexture18);
                    // End:0x7E
                    break;
                // End:0x64
                case 2:
                // End:0xFFFF
                default:
                    reviewTexture.SetTexture(LoadingTextureFree);
                    // End:0x7E
                    break;
                    break;
            }
        }        
    }
    else
    {
        // End:0x99
        if(a_EventID == 2900)
        {
            CheckResolution();            
        }
        else
        {
            // End:0x110
            if(a_EventID == 8000)
            {
                // End:0xD2
                if(getInstanceUIData().getIsClassicServer())
                {
                    loadingtexture.SetTexture(defaultBackgroundTextureStr_Classic);                    
                }
                else
                {
                    // End:0xFC
                    if(getInstanceUIData().getIsArenaServer())
                    {
                        loadingtexture.SetTexture(defaultBackgroundTextureStr_Arena);                        
                    }
                    else
                    {
                        loadingtexture.SetTexture(defaultBackgroundTextureStr);
                    }
                }
            }
        }
    }
    return;
}

function setBackgroundTextureStr(string changeTextureStr)
{
    // End:0x77
    if(changeTextureStr == "")
    {
        // End:0x36
        if(getInstanceUIData().getIsClassicServer())
        {
            loadingtexture.SetTexture(defaultBackgroundTextureStr_Classic);            
        }
        else
        {
            // End:0x60
            if(getInstanceUIData().getIsArenaServer())
            {
                loadingtexture.SetTexture(defaultBackgroundTextureStr_Arena);                
            }
            else
            {
                loadingtexture.SetTexture(defaultBackgroundTextureStr);
            }
        }        
    }
    else
    {
        loadingtexture.SetTexture(changeTextureStr);
    }
    return;
}

function CheckResolution()
{
    local int CurrentMaxWidth, CurrentMaxHeight;

    GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
    blackbillboard.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
    loadingtexture.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
    loadingtexture.SetAnchor("LoadingWnd", "CenterCenter", "CenterCenter", 0, 0);
    loadingtexture.SetWindowSizeRel43(1.0000000, 1.0000000, 0, 0);
    reviewTexture.SetWindowSize(CurrentMaxWidth, CurrentMaxHeight);
    reviewTexture.SetAnchor("LoadingWnd", "CenterCenter", "CenterCenter", 0, 0);
    reviewTexture.SetWindowSizeRel43(1.0000000, 1.0000000, 0, 0);
    return;
}

defaultproperties
{
    LoadingTexture18="L2Font.skins.loading04-k"
    LoadingTextureFree="L2Font.skins.loading02-k"
    defaultBackgroundTextureStr="L2Font.Loading_Default_0000_001"
    defaultBackgroundTextureStr_Classic="L2Font.Loading_Default_0000_C001"
    defaultBackgroundTextureStr_Arena="L2Font.Loading_Default_0000_A001"
}