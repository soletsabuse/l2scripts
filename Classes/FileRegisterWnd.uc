class FileRegisterWnd extends UICommonAPI;

var bool m_bShow;
var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var ComboBoxHandle FilePathComboBoxCtrl;
var ComboBoxHandle FileExtComboBoxCtrl;
var string m_filePath;
var string FileTextureName;
var string FolderTextureName;
var string UpFolderTextureName;
var string CurrentForerTextureName;
var string DesktopTextureName;
var string MyDocumentsTextureName;
var string DriveTextureName;
var UICommonAPI._FileHandler FileHandler;
var bool IsIdle;
var string m_fileName;

function ShowFileRegisterWnd(UICommonAPI._FileHandler filehandlertype)
{
    // End:0x0B
    if(m_bShow)
    {
        return;
    }
    FileHandler = filehandlertype;
    switch(FileHandler)
    {
        // End:0x3F
        case 1:
            Me.SetWindowTitle(GetSystemString(2229));
            // End:0x8B
            break;
        // End:0x61
        case 2:
            Me.SetWindowTitle(GetSystemString(2229));
            // End:0x8B
            break;
        // End:0x66
        case 3:
        // End:0x6B
        case 4:
        // End:0xFFFF
        default:
            Me.SetWindowTitle(GetSystemString(2229));
            // End:0x8B
            break;
            break;
    }
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function FileRegisterWndShowByTypeStr(string numStr)
{
    Debug("FileRegisterWndShowByTypeStr : " @ numStr);
    switch(numStr)
    {
        // End:0x5B
        case "FH_PLEDGE_CREST_UPLOAD":
            ShowFileRegisterWnd(1);
            // End:0x11F
            break;
        // End:0x82
        case "FH_PLEDGE_EMBLEM_UPLOAD":
            ShowFileRegisterWnd(2);
            // End:0x11F
            break;
        // End:0xAA
        case "FH_ALLIANCE_CREST_UPLOAD":
            ShowFileRegisterWnd(3);
            // End:0x11F
            break;
        // End:0xD3
        case "FH_WEBBROWSER_FILE_UPLOAD":
            ShowFileRegisterWnd(4);
            // End:0x11F
            break;
        // End:0xFFFF
        default:
            Debug("Error: FileRegisterWndShowByNum 함수에 잘못된 번호를 넣음:" @ numStr);
            break;
    }
    return;
}

function HideFileRegisterWnd()
{
    Me.HideWindow();
    return;
}

function AddFileExt(string Str, array<string> strArray)
{
    FileExtComboBoxCtrl.AddStringWithFileExt(Str, strArray);
    return;
}

function ClearFileExt()
{
    FileExtComboBoxCtrl.Clear();
    return;
}

function bool RequestWebBrowserRegisterByFilePath(string Path)
{
    local WebBrowserWnd script;

    script = WebBrowserWnd(GetScript("WebBrowserWnd"));
    Debug("RequestWebBrowserRegisterByFilePath");
    script.UploadFileFullPath(Path);
    return true;
    return;
}

function bool UploadFile(string filePath, string Filename)
{
    local string filestr;

    filestr = (filePath $ "\\") $ Filename;
    // End:0x29
    if(int(FileHandler) >= int(5))
    {
        return true;
    }
    SetOptionString("Game", "FileRegisterPath" $ string(FileHandler), filePath);
    UploadFileFullPath(filestr);
    return;
}

function bool UploadFileFullPath(string Path)
{
    // End:0x12
    if(int(FileHandler) >= int(5))
    {
        return true;
    }
    switch(FileHandler)
    {
        // End:0x20
        case 0:
            return true;
        // End:0x40
        case 1:
            Me.HideWindow();
            return RequestClanRegisterCrestByFilePath(Path);
        // End:0x60
        case 2:
            Me.HideWindow();
            return RequestClanRegisterEmblemByFilePath(Path);
        // End:0x80
        case 3:
            Me.HideWindow();
            return RequestAllianceRegisterCrestByFilePath(Path);
        // End:0xA0
        case 4:
            Me.HideWindow();
            return RequestWebBrowserRegisterByFilePath(Path);
        // End:0xFFFF
        default:
            return true;
            break;
    }
    return;
}

function OnLoad()
{
    local array<string> strArray;

    SetClosingOnESC();
    IsIdle = true;
    FileHandler = 0;
    FileTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_BMP";
    FolderTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Folder";
    UpFolderTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_FolderUp";
    CurrentForerTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_FolderOpen";
    DesktopTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Desktop";
    MyDocumentsTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_MyDocument";
    DriveTextureName = "L2UI_CT1.FileRegisterWnd_DF_Icon_Drive";
    // End:0x170
    if(1 == 0)
    {        
    }
    else
    {
        Me = GetWindowHandle("FileRegisterWnd");
        FileListCtrl = GetListCtrlHandle("FileRegisterWnd.fileListCtrl");
        FileListCtrl.SetHeaderAlignment(0, 1);
        FileListCtrl.SetResizable(false);
        EditBoxCtrl = GetEditBoxHandle("FileRegisterWnd.fileNameEditBox");
        FilePathComboBoxCtrl = GetComboBoxHandle("FileRegisterWnd.FileLocationComboBox");
        FileExtComboBoxCtrl = GetComboBoxHandle("FileRegisterWnd.FileTypeComboBox");
        FileListCtrl.SetHeaderTextOffset(0, 135);
        strArray.Length = 1;
        strArray[0] = "*";
        FileExtComboBoxCtrl.AddStringWithFileExt(GetSystemString(5861), strArray);
        SetFilePathnAdjustControl(GetMydocumentPath());
    }
    m_bShow = false;
    return;
}

function SetFilePathnAdjustControl(string S)
{
    local array<FileNameInfo> fInfoArray;
    local array<string> fExtArray;

    EditBoxCtrl.Clear();
    UpdateFilePathComboBox(S);
    fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
    fInfoArray = GetFilesInfoList(m_filePath, fExtArray);
    EnumerateFile(fInfoArray);
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

function OnCompleteEditBox(string strID)
{
    local LVDataRecord Record;
    local int idx;
    local string strEdit, filePath;

    // End:0x1D
    if(strID != "fileNameEditBox")
    {
        return;
    }
    strEdit = EditBoxCtrl.GetString();
    idx = SearchFileListWithName(strEdit);
    // End:0x6A
    if(idx < 0)
    {
        UploadFileFullPath(strEdit);
        EditBoxCtrl.Clear();
        return;
    }
    FileListCtrl.GetRec(idx, Record);
    m_fileName = Record.LVDataList[0].szData;
    // End:0xD5
    if(__NFUN_412__(Record.nReserved1, (1)))
    {
        // End:0xD2
        if(UploadFile(m_filePath, m_fileName))
        {
            Me.HideWindow();            
        }        
    }
    else
    {
        SetFilePathnAdjustControl(filePath);
    }
    return;
}

function OnDBClickListCtrlRecord(string strID)
{
    local int Index, idx;
    local LVDataRecord Record;
    local string Str, editStr;

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
    // End:0xA6
    if(__NFUN_412__(Record.nReserved2, (1)))
    {
        Index = InStrFromBack(m_filePath, "\\");
        // End:0xA4
        if(Index >= 0)
        {
            editStr = Left(m_filePath, Index);
            SetFilePathnAdjustControl(editStr);
        }
        return;
    }
    Str = Record.LVDataList[0].szData;
    // End:0xF5
    if(__NFUN_412__(Record.nReserved1, (0)))
    {
        Str = (m_filePath $ "\\") $ Str;
        SetFilePathnAdjustControl(Str);        
    }
    else
    {
        m_fileName = Record.LVDataList[0].szData;
        // End:0x131
        if(UploadFile(m_filePath, m_fileName))
        {
            Me.HideWindow();            
        }
    }
    return;
}

function UpdateFilePathComboBox(string Str)
{
    local int i, j, k, drivenum;
    local array<DriveInfo> arrDrvInfo;
    local int Width, selectedNum;
    local string desktop;

    selectedNum = 0;
    // End:0x16
    if(Len(Str) <= 0)
    {
        return;
    }
    FilePathComboBoxCtrl.Clear();
    m_filePath = Str;
    k = -1;
    desktop = GetDesktopPath();
    // End:0x8C
    if(Len(desktop) != 0)
    {
        FilePathComboBoxCtrl.AddStringWithIconWithStr(Mid(desktop, (InStrFromBack(desktop, "\\")) + 1), DesktopTextureName, desktop);
        selectedNum++;
    }
    desktop = GetMydocumentPath();
    // End:0xDD
    if(Len(desktop) != 0)
    {
        FilePathComboBoxCtrl.AddStringWithIconWithStr(Mid(desktop, (InStrFromBack(desktop, "\\")) + 1), MyDocumentsTextureName, desktop);
        selectedNum++;
    }
    arrDrvInfo = GetDrivesInfoList();
    drivenum = 0;
    J0xF0:

    // End:0x33A [Loop If]
    if(drivenum < arrDrvInfo.Length)
    {
        // End:0x16F
        if(Left(arrDrvInfo[drivenum].driveChar, 1) != Left(m_filePath, 1))
        {
            FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr(Left(arrDrvInfo[drivenum].driveChar, 1) $ ":", DriveTextureName, 1, Left(arrDrvInfo[drivenum].driveChar, 1) $ ":");
            selectedNum++;
            // [Explicit Continue]
            goto J0x330;
        }
        i = 0;
        j = 0;
        k = 0;
        J0x184:

        // End:0x315 [Loop If]
        if(true)
        {
            j = i;
            // End:0x1C3
            if(j == 0)
            {
                i = InStr(Mid(Str, j), "\\");
                Width = j;                
            }
            else
            {
                i = InStr(Mid(Str, j + 1), "\\");
                Width = j + 1;
            }
            // End:0x26B
            if(i == -1)
            {
                // End:0x235
                if(j == 0)
                {
                    FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr(Mid(Str, j), DriveTextureName, k + 1, Str);                    
                }
                else
                {
                    FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr(Mid(Str, j + 1), CurrentForerTextureName, k + 1, Str);
                }
                // [Explicit Break]
                goto J0x315;                
            }
            else
            {
                i += Width;
                // End:0x2C5
                if(j == 0)
                {
                    FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr(Mid(Str, j, i - j), DriveTextureName, k + 1, Left(Str, i));
                    // [Explicit Continue]
                    goto J0x30B;
                }
                FilePathComboBoxCtrl.AddStringWithIconWithGapWithStr(Mid(Str, j + 1, (i - j) - 1), FolderTextureName, k + 1, Left(Str, i));
                J0x30B:

                k++;
            }
            // [Loop Continue]
            goto J0x184;
        }
        J0x315:

        FilePathComboBoxCtrl.SetSelectedNum(k + selectedNum);
        J0x330:

        ++drivenum;
        // [Loop Continue]
        goto J0xF0;
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

function EnumerateFile(array<FileNameInfo> FList)
{
    local int k;
    local LVDataRecord Record;

    FileListCtrl.DeleteAllItem();
    Record.LVDataList.Length = 1;
    Record.LVDataList[0].szData = "..";
    Record.LVDataList[0].hasIcon = true;
    Record.LVDataList[0].nTextureWidth = 19;
    Record.LVDataList[0].nTextureHeight = 15;
    Record.LVDataList[0].nTextureU = 19;
    Record.LVDataList[0].nTextureV = 15;
    Record.LVDataList[0].IconPosX = 3;
    Record.LVDataList[0].nsortPrior = 2;
    Record.LVDataList[0].szTexture = UpFolderTextureName;
    Record.nReserved2 = (1);
    k = InStrFromBack(m_filePath, "\\");
    // End:0x11A
    if(k != -1)
    {
        FileListCtrl.InsertRecord(Record);
    }
    k = 0;
    J0x121:

    // End:0x257 [Loop If]
    if(k < FList.Length)
    {
        Record.LVDataList[0].szData = FList[k].Filename;
        Record.LVDataList[0].hasIcon = true;
        Record.nReserved2 = (0);
        // End:0x1B6
        if(FList[k].bIsFile)
        {
            Record.LVDataList[0].nsortPrior = 0;
            Record.LVDataList[0].szTexture = FileTextureName;            
        }
        else
        {
            Record.LVDataList[0].nsortPrior = 1;
            Record.LVDataList[0].szData = Right(Record.LVDataList[0].szData, Len(Record.LVDataList[0].szData) - 1);
            Record.LVDataList[0].szTexture = FolderTextureName;
        }
        Record.nReserved1 = (FList[k].bIsFile);
        FileListCtrl.InsertRecord(Record);
        k++;
        // [Loop Continue]
        goto J0x121;
    }
    FileListCtrl.AdjustColumnWidth(0);
    FileListCtrl.SetSelectedIndex(0, true);
    return;
}

function OnShow()
{
    local array<string> fExtArray;

    EditBoxCtrl.Clear();
    FileListCtrl.InitListCtrl();
    FileExtComboBoxCtrl.SetSelectedNum(0);
    fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
    // End:0x8F
    if(GetOptionString("Game", "FileRegisterPath" $ string(FileHandler)) == "")
    {
        m_filePath = GetMydocumentPath();        
    }
    else
    {
        m_filePath = GetOptionString("Game", "FileRegisterPath" $ string(FileHandler));
    }
    // End:0xD6
    if(m_filePath != "")
    {
        SetFilePathnAdjustControl(m_filePath);        
    }
    else
    {
        m_filePath = "C:";
        SetFilePathnAdjustControl(m_filePath);
    }
    m_bShow = true;
    return;
}

function OnHide()
{
    m_bShow = false;
    return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
    local string Str;
    local array<FileNameInfo> fInfoArray;
    local array<string> fExtArray;

    // End:0x0D
    if(Index < 0)
    {
        return;
    }
    // End:0x5F
    if(strID == "fileLocationComboBox")
    {
        Str = FilePathComboBoxCtrl.GetAdditionalString(FilePathComboBoxCtrl.GetSelectedNum());
        SetFilePathnAdjustControl(Str);        
    }
    else
    {
        // End:0xC0
        if(strID == "fileTypeComboBox")
        {
            fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
            fInfoArray = GetFilesInfoList(m_filePath, fExtArray);
            EnumerateFile(fInfoArray);
        }
    }
    return;
}

function OnClickButton(string strID)
{
    local string editStr, filePath;
    local int Index;
    local LVDataRecord Record;

    switch(strID)
    {
        // End:0x104
        case "registOKButton":
            editStr = EditBoxCtrl.GetString();
            Index = SearchFileListWithName(editStr);
            // End:0x68
            if(Index < 0)
            {
                AddSystemMessage(528);
                EditBoxCtrl.Clear();
                // [Explicit Continue]
                goto J0x150;
            }
            FileListCtrl.GetRec(Index, Record);
            // End:0xD3
            if(__NFUN_412__(Record.nReserved1, (1)))
            {
                m_fileName = Record.LVDataList[0].szData;
                // End:0xD0
                if(UploadFile(m_filePath, m_fileName))
                {
                    Me.HideWindow();                    
                }                
            }
            else
            {
                filePath = (m_filePath $ "\\") $ Record.LVDataList[0].szData;
                SetFilePathnAdjustControl(filePath);
            }
            // End:0x150
            break;
        // End:0x12D
        case "registCancleButton":
            Me.HideWindow();
            // End:0x150
            break;
        // End:0x14D
        case "refreshButton":
            SetFilePathnAdjustControl(m_filePath);
            // End:0x150
            break;
        // End:0xFFFF
        default:
            break;
    }
    J0x150:

    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("FileRegisterWnd").HideWindow();
    return;
}
