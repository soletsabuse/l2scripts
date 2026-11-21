class HennaInfoWnd extends UICommonAPI;

const HENNA_EQUIP = 1;
const HENNA_UNEQUIP = 2;

var int m_iState;
var int m_iHennaID;

function OnRegisterEvent()
{
    RegisterEvent(1660);
    RegisterEvent(1690);
    RegisterEvent(8000);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    OnRegisterEvent();
    GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtSTRString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3366), 154));
    GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtDEXString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3368), 154));
    GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtCONString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3370), 154));
    GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtINTString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3367), 154));
    GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtWITString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3369), 154));
    GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtMENString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3371), 154));
    GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtLUCString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3372), 154));
    GetTextBoxHandle("HennaInfoWnd.HennaInfoWndUnEquip.txtCHAString").SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(3373), 154));
    return;
}

function OnClickButton(string strID)
{
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd");
    switch(strID)
    {
        // End:0x59
        case "btnPrev":
            // End:0x44
            if(m_iState == 1)
            {
                RequestHennaItemList();                
            }
            else
            {
                // End:0x56
                if(m_iState == 2)
                {
                    RequestHennaUnEquipList();
                }
            }
            // End:0x99
            break;
        // End:0x96
        case "btnOK":
            // End:0x7C
            if(m_iState == 1)
            {
                RequestHennaEquip(m_iHennaID);                
            }
            else
            {
                // End:0x93
                if(m_iState == 2)
                {
                    RequestHennaUnEquip(m_iHennaID);
                }
            }
            // End:0x99
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnShow()
{
    // End:0x96
    if(m_iState == 1)
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("HennaInfoWnd", GetSystemString(651));
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.HennaInfoWndUnEquip");
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.HennaInfoWndEquip");        
    }
    else
    {
        // End:0x12D
        if(m_iState == 2)
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("HennaInfoWnd", GetSystemString(652));
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.HennaInfoWndEquip");
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.HennaInfoWndUnEquip");            
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x24
        case 1660:
            m_iState = 1;
            ShowHennaInfoWnd(param);
            // End:0x2FE
            break;
        // End:0x42
        case 1690:
            m_iState = 2;
            ShowHennaInfoWnd(param);
            // End:0x2FE
            break;
        // End:0x2FB
        case 8000:
            // End:0x1AC
            if(getInstanceUIData().getIsClassicServer())
            {
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCString");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCBefore");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCArrow");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtLUCAfter");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHAString");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHABefore");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHAArrow");
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaInfoWnd.txtCHAAfter");                
            }
            else
            {
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCString");
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCBefore");
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCArrow");
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtLUCAfter");
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHAString");
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHABefore");
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHAArrow");
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd.txtCHAAfter");
            }
            // End:0x2FE
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ShowHennaInfoWnd(string param)
{
    local string strAdenaComma;
    local INT64 iAdena;
    local string strDyeName, strDyeIconName;
    local int iHennaID, iClassID;
    local INT64 iNum, iFee;
    local string strTattooName, strTattooAddName, strTattooIconName;
    local int iINTnow, iINTchange, iSTRnow, iSTRchange, iCONnow, iCONchange,
	    iMENnow, iMENchange, iDEXnow, iDEXchange, iWITnow,
	    iWITchange, iLUCnow, iLUCchange, iCHAnow, iCHAchange;

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
    ParseInt(param, "LUCnow", iLUCnow);
    ParseInt(param, "LUCchange", iLUCchange);
    ParseInt(param, "CHAnow", iCHAnow);
    ParseInt(param, "CHAchange", iCHAchange);
    m_iHennaID = iHennaID;
    // End:0x5B4
    if(m_iState == 1)
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeInfo", GetSystemString(638));
        Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureDyeIconName", strDyeIconName);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeName", strDyeName);
        Col.R = 168;
        Col.G = 168;
        Col.B = 168;
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtFee", GetSystemString(637) $ " : ");
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtFee", Col);
        strAdenaComma = MakeCostString((iFee));
        Col = GetNumericColor(strAdenaComma);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdena", strAdenaComma);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdena", Col);
        Col.R = byte(255);
        Col.G = byte(255);
        Col.B = 0;
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaString", GetSystemString(469));
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaString", Col);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooInfo", GetSystemString(639));
        Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureTattooIconName", strTattooIconName);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooName", strTattooName);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooAddName", strTattooAddName);        
    }
    else
    {
        // End:0x926
        if(m_iState == 2)
        {
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooInfoUnEquip", GetSystemString(639));
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureTattooIconNameUnEquip", strTattooIconName);
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooNameUnEquip", (GetSystemString(652) $ ":") $ strTattooName);
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtTattooAddNameUnEquip", strTattooAddName);
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeInfoUnEquip", GetSystemString(638));
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("HennaInfoWnd.textureDyeIconNameUnEquip", strDyeIconName);
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtDyeNameUnEquip", strDyeName);
            Col.R = 168;
            Col.G = 168;
            Col.B = 168;
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtFeeUnEquip", GetSystemString(637) $ " : ");
            Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtFeeUnEquip", Col);
            strAdenaComma = MakeCostString((iFee));
            Col = GetNumericColor(strAdenaComma);
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaUnEquip", strAdenaComma);
            Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaUnEquip", Col);
            Col.R = byte(255);
            Col.G = byte(255);
            Col.B = 0;
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtAdenaStringUnEquip", GetSystemString(469));
            Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("HennaInfoWnd.txtAdenaStringUnEquip", Col);
        }
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtSTRBefore", iSTRnow);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtSTRAfter", iSTRchange);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtDEXBefore", iDEXnow);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtDEXAfter", iDEXchange);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCONBefore", iCONnow);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCONAfter", iCONchange);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtINTBefore", iINTnow);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtINTAfter", iINTchange);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtWITBefore", iWITnow);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtWITAfter", iWITchange);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtMENBefore", iMENnow);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtMENAfter", iMENchange);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtLUCBefore", iLUCnow);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtLUCAfter", iLUCchange);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCHABefore", iCHAnow);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetInt("HennaInfoWnd.txtCHAAfter", iCHAchange);
    strAdenaComma = MakeCostString((iAdena));
    Col = GetNumericColor(strAdenaComma);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaInfoWnd.txtHaveAdena", strAdenaComma);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("HennaInfoWnd.txtHaveAdena", ConvertNumToText((iAdena)));
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("HennaListWnd");
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("HennaInfoWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HennaInfoWnd");
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("HennaInfoWnd").HideWindow();
    return;
}
