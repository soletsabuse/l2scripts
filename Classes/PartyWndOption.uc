class PartyWndOption extends UICommonAPI;

enum eHighlightType
{
    PH_PARTY,                       // 0
    PH_WARRIOR,                     // 1
    PH_WIZARD,                      // 2
    PH_ARCHER,                      // 3
    PH_DAGGER,                      // 4
    PH_TANKER,                      // 5
    PH_HEALER,                      // 6
    PH_ENCHANTER,                   // 7
    PH_SONGER,                      // 8
    PH_DANCER,                      // 9
    PH_SUMMONER,                    // 10
    PH_MAX                          // 11
};

enum eHighlightColorType
{
    PH_NONE,                        // 0
    PH_BLUE,                        // 1
    PH_CYAN,                        // 2
    PH_GREEN,                       // 3
    PH_ORANGE,                      // 4
    PH_RED,                         // 5
    PH_VIOLET,                      // 6
    PH_YELLOW,                      // 7
    PH_WHITE,                       // 8
    PH_MAX                          // 9
};

var int currentSelectedClassType;
var TextureHandle TypeIconTx;
var TextBoxHandle TypeNameTxt;
var ButtonHandle TypeLeftBtn;
var ButtonHandle TypeRightBtn;
var ButtonHandle TypeColorLeftBtn;
var ButtonHandle TypeColorRightBtn;
var TextBoxHandle TypeColorNameTxt;
var PartyWnd Party;
var WindowHandle PartyWnd;
var bool m_OptionShow;
var int m_arrPetIDOpen[9];
var WindowHandle m_PartyOption;
var WindowHandle m_PartyWndBig;
var WindowHandle m_PartyWndSmall;
var CheckBoxHandle m_CheckHideAllPet;
var CheckBoxHandle m_showSmallPartyWndChek;
var CheckBoxHandle NobleShow;
var CheckBoxHandle CardShow;
var CheckBoxHandle ColoredNicknameShow;
var CheckBoxHandle RessurectHighlightShow;

function OnLoad()
{
    m_OptionShow = false;
    m_PartyOption = GetWindowHandle("PartyWndOption");
    m_PartyWndBig = GetWindowHandle("PartyWnd");
    m_PartyWndSmall = GetWindowHandle("PartyWndCompact");
    m_CheckHideAllPet = GetCheckBoxHandle("PartyWndOption.removeAllPet");
    m_showSmallPartyWndChek = GetCheckBoxHandle("PartyWndOption.ShowSmallPartyWndCheck");
    NobleShow = GetCheckBoxHandle("PartyWndOption.NobleShow");
    CardShow = GetCheckBoxHandle("PartyWndOption.CardShow");
    ColoredNicknameShow = GetCheckBoxHandle("PartyWndOption.ColoredNicknameShow");
    RessurectHighlightShow = GetCheckBoxHandle("PartyWndOption.RessurectHighlightShow");
    TypeIconTx = GetTextureHandle("PartyWndOption.HighlightSelectWnd.TypeSelectorWnd.TypeIconTx");
    TypeNameTxt = GetTextBoxHandle("PartyWndOption.HighlightSelectWnd.TypeSelectorWnd.TypeNameTxt");
    TypeLeftBtn = GetButtonHandle("PartyWndOption.HighlightSelectWnd.TypeSelectorWnd.TypeLeftBtn");
    TypeRightBtn = GetButtonHandle("PartyWndOption.HighlightSelectWnd.TypeSelectorWnd.TypeRightBtn");
    TypeColorNameTxt = GetTextBoxHandle("PartyWndOption.HighlightSelectWnd.TypeColorSelectorWnd.TypeColorNameTxt");
    TypeColorLeftBtn = GetButtonHandle("PartyWndOption.HighlightSelectWnd.TypeColorSelectorWnd.TypeColorLeftBtn");
    TypeColorRightBtn = GetButtonHandle("PartyWndOption.HighlightSelectWnd.TypeColorSelectorWnd.TypeColorRightBtn");
    PartyWnd = GetWindowHandle("PartyWnd");
    Party = PartyWnd(GetScript("PartyWnd"));
    setSettings();
    firstLoadHighlight();
    return;
}

function OnShow()
{
    return;
}

function SaveSettings()
{
    local int i, colorType;
    local string highlightBypass;

    SetINIInt("PartyWnd", "e", int(m_showSmallPartyWndChek.IsChecked()), "Windowsinfo.ini");
    SetINIInt("PartyWnd", "p", int(m_CheckHideAllPet.IsChecked()), "Windowsinfo.ini");
    SetINIInt("PartyWnd", "n", int(NobleShow.IsChecked()), "Windowsinfo.ini");
    SetINIInt("PartyWnd", "c", int(ColoredNicknameShow.IsChecked()), "Windowsinfo.ini");
    SetINIInt("PartyWnd", "cc", int(CardShow.IsChecked()), "Windowsinfo.ini");
    SetINIInt("PartyWnd", "r", int(RessurectHighlightShow.IsChecked()), "Windowsinfo.ini");
    showHideNoblesse(NobleShow.IsChecked());
    showHideClubCard(CardShow.IsChecked());
    handleAnchorUI();
    i = 0;
    J0x176:

    // End:0x1B6 [Loop If]
    if(i < 11)
    {
        colorType = GetColorType(i);
        highlightBypass = (highlightBypass $ ";") $ string(colorType);
        i++;
        // [Loop Continue]
        goto J0x176;
    }
    RequestBypassToServer((((((("partyph" $ highlightBypass) $ ";") $ string(int(ColoredNicknameShow.IsChecked()))) $ ";") $ string(int(CardShow.IsChecked()))) $ ";") $ string(int(RessurectHighlightShow.IsChecked())));
    return;
}

function setSettings()
{
    local int i, tmpInt;

    GetINIInt("PartyWnd", "e", tmpInt, "Windowsinfo.ini");
    m_showSmallPartyWndChek.SetCheck(bool(tmpInt));
    GetINIInt("PartyWnd", "p", tmpInt, "Windowsinfo.ini");
    m_CheckHideAllPet.SetCheck(bool(tmpInt));
    GetINIInt("PartyWnd", "n", tmpInt, "Windowsinfo.ini");
    NobleShow.SetCheck(bool(tmpInt));
    showHideNoblesse(bool(tmpInt));
    GetINIInt("PartyWnd", "cc", tmpInt, "Windowsinfo.ini");
    CardShow.SetCheck(bool(tmpInt));
    showHideClubCard(bool(tmpInt));
    GetINIInt("PartyWnd", "c", tmpInt, "Windowsinfo.ini");
    ColoredNicknameShow.SetCheck(bool(tmpInt));
    GetINIInt("PartyWnd", "r", tmpInt, "Windowsinfo.ini");
    RessurectHighlightShow.SetCheck(bool(tmpInt));
    showHideResHighLight(false);
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("PartyWndOption");
    m_OptionShow = true;
    handleAnchorUI();
    return;
}

function handleAnchorUI()
{
    local int i;
    local bool bNoble, bCard;

    bNoble = NobleShow.IsChecked();
    bCard = CardShow.IsChecked();
    i = 0;
    J0x33:

    // End:0x190 [Loop If]
    if(i < Party.10)
    {
        // End:0x115
        if(bNoble && bCard)
        {
            Party.NoblesseTex[i].SetAnchor("PartyWnd.PartyStatusWnd" $ string(i), "TopRight", "TopRight", -8, 6);
            Party.CardTex[i].SetAnchor("PartyWnd.PartyStatusWnd" $ string(i), "TopRight", "TopRight", -27, 5);
            // [Explicit Continue]
            goto J0x186;
        }
        // End:0x186
        if(!bNoble && bCard)
        {
            Party.CardTex[i].SetAnchor("PartyWnd.PartyStatusWnd" $ string(i), "TopRight", "TopRight", -8, 5);
        }
        J0x186:

        i++;
        // [Loop Continue]
        goto J0x33;
    }
    return;
}

function showHideClubCard(bool B)
{
    local int i;

    // End:0x75
    if(B)
    {
        i = 0;
        J0x10:

        // End:0x72 [Loop If]
        if(i < Party.10)
        {
            Party.CardTex[i].ShowWindow();
            Party.CardTex[i].SetAlpha(50, 0.1000000);
            i++;
            // [Loop Continue]
            goto J0x10;
        }        
    }
    else
    {
        i = 0;
        J0x7C:

        // End:0xB9 [Loop If]
        if(i < Party.10)
        {
            Party.CardTex[i].HideWindow();
            i++;
            // [Loop Continue]
            goto J0x7C;
        }
    }
    return;
}

function showHideNoblesse(bool B)
{
    local int i;

    // End:0x6E
    if(B)
    {
        i = 0;
        J0x10:

        // End:0x6B [Loop If]
        if(i < Party.10)
        {
            Party.HandleNoblesseActive("idx=" $ string(i));
            Party.NoblesseTex[i].ShowWindow();
            i++;
            // [Loop Continue]
            goto J0x10;
        }        
    }
    else
    {
        i = 0;
        J0x75:

        // End:0xB2 [Loop If]
        if(i < Party.10)
        {
            Party.NoblesseTex[i].HideWindow();
            i++;
            // [Loop Continue]
            goto J0x75;
        }
    }
    return;
}

function showHideResHighLight(bool B)
{
    local int i;

    // End:0x50
    if(!B)
    {
        i = 0;
        J0x12:

        // End:0x50 [Loop If]
        if(i < Party.10)
        {
            Party.RessurectBg[i].SetAlpha(0);
            i++;
            // [Loop Continue]
            goto J0x12;
        }
    }
    return;
}

function OnClickCheckBox(string CheckBoxID)
{
    switch(CheckBoxID)
    {
        // End:0x25
        case "ShowSmallPartyWndCheck":
            // End:0x3F
            break;
        // End:0x39
        case "removeAllPet":
            // End:0x3F
            break;
        // End:0xFFFF
        default:
            // End:0x3F
            break;
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x37
        case "okbtn":
            SaveSettings();
            SwapBigAndSmall();
            m_PartyOption.HideWindow();
            m_OptionShow = false;
            // End:0x107
            break;
        // End:0x54
        case "cancelbtn":
            firstLoadHighlight();
            setSettings();
            // End:0x107
            break;
        // End:0x6E
        case "TypeLeftBtn":
            SwitchHighlightType(false);
            // End:0x107
            break;
        // End:0x89
        case "TypeRightBtn":
            SwitchHighlightType(true);
            // End:0x107
            break;
        // End:0xA8
        case "TypeColorLeftBtn":
            SwitchHighlightColor(false);
            // End:0x107
            break;
        // End:0xC8
        case "TypeColorRightBtn":
            SwitchHighlightColor(true);
            // End:0x107
            break;
        // End:0xE2
        case "resetMainBtn":
            reloadMainSettings();
            // End:0x107
            break;
        // End:0x101
        case "resetHighlightBtn":
            reloadHighlight();
            // End:0x107
            break;
        // End:0xFFFF
        default:
            // End:0x107
            break;
            break;
    }
    return;
}

function reloadMainSettings()
{
    m_CheckHideAllPet.SetCheck(false);
    m_showSmallPartyWndChek.SetCheck(false);
    NobleShow.SetCheck(false);
    CardShow.SetCheck(false);
    ColoredNicknameShow.SetCheck(false);
    RessurectHighlightShow.SetCheck(false);
    return;
}

function reloadHighlight()
{
    local int i, savedType;

    currentSelectedClassType = 0;
    i = 0;
    J0x0E:

    // End:0x24 [Loop If]
    if(i < 11)
    {
        i++;
        // [Loop Continue]
        goto J0x0E;
    }
    CheckButtonState(0, 0);
    UpdateHighlightType(byte(currentSelectedClassType));
    SetTextWithColor(0);
    return;
}

function SwapBigAndSmall()
{
    local int i;
    local PartyWnd scriptBig;
    local PartyWndCompact scriptSmall;

    scriptBig = PartyWnd(GetScript("PartyWnd"));
    scriptSmall = PartyWndCompact(GetScript("PartyWndCompact"));
    Class'NWindow.UIAPI_WINDOW'.static.SetAnchor("PartyWndCompact", "PartyWnd", "TopLeft", "TopLeft", 0, 0);
    i = 0;
    J0x82:

    // End:0x12A [Loop If]
    if(i < 9)
    {
        // End:0xC2
        if(m_CheckHideAllPet.IsChecked())
        {
            // End:0xBF
            if(m_arrPetIDOpen[i] > 0)
            {
                m_arrPetIDOpen[i] = 2;
            }            
        }
        else
        {
            // End:0xE0
            if(m_arrPetIDOpen[i] > 0)
            {
                m_arrPetIDOpen[i] = 1;
            }
        }
        scriptBig.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
        scriptSmall.m_arrPetIDOpen[i] = m_arrPetIDOpen[i];
        i++;
        // [Loop Continue]
        goto J0x82;
    }
    scriptBig.ResizeWnd();
    scriptSmall.ResizeWnd();
    return;
}

function firstLoadHighlight()
{
    local int i, savedType;

    // End:0x8C
    if(!GetINIInt("Highlight", "Type", savedType, "Option.ini"))
    {
        SetOptionInt("Highlight", "Type", 0);
        i = 0;
        J0x4C:

        // End:0x89 [Loop If]
        if(i < 11)
        {
            SetOptionInt("Highlight", "ColorType_" $ string(i), 0);
            i++;
            // [Loop Continue]
            goto J0x4C;
        }        
    }
    else
    {
        currentSelectedClassType = savedType;
        UpdateHighlightType(byte(currentSelectedClassType));
    }
    return;
}

function SwitchHighlightType(bool bIncrement)
{
    // End:0x13
    if(bIncrement)
    {
        currentSelectedClassType++;        
    }
    else
    {
        currentSelectedClassType--;
    }
    currentSelectedClassType = CheckHighlightType(currentSelectedClassType);
    SetOptionInt("Highlight", "Type", currentSelectedClassType);
    UpdateHighlightType(byte(currentSelectedClassType));
    return;
}

function SwitchHighlightColor(bool bIncrement)
{
    local int savedType, savedColorType;

    savedType = GetOptionInt("Highlight", "Type");
    savedColorType = GetOptionInt("Highlight", "ColorType_" $ string(savedType));
    // End:0x5C
    if(bIncrement)
    {
        savedColorType++;        
    }
    else
    {
        savedColorType--;
    }
    savedColorType = CheckColorRange(savedColorType);
    SetOptionInt("Highlight", "ColorType_" $ string(savedType), savedColorType);
    TypeColorNameTxt.SetAlpha(25);
    TypeColorNameTxt.SetAlpha(255, 0.2500000);
    CheckButtonState(byte(savedType), byte(savedColorType));
    SetTextWithColor(savedColorType);
    return;
}

function UpdateHighlightType(PartyWndOption.eHighlightType Type)
{
    local int savedColorType;

    savedColorType = GetColorType(int(Type));
    SetTextWithColor(savedColorType);
    TypeIconTx.SetTexture(GetHighlightTypeIconString(Type));
    TypeNameTxt.SetText(GetClassTypeNameString(Type));
    TypeIconTx.SetAlpha(25);
    TypeIconTx.SetAlpha(255, 0.2500000);
    TypeNameTxt.SetAlpha(25);
    TypeNameTxt.SetAlpha(255, 0.2500000);
    CheckButtonState(Type, byte(savedColorType));
    getClassListTooltip(int(Type));
    return;
}

function int GetColorType(int Type)
{
    local int savedColorType;

    savedColorType = GetOptionInt("Highlight", "ColorType_" $ string(Type));
    savedColorType = CheckColorRange(savedColorType);
    return savedColorType;
    return;
}

function CheckButtonState(PartyWndOption.eHighlightType Type, PartyWndOption.eHighlightColorType colorType)
{
    TypeLeftBtn.EnableWindow();
    TypeRightBtn.EnableWindow();
    TypeColorLeftBtn.EnableWindow();
    TypeColorRightBtn.EnableWindow();
    // End:0x58
    if(int(Type) <= 0)
    {
        TypeLeftBtn.DisableWindow();
    }
    // End:0x78
    if(int(Type) >= (11 - 1))
    {
        TypeRightBtn.DisableWindow();
    }
    // End:0x94
    if(int(colorType) <= 0)
    {
        TypeColorLeftBtn.DisableWindow();
    }
    // End:0xB4
    if(int(colorType) >= (9 - 1))
    {
        TypeColorRightBtn.DisableWindow();
    }
    return;
}

function int CheckHighlightType(int Type)
{
    // End:0x12
    if(Type <= 0)
    {
        Type = 0;
    }
    // End:0x29
    if(Type >= 11)
    {
        Type = 11 - 1;
    }
    return Type;
    return;
}

function int CheckColorRange(int colorType)
{
    // End:0x12
    if(colorType <= 0)
    {
        colorType = 0;
    }
    // End:0x29
    if(colorType >= 9)
    {
        colorType = 9 - 1;
    }
    return colorType;
    return;
}

function SetTextWithColor(int colorType)
{
    TypeColorNameTxt.SetTextColor(GetColorTypeNameColor(byte(colorType)));
    TypeColorNameTxt.SetText(GetColorTypeNameString(byte(colorType)));
    return;
}

function getClassListTooltip(int Type)
{
    local int i;
    local Color b0;
    local array<DrawItemInfo> drawListArr;
    local array<int> classesList, nextClassesList;

    TypeIconTx.ClearTooltip();
    TypeIconTx.SetTooltipType("text");
    getClassListByHighlightType(byte(Type), classesList);
    // End:0x76
    if(classesList.Length == 0)
    {
        drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(7811), getInstanceL2Util().Yellow, "", true, true);        
    }
    else
    {
        drawListArr[drawListArr.Length] = addDrawItemText(GetSystemString(7810), getInstanceL2Util().Yellow, "", true, true);
        drawListArr[drawListArr.Length] = addDrawItemBlank(1);
        i = 0;
        J0xC2:

        // End:0x142 [Loop If]
        if(i < classesList.Length)
        {
            GetNextClass(classesList[i], nextClassesList);
            drawListArr[drawListArr.Length] = addDrawItemText(((GetClassType(classesList[i]) @ "(") $ GetClassType(nextClassesList[0])) $ ")", getInstanceL2Util().ColorDesc, "", true, true);
            i++;
            // [Loop Continue]
            goto J0xC2;
        }
    }
    TypeIconTx.SetTooltipCustomType(MakeTooltipMultiTextByArray(drawListArr));
    return;
}

function getClassListByHighlightType(PartyWndOption.eHighlightType Type, out array<int> classes)
{
    switch(Type)
    {
        // End:0x0F
        case 0:
            // End:0x26B
            break;
        // End:0x71
        case 1:
            classes[classes.Length] = 2;
            classes[classes.Length] = 3;
            classes[classes.Length] = 46;
            classes[classes.Length] = 48;
            classes[classes.Length] = 55;
            classes[classes.Length] = 57;
            // End:0x26B
            break;
        // End:0xD3
        case 2:
            classes[classes.Length] = 12;
            classes[classes.Length] = 13;
            classes[classes.Length] = 27;
            classes[classes.Length] = 40;
            classes[classes.Length] = 128;
            classes[classes.Length] = 129;
            // End:0x26B
            break;
        // End:0x117
        case 3:
            classes[classes.Length] = 9;
            classes[classes.Length] = 24;
            classes[classes.Length] = 37;
            classes[classes.Length] = 130;
            // End:0x26B
            break;
        // End:0x14C
        case 4:
            classes[classes.Length] = 8;
            classes[classes.Length] = 23;
            classes[classes.Length] = 36;
            // End:0x26B
            break;
        // End:0x190
        case 5:
            classes[classes.Length] = 5;
            classes[classes.Length] = 6;
            classes[classes.Length] = 20;
            classes[classes.Length] = 33;
            // End:0x26B
            break;
        // End:0x1C5
        case 6:
            classes[classes.Length] = 16;
            classes[classes.Length] = 30;
            classes[classes.Length] = 43;
            // End:0x26B
            break;
        // End:0x1FA
        case 7:
            classes[classes.Length] = 51;
            classes[classes.Length] = 52;
            classes[classes.Length] = 135;
            // End:0x26B
            break;
        // End:0x211
        case 8:
            classes[classes.Length] = 21;
            // End:0x26B
            break;
        // End:0x228
        case 9:
            classes[classes.Length] = 34;
            // End:0x26B
            break;
        // End:0x25D
        case 10:
            classes[classes.Length] = 14;
            classes[classes.Length] = 28;
            classes[classes.Length] = 41;
            // End:0x26B
            break;
        // End:0x265
        case 11:
            // End:0x26B
            break;
        // End:0xFFFF
        default:
            // End:0x26B
            break;
            break;
    }
    return;
}

function string GetHighlightTypeIconString(PartyWndOption.eHighlightType Type)
{
    switch(Type)
    {
        // End:0x39
        case 0:
            return "L2UI_NewTex.BottomBar.PartyMatchingAni0000";
        // End:0x62
        case 1:
            return "UI_BOHPTS.Party.styleicon_warrior";
        // End:0x8B
        case 2:
            return "UI_BOHPTS.Party.styleicon_magican";
        // End:0xB3
        case 3:
            return "UI_BOHPTS.Party.styleicon_archer";
        // End:0xDB
        case 4:
            return "UI_BOHPTS.Party.styleicon_dagger";
        // End:0x103
        case 5:
            return "UI_BOHPTS.Party.styleicon_tanker";
        // End:0x12B
        case 6:
            return "UI_BOHPTS.Party.styleicon_healer";
        // End:0x156
        case 7:
            return "UI_BOHPTS.Party.styleicon_enchanter";
        // End:0x181
        case 8:
            return "UI_BOHPTS.Party.styleicon_songdance";
        // End:0x1AB
        case 9:
            return "UI_BOHPTS.Party.styleicon_warrior2";
        // End:0x1D5
        case 10:
            return "UI_BOHPTS.Party.styleicon_summoner";
        // End:0xFFFF
        default:
            return "";
            break;
    }    
    return;
}

function string GetClassTypeNameString(PartyWndOption.eHighlightType Type)
{
    switch(Type)
    {
        // End:0x18
        case 0:
            return GetSystemString(7781);
        // End:0x29
        case 1:
            return GetSystemString(7771);
        // End:0x3A
        case 2:
            return GetSystemString(7772);
        // End:0x4B
        case 3:
            return GetSystemString(7773);
        // End:0x5C
        case 4:
            return GetSystemString(7774);
        // End:0x6D
        case 5:
            return GetSystemString(7775);
        // End:0x7E
        case 6:
            return GetSystemString(7776);
        // End:0x8F
        case 7:
            return GetSystemString(7777);
        // End:0xA0
        case 8:
            return GetSystemString(7778);
        // End:0xB1
        case 9:
            return GetSystemString(7779);
        // End:0xC2
        case 10:
            return GetSystemString(7780);
        // End:0xFFFF
        default:
            return "";
            break;
    }    
    return;
}

function Color GetColorTypeNameColor(PartyWndOption.eHighlightColorType Type)
{
    switch(Type)
    {
        // End:0x1B
        case 0:
            return GetColor(128, 128, 128, 255);
        // End:0x2E
        case 1:
            return GetColor(0, 100, 255, 255);
        // End:0x41
        case 2:
            return GetColor(0, 255, 255, 255);
        // End:0x53
        case 3:
            return GetColor(0, 255, 0, 255);
        // End:0x66
        case 4:
            return GetColor(255, 165, 0, 255);
        // End:0x78
        case 5:
            return GetColor(255, 0, 0, 255);
        // End:0x8C
        case 6:
            return GetColor(238, 130, 238, 255);
        // End:0x9F
        case 7:
            return GetColor(255, 255, 0, 255);
        // End:0xB3
        case 8:
            return GetColor(255, 255, 255, 255);
        // End:0xFFFF
        default:
            return GetColor(128, 128, 128, 255);
            break;
    }    
    return;
}

function string GetColorTypeNameString(PartyWndOption.eHighlightColorType Type)
{
    switch(Type)
    {
        // End:0x18
        case 0:
            return GetSystemString(7782);
        // End:0x29
        case 1:
            return GetSystemString(7790);
        // End:0x3A
        case 2:
            return GetSystemString(7791);
        // End:0x4B
        case 3:
            return GetSystemString(7792);
        // End:0x5C
        case 4:
            return GetSystemString(7793);
        // End:0x6D
        case 5:
            return GetSystemString(7794);
        // End:0x7E
        case 6:
            return GetSystemString(7795);
        // End:0x8F
        case 7:
            return GetSystemString(7796);
        // End:0xA0
        case 8:
            return GetSystemString(7797);
        // End:0xFFFF
        default:
            return "";
            break;
    }    
    return;
}

function ShowPartyWndOption()
{
    // End:0x25
    if(!m_OptionShow)
    {
        m_PartyOption.ShowWindow();
        m_OptionShow = true;        
    }
    else
    {
        m_PartyOption.HideWindow();
        m_OptionShow = false;
    }
    return;
}
