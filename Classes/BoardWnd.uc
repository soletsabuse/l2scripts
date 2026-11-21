class BoardWnd extends UICommonAPI;

var bool m_bShow;
var bool m_bBtnLock;
var string m_Command[8];
var WindowHandle Me;
var HtmlHandle m_hBoardWndHtmlViewer;
var TabHandle m_hBoardWndTabCtrl;

function OnRegisterEvent()
{
    RegisterEvent(1190);
    RegisterEvent(1200);
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
    Me = GetWindowHandle("BoardWnd");
    m_hBoardWndHtmlViewer = GetHtmlHandle("BoardWnd.HtmlViewer");
    m_hBoardWndTabCtrl = GetTabHandle("BoardWnd.TabCtrl");
    m_bShow = false;
    m_bBtnLock = false;
    return;
}

function OnShow()
{
    m_bShow = true;
    return;
}

function OnHide()
{
    m_bShow = false;
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1D
    if(Event_ID == 1190)
    {
        HandleShowBBS(param);        
    }
    else
    {
        // End:0x37
        if(Event_ID == 1200)
        {
            HandleShowBoardPacket(param);
        }
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x20
        case "btnBookmark":
            OnClickBookmark();
            // End:0x23
            break;
        // End:0xFFFF
        default:
            break;
    }
    TabButtonClick(strID);
    return;
}

function OnRClickButton(string strID)
{
    TabButtonClick(strID);
    return;
}

function TabButtonClick(string strID)
{
    // End:0x51
    if(Left(strID, 7) == "TabCtrl")
    {
        strID = Mid(strID, 7);
        // End:0x51
        if(!Class'NWindow.UIAPI_WINDOW'.static.IsMinimizedWindow("BoardWnd"))
        {
            ShowBBSTab(int(strID));
        }
    }
    return;
}

function Clear()
{
    return;
}

function HandleShowBBS(string param)
{
    local int Index, Init;

    ParseInt(param, "Index", Index);
    ParseInt(param, "Init", Init);
    // End:0x59
    if(m_bShow)
    {
        PlayConsoleSound(6);
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("BoardWnd");
        return;
    }
    // End:0xB1
    if(Init > 0)
    {
        // End:0xAE
        if(!m_hBoardWndHtmlViewer.IsPageLock())
        {
            m_hBoardWndHtmlViewer.SetPageLock(true);
            m_hBoardWndTabCtrl.SetTopOrder(0, false);
            m_hBoardWndHtmlViewer.Clear();
            RequestBBSBoard();
        }        
    }
    else
    {
        // End:0xD1
        if(Index == 8)
        {
            m_hBoardWndTabCtrl.SetTopOrder(0, false);            
        }
        else
        {
            m_hBoardWndTabCtrl.SetTopOrder(Index, false);
        }
        m_hBoardWndHtmlViewer.Clear();
        ShowBBSTab(Index);
    }
    return;
}

function HandleShowBoardPacket(string param)
{
    local int idx, Ok;
    local string Address;
    local array<string> AddressData;
    local int SizeX, SizeY;

    ParseInt(param, "OK", Ok);
    // End:0x3A
    if(Ok < 1)
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("BoardWnd");
        return;
    }
    idx = 0;
    J0x41:

    // End:0x65 [Loop If]
    if(idx < 8)
    {
        m_Command[idx] = "";
        idx++;
        // [Loop Continue]
        goto J0x41;
    }
    ParseString(param, "Command1", m_Command[0]);
    ParseString(param, "Command2", m_Command[1]);
    ParseString(param, "Command3", m_Command[2]);
    ParseString(param, "Command4", m_Command[3]);
    ParseString(param, "Command5", m_Command[4]);
    ParseString(param, "Command6", m_Command[5]);
    ParseString(param, "Command7", m_Command[6]);
    ParseString(param, "Command8", m_Command[7]);
    m_bBtnLock = false;
    ParseString(param, "Address", Address);
    m_hBoardWndHtmlViewer.SetHtmlBuffData(Address);
    // End:0x1C5
    if(!m_bShow)
    {
        PlayConsoleSound(5);
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("BoardWnd");
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus("BoardWnd");
    }
    ParseInt(param, "dialogWidth", SizeX);
    ParseInt(param, "dialogHeight", SizeY);
    AddressData = Arr(Address, "");
    // End:0x244
    if((AddressData.Length > 1) && AddressData[1] != "null")
    {
        SetDialogSize(SizeX, SizeY);
    }
    return;
}

function SetDialogSize(int W, int h)
{
    // End:0x34
    if((W > 0) && h > 0)
    {
        Me.SetWindowSize(W, h);        
    }
    else
    {
        // End:0x68
        if((W > 0) && h <= 0)
        {
            Me.SetWindowSize(W, 578);            
        }
        else
        {
            // End:0x9C
            if((W <= 0) && h > 0)
            {
                Me.SetWindowSize(784, h);                
            }
            else
            {
                Me.SetWindowSize(784, 578);
            }
        }
    }
    return;
}

function ShowBBSTab(int Index)
{
    local string strBypass;
    local UIEventManager.EControlReturnType Ret;

    switch(Index)
    {
        // End:0x25
        case 0:
            strBypass = "bypass _bbshome";
            goto J0x192;
        // End:0x45
        case 1:
            strBypass = "bypass _bbsgetfav";
            goto J0x192;
        // End:0x64
        case 2:
            strBypass = "bypass _bbslink";
            goto J0x192;
        // End:0x83
        case 3:
            strBypass = "bypass _bbsclan";
            goto J0x192;
        // End:0xA2
        case 4:
            strBypass = "bypass _bbsmemo";
            goto J0x192;
        // End:0xC9
        case 5:
            strBypass = "bypass _maillist_0_1_0_";
            goto J0x192;
        // End:0xEE
        case 6:
            strBypass = "bypass _friendlist_0_";
            goto J0x192;
        // End:0x18F
        case 8:
            switch(GetReleaseMode())
            {
                // End:0x121
                case 0:
                    strBypass = "bypass _bbslist_1023_1";
                    // End:0x18F
                    break;
                // End:0x144
                case 1:
                    strBypass = "bypass _bbslist_8_1";
                    // End:0x18F
                    break;
                // End:0x168
                case 2:
                    strBypass = "bypass _bbslist_44_1";
                    // End:0x18F
                    break;
                // End:0x18C
                case 3:
                    strBypass = "bypass _bbslist_20_1";
                    // End:0x18F
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        // End:0xFFFF
        default:
            J0x192:

            Debug("strBypass" @ strBypass);
            // End:0x1E9
            if(Len(strBypass) > 0)
            {
                Ret = m_hBoardWndHtmlViewer.ControllerExecution(strBypass);
                // End:0x1E9
                if(int(Ret) == int(1))
                {
                    m_bBtnLock = true;
                }
            }
            return;
            break;
    }
}

function OnClickBookmark()
{
    local UIEventManager.EControlReturnType Ret;

    // End:0x52
    if((Len(m_Command[7]) > 0) && !m_bBtnLock)
    {
        Ret = m_hBoardWndHtmlViewer.ControllerExecution(m_Command[7]);
        // End:0x52
        if(int(Ret) == int(1))
        {
            m_bBtnLock = true;
        }
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("BoardWnd").HideWindow();
    return;
}
