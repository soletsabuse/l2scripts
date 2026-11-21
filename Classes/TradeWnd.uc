class TradeWnd extends UICommonAPI;

const DIALOG_ID_TRADE_REQUEST = 323;
const DIALOG_ID_ITEM_NUMBER = 324;

var string m_WindowName;
var L2Util util;
//var delegate<onTradeDone> __onTradeDone__Delegate;

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(1950);
    RegisterEvent(1960);
    RegisterEvent(1970);
    RegisterEvent(1980);
    RegisterEvent(1990);
    RegisterEvent(2000);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    OnRegisterEvent();
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    return;
}

function OnSendPacketWhenHiding()
{
    RequestTradeDone(false);
    return;
}

function OnHide()
{
    Clear();
    return;
}

function OnEvent(int EventID, string param)
{
    switch(EventID)
    {
        // End:0x1D
        case 1950:
            HandleStartTrade(param);
            // End:0xB6
            break;
        // End:0x33
        case 1960:
            HandleTradeAddItem(param);
            // End:0xB6
            break;
        // End:0x49
        case 1970:
            handleTradeDone(param);
            // End:0xB6
            break;
        // End:0x5F
        case 1980:
            HandleTradeOtherOK(param);
            // End:0xB6
            break;
        // End:0x75
        case 1990:
            HandleTradeUpdateInventoryItem(param);
            // End:0xB6
            break;
        // End:0x8B
        case 2000:
            HandleReceiveStartTrade(param);
            // End:0xB6
            break;
        // End:0x9C
        case 1710:
            HandleDialogOK();
            // End:0xB6
            break;
        // End:0xAD
        case 1720:
            HandleDialogCancel();
            // End:0xB6
            break;
        // End:0xFFFF
        default:
            // End:0xB6
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0B6
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0B6
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0B6
}

function OnClickButton(string ControlName)
{
    // End:0x45
    if(ControlName == "OKButton")
    {
        Class'NWindow.UIAPI_ITEMWINDOW'.static.SetFaded("TradeWnd.MyList", true);
        RequestTradeDone(true);
        DialogHide();        
    }
    else
    {
        // End:0x6D
        if(ControlName == "CancelButton")
        {
            RequestTradeDone(false);
            DialogHide();            
        }
        else
        {
            // End:0x89
            if(ControlName == "MoveButton")
            {
                HandleMoveButton();
            }
        }
    }
    return;
}

function OnDBClickItem(string ControlName, int Index)
{
    local ItemInfo Info;

    // End:0xDD
    if(ControlName == "InventoryList")
    {
        // End:0xDD
        if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList", Index, Info))
        {
            // End:0xCA
            if(IsStackableItem(Info.ConsumeType) && __NFUN_413__(Info.ItemNum, (1)))
            {
                DialogSetID(324);
                DialogSetReservedItemID(Info.Id);
                DialogSetParamInt64(Info.ItemNum);
                DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));                
            }
            else
            {
                RequestAddTradeItem(Info.Id, (1));
            }
        }
    }
    return;
}

function OnDropItem(string strID, ItemInfo Info, int X, int Y)
{
    // End:0x106
    if((strID == "MyList") && Info.DragSrcName == "InventoryList")
    {
        // End:0xF3
        if(IsStackableItem(Info.ConsumeType))
        {
            // End:0x75
            if(__NFUN_409__(Info.AllItemCount, (0)))
            {
                RequestAddTradeItem(Info.Id, Info.AllItemCount);                
            }
            else
            {
                // End:0x9E
                if(__NFUN_412__(Info.ItemNum, (1)))
                {
                    RequestAddTradeItem(Info.Id, (1));                    
                }
                else
                {
                    DialogSetID(324);
                    DialogSetReservedItemID(Info.Id);
                    DialogSetParamInt64(Info.ItemNum);
                    DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));
                }
            }            
        }
        else
        {
            RequestAddTradeItem(Info.Id, (1));
        }
    }
    return;
}

function MoveToMyList(int Index, INT64 Num)
{
    local ItemInfo Info;

    // End:0x49
    if(Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList", Index, Info))
    {
        RequestAddTradeItem(Info.Id, Num);
    }
    return;
}

function HandleMoveButton()
{
    local int selected;
    local ItemInfo Info;

    selected = Class'NWindow.UIAPI_ITEMWINDOW'.static.GetSelectedNum("TradeWnd.InventoryList");
    // End:0xDF
    if(selected >= 0)
    {
        Class'NWindow.UIAPI_ITEMWINDOW'.static.GetItem("TradeWnd.InventoryList", selected, Info);
        // End:0x8D
        if(__NFUN_412__(Info.ItemNum, (1)))
        {
            MoveToMyList(selected, (1));            
        }
        else
        {
            DialogSetID(324);
            DialogSetReservedItemID(Info.Id);
            DialogSetParamInt64(Info.ItemNum);
            DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), Info.Name, ""), string(self));
        }
    }
    return;
}

function HandleStartTrade(string param)
{
    local int targetID, TargetLevel, isFriend, isPledge, isMentoring, isAlliance,
	    isGM;

    local UserInfo targetInfo;
    local string ClanName, colorString, addStr, levelString, Name;

    local Rect itemWindowRect;

    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TradeWnd");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("TradeWnd");
    ParseInt(param, "targetId", targetID);
    ParseInt(param, "targetLevel", TargetLevel);
    ParseInt(param, "IsFriend", isFriend);
    ParseInt(param, "IsPledge", isPledge);
    ParseInt(param, "IsMentoring", isMentoring);
    ParseInt(param, "IsAlliance", isAlliance);
    ParseInt(param, "IsGM", isGM);
    // End:0x4B1
    if(targetID > 0)
    {
        GetUserInfo(targetID, targetInfo);
        // End:0x1CC
        if(targetInfo.nClanID > 0)
        {
            ClanName = GetClanName(targetInfo.nClanID);
            // End:0x160
            if(targetInfo.WantHideName && targetInfo.JoinedDominionID > 0)
            {
                Name = targetInfo.RealName;                
            }
            else
            {
                Name = targetInfo.Name;
            }
            // End:0x18A
            if(ClanName != "")
            {
                addStr = " - ";                
            }
            else
            {
                addStr = "";
            }
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("TradeWnd.Targetname", (Name $ addStr) $ ClanName);            
        }
        else
        {
            // End:0x1FF
            if(targetInfo.WantHideName && targetInfo.JoinedDominionID > 0)
            {
                Name = targetInfo.RealName;                
            }
            else
            {
                Name = targetInfo.Name;
            }
            Class'NWindow.UIAPI_TEXTBOX'.static.SetText("TradeWnd.Targetname", Name);
        }
        itemWindowRect = GetItemWindowHandle("TradeWnd.InventoryList").GetRect();
        GetTextBoxHandle("TradeWnd.Targetname").SetTextEllipsisWidth(itemWindowRect.nWidth);
        GetTextBoxHandle("TradeWnd.Targetname").SetTooltipType("Text");
        GetTextBoxHandle("TradeWnd.Targetname").SetTooltipText((Name $ addStr) $ ClanName);
        // End:0x347
        if(((((isFriend != 0) || isPledge != 0) || isMentoring != 0) || isAlliance != 0) || isGM != 0)
        {
            colorString = "Green";            
        }
        else
        {
            colorString = "Red";
        }
        SetTooltipString(param);
        levelString = Left(colorString, 1) $ (GetTargetLevelIconIndex(TargetLevel));
        // End:0x39A
        if(isGM != 0)
        {
            levelString = "GM";
            colorString = "Green";
        }
        GetTextureHandle("TradeWnd.ChatLevel").SetTexture("L2UI_CT1.ChatWindow.ChatLevelIcon_" $ levelString);
        GetButtonHandle("TradeWnd.ChatLevelIcon_Btn").SetTexture("L2UI_CT1.ChatWindow.ChatLevelIcon_Btn" $ colorString, ("L2UI_CT1.ChatWindow.ChatLevelIcon_Btn" $ colorString) $ "_down", ("L2UI_CT1.ChatWindow.ChatLevelIcon_Btn" $ colorString) $ "_over");
    }
    return;
}

function SetTooltipString(string param)
{
    local CustomTooltip t;
    local string charName;
    local int isFriend, isGM, isPledge, isAlliance, isMentoring;

    t.MinimumWidth = 125;
    util = L2Util(GetScript("L2Util"));
    util.setCustomTooltip(t);
    ParseString(param, "CharName", charName);
    ParseInt(param, "IsFriend", isFriend);
    ParseInt(param, "IsPledge", isPledge);
    ParseInt(param, "IsMentoring", isMentoring);
    ParseInt(param, "IsAlliance", isAlliance);
    ParseInt(param, "IsGM", isGM);
    // End:0x113
    if(isFriend != 0)
    {
        util.ToopTipInsertTitleContents(GetSystemString(2273), GetSystemString(3175), 77, 255, 99, true, true, true);        
    }
    else
    {
        util.ToopTipInsertTitleContents(GetSystemString(2273), GetSystemString(3176), 255, 66, 66, true, true, true);
    }
    // End:0x17D
    if(isPledge != 0)
    {
        util.ToopTipInsertTitleContents(GetSystemString(314), GetSystemString(3179), 77, 255, 99, true, true, false);        
    }
    else
    {
        util.ToopTipInsertTitleContents(GetSystemString(314), GetSystemString(3180), 255, 66, 66, true, true, false);
    }
    // End:0x1FE
    if((isMentoring != 0) && !getInstanceUIData().getIsClassicServer())
    {
        util.ToopTipInsertTitleContents(GetSystemString(2767), GetSystemString(3177), 77, 255, 99, true, true, false);        
    }
    else
    {
        // End:0x241
        if(!getInstanceUIData().getIsClassicServer())
        {
            util.ToopTipInsertTitleContents(GetSystemString(2767), GetSystemString(3178), 255, 66, 66, true, true, false);
        }
    }
    // End:0x27D
    if(isAlliance != 0)
    {
        util.ToopTipInsertTitleContents(GetSystemString(490), GetSystemString(3181), 77, 255, 99, true, true, false);        
    }
    else
    {
        util.ToopTipInsertTitleContents(GetSystemString(490), GetSystemString(3182), 255, 66, 66, true, true, false);
    }
    GetButtonHandle("TradeWnd.ChatLevelIcon_Btn").SetTooltipCustomType(util.getCustomTooltip());
    return;
}

function string GetTargetLevelIconIndex(int UserLevel)
{
    local int Num;

    Num = UserLevel / 10;
    // End:0x22
    if(Num == 0)
    {
        return "01";        
    }
    else
    {
        return string(Num) $ "0";
    }
    return "01";
    return;
}

function HandleTradeAddItem(string param)
{
    local string strDest;
    local ItemInfo ItemInfo;
    local int Index;

    ParseString(param, "destination", strDest);
    ParamToItemInfo(param, ItemInfo);
    // End:0x67
    if(strDest == "inventoryList")
    {
        strDest = "TradeWnd.InventoryList";        
    }
    else
    {
        // End:0xD1
        if(strDest == "myList")
        {
            strDest = "TradeWnd.MyList";
            Class'NWindow.UIAPI_INVENWEIGHT'.static.ReduceWeight("TradeWnd.InvenWeight", __NFUN_401__(ItemInfo.ItemNum, (ItemInfo.Weight)));            
        }
        else
        {
            // End:0x13E
            if(strDest == "otherList")
            {
                strDest = "TradeWnd.OtherList";
                Class'NWindow.UIAPI_INVENWEIGHT'.static.AddWeight("TradeWnd.InvenWeight", __NFUN_401__(ItemInfo.ItemNum, (ItemInfo.Weight)));
            }
        }
    }
    Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem(strDest, ItemInfo.Id);
    // End:0x1A1
    if(Index >= 0)
    {
        // End:0x19E
        if(IsStackableItem(ItemInfo.ConsumeType))
        {
            Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem(strDest, Index, ItemInfo);
        }        
    }
    else
    {
        Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem(strDest, ItemInfo);
    }
    return;
}

function handleTradeDone(string param)
{
    onTradeDone();
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TradeWnd");
    InventoryWnd(GetScript("InventoryWnd")).bFalseOpen = true;
    RequestItemList();
    return;
}

function HandleTradeOtherOK(string param)
{
    Class'NWindow.UIAPI_ITEMWINDOW'.static.SetFaded("TradeWnd.OtherList", true);
    return;
}

function HandleTradeUpdateInventoryItem(string param)
{
    local ItemInfo Info;
    local string Type;
    local int Index;

    ParseString(param, "type", Type);
    ParamToItemInfo(param, Info);
    // End:0x64
    if(Type == "add")
    {
        Class'NWindow.UIAPI_ITEMWINDOW'.static.AddItem("TradeWnd.InventoryList", Info);        
    }
    else
    {
        // End:0xEC
        if(Type == "update")
        {
            Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("TradeWnd.InventoryList", Info.Id);
            // End:0xE9
            if(Index >= 0)
            {
                Class'NWindow.UIAPI_ITEMWINDOW'.static.SetItem("TradeWnd.InventoryList", Index, Info);
            }            
        }
        else
        {
            // End:0x16C
            if(Type == "delete")
            {
                Index = Class'NWindow.UIAPI_ITEMWINDOW'.static.FindItem("TradeWnd.InventoryList", Info.Id);
                // End:0x16C
                if(Index >= 0)
                {
                    Class'NWindow.UIAPI_ITEMWINDOW'.static.DeleteItem("TradeWnd.InventoryList", Index);
                }
            }
        }
    }
    return;
}

function HandleReceiveStartTrade(string param)
{
    local int targetID;
    local UserInfo Info;
    local string Name;
    local bool bOption;

    bOption = GetOptionBool("Communication", "IsRejectingTrade");
    ParseInt(param, "targetID", targetID);
    // End:0x5E
    if(bOption == true)
    {
        AnswerTradeRequest(false);        
    }
    else
    {
        // End:0x13C
        if((targetID > 0) && GetUserInfo(targetID, Info))
        {
            // End:0x9B
            if(IsShowWindow("DialogBox"))
            {
                RequestTradeDone(false);
                return;
            }
            // End:0xCE
            if(Info.WantHideName && Info.JoinedDominionID > 0)
            {
                Name = Info.RealName;                
            }
            else
            {
                Name = Info.Name;
            }
            DialogSetID(323);
            DialogSetCancelD(323);
            DialogSetParamInt64((10 * 1000));
            DialogSetEnterDoNothing();
            DialogShow(1, 7, MakeFullSystemMsg(GetSystemMessage(100), Name, ""), string(self));
            Class'NWindow.FlashWindowAPI'.static.FlashWindow();
        }
    }
    return;
}

function HandleDialogOK()
{
    local ItemID sID;
    local INT64 Num;

    // End:0x5D
    if(DialogIsMine())
    {
        // End:0x23
        if((DialogGetID()) == 323)
        {
            AnswerTradeRequest(true);            
        }
        else
        {
            // End:0x5D
            if((DialogGetID()) == 324)
            {
                sID = DialogGetReservedItemID();
                Num = (DialogGetString());
                RequestAddTradeItem(sID, Num);
            }
        }
    }
    return;
}

function HandleDialogCancel()
{
    // End:0x1E
    if(DialogIsMine())
    {
        // End:0x1E
        if(DialogCheckCancelByID(323))
        {
            AnswerTradeRequest(false);
        }
    }
    return;
}

function Clear()
{
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("TradeWnd.InventoryList");
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("TradeWnd.MyList");
    Class'NWindow.UIAPI_ITEMWINDOW'.static.Clear("TradeWnd.OtherList");
    Class'NWindow.UIAPI_TEXTBOX'.static.SetText("TradeWnd.TargetName", "");
    Class'NWindow.UIAPI_INVENWEIGHT'.static.ZeroWeight("TradeWnd.InvenWeight");
    DialogHide();
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    AnswerTradeRequest(false);
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow(m_WindowName);
    return;
}

delegate onTradeDone()
{
    return;
}

defaultproperties
{
    m_WindowName="TradeWnd"
}