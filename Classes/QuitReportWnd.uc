class QuitReportWnd extends UICommonAPI;

const TIMER_ID = 999001;

struct sSession
{
    var array<INT64> expPerMenute;
    var array<INT64> adenaPerMinute;
};

var WindowHandle Me;
var WindowHandle PlayReportWnd;
var TextureHandle texQuitReportWnd_Groupbox1;
var TextureHandle texQuitReportWnd_Groupbox3;
var TextureHandle ButtonIconImg_Texture;
var TextureHandle PlayReportWnd_Groupbox;
var TextBoxHandle txtPlayReportWnd_Title;
var TextBoxHandle txtPlayReportWnd_expHead;
var TextBoxHandle txtPlayReportWnd_adenaHead;
var TextBoxHandle txtPlayReportWnd_itemHead;
var TextBoxHandle txtPlayReportWnd_exp;
var TextBoxHandle txtPlayReportWnd_avgexp;
var TextBoxHandle txtPlayReportWnd_perminexp;
var TextBoxHandle txtPlayReportWnd_adena;
var TextBoxHandle txtPlayReportWnd_avgadena;
var TextBoxHandle txtPlayReportWnd_perminadena;
var TextBoxHandle txtPlayReportWnd_item;
var TextBoxHandle txtPlayReportWnd_time;
var ButtonHandle ITEMButton_Right;
var ButtonHandle ITEMButton_Reset;
var ButtonHandle BtnRestart;
var ButtonHandle btnCancel;
var INT64 beforeExp;
var INT64 Exp;
var INT64 beforeAdena;
var INT64 Adena;
var bool firstSetting;
var bool firstAdenaSetting;
var string quitOrRestartExeStr;
var array<ItemInfo> getItemInfoArray;
var L2Util util;
var InventoryWnd inventoryWndScript;
var QuitReportDrawerWnd QuitReportDrawerWndScript;
var UserInfo PlayerInfo;
var int currentSessionTime;
var string currentTimeString;
var sSession Session;
var ButtonHandle PerMinuteExpStatBtn;
var ButtonHandle PerMinuteAdenaStatBtn;
//var delegate<OnRestart> __OnRestart__Delegate;
//var delegate<onExit> __onExit__Delegate;

function OnRegisterEvent()
{
    RegisterEvent(40);
    RegisterEvent(180);
    RegisterEvent(9570);
    RegisterEvent(3340);
    RegisterEvent(3350);
    RegisterEvent(5312);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function OnShow()
{
    Me.SetFocus();
    UpdateUserInfoHandler();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("QuitReportWnd");
    texQuitReportWnd_Groupbox1 = GetTextureHandle("QuitReportWnd.texQuitReportWnd_Groupbox1");
    texQuitReportWnd_Groupbox3 = GetTextureHandle("QuitReportWnd.texQuitReportWnd_Groupbox3");
    PlayReportWnd_Groupbox = GetTextureHandle("QuitReportWnd.PlayReportWnd.PlayReportWnd_Groupbox");
    txtPlayReportWnd_Title = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_Title");
    txtPlayReportWnd_expHead = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_expHead");
    txtPlayReportWnd_adenaHead = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_adenaHead");
    txtPlayReportWnd_itemHead = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_itemHead");
    txtPlayReportWnd_item = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_item");
    txtPlayReportWnd_time = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_time");
    txtPlayReportWnd_exp = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_exp");
    txtPlayReportWnd_avgexp = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_avgexp");
    txtPlayReportWnd_perminexp = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_perminexp");
    txtPlayReportWnd_adena = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_adena");
    txtPlayReportWnd_avgadena = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_avgadena");
    txtPlayReportWnd_perminadena = GetTextBoxHandle("QuitReportWnd.PlayReportWnd.txtPlayReportWnd_perminadena");
    PerMinuteExpStatBtn = GetButtonHandle("QuitReportWnd.PlayReportWnd.PerMinuteExpStatBtn");
    PerMinuteAdenaStatBtn = GetButtonHandle("QuitReportWnd.PlayReportWnd.PerMinuteAdenaStatBtn");
    ITEMButton_Right = GetButtonHandle("QuitReportWnd.PlayReportWnd.ITEMButton_Right");
    ITEMButton_Reset = GetButtonHandle("QuitReportWnd.PlayReportWnd.ITEMButton_Reset");
    BtnRestart = GetButtonHandle("QuitReportWnd.BtnRestart");
    btnCancel = GetButtonHandle("QuitReportWnd.BtnCancel");
    ButtonIconImg_Texture = GetTextureHandle("QuitReportWnd.ButtonIconImg_Texture");
    util = L2Util(GetScript("L2Util"));
    inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
    QuitReportDrawerWndScript = QuitReportDrawerWnd(GetScript("QuitReportDrawerWnd"));
    Init();
    return;
}

function Init()
{
    beforeExp = (0);
    Exp = (0);
    Adena = (0);
    beforeAdena = GetAdena();
    resetGameSessionTime();
    firstSetting = false;
    firstAdenaSetting = false;
    txtPlayReportWnd_exp.SetText("0");
    txtPlayReportWnd_avgexp.SetText("0");
    txtPlayReportWnd_perminexp.SetText("0");
    txtPlayReportWnd_adena.SetText("0");
    txtPlayReportWnd_avgadena.SetText("0");
    txtPlayReportWnd_perminadena.SetText("0");
    PerMinuteExpStatBtn.ClearTooltip();
    PerMinuteAdenaStatBtn.ClearTooltip();
    txtPlayReportWnd_item.SetText(MakeFullSystemMsg(GetSystemString(8061), "0"));
    txtPlayReportWnd_time.SetText("0");
    // End:0x150
    if(GetWindowHandle("QuitReportDrawerWnd").IsShowWindow())
    {
        setDrawerButtonState(true);
        GetWindowHandle("QuitReportDrawerWnd").HideWindow();
    }
    return;
}

function setDrawerButtonState(bool bShow)
{
    // End:0x8D
    if(bShow)
    {
        ITEMButton_Right.SetTexture("L2UI_CT1.Button.Button_DF_Right_Down", "L2UI_CT1.Button.Button_DF_Right_Down", "L2UI_CT1.Button.Button_DF_Right_Over");        
    }
    else
    {
        ITEMButton_Right.SetTexture("L2UI_CT1.Button.Button_DF_Left_Down", "L2UI_CT1.Button.Button_DF_Left_Down", "L2UI_CT1.Button.Button_DF_Left_Over");
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0xA4
        case "ITEMButton_Right":
            // End:0x75
            if(!GetWindowHandle("QuitReportDrawerWnd").IsShowWindow())
            {
                setDrawerButtonState(false);
                GetWindowHandle("QuitReportDrawerWnd").ShowWindow();                
            }
            else
            {
                setDrawerButtonState(true);
                GetWindowHandle("QuitReportDrawerWnd").HideWindow();
            }
            // End:0x103
            break;
        // End:0xC2
        case "ITEMButton_Reset":
            OnITEMButton_ResetClick();
            // End:0x103
            break;
        // End:0xE9
        case "BtnRestart":
            ExecuteQuitOrRestart();
            Me.HideWindow();
            // End:0x103
            break;
        // End:0x100
        case "BtnCancel":
            OnbtnCancelClick();
            // End:0x103
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ExecuteQuitOrRestart()
{
    local InventoryWnd script;

    InventoryWnd(GetScript("InventoryWnd")).SaveInventoryOrder();
    // End:0x46
    if(quitOrRestartExeStr == "quit")
    {
        onExit();
        ExecQuit();        
    }
    else
    {
        OnRestart();
        ExecRestart();
    }
    return;
}

function resetGameSessionTime()
{
    currentTimeString = GetTimeString();
    currentSessionTime = 0;
    Me.KillTimer(1001);
    Me.SetTimer(1001, 1000);
    return;
}

function updateGameSessionTimeText()
{
    txtPlayReportWnd_time.SetText(measureTimeString(currentSessionTime));
    return;
}

function OnTimer(int TimerID)
{
    // End:0x32
    if(TimerID == 999001)
    {
        beforeAdena = GetAdena();
        Me.KillTimer(999001);        
    }
    else
    {
        // End:0x7B
        if(TimerID == 1001)
        {
            currentSessionTime++;
            updateGameSessionTimeText();
            Me.KillTimer(1001);
            Me.SetTimer(1001, 1000);
        }
    }
    return;
}

function OnITEMButton_ResetClick()
{
    local sSession clearSession;

    GetPlayerInfo(PlayerInfo);
    beforeExp = PlayerInfo.nCurExp;
    Exp = (0);
    Adena = (0);
    beforeAdena = GetAdena();
    resetGameSessionTime();
    firstSetting = true;
    firstAdenaSetting = true;
    Session = clearSession;
    QuitReportDrawerWndScript.Init();
    txtPlayReportWnd_exp.SetText("0");
    txtPlayReportWnd_avgexp.SetText("0");
    txtPlayReportWnd_perminexp.SetText("0");
    txtPlayReportWnd_adena.SetText("0");
    txtPlayReportWnd_avgadena.SetText("0");
    txtPlayReportWnd_perminadena.SetText("0");
    txtPlayReportWnd_item.SetText(MakeFullSystemMsg(GetSystemString(8061), "0"));
    PerMinuteExpStatBtn.ClearTooltip();
    PerMinuteAdenaStatBtn.ClearTooltip();
    // End:0x16A
    if(GetWindowHandle("QuitReportDrawerWnd").IsShowWindow())
    {
        setDrawerButtonState(true);
        GetWindowHandle("QuitReportDrawerWnd").HideWindow();
    }
    return;
}

function OnbtnCancelClick()
{
    Me.HideWindow();
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local INT64 pAdena;

    // End:0x34
    if(a_EventID == 9570)
    {
        ParseINT64(a_Param, "Adena", pAdena);
        UpdateAdena(pAdena);        
    }
    else
    {
        // End:0x58
        if(a_EventID == 40)
        {
            Init();
            QuitReportDrawerWndScript.Init();            
        }
        else
        {
            // End:0xE3
            if(a_EventID == 3340)
            {
                quitOrRestartExeStr = "quit";
                ButtonIconImg_Texture.SetTexture("L2UI_CT1.Icon.QuitIcon");
                BtnRestart.SetButtonName(148);
                Me.SetWindowTitle(GetSystemString(148));
                Me.ShowWindow();
                Me.SetFocus();                
            }
            else
            {
                // End:0x174
                if(a_EventID == 3350)
                {
                    quitOrRestartExeStr = "restart";
                    ButtonIconImg_Texture.SetTexture("L2UI_CT1.Icon.RestartIcon");
                    BtnRestart.SetButtonName(147);
                    Me.SetWindowTitle(GetSystemString(147));
                    Me.ShowWindow();
                    Me.SetFocus();                    
                }
                else
                {
                    // End:0x189
                    if(a_EventID == 180)
                    {
                        UpdateUserInfoHandler();                        
                    }
                    else
                    {
                        // End:0x1C4
                        if(a_EventID == 5312)
                        {
                            firstSetting = false;
                            beforeExp = (0);
                            Exp = (0);
                            txtPlayReportWnd_exp.SetText("0");
                        }
                    }
                }
            }
        }
    }
    return;
}

function addInzoneListItem(string inzoneName, string remainTimeStr)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 2;
    Record.LVDataList[0].szData = inzoneName;
    Record.LVDataList[1].szData = remainTimeStr;
    return;
}

function string setTimeString(int tmpTime)
{
    local string timeStr;
    local int timeHour, timeMin;

    // End:0x45
    if(tmpTime < 60)
    {
        timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(1));
        timeStr = MakeFullSystemMsg(GetSystemMessage(3408), timeStr);        
    }
    else
    {
        // End:0x84
        if(tmpTime < 3600)
        {
            tmpTime = tmpTime / 60;
            timeStr = MakeFullSystemMsg(GetSystemMessage(3390), string(tmpTime));            
        }
        else
        {
            timeHour = tmpTime / 3600;
            timeMin = (tmpTime - (timeHour * 3600)) / 60;
            // End:0xF9
            if(timeMin > 0)
            {
                timeStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeHour)) @ MakeFullSystemMsg(GetSystemMessage(3390), string(timeMin));                
            }
            else
            {
                timeStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeHour));
            }
        }
    }
    return timeStr;
    return;
}

function int getMinuteIndex()
{
    return currentSessionTime / 60;
    return;
}

function setAdenaToArray(INT64 Adena)
{
    local INT64 totalAdena;

    // End:0x10
    if(__NFUN_412__(Adena, (0)))
    {
        return;
    }
    totalAdena = Session.adenaPerMinute[getMinuteIndex()];
    totalAdena = __NFUN_404__(totalAdena, Adena);
    Session.adenaPerMinute[getMinuteIndex()] = totalAdena;
    return;
}

function setEXPToArray(INT64 Exp)
{
    local INT64 totalEXP;

    // End:0x10
    if(__NFUN_412__(Exp, (0)))
    {
        return;
    }
    totalEXP = Session.expPerMenute[getMinuteIndex()];
    totalEXP = __NFUN_404__(totalEXP, Exp);
    Session.expPerMenute[getMinuteIndex()] = totalEXP;
    return;
}

function int getMinuteAdenaSize()
{
    return Session.adenaPerMinute.Length;
    return;
}

function INT64 getMinuteAdena()
{
    return Session.adenaPerMinute[getMinuteIndex()];
    return;
}

function INT64 getMinuteEXPSize()
{
    return (Session.expPerMenute.Length);
    return;
}

function INT64 getMinuteEXP()
{
    return Session.expPerMenute[getMinuteIndex()];
    return;
}

function UpdateAdena(INT64 pAdena)
{
    local INT64 avgAdenaPerMinute, adenaDiff;
    local int currentMinutes;

    // End:0x28
    if(firstAdenaSetting == false)
    {
        Adena = (0);
        beforeAdena = pAdena;
        firstAdenaSetting = true;
    }
    // End:0x4B
    if(__NFUN_409__(pAdena, beforeAdena))
    {
        adenaDiff = __NFUN_405__(pAdena, beforeAdena);
    }
    setAdenaToArray(adenaDiff);
    // End:0x81
    if(__NFUN_409__(pAdena, beforeAdena))
    {
        Adena = __NFUN_404__(Adena, __NFUN_405__(pAdena, beforeAdena));
    }
    beforeAdena = pAdena;
    currentMinutes = currentSessionTime / 60;
    avgAdenaPerMinute = (name(__NFUN_403__(Adena, (currentMinutes))));
    txtPlayReportWnd_adena.SetText(MakeCostString((Adena)));
    txtPlayReportWnd_avgadena.SetText(MakeCostString((avgAdenaPerMinute)));
    txtPlayReportWnd_perminadena.SetText(MakeCostStringINT64(getMinuteAdena()));
    // End:0x143
    if((getMinuteAdenaSize()) > 1)
    {
        PerMinuteAdenaStatBtn.SetTooltipCustomType(ToolTip(GetScript("Tooltip")).ReturnTooltip_NTT_QuitReportStatAdena());        
    }
    else
    {
        PerMinuteAdenaStatBtn.ClearTooltip();
        PerMinuteAdenaStatBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(8063)));
    }
    return;
}

function UpdateUserInfoHandler()
{
    local INT64 ItemCount, expDiff, currentMinutes, avgEXPPerMinute;

    // End:0x1A
    if(GetGameStateName() != "GAMINGSTATE")
    {
        return;
    }
    GetPlayerInfo(PlayerInfo);
    // End:0x80
    if(firstSetting == false)
    {
        firstSetting = true;
        beforeExp = PlayerInfo.nCurExp;
        Exp = (0);
        // End:0x80
        if(Me.IsShowWindow())
        {
            txtPlayReportWnd_exp.SetText(MakeCostString((Exp)));
        }
    }
    // End:0xAD
    if(__NFUN_409__(PlayerInfo.nCurExp, beforeExp))
    {
        expDiff = __NFUN_405__(PlayerInfo.nCurExp, beforeExp);
    }
    setEXPToArray(expDiff);
    // End:0xED
    if(__NFUN_409__(PlayerInfo.nCurExp, beforeExp))
    {
        Exp = __NFUN_404__(Exp, __NFUN_405__(PlayerInfo.nCurExp, beforeExp));
    }
    beforeExp = PlayerInfo.nCurExp;
    currentMinutes = (currentSessionTime / 60);
    avgEXPPerMinute = (name(__NFUN_403__(Exp, currentMinutes)));
    // End:0x1D0
    if(Me.IsShowWindow())
    {
        ItemCount = (QuitReportDrawerWndScript.getTotalItemCount());
        txtPlayReportWnd_exp.SetText(MakeCostString((Exp)));
        txtPlayReportWnd_avgexp.SetText(MakeCostString((avgEXPPerMinute)));
        txtPlayReportWnd_perminexp.SetText(MakeCostString((getMinuteEXP())));
        txtPlayReportWnd_item.SetText(MakeFullSystemMsg(GetSystemString(8061), MakeCostString((ItemCount))));
    }
    // End:0x20F
    if(__NFUN_409__(getMinuteEXPSize(), (1)))
    {
        PerMinuteExpStatBtn.SetTooltipCustomType(ToolTip(GetScript("Tooltip")).ReturnTooltip_NTT_QuitReportStatExp());        
    }
    else
    {
        PerMinuteExpStatBtn.ClearTooltip();
        PerMinuteExpStatBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(8063)));
    }
    return;
}

function externalAddItem(ItemInfo addItemInfo)
{
    QuitReportDrawerWndScript.externalAddItem(addItemInfo);
    return;
}

function string measureTimeString(int measureSec)
{
    local int gameSec, days, Hours, mins, secs;

    gameSec = measureSec;
    days = gameSec / 86400;
    gameSec = int(float(gameSec) % float(86400));
    Hours = gameSec / 3600;
    gameSec = int(float(gameSec) % float(3600));
    mins = gameSec / 60;
    gameSec = int(float(gameSec) % float(60));
    secs = gameSec;
    return ((((((string(days) $ GetSystemString(1109)) @ string(Hours)) $ GetSystemString(1110)) @ string(mins)) $ GetSystemString(1111)) @ string(secs)) $ GetSystemString(2001);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}

delegate OnRestart()
{
    return;
}

delegate onExit()
{
    return;
}
