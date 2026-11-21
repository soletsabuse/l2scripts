class IngameShopBtnWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(9015);
    RegisterGFxEvent(20150);
    RegisterEvent(20150);
    RegisterEvent(3410);
    return;
}

function OnLoad()
{
    SetContainerWindow("SimpleDragWindow", 0);
    AddState("GAMINGSTATE");
    SetHavingFocus(false);
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x2C
        case 3410:
            // End:0x2C
            if(param == "GAMINGSTATE")
            {
                checkNShowWindow();
            }
        // End:0xFFFF
        default:
            return;
            break;
    }
}

function checkNShowWindow()
{
    local int bIsClassicShow;

    // End:0x3F
    if(!GetINIBool("PrimeShop", "UseClassicPrimeShop", bIsClassicShow, "L2.ini"))
    {
        bIsClassicShow = 0;
    }
    // End:0x7A
    if((bIsClassicShow == 1) && getInstanceUIData().getIsClassicServer())
    {
        ShowWindow("IngameShopBtnWnd");        
    }
    else
    {
        HideWindow("IngameShopBtnWnd");
    }
    return;
}
