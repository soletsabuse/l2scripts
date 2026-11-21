class PostWriteWnd extends UICommonAPI;

const TRADE_NORMAL = 0;
const TRADE_SAFE = 1;
const MAX_APPEND_ITEM_NUM = 36;
const DIALOG_STACKABLE_ITEM_ACCOMPANY_TO_INVEN = 1111;
const DIALOG_STACKABLE_ITEM_INVEN_TO_ACCOMPANY = 2222;
const DIALOG_RECEIVE_ADENA = 3333;
const DIALOG_NOTIFY_SEND_POST = 4444;
const DIALOG_ONLY_NOTICE = 5555;
const MAX_CHAR_LENGTH = 24;
const MAX_TITLE_LENGTH = 60;
const MAX_CONTENTS_LENGTH = 1000;
const ADENA_OVER_FLOW = "1000000000000";
const MAX_PAGE_ITEM_NUM = 24;

var string m_WindowName;
var WindowHandle Me;
var WindowHandle PostBoxWnd;
var WindowHandle PostDetailWnd_General;
var WindowHandle PostDetailWnd_SafetyTrade;
var TextureHandle PostTitleDivider;
var TextureHandle PostContentsBg;
var TextureHandle GroupBox1;
var TextureHandle AccompanyItemSlotBg01;
var TextureHandle AccompanyItemSlotBg02;
var TextureHandle AccompanyItemSlotBg03;
var TextureHandle AdenaIcon;
var TextureHandle WeightBg;
var TextureHandle WeightDivider;
var TextureHandle InventoryItemSlot01;
var TextureHandle InventoryItemSlot02;
var TextureHandle InventoryDivider;
var TextureHandle ChargeAdenaIcon;
var TextureHandle Chargeadenabg;
var TextureHandle GroupBox2;
var TextureHandle SafetyTradeAdenaIcon;
var TextureHandle groupbox3;
var TextureHandle SafetyTradeAdenaTextBoxBg;
var TextureHandle SafetyReceiveAdenaIcon;
var TextBoxHandle Title_ReceiverID;
var TextBoxHandle Title_PostType;
var TextBoxHandle Title_PostTitle;
var TextBoxHandle PostTitleByte;
var TextBoxHandle Title_PostContents;
var TextBoxHandle PostContentsByte;
var TextBoxHandle Title_AccompanyItem;
var TextBoxHandle Title_Weight;
var TextBoxHandle WeightText;
var TextBoxHandle Title_Inventory;
var TextBoxHandle InventoryItemNumber;
var TextBoxHandle InventoryPageNumber;
var TextBoxHandle Title_Charge;
var TextBoxHandle ChargeAdenaText;
var TextBoxHandle Title_SafetyTradeAdena;
var EditBoxHandle ReceiverID;
var EditBoxHandle PostTitle;
var TextBoxHandle SafetyTradeAdenaTextBox;
var ButtonHandle SafetyReceiveAdena;
var MultiEditBoxHandle contents;
var ComboBoxHandle PostTypeComboBox;
var ButtonHandle sendBtn;
var ItemWindowHandle AccompanyItem;
var ItemWindowHandle InventoryItem;
var ButtonHandle PrevButton;
var ButtonHandle NextButton;
var InventoryWnd script;
var WindowHandle PostReceiverListWnd;
var bool bOpenPostReceiverList;
var string strSendID;
var array<RequestItem> itemIDList;
var ItemInfo adenaInfo;
var INT64 SafetyTradeAdena;
var INT64 FeeAdena;
var int totalWeight;
var int curTradeType;
var int zonetype;
var Color disableColor;
var Color enableColor;
var int FEE_PER_SLOT;
var int BASE_FEE_ADENA;
//var delegate<onSendPost> __onSendPost__Delegate;

function OnRegisterEvent()
{
    RegisterEvent(4970);
    RegisterEvent(4980);
    RegisterEvent(4990);
    RegisterEvent(5000);
    RegisterEvent(4790);
    RegisterEvent(4791);
    RegisterEvent(4792);
    RegisterEvent(1710);
    RegisterEvent(4799);
    RegisterEvent(110);
    RegisterEvent(160);
    RegisterEvent(4731);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x23
    if(1 == 0)
    {
        Initialize();        
    }
    else
    {
        InitializeCOD();
    }
    Me.HideWindow();
    enableColor.R = 220;
    enableColor.G = 220;
    enableColor.B = 220;
    disableColor.R = 130;
    disableColor.G = 130;
    disableColor.B = 130;
    ClearAll();
    bOpenPostReceiverList = false;
    return;
}

function OnShow()
{
    // End:0x21
    if(PostBoxWnd.IsShowWindow())
    {
        PostBoxWnd.HideWindow();
    }
    // End:0x42
    if(PostDetailWnd_General.IsShowWindow())
    {
        PostDetailWnd_General.HideWindow();
    }
    // End:0x63
    if(PostDetailWnd_SafetyTrade.IsShowWindow())
    {
        PostDetailWnd_SafetyTrade.HideWindow();
    }
    // End:0x7E
    if(zonetype != 12)
    {
        sendBtn.EnableWindow();
    }
    // End:0xA6
    if(ReceiverID.GetString() == "")
    {
        ReceiverID.SetFocus();        
    }
    else
    {
        contents.SetFocus();
    }
    PostTitle.SetString(GetSystemString(7667));
    return;
}

function toWrite(string Name)
{
    ReceiverID.SetString(Name);
    return;
}

function Initialize()
{
    Me = GetHandle("PostWriteWnd");
    PostBoxWnd = GetHandle("PostBoxWnd");
    PostDetailWnd_General = GetHandle("PostDetailWnd_General");
    PostDetailWnd_SafetyTrade = GetHandle("PostDetailWnd_SafetyTrade");
    Title_ReceiverID = TextBoxHandle(GetHandle("PostWriteWnd.Title_ReceiverID"));
    Title_PostType = TextBoxHandle(GetHandle("PostWriteWnd.Title_PostType"));
    Title_PostTitle = TextBoxHandle(GetHandle("PostWriteWnd.Title_PostTitle"));
    PostTitleByte = TextBoxHandle(GetHandle("PostWriteWnd.PostTitleByte"));
    Title_PostContents = TextBoxHandle(GetHandle("PostWriteWnd.Title_PostContents"));
    PostContentsByte = TextBoxHandle(GetHandle("PostWriteWnd.PostContentsByte"));
    Title_AccompanyItem = TextBoxHandle(GetHandle("PostWriteWnd.Title_AccompanyItem"));
    Title_Weight = TextBoxHandle(GetHandle("PostWriteWnd.Title_Weight"));
    WeightText = TextBoxHandle(GetHandle("PostWriteWnd.WeightText"));
    Title_Inventory = TextBoxHandle(GetHandle("PostWriteWnd.Title_Inventory"));
    InventoryItemNumber = TextBoxHandle(GetHandle("PostWriteWnd.InventoryItemNumber"));
    InventoryPageNumber = TextBoxHandle(GetHandle("PostWriteWnd.InventoryPageNumber"));
    Title_Charge = TextBoxHandle(GetHandle("PostWriteWnd.Title_Charge"));
    ChargeAdenaText = TextBoxHandle(GetHandle("PostWriteWnd.ChargeAdenaText"));
    Title_SafetyTradeAdena = TextBoxHandle(GetHandle("PostWriteWnd.Title_SafetyTradeAdena"));
    PostTitleDivider = TextureHandle(GetHandle("PostWriteWnd.PostTitleDivider"));
    PostContentsBg = TextureHandle(GetHandle("PostWriteWnd.PostContentsBg"));
    GroupBox1 = TextureHandle(GetHandle("PostWriteWnd.groupbox1"));
    AccompanyItemSlotBg01 = TextureHandle(GetHandle("PostWriteWnd.AccompanyItemSlotBg01"));
    AccompanyItemSlotBg02 = TextureHandle(GetHandle("PostWriteWnd.AccompanyItemSlotBg02"));
    AccompanyItemSlotBg03 = TextureHandle(GetHandle("PostWriteWnd.AccompanyItemSlotBg03"));
    AdenaIcon = TextureHandle(GetHandle("PostWriteWnd.AdenaIcon"));
    WeightBg = TextureHandle(GetHandle("PostWriteWnd.WeightBg"));
    WeightDivider = TextureHandle(GetHandle("PostWriteWnd.WeightDivider"));
    InventoryItemSlot01 = TextureHandle(GetHandle("PostWriteWnd.InventoryItemSlot01"));
    InventoryItemSlot02 = TextureHandle(GetHandle("PostWriteWnd.InventoryItemSlot02"));
    InventoryDivider = TextureHandle(GetHandle("PostWriteWnd.InventoryDivider"));
    ChargeAdenaIcon = TextureHandle(GetHandle("PostWriteWnd.ChargeAdenaIcon"));
    Chargeadenabg = TextureHandle(GetHandle("PostWriteWnd.Chargeadenabg"));
    GroupBox2 = TextureHandle(GetHandle("PostWriteWnd.groupbox2"));
    SafetyTradeAdenaIcon = TextureHandle(GetHandle("PostWriteWnd.SafetyTradeAdenaIcon"));
    groupbox3 = TextureHandle(GetHandle("PostWriteWnd.groupbox3"));
    SafetyTradeAdenaTextBoxBg = TextureHandle(GetHandle("PostWriteWnd.SafetyTradeAdenaTextBoxBg"));
    SafetyReceiveAdenaIcon = TextureHandle(GetHandle("PostWriteWnd.SafetyReceiveAdenaIcon"));
    ReceiverID = EditBoxHandle(GetHandle("PostWriteWnd.ReceiverID"));
    PostTitle = EditBoxHandle(GetHandle("PostWriteWnd.PostTitle"));
    SafetyTradeAdenaTextBox = TextBoxHandle(GetHandle("PostWriteWnd.SafetyTradeAdenaTextBox"));
    contents = MultiEditBoxHandle(GetHandle("PostWriteWnd.PostContents"));
    PostTypeComboBox = ComboBoxHandle(GetHandle("PostWriteWnd.PostTypeComboBox"));
    AccompanyItem = ItemWindowHandle(GetHandle("PostWriteWnd.AccompanyItem"));
    InventoryItem = ItemWindowHandle(GetHandle("PostWriteWnd.InventoryItem"));
    PrevButton = ButtonHandle(GetHandle("PostWriteWnd.PrevButton"));
    NextButton = ButtonHandle(GetHandle("PostWriteWnd.NextButton"));
    sendBtn = ButtonHandle(GetHandle("PostWriteWnd.SendBtn"));
    SafetyReceiveAdena = ButtonHandle(GetHandle("PostWriteWnd.SafetyReceiveAdena"));
    script = InventoryWnd(GetScript("InventoryWnd"));
    PostReceiverListWnd = GetWindowHandle("PostReceiverListWnd");
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("PostWriteWnd");
    PostBoxWnd = GetWindowHandle("PostBoxWnd");
    PostDetailWnd_General = GetWindowHandle("PostDetailWnd_General");
    PostDetailWnd_SafetyTrade = GetWindowHandle("PostDetailWnd_SafetyTrade");
    Title_ReceiverID = GetTextBoxHandle("PostWriteWnd.Title_ReceiverID");
    Title_PostType = GetTextBoxHandle("PostWriteWnd.Title_PostType");
    Title_PostTitle = GetTextBoxHandle("PostWriteWnd.Title_PostTitle");
    PostTitleByte = GetTextBoxHandle("PostWriteWnd.PostTitleByte");
    Title_PostContents = GetTextBoxHandle("PostWriteWnd.Title_PostContents");
    PostContentsByte = GetTextBoxHandle("PostWriteWnd.PostContentsByte");
    Title_AccompanyItem = GetTextBoxHandle("PostWriteWnd.Title_AccompanyItem");
    Title_Weight = GetTextBoxHandle("PostWriteWnd.Title_Weight");
    WeightText = GetTextBoxHandle("PostWriteWnd.WeightText");
    Title_Inventory = GetTextBoxHandle("PostWriteWnd.Title_Inventory");
    InventoryItemNumber = GetTextBoxHandle("PostWriteWnd.InventoryItemNumber");
    InventoryPageNumber = GetTextBoxHandle("PostWriteWnd.InventoryPageNumber");
    Title_Charge = GetTextBoxHandle("PostWriteWnd.Title_Charge");
    ChargeAdenaText = GetTextBoxHandle("PostWriteWnd.ChargeAdenaText");
    Title_SafetyTradeAdena = GetTextBoxHandle("PostWriteWnd.Title_SafetyTradeAdena");
    PostTitleDivider = GetTextureHandle("PostWriteWnd.PostTitleDivider");
    PostContentsBg = GetTextureHandle("PostWriteWnd.PostContentsBg");
    GroupBox1 = GetTextureHandle("PostWriteWnd.groupbox1");
    AccompanyItemSlotBg01 = GetTextureHandle("PostWriteWnd.AccompanyItemSlotBg01");
    AccompanyItemSlotBg02 = GetTextureHandle("PostWriteWnd.AccompanyItemSlotBg02");
    AccompanyItemSlotBg03 = GetTextureHandle("PostWriteWnd.AccompanyItemSlotBg03");
    AdenaIcon = GetTextureHandle("PostWriteWnd.AdenaIcon");
    WeightBg = GetTextureHandle("PostWriteWnd.WeightBg");
    WeightDivider = GetTextureHandle("PostWriteWnd.WeightDivider");
    InventoryItemSlot01 = GetTextureHandle("PostWriteWnd.InventoryItemSlot01");
    InventoryItemSlot02 = GetTextureHandle("PostWriteWnd.InventoryItemSlot02");
    InventoryDivider = GetTextureHandle("PostWriteWnd.InventoryDivider");
    ChargeAdenaIcon = GetTextureHandle("PostWriteWnd.ChargeAdenaIcon");
    Chargeadenabg = GetTextureHandle("PostWriteWnd.Chargeadenabg");
    GroupBox2 = GetTextureHandle("PostWriteWnd.groupbox2");
    SafetyTradeAdenaIcon = GetTextureHandle("PostWriteWnd.SafetyTradeAdenaIcon");
    groupbox3 = GetTextureHandle("PostWriteWnd.groupbox3");
    SafetyTradeAdenaTextBoxBg = GetTextureHandle("PostWriteWnd.SafetyTradeAdenaTextBoxBg");
    SafetyReceiveAdenaIcon = GetTextureHandle("PostWriteWnd.SafetyReceiveAdenaIcon");
    ReceiverID = GetEditBoxHandle("PostWriteWnd.ReceiverID");
    PostTitle = GetEditBoxHandle("PostWriteWnd.PostTitle");
    SafetyTradeAdenaTextBox = GetTextBoxHandle("PostWriteWnd.SafetyTradeAdenaTextBox");
    contents = GetMultiEditBoxHandle("PostWriteWnd.PostContents");
    PostTypeComboBox = GetComboBoxHandle("PostWriteWnd.PostTypeComboBox");
    AccompanyItem = GetItemWindowHandle("PostWriteWnd.AccompanyItem");
    InventoryItem = GetItemWindowHandle("PostWriteWnd.InventoryItem");
    PrevButton = GetButtonHandle("PostWriteWnd.PrevButton");
    NextButton = GetButtonHandle("PostWriteWnd.NextButton");
    sendBtn = GetButtonHandle("PostWriteWnd.SendBtn");
    SafetyReceiveAdena = GetButtonHandle("PostWriteWnd.SafetyReceiveAdena");
    script = InventoryWnd(GetScript("InventoryWnd"));
    PostReceiverListWnd = GetWindowHandle("PostReceiverListWnd");
    PrevButton.HideWindow();
    NextButton.HideWindow();
    InventoryPageNumber.HideWindow();
    return;
}

function PostListUpdate()
{
    Class'NWindow.PostWndAPI'.static.RequestFriendList();
    Class'NWindow.PostWndAPI'.static.RequestPledgeMemberList();
    Class'NWindow.PostWndAPI'.static.RequestPostFriendList();
    return;
}

function OnClickButton(string a_ButtonID)
{
    switch(a_ButtonID)
    {
        // End:0x1C
        case "SendBtn":
            HandleSendBtn();
            // End:0xE1
            break;
        // End:0x3C
        case "SafetyReceiveAdena":
            HandleSafetyReceiveAdena();
            // End:0xE1
            break;
        // End:0x63
        case "PrevButton":
            InventoryItem.PushSideTypePrevBtn();
            SetInventoryPageNumber();
            // End:0xE1
            break;
        // End:0x8A
        case "NextButton":
            InventoryItem.PushSideTypeNextBtn();
            SetInventoryPageNumber();
            // End:0xE1
            break;
        // End:0xBE
        case "ClearAccompanyButton":
            ClearAccompanyList();
            SetInventoryPageNumber();
            SetFeeAdena();
            SetWeight();
            // End:0xE1
            break;
        // End:0xDB
        case "ReceiverListBtn":
            OnReceiverListButton();
            // End:0xE1
            break;
        // End:0xFFFF
        default:
            // End:0xE1
            break;
            break;
    }
    return;
}

function SetBoolPostReceiverList(bool B)
{
    bOpenPostReceiverList = B;
    return;
}

function OnReceiverListButton()
{
    local PostReceiverListWnd script;

    script = PostReceiverListWnd(GetScript("PostReceiverListWnd"));
    bOpenPostReceiverList = !bOpenPostReceiverList;
    // End:0x56
    if(bOpenPostReceiverList)
    {
        PostReceiverListWnd.ShowWindow();
        PostListUpdate();        
    }
    else
    {
        script.selectedInit();
        PostReceiverListWnd.HideWindow();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x18
        case 4790:
            HandlePostWriteOpen();
            // End:0x120
            break;
        // End:0x2E
        case 4791:
            HandleSentEnableAddItem(param);
            // End:0x120
            break;
        // End:0x3F
        case 4792:
            HandlePostWriteEnd();
            // End:0x120
            break;
        // End:0x50
        case 1710:
            HandleDialogOK();
            // End:0x120
            break;
        // End:0x66
        case 4799:
            HandleReplyWritePost(param);
            // End:0x120
            break;
        // End:0xCA
        case 110:
            ParseInt(param, "ZoneCode", zonetype);
            // End:0xA3
            if(zonetype == 12)
            {
                sendBtn.EnableWindow();                
            }
            else
            {
                // End:0xC7
                if(AccompanyItem.GetItemNum() > 0)
                {
                    sendBtn.DisableWindow();
                }
            }
            // End:0x120
            break;
        // End:0xE1
        case 160:
            ReceiverID.ClearHistory();
            // End:0x120
            break;
        // End:0xF7
        case 4731:
            handleSetCommisionValue(param);
            // End:0x120
            break;
        // End:0xFF
        case 4970:
        // End:0x107
        case 4980:
        // End:0x10F
        case 4990:
        // End:0x11A
        case 5000:
            // End:0x120
            break;
        // End:0xFFFF
        default:
            // End:0x120
            break;
            break;
    }
    return;
}

function handleSetCommisionValue(string param)
{
    ParseInt(param, "Commision", BASE_FEE_ADENA);
    ParseInt(param, "PerSlot", FEE_PER_SLOT);
    return;
}

function UseInvenToAccompany(ItemInfo infItem)
{
    local int __var2746, __var7777;
    local ItemInfo AccompanyInfo;

    __var7777 = InventoryItem.FindItem(infItem.Id);
    __var2746 = AccompanyItem.FindItem(infItem.Id);
    // End:0x255
    if(AccompanyItem.GetItemNum() < 36)
    {
        // End:0x185
        if(IsStackableItem(infItem.ConsumeType) && __NFUN_413__(infItem.ItemNum, (1)))
        {
            // End:0x135
            if(Class'NWindow.InputAPI'.static.IsAltPressed())
            {
                // End:0xE5
                if(__var2746 >= 0)
                {
                    AccompanyItem.GetItem(__var2746, AccompanyInfo);
                    __NFUN_406__(AccompanyInfo.ItemNum, infItem.AllItemCount);
                    AccompanyItem.SetItem(__var2746, AccompanyInfo);                    
                }
                else
                {
                    AccompanyItem.AddItem(infItem);
                }
                InventoryItem.DeleteItem(__var7777);
                totalWeight += (infItem.Weight * name(infItem.ItemNum));
                SetWeight();                
            }
            else
            {
                DialogSetID(2222);
                DialogSetReservedItemInfo(infItem);
                DialogSetParamInt64(infItem.ItemNum);
                DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), infItem.Name, ""), string(self));
            }            
        }
        else
        {
            totalWeight += infItem.Weight;
            InventoryItem.DeleteItem(__var7777);
            // End:0x224
            if(IsStackableItem(infItem.ConsumeType))
            {
                // End:0x20D
                if(__var2746 >= 0)
                {
                    AccompanyItem.GetItem(__var2746, AccompanyInfo);
                    __NFUN_406__(AccompanyInfo.ItemNum, (1));
                    AccompanyItem.SetItem(__var2746, AccompanyInfo);                    
                }
                else
                {
                    AccompanyItem.AddItem(infItem);
                }                
            }
            else
            {
                AccompanyItem.AddItem(infItem);
            }
            FeeAdena = (CalculateFeeAdena());
            SetWeight();
            SetFeeAdena();
        }        
    }
    else
    {
        // End:0x3F7
        if(((AccompanyItem.GetItemNum() == 36) && IsStackableItem(infItem.ConsumeType)) && __var2746 >= 0)
        {
            // End:0x383
            if((__NFUN_413__(infItem.ItemNum, (1)) && __NFUN_409__(infItem.AllItemCount, (0))) || __NFUN_412__(infItem.ItemNum, (1)))
            {
                AccompanyItem.GetItem(__var2746, AccompanyInfo);
                __NFUN_406__(AccompanyInfo.ItemNum, infItem.ItemNum);
                AccompanyItem.SetItem(__var2746, AccompanyInfo);
                InventoryItem.DeleteItem(__var7777);
                totalWeight += (infItem.Weight * name(infItem.ItemNum));
                FeeAdena = (CalculateFeeAdena());
                SetWeight();
                SetFeeAdena();
                Debug("ï¿½ï¿½ï¿½ï¿½");                
            }
            else
            {
                Debug("ï¿½Ï¤ï¿½ï¿½ï¿½");
                DialogSetID(2222);
                DialogSetReservedItemInfo(infItem);
                DialogSetParamInt64(infItem.ItemNum);
                DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), infItem.Name, ""), string(self));
            }            
        }
        else
        {
            DialogHide();
            DialogShow(1, 5, GetSystemMessage(3016), string(self));
            DialogSetID(5555);
        }
    }
    FeeAdena = (CalculateFeeAdena());
    SetWeight();
    SetFeeAdena();
    SetInventoryPageNumber();
    return;
}

function ClearAccompanyList()
{
    local int __var7778;
    local ItemInfo Info;

    __var7778 = AccompanyItem.GetItemNum() - 1;
    J0x18:

    // End:0x52 [Loop If]
    if(__var7778 >= 0)
    {
        AccompanyItem.GetItem(__var7778, Info);
        UseAccompanyToInven(Info, true);
        __var7778--;
        // [Loop Continue]
        goto J0x18;
    }
    return;
}

function UseAccompanyToInven(ItemInfo infItem, optional bool bFullClear)
{
    local int __var13448, __var3876;
    local ItemInfo invenInfo;

    __var13448 = AccompanyItem.FindItem(infItem.Id);
    // End:0x1A9
    if(IsStackableItem(infItem.ConsumeType) && __NFUN_413__(infItem.ItemNum, (1)))
    {
        // End:0x159
        if((__NFUN_409__(infItem.AllItemCount, (0)) || Class'NWindow.InputAPI'.static.IsAltPressed()) || bFullClear)
        {
            __var3876 = InventoryItem.FindItem(infItem.Id);
            // End:0xEF
            if(__var3876 >= 0)
            {
                InventoryItem.GetItem(__var3876, invenInfo);
                __NFUN_406__(invenInfo.ItemNum, infItem.ItemNum);
                InventoryItem.SetItem(__var3876, invenInfo);                
            }
            else
            {
                InventoryItem.AddItem(infItem);
                MoveNewItemToPosition1();
            }
            AccompanyItem.DeleteItem(__var13448);
            totalWeight -= (infItem.Weight * name(infItem.AllItemCount));
            FeeAdena = (CalculateFeeAdena());
            SetWeight();
            SetFeeAdena();            
        }
        else
        {
            DialogSetID(1111);
            DialogSetReservedItemInfo(infItem);
            DialogSetParamInt64(infItem.ItemNum);
            DialogShow(1, 6, MakeFullSystemMsg(GetSystemMessage(72), infItem.Name, ""), string(self));
        }        
    }
    else
    {
        totalWeight -= infItem.Weight;
        AccompanyItem.DeleteItem(__var13448);
        // End:0x26D
        if(IsStackableItem(infItem.ConsumeType))
        {
            __var3876 = InventoryItem.FindItem(infItem.Id);
            // End:0x250
            if(__var3876 >= 0)
            {
                InventoryItem.GetItem(__var3876, invenInfo);
                __NFUN_406__(invenInfo.ItemNum, (1));
                InventoryItem.SetItem(__var3876, invenInfo);                
            }
            else
            {
                InventoryItem.AddItem(infItem);
                MoveNewItemToPosition1();
            }            
        }
        else
        {
            InventoryItem.AddItem(infItem);
            MoveNewItemToPosition1();
        }
        FeeAdena = (CalculateFeeAdena());
        SetWeight();
        SetFeeAdena();
    }
    // End:0x2D3
    if((AccompanyItem.GetItemNum() == 0) && zonetype != 12)
    {
        sendBtn.EnableWindow();
    }
    SetInventoryPageNumber();
    return;
}

function MoveNewItemToPosition1()
{
    local int __var7342;

    __var7342 = InventoryItem.GetItemNum() - 1;
    J0x18:

    // End:0x49 [Loop If]
    if(__var7342 > 1)
    {
        InventoryItem.SwapItems(__var7342, __var7342 - 1);
        __var7342--;
        // [Loop Continue]
        goto J0x18;
    }
    return;
}

function OnDropItem(string strID, ItemInfo infItem, int X, int Y)
{
    // End:0x53
    if((strID == "AccompanyItem") && infItem.DragSrcName == "InventoryItem")
    {
        // End:0x50
        if(zonetype == 12)
        {
            UseInvenToAccompany(infItem);
        }        
    }
    else
    {
        // End:0x97
        if((strID == "InventoryItem") && infItem.DragSrcName == "AccompanyItem")
        {
            UseAccompanyToInven(infItem);
        }
    }
    return;
}

function OnDBClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
    local ItemInfo Info;

    // End:0x87
    if(a_hItemWindow.GetItem(Index, Info))
    {
        // End:0x4D
        if(a_hItemWindow.GetWindowName() == "AccompanyItem")
        {
            UseAccompanyToInven(Info);            
        }
        else
        {
            // End:0x87
            if(a_hItemWindow.GetWindowName() == "InventoryItem")
            {
                // End:0x87
                if(zonetype == 12)
                {
                    UseInvenToAccompany(Info);
                }
            }
        }
    }
    return;
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
    local ItemInfo Info;

    // End:0x87
    if(a_hItemWindow.GetItem(Index, Info))
    {
        // End:0x4D
        if(a_hItemWindow.GetWindowName() == "AccompanyItem")
        {
            UseAccompanyToInven(Info);            
        }
        else
        {
            // End:0x87
            if(a_hItemWindow.GetWindowName() == "InventoryItem")
            {
                // End:0x87
                if(zonetype == 12)
                {
                    UseInvenToAccompany(Info);
                }
            }
        }
    }
    return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
    switch(strID)
    {
        // End:0x78
        case "PostTypeComboBox":
            // End:0x4A
            if(Index == 0)
            {
                DisableSafetyAdena();
                PostTitle.SetString(GetSystemString(7667));                
            }
            else
            {
                // End:0x75
                if(Index == 1)
                {
                    EnableSafetyAdena();
                    PostTitle.SetString(GetSystemString(7668));
                }
            }
            // End:0x7E
            break;
        // End:0xFFFF
        default:
            // End:0x7E
            break;
            break;
    }
    return;
}

function setCombobox(int selectedNum)
{
    PostTypeComboBox.SetSelectedNum(selectedNum);
    return;
}

function DisableSafetyAdena()
{
    Title_SafetyTradeAdena.DisableWindow();
    SafetyReceiveAdena.DisableWindow();
    SafetyTradeAdenaTextBox.DisableWindow();
    SafetyTradeAdenaTextBoxBg.DisableWindow();
    SafetyReceiveAdenaIcon.DisableWindow();
    Title_SafetyTradeAdena.SetTextColor(disableColor);
    SafetyTradeAdenaTextBox.SetTextColor(disableColor);
    SafetyReceiveAdenaIcon.SetTexture("L2UI_ct1.Icon.Icon_DF_Common_Adena_disable");
    SafetyTradeAdenaTextBox.SetText("0");
    SafetyTradeAdena = (0);
    Me.SetWindowTitle((GetSystemString(2031) $ " - ") $ GetSystemString(2071));
    sendBtn.SetNameText(MakeFullSystemMsg(GetSystemMessage(4412), GetSystemString(2071)));
    Title_SafetyTradeAdena.SetTextColor(getInstanceL2Util().White);
    return;
}

function EnableSafetyAdena()
{
    Title_SafetyTradeAdena.EnableWindow();
    SafetyReceiveAdena.EnableWindow();
    SafetyTradeAdenaTextBox.EnableWindow();
    SafetyTradeAdenaTextBoxBg.EnableWindow();
    SafetyReceiveAdenaIcon.EnableWindow();
    Title_SafetyTradeAdena.SetTextColor(enableColor);
    SafetyTradeAdenaTextBox.SetTextColor(enableColor);
    SafetyReceiveAdenaIcon.SetTexture("L2UI_ct1.Icon.Icon_DF_Common_Adena");
    Me.SetWindowTitle((GetSystemString(2031) $ " - ") $ GetSystemString(2072));
    sendBtn.SetNameText(MakeFullSystemMsg(GetSystemMessage(4412), GetSystemString(2072)));
    Title_SafetyTradeAdena.SetTextColor(getInstanceL2Util().Yellow);
    return;
}

function SetWeight()
{
    WeightText.SetText(MakeCostString(string(totalWeight)));
    return;
}

function SetFeeAdena()
{
    ChargeAdenaText.SetText(MakeCostString((FeeAdena)));
    return;
}

function HandleDialogOK()
{
    local ItemInfo scInfo;
    local INT64 __var2038, __var7329;
    local int __var3874, __var3873;
    local ItemInfo invenInfo, AccompanyInfo;
    local bool __var13469;
    local int __var4200;
    local string __var23121;
    local Color TextColor;
    local CustomTooltip cTooltip;

    // End:0x48D
    if(DialogIsMine())
    {
        __var4200 = DialogGetID();
        // End:0x2D
        if(__var4200 == 4444)
        {
            SendPostMsg();            
        }
        else
        {
            // End:0x160
            if(__var4200 == 3333)
            {
                __var7329 = (DialogGetString());
                // End:0x97
                if(__NFUN_409__(__var7329, ("1000000000000")) || __NFUN_408__(__var7329, (0)))
                {
                    DialogHide();
                    DialogShow(1, 5, GetSystemMessage(1369), string(self));                    
                }
                else
                {
                    SafetyTradeAdenaTextBox.SetText(MakeCostString(DialogGetString()));
                    TextColor = GetNumericColor(MakeCostString(SafetyTradeAdenaTextBox.GetText()));
                    SafetyTradeAdenaTextBox.SetTextColor(TextColor);
                    __var23121 = SafetyTradeAdenaTextBox.GetText();
                    addToolTipDrawList(cTooltip, addDrawItemText((ConvertNumToTextNoAdena((__var7329)) $ " ") $ GetSystemString(469), getInstanceL2Util().White, "", false));
                    SafetyTradeAdenaTextBox.SetTooltipCustomType(cTooltip);
                    SafetyTradeAdena = __var7329;
                }                
            }
            else
            {
                // End:0x48D
                if((__var4200 == 1111) || __var4200 == 2222)
                {
                    DialogGetReservedItemInfo(scInfo);
                    __var2038 = (DialogGetString());
                    // End:0x48D
                    if(__NFUN_409__(__var2038, (0)))
                    {
                        // End:0x1D4
                        if(__NFUN_411__(__var2038, scInfo.ItemNum))
                        {
                            __var2038 = scInfo.ItemNum;
                            __var13469 = true;
                        }
                        // End:0x332
                        if(__var4200 == 1111)
                        {
                            __var3874 = InventoryItem.FindItem(scInfo.Id);
                            __var3873 = AccompanyItem.FindItem(scInfo.Id);
                            // End:0x273
                            if(__var3874 >= 0)
                            {
                                InventoryItem.GetItem(__var3874, invenInfo);
                                __NFUN_406__(invenInfo.ItemNum, __var2038);
                                InventoryItem.SetItem(__var3874, invenInfo);                                
                            }
                            else
                            {
                                AccompanyItem.GetItem(__var3873, AccompanyInfo);
                                AccompanyInfo.ItemNum = __var2038;
                                InventoryItem.AddItem(AccompanyInfo);
                            }
                            // End:0x2D0
                            if(__var13469)
                            {
                                AccompanyItem.DeleteItem(__var3873);                                
                            }
                            else
                            {
                                __NFUN_407__(scInfo.ItemNum, __var2038);
                                AccompanyItem.SetItem(__var3873, scInfo);
                            }
                            totalWeight -= (scInfo.Weight * name(__var2038));
                            FeeAdena = (CalculateFeeAdena());
                            SetWeight();
                            SetFeeAdena();                            
                        }
                        else
                        {
                            // End:0x48D
                            if(__var4200 == 2222)
                            {
                                __var3873 = AccompanyItem.FindItem(scInfo.Id);
                                __var3874 = InventoryItem.FindItem(scInfo.Id);
                                // End:0x3D1
                                if(__var3873 >= 0)
                                {
                                    AccompanyItem.GetItem(__var3873, AccompanyInfo);
                                    __NFUN_406__(AccompanyInfo.ItemNum, __var2038);
                                    AccompanyItem.SetItem(__var3873, AccompanyInfo);                                    
                                }
                                else
                                {
                                    InventoryItem.GetItem(__var3874, invenInfo);
                                    invenInfo.ItemNum = __var2038;
                                    AccompanyItem.AddItem(invenInfo);
                                }
                                // End:0x42E
                                if(__var13469)
                                {
                                    InventoryItem.DeleteItem(__var3874);                                    
                                }
                                else
                                {
                                    __NFUN_407__(scInfo.ItemNum, __var2038);
                                    InventoryItem.SetItem(__var3874, scInfo);
                                }
                                totalWeight += (scInfo.Weight * name(__var2038));
                                FeeAdena = (CalculateFeeAdena());
                                SetWeight();
                                SetFeeAdena();
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function HandlePostWriteOpen()
{
    // End:0x21
    if(PostBoxWnd.IsShowWindow())
    {
        PostBoxWnd.HideWindow();
    }
    return;
}

function HandleSentEnableAddItem(string param)
{
    local ItemInfo Info;

    ParamToItemInfo(param, Info);
    InventoryItem.AddItem(Info);
    // End:0x67
    if(Info.Id.ClassID == 57)
    {
        adenaInfo = Info;
        InventoryItem.SwapItems(0, InventoryItem.GetItemNum() - 1);
    }
    return;
}

function HandlePostWriteEnd()
{
    SetInventoryPageNumber();
    return;
}

function HandleReplyWritePost(string param)
{
    local int __var14917;

    ParseInt(param, "Success", __var14917);
    // End:0x4D
    if(__var14917 == 1)
    {
        ReceiverID.AddItemToAutoCompleteHistory(strSendID);
        Me.HideWindow();
        ClearAll();
    }
    return;
}

function HandleSendBtn()
{
    // End:0x58
    if((PostTypeComboBox.GetSelectedNum() == 1) && AccompanyItem.GetItemNum() <= 0)
    {
        DialogHide();
        DialogShow(1, 5, GetSystemMessage(2966), string(self));
        DialogSetID(5555);        
    }
    else
    {
        // End:0x9A
        if(PostTitle.GetString() == "")
        {
            DialogHide();
            DialogShow(1, 5, GetSystemMessage(328), string(self));
            DialogSetID(5555);            
        }
        else
        {
            // End:0xEB
            if((PostTypeComboBox.GetSelectedNum() == 1) && __NFUN_412__(SafetyTradeAdena, (0)))
            {
                DialogHide();
                DialogShow(1, 5, GetSystemMessage(3020), string(self));
                DialogSetID(5555);                
            }
            else
            {
                // End:0x12F
                if(Len(ReceiverID.GetString()) > 24)
                {
                    DialogHide();
                    DialogShow(1, 5, GetSystemMessage(3074), string(self));
                    DialogSetID(5555);                    
                }
                else
                {
                    // End:0x173
                    if(Len(PostTitle.GetString()) > 60)
                    {
                        DialogHide();
                        DialogShow(1, 5, GetSystemMessage(3075), string(self));
                        DialogSetID(5555);                        
                    }
                    else
                    {
                        // End:0x1BA
                        if(Len(contents.GetString()) > 1000)
                        {
                            DialogHide();
                            DialogShow(1, 5, GetSystemMessage(3076), string(self));
                            DialogSetID(5555);                            
                        }
                        else
                        {
                            DialogHide();
                            // End:0x1F0
                            if(PostTypeComboBox.GetSelectedNum() == 0)
                            {
                                DialogShow(0, 0, GetSystemMessage(2967), string(self));                                
                            }
                            else
                            {
                                DialogShow(0, 0, GetSystemMessage(3078), string(self));
                            }
                            DialogSetID(4444);
                        }
                    }
                }
            }
        }
    }
    return;
}

function HandleSafetyReceiveAdena()
{
    DialogSetID(3333);
    DialogSetParamInt64((0));
    DialogShow(0, 6, GetSystemMessage(2987), string(self));
    return;
}

function SendPostMsg()
{
    local int __var7806;
    local ItemInfo ItemInfo;
    local RequestItem item;
    local string __var14899;

    itemIDList.Remove(0, itemIDList.Length);
    __var7806 = 0;
    J0x14:

    // End:0xA1 [Loop If]
    if(__var7806 < AccompanyItem.GetItemNum())
    {
        AccompanyItem.GetItem(__var7806, ItemInfo);
        item.Id = ItemInfo.Id.ServerID;
        item.amount = ItemInfo.ItemNum;
        itemIDList.Insert(itemIDList.Length, 1);
        itemIDList[itemIDList.Length - 1] = item;
        __var7806++;
        // [Loop Continue]
        goto J0x14;
    }
    // End:0xBF
    if(PostTypeComboBox.GetSelectedNum() == 0)
    {
        SafetyTradeAdena = (0);
    }
    strSendID = ReceiverID.GetString();
    __var14899 = ReceiverID.GetString();
    // End:0x195
    if(Len(__var14899) > 0)
    {
        RequestSendPost(ReceiverID.GetString(), PostTypeComboBox.GetSelectedNum(), PostTitle.GetString(), contents.GetString(), itemIDList, SafetyTradeAdena);
        onSendPost(ReceiverID.GetString(), PostTypeComboBox.GetSelectedNum(), PostTitle.GetString(), contents.GetString(), itemIDList, SafetyTradeAdena);        
    }
    else
    {
        AddSystemMessage(3002);
    }
    return;
}

delegate onSendPost(string receivedPerson, int safeMail, string Title, string contents, array<RequestItem> itemIDList, INT64 nAdena)
{
    return;
}

function ClearAll()
{
    PostTypeComboBox.Clear();
    PostTypeComboBox.AddStringWithReserved(GetSystemString(2071), 0);
    PostTypeComboBox.AddStringWithReserved(GetSystemString(2072), 1);
    PostTypeComboBox.SetSelectedNum(0);
    FeeAdena = (0);
    totalWeight = 0;
    SafetyTradeAdena = (0);
    ReceiverID.SetString("");
    ReceiverID.SetMaxLength(24);
    PostTypeComboBox.SetSelectedNum(0);
    PostTitle.SetString("");
    PostTitle.SetMaxLength(60);
    contents.SetString("");
    itemIDList.Remove(0, itemIDList.Length);
    SafetyTradeAdena = (0);
    SafetyTradeAdenaTextBox.SetText("0");
    WeightText.SetText("0");
    ChargeAdenaText.SetText("0");
    AccompanyItem.Clear();
    InventoryItem.Clear();
    FeeAdena = (CalculateFeeAdena());
    SetWeight();
    SetFeeAdena();
    DisableSafetyAdena();
    return;
}

function SetPostWriteWnd(string senderName, string Title, string context)
{
    ClearAll();
    ReceiverID.SetString(senderName);
    PostTitle.SetString(Title);
    contents.SetString(context);
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function int CalculateFeeAdena()
{
    local int __var14887;

    __var14887 = BASE_FEE_ADENA + (FEE_PER_SLOT * AccompanyItem.GetItemNum());
    return __var14887;
    return;
}

function SetInventoryPageNumber()
{
    // End:0x2C
    if(InventoryItem.GetSideTypePageNum() == 0)
    {
        InventoryPageNumber.SetText("0/0");        
    }
    else
    {
        InventoryPageNumber.SetText((string(InventoryItem.GetSideTypeCurPage() + 1) $ "/") $ string(InventoryItem.GetSideTypePageNum()));
    }
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey nKey)
{
    // End:0x53
    if(int(nKey) == 9)
    {
        // End:0x32
        if(ReceiverID.IsFocused())
        {
            PostTitle.SetFocus();            
        }
        else
        {
            // End:0x53
            if(PostTitle.IsFocused())
            {
                contents.SetFocus();
            }
        }
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="PostWriteWnd"
}