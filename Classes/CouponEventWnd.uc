class CouponEventWnd extends UIScript;

var string CurrentInput;
var bool completeEditbox;
var array<int> completebox;

function OnRegisterEvent()
{
    RegisterEvent(530);
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("CouponEventWnd");
    completebox.Length = 5;
    initValue();
    return;
}

function initValue()
{
    CurrentInput = "";
    completeEditbox = false;
    completebox[1] = 0;
    completebox[2] = 0;
    completebox[3] = 0;
    completebox[4] = 0;
    completebox[5] = 0;
    return;
}

function resetEditBox()
{
    local int i;

    i = 1;
    J0x07:

    // End:0x4D [Loop If]
    if(i <= 5)
    {
        Class'NWindow.UIAPI_EDITBOX'.static.SetString("CouponEventWnd.input" $ string(i), "");
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function OnShow()
{
    initValue();
    resetEditBox();
    Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("CouponEventWnd.inputnumber");
    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("CouponEventWnd.input1");
    return;
}

function OnEvent(int Event_ID, string param)
{
    // End:0x2E
    if(Event_ID == 530)
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("CouponEventWnd");
    }
    return;
}

function OnClickButton(string strID)
{
    // End:0x48
    if(strID == "inputnumber")
    {
        Proc_Delivery();
        resetEditBox();
        initValue();
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("CouponEventWnd");
    }
    // End:0x8E
    if(strID == "resetbtn")
    {
        resetEditBox();
        initValue();
        Class'NWindow.UIAPI_WINDOW'.static.SetFocus("CouponEventWnd.input1");
    }
    return;
}

function Proc_Delivery()
{
    RequestPCCafeCouponUse(CurrentInput);
    return;
}

function OnChangeEditBox(string EditBoxID)
{
    // End:0x1D
    if(EditBoxID == "input1")
    {
        count_editBox(EditBoxID);
    }
    // End:0x3A
    if(EditBoxID == "input2")
    {
        count_editBox(EditBoxID);
    }
    // End:0x57
    if(EditBoxID == "input3")
    {
        count_editBox(EditBoxID);
    }
    // End:0x74
    if(EditBoxID == "input4")
    {
        count_editBox(EditBoxID);
    }
    // End:0x91
    if(EditBoxID == "input5")
    {
        count_editBox(EditBoxID);
    }
    return;
}

function count_editBox(string currentboxnum)
{
    local array<string> inputtxt;
    local int currentboxNumint, i;

    inputtxt.Length = 5;
    currentboxNumint = int(Right(currentboxnum, 1));
    inputtxt[currentboxNumint] = "" $ Class'NWindow.UIAPI_EDITBOX'.static.GetString("CouponEventWnd.input" $ string(currentboxNumint));
    // End:0xB8
    if(Len(inputtxt[currentboxNumint]) == 4)
    {
        completebox[currentboxNumint] = 1;
        // End:0xB5
        if(currentboxNumint != 5)
        {
            Class'NWindow.UIAPI_WINDOW'.static.SetFocus("CouponEventWnd.input" $ string(currentboxNumint + 1));
        }        
    }
    else
    {
        completebox[currentboxNumint] = 0;
    }
    i = 1;
    J0xCC:

    // End:0xE2 [Loop If]
    if(i <= 5)
    {
        ++i;
        // [Loop Continue]
        goto J0xCC;
    }
    // End:0x235
    if(((((completebox[1] == 1) && completebox[2] == 1) && completebox[3] == 1) && completebox[4] == 1) && completebox[5] == 1)
    {
        completeEditbox = true;
        CurrentInput = (((("" $ Class'NWindow.UIAPI_EDITBOX'.static.GetString("CouponEventWnd.input1")) $ Class'NWindow.UIAPI_EDITBOX'.static.GetString("CouponEventWnd.input2")) $ Class'NWindow.UIAPI_EDITBOX'.static.GetString("CouponEventWnd.input3")) $ Class'NWindow.UIAPI_EDITBOX'.static.GetString("CouponEventWnd.input4")) $ Class'NWindow.UIAPI_EDITBOX'.static.GetString("CouponEventWnd.input5");
        Class'NWindow.UIAPI_WINDOW'.static.EnableWindow("CouponEventWnd.inputnumber");        
    }
    else
    {
        completeEditbox = false;
        Class'NWindow.UIAPI_WINDOW'.static.DisableWindow("CouponEventWnd.inputnumber");
    }
    return;
}
