class TeleportBookMarkDrawerWnd extends UICommonAPI;

const TEMPLATEICONNAME = "L2ui_ct1.TeleportBookMark_DF_Icon_";
const BOOKMARKICON_MAX_COUNT = 42;

var WindowHandle Me;
var TextBoxHandle txtHead;
var TextBoxHandle txtSaveSlotHead;
var EditBoxHandle EditCurrentSaveBookMarkName;
var TextBoxHandle txtIconName;
var TextBoxHandle txtTeleportBookMarkDrawerWndNameHead;
var EditBoxHandle EditCurrentSaveBookMarkIcn;
var TextureHandle TexItemTemplate;
var ButtonHandle btnIconPrev;
var ButtonHandle btnIconNext;
var ButtonHandle btnSave;
var ButtonHandle btnCancel;
var TextBoxHandle txtSaveLocHead;
var TextBoxHandle txtSaveName;
var TextureHandle IconBack;
var TextBoxHandle txtTeleportFlagCount;
var int bUseTeleportFlag;
var ItemWindowHandle ItemBookMarkItem;
var int m_CurIconNum;

function OnLoad()
{
    SetClosingOnESC();
    InitializeCOD();
    load();
    m_CurIconNum = 1;
    HandleIconList();
    GetINIBool("Localize", "UseTeleportFlag", bUseTeleportFlag, "L2.ini");
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(2420);
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("TeleportBookMarkDrawerWnd");
    txtHead = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtHead");
    txtSaveSlotHead = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtSaveSlotHead");
    EditCurrentSaveBookMarkName = GetEditBoxHandle("TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkName");
    txtIconName = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtIconName");
    EditCurrentSaveBookMarkIcn = GetEditBoxHandle("TeleportBookMarkDrawerWnd.EditCurrentSaveBookMarkIcn");
    txtTeleportBookMarkDrawerWndNameHead = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtTeleportBookMarkDrawerWndNameHead");
    TexItemTemplate = GetTextureHandle("TeleportBookMarkDrawerWnd.TexItemTemplate");
    btnIconPrev = GetButtonHandle("TeleportBookMarkDrawerWnd.btnIconPrev");
    btnIconNext = GetButtonHandle("TeleportBookMarkDrawerWnd.btnIconNext");
    btnSave = GetButtonHandle("TeleportBookMarkDrawerWnd.btnSave");
    btnCancel = GetButtonHandle("TeleportBookMarkDrawerWnd.btnCancel");
    txtSaveLocHead = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtSaveLocHead");
    txtSaveName = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtSaveName");
    IconBack = GetTextureHandle("TeleportBookMarkDrawerWnd.IconBack");
    txtTeleportFlagCount = GetTextBoxHandle("TeleportBookMarkDrawerWnd.txtTeleportFlagCount");
    ItemBookMarkItem = GetItemWindowHandle("TeleportBookMarkDrawerWnd.ItemBookMarkItem");
    return;
}

function load()
{
    return;
}

function OnEvent(int EventID, string param)
{
    switch(EventID)
    {
        // End:0x12
        case 2420:
            // End:0x15
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnChangeEditBox(string strID)
{
    switch(strID)
    {
        // End:0x2F
        case "EditCurrentSaveBookMarkIcn":
            UpdateIconName();
            // End:0x32
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function UpdateIconName()
{
    local string strShortName;

    strShortName = EditCurrentSaveBookMarkIcn.GetString();
    txtIconName.SetText(strShortName);
    return;
}

function OnShow()
{
    UpdateIcon();
    txtTeleportFlagCount.SetText("");
    return;
}

function UpdateCurrentLocation()
{
    EditCurrentSaveBookMarkName.SetString(GetCurrentZoneName());
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1C
        case "btnSave":
            OnbtnSaveClick();
            // End:0x36
            break;
        // End:0x33
        case "btnCancel":
            OnbtnCancelClick();
            // End:0x36
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    m_CurIconNum = Index + 1;
    UpdateIcon();
    return;
}

function OnbtnSaveClick()
{
    local string slotTitle;
    local int iconID;
    local string iconTitle;
    local TeleportBookMarkWnd script;

    script = TeleportBookMarkWnd(GetScript("TeleportBookMarkWnd"));
    slotTitle = EditCurrentSaveBookMarkName.GetString();
    iconID = m_CurIconNum;
    iconTitle = EditCurrentSaveBookMarkIcn.GetString();
    iconTitle = Left(iconTitle, 4);
    // End:0xFE
    if(slotTitle != "")
    {
        // End:0xCE
        if(IsValidItemID(script.m_CurBookMarkItemID))
        {
            // End:0xCB
            if(Class'NWindow.BookMarkAPI'.static.RequestModifyBookMarkSlot(script.m_CurBookMarkItemID, slotTitle, iconID, iconTitle))
            {
                Me.HideWindow();
            }            
        }
        else
        {
            // End:0xFE
            if(Class'NWindow.BookMarkAPI'.static.RequestSaveBookMarkSlot(slotTitle, iconID, iconTitle))
            {
                Me.HideWindow();
            }
        }
    }
    return;
}

function HandleIconList()
{
    local int idx;
    local ItemInfo infItem;

    ItemBookMarkItem.Clear();
    idx = 0;
    J0x16:

    // End:0x7F [Loop If]
    if(idx < 42)
    {
        infItem.IconName = "L2ui_ct1.TeleportBookMark_DF_Icon_" $ (itoStr(idx + 1));
        ItemBookMarkItem.AddItem(infItem);
        idx++;
        // [Loop Continue]
        goto J0x16;
    }
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

function OnbtnCancelClick()
{
    Me.HideWindow();
    return;
}

function UpdateIcon()
{
    TexItemTemplate.SetTexture("L2ui_ct1.TeleportBookMark_DF_Icon_" $ (itoStr(m_CurIconNum)));
    return;
}

function InitializeUI()
{
    m_CurIconNum = 1;
    ItemBookMarkItem.SetSelectedNum(m_CurIconNum - 1);
    EditCurrentSaveBookMarkName.SetString("");
    EditCurrentSaveBookMarkIcn.SetString("");
    txtTeleportBookMarkDrawerWndNameHead.SetText(GetSystemString(1746));
    txtIconName.SetText("");
    UpdateIcon();
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("TeleportBookMarkDrawerWnd").HideWindow();
    return;
}
