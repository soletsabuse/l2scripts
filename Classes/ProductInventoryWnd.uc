class ProductInventoryWnd extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle txtItemList;
var TreeHandle ProductListTree;
var ButtonHandle HelpHtmlBtn;
var TextureHandle ProductListBack;
var WindowHandle HelpHtmlWnd;
var string TREENAME;
var string ROOTNAME;
var bool bDrawBgTree;
var int selectItemIndex;
var string beforeTreeName;
var WindowHandle m_inventoryWnd;
var L2Util util;

function OnRegisterEvent()
{
    RegisterEvent(5601);
    RegisterEvent(5604);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    load();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("ProductInventoryWnd");
    txtItemList = GetTextBoxHandle("ProductInventoryWnd.txtItemList");
    ProductListTree = GetTreeHandle("ProductInventoryWnd.ProductListTree");
    HelpHtmlBtn = GetButtonHandle("ProductInventoryWnd.HelpHtmlBtn");
    ProductListBack = GetTextureHandle("ProductInventoryWnd.ProductListBack");
    HelpHtmlWnd = GetWindowHandle("ProductInventoryHelpHtmlWnd");
    m_inventoryWnd = GetWindowHandle("InventoryWnd");
    return;
}

function load()
{
    util = L2Util(GetScript("L2Util"));
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    PlayConsoleSound(5);
    TreeClear();
    Class'NWindow.UIAPI_TREECTRL'.static.Clear("ProductInventoryDrawerWnd.ProductItemDetailList");
    RequestGoodsInventoryItemList();
    return;
}

function OnHide()
{
    DescHide();
    PlayConsoleSound(6);
    // End:0x1D
    if(DialogIsMine())
    {
        DialogHide();
    }
    return;
}

function DescHide()
{
    local WindowHandle win;

    win = GetWindowHandle("ProductInventoryDrawerWnd");
    DialogHide();
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ProductInventoryDrawerWnd.RecieveBtn");
    Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("ProductInventoryDrawerWnd.CloseBtn");
    beforeTreeName = "";
    SetDisableTree(true);
    // End:0xD6
    if(win.IsShowWindow())
    {
        win.HideWindow();
        RequestGoodsInventoryItemDesc(-1);
        SetSelectClear();
    }
    return;
}

function OnClickButton(string strID)
{
    local array<string> Result;

    Split(strID, ".", Result);
    // End:0x30
    if(strID == "HelpHtmlBtn")
    {
        OnHelpHtmlBtnClick();
    }
    // End:0xB7
    if(Result[0] == ROOTNAME)
    {
        // End:0x97
        if(beforeTreeName != strID)
        {
            ProductListTree.SetExpandedNode(beforeTreeName, false);
            ProductListTree.SetExpandedNode(strID, true);
            selectItemIndex = int(Result[1]);
            RequestGoodsInventoryItemDesc(selectItemIndex);            
        }
        else
        {
            ProductListTree.SetExpandedNode(beforeTreeName, true);
        }
        beforeTreeName = strID;
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 5601:
            OnGoodsInventoryItemList(param);
            // End:0x36
            break;
        // End:0x33
        case 5604:
            OnGoodsInventoryResult(param);
            // End:0x36
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnGoodsInventoryItemList(string param)
{
    local int i, goodsCount, goodsType, goodsIconID;
    local string goodsName;
    local int goodsCondition;
    local string strTexture;
    local ItemID cID;

    TreeClear();
    ShowSkillTree();
    ParseInt(param, "goodsCount", goodsCount);
    i = 0;
    J0x2F:

    // End:0x170 [Loop If]
    if(i < goodsCount)
    {
        ParseInt(param, "goodsType_" $ string(i), goodsType);
        ParseInt(param, "goodsIconID_" $ string(i), goodsIconID);
        ParseString(param, "goodsName_" $ string(i), goodsName);
        ParseInt(param, "goodsCondition_" $ string(i), goodsCondition);
        // End:0xFD
        if(Len(goodsName) > 40)
        {
            goodsName = Left(goodsName, 37) $ "...";
        }
        cID = GetItemID(goodsIconID);
        // End:0x136
        if(goodsType == 0)
        {
            strTexture = Class'NWindow.UIDATA_ITEM'.static.GetItemTextureName(cID);            
        }
        else
        {
            strTexture = GetGoodsIconName(goodsIconID);
        }
        MakeTreeNode(cID, goodsName, goodsCondition, i, strTexture);
        i++;
        // [Loop Continue]
        goto J0x2F;
    }
    return;
}

function MakeTreeNode(ItemID cID, string goodsName, int goodsCondition, int Index, string Texture)
{
    local string setTreeName, strRetName;

    setTreeName = ROOTNAME;
    strRetName = util.TreeInsertItemTooltipSimpleNode(TREENAME, "" $ string(Index), setTreeName, -2, 0, 38, 0, 30, 38);
    // End:0x92
    if(bDrawBgTree == true)
    {
        util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CH3.etc.textbackline", 298, 38,,,,, 14);        
    }
    else
    {
        util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 298, 38);
    }
    bDrawBgTree = !bDrawBgTree;
    util.TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2", 36, 36, -291, 2);
    util.TreeInsertTextureNodeItem(TREENAME, strRetName, Texture, 32, 32, -34, 3);
    // End:0x19A
    if((goodsCondition == 0) || goodsCondition == 2)
    {
        util.TreeInsertTextMultiNodeItem(TREENAME, strRetName, goodsName, 4, 0, 38, util.0);        
    }
    else
    {
        // End:0x1D3
        if(goodsCondition == 1)
        {
            util.TreeInsertTextMultiNodeItem(TREENAME, strRetName, goodsName, 4, 0, 38, util.4);
        }
    }
    return;
}

function OnGoodsInventoryResult(string param)
{
    local int Result;

    ParseInt(param, "Result", Result);
    // End:0x26
    if(Result == 1)
    {        
    }
    else
    {
        // End:0x43
        if(Result == 2)
        {
            AddSystemMessage(3412);
            DescHide();
        }
    }
    // End:0x294
    if(Result < 0)
    {
        Me.HideWindow();
        DescHide();
        // End:0x8D
        if(Result == -1)
        {
            DialogShow(1, 5, GetSystemMessage(3377), string(self));            
        }
        else
        {
            // End:0xB7
            if(Result == -2)
            {
                DialogShow(1, 5, GetSystemMessage(3385), string(self));                
            }
            else
            {
                // End:0xE1
                if(Result == -3)
                {
                    DialogShow(1, 5, GetSystemMessage(3386), string(self));                    
                }
                else
                {
                    // End:0x10B
                    if(Result == -4)
                    {
                        DialogShow(1, 5, GetSystemMessage(3411), string(self));                        
                    }
                    else
                    {
                        // End:0x135
                        if(Result == -5)
                        {
                            DialogShow(1, 5, GetSystemMessage(3413), string(self));                            
                        }
                        else
                        {
                            // End:0x15F
                            if(Result == -6)
                            {
                                DialogShow(1, 5, GetSystemMessage(3417), string(self));                                
                            }
                            else
                            {
                                // End:0x189
                                if(Result == -101)
                                {
                                    DialogShow(1, 5, GetSystemMessage(3378), string(self));                                    
                                }
                                else
                                {
                                    // End:0x1B3
                                    if(Result == -102)
                                    {
                                        DialogShow(1, 5, GetSystemMessage(3410), string(self));                                        
                                    }
                                    else
                                    {
                                        // End:0x1DD
                                        if(Result == -103)
                                        {
                                            DialogShow(1, 5, GetSystemMessage(3379), string(self));                                            
                                        }
                                        else
                                        {
                                            // End:0x1EF
                                            if(Result == -104)
                                            {                                                
                                            }
                                            else
                                            {
                                                // End:0x219
                                                if(Result == -105)
                                                {
                                                    DialogShow(1, 5, GetSystemMessage(3381), string(self));                                                    
                                                }
                                                else
                                                {
                                                    // End:0x243
                                                    if(Result == -106)
                                                    {
                                                        DialogShow(1, 5, GetSystemMessage(3382), string(self));                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x26D
                                                        if(Result == -107)
                                                        {
                                                            DialogShow(1, 5, GetSystemMessage(3383), string(self));                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x294
                                                            if(Result == -108)
                                                            {
                                                                DialogShow(1, 5, GetSystemMessage(3384), string(self));
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

function OnHelpHtmlBtnClick()
{
    HelpHtmlWnd.ShowWindow();
    return;
}

function TreeClear()
{
    ProductListTree.SetScrollPosition(0);
    Class'NWindow.UIAPI_TREECTRL'.static.Clear(TREENAME);
    return;
}

function ShowSkillTree()
{
    util.TreeInsertRootNode(TREENAME, ROOTNAME, "", 0, 4);
    return;
}

function int GetSelectIndex()
{
    return selectItemIndex;
    return;
}

function SetSelectClear()
{
    ProductListTree.SetExpandedNode(beforeTreeName, false);
    beforeTreeName = "";
    return;
}

function SetDisableTree(bool B)
{
    // End:0x1E
    if(B == true)
    {
        ProductListTree.EnableWindow();        
    }
    else
    {
        ProductListTree.DisableWindow();
    }
    return;
}

function SetExpandedOpen(string NodeName)
{
    local string openNode;

    openNode = ProductListTree.GetExpandedNode("root");
    // End:0x45
    if(openNode == "")
    {
        ProductListTree.SetExpandedNode("root." $ NodeName, true);
    }
    return;
}

function OnReceivedCloseUI()
{
    Me.HideWindow();
    return;
}

defaultproperties
{
    TREENAME="ProductInventoryWnd.ProductListTree"
    ROOTNAME="root"
}