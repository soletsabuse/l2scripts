class HennaListWnd extends UICommonAPI;

const FEE_OFFSET_Y_EQUIP = -23;
const FEE_OFFSET_Y_UNEQUIP = -21;
const HENNA_EQUIP = 1;
const HENNA_UNEQUIP = 2;

var int m_iState;
var int m_iRootNameLength;
var bool m_bDrawBg;

function OnRegisterEvent()
{
    RegisterEvent(1640);
    RegisterEvent(1650);
    RegisterEvent(1670);
    RegisterEvent(1680);
    RegisterEvent(1671);
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
    m_bDrawBg = true;
    return;
}

function OnClickButton(string strID)
{
    local string strHennaID;

    switch(strID)
    {
        // End:0xFFFF
        default:
            strHennaID = Mid(strID, m_iRootNameLength + 1);
            // End:0x3A
            if(m_iState == 1)
            {
                RequestHennaItemInfo(int(strHennaID));                
            }
            else
            {
                // End:0x53
                if(m_iState == 2)
                {
                    RequestHennaUnEquipInfo(int(strHennaID));
                }
            }
            // End:0x56
            break;
            break;
    }
    return;
}

function Clear()
{
    Class'NWindow.UIAPI_TREECTRL'.static.Clear("HennaListWnd.HennaListTree");
    return;
}

function OnEvent(int Event_ID, string param)
{
    local INT64 iAdena;
    local string strName, strIconName, strDescription;
    local int iHennaID, iClassID;
    local INT64 iNum, iFee;

    switch(Event_ID)
    {
        // End:0x41
        case 1640:
            m_iState = 1;
            Clear();
            ParseINT64(param, "Adena", iAdena);
            ShowHennaListWnd(iAdena);
            // End:0x171
            break;
        // End:0x49
        case 1650:
        // End:0x122
        case 1680:
            ParseString(param, "Name", strName);
            ParseString(param, "Description", strDescription);
            ParseString(param, "IconName", strIconName);
            ParseInt(param, "HennaID", iHennaID);
            ParseInt(param, "ClassID", iClassID);
            ParseINT64(param, "NumOfItem", iNum);
            ParseINT64(param, "Fee", iFee);
            AddHennaListItem(strName, strIconName, strDescription, iFee, iHennaID);
            // End:0x171
            break;
        // End:0x15D
        case 1670:
            m_iState = 2;
            Clear();
            ParseINT64(param, "Adena", iAdena);
            ShowHennaListWnd(iAdena);
            // End:0x171
            break;
        // End:0x16E
        case 1671:
            OnReceivedCloseUI();
            // End:0x171
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ShowHennaListWnd(INT64 iAdena)
{
    local XMLTreeNodeInfo infNode;
    local string strTmp;

    // End:0x66
    if(m_iState == 1)
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("HennaListWnd", GetSystemString(651));
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaListWnd.txtList", GetSystemString(659));        
    }
    else
    {
        // End:0xCA
        if(m_iState == 2)
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("HennaListWnd", GetSystemString(652));
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaListWnd.txtList", GetSystemString(660));
        }
    }
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("HennaListWnd.txtAdena", MakeCostString((iAdena)));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("HennaListWnd.txtAdena", ConvertNumToText((iAdena)));
    infNode.strName = "HennaListRoot";
    infNode.nOffSetX = 0;
    infNode.nOffSetY = -3;
    strTmp = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("HennaListWnd.HennaListTree", "", infNode);
    // End:0x1AD
    if(Len(strTmp) < 1)
    {
        return;
    }
    m_iRootNameLength = Len(infNode.strName);
    ShowWindow("HennaListWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("HennaListWnd");
    return;
}

function AddHennaListItem(string strName, string strIconName, string strDescription, INT64 iFee, int iHennaID)
{
    local XMLTreeNodeInfo infNode;
    local XMLTreeNodeItemInfo infNodeItem;
    local XMLTreeNodeInfo infNodeClear;
    local XMLTreeNodeItemInfo infNodeItemClear;
    local string strRetName, strAdenaComma;

    infNode = infNodeClear;
    infNode.strName = "" $ string(iHennaID);
    infNode.bShowButton = 0;
    infNode.nTexExpandedOffSetX = -7;
    infNode.nTexExpandedOffSetY = 8;
    infNode.nTexExpandedHeight = 46;
    infNode.nTexExpandedRightWidth = 0;
    infNode.nTexExpandedLeftUWidth = 32;
    infNode.nTexExpandedLeftUHeight = 40;
    infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
    strRetName = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("HennaListWnd.HennaListTree", "HennaListRoot", infNode);
    // End:0xF6
    if(Len(strRetName) < 1)
    {
        return;
    }
    // End:0x1C2
    if(m_bDrawBg == true)
    {
        infNodeItem = infNodeItemClear;
        infNodeItem.eType = 2;
        infNodeItem.nOffSetX = 0;
        infNodeItem.nOffSetY = 0;
        infNodeItem.u_nTextureUHeight = 14;
        infNodeItem.u_nTextureWidth = 333;
        infNodeItem.u_nTextureHeight = 53;
        infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
        Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
        m_bDrawBg = false;        
    }
    else
    {
        infNodeItem = infNodeItemClear;
        infNodeItem.eType = 2;
        infNodeItem.nOffSetX = 0;
        infNodeItem.nOffSetY = 0;
        infNodeItem.u_nTextureWidth = 333;
        infNodeItem.u_nTextureHeight = 53;
        infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
        Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
        m_bDrawBg = true;
    }
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 2;
    infNodeItem.nOffSetX = -333;
    infNodeItem.nOffSetY = 10;
    infNodeItem.u_nTextureWidth = 36;
    infNodeItem.u_nTextureHeight = 36;
    infNodeItem.u_strTexture = "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2";
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 2;
    infNodeItem.nOffSetX = -34;
    infNodeItem.nOffSetY = 11;
    infNodeItem.u_nTextureWidth = 32;
    infNodeItem.u_nTextureHeight = 32;
    infNodeItem.u_strTexture = strIconName;
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = strName;
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 5;
    // End:0x419
    if(m_iState == 1)
    {
        infNodeItem.nOffSetY = 13;        
    }
    else
    {
        // End:0x432
        if(m_iState == 2)
        {
            infNodeItem.nOffSetY = 6;
        }
    }
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
    // End:0x507
    if(m_iState == 2)
    {
        infNodeItem = infNodeItemClear;
        infNodeItem.eType = 1;
        infNodeItem.t_strText = strDescription;
        infNodeItem.bLineBreak = true;
        infNodeItem.t_bDrawOneLine = true;
        infNodeItem.nOffSetX = 47;
        infNodeItem.nOffSetY = -34;
        Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
    }
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = GetSystemString(637) $ " : ";
    infNodeItem.bLineBreak = true;
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 46;
    // End:0x581
    if(m_iState == 1)
    {
        infNodeItem.nOffSetY = -23;        
    }
    else
    {
        // End:0x59D
        if(m_iState == 2)
        {
            infNodeItem.nOffSetY = -21;
        }
    }
    infNodeItem.t_color.R = 168;
    infNodeItem.t_color.G = 168;
    infNodeItem.t_color.B = 168;
    infNodeItem.t_color.A = byte(255);
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
    strAdenaComma = MakeCostString((iFee));
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = strAdenaComma;
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 0;
    // End:0x68E
    if(m_iState == 1)
    {
        infNodeItem.nOffSetY = -23;        
    }
    else
    {
        // End:0x6AA
        if(m_iState == 2)
        {
            infNodeItem.nOffSetY = -21;
        }
    }
    infNodeItem.t_color = GetNumericColor(strAdenaComma);
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = GetSystemString(469);
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 5;
    // End:0x75B
    if(m_iState == 1)
    {
        infNodeItem.nOffSetY = -23;        
    }
    else
    {
        // End:0x777
        if(m_iState == 2)
        {
            infNodeItem.nOffSetY = -21;
        }
    }
    infNodeItem.t_color.R = byte(255);
    infNodeItem.t_color.G = byte(255);
    infNodeItem.t_color.B = 0;
    infNodeItem.t_color.A = byte(255);
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("HennaListWnd.HennaListTree", strRetName, infNodeItem);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("HennaListWnd").HideWindow();
    return;
}
