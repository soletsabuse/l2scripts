class SkillEffectWnd extends UICommonAPI;

const Num = 51;

var int SkillID[51];
var string SkillIcon[51];
var string m_WindowName;
var int m_Active;

function OnLoad()
{
    m_WindowName = getCurrentWindowName(string(self));
    SetClosingOnESC();
    m_Active = 1;
    GetINIInt("Cfg", "Active", m_Active, "SkillFx.ini");
    // End:0x61
    if((m_Active < 1) || m_Active > 3)
    {
        m_Active = 1;
    }
    initIcons();
    loadProfile();
    return;
}

function initIcons()
{
    local int i, Id;
    local string S, nm;
    local ItemID cID;

    cID.ServerID = 0;
    i = 0;
    J0x13:

    // End:0xF7 [Loop If]
    if(i < 51)
    {
        Id = SkillID[i];
        S = string(Id);
        cID.ClassID = Id;
        nm = Class'NWindow.UIDATA_SKILL'.static.GetName(cID, 1, 0);
        GetTextureHandle((m_WindowName $ ".ic") $ S).SetTexture(SkillIcon[i]);
        GetTextBoxHandle((m_WindowName $ ".nm") $ S).SetText(nm);
        GetTextBoxHandle((m_WindowName $ ".nm") $ S).SetTooltipCustomType(MakeTooltipSimpleText(nm));
        i++;
        // [Loop Continue]
        goto J0x13;
    }
    return;
}

function loadProfile()
{
    local int i, Id, ST;
    local string Sec;

    Sec = "P" $ string(m_Active);
    highlightProfile();
    i = 0;
    J0x1F:

    // End:0xD6 [Loop If]
    if(i < 51)
    {
        Id = SkillID[i];
        ST = 1;
        GetINIInt(Sec, string(Id), ST, "SkillFx.ini");
        // End:0x8A
        if(ST != 0)
        {
            Class'NWindow.SkillAnimSwapAPI'.static.SetSkillEffectEnabled(Id, true);            
        }
        else
        {
            Class'NWindow.SkillAnimSwapAPI'.static.SetSkillEffectEnabled(Id, false);
        }
        GetCheckBoxHandle((m_WindowName $ ".cb") $ string(Id)).SetCheck(ST != 0);
        i++;
        // [Loop Continue]
        goto J0x1F;
    }
    return;
}

function highlightProfile()
{
    GetButtonHandle(m_WindowName $ ".Prof1").SetTexture(profTex(1), profTex(1), profTex(1));
    GetButtonHandle(m_WindowName $ ".Prof2").SetTexture(profTex(2), profTex(2), profTex(2));
    GetButtonHandle(m_WindowName $ ".Prof3").SetTexture(profTex(3), profTex(3), profTex(3));
    return;
}

function string profTex(int P)
{
    // End:0x32
    if(P == m_Active)
    {
        return "L2UI_NewTex.Button.Button23_Down";
    }
    return "L2UI_NewTex.Button.Button23_DF";
    return;
}

function OnClickCheckBox(string strID)
{
    local int Id, newst;

    Id = int(Mid(strID, 2));
    // End:0x47
    if(Class'NWindow.SkillAnimSwapAPI'.static.IsSkillEffectEnabled(Id))
    {
        Class'NWindow.SkillAnimSwapAPI'.static.SetSkillEffectEnabled(Id, false);
        newst = 0;        
    }
    else
    {
        Class'NWindow.SkillAnimSwapAPI'.static.SetSkillEffectEnabled(Id, true);
        newst = 1;
    }
    SetINIInt("P" $ string(m_Active), string(Id), newst, "SkillFx.ini");
    return;
}

function OnClickButton(string strID)
{
    // End:0x1B
    if(strID == "Prof1")
    {
        switchProfile(1);        
    }
    else
    {
        // End:0x37
        if(strID == "Prof2")
        {
            switchProfile(2);            
        }
        else
        {
            // End:0x53
            if(strID == "Prof3")
            {
                switchProfile(3);                
            }
            else
            {
                // End:0x7C
                if(strID == "CloseBtn")
                {
                    GetWindowHandle(m_WindowName).HideWindow();
                }
            }
        }
    }
    return;
}

function switchProfile(int P)
{
    m_Active = P;
    SetINIInt("Cfg", "Active", m_Active, "SkillFx.ini");
    loadProfile();
    return;
}

defaultproperties
{
    SkillID[0]=110
    SkillID[1]=111
    SkillID[2]=139
    SkillID[3]=176
    SkillID[4]=287
    SkillID[5]=341
    SkillID[6]=368
    SkillID[7]=406
    SkillID[8]=420
    SkillID[9]=443
    SkillID[10]=445
    SkillID[11]=446
    SkillID[12]=447
    SkillID[13]=483
    SkillID[14]=499
    SkillID[15]=536
    SkillID[16]=622
    SkillID[17]=760
    SkillID[18]=768
    SkillID[19]=769
    SkillID[20]=785
    SkillID[21]=787
    SkillID[22]=789
    SkillID[23]=916
    SkillID[24]=917
    SkillID[25]=948
    SkillID[26]=1016
    SkillID[27]=1409
    SkillID[28]=1411
    SkillID[29]=1418
    SkillID[30]=1470
    SkillID[31]=1476
    SkillID[32]=1478
    SkillID[33]=1479
    SkillID[34]=1514
    SkillID[35]=1532
    SkillID[36]=1533
    SkillID[37]=1556
    SkillID[38]=3284
    SkillID[39]=10279
    SkillID[40]=21237
    SkillID[41]=64222
    SkillID[42]=442
    SkillID[43]=837
    SkillID[44]=528
    SkillID[45]=64270
    SkillID[46]=1254
    SkillID[47]=11764
    SkillID[48]=1427
    SkillID[49]=1505
    SkillID[50]=1273
    SkillIcon[0]="icon.skill0110"
    SkillIcon[1]="icon.skill0111"
    SkillIcon[2]="icon.skill0139"
    SkillIcon[3]="icon.skill0176"
    SkillIcon[4]="icon.skill0287"
    SkillIcon[5]="icon.skill0341"
    SkillIcon[6]="icon.skill0368"
    SkillIcon[7]="icon.skill0406"
    SkillIcon[8]="icon.skill0420"
    SkillIcon[9]="icon.skill0443"
    SkillIcon[10]="icon.skill0445"
    SkillIcon[11]="icon.skill0446"
    SkillIcon[12]="icon.skill0447"
    SkillIcon[13]="icon.skill0483"
    SkillIcon[14]="icon.skill0499"
    SkillIcon[15]="icon.skill0536"
    SkillIcon[16]="icon.skill0622"
    SkillIcon[17]="icon.skill0760"
    SkillIcon[18]="icon.skill0768"
    SkillIcon[19]="icon.skill0769"
    SkillIcon[20]="icon.skill0785"
    SkillIcon[21]="icon.skill0787"
    SkillIcon[22]="icon.skill0789"
    SkillIcon[23]="icon.skill0916"
    SkillIcon[24]="icon.skill0917"
    SkillIcon[25]="icon.skill0948"
    SkillIcon[26]="icon.skill1016"
    SkillIcon[27]="icon.skill1409"
    SkillIcon[28]="icon.skill1411"
    SkillIcon[29]="icon.skill1418"
    SkillIcon[30]="icon.skill1470"
    SkillIcon[31]="icon.skill1476"
    SkillIcon[32]="icon.skill1478"
    SkillIcon[33]="icon.skill1479"
    SkillIcon[34]="icon.skill1514"
    SkillIcon[35]="icon.skill1532"
    SkillIcon[36]="icon.skill1532"
    SkillIcon[37]="icon.skill1556"
    SkillIcon[38]="talici_ico.blue_11"
    SkillIcon[39]="icon.skill10279"
    SkillIcon[40]="icon.skill1418"
    SkillIcon[41]="icon.skill0111"
    SkillIcon[42]="icon.skill0442"
    SkillIcon[43]="icon.skill0837"
    SkillIcon[44]="icon.skill0528"
    SkillIcon[45]="icon.skill10092_2"
    SkillIcon[46]="icon.skill1254"
    SkillIcon[47]="icon.skill1550"
    SkillIcon[48]="icon.skill1427"
    SkillIcon[49]="icon.skill1505"
    SkillIcon[50]="icon.skill1273"
}