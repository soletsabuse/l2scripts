class UIEditor_ControlManager extends UICommonAPI;

const XML_PATH = "..\\Interface\\Default";

var WindowHandle Me;
var TextBoxHandle txtNewControl;
var ListBoxHandle lstControls;
var ItemWindowHandle ControlItem;
var TextBoxHandle txtControlAlign;
var CheckBoxHandle chkShowWindowBox;
var CheckBoxHandle chkVirtualBack;
var CheckBoxHandle chkExampleAni;
var ButtonHandle btnLeft;
var ButtonHandle btnCenter;
var ButtonHandle btnRight;
var ButtonHandle btnWidth;
var ButtonHandle btnHeight;
var ButtonHandle btnUp;
var ButtonHandle btnDown;
var ListCtrlHandle lstCurrentControl;
var WindowHandle m_CurTopWnd;

function OnRegisterEvent()
{
    RegisterEvent(2920);
    RegisterEvent(2930);
    RegisterEvent(2940);
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
    return;
}

function InitHandle()
{
    // End:0x322
    if(1 == 0)
    {
        Me = GetHandle("UIEditor_ControlManager");
        ControlItem = ItemWindowHandle(GetHandle("UIEditor_ControlManager.NewControlItem"));
        lstControls = ListBoxHandle(GetHandle("UIEditor_ControlManager.lstControls"));
        txtControlAlign = TextBoxHandle(GetHandle("UIEditor_ControlManager.txtControlAlign"));
        chkShowWindowBox = CheckBoxHandle(GetHandle("UIEditor_ControlManager.chkShowWindowBox"));
        chkVirtualBack = CheckBoxHandle(GetHandle("UIEditor_ControlManager.chkVirtualBack"));
        chkExampleAni = CheckBoxHandle(GetHandle("UIEditor_ControlManager.chkExampleAni"));
        btnLeft = ButtonHandle(GetHandle("UIEditor_ControlManager.btnLeft"));
        btnCenter = ButtonHandle(GetHandle("UIEditor_ControlManager.btnCenter"));
        btnRight = ButtonHandle(GetHandle("UIEditor_ControlManager.btnRight"));
        btnWidth = ButtonHandle(GetHandle("UIEditor_ControlManager.btnWidth"));
        btnHeight = ButtonHandle(GetHandle("UIEditor_ControlManager.btnHeight"));
        btnUp = ButtonHandle(GetHandle("UIEditor_ControlManager.btnUp"));
        btnDown = ButtonHandle(GetHandle("UIEditor_ControlManager.btnDown"));
        lstCurrentControl = ListCtrlHandle(GetHandle("UIEditor_ControlManager.lstCurrentControl"));        
    }
    else
    {
        Me = GetWindowHandle("UIEditor_ControlManager");
        ControlItem = GetItemWindowHandle("UIEditor_ControlManager.NewControlItem");
        lstControls = GetListBoxHandle("UIEditor_ControlManager.lstControls");
        txtControlAlign = GetTextBoxHandle("UIEditor_ControlManager.txtControlAlign");
        chkShowWindowBox = GetCheckBoxHandle("UIEditor_ControlManager.chkShowWindowBox");
        chkVirtualBack = GetCheckBoxHandle("UIEditor_ControlManager.chkVirtualBack");
        chkExampleAni = GetCheckBoxHandle("UIEditor_ControlManager.chkExampleAni");
        btnLeft = GetButtonHandle("UIEditor_ControlManager.btnLeft");
        btnCenter = GetButtonHandle("UIEditor_ControlManager.btnCenter");
        btnRight = GetButtonHandle("UIEditor_ControlManager.btnRight");
        btnWidth = GetButtonHandle("UIEditor_ControlManager.btnWidth");
        btnHeight = GetButtonHandle("UIEditor_ControlManager.btnHeight");
        btnUp = GetButtonHandle("UIEditor_ControlManager.btnUp");
        btnDown = GetButtonHandle("UIEditor_ControlManager.btnDown");
        lstCurrentControl = GetListCtrlHandle("UIEditor_ControlManager.lstCurrentControl");
    }
    return;
}

function InitControlItem()
{
    local ItemInfo infItem;

    Me.SetWindowTitle("UIEditor - ControlManager");
    infItem.Name = "NewControl";
    infItem.IconName = "L2UI_CH3.MenuIcon.menuButton4";
    ControlItem.AddItem(infItem);
    txtControlAlign.SetText("Control Align");
    InitNewControlList();
    return;
}

function InitNewControlList()
{
    local int i;
    local string strName;

    lstControls.Clear();
    i = 1;
    J0x16:

    // End:0x66 [Loop If]
    if(i < 100)
    {
        strName = GetXMLControlString(byte(i));
        // End:0x59
        if(Len(strName) > 0)
        {
            lstControls.AddString(strName);
            // [Explicit Continue]
            goto J0x5C;
        }
        // [Explicit Break]
        goto J0x66;
        J0x5C:

        i++;
        // [Loop Continue]
        goto J0x16;
    }
    J0x66:

    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x18
    if(Event_ID == 2920)
    {
        HandleTrackerAttach();        
    }
    else
    {
        // End:0x30
        if(Event_ID == 2930)
        {
            HandleTrackerDetach();            
        }
        else
        {
            // End:0x4A
            if(Event_ID == 2940)
            {
                HandleEditorSetProperty(param);
            }
        }
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x13
        case "btnLeft":
        // End:0x21
        case "btnCenter":
        // End:0x2E
        case "btnRight":
        // End:0x3B
        case "btnWidth":
        // End:0x57
        case "btnHeight":
            OnAlignClick(Name);
            // End:0x7E
            break;
        // End:0x61
        case "btnUp":
        // End:0x7B
        case "btnDown":
            OnOrderClick(Name);
            // End:0x7E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickCheckBox(string Name)
{
    switch(Name)
    {
        // End:0x34
        case "chkShowWindowBox":
            ShowEnableTrackerBox(chkShowWindowBox.IsChecked());
            // End:0x8C
            break;
        // End:0x5F
        case "chkVirtualBack":
            ShowVirtualWindowBackground(chkVirtualBack.IsChecked());
            // End:0x8C
            break;
        // End:0x89
        case "chkExampleAni":
            ShowExampleAnimation(chkExampleAni.IsChecked());
            // End:0x8C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function UIEventManager.EXMLControlType GetCurrentControlType()
{
    return GetXMLControlIndex(GetCurrentControlTypeString());
    return;
}

function string GetCurrentControlTypeString()
{
    return lstControls.GetSelectedString();
    return;
}

function OnAlignClick(string Name)
{
    switch(Name)
    {
        // End:0x1E
        case "btnLeft":
            ExecuteAlign(0);
            // End:0x83
            break;
        // End:0x37
        case "btnCenter":
            ExecuteAlign(1);
            // End:0x83
            break;
        // End:0x4F
        case "btnRight":
            ExecuteAlign(2);
            // End:0x83
            break;
        // End:0x67
        case "btnWidth":
            ExecuteAlign(3);
            // End:0x83
            break;
        // End:0x80
        case "btnHeight":
            ExecuteAlign(4);
            // End:0x83
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickListCtrlRecord(string strID)
{
    local int idx;
    local LVDataRecord Record;

    // End:0x1F
    if(strID != "lstCurrentControl")
    {
        return;
    }
    idx = lstCurrentControl.GetSelectedIndex();
    // End:0x41
    if(idx < 0)
    {
        return;
    }
    lstCurrentControl.GetRec(idx, Record);
    SelectControl(Record.szReserved);
    return;
}

function OnDBClickListCtrlRecord(string strID)
{
    local int idx;
    local LVDataRecord Record;
    local WindowHandle hWnd;

    // End:0x1F
    if(strID != "lstCurrentControl")
    {
        return;
    }
    idx = lstCurrentControl.GetSelectedIndex();
    // End:0x41
    if(idx < 0)
    {
        return;
    }
    lstCurrentControl.GetRec(idx, Record);
    // End:0x6F
    if(__NFUN_408__(Record.nReserved1, (1)))
    {
        return;
    }
    hWnd = FindWindowHandle(Record.szReserved);
    // End:0xE9
    if(Record.LVDataList[0].szTexture != "")
    {
        Record.LVDataList[0].nTextureWidth = 0;
        Record.LVDataList[0].nTextureHeight = 0;
        Record.LVDataList[0].szTexture = "";
        hWnd.EnterState();        
    }
    else
    {
        Record.LVDataList[0].nTextureWidth = 12;
        Record.LVDataList[0].nTextureHeight = 12;
        Record.LVDataList[0].szTexture = "L2UI_CH3.RadioCtrl.RadioButton1";
        hWnd.ExitState();
    }
    lstCurrentControl.ModifyRecord(idx, Record);
    return;
}

function UpdateControlList()
{
    m_CurTopWnd = none;
    return;
}

function RefreshControlList()
{
    UpdateControlList();
    HandleTrackerAttach();
    return;
}

function HandleTrackerAttach()
{
    local WindowHandle TrackerWnd, TopWnd;

    TrackerWnd = GetTrackerAttachedWindow();
    // End:0x19
    if(TrackerWnd == none)
    {
        return;
    }
    TopWnd = TrackerWnd.GetTopFrameWnd();
    // End:0x3B
    if(TopWnd == none)
    {
        return;
    }
    // End:0x72
    if(m_CurTopWnd != TopWnd)
    {
        m_CurTopWnd = TopWnd;
        lstCurrentControl.DeleteAllItem();
        AddChildWIndowToList(TopWnd, "", 0);
    }
    SelectControlList(GetFullName(TrackerWnd));
    return;
}

function HandleTrackerDetach()
{
    m_CurTopWnd = none;
    lstCurrentControl.DeleteAllItem();
    return;
}

function HandleEditorSetProperty(string param)
{
    local string PropertyName;
    local int Count;
    local array<string> NameList;

    ParseString(param, "PropertyName", PropertyName);
    // End:0x2D
    if(Len(PropertyName) < 1)
    {
        return;
    }
    Count = Split(PropertyName, ".", NameList);
    // End:0x54
    if(Count < 2)
    {
        return;
    }
    // End:0xA0
    if((NameList[Count - 1] == "name") && NameList[Count - 2] == "DefaultProperty")
    {
        UpdateControlList();
        HandleTrackerAttach();
    }
    return;
}

function AddChildWIndowToList(WindowHandle hWnd, string parentName, int depth)
{
    local int idx;
    local UIEventManager.EXMLControlType Type;
    local string Name, FullName;
    local array<WindowHandle> ChildList;
    local LVDataRecord Record;
    local int ChildDepth;
    local string ChildHead;

    // End:0x0D
    if(hWnd == none)
    {
        return;
    }
    Type = hWnd.GetControlType();
    // End:0x34
    if(int(Type) == int(0))
    {
        return;
    }
    // End:0x4A
    if(!hWnd.IsShowWindow())
    {
        return;
    }
    Name = hWnd.GetWindowName();
    // End:0x6E
    if(Len(Name) < 1)
    {
        return;
    }
    FullName = Name;
    // End:0x9D
    if(Len(parentName) > 0)
    {
        FullName = (parentName $ ".") $ Name;
    }
    // End:0xFE
    if(depth > 0)
    {
        idx = 0;
        J0xAF:

        // End:0xFE [Loop If]
        if(idx < depth)
        {
            // End:0xE4
            if(idx == (depth - 1))
            {
                ChildHead = ChildHead $ "¦¦";
                // [Explicit Continue]
                goto J0xF4;
            }
            ChildHead = ChildHead $ " ";
            J0xF4:

            idx++;
            // [Loop Continue]
            goto J0xAF;
        }
    }
    Record.LVDataList.Length = 4;
    Record.szReserved = FullName;
    Record.nReserved1 = (depth);
    Record.LVDataList[1].szData = ChildHead $ Name;
    Record.LVDataList[2].szData = GetXMLControlString(Type);
    Record.LVDataList[3].szData = ReverseParentName(parentName);
    lstCurrentControl.InsertRecord(Record);
    // End:0x1B2
    if(!hWnd.IsControlContainer())
    {
        return;
    }
    hWnd.GetChildWindowList(ChildList);
    ChildDepth = depth + 1;
    idx = 0;
    J0x1DB:

    // End:0x210 [Loop If]
    if(idx < ChildList.Length)
    {
        AddChildWIndowToList(ChildList[idx], FullName, ChildDepth);
        idx++;
        // [Loop Continue]
        goto J0x1DB;
    }
    return;
}

function SelectControl(string ControlName)
{
    local WindowHandle hWnd;

    // End:0x0F
    if(Len(ControlName) < 1)
    {
        return;
    }
    hWnd = FindWindowHandle(ControlName);
    // End:0x3A
    if(hWnd != none)
    {
        hWnd.SetFocus();
    }
    return;
}

function string ReverseParentName(string Name)
{
    local int idx, Count;
    local string NewName;
    local array<string> NameList;

    // End:0x10
    if(Len(Name) < 1)
    {
        return "";
    }
    Count = Split(Name, ".", NameList);
    idx = Count - 1;
    J0x37:

    // End:0x81 [Loop If]
    if(idx >= 0)
    {
        // End:0x5F
        if(Len(NewName) > 0)
        {
            NewName = NewName $ ".";
        }
        NewName = NewName $ NameList[idx];
        idx--;
        // [Loop Continue]
        goto J0x37;
    }
    return NewName;
    return;
}

function WindowHandle FindWindowHandle(string a_FullName)
{
    local int idx, Count;
    local string NewName;
    local array<string> NameList;
    local WindowHandle ParentHandle, FindedHandle;

    NewName = a_FullName;
    Count = Split(a_FullName, ".", NameList);
    // End:0xB0
    if(Count > 1)
    {
        NewName = "";
        idx = 1;
        J0x3E:

        // End:0x8C [Loop If]
        if(idx < Count)
        {
            // End:0x6A
            if(Len(NewName) > 0)
            {
                NewName = NewName $ ".";
            }
            NewName = NewName $ NameList[idx];
            idx++;
            // [Loop Continue]
            goto J0x3E;
        }
        ParentHandle = m_CurTopWnd;
        FindedHandle = FindHandle(NewName, ParentHandle);        
    }
    else
    {
        FindedHandle = m_CurTopWnd;
    }
    return FindedHandle;
    return;
}

function SelectControlList(string FullName)
{
    local int idx;
    local LVDataRecord Record;

    // End:0x0F
    if(Len(FullName) < 1)
    {
        return;
    }
    idx = 0;
    J0x16:

    // End:0x7E [Loop If]
    if(idx < lstCurrentControl.GetRecordCount())
    {
        lstCurrentControl.GetRec(idx, Record);
        // End:0x74
        if(Record.szReserved == FullName)
        {
            lstCurrentControl.SetSelectedIndex(idx, true);
            // [Explicit Break]
            goto J0x7E;
        }
        idx++;
        // [Loop Continue]
        goto J0x16;
    }
    J0x7E:

    return;
}

function string GetFullName(WindowHandle hWnd)
{
    local UIEventManager.EXMLControlType Type;
    local string FullName, parentName;
    local WindowHandle hParent;

    // End:0x11
    if(hWnd == none)
    {
        return FullName;
    }
    FullName = hWnd.GetWindowName();
    hParent = hWnd.GetParentWindowHandle();
    J0x3B:

    // End:0xEE [Loop If]
    if(hParent != none)
    {
        parentName = hParent.GetWindowName();
        // End:0x8B
        if((parentName == "Console") || parentName == "Worksheet")
        {
            return FullName;
        }
        Type = hParent.GetControlType();
        // End:0xD6
        if((int(Type) != int(0)) && Len(parentName) > 0)
        {
            FullName = (parentName $ ".") $ FullName;
        }
        hParent = hParent.GetParentWindowHandle();
        // [Loop Continue]
        goto J0x3B;
    }
    return FullName;
    return;
}

function OnOrderClick(string Name)
{
    local WindowHandle TrackerWnd;

    TrackerWnd = GetTrackerAttachedWindow();
    // End:0x19
    if(TrackerWnd == none)
    {
        return;
    }
    switch(Name)
    {
        // End:0x3E
        case "btnUp":
            TrackerWnd.ChangeControlOrder(2);
            // End:0x61
            break;
        // End:0x5E
        case "btnDown":
            TrackerWnd.ChangeControlOrder(3);
            // End:0x61
            break;
        // End:0xFFFF
        default:
            break;
    }
    RefreshControlList();
    return;
}
