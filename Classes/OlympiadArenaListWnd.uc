class OlympiadArenaListWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterEvent(5080);
    return;
}

function OnEvent(int EventID, string param)
{
    // End:0x3F
    if(EventID == 5080)
    {
        OlyArenaListWnd(GetScript("OlyArenaListWnd")).OnEvent(EventID, param);
    }
    return;
}
