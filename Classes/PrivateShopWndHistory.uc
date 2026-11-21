class PrivateShopWndHistory extends UICommonAPI;

var WindowHandle Me;
var ListCtrlHandle ItemListCtrl;
var ButtonHandle CloseBtn;
var PrivateShopWndReport PrivateShopWndReportScript;

function Initialize()
{
    SetClosingOnESC();
    Me = GetWindowHandle("PrivateShopWndHistory");
    ItemListCtrl = GetListCtrlHandle("PrivateShopWndHistory.ItemList");
    CloseBtn = GetButtonHandle("PrivateShopWndHistory.closeBtn");
    PrivateShopWndReportScript = PrivateShopWndReport(GetScript("PrivateShopWndReport"));
    ItemListCtrl.SetSelectedSelTooltip(false);
    ItemListCtrl.SetAppearTooltipAtMouseX(true);
    Init();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(40);
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1E
        case 40:
            ItemListCtrl.DeleteAllItem();
            // End:0x21
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function OnShow()
{
    Me.SetFocus();
    return;
}

function OnHide()
{
    Init();
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x27
        case "close_Btn":
            Me.HideWindow();
            // End:0x2A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function Init()
{
    return;
}

function Color getcolorbymessagetype()
{
    switch(PrivateShopWndReportScript.messagetype)
    {
        // End:0x2F
        case "bulksell":
            return GetColor(255, 119, 119, 255);
            // End:0x67
            break;
        // End:0x4A
        case "sell":
            return GetColor(221, 119, 238, 255);
            // End:0x67
            break;
        // End:0x64
        case "buy":
            return GetColor(170, 204, 17, 255);
            // End:0x67
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function addHistory(string ItemName, bool isStackable, INT64 ItemNum, string Username)
{
    local int SystemMsgNum;
    local string SystemMsg;

    switch(PrivateShopWndReportScript.messagetype)
    {
        // End:0x1D
        case "bulksell":
        // End:0x4B
        case "sell":
            // End:0x3D
            if(isStackable)
            {
                SystemMsgNum = 380;                
            }
            else
            {
                SystemMsgNum = 378;
            }
            // End:0x7B
            break;
        // End:0x78
        case "buy":
            // End:0x6A
            if(isStackable)
            {
                SystemMsgNum = 561;                
            }
            else
            {
                SystemMsgNum = 559;
            }
            // End:0x7B
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xAF
    if(isStackable)
    {
        SystemMsg = MakeFullSystemMsg(GetSystemMessage(SystemMsgNum), Username, ItemName, (ItemNum));        
    }
    else
    {
        SystemMsg = MakeFullSystemMsg(GetSystemMessage(SystemMsgNum), Username, ItemName);
    }
    ItemListCtrl.InsertRecord(makeRecord(SystemMsg, getcolorbymessagetype(), Username));
    return;
}

function LVDataRecord makeRecord(string Message, Color messageColor, string Username)
{
    local LVDataRecord Record;
    local int textWidth, textHeight;

    Record.LVDataList.Length = 1;
    GetTextSizeDefault(Message, textWidth, textHeight);
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[0].TextColor = messageColor;
    Record.LVDataList[0].textAlignment = 1;
    // End:0xF0
    if(textWidth > 430)
    {
        Record.szReserved = Message;
        Record.LVDataList[0].szData = ellipsisWidth(Message, 430);
        Record.nReserved1 = (int(messageColor.R));
        Record.nReserved2 = (int(messageColor.G));
        Record.nReserved3 = (int(messageColor.B));        
    }
    else
    {
        Record.LVDataList[0].szData = Message;
    }
    return Record;
    return;
}

function string ellipsisWidth(string Text, int MaxWidth)
{
    local int nWidth, nHeight, i;

    GetTextSizeDefault(Text $ "..", nWidth, nHeight);
    // End:0x30
    if(nWidth < MaxWidth)
    {
        return Text;
    }
    i = 0;
    J0x37:

    // End:0x9B [Loop If]
    if(i < 200)
    {
        GetTextSizeDefault(Text $ "..", nWidth, nHeight);
        // End:0x79
        if(nWidth < MaxWidth)
        {
            return Text $ "..";
        }
        Text = Mid(Text, 0, Len(Text) - 1);
        i++;
        // [Loop Continue]
        goto J0x37;
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("PrivateShopWndHistory").HideWindow();
    return;
}
