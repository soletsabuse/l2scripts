class UIServerHtmlToolWnd extends UICommonAPI;

const TIME_ID = 2001111;
const TIME_DELAY = 100;

var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var string m_fileName;

function OnLoad()
{
    SetClosingOnESC();
    Me = GetWindowHandle("UIServerHtmlToolWnd");
    FileListCtrl = GetListCtrlHandle("UIServerHtmlToolWnd.fileListCtrl");
    FileListCtrl.SetHeaderAlignment(0, 1);
    FileListCtrl.SetResizable(false);
    EditBoxCtrl = GetEditBoxHandle("UIServerHtmlToolWnd.fileNameEditBox");
    Me.SetWindowTitle("UIPowerTools - [ ServerHtmlTool ]");
    return;
}

function int SearchFileListWithName(string S)
{
    local int i, Num;
    local LVDataRecord Record;

    Num = FileListCtrl.GetRecordCount();
    i = 0;
    J0x1C:

    // End:0x6F [Loop If]
    if(i < Num)
    {
        FileListCtrl.GetRec(i, Record);
        // End:0x65
        if(Record.LVDataList[0].szData == S)
        {
            return i;
        }
        ++i;
        // [Loop Continue]
        goto J0x1C;
    }
    return -1;
    return;
}

function OnDBClickListCtrlRecord(string strID)
{
    local int idx;
    local LVDataRecord Record;

    // End:0x1A
    if(strID != "fileListCtrl")
    {
        return;
    }
    idx = FileListCtrl.GetSelectedIndex();
    // End:0x3C
    if(idx < 0)
    {
        return;
    }
    FileListCtrl.GetRec(idx, Record);
    // End:0x84
    if(Record.LVDataList[0].szData != "")
    {
        loadServerHtml(Record.LVDataList[0].szData);
    }
    FileListCtrl.SetFocus();
    Me.KillTimer(2001111);
    Me.SetTimer(2001111, 100);
    return;
}

function OnTimer(int TimeID)
{
    // End:0x32
    if(TimeID == 2001111)
    {
        FileListCtrl.SetFocus();
        Me.KillTimer(2001111);
    }
    return;
}

function OnClickListCtrlRecord(string strID)
{
    local int idx;
    local LVDataRecord Record;

    // End:0x1A
    if(strID != "fileListCtrl")
    {
        return;
    }
    idx = FileListCtrl.GetSelectedIndex();
    // End:0x3C
    if(idx < 0)
    {
        return;
    }
    FileListCtrl.GetRec(idx, Record);
    EditBoxCtrl.SetString(Record.LVDataList[0].szData);
    return;
}

function addHtmlFileAtList(string Filename)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 1;
    Record.LVDataList[0].szData = Filename;
    FileListCtrl.InsertRecord(Record);
    return;
}

function OnShow()
{
    EditBoxCtrl.Clear();
    FileListCtrl.InitListCtrl();
    FileListCtrl.DeleteAllItem();
    return;
}

function getHtmlListInINI()
{
    local string tempstring;
    local int i, fileCount;

    EditBoxCtrl.Clear();
    FileListCtrl.DeleteAllItem();
    GetINIString("HtmlList", "totalFileCount", tempstring, "serverHtmlList.ini");
    fileCount = int(tempstring);
    i = 0;
    J0x6B:

    // End:0xC7 [Loop If]
    if(i < fileCount)
    {
        GetINIString("HtmlList", "html" $ string(i), tempstring, "serverHtmlList.ini");
        addHtmlFileAtList(tempstring);
        i++;
        // [Loop Continue]
        goto J0x6B;
    }
    return;
}

function OnHide()
{
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x36
        case "htmlSmallViewButton":
            OnDBClickListCtrlRecord("fileListCtrl");
            // End:0x54
            break;
        // End:0x51
        case "refreshButton":
            getHtmlListInINI();
            // End:0x54
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function loadServerHtml(string htmlFileName)
{
    ExecuteCommand("//loadhtml " $ htmlFileName);
    EditBoxCtrl.AddNameToAdditionalSearchList(htmlFileName, 3);
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x4D
    if(EditBoxCtrl.IsFocused())
    {
        // End:0x4A
        if(int(nKey) == int(13))
        {
            Debug("EditBoxCtrl");
            loadServerHtml(EditBoxCtrl.GetString());
        }        
    }
    else
    {
        // End:0x95
        if(FileListCtrl.IsFocused())
        {
            // End:0x95
            if(int(nKey) == int(13))
            {
                Debug("파일리스트");
                OnDBClickListCtrlRecord("fileListCtrl");
            }
        }
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("UIServerHtmlToolWnd").HideWindow();
    return;
}
