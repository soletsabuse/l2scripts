class JsonFactory extends UICommonAPI;

var array<string> keys;
var array<string> Values;

function Init()
{
    keys.Remove(0, keys.Length);
    Values.Remove(0, Values.Length);
    return;
}

function push(coerce string Key, coerce string Value)
{
    // End:0x1C
    if((Key == "") || Value == "")
    {
        return;
    }
    keys[keys.Length] = Key;
    Values[Values.Length] = Value;
    return;
}

function string Get(optional bool bReinit)
{
    local string json;
    local int i;
    local string escapedKey, escapedValue;

    // End:0x11
    if(keys.Length == 0)
    {
        return "{}";
    }
    json = "{";
    i = 0;
    J0x21:

    // End:0xB6 [Loop If]
    if(i < keys.Length)
    {
        escapedKey = clean(keys[i]);
        escapedValue = clean(Values[i]);
        json = ((((json $ "\"") $ escapedKey) $ "\":\"") $ escapedValue) $ "\"";
        // End:0xAC
        if(i < (keys.Length - 1))
        {
            json = json $ ",";
        }
        i++;
        // [Loop Continue]
        goto J0x21;
    }
    json = json $ "}";
    // End:0xD5
    if(bReinit)
    {
        Init();
    }
    return json;
    return;
}

function string asObjects(coerce optional string K1, coerce optional string O1, coerce optional string K2, coerce optional string O2, coerce optional string K3, coerce optional string O3, coerce optional string K4, coerce optional string O4)
{
    local string Objects;

    Objects = "{";
    // End:0x47
    if((K1 != "") && O1 != "")
    {
        Objects = (((Objects $ "\"") $ K1) $ "\":") $ O1;
    }
    // End:0x86
    if((K2 != "") && O2 != "")
    {
        Objects = (((Objects $ ",\"") $ K2) $ "\":") $ O2;
    }
    // End:0xC5
    if((K3 != "") && O3 != "")
    {
        Objects = (((Objects $ ",\"") $ K3) $ "\":") $ O3;
    }
    // End:0x104
    if((K4 != "") && O4 != "")
    {
        Objects = (((Objects $ ",\"") $ K4) $ "\":") $ O4;
    }
    Objects = Objects $ "}";
    return Objects;
    return;
}

function string clean(string Input)
{
    local string Result;

    Result = Input;
    Result = Locs(Result, "&", "**", false);
    return Result;
    return;
}

function bool isValidJson(string json)
{
    return (json != "") && json != "{}";
    return;
}
