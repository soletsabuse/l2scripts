class ChatFontsizeWnd extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle m_hFontSize_0;
var ButtonHandle m_hFontSize_1;
var ButtonHandle m_hFontSize_2;
var CheckBoxHandle btnAttributeSelect0;
var CheckBoxHandle btnAttributeSelect1;
var CheckBoxHandle btnAttributeSelect2;
var TextBoxHandle fontSizeText0;
var TextBoxHandle fontSizeText1;
var TextBoxHandle fontSizeText2;
var TextBoxHandle sampleText0;
var TextBoxHandle sampleText1;
var TextBoxHandle sampleText2;
var int m_SelectFontIndex;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Me = GetWindowHandle("ChatFontsizeWnd");
    m_hFontSize_0 = GetButtonHandle("ChatFontsizeWnd.btnListSelect0");
    m_hFontSize_1 = GetButtonHandle("ChatFontsizeWnd.btnListSelect1");
    m_hFontSize_2 = GetButtonHandle("ChatFontsizeWnd.btnListSelect2");
    btnAttributeSelect0 = GetCheckBoxHandle("ChatFontsizeWnd.btnAttributeSelect0");
    btnAttributeSelect1 = GetCheckBoxHandle("ChatFontsizeWnd.btnAttributeSelect1");
    btnAttributeSelect2 = GetCheckBoxHandle("ChatFontsizeWnd.btnAttributeSelect2");
    fontSizeText0 = GetTextBoxHandle("ChatFontsizeWnd.ChatFontSizeExemple0");
    fontSizeText1 = GetTextBoxHandle("ChatFontsizeWnd.ChatFontSizeExemple1");
    fontSizeText2 = GetTextBoxHandle("ChatFontsizeWnd.ChatFontSizeExemple2");
    sampleText0 = GetTextBoxHandle("ChatFontsizeWnd.ChatFontSizeExemple_0");
    sampleText1 = GetTextBoxHandle("ChatFontsizeWnd.ChatFontSizeExemple_1");
    sampleText2 = GetTextBoxHandle("ChatFontsizeWnd.ChatFontSizeExemple_2");
    fontSizeText0.SetText(" " $ GetSystemString(2636));
    fontSizeText1.SetText(" " $ GetSystemString(3163));
    fontSizeText2.SetText(" " $ GetSystemString(2637));
    sampleText0.SetFontIDByName("chatFontSize10");
    sampleText1.SetFontIDByName("chatFontSize11");
    sampleText2.SetFontIDByName("chatFontSize12");
    return;
}

function OnShow()
{
    local int vars;

    GetINIInt("global", "ChatFontSizeSaved", vars, "chatfilter.ini");
    m_SelectFontIndex = vars;
    setRadioButton(vars);
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0xFFFF
        default:
            return;
            break;
    }
}

function LoadDefaultVaule()
{
    return;
}

function RequestChangeFont(int FontType)
{
    local ChatWnd script;

    script = ChatWnd(GetScript("ChatWnd"));
    script.SetChangeFont(FontType);
    return;
}

function CloseFontSizeWnd()
{
    PlayConsoleSound(6);
    GetWindowHandle("ChatFontsizeWnd").HideWindow();
    return;
}

function OnClickButton(string strID)
{
    // End:0x20
    if(strID == "CloseButton")
    {
        CloseFontSizeWnd();        
    }
    else
    {
        // End:0x82
        if(strID == "ChatFilterOK")
        {
            SetINIInt("global", "ChatFontSizeSaved", m_SelectFontIndex, "chatfilter.ini");
            RequestChangeFont(m_SelectFontIndex);
            CloseFontSizeWnd();            
        }
        else
        {
            // End:0xA7
            if(strID == "ChatFilterCancel")
            {
                CloseFontSizeWnd();                
            }
            else
            {
                // End:0xCB
                if(strID == "btnListSelect0")
                {
                    setRadioButton(0);                    
                }
                else
                {
                    // End:0xEF
                    if(strID == "btnListSelect1")
                    {
                        setRadioButton(1);                        
                    }
                    else
                    {
                        // End:0x111
                        if(strID == "btnListSelect2")
                        {
                            setRadioButton(2);
                        }
                    }
                }
            }
        }
    }
    return;
}

function setRadioButton(int SelectNum)
{
    btnAttributeSelect0.SetCheck(false);
    btnAttributeSelect1.SetCheck(false);
    btnAttributeSelect2.SetCheck(false);
    m_SelectFontIndex = SelectNum;
    // End:0x59
    if(SelectNum == 1)
    {
        btnAttributeSelect1.SetCheck(true);        
    }
    else
    {
        // End:0x78
        if(SelectNum == 2)
        {
            btnAttributeSelect2.SetCheck(true);            
        }
        else
        {
            btnAttributeSelect0.SetCheck(true);
        }
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("ChatFontsizeWnd").HideWindow();
    return;
}
