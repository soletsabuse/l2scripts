class EnsoulSubWnd extends UICommonAPI;

const STATE_INSERT_WEAPON = "STATE_INSERT_WEAPON";
const STATE_INSERT_ENSOULSTONE = "STATE_INSERT_ENSOULSTONE";
const STATE_SELECT_ENSOUL = "STATE_SELECT_ENSOUL";
const STATE_CONFIRM_ENSOUL = "STATE_CONFIRM_ENSOUL";
const STATE_ASK_OVERWRITE = "STATE_ASK_OVERWRITE";
const STATE_RESULT = "STATE_RESULT";

var WindowHandle Me;
var TextureHandle SlotBg1_Texture;
var ItemWindowHandle EnsoulSubWnd_Item1;
var ItemWindowHandle EnsoulSubWnd_Item2;
var TabHandle EnsoulSubWnd_Tab;
var TextureHandle tabbgLine;
var TextureHandle tabBg;
var L2Util util;
var InventoryWnd inventoryWndScript;
var EnsoulWnd ensoulWndScript;

function OnRegisterEvent()
{
    return;
}

function OnShow()
{
    syncInventory();
    return;
}

function syncInventory()
{
    local array<ItemInfo> itemarray;
    local int i, nStackableNum;

    // End:0x96
    if(EnsoulSubWnd_Tab.GetTopIndex() == 0)
    {
        itemarray = inventoryWndScript.getInventoryEnSoulEnableItemArray();
        EnsoulSubWnd_Item1.Clear();
        i = 0;
        J0x40:

        // End:0x93 [Loop If]
        if(i < itemarray.Length)
        {
            // End:0x89
            if(!ensoulWndScript.externalCheckUsingItem(itemarray[i]))
            {
                EnsoulSubWnd_Item1.AddItem(itemarray[i]);
            }
            i++;
            // [Loop Continue]
            goto J0x40;
        }        
    }
    else
    {
        // End:0x1E3
        if(EnsoulSubWnd_Tab.GetTopIndex() == 1)
        {
            itemarray = inventoryWndScript.getInventoryEnSoulStoneArray();
            EnsoulSubWnd_Item2.Clear();
            i = 0;
            J0xD6:

            // End:0x1E3 [Loop If]
            if(i < itemarray.Length)
            {
                nStackableNum = 0;
                // End:0x1A0
                if(IsStackableItem(itemarray[i].ConsumeType))
                {
                    // End:0x153
                    if(ensoulWndScript.externalCheckUsingItem(itemarray[i], nStackableNum))
                    {
                        itemarray[i].ItemNum = __NFUN_405__(itemarray[i].ItemNum, (nStackableNum));
                    }
                    // End:0x189
                    if(__NFUN_409__(itemarray[i].ItemNum, (0)))
                    {
                        EnsoulSubWnd_Item2.AddItem(itemarray[i]);                        
                    }
                    else
                    {
                        EnsoulSubWnd_Item2.DeleteItem(i);
                    }
                    // [Explicit Continue]
                    goto J0x1D9;
                }
                // End:0x1D9
                if(!ensoulWndScript.externalCheckUsingItem(itemarray[i]))
                {
                    EnsoulSubWnd_Item2.AddItem(itemarray[i]);
                }
                J0x1D9:

                i++;
                // [Loop Continue]
                goto J0xD6;
            }
        }
    }
    return;
}

function setLock(bool bLock)
{
    // End:0x2A
    if(bLock)
    {
        EnsoulSubWnd_Item1.DisableWindow();
        EnsoulSubWnd_Item2.DisableWindow();        
    }
    else
    {
        EnsoulSubWnd_Item1.EnableWindow();
        EnsoulSubWnd_Item2.EnableWindow();
    }
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function OnClickButton(string Name)
{
    OnShow();
    switch(Name)
    {
        // End:0x26
        case "EnsoulInfo_Button":
            // End:0x29
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnDBClickItem(string ControlName, int Index)
{
    local ItemInfo Info;

    // End:0x37
    if((ControlName == "EnsoulSubWnd_Item1") && EnsoulSubWnd_Item1.IsEnableWindow() == false)
    {
        return;
    }
    // End:0x6E
    if((ControlName == "EnsoulSubWnd_Item2") && EnsoulSubWnd_Item2.IsEnableWindow() == false)
    {
        return;
    }
    // End:0x190
    if(((ensoulWndScript.getCurrentEnsoulState() == "STATE_INSERT_WEAPON") || ensoulWndScript.getCurrentEnsoulState() == "STATE_INSERT_ENSOULSTONE") || ensoulWndScript.getCurrentEnsoulState() == "STATE_SELECT_ENSOUL")
    {
        // End:0x140
        if(ControlName == "EnsoulSubWnd_Item1")
        {
            EnsoulSubWnd_Item1.GetItem(Index, Info);
            ensoulWndScript.InsertWeapon(Info);            
        }
        else
        {
            // End:0x190
            if(ControlName == "EnsoulSubWnd_Item2")
            {
                EnsoulSubWnd_Item2.GetItem(Index, Info);
                ensoulWndScript.InsertEnsoulStone(-1, Info);
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

function Initialize()
{
    Me = GetWindowHandle("EnsoulSubWnd");
    SlotBg1_Texture = GetTextureHandle("EnsoulSubWnd.SlotBg1_Texture");
    EnsoulSubWnd_Item1 = GetItemWindowHandle("EnsoulSubWnd.EnsoulSubWnd_Item1");
    EnsoulSubWnd_Item2 = GetItemWindowHandle("EnsoulSubWnd.EnsoulSubWnd_Item2");
    EnsoulSubWnd_Tab = GetTabHandle("EnsoulSubWnd.EnsoulSubWnd_Tab");
    tabbgLine = GetTextureHandle("EnsoulSubWnd.tabbgLine");
    tabBg = GetTextureHandle("EnsoulSubWnd.tabbg");
    util = L2Util(GetScript("L2Util"));
    inventoryWndScript = InventoryWnd(GetScript("inventoryWnd"));
    ensoulWndScript = EnsoulWnd(GetScript("EnsoulWnd"));
    return;
}

function setTabIndex(int nIndex)
{
    EnsoulSubWnd_Tab.SetTopOrder(nIndex, false);
    syncInventory();
    return;
}
