class ActionWnd extends UICommonAPI;

enum NextTargetType
{
    NTT_GENERAL,                    // 0
    NTT_PLAYERS,                    // 1
    NTT_NPC                         // 2
};

var bool m_bShow;
var ComboBoxHandle NextTargetOptionsComboBox;

function OnRegisterEvent()
{
    RegisterEvent(1311);
    RegisterEvent(1300);
    RegisterEvent(1310);
    RegisterEvent(1900);
    RegisterEvent(8000);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    m_bShow = false;
    HideScrollBar();
    NextTargetOptionsComboBox = GetComboBoxHandle("ActionWnd.NextTargetOptionsComboBox");
    NextTargetOptionsComboBox.SetSelectedNum(GetOptionInt("Game", "NextTargetType"));
    NextTargetOptionsComboBox.HideWindow();
    return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
    switch(strID)
    {
        // End:0xA3
        case "NextTargetOptionsComboBox":
            RequestBypassToServer("nto " $ string(IndexID));
            getInstanceL2Util().showGfxScreenMessage(((GetSystemString(7658) @ "'") $ NextTargetOptionsComboBox.GetString(NextTargetOptionsComboBox.GetSelectedNum())) $ "'");
            SetOptionInt("Game", "NextTargetType", IndexID);
            // End:0xA9
            break;
        // End:0xFFFF
        default:
            // End:0xA9
            break;
            break;
    }
    return;
}

function OnShow()
{
    Class'NWindow.ActionAPI'.static.RequestActionList();
    m_bShow = true;
    return;
}

function OnHide()
{
    m_bShow = false;
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x18
    if(Event_ID == 1300)
    {
        HandleActionListStart();        
    }
    else
    {
        // End:0x35
        if(Event_ID == 1310)
        {
            HandleActionList(param);            
        }
        else
        {
            // End:0x4D
            if(Event_ID == 1900)
            {
                HandleLanguageChanged();                
            }
            else
            {
                // End:0x65
                if(Event_ID == 1311)
                {
                    HandleActionListNew();                    
                }
                else
                {
                    // End:0x74
                    if(Event_ID == 8000)
                    {
                    }
                }
            }
        }
    }
    return;
}

function checkClassicForm()
{
    local WindowHandle Me;
    local TextBoxHandle txtMark;
    local TextureHandle SlotMark_01, SlotMark_02;
    local ItemWindowHandle ActionMarkItem;
    local TextBoxHandle txtSocial;
    local TextureHandle SlotSocial_01, SlotSocial_02;
    local ItemWindowHandle ActionSocialItem;

    Me = GetWindowHandle("ActionWnd");
    txtSocial = GetTextBoxHandle("ActionWnd.txtSocial");
    SlotSocial_01 = GetTextureHandle("ActionWnd.SlotSocial_01");
    SlotSocial_02 = GetTextureHandle("ActionWnd.SlotSocial_02");
    ActionSocialItem = GetItemWindowHandle("ActionWnd.ActionSocialItem");
    txtMark = GetTextBoxHandle("ActionWnd.txtMark");
    SlotMark_01 = GetTextureHandle("ActionWnd.SlotMark_01");
    SlotMark_02 = GetTextureHandle("ActionWnd.SlotMark_01");
    ActionMarkItem = GetItemWindowHandle("ActionWnd.ActionMarkItem");
    // End:0x275
    if(false && getInstanceUIData().getIsClassicServer())
    {
        SlotMark_01.HideWindow();
        SlotMark_02.HideWindow();
        txtMark.HideWindow();
        ActionMarkItem.HideWindow();
        txtSocial.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 15, 298);
        SlotSocial_01.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 6, 314);
        SlotSocial_02.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 258, 314);
        ActionSocialItem.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 7, 314);
        Me.SetWindowSize(300, 430);        
    }
    else
    {
        SlotMark_01.ShowWindow();
        SlotMark_02.ShowWindow();
        txtMark.ShowWindow();
        ActionMarkItem.ShowWindow();
        txtSocial.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 15, 395);
        SlotSocial_01.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 6, 411);
        SlotSocial_02.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 258, 411);
        ActionSocialItem.SetAnchor("ActionWnd", "TopLeft", "TopLeft", 7, 411);
        Me.SetWindowSize(300, 527);
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo infItem;

    // End:0x9E
    if((strID == "ActionBasicItem") && Index > -1)
    {
        // End:0x67
        if(!Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionBasicItem", Index, infItem))
        {
            return;
        }
        Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem("ActionWnd.ActionBasicItem", Index, infItem);        
    }
    else
    {
        // End:0x108
        if((strID == "ActionPartyItem") && Index > -1)
        {
            // End:0x105
            if(!Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionPartyItem", Index, infItem))
            {
                return;
            }            
        }
        else
        {
            // End:0x170
            if((strID == "ActionMarkItem") && Index > -1)
            {
                // End:0x16D
                if(!Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionMarkItem", Index, infItem))
                {
                    return;
                }                
            }
            else
            {
                // End:0x1D9
                if((strID == "ActionSocialItem") && Index > -1)
                {
                    // End:0x1D9
                    if(!Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("ActionWnd.ActionSocialItem", Index, infItem))
                    {
                        return;
                    }
                }
            }
        }
    }
    // End:0x217
    if(infItem.Id.ClassID == 93)
    {
        ShowW("NPCBrokerWnd");
        RequestBypassToServer("getbroker");        
    }
    else
    {
        DoAction(infItem.Id);
    }
    return;
}

function HideScrollBar()
{
    Class'NWindow.UIAPI_ITEMWINDOW'.static.ShowScrollBar("ActionWnd.ActionBasicItem", false);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.ShowScrollBar("ActionWnd.ActionPartyItem", false);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.ShowScrollBar("ActionWnd.ActionMarkItem", false);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.ShowScrollBar("ActionWnd.ActionSocialItem", false);
    return;
}

function HandleLanguageChanged()
{
    Class'NWindow.ActionAPI'.static.RequestActionList();
    return;
}

function HandleActionListStart()
{
    Clear();
    return;
}

function Clear()
{
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("ActionWnd.ActionBasicItem");
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("ActionWnd.ActionPartyItem");
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("ActionWnd.ActionMarkItem");
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("ActionWnd.ActionSocialItem");
    return;
}

function string addBrokerAction()
{
    local string param;

    ParamAdd(param, "ClassID", string(93));
    ParamAdd(param, "ServerID", string(0));
    ParamAdd(param, "Type", string(1));
    ParamAdd(param, "Name", GetSystemString(7653));
    ParamAdd(param, "IconName", "UI_BOHPTS.Icons.actionBroker");
    ParamAdd(param, "IconNameEx1", "");
    ParamAdd(param, "Description", GetSystemString(7654));
    ParamAdd(param, "Command", "/itemfind");
    return param;
    return;
}

function string addCustomAction1()
{
    local string param;

    ParamAdd(param, "ClassID", string(1221));
    ParamAdd(param, "Type", string(2));
    ParamAdd(param, "Name", GetSystemString(7653));
    ParamAdd(param, "IconName", "UI_BOHPTS.Actions.party_control");
    ParamAdd(param, "IconNameEx1", "");
    ParamAdd(param, "Description", GetSystemString(7654));
    ParamAdd(param, "Command", "/itemfind");
    return param;
    return;
}

function string addCustomAction2()
{
    local string param;

    ParamAdd(param, "ClassID", string(1217));
    ParamAdd(param, "Type", string(2));
    ParamAdd(param, "Name", GetSystemString(7653));
    ParamAdd(param, "IconName", "UI_BOHPTS.Actions.leader_mark_blue");
    ParamAdd(param, "IconNameEx1", "");
    ParamAdd(param, "Description", GetSystemString(7654));
    ParamAdd(param, "Command", "/itemfind");
    return param;
    return;
}

function string addCustomAction3()
{
    local string param;

    ParamAdd(param, "ClassID", string(1218));
    ParamAdd(param, "Type", string(2));
    ParamAdd(param, "Name", GetSystemString(7653));
    ParamAdd(param, "IconName", "UI_BOHPTS.Actions.leader_mark_green");
    ParamAdd(param, "IconNameEx1", "");
    ParamAdd(param, "Description", GetSystemString(7654));
    ParamAdd(param, "Command", "/itemfind");
    return param;
    return;
}

function string addCustomAction4()
{
    local string param;

    ParamAdd(param, "ClassID", string(1219));
    ParamAdd(param, "Type", string(2));
    ParamAdd(param, "Name", GetSystemString(7653));
    ParamAdd(param, "IconName", "UI_BOHPTS.Actions.leader_mark_red");
    ParamAdd(param, "IconNameEx1", "");
    ParamAdd(param, "Description", GetSystemString(7654));
    ParamAdd(param, "Command", "/itemfind");
    return param;
    return;
}

function string addCustomAction5()
{
    local string param;

    ParamAdd(param, "ClassID", string(1220));
    ParamAdd(param, "Type", string(2));
    ParamAdd(param, "Name", GetSystemString(7653));
    ParamAdd(param, "IconName", "UI_BOHPTS.Actions.leader_mark_violet");
    ParamAdd(param, "IconNameEx1", "");
    ParamAdd(param, "Description", GetSystemString(7654));
    ParamAdd(param, "Command", "/itemfind");
    return param;
    return;
}

function HandleActionList(string param)
{
    local string wndname;
    local int tmp;
    local UIEventManager.EActionCategory Type;
    local string strActionName, strIconName, strIconNameEx1, strDescription, strCommand;

    local ItemInfo infItem;

    ParseItemID(param, infItem.Id);
    ParseInt(param, "Type", tmp);
    ParseString(param, "Name", strActionName);
    ParseString(param, "IconName", strIconName);
    ParseString(param, "IconNameEx1", strIconNameEx1);
    ParseString(param, "Description", strDescription);
    ParseString(param, "Command", strCommand);
    infItem.Name = strActionName;
    infItem.IconName = strIconName;
    infItem.IconNameEx1 = strIconNameEx1;
    infItem.Description = strDescription;
    infItem.ItemSubType = 3;
    infItem.MacroCommand = strCommand;
    Type = byte(tmp);
    // End:0x13F
    if(int(Type) == 1)
    {
        wndname = "ActionBasicItem";        
    }
    else
    {
        // End:0x167
        if(int(Type) == 2)
        {
            wndname = "ActionPartyItem";            
        }
        else
        {
            // End:0x18E
            if(int(Type) == 3)
            {
                wndname = "ActionMarkItem";                
            }
            else
            {
                // End:0x1B7
                if(int(Type) == 4)
                {
                    wndname = "ActionSocialItem";                    
                }
                else
                {
                    return;
                }
            }
        }
    }
    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("ActionWnd." $ wndname, infItem);
    return;
}

function HandleActionListNew()
{
    Class'NWindow.ActionAPI'.static.RequestActionList();
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("ActionWnd").HideWindow();
    return;
}
