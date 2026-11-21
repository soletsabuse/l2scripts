class PlayerAgeWnd extends UIScript;

function OnLoad()
{
    SetClosingOnESC();
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("PlayerAgeWnd").HideWindow();
    return;
}
