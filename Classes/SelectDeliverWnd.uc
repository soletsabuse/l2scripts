class SelectDeliverWnd extends UICommonAPI;

function OnRegisterEvent()
{
    RegisterEvent(2140);
    RegisterEvent(2150);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x7F
        case 2140:
            Class'NWindow.UIAPI_COMBOBOX'.static.Clear("SelectDeliverWnd.SelectDeliverCombo");
            ShowWindow("SelectDeliverWnd");
            Class'NWindow.UIAPI_WINDOW'.static.SetFocus("SelectDeliverWnd");
            // End:0x9B
            break;
        // End:0x95
        case 2150:
            HandleAddName(param);
            // End:0x9B
            break;
        // End:0xFFFF
        default:
            // End:0x9B
            break;
            break;
    }
    return;
}

function HandleAddName(string param)
{
    local string Name;
    local int Id;

    ParseString(param, "name", Name);
    ParseInt(param, "id", Id);
    Class'NWindow.UIAPI_COMBOBOX'.static.AddStringWithReserved("SelectDeliverWnd.SelectDeliverCombo", Name, Id);
    return;
}

function OnClickButton(string ControlName)
{
    // End:0x1D
    if(ControlName == "OKButton")
    {
        HandleOKButtonClick();        
    }
    else
    {
        // End:0x4D
        if(ControlName == "CancelButton")
        {
            HideWindow("SelectDeliverWnd");
        }
    }
    return;
}

function HandleOKButtonClick()
{
    local int selected, reservedID;

    selected = Class'NWindow.UIAPI_COMBOBOX'.static.GetSelectedNum("SelectDeliverWnd.SelectDeliverCombo");
    // End:0x8F
    if(selected >= 0)
    {
        reservedID = Class'NWindow.UIAPI_COMBOBOX'.static.GetReserved("SelectDeliverWnd.SelectDeliverCombo", selected);
        RequestPackageSendableItemList(reservedID);
    }
    HideWindow("SelectDeliverWnd");
    return;
}
