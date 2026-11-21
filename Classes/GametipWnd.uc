class GametipWnd extends UIScript;

var array<GameTipData> TipData;
var int CountRecord;
var UserInfo userinfofortip;
var string CurrentTip;
var string CurrentTipImgTexture;
var int numb;

function OnRegisterEvent()
{
    RegisterEvent(8000);
    RegisterEvent(1900);
    return;
}

function OnLoad()
{
    LoadGameTipData();
    return;
}

function OnEventWithStr(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x18
        case 1900:
            LoadGameTipData();
            // End:0x1B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x18
        case 8000:
            LoadGameTipData();
            // End:0x1B
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function LoadGameTipData()
{
    local int i;
    local bool gamedataloaded;
    local GameTipData TipData1;

    CountRecord = Class'NWindow.UIDATA_GAMETIP'.static.GetDataCount();
    i = 0;
    J0x1C:

    // End:0x66 [Loop If]
    if(i < CountRecord)
    {
        gamedataloaded = Class'NWindow.UIDATA_GAMETIP'.static.GetDataByIndex(i, TipData1);
        TipData[i] = TipData1;
        ++i;
        // [Loop Continue]
        goto J0x1C;
    }
    return;
}

function OnShow()
{
    local int RandomVal, PrioritySelect, UserLevelData;
    local bool userinfoloaded;
    local array<GameTipData> SelectedCondition;
    local int i, j, UserLevel, UserArrange, NumberSelect;

    local GameTipData tempTipData;
    local LoadingWnd loadingWndScript;

    j = 0;
    userinfoloaded = GetPlayerInfo(userinfofortip);
    // End:0x28
    if(userinfoloaded == false)
    {        
    }
    UserLevelData = userinfofortip.nLevel;
    // End:0x5B
    if((UserLevelData >= 1) && UserLevelData <= 20)
    {
        UserLevel = 1;        
    }
    else
    {
        // End:0x80
        if((UserLevelData >= 21) && UserLevelData <= 40)
        {
            UserLevel = 20;            
        }
        else
        {
            // End:0xA5
            if((UserLevelData >= 41) && UserLevelData <= 60)
            {
                UserLevel = 40;                
            }
            else
            {
                // End:0xCA
                if((UserLevelData >= 61) && UserLevelData <= 74)
                {
                    UserLevel = 60;                    
                }
                else
                {
                    // End:0xEF
                    if((UserLevelData >= 75) && UserLevelData <= 84)
                    {
                        UserLevel = 80;                        
                    }
                    else
                    {
                        UserLevel = 90;
                    }
                }
            }
        }
    }
    // End:0x11B
    if((UserLevelData <= 40) && UserLevelData > 0)
    {
        UserArrange = 101;        
    }
    else
    {
        // End:0x140
        if((UserLevelData < 85) && UserLevelData >= 41)
        {
            UserArrange = 102;            
        }
        else
        {
            UserArrange = 103;
        }
    }
    RandomVal = Rand(99) + 1;
    // End:0x178
    if((RandomVal >= 1) && RandomVal <= 70)
    {
        PrioritySelect = 1;        
    }
    else
    {
        // End:0x19D
        if((RandomVal >= 71) && RandomVal <= 85)
        {
            PrioritySelect = 2;            
        }
        else
        {
            // End:0x1C2
            if((RandomVal >= 86) && RandomVal <= 95)
            {
                PrioritySelect = 3;                
            }
            else
            {
                // End:0x1E4
                if((RandomVal >= 96) && RandomVal <= 100)
                {
                    PrioritySelect = 4;
                }
            }
        }
    }
    i = 0;
    J0x1EB:

    // End:0x2F7 [Loop If]
    if(i < TipData.Length)
    {
        // End:0x2ED
        if(TipData[i].TipMsg != "")
        {
            // End:0x2ED
            if((TipData[i].Priority == PrioritySelect) && TipData[i].Validity == true)
            {
                // End:0x2ED
                if(((TipData[i].TargetLevel == UserLevel) || TipData[i].TargetLevel == 0) || TipData[i].TargetLevel == UserArrange)
                {
                    SelectedCondition[j] = tempTipData;
                    SelectedCondition[j].TipMsg = TipData[i].TipMsg;
                    SelectedCondition[j].TipImg = TipData[i].TipImg;
                    ++j;
                }
            }
        }
        ++i;
        // [Loop Continue]
        goto J0x1EB;
    }
    NumberSelect = Rand(SelectedCondition.Length);
    // End:0x324
    if(SelectedCondition.Length == 0)
    {
        CurrentTip = "";
        CurrentTipImgTexture = "";        
    }
    else
    {
        CurrentTip = SelectedCondition[NumberSelect].TipMsg;
        CurrentTipImgTexture = SelectedCondition[NumberSelect].TipImg;
        loadingWndScript = LoadingWnd(GetScript("LoadingWnd"));
        loadingWndScript.setBackgroundTextureStr(CurrentTipImgTexture);
    }
    // End:0x40B
    if(GetOptionBool("ScreenInfo", "ShowGameTipMsg") == true)
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText1", GetSystemString(1455));
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText", CurrentTip);        
    }
    else
    {
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText1", "");
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("GametipWnd.GameTipText", "");
    }
    return;
}
