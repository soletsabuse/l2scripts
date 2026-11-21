class HairshopWnd extends UICommonAPI;

const NUMCOLORSPACE = 2;

var WindowHandle Me;
var SliderCtrlHandle RHColorCtrl[2];
var SliderCtrlHandle GSColorCtrl[2];
var SliderCtrlHandle BVColorCtrl[2];
var int colorspaceIndex;
var ComboBoxHandle ColorspaceBox;
var ComboBoxHandle hairTypeBox;
var CheckBoxHandle NewHairUseBox;
var CheckBoxHandle HairColorUseBox;
var ButtonHandle btnClose;
var EditBoxHandle RHColorBox;
var EditBoxHandle GSColorBox;
var EditBoxHandle BVColorBox;
var bool bUseNewHair;
var bool bUseHairColor;
var int gHairtype;
var int nColorRH[2];
var int nColorGS[2];
var int nColorBV[2];
var int savedHairtype;

function OnRegisterEvent()
{
    RegisterEvent(9410);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    Initialize();
    // End:0x19
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    return;
}

function Initialize()
{
    local int i;

    Me = GetWindowHandle("HairshopWnd");
    RHColorCtrl[0] = GetSliderCtrlHandle("HairshopWnd.RColorCtrl");
    GSColorCtrl[0] = GetSliderCtrlHandle("HairshopWnd.GColorCtrl");
    BVColorCtrl[0] = GetSliderCtrlHandle("HairshopWnd.BColorCtrl");
    RHColorCtrl[1] = GetSliderCtrlHandle("HairshopWnd.HColorCtrl");
    GSColorCtrl[1] = GetSliderCtrlHandle("HairshopWnd.SColorCtrl");
    BVColorCtrl[1] = GetSliderCtrlHandle("HairshopWnd.VColorCtrl");
    ColorspaceBox = GetComboBoxHandle("HairshopWnd.ColorspaceBox");
    hairTypeBox = GetComboBoxHandle("HairshopWnd.hairTypeBox");
    NewHairUseBox = GetCheckBoxHandle("HairshopWnd.NewHairUseBox");
    HairColorUseBox = GetCheckBoxHandle("HairshopWnd.HairColorUseBox");
    btnClose = GetButtonHandle("HairshopWnd.btnClose");
    RHColorBox = GetEditBoxHandle("HairshopWnd.RColorBox");
    GSColorBox = GetEditBoxHandle("HairshopWnd.GColorBox");
    BVColorBox = GetEditBoxHandle("HairshopWnd.BColorBox");
    colorspaceIndex = 0;
    gHairtype = 0;
    updateHairColorData();
    i = 0;
    J0x23F:

    // End:0x260 [Loop If]
    if(i < 2)
    {
        hideAllSliderBar(i);
        i++;
        // [Loop Continue]
        goto J0x23F;
    }
    i = 0;
    J0x267:

    // End:0x29C [Loop If]
    if(i < gHairtype)
    {
        hairTypeBox.AddString(ConvertNumToTextNoAdena(string(i)));
        i++;
        // [Loop Continue]
        goto J0x267;
    }
    showAllSliderBar(colorspaceIndex);
    setRGBTextBox(nColorRH[colorspaceIndex], nColorGS[colorspaceIndex], nColorBV[colorspaceIndex]);
    savedHairtype = 0;
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x1D
        case 9410:
            handleHairColorData(param);
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickCheckBox(string strID)
{
    applyData();
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1D
        case "btnClose":
            OnBtnCloseClick();
            // End:0x20
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnComboBoxItemSelected(string strID, int Index)
{
    local int i;

    // End:0x93
    if(strID == "ColorspaceBox")
    {
        colorspaceIndex = Index;
        i = 0;
        J0x2B:

        // End:0x69 [Loop If]
        if(i < 2)
        {
            // End:0x54
            if(i == Index)
            {
                showAllSliderBar(i);
                // [Explicit Continue]
                goto J0x5F;
            }
            hideAllSliderBar(i);
            J0x5F:

            i++;
            // [Loop Continue]
            goto J0x2B;
        }
        setRGBTextBox(nColorRH[colorspaceIndex], nColorGS[colorspaceIndex], nColorBV[colorspaceIndex]);        
    }
    else
    {
        // End:0xC9
        if(strID == "hairTypeBox")
        {
            Class'NWindow.HairshopAPI'.static.ApplyHairType(Index);
            savedHairtype = Index;
        }
    }
    return;
}

function showAllSliderBar(int idx)
{
    RHColorCtrl[idx].ShowWindow();
    GSColorCtrl[idx].ShowWindow();
    BVColorCtrl[idx].ShowWindow();
    return;
}

function hideAllSliderBar(int idx)
{
    RHColorCtrl[idx].HideWindow();
    GSColorCtrl[idx].HideWindow();
    BVColorCtrl[idx].HideWindow();
    return;
}

function OnBtnCloseClick()
{
    PlayConsoleSound(6);
    Me.HideWindow();
    return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
    switch(strID)
    {
        // End:0x16
        case "RColorCtrl":
        // End:0x25
        case "GColorCtrl":
        // End:0x34
        case "BColorCtrl":
        // End:0x43
        case "HColorCtrl":
        // End:0x52
        case "SColorCtrl":
        // End:0x91
        case "VColorCtrl":
            applyData();
            setRGBTextBox(nColorRH[colorspaceIndex], nColorGS[colorspaceIndex], nColorBV[colorspaceIndex]);
            // End:0x94
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function applyData()
{
    nColorRH[colorspaceIndex] = RHColorCtrl[colorspaceIndex].GetCurrentTick();
    nColorGS[colorspaceIndex] = GSColorCtrl[colorspaceIndex].GetCurrentTick();
    nColorBV[colorspaceIndex] = BVColorCtrl[colorspaceIndex].GetCurrentTick();
    // End:0x8C
    if(colorspaceIndex == 0)
    {
        RGBtoHSV(nColorRH[0], nColorGS[0], nColorBV[0]);        
    }
    else
    {
        // End:0xB8
        if(colorspaceIndex == 1)
        {
            HSVtoRGB(float(nColorRH[1]), float(nColorGS[1]), float(nColorBV[1]));
        }
    }
    bUseNewHair = NewHairUseBox.IsChecked();
    bUseHairColor = HairColorUseBox.IsChecked();
    Class'NWindow.HairshopAPI'.static.ApplyCharHairInfo(bUseNewHair, savedHairtype, bUseHairColor, nColorRH[0], nColorGS[0], nColorBV[0]);
    return;
}

function updateHairColorData()
{
    Class'NWindow.HairshopAPI'.static.UpdateCharHairInfo();
    return;
}

function handleHairColorData(string param)
{
    local int i, tempUseHairCol;

    ParseInt(param, "bUseCustomHair", tempUseHairCol);
    ParseInt(param, "maxHairNum", gHairtype);
    ParseInt(param, "colorR", nColorRH[0]);
    ParseInt(param, "colorG", nColorGS[0]);
    ParseInt(param, "colorB", nColorBV[0]);
    bUseNewHair = bool(tempUseHairCol);
    RGBtoHSV(nColorRH[0], nColorGS[0], nColorBV[0]);
    i = 0;
    J0xBA:

    // End:0x130 [Loop If]
    if(i < 2)
    {
        RHColorCtrl[i].SetCurrentTick(nColorRH[i]);
        GSColorCtrl[i].SetCurrentTick(nColorGS[i]);
        BVColorCtrl[i].SetCurrentTick(nColorBV[i]);
        i++;
        // [Loop Continue]
        goto J0xBA;
    }
    setRGBTextBox(nColorRH[colorspaceIndex], nColorGS[colorspaceIndex], nColorBV[colorspaceIndex]);
    return;
}

function setRGBTextBox(int rh, int gs, int bv)
{
    RHColorBox.SetString(string(rh));
    GSColorBox.SetString(string(gs));
    BVColorBox.SetString(string(bv));
    return;
}

function float __min_channel(float R, float G, float B)
{
    local float t;

    // End:0x1D
    if(R < G)
    {
        t = R;        
    }
    else
    {
        t = G;
    }
    // End:0x42
    if(t > B)
    {
        t = B;
    }
    return t;
    return;
}

function float __max_channel(float R, float G, float B)
{
    local float t;

    // End:0x1D
    if(R > G)
    {
        t = R;        
    }
    else
    {
        t = G;
    }
    // End:0x42
    if(t < B)
    {
        t = B;
    }
    return t;
    return;
}

function RGBtoHSV(int inr, int ing, int inb)
{
    local float R, G, B, minVal, maxVal, deltaVal;

    R = float(inr) / 255.0000000;
    G = float(ing) / 255.0000000;
    B = float(inb) / 255.0000000;
    minVal = __min_channel(R, G, B);
    maxVal = __max_channel(R, G, B);
    nColorBV[1] = int(maxVal * 100.0000000);
    deltaVal = maxVal - minVal;
    // End:0xC7
    if(maxVal != float(0))
    {
        nColorGS[1] = int((deltaVal / maxVal) * 100.0000000);        
    }
    else
    {
        nColorGS[1] = -1;
        return;
    }
    // End:0x105
    if(R == maxVal)
    {
        nColorRH[1] = int((G - B) / deltaVal);        
    }
    else
    {
        // End:0x13B
        if(G == maxVal)
        {
            nColorRH[1] = int(2.0000000 + ((B - R) / deltaVal));            
        }
        else
        {
            nColorRH[1] = int(4.0000000 + ((R - G) / deltaVal));
        }
    }
    nColorRH[1] = 60;
    // End:0x183
    if(nColorRH[1] < 0)
    {
        nColorRH[1] = 360;
    }
    return;
}

function HSVtoRGB(float h, float S, float V)
{
    local int i;
    local float F, q, P, t, floatR, floatG,
	    floatB;

    // End:0x4A
    if(S == float(0))
    {
        nColorRH[0] = int((V / 100.0000000) * 255.0000000);
        nColorGS[0] = nColorRH[0];
        nColorBV[0] = nColorRH[0];
        return;
    }
    h /= 60.0000000;
    i = int(h + 0.5000000);
    F = h - float(i);
    P = (V / 100.0000000) * (float(1) - (S / 100.0000000));
    q = (V / 100.0000000) * (float(1) - ((S / 100.0000000) * F));
    t = (V / 100.0000000) * (float(1) - ((S / 100.0000000) * (float(1) - F)));
    switch(i)
    {
        // End:0x136
        case 0:
            floatR = V / 100.0000000;
            floatG = t;
            floatB = P;
            // End:0x223
            break;
        // End:0x165
        case 1:
            floatR = q;
            floatG = V / 100.0000000;
            floatB = P;
            // End:0x223
            break;
        // End:0x195
        case 2:
            floatR = P;
            floatG = V / 100.0000000;
            floatB = t;
            // End:0x223
            break;
        // End:0x1C5
        case 3:
            floatR = P;
            floatG = q;
            floatB = V / 100.0000000;
            // End:0x223
            break;
        // End:0x1F5
        case 4:
            floatR = t;
            floatG = P;
            floatB = V / 100.0000000;
            // End:0x223
            break;
        // End:0xFFFF
        default:
            floatR = V / 100.0000000;
            floatG = P;
            floatB = q;
            // End:0x223
            break;
            break;
    }
    nColorRH[0] = int(floatR * 255.0000000);
    nColorGS[0] = int(floatG * 255.0000000);
    nColorBV[0] = int(floatB * 255.0000000);
    return;
}
