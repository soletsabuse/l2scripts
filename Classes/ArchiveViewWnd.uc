class ArchiveViewWnd extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = -50;
const cuttingCriteria = 1000000000;
const cuttingCriteriaCipher = 9;

var int currentScreenWidth;
var int currentScreenHeight;
var bool isFlashLoaded;
var int preloadedPledgeID;
var int preloadedCrestID;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    RegisterState("ArchiveViewWnd", "GamingState");
    SetClosingOnESC();
    isFlashLoaded = false;
    return;
}

function OnShow()
{
    PlayConsoleSound(15);
    return;
}

function OnHide()
{
    PlayConsoleSound(16);
    dispatchEventToFlash_String(11, "");
    return;
}

function dispatchEventToFlash_String(int Event_ID, string argString)
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    AllocGFxValues(args, 2);
    AllocGFxValue(invokeResult);
    args[0].SetInt(Event_ID);
    CreateObject(args[1]);
    args[1].SetMemberString("string", argString);
    Invoke("_root.onEvent", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function OnFlashLoaded()
{
    local array<GFxValue> args;
    local GFxValue invokeResult;
    local float xLoc, yLoc;

    RegisterDelegateHandler(5);
    setTableContent(Class'NWindow.StatisticAPI'.static.GetTableOfContent());
    beforeFlashLoadedEvent();
    isFlashLoaded = true;
    // End:0x3D
    if(IsSavedInfo())
    {
        SetGFxFromSavedInfo();        
    }
    else
    {
        AllocGFxValues(args, 2);
        AllocGFxValue(invokeResult);
        GetAnchorPointFromWindow(xLoc, yLoc, 5);
        args[0].SetInt(int(xLoc) + 0);
        args[1].SetInt(int(yLoc) + -50);
        Invoke("_root.onMove", args, invokeResult);
        DeallocGFxValue(invokeResult);
        DeallocGFxValues(args);
    }
    return;
}

function beforeFlashLoadedEvent()
{
    return;
}

function OnDefaultPosition()
{
    return;
}

function OnCallUCLogic(int logicID, string param)
{
    return;
}

function OnFocus(bool bFlag, bool bTransparency)
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    AllocGFxValues(args, 2);
    args[0].SetBool(bFlag);
    args[1].SetBool(bTransparency);
    AllocGFxValue(invokeResult);
    Invoke("_root.onFocus", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function setTableContent(string param)
{
    local UserInfo UserInfo;
    local int i, j, k, depth2Max, depth3Max, tmpSize0,
	    tmpID1;

    local string tmpName1;
    local int tmpSize1, tmpID2;
    local string tmpName2;
    local int tmpSize2, tmpID3;
    local string tmpName3;
    local int tmpSize3;
    local array<GFxValue> args;
    local GFxValue invokeResult, argArray_1, argArray_2, argArray_3, ArrayElem;

    AllocGFxValues(args, 2);
    AllocGFxValue(argArray_1);
    AllocGFxValue(argArray_2);
    AllocGFxValue(argArray_3);
    AllocGFxValue(invokeResult);
    AllocGFxValue(ArrayElem);
    args[0].SetInt(4);
    CreateObject(args[1]);
    CreateArray(argArray_1);
    CreateArray(argArray_2);
    CreateArray(argArray_3);
    depth2Max = 0;
    depth3Max = 0;
    ParseInt(param, "Content_Size", tmpSize0);
    args[1].SetMemberInt("depth0Size", tmpSize0);
    GetPlayerInfo(UserInfo);
    args[1].SetMemberString("userName", UserInfo.Name);
    i = 0;
    J0x10A:

    // End:0x4E9 [Loop If]
    if(i < tmpSize0)
    {
        CreateObject(ArrayElem);
        ParseInt(param, ("Content_" $ string(i)) $ "_ID", tmpID1);
        ParseString(param, ("Content_" $ string(i)) $ "_Name", tmpName1);
        ParseInt(param, ("Content_" $ string(i)) $ "_Size", tmpSize1);
        ArrayElem.SetMemberInt("ID", tmpID1);
        ArrayElem.SetMemberString("name", tmpName1);
        ArrayElem.SetMemberInt("size", tmpSize1);
        argArray_1.SetElement(i, ArrayElem);
        j = 0;
        J0x212:

        // End:0x4CD [Loop If]
        if(j < tmpSize1)
        {
            CreateObject(ArrayElem);
            ParseInt(param, ((("Content_" $ string(i)) $ "_") $ string(j)) $ "_ID", tmpID2);
            ParseString(param, ((("Content_" $ string(i)) $ "_") $ string(j)) $ "_Name", tmpName2);
            ParseInt(param, ((("Content_" $ string(i)) $ "_") $ string(j)) $ "_Size", tmpSize2);
            ArrayElem.SetMemberInt("ID", tmpID2);
            ArrayElem.SetMemberString("name", tmpName2);
            ArrayElem.SetMemberInt("size", tmpSize2);
            argArray_2.SetElement(depth2Max + j, ArrayElem);
            k = 0;
            J0x34B:

            // End:0x4B1 [Loop If]
            if(k < tmpSize2)
            {
                CreateObject(ArrayElem);
                ParseInt(param, ((((("Content_" $ string(i)) $ "_") $ string(j)) $ "_") $ string(k)) $ "_ID", tmpID3);
                ParseString(param, ((((("Content_" $ string(i)) $ "_") $ string(j)) $ "_") $ string(k)) $ "_Name", tmpName3);
                ParseInt(param, ((((("Content_" $ string(i)) $ "_") $ string(j)) $ "_") $ string(k)) $ "_Size", tmpSize3);
                ArrayElem.SetMemberInt("ID", tmpID3);
                ArrayElem.SetMemberString("name", tmpName3);
                ArrayElem.SetMemberInt("size", tmpSize3);
                argArray_3.SetElement(depth3Max + k, ArrayElem);
                k++;
                // [Loop Continue]
                goto J0x34B;
            }
            depth3Max = depth3Max + tmpSize2;
            j++;
            // [Loop Continue]
            goto J0x212;
        }
        depth2Max = depth2Max + tmpSize1;
        i++;
        // [Loop Continue]
        goto J0x10A;
    }
    args[1].SetMemberValue("depth1ListArray", argArray_1);
    args[1].SetMemberValue("depth2ListArray", argArray_2);
    args[1].SetMemberValue("depth3ListArray", argArray_3);
    Invoke("_root.onEvent", args, invokeResult);
    DeallocGFxValue(argArray_1);
    DeallocGFxValue(argArray_2);
    DeallocGFxValue(argArray_3);
    DeallocGFxValue(ArrayElem);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int i, Id;
    local UIEventManager.EStatisticUnitType Type;
    local int tmpSize;
    local string tmpName;
    local INT64 tmpValue, tmpValue2;
    local int tmpDiff, tmpPledgeID, tmpPledgeCrestID, ZeroInvisible;
    local string Unit;
    local int UnitType;
    local string content;
    local UserInfo UserInfo;
    local GFxValue argArray_Month, argArray_Total, argArray_Record;
    local array<GFxValue> args;
    local GFxValue invokeResult, ArrayElem;

    // End:0xAC
    if(Event_ID == 150)
    {
        AllocGFxValues(args, 2);
        AllocGFxValue(invokeResult);
        args[0].SetInt(2);
        CreateObject(args[1]);
        GetPlayerInfo(UserInfo);
        args[1].SetMemberString("userName", UserInfo.Name);
        Invoke("_root.onEvent", args, invokeResult);
        DeallocGFxValue(invokeResult);
        DeallocGFxValues(args);        
    }
    else
    {
        // End:0x11B
        if(Event_ID == 40)
        {
            AllocGFxValues(args, 2);
            AllocGFxValue(invokeResult);
            args[0].SetInt(3);
            Invoke("_root.onEvent", args, invokeResult);
            DeallocGFxValue(invokeResult);
            DeallocGFxValues(args);            
        }
        else
        {
            // End:0x148
            if(Event_ID == 5590)
            {
                // End:0x13F
                if(IsShowWindow() == false)
                {
                    ShowWindow();                    
                }
                else
                {
                    HideWindow();
                }                
            }
            else
            {
                // End:0x76B
                if(Event_ID == 5594)
                {
                    AllocGFxValues(args, 2);
                    AllocGFxValue(argArray_Month);
                    AllocGFxValue(argArray_Total);
                    AllocGFxValue(invokeResult);
                    AllocGFxValue(ArrayElem);
                    args[0].SetInt(5);
                    CreateObject(args[1]);
                    CreateArray(argArray_Month);
                    CreateArray(argArray_Total);
                    ParseInt(param, "ID", Id);
                    ParseInt(Class'NWindow.StatisticAPI'.static.GetContentInfo(Id), "UnitType", UnitType);
                    Type = byte(UnitType);
                    // End:0x25A
                    if((int(Type) == int(0)) || int(Type) == int(4))
                    {
                        ParseString(Class'NWindow.StatisticAPI'.static.GetContentInfo(Id), "Unit", Unit);                        
                    }
                    else
                    {
                        Unit = "";
                    }
                    args[1].SetMemberString("Unit", Unit);
                    ParseInt(param, "SizeOfMonth", tmpSize);
                    args[1].SetMemberInt("SizeOfMonth", tmpSize);
                    i = 0;
                    J0x2C5:

                    // End:0x4A5 [Loop If]
                    if(i < tmpSize)
                    {
                        CreateObject(ArrayElem);
                        ParseString(param, "MonthName_" $ string(i), tmpName);
                        ParseINT64(param, "MonthValue_" $ string(i), tmpValue);
                        ParseInt(param, "MonthDiff_" $ string(i), tmpDiff);
                        ParseInt(param, "MonthPledgeID_" $ string(i), tmpPledgeID);
                        ParseInt(param, "MonthPledgeCrestID_" $ string(i), tmpPledgeCrestID);
                        ArrayElem.SetMemberString("name", tmpName);
                        // End:0x406
                        if((int(Type) == int(0)) || int(Type) == int(4))
                        {
                            ArrayElem.SetMemberString("value", valueNumToStr(tmpValue));                            
                        }
                        else
                        {
                            ArrayElem.SetMemberString("value", setTimeString(tmpValue));
                        }
                        ArrayElem.SetMemberInt("diff", tmpDiff);
                        ArrayElem.SetMemberInt("pledgeID", tmpPledgeID);
                        ArrayElem.SetMemberInt("pledgeCrestID", tmpPledgeCrestID);
                        argArray_Month.SetElement(i, ArrayElem);
                        i++;
                        // [Loop Continue]
                        goto J0x2C5;
                    }
                    ParseInt(param, "SizeOfTotal", tmpSize);
                    args[1].SetMemberInt("SizeOfTotal", tmpSize);
                    i = 0;
                    J0x4EC:

                    // End:0x6CC [Loop If]
                    if(i < tmpSize)
                    {
                        CreateObject(ArrayElem);
                        ParseString(param, "TotalName_" $ string(i), tmpName);
                        ParseINT64(param, "TotalValue_" $ string(i), tmpValue);
                        ParseInt(param, "TotalDiff_" $ string(i), tmpDiff);
                        ParseInt(param, "TotalPledgeID_" $ string(i), tmpPledgeID);
                        ParseInt(param, "TotalPledgeCrestID_" $ string(i), tmpPledgeCrestID);
                        ArrayElem.SetMemberString("name", tmpName);
                        // End:0x62D
                        if((int(Type) == int(0)) || int(Type) == int(4))
                        {
                            ArrayElem.SetMemberString("value", valueNumToStr(tmpValue));                            
                        }
                        else
                        {
                            ArrayElem.SetMemberString("value", setTimeString(tmpValue));
                        }
                        ArrayElem.SetMemberInt("diff", tmpDiff);
                        ArrayElem.SetMemberInt("pledgeID", tmpPledgeID);
                        ArrayElem.SetMemberInt("pledgeCrestID", tmpPledgeCrestID);
                        argArray_Total.SetElement(i, ArrayElem);
                        i++;
                        // [Loop Continue]
                        goto J0x4EC;
                    }
                    args[1].SetMemberValue("array_Total", argArray_Total);
                    args[1].SetMemberValue("array_Month", argArray_Month);
                    Invoke("_root.onEvent", args, invokeResult);
                    DeallocGFxValue(argArray_Month);
                    DeallocGFxValue(argArray_Total);
                    DeallocGFxValue(ArrayElem);
                    DeallocGFxValue(invokeResult);
                    DeallocGFxValues(args);                    
                }
                else
                {
                    // End:0xB33
                    if(Event_ID == 5595)
                    {
                        AllocGFxValues(args, 2);
                        AllocGFxValue(argArray_Record);
                        AllocGFxValue(invokeResult);
                        AllocGFxValue(ArrayElem);
                        args[0].SetInt(6);
                        CreateObject(args[1]);
                        CreateArray(argArray_Record);
                        GetPlayerInfo(UserInfo);
                        args[1].SetMemberString("userName", UserInfo.Name);
                        ParseInt(param, "SizeOfRecord", tmpSize);
                        args[1].SetMemberInt("SizeOfRecord", tmpSize);
                        i = 0;
                        J0x84C:

                        // End:0xAC4 [Loop If]
                        if(i < tmpSize)
                        {
                            CreateObject(ArrayElem);
                            ParseInt(param, "ID_" $ string(i), Id);
                            content = Class'NWindow.StatisticAPI'.static.GetContentInfo(Id);
                            ParseInt(content, "UnitType", UnitType);
                            Type = byte(UnitType);
                            // End:0x900
                            if((int(Type) == int(0)) || int(Type) == int(4))
                            {
                                ParseString(content, "Unit", Unit);                                
                            }
                            else
                            {
                                Unit = "";
                            }
                            ParseInt(content, "ZeroInvisible", ZeroInvisible);
                            tmpName = Class'NWindow.StatisticAPI'.static.GetTitleNameOfStatistic(Id);
                            ParseINT64(param, "MonthValue_" $ string(i), tmpValue);
                            ParseINT64(param, "TotalValue_" $ string(i), tmpValue2);
                            ArrayElem.SetMemberString("Unit", Unit);
                            ArrayElem.SetMemberString("name", tmpName);
                            // End:0xA32
                            if((int(Type) == int(0)) || int(Type) == int(4))
                            {
                                ArrayElem.SetMemberString("MonthValue", valueNumToStr(tmpValue));
                                ArrayElem.SetMemberString("TotalValue", valueNumToStr(tmpValue2));                                
                            }
                            else
                            {
                                ArrayElem.SetMemberString("MonthValue", setTimeString(tmpValue));
                                ArrayElem.SetMemberString("TotalValue", setTimeString(tmpValue2));
                            }
                            ArrayElem.SetMemberInt("ZeroInvisible", ZeroInvisible);
                            argArray_Record.SetElement(i, ArrayElem);
                            i++;
                            // [Loop Continue]
                            goto J0x84C;
                        }
                        args[1].SetMemberValue("array_Record", argArray_Record);
                        Invoke("_root.onEvent", args, invokeResult);
                        DeallocGFxValue(argArray_Record);
                        DeallocGFxValue(ArrayElem);
                        DeallocGFxValue(invokeResult);
                        DeallocGFxValues(args);
                    }
                }
            }
        }
    }
    // End:0xC43
    if(Event_ID == 9220)
    {
        ParseInt(param, "PledgeID", tmpPledgeID);
        ParseInt(param, "CrestID", tmpPledgeCrestID);
        // End:0xC2D
        if(isFlashLoaded)
        {
            AllocGFxValues(args, 2);
            AllocGFxValue(invokeResult);
            args[0].SetInt(10);
            CreateObject(args[1]);
            args[1].SetMemberInt("PledgeID", tmpPledgeID);
            args[1].SetMemberInt("CrestID", tmpPledgeCrestID);
            Invoke("_root.onEvent", args, invokeResult);
            DeallocGFxValue(invokeResult);
            DeallocGFxValues(args);            
        }
        else
        {
            preloadedPledgeID = tmpPledgeID;
            preloadedCrestID = tmpPledgeCrestID;
        }
    }
    return;
}

function string valueNumToStr(INT64 tmpValue)
{
    local string returnStr;

    // End:0x3E
    if(__NFUN_409__(tmpValue, (0)))
    {
        returnStr = getValueCuttingCriteria(tmpValue, (1000000000), 0);
        returnStr = ConvertNumToTextNoAdena(returnStr);
        return returnStr;
    }
    return "0";
    return;
}

function string getValueCuttingCriteria(INT64 tmpValue, INT64 criteria, int Num)
{
    // End:0x10
    if(Num > 5)
    {
        return "0";
    }
    // End:0x46
    if(__NFUN_409__(tmpValue, criteria))
    {
        return getValueCuttingCriteria(tmpValue, __NFUN_401__(criteria, (1000000000)), Num + 1);        
    }
    else
    {
        return CeilingNum((tmpValue), 9 * Num);
    }
    return;
}

function string setTimeString(INT64 tmpTime)
{
    local INT64 tmpDay, tmpHou, tmpMin;
    local string timeStr;
    local int minToHou, minToDay;

    minToHou = 60;
    minToDay = minToHou * 24;
    tmpMin = __NFUN_403__(tmpTime, (60));
    // End:0xDC
    if(__NFUN_409__(tmpMin, (minToDay)))
    {
        tmpHou = __NFUN_403__(tmpMin, (60));
        tmpDay = __NFUN_403__(tmpHou, (24));
        tmpHou = __NFUN_405__(tmpHou, __NFUN_401__(tmpDay, (24)));
        // End:0xB5
        if(__NFUN_413__(tmpHou, (0)))
        {
            timeStr = MakeFullSystemMsg(GetSystemMessage(3503), MakeCostString((tmpDay)), (tmpHou));            
        }
        else
        {
            timeStr = MakeFullSystemMsg(GetSystemMessage(3418), MakeCostString((tmpDay)));
        }        
    }
    else
    {
        // End:0x16E
        if(__NFUN_409__(tmpMin, (60)))
        {
            tmpHou = __NFUN_403__(tmpMin, (60));
            tmpMin = __NFUN_405__(tmpMin, __NFUN_401__(tmpHou, (60)));
            // End:0x14D
            if(__NFUN_413__(tmpMin, (0)))
            {
                timeStr = MakeFullSystemMsg(GetSystemMessage(3304), (tmpHou), (tmpMin));                
            }
            else
            {
                timeStr = MakeFullSystemMsg(GetSystemMessage(3406), (tmpHou));
            }            
        }
        else
        {
            timeStr = MakeFullSystemMsg(GetSystemMessage(3390), (tmpMin));
        }
    }
    return timeStr;
    return;
}

function OnReceivedCloseUI()
{
    local array<GFxValue> args;
    local GFxValue invokeResult;

    AllocGFxValues(args, 1);
    Invoke("_root.onReceivedCloseUI", args, invokeResult);
    DeallocGFxValue(invokeResult);
    DeallocGFxValues(args);
    return;
}
