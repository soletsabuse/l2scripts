class MacroEditWnd extends UICommonAPI;

const MACRO_MAX_COUNT = 100;
const MACROCOMMAND_MAX_COUNT = 12;
const MACROICON_MAX_COUNT = 104;
const DEFAULT_MACROICON_ID = 1;
const MACRO_ICONANME = "L2UI.ActionWnd.Macro_Icon";

var string m_WindowName;
var bool m_bShow;
var int m_CurIconNum;
var int m_CurSkillID;
var ItemID m_CurMacroItemID;
var string m_CurFocusedBoxName;
var int m_CurFocusedBoxIndex;
var WindowHandle MacroEditWnd_Input;
var WindowHandle MacroEditWnd_IconList;
var WindowHandle MacroListWnd;
var WindowHandle Me;
var ButtonHandle m_EditUpButton;
var ButtonHandle m_EditDownButton;
var MultiEditBoxHandle MacroDesc_MultiEdit;

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(1260);
    RegisterEvent(1270);
    RegisterEvent(40);
    RegisterEvent(20);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    OnRegisterEvent();
    Me = GetWindowHandle("MacroEditWnd");
    MacroEditWnd_Input = GetWindowHandle("MacroEditWnd.MacroEditWnd_Input");
    MacroEditWnd_IconList = GetWindowHandle("MacroEditWnd.MacroEditWnd_IconList");
    MacroListWnd = GetWindowHandle("MacroListWnd");
    m_EditUpButton = GetButtonHandle("MacroEditWnd.BtnEditUp");
    m_EditDownButton = GetButtonHandle("MacroEditWnd.BtnEditDown");
    MacroDesc_MultiEdit = GetMultiEditBoxHandle("MacroEditWnd.MacroDesc_MultiEdit");
    m_bShow = false;
    m_CurIconNum = 1;
    ClearItemID(m_CurMacroItemID);
    InitTabOrder();
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("MacroEditWnd.texMacro", "L2UI.ActionWnd.Macro_Icon" $ string(1));
    Clear();
    return;
}

function OnShow()
{
    HandleMacroList();
    // End:0x1E
    if(MacroEditWnd_IconList.IsShowWindow())
    {
        swapWindow();
    }
    m_bShow = true;
    return;
}

function OnHide()
{
    m_bShow = false;
    return;
}

function bool hasIconInArray(string targetIconName)
{
    local int __var8466, __var14456;
    local bool __var14455;
    local ItemInfo ItemInfo;

    __var14456 = GetItemWindowHandle("MacroEditWnd.MacroEditWnd_IconList.MacroItem").GetItemNum();
    __var8466 = 0;
    J0x4B:

    // End:0xCB [Loop If]
    if(__var8466 < __var14456)
    {
        GetItemWindowHandle("MacroEditWnd.MacroEditWnd_IconList.MacroItem").GetItem(__var8466, ItemInfo);
        // End:0xC1
        if(targetIconName == ItemInfo.IconName)
        {
            __var14455 = true;
            // [Explicit Break]
            goto J0xCB;
        }
        __var8466++;
        // [Loop Continue]
        goto J0x4B;
    }
    J0xCB:

    return __var14455;
    return;
}

function HandleMacroList()
{
    local int __var8464;
    local ItemInfo infItem, nullItemInfo;
    local array<ItemID> mySkillIDArray;
    local string __var28477;
    local SkillInfo tempSkillInfo;

    GetItemWindowHandle("MacroEditWnd.MacroItem").Clear();
    __var8464 = 0;
    J0x2F:

    // End:0xC6 [Loop If]
    if(__var8464 < 113)
    {
        infItem.IconName = "L2UI.ActionWnd.Macro_Icon" $ string(__var8464 + 1);
        infItem.ItemSubType = 4;
        Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("MacroEditWnd.MacroEditWnd_IconList.MacroItem", infItem);
        __var8464++;
        // [Loop Continue]
        goto J0x2F;
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
            // End:0x14E
            break;
        // End:0x33
        case "btnCancel":
            OnClickCancel();
            // End:0x14E
            break;
        // End:0x48
        case "btnSave":
            OnClickSave();
            // End:0x14E
            break;
        // End:0x63
        case "btnIconChange":
            onClickIconChange();
            // End:0x14E
            break;
        // End:0x7E
        case "BtnEditUp":
            LineSwap("up");
            // End:0x14E
            break;
        // End:0x9D
        case "BtnEditDown":
            LineSwap("down");
            // End:0x14E
            break;
        // End:0xB5
        case "BtnEditdel":
            CurClearLine();
            // End:0x14E
            break;
        // End:0xCD
        case "BtnEditAdd":
            CurInsertLine();
            // End:0x14E
            break;
        // End:0xF6
        case "Preset_Btn":
            toggleWindow("MacroPresetWnd", true);
            // End:0x14E
            break;
        // End:0x111
        case "MacroCopy_Btn":
            macroTotalCopy();
            // End:0x14E
            break;
        // End:0x12D
        case "MacroPaste_Btn":
            macroTotalPaste();
            // End:0x14E
            break;
        // End:0x148
        case "BtnEditAlldel":
            clearAllMacrocommandEditbox();
            // End:0x14E
            break;
        // End:0xFFFF
        default:
            // End:0x14E
            break;
            break;
    }
    return;
}

function macroTotalCopy()
{
    local int __var6585;
    local string __var3724;

    __var6585 = 0;
    J0x07:

    // End:0x95 [Loop If]
    if(__var6585 < 12)
    {
        // End:0x8B
        if(GetEditBoxHandle("MacroEditWnd.txtEdit" $ string(__var6585)).GetString() != "")
        {
            __var3724 = (__var3724 $ GetEditBoxHandle("MacroEditWnd.txtEdit" $ string(__var6585)).GetString()) $ Chr(13);
        }
        __var6585++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0xB9
    if(Len(__var3724) > 0)
    {
        __var3724 = Left(__var3724, Len(__var3724) - 1);
    }
    Debug("Å¬ï¿½ï¿½ ï¿½ï¿½ï¿½å¿¡ Ä«ï¿½ï¿½ ï¿½Ç¾ï¿½ï¿½ï¿½ï¿½Ï´ï¿½.:" @ __var3724);
    AddSystemMessage(4399);
    ClipboardCopy(__var3724);
    return;
}

function macroTotalPaste()
{
    pastByClipboard(true);
    return;
}

function onClickIconChange()
{
    swapWindow();
    return;
}

function swapWindow()
{
    local ButtonHandle btnIconChange;

    btnIconChange = GetButtonHandle("MacroEditWnd.btnIconChange");
    // End:0x7E
    if(MacroEditWnd_Input.IsShowWindow())
    {
        btnIconChange.SetButtonName(2817);
        MacroEditWnd_Input.HideWindow();
        MacroEditWnd_IconList.ShowWindow();
        MacroEditWnd_IconList.SetFocus();        
    }
    else
    {
        btnIconChange.SetButtonName(2815);
        MacroEditWnd_Input.ShowWindow();
        MacroEditWnd_IconList.HideWindow();
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    local int __var26430;
    local ItemInfo infItem;

    // End:0x11D
    if((strID == "MacroItem") && Index > -1)
    {
        // End:0x11D
        if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("MacroEditWnd.MacroItem", Index, infItem))
        {
            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("MacroEditWnd.texMacro", infItem.IconName);
            // End:0xAD
            if(infItem.Level > 0)
            {
                m_CurSkillID = infItem.Level;                
            }
            else
            {
                m_CurSkillID = 0;
                __var26430 = Len(infItem.IconName) - Len("L2UI.ActionWnd.Macro_Icon");
                m_CurIconNum = int(Locs(infItem.IconName, "L2UI.ActionWnd.Macro_Icon", "", true));
            }
            swapWindow();
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1D
    if(Event_ID == 1260)
    {
        HandleMacroShowEditWnd(param);        
    }
    else
    {
        // End:0x3A
        if(Event_ID == 1270)
        {
            HandleMacroDeleted(param);            
        }
        else
        {
            // End:0x5B
            if(Event_ID == 1710)
            {
                // End:0x58
                if(DialogIsMine())
                {
                    ProcessInsertLine();
                }                
            }
            else
            {
                // End:0x6D
                if(Event_ID == 1720)
                {                    
                }
                else
                {
                    // End:0x83
                    if(Event_ID == 20)
                    {
                        pastByClipboard(true);                        
                    }
                    else
                    {
                        // End:0x95
                        if(Event_ID == 40)
                        {
                            Clear();
                        }
                    }
                }
            }
        }
    }
    return;
}

function setEditMacroInfo(string macroName, string IconTextureName)
{
    local int __var26426;

    GetEditBoxHandle("MacroEditWnd.txtName").SetString(macroName);
    GetTextBoxHandle("MacroEditWnd.txtMacroName").SetText(Left(macroName, 4));
    m_CurSkillID = 0;
    __var26426 = Len(IconTextureName) - Len("L2UI.MacroWnd.MACRO_ICON");
    m_CurIconNum = int(Locs(IconTextureName, "L2UI.MacroWnd.MACRO_ICON", "", true));
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("MacroEditWnd.texMacro", "L2UI.ActionWnd.Macro_Icon" $ string(m_CurIconNum));
    return;
}

function pastByClipboard(bool bLastEditBoxFocus)
{
    local string __var8439;
    local int __var13787;

    __var8439 = ClipboardPaste();
    // End:0xF1
    if(Len(__var8439) > 0)
    {
        // End:0xAE
        if(GetEditBoxHandle(m_CurFocusedBoxName).IsFocused())
        {
            __var13787 = GetCurTextBoxIndex(m_CurFocusedBoxName);
            pasteMacroEdit(__var13787, __var8439, bLastEditBoxFocus);
            Debug("ï¿½ï¿½ï¿½ï¿½ ï¿½ï¿½Ä¡ ï¿½ï¿½ï¿½ï¿½" @ string(__var13787));            
        }
        else
        {
            pasteMacroEdit(0, __var8439, bLastEditBoxFocus);
            Debug("Ã¹ï¿½ï¿½ ï¿½ï¿½ï¿½ï¿½");
        }
    }
    return;
}

function pasteMacroEdit(int nEditLine, string commandStr, optional bool bLastEditBoxFocus, optional bool onelineOverwrite)
{
    local array<string> commandArray;
    local int __var2289;
    local string __var13788;

    Split(commandStr, Chr(13), commandArray);
    Debug("Length : " @ string(commandArray.Length));
    // End:0x1D9
    if(InStr(commandStr, Chr(13)) != -1)
    {
        __var2289 = 0;
        J0x4B:

        // End:0x1D6 [Loop If]
        if(__var2289 < commandArray.Length)
        {
            // End:0x1CC
            if((nEditLine + __var2289) < 12)
            {
                __var13788 = deleteEnter(commandArray[__var2289]);
                Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtEdit" $ string(nEditLine + __var2289), __var13788);
                Debug((("ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½  ï¿½Ö±ï¿½" @ string(nEditLine + __var2289)) @ ": ") @ commandArray[__var2289]);
                Debug((("ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½  pasteString:" @ string(nEditLine + __var2289)) @ ": ") @ __var13788);
                // End:0x1CC
                if(bLastEditBoxFocus)
                {
                    // End:0x1CC
                    if((nEditLine + __var2289) < 11)
                    {
                        GetEditBoxHandle("MacroEditWnd.txtEdit" $ string((nEditLine + __var2289) + 1)).SetFocus();
                    }
                }
            }
            __var2289++;
            // [Loop Continue]
            goto J0x4B;
        }        
    }
    else
    {
        // End:0x219
        if(onelineOverwrite)
        {
            GetEditBoxHandle("MacroEditWnd.txtEdit" $ string(nEditLine)).SetString(commandStr);            
        }
        else
        {
            Debug("ï¿½ï¿½ï¿½ï¿½ ï¿½Ö±ï¿½" @ commandStr);
            GetEditBoxHandle("MacroEditWnd.txtEdit" $ string(nEditLine)).DeleteClipBoard();
            GetEditBoxHandle("MacroEditWnd.txtEdit" $ string(nEditLine)).AddString(commandStr);
        }
    }
    return;
}

function InitTabOrder()
{
    local int __var3725;

    Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd", "MacroEditWnd.txtName", "MacroEditWnd.MacroDesc_MultiEdit");
    Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtName", "MacroEditWnd.MacroDesc_MultiEdit", "MacroEditWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.MacroDesc_MultiEdit", "MacroEditWnd.txtEdit0", "MacroEditWnd.txtName");
    __var3725 = 0;
    J0x10F:

    // End:0x26B [Loop If]
    if(__var3725 < 12)
    {
        // End:0x188
        if(__var3725 == 0)
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtEdit0", "MacroEditWnd.txtEdit1", "MacroEditWnd.MacroDesc_MultiEdit");
            // [Explicit Continue]
            goto J0x261;
        }
        // End:0x1EF
        if(__var3725 == (12 - 1))
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtEdit11", "MacroEditWnd.txtName", "MacroEditWnd.txtEdit10");
            // [Explicit Continue]
            goto J0x261;
        }
        Class'NWindow.UIAPI_WINDOW'.static.SetTabOrder("MacroEditWnd.txtEdit" $ string(__var3725), "MacroEditWnd.txtEdit" $ string(__var3725 + 1), "MacroEditWnd.txtEdit" $ string(__var3725 - 1));
        J0x261:

        __var3725++;
        // [Loop Continue]
        goto J0x10F;
    }
    return;
}

function OnClickHelp()
{
    local string __var14408;

    ParamAdd(__var14408, "FilePath", "..\\L2text\\help_general_control_macro.htm");
    ExecuteEvent(1210, __var14408);
    return;
}

function OnClickCancel()
{
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
    return;
}

function OnClickSave()
{
    SaveMacro();
    return;
}

function OnDropItem(string strID, ItemInfo infItem, int X, int Y)
{
    local int __var1104;

    // End:0x0F
    if(Len(strID) < 1)
    {
        return;
    }
    // End:0x28
    if(Left(strID, 7) != "txtEdit")
    {
        return;
    }
    Class'NWindow.UIAPI_EDITBOX'.static.SetHighLight("MacroEditWnd." $ strID, false);
    __var1104 = int(Mid(strID, Len("txtEdit"), Len(strID)));
    // End:0xF9
    if(infItem.ItemSubType == 2)
    {
        // End:0xF9
        if(((Left(infItem.MacroCommand, 9) == "/useskill") || Left(infItem.DragSrcName, 10) == "PSkillItem") || Left(infItem.DragSrcName, 10) == "ASkillItem")
        {
            pasteMacroEdit(__var1104, infItem.MacroCommand, false, true);
            return;
        }
    }
    // End:0x12C
    if(infItem.Id.ClassID == 63)
    {
        pasteMacroEdit(__var1104, "/nexttarget", false, true);        
    }
    else
    {
        // End:0x160
        if(infItem.Id.ClassID == 92)
        {
            pasteMacroEdit(__var1104, "/nexttarget2", false, true);            
        }
        else
        {
            // End:0x198
            if(infItem.Id.ClassID == 77)
            {
                pasteMacroEdit(__var1104, "/combatmodeonoff", false, true);                
            }
            else
            {
                // End:0x1CF
                if(infItem.Id.ClassID == 1200)
                {
                    pasteMacroEdit(__var1104, "/tacticsign5", false, true);                    
                }
                else
                {
                    // End:0x206
                    if(infItem.Id.ClassID == 1201)
                    {
                        pasteMacroEdit(__var1104, "/tacticsign6", false, true);                        
                    }
                    else
                    {
                        // End:0x23D
                        if(infItem.Id.ClassID == 1202)
                        {
                            pasteMacroEdit(__var1104, "/tacticsign7", false, true);                            
                        }
                        else
                        {
                            // End:0x274
                            if(infItem.Id.ClassID == 1203)
                            {
                                pasteMacroEdit(__var1104, "/tacticsign8", false, true);                                
                            }
                            else
                            {
                                // End:0x2B1
                                if(infItem.Id.ClassID == 1204)
                                {
                                    pasteMacroEdit(__var1104, "/targettacticsign5", false, true);                                    
                                }
                                else
                                {
                                    // End:0x2EE
                                    if(infItem.Id.ClassID == 1205)
                                    {
                                        pasteMacroEdit(__var1104, "/targettacticsign6", false, true);                                        
                                    }
                                    else
                                    {
                                        // End:0x32B
                                        if(infItem.Id.ClassID == 1206)
                                        {
                                            pasteMacroEdit(__var1104, "/targettacticsign7", false, true);                                            
                                        }
                                        else
                                        {
                                            // End:0x368
                                            if(infItem.Id.ClassID == 1207)
                                            {
                                                pasteMacroEdit(__var1104, "/targettacticsign8", false, true);                                                
                                            }
                                            else
                                            {
                                                // End:0x39F
                                                if(infItem.Id.ClassID == 1208)
                                                {
                                                    pasteMacroEdit(__var1104, "/tacticsign9", false, true);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x3D7
                                                    if(infItem.Id.ClassID == 1209)
                                                    {
                                                        pasteMacroEdit(__var1104, "/tacticsign10", false, true);                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x40F
                                                        if(infItem.Id.ClassID == 1210)
                                                        {
                                                            pasteMacroEdit(__var1104, "/tacticsign11", false, true);                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x447
                                                            if(infItem.Id.ClassID == 1211)
                                                            {
                                                                pasteMacroEdit(__var1104, "/tacticsign12", false, true);                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x484
                                                                if(infItem.Id.ClassID == 1212)
                                                                {
                                                                    pasteMacroEdit(__var1104, "/targettacticsign9", false, true);                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x4C2
                                                                    if(infItem.Id.ClassID == 1213)
                                                                    {
                                                                        pasteMacroEdit(__var1104, "/targettacticsign10", false, true);                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x500
                                                                        if(infItem.Id.ClassID == 1214)
                                                                        {
                                                                            pasteMacroEdit(__var1104, "/targettacticsign11", false, true);                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x53E
                                                                            if(infItem.Id.ClassID == 1215)
                                                                            {
                                                                                pasteMacroEdit(__var1104, "/targettacticsign12", false, true);                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x592
                                                                                if((infItem.ItemSubType == 3) && Len(infItem.MacroCommand) <= 1)
                                                                                {
                                                                                    pasteMacroEdit(__var1104, "/useaction" @ string(infItem.Id.ClassID), false, true);                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    pasteMacroEdit(__var1104, infItem.MacroCommand, false, true);
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function OnDragItemStart(string strID, ItemInfo infItem)
{
    // End:0x0F
    if(Len(strID) < 1)
    {
        return;
    }
    // End:0x28
    if(Left(strID, 7) != "txtEdit")
    {
        return;
    }
    Class'NWindow.UIAPI_EDITBOX'.static.SetHighLight("MacroEditWnd." $ strID, true);
    return;
}

function OnDragItemEnd(string strID)
{
    // End:0x0F
    if(Len(strID) < 1)
    {
        return;
    }
    // End:0x28
    if(Left(strID, 7) != "txtEdit")
    {
        return;
    }
    Class'NWindow.UIAPI_EDITBOX'.static.SetHighLight("MacroEditWnd." $ strID, false);
    return;
}

function OnChangeEditBox(string strID)
{
    local string __var13801, __var14389;

    // End:0xB6
    if(InStr(strID, "txtEdit") > -1)
    {
        __var13801 = GetEditBoxHandle("MacroEditWnd." $ strID).GetString();
        // End:0xB4
        if(InStr(__var13801, "targetnext") > -1)
        {
            __var14389 = Locs(__var13801, "targetnext", "nexttarget", false);
            GetEditBoxHandle("MacroEditWnd." $ strID).SetString(__var14389);
        }
        return;
    }
    switch(strID)
    {
        // End:0xD2
        case "txtName":
            UpdateIconName();
            // End:0xD8
            break;
        // End:0xFFFF
        default:
            // End:0xD8
            break;
            break;
    }
    return;
}

function UpdateIcon()
{
    local string __var28535;

    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("MacroEditWnd.texMacro", "L2UI.ActionWnd.Macro_Icon" $ string(m_CurIconNum));
    return;
}

function UpdateIconName()
{
    local string __var14386;

    __var14386 = Left(Class'NWindow.UIAPI_EDITBOX'.static.GetString("MacroEditWnd.txtName"), 4);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("MacroEditWnd.txtMacroName", __var14386);
    return;
}

function Clear()
{
    m_CurSkillID = 0;
    m_CurIconNum = 1;
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtName", "");
    MacroDesc_MultiEdit.SetString("");
    clearAllMacrocommandEditbox();
    UpdateIcon();
    UpdateIconName();
    return;
}

function clearAllMacrocommandEditbox()
{
    local int __var8408;

    __var8408 = 0;
    J0x07:

    // End:0x4D [Loop If]
    if(__var8408 < 12)
    {
        Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtEdit" $ string(__var8408), "");
        __var8408++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function HandleMacroDeleted(string param)
{
    local ItemID cID;

    ParseItemID(param, cID);
    // End:0x2A
    if(m_bShow)
    {
        Clear();
        ClearItemID(m_CurMacroItemID);
    }
    return;
}

function HandleMacroShowEditWnd(string param)
{
    local int __var14377;
    local Color TextColor;

    Clear();
    ClearItemID(m_CurMacroItemID);
    Debug("param" @ param);
    // End:0xC2
    if(ParseItemID(param, m_CurMacroItemID))
    {
        SetMacroID(m_CurMacroItemID);
        // End:0x73
        if(!m_bShow)
        {
            PlayConsoleSound(5);
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
        }
        GetEditBoxHandle("MacroEditWnd.txtEdit0").SetFocus();
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtName");        
    }
    else
    {
        // End:0xCE
        if(m_bShow)
        {            
        }
        else
        {
            __var14377 = Class'NWindow.UIDATA_MACRO'.static.GetMacroCount();
            // End:0x146
            if(__var14377 >= 100)
            {
                TextColor.R = 176;
                TextColor.G = 155;
                TextColor.B = 121;
                TextColor.A = byte(255);
                DialogShow(1, 5, GetSystemMessage(797), string(self));
                DialogSetID(0);
                return;
            }
            PlayConsoleSound(5);
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("MacroEditWnd");
            GetEditBoxHandle("MacroEditWnd.txtEdit0").SetFocus();
            Class'NWindow.UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtName");
        }
    }
    return;
}

function SetMacroID(ItemID cID)
{
    local int __var6635;
    local MacroInfo Info;
    local int __var28552;

    // End:0x12
    if(!IsValidItemID(cID))
    {
        return;
    }
    // End:0x144
    if(Class'NWindow.UIDATA_MACRO'.static.GetMacroInfo(cID, Info))
    {
        Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtName", Info.Name);
        // End:0x87
        if(Info.IconSkillId > 0)
        {
            m_CurSkillID = Info.IconSkillId;
            m_CurIconNum = 1;            
        }
        else
        {
            m_CurIconNum = int(Locs(Info.IconTextureName, "L2UI.MacroWnd.MACRO_ICON", "", true));
        }
        // End:0xCA
        if(m_CurIconNum < 1)
        {
            m_CurIconNum = 1;
        }
        UpdateIcon();
        MacroDesc_MultiEdit.SetString(Info.Description);
        __var6635 = 0;
        J0xF0:

        // End:0x144 [Loop If]
        if(__var6635 < 12)
        {
            Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtEdit" $ string(__var6635), Info.CommandList[__var6635]);
            __var6635++;
            // [Loop Continue]
            goto J0xF0;
        }
    }
    return;
}

function SaveMacro()
{
    local int __var8403, __var13821;
    local string __var13824, __var14351, __var13833;
    local array<string> CommandList;

    __var13824 = Class'NWindow.UIAPI_EDITBOX'.static.GetString("MacroEditWnd.txtName");
    __var14351 = MacroDesc_MultiEdit.GetString();
    __var8403 = 0;
    J0x47:

    // End:0xBF [Loop If]
    if(__var8403 < 12)
    {
        __var13833 = Class'NWindow.UIAPI_EDITBOX'.static.GetString("MacroEditWnd.txtEdit" $ string(__var8403));
        // End:0xB5
        if(__var13833 != "")
        {
            CommandList.Insert(CommandList.Length, 1);
            CommandList[CommandList.Length - 1] = __var13833;
        }
        __var8403++;
        // [Loop Continue]
        goto J0x47;
    }
    __var13821 = CommandList.Length;
    J0xCB:

    // End:0x100 [Loop If]
    if(__var13821 < 12)
    {
        CommandList.Insert(CommandList.Length, 1);
        CommandList[CommandList.Length - 1] = "";
        __var13821++;
        // [Loop Continue]
        goto J0xCB;
    }
    // End:0x159
    if(Class'NWindow.MacroAPI'.static.RequestMakeMacro(m_CurMacroItemID, __var13824, Left(__var13824, 4), m_CurIconNum - 1, m_CurSkillID, __var14351, CommandList))
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("MacroEditWnd");
    }
    return;
}

function CurClearLine()
{
    local int __var4346, __var2865;
    local string __var14336, __var14332;
    local array<string> List;

    __var4346 = GetCurTextBoxIndex(m_CurFocusedBoxName);
    List.Remove(0, List.Length);
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtEdit" $ string(__var4346), "");
    __var2865 = __var4346 + 1;
    J0x5C:

    // End:0xF8 [Loop If]
    if(__var2865 < 12)
    {
        __var14332 = Class'NWindow.UIAPI_EDITBOX'.static.GetString("MacroEditWnd.txtEdit" $ string(__var2865));
        Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtEdit" $ string(__var2865), "");
        List.Insert(List.Length, 1);
        List[List.Length - 1] = __var14332;
        __var2865++;
        // [Loop Continue]
        goto J0x5C;
    }
    __var2865 = __var4346;
    J0x103:

    // End:0x16F [Loop If]
    if(__var2865 < (List.Length + __var4346))
    {
        __var14336 = List[__var2865 - __var4346];
        Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtEdit" $ string(__var2865), __var14336);
        __var2865++;
        // [Loop Continue]
        goto J0x103;
    }
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtEdit" $ string(__var4346));
    return;
}

function removeAllEditBox()
{
    local int __var8377;

    __var8377 = 0;
    J0x07:

    // End:0x4D [Loop If]
    if(__var8377 < 12)
    {
        Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtEdit" $ string(__var8377), "");
        __var8377++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function CurInsertLine()
{
    m_CurFocusedBoxIndex = GetCurTextBoxIndex(m_CurFocusedBoxName);
    // End:0x67
    if(Class'NWindow.UIAPI_EDITBOX'.static.GetString("MacroEditWnd.txtEdit" $ string(12 - 1)) != "")
    {
        DialogShow(0, 0, GetSystemMessage(4208), string(self));
        DialogSetID(0);
        return;
    }
    ProcessInsertLine();
    return;
}

function ProcessInsertLine()
{
    local int __var5389, __var2864, __var13844;
    local string __var14318, __var14316;
    local array<string> List;

    __var5389 = m_CurFocusedBoxIndex;
    __var2864 = __var5389;
    J0x16:

    // End:0x82 [Loop If]
    if(__var2864 < 12)
    {
        __var14316 = Class'NWindow.UIAPI_EDITBOX'.static.GetString("MacroEditWnd.txtEdit" $ string(__var2864));
        List.Insert(List.Length, 1);
        List[List.Length - 1] = __var14316;
        __var2864++;
        // [Loop Continue]
        goto J0x16;
    }
    __var2864 = __var5389;
    J0x8D:

    // End:0x116 [Loop If]
    if(__var2864 < 12)
    {
        __var13844 = __var2864 - __var5389;
        // End:0x10C
        if(__var13844 >= 0)
        {
            __var14318 = List[__var13844];
            // End:0x10C
            if((__var2864 + 1) < 12)
            {
                Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtEdit" $ string(__var2864 + 1), __var14318);
            }
        }
        __var2864++;
        // [Loop Continue]
        goto J0x8D;
    }
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtEdit" $ string(__var5389), "");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtEdit" $ string(__var5389));
    return;
}

function LineSwap(string strType)
{
    local int __var4338;

    __var4338 = GetCurTextBoxIndex(m_CurFocusedBoxName);
    // End:0x40
    if(strType == "up")
    {
        // End:0x3D
        if(__var4338 > 0)
        {
            SwapString(__var4338, __var4338 - 1);
        }        
    }
    else
    {
        // End:0x72
        if(strType == "down")
        {
            // End:0x72
            if(__var4338 < (12 - 1))
            {
                SwapString(__var4338, __var4338 + 1);
            }
        }
    }
    return;
}

function SwapString(int firstID, int lastID)
{
    local string __var14302, __var14299;

    __var14299 = Class'NWindow.UIAPI_EDITBOX'.static.GetString("MacroEditWnd.txtEdit" $ string(firstID));
    __var14302 = Class'NWindow.UIAPI_EDITBOX'.static.GetString("MacroEditWnd.txtEdit" $ string(lastID));
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtEdit" $ string(firstID), __var14302);
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("MacroEditWnd.txtEdit" $ string(lastID), __var14299);
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("MacroEditWnd.txtEdit" $ string(lastID));
    return;
}

function int GetCurTextBoxIndex(string boxName)
{
    local string __var13858;
    local int __var13865;

    // End:0x5A
    if(Left(boxName, 7) == "txtEdit")
    {
        __var13858 = Right(boxName, 2);
        // End:0x49
        if(Left(__var13858, 1) == "t")
        {
            __var13865 = int(Right(boxName, 1));            
        }
        else
        {
            __var13865 = int(Right(__var13858, 2));
        }
    }
    return __var13865;
    return;
}

function OnSetFocus(WindowHandle Handle, bool bFocused)
{
    local int __var13866;

    // End:0x16F
    if(string(Handle.Name) == "EditBoxHandle")
    {
        m_CurFocusedBoxName = Handle.GetWindowName();
        __var13866 = GetCurTextBoxIndex(m_CurFocusedBoxName);
        m_EditUpButton.EnableWindow();
        m_EditDownButton.EnableWindow();
        m_EditUpButton.SetTexture("L2UI_CT1.Button.BtnEditUp", "", "");
        m_EditDownButton.SetTexture("L2UI_CT1.Button.BtnEditDown", "", "");
        // End:0x119
        if(__var13866 == 0)
        {
            m_EditUpButton.DisableWindow();
            m_EditUpButton.SetTexture("L2UI_CT1.Button.BtnEditUp_disable", "", "");            
        }
        else
        {
            // End:0x16F
            if(__var13866 == (12 - 1))
            {
                m_EditDownButton.DisableWindow();
                m_EditDownButton.SetTexture("L2UI_CT1.Button.BtnEditDown_disable", "", "");
            }
        }
    }
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
    local int nEditLine;

    // End:0x84
    if((int(Key) == int(38)) || int(Key) == int(40))
    {
        nEditLine = int(Mid(m_CurFocusedBoxName, Len("txtEdit"), Len(m_CurFocusedBoxName)));
        // End:0x84
        if(!GetEditBoxHandle("MacroEditWnd.txtEdit" $ string(nEditLine)).IsFocused())
        {
            nEditLine = -1;
            return;
        }
    }
    switch(Key)
    {
        // End:0xD4
        case 38:
            // End:0xD1
            if(nEditLine > 0)
            {
                nEditLine--;
                GetEditBoxHandle("MacroEditWnd.txtEdit" $ string(nEditLine)).SetFocus();
            }
            // End:0x121
            break;
        // End:0x11E
        case 40:
            // End:0x11B
            if(nEditLine < 11)
            {
                nEditLine++;
                GetEditBoxHandle("MacroEditWnd.txtEdit" $ string(nEditLine)).SetFocus();
            }
            // End:0x121
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function bool isActiveSkill(SkillInfo Info)
{
    local bool __var14287;

    switch(Info.IconType)
    {
        // End:0x10
        case 0:
        // End:0x14
        case 1:
        // End:0x19
        case 2:
        // End:0x1E
        case 3:
        // End:0x23
        case 4:
        // End:0x28
        case 5:
        // End:0x2D
        case 6:
        // End:0x32
        case 7:
        // End:0x42
        case 8:
            __var14287 = true;
            // End:0x48
            break;
        // End:0xFFFF
        default:
            // End:0x48
            break;
            break;
    }
    return __var14287;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="MacroEditWnd"
}