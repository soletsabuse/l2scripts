class TeleportBookMarkWnd extends UICommonAPI;

const TEMPLATEICONNAME = "L2ui_ct1.TeleportBookMark_DF_Icon_";

var WindowHandle Me;
var WindowHandle BookMarkEditWnd;
var TextBoxHandle txtTeleportLoc;
var ItemWindowHandle ItemBookMarkItem;
var TextBoxHandle txtSlotAvailability;
var TextBoxHandle txtSavedTeleportList;
var TextBoxHandle txtRequiredItemCount;
var MinimapCtrlHandle Minimap;
var ButtonHandle ItemDelete;
var ButtonHandle ItemEdit;
var ButtonHandle btnSaveMyLoc;
var TeleportBookMarkDrawerWnd m_Script;
var ButtonHandle btnReduce;
var TextBoxHandle txtNoticeMessage;
var TextBoxHandle txtNoticeMessage2;
var TextureHandle TexDeactivated;
var ItemID m_CurBookMarkItemID;
var ItemID m_DeleteBookMarkItemID;
var int m_totalableSlotNum;

function OnEnterState(name a_PreStateName)
{
    return;
}

function OnShow()
{
    // End:0x18
    if(getInstanceL2Util().checkIsPrologueGrowType(string(self)))
    {
        return;
    }
    MinimapWnd(GetScript("MinimapWnd")).showMapIconElement();
    Class'NWindow.BookMarkAPI'.static.RequestBookMarkSlotInfo();
    Class'NWindow.BookMarkAPI'.static.RequestShowBookMark();
    OnMyLocBtnClick();
    GetTeleportItemCnt();
    btnReduce.HideWindow();
    return;
}

function GetTeleportItemCnt()
{
    txtSavedTeleportList.SetText(MakeFullSystemMsg(GetSystemMessage(2360), string(GetTeleportBookMarkCount()), ""));
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    InitializeCOD();
    load();
    txtNoticeMessage.ShowWindow();
    txtNoticeMessage2.ShowWindow();
    ClearItemID(m_CurBookMarkItemID);
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("TeleportBookMarkWnd");
    BookMarkEditWnd = GetWindowHandle("TeleportBookMarkDrawerWnd");
    txtTeleportLoc = GetTextBoxHandle("TeleportBookMarkWnd.txtTeleportLoc");
    ItemBookMarkItem = GetItemWindowHandle("TeleportBookMarkWnd.ItemBookMarkItem");
    txtSlotAvailability = GetTextBoxHandle("TeleportBookMarkWnd.txtSlotAvailability");
    txtSavedTeleportList = GetTextBoxHandle("TeleportBookMarkWnd.txtSavedTeleportList");
    txtRequiredItemCount = GetTextBoxHandle("TeleportBookMarkWnd.txtRequiredItemCount");
    Minimap = GetMinimapCtrlHandle("TeleportBookMarkWnd.Minimap");
    ItemDelete = GetButtonHandle("TeleportBookMarkWnd.ItemDelete");
    ItemEdit = GetButtonHandle("TeleportBookMarkWnd.ItemEdit");
    btnSaveMyLoc = GetButtonHandle("TeleportBookMarkWnd.btnSaveMyLoc");
    btnReduce = GetButtonHandle("TeleportBookMarkWnd.btnReduce");
    TexDeactivated = GetTextureHandle("TeleportBookMarkWnd.TexDeactivated");
    txtNoticeMessage = GetTextBoxHandle("TeleportBookMarkWnd.txtNoticeMessage");
    txtNoticeMessage2 = GetTextBoxHandle("TeleportBookMarkWnd.txtNoticeMessage2");
    btnReduce.HideWindow();
    m_Script = TeleportBookMarkDrawerWnd(GetScript("TeleportBookMarkDrawerWnd"));
    return;
}

function load()
{
    ClearItemID(m_CurBookMarkItemID);
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(1870);
    RegisterEvent(3450);
    RegisterEvent(3451);
    RegisterEvent(2420);
    RegisterEvent(580);
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x21
        case "btnSaveMyLoc":
            OnbtnSaveMyLocClick();
            // End:0x72
            break;
        // End:0x37
        case "BtnMyLoc":
            OnMyLocBtnClick();
            // End:0x72
            break;
        // End:0x6C
        case "btnReduce":
            Minimap.RequestReduceBtn();
            btnReduce.HideWindow();
            SetLocatorOnMiniMap2();
            // End:0x72
            break;
        // End:0xFFFF
        default:
            // End:0x72
            break;
            break;
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int SystemMsgIndex;

    // End:0x1D
    if(Event_ID == 3450)
    {
        HandleBookMarkList(param);        
    }
    else
    {
        // End:0x65
        if(Event_ID == 1710)
        {
            // End:0x62
            if(DialogIsMine())
            {
                // End:0x62
                if(IsValidItemID(m_DeleteBookMarkItemID))
                {
                    Class'NWindow.BookMarkAPI'.static.RequestDeleteBookMarkSlot(m_DeleteBookMarkItemID);
                    ClearItemID(m_DeleteBookMarkItemID);
                }
            }            
        }
        else
        {
            // End:0x7D
            if(Event_ID == 2420)
            {
                GetTeleportItemCnt();                
            }
            else
            {
                // End:0x95
                if(Event_ID == 3451)
                {
                    OpenWindow();                    
                }
                else
                {
                    // End:0xA7
                    if(Event_ID == 1870)
                    {                        
                    }
                    else
                    {
                        // End:0xD8
                        if(Event_ID == 580)
                        {
                            ParseInt(param, "Index", SystemMsgIndex);
                            HandleUpdateItemCountSystemMessage(SystemMsgIndex);
                        }
                    }
                }
            }
        }
    }
    return;
}

function HandleUpdateItemCountSystemMessage(int Index)
{
    switch(Index)
    {
        // End:0x0F
        case 301:
        // End:0x17
        case 302:
        // End:0x1F
        case 301:
        // End:0x30
        case 377:
            GetTeleportItemCnt();
            // End:0x36
            break;
        // End:0xFFFF
        default:
            // End:0x36
            break;
            break;
    }
    return;
}

function OpenWindow()
{
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function OnDropItem(string strID, ItemInfo formInfItem, int X, int Y)
{
    switch(strID)
    {
        // End:0x24
        case "ItemDelete":
            OnDeleteBookMarkSlot(formInfItem);
            // End:0x72
            break;
        // End:0x3F
        case "ItemEdit":
            OnModifyBookMarkSlot(formInfItem);
            // End:0x72
            break;
        // End:0x6C
        case "ItemBookMarkItem":
            handleSwap(formInfItem, X, Y);
            // End:0x72
            break;
        // End:0xFFFF
        default:
            // End:0x72
            break;
            break;
    }
    return;
}

function handleSwap(ItemInfo formInfItem, int X, int Y)
{
    local int toIndex, fromIndex;
    local ItemInfo toItemInfo;

    // End:0x23
    if(formInfItem.DragSrcName != "ItemBookMarkItem")
    {
        return;
    }
    toIndex = ItemBookMarkItem.GetIndexAt(X, Y, 1, 1);
    // End:0xE9
    if(toIndex >= 0)
    {
        fromIndex = ItemBookMarkItem.FindItem(formInfItem.Id);
        // End:0xE9
        if(toIndex != fromIndex)
        {
            ItemBookMarkItem.GetItem(toIndex, toItemInfo);
            formInfItem.Id.ClassID = fromIndex + 1;
            toItemInfo.Id.ClassID = toIndex + 1;
            Class'NWindow.BookMarkAPI'.static.RequestChangeBookMarkSlot(formInfItem.Id, toItemInfo.Id);
        }
    }
    return;
}

function SetUnActiveSlots()
{
    TexDeactivated.ShowWindow();
    return;
}

function HandleBookMarkList(string param)
{
    local int idx, ableSlotNum, curSlotNum, iconID;
    local string strSlotTitle, strIconTitle, strTexture;
    local ItemInfo infItem, clearItem;
    local int emptySlot;
    local Vector loc;

    ClearItemID(clearItem.Id);
    clearItem.IconName = "L2ui_ct1.emptyBtn";
    Clear();
    ParseInt(param, "Count", ableSlotNum);
    curSlotNum = 0;
    m_totalableSlotNum = ableSlotNum;
    // End:0x9E
    if(ableSlotNum == 0)
    {
        txtNoticeMessage.ShowWindow();
        txtNoticeMessage2.ShowWindow();
        TexDeactivated.ShowWindow();
        SetUnActiveSlots();        
    }
    else
    {
        txtNoticeMessage.HideWindow();
        txtNoticeMessage2.HideWindow();
        TexDeactivated.HideWindow();
    }
    idx = 0;
    J0xD2:

    // End:0x2D1 [Loop If]
    if(idx < ableSlotNum)
    {
        strSlotTitle = "";
        strIconTitle = "";
        strTexture = "";
        ParseInt(param, "EmptySlot_" $ string(idx), emptySlot);
        // End:0x140
        if(emptySlot == 1)
        {
            ItemBookMarkItem.AddItem(clearItem);
            // [Explicit Continue]
            goto J0x2C7;
        }
        ParseItemIDWithIndex(param, infItem.Id, idx);
        ParseString(param, "SlotName_" $ string(idx), strSlotTitle);
        ParseInt(param, "IconID_" $ string(idx), iconID);
        ParseString(param, "IconName_" $ string(idx), strIconTitle);
        ParseFloat(param, "XPos_" $ string(idx), loc.X);
        ParseFloat(param, "YPos_" $ string(idx), loc.Y);
        ParseFloat(param, "ZPos_" $ string(idx), loc.Z);
        infItem.Name = strSlotTitle;
        infItem.AdditionalName = strIconTitle;
        infItem.IconName = "L2ui_ct1.TeleportBookMark_DF_Icon_" $ (itoStr(iconID));
        infItem.Description = strIconTitle;
        infItem.ItemSubType = 6;
        ItemBookMarkItem.AddItem(infItem);
        curSlotNum++;
        J0x2C7:

        ++idx;
        // [Loop Continue]
        goto J0xD2;
    }
    SetBookMarkCount(ableSlotNum, curSlotNum);
    return;
}

function OnDeleteBookMarkSlot(ItemInfo infItem)
{
    local string strMsg;

    // End:0x13
    if(infItem.ItemSubType != 6)
    {
        return;
    }
    strMsg = MakeFullSystemMsg(GetSystemMessage(2362), infItem.Name, "");
    m_DeleteBookMarkItemID = infItem.Id;
    DialogShow(1, 4, strMsg, string(self));
    return;
}

function OnModifyBookMarkSlot(ItemInfo infItem)
{
    local Vector loc;

    m_Script.txtTeleportBookMarkDrawerWndNameHead.SetText(GetSystemString(1762));
    // End:0x36
    if(infItem.ItemSubType != 6)
    {
        return;
    }
    m_CurBookMarkItemID = infItem.Id;
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkName", infItem.Name);
    Class'NWindow.UIAPI_EDITBOX'.static.SetString("TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkIcn", infItem.AdditionalName);
    Class'NWindow.BookMarkAPI'.static.RequestGetBookMarkPos(infItem.Id, loc);
    SetLocatorOnMiniMap(loc);
    m_Script.m_CurIconNum = int(Right(infItem.IconName, 2));
    m_Script.ItemBookMarkItem.SetSelectedNum(m_Script.m_CurIconNum - 1);
    m_Script.UpdateIcon();
    // End:0x197
    if(!BookMarkEditWnd.IsShowWindow())
    {
        BookMarkEditWnd.ShowWindow();
        BookMarkEditWnd.SetFocus();
    }
    return;
}

function OnbtnSaveMyLocClick()
{
    ClearItemID(m_CurBookMarkItemID);
    // End:0x2F
    if(BookMarkEditWnd.IsShowWindow())
    {
        BookMarkEditWnd.HideWindow();        
    }
    else
    {
        m_Script.InitializeUI();
        m_Script.UpdateCurrentLocation();
        BookMarkEditWnd.ShowWindow();
        SetCurrentLocOnMinimap();
    }
    GetTeleportItemCnt();
    return;
}

function SetCurrentLocOnMinimap()
{
    local Vector loc;

    loc = GetPlayerPosition();
    SetLocatorOnMiniMap(loc);
    return;
}

function MinimapRegionInfo makeRegionInfo(string TooltipString, Vector pLoc)
{
    local MinimapRegionInfo regionInfoForMapIcon;
    local MinimapRegionIconData IconData;
    local string toolTipParam;

    toolTipParam = "";
    ParamAdd(toolTipParam, "tooltipString", TooltipString);
    ParamAdd(toolTipParam, "Type", string(8));
    regionInfoForMapIcon.strTooltip = toolTipParam;
    regionInfoForMapIcon.eType = 8;
    regionInfoForMapIcon.nIndex = 1;
    IconData.nWidth = 24;
    IconData.nHeight = 24;
    IconData.nWorldLocX = int(pLoc.X);
    IconData.nWorldLocY = int(pLoc.Y - float(1500));
    IconData.nWorldLocZ = int(pLoc.Z);
    IconData.nIconOffsetX = 0;
    IconData.nIconOffsetY = -20;
    IconData.strIconNormal = "l2ui_ch3.mapicon_mark";
    IconData.strIconOver = "l2ui_ch3.mapicon_mark";
    IconData.strIconPushed = "l2ui_ch3.mapicon_mark";
    regionInfoForMapIcon.IconData = IconData;
    return regionInfoForMapIcon;
    return;
}

function SetLocatorOnMiniMap(Vector loc)
{
    local MinimapRegionInfo regionInfoForMapIcon;

    Minimap.SetShowRegionInfoByType(8, true);
    regionInfoForMapIcon = makeRegionInfo(GetSystemString(887), loc);
    Minimap.EraseRegionInfoCtrl(8, 1);
    Minimap.AddRegionInfoCtrl(regionInfoForMapIcon);
    Minimap.SetContinent(Minimap.GetContinent(loc));
    Minimap.AdjustMapView(loc);
    return;
}

function SetLocatorOnMiniMap2()
{
    local Vector loc;
    local string DataforMap;

    loc = GetPlayerPosition();
    ParamAdd(DataforMap, "Index", "BookMarkID");
    ParamAdd(DataforMap, "WorldX", string(loc.X));
    ParamAdd(DataforMap, "WorldY", string(loc.Y - float(1500)));
    ParamAdd(DataforMap, "BtnTexNormal", "l2ui_ch3.mapicon_mark");
    ParamAdd(DataforMap, "BtnTexPushed", "l2ui_ch3.mapicon_mark");
    ParamAdd(DataforMap, "BtnTexOver", "l2ui_ch3.mapicon_mark");
    ParamAdd(DataforMap, "BtnWidth", string(24));
    ParamAdd(DataforMap, "BtnHeight", string(24));
    ParamAdd(DataforMap, "Description", "");
    ParamAdd(DataforMap, "DescOffsetX", "0");
    ParamAdd(DataforMap, "DescOffsetY", "-20");
    ParamAdd(DataforMap, "Tooltip", "");
    Minimap.AddRegionInfo(DataforMap);
    return;
}

function Clear()
{
    Minimap.DeleteAllTarget();
    ItemBookMarkItem.super(TeleportBookMarkWnd).Clear();
    return;
}

function OnDBClickItem(string strID, int Index)
{
    local ItemInfo infItem;

    // End:0x77
    if((strID == "ItemBookMarkItem") && Index > -1)
    {
        // End:0x77
        if(ItemBookMarkItem.GetItem(Index, infItem))
        {
            // End:0x77
            if(infItem.Id.ClassID > 0)
            {
                Class'NWindow.BookMarkAPI'.static.RequestTelePortBookMark(infItem.Id);
            }
        }
    }
    GetTeleportItemCnt();
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo infItem;
    local Vector loc;

    // End:0x87
    if((strID == "ItemBookMarkItem") && Index > -1)
    {
        // End:0x87
        if(ItemBookMarkItem.GetItem(Index, infItem))
        {
            // End:0x87
            if(infItem.Id.ClassID > 0)
            {
                Class'NWindow.BookMarkAPI'.static.RequestGetBookMarkPos(infItem.Id, loc);
                SetLocatorOnMiniMap(loc);
            }
        }
    }
    GetTeleportItemCnt();
    return;
}

function SetBookMarkCount(int ableSlotNum, int curSlotNum)
{
    txtSlotAvailability.SetText(((("(" $ string(curSlotNum)) $ "/") $ string(ableSlotNum)) $ ")");
    return;
}

function OnMyLocBtnClick()
{
    local Vector PlayerPosition;

    PlayerPosition = GetPlayerPosition();
    Minimap.DeleteAllTarget();
    SetLocatorOnMiniMap(PlayerPosition);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("TeleportBookMarkWnd").HideWindow();
    return;
}

function string itoStr(int tmpNum)
{
    local string tmpStr;

    // End:0x21
    if(tmpNum < 10)
    {
        tmpStr = "0" $ string(tmpNum);        
    }
    else
    {
        tmpStr = string(tmpNum);
    }
    return tmpStr;
    return;
}
