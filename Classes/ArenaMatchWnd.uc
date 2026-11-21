class ArenaMatchWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterEvent(3410);
    RegisterGFxEvent(8300);
    RegisterGFxEvent(8310);
    RegisterGFxEvent(8320);
    RegisterGFxEvent(8330);
    RegisterGFxEvent(4915);
    RegisterGFxEvent(4919);
    RegisterGFxEvent(4918);
    RegisterGFxEvent(1140);
    RegisterGFxEvent(1170);
    return;
}

function OnLoad()
{
    AddState("ARENAGAMINGSTATE");
    SetContainerHUD("none", 0);
    SetHUD();
    SetDefaultShow(true);
    SetHavingFocus(false);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0xE5
    if(Event_ID == 3410)
    {
        // End:0x6A
        if(param == "ARENAGAMINGSTATE")
        {
            ShowWindow();
            GetWindowHandle("ChatWnd").ShowWindow();
            GetWindowHandle("ShortcutWnd").ShowWindow();            
        }
        else
        {
            // End:0x8D
            if(param == "ARENAPICKSTATE")
            {
                HideWindow();                
            }
            else
            {
                // End:0xE5
                if(param == "ARENABATTLESTATE")
                {
                    GetWindowHandle("ChatWnd").ShowWindow();
                    GetWindowHandle("ShortcutWnd").ShowWindow();
                    HideWindow();
                }
            }
        }
    }
    return;
}

function OnFlashLoaded()
{
    SetAnchor("", 8, 2, 0, -248);
    return;
}
