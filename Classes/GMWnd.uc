class GMWnd extends UICommonAPI;

const DIALOGID_Recall = 0;
const DIALOGID_SendHome = 1;

var Color m_WhiteColor;
var EditBoxHandle m_hEditBox;
var WindowHandle m_hGMwnd;
var WindowHandle m_hGMDetailStatusWnd;
var WindowHandle m_hGMInventoryWnd;
var WindowHandle m_hGMMagicSkillWnd;
var WindowHandle m_hGMQuestWnd;
var WindowHandle m_hGMWarehouseWnd;
var WindowHandle m_hGMClanWnd;
var WindowHandle m_hGMFindTreeWnd;
var int m_targetID;
var WindowHandle m_dialogWnd;
var ComboBoxHandle m_hCbClassName;
var string m_WindowName;

function OnRegisterEvent()
{
    RegisterEvent(2280);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(980);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    InitHandle();
    m_WhiteColor.R = 220;
    m_WhiteColor.G = 220;
    m_WhiteColor.B = 220;
    m_WhiteColor.A = byte(255);
    m_targetID = 0;
    m_hOwnerWnd.SetWindowTitle("BOHPTS");
    return;
}

function SetClassTypeComboBox()
{
    local int classNameSysString, i;
    local array<int> EnableClassIndexList;
    local int Len, classIndex;
    local UserInfo targetInfo;
    local int myClassIndex;

    m_hCbClassName.Clear();
    GetTargetInfo(targetInfo);
    // End:0x2A
    if(targetInfo.bNpc)
    {
        return;
    }
    Class'NWindow.UIDataManager'.static.GetEnableClassIndexList(targetInfo.Class, EnableClassIndexList);
    Len = EnableClassIndexList.Length;
    i = 0;
    J0x5B:

    // End:0xD7 [Loop If]
    if(i < Len)
    {
        classIndex = EnableClassIndexList[i];
        classNameSysString = Class'NWindow.UIDataManager'.static.GetClassnameSysstringIndexByClassIndex(classIndex);
        m_hCbClassName.SYS_AddStringWithReserved(classNameSysString, classIndex);
        // End:0xCD
        if(targetInfo.Class == classIndex)
        {
            myClassIndex = i;
        }
        ++i;
        // [Loop Continue]
        goto J0x5B;
    }
    m_hCbClassName.SetSelectedNum(myClassIndex);
    return;
}

function InitHandle()
{
    m_hGMwnd = GetWindowHandle(m_WindowName);
    m_hEditBox = GetEditBoxHandle("GMWnd.EditBox");
    m_hGMDetailStatusWnd = GetWindowHandle("GMDetailStatusWnd");
    m_hGMInventoryWnd = GetWindowHandle("GMInventoryWnd");
    m_hGMMagicSkillWnd = GetWindowHandle("GMMagicSkillWnd");
    m_hGMQuestWnd = GetWindowHandle("GMQuestWnd");
    m_hGMWarehouseWnd = GetWindowHandle("GMWarehouseWnd");
    m_hGMClanWnd = GetWindowHandle("GMClanWnd");
    m_hGMFindTreeWnd = GetWindowHandle("GMFindTreeWnd");
    m_dialogWnd = GetWindowHandle("DialogBox");
    m_hCbClassName = GetComboBoxHandle(m_WindowName $ ".cbClassName");
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x18
        case 2280:
            HandleShowGMWnd();
            // End:0x51
            break;
        // End:0x29
        case 1710:
            HandleDialogOK();
            // End:0x51
            break;
        // End:0x3A
        case 1720:
            HandleDialogCancel();
            // End:0x51
            break;
        // End:0x4B
        case 980:
            HandleTargetUpdate();
            // End:0x51
            break;
        // End:0xFFFF
        default:
            // End:0x51
            break;
            break;
    }
    return;
}

function HandleShowGMWnd()
{
    // End:0x24
    if(m_hOwnerWnd.IsShowWindow())
    {
        m_hOwnerWnd.HideWindow();        
    }
    else
    {
        m_hOwnerWnd.ShowWindow();
        m_hGMwnd.SetFocus();
    }
    return;
}

function OnShow()
{
    // End:0x1A
    if(!IsBuilderPC())
    {
        m_hOwnerWnd.HideWindow();
    }
    SetClassTypeComboBox();
    checkVisibleLockButton();
    return;
}

function HandleDialogOK()
{
    // End:0x0D
    if(!DialogIsMine())
    {
        return;
    }
    switch(DialogGetID())
    {
        // End:0x22
        case 0:
            Recall();
            // End:0x35
            break;
        // End:0x2F
        case 1:
            SendHome();
            // End:0x35
            break;
        // End:0xFFFF
        default:
            // End:0x35
            break;
            break;
    }
    return;
}

function HandleTargetUpdate()
{
    local int m_nowTargetID;
    local UserInfo Info;

    m_nowTargetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
    // End:0x26
    if(m_nowTargetID == m_targetID)
    {
        return;
    }
    // End:0x5D
    if(m_nowTargetID < 1)
    {
        m_targetID = 0;
        // End:0x5B
        if(m_hEditBox.IsEnableWindow())
        {
            m_hEditBox.SetString("");
        }
        return;
    }
    GetTargetInfo(Info);
    // End:0xB1
    if((m_nowTargetID > 0) && Info.bNpc == false)
    {
        // End:0xB1
        if(m_hEditBox.IsEnableWindow())
        {
            m_hEditBox.SetString(Info.Name);
        }
    }
    m_targetID = m_nowTargetID;
    SetClassTypeComboBox();
    return;
}

function HandleDialogCancel()
{
    // End:0x0D
    if(!DialogIsMine())
    {
        return;
    }
    return;
}

function OnClickButton(string a_ButtonID)
{
    switch(a_ButtonID)
    {
        // End:0x44
        case "TicketBtn":
            // End:0x41
            if(IsBuilderPC())
            {
                PlayerPort(GetScript("PlayerPort")).requestUpdate(21);
            }
            // End:0x3C3
            break;
        // End:0x5B
        case "TargetBtn":
            OnClickTargetButton();
            // End:0x3C3
            break;
        // End:0x73
        case "TeleButton":
            OnClickTeleButton();
            // End:0x3C3
            break;
        // End:0x8B
        case "MoveButton":
            OnClickMoveButton();
            // End:0x3C3
            break;
        // End:0xA8
        case "CoordMoveButton":
            OnClickCoordMoveButton();
            // End:0x3C3
            break;
        // End:0xC5
        case "CoordCopyButton":
            OnClickCoordCopyButton();
            // End:0x3C3
            break;
        // End:0xDF
        case "RecallButton":
            OnClickRecallButton();
            // End:0x3C3
            break;
        // End:0xFF
        case "DetailStatusButton":
            OnClickDetailStatusButton();
            // End:0x3C3
            break;
        // End:0x11C
        case "InventoryButton":
            OnClickInventoryButton();
            // End:0x3C3
            break;
        // End:0x13A
        case "MagicSkillButton":
            OnClickMagicSkillButton();
            // End:0x3C3
            break;
        // End:0x153
        case "QuestButton":
            OnClickQuestButton();
            // End:0x3C3
            break;
        // End:0x16B
        case "InfoButton":
            OnClickInfoButton();
            // End:0x3C3
            break;
        // End:0x184
        case "StoreButton":
            OnClickStoreButton();
            // End:0x3C3
            break;
        // End:0x1A1
        case "ClanStoreButton":
            OnClickClanStoreButton();
            // End:0x3C3
            break;
        // End:0x1B9
        case "ClanButton":
            OnClickClanButton();
            // End:0x3C3
            break;
        // End:0x1D5
        case "PetitionButton":
            OnClickPetitionButton();
            // End:0x3C3
            break;
        // End:0x1F1
        case "SendHomeButton":
            OnClickSendHomeButton();
            // End:0x3C3
            break;
        // End:0x20C
        case "NPCListButton":
            OnClickNPCListButton();
            // End:0x3C3
            break;
        // End:0x228
        case "ItemListButton":
            OnClickItemListButton();
            // End:0x3C3
            break;
        // End:0x245
        case "SkillListButton":
            OnClickSkillListButton();
            // End:0x3C3
            break;
        // End:0x266
        case "ForcePetitionButton":
            OnClickForcePetitionButton();
            // End:0x3C3
            break;
        // End:0x286
        case "ChangeServerButton":
            OnClickChangeServerButton();
            // End:0x3C3
            break;
        // End:0x2A2
        case "btnClassChange":
            OnClickBtnClassChange();
            // End:0x3C3
            break;
        // End:0x2B8
        case "UIButton":
            OnClickUIButton();
            // End:0x3C3
            break;
        // End:0x2D7
        case "btnBuilderCommand":
            onClickBuilderCmdBtn();
            // End:0x3C3
            break;
        // End:0x2F4
        case "QuestListButton":
            OnClickQuestListButton();
            // End:0x3C3
            break;
        // End:0x312
        case "TargettingButton":
            OnClickTargetButton();
            // End:0x3C3
            break;
        // End:0x331
        case "ClassChangeButton":
            OnClickClassChangeButton();
            // End:0x3C3
            break;
        // End:0x33D
        case "LockBtn":
        // End:0x354
        case "UnLockBtn":
            OnClickLockButton();
            // End:0x3C3
            break;
        // End:0x387
        case "questSearchToolButton":
            LoadWindowClick("UIQuestToolWnd");
            // End:0x3C3
            break;
        // End:0x3A4
        case "TargetCoordBtn":
            getCoordinatesToClipboard(true);
            // End:0x3C3
            break;
        // End:0x3BD
        case "MyCoordBtn":
            getCoordinatesToClipboard(false);
            // End:0x3C3
            break;
        // End:0xFFFF
        default:
            // End:0x3C3
            break;
            break;
    }
    return;
}

function getCoordinatesToClipboard(bool bTarget)
{
    local UserInfo Player;

    // End:0x17
    if(bTarget)
    {
        GetTargetInfo(Player);        
    }
    else
    {
        GetPlayerInfo(Player);
    }
    // End:0x110
    if(Player.nID > 0)
    {
        ClipboardCopy((string(int(Player.loc.X)) @ string(int(Player.loc.Y))) @ string(int(Player.loc.Z)));
        getInstanceL2Util().showGfxScreenMessage((("Copied coord. for target=" $ string(bTarget)) @ "Name:") @ Player.Name);
        getInstanceL2Util().showGfxScreenMessage((("" $ string(int(Player.loc.X))) @ string(int(Player.loc.Y))) @ string(int(Player.loc.Z)));
    }
    return;
}

function onClickBuilderCmdBtn()
{
    local WindowHandle BuilderCmdWnd;

    BuilderCmdWnd = GetWindowHandle("BuilderCmdWnd");
    BuilderCmdWnd.ShowWindow();
    BuilderCmdWnd.SetFocus();
    return;
}

function LoadWindowClick(string WindowName)
{
    local WindowHandle NewWindow;

    NewWindow = GetWindowHandle(WindowName);
    NewWindow.ShowWindow();
    NewWindow.SetFocus();
    return;
}

function OnClickLockButton()
{
    // End:0x24
    if(m_hEditBox.IsEnableWindow())
    {
        m_hEditBox.DisableWindow();        
    }
    else
    {
        m_hEditBox.EnableWindow();
    }
    checkVisibleLockButton();
    return;
}

function checkVisibleLockButton()
{
    // End:0x55
    if(m_hEditBox.IsEnableWindow())
    {
        GetButtonHandle("GMWnd.UnlockBtn").ShowWindow();
        GetButtonHandle("GMWnd.LockBtn").HideWindow();        
    }
    else
    {
        GetButtonHandle("GMWnd.UnlockBtn").HideWindow();
        GetButtonHandle("GMWnd.LockBtn").ShowWindow();
    }
    return;
}

function OnClickTargetButton()
{
    local string EditBoxString;

    EditBoxString = m_hEditBox.GetString();
    // End:0x37
    if(EditBoxString != "")
    {
        ExecuteCommand("/target" @ EditBoxString);
    }
    return;
}

function OnClickClassChangeButton()
{
    local string EditBoxString;
    local GMFindTreeWnd m_GMFindTreeWnd;

    EditBoxString = m_hEditBox.GetString();
    m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
    m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.4);
    return;
}

function OnClickFindListButton()
{
    local string EditBoxString;
    local GMFindTreeWnd m_GMFindTreeWnd;

    EditBoxString = m_hEditBox.GetString();
    m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
    m_GMFindTreeWnd = GMFindTreeWnd(GetScript("GMFindTreeWnd"));
    m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.0);
    return;
}

function OnClickBtnClassChange()
{
    local int selected, classIndex;

    selected = m_hCbClassName.GetSelectedNum();
    classIndex = m_hCbClassName.GetReserved(selected);
    // End:0x56
    if(classIndex >= 0)
    {
        ExecuteCommand("//setclass " @ string(classIndex));
    }
    return;
}

function OnClickTeleButton()
{
    local string EditBoxString;

    EditBoxString = m_hEditBox.GetString();
    // End:0x3C
    if(EditBoxString != "")
    {
        ExecuteCommand("//teleportto" @ EditBoxString);
    }
    return;
}

function OnClickMoveButton()
{
    ExecuteCommand("//instant_move");
    return;
}

function OnClickCoordMoveButton()
{
    local string EditBoxString;
    local array<string> EditBoxStringArr;
    local Vector loc;

    EditBoxString = m_hEditBox.GetString();
    // End:0xD5
    if(EditBoxString != "")
    {
        EditBoxStringArr = Arr(EditBoxString, " ");
        // End:0x88
        if(EditBoxStringArr.Length == 3)
        {
            loc.X = float(int(EditBoxStringArr[0]));
            loc.Y = float(int(EditBoxStringArr[1]));
            loc.Z = float(int(EditBoxStringArr[2]));            
        }
        else
        {
            loc = getHuntingCoord(EditBoxString);
        }
        ExecuteCommand((("//teleport" @ string(loc.X)) @ string(loc.Y)) @ string(loc.Z));
    }
    return;
}

function OnClickCoordCopyButton()
{
    local string EditBoxString;
    local array<string> EditBoxStringArr;
    local Vector loc;

    EditBoxString = m_hEditBox.GetString();
    // End:0x8F
    if(EditBoxString != "")
    {
        ClipboardCopy(EditBoxString);
        getInstanceL2Util().showGfxScreenMessage("Input value:");
        getInstanceL2Util().showGfxScreenMessage(("[" $ EditBoxString) $ "]");
        getInstanceL2Util().showGfxScreenMessage("successfully copied!");
    }
    return;
}

function OnClickRecallButton()
{
    DialogSetID(0);
    DialogShow(1, 0, GetSystemMessage(1220), string(self));
    return;
}

function Recall()
{
    local string EditBoxString;

    EditBoxString = m_hEditBox.GetString();
    // End:0x38
    if(EditBoxString != "")
    {
        ExecuteCommand("//recall" @ EditBoxString);
    }
    return;
}

function OnClickDetailStatusButton()
{
    local string EditBoxString;
    local GMDetailStatusWnd GMDetailStatusWndScript;

    EditBoxString = m_hEditBox.GetString();
    // End:0x52
    if(EditBoxString != "")
    {
        GMDetailStatusWndScript = GMDetailStatusWnd(m_hGMDetailStatusWnd.GetScript());
        GMDetailStatusWndScript.ShowStatus(EditBoxString);        
    }
    else
    {
        AddSystemMessage(364);
    }
    return;
}

function OnClickInventoryButton()
{
    local string EditBoxString;
    local GMInventoryWnd GMInventoryWndScript;

    EditBoxString = m_hEditBox.GetString();
    // End:0x52
    if(EditBoxString != "")
    {
        GMInventoryWndScript = GMInventoryWnd(m_hGMInventoryWnd.GetScript());
        GMInventoryWndScript.ShowInventory(EditBoxString);        
    }
    else
    {
        AddSystemMessage(364);
    }
    return;
}

function OnClickMagicSkillButton()
{
    local string EditBoxString;
    local GMMagicSkillWnd GMMagicSkillWndScript;

    EditBoxString = m_hEditBox.GetString();
    GMMagicSkillWndScript = GMMagicSkillWnd(m_hGMMagicSkillWnd.GetScript());
    GMMagicSkillWndScript.ShowMagicSkill(EditBoxString);
    return;
}

function OnClickQuestButton()
{
    local string EditBoxString;
    local GMQuestWnd GMQuestWndScript;

    EditBoxString = m_hEditBox.GetString();
    GMQuestWndScript = GMQuestWnd(m_hGMQuestWnd.GetScript());
    GMQuestWndScript.ShowQuest(EditBoxString);
    return;
}

function OnClickInfoButton()
{
    local string EditBoxString;

    EditBoxString = m_hEditBox.GetString();
    // End:0x37
    if(EditBoxString != "")
    {
        ExecuteCommand("//debug" @ EditBoxString);
    }
    return;
}

function OnClickStoreButton()
{
    local string EditBoxString;
    local GMWarehouseWnd GMWarehouseWndScript;

    EditBoxString = m_hEditBox.GetString();
    // End:0x54
    if(EditBoxString != "")
    {
        GMWarehouseWndScript = GMWarehouseWnd(m_hGMWarehouseWnd.GetScript());
        GMWarehouseWndScript.ShowWarehouse(6, EditBoxString);        
    }
    else
    {
        AddSystemMessage(364);
    }
    return;
}

function OnClickClanStoreButton()
{
    local string EditBoxString;
    local GMWarehouseWnd GMWarehouseWndScript;

    EditBoxString = m_hEditBox.GetString();
    // End:0x54
    if(EditBoxString != "")
    {
        GMWarehouseWndScript = GMWarehouseWnd(m_hGMWarehouseWnd.GetScript());
        GMWarehouseWndScript.ShowWarehouse(7, EditBoxString);        
    }
    else
    {
        AddSystemMessage(364);
    }
    return;
}

function OnClickClanButton()
{
    local string EditBoxString;
    local GMClanWnd GMClanWndScript;

    EditBoxString = m_hEditBox.GetString();
    GMClanWndScript = GMClanWnd(m_hGMClanWnd.GetScript());
    GMClanWndScript.ShowClan(EditBoxString);
    return;
}

function OnClickPetitionButton()
{
    local string EditBoxString;

    EditBoxString = m_hEditBox.GetString();
    // End:0x3F
    if(EditBoxString != "")
    {
        ExecuteCommand("//add_peti_chat" @ EditBoxString);
    }
    return;
}

function OnClickSendHomeButton()
{
    DialogSetID(1);
    DialogShow(1, 0, GetSystemMessage(1221), string(self));
    return;
}

function SendHome()
{
    local string EditBoxString;

    EditBoxString = m_hEditBox.GetString();
    // End:0x3A
    if(EditBoxString != "")
    {
        ExecuteCommand("//sendhome" @ EditBoxString);
    }
    return;
}

function OnClickNPCListButton()
{
    local string EditBoxString;
    local GMFindTreeWnd m_GMFindTreeWnd;

    EditBoxString = m_hEditBox.GetString();
    m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
    m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.1);
    return;
}

function OnClickItemListButton()
{
    local string EditBoxString;
    local GMFindTreeWnd m_GMFindTreeWnd;

    EditBoxString = m_hEditBox.GetString();
    m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
    m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.0);
    return;
}

function OnClickSkillListButton()
{
    local string EditBoxString;
    local GMFindTreeWnd m_GMFindTreeWnd;

    EditBoxString = m_hEditBox.GetString();
    m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
    m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.3);
    return;
}

function OnClickForcePetitionButton()
{
    local string EditBoxString;

    EditBoxString = m_hEditBox.GetString();
    // End:0x49
    if(EditBoxString != "")
    {
        ExecuteCommand(("//force_peti" @ EditBoxString) @ GetSystemMessage(1528));
    }
    return;
}

function OnClickChangeServerButton()
{
    local string EditBoxString;
    local UserInfo PlayerInfo;

    EditBoxString = m_hEditBox.GetString();
    // End:0x23
    if(EditBoxString == "")
    {
        return;
    }
    // End:0x35
    if(!GetPlayerInfo(PlayerInfo))
    {
        return;
    }
    Class'NWindow.GMAPI'.static.BeginGMChangeServer(int(EditBoxString), PlayerInfo.loc);
    return;
}

function OnClickUIButton()
{
    local WindowHandle UIToolWnd;

    UIToolWnd = GetWindowHandle("UIToolWnd");
    UIToolWnd.ShowWindow();
    UIToolWnd.SetFocus();
    return;
}

function OnClickQuestListButton()
{
    local string EditBoxString;
    local GMFindTreeWnd m_GMFindTreeWnd;

    EditBoxString = m_hEditBox.GetString();
    m_GMFindTreeWnd = GMFindTreeWnd(m_hGMFindTreeWnd.GetScript());
    m_GMFindTreeWnd.ShowList(EditBoxString, m_GMFindTreeWnd.2);
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
    m_WindowName="GMWnd"
}