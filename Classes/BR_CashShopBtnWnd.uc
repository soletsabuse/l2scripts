class BR_CashShopBtnWnd extends UICommonAPI;

const TIMER_ID = 1410;
const TIMER_DELAY = 500;

var WindowHandle Me;
var ButtonHandle BtnShowCashShop;
var WindowHandle Drawer;
var TextureHandle TexPrime_panel_new;
var array<string> m_UI_prime_panel_new;
var int m_currentAnim;
var bool m_newAnim;
var int m_SubJobClassID;

function OnRegisterEvent()
{
    RegisterEvent(9015);
    RegisterEvent(5312);
    RegisterEvent(40);
    return;
}

function OnLoad()
{
    RegisterState("BR_CashShopBtnWnd", "TRAININGROOMSTATE");
    InitHandle();
    load();
    return;
}

function InitHandle()
{
    // End:0x88
    if(1 == 0)
    {
        Me = GetHandle("BR_CashShopBtnWnd");
        BtnShowCashShop = ButtonHandle(GetHandle("BR_CashShopBtnWnd.BtnShowCashShop"));
        TexPrime_panel_new = TextureHandle(GetHandle("BR_CashShopBtnWnd.TexNew"));        
    }
    else
    {
        Me = GetWindowHandle("BR_CashShopBtnWnd");
        BtnShowCashShop = GetButtonHandle("BR_CashShopBtnWnd.BtnShowCashShop");
        TexPrime_panel_new = GetTextureHandle("BR_CashShopBtnWnd.TexNew");
    }
    m_UI_prime_panel_new.Length = 2;
    m_UI_prime_panel_new[0] = "BranchSys3.ui.g_ui_prime_button_new_ani1";
    m_UI_prime_panel_new[1] = "BranchSys3.ui.g_ui_prime_button_new_ani2";
    m_currentAnim = 0;
    m_SubJobClassID = 0;
    m_newAnim = false;
    TexPrime_panel_new.HideWindow();
    return;
}

function load()
{
    RequestBR_CashShopNewICon();
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int iResult, bShow;

    bShow = 0;
    GetINIBool("PrimeShop", "UsePrimeShop", bShow, "L2.ini");
    switch(Event_ID)
    {
        // End:0x8A
        case 9015:
            ParseInt(param, "NewIConAnim", iResult);
            // End:0x87
            if(iResult > 0)
            {
                TexPrime_panel_new.ShowWindow();
                m_newAnim = true;
                PlayAnimation();
            }
            // End:0x112
            break;
        // End:0xFD
        case 5312:
            // End:0xFA
            if(param != "")
            {
                ParseInt(param, "CurrentSubjobClassID", m_SubJobClassID);
                // End:0xFA
                if(!getInstanceL2Util().getIsPrologueGrowType(m_SubJobClassID) && bShow == 1)
                {
                    Me.ShowWindow();
                }
            }
            // End:0x112
            break;
        // End:0x10C
        case 40:
            m_SubJobClassID = 0;
            // End:0x112
            break;
        // End:0xFFFF
        default:
            // End:0x112
            break;
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x24
        case "BtnShowCashShop":
            OnBtnShowCashShopClick();
            // End:0x27
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnBtnShowCashShopClick()
{
    local string BR_NewCashShop;

    BR_NewCashShop = "BR_NewCashShopWnd";
    // End:0x5E
    if(IsShowWindow(BR_NewCashShop))
    {
        HideWindow(BR_NewCashShop);
        PlaySound("InterfaceSound.inventory_close_01");        
    }
    else
    {
        ExecuteEvent(9010);
        PlaySound("InterfaceSound.inventory_open_01");
        m_newAnim = false;
        TexPrime_panel_new.HideWindow();
    }
    return;
}

function OnShow()
{
    local int bShow;
    local bool bIsGrow;

    bShow = 0;
    GetINIBool("PrimeShop", "UsePrimeShop", bShow, "L2.ini");
    bIsGrow = getInstanceL2Util().checkIsPrologueGrowType(string(self));
    // End:0x6A
    if((m_SubJobClassID == 0) && bIsGrow)
    {
        bShow = 0;
    }
    // End:0x99
    if((bShow == 0) || getInstanceUIData().getIsClassicServer())
    {
        Me.HideWindow();
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x0E
    if(m_newAnim == false)
    {
        return;
    }
    // End:0x6D
    if(TimerID == 1410)
    {
        // End:0x4C
        if(m_currentAnim == 0)
        {
            m_currentAnim = 1;
            TexPrime_panel_new.SetTexture(m_UI_prime_panel_new[m_currentAnim]);            
        }
        else
        {
            m_currentAnim = 0;
            TexPrime_panel_new.SetTexture(m_UI_prime_panel_new[m_currentAnim]);
        }
    }
    return;
}

function PlayAnimation()
{
    // End:0x39
    if(m_newAnim)
    {
        Me.KillTimer(1410);
        Me.SetTimer(1410, 500);        
    }
    else
    {
        Me.KillTimer(1410);
    }
    return;
}
