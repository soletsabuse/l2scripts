class RecipeBuyListWnd extends UICommonAPI;

const RECIPEWND_MAX_MP_WIDTH = 165.0f;

var int m_merchantID;
var int m_MaxMP;
var BarHandle MPBar;

function OnRegisterEvent()
{
    RegisterEvent(780);
    RegisterEvent(790);
    RegisterEvent(210);
    RegisterEvent(211);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    MPBar = GetBarHandle("RecipeBuyListWnd.barMp");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeBuyListWnd.txtAdena", "0");
    return;
}

function OnEvent(int Event_ID, string param)
{
    local Rect rectWnd;
    local int ServerID, MPValue, currentMP, maxMP;
    local INT64 Adena;
    local int RecipeID, CanbeMade;
    local INT64 MakingFee;

    // End:0x184
    if(Event_ID == 780)
    {
        Clear();
        // End:0xC2
        if(IsShowWindow("RecipeBuyManufactureWnd"))
        {
            rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect("RecipeBuyManufactureWnd");
            Class'NWindow.UIAPI_WINDOW'.static.MoveTo("RecipeBuyListWnd", rectWnd.nX, rectWnd.nY);
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeBuyManufactureWnd");
        }
        ParseInt(param, "ServerID", ServerID);
        ParseInt(param, "CurrentMP", currentMP);
        ParseInt(param, "MaxMP", maxMP);
        ParseINT64(param, "Adena", Adena);
        ReceiveRecipeShopSellList(ServerID, currentMP, maxMP, Adena);
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RecipeBuyListWnd");
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus("RecipeBuyListWnd");        
    }
    else
    {
        // End:0x1FB
        if(Event_ID == 790)
        {
            ParseInt(param, "RecipeID", RecipeID);
            ParseInt(param, "CanbeMade", CanbeMade);
            ParseINT64(param, "MakingFee", MakingFee);
            AddRecipeShopSellItem(RecipeID, CanbeMade, MakingFee);            
        }
        else
        {
            // End:0x271
            if((Event_ID == 210) || Event_ID == 211)
            {
                ParseInt(param, "ServerID", ServerID);
                ParseInt(param, "CurrentMP", MPValue);
                // End:0x271
                if((m_merchantID == ServerID) && m_merchantID > 0)
                {
                    SetMPBar(MPValue);
                }
            }
        }
    }
    return;
}

function OnClickButton(string strID)
{
    local string strRecipeID;

    switch(strID)
    {
        // End:0x1D
        case "btnClose":
            closeWindow();
            // End:0x4D
            break;
        // End:0xFFFF
        default:
            strRecipeID = Mid(strID, 5);
            Class'NWindow.RecipeAPI'.static.RequestRecipeShopMakeInfo(m_merchantID, int(strRecipeID));
            // End:0x4D
            break;
            break;
    }
    return;
}

function closeWindow()
{
    Clear();
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeBuyListWnd");
    PlayConsoleSound(6);
    return;
}

function Clear()
{
    m_merchantID = 0;
    m_MaxMP = 0;
    Class'NWindow.UIAPI_TREECTRL'.static.Clear("RecipeBuyListWnd.MainTree");
    return;
}

function ReceiveRecipeShopSellList(int ServerID, int currentMP, int maxMP, INT64 Adena)
{
    local string strTmp;
    local XMLTreeNodeInfo infNode;

    m_merchantID = ServerID;
    m_MaxMP = maxMP;
    strTmp = (GetSystemString(663) $ " - ") $ Class'NWindow.UIDATA_USER'.static.GetUserName(ServerID);
    Class'NWindow.UIAPI_WINDOW'.static.SetWindowTitleByText("RecipeBuyListWnd", strTmp);
    SetMPBar(currentMP);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeBuyListWnd.txtAdena", MakeCostString((Adena)));
    Class'NWindow.UIAPI_TEXTBOX'.static.SetTooltipString("RecipeBuyListWnd.txtAdena", ConvertNumToText((Adena)));
    infNode.strName = "root";
    infNode.nOffSetX = 7;
    infNode.nOffSetY = 7;
    strTmp = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("RecipeBuyListWnd.MainTree", "", infNode);
    // End:0x154
    if(Len(strTmp) < 1)
    {
        return;
    }
    return;
}

function SetMPBar(int currentMP)
{
    Debug((("MP" $ string(m_MaxMP)) $ " ") $ string(currentMP));
    MPBar.SetValue(m_MaxMP, currentMP);
    return;
}

function AddRecipeShopSellItem(int RecipeID, int CanbeMade, INT64 MakingFee)
{
    local string strTmp;
    local XMLTreeNodeInfo infNode;
    local XMLTreeNodeItemInfo infNodeItem;
    local XMLTreeNodeInfo infNodeClear;
    local XMLTreeNodeItemInfo infNodeItemClear;
    local string strRetName;
    local int ProductID;
    local string AdenaComma, strName, strDescription;
    local ItemID cID;

    ProductID = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
    cID = GetItemID(ProductID);
    strName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(cID);
    strDescription = Class'NWindow.UIDATA_ITEM'.static.GetItemDescription(cID);
    infNode = infNodeClear;
    infNode.strName = "" $ string(RecipeID);
    infNode.bShowButton = 0;
    infNode.ToolTip = SetTooltip(strName, strDescription, MakingFee);
    infNode.bFollowCursor = true;
    infNode.nTexExpandedOffSetX = -7;
    infNode.nTexExpandedOffSetY = -3;
    infNode.nTexExpandedHeight = 46;
    infNode.nTexExpandedRightWidth = 0;
    infNode.nTexExpandedLeftUWidth = 32;
    infNode.nTexExpandedLeftUHeight = 40;
    infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
    strRetName = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("RecipeBuyListWnd.MainTree", "root", infNode);
    // End:0x1AB
    if(Len(strRetName) < 1)
    {
        LogInternal("ERROR: Can't insert node. Name: " $ infNode.strName);
        return;
    }
    infNode.ToolTip.DrawList.Remove(0, infNode.ToolTip.DrawList.Length);
    strTmp = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID);
    // End:0x20F
    if(Len(strTmp) < 1)
    {
        strTmp = "Default.BlackTexture";
    }
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 2;
    infNodeItem.nOffSetX = 0;
    infNodeItem.nOffSetY = 4;
    infNodeItem.u_nTextureWidth = 32;
    infNodeItem.u_nTextureHeight = 32;
    infNodeItem.u_strTexture = strTmp;
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = strName;
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 10;
    infNodeItem.nOffSetY = 0;
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = GetSystemString(641);
    infNodeItem.bLineBreak = true;
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 42;
    infNodeItem.nOffSetY = -22;
    infNodeItem.t_color.R = 168;
    infNodeItem.t_color.G = 168;
    infNodeItem.t_color.B = 168;
    infNodeItem.t_color.A = byte(255);
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = " : ";
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 0;
    infNodeItem.nOffSetY = -22;
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
    AdenaComma = MakeCostString((MakingFee));
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = AdenaComma;
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 0;
    infNodeItem.nOffSetY = -22;
    infNodeItem.t_color = GetNumericColor(AdenaComma);
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = GetSystemString(469);
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 5;
    infNodeItem.nOffSetY = -22;
    infNodeItem.t_color.R = byte(255);
    infNodeItem.t_color.G = byte(255);
    infNodeItem.t_color.B = 0;
    infNodeItem.t_color.A = byte(255);
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = GetSystemString(642);
    infNodeItem.bLineBreak = true;
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 42;
    infNodeItem.nOffSetY = -8;
    infNodeItem.t_color.R = 168;
    infNodeItem.t_color.G = 168;
    infNodeItem.t_color.B = 168;
    infNodeItem.t_color.A = byte(255);
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = " : ";
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 0;
    infNodeItem.nOffSetY = -8;
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = string(Class'NWindow.UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID)) $ "%";
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 0;
    infNodeItem.nOffSetY = -8;
    infNodeItem.t_color.R = 176;
    infNodeItem.t_color.G = 155;
    infNodeItem.t_color.B = 121;
    infNodeItem.t_color.A = byte(255);
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 0;
    infNodeItem.bStopMouseFocus = true;
    infNodeItem.b_nHeight = 10;
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeBuyListWnd.MainTree", strRetName, infNodeItem);
    return;
}

function CustomTooltip SetTooltip(string Name, string Description, INT64 MakingFee)
{
    local CustomTooltip ToolTip;
    local DrawItemInfo Info, infoClear;
    local string AdenaComma;

    AdenaComma = MakeCostString((MakingFee));
    ToolTip.DrawList.Length = 4;
    Info = infoClear;
    Info.eType = 1;
    Info.t_bDrawOneLine = true;
    Info.t_strText = Name;
    ToolTip.DrawList[0] = Info;
    Info = infoClear;
    Info.eType = 1;
    Info.nOffSetY = 6;
    Info.bLineBreak = true;
    Info.t_bDrawOneLine = true;
    Info.t_color.R = 163;
    Info.t_color.G = 163;
    Info.t_color.B = 163;
    Info.t_color.A = byte(255);
    Info.t_strText = GetSystemString(322) $ " : ";
    ToolTip.DrawList[1] = Info;
    Info = infoClear;
    Info.eType = 1;
    Info.nOffSetY = 6;
    Info.t_bDrawOneLine = true;
    Info.t_color = GetNumericColor(AdenaComma);
    Info.t_strText = (AdenaComma $ " ") $ GetSystemString(469);
    ToolTip.DrawList[2] = Info;
    Info = infoClear;
    Info.eType = 1;
    Info.nOffSetY = 6;
    Info.bLineBreak = true;
    Info.t_bDrawOneLine = true;
    Info.t_color = GetNumericColor(AdenaComma);
    Info.t_strText = ("(" $ ConvertNumToText((MakingFee))) $ ")";
    ToolTip.DrawList[3] = Info;
    return ToolTip;
    return;
}

function OnReceivedCloseUI()
{
    closeWindow();
    return;
}
