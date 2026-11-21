class FileWnd extends UICommonAPI;

var bool m_bShow;
var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var ComboBoxHandle FilePathComboBoxCtrl;
var ComboBoxHandle FileExtComboBoxCtrl;
var string m_filePath;
var string FileTextureName;
var string FolderTextureName;
var UICommonAPI._FileHandler FileHandler;
var bool IsIdle;
var array<string> LastPath;
var string m_fileName;

function ShowFileWnd(UICommonAPI._FileHandler filehandlertype)
{
    // End:0x0B
    if(m_bShow)
    {
        return;
    }
    FileHandler = filehandlertype;
    switch(FileHandler)
    {
        // End:0x42
        case 1:
            Me.SetWindowTitle("CREST UPLOAD");
            // End:0x91
            break;
        // End:0x68
        case 2:
            Me.SetWindowTitle("EMBLEM UPLOAD");
            // End:0x91
            break;
        // End:0xFFFF
        default:
            Me.SetWindowTitle("File Registeration");
            // End:0x91
            break;
            break;
    }
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function HideFileWnd()
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

function bool UploadFile(string filePath, string Filename)
{
    local string filestr;

    filestr = (filePath $ "\\") $ Filename;
    // End:0x29
    if(int(FileHandler) >= int(5))
    {
        return true;
    }
    LastPath[int(FileHandler)] = filePath;
    UploadFileFullPath(filestr);
    return;
}

function bool UploadFileFullPath(string Path)
{
    Debug(Path);
    // End:0x1D
    if(int(FileHandler) >= int(5))
    {
        return true;
    }
    switch(FileHandler)
    {
        // End:0x2B
        case 0:
            return true;
        // End:0x3C
        case 1:
            return RequestClanRegisterCrestByFilePath(Path);
        // End:0x4D
        case 2:
            return RequestClanRegisterEmblemByFilePath(Path);
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
    local int i;

    LastPath.Length = int(5);
    i = 0;
    J0x12:

    // End:0x3A [Loop If]
    if(i < int(5))
    {
        LastPath[i] = "C:";
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    IsIdle = true;
    FileHandler = 0;
    FileTextureName = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
    FolderTextureName = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
    // End:0xAF
    if(1 == 0)
    {        
    }
    else
    {
        Me = GetWindowHandle("FileWnd");
        FileListCtrl = GetListCtrlHandle("FileWnd.FLWListCtrl");
        FileListCtrl.SetHeaderAlignment(0, 1);
        EditBoxCtrl = GetEditBoxHandle("FileWnd.FLWEditBox");
        FilePathComboBoxCtrl = GetComboBoxHandle("FileWnd.FLWComboBox");
        FileExtComboBoxCtrl = GetComboBoxHandle("FileWnd.FLWFTypeComboBox");
        strArray.Length = 1;
        strArray[0] = "*";
        FileExtComboBoxCtrl.AddStringWithFileExt("모든 파일", strArray);
        SetFilePathnAdjustControl("C:");
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

    // End:0x18
    if(strID != "FLWEditBox")
    {
        return;
    }
    strEdit = EditBoxCtrl.GetString();
    idx = SearchFileListWithName(strEdit);
    // End:0x65
    if(idx < 0)
    {
        UploadFileFullPath(strEdit);
        EditBoxCtrl.Clear();
        return;
    }
    FileListCtrl.GetRec(idx, Record);
    m_fileName = Record.LVDataList[0].szData;
    // End:0xD0
    if(__NFUN_412__(Record.nReserved1, (1)))
    {
        // End:0xCD
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
    local int idx;
    local LVDataRecord Record;
    local string Str;

    // End:0x19
    if(strID != "FLWListCtrl")
    {
        return;
    }
    idx = FileListCtrl.GetSelectedIndex();
    // End:0x3B
    if(idx < 0)
    {
        return;
    }
    FileListCtrl.GetRec(idx, Record);
    Str = Record.LVDataList[0].szData;
    // End:0x9E
    if(__NFUN_412__(Record.nReserved1, (0)))
    {
        Str = m_filePath $ Str;
        SetFilePathnAdjustControl(Str);        
    }
    else
    {
        m_fileName = Record.LVDataList[0].szData;
        // End:0xDA
        if(UploadFile(m_filePath, m_fileName))
        {
            Me.HideWindow();            
        }
    }
    return;
}

function UpdateFilePathComboBox(string Str)
{
    local int idx, i, j, k;
    local bool bComp;
    local string remainStr;
    local array<DriveInfo> arrDrvInfo;

    // End:0x0F
    if(Len(Str) <= 0)
    {
        return;
    }
    FilePathComboBoxCtrl.Clear();
    m_filePath = Str;
    k = -1;
    bComp = false;
    arrDrvInfo = GetDrivesInfoList();
    j = 0;
    J0x4F:

    // End:0x203 [Loop If]
    if(j < arrDrvInfo.Length)
    {
        // End:0xBB
        if(Left(arrDrvInfo[j].driveChar, 1) != Left(m_filePath, 1))
        {
            FilePathComboBoxCtrl.AddString(Left(arrDrvInfo[j].driveChar, 1) $ ":");
            // End:0xB8
            if(!bComp)
            {
                ++k;
            }
            // [Explicit Continue]
            goto J0x1F9;
        }
        remainStr = Str;
        idx = InStr(remainStr, "\\");
        // End:0xEE
        if(idx < 0)
        {
            idx = Len(remainStr);
        }
        Str = Left(remainStr, idx);
        remainStr = Right(remainStr, Len(remainStr) - idx);
        FilePathComboBoxCtrl.AddStringWithGap(Str, 0);
        ++k;
        i = 1;
        J0x13E:

        // End:0x1F1 [Loop If]
        if(Len(remainStr) > 0)
        {
            remainStr = Right(remainStr, Len(remainStr) - 1);
            idx = InStr(remainStr, "\\");
            // End:0x18A
            if(idx < 0)
            {
                idx = Len(remainStr);
            }
            Str = Left(remainStr, idx);
            remainStr = Right(remainStr, Len(remainStr) - idx);
            Str = "\\" $ Str;
            FilePathComboBoxCtrl.AddStringWithGap(Str, i);
            ++i;
            ++k;
            // [Loop Continue]
            goto J0x13E;
        }
        bComp = true;
        J0x1F9:

        ++j;
        // [Loop Continue]
        goto J0x4F;
    }
    FilePathComboBoxCtrl.SetSelectedNum(k);
    return;
}

function OnClickListCtrlRecord(string strID)
{
    local int idx;
    local LVDataRecord Record;

    // End:0x19
    if(strID != "FLWListCtrl")
    {
        return;
    }
    idx = FileListCtrl.GetSelectedIndex();
    // End:0x3B
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
    local LVData Data;
    local LVDataRecord Record;

    FileListCtrl.DeleteAllItem();
    Record.LVDataList.Length = 1;
    k = 0;
    J0x23:

    // End:0x12D [Loop If]
    if(k < FList.Length)
    {
        Data.szData = FList[k].Filename;
        Record.LVDataList[0].hasIcon = true;
        // End:0x90
        if(FList[k].bIsFile)
        {
            Record.LVDataList[0].szTexture = FileTextureName;            
        }
        else
        {
            Record.LVDataList[0].szTexture = FolderTextureName;
        }
        Record.LVDataList[0].nTextureWidth = 14;
        Record.LVDataList[0].nTextureHeight = 14;
        Record.LVDataList[0].szData = FList[k].Filename;
        Record.nReserved1 = (FList[k].bIsFile);
        FileListCtrl.InsertRecord(Record);
        k++;
        // [Loop Continue]
        goto J0x23;
    }
    FileListCtrl.AdjustColumnWidth(0);
    return;
}

function OnShow()
{
    local array<FileNameInfo> fInfoArray;
    local array<string> fExtArray;

    EditBoxCtrl.Clear();
    FileListCtrl.InitListCtrl();
    FileExtComboBoxCtrl.SetSelectedNum(0);
    fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
    m_filePath = LastPath[int(FileHandler)];
    fInfoArray = GetFilesInfoList(LastPath[int(FileHandler)], fExtArray);
    EnumerateFile(fInfoArray);
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
    local int i, S, E;
    local array<FileNameInfo> fInfoArray;
    local array<string> fExtArray;

    // End:0x0D
    if(Index < 0)
    {
        return;
    }
    // End:0xCC
    if(strID == "FLWComboBox")
    {
        S = getIndexOfCurrentDrive();
        E = getIndexOfCurrentFolder();
        // End:0xA4
        if((Index >= S) && Index <= E)
        {
            i = S;
            J0x67:

            // End:0xA1 [Loop If]
            if(i <= Index)
            {
                Str = Str $ FilePathComboBoxCtrl.GetString(i);
                ++i;
                // [Loop Continue]
                goto J0x67;
            }            
        }
        else
        {
            Str = FilePathComboBoxCtrl.GetString(Index);
        }
        SetFilePathnAdjustControl(Str);        
    }
    else
    {
        // End:0x12D
        if(strID == "FLWFTypeComboBox")
        {
            fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
            fInfoArray = GetFilesInfoList(m_filePath, fExtArray);
            EnumerateFile(fInfoArray);
        }
    }
    return;
}

function int getIndexOfCurrentDrive()
{
    local int idx, Num;
    local string rootDrive;

    idx = InStr(m_filePath, "\\");
    // End:0x30
    if(idx >= 0)
    {
        rootDrive = Left(m_filePath, idx);        
    }
    else
    {
        rootDrive = m_filePath;
    }
    Num = FilePathComboBoxCtrl.GetNumOfItems();
    idx = 0;
    J0x57:

    // End:0x94 [Loop If]
    if(idx < Num)
    {
        // End:0x8A
        if(rootDrive == FilePathComboBoxCtrl.GetString(idx))
        {
            return idx;
        }
        ++idx;
        // [Loop Continue]
        goto J0x57;
    }
    return -1;
    return;
}

function int getIndexOfCurrentFolder()
{
    local int S, i;
    local string Str;

    Str = m_filePath;
    S = getIndexOfCurrentDrive();
    J0x17:

    // End:0x6F [Loop If]
    if(InStr(Str, "\\") >= 0)
    {
        i = InStr(Str, "\\");
        Str = Right(Str, (Len(Str) - i) - 1);
        // End:0x65
        if(Len(Str) <= 0)
        {
            // [Explicit Break]
            goto J0x6F;
        }
        ++S;
        // [Loop Continue]
        goto J0x17;
    }
    J0x6F:

    return S;
    return;
}

function OnClickButton(string strID)
{
    local string editStr, filePath;
    local int Index;
    local LVDataRecord Record;

    switch(strID)
    {
        // End:0xF1
        case "FLWButtonOK":
            editStr = EditBoxCtrl.GetString();
            Index = SearchFileListWithName(editStr);
            // End:0x5A
            if(Index < 0)
            {
                EditBoxCtrl.Clear();
                // [Explicit Continue]
                goto J0x169;
            }
            FileListCtrl.GetRec(Index, Record);
            // End:0xC5
            if(__NFUN_412__(Record.nReserved1, (1)))
            {
                m_fileName = Record.LVDataList[0].szData;
                // End:0xC2
                if(UploadFile(m_filePath, m_fileName))
                {
                    Me.HideWindow();                    
                }                
            }
            else
            {
                filePath = m_filePath $ Record.LVDataList[0].szData;
                SetFilePathnAdjustControl(filePath);
            }
            // End:0x169
            break;
        // End:0x117
        case "FLWButtonCancel":
            Me.HideWindow();
            // End:0x169
            break;
        // End:0x166
        case "FLWButtonUp":
            Index = InStrFromBack(m_filePath, "\\");
            // End:0x163
            if(Index >= 0)
            {
                editStr = Left(m_filePath, Index);
                SetFilePathnAdjustControl(editStr);
            }
            // End:0x169
            break;
        // End:0xFFFF
        default:
            break;
    }
    J0x169:

    return;
}
