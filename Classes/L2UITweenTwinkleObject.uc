class L2UITweenTwinkleObject extends UIEventManager;

var WindowHandle Target;
var string Owner;
var float Position;
var float Duration;
var float Delay;
var float twinkleNum;
var bool Paused;
var int minAlpha;
var int maxAlpha;
var float gab;
//var delegate<_DelegateOnStart> ___DelegateOnStart__Delegate;
//var delegate<_DelegateOnUpdate> ___DelegateOnUpdate__Delegate;
//var delegate<_DelegateOnEnd> ___DelegateOnEnd__Delegate;

delegate _DelegateOnStart()
{
    return;
}

delegate _DelegateOnUpdate(float Position)
{
    return;
}

delegate _DelegateOnEnd()
{
    return;
}

function float _Ratio()
{
    return Position / (Duration / float(1000));
    return;
}

function _SetRatio(float Ratio)
{
    Position = Ratio * (Duration / float(1000));
    return;
}

function float _Position()
{
    return Position;
    return;
}

function _Play(optional int _delay)
{
    // End:0x18
    if(_delay != 0)
    {
        Delay = float(_delay);
    }
    Paused = false;
    return;
}

function _Pause()
{
    Paused = true;
    return;
}

function _Stop()
{
    Paused = true;
    Position = 0.0000000;
    return;
}

function _Kill()
{
    Class'Interface.L2UITween'.static.Inst()._KillTwinkleWithWnd(Target);
    return;
}

function _Reset()
{
    Paused = false;
    Position = 0.0000000;
    return;
}
