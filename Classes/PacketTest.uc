class PacketTest extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle txtSend1_1;
var EditBoxHandle edSend1_1;
var ButtonHandle btnSend1_1;
var TextBoxHandle txtSend2_1;
var EditBoxHandle edSend2_1;
var ButtonHandle btnSend2_1;
var TextBoxHandle txtSend3_1;
var ButtonHandle btnSend3_1;
var TextBoxHandle txtSend4_1;
var EditBoxHandle edSend4_1;
var ButtonHandle btnSend4_1;
var TextBoxHandle txtSend5_1;
var ButtonHandle btnSend5_1;
var TextBoxHandle txtSend6_1;
var EditBoxHandle edSend6_1;
var ButtonHandle btnSend6_1;
var TextBoxHandle txtSend7_1;
var EditBoxHandle edSend7_1;
var ButtonHandle btnSend7_1;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    Initialize();
    load();
    return;
}

function Initialize()
{
    Me = GetWindowHandle("PacketTest");
    txtSend1_1 = GetTextBoxHandle("PacketTest.txtSend1_1");
    edSend1_1 = GetEditBoxHandle("PacketTest.edSend1_1");
    btnSend1_1 = GetButtonHandle("PacketTest.btnSend1_1");
    txtSend2_1 = GetTextBoxHandle("PacketTest.txtSend2_1");
    edSend2_1 = GetEditBoxHandle("PacketTest.edSend2_1");
    btnSend2_1 = GetButtonHandle("PacketTest.btnSend2_1");
    txtSend3_1 = GetTextBoxHandle("PacketTest.txtSend3_1");
    btnSend3_1 = GetButtonHandle("PacketTest.btnSend3_1");
    txtSend4_1 = GetTextBoxHandle("PacketTest.txtSend4_1");
    edSend4_1 = GetEditBoxHandle("PacketTest.edSend4_1");
    btnSend4_1 = GetButtonHandle("PacketTest.btnSend4_1");
    txtSend5_1 = GetTextBoxHandle("PacketTest.txtSend5_1");
    btnSend5_1 = GetButtonHandle("PacketTest.btnSend5_1");
    txtSend6_1 = GetTextBoxHandle("PacketTest.txtSend6_1");
    edSend6_1 = GetEditBoxHandle("PacketTest.edSend6_1");
    btnSend6_1 = GetButtonHandle("PacketTest.btnSend6_1");
    txtSend7_1 = GetTextBoxHandle("PacketTest.txtSend7_1");
    edSend7_1 = GetEditBoxHandle("PacketTest.edSend7_1");
    btnSend7_1 = GetButtonHandle("PacketTest.btnSend7_1");
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
        // End:0x1F
        case "btnSend1_1":
            OnbtnSend1_1Click();
            // End:0xB2
            break;
        // End:0x37
        case "btnSend2_1":
            OnbtnSend2_1Click();
            // End:0xB2
            break;
        // End:0x4F
        case "btnSend3_1":
            OnbtnSend3_1Click();
            // End:0xB2
            break;
        // End:0x67
        case "btnSend4_1":
            OnbtnSend4_1Click();
            // End:0xB2
            break;
        // End:0x7F
        case "btnSend5_1":
            OnbtnSend5_1Click();
            // End:0xB2
            break;
        // End:0x97
        case "btnSend6_1":
            OnbtnSend6_1Click();
            // End:0xB2
            break;
        // End:0xAF
        case "btnSend7_1":
            OnbtnSend7_1Click();
            // End:0xB2
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnbtnSend1_1Click()
{
    local int unionID;

    unionID = int(edSend1_1.GetString());
    Class'NWindow.UnionActionAPI'.static.RequestUnionJoin(unionID);
    return;
}

function OnbtnSend2_1Click()
{
    local int unionID;

    unionID = int(edSend2_1.GetString());
    Class'NWindow.UnionActionAPI'.static.RequestUnionChange(unionID);
    return;
}

function OnbtnSend3_1Click()
{
    Class'NWindow.UnionActionAPI'.static.RequestUnionWithdraw();
    return;
}

function OnbtnSend4_1Click()
{
    local int requestType;

    requestType = int(edSend4_1.GetString());
    Class'NWindow.UnionActionAPI'.static.RequestUnionRequest(requestType);
    return;
}

function OnbtnSend5_1Click()
{
    Class'NWindow.UnionActionAPI'.static.RequestUnionAdjust();
    return;
}

function OnbtnSend6_1Click()
{
    local int NpcType;

    NpcType = int(edSend6_1.GetString());
    Class'NWindow.UnionActionAPI'.static.RequestUnionSummon(NpcType);
    return;
}

function OnbtnSend7_1Click()
{
    local int NpcType;

    NpcType = int(edSend7_1.GetString());
    Class'NWindow.UnionActionAPI'.static.RequestUnionStart(NpcType);
    return;
}
