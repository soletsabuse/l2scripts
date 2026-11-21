class MacroPresetWnd extends UICommonAPI;

const MACROCOMMAND_MAX_COUNT = 12;

var WindowHandle Me;
var ItemWindowHandle MacroItem_ItemWnd;
var HtmlHandle PresetViewer_Html;
var ButtonHandle MacroCopy_Btn;
var ButtonHandle Close_Btn;
var TextureHandle SlotGroupBoxBg_Tex;
var array<int> macroPresetIDArray;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function OnShow()
{
    Debug("Show updateMacroPreset");
    updateMacroPreset();
    return;
}

function updateMacroPreset()
{
    local int i;
    local MacroPresetInfo mPresetInfo;
    local ItemInfo infItem;

    macroPresetIDArray.Length = 0;
    Class'NWindow.UIDATA_MACRO'.static.GetMacroPresetIDs(macroPresetIDArray);
    Debug("macroPresetIDArray" @ string(macroPresetIDArray.Length));
    MacroItem_ItemWnd.Clear();
    i = 0;
    J0x56:

    // End:0x1CD [Loop If]
    if(i < macroPresetIDArray.Length)
    {
        Class'NWindow.UIDATA_MACRO'.static.GetMacroPresetInfo(macroPresetIDArray[i], mPresetInfo);
        infItem.Name = mPresetInfo.Name;
        infItem.AdditionalName = mPresetInfo.IconName;
        infItem.Id.ClassID = mPresetInfo.Id;
        infItem.Description = mPresetInfo.Description;
        infItem.IconName = mPresetInfo.IconTextureName;
        infItem.ItemSubType = int(4);
        infItem.IconNameEx4 = mPresetInfo.PresetDescription;
        infItem.MacroCommand = macroCommandArrayToString(mPresetInfo);
        MacroItem_ItemWnd.AddItem(infItem);
        // End:0x1C3
        if((i == 0) && mPresetInfo.PresetDescription != "")
        {
            MacroItem_ItemWnd.SetSelectedNum(0);
            Debug(("html open :" @ "..\\L2text\\") $ mPresetInfo.PresetDescription);
            PresetViewer_Html.LoadHtml("..\\L2text\\" $ mPresetInfo.PresetDescription);
        }
        i++;
        // [Loop Continue]
        goto J0x56;
    }
    return;
}

function Initialize()
{
    Me = GetWindowHandle("MacroPresetWnd");
    MacroItem_ItemWnd = GetItemWindowHandle("MacroPresetWnd.MacroItem_ItemWnd");
    PresetViewer_Html = GetHtmlHandle("MacroPresetWnd.PresetViewer_Html");
    Close_Btn = GetButtonHandle("MacroPresetWnd.Close_Btn");
    MacroCopy_Btn = GetButtonHandle("MacroPresetWnd.MacroCopy_Btn");
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x22
        case "MacroCopy_Btn":
            OnMacroCopy_BtnClick();
            // End:0x3C
            break;
        // End:0x39
        case "Close_Btn":
            OnClose_BtnClick();
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnMacroCopy_BtnClick(optional int gfxSystemMessageNum)
{
    local int selectedNum;
    local ItemInfo Info;

    selectedNum = MacroItem_ItemWnd.GetSelectedNum();
    // End:0xC7
    if(selectedNum > -1)
    {
        MacroItem_ItemWnd.GetItem(selectedNum, Info);
        // End:0xA7
        if(Info.MacroCommand != "")
        {
            // End:0x67
            if(gfxSystemMessageNum > 0)
            {
                AddSystemMessage(gfxSystemMessageNum);                
            }
            else
            {
                AddSystemMessage(4399);
            }
            ClipboardCopy(Info.MacroCommand);
            Debug("클립보드 카피:" @ Info.MacroCommand);            
        }
        else
        {
            Debug("클립보드 카피할게 없어..");
        }
    }
    return;
}

function OnClose_BtnClick()
{
    Me.HideWindow();
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo Info;

    // End:0xD6
    if(strID == "MacroItem_ItemWnd")
    {
        // End:0xD6
        if(Index > -1)
        {
            MacroItem_ItemWnd.SetSelectedNum(Index);
            MacroItem_ItemWnd.GetItem(Index, Info);
            // End:0xD6
            if(Info.IconNameEx4 != "")
            {
                // End:0xAF
                if(getInstanceUIData().getIsClassicServer())
                {
                    PresetViewer_Html.LoadHtml("..\\l2text_classic\\" $ Info.IconNameEx4);                    
                }
                else
                {
                    PresetViewer_Html.LoadHtml("..\\L2text\\" $ Info.IconNameEx4);
                }
            }
        }
    }
    return;
}

function OnDBClickItem(string strID, int Index)
{
    local ItemInfo Info;

    // End:0x10B
    if(strID == "MacroItem_ItemWnd")
    {
        // End:0xDF
        if(GetWindowHandle("MacroEditWnd").IsShowWindow())
        {
            OnMacroCopy_BtnClick(4401);
            MacroItem_ItemWnd.GetItem(Index, Info);
            MacroEditWnd(GetScript("MacroEditWnd")).setEditMacroInfo(Info.Name, Info.IconName);
            MacroEditWnd(GetScript("MacroEditWnd")).pastByClipboard(false);
            Debug("전체 프리셋 붙이기 시도");            
        }
        else
        {
            Debug("에디터 창이 닫혀 있어서 붙이기 안함.");
        }
    }
    return;
}

function string macroCommandArrayToString(out MacroPresetInfo mPresetInfo)
{
    local string CommandString;
    local int i;

    i = 0;
    J0x07:

    // End:0x57 [Loop If]
    if(i < 12)
    {
        // End:0x4D
        if(mPresetInfo.CommandList[i] != "")
        {
            CommandString = (CommandString $ mPresetInfo.CommandList[i]) $ Chr(13);
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x7B
    if(Len(CommandString) > 0)
    {
        CommandString = Left(CommandString, Len(CommandString) - 1);
    }
    return CommandString;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
