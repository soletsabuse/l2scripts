class MacroListWnd extends UICommonAPI;

const MACRO_MAX_COUNT = 100;
const MACROCOMMAND_MAX_COUNT = 12;

var string m_WindowName;
var bool m_bShow;
var ItemID m_DeleteItemID;
var int m_Max;
var WindowHandle m_hMacroListWnd;
var ItemWindowHandle m_MacroItems;
var EditBoxHandle m_SearchInput;
var ButtonHandle m_SearchClear;

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(1230);
    RegisterEvent(1240);
    RegisterEvent(1250);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    m_hMacroListWnd = GetWindowHandle(m_WindowName);
    m_MacroItems = GetItemWindowHandle("MacroListWnd.MacroItem");
    m_SearchInput = GetEditBoxHandle("MacroListWnd.MacroSearchInput");
    m_SearchClear = GetButtonHandle("MacroListWnd.MacroSearchClear");
    m_SearchClear.HideWindow();
    m_bShow = false;
    ClearItemID(m_DeleteItemID);
    return;
}

function OnEnterState(name a_PreStateName)
{
    Class'NWindow.MacroAPI'.static.RequestMacroList();
    return;
}

function OnShow()
{
    m_bShow = true;
    return;
}

function OnHide()
{
    m_bShow = false;
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
    // End:0x68
    if(GetWindowHandle("MacroPresetWnd").IsShowWindow())
    {
        GetWindowHandle("MacroPresetWnd").HideWindow();
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1C
        case "btnHelp":
            OnClickHelp();
            // End:0x63
            break;
        // End:0x30
        case "btnAdd":
            OnClickAdd();
            // End:0x63
            break;
        // End:0x5D
        case "MacroSearchClear":
            m_SearchInput.Clear();
            ApplyMacroFilter();
            // End:0x63
            break;
        // End:0xFFFF
        default:
            // End:0x63
            break;
            break;
    }
    return;
}

function OnChangeEditBox(string strID)
{
    // End:0x22
    if(strID == "MacroSearchInput")
    {
        ApplyMacroFilter();
    }
    return;
}

function ApplyMacroFilter()
{
    local int idx;
    local string searchText;
    local ItemInfo infItem;

    searchText = m_SearchInput.GetString();
    // End:0x72
    if(Len(searchText) < 1)
    {
        m_SearchClear.HideWindow();
        idx = 0;
        J0x38:

        // End:0x70 [Loop If]
        if(idx < m_MacroItems.GetItemNum())
        {
            m_MacroItems.SetItemSkillDisabled(idx, 0);
            idx++;
            // [Loop Continue]
            goto J0x38;
        }
        return;
    }
    m_SearchClear.ShowWindow();
    idx = 0;
    J0x88:

    // End:0x103 [Loop If]
    if(idx < m_MacroItems.GetItemNum())
    {
        // End:0xF9
        if(m_MacroItems.GetItem(idx, infItem))
        {
            m_MacroItems.SetItemSkillDisabled(idx, int(!StringMatching(ToLowerByLanguage(infItem.Name), ToLowerByLanguage(searchText), " ")));
        }
        idx++;
        // [Loop Continue]
        goto J0x88;
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x18
    if(Event_ID == 1230)
    {
        HandleMacroShowListWnd();        
    }
    else
    {
        // End:0x30
        if(Event_ID == 1240)
        {
            HandleMacroUpdate();            
        }
        else
        {
            // End:0x4D
            if(Event_ID == 1250)
            {
                HandleMacroList(param);                
            }
            else
            {
                // End:0xA5
                if(Event_ID == 1710)
                {
                    // End:0xA5
                    if(DialogIsMine())
                    {
                        // End:0xA5
                        if(IsValidItemID(m_DeleteItemID))
                        {
                            Class'NWindow.MacroAPI'.static.RequestDeleteMacro(m_DeleteItemID);
                            ClearItemID(m_DeleteItemID);
                            // End:0xA5
                            if(m_Max == 1)
                            {
                                HandleMacroList("");
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo infItem;

    // End:0x73
    if((strID == "MacroItem") && Index > -1)
    {
        // End:0x73
        if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("MacroListWnd.MacroItem", Index, infItem))
        {
            Class'NWindow.MacroAPI'.static.RequestUseMacro(infItem.Id);
        }
    }
    return;
}

function OnClickHelp()
{
    local string strParam;

    // End:0x6D
    if(getInstanceUIData().getIsClassicServer())
    {
        ParamAdd(strParam, "FilePath", "..\\l2text_classic\\help_general_control_macro.htm");
        ExecuteEvent(1210, strParam);        
    }
    else
    {
        ExecuteEvent(1210, "37");
    }
    return;
}

function OnClickAdd()
{
    // End:0x3F
    if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("MacroEditWnd"))
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
    }
    ExecuteEvent(1260, "");
    return;
}

function HandleMacroUpdate()
{
    Class'NWindow.MacroAPI'.static.RequestMacroList();
    return;
}

function HandleMacroShowListWnd()
{
    // End:0x23
    if(m_bShow)
    {
        PlayConsoleSound(6);
        m_hMacroListWnd.HideWindow();        
    }
    else
    {
        PlayConsoleSound(5);
        m_hMacroListWnd.ShowWindow();
        m_hMacroListWnd.SetFocus();
    }
    return;
}

function Clear()
{
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("MacroListWnd.MacroItem");
    return;
}

function HandleMacroList(string param)
{
    local int idx, Max;
    local string strIconName, strMacroName, strDescription, strTexture, strTmp;

    local ItemInfo infItem;

    Clear();
    ParseInt(param, "Max", Max);
    m_Max = Max;
    idx = 0;
    J0x2D:

    // End:0x190 [Loop If]
    if(idx < Max)
    {
        strIconName = "";
        strMacroName = "";
        strDescription = "";
        strTexture = "";
        ParseItemIDWithIndex(param, infItem.Id, idx);
        ParseString(param, "IconName_" $ string(idx), strIconName);
        ParseString(param, "MacroName_" $ string(idx), strMacroName);
        ParseString(param, "Description_" $ string(idx), strDescription);
        ParseString(param, "TextureName_" $ string(idx), strTexture);
        infItem.Name = strMacroName;
        infItem.AdditionalName = strIconName;
        infItem.IconName = strTexture;
        infItem.Description = strDescription;
        infItem.ItemSubType = 4;
        Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("MacroListWnd.MacroItem", infItem);
        idx++;
        // [Loop Continue]
        goto J0x2D;
    }
    // End:0x1AC
    if(Max < 10)
    {
        strTmp = strTmp $ "0";
    }
    strTmp = strTmp $ string(Max);
    strTmp = ((("(" $ strTmp) $ "/") $ string(100)) $ ")";
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MacroListWnd.txtCount", strTmp);
    ApplyMacroFilter();
    return;
}

function OnDropItem(string strID, ItemInfo infItem, int X, int Y)
{
    switch(strID)
    {
        // End:0x22
        case "btnTrash":
            DeleteMacro(infItem);
            // End:0x68
            break;
        // End:0x3C
        case "btnEdit":
            EditMacro(infItem);
            // End:0x68
            break;
        // End:0x62
        case "MacroItem":
            ReorderMacro(infItem, X, Y);
            // End:0x68
            break;
        // End:0xFFFF
        default:
            // End:0x68
            break;
            break;
    }
    return;
}

function ReorderMacro(ItemInfo infItem, int X, int Y)
{
    local int toIndex, fromIndex;

    // End:0x2F
    if((infItem.ItemSubType != 4) || infItem.DragSrcName != "MacroItem")
    {
        return;
    }
    toIndex = m_MacroItems.GetIndexAt(X, Y, 1, 1);
    fromIndex = m_MacroItems.FindItem(infItem.Id);
    // End:0x7C
    if(toIndex < 0)
    {
        return;
    }
    // End:0xAD
    if(toIndex >= m_MacroItems.GetItemNum())
    {
        toIndex = m_MacroItems.GetItemNum() - 1;
    }
    // End:0xCB
    if((fromIndex < 0) || toIndex == fromIndex)
    {
        return;
    }
    RequestBypassToServer(("macro_reorder" @ string(infItem.Id.ClassID)) @ string(toIndex));
    return;
}

function DeleteMacro(ItemInfo infItem)
{
    local string strMsg;

    // End:0x13
    if(infItem.ItemSubType != 4)
    {
        return;
    }
    strMsg = MakeFullSystemMsg(GetSystemMessage(828), infItem.Name, "");
    m_DeleteItemID = infItem.Id;
    DialogShow(1, 4, strMsg, string(self));
    return;
}

function EditMacro(ItemInfo infItem)
{
    local string param;

    Debug("------------------ > ");
    Debug("infItem Name" @ infItem.Name);
    // End:0x50
    if(infItem.ItemSubType != 4)
    {
        return;
    }
    Debug("------------EShortCutItemType ------ > " @ string(4));
    ParamAddItemID(param, infItem.Id);
    ExecuteEvent(1260, param);
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
    Debug("ï¿½ï¿½ï¿½ï¿½ " @ param);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    m_hMacroListWnd.HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="MacroListWnd"
}