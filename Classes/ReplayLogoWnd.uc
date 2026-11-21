class ReplayLogoWnd extends UIScript;

var string m_strLineage2LogoTexture;
var string m_strMiniLogoTexture;

function OnLoad()
{
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ReplayLogoWnd.textureLogoTitle", m_strLineage2LogoTexture);
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("ReplayLogoWnd.textureLogoSubtitle", m_strMiniLogoTexture);
    return;
}

defaultproperties
{
    m_strLineage2LogoTexture="L2Font.replay_logo-k"
    m_strMiniLogoTexture="L2Font.start_minilogo-k"
}