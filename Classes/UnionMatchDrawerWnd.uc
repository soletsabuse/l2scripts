class UnionMatchDrawerWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle txtTitle1;
var TextBoxHandle txtTitle2;
var ButtonHandle btnPrev;
var ButtonHandle BtnNext;
var ButtonHandle btnWhisper;
var ButtonHandle btnRefresh;
var ListCtrlHandle lstParty;
var TextureHandle txListTitleBg;
var TextureHandle txListBg;
var TextureHandle txLine;
var ButtonHandle btnClose;

function OnRegisterEvent()
{
    RegisterEvent(4080);
    return;
}

function OnLoad()
{
    Initialize();
    load();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("UnionMatchDrawerWnd");
    txtTitle1 = GetTextBoxHandle("UnionMatchDrawerWnd.txtTitle1");
    txtTitle2 = GetTextBoxHandle("UnionMatchDrawerWnd.txtTitle2");
    btnPrev = GetButtonHandle("UnionMatchDrawerWnd.btnPrev");
    BtnNext = GetButtonHandle("UnionMatchDrawerWnd.btnNext");
    btnWhisper = GetButtonHandle("UnionMatchDrawerWnd.btnWhisper");
    btnRefresh = GetButtonHandle("UnionMatchDrawerWnd.btnRefresh");
    lstParty = GetListCtrlHandle("UnionMatchDrawerWnd.lstParty");
    txListTitleBg = GetTextureHandle("UnionMatchDrawerWnd.txListTitleBg");
    txListBg = GetTextureHandle("UnionMatchDrawerWnd.txListBg");
    txLine = GetTextureHandle("UnionMatchDrawerWnd.txLine");
    btnClose = GetButtonHandle("UnionMatchDrawerWnd.btnClose");
    return;
}

function load()
{
    btnPrev.DisableWindow();
    BtnNext.DisableWindow();
    return;
}

function OnEvent(int a_EventID, string param)
{
    switch(a_EventID)
    {
        // End:0x1D
        case 4080:
            HandleMpccPartyMasterList(param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleMpccPartyMasterList(string param)
{
    local int PartyMasterCnt, idx;
    local string Name;
    local LVDataRecord Record;

    lstParty.DeleteAllItem();
    ParseInt(param, "PartyMasterCnt", PartyMasterCnt);
    Record.LVDataList.Length = 1;
    idx = 1;
    J0x43:

    // End:0xA6 [Loop If]
    if(idx <= PartyMasterCnt)
    {
        ParseString(param, "Name" $ string(idx), Name);
        Record.LVDataList[0].szData = Name;
        lstParty.InsertRecord(Record);
        idx++;
        // [Loop Continue]
        goto J0x43;
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1F
        case "btnWhisper":
            OnbtnWhisperClick();
            // End:0x50
            break;
        // End:0x37
        case "btnRefresh":
            OnbtnRefreshClick();
            // End:0x50
            break;
        // End:0x4D
        case "btnClose":
            OnBtnCloseClick();
            // End:0x50
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnbtnWhisperClick()
{
    local int idx;
    local LVDataRecord Record;
    local string Name;
    local EditBoxHandle ChatEditBox;

    idx = lstParty.GetSelectedIndex();
    // End:0x22
    if(idx < 0)
    {
        return;
    }
    lstParty.GetRec(idx, Record);
    Name = Record.LVDataList[0].szData;
    // End:0xAE
    if(Name != "")
    {
        SetChatMessage(("\"" $ Name) $ " ");
        ChatEditBox = GetEditBoxHandle("ChatWnd.ChatEditBox");
        // End:0xAE
        if(ChatEditBox != none)
        {
            ChatEditBox.SetFocus();
        }
    }
    return;
}

function OnbtnRefreshClick()
{
    Class'NWindow.PartyMatchAPI'.static.RequestMpccPartymasterList();
    return;
}

function OnBtnCloseClick()
{
    Me.HideWindow();
    return;
}
