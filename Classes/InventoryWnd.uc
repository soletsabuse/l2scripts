class InventoryWnd extends UICommonAPI;

const DIALOG_USE_RECIPE = 1111;
const DIALOG_POPUP = 2222;
const DIALOG_DROPITEM = 3333;
const DIALOG_DROPITEM_ASKCOUNT = 4444;
const DIALOG_DROPITEM_ALL = 5555;
const DIALOG_DESTROYITEM = 6666;
const DIALOG_DESTROYITEM_ALL = 7777;
const DIALOG_DESTROYITEM_ASKCOUNT = 8888;
const DIALOG_CRYSTALLIZE = 9999;
const DIALOG_NOTCRYSTALLIZE = 9998;
const DIALOG_DROPITEM_PETASKCOUNT = 10000;
const TIMER_REQUEST_ITEMLIST = 1718;
const TIMER_REQUEST_ITEMLIST_DELAY = 5000;
const EQUIPITEM_Underwear = 0;
const EQUIPITEM_Head = 1;
const EQUIPITEM_Hair = 2;
const EQUIPITEM_Hair2 = 3;
const EQUIPITEM_Neck = 4;
const EQUIPITEM_RHand = 5;
const EQUIPITEM_Chest = 6;
const EQUIPITEM_LHand = 7;
const EQUIPITEM_REar = 8;
const EQUIPITEM_LEar = 9;
const EQUIPITEM_Gloves = 10;
const EQUIPITEM_Legs = 11;
const EQUIPITEM_Feet = 12;
const EQUIPITEM_RFinger = 13;
const EQUIPITEM_LFinger = 14;
const EQUIPITEM_LBracelet = 15;
const EQUIPITEM_RBracelet = 16;
const EQUIPITEM_Deco1 = 17;
const EQUIPITEM_Deco2 = 18;
const EQUIPITEM_Deco3 = 19;
const EQUIPITEM_Deco4 = 20;
const EQUIPITEM_Deco5 = 21;
const EQUIPITEM_Deco6 = 22;
const EQUIPITEM_Cloak = 23;
const EQUIPITEM_Waist = 24;
const EQUIPITEM_Brooch = 25;
const EQUIPITEM_Jewel1 = 26;
const EQUIPITEM_Jewel2 = 27;
const EQUIPITEM_Jewel3 = 28;
const EQUIPITEM_Jewel4 = 29;
const EQUIPITEM_Jewel5 = 30;
const EQUIPITEM_Jewel6 = 31;
const EQUIPITEM_AGATHION_MAIN = 32;
const EQUIPITEM_AGATHION_SUB1 = 33;
const EQUIPITEM_AGATHION_SUB2 = 34;
const EQUIPITEM_AGATHION_SUB3 = 35;
const EQUIPITEM_AGATHION_SUB4 = 36;
const EQUIPITEM_Max = 37;
const INVENTORY_ITEM_TAB = 0;
const INVENTORY_ITEM_1_TAB = 1;
const INVENTORY_ITEM_2_TAB = 2;
const INVENTORY_ITEM_3_TAB = 3;
const INVENTORY_ITEM_4_TAB = 4;
const QUEST_ITEM_TAB = 5;
const ICON_WIDTH = 36;
const INVENTORYWND_MIN_WIDTH = 556;
const ITEMWINDOW_MIN_WIDTH = 339;
const TAB_BG_MIN_WIDTH = 350;
const TAB_BG_LING_MIN_WIDTH = 10;
const TAB_LENGTH = 4;

struct Templates
{
    var array<int> Template;
};

struct hTemplate
{
    var array<Templates> Templates;
    var INT64 commission;
};

struct hTemplateUI
{
    var WindowHandle hennaTemplateWnd;
    var ItemWindowHandle hennaTemplateItem;
};

var bool bFalseOpen;
var array<ItemInfo> newItems;
var WindowHandle m_hInventoryWnd;
var string m_WindowName;
var ItemWindowHandle m_invenItem;
var ItemWindowHandle m_questItem;
var ItemWindowHandle m_equipItem[37];
var ItemWindowHandle m_hHennaItemWindow;
var ItemWindowHandle m_hPremiumHennaItemWindow;
var TextBoxHandle m_hAdenaTextBox;
var TabHandle m_invenTab;
var ButtonHandle m_sortBtn;
var ButtonHandle m_BtnRotateLeft;
var ButtonHandle m_BtnRotateRight;
var TextureHandle m_Talisman_Disable[6];
var TextureHandle m_Jewel_Disable[6];
var ItemWindowHandle m_invenItem_1;
var ItemWindowHandle m_invenItem_2;
var ItemWindowHandle m_invenItem_3;
var ItemWindowHandle m_invenItem_4;
var ItemWindowHandle m_equipItem_Brooch;
var TextureHandle m_BroochEquiped;
var ButtonHandle m_BtnWindowExpand;
var TextureHandle m_InventoryItembg;
var TextureHandle m_InventoryItembg_expand;
var TextureHandle m_tabbg;
var TextureHandle m_tabbgLine;
var TextBoxHandle m_itemCount;
var int currentInvenCol;
var int pInventoryItemCount;
var CharacterViewportWindowHandle m_ObjectViewport;
var array<ItemID> m_itemOrder;
var Vector m_clickLocation;
var array<ItemInfo> m_EarItemList;
var array<ItemInfo> m_FingerItemLIst;
var array<ItemInfo> m_DecoItemList;
var int m_NormalInvenCount;
var int m_QuestInvenCount;
var bool m_bCurrentState;
var int m_MaxInvenCount;
var int m_MaxQuestItemInvenCount;
var int m_MeshType;
var int m_NpcID;
var ButtonHandle m_hBtnCrystallize;
var ButtonHandle m_hBtnRefinery;
var WindowHandle ColorNickNameWnd;
var int m_selectedItemTab;
var string lastHandleAddItemParam;
var ButtonHandle AdenacalculateButton;
var ButtonHandle EnchantJewelButton;
var ButtonHandle CollectionBtn;
var ButtonHandle JewelButton;
var ButtonHandle AlchemyOpenerBtn;
var bool m_bFirstOpen;
var ButtonHandle ViewHairButton;
var ButtonHandle ViewAccessoryButton;
var WindowHandle JewelWindow;
var WindowHandle AlchemyOpenerWindow;
var ButtonHandle AlchemyMixCubeWndBtn;
var ButtonHandle AlchemyItemConversionWndBtn;
var ButtonHandle AlchemyItemCreateWndBtn;
var string cur_state;
var int mainClass;
var bool bIsPremiumHennaSlot;
var QuitReportWnd QuitReportWndScript;
var string m_EquipWindowName;
var WindowHandle m_EquipWindow;
var WindowHandle AgathionWindow;
var ButtonHandle AgathionBtn;
var TextureHandle m_Agathion_Disable[5];
var L2Util l2utilScript;
var bool bIsSavedLocalItemIdx;
var array<int> itemSwapedServerID;
var array<int> itemSwapedServerID_1;
var array<int> itemSwapedServerID_2;
var array<int> itemSwapedServerID_3;
var array<int> itemSwapedServerID_4;
var array<int> itemSwapedServerID_q;
var array<int> itemSwapedIdx;
var array<int> itemSwapedIdx_1;
var array<int> itemSwapedIdx_2;
var array<int> itemSwapedIdx_3;
var array<int> itemSwapedIdx_4;
var array<int> itemSwapedIdx_q;
var bool bIsQuestItemList;
var bool bIsRequestItemList;
var AnimTextureHandle hennaTemplateSuccessTex;
var int currentHennaTemplate;
var ButtonHandle HennaButton;
var WindowHandle hennaSwapContainer;
var array<hTemplateUI> hennaTemplatesUI;
var hTemplate hennaTemplates;
//var delegate<onItemGroundDrop> __onItemGroundDrop__Delegate;
//var delegate<onItemDelete> __onItemDelete__Delegate;

function OnRegisterEvent()
{
    RegisterEvent(2570);
    RegisterEvent(2580);
    RegisterEvent(2590);
    RegisterEvent(2600);
    RegisterEvent(2610);
    RegisterEvent(2620);
    RegisterEvent(2630);
    RegisterEvent(2632);
    RegisterEvent(2633);
    RegisterEvent(2631);
    RegisterEvent(260);
    RegisterEvent(180);
    RegisterEvent(181);
    RegisterEvent(1710);
    RegisterEvent(40);
    RegisterEvent(2070);
    RegisterEvent(3810);
    RegisterEvent(9439);
    RegisterEvent(3410);
    RegisterEvent(9873);
    RegisterEvent(5312);
    RegisterEvent(5310);
    RegisterEvent(8000);
    RegisterEvent(3550);
    return;
}

function OnLoad()
{
    l2utilScript = L2Util(GetScript("L2Util"));
    GetWindowHandle(m_WindowName $ ".Equip_Live").HideWindow();
    GetWindowHandle(m_WindowName $ ".Equip_classic").HideWindow();
    HandleChangeCharacterPawn("MeshType=" $ string(m_MeshType));
    SetClosingOnESC();
    InitHandleCOD();
    setEquipWindowHandle();
    getHandles();
    InitScrollBar();
    m_bCurrentState = false;
    m_selectedItemTab = 0;
    currentInvenCol = GetOptionInt("Game", "ItemInventoryCol");
    // End:0xF1
    if((currentInvenCol != 9) && currentInvenCol != 12)
    {
        currentInvenCol = 9;
    }
    m_bFirstOpen = false;
    m_BroochEquiped.HideWindow();
    handlePremiumHenna();
    QuitReportWndScript = QuitReportWnd(GetScript("QuitReportWnd"));
    return;
}

function OnEvent(int Event_ID, string param)
{
    local UIEventManager.ELanguageType Language;

    switch(Event_ID)
    {
        // End:0x18
        case 2570:
            HandleClear();
            // End:0x1FF
            break;
        // End:0x2E
        case 2580:
            HandleOpenWindow(param);
            // End:0x1FF
            break;
        // End:0x3F
        case 2590:
            HandleHideWindow();
            // End:0x1FF
            break;
        // End:0x55
        case 2600:
            HandleAddItem(param);
            // End:0x1FF
            break;
        // End:0x92
        case 2610:
            // End:0x84
            if((GetServerType() == 3) || int(Language) != 0)
            {
                showItemUpdateEffect(param);
            }
            HandleUpdateItem(param);
            // End:0x1FF
            break;
        // End:0xA3
        case 2620:
            HandleItemListEnd();
            // End:0x1FF
            break;
        // End:0xB4
        case 2630:
            UpdateHennaInfo();
            // End:0x1FF
            break;
        // End:0xC6
        case 2632:
            UpdatePremiumHennaInfo(false);
            // End:0x1FF
            break;
        // End:0xD8
        case 2633:
            UpdatePremiumHennaInfo(true);
            // End:0x1FF
            break;
        // End:0xE9
        case 260:
            UpdateHennaInfo();
            // End:0x1FF
            break;
        // End:0xFA
        case 2631:
            HandleToggleWindow();
            // End:0x1FF
            break;
        // End:0x10B
        case 1710:
            HandleDialogOK();
            // End:0x1FF
            break;
        // End:0x119
        case 180:
            HandleUpdateUserInfo();
            // End:0x1FF
            break;
        // End:0x127
        case 181:
            HandleUpdateUserEquipSlotInfo();
            // End:0x1FF
            break;
        // End:0x135
        case 40:
            HandleRestart();
            // End:0x1FF
            break;
        // End:0x14B
        case 2070:
            HandleSetMaxCount(param);
            // End:0x1FF
            break;
        // End:0x161
        case 3810:
            HandleChangeCharacterPawn(param);
            // End:0x1FF
            break;
        // End:0x177
        case 9439:
            ReceiveHairAccessoryPriority(param);
            // End:0x1FF
            break;
        // End:0x18D
        case 3410:
            cur_state = param;
            // End:0x1FF
            break;
        // End:0x1A0
        case 5312:
            handleChangedSubjob(param);
        // End:0x1B6
        case 5310:
            handleNotifySubjob(param);
            // End:0x1FF
            break;
        // End:0x1E0
        case 8000:
            checkClassicForm();
            // End:0x1CF
            if(bIsRequestItemList)
            {
                return;
            }
            bIsRequestItemList = true;
            RequestItemList();
            // End:0x1FF
            break;
        // End:0x1F6
        case 3550:
            handlePacket(param);
            // End:0x1FF
            break;
        // End:0xFFFF
        default:
            // End:0x1FF
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1FF
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1FF
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x1FF
}

function OnShow()
{
    m_bFirstOpen = true;
    checkClassicForm();
    // End:0x3C
    if(IsShowWindow("PostWriteWnd"))
    {
        HideWindow("InventoryWnd");        
    }
    else
    {
        getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "AttributeEnchantWnd,AttributeRemoveWnd,ItemEnchantWnd,RefineryWnd,UnrefineryWnd,CrystallizationWnd,ItemAttributeChangeWnd,ProgressBox,AlchemyMixCubeWnd");
    }
    setButtons();
    SetAdenaText();
    SetItemCount();
    handleNewItemOnShow();
    UpdateHennaInfo();
    // End:0x12A
    if(currentInvenCol == 9)
    {
        m_InventoryItembg_expand.HideWindow();        
    }
    else
    {
        // End:0x13D
        if(currentInvenCol == 12)
        {
            extendInventory(true);
        }
    }
    setAhclemyOpener();
    m_hOwnerWnd.KillTimer(1718);
    // End:0x162
    if(bIsRequestItemList)
    {
        return;
    }
    bIsRequestItemList = true;
    RequestItemList();
    return;
}

function OnHide()
{
    hennaSwapContainer.HideWindow();
    JewelWindow.HideWindow();
    JewelButton.SetTexture("L2UI_CT1.Button.BtnEditDown", "L2UI_CT1.Button.BtnEditDown_down", "L2UI_CT1.bButton.BtnEditDown_over");
    AlchemyOpenerWindow.HideWindow();
    // End:0xAD
    if(m_bCurrentState)
    {
        SaveInventoryOrder();
    }
    // End:0xBC
    if(DialogIsMine())
    {
        DialogHide();
    }
    setSearchClear();
    handleNewItemOnHide();
    return;
}

function OnTimer(int TimerID)
{
    switch(TimerID)
    {
        // End:0x12
        case 1718:
            // End:0x18
            break;
        // End:0xFFFF
        default:
            // End:0x18
            break;
            break;
    }
    return;
}

function OnEnterState(name a_PrevStateName)
{
    m_bCurrentState = true;
    return;
}

function OnExitState(name a_NextStateName)
{
    m_bCurrentState = false;
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo Info;

    // End:0x5E
    if(strID == "HennaItem")
    {
        // End:0x5B
        if(m_hHennaItemWindow.GetItem(Index, Info))
        {
            // End:0x54
            if(Info.Id.ClassID == 10000000)
            {
                handleHennaUI(0);                
            }
            else
            {
                handleHennaUI(1);
            }
        }        
    }
    else
    {
        // End:0x114
        if((InStr(strID, "InventoryItem") > -1) || InStr(strID, "QuestItem") > -1)
        {
            GetItemWindowHandle("InventoryWnd." $ strID).GetItem(Index, Info);
            // End:0x114
            if(Info.ForeTexture == "L2UI_CT1.InventoryWnd.Inventory_NewItem_01")
            {
                SetNewAcquiredUtil(Info, false, true);
            }
        }
    }
    return;
}

function OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
    local ItemInfo Info;

    UseItem(a_hItemWindow, Index);
    a_hItemWindow.GetSelectedItem(Info);
    SetNewAcquiredUtil(Info, false, false);
    return;
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
    local ItemInfo Info;

    UseItem(a_hItemWindow, Index);
    a_hItemWindow.GetItem(Index, Info);
    SetNewAcquiredUtil(Info, false, false);
    return;
}

function OnSelectItemWithHandle(ItemWindowHandle a_hItemWindow, int a_Index)
{
    local int __var6793;
    local ItemInfo Info;
    local string __var19966;

    // End:0xC8
    if(IsKeyDown(16) && !Class'NWindow.InputAPI'.static.IsCtrlPressed())
    {
        a_hItemWindow.GetSelectedItem(Info);
        __var19966 = Class'NWindow.UIDATA_ITEM'.static.GetRefineryItemName(Info.Name, Info.RefineryOp1, Info.RefineryOp2);
        // End:0xB3
        if(IsStackableItem(Info.ConsumeType) && __NFUN_409__(Info.ItemNum, (1)))
        {
            __var19966 = ((__var19966 $ "(") $ (Info.ItemNum)) $ ")";
        }
        SetItemTextLink(Info.Id, __var19966);
    }
    switch(a_hItemWindow)
    {
        // End:0xD7
        case m_invenItem:
        // End:0xDF
        case m_invenItem_1:
        // End:0xE7
        case m_invenItem_2:
        // End:0xEF
        case m_invenItem_3:
        // End:0xF7
        case m_invenItem_4:
        // End:0x101
        case m_questItem:
            return;
        // End:0xFFFF
        default:
            __var6793 = 0;
            J0x10B:

            // End:0x14B [Loop If]
            if(__var6793 < 37)
            {
                // End:0x141
                if(a_hItemWindow != m_equipItem[__var6793])
                {
                    m_equipItem[__var6793].ClearSelect();
                }
                ++__var6793;
                // [Loop Continue]
                goto J0x10B;
            }
            // End:0x169
            if(a_hItemWindow != m_equipItem_Brooch)
            {
                m_equipItem_Brooch.ClearSelect();
            }
            // End:0x16C
            break;
            break;
    }
    return;
}

function OnDropItem(string strTarget, ItemInfo Info, int X, int Y)
{
    local int __var3940, __var5302;
    local CrystallizationWnd CrystallizationWndScript;
    local ItemWindowHandle normalinven;
    local CollectionWnd CollectionWnd;

    CrystallizationWndScript = CrystallizationWnd(GetScript("CrystallizationWnd"));
    // End:0x3C
    if(!isDragSrcInventory(Info.DragSrcName))
    {
        return;
    }
    // End:0x2BA
    if(((((strTarget == "InventoryItem") || strTarget == "InventoryItem_1") || strTarget == "InventoryItem_2") || strTarget == "InventoryItem_3") || strTarget == "InventoryItem_4")
    {
        // End:0x164
        if(Info.DragSrcName == strTarget)
        {
            normalinven = getItemWindowHandleBystrTarget(strTarget);
            __var3940 = normalinven.GetIndexAt(X, Y, 1, 1);
            // End:0x161
            if(__var3940 >= 0)
            {
                __var5302 = normalinven.FindItem(Info.Id);
                // End:0x161
                if(__var3940 != __var5302)
                {
                    normalinven.SwapItems(__var5302, __var3940);
                }
            }            
        }
        else
        {
            // End:0x1AC
            if(-1 != InStr(Info.DragSrcName, "EquipItem"))
            {
                handleRequestUnequipItem(Info.DragSrcName, Info.Id, Info.SlotBitType);                
            }
            else
            {
                // End:0x2B7
                if(Info.DragSrcName == "PetInvenWnd")
                {
                    // End:0x29A
                    if(IsStackableItem(Info.ConsumeType) && __NFUN_409__(Info.ItemNum, (1)))
                    {
                        // End:0x247
                        if(__NFUN_409__(Info.AllItemCount, (0)))
                        {
                            // End:0x244
                            if(CheckItemLimit(Info.Id, Info.AllItemCount))
                            {
                                Class'NWindow.PetAPI'.static.RequestGetItemFromPet(Info.Id, Info.AllItemCount, false);
                            }                            
                        }
                        else
                        {
                            DialogSetID(10000);
                            DialogSetReservedItemID(Info.Id);
                            DialogSetParamInt64(Info.ItemNum);
                            DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), Info.Name), string(self));
                        }                        
                    }
                    else
                    {
                        Class'NWindow.PetAPI'.static.RequestGetItemFromPet(Info.Id, (1), false);
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x35F
        if(strTarget == "QuestItem")
        {
            // End:0x35C
            if(Info.DragSrcName == "QuestItem")
            {
                __var3940 = m_questItem.GetIndexAt(X, Y, 1, 1);
                // End:0x35C
                if(__var3940 >= 0)
                {
                    __var5302 = m_questItem.FindItem(Info.Id);
                    // End:0x35C
                    if(__var3940 != __var5302)
                    {
                        m_questItem.SwapItems(__var5302, __var3940);
                    }
                }
            }            
        }
        else
        {
            // End:0x42A
            if((-1 != InStr(strTarget, "EquipItem")) || strTarget == "ObjectViewportDispatchMsg")
            {
                // End:0x3DE
                if(Info.DragSrcName == "PetInvenWnd")
                {
                    Class'NWindow.PetAPI'.static.RequestGetItemFromPet(Info.Id, (1), true);                    
                }
                else
                {
                    // End:0x402
                    if(-1 != InStr(Info.DragSrcName, "EquipItem"))
                    {                        
                    }
                    else
                    {
                        // End:0x427
                        if(int(byte(Info.ItemType)) != 5)
                        {
                            RequestUseItem(Info.Id);
                        }
                    }
                }                
            }
            else
            {
                // End:0x5E6
                if(strTarget == "TrashButton")
                {
                    // End:0x46F
                    if((IsShowWindow("AttributeEnchantWnd")) == true)
                    {
                        AddSystemMessage(4148);
                        return;
                    }
                    // End:0x552
                    if(IsStackableItem(Info.ConsumeType) && __NFUN_409__(Info.ItemNum, (1)))
                    {
                        // End:0x4FF
                        if(__NFUN_409__(Info.AllItemCount, (0)))
                        {
                            DialogSetID(7777);
                            DialogSetReservedItemID(Info.Id);
                            DialogSetReservedInt2(Info.AllItemCount);
                            DialogShow(1, 4, MakeFullSystemMsg(GetSystemMessage(74), Info.Name, ""), string(self));                            
                        }
                        else
                        {
                            DialogSetID(8888);
                            DialogSetReservedItemID(Info.Id);
                            DialogSetParamInt64(Info.ItemNum);
                            DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(73), Info.Name), string(self));
                        }                        
                    }
                    else
                    {
                        // End:0x5A3
                        if((isCrafter()) && Class'NWindow.UIDATA_ITEM'.static.IsCrystallizable(Info.Id))
                        {
                            CrystallizationWndScript.SetItemInfo(Info);
                            RequestCrystallizeEstimate(Info.Id, (1));                            
                        }
                        else
                        {
                            DialogSetID(6666);
                            DialogSetReservedItemID(Info.Id);
                            DialogShow(1, 4, MakeFullSystemMsg(GetSystemMessage(74), Info.Name), string(self));
                        }
                    }                    
                }
                else
                {
                    // End:0x768
                    if(strTarget == "CrystallizeButton")
                    {
                        // End:0x631
                        if((IsShowWindow("AttributeEnchantWnd")) == true)
                        {
                            AddSystemMessage(4148);
                            return;
                        }
                        // End:0x765
                        if((((((Info.DragSrcName == "InventoryItem") || Info.DragSrcName == "InventoryItem_1") || Info.DragSrcName == "InventoryItem_2") || Info.DragSrcName == "InventoryItem_3") || Info.DragSrcName == "InventoryItem_4") || -1 != InStr(Info.DragSrcName, "EquipItem"))
                        {
                            // End:0x74B
                            if((isCrafter()) && Class'NWindow.UIDATA_ITEM'.static.IsCrystallizable(Info.Id))
                            {
                                CrystallizationWndScript.SetItemInfo(Info);
                                RequestCrystallizeEstimate(Info.Id, (1));                                
                            }
                            else
                            {
                                CrystallizationWndScript.cancelCystallizeItem();
                                AddSystemMessage(2171);
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x811
                        if(strTarget == "CollectionBtn")
                        {
                            CollectionWnd = CollectionWnd(GetScript("CollectionWnd"));
                            CollectionWnd.clearAssignCollectionDialog();
                            CollectionWnd.AssignCollectionWnd.HideWindow();
                            CollectionWnd.setTotalRightSideTexture();
                            CollectionWnd.setSearchString(Info.Name);
                            CollectionWnd.startSearch();
                            CollectionWnd.handleShow();                            
                        }
                        else
                        {
                            // End:0x9D3
                            if(strTarget == "RefineryButton")
                            {
                                // End:0x86B
                                if((Info.ItemType != 0) || Info.CrystalType < 2)
                                {
                                    getInstanceL2Util().showGfxScreenMessage(GetSystemString(8093));
                                    return;
                                }
                                // End:0x931
                                if((Info.RefineryOp1 > 0) || Info.RefineryOp2 > 0)
                                {
                                    UnrefineryWnd(GetScript("UnrefineryWnd")).OnDropItem("ItemUnrefine", Info, 0, 0);
                                    UnrefineryWnd(GetScript("UnrefineryWnd")).ResetReady();
                                    RefineryWnd(GetScript("RefineryWnd")).ResetRefineryData();
                                    RefineryWnd(GetScript("RefineryWnd")).ShowRefineryInterface();                                    
                                }
                                else
                                {
                                    RefineryWnd(GetScript("RefineryWnd")).ResetRefineryData();
                                    RefineryWnd(GetScript("RefineryWnd")).ShowRefineryInterface();
                                    RefineryWnd(GetScript("RefineryWnd")).OnDropItem("ItemDragBox1", Info, 0, 0);
                                    UnrefineryWnd(GetScript("UnrefineryWnd")).ResetReady();
                                }                                
                            }
                            else
                            {
                                // End:0xA7A
                                if(strTarget == "AdenacalculateButton")
                                {
                                    // End:0xA6C
                                    if((IsAdena(Info.Id)) && !Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AdenaDistributionWnd"))
                                    {
                                        CallGFxFunction("AdenaDistributionWnd", "RequestDivideAdenaStart", "");                                        
                                    }
                                    else
                                    {
                                        AddSystemMessage(4158);
                                    }                                    
                                }
                                else
                                {
                                    // End:0xAA3
                                    if(strTarget == "EnchantJewelButton")
                                    {
                                        handleJewelDropedOnButton(Info);
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

function OnDropItemSource(string strTarget, ItemInfo Info)
{
    // End:0x15
    if(strTarget != "Console")
    {
        return;
    }
    // End:0x2C
    if(!isDragSrcInventory(Info.DragSrcName))
    {
        return;
    }
    // End:0x1B9
    if(((IsShowWindow("ItemEnchantWnd")) == false) && (IsShowWindow("AttributeEnchantWnd")) == false)
    {
        m_clickLocation = GetClickLocation();
        // End:0x16B
        if(IsStackableItem(Info.ConsumeType) && __NFUN_409__(Info.ItemNum, (1)))
        {
            // End:0x110
            if(__NFUN_409__(Info.AllItemCount, (0)))
            {
                DialogHide();
                DialogSetID(5555);
                DialogSetReservedItemID(Info.Id);
                DialogSetReservedInt2(Info.AllItemCount);
                DialogShow(1, 4, MakeFullSystemMsg(GetSystemMessage(1833), Info.Name, ""), string(self));                
            }
            else
            {
                DialogHide();
                DialogSetID(4444);
                DialogSetReservedItemID(Info.Id);
                DialogSetParamInt64(Info.ItemNum);
                DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(71), Info.Name, ""), string(self));
            }            
        }
        else
        {
            DialogHide();
            DialogSetID(3333);
            DialogSetReservedItemID(Info.Id);
            DialogShow(1, 4, MakeFullSystemMsg(GetSystemMessage(400), Info.Name, ""), string(self));
        }        
    }
    else
    {
        // End:0x1E8
        if((IsShowWindow("AttributeEnchantWnd")) == true)
        {
            AddSystemMessage(4147);            
        }
        else
        {
            AddSystemMessage(3656);
        }
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0xE1
        case "SortButton":
            switch(m_selectedItemTab)
            {
                // End:0x3E
                case 0:
                    l2utilScript.SortItem(m_invenItem);
                    SaveInventoryOrder();
                    // End:0xDE
                    break;
                // End:0x59
                case 1:
                    l2utilScript.SortItem(m_invenItem_1);
                    // End:0xDE
                    break;
                // End:0x75
                case 2:
                    l2utilScript.SortItem(m_invenItem_2);
                    // End:0xDE
                    break;
                // End:0x91
                case 3:
                    l2utilScript.SortItem(m_invenItem_3);
                    // End:0xDE
                    break;
                // End:0xAD
                case 4:
                    l2utilScript.SortItem(m_invenItem_4);
                    // End:0xDE
                    break;
                // End:0xBB
                case 5:
                    SortQuestItem();
                    // End:0xDE
                    break;
                // End:0xFFFF
                default:
                    l2utilScript.SortItem(m_invenItem);
                    SaveInventoryOrder();
                    // End:0xDE
                    break;
                    break;
            }            
        }/* !MISMATCHING REMOVE, tried Switch got Type:Case Position:0x007! */
        // End:0x584
        break;/* !MISMATCHING REMOVE, tried Case got Type:Switch Position:0x000! */
    // End:0x11E
    case "InventoryTab0":
        m_selectedItemTab = 0;
        m_invenItem.SetScrollPosition(0);
        SetItemCount();
        onCallTabButton(strID);
        // End:0x584
        break;
    // End:0x15B
    case "InventoryTab1":
        m_selectedItemTab = 1;
        m_invenItem_1.SetScrollPosition(0);
        SetItemCount();
        onCallTabButton(strID);
        // End:0x584
        break;
    // End:0x199
    case "InventoryTab2":
        m_selectedItemTab = 2;
        m_invenItem_2.SetScrollPosition(0);
        SetItemCount();
        onCallTabButton(strID);
        // End:0x584
        break;
    // End:0x1D7
    case "InventoryTab3":
        m_selectedItemTab = 3;
        m_invenItem_3.SetScrollPosition(0);
        SetItemCount();
        onCallTabButton(strID);
        // End:0x584
        break;
    // End:0x215
    case "InventoryTab4":
        m_selectedItemTab = 4;
        m_invenItem_4.SetScrollPosition(0);
        SetItemCount();
        onCallTabButton(strID);
        // End:0x584
        break;
    // End:0x253
    case "InventoryTab5":
        m_selectedItemTab = 5;
        m_questItem.SetScrollPosition(0);
        SetItemCount();
        onCallTabButton(strID);
        // End:0x584
        break;
    // End:0x279
    case "BtnWindowExpand":
        extendInventory(currentInvenCol == 9);
        // End:0x584
        break;
    // End:0x314
    case "AdenacalculateButton":
        // End:0x2F6
        if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("PrivateShopWndReport"))
        {
            CallGFxFunction("AdenaDistributionWnd", "RequestDivideAdenaStart", "");            
        }
        else
        {
            getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(5104));
        }
        // End:0x584
        break;
    // End:0x326
    case "HairAccButton":
    // End:0x33E
    case "HairButton":
        ChangeViewAccessoryFunc();
        // End:0x584
        break;
    // End:0x35E
    case "EnchantJewelButton":
        handleEnchantJewelButton();
        // End:0x584
        break;
    // End:0x371
    case "AgathionButton":
    // End:0x392
    case "AgathionCloseButton":
        toggleAgathionWindow();
        // End:0x584
        break;
    // End:0x3A7
    case "AlchemyOpenerBtn":
    // End:0x3C7
    case "AlchemyCloseButton":
        toggleAlchemyOpener();
        // End:0x584
        break;
    // End:0x3E6
    case "AlchemyItemCreateWndBtn":
        // End:0x584
        break;
    // End:0x438
    case "AlchemyItemConversionWndBtn":
        toggleShowAlchemyWindow("AlchemyItemConversionWnd");
        AlchemyOpenerWindow.HideWindow();
        // End:0x584
        break;
    // End:0x47C
    case "AlchemyMixCubeWndBtn":
        toggleShowAlchemyWindow("AlchemyMixCubeWnd");
        AlchemyOpenerWindow.HideWindow();
        // End:0x584
        break;
    // End:0x48C
    case "JewelButton":
    // End:0x4B9
    case "JewelCloseButton":
        hennaSwapContainer.HideWindow();
        toggleJewelWindow();
        // End:0x584
        break;
    // End:0x4C9
    case "HennaButton":
    // End:0x52B
    case "HennaCloseButton":
        JewelWindow.HideWindow();
        toggleWindow(m_hOwnerWnd.GetWindowName() $ ".Equip_Live.EquipItem_Henna_Window");
        // End:0x584
        break;
    // End:0x547
    case "ClearSearchBtn":
        setSearchClear();
        // End:0x584
        break;
    // End:0x562
    case "OpenSearchBtn":
        toggleSearchUI();
        // End:0x584
        break;
    // End:0x57E
    case "RefineryButton":
        toggleRefineryUI();
        // End:0x584
        break;
    // End:0xFFFF
    default:
        // End:0x584
        break;
// Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
// 1 & Type:Switch Position:0x584
return;
// Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
// 1 & Type:Switch Position:0x584
// Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
// 1 & Type:Switch Position:0x584
}

function toggleRefineryUI()
{
    GetWindowHandle("RefineryWnd").ShowWindow();
    GetWindowHandle("UnrefineryWnd").ShowWindow();
    return;
}

function toggleSearchUI()
{
    // End:0x71
    if(GetWindowHandle("InventoryWnd.SearchInputWnd").IsShowWindow())
    {
        m_hOwnerWnd.SetTitlePosOffset(0, 0);
        GetWindowHandle("InventoryWnd.SearchInputWnd").HideWindow();        
    }
    else
    {
        m_hOwnerWnd.SetTitlePosOffset(-50, 0);
        GetWindowHandle("InventoryWnd.SearchInputWnd").ShowWindow();
    }
    return;
}

function InitHandleCOD()
{
    m_hInventoryWnd = GetWindowHandle(m_WindowName);
    m_invenItem = GetItemWindowHandle(m_WindowName $ ".InventoryItem");
    m_invenItem_1 = GetItemWindowHandle(m_WindowName $ ".InventoryItem_1");
    m_invenItem_2 = GetItemWindowHandle(m_WindowName $ ".InventoryItem_2");
    m_invenItem_3 = GetItemWindowHandle(m_WindowName $ ".InventoryItem_3");
    m_invenItem_4 = GetItemWindowHandle(m_WindowName $ ".InventoryItem_4");
    m_questItem = GetItemWindowHandle(m_WindowName $ ".QuestItem");
    m_hAdenaTextBox = GetTextBoxHandle(m_WindowName $ ".AdenaText");
    m_invenTab = GetTabHandle(m_WindowName $ ".InventoryTab");
    m_sortBtn = GetButtonHandle(m_WindowName $ ".SortButton");
    AlchemyOpenerWindow = GetWindowHandle(m_WindowName $ ".AlchemyOpener_Window");
    AlchemyMixCubeWndBtn = GetButtonHandle(m_WindowName $ ".AlchemyOpener_Window.AlchemyMixCubeWndBtn");
    AlchemyItemConversionWndBtn = GetButtonHandle(m_WindowName $ ".AlchemyOpener_Window.AlchemyItemConversionWndBtn");
    AlchemyItemCreateWndBtn = GetButtonHandle(m_WindowName $ ".AlchemyOpener_Window.AlchemyItemCreateWndBtn");
    m_hBtnCrystallize = GetButtonHandle(m_WindowName $ ".CrystallizeButton");
    m_hBtnRefinery = GetButtonHandle(m_WindowName $ ".RefineryButton");
    EnchantJewelButton = GetButtonHandle(m_WindowName $ ".EnchantJewelButton");
    CollectionBtn = GetButtonHandle(m_WindowName $ ".CollectionBtn");
    JewelButton = GetButtonHandle(m_WindowName $ ".Equip_Live.JewelButton");
    AdenacalculateButton = GetButtonHandle(m_WindowName $ ".AdenacalculateButton");
    ColorNickNameWnd = GetWindowHandle("ColorNickNameWnd");
    AlchemyOpenerBtn = GetButtonHandle(m_WindowName $ ".AlchemyOpenerBtn");
    m_BtnWindowExpand = GetButtonHandle(m_WindowName $ ".BtnWindowExpand");
    m_InventoryItembg_expand = GetTextureHandle(m_WindowName $ ".InventoryItembg_expand");
    m_tabbg = GetTextureHandle(m_WindowName $ ".tabbg");
    m_tabbgLine = GetTextureHandle(m_WindowName $ ".tabbgLine");
    m_itemCount = GetTextBoxHandle(m_WindowName $ ".ItemCount");
    m_BtnRotateLeft = GetButtonHandle(m_WindowName $ ".Equip_Live.BtnRotateLeft");
    m_BtnRotateRight = GetButtonHandle(m_WindowName $ ".Equip_Live.BtnRotateRight");
    m_ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".Equip_Live.ObjectViewport");
    m_hPremiumHennaItemWindow = GetItemWindowHandle(m_WindowName $ ".Equip_Live.PremiumHennaItem");
    return;
}

function getHandles()
{
    local string __var759;

    __var759 = (m_WindowName $ ".") $ m_EquipWindowName;
    ViewHairButton = GetButtonHandle(__var759 $ ".HairButton");
    ViewAccessoryButton = GetButtonHandle(__var759 $ ".HairAccButton");
    m_equipItem[1] = GetItemWindowHandle(__var759 $ ".EquipItem_Head");
    m_equipItem[2] = GetItemWindowHandle(__var759 $ ".EquipItem_Hair");
    m_equipItem[3] = GetItemWindowHandle(__var759 $ ".EquipItem_Hair2");
    m_equipItem[4] = GetItemWindowHandle(__var759 $ ".EquipItem_Neck");
    m_equipItem[5] = GetItemWindowHandle(__var759 $ ".EquipItem_RHand");
    m_equipItem[6] = GetItemWindowHandle(__var759 $ ".EquipItem_Chest");
    m_equipItem[7] = GetItemWindowHandle(__var759 $ ".EquipItem_LHand");
    m_equipItem[8] = GetItemWindowHandle(__var759 $ ".EquipItem_REar");
    m_equipItem[9] = GetItemWindowHandle(__var759 $ ".EquipItem_LEar");
    m_equipItem[10] = GetItemWindowHandle(__var759 $ ".EquipItem_Gloves");
    m_equipItem[11] = GetItemWindowHandle(__var759 $ ".EquipItem_Legs");
    m_equipItem[12] = GetItemWindowHandle(__var759 $ ".EquipItem_Feet");
    m_equipItem[13] = GetItemWindowHandle(__var759 $ ".EquipItem_RFinger");
    m_equipItem[14] = GetItemWindowHandle(__var759 $ ".EquipItem_LFinger");
    m_equipItem[15] = GetItemWindowHandle(__var759 $ ".EquipItem_LBracelet");
    m_equipItem[23] = GetItemWindowHandle(__var759 $ ".EquipItem_Cloak");
    m_equipItem[24] = GetItemWindowHandle(__var759 $ ".EquipItem_Waist");
    m_equipItem[17] = GetItemWindowHandle(__var759 $ ".EquipItem_Talisman1");
    m_equipItem[18] = GetItemWindowHandle(__var759 $ ".EquipItem_Talisman2");
    m_equipItem[19] = GetItemWindowHandle(__var759 $ ".EquipItem_Talisman3");
    m_equipItem[20] = GetItemWindowHandle(__var759 $ ".EquipItem_Talisman4");
    m_equipItem[21] = GetItemWindowHandle(__var759 $ ".EquipItem_Talisman5");
    m_equipItem[22] = GetItemWindowHandle(__var759 $ ".EquipItem_Talisman6");
    m_Talisman_Disable[0] = GetTextureHandle(__var759 $ ".Talisman1_Disable");
    m_Talisman_Disable[1] = GetTextureHandle(__var759 $ ".Talisman2_Disable");
    m_Talisman_Disable[2] = GetTextureHandle(__var759 $ ".Talisman3_Disable");
    m_Talisman_Disable[3] = GetTextureHandle(__var759 $ ".Talisman4_Disable");
    m_Talisman_Disable[4] = GetTextureHandle(__var759 $ ".Talisman5_Disable");
    m_Talisman_Disable[5] = GetTextureHandle(__var759 $ ".Talisman6_Disable");
    m_equipItem[16] = GetItemWindowHandle(__var759 $ ".EquipItem_RBracelet");
    m_equipItem[0] = GetItemWindowHandle(__var759 $ ".EquipItem_Underwear");
    m_equipItem[7].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
    m_equipItem[1].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
    m_equipItem[10].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
    m_equipItem[11].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
    m_equipItem[12].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
    m_equipItem[3].SetDisableTex("L2UI.InventoryWnd.Icon_dualcap");
    m_hHennaItemWindow = GetItemWindowHandle(__var759 $ ".HennaItem");
    m_equipItem[1].SetTooltipText(GetSystemString(230));
    m_equipItem[2].SetTooltipText(GetSystemString(1024));
    m_equipItem[3].SetTooltipText(GetSystemString(1024));
    m_equipItem[4].SetTooltipText(GetSystemString(238));
    m_equipItem[5].SetTooltipText(GetSystemString(2520));
    m_equipItem[6].SetTooltipText(GetSystemString(38));
    m_equipItem[7].SetTooltipText(GetSystemString(231));
    m_equipItem[8].SetTooltipText(GetSystemString(237));
    m_equipItem[9].SetTooltipText(GetSystemString(237));
    m_equipItem[10].SetTooltipText(GetSystemString(37));
    m_equipItem[11].SetTooltipText(GetSystemString(39));
    m_equipItem[12].SetTooltipText(GetSystemString(40));
    m_equipItem[13].SetTooltipText(GetSystemString(239));
    m_equipItem[14].SetTooltipText(GetSystemString(239));
    m_equipItem[15].SetTooltipText(GetSystemString(1637));
    m_equipItem[23].SetTooltipText(GetSystemString(234));
    m_equipItem[24].SetTooltipText(GetSystemString(2538));
    m_equipItem[16].SetTooltipText(GetSystemString(1636));
    m_equipItem[17].SetTooltipText(GetSystemString(1638));
    m_equipItem[18].SetTooltipText(GetSystemString(1638));
    m_equipItem[19].SetTooltipText(GetSystemString(1638));
    m_equipItem[20].SetTooltipText(GetSystemString(1638));
    m_equipItem[21].SetTooltipText(GetSystemString(1638));
    m_equipItem[22].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[0].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[1].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[2].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[3].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[4].SetTooltipText(GetSystemString(1638));
    m_Talisman_Disable[5].SetTooltipText(GetSystemString(1638));
    m_equipItem[0].SetTooltipText(GetSystemString(28));
    m_hHennaItemWindow.SetTooltipText(GetSystemString(7956));
    setCustomTooltip();
    return;
}

function setBottomButtonPostion(out int Num, ButtonHandle tmpBottomButton)
{
    local int __var19942, __var19941;

    __var19942 = 207;
    __var19941 = 39;
    tmpBottomButton.SetAnchor(m_WindowName, "TopLeft", "TopLeft", __var19942 + (Num * __var19941), 352);
    ++Num;
    return;
}

function setButtons()
{
    local int __var19939, __var8204;

    setBottomButtonPostion(__var8204, m_hBtnRefinery);
    m_hBtnRefinery.ShowWindow();
    m_hBtnCrystallize.HideWindow();
    EnchantJewelButton.HideWindow();
    CollectionBtn.HideWindow();
    // End:0x74
    if(isCrafter())
    {
        setBottomButtonPostion(__var8204, m_hBtnCrystallize);
        m_hBtnCrystallize.ShowWindow();
    }
    GetINIBool("Localize", "UseClassicJewelEnchantBtn", __var19939, "L2.ini");
    // End:0xD6
    if(__var19939 == 1)
    {
        setBottomButtonPostion(__var8204, EnchantJewelButton);
        EnchantJewelButton.ShowWindow();
    }
    // End:0x118
    if(SettingSectorBool("COLLECTION", "COLLECION_UI"))
    {
        setBottomButtonPostion(__var8204, CollectionBtn);
        CollectionBtn.ShowWindow();
    }
    return;
}

function HandleDialogOK()
{
    local int __var2240;
    local INT64 __var6879;
    local ItemID sID;
    local INT64 __var3954;

    // End:0x25B
    if(DialogIsMine())
    {
        __var2240 = DialogGetID();
        __var6879 = DialogGetReservedInt2();
        __var3954 = (DialogGetString());
        sID = DialogGetReservedItemID();
        // End:0x53
        if(__var2240 == 1000003)
        {
            requestChangeHennaTemplate();            
        }
        else
        {
            // End:0x81
            if((__var2240 == 1111) || __var2240 == 2222)
            {
                RequestUseItem(sID);                
            }
            else
            {
                // End:0xBD
                if(__var2240 == 3333)
                {
                    onItemGroundDrop(sID, (1), m_clickLocation);
                    RequestDropItem(sID, (1), m_clickLocation);                    
                }
                else
                {
                    // End:0x114
                    if(__var2240 == 4444)
                    {
                        // End:0xE3
                        if(__NFUN_412__(__var3954, (0)))
                        {
                            __var3954 = (1);
                        }
                        onItemGroundDrop(sID, __var3954, m_clickLocation);
                        RequestDropItem(sID, __var3954, m_clickLocation);                        
                    }
                    else
                    {
                        // End:0x154
                        if(__var2240 == 5555)
                        {
                            onItemGroundDrop(sID, __var6879, m_clickLocation);
                            RequestDropItem(sID, __var6879, m_clickLocation);                            
                        }
                        else
                        {
                            // End:0x18E
                            if(__var2240 == 6666)
                            {
                                onItemDelete(sID, (1));
                                RequestDestroyItem(sID, (1));
                                PlayConsoleSound(4);                                
                            }
                            else
                            {
                                // End:0x1CC
                                if(__var2240 == 8888)
                                {
                                    onItemDelete(sID, __var3954);
                                    RequestDestroyItem(sID, __var3954);
                                    PlayConsoleSound(4);                                    
                                }
                                else
                                {
                                    // End:0x20A
                                    if(__var2240 == 7777)
                                    {
                                        onItemDelete(sID, __var6879);
                                        RequestDestroyItem(sID, __var6879);
                                        PlayConsoleSound(4);                                        
                                    }
                                    else
                                    {
                                        // End:0x232
                                        if(__var2240 == 9999)
                                        {
                                            RequestCrystallizeItem(sID, (1));
                                            PlayConsoleSound(4);                                            
                                        }
                                        else
                                        {
                                            // End:0x25B
                                            if(__var2240 == 10000)
                                            {
                                                Class'NWindow.PetAPI'.static.RequestGetItemFromPet(sID, __var3954, false);
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

function handlePacket(string param)
{
    local int __var19921;

    ParseInt(param, "EventID", __var19921);
    switch(__var19921)
    {
        // End:0x36
        case 1210:
            handleHennaTemplates(param);
            // End:0x52
            break;
        // End:0x4C
        case 1211:
            handleHennaTemplateResult(param);
            // End:0x52
            break;
        // End:0xFFFF
        default:
            // End:0x52
            break;
            break;
    }
    return;
}

function handleHennaTemplates(string param)
{
    local int __var2239, __var10437, __var19913;
    local string __var19912, __var19903, __var19899;
    local array<string> template1, template2, template3;

    ParseInt(param, "ask", __var10437);
    ParseInt(param, "reply", __var19913);
    ParseString(param, "param1", __var19912);
    ParseString(param, "param2", __var19903);
    ParseString(param, "param3", __var19899);
    currentHennaTemplate = __var10437;
    hennaTemplates.commission = (__var19913);
    template1 = Arr(__var19912, ",");
    template2 = Arr(__var19903, ",");
    template3 = Arr(__var19899, ",");
    resetHennaTemplates();
    showActiveTemplate(__var10437);
    hennaTemplates.Templates.Remove(0, hennaTemplates.Templates.Length);
    hennaTemplates.Templates[0].Template.Length = 0;
    hennaTemplates.Templates[1].Template.Length = 0;
    hennaTemplates.Templates[2].Template.Length = 0;
    hennaTemplates.Templates.Length = 3;
    __var2239 = 0;
    J0x147:

    // End:0x193 [Loop If]
    if(__var2239 < template1.Length)
    {
        hennaTemplates.Templates[0].Template[hennaTemplates.Templates[0].Template.Length] = int(template1[__var2239]);
        __var2239++;
        // [Loop Continue]
        goto J0x147;
    }
    __var2239 = 0;
    J0x19A:

    // End:0x1E6 [Loop If]
    if(__var2239 < template2.Length)
    {
        hennaTemplates.Templates[1].Template[hennaTemplates.Templates[1].Template.Length] = int(template2[__var2239]);
        __var2239++;
        // [Loop Continue]
        goto J0x19A;
    }
    __var2239 = 0;
    J0x1ED:

    // End:0x23B [Loop If]
    if(__var2239 < template3.Length)
    {
        hennaTemplates.Templates[2].Template[hennaTemplates.Templates[2].Template.Length] = int(template3[__var2239]);
        __var2239++;
        // [Loop Continue]
        goto J0x1ED;
    }
    updateTemplates();
    return;
}

function handleHennaTemplateResult(string param)
{
    local int __var19888;

    ParseInt(param, "ask", __var19888);
    // End:0x5D
    if(__var19888 == 1)
    {
        hennaTemplateSuccessTex.ShowWindow();
        hennaTemplateSuccessTex.SetLoopCount(1);
        hennaTemplateSuccessTex.Stop();
        hennaTemplateSuccessTex.Play();
    }
    return;
}

function int showActiveTemplate(int Index)
{
    hennaTemplatesUI[Index].hennaTemplateWnd.ClearAnchor();
    hennaTemplatesUI[Index].hennaTemplateWnd.SetAlpha(255);
    hennaTemplatesUI[Index].hennaTemplateWnd.SetBackTexture("L2UI_ct1.Windows.Windows_DF_Drawer_Bg");
    hennaTemplatesUI[Index].hennaTemplateWnd.Move(0, -10, 0.1000000);
    return;
}

function updateTemplates()
{
    local int __var1557, __var4071;
    local INT64 __var10451;
    local ItemInfo henna;
    local array<DrawItemInfo> drawListArr;

    __var1557 = 0;
    J0x07:

    // End:0x477 [Loop If]
    if(__var1557 < hennaTemplates.Templates.Length)
    {
        drawListArr.Remove(0, drawListArr.Length);
        hennaTemplatesUI[__var1557].hennaTemplateItem.Clear();
        drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(GetSystemString(7952), true, true, 0, 0, 140, GetColor(255, 255, 0, 255));
        drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE("", true, true, 0, 0, 140, GetColor(255, 255, 0, 255));
        // End:0x2A5
        if(hennaTemplates.Templates[__var1557].Template.Length > 0)
        {
            __var4071 = 0;
            J0xBF:

            // End:0x292 [Loop If]
            if(__var4071 < hennaTemplates.Templates[__var1557].Template.Length)
            {
                henna.Name = Class'NWindow.UIDATA_HENNA'.static.GetItemNameS(hennaTemplates.Templates[__var1557].Template[__var4071]);
                henna.AdditionalName = Class'NWindow.UIDATA_HENNA'.static.GetAddtionNameS(hennaTemplates.Templates[__var1557].Template[__var4071]);
                henna.Description = Class'NWindow.UIDATA_HENNA'.static.GetDescriptionS(hennaTemplates.Templates[__var1557].Template[__var4071]);
                henna.IconName = Class'NWindow.UIDATA_HENNA'.static.GetIconTexS(hennaTemplates.Templates[__var1557].Template[__var4071]);
                hennaTemplatesUI[__var1557].hennaTemplateItem.AddItem(henna);
                drawListArr[drawListArr.Length] = TLTP_TEXTURE_LINE(henna.IconName, false, true, 2, 0, 32, 32);
                drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(henna.Name, true, false, 4, 0, 140, GetColor(255, 255, 255, 255));
                drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(henna.AdditionalName, false, true, 38, -13, 140, GetColor(200, 200, 200, 255));
                drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE("", true, true, 0, 0, 140, GetColor(255, 255, 0, 255));
                __var4071++;
                // [Loop Continue]
                goto J0xBF;
            }
            __var10451 = hennaTemplates.commission;            
        }
        else
        {
            drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE("", true, true, 0, 0, 140, GetColor(255, 255, 0, 255));
            drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(GetSystemString(7959), true, true, 0, 0, 140, GetColor(200, 200, 200, 255));
            drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE("", true, true, 0, 0, 140, GetColor(255, 255, 0, 255));
            __var10451 = (0);
        }
        drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE("", true, true, 0, 0, 140, GetColor(255, 255, 0, 255));
        // End:0x3DD
        if(__var1557 != currentHennaTemplate)
        {
            drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(GetSystemString(7953), true, true, 0, 0, 140, GetColor(255, 255, 0, 255));
            drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(MakeFullSystemMsg(GetSystemString(7960), MakeCostStringINT64(__var10451)), true, true, 0, 0, 140, GetColor(255, 255, 0, 255));            
        }
        else
        {
            drawListArr[drawListArr.Length] = TLTP_COLOR_TEXT_LINE(GetSystemString(7958), true, false, 0, 0, 140, GetColor(255, 255, 0, 255));
        }
        hennaTemplatesUI[__var1557].hennaTemplateWnd.ClearTooltip();
        hennaTemplatesUI[__var1557].hennaTemplateWnd.SetTooltipType("Text");
        hennaTemplatesUI[__var1557].hennaTemplateWnd.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
        __var1557++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function resetHennaTemplates()
{
    local int __var5191;

    __var5191 = 0;
    J0x07:

    // End:0x91 [Loop If]
    if(__var5191 < 3)
    {
        hennaTemplatesUI[__var5191].hennaTemplateItem.Clear();
        hennaTemplatesUI[__var5191].hennaTemplateWnd.SetAlpha(80);
        hennaTemplatesUI[__var5191].hennaTemplateWnd.SetBackTexture("L2UI_CT1.GroupBox.GroupBox_DF_Text");
        __var5191++;
        // [Loop Continue]
        goto J0x07;
    }
    hennaTemplatesUI[0].hennaTemplateWnd.SetAnchor(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Henna_Window", "TopLeft", "TopLeft", 5, 45);
    hennaTemplatesUI[1].hennaTemplateWnd.SetAnchor(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Henna_Window", "TopLeft", "TopLeft", 42, 45);
    hennaTemplatesUI[2].hennaTemplateWnd.SetAnchor(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Henna_Window", "TopLeft", "TopLeft", 79, 45);
    return;
}

function int GetHennaIndex(string winName)
{
    // End:0x46
    if(InStr(winName, "HennaTemplateItem0") > -1)
    {
        return int(Locs(winName, "HennaTemplateItem0", "", true));
    }
    return -1;
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    // End:0x22
    if(a_WindowHandle == m_BtnRotateLeft)
    {
        m_ObjectViewport.StartRotation(false);        
    }
    else
    {
        // End:0x44
        if(a_WindowHandle == m_BtnRotateRight)
        {
            m_ObjectViewport.StartRotation(true);            
        }
        else
        {
            // End:0xAB
            if((InStr(a_WindowHandle.GetWindowName(), "HennaTemplate0") > -1) || InStr(a_WindowHandle.GetWindowName(), "HennaTemplateItem0") > -1)
            {
                handleChangeTemplate(a_WindowHandle);
            }
        }
    }
    return;
}

function OnLButtonUp(WindowHandle a_WindowHandle, int X, int Y)
{
    // End:0x21
    if(a_WindowHandle == m_BtnRotateLeft)
    {
        m_ObjectViewport.EndRotation();        
    }
    else
    {
        // End:0x3F
        if(a_WindowHandle == m_BtnRotateRight)
        {
            m_ObjectViewport.EndRotation();
        }
    }
    return;
}

function handleChangeTemplate(WindowHandle win)
{
    local int __var4017;

    // End:0x57
    if(InStr(win.GetWindowName(), "HennaTemplate0") > -1)
    {
        __var4017 = int(Locs(win.GetWindowName(), "HennaTemplate0", "", true));
    }
    // End:0xB6
    if(InStr(win.GetWindowName(), "HennaTemplateItem0") > -1)
    {
        __var4017 = int(Locs(win.GetWindowName(), "HennaTemplateItem0", "", true));
    }
    // End:0xF3
    if(__var4017 == currentHennaTemplate)
    {
        AddSystemMessageString(GetSystemString(7955));
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(7955));
        return;
    }
    DialogSetID(1000003);
    DialogSetReservedInt(__var4017);
    // End:0x160
    if(hennaTemplates.Templates[__var4017].Template.Length > 0)
    {
        DialogShow(1, 4, MakeFullSystemMsg(GetSystemString(7954), string(__var4017 + 1), MakeCostStringINT64(hennaTemplates.commission)), string(self));        
    }
    else
    {
        DialogShow(1, 4, MakeFullSystemMsg(GetSystemString(7954), string(__var4017 + 1), MakeCostStringINT64((0))), string(self));
    }
    return;
}

function requestChangeHennaTemplate()
{
    local int __var19865;

    __var19865 = DialogGetReservedInt();
    RequestBypassToServer("dyetemplate" @ string(__var19865));
    return;
}

function requestHennaTemplates()
{
    RequestBypassToServer("dyetemplate update");
    return;
}

function handleHennaUI(int N)
{
    switch(N)
    {
        // End:0x1D
        case 0:
            RequestBypassToServer("dye add");
            // End:0x3C
            break;
        // End:0x36
        case 1:
            RequestBypassToServer("dye remove");
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            // End:0x3C
            break;
            break;
    }
    return;
}

function OnMouseOver(WindowHandle W)
{
    local Rect Rect;
    local int __var19864;

    __var19864 = GetHennaIndex(W.GetWindowName());
    // End:0x2C
    if(__var19864 == -1)
    {
        return;
    }
    return;
}

function OnMouseOut(WindowHandle W)
{
    local Rect Rect;
    local int __var19863, __var45679, __var45678;

    __var19863 = GetHennaIndex(W.GetWindowName());
    // End:0x2C
    if(__var19863 == -1)
    {
        return;
    }
    return;
}

function setEquipWindowHandle()
{
    local int __var4016;
    local ItemInfo item;
    local string __var2483, __var7934, __var2629;

    m_EquipWindowName = "Equip_Live";
    setButtons();
    GetWindowHandle(m_WindowName $ ".Equip_Live").HideWindow();
    GetWindowHandle(m_WindowName $ ".Equip_classic").HideWindow();
    GetWindowHandle((m_WindowName $ ".") $ m_EquipWindowName).ShowWindow();
    HennaButton = GetButtonHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".HennaButton");
    hennaSwapContainer = GetWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Henna_Window");
    hennaTemplateSuccessTex = GetAnimTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".hennaTemplateSuccessTex");
    hennaSwapContainer.HideWindow();
    hennaTemplatesUI.Length = 3;
    __var4016 = 0;
    J0x141:

    // End:0x22D [Loop If]
    if(__var4016 < 3)
    {
        hennaTemplatesUI[__var4016].hennaTemplateWnd = GetWindowHandle((((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Henna_Window.HennaTemplate0") $ string(__var4016));
        hennaTemplatesUI[__var4016].hennaTemplateItem = GetItemWindowHandle((((((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Henna_Window.HennaTemplate0") $ string(__var4016)) $ ".HennaTemplateItem0") $ string(__var4016));
        __var4016++;
        // [Loop Continue]
        goto J0x141;
    }
    JewelButton = GetButtonHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".JewelButton");
    JewelWindow = GetWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window");
    m_equipItem_Brooch = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.EquipItem_Brooch");
    m_BroochEquiped = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.BroochEquiped");
    m_equipItem[25] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Brooch");
    m_equipItem[26] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.EquipItem_Jewel1");
    m_equipItem[27] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.EquipItem_Jewel2");
    m_equipItem[28] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.EquipItem_Jewel3");
    m_equipItem[29] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.EquipItem_Jewel4");
    m_equipItem[30] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.EquipItem_Jewel5");
    m_equipItem[31] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.EquipItem_Jewel6");
    m_Jewel_Disable[0] = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.Jewel1_Disable");
    m_Jewel_Disable[1] = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.Jewel2_Disable");
    m_Jewel_Disable[2] = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.Jewel3_Disable");
    m_Jewel_Disable[3] = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.Jewel4_Disable");
    m_Jewel_Disable[4] = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.Jewel5_Disable");
    m_Jewel_Disable[5] = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Jewel_Window.Jewel6_Disable");
    m_equipItem_Brooch.SetTooltipText(GetSystemString(3186));
    m_equipItem[25].SetTooltipText(GetSystemString(3186));
    AgathionWindow = GetWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Agathion_Window");
    AgathionBtn = GetButtonHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".AgathionButton");
    m_Agathion_Disable[0] = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Agathion_Window.AgathionMain_Disable");
    m_Agathion_Disable[1] = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Agathion_Window.Agathion1_Disable");
    m_Agathion_Disable[2] = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Agathion_Window.Agathion2_Disable");
    m_Agathion_Disable[3] = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Agathion_Window.Agathion3_Disable");
    m_Agathion_Disable[4] = GetTextureHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Agathion_Window.Agathion4_Disable");
    m_equipItem[32] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Agathion_Window.EquipItem_AgathionMain");
    m_equipItem[33] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub1");
    m_equipItem[34] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub2");
    m_equipItem[35] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub3");
    m_equipItem[36] = GetItemWindowHandle(((m_WindowName $ ".") $ m_EquipWindowName) $ ".EquipItem_Agathion_Window.EquipItem_AgathionSub4");
    __var2483 = getHyphenByLanguage();
    __var7934 = GetSystemString(2738) @ GetSystemString(3638);
    __var2629 = GetSystemString(2341) @ GetSystemString(3638);
    // End:0xB2C
    if(int(GetLanguage()) != 0)
    {
        __var7934 = GetSystemString(5864);
        __var2629 = GetSystemString(5865);
    }
    m_Agathion_Disable[0].SetTooltipCustomType(getAgathionTooltip(__var7934, __var2483 $ GetSystemString(3642)));
    m_Agathion_Disable[1].SetTooltipCustomType(getAgathionTooltip(__var2629, __var2483 $ GetSystemString(3643)));
    m_Agathion_Disable[2].SetTooltipCustomType(getAgathionTooltip(__var2629, __var2483 $ GetSystemString(3643)));
    m_Agathion_Disable[3].SetTooltipCustomType(getAgathionTooltip(__var2629, __var2483 $ GetSystemString(3643)));
    m_Agathion_Disable[4].SetTooltipCustomType(getAgathionTooltip(__var2629, __var2483 $ GetSystemString(3643)));
    m_equipItem[32].SetTooltipText(((__var7934 $ "\\n") $ __var2483) $ GetSystemString(3642));
    m_equipItem[33].SetTooltipText(((__var2629 $ "\\n") $ __var2483) $ GetSystemString(3643));
    m_equipItem[34].SetTooltipText(((__var2629 $ "\\n") $ __var2483) $ GetSystemString(3643));
    m_equipItem[35].SetTooltipText(((__var2629 $ "\\n") $ __var2483) $ GetSystemString(3643));
    m_equipItem[36].SetTooltipText(((__var2629 $ "\\n") $ __var2483) $ GetSystemString(3643));
    m_EquipWindow = GetWindowHandle((m_WindowName $ ".") $ m_EquipWindowName);
    return;
}

function string getHyphenByLanguage()
{
    // End:0x1D
    if(int(GetLanguage()) == 0)
    {
        return "ï¿½ï¿½";
    }
    return "-";
    return;
}

function HandleRestart()
{
    m_bCurrentState = false;
    m_bFirstOpen = true;
    m_hInventoryWnd.HideWindow();
    bIsRequestItemList = false;
    m_hOwnerWnd.KillTimer(1718);
    return;
}

delegate onItemGroundDrop(ItemID ItemID, INT64 Count, Vector Location)
{
    return;
}

delegate onItemDelete(ItemID ItemID, INT64 Count)
{
    return;
}

function ChangeViewAccessoryFunc()
{
    local ItemInfo infItem;

    infItem.Id.ClassID = 17192;
    UseSkill(infItem.Id, 2);
    return;
}

function UseItem(ItemWindowHandle a_hItemWindow, int Index)
{
    local ItemInfo Info;

    // End:0xCB
    if(a_hItemWindow.GetItem(Index, Info))
    {
        // End:0xCB
        if(Info.bDisabled == 0)
        {
            // End:0x70
            if(Info.bRecipe)
            {
                DialogSetReservedItemID(Info.Id);
                DialogSetID(1111);
                DialogShow(1, 4, GetSystemMessage(798), string(self));                
            }
            else
            {
                // End:0xBB
                if(Info.PopMsgNum > 0)
                {
                    DialogSetID(2222);
                    DialogSetReservedItemID(Info.Id);
                    DialogShow(1, 4, GetSystemMessage(Info.PopMsgNum), string(self));                    
                }
                else
                {
                    RequestUseItem(Info.Id);
                }
            }
        }
    }
    return;
}

function handleJewelDropedOnButton(ItemInfo Info)
{
    local ItemJewelEnchantWnd script;

    script = ItemJewelEnchantWnd(GetScript("ItemJewelEnchantWnd"));
    script.handleDropedItem(Info);
    return;
}

function UpdateItemUsability()
{
    m_invenItem.SetItemUsability();
    m_invenItem_1.SetItemUsability();
    m_invenItem_2.SetItemUsability();
    m_invenItem_3.SetItemUsability();
    m_invenItem_4.SetItemUsability();
    m_questItem.SetItemUsability();
    return;
}

function HandleUpdateItem(string param)
{
    local ItemInfo beforeItem;
    local string __var7208;
    local ItemInfo Info;
    local int __var4003;
    local ItemWindowHandle detailItemWindowHandle;

    lastHandleAddItemParam = param;
    ParseString(param, "type", __var7208);
    ParamToItemInfo(param, Info);
    zAutoPotionWnd(GetScript("AutoPotionWnd")).UpdateItem(Info, __var7208);
    // End:0xF2
    if(__var7208 == "add")
    {
        // End:0x9E
        if(IsEquipItem(Info))
        {
            QuitReportWndScript.externalAddItem(Info);
            EquipItemUpdate(Info);            
        }
        else
        {
            // End:0xC5
            if(IsQuestItem(Info))
            {
                QuestInvenAddItem(Info);
                handleNewItem(Info);                
            }
            else
            {
                QuitReportWndScript.externalAddItem(Info);
                NormalInvenAddItem(Info);
                handleNewItem(Info);
            }
        }        
    }
    else
    {
        // End:0x31D
        if(__var7208 == "update")
        {
            // End:0x14C
            if(IsEquipItem(Info))
            {
                // End:0x133
                if(EquipItemFind(Info.Id))
                {
                    EquipItemUpdate(Info);                    
                }
                else
                {
                    InvenDelete(Info);
                    EquipItemUpdate(Info);
                }                
            }
            else
            {
                // End:0x20B
                if(IsQuestItem(Info))
                {
                    __var4003 = m_questItem.FindItem(Info.Id);
                    // End:0x1E2
                    if(__var4003 != -1)
                    {
                        m_questItem.GetItem(__var4003, beforeItem);
                        m_questItem.SetItem(__var4003, Info);
                        // End:0x1DF
                        if(__NFUN_408__(beforeItem.ItemNum, Info.ItemNum))
                        {
                            handleNewItem(Info);
                        }                        
                    }
                    else
                    {
                        EquipItemDelete(Info.Id);
                        QuestInvenAddItem(Info);
                        handleNewItem(Info);
                    }                    
                }
                else
                {
                    __var4003 = m_invenItem.FindItem(Info.Id);
                    // End:0x2FF
                    if(__var4003 != -1)
                    {
                        m_invenItem.GetItem(__var4003, beforeItem);
                        // End:0x280
                        if(__NFUN_413__(beforeItem.ItemNum, Info.ItemNum))
                        {
                            QuitReportWndScript.externalAddItem(Info);
                        }
                        m_invenItem.SetItem(__var4003, Info);
                        detailItemWindowHandle = getItemWindowHandleByItemType(Info);
                        detailItemWindowHandle.SetItem(detailItemWindowHandle.FindItem(Info.Id), Info);
                        // End:0x2FC
                        if(__NFUN_408__(beforeItem.ItemNum, Info.ItemNum))
                        {
                            handleNewItem(Info);
                        }                        
                    }
                    else
                    {
                        EquipItemDelete(Info.Id);
                        NormalInvenAddItem(Info);
                    }
                }
            }            
        }
        else
        {
            // End:0x377
            if(__var7208 == "delete")
            {
                // End:0x350
                if(IsEquipItem(Info))
                {
                    EquipItemDelete(Info.Id);                    
                }
                else
                {
                    // End:0x36C
                    if(IsQuestItem(Info))
                    {
                        QuestInvenDelete(Info);                        
                    }
                    else
                    {
                        InvenDelete(Info);
                    }
                }
            }
        }
    }
    UpdateItemUsability();
    SetAdenaText();
    SetItemCount();
    return;
}

function HandleItemListEnd()
{
    // End:0x15
    if(!bIsQuestItemList)
    {
        bIsQuestItemList = true;
        return;
    }
    SetAdenaText();
    SetItemCount();
    UpdateItemUsability();
    // End:0x36
    if(bIsSavedLocalItemIdx)
    {
        SaveInventoryOrder();
    }
    l2utilScript.SortItem(m_invenItem_1);
    l2utilScript.SortItem(m_invenItem_2);
    l2utilScript.SortItem(m_invenItem_3);
    l2utilScript.SortItem(m_invenItem_4);
    PlayConsoleSound(13);
    return;
}

function HandleAddItem(string param)
{
    local ItemInfo Info;

    ParamToItemInfo(param, Info);
    // End:0x2C
    if(IsEquipItem(Info))
    {
        EquipItemUpdate(Info);        
    }
    else
    {
        // End:0x48
        if(IsQuestItem(Info))
        {
            QuestInvenAddItem(Info);            
        }
        else
        {
            NormalInvenAddItem(Info);
        }
    }
    return;
}

function NormalInvenAddItem(ItemInfo NewItem)
{
    local int __var2642, __var10473, __var2471;
    local ItemInfo curItem;
    local ItemWindowHandle detailItemWindow;

    __var2471 = -1;
    __var10473 = m_invenItem.GetItemNum();
    // End:0x5D
    if(bIsSavedLocalItemIdx)
    {
        NewItem.ORDER = getLocalItemOrder(NewItem.Id.ServerID, itemSwapedServerID, itemSwapedIdx, NewItem.ORDER);
    }
    // End:0xA3
    if(m_invenItem.GetItem(NewItem.ORDER, curItem))
    {
        // End:0xA3
        if(!IsValidItemID(curItem.Id))
        {
            __var2471 = NewItem.ORDER;
        }
    }
    // End:0x10D
    if(__var2471 < 0)
    {
        __var2642 = 0;
        J0xB5:

        // End:0x10D [Loop If]
        if(__var2642 < __var10473)
        {
            // End:0x103
            if(m_invenItem.GetItem(__var2642, curItem))
            {
                // End:0x103
                if(!IsValidItemID(curItem.Id))
                {
                    __var2471 = __var2642;
                    // [Explicit Break]
                    goto J0x10D;
                }
            }
            __var2642++;
            // [Loop Continue]
            goto J0xB5;
        }
    }
    J0x10D:

    // End:0x138
    if(__var2471 > -1)
    {
        m_invenItem.SetItem(__var2471, NewItem);        
    }
    else
    {
        m_invenItem.AddItem(NewItem);
    }
    m_NormalInvenCount++;
    detailItemWindow = getItemWindowHandleByItemType(NewItem);
    // End:0x195
    if(bIsSavedLocalItemIdx)
    {
        __var2471 = getLocalItemOrderByItemWindow(detailItemWindow, NewItem.Id.ServerID, -1);        
    }
    else
    {
        __var2471 = -1;
        __var2642 = 0;
        J0x1A7:

        // End:0x1FF [Loop If]
        if(__var2642 < __var10473)
        {
            // End:0x1F5
            if(detailItemWindow.GetItem(__var2642, curItem))
            {
                // End:0x1F5
                if(!IsValidItemID(curItem.Id))
                {
                    __var2471 = __var2642;
                    // [Explicit Break]
                    goto J0x1FF;
                }
            }
            __var2642++;
            // [Loop Continue]
            goto J0x1A7;
        }
    }
    J0x1FF:

    // End:0x22A
    if(__var2471 > -1)
    {
        detailItemWindow.SetItem(__var2471, NewItem);        
    }
    else
    {
        detailItemWindow.AddItem(NewItem);
    }
    zAutoPotionWnd(GetScript("zAutoPotionWnd")).UpdateItem(NewItem, "add");
    return;
}

function QuestInvenAddItem(ItemInfo NewItem)
{
    local int __var7267, __var19833, __var4054;
    local ItemInfo curItem;

    __var4054 = -1;
    // End:0x3C
    if(bIsSavedLocalItemIdx)
    {
        __var4054 = getLocalItemOrderByItemWindow(m_questItem, NewItem.Id.ServerID, -1);        
    }
    else
    {
        // End:0x82
        if(m_questItem.GetItem(NewItem.ORDER, curItem))
        {
            // End:0x82
            if(!IsValidItemID(curItem.Id))
            {
                __var4054 = NewItem.ORDER;
            }
        }
    }
    // End:0x101
    if(__var4054 < 0)
    {
        __var19833 = m_questItem.GetItemNum();
        __var7267 = 0;
        J0xA9:

        // End:0x101 [Loop If]
        if(__var7267 < __var19833)
        {
            // End:0xF7
            if(m_questItem.GetItem(__var7267, curItem))
            {
                // End:0xF7
                if(!IsValidItemID(curItem.Id))
                {
                    __var4054 = __var7267;
                    // [Explicit Break]
                    goto J0x101;
                }
            }
            __var7267++;
            // [Loop Continue]
            goto J0xA9;
        }
    }
    J0x101:

    // End:0x12C
    if(__var4054 > -1)
    {
        m_questItem.SetItem(__var4054, NewItem);        
    }
    else
    {
        m_questItem.AddItem(NewItem);
    }
    m_QuestInvenCount++;
    return;
}

function handleAgathionEquip(ItemInfo a_Info)
{
    local int __var7320;

    __var7320 = GetAgathionIndex(a_Info.Id);
    // End:0x75
    if(__var7320 != -1)
    {
        m_equipItem[32 + __var7320].Clear();
        m_equipItem[32 + __var7320].AddItem(a_Info);
        m_equipItem[32 + __var7320].EnableWindow();
    }
    return;
}

function EarItemUpdate()
{
    local int __var4067, __var7802, __var7798;

    __var7802 = -1;
    __var7798 = -1;
    __var4067 = 0;
    J0x1D:

    // End:0x90 [Loop If]
    if(__var4067 < m_EarItemList.Length)
    {
        switch(IsLOrREar(m_EarItemList[__var4067].Id))
        {
            // End:0x5B
            case -1:
                __var7802 = __var4067;
                // End:0x86
                break;
            // End:0x6E
            case 0:
                m_EarItemList.Remove(__var4067, 1);
                // End:0x86
                break;
            // End:0x80
            case 1:
                __var7798 = __var4067;
                // End:0x86
                break;
            // End:0xFFFF
            default:
                // End:0x86
                break;
                break;
        }
        ++__var4067;
        // [Loop Continue]
        goto J0x1D;
    }
    // End:0xCE
    if(-1 != __var7802)
    {
        m_equipItem[9].Clear();
        m_equipItem[9].AddItem(m_EarItemList[__var7802]);
    }
    // End:0x10C
    if(-1 != __var7798)
    {
        m_equipItem[8].Clear();
        m_equipItem[8].AddItem(m_EarItemList[__var7798]);
    }
    return;
}

function FingerItemUpdate()
{
    local int __var4070, __var7780, __var7779;

    __var7780 = -1;
    __var7779 = -1;
    __var4070 = 0;
    J0x1D:

    // End:0x90 [Loop If]
    if(__var4070 < m_FingerItemLIst.Length)
    {
        switch(IsLOrRFinger(m_FingerItemLIst[__var4070].Id))
        {
            // End:0x5B
            case -1:
                __var7780 = __var4070;
                // End:0x86
                break;
            // End:0x6E
            case 0:
                m_FingerItemLIst.Remove(__var4070, 1);
                // End:0x86
                break;
            // End:0x80
            case 1:
                __var7779 = __var4070;
                // End:0x86
                break;
            // End:0xFFFF
            default:
                // End:0x86
                break;
                break;
        }
        ++__var4070;
        // [Loop Continue]
        goto J0x1D;
    }
    // End:0xCE
    if(-1 != __var7780)
    {
        m_equipItem[14].Clear();
        m_equipItem[14].AddItem(m_FingerItemLIst[__var7780]);
    }
    // End:0x10C
    if(-1 != __var7779)
    {
        m_equipItem[13].Clear();
        m_equipItem[13].AddItem(m_FingerItemLIst[__var7779]);
    }
    return;
}

function EquipItemUpdate(ItemInfo a_Info)
{
    local ItemWindowHandle hItemWnd;
    local ItemInfo TheItemInfo;
    local bool __var7705;
    local ItemInfo rHand, LHand, Legs, Gloves, Feet, Hair2;

    local int __var2234, __var7511, __var7518;

    switch(a_Info.SlotBitType)
    {
        // End:0x22
        case (1):
            hItemWnd = m_equipItem[0];
            // End:0x972
            break;
        // End:0x29
        case (2):
        // End:0x30
        case (4):
        // End:0xD4
        case (6):
            __var2234 = 0;
            J0x3E:

            // End:0x8F [Loop If]
            if(__var2234 < m_EarItemList.Length)
            {
                // End:0x85
                if(IsSameServerID(m_EarItemList[__var2234].Id, a_Info.Id))
                {
                    m_EarItemList[__var2234] = a_Info;
                    // [Explicit Break]
                    goto J0x8F;
                }
                ++__var2234;
                // [Loop Continue]
                goto J0x3E;
            }
            J0x8F:

            // End:0xC4
            if(__var2234 == m_EarItemList.Length)
            {
                m_EarItemList.Length = m_EarItemList.Length + 1;
                m_EarItemList[m_EarItemList.Length - 1] = a_Info;
            }
            hItemWnd = none;
            EarItemUpdate();
            // End:0x972
            break;
        // End:0xEC
        case (8):
            hItemWnd = m_equipItem[4];
            // End:0x972
            break;
        // End:0xF3
        case (16):
        // End:0xFA
        case (32):
        // End:0x19E
        case (48):
            __var2234 = 0;
            J0x108:

            // End:0x159 [Loop If]
            if(__var2234 < m_FingerItemLIst.Length)
            {
                // End:0x14F
                if(IsSameServerID(m_FingerItemLIst[__var2234].Id, a_Info.Id))
                {
                    m_FingerItemLIst[__var2234] = a_Info;
                    // [Explicit Break]
                    goto J0x159;
                }
                ++__var2234;
                // [Loop Continue]
                goto J0x108;
            }
            J0x159:

            // End:0x18E
            if(__var2234 == m_FingerItemLIst.Length)
            {
                m_FingerItemLIst.Length = m_FingerItemLIst.Length + 1;
                m_FingerItemLIst[m_FingerItemLIst.Length - 1] = a_Info;
            }
            hItemWnd = none;
            FingerItemUpdate();
            // End:0x972
            break;
        // End:0x1C4
        case (64):
            hItemWnd = m_equipItem[1];
            hItemWnd.EnableWindow();
            // End:0x972
            break;
        // End:0x1DC
        case (128):
            hItemWnd = m_equipItem[5];
            // End:0x972
            break;
        // End:0x206
        case (256):
            hItemWnd = m_equipItem[7];
            hItemWnd.EnableWindow();
            // End:0x972
            break;
        // End:0x230
        case (512):
            hItemWnd = m_equipItem[10];
            hItemWnd.EnableWindow();
            // End:0x972
            break;
        // End:0x24B
        case (1024):
            hItemWnd = m_equipItem[6];
            // End:0x972
            break;
        // End:0x275
        case (2048):
            hItemWnd = m_equipItem[11];
            hItemWnd.EnableWindow();
            // End:0x972
            break;
        // End:0x29F
        case (4096):
            hItemWnd = m_equipItem[12];
            hItemWnd.EnableWindow();
            // End:0x972
            break;
        // End:0x2C9
        case (8192):
            hItemWnd = m_equipItem[23];
            hItemWnd.EnableWindow();
            // End:0x972
            break;
        // End:0x45D
        case (16384):
            hItemWnd = m_equipItem[5];
            __var7705 = true;
            // End:0x328
            if(IsBowOrFishingRod(a_Info))
            {
                // End:0x328
                if(m_equipItem[7].GetItem(0, TheItemInfo))
                {
                    // End:0x328
                    if(IsArrow(TheItemInfo))
                    {
                        __var7705 = false;
                    }
                }
            }
            // End:0x367
            if(IsBowOrFishingRod(a_Info))
            {
                // End:0x367
                if(m_equipItem[7].GetItem(0, TheItemInfo))
                {
                    // End:0x367
                    if(IsArrow(TheItemInfo))
                    {
                        __var7705 = false;
                    }
                }
            }
            // End:0x45A
            if(__var7705)
            {
                // End:0x41F
                if(Len(a_Info.IconNameEx1) != 0)
                {
                    rHand = a_Info;
                    LHand = a_Info;
                    rHand.IconIndex = 1;
                    LHand.IconIndex = 2;
                    m_equipItem[5].Clear();
                    m_equipItem[5].AddItem(rHand);
                    m_equipItem[7].Clear();
                    m_equipItem[7].AddItem(LHand);
                    m_equipItem[7].DisableWindow();
                    hItemWnd = none;                    
                }
                else
                {
                    m_equipItem[7].Clear();
                    m_equipItem[7].AddItem(a_Info);
                    m_equipItem[7].DisableWindow();
                }
            }
            // End:0x972
            break;
        // End:0x4D7
        case (32768):
            hItemWnd = m_equipItem[6];
            a_Info.IconIndex = 1;
            Legs = a_Info;
            Legs.IconIndex = 2;
            m_equipItem[11].Clear();
            m_equipItem[11].AddItem(Legs);
            m_equipItem[11].DisableWindow();
            // End:0x972
            break;
        // End:0x4F2
        case (65536):
            hItemWnd = m_equipItem[2];
            // End:0x972
            break;
        // End:0x676
        case (131072):
            hItemWnd = m_equipItem[6];
            Hair2 = a_Info;
            Gloves = a_Info;
            Legs = a_Info;
            Feet = a_Info;
            Hair2.IconName = a_Info.IconNameEx1;
            Gloves.IconName = a_Info.IconNameEx2;
            Legs.IconName = a_Info.IconNameEx3;
            Feet.IconName = a_Info.IconNameEx4;
            m_equipItem[1].Clear();
            m_equipItem[1].AddItem(Hair2);
            m_equipItem[1].DisableWindow();
            m_equipItem[10].Clear();
            m_equipItem[10].AddItem(Gloves);
            m_equipItem[10].DisableWindow();
            m_equipItem[11].Clear();
            m_equipItem[11].AddItem(Legs);
            m_equipItem[11].DisableWindow();
            m_equipItem[12].Clear();
            m_equipItem[12].AddItem(Feet);
            m_equipItem[12].DisableWindow();
            // End:0x972
            break;
        // End:0x6A0
        case (262144):
            hItemWnd = m_equipItem[3];
            hItemWnd.EnableWindow();
            // End:0x972
            break;
        // End:0x6F6
        case (524288):
            hItemWnd = m_equipItem[2];
            m_equipItem[3].Clear();
            m_equipItem[3].AddItem(a_Info);
            m_equipItem[3].DisableWindow();
            // End:0x972
            break;
        // End:0x74C
        case (1048576):
            hItemWnd = m_equipItem[16];
            m_equipItem[16].Clear();
            m_equipItem[16].AddItem(a_Info);
            m_equipItem[16].EnableWindow();
            // End:0x972
            break;
        // End:0x7CE
        case (4194304):
            __var7511 = GetDecoIndex(a_Info.Id);
            // End:0x7CB
            if(__var7511 != -1)
            {
                m_equipItem[17 + __var7511].Clear();
                m_equipItem[17 + __var7511].AddItem(a_Info);
                m_equipItem[17 + __var7511].EnableWindow();
            }
            // End:0x972
            break;
        // End:0x7E9
        case (268435456):
            hItemWnd = m_equipItem[24];
            // End:0x972
            break;
        // End:0x880
        case (536870912):
            m_equipItem_Brooch.Clear();
            m_equipItem_Brooch.AddItem(a_Info);
            m_equipItem_Brooch.EnableWindow();
            m_BroochEquiped.ShowWindow();
            hItemWnd = m_equipItem[25];
            m_equipItem[25].Clear();
            m_equipItem[25].AddItem(a_Info);
            m_equipItem[25].EnableWindow();
            // End:0x972
            break;
        // End:0x902
        case (1073741824):
            __var7518 = GetJewelIndex(a_Info.Id);
            // End:0x8FF
            if(__var7518 != -1)
            {
                m_equipItem[26 + __var7518].Clear();
                m_equipItem[26 + __var7518].AddItem(a_Info);
                m_equipItem[26 + __var7518].EnableWindow();
            }
            // End:0x972
            break;
        // End:0x958
        case (2097152):
            hItemWnd = m_equipItem[15];
            m_equipItem[15].Clear();
            m_equipItem[15].AddItem(a_Info);
            m_equipItem[15].EnableWindow();
            // End:0x972
            break;
        // End:0x96C
        case (0):
            handleAgathionEquip(a_Info);
            // End:0x972
            break;
        // End:0xFFFF
        default:
            // End:0x972
            break;
            break;
    }
    // End:0x9A0
    if(none != hItemWnd)
    {
        hItemWnd.Clear();
        hItemWnd.AddItem(a_Info);
    }
    return;
}

function UpdatePremiumHennaInfo(bool Clear)
{
    local int __var4840, __var19774;
    local ItemInfo HennaItemInfo;
    local bool __var19769;

    m_hPremiumHennaItemWindow.Clear();
    // End:0x28
    if(Clear || bIsPremiumHennaSlot == false)
    {
        return;
    }
    // End:0x138
    if(Class'NWindow.HennaAPI'.static.GetPremiumHennaInfo(__var4840, __var19774))
    {
        __var19769 = Class'NWindow.UIDATA_HENNA'.static.GetItemCheck(__var4840);
        // End:0xFE
        if(__var19769)
        {
            HennaItemInfo.Name = Class'NWindow.UIDATA_HENNA'.static.GetItemNameS(__var4840);
            HennaItemInfo.AdditionalName = Class'NWindow.UIDATA_HENNA'.static.GetAddtionNameS(__var4840);
            HennaItemInfo.Description = Class'NWindow.UIDATA_HENNA'.static.GetDescriptionS(__var4840);
            HennaItemInfo.IconName = Class'NWindow.UIDATA_HENNA'.static.GetIconTexS(__var4840);
            HennaItemInfo.CurrentPeriod = Class'NWindow.HennaAPI'.static.GetPremiumHennaPeriod();
        }
        // End:0x118
        if(0 == __var19774)
        {
            HennaItemInfo.bDisabled = 1;            
        }
        else
        {
            HennaItemInfo.bDisabled = 0;
        }
        m_hPremiumHennaItemWindow.AddItem(HennaItemInfo);
    }
    return;
}

function resetHennaSlot()
{
    local ItemInfo henna;

    henna.Id.ClassID = 10000000;
    henna.Name = GetSystemString(639);
    henna.CrystalType = 100;
    m_hHennaItemWindow.Clear();
    m_hHennaItemWindow.AddItem(henna);
    m_hHennaItemWindow.AddItem(henna);
    m_hHennaItemWindow.AddItem(henna);
    return;
}

function UpdateHennaInfo()
{
    local int __var7538, __var7577, __var4816, __var19748;
    local ItemInfo HennaItemInfo;
    local UserInfo PlayerInfo;
    local int __var7530;
    local bool __var19741;

    // End:0x73
    if(GetPlayerInfo(PlayerInfo))
    {
        __var7530 = GetClassStep(PlayerInfo.nSubClass);
        switch(__var7530)
        {
            // End:0x2F
            case 1:
            // End:0x34
            case 2:
            // End:0x39
            case 3:
            // End:0x3E
            case 4:
            // End:0x5A
            case 5:
                m_hHennaItemWindow.SetRow(__var7530);
                // End:0x73
                break;
            // End:0xFFFF
            default:
                m_hHennaItemWindow.SetRow(0);
                // End:0x73
                break;
                break;
        }        
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x073
    resetHennaSlot();
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x073
    __var7577 = Class'NWindow.HennaAPI'.static.GetHennaInfoCount();
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x073
    // End:0xA8
    if(__var7577 > __var7530)
    {
    }
    __var7577 = __var7530;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x0A8
    __var7538 = 0;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x0A8
    J0xAF:

    // End:0x1D7 [Loop If]
    if(__var7538 < __var7577)
    {
    }/* !MISMATCHING REMOVE, tried If got Type:Loop Position:0x0AF! */
    // End:0x1CD
    if(Class'NWindow.HennaAPI'.static.GetHennaInfo(__var7538, __var4816, __var19748))
    {
        __var19741 = Class'NWindow.UIDATA_HENNA'.static.GetItemCheck(__var4816);
        // End:0x175
        if(__var19741)
        {
            HennaItemInfo.Id.ClassID = __var4816;
            HennaItemInfo.Name = Class'NWindow.UIDATA_HENNA'.static.GetItemNameS(__var4816);
            HennaItemInfo.Description = Class'NWindow.UIDATA_HENNA'.static.GetDescriptionS(__var4816);
            HennaItemInfo.IconName = Class'NWindow.UIDATA_HENNA'.static.GetIconTexS(__var4816);
        }
        // End:0x18F
        if(0 == __var19748)
        {
            HennaItemInfo.bDisabled = 1;            
        }
        else
        {
            HennaItemInfo.bDisabled = 0;
        }
        // End:0x1B9
        if(!m_hHennaItemWindow.SetItem(__var7538, HennaItemInfo))
        {
        }
        m_hHennaItemWindow.AddItem(HennaItemInfo);
    }
    ++__var7538;
    // [Loop Continue]
    goto J0xAF;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Loop Position:0x1D7
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Loop Position:0x1D7
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Loop Position:0x1D7
}

function HandleUpdateUserEquipSlotInfo()
{
    EarItemUpdate();
    FingerItemUpdate();
    UpdateTalismanSlotActivation();
    return;
}

function handleRequestUnequipItem(string DragSrcName, ItemID infoID, INT64 SlotBitType)
{
    local string __var1452;

    __var1452 = "";
    // End:0xCB
    if(-1 != InStr(DragSrcName, "Talisman"))
    {
        switch(Right(DragSrcName, 1))
        {
            // End:0x45
            case "1":
                __var1452 = "4194304";
                // End:0xC8
                break;
            // End:0x5D
            case "2":
                __var1452 = "8388608";
                // End:0xC8
                break;
            // End:0x76
            case "3":
                __var1452 = "16777216";
                // End:0xC8
                break;
            // End:0x8F
            case "4":
                __var1452 = "33554432";
                // End:0xC8
                break;
            // End:0xA8
            case "5":
                __var1452 = "67108864";
                // End:0xC8
                break;
            // End:0xC2
            case "6":
                __var1452 = "134217728";
                // End:0xC8
                break;
            // End:0xFFFF
            default:
                // End:0xC8
                break;
                break;
        }        
    }
    else
    {
        // End:0x19A
        if(-1 != InStr(DragSrcName, "Jewel"))
        {
            switch(Right(DragSrcName, 1))
            {
                // End:0x108
                case "1":
                    __var1452 = "1073741824";
                    // End:0x197
                    break;
                // End:0x123
                case "2":
                    __var1452 = "2147483648";
                    // End:0x197
                    break;
                // End:0x13E
                case "3":
                    __var1452 = "4294967296";
                    // End:0x197
                    break;
                // End:0x159
                case "4":
                    __var1452 = "8589934592";
                    // End:0x197
                    break;
                // End:0x175
                case "5":
                    __var1452 = "17179869184";
                    // End:0x197
                    break;
                // End:0x191
                case "6":
                    __var1452 = "34359738368";
                    // End:0x197
                    break;
                // End:0xFFFF
                default:
                    // End:0x197
                    break;
                    break;
            }            
        }
        else
        {
            // End:0x1C9
            if(-1 != InStr(DragSrcName, "Agathion"))
            {
                __var1452 = getAgathionSlotBitTypeString(Right(DragSrcName, 1));
            }
        }
    }
    // End:0x1E8
    if(__var1452 == "")
    {
        RequestUnequipItem(infoID, SlotBitType);        
    }
    else
    {
        RequestUnequipItem(infoID, (__var1452));
    }
    return;
}

function EquipItemDelete(ItemID sID)
{
    local int __var3918, __var19733;
    local ItemInfo TheItemInfo;

    __var3918 = 0;
    J0x07:

    // End:0x11C [Loop If]
    if(__var3918 < 37)
    {
        __var19733 = m_equipItem[__var3918].FindItem(sID);
        // End:0x112
        if(-1 != __var19733)
        {
            m_equipItem[__var3918].Clear();
            m_equipItem[__var3918].EnableWindow();
            // End:0xE8
            if(__var3918 == 7)
            {
                // End:0xE5
                if(m_equipItem[5].GetItem(0, TheItemInfo))
                {
                    // End:0xE5
                    if(__NFUN_412__(TheItemInfo.SlotBitType, (16384)))
                    {
                        m_equipItem[7].Clear();
                        m_equipItem[7].AddItem(TheItemInfo);
                        m_equipItem[7].DisableWindow();
                    }
                }
                // [Explicit Continue]
                goto J0x112;
            }
            // End:0x112
            if(__var3918 == 25)
            {
                m_equipItem_Brooch.Clear();
                m_BroochEquiped.HideWindow();
            }
        }
        J0x112:

        ++__var3918;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function InvenDelete(ItemInfo item)
{
    local int __var10558, __var19728;
    local ItemInfo clearItem;
    local ItemWindowHandle detailItemWindow;

    detailItemWindow = getItemWindowHandleByItemType(item);
    ClearItemID(clearItem.Id);
    clearItem.IconName = "L2ui_ct1.emptyBtn";
    __var10558 = m_invenItem.FindItem(item.Id);
    __var19728 = detailItemWindow.FindItem(item.Id);
    // End:0xC5
    if(__var10558 != -1)
    {
        m_invenItem.SetItem(__var10558, clearItem);
        detailItemWindow.SetItem(__var19728, clearItem);
        m_NormalInvenCount--;
    }
    return;
}

function QuestInvenDelete(ItemInfo item)
{
    local int __var10564;
    local ItemInfo clearItem;

    __var10564 = m_questItem.FindItem(item.Id);
    // End:0x8B
    if(__var10564 != -1)
    {
        m_questItem.DeleteItem(__var10564);
        m_QuestInvenCount--;
        ClearItemID(clearItem.Id);
        clearItem.IconName = "L2ui_ct1.emptyBtn";
        m_questItem.AddItem(clearItem);
    }
    return;
}

function HandleClear()
{
    // End:0x18
    if(m_hOwnerWnd.IsShowWindow())
    {
        saveLocalItemOrder();
    }
    InvenClear();
    invenItem_1Clear();
    invenItem_2Clear();
    invenItem_3Clear();
    invenItem_4Clear();
    QuestInvenClear();
    EquipItemClear();
    m_EarItemList.Length = 0;
    m_FingerItemLIst.Length = 0;
    m_DecoItemList.Length = 0;
    InvenLimitUpdate();
    bIsQuestItemList = false;
    return;
}

function EquipItemClear()
{
    local int __var7914;

    __var7914 = 0;
    J0x07:

    // End:0x32 [Loop If]
    if(__var7914 < 37)
    {
        m_equipItem[__var7914].Clear();
        ++__var7914;
        // [Loop Continue]
        goto J0x07;
    }
    m_equipItem_Brooch.Clear();
    m_BroochEquiped.HideWindow();
    return;
}

function InvenClear()
{
    m_invenItem.Clear();
    m_NormalInvenCount = 0;
    return;
}

function QuestInvenClear()
{
    m_questItem.Clear();
    m_QuestInvenCount = 0;
    return;
}

function invenItem_1Clear()
{
    m_invenItem_1.Clear();
    return;
}

function invenItem_2Clear()
{
    m_invenItem_2.Clear();
    return;
}

function invenItem_3Clear()
{
    m_invenItem_3.Clear();
    return;
}

function invenItem_4Clear()
{
    m_invenItem_4.Clear();
    return;
}

function saveLocalItemOrder()
{
    local int __var2231;

    bIsSavedLocalItemIdx = true;
    __var2231 = 0;
    J0x0F:

    // End:0xB4 [Loop If]
    if(__var2231 < m_invenItem.GetItemNum())
    {
        saveServerID(m_invenItem, __var2231, itemSwapedServerID, itemSwapedIdx);
        saveServerID(m_invenItem_1, __var2231, itemSwapedServerID_1, itemSwapedIdx_1);
        saveServerID(m_invenItem_2, __var2231, itemSwapedServerID_2, itemSwapedIdx_2);
        saveServerID(m_invenItem_3, __var2231, itemSwapedServerID_3, itemSwapedIdx_3);
        saveServerID(m_invenItem_4, __var2231, itemSwapedServerID_4, itemSwapedIdx_4);
        __var2231++;
        // [Loop Continue]
        goto J0x0F;
    }
    __var2231 = 0;
    J0xBB:

    // End:0xF8 [Loop If]
    if(__var2231 < m_questItem.GetItemNum())
    {
        saveServerID(m_questItem, __var2231, itemSwapedServerID_q, itemSwapedIdx_q);
        __var2231++;
        // [Loop Continue]
        goto J0xBB;
    }
    return;
}

function saveServerID(ItemWindowHandle targetWindow, int idx, out array<int> serverIDList, out array<int> SwapedIdx)
{
    local ItemInfo invenInfo;

    targetWindow.GetItem(idx, invenInfo);
    // End:0x8F
    if(invenInfo.Id.ServerID != -1)
    {
        invenInfo.ORDER = idx;
        idx = serverIDList.Length;
        serverIDList.Length = serverIDList.Length + 1;
        serverIDList[idx] = invenInfo.Id.ServerID;
        SwapedIdx[idx] = invenInfo.ORDER;
    }
    return;
}

function int getLocalItemOrder(int ServerID, array<int> serverIDList, array<int> SwapedIdx, int defaultOrder)
{
    local int __var7145;

    __var7145 = 0;
    J0x07:

    // End:0x42 [Loop If]
    if(__var7145 < serverIDList.Length)
    {
        // End:0x38
        if(serverIDList[__var7145] == ServerID)
        {
            return SwapedIdx[__var7145];
        }
        __var7145++;
        // [Loop Continue]
        goto J0x07;
    }
    return defaultOrder;
    return;
}

function int getLocalItemOrderByItemWindow(ItemWindowHandle targetWindow, int ServerID, int defaultOrder)
{
    switch(targetWindow)
    {
        // End:0x2A
        case m_invenItem_1:
            return getLocalItemOrder(ServerID, itemSwapedServerID_1, itemSwapedIdx_1, defaultOrder);
        // End:0x4D
        case m_invenItem_2:
            return getLocalItemOrder(ServerID, itemSwapedServerID_2, itemSwapedIdx_2, defaultOrder);
        // End:0x70
        case m_invenItem_3:
            return getLocalItemOrder(ServerID, itemSwapedServerID_3, itemSwapedIdx_3, defaultOrder);
        // End:0x93
        case m_invenItem_4:
            return getLocalItemOrder(ServerID, itemSwapedServerID_4, itemSwapedIdx_4, defaultOrder);
        // End:0xB6
        case m_questItem:
            return getLocalItemOrder(ServerID, itemSwapedServerID_q, itemSwapedIdx_q, defaultOrder);
        // End:0xFFFF
        default:
            return defaultOrder;
            break;
    }    
    return;
}

function SaveInventoryOrder()
{
    local int __var7995, __var19637;
    local ItemInfo item;
    local array<ItemID> IDList;
    local array<int> OrderList;

    __var19637 = m_invenItem.GetItemNum();
    __var7995 = 0;
    J0x1C:

    // End:0xB2 [Loop If]
    if(__var7995 < __var19637)
    {
        // End:0xA8
        if(m_invenItem.GetItem(__var7995, item))
        {
            // End:0xA8
            if(IsValidItemID(item.Id))
            {
                IDList.Insert(IDList.Length, 1);
                IDList[IDList.Length - 1] = item.Id;
                OrderList.Insert(OrderList.Length, 1);
                OrderList[OrderList.Length - 1] = item.ORDER;
            }
        }
        __var7995++;
        // [Loop Continue]
        goto J0x1C;
    }
    // End:0xCE
    if(IDList.Length > 0)
    {
        RequestSaveInventoryOrder(IDList, OrderList);
    }
    SetOptionInt("Game", "ItemInventoryCol", currentInvenCol);
    bIsSavedLocalItemIdx = false;
    itemSwapedIdx.Length = 0;
    itemSwapedIdx_1.Length = 0;
    itemSwapedIdx_2.Length = 0;
    itemSwapedIdx_3.Length = 0;
    itemSwapedIdx_4.Length = 0;
    itemSwapedIdx_q.Length = 0;
    itemSwapedServerID.Length = 0;
    itemSwapedServerID_1.Length = 0;
    itemSwapedServerID_2.Length = 0;
    itemSwapedServerID_3.Length = 0;
    itemSwapedServerID_4.Length = 0;
    itemSwapedServerID_q.Length = 0;
    return;
}

function bool IsEquipItem(out ItemInfo Info)
{
    return Info.bEquipped;
    return;
}

function bool IsQuestItem(out ItemInfo Info)
{
    return int(byte(Info.ItemType)) == 3;
    return;
}

function int IsLOrREar(ItemID sID)
{
    local ItemID LEar, REar, LFinger, RFinger;

    GetAccessoryItemID(LEar, REar, LFinger, RFinger);
    // End:0x36
    if(IsSameServerID(sID, LEar))
    {
        return -1;        
    }
    else
    {
        // End:0x4E
        if(IsSameServerID(sID, REar))
        {
            return 1;            
        }
        else
        {
            return 0;
        }
    }
    return;
}

function int IsLOrRFinger(ItemID sID)
{
    local ItemID LEar, REar, LFinger, RFinger;

    GetAccessoryItemID(LEar, REar, LFinger, RFinger);
    // End:0x36
    if(IsSameServerID(sID, LFinger))
    {
        return -1;        
    }
    else
    {
        // End:0x4E
        if(IsSameServerID(sID, RFinger))
        {
            return 1;            
        }
        else
        {
            return 0;
        }
    }
    return;
}

function bool IsBowOrFishingRod(ItemInfo a_Info)
{
    // End:0x4C
    if((((6 == a_Info.WeaponType) || 10 == a_Info.WeaponType) || 12 == a_Info.WeaponType) || 17 == a_Info.WeaponType)
    {
        return true;
    }
    return false;
    return;
}

function bool IsArrow(ItemInfo a_Info)
{
    return a_Info.bArrow;
    return;
}

function bool isDragSrcInventory(string DragSrcName)
{
    switch(DragSrcName)
    {
        // End:0x19
        case "InventoryItem":
        // End:0x27
        case "QuestItem":
        // End:0x37
        case "PetInvenWnd":
        // End:0x4B
        case "InventoryItem_1":
        // End:0x5F
        case "InventoryItem_2":
        // End:0x73
        case "InventoryItem_3":
        // End:0x89
        case "InventoryItem_4":
            return true;
        // End:0xFFFF
        default:
            // End:0xAA
            if(-1 != InStr(DragSrcName, "EquipItem"))
            {
                return true;
            }
            return false;
            break;
    }    
    return;
}

function int EquipItemGetItemNum()
{
    local int __var7037, __var10642;

    __var7037 = 0;
    J0x07:

    // End:0x57 [Loop If]
    if(__var7037 < 37)
    {
        // End:0x4D
        if(m_equipItem[__var7037].IsEnableWindow())
        {
            __var10642 = __var10642 + m_equipItem[__var7037].GetItemNum();
        }
        ++__var7037;
        // [Loop Continue]
        goto J0x07;
    }
    return __var10642;
    return;
}

function bool EquipItemFind(ItemID sID)
{
    local int __var8093, __var19606;

    __var8093 = 0;
    J0x07:

    // End:0x4E [Loop If]
    if(__var8093 < 37)
    {
        __var19606 = m_equipItem[__var8093].FindItem(sID);
        // End:0x44
        if(-1 != __var19606)
        {
            return true;
        }
        ++__var8093;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function int getCurrentInventoryItemCount()
{
    return pInventoryItemCount;
    return;
}

function bool getInventoryItemWndName(string Str)
{
    local int __var6989;

    __var6989 = 0;
    J0x07:

    // End:0x6B [Loop If]
    if(__var6989 <= 4)
    {
        // End:0x3C
        if(__var6989 == 0)
        {
            // End:0x39
            if("InventoryItem" == Str)
            {
                return true;
            }
            // [Explicit Continue]
            goto J0x61;
        }
        // End:0x61
        if(("InventoryItem_" $ string(__var6989)) == Str)
        {
            return true;
        }
        J0x61:

        ++__var6989;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function bool getInventoryItemInfo(ItemID Id, out ItemInfo InvenItemInfo, optional bool onlyUseClassID)
{
    local bool __var6945;
    local int __var4284, __var2340;
    local ItemInfo tempOutItemInfo, tmpItemInfo;

    __var6945 = false;
    // End:0x2E
    if(onlyUseClassID)
    {
        __var2340 = m_invenItem.FindItemByClassID(Id);        
    }
    else
    {
        __var2340 = m_invenItem.FindItem(Id);
    }
    // End:0x78
    if(__var2340 > -1)
    {
        m_invenItem.GetItem(__var2340, InvenItemInfo);
        __var6945 = true;
    }
    __var2340 = m_questItem.FindItem(Id);
    // End:0xC2
    if(__var2340 > -1)
    {
        m_questItem.GetItem(__var2340, InvenItemInfo);
        __var6945 = true;
    }
    __var4284 = 0;
    J0xC9:

    // End:0x1E2 [Loop If]
    if(__var4284 < 37)
    {
        // End:0x101
        if(onlyUseClassID)
        {
            __var2340 = m_equipItem[__var4284].FindItemByClassID(Id);            
        }
        else
        {
            __var2340 = m_equipItem[__var4284].FindItem(Id);
        }
        // End:0x1D8
        if(__var2340 > -1)
        {
            m_equipItem[__var4284].GetItem(__var2340, tempOutItemInfo);
            switch(__var4284)
            {
                // End:0x176
                case 7:
                    m_equipItem[5].GetItem(0, tmpItemInfo);
                    // End:0x19C
                    break;
                // End:0x196
                case 3:
                    m_equipItem[2].GetItem(0, tmpItemInfo);
                    // End:0x19C
                    break;
                // End:0xFFFF
                default:
                    // End:0x19C
                    break;
                    break;
            }
            // End:0x1C2
            if(tempOutItemInfo.Id.ServerID == tmpItemInfo.Id.ServerID)
            {
                // [Explicit Continue]
                goto J0x1D8;
            }
            InvenItemInfo = tempOutItemInfo;
            __var6945 = true;
            // [Explicit Break]
            goto J0x1E2;
        }
        J0x1D8:

        __var4284++;
        // [Loop Continue]
        goto J0xC9;
    }
    J0x1E2:

    return __var6945;
    return;
}

function INT64 getItemCountByClassID(int ClassID)
{
    local int __var4291, __var19574;
    local INT64 __var5238;
    local ItemInfo tempOutItemInfo, tmpItemInfo, Info;
    local ItemID Id;

    Id.ClassID = ClassID;
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Id, Info);
    // End:0x5E
    if(IsStackableItem(Info.ConsumeType))
    {
        // End:0x5B
        if(getInventoryItemInfo(Id, tempOutItemInfo, true))
        {
            return tempOutItemInfo.ItemNum;
        }        
    }
    else
    {
        __var5238 = getItemWindowCountByClassID(ClassID, m_invenItem);
        __var5238 = __NFUN_404__(__var5238, getItemWindowCountByClassID(ClassID, m_questItem));
        __var4291 = 0;
        J0x99:

        // End:0x187 [Loop If]
        if(__var4291 < 37)
        {
            __var19574 = m_equipItem[__var4291].GetItemNum();
            // End:0xCE
            if(__var19574 == 0)
            {
                // [Explicit Continue]
                goto J0x17D;
            }
            m_equipItem[__var4291].GetItem(0, tempOutItemInfo);
            switch(__var4291)
            {
                // End:0x110
                case 7:
                    m_equipItem[5].GetItem(0, tmpItemInfo);
                    // End:0x136
                    break;
                // End:0x130
                case 3:
                    m_equipItem[2].GetItem(0, tmpItemInfo);
                    // End:0x136
                    break;
                // End:0xFFFF
                default:
                    // End:0x136
                    break;
                    break;
            }
            // End:0x17D
            if(tempOutItemInfo.Id.ServerID != tmpItemInfo.Id.ServerID)
            {
                __var5238 = __NFUN_404__(__var5238, getItemWindowCountByClassID(ClassID, m_equipItem[__var4291]));
            }
            J0x17D:

            __var4291++;
            // [Loop Continue]
            goto J0x99;
        }
    }
    return __var5238;
    return;
}

function INT64 getItemWindowCountByClassID(int ClassID, ItemWindowHandle targetItemWindow)
{
    local int __var8263, __var19547, __var21287, __var19546;
    local ItemInfo tmInfo, tempOutItemInfo, Info;
    local ItemID Id;

    Id.ClassID = ClassID;
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(Id, Info);
    // End:0x75
    if(IsStackableItem(Info.ConsumeType))
    {
        __var21287 = m_invenItem.FindItemByClassID(Id);
        // End:0x75
        if(getInventoryItemInfo(Id, tempOutItemInfo, true))
        {
            return tempOutItemInfo.ItemNum;
        }
    }
    __var19546 = targetItemWindow.GetItemNum();
    __var8263 = 0;
    J0x91:

    // End:0xE3 [Loop If]
    if(__var8263 < __var19546)
    {
        targetItemWindow.GetItem(__var8263, tmInfo);
        // End:0xD9
        if(tmInfo.Id.ClassID == ClassID)
        {
            __var19547++;
        }
        __var8263++;
        // [Loop Continue]
        goto J0x91;
    }
    return (__var19547);
    return;
}

function array<ItemInfo> getInventoryAllItemArray(optional bool bExceptionEquipItem)
{
    local int __var19541, __var8267;
    local array<ItemInfo> itemarray;
    local ItemInfo InvenItemInfo;

    __var19541 = m_invenItem.GetItemNum();
    __var8267 = 0;
    J0x1C:

    // End:0x8B [Loop If]
    if(__var8267 < __var19541)
    {
        m_invenItem.GetItem(__var8267, InvenItemInfo);
        // End:0x5C
        if(InvenItemInfo.Id.ClassID <= 0)
        {
            // [Explicit Continue]
            goto J0x81;
        }
        itemarray.Length = itemarray.Length + 1;
        itemarray[itemarray.Length - 1] = InvenItemInfo;
        J0x81:

        __var8267++;
        // [Loop Continue]
        goto J0x1C;
    }
    // End:0xC5
    if(bExceptionEquipItem == false)
    {
        itemarray = L2Util(GetScript("L2Util")).pushItemInfoArray(itemarray, getInventoryEquipItemArray());
    }
    return itemarray;
    return;
}

function array<ItemInfo> getInventoryEquipItemArray()
{
    local int __var8292, __var8301;
    local bool __var10682;
    local array<ItemInfo> itemarray;
    local ItemInfo InvenItemInfo;

    m_equipItem[6].GetItem(0, InvenItemInfo);
    // End:0x40
    if(IsValidItemID(InvenItemInfo.Id))
    {
        itemarray.Length = 1;
        itemarray[0] = InvenItemInfo;
    }
    __var8292 = 0;
    J0x47:

    // End:0x127 [Loop If]
    if(__var8292 < 37)
    {
        ClearItemID(InvenItemInfo.Id);
        m_equipItem[__var8292].GetItem(0, InvenItemInfo);
        // End:0x96
        if(!IsValidItemID(InvenItemInfo.Id))
        {
            // [Explicit Continue]
            goto J0x11D;
        }
        __var10682 = false;
        __var8301 = 0;
        J0xA5:

        // End:0xED [Loop If]
        if(__var8301 < itemarray.Length)
        {
            // End:0xE3
            if(IsSameServerID(itemarray[__var8301].Id, InvenItemInfo.Id))
            {
                __var10682 = true;
                // [Explicit Continue]
            }
            __var8301++;
            // [Loop Continue]
            goto J0xA5;
        }
        // End:0x11D
        if(!__var10682)
        {
            itemarray.Length = itemarray.Length + 1;
            itemarray[itemarray.Length - 1] = InvenItemInfo;
        }
        J0x11D:

        __var8292++;
        // [Loop Continue]
        goto J0x47;
    }
    return itemarray;
    return;
}

function int GetMyInventoryLimit()
{
    return m_MaxInvenCount;
    return;
}

function int GetQuestItemInventoryLimit()
{
    return m_MaxQuestItemInvenCount;
    return;
}

function array<ItemInfo> getInventoryEnSoulExtractEnableItemArray()
{
    local int __var5343, __var8317, __var3747;
    local array<ItemInfo> itemarray;
    local ItemInfo InvenItemInfo;

    __var8317 = m_invenItem.GetItemNum();
    __var3747 = 0;
    J0x1C:

    // End:0xBD [Loop If]
    if(__var3747 < __var8317)
    {
        m_invenItem.GetItem(__var3747, InvenItemInfo);
        // End:0x5C
        if(InvenItemInfo.Id.ClassID <= 0)
        {
            // [Explicit Continue]
            goto J0xB3;
        }
        // End:0x6F
        if(InvenItemInfo.ItemType != 0)
        {
            // [Explicit Continue]
            goto J0xB3;
        }
        // End:0x80
        if(InvenItemInfo.bSecurityLock)
        {
            // [Explicit Continue]
            goto J0xB3;
        }
        // End:0xB3
        if(hasEnsoulOption(InvenItemInfo))
        {
            itemarray.Length = itemarray.Length + 1;
            itemarray[itemarray.Length - 1] = InvenItemInfo;
        }
        J0xB3:

        __var3747++;
        // [Loop Continue]
        goto J0x1C;
    }
    __var5343 = 0;
    J0xC4:

    // End:0x1A1 [Loop If]
    if(__var5343 < 37)
    {
        __var8317 = m_equipItem[__var5343].GetItemNum();
        __var3747 = 0;
        J0xF2:

        // End:0x197 [Loop If]
        if(__var3747 < __var8317)
        {
            // End:0x110
            if(7 == __var5343)
            {
                // [Explicit Continue]
                goto J0x18D;
            }
            m_equipItem[__var5343].GetItem(__var3747, InvenItemInfo);
            // End:0x147
            if(InvenItemInfo.Id.ClassID <= 0)
            {
                // [Explicit Continue]
                goto J0x18D;
            }
            // End:0x15A
            if(InvenItemInfo.ItemType != 0)
            {
                // [Explicit Continue]
                goto J0x18D;
            }
            // End:0x18D
            if(hasEnsoulOption(InvenItemInfo))
            {
                itemarray.Length = itemarray.Length + 1;
                itemarray[itemarray.Length - 1] = InvenItemInfo;
            }
            J0x18D:

            __var3747++;
            // [Loop Continue]
            goto J0xF2;
        }
        __var5343++;
        // [Loop Continue]
        goto J0xC4;
    }
    return itemarray;
    return;
}

function array<ItemInfo> getInventoryEnSoulEnableItemArray()
{
    local int __var5368, __var8339, __var3745;
    local array<ItemInfo> itemarray;
    local ItemInfo InvenItemInfo;
    local int __var8356, __var8362;

    __var8339 = m_invenItem.GetItemNum();
    __var3745 = 0;
    J0x1C:

    // End:0x108 [Loop If]
    if(__var3745 < __var8339)
    {
        m_invenItem.GetItem(__var3745, InvenItemInfo);
        // End:0x5C
        if(InvenItemInfo.Id.ClassID <= 0)
        {
            // [Explicit Continue]
            goto J0xFE;
        }
        // End:0x6F
        if(InvenItemInfo.ItemType != 0)
        {
            // [Explicit Continue]
            goto J0xFE;
        }
        // End:0x80
        if(InvenItemInfo.bSecurityLock)
        {
            // [Explicit Continue]
            goto J0xFE;
        }
        __var8356 = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, 1);
        __var8362 = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, 2);
        // End:0xFE
        if((__var8356 > 0) || __var8362 > 0)
        {
            itemarray.Length = itemarray.Length + 1;
            itemarray[itemarray.Length - 1] = InvenItemInfo;
        }
        J0xFE:

        __var3745++;
        // [Loop Continue]
        goto J0x1C;
    }
    __var5368 = 0;
    J0x10F:

    // End:0x248 [Loop If]
    if(__var5368 < 37)
    {
        __var8339 = m_equipItem[__var5368].GetItemNum();
        __var3745 = 0;
        J0x13D:

        // End:0x23E [Loop If]
        if(__var3745 < __var8339)
        {
            // End:0x15B
            if(7 == __var5368)
            {
                // [Explicit Continue]
                goto J0x234;
            }
            m_equipItem[__var5368].GetItem(__var3745, InvenItemInfo);
            // End:0x192
            if(InvenItemInfo.Id.ClassID <= 0)
            {
                // [Explicit Continue]
                goto J0x234;
            }
            // End:0x1A5
            if(InvenItemInfo.ItemType != 0)
            {
                // [Explicit Continue]
                goto J0x234;
            }
            // End:0x1B6
            if(InvenItemInfo.bSecurityLock)
            {
                // [Explicit Continue]
                goto J0x234;
            }
            __var8356 = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, 1);
            __var8362 = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(InvenItemInfo.Id, 2);
            // End:0x234
            if((__var8356 > 0) || __var8362 > 0)
            {
                itemarray.Length = itemarray.Length + 1;
                itemarray[itemarray.Length - 1] = InvenItemInfo;
            }
            J0x234:

            __var3745++;
            // [Loop Continue]
            goto J0x13D;
        }
        __var5368++;
        // [Loop Continue]
        goto J0x10F;
    }
    return itemarray;
    return;
}

function array<ItemInfo> getInventoryEnSoulStoneArray()
{
    local int __var6673, __var8383, __var3729;
    local array<ItemInfo> itemarray;
    local ItemInfo InvenItemInfo;

    __var8383 = m_invenItem.GetItemNum();
    __var3729 = 0;
    J0x1C:

    // End:0x84 [Loop If]
    if(__var3729 < __var8383)
    {
        m_invenItem.GetItem(__var3729, InvenItemInfo);
        // End:0x7A
        if(InvenItemInfo.ItemSubType == 60)
        {
            itemarray.Length = itemarray.Length + 1;
            itemarray[itemarray.Length - 1] = InvenItemInfo;
        }
        __var3729++;
        // [Loop Continue]
        goto J0x1C;
    }
    __var6673 = 0;
    J0x8B:

    // End:0x131 [Loop If]
    if(__var6673 < 37)
    {
        __var8383 = m_equipItem[__var6673].GetItemNum();
        __var3729 = 0;
        J0xB9:

        // End:0x127 [Loop If]
        if(__var3729 < __var8383)
        {
            m_equipItem[__var6673].GetItem(__var3729, InvenItemInfo);
            // End:0x11D
            if(InvenItemInfo.ItemSubType == 60)
            {
                itemarray.Length = itemarray.Length + 1;
                itemarray[itemarray.Length - 1] = InvenItemInfo;
            }
            __var3729++;
            // [Loop Continue]
            goto J0xB9;
        }
        __var6673++;
        // [Loop Continue]
        goto J0x8B;
    }
    return itemarray;
    return;
}

function array<ItemInfo> getInventoryPotionsArray()
{
    local int __var44302, __var19514, __var8416;
    local array<ItemInfo> itemarray;
    local ItemInfo InvenItemInfo;

    __var19514 = m_invenItem.GetItemNum();
    __var8416 = 0;
    J0x1C:

    // End:0x84 [Loop If]
    if(__var8416 < __var19514)
    {
        m_invenItem.GetItem(__var8416, InvenItemInfo);
        // End:0x7A
        if(InvenItemInfo.ItemSubType == 3)
        {
            itemarray.Length = itemarray.Length + 1;
            itemarray[itemarray.Length - 1] = InvenItemInfo;
        }
        __var8416++;
        // [Loop Continue]
        goto J0x1C;
    }
    return itemarray;
    return;
}

function array<ItemInfo> getInventoryCollectionArray(ItemInfo item)
{
    local int __var44253, __var19505, __var8423;
    local array<ItemInfo> itemarray;
    local ItemInfo InvenItemInfo;

    __var19505 = m_invenItem.GetItemNum();
    __var8423 = 0;
    J0x1C:

    // End:0xB1 [Loop If]
    if(__var8423 < __var19505)
    {
        m_invenItem.GetItem(__var8423, InvenItemInfo);
        // End:0xA7
        if((InvenItemInfo.Id.ClassID == item.Id.ClassID) && InvenItemInfo.Enchanted == item.Enchanted)
        {
            itemarray.Length = itemarray.Length + 1;
            itemarray[itemarray.Length - 1] = InvenItemInfo;
        }
        __var8423++;
        // [Loop Continue]
        goto J0x1C;
    }
    return itemarray;
    return;
}

function SortQuestItem()
{
    local int __var1502, __var5459, __var19498;
    local ItemInfo item, temp;
    local int __var5463;
    local array<ItemInfo> QuestList;

    __var19498 = m_questItem.GetItemNum();
    __var1502 = 0;
    J0x1C:

    // End:0x85 [Loop If]
    if(__var1502 < __var19498)
    {
        m_questItem.GetItem(__var1502, item);
        // End:0x5C
        if(!IsValidItemID(item.Id))
        {
            // [Explicit Continue]
            goto J0x7B;
        }
        QuestList[__var5463] = item;
        __var5463 = __var5463 + 1;
        J0x7B:

        __var1502++;
        // [Loop Continue]
        goto J0x1C;
    }
    m_questItem.Clear();
    ItemboxUpdate(m_questItem, GetQuestItemInventoryLimit());
    __var1502 = 0;
    J0xAC:

    // End:0x151 [Loop If]
    if(__var1502 < __var5463)
    {
        __var5459 = __var1502;
        J0xC6:

        // End:0x147 [Loop If]
        if(__var5459 < __var5463)
        {
            // End:0x13D
            if(QuestList[__var1502].Id.ServerID < QuestList[__var5459].Id.ServerID)
            {
                temp = QuestList[__var1502];
                QuestList[__var1502] = QuestList[__var5459];
                QuestList[__var5459] = temp;
            }
            ++__var5459;
            // [Loop Continue]
            goto J0xC6;
        }
        __var1502++;
        // [Loop Continue]
        goto J0xAC;
    }
    __var1502 = 0;
    J0x158:

    // End:0x190 [Loop If]
    if(__var1502 < __var5463)
    {
        m_questItem.SetItem(__var1502, QuestList[__var1502]);
        ++__var1502;
        // [Loop Continue]
        goto J0x158;
    }
    return;
}

function UpdateTalismanSlotActivation()
{
    local int __var8504, __var1643;
    local UserInfo User;
    local ItemInfo DisableItem;

    DisableItem.IconName = "L2UI_CT1.Inventory_DF_TalismanSlot_Disable";
    // End:0x14B
    if(GetPlayerInfo(User))
    {
        __var8504 = User.nTalismanNum;
        // End:0x100
        if(__var8504 > 0)
        {
            __var1643 = 0;
            J0x67:

            // End:0xAE [Loop If]
            if(__var1643 < __var8504)
            {
                m_Talisman_Disable[__var1643].HideWindow();
                m_equipItem[17 + __var1643].EnableWindow();
                __var1643++;
                // [Loop Continue]
                goto J0x67;
            }
            __var1643 = __var8504;
            J0xB9:

            // End:0xFD [Loop If]
            if(__var1643 < 6)
            {
                m_Talisman_Disable[__var1643].ShowWindow();
                m_equipItem[17 + __var1643].DisableWindow();
                __var1643++;
                // [Loop Continue]
                goto J0xB9;
            }            
        }
        else
        {
            __var1643 = 0;
            J0x107:

            // End:0x14B [Loop If]
            if(__var1643 < 6)
            {
                m_Talisman_Disable[__var1643].ShowWindow();
                m_equipItem[17 + __var1643].DisableWindow();
                __var1643++;
                // [Loop Continue]
                goto J0x107;
            }
        }
    }
    return;
}

function UpdateAgathionSlotActivation()
{
    local int __var8506, __var1645;
    local UserInfo User;

    // End:0x173
    if(GetPlayerInfo(User))
    {
        // End:0x44
        if(User.nAgathionMainNum > 0)
        {
            m_Agathion_Disable[0].HideWindow();
            m_equipItem[32].EnableWindow();            
        }
        else
        {
            m_Agathion_Disable[0].ShowWindow();
            m_equipItem[32].DisableWindow();
        }
        __var8506 = User.nAgathionSubNum;
        // End:0x128
        if(__var8506 > 0)
        {
            __var1645 = 1;
            J0x89:

            // End:0xD3 [Loop If]
            if(__var1645 < (__var8506 + 1))
            {
                m_Agathion_Disable[__var1645].HideWindow();
                m_equipItem[32 + __var1645].EnableWindow();
                __var1645++;
                // [Loop Continue]
                goto J0x89;
            }
            __var1645 = __var8506 + 1;
            J0xE1:

            // End:0x125 [Loop If]
            if(__var1645 < 5)
            {
                m_Agathion_Disable[__var1645].ShowWindow();
                m_equipItem[32 + __var1645].DisableWindow();
                __var1645++;
                // [Loop Continue]
                goto J0xE1;
            }            
        }
        else
        {
            __var1645 = 1;
            J0x12F:

            // End:0x173 [Loop If]
            if(__var1645 < 5)
            {
                m_Agathion_Disable[__var1645].ShowWindow();
                m_equipItem[32 + __var1645].DisableWindow();
                __var1645++;
                // [Loop Continue]
                goto J0x12F;
            }
        }
    }
    return;
}

function UpdateJewelSlotActivation()
{
    local int __var8508, __var1647;
    local UserInfo User;
    local ItemInfo DisableItem;

    DisableItem.IconName = "L2UI_CT1.Inventory_DF_TalismanSlot_Disable";
    // End:0x14B
    if(GetPlayerInfo(User))
    {
        __var8508 = User.nJewelNum;
        // End:0x100
        if(__var8508 > 0)
        {
            __var1647 = 0;
            J0x67:

            // End:0xAE [Loop If]
            if(__var1647 < __var8508)
            {
                m_Jewel_Disable[__var1647].HideWindow();
                m_equipItem[26 + __var1647].EnableWindow();
                __var1647++;
                // [Loop Continue]
                goto J0x67;
            }
            __var1647 = __var8508;
            J0xB9:

            // End:0xFD [Loop If]
            if(__var1647 < 6)
            {
                m_Jewel_Disable[__var1647].ShowWindow();
                m_equipItem[26 + __var1647].DisableWindow();
                __var1647++;
                // [Loop Continue]
                goto J0xB9;
            }            
        }
        else
        {
            __var1647 = 0;
            J0x107:

            // End:0x14B [Loop If]
            if(__var1647 < 6)
            {
                m_Jewel_Disable[__var1647].ShowWindow();
                m_equipItem[26 + __var1647].DisableWindow();
                __var1647++;
                // [Loop Continue]
                goto J0x107;
            }
        }
    }
    return;
}

function handlePremiumHenna()
{
    local int __var19475;
    local TextureHandle PremiumHennaTex;

    GetINIBool("Localize", "UsePremiumHennaSlot", __var19475, "L2.ini");
    // End:0x45
    if(__var19475 == 1)
    {
        bIsPremiumHennaSlot = true;
    }
    // End:0xA2
    if(bIsPremiumHennaSlot == false)
    {
        PremiumHennaTex = GetTextureHandle(m_WindowName $ ".Charge_HennaSlotBg");
        // End:0x93
        if(PremiumHennaTex != none)
        {
            PremiumHennaTex.HideWindow();
        }
        m_hPremiumHennaItemWindow.HideWindow();
    }
    return;
}

function HandleUpdateUserInfo()
{
    // End:0x24
    if(m_hOwnerWnd.IsShowWindow())
    {
        setAhclemyOpener();
        InvenLimitUpdate();
        setButtons();
    }
    return;
}

function handleChangedSubjob(string param)
{
    ParseInt(param, "SubjobClassID_0", mainClass);
    setAhclemyOpener();
    setButtons();
    return;
}

function handleNotifySubjob(string param)
{
    ParseInt(param, "SubjobClassID_0", mainClass);
    setAhclemyOpener();
    setButtons();
    return;
}

function ReceiveHairAccessoryPriority(string param)
{
    local int __var10708;

    ViewHairButton.HideWindow();
    ViewAccessoryButton.HideWindow();
    ParseInt(param, "priority", __var10708);
    // End:0x55
    if(__var10708 == 0)
    {
        ViewHairButton.ShowWindow();        
    }
    else
    {
        // End:0x6F
        if(__var10708 == 1)
        {
            ViewAccessoryButton.ShowWindow();
        }
    }
    return;
}

function setAhclemyOpener()
{
    local UserInfo Info;

    // End:0x12
    if(!GetPlayerInfo(Info))
    {
        return;
    }
    // End:0x1F0
    if(Info.Race == 6)
    {
        AlchemyOpenerBtn.ShowWindow();
        // End:0x116
        if((GetClassTransferDegree(Info.nSubClass) > 1) && mainClass == Info.nSubClass)
        {
            toggleAlchemyOpenerTooltip(true);
            AlchemyOpenerBtn.EnableWindow();
            AlchemyOpenerBtn.ShowWindow();
            AlchemyOpenerBtn.SetTexture("L2ui_ct1.InventoryWnd.Alchemyopener", "L2ui_ct1.InventoryWnd.InventoryWnd.Alchemyopener", "L2ui_ct1.InventoryWnd.Alchemyopener_drag");            
        }
        else
        {
            toggleAlchemyOpenerTooltip(false);
            AlchemyOpenerBtn.DisableWindow();
            AlchemyOpenerBtn.HideWindow();
            AlchemyOpenerBtn.SetTexture("L2ui_ct1.InventoryWnd.Alchemyopener_disable", "L2ui_ct1.InventoryWnd.InventoryWnd.Alchemyopener_disable", "L2ui_ct1.InventoryWnd.Alchemyopener_disable");
            AlchemyOpenerWindow.HideWindow();
        }        
    }
    else
    {
        AlchemyOpenerBtn.HideWindow();
    }
    return;
}

function InitScrollBar()
{
    m_invenItem.SetScrollBarPosition(0, 17, 0);
    m_invenItem_1.SetScrollBarPosition(0, 17, 0);
    m_invenItem_2.SetScrollBarPosition(0, 17, 0);
    m_invenItem_3.SetScrollBarPosition(0, 17, 0);
    m_invenItem_4.SetScrollBarPosition(0, 17, 0);
    m_questItem.SetScrollBarPosition(0, 17, 0);
    return;
}

function extendInventory(bool flag)
{
    local ItemWindowHandle tmpItemWindowHandle;
    local int __var2261;

    // End:0xA7
    if(flag)
    {
        currentInvenCol = 12;
        __var2261 = 108;
        m_InventoryItembg_expand.ShowWindow();
        m_BtnWindowExpand.SetTexture("L2UI_CT1.frames_df_Btn_Minimize", "L2UI_ct1.frames_df_btn_Minimize_down", "L2UI_ct1.frames_df_btn_Minimize_over");        
    }
    else
    {
        currentInvenCol = 9;
        __var2261 = 0;
        m_InventoryItembg_expand.HideWindow();
        m_BtnWindowExpand.SetTexture("L2UI_ct1.frames_df_btn_Expand", "L2UI_ct1.frames_df_btn_Expand_down", "L2UI_ct1.frames_df_btn_Expand_over");
    }
    m_hInventoryWnd.SetWindowSize(556 + __var2261, 394);
    m_invenItem.SetWindowSize(339 + __var2261, 288);
    m_invenItem_1.SetWindowSize(339 + __var2261, 288);
    m_invenItem_2.SetWindowSize(339 + __var2261, 288);
    m_invenItem_3.SetWindowSize(339 + __var2261, 288);
    m_invenItem_4.SetWindowSize(339 + __var2261, 288);
    m_questItem.SetWindowSize(339 + __var2261, 288);
    m_tabbg.SetWindowSize(350 + __var2261, 321);
    m_tabbgLine.SetWindowSize(10 + __var2261, 23);
    m_invenItem.SetCol(currentInvenCol);
    m_invenItem_1.SetCol(currentInvenCol);
    m_invenItem_2.SetCol(currentInvenCol);
    m_invenItem_3.SetCol(currentInvenCol);
    m_invenItem_4.SetCol(currentInvenCol);
    m_questItem.SetCol(currentInvenCol);
    // End:0x2E3
    if(m_selectedItemTab == 0)
    {
        tmpItemWindowHandle = m_invenItem;
    }
    // End:0x2F9
    if(m_selectedItemTab == 1)
    {
        tmpItemWindowHandle = m_invenItem_1;
    }
    // End:0x310
    if(m_selectedItemTab == 2)
    {
        tmpItemWindowHandle = m_invenItem_2;
    }
    // End:0x327
    if(m_selectedItemTab == 3)
    {
        tmpItemWindowHandle = m_invenItem_3;
    }
    // End:0x341
    if(m_selectedItemTab == 4)
    {
        tmpItemWindowHandle = m_invenItem_4;        
    }
    else
    {
        // End:0x358
        if(m_selectedItemTab == 5)
        {
            tmpItemWindowHandle = m_questItem;
        }
    }
    tmpItemWindowHandle.SetScrollPosition(0);
    tmpItemWindowHandle.ResizeScrollBar();
    tmpItemWindowHandle.SetFocus();
    return;
}

function checkClassicForm()
{
    m_EquipWindow.HideWindow();
    setEquipWindowHandle();
    m_EquipWindow.ShowWindow();
    getHandles();
    return;
}

function SetAdenaText()
{
    local string __var19469;

    __var19469 = MakeCostString((GetAdena()));
    m_hAdenaTextBox.SetText(__var19469);
    m_hAdenaTextBox.SetTooltipString(ConvertNumToText((GetAdena())));
    return;
}

function SetItemCount()
{
    local int __var8546, __var8547;

    // End:0x26
    if(m_selectedItemTab == 5)
    {
        __var8547 = m_QuestInvenCount;
        __var8546 = GetQuestItemInventoryLimit();        
    }
    else
    {
        __var8547 = m_NormalInvenCount + (EquipItemGetItemNum());
        __var8546 = GetMyInventoryLimit();
    }
    m_itemCount.SetText(((("(" $ string(__var8547)) $ "/") $ string(__var8546)) $ ")");
    pInventoryItemCount = __var8546 - __var8547;
    return;
}

function InvenLimitUpdate()
{
    ItemboxUpdate(m_invenItem, GetMyInventoryLimit());
    ItemboxUpdate(m_invenItem_1, GetMyInventoryLimit());
    ItemboxUpdate(m_invenItem_2, GetMyInventoryLimit());
    ItemboxUpdate(m_invenItem_3, GetMyInventoryLimit());
    ItemboxUpdate(m_invenItem_4, GetMyInventoryLimit());
    ItemboxUpdate(m_questItem, GetQuestItemInventoryLimit());
    return;
}

function ItemboxUpdate(ItemWindowHandle hItemWnd, int iInvenLimit)
{
    local int __var3689, __var6358, __var19450, __var8654;
    local ItemInfo kClearItem, kCurItem;

    kClearItem.IconName = "L2ui_ct1.emptyBtn";
    ClearItemID(kClearItem.Id);
    __var6358 = hItemWnd.GetItemNum();
    // End:0x9B
    if(__var6358 < iInvenLimit)
    {
        __var19450 = iInvenLimit - __var6358;
        __var3689 = 0;
        J0x6B:

        // End:0x98 [Loop If]
        if(__var3689 < __var19450)
        {
            hItemWnd.AddItem(kClearItem);
            __var3689++;
            // [Loop Continue]
            goto J0x6B;
        }        
    }
    else
    {
        // End:0x14B
        if(__var6358 > iInvenLimit)
        {
            __var8654 = __var6358 - iInvenLimit;
            __var3689 = hItemWnd.GetItemNum() - 1;
            J0xD4:

            // End:0x14B [Loop If]
            if(__var3689 >= 0)
            {
                // End:0x141
                if(__var8654 > 0)
                {
                    hItemWnd.GetItem(__var3689, kCurItem);
                    // End:0x133
                    if(!IsValidItemID(kCurItem.Id))
                    {
                        hItemWnd.DeleteItem(__var3689);
                        __var8654--;
                    }
                    // End:0x141
                    if(__var8654 <= 0)
                    {
                        // [Explicit Break]
                        goto J0x14B;
                    }
                }
                __var3689--;
                // [Loop Continue]
                goto J0xD4;
            }
        }
    }
    J0x14B:

    return;
}

function HandleSetMaxCount(string param)
{
    local int __var19442;

    ParseInt(param, "Inventory", m_MaxInvenCount);
    ParseInt(param, "questItem", m_MaxQuestItemInvenCount);
    ParseInt(param, "extrabelt", __var19442);
    m_invenItem.SetExpandItemNum(0, __var19442);
    InvenLimitUpdate();
    SetItemCount();
    return;
}

function HandleToggleWindow()
{
    // End:0x2C
    if(m_hOwnerWnd.IsShowWindow())
    {
        m_hOwnerWnd.HideWindow();
        PlayConsoleSound(14);        
    }
    else
    {
        ShowWindowWithFocus("InventoryWnd");
        m_hOwnerWnd.SetTimer(1718, 5000);
    }
    return;
}

function HandleOpenWindow(string param)
{
    local int __var19441;

    // End:0x1D
    if(cur_state == "BEAUTYSHOPSTATE")
    {
        return;
    }
    ParseInt(param, "Open", __var19441);
    // End:0x40
    if(__var19441 == 0)
    {
        return;
    }
    // End:0x53
    if(bFalseOpen)
    {
        bFalseOpen = false;
        return;
    }
    OpenWindow();
    return;
}

function OpenWindow()
{
    m_hInventoryWnd.ShowWindow();
    m_hInventoryWnd.SetFocus();
    return;
}

function HandleHideWindow()
{
    DialogHide();
    HideWindow(m_WindowName);
    return;
}

function handleEnchantJewelButton()
{
    local ItemJewelEnchantWnd script;

    script = ItemJewelEnchantWnd(GetScript("ItemJewelEnchantWnd"));
    script.toggleShowWindow();
    return;
}

function toggleShowAlchemyWindow(string winName)
{
    // End:0x2E
    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(winName))
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow(winName);        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(winName);
    }
    return;
}

function toggleAlchemyOpener()
{
    // End:0x24
    if(AlchemyOpenerWindow.IsShowWindow())
    {
        AlchemyOpenerWindow.HideWindow();        
    }
    else
    {
        AlchemyOpenerWindow.ShowWindow();
    }
    return;
}

function toggleAgathionWindow()
{
    // End:0x114
    if(AgathionWindow.IsShowWindow())
    {
        // End:0x98
        if(getInstanceUIData().getIsClassicServer())
        {
            AgathionBtn.SetTexture("L2UI_CT1.button.BtnEditDown", "L2UI_CT1.button.BtnEditDown_down", "L2UI_CT1.button.BtnEditDown_over");            
        }
        else
        {
            AgathionBtn.SetTexture("L2UI_CT1.button.BtnEditUp", "L2UI_CT1.button.BtnEditUp_down", "L2UI_CT1.button.BtnEditUp_over");
        }
        AgathionWindow.HideWindow();        
    }
    else
    {
        // End:0x194
        if(getInstanceUIData().getIsClassicServer())
        {
            AgathionBtn.SetTexture("L2UI_CT1.button.BtnEditUp", "L2UI_CT1.button.BtnEditUp_down", "L2UI_CT1.button.BtnEditUp_over");            
        }
        else
        {
            AgathionBtn.SetTexture("L2UI_CT1.button.BtnEditDown", "L2UI_CT1.button.BtnEditDown_down", "L2UI_CT1.button.BtnEditDown_over");
        }
        JewelWindow.HideWindow();
        JewelButton.SetTexture("L2UI_CT1.button.Button_DF_right", "L2UI_CT1.button.Button_DF_right_down", "L2UI_CT1.button.Button_DF_right_over");
        AgathionWindow.ShowWindow();
        AgathionWindow.SetFocus();
    }
    return;
}

function toggleJewelWindow()
{
    // End:0x95
    if(JewelWindow.IsShowWindow())
    {
        JewelButton.SetTexture("L2UI_CT1.Button.BtnEditDown", "L2UI_CT1.Button.BtnEditDown_down", "L2UI_CT1.bButton.BtnEditDown_over");
        JewelWindow.HideWindow();        
    }
    else
    {
        AgathionWindow.HideWindow();
        // End:0x12A
        if(getInstanceUIData().getIsClassicServer())
        {
            AgathionBtn.SetTexture("L2UI_CT1.button.BtnEditDown", "L2UI_CT1.button.BtnEditDown_down", "L2UI_CT1.button.BtnEditDown_over");            
        }
        else
        {
            AgathionBtn.SetTexture("L2UI_CT1.button.BtnEditUp", "L2UI_CT1.button.BtnEditUp_down", "L2UI_CT1.button.BtnEditUp_over");
        }
        JewelButton.SetTexture("L2UI_CT1.button.BtnEditUp", "L2UI_CT1.button.BtnEditUp_down", "L2UI_CT1.button.BtnEditUp_over");
        JewelWindow.ShowWindow();
        JewelWindow.SetFocus();
    }
    return;
}

function HandleChangeCharacterPawn(string param)
{
    ParseInt(param, "MeshType", m_MeshType);
    switch(m_MeshType)
    {
        // End:0x64
        case 0:
            m_ObjectViewport.SetCharacterScale(1.0000000);
            m_ObjectViewport.SetCharacterOffsetX(-2);
            m_ObjectViewport.SetCharacterOffsetY(-6);
            // End:0x44B
            break;
        // End:0xA7
        case 1:
            m_ObjectViewport.SetCharacterScale(1.0300000);
            m_ObjectViewport.SetCharacterOffsetX(-2);
            m_ObjectViewport.SetCharacterOffsetY(-8);
            // End:0x44B
            break;
        // End:0xE8
        case 8:
            m_ObjectViewport.SetCharacterScale(1.0470000);
            m_ObjectViewport.SetCharacterOffsetX(2);
            m_ObjectViewport.SetCharacterOffsetY(-8);
            // End:0x44B
            break;
        // End:0x12C
        case 9:
            m_ObjectViewport.SetCharacterScale(1.0700000);
            m_ObjectViewport.SetCharacterOffsetX(-1);
            m_ObjectViewport.SetCharacterOffsetY(-9);
            // End:0x44B
            break;
        // End:0x170
        case 6:
            m_ObjectViewport.SetCharacterScale(0.9800000);
            m_ObjectViewport.SetCharacterOffsetX(-2);
            m_ObjectViewport.SetCharacterOffsetY(-7);
            // End:0x44B
            break;
        // End:0x1B4
        case 7:
            m_ObjectViewport.SetCharacterScale(1.0400000);
            m_ObjectViewport.SetCharacterOffsetX(-4);
            m_ObjectViewport.SetCharacterOffsetY(-8);
            // End:0x44B
            break;
        // End:0x1F8
        case 2:
            m_ObjectViewport.SetCharacterScale(0.9900000);
            m_ObjectViewport.SetCharacterOffsetX(-1);
            m_ObjectViewport.SetCharacterOffsetY(-7);
            // End:0x44B
            break;
        // End:0x23C
        case 3:
            m_ObjectViewport.SetCharacterScale(1.0150000);
            m_ObjectViewport.SetCharacterOffsetX(-1);
            m_ObjectViewport.SetCharacterOffsetY(-7);
            // End:0x44B
            break;
        // End:0x27C
        case 10:
            m_ObjectViewport.SetCharacterScale(0.9530000);
            m_ObjectViewport.SetCharacterOffsetX(0);
            m_ObjectViewport.SetCharacterOffsetY(-9);
            // End:0x44B
            break;
        // End:0x2BD
        case 11:
            m_ObjectViewport.SetCharacterScale(0.9700000);
            m_ObjectViewport.SetCharacterOffsetX(2);
            m_ObjectViewport.SetCharacterOffsetY(-8);
            // End:0x44B
            break;
        // End:0x301
        case 12:
            m_ObjectViewport.SetCharacterScale(0.9550000);
            m_ObjectViewport.SetCharacterOffsetX(-2);
            m_ObjectViewport.SetCharacterOffsetY(-8);
            // End:0x44B
            break;
        // End:0x341
        case 13:
            m_ObjectViewport.SetCharacterScale(0.9850000);
            m_ObjectViewport.SetCharacterOffsetX(0);
            m_ObjectViewport.SetCharacterOffsetY(-8);
            // End:0x44B
            break;
        // End:0x381
        case 4:
            m_ObjectViewport.SetCharacterScale(1.0430000);
            m_ObjectViewport.SetCharacterOffsetX(0);
            m_ObjectViewport.SetCharacterOffsetY(-2);
            // End:0x44B
            break;
        // End:0x3C1
        case 5:
            m_ObjectViewport.SetCharacterScale(1.0900000);
            m_ObjectViewport.SetCharacterOffsetX(0);
            m_ObjectViewport.SetCharacterOffsetY(-6);
            // End:0x44B
            break;
        // End:0x405
        case 14:
            m_ObjectViewport.SetCharacterScale(0.9930000);
            m_ObjectViewport.SetCharacterOffsetX(-5);
            m_ObjectViewport.SetCharacterOffsetY(-6);
            // End:0x44B
            break;
        // End:0x445
        case 15:
            m_ObjectViewport.SetCharacterScale(1.0100000);
            m_ObjectViewport.SetCharacterOffsetX(0);
            m_ObjectViewport.SetCharacterOffsetY(-6);
            // End:0x44B
            break;
        // End:0xFFFF
        default:
            // End:0x44B
            break;
            break;
    }
    return;
}

function showItemUpdateEffect(string param)
{
    local int __var19397, __var8997;
    local ItemInfo Info, NewItem, tmpItem;
    local ItemWindowHandle targetItemWnd;
    local string __var19391, __var9023;

    ParseString(param, "type", __var19391);
    ParamToItemInfo(param, NewItem);
    __var8997 = 0;
    J0x2D:

    // End:0x7D [Loop If]
    if(__var8997 < 37)
    {
        m_equipItem[__var8997].GetItem(0, tmpItem);
        // End:0x73
        if(IsSameServerID(tmpItem.Id, NewItem.Id))
        {
            return;
        }
        __var8997++;
        // [Loop Continue]
        goto J0x2D;
    }
    // End:0x91
    if(__var19391 == "delete")
    {
        return;
    }
    // End:0xA4
    if(IsEquipItem(NewItem))
    {
        return;        
    }
    else
    {
        // End:0xC0
        if(IsQuestItem(NewItem))
        {
            targetItemWnd = m_questItem;            
        }
        else
        {
            targetItemWnd = m_invenItem;
        }
    }
    __var19397 = targetItemWnd.FindItem(NewItem.Id);
    targetItemWnd.GetItem(__var19397, Info);
    // End:0x18F
    if(__NFUN_408__(Info.ItemNum, NewItem.ItemNum))
    {
        __var9023 = "iconName=" $ NewItem.IconName;
        __var9023 = (__var9023 @ "itemNum=") $ (__NFUN_405__(NewItem.ItemNum, Info.ItemNum));
        getInstanceL2Util().showGfxScreenMessage(__var9023, int(getInstanceL2Util().1));
    }
    return;
}

function CustomTooltip getAgathionTooltip(string Title, string Desc)
{
    local CustomTooltip t;
    local L2Util util;

    util = L2Util(GetScript("L2Util"));
    util.setCustomTooltip(t);
    util.ToopTipInsertText(Title, true, false, util.1);
    util.ToopTipInsertText(Desc, true, true, util.1);
    return util.getCustomTooltip();
    return;
}

function setCustomTooltip()
{
    local L2Util util;
    local CustomTooltip t;

    util = L2Util(GetScript("L2Util"));
    util.setCustomTooltip(t);
    util.ToopTipMinWidth(150);
    util.ToopTipInsertText(GetSystemString(3265), true, false);
    util.TooltipInsertItemBlank(4);
    util.ToopTipInsertText(GetSystemString(3270), false, true, util.1);
    AlchemyMixCubeWndBtn.SetTooltipCustomType(util.getCustomTooltip());
    util.setCustomTooltip(t);
    util.ToopTipMinWidth(150);
    util.ToopTipInsertText(GetSystemString(3266), true, false);
    util.TooltipInsertItemBlank(4);
    util.ToopTipInsertText(GetSystemString(3271), false, true, util.1);
    AlchemyItemConversionWndBtn.SetTooltipCustomType(util.getCustomTooltip());
    AlchemyItemCreateWndBtn.DisableWindow();
    util.setCustomTooltip(t);
    util.ToopTipInsertText(GetSystemString(3312), true, false);
    util.TooltipInsertItemBlank(4);
    util.ToopTipInsertText(GetSystemString(3272), false, true, util.1);
    AlchemyItemCreateWndBtn.SetTooltipCustomType(util.getCustomTooltip());
    return;
}

function toggleAlchemyOpenerTooltip(bool isOn)
{
    local L2Util util;
    local CustomTooltip t;

    util = L2Util(GetScript("L2Util"));
    util.setCustomTooltip(t);
    util.ToopTipInsertText(GetSystemString(3257), true, false);
    // End:0x9D
    if(!isOn)
    {
        util.ToopTipMinWidth(150);
        util.TooltipInsertItemBlank(4);
        util.ToopTipInsertText(GetSystemMessage(4263), false, true, util.1);
    }
    AlchemyOpenerBtn.SetTooltipCustomType(util.getCustomTooltip());
    return;
}

function string getAgathionSlotBitTypeString(string keyword)
{
    switch(keyword)
    {
        // End:0x1E
        case "n":
            return "68719476736";
            // End:0x85
            break;
        // End:0x36
        case "1":
            return "137438953472";
            // End:0x85
            break;
        // End:0x4E
        case "2":
            return "274877906944";
            // End:0x85
            break;
        // End:0x66
        case "3":
            return "549755813888";
            // End:0x85
            break;
        // End:0x7F
        case "4":
            return "1099511627776";
            // End:0x85
            break;
        // End:0xFFFF
        default:
            // End:0x85
            break;
            break;
    }
    return "";
    return;
}

function ItemWindowHandle getItemWindowHandleBystrTarget(string strTarget)
{
    switch(strTarget)
    {
        // End:0x22
        case "InventoryItem":
            return m_invenItem;
            // End:0x9C
            break;
        // End:0x3F
        case "InventoryItem_1":
            return m_invenItem_1;
            // End:0x9C
            break;
        // End:0x5C
        case "InventoryItem_2":
            return m_invenItem_2;
            // End:0x9C
            break;
        // End:0x79
        case "InventoryItem_3":
            return m_invenItem_3;
            // End:0x9C
            break;
        // End:0x96
        case "InventoryItem_4":
            return m_invenItem_4;
            // End:0x9C
            break;
        // End:0xFFFF
        default:
            // End:0x9C
            break;
            break;
    }
    return;
}

function ItemWindowHandle getItemWindowHandleByItemType(ItemInfo item)
{
    // End:0x1B
    if(!IsValidItemID(item.Id))
    {
        return m_invenItem_4;
    }
    switch(Class'NWindow.UIDATA_ITEM'.static.GetInventoryType(item.Id.ClassID))
    {
        // End:0x49
        case 1:
            return m_invenItem_1;
            // End:0x89
            break;
        // End:0x57
        case 2:
            return m_invenItem_2;
            // End:0x89
            break;
        // End:0x65
        case 3:
            return m_invenItem_3;
            // End:0x89
            break;
        // End:0x6A
        case 4:
        // End:0x78
        case 0:
            return m_invenItem_4;
            // End:0x89
            break;
        // End:0x83
        case 5:
            return m_questItem;
        // End:0xFFFF
        default:
            // End:0x89
            break;
            break;
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

function onCallTabButton(string strID)
{
    SetItemsWithFindString(GetEditBoxHandle("InventoryWnd.SearchInputWnd.SearchInput").GetString());
    return;
}

function OnChangeEditBox(string strID)
{
    local string __var44054;

    // End:0x56
    if(strID == "SearchInput")
    {
        SetItemsWithFindString(GetEditBoxHandle("InventoryWnd.SearchInputWnd.SearchInput").GetString());
    }
    return;
}

function SetItemsWithFindString(string Text)
{
    local int __var5965, __var44050;
    local ItemWindowHandle targetItemList;
    local ItemInfo targetItemInfo, equipItemInfo;

    // End:0x16
    if(!m_hOwnerWnd.IsShowWindow())
    {
        return;
    }
    // End:0x2B
    if(Len(Text) < 1)
    {
        setSearchClear();
        return;
    }
    GetButtonHandle("InventoryWnd.SearchInputWnd.ClearSearchBtn").ShowWindow();
    targetItemList = getTargetList();
    __var5965 = 0;
    J0x7A:

    // End:0xF2 [Loop If]
    if(__var5965 < targetItemList.GetItemNum())
    {
        // End:0xE8
        if(bIsSearchItem(targetItemList, __var5965, targetItemInfo))
        {
            targetItemList.SetItemSkillDisabled(__var5965, int(!StringMatching(ToLowerByLanguage(GetItemNameAll(targetItemInfo)), ToLowerByLanguage(Text), " ")));
        }
        __var5965++;
        // [Loop Continue]
        goto J0x7A;
    }
    return;
}

function bool bIsSearchItem(ItemWindowHandle itemsList, int Index, out ItemInfo Info)
{
    local ItemInfo tmpInf;

    // End:0x50
    if(itemsList.GetItem(Index, tmpInf))
    {
        // End:0x50
        if((IsValidItemID(tmpInf.Id)) && Len(tmpInf.Name) > 0)
        {
            Info = tmpInf;
            return true;
        }
    }
    return;
}

function setSearchClear()
{
    local int __var2981;

    __var2981 = 0;
    J0x07:

    // End:0x9E [Loop If]
    if(__var2981 < 500)
    {
        m_invenItem.SetItemSkillDisabled(__var2981, 0);
        m_invenItem_1.SetItemSkillDisabled(__var2981, 0);
        m_invenItem_2.SetItemSkillDisabled(__var2981, 0);
        m_invenItem_3.SetItemSkillDisabled(__var2981, 0);
        m_invenItem_4.SetItemSkillDisabled(__var2981, 0);
        m_questItem.SetItemSkillDisabled(__var2981, 0);
        __var2981++;
        // [Loop Continue]
        goto J0x07;
    }
    GetEditBoxHandle("InventoryWnd.SearchInputWnd.SearchInput").Clear();
    GetButtonHandle("InventoryWnd.SearchInputWnd.ClearSearchBtn").HideWindow();
    return;
}

function ItemWindowHandle getTargetList()
{
    switch(m_invenTab.GetTopIndex())
    {
        // End:0x1B
        case 0:
            return m_invenItem;
        // End:0x25
        case 1:
            return m_invenItem_1;
        // End:0x30
        case 2:
            return m_invenItem_2;
        // End:0x3B
        case 3:
            return m_invenItem_3;
        // End:0x46
        case 4:
            return m_invenItem_4;
        // End:0x51
        case 5:
            return m_questItem;
        // End:0xFFFF
        default:
            // End:0x57
            break;
            break;
    }
    return;
}

function handleNewItem(ItemInfo addedItemInfo)
{
    local int __var5855;

    // End:0x18
    if(addedItemInfo.Id.ClassID == 57)
    {
        return;
    }
    // End:0x37
    if(m_hOwnerWnd.IsShowWindow())
    {
        SetNewAcquiredUtil(addedItemInfo, true, false);
    }
    __var5855 = findNewItem(addedItemInfo.Id);
    // End:0x8C
    if(__var5855 == -1)
    {
        __var5855 = newItems.Length;
        newItems.Length = newItems.Length + 1;
        newItems[__var5855] = addedItemInfo;        
    }
    else
    {
        // End:0xBD
        if(__NFUN_408__(newItems[__var5855].ItemNum, addedItemInfo.ItemNum))
        {
            newItems[__var5855] = addedItemInfo;
        }
    }
    return;
}

function SetNewAcquiredUtil(ItemInfo iInfo, bool On, optional bool bIsFactClick)
{
    local int __var2226;
    local ItemWindowHandle tmpInven;
    local ItemInfo item;
    local ItemWindowHandle detailItemWindow;

    detailItemWindow = getItemWindowHandleByItemType(iInfo);
    __var2226 = detailItemWindow.FindItem(iInfo.Id);
    // End:0xE1
    if(__var2226 != -1)
    {
        // End:0xE1
        if(detailItemWindow.GetItem(__var2226, item))
        {
            // End:0x9E
            if(On)
            {
                item.ForeTexture = "L2UI_CT1.InventoryWnd.Inventory_NewItem_01";                
            }
            else
            {
                item.ForeTexture = "";
            }
            detailItemWindow.SetItem(__var2226, item);
            // End:0xE1
            if(bIsFactClick)
            {
                detailItemWindow.SetSelectedNum(__var2226);
            }
        }
    }
    tmpInven = m_invenItem;
    __var2226 = tmpInven.FindItem(iInfo.Id);
    // End:0x1BC
    if(__var2226 != -1)
    {
        // End:0x1BC
        if(m_invenItem.GetItem(__var2226, item))
        {
            // End:0x179
            if(On)
            {
                item.ForeTexture = "L2UI_CT1.InventoryWnd.Inventory_NewItem_01";                
            }
            else
            {
                item.ForeTexture = "";
            }
            m_invenItem.SetItem(__var2226, item);
            // End:0x1BC
            if(bIsFactClick)
            {
                m_invenItem.SetSelectedNum(__var2226);
            }
        }
    }
    return;
}

function handleNewItemOnShow()
{
    local int __var9195;

    __var9195 = 0;
    J0x07:

    // End:0x34 [Loop If]
    if(__var9195 < newItems.Length)
    {
        SetNewAcquiredUtil(newItems[__var9195], true, false);
        __var9195++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function handleNewItemOnHide()
{
    local int __var9198;

    __var9198 = 0;
    J0x07:

    // End:0x34 [Loop If]
    if(__var9198 < newItems.Length)
    {
        SetNewAcquiredUtil(newItems[__var9198], false, false);
        __var9198++;
        // [Loop Continue]
        goto J0x07;
    }
    newItems.Length = 0;
    return;
}

function int findNewItem(ItemID Id)
{
    local int __var6013;

    __var6013 = 0;
    J0x07:

    // End:0x44 [Loop If]
    if(__var6013 < newItems.Length)
    {
        // End:0x3A
        if(newItems[__var6013].Id == Id)
        {
            return __var6013;
        }
        __var6013++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

defaultproperties
{
    m_WindowName="InventoryWnd"
}