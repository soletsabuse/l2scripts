class FileListWnd extends UICommonAPI;

var bool m_bShow;
var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var ComboBoxHandle FilePathComboBoxCtrl;
var ComboBoxHandle FileExtComboBoxCtrl;
var string m_filePath;

function OnLoad()
{
    local array<string> strArray;

    SetClosingOnESC();
    // End:0x10
    if(1 == 0)
    {        
    }
    else
    {
        Me = GetWindowHandle("FileListWnd");
        FileListCtrl = GetListCtrlHandle("FileListWnd.FLWListCtrl");
        FileListCtrl.SetHeaderAlignment(0, 1);
        EditBoxCtrl = GetEditBoxHandle("FileListWnd.FLWEditBox");
        FilePathComboBoxCtrl = GetComboBoxHandle("FileListWnd.FLWComboBox");
        FileExtComboBoxCtrl = GetComboBoxHandle("FileListWnd.FLWFTypeComboBox");
        strArray.Length = 1;
        strArray[0] = "swf";
        FileExtComboBoxCtrl.AddStringWithFileExt("Flash file", strArray);
        strArray.Length = 1;
        strArray[0] = "*";
        FileExtComboBoxCtrl.AddStringWithFileExt("All file", strArray);
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
    fInfoArray = Class'NWindow.FileListAPI'.static.GetFileInfoList(m_filePath, fExtArray);
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
    // End:0x5A
    if(idx < 0)
    {
        EditBoxCtrl.Clear();
        return;
    }
    FileListCtrl.GetRec(idx, Record);
    filePath = (m_filePath $ "\\") $ Record.LVDataList[0].szData;
    // End:0xD5
    if(__NFUN_412__(Record.nReserved1, (1)))
    {
        // End:0xD2
        if(Class'NWindow.FileListAPI'.static.ShowFlash(filePath))
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
        Str = (m_filePath $ "\\") $ Record.LVDataList[0].szData;
        // End:0xEA
        if(Class'NWindow.FileListAPI'.static.ShowFlash(Str))
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
    arrDrvInfo = Class'NWindow.FileListAPI'.static.GetDriveInfoList();
    j = 0;
    J0x58:

    // End:0x20C [Loop If]
    if(j < arrDrvInfo.Length)
    {
        // End:0xC4
        if(Left(arrDrvInfo[j].driveChar, 1) != Left(m_filePath, 1))
        {
            FilePathComboBoxCtrl.AddString(Left(arrDrvInfo[j].driveChar, 1) $ ":");
            // End:0xC1
            if(!bComp)
            {
                ++k;
            }
            // [Explicit Continue]
            goto J0x202;
        }
        remainStr = Str;
        idx = InStr(remainStr, "\\");
        // End:0xF7
        if(idx < 0)
        {
            idx = Len(remainStr);
        }
        Str = Left(remainStr, idx);
        remainStr = Right(remainStr, Len(remainStr) - idx);
        FilePathComboBoxCtrl.AddStringWithGap(Str, 0);
        ++k;
        i = 1;
        J0x147:

        // End:0x1FA [Loop If]
        if(Len(remainStr) > 0)
        {
            remainStr = Right(remainStr, Len(remainStr) - 1);
            idx = InStr(remainStr, "\\");
            // End:0x193
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
            goto J0x147;
        }
        bComp = true;
        J0x202:

        ++j;
        // [Loop Continue]
        goto J0x58;
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

    // End:0x19A [Loop If]
    if(k < FList.Length)
    {
        Data.szData = FList[k].Filename;
        Record.LVDataList[0].hasIcon = true;
        // End:0xB2
        if(FList[k].bIsFile)
        {
            Record.LVDataList[0].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";            
        }
        else
        {
            Record.LVDataList[0].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
        }
        Record.LVDataList[0].nTextureWidth = 14;
        Record.LVDataList[0].nTextureHeight = 14;
        Record.LVDataList[0].nTextureU = 14;
        Record.LVDataList[0].nTextureV = 14;
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
    fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
    fInfoArray = Class'NWindow.FileListAPI'.static.GetFileInfoList(m_filePath, fExtArray);
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
        // End:0x136
        if(strID == "FLWFTypeComboBox")
        {
            fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
            fInfoArray = Class'NWindow.FileListAPI'.static.GetFileInfoList(m_filePath, fExtArray);
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
        // End:0x101
        case "FLWButtonOK":
            editStr = EditBoxCtrl.GetString();
            Index = SearchFileListWithName(editStr);
            // End:0x5A
            if(Index < 0)
            {
                EditBoxCtrl.Clear();
                // [Explicit Continue]
                goto J0x179;
            }
            FileListCtrl.GetRec(Index, Record);
            // End:0xD5
            if(__NFUN_412__(Record.nReserved1, (1)))
            {
                filePath = (m_filePath $ "\\") $ Record.LVDataList[0].szData;
                // End:0xD2
                if(Class'NWindow.FileListAPI'.static.ShowFlash(filePath))
                {
                    Me.HideWindow();                    
                }                
            }
            else
            {
                filePath = m_filePath $ Record.LVDataList[0].szData;
                SetFilePathnAdjustControl(filePath);
            }
            // End:0x179
            break;
        // End:0x127
        case "FLWButtonCancel":
            Me.HideWindow();
            // End:0x179
            break;
        // End:0x176
        case "FLWButtonUp":
            Index = InStrFromBack(m_filePath, "\\");
            // End:0x173
            if(Index >= 0)
            {
                editStr = Left(m_filePath, Index);
                SetFilePathnAdjustControl(editStr);
            }
            // End:0x179
            break;
        // End:0xFFFF
        default:
            break;
    }
    J0x179:

    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("FileListWnd").HideWindow();
    return;
}
