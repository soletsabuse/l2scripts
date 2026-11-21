class ProgressBox extends UICommonAPI;

var WindowHandle Me;
var ButtonHandle btnCancle;
var ButtonHandle btnOk;
var TextBoxHandle txtProgress;
var ItemWindowHandle EnchantAttributeSlot;
var ItemWindowHandle EnchantItemSlot;
var bool m_bInUse;
var string m_strTargetScript;
var string m_strEditMessage;
var string _message;
var string _target;
var int _time;
var ItemInfo _infoAttribute;
var ItemInfo _item;
var ProgressCtrlHandle m_hProgressBoxprogressCtrl;

function OnRegisterEvent()
{
    RegisterEvent(580);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    Initialize();
    load();
    return;
}

function Initialize()
{
    m_strTargetScript = "";
    m_bInUse = false;
    // End:0x10A
    if(1 == 0)
    {
        Me = GetHandle("ProgressBox");
        btnCancle = ButtonHandle(GetHandle("ProgressBox.btnCancle"));
        btnOk = ButtonHandle(GetHandle("ProgressBox.btnOK"));
        txtProgress = TextBoxHandle(GetHandle("ProgressBox.txtProgress"));
        EnchantAttributeSlot = ItemWindowHandle(GetHandle("ProgressBox.EnchantAttributeSlot"));
        EnchantItemSlot = ItemWindowHandle(GetHandle("ProgressBox.EnchantItemSlot"));        
    }
    else
    {
        Me = GetWindowHandle("ProgressBox");
        btnCancle = GetButtonHandle("ProgressBox.btnCancle");
        btnOk = GetButtonHandle("ProgressBox.btnOK");
        txtProgress = GetTextBoxHandle("ProgressBox.txtProgress");
        EnchantAttributeSlot = GetItemWindowHandle("ProgressBox.EnchantAttributeSlot");
        EnchantItemSlot = GetItemWindowHandle("ProgressBox.EnchantItemSlot");
        m_hProgressBoxprogressCtrl = GetProgressCtrlHandle("ProgressBox.progressCtrl");
    }
    return;
}

function load()
{
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1E
        case "btnCancle":
            OnbtnCancleClick();
            // End:0x34
            break;
        // End:0x31
        case "btnOK":
            OnBtnOkClick();
            // End:0x34
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnBtnOkClick()
{
    m_hProgressBoxprogressCtrl.Start();
    m_bInUse = true;
    return;
}

function OnbtnCancleClick()
{
    local AttributeEnchantWnd scriptAttributeEnchant;

    // End:0x60
    if(m_strTargetScript == "AttributeEnchantWnd")
    {
        m_hProgressBoxprogressCtrl.Reset();
        Me.HideWindow();
        m_bInUse = false;
        ShowWindow("AttributeEnchantWnd");
    }
    scriptAttributeEnchant = AttributeEnchantWnd(GetScript("AttributeEnchantWnd"));
    scriptAttributeEnchant.DisableCurrentWindow(false);
    return;
}

function ShowDialog(string Message, string Target, int Time, ItemInfo infoAttribute, ItemInfo item)
{
    // End:0x0B
    if(m_bInUse)
    {
        return;
    }
    // End:0x18
    if(Time == 0)
    {
        return;
    }
    _message = Message;
    _target = Target;
    _time = Time;
    _infoAttribute = infoAttribute;
    _item = item;
    EnchantAttributeSlot.Clear();
    EnchantItemSlot.Clear();
    EnchantAttributeSlot.SetItem(0, _infoAttribute);
    EnchantAttributeSlot.AddItem(_infoAttribute);
    EnchantItemSlot.SetItem(0, _item);
    EnchantItemSlot.AddItem(_item);
    m_hProgressBoxprogressCtrl.SetProgressTime(_time);
    m_hProgressBoxprogressCtrl.Reset();
    Me.ShowWindow();
    Me.SetFocus();
    SetMessage(_message);
    m_strTargetScript = Target;
    return;
}

function OnProgressTimeUp(string strID)
{
    local AttributeEnchantWnd scriptAttributeEnchant;

    // End:0x91
    if(strID == "progressCtrl")
    {
        // End:0x91
        if(m_strTargetScript == "AttributeEnchantWnd")
        {
            scriptAttributeEnchant = AttributeEnchantWnd(GetScript("AttributeEnchantWnd"));
            scriptAttributeEnchant.DisableCurrentWindow(false);
            Me.HideWindow();
            Initialize();
            scriptAttributeEnchant.OnOKClick();
        }
    }
    return;
}

function SetMessage(string strMessage)
{
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("ProgressBox.txtProgress", strMessage);
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local int SystemMsgIndex;
    local string ParamString1, ParamString2;

    // End:0x98
    if(a_EventID == 580)
    {
        ParseInt(a_Param, "Index", SystemMsgIndex);
        ParseString(a_Param, "Param1", ParamString1);
        ParseString(a_Param, "Param2", ParamString2);
        // End:0x98
        if((SystemMsgIndex > 61) && SystemMsgIndex < 66)
        {
            DialogShow(1, 5, MakeFullSystemMsg(GetSystemMessage(SystemMsgIndex), ParamString1, ParamString2), string(self));
        }
    }
    return;
}
