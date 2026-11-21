class CharacterPasswordWnd extends UICommonAPI;

const DIALOG_COMPARE_PROBLEM = 50101;
const DIALOG_WRONG_PASSWORD = 50102;
const DIALOG_BLOCK_PASSWORD = 50103;
const DIALOG_FORBIDDEN_PASSWORD = 50104;
const DIALOG_ETCERROR_PASSWORD = 50105;
const DIALOG_SAVE_SUCCESS_PASSWORD = 50106;

var WindowHandle Me;
var TextureHandle GroupBox1;
var TextureHandle GroupBox2;
var TextureHandle Divider1;
var TextBoxHandle txtNotice;
var ButtonHandle btnPasswordChange;
var ButtonHandle btnHelp;
var ButtonHandle btnOk;
var ButtonHandle btnChangeOk;
var ButtonHandle btnCancel;
var ButtonHandle btnKey1;
var ButtonHandle btnKey2;
var ButtonHandle btnKey3;
var ButtonHandle btnKey4;
var ButtonHandle btnKey5;
var ButtonHandle btnKey6;
var ButtonHandle btnKey7;
var ButtonHandle btnKey8;
var ButtonHandle btnKey9;
var ButtonHandle btnKey0;
var ButtonHandle btnKeyClear;
var ButtonHandle btnKeyBack;
var WindowHandle CharacterPasswordWnd_New;
var TextBoxHandle txtNewTitle;
var TextBoxHandle txtNewInfo;
var TextBoxHandle txtMouseInfo1;
var TextBoxHandle txtSubTitleNew1;
var TextBoxHandle txtSubTitleNew2;
var WindowHandle CharacterPasswordWnd_Normal;
var TextBoxHandle txtNormalTitle;
var TextBoxHandle txtNormalInfo;
var TextBoxHandle txtMouseInfo2;
var TextBoxHandle txtSubTitleNormal1;
var WindowHandle CharacterPasswordWnd_Edit;
var TextBoxHandle txtEditTitle;
var TextBoxHandle txtEditInfo;
var TextBoxHandle txtMouseInfo3;
var TextBoxHandle txtSubTitleEdit1;
var TextBoxHandle txtSubTitleEdit2;
var TextBoxHandle txtSubTitleEdit3;
var TextBoxHandle InputEdit1;
var TextBoxHandle InputEdit2;
var TextBoxHandle InputEdit3;
var TextBoxHandle InputNew1;
var TextBoxHandle InputNew2;
var TextBoxHandle InputNormal1;
var string InputEdit1_string;
var string InputEdit2_string;
var string InputEdit3_string;
var string InputNew1_string;
var string InputNew2_string;
var string InputNormal1_string;
var TextureHandle InputNewFocus1;
var TextureHandle InputNewFocus2;
var TextureHandle InputNormalFocus1;
var TextureHandle InputNormalFocus2;
var TextureHandle InputEditFocus1;
var TextureHandle InputEditFocus2;
var TextureHandle InputEditFocus3;
var ButtonHandle InputNormalBlankBtn1;
var ButtonHandle InputNewBlankBtn1;
var ButtonHandle InputNewBlankBtn2;
var ButtonHandle InputEditBlankBtn1;
var ButtonHandle InputEditBlankBtn2;
var ButtonHandle InputEditBlankBtn3;
var L2Util util;
var array<int> keyArray;
var string currentWindowName;
var string currentFocusEditBoxName;
var CharacterPasswordHelpHtmlWnd CharacterPasswordHelpHtmlWndScript;
var array<string> forbiddenPasswordArray;
var TextBoxHandle currentFocusTextBoxHandle;

function OnRegisterEvent()
{
    RegisterEvent(1710);
    RegisterEvent(1720);
    RegisterEvent(5610);
    RegisterEvent(5611);
    RegisterEvent(5612);
    RegisterEvent(5613);
    RegisterEvent(5614);
    RegisterEvent(5615);
    RegisterEvent(5616);
    return;
}

function OnLoad()
{
    Initialize();
    load();
    setForbiddenWord();
    util = L2Util(GetScript("L2Util"));
    CharacterPasswordHelpHtmlWndScript = CharacterPasswordHelpHtmlWnd(GetScript("CharacterPasswordHelpHtmlWnd"));
    randomWindow();
    return;
}

function randomWindow()
{
    local int randX, randY;

    randX = Rand(30) - 15;
    randY = Rand(30) - 15;
    Me.SetAnchor("", "CenterCenter", "CenterCenter", randX, randY);
    return;
}

function OnShow()
{
    return;
}

function OnExitState(name a_NextStateName)
{
    Me.HideWindow();
    CharacterPasswordHelpHtmlWndScript.Me.HideWindow();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("CharacterPasswordWnd");
    GroupBox1 = GetTextureHandle("CharacterPasswordWnd.GroupBox1");
    GroupBox2 = GetTextureHandle("CharacterPasswordWnd.GroupBox2");
    Divider1 = GetTextureHandle("CharacterPasswordWnd.Divider1");
    txtNotice = GetTextBoxHandle("CharacterPasswordWnd.txtNotice");
    btnPasswordChange = GetButtonHandle("CharacterPasswordWnd.btnPasswordChange");
    btnHelp = GetButtonHandle("CharacterPasswordWnd.btnHelp");
    btnOk = GetButtonHandle("CharacterPasswordWnd.btnOk");
    btnChangeOk = GetButtonHandle("CharacterPasswordWnd.btnChangeOk");
    btnCancel = GetButtonHandle("CharacterPasswordWnd.btnCancel");
    btnKey1 = GetButtonHandle("CharacterPasswordWnd.btnKey1");
    btnKey2 = GetButtonHandle("CharacterPasswordWnd.btnKey2");
    btnKey3 = GetButtonHandle("CharacterPasswordWnd.btnKey3");
    btnKey4 = GetButtonHandle("CharacterPasswordWnd.btnKey4");
    btnKey5 = GetButtonHandle("CharacterPasswordWnd.btnKey5");
    btnKey6 = GetButtonHandle("CharacterPasswordWnd.btnKey6");
    btnKey7 = GetButtonHandle("CharacterPasswordWnd.btnKey7");
    btnKey8 = GetButtonHandle("CharacterPasswordWnd.btnKey8");
    btnKey9 = GetButtonHandle("CharacterPasswordWnd.btnKey9");
    btnKey0 = GetButtonHandle("CharacterPasswordWnd.btnKey0");
    btnKeyClear = GetButtonHandle("CharacterPasswordWnd.btnKeyClear");
    btnKeyBack = GetButtonHandle("CharacterPasswordWnd.btnKeyBack");
    CharacterPasswordWnd_New = GetWindowHandle("CharacterPasswordWnd.CharacterPasswordWnd_New");
    txtNewTitle = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_New.txtNewTitle");
    txtNewInfo = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_New.txtNewInfo");
    txtMouseInfo1 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_New.txtMouseInfo1");
    txtSubTitleNew1 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_New.txtSubTitleNew1");
    txtSubTitleNew2 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_New.txtSubTitleNew2");
    CharacterPasswordWnd_Normal = GetWindowHandle("CharacterPasswordWnd.CharacterPasswordWnd_Normal");
    txtNormalTitle = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Normal.txtNormalTitle");
    txtNormalInfo = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Normal.txtNormalInfo");
    txtMouseInfo2 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Normal.txtMouseInfo2");
    txtSubTitleNormal1 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Normal.txtSubTitleNormal1");
    CharacterPasswordWnd_Edit = GetWindowHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit");
    txtEditTitle = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.txtEditTitle");
    txtEditInfo = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.txtEditInfo");
    txtMouseInfo3 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.txtMouseInfo3");
    txtSubTitleEdit1 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.txtSubTitleEdit1");
    txtSubTitleEdit2 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.txtSubTitleEdit2");
    txtSubTitleEdit3 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.txtSubTitleEdit3");
    InputNormal1 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Normal.InputNormal1");
    InputEdit1 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.InputEdit1");
    InputEdit2 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.InputEdit2");
    InputEdit3 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.InputEdit3");
    InputNew1 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_New.InputNew1");
    InputNew2 = GetTextBoxHandle("CharacterPasswordWnd.CharacterPasswordWnd_New.InputNew2");
    InputNewFocus1 = GetTextureHandle("CharacterPasswordWnd.CharacterPasswordWnd_New.InputNewFocus1");
    InputNewFocus2 = GetTextureHandle("CharacterPasswordWnd.CharacterPasswordWnd_New.InputNewFocus2");
    InputNormalFocus1 = GetTextureHandle("CharacterPasswordWnd.CharacterPasswordWnd_Normal.InputNormalFocus1");
    InputEditFocus1 = GetTextureHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.InputEditFocus1");
    InputEditFocus2 = GetTextureHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.InputEditFocus2");
    InputEditFocus3 = GetTextureHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.InputEditFocus3");
    GetButtonHandle("CharacterPasswordWnd.CharacterPasswordWnd_New.InputNewBlankBtn1");
    GetButtonHandle("CharacterPasswordWnd.CharacterPasswordWnd_New.InputNewBlankBtn2");
    GetButtonHandle("CharacterPasswordWnd.CharacterPasswordWnd_Normal.InputNormalBlankBtn1");
    GetButtonHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.InputEditBlankBtn1");
    GetButtonHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.InputEditBlankBtn2");
    GetButtonHandle("CharacterPasswordWnd.CharacterPasswordWnd_Edit.InputEditBlankBtn3");
    return;
}

function load()
{
    return;
}

function OnClickButton(string Name)
{
    switch(Name)
    {
        // End:0x26
        case "btnPasswordChange":
            changePasswordClick();
            // End:0x1A5
            break;
        // End:0x3B
        case "btnHelp":
            helpClick();
            // End:0x1A5
            break;
        // End:0x4E
        case "btnOk":
            tryPasswordCheck();
            // End:0x1A5
            break;
        // End:0x65
        case "btnCancel":
            cancelBtnClick();
            // End:0x1A5
            break;
        // End:0x7B
        case "InputNewBlankBtn1":
        // End:0x91
        case "InputNewBlankBtn2":
        // End:0xAA
        case "InputNormalBlankBtn1":
        // End:0xC1
        case "InputEditBlankBtn1":
        // End:0xD8
        case "InputEditBlankBtn2":
        // End:0xFD
        case "InputEditBlankBtn3":
            setTexFocus(Name);
            // End:0x1A5
            break;
        // End:0x109
        case "btnKey1":
        // End:0x115
        case "btnKey2":
        // End:0x121
        case "btnKey3":
        // End:0x12D
        case "btnKey4":
        // End:0x139
        case "btnKey5":
        // End:0x145
        case "btnKey6":
        // End:0x151
        case "btnKey7":
        // End:0x15D
        case "btnKey8":
        // End:0x169
        case "btnKey9":
        // End:0x175
        case "btnKey0":
        // End:0x185
        case "btnKeyClear":
        // End:0x1A2
        case "btnKeyBack":
            passwordKeyBoardClick(Name);
            // End:0x1A5
            break;
        // End:0xFFFF
        default:
            break;
    }
    checkEnableOKButton(currentWindowName);
    return;
}

function helpClick()
{
    // End:0x4E
    if(IsShowWindow("CharacterPasswordHelpHtmlWnd"))
    {
        HideWindow("CharacterPasswordHelpHtmlWnd");        
    }
    else
    {
        CharacterPasswordHelpHtmlWndScript.ShowHelp("..\\L2text\\CharacterPasswordHelpHtmlWnd.htm");
    }
    return;
}

function cancelBtnClick()
{
    switch(currentWindowName)
    {
        // End:0x5B
        case "CharacterPasswordWnd_New":
            Me.HideWindow();
            LobbyMenuWnd(GetScript("LobbyMenuWnd")).isStarting = false;
            // End:0x104
            break;
        // End:0x9F
        case "CharacterPasswordWnd_Edit":
            targetWindowShow("CharacterPasswordWnd_Normal");
            // End:0x104
            break;
        // End:0x101
        case "CharacterPasswordWnd_Normal":
            ExecuteEvent(3027);
            LobbyMenuWnd(GetScript("LobbyMenuWnd")).isStarting = false;
            Me.HideWindow();
            // End:0x104
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function passwordKeyBoardClick(string Name)
{
    local string inputNumChar, tempStr;

    // End:0x27
    if(Name == "btnKeyClear")
    {
        setPasswordTextField(currentFocusTextBoxHandle, "");        
    }
    else
    {
        // End:0x7A
        if(Name == "btnKeyBack")
        {
            tempStr = getPasswordString(currentFocusTextBoxHandle);
            // End:0x77
            if(Len(tempStr) > 0)
            {
                setPasswordTextField(currentFocusTextBoxHandle, Left(tempStr, Len(tempStr) - 1));
            }            
        }
        else
        {
            tempStr = getPasswordString(currentFocusTextBoxHandle);
            // End:0xC8
            if(Len(tempStr) < 8)
            {
                inputNumChar = Right(Name, 1);
                setPasswordTextField(currentFocusTextBoxHandle, tempStr $ string(keyArray[int(inputNumChar)]));
            }
        }
    }
    return;
}

function changePasswordClick()
{
    targetWindowShow("CharacterPasswordWnd_Edit");
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int blockTime, Result, Count, errorCode;

    switch(Event_ID)
    {
        // End:0x18
        case 1710:
            HandleDialogOK();
            // End:0x2A9
            break;
        // End:0x23
        case 1720:
            // End:0x2A9
            break;
        // End:0x72
        case 5610:
            Me.ShowWindow();
            Me.SetFocus();
            makeRandomPasswordButton();
            targetWindowShow("CharacterPasswordWnd_New");
            // End:0x2A9
            break;
        // End:0xCA
        case 5611:
            randomWindow();
            Me.ShowWindow();
            Me.SetFocus();
            makeRandomPasswordButton();
            targetWindowShow("CharacterPasswordWnd_Normal");
            // End:0x2A9
            break;
        // End:0x126
        case 5612:
            ParseInt(param, "BlockTime", blockTime);
            DialogSetID(50103);
            DialogShow(0, 1, MakeFullSystemMsg(GetSystemMessage(3376), getTimeStringBySec(blockTime, true, true)), string(self));
            // End:0x2A9
            break;
        // End:0x1A6
        case 5613:
            Me.HideWindow();
            ParseInt(param, "Type", Result);
            // End:0x1A3
            if((Result == 0) || Result == 2)
            {
                DialogSetReservedInt(Result);
                DialogSetReservedInt2((0));
                DialogSetID(50106);
                DialogShow(0, 1, GetSystemMessage(3322), string(self));
            }
            // End:0x2A9
            break;
        // End:0x1D9
        case 5614:
            ParseInt(param, "Result", Result);
            showDialogProcess(50104, 3321);
            // End:0x2A9
            break;
        // End:0x250
        case 5615:
            ParseInt(param, "Result", Result);
            ParseInt(param, "Count", Count);
            DialogSetReservedInt2((Count));
            DialogSetID(50102);
            DialogShow(0, 1, MakeFullSystemMsg(GetSystemMessage(3315), string(Count)), string(self));
            // End:0x2A9
            break;
        // End:0x2A6
        case 5616:
            ParseInt(param, "ErrorCode", errorCode);
            DialogSetID(50105);
            DialogShow(0, 1, MakeFullSystemMsg(GetSystemMessage(3391), string(errorCode)), string(self));
            // End:0x2A9
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function HandleDialogOK()
{
    local int dialogInt;

    // End:0x101
    if(DialogIsMine())
    {
        dialogInt = DialogGetReservedInt();
        switch(DialogGetID())
        {
            // End:0x25
            case 50101:
            // End:0x2D
            case 50104:
            // End:0x54
            case 50105:
                initCurrentText();
                targetWindowShow(currentWindowName);
                checkEnableOKButton(currentWindowName);
                // End:0x101
                break;
            // End:0x9D
            case 50102:
                // End:0x7E
                if(__NFUN_411__(DialogGetReservedInt2(), (5)))
                {
                    Me.HideWindow();                    
                }
                else
                {
                    initCurrentText();
                    targetWindowShow(currentWindowName);
                    checkEnableOKButton(currentWindowName);
                }
                // End:0x101
                break;
            // End:0xB7
            case 50103:
                Me.HideWindow();
                // End:0x101
                break;
            // End:0xFE
            case 50106:
                // End:0xFB
                if((dialogInt == 0) || dialogInt == 2)
                {
                    targetWindowShow("CharacterPasswordWnd_Normal");
                }
                // End:0x101
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        return;
    }
}

function string getTimeStringBySec(int Sec, optional bool hourFlag, optional bool minFlag)
{
    local int timeTemp;
    local string returnStr;

    returnStr = "";
    timeTemp = (Sec / 60) / 60;
    // End:0xE0
    if(timeTemp > 0)
    {
        // End:0x70
        if(hourFlag && minFlag)
        {
            returnStr = MakeFullSystemMsg(GetSystemMessage(3304), string(timeTemp), string(int(float(Sec / 60) % float(60))));            
        }
        else
        {
            // End:0xA8
            if(hourFlag && minFlag == false)
            {
                returnStr = MakeFullSystemMsg(GetSystemMessage(3406), string(timeTemp));                
            }
            else
            {
                // End:0xDD
                if((hourFlag == false) && minFlag)
                {
                    returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp));
                }
            }
        }        
    }
    else
    {
        // End:0x13C
        if(hourFlag && minFlag == false)
        {
            // End:0x11F
            if(Sec <= 0)
            {
                returnStr = MakeFullSystemMsg(GetSystemMessage(3407), "0");                
            }
            else
            {
                returnStr = MakeFullSystemMsg(GetSystemMessage(3407), "1");
            }            
        }
        else
        {
            timeTemp = Sec / 60;
            // End:0x15D
            if(timeTemp <= 0)
            {
                timeTemp = 1;
            }
            returnStr = MakeFullSystemMsg(GetSystemMessage(3390), string(timeTemp));
        }
    }
    return returnStr;
    return;
}

function checkEnableOKButton(string targetWndName)
{
    btnOk.DisableWindow();
    switch(targetWndName)
    {
        // End:0x77
        case "CharacterPasswordWnd_New":
            // End:0x74
            if((Len(InputNew1.GetText()) >= 6) && Len(InputNew2.GetText()) >= 6)
            {
                btnOk.EnableWindow();
            }
            // End:0x140
            break;
        // End:0xC1
        case "CharacterPasswordWnd_Normal":
            // End:0xBE
            if(Len(InputNormal1.GetText()) >= 6)
            {
                btnOk.EnableWindow();
            }
            // End:0x140
            break;
        // End:0x13D
        case "CharacterPasswordWnd_Edit":
            // End:0x13A
            if(((Len(InputEdit1.GetText()) >= 6) && Len(InputEdit2.GetText()) >= 6) && Len(InputEdit3.GetText()) >= 6)
            {
                btnOk.EnableWindow();
            }
            // End:0x140
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function makeRandomPasswordButton()
{
    local int i;

    i = 0;
    J0x07:

    // End:0x2E [Loop If]
    if(i < 10)
    {
        keyArray[i] = i;
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    util.arrayShuffleInt(keyArray);
    i = 0;
    J0x49:

    // End:0x12B [Loop If]
    if(i < 10)
    {
        GetButtonHandle("CharacterPasswordWnd.btnKey" $ string(i)).SetTexture("l2ui_ct1.CharacterPassword_DF_Key" $ string(keyArray[i]), "l2ui_ct1.CharacterPassword_DF_Key" $ string(keyArray[i]), "l2ui_ct1.CharacterPassword_DF_Key" $ string(keyArray[i]));
        i++;
        // [Loop Continue]
        goto J0x49;
    }
    return;
}

function initCurrentText()
{
    switch(currentWindowName)
    {
        // End:0x5A
        case "CharacterPasswordWnd_New":
            setPasswordTextField(InputNew1, "");
            setPasswordTextField(InputNew2, "");
            setTexFocus("InputNewBlankBtn1");
            // End:0x10A
            break;
        // End:0xA6
        case "CharacterPasswordWnd_Normal":
            setPasswordTextField(InputNormal1, "");
            setTexFocus("InputNormalBlankBtn1");
            // End:0x10A
            break;
        // End:0x107
        case "CharacterPasswordWnd_Edit":
            setPasswordTextField(InputEdit1, "");
            setPasswordTextField(InputEdit2, "");
            setPasswordTextField(InputEdit3, "");
            setTexFocus("InputNewBlankBtn1");
            // End:0x10A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function showDialogProcess(int dialogID, int systemMessageNum)
{
    DialogSetID(dialogID);
    DialogShow(0, 1, GetSystemMessage(systemMessageNum), string(self));
    return;
}

function tryPasswordCheck()
{
    switch(currentWindowName)
    {
        // End:0xA3
        case "CharacterPasswordWnd_New":
            // End:0x90
            if((getPasswordString(InputNew1)) == (getPasswordString(InputNew2)))
            {
                // End:0x7D
                if((passPasswordFilter(getPasswordString(InputNew1))) && passPasswordFilter(getPasswordString(InputNew2)))
                {
                    RequestSecondaryAuthCreate(getPasswordString(InputNew1));                    
                }
                else
                {
                    showDialogProcess(50104, 3321);
                }                
            }
            else
            {
                showDialogProcess(50101, 3318);
            }
            // End:0x1BC
            break;
        // End:0xFE
        case "CharacterPasswordWnd_Normal":
            // End:0xEB
            if(passPasswordFilter(getPasswordString(InputNormal1)))
            {
                RequestSecondaryAuthVerify(getPasswordString(InputNormal1));                
            }
            else
            {
                showDialogProcess(50104, 3321);
            }
            // End:0x1BC
            break;
        // End:0x1B9
        case "CharacterPasswordWnd_Edit":
            // End:0x193
            if((getPasswordString(InputEdit2)) == (getPasswordString(InputEdit3)))
            {
                // End:0x180
                if((passPasswordFilter(getPasswordString(InputEdit2))) && passPasswordFilter(getPasswordString(InputEdit3)))
                {
                    RequestSecondaryAuthModify(getPasswordString(InputEdit1), getPasswordString(InputEdit3));                    
                }
                else
                {
                    showDialogProcess(50104, 3321);
                }                
            }
            else
            {
                DialogSetID(50101);
                DialogShow(1, 1, GetSystemMessage(3318), string(self));
            }
            // End:0x1BC
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function setTexFocus(string btnName)
{
    switch(btnName)
    {
        // End:0x36
        case "InputNewBlankBtn1":
            setFocusChange(InputNewFocus1);
            currentFocusTextBoxHandle = InputNew1;
            // End:0x12A
            break;
        // End:0x65
        case "InputNewBlankBtn2":
            setFocusChange(InputNewFocus2);
            currentFocusTextBoxHandle = InputNew2;
            // End:0x12A
            break;
        // End:0x97
        case "InputNormalBlankBtn1":
            setFocusChange(InputNormalFocus1);
            currentFocusTextBoxHandle = InputNormal1;
            // End:0x12A
            break;
        // End:0xC7
        case "InputEditBlankBtn1":
            setFocusChange(InputEditFocus1);
            currentFocusTextBoxHandle = InputEdit1;
            // End:0x12A
            break;
        // End:0xF7
        case "InputEditBlankBtn2":
            setFocusChange(InputEditFocus2);
            currentFocusTextBoxHandle = InputEdit2;
            // End:0x12A
            break;
        // End:0x127
        case "InputEditBlankBtn3":
            setFocusChange(InputEditFocus3);
            currentFocusTextBoxHandle = InputEdit3;
            // End:0x12A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function setFocusChange(TextureHandle targetTexture)
{
    InputNewFocus1.SetTexture("L2UI_CT1.CharacterPassword_DF_EditBox");
    InputNewFocus2.SetTexture("L2UI_CT1.CharacterPassword_DF_EditBox");
    InputNormalFocus1.SetTexture("L2UI_CT1.CharacterPassword_DF_EditBox");
    InputEditFocus1.SetTexture("L2UI_CT1.CharacterPassword_DF_EditBox");
    InputEditFocus2.SetTexture("L2UI_CT1.CharacterPassword_DF_EditBox");
    InputEditFocus3.SetTexture("L2UI_CT1.CharacterPassword_DF_EditBox");
    targetTexture.SetTexture("L2UI_CT1.CharacterPassword_DF_EditBoxFocus");
    return;
}

function setPasswordTextField(out TextBoxHandle targetTextBox, string inputNumStr)
{
    local string targetTextBox_string;
    local int i;

    targetTextBox_string = "";
    // End:0x30
    if(inputNumStr == "")
    {
        targetTextBox.SetText("");
        targetTextBox_string = "";        
    }
    else
    {
        targetTextBox_string = inputNumStr;
    }
    targetTextBox.SetText("");
    i = 0;
    J0x53:

    // End:0x91 [Loop If]
    if(i < Len(targetTextBox_string))
    {
        targetTextBox.SetText(targetTextBox.GetText() $ "*");
        i++;
        // [Loop Continue]
        goto J0x53;
    }
    switch(targetTextBox)
    {
        // End:0xAE
        case InputNew1:
            InputNew1_string = inputNumStr;
            // End:0x11F
            break;
        // End:0xC4
        case InputNew2:
            InputNew2_string = inputNumStr;
            // End:0x11F
            break;
        // End:0xDA
        case InputEdit1:
            InputEdit1_string = inputNumStr;
            // End:0x11F
            break;
        // End:0xF0
        case InputEdit2:
            InputEdit2_string = inputNumStr;
            // End:0x11F
            break;
        // End:0x106
        case InputEdit3:
            InputEdit3_string = inputNumStr;
            // End:0x11F
            break;
        // End:0x11C
        case InputNormal1:
            InputNormal1_string = inputNumStr;
            // End:0x11F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function string getPasswordString(TextBoxHandle targetTextBox)
{
    switch(targetTextBox)
    {
        // End:0x15
        case InputNew1:
            return InputNew1_string;
        // End:0x23
        case InputNew2:
            return InputNew2_string;
        // End:0x31
        case InputEdit1:
            return InputEdit1_string;
        // End:0x3F
        case InputEdit2:
            return InputEdit2_string;
        // End:0x4D
        case InputEdit3:
            return InputEdit3_string;
        // End:0x5B
        case InputNormal1:
            return InputNormal1_string;
        // End:0xFFFF
        default:
            return;
            break;
    }
}

function targetWindowShow(string targetWndName)
{
    Me.ShowWindow();
    Me.SetFocus();
    CharacterPasswordWnd_New.HideWindow();
    CharacterPasswordWnd_New.DisableWindow();
    CharacterPasswordWnd_Normal.HideWindow();
    CharacterPasswordWnd_Normal.DisableWindow();
    CharacterPasswordWnd_Edit.HideWindow();
    CharacterPasswordWnd_Edit.DisableWindow();
    switch(targetWndName)
    {
        // End:0x12E
        case "CharacterPasswordWnd_New":
            CharacterPasswordWnd_New.EnableWindow();
            CharacterPasswordWnd_New.ShowWindow();
            CharacterPasswordWnd_New.SetFocus();
            currentWindowName = "CharacterPasswordWnd_New";
            btnPasswordChange.HideWindow();
            setPasswordTextField(InputNew1, "");
            setPasswordTextField(InputNew2, "");
            setTexFocus("InputNewBlankBtn1");
            // End:0x2D4
            break;
        // End:0x1D9
        case "CharacterPasswordWnd_Normal":
            CharacterPasswordWnd_Normal.EnableWindow();
            CharacterPasswordWnd_Normal.ShowWindow();
            CharacterPasswordWnd_Normal.SetFocus();
            currentWindowName = "CharacterPasswordWnd_Normal";
            btnPasswordChange.ShowWindow();
            setPasswordTextField(InputNormal1, "");
            setTexFocus("InputNormalBlankBtn1");
            // End:0x2D4
            break;
        // End:0x2D1
        case "CharacterPasswordWnd_Edit":
            CharacterPasswordWnd_Edit.EnableWindow();
            CharacterPasswordWnd_Edit.ShowWindow();
            CharacterPasswordWnd_Edit.SetFocus();
            currentWindowName = "CharacterPasswordWnd_Edit";
            btnPasswordChange.HideWindow();
            setPasswordTextField(InputEdit1, getPasswordString(InputNormal1));
            setPasswordTextField(InputEdit2, "");
            setPasswordTextField(InputEdit3, "");
            // End:0x2B4
            if(Len(getPasswordString(InputNormal1)) > 0)
            {
                setTexFocus("InputEditBlankBtn2");                
            }
            else
            {
                setTexFocus("InputEditBlankBtn1");
            }
            // End:0x2D4
            break;
        // End:0xFFFF
        default:
            break;
    }
    checkEnableOKButton(targetWndName);
    return;
}

function bool passPasswordFilter(string word)
{
    local int i;
    local bool bFlag;

    bFlag = true;
    i = 0;
    J0x0F:

    // End:0x49 [Loop If]
    if(i < forbiddenPasswordArray.Length)
    {
        // End:0x3F
        if(forbiddenPasswordArray[i] == word)
        {
            bFlag = false;
            // [Explicit Break]
            goto J0x49;
        }
        i++;
        // [Loop Continue]
        goto J0x0F;
    }
    J0x49:

    return bFlag;
    return;
}

function setForbiddenWord()
{
    forbiddenPasswordArray[0] = "000000";
    forbiddenPasswordArray[1] = "111111";
    forbiddenPasswordArray[2] = "222222";
    forbiddenPasswordArray[3] = "333333";
    forbiddenPasswordArray[4] = "444444";
    forbiddenPasswordArray[5] = "555555";
    forbiddenPasswordArray[6] = "666666";
    forbiddenPasswordArray[7] = "777777";
    forbiddenPasswordArray[8] = "888888";
    forbiddenPasswordArray[9] = "999999";
    forbiddenPasswordArray[10] = "123456";
    forbiddenPasswordArray[11] = "234567";
    forbiddenPasswordArray[12] = "345678";
    forbiddenPasswordArray[13] = "456789";
    forbiddenPasswordArray[14] = "567890";
    forbiddenPasswordArray[15] = "012345";
    forbiddenPasswordArray[16] = "098765";
    forbiddenPasswordArray[17] = "987654";
    forbiddenPasswordArray[18] = "876543";
    forbiddenPasswordArray[19] = "765432";
    forbiddenPasswordArray[20] = "543210";
    forbiddenPasswordArray[21] = "010101";
    forbiddenPasswordArray[22] = "020202";
    forbiddenPasswordArray[23] = "030303";
    forbiddenPasswordArray[24] = "040404";
    forbiddenPasswordArray[25] = "050505";
    forbiddenPasswordArray[26] = "060606";
    forbiddenPasswordArray[27] = "070707";
    forbiddenPasswordArray[28] = "080808";
    forbiddenPasswordArray[29] = "090909";
    forbiddenPasswordArray[30] = "121212";
    forbiddenPasswordArray[31] = "131313";
    forbiddenPasswordArray[32] = "141414";
    forbiddenPasswordArray[33] = "151515";
    forbiddenPasswordArray[34] = "161616";
    forbiddenPasswordArray[35] = "171717";
    forbiddenPasswordArray[36] = "181818";
    forbiddenPasswordArray[37] = "191919";
    forbiddenPasswordArray[38] = "101010";
    forbiddenPasswordArray[39] = "212121";
    forbiddenPasswordArray[40] = "232323";
    forbiddenPasswordArray[41] = "242424";
    forbiddenPasswordArray[42] = "252525";
    forbiddenPasswordArray[43] = "262626";
    forbiddenPasswordArray[44] = "272727";
    forbiddenPasswordArray[45] = "282828";
    forbiddenPasswordArray[46] = "292929";
    forbiddenPasswordArray[47] = "202020";
    forbiddenPasswordArray[48] = "313131";
    forbiddenPasswordArray[49] = "323232";
    forbiddenPasswordArray[50] = "343434";
    forbiddenPasswordArray[51] = "353535";
    forbiddenPasswordArray[52] = "363636";
    forbiddenPasswordArray[53] = "373737";
    forbiddenPasswordArray[54] = "383838";
    forbiddenPasswordArray[55] = "393939";
    forbiddenPasswordArray[56] = "303030";
    forbiddenPasswordArray[57] = "404040";
    forbiddenPasswordArray[58] = "414141";
    forbiddenPasswordArray[59] = "424242";
    forbiddenPasswordArray[60] = "434343";
    forbiddenPasswordArray[61] = "454545";
    forbiddenPasswordArray[62] = "464646";
    forbiddenPasswordArray[63] = "474747";
    forbiddenPasswordArray[64] = "484848";
    forbiddenPasswordArray[65] = "494949";
    forbiddenPasswordArray[66] = "505050";
    forbiddenPasswordArray[67] = "515151";
    forbiddenPasswordArray[68] = "525252";
    forbiddenPasswordArray[69] = "535353";
    forbiddenPasswordArray[70] = "545454";
    forbiddenPasswordArray[71] = "565656";
    forbiddenPasswordArray[72] = "575757";
    forbiddenPasswordArray[73] = "585858";
    forbiddenPasswordArray[74] = "595959";
    forbiddenPasswordArray[75] = "606060";
    forbiddenPasswordArray[76] = "616161";
    forbiddenPasswordArray[77] = "626262";
    forbiddenPasswordArray[78] = "636363";
    forbiddenPasswordArray[79] = "646464";
    forbiddenPasswordArray[80] = "656565";
    forbiddenPasswordArray[81] = "676767";
    forbiddenPasswordArray[82] = "686868";
    forbiddenPasswordArray[83] = "696969";
    forbiddenPasswordArray[84] = "707070";
    forbiddenPasswordArray[85] = "717171";
    forbiddenPasswordArray[86] = "727272";
    forbiddenPasswordArray[87] = "737373";
    forbiddenPasswordArray[88] = "747474";
    forbiddenPasswordArray[89] = "757575";
    forbiddenPasswordArray[90] = "767676";
    forbiddenPasswordArray[91] = "787878";
    forbiddenPasswordArray[92] = "797979";
    forbiddenPasswordArray[93] = "808080";
    forbiddenPasswordArray[94] = "818181";
    forbiddenPasswordArray[95] = "828282";
    forbiddenPasswordArray[96] = "838383";
    forbiddenPasswordArray[97] = "848484";
    forbiddenPasswordArray[98] = "858585";
    forbiddenPasswordArray[99] = "868686";
    forbiddenPasswordArray[100] = "878787";
    forbiddenPasswordArray[101] = "898989";
    forbiddenPasswordArray[102] = "909090";
    forbiddenPasswordArray[103] = "919191";
    forbiddenPasswordArray[104] = "929292";
    forbiddenPasswordArray[105] = "939393";
    forbiddenPasswordArray[106] = "949494";
    forbiddenPasswordArray[107] = "959595";
    forbiddenPasswordArray[108] = "969696";
    forbiddenPasswordArray[109] = "979797";
    forbiddenPasswordArray[110] = "989898";
    forbiddenPasswordArray[111] = "0000000";
    forbiddenPasswordArray[112] = "1111111";
    forbiddenPasswordArray[113] = "2222222";
    forbiddenPasswordArray[114] = "3333333";
    forbiddenPasswordArray[115] = "4444444";
    forbiddenPasswordArray[116] = "5555555";
    forbiddenPasswordArray[117] = "6666666";
    forbiddenPasswordArray[118] = "7777777";
    forbiddenPasswordArray[119] = "8888888";
    forbiddenPasswordArray[120] = "9999999";
    forbiddenPasswordArray[121] = "0123456";
    forbiddenPasswordArray[122] = "1234567";
    forbiddenPasswordArray[123] = "2345678";
    forbiddenPasswordArray[124] = "3456789";
    forbiddenPasswordArray[125] = "4567890";
    forbiddenPasswordArray[126] = "0987654";
    forbiddenPasswordArray[127] = "9876543";
    forbiddenPasswordArray[128] = "8765432";
    forbiddenPasswordArray[129] = "7654321";
    forbiddenPasswordArray[130] = "6543210";
    forbiddenPasswordArray[131] = "0101010";
    forbiddenPasswordArray[132] = "0202020";
    forbiddenPasswordArray[133] = "0303030";
    forbiddenPasswordArray[134] = "0404040";
    forbiddenPasswordArray[135] = "0505050";
    forbiddenPasswordArray[136] = "0606060";
    forbiddenPasswordArray[137] = "0707070";
    forbiddenPasswordArray[138] = "0808080";
    forbiddenPasswordArray[139] = "0909090";
    forbiddenPasswordArray[140] = "1212121";
    forbiddenPasswordArray[141] = "1313131";
    forbiddenPasswordArray[142] = "1414141";
    forbiddenPasswordArray[143] = "1515151";
    forbiddenPasswordArray[144] = "1616161";
    forbiddenPasswordArray[145] = "1717171";
    forbiddenPasswordArray[146] = "1818181";
    forbiddenPasswordArray[147] = "1919191";
    forbiddenPasswordArray[148] = "1010101";
    forbiddenPasswordArray[149] = "2020202";
    forbiddenPasswordArray[150] = "2121212";
    forbiddenPasswordArray[151] = "2323232";
    forbiddenPasswordArray[152] = "2424242";
    forbiddenPasswordArray[153] = "2525252";
    forbiddenPasswordArray[154] = "2626262";
    forbiddenPasswordArray[155] = "2727272";
    forbiddenPasswordArray[156] = "2828282";
    forbiddenPasswordArray[157] = "2929292";
    forbiddenPasswordArray[158] = "3030303";
    forbiddenPasswordArray[159] = "3131313";
    forbiddenPasswordArray[160] = "3232323";
    forbiddenPasswordArray[161] = "3434343";
    forbiddenPasswordArray[162] = "3535353";
    forbiddenPasswordArray[163] = "3636363";
    forbiddenPasswordArray[164] = "3737373";
    forbiddenPasswordArray[165] = "3838383";
    forbiddenPasswordArray[166] = "3939393";
    forbiddenPasswordArray[167] = "4040404";
    forbiddenPasswordArray[168] = "4141414";
    forbiddenPasswordArray[169] = "4242424";
    forbiddenPasswordArray[170] = "4343434";
    forbiddenPasswordArray[171] = "4545454";
    forbiddenPasswordArray[172] = "4646464";
    forbiddenPasswordArray[173] = "4747474";
    forbiddenPasswordArray[174] = "4848484";
    forbiddenPasswordArray[175] = "4949494";
    forbiddenPasswordArray[176] = "5050505";
    forbiddenPasswordArray[177] = "5151515";
    forbiddenPasswordArray[178] = "5252525";
    forbiddenPasswordArray[179] = "5353535";
    forbiddenPasswordArray[180] = "5454545";
    forbiddenPasswordArray[181] = "5656565";
    forbiddenPasswordArray[182] = "5757575";
    forbiddenPasswordArray[183] = "5858585";
    forbiddenPasswordArray[184] = "5959595";
    forbiddenPasswordArray[185] = "6060606";
    forbiddenPasswordArray[186] = "6161616";
    forbiddenPasswordArray[187] = "6262626";
    forbiddenPasswordArray[188] = "6363636";
    forbiddenPasswordArray[189] = "6464646";
    forbiddenPasswordArray[190] = "6565656";
    forbiddenPasswordArray[191] = "6767676";
    forbiddenPasswordArray[192] = "6868686";
    forbiddenPasswordArray[193] = "6969696";
    forbiddenPasswordArray[194] = "7070707";
    forbiddenPasswordArray[195] = "7171717";
    forbiddenPasswordArray[196] = "7272727";
    forbiddenPasswordArray[197] = "7373737";
    forbiddenPasswordArray[198] = "7474747";
    forbiddenPasswordArray[199] = "7575757";
    forbiddenPasswordArray[200] = "7676767";
    forbiddenPasswordArray[201] = "7878787";
    forbiddenPasswordArray[202] = "7979797";
    forbiddenPasswordArray[203] = "8080808";
    forbiddenPasswordArray[204] = "8181818";
    forbiddenPasswordArray[205] = "8282828";
    forbiddenPasswordArray[206] = "8383838";
    forbiddenPasswordArray[207] = "8484848";
    forbiddenPasswordArray[208] = "8585858";
    forbiddenPasswordArray[209] = "8686868";
    forbiddenPasswordArray[210] = "8787878";
    forbiddenPasswordArray[211] = "8989898";
    forbiddenPasswordArray[212] = "9090909";
    forbiddenPasswordArray[213] = "9191919";
    forbiddenPasswordArray[214] = "9292929";
    forbiddenPasswordArray[215] = "9393939";
    forbiddenPasswordArray[216] = "9494949";
    forbiddenPasswordArray[217] = "9595959";
    forbiddenPasswordArray[218] = "9696969";
    forbiddenPasswordArray[219] = "9797979";
    forbiddenPasswordArray[220] = "9898989";
    forbiddenPasswordArray[221] = "00000000";
    forbiddenPasswordArray[222] = "11111111";
    forbiddenPasswordArray[223] = "22222222";
    forbiddenPasswordArray[224] = "33333333";
    forbiddenPasswordArray[225] = "44444444";
    forbiddenPasswordArray[226] = "55555555";
    forbiddenPasswordArray[227] = "66666666";
    forbiddenPasswordArray[228] = "77777777";
    forbiddenPasswordArray[229] = "88888888";
    forbiddenPasswordArray[230] = "99999999";
    forbiddenPasswordArray[231] = "12345678";
    forbiddenPasswordArray[232] = "23456789";
    forbiddenPasswordArray[233] = "34567890";
    forbiddenPasswordArray[234] = "01234567";
    forbiddenPasswordArray[235] = "98765432";
    forbiddenPasswordArray[236] = "87654321";
    forbiddenPasswordArray[237] = "76543210";
    forbiddenPasswordArray[238] = "01010101";
    forbiddenPasswordArray[239] = "02020202";
    forbiddenPasswordArray[240] = "03030303";
    forbiddenPasswordArray[241] = "04040404";
    forbiddenPasswordArray[242] = "05050505";
    forbiddenPasswordArray[243] = "06060606";
    forbiddenPasswordArray[244] = "07070707";
    forbiddenPasswordArray[245] = "08080808";
    forbiddenPasswordArray[246] = "09090909";
    forbiddenPasswordArray[247] = "10101010";
    forbiddenPasswordArray[248] = "12121212";
    forbiddenPasswordArray[249] = "13131313";
    forbiddenPasswordArray[250] = "14141414";
    forbiddenPasswordArray[251] = "15151515";
    forbiddenPasswordArray[252] = "16161616";
    forbiddenPasswordArray[253] = "17171717";
    forbiddenPasswordArray[254] = "18181818";
    forbiddenPasswordArray[255] = "19191919";
    forbiddenPasswordArray[256] = "20202020";
    forbiddenPasswordArray[257] = "21212121";
    forbiddenPasswordArray[258] = "23232323";
    forbiddenPasswordArray[259] = "24242424";
    forbiddenPasswordArray[260] = "25252525";
    forbiddenPasswordArray[261] = "26262626";
    forbiddenPasswordArray[262] = "27272727";
    forbiddenPasswordArray[263] = "28282828";
    forbiddenPasswordArray[264] = "29292929";
    forbiddenPasswordArray[265] = "30303030";
    forbiddenPasswordArray[266] = "31313131";
    forbiddenPasswordArray[267] = "32323232";
    forbiddenPasswordArray[268] = "34343434";
    forbiddenPasswordArray[269] = "35353535";
    forbiddenPasswordArray[270] = "36363636";
    forbiddenPasswordArray[271] = "37373737";
    forbiddenPasswordArray[272] = "38383838";
    forbiddenPasswordArray[273] = "39393939";
    forbiddenPasswordArray[274] = "40404040";
    forbiddenPasswordArray[275] = "41414141";
    forbiddenPasswordArray[276] = "42424242";
    forbiddenPasswordArray[277] = "43434343";
    forbiddenPasswordArray[278] = "45454545";
    forbiddenPasswordArray[279] = "46464646";
    forbiddenPasswordArray[280] = "47474747";
    forbiddenPasswordArray[281] = "48484848";
    forbiddenPasswordArray[282] = "49494949";
    forbiddenPasswordArray[283] = "50505050";
    forbiddenPasswordArray[284] = "51515151";
    forbiddenPasswordArray[285] = "52525252";
    forbiddenPasswordArray[286] = "53535353";
    forbiddenPasswordArray[287] = "54545454";
    forbiddenPasswordArray[288] = "56565656";
    forbiddenPasswordArray[289] = "57575757";
    forbiddenPasswordArray[290] = "58585858";
    forbiddenPasswordArray[291] = "59595959";
    forbiddenPasswordArray[292] = "60606060";
    forbiddenPasswordArray[293] = "61616161";
    forbiddenPasswordArray[294] = "62626262";
    forbiddenPasswordArray[295] = "63636363";
    forbiddenPasswordArray[296] = "64646464";
    forbiddenPasswordArray[297] = "65656565";
    forbiddenPasswordArray[298] = "67676767";
    forbiddenPasswordArray[299] = "68686868";
    forbiddenPasswordArray[300] = "69696969";
    forbiddenPasswordArray[301] = "70707070";
    forbiddenPasswordArray[302] = "71717171";
    forbiddenPasswordArray[303] = "72727272";
    forbiddenPasswordArray[304] = "73737373";
    forbiddenPasswordArray[305] = "74747474";
    forbiddenPasswordArray[306] = "75757575";
    forbiddenPasswordArray[307] = "76767676";
    forbiddenPasswordArray[308] = "78787878";
    forbiddenPasswordArray[309] = "79797979";
    forbiddenPasswordArray[310] = "80808080";
    forbiddenPasswordArray[311] = "81818181";
    forbiddenPasswordArray[312] = "82828282";
    forbiddenPasswordArray[313] = "83838383";
    forbiddenPasswordArray[314] = "84848484";
    forbiddenPasswordArray[315] = "85858585";
    forbiddenPasswordArray[316] = "86868686";
    forbiddenPasswordArray[317] = "87878787";
    forbiddenPasswordArray[318] = "89898989";
    forbiddenPasswordArray[319] = "90909090";
    forbiddenPasswordArray[320] = "91919191";
    forbiddenPasswordArray[321] = "92929292";
    forbiddenPasswordArray[322] = "93939393";
    forbiddenPasswordArray[323] = "94949494";
    forbiddenPasswordArray[324] = "95959595";
    forbiddenPasswordArray[325] = "96969696";
    forbiddenPasswordArray[326] = "97979797";
    forbiddenPasswordArray[327] = "98989898";
    return;
}
