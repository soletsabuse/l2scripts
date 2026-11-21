class ArenaPickWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterEvent(3410);
    RegisterGFxEvent(8340);
    RegisterGFxEvent(8350);
    RegisterGFxEvent(8360);
    RegisterGFxEvent(8370);
    return;
}

function OnLoad()
{
    AddState("ARENAPICKSTATE");
    SetContainerHUD("SimpleNoBg", 0);
    SetDefaultShow(true);
    SetHavingFocus(false);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x38
    if(Event_ID == 3410)
    {
        // End:0x32
        if(param == "ARENAPICKSTATE")
        {
            ShowWindow();            
        }
        else
        {
            HideWindow();
        }
    }
    return;
}

function OnFlashLoaded()
{
    SetAnchor("", 5, 5, 0, 0);
    return;
}
