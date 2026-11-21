class ReplayListWnd extends UICommonAPI;

const REPLAY_DIR = "..\\REPLAY";
const REPLAY_EXTENSION = ".L2R";
const DIALOG_DEL_CONFIRM = 8889;

var array<string> m_StrFileList;
var ListCtrlHandle m_hRecordList;
var CheckBoxHandle m_hChkCameraInst;
var CheckBoxHandle m_hChkChatData;

function OnLoad()
{
    m_hRecordList = GetListCtrlHandle("ReplayListWnd.ReplayListCtrl");
    m_hChkCameraInst = GetCheckBoxHandle("ReplayListWnd.chkLoadCamInst");
    m_hChkChatData = GetCheckBoxHandle("ReplayListWnd.chkLoadChatData");
    return;
}

function OnShow()
{
    InitReplayList();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function InitReplayList()
{
    local array<string> strReplayFileList;
    local int i, iLength;
    local string strFileName;

    m_hRecordList.DeleteAllItem();
    GetFileList(strReplayFileList, "..\\REPLAY", ".L2R");
    i = 0;
    J0x32:

    // End:0x91 [Loop If]
    if(i < strReplayFileList.Length)
    {
        iLength = Len(strReplayFileList[i]) - Len(".L2R");
        strFileName = Left(strReplayFileList[i], iLength);
        AddItem(i, strFileName);
        ++i;
        // [Loop Continue]
        goto J0x32;
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x18
        case 1710:
            HandleDialogOK();
            // End:0x26
            break;
        // End:0x23
        case 1720:
            // End:0x26
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function AddItem(int iNum, string strFileName)
{
    local LVDataRecord Record;
    local LVData Data;

    Data.szData = string(iNum);
    Record.LVDataList[0] = Data;
    Data.szData = strFileName;
    Record.LVDataList[1] = Data;
    m_hRecordList.InsertRecord(Record);
    return;
}

function string GetSelectedFileName()
{
    local int Index;
    local LVDataRecord Record;
    local string strFileName;

    Index = m_hRecordList.GetSelectedIndex();
    // End:0x50
    if(Index >= 0)
    {
        m_hRecordList.GetRec(Index, Record);
        strFileName = Record.LVDataList[1].szData;
    }
    return strFileName;
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    OnOk();
    return;
}

function HandleDialogOK()
{
    local int Id;

    // End:0x30
    if(DialogIsMine())
    {
        Id = DialogGetID();
        // End:0x30
        if(Id == 8889)
        {
            OnDelete();
            InitReplayList();
        }
    }
    return;
}

function askDelDialog()
{
    local WindowHandle m_dialogWnd;
    local string strFileName;

    strFileName = GetSelectedFileName();
    // End:0x1A
    if(strFileName == "")
    {
        return;
    }
    m_dialogWnd = GetWindowHandle("DialogBox");
    // End:0x68
    if(!m_dialogWnd.IsShowWindow())
    {
        DialogSetID(8889);
        DialogShow(0, 0, GetSystemMessage(3719), string(self));
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1A
        case "btnOK":
            OnOk();
            // End:0x54
            break;
        // End:0x2E
        case "btnDel":
            askDelDialog();
            // End:0x54
            break;
        // End:0x51
        case "btnCancel":
            SetUIState("LoginState");
            // End:0x54
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnOk()
{
    local string strFileName;
    local bool bLoadCameraInst, bLoadChatData;

    strFileName = GetSelectedFileName();
    // End:0x1A
    if(strFileName == "")
    {
        return;
    }
    bLoadCameraInst = m_hChkCameraInst.IsChecked();
    bLoadChatData = m_hChkChatData.IsChecked();
    BeginReplay(strFileName, bLoadCameraInst, bLoadChatData);
    return;
}

function OnDelete()
{
    local string strFileName;

    strFileName = GetSelectedFileName();
    // End:0x1A
    if(strFileName == "")
    {
        return;
    }
    EraseReplayFile(((("..\\REPLAY" $ "\\") $ strFileName) $ "") $ ".L2R");
    return;
}
