class CrystallizationWnd extends UICommonAPI;

const LINE_MAX = 6;

var string m_WindowName;
var WindowHandle Me;
var ItemWindowHandle CrystallizationItem;
var TextBoxHandle CrystallizationItemName;
var WindowHandle CrystallizationGetItemWnd;
var ButtonHandle OKButton;
var ButtonHandle CancelButton;
var ItemInfo tryItemInfo;
var int cHeight;
var int LineCount;
var bool isCrystallizeItem;

function OnRegisterEvent()
{
    RegisterEvent(5140);
    RegisterEvent(5141);
    RegisterEvent(5142);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    PlayConsoleSound(5);
    return;
}

function OnShow()
{
    isCrystallizeItem = false;
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
    return;
}

function OnHide()
{
    // End:0x1F
    if(isCrystallizeItem)
    {
        RequestCrystallizeItem(tryItemInfo.Id, (1));        
    }
    else
    {
        RequestCrystallizeItemCancel();
    }
    return;
}

function Initialize()
{
    Me = GetWindowHandle("CrystallizationWnd");
    CrystallizationItem = GetItemWindowHandle("CrystallizationWnd.CrystallizationItem");
    CrystallizationItemName = GetTextBoxHandle("CrystallizationWnd.CrystallizationItemName");
    CrystallizationGetItemWnd = GetWindowHandle("CrystallizationWnd.CrystallizationGetItemWnd");
    OKButton = GetButtonHandle("CrystallizationWnd.OKButton");
    CancelButton = GetButtonHandle("CrystallizationWnd.CancelButton");
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 5140:
            getCrystalizingEstimation(param);
            // End:0x42
            break;
        // End:0x2E
        case 5141:
            showCrystalizingEstimationList();
            // End:0x42
            break;
        // End:0x3F
        case 5142:
            cancelCystallizeItem();
            // End:0x42
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function SetItemInfo(ItemInfo cItemInfo)
{
    local int lineNum;

    RequestCrystallizeItemCancel();
    tryItemInfo = cItemInfo;
    cHeight = 0;
    LineCount = 0;
    CrystallizationItem.Clear();
    CrystallizationItemName.SetText("");
    lineNum = 1;
    J0x46:

    // End:0x1EF [Loop If]
    if(lineNum <= 6)
    {
        GetItemWindowHandle("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItem0" $ string(lineNum)).Clear();
        GetTextBoxHandle("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemName0" $ string(lineNum)).SetText("");
        GetTextBoxHandle("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemCount0" $ string(lineNum)).SetText("");
        GetTextBoxHandle("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationItemProbability0" $ string(lineNum)).SetText("");
        lineNum++;
        // [Loop Continue]
        goto J0x46;
    }
    return;
}

function getCrystalizingEstimation(string param)
{
    local int nItemID, crystalCnt;
    local float Probability;
    local ItemID cItemID;
    local ItemInfo cItemInfo;

    LineCount++;
    CrystallizationItem.AddItem(tryItemInfo);
    getInstanceL2Util().textBox_setToolTipWithShortString(CrystallizationItemName, tryItemInfo.Name, -4);
    CrystallizationItem.SetSelectedNum(0);
    ParseInt(param, "ItemID", nItemID);
    ParseInt(param, "CrystalCnt", crystalCnt);
    ParseFloat(param, "Probability", Probability);
    cItemID = GetItemID(nItemID);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(cItemID, cItemInfo);
    cItemInfo.ItemNum = (crystalCnt);
    setItemLine(LineCount, cItemInfo, crystalCnt, Probability);
    return;
}

function showCrystalizingEstimationList()
{
    cHeight = cHeight + (38 * (5 - LineCount));
    CrystallizationGetItemWnd.SetWindowSize(286, 194 - cHeight);
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function setItemLine(int lineNum, ItemInfo cItemInfo, int crystalCnt, float Probability)
{
    local string probabilityStr;
    local array<string> arrSplit;
    local TextBoxHandle TX;

    // End:0x1C
    if(Probability <= float(10))
    {
        probabilityStr = "???";        
    }
    else
    {
        // End:0x39
        if(Probability == float(100))
        {
            probabilityStr = "100%";            
        }
        else
        {
            Split(string(Probability), ".", arrSplit);
            // End:0xA8
            if(arrSplit.Length == 2)
            {
                // End:0x93
                if(Len(arrSplit[1]) >= 2)
                {
                    probabilityStr = ((arrSplit[0] $ ".") $ Mid(arrSplit[1], 0, 2)) $ "%";                    
                }
                else
                {
                    probabilityStr = string(Probability) $ "%";
                }                
            }
            else
            {
                probabilityStr = string(Probability) $ "%";
            }
        }
    }
    GetItemWindowHandle("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItem0" $ string(lineNum)).AddItem(cItemInfo);
    TX = GetTextBoxHandle("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemName0" $ string(lineNum));
    getInstanceL2Util().textBox_setToolTipWithShortString(TX, cItemInfo.Name, -7);
    GetTextBoxHandle("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationGetItemCount0" $ string(lineNum)).SetText(string(crystalCnt) $ GetSystemString(932));
    GetTextBoxHandle("CrystallizationWnd.CrystallizationGetItemWnd.CrystallizationItemProbability0" $ string(lineNum)).SetText(probabilityStr);
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1D
        case "OKButton":
            OnOKButtonClick();
            // End:0x3A
            break;
        // End:0x37
        case "CancelButton":
            cancelCystallizeItem();
            // End:0x3A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnOKButtonClick()
{
    isCrystallizeItem = true;
    Me.HideWindow();
    return;
}

function cancelCystallizeItem()
{
    Me.HideWindow();
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    cancelCystallizeItem();
    return;
}

defaultproperties
{
    m_WindowName="CrystallizationWnd"
}