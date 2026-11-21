class CalculatorWnd extends UICommonAPI;

const MAX_NUMERIC_LENGTH = 17;

enum EOperator
{
    OP_None,                        // 0
    OP_PLUS,                        // 1
    OP_MINUS,                       // 2
    OP_MULTIPLY,                    // 3
    OP_DIVIDE                       // 4
};

var INT64 m_Operand1;
var CalculatorWnd.EOperator m_Operator;
var EditBoxHandle m_ResultEditBox;

function OnRegisterEvent()
{
    RegisterEvent(1700);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    m_ResultEditBox = GetEditBoxHandle("CalculatorWnd.editBoxCalculate");
    m_ResultEditBox.DisableWindow();
    return;
}

function OnShow()
{
    InitCalculator();
    return;
}

function InitCalculator()
{
    m_Operand1 = (0);
    SetOperator(0);
    GotoState('Operand1');
    CE();
    return;
}

function CE()
{
    SetNumeric((0));
    return;
}

function SetOperand1(INT64 a_Operand)
{
    m_Operand1 = a_Operand;
    return;
}

function SetOperator(CalculatorWnd.EOperator Op)
{
    m_Operator = Op;
    return;
}

function AddString(string Str)
{
    m_ResultEditBox.super(CalculatorWnd).AddString(Str);
    return;
}

function SetString(string Str)
{
    m_ResultEditBox.super(CalculatorWnd).SetString(Str);
    return;
}

function string GetString()
{
    return m_ResultEditBox.super(CalculatorWnd).GetString();
    return;
}

function INT64 GetOperand()
{
    local string Str;

    Str = GetString();
    // End:0x24
    if(Len(Str) > 0)
    {
        return (Str);        
    }
    else
    {
        return (0);
    }
    return;
}

function INT64 Calc(INT64 A, INT64 B, CalculatorWnd.EOperator Op)
{
    local INT64 nResult;

    switch(Op)
    {
        // End:0x22
        case 1:
            nResult = __NFUN_404__(A, B);
            // End:0xA1
            break;
        // End:0x3D
        case 2:
            nResult = __NFUN_405__(A, B);
            // End:0xA1
            break;
        // End:0x58
        case 3:
            nResult = __NFUN_401__(A, B);
            // End:0xA1
            break;
        // End:0x8D
        case 4:
            // End:0x77
            if(__NFUN_412__(B, (0)))
            {
                nResult = (0);                
            }
            else
            {
                nResult = __NFUN_403__(A, B);
            }
            // End:0xA1
            break;
        // End:0x9E
        case 0:
            nResult = (0);
            // End:0xA1
            break;
        // End:0xFFFF
        default:
            break;
    }
    return nResult;
    return;
}

function BackSpace()
{
    local string strTemp, strResult;
    local int iLength;

    strTemp = GetString();
    iLength = Len(strTemp) - 1;
    // End:0x47
    if(iLength > 0)
    {
        strResult = Left(strTemp, iLength);
        SetString(strResult);        
    }
    else
    {
        CE();
    }
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x27
        case 1700:
            ShowWindowWithFocus("CalculatorWnd");
            // End:0x2A
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function AddNumeric(int a_Number)
{
    local string currentNumeric;

    currentNumeric = GetString();
    // End:0x29
    if(currentNumeric == "0")
    {
        SetNumeric((a_Number));        
    }
    else
    {
        // End:0x44
        if(Len(currentNumeric) < 17)
        {
            AddString(string(a_Number));
        }
    }
    return;
}

function SetNumeric(INT64 a_Number)
{
    local DialogBox script;
    local string newNumeric;

    script = DialogBox(GetScript("DialogBox"));
    newNumeric = (a_Number);
    // End:0x45
    if(Len(newNumeric) <= 17)
    {
        SetString(newNumeric);        
    }
    else
    {
        script.ShowDialog(1, 5, GetSystemMessage(3093), "CalculatorWnd");
        CE();
    }
    return;
}

function ProcessNumeric(int a_Number)
{
    return;
}

function ProcessOperator(CalculatorWnd.EOperator a_Operator)
{
    return;
}

function ProcessEqual()
{
    return;
}

function ProcessBtn(Interactions.EInputKey ivalue)
{
    local int inputNumeric;
    local CalculatorWnd.EOperator inputOperator;

    // End:0x9F
    if(((int(48) <= int(ivalue)) && int(ivalue) <= int(57)) || (int(96) <= int(ivalue)) && int(ivalue) <= int(105))
    {
        // End:0x7E
        if((int(48) <= int(ivalue)) && int(ivalue) <= int(57))
        {
            inputNumeric = int(ivalue) - int(48);            
        }
        else
        {
            inputNumeric = int(ivalue) - int(96);
        }
        ProcessNumeric(inputNumeric);        
    }
    else
    {
        // End:0x15F
        if(((((int(ivalue) == int(106)) || int(ivalue) == int(107)) || int(ivalue) == int(109)) || int(ivalue) == int(189)) || int(ivalue) == int(111))
        {
            switch(ivalue)
            {
                // End:0x10E
                case 106:
                    inputOperator = 3;
                    // End:0x151
                    break;
                // End:0x11E
                case 107:
                    inputOperator = 1;
                    // End:0x151
                    break;
                // End:0x123
                case 109:
                // End:0x133
                case 189:
                    inputOperator = 2;
                    // End:0x151
                    break;
                // End:0x143
                case 111:
                    inputOperator = 4;
                    // End:0x151
                    break;
                // End:0xFFFF
                default:
                    inputOperator = 0;
                    // End:0x151
                    break;
                    break;
            }
            ProcessOperator(inputOperator);            
        }
        else
        {
            // End:0x18A
            if((int(ivalue) == int(13)) || int(ivalue) == int(187))
            {
                ProcessEqual();                
            }
            else
            {
                // End:0x1A3
                if(int(ivalue) == int(27))
                {
                    InitCalculator();                    
                }
                else
                {
                    // End:0x1B9
                    if(int(ivalue) == int(8))
                    {
                        BackSpace();
                    }
                }
            }
        }
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1B
        case "btn0":
            ProcessBtn(48);
            // End:0x1C6
            break;
        // End:0x2F
        case "btn1":
            ProcessBtn(49);
            // End:0x1C6
            break;
        // End:0x43
        case "btn2":
            ProcessBtn(50);
            // End:0x1C6
            break;
        // End:0x57
        case "btn3":
            ProcessBtn(51);
            // End:0x1C6
            break;
        // End:0x6B
        case "btn4":
            ProcessBtn(52);
            // End:0x1C6
            break;
        // End:0x7F
        case "btn5":
            ProcessBtn(53);
            // End:0x1C6
            break;
        // End:0x93
        case "btn6":
            ProcessBtn(54);
            // End:0x1C6
            break;
        // End:0xA7
        case "btn7":
            ProcessBtn(55);
            // End:0x1C6
            break;
        // End:0xBB
        case "btn8":
            ProcessBtn(56);
            // End:0x1C6
            break;
        // End:0xCF
        case "btn9":
            ProcessBtn(57);
            // End:0x1C6
            break;
        // End:0xE5
        case "btnAdd":
            ProcessBtn(107);
            // End:0x1C6
            break;
        // End:0xF8
        case "btnCE":
            CE();
            // End:0x1C6
            break;
        // End:0x10E
        case "btnSub":
            ProcessBtn(109);
            // End:0x1C6
            break;
        // End:0x122
        case "btnC":
            ProcessBtn(27);
            // End:0x1C6
            break;
        // End:0x138
        case "btnMul":
            ProcessBtn(106);
            // End:0x1C6
            break;
        // End:0x14D
        case "btnBS":
            ProcessBtn(8);
            // End:0x1C6
            break;
        // End:0x16A
        case "btn00":
            ProcessBtn(48);
            ProcessBtn(48);
            // End:0x1C6
            break;
        // End:0x180
        case "btnDiv":
            ProcessBtn(111);
            // End:0x1C6
            break;
        // End:0x195
        case "btnEQ":
            ProcessBtn(13);
            // End:0x1C6
            break;
        // End:0x1C3
        case "btnClose":
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("CalculatorWnd");
            // End:0x1C6
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnKeyUp(WindowHandle a_WindowHandle, Interactions.EInputKey Key)
{
    ProcessBtn(Key);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("CalculatorWnd").HideWindow();
    return;
}

auto state Operand1
{
    function ProcessNumeric(int a_Number)
    {
        AddNumeric(a_Number);
        return;
    }

    function ProcessOperator(CalculatorWnd.EOperator a_Operator)
    {
        SetOperator(a_Operator);
        SetOperand1(GetOperand());
        GotoState('ReadyForOperand2');
        return;
    }
    stop;
}

state ReadyForOperand2
{
    function ProcessNumeric(int a_Number)
    {
        SetNumeric((a_Number));
        GotoState('Operand2');
        return;
    }

    function ProcessOperator(CalculatorWnd.EOperator a_Operator)
    {
        SetOperator(a_Operator);
        SetOperand1(GetOperand());
        return;
    }

    function ProcessEqual()
    {
        SetNumeric(Calc(m_Operand1, GetOperand(), m_Operator));
        return;
    }
    stop;
}

state Operand2
{
    function ProcessNumeric(int a_Number)
    {
        AddNumeric(a_Number);
        return;
    }

    function ProcessOperator(CalculatorWnd.EOperator a_Operator)
    {
        local INT64 Result;

        Result = Calc(m_Operand1, GetOperand(), m_Operator);
        SetNumeric(Result);
        SetOperand1(Result);
        SetOperator(a_Operator);
        GotoState('ReadyForOperand2');
        return;
    }

    function ProcessEqual()
    {
        local INT64 Operand2;

        Operand2 = GetOperand();
        SetNumeric(Calc(m_Operand1, Operand2, m_Operator));
        SetOperand1(Operand2);
        GotoState('ReadyForOperand1');
        return;
    }
    stop;
}

state ReadyForOperand1
{
    function ProcessNumeric(int a_Number)
    {
        SetNumeric((a_Number));
        GotoState('Operand1');
        return;
    }

    function ProcessOperator(CalculatorWnd.EOperator a_Operator)
    {
        SetOperand1(GetOperand());
        SetOperator(a_Operator);
        GotoState('ReadyForOperand2');
        return;
    }

    function ProcessEqual()
    {
        SetNumeric(Calc(GetOperand(), m_Operand1, m_Operator));
        return;
    }
    stop;
}
