class RecipeTreeWnd extends UICommonAPI;

const CRYSTAL_TYPE_WIDTH = 14;
const CRYSTAL_TYPE_HEIGHT = 14;

var TreeHandle MainTree;
var array<INT64> itemNeedCount;

function OnRegisterEvent()
{
    RegisterEvent(810);
    RegisterEvent(2600);
    RegisterEvent(2610);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    MainTree = GetTreeHandle("RecipeTreeWnd.MainTree");
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int RecipeID;

    // End:0x37
    if(Event_ID == 810)
    {
        ParseInt(param, "RecipeID", RecipeID);
        StartRecipeTreeWnd(RecipeID);        
    }
    else
    {
        // End:0x62
        if((Event_ID == 2600) || Event_ID == 2610)
        {
            HandleInventoryItem(param);
        }
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1D
        case "btnClose":
            closeWindow();
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function closeWindow()
{
    Clear();
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");
    PlayConsoleSound(6);
    return;
}

function Clear()
{
    Class'NWindow.UIAPI_TREECTRL'.static.Clear("RecipeTreeWnd.MainTree");
    return;
}

function StartRecipeTreeWnd(int RecipeID)
{
    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("RecipeTreeWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("RecipeTreeWnd");
    Clear();
    SetRecipeInfo(RecipeID);
    return;
}

function SetRecipeInfo(int RecipeID)
{
    local string strTmp, strTmp2;
    local int nTmp;
    local XMLTreeNodeInfo infNode;
    local int ProductID;
    local Rect txtNameRect;
    local ItemInfo NewItem;

    ProductID = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ProductID), NewItem);
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("RecipeTreeWnd.texItem");
    Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("RecipeTreeWnd.texItem", NewItem);
    strTmp = MakeFullItemName(ProductID);
    nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
    strTmp2 = GetItemGradeTextureName(nTmp);
    Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("RecipeTreeWnd.texGrade", strTmp2);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtName", strTmp);
    txtNameRect = GetTextBoxHandle("RecipeTreeWnd.txtName").GetRect();
    // End:0x1BA
    if(txtNameRect.nWidth > 150)
    {
        GetTextBoxHandle("RecipeTreeWnd.txtName").SetWindowSize(141, txtNameRect.nHeight);
        GetTextBoxHandle("RecipeTreeWnd.txtName").SetTextEllipsisWidth(141);        
    }
    else
    {
        GetTextBoxHandle("RecipeTreeWnd.txtName").SetTextEllipsisWidth(-1);
    }
    GetTextBoxHandle("RecipeTreeWnd.txtName").SetTooltipType("Text");
    GetTextBoxHandle("RecipeTreeWnd.txtName").SetTooltipText(strTmp);
    // End:0x2BF
    if(((((nTmp == int(6)) || nTmp == int(7)) || nTmp == int(9)) || nTmp == int(10)) || nTmp == int(11))
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("RecipeTreeWnd.texGrade", 14 * 2, 14);        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.SetWindowSize("RecipeTreeWnd.texGrade", 14, 14);
    }
    nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtMPConsume", "" $ string(nTmp));
    nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtSuccessRate", string(nTmp) $ "%");
    nTmp = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.TxtForgeLevelValue", string(nTmp));
    // End:0x42E
    if(bool(Class'NWindow.UIDATA_RECIPE'.static.GetRecipeIsMultipleProduct(RecipeID)))
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtOption", GetSystemMessage(2320));        
    }
    else
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtOption", "");
    }
    infNode.strName = "root";
    infNode.nOffSetX = 1;
    infNode.nOffSetY = 5;
    strTmp = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree", "", infNode);
    // End:0x4C5
    if(Len(strTmp) < 1)
    {
        return;
    }
    itemNeedCount.Remove(0, itemNeedCount.Length);
    AddRecipeItem(RecipeID, ProductID, (0), "root");
    return;
}

function HandleInventoryItem(string param)
{
    local ItemID cID;

    // End:0x26
    if(!GetWindowHandle("RecipeTreeWnd").IsShowWindow())
    {
        return;
    }
    // End:0x54
    if(ParseItemID(param, cID))
    {
        findNFixItem(cID.ClassID, "root", -1);
    }
    return;
}

function int findNFixItem(int cID, string strNodeName, int Index)
{
    local string strChildList;
    local array<string> ChildList, itemList;
    local string TextureName;
    local int i;
    local INT64 nTmp;

    strChildList = MainTree.GetChildNode(strNodeName);
    Split(strChildList, "|", ChildList);
    // End:0x3E
    if(cID <= 0)
    {
        return -1;
    }
    i = 0;
    J0x45:

    // End:0x1C2 [Loop If]
    if(i < ChildList.Length)
    {
        // End:0x1B8
        if(ChildList[i] != "")
        {
            Index++;
            // End:0x197
            if(strNodeName != "root")
            {
                Split(ChildList[i], ".", itemList);
                // End:0x197
                if(int(itemList[itemList.Length - 1]) == cID)
                {
                    nTmp = GetInventoryItemCount(GetItemID(cID));
                    MainTree.SetNodeItemText(ChildList[i], 1, ((("(" $ (nTmp)) $ "/") $ (itemNeedCount[Index])) $ ")");
                    // End:0x137
                    if(__NFUN_408__(nTmp, itemNeedCount[Index]))
                    {
                        TextureName = "Default.ChatBack";
                    }
                    MainTree.SetNodeItemTexture(ChildList[i], 2, TextureName, 0, 0, 0);
                    Class'NWindow.UIAPI_TREECTRL'.static.SetNodeItemTexture("RecipeTreeWnd.MainTree", ChildList[i], 2, TextureName, 0, 0, 0);
                }
            }
            Index = findNFixItem(cID, ChildList[i], Index);
        }
        i++;
        // [Loop Continue]
        goto J0x45;
    }
    return Index;
    return;
}

static function int Split(string strInput, string delim, out array<string> arrToken)
{
    local int arrSize;

    J0x00:
    // End:0x6F [Loop If]
    if(InStr(strInput, delim) > 0)
    {
        arrToken.Insert(arrToken.Length, 1);
        arrToken[arrToken.Length - 1] = Left(strInput, InStr(strInput, delim));
        strInput = Mid(strInput, InStr(strInput, delim) + 1);
        arrSize = arrSize + 1;
        // [Loop Continue]
        goto J0x00;
    }
    arrToken.Insert(arrToken.Length, 1);
    arrToken[arrToken.Length - 1] = strInput;
    arrSize = arrSize + 1;
    return arrSize;
    return;
}

function AddRecipeItem(int RecipeID, int ProductID, INT64 NeedCount, string NodeName)
{
    local int i, nMax;
    local INT64 nTmp;
    local bool bIamRoot;
    local string strTmp, strTmp2, param, strRetName;
    local array<int> arrMatID;
    local array<INT64> arrMatNeedCount;
    local array<int> arrMatRecipeID;
    local XMLTreeNodeInfo infNode;
    local XMLTreeNodeItemInfo infNodeItem;
    local XMLTreeNodeInfo infNodeClear;
    local XMLTreeNodeItemInfo infNodeItemClear;
    local L2Util util;
    local ItemInfo NewItem;

    util = L2Util(GetScript("L2Util"));
    strTmp = Class'NWindow.UIDATA_ITEM'.static.GetItemName(GetItemID(ProductID));
    param = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeMaterialItem(RecipeID);
    ParseInt(param, "Count", nMax);
    arrMatID.Length = nMax;
    arrMatNeedCount.Length = nMax;
    arrMatRecipeID.Length = nMax;
    i = 0;
    J0x95:

    // End:0x127 [Loop If]
    if(i < nMax)
    {
        ParseInt(param, "ID_" $ string(i), arrMatID[i]);
        ParseINT64(param, "NeededNum_" $ string(i), arrMatNeedCount[i]);
        ParseInt(param, "RecipeID_" $ string(i), arrMatRecipeID[i]);
        i++;
        // [Loop Continue]
        goto J0x95;
    }
    // End:0x142
    if(NodeName == "root")
    {
        bIamRoot = true;        
    }
    else
    {
        bIamRoot = false;
    }
    infNode = infNodeClear;
    infNode.strName = "" $ string(ProductID);
    infNode.ToolTip = MakeTooltipSimpleText(strTmp);
    infNode.bFollowCursor = true;
    // End:0x244
    if(nMax > 0)
    {
        infNode.bShowButton = 1;
        // End:0x1BD
        if(!bIamRoot)
        {
            infNode.nOffSetX = 13;
        }
        infNode.nTexBtnOffSetY = 8;
        infNode.nTexBtnWidth = 15;
        infNode.nTexBtnHeight = 15;
        infNode.strTexBtnExpand = "l2ui_ch3.QuestWnd.QuestWndPlusBtn";
        infNode.strTexBtnCollapse = "l2ui_ch3.QuestWnd.QuestWndMinusBtn";        
    }
    else
    {
        infNode.bShowButton = 0;
        infNode.nOffSetX = 30;
    }
    strRetName = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree", NodeName, infNode);
    // End:0x2D3
    if(Len(strRetName) < 1)
    {
        LogInternal("ERROR: Can't insert node. Name: " $ infNode.strName);
        return;
    }
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ProductID), NewItem);
    strTmp2 = NewItem.IconName;
    // End:0x32B
    if(Len(strTmp2) < 1)
    {
        strTmp2 = "Default.BlackTexture";
    }
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 2;
    // End:0x3C6
    if(nMax > 0)
    {
        util.TreeInsertTextureNodeItem("RecipeTreeWnd.MainTree", strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, 0, -2);
        infNodeItem.nOffSetX = -34;        
    }
    else
    {
        util.TreeInsertTextureNodeItem("RecipeTreeWnd.MainTree", strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -2, -2);
        infNodeItem.nOffSetX = -34;
    }
    infNodeItem.nOffSetY = 0;
    infNodeItem.u_nTextureWidth = 32;
    infNodeItem.u_nTextureHeight = 32;
    infNodeItem.u_strTexture = strTmp2;
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
    util.TreeInsertTextureNodeItem("RecipeTreeWnd.MainTree", strRetName, NewItem.IconPanel, 32, 32, -32);
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 2;
    infNodeItem.nOffSetX = -32;
    infNodeItem.nOffSetY = 0;
    infNodeItem.u_nTextureWidth = 32;
    infNodeItem.u_nTextureHeight = 32;
    // End:0x5A3
    if(nMax > 0)
    {
        infNodeItem.u_strTexture = "L2UI.RecipeWnd.RecipeTreeIconBack";
        infNodeItem.u_strTextureExpanded = "L2UI.RecipeWnd.RecipeTreeIconBack_click";        
    }
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
    // End:0x6AF
    if(!bIamRoot)
    {
        nTmp = GetInventoryItemCount(GetItemID(ProductID));
        infNodeItem = infNodeItemClear;
        infNodeItem.eType = 2;
        infNodeItem.nOffSetX = -32;
        infNodeItem.nOffSetY = 0;
        infNodeItem.u_nTextureWidth = 32;
        infNodeItem.u_nTextureHeight = 32;
        infNodeItem.t_nTextID = 2;
        // End:0x67E
        if(__NFUN_408__(nTmp, NeedCount))
        {
            infNodeItem.u_strTexture = "Default.ChatBack";
        }
        Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
    }
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 1;
    infNodeItem.t_strText = strTmp;
    infNodeItem.t_bDrawOneLine = true;
    infNodeItem.nOffSetX = 5;
    infNodeItem.nOffSetY = 3;
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
    // End:0x7FE
    if(!bIamRoot)
    {
        infNodeItem = infNodeItemClear;
        infNodeItem.eType = 1;
        infNodeItem.t_nTextID = 1;
        infNodeItem.t_strText = ((("(" $ (nTmp)) $ "/") $ (NeedCount)) $ ")";
        infNodeItem.bLineBreak = true;
        // End:0x7B0
        if(nMax > 0)
        {
            infNodeItem.nOffSetX = 51;            
        }
        else
        {
            infNodeItem.nOffSetX = 37;
        }
        infNodeItem.nOffSetY = -14;
        Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
    }
    itemNeedCount.Length = itemNeedCount.Length + 1;
    itemNeedCount[itemNeedCount.Length - 1] = NeedCount;
    infNodeItem = infNodeItemClear;
    infNodeItem.eType = 0;
    infNodeItem.bStopMouseFocus = true;
    // End:0x863
    if(nMax > 0)
    {
        infNodeItem.b_nHeight = 6;        
    }
    else
    {
        infNodeItem.b_nHeight = 4;
    }
    Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
    i = 0;
    J0x8A8:

    // End:0x8ED [Loop If]
    if(i < nMax)
    {
        AddRecipeItem(arrMatRecipeID[i], arrMatID[i], arrMatNeedCount[i], strRetName);
        i++;
        // [Loop Continue]
        goto J0x8A8;
    }
    return;
}

function OnReceivedCloseUI()
{
    closeWindow();
    return;
}
