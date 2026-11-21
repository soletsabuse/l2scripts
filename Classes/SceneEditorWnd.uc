class SceneEditorWnd extends UICommonAPI;

const UC_EXT = ".uc";
const PREV_DIR = "..";

var WindowHandle Me;
var ListBoxHandle lstFiles;
var EditBoxHandle editPath;
var EditBoxHandle editNear;
var EditBoxHandle editFar;
var EditBoxHandle editPlayRate;
var EditBoxHandle editVoiceOption;
var EditBoxHandle editSkipTo;
var EditBoxHandle editPlayTo;
var CheckBoxHandle ForcePlayCheckBox;
var CheckBoxHandle EscapableCheckBox;
var CheckBoxHandle ShowMyPCCheckBox;
var CheckBoxHandle ShowOtherPCsCheckBox;
var TextBoxHandle txtSceneDataFile;
var TextBoxHandle txtSceneDataIndex;
var EditBoxHandle editSceneTime;
var EditBoxHandle editScenePlayRate;
var EditBoxHandle editSceneDesc;
var WindowHandle Camera;
var WindowHandle Npc;
var WindowHandle pc;
var WindowHandle Music;
var WindowHandle SCREEN;
var WindowHandle CurrentData;
var PropertyControllerHandle ctlPropertyCAMERA;
var PropertyControllerHandle ctlPropertyNPC;
var PropertyControllerHandle ctlPropertyPC;
var PropertyControllerHandle ctlPropertyMUSIC;
var PropertyControllerHandle ctlPropertySCREEN;
var WindowHandle SceneCameraWnd;
var WindowHandle SceneNpcWnd;
var WindowHandle ScenePcWnd;
var WindowHandle SceneScreenWnd;
var WindowHandle SceneMusicWnd;
var SceneCameraCtrlHandle SceneCameraCtrl;
var SceneNpcCtrlHandle SceneNpcCtrl;
var ScenePcCtrlHandle ScenePcCtrl;
var SceneScreenCtrlHandle SceneScreenCtrl;
var SceneMusicCtrlHandle SceneMusicCtrl;
var array<WindowHandle> TimeLineItem;
var array<TextBoxHandle> TimeLineItem_Index;
var array<TextBoxHandle> TimeLineItem_Time;
var array<TextBoxHandle> TimeLineItem_Desc;
var array<TextureHandle> TimeLineItem_Outline;
var EditBoxHandle editAddSceneNo;
var EditBoxHandle editDeleteSceneNo;
var EditBoxHandle editSrcSceneNo;
var EditBoxHandle editDestSceneNo;
var string m_CurPath;
var string m_CurFileName;
var int m_CurIndex;
var int m_ShowStartIndex;
var int m_NumOfScene;
var array<string> TimeLineIndex;
var array<string> TimeLineTime;
var array<string> TimeLineDesc;

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(4500);
    RegisterEvent(4530);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x1D
    if(1 == 0)
    {
        Initialize();        
    }
    else
    {
        InitializeCOD();
    }
    initValue();
    InitControlItem();
    UpdatePath();
    Class'NWindow.SceneEditorAPI'.static.InitSceneEditorData();
    Class'NWindow.SceneEditorAPI'.static.AddScene(-1);
    txtSceneDataFile.SetText("New File");
    SetSceneDataIndex();
    return;
}

function OnShow()
{
    SceneFileModifyCheck();
    return;
}

function SceneFileModifyCheck(optional bool ShowNoNeedMsg)
{
    local bool isReload;

    isReload = Class'NWindow.SceneEditorAPI'.static.IsReloadSceneData();
    // End:0x8E
    if(isReload)
    {
        DialogSetID(3003);
        DialogSetDefaultOK();
        DialogShow(1, 0, "Scene files has been modified.       Do you wanna reload LineageSceneInfo.u?", string(self));        
    }
    else
    {
        // End:0xCC
        if(ShowNoNeedMsg)
        {
            DialogSetID(3333);
            DialogSetDefaultOK();
            DialogShow(1, 1, "바뀐 파일이 없습니다.", string(self));
        }
    }
    return;
}

function Initialize()
{
    local int i;

    Me = GetHandle("SceneEditorWnd");
    lstFiles = ListBoxHandle(GetHandle("SceneEditorWnd.FileManager.lstFiles"));
    editPath = EditBoxHandle(GetHandle("SceneEditorWnd.FileManager.editPath"));
    ForcePlayCheckBox = CheckBoxHandle(GetHandle("SceneEditorWnd.PlayManager.PlayModeBox"));
    EscapableCheckBox = CheckBoxHandle(GetHandle("SceneEditorWnd.PlayManager.EscapableBox"));
    ShowMyPCCheckBox = CheckBoxHandle(GetHandle("SceneEditorWnd.PlayManager.ShowMyPCBox"));
    ShowOtherPCsCheckBox = CheckBoxHandle(GetHandle("SceneEditorWnd.PlayManager.ShowOtherPCsBox"));
    editPlayRate = EditBoxHandle(GetHandle("SceneEditorWnd.PlayManager.editPlayRate"));
    editNear = EditBoxHandle(GetHandle("SceneEditorWnd.PlayManager.editNear"));
    editFar = EditBoxHandle(GetHandle("SceneEditorWnd.PlayManager.editFar"));
    editVoiceOption = EditBoxHandle(GetHandle("SceneEditorWnd.PlayManager.editVoiceOption"));
    editSkipTo = EditBoxHandle(GetHandle("SceneEditorWnd.PlayManager.editSkipTo"));
    editPlayTo = EditBoxHandle(GetHandle("SceneEditorWnd.PlayManager.editPlayTo"));
    txtSceneDataFile = TextBoxHandle(GetHandle("SceneEditorWnd.SceneDataEdit.txtSceneDataFile"));
    txtSceneDataIndex = TextBoxHandle(GetHandle("SceneEditorWnd.SceneDataEdit.txtSceneDataIndex"));
    editSceneTime = EditBoxHandle(GetHandle("SceneEditorWnd.SceneDataEdit.editSceneTime"));
    editScenePlayRate = EditBoxHandle(GetHandle("SceneEditorWnd.SceneDataEdit.editScenePlayRate"));
    editSceneDesc = EditBoxHandle(GetHandle("SceneEditorWnd.SceneDataEdit.editSceneDesc"));
    Camera = GetHandle("SceneEditorWnd.SceneDataEdit.CAMERA");
    Npc = GetHandle("SceneEditorWnd.SceneDataEdit.NPC");
    pc = GetHandle("SceneEditorWnd.SceneDataEdit.PC");
    Music = GetHandle("SceneEditorWnd.SceneDataEdit.MUSIC");
    SCREEN = GetHandle("SceneEditorWnd.SceneDataEdit.SCREEN");
    ctlPropertyCAMERA = PropertyControllerHandle(GetHandle("SceneEditorWnd.SceneDataEdit.CAMERA.ctlPropertyCAMERA"));
    ctlPropertyNPC = PropertyControllerHandle(GetHandle("SceneEditorWnd.SceneDataEdit.NPC.ctlPropertyNPC"));
    ctlPropertyPC = PropertyControllerHandle(GetHandle("SceneEditorWnd.SceneDataEdit.PC.ctlPropertyPC"));
    ctlPropertyMUSIC = PropertyControllerHandle(GetHandle("SceneEditorWnd.SceneDataEdit.MUSIC.ctlPropertyMUSIC"));
    ctlPropertySCREEN = PropertyControllerHandle(GetHandle("SceneEditorWnd.SceneDataEdit.SCREEN.ctlPropertySCREEN"));
    i = 0;
    J0x64B:

    // End:0x7EA [Loop If]
    if(i < 5)
    {
        TimeLineItem[i] = GetHandle("SceneEditorWnd.TimeLine.TimeLineItem" $ string(i));
        TimeLineItem_Index[i] = TextBoxHandle(GetHandle(("SceneEditorWnd.TimeLine.TimeLineItem" $ string(i)) $ ".Index"));
        TimeLineItem_Time[i] = TextBoxHandle(GetHandle(("SceneEditorWnd.TimeLine.TimeLineItem" $ string(i)) $ ".Time"));
        TimeLineItem_Desc[i] = TextBoxHandle(GetHandle(("SceneEditorWnd.TimeLine.TimeLineItem" $ string(i)) $ ".Desc"));
        TimeLineItem_Outline[i] = TextureHandle(GetHandle(("SceneEditorWnd.TimeLine.TimeLineItem" $ string(i)) $ ".BackTex_Outline"));
        ++i;
        // [Loop Continue]
        goto J0x64B;
    }
    editAddSceneNo = EditBoxHandle(GetHandle("SceneEditorWnd.TimeLine.editAddSceneNo"));
    editDeleteSceneNo = EditBoxHandle(GetHandle("SceneEditorWnd.TimeLine.editDeleteSceneNo"));
    editSrcSceneNo = EditBoxHandle(GetHandle("SceneEditorWnd.TimeLine.editSrcSceneNo"));
    editDestSceneNo = EditBoxHandle(GetHandle("SceneEditorWnd.TimeLine.editDestSceneNo"));
    return;
}

function InitializeCOD()
{
    local int i;

    Me = GetWindowHandle("SceneEditorWnd");
    lstFiles = GetListBoxHandle("SceneEditorWnd.FileManager.lstFiles");
    editPath = GetEditBoxHandle("SceneEditorWnd.FileManager.editPath");
    ForcePlayCheckBox = GetCheckBoxHandle("SceneEditorWnd.PlayModeBox");
    EscapableCheckBox = GetCheckBoxHandle("SceneEditorWnd.EscapableBox");
    ShowMyPCCheckBox = GetCheckBoxHandle("SceneEditorWnd.ShowMyPCBox");
    ShowOtherPCsCheckBox = GetCheckBoxHandle("SceneEditorWnd.ShowOtherPCsBox");
    editPlayRate = GetEditBoxHandle("SceneEditorWnd.PlayManager.editPlayRate");
    editNear = GetEditBoxHandle("SceneEditorWnd.PlayManager.editNear");
    editFar = GetEditBoxHandle("SceneEditorWnd.PlayManager.editFar");
    editVoiceOption = GetEditBoxHandle("SceneEditorWnd.PlayManager.editVoiceOption");
    editSkipTo = GetEditBoxHandle("SceneEditorWnd.PlayManager.editSkipTo");
    editPlayTo = GetEditBoxHandle("SceneEditorWnd.PlayManager.editPlayTo");
    txtSceneDataFile = GetTextBoxHandle("SceneEditorWnd.SceneDataEdit.txtSceneDataFile");
    txtSceneDataIndex = GetTextBoxHandle("SceneEditorWnd.SceneDataEdit.txtSceneDataIndex");
    editSceneTime = GetEditBoxHandle("SceneEditorWnd.SceneDataEdit.editSceneTime");
    editScenePlayRate = GetEditBoxHandle("SceneEditorWnd.SceneDataEdit.editScenePlayRate");
    editSceneDesc = GetEditBoxHandle("SceneEditorWnd.SceneDataEdit.editSceneDesc");
    Camera = GetWindowHandle("SceneEditorWnd.SceneDataEdit.CAMERA");
    Npc = GetWindowHandle("SceneEditorWnd.SceneDataEdit.NPC");
    pc = GetWindowHandle("SceneEditorWnd.SceneDataEdit.PC");
    Music = GetWindowHandle("SceneEditorWnd.SceneDataEdit.MUSIC");
    SCREEN = GetWindowHandle("SceneEditorWnd.SceneDataEdit.SCREEN");
    ctlPropertyCAMERA = GetPropertyControllerHandle("SceneEditorWnd.SceneDataEdit.CAMERA.ctlPropertyCAMERA");
    ctlPropertyNPC = GetPropertyControllerHandle("SceneEditorWnd.SceneDataEdit.NPC.ctlPropertyNPC");
    ctlPropertyPC = GetPropertyControllerHandle("SceneEditorWnd.SceneDataEdit.PC.ctlPropertyPC");
    ctlPropertyMUSIC = GetPropertyControllerHandle("SceneEditorWnd.SceneDataEdit.MUSIC.ctlPropertyMUSIC");
    ctlPropertySCREEN = GetPropertyControllerHandle("SceneEditorWnd.SceneDataEdit.SCREEN.ctlPropertySCREEN");
    i = 0;
    J0x5AD:

    // End:0x738 [Loop If]
    if(i < 5)
    {
        TimeLineItem[i] = GetWindowHandle("SceneEditorWnd.TimeLine.TimeLineItem" $ string(i));
        TimeLineItem_Index[i] = GetTextBoxHandle(("SceneEditorWnd.TimeLine.TimeLineItem" $ string(i)) $ ".Index");
        TimeLineItem_Time[i] = GetTextBoxHandle(("SceneEditorWnd.TimeLine.TimeLineItem" $ string(i)) $ ".Time");
        TimeLineItem_Desc[i] = GetTextBoxHandle(("SceneEditorWnd.TimeLine.TimeLineItem" $ string(i)) $ ".Desc");
        TimeLineItem_Outline[i] = GetTextureHandle(("SceneEditorWnd.TimeLine.TimeLineItem" $ string(i)) $ ".BackTex_Outline");
        ++i;
        // [Loop Continue]
        goto J0x5AD;
    }
    editAddSceneNo = GetEditBoxHandle("SceneEditorWnd.TimeLine.editAddSceneNo");
    editDeleteSceneNo = GetEditBoxHandle("SceneEditorWnd.TimeLine.editDeleteSceneNo");
    editSrcSceneNo = GetEditBoxHandle("SceneEditorWnd.TimeLine.editSrcSceneNo");
    editDestSceneNo = GetEditBoxHandle("SceneEditorWnd.TimeLine.editDestSceneNo");
    return;
}

function ResetIndex()
{
    m_CurIndex = -1;
    m_ShowStartIndex = 0;
    return;
}

function int GetRealIndex(int ShowIndex)
{
    return ShowIndex + m_ShowStartIndex;
    return;
}

function int GetShowIndex(int RealIndex)
{
    return RealIndex - m_ShowStartIndex;
    return;
}

function SetShowStartIndex(int Index)
{
    local int OldIndex;

    OldIndex = m_ShowStartIndex;
    m_ShowStartIndex = Index;
    // End:0x38
    if((m_ShowStartIndex + 4) >= m_NumOfScene)
    {
        m_ShowStartIndex = m_NumOfScene - 5;
    }
    // End:0x4A
    if(m_ShowStartIndex < 0)
    {
        m_ShowStartIndex = 0;
    }
    // End:0x70
    if(m_ShowStartIndex != OldIndex)
    {
        SetTimeLineItemText();
        SetOutlineTexture(GetShowIndex(m_CurIndex));
    }
    return;
}

function SetTimeLineItemText()
{
    local int i, RealIndex;

    RealIndex = m_ShowStartIndex;
    i = 0;
    J0x12:

    // End:0xEF [Loop If]
    if(i < 5)
    {
        // End:0x7E
        if(RealIndex >= m_NumOfScene)
        {
            TimeLineItem_Index[i].SetText("...");
            TimeLineItem_Time[i].SetText("...");
            TimeLineItem_Desc[i].SetText("...");            
        }
        else
        {
            TimeLineItem_Index[i].SetText(TimeLineIndex[RealIndex]);
            TimeLineItem_Time[i].SetText(TimeLineTime[RealIndex]);
            TimeLineItem_Desc[i].SetText(TimeLineDesc[RealIndex]);
        }
        ++RealIndex;
        ++i;
        // [Loop Continue]
        goto J0x12;
    }
    return;
}

function initValue()
{
    local int PathLength;

    editPlayRate.SetString(string(1.0000000));
    editNear.SetString(string(-1.0000000));
    editFar.SetString(string(-1.0000000));
    m_NumOfScene = 0;
    ResetIndex();
    Me.SetWindowTitle("Scene Editor");
    m_CurPath = GetOptionString("ScenePlayer", "DefaultPath");
    // End:0xF6
    if(Len(m_CurPath) < 1)
    {
        m_CurPath = GetSystemDir();
        PathLength = Len(m_CurPath);
        m_CurPath = Left(m_CurPath, PathLength - 6);
        m_CurPath = m_CurPath $ "LineageSceneInfo\\Classes\\";
    }
    editPath.SetString(m_CurPath);
    return;
}

function InitControlItem()
{
    SceneCameraWnd = Me.AddChildWnd(1);
    SceneCameraWnd.SetWindowSize(0, 0);
    SceneCameraWnd.SetBackTexture("");
    SceneCameraCtrl = SceneCameraCtrlHandle(SceneCameraWnd.AddChildWnd(38));
    // End:0xE3
    if(SceneCameraCtrl != none)
    {
        SceneCameraCtrl.SetWindowSize(0, 0);
        ctlPropertyCAMERA.SetProperty(SceneCameraCtrl.GetControlType(), SceneCameraCtrl);
        ctlPropertyCAMERA.SetGroupVisible("DefaultProperty", false);
        Camera.SetScrollHeight(ctlPropertyCAMERA.GetPropertyHeight());
        Camera.SetScrollPosition(0);
    }
    SceneNpcWnd = Me.AddChildWnd(1);
    SceneNpcWnd.SetWindowSize(0, 0);
    SceneNpcWnd.SetBackTexture("");
    SceneNpcCtrl = SceneNpcCtrlHandle(SceneNpcWnd.AddChildWnd(39));
    // End:0x1C6
    if(SceneNpcCtrl != none)
    {
        SceneNpcCtrl.SetWindowSize(0, 0);
        ctlPropertyNPC.SetProperty(SceneNpcCtrl.GetControlType(), SceneNpcCtrl);
        ctlPropertyNPC.SetGroupVisible("DefaultProperty", false);
        Npc.SetScrollHeight(ctlPropertyNPC.GetPropertyHeight());
        Npc.SetScrollPosition(0);
    }
    ScenePcWnd = Me.AddChildWnd(1);
    ScenePcWnd.SetWindowSize(0, 0);
    ScenePcWnd.SetBackTexture("");
    ScenePcCtrl = ScenePcCtrlHandle(ScenePcWnd.AddChildWnd(40));
    // End:0x2A9
    if(ScenePcCtrl != none)
    {
        ScenePcCtrl.SetWindowSize(0, 0);
        ctlPropertyPC.SetProperty(ScenePcCtrl.GetControlType(), ScenePcCtrl);
        ctlPropertyPC.SetGroupVisible("DefaultProperty", false);
        pc.SetScrollHeight(ctlPropertyPC.GetPropertyHeight());
        pc.SetScrollPosition(0);
    }
    SceneMusicWnd = Me.AddChildWnd(1);
    SceneMusicWnd.SetWindowSize(0, 0);
    SceneMusicWnd.SetBackTexture("");
    SceneMusicCtrl = SceneMusicCtrlHandle(SceneMusicWnd.AddChildWnd(42));
    // End:0x38C
    if(SceneMusicCtrl != none)
    {
        SceneMusicCtrl.SetWindowSize(0, 0);
        ctlPropertyMUSIC.SetProperty(SceneMusicCtrl.GetControlType(), SceneMusicCtrl);
        ctlPropertyMUSIC.SetGroupVisible("DefaultProperty", false);
        Music.SetScrollHeight(ctlPropertyMUSIC.GetPropertyHeight());
        Music.SetScrollPosition(0);
    }
    SceneScreenWnd = Me.AddChildWnd(1);
    SceneScreenWnd.SetWindowSize(0, 0);
    SceneScreenWnd.SetBackTexture("");
    SceneScreenCtrl = SceneScreenCtrlHandle(SceneScreenWnd.AddChildWnd(41));
    // End:0x46F
    if(SceneScreenCtrl != none)
    {
        SceneScreenCtrl.SetWindowSize(0, 0);
        ctlPropertySCREEN.SetProperty(SceneScreenCtrl.GetControlType(), SceneScreenCtrl);
        ctlPropertySCREEN.SetGroupVisible("DefaultProperty", false);
        SCREEN.SetScrollHeight(ctlPropertySCREEN.GetPropertyHeight());
        SCREEN.SetScrollPosition(0);
    }
    return;
}

function OnPropertyControllerResize(PropertyControllerHandle a_PropertyHandle, int a_Height)
{
    a_Height += 50;
    // End:0x2F
    if(a_PropertyHandle == ctlPropertyCAMERA)
    {
        Camera.SetScrollHeight(a_Height);        
    }
    else
    {
        // End:0x55
        if(a_PropertyHandle == ctlPropertyNPC)
        {
            Npc.SetScrollHeight(a_Height);            
        }
        else
        {
            // End:0x7B
            if(a_PropertyHandle == ctlPropertyPC)
            {
                pc.SetScrollHeight(a_Height);                
            }
            else
            {
                // End:0xA1
                if(a_PropertyHandle == ctlPropertyMUSIC)
                {
                    Music.SetScrollHeight(a_Height);                    
                }
                else
                {
                    // End:0xC4
                    if(a_PropertyHandle == ctlPropertySCREEN)
                    {
                        SCREEN.SetScrollHeight(a_Height);
                    }
                }
            }
        }
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    local string Filename;
    local bool Success, bForceToPlay, bEscapable, bShowMyPC, bShowOtherPCs;

    local float NearPlane, FarPlane;

    // End:0x1D
    if(Event_ID == 4500)
    {
        HandleSceneListUpdate(param);        
    }
    else
    {
        // End:0x3A
        if(Event_ID == 4530)
        {
            UpdateTimeLine(param);            
        }
        else
        {
            // End:0x359
            if(Event_ID == 1710)
            {
                // End:0x359
                if(DialogIsMine())
                {
                    // End:0xDF
                    if((DialogGetID()) == 1001)
                    {
                        Filename = DialogGetString();
                        // End:0x7D
                        if(Len(Filename) < 1)
                        {
                            return;
                        }
                        Class'NWindow.SceneEditorAPI'.static.InitSceneEditorData();
                        Class'NWindow.SceneEditorAPI'.static.LoadSceneData(Filename);
                        ResetIndex();
                        SetOutlineTexture(-1);
                        m_CurFileName = Filename;
                        txtSceneDataFile.SetText(Filename);
                        SetSceneDataIndex();
                        UpdatePath();                        
                    }
                    else
                    {
                        // End:0x2CC
                        if((DialogGetID()) == 2002)
                        {
                            Filename = DialogGetString();
                            // End:0x10A
                            if(Len(Filename) < 1)
                            {
                                return;
                            }
                            bForceToPlay = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("SceneEditorWnd.PlayModeBox");
                            bEscapable = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("SceneEditorWnd.EscapableBox");
                            bShowMyPC = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("SceneEditorWnd.ShowMyPCBox");
                            bShowOtherPCs = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("SceneEditorWnd.ShowOtherPCsBox");
                            NearPlane = float(editNear.GetString());
                            FarPlane = float(editFar.GetString());
                            Success = Class'NWindow.SceneEditorAPI'.static.SaveSceneData(Filename, m_CurPath, bForceToPlay, bEscapable, bShowMyPC, bShowOtherPCs, 1.0000000, NearPlane, FarPlane);
                            // End:0x296
                            if(Success)
                            {
                                DialogSetID(2222);
                                DialogSetDefaultOK();
                                DialogShow(1, 1, "저장 성공 - " $ Filename, string(self));
                                m_CurFileName = Filename;                                
                            }
                            else
                            {
                                DialogSetID(2222);
                                DialogSetDefaultOK();
                                DialogShow(1, 1, "저장 실패 - " $ Filename, string(self));
                            }                            
                        }
                        else
                        {
                            // End:0x2EE
                            if((DialogGetID()) == 3003)
                            {
                                Class'NWindow.SceneEditorAPI'.static.ReloadSceneData();                                
                            }
                            else
                            {
                                // End:0x359
                                if((DialogGetID()) == 4004)
                                {
                                    Class'NWindow.SceneEditorAPI'.static.InitSceneEditorData();
                                    Class'NWindow.SceneEditorAPI'.static.AddScene(-1);
                                    ResetIndex();
                                    SetOutlineTexture(-1);
                                    m_CurFileName = "";
                                    txtSceneDataFile.SetText("New File");
                                    SetSceneDataIndex();
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

function UpdateTimeLine(string param)
{
    local int ShowIndex, Index, Time;
    local string Desc;
    local float PlayRate;

    ParseInt(param, "Index", Index);
    ParseInt(param, "Time", Time);
    ParseString(param, "Desc", Desc);
    ParseFloat(param, "PlayRate", PlayRate);
    TimeLineIndex[Index] = string(Index);
    TimeLineTime[Index] = string(Time);
    TimeLineDesc[Index] = Desc;
    ShowIndex = GetShowIndex(Index);
    // End:0xF4
    if((0 <= ShowIndex) && ShowIndex < 5)
    {
        TimeLineItem_Time[ShowIndex].SetText(string(Time));
        TimeLineItem_Desc[ShowIndex].SetText(Desc);
    }
    return;
}

function SetOutlineTexture(int Index)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x94 [Loop If]
    if(i < 5)
    {
        // End:0x5A
        if(i == Index)
        {
            TimeLineItem_Outline[i].SetTexture("L2UI_ch3.Etc.Menu_Outline_Over");
            // [Explicit Continue]
            goto J0x8A;
        }
        TimeLineItem_Outline[i].SetTexture("L2UI_ch3.Etc.Menu_Outline");
        J0x8A:

        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local int i, ShowIndex;

    ShowIndex = -1;
    i = 0;
    J0x12:

    // End:0x4B [Loop If]
    if(i < 5)
    {
        // End:0x41
        if(a_WindowHandle == TimeLineItem[i])
        {
            ShowIndex = i;
            // [Explicit Break]
            goto J0x4B;
        }
        ++i;
        // [Loop Continue]
        goto J0x12;
    }
    J0x4B:

    // End:0x58
    if(ShowIndex < 0)
    {
        return;
    }
    // End:0x6F
    if((GetRealIndex(ShowIndex)) >= m_NumOfScene)
    {
        return;
    }
    SceneDataSave();
    SetOutlineTexture(ShowIndex);
    m_CurIndex = GetRealIndex(ShowIndex);
    SceneDataUpdate();
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x1A
        case "btnGo":
            OnBtnGoClick();
            // End:0x155
            break;
        // End:0x2E
        case "btnNew":
            OnbtnNewClick();
            // End:0x155
            break;
        // End:0x43
        case "btnLoad":
            OnbtnLoadClick();
            // End:0x155
            break;
        // End:0x5A
        case "btnReload":
            OnbtnReloadClick();
            // End:0x155
            break;
        // End:0x6F
        case "btnSave":
            OnbtnSaveClick();
            // End:0x155
            break;
        // End:0x84
        case "btnPlay":
            OnbtnPlayClick();
            // End:0x155
            break;
        // End:0x98
        case "btnAdd":
            OnBtnAddClick();
            // End:0x155
            break;
        // End:0xAF
        case "btnDelete":
            OnBtnDeleteClick();
            // End:0x155
            break;
        // End:0xC4
        case "btnCopy":
            OnBtnCopyClick();
            // End:0x155
            break;
        // End:0xE8
        case "btnTimeLinePre":
            SetShowStartIndex(m_ShowStartIndex - 1);
            // End:0x155
            break;
        // End:0x10D
        case "btnTimeLineNext":
            SetShowStartIndex(m_ShowStartIndex + 1);
            // End:0x155
            break;
        // End:0x12C
        case "btnTimeLineFirst":
            SetShowStartIndex(0);
            // End:0x155
            break;
        // End:0x152
        case "btnTimeLineLast":
            SetShowStartIndex(m_NumOfScene - 4);
            // End:0x155
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnCompleteEditBox(string strID)
{
    switch(strID)
    {
        // End:0x19
        case "editSceneTime":
        // End:0x2B
        case "editSceneDesc":
        // End:0x4A
        case "editScenePlayRate":
            SceneDataSave();
            // End:0x63
            break;
        // End:0x60
        case "editPath":
            OnBtnGoClick();
            // End:0x63
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnBtnGoClick()
{
    m_CurPath = editPath.GetString();
    UpdatePath();
    return;
}

function OnbtnNewClick()
{
    DialogSetID(4004);
    DialogSetDefaultOK();
    DialogShow(1, 0, "현재 수정중인 사항이 사라집니다. 계속하시겠습니까?", string(self));
    return;
}

function OnbtnLoadClick()
{
    local string Filename;

    Filename = lstFiles.GetSelectedString();
    Filename = Left(Filename, Len(Filename) - 3);
    DialogSetEditBoxMaxLength(100);
    DialogSetID(1001);
    DialogSetDefaultOK();
    DialogShow(1, 2, "Input Scene Name.", string(self));
    DialogSetString(Filename);
    return;
}

function OnbtnReloadClick()
{
    SceneFileModifyCheck(true);
    return;
}

function OnbtnSaveClick()
{
    SceneDataSave();
    DialogSetEditBoxMaxLength(100);
    DialogSetID(2002);
    DialogSetDefaultOK();
    DialogShow(1, 2, "Input Scene Name.", string(self));
    DialogSetString(m_CurFileName);
    return;
}

function OnbtnPlayClick()
{
    local string tmp;
    local int SkipTo, PlayTo, VoiceOption;
    local bool bShowInfo, bReShow, bForceToPlay, bEscapable, bShowMyPC, bShowOtherPCs;

    local float PlayRate, NearClippingPlane, FarClippingPlane;

    SceneDataSave();
    tmp = editSkipTo.GetString();
    // End:0x38
    if(Len(tmp) > 0)
    {
        SkipTo = int(tmp);        
    }
    else
    {
        SkipTo = -1;
    }
    tmp = editPlayTo.GetString();
    // End:0x75
    if(Len(tmp) > 0)
    {
        PlayTo = int(tmp);        
    }
    else
    {
        PlayTo = -1;
    }
    // End:0xB8
    if(PlayTo < 0)
    {
        DialogShow(1, 1, "어디까지 플레이 하실 건가여?", string(self));
        return;
    }
    tmp = editVoiceOption.GetString();
    // End:0xEA
    if(Len(tmp) > 0)
    {
        VoiceOption = int(tmp);        
    }
    else
    {
        VoiceOption = -1;
    }
    bForceToPlay = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("SceneEditorWnd.PlayModeBox");
    bEscapable = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("SceneEditorWnd.EscapableBox");
    bShowMyPC = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("SceneEditorWnd.ShowMyPCBox");
    bShowOtherPCs = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("SceneEditorWnd.ShowOtherPCsBox");
    PlayRate = float(editPlayRate.GetString());
    NearClippingPlane = float(editNear.GetString());
    FarClippingPlane = float(editFar.GetString());
    Class'NWindow.SceneEditorAPI'.static.SetSceneInfoAttribute(bForceToPlay, bEscapable, bShowMyPC, bShowOtherPCs, PlayRate, NearClippingPlane, FarClippingPlane);
    bShowInfo = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("SceneEditorWnd.PlayManager.InfoBox");
    bReShow = Class'NWindow.UIAPI_CHECKBOX'.static.IsChecked("SceneEditorWnd.PlayManager.ReShow");
    Class'NWindow.SceneEditorAPI'.static.PlayScene(SkipTo, PlayTo, VoiceOption, bShowInfo, bReShow);
    return;
}

function OnBtnAddClick()
{
    local string tmp;
    local int Index, OldNumOfScene, OldCurIndex;

    OldNumOfScene = m_NumOfScene;
    SceneDataSave();
    tmp = editAddSceneNo.GetString();
    // End:0x43
    if(Len(tmp) > 0)
    {
        Index = int(tmp);        
    }
    else
    {
        Index = -1;
    }
    Class'NWindow.SceneEditorAPI'.static.AddScene(Index);
    // End:0x73
    if(m_NumOfScene == OldNumOfScene)
    {
        return;
    }
    OldCurIndex = m_CurIndex;
    // End:0x9E
    if(Index == -1)
    {
        m_CurIndex = m_NumOfScene - 1;        
    }
    else
    {
        m_CurIndex = Index;
    }
    SceneDataUpdate();
    // End:0xE1
    if((m_CurIndex < m_ShowStartIndex) || (m_ShowStartIndex + 4) < m_CurIndex)
    {
        SetShowStartIndex(m_CurIndex);        
    }
    else
    {
        // End:0x101
        if(m_CurIndex != OldCurIndex)
        {
            SetOutlineTexture(GetShowIndex(m_CurIndex));
        }
    }
    return;
}

function OnBtnDeleteClick()
{
    local string tmp;
    local int Index;

    SceneDataSave();
    tmp = editDeleteSceneNo.GetString();
    // End:0x38
    if(Len(tmp) > 0)
    {
        Index = int(tmp);        
    }
    else
    {
        return;
    }
    Class'NWindow.SceneEditorAPI'.static.DeleteScene(Index);
    // End:0x64
    if(Index < m_CurIndex)
    {
        --m_CurIndex;
    }
    // End:0x92
    if(m_CurIndex >= m_NumOfScene)
    {
        m_CurIndex = m_NumOfScene - 1;
        SetOutlineTexture(GetShowIndex(m_CurIndex));
    }
    // End:0xB2
    if(Index < m_ShowStartIndex)
    {
        SetShowStartIndex(m_ShowStartIndex - 1);        
    }
    else
    {
        SetShowStartIndex(m_ShowStartIndex);
    }
    SceneDataUpdate();
    return;
}

function OnBtnCopyClick()
{
    local string tmp;
    local int SrcIndex, DestIndex, OldNumOfScene, OldCurIndex;

    OldNumOfScene = m_NumOfScene;
    SceneDataSave();
    tmp = editSrcSceneNo.GetString();
    // End:0x43
    if(Len(tmp) > 0)
    {
        SrcIndex = int(tmp);        
    }
    else
    {
        return;
    }
    tmp = "";
    tmp = editDestSceneNo.GetString();
    // End:0x7F
    if(Len(tmp) > 0)
    {
        DestIndex = int(tmp);        
    }
    else
    {
        return;
    }
    // End:0x9B
    if(DestIndex > m_NumOfScene)
    {
        DestIndex = m_NumOfScene;
    }
    Class'NWindow.SceneEditorAPI'.static.CopyScene(SrcIndex, DestIndex);
    // End:0xC5
    if(m_NumOfScene == OldNumOfScene)
    {
        return;
    }
    OldCurIndex = m_CurIndex;
    m_CurIndex = DestIndex;
    SceneDataUpdate();
    // End:0x113
    if((m_CurIndex < m_ShowStartIndex) || (m_ShowStartIndex + 4) < m_CurIndex)
    {
        SetShowStartIndex(m_CurIndex);        
    }
    else
    {
        // End:0x133
        if(m_CurIndex != OldCurIndex)
        {
            SetOutlineTexture(GetShowIndex(m_CurIndex));
        }
    }
    return;
}

function UpdatePath()
{
    // End:0x2F
    if((Len(m_CurPath) > 0) && Right(m_CurPath, 1) != "\\")
    {
        m_CurPath = m_CurPath $ "\\";
    }
    SetOptionString("ScenePlayer", "DefaultPath", m_CurPath);
    editPath.SetString(m_CurPath);
    UpdateFileList();
    return;
}

function UpdateFileList()
{
    local int idx;
    local Color C;
    local array<string> FileList, DirList;
    local array<DriveInfo> DriveList;

    lstFiles.Clear();
    C.R = byte(255);
    C.G = byte(255);
    C.B = 150;
    // End:0x93
    if(Len(m_CurPath) < 1)
    {
        DriveList = GetDrivesInfoList();
        idx = 0;
        J0x5A:

        // End:0x90 [Loop If]
        if(idx < DriveList.Length)
        {
            DirList[idx] = DriveList[idx].driveChar;
            ++idx;
            // [Loop Continue]
            goto J0x5A;
        }        
    }
    else
    {
        lstFiles.AddStringWithData("..", C, 1);
        GetDirList(DirList, m_CurPath);
    }
    idx = 0;
    J0xC3:

    // End:0xFD [Loop If]
    if(idx < DirList.Length)
    {
        lstFiles.AddStringWithData(DirList[idx], C, 1);
        ++idx;
        // [Loop Continue]
        goto J0xC3;
    }
    GetFileList(FileList, m_CurPath, ".uc");
    idx = 0;
    J0x119:

    // End:0x1C2 [Loop If]
    if(idx < FileList.Length)
    {
        // End:0x171
        if(FileList[idx] == (m_CurFileName $ ".uc"))
        {
            C.R = byte(255);
            C.G = 0;
            C.B = 0;            
        }
        else
        {
            C.R = 220;
            C.G = 220;
            C.B = 220;
        }
        lstFiles.AddStringWithData(FileList[idx], C, 0);
        ++idx;
        // [Loop Continue]
        goto J0x119;
    }
    return;
}

function OnDBClickListBoxItem(string strID, int SelectedIndex)
{
    local string DirName;
    local int IsDir;

    switch(strID)
    {
        // End:0x9A
        case "lstFiles":
            IsDir = lstFiles.GetSelectedItemData();
            // End:0x86
            if(IsDir == 1)
            {
                DirName = lstFiles.GetSelectedString();
                // End:0x6B
                if(DirName == "..")
                {
                    m_CurPath = GetParentDirectory(m_CurPath);                    
                }
                else
                {
                    m_CurPath = m_CurPath $ DirName;
                }
                UpdatePath();                
            }
            else
            {
                // End:0x97
                if(IsDir == 0)
                {
                    OnbtnLoadClick();
                }
            }
            // End:0x9D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function string GetParentDirectory(string Path)
{
    local array<string> DirList;
    local int Count, idx;
    local string NewPath;

    // End:0x13
    if(Len(Path) < 1)
    {
        return NewPath;
    }
    // End:0x3A
    if(Right(Path, 1) == "\\")
    {
        Path = Left(Path, Len(Path) - 1);
    }
    Count = Split(Path, "\\", DirList);
    // End:0x61
    if(Count == 1)
    {
        return "";
    }
    idx = 0;
    J0x68:

    // End:0xA1 [Loop If]
    if(idx < (Count - 1))
    {
        NewPath = (NewPath $ DirList[idx]) $ "\\";
        ++idx;
        // [Loop Continue]
        goto J0x68;
    }
    return NewPath;
    return;
}

function HandleSceneListUpdate(string param)
{
    local int TotalCount, Index, Time;
    local string Desc, ParamString;
    local int i, bNew, ForceToPlay, Escapable, ShowMyPC, ShowOtherPCs;

    local float PlayRate, SceneItemPlayRate, NearClippingPlane, FarClippingPlane;
    local string tempStr;

    ParseInt(param, "IsNew", bNew);
    // End:0x22E
    if(bNew > 0)
    {
        ParseInt(param, "IsForceToPlay", ForceToPlay);
        // End:0x5F
        if(ForceToPlay > 0)
        {
            ForcePlayCheckBox.SetCheck(true);            
        }
        else
        {
            ForcePlayCheckBox.SetCheck(false);
        }
        ParseInt(param, "IsEscapable", Escapable);
        // End:0xAA
        if(Escapable > 0)
        {
            EscapableCheckBox.SetCheck(true);            
        }
        else
        {
            EscapableCheckBox.SetCheck(false);
        }
        ParseInt(param, "IsShowMyPC", ShowMyPC);
        // End:0xF4
        if(ShowMyPC > 0)
        {
            ShowMyPCCheckBox.SetCheck(true);            
        }
        else
        {
            ShowMyPCCheckBox.SetCheck(false);
        }
        ParseInt(param, "IsShowOtherPCs", ShowOtherPCs);
        // End:0x142
        if(ShowOtherPCs > 0)
        {
            ShowOtherPCsCheckBox.SetCheck(true);            
        }
        else
        {
            ShowOtherPCsCheckBox.SetCheck(false);
        }
        ParseFloat(param, "PlayRate", PlayRate);
        // End:0x186
        if(PlayRate <= 0.0000000)
        {
            PlayRate = 1.0000000;
        }
        tempStr = string(PlayRate);
        editPlayRate.SetString(tempStr);
        ParseFloat(param, "NearClippingPlane", NearClippingPlane);
        tempStr = string(NearClippingPlane);
        editNear.SetString(tempStr);
        ParseFloat(param, "FarClippingPlane", FarClippingPlane);
        tempStr = string(FarClippingPlane);
        editFar.SetString(tempStr);
    }
    ParseInt(param, "TotalCount", TotalCount);
    // End:0x257
    if(TotalCount < 1)
    {
        return;
    }
    m_NumOfScene = TotalCount;
    TimeLineIndex.Length = m_NumOfScene;
    TimeLineTime.Length = m_NumOfScene;
    TimeLineDesc.Length = m_NumOfScene;
    i = 0;
    J0x28D:

    // End:0x2D0 [Loop If]
    if(i < m_NumOfScene)
    {
        TimeLineIndex[i] = "";
        TimeLineTime[i] = "";
        TimeLineDesc[i] = "";
        ++i;
        // [Loop Continue]
        goto J0x28D;
    }
    i = 0;
    J0x2D7:

    // End:0x3CC [Loop If]
    if(i < TotalCount)
    {
        Index = i;
        Time = 0;
        ParamString = "Time" $ string(i);
        ParseInt(param, ParamString, Time);
        Desc = "";
        ParamString = "Desc" $ string(i);
        ParseString(param, ParamString, Desc);
        ParamString = "SceneItemPlayRate" $ string(i);
        ParseFloat(param, ParamString, SceneItemPlayRate);
        TimeLineIndex[i] = string(Index);
        TimeLineTime[i] = string(Time);
        TimeLineDesc[i] = Desc;
        ++i;
        // [Loop Continue]
        goto J0x2D7;
    }
    SetTimeLineItemText();
    editPlayTo.SetString(string(m_NumOfScene - 1));
    return;
}

function SetSceneDataIndex()
{
    local string InfoText;
    local Color C;

    // End:0x50
    if(m_CurIndex < 0)
    {
        InfoText = "No Scene Selected";
        C.R = byte(255);
        C.G = 0;
        C.B = 0;        
    }
    else
    {
        InfoText = "Scene " $ string(m_CurIndex);
        C.R = byte(255);
        C.G = byte(255);
        C.B = byte(255);
    }
    txtSceneDataIndex.SetTextColor(C);
    txtSceneDataIndex.SetText(InfoText);
    return;
}

function SceneDataUpdate()
{
    local int Time;
    local string Desc;
    local float PlayRate;

    SetSceneDataIndex();
    // End:0x4F
    if(m_CurIndex < 0)
    {
        editSceneTime.SetString("N/A");
        editSceneDesc.SetString("N/A");
        editScenePlayRate.SetString("N/A");
        return;
    }
    Class'NWindow.SceneEditorAPI'.static.GetCurSceneTimeAndDesc(m_CurIndex, Time, Desc);
    editSceneTime.SetString(string(Time));
    editSceneDesc.SetString(Desc);
    Class'NWindow.SceneEditorAPI'.static.GetCurScenePlayRate(m_CurIndex, PlayRate);
    editScenePlayRate.SetString(string(PlayRate));
    // End:0x157
    if(SceneCameraCtrl != none)
    {
        SceneCameraCtrl.UpdateCameraData(m_CurIndex);
        ctlPropertyCAMERA.SetProperty(SceneCameraCtrl.GetControlType(), SceneCameraCtrl);
        ctlPropertyCAMERA.SetGroupVisible("DefaultProperty", false);
        Camera.SetScrollHeight(ctlPropertyCAMERA.GetPropertyHeight());
        Camera.SetScrollPosition(0);
    }
    // End:0x1E8
    if(SceneNpcCtrl != none)
    {
        SceneNpcCtrl.UpdateNpcData(m_CurIndex);
        ctlPropertyNPC.SetProperty(SceneNpcCtrl.GetControlType(), SceneNpcCtrl);
        ctlPropertyNPC.SetGroupVisible("DefaultProperty", false);
        Npc.SetScrollHeight(ctlPropertyNPC.GetPropertyHeight());
        Npc.SetScrollPosition(0);
    }
    // End:0x279
    if(ScenePcCtrl != none)
    {
        ScenePcCtrl.UpdatePcData(m_CurIndex);
        ctlPropertyPC.SetProperty(ScenePcCtrl.GetControlType(), ScenePcCtrl);
        ctlPropertyPC.SetGroupVisible("DefaultProperty", false);
        pc.SetScrollHeight(ctlPropertyPC.GetPropertyHeight());
        pc.SetScrollPosition(0);
    }
    // End:0x30A
    if(SceneMusicCtrl != none)
    {
        SceneMusicCtrl.UpdateMusicData(m_CurIndex);
        ctlPropertyMUSIC.SetProperty(SceneMusicCtrl.GetControlType(), SceneMusicCtrl);
        ctlPropertyMUSIC.SetGroupVisible("DefaultProperty", false);
        Music.SetScrollHeight(ctlPropertyMUSIC.GetPropertyHeight());
        Music.SetScrollPosition(0);
    }
    // End:0x39B
    if(SceneScreenCtrl != none)
    {
        SceneScreenCtrl.UpdateScreenData(m_CurIndex);
        ctlPropertySCREEN.SetProperty(SceneScreenCtrl.GetControlType(), SceneScreenCtrl);
        ctlPropertySCREEN.SetGroupVisible("DefaultProperty", false);
        SCREEN.SetScrollHeight(ctlPropertySCREEN.GetPropertyHeight());
        SCREEN.SetScrollPosition(0);
    }
    return;
}

function SceneDataSave()
{
    local int Time, OldTime, DeltaTime;
    local string tempStr, Desc;
    local float PlayRate;

    // End:0x0D
    if(m_CurIndex < 0)
    {
        return;
    }
    Class'NWindow.SceneEditorAPI'.static.GetCurSceneTimeAndDesc(m_CurIndex, OldTime, Desc);
    tempStr = editSceneTime.GetString();
    Time = int(tempStr);
    tempStr = editScenePlayRate.GetString();
    PlayRate = float(tempStr);
    Desc = editSceneDesc.GetString();
    Class'NWindow.SceneEditorAPI'.static.SaveCurSceneTimeAndDesc(m_CurIndex, Time, Desc, PlayRate);
    DeltaTime = Time - OldTime;
    AllSceneTimeUpdate(DeltaTime);
    // End:0xE3
    if(SceneCameraCtrl != none)
    {
        SceneCameraCtrl.SaveCameraData(m_CurIndex);
    }
    // End:0x102
    if(SceneNpcCtrl != none)
    {
        SceneNpcCtrl.SaveNpcData(m_CurIndex);
    }
    // End:0x121
    if(ScenePcCtrl != none)
    {
        ScenePcCtrl.SavePcData(m_CurIndex);
    }
    // End:0x140
    if(SceneMusicCtrl != none)
    {
        SceneMusicCtrl.SaveMusicData(m_CurIndex);
    }
    // End:0x15F
    if(SceneScreenCtrl != none)
    {
        SceneScreenCtrl.SaveScreenData(m_CurIndex);
    }
    return;
}

function AllSceneTimeUpdate(int DeltaTime)
{
    local int Time;
    local string Desc;
    local int Index;
    local float PlayRate;

    Index = m_CurIndex + 1;
    J0x0E:

    // End:0x8D [Loop If]
    if(Index < m_NumOfScene)
    {
        Class'NWindow.SceneEditorAPI'.static.GetCurScenePlayRate(Index, PlayRate);
        Class'NWindow.SceneEditorAPI'.static.GetCurSceneTimeAndDesc(Index, Time, Desc);
        Time += DeltaTime;
        Class'NWindow.SceneEditorAPI'.static.SaveCurSceneTimeAndDesc(Index, Time, Desc, PlayRate);
        ++Index;
        // [Loop Continue]
        goto J0x0E;
    }
    return;
}
