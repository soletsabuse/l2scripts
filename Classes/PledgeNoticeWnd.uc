class PledgeNoticeWnd extends PacketsInfo;

const LINK_MAX = 3;
const LINK_MIN_LENGTH = 5;

enum ePledgeNoticeState
{
    PNS_MASTER,                     // 0
    PNS_MEMBER                      // 1
};

struct sPledgeNotice
{
    var string Title;
    var string Desc;
    var array<string> webLinks;
    var string webLink1;
    var string webLink2;
    var string webLink3;
};

var string m_WindowName;
var WindowHandle Me;
var sPledgeNotice currentNoticeInfo;
var ButtonHandle EditBtn;
var PledgeNoticeWnd.ePledgeNoticeState nCurrentState;
var WindowHandle MasterViewWnd;
var EditBoxHandle edit_titleNameEBox;
var MultiEditBoxHandle edit_descNameMBox;
var EditBoxHandle edit_linkNameEBox[3];
var WindowHandle MemberViewWnd;
var TextureHandle PledgeHeadTx;
var ButtonHandle ToggleShowBtn;
var TextBoxHandle PledgeTitleTxt;
var MultiEditBoxHandle PledgeDescTxt;
var TextBoxHandle linkNameEBox[3];
var TextBoxHandle PledgeNoWebTxt;
var array<int> nNewLineIndex;

function OnLoad()
{
    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    MasterViewWnd = GetWindowHandle("PledgeNoticeWnd.ContentWnd.MasterViewWnd");
    EditBtn = GetButtonHandle("PledgeNoticeWnd.ContentWnd.EditBtn");
    PledgeHeadTx = GetTextureHandle("PledgeNoticeWnd.ContentWnd.MasterViewWnd.PledgeHeadTx");
    ToggleShowBtn = GetButtonHandle("PledgeNoticeWnd.ContentWnd.MasterViewWnd.ToggleShowBtn");
    edit_titleNameEBox = GetEditBoxHandle("PledgeNoticeWnd.ContentWnd.MasterViewWnd.TitileInput");
    edit_descNameMBox = GetMultiEditBoxHandle("PledgeNoticeWnd.ContentWnd.MasterViewWnd.DescInput");
    edit_linkNameEBox[0] = GetEditBoxHandle("PledgeNoticeWnd.ContentWnd.MasterViewWnd.WebLink1");
    edit_linkNameEBox[1] = GetEditBoxHandle("PledgeNoticeWnd.ContentWnd.MasterViewWnd.WebLink2");
    edit_linkNameEBox[2] = GetEditBoxHandle("PledgeNoticeWnd.ContentWnd.MasterViewWnd.WebLink3");
    MemberViewWnd = GetWindowHandle("PledgeNoticeWnd.ContentWnd.MemberViewWnd");
    PledgeTitleTxt = GetTextBoxHandle("PledgeNoticeWnd.ContentWnd.MemberViewWnd.PledgeTitleTxt");
    PledgeDescTxt = GetMultiEditBoxHandle("PledgeNoticeWnd.ContentWnd.MemberViewWnd.PledgeDescTxt");
    linkNameEBox[0] = GetTextBoxHandle("PledgeNoticeWnd.ContentWnd.MemberViewWnd.PledgeWeb1Txt");
    linkNameEBox[1] = GetTextBoxHandle("PledgeNoticeWnd.ContentWnd.MemberViewWnd.PledgeWeb2Txt");
    linkNameEBox[2] = GetTextBoxHandle("PledgeNoticeWnd.ContentWnd.MemberViewWnd.PledgeWeb3Txt");
    PledgeNoWebTxt = GetTextBoxHandle("PledgeNoticeWnd.ContentWnd.MemberViewWnd.PledgeNoWebTxt");
    ToggleShowBtn.SetAlpha(200);
    nCurrentState = 1;
    setState(1);
    return;
}

function OnShow()
{
    return;
}

function OnHide()
{
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(3550);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x15
    if(Event_ID == 1710)
    {
        HandleDialogOK();
    }
    // End:0x2F
    if(Event_ID == 3550)
    {
        _OnEvent(param);
    }
    return;
}

function _OnEvent(string param)
{
    local int Event_ID;

    ParseInt(param, "EventID", Event_ID);
    switch(Event_ID)
    {
        // End:0x36
        case 1300:
            handlePledgeNoticeInfo(param);
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            // End:0x3C
            break;
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x6F
        case "ApplyBtn":
            evRqSaveMyClanNotice(edit_titleNameEBox.GetString(), edit_descNameMBox.GetString(), edit_linkNameEBox[0].GetString(), edit_linkNameEBox[1].GetString(), edit_linkNameEBox[2].GetString());
            // End:0xA5
            break;
        // End:0x84
        case "EditBtn":
            toggleState();
            // End:0xA5
            break;
        // End:0x9F
        case "ToggleShowBtn":
            toggleONOFF();
            // End:0xA5
            break;
        // End:0xFFFF
        default:
            // End:0xA5
            break;
            break;
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local int Index;

    // End:0xE3
    if(((a_WindowHandle.GetWindowName() == "PledgeWeb1Txt") || a_WindowHandle.GetWindowName() == "PledgeWeb2Txt") || a_WindowHandle.GetWindowName() == "PledgeWeb3Txt")
    {
        // End:0x8C
        if(Len(TextBoxHandle(a_WindowHandle).GetText()) < 5)
        {
            return;
        }
        DialogSetID(-1773790777);
        DialogSetStr(TextBoxHandle(a_WindowHandle).GetText());
        DialogShow(0, 0, MakeFullSystemMsg(GetSystemString(8073), TextBoxHandle(a_WindowHandle).GetText()), string(self));
    }
    return;
}

function HandleDialogOK()
{
    // End:0x2E
    if(DialogIsMine())
    {
        switch(DialogGetID())
        {
            // End:0x28
            case -1773790777:
                OpenGivenURL(DialogGetStr());
                // End:0x2E
                break;
            // End:0xFFFF
            default:
                // End:0x2E
                break;
                break;
        }
    }
    return;
}

function OnChangeEditBox(string strID)
{
    local string strCount;

    // End:0x15
    if(strID == "DescInput")
    {
    }
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x53
    if(a_WindowHandle == edit_descNameMBox)
    {
        // End:0x53
        if(a_WindowHandle.IsFocused())
        {
            // End:0x53
            if(int(nKey) == 13)
            {
                edit_descNameMBox.SetString(edit_descNameMBox.GetString() $ Chr(127));
            }
        }
    }
    return;
}

function toggleONOFF()
{
    local string Cmd, arg, ButtonHandle;

    ToggleShowBtn.SetButtonValue(ToggleShowBtn.GetButtonValue() ^ 1);
    setoNOFF(ToggleShowBtn.GetButtonValue());
    evRqToggleClanNotice(ToggleShowBtn.GetButtonValue());
    return;
}

function setoNOFF(int nOpen)
{
    // End:0x84
    if(nOpen == 0)
    {
        ToggleShowBtn.SetTexture("L2UI_NewTex.L2PassWnd.Off", "L2UI_NewTex.L2PassWnd.Off", "L2UI_NewTex.L2PassWnd.Off");
        PledgeHeadTx.SetAlpha(140, 0.1000000);        
    }
    else
    {
        ToggleShowBtn.SetTexture("L2UI_NewTex.L2PassWnd.On", "L2UI_NewTex.L2PassWnd.On", "L2UI_NewTex.L2PassWnd.On");
        PledgeHeadTx.SetAlpha(255, 0.1000000);
    }
    ToggleShowBtn.SetButtonValue(nOpen);
    return;
}

function handlePledgeNoticeInfo(string param)
{
    local int i, nOpen, nMaster;
    local string Title, Desc, linksParam;
    local array<string> links;

    ParseInt(param, "ask", nOpen);
    ParseInt(param, "reply", nMaster);
    ParseString(param, "param1", Title);
    ParseString(param, "param2", Desc);
    ParseString(param, "param3", linksParam);
    links = Arr(linksParam, ";");
    currentNoticeInfo.Title = Title;
    currentNoticeInfo.Desc = Desc;
    currentNoticeInfo.webLinks.Remove(0, currentNoticeInfo.webLinks.Length);
    i = 0;
    J0xC6:

    // End:0x12A [Loop If]
    if(i < links.Length)
    {
        // End:0x120
        if((links[i] != "") && Len(links[i]) > 5)
        {
            currentNoticeInfo.webLinks[currentNoticeInfo.webLinks.Length] = links[i];
        }
        i++;
        // [Loop Continue]
        goto J0xC6;
    }
    currentNoticeInfo.webLink1 = links[0];
    currentNoticeInfo.webLink2 = links[1];
    currentNoticeInfo.webLink3 = links[2];
    toggleHeadUI(nOpen, nMaster == 1);
    setState(1);
    Me.ShowWindow();
    return;
}

function toggleHeadUI(int nOpen, bool bIsMaster)
{
    // End:0x35
    if(bIsMaster)
    {
        setoNOFF(nOpen);
        ToggleShowBtn.ShowWindow();
        EditBtn.ShowWindow();        
    }
    else
    {
        ToggleShowBtn.HideWindow();
        EditBtn.HideWindow();
    }
    return;
}

function setState(PledgeNoticeWnd.ePledgeNoticeState nState)
{
    ClearAll();
    MasterViewWnd.SetAlpha(0);
    MemberViewWnd.SetAlpha(0);
    switch(nState)
    {
        // End:0x6F
        case 0:
            MasterViewWnd.ShowWindow();
            MemberViewWnd.HideWindow();
            MasterViewWnd.SetAlpha(255, 0.3500000);
            showMasterViewInfo();
            // End:0xB7
            break;
        // End:0xB1
        case 1:
            MasterViewWnd.HideWindow();
            MemberViewWnd.ShowWindow();
            MemberViewWnd.SetAlpha(255, 0.3500000);
            showMemberViewInfo();
            // End:0xB7
            break;
        // End:0xFFFF
        default:
            // End:0xB7
            break;
            break;
    }
    return;
}

function toggleState()
{
    // End:0x18
    if(int(nCurrentState) == 1)
    {
        nCurrentState = 0;        
    }
    else
    {
        // End:0x2D
        if(int(nCurrentState) == 0)
        {
            nCurrentState = 1;
        }
    }
    setState(nCurrentState);
    return;
}

function ClearAll()
{
    edit_titleNameEBox.SetString("");
    edit_descNameMBox.SetString("");
    edit_linkNameEBox[0].SetString("");
    edit_linkNameEBox[1].SetString("");
    edit_linkNameEBox[2].SetString("");
    PledgeNoWebTxt.HideWindow();
    PledgeTitleTxt.SetText("");
    PledgeDescTxt.SetString("");
    PledgeDescTxt.DisableWindow();
    linkNameEBox[0].SetText("");
    linkNameEBox[1].SetText("");
    linkNameEBox[2].SetText("");
    return;
}

function showMasterViewInfo()
{
    local int i;
    local string magic;

    // End:0x2A
    if(currentNoticeInfo.Title != "")
    {
        edit_titleNameEBox.SetString(currentNoticeInfo.Title);
    }
    // End:0x88
    if(currentNoticeInfo.Desc != "")
    {
        edit_descNameMBox.SetString(currentNoticeInfo.Desc);
        magic = Locs(edit_descNameMBox.GetString(), "\\n", Chr(127), false);
        edit_descNameMBox.SetString(magic);
    }
    i = 0;
    J0x8F:

    // End:0xEA [Loop If]
    if(i < currentNoticeInfo.webLinks.Length)
    {
        // End:0xE0
        if(currentNoticeInfo.webLinks[i] != "")
        {
            edit_linkNameEBox[i].SetString(currentNoticeInfo.webLinks[i]);
        }
        i++;
        // [Loop Continue]
        goto J0x8F;
    }
    return;
}

function showMemberViewInfo()
{
    local int i;
    local bool bWeb;
    local string magic;

    PledgeTitleTxt.SetText(currentNoticeInfo.Title);
    PledgeDescTxt.SetString(currentNoticeInfo.Desc);
    magic = Locs(PledgeDescTxt.GetString(), "\\n", Chr(127), false);
    PledgeDescTxt.SetString(magic);
    PledgeDescTxt.DisableWindow();
    bWeb = false;
    i = 0;
    J0x84:

    // End:0xE7 [Loop If]
    if(i < currentNoticeInfo.webLinks.Length)
    {
        // End:0xDD
        if(currentNoticeInfo.webLinks[i] != "")
        {
            bWeb = true;
            linkNameEBox[i].SetText(currentNoticeInfo.webLinks[i]);
        }
        i++;
        // [Loop Continue]
        goto J0x84;
    }
    // End:0x101
    if(!bWeb)
    {
        PledgeNoWebTxt.ShowWindow();
    }
    return;
}

function evRqSaveMyClanNotice(string Title, string Desc, string web1, string web2, string web3)
{
    local string LINE;

    // End:0x3B
    if((Len(Title) < 4) || Len(Title) > 50)
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(8074));
        return;
    }
    // End:0x79
    if((Len(Desc) < 10) || Len(Desc) > 400)
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(8075));
        return;
    }
    // End:0xC4
    if(((Len(web1) > 50) || Len(web2) > 50) || Len(web3) > 50)
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(8076));
        return;
    }
    getInstanceL2Util().showGfxScreenMessage(GetSystemString(8077));
    LINE = Locs(Desc, Chr(127), "\\n", false);
    RequestBypassToServer((((((((("myClanNotice Edit " $ Title) @ "||") @ LINE) $ "||") @ (trim(web1))) @ "||") @ (trim(web2))) @ "||") @ (trim(web3)));
    return;
}

function evRqToggleClanNotice(int nOpen)
{
    // End:0x29
    if(nOpen == 1)
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(8079));        
    }
    else
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(8078));
    }
    RequestBypassToServer("myClanNotice Toggle" @ string(nOpen));
    return;
}

function evRqClanNotice()
{
    RequestBypassToServer("myClanNotice Open");
    return;
}

function OnSetFocus(WindowHandle Handle, bool bFocused)
{
    // End:0x3B
    if(Handle == PledgeDescTxt)
    {
        // End:0x3B
        if(PledgeDescTxt.IsFocused() || bFocused)
        {
            PledgeDescTxt.ReleaseFocus();
        }
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x44
    if(TimerID == 1001)
    {
        Me.KillTimer(TimerID);
        // End:0x44
        if(PledgeDescTxt.IsFocused())
        {
            PledgeDescTxt.ReleaseFocus();
        }
    }
    return;
}
