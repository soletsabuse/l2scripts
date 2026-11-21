class ViewPortWndBase extends UICommonAPI;

const EFFECT_MONSTER_ID = 19671;

var string m_WindowName;
var WindowHandle Me;
var CharacterViewportWindowHandle m_ObjectViewport;

function OnLoad()
{
    m_WindowName = getCurrentWindowName(string(self));
    InitializeCOD();
    RegisterState("ViewPortWndBase", "CHARACTERSELECTSTATE");
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle(m_WindowName);
    m_ObjectViewport = GetCharacterViewportWindowHandle(m_WindowName $ ".EffectStageWnd.ObjectViewport");
    m_ObjectViewport.SetSpawnDuration(0.2000000);
    Me.DisableWindow();
    return;
}

function SetNPCViewportData(int Id)
{
    m_ObjectViewport.super(ViewPortWndBase).SetNPCViewportData(Id);
    return;
}

function SpawnEffect(string EffectName)
{
    m_ObjectViewport.super(ViewPortWndBase).SpawnEffect(EffectName);
    return;
}

function SpawnNPC()
{
    m_ObjectViewport.super(ViewPortWndBase).SpawnNPC();
    return;
}

function PlayAnimation(int Index)
{
    m_ObjectViewport.super(ViewPortWndBase).PlayAnimation(Index);
    return;
}

function StartRotation(bool isRight)
{
    m_ObjectViewport.super(ViewPortWndBase).StartRotation(isRight);
    return;
}

function EndRotation()
{
    m_ObjectViewport.super(ViewPortWndBase).EndRotation();
    return;
}

function SetNPCInfo(int Index)
{
    m_ObjectViewport.super(ViewPortWndBase).SetNPCInfo(Index);
    return;
}

function StartZoom(bool isZoomOut)
{
    m_ObjectViewport.super(ViewPortWndBase).StartZoom(isZoomOut);
    return;
}

function EndZoom()
{
    m_ObjectViewport.super(ViewPortWndBase).EndZoom();
    return;
}

function SetCharacterScale(float Scale)
{
    m_ObjectViewport.super(ViewPortWndBase).SetCharacterScale(Scale);
    return;
}

function SetCharacterOffsetX(int Position)
{
    m_ObjectViewport.super(ViewPortWndBase).SetCharacterOffsetX(Position);
    return;
}

function SetCharacterOffsetY(int Position)
{
    m_ObjectViewport.super(ViewPortWndBase).SetCharacterOffsetY(Position);
    return;
}

function SetCharacterOffsetZ(int Position)
{
    m_ObjectViewport.super(ViewPortWndBase).SetCharacterOffsetZ(Position);
    return;
}

function SetCharacterOffset(int X, int Y, int Z)
{
    m_ObjectViewport.super(ViewPortWndBase).SetCharacterOffset(setVector(X, Y, Z));
    return;
}

function PlayAttackAnimation(int Index)
{
    m_ObjectViewport.super(ViewPortWndBase).PlayAttackAnimation(Index);
    return;
}

function AutoAttacking(bool isAutoAttack)
{
    m_ObjectViewport.super(ViewPortWndBase).AutoAttacking(isAutoAttack);
    return;
}

function ShowNPC(float Duration)
{
    m_ObjectViewport.super(ViewPortWndBase).ShowNPC(Duration);
    return;
}

function HideNPC(float Duration)
{
    m_ObjectViewport.super(ViewPortWndBase).HideNPC(Duration);
    return;
}

function SetDragRotationRate(int Rate)
{
    m_ObjectViewport.super(ViewPortWndBase).SetDragRotationRate(Rate);
    return;
}

function SetCurrentRotation(int Rotation)
{
    m_ObjectViewport.super(ViewPortWndBase).SetCurrentRotation(Rotation);
    return;
}

function SetCameraDistance(int Distance)
{
    m_ObjectViewport.super(ViewPortWndBase).SetCameraDistance(Distance);
    return;
}

function SetSpawnDuration(float Duration)
{
    m_ObjectViewport.super(ViewPortWndBase).SetSpawnDuration(Duration);
    return;
}

function SetUISound(bool IsSound)
{
    m_ObjectViewport.super(ViewPortWndBase).SetUISound(IsSound);
    return;
}

function OnCallUCFunction(string functionName, string param)
{
    switch(functionName)
    {
        // End:0x25
        case "SpawnEffect":
            SpawnEffect(param);
            // End:0x2EB
            break;
        // End:0x3B
        case "SpawnNPC":
            SpawnNPC();
            // End:0x2EB
            break;
        // End:0x5D
        case "PlayAnimation":
            PlayAnimation(int(param));
            // End:0x2EB
            break;
        // End:0x7F
        case "StartRotation":
            StartRotation(bool(param));
            // End:0x2EB
            break;
        // End:0x98
        case "EndRotation":
            EndRotation();
            // End:0x2EB
            break;
        // End:0xB6
        case "StartZoom":
            StartZoom(bool(param));
            // End:0x2EB
            break;
        // End:0xCB
        case "EndZoom":
            EndZoom();
            // End:0x2EB
            break;
        // End:0xF1
        case "SetCharacterScale":
            SetCharacterScale(float(param));
            // End:0x2EB
            break;
        // End:0x119
        case "SetCharacterOffsetX":
            SetCharacterOffsetX(int(param));
            // End:0x2EB
            break;
        // End:0x141
        case "SetCharacterOffsetY":
            SetCharacterOffsetY(int(param));
            // End:0x2EB
            break;
        // End:0x169
        case "SetCharacterOffsetZ":
            SetCharacterOffsetZ(int(param));
            // End:0x2EB
            break;
        // End:0x18E
        case "SetCharacterOffset":
            handleSetCharacterOffset(param);
            // End:0x2EB
            break;
        // End:0x1B6
        case "PlayAttackAnimation":
            PlayAttackAnimation(int(param));
            // End:0x2EB
            break;
        // End:0x1D8
        case "AutoAttacking":
            AutoAttacking(bool(param));
            // End:0x2EB
            break;
        // End:0x1F4
        case "ShowNPC":
            ShowNPC(float(param));
            // End:0x2EB
            break;
        // End:0x210
        case "HideNPC":
            HideNPC(float(param));
            // End:0x2EB
            break;
        // End:0x22F
        case "SetNPCInfo":
            SetNPCInfo(int(param));
            // End:0x2EB
            break;
        // End:0x257
        case "SetDragRotationRate":
            SetDragRotationRate(int(param));
            // End:0x2EB
            break;
        // End:0x27E
        case "SetCurrentRotation":
            SetCurrentRotation(int(param));
            // End:0x2EB
            break;
        // End:0x2A4
        case "SetCameraDistance":
            SetCameraDistance(int(param));
            // End:0x2EB
            break;
        // End:0x2C9
        case "SetSpawnDuration":
            SetSpawnDuration(float(param));
            // End:0x2EB
            break;
        // End:0x2E8
        case "SetUISound":
            SetUISound(bool(param));
            // End:0x2EB
            break;
        // End:0xFFFF
        default:
            break;
    }
    Me.BringToFront();
    return;
}

function handleSetCharacterOffset(string param)
{
    local int X, Y, Z;

    ParseInt(param, "x", X);
    ParseInt(param, "y", Y);
    ParseInt(param, "z", Z);
    SetCharacterOffset(X, Y, Z);
    return;
}

defaultproperties
{
    m_WindowName="ViewPortWndBase"
}