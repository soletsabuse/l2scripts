class UIOpenToolWnd extends UICommonAPI;

const XML_EXT = ".xml";
const UC_EXT = ".uc";
const PREV_DIR = "..";

var WindowHandle Me;
var ButtonHandle SearchBtn;
var ButtonHandle InitBtn;
var ButtonHandle showBtn;
var EditBoxHandle searchEditBox;
var EditBoxHandle itemCountEditBox;
var EditBoxHandle descViewEditBox;
var ListCtrlHandle ItemListCtrl;
var array<string> FileList;
var string m_CurPath;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    load();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("UIOpenToolWnd");
    ItemListCtrl = GetListCtrlHandle("UIOpenToolWnd.itemListCtrl");
    searchEditBox = GetEditBoxHandle("UIOpenToolWnd.searchEditBox");
    itemCountEditBox = GetEditBoxHandle("UIOpenToolWnd.itemCountEditBox");
    descViewEditBox = GetEditBoxHandle("UIOpenToolWnd.descViewEditBox");
    SearchBtn = GetButtonHandle("UIOpenToolWnd.searchBtn");
    InitBtn = GetButtonHandle("UIOpenToolWnd.InitBtn");
    showBtn = GetButtonHandle("UIOpenToolWnd.showBtn");
    return;
}

function load()
{
    return;
}

function OnShow()
{
    Me.SetWindowTitle("UIOpenTool [UC Files List]");
    m_CurPath = GetInterfaceDir() $ "\\CLASSES\\";
    updateUCFiles();
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1E
        case "searchBtn":
            OnSearchBtnClick();
            // End:0x4B
            break;
        // End:0x33
        case "InitBtn":
            OnInitBtnClick();
            // End:0x4B
            break;
        // End:0x48
        case "showBtn":
            OnShowBtnClick();
            // End:0x4B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnSearchBtnClick()
{
    local int idx;
    local LVDataRecord recordInfo;

    // End:0x1E
    if(searchEditBox.GetString() == "")
    {
        updateUCFiles();
        return;
    }
    ItemListCtrl.DeleteAllItem();
    searchEditBox.ClearAdditionalSearchList(3);
    idx = 0;
    J0x45:

    // End:0xE4 [Loop If]
    if(idx < FileList.Length)
    {
        // End:0xDA
        if(InStr(Caps(FileList[idx]), Caps(searchEditBox.GetString())) != -1)
        {
            recordInfo.LVDataList.Length = 3;
            recordInfo.LVDataList[0].szData = FileList[idx];
            ItemListCtrl.InsertRecord(recordInfo);
            searchEditBox.AddNameToAdditionalSearchList(FileList[idx], 3);
        }
        idx++;
        // [Loop Continue]
        goto J0x45;
    }
    descViewEditBox.SetString("Total Search Files: " $ string(ItemListCtrl.GetRecordCount()));
    return;
}

function OnInitBtnClick()
{
    searchEditBox.SetString("");
    return;
}

function OnShowBtnClick()
{
    local LVDataRecord Record;
    local string Str;

    ItemListCtrl.GetSelectedRec(Record);
    Str = Record.LVDataList[0].szData;
    // End:0x8D
    if(Str != "")
    {
        // End:0x65
        if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(Str))
        {
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(Str);            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(Str);
            Class'NWindow.UIAPI_WINDOW'.static.SetFocus(Str);
        }
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    // End:0x1E
    if(ListCtrlID == "itemListCtrl")
    {
        OnShowBtnClick();
    }
    return;
}

function updateUCFiles()
{
    local int idx;
    local LVDataRecord recordInfo;
    local LVData data1;

    ItemListCtrl.DeleteAllItem();
    searchEditBox.ClearAdditionalSearchList(3);
    FileList.Remove(0, FileList.Length);
    GetFileList(FileList, m_CurPath, ".uc");
    idx = 0;
    J0x49:

    // End:0xF3 [Loop If]
    if(idx < FileList.Length)
    {
        FileList[idx] = Left(FileList[idx], Len(FileList[idx]) - 3);
        data1.szData = FileList[idx];
        recordInfo.LVDataList.Length = 3;
        recordInfo.LVDataList[0] = data1;
        ItemListCtrl.InsertRecord(recordInfo);
        searchEditBox.AddNameToAdditionalSearchList(FileList[idx], 3);
        idx++;
        // [Loop Continue]
        goto J0x49;
    }
    descViewEditBox.SetString("Total UC Files: " $ string(FileList.Length));
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x44
    if(searchEditBox.IsFocused())
    {
        // End:0x44
        if(int(nKey) == int(13))
        {
            // End:0x44
            if((trim(searchEditBox.GetString())) != "")
            {
                OnSearchBtnClick();
            }
        }
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("UIOpenToolWnd").HideWindow();
    return;
}
