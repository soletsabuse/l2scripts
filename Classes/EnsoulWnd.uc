class EnsoulWnd extends UICommonAPI;

const STATE_INSERT_WEAPON = "STATE_INSERT_WEAPON";
const STATE_INSERT_ENSOULSTONE = "STATE_INSERT_ENSOULSTONE";
const STATE_SELECT_ENSOUL = "STATE_SELECT_ENSOUL";
const STATE_CONFIRM_ENSOUL = "STATE_CONFIRM_ENSOUL";
const STATE_ASK_OVERWRITE = "STATE_ASK_OVERWRITE";
const STATE_RESULT = "STATE_RESULT";
const TEXTBOX_DOT_GAP = 12;

struct ItemEnsoulRequest
{
    var int selectedOptionID;
    var int selectedOptionType;
    var int ensoulStoneServerID;
    var int clientSlotIndex;
    var int clientSlotType;
};

struct EnsoulStoneSlot
{
    var ItemInfo Info;
    var EnsoulOptionUIInfo eOptionUIInfo;
    var int SlotIndex;
    var int slotType;
};

var WindowHandle Me;
var TextureHandle EnsoulGroupbox1_Texture;
var TextureHandle EnsoulGroupbox2_Texture;
var ButtonHandle EnsoulInfo_Button;
var ButtonHandle EnsoulOK_Button;
var ButtonHandle EnsoulCancelBtn;
var TextBoxHandle EnsoulDiscription_TextBox;
var WindowHandle EnsoulProgressWnd;
var TextBoxHandle EnsoulProgressWnd_Title_TextBox;
var ProgressCtrlHandle EnsoulProgressWnd_ProgressBar;
var WindowHandle EnsoulDefaultWnd;
var TextureHandle EnsoulDefaultWnd_SlotBg1Light_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg2Light_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg3Light_Texture;
var TextureHandle EnsoulDefaultWnd_Select1_Texture;
var TextureHandle EnsoulDefaultWnd_Select2_Texture;
var TextureHandle EnsoulDefaultWnd_Groupbox1_Texture;
var TextureHandle EnsoulDefaultWnd_Groupbox2_Texture;
var TextureHandle EnsoulDefaultWnd_Step1_Texture;
var TextureHandle EnsoulDefaultWnd_Step2_Texture;
var TextureHandle EnsoulDefaultWnd_BM_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg1_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg2_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg3_Texture;
var TextureHandle EnsoulDefaultWnd_SlotBg4_Texture;
var TextureHandle EnsoulDefaultWnd_Divider1;
var TextureHandle EnsoulDefaultWnd_Divider2;
var TextureHandle EnsoulDefaultWnd_Divider3;
var TextureHandle EnsoulDefaultWnd_Step1block_Texture;
var TextureHandle EnsoulDefaultWnd_Step2block_Texture;
var TextureHandle EnsoulDefaultWnd_BMblock_Texture;
var ItemWindowHandle EnsoulDefaultWnd_Item1_ItemWnd;
var ItemWindowHandle EnsoulDefaultWnd_Item2_ItemWnd;
var ItemWindowHandle EnsoulDefaultWnd_Item3_ItemWnd;
var ItemWindowHandle EnsoulDefaultWnd_ItemBM_ItemWnd;
var TextBoxHandle EnsoulDefaultWnd_TitleWeapon_TextBox;
var TextBoxHandle EnsoulDefaultWnd_WeaponName_TextBox;
var TextBoxHandle EnsoulDefaultWnd_TitleSoul_TextBox;
var TextBoxHandle EnsoulDefaultWnd_SoulName1_TextBox;
var TextBoxHandle EnsoulDefaultWnd_Soul1_TextBox;
var TextBoxHandle EnsoulDefaultWnd_SoulName2_TextBox;
var TextBoxHandle EnsoulDefaultWnd_Soul2_TextBox;
var TextBoxHandle EnsoulDefaultWnd_SoulName3_TextBox;
var TextBoxHandle EnsoulDefaultWnd_Soul3_TextBox;
var WindowHandle EnsoulOptionWnd;
var TextureHandle EnsoulOptionWnd_Groupbox1_Texture;
var TextureHandle EnsoulOptionWnd_Groupbox2_Texture;
var TextureHandle EnsoulOptionWnd_Groupbox3_Texture;
var TextureHandle EnsoulOptionWnd_SlotBg1_Texture;
var TextureHandle EnsoulOptionWnd_SlotBg2_Texture;
var ItemWindowHandle EnsoulOptionWnd_ITEM1_ItemWnd;
var ItemWindowHandle EnsoulOptionWnd_ITEM2_ItemWnd;
var TextBoxHandle EnsoulOptionWnd_TitleWeapon_TextBox;
var TextBoxHandle EnsoulOptionWnd_WeaponName_TextBox;
var TextBoxHandle EnsoulOptionWnd_TitleSoul_TextBox;
var TextBoxHandle EnsoulOptionWnd_SoulName_TextBox;
var TextBoxHandle EnsoulOptionWnd_Soul_TextBox;
var TextBoxHandle EnsoulOptionWnd_Souloption_TextBox;
var TextureHandle EnsoulOptionWnd_ListGroupbox1_Texture;
var TextureHandle EnsoulOptionWnd_Divider_Texture;
var ListCtrlHandle EnsoulOptionWnd_ListCtrl;
var TextBoxHandle EnsoulOptionWnd_ChargeTitle_TextBox;
var TextBoxHandle EnsoulOptionWnd_Charge1_TextBox;
var TextBoxHandle EnsoulOptionWnd_Charge2_TextBox;
var TextBoxHandle EnsoulOptionWnd_Charge3_TextBox;
var WindowHandle EnsouEffectWnd;
var TextBoxHandle EnsouEffectWnd_TitleBefore_TextBox;
var TextBoxHandle EnsouEffectWnd_TitleAfter_TextBox;
var TextBoxHandle EnsouEffectWnd_TitleCharge_TextBox;
var TextBoxHandle EnsouEffectWnd_Charge1_TextBox;
var TextBoxHandle EnsouEffectWnd_Charge2_TextBox;
var TextBoxHandle EnsouEffectWnd_Charge3_TextBox;
var TextureHandle EnsouEffectWnd_Arrow_Texture;
var TextureHandle EnsouEffectWnd_ChargeGroupbox_Texture;
var TextureHandle EnsouEffectWnd_ListGroupbox1_Texture;
var ListCtrlHandle EnsouEffectWnd_Before_ListCtrl;
var TextureHandle EnsouEffectWnd_ListGroupbox2_Texture;
var ListCtrlHandle EnsouEffectWnd_After_ListCtrl;
var AnimTextureHandle EnsoulProgress_AnimTex;
var WindowHandle DisableWnd;
var WindowHandle EnsoulWnd_ResultWnd;
var L2Util util;
var InventoryWnd inventoryWndScript;
var EnsoulSubWnd EnsoulSubWndScript;
var ItemWindowHandle EnsoulSubWnd_WeaponItemWindow;
var ItemWindowHandle EnsoulSubWnd_EnsoulItemWindow;
var string currentEnsoulState;
var int currentOpenEnsoulStoneSlot;
var array<ItemEnsoulRequest> itemEnsoulRequestInfo;
var array<EnsoulStoneSlot> alreadyHasOptionSlotArray;
var array<EnsoulOptionUIInfo> selectedOptionSlotArray;
var EnsoulOptionUIInfo selectedEnsoulOptionUIInfo;
var array<INT64> slotJamStoneFee;
var int overwriteSlotIndex;
var ItemInfo overwriteItemInfo;
var int normalSlotCount;
var int bmSlotCount;

function OnRegisterEvent()
{
    RegisterEvent(10060);
    RegisterEvent(10061);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(40);
    return;
}

function OnShow()
{
    getInstanceL2Util().ItemRelationWindowHide(getCurrentWindowName(string(self)));
    setWindowStateSetting("STATE_INSERT_WEAPON");
    GetWindowHandle("EnsoulSubWnd").ShowWindow();
    return;
}

function OnHide()
{
    GetWindowHandle("EnsoulSubWnd").HideWindow();
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    return;
}

function Initialize()
{
    util = L2Util(GetScript("L2Util"));
    inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
    EnsoulSubWndScript = EnsoulSubWnd(GetScript("EnsoulSubWnd"));
    Me = GetWindowHandle("EnsoulWnd");
    EnsoulProgress_AnimTex = GetAnimTextureHandle("EnsoulWnd.EnsoulWnd_ResultWnd.EnsoulProgress_AnimTex");
    EnsoulGroupbox1_Texture = GetTextureHandle("EnsoulWnd.EnsoulGroupbox1_Texture");
    EnsoulGroupbox2_Texture = GetTextureHandle("EnsoulWnd.EnsoulGroupbox2_Texture");
    EnsoulInfo_Button = GetButtonHandle("EnsoulWnd.EnsoulInfo_Button");
    EnsoulOK_Button = GetButtonHandle("EnsoulWnd.EnsoulOK_Button");
    EnsoulCancelBtn = GetButtonHandle("EnsoulWnd.EnsoulCancelBtn");
    EnsoulDiscription_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDiscription_TextBox");
    EnsoulProgressWnd = GetWindowHandle("EnsoulWnd.EnsoulProgressWnd");
    EnsoulProgressWnd_Title_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulProgressWnd.EnsoulProgressWnd_Title_TextBox");
    EnsoulProgressWnd_ProgressBar = GetProgressCtrlHandle("EnsoulWnd.EnsoulProgressWnd.EnsoulProgressWnd_ProgressBar");
    EnsoulDefaultWnd = GetWindowHandle("EnsoulWnd.EnsoulDefaultWnd");
    EnsoulDefaultWnd_SlotBg1Light_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg1Light_Texture");
    EnsoulDefaultWnd_SlotBg2Light_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg2Light_Texture");
    EnsoulDefaultWnd_SlotBg3Light_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg3Light_Texture");
    EnsoulDefaultWnd_Select1_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Select1_Texture");
    EnsoulDefaultWnd_Select2_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Select2_Texture");
    EnsoulDefaultWnd_Groupbox1_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Groupbox1_Texture");
    EnsoulDefaultWnd_Groupbox2_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Groupbox2_Texture");
    EnsoulDefaultWnd_Step1_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Step1_Texture");
    EnsoulDefaultWnd_Step2_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Step2_Texture");
    EnsoulDefaultWnd_BM_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_BM_Texture");
    EnsoulDefaultWnd_SlotBg1_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg1_Texture");
    EnsoulDefaultWnd_SlotBg2_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg2_Texture");
    EnsoulDefaultWnd_SlotBg3_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg3_Texture");
    EnsoulDefaultWnd_SlotBg4_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SlotBg4_Texture");
    EnsoulDefaultWnd_Divider1 = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Divider1");
    EnsoulDefaultWnd_Divider2 = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Divider2");
    EnsoulDefaultWnd_Divider3 = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Divider3");
    EnsoulDefaultWnd_Step1block_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Step1block_Texture");
    EnsoulDefaultWnd_Step2block_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Step2block_Texture");
    EnsoulDefaultWnd_BMblock_Texture = GetTextureHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_BMblock_Texture");
    EnsoulDefaultWnd_Item1_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Item1_ItemWnd");
    EnsoulDefaultWnd_Item2_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Item2_ItemWnd");
    EnsoulDefaultWnd_Item3_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Item3_ItemWnd");
    EnsoulDefaultWnd_ItemBM_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_ItemBM_ItemWnd");
    EnsoulDefaultWnd_TitleWeapon_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_TitleWeapon_TextBox");
    EnsoulDefaultWnd_WeaponName_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_WeaponName_TextBox");
    EnsoulDefaultWnd_TitleSoul_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_TitleSoul_TextBox");
    EnsoulDefaultWnd_SoulName1_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SoulName1_TextBox");
    EnsoulDefaultWnd_Soul1_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Soul1_TextBox");
    EnsoulDefaultWnd_SoulName2_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SoulName2_TextBox");
    EnsoulDefaultWnd_Soul2_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Soul2_TextBox");
    EnsoulDefaultWnd_SoulName3_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_SoulName3_TextBox");
    EnsoulDefaultWnd_Soul3_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulDefaultWnd.EnsoulDefaultWnd_Soul3_TextBox");
    EnsoulOptionWnd = GetWindowHandle("EnsoulWnd.EnsoulOptionWnd");
    EnsoulOptionWnd_Groupbox1_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Groupbox1_Texture");
    EnsoulOptionWnd_Groupbox2_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Groupbox2_Texture");
    EnsoulOptionWnd_Groupbox3_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Groupbox3_Texture");
    EnsoulOptionWnd_SlotBg1_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_SlotBg1_Texture");
    EnsoulOptionWnd_SlotBg2_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_SlotBg2_Texture");
    EnsoulOptionWnd_ITEM1_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_ITEM1_ItemWnd");
    EnsoulOptionWnd_ITEM2_ItemWnd = GetItemWindowHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_ITEM2_ItemWnd");
    EnsoulOptionWnd_TitleWeapon_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_TitleWeapon_TextBox");
    EnsoulOptionWnd_WeaponName_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_WeaponName_TextBox");
    EnsoulOptionWnd_TitleSoul_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_TitleSoul_TextBox");
    EnsoulOptionWnd_SoulName_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_SoulName_TextBox");
    EnsoulOptionWnd_Soul_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Soul_TextBox");
    EnsoulOptionWnd_Souloption_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Souloption_TextBox");
    EnsoulOptionWnd_ListGroupbox1_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_ListGroupbox1_Texture");
    EnsoulOptionWnd_Divider_Texture = GetTextureHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Divider_Texture");
    EnsoulOptionWnd_ListCtrl = GetListCtrlHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_ListCtrl");
    EnsoulOptionWnd_ChargeTitle_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_ChargeTitle_TextBox");
    EnsoulOptionWnd_Charge1_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Charge1_TextBox");
    EnsoulOptionWnd_Charge2_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Charge2_TextBox");
    EnsoulOptionWnd_Charge3_TextBox = GetTextBoxHandle("EnsoulWnd.EnsoulOptionWnd.EnsoulOptionWnd_Charge3_TextBox");
    EnsouEffectWnd = GetWindowHandle("EnsoulWnd.EnsouEffectWnd");
    EnsouEffectWnd_TitleBefore_TextBox = GetTextBoxHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_TitleBefore_TextBox");
    EnsouEffectWnd_TitleAfter_TextBox = GetTextBoxHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_TitleAfter_TextBox");
    EnsouEffectWnd_TitleCharge_TextBox = GetTextBoxHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_TitleCharge_TextBox");
    EnsouEffectWnd_Charge1_TextBox = GetTextBoxHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_Charge1_TextBox");
    EnsouEffectWnd_Charge2_TextBox = GetTextBoxHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_Charge2_TextBox");
    EnsouEffectWnd_Charge3_TextBox = GetTextBoxHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_Charge3_TextBox");
    EnsouEffectWnd_Arrow_Texture = GetTextureHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_Arrow_Texture");
    EnsouEffectWnd_ChargeGroupbox_Texture = GetTextureHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_ChargeGroupbox_Texture");
    EnsouEffectWnd_ListGroupbox1_Texture = GetTextureHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_ListGroupbox1_Texture");
    EnsouEffectWnd_ListGroupbox2_Texture = GetTextureHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_ListGroupbox2_Texture");
    EnsoulProgress_AnimTex.Stop();
    EnsoulProgress_AnimTex.HideWindow();
    EnsouEffectWnd_Before_ListCtrl = GetListCtrlHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_Before_ListCtrl");
    EnsouEffectWnd_After_ListCtrl = GetListCtrlHandle("EnsoulWnd.EnsouEffectWnd.EnsouEffectWnd_After_ListCtrl");
    DisableWnd = GetWindowHandle("EnsoulWnd.DisableWnd");
    EnsoulWnd_ResultWnd = GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd");
    EnsoulSubWnd_WeaponItemWindow = GetItemWindowHandle("EnsoulSubWnd.EnsoulSubWnd_Item1");
    EnsoulSubWnd_EnsoulItemWindow = GetItemWindowHandle("EnsoulSubWnd.EnsoulSubWnd_Item2");
    EnsoulOptionWnd_ListCtrl.SetSelectedSelTooltip(false);
    EnsoulOptionWnd_ListCtrl.SetAppearTooltipAtMouseX(true);
    EnsouEffectWnd_After_ListCtrl.SetSelectedSelTooltip(false);
    EnsouEffectWnd_After_ListCtrl.SetAppearTooltipAtMouseX(true);
    EnsouEffectWnd_Before_ListCtrl.SetSelectedSelTooltip(false);
    EnsouEffectWnd_Before_ListCtrl.SetAppearTooltipAtMouseX(true);
    return;
}

function ItemWindowHandle getItemSlotWindow(int SlotIndex)
{
    local ItemWindowHandle targetItemWndow;

    // End:0x19
    if(SlotIndex == 0)
    {
        targetItemWndow = EnsoulDefaultWnd_Item1_ItemWnd;        
    }
    else
    {
        // End:0x32
        if(SlotIndex == 1)
        {
            targetItemWndow = EnsoulDefaultWnd_Item2_ItemWnd;            
        }
        else
        {
            // End:0x4C
            if(SlotIndex == 2)
            {
                targetItemWndow = EnsoulDefaultWnd_Item3_ItemWnd;                
            }
            else
            {
                // End:0x66
                if(SlotIndex == 3)
                {
                    targetItemWndow = EnsoulDefaultWnd_ItemBM_ItemWnd;                    
                }
                else
                {
                    Debug("Error (getItemSlotWindow) : Index is " @ string(SlotIndex));
                }
            }
        }
    }
    return targetItemWndow;
    return;
}

function bool hasItemInSlot(int SlotIndex)
{
    local ItemInfo Info;
    local bool flag;

    Info = getItemSlotInfo(SlotIndex);
    // End:0x56
    if(getItemSlotWindow(SlotIndex).GetItemNum() > 0)
    {
        Info = getItemSlotInfo(SlotIndex);
        // End:0x56
        if(Info.IconName != "")
        {
            flag = true;
        }
    }
    return flag;
    return;
}

function ItemInfo getItemSlotInfo(int SlotIndex)
{
    local ItemWindowHandle targetItemWndow;
    local ItemInfo Info;

    // End:0x19
    if(SlotIndex == 0)
    {
        targetItemWndow = EnsoulDefaultWnd_Item1_ItemWnd;        
    }
    else
    {
        // End:0x32
        if(SlotIndex == 1)
        {
            targetItemWndow = EnsoulDefaultWnd_Item2_ItemWnd;            
        }
        else
        {
            // End:0x4C
            if(SlotIndex == 2)
            {
                targetItemWndow = EnsoulDefaultWnd_Item3_ItemWnd;                
            }
            else
            {
                // End:0x66
                if(SlotIndex == 3)
                {
                    targetItemWndow = EnsoulDefaultWnd_ItemBM_ItemWnd;                    
                }
                else
                {
                    Debug("Error (getItemSlotWindow) : Index is " @ string(SlotIndex));
                }
            }
        }
    }
    targetItemWndow.GetItem(0, Info);
    return Info;
    return;
}

function CheckButtonState()
{
    return;
}

function InitWindows()
{
    EnsoulDefaultWnd_Select1_Texture.HideWindow();
    EnsoulDefaultWnd_Select2_Texture.HideWindow();
    EnsoulDefaultWnd_Step1block_Texture.ShowWindow();
    EnsoulDefaultWnd_Step2block_Texture.ShowWindow();
    EnsoulDefaultWnd_BMblock_Texture.ShowWindow();
    EnsoulDefaultWnd.HideWindow();
    EnsoulOptionWnd.HideWindow();
    EnsouEffectWnd.HideWindow();
    EnsoulProgressWnd.HideWindow();
    EnsoulWnd_ResultWnd.HideWindow();
    DisableWnd.HideWindow();
    EnsoulSubWndScript.setLock(false);
    EnsoulOK_Button.HideWindow();
    EnsoulCancelBtn.SetButtonName(3387);
    return;
}

function setWeaponEnsoulOptionSlot(ItemInfo tempInfo)
{
    local int N;

    N = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, 1);
    // End:0x3D
    if(N == 1)
    {
        EnsoulDefaultWnd_Step1block_Texture.HideWindow();        
    }
    else
    {
        // End:0x67
        if(N == 2)
        {
            EnsoulDefaultWnd_Step1block_Texture.HideWindow();
            EnsoulDefaultWnd_Step2block_Texture.HideWindow();
        }
    }
    N = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(tempInfo.Id, 2);
    // End:0xA2
    if(N > 0)
    {
        EnsoulDefaultWnd_BMblock_Texture.HideWindow();
    }
    return;
}

function bool isOpendEnsoulSlot(int SlotIndex)
{
    local bool RValue;

    switch(SlotIndex)
    {
        // End:0x26
        case 1:
            RValue = !EnsoulDefaultWnd_Step1block_Texture.IsShowWindow();
            // End:0x9C
            break;
        // End:0x46
        case 2:
            RValue = !EnsoulDefaultWnd_Step2block_Texture.IsShowWindow();
            // End:0x9C
            break;
        // End:0x66
        case 3:
            RValue = !EnsoulDefaultWnd_BMblock_Texture.IsShowWindow();
            // End:0x9C
            break;
        // End:0xFFFF
        default:
            Debug("Error isUseEnsoulSlot-> 잘못된 값을 넣었어!");
            break;
    }
    return RValue;
    return;
}

function setWindowStateSetting(string wndStateString)
{
    currentEnsoulState = wndStateString;
    // End:0xC8
    if(wndStateString == "STATE_INSERT_WEAPON")
    {
        InitWindows();
        clearWeponSlot();
        clearEnsoulStoneSlot();
        clearEnsoulOptionWnd();
        itemEnsoulRequestInfo.Length = 0;
        itemEnsoulRequestInfo.Length = 3;
        EnsoulDefaultWnd_Select1_Texture.ShowWindow();
        EnsoulDefaultWnd.ShowWindow();
        EnsoulSubWndScript.setTabIndex(0);
        EnsoulDiscription_TextBox.SetText(GetSystemMessage(4327));
        // End:0xB6
        if(isChangedWeaponEnsoulOption())
        {
            EnsoulCancelBtn.EnableWindow();            
        }
        else
        {
            EnsoulCancelBtn.DisableWindow();
        }        
    }
    else
    {
        // End:0x191
        if(wndStateString == "STATE_INSERT_ENSOULSTONE")
        {
            InitWindows();
            clearEnsoulOptionWnd();
            EnsoulDefaultWnd_Select2_Texture.ShowWindow();
            EnsoulDefaultWnd.ShowWindow();
            // End:0x131
            if(isChangedWeaponEnsoulOption())
            {
                EnsoulCancelBtn.EnableWindow();                
            }
            else
            {
                EnsoulCancelBtn.DisableWindow();
            }
            // End:0x174
            if(getItemSlotWindow(0).GetItemNum() > 0)
            {
                setWeaponEnsoulOptionSlot(getItemSlotInfo(0));
                EnsoulSubWndScript.setTabIndex(1);
            }
            EnsoulDiscription_TextBox.SetText(GetSystemMessage(4328));            
        }
        else
        {
            // End:0x253
            if(wndStateString == "STATE_SELECT_ENSOUL")
            {
                InitWindows();
                EnsoulSubWndScript.setLock(true);
                EnsoulOptionWnd.ShowWindow();
                EnsoulDiscription_TextBox.SetText(GetSystemMessage(4330));
                EnsoulOK_Button.EnableWindow();
                EnsoulOK_Button.ShowWindow();
                EnsoulOK_Button.SetButtonName(2234);
                EnsoulCancelBtn.EnableWindow();
                EnsoulCancelBtn.ShowWindow();
                EnsoulCancelBtn.SetButtonName(141);                
            }
            else
            {
                // End:0x312
                if(wndStateString == "STATE_CONFIRM_ENSOUL")
                {
                    InitWindows();
                    EnsoulSubWndScript.setLock(true);
                    EnsouEffectWnd.ShowWindow();
                    EnsoulProgressWnd.HideWindow();
                    EnsoulProgressWnd_ProgressBar.HideWindow();
                    askEnsoulLastProcess(true);
                    EnsoulOK_Button.EnableWindow();
                    EnsoulOK_Button.ShowWindow();
                    EnsoulOK_Button.SetButtonName(1337);
                    EnsoulCancelBtn.ShowWindow();
                    EnsoulCancelBtn.SetButtonName(141);                    
                }
                else
                {
                    // End:0x37C
                    if(wndStateString == "STATE_RESULT")
                    {
                        InitWindows();
                        EnsoulSubWndScript.setLock(true);
                        EnsouEffectWnd.ShowWindow();
                        EnsoulProgressWnd.ShowWindow();
                        EnsoulWnd_ResultWnd.ShowWindow();
                        DisableWnd.ShowWindow();
                    }
                }
            }
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x21
        case 10060:
            Me.ShowWindow();
            // End:0x58
            break;
        // End:0x37
        case 10061:
            showResult(param);
            // End:0x58
            break;
        // End:0x42
        case 1710:
            // End:0x58
            break;
        // End:0x4D
        case 1720:
            // End:0x58
            break;
        // End:0x55
        case 40:
            // End:0x58
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string Name)
{
    local LVDataRecord Record;
    local ItemInfo Info;
    local EnsoulStoneUIInfo refEnsoulStoneUIInfo;

    switch(Name)
    {
        // End:0x263
        case "EnsoulOK_Button":
            // End:0x160
            if((getCurrentEnsoulState()) == "STATE_SELECT_ENSOUL")
            {
                // End:0x138
                if(EnsoulOptionWnd_ListCtrl.GetSelectedIndex() > -1)
                {
                    EnsoulOptionWnd_ListCtrl.GetSelectedRec(Record);
                    // End:0x135
                    if(Record.LVDataList[0].nReserved2 > 0)
                    {
                        GetEnsoulOptionUIInfo(Record.LVDataList[0].nReserved2, selectedEnsoulOptionUIInfo);
                        // End:0x135
                        if(EnsoulOptionWnd_ITEM2_ItemWnd.GetItemNum() > 0)
                        {
                            EnsoulOptionWnd_ITEM2_ItemWnd.GetItem(0, Info);
                            // End:0xF4
                            if(overwriteSlotIndex > 0)
                            {
                                applySelectdEnsoulOption(overwriteSlotIndex, Info, Record.LVDataList[0].nReserved2);                                
                            }
                            else
                            {
                                applySelectdEnsoulOption(currentOpenEnsoulStoneSlot, Info, Record.LVDataList[0].nReserved2);
                            }
                            setWindowStateSetting("STATE_INSERT_ENSOULSTONE");
                        }
                    }                    
                }
                else
                {
                    EnsoulDiscription_TextBox.SetText(GetSystemMessage(4345));
                    AddSystemMessage(4345);
                }                
            }
            else
            {
                // End:0x1A4
                if((getCurrentEnsoulState()) == "STATE_INSERT_ENSOULSTONE")
                {
                    setWindowStateSetting("STATE_CONFIRM_ENSOUL");                    
                }
                else
                {
                    // End:0x260
                    if((getCurrentEnsoulState()) == "STATE_CONFIRM_ENSOUL")
                    {
                        EnsoulOK_Button.DisableWindow();
                        EnsoulProgressWnd.ShowWindow();
                        EnsoulProgressWnd_ProgressBar.ShowWindow();
                        EnsoulProgressWnd_ProgressBar.Reset();
                        EnsoulProgressWnd_ProgressBar.SetProgressTime(1500);
                        EnsoulProgressWnd_ProgressBar.Start();
                        EnsoulDiscription_TextBox.SetText(GetSystemMessage(4336));
                        PlaySound("ItemSound3.enchant_process");
                    }
                }
            }
            // End:0x517
            break;
        // End:0x408
        case "EnsoulCancelBtn":
            // End:0x2CB
            if(currentEnsoulState == "STATE_SELECT_ENSOUL")
            {
                slotJamStoneFee[currentOpenEnsoulStoneSlot - 1] = (0);
                setWindowStateSetting("STATE_INSERT_ENSOULSTONE");                
            }
            else
            {
                // End:0x39B
                if(currentEnsoulState == "STATE_CONFIRM_ENSOUL")
                {
                    // End:0x378
                    if(EnsoulProgressWnd_ProgressBar.IsShowWindow())
                    {
                        StopSound("ItemSound3.enchant_process");
                        EnsoulDiscription_TextBox.SetText(GetSystemMessage(4335));
                        EnsoulProgressWnd_ProgressBar.Stop();
                        EnsoulProgressWnd_ProgressBar.Reset();
                        EnsoulProgressWnd_ProgressBar.HideWindow();
                        EnsoulOK_Button.EnableWindow();                        
                    }
                    else
                    {
                        setWindowStateSetting("STATE_INSERT_ENSOULSTONE");
                    }                    
                }
                else
                {
                    // End:0x405
                    if((currentEnsoulState == "STATE_INSERT_ENSOULSTONE") || currentEnsoulState == "STATE_INSERT_WEAPON")
                    {
                        // End:0x405
                        if(isChangedWeaponEnsoulOption())
                        {
                            setWindowStateSetting("STATE_CONFIRM_ENSOUL");
                        }
                    }
                }
            }
            // End:0x517
            break;
        // End:0x427
        case "EnsoulInfo_Button":
            OnHelpBtnClick();
            // End:0x517
            break;
        // End:0x4C6
        case "OK_Button":
            setWindowStateSetting("STATE_SELECT_ENSOUL");
            GetEnsoulStoneUIInfo(overwriteItemInfo.Id, refEnsoulStoneUIInfo);
            Debug("overwriteSlotIndex" @ string(overwriteSlotIndex));
            // End:0x49F
            if(overwriteSlotIndex > 0)
            {
                removeEnsoulStone(overwriteSlotIndex, true);
            }
            applySelectOptionInEnsoulStone(overwriteSlotIndex, getItemSlotInfo(0), overwriteItemInfo, refEnsoulStoneUIInfo, true);
            askOverwriteEnsoulOption(false);
            // End:0x517
            break;
        // End:0x4E2
        case "Cancel_Button":
            askOverwriteEnsoulOption(false);
            // End:0x517
            break;
        // End:0x514
        case "singleOK_Button":
            setWindowStateSetting("STATE_INSERT_WEAPON");
            // End:0x517
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnHelpBtnClick()
{
    local string strParam;

    // End:0x71
    if(getInstanceUIData().getIsClassicServer())
    {
        ParamAdd(strParam, "FilePath", "..\\L2text_Classic\\blacksmith_ensoul_help_classic.htm");
        ExecuteEvent(1210, strParam);        
    }
    else
    {
        ExecuteEvent(1210, "40");
    }
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    local LVDataRecord Record;
    local int nSelect;

    nSelect = EnsoulOptionWnd_ListCtrl.GetSelectedIndex();
    // End:0x34
    if(nSelect >= 0)
    {
        EnsoulOptionWnd_ListCtrl.GetSelectedRec(Record);
    }
    return;
}

function OnDropItemSource(string strTarget, ItemInfo Info)
{
    // End:0xD7
    if(strTarget == "Console")
    {
        switch(Info.DragSrcName)
        {
            // End:0x4B
            case "EnsoulDefaultWnd_Item1_ItemWnd":
                removeWeaponItem();
                // End:0xD7
                break;
            // End:0x78
            case "EnsoulDefaultWnd_Item2_ItemWnd":
                removeEnsoulStone(1);
                // End:0xD7
                break;
            // End:0xA6
            case "EnsoulDefaultWnd_Item3_ItemWnd":
                removeEnsoulStone(2);
                // End:0xD7
                break;
            // End:0xD4
            case "EnsoulDefaultWnd_Item3_ItemWnd":
                removeEnsoulStone(3);
                // End:0xD7
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return;
    }
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    local Rect rectWnd, DragDropItemRect1, DragDropItemRect2, DragDropItemRect3, DragDropItemRectBM, DragDropItemRectAll,
	    OptionSelectEnsoulStoneRect;

    rectWnd = Me.GetRect();
    DragDropItemRect1 = EnsoulOptionWnd_Groupbox1_Texture.GetRect();
    DragDropItemRect2 = EnsoulDefaultWnd_Step1block_Texture.GetRect();
    DragDropItemRect3 = EnsoulDefaultWnd_Step2block_Texture.GetRect();
    DragDropItemRectBM = EnsoulDefaultWnd_BMblock_Texture.GetRect();
    DragDropItemRectAll = EnsoulDefaultWnd_Groupbox2_Texture.GetRect();
    OptionSelectEnsoulStoneRect = EnsoulOptionWnd_Groupbox2_Texture.GetRect();
    // End:0xDE
    if((a_ItemInfo.DragSrcName == "EnsoulSubWnd_Item1") || a_ItemInfo.DragSrcName == "EnsoulSubWnd_Item2")
    {        
    }
    else
    {
        return;
    }
    // End:0x39B
    if((currentEnsoulState == "STATE_INSERT_WEAPON") || currentEnsoulState == "STATE_INSERT_ENSOULSTONE")
    {
        // End:0x1A1
        if((((X > DragDropItemRect1.nX) && X < (DragDropItemRect1.nX + DragDropItemRect1.nWidth)) && Y > DragDropItemRect1.nY) && Y < (DragDropItemRect1.nY + DragDropItemRect1.nHeight))
        {
            InsertWeapon(a_ItemInfo);            
        }
        else
        {
            // End:0x21E
            if((((X > DragDropItemRect2.nX) && X < (DragDropItemRect2.nX + DragDropItemRect2.nWidth)) && Y > DragDropItemRect2.nY) && Y < (DragDropItemRect2.nY + DragDropItemRect2.nHeight))
            {
                InsertEnsoulStone(1, a_ItemInfo);                
            }
            else
            {
                // End:0x29C
                if((((X > DragDropItemRect3.nX) && X < (DragDropItemRect3.nX + DragDropItemRect3.nWidth)) && Y > DragDropItemRect3.nY) && Y < (DragDropItemRect3.nY + DragDropItemRect3.nHeight))
                {
                    InsertEnsoulStone(2, a_ItemInfo);                    
                }
                else
                {
                    // End:0x31A
                    if((((X > DragDropItemRectBM.nX) && X < (DragDropItemRectBM.nX + DragDropItemRectBM.nWidth)) && Y > DragDropItemRectBM.nY) && Y < (DragDropItemRectBM.nY + DragDropItemRectBM.nHeight))
                    {
                        InsertEnsoulStone(3, a_ItemInfo);                        
                    }
                    else
                    {
                        // End:0x398
                        if((((X > DragDropItemRectAll.nX) && X < (DragDropItemRectAll.nX + DragDropItemRectAll.nWidth)) && Y > DragDropItemRectAll.nY) && Y < (DragDropItemRectAll.nY + DragDropItemRectAll.nHeight))
                        {
                            InsertEnsoulStone(-1, a_ItemInfo);
                        }
                    }
                }
            }
        }        
    }
    else
    {
        // End:0x438
        if(currentEnsoulState == "STATE_SELECT_ENSOUL")
        {
            // End:0x438
            if((((X > OptionSelectEnsoulStoneRect.nX) && X < (OptionSelectEnsoulStoneRect.nX + OptionSelectEnsoulStoneRect.nWidth)) && Y > OptionSelectEnsoulStoneRect.nY) && Y < (OptionSelectEnsoulStoneRect.nY + OptionSelectEnsoulStoneRect.nHeight))
            {
                InsertEnsoulStone(currentOpenEnsoulStoneSlot, a_ItemInfo);
            }
        }
    }
    return;
}

function OnDBClickItem(string ControlName, int Index)
{
    // End:0x33
    if(ControlName == "EnsoulDefaultWnd_Item1_ItemWnd")
    {
        removeWeaponItem();        
    }
    else
    {
        // End:0x67
        if(ControlName == "EnsoulDefaultWnd_Item2_ItemWnd")
        {
            removeEnsoulStone(1);            
        }
        else
        {
            // End:0x9C
            if(ControlName == "EnsoulDefaultWnd_Item3_ItemWnd")
            {
                removeEnsoulStone(2);                
            }
            else
            {
                // End:0xD2
                if(ControlName == "EnsoulDefaultWnd_ItemBM_ItemWnd")
                {
                    removeEnsoulStone(3);                    
                }
                else
                {
                    // End:0xFE
                    if(ControlName == "EnsoulOptionWnd_ITEM1_ItemWnd")
                    {                        
                    }
                    else
                    {
                        // End:0x127
                        if(ControlName == "EnsoulOptionWnd_ITEM2_ItemWnd")
                        {
                        }
                    }
                }
            }
        }
    }
    return;
}

function OnRClickItem(string strID, int Index)
{
    OnDBClickItem(strID, Index);
    return;
}

function InsertWeapon(ItemInfo Info)
{
    local string FullName;

    PlaySound("ItemSound3.enchant_input");
    setWindowStateSetting("STATE_INSERT_WEAPON");
    // End:0x50
    if(Info.ItemType != int(0))
    {
        return;
    }
    // End:0xA1
    if(EnsoulDefaultWnd_Item1_ItemWnd.GetItemNum() > 0)
    {
        util.ItemWIndow_ItemMoveByIndex(getItemSlotWindow(0), EnsoulSubWnd_WeaponItemWindow, 0);
        EnsoulDefaultWnd_WeaponName_TextBox.SetTooltipType("");
        EnsoulDefaultWnd_WeaponName_TextBox.ClearTooltip();
    }
    util.ItemWIndow_ItemMoveByItemID(EnsoulSubWnd_WeaponItemWindow, getItemSlotWindow(0), Info.Id);
    // End:0x1A4
    if(Info.Id.ClassID > 0)
    {
        normalSlotCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(Info.Id, 1);
        bmSlotCount = Class'NWindow.UIDATA_ENSOUL'.static.GetEnsoulSlotCount(Info.Id, 2);
        EnsoulDefaultWnd_SlotBg1Light_Texture.HideWindow();
        EnsoulDefaultWnd_SlotBg2Light_Texture.HideWindow();
        EnsoulDefaultWnd_SlotBg3Light_Texture.HideWindow();
        FullName = GetItemNameAll(Info);
        util.textBox_setToolTipWithShortString(EnsoulDefaultWnd_WeaponName_TextBox, FullName);
        clearEnsoulStoneSlot();
        setWindowStateSetting("STATE_INSERT_ENSOULSTONE");
        applyWeaponEnsoulInfo(Info);
    }
    return;
}

function InsertEnsoulStone(int SlotIndex, ItemInfo eInfo)
{
    local EnsoulStoneUIInfo refEnsoulStoneUIInfo;
    local ItemInfo weaponInfo, nullInfo;

    PlaySound("ItemSound3.enchant_input");
    // End:0x7D
    if(getItemSlotInfo(0).Id.ClassID <= 0)
    {
        Debug("error : InsertEnsoulStone(..) --> 무기를 넣으세요");
        AddSystemMessage(4326);
        return;
    }
    // End:0xD8
    if(eInfo.ItemSubType != int(60))
    {
        Debug("error : InsertEnsoulStone(..) --> 집혼석이 아닙니다");
        AddSystemMessage(4329);
        return;
    }
    // End:0xF9
    if(IsStackableItem(eInfo.ConsumeType))
    {
        eInfo.ItemNum = (1);
    }
    GetEnsoulStoneUIInfo(eInfo.Id, refEnsoulStoneUIInfo);
    Debug("넣은 아이템의 슬롯 타입 refEnsoulStoneUIInfo.SlotType" @ string(refEnsoulStoneUIInfo.slotType));
    // End:0x34E
    if(refEnsoulStoneUIInfo.slotType == 1)
    {
        // End:0x23A
        if(normalSlotCount >= 2)
        {
            // End:0x19A
            if(!hasItemInSlot(1) && !hasItemInSlot(2))
            {
                SlotIndex = 1;                
            }
            else
            {
                // End:0x237
                if((SlotIndex == 3) || SlotIndex == -1)
                {
                    // End:0x1DA
                    if(!hasItemInSlot(1) && hasItemInSlot(2))
                    {
                        SlotIndex = 1;                        
                    }
                    else
                    {
                        // End:0x1FE
                        if((hasItemInSlot(1)) && !hasItemInSlot(2))
                        {
                            SlotIndex = 2;                            
                        }
                        else
                        {
                            // End:0x22A
                            if((SlotIndex == 3) && refEnsoulStoneUIInfo.slotType == 1)
                            {
                                AddSystemMessage(4349);                                
                            }
                            else
                            {
                                AddSystemMessage(4350);
                            }
                            return;
                        }
                    }
                }
            }            
        }
        else
        {
            // End:0x255
            if(normalSlotCount <= 0)
            {
                AddSystemMessage(4349);
                return;                
            }
            else
            {
                // End:0x280
                if((SlotIndex == 3) && refEnsoulStoneUIInfo.slotType == 1)
                {
                    AddSystemMessage(4349);
                    return;
                }
                SlotIndex = 1;
            }
        }
        // End:0x2C7
        if(checkAlreadyEOptionedSlot(SlotIndex))
        {
            overwriteSlotIndex = SlotIndex;
            overwriteItemInfo = eInfo;
            currentOpenEnsoulStoneSlot = SlotIndex;
            askOverwriteEnsoulOption(true, eInfo);
            return;            
        }
        else
        {
            overwriteSlotIndex = 0;
            overwriteItemInfo = nullInfo;
        }
        // End:0x34B
        if((SlotIndex == 1) || SlotIndex == 2)
        {
            setWindowStateSetting("STATE_SELECT_ENSOUL");
            weaponInfo = getItemSlotInfo(0);
            removeEnsoulStone(SlotIndex, true);
            currentOpenEnsoulStoneSlot = SlotIndex;
            applySelectOptionInEnsoulStone(currentOpenEnsoulStoneSlot, weaponInfo, eInfo, refEnsoulStoneUIInfo);
        }        
    }
    else
    {
        // End:0x421
        if(refEnsoulStoneUIInfo.slotType == 2)
        {
            // End:0x37A
            if(bmSlotCount <= 0)
            {
                AddSystemMessage(4349);
                return;                
            }
            else
            {
                SlotIndex = 3;
                // End:0x3B7
                if(checkAlreadyEOptionedSlot(SlotIndex))
                {
                    overwriteSlotIndex = SlotIndex;
                    overwriteItemInfo = eInfo;
                    askOverwriteEnsoulOption(true, eInfo);
                    return;                    
                }
                else
                {
                    overwriteSlotIndex = 0;
                    overwriteItemInfo = nullInfo;
                }
                currentOpenEnsoulStoneSlot = SlotIndex;
                setWindowStateSetting("STATE_SELECT_ENSOUL");
                weaponInfo = getItemSlotInfo(0);
                currentOpenEnsoulStoneSlot = SlotIndex;
                applySelectOptionInEnsoulStone(currentOpenEnsoulStoneSlot, weaponInfo, eInfo, refEnsoulStoneUIInfo);
            }
        }
    }
    return;
}

function setEnsoulSlotText(int SlotIndex, EnsoulOptionUIInfo eOptionInfo, optional bool bDelete, optional string applyAddString, optional Color applyColor)
{
    local TextBoxHandle soulNameTextBox, soulDescTextBox;
    local CustomTooltip cTooltip;

    // End:0x24
    if(SlotIndex == 1)
    {
        soulNameTextBox = EnsoulDefaultWnd_SoulName1_TextBox;
        soulDescTextBox = EnsoulDefaultWnd_Soul1_TextBox;        
    }
    else
    {
        // End:0x49
        if(SlotIndex == 2)
        {
            soulNameTextBox = EnsoulDefaultWnd_SoulName2_TextBox;
            soulDescTextBox = EnsoulDefaultWnd_Soul2_TextBox;            
        }
        else
        {
            // End:0x6B
            if(SlotIndex == 3)
            {
                soulNameTextBox = EnsoulDefaultWnd_SoulName3_TextBox;
                soulDescTextBox = EnsoulDefaultWnd_Soul3_TextBox;
            }
        }
    }
    // End:0xB9
    if(((int(applyColor.R) != 0) && int(applyColor.G) != 0) && int(applyColor.B) != 0)
    {
        soulNameTextBox.SetTextColor(applyColor);
    }
    // End:0xDB
    if(bDelete)
    {
        textBoxClear(soulNameTextBox);
        textBoxClear(soulDescTextBox);        
    }
    else
    {
        // End:0x130
        if(eOptionInfo.OptionStep > 0)
        {
            util.textBox_setToolTipWithShortString(soulNameTextBox, MakeFullSystemMsg(GetSystemMessage(4347), applyAddString $ eOptionInfo.Name, string(eOptionInfo.OptionStep)));            
        }
        else
        {
            util.textBox_setToolTipWithShortString(soulNameTextBox, applyAddString $ eOptionInfo.Name);
        }
        util.textBox_setToolTipWithShortString(soulDescTextBox, eOptionInfo.Desc);
        addToolTipDrawList(cTooltip, addDrawItemTexture(eOptionInfo.IconPanelTex, false, false, 2));
        addToolTipDrawList(cTooltip, addDrawItemTexture(eOptionInfo.Icontex, false, false, -16));
        addToolTipDrawList(cTooltip, addDrawItemText(eOptionInfo.Name, util.White, "", false));
        addToolTipDrawList(cTooltip, addDrawItemText(" : ", util.White, "", false));
        addToolTipDrawList(cTooltip, addDrawItemText(eOptionInfo.Desc, util.ColorDesc, "", false));
        addToolTipDrawList(cTooltip, addDrawItemBlank(1));
        soulDescTextBox.SetTooltipType("text");
        soulDescTextBox.SetTooltipCustomType(cTooltip);
    }
    return;
}

function removeEnsoulStone(int SlotIndex, optional bool noSystemMessage)
{
    local ItemWindowHandle targetItemWnd;
    local TextBoxHandle soulNameTextBox, soulDescTextBox;
    local EnsoulOptionUIInfo eOptionInfo;
    local ItemInfo tmInfo;
    local ItemEnsoulRequest nullItemEnsoulRequestInfo;
    local bool needSwapSlot;

    // End:0x6D
    if(getItemSlotWindow(SlotIndex).GetItemNum() > 0)
    {
        tmInfo = getItemSlotInfo(SlotIndex);
        // End:0x6D
        if((tmInfo.Id.ClassID <= 0) && tmInfo.Name == "")
        {
            // End:0x6B
            if(noSystemMessage == false)
            {
                AddSystemMessage(4348);
            }
            return;
        }
    }
    slotJamStoneFee[SlotIndex - 1] = (0);
    // End:0xD5
    if(SlotIndex == 1)
    {
        targetItemWnd = EnsoulDefaultWnd_Item2_ItemWnd;
        soulNameTextBox = EnsoulDefaultWnd_SoulName1_TextBox;
        soulDescTextBox = EnsoulDefaultWnd_Soul1_TextBox;
        itemEnsoulRequestInfo[0] = nullItemEnsoulRequestInfo;
        // End:0xD2
        if(itemEnsoulRequestInfo[1].selectedOptionID > 0)
        {
            needSwapSlot = true;
        }        
    }
    else
    {
        // End:0x112
        if(SlotIndex == 2)
        {
            targetItemWnd = EnsoulDefaultWnd_Item3_ItemWnd;
            soulNameTextBox = EnsoulDefaultWnd_SoulName2_TextBox;
            soulDescTextBox = EnsoulDefaultWnd_Soul2_TextBox;
            itemEnsoulRequestInfo[1] = nullItemEnsoulRequestInfo;            
        }
        else
        {
            // End:0x14D
            if(SlotIndex == 3)
            {
                targetItemWnd = EnsoulDefaultWnd_ItemBM_ItemWnd;
                soulNameTextBox = EnsoulDefaultWnd_SoulName3_TextBox;
                soulDescTextBox = EnsoulDefaultWnd_Soul3_TextBox;
                itemEnsoulRequestInfo[2] = nullItemEnsoulRequestInfo;
            }
        }
    }
    // End:0x19E
    if(SlotIndex > 0)
    {
        // End:0x19E
        if(targetItemWnd.GetItemNum() > 0)
        {
            util.ItemWIndow_ItemMoveByIndex(targetItemWnd, EnsoulSubWnd_EnsoulItemWindow, 0, true);
            textBoxClear(soulNameTextBox);
            textBoxClear(soulDescTextBox);
        }
    }
    // End:0x1B9
    if(isChangedWeaponEnsoulOption())
    {
        EnsoulCancelBtn.EnableWindow();        
    }
    else
    {
        EnsoulCancelBtn.DisableWindow();
    }
    // End:0x1E5
    if(checkAlreadyEOptionedSlot(SlotIndex))
    {
        applyWeaponEnsoulInfo(getItemSlotInfo(0));
        return;
    }
    // End:0x285
    if(needSwapSlot)
    {
        swapItemWithSubInven(getItemSlotWindow(2), getItemSlotWindow(1), getItemSlotInfo(2));
        util.ItemWIndow_ItemMoveByIndex(getItemSlotWindow(2), getItemSlotWindow(1), 0);
        itemEnsoulRequestInfo[0] = itemEnsoulRequestInfo[1];
        itemEnsoulRequestInfo[1] = nullItemEnsoulRequestInfo;
        itemEnsoulRequestInfo[0].clientSlotIndex = 1;
        GetEnsoulOptionUIInfo(itemEnsoulRequestInfo[0].selectedOptionID, eOptionInfo);
        setEnsoulSlotText(1, eOptionInfo);
        setEnsoulSlotText(2, eOptionInfo, true);
    }
    return;
}

function removeWeaponItem()
{
    // End:0x4E
    if(getItemSlotWindow(0).GetItemNum() > 0)
    {
        util.ItemWIndow_ItemMoveByIndex(getItemSlotWindow(0), EnsoulSubWnd_WeaponItemWindow, 0);
        setWindowStateSetting("STATE_INSERT_WEAPON");
    }
    return;
}

function clearWeponSlot()
{
    getItemSlotWindow(0).Clear();
    textBoxClear(EnsoulDefaultWnd_WeaponName_TextBox);
    return;
}

function clearEnsoulStoneSlot()
{
    getItemSlotWindow(1).Clear();
    getItemSlotWindow(2).Clear();
    getItemSlotWindow(3).Clear();
    textBoxClear(EnsoulDefaultWnd_Soul1_TextBox);
    textBoxClear(EnsoulDefaultWnd_Soul2_TextBox);
    textBoxClear(EnsoulDefaultWnd_Soul3_TextBox);
    textBoxClear(EnsoulDefaultWnd_SoulName1_TextBox);
    textBoxClear(EnsoulDefaultWnd_SoulName2_TextBox);
    textBoxClear(EnsoulDefaultWnd_SoulName3_TextBox);
    return;
}

function swapItemWithSubInven(ItemWindowHandle targetItemWnd, ItemWindowHandle subInvenItemWnd, ItemInfo Info)
{
    // End:0x2F
    if(targetItemWnd.GetItemNum() > 0)
    {
        util.ItemWIndow_ItemMoveByIndex(targetItemWnd, subInvenItemWnd, 0);
    }
    targetItemWnd.Clear();
    util.ItemWIndow_ItemMoveByItemID(subInvenItemWnd, targetItemWnd, Info.Id);
    return;
}

function applySelectdEnsoulOption(int SlotIndex, ItemInfo eStoneitemInfo, int selectedOptionID)
{
    local ItemWindowHandle targetItemWndow;
    local EnsoulOptionUIInfo eOptionInfo;
    local ItemEnsoulRequest tempItemEnsoulRequest;

    targetItemWndow = getItemSlotWindow(SlotIndex);
    targetItemWndow.Clear();
    targetItemWndow.AddItem(eStoneitemInfo);
    GetEnsoulOptionUIInfo(selectedOptionID, eOptionInfo);
    // End:0x8B
    if(SlotIndex == overwriteSlotIndex)
    {
        setEnsoulSlotText(SlotIndex, eOptionInfo,, ("(" $ GetSystemString(3395)) $ ") ", util.ColorYellow);        
    }
    else
    {
        setEnsoulSlotText(SlotIndex, eOptionInfo,,, util.ColorYellow);
    }
    selectedOptionSlotArray[SlotIndex - 1] = eOptionInfo;
    tempItemEnsoulRequest.ensoulStoneServerID = eStoneitemInfo.Id.ServerID;
    tempItemEnsoulRequest.selectedOptionID = selectedOptionID;
    tempItemEnsoulRequest.selectedOptionType = eOptionInfo.optionType;
    tempItemEnsoulRequest.clientSlotIndex = getSlotIndexForClient(SlotIndex);
    tempItemEnsoulRequest.clientSlotType = getSlotTypeForClient(SlotIndex);
    itemEnsoulRequestInfo[SlotIndex - 1] = tempItemEnsoulRequest;
    return;
}

function applyWeaponEnsoulInfo(ItemInfo Info)
{
    local int N, i, Cnt, optionId, rIndex;

    local EnsoulOptionUIInfo optionInfo;
    local ItemInfo esInfo;

    alreadyHasOptionSlotArray.Length = 0;
    selectedOptionSlotArray.Length = 0;
    selectedOptionSlotArray.Length = 3;
    slotJamStoneFee.Length = 0;
    slotJamStoneFee.Length = 3;
    slotJamStoneFee[0] = (0);
    slotJamStoneFee[1] = (0);
    slotJamStoneFee[2] = (0);
    i = 1;
    J0x53:

    // End:0x345 [Loop If]
    if(i < 3)
    {
        Cnt = Info.EnsoulOption[i - 1].OptionArray.Length;
        N = 1;
        J0x85:

        // End:0x33B [Loop If]
        if(N < (1 + Cnt))
        {
            optionId = Info.EnsoulOption[i - 1].OptionArray[N - 1];
            Debug("무기 조회 optionID" @ string(optionId));
            // End:0xFF
            if(optionId > 0)
            {
                GetEnsoulOptionUIInfo(optionId, optionInfo);                
            }
            else
            {
                // [Explicit Continue]
                goto J0x331;
            }
            // End:0x331
            if(optionId > 0)
            {
                alreadyHasOptionSlotArray.Length = alreadyHasOptionSlotArray.Length + 1;
                alreadyHasOptionSlotArray[alreadyHasOptionSlotArray.Length - 1].Info = Info;
                alreadyHasOptionSlotArray[alreadyHasOptionSlotArray.Length - 1].eOptionUIInfo = optionInfo;
                alreadyHasOptionSlotArray[alreadyHasOptionSlotArray.Length - 1].slotType = i;
                // End:0x182
                if(i == 2)
                {
                    rIndex = 3;                    
                }
                else
                {
                    rIndex = N;
                }
                alreadyHasOptionSlotArray[alreadyHasOptionSlotArray.Length - 1].SlotIndex = rIndex;
                esInfo.IconName = optionInfo.Icontex;
                // End:0x2B5
                if(i == 1)
                {
                    // End:0x242
                    if(N == 1)
                    {
                        // End:0x23F
                        if(getItemSlotWindow(1).GetItemNum() == 0)
                        {
                            getItemSlotWindow(1).AddItem(esInfo);
                            setEnsoulSlotText(1, optionInfo,, ("(" $ GetSystemString(3351)) $ ") ", util.ColorLightBrown);
                            EnsoulDefaultWnd_SlotBg1Light_Texture.ShowWindow();
                        }                        
                    }
                    else
                    {
                        // End:0x2B2
                        if(getItemSlotWindow(2).GetItemNum() == 0)
                        {
                            getItemSlotWindow(2).AddItem(esInfo);
                            setEnsoulSlotText(2, optionInfo,, ("(" $ GetSystemString(3351)) $ ") ", util.ColorLightBrown);
                            EnsoulDefaultWnd_SlotBg2Light_Texture.ShowWindow();
                        }
                    }
                    // [Explicit Continue]
                    goto J0x331;
                }
                // End:0x331
                if(i == 2)
                {
                    // End:0x331
                    if(getItemSlotWindow(3).GetItemNum() == 0)
                    {
                        getItemSlotWindow(3).AddItem(esInfo);
                        setEnsoulSlotText(3, optionInfo,, ("(" $ GetSystemString(3351)) $ ") ", util.ColorLightBrown);
                        EnsoulDefaultWnd_SlotBg3Light_Texture.ShowWindow();
                    }
                }
            }
            J0x331:

            N++;
            // [Loop Continue]
            goto J0x85;
        }
        i++;
        // [Loop Continue]
        goto J0x53;
    }
    return;
}

function int getSlotIndexForClient(int SlotIndex)
{
    local int RValue;

    // End:0x27
    if((SlotIndex == 1) || SlotIndex == 2)
    {
        RValue = SlotIndex;        
    }
    else
    {
        // End:0x3D
        if(SlotIndex == 3)
        {
            RValue = 1;            
        }
        else
        {
            Debug("Error : getSlotIndexForClient ->" @ string(SlotIndex));
        }
    }
    return RValue;
    return;
}

function int getSlotTypeForClient(int SlotIndex)
{
    local int RValue;

    // End:0x23
    if((SlotIndex == 1) || SlotIndex == 2)
    {
        RValue = 1;        
    }
    else
    {
        // End:0x3A
        if(SlotIndex == 3)
        {
            RValue = 2;            
        }
        else
        {
            Debug("Error : getSlotTypeForClient ->" @ string(SlotIndex));
        }
    }
    return RValue;
    return;
}

function applySelectOptionInEnsoulStone(int SlotIndex, ItemInfo weaponInfo, ItemInfo eInfo, EnsoulStoneUIInfo esInfo, optional bool isOverwriteOption)
{
    local EnsoulOptionUIInfo optionInfo;
    local EnsoulFeeUIInfo ensoulFeeInfo;
    local int i;
    local LVDataRecord Record;
    local ItemInfo jamStoneInfo, InvenJamStoneInfo;
    local INT64 decUseJamStone;
    local string jamStoneValueComma;

    EnsoulOptionWnd_ListCtrl.DeleteAllItem();
    EnsoulOptionWnd_ListCtrl.ShowWindow();
    util.textBox_setToolTipWithShortString(EnsoulOptionWnd_WeaponName_TextBox, weaponInfo.Name);
    util.textBox_setToolTipWithShortString(EnsoulOptionWnd_SoulName_TextBox, eInfo.Name);
    EnsoulOptionWnd_ITEM1_ItemWnd.Clear();
    EnsoulOptionWnd_ITEM1_ItemWnd.AddItem(weaponInfo);
    EnsoulOptionWnd_ITEM2_ItemWnd.Clear();
    EnsoulOptionWnd_ITEM2_ItemWnd.AddItem(eInfo);
    Debug("esinfo.OptionId_Array.Length" @ string(esInfo.OptionId_Array.Length));
    i = 0;
    J0xDA:

    // End:0x453 [Loop If]
    if(i < esInfo.OptionId_Array.Length)
    {
        GetEnsoulOptionUIInfo(esInfo.OptionId_Array[i], optionInfo);
        // End:0x2C0
        if(((((isOverwriteOption == true) && (hasSelectedEnsoulOptionTypeOtherSlot(optionInfo.optionType, SlotIndex)) == false) && (hasSelectedEnsoulOptionIdOtherSlot(optionInfo.optionId)) == false) && (hasWeaponOptionTypeOtherSlot(optionInfo.optionType, SlotIndex)) == false) && (hasWeaponOptionIdOtherSlot(optionInfo.optionId)) == false)
        {
            Record.LVDataList.Length = 1;
            Record.LVDataList[0].bUseTextColor = true;
            Record.LVDataList[0].TextColor = util.ColorDesc;
            // End:0x219
            if(optionInfo.OptionStep > 0)
            {
                Record.LVDataList[0].szData = makeShortStringByPixel(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), 230, "..");                
            }
            else
            {
                Record.LVDataList[0].szData = makeShortStringByPixel(optionInfo.Name, 230, "..");
            }
            Record.LVDataList[0].nReserved1 = optionInfo.optionType;
            Record.LVDataList[0].nReserved2 = esInfo.OptionId_Array[i];
            Debug("리스트에 넣는다. .Name" @ optionInfo.Name);
            EnsoulOptionWnd_ListCtrl.InsertRecord(Record);
            // [Explicit Continue]
            goto J0x449;
        }
        // End:0x449
        if(((((isOverwriteOption == false) && (hasSelectedEnsoulOptionTypeOtherSlot(optionInfo.optionType, SlotIndex)) == false) && (hasSelectedEnsoulOptionIdOtherSlot(optionInfo.optionId)) == false) && (hasWeaponOptionTypeOtherSlot(optionInfo.optionType, SlotIndex)) == false) && (hasWeaponOptionIdOtherSlot(optionInfo.optionId)) == false)
        {
            Record.LVDataList.Length = 1;
            Record.LVDataList[0].bUseTextColor = true;
            Record.LVDataList[0].TextColor = util.ColorDesc;
            // End:0x3CF
            if(optionInfo.OptionStep > 0)
            {
                Record.LVDataList[0].szData = makeShortStringByPixel(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), 230, "..");                
            }
            else
            {
                Record.LVDataList[0].szData = makeShortStringByPixel(optionInfo.Name, 230, "..");
            }
            Record.LVDataList[0].nReserved1 = optionInfo.optionType;
            Record.LVDataList[0].nReserved2 = esInfo.OptionId_Array[i];
            EnsoulOptionWnd_ListCtrl.InsertRecord(Record);
        }
        J0x449:

        i++;
        // [Loop Continue]
        goto J0xDA;
    }
    GetEnsoulFeeUIInfo(weaponInfo.CrystalType, checkAlreadyEOptionedSlot(SlotIndex), esInfo.slotType, getSlotIndexForClient(SlotIndex), ensoulFeeInfo);
    inventoryWndScript.getInventoryItemInfo(GetItemID(ensoulFeeInfo.nID), InvenJamStoneInfo);
    Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ensoulFeeInfo.nID), jamStoneInfo);
    slotJamStoneFee[SlotIndex - 1] = ensoulFeeInfo.ItemCount;
    i = 0;
    J0x4F0:

    // End:0x531 [Loop If]
    if(i < 3)
    {
        // End:0x527
        if(SlotIndex != (i + 1))
        {
            decUseJamStone = __NFUN_404__(decUseJamStone, slotJamStoneFee[i]);
        }
        i++;
        // [Loop Continue]
        goto J0x4F0;
    }
    util.textBox_setToolTipWithShortString(EnsoulOptionWnd_Charge1_TextBox, jamStoneInfo.Name);
    EnsoulOptionWnd_Charge2_TextBox.SetText("x" @ (ensoulFeeInfo.ItemCount));
    EnsoulCancelBtn.EnableWindow();
    // End:0x5CF
    if(__NFUN_410__(ensoulFeeInfo.ItemCount, __NFUN_405__(InvenJamStoneInfo.ItemNum, decUseJamStone)))
    {
        EnsoulOptionWnd_Charge3_TextBox.SetTextColor(GetColor(85, 170, 255, 255));
        EnsoulOK_Button.EnableWindow();        
    }
    else
    {
        EnsoulOptionWnd_Charge3_TextBox.SetTextColor(GetColor(255, 0, 0, 255));
        EnsoulDiscription_TextBox.SetText(MakeFullSystemMsg(GetSystemMessage(1473), jamStoneInfo.Name));
        EnsoulOK_Button.DisableWindow();
    }
    EnsoulOptionWnd_Charge3_TextBox.SetText(("(" $ (maxCountLimitString(__NFUN_405__(InvenJamStoneInfo.ItemNum, decUseJamStone), (9999), "9999+"))) $ ")");
    // End:0x6C5
    if(__NFUN_409__(InvenJamStoneInfo.ItemNum, (9999)))
    {
        jamStoneValueComma = MakeCostString((__NFUN_405__(InvenJamStoneInfo.ItemNum, decUseJamStone)));
        EnsoulOptionWnd_Charge3_TextBox.SetTooltipType("text");
        EnsoulOptionWnd_Charge3_TextBox.SetTooltipText(jamStoneValueComma);        
    }
    else
    {
        EnsoulOptionWnd_Charge3_TextBox.SetTooltipType("");
        EnsoulOptionWnd_Charge3_TextBox.SetTooltipText("");
    }
    return;
}

function askOverwriteEnsoulOption(bool bShow, optional ItemInfo Info)
{
    local ItemInfo tempInfo;

    // End:0x29A
    if(bShow)
    {
        DisableWnd.ShowWindow();
        DisableWnd.SetFocus();
        tempInfo.IconName = "L2UI_ct1.Icon.ICON_DF_Exclamation";
        EnsoulWnd_ResultWnd.ShowWindow();
        EnsoulWnd_ResultWnd.SetWindowSize(233, 250);
        GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.OK_Button").ShowWindow();
        GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Cancel_Button").ShowWindow();
        GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.singleOK_Button").HideWindow();
        EnsoulProgress_AnimTex.Stop();
        EnsoulProgress_AnimTex.HideWindow();
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").Clear();
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").AddItem(tempInfo);
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").SetTooltipType("");
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").ClearTooltip();
        GetTextBoxHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Discription_TextBox").SetText(GetSystemMessage(4332));        
    }
    else
    {
        DisableWnd.HideWindow();
        EnsoulWnd_ResultWnd.HideWindow();
    }
    return;
}

function confirmResultEnsoulOption(bool bSuccess, ItemInfo Info)
{
    local ItemInfo tempInfo;

    setWindowStateSetting("STATE_RESULT");
    // End:0x29D
    if(bSuccess)
    {
        EnsoulWnd_ResultWnd.SetWindowSize(233, 200);
        GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.OK_Button").HideWindow();
        GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Cancel_Button").HideWindow();
        GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.singleOK_Button").ShowWindow();
        EnsoulProgress_AnimTex.SetLoopCount(1);
        EnsoulProgress_AnimTex.Stop();
        EnsoulProgress_AnimTex.Play();
        PlaySound("ItemSound3.enchant_success");
        EnsoulProgress_AnimTex.ShowWindow();
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").Clear();
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").ClearTooltip();
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").AddItem(Info);
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").SetTooltipType("Inventory");
        GetTextBoxHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Discription_TextBox").SetText(GetSystemMessage(4333));        
    }
    else
    {
        PlaySound("ItemSound3.enchant_fail");
        EnsoulWnd_ResultWnd.SetWindowSize(233, 250);
        tempInfo.IconName = "L2UI_ct1.Icon.ICON_DF_Exclamation";
        GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.OK_Button").HideWindow();
        GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Cancel_Button").HideWindow();
        GetWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.singleOK_Button").ShowWindow();
        EnsoulProgress_AnimTex.Stop();
        EnsoulProgress_AnimTex.HideWindow();
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").ShowWindow();
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").Clear();
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").AddItem(tempInfo);
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").SetTooltipType("");
        GetItemWindowHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Result_ItemWnd").ClearTooltip();
        GetTextBoxHandle("EnsoulWnd.EnsoulWnd_ResultWnd.Discription_TextBox").SetText(GetSystemMessage(4334));
    }
    return;
}

function askEnsoulLastProcess(bool bShow)
{
    local ItemInfo tempInfo, InvenJamStoneInfo, jamStoneInfo;
    local int i, N;
    local INT64 jamStoneTotalCount;
    local string jamStoneValueComma;
    local EnsoulFeeUIInfo ensoulFeeInfo;
    local EnsoulOptionUIInfo eOptionInfo;

    jamStoneTotalCount = (0);
    // End:0x4A2
    if(bShow)
    {
        EnsouEffectWnd_Before_ListCtrl.DeleteAllItem();
        EnsouEffectWnd_After_ListCtrl.DeleteAllItem();
        i = 0;
        J0x37:

        // End:0xBF [Loop If]
        if(i < alreadyHasOptionSlotArray.Length)
        {
            // End:0x8C
            if(isChangedOptionSlot(alreadyHasOptionSlotArray[i].SlotIndex))
            {
                addListESOption(EnsouEffectWnd_Before_ListCtrl, alreadyHasOptionSlotArray[i].eOptionUIInfo, util.ColorLightBrown);
                // [Explicit Continue]
                goto J0xB5;
            }
            addListESOption(EnsouEffectWnd_Before_ListCtrl, alreadyHasOptionSlotArray[i].eOptionUIInfo, util.ColorGray);
            J0xB5:

            i++;
            // [Loop Continue]
            goto J0x37;
        }
        N = 0;
        J0xC6:

        // End:0x1EF [Loop If]
        if(N < 3)
        {
            // End:0x1A3
            if(checkAlreadyEOptionedSlot(N + 1))
            {
                // End:0x129
                if(isChangedOptionSlot(N + 1))
                {
                    eOptionInfo = getChangedOptionUIInfo(N + 1);
                    addListESOption(EnsouEffectWnd_After_ListCtrl, eOptionInfo, util.ColorYellow);                    
                }
                else
                {
                    eOptionInfo = getAlreadyHasOptionUIInfo(N + 1);
                    // End:0x16E
                    if(eOptionInfo.optionId > 0)
                    {
                        addListESOption(EnsouEffectWnd_After_ListCtrl, eOptionInfo, util.ColorGray);                        
                    }
                    else
                    {
                        eOptionInfo = getAlreadyHasOptionUIInfo(N + 1);
                        addListESOption(EnsouEffectWnd_After_ListCtrl, eOptionInfo, util.ColorGray);
                    }
                }
                // [Explicit Continue]
                goto J0x1E5;
            }
            eOptionInfo = getChangedOptionUIInfo(N + 1);
            // End:0x1E5
            if(eOptionInfo.optionId > 0)
            {
                addListESOption(EnsouEffectWnd_After_ListCtrl, eOptionInfo, util.ColorYellow);
            }
            J0x1E5:

            N++;
            // [Loop Continue]
            goto J0xC6;
        }
        // End:0x220
        if(EnsouEffectWnd_Before_ListCtrl.GetRecordCount() <= 0)
        {
            addListString(EnsouEffectWnd_Before_ListCtrl, "  " $ GetSystemString(3393));
        }
        i = 1;
        J0x227:

        // End:0x2FB [Loop If]
        if(i < 4)
        {
            tempInfo = getItemSlotInfo(i);
            // End:0x2F1
            if(tempInfo.Id.ClassID > 0)
            {
                GetEnsoulFeeUIInfo(getItemSlotInfo(0).CrystalType, checkAlreadyEOptionedSlot(i), getSlotTypeForClient(i), getSlotIndexForClient(i), ensoulFeeInfo);
                inventoryWndScript.getInventoryItemInfo(GetItemID(ensoulFeeInfo.nID), InvenJamStoneInfo);
                Class'NWindow.UIDATA_ITEM'.static.GetItemInfo(GetItemID(ensoulFeeInfo.nID), jamStoneInfo);
                jamStoneTotalCount = __NFUN_404__(jamStoneTotalCount, ensoulFeeInfo.ItemCount);
            }
            i++;
            // [Loop Continue]
            goto J0x227;
        }
        util.textBox_setToolTipWithShortString(EnsouEffectWnd_Charge1_TextBox, jamStoneInfo.Name);
        EnsouEffectWnd_Charge2_TextBox.SetText("x" @ (jamStoneTotalCount));
        EnsouEffectWnd_Charge3_TextBox.SetText(("(" $ (maxCountLimitString(InvenJamStoneInfo.ItemNum, (9999), "9999+"))) $ ")");
        // End:0x3C6
        if(__NFUN_409__(InvenJamStoneInfo.ItemNum, (9999)))
        {
            jamStoneValueComma = MakeCostString((InvenJamStoneInfo.ItemNum));
            EnsouEffectWnd_Charge3_TextBox.SetTooltipType("text");
            EnsouEffectWnd_Charge3_TextBox.SetTooltipText(jamStoneValueComma);            
        }
        else
        {
            EnsouEffectWnd_Charge3_TextBox.SetTooltipType("");
            EnsouEffectWnd_Charge3_TextBox.SetTooltipText("");
        }
        // End:0x44B
        if(__NFUN_410__(ensoulFeeInfo.ItemCount, InvenJamStoneInfo.ItemNum))
        {
            EnsouEffectWnd_Charge3_TextBox.SetTextColor(GetColor(85, 170, 255, 255));
            EnsoulDiscription_TextBox.SetText(GetSystemMessage(4335));
            EnsoulOK_Button.EnableWindow();            
        }
        else
        {
            EnsouEffectWnd_Charge3_TextBox.SetTextColor(GetColor(255, 0, 0, 255));
            EnsoulDiscription_TextBox.SetText(MakeFullSystemMsg(GetSystemMessage(1473), jamStoneInfo.Name));
            EnsoulOK_Button.DisableWindow();
        }        
    }
    else
    {
        setWindowStateSetting("STATE_INSERT_ENSOULSTONE");
    }
    return;
}

function addListESOption(ListCtrlHandle List, EnsoulOptionUIInfo optionInfo, Color applyColor)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 1;
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[0].TextColor = applyColor;
    // End:0x96
    if(optionInfo.OptionStep > 0)
    {
        Record.LVDataList[0].szData = "  " $ (makeShortStringByPixel(MakeFullSystemMsg(GetSystemMessage(4347), optionInfo.Name, string(optionInfo.OptionStep)), 230, ".."));        
    }
    else
    {
        Record.LVDataList[0].szData = "  " $ (makeShortStringByPixel(optionInfo.Name, 230, ".."));
    }
    Record.LVDataList[0].nReserved1 = optionInfo.optionType;
    Record.LVDataList[0].nReserved2 = optionInfo.optionId;
    List.InsertRecord(Record);
    return;
}

function addListString(ListCtrlHandle List, string Str)
{
    local LVDataRecord Record;

    Record.LVDataList.Length = 1;
    Record.LVDataList[0].bUseTextColor = true;
    Record.LVDataList[0].TextColor = util.ColorDesc;
    Record.LVDataList[0].szData = Str;
    Record.LVDataList[0].nReserved1 = 0;
    Record.LVDataList[0].nReserved2 = 0;
    List.InsertRecord(Record);
    return;
}

function OnProgressTimeUp(string strID)
{
    // End:0x3E
    if(strID == "EnsoulProgressWnd_ProgressBar")
    {
        EnsoulProgressWnd_ProgressBar.HideWindow();
        requestItemEnsoulProcess();
    }
    return;
}

function requestItemEnsoulProcess()
{
    local string param;

    param = makeRequestEnsoulParam();
    Class'NWindow.EnsoulAPI'.static.RequestItemEnsoul(param);
    return;
}

function bool isChangedWeaponEnsoulOption()
{
    local string param;
    local int NumOfChangedSlot;

    param = makeRequestEnsoulParam();
    ParseInt(param, "NumOfChangedSlot", NumOfChangedSlot);
    return NumOfChangedSlot > 0;
    return;
}

function string makeRequestEnsoulParam()
{
    local string param;
    local int i, chanagedCount, targetWeaponServerID;

    chanagedCount = 0;
    targetWeaponServerID = getItemSlotInfo(0).Id.ServerID;
    ParamAdd(param, "TargetItemID", string(targetWeaponServerID));
    i = 0;
    J0x45:

    // End:0x144 [Loop If]
    if(i < itemEnsoulRequestInfo.Length)
    {
        // End:0x13A
        if(itemEnsoulRequestInfo[i].ensoulStoneServerID > 0)
        {
            ParamAdd(param, "SlotType_" $ string(chanagedCount), string(itemEnsoulRequestInfo[i].clientSlotType));
            ParamAdd(param, "SlotIndex_" $ string(chanagedCount), string(itemEnsoulRequestInfo[i].clientSlotIndex));
            ParamAdd(param, "InputItemID_" $ string(chanagedCount), string(itemEnsoulRequestInfo[i].ensoulStoneServerID));
            ParamAdd(param, "OptionID_" $ string(chanagedCount), string(itemEnsoulRequestInfo[i].selectedOptionID));
            chanagedCount++;
        }
        i++;
        // [Loop Continue]
        goto J0x45;
    }
    ParamAdd(param, "NumOfChangedSlot", string(chanagedCount));
    return param;
    return;
}

function showResult(string param)
{
    local int resultValue;
    local ItemInfo weaponInfo;
    local int EnsoulOptionNum, N, i, nEOptionID;

    weaponInfo = getItemSlotInfo(0);
    ParseInt(param, "Result", resultValue);
    i = 1;
    J0x2C:

    // End:0xEF [Loop If]
    if(i < 3)
    {
        ParseInt(param, "EnsoulOptionNum_" $ string(i), EnsoulOptionNum);
        N = 1;
        J0x6A:

        // End:0xE5 [Loop If]
        if(N < (1 + EnsoulOptionNum))
        {
            ParseInt(param, (("EnsoulOptionID_" $ string(i)) $ "_") $ string(N), nEOptionID);
            weaponInfo.EnsoulOption[i - 1].OptionArray[N - 1] = nEOptionID;
            N++;
            // [Loop Continue]
            goto J0x6A;
        }
        i++;
        // [Loop Continue]
        goto J0x2C;
    }
    // End:0x109
    if(resultValue > 0)
    {
        confirmResultEnsoulOption(true, weaponInfo);        
    }
    else
    {
        confirmResultEnsoulOption(false, getItemSlotInfo(0));
    }
    return;
}

function OnTextureAnimEnd(AnimTextureHandle a_AnimTextureHandle)
{
    switch(a_AnimTextureHandle.GetWindowName())
    {
        // End:0x3E
        case "EnsoulProgress_AnimTex":
            a_AnimTextureHandle.HideWindow();
            // End:0x41
            break;
        // End:0xFFFF
        default:
            break;
    }
    Debug("---------------------OnTextureAnimEnd : " @ a_AnimTextureHandle.GetWindowName());
    return;
}

function bool externalCheckUsingItem(ItemInfo Info, optional out int nStackableNum)
{
    local ItemInfo innerItemInfo;
    local bool RValue;

    // End:0x52
    if(getItemSlotWindow(0).GetItemNum() > 0)
    {
        getItemSlotWindow(0).GetItem(0, innerItemInfo);
        // End:0x52
        if(innerItemInfo.Id == Info.Id)
        {
            RValue = true;
        }
    }
    // End:0xAB
    if(getItemSlotWindow(1).GetItemNum() > 0)
    {
        getItemSlotWindow(1).GetItem(0, innerItemInfo);
        // End:0xAB
        if(innerItemInfo.Id == Info.Id)
        {
            RValue = true;
            nStackableNum++;
        }
    }
    // End:0x106
    if(getItemSlotWindow(2).GetItemNum() > 0)
    {
        getItemSlotWindow(2).GetItem(0, innerItemInfo);
        // End:0x106
        if(innerItemInfo.Id == Info.Id)
        {
            RValue = true;
            nStackableNum++;
        }
    }
    // End:0x161
    if(getItemSlotWindow(3).GetItemNum() > 0)
    {
        getItemSlotWindow(3).GetItem(0, innerItemInfo);
        // End:0x161
        if(innerItemInfo.Id == Info.Id)
        {
            RValue = true;
            nStackableNum++;
        }
    }
    return RValue;
    return;
}

function bool hasSelectedEnsoulOptionTypeOtherSlot(int nSelectedOptionType, optional int exceptionSlotIndex)
{
    local int N;
    local bool RValue;
    local int clientSlotIndex, exceptionSlotType;

    // End:0x1E
    if(exceptionSlotIndex >= 3)
    {
        exceptionSlotType = 2;
        clientSlotIndex = 1;        
    }
    else
    {
        // End:0x3B
        if(exceptionSlotIndex > 0)
        {
            exceptionSlotType = 1;
            clientSlotIndex = exceptionSlotIndex;
        }
    }
    N = 0;
    J0x42:

    // End:0xB7 [Loop If]
    if(N < itemEnsoulRequestInfo.Length)
    {
        // End:0xAD
        if((itemEnsoulRequestInfo[N].clientSlotIndex != clientSlotIndex) || itemEnsoulRequestInfo[N].clientSlotType != exceptionSlotType)
        {
            // End:0xAD
            if(itemEnsoulRequestInfo[N].selectedOptionType == nSelectedOptionType)
            {
                RValue = true;
                // [Explicit Break]
                goto J0xB7;
            }
        }
        N++;
        // [Loop Continue]
        goto J0x42;
    }
    J0xB7:

    return RValue;
    return;
}

function bool hasSelectedEnsoulOptionIdOtherSlot(int nSelectedOptionID, optional int exceptionSlotIndex)
{
    local int N;
    local bool RValue;
    local int clientSlotIndex, exceptionSlotType;

    // End:0x1E
    if(exceptionSlotIndex >= 3)
    {
        exceptionSlotType = 2;
        clientSlotIndex = 1;        
    }
    else
    {
        // End:0x3B
        if(exceptionSlotIndex > 0)
        {
            exceptionSlotType = 1;
            clientSlotIndex = exceptionSlotIndex;
        }
    }
    N = 0;
    J0x42:

    // End:0xF5 [Loop If]
    if(N < itemEnsoulRequestInfo.Length)
    {
        // End:0xEB
        if((itemEnsoulRequestInfo[N].clientSlotIndex != clientSlotIndex) || itemEnsoulRequestInfo[N].clientSlotType != exceptionSlotType)
        {
            // End:0xEB
            if(itemEnsoulRequestInfo[N].selectedOptionID == nSelectedOptionID)
            {
                RValue = true;
                Debug("---> 같은 옵션 selectedOptionID : " @ string(itemEnsoulRequestInfo[N].selectedOptionID));
                // [Explicit Break]
                goto J0xF5;
            }
        }
        N++;
        // [Loop Continue]
        goto J0x42;
    }
    J0xF5:

    return RValue;
    return;
}

function bool hasWeaponOptionTypeOtherSlot(int nSelectedOptionType, optional int exceptionSlotIndex)
{
    local int N;
    local bool RValue;

    N = 0;
    J0x07:

    // End:0x6F [Loop If]
    if(N < alreadyHasOptionSlotArray.Length)
    {
        // End:0x65
        if((alreadyHasOptionSlotArray[N].SlotIndex != exceptionSlotIndex) || exceptionSlotIndex == 0)
        {
            // End:0x65
            if(alreadyHasOptionSlotArray[N].eOptionUIInfo.optionType == nSelectedOptionType)
            {
                RValue = true;
            }
        }
        N++;
        // [Loop Continue]
        goto J0x07;
    }
    return RValue;
    return;
}

function bool hasWeaponOptionIdOtherSlot(int applyEOptionID, optional int exceptionSlotIndex)
{
    local int N;
    local bool RValue;

    N = 0;
    J0x07:

    // End:0x6F [Loop If]
    if(N < alreadyHasOptionSlotArray.Length)
    {
        // End:0x65
        if((alreadyHasOptionSlotArray[N].SlotIndex != exceptionSlotIndex) || exceptionSlotIndex == 0)
        {
            // End:0x65
            if(alreadyHasOptionSlotArray[N].eOptionUIInfo.optionId == applyEOptionID)
            {
                RValue = true;
            }
        }
        N++;
        // [Loop Continue]
        goto J0x07;
    }
    return RValue;
    return;
}

function bool hasWeaponOptionIDInTargetSlot(int SlotIndex, int applyEOptionID)
{
    local int N;
    local bool RValue;

    N = 0;
    J0x07:

    // End:0x62 [Loop If]
    if(N < alreadyHasOptionSlotArray.Length)
    {
        // End:0x58
        if(alreadyHasOptionSlotArray[N].SlotIndex == SlotIndex)
        {
            // End:0x58
            if(alreadyHasOptionSlotArray[N].eOptionUIInfo.optionId == applyEOptionID)
            {
                RValue = true;
            }
        }
        N++;
        // [Loop Continue]
        goto J0x07;
    }
    return RValue;
    return;
}

function bool isChangedOptionSlot(int SlotIndex)
{
    local int i, clientSlotIndex, slotType;

    // End:0x1E
    if(SlotIndex >= 3)
    {
        slotType = 2;
        clientSlotIndex = 1;        
    }
    else
    {
        slotType = 1;
        clientSlotIndex = SlotIndex;
    }
    i = 0;
    J0x37:

    // End:0x9F [Loop If]
    if(i < itemEnsoulRequestInfo.Length)
    {
        // End:0x95
        if((itemEnsoulRequestInfo[i].clientSlotIndex == clientSlotIndex) && itemEnsoulRequestInfo[i].clientSlotType == slotType)
        {
            // End:0x95
            if(itemEnsoulRequestInfo[i].ensoulStoneServerID > 0)
            {
                return true;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x37;
    }
    return false;
    return;
}

function EnsoulOptionUIInfo getChangedOptionUIInfo(int SlotIndex)
{
    local int i, clientSlotIndex, slotType;
    local EnsoulOptionUIInfo rEnsoulStoneUIInfo;

    // End:0x1E
    if(SlotIndex >= 3)
    {
        slotType = 2;
        clientSlotIndex = 1;        
    }
    else
    {
        slotType = 1;
        clientSlotIndex = SlotIndex;
    }
    i = 0;
    J0x37:

    // End:0xBE [Loop If]
    if(i < itemEnsoulRequestInfo.Length)
    {
        // End:0xB4
        if((itemEnsoulRequestInfo[i].clientSlotIndex == clientSlotIndex) && itemEnsoulRequestInfo[i].clientSlotType == slotType)
        {
            // End:0xB4
            if(itemEnsoulRequestInfo[i].ensoulStoneServerID > 0)
            {
                GetEnsoulOptionUIInfo(itemEnsoulRequestInfo[i].selectedOptionID, rEnsoulStoneUIInfo);
                return rEnsoulStoneUIInfo;
            }
        }
        i++;
        // [Loop Continue]
        goto J0x37;
    }
    return rEnsoulStoneUIInfo;
    return;
}

function EnsoulOptionUIInfo getAlreadyHasOptionUIInfo(int SlotIndex)
{
    local int i;
    local EnsoulOptionUIInfo rEnsoulStoneUIInfo;

    i = 0;
    J0x07:

    // End:0x4C [Loop If]
    if(i < alreadyHasOptionSlotArray.Length)
    {
        // End:0x42
        if(alreadyHasOptionSlotArray[i].SlotIndex == SlotIndex)
        {
            return alreadyHasOptionSlotArray[i].eOptionUIInfo;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return rEnsoulStoneUIInfo;
    return;
}

function bool checkAlreadyEOptionedSlot(int SlotIndex)
{
    local int N;
    local bool RValue;

    // End:0x0D
    if(SlotIndex <= 0)
    {
        return false;
    }
    N = 0;
    J0x14:

    // End:0x50 [Loop If]
    if(N < alreadyHasOptionSlotArray.Length)
    {
        // End:0x46
        if(alreadyHasOptionSlotArray[N].SlotIndex == SlotIndex)
        {
            RValue = true;
        }
        N++;
        // [Loop Continue]
        goto J0x14;
    }
    return RValue;
    return;
}

function textBoxClear(TextBoxHandle txtBox)
{
    txtBox.SetText("");
    txtBox.SetTooltipType("");
    txtBox.SetText("");
    return;
}

function clearEnsoulOptionWnd()
{
    EnsoulOptionWnd_ITEM1_ItemWnd.Clear();
    EnsoulOptionWnd_ITEM2_ItemWnd.Clear();
    return;
}

function string getCurrentEnsoulState()
{
    return currentEnsoulState;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(getCurrentWindowName(string(self))).HideWindow();
    return;
}
