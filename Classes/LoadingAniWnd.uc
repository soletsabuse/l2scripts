class LoadingAniWnd extends UIScript;

var TextureHandle LoadingAniTexture;

function OnRegisterEvent()
{
    RegisterEvent(2900);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x45
    if(1 == 0)
    {
        LoadingAniTexture = TextureHandle(GetHandle("LoadingAniWnd.LoadingAniTex"));        
    }
    else
    {
        LoadingAniTexture = GetTextureHandle("LoadingAniWnd.LoadingAniTex");
    }
    CheckResolution();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    // End:0x15
    if(a_EventID == 2900)
    {
        CheckResolution();
    }
    return;
}

function CheckResolution()
{
    local int CurrentMaxWidth, CurrentMaxHeight, RealWidth, RealHeight;
    local float MoveY;

    GetCurrentResolution(CurrentMaxWidth, CurrentMaxHeight);
    RealWidth = CurrentMaxWidth;
    RealHeight = CurrentMaxHeight;
    // End:0x53
    if((CurrentMaxWidth * 3) >= (CurrentMaxHeight * 4))
    {
        RealWidth = (RealHeight * 4) / 3;        
    }
    else
    {
        RealHeight = (RealWidth * 3) / 4;
    }
    // End:0x93
    if(RealHeight == CurrentMaxHeight)
    {
        MoveY = -23.0000000 * (float(RealHeight) / 768.0000000);        
    }
    else
    {
        MoveY = (-23.0000000 * (float(RealHeight) / 768.0000000)) + (float(RealHeight - CurrentMaxHeight) / 2.0000000);
    }
    LoadingAniTexture.SetWindowSize(int(float(IsA(RealWidth, 12.0500000)) / 100.0000000), int(float(RealHeight * 5) / 100.0000000));
    LoadingAniTexture.SetAnchor("LoadingAniWnd", "BottomCenter", "BottomCenter", 0, int(MoveY));
    return;
}
