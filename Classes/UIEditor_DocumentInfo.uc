class UIEditor_DocumentInfo extends UICommonAPI;

var WindowHandle Me;
var EditBoxHandle txtCommentInput;
var string m_xmlnsInput;
var string m_xsiInput;
var string m_schemaLocationInput;
var WindowHandle m_CurTopWnd;

function OnRegisterEvent()
{
    RegisterEvent(2920);
    RegisterEvent(2930);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    InitHandle();
    InitControlItem();
    return;
}

function InitHandle()
{
    // End:0x65
    if(1 == 0)
    {
        Me = GetHandle("UIEditor_DocumentInfo");
        txtCommentInput = EditBoxHandle(GetHandle("UIEditor_DocumentInfo.txtCommentInput"));        
    }
    else
    {
        Me = GetWindowHandle("UIEditor_DocumentInfo");
        txtCommentInput = GetEditBoxHandle("UIEditor_DocumentInfo.txtCommentInput");
    }
    return;
}

function InitControlItem()
{
    Me.SetWindowTitle("UIEditor - DocumentInfo");
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1D
    if(Event_ID == 2920)
    {
        HandleTrackerAttach(param);        
    }
    else
    {
        // End:0x32
        if(Event_ID == 2930)
        {
            HandleTrackerDetach();
        }
    }
    return;
}

function OnCompleteEditBox(string strID)
{
    switch(strID)
    {
        // End:0x24
        case "txtCommentInput":
            UpdateDocumentInfo();
            // End:0x27
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleTrackerAttach(string param)
{
    local WindowHandle TrackerWnd, TopWnd;
    local string Comment, NameSpace, XSI, SchemaLocation;

    TrackerWnd = GetTrackerAttachedWindow();
    // End:0x19
    if(TrackerWnd == none)
    {
        return;
    }
    Clear();
    TopWnd = TrackerWnd.GetTopFrameWnd();
    // End:0x41
    if(TopWnd == none)
    {
        return;
    }
    // End:0x52
    if(TopWnd == m_CurTopWnd)
    {
        return;
    }
    m_CurTopWnd = TopWnd;
    TopWnd.GetXMLDocumentInfo(Comment, NameSpace, XSI, SchemaLocation);
    txtCommentInput.AddString(Comment);
    m_xmlnsInput = NameSpace;
    m_xsiInput = XSI;
    m_schemaLocationInput = SchemaLocation;
    return;
}

function UpdateDocumentInfo()
{
    m_CurTopWnd.SetXMLDocumentInfo(txtCommentInput.GetString(), m_xmlnsInput, m_xsiInput, m_schemaLocationInput);
    return;
}

function HandleTrackerDetach()
{
    Clear();
    return;
}

function Clear()
{
    m_CurTopWnd = none;
    txtCommentInput.super(UIEditor_DocumentInfo).Clear();
    m_xmlnsInput = "";
    m_xsiInput = "";
    m_schemaLocationInput = "";
    return;
}
