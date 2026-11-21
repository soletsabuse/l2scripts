class Sample extends GFxUIScript;

var string testMember;
var Sample sampleWnd;

function OnRegisterEvent()
{
    RegisterGFxEvent(77777);
    return;
}

function OnLoad()
{
    testMember = "testMember uc µ•¿Ã≈∏";
    SetClosingOnESC();
    RegisterState("Sample", "GamingState");
    SetContainer("ContainerWindow");
    SetStateChangeNotification();
    sampleWnd = Sample(GetScript("Sample"));
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    Debug(("sampe's onCallUCFunction" @ functionName) @ param);
    switch(functionName)
    {
        // End:0x52
        case "ouputCheck":
            ouputCheck(param);
            // End:0x55
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function ouputCheck(string param)
{
    local GFxValue obj;
    local string test1;
    local int test2;
    local float test3;
    local bool test4;
    local string data1, data2, data3, data4;

    PlayConsoleSound(15);
    AllocGFxValue(obj);
    ParseString(param, "d1", data1);
    ParseString(param, "d2", data2);
    ParseString(param, "d3", data3);
    ParseString(param, "d4", data4);
    Debug("sample.GetVariable" @ string(sampleWnd.GetVariable(obj, "getValTest1")));
    test1 = obj.GetString();
    Debug("sample.GetVariable" @ string(sampleWnd.GetVariable(obj, "getValTest2")));
    test2 = obj.GetInt();
    Debug("sample.GetVariable" @ string(sampleWnd.GetVariable(obj, "getValTest3")));
    test3 = obj.GetFloat();
    Debug("sample.GetVariable" @ string(sampleWnd.GetVariable(obj, "getValTest4")));
    test4 = obj.GetBool();
    Debug(((((((("ouputCheck" @ data1) @ test1) @ data2) @ string(test2)) @ data3) @ string(test3)) @ data4) @ string(test4));
    DeallocGFxValue(obj);
    return;
}
