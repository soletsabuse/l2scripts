class zAutoPotionWnd extends PacketsInfo;

const CP_TIMER = 100;
const bCP_TIMER = 200;
const HP_TIMER = 300;
const MP_TIMER = 400;
const MP2_TIMER = 500;
const ELIXIR1_TIMER = 600;
const ELIXIR2_TIMER = 700;
const ELIXIR3_TIMER = 800;

var array<int> invSkills;
var int Type;
var ItemWindowHandle InvenItem;
var ItemWindowHandle QuestItem;
var int POTION_DELAY;
var int bPOTION_DELAY;
var int HP_POTION_DELAY;
var int MP_DELAY;
var int MP2_DELAY;
var int ELIXIR1_DELAY;
var int ELIXIR2_DELAY;
var int ELIXIR3_DELAY;
var WindowHandle Me;
var WindowHandle AutoPotionParamWnd;
var zAutoPotionParamWnd SC_AutoPotionParamWnd;
var ItemWindowHandle iCPslot;
var ItemWindowHandle ibCPslot;
var ItemWindowHandle iHPslot;
var ItemWindowHandle iMPslot;
var ItemWindowHandle iMP2slot;
var ItemWindowHandle iElixir1slot;
var ItemWindowHandle iElixir2slot;
var ItemWindowHandle iElixir3slot;
var AnimTextureHandle AnimCP;
var AnimTextureHandle AnimbCP;
var AnimTextureHandle AnimHP;
var AnimTextureHandle AnimMP;
var AnimTextureHandle AnimMP2;
var AnimTextureHandle AnimElixir1;
var AnimTextureHandle AnimElixir2;
var AnimTextureHandle AnimElixir3;
var ButtonHandle SettingBtn;
var TextureHandle BG1;
var TextureHandle BG2;
var TextureHandle BG3;
var TextureHandle BG4;
var TextureHandle BG5;
var TextureHandle BG6;
var TextureHandle BG7;
var TextureHandle BG8;
var array<TextureHandle> BGs;
var array<TextureHandle> GoldBGs;
var ItemID iCP;
var ItemID ibCP;
var ItemID iHP;
var ItemID imp;
var ItemID iMP2;
var ItemID iElixir1;
var ItemID iElixir2;
var ItemID iElixir3;
var int iSoulSkill;
var bool IsOly;
var SliderCtrlHandle sCP;
var SliderCtrlHandle sbCP;
var SliderCtrlHandle sHP;
var SliderCtrlHandle sMP;
var SliderCtrlHandle sMP2;
var StatusIconHandle StatusIcon;
var int currCP;
var int currHP;
var int currMP;
var int currSOUL;
var bool bFirstTime;
var int currentClassID;

function OnLoad()
{
    local int i;

    Me = GetWindowHandle("AutoPotionWnd");
    AutoPotionParamWnd = GetWindowHandle("AutoPotionParamWnd");
    SC_AutoPotionParamWnd = zAutoPotionParamWnd(GetScript("zAutoPotionParamWnd"));
    iCPslot = GetItemWindowHandle("AutoPotionWnd.CPslot");
    ibCPslot = GetItemWindowHandle("AutoPotionWnd.bCPslot");
    iHPslot = GetItemWindowHandle("AutoPotionWnd.HPSlot");
    iMPslot = GetItemWindowHandle("AutoPotionWnd.MPSlot");
    iMP2slot = GetItemWindowHandle("AutoPotionWnd.MP2Slot");
    iElixir1slot = GetItemWindowHandle("AutoPotionWnd.Elixir1Slot");
    iElixir2slot = GetItemWindowHandle("AutoPotionWnd.Elixir2Slot");
    iElixir3slot = GetItemWindowHandle("AutoPotionWnd.Elixir3Slot");
    AnimCP = GetAnimTextureHandle("AutoPotionWnd.AnimCP");
    AnimbCP = GetAnimTextureHandle("AutoPotionWnd.AnimbCP");
    AnimHP = GetAnimTextureHandle("AutoPotionWnd.AnimHP");
    AnimMP = GetAnimTextureHandle("AutoPotionWnd.AnimMP");
    AnimMP2 = GetAnimTextureHandle("AutoPotionWnd.AnimMP2");
    AnimElixir1 = GetAnimTextureHandle("AutoPotionWnd.AnimElixir1");
    AnimElixir2 = GetAnimTextureHandle("AutoPotionWnd.AnimElixir2");
    AnimElixir3 = GetAnimTextureHandle("AutoPotionWnd.AnimElixir3");
    SettingBtn = GetButtonHandle("AutoPotionWnd.SettingBtn");
    BGs[0] = GetTextureHandle("AutoPotionWnd.CPBG");
    BGs[1] = GetTextureHandle("AutoPotionWnd.bCPBG");
    BGs[2] = GetTextureHandle("AutoPotionWnd.HPBG");
    BGs[3] = GetTextureHandle("AutoPotionWnd.MPBG");
    BGs[4] = GetTextureHandle("AutoPotionWnd.MP2BG");
    BGs[5] = GetTextureHandle("AutoPotionWnd.Elixir1BG");
    BGs[6] = GetTextureHandle("AutoPotionWnd.Elixir2BG");
    BGs[7] = GetTextureHandle("AutoPotionWnd.Elixir3BG");
    i = 0;
    J0x3F7:

    // End:0x441 [Loop If]
    if(i < BGs.Length)
    {
        BGs[i].SetTextureCtrlType(0);
        BGs[i].SetTextureSize(32, 32);
        i++;
        // [Loop Continue]
        goto J0x3F7;
    }
    GoldBGs[0] = GetTextureHandle("AutoPotionWnd.GoldPanelIcon1");
    GoldBGs[1] = GetTextureHandle("AutoPotionWnd.GoldPanelIcon2");
    GoldBGs[2] = GetTextureHandle("AutoPotionWnd.GoldPanelIcon3");
    GoldBGs[3] = GetTextureHandle("AutoPotionWnd.GoldPanelIcon4");
    GoldBGs[4] = GetTextureHandle("AutoPotionWnd.GoldPanelIcon5");
    GoldBGs[5] = GetTextureHandle("AutoPotionWnd.GoldPanelIcon6");
    GoldBGs[6] = GetTextureHandle("AutoPotionWnd.GoldPanelIcon7");
    GoldBGs[7] = GetTextureHandle("AutoPotionWnd.GoldPanelIcon8");
    sCP = GetSliderCtrlHandle("AutoPotionParamWnd.CP");
    sbCP = GetSliderCtrlHandle("AutoPotionParamWnd.bCP");
    sHP = GetSliderCtrlHandle("AutoPotionParamWnd.HP");
    sMP = GetSliderCtrlHandle("AutoPotionParamWnd.MP");
    sMP2 = GetSliderCtrlHandle("AutoPotionParamWnd.MP2");
    InvenItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
    QuestItem = GetItemWindowHandle("InventoryWnd.QuestItem");
    StatusIcon = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon");
    InitializeDefaultSettings();
    InitializeInvulList();
    InintializeSavedSettings();
    InitializeSavedPercent();
    ShortcutWnd(GetScript("ShortcutWnd")).ReAnchorPotion();
    return;
}

function InitializeDefaultSettings()
{
    IsOly = false;
    POTION_DELAY = 700;
    bPOTION_DELAY = 700;
    HP_POTION_DELAY = 700;
    MP_DELAY = 700;
    MP2_DELAY = 250;
    ELIXIR1_DELAY = 1000;
    ELIXIR2_DELAY = 1000;
    ELIXIR3_DELAY = 1000;
    AnimCP.SetLoopCount(0);
    AnimCP.Stop();
    AnimbCP.SetLoopCount(0);
    AnimbCP.Stop();
    AnimHP.SetLoopCount(0);
    AnimHP.Stop();
    AnimMP.SetLoopCount(0);
    AnimMP.Stop();
    AnimMP2.SetLoopCount(0);
    AnimMP2.Stop();
    AnimElixir1.SetLoopCount(0);
    AnimElixir1.Stop();
    AnimElixir2.SetLoopCount(0);
    AnimElixir2.Stop();
    AnimElixir3.SetLoopCount(0);
    AnimElixir3.Stop();
    AnimCP.HideWindow();
    AnimbCP.HideWindow();
    AnimHP.HideWindow();
    AnimMP.HideWindow();
    AnimMP2.HideWindow();
    AnimElixir1.HideWindow();
    AnimElixir2.HideWindow();
    AnimElixir3.HideWindow();
    return;
}

function getElixir(out int cp, out int hp, out int mp)
{
    local int nLevel;
    local UserInfo PlayerInfo;

    // End:0x180
    if(GetPlayerInfo(PlayerInfo))
    {
        nLevel = PlayerInfo.nLevel;
        // End:0x5B
        if((nLevel >= 0) && nLevel < 20)
        {
            cp = 8634;
            hp = 8622;
            mp = 8628;            
        }
        else
        {
            // End:0x99
            if((nLevel >= 20) && nLevel < 40)
            {
                cp = 8635;
                hp = 8623;
                mp = 8629;                
            }
            else
            {
                // End:0xD7
                if((nLevel >= 40) && nLevel < 52)
                {
                    cp = 8636;
                    hp = 8624;
                    mp = 8630;                    
                }
                else
                {
                    // End:0x115
                    if((nLevel >= 52) && nLevel < 61)
                    {
                        cp = 8637;
                        hp = 8625;
                        mp = 8631;                        
                    }
                    else
                    {
                        // End:0x153
                        if((nLevel >= 61) && nLevel < 76)
                        {
                            cp = 8638;
                            hp = 8626;
                            mp = 8632;                            
                        }
                        else
                        {
                            // End:0x180
                            if(nLevel >= 76)
                            {
                                cp = 8639;
                                hp = 8627;
                                mp = 8633;
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function initElixir()
{
    local int CpElixirID, HpElixirID, MpElixirID;
    local ItemInfo CpInfo, HpInfo, MpInfo;

    getElixir(CpElixirID, HpElixirID, MpElixirID);
    InventoryWnd(GetScript("InventoryWnd")).getInventoryItemInfo(GetItemID(CpElixirID), CpInfo, true);
    InventoryWnd(GetScript("InventoryWnd")).getInventoryItemInfo(GetItemID(HpElixirID), HpInfo, true);
    InventoryWnd(GetScript("InventoryWnd")).getInventoryItemInfo(GetItemID(MpElixirID), MpInfo, true);
    iElixir1.ClassID = CpElixirID;
    iElixir2.ClassID = HpElixirID;
    iElixir3.ClassID = MpElixirID;
    CpInfo.Id = iElixir1;
    HpInfo.Id = iElixir2;
    MpInfo.Id = iElixir3;
    // End:0x1B1
    if(__NFUN_409__(CpInfo.ItemNum, (0)))
    {
        UpdateItem(CpInfo, "update");
        // End:0x1AE
        if(GetOptionBool(GetMyName(), "ELIXIR1"))
        {
            Me.KillTimer(600);
            Me.SetTimer(600, ELIXIR1_DELAY);
            AnimElixir1.SetLoopCount(999999999);
            AnimElixir1.Play();
            AnimElixir1.ShowWindow();
        }        
    }
    else
    {
        UpdateItem(HpInfo, "delete");
    }
    // End:0x264
    if(__NFUN_409__(HpInfo.ItemNum, (0)))
    {
        UpdateItem(HpInfo, "update");
        // End:0x261
        if(GetOptionBool(GetMyName(), "ELIXIR2"))
        {
            Me.KillTimer(700);
            Me.SetTimer(700, ELIXIR2_DELAY);
            AnimElixir2.SetLoopCount(999999999);
            AnimElixir2.Play();
            AnimElixir2.ShowWindow();
        }        
    }
    else
    {
        UpdateItem(MpInfo, "delete");
    }
    // End:0x317
    if(__NFUN_409__(MpInfo.ItemNum, (0)))
    {
        UpdateItem(MpInfo, "update");
        // End:0x314
        if(GetOptionBool(GetMyName(), "ELIXIR3"))
        {
            Me.KillTimer(800);
            Me.SetTimer(800, ELIXIR3_DELAY);
            AnimElixir3.SetLoopCount(999999999);
            AnimElixir3.Play();
            AnimElixir3.ShowWindow();
        }        
    }
    else
    {
        UpdateItem(MpInfo, "delete");
    }
    return;
}

function InintializeSavedSettings()
{
    local UserInfo Player;
    local ItemInfo iCPinfo, ibCPinfo, iHPinfo, iMPinfo, iMP2info, iElixir1info,
	    iElixir2info, iElixir3info;

    local int CpElixirID, HpElixirID, MpElixirID;

    GetPlayerInfo(Player);
    getElixir(CpElixirID, HpElixirID, MpElixirID);
    iCP.ClassID = 5591;
    ibCP.ClassID = 5592;
    // End:0x5C
    if(getIsEnergyConsumer())
    {
        iMP2.ClassID = 5589;        
    }
    else
    {
        // End:0x78
        if(IsSoulConsumer())
        {
            iMP2.ClassID = 10410;            
        }
        else
        {
            iMP2.ClassID = 0;
        }
    }
    iHP.ClassID = GetOptionInt(GetMyName(), "ACP_slot_3_class");
    iHP.ServerID = GetOptionInt(GetMyName(), "ACP_slot_3_server");
    imp.ClassID = GetOptionInt(GetMyName(), "ACP_slot_4_class");
    imp.ServerID = GetOptionInt(GetMyName(), "ACP_slot_4_server");
    iElixir1.ClassID = CpElixirID;
    iElixir2.ClassID = HpElixirID;
    iElixir3.ClassID = MpElixirID;
    InventoryWnd(GetScript("InventoryWnd")).getInventoryItemInfo(iCP, iCPinfo, true);
    InventoryWnd(GetScript("InventoryWnd")).getInventoryItemInfo(ibCP, ibCPinfo, true);
    InventoryWnd(GetScript("InventoryWnd")).getInventoryItemInfo(iHP, iHPinfo, true);
    InventoryWnd(GetScript("InventoryWnd")).getInventoryItemInfo(imp, iMPinfo, true);
    InventoryWnd(GetScript("InventoryWnd")).getInventoryItemInfo(iMP2, iMP2info, true);
    InventoryWnd(GetScript("InventoryWnd")).getInventoryItemInfo(iElixir1, iElixir1info, true);
    InventoryWnd(GetScript("InventoryWnd")).getInventoryItemInfo(iElixir2, iElixir2info, true);
    InventoryWnd(GetScript("InventoryWnd")).getInventoryItemInfo(iElixir3, iElixir3info, true);
    // End:0x361
    if(__NFUN_409__(iCPinfo.ItemNum, (0)))
    {
        UpdateItem(iCPinfo, "update");
        // End:0x35E
        if(GetOptionBool(GetMyName(), "50CP"))
        {
            Me.KillTimer(100);
            Me.SetTimer(100, POTION_DELAY);
            AnimCP.SetLoopCount(999999999);
            AnimCP.Play();
            AnimCP.ShowWindow();
        }        
    }
    else
    {
        UpdateItem(iCPinfo, "delete");
    }
    // End:0x40C
    if(__NFUN_409__(ibCPinfo.ItemNum, (0)))
    {
        UpdateItem(ibCPinfo, "update");
        // End:0x409
        if(GetOptionBool(GetMyName(), "200CP"))
        {
            Me.KillTimer(200);
            Me.SetTimer(200, bPOTION_DELAY);
            AnimbCP.SetLoopCount(999999999);
            AnimbCP.Play();
            AnimbCP.ShowWindow();
        }        
    }
    else
    {
        UpdateItem(ibCPinfo, "delete");
    }
    // End:0x4BA
    if(__NFUN_409__(iHPinfo.ItemNum, (0)))
    {
        UpdateItem(iHPinfo, "update");
        // End:0x4B7
        if(GetOptionBool(GetMyName(), "HP"))
        {
            Me.KillTimer(300);
            Me.SetTimer(300, HP_POTION_DELAY);
            AnimHP.SetLoopCount(999999999);
            AnimHP.Play();
            AnimHP.ShowWindow();
        }        
    }
    else
    {
        UpdateItem(iHPinfo, "delete");
    }
    // End:0x568
    if(__NFUN_409__(iMPinfo.ItemNum, (0)))
    {
        UpdateItem(iMPinfo, "update");
        // End:0x565
        if(GetOptionBool(GetMyName(), "MP"))
        {
            Me.KillTimer(400);
            Me.SetTimer(400, MP_DELAY);
            AnimMP.SetLoopCount(999999999);
            AnimMP.Play();
            AnimMP.ShowWindow();
        }        
    }
    else
    {
        UpdateItem(iMPinfo, "delete");
    }
    // End:0x617
    if(__NFUN_409__(iMP2info.ItemNum, (0)))
    {
        UpdateItem(iMP2info, "update");
        // End:0x614
        if(GetOptionBool(GetMyName(), "MP2"))
        {
            Me.KillTimer(500);
            Me.SetTimer(500, MP2_DELAY);
            AnimMP2.SetLoopCount(999999999);
            AnimMP2.Play();
            AnimMP2.ShowWindow();
        }        
    }
    else
    {
        UpdateItem(iMP2info, "delete");
    }
    // End:0x6CA
    if(__NFUN_409__(iElixir1info.ItemNum, (0)))
    {
        UpdateItem(iElixir1info, "update");
        // End:0x6C7
        if(GetOptionBool(GetMyName(), "ELIXIR1"))
        {
            Me.KillTimer(600);
            Me.SetTimer(600, ELIXIR1_DELAY);
            AnimElixir1.SetLoopCount(999999999);
            AnimElixir1.Play();
            AnimElixir1.ShowWindow();
        }        
    }
    else
    {
        UpdateItem(iElixir1info, "delete");
    }
    // End:0x77D
    if(__NFUN_409__(iElixir2info.ItemNum, (0)))
    {
        UpdateItem(iElixir2info, "update");
        // End:0x77A
        if(GetOptionBool(GetMyName(), "ELIXIR2"))
        {
            Me.KillTimer(700);
            Me.SetTimer(700, ELIXIR2_DELAY);
            AnimElixir2.SetLoopCount(999999999);
            AnimElixir2.Play();
            AnimElixir2.ShowWindow();
        }        
    }
    else
    {
        UpdateItem(iElixir2info, "delete");
    }
    // End:0x830
    if(__NFUN_409__(iElixir3info.ItemNum, (0)))
    {
        UpdateItem(iElixir3info, "update");
        // End:0x82D
        if(GetOptionBool(GetMyName(), "ELIXIR3"))
        {
            Me.KillTimer(800);
            Me.SetTimer(800, ELIXIR3_DELAY);
            AnimElixir3.SetLoopCount(999999999);
            AnimElixir3.Play();
            AnimElixir3.ShowWindow();
        }        
    }
    else
    {
        UpdateItem(iElixir3info, "delete");
    }
    AutoPotionInventoryViewer(GetScript("AutoPotionInventoryViewer")).syncInventory();
    return;
}

function InitializeInvulList()
{
    invSkills[0] = 1540;
    invSkills[1] = 922;
    invSkills[2] = 442;
    invSkills[3] = 443;
    invSkills[4] = 5576;
    invSkills[5] = 1418;
    invSkills[6] = 1427;
    invSkills[7] = 1505;
    invSkills[8] = 837;
    invSkills[9] = 21237;
    invSkills[10] = 3158;
    invSkills[11] = 18043;
    return;
}

function OnShow()
{
    return;
}

function OnRegisterEvent()
{
    RegisterEvent(110);
    RegisterEvent(150);
    RegisterEvent(160);
    RegisterEvent(580);
    RegisterEvent(5352);
    RegisterEvent(3550);
    RegisterEvent(2620);
    RegisterEvent(180);
    return;
}

function OnClickButton(string a_ControlID)
{
    // End:0x6A
    if(a_ControlID == "SettingBtn")
    {
        // End:0x50
        if(IsShow("AutoPotionParamWnd"))
        {
            HideW("AutoPotionParamWnd");            
        }
        else
        {
            ShowW("AutoPotionParamWnd");
        }
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x43
        case 150:
            ShortcutWnd(GetScript("ShortcutWnd")).ReAnchorPotion();
            InitializePotionStaticDelay();
            InitializeSavedPercent();
            InintializeSavedSettings();
            // End:0x121
            break;
        // End:0x59
        case 580:
            FindChatMessage(a_Param);
            // End:0x121
            break;
        // End:0x6F
        case 160:
            ResetAll();
            bFirstTime = false;
            // End:0x121
            break;
        // End:0x82
        case 5352:
            bFirstTime = false;
            // End:0x121
            break;
        // End:0xE8
        case 2620:
            // End:0xE5
            if(!bFirstTime && (GetUIState()) == "GAMINGSTATE")
            {
                bFirstTime = true;
                InintializeSavedSettings();
                ShortcutWnd(GetScript("ShortcutWnd")).ReAnchorPotion();
                PlaceItem();
            }
            // End:0x121
            break;
        // End:0x105
        case 180:
            // End:0x102
            if(bFirstTime)
            {
                checkLevelChange();
                checkClassChange();
            }
            // End:0x121
            break;
        // End:0x11B
        case 3550:
            _OnEvent(a_Param);
            // End:0x121
            break;
        // End:0xFFFF
        default:
            // End:0x121
            break;
            break;
    }
    return;
}

function _OnEvent(string param)
{
    local int Event_ID;

    ParseInt(param, "EventID", Event_ID);
    switch(Event_ID)
    {
        // End:0x36
        case 1450:
            handlePotionInfo(param);
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            // End:0x3C
            break;
            break;
    }
    return;
}

function handlePotionInfo(string param)
{
    local string delayParam;
    local array<string> delayInfo;

    ParseString(param, "param1", delayParam);
    delayInfo = Arr(delayParam, ",");
    // End:0x4A
    if(int(delayInfo[0]) > 0)
    {
        POTION_DELAY = int(delayInfo[0]);
    }
    // End:0x68
    if(int(delayInfo[1]) > 0)
    {
        bPOTION_DELAY = int(delayInfo[1]);
    }
    // End:0x88
    if(int(delayInfo[2]) > 0)
    {
        HP_POTION_DELAY = int(delayInfo[2]);
    }
    // End:0xA8
    if(int(delayInfo[3]) > 0)
    {
        MP_DELAY = int(delayInfo[3]);
    }
    // End:0xC8
    if(int(delayInfo[4]) > 0)
    {
        MP2_DELAY = int(delayInfo[4]);
    }
    // End:0xE8
    if(int(delayInfo[5]) > 0)
    {
        ELIXIR1_DELAY = int(delayInfo[5]);
    }
    // End:0x108
    if(int(delayInfo[6]) > 0)
    {
        ELIXIR2_DELAY = int(delayInfo[6]);
    }
    // End:0x128
    if(int(delayInfo[7]) > 0)
    {
        ELIXIR3_DELAY = int(delayInfo[7]);
    }
    return;
}

function InitializePotionStaticDelay()
{
    // End:0x54
    if(GetOptionInt(GetMyName(), "ACP_slot_5_delay_start") > (getCurrentSecond()))
    {
        SetOptionInt(GetMyName(), "ACP_slot_5_delay_start", 0);
    }
    // End:0xA8
    if(GetOptionInt(GetMyName(), "ACP_slot_6_delay_start") > (getCurrentSecond()))
    {
        SetOptionInt(GetMyName(), "ACP_slot_6_delay_start", 0);
    }
    // End:0xFC
    if(GetOptionInt(GetMyName(), "ACP_slot_7_delay_start") > (getCurrentSecond()))
    {
        SetOptionInt(GetMyName(), "ACP_slot_7_delay_start", 0);
    }
    ini(1);
    return;
}

function setPotionStaticDelay(int nType)
{
    switch(nType)
    {
        // End:0x38
        case 0:
            SetOptionInt(GetMyName(), "ACP_slot_5_delay_start", getCurrentSecond());
            // End:0xA1
            break;
        // End:0x69
        case 1:
            SetOptionInt(GetMyName(), "ACP_slot_6_delay_start", getCurrentSecond());
            // End:0xA1
            break;
        // End:0x9B
        case 2:
            SetOptionInt(GetMyName(), "ACP_slot_7_delay_start", getCurrentSecond());
            // End:0xA1
            break;
        // End:0xFFFF
        default:
            // End:0xA1
            break;
            break;
    }
    ini(1);
    return;
}

function bool getPotionStaticDelay(int nType)
{
    switch(nType)
    {
        // End:0x43
        case 0:
            // End:0x43
            if(((getCurrentSecond()) - GetOptionInt(GetMyName(), "ACP_slot_5_delay_start")) < 300)
            {
                return true;
            }
        // End:0x7F
        case 1:
            // End:0x7F
            if(((getCurrentSecond()) - GetOptionInt(GetMyName(), "ACP_slot_6_delay_start")) < 300)
            {
                return true;
            }
        // End:0xBC
        case 2:
            // End:0xBC
            if(((getCurrentSecond()) - GetOptionInt(GetMyName(), "ACP_slot_7_delay_start")) < 300)
            {
                return true;
            }
        // End:0xFFFF
        default:
            // End:0xC2
            break;
            break;
    }
    return;
}

function int getCurrentSecond()
{
    return int(GetAppSeconds());
    return;
}

function checkLevelChange()
{
    // End:0x3A
    if(getInstanceUIData().isLevelUP() || getInstanceUIData().isLevelDown())
    {
        currSOUL = getMaxSoulLevel();
        initElixir();
    }
    return;
}

function checkClassChange()
{
    local UserInfo Player;

    GetPlayerInfo(Player);
    // End:0x6A
    if((currentClassID <= 0) || currentClassID != Player.nSubClass)
    {
        ShortcutWnd(GetScript("ShortcutWnd")).ReAnchorPotion();
        InintializeSavedSettings();
        PlaceItem();
        currentClassID = Player.nSubClass;
    }
    return;
}

function FindChatMessage(string a_Param)
{
    local int idx;

    ParseInt(a_Param, "Index", idx);
    // End:0x78
    if((GetUIState()) == "GAMINGSTATE")
    {
        switch(idx)
        {
            // End:0x4F
            case 1495:
                ResetAll();
                IsOly = true;
                // End:0x78
                break;
            // End:0x57
            case 1657:
            // End:0x5F
            case 1658:
            // End:0x72
            case 1498:
                IsOly = false;
                // End:0x78
                break;
            // End:0xFFFF
            default:
                // End:0x78
                break;
                break;
        }
    }
    return;
}

function ResetAll()
{
    Me.KillTimer(100);
    Me.KillTimer(200);
    Me.KillTimer(300);
    Me.KillTimer(400);
    Me.KillTimer(500);
    Me.KillTimer(600);
    Me.KillTimer(700);
    Me.KillTimer(800);
    AnimCP.SetLoopCount(0);
    AnimCP.Stop();
    AnimbCP.SetLoopCount(0);
    AnimbCP.Stop();
    AnimHP.SetLoopCount(0);
    AnimHP.Stop();
    AnimMP.SetLoopCount(0);
    AnimMP.Stop();
    AnimMP2.SetLoopCount(0);
    AnimMP2.Stop();
    AnimElixir1.SetLoopCount(0);
    AnimElixir1.Stop();
    AnimElixir2.SetLoopCount(0);
    AnimElixir2.Stop();
    AnimElixir3.SetLoopCount(0);
    AnimElixir3.Stop();
    iCPslot.Clear();
    ibCPslot.Clear();
    iHPslot.Clear();
    iMPslot.Clear();
    iMP2slot.Clear();
    iElixir1slot.Clear();
    iElixir2slot.Clear();
    iElixir3slot.Clear();
    AnimCP.HideWindow();
    AnimbCP.HideWindow();
    AnimHP.HideWindow();
    AnimMP.HideWindow();
    AnimMP2.HideWindow();
    AnimElixir1.HideWindow();
    AnimElixir2.HideWindow();
    IsOly = false;
    return;
}

function bool IsActiveState(WindowHandle Handle)
{
    return Handle.IsShowWindow();
    return;
}

function InitializeSavedPercent()
{
    currCP = GetOptionInt(GetMyName(), "50CP_PER");
    currHP = GetOptionInt(GetMyName(), "HP_PER");
    currMP = GetOptionInt(GetMyName(), "MP_PER");
    currSOUL = getMaxSoulLevel();
    return;
}

function OnTimer(int TimerID)
{
    local ItemInfo CpInfo, bCPinfo, HpInfo, MpInfo, MP2info, Elixir1info,
	    Elixir2info, Elixir3info;

    local UserInfo Player;
    local StatusIconInfo Info;
    local float fPercentCP, fPercentHP, fPercentMP, fPercentMP2;
    local bool bUsagePriority;

    // End:0x2B
    if(IsOly && (GetUIState()) == "GAMINGSTATE")
    {
        ResetAll();
        return;
    }
    // End:0x4B
    if((GetUIState()) != "GAMINGSTATE")
    {
        ResetAll();
        return;
    }
    // End:0x56
    if(IsWrongCondition())
    {
        return;
    }
    GetPlayerInfo(Player);
    fPercentCP = (float(Player.nCurCP) / float(Player.nMaxCP)) * 100.0000000;
    fPercentHP = (float(Player.nCurHP) / float(Player.nMaxHP)) * 100.0000000;
    fPercentMP = (float(Player.nCurMP) / float(Player.nMaxMP)) * 100.0000000;
    bUsagePriority = (fPercentHP < float(currHP)) && fPercentMP < float(currMP);
    // End:0x121
    if(TimerID == 5555)
    {
        Me.KillTimer(5555);
    }
    // End:0x1AB
    if(TimerID == 100)
    {
        // End:0x1AB
        if((fPercentCP != float(100)) && fPercentCP < float(GetOptionInt(GetMyName(), "50CP_PER")))
        {
            Me.KillTimer(100);
            iCPslot.GetItem(0, CpInfo);
            RequestUseItem(CpInfo.Id);
            Me.SetTimer(100, POTION_DELAY);
        }
    }
    // End:0x236
    if(TimerID == 200)
    {
        // End:0x236
        if((fPercentCP != float(100)) && fPercentCP < float(GetOptionInt(GetMyName(), "200CP_PER")))
        {
            Me.KillTimer(200);
            ibCPslot.GetItem(0, bCPinfo);
            RequestUseItem(bCPinfo.Id);
            Me.SetTimer(200, bPOTION_DELAY);
        }
    }
    // End:0x35C
    if(TimerID == 300)
    {
        iHPslot.GetItem(0, HpInfo);
        // End:0x2EF
        if(IsHPPotion(HpInfo.Id.ClassID))
        {
            // End:0x2EC
            if(((fPercentHP != float(100)) && fPercentHP < float(GetOptionInt(GetMyName(), "HP_PER"))) && !FindHpRecoveryEffect())
            {
                Me.KillTimer(300);
                RequestUseItem(HpInfo.Id);
                Me.SetTimer(300, HP_POTION_DELAY);
            }            
        }
        else
        {
            // End:0x35C
            if((fPercentMP != float(100)) && fPercentMP < float(GetOptionInt(GetMyName(), "MP_PER")))
            {
                Me.KillTimer(300);
                RequestUseItem(HpInfo.Id);
                Me.SetTimer(300, HP_POTION_DELAY);
            }
        }
    }
    // End:0x482
    if(TimerID == 400)
    {
        iMPslot.GetItem(0, MpInfo);
        // End:0x415
        if(IsHPPotion(MpInfo.Id.ClassID))
        {
            // End:0x412
            if(((fPercentHP != float(100)) && fPercentHP < float(GetOptionInt(GetMyName(), "HP_PER"))) && !FindHpRecoveryEffect())
            {
                Me.KillTimer(400);
                RequestUseItem(MpInfo.Id);
                Me.SetTimer(400, MP_DELAY);
            }            
        }
        else
        {
            // End:0x482
            if((fPercentMP != float(100)) && fPercentMP < float(GetOptionInt(GetMyName(), "MP_PER")))
            {
                Me.KillTimer(400);
                RequestUseItem(MpInfo.Id);
                Me.SetTimer(400, MP_DELAY);
            }
        }
    }
    // End:0x59E
    if(TimerID == 500)
    {
        iMP2slot.GetItem(0, MP2info);
        // End:0x511
        if(MP2info.Id.ClassID == 5589)
        {
            // End:0x50E
            if(!FindEffectByLevel(4271, 2))
            {
                Me.KillTimer(500);
                RequestUseItem(MP2info.Id);
                Me.SetTimer(500, MP2_DELAY);
            }            
        }
        else
        {
            // End:0x59E
            if(MP2info.Id.ClassID == 10410)
            {
                // End:0x54B
                if(!IsSoulConsumer())
                {
                    Me.KillTimer(500);
                    return;
                }
                // End:0x59E
                if(!FindEffectByLevel(5446, getMaxSoulLevel()))
                {
                    Me.KillTimer(500);
                    RequestUseItem(MP2info.Id);
                    Me.SetTimer(500, MP2_DELAY);
                }
            }
        }
    }
    // End:0x659
    if(TimerID == 600)
    {
        // End:0x5B9
        if(getPotionStaticDelay(0))
        {
            return;
        }
        iElixir1slot.GetItem(0, Elixir1info);
        // End:0x659
        if((fPercentCP != float(100)) && fPercentCP < float(GetOptionInt(GetMyName(), "50CP_PER")))
        {
            Me.KillTimer(600);
            iElixir1slot.GetItem(0, Elixir1info);
            RequestUseItem(Elixir1info.Id);
            setPotionStaticDelay(1);
            Me.SetTimer(600, ELIXIR1_DELAY);
        }
    }
    // End:0x727
    if(TimerID == 700)
    {
        // End:0x681
        if((getPotionStaticDelay(1)) && getPotionStaticDelay(2))
        {
            return;
        }
        iElixir2slot.GetItem(0, Elixir2info);
        // End:0x727
        if((fPercentHP != float(100)) && fPercentHP < float(GetOptionInt(GetMyName(), "HP_PER")))
        {
            Me.KillTimer(700);
            iElixir2slot.GetItem(0, Elixir2info);
            RequestUseItem(Elixir2info.Id);
            setPotionStaticDelay(1);
            setPotionStaticDelay(2);
            Me.SetTimer(700, ELIXIR2_DELAY);
        }
    }
    // End:0x7F5
    if(TimerID == 800)
    {
        // End:0x74F
        if((getPotionStaticDelay(1)) && getPotionStaticDelay(2))
        {
            return;
        }
        iElixir3slot.GetItem(0, Elixir3info);
        // End:0x7F5
        if((fPercentMP != float(100)) && fPercentMP < float(GetOptionInt(GetMyName(), "MP_PER")))
        {
            Me.KillTimer(800);
            iElixir3slot.GetItem(0, Elixir3info);
            RequestUseItem(Elixir3info.Id);
            setPotionStaticDelay(1);
            setPotionStaticDelay(2);
            Me.SetTimer(800, ELIXIR3_DELAY);
        }
    }
    return;
}

function bool IsHPPotion(int ClassID)
{
    switch(ClassID)
    {
        // End:0x0F
        case 22025:
        // End:0x17
        case 1539:
        // End:0x1F
        case 1060:
        // End:0x29
        case 1061:
            return true;
        // End:0xFFFF
        default:
            // End:0x2F
            break;
            break;
    }
    return;
}

function Position(bool Vertical)
{
    local bool isSpecialSlot;

    isSpecialSlot = getIsSpecialSlotPlayer();
    // End:0x304
    if(!Vertical)
    {
        Me.SetWindowSize(265, 30);
        AutoPotionParamWnd.SetAnchor("AutoPotionWnd.SettingBtn", "TopRight", "BottomLeft", 4, -4);
        ibCPslot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 5, 1);
        iCPslot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 34, 1);
        iHPslot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 63, 1);
        iMPslot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 92, 1);
        iElixir1slot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 121, 1);
        iElixir2slot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 150, 1);
        iElixir3slot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 179, 1);
        // End:0x285
        if(isSpecialSlot)
        {
            iMP2slot.ShowWindow();
            BGs[4].ShowWindow();
            GoldBGs[4].ShowWindow();
            iMP2slot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 208, 1);
            SettingBtn.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 247, 7);
            restoreSpecialSlot();            
        }
        else
        {
            iMP2slot.HideWindow();
            BGs[4].HideWindow();
            GoldBGs[4].HideWindow();
            AnimMP2.HideWindow();
            SettingBtn.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 213, 7);
            deactivateSpecialSlot();
        }        
    }
    else
    {
        Me.SetWindowSize(30, 265);
        AutoPotionParamWnd.SetAnchor("AutoPotionWnd.SettingBtn", "BottomLeft", "TopRight", -4, 4);
        ibCPslot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 1, 5);
        iCPslot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 1, 34);
        iHPslot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 1, 63);
        iMPslot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 1, 92);
        iElixir1slot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 1, 121);
        iElixir2slot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 1, 150);
        iElixir3slot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 1, 179);
        // End:0x571
        if(isSpecialSlot)
        {
            iMP2slot.ShowWindow();
            BGs[4].ShowWindow();
            GoldBGs[4].ShowWindow();
            iMP2slot.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 1, 208);
            SettingBtn.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 7, 247);
            restoreSpecialSlot();            
        }
        else
        {
            iMP2slot.HideWindow();
            BGs[4].HideWindow();
            GoldBGs[4].HideWindow();
            AnimMP2.HideWindow();
            SettingBtn.SetAnchor("AutoPotionWnd", "TopLeft", "TopLeft", 7, 213);
            deactivateSpecialSlot();
        }
    }
    return;
}

function deactivateSpecialSlot()
{
    Me.KillTimer(500);
    AnimMP2.SetLoopCount(0);
    AnimMP2.Stop();
    AnimMP2.HideWindow();
    return;
}

function restoreSpecialSlot()
{
    // End:0x8E
    if(GetOptionBool(GetMyName(), "MP2") && __NFUN_409__(OwnItem(InvenItem, iMP2), (0)))
    {
        Me.KillTimer(500);
        Me.SetTimer(500, MP2_DELAY);
        AnimMP2.SetLoopCount(999999999);
        AnimMP2.Play();
        AnimMP2.ShowWindow();
    }
    return;
}

function OnClickItem(string strID, int Index)
{
    local ItemInfo CPinf, bCPinf, HPinf, MPinf, MP2inf, Elixir1inf,
	    Elixir2inf, Elixir3inf;

    switch(strID)
    {
        // End:0x3D
        case "CPslot":
            // End:0x3A
            if(iCPslot.GetItem(0, CPinf))
            {
                RequestUseItem(CPinf.Id);
            }
            // End:0x22E
            break;
        // End:0x74
        case "bCPslot":
            // End:0x71
            if(ibCPslot.GetItem(0, bCPinf))
            {
                RequestUseItem(bCPinf.Id);
            }
            // End:0x22E
            break;
        // End:0xAA
        case "HPslot":
            // End:0xA7
            if(iHPslot.GetItem(0, HPinf))
            {
                RequestUseItem(HPinf.Id);
            }
            // End:0x22E
            break;
        // End:0xE0
        case "MPslot":
            // End:0xDD
            if(iMPslot.GetItem(0, MPinf))
            {
                RequestUseItem(MPinf.Id);
            }
            // End:0x22E
            break;
        // End:0x117
        case "MP2slot":
            // End:0x114
            if(iMP2slot.GetItem(0, MP2inf))
            {
                RequestUseItem(MP2inf.Id);
            }
            // End:0x22E
            break;
        // End:0x165
        case "Elixir1slot":
            // End:0x133
            if(getPotionStaticDelay(0))
            {
                return;
            }
            // End:0x162
            if(iElixir1slot.GetItem(0, Elixir1inf))
            {
                setPotionStaticDelay(0);
                RequestUseItem(Elixir1inf.Id);
            }
            // End:0x22E
            break;
        // End:0x1C5
        case "Elixir2slot":
            // End:0x18E
            if((getPotionStaticDelay(1)) && getPotionStaticDelay(2))
            {
                return;
            }
            // End:0x1C5
            if(iElixir2slot.GetItem(0, Elixir2inf))
            {
                setPotionStaticDelay(1);
                setPotionStaticDelay(2);
                RequestUseItem(Elixir2inf.Id);
            }
        // End:0x228
        case "Elixir3slot":
            // End:0x1EE
            if((getPotionStaticDelay(1)) && getPotionStaticDelay(2))
            {
                return;
            }
            // End:0x225
            if(iElixir3slot.GetItem(0, Elixir3inf))
            {
                setPotionStaticDelay(1);
                setPotionStaticDelay(2);
                RequestUseItem(Elixir3inf.Id);
            }
            // End:0x22E
            break;
        // End:0xFFFF
        default:
            // End:0x22E
            break;
            break;
    }
    return;
}

function OnRDBClickItem(string strID, int Index)
{
    local ItemInfo inf;

    switch(strID)
    {
        // End:0x3F
        case "HPSlot":
            // End:0x3C
            if(!IsActiveState(AnimHP))
            {
                iHPslot.Clear();
                ClearItemID(iHP);
            }
            // End:0x7D
            break;
        // End:0x77
        case "MPSlot":
            // End:0x74
            if(!IsActiveState(AnimMP))
            {
                iMPslot.Clear();
                ClearItemID(imp);
            }
            // End:0x7D
            break;
        // End:0xFFFF
        default:
            // End:0x7D
            break;
            break;
    }
    return;
}

function OnRClickItem(string strID, int Index)
{
    // End:0x29
    if(Type == 12)
    {
        getInstanceL2Util().showGfxScreenMessage(GetSystemString(6470));
        return;
    }
    switch(strID)
    {
        // End:0xE7
        case "CPslot":
            // End:0x8B
            if(IsActiveState(AnimCP))
            {
                Me.KillTimer(100);
                AnimCP.SetLoopCount(0);
                AnimCP.Stop();
                AnimCP.HideWindow();                
            }
            else
            {
                Me.KillTimer(100);
                Me.SetTimer(100, POTION_DELAY);
                AnimCP.SetLoopCount(999999999);
                AnimCP.Play();
                AnimCP.ShowWindow();
            }
            // End:0x635
            break;
        // End:0x19F
        case "bCPslot":
            // End:0x143
            if(IsActiveState(AnimbCP))
            {
                Me.KillTimer(200);
                AnimbCP.SetLoopCount(0);
                AnimbCP.Stop();
                AnimbCP.HideWindow();                
            }
            else
            {
                Me.KillTimer(200);
                Me.SetTimer(200, bPOTION_DELAY);
                AnimbCP.SetLoopCount(999999999);
                AnimbCP.Play();
                AnimbCP.ShowWindow();
            }
            // End:0x635
            break;
        // End:0x25F
        case "HPslot":
            // End:0x1FD
            if(IsActiveState(AnimHP))
            {
                Me.KillTimer(300);
                AnimHP.SetLoopCount(0);
                AnimHP.Stop();
                AnimHP.HideWindow();                
            }
            else
            {
                Me.KillTimer(300);
                Me.SetTimer(300, HP_POTION_DELAY);
                AnimHP.SetLoopCount(999999999);
                AnimHP.Play();
                AnimHP.ShowWindow();
            }
            // End:0x635
            break;
        // End:0x31F
        case "MPslot":
            // End:0x2BD
            if(IsActiveState(AnimMP))
            {
                Me.KillTimer(400);
                AnimMP.SetLoopCount(0);
                AnimMP.Stop();
                AnimMP.HideWindow();                
            }
            else
            {
                Me.KillTimer(400);
                Me.SetTimer(400, MP_DELAY);
                AnimMP.SetLoopCount(999999999);
                AnimMP.Play();
                AnimMP.ShowWindow();
            }
            // End:0x635
            break;
        // End:0x3E0
        case "MP2slot":
            // End:0x37E
            if(IsActiveState(AnimMP2))
            {
                Me.KillTimer(500);
                AnimMP2.SetLoopCount(0);
                AnimMP2.Stop();
                AnimMP2.HideWindow();                
            }
            else
            {
                Me.KillTimer(500);
                Me.SetTimer(500, MP2_DELAY);
                AnimMP2.SetLoopCount(999999999);
                AnimMP2.Play();
                AnimMP2.ShowWindow();
            }
            // End:0x635
            break;
        // End:0x4A5
        case "Elixir1slot":
            // End:0x443
            if(IsActiveState(AnimElixir1))
            {
                Me.KillTimer(600);
                AnimElixir1.SetLoopCount(0);
                AnimElixir1.Stop();
                AnimElixir1.HideWindow();                
            }
            else
            {
                Me.KillTimer(600);
                Me.SetTimer(600, ELIXIR1_DELAY);
                AnimElixir1.SetLoopCount(999999999);
                AnimElixir1.Play();
                AnimElixir1.ShowWindow();
            }
            // End:0x635
            break;
        // End:0x56A
        case "Elixir2slot":
            // End:0x508
            if(IsActiveState(AnimElixir2))
            {
                Me.KillTimer(700);
                AnimElixir2.SetLoopCount(0);
                AnimElixir2.Stop();
                AnimElixir2.HideWindow();                
            }
            else
            {
                Me.KillTimer(700);
                Me.SetTimer(700, ELIXIR2_DELAY);
                AnimElixir2.SetLoopCount(999999999);
                AnimElixir2.Play();
                AnimElixir2.ShowWindow();
            }
            // End:0x635
            break;
        // End:0x62F
        case "Elixir3slot":
            // End:0x5CD
            if(IsActiveState(AnimElixir3))
            {
                Me.KillTimer(800);
                AnimElixir3.SetLoopCount(0);
                AnimElixir3.Stop();
                AnimElixir3.HideWindow();                
            }
            else
            {
                Me.KillTimer(800);
                Me.SetTimer(800, ELIXIR3_DELAY);
                AnimElixir3.SetLoopCount(999999999);
                AnimElixir3.Play();
                AnimElixir3.ShowWindow();
            }
            // End:0x635
            break;
        // End:0xFFFF
        default:
            // End:0x635
            break;
            break;
    }
    SetOptionBool(GetMyName(), "200CP", IsActiveState(AnimbCP));
    SetOptionBool(GetMyName(), "50CP", IsActiveState(AnimCP));
    SetOptionBool(GetMyName(), "HP", IsActiveState(AnimHP));
    SetOptionBool(GetMyName(), "MP", IsActiveState(AnimMP));
    SetOptionBool(GetMyName(), "MP2", IsActiveState(AnimMP2));
    SetOptionBool(GetMyName(), "ELIXIR1", IsActiveState(AnimElixir1));
    SetOptionBool(GetMyName(), "ELIXIR2", IsActiveState(AnimElixir2));
    SetOptionBool(GetMyName(), "ELIXIR3", IsActiveState(AnimElixir3));
    ini(1);
    return;
}

function UpdateItem(ItemInfo Info, string Type)
{
    local ItemInfo CurrentInfo;

    // End:0x0B
    if(IsOly)
    {
        return;
    }
    // End:0x560
    if((Type == "add") || Type == "update")
    {
        switch(Info.Id.ClassID)
        {
            // End:0xE2
            case iCP.ClassID:
                iCPslot.GetItem(0, CurrentInfo);
                // End:0x8B
                if(__NFUN_410__(CurrentInfo.ItemNum, (0)))
                {
                    iCPslot.AddItem(Info);                    
                }
                else
                {
                    // End:0xDF
                    if(__NFUN_413__(CurrentInfo.ItemNum, Info.ItemNum) || CurrentInfo.Id.ServerID != Info.Id.ServerID)
                    {
                        iCPslot.SetItem(0, Info);
                    }
                }
                // End:0x55D
                break;
            // End:0x185
            case ibCP.ClassID:
                ibCPslot.GetItem(0, CurrentInfo);
                // End:0x12E
                if(__NFUN_410__(CurrentInfo.ItemNum, (0)))
                {
                    ibCPslot.AddItem(Info);                    
                }
                else
                {
                    // End:0x182
                    if(__NFUN_413__(CurrentInfo.ItemNum, Info.ItemNum) || CurrentInfo.Id.ServerID != Info.Id.ServerID)
                    {
                        ibCPslot.SetItem(0, Info);
                    }
                }
                // End:0x55D
                break;
            // End:0x228
            case iHP.ClassID:
                iHPslot.GetItem(0, CurrentInfo);
                // End:0x1D1
                if(__NFUN_410__(CurrentInfo.ItemNum, (0)))
                {
                    iHPslot.AddItem(Info);                    
                }
                else
                {
                    // End:0x225
                    if(__NFUN_413__(CurrentInfo.ItemNum, Info.ItemNum) || CurrentInfo.Id.ServerID != Info.Id.ServerID)
                    {
                        iHPslot.SetItem(0, Info);
                    }
                }
                // End:0x55D
                break;
            // End:0x2CB
            case imp.ClassID:
                iMPslot.GetItem(0, CurrentInfo);
                // End:0x274
                if(__NFUN_410__(CurrentInfo.ItemNum, (0)))
                {
                    iMPslot.AddItem(Info);                    
                }
                else
                {
                    // End:0x2C8
                    if(__NFUN_413__(CurrentInfo.ItemNum, Info.ItemNum) || CurrentInfo.Id.ServerID != Info.Id.ServerID)
                    {
                        iMPslot.SetItem(0, Info);
                    }
                }
                // End:0x55D
                break;
            // End:0x36E
            case iMP2.ClassID:
                iMP2slot.GetItem(0, CurrentInfo);
                // End:0x317
                if(__NFUN_410__(CurrentInfo.ItemNum, (0)))
                {
                    iMP2slot.AddItem(Info);                    
                }
                else
                {
                    // End:0x36B
                    if(__NFUN_413__(CurrentInfo.ItemNum, Info.ItemNum) || CurrentInfo.Id.ServerID != Info.Id.ServerID)
                    {
                        iMP2slot.SetItem(0, Info);
                    }
                }
                // End:0x55D
                break;
            // End:0x411
            case iElixir1.ClassID:
                iElixir1slot.GetItem(0, CurrentInfo);
                // End:0x3BA
                if(__NFUN_410__(CurrentInfo.ItemNum, (0)))
                {
                    iElixir1slot.AddItem(Info);                    
                }
                else
                {
                    // End:0x40E
                    if(__NFUN_413__(CurrentInfo.ItemNum, Info.ItemNum) || CurrentInfo.Id.ServerID != Info.Id.ServerID)
                    {
                        iElixir1slot.SetItem(0, Info);
                    }
                }
                // End:0x55D
                break;
            // End:0x4B4
            case iElixir2.ClassID:
                iElixir2slot.GetItem(0, CurrentInfo);
                // End:0x45D
                if(__NFUN_410__(CurrentInfo.ItemNum, (0)))
                {
                    iElixir2slot.AddItem(Info);                    
                }
                else
                {
                    // End:0x4B1
                    if(__NFUN_413__(CurrentInfo.ItemNum, Info.ItemNum) || CurrentInfo.Id.ServerID != Info.Id.ServerID)
                    {
                        iElixir2slot.SetItem(0, Info);
                    }
                }
                // End:0x55D
                break;
            // End:0x557
            case iElixir3.ClassID:
                iElixir3slot.GetItem(0, CurrentInfo);
                // End:0x500
                if(__NFUN_410__(CurrentInfo.ItemNum, (0)))
                {
                    iElixir3slot.AddItem(Info);                    
                }
                else
                {
                    // End:0x554
                    if(__NFUN_413__(CurrentInfo.ItemNum, Info.ItemNum) || CurrentInfo.Id.ServerID != Info.Id.ServerID)
                    {
                        iElixir3slot.SetItem(0, Info);
                    }
                }
                // End:0x55D
                break;
            // End:0xFFFF
            default:
                // End:0x55D
                break;
                break;
        }        
    }
    else
    {
        // End:0x88B
        if(Type == "delete")
        {
            switch(Info.Id.ClassID)
            {
                // End:0x5E1
                case iCP.ClassID:
                    iCPslot.Clear();
                    Me.KillTimer(100);
                    AnimCP.SetLoopCount(0);
                    AnimCP.Stop();
                    AnimCP.HideWindow();
                    // End:0x88B
                    break;
                // End:0x63F
                case ibCP.ClassID:
                    ibCPslot.Clear();
                    Me.KillTimer(200);
                    AnimbCP.SetLoopCount(0);
                    AnimbCP.Stop();
                    AnimbCP.HideWindow();
                    // End:0x88B
                    break;
                // End:0x6A0
                case iHP.ClassID:
                    iHPslot.Clear();
                    Me.KillTimer(300);
                    AnimHP.SetLoopCount(0);
                    AnimHP.Stop();
                    AnimHP.HideWindow();
                    // End:0x88B
                    break;
                // End:0x701
                case imp.ClassID:
                    iMPslot.Clear();
                    Me.KillTimer(400);
                    AnimMP.SetLoopCount(0);
                    AnimMP.Stop();
                    AnimMP.HideWindow();
                    // End:0x88B
                    break;
                // End:0x762
                case iMP2.ClassID:
                    iMP2slot.Clear();
                    Me.KillTimer(500);
                    AnimMP2.SetLoopCount(0);
                    AnimMP2.Stop();
                    AnimMP2.HideWindow();
                    // End:0x88B
                    break;
                // End:0x7C3
                case iElixir1.ClassID:
                    iElixir1slot.Clear();
                    Me.KillTimer(600);
                    AnimElixir1.SetLoopCount(0);
                    AnimElixir1.Stop();
                    AnimElixir1.HideWindow();
                    // End:0x88B
                    break;
                // End:0x824
                case iElixir2.ClassID:
                    iElixir2slot.Clear();
                    Me.KillTimer(700);
                    AnimElixir2.SetLoopCount(0);
                    AnimElixir2.Stop();
                    AnimElixir2.HideWindow();
                    // End:0x88B
                    break;
                // End:0x885
                case iElixir3.ClassID:
                    iElixir3slot.Clear();
                    Me.KillTimer(800);
                    AnimElixir3.SetLoopCount(0);
                    AnimElixir3.Stop();
                    AnimElixir3.HideWindow();
                    // End:0x88B
                    break;
                // End:0xFFFF
                default:
                    // End:0x88B
                    break;
                    break;
            }
        }
    }
    return;
}

function PlaceItem()
{
    local bool cp_cnt, bcp_cnt, hp_cnt, mp_cnt, mp2_cnt, elixir1_cnt,
	    elixir2_cnt, elixir3_cnt;

    local ItemInfo Info;

    // End:0x0B
    if(IsOly)
    {
        return;
    }
    // End:0x25
    if((GetUIState()) != "GAMINGSTATE")
    {
        return;
    }
    // End:0x7F
    if(__NFUN_409__(OwnItem(InvenItem, iCP), (0)))
    {
        GetSetEx("InventoryWnd.InventoryItem", "AutoPotionWnd.CPslot", iCP, 1);        
    }
    else
    {
        iCPslot.Clear();
        cp_cnt = true;
        Me.KillTimer(100);
        AnimCP.SetLoopCount(0);
        AnimCP.Stop();
        AnimCP.HideWindow();
    }
    // End:0x130
    if(__NFUN_409__(OwnItem(InvenItem, ibCP), (0)))
    {
        GetSetEx("InventoryWnd.InventoryItem", "AutoPotionWnd.bCPslot", ibCP, 1);        
    }
    else
    {
        ibCPslot.Clear();
        bcp_cnt = true;
        Me.KillTimer(200);
        AnimbCP.SetLoopCount(0);
        AnimbCP.Stop();
        AnimbCP.HideWindow();
    }
    // End:0x1E0
    if(__NFUN_409__(OwnItem(InvenItem, iHP), (0)))
    {
        GetSetEx("InventoryWnd.InventoryItem", "AutoPotionWnd.HPslot", iHP, 1);        
    }
    else
    {
        iHPslot.Clear();
        hp_cnt = true;
        Me.KillTimer(300);
        AnimHP.SetLoopCount(0);
        AnimHP.Stop();
        AnimHP.HideWindow();
    }
    // End:0x293
    if(__NFUN_409__(OwnItem(InvenItem, imp), (0)))
    {
        GetSetEx("InventoryWnd.InventoryItem", "AutoPotionWnd.MPslot", imp, 1);        
    }
    else
    {
        iMPslot.Clear();
        mp_cnt = true;
        Me.KillTimer(400);
        AnimMP.SetLoopCount(0);
        AnimMP.Stop();
        AnimMP.HideWindow();
    }
    // End:0x347
    if(__NFUN_409__(OwnItem(InvenItem, iMP2), (0)))
    {
        GetSetEx("InventoryWnd.InventoryItem", "AutoPotionWnd.MP2slot", iMP2, 1);        
    }
    else
    {
        iMP2slot.Clear();
        mp2_cnt = true;
        Me.KillTimer(500);
        AnimMP2.SetLoopCount(0);
        AnimMP2.Stop();
        AnimMP2.HideWindow();
    }
    // End:0x3FF
    if(__NFUN_409__(OwnItem(InvenItem, iElixir1), (0)))
    {
        GetSetEx("InventoryWnd.InventoryItem", "AutoPotionWnd.Elixir1Slot", iElixir1, 1);        
    }
    else
    {
        iElixir1slot.Clear();
        elixir1_cnt = true;
        Me.KillTimer(600);
        AnimElixir1.SetLoopCount(0);
        AnimElixir1.Stop();
        AnimElixir1.HideWindow();
    }
    // End:0x4B7
    if(__NFUN_409__(OwnItem(InvenItem, iElixir2), (0)))
    {
        GetSetEx("InventoryWnd.InventoryItem", "AutoPotionWnd.Elixir2Slot", iElixir2, 1);        
    }
    else
    {
        iElixir2slot.Clear();
        elixir2_cnt = true;
        Me.KillTimer(700);
        AnimElixir2.SetLoopCount(0);
        AnimElixir2.Stop();
        AnimElixir2.HideWindow();
    }
    // End:0x56F
    if(__NFUN_409__(OwnItem(InvenItem, iElixir3), (0)))
    {
        GetSetEx("InventoryWnd.InventoryItem", "AutoPotionWnd.Elixir3Slot", iElixir3, 1);        
    }
    else
    {
        iElixir3slot.Clear();
        elixir3_cnt = true;
        Me.KillTimer(800);
        AnimElixir3.SetLoopCount(0);
        AnimElixir3.Stop();
        AnimElixir3.HideWindow();
    }
    return;
}

function bool IsWrongCondition()
{
    local int i, j, k, RowCount, ColCount;

    local StatusIconInfo Info;

    RowCount = StatusIcon.GetRowCount();
    i = 0;
    J0x1C:

    // End:0xCF [Loop If]
    if(i < RowCount)
    {
        ColCount = StatusIcon.GetColCount(i);
        j = 0;
        J0x4C:

        // End:0xC5 [Loop If]
        if(j < ColCount)
        {
            StatusIcon.GetItem(i, j, Info);
            k = 0;
            J0x80:

            // End:0xBB [Loop If]
            if(k < invSkills.Length)
            {
                // End:0xB1
                if(Info.Id.ClassID == invSkills[k])
                {
                    return true;
                }
                k++;
                // [Loop Continue]
                goto J0x80;
            }
            j++;
            // [Loop Continue]
            goto J0x4C;
        }
        i++;
        // [Loop Continue]
        goto J0x1C;
    }
    return false;
    return;
}

function bool FindEffectByLevel(int Id, int Level)
{
    local int i, j, RowCount, ColCount;
    local StatusIconInfo Info;

    // End:0x0D
    if(Id <= 0)
    {
        return true;
    }
    // End:0x1A
    if(Level <= 0)
    {
        return true;
    }
    RowCount = StatusIcon.GetRowCount();
    i = 0;
    J0x36:

    // End:0xD8 [Loop If]
    if(i < RowCount)
    {
        ColCount = StatusIcon.GetColCount(i);
        j = 0;
        J0x66:

        // End:0xCE [Loop If]
        if(j < ColCount)
        {
            StatusIcon.GetItem(i, j, Info);
            // End:0xC4
            if((Info.Id.ClassID == Id) && Info.Level >= Level)
            {
                return true;
            }
            j++;
            // [Loop Continue]
            goto J0x66;
        }
        i++;
        // [Loop Continue]
        goto J0x36;
    }
    return false;
    return;
}

function bool FindHpRecoveryEffect()
{
    local int i, j, k;
    local array<int> IDs;
    local int RowCount, ColCount;
    local StatusIconInfo Info;

    IDs[0] = 2037;
    IDs[1] = 2031;
    IDs[2] = 2032;
    IDs[3] = 22025;
    RowCount = StatusIcon.GetRowCount();
    i = 0;
    J0x52:

    // End:0x112 [Loop If]
    if(i < RowCount)
    {
        ColCount = StatusIcon.GetColCount(i);
        j = 0;
        J0x82:

        // End:0x108 [Loop If]
        if(j < ColCount)
        {
            StatusIcon.GetItem(i, j, Info);
            k = 0;
            J0xB6:

            // End:0xFE [Loop If]
            if(k < IDs.Length)
            {
                // End:0xF4
                if(Info.Id.ClassID == IDs[k])
                {
                    return Info.RemainTime >= 5;
                }
                k++;
                // [Loop Continue]
                goto J0xB6;
            }
            j++;
            // [Loop Continue]
            goto J0x82;
        }
        i++;
        // [Loop Continue]
        goto J0x52;
    }
    return false;
    return;
}

function int getMaxSoulLevel()
{
    local UserInfo User;
    local int nLevel;

    GetPlayerInfo(User);
    nLevel = User.nLevel;
    // End:0x3D
    if((nLevel >= 0) && nLevel <= 4)
    {
        return -1;        
    }
    else
    {
        // End:0x5D
        if((nLevel >= 5) && nLevel <= 9)
        {
            return 5;            
        }
        else
        {
            // End:0x7D
            if((nLevel >= 10) && nLevel <= 14)
            {
                return 8;                
            }
            else
            {
                // End:0x9D
                if((nLevel >= 15) && nLevel <= 19)
                {
                    return 10;                    
                }
                else
                {
                    // End:0xBD
                    if((nLevel >= 20) && nLevel <= 23)
                    {
                        return 12;                        
                    }
                    else
                    {
                        // End:0xDD
                        if((nLevel >= 24) && nLevel <= 27)
                        {
                            return 14;                            
                        }
                        else
                        {
                            // End:0xFD
                            if((nLevel >= 28) && nLevel <= 31)
                            {
                                return 16;                                
                            }
                            else
                            {
                                // End:0x11D
                                if((nLevel >= 32) && nLevel <= 35)
                                {
                                    return 18;                                    
                                }
                                else
                                {
                                    // End:0x13D
                                    if((nLevel >= 36) && nLevel <= 39)
                                    {
                                        return 20;                                        
                                    }
                                    else
                                    {
                                        // End:0x15D
                                        if((nLevel >= 40) && nLevel <= 42)
                                        {
                                            return 21;                                            
                                        }
                                        else
                                        {
                                            // End:0x17D
                                            if((nLevel >= 43) && nLevel <= 45)
                                            {
                                                return 22;                                                
                                            }
                                            else
                                            {
                                                // End:0x19D
                                                if((nLevel >= 46) && nLevel <= 48)
                                                {
                                                    return 23;                                                    
                                                }
                                                else
                                                {
                                                    // End:0x1BD
                                                    if((nLevel >= 49) && nLevel <= 51)
                                                    {
                                                        return 24;                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x1DD
                                                        if((nLevel >= 52) && nLevel <= 54)
                                                        {
                                                            return 25;                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x1FD
                                                            if((nLevel >= 55) && nLevel <= 57)
                                                            {
                                                                return 26;                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x21D
                                                                if((nLevel >= 58) && nLevel <= 59)
                                                                {
                                                                    return 27;                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x23D
                                                                    if((nLevel >= 60) && nLevel <= 61)
                                                                    {
                                                                        return 28;                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x25D
                                                                        if((nLevel >= 62) && nLevel <= 63)
                                                                        {
                                                                            return 29;                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x27D
                                                                            if((nLevel >= 64) && nLevel <= 65)
                                                                            {
                                                                                return 30;                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x29D
                                                                                if((nLevel >= 66) && nLevel <= 67)
                                                                                {
                                                                                    return 32;                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    // End:0x2BD
                                                                                    if((nLevel >= 68) && nLevel <= 69)
                                                                                    {
                                                                                        return 34;                                                                                        
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        // End:0x2DD
                                                                                        if((nLevel >= 70) && nLevel <= 71)
                                                                                        {
                                                                                            return 36;                                                                                            
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            // End:0x2FD
                                                                                            if((nLevel >= 72) && nLevel <= 73)
                                                                                            {
                                                                                                return 38;                                                                                                
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                // End:0x30C
                                                                                                if(nLevel >= 74)
                                                                                                {
                                                                                                    return 40;
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}
