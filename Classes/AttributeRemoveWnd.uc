class AttributeRemoveWnd extends UICommonAPI;

const DIALOG_ATTRIBUTE_REMOVE = 9001;
const EQUIPITEM_Max = 23;
const ATTRIBUTE_FIRE = 0;
const ATTRIBUTE_WATER = 1;
const ATTRIBUTE_WIND = 2;
const ATTRIBUTE_EARTH = 3;
const ATTRIBUTE_HOLY = 4;
const ATTRIBUTE_UNHOLY = 5;

var WindowHandle Me;
var TextBoxHandle txtRemoveAdenaStr;
var TextBoxHandle txtRemoveAdena;
var TextBoxHandle txtItemSelectStr;
var ItemWindowHandle ItemWnd;
var TextureHandle ItemWndBg;
var TextureHandle txtRemoveAdenaBg;
var TextureHandle ItemWndScrollBg;
var ButtonHandle btnOk;
var ButtonHandle btnCancel;
var ButtonHandle btnHideBarButton0;
var ButtonHandle btnHideBarButton1;
var ButtonHandle btnHideBarButton2;
var ToolTip toolTipScript;
var BarHandle gageAttributeSelect0;
var BarHandle gageAttributeSelect1;
var BarHandle gageAttributeSelect2;
var CheckBoxHandle btnAttributeSelect0;
var CheckBoxHandle btnAttributeSelect1;
var CheckBoxHandle btnAttributeSelect2;
var TextBoxHandle txtAttributeSelect0;
var TextBoxHandle txtAttributeSelect1;
var TextBoxHandle txtAttributeSelect2;
var ItemInfo SelectItemInfo;
var array<string> tooltipStr;
var array<string> attributeWord;
var array<int> attributerTypeRadio;
var array<int> memoryAttributeSelectedRadio;
var int beforeClickedItem;
var int radioButtonCount;
var InventoryWnd script;

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    initAttributeElements(false);
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)), "InventoryWnd");
    initAttributeElements(false);
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(2896);
    RegisterEvent(2897);
    RegisterEvent(2898);
    RegisterEvent(1710);
    RegisterEvent(1720);
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x52
    if(Event_ID == 2896)
    {
        // End:0x44
        if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("AttributeEnchantWnd"))
        {
            AddSystemMessage(3161);            
        }
        else
        {
            HandleAttributeRemoveShow(param);
        }        
    }
    else
    {
        // End:0x6F
        if(Event_ID == 2897)
        {
            HandleAttributeRemoveItemData(param);            
        }
        else
        {
            // End:0x8C
            if(Event_ID == 2898)
            {
                HandleAttributeRemoveResult(param);                
            }
            else
            {
                // End:0xA4
                if(Event_ID == 1710)
                {
                    HandleDialogOK();                    
                }
                else
                {
                    // End:0xC2
                    if(Event_ID == 1720)
                    {
                        Me.EnableWindow();
                    }
                }
            }
        }
    }
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1A
        case "btnOK":
            OnBtnOkClick();
            // End:0xC2
            break;
        // End:0x31
        case "btnCancel":
            OnbtnCancelClick();
            // End:0xC2
            break;
        // End:0x60
        case "btnListSelect0":
            // End:0x5D
            if(gageAttributeSelect0.IsShowWindow())
            {
                setRadioButton(0);
            }
            // End:0xC2
            break;
        // End:0x8F
        case "btnListSelect1":
            // End:0x8C
            if(gageAttributeSelect1.IsShowWindow())
            {
                setRadioButton(1);
            }
            // End:0xC2
            break;
        // End:0xBF
        case "btnListSelect2":
            // End:0xBC
            if(gageAttributeSelect2.IsShowWindow())
            {
                setRadioButton(2);
            }
            // End:0xC2
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function Initialize()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    Me = GetWindowHandle("AttributeRemoveWnd");
    txtRemoveAdenaStr = GetTextBoxHandle("AttributeRemoveWnd.txtRemoveAdenaStr");
    txtRemoveAdena = GetTextBoxHandle("AttributeRemoveWnd.txtRemoveAdena");
    txtItemSelectStr = GetTextBoxHandle("AttributeRemoveWnd.txtItemSelectStr");
    ItemWnd = GetItemWindowHandle("AttributeRemoveWnd.ItemWnd");
    ItemWndBg = GetTextureHandle("AttributeRemoveWnd.ItemWndBg");
    txtRemoveAdenaBg = GetTextureHandle("AttributeRemoveWnd.txtRemoveAdenaBg");
    ItemWndScrollBg = GetTextureHandle("AttributeRemoveWnd.ItemWndScrollBg");
    btnOk = GetButtonHandle("AttributeRemoveWnd.btnOK");
    btnCancel = GetButtonHandle("AttributeRemoveWnd.btnCancel");
    btnHideBarButton0 = GetButtonHandle("AttributeRemoveWnd.btnListSelect0");
    btnHideBarButton1 = GetButtonHandle("AttributeRemoveWnd.btnListSelect1");
    btnHideBarButton2 = GetButtonHandle("AttributeRemoveWnd.btnListSelect2");
    gageAttributeSelect0 = GetBarHandle("AttributeRemoveWnd.gageAttributeSelect0");
    gageAttributeSelect1 = GetBarHandle("AttributeRemoveWnd.gageAttributeSelect1");
    gageAttributeSelect2 = GetBarHandle("AttributeRemoveWnd.gageAttributeSelect2");
    btnAttributeSelect0 = GetCheckBoxHandle("AttributeRemoveWnd.btnAttributeSelect0");
    btnAttributeSelect1 = GetCheckBoxHandle("AttributeRemoveWnd.btnAttributeSelect1");
    btnAttributeSelect2 = GetCheckBoxHandle("AttributeRemoveWnd.btnAttributeSelect2");
    txtAttributeSelect0 = GetTextBoxHandle("AttributeRemoveWnd.txtAttributeSelect0");
    txtAttributeSelect1 = GetTextBoxHandle("AttributeRemoveWnd.txtAttributeSelect1");
    txtAttributeSelect2 = GetTextBoxHandle("AttributeRemoveWnd.txtAttributeSelect2");
    script = InventoryWnd(GetScript("InventoryWnd"));
    toolTipScript = ToolTip(GetScript("Tooltip"));
    attributeWord[0] = "Fire";
    attributeWord[1] = "Water";
    attributeWord[2] = "Wind";
    attributeWord[3] = "Earth";
    attributeWord[4] = "Divine";
    attributeWord[5] = "Dark";
    beforeClickedItem = -1;
    return;
}

function initAttributeElements(bool visibleFlag)
{
    txtRemoveAdena.SetText("");
    gageAttributeSelect0.Clear();
    gageAttributeSelect1.Clear();
    gageAttributeSelect2.Clear();
    txtAttributeSelect0.SetText("");
    txtAttributeSelect1.SetText("");
    txtAttributeSelect2.SetText("");
    btnAttributeSelect0.SetCheck(false);
    btnAttributeSelect1.SetCheck(false);
    btnAttributeSelect2.SetCheck(false);
    // End:0x137
    if(visibleFlag == false)
    {
        btnAttributeSelect0.HideWindow();
        btnAttributeSelect1.HideWindow();
        btnAttributeSelect2.HideWindow();
        gageAttributeSelect0.HideWindow();
        gageAttributeSelect1.HideWindow();
        gageAttributeSelect2.HideWindow();
        txtAttributeSelect0.HideWindow();
        txtAttributeSelect1.HideWindow();
        txtAttributeSelect2.HideWindow();        
    }
    else
    {
        btnAttributeSelect0.ShowWindow();
        btnAttributeSelect1.ShowWindow();
        btnAttributeSelect2.ShowWindow();
        gageAttributeSelect0.ShowWindow();
        gageAttributeSelect1.ShowWindow();
        gageAttributeSelect2.ShowWindow();
        txtAttributeSelect0.ShowWindow();
        txtAttributeSelect1.ShowWindow();
        txtAttributeSelect2.ShowWindow();
    }
    return;
}

function string getAttributeNumToStr(int Num)
{
    local string returnStr;

    returnStr = "";
    switch(Num)
    {
        // End:0x27
        case 0:
            returnStr = GetSystemString(1622);
            // End:0xFE
            break;
        // End:0x3F
        case 1:
            returnStr = GetSystemString(1623);
            // End:0xFE
            break;
        // End:0x58
        case 2:
            returnStr = GetSystemString(1624);
            // End:0xFE
            break;
        // End:0x71
        case 3:
            returnStr = GetSystemString(1625);
            // End:0xFE
            break;
        // End:0x8A
        case 4:
            returnStr = GetSystemString(1626);
            // End:0xFE
            break;
        // End:0xA3
        case 5:
            returnStr = GetSystemString(1627);
            // End:0xFE
            break;
        // End:0xFFFF
        default:
            Debug("UC Error : 잘못된 속성 타입 번호를 getAttributeNumToStr 메소드에 삽입하였습니다.");
            break;
    }
    return returnStr;
    return;
}

function applyAttribute(int attributeNum)
{
    ItemWnd.GetSelectedItem(SelectItemInfo);
    // End:0x4A
    if(SelectItemInfo.AttackAttributeValue > 0)
    {
        Class'NWindow.EnchantAPI'.static.RequestRemoveAttribute(SelectItemInfo.Id, SelectItemInfo.AttackAttributeType);        
    }
    else
    {
        Class'NWindow.EnchantAPI'.static.RequestRemoveAttribute(SelectItemInfo.Id, attributeNum);
    }
    return;
}

function OnBtnOkClick()
{
    local string strName;
    local int attributeTypeByRadio, currentAttributerTypeRadio;

    strName = Class'NWindow.UIDATA_ITEM'.static.GetItemName(SelectItemInfo.Id);
    attributeTypeByRadio = attributerTypeRadio[getRadioButtonSelected()];
    // End:0x4F
    if(SelectItemInfo.AttackAttributeValue > 0)
    {
        currentAttributerTypeRadio = attributeTypeByRadio;        
    }
    else
    {
        // End:0x64
        if(attributeTypeByRadio == 0)
        {
            currentAttributerTypeRadio = 1;            
        }
        else
        {
            // End:0x79
            if(attributeTypeByRadio == 1)
            {
                currentAttributerTypeRadio = 0;                
            }
            else
            {
                // End:0x90
                if(attributeTypeByRadio == 2)
                {
                    currentAttributerTypeRadio = 3;                    
                }
                else
                {
                    // End:0xA7
                    if(attributeTypeByRadio == 3)
                    {
                        currentAttributerTypeRadio = 2;                        
                    }
                    else
                    {
                        // End:0xBE
                        if(attributeTypeByRadio == 4)
                        {
                            currentAttributerTypeRadio = 5;                            
                        }
                        else
                        {
                            // End:0xD2
                            if(attributeTypeByRadio == 5)
                            {
                                currentAttributerTypeRadio = 4;
                            }
                        }
                    }
                }
            }
        }
    }
    // End:0x14C
    if(__NFUN_411__(GetAdena(), (txtRemoveAdena.GetText())))
    {
        Me.DisableWindow();
        DialogSetID(9001);
        DialogSetReservedInt(attributerTypeRadio[getRadioButtonSelected()]);
        DialogShow(1, 4, MakeFullSystemMsg(GetSystemMessage(3146), strName, getAttributeNumToStr(currentAttributerTypeRadio)), string(self));        
    }
    else
    {
        AddSystemMessage(3156);
    }
    return;
}

function HandleDialogOK()
{
    // End:0x34
    if(DialogIsMine())
    {
        // End:0x34
        if((DialogGetID()) == 9001)
        {
            applyAttribute(DialogGetReservedInt());
            Me.EnableWindow();
        }
    }
    return;
}

function OnbtnCancelClick()
{
    Me.HideWindow();
    ItemWnd.Clear();
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo infItem;
    local int Price;

    // End:0xBF
    if(strID == "ItemWnd")
    {
        // End:0x34
        if(beforeClickedItem != -1)
        {
            memoryAttributeSelectedRadio[beforeClickedItem] = getRadioButtonSelected();
        }
        ItemWnd.GetItem(Index, infItem);
        ItemWnd.GetSelectedItem(SelectItemInfo);
        btnOk.EnableWindow();
        setAttributeGages(infItem, memoryAttributeSelectedRadio[Index]);
        Price = name(infItem.DefaultPrice);
        txtRemoveAdena.SetText(MakeCostString(string(Price)));
        beforeClickedItem = Index;
    }
    return;
}

function HandleAttributeRemoveShow(string param)
{
    ItemWnd.Clear();
    initAttributeElements(false);
    btnOk.DisableWindow();
    Me.ShowWindow();
    Me.SetFocus();
    Me.EnableWindow();
    return;
}

function HandleAttributeRemoveItemData(string param)
{
    local int invenIdx, i, Index;
    local INT64 Adena;
    local ItemID sID;
    local ItemInfo infItem;

    ParseItemID(param, sID);
    ParseINT64(param, "Adena", Adena);
    invenIdx = script.m_invenItem.FindItem(sID);
    // End:0x106
    if(invenIdx == -1)
    {
        i = 0;
        J0x60:

        // End:0x103 [Loop If]
        if(i < 23)
        {
            Index = script.m_equipItem[i].FindItem(sID);
            memoryAttributeSelectedRadio[i] = 0;
            // End:0xF9
            if(-1 != Index)
            {
                memoryAttributeSelectedRadio[i] = 0;
                script.m_equipItem[i].GetItem(Index, infItem);
                infItem.DefaultPrice = Adena;
                // [Explicit Break]
                goto J0x103;
            }
            ++i;
            // [Loop Continue]
            goto J0x60;
        }
        J0x103:
        
    }
    else
    {
        script.m_invenItem.GetItem(invenIdx, infItem);
        infItem.DefaultPrice = Adena;
    }
    ItemWnd.AddItem(infItem);
    return;
}

function HandleAttributeRemoveResult(string param)
{
    local int Result, removedAttr, GetItemNum;
    local ItemID sID;
    local ItemInfo targetItem;

    Me.EnableWindow();
    ParseInt(param, "Result", Result);
    ParseInt(param, "RemovedAttr", removedAttr);
    ParseInt(param, "itemID", sID.ServerID);
    sID.ClassID = 0;
    GetItemNum = ItemWnd.FindItem(sID);
    ItemWnd.GetItem(GetItemNum, targetItem);
    // End:0x356
    if(Result == 1)
    {
        // End:0x155
        if(targetItem.AttackAttributeValue > 0)
        {
            targetItem.AttackAttributeValue = 0;
            ItemWnd.DeleteItem(GetItemNum);
            memoryAttributeSelectedRadio.Remove(GetItemNum, 1);
            // End:0x12D
            if(ItemWnd.GetItemNum() > 0)
            {
                ItemWnd.SetSelectedNum(GetItemNum - 1);
                OnClickItem("ItemWnd", GetItemNum - 1);                
            }
            else
            {
                ItemWnd.Clear();
                initAttributeElements(false);
                btnOk.DisableWindow();
            }            
        }
        else
        {
            // End:0x353
            if((getDefenseAttributeValue(targetItem)) > 0)
            {
                switch(removedAttr)
                {
                    // End:0x180
                    case 0:
                        targetItem.DefenseAttributeValueFire = 0;
                        // End:0x1E6
                        break;
                    // End:0x193
                    case 1:
                        targetItem.DefenseAttributeValueWater = 0;
                        // End:0x1E6
                        break;
                    // End:0x1A7
                    case 2:
                        targetItem.DefenseAttributeValueWind = 0;
                        // End:0x1E6
                        break;
                    // End:0x1BB
                    case 3:
                        targetItem.DefenseAttributeValueEarth = 0;
                        // End:0x1E6
                        break;
                    // End:0x1CF
                    case 4:
                        targetItem.DefenseAttributeValueHoly = 0;
                        // End:0x1E6
                        break;
                    // End:0x1E3
                    case 5:
                        targetItem.DefenseAttributeValueUnholy = 0;
                        // End:0x1E6
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                // End:0x281
                if((getDefenseAttributeValue(targetItem)) > 0)
                {
                    ItemWnd.SetItem(GetItemNum, targetItem);
                    // End:0x23E
                    if(memoryAttributeSelectedRadio[GetItemNum] > 0)
                    {
                        memoryAttributeSelectedRadio[GetItemNum] = memoryAttributeSelectedRadio[GetItemNum] - 1;                        
                    }
                    else
                    {
                        memoryAttributeSelectedRadio[GetItemNum] = 0;
                    }
                    beforeClickedItem = -1;
                    ItemWnd.SetSelectedNum(GetItemNum);
                    OnClickItem("ItemWnd", GetItemNum);                    
                }
                else
                {
                    ItemWnd.DeleteItem(GetItemNum);
                    memoryAttributeSelectedRadio.Remove(GetItemNum, 1);
                    // End:0x32B
                    if(ItemWnd.GetItemNum() > 0)
                    {
                        // End:0x300
                        if(ItemWnd.GetItemNum() == GetItemNum)
                        {
                            ItemWnd.SetSelectedNum(GetItemNum - 1);
                            OnClickItem("ItemWnd", GetItemNum - 1);                            
                        }
                        else
                        {
                            ItemWnd.SetSelectedNum(GetItemNum);
                            OnClickItem("ItemWnd", GetItemNum);
                        }                        
                    }
                    else
                    {
                        ItemWnd.Clear();
                        initAttributeElements(false);
                        btnOk.DisableWindow();
                    }
                }                
            }
        }        
    }
    else
    {
        Me.HideWindow();
        ItemWnd.Clear();
    }
    return;
}

function int getDefenseAttributeValue(ItemInfo targetItem)
{
    return ((((targetItem.DefenseAttributeValueFire + targetItem.DefenseAttributeValueWater) + targetItem.DefenseAttributeValueWind) + targetItem.DefenseAttributeValueEarth) + targetItem.DefenseAttributeValueHoly) + targetItem.DefenseAttributeValueUnholy;
    return;
}

function int getRadioButtonSelected()
{
    local int returnValueM;

    // End:0x1D
    if(btnAttributeSelect2.IsChecked())
    {
        returnValueM = 2;        
    }
    else
    {
        // End:0x39
        if(btnAttributeSelect1.IsChecked())
        {
            returnValueM = 1;            
        }
        else
        {
            returnValueM = 0;
        }
    }
    return returnValueM;
    return;
}

function setRadioButton(int SelectNum)
{
    btnAttributeSelect0.SetCheck(false);
    btnAttributeSelect1.SetCheck(false);
    btnAttributeSelect2.SetCheck(false);
    // End:0x4E
    if(SelectNum == 1)
    {
        btnAttributeSelect1.SetCheck(true);        
    }
    else
    {
        // End:0x6D
        if(SelectNum == 2)
        {
            btnAttributeSelect2.SetCheck(true);            
        }
        else
        {
            btnAttributeSelect0.SetCheck(true);
        }
    }
    return;
}

function setAttributeGages(ItemInfo item, int selectedRadioButtonNum)
{
    local int i;
    local BarHandle currentGage;
    local TextBoxHandle currentTextBox;
    local CheckBoxHandle currentRadioButton;

    i = 0;
    J0x07:

    // End:0x2B [Loop If]
    if(i < 6)
    {
        tooltipStr[i] = "";
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    i = 0;
    J0x32:

    // End:0x59 [Loop If]
    if(i < 3)
    {
        attributerTypeRadio[i] = 999;
        i++;
        // [Loop Continue]
        goto J0x32;
    }
    initAttributeElements(false);
    radioButtonCount = 0;
    // End:0x3D5
    if(item.AttackAttributeValue > 0)
    {
        toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 0);
        toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 1);
        toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 2);
        toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 3);
        toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 4);
        toolTipScript.SetAttackAttribute(item.AttackAttributeValue, 5);
        switch(item.AttackAttributeType)
        {
            // End:0x193
            case 0:
                tooltipStr[0] = ((((((((GetSystemString(1622) $ " Lv ") $ string(toolTipScript.AttackAttLevel[0])) $ " (") $ GetSystemString(1622)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x3D2
                break;
            // End:0x203
            case 1:
                tooltipStr[1] = ((((((((GetSystemString(1623) $ " Lv ") $ string(toolTipScript.AttackAttLevel[1])) $ " (") $ GetSystemString(1623)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x3D2
                break;
            // End:0x276
            case 2:
                tooltipStr[2] = ((((((((GetSystemString(1624) $ " Lv ") $ string(toolTipScript.AttackAttLevel[2])) $ " (") $ GetSystemString(1624)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x3D2
                break;
            // End:0x2E9
            case 3:
                tooltipStr[3] = ((((((((GetSystemString(1625) $ " Lv ") $ string(toolTipScript.AttackAttLevel[3])) $ " (") $ GetSystemString(1625)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x3D2
                break;
            // End:0x35C
            case 4:
                tooltipStr[4] = ((((((((GetSystemString(1626) $ " Lv ") $ string(toolTipScript.AttackAttLevel[4])) $ " (") $ GetSystemString(1626)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x3D2
                break;
            // End:0x3CF
            case 5:
                tooltipStr[5] = ((((((((GetSystemString(1627) $ " Lv ") $ string(toolTipScript.AttackAttLevel[5])) $ " (") $ GetSystemString(1627)) $ " ") $ GetSystemString(55)) $ " ") $ string(item.AttackAttributeValue)) $ ")";
                // End:0x3D2
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        toolTipScript.SetDefAttribute(item.DefenseAttributeValueFire, 0);
        toolTipScript.SetDefAttribute(item.DefenseAttributeValueWater, 1);
        toolTipScript.SetDefAttribute(item.DefenseAttributeValueWind, 2);
        toolTipScript.SetDefAttribute(item.DefenseAttributeValueEarth, 3);
        toolTipScript.SetDefAttribute(item.DefenseAttributeValueHoly, 4);
        toolTipScript.SetDefAttribute(item.DefenseAttributeValueUnholy, 5);
        // End:0x4EE
        if(item.DefenseAttributeValueFire != 0)
        {
            tooltipStr[0] = ((((((((GetSystemString(1623) $ " Lv ") $ string(toolTipScript.DefAttLevel[0])) $ " (") $ GetSystemString(1622)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueFire)) $ ")";
        }
        // End:0x567
        if(item.DefenseAttributeValueWater != 0)
        {
            tooltipStr[1] = ((((((((GetSystemString(1622) $ " Lv ") $ string(toolTipScript.DefAttLevel[1])) $ " (") $ GetSystemString(1623)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueWater)) $ ")";
        }
        // End:0x5E2
        if(item.DefenseAttributeValueWind != 0)
        {
            tooltipStr[2] = ((((((((GetSystemString(1625) $ " Lv ") $ string(toolTipScript.DefAttLevel[2])) $ " (") $ GetSystemString(1624)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueWind)) $ ")";
        }
        // End:0x65D
        if(item.DefenseAttributeValueEarth != 0)
        {
            tooltipStr[3] = ((((((((GetSystemString(1624) $ " Lv ") $ string(toolTipScript.DefAttLevel[3])) $ " (") $ GetSystemString(1625)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueEarth)) $ ")";
        }
        // End:0x6D8
        if(item.DefenseAttributeValueHoly != 0)
        {
            tooltipStr[4] = ((((((((GetSystemString(1627) $ " Lv ") $ string(toolTipScript.DefAttLevel[4])) $ " (") $ GetSystemString(1626)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueHoly)) $ ")";
        }
        // End:0x753
        if(item.DefenseAttributeValueUnholy != 0)
        {
            tooltipStr[5] = ((((((((GetSystemString(1626) $ " Lv ") $ string(toolTipScript.DefAttLevel[5])) $ " (") $ GetSystemString(1627)) $ " ") $ GetSystemString(54)) $ " ") $ string(item.DefenseAttributeValueUnholy)) $ ")";
        }
    }
    // End:0x905
    if(item.AttackAttributeValue > 0)
    {
        i = 0;
        J0x76A:

        // End:0x902 [Loop If]
        if(i < 6)
        {
            // End:0x78E
            if(tooltipStr[i] == "")
            {
                // [Explicit Continue]
                goto J0x8F8;
                // [Explicit Continue]
                goto J0x8F8;
            }
            currentGage = GetBarHandle("AttributeRemoveWnd.gageAttributeSelect" $ string(radioButtonCount));
            currentTextBox = GetTextBoxHandle("AttributeRemoveWnd.txtAttributeSelect" $ string(radioButtonCount));
            currentRadioButton = GetCheckBoxHandle("AttributeRemoveWnd.btnAttributeSelect" $ string(radioButtonCount));
            currentGage.Clear();
            currentGage.SetValue(toolTipScript.AttackAttMaxValue[i], toolTipScript.AttackAttCurrValue[i]);
            setColorBar(currentGage, i);
            currentGage.ShowWindow();
            currentTextBox.ShowWindow();
            currentRadioButton.ShowWindow();
            currentTextBox.SetText(tooltipStr[i]);
            attributerTypeRadio[radioButtonCount] = i;
            radioButtonCount++;
            J0x8F8:

            i++;
            // [Loop Continue]
            goto J0x76A;
        }        
    }
    else
    {
        i = 0;
        J0x90C:

        // End:0xAA4 [Loop If]
        if(i < 6)
        {
            // End:0x930
            if(tooltipStr[i] == "")
            {
                // [Explicit Continue]
                goto J0xA9A;
                // [Explicit Continue]
                goto J0xA9A;
            }
            currentGage = GetBarHandle("AttributeRemoveWnd.gageAttributeSelect" $ string(radioButtonCount));
            currentTextBox = GetTextBoxHandle("AttributeRemoveWnd.txtAttributeSelect" $ string(radioButtonCount));
            currentRadioButton = GetCheckBoxHandle("AttributeRemoveWnd.btnAttributeSelect" $ string(radioButtonCount));
            currentGage.Clear();
            currentGage.SetValue(toolTipScript.DefAttMaxValue[i], toolTipScript.DefAttCurrValue[i]);
            setColorBar(currentGage, i);
            currentGage.ShowWindow();
            currentTextBox.ShowWindow();
            currentRadioButton.ShowWindow();
            currentTextBox.SetText(tooltipStr[i]);
            attributerTypeRadio[radioButtonCount] = i;
            radioButtonCount++;
            J0xA9A:

            i++;
            // [Loop Continue]
            goto J0x90C;
        }
    }
    setRadioButton(selectedRadioButtonNum);
    return;
}

function setColorBar(BarHandle bar, int SelectNum)
{
    bar.SetTexture(0, ("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Left");
    bar.SetTexture(1, ("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Center");
    bar.SetTexture(2, ("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Right");
    bar.SetTexture(3, ("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Bg_Left");
    bar.SetTexture(4, ("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Bg_Center");
    bar.SetTexture(5, ("L2UI_CT1.Gauge_DF_Attribute_" $ attributeWord[SelectNum]) $ "_Bg_Right");
    return;
}

function BarHandle selectBarHandle(int SelectNum)
{
    local BarHandle returnValueM;

    // End:0x19
    if(SelectNum == 0)
    {
        returnValueM = gageAttributeSelect0;        
    }
    else
    {
        // End:0x32
        if(SelectNum == 1)
        {
            returnValueM = gageAttributeSelect1;            
        }
        else
        {
            // End:0x49
            if(SelectNum == 2)
            {
                returnValueM = gageAttributeSelect2;
            }
        }
    }
    return returnValueM;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    OnbtnCancelClick();
    return;
}
