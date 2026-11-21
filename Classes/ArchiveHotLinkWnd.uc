class ArchiveHotLinkWnd extends GFxUIScript;

const FLASH_XPOS = 0;
const FLASH_YPOS = -50;
const cuttingCriteria = 1000000000;
const cuttingCriteriaCipher = 9;

var int currentScreenWidth;
var int currentScreenHeight;

function OnRegisterEvent()
{
    RegisterEvent(5591);
    return;
}

function OnLoad()
{
    RegisterState("ArchiveHotLinkWnd", "GamingState");
    SetClosingOnESC();
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
    // End:0x1A
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

function OnEvent(int Event_ID, string param)
{
    local UserInfo UserInfo;
    local int Id;
    local string Title, Unit;
    local int UnitType;
    local UIEventManager.EStatisticUnitType Type;
    local int m_arrow;
    local string m_name;
    local INT64 m_number;
    local int tmpPledgeID, tmpPledgeCrestID;
    local string content;
    local int i, totalNum;
    local array<GFxValue> args;
    local GFxValue invokeResult, argArray_m, argArray_t, ArrayElem;

    // End:0x66F
    if(Event_ID == 5591)
    {
        // End:0x21
        if(IsShowWindow() == false)
        {
            ShowWindow();
        }
        AllocGFxValues(args, 2);
        AllocGFxValue(argArray_m);
        AllocGFxValue(argArray_t);
        AllocGFxValue(invokeResult);
        AllocGFxValue(ArrayElem);
        args[0].SetInt(4);
        CreateObject(args[1]);
        CreateArray(argArray_m);
        CreateArray(argArray_t);
        ParseInt(param, "ID", Id);
        content = Class'NWindow.StatisticAPI'.static.GetContentInfo(Id);
        ParseInt(content, "UnitType", UnitType);
        Type = byte(UnitType);
        // End:0x120
        if((int(Type) == int(0)) || int(Type) == int(4))
        {
            ParseString(content, "Unit", Unit);            
        }
        else
        {
            Unit = "";
        }
        ParseString(content, "Name", Title);
        args[1].SetMemberString("title", Title);
        args[1].SetMemberString("Unit", Unit);
        GetPlayerInfo(UserInfo);
        args[1].SetMemberString("userName", UserInfo.Name);
        ParseInt(param, "SizeOfMonth", totalNum);
        i = 0;
        J0x1CB:

        // End:0x3B8 [Loop If]
        if(i < totalNum)
        {
            CreateObject(ArrayElem);
            ParseString(param, "MonthName_" $ string(i), m_name);
            ArrayElem.SetMemberString("pcName", m_name);
            ParseINT64(param, "MonthValue_" $ string(i), m_number);
            // End:0x297
            if((int(Type) == int(0)) || int(Type) == int(4))
            {
                ArrayElem.SetMemberString("numberdata", valueNumToStr(m_number));                
            }
            else
            {
                ArrayElem.SetMemberString("numberdata", setTimeString(m_number));
            }
            ParseInt(param, "MonthDiff_" $ string(i), m_arrow);
            ArrayElem.SetMemberInt("arrow", m_arrow);
            ParseInt(param, "MonthPledgeID_" $ string(i), tmpPledgeID);
            ArrayElem.SetMemberInt("pledgeID", tmpPledgeID);
            ParseInt(param, "MonthPledgeCrestID_" $ string(i), tmpPledgeCrestID);
            ArrayElem.SetMemberInt("pledgeCrestID", tmpPledgeCrestID);
            argArray_m.SetElement(i, ArrayElem);
            i++;
            // [Loop Continue]
            goto J0x1CB;
        }
        args[1].SetMemberValue("resultListArray1", argArray_m);
        ParseInt(param, "SizeOfTotal", totalNum);
        i = 0;
        J0x404:

        // End:0x5F1 [Loop If]
        if(i < totalNum)
        {
            CreateObject(ArrayElem);
            ParseString(param, "TotalName_" $ string(i), m_name);
            ArrayElem.SetMemberString("pcName", m_name);
            ParseINT64(param, "TotalValue_" $ string(i), m_number);
            // End:0x4D0
            if((int(Type) == int(0)) || int(Type) == int(4))
            {
                ArrayElem.SetMemberString("numberdata", valueNumToStr(m_number));                
            }
            else
            {
                ArrayElem.SetMemberString("numberdata", setTimeString(m_number));
            }
            ParseInt(param, "TotalDiff_" $ string(i), m_arrow);
            ArrayElem.SetMemberInt("arrow", m_arrow);
            ParseInt(param, "TotalPledgeID_" $ string(i), tmpPledgeID);
            ArrayElem.SetMemberInt("pledgeID", tmpPledgeID);
            ParseInt(param, "TotalPledgeCrestID_" $ string(i), tmpPledgeCrestID);
            ArrayElem.SetMemberInt("pledgeCrestID", tmpPledgeCrestID);
            argArray_t.SetElement(i, ArrayElem);
            i++;
            // [Loop Continue]
            goto J0x404;
        }
        args[1].SetMemberValue("resultListArray2", argArray_t);
        Invoke("_root.onEvent", args, invokeResult);
        DeallocGFxValue(argArray_m);
        DeallocGFxValue(argArray_t);
        DeallocGFxValue(ArrayElem);
        DeallocGFxValue(invokeResult);
        DeallocGFxValues(args);
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

function bool bFlag(int nflag)
{
    // End:0x10
    if(nflag > 0)
    {
        return true;        
    }
    else
    {
        return false;
    }
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
