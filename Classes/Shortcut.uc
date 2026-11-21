class Shortcut extends UICommonAPI;

const CHAT_WINDOW_NORMAL = 0;
const CHAT_WINDOW_TRADE = 1;
const CHAT_WINDOW_PARTY = 2;
const CHAT_WINDOW_CLAN = 3;
const CHAT_WINDOW_ALLY = 4;
const CHAT_WINDOW_COUNT = 5;
const CHAT_WINDOW_SYSTEM = 5;
const DIALOGID_Gohome = 44420;

var bool m_chatstateok;
var int IsPeaceZone;
var bool bServerTypeArmed;
var bool bServerTypeReported;

function OnRegisterEvent()
{
    RegisterEvent(90);
    RegisterEvent(3410);
    RegisterEvent(3080);
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(110);
    RegisterEvent(180);
    return;
}

function OnLoad()
{
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    local int zonetype;

    switch(a_EventID)
    {
        // End:0x1A
        case 90:
            HandleShortcutCommand(a_Param);
            // End:0xB6
            break;
        // End:0x30
        case 3410:
            HandleStateChange(a_Param);
            // End:0xB6
            break;
        // End:0x46
        case 3080:
            HandleShortcutKeyEvent(a_Param);
            // End:0xB6
            break;
        // End:0x85
        case 110:
            ParseInt(a_Param, "ZoneCode", zonetype);
            // End:0x7B
            if(zonetype == 12)
            {
                IsPeaceZone = 1;                
            }
            else
            {
                IsPeaceZone = 0;
            }
            // End:0xB6
            break;
        // End:0x96
        case 1710:
            HandleDialogOK();
            // End:0xB6
            break;
        // End:0xAD
        case 180:
            // End:0xAA
            if(bServerTypeArmed)
            {
                ReportServerTypeToBuilder();
            }
            // End:0xB6
            break;
        // End:0xFFFF
        default:
            // End:0xB6
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0B6
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0B6
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x0B6
}

function HandleShortcutKeyEvent(string a_Param)
{
    local string wndname;
    local OptionWnd o_script;
    local TargetStatusWnd t_script;
    local ShortcutWnd s_script;
    local WindowHandle TempWnd;

    ParseString(a_Param, "Name", wndname);
    o_script = OptionWnd(GetScript("OptionWnd"));
    t_script = TargetStatusWnd(GetScript("TargetStatusWnd"));
    s_script = ShortcutWnd(GetScript("ShortcutWnd"));
    switch(wndname)
    {
        // End:0x83
        case "GMWnd":
        // End:0x91
        case "GMClanWnd":
        // End:0xA7
        case "GMDetailStatusWnd":
        // End:0xBA
        case "GMInventoryWnd":
        // End:0xCE
        case "GMMagicSkillWnd":
        // End:0xDD
        case "GMQuestWnd":
        // End:0xF0
        case "GMWarehouseWnd":
        // End:0xFF
        case "GMSnoopWnd":
        // End:0x121
        case "GMPetitionWnd":
            // End:0x11E
            if(!IsBuilderPC())
            {
                return;
            }
            // End:0x127
            break;
        // End:0xFFFF
        default:
            // End:0x127
            break;
            break;
    }
    switch(wndname)
    {
        // End:0x14D
        case "InventoryWnd":
            ExecuteEvent(2631);
            // End:0x56B
            break;
        // End:0x168
        case "MacroWnd":
            ExecuteEvent(1230);
            // End:0x56B
            break;
        // End:0x183
        case "PartyMatchWnd":
            HandlePartyMatchingOnOff();
            // End:0x56B
            break;
        // End:0x1D8
        case "BoardWnd":
            TempWnd = GetWindowHandle("BoardWnd");
            // End:0x1CA
            if(TempWnd.IsShowWindow())
            {
                TempWnd.HideWindow();                
            }
            else
            {
                ExecuteEvent(1190);
            }
            // End:0x56B
            break;
        // End:0x1F0
        case "MinimapWnd":
            RequestOpenMinimap();
            // End:0x56B
            break;
        // End:0x209
        case "HelpHtmlWnd":
            HandleShowHelpHtmlWnd();
            // End:0x56B
            break;
        // End:0x2A1
        case "FN_HideDropItemSilhauette":
            // End:0x26E
            if(GetOptionBool("ScreenInfo", "HideDropItem"))
            {
                SetOptionBool("ScreenInfo", "HideDropItem", false);                
            }
            else
            {
                SetOptionBool("ScreenInfo", "HideDropItem", true);
            }
            o_script.InitScreenInfoOption();
            // End:0x56B
            break;
        // End:0x2FE
        case "FN_SendTargetedCharacterMessage":
            // End:0x2DD
            if(t_script.g_NameStr == "")
            {                
            }
            else
            {
                SetChatMessage(("\"" $ t_script.g_NameStr) $ " ");
            }
            // End:0x56B
            break;
        // End:0x37A
        case "FN_MuteAllAudio":
            // End:0x34D
            if(GetOptionBool("Audio", "AudioMuteOn"))
            {
                SetOptionBool("Audio", "AudioMuteOn", false);                
            }
            else
            {
                SetOptionBool("Audio", "AudioMuteOn", true);
            }
            o_script.InitControlOption();
            // End:0x56B
            break;
        // End:0x3A2
        case "FN_SHORTCUTEXPAND":
            s_script.OnClickExpandShortcutButton();
            // End:0x56B
            break;
        // End:0x3C6
        case "FN_UILocReset":
            o_script.SetDefaultPositionByClick();
            // End:0x56B
            break;
        // End:0x3DB
        case "SystemMenuWnd":
            // End:0x56B
            break;
        // End:0x3ED
        case "Post":
            HandleShowPostBoxWnd();
            // End:0x56B
            break;
        // End:0x409
        case "ShortcutAssign":
            HandleShowShortcutAssignWnd();
            // End:0x56B
            break;
        // End:0x424
        case "InstancedZone":
            RequestInzoneWaitingTime();
            // End:0x56B
            break;
        // End:0x435
        case "Rec":
            HandleShowMovieCaptureWnd();
            // End:0x56B
            break;
        // End:0x45D
        case "Replayrec":
            DoAction(Class'Interface.UICommonAPI'.static.GetItemID(55));
            // End:0x56B
            break;
        // End:0x477
        case "Productinven":
            HandleShowProductInventory();
            // End:0x56B
            break;
        // End:0x49E
        case "ShopSell":
            DoAction(Class'Interface.UICommonAPI'.static.GetItemID(10));
            // End:0x56B
            break;
        // End:0x4C4
        case "ShopBuy":
            DoAction(Class'Interface.UICommonAPI'.static.GetItemID(28));
            // End:0x56B
            break;
        // End:0x4EE
        case "ShopSellAll":
            DoAction(Class'Interface.UICommonAPI'.static.GetItemID(61));
            // End:0x56B
            break;
        // End:0x517
        case "ShopSearch":
            DoAction(Class'Interface.UICommonAPI'.static.GetItemID(57));
            // End:0x56B
            break;
        // End:0x52D
        case "Petition":
            HandleShowPetitionBegin();
            // End:0x56B
            break;
        // End:0x543
        case "Homepage":
            linkHomePage();
            // End:0x56B
            break;
        // End:0x557
        case "PcRoom":
            HandleToggleShowPCCafeEventWnd();
            // End:0x56B
            break;
        // End:0xFFFF
        default:
            WindowOpenOrClose(wndname);
            // End:0x56B
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x56B
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x56B
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x56B
}

function string getWindowNameByServerType(string wndname)
{
    // End:0x29
    if(wndname == "ChatMessage")
    {
        wndname = "ChatWnd";        
    }
    else
    {
        // End:0x50
        if(getInstanceUIData().getIsClassicServer())
        {
            wndname = getClassicWindowName(wndname);            
        }
        else
        {
            // End:0x74
            if(getInstanceUIData().getIsArenaServer())
            {
                wndname = getArenaWindowName(wndname);
            }
        }
    }
    return wndname;
    return;
}

function string getClassicWindowName(string wndname)
{
    switch(wndname)
    {
        // End:0x13
        case "ClanWnd":
        // End:0x38
        case "DetailStatusWnd":
            return wndname $ "Classic";
        // End:0xFFFF
        default:
            return wndname;
            break;
    }    
    return;
}

function string getArenaWindowName(string wndname)
{
    switch(wndname)
    {
        // End:0x2C
        case "DetailStatusWnd":
            return wndname $ "Classic";
        // End:0xFFFF
        default:
            return wndname;
            break;
    }    
    return;
}

function getSoundTypeByWndName(string wndname, out UIEventManager.EInterfaceSoundType openSound, out UIEventManager.EInterfaceSoundType closeSound)
{
    switch(wndname)
    {
        // End:0x2C
        case "MagicSkillWnd":
            openSound = 15;
            closeSound = 16;
            // End:0x95
            break;
        // End:0x3A
        case "ActionWnd":
        // End:0x4E
        case "DetailStatusWnd":
        // End:0x7C
        case "DetailStatusWndClassic":
            openSound = 5;
            closeSound = 6;
            // End:0x95
            break;
        // End:0xFFFF
        default:
            openSound = 11;
            closeSound = 12;
            // End:0x95
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x095
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x095
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x095
}

function HandleStopShowWindow(string a_Param)
{
    local string wndname;

    ParseString(a_Param, "Name", wndname);
    // End:0x5D
    if(InStr(wndname, "ArenaScoreBoardWnd") > -1)
    {
        CallGFxFunction("ArenaScoreBoardWnd", "hide", "");
    }
    return;
}

function WindowOpenOrClose(string wndname)
{
    local UIEventManager.EInterfaceSoundType openSound, closeSound;
    local WindowHandle WNDNameHandle;
    local int tempVars;

    WNDNameHandle = GetWindowHandle(getWindowNameByServerType(wndname));
    getSoundTypeByWndName(wndname, openSound, closeSound);
    switch(wndname)
    {
        // End:0x47
        case "ArenaRankingWnd":
        // End:0x9C
        case "RadarMapWnd":
            // End:0x85
            if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(wndname))
            {
                Class'NWindow.UIAPI_WINDOW'.static.HideWindow(wndname);                
            }
            else
            {
                Class'NWindow.UIAPI_WINDOW'.static.ShowWindow(wndname);
            }
            // End:0x326
            break;
        // End:0xD8
        case "ArenaScoreBoardWnd":
            CallGFxFunction("ArenaScoreBoardWnd", "show", "");
            // End:0x326
            break;
        // End:0xEF
        case "OptionWnd":
            toggleShowOptionWnd();
            // End:0x326
            break;
        // End:0x1EA
        case "ChatWnd":
            // End:0x153
            if(WNDNameHandle.IsShowWindow())
            {
                CallGFxFunction("WorldChatBox", "ToggleShowWnd", "hide");
                WNDNameHandle.HideWindow();
                PlayConsoleSound(closeSound);                
            }
            else
            {
                GetINIBool("global", "UseWorldChatSpeaker", tempVars, "chatfilter.ini");
                // End:0x1BE
                if(bool(tempVars))
                {
                    CallGFxFunction("WorldChatBox", "ToggleShowWnd", "show");
                }
                WNDNameHandle.ShowWindow();
                WNDNameHandle.SetFocus();
                PlayConsoleSound(openSound);
            }
            // End:0x326
            break;
        // End:0x1F6
        case "ClanWnd":
        // End:0x2C5
        case "ClanWndClassic":
            // End:0x22F
            if(IsPlayerOnWorldRaidServer())
            {
                getInstanceL2Util().showGfxScreenMessage(GetSystemMessage(4047));
                return;
            }
            // End:0x287
            if(getInstanceUIData().getIsClassicServer())
            {
                // End:0x26C
                if(getInstanceL2Util().isClanV2())
                {
                    toggleWindow("ClanGfxWnd", true, true);                    
                }
                else
                {
                    toggleWindow("ClanWndClassic", true, true);
                }                
            }
            else
            {
                // End:0x2B1
                if(getInstanceL2Util().isClanV2())
                {
                    toggleWindow("ClanGfxWnd", true, true);                    
                }
                else
                {
                    toggleWindow("ClanWnd", true, true);
                }
            }
            // End:0x326
            break;
        // End:0xFFFF
        default:
            // End:0x2F7
            if(WNDNameHandle.IsShowWindow())
            {
                WNDNameHandle.HideWindow();
                PlayConsoleSound(closeSound);                
            }
            else
            {
                WNDNameHandle.ShowWindow();
                WNDNameHandle.SetFocus();
                PlayConsoleSound(openSound);
            }
            // End:0x326
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x326
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x326
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x326
}

function toggleShowOptionWnd()
{
    local OptionWnd win;

    win = OptionWnd(GetScript("OptionWnd"));
    win.ToggleOpenMeWnd(false);
    return;
}

function HandleShowShortcutAssignWnd()
{
    local OptionWnd win;

    win = OptionWnd(GetScript("OptionWnd"));
    win.ToggleOpenMeWnd(true);
    return;
}

function HandleToggleShowPCCafeEventWnd()
{
    local InfoWnd script;

    script = InfoWnd(GetScript("InfoWnd"));
    // End:0x34
    if(script != none)
    {
        script.HandleToggleShowPCCafeEventWnd();
    }
    return;
}

function HandleShowMovieCaptureWnd()
{
    local bool tmpBool;
    local WindowHandle win, win1;

    win = GetWindowHandle("MovieCaptureWnd_Expand");
    win1 = GetWindowHandle("MovieCaptureWnd");
    tmpBool = IsNowMovieCapturing();
    // End:0xBB
    if(tmpBool)
    {
        win.HideWindow();
        // End:0x92
        if(win.IsShowWindow())
        {
            PlayConsoleSound(6);
            win.HideWindow();            
        }
        else
        {
            PlayConsoleSound(5);
            win.ShowWindow();
            win.SetFocus();
        }        
    }
    else
    {
        // End:0xE7
        if(win1.IsShowWindow())
        {
            PlayConsoleSound(6);
            win1.HideWindow();            
        }
        else
        {
            PlayConsoleSound(5);
            win1.ShowWindow();
            win1.SetFocus();
        }
    }
    return;
}

function HandleShowPetitionBegin()
{
    local WindowHandle win, win1, win2;
    local UIScript.PetitionMethod useNewPetition;

    win = GetWindowHandle("NewUserPetitionWnd");
    win1 = GetWindowHandle("UserPetitionWnd");
    win2 = GetWindowHandle("WebPetitionWnd");
    useNewPetition = GetPetitionMethod();
    // End:0xAF
    if(int(useNewPetition) == 1)
    {
        // End:0x9E
        if(win.IsShowWindow())
        {
            PlayConsoleSound(6);
            win.HideWindow();            
        }
        else
        {
            PlayConsoleSound(5);
            RequestShowPetitionAsMethod();
        }        
    }
    else
    {
        // End:0x111
        if(int(useNewPetition) == 0)
        {
            // End:0xE8
            if(win1.IsShowWindow())
            {
                PlayConsoleSound(6);
                win1.HideWindow();                
            }
            else
            {
                PlayConsoleSound(5);
                win1.ShowWindow();
                win1.SetFocus();
            }            
        }
        else
        {
            // End:0x159
            if(int(useNewPetition) == 2)
            {
                // End:0x14B
                if(win2.IsShowWindow())
                {
                    PlayConsoleSound(6);
                    win2.HideWindow();                    
                }
                else
                {
                    PlayConsoleSound(5);
                    RequestShowPetitionAsMethod();
                }
            }
        }
    }
    return;
}

function linkHomePage()
{
    Class'Interface.UICommonAPI'.static.DialogSetID(44420);
    Class'Interface.UICommonAPI'.static.DialogShow(1, 0, GetSystemMessage(3208), string(self));
    return;
}

function HandleDialogOK()
{
    // End:0x19
    if(!Class'Interface.UICommonAPI'.static.DialogIsOwnedBy(string(self)))
    {
        return;
    }
    switch(Class'Interface.UICommonAPI'.static.DialogGetID())
    {
        // End:0x3B
        case 44420:
            OpenL2Home();
            // End:0x41
            break;
        // End:0xFFFF
        default:
            // End:0x41
            break;
            break;
    }
    return;
}

function HandleShowProductInventory()
{
    local WindowHandle win, win1;
    local L2Util util;

    win = GetWindowHandle("ProductInventoryWnd");
    win1 = GetWindowHandle("ShopWnd");
    util = L2Util(GetScript("L2Util"));
    // End:0x7B
    if(win.IsShowWindow())
    {
        PlayConsoleSound(14);
        win.HideWindow();        
    }
    else
    {
        util.ItemRelationWindowHide("ProductInventoryWnd");
        // End:0xD9
        if(!win1.IsShowWindow())
        {
            PlayConsoleSound(13);
            win.ShowWindow();
            win.SetFocus();
        }
    }
    return;
}

function HandleShowPostBoxWnd()
{
    local WindowHandle win;

    win = GetWindowHandle("PostBoxWnd");
    // End:0x44
    if(win.IsShowWindow())
    {
        win.HideWindow();
        PlayConsoleSound(6);        
    }
    else
    {
        PlayConsoleSound(5);
        RequestRequestReceivedPostList();
        // End:0x68
        if(IsPeaceZone == 0)
        {
            AddSystemMessage(3066);
        }
    }
    return;
}

function ClosePartyMatchingWnd()
{
    local WindowHandle TaskWnd;
    local PartyMatchWnd p_script;

    p_script = PartyMatchWnd(GetScript("PartyMatchWnd"));
    // End:0x45
    if(1 == 0)
    {
        TaskWnd = GetHandle("PartyMatchWnd");        
    }
    else
    {
        TaskWnd = GetWindowHandle("PartyMatchWnd");
    }
    TaskWnd.HideWindow();
    p_script.OnSendPacketWhenHiding();
    return;
}

function HandleShowHelpHtmlWnd()
{
    local AgeWnd script1;
    local string strParam;

    ParamAdd(strParam, "FilePath", "..\\L2text\\help.htm");
    ExecuteEvent(1210, strParam);
    script1 = AgeWnd(GetScript("AgeWnd"));
    // End:0x76
    if(script1.bBlock == false)
    {
        script1.startAge();
    }
    return;
}

function HandlePartyMatchingOnOff()
{
    local WindowHandle PartyMatchRoomWnd, PartyMatchWnd;
    local PartyMatchRoomWnd p2_script;
    local L2Util util;

    // End:0x46
    if(getInstanceUIData().getIsArenaServer())
    {
        util = L2Util(GetScript("L2Util"));
        util.showGfxScreenMessage(GetSystemMessage(5517));
    }
    PartyMatchWnd = GetWindowHandle("PartyMatchWnd");
    PartyMatchRoomWnd = GetWindowHandle("PartyMatchRoomWnd");
    p2_script = PartyMatchRoomWnd(GetScript("PartyMatchRoomWnd"));
    // End:0xBF
    if(PartyMatchWnd.IsShowWindow())
    {
        ClosePartyMatchingWnd();        
    }
    else
    {
        // End:0x10B
        if(PartyMatchRoomWnd.IsShowWindow())
        {
            PartyMatchRoomWnd.HideWindow();
            p2_script.OnSendPacketWhenHiding();
            PartyMatchWnd.SetTimer(1991, 500);            
        }
        else
        {
            Class'NWindow.PartyMatchAPI'.static.RequestOpenPartyMatch();
        }
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x36
    if(TimerID == 1991)
    {
        ClosePartyMatchingWnd();
        Class'NWindow.UIAPI_WINDOW'.static.KillUITimer("ShortcutTab", 1991);
    }
    return;
}

function OnExitState(name a_NextStateName)
{
    // End:0x1A
    if(a_NextStateName == 'GamingState')
    {
        m_chatstateok = true;        
    }
    else
    {
        m_chatstateok = false;
    }
    return;
}

function HandleShortcutCommand(string a_Param)
{
    local string Command;
    local PlayerGameplayWnd PlayerGameplay;

    // End:0x407
    if(ParseString(a_Param, "Command", Command))
    {
        PlayerGameplay = PlayerGameplayWnd(GetScript("PlayerGameplayWnd"));
        switch(Command)
        {
            // End:0x73
            case "showFog":
                PlayerGameplay.toggleButton(int(PlayerGameplay.0), false);
                // End:0x407
                break;
            // End:0x9F
            case "showSky":
                PlayerGameplay.toggleButton(int(PlayerGameplay.1), false);
                // End:0x407
                break;
            // End:0xCF
            case "showEffects":
                PlayerGameplay.toggleButton(int(PlayerGameplay.2), false);
                // End:0x407
                break;
            // End:0xFD
            case "showLight":
                PlayerGameplay.toggleButton(int(PlayerGameplay.3), false);
                // End:0x407
                break;
            // End:0x129
            case "showFPS":
                PlayerGameplay.toggleButton(int(PlayerGameplay.4), false);
                // End:0x407
                break;
            // End:0x156
            case "hideName":
                PlayerGameplay.toggleButton(int(PlayerGameplay.5), false);
                // End:0x407
                break;
            // End:0x183
            case "wallhack":
                PlayerGameplay.toggleButton(int(PlayerGameplay.6), false);
                // End:0x407
                break;
            // End:0x19F
            case "CloseAllWindow":
                HandleCloseAllWindow();
                // End:0x407
                break;
            // End:0x1BB
            case "ShowChatWindow":
                HandleShowChatWindow();
                // End:0x407
                break;
            // End:0x1D8
            case "SetPrevChatType":
                HandleSetPrevChatType();
                // End:0x407
                break;
            // End:0x1F5
            case "SetNextChatType":
                HandleSetNextChatType();
                // End:0x407
                break;
            // End:0x219
            case "shortcutreset":
                Class'NWindow.ShortcutAPI'.static.RestoreDefault();
                // End:0x407
                break;
            // End:0x23C
            case "shortcutsave":
                Class'NWindow.ShortcutAPI'.static.Save();
                // End:0x407
                break;
            // End:0x25F
            case "shortcutload":
                Class'NWindow.ShortcutAPI'.static.RequestList();
                // End:0x407
                break;
            // End:0x271
            case "test":
                HandleShortcutTest();
                // End:0x407
                break;
            // End:0x28C
            case "printshortcut":
                HandlePrintShortcut();
                // End:0x407
                break;
            // End:0x2E5
            case "getPrevTarget":
                // End:0x2E2
                if(getInstanceUIData().getIsArenaServer())
                {
                    ExecuteCommand("/ï¿½ï¿½ï¿½ï¿½Å¸ï¿½ï¿½");
                }
                // End:0x407
                break;
            // End:0x33E
            case "getNextTarget":
                // End:0x33B
                if(getInstanceUIData().getIsArenaServer())
                {
                    ExecuteCommand("/ï¿½ï¿½ï¿½ï¿½Å¸ï¿½ï¿½");
                }
                // End:0x407
                break;
            // End:0x36F
            case "useRunSkill":
                // End:0x36C
                if(getInstanceUIData().getIsArenaServer())
                {
                    setUseSkill(18651);
                }
                // End:0x407
                break;
            // End:0x3A7
            case "useBaseRecallSkill":
                // End:0x3A4
                if(getInstanceUIData().getIsArenaServer())
                {
                    setUseSkill(18652);
                }
                // End:0x407
                break;
            // End:0x3BF
            case "HideAllWindow":
                HandleHideAllWindow();
            // End:0x3D2
            case "StopShowWindow":
            // End:0xFFFF
            default:
                // End:0x401
                if(InStr(Command, "StopShowWindow") > -1)
                {
                    HandleStopShowWindow(a_Param);
                }
                // End:0x407
                break;
                break;
        }        
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x407
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x407
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:If Position:0x407
}

function setUseSkill(int SkillID)
{
    local ItemID skillItemID;

    skillItemID.ClassID = SkillID;
    Debug("setUseSkill" @ string(skillItemID.ClassID));
    UseSkill(skillItemID, 2);
    return;
}

function HandleHideAllWindow()
{
    return;
}

function HandlePrintShortcut()
{
    local array<ShortcutCommandItem> CommandList;
    local array<string> grouplist;
    local int i;

    Class'NWindow.ShortcutAPI'.static.GetGroupList(grouplist);
    i = 0;
    J0x1B:

    // End:0x5C [Loop If]
    if(i < grouplist.Length)
    {
        CommandList.Length = 0;
        Class'NWindow.ShortcutAPI'.static.GetGroupCommandList(grouplist[i], CommandList);
        ++i;
        // [Loop Continue]
        goto J0x1B;
    }
    grouplist.Length = 0;
    Class'NWindow.ShortcutAPI'.static.GetActiveGroupList(grouplist);
    i = 0;
    J0x7F:

    // End:0x99 [Loop If]
    if(i < grouplist.Length)
    {
        ++i;
        // [Loop Continue]
        goto J0x7F;
    }
    return;
}

function HandleShortcutTest()
{
    return;
}

function HandleShowChatWindow()
{
    local WindowHandle Handle;
    local int tempVars;

    Handle = GetWindowHandle("ChatWnd");
    // End:0x93
    if(Handle.IsShowWindow())
    {
        Handle.HideWindow();
        GetINIBool("global", "SystemMsgWnd", tempVars, "chatfilter.ini");
        // End:0x90
        if(!bool(tempVars))
        {
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("SystemMsgWnd");
        }        
    }
    else
    {
        Handle.ShowWindow();
        GetINIBool("global", "SystemMsgWnd", tempVars, "chatfilter.ini");
        // End:0xFA
        if(bool(tempVars))
        {
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("SystemMsgWnd");
        }
    }
    return;
}

function HandleSetPrevChatType()
{
    local ChatWnd chatWndScript;

    chatWndScript = ChatWnd(GetScript("ChatWnd"));
    switch(chatWndScript.m_chatType.UI)
    {
        // End:0x6E
        case 0:
            chatWndScript.ChatTabCtrl.SetTopOrder(4, true);
            chatWndScript.HandleTabClick("ChatTabCtrl4");
            // End:0x171
            break;
        // End:0xAC
        case 1:
            chatWndScript.ChatTabCtrl.SetTopOrder(0, true);
            chatWndScript.HandleTabClick("ChatTabCtrl0");
            // End:0x171
            break;
        // End:0xEB
        case 2:
            chatWndScript.ChatTabCtrl.SetTopOrder(1, true);
            chatWndScript.HandleTabClick("ChatTabCtrl1");
            // End:0x171
            break;
        // End:0x12B
        case 3:
            chatWndScript.ChatTabCtrl.SetTopOrder(2, true);
            chatWndScript.HandleTabClick("ChatTabCtrl2");
            // End:0x171
            break;
        // End:0x16B
        case 4:
            chatWndScript.ChatTabCtrl.SetTopOrder(3, true);
            chatWndScript.HandleTabClick("ChatTabCtrl3");
            // End:0x171
            break;
        // End:0xFFFF
        default:
            // End:0x171
            break;
            break;
    }
    return;
}

function HandleSetNextChatType()
{
    local ChatWnd chatWndScript;

    chatWndScript = ChatWnd(GetScript("ChatWnd"));
    switch(chatWndScript.m_chatType.UI)
    {
        // End:0x6D
        case 0:
            chatWndScript.ChatTabCtrl.SetTopOrder(1, true);
            chatWndScript.HandleTabClick("ChatTabCtrl1");
            // End:0x171
            break;
        // End:0xAC
        case 1:
            chatWndScript.ChatTabCtrl.SetTopOrder(2, true);
            chatWndScript.HandleTabClick("ChatTabCtrl2");
            // End:0x171
            break;
        // End:0xEC
        case 2:
            chatWndScript.ChatTabCtrl.SetTopOrder(3, true);
            chatWndScript.HandleTabClick("ChatTabCtrl3");
            // End:0x171
            break;
        // End:0x12C
        case 3:
            chatWndScript.ChatTabCtrl.SetTopOrder(4, true);
            chatWndScript.HandleTabClick("ChatTabCtrl4");
            // End:0x171
            break;
        // End:0x16B
        case 4:
            chatWndScript.ChatTabCtrl.SetTopOrder(0, true);
            chatWndScript.HandleTabClick("ChatTabCtrl0");
            // End:0x171
            break;
        // End:0xFFFF
        default:
            // End:0x171
            break;
            break;
    }
    return;
}

function HandleCloseAllWindow()
{
    local WindowHandle Handle;
    local int i;
    local array<string> WndList, GFxWndList;
    local int numOfWnd;
    local PrivateShopWnd PrivateShopWndScript;
    local RefineryWnd RefineryWndScript;

    PrivateShopWndScript = PrivateShopWnd(GetScript("PrivateShopWnd"));
    PrivateShopWndScript.RequestQuit();
    Class'NWindow.RecipeAPI'.static.RequestRecipeShopManageQuit();
    Class'NWindow.EnchantAPI'.static.RequestExCancelEnchantItem();
    RefineryWndScript = RefineryWnd(GetScript("RefineryWnd"));
    RefineryWndScript.OnClickCancelButton();
    numOfWnd = 0;
    WndList[numOfWnd++] = "ActionWnd";
    WndList[numOfWnd++] = "AttributeEnchantWnd";
    WndList[numOfWnd++] = "AttributeRemoveWnd";
    WndList[numOfWnd++] = "BoardWnd";
    WndList[numOfWnd++] = "CalculatorWnd";
    WndList[numOfWnd++] = getWindowNameByServerType("ClanWnd");
    WndList[numOfWnd++] = "ConsoleWnd";
    WndList[numOfWnd++] = "CouponEventWnd";
    WndList[numOfWnd++] = "DeliverWnd";
    WndList[numOfWnd++] = "SelectDeliverWnd";
    WndList[numOfWnd++] = getWindowNameByServerType("DetailStatusWnd");
    WndList[numOfWnd++] = "MailBtnWnd";
    WndList[numOfWnd++] = "HelpHtmlWnd";
    WndList[numOfWnd++] = "HelpWnd";
    WndList[numOfWnd++] = "HennaInfoWnd";
    WndList[numOfWnd++] = "HennaListWnd";
    WndList[numOfWnd++] = "HeroTowerWnd";
    WndList[numOfWnd++] = "HeroTowerWndWorld";
    WndList[numOfWnd++] = "InventoryWnd";
    WndList[numOfWnd++] = "ItemEnchantWnd";
    WndList[numOfWnd++] = "XMasSealWnd";
    WndList[numOfWnd++] = "MacroEditWnd";
    WndList[numOfWnd++] = "MacroListWnd";
    WndList[numOfWnd++] = "MagicSkillWnd";
    WndList[numOfWnd++] = "ManorCropInfoChangeWnd";
    WndList[numOfWnd++] = "ManorCropInfoSettingWnd";
    WndList[numOfWnd++] = "ManorCropSellChangeWnd";
    WndList[numOfWnd++] = "ManorCropSellWnd";
    WndList[numOfWnd++] = "ManorInfoWnd";
    WndList[numOfWnd++] = "ManorSeedInfoChangeWnd";
    WndList[numOfWnd++] = "ManorSeedInfoSettingWnd";
    WndList[numOfWnd++] = "ManorShopWnd";
    WndList[numOfWnd++] = "MinimapWnd";
    WndList[numOfWnd++] = "MultiSellWnd";
    WndList[numOfWnd++] = "OptionWnd";
    WndList[numOfWnd++] = "PetitionFeedBackWnd";
    WndList[numOfWnd++] = "PetitionWnd";
    WndList[numOfWnd++] = "UserPetitionWnd";
    WndList[numOfWnd++] = "PetWnd";
    WndList[numOfWnd++] = "PrivateShopWnd";
    WndList[numOfWnd++] = "QuestListWnd";
    WndList[numOfWnd++] = "QuestTreeWnd";
    WndList[numOfWnd++] = "RecipeBookWnd";
    WndList[numOfWnd++] = "RecipeBuyListWnd";
    WndList[numOfWnd++] = "RecipeBuyManufactureWnd";
    WndList[numOfWnd++] = "RecipeManufactureWnd";
    WndList[numOfWnd++] = "RecipeShopWnd";
    WndList[numOfWnd++] = "RecipeTreeWnd";
    WndList[numOfWnd++] = "RefineryWnd";
    WndList[numOfWnd++] = "ReplayListWnd";
    WndList[numOfWnd++] = "ReplayLogoWnd";
    WndList[numOfWnd++] = "ShopWnd";
    WndList[numOfWnd++] = "SiegeInfoWnd";
    WndList[numOfWnd++] = "SummonedWnd";
    WndList[numOfWnd++] = "TownMapWnd";
    WndList[numOfWnd++] = "TradeWnd";
    WndList[numOfWnd++] = "SkillTrainClanTreeWnd";
    WndList[numOfWnd++] = "SkillTrainInfoWnd";
    WndList[numOfWnd++] = "SkillTrainListWnd";
    WndList[numOfWnd++] = "TutorialViewerWnd";
    WndList[numOfWnd++] = "unrefineryWnd";
    WndList[numOfWnd++] = "WarehouseWnd";
    WndList[numOfWnd++] = "PartyMatchWnd";
    WndList[numOfWnd++] = "PersonalConnectionsWnd";
    WndList[numOfWnd++] = "NPCDialogWnd";
    WndList[numOfWnd++] = "PostBoxWnd";
    WndList[numOfWnd++] = "NewUserPetitionWnd";
    WndList[numOfWnd++] = "ProductInventoryWnd";
    WndList[numOfWnd++] = "AuctionWnd";
    WndList[numOfWnd++] = "BlockCurWnd";
    WndList[numOfWnd++] = "BlockEnterWnd";
    WndList[numOfWnd++] = "CleftEnterWnd";
    WndList[numOfWnd++] = "CleftCurWnd";
    WndList[numOfWnd++] = "ColorNickNameWnd";
    WndList[numOfWnd++] = "DominionWarInfoWnd";
    WndList[numOfWnd++] = "FileRegisterWnd";
    WndList[numOfWnd++] = "KillPointRankWnd";
    WndList[numOfWnd++] = "MagicskillGuideWnd";
    WndList[numOfWnd++] = "miniGame1Wnd";
    WndList[numOfWnd++] = "NewPetitionWnd";
    WndList[numOfWnd++] = "PetitionFeedBackWnd";
    WndList[numOfWnd++] = "PostWriteWnd";
    WndList[numOfWnd++] = "PremiumItemGetWnd";
    WndList[numOfWnd++] = "PVPDetailedWnd";
    WndList[numOfWnd++] = "QuesthtmlWnd";
    WndList[numOfWnd++] = "SeedShopWnd";
    WndList[numOfWnd++] = "SellingAgencyWnd";
    WndList[numOfWnd++] = "TeleportBookMarkWnd";
    WndList[numOfWnd++] = "WebPetitionWnd";
    WndList[numOfWnd++] = "IngameNoticeWnd";
    WndList[numOfWnd++] = "ItemJewelEnchantWnd";
    WndList[numOfWnd++] = "PlayerAgeWnd";
    WndList[numOfWnd++] = "BR_PathWnd";
    WndList[numOfWnd++] = "ToDoListWnd";
    WndList[numOfWnd++] = "ToDoListClanWnd";
    WndList[numOfWnd++] = "InventoryViewer";
    WndList[numOfWnd++] = "EnsoulWnd";
    WndList[numOfWnd++] = "AttendCheckWnd";
    WndList[numOfWnd++] = "SiegeReportWnd";
    WndList[numOfWnd++] = "AgitDecoWnd";
    WndList[numOfWnd++] = "MonsterArenaResultWnd";
    WndList[numOfWnd++] = "MacroPresetWnd";
    WndList[numOfWnd++] = "IngameWebWnd";
    WndList[numOfWnd++] = "MonsterBookDetailedInfo";
    WndList[numOfWnd++] = "PrivateShopWndHistory";
    WndList[numOfWnd++] = "ItemLockWnd";
    i = 0;
    J0xD05:

    // End:0xD69 [Loop If]
    if(i < WndList.Length)
    {
        Handle = GetWindowHandle(WndList[i]);
        // End:0xD3E
        if(WndList[i] == "")
        {
        }
        // End:0xD5F
        if(Handle.IsShowWindow())
        {
            Handle.HideWindow();
        }
        ++i;
        // [Loop Continue]
        goto J0xD05;
    }
    numOfWnd = 0;
    GFxWndList[numOfWnd++] = "ClanSearch";
    GFxWndList[numOfWnd++] = "InstancedZoneHistoryWnd";
    GFxWndList[numOfWnd++] = "OptionWnd";
    GFxWndList[numOfWnd++] = "CardExchange";
    GFxWndList[numOfWnd++] = "CardExchangeB";
    GFxWndList[numOfWnd++] = "CardExchangeC";
    GFxWndList[numOfWnd++] = "AdenaDistributionWnd";
    GFxWndList[numOfWnd++] = "AbilityWnd";
    GFxWndList[numOfWnd++] = "AlchemyMixCubeWnd";
    GFxWndList[numOfWnd++] = "AlchemyOpener";
    GFxWndList[numOfWnd++] = "AlchemyItemConversionWnd";
    GFxWndList[numOfWnd++] = "FactionWnd";
    GFxWndList[numOfWnd++] = "VipInfoWnd";
    GFxWndList[numOfWnd++] = "IngameShopWnd";
    GFxWndList[numOfWnd++] = "LuckyGame";
    GFxWndList[numOfWnd++] = "MonsterBookWnd";
    GFxWndList[numOfWnd++] = "MiniMapGFxWnd";
    GFxWndList[numOfWnd++] = "EventInfoWnd";
    GFxWndList[numOfWnd++] = "CardDrawEventWnd";
    GFxWndList[numOfWnd++] = "ArenaRankingWnd";
    GFxWndList[numOfWnd++] = "ClanRaidsWnd";
    GFxWndList[numOfWnd++] = "ClanGfxWnd";
    i = 0;
    J0x1001:

    // End:0x10B0 [Loop If]
    if(i < GFxWndList.Length)
    {
        // End:0x10A6
        if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow(GFxWndList[i]))
        {
            // End:0x108C
            if(GFxWndList[i] == "AdenaDistributionWnd")
            {
                CallGFxFunction("AdenaDistributionWnd", "RequestDivideAdenaCancel", "");
            }
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow(GFxWndList[i]);
        }
        i++;
        // [Loop Continue]
        goto J0x1001;
    }
    return;
}

function HandleStateChange(string State)
{
    local FlightShipCtrlWnd scriptShip;
    local FlightTransformCtrlWnd scriptTrans;

    scriptShip = FlightShipCtrlWnd(GetScript("FlightShipCtrlWnd"));
    scriptTrans = FlightTransformCtrlWnd(GetScript("FlightTransformCtrlWnd"));
    // End:0x1B9
    if(State == "GAMINGSTATE")
    {
        // End:0xA6
        if(GetChatFilterBool("Global", "EnterChatting"))
        {
            Class'NWindow.ShortcutAPI'.static.ActivateGroup("TempStateShortcut");
        }
        // End:0x121
        if(scriptShip.isNowActiveFlightShipShortcut)
        {
            // End:0xFA
            if(GetChatFilterBool("Global", "EnterChatting"))
            {
                Class'NWindow.ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");
            }
            Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightStateShortcut");            
        }
        else
        {
            // End:0x19D
            if(scriptTrans.isNowActiveFlightTransShortcut)
            {
                // End:0x175
                if(GetChatFilterBool("Global", "EnterChatting"))
                {
                    Class'NWindow.ShortcutAPI'.static.DeactivateGroup("TempStateShortcut");
                }
                Class'NWindow.ShortcutAPI'.static.ActivateGroup("FlightTransformShortcut");
            }
        }
        // End:0x1B6
        if(!bServerTypeReported)
        {
            bServerTypeArmed = true;
            ReportServerTypeToBuilder();
        }        
    }
    else
    {
        // End:0x201
        if((State ~= "CHARACTERSELECTSTATE") || State ~= "LOGINSTATE")
        {
            bServerTypeArmed = false;
            bServerTypeReported = false;
        }
    }
    return;
}

function ReportServerTypeToBuilder()
{
    local int nCustom;
    local string strEngine, strCustom;

    // End:0x18
    if(bServerTypeReported || !IsBuilderPC())
    {
        return;
    }
    bServerTypeReported = true;
    bServerTypeArmed = false;
    switch(GetServerType())
    {
        // End:0x43
        case 1:
            strEngine = "Live";
            // End:0x9F
            break;
        // End:0x5A
        case 2:
            strEngine = "Classic";
            // End:0x9F
            break;
        // End:0x6F
        case 3:
            strEngine = "Arena";
            // End:0x9F
            break;
        // End:0x8A
        case 4:
            strEngine = "ClassicAden";
            // End:0x9F
            break;
        // End:0xFFFF
        default:
            strEngine = "unknown";
            // End:0x9F
            break;
            break;
    }
    nCustom = GetOptionInt("L2", "CustomServerType");
    // End:0xDE
    if(nCustom == 0)
    {
        strCustom = "not set";        
    }
    else
    {
        strCustom = GetCustomServerSuffix();
    }
    AddSystemMessageString((((((((("[GM] Server type: " $ strEngine) $ " (") $ string(GetServerType())) $ ") | CustomServerType=") $ string(nCustom)) $ " (") $ strCustom) $ ") | ") $ (ApplyCustomServerSuffix("settings.ini")));
    return;
}
