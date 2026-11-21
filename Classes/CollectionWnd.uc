class CollectionWnd extends CollectionAPI;

var int keyGlowOpenCount;
var ItemInfo lastNotifyItem;
var int lastNotifyitemId;
var string m_WindowName;
var InventoryWnd Inventory;
var Paginator Paginator;
var int currentPage;
var int currentDialogIndex;
var array<_collectionData> filtredCollections;
var array<CollectionAPI.eKeyType> ItemTypeRestriction;
var CollectionAPI.eCollectionType currentCategory;
var WindowHandle Me;
var WindowHandle CollectionsListWnd;
var ListCtrlHandle CollectionsList;
var ButtonHandle ListBackBtn;
var EditBoxHandle searchWordBox;
var ComboBoxHandle TypeCrystalCBox;
var ComboBoxHandle TypeStatCBox;
var WindowHandle DisableWnd;
var TextBoxHandle CollectionHeadTxt;
var AnimTextureHandle Complete_Ani;
var TextureHandle Complete_Tx;
var WindowHandle AssignCollectionWnd;
var WindowHandle CollectionItemsWnd;
var TextureHandle CollectionSlotSelect;
var ItemWindowHandle AssignedCollection[6];
var TextureHandle SlotFaded[6];
var ButtonHandle SlotLockCommission[6];
var TextureHandle RightTypeTx;
var WindowHandle CollectionInventoryWnd;
var TextBoxHandle InventoryHeadTxt;
var TextBoxHandle CollectionOptionTxt[3];
var ItemWindowHandle AssignedInventory;
var ButtonHandle CollectionItemRegBtn;
var WindowHandle AssignDialogBody;
var TextBoxHandle AssignTargetItemNameTxt;
var TextBoxHandle NeeddedItemCountTxt;
var TextBoxHandle CurrentItemCountTxt;
var TextBoxHandle AssignDialogText;
var TextBoxHandle AssignDialogText2;
var TextBoxHandle AssignDialogReadingText;
var ItemWindowHandle AssignTargetItem;
var ButtonHandle AssignOKButton;
var WindowHandle CollectionStatusWnd;
var StatusBarHandle CollectionsDone;
var StatusBarHandle ItemsDone;
var TextureHandle CollectionsCircle;
var TextureHandle ItemsCircle;
var TextBoxHandle CollectionsTxt;
var TextBoxHandle ItemsTxt;
var TextBoxHandle CollectionsTotalTxt;
var TextBoxHandle CollectionsCompleteTxt;
var TextBoxHandle CollectionsInProgressTxt;
var TextBoxHandle CollectionsNotStartedTxt;
var TextBoxHandle ItemsTotalTxt;
var TextBoxHandle ItemsAssignedTxt;
var TextBoxHandle ItemsAvailableTxt;

function OnLoad()
{
    local int i;

    SetClosingOnESC();
    Inventory = InventoryWnd(GetScript("InventoryWnd"));
    m_WindowName = getCurrentWindowName(string(self));
    Me = GetWindowHandle(m_WindowName);
    CollectionsListWnd = GetWindowHandle(m_WindowName $ ".CollectionsListWnd");
    ListBackBtn = GetButtonHandle(m_WindowName $ ".ListBackBtn");
    CollectionsList = GetListCtrlHandle(m_WindowName $ ".CollectionsListWnd.ListWnd.CollectionsListCtrl");
    searchWordBox = GetEditBoxHandle(m_WindowName $ ".CollectionsListWnd.ListWnd.FilterContainer.searchWordBox");
    TypeCrystalCBox = GetComboBoxHandle(m_WindowName $ ".CollectionsListWnd.ListWnd.FilterContainer.TypeCrystalCBox");
    TypeStatCBox = GetComboBoxHandle(m_WindowName $ ".CollectionsListWnd.ListWnd.FilterContainer.TypeStatCBox");
    DisableWnd = GetWindowHandle(m_WindowName $ ".CollectionsListWnd.ListWnd.DisableWnd");
    CollectionStatusWnd = GetWindowHandle(m_WindowName $ ".CollectionStatusWnd");
    CollectionsDone = GetStatusBarHandle(m_WindowName $ ".CollectionStatusWnd.CollectionsDone");
    ItemsDone = GetStatusBarHandle(m_WindowName $ ".CollectionStatusWnd.ItemsDone");
    CollectionsCircle = GetTextureHandle(m_WindowName $ ".CollectionStatusWnd.CollectionsWnd.CollectionsCircle");
    ItemsCircle = GetTextureHandle(m_WindowName $ ".CollectionStatusWnd.ItemsWnd.ItemsCircle");
    CollectionsTxt = GetTextBoxHandle(m_WindowName $ ".CollectionStatusWnd.ItemsWnd.CollectionsTxt");
    ItemsTxt = GetTextBoxHandle(m_WindowName $ ".CollectionStatusWnd.ItemsWnd.ItemsTxt");
    CollectionsTotalTxt = GetTextBoxHandle(m_WindowName $ ".CollectionStatusWnd.CollectionsTotalTxt");
    CollectionsCompleteTxt = GetTextBoxHandle(m_WindowName $ ".CollectionStatusWnd.CollectionsCompleteTxt");
    CollectionsInProgressTxt = GetTextBoxHandle(m_WindowName $ ".CollectionStatusWnd.CollectionsInProgressTxt");
    CollectionsNotStartedTxt = GetTextBoxHandle(m_WindowName $ ".CollectionStatusWnd.CollectionsNotStartedTxt");
    ItemsTotalTxt = GetTextBoxHandle(m_WindowName $ ".CollectionStatusWnd.ItemsTotalTxt");
    ItemsAssignedTxt = GetTextBoxHandle(m_WindowName $ ".CollectionStatusWnd.ItemsAssignedTxt");
    ItemsAvailableTxt = GetTextBoxHandle(m_WindowName $ ".CollectionStatusWnd.ItemsAvailableTxt");
    AssignCollectionWnd = GetWindowHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd");
    CollectionHeadTxt = GetTextBoxHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionHeadTxt");
    CollectionInventoryWnd = GetWindowHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionItemsWnd.CollectionInventoryWnd");
    Complete_Ani = GetAnimTextureHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.Complete_Ani");
    Complete_Tx = GetTextureHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.Complete_Tx");
    CollectionItemRegBtn = GetButtonHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionItemsWnd.CollectionItemRegBtn");
    CollectionSlotSelect = GetTextureHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionItemsWnd.CollectionSlotSelect");
    RightTypeTx = GetTextureHandle(m_WindowName $ ".CollectionsListWnd.RightTypeTx");
    i = 0;
    J0x7C2:

    // End:0x96C [Loop If]
    if(i < 6)
    {
        AssignedCollection[i] = GetItemWindowHandle((((m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionItemsWnd.Collection0") $ string(i)) $ ".CollectionItem0") $ string(i));
        SlotFaded[i] = GetTextureHandle((((m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionItemsWnd.Collection0") $ string(i)) $ ".SlotFaded0") $ string(i));
        SlotLockCommission[i] = GetButtonHandle((((m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionItemsWnd.Collection0") $ string(i)) $ ".SlotLockCommission0") $ string(i));
        i++;
        // [Loop Continue]
        goto J0x7C2;
    }
    i = 0;
    J0x973:

    // End:0x9EB [Loop If]
    if(i < 3)
    {
        CollectionOptionTxt[i] = GetTextBoxHandle((m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionOptionTxt") $ string(i + 1));
        i++;
        // [Loop Continue]
        goto J0x973;
    }
    AssignedInventory = GetItemWindowHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionItemsWnd.CollectionInventoryWnd.InventoryItemsWnd.InventoryItems");
    InventoryHeadTxt = GetTextBoxHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionItemsWnd.CollectionInventoryWnd.InventoryHeadTxt");
    AssignDialogBody = GetWindowHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionInventoryWnd.AssignDialogBody");
    AssignTargetItemNameTxt = GetTextBoxHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionInventoryWnd.AssignDialogBody.AssignTargetItemNameTxt");
    NeeddedItemCountTxt = GetTextBoxHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionInventoryWnd.AssignDialogBody.NeeddedItemCountTxt");
    CurrentItemCountTxt = GetTextBoxHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionInventoryWnd.AssignDialogBody.CurrentItemCountTxt");
    AssignDialogText = GetTextBoxHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionInventoryWnd.AssignDialogBody.AssignDialogText");
    AssignDialogText2 = GetTextBoxHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionInventoryWnd.AssignDialogBody.AssignDialogText2");
    AssignDialogReadingText = GetTextBoxHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionInventoryWnd.AssignDialogBody.AssignDialogReadingText");
    AssignTargetItem = GetItemWindowHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionInventoryWnd.AssignDialogBody.AssignTargetItem");
    AssignOKButton = GetButtonHandle(m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionInventoryWnd.AssignDialogBody.AssignOKButton");
    AssignDialogBody.SetModal(true);
    initCollections();
    initPaginator();
    initFilters();
    killOpenGlowTimer();
    CollectionsList.SetSelectedSelTooltip(false);
    CollectionsList.SetAppearTooltipAtMouseX(true);
    NoticeWnd(GetScript("NoticeWnd")).__onCollectionNotifyClick__Delegate = onCollectionNotifyClick;
    return;
}

function OnShow()
{
    // End:0x34
    if(!SettingSectorBool("COLLECTION", "COLLECION_UI"))
    {
        Me.HideWindow();
    }
    EssenceMainDesc(GetScript("EssenceMainDesc")).CheckByType(5);
    startOpenGlowTimer();
    return;
}

function OnHide()
{
    initCollections();
    EssenceMainDesc(GetScript("EssenceMainDesc")).CheckByType(5);
    killOpenGlowTimer();
    return;
}

function startOpenGlowTimer()
{
    showKeyGlow(99, false, 0.3000000);
    Me.KillTimer(1001);
    Me.SetTimer(1001, int((0.3000000 * float(1000)) + float(25)));
    return;
}

function killOpenGlowTimer()
{
    keyGlowOpenCount = 0;
    Me.KillTimer(1001);
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
        // End:0x37
        case 1103:
            initCollections();
            handleShow();
            // End:0x95
            break;
        // End:0x4D
        case 1104:
            handleCollectableItemNotify(param);
            // End:0x95
            break;
        // End:0x63
        case 1100:
            handleCollectionListPageInfo(param);
            // End:0x95
            break;
        // End:0x79
        case 1101:
            handleCollectionRegistrationUpdate(param);
            // End:0x95
            break;
        // End:0x8F
        case 1102:
            handleCollectionStatus(param);
            // End:0x95
            break;
        // End:0xFFFF
        default:
            // End:0x95
            break;
            break;
    }
    return;
}

function OnTimer(int TimerID)
{
    local ItemInfo collectionItem;

    // End:0x56
    if(TimerID == 1001)
    {
        // End:0x23
        if(keyGlowOpenCount >= 3)
        {
            killOpenGlowTimer();
            return;
        }
        // End:0x41
        if((float(keyGlowOpenCount) % float(2)) == float(0))
        {
            hideKeyGlow();            
        }
        else
        {
            showKeyGlow(99, false, 0.3000000);
        }
        keyGlowOpenCount++;
    }
    // End:0xE9
    if(TimerID == 1002)
    {
        Me.KillTimer(1002);
        NoticeWnd(GetScript("NoticeWnd")).removeNoticeButton(26);
        // End:0xE9
        if(Class'NWindow.UIDATA_INVENTORY'.static.FindItem(lastNotifyitemId, collectionItem))
        {
            lastNotifyItem = collectionItem;
            NoticeWnd(GetScript("NoticeWnd")).createNoticeButton(26, 7908);
        }
    }
    return;
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
    switch(a_WindowHandle)
    {
        // End:0x19
        case Complete_Ani:
            setCompleteCollectionAni(true);
            // End:0x1F
            break;
        // End:0xFFFF
        default:
            // End:0x1F
            break;
            break;
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    // End:0x20
    if(strID == "InventoryItems")
    {
        checkDialogButtons();
    }
    return;
}

function OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
    local int SlotIndex;
    local ItemInfo item;

    // End:0x168
    if(InStr(a_hItemWindow.GetWindowName(), "CollectionItem") > -1)
    {
        // End:0x168
        if(a_hItemWindow.GetItem(a_Index, item))
        {
            // End:0x94
            if(int(byte(item.Reserved)) == 2)
            {
                getInstanceL2Util().showGfxScreenMessage(GetSystemString(7860));
                getInstanceL2Util().showGfxScreenMessage(GetSystemString(7861));
                return;
            }
            SlotIndex = int(Locs(a_hItemWindow.GetWindowName(), "CollectionItem", "", true));
            currentDialogIndex = SlotIndex;
            CollectionSlotSelect.ShowWindow();
            CollectionSlotSelect.SetAnchor((m_WindowName $ ".CollectionsListWnd.AssignCollectionWnd.CollectionItemsWnd.Collection0") $ string(SlotIndex), "TopLeft", "TopLeft", -5, -4);
            showAvailableInventoryItemsByCollectionItem(item);
        }
    }
    return;
}

function OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
    local int SlotIndex;
    local ItemInfo item;

    // End:0x7A
    if(InStr(a_hItemWindow.GetWindowName(), "InventoryItems") > -1)
    {
        // End:0x7A
        if(a_hItemWindow.GetItem(a_Index, item))
        {
            // End:0x6F
            if(!checkAdena())
            {
                getInstanceL2Util().showGfxScreenMessage(GetSystemString(7913));
                return;
            }
            registrationConfirmDialog(item);
        }
    }
    return;
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
    switch(ListCtrlID)
    {
        // End:0x28
        case "CollectionsListCtrl":
            handleCollectionAssignDialog();
            // End:0x2E
            break;
        // End:0xFFFF
        default:
            // End:0x2E
            break;
            break;
    }
    return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
    switch(strID)
    {
        // End:0x18
        case "TypeStatCBox":
        // End:0x35
        case "TypeCrystalCBox":
            startSearch();
            // End:0x3B
            break;
        // End:0xFFFF
        default:
            // End:0x3B
            break;
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    local int test, test2;
    local array<int> test3;

    // End:0x2F
    if(strID == "btnCategory99")
    {
        resetFilters();
        setRightSideTexture(0);
        requestCollectionsPageByCategory(0);
    }
    // End:0x61
    if(strID == "btnCategory00")
    {
        resetFilters();
        setRightSideTexture(1);
        requestCollectionsPageByCategory(1);        
    }
    else
    {
        // End:0x93
        if(strID == "btnCategory01")
        {
            resetFilters();
            setRightSideTexture(2);
            requestCollectionsPageByCategory(2);            
        }
        else
        {
            // End:0xC5
            if(strID == "btnCategory02")
            {
                resetFilters();
                setRightSideTexture(3);
                requestCollectionsPageByCategory(3);                
            }
            else
            {
                // End:0xF7
                if(strID == "btnCategory03")
                {
                    resetFilters();
                    setRightSideTexture(4);
                    requestCollectionsPageByCategory(4);                    
                }
                else
                {
                    // End:0x117
                    if(strID == "ListBackBtn")
                    {
                        handleBack();                        
                    }
                    else
                    {
                        // End:0x1F5
                        if(strID == "test")
                        {
                            test3[test3.Length] = 25;
                            test3[test3.Length] = 625;
                            test3[test3.Length] = 100;
                            test3[test3.Length] = 256;
                            test3[test3.Length] = 33;
                            test3[test3.Length] = 1148;
                            test3[test3.Length] = 315;
                            test3[test3.Length] = 308;
                            test3[test3.Length] = 148;
                            test3[test3.Length] = 264;
                            SendFake(string(1104), string(test3[Rand(test3.Length - 1)]), string(0));                            
                        }
                        else
                        {
                            // End:0x234
                            if(strID == "CloseInventory_Btn")
                            {
                                CollectionInventoryWnd.HideWindow();
                                CollectionSlotSelect.HideWindow();                                
                            }
                            else
                            {
                                // End:0x281
                                if((strID == "Close_Btn") || strID == "CollectionInventoryOkBtn")
                                {
                                    AssignCollectionWnd.HideWindow();                                    
                                }
                                else
                                {
                                    // End:0x2BE
                                    if(strID == "CollectionItemRegBtn")
                                    {
                                        OnDBClickItemWithHandle(AssignedInventory, AssignedInventory.GetSelectedNum());                                        
                                    }
                                    else
                                    {
                                        // End:0x2E1
                                        if(strID == "AssignOKButton")
                                        {
                                            requestSaveCollectionItem();                                            
                                        }
                                        else
                                        {
                                            // End:0x308
                                            if(strID == "AssignCancelButton")
                                            {
                                                clearAssignDialog();                                                
                                            }
                                            else
                                            {
                                                // End:0x33D
                                                if(strID == "Find_Btn")
                                                {
                                                    // End:0x334
                                                    if(searchWordBox.GetString() == "")
                                                    {
                                                        return;
                                                    }
                                                    startSearch();                                                    
                                                }
                                                else
                                                {
                                                    // End:0x362
                                                    if(strID == "ClearEditBox_Btn")
                                                    {
                                                        clearSearch();                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x38B
                                                        if(strID == "BtnViewNext")
                                                        {
                                                            Paginator.setNextPage();                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x3B3
                                                            if(strID == "BtnViewPre")
                                                            {
                                                                Paginator.setPrevPage();                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x3DF
                                                                if(strID == "BtnViewNextEnd")
                                                                {
                                                                    Paginator.setMaxPage();                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x407
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
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
    local int Index;

    // End:0x8F
    if(InStr(a_WindowHandle.GetWindowName(), "KeyItem") > -1)
    {
        Index = int(Locs(a_WindowHandle.GetWindowName(), "KeyItem", "", true));
        setRightSideTexture(keyTypeToCollectionType(byte(Index)));
        requestCollectionsPageByKeyType(byte(Index), byte(-1), byte(-1), byte(-1), byte(-1), byte(-1));        
    }
    else
    {
        // End:0x108
        if((AssignCollectionWnd.IsShowWindow() && a_WindowHandle.GetWindowName() == "CollectionWnd") || a_WindowHandle.GetWindowName() == "CollectionsListWnd")
        {
            clearAssignCollectionDialog();
            AssignCollectionWnd.HideWindow();            
        }
        else
        {
            // End:0x15B
            if((!AssignCollectionWnd.IsShowWindow() && CollectionsListWnd.IsShowWindow()) && a_WindowHandle.GetWindowName() == "CollectionWnd")
            {
                initCollections();
            }
        }
    }
    return;
}

function OnMouseOver(WindowHandle W)
{
    local int Index;

    // End:0x64
    if(InStr(W.GetWindowName(), "KeyItem") > -1)
    {
        killOpenGlowTimer();
        Index = int(Locs(W.GetWindowName(), "KeyItem", "", true));
        hideKeyGlow();
        showKeyGlow(Index, true);        
    }
    else
    {
        // End:0xCD
        if(InStr(W.GetWindowName(), "btnCategory") > -1)
        {
            killOpenGlowTimer();
            Index = int(Locs(W.GetWindowName(), "btnCategory", "", true));
            hideKeyGlow();
            showKeyGlow(Index, false);
        }
    }
    return;
}

function OnMouseOut(WindowHandle W)
{
    local int Index;

    // End:0x54
    if((InStr(W.GetWindowName(), "KeyItem") > -1) || InStr(W.GetWindowName(), "btnCategory") > -1)
    {
        hideKeyGlow();
    }
    return;
}

function handlePageNext()
{
    local int page;

    page = Paginator.getCurrentPage();
    currentPage = page;
    requestCollectionsPage();
    return;
}

function handlePagePrev()
{
    local int page;

    page = Paginator.getCurrentPage();
    currentPage = page;
    requestCollectionsPage();
    return;
}

function onCollectionNotifyClick()
{
    clearAssignCollectionDialog();
    AssignCollectionWnd.HideWindow();
    setTotalRightSideTexture();
    setSearchString(lastNotifyItem.Name);
    startSearch();
    handleShow();
    return;
}

function requestCollectionsPageByCategory(CollectionAPI.eCollectionType Category)
{
    currentPage = 1;
    clearKeyTypeRestrictions();
    currentCategory = Category;
    filtredCollections = GetFilteredCollectionList(ItemTypeRestriction, "", 100, 100, currentCategory);
    checkFilterListState(filtredCollections.Length);
    return;
}

function requestCollectionsPageByKeyType(CollectionAPI.eKeyType e1, CollectionAPI.eKeyType e2, CollectionAPI.eKeyType e3, CollectionAPI.eKeyType e4, CollectionAPI.eKeyType e5, CollectionAPI.eKeyType e6)
{
    currentPage = 1;
    currentCategory = 0;
    clearKeyTypeRestrictions();
    // End:0x31
    if(int(e1) > -1)
    {
        setKeyTypeRestrictions(e1);
    }
    // End:0x4D
    if(int(e2) > -1)
    {
        setKeyTypeRestrictions(e2);
    }
    // End:0x69
    if(int(e3) > -1)
    {
        setKeyTypeRestrictions(e3);
    }
    // End:0x85
    if(int(e4) > -1)
    {
        setKeyTypeRestrictions(e4);
    }
    // End:0xA1
    if(int(e5) > -1)
    {
        setKeyTypeRestrictions(e5);
    }
    // End:0xBD
    if(int(e6) > -1)
    {
        setKeyTypeRestrictions(e6);
    }
    filtredCollections = GetFilteredCollectionList(ItemTypeRestriction, "", 100, 100);
    checkFilterListState(filtredCollections.Length);
    return;
}

function requestCollectionsPageBySearch(string search)
{
    currentPage = 1;
    filtredCollections = GetFilteredCollectionList(ItemTypeRestriction, search, byte(TypeCrystalCBox.GetReserved(TypeCrystalCBox.GetSelectedNum())), byte(TypeStatCBox.GetReserved(TypeStatCBox.GetSelectedNum())), currentCategory);
    checkFilterListState(filtredCollections.Length);
    return;
}

function checkFilterListState(int nSize)
{
    CollectionsList.DeleteAllItem();
    // End:0x53
    if(nSize > 0)
    {
        DisableWnd.HideWindow();
        Paginator.setPages(1, appCeil(float(nSize / 15)));
        requestCollectionsPage();        
    }
    else
    {
        currentPage = 1;
        DisableWnd.ShowWindow();
        Paginator.setPages(0, 0);
    }
    return;
}

function requestSaveCollectionItem()
{
    local ItemInfo item;
    local int collectionId;

    collectionId = AssignOKButton.GetButtonValue();
    // End:0x58
    if((collectionId > 0) && AssignedInventory.GetSelectedItem(item))
    {
        requestSaveItemToCollection(collectionId, item);
        AssignDialogBody.HideWindow();
    }
    return;
}

function requestCollectionsPage()
{
    local int i, startIndex, endIndex, listSize;
    local array<int> currentCollectionIds;

    startIndex = (currentPage - 1) * 15;
    endIndex = Min(startIndex + 15, filtredCollections.Length);
    i = startIndex;
    J0x34:

    // End:0x6A [Loop If]
    if(i < endIndex)
    {
        currentCollectionIds[currentCollectionIds.Length] = filtredCollections[i].collection_id;
        i++;
        // [Loop Continue]
        goto J0x34;
    }
    requestPageCollectionsInfo(currentCollectionIds);
    return;
}

function handleShow()
{
    // End:0x23
    if(!Me.IsShowWindow())
    {
        Me.ShowWindow();
    }
    return;
}

function setSearchString(string Str)
{
    searchWordBox.SetString(Str);
    return;
}

function clearKeyTypeRestrictions()
{
    ItemTypeRestriction.Remove(0, ItemTypeRestriction.Length);
    return;
}

function setKeyTypeRestrictions(CollectionAPI.eKeyType Type)
{
    ItemTypeRestriction[ItemTypeRestriction.Length] = Type;
    return;
}

function checkDialogButtons()
{
    CollectionItemRegBtn.EnableWindow();
    CollectionItemRegBtn.ClearTooltip();
    // End:0x65
    if(AssignedInventory.GetItemNum() <= 0)
    {
        CollectionItemRegBtn.DisableWindow();
        CollectionItemRegBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7912)));        
    }
    else
    {
        // End:0x9F
        if(!checkAdena())
        {
            CollectionItemRegBtn.DisableWindow();
            CollectionItemRegBtn.SetTooltipCustomType(MakeTooltipSimpleText(GetSystemString(7913)));
        }
    }
    return;
}

function bool checkAdena()
{
    local ItemInfo item;

    AssignedInventory.GetItem(0, item);
    return __NFUN_411__(GetAdena(), item.Reserved64);
    return;
}

function handleCollectableItemNotify(string param)
{
    local int ServerID, collectionId;
    local ItemInfo collectionItem;

    // End:0x65
    if(SettingSectorBool("COLLECTION", "COLLECION_UI"))
    {
        ParseInt(param, "ask", lastNotifyitemId);
        Me.KillTimer(1002);
        Me.SetTimer(1002, 300);
    }
    return;
}

function handleCollectionStatus(string param)
{
    local string collectionDoneStr, itemsAddedStr;
    local array<string> collectionDoneData, itemsAddedData;

    ParseString(param, "param1", collectionDoneStr);
    ParseString(param, "param2", itemsAddedStr);
    collectionDoneData = Arr(collectionDoneStr, ",");
    itemsAddedData = Arr(itemsAddedStr, ",");
    statusData.collectionDoneData = collectionDoneData;
    statusData.itemsAddedData = itemsAddedData;
    updateCollectionStatus(collectionDoneData, itemsAddedData);
    return;
}

function updateCollectionStatus(array<string> cData, array<string> iData)
{
    local int nNotStartedNum, nNotAddedNum;

    CollectionsDone.SetAlpha(128);
    ItemsDone.SetAlpha(128);
    CollectionsDone.SetPointPercent((cData[0]), (0), (cData[1]));
    ItemsDone.SetPointPercent((iData[0]), (0), (iData[1]));
    CollectionsTxt.SetText(((cData[0] @ "/") @ cData[1]) @ cData[2]);
    ItemsTxt.SetText((iData[0] @ "/") @ iData[1]);
    nNotStartedNum = (int(cData[1]) - int(cData[0])) - int(cData[2]);
    nNotAddedNum = int(iData[1]) - int(iData[0]);
    CollectionsTotalTxt.SetText(MakeCostString(cData[1]));
    CollectionsCompleteTxt.SetText(MakeCostString(cData[0]));
    CollectionsInProgressTxt.SetText(MakeCostString(cData[2]));
    CollectionsNotStartedTxt.SetText(MakeCostString(string(nNotStartedNum)));
    ItemsTotalTxt.SetText(MakeCostString(iData[1]));
    ItemsAssignedTxt.SetText(MakeCostString(iData[0]));
    ItemsAvailableTxt.SetText(MakeCostString(string(nNotAddedNum)));
    return;
}

function handleCollectionRegistrationUpdate(string param)
{
    local int i, nIsCompleted;
    local ItemInfo item;
    local string updateStr;
    local array<string> Object, Objects, updateData;
    local array<ItemInfo> Collection;

    ParseInt(param, "ask", nIsCompleted);
    ParseString(param, "param1", updateStr);
    Object = Arr(updateStr, ",");
    GetItemInfoByClassID(int(Object[1]), item, true);
    item.Reserved = int(Object[0]);
    item.ItemNum = (int(Object[2]));
    setEnchanted(int(Object[3]), item);
    updateAssignCollectionDialog(nIsCompleted, item);
    return;
}

function handleCollectionListPageInfo(string param)
{
    local int i, j, objectsLength, statesLength;
    local string statesStr;
    local array<string> Objects, collectionObject, collectionStates;
    local array<_collectionState> collection_states;

    ParseString(param, "param1", statesStr);
    Objects = Arr(statesStr, ";");
    collection_states.Length = Objects.Length;
    i = 0;
    J0x40:

    // End:0x11D [Loop If]
    if(i < Objects.Length)
    {
        collectionObject = Arr(Objects[i], ":");
        collection_states[i].collectionState = byte(int(collectionObject[0]));
        collectionStates = Arr(collectionObject[1], ",");
        collection_states[i].strStatesArr = collectionObject[1];
        collection_states[i].states.Length = collectionStates.Length;
        j = 0;
        J0xD3:

        // End:0x113 [Loop If]
        if(j < collectionStates.Length)
        {
            collection_states[i].states[j] = byte(int(collectionStates[j]));
            j++;
            // [Loop Continue]
            goto J0xD3;
        }
        i++;
        // [Loop Continue]
        goto J0x40;
    }
    loadCollectionsPage(collection_states);
    return;
}

function loadCollectionsPage(array<_collectionState> collection_states)
{
    local int i, j, k, SlotIndex, startIndex, endIndex;

    local string strDesc1, strDesc2, strDesc3, collectionStatusStr;
    local int bInsert;
    local UIEventManager.EItemType ItemType;
    local LVDataRecord clearRecord, Record;
    local ItemInfo clearItem, item;
    local string tooltipLine, itemLine;
    local bool isLockedItem, isValidType;
    local array<int> currentCollectionIds;
    local int localIndex;
    local Color Color, optC1, optC2, optC3;
    local CollectionAPI.eCollectionState currentCollectionState;
    local CollectionAPI.eCollectionItemState currentItemState;
    local float f1, f2, f3;

    localIndex = 0;
    clearRecord.LVDataList.Length = 6;
    clearRecord.LVDataList[1].arrTexture.Length = 50;
    startIndex = (currentPage - 1) * 15;
    endIndex = Min(startIndex + 15, filtredCollections.Length);
    CollectionsList.DeleteAllItem();
    i = startIndex;
    J0x6D:

    // End:0xB2D [Loop If]
    if(i < endIndex)
    {
        Record = clearRecord;
        bInsert = 0;
        tooltipLine = "";
        currentCollectionState = collection_states[localIndex].collectionState;
        getOptionsStrings(filtredCollections[i].option_id, strDesc1, strDesc2, strDesc3, optC1, optC2, optC3);
        getNumericOptions(strDesc1, strDesc2, strDesc3, f1, f2, f3);
        ParamAdd(tooltipLine, "collection_name", filtredCollections[i].collection_name);
        ParamAdd(tooltipLine, "collection_state", string(currentCollectionState));
        ParamAdd(tooltipLine, "option_id", string(filtredCollections[i].option_id));
        ParamAdd(tooltipLine, "collection_size", string(filtredCollections[i].Collection.Length));
        ParamAdd(tooltipLine, "opt1", strDesc1);
        ParamAdd(tooltipLine, "opt2", strDesc2);
        ParamAdd(tooltipLine, "opt3", strDesc3);
        ParamAdd(tooltipLine, "string_states", collection_states[localIndex].strStatesArr);
        Record.nReserved1 = (filtredCollections[i].collection_id);
        switch(currentCollectionState)
        {
            // End:0x268
            case 0:
                Color = GetColor(180, 80, 80, 255);
                collectionStatusStr = GetSystemString(7855);
                // End:0x2F5
                break;
            // End:0x295
            case 1:
                Color = GetColor(160, 70, 70, 255);
                collectionStatusStr = GetSystemString(7856);
                // End:0x2F5
                break;
            // End:0x2C2
            case 2:
                Color = GetColor(110, 140, 160, 255);
                collectionStatusStr = GetSystemString(7857);
                // End:0x2F5
                break;
            // End:0x2EF
            case 3:
                Color = GetColor(200, 180, 120, 255);
                collectionStatusStr = GetSystemString(7858);
                // End:0x2F5
                break;
            // End:0xFFFF
            default:
                // End:0x2F5
                break;
                break;
        }
        Record.LVDataList[0].bUseTextColor = true;
        Record.LVDataList[0].szData = filtredCollections[i].collection_name;
        Record.LVDataList[0].TextColor = Color;
        Record.LVDataList[0].textAlignment = 1;
        Record.LVDataList[0].FirstLineOffsetX = 3;
        Record.LVDataList[0].HiddenStringForSorting = filtredCollections[i].collection_name;
        Record.LVDataList[0].hasIcon = true;
        Record.LVDataList[0].AttrIconTexArray.Length = 1;
        Record.LVDataList[0].AttrIconTexArray[0].X = 0;
        Record.LVDataList[0].AttrIconTexArray[0].Y = 2;
        Record.LVDataList[0].AttrIconTexArray[0].Width = 0;
        Record.LVDataList[0].AttrIconTexArray[0].Height = 0;
        Record.LVDataList[0].AttrIconTexArray[0].U = 0;
        Record.LVDataList[0].AttrIconTexArray[0].V = 0;
        Record.LVDataList[0].AttrIconTexArray[0].UL = 0;
        Record.LVDataList[0].AttrIconTexArray[0].VL = 0;
        Record.LVDataList[0].AttrIconTexArray[0].objTex = GetTexture("");
        Record.LVDataList[0].AttrColor = Color;
        Record.LVDataList[0].AttrStat[0] = collectionStatusStr;
        j = 0;
        J0x4DD:

        // End:0x95A [Loop If]
        if(j < filtredCollections[i].Collection.Length)
        {
            item = clearItem;
            GetItemInfoByClassID(filtredCollections[i].Collection[j].ItemID, item);
            item.ItemNum = (filtredCollections[i].Collection[j].Count);
            item.Enchanted = filtredCollections[i].Collection[j].Enchant;
            currentItemState = collection_states[localIndex].states[j];
            ParamAdd(tooltipLine, "collection_item_" $ string(j), string(filtredCollections[i].Collection[j].ItemID));
            ParamAdd(tooltipLine, "collection_item_count_" $ string(j), (item.ItemNum));
            ParamAdd(tooltipLine, "collection_item_enchant_" $ string(j), string(item.Enchanted));
            ParamAdd(tooltipLine, "collection_item_commission_" $ string(j), string(filtredCollections[i].Collection[j].commission));
            Record.LVDataList[1].arrTexture[j * 3].objTex = GetTexture(item.IconName);
            Record.LVDataList[1].arrTexture[j * 3].Width = 32;
            Record.LVDataList[1].arrTexture[j * 3].Height = 32;
            Record.LVDataList[1].arrTexture[j * 3].X = j * 34;
            Record.LVDataList[1].arrTexture[j * 3].Y = 0;
            // End:0x83B
            if(item.Enchanted > 0)
            {
                Record.LVDataList[1].arrTexture[(j * 3) + 1].objTex = getEnchantTexture(item.Enchanted);
                Record.LVDataList[1].arrTexture[(j * 3) + 1].Width = 32;
                Record.LVDataList[1].arrTexture[(j * 3) + 1].Height = 32;
                Record.LVDataList[1].arrTexture[(j * 3) + 1].X = j * 34;
                Record.LVDataList[1].arrTexture[(j * 3) + 1].Y = 0;
            }
            // End:0x950
            if((int(currentItemState) == 0) || int(currentItemState) == 1)
            {
                Record.LVDataList[1].arrTexture[(j * 3) + 2].objTex = GetTexture("L2UI_CT1.Itemwindow.ItemWindow_IconDisable");
                Record.LVDataList[1].arrTexture[(j * 3) + 2].Width = 32;
                Record.LVDataList[1].arrTexture[(j * 3) + 2].Height = 32;
                Record.LVDataList[1].arrTexture[(j * 3) + 2].X = j * 34;
                Record.LVDataList[1].arrTexture[(j * 3) + 2].Y = 0;
            }
            j++;
            // [Loop Continue]
            goto J0x4DD;
        }
        Record.LVDataList[1].HiddenStringForSorting = string(filtredCollections[i].Collection.Length);
        Record.LVDataList[2].bUseTextColor = true;
        Record.LVDataList[2].TextColor = optC1;
        Record.LVDataList[2].szData = strDesc1;
        Record.LVDataList[2].textAlignment = 1;
        Record.LVDataList[2].HiddenStringForSorting = string(f1);
        Record.LVDataList[3].bUseTextColor = true;
        Record.LVDataList[3].TextColor = optC2;
        Record.LVDataList[3].szData = strDesc2;
        Record.LVDataList[3].textAlignment = 2;
        Record.LVDataList[3].HiddenStringForSorting = string(f2);
        Record.LVDataList[4].bUseTextColor = true;
        Record.LVDataList[4].TextColor = optC3;
        Record.LVDataList[4].szData = strDesc3;
        Record.LVDataList[4].textAlignment = 2;
        Record.LVDataList[4].HiddenStringForSorting = string(f3);
        Record.szReserved = tooltipLine;
        CollectionsList.InsertRecord(Record);
        currentCollectionIds[currentCollectionIds.Length] = filtredCollections[i].collection_id;
        localIndex++;
        i++;
        // [Loop Continue]
        goto J0x6D;
    }
    ListBackBtn.ShowWindow();
    CollectionsListWnd.ShowWindow();
    CollectionsListWnd.BringToFront();
    return;
}

function handleCollectionAssignDialog()
{
    local int i, listIndex, item_id, collection_size, option_id, item_count,
	    item_enchant;

    local INT64 item_commission;
    local string szReserved, collection_name, opt1, opt2, opt3;

    local ItemInfo clearItem, item;
    local LVDataRecord Record;
    local array<ItemInfo> Collection;
    local array<string> collection_effects;
    local string strStates;
    local array<string> strStatesData;

    listIndex = CollectionsList.GetSelectedIndex();
    clearAssignCollectionDialog();
    // End:0x28
    if(listIndex < 0)
    {
        return;
    }
    CollectionsList.GetRec(listIndex, Record);
    ParseString(Record.szReserved, "collection_name", collection_name);
    ParseInt(Record.szReserved, "collection_size", collection_size);
    ParseString(Record.szReserved, "opt1", opt1);
    ParseString(Record.szReserved, "opt2", opt2);
    ParseString(Record.szReserved, "opt3", opt3);
    ParseString(Record.szReserved, "string_states", strStates);
    strStatesData = Arr(strStates, ",");
    collection_effects[collection_effects.Length] = opt1;
    collection_effects[collection_effects.Length] = opt2;
    collection_effects[collection_effects.Length] = opt3;
    i = 0;
    J0x153:

    // End:0x2A5 [Loop If]
    if(i < collection_size)
    {
        item = clearItem;
        ParseInt(Record.szReserved, "collection_item_" $ string(i), item_id);
        ParseInt(Record.szReserved, "collection_item_count_" $ string(i), item_count);
        ParseInt(Record.szReserved, "collection_item_enchant_" $ string(i), item_enchant);
        ParseINT64(Record.szReserved, "collection_item_commission_" $ string(i), item_commission);
        GetItemInfoByClassID(item_id, item, true);
        item.ItemNum = (item_count);
        item.Reserved64 = item_commission;
        setEnchanted(item_enchant, item);
        Collection[Collection.Length] = item;
        i++;
        // [Loop Continue]
        goto J0x153;
    }
    AssignOKButton.SetButtonValue(name(Record.nReserved1));
    showAssignCollectionDialog(collection_name, Collection, strStatesData, collection_effects);
    return;
}

function showAssignCollectionDialog(string collection_name, array<ItemInfo> Collection, array<string> strStatesData, array<string> collection_effects)
{
    local int i, nIsCompleted;
    local CollectionAPI.eCollectionItemState currentItemState;

    CollectionHeadTxt.SetText(collection_name);
    i = 0;
    J0x1B:

    // End:0x17A [Loop If]
    if(i < Collection.Length)
    {
        currentItemState = byte(int(strStatesData[i]));
        Collection[i].Reserved = int(strStatesData[i]);
        // End:0xA7
        if((int(currentItemState) == 0) || int(currentItemState) == 1)
        {
            SlotFaded[i].ShowWindow();
            SlotFaded[i].BringToFront();            
        }
        else
        {
            // End:0xBC
            if(int(currentItemState) == 2)
            {
                nIsCompleted++;
            }
        }
        // End:0x13B
        if((__NFUN_409__(Collection[i].Reserved64, (0)) && int(currentItemState) == 0) || int(currentItemState) == 1)
        {
            SlotLockCommission[i].ShowWindow();
            SlotLockCommission[i].BringToFront();
            setAssignDialogCommissionTooltip(Collection[i].Reserved64, i);            
        }
        else
        {
            SlotLockCommission[i].HideWindow();
        }
        AssignedCollection[i].AddItem(Collection[i]);
        i++;
        // [Loop Continue]
        goto J0x1B;
    }
    i = 0;
    J0x181:

    // End:0x1BB [Loop If]
    if(i < collection_effects.Length)
    {
        CollectionOptionTxt[i].SetText(collection_effects[i]);
        i++;
        // [Loop Continue]
        goto J0x181;
    }
    AssignCollectionWnd.ShowWindow();
    AssignCollectionWnd.BringToFront();
    // End:0x1F0
    if(nIsCompleted == Collection.Length)
    {
        setCompleteCollectionAni(false);
    }
    return;
}

function setAssignDialogCommissionTooltip(INT64 commission, int Index)
{
    local array<DrawItemInfo> drawListArr;

    drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(7910), getInstanceL2Util().Yellow, "", true, true);
    drawListArr[drawListArr.Length] = addDrawItemText(MakeFullSystemMsg(GetSystemString(7911), MakeCostStringINT64(commission)), getInstanceL2Util().ColorDesc, "", true, true);
    SlotLockCommission[Index].SetTooltipType("text");
    SlotLockCommission[Index].SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
    return;
}

function updateAssignCollectionDialog(int nIsCompleted, ItemInfo collectionItem)
{
    local int i;

    AssignedCollection[currentDialogIndex].Clear();
    AssignedCollection[currentDialogIndex].AddItem(collectionItem);
    // End:0x86
    if((int(byte(collectionItem.Reserved)) == 0) || int(byte(collectionItem.Reserved)) == 1)
    {
        SlotFaded[currentDialogIndex].ShowWindow();
        SlotFaded[currentDialogIndex].BringToFront();        
    }
    else
    {
        SlotLockCommission[currentDialogIndex].HideWindow();
        SlotFaded[currentDialogIndex].HideWindow();
    }
    CollectionSlotSelect.HideWindow();
    CollectionInventoryWnd.HideWindow();
    getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemString(7914), collectionItem.Name, CollectionHeadTxt.GetText()));
    AddSystemMessageString(MakeFullSystemMsg(GetSystemString(7914), collectionItem.Name, CollectionHeadTxt.GetText()));
    // End:0x1AF
    if(int(byte(nIsCompleted)) == 3)
    {
        setCompleteCollectionAni(false);
        getInstanceL2Util().showGfxScreenMessage(MakeFullSystemMsg(GetSystemString(7915), CollectionHeadTxt.GetText()));
        AddSystemMessageString(MakeFullSystemMsg(GetSystemString(7915), collectionItem.Name, CollectionHeadTxt.GetText()));
    }
    return;
}

function registrationConfirmDialog(ItemInfo item)
{
    setBigIcon(item);
    AssignTargetItem.Clear();
    AssignTargetItem.AddItem(item);
    AssignTargetItemNameTxt.SetText(MakeFullItemName(item.Id.ClassID));
    NeeddedItemCountTxt.SetText("");
    AssignDialogText.SetText(MakeFullSystemMsg(GetSystemString(7845), item.Name, (item.ItemNum)));
    // End:0xEE
    if(__NFUN_409__(item.Reserved64, (0)))
    {
        AssignDialogText2.ShowWindow();
        AssignDialogText2.SetText(MakeFullSystemMsg(GetSystemString(7909), MakeCostStringINT64(item.Reserved64)));        
    }
    else
    {
        AssignDialogText2.HideWindow();
    }
    AssignDialogBody.ShowWindow();
    AssignDialogBody.SetFocus();
    AssignDialogBody.BringToFront();
    return;
}

function clearAssignCollectionDialog()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x71 [Loop If]
    if(i < 6)
    {
        SlotFaded[i].HideWindow();
        SlotLockCommission[i].HideWindow();
        SlotLockCommission[i].ClearTooltip();
        AssignedCollection[i].Clear();
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    i = 0;
    J0x78:

    // End:0xA5 [Loop If]
    if(i < 3)
    {
        CollectionOptionTxt[i].SetText("");
        i++;
        // [Loop Continue]
        goto J0x78;
    }
    clearAssignDialog();
    CollectionSlotSelect.HideWindow();
    CollectionInventoryWnd.HideWindow();
    Complete_Ani.HideWindow();
    return;
}

function clearAssignDialog()
{
    AssignDialogBody.HideWindow();
    AssignOKButton.SetButtonValue(-1);
    checkDialogButtons();
    return;
}

function showAvailableInventoryItemsByCollectionItem(ItemInfo item)
{
    local int i;
    local array<ItemInfo> infos;

    infos = Inventory.getInventoryCollectionArray(item);
    AssignedInventory.Clear();
    i = 0;
    J0x30:

    // End:0x7F [Loop If]
    if(i < infos.Length)
    {
        infos[i].Reserved64 = item.Reserved64;
        AssignedInventory.AddItem(infos[i]);
        i++;
        // [Loop Continue]
        goto J0x30;
    }
    CollectionInventoryWnd.ShowWindow();
    checkDialogButtons();
    return;
}

function hideKeyGlow()
{
    local int i;

    i = 0;
    J0x07:

    // End:0xC3 [Loop If]
    if(i < 6)
    {
        GetTextureHandle((("CollectionWnd.KeyItem0" $ string(i)) $ ".keyItemGlow1_0") $ string(i)).SetAlpha(0, 0.2500000);
        GetTextureHandle((("CollectionWnd.KeyItem0" $ string(i)) $ ".keyItemGlow2_0") $ string(i)).SetAlpha(0, 0.2500000);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function showKeyGlow(int Index, bool bFromKeyOver, optional float fAlphaSpeed)
{
    // End:0x1A
    if(fAlphaSpeed == 0.0000000)
    {
        fAlphaSpeed = 0.4500000;
    }
    // End:0xCD
    if(bFromKeyOver)
    {
        GetTextureHandle((("CollectionWnd.KeyItem0" $ string(Index)) $ ".keyItemGlow1_0") $ string(Index)).SetAlpha(255, fAlphaSpeed);
        GetTextureHandle((("CollectionWnd.KeyItem0" $ string(Index)) $ ".keyItemGlow2_0") $ string(Index)).SetAlpha(255, fAlphaSpeed);
        return;
    }
    switch(Index)
    {
        // End:0x3DC
        case 99:
            GetTextureHandle("CollectionWnd.KeyItem00.keyItemGlow1_00").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem00.keyItemGlow2_00").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem01.keyItemGlow1_01").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem01.keyItemGlow2_01").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem02.keyItemGlow1_02").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem02.keyItemGlow2_02").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem03.keyItemGlow1_03").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem03.keyItemGlow2_03").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem04.keyItemGlow1_04").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem04.keyItemGlow2_04").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem04.keyItemGlow1_05").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem04.keyItemGlow2_05").SetAlpha(255, fAlphaSpeed);
            // End:0x6F8
            break;
        // End:0x4E3
        case 0:
            GetTextureHandle("CollectionWnd.KeyItem00.keyItemGlow1_00").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem00.keyItemGlow2_00").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem01.keyItemGlow1_01").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem01.keyItemGlow2_01").SetAlpha(255, fAlphaSpeed);
            // End:0x6F8
            break;
        // End:0x66A
        case 1:
            GetTextureHandle("CollectionWnd.KeyItem02.keyItemGlow1_02").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem02.keyItemGlow2_02").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem03.keyItemGlow1_03").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem03.keyItemGlow2_03").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem04.keyItemGlow1_04").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem04.keyItemGlow2_04").SetAlpha(255, fAlphaSpeed);
            // End:0x6F8
            break;
        // End:0x6F2
        case 3:
            GetTextureHandle("CollectionWnd.KeyItem05.keyItemGlow1_05").SetAlpha(255, fAlphaSpeed);
            GetTextureHandle("CollectionWnd.KeyItem05.keyItemGlow2_05").SetAlpha(255, fAlphaSpeed);
            // End:0x6F8
            break;
        // End:0xFFFF
        default:
            // End:0x6F8
            break;
            break;
    }
    return;
}

function setRightSideTexture(CollectionAPI.eCollectionType KeyType)
{
    local CollectionAPI.eCollectionType collectionType;

    switch(KeyType)
    {
        // End:0x57
        case 1:
            RightTypeTx.SetTexture("L2UI_EPIC.L2UI_EPIC.CollectionSystemWnd.KeyItemcol_A_00");
            // End:0x156
            break;
        // End:0xA7
        case 2:
            RightTypeTx.SetTexture("L2UI_EPIC.L2UI_EPIC.CollectionSystemWnd.KeyItemcol_B_00");
            // End:0x156
            break;
        // End:0xF7
        case 3:
            RightTypeTx.SetTexture("L2UI_EPIC.L2UI_EPIC.CollectionSystemWnd.KeyItemcol_C_00");
            // End:0x156
            break;
        // End:0x147
        case 4:
            RightTypeTx.SetTexture("L2UI_EPIC.L2UI_EPIC.CollectionSystemWnd.KeyItemcol_G_00");
            // End:0x156
            break;
        // End:0xFFFF
        default:
            setTotalRightSideTexture();
            // End:0x156
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x156
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x156
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x156
}

function setTotalRightSideTexture()
{
    RightTypeTx.SetTexture("L2UI_EPIC.L2UI_EPIC.CollectionSystemWnd.KeyItemcol_F_00");
    return;
}

function initCollections()
{
    hideKeyGlow();
    clearAssignCollectionDialog();
    ListBackBtn.HideWindow();
    CollectionsList.DeleteAllItem();
    CollectionsListWnd.HideWindow();
    AssignCollectionWnd.HideWindow();
    CollectionInventoryWnd.HideWindow();
    resetFilters();
    return;
}

function initPaginator()
{
    Paginator = new Class'Interface.Paginator';
    Paginator.SetPaginatorElement(GetTextBoxHandle(m_WindowName $ ".CollectionsListWnd.PaginationContainer.currPageTxt"), GetTextBoxHandle(m_WindowName $ ".CollectionsListWnd.PaginationContainer.totalPageTxt"), GetButtonHandle(m_WindowName $ ".CollectionsListWnd.PaginationContainer.BtnViewNext"), GetButtonHandle(m_WindowName $ ".CollectionsListWnd.PaginationContainer.BtnViewPre"), GetButtonHandle(m_WindowName $ ".CollectionsListWnd.PaginationContainer.BtnViewPreEnd"), GetButtonHandle(m_WindowName $ ".CollectionsListWnd.PaginationContainer.BtnViewNextEnd"));
    Paginator.__onPageNext__Delegate = handlePageNext;
    Paginator.__onPagePrev__Delegate = handlePagePrev;
    return;
}

function initFilters()
{
    local int i;

    TypeCrystalCBox.AddStringWithReserved(GetSystemString(144), 100);
    TypeCrystalCBox.AddStringWithReserved(GetSystemString(7886), 0);
    TypeCrystalCBox.AddStringWithReserved(GetSystemString(7887), 1);
    TypeCrystalCBox.AddStringWithReserved(GetSystemString(7888), 2);
    TypeCrystalCBox.AddStringWithReserved(GetSystemString(7889), 3);
    TypeCrystalCBox.AddStringWithReserved(GetSystemString(7890), 4);
    TypeCrystalCBox.AddStringWithReserved(GetSystemString(7891), 5);
    TypeStatCBox.AddStringWithReserved(GetSystemString(144), 100);
    i = 0;
    J0xDF:

    // End:0x116 [Loop If]
    if(i < 16)
    {
        TypeStatCBox.AddStringWithReserved(getStatString(byte(i)), i);
        i++;
        // [Loop Continue]
        goto J0xDF;
    }
    resetFilters();
    return;
}

function resetFilters()
{
    TypeCrystalCBox.SetSelectedNum(0);
    TypeStatCBox.SetSelectedNum(0);
    searchWordBox.Clear();
    return;
}

function handleBack()
{
    OnReceivedCloseUI();
    return;
}

function setCompleteCollectionAni(bool bEnd)
{
    Complete_Ani.ShowWindow();
    // End:0x89
    if(!bEnd)
    {
        Complete_Ani.SetTexture("L2UI_EPIC.CollectionSystemWnd_CompleteAni0000");
        Complete_Ani.Stop();
        Complete_Ani.SetLoopCount(1);
        Complete_Ani.Play();        
    }
    else
    {
        Complete_Ani.SetTexture("L2UI_EPIC.CollectionSystemWnd_CompleteAni0015");
    }
    return;
}

function startSearch()
{
    requestCollectionsPageBySearch(searchWordBox.GetString());
    return;
}

function clearSearch()
{
    // End:0x18
    if(searchWordBox.GetString() == "")
    {
        return;
    }
    searchWordBox.Clear();
    requestCollectionsPageBySearch("");
    return;
}

function OnReceivedCloseUI()
{
    // End:0x24
    if(AssignDialogBody.IsShowWindow())
    {
        AssignDialogBody.HideWindow();        
    }
    else
    {
        // End:0x62
        if(AssignCollectionWnd.IsShowWindow() || CollectionInventoryWnd.IsShowWindow())
        {
            clearAssignCollectionDialog();
            AssignCollectionWnd.HideWindow();            
        }
        else
        {
            // End:0x7D
            if(CollectionsListWnd.IsShowWindow())
            {
                initCollections();                
            }
            else
            {
                Me.HideWindow();
            }
        }
    }
    return;
}

function OnKeyDown(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
    // End:0x30
    if(CollectionsListWnd.IsShowWindow())
    {
        // End:0x30
        if(int(Key) == 13)
        {
            OnClickButton("Find_Btn");
        }
    }
    return;
}
