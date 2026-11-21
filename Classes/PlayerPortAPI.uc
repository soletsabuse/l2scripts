class PlayerPortAPI extends PlayerPortData
    config(Engine)
    perobjectconfig;

const Adena = 57;
const ANCIENT_ADENA = 5575;
const SEVENSIGN_STONE_BLUE = 6360;
const SEVENSIGN_STONE_GREEN = 6361;
const SEVENSIGN_STONE_RED = 6362;
const Col = 4037;
const Minute = 60000;
const TWOMIN = 120000;
const THREEMIN = 180000;
const FOURMIN = 240000;
const FIVEMIN = 300000;
const REQUEST_TIMEOUT = 10001;
const SOFT_UNSET = 10002;
const SOFT_UNSET_START_SEC = 60;
const THE_CONNECTION_WITH_THE_SERVER_IS_LOST = 0;
const YOU_HAVE_BEEN_DISCONNECTED_FROM_THE_SERVER = 127;
const THE_SERVER_WILL_BE_COMING_DOWN_IN_S1_SECONDS = 1;

enum CHAT
{
    C_PRIVATE,                      // 0
    C_White,                        // 1
    C_SHOUT,                        // 2
    C_TRADE,                        // 3
    C_PARTY,                        // 4
    C_CLAN,                         // 5
    C_ALLIANCE,                     // 6
    C_HERO,                         // 7
    C_WORLD,                        // 8
    C_ADMIN,                        // 9
    C_JAVA_COMMAND                  // 10
};

struct SubjobInfo
{
    var int Id;
    var int ClassID;
    var int Level;
    var int Type;
};

struct postPlayer
{
    var string receivedPerson;
    var string Title;
    var string contents;
    var int safeMail;
    var INT64 nAdena;
    var array<ItemInfo> itemList;
};

struct tradePlayer
{
    var UserInfo Player;
    var int isFriend;
    var int isPledge;
    var int isMentoring;
    var int isAlliance;
    var int isGM;
};

struct iServerPlayerData
{
    var string key1;
    var string key1C;
    var string key2;
};

struct iServerItem
{
    var int Id;
    var string Name;
    var int CharCnt;
    var int IsClassicServer;
    var int IsAdenServer;
};

struct iServerInfo
{
    var int selected;
    var int Num;
    var array<iServerItem> List;
};

var UserInfo Owner;
var JsonFactory json;
var UserInfo prevUserInfo;
var UserInfo currUserInfo;
var globalconfig iServerInfo ServerInfo;
var globalconfig iServerItem targetServerInfo;
var string serverAddress;
var string windowsName;
var string ROOTNAME;
var string driveLine;
var array<string> vals;
var bool isUpdateAvailable;
var bool isServerShutdownOrRestart;
var int nPremiumState;
var int nClanPoints;
var int nZoneCode;
var int nExtraWorldChattingCnt;
var int nSelectedServer;
var int REQUEST_TIMEOUT_DELAY;
var postPlayer currentPostInfo;
var tradePlayer currentTradeInfo;

function swapPrevUserInfo()
{
    prevUserInfo = currUserInfo;
    GetPlayerInfo(currUserInfo);
    return;
}

function clearTradeInfo()
{
    local tradePlayer clearTradeInfo;

    currentTradeInfo = clearTradeInfo;
    return;
}

function clearPostInfo()
{
    local postPlayer clearPostInfo;

    currentPostInfo = clearPostInfo;
    return;
}

function bool isCorrectUser()
{
    // End:0x12
    if(Owner.nID < 1)
    {
        return false;
    }
    // End:0x26
    if(Len(Owner.Name) <= 0)
    {
        return false;
    }
    return true;
    return;
}

function bool isCorrectState()
{
    switch(GetUIState())
    {
        // End:0x27
        case "GAMINGSTATE":
            return IsShowWindow("ExpBar");
        // End:0xFFFF
        default:
            // End:0x2D
            break;
            break;
    }
    return;
}

function showAnotherWeb(string URL, int Width, int Height, string targetPoint, string AnchorPoint, int oX, int oY)
{
    local IngameWebWnd IngameWeb;
    local WindowHandle IngameWebWnd;
    local WebBrowserHandle WebBrowserHandle;

    IngameWeb = IngameWebWnd(GetScript("IngameWebWnd"));
    IngameWebWnd = GetWindowHandle("IngameWebWnd");
    WebBrowserHandle = GetWebBrowserHandle("IngameWebWnd.WebBrowser");
    IngameWebWnd.SetWindowSize(Width + 60, Height + 60);
    WebBrowserHandle.SetWindowSize(Width + 60, (Height + 60) - 35);
    IngameWebWnd.SetAnchor("", targetPoint, AnchorPoint, oX, oY);
    IngameWebWnd.ClearAnchor();
    WebBrowserHandle.SetAnchor("IngameWebWnd", "TopCenter", "TopCenter", 0, 35);
    WebBrowserHandle.NavigateAsGet(URL);
    IngameWebWnd.ShowWindow();
    IngameWebWnd.SetFocus();
    return;
}

function morphAnotherWeb(string param)
{
    local IngameWebWnd IngameWeb;
    local WindowHandle IngameWebWnd;
    local WebBrowserHandle WebBrowserHandle;
    local int Width, Height;

    ParseInt(param, "width", Width);
    ParseInt(param, "height", Height);
    IngameWeb = IngameWebWnd(GetScript("IngameWebWnd"));
    IngameWebWnd = GetWindowHandle("IngameWebWnd");
    WebBrowserHandle = GetWebBrowserHandle("IngameWebWnd.WebBrowser");
    IngameWebWnd.SetWindowSize(Width + 60, Height + 60);
    WebBrowserHandle.SetWindowSize(Width + 60, (Height + 60) - 35);
    IngameWebWnd.ClearAnchor();
    WebBrowserHandle.SetAnchor("IngameWebWnd", "TopCenter", "TopCenter", 0, 35);
    return;
}

function bool textnormalize(out string InputText, optional out string reciever, optional out byte ChatType)
{
    local int i;
    local string Result;
    local bool SkipSpace, bPrivate, HasNonSpace;
    local array<string> words;

    InputText = ToLower(InputText);
    // End:0xCB
    if(Left(InputText, 1) == "\"")
    {
        words = Arr(InputText, " ");
        bPrivate = ((Len(InputText) > Len(words[0])) && InputText != (words[0] $ "")) && InputText != (words[0] $ " ");
        // End:0xC8
        if(bPrivate)
        {
            InputText = Right(InputText, Len(InputText) - Len(words[0]));
            reciever = Right(words[0], Len(words[0]) - 1);
            ChatType = 0;
        }        
    }
    else
    {
        // End:0xFD
        if(Left(InputText, 1) == "!")
        {
            InputText = Right(InputText, Len(InputText) - 1);
            ChatType = 2;            
        }
        else
        {
            // End:0x12F
            if(Left(InputText, 1) == "+")
            {
                InputText = Right(InputText, Len(InputText) - 1);
                ChatType = 3;                
            }
            else
            {
                // End:0x16F
                if(Left(InputText, 1) == "#")
                {
                    InputText = Right(InputText, Len(InputText) - 1);
                    ChatType = 4;
                    // End:0x16C
                    if((GetPartyMemberCount()) <= 0)
                    {
                        return false;
                    }                    
                }
                else
                {
                    // End:0x1B3
                    if(Left(InputText, 1) == "@")
                    {
                        InputText = Right(InputText, Len(InputText) - 1);
                        ChatType = 5;
                        // End:0x1B0
                        if(Owner.nClanID <= 0)
                        {
                            return false;
                        }                        
                    }
                    else
                    {
                        // End:0x1F7
                        if(Left(InputText, 1) == "$")
                        {
                            InputText = Right(InputText, Len(InputText) - 1);
                            ChatType = 6;
                            // End:0x1F4
                            if(Owner.nAllianceID <= 0)
                            {
                                return false;
                            }                            
                        }
                        else
                        {
                            // End:0x23B
                            if(Left(InputText, 1) == "%")
                            {
                                InputText = Right(InputText, Len(InputText) - 1);
                                ChatType = 7;
                                // End:0x238
                                if(!Owner.bHero)
                                {
                                    return false;
                                }                                
                            }
                            else
                            {
                                // End:0x27A
                                if(Left(InputText, 1) == "&")
                                {
                                    InputText = Right(InputText, Len(InputText) - 1);
                                    ChatType = 8;
                                    // End:0x277
                                    if(nExtraWorldChattingCnt > 0)
                                    {
                                        return false;
                                    }                                    
                                }
                                else
                                {
                                    // End:0x2BC
                                    if(Left(InputText, 2) == "//")
                                    {
                                        InputText = Right(InputText, Len(InputText) - 2);
                                        ChatType = 9;
                                        // End:0x2B9
                                        if(!IsBuilderPC())
                                        {
                                            return false;
                                        }                                        
                                    }
                                    else
                                    {
                                        // End:0x2EE
                                        if(Left(InputText, 1) == ".")
                                        {
                                            InputText = Right(InputText, Len(InputText) - 1);
                                            ChatType = 10;                                            
                                        }
                                        else
                                        {
                                            ChatType = 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Result = "";
    SkipSpace = false;
    HasNonSpace = false;
    i = 0;
    J0x315:

    // End:0x395 [Loop If]
    if(i < Len(InputText))
    {
        // End:0x361
        if(Mid(InputText, i, 1) == " ")
        {
            // End:0x35E
            if(!SkipSpace)
            {
                Result = Result $ " ";
                SkipSpace = true;
            }
            // [Explicit Continue]
            goto J0x38B;
        }
        Result = Result $ Mid(InputText, i, 1);
        SkipSpace = false;
        HasNonSpace = true;
        J0x38B:

        i++;
        // [Loop Continue]
        goto J0x315;
    }
    // End:0x3A2
    if(!HasNonSpace)
    {
        return false;
    }
    // End:0x3B1
    if(int(ChatType) < 0)
    {
        return false;
    }
    return true;
    return;
}

function bool isCorrectCommand(string Str)
{
    // End:0x12
    if(Left(Str, 1) != "/")
    {
        return true;
    }
    // End:0x26
    if(Left(Str, 2) == "//")
    {
        return true;
    }
    // End:0x3B
    if(Left(Str, 3) == "///")
    {
        return true;
    }
    // End:0x5D
    if(Left(Str, Len("/gmlist")) == "/gmlist")
    {
        return true;
    }
    // End:0x77
    if(Left(Str, Len("/gm")) == "/gm")
    {
        return true;
    }
    // End:0x9B
    if(Left(Str, Len("/unstuck")) == "/unstuck")
    {
        return true;
    }
    // End:0xC1
    if(Left(Str, Len("/allblock")) == "/allblock")
    {
        return true;
    }
    // End:0xEB
    if(Left(Str, Len("/allunblock")) == "/allunblock")
    {
        return true;
    }
    // End:0x10B
    if(Left(Str, Len("/block")) == "/block")
    {
        return true;
    }
    // End:0x139
    if(Left(Str, Len("/olympiadstat")) == "/olympiadstat")
    {
        return true;
    }
    // End:0x15D
    if(Left(Str, Len("/unstuck")) == "/unstuck")
    {
        return true;
    }
    // End:0x18B
    if(Left(Str, Len("/olympiadstat")) == "/olympiadstat")
    {
        return true;
    }
    return;
}

function bool isEmptyMessage(string Str)
{
    // End:0x0F
    if(Len(Str) <= 0)
    {
        return true;
    }
    switch(Str)
    {
        // End:0x1C
        case " ":
        // End:0x22
        case "	":
        // End:0x28
        case "!":
        // End:0x2E
        case "#":
        // End:0x34
        case "@":
        // End:0x3A
        case "^":
        // End:0x40
        case "<":
        // End:0x46
        case ">":
        // End:0x4C
        case "/":
        // End:0x53
        case "//":
        // End:0x59
        case ".":
        // End:0x5F
        case ",":
        // End:0x65
        case "&":
        // End:0x6B
        case "`":
        // End:0x71
        case "*":
        // End:0x77
        case ":":
        // End:0x80
        case "Â·":
        // End:0x86
        case "_":
        // End:0x8C
        case "]":
        // End:0x92
        case "|":
        // End:0x98
        case "[":
        // End:0x9F
        case "[]":
        // End:0xA5
        case "}":
        // End:0xAB
        case "{":
        // End:0xB2
        case "{}":
        // End:0xB9
        case "][":
        // End:0xC1
        case "\\":
            return true;
        // End:0xFFFF
        default:
            // End:0xC7
            break;
            break;
    }
    return;
}

function setParam(out string param, string paramName, string paramValue)
{
    // End:0x32
    if(param != "")
    {
        param = (((param $ "	") $ paramName) $ "=") $ paramValue;        
    }
    else
    {
        param = (paramName $ "=") $ paramValue;
    }
    return;
}

function string getFromArray(string param, string Key)
{
    local int i;
    local array<string> a1, a2;

    a1 = Arr(param, " ");
    // End:0x81
    if(a1.Length > 0)
    {
        i = 0;
        J0x27:

        // End:0x81 [Loop If]
        if(i < a1.Length)
        {
            a2 = Arr(a1[i], "=");
            // End:0x77
            if(a2.Length == 2)
            {
                // End:0x77
                if(a2[0] == Key)
                {
                    return a2[1];
                }
            }
            i++;
            // [Loop Continue]
            goto J0x27;
        }
    }
    return;
}

function int imLeader()
{
    return int(PartyWnd(GetScript("PartyWnd")).PartyLeaderID == Owner.nID);
    return;
}

function bool isRealDrive(string driveName)
{
    return (DrivesToNumeric(driveName)) > -1;
    return;
}

function int DrivesToNumeric(string drive)
{
    drive = Locs(drive, "\\", "", false);
    drive = Locs(drive, " ", "", false);
    switch(drive)
    {
        // End:0x36
        case "A:":
            return 0;
        // End:0x3F
        case "B:":
            return 1;
        // End:0x49
        case "C:":
            return 2;
        // End:0x53
        case "D:":
            return 3;
        // End:0x5D
        case "E:":
            return 4;
        // End:0x67
        case "F:":
            return 5;
        // End:0x71
        case "G:":
            return 6;
        // End:0x7B
        case "H:":
            return 7;
        // End:0x85
        case "I:":
            return 8;
        // End:0x8F
        case "J:":
            return 9;
        // End:0x99
        case "K:":
            return 10;
        // End:0xA3
        case "L:":
            return 11;
        // End:0xAD
        case "M:":
            return 12;
        // End:0xB7
        case "N:":
            return 13;
        // End:0xC1
        case "O:":
            return 14;
        // End:0xCB
        case "P:":
            return 15;
        // End:0xD5
        case "Q:":
            return 16;
        // End:0xDF
        case "R:":
            return 17;
        // End:0xE9
        case "S:":
            return 18;
        // End:0xF3
        case "T:":
            return 19;
        // End:0xFD
        case "U:":
            return 20;
        // End:0x107
        case "V:":
            return 21;
        // End:0x111
        case "W:":
            return 22;
        // End:0x11B
        case "X:":
            return 23;
        // End:0x125
        case "Y:":
            return 24;
        // End:0x12F
        case "Z:":
            return 25;
        // End:0xFFFF
        default:
            return -1;
            break;
    }    
    return;
}

function string removeSpaces(string S)
{
    local string clean;

    clean = S;
    clean = Locs(clean, " ", "", false);
    return clean;
    return;
}

function string ConcatDrives()
{
    local int i;
    local array<DriveInfo> L;

    L = GetDrivesInfoList();
    driveLine = "";
    driveLine = string(DrivesToNumeric(L[i].driveChar));
    i = 1;
    J0x39:

    // End:0x7D [Loop If]
    if(i < L.Length)
    {
        driveLine = (driveLine $ ",") $ string(DrivesToNumeric(L[i].driveChar));
        i++;
        // [Loop Continue]
        goto J0x39;
    }
    return;
}

function explodeRootName()
{
    local int i, startIndex;
    local string Result, Path;
    local array<string> vals;

    Path = removeSpaces(GetL2Path());
    vals = Arr(Path, "\\");
    // End:0x40
    if(vals.Length <= 5)
    {
        ROOTNAME = Path;
        return;
    }
    startIndex = vals.Length - 5;
    Result = vals[startIndex];
    i = startIndex + 1;
    J0x6F:

    // End:0xA6 [Loop If]
    if(i < vals.Length)
    {
        Result = (Result $ "\\") $ vals[i];
        i++;
        // [Loop Continue]
        goto J0x6F;
    }
    ROOTNAME = Result;
    return;
}

function explodeUserName()
{
    local string DescPath, DocsPath;
    local array<string> vals1, vals2;

    DescPath = GetDesktopPath();
    DocsPath = GetMydocumentPath();
    windowsName = DescPath;
    vals1 = Arr(DescPath, "\\");
    vals2 = Arr(DocsPath, "\\");
    // End:0x6C
    if(isRealDrive(vals1[0]))
    {
        windowsName = vals1[2];        
    }
    else
    {
        // End:0x8A
        if(isRealDrive(vals2[0]))
        {
            windowsName = vals2[2];
        }
    }
    return;
}

function bool insertServer(iServerItem Info)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x62 [Loop If]
    if(i < ServerInfo.List.Length)
    {
        // End:0x58
        if(ServerInfo.List[i].Id == Info.Id)
        {
            ServerInfo.List[i] = Info;
            return false;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    ServerInfo.List[ServerInfo.List.Length] = Info;
    return true;
    return;
}

function iServerItem getSelectedServerInfo(int Id)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x56 [Loop If]
    if(i < ServerInfo.List.Length)
    {
        // End:0x4C
        if(ServerInfo.List[i].Id == Id)
        {
            return ServerInfo.List[i];
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return;
}

function string getSessionFormatTime(coerce int nTime)
{
    return (getInstanceL2Util().makeZeroString(2, (nTime / 60)) $ ":") $ getInstanceL2Util().makeZeroString(2, (int(float(nTime) % float(60))));
    return;
}

function int isLevelChanged()
{
    local int prevLevel, currLevel, diff;

    prevLevel = prevUserInfo.nLevel;
    currLevel = currUserInfo.nLevel;
    diff = currLevel - prevLevel;
    // End:0x48
    if(diff < 0)
    {
        return -diff;        
    }
    else
    {
        return diff;
    }
    return;
}

function string GetUIVersionCodename(int Index)
{
    Index = Clamp(Index, 0, 200);
    switch(Index)
    {
        // End:0x22
        case 0:
            return "Cora";
        // End:0x2D
        case 1:
            return "Nova";
        // End:0x39
        case 2:
            return "Lyra";
        // End:0x45
        case 3:
            return "Zara";
        // End:0x50
        case 4:
            return "Nyx";
        // End:0x5C
        case 5:
            return "Kira";
        // End:0x68
        case 6:
            return "Vega";
        // End:0x74
        case 7:
            return "Rhea";
        // End:0x80
        case 8:
            return "Aria";
        // End:0x8D
        case 9:
            return "Freya";
        // End:0x9B
        case 10:
            return "Selene";
        // End:0xA7
        case 11:
            return "Iris";
        // End:0xB3
        case 12:
            return "Juno";
        // End:0xBF
        case 13:
            return "Thea";
        // End:0xCB
        case 14:
            return "Gaia";
        // End:0xD7
        case 15:
            return "Nika";
        // End:0xE3
        case 16:
            return "Sora";
        // End:0xEF
        case 17:
            return "Veda";
        // End:0xFB
        case 18:
            return "Mira";
        // End:0x107
        case 19:
            return "Luna";
        // End:0x114
        case 20:
            return "Elara";
        // End:0x122
        case 21:
            return "Thalia";
        // End:0x12F
        case 22:
            return "Astra";
        // End:0x13A
        case 23:
            return "Eos";
        // End:0x148
        case 24:
            return "Phoebe";
        // End:0x154
        case 25:
            return "Clio";
        // End:0x160
        case 26:
            return "Maia";
        // End:0x16C
        case 27:
            return "Kaia";
        // End:0x179
        case 28:
            return "Talia";
        // End:0x185
        case 29:
            return "Zora";
        // End:0x191
        case 30:
            return "Neva";
        // End:0x19E
        case 31:
            return "Amara";
        // End:0x1AA
        case 32:
            return "Elia";
        // End:0x1B7
        case 33:
            return "Liora";
        // End:0x1C4
        case 34:
            return "Seris";
        // End:0x1D0
        case 35:
            return "Yara";
        // End:0x1DC
        case 36:
            return "Ziva";
        // End:0x1E8
        case 37:
            return "Ayla";
        // End:0x1F5
        case 38:
            return "Brynn";
        // End:0x203
        case 39:
            return "Celine";
        // End:0x210
        case 40:
            return "Delia";
        // End:0x21C
        case 41:
            return "Eira";
        // End:0x229
        case 42:
            return "Fable";
        // End:0x236
        case 43:
            return "Gemma";
        // End:0x243
        case 44:
            return "Haven";
        // End:0x24F
        case 45:
            return "Isla";
        // End:0x25B
        case 46:
            return "Jada";
        // End:0x268
        case 47:
            return "Livia";
        // End:0x275
        case 48:
            return "Mavis";
        // End:0x281
        case 49:
            return "Nola";
        // End:0x28D
        case 50:
            return "Opal";
        // End:0x29A
        case 51:
            return "Pippa";
        // End:0x2A7
        case 52:
            return "Quinn";
        // End:0x2B4
        case 53:
            return "Riven";
        // End:0x2C1
        case 54:
            return "Sable";
        // End:0x2CD
        case 55:
            return "Tove";
        // End:0x2D8
        case 56:
            return "Uma";
        // End:0x2E6
        case 57:
            return "Vesper";
        // End:0x2F2
        case 58:
            return "Wren";
        // End:0x2FE
        case 59:
            return "Xena";
        // End:0x30C
        case 60:
            return "Zinnia";
        // End:0x318
        case 61:
            return "Alba";
        // End:0x325
        case 62:
            return "Briar";
        // End:0x332
        case 63:
            return "Calla";
        // End:0x33F
        case 64:
            return "Ember";
        // End:0x34B
        case 65:
            return "Faye";
        // End:0x357
        case 66:
            return "Halo";
        // End:0x363
        case 67:
            return "Ione";
        // End:0x36F
        case 68:
            return "Jett";
        // End:0x37C
        case 69:
            return "Lumen";
        // End:0x388
        case 70:
            return "Myra";
        // End:0x394
        case 71:
            return "Noir";
        // End:0x3A0
        case 72:
            return "Orla";
        // End:0x3AD
        case 73:
            return "Petra";
        // End:0x3BA
        case 74:
            return "Quill";
        // End:0x3C6
        case 75:
            return "Suki";
        // End:0x3D4
        case 76:
            return "Tindra";
        // End:0x3DF
        case 77:
            return "Una";
        // End:0x3EB
        case 78:
            return "Vada";
        // End:0x3F9
        case 79:
            return "Winter";
        // End:0x407
        case 80:
            return "Xanthe";
        // End:0x415
        case 81:
            return "Zephyr";
        // End:0x424
        case 82:
            return "Aveline";
        // End:0x431
        case 83:
            return "Calyx";
        // End:0x43F
        case 84:
            return "Elowen";
        // End:0x44C
        case 85:
            return "Fenna";
        // End:0x45A
        case 86:
            return "Galene";
        // End:0x467
        case 87:
            return "Helia";
        // End:0x473
        case 88:
            return "Idun";
        // End:0x47F
        case 89:
            return "Jora";
        // End:0x48D
        case 90:
            return "Ksenia";
        // End:0x499
        case 91:
            return "Luma";
        // End:0x4A6
        case 92:
            return "Niamh";
        // End:0x4B4
        case 93:
            return "Ondine";
        // End:0x4C3
        case 94:
            return "Reverie";
        // End:0x4D0
        case 95:
            return "Solvi";
        // End:0x4DE
        case 96:
            return "Tamsin";
        // End:0x4EC
        case 97:
            return "Ulrika";
        // End:0x4FA
        case 98:
            return "Vionna";
        // End:0x507
        case 99:
            return "Wylda";
        // End:0x514
        case 100:
            return "Aelin";
        // End:0x520
        case 101:
            return "Cyra";
        // End:0x52E
        case 102:
            return "Daener";
        // End:0x53B
        case 103:
            return "Elune";
        // End:0x548
        case 104:
            return "Faora";
        // End:0x556
        case 105:
            return "Hecate";
        // End:0x565
        case 106:
            return "Illyria";
        // End:0x572
        case 107:
            return "Jaela";
        // End:0x580
        case 108:
            return "Lirien";
        // End:0x58E
        case 109:
            return "Morwen";
        // End:0x59C
        case 110:
            return "Naevia";
        // End:0x5AA
        case 111:
            return "Oriane";
        // End:0x5B6
        case 112:
            return "Pyra";
        // End:0x5C3
        case 113:
            return "Rhian";
        // End:0x5D1
        case 114:
            return "Siofra";
        // End:0x5DE
        case 115:
            return "Taiga";
        // End:0x5EA
        case 116:
            return "Ursa";
        // End:0x5F6
        case 117:
            return "Veya";
        // End:0x603
        case 118:
            return "Wynne";
        // End:0x610
        case 119:
            return "Yenne";
        // End:0x61C
        case 120:
            return "Auri";
        // End:0x62A
        case 121:
            return "Dextra";
        // End:0x637
        case 122:
            return "Elira";
        // End:0x644
        case 123:
            return "Faune";
        // End:0x651
        case 124:
            return "Glace";
        // End:0x65D
        case 125:
            return "Hira";
        // End:0x66A
        case 126:
            return "Ivara";
        // End:0x676
        case 127:
            return "Jinx";
        // End:0x682
        case 128:
            return "Kiva";
        // End:0x68F
        case 129:
            return "Mythe";
        // End:0x69A
        case 130:
            return "Nix";
        // End:0x6A6
        case 131:
            return "Oryx";
        // End:0x6B4
        case 132:
            return "Quorra";
        // End:0x6BF
        case 133:
            return "Ryn";
        // End:0x6CC
        case 134:
            return "Sylva";
        // End:0x6D8
        case 135:
            return "Teya";
        // End:0x6E3
        case 136:
            return "Umi";
        // End:0x6EE
        case 137:
            return "Vyx";
        // End:0x6FA
        case 138:
            return "Wera";
        // End:0x706
        case 139:
            return "Xira";
        // End:0x711
        case 140:
            return "Yva";
        // End:0x71D
        case 141:
            return "Aera";
        // End:0x729
        case 142:
            return "Brea";
        // End:0x735
        case 143:
            return "Cira";
        // End:0x741
        case 144:
            return "Duna";
        // End:0x74C
        case 145:
            return "Ena";
        // End:0x758
        case 146:
            return "Fira";
        // End:0x765
        case 147:
            return "Gwyne";
        // End:0x771
        case 148:
            return "Haze";
        // End:0x77C
        case 149:
            return "Ila";
        // End:0x788
        case 150:
            return "Kael";
        // End:0x794
        case 151:
            return "Myne";
        // End:0x79F
        case 152:
            return "Nua";
        // End:0x7AA
        case 153:
            return "Ova";
        // End:0x7B6
        case 154:
            return "Pyre";
        // End:0x7C2
        case 155:
            return "Sira";
        // End:0x7CE
        case 156:
            return "Tora";
        // End:0x7D9
        case 157:
            return "Ura";
        // End:0x7E5
        case 158:
            return "Vela";
        // End:0x7F0
        case 159:
            return "Wyn";
        // End:0x7FB
        case 160:
            return "Xea";
        // End:0x806
        case 161:
            return "Yna";
        // End:0x812
        case 162:
            return "Zela";
        // End:0x81E
        case 163:
            return "Cael";
        // End:0x82A
        case 164:
            return "Dira";
        // End:0x835
        case 165:
            return "Fyn";
        // End:0x841
        case 166:
            return "Gaea";
        // End:0x84D
        case 167:
            return "Jael";
        // End:0x859
        case 168:
            return "Lira";
        // End:0x864
        case 169:
            return "Myn";
        // End:0x86F
        case 170:
            return "Nys";
        // End:0x87A
        case 171:
            return "Ora";
        // End:0x886
        case 172:
            return "Pria";
        // End:0x892
        case 173:
            return "Sola";
        // End:0x89D
        case 174:
            return "Tyn";
        // End:0x8A8
        case 175:
            return "Vyn";
        // End:0x8B4
        case 176:
            return "Xora";
        // End:0x8C0
        case 177:
            return "Yael";
        // End:0x8CB
        case 178:
            return "Zyn";
        // End:0x8D9
        case 179:
            return "Vesper";
        // End:0x8E6
        case 180:
            return "Raven";
        // End:0x8F2
        case 181:
            return "Hawk";
        // End:0x901
        case 182:
            return "Phoenix";
        // End:0x90F
        case 183:
            return "Sirius";
        // End:0x91C
        case 184:
            return "Rigel";
        // End:0x92A
        case 185:
            return "Altair";
        // End:0x93A
        case 186:
            return "Obsidian";
        // End:0x946
        case 187:
            return "Onyx";
        // End:0x952
        case 188:
            return "Jade";
        // End:0x95F
        case 189:
            return "Topaz";
        // End:0x96D
        case 190:
            return "Quartz";
        // End:0x979
        case 191:
            return "Neon";
        // End:0x986
        case 192:
            return "Xenon";
        // End:0x993
        case 193:
            return "Helix";
        // End:0x9A0
        case 194:
            return "Orion";
        // End:0x9AD
        case 195:
            return "Atlas";
        // End:0x9BA
        case 196:
            return "Titan";
        // End:0x9C6
        case 197:
            return "Loki";
        // End:0x9D2
        case 198:
            return "Thor";
        // End:0x9DE
        case 199:
            return "Zeus";
        // End:0x9EA
        case 200:
            return "Apex";
        // End:0xFFFF
        default:
            return "Unknown";
            break;
    }    
    return;
}

defaultproperties
{
    REQUEST_TIMEOUT_DELAY=30000
}