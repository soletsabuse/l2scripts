class UIEditor_FileManager extends UICommonAPI;

const XML_EXT = ".xml";
const UC_EXT = ".uc";
const PREV_DIR = "..";
const TIMER_ID_UPDATEUI = 1022345;
const DELAY_UPDATEUI = 3000;

var WindowHandle Me;
var ListBoxHandle lstDirs;
var ListBoxHandle lstFiles;
var ButtonHandle btnLoad;
var ButtonHandle btnSave;
var ButtonHandle btnMakeUC;
var ButtonHandle exitButton;
var ButtonHandle reLoadButton;
var EditBoxHandle txtPath;
var WindowHandle WorkSheet;
var CheckBoxHandle AutoReloadCheckBox;
var string m_CurPath;
var string lastLoadedFile;
var name m_PrevStateName;

function OnRegisterEvent()
{
    RegisterEvent(1710);
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
    Update();
    return;
}

function OnShow()
{
    Me.KillTimer(1022345);
    AutoReloadCheckBox.SetCheck(false);
    return;
}

function OnHide()
{
    Me.KillTimer(1022345);
    AutoReloadCheckBox.SetCheck(false);
    return;
}

function OnTimer(int TimerID)
{
    // End:0x54
    if(TimerID == 1022345)
    {
        // End:0x54
        if(AutoReloadCheckBox.IsChecked())
        {
            reloadTargetXMLUI();
            Me.KillTimer(1022345);
            Me.SetTimer(1022345, 3000);
        }
    }
    return;
}

function OnEnterState(name a_PrevStateName)
{
    m_PrevStateName = a_PrevStateName;
    return;
}

function UpdateDirectory()
{
    local array<string> DirList;
    local int idx;

    lstDirs.Clear();
    lstFiles.Clear();
    GetDirList(DirList, m_CurPath);
    lstDirs.AddString("..");
    idx = 0;
    J0x48:

    // End:0x9F [Loop If]
    if(idx < DirList.Length)
    {
        lstDirs.AddString(DirList[idx]);
        txtPath.AddNameToAdditionalSearchList(m_CurPath $ DirList[idx], 3);
        idx++;
        // [Loop Continue]
        goto J0x48;
    }
    return;
}

function UpdateFileList()
{
    local array<string> FileList;
    local int idx;

    lstFiles.Clear();
    GetFileList(FileList, m_CurPath, ".xml");
    idx = 0;
    J0x2C:

    // End:0x83 [Loop If]
    if(idx < FileList.Length)
    {
        lstFiles.AddString(FileList[idx]);
        txtPath.AddNameToAdditionalSearchList(m_CurPath $ FileList[idx], 3);
        idx++;
        // [Loop Continue]
        goto J0x2C;
    }
    return;
}

function InitHandle()
{
    Me = GetWindowHandle("UIEditor_FileManager");
    lstDirs = GetListBoxHandle("UIEditor_FileManager.wndFileManager.lstDirs");
    lstFiles = GetListBoxHandle("UIEditor_FileManager.wndFileManager.lstFiles");
    btnLoad = GetButtonHandle("UIEditor_FileManager.wndFileManager.btnLoad");
    btnSave = GetButtonHandle("UIEditor_FileManager.wndFileManager.btnSave");
    btnMakeUC = GetButtonHandle("UIEditor_FileManager.wndFileManager.btnMakeUC");
    txtPath = GetEditBoxHandle("UIEditor_FileManager.wndFileManager.txtPath");
    WorkSheet = GetWindowHandle("Worksheet.Worksheet");
    reLoadButton = GetButtonHandle("UIEditor_FileManager.reLoadButton");
    AutoReloadCheckBox = GetCheckBoxHandle("UIEditor_FileManager.AutoReloadCheckBox");
    return;
}

function OnClickCheckBox(string strID)
{
    // End:0x74
    if(strID == "AutoReloadCheckBox")
    {
        // End:0x60
        if(AutoReloadCheckBox.IsChecked())
        {
            Me.KillTimer(1022345);
            Me.SetTimer(1022345, 3000);            
        }
        else
        {
            Me.KillTimer(1022345);
        }
    }
    return;
}

function InitControlItem()
{
    Me.SetWindowTitle("UIEditor - FileManager");
    m_CurPath = GetInterfaceDir() $ "\\Default\\";
    txtPath.SetString(m_CurPath);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string Filename;

    // End:0x81
    if(Event_ID == 1710)
    {
        // End:0x81
        if(DialogIsMine())
        {
            // End:0x4E
            if((DialogGetID()) == 98)
            {
                Filename = DialogGetString();
                // End:0x40
                if(Len(Filename) < 1)
                {
                    return;
                }
                MakeUC(Filename);                
            }
            else
            {
                // End:0x81
                if((DialogGetID()) == 99)
                {
                    Filename = DialogGetString();
                    // End:0x76
                    if(Len(Filename) < 1)
                    {
                        return;
                    }
                    SaveXMLFile(Filename);
                }
            }
        }
    }
    return;
}

function OnDBClickListBoxItem(string strID, int SelectedIndex)
{
    local string DirName;

    // End:0x15
    if(strID != "lstDirs")
    {
        return;
    }
    DirName = lstDirs.GetSelectedString();
    // End:0x4C
    if(DirName == "..")
    {
        m_CurPath = GetParentDirectory(m_CurPath);        
    }
    else
    {
        m_CurPath = m_CurPath $ DirName;
    }
    Update();
    return;
}

function Update()
{
    // End:0x20
    if(Right(m_CurPath, 1) != "\\")
    {
        m_CurPath = m_CurPath $ "\\";
    }
    SetOptionString("UIEditor", "SysPath", m_CurPath);
    txtPath.SetString(m_CurPath);
    txtPath.ClearAdditionalSearchList(3);
    UpdateDirectory();
    UpdateFileList();
    return;
}

function string GetParentDirectory(string Path)
{
    local array<string> DirList;
    local int Count, idx;
    local string NewPath;

    // End:0x13
    if(Len(Path) < 1)
    {
        return NewPath;
    }
    // End:0x3A
    if(Right(Path, 1) == "\\")
    {
        Path = Left(Path, Len(Path) - 1);
    }
    Count = Split(Path, "\\", DirList);
    // End:0x64
    if(Count == 1)
    {
        return Path;
    }
    idx = 0;
    J0x6B:

    // End:0xA4 [Loop If]
    if(idx < (Count - 1))
    {
        NewPath = (NewPath $ DirList[idx]) $ "\\";
        idx++;
        // [Loop Continue]
        goto J0x6B;
    }
    return NewPath;
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1C
        case "btnLoad":
            OnLoadClick();
            // End:0x9A
            break;
        // End:0x31
        case "btnSave":
            OnSaveClick();
            // End:0x9A
            break;
        // End:0x48
        case "btnMakeUC":
            OnMakeClick();
            // End:0x9A
            break;
        // End:0x7D
        case "exitButton":
            Update();
            ExecuteCommand("///setstate " $ string(m_PrevStateName));
            // End:0x9A
            break;
        // End:0x97
        case "reLoadButton":
            reloadTargetXMLUI();
            // End:0x9A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnCompleteEditBox(string strID)
{
    switch(strID)
    {
        // End:0x31
        case "txtPath":
            m_CurPath = txtPath.GetString();
            Update();
            // End:0x34
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnLoadClick()
{
    local WindowHandle NewControl;
    local string Filename, FullName;

    // End:0x31
    if(WorkSheet == none)
    {
        DialogShow(1, 1, "Can't Find Worksheet.", string(self));
        return;
    }
    Filename = lstFiles.GetSelectedString();
    // End:0x7B
    if(Len(Filename) < 1)
    {
        DialogShow(1, 1, "Please Select XML File.", string(self));
        return;
    }
    FullName = m_CurPath $ Filename;
    NewControl = WorkSheet.LoadXMLWindow(FullName);
    // End:0xDA
    if(NewControl == none)
    {
        DialogShow(1, 1, "Load XML Window Failed!", string(self));
        return;
    }
    lastLoadedFile = FullName;
    NewControl.SetScript("UIEditor_Worksheet");
    NewControl.ConvertToEditable();
    NewControl.SetFocus();
    return;
}

function reloadTargetXMLUI()
{
    local WindowHandle NewControl;
    local array<WindowHandle> WindowList;
    local int i;

    // End:0x31
    if(WorkSheet == none)
    {
        DialogShow(1, 1, "Can't Find Worksheet.", string(self));
        return;
    }
    WorkSheet.SetFocus();
    WorkSheet.GetChildWindowList(WindowList);
    i = 0;
    J0x5B:

    // End:0x96 [Loop If]
    if(i < WindowList.Length)
    {
        WindowList[i].SetFocus();
        DeleteAttachedWindow();
        ClearTracker();
        i++;
        // [Loop Continue]
        goto J0x5B;
    }
    NewControl = WorkSheet.LoadXMLWindow(lastLoadedFile);
    // End:0xE3
    if(NewControl == none)
    {
        DialogShow(1, 1, "Load XML Window Failed!", string(self));
        return;
    }
    NewControl.SetScript("UIEditor_Worksheet");
    NewControl.ConvertToEditable();
    NewControl.SetFocus();
    return;
}

function OnSaveClick()
{
    local string Filename;

    Filename = lstFiles.GetSelectedString();
    DialogSetEditBoxMaxLength(100);
    DialogSetID(99);
    DialogShow(1, 2, "Input File Name.", string(self));
    DialogSetString(Filename);
    return;
}

function OnMakeClick()
{
    local WindowHandle TrackerWnd, TopWnd;
    local string ScriptName, Filename;

    TrackerWnd = GetTrackerAttachedWindow();
    // End:0x45
    if(TrackerWnd == none)
    {
        DialogShow(1, 1, "Select Target Window to save.", string(self));
        return;
    }
    TopWnd = TrackerWnd.GetTopFrameWnd();
    // End:0x9B
    if(TopWnd == none)
    {
        DialogShow(1, 1, "Target Window Have No XML Infomation.", string(self));
        return;
    }
    ScriptName = TopWnd.GetScriptName();
    // End:0xF0
    if(Len(ScriptName) < 1)
    {
        DialogShow(1, 1, "Target Window Have No Script Name.", string(self));
        return;
    }
    Filename = ScriptName $ ".uc";
    DialogSetEditBoxMaxLength(100);
    DialogSetID(98);
    DialogShow(1, 2, "Input Script File Name.", string(self));
    DialogSetString(Filename);
    return;
}

function SaveXMLFile(string Filename)
{
    local WindowHandle TrackerWnd, TopWnd;
    local string FullName;

    // End:0x3A
    if(Len(Filename) < 1)
    {
        DialogShow(1, 1, "Please Input Save File Name!", string(self));
        return;
    }
    TrackerWnd = GetTrackerAttachedWindow();
    // End:0x7F
    if(TrackerWnd == none)
    {
        DialogShow(1, 1, "Select Target Window to save.", string(self));
        return;
    }
    TopWnd = TrackerWnd.GetTopFrameWnd();
    // End:0xD5
    if(TopWnd == none)
    {
        DialogShow(1, 1, "Target Window Have No XML Infomation.", string(self));
        return;
    }
    FullName = m_CurPath $ Filename;
    // End:0x12C
    if(TopWnd.SaveXMLWindow(FullName))
    {
        DialogShow(1, 1, ("Save Complete. (" $ FullName) $ ")", string(self));        
    }
    else
    {
        DialogShow(1, 1, "Save Failed. OTL", string(self));
    }
    Update();
    return;
}

function MakeUC(string Filename)
{
    local WindowHandle TrackerWnd, TopWnd;
    local array<string> NameList;
    local int idx, Count;
    local string UCName, FullName;

    // End:0x3A
    if(Len(Filename) < 1)
    {
        DialogShow(1, 1, "Please Input Save File Name!", string(self));
        return;
    }
    Count = Split(Filename, ".", NameList);
    // End:0x82
    if(("." $ NameList[Count - 1]) != ".uc")
    {
        Filename = Filename $ ".uc";
    }
    Count = Split(Filename, ".", NameList);
    idx = 0;
    J0xA2:

    // End:0xF1 [Loop If]
    if(idx < (Count - 1))
    {
        // End:0xCF
        if(idx > 0)
        {
            UCName = UCName $ ".";
        }
        UCName = UCName $ NameList[idx];
        idx++;
        // [Loop Continue]
        goto J0xA2;
    }
    TrackerWnd = GetTrackerAttachedWindow();
    // End:0x136
    if(TrackerWnd == none)
    {
        DialogShow(1, 1, "Select Target Window to save.", string(self));
        return;
    }
    TopWnd = TrackerWnd.GetTopFrameWnd();
    // End:0x18C
    if(TopWnd == none)
    {
        DialogShow(1, 1, "Target Window Have No XML Infomation.", string(self));
        return;
    }
    FullName = m_CurPath $ Filename;
    // End:0x1E8
    if(TopWnd.MakeBaseUC(UCName, FullName))
    {
        DialogShow(1, 1, ("Save Complete. (" $ FullName) $ ")", string(self));        
    }
    else
    {
        DialogShow(1, 1, "Save Failed. OTL", string(self));
    }
    return;
}
