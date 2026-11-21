class L2UITween extends UICommonAPI;

const TWEENEND = "tweenEnd";
const SHAKEEND = "shakeEnd";

enum easeType
{
    IN_STRONG,                      // 0
    OUT_STRONG,                     // 1
    INOUT_STRONG,                   // 2
    IN_BOUNCE,                      // 3
    OUT_BOUNCE,                     // 4
    INOUT_BOUNCE,                   // 5
    IN_ELASTIC,                     // 6
    OUT_ELASTIC,                    // 7
    INOUT_ELASTIC,                  // 8
    EASENONE                        // 9
};

enum directionType
{
    big,                            // 0
    small                           // 1
};

struct TweenObject
{
    var WindowHandle Target;
    var string Owner;
    var int Id;
    var float Position;
    var float Duration;
    var float Delay;
    var int sizeXStart;
    var int sizeYStart;
    var float MoveX;
    var float MoveY;
    var float Alpha;
    var float SizeX;
    var float SizeY;
    var int alphaStart;
    var int PosX;
    var int PosY;
    var int ease;
    var bool tweenStarted;
};

struct ShakeObject
{
    var WindowHandle Target;
    var string Owner;
    var int Id;
    var float Position;
    var float Duration;
    var float Delay;
    var float shakeSize;
    var int PosX;
    var int PosY;
    var bool shakeStarted;
    var L2UITween.directionType direction;
};

var WindowHandle Me;
var private float lastAppSeconds;
var private INT64 lastAppMilliSeconds;
var array<L2UITweenObject> tweenObjects;
var array<L2UITweenTwinkleObject> twinkleObjects;
var array<ShakeObject> shakeObjects;
var bool isTickOn;
var int msTime;

static function L2UITween Inst()
{
    return L2UITween(GetScript("L2UITween"));
    return;
}

event OnLoad()
{
    Me = GetWindowHandle("L2UITween");
    return;
}

event OnTick()
{
    local float DeltaTime;

    DeltaTime = (GetDeltaMilliTime()) / float(1000);
    SetLastAppMilliSeconds();
    // End:0x34
    if(twinkleObjects.Length > 0)
    {
        UpdatePositionTwinkle(DeltaTime);
    }
    // End:0x4B
    if(tweenObjects.Length > 0)
    {
        UpdatePosition(DeltaTime);
    }
    // End:0x62
    if(shakeObjects.Length > 0)
    {
        UpdatePositionShake(DeltaTime);
    }
    CheckTickEnable();
    return;
}

private function SetLastAppMilliSeconds()
{
    lastAppMilliSeconds = (msTime);
    return;
}

private function INT64 GetDeltaMilliTime()
{
    return __NFUN_405__((msTime), lastAppMilliSeconds);
    return;
}

function OnTimer(int tID)
{
    msTime++;
    return;
}

private function TickOn()
{
    // End:0x0B
    if(isTickOn)
    {
        return;
    }
    msTime = 0;
    Me.KillTimer(1001);
    Me.SetTimer(1001, 1);
    isTickOn = true;
    Me.EnableTick();
    SetLastAppMilliSeconds();
    return;
}

private function TickOff()
{
    // End:0x0D
    if(!isTickOn)
    {
        return;
    }
    msTime = 0;
    Me.KillTimer(1001);
    isTickOn = false;
    Me.DisableTick();
    return;
}

private function CheckTickEnable()
{
    // End:0x0E
    if(tweenObjects.Length > 0)
    {
        return;
    }
    // End:0x1C
    if(shakeObjects.Length > 0)
    {
        return;
    }
    // End:0x2A
    if(twinkleObjects.Length > 0)
    {
        return;
    }
    TickOff();
    return;
}

function Add(string TargetName, string Owner, int Id, int ease, float Duration, float Alpha, float MoveX, float MoveY, float SizeX, float SizeY, optional float Delay)
{
    local TweenObject tweenObj;

    tweenObj.Position = 0.0000000;
    tweenObj.Delay = Delay;
    tweenObj.Target = GetWindowHandle(TargetName);
    tweenObj.Owner = Owner;
    tweenObj.Id = Id;
    tweenObj.ease = ease;
    tweenObj.Duration = Duration;
    tweenObj.Alpha = Alpha;
    tweenObj.MoveX = MoveX;
    tweenObj.MoveY = MoveY;
    tweenObj.SizeX = SizeX;
    tweenObj.SizeY = SizeY;
    AddTweenObject(tweenObj);
    return;
}

function AddTweenObject(TweenObject tweenObj)
{
    local L2UITweenObject l2uiTweenObj;

    l2uiTweenObj = new Class'Interface.L2UITweenObject';
    tweenObj.Position = 0.0000000;
    l2uiTweenObj.Position = tweenObj.Position;
    l2uiTweenObj.Delay = tweenObj.Delay;
    l2uiTweenObj.Target = tweenObj.Target;
    l2uiTweenObj.Owner = tweenObj.Owner;
    l2uiTweenObj.Id = tweenObj.Id;
    l2uiTweenObj.ease = tweenObj.ease;
    l2uiTweenObj.Duration = tweenObj.Duration;
    l2uiTweenObj.Alpha = tweenObj.Alpha;
    l2uiTweenObj.MoveX = tweenObj.MoveX;
    l2uiTweenObj.MoveY = tweenObj.MoveY;
    l2uiTweenObj.SizeX = tweenObj.SizeX;
    l2uiTweenObj.SizeY = tweenObj.SizeY;
    SetStartValue(l2uiTweenObj);
    TickOn();
    tweenObjects[tweenObjects.Length] = l2uiTweenObj;
    return;
}

function StopTween(string Owner, int Id)
{
    local int Index;

    Index = GetTweenObjectIndex(Owner, Id);
    // End:0x31
    if(Index != -1)
    {
        tweenObjects.Remove(Index, 1);
    }
    return;
}

function _Pause(string Owner, int Id)
{
    local int Index;

    Index = GetTweenObjectIndex(Owner, Id);
    // End:0x3A
    if(Index != -1)
    {
        tweenObjects[Index]._Pause();
    }
    return;
}

function _Play(string Owner, int Id)
{
    local int Index;

    Index = GetTweenObjectIndex(Owner, Id);
    // End:0x3A
    if(Index != -1)
    {
        tweenObjects[Index]._Play();
    }
    return;
}

private function SetStartValue(out L2UITweenObject tweenObjectData)
{
    local Rect rectWnd, rectWndParent;

    rectWnd = tweenObjectData.Target.GetRect();
    rectWndParent = tweenObjectData.Target.GetParentWindowHandle().GetRect();
    tweenObjectData.alphaStart = tweenObjectData.Target.GetAlpha();
    tweenObjectData.PosX = rectWnd.nX - rectWndParent.nX;
    tweenObjectData.PosY = rectWnd.nY - rectWndParent.nY;
    tweenObjectData.sizeXStart = rectWnd.nWidth;
    tweenObjectData.sizeYStart = rectWnd.nHeight;
    tweenObjectData._DelegateOnStart();
    return;
}

private function UpdatePosition(float Value)
{
    local float Ratio, ratioEase;
    local int i;
    local array<int> completeds;
    local array<L2UITweenObject> completedargetObject;

    i = 0;
    J0x07:

    // End:0x3DD [Loop If]
    if(i < tweenObjects.Length)
    {
        // End:0x32
        if(tweenObjects[i].Paused)
        {
            // [Explicit Continue]
            goto J0x3D3;
        }
        tweenObjects[i].Position += Value;
        // End:0x86
        if(tweenObjects[i].Position <= (tweenObjects[i].Delay / float(1000)))
        {
            // [Explicit Continue]
            goto J0x3D3;
        }
        tweenObjects[i]._DelegateOnUpdate(tweenObjects[i].Position);
        Ratio = (tweenObjects[i].Position - (tweenObjects[i].Delay / float(1000))) / (tweenObjects[i].Duration / float(1000));
        // End:0x195
        if(Ratio >= float(1))
        {
            Ratio = 1.0000000;
            tweenObjects[i].Position = (tweenObjects[i].Duration + tweenObjects[i].Delay) / float(1000);
            completedargetObject[completedargetObject.Length] = tweenObjects[i];
            completeds[completeds.Length] = i;
        }
        ratioEase = GetRationEase(Ratio, tweenObjects[i].ease);
        // End:0x1E0
        if(tweenObjects[i].Target.m_pTargetWnd == none)
        {
            // [Explicit Continue]
            goto J0x3D3;
        }
        // End:0x24F
        if(tweenObjects[i].Alpha != float(0))
        {
            tweenObjects[i].Target.SetAlpha(int(float(tweenObjects[i].alphaStart) + (tweenObjects[i].Alpha * ratioEase)));
        }
        // End:0x311
        if((tweenObjects[i].SizeX != float(0)) || tweenObjects[i].SizeY != float(0))
        {
            tweenObjects[i].Target.SetWindowSize(int(float(tweenObjects[i].sizeXStart) + (tweenObjects[i].SizeX * ratioEase)), int(float(tweenObjects[i].sizeYStart) + (tweenObjects[i].SizeY * ratioEase)));
        }
        // End:0x3D3
        if((tweenObjects[i].MoveX != float(0)) || tweenObjects[i].MoveY != float(0))
        {
            tweenObjects[i].Target.MoveC(int(float(tweenObjects[i].PosX) + (tweenObjects[i].MoveX * ratioEase)), int(float(tweenObjects[i].PosY) + (tweenObjects[i].MoveY * ratioEase)));
        }
        J0x3D3:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    i = completeds.Length - 1;
    J0x3EC:

    // End:0x432 [Loop If]
    if(i >= 0)
    {
        tweenObjects[completeds[i]]._DelegateOnEnd();
        tweenObjects.Remove(completeds[i], 1);
        i--;
        // [Loop Continue]
        goto J0x3EC;
    }
    i = 0;
    J0x439:

    // End:0x464 [Loop If]
    if(i < completeds.Length)
    {
        CompleteTween(completedargetObject[i]);
        i++;
        // [Loop Continue]
        goto J0x439;
    }
    return;
}

private function CompleteTween(L2UITweenObject tweenObjectData)
{
    local WindowHandle Target;

    Target = tweenObjectData.Target;
    Target.SetAlpha(int(float(tweenObjectData.alphaStart) + tweenObjectData.Alpha));
    Target.SetWindowSize(int(float(tweenObjectData.sizeXStart) + tweenObjectData.SizeX), int(float(tweenObjectData.sizeYStart) + tweenObjectData.SizeY));
    Target.MoveC(int(float(tweenObjectData.PosX) + tweenObjectData.MoveX), int(float(tweenObjectData.PosY) + tweenObjectData.MoveY));
    GetScript(tweenObjectData.Owner).OnCallUCFunction("tweenEnd", string(tweenObjectData.Id));
    return;
}

function StartShake(string TargetName, int nShakeSize, int nTime, L2UITween.directionType Dir, optional int Delay, optional int Id)
{
    local ShakeObject shakeObjectData;

    shakeObjectData.Owner = TargetName;
    shakeObjectData.Target = GetWindowHandle(TargetName);
    shakeObjectData.Duration = float(nTime);
    shakeObjectData.shakeSize = float(nShakeSize);
    shakeObjectData.direction = Dir;
    shakeObjectData.Delay = float(Delay);
    shakeObjectData.Id = Id;
    StartShakeObject(shakeObjectData);
    return;
}

function StartShakeObject(ShakeObject shakeObjectData)
{
    shakeObjects[shakeObjects.Length] = shakeObjectData;
    TickOn();
    return;
}

private function SetStartValueShake(out ShakeObject shakeObjectData)
{
    local Rect rectWnd, rectWndParent;

    rectWnd = shakeObjectData.Target.GetRect();
    rectWndParent = shakeObjectData.Target.GetParentWindowHandle().GetRect();
    shakeObjectData.PosX = rectWnd.nX - rectWndParent.nX;
    shakeObjectData.PosY = rectWnd.nY - rectWndParent.nY;
    shakeObjectData.shakeStarted = true;
    return;
}

private function UpdatePositionShake(float DeltaTime)
{
    local int i;
    local array<int> Completed;
    local float Ratio;
    local bool complete;

    i = 0;
    J0x07:

    // End:0x12C [Loop If]
    if(i < shakeObjects.Length)
    {
        shakeObjects[i].Position += DeltaTime;
        // End:0x62
        if(shakeObjects[i].Position <= (shakeObjects[i].Delay / float(1000)))
        {
            // [Explicit Continue]
            goto J0x122;            
        }
        else
        {
            // End:0x89
            if(!shakeObjects[i].shakeStarted)
            {
                SetStartValueShake(shakeObjects[i]);
            }
        }
        Ratio = (shakeObjects[i].Position - (shakeObjects[i].Delay / float(1000))) / (shakeObjects[i].Duration / float(1000));
        complete = Ratio >= float(1);
        Shake(shakeObjects[i], Ratio);
        // End:0x122
        if(complete)
        {
            Completed[Completed.Length] = i;
            CompleteShake(i);
        }
        J0x122:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    i = Completed.Length - 1;
    J0x13B:

    // End:0x162 [Loop If]
    if(i >= 0)
    {
        shakeObjects.Remove(Completed[i], 1);
        i--;
        // [Loop Continue]
        goto J0x13B;
    }
    return;
}

function Shake(ShakeObject shakeObjectData, float Ratio)
{
    local float X, Y, Value;

    switch(shakeObjectData.direction)
    {
        // End:0x2B
        case 0:
            Value = shakeObjectData.shakeSize * Ratio;
            // End:0x55
            break;
        // End:0x4F
        case 1:
            Value = (shakeObjectData.shakeSize * float(1)) - Ratio;
            // End:0x55
            break;
        // End:0xFFFF
        default:
            // End:0x55
            break;
            break;
    }
    // End:0x87
    if(Rand(2) == 0)
    {
        X = float(shakeObjectData.PosX - (appRound(float(Rand(int(Value))))));        
    }
    else
    {
        X = float(shakeObjectData.PosX + (appRound(float(Rand(int(Value))))));
    }
    // End:0xDE
    if(Rand(2) == 0)
    {
        Y = float(shakeObjectData.PosY - (appRound(float(Rand(int(Value))))));        
    }
    else
    {
        Y = float(shakeObjectData.PosY + (appRound(float(Rand(int(Value))))));
    }
    shakeObjectData.Target.MoveC(int(X), int(Y));
    return;
}

function StopShake(string Owner, int Id)
{
    local int Index;

    Index = GetShakeObjectIndex(Owner, Id);
    // End:0x31
    if(Index != -1)
    {
        shakeObjects.Remove(Index, 1);
    }
    return;
}

function int GetShakeObjectIndex(string Owner, int Id)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x5D [Loop If]
    if(i < shakeObjects.Length)
    {
        // End:0x53
        if((shakeObjects[i].Owner == Owner) && shakeObjects[i].Id == Id)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

private function CompleteShake(int Index)
{
    local WindowHandle Target;
    local ShakeObject shakeObjectData;

    shakeObjectData = shakeObjects[Index];
    Target = shakeObjectData.Target;
    Target.MoveC(shakeObjectData.PosX, shakeObjectData.PosY);
    GetScript(shakeObjectData.Owner).OnCallUCFunction("shakeEnd", string(shakeObjectData.Id));
    return;
}

function L2UITweenTwinkleObject _AddTweenTwinlkle(WindowHandle targetObject, optional float twinkleNum, optional float startRatio, optional float Duration, optional int minAlpha, optional int maxAlpha, optional float gab, optional float Delay)
{
    local L2UITweenTwinkleObject twinkleObj;
    local int Index;

    // End:0x16
    if(targetObject.m_pTargetWnd == none)
    {
        return none;
    }
    // End:0x2E
    if(Duration == float(0))
    {
        Duration = 1000.0000000;
    }
    twinkleObj = new Class'Interface.L2UITweenTwinkleObject';
    twinkleObj.Owner = targetObject.GetTopFrameWnd().GetWindowName();
    twinkleObj.Target = targetObject;
    twinkleObj.Duration = Duration;
    twinkleObj.twinkleNum = twinkleNum;
    twinkleObj._SetRatio(startRatio);
    twinkleObj.minAlpha = minAlpha;
    twinkleObj.gab = gab;
    twinkleObj.Delay = Delay;
    // End:0x110
    if(maxAlpha == 0)
    {
        twinkleObj.maxAlpha = 255;        
    }
    else
    {
        twinkleObj.maxAlpha = maxAlpha;
    }
    Index = GetTwinkleObjectIndex(targetObject);
    // End:0x154
    if(Index >= 0)
    {
        twinkleObjects[Index] = twinkleObj;        
    }
    else
    {
        twinkleObjects[twinkleObjects.Length] = twinkleObj;
        TickOn();
    }
    return twinkleObj;
    return;
}

private function UpdatePositionTwinkle(float Value)
{
    local int i, Index;
    local float Ratio;
    local array<int> completeds;

    i = 0;
    J0x07:

    // End:0x38A [Loop If]
    if(i < twinkleObjects.Length)
    {
        // End:0x32
        if(twinkleObjects[i].Paused)
        {
            // [Explicit Continue]
            goto J0x380;
        }
        // End:0x62
        if(!twinkleObjects[i].Target.GetTopFrameWnd().IsShowWindow())
        {
            // [Explicit Continue]
            goto J0x380;
        }
        // End:0x154
        if(twinkleObjects[i].Delay > float(0))
        {
            // End:0xBD
            if(twinkleObjects[i].Delay > Value)
            {
                twinkleObjects[i].Delay -= Value;
                // [Explicit Continue]
                goto J0x380;                
            }
            else
            {
                // End:0xF2
                if(twinkleObjects[i].Position == float(0))
                {
                    twinkleObjects[i]._DelegateOnStart();
                }
                twinkleObjects[i].Position += twinkleObjects[i].Delay;
                twinkleObjects[i].Delay = 0.0000000;
            }
            Ratio = twinkleObjects[i]._Ratio();            
        }
        else
        {
            // End:0x189
            if(twinkleObjects[i].Position == float(0))
            {
                twinkleObjects[i]._DelegateOnStart();
            }
            twinkleObjects[i].Position += Value;
            Ratio = twinkleObjects[i]._Ratio();
            // End:0x21D
            if((Ratio - ((Value * float(1000)) / twinkleObjects[i].Duration)) < Ratio)
            {
                twinkleObjects[i].Delay = twinkleObjects[i].gab;
            }
        }
        twinkleObjects[i]._DelegateOnUpdate(twinkleObjects[i].Position);
        // End:0x294
        if(twinkleObjects[i].twinkleNum == float(-1))
        {
            // End:0x291
            if(Ratio >= float(1))
            {
                twinkleObjects[i].Position = 0.0000000;
            }            
        }
        else
        {
            // End:0x2DE
            if(Ratio >= twinkleObjects[i].twinkleNum)
            {
                completeds[completeds.Length] = i;
                Ratio = twinkleObjects[i].twinkleNum;
            }
        }
        // End:0x380
        if(twinkleObjects[i].Target.m_pTargetWnd != none)
        {
            twinkleObjects[i].Target.SetAlpha((((int(Cos((Ratio * float(2)) * 3.1415930) + float(1)) / 2) * twinkleObjects[i].maxAlpha) - twinkleObjects[i].minAlpha) + twinkleObjects[i].minAlpha);
        }
        J0x380:

        i++;
        // [Loop Continue]
        goto J0x07;
    }
    i = completeds.Length - 1;
    J0x399:

    // End:0x3E4 [Loop If]
    if(i >= 0)
    {
        Index = completeds[i];
        twinkleObjects[Index]._DelegateOnEnd();
        twinkleObjects.Remove(Index, 1);
        i--;
        // [Loop Continue]
        goto J0x399;
    }
    return;
}

function _KillTwinkleWithWnd(WindowHandle targetWnd)
{
    local int Index;

    Index = GetTwinkleObjectIndex(targetWnd);
    // End:0x22
    if(Index == -1)
    {
        return;
    }
    twinkleObjects.Remove(Index, 1);
    return;
}

private function int GetTwinkleObjectIndex(WindowHandle wndHandle)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x45 [Loop If]
    if(i < twinkleObjects.Length)
    {
        // End:0x3B
        if(twinkleObjects[i].Target == wndHandle)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

private function int GetTweenObjectIndex(string Owner, int Id)
{
    local int i;

    i = 0;
    J0x07:

    // End:0x65 [Loop If]
    if(i < tweenObjects.Length)
    {
        // End:0x5B
        if((tweenObjects[i].Owner == Owner) && tweenObjects[i].Id == Id)
        {
            return i;
        }
        i++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    return;
}

function int GetAbs(int Num)
{
    // End:0x13
    if(Num < 0)
    {
        return -Num;
    }
    return Num;
    return;
}

function float GetRationEase(float Ratio, int Type)
{
    switch(Type)
    {
        // End:0x29
        case 0:
            return easeInStrong(Ratio, 0.0000000, 1.0000000, 1.0000000);
            // End:0x136
            break;
        // End:0x4B
        case 1:
            return easeOutStrong(Ratio, 0.0000000, 1.0000000, 1.0000000);
            // End:0x136
            break;
        // End:0x6E
        case 2:
            return easeInOutStrong(Ratio, 0.0000000, 1.0000000, 1.0000000);
            // End:0x136
            break;
        // End:0x91
        case 3:
            return easeInBounce(Ratio, 0.0000000, 1.0000000, 1.0000000);
            // End:0x136
            break;
        // End:0xB4
        case 4:
            return easeOutBounce(Ratio, 0.0000000, 1.0000000, 1.0000000);
            // End:0x136
            break;
        // End:0xD7
        case 5:
            return easeInOutBounce(Ratio, 0.0000000, 1.0000000, 1.0000000);
            // End:0x136
            break;
        // End:0xFA
        case 6:
            return easeInElastic(Ratio, 0.0000000, 1.0000000, 1.0000000);
            // End:0x136
            break;
        // End:0x11D
        case 7:
            return easeOutElastic(Ratio, 0.0000000, 1.0000000, 1.0000000);
            // End:0x136
            break;
        // End:0x125
        case 8:
            // End:0x136
            break;
        // End:0x12D
        case 9:
            // End:0x136
            break;
        // End:0xFFFF
        default:
            // End:0x136
            break;
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x136
    return Ratio;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x136
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x136
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: ?????? ?? ????????? ?????????. ?????? ?????? ???? ????????????? ??????, ? ??? ?????? ?? ?????? ????????? ?????? ?????????.
??? ?????????: index
   ? System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   ? UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   ? UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x136
}

function float easeInElastic(float t, float B, float C, float D, optional float A, optional float P)
{
    local float S, PI2;

    PI2 = 2.0000000 * 3.1415930;
    // End:0x25
    if(t == float(0))
    {
        return B;
    }
    // End:0x46
    if((t /= D) == float(1))
    {
        return B + C;
    }
    // End:0x65
    if(P != float(0))
    {
        P = D * 0.3000000;
    }
    // End:0xAC
    if((A != float(0)) || A < float(GetAbs(int(C))))
    {
        A = C;
        S = P / float(4);        
    }
    else
    {
        S = (P / PI2) * Asin(C / A);
    }
    return ((-A * ExpFloat(10.0000000 * (t -= float(1)), 2)) * Sin((((t * D) - S) * PI2) / P)) + B;
    return;
}

function float easeOutElastic(float t, float B, float C, float D, optional float A, optional float P)
{
    local float S, PI2;

    PI2 = 2.0000000 * 3.1415930;
    // End:0x25
    if(t == float(0))
    {
        return B;
    }
    // End:0x46
    if((t /= D) == float(1))
    {
        return B + C;
    }
    // End:0x65
    if(P != float(0))
    {
        P = D * 0.3000000;
    }
    // End:0xAC
    if((A != float(0)) || A < float(GetAbs(int(C))))
    {
        A = C;
        S = P / float(4);        
    }
    else
    {
        S = (P / PI2) * Asin(C / A);
    }
    return (((A * ExpFloat(2.0000000, IsA(-10, t))) * Sin((((t * D) - S) * PI2) / P)) + C) + B;
    return;
}

function float easeOutBounce(float t, float B, float C, float D)
{
    // End:0x40
    if((t /= D) < (float(1) / 2.7500000))
    {
        return ((C * (7.5625000 * t)) * t) + B;        
    }
    else
    {
        // End:0x8F
        if(t < (float(2) / 2.7500000))
        {
            return (C * (((7.5625000 * (t -= (1.5000000 / 2.7500000))) * t) + 0.7500000)) + B;            
        }
        else
        {
            // End:0xDF
            if(t < (2.5000000 / 2.7500000))
            {
                return (C * (((7.5625000 * (t -= (2.2500000 / 2.7500000))) * t) + 0.9375000)) + B;                
            }
            else
            {
                return (C * (((7.5625000 * (t -= (2.6250000 / 2.7500000))) * t) + 0.9843750)) + B;
            }
        }
    }
    return;
}

function float easeInBounce(float t, float B, float C, float D)
{
    return (C - (easeOutBounce(D - t, 0.0000000, C, D))) + B;
    return;
}

function float easeInOutBounce(float t, float B, float C, float D)
{
    // End:0x47
    if(t < (D / float(2)))
    {
        return ((easeInBounce(t * float(2), 0.0000000, C, D)) * 0.5000000) + B;        
    }
    else
    {
        return (((easeOutBounce((t * float(2)) - D, 0.0000000, C, D)) * 0.5000000) + (C * 0.5000000)) + B;
    }
    return;
}

function float easeInOutStrong(float t, float B, float C, float D)
{
    // End:0x50
    if((t /= (D / float(2))) < float(1))
    {
        return ((((((C / float(2)) * t) * t) * t) * t) * t) + B;
    }
    return ((C / float(2)) * ((((((t -= float(2)) * t) * t) * t) * t) + float(2))) + B;
    return;
}

function float easeOutStrong(float t, float B, float C, float D)
{
    t = t - float(1);
    return ExpFloat(t, 5) + float(1);
    return;
}

function float easeInStrong(float t, float B, float C, float D)
{
    return ExpFloat(t, 5);
    return;
}
