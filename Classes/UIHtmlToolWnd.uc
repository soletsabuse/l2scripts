class UIHtmlToolWnd extends UICommonAPI;

var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var EditBoxHandle dirEditBox;
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
    FileHandler = filehandlertype;
    Me.ShowWindow();
    Me.SetFocus();
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
        // End:0x31
        case 1:
            return RequestClanRegisterCrestByFilePath(Path);
        // End:0x42
        case 2:
            return RequestClanRegisterEmblemByFilePath(Path);
        // End:0x53
        case 3:
            return RequestAllianceRegisterCrestByFilePath(Path);
        // End:0x64
        case 4:
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
        Me = GetWindowHandle("UIHtmlToolWnd");
        FileListCtrl = GetListCtrlHandle("UIHtmlToolWnd.fileListCtrl");
        FileListCtrl.SetHeaderAlignment(0, 1);
        FileListCtrl.SetResizable(false);
        EditBoxCtrl = GetEditBoxHandle("UIHtmlToolWnd.fileNameEditBox");
        dirEditBox = GetEditBoxHandle("UIHtmlToolWnd.dirEditBox");
        FilePathComboBoxCtrl = GetComboBoxHandle("UIHtmlToolWnd.FileLocationComboBox");
        FileExtComboBoxCtrl = GetComboBoxHandle("UIHtmlToolWnd.FileTypeComboBox");
        FileListCtrl.SetHeaderTextOffset(0, 135);
        strArray.Length = 2;
        strArray[0] = "htm";
        strArray[1] = "html";
        FileExtComboBoxCtrl.AddStringWithFileExt("All File", strArray);
        SetFilePathnAdjustControl(GetMydocumentPath());
    }
    Me.SetWindowTitle("UIPowerTools - [ HtmlTool ]");
    return;
}

function SetFilePathnAdjustControl(string S)
{
    local array<FileNameInfo> fInfoArray;
    local array<string> fExtArray;

    EditBoxCtrl.Clear();
    dirEditBox.Clear();
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
        // End:0x14D
        if(GetWindowHandle("QuestTutorialWnd").IsShowWindow())
        {
            OnClickButton("htmlBigViewButton");            
        }
        else
        {
            OnClickButton("htmlSmallViewButton");
        }
        // End:0x1A3
        if(GetWindowHandle("ItemDescWnd").IsShowWindow())
        {
            OnClickButton("htmlSmallViewButton");
        }
    }
    FileListCtrl.SetFocus();
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
    dirEditBox.SetString(m_filePath);
    EditBoxCtrl.SetString(Record.LVDataList[0].szData);
    return;
}

function EnumerateFile(array<FileNameInfo> FList)
{
    local int k;
    local LVDataRecord Record;

    FileListCtrl.DeleteAllItem();
    EditBoxCtrl.ClearAdditionalSearchList(3);
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
    // End:0x12B
    if(k != -1)
    {
        FileListCtrl.InsertRecord(Record);
    }
    k = 0;
    J0x132:

    // End:0x299 [Loop If]
    if(k < FList.Length)
    {
        Record.LVDataList[0].szData = FList[k].Filename;
        Record.LVDataList[0].hasIcon = true;
        Record.nReserved2 = (0);
        // End:0x1C7
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
        // End:0x28F
        if(FList.Length < 1000)
        {
            EditBoxCtrl.AddNameToAdditionalSearchList(FList[k].Filename, 3);
        }
        k++;
        // [Loop Continue]
        goto J0x132;
    }
    dirEditBox.SetString(m_filePath);
    FileListCtrl.AdjustColumnWidth(0);
    FileListCtrl.SetSelectedIndex(0, true);
    return;
}

function OnShow()
{
    local array<string> fExtArray;

    ShowFileRegisterWnd(0);
    EditBoxCtrl.Clear();
    dirEditBox.Clear();
    FileListCtrl.InitListCtrl();
    FileExtComboBoxCtrl.SetSelectedNum(0);
    fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
    UpdateFilePathComboBox(m_filePath);
    SetFilePathnAdjustControl(m_filePath);
    dirEditBox.SetString(m_filePath);
    return;
}

function OnHide()
{
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
        // End:0x1D
        case "htmlBigViewButton":
        // End:0x14B
        case "htmlSmallViewButton":
            editStr = EditBoxCtrl.GetString();
            Index = SearchFileListWithName(editStr);
            // End:0x83
            if(Index < 0)
            {
                AddSystemMessage(528);
                EditBoxCtrl.Clear();
                // [Explicit Continue]
                goto J0x16E;
            }
            FileListCtrl.GetRec(Index, Record);
            // End:0xE0
            if(__NFUN_412__(Record.nReserved1, (1)))
            {
                m_fileName = Record.LVDataList[0].szData;
                filePath = (m_filePath $ "\\") $ m_fileName;                
            }
            else
            {
                filePath = (m_filePath $ "\\") $ Record.LVDataList[0].szData;
                SetFilePathnAdjustControl(filePath);
            }
            // End:0x13C
            if(strID == "htmlSmallViewButton")
            {
                htmlButtonClick(true, filePath);                
            }
            else
            {
                htmlButtonClick(false, filePath);
            }
            // End:0x16E
            break;
        // End:0x16B
        case "refreshButton":
            SetFilePathnAdjustControl(m_filePath);
            // End:0x16E
            break;
        // End:0xFFFF
        default:
            break;
    }
    J0x16E:

    return;
}

function htmlButtonClick(bool bSmallOpenType, string filePath)
{
    local ItemDescWnd script;

    script = ItemDescWnd(GetScript("ItemDescWnd"));
    // End:0x3E
    if(bSmallOpenType)
    {
        script.ShowHelp(filePath);        
    }
    else
    {
        ExecuteEvent(2431, ("HtmlFile=" $ filePath) @ "ViewerType=2");
    }
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x47
    if(EditBoxCtrl.IsFocused())
    {
        // End:0x44
        if(int(nKey) == int(13))
        {
            htmlButtonClick(true, (m_filePath $ "\\") $ EditBoxCtrl.GetString());
        }        
    }
    else
    {
        // End:0x94
        if(dirEditBox.IsFocused())
        {
            // End:0x94
            if(int(nKey) == int(13))
            {
                m_filePath = dirEditBox.GetString();
                UpdateFilePathComboBox(m_filePath);
                SetFilePathnAdjustControl(m_filePath);
            }
        }
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("UIHtmlToolWnd").HideWindow();
    return;
}
