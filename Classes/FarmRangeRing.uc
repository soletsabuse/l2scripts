class FarmRangeRing extends ProjectedEmitter;

const RING_UNITS_PER_FACTOR = 99.0;
const LIFT_PER_FACTOR = 200.0;
const RING_TEXTURE = "UI_BOHPTS.AutoFarm.RangeRing";

var float RangeFactor;
var bool bFollowPlayer;
var bool bShown;
var bool bProjectorReady;
var Vector FixedCenter;
var PlayerController FollowController;

static function float FactorFor(float Distance)
{
    return FMax(Distance, 50.0000000) / 99.0000000;
    return;
}

static function SetSpawnRange(float Distance)
{
    default.RangeFactor = FactorFor(Distance);
    return;
}

static function Vector RingLocation(Vector Center, float Distance)
{
    Center.Z += (200.0000000 * (FactorFor(Distance)));
    return Center;
    return;
}

function SetShown(bool bShow)
{
    bShown = bShow;
    bHidden = !bShow;
    // End:0x2D
    if(!bShow)
    {
        StopProjection();
    }
    return;
}

function StopProjection()
{
    // End:0x41
    if((Projector != none) && !Projector.bDeleteMe)
    {
        Projector.ProjTexture = none;
        Projector.DetachProjector(true);
    }
    return;
}

function SetRange(float Distance)
{
    RangeFactor = FactorFor(Distance);
    UpdateRangeProjection();
    // End:0x29
    if(bFollowPlayer)
    {
        MoveToPlayer();        
    }
    else
    {
        PlaceAt(FixedCenter);
    }
    return;
}

function FollowPlayer(PlayerController pc)
{
    FollowController = pc;
    bFollowPlayer = true;
    MoveToPlayer();
    return;
}

function PlaceAt(Vector Center)
{
    bFollowPlayer = false;
    FixedCenter = Center;
    Center.Z += (200.0000000 * RangeFactor);
    SetLocation(Center);
    return;
}

function MoveToPlayer()
{
    local PlayerController pc;
    local Vector Center;

    pc = Level.GetLocalPlayerController();
    // End:0x41
    if((pc == none) || pc.Pawn == none)
    {
        pc = FollowController;
    }
    // End:0xB5
    if(((pc != none) && !pc.bDeleteMe) && pc.Pawn != none)
    {
        Center = pc.Pawn.Location;
        Center.Z += (200.0000000 * RangeFactor);
        SetLocation(Center);
    }
    return;
}

function UpdateRangeProjection()
{
    bSetSizeScale = false;
    SetDrawScale(default.DrawScale);
    SetDrawScale3D(default.DrawScale3D);
    ProjectorDrawScale = 1.0000000;
    ProjectorClippingDistance = 400.0000000 * RangeFactor;
    ProjectorSizeX = 220.0000000 * RangeFactor;
    ProjectorSizeY = 220.0000000 * RangeFactor;
    // End:0x80
    if((Projector == none) || Projector.bDeleteMe)
    {
        return;
    }
    Projector.MaxTraceDistance = int(ProjectorClippingDistance);
    // End:0xDA
    if(!bProjectorReady)
    {
        bProjectorReady = true;
        Projector.bProjectActor = false;
        Projector.bProjectParticles = false;
        Projector.SetCollision(false, false, false);
    }
    return;
}

event PostBeginPlay()
{
    local Texture RingTexture;

    super(Actor).PostBeginPlay();
    RingTexture = Texture(DynamicLoadObject("UI_BOHPTS.AutoFarm.RangeRing", Class'Engine.Texture'));
    // End:0x69
    if((RingTexture != none) && Emitters.Length > 0)
    {
        Emitters[0].Texture = RingTexture;
    }
    UpdateRangeProjection();
    return;
}

event Destroyed()
{
    StopProjection();
    super(Actor).Destroyed();
    return;
}

event Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x18
    if(!bShown)
    {
        return;
    }
    // End:0x27
    if(bFollowPlayer)
    {
        MoveToPlayer();
    }
    UpdateRangeProjection();
    return;
}

defaultproperties
{
    RangeFactor=1.0000000
    bFollowPlayer=true
    bShown=true
    rtUSize=2048
    rtVSize=2048
    ProjectorClippingDistance=400.0000000
    ProjectorSizeX=220.0000000
    ProjectorSizeY=220.0000000
    ProjectorFrameBufferBlendingOp=4
    // Reference: SpriteEmitter'Interface.FarmRangeRing.RingSprite'
    begin object name="RingSprite" class=Engine.SpriteEmitter
        ColorMultiplierRange=(X=(Min=1.0000000,Max=1.0000000),Y=(Min=0.8000000,Max=0.8000000),Z=(Min=0.4000000,Max=0.4000000))
        Opacity=0.8500000
        CoordinateSystem=6
        MaxParticles=2
        UseRegularSizeScale=false
        UniformSize=true
        SizeScale=/* Array type was not detected. */
        SizeScaleRepeats=2.0000000
        StartSizeRange=(X=(Min=10.0000000,Max=10.0000000),Y=(Min=10.0000000,Max=10.0000000),Z=(Min=10.0000000,Max=10.0000000))
        InitialParticlesPerSecond=1000.0000000
        AutomaticInitialSpawning=false
        DrawStyle=1
    end object
    Emitters[0]=RingSprite
    bSetSizeScale=false
    bLightChanged=true
    bNoDelete=false
    bSunAffect=true
    DrawScale=0.1000000
    bDirectional=true
}