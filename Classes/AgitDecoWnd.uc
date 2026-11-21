class AgitDecoWnd extends UICommonAPI;

const POWER_ENVOY_TYPE = 1000;
const TOP_MARGIN = 7;
const MAX_SLOT = 5;

struct AgitDecoSlotData
{
    var int SlotNum;
    var int DecoNpcId;
    var int NpcType;
    var int FactionType;
    var bool bResponseAvailability;
};

var WindowHandle Me;
var ButtonHandle Close_Button;
var WindowHandle AgitSlot_Scroll;
var WindowHandle AgitSlot1;
var WindowHandle AgitSlot2;
var WindowHandle AgitSlot3;
var WindowHandle AgitSlot4;
var WindowHandle AgitSlot5;
var int nUseSlotNum;
var int nCurrentSlotNum;
var int nAgitID;
var array<int> domainArray;
var int domainGrade;
var int currentDecoNPCId;
var AgitDecoDrawerWnd AgitDecoDrawerWndScript;
var array<AgitDecoSlotData> agitDecoSlotDataArray;

function OnRegisterEvent()
{
    RegisterEvent(10100);
    RegisterEvent(10110);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function OnHide()
{
    nCurrentSlotNum = -1;
    nAgitID = -1;
    agitDecoSlotDataArray.Length = 0;
    GetWindowHandle("AgitDecoDrawerWnd").HideWindow();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("AgitDecoWnd");
    Close_Button = GetButtonHandle("AgitDecoWnd.Close_Button");
    AgitSlot_Scroll = GetWindowHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot_Scroll");
    AgitSlot1 = GetWindowHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot1");
    AgitSlot2 = GetWindowHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot2");
    AgitSlot3 = GetWindowHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot3");
    AgitSlot4 = GetWindowHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot4");
    AgitSlot5 = GetWindowHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot5");
    agitDecoSlotDataArray.Length = 0;
    AgitDecoDrawerWndScript = AgitDecoDrawerWnd(GetScript("AgitDecoDrawerWnd"));
    hideAllSelect();
    return;
}

function initWindowLoc()
{
    local int i, nWndWidth, nWndHeight;

    i = 1;
    J0x07:

    // End:0x59 [Loop If]
    if(i <= 5)
    {
        // End:0x3A
        if(i <= nUseSlotNum)
        {
            getAgitSlotWnd(i).ShowWindow();
            // [Explicit Continue]
            goto J0x4F;
        }
        getAgitSlotWnd(i).HideWindow();
        J0x4F:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    i = 2;
    J0x61:

    // End:0x11B [Loop If]
    if(i <= nUseSlotNum)
    {
        getAgitSlotWnd(i - 1).GetWindowSize(nWndWidth, nWndHeight);
        getAgitSlotWnd(i).ClearAnchor();
        getAgitSlotWnd(i).SetAnchor("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(i - 1), "BottomCenter", "TopCenter", 0, 7);
        i++;
        // [Loop Continue]
        goto J0x61;
    }
    getAgitSlotWnd(nUseSlotNum - 1).GetWindowSize(nWndWidth, nWndHeight);
    AgitSlot_Scroll.SetScrollHeight((nWndHeight + 7) * nUseSlotNum);
    return;
}

function WindowHandle getAgitSlotWnd(int i)
{
    return GetWindowHandle("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(i));
    return;
}

function setSelectSlot(int Index, bool flag)
{
    // End:0x164
    if(flag)
    {
        GetTextureHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "_Selectbox_texture").ShowWindow();
        GetWindowHandle("AgitDecoDrawerWnd").ShowWindow();
        GetWindowHandle("AgitDecoDrawerWnd").SetFocus();
        GetTextBoxHandle("AgitDecoDrawerWnd.Title_Faction_text").SetText(GetTextBoxHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "Title_text").GetText());        
    }
    else
    {
        GetTextureHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "_Selectbox_texture").HideWindow();
    }
    nCurrentSlotNum = Index - 1;
    return;
}

function hideAllSelect()
{
    local int i;

    i = 1;
    J0x07:

    // End:0x29 [Loop If]
    if(i <= 5)
    {
        setSelectSlot(i, false);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function setAgitSlotPropert(int Index, string Title, string NpcName, string npcDesc, int remainingPeriodSec)
{
    local int dotWidth, dotHeight;

    Debug("-----------------------------------------");
    Debug("index:" @ string(Index));
    Debug("title:" @ Title);
    Debug("npcName:" @ NpcName);
    Debug("npcDesc:" @ npcDesc);
    Debug("remainingPeriodSec:" @ string(remainingPeriodSec));
    GetTextBoxHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "Title_text").SetText(Title);
    GetTextBoxHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "NPCname_text").SetText(NpcName);
    GetTextSize(npcDesc, "GameDefault", dotWidth, dotHeight);
    // End:0x336
    if(dotWidth > 185)
    {
        GetTextBoxHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "_ItemContents_text").SetText(makeShortStringByPixel(npcDesc, 186, ".."));
        GetButtonHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "_MouseOverButton").SetTooltipType("text");
        GetButtonHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "_MouseOverButton").SetTooltipCustomType(MakeTooltipSimpleText(npcDesc, 200));        
    }
    else
    {
        GetTextBoxHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "_ItemContents_text").SetText(npcDesc);
        GetButtonHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "_MouseOverButton").ClearTooltip();
    }
    // End:0x4AC
    if(remainingPeriodSec >= 0)
    {
        GetTextBoxHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "_ItemDateContents_text").SetText(getStringDayAndTime(remainingPeriodSec));        
    }
    else
    {
        GetTextBoxHandle(((("AgitDecoWnd.AgitSlot_ScrollAreaWnd.AgitSlot" $ string(Index)) $ ".AgitSlot") $ string(Index)) $ "_ItemDateContents_text").SetText(GetSystemString(27));
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x1D
    if(Event_ID == 10100)
    {
        sendAgitFuncInfoHandler(param);        
    }
    else
    {
        // End:0x37
        if(Event_ID == 10110)
        {
            ResponseDecoNPCAvalabilityHandler(param);
        }
    }
    return;
}

function ResponseDecoNPCAvalabilityHandler(string param)
{
    local int Result;

    ParseInt(param, "Result", Result);
    Debug("°á°ú ---> ResponseDecoNPCAvalability param : " @ param);
    // End:0x73
    if(Result == 0)
    {
        Class'NWindow.UIDATA_AGIT'.static.RequestOpenDecoNPC(nAgitID);
    }
    return;
}

function string getSlotName(int SlotNum)
{
    local string slotName;

    // End:0x1F
    if(SlotNum == 0)
    {
        slotName = GetSystemString(3432);        
    }
    else
    {
        slotName = (GetSystemString(3447) $ " ") $ string(SlotNum);
    }
    return slotName;
    return;
}

function sendAgitFuncInfoHandler(string param)
{
    local int totalCnt, SlotNum, SubType, remainingPeriodSec, FactionType, DecoNpcId,
	    NpcType;

    local string npcDesc, npcStr;
    local int domainCnt, domainValue, i, Level;
    local L2FactionUIData FactionData;

    Debug("sendAgitFuncInfoHandler Param: " @ param);
    ParseInt(param, "AgitID", nAgitID);
    ParseInt(param, "TotalCnt", totalCnt);
    // End:0x74
    if(totalCnt <= -1)
    {
        return;        
    }
    else
    {
        // End:0x97
        if(!Me.IsShowWindow())
        {
            Me.ShowWindow();
        }
    }
    GetWindowHandle("AgitDecoDrawerWnd").HideWindow();
    ParseInt(param, "Grade", domainGrade);
    ParseInt(param, "DomainCnt", domainCnt);
    agitDecoSlotDataArray.Length = 0;
    domainArray.Length = 0;
    hideAllSelect();
    i = 0;
    J0x109:

    // End:0x162 [Loop If]
    if(i < domainCnt)
    {
        ParseInt(param, "Domain_" $ string(i), domainValue);
        domainArray.Insert(domainArray.Length, 1);
        domainArray[i] = domainValue;
        i++;
        // [Loop Continue]
        goto J0x109;
    }
    nUseSlotNum = totalCnt;
    initWindowLoc();
    i = 0;
    J0x17A:

    // End:0x452 [Loop If]
    if(i < totalCnt)
    {
        NpcType = 0;
        ParseInt(param, "SlotNum_" $ string(i), SlotNum);
        ParseInt(param, "SubType_" $ string(i), SubType);
        ParseInt(param, "RemainingPeriod_" $ string(i), remainingPeriodSec);
        ParseInt(param, "FactionType_" $ string(i), FactionType);
        ParseInt(param, "DecoNPCId_" $ string(i), DecoNpcId);
        ParseInt(param, "Level_" $ string(i), Level);
        ParseInt(param, "NPCType_" $ string(i), NpcType);
        ParseString(param, "Desc_" $ string(i), npcDesc);
        agitDecoSlotDataArray.Insert(agitDecoSlotDataArray.Length, 1);
        agitDecoSlotDataArray[i].SlotNum = i;
        // End:0x2F5
        if(DecoNpcId > 0)
        {
            agitDecoSlotDataArray[i].bResponseAvailability = true;            
        }
        else
        {
            agitDecoSlotDataArray[i].bResponseAvailability = false;
        }
        agitDecoSlotDataArray[i].DecoNpcId = DecoNpcId;
        agitDecoSlotDataArray[i].FactionType = FactionType;
        // End:0x358
        if(SlotNum == 0)
        {
            agitDecoSlotDataArray[i].NpcType = 1000;            
        }
        else
        {
            agitDecoSlotDataArray[i].NpcType = NpcType;
        }
        // End:0x3C3
        if(FactionType > 0)
        {
            GetFactionData(FactionType, FactionData);
            npcStr = (((("Lv." $ string(Level)) $ " ") $ FactionData.strFactionName) $ "-") $ GetSystemString(SubType);            
        }
        else
        {
            npcStr = ("Lv." $ string(Level)) $ GetSystemString(SubType);
        }
        // End:0x41A
        if(DecoNpcId > 0)
        {
            setAgitSlotPropert(SlotNum + 1, getSlotName(SlotNum), npcStr, npcDesc, remainingPeriodSec);
            // [Explicit Continue]
            goto J0x448;
        }
        setAgitSlotPropert(SlotNum + 1, getSlotName(SlotNum), GetSystemString(27), GetSystemString(27), -1);
        J0x448:

        i++;
        // [Loop Continue]
        goto J0x17A;
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x21
        case "Close_Button":
            OnClose_ButtonClick();
            // End:0x17C
            break;
        // End:0x65
        case "AgitSlot1_MouseOverButton":
            hideAllSelect();
            setSelectSlot(1, true);
            AgitDecoDrawerWndScript.updateComboAndList(getCurrentNpcType());
            // End:0x17C
            break;
        // End:0xAA
        case "AgitSlot2_MouseOverButton":
            hideAllSelect();
            setSelectSlot(2, true);
            AgitDecoDrawerWndScript.updateComboAndList(getCurrentNpcType());
            // End:0x17C
            break;
        // End:0xEF
        case "AgitSlot3_MouseOverButton":
            hideAllSelect();
            setSelectSlot(3, true);
            AgitDecoDrawerWndScript.updateComboAndList(getCurrentNpcType());
            // End:0x17C
            break;
        // End:0x134
        case "AgitSlot4_MouseOverButton":
            hideAllSelect();
            setSelectSlot(4, true);
            AgitDecoDrawerWndScript.updateComboAndList(getCurrentNpcType());
            // End:0x17C
            break;
        // End:0x179
        case "AgitSlot5_MouseOverButton":
            hideAllSelect();
            setSelectSlot(5, true);
            AgitDecoDrawerWndScript.updateComboAndList(getCurrentNpcType());
            // End:0x17C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClose_ButtonClick()
{
    Me.HideWindow();
    return;
}

function int getCurrentSelectedSlotNum()
{
    return nCurrentSlotNum;
    return;
}

function int getCurrentAgitID()
{
    return nAgitID;
    return;
}

function int getDomainGrade()
{
    return domainGrade;
    return;
}

function array<int> getDomainArray()
{
    return domainArray;
    return;
}

function bool getCurrentDeployMentSlotByNpcID(int DecoNpcId)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x57 [Loop If]
    if(i < agitDecoSlotDataArray.Length)
    {
        // End:0x4D
        if(agitDecoSlotDataArray[i].SlotNum == nCurrentSlotNum)
        {
            // End:0x4D
            if(agitDecoSlotDataArray[i].DecoNpcId == DecoNpcId)
            {
                return true;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    return;
}

function int getCurrentFactionTypeBySlotNum(int SlotNum)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x4C [Loop If]
    if(i < agitDecoSlotDataArray.Length)
    {
        // End:0x42
        if(agitDecoSlotDataArray[i].SlotNum == SlotNum)
        {
            return agitDecoSlotDataArray[i].FactionType;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function OnShow()
{
    Me.SetFocus();
    return;
}

function int getCurrentNpcType()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x4C [Loop If]
    if(i < agitDecoSlotDataArray.Length)
    {
        // End:0x42
        if(agitDecoSlotDataArray[i].SlotNum == nCurrentSlotNum)
        {
            return agitDecoSlotDataArray[i].NpcType;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
