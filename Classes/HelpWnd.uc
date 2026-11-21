class HelpWnd extends UICommonAPI;

const ERRORMESSAGEID = 99;

var WindowHandle Me;
var TreeHandle MainTree;
var HtmlHandle HtmlViewer;
var string ROOTNAME;
var string TREENAME;
var int bodyCount;
var int CurrentID;
var int bodyCountCurrent;
var string expenedNode;
var ButtonHandle BtnNext;
var ButtonHandle btnPrev;
var TextBoxHandle txtNumber;
var bool indexLoaded;
//var delegate<OnSortCompareOrder> __OnSortCompareOrder__Delegate;

function OnRegisterEvent()
{
    RegisterEvent(1210);
    RegisterEvent(10700);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    RegisterState(getCurrentWindowName(string(self)), "GamingState");
    RegisterState(getCurrentWindowName(string(self)), "LoginState");
    Initialize();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("HelpWnd");
    MainTree = GetTreeHandle("HelpWnd.MainTree");
    HtmlViewer = GetHtmlHandle("HelpWnd.HtmlViewer");
    BtnNext = GetButtonHandle("HelpWnd.btnNext");
    btnPrev = GetButtonHandle("HelpWnd.btnPrev");
    txtNumber = GetTextBoxHandle("HelpWnd.txtNumber");
    ROOTNAME = "root";
    TREENAME = "HelpWnd.MainTree";
    bodyCountCurrent = 1;
    bodyCount = 1;
    setButtonState();
    return;
}

function OnEvent(int EventID, string param)
{
    // End:0x21
    if(GetGameStateName() == "SERVERLISTSTATE")
    {
        return;        
    }
    else
    {
        // End:0x36
        if(getInstanceUIData().getIsClassicServer())
        {
            return;
        }
    }
    switch(EventID)
    {
        // End:0x53
        case 1210:
            openHelp(param);
            // End:0x6C
            break;
        // End:0x69
        case 10700:
            handleTutorialShow(param);
            // End:0x6C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnShow()
{
    PlayConsoleSound(5);
    return;
}

function OnHide()
{
    PlayConsoleSound(6);
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x29
        case "btnNext":
            bodyCountCurrent++;
            setButtonState();
            LoadHtml();
            // End:0x77
            break;
        // End:0x4B
        case "btnPrev":
            bodyCountCurrent--;
            setButtonState();
            LoadHtml();
            // End:0x77
            break;
        // End:0xFFFF
        default:
            clickTreeNode(Name);
            setButtonState();
            LoadHtml();
            MainTree.SetFocus();
            // End:0x77
            break;
            break;
    }
    return;
}

function clickTreeNode(string Name)
{
    local array<string> Result, bodyInfo;

    // End:0x26
    if(expenedNode == Name)
    {
        MainTree.SetExpandedNode(expenedNode, true);
        return;
    }
    Split(Name, ".", Result);
    // End:0x48
    if(Result.Length < 3)
    {
        return;
    }
    // End:0x69
    if(expenedNode != "")
    {
        MainTree.SetExpandedNode(expenedNode, false);
    }
    expenedNode = Name;
    Split(Result[2], ",", bodyInfo);
    CurrentID = int(bodyInfo[0]);
    bodyCount = int(bodyInfo[1]);
    bodyCountCurrent = 1;
    return;
}

function setButtonState()
{
    txtNumber.SetText((string(bodyCountCurrent) $ "/") $ string(bodyCount));
    // End:0x41
    if(bodyCountCurrent == 1)
    {
        btnPrev.DisableWindow();        
    }
    else
    {
        btnPrev.EnableWindow();
    }
    // End:0x71
    if(bodyCountCurrent == bodyCount)
    {
        BtnNext.DisableWindow();        
    }
    else
    {
        BtnNext.EnableWindow();
    }
    return;
}

function handleTutorialShow(string param)
{
    local int Id;

    ParseInt(param, "ID", Id);
    // End:0x52
    if(Id > 0)
    {
        // End:0x38
        if(!indexLoaded)
        {
            helpIndexLoad();
            indexLoaded = true;
        }
        setExpandedNodeByID(Id);
        Me.ShowWindow();
    }
    HtmlViewer.SetFocus();
    return;
}

function openHelp(string param)
{
    // End:0x24
    if(Me.IsShowWindow())
    {
        Me.HideWindow();        
    }
    else
    {
        // End:0x3D
        if(!indexLoaded)
        {
            helpIndexLoad();
            indexLoaded = true;
        }
        // End:0x56
        if(param != "")
        {
            setExpandedNodeByID(int(param));
        }
        Me.ShowWindow();
    }
    HtmlViewer.SetFocus();
    return;
}

delegate int OnSortCompareOrder(TutorialIndex A, TutorialIndex B)
{
    // End:0x22
    if(A.ORDER > B.ORDER)
    {
        return -1;        
    }
    else
    {
        return 0;
    }
    return;
}

function helpIndexLoad()
{
    local array<TutorialIndex> TutorialIndexs;

    GetTutorialIndices(TutorialIndexs);
    setHelpCategroyTreeNode(TutorialIndexs);
    return;
}

function setExpandedNodeByID(int Id)
{
    local array<TutorialIndex> TutorialIndexs;
    local int i;
    local string NodeName, categoryNodeName;

    GetTutorialIndices(TutorialIndexs);
    i = 0;
    J0x12:

    // End:0xEA [Loop If]
    if(i < TutorialIndexs.Length)
    {
        // End:0xE0
        if(TutorialIndexs[i].Id == Id)
        {
            categoryNodeName = (ROOTNAME $ ".") $ string(TutorialIndexs[i].Category);
            NodeName = (((categoryNodeName $ ".") $ string(TutorialIndexs[i].Id)) $ ",") $ string(TutorialIndexs[i].LevelCount);
            MainTree.SetExpandedNode(categoryNodeName, true);
            MainTree.SetExpandedNode(NodeName, true);
            clickTreeNode(NodeName);
            setButtonState();
            LoadHtml();
            return;
        }
        i++;
        // [Loop Continue]
        goto J0x12;
    }
    return;
}

function setHelpCategroyTreeNode(array<TutorialIndex> TutorialIndexs)
{
    local int i, categoryIndex;
    local string strRetName, subTreeName;

    MainTree.Clear();
    getInstanceL2Util().TreeInsertRootNode(TREENAME, ROOTNAME, "", 0, 0);
    categoryIndex = -1;
    i = 0;
    J0x3F:

    // End:0x234 [Loop If]
    if(i < TutorialIndexs.Length)
    {
        // End:0x106
        if(categoryIndex != TutorialIndexs[i].Category)
        {
            categoryIndex = TutorialIndexs[i].Category;
            strRetName = insertExpandNode(string(categoryIndex), ROOTNAME);
            getInstanceL2Util().TreeInsertTextureNodeItem(TREENAME, strRetName, "L2UI_CT1.EmptyBtn", 190, 30, 0, -5);
            getInstanceL2Util().TreeInsertTextNodeItem(TREENAME, strRetName, GetSystemString(categoryIndex), -188, 9, getInstanceL2Util().0);
        }
        subTreeName = InsertNode(makeNodeName(TutorialIndexs[i]), strRetName);
        // End:0x171
        if((float(i) % float(2)) == float(0))
        {
            getInstanceL2Util().TreeInsertTextureNodeItem(TREENAME, subTreeName, "L2UI_CT1.EmptyBtn", 192, 20);            
        }
        else
        {
            getInstanceL2Util().TreeInsertTextureNodeItem(TREENAME, subTreeName, "L2UI_CH3.etc.textbackline", 192, 20,,,,, 14);
        }
        getInstanceL2Util().TreeInsertTextureNodeItem(TREENAME, subTreeName, "L2UI_CT1.BTN_Icon_Normal", 16, 16, 9 - 192, 2);
        getInstanceL2Util().TreeInsertTextNodeItem(TREENAME, subTreeName, TutorialIndexs[i].Name, 3, 4, getInstanceL2Util().2);
        i++;
        // [Loop Continue]
        goto J0x3F;
    }
    return;
}

function string makeNodeName(TutorialIndex TutorialIndex)
{
    return (string(TutorialIndex.Id) $ ",") $ string(TutorialIndex.LevelCount);
    return;
}

function string InsertNode(string NodeName, string parentName)
{
    local XMLTreeNodeInfo infNode, infNodeClear;

    infNode = infNodeClear;
    infNode.bShowButton = 0;
    infNode.strName = NodeName;
    infNode.bFollowCursor = true;
    infNode.nOffSetX = 2;
    infNode.nTexExpandedOffSetX = 0;
    infNode.nTexExpandedOffSetY = 0;
    infNode.nTexExpandedHeight = 20;
    infNode.nTexExpandedRightWidth = 0;
    infNode.nTexExpandedLeftUWidth = 1;
    infNode.nTexExpandedLeftUHeight = 15;
    infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
    return Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(TREENAME, parentName, infNode);
    return;
}

function string insertExpandNode(string NodeName, string parentName)
{
    local XMLTreeNodeInfo infNode, infNodeClear;

    infNode = infNodeClear;
    infNode.strName = NodeName;
    infNode.bFollowCursor = true;
    infNode.bShowButton = 1;
    infNode.nTexBtnOffSetY = 8;
    infNode.nTexBtnWidth = 15;
    infNode.nTexBtnHeight = 15;
    infNode.strTexBtnExpand = "l2ui_ch3.QuestWnd.QuestWndPlusBtn";
    infNode.strTexBtnCollapse = "l2ui_ch3.QuestWnd.QuestWndMinusBtn";
    return Class'NWindow.UIAPI_TREECTRL'.static.InsertNode(TREENAME, parentName, infNode);
    return;
}

function LoadHtml()
{
    local TutorialBody body;

    GetTutorialBody(CurrentID, bodyCountCurrent, body);
    HtmlViewer.LoadHtmlFromString(htmlSetHtmlStart(body.Description));
    return;
}

function OnReceivedCloseUI()
{
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
