class MailBtnWnd extends UICommonAPI;

var ButtonHandle btnItemPop;
var int buttonType;
var int IsPeaceZone;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    buttonType = 0;
    Initialize();
    return;
}

function Initialize()
{
    // End:0x2F
    if(1 == 0)
    {
        btnItemPop = ButtonHandle(GetHandle("MailBtnWnd.btnMail"));        
    }
    else
    {
        btnItemPop = GetButtonHandle("MailBtnWnd.btnMail");
    }
    btnItemPop.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemMessage(3064)));
    IsPeaceZone = 1;
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int iEffectNumber, zonetype;

    ParseInt(param, "IdxMail", iEffectNumber);
    switch(Event_ID)
    {
        // End:0x6C
        case 1530:
            ShowWindowWithFocus("MailBtnWnd");
            Class'NWindow.UIAPI_EFFECTBUTTON'.static.BeginEffect("MailBtnWnd.btnMail", iEffectNumber);
            buttonType = 1;
            // End:0xFB
            break;
        // End:0xB9
        case 4700:
            ShowWindowWithFocus("MailBtnWnd");
            Class'NWindow.UIAPI_EFFECTBUTTON'.static.BeginEffect("MailBtnWnd.btnMail", iEffectNumber);
            buttonType = 2;
            // End:0xFB
            break;
        // End:0xF8
        case 110:
            ParseInt(param, "ZoneCode", zonetype);
            // End:0xEE
            if(zonetype == 12)
            {
                IsPeaceZone = 1;                
            }
            else
            {
                IsPeaceZone = 0;
            }
            // End:0xFB
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x53
        case "btnMail":
            HideWindow("MailBtnWnd");
            // End:0x50
            if(buttonType == 2)
            {
                // End:0x45
                if(IsPeaceZone == 1)
                {
                    RequestRequestReceivedPostList();                    
                }
                else
                {
                    AddSystemMessage(3066);
                }
            }
            // End:0x56
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}
