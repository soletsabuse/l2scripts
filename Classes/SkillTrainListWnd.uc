class SkillTrainListWnd extends UICommonAPI;

const OFFSET_X_ICON_TEXTURE = 0;
const OFFSET_Y_ICON_TEXTURE = 4;
const OFFSET_Y_SECONDLINE = -17;

var int m_iType;
var int m_iState;
var int m_iRootNameLength;
var bool m_bDrawBg;
var WindowHandle m_SkillTrainListWnd;

function OnRegisterEvent()
{
    RegisterEvent(2010);
    RegisterEvent(2020);
    RegisterEvent(2030);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    m_SkillTrainListWnd = GetWindowHandle("SkillTrainListWnd.SkillTrainListTree");
    return;
}

function OnClickButton(string strItemID)
{
    local string strID_Level, strID, strLevel;
    local int iID, iLevel, iSubLevel, iIdxComma, iLength;

    iID = 0;
    iLevel = 0;
    iSubLevel = 0;
    strID_Level = Mid(strItemID, m_iRootNameLength + 1);
    iLength = Len(strID_Level);
    iIdxComma = InStr(strID_Level, ",");
    strID = Left(strID_Level, iIdxComma);
    strLevel = Right(strID_Level, (iLength - iIdxComma) - 1);
    iID = int(strID);
    iLevel = int(strLevel);
    // End:0xC1
    if((iID > 0) && iLevel > 0)
    {
        RequestAcquireSkillInfo(iID, iLevel, iSubLevel, m_iType);
    }
    HideWindow("SkillTrainListWnd");
    m_SkillTrainListWnd.SetScrollPosition(0);
    m_bDrawBg = true;
    return;
}

function Clear()
{
    Class'NWindow.UIAPI_TREECTRL'.static.Clear("SkillTrainListWnd.SkillTrainListTree");
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int iType;
    local string strIconName, strName;
    local int iID, iLevel, iSubLevel;
    local INT64 iSPConsume;
    local string strEnchantName;
    local int TotalCount;

    ParseInt(param, "Type", iType);
    // End:0x24
    if(iType == 140)
    {
        return;
    }
    switch(Event_ID)
    {
        // End:0xBC
        case 2010:
            Clear();
            m_iType = iType;
            ParseInt(param, "Count", TotalCount);
            // End:0xAE
            if(TotalCount == 0)
            {
                AddSystemMessageString(GetSystemMessage(750));
                // End:0xAC
                if(IsShowWindow("SkillTrainInfoWnd"))
                {
                    HideWindow("SkillTrainInfoWnd");
                }
                return;
            }
            ShowSkillTrainListWnd(iType);
            // End:0x1ED
            break;
        // End:0x1AA
        case 2030:
            ParseString(param, "strIconName", strIconName);
            ParseString(param, "strName", strName);
            ParseInt(param, "iID", iID);
            ParseInt(param, "iLevel", iLevel);
            ParseInt(param, "iSubLevel", iSubLevel);
            ParseINT64(param, "iSPConsume", iSPConsume);
            ParseString(param, "strEnchantName", strEnchantName);
            AddSkillTrainListItem(strIconName, strName, iID, iLevel, iSubLevel, iSPConsume, strEnchantName);
            // End:0x1ED
            break;
        // End:0x1EA
        case 2020:
            // End:0x1E7
            if(IsShowWindow("SkillTrainListWnd"))
            {
                HideWindow("SkillTrainListWnd");
            }
            // End:0x1ED
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnShow()
{
    ShowWindow("SkillTrainListWnd.txtSPString");
    ShowWindow("SkillTrainListWnd.txtSP");
    // End:0x79
    if(IsShowWindow("SkillTrainInfoWnd"))
    {
        HideWindow("SkillTrainInfoWnd");
    }
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("SkillTrainListWnd", "SkillTrainInfoWnd", "TopLeft", "TopLeft", 0, 0);
    return;
}

function ShowSkillTrainListWnd(int iType)
{
    local XMLTreeNodeInfo infNode;
    local string strTmp;
    local int iWindowTitle, iSPIdx;
    local UserInfo infoPlayer;
    local INT64 iPlayerSP;

    GetPlayerInfo(infoPlayer);
    switch(m_iType)
    {
        // End:0x17
        case 2:
        // End:0x4D
        case 3:
            iWindowTitle = 1436;
            iSPIdx = 1372;
            iPlayerSP = (GetClanNameValue(infoPlayer.nClanID));
            // End:0x76
            break;
        // End:0xFFFF
        default:
            iWindowTitle = 477;
            iSPIdx = 92;
            iPlayerSP = infoPlayer.nSP;
            // End:0x76
            break;
            break;
    }
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitle("SkillTrainListWnd", iWindowTitle);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainListWnd.txtSPString", GetSystemString(iSPIdx));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("SkillTrainListWnd.txtSP", (iPlayerSP));
    infNode.strName = "SkillTrainListRoot";
    infNode.nOffSetX = 7;
    infNode.nOffSetY = 0;
    strTmp = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("SkillTrainListWnd.SkillTrainListTree", "", infNode);
    // End:0x18E
    if(Len(strTmp) < 1)
    {
        return;
    }
    m_iRootNameLength = Len(infNode.strName);
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SkillTrainListWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("SkillTrainListWnd");
    return;
}

function AddSkillTrainListItem(string strIconName, string strName, int iID, int iLevel, int iSubLevel, INT64 iSPConsume, string strEnchantName)
{
    local XMLTreeNodeInfo infNode;
    local XMLTreeNodeItemInfo infNodeItem;
    local XMLTreeNodeInfo infNodeClear;
    local XMLTreeNodeItemInfo infNodeItemClear;
    local string strRetName;
    local SkillInfo SkillInfo;

    GetSkillInfo(iID, iLevel, iSubLevel, SkillInfo);
    infNode = infNodeClear;
    infNode.strName = (("" $ string(iID)) $ ",") $ string(iLevel);
    infNode.bShowButton = 0;
    infNode.nTexExpandedOffSetX = -7;
    infNode.nTexExpandedOffSetY = 0;
    infNode.nTexExpandedHeight = 38;
    infNode.nTexExpandedRightWidth = 0;
    infNode.nTexExpandedLeftUWidth = 32;
    infNode.nTexExpandedLeftUHeight = 38;
    infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
    strRetName = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("SkillTrainListWnd.SkillTrainListTree", "SkillTrainListRoot", infNode);
    // End:0x12C
    if(Len(strRetName) < 1)
    {
        return;
    }
    // End:0x202
    if(m_bDrawBg == true)
    {
        infNodeItem = infNodeItemClear;
        infNodeItem.eType = 2;
        infNodeItem.nOffSetX = 0;
        infNodeItem.nOffSetY = 0;
        infNodeItem.u_nTextureUHeight = 14;
        infNodeItem.u_nTextureWidth = 357;
        infNodeItem.u_nTextureHeight = 38;
        infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
        Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("SkillTrainListWnd.SkillTrainListTree", strRetName, infNodeItem);
        m_bDrawBg = false;        
    }
    else
    {
        infNodeItem = infNodeItemClear;
        infNodeItem.eType = 2;
        infNodeItem.nOffSetX = 0;
        infNodeItem.nOffSetY = 0;
        infNodeItem.u_nTextureWidth = 357;
        infNodeItem.u_nTextureHeight = 38;
        infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
        Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("SkillTrainListWnd.SkillTrainListTree", strRetName, infNodeItem);
        m_bDrawBg = true;
    }
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 2;
    infNodeItem.nOffSetX = -351;
    infNodeItem.nOffSetY = 2;
    infNodeItem.u_nTextureWidth = 36;
    infNodeItem.u_nTextureHeight = 36;
    infNodeItem.u_strTexture = "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2";
    InsertNodeItem(strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 2;
    infNodeItem.nOffSetX = -34;
    infNodeItem.nOffSetY = 4 - 1;
    infNodeItem.u_nTextureWidth = 32;
    infNodeItem.u_nTextureHeight = 32;
    infNodeItem.u_strTexture = strIconName;
    InsertNodeItem(strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 2;
    infNodeItem.nOffSetX = -32;
    infNodeItem.nOffSetY = 4 - 1;
    infNodeItem.u_nTextureWidth = 32;
    infNodeItem.u_nTextureHeight = 32;
    infNodeItem.u_strTexture = SkillInfo.IconPanel;
    InsertNodeItem(strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = strName;
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 5;
    infNodeItem.nOffSetY = 5;
    InsertNodeItem(strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = GetSystemString(88);
    infNodeItem.bLineBreak = true;
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 46;
    infNodeItem.nOffSetY = -17;
    infNodeItem.t_color.R = 163;
    infNodeItem.t_color.G = 163;
    infNodeItem.t_color.B = 163;
    infNodeItem.t_color.A = byte(255);
    InsertNodeItem(strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = string(iLevel);
    infNodeItem.nOffSetX = 2;
    infNodeItem.nOffSetY = -17;
    infNodeItem.t_color.R = 176;
    infNodeItem.t_color.G = 155;
    infNodeItem.t_color.B = 121;
    infNodeItem.t_color.A = byte(255);
    InsertNodeItem(strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    switch(m_iType)
    {
        // End:0x616
        case 2:
        // End:0x63B
        case 3:
            infNodeItem.t_strText = GetSystemString(1437) $ " : ";
            // End:0x65E
            break;
        // End:0xFFFF
        default:
            infNodeItem.t_strText = GetSystemString(365) $ " : ";
            // End:0x65E
            break;
            break;
    }
    infNodeItem.bLineBreak = true;
    infNodeItem.nOffSetX = 83;
    infNodeItem.nOffSetY = -17;
    infNodeItem.t_color.R = 163;
    infNodeItem.t_color.G = 163;
    infNodeItem.t_color.B = 163;
    infNodeItem.t_color.A = byte(255);
    InsertNodeItem(strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = (iSPConsume);
    infNodeItem.nOffSetX = 0;
    infNodeItem.nOffSetY = -17;
    infNodeItem.t_color.R = 176;
    infNodeItem.t_color.G = 155;
    infNodeItem.t_color.B = 121;
    infNodeItem.t_color.A = byte(255);
    InsertNodeItem(strRetName, infNodeItem);
    return;
}

function InsertNodeItem(string strNodeName, XMLTreeNodeItemInfo infNodeItemName)
{
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("SkillTrainListWnd.SkillTrainListTree", strNodeName, infNodeItemName);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("SkillTrainListWnd").HideWindow();
    m_SkillTrainListWnd.SetScrollPosition(0);
    m_bDrawBg = true;
    return;
}
