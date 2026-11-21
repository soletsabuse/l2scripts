class GMFindTreeWnd extends UICommonAPI;

const ASK_SUMMON_NUMBER = 10000;

enum EListType
{
    LISTTYPE_ITEM,                  // 0
    LISTTYPE_NPC,                   // 1
    LISTTYPE_QUEST,                 // 2
    LISTTYPE_SKILL,                 // 3
    LISTTYPE_CLASS,                 // 4
    LISTTYPE_SYSTEMSTRING,          // 5
    LISTTYPE_SYSTEMMESSAGE          // 6
};

var WindowHandle Me;
var string m_WindowName;
var bool bShow;
var Color Gold;
var ListCtrlHandle m_hFindTreeList;
var EditBoxHandle m_hEditBox;
var ComboBoxHandle m_hComboBox;
var ButtonHandle m_hBtnSummon;
var GMFindTreeWnd.EListType curListType;

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Me = GetWindowHandle("GMFindTreeWnd");
    m_hFindTreeList = GetListCtrlHandle(m_WindowName $ ".ListFindWnd");
    m_hEditBox = GetEditBoxHandle(m_WindowName $ ".EditBox");
    m_hComboBox = GetComboBoxHandle(m_WindowName $ ".ComboBox");
    m_hBtnSummon = GetButtonHandle(m_WindowName $ ".btnSummon");
    m_hFindTreeList.SetSelectedSelTooltip(false);
    m_hFindTreeList.SetAppearTooltipAtMouseX(true);
    bShow = false;
    Gold.R = 176;
    Gold.G = 153;
    Gold.B = 121;
    FillOutComboBoxHandle();
    return;
}

function FillOutComboBoxHandle()
{
    m_hComboBox.Clear();
    m_hComboBox.AddStringWithReserved(GetSystemString(691), int(0));
    m_hComboBox.AddStringWithReserved(GetSystemString(690), int(1));
    m_hComboBox.AddStringWithReserved(GetSystemString(699), int(2));
    m_hComboBox.AddStringWithReserved(GetSystemString(692), int(3));
    m_hComboBox.AddStringWithReserved(GetSystemString(2290), int(4));
    m_hComboBox.AddStringWithReserved("SystemString", int(5));
    m_hComboBox.AddStringWithReserved("SystemMessage", int(6));
    return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
    local string EditBoxString;

    EditBoxString = m_hEditBox.GetString();
    switch(strID)
    {
        // End:0x3E
        case "ComboBox":
            ShowList(EditBoxString, byte(IndexID));
            // End:0x41
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
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

function ShowList(string a_Param, GMFindTreeWnd.EListType listType)
{
    Me.HideWindow();
    curListType = listType;
    m_hEditBox.SetString(a_Param);
    m_hComboBox.SetSelectedNum(int(curListType));
    m_hBtnSummon.DisableWindow();
    switch(curListType)
    {
        // End:0x6D
        case 0:
            FindAllItem(a_Param);
            // End:0xE2
            break;
        // End:0x80
        case 2:
            FindAllQuest(a_Param);
            // End:0xE2
            break;
        // End:0x93
        case 1:
            FindAllNPC(a_Param);
            // End:0xE2
            break;
        // End:0xA6
        case 3:
            FindAllSkill(a_Param);
            // End:0xE2
            break;
        // End:0xB9
        case 4:
            FindAllCLASS(a_Param);
            // End:0xE2
            break;
        // End:0xCC
        case 5:
            FindAllSystemString(a_Param);
            // End:0xE2
            break;
        // End:0xDF
        case 6:
            FindAllSystemMessage(a_Param);
            // End:0xE2
            break;
        // End:0xFFFF
        default:
            break;
    }
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function FindAllCLASS(string a_Param)
{
    local int classIndex;
    local string fullNameString;

    ClearList();
    classIndex = 0;
    J0x0D:

    // End:0x89 [Loop If]
    if(classIndex < 500)
    {
        fullNameString = GetSystemString(Class'NWindow.UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(classIndex));
        // End:0x7F
        if(fullNameString != "")
        {
            // End:0x7F
            if((InsertRecordFindTreeList(fullNameString, a_Param, classIndex, GetClassRoleIconName(classIndex))) == 1000)
            {
                AddSystemMessage(3489);
                return;
            }
        }
        classIndex++;
        // [Loop Continue]
        goto J0x0D;
    }
    return;
}

function FindAllSystemString(string a_Param)
{
    local int i;
    local string fullNameString;

    ClearList();
    i = 0;
    J0x0D:

    // End:0x71 [Loop If]
    if(i < 10000)
    {
        fullNameString = GetSystemString(i);
        // End:0x67
        if(fullNameString != "")
        {
            // End:0x67
            if((InsertRecordFindTreeList(fullNameString, a_Param, i, "")) == 1000)
            {
                AddSystemMessage(3489);
                return;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x0D;
    }
    return;
}

function FindAllSystemMessage(string a_Param)
{
    local int i;
    local string fullNameString;

    ClearList();
    i = 0;
    J0x0D:

    // End:0x71 [Loop If]
    if(i < 7000)
    {
        fullNameString = GetSystemMessage(i);
        // End:0x67
        if(fullNameString != "")
        {
            // End:0x67
            if((InsertRecordFindTreeList(fullNameString, a_Param, i, "")) == 1000)
            {
                AddSystemMessage(3489);
                return;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x0D;
    }
    return;
}

function FindAllQuest(string a_Param)
{
    local int Id;
    local string fullNameString, IconName;
    local int QuestType;

    ClearList();
    Id = Class'NWindow.UIDATA_QUEST'.static.GetFirstID();
    J0x1B:

    // End:0x15B [Loop If]
    if(-1 != Id)
    {
        fullNameString = Class'NWindow.UIDATA_QUEST'.static.GetQuestName(Id);
        QuestType = Class'NWindow.UIDATA_QUEST'.static.GetQuestType(Id, 1);
        switch(QuestType)
        {
            // End:0x6A
            case 0:
            // End:0x9E
            case 2:
                IconName = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_1";
                // End:0x112
                break;
            // End:0xA2
            case 1:
            // End:0xD6
            case 3:
                IconName = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_2";
                // End:0x112
                break;
            // End:0xDB
            case 4:
            // End:0x10F
            case 5:
                IconName = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_3";
                // End:0x112
                break;
            // End:0xFFFF
            default:
                break;
        }
        // End:0x143
        if((InsertRecordFindTreeList(fullNameString, a_Param, Id, IconName)) == 1000)
        {
            AddSystemMessage(3489);
            return;
        }
        Id = Class'NWindow.UIDATA_QUEST'.static.GetNextID();
        // [Loop Continue]
        goto J0x1B;
    }
    return;
}

function FindAllSkill(string a_Param)
{
    local ItemID cID;
    local string fullNameString, IconName;

    ClearList();
    cID = Class'NWindow.UIDATA_SKILL'.static.GetFirstID();
    J0x1B:

    // End:0xAF [Loop If]
    if(IsValidItemID(cID))
    {
        fullNameString = Class'NWindow.UIDATA_SKILL'.static.GetName(cID, 1, 0);
        IconName = Class'NWindow.UIDATA_SKILL'.static.GetIconName(cID, 1, 0);
        // End:0x97
        if((InsertRecordFindTreeList(fullNameString, a_Param, cID.ClassID, IconName)) == 1000)
        {
            AddSystemMessage(3489);
            return;
        }
        cID = Class'NWindow.UIDATA_SKILL'.static.GetNextID();
        // [Loop Continue]
        goto J0x1B;
    }
    return;
}

function FindAllNPC(string a_Param)
{
    local int Id;
    local string fullNameString;

    ClearList();
    Id = Class'NWindow.UIDATA_NPC'.static.GetFirstID();
    J0x1B:

    // End:0x91 [Loop If]
    if(-1 != Id)
    {
        fullNameString = Class'NWindow.UIDATA_NPC'.static.GetNPCName(Id);
        // End:0x79
        if((InsertRecordFindTreeList(fullNameString, a_Param, Id + 1000000, "")) == 1000)
        {
            AddSystemMessage(3489);
            return;
        }
        Id = Class'NWindow.UIDATA_NPC'.static.GetNextID();
        // [Loop Continue]
        goto J0x1B;
    }
    return;
}

function FindAllItem(string a_Param)
{
    local ItemID cID;
    local string fullNameString, AdditionalName;
    local int itemNameClass;
    local string IconName;

    ClearList();
    m_hFindTreeList.SetTooltipType("SellItemList");
    cID = Class'NWindow.UIDATA_ITEM'.static.GetFirstID();
    J0x38:

    // End:0x177 [Loop If]
    if(IsValidItemID(cID))
    {
        fullNameString = Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID);
        itemNameClass = Class'NWindow.UIDATA_ITEM'.static.GetItemNameClass(cID);
        AdditionalName = Class'NWindow.UIDATA_ITEM'.static.GetItemAdditionalName(cID);
        IconName = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID);
        // End:0xD8
        if(itemNameClass == 0)
        {
            fullNameString = MakeFullSystemMsg(GetSystemMessage(2332), fullNameString);            
        }
        else
        {
            // End:0x100
            if(itemNameClass == 2)
            {
                fullNameString = MakeFullSystemMsg(GetSystemMessage(2331), fullNameString);
            }
        }
        // End:0x129
        if(Len(AdditionalName) > 0)
        {
            fullNameString = ((fullNameString $ "(") $ AdditionalName) $ ")";
        }
        // End:0x15F
        if((InsertRecordFindTreeList(fullNameString, a_Param, cID.ClassID, IconName)) == 1000)
        {
            AddSystemMessage(3489);
            return;
        }
        cID = Class'NWindow.UIDATA_ITEM'.static.GetNextID();
        // [Loop Continue]
        goto J0x38;
    }
    return;
}

function int makeSkillLevel(int Id)
{
    local LVDataRecord preRecord;
    local int recordCount;

    preRecord.LVDataList.Length = 2;
    recordCount = m_hFindTreeList.GetRecordCount();
    // End:0x30
    if(recordCount == 0)
    {
        return 1;
    }
    m_hFindTreeList.GetRec(recordCount - 1, preRecord);
    // End:0x7E
    if(preRecord.LVDataList[1].szData == string(Id))
    {
        return preRecord.LVDataList[1].nReserved1 + 1;
    }
    return 1;
    return;
}

function LVDataRecord InsertIconData(LVDataRecord Record, string IconName)
{
    local int nTextureWH, nTextureUV;

    Record.LVDataList[0].hasIcon = true;
    switch(curListType)
    {
        // End:0x33
        case 0:
            nTextureWH = 18;
            nTextureUV = 32;
            // End:0x91
            break;
        // End:0x4B
        case 3:
            nTextureWH = 18;
            nTextureUV = 32;
            // End:0x91
            break;
        // End:0x63
        case 4:
            nTextureWH = 16;
            nTextureUV = 16;
            // End:0x91
            break;
        // End:0x7B
        case 2:
            nTextureWH = 16;
            nTextureUV = 16;
            // End:0x91
            break;
        // End:0xFFFF
        default:
            nTextureWH = 16;
            nTextureUV = 16;
            // End:0x91
            break;
            break;
    }
    Record.LVDataList[0].nTextureWidth = nTextureWH;
    Record.LVDataList[0].nTextureHeight = nTextureWH;
    Record.LVDataList[0].nTextureU = nTextureUV;
    Record.LVDataList[0].nTextureV = nTextureUV;
    Record.LVDataList[0].szTexture = IconName;
    Record.LVDataList[0].IconPosX = 2;
    Record.LVDataList[0].FirstLineOffsetX = 2;
    return Record;
    return;
}

function int InsertRecordFindTreeList(string fullNameString, string a_Param, int Id, string IconName)
{
    local string modifiedString, itemParam;
    local LVDataRecord Record;

    Record.LVDataList.Length = 2;
    modifiedString = Locs(fullNameString, " ", "", false);
    // End:0x1B5
    if((((findMatchString(modifiedString, a_Param)) != -1) || a_Param == "") || a_Param == string(Id))
    {
        Record.LVDataList[0].bUseTextColor = true;
        Record.LVDataList[0].TextColor = Gold;
        // End:0xD5
        if(int(curListType) == int(0))
        {
            Class'NWindow.UIDATA_ITEM'.static.GetItemInfoString(Id, itemParam);
            Record.szReserved = itemParam;
            Record.nReserved1 = (Id);            
        }
        else
        {
            // End:0x128
            if(int(curListType) == int(3))
            {
                Record.LVDataList[1].nReserved1 = makeSkillLevel(Id);
                fullNameString = (fullNameString @ "Lv") $ string(Record.LVDataList[1].nReserved1);
            }
        }
        // End:0x14A
        if(IconName != "")
        {
            Record = InsertIconData(Record, IconName);
        }
        Record.LVDataList[0].szData = fullNameString;
        Record.LVDataList[1].szData = string(Id);
        Record.LVDataList[1].TextColor = Gold;
        m_hFindTreeList.InsertRecord(Record);
        return m_hFindTreeList.GetRecordCount();
    }
    return;
}

function int findMatchString(string modifiedString, string a_Param)
{
    local string delim;

    delim = " ";
    // End:0x26
    if(StringMatching(modifiedString, a_Param, delim))
    {
        return 1;        
    }
    else
    {
        return -1;
    }
    return 1;
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    Summon((1));
    return;
}

function Summon(INT64 Cnt)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 2;
    // End:0x173
    if(GetSelectedListCtrlItem(Record))
    {
        // End:0x173
        if(Record.LVDataList[1].szData != "")
        {
            switch(curListType)
            {
                // End:0x40
                case 0:
                // End:0x75
                case 1:
                    ProcessChatMessage(("//summon" @ Record.LVDataList[1].szData) @ (Cnt), 0);
                    // End:0x173
                    break;
                // End:0xBD
                case 3:
                    ProcessChatMessage((("//setskill" @ Record.LVDataList[1].szData) @ string(Record.LVDataList[1].nReserved1)) @ string(0), 0);
                    // End:0x173
                    break;
                // End:0xEB
                case 4:
                    ProcessChatMessage("//setclass" @ Record.LVDataList[1].szData, 0);
                    // End:0x173
                    break;
                // End:0x11E
                case 2:
                    ProcessChatMessage(("//setquest" @ Record.LVDataList[1].szData) @ string(0), 0);
                    // End:0x173
                    break;
                // End:0x147
                case 5:
                    ProcessChatMessage("///ss" @ Record.LVDataList[1].szData, 0);
                    // End:0x173
                    break;
                // End:0x170
                case 6:
                    ProcessChatMessage("///sm" @ Record.LVDataList[1].szData, 0);
                    // End:0x173
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x173! */
        return;
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x00E! */
}

function OnClickListCtrlRecord(string strID)
{
    m_hBtnSummon.EnableWindow();
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x88
        case "btnSummon":
            switch(curListType)
            {
                // End:0x2D
                case 0:
                    openDialogNumpad((1));
                    // End:0x85
                    break;
                // End:0x3E
                case 2:
                    Summon((1));
                    // End:0x85
                    break;
                // End:0x4F
                case 1:
                    openDialogNumpad((1));
                    // End:0x85
                    break;
                // End:0x60
                case 3:
                    Summon((1));
                    // End:0x85
                    break;
                // End:0x71
                case 5:
                    Summon((1));
                    // End:0x85
                    break;
                // End:0x82
                case 6:
                    Summon((1));
                    // End:0x85
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0xA0
            break;
        // End:0x9D
        case "btnFind":
            handleFind();
            // End:0xA0
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function handleFind()
{
    local string EditBoxString;

    EditBoxString = m_hEditBox.GetString();
    ShowList(EditBoxString, curListType);
    return;
}

function bool GetSelectedListCtrlItem(out LVDataRecord Record)
{
    local int Index;

    Index = m_hFindTreeList.GetSelectedIndex();
    // End:0x3B
    if(Index >= 0)
    {
        m_hFindTreeList.GetRec(Index, Record);
        return true;
    }
    return false;
    return;
}

function ClearList()
{
    m_hFindTreeList.DeleteAllItem();
    m_hFindTreeList.ClearTooltip();
    m_hFindTreeList.SetTooltipType("");
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

function HandleDialogOK()
{
    local INT64 inputNum;
    local int Id;

    // End:0x19
    if(!Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
    {
        return;
    }
    Id = Class'Interface.UICommonAPI'.static.DialogGetID();
    // End:0x5F
    if(Id == 10000)
    {
        inputNum = (Class'Interface.UICommonAPI'.static.DialogGetString());
        Summon(inputNum);
    }
    return;
}

function openDialogNumpad(INT64 Num)
{
    Class'Interface.UICommonAPI'.static.DialogSetID(10000);
    Class'Interface.UICommonAPI'.static.DialogSetEditType("number");
    Class'Interface.UICommonAPI'.static.DialogSetParamInt64(Num);
    Class'Interface.UICommonAPI'.static.DialogSetDefaultOK();
    Class'Interface.UICommonAPI'.static.DialogShow(1, 6, GetSystemString(1543) @ GetSystemString(192), string(self));
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x44
    if(m_hEditBox.IsFocused())
    {
        // End:0x44
        if(int(nKey) == int(13))
        {
            // End:0x44
            if((trim(m_hEditBox.GetString())) != "")
            {
                handleFind();
            }
        }
    }
    return;
}

defaultproperties
{
    m_WindowName="GMFindTreeWnd"
}