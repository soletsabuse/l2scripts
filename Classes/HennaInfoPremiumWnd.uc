class HennaInfoPremiumWnd extends UICommonAPI;

const HENNA_EQUIP = 1;
const HENNA_UNEQUIP = 2;

var int m_iState;
var int m_iHennaID;

function OnRegisterEvent()
{
    RegisterEvent(1661);
    RegisterEvent(1691);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    return;
}

function OnClickButton(string strID)
{
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoPremiumWnd");
    switch(strID)
    {
        // End:0x60
        case "btnPrev":
            // End:0x4B
            if(m_iState == 1)
            {
                RequestHennaItemList();                
            }
            else
            {
                // End:0x5D
                if(m_iState == 2)
                {
                    RequestHennaUnEquipList();
                }
            }
            // End:0xA0
            break;
        // End:0x9D
        case "btnOK":
            // End:0x83
            if(m_iState == 1)
            {
                RequestHennaEquip(m_iHennaID);                
            }
            else
            {
                // End:0x9A
                if(m_iState == 2)
                {
                    RequestHennaUnEquip(m_iHennaID);
                }
            }
            // End:0xA0
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnShow()
{
    // End:0x3D
    if(m_iState == 1)
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("HennaInfoPremiumWnd", GetSystemString(651));        
    }
    else
    {
        // End:0x7B
        if(m_iState == 2)
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("HennaInfoPremiumWnd", GetSystemString(652));            
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x24
        case 1661:
            m_iState = 1;
            ShowHennaInfoPremiumWnd(param);
            // End:0x45
            break;
        // End:0x42
        case 1691:
            m_iState = 2;
            ShowHennaInfoPremiumWnd(param);
            // End:0x45
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ShowHennaInfoPremiumWnd(string param)
{
    local string strAdenaComma;
    local INT64 iAdena;
    local string strDyeName, strDyeIconName;
    local int iHennaID, iClassID;
    local INT64 iNum, iFee;
    local string strTattooName, strTattooAddName, strTattooIconName, Description;
    local int iINTnow, iINTchange, iSTRnow, iSTRchange, iCONnow, iCONchange,
	    iMENnow, iMENchange, iDEXnow, iDEXchange, iWITnow,
	    iWITchange;

    local Color Col;

    ParseINT64(param, "Adena", iAdena);
    ParseString(param, "DyeIconName", strDyeIconName);
    ParseString(param, "DyeName", strDyeName);
    ParseInt(param, "HennaID", iHennaID);
    ParseInt(param, "ClassID", iClassID);
    ParseINT64(param, "NumOfItem", iNum);
    ParseINT64(param, "Fee", iFee);
    ParseString(param, "TattooIconName", strTattooIconName);
    ParseString(param, "TattooName", strTattooName);
    ParseString(param, "TattooAddName", strTattooAddName);
    ParseInt(param, "INTnow", iINTnow);
    ParseInt(param, "INTchange", iINTchange);
    ParseInt(param, "STRnow", iSTRnow);
    ParseInt(param, "STRchange", iSTRchange);
    ParseInt(param, "CONnow", iCONnow);
    ParseInt(param, "CONchange", iCONchange);
    ParseInt(param, "MENnow", iMENnow);
    ParseInt(param, "MENchange", iMENchange);
    ParseInt(param, "DEXnow", iDEXnow);
    ParseInt(param, "DEXchange", iDEXchange);
    ParseInt(param, "WITnow", iWITnow);
    ParseInt(param, "WITchange", iWITchange);
    ParseString(param, "Description", Description);
    m_iHennaID = iHennaID;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoPremiumWnd.txtDyeInfo", GetSystemString(638));
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoPremiumWnd.textureDyeIconName", strDyeIconName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoPremiumWnd.txtDyeName", strDyeName);
    Col.R = 168;
    Col.G = 168;
    Col.B = 168;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoPremiumWnd.txtFee", GetSystemString(637) $ " : ");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoPremiumWnd.txtFee", Col);
    strAdenaComma = MakeCostString((iFee));
    Col = GetNumericColor(strAdenaComma);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoPremiumWnd.txtAdena", strAdenaComma);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoPremiumWnd.txtAdena", Col);
    Col.R = byte(255);
    Col.G = byte(255);
    Col.B = 0;
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoPremiumWnd.txtAdenaString", GetSystemString(469));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoPremiumWnd.txtAdenaString", Col);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoPremiumWnd.txtTattooInfo", GetSystemString(639));
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoPremiumWnd.textureTattooIconName", strTattooIconName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoPremiumWnd.txtTattooName", strTattooName);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoPremiumWnd.txtTattooAddName", strTattooAddName);
    strAdenaComma = MakeCostString((iAdena));
    Col = GetNumericColor(strAdenaComma);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoPremiumWnd.txtHaveAdena", strAdenaComma);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("HennaInfoPremiumWnd.txtHaveAdena", ConvertNumToText((iAdena)));
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaListWnd");
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoPremiumWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HennaInfoPremiumWnd");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoPremiumWnd.HennaDescTextBox", Description);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("HennaInfoPremiumWnd").HideWindow();
    return;
}
