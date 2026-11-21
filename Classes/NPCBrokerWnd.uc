class NPCBrokerWnd extends NPCBrokerAPI;

const NPC_TALK = 1001;
const NPC_IDLE = 1002;
const NPC_IDLE_DELAY = 15000;
const NPC_IDLE_RANDOM = 30000;
const HIDE_POPUP = 1003;
const HIDE_POPUP_DELAY = 25;
const GOTO_TRADER = 1004;
const GOTO_TRADER_DELAY = 500;

struct _targetInfo
{
    var ItemInfo targetSlotItem;
    var int targetSlotUserId;
};

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle btnBack;
var WindowHandle SelectContainer;
var TextBoxHandle txtBrokerHead;
var CharacterViewportWindowHandle ObjectViewport;
var ButtonHandle Main_sellBtn;
var ButtonHandle Main_buyBtn;
var ButtonHandle Main_manifactureBtn;
var WindowHandle MainPageContainer;
var ButtonHandle btnSearch;
var WindowHandle TypePopupWnd;
var EditBoxHandle EditBoxSearch;
var TextBoxHandle txtTypeHead;
var TextureHandle texMainBackAdena;
var array<ButtonHandle> TypeButtons;
var array<ButtonHandle> SpecialTypeButtons;
var WindowHandle ListContainer;
var TextureHandle texBackAdena;
var array<TraderItem> TraderItems;
var ButtonHandle btnSort;
var Paginator Paginator;
var int nCurrentTextPos;
var NPCBrokerAPI.WindowStateType previousWindowType;
var NPCBrokerAPI.WindowStateType currentWindowType;
var NPCBrokerAPI.BrokerGeneralType previousBrokerGeneralType;
var NPCBrokerAPI.BrokerGeneralType currentBrokerGeneralType;
var int currentButtonType;
var array<BrokerItemData> currentBrokerItemsList;
var string currentSearchLine;
var int currentPage;
var bool bSearchInside;
var byte nCurSortType;
var _targetInfo targetInfo;
var _targetInfo noneTargetInfo;

function OnLoad()
{
    local int i;

    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    btnBack = GetButtonHandle(m_WindowName $ ".btnBack");
    SelectContainer = GetWindowHandle(m_WindowName $ ".SelectContainer");
    txtBrokerHead = GetTextBoxHandle(m_WindowName $ ".SelectContainer.txtBrokerHead");
    ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".SelectContainer.ObjectViewport");
    Main_sellBtn = GetButtonHandle(m_WindowName $ ".SelectContainer.BtnSell");
    Main_buyBtn = GetButtonHandle(m_WindowName $ ".SelectContainer.BtnBuy");
    Main_manifactureBtn = GetButtonHandle(m_WindowName $ ".SelectContainer.BtnManifacture");
    MainPageContainer = GetWindowHandle(m_WindowName $ ".MainPageContainer");
    btnSearch = GetButtonHandle(m_WindowName $ ".MainPageContainer.btnSearch");
    TypePopupWnd = GetWindowHandle(m_WindowName $ ".MainPageContainer.TypePopupWnd");
    EditBoxSearch = GetEditBoxHandle(m_WindowName $ ".MainPageContainer.EditBoxSearch");
    txtTypeHead = GetTextBoxHandle(m_WindowName $ ".MainPageContainer.txtTypeHead");
    texMainBackAdena = GetTextureHandle(m_WindowName $ ".MainPageContainer.texMainBackAdena");
    TypeButtons.Length = 12;
    i = 0;
    J0x292:

    // End:0x2FF [Loop If]
    if(i < TypeButtons.Length)
    {
        TypeButtons[i] = GetButtonHandle((m_WindowName $ ".MainPageContainer.btnType") $ getInstanceL2Util().makeZeroString(2, (i + 1)));
        i++;
        // [Loop Continue]
        goto J0x292;
    }
    SpecialTypeButtons.Length = 3;
    SpecialTypeButtons[0] = GetButtonHandle(m_WindowName $ ".MainPageContainer.TypePopupWnd.btnSpecialType_01_01");
    SpecialTypeButtons[1] = GetButtonHandle(m_WindowName $ ".MainPageContainer.TypePopupWnd.btnSpecialType_01_02");
    SpecialTypeButtons[2] = GetButtonHandle(m_WindowName $ ".MainPageContainer.TypePopupWnd.btnSpecialType_01_03");
    ListContainer = GetWindowHandle(m_WindowName $ ".ListContainer");
    texBackAdena = GetTextureHandle(m_WindowName $ ".ListContainer.texBackAdena");
    btnSort = GetButtonHandle(m_WindowName $ ".ListContainer.btnSort");
    TraderItems.Length = 7;
    i = 0;
    J0x478:

    // End:0x8F6 [Loop If]
    if(i < TraderItems.Length)
    {
        TraderItems[i].Target = GetWindowHandle((m_WindowName $ ".ListContainer.Item") $ getInstanceL2Util().makeZeroString(2, (i + 1)));
        TraderItems[i].item = GetItemWindowHandle(((m_WindowName $ ".ListContainer.Item") $ getInstanceL2Util().makeZeroString(2, (i + 1))) $ ".ItemSlot");
        TraderItems[i].ItemName = GetTextBoxHandle(((m_WindowName $ ".ListContainer.Item") $ getInstanceL2Util().makeZeroString(2, (i + 1))) $ ".ItemNameTxt");
        TraderItems[i].priceHeader = GetTextBoxHandle(((m_WindowName $ ".ListContainer.Item") $ getInstanceL2Util().makeZeroString(2, (i + 1))) $ ".PriceHeadTxt");
        TraderItems[i].Price = GetTextBoxHandle(((m_WindowName $ ".ListContainer.Item") $ getInstanceL2Util().makeZeroString(2, (i + 1))) $ ".PriceTxt");
        TraderItems[i].Count = GetTextBoxHandle(((m_WindowName $ ".ListContainer.Item") $ getInstanceL2Util().makeZeroString(2, (i + 1))) $ ".CountTxt");
        TraderItems[i].traderHeader = GetTextBoxHandle(((m_WindowName $ ".ListContainer.Item") $ getInstanceL2Util().makeZeroString(2, (i + 1))) $ ".TraderHeadTxt");
        TraderItems[i].traderName = GetTextBoxHandle(((m_WindowName $ ".ListContainer.Item") $ getInstanceL2Util().makeZeroString(2, (i + 1))) $ ".TraderTxt");
        TraderItems[i].CraftTreeButton = GetButtonHandle(((m_WindowName $ ".ListContainer.Item") $ getInstanceL2Util().makeZeroString(2, (i + 1))) $ ".btnCraftTree");
        TraderItems[i].RunOwnerButton = GetButtonHandle(((m_WindowName $ ".ListContainer.Item") $ getInstanceL2Util().makeZeroString(2, (i + 1))) $ ".btnGotoOwner");
        TraderItems[i].txHighlight = GetTextureHandle(((m_WindowName $ ".ListContainer.Item") $ getInstanceL2Util().makeZeroString(2, (i + 1))) $ ".txHighlight");
        TraderItems[i].txHighlight.SetAlpha(0);
        TraderItems[i].RunOwnerButton.HideWindow();
        TraderItems[i].Target.HideWindow();
        i++;
        // [Loop Continue]
        goto J0x478;
    }
    initPaginator();
    initTypeButtonValues();
    setViewportNPC();
    stopTalk();
    stopIdle();
    setMinAlphaAllSingleButtons(0.0000000);
    setMinAlphaAllTypeButtons(0.0000000);
    SetSortButtonTooltip(true);
    currentBrokerGeneralType = 0;
    currentButtonType = 0;
    currentWindowType = 0;
    changeWindowState(currentWindowType, true);
    return;
}

function initTypeButtonValues()
{
    TypeButtons[0].SetButtonValue(0);
    TypeButtons[1].SetButtonValue(1);
    TypeButtons[2].SetButtonValue(5);
    TypeButtons[3].SetButtonValue(9);
    TypeButtons[4].SetButtonValue(13);
    TypeButtons[5].SetButtonValue(14);
    TypeButtons[6].SetButtonValue(15);
    TypeButtons[7].SetButtonValue(16);
    TypeButtons[8].SetButtonValue(17);
    TypeButtons[9].SetButtonValue(18);
    TypeButtons[10].SetButtonValue(19);
    TypeButtons[11].SetButtonValue(20);
    return;
}

function initPaginator()
{
    Paginator = new Class'Interface.Paginator';
    Paginator.SetPaginatorElement(GetTextBoxHandle(m_WindowName $ ".PaginationContainer.currPageTxt"), GetTextBoxHandle(m_WindowName $ ".PaginationContainer.totalPageTxt"), GetButtonHandle(m_WindowName $ ".PaginationContainer.BtnViewNext"), GetButtonHandle(m_WindowName $ ".PaginationContainer.BtnViewPre"), GetButtonHandle(m_WindowName $ ".PaginationContainer.BtnViewPreEnd"), GetButtonHandle(m_WindowName $ ".PaginationContainer.BtnViewNextEnd"));
    Paginator.__onPageNext__Delegate = handlePageNext;
    Paginator.__onPagePrev__Delegate = handlePagePrev;
    return;
}

function OnShow()
{
    changeWindowState(0, true);
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    return;
}

function OnHide()
{
    stopTalk();
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(3550);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1A
    if(Event_ID == 3550)
    {
        _OnEvent(param);
    }
    return;
}

function _OnEvent(string param)
{
    local int Event_ID;

    ParseInt(param, "EventID", Event_ID);
    switch(Event_ID)
    {
        // End:0x43
        case 1053:
            changeWindowState(0, true);
            Me.ShowWindow();
            // End:0x8B
            break;
        // End:0x59
        case 1050:
            setButtons(param);
            // End:0x8B
            break;
        // End:0x6F
        case 1051:
            handleList(param);
            // End:0x8B
            break;
        // End:0x85
        case 1052:
            handleList(param);
            // End:0x8B
            break;
        // End:0xFFFF
        default:
            // End:0x8B
            break;
            break;
    }
    return;
}

function OnTimer(int TimerID)
{
    Me.KillTimer(TimerID);
    // End:0x2C
    if(TimerID == 1001)
    {
        setTalk();        
    }
    else
    {
        // End:0x45
        if(TimerID == 1002)
        {
            setIdle(true);            
        }
        else
        {
            // End:0x63
            if(TimerID == 1003)
            {
                TypePopupWnd.HideWindow();
            }
        }
    }
    return;
}

function getTargetSlotInfo(int Index, out ItemInfo ItemInfo, out int UserID)
{
    TraderItems[Index].item.GetItem(0, ItemInfo);
    UserID = TraderItems[Index].RunOwnerButton.GetButtonValue();
    return;
}

event OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local string WindowName;
    local int Index, UserID;

    WindowName = a_WindowHandle.GetWindowName();
    // End:0xC6
    if(InStr(WindowName, "Item0") > -1)
    {
        Index = int(Locs(WindowName, "Item0", "", true));
        getTargetSlotInfo(Index - 1, targetInfo.targetSlotItem, targetInfo.targetSlotUserId);
        // End:0x84
        if(bSearchInside)
        {
            requestMoveToTrader(targetInfo.targetSlotUserId);            
        }
        else
        {
            bSearchInside = true;
            currentPage = Paginator.getCurrentPage();
            requestBrokerSearchSpecificItem(targetInfo.targetSlotItem.Id.ClassID, currentBrokerGeneralType, currentButtonType, 1);
        }
    }
    return;
}

function OnClickButtonWithHandle(ButtonHandle a_ButtonHandle)
{
    // End:0xA1
    if((InStr(a_ButtonHandle.GetWindowName(), "btnType") > -1) || InStr(a_ButtonHandle.GetWindowName(), "btnSpecialType") > -1)
    {
        currentButtonType = a_ButtonHandle.GetButtonValue();
        requestBrokerSpecificList(currentBrokerGeneralType, currentButtonType, 1, nCurSortType);
        switch(currentBrokerGeneralType)
        {
            // End:0x88
            case 1:
            // End:0x90
            case 2:
                // End:0x9E
                break;
            // End:0x98
            case 3:
                // End:0x9E
                break;
            // End:0xFFFF
            default:
                // End:0x9E
                break;
                break;
        }        
    }
    else
    {
        // End:0xEF
        if(a_ButtonHandle.GetWindowName() == "btnCraftTree")
        {
            ExecuteEvent(810, "RecipeID=" $ string(a_ButtonHandle.GetButtonValue()));            
        }
        else
        {
            // End:0x126
            if(a_ButtonHandle.GetWindowName() == "btnGotoOwner")
            {
                requestMoveToTrader(a_ButtonHandle.GetButtonValue());
            }
        }
    }
    return;
}

function OnClickButton(string strID)
{
    // End:0x1D
    if(strID == "BtnBuy")
    {
        requestBrokerMainPage(1);        
    }
    else
    {
        // End:0x3B
        if(strID == "BtnSell")
        {
            requestBrokerMainPage(2);            
        }
        else
        {
            // End:0x60
            if(strID == "BtnManifacture")
            {
                requestBrokerMainPage(3);                
            }
            else
            {
                // End:0xA5
                if(strID == "btnSearch")
                {
                    currentSearchLine = EditBoxSearch.GetString();
                    requestBrokerSearchList(currentSearchLine, currentBrokerGeneralType, 0, 1, nCurSortType);                    
                }
                else
                {
                    // End:0xC2
                    if(strID == "btnSort")
                    {
                        SetSortButtonTooltip(false);                        
                    }
                    else
                    {
                        // End:0xDE
                        if(strID == "btnBack")
                        {
                            handleBackButton();                            
                        }
                        else
                        {
                            // End:0x107
                            if(strID == "BtnViewNext")
                            {
                                Paginator.setNextPage();                                
                            }
                            else
                            {
                                // End:0x12F
                                if(strID == "BtnViewPre")
                                {
                                    Paginator.setPrevPage();                                    
                                }
                                else
                                {
                                    // End:0x15B
                                    if(strID == "BtnViewNextEnd")
                                    {
                                        Paginator.setMaxPage();                                        
                                    }
                                    else
                                    {
                                        // End:0x183
                                        if(strID == "BtnViewPreEnd")
                                        {
                                            Paginator.setMinPage();
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

function handlePageNext()
{
    local int page;

    page = Paginator.getCurrentPage();
    // End:0x2B
    if(!bSearchInside)
    {
        currentPage = page;
    }
    // End:0x5D
    if(bSearchInside)
    {
        requestBrokerSearchSpecificItem(targetInfo.targetSlotItem.Id.ClassID, currentBrokerGeneralType, currentButtonType, page);
    }
    // End:0x87
    if(Len(currentSearchLine) <= 0)
    {
        requestBrokerSpecificList(currentBrokerGeneralType, currentButtonType, page, nCurSortType);        
    }
    else
    {
        requestBrokerSearchList(currentSearchLine, currentBrokerGeneralType, 0, page, nCurSortType);
    }
    return;
}

function handlePagePrev()
{
    local int page;

    page = Paginator.getCurrentPage();
    // End:0x2B
    if(!bSearchInside)
    {
        currentPage = page;
    }
    // End:0x5D
    if(bSearchInside)
    {
        requestBrokerSearchSpecificItem(targetInfo.targetSlotItem.Id.ClassID, currentBrokerGeneralType, currentButtonType, page);
    }
    // End:0x87
    if(Len(currentSearchLine) <= 0)
    {
        requestBrokerSpecificList(currentBrokerGeneralType, currentButtonType, page, nCurSortType);        
    }
    else
    {
        requestBrokerSearchList(currentSearchLine, currentBrokerGeneralType, 0, page, nCurSortType);
    }
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x31
    if(EditBoxSearch.IsFocused())
    {
        // End:0x31
        if(int(nKey) == 13)
        {
            OnClickButton("btnSearch");
        }
    }
    return;
}

event OnMouseOver(WindowHandle W)
{
    local int SlotIndex;
    local string targetWindowName;
    local ButtonHandle targetButton;
    local int Width, C;

    targetWindowName = W.GetWindowName();
    // End:0x47
    if(isSingleButtons(W))
    {
        setMinAlphaAllSingleButtons(0.2000000);
        W.SetAlpha(255, 0.1500000);        
    }
    else
    {
        // End:0x80
        if(InStr(targetWindowName, "Item0") > -1)
        {
            SlotIndex = int(Right(targetWindowName, 1)) - 1;
            handleShowHighlightTargetTradeSlot(SlotIndex);            
        }
        else
        {
            // End:0xBE
            if(isProvokeHighlight(targetWindowName))
            {
                SlotIndex = int(Right(getOwnerWindowName(W.m_WindowNameWithFullPath), 1)) - 1;
                handleShowHighlightTargetTradeSlot(SlotIndex);                
            }
            else
            {
                // End:0x226
                if(InStr(targetWindowName, "btnType") > -1)
                {
                    setMinAlphaAllTypeButtons(0.2000000);
                    targetButton = GetButtonHandle((m_WindowName $ ".MainPageContainer.") $ targetWindowName);
                    targetButton.SetAlpha(255, 0.1500000);
                    // End:0x223
                    if((int(currentBrokerGeneralType) == 1) || int(currentBrokerGeneralType) == 2)
                    {
                        switch(byte(targetButton.GetButtonValue()))
                        {
                            // End:0x15D
                            case 1:
                            // End:0x162
                            case 5:
                            // End:0x167
                            case 9:
                            // End:0x21D
                            case 20:
                                targetButton.GetWindowSize(Width, Width);
                                // End:0x192
                                if(Width <= 1)
                                {
                                    return;
                                }
                                Me.KillTimer(1003);
                                setSpecialTypeButtonByTargetType(byte(targetButton.GetButtonValue()));
                                TypePopupWnd.SetAnchor((m_WindowName $ ".MainPageContainer.") $ targetWindowName, "TopCenter", "BottomCenter", 0, 8);
                                TypePopupWnd.ShowWindow();
                                // End:0x223
                                break;
                            // End:0xFFFF
                            default:
                                // End:0x223
                                break;
                                break;
                        }
                    }                    
                }
                else
                {
                    // End:0x275
                    if((targetWindowName == "TypePopupWnd") || InStr(targetWindowName, "btnSpecialType") > -1)
                    {
                        Me.KillTimer(1003);
                    }
                }
            }
        }
    }
    return;
}

event OnMouseOut(WindowHandle W)
{
    local int SlotIndex;
    local string targetWindowName;
    local ButtonHandle targetButton;

    targetWindowName = W.GetWindowName();
    // End:0x31
    if(isSingleButtons(W))
    {
        setMinAlphaAllSingleButtons(0.2000000);        
    }
    else
    {
        // End:0x6A
        if(InStr(targetWindowName, "Item0") > -1)
        {
            SlotIndex = int(Right(targetWindowName, 1)) - 1;
            handleHideHighlightTargetTradeSlot(SlotIndex);            
        }
        else
        {
            // End:0xA8
            if(isProvokeHighlight(targetWindowName))
            {
                SlotIndex = int(Right(getOwnerWindowName(W.m_WindowNameWithFullPath), 1)) - 1;
                handleHideHighlightTargetTradeSlot(SlotIndex);                
            }
            else
            {
                // End:0x176
                if(InStr(targetWindowName, "btnType") > -1)
                {
                    setMinAlphaAllTypeButtons(0.2000000);
                    // End:0x173
                    if((int(currentBrokerGeneralType) == 1) || int(currentBrokerGeneralType) == 2)
                    {
                        targetButton = GetButtonHandle((m_WindowName $ ".MainPageContainer.") $ targetWindowName);
                        switch(byte(targetButton.GetButtonValue()))
                        {
                            // End:0x131
                            case 1:
                            // End:0x136
                            case 5:
                            // End:0x13B
                            case 9:
                            // End:0x16D
                            case 20:
                                Me.KillTimer(1003);
                                Me.SetTimer(1003, 25);
                                // End:0x173
                                break;
                            // End:0xFFFF
                            default:
                                // End:0x173
                                break;
                                break;
                        }
                    }                    
                }
                else
                {
                    // End:0x1E6
                    if((InStr(targetWindowName, "btnSpecialType") > -1) || targetWindowName == "TypePopupWnd")
                    {
                        setMinAlphaAllTypeButtons(0.2000000);
                        Me.KillTimer(1003);
                        Me.SetTimer(1003, 25);
                    }
                }
            }
        }
    }
    return;
}

function handleBackButton()
{
    switch(currentWindowType)
    {
        // End:0x80
        case 2:
            // End:0x66
            if(bSearchInside)
            {
                // End:0x41
                if(Len(currentSearchLine) > 0)
                {
                    requestBrokerSearchList(currentSearchLine, currentBrokerGeneralType, 0, currentPage, nCurSortType);                    
                }
                else
                {
                    requestBrokerSpecificList(currentBrokerGeneralType, currentButtonType, currentPage, nCurSortType);
                }
                bSearchInside = false;                
            }
            else
            {
                changeWindowState(1, true);
                currentButtonType = 0;
                currentPage = 1;
            }
            // End:0x97
            break;
        // End:0x91
        case 1:
            changeWindowState(0, true);
            // End:0x97
            break;
        // End:0xFFFF
        default:
            // End:0x97
            break;
            break;
    }
    return;
}

function setSpecialTypeButtonByTargetType(NPCBrokerAPI.BrokerButtonTypes targetButtonType)
{
    SpecialTypeButtons[0].ShowWindow();
    SpecialTypeButtons[1].ShowWindow();
    SpecialTypeButtons[2].ShowWindow();
    switch(targetButtonType)
    {
        // End:0xE4
        case 1:
            SpecialTypeButtons[0].SetButtonValue(2);
            SpecialTypeButtons[1].SetButtonValue(3);
            SpecialTypeButtons[2].SetButtonValue(4);
            SpecialTypeButtons[0].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7737)));
            SpecialTypeButtons[1].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7738)));
            SpecialTypeButtons[2].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7739)));
            // End:0x2C0
            break;
        // End:0x18D
        case 5:
            SpecialTypeButtons[0].SetButtonValue(6);
            SpecialTypeButtons[1].SetButtonValue(7);
            SpecialTypeButtons[2].SetButtonValue(8);
            SpecialTypeButtons[0].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7740)));
            SpecialTypeButtons[1].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7741)));
            SpecialTypeButtons[2].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7742)));
            // End:0x2C0
            break;
        // End:0x236
        case 9:
            SpecialTypeButtons[0].SetButtonValue(10);
            SpecialTypeButtons[1].SetButtonValue(11);
            SpecialTypeButtons[2].SetButtonValue(12);
            SpecialTypeButtons[0].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7743)));
            SpecialTypeButtons[1].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7744)));
            SpecialTypeButtons[2].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7745)));
            // End:0x2C0
            break;
        // End:0x2BA
        case 20:
            SpecialTypeButtons[0].SetButtonValue(21);
            SpecialTypeButtons[1].SetButtonValue(22);
            SpecialTypeButtons[2].HideWindow();
            SpecialTypeButtons[0].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(8081)));
            SpecialTypeButtons[1].SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(8082)));
            // End:0x2C0
            break;
        // End:0xFFFF
        default:
            // End:0x2C0
            break;
            break;
    }
    return;
}

function changeWindowState(NPCBrokerAPI.WindowStateType State, optional bool bIm)
{
    local ItemInfo noneInfo;

    // End:0x20
    if(!bIm)
    {
        // End:0x20
        if(int(currentWindowType) == int(State))
        {
            return;
        }
    }
    previousWindowType = currentWindowType;
    currentWindowType = State;
    stopTalk();
    stopIdle();
    TypePopupWnd.HideWindow();
    targetInfo = noneTargetInfo;
    bSearchInside = false;
    switch(currentWindowType)
    {
        // End:0xF1
        case 0:
            currentBrokerGeneralType = 0;
            currentButtonType = 0;
            currentBrokerItemsList.Remove(0, currentBrokerItemsList.Length);
            currentSearchLine = "";
            setMinAlphaAllSingleButtons(0.0000000);
            setViewportNPC();
            setTalk();
            setIdle(false);
            ListContainer.HideWindow();
            MainPageContainer.HideWindow();
            btnBack.HideWindow();
            SelectContainer.ShowWindow();
            // End:0x1ED
            break;
        // End:0x18E
        case 1:
            setMinAlphaAllTypeButtons(0.0000000);
            currentSearchLine = "";
            currentBrokerItemsList.Remove(0, currentBrokerItemsList.Length);
            EditBoxSearch.Clear();
            txtTypeHead.SetText(getTypeHeaderString());
            texMainBackAdena.SetTexture(getAdenaBackTexture());
            SelectContainer.HideWindow();
            ListContainer.HideWindow();
            btnBack.ShowWindow();
            MainPageContainer.ShowWindow();
            // End:0x1ED
            break;
        // End:0x1E7
        case 2:
            texBackAdena.SetTexture(getAdenaBackTexture());
            SelectContainer.HideWindow();
            MainPageContainer.HideWindow();
            btnBack.ShowWindow();
            ListContainer.ShowWindow();
            // End:0x1ED
            break;
        // End:0xFFFF
        default:
            // End:0x1ED
            break;
            break;
    }
    Me.SetWindowTitle(getWindowTitleStringByGeneralType(currentBrokerGeneralType));
    return;
}

function setButtons(string param)
{
    local int i, nType, nWidth, nHeight;
    local string Param1;
    local array<string> paramData;

    ParseInt(param, "ask", nType);
    ParseString(param, "param1", Param1);
    previousBrokerGeneralType = currentBrokerGeneralType;
    currentBrokerGeneralType = byte(nType);
    TypeButtons[0].SetButtonValue(0);
    TypeButtons[1].SetButtonValue(1);
    TypeButtons[2].SetButtonValue(5);
    TypeButtons[3].SetButtonValue(9);
    TypeButtons[4].SetButtonValue(13);
    TypeButtons[5].SetButtonValue(14);
    TypeButtons[6].SetButtonValue(15);
    TypeButtons[7].SetButtonValue(16);
    TypeButtons[8].SetButtonValue(17);
    TypeButtons[9].SetButtonValue(18);
    TypeButtons[10].SetButtonValue(19);
    TypeButtons[11].SetButtonValue(20);
    paramData = Arr(Param1, ",");
    hideAllTypeButtons();
    // End:0x1D7
    if(paramData.Length > 0)
    {
        i = 0;
        J0x15E:

        // End:0x1CF [Loop If]
        if(i < paramData.Length)
        {
            switch(byte(int(paramData[i])))
            {
                // End:0x193
                case 0:
                    nWidth = 146 * 2;
                    // End:0x1A1
                    break;
                // End:0xFFFF
                default:
                    nWidth = 146;
                    // End:0x1A1
                    break;
                    break;
            }
            TypeButtons[int(paramData[i])].SetWindowSize(nWidth, 29);
            i++;
            // [Loop Continue]
            goto J0x15E;
        }
        changeWindowState(1);
    }
    return;
}

function handleList(string param)
{
    local int i, nPage, nMaxPage, ItemID, UserID, enchantLevel;

    local INT64 Price;
    local string paramLine, attrLine, nameLine;
    local array<string> paramData, BrokerData, attrData, nameData, attrInfo, nameInfo;

    local BrokerItemData tmpBrokerItemData, clearBrokerItemData;
    local array<BrokerItemData> BrokerItemDatas;
    local BrokerAttrItem BrokerAttrItemData, clearBrokerAttrItemData;
    local array<BrokerAttrItem> BrokerAttrItemDatas;

    ParseInt(param, "ask", nPage);
    ParseInt(param, "reply", nMaxPage);
    ParseString(param, "param1", paramLine);
    ParseString(param, "param2", attrLine);
    ParseString(param, "param3", nameLine);
    nameData = Arr(nameLine, ";");
    attrData = Arr(attrLine, ";");
    // End:0x19D
    if(attrData.Length > 0)
    {
        BrokerAttrItemDatas.Length = 0;
        i = 0;
        J0xB7:

        // End:0x19D [Loop If]
        if(i < attrData.Length)
        {
            attrInfo = Arr(attrData[i], ",");
            BrokerAttrItemData.nType = int(attrInfo[0]);
            BrokerAttrItemData.Value = int(attrInfo[1]);
            BrokerAttrItemDatas[BrokerAttrItemDatas.Length] = BrokerAttrItemData;
            BrokerAttrItemData.nType = int(attrInfo[2]);
            BrokerAttrItemData.Value = int(attrInfo[3]);
            BrokerAttrItemDatas[BrokerAttrItemDatas.Length] = BrokerAttrItemData;
            BrokerAttrItemData.nType = int(attrInfo[4]);
            BrokerAttrItemData.Value = int(attrInfo[5]);
            BrokerAttrItemDatas[BrokerAttrItemDatas.Length] = BrokerAttrItemData;
            i++;
            // [Loop Continue]
            goto J0xB7;
        }
    }
    paramData = Arr(paramLine, ";");
    // End:0x3AA
    if(paramData.Length > 0)
    {
        i = 0;
        J0x1C4:

        // End:0x37B [Loop If]
        if(i < paramData.Length)
        {
            tmpBrokerItemData = clearBrokerItemData;
            BrokerData = Arr(paramData[i], ",");
            tmpBrokerItemData.attr[0] = BrokerAttrItemDatas[(i * 3) + 0];
            tmpBrokerItemData.attr[1] = BrokerAttrItemDatas[(i * 3) + 1];
            tmpBrokerItemData.attr[2] = BrokerAttrItemDatas[(i * 3) + 2];
            switch(currentBrokerGeneralType)
            {
                // End:0x264
                case 1:
                // End:0x2E9
                case 2:
                    tmpBrokerItemData.ItemID = int(BrokerData[0]);
                    tmpBrokerItemData.Price = (BrokerData[1]);
                    tmpBrokerItemData.Count = (BrokerData[2]);
                    tmpBrokerItemData.enchantLevel = int(BrokerData[3]);
                    tmpBrokerItemData.UserID = int(BrokerData[4]);
                    tmpBrokerItemData.Username = nameData[i];
                    // End:0x35F
                    break;
                // End:0x359
                case 3:
                    tmpBrokerItemData.ItemID = int(BrokerData[0]);
                    tmpBrokerItemData.Price = (BrokerData[1]);
                    tmpBrokerItemData.RecipeID = int(BrokerData[2]);
                    tmpBrokerItemData.UserID = int(BrokerData[3]);
                    tmpBrokerItemData.Username = nameData[i];
                    // End:0x35F
                    break;
                // End:0xFFFF
                default:
                    // End:0x35F
                    break;
                    break;
            }
            BrokerItemDatas[BrokerItemDatas.Length] = tmpBrokerItemData;
            i++;
            // [Loop Continue]
            goto J0x1C4;
        }
        Paginator.setPages(nPage, nMaxPage);
        setLIST(BrokerItemDatas);
        currentBrokerItemsList = BrokerItemDatas;
    }
    return;
}

function setLIST(array<BrokerItemData> BrokerItemDatas)
{
    local int i, j;
    local ItemInfo ItemInfo, clearItemInfo;
    local UserInfo UserInfo;
    local bool bIsBuySell;
    local int ItemID, Enchant, UserID, RecipeID;
    local INT64 Price, Count, myAdena;
    local string ItemName, OwnerName, ownerHeader, priceHeader, countHeader;

    local int recipeRate, itemInventoryCount;
    local Color priceColor;

    hideAllTradeItems();
    handleHideAllHighlightTargetTradeSlot();
    myAdena = GetAdena();
    // End:0x89A
    if(BrokerItemDatas.Length > 0)
    {
        i = 0;
        J0x2B:

        // End:0x892 [Loop If]
        if(i < BrokerItemDatas.Length)
        {
            // End:0x888
            if(BrokerItemDatas[i].ItemID > 0)
            {
                switch(currentBrokerGeneralType)
                {
                    // End:0x5D
                    case 1:
                    // End:0xF1
                    case 2:
                        ItemID = BrokerItemDatas[i].ItemID;
                        Price = BrokerItemDatas[i].Price;
                        Count = BrokerItemDatas[i].Count;
                        Enchant = BrokerItemDatas[i].enchantLevel;
                        UserID = BrokerItemDatas[i].UserID;
                        OwnerName = BrokerItemDatas[i].Username;
                        bIsBuySell = true;
                        // End:0x175
                        break;
                    // End:0x16F
                    case 3:
                        ItemID = BrokerItemDatas[i].ItemID;
                        Price = BrokerItemDatas[i].Price;
                        RecipeID = BrokerItemDatas[i].RecipeID;
                        UserID = BrokerItemDatas[i].UserID;
                        OwnerName = BrokerItemDatas[i].Username;
                        bIsBuySell = false;
                        // End:0x175
                        break;
                    // End:0xFFFF
                    default:
                        // End:0x175
                        break;
                        break;
                }
                ItemInfo = clearItemInfo;
                GetItemInfoByClassID(ItemID, ItemInfo);
                getListHeadersByGeneralType(ownerHeader, countHeader, priceHeader);
                ItemName = GetItemName(ItemInfo);
                priceColor = GetNumericColor((Price));
                ItemInfo.Reserved = 777;
                // End:0x4DC
                if(bIsBuySell)
                {
                    ItemInfo.Enchanted = Enchant;
                    // End:0x250
                    if(IsEnchantableItem(byte(ItemInfo.ItemType)))
                    {
                        ItemInfo.IconPanel = "IconBig.icon_panel.enchant_panel_" $ getInstanceL2Util().makeZeroString(2, (Enchant));
                    }
                    // End:0x2A7
                    if(ItemInfo.ItemType == 0)
                    {
                        ItemInfo.AttackAttributeType = BrokerItemDatas[i].attr[0].nType;
                        ItemInfo.AttackAttributeValue = BrokerItemDatas[i].attr[0].Value;                        
                    }
                    else
                    {
                        j = 0;
                        J0x2AE:

                        // End:0x4BF [Loop If]
                        if(j < 3)
                        {
                            switch(BrokerItemDatas[i].attr[j].nType)
                            {
                                // End:0x325
                                case 0:
                                    // End:0x322
                                    if(BrokerItemDatas[i].attr[j].Value > 0)
                                    {
                                        ItemInfo.DefenseAttributeValueFire = BrokerItemDatas[i].attr[j].Value;
                                    }
                                    // End:0x4B5
                                    break;
                                // End:0x373
                                case 1:
                                    // End:0x370
                                    if(BrokerItemDatas[i].attr[j].Value > 0)
                                    {
                                        ItemInfo.DefenseAttributeValueWater = BrokerItemDatas[i].attr[j].Value;
                                    }
                                    // End:0x4B5
                                    break;
                                // End:0x3C2
                                case 2:
                                    // End:0x3BF
                                    if(BrokerItemDatas[i].attr[j].Value > 0)
                                    {
                                        ItemInfo.DefenseAttributeValueWind = BrokerItemDatas[i].attr[j].Value;
                                    }
                                    // End:0x4B5
                                    break;
                                // End:0x411
                                case 3:
                                    // End:0x40E
                                    if(BrokerItemDatas[i].attr[j].Value > 0)
                                    {
                                        ItemInfo.DefenseAttributeValueEarth = BrokerItemDatas[i].attr[j].Value;
                                    }
                                    // End:0x4B5
                                    break;
                                // End:0x460
                                case 4:
                                    // End:0x45D
                                    if(BrokerItemDatas[i].attr[j].Value > 0)
                                    {
                                        ItemInfo.DefenseAttributeValueHoly = BrokerItemDatas[i].attr[j].Value;
                                    }
                                    // End:0x4B5
                                    break;
                                // End:0x4AF
                                case 5:
                                    // End:0x4AC
                                    if(BrokerItemDatas[i].attr[j].Value > 0)
                                    {
                                        ItemInfo.DefenseAttributeValueUnholy = BrokerItemDatas[i].attr[j].Value;
                                    }
                                    // End:0x4B5
                                    break;
                                // End:0xFFFF
                                default:
                                    // End:0x4B5
                                    break;
                                    break;
                            }
                            j++;
                            // [Loop Continue]
                            goto J0x2AE;
                        }
                    }
                    TraderItems[i].CraftTreeButton.HideWindow();                    
                }
                else
                {
                    getRecipeData(RecipeID, recipeRate, Count);
                    ItemName = ((ItemName @ "(") $ string(recipeRate)) $ "%)";
                    ItemInfo.ItemNum = Count;
                    ItemInfo.IconPanel = "IconBig.icon_panel.craft_panel_i00";
                    TraderItems[i].CraftTreeButton.SetButtonValue(RecipeID);
                    TraderItems[i].CraftTreeButton.ShowWindow();
                }
                TraderItems[i].RunOwnerButton.SetButtonValue(UserID);
                // End:0x605
                if((int(currentBrokerGeneralType) == 1) || int(currentBrokerGeneralType) == 3)
                {
                    // End:0x602
                    if(__NFUN_409__(Price, myAdena))
                    {
                        ItemInfo.ForeTexture = "L2UI_CT1.MagicSkillWnd.skillLock";
                    }                    
                }
                else
                {
                    // End:0x688
                    if(int(currentBrokerGeneralType) == 2)
                    {
                        itemInventoryCount = name(InventoryWnd(GetScript("InventoryWnd")).getItemCountByClassID(ItemInfo.Id.ClassID));
                        // End:0x685
                        if(itemInventoryCount < 1)
                        {
                            ItemInfo.ForeTexture = "L2UI_CT1.MagicSkillWnd.skillLock";
                        }                        
                    }
                    else
                    {
                        ItemInfo.ForeTexture = "";
                    }
                }
                TraderItems[i].traderHeader.SetText(ownerHeader);
                TraderItems[i].traderName.SetText(OwnerName);
                TraderItems[i].priceHeader.SetText(priceHeader);
                TraderItems[i].Price.SetText(MakeCostStringINT64(Price) @ GetSystemString(469));
                TraderItems[i].Price.SetTextColor(priceColor);
                TraderItems[i].ItemName.SetText(ItemName);
                TraderItems[i].Count.SetText((countHeader @ MakeCostStringINT64(Count)) @ GetSystemString(7748));
                TraderItems[i].traderName.SetAnchor(TraderItems[i].traderHeader.m_WindowNameWithFullPath, "TopRight", "TopLeft", 3, 0);
                TraderItems[i].Price.SetAnchor(TraderItems[i].priceHeader.m_WindowNameWithFullPath, "TopRight", "TopLeft", 3, 0);
                TraderItems[i].Target.SetTooltipCustomType(getItemTooltip(ItemInfo));
                insertItem(TraderItems[i].item, ItemInfo);
                TraderItems[i].Target.ShowWindow();
            }
            i++;
            // [Loop Continue]
            goto J0x2B;
        }
        changeWindowState(2);
    }
    return;
}

function string insertItem(ItemWindowHandle Target, ItemInfo Info)
{
    // End:0x2E
    if(!Target.SetItem(0, Info))
    {
        Target.AddItem(Info);
    }
    return;
}

function string getRecipeData(int RecipeID, out int recipeRate, out INT64 Count)
{
    recipeRate = Class'NWindow.UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
    Count = (Class'NWindow.UIDATA_RECIPE'.static.GetRecipeProductNum(RecipeID));
    return;
}

function string GetUserName(UserInfo Info)
{
    // End:0x25
    if(Info.Name == "")
    {
        Info.Name = "Unnamed";
    }
    return Info.Name;
    return;
}

function string GetItemName(ItemInfo Info)
{
    Info.Name = GetItemNameAll(Info, true);
    // End:0x4A
    if(Len(Info.Name) > 23)
    {
        Info.Name = Left(Info.Name, 23) $ "...";
    }
    return Info.Name;
    return;
}

function setTalk()
{
    local int i, nTextLen;
    local string nText, currentText;

    // End:0x16
    if(!Me.IsShowWindow())
    {
        return;
    }
    currentText = GetSystemString(7733);
    nText = Left(GetSystemString(7733), nCurrentTextPos);
    // End:0x5A
    if(nCurrentTextPos == 1)
    {
        ObjectViewport.PlayAnimation(0);
    }
    txtBrokerHead.SetText(nText);
    // End:0x91
    if(Mid(currentText, nCurrentTextPos, 2) == "\\n")
    {
        nCurrentTextPos += 2;        
    }
    else
    {
        nCurrentTextPos++;
    }
    // End:0xD7
    if(nCurrentTextPos <= Len(GetSystemString(7733)))
    {
        Me.SetTimer(1001, 3100 / Len(GetSystemString(7733)));
    }
    return;
}

function stopTalk()
{
    // End:0x16
    if(!Me.IsShowWindow())
    {
        return;
    }
    nCurrentTextPos = 1;
    Me.KillTimer(1001);
    txtBrokerHead.SetText("");
    return;
}

function setIdle(bool bShowAnimation)
{
    // End:0x16
    if(!Me.IsShowWindow())
    {
        return;
    }
    // End:0x30
    if(bShowAnimation)
    {
        ObjectViewport.PlayAnimation(2);
    }
    Me.KillTimer(1002);
    Me.SetTimer(1002, 15000 + Rand(30000));
    return;
}

function stopIdle()
{
    Me.KillTimer(1002);
    return;
}

function setViewportNPC()
{
    ObjectViewport.SetNPCViewportData(32321);
    ObjectViewport.SpawnNPC();
    return;
}

function string getAdenaBackTexture()
{
    switch(currentBrokerGeneralType)
    {
        // End:0x0F
        case 0:
            return "";
        // End:0x14
        case 1:
        // End:0x51
        case 2:
            return "L2UI_EPIC.HtmlWnd.HtmlWnd_PremiumManagerWnd_Store_IMG";
        // End:0x94
        case 3:
            return "L2UI_EPIC.HtmlWnd.HtmlWnd_PremiumManagerWnd_ItemEnchant_IMG";
        // End:0xFFFF
        default:
            // End:0x9A
            break;
            break;
    }
    return;
}

function string getTypeHeaderString()
{
    switch(currentBrokerGeneralType)
    {
        // End:0x0F
        case 0:
            return "";
        // End:0x20
        case 1:
            return GetSystemString(7728);
        // End:0x31
        case 2:
            return GetSystemString(7729);
        // End:0x42
        case 3:
            return GetSystemString(7730);
        // End:0xFFFF
        default:
            // End:0x48
            break;
            break;
    }
    return;
}

function hideAllTypeButtons()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x4C [Loop If]
    if(i < 12)
    {
        TypeButtons[i].SetAlpha(255);
        TypeButtons[i].SetWindowSize(136, 0);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function setMinAlphaAllSingleButtons(float fAlphaSpeed)
{
    Main_sellBtn.SetAlpha(180, fAlphaSpeed);
    Main_buyBtn.SetAlpha(180, fAlphaSpeed);
    Main_manifactureBtn.SetAlpha(180, fAlphaSpeed);
    btnSearch.SetAlpha(180, fAlphaSpeed);
    btnBack.SetAlpha(180, fAlphaSpeed);
    return;
}

function setMinAlphaAllTypeButtons(float fAlphaSpeed)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x39 [Loop If]
    if(i < 12)
    {
        TypeButtons[i].SetAlpha(180, fAlphaSpeed);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function hideAllTradeItems()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x37 [Loop If]
    if(i < 7)
    {
        TraderItems[i].Target.HideWindow();
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function handleShowHighlightTargetTradeSlot(int Index)
{
    TraderItems[Index].txHighlight.SetAlpha(255, 0.2000000);
    return;
}

function handleHideHighlightTargetTradeSlot(int Index)
{
    TraderItems[Index].txHighlight.SetAlpha(0, 0.1000000);
    return;
}

function handleHideAllHighlightTargetTradeSlot()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(i < 7)
    {
        TraderItems[i].txHighlight.SetAlpha(0);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function getListHeadersByGeneralType(out string ownerHeader, out string countHeader, out string priceHeader)
{
    switch(currentBrokerGeneralType)
    {
        // End:0x42
        case 1:
            ownerHeader = GetSystemString(7732);
            countHeader = GetSystemString(7747);
            priceHeader = GetSystemString(7731);
            // End:0xBE
            break;
        // End:0x7D
        case 2:
            ownerHeader = GetSystemString(7754);
            countHeader = GetSystemString(7755);
            priceHeader = GetSystemString(7731);
            // End:0xBE
            break;
        // End:0xB8
        case 3:
            ownerHeader = GetSystemString(7750);
            countHeader = GetSystemString(7752);
            priceHeader = GetSystemString(7751);
            // End:0xBE
            break;
        // End:0xFFFF
        default:
            // End:0xBE
            break;
            break;
    }
    // End:0x11E
    if(!bSearchInside)
    {
        countHeader = GetSystemString(7758);
        switch(currentBrokerGeneralType)
        {
            // End:0xE6
            case 1:
            // End:0xFF
            case 2:
                priceHeader = GetSystemString(7759);
                // End:0x11E
                break;
            // End:0x118
            case 3:
                priceHeader = GetSystemString(7760);
                // End:0x11E
                break;
            // End:0xFFFF
            default:
                // End:0x11E
                break;
                break;
        }
    }
    return;
}

function bool isProvokeHighlight(string strID)
{
    switch(strID)
    {
        // End:0x14
        case "ItemSlot":
        // End:0x25
        case "btnCraftTree":
        // End:0x38
        case "btnGotoOwner":
            return true;
        // End:0xFFFF
        default:
            // End:0x3E
            break;
            break;
    }
    return;
}

function bool isSingleButtons(WindowHandle Target)
{
    switch(Target)
    {
        // End:0x0F
        case Main_sellBtn:
        // End:0x17
        case Main_buyBtn:
        // End:0x1F
        case Main_manifactureBtn:
        // End:0x27
        case btnSearch:
        // End:0x31
        case btnBack:
            return true;
        // End:0xFFFF
        default:
            // End:0x37
            break;
            break;
    }
    return;
}

function SetSortButtonTooltip(bool bInit)
{
    local Color b1, b2, b3, b4;
    local array<DrawItemInfo> drawListArr;

    b1 = getInstanceL2Util().Gray;
    b2 = getInstanceL2Util().Gray;
    b3 = getInstanceL2Util().Gray;
    b4 = getInstanceL2Util().Gray;
    // End:0x68
    if(bInit)
    {
        nCurSortType = 1;        
    }
    else
    {
        nCurSortType = byte(int(nCurSortType) + 1);
        // End:0x90
        if(int(nCurSortType) > 4)
        {
            nCurSortType = 1;
        }
    }
    btnSort.SetTexture("UI_BOHPTS.Broker.Sort_" $ string(nCurSortType), "UI_BOHPTS.Broker.Sort_" $ string(nCurSortType), "UI_BOHPTS.Broker.Sort_" $ string(nCurSortType));
    switch(nCurSortType)
    {
        // End:0x126
        case 1:
            b1 = getInstanceL2Util().Yellow;
            // End:0x1A0
            break;
        // End:0x143
        case 2:
            b2 = getInstanceL2Util().Yellow;
            // End:0x1A0
            break;
        // End:0x160
        case 3:
            b3 = getInstanceL2Util().Yellow;
            // End:0x1A0
            break;
        // End:0x17D
        case 4:
            b4 = getInstanceL2Util().Yellow;
            // End:0x1A0
            break;
        // End:0xFFFF
        default:
            nCurSortType = 1;
            b1 = getInstanceL2Util().Yellow;
            // End:0x1A0
            break;
            break;
    }
    drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(7762), b1, "", true, true);
    drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(7763), b2, "", true, true);
    drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(7764), b3, "", true, true);
    drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(7765), b4, "", true, true);
    btnSort.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
    return;
}
