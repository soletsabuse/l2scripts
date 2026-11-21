class MiniGame1Wnd extends UIScript;

const MAX_COLOR = 6;
const MAX_ROW = 8;
const TOTAL_GRID = 64;
const IDLE_NUMBER = 999;
const TIMER_ID1 = 1260;
const TIMER_DELAY1 = 300;
const TIMER_ID2 = 1261;
const TIMER_DELAY2 = 500;
const TIMER_ID3 = 1262;
const TIMER_DELAY3 = 300;
const TIMER_ID4 = 1263;
const TIMER_DELAY4 = 5;
const TIMER_ID5 = 1264;
const TIMER_DELAY5 = 300;
const TARGETSCORESEED = 300;

struct MG1CellData
{
    var int X;
    var int Y;
    var int RV;
    var string BtnTex;
    var bool isFlagged;
    var TextureHandle TextureLoc;
    var ButtonHandle ButtonLoc;
    var AnimTextureHandle AnimLoc;
};

var MG1CellData CellGridData[64];
var WindowHandle Me;
var TextureHandle MGTex0[8];
var TextureHandle MGTex1[8];
var TextureHandle MGTex2[8];
var TextureHandle MGTex3[8];
var TextureHandle MGTex4[8];
var TextureHandle MGTex5[8];
var TextureHandle MGTex6[8];
var TextureHandle MGTex7[8];
var ButtonHandle MGBtn0[8];
var ButtonHandle MGBtn1[8];
var ButtonHandle MGBtn2[8];
var ButtonHandle MGBtn3[8];
var ButtonHandle MGBtn4[8];
var ButtonHandle MGBtn5[8];
var ButtonHandle MGBtn6[8];
var ButtonHandle MGBtn7[8];
var AnimTextureHandle MGAnim0[8];
var AnimTextureHandle MGAnim1[8];
var AnimTextureHandle MGAnim2[8];
var AnimTextureHandle MGAnim3[8];
var AnimTextureHandle MGAnim4[8];
var AnimTextureHandle MGAnim5[8];
var AnimTextureHandle MGAnim6[8];
var AnimTextureHandle MGAnim7[8];
var ButtonHandle MG_BTNChallenge;
var ButtonHandle MG_BTNClose;
var ProgressCtrlHandle ProgressBar;
var TextureHandle ResultTex;
var string TX[6];
var bool m_InGamingBool;
var bool m_IsNewGamingBool;
var bool m_PauseBool;
var int m_MatchCount;
var int m_CellBtnStatus;
var int m_CellBtnID1;
var int m_CellBtnID2;
var int m_CurrentLevel;
var int m_CurrentTimer;
var int m_CurrentScore;
var int m_TargetScore;
var int m_CountNumberofChains;
var int m_CurrentAnimID;
var ButtonHandle BtnRanking;
var WindowHandle MiniGameRankWnd;
var int m_bUseJapanStyle;

function OnRegisterEvent()
{
    RegisterEvent(3520);
    return;
}

function OnLoad()
{
    local int i;

    SetClosingOnESC();
    m_bUseJapanStyle = 0;
    GetINIBool("Localize", "UseJapanMinigame1", m_bUseJapanStyle, "L2.ini");
    // End:0xADA
    if(1 == 0)
    {
        BtnRanking = ButtonHandle(GetHandle("MiniGame1Wnd.BtnRanking"));
        MiniGameRankWnd = GetHandle("BR_MiniRankWnd");
        Me = GetHandle("MiniGame1Wnd");
        ProgressBar = ProgressCtrlHandle(GetHandle("MG_Progress"));
        ResultTex = TextureHandle(GetHandle("MG_RESULT"));
        MG_BTNChallenge = ButtonHandle(GetHandle("MG_BTNChallenge"));
        MG_BTNClose = ButtonHandle(GetHandle("MG_BTNClose"));
        i = 0;
        J0x125:

        // End:0xAD7 [Loop If]
        if(i < 8)
        {
            MGTex0[i] = TextureHandle(GetHandle("MG_Texture-0-" $ string(i)));
            MGBtn0[i] = ButtonHandle(GetHandle("MG_Button-0-" $ string(i)));
            MGAnim0[i] = AnimTextureHandle(GetHandle("MG_AnimTexture-0-" $ string(i)));
            CellGridData[i + (8 * 0)].ButtonLoc = MGBtn0[i];
            CellGridData[i + (8 * 0)].TextureLoc = MGTex0[i];
            CellGridData[i + (8 * 0)].AnimLoc = MGAnim0[i];
            CellGridData[i + (8 * 0)].X = 0;
            CellGridData[i + (8 * 0)].Y = i;
            MGTex1[i] = TextureHandle(GetHandle("MG_Texture-1-" $ string(i)));
            MGBtn1[i] = ButtonHandle(GetHandle("MG_Button-1-" $ string(i)));
            MGAnim1[i] = AnimTextureHandle(GetHandle("MG_AnimTexture-1-" $ string(i)));
            CellGridData[i + (8 * 1)].ButtonLoc = MGBtn1[i];
            CellGridData[i + (8 * 1)].TextureLoc = MGTex1[i];
            CellGridData[i + (8 * 1)].AnimLoc = MGAnim1[i];
            CellGridData[i + (8 * 1)].X = 1;
            CellGridData[i + (8 * 1)].Y = i;
            MGTex2[i] = TextureHandle(GetHandle("MG_Texture-2-" $ string(i)));
            MGBtn2[i] = ButtonHandle(GetHandle("MG_Button-2-" $ string(i)));
            MGAnim2[i] = AnimTextureHandle(GetHandle("MG_AnimTexture-2-" $ string(i)));
            CellGridData[i + (8 * 2)].ButtonLoc = MGBtn2[i];
            CellGridData[i + (8 * 2)].TextureLoc = MGTex2[i];
            CellGridData[i + (8 * 2)].AnimLoc = MGAnim2[i];
            CellGridData[i + (8 * 2)].X = 2;
            CellGridData[i + (8 * 2)].Y = i;
            MGTex3[i] = TextureHandle(GetHandle("MG_Texture-3-" $ string(i)));
            MGBtn3[i] = ButtonHandle(GetHandle("MG_Button-3-" $ string(i)));
            MGAnim3[i] = AnimTextureHandle(GetHandle("MG_AnimTexture-3-" $ string(i)));
            CellGridData[i + (8 * 3)].ButtonLoc = MGBtn3[i];
            CellGridData[i + (8 * 3)].TextureLoc = MGTex3[i];
            CellGridData[i + (8 * 3)].AnimLoc = MGAnim3[i];
            CellGridData[i + (8 * 3)].X = 3;
            CellGridData[i + (8 * 3)].Y = i;
            MGTex4[i] = TextureHandle(GetHandle("MG_Texture-4-" $ string(i)));
            MGBtn4[i] = ButtonHandle(GetHandle("MG_Button-4-" $ string(i)));
            MGAnim4[i] = AnimTextureHandle(GetHandle("MG_AnimTexture-4-" $ string(i)));
            CellGridData[i + (8 * 4)].ButtonLoc = MGBtn4[i];
            CellGridData[i + (8 * 4)].TextureLoc = MGTex4[i];
            CellGridData[i + (8 * 4)].AnimLoc = MGAnim4[i];
            CellGridData[i + (8 * 4)].X = 4;
            CellGridData[i + (8 * 4)].Y = i;
            MGTex5[i] = TextureHandle(GetHandle("MG_Texture-5-" $ string(i)));
            MGBtn5[i] = ButtonHandle(GetHandle("MG_Button-5-" $ string(i)));
            MGAnim5[i] = AnimTextureHandle(GetHandle("MG_AnimTexture-5-" $ string(i)));
            CellGridData[i + (8 * 5)].ButtonLoc = MGBtn5[i];
            CellGridData[i + (8 * 5)].TextureLoc = MGTex5[i];
            CellGridData[i + (8 * 5)].AnimLoc = MGAnim5[i];
            CellGridData[i + (8 * 5)].X = 5;
            CellGridData[i + (8 * 5)].Y = i;
            MGTex6[i] = TextureHandle(GetHandle("MG_Texture-6-" $ string(i)));
            MGBtn6[i] = ButtonHandle(GetHandle("MG_Button-6-" $ string(i)));
            MGAnim6[i] = AnimTextureHandle(GetHandle("MG_AnimTexture-6-" $ string(i)));
            CellGridData[i + (8 * 6)].ButtonLoc = MGBtn6[i];
            CellGridData[i + (8 * 6)].TextureLoc = MGTex6[i];
            CellGridData[i + (8 * 6)].AnimLoc = MGAnim6[i];
            CellGridData[i + (8 * 6)].X = 6;
            CellGridData[i + (8 * 6)].Y = i;
            MGTex7[i] = TextureHandle(GetHandle("MG_Texture-7-" $ string(i)));
            MGBtn7[i] = ButtonHandle(GetHandle("MG_Button-7-" $ string(i)));
            MGAnim7[i] = AnimTextureHandle(GetHandle("MG_AnimTexture-7-" $ string(i)));
            CellGridData[i + (8 * 7)].ButtonLoc = MGBtn7[i];
            CellGridData[i + (8 * 7)].TextureLoc = MGTex7[i];
            CellGridData[i + (8 * 7)].AnimLoc = MGAnim7[i];
            CellGridData[i + (8 * 7)].X = 7;
            CellGridData[i + (8 * 7)].Y = i;
            i++;
            // [Loop Continue]
            goto J0x125;
        }        
    }
    else
    {
        BtnRanking = GetButtonHandle("MiniGame1Wnd.BtnRanking");
        MiniGameRankWnd = GetWindowHandle("BR_MiniGameRankWnd");
        Me = GetWindowHandle("MiniGame1Wnd");
        ProgressBar = GetProgressCtrlHandle("MG_Progress");
        ResultTex = GetTextureHandle("MG_RESULT");
        MG_BTNChallenge = GetButtonHandle("MG_BTNChallenge");
        MG_BTNClose = GetButtonHandle("MG_BTNClose");
        i = 0;
        J0xBA6:

        // End:0x14E0 [Loop If]
        if(i < 8)
        {
            MGTex0[i] = GetTextureHandle("MG_Texture-0-" $ string(i));
            MGBtn0[i] = GetButtonHandle("MG_Button-0-" $ string(i));
            MGAnim0[i] = GetAnimTextureHandle("MG_AnimTexture-0-" $ string(i));
            CellGridData[i + (8 * 0)].ButtonLoc = MGBtn0[i];
            CellGridData[i + (8 * 0)].TextureLoc = MGTex0[i];
            CellGridData[i + (8 * 0)].AnimLoc = MGAnim0[i];
            CellGridData[i + (8 * 0)].X = 0;
            CellGridData[i + (8 * 0)].Y = i;
            MGTex1[i] = GetTextureHandle("MG_Texture-1-" $ string(i));
            MGBtn1[i] = GetButtonHandle("MG_Button-1-" $ string(i));
            MGAnim1[i] = GetAnimTextureHandle("MG_AnimTexture-1-" $ string(i));
            CellGridData[i + (8 * 1)].ButtonLoc = MGBtn1[i];
            CellGridData[i + (8 * 1)].TextureLoc = MGTex1[i];
            CellGridData[i + (8 * 1)].AnimLoc = MGAnim1[i];
            CellGridData[i + (8 * 1)].X = 1;
            CellGridData[i + (8 * 1)].Y = i;
            MGTex2[i] = GetTextureHandle("MG_Texture-2-" $ string(i));
            MGBtn2[i] = GetButtonHandle("MG_Button-2-" $ string(i));
            MGAnim2[i] = GetAnimTextureHandle("MG_AnimTexture-2-" $ string(i));
            CellGridData[i + (8 * 2)].ButtonLoc = MGBtn2[i];
            CellGridData[i + (8 * 2)].TextureLoc = MGTex2[i];
            CellGridData[i + (8 * 2)].AnimLoc = MGAnim2[i];
            CellGridData[i + (8 * 2)].X = 2;
            CellGridData[i + (8 * 2)].Y = i;
            MGTex3[i] = GetTextureHandle("MG_Texture-3-" $ string(i));
            MGBtn3[i] = GetButtonHandle("MG_Button-3-" $ string(i));
            MGAnim3[i] = GetAnimTextureHandle("MG_AnimTexture-3-" $ string(i));
            CellGridData[i + (8 * 3)].ButtonLoc = MGBtn3[i];
            CellGridData[i + (8 * 3)].TextureLoc = MGTex3[i];
            CellGridData[i + (8 * 3)].AnimLoc = MGAnim3[i];
            CellGridData[i + (8 * 3)].X = 3;
            CellGridData[i + (8 * 3)].Y = i;
            MGTex4[i] = GetTextureHandle("MG_Texture-4-" $ string(i));
            MGBtn4[i] = GetButtonHandle("MG_Button-4-" $ string(i));
            MGAnim4[i] = GetAnimTextureHandle("MG_AnimTexture-4-" $ string(i));
            CellGridData[i + (8 * 4)].ButtonLoc = MGBtn4[i];
            CellGridData[i + (8 * 4)].TextureLoc = MGTex4[i];
            CellGridData[i + (8 * 4)].AnimLoc = MGAnim4[i];
            CellGridData[i + (8 * 4)].X = 4;
            CellGridData[i + (8 * 4)].Y = i;
            MGTex5[i] = GetTextureHandle("MG_Texture-5-" $ string(i));
            MGBtn5[i] = GetButtonHandle("MG_Button-5-" $ string(i));
            MGAnim5[i] = GetAnimTextureHandle("MG_AnimTexture-5-" $ string(i));
            CellGridData[i + (8 * 5)].ButtonLoc = MGBtn5[i];
            CellGridData[i + (8 * 5)].TextureLoc = MGTex5[i];
            CellGridData[i + (8 * 5)].AnimLoc = MGAnim5[i];
            CellGridData[i + (8 * 5)].X = 5;
            CellGridData[i + (8 * 5)].Y = i;
            MGTex6[i] = GetTextureHandle("MG_Texture-6-" $ string(i));
            MGBtn6[i] = GetButtonHandle("MG_Button-6-" $ string(i));
            MGAnim6[i] = GetAnimTextureHandle("MG_AnimTexture-6-" $ string(i));
            CellGridData[i + (8 * 6)].ButtonLoc = MGBtn6[i];
            CellGridData[i + (8 * 6)].TextureLoc = MGTex6[i];
            CellGridData[i + (8 * 6)].AnimLoc = MGAnim6[i];
            CellGridData[i + (8 * 6)].X = 6;
            CellGridData[i + (8 * 6)].Y = i;
            MGTex7[i] = GetTextureHandle("MG_Texture-7-" $ string(i));
            MGBtn7[i] = GetButtonHandle("MG_Button-7-" $ string(i));
            MGAnim7[i] = GetAnimTextureHandle("MG_AnimTexture-7-" $ string(i));
            CellGridData[i + (8 * 7)].ButtonLoc = MGBtn7[i];
            CellGridData[i + (8 * 7)].TextureLoc = MGTex7[i];
            CellGridData[i + (8 * 7)].AnimLoc = MGAnim7[i];
            CellGridData[i + (8 * 7)].X = 7;
            CellGridData[i + (8 * 7)].Y = i;
            i++;
            // [Loop Continue]
            goto J0xBA6;
        }
    }
    // End:0x1617
    if(m_bUseJapanStyle == 1)
    {
        TX[0] = "BranchSys.ui." $ "MiniGame_DF_Icon_DarkElf";
        TX[1] = "BranchSys.ui." $ "MiniGame_DF_Icon_Dwarf";
        TX[2] = "BranchSys.ui." $ "MiniGame_DF_Icon_Elf";
        TX[3] = "BranchSys.ui." $ "MiniGame_DF_Icon_Kamael";
        TX[4] = "BranchSys.ui." $ "MiniGame_DF_Icon_Orc";
        TX[5] = "BranchSys.ui." $ "MiniGame_DF_Icon_Human";        
    }
    else
    {
        TX[0] = "l2ui_ct1." $ "MiniGame_DF_Icon_Dark";
        TX[1] = "l2ui_ct1." $ "MiniGame_DF_Icon_Divine";
        TX[2] = "l2ui_ct1." $ "MiniGame_DF_Icon_Earth";
        TX[3] = "l2ui_ct1." $ "MiniGame_DF_Icon_Fire";
        TX[4] = "l2ui_ct1." $ "MiniGame_DF_Icon_Water";
        TX[5] = "l2ui_ct1." $ "MiniGame_DF_Icon_Wind";
    }
    m_InGamingBool = false;
    ClearCellGridData();
    return;
}

function OnEvent(int EvID, string param)
{
    // End:0x1E
    if(EvID == 3520)
    {
        Me.ShowWindow();
    }
    return;
}

function ClearScoreData()
{
    m_CurrentLevel = 0;
    m_CurrentTimer = 20;
    m_CurrentScore = 0;
    PutNumberLevel(m_CurrentLevel);
    PutNumberScore(m_CurrentScore);
    return;
}

function ClearCellGridData()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x55 [Loop If]
    if(i < 64)
    {
        CellGridData[i].RV = 0;
        CellGridData[i].BtnTex = "";
        CellGridData[i].isFlagged = false;
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnShow()
{
    Initialize();
    MG_BTNClose.SetNameText(GetSystemString(908));
    PutNumberLevel(0);
    PutNumberScore(0);
    MG_BTNChallenge.EnableWindow();
    return;
}

function ReadyCells()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x28 [Loop If]
    if(i < 64)
    {
        Randomize(i);
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    MoveTillnoMatches();
    return;
}

function MoveTillnoMatches()
{
    CheckMatches(false);
    CountMatches();
    J0x0D:

    // End:0x2E [Loop If]
    if(m_MatchCount > 0)
    {
        CheckMoves();
        CheckMatches(false);
        CountMatches();
        // [Loop Continue]
        goto J0x0D;
    }
    return;
}

function ClearCellGridDataFlag()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x30 [Loop If]
    if(i < 64)
    {
        CellGridData[i].isFlagged = false;
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function CountMatches()
{
    local int i;

    m_MatchCount = 0;
    i = 0;
    J0x0E:

    // End:0x46 [Loop If]
    if(i < 64)
    {
        // End:0x3C
        if(CellGridData[i].isFlagged)
        {
            m_MatchCount = m_MatchCount + 1;
        }
        i++;
        // [Loop Continue]
        goto J0x0E;
    }
    return;
}

function CheckMoves()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x4B [Loop If]
    if(i < 64)
    {
        // End:0x41
        if(CellGridData[i].isFlagged)
        {
            m_IsNewGamingBool = true;
            PushDownRow(i);
            CheckMatches(false);
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function PushDownRow(int Id)
{
    local int i, startpointID;
    local ButtonHandle temp1;
    local AnimTextureHandle TempAnim;
    local int CntScore;

    CntScore = 0;
    // End:0x1F0
    if(CellGridData[Id].isFlagged)
    {
        startpointID = GetCellGridID(0, CellGridData[Id].Y);
        // End:0x77
        if(!m_IsNewGamingBool)
        {
            TempAnim = CellGridData[Id].AnimLoc;
            TempAnim.ShowWindow();
            TempAnim.Play();
        }
        // End:0xB6
        if(CellGridData[Id] == CellGridData[startpointID])
        {
            Randomize(Id);
            CellGridData[Id].isFlagged = false;            
        }
        else
        {
            i = Id;
            J0xC1:

            // End:0x1F0 [Loop If]
            if(i >= startpointID)
            {
                // End:0x1B1
                if(i != startpointID)
                {
                    CellGridData[i].RV = CellGridData[i - 8].RV;
                    CellGridData[i].BtnTex = CellGridData[i - 8].BtnTex;
                    CellGridData[i].isFlagged = CellGridData[i - 8].isFlagged;
                    temp1 = CellGridData[i].ButtonLoc;
                    temp1.SetTexture(CellGridData[i].BtnTex, CellGridData[i].BtnTex, CellGridData[i].BtnTex $ "_over");                    
                }
                else
                {
                    // End:0x1DE
                    if(i == startpointID)
                    {
                        Randomize(i);
                        CellGridData[Id].isFlagged = false;
                    }
                }
                i = i - 8;
                // [Loop Continue]
                goto J0xC1;
            }
        }
    }
    m_IsNewGamingBool = false;
    return;
}

function Initialize()
{
    local int i;
    local ButtonHandle tempButton;
    local TextureHandle tempTexture;
    local AnimTextureHandle TempAnim;

    i = 0;
    J0x07:

    // End:0xAB [Loop If]
    if(i < 64)
    {
        tempButton = CellGridData[i].ButtonLoc;
        tempTexture = CellGridData[i].TextureLoc;
        TempAnim = CellGridData[i].AnimLoc;
        tempButton.HideWindow();
        tempTexture.HideWindow();
        TempAnim.SetLoopCount(1);
        TempAnim.HideWindow();
        TempAnim.Stop();
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    ResultTex.HideWindow();
    ProgressBar.Reset();
    ProgressBar.Stop();
    m_CurrentAnimID = 0;
    m_CellBtnStatus = 0;
    m_CellBtnID1 = 999;
    m_CellBtnID2 = 999;
    MG_BTNClose.SetNameText(GetSystemString(908));
    // End:0x156
    if(m_bUseJapanStyle != 1)
    {
        BtnRanking.SetNameText("");
        BtnRanking.SetTexture("", "", "");
        BtnRanking.HideWindow();
    }
    return;
}

function Randomize(int Id)
{
    local int RV;
    local ButtonHandle tempButton;

    RV = Rand(6);
    CellGridData[Id].RV = RV;
    CellGridData[Id].BtnTex = TX[RV];
    CellGridData[Id].isFlagged = false;
    tempButton = CellGridData[Id].ButtonLoc;
    tempButton.SetTexture(CellGridData[Id].BtnTex, CellGridData[Id].BtnTex, CellGridData[Id].BtnTex $ "_Over");
    tempButton.ShowWindow();
    return;
}

function CheckMatches(bool ClearButton)
{
    local int i;
    local ButtonHandle TempBtn;
    local TextureHandle TempTex;

    i = 0;
    J0x07:

    // End:0x55 [Loop If]
    if(i < 64)
    {
        TempTex = CellGridData[i].TextureLoc;
        TempTex.HideWindow();
        CellGridData[i].isFlagged = false;
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    i = 0;
    J0x5C:

    // End:0x53C [Loop If]
    if(i < 64)
    {
        // End:0x2D1
        if((CellGridData[i].X > 0) && CellGridData[i].X < (8 - 1))
        {
            // End:0x2D1
            if((CellGridData[i].RV == CellGridData[i - 8].RV) && CellGridData[i].RV == CellGridData[i + 8].RV)
            {
                CellGridData[i].isFlagged = true;
                CellGridData[i - 8].isFlagged = true;
                CellGridData[i + 8].isFlagged = true;
                TempTex = CellGridData[i].TextureLoc;
                TempTex.ShowWindow();
                TempTex = CellGridData[i - 8].TextureLoc;
                TempTex.ShowWindow();
                TempTex = CellGridData[i + 8].TextureLoc;
                TempTex.ShowWindow();
                // End:0x2D1
                if(ClearButton)
                {
                    TempBtn = CellGridData[i].ButtonLoc;
                    TempBtn.SetTexture("l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn");
                    TempBtn = CellGridData[i - 8].ButtonLoc;
                    TempBtn.SetTexture("l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn");
                    TempBtn = CellGridData[i + 8].ButtonLoc;
                    TempBtn.SetTexture("l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn");
                }
            }
        }
        // End:0x532
        if((CellGridData[i].Y > 0) && CellGridData[i].Y < (8 - 1))
        {
            // End:0x532
            if((CellGridData[i].RV == CellGridData[i - 1].RV) && CellGridData[i].RV == CellGridData[i + 1].RV)
            {
                CellGridData[i].isFlagged = true;
                CellGridData[i - 1].isFlagged = true;
                CellGridData[i + 1].isFlagged = true;
                TempTex = CellGridData[i].TextureLoc;
                TempTex.ShowWindow();
                TempTex = CellGridData[i - 1].TextureLoc;
                TempTex.ShowWindow();
                TempTex = CellGridData[i + 1].TextureLoc;
                TempTex.ShowWindow();
                // End:0x532
                if(ClearButton)
                {
                    TempBtn = CellGridData[i].ButtonLoc;
                    TempBtn.SetTexture("l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn");
                    TempBtn = CellGridData[i - 1].ButtonLoc;
                    TempBtn.SetTexture("l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn");
                    TempBtn = CellGridData[i + 1].ButtonLoc;
                    TempBtn.SetTexture("l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn");
                }
            }
        }
        i++;
        // [Loop Continue]
        goto J0x5C;
    }
    return;
}

function OnClickButton(string strID)
{
    local int BTNID, BTNID1, BTNID2;

    BTNID = Len(strID);
    // End:0x77
    if((BTNID == 13) && m_InGamingBool)
    {
        BTNID1 = int(Mid(strID, 10, 1));
        BTNID2 = int(Right(strID, 1));
        OnClickCellIcon(BTNID1, BTNID2);
        PlaySound("ItemSound3.minigame_click");
    }
    // End:0xDD
    if(strID == "MG_BTNChallenge")
    {
        // End:0xA4
        if(m_InGamingBool)
        {
            PauseGame();            
        }
        else
        {
            m_CurrentLevel = 0;
            m_TargetScore = 0;
            m_CurrentScore = 0;
            m_PauseBool = false;
            StartNewGame();
            PutNumberLevel(m_CurrentLevel);
            PutNumberScore(m_CurrentScore);
        }
    }
    // End:0x124
    if(strID == "MG_BTNClose")
    {
        // End:0x115
        if(m_InGamingBool)
        {
            // End:0x10C
            if(m_PauseBool)
            {
                PauseGame();
            }
            EndGame();            
        }
        else
        {
            Me.HideWindow();
        }
    }
    // End:0x180
    if((strID == "BtnRanking") && m_bUseJapanStyle == 1)
    {
        // End:0x16B
        if(MiniGameRankWnd.IsShowWindow())
        {
            MiniGameRankWnd.HideWindow();            
        }
        else
        {
            MiniGameRankWnd.ShowWindow();
            RequestBR_MinigameLoadScores();
        }
    }
    return;
}

function PauseGame()
{
    local int i;
    local ButtonHandle temp1;

    // End:0x79
    if(!m_PauseBool)
    {
        ProgressBar.Stop();
        i = 0;
        J0x21:

        // End:0x5C [Loop If]
        if(i < 64)
        {
            temp1 = CellGridData[i].ButtonLoc;
            temp1.HideWindow();
            i++;
            // [Loop Continue]
            goto J0x21;
        }
        MG_BTNChallenge.SetNameText(GetSystemString(1731));        
    }
    else
    {
        ProgressBar.Resume();
        i = 0;
        J0x8F:

        // End:0xCA [Loop If]
        if(i < 64)
        {
            temp1 = CellGridData[i].ButtonLoc;
            temp1.ShowWindow();
            i++;
            // [Loop Continue]
            goto J0x8F;
        }
        MG_BTNChallenge.SetNameText(GetSystemString(1073));
    }
    // End:0xF8
    if(m_PauseBool)
    {
        m_PauseBool = false;        
    }
    else
    {
        m_PauseBool = true;
    }
    return;
}

function OnHide()
{
    MG_BTNChallenge.SetNameText(GetSystemString(1728));
    // End:0x46
    if(m_InGamingBool && m_bUseJapanStyle == 1)
    {
        // End:0x46
        if(m_CurrentScore != 0)
        {
            RequestBR_MinigameInsertScore(m_CurrentScore);
        }
    }
    // End:0x67
    if(MiniGameRankWnd.IsShowWindow())
    {
        MiniGameRankWnd.HideWindow();
    }
    m_InGamingBool = false;
    Me.KillTimer(1260);
    Me.KillTimer(1261);
    Me.KillTimer(1262);
    Me.KillTimer(1263);
    Me.KillTimer(1264);
    return;
}

function StartNewGame()
{
    Initialize();
    m_InGamingBool = true;
    MG_BTNChallenge.DisableWindow();
    MG_BTNClose.SetNameText(GetSystemString(1732));
    ResultTex.SetAlpha(255, 0.0000000);
    ResultTex.SetTexture("l2ui_ct1.MiniGame_DF_Text_Ready");
    PlaySound("ItemSound3.minigame_start");
    ResultTex.ShowWindow();
    ResultTex.SetAlpha(0, 0.9000000);
    Me.SetTimer(1261, 1000);
    return;
}

function StartNewGameProc()
{
    ReadyCells();
    m_CurrentLevel = m_CurrentLevel + 1;
    PutNumberLevel(m_CurrentLevel);
    m_TargetScore = m_TargetScore + (GetTargetScore(m_CurrentLevel));
    ProgressBar.SetProgressTime(GetCurrentTimeLimit(m_CurrentLevel));
    ProgressBar.Start();
    return;
}

function RestartCurrentGame()
{
    Initialize();
    m_InGamingBool = false;
    MG_BTNClose.SetNameText(GetSystemString(908));
    MG_BTNChallenge.SetNameText(GetSystemString(1073));
    ResultTex.SetAlpha(255, 0.0000000);
    ResultTex.SetTexture("l2ui_ct1.MiniGame_DF_Text_Ready");
    PlaySound("ItemSound3.minigame_start");
    ResultTex.ShowWindow();
    ResultTex.SetAlpha(0, 0.9000000);
    Me.SetTimer(1261, 1000);
    return;
}

function OnTimeOver()
{
    m_InGamingBool = false;
    EndGamewithTimeOut();
    return;
}

function OnClickCellIcon(int X, int Y)
{
    local int Id;
    local TextureHandle TempTex;
    local ButtonHandle TempBtn;

    Id = GetCellGridID(X, Y);
    TempTex = CellGridData[Id].TextureLoc;
    TempBtn = CellGridData[Id].ButtonLoc;
    // End:0x87
    if(!TempTex.IsShowWindow() && m_CellBtnStatus == 0)
    {
        TempTex.ShowWindow();
        m_CellBtnStatus = 1;
        m_CellBtnID1 = Id;        
    }
    else
    {
        // End:0xCA
        if(TempTex.IsShowWindow() && m_CellBtnStatus == 1)
        {
            TempTex.HideWindow();
            m_CellBtnID1 = 999;
            m_CellBtnStatus = 0;            
        }
        else
        {
            // End:0x19B
            if(!TempTex.IsShowWindow() && m_CellBtnStatus == 1)
            {
                TempTex.ShowWindow();
                // End:0x160
                if(CheckSwappable(m_CellBtnID1, Id))
                {
                    TempTex = CellGridData[m_CellBtnID1].TextureLoc;
                    m_CellBtnStatus = 0;
                    m_CellBtnID1 = 999;
                    ProgressBar.Stop();
                    Me.SetTimer(1260, 300);                    
                }
                else
                {
                    TempTex.HideWindow();
                    TempTex = CellGridData[m_CellBtnID1].TextureLoc;
                    TempTex.HideWindow();
                    m_CellBtnStatus = 0;
                }
            }
        }
    }
    return;
}

function OnTimer(int TimerID)
{
    // End:0x8D
    if(TimerID == 1260)
    {
        // End:0x8D
        if(CheckMovesOnTimer())
        {
            m_InGamingBool = true;
            ProgressBar.Reset();
            // End:0x5B
            if(m_CurrentScore >= m_TargetScore)
            {
                Me.KillTimer(1260);
                StartLevelUp();                
            }
            else
            {
                Me.KillTimer(1260);
                ProgressBar.Reset();
                ProgressBar.Start();
            }
        }
    }
    // End:0x154
    if(TimerID == 1261)
    {
        ResultTex.SetAlpha(255, 0.0000000);
        ResultTex.SetTexture("l2ui_ct1.MiniGame_DF_Text_Start");
        PlaySound("ItemSound3.minigame_start");
        ResultTex.ShowWindow();
        ResultTex.SetAlpha(0, 0.9000000);
        Me.KillTimer(1261);
        Me.SetTimer(1262, 1000);
    }
    // End:0x1CC
    if(TimerID == 1262)
    {
        ResultTex.HideWindow();
        Me.KillTimer(1262);
        m_InGamingBool = true;
        MG_BTNChallenge.SetNameText(GetSystemString(1073));
        MG_BTNChallenge.EnableWindow();
        StartNewGameProc();
        MG_BTNChallenge.EnableWindow();
    }
    // End:0x2D7
    if(TimerID == 1263)
    {
        // End:0x2BE
        if(m_CurrentAnimID == 64)
        {
            // End:0x222
            if((m_CurrentScore != 0) && m_bUseJapanStyle == 1)
            {
                RequestBR_MinigameInsertScore(m_CurrentScore);
                // End:0x222
                if(MiniGameRankWnd.IsShowWindow())
                {
                    RequestBR_MinigameLoadScores();
                }
            }
            m_CurrentAnimID = 0;
            ResultTex.SetTexture("l2ui_ct1.MiniGame_DF_Text_GameOver");
            MG_BTNChallenge.SetNameText(GetSystemString(1728));
            MG_BTNClose.SetNameText(GetSystemString(908));
            Me.KillTimer(1263);
            m_InGamingBool = false;
            MG_BTNChallenge.EnableWindow();            
        }
        else
        {
            EndGameRemoveBlock(m_CurrentAnimID);
            m_CurrentAnimID = m_CurrentAnimID + 1;
        }
    }
    // End:0x3AD
    if(TimerID == 1264)
    {
        // End:0x394
        if(m_CurrentAnimID == 64)
        {
            m_CurrentAnimID = 0;
            ResultTex.SetTexture("l2ui_ct1.MiniGame_DF_Text_GameOver");
            MG_BTNChallenge.SetNameText(GetSystemString(1728));
            MG_BTNClose.SetNameText(GetSystemString(908));
            StartNewGame();
            Me.KillTimer(1264);
            m_InGamingBool = true;
            MG_BTNChallenge.EnableWindow();            
        }
        else
        {
            EndGameRemoveBlock(m_CurrentAnimID);
            m_CurrentAnimID = m_CurrentAnimID + 1;
        }
    }
    return;
}

function bool CheckMovesOnTimer()
{
    local int i;
    local bool B;

    m_InGamingBool = false;
    m_CountNumberofChains = 0;
    i = 0;
    J0x16:

    // End:0x114 [Loop If]
    if(i < 64)
    {
        // End:0xF3
        if(CellGridData[i].isFlagged)
        {
            m_CountNumberofChains = m_CountNumberofChains + 1;
            PushDownRow(i);
            PlaySound("ItemSound3.minigame_block_down");
            m_CurrentScore = m_CurrentScore + (2 * (m_CountNumberofChains - 2));
            PutNumberScore(m_CurrentScore);
            B = false;
            // End:0xD5
            if(m_CountNumberofChains > 2)
            {
                PlaySound("ItemSound3.minigame_break_combo");
            }
            ProgressBar.Reset();
            ProgressBar.Start();
        }
        // End:0x10A
        if(i == (64 - 1))
        {
            B = true;
        }
        i++;
        // [Loop Continue]
        goto J0x16;
    }
    m_CurrentScore = m_CurrentScore + 10;
    PutNumberScore(m_CurrentScore);
    PlaySound("ItemSound3.minigame_break_normal");
    // End:0x1A4
    if(B)
    {
        CheckMatches(false);
        CountMatches();
        // End:0x182
        if(m_MatchCount == 0)
        {
            B = true;            
        }
        else
        {
            m_CurrentScore = m_CurrentScore + 10;
            PutNumberScore(m_CurrentScore);
            B = false;
        }
    }
    return B;
    return;
}

function bool CheckSwappable(int ID1, int ID2)
{
    local bool returnSwappableBoolValue;
    local int rowcol;
    local MG1CellData tempCellGridData;
    local ButtonHandle temp1;

    returnSwappableBoolValue = false;
    rowcol = ID1 - ID2;
    // End:0x353
    if((((rowcol == 1) || rowcol == -1) || rowcol == 8) || rowcol == -8)
    {
        tempCellGridData = CellGridData[ID1];
        CellGridData[ID1].RV = CellGridData[ID2].RV;
        CellGridData[ID1].BtnTex = CellGridData[ID2].BtnTex;
        temp1 = CellGridData[ID1].ButtonLoc;
        temp1.SetTexture(CellGridData[ID1].BtnTex, CellGridData[ID1].BtnTex, CellGridData[ID1].BtnTex $ "_over");
        CellGridData[ID2].RV = tempCellGridData.RV;
        CellGridData[ID2].BtnTex = tempCellGridData.BtnTex;
        temp1 = CellGridData[ID2].ButtonLoc;
        temp1.SetTexture(CellGridData[ID2].BtnTex, CellGridData[ID2].BtnTex, CellGridData[ID2].BtnTex $ "_over");
        CheckMatches(true);
        CountMatches();
        // End:0x1E5
        if(m_MatchCount > 0)
        {
            returnSwappableBoolValue = true;
            PlaySound("ItemSound3.minigame_block_change");            
        }
        else
        {
            CellGridData[ID2].RV = CellGridData[ID1].RV;
            CellGridData[ID2].BtnTex = CellGridData[ID1].BtnTex;
            temp1 = CellGridData[ID2].ButtonLoc;
            temp1.SetTexture(CellGridData[ID2].BtnTex, CellGridData[ID2].BtnTex, CellGridData[ID2].BtnTex $ "_over");
            CellGridData[ID1].RV = tempCellGridData.RV;
            CellGridData[ID1].BtnTex = tempCellGridData.BtnTex;
            temp1 = CellGridData[ID1].ButtonLoc;
            temp1.SetTexture(CellGridData[ID1].BtnTex, CellGridData[ID1].BtnTex, CellGridData[ID1].BtnTex $ "_over");
            CheckMatches(false);
            CountMatches();
            PlaySound("ItemSound3.minigame_change_impossible");
        }
    }
    return returnSwappableBoolValue;
    return;
}

function int GetCellGridID(int X, int Y)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x5C [Loop If]
    if(i < 64)
    {
        // End:0x52
        if((CellGridData[i].X == X) && CellGridData[i].Y == Y)
        {
            return i;
            // [Explicit Break]
            goto J0x5C;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x5C:

    return;
}

function OnProgressTimeUp(string strID)
{
    // End:0x1D
    if(strID == "MG_Progress")
    {
        OnTimeOver();
    }
    return;
}

function OnTextureAnimEnd(AnimTextureHandle a_WindowHandle)
{
    a_WindowHandle.HideWindow();
    return;
}

function int GetCurrentTimeLimit(int CurrentLevel)
{
    local int TimeLimit;

    // End:0xD6
    if(CurrentLevel <= 10)
    {
        switch(CurrentLevel)
        {
            // End:0x25
            case 1:
                TimeLimit = 20000;
                // End:0xD3
                break;
            // End:0x38
            case 2:
                TimeLimit = 18000;
                // End:0xD3
                break;
            // End:0x4B
            case 3:
                TimeLimit = 16000;
                // End:0xD3
                break;
            // End:0x5E
            case 4:
                TimeLimit = 14000;
                // End:0xD3
                break;
            // End:0x71
            case 5:
                TimeLimit = 12000;
                // End:0xD3
                break;
            // End:0x84
            case 6:
                TimeLimit = 10000;
                // End:0xD3
                break;
            // End:0x97
            case 7:
                TimeLimit = 8000;
                // End:0xD3
                break;
            // End:0xAA
            case 8:
                TimeLimit = 6000;
                // End:0xD3
                break;
            // End:0xBD
            case 9:
                TimeLimit = 4000;
                // End:0xD3
                break;
            // End:0xD0
            case 10:
                TimeLimit = 3000;
                // End:0xD3
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        TimeLimit = 2000;
    }
    return TimeLimit;
    return;
}

function int GetTargetScore(int CurrentLevel)
{
    local int TargetScore;

    TargetScore = 300 * CurrentLevel;
    return TargetScore;
    return;
}

function EndGameRemoveBlock(int Id)
{
    local ButtonHandle temp1;

    temp1 = CellGridData[Id].ButtonLoc;
    m_InGamingBool = false;
    temp1.SetTexture("l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn", "l2ui_ct1.emptyBtn");
    MG_BTNChallenge.DisableWindow();
    return;
}

function StartLevelUp()
{
    ProcEndGameDefaultSetting("l2ui_ct1.MiniGame_DF_Text_Levelup");
    PlaySound("ItemSound3.minigame_start");
    Me.SetTimer(1264, 5);
    return;
}

function EndGame()
{
    Me.KillTimer(1261);
    Me.KillTimer(1262);
    ProcEndGameDefaultSetting("l2ui_ct1.MiniGame_DF_Text_GameOver");
    MG_BTNChallenge.SetNameText(GetSystemString(1728));
    MG_BTNClose.SetNameText(GetSystemString(908));
    Me.SetTimer(1263, 5);
    return;
}

function EndGamewithTimeOut()
{
    ProcEndGameDefaultSetting("l2ui_ct1.MiniGame_DF_Text_TimeOut");
    Me.SetTimer(1263, 5);
    return;
}

function ProcEndGameDefaultSetting(string SetTextureName)
{
    local int i;
    local TextureHandle temp1;

    // End:0x4D
    if(!m_PauseBool)
    {
        i = 0;
        J0x12:

        // End:0x4D [Loop If]
        if(i < 64)
        {
            temp1 = CellGridData[i].TextureLoc;
            temp1.HideWindow();
            i++;
            // [Loop Continue]
            goto J0x12;
        }
    }
    ProgressBar.Reset();
    ResultTex.SetAlpha(255, 0.0000000);
    ResultTex.SetTexture(SetTextureName);
    ResultTex.ShowWindow();
    m_InGamingBool = false;
    MG_BTNChallenge.DisableWindow();
    return;
}

function PutNumberLevel(int LevelNo)
{
    local string strtex, TempTex;
    local int strtexcnt, compcnt, i;

    TempTex = "";
    strtex = string(LevelNo);
    strtexcnt = Len(strtex);
    compcnt = 3 - strtexcnt;
    i = 1;
    J0x38:

    // End:0xA5 [Loop If]
    if(i <= compcnt)
    {
        Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("Minigame1wnd.TxtLevel_0" $ string(i), "l2ui_ct1.MiniGame_df_Text_Level_0");
        i++;
        // [Loop Continue]
        goto J0x38;
    }
    i = strtexcnt;
    J0xB0:

    // End:0x145 [Loop If]
    if(i > 0)
    {
        TempTex = Right(strtex, 1);
        strtex = TrimRight(strtex);
        Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("Minigame1wnd.TxtLevel_0" $ string(compcnt + i), "l2ui_ct1.MiniGame_df_Text_Level_" $ TempTex);
        i--;
        // [Loop Continue]
        goto J0xB0;
    }
    return;
}

function PutNumberScore(int LevelNo)
{
    local string strtex, TempTex;
    local int strtexcnt, compcnt, i;

    TempTex = "";
    strtex = string(LevelNo);
    strtexcnt = Len(strtex);
    compcnt = 6 - strtexcnt;
    i = 1;
    J0x38:

    // End:0xA5 [Loop If]
    if(i <= compcnt)
    {
        Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("Minigame1wnd.TxtScore_0" $ string(i), "l2ui_ct1.MiniGame_df_Text_Score_0");
        i++;
        // [Loop Continue]
        goto J0x38;
    }
    i = strtexcnt;
    J0xB0:

    // End:0x145 [Loop If]
    if(i > 0)
    {
        TempTex = Right(strtex, 1);
        strtex = TrimRight(strtex);
        Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTexture("Minigame1wnd.TxtScore_0" $ string(compcnt + i), "l2ui_ct1.MiniGame_df_Text_Score_" $ TempTex);
        i--;
        // [Loop Continue]
        goto J0xB0;
    }
    return;
}

function string TrimRight(string S)
{
    S = Left(S, Len(S) - 1);
    return S;
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("MiniGame1Wnd").HideWindow();
    return;
}
