unit MobPull;

// Mob pull (body pull): run next to free mobs by the server path until the pack follows us. A mob
// behind a wall is reached along the nav map (Core\nav_move.pas: NavWaypoint) when it is built. We never
// stop while mobs are on us (the pack catches up and hits): touching a mob = at once to the next.
// A mob that does not aggro from the run past it is hit once (with the tap weapon if set; a caster:
// PullSetTapSkill - that skill from its range, no weapon, only with the mob in sight on the nav map;
// PullAddTapSkill - more skills: the first ready one that reaches the mob goes; with PullSetTapAlways
// every mob). PullAddAoeSkill: an AoE aggro skill - the pull is then ONE run planned at its start (the free mobs
// grouped into areas of the skill, the areas in the shortest order to the farm spot), the skill pressed on the run
// at each area, never at mobs it took already. Our HP low: a drain / heal of PullAddHeal goes first, then the pull goes on. Mobs that
// are on the ignore list (PullIgnoreID: archers that shoot from their place...) are never pulled. Ends: pack full and nothing close, nothing free left,
// HP low, no new aggro for a while, pull time over, stop asked. The fight is the caller's job.
//
//   uses MobPull in 'Core\mob_pull.pas';
//   PullSetMobs([20215]);                 // [] = any mob
//   PullSetPackSize(15);
//   PullSetGrid('CRUMA_MORDEO_1.navgrid'); // mobs only on walkable cells of this grid (Library\Nav)
//   PullSet('touch_wait_ms', 800);         // any tuning value by name, see PullSet
//   ...
//   if PullRun() = 0 then <nothing to pull: stand at the safe point>
//
// Shared library: scripts only call it, nobody edits it.

interface

uses SysUtils, Classes, NavMove in 'Core\nav_move.pas', DbgLog in 'Core\dbg_log.pas';

procedure PullSetMobs(IDs: array of integer);    // mob IDs to pull; [] = any mob (from a script)
procedure PullClearMobs();                       // no mob list = any mob
procedure PullAddMob(ID: integer);               // one more mob ID to pull (from another unit)
procedure PullSetPackSize(N: integer);           // aggro count that makes a pack
procedure PullSetZRange(R: integer);             // only mobs at most R up / down from us (0 = any)
procedure PullSetGrid(GridFile: string);         // only mobs on walkable cells of this .navgrid
procedure PullSetRadius(X, Y, R: integer);       // no grid: only mobs within R of this point (0 = bot zone)
procedure PullSetTap(WeaponID, Range: integer);  // a mob that does not aggro is hit with this weapon from Range
procedure PullSetTapSkill(SkillID, Range: integer);   // a caster: the tap is this skill from Range (0 = the weapon / a hit)
// one more tap skill after it: every mob gets the first skill of the list that is ready (no reuse) and
// reaches it - one in reuse, the next one goes (the pull does not wait for one reuse)
procedure PullAddTapSkill(SkillID, Range: integer);
// while pulling: our HP % below HPBelow -> this skill (Range > 0: a drain at the nearest mob on us / of the
// pull within Range and in sight; 0: on us, no target). Any number, the first one that may go; the pull
// goes on after it
procedure PullAddHeal(SkillID, HPBelow, Range: integer);
procedure PullClearHeals();
// an AoE pull skill (a huge aggro round us...): Radius round us (AtTarget false, no target) or round a mob within
// Range (AtTarget true: cast at that mob), not cast within EveryMs (0 = whenever ready). With one the pull is ONE
// RUN planned at its start: the free mobs of the pull (a room: all of it; else as many as the pack lacks) grouped
// into areas of the skill (the most mobs per press), the areas ordered into the shortest way from us to the end
// point (PullSweepEndAdd: the farm spot - spotted, led there, killed). Point after point the skill is sent ON THE RUN
// as soon as every mob of the area left is in its reach (no need to get to the point), the run goes on at once (the
// server moves us after its cast). Every free mob in its area when it went is ours from then (provoked, prv_ms): it
// is never pressed / run at again - the bot shows its target on us only later. The skill not ready at the point
// (reuse): through it and back, never standing, at most sweep_wait_ms. Never while a mob of the ignore list / a
// skipped champion is in its area. Only mobs in sight (no wall of the nav map between). MinMobs: not used
// The order of the areas: the cheapest run from us through them to the farm spot, the ways along the nav map, each
// leg dearer by sweep_pack_w % (default 333: our empty run = 0.3 of a mob) per mob behind us - the far mobs first (we run there
// free) and the near ones on the way back to the spot, the pack runs (and hits) as short as can be
procedure PullAddAoeSkill(SkillID: integer; AtTarget: boolean; Range, Radius, MinMobs, EveryMs: integer);
procedure PullClearAoeSkills();
// a rush skill: a dash at a mob (the server flies us to it; a run speed buff after it). Not a pull skill of its own:
// on the runs of the pull it is cast whenever ready at a mob that lies on our way - the mob we run to, or any mob of
// the pull list (free, or already on us) that brings us closer to where we go by at least half the dash (forward,
// never back). Range = its cast range; MinDash: no shorter dash (0 = 100). Any number: the first ready one goes
procedure PullAddRushSkill(SkillID, Range, MinDash: integer);
function PullRushOn(): boolean;                  // a rush skill is set
// the rush now, if one is worth it on the way to GX, GY: FreeOk = free mobs of the pull may be dashed at too (else
// only the ones on us). The pull calls it itself; the caller on its own runs (the pack to the farm spot) - every tick,
// it never waits. true = a rush is on: the caller does not click this tick (its start is waited for / it started and
// we clicked on our way already), the next tick it clicks its run at once
function PullRushTick(GX, GY: integer; FreeOk: boolean): boolean;
function PullRushCount(): integer;               // rushes since the script start (the log)
procedure PullSweepEndsClear();                  // the run of the next pull: no end point (it ends at its last area)
procedure PullSweepEndAdd(X, Y: integer);        // ... it may end at this point (up to 8): the shortest way is taken
function PullSweepEndPicked(): integer;          // ... the end point the last run took (index of the adds), -1 none
function PullCountOurs(): integer;               // on us + hit by our tap + provoked by our AoE (they come)
function PullAoeOn(): boolean;                   // an AoE pull skill is set: the pull is one planned run
// the heal / drain of PullAddHeal now if our HP is low (the pull calls it every tick; the caller may call it
// on its own runs - to the farm spot); we stand for its cast (heal_cast_ms, our HP going up ends it
// sooner). true = cast
function PullHealTick(): boolean;
procedure PullSetTapAlways(Enable: boolean);     // every mob is pulled by a hit of the tap weapon / skill
procedure PullSetFarmWeapon(ID: integer);        // weapon put back after the tap (0 = the one in hands)
procedure PullSet(Key: string; Value: integer);  // tuning by name (see the list in PullSet)
procedure PullIgnore(OID, Ms: integer);          // do not run at this mob for Ms (it still counts as aggro)
procedure PullForget(OID, Ms: integer);          // unreachable (behind a wall): not aggro, not pulled for Ms
procedure PullIgnoreName(Name: string);          // never take mobs with this name
procedure PullIgnoreID(ID: integer);             // never pull / count / fight mobs with this ID (shooters...)
procedure PullSetStop(Stop: boolean);            // true = end the pull at once (farm paused, return...)
function PullRun(): integer;                     // the pull; result = mobs on us (0 = nothing to pull)
// the pull log (always on): Library\Logs\pull_<character>_<time>_<part>.log - every pull: the mobs seen and why each
// is / is not free, the plan (groups, their way to the farm spot, the order), every pick and skip, the end. A caller
// adds its own lines (the room, why it pulls) with PullLog
procedure PullLog(S: string);
function PullIsAggro(i: integer): boolean;       // NpcList(i) is on us (shooters / ignored do not count)
function PullMobTarget(i: integer): integer;     // OID of whom NpcList(i) targets, 0 = none / gone
// NpcList(i) is "on us" only from before - it held us when we came back to life (res) / when the script started,
// and has not hit us since: the bot keeps its target / last attack, the server never says it dropped us.
// Not on us (and free to pull again) until it hits us, casts at us, we attack it (a shot, a hit: its MyAtkTime),
// we tap / provoke it, or it comes within MP_STALE_NEAR of us (it chases: an archer's mobs never get to hit)
function PullIsStale(i: integer): boolean;
function PullCountAggro(): integer;
function PullIsShooter(OID: integer): boolean;    // the mob is on the ignore list (PullIgnoreID) / a skipped champion
function PullIsShooterAt(i: integer): boolean;    // the same for NpcList(i) (no search by OID: cheap)
// NpcList(i) has a name of the ignore list (PullIgnoreName). The name is read once per NPC kind (ID)
// and remembered - no string read from the bot's objects every tick (they are freed under us)
function PullNameIgnored(i: integer): boolean;
function PullNpcName(i: integer): string;        // name of NpcList(i) for a log line; '' = gone
procedure PullDbgMobs(Tag: string);              // debug log: every mob near with all the pull's verdicts on it
procedure PullSkipChampions(MinMaxHP: integer);   // mobs with MaxHP above this: never pulled / fought (0 = off)
function PullIsChampion(i: integer): boolean;     // NpcList(i) is a live champion skipped by PullSkipChampions
procedure PullSetPackLive(Enable: boolean);       // true: pack = on us + every free mob of the area, every tick
procedure PullCheckShooters();                   // (does nothing now: no automatic shooters)
function PullInArea(X, Y, Z: integer): boolean;  // the point is where we pull
procedure PullPolyClear();                       // no extra polygon: the whole area
procedure PullPolyAdd(X, Y: integer);            // pull only inside this polygon too (a room)
function PullIsFree(i: integer): boolean;        // NpcList(i) is a free mob we may take
// the same, but anywhere in the area - the polygon of the room we farm now not looked at (each room counts its own)
function PullIsFreeAnyRoom(i: integer): boolean;
function PullTapActive(): boolean;               // the tap / farm weapon swap is ours now (disarm guard: wait)
// one by one (farm mobs where they stand): the free mob nearest by the way to it (nav map), within
// single_range; 0 = none
function PullPickSingle(): integer;
function PullCountFree(X, Y, R: integer): integer;   // free mobs of the list within R of the point
function PullDensity(): integer;                     // auto mode: this many free mobs near = a pack
procedure PullChase(OID: integer; First: boolean);   // one step of the run to this mob (never stops)
procedure PullTapRestore();                      // the farm weapon back; call every tick until not active
// the run to the farm spot with the pack behind: a pack mob is about to lose us -> one zigzag step
// across the way to it (true = this tick is ours, do not click your target). leash_range, 0 -> 800
function PullLeashTick(): boolean;

implementation

var
  MpInited: boolean;
  // the pull log (PlLog)
  PlLines: TStringList;
  PlBase, PlPath: string;
  PlPart: integer;
  PlAt, PlTickAt: cardinal;
  PlOn, PlDirty: boolean;
  PlSkBehind, PlSkOut: integer;        // MpFindFree, a planned room: the mobs it passed over (behind us / not in the plan)
  // tuning (PullSet)
  MpPack, MpTouchDist, MpTouchWaitMs, MpTouchGraceMs, MpTouchMax, MpSkipMs, MpIgnoreMs, MpApproachMs,
  MpTapAfterMs, MpTapMs, MpTapSkipMs, MpStaticMs, MpStaticDist, MpExtraRange, MpBackPenalty,
  MpHitRange, MpStuckMs, MpMinHP, MpNoGainMs, MpMaxMs, MpAggroDist, MpPackMult, MpStopMs,
  MpReclickDist, MpTickMs, MpGridTol, MpPullRange, MpLeash, MpZig, MpOvershoot, MpSingleRange,
  MpPackDensity: integer;
  // the pack behind us (each tick of the pull)
  MpFarX, MpFarY: integer;
  MpFarD: double;
  MpHavePack, MpWaiting: boolean;
  MpZigSign: integer;
  MpZigAt: cardinal;
  MpFarOID, MpWaitOID: integer;   // the lagging mob / the one we wait for
  MpWaitD0: double;               // its distance when we began to wait (or 4 s ago)
  MpWaitAt: cardinal;
  // why nothing was found (MpFindFree), told now and then
  MpCntAll, MpCntArea, MpCntRange, MpCntZ, MpCntSkip: integer;
  MpWhyAt: cardinal;
  // run to a mob along the nav map
  MpWpOn: boolean;
  MpWpX, MpWpY: integer;
  MpWpAt: cardinal;
  MpChaseMX, MpChaseMY: integer;   // where the mob was at our last straight click
  // config
  MpMobIDs: array of integer;
  MpZRange: integer;
  MpRX, MpRY, MpRR: integer;
  MpTapWeapon, MpTapRange, MpFarmWeapon: integer;
  MpTapSkill: integer;          // PullSetTapSkill: the tap is this skill from MpTapRange (a caster), no weapon
  MpTapSks, MpTapRngs: array of integer;   // ... + PullAddTapSkill: all tap skills in order, their ranges
  MpHealSk, MpHealHP, MpHealRng: array of integer;   // PullAddHeal: heal / drain skills, our HP % level, range (0 = on us)
  MpHealFail: array of cardinal;  // ... ordered but no cast seen (MP...): not tried again before this
  MpHealCastMs: integer;          // heal_cast_ms: we stand this long for its cast (our HP up -> sooner)
  MpTapSkillMs: integer;        // tap_skill_ms: after the cast its hit must land within this
  MpTapFireMs: integer;         // tap_fire_ms: the tap skill sent (DUseSkill) must start (its reuse) within this
  MpTapResendMs: integer;       // tap_resend_ms: until it starts it is sent again this often
  MpTapSkillTold: boolean;      // "no such tap skill" said
  MpAoeSk, MpAoeRng, MpAoeRad, MpAoeEvery: array of integer;   // PullAddAoeSkill: skill, cast range, radius,
                                  //   at most once in this many ms
  MpAoeAtMob: array of boolean;   // ... cast at a mob (else round us, no target)
  MpAoeLast, MpAoeHold: array of cardinal;   // ... went last / did not go: not tried before this
  MpAoeTold: array of boolean;    // ... "no such skill" said
  MpAoeRunAt: cardinal;           // ... one went on the run then (its cast may hold us: no "stuck" for a while)
  MpRushSk, MpRushRng, MpRushMin: array of integer;   // PullAddRushSkill: skill, cast range, the shortest dash
  MpRushHold: array of cardinal;  // ... sent and did not start / not on this character: not tried before this
  MpRushPOID: integer;            // PullRushTick: the rush sent now at this mob (0 = none) ...
  MpRushPSk, MpRushPK: integer;   // ... its skill, its row
  MpRushPAt, MpRushPSent: cardinal;   // ... sent first / last (sent again until its reuse shows it started)
  MpRushPOurs: boolean;           // ... the mob was on us already (else: free - ours once it started)
  MpRushPD, MpRushPGain, MpRushPWG: integer;   // ... for the log: its distance, how much closer, the goal away
  MpRushBadOID: integer;          // ... it did not start at this mob (a wall the map does not know...) ...
  MpRushBadUntil: cardinal;       // ... not at it again before this
  MpRushN: integer;               // rushes done (the log)
  MpPrvOID: array[0..127] of integer;   // MpPrvAdd: provoked by our AoE (ours, it comes) ...
  MpPrvAt: array[0..127] of cardinal;   // ... then
  MpPrvHead: integer;
  MpPrvLast: cardinal;            // ... the last one (none within prv_ms: nothing to look at)
  MpPrvMs: integer;               // prv_ms: a provoked mob is ours this long
  MpSwWaitMs: integer;            // sweep_wait_ms: at a point of the run the skill not ready this long -> on
  MpSwPackW: integer;             // sweep_pack_w: % a leg of the run costs more per mob behind us on it (0 = the way only)
  // the run of a pull with an AoE skill (MpSweep), planned at its start
  SwMobOID, SwMobX, SwMobY, SwMobZ, SwMobPt: array[0..127] of integer;   // the free mobs of the plan, the point
  SwMobN: integer;                                   //   that takes each (-1 = none: next to a mob that must not come)
  SwBadX, SwBadY: array[0..31] of integer;           // mobs that must not come (ignore list / skipped champions)
  SwBadN: integer;
  SwPX, SwPY, SwPZ: array[0..31] of integer;         // the points as found (the middle mob of each area)
  SwX, SwY, SwZ: array[0..31] of integer;            // ... in run order
  SwN: integer;
  SwOrd, SwTry, SwBest, SwInv: array[0..31] of integer;   // the order: the best of an end / tried / the best / its inverse
  SwUsed: array[0..31] of boolean;
  SwDM: array[0..1155] of double;                    // distances: points 0..31, us 32, the end 33 (34 x 34)
  SwEndD: array[0..255] of double;                   // point i -> end point e: SwEndD[i * 8 + e]
  SwPW: array[0..31] of integer;                     // the mobs of each point (the pack grows by them)
  SwCarry: integer;                                  // the mobs on us when the run starts
  SwPlanMs: cardinal;                                // the plan took this long ...
  SwPlanMap: boolean;                                // ... with the ways along the nav map (else straight)
  // the tap / body pull of a room (no AoE skill): its order planned as the AoE run's (MpTapPlan) - MpFindFree
  // takes the free mob of the first group left in it
  TpOn: boolean;
  TpAt: cardinal;
  TpPlans: integer;
  TpMinRank: integer;                                // the group of the plan we went on to: the ones before it are passed
  TpBehind: integer;                                 // MpTapPlan: mobs of the passed groups left out of the new plan
  TpPassed: array[0..127] of integer;                // the mobs of the groups passed in this pull (kept over a new plan)
  TpPassedN: integer;
  SwTmp: array[0..31] of integer;                    // MpSwImprove: the order before a try
  SwNoBad: boolean;                                  // MpSwCover: no area kept off the mobs that must not come (taps)
  SwLOID, SwLX, SwLY: array[0..127] of integer;      // MpSwLook: the mobs of a point still to pull, where they are now
  SwLN: integer;
  MpSwEndX, MpSwEndY: array[0..7] of integer;        // PullSweepEndAdd: where the run may end (the farm spots)
  MpSwEndN, MpSwEndPick: integer;                    // ... how many / the one the last run took (-1 = none)
  MpTapAlways: boolean;
  MpNames: array of string;
  MpNkID: array[0..511] of integer;      // PullNameIgnored: NPC kinds seen ...
  MpNkIgn: array[0..511] of boolean;     // ... their name is on the ignore list
  MpNkN: integer;
  MpIgnIDs: array of integer;   // PullIgnoreID
  MpChampHP: integer;           // PullSkipChampions: 0 = champions are mobs like any other
  MpPackLive: boolean;          // PullSetPackLive: the pack size follows the free mobs (a room: respawn joins)
  MpStop: boolean;
  // area grid
  GgX0, GgY0, GgCell, GgW, GgH: integer;
  GgFree: array of boolean;
  GgOn: boolean;
  GgNav: boolean;               // the pull area is the nav map's grid (NavGridFree): no own copy
  PpX, PpY: array of integer;   // PullPolyAdd: the room we farm (3+ points = on)
  PpN: integer;
  // run state
  MpLX, MpLY: integer;
  MpMovedAt, MpClickAt: cardinal;
  MpClickX, MpClickY: integer;
  MpDirX, MpDirY: integer;
  MpTouchOID: array[0..15] of integer;
  MpTouchAt: array[0..15] of cardinal;
  MpTouchCnt: array[0..15] of integer;
  MpTouchHead: integer;
  MpSkipOID: array[0..63] of integer;
  MpSkipUntil: array[0..63] of cardinal;
  MpSkipHead: integer;
  MpHardOID: array[0..31] of integer;     // PullForget
  MpHardUntil: array[0..31] of cardinal;
  MpHardHead: integer;
  MpHitOID: array[0..31] of integer;      // mobs our tap hit: one hit = ours (the pull counts them)
  MpHitAt: array[0..31] of cardinal;
  MpHitHead: integer;
  MpHitLast: cardinal;                    // the last hit (none within tap_skip_ms: nothing to look at)
  // "on us" from before (PullIsStale): the mobs that held us at the start / when we came back to life, and their
  // attack time then (a new attack on us = on us for real); 0 = the entry is done
  MpStOID: array[0..95] of integer;
  MpStAt: array[0..95] of cardinal;
  MpStMy: array[0..95] of cardinal;       // ... and our last attack on it then (a new one = we fight it)
  MpStN: integer;
  MpStSnapped, MpStWasDead: boolean;
  MpStLook: cardinal;
  MpAtkWorks: boolean;                    // an attack of ours on a tapped mob was seen (the bot fills it)
  MpTrkOID: array[0..31] of integer;
  MpTrkX, MpTrkY: array[0..31] of integer;
  MpTrkAt: array[0..31] of cardinal;
  MpTrkHead: integer;
  MpShootOID: array[0..31] of integer;
  MpShootHead: integer;
  // tap weapon
  MpTapOn: boolean;
  MpTapMain: integer;
  MpTapSameTold: boolean;        // "farm weapon = tap weapon" said (a hit with the weapon in hands: said once)
  MpWearID: integer;
  MpWearUseAt, MpWearRefAt: cardinal;
  MpWearOK: boolean;

// a square in double (an integer square overflows past 46340: far coordinates, a point not set yet)
function MpSq(V: double): double;
begin
  result := V * V;
end;

// ---------- the pull log ----------

procedure PlFlush();
var FS: TFileStream;
begin
  if (not PlOn) or (not PlDirty) then exit;
  PlDirty := false;
  PlAt := GetTickCount;
  try
    FS := TFileStream.Create(PlPath, fmCreate or fmShareDenyNone);   // readable while written
    try
      PlLines.SaveToStream(FS);
    finally
      FS.Free;
    end;
  except
  end;
  if PlLines.Count >= 3000 then begin  // the next part
    Inc(PlPart);
    PlPath := PlBase + '_' + IntToStr(PlPart) + '.log';
    PlLines.Clear;
  end;
end;

procedure PlLog(S: string);
begin
  if not PlOn then begin
    PlLines := TStringList.Create;
    PlBase := Script.Path + '..\Logs\pull_' + User.Name + '_' + FormatDateTime('mmdd_hhnnss', Now);
    PlPart := 1;
    PlPath := PlBase + '_1.log';
    PlOn := true;
    Engine.Msg('[Pull]', 'Pull log: ' + PlPath, 0);
  end;
  PlLines.Add(FormatDateTime('hh:nn:ss.zzz', Now) + ' ' + S);
  PlDirty := true;
  if GetTickCount - PlAt >= 2000 then PlFlush();
end;

procedure PullLog(S: string);
begin
  PlLog(S);
end;

procedure MpInit();
begin
  if MpInited then exit;
  MpInited := true;
  MpPack := 10;
  MpTouchDist := 120;          // this close to a free mob = it should aggro (body pull)
  MpTouchWaitMs := 800;    // nobody on us yet, next to a mob this long without aggro -> hit it once
  MpTouchGraceMs := 3000;  // a touched mob gets this long to aggro before we run at it again
  MpTouchMax := 3;         // touched this many times without aggro = passive -> skipped
  MpSkipMs := 8000;        // a mob we got stuck on the way to -> skipped this long
  MpIgnoreMs := 30000;     // a passive / not hit mob -> skipped this long
  MpApproachMs := 15000;   // running to a mob this long without getting any closer to it (a wall) -> skipped
  MpTapAfterMs := 1000;    // tap weapon: ran past a mob, no aggro this long -> tap it
  MpTapMs := 1000;         // tap: the hit must land within the run to the mob (way / our speed) + this
  MpTapSkipMs := 10000;    // a mob our tap hit counts as the pack this long (not run at again, it comes)
  MpStaticMs := 2000;      // a mob hitting us from afar without moving this long ...
  MpStaticDist := 150;     // ... farther than this = a shooter: never pulled / fought
  MpExtraRange := 300;     // pack full: still take free mobs this close (on the way)
  MpBackPenalty := 400;    // pull order: a mob behind us costs this much extra distance
  MpHitRange := 80;        // hit only this close (farther the attack runs straight, not by the path)
  MpStuckMs := 1500;       // running to a mob without moving this long (wall) -> skip it
  MpMinHP := 50;           // HP % below this -> pull ends
  MpNoGainMs := 15000;     // no new aggro this long -> pull ends
  MpMaxMs := 120000;       // max time of one pull (a big room with respawns needs more than a minute)
  MpAggroDist := 1500;     // a mob "on us" farther than this does not count (stuck / teleported)
  MpPackMult := 2;         // this many packs on us -> pull ends at once
  MpStopMs := 300;         // not moving this long = stopped -> click again
  MpReclickDist := 80;     // the mob moved this far from our click point -> click again
  MpTickMs := 30;          // the pull tick: HP / the pack / the run looked at this often
  MpGridTol := 48;         // grid area: a mob this close to a walkable cell still counts
  MpPullRange := 0;        // a free mob farther than this from us is not pulled (0 = any distance)
  MpLeash := 0;            // a pack mob farther than this from us loses us: wait for it zigzagging (0 = off)
  MpZig := 180;            // zigzag: this far to each side across the way to the lagging mob
  MpOvershoot := 150;      // running at a mob we click this far past it: no stop at the click point
  MpSingleRange := 3000;   // one by one: mobs farther than this (by the way to them) are not taken
  MpPackDensity := 0;      // auto mode: this many free mobs near us -> pull a pack (0 = half the pack)
  MpTapSkill := 0;         // the tap: 0 = the tap weapon / a hit, else this skill from MpTapRange
  MpTapSkillMs := 3000;    // tap skill: its cast + flight - the hit must land within this after the cast
  MpHealCastMs := 2000;    // heal / drain while pulling: we stand this long for its cast (HP up -> sooner)
  MpTapFireMs := 1200;     // tap skill sent with DUseSkill: no start (reuse) in this -> out of sight: closer
  MpTapResendMs := 150;    // ... until it starts it is sent again this often (one packet may be dropped)
  MpTapRange := 80;
  MpSwEndPick := -1;
  MpPrvMs := 15000;        // AoE pull skill: a mob in its area when it went is ours (it comes) this long
  MpSwPackW := 333;        // the run: a leg costs 333 % more per mob behind us = our empty run counts 0.3 of one mob
                           // (the least way the pack runs: the far room whole first, the near one toward the spot)
  MpSwWaitMs := 8000;      // ... the run: at a point the skill not ready (reuse) this long -> on to the next
end;

// tuning by name; unknown name -> a message
procedure PullSet(Key: string; Value: integer);
var K: string;
begin
  MpInit();
  K := LowerCase(Key);
  if K = 'pack' then MpPack := Value
  else if K = 'touch' then MpTouchDist := Value
  else if K = 'touch_wait_ms' then MpTouchWaitMs := Value
  else if K = 'touch_grace_ms' then MpTouchGraceMs := Value
  else if K = 'touch_max' then MpTouchMax := Value
  else if K = 'skip_ms' then MpSkipMs := Value
  else if K = 'ignore_ms' then MpIgnoreMs := Value
  else if K = 'approach_ms' then MpApproachMs := Value
  else if K = 'tap_after_ms' then MpTapAfterMs := Value
  else if K = 'tap_ms' then MpTapMs := Value
  else if K = 'tap_skip_ms' then MpTapSkipMs := Value
  else if K = 'static_ms' then MpStaticMs := Value
  else if K = 'static_dist' then MpStaticDist := Value
  else if K = 'extra_range' then MpExtraRange := Value
  else if K = 'back_penalty' then MpBackPenalty := Value
  else if K = 'hit_range' then MpHitRange := Value
  else if K = 'stuck_ms' then MpStuckMs := Value
  else if K = 'min_hp' then MpMinHP := Value
  else if K = 'nogain_ms' then MpNoGainMs := Value
  else if K = 'max_ms' then MpMaxMs := Value
  else if K = 'aggro_dist' then MpAggroDist := Value
  else if K = 'pack_mult' then MpPackMult := Value
  else if K = 'stop_ms' then MpStopMs := Value
  else if K = 'reclick_dist' then MpReclickDist := Value
  else if K = 'tick_ms' then MpTickMs := Value
  else if K = 'grid_tol' then MpGridTol := Value
  else if K = 'pull_range' then MpPullRange := Value
  else if K = 'leash_range' then MpLeash := Value
  else if K = 'zig' then MpZig := Value
  else if K = 'overshoot' then MpOvershoot := Value
  else if K = 'single_range' then MpSingleRange := Value
  else if K = 'pack_density' then MpPackDensity := Value
  else if K = 'tap_skill_ms' then MpTapSkillMs := Value
  else if K = 'heal_cast_ms' then MpHealCastMs := Value
  else if K = 'tap_fire_ms' then MpTapFireMs := Value
  else if K = 'tap_resend_ms' then MpTapResendMs := Value
  else if K = 'prv_ms' then MpPrvMs := Value
  else if K = 'sweep_wait_ms' then MpSwWaitMs := Value
  else if K = 'sweep_pack_w' then MpSwPackW := Value
  else Engine.Msg('[Pull]', 'PullSet: unknown "' + Key + '"', 255);
end;

procedure PullSetMobs(IDs: array of integer);
var i: integer;
begin
  MpInit();
  SetLength(MpMobIDs, 0);
  for i := 0 to Length(IDs) - 1 do
    if IDs[i] > 0 then begin           // [0] = any mob too
      SetLength(MpMobIDs, Length(MpMobIDs) + 1);
      MpMobIDs[Length(MpMobIDs) - 1] := IDs[i];
    end;
end;

procedure PullClearMobs();
begin
  MpInit();
  SetLength(MpMobIDs, 0);
end;

procedure PullAddMob(ID: integer);
begin
  MpInit();
  if ID <= 0 then exit;                // 0 = any mob
  SetLength(MpMobIDs, Length(MpMobIDs) + 1);
  MpMobIDs[Length(MpMobIDs) - 1] := ID;
end;

procedure PullSetPackSize(N: integer);
begin
  MpInit();
  MpPack := N;
  if MpPack < 1 then MpPack := 1;
end;

procedure PullSetZRange(R: integer);
begin
  MpInit();
  MpZRange := R;
end;

procedure PullSetRadius(X, Y, R: integer);
begin
  MpInit();
  MpRX := X;
  MpRY := Y;
  MpRR := R;
end;

procedure PullSetTap(WeaponID, Range: integer);
begin
  MpInit();
  MpTapWeapon := WeaponID;
  MpTapRange := Range;
  if MpTapRange <= 0 then MpTapRange := MpHitRange;
end;

// a caster: the tap is SkillID cast from Range (we stop there, cast, wait for its hit, run on); no weapon
// swap. With PullSetTapAlways(true) every mob is pulled so (no run past them). 0 = the tap weapon / a hit
procedure PullSetTapSkill(SkillID, Range: integer);
begin
  MpInit();
  MpTapSkill := SkillID;
  MpTapSkillTold := false;
  SetLength(MpTapSks, 0);
  SetLength(MpTapRngs, 0);
  if SkillID <= 0 then exit;
  MpTapRange := Range;
  if MpTapRange <= 0 then MpTapRange := 600;
  SetLength(MpTapSks, 1);
  SetLength(MpTapRngs, 1);
  MpTapSks[0] := SkillID;
  MpTapRngs[0] := MpTapRange;
end;

// one more tap skill (after PullSetTapSkill: the list goes in this order); none before -> it is the first
procedure PullAddTapSkill(SkillID, Range: integer);
var n, R: integer;
begin
  MpInit();
  if SkillID <= 0 then exit;
  R := Range;
  if R <= 0 then R := 600;
  if MpTapSkill <= 0 then begin
    PullSetTapSkill(SkillID, R);
    exit;
  end;
  n := Length(MpTapSks);
  SetLength(MpTapSks, n + 1);
  SetLength(MpTapRngs, n + 1);
  MpTapSks[n] := SkillID;
  MpTapRngs[n] := R;
end;

// a heal / drain while pulling (PullHealTick): our HP % below HPBelow -> SkillID; Range > 0 = at a mob
// within Range (a drain), 0 = on us
procedure PullAddHeal(SkillID, HPBelow, Range: integer);
var n: integer;
begin
  MpInit();
  if (SkillID <= 0) or (HPBelow <= 0) then exit;
  n := Length(MpHealSk);
  SetLength(MpHealSk, n + 1);
  SetLength(MpHealHP, n + 1);
  SetLength(MpHealRng, n + 1);
  SetLength(MpHealFail, n + 1);
  MpHealSk[n] := SkillID;
  MpHealHP[n] := HPBelow;
  MpHealRng[n] := Range;
  MpHealFail[n] := 0;
end;

procedure PullClearHeals();
begin
  SetLength(MpHealSk, 0);
  SetLength(MpHealHP, 0);
  SetLength(MpHealRng, 0);
  SetLength(MpHealFail, 0);
end;

procedure PullAddAoeSkill(SkillID: integer; AtTarget: boolean; Range, Radius, MinMobs, EveryMs: integer);
var n: integer;
begin
  MpInit();
  if (SkillID <= 0) or (Radius <= 0) then exit;
  n := Length(MpAoeSk);
  SetLength(MpAoeSk, n + 1);
  SetLength(MpAoeRng, n + 1);
  SetLength(MpAoeRad, n + 1);
  SetLength(MpAoeEvery, n + 1);
  SetLength(MpAoeAtMob, n + 1);
  SetLength(MpAoeLast, n + 1);
  SetLength(MpAoeHold, n + 1);
  SetLength(MpAoeTold, n + 1);
  MpAoeSk[n] := SkillID;
  MpAoeAtMob[n] := AtTarget;
  MpAoeRng[n] := Range;
  if MpAoeRng[n] <= 0 then MpAoeRng[n] := 600;
  MpAoeRad[n] := Radius;
  MpAoeEvery[n] := EveryMs;           // (MinMobs: not used - the run plans its presses itself)
  if MpAoeEvery[n] < 0 then MpAoeEvery[n] := 0;
  MpAoeLast[n] := 0;
  MpAoeHold[n] := 0;
  MpAoeTold[n] := false;
end;

procedure PullAddRushSkill(SkillID, Range, MinDash: integer);
var n: integer;
begin
  MpInit();
  if SkillID <= 0 then exit;
  n := Length(MpRushSk);
  SetLength(MpRushSk, n + 1);
  SetLength(MpRushRng, n + 1);
  SetLength(MpRushMin, n + 1);
  SetLength(MpRushHold, n + 1);
  MpRushSk[n] := SkillID;
  MpRushRng[n] := Range;
  if MpRushRng[n] <= 0 then MpRushRng[n] := 400;
  MpRushMin[n] := MinDash;
  if MpRushMin[n] <= 0 then MpRushMin[n] := 100;
  if MpRushMin[n] > MpRushRng[n] - 20 then MpRushMin[n] := MpRushRng[n] - 20;
  MpRushHold[n] := 0;
end;

function PullRushOn(): boolean;
begin
  result := Length(MpRushSk) > 0;
end;

function PullRushCount(): integer;
begin
  result := MpRushN;
end;

procedure PullClearAoeSkills();
begin
  SetLength(MpAoeSk, 0);
  SetLength(MpAoeRng, 0);
  SetLength(MpAoeRad, 0);
  SetLength(MpAoeEvery, 0);
  SetLength(MpAoeAtMob, 0);
  SetLength(MpAoeLast, 0);
  SetLength(MpAoeHold, 0);
  SetLength(MpAoeTold, 0);
end;

procedure PullSweepEndsClear();
begin
  MpSwEndN := 0;
  MpSwEndPick := -1;
end;

procedure PullSweepEndAdd(X, Y: integer);
begin
  if MpSwEndN >= 8 then exit;
  MpSwEndX[MpSwEndN] := X;
  MpSwEndY[MpSwEndN] := Y;
  Inc(MpSwEndN);
end;

function PullSweepEndPicked(): integer;
begin
  result := MpSwEndPick;
end;

function PullAoeOn(): boolean;
begin
  result := Length(MpAoeSk) > 0;
end;

procedure PullSetTapAlways(Enable: boolean);
begin
  MpInit();
  MpTapAlways := Enable;
end;

procedure PullSetFarmWeapon(ID: integer);
begin
  MpInit();
  MpFarmWeapon := ID;
end;

procedure PullSetStop(Stop: boolean);
begin
  MpStop := Stop;
end;

procedure PullIgnoreID(ID: integer);
begin
  MpInit();
  if ID <= 0 then exit;
  SetLength(MpIgnIDs, Length(MpIgnIDs) + 1);
  MpIgnIDs[Length(MpIgnIDs) - 1] := ID;
end;

procedure PullIgnoreName(Name: string);
begin
  MpInit();
  SetLength(MpNames, Length(MpNames) + 1);
  MpNames[Length(MpNames) - 1] := LowerCase(Name);
  MpNkN := 0;
end;

procedure PullIgnore(OID, Ms: integer);
begin
  MpInit();
  MpSkipOID[MpSkipHead] := OID;
  MpSkipUntil[MpSkipHead] := GetTickCount + Ms;
  MpSkipHead := (MpSkipHead + 1) mod 64;
end;

procedure PullForget(OID, Ms: integer);
begin
  MpInit();
  MpHardOID[MpHardHead] := OID;
  MpHardUntil[MpHardHead] := GetTickCount + Ms;
  MpHardHead := (MpHardHead + 1) mod 32;
end;

function MpSkippedHard(OID: integer): boolean;
var k: integer;
begin
  result := false;
  for k := 0 to 31 do
    if (MpHardOID[k] = OID) and (GetTickCount < MpHardUntil[k]) then begin
      result := true;
      exit;
    end;
end;

function MpSkipped(OID: integer): boolean;
var k: integer;
begin
  result := false;
  for k := 0 to 63 do
    if (MpSkipOID[k] = OID) and (GetTickCount < MpSkipUntil[k]) then begin
      result := true;
      exit;
    end;
end;

// a mob our tap hit: it is ours from now on - the pull counts it in the pack and does not run at it
// again for tap_skip_ms (it comes to us)
procedure MpHitAdd(OID: integer);
begin
  MpHitOID[MpHitHead] := OID;
  MpHitAt[MpHitHead] := GetTickCount;
  MpHitHead := (MpHitHead + 1) mod 32;
  MpHitLast := GetTickCount;
end;

function MpWasHit(OID: integer): boolean;
var k: integer;
begin
  result := false;
  if (MpHitLast = 0) or (GetTickCount - MpHitLast >= MpTapSkipMs) then exit;
  for k := 0 to 31 do
    if (MpHitOID[k] = OID) and (GetTickCount - MpHitAt[k] < MpTapSkipMs) then begin
      result := true;
      exit;
    end;
end;

// a mob in the area of our AoE pull skill when it went: ours from now on (provoked, it comes - the bot may not
// show its target on us for a while) - not free, never pressed / run at again, counted in the pack for prv_ms
procedure MpPrvAdd(OID: integer);
begin
  MpPrvOID[MpPrvHead] := OID;
  MpPrvAt[MpPrvHead] := GetTickCount;
  MpPrvHead := (MpPrvHead + 1) mod 128;
  MpPrvLast := GetTickCount;
end;

function MpProvoked(OID: integer): boolean;
var k: integer;
begin
  result := false;
  if (MpPrvLast = 0) or (GetTickCount - MpPrvLast >= cardinal(MpPrvMs)) then exit;
  for k := 0 to 127 do
    if (MpPrvOID[k] = OID) and (GetTickCount - MpPrvAt[k] < cardinal(MpPrvMs)) then begin
      result := true;
      exit;
    end;
end;

function MpField(S: string; k: integer): string;
var p, n: integer;
  T: string;
begin
  T := Trim(S);
  n := k;
  while n > 0 do begin
    p := Pos(' ', T);
    if p = 0 then begin
      result := '';
      exit;
    end;
    T := Trim(Copy(T, p + 1, Length(T)));
    Dec(n);
  end;
  p := Pos(' ', T);
  if p > 0 then result := Copy(T, 1, p - 1) else result := T;
end;

// the walkable cells ('.') of a .navgrid are where we pull
procedure PullSetGrid(GridFile: string);
var L: TStringList;
  i, cx, cy, n: integer;
  S, F, Row: string;
begin
  MpInit();
  GgOn := false;
  GgNav := false;
  if NavGridIs(GridFile) then begin    // loaded by NavBuild already (from its cache): not read again
    GgNav := true;
    GgOn := true;
    Engine.Msg('[Pull]', 'Pull area: ' + GridFile + ' (the nav map)', 128);
    exit;
  end;
  F := Script.Path + '..\Nav\' + GridFile;
  if not FileExists(F) then begin
    Engine.Msg('[Pull]', 'No grid file ' + F + ' - pulling in the bot zone', 255);
    exit;
  end;
  L := TStringList.Create;
  L.LoadFromFile(F);
  cy := -1;
  n := 0;
  for i := 0 to L.Count - 1 do begin
    S := L[i];
    if MpField(S, 0) = 'G' then begin
      GgX0 := StrToIntDef(MpField(S, 1), 0);
      GgY0 := StrToIntDef(MpField(S, 2), 0);
      GgCell := StrToIntDef(MpField(S, 3), 32);
      GgW := StrToIntDef(MpField(S, 4), 0);
      GgH := StrToIntDef(MpField(S, 5), 0);
      SetLength(GgFree, GgW * GgH);
      for cx := 0 to GgW * GgH - 1 do GgFree[cx] := false;
      cy := 0;
    end else if (Copy(S, 1, 2) = 'R ') and (cy >= 0) and (cy < GgH) then begin
      Row := Copy(S, 3, GgW);
      for cx := 0 to Length(Row) - 1 do
        if Row[cx + 1] = '.' then begin
          GgFree[cy * GgW + cx] := true;
          Inc(n);
        end;
      Inc(cy);
    end;
  end;
  L.Free;
  GgOn := (GgW > 0) and (n > 0);
  Engine.Msg('[Pull]', 'Pull area: ' + GridFile + ', ' + IntToStr(n) + ' walkable cells', 128);
end;

function MpGridFree(X, Y: integer): boolean;
var cx, cy: integer;
begin
  if GgNav then begin
    result := NavGridFree(X, Y);
    exit;
  end;
  result := false;
  if (X < GgX0) or (Y < GgY0) then exit;
  cx := (X - GgX0) div GgCell;
  cy := (Y - GgY0) div GgCell;
  if (cx >= GgW) or (cy >= GgH) then exit;
  result := GgFree[cy * GgW + cx];
end;

procedure PullPolyClear();
begin
  PpN := 0;
end;

procedure PullPolyAdd(X, Y: integer);
begin
  if PpN >= Length(PpX) then begin
    SetLength(PpX, PpN + 16);
    SetLength(PpY, PpN + 16);
  end;
  PpX[PpN] := X;
  PpY[PpN] := Y;
  Inc(PpN);
end;

function MpInPoly(X, Y: integer): boolean;
var k, j: integer;
begin
  result := true;
  if PpN < 3 then exit;
  result := false;
  j := PpN - 1;
  for k := 0 to PpN - 1 do begin
    if ((PpY[k] > Y) <> (PpY[j] > Y)) and
       (X < 1.0 * (PpX[j] - PpX[k]) * (Y - PpY[k]) / (PpY[j] - PpY[k]) + PpX[k]) then result := not result;
    j := k;
  end;
end;

// the point is in the area of the pull (the grid / radius / bot zone) - the room polygon not looked at
function MpInZone(X, Y, Z: integer): boolean;
var DX, DY: double;
  T: integer;
begin
  if GgOn then begin
    T := MpGridTol;                    // a mob at the very wall stands on a cell painted as wall
    result := MpGridFree(X, Y) or MpGridFree(X - T, Y) or MpGridFree(X + T, Y) or
              MpGridFree(X, Y - T) or MpGridFree(X, Y + T);
  end else if MpRR > 0 then begin
    DX := X - MpRX;
    DY := Y - MpRY;
    result := Sqrt(DX * DX + DY * DY) <= MpRR;
  end else
    result := Engine.InZone(X, Y, Z);
end;

function PullInArea(X, Y, Z: integer): boolean;
begin
  MpInit();
  result := MpInPoly(X, Y) and MpInZone(X, Y, Z);   // a room is set: only inside it
end;

function MpDist(X, Y: integer): double;
var UX, UY: integer;
  DX, DY: double;
begin
  UX := User.X;
  UY := User.Y;
  DX := X - UX;
  DY := Y - UY;
  result := Sqrt(DX * DX + DY * DY);
end;

function MpIdx(OID: integer): integer;
var i: integer;
begin
  result := -1;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then
    if NpcList(i).OID = OID then begin
      result := i;
      exit;
    end;
end;

function PullNpcName(i: integer): string;
var Mob: TL2Npc;
begin
  result := '';
  if (i < 0) or (i >= NpcList.Count) then exit;
  Mob := NpcList(i);
  if Mob <> nil then result := Mob.Name;
end;

function PullNameIgnored(i: integer): boolean;
var k, ID, Cnt: integer;
  Nm: string;
  Mob: TL2Npc;
  Found: boolean;
begin
  result := false;
  if Length(MpNames) = 0 then exit;
  if (i < 0) or (i >= NpcList.Count) then exit;
  Mob := NpcList(i);
  if Mob = nil then exit;
  ID := Mob.ID;
  Found := false;
  // the table is shared by the threads (farm, events): an entry is written whole before the count
  // grows, so a reader never sees half of one; two threads adding the same kind = a harmless double
  for k := 0 to MpNkN - 1 do
    if MpNkID[k] = ID then begin
      result := MpNkIgn[k];
      Found := true;
      break;
    end;
  if Found then exit;
  Nm := LowerCase(Mob.Name);            // a new kind: its name once
  for k := 0 to Length(MpNames) - 1 do
    if Nm = MpNames[k] then begin
      result := true;
      break;
    end;
  Cnt := MpNkN;
  if Cnt <= 511 then begin
    MpNkID[Cnt] := ID;
    MpNkIgn[Cnt] := result;
    MpNkN := Cnt + 1;
  end;
end;

function MpNameIgnored(i: integer): boolean;
begin
  result := PullNameIgnored(i);
end;

function MpWhitelisted(i: integer): boolean;
var j, ID: integer;
begin
  result := Length(MpMobIDs) = 0;
  if result then exit;
  ID := NpcList(i).ID;
  for j := 0 to Length(MpMobIDs) - 1 do
    if ID = MpMobIDs[j] then begin
      result := true;
      exit;
    end;
end;

function MpZOk(Z: integer): boolean;
var UZ: integer;
begin
  UZ := User.Z;
  result := (MpZRange <= 0) or (Abs(Z - UZ) <= MpZRange);
end;

// ---------- run by the server path ----------

procedure MpMoveReset();
begin
  MpLX := User.X;
  MpLY := User.Y;
  MpMovedAt := GetTickCount;
end;

function MpStillMs(): cardinal;
var UX, UY: integer;
begin
  UX := User.X;
  UY := User.Y;
  if MpSq(UX - MpLX) + MpSq(UY - MpLY) >= 100 then begin
    MpLX := UX;
    MpLY := UY;
    MpMovedAt := GetTickCount;
  end;
  result := GetTickCount - MpMovedAt;
end;

// running without moving for stuck_ms = stuck (a wall) - not within 3 s after an AoE pull skill went on the run
// (the server holds us for its cast, the move comes after it)
function MpStuck(): boolean;
begin
  result := (MpStillMs() > MpStuckMs) and ((MpAoeRunAt = 0) or (GetTickCount - MpAoeRunAt > 3000));
end;

// one server path click (mouse click packet), remembered: it is NOT repeated on a timer - a new click
// makes the server build the path anew, and its first node may lie behind us
procedure MpClick(X, Y, Z: integer);
begin
  NavClick(X, Y, Z);                   // the move module sends the click
  MpClickX := X;
  MpClickY := Y;
  MpClickAt := GetTickCount;
end;

function MpNeedClick(X, Y: integer): boolean;
var DX, DY: double;
begin
  result := true;
  if MpClickAt = 0 then exit;
  DX := X - MpClickX;
  DY := Y - MpClickY;
  if Sqrt(DX * DX + DY * DY) > MpReclickDist then exit;
  result := (MpStillMs() >= MpStopMs) and (GetTickCount - MpClickAt >= MpStopMs);
end;

// run to a mob, never stopping: in sight -> click 150 PAST it (we run through it - the touch / hit
// happens on the way, no stop at the click point); behind a wall -> the farthest node of the nav map
// route in sight, the next one asked as soon as we are near it. A new click only when the mob moved,
// we are near the click point or we stopped. First = the first click of this run
procedure MpChase(MX, MY, MZ: integer; First: boolean);
var TX, TY, UX, UY: integer;
  DX, DY, L: double;
  Again: boolean;
begin
  UX := User.X;
  UY := User.Y;
  if NavIsReady() then begin
    Again := First or (GetTickCount - MpWpAt > 500);
    if MpWpOn and (Sqrt(MpSq(MpWpX - UX) + MpSq(MpWpY - UY)) < 120) then Again := true;
    if Again then begin
      MpWpOn := NavWaypoint(MX, MY);
      if MpWpOn then begin
        MpWpX := NavWpX();
        MpWpY := NavWpY();
      end;
      MpWpAt := GetTickCount;
    end;
  end else MpWpOn := false;
  if MpWpOn then begin
    TX := MpWpX;
    TY := MpWpY;
    if First or (Sqrt(MpSq(TX - MpClickX) + MpSq(TY - MpClickY)) > MpReclickDist) or
       (MpStillMs() >= MpStopMs) then begin
      if NavDebugOn() then
        Dbg('[Move]', 'pull: to the mob at ' + IntToStr(MX) + ',' + IntToStr(MY) + ' round a wall via the node ' +
          IntToStr(TX) + ',' + IntToStr(TY) + ' (we at ' + IntToStr(UX) + ',' + IntToStr(UY) + ', still ' +
          IntToStr(MpStillMs()) + ' ms)');
      MpClick(TX, TY, MZ);
    end;
    exit;
  end;
  // straight at the mob: the overshoot direction is kept between clicks (no turning back after we
  // ran past it)
  Again := First or (MpStillMs() >= MpStopMs);
  if Sqrt(MpSq(MX - MpChaseMX) + MpSq(MY - MpChaseMY)) > MpReclickDist then Again := true;
  if Sqrt(MpSq(MpClickX - UX) + MpSq(MpClickY - UY)) < 100 then Again := true;
  if not Again then exit;
  DX := MX - UX;
  DY := MY - UY;
  L := Sqrt(DX * DX + DY * DY);
  TX := MX;
  TY := MY;
  if L > 1 then begin
    TX := MX + Round(DX / L * MpOvershoot);
    TY := MY + Round(DY / L * MpOvershoot);
    if NavIsReady() and (not NavWalkLine(MX, MY, TX, TY)) then begin   // a wall right behind it: no overshoot
      TX := MX;
      TY := MY;
    end;
  end;
  // the strict map: never a click into red / the sight cells - up to the last green on the way only
  if NavIsReady() and NavStrictOn() then begin
    if not NavWalkClamp(UX, UY, TX, TY) then exit;   // no green on the way at all: no click (never into red)
    TX := NavClampX();
    TY := NavClampY();
  end;
  MpChaseMX := MX;
  MpChaseMY := MY;
  if NavDebugOn() then
    Dbg('[Move]', 'pull: straight at the mob at ' + IntToStr(MX) + ',' + IntToStr(MY) + ' d=' + IntToStr(Round(L)) +
      ', click past it ' + IntToStr(TX) + ',' + IntToStr(TY) + ' (we at ' + IntToStr(UX) + ',' + IntToStr(UY) + ')');
  MpClick(TX, TY, MZ);
end;

// ---------- ignored mobs, aggro ----------

function MpIgnoredID(ID: integer): boolean;
var k: integer;
begin
  result := false;
  for k := 0 to Length(MpIgnIDs) - 1 do
    if MpIgnIDs[k] = ID then begin
      result := true;
      exit;
    end;
end;

// a mob of the ignore list (PullIgnoreID): never pulled, never counted as aggro, not fought
function PullIsShooterAt(i: integer): boolean;
var ID, HP: integer;
begin
  result := false;
  if (Length(MpIgnIDs) = 0) and (MpChampHP <= 0) then exit;
  if (i < 0) or (i >= NpcList.Count) then exit;
  if MpChampHP > 0 then begin          // a champion: as if it were not there
    HP := NpcList(i).MaxHP;
    if HP > MpChampHP then begin
      result := true;
      exit;
    end;
  end;
  if Length(MpIgnIDs) = 0 then exit;
  ID := NpcList(i).ID;
  result := MpIgnoredID(ID);
end;

function PullIsShooter(OID: integer): boolean;
var i, ID, HP: integer;
begin
  result := false;
  if (Length(MpIgnIDs) = 0) and (MpChampHP <= 0) then exit;
  i := MpIdx(OID);
  if i < 0 then exit;
  if MpChampHP > 0 then begin          // a champion: as if it were not there
    HP := NpcList(i).MaxHP;
    if HP > MpChampHP then begin
      result := true;
      exit;
    end;
  end;
  if Length(MpIgnIDs) = 0 then exit;
  ID := NpcList(i).ID;
  result := MpIgnoredID(ID);
end;

procedure PullSkipChampions(MinMaxHP: integer);
begin
  MpChampHP := MinMaxHP;
end;

function PullIsChampion(i: integer): boolean;
var HP: integer;
begin
  result := false;
  if (MpChampHP <= 0) or NpcList(i).Dead then exit;
  HP := NpcList(i).MaxHP;
  result := HP > MpChampHP;
end;

// no automatic shooter detection any more (it took normal mobs for shooters): the ignore list only
procedure PullCheckShooters();
begin
end;

// whom the mob targets. The list changes in the bot's own thread while we walk it: the index may be
// past its end now and the target object may be gone - no exception (a try round .Target.OID broke
// the script with "Invalid pointer operation"): the object is taken once and checked for nil
function PullMobTarget(i: integer): integer;
var T: TL2Live;
begin
  result := 0;
  if (i < 0) or (i >= NpcList.Count) then exit;
  T := NpcList(i).Target;
  if T <> nil then result := T.OID;
end;

// every live mob whose target / last attack is us now -> the "from before" list
procedure MpStaleSnap();
var i, Atk, Tgt: integer;
begin
  MpStN := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if NpcList(i).Dead then continue;
    Atk := NpcList(i).AtkOID;
    Tgt := PullMobTarget(i);
    if (Atk <> User.OID) and (Tgt <> User.OID) then continue;
    if MpStN > 95 then break;
    MpStOID[MpStN] := NpcList(i).OID;
    MpStAt[MpStN] := NpcList(i).AtkTime;
    MpStMy[MpStN] := NpcList(i).MyAtkTime;
    MpStN := MpStN + 1;
  end;
  if MpStN > 0 then
    Engine.Msg('[Pull]', IntToStr(MpStN) + ' mobs still "on us" from before (death / the start): not counted ' +
      'until they hit us, we attack them or they come close', 0);
end;

function MpStaleIdx(OID: integer): integer;
var s: integer;
begin
  result := -1;
  for s := 0 to MpStN - 1 do
    if MpStOID[s] = OID then begin
      result := s;
      exit;
    end;
end;

// the moments to take the list: the first look (the script start) and coming back to life; looked at every 300 ms
procedure MpStaleTick();
var IsDead: boolean;
begin
  if MpStSnapped and (GetTickCount - MpStLook < 300) then exit;
  MpStLook := GetTickCount;
  IsDead := User.Dead;
  if IsDead then begin
    MpStWasDead := true;
    exit;
  end;
  if MpStSnapped and (not MpStWasDead) then exit;
  MpStSnapped := true;
  MpStWasDead := false;
  MpStaleSnap();
end;

function PullIsStale(i: integer): boolean;
const
  MP_STALE_NEAR = 250;                        // a mob "from before" this close to us chases us: on us for real
var OID, s: integer;
  C: TL2Cast;                                 // (TL2Cast, not TL2Effect as the help says)
begin
  result := false;
  MpStaleTick();
  if MpStN = 0 then exit;
  if (i < 0) or (i >= NpcList.Count) then exit;
  OID := NpcList(i).OID;
  s := MpStaleIdx(OID);
  if s < 0 then exit;
  if ((NpcList(i).AtkOID = User.OID) and (NpcList(i).AtkTime <> MpStAt[s])) or MpWasHit(OID) or MpProvoked(OID) or
     (NpcList(i).MyAtkTime <> MpStMy[s]) or (MpDist(NpcList(i).X, NpcList(i).Y) < MP_STALE_NEAR) then begin
    MpStOID[s] := 0;                          // it hits us / we attack, tap or provoke it / it came to us: on us for real
    exit;
  end;
  C := NpcList(i).Cast;
  if (C <> nil) and (C.EndTime > 0) and (PullMobTarget(i) = User.OID) then begin
    MpStOID[s] := 0;                          // it casts at us
    exit;
  end;
  result := true;
end;

function PullIsAggro(i: integer): boolean;
var Atk, Tgt, NX, NY, OID: integer;
begin
  MpInit();
  result := false;
  if i >= NpcList.Count then exit;
  if NpcList(i).Dead then exit;
  OID := NpcList(i).OID;
  if MpSkippedHard(OID) or PullIsShooterAt(i) then exit;
  Atk := NpcList(i).AtkOID;
  Tgt := PullMobTarget(i);
  if (Atk <> User.OID) and (Tgt <> User.OID) then exit;
  if PullIsStale(i) then exit;                // on us only from before (death / the start)
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  result := MpDist(NX, NY) < MpAggroDist;
end;

function PullCountAggro(): integer;
var i: integer;
begin
  result := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then
    if PullIsAggro(i) then Inc(result);
end;

// mobs our tap hit that do not target us yet (alive, near): the pull counts them as aggro already
function MpCountHit(): integer;
var i, OID: integer;
begin
  result := 0;
  if (MpHitLast = 0) or (GetTickCount - MpHitLast >= MpTapSkipMs) then exit;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if NpcList(i).Dead then continue;
    OID := NpcList(i).OID;
    if (not MpWasHit(OID)) or MpSkippedHard(OID) or PullIsAggro(i) then continue;
    if MpDist(NpcList(i).X, NpcList(i).Y) < MpAggroDist then Inc(result);
  end;
end;

// mobs our AoE pull skill provoked that do not target us yet (alive, near): the pull counts them as aggro already
function MpCountPrv(): integer;
var i, OID: integer;
begin
  result := 0;
  if (MpPrvLast = 0) or (GetTickCount - MpPrvLast >= cardinal(MpPrvMs)) then exit;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if NpcList(i).Dead then continue;
    OID := NpcList(i).OID;
    if (not MpProvoked(OID)) or MpWasHit(OID) or MpSkippedHard(OID) or PullIsAggro(i) then continue;
    if MpDist(NpcList(i).X, NpcList(i).Y) < MpAggroDist then Inc(result);
  end;
end;

function PullCountOurs(): integer;
begin
  MpInit();
  result := PullCountAggro() + MpCountHit() + MpCountPrv();
end;

// ---------- touch list (mobs we ran past) ----------

procedure MpTouch(OID: integer);
var i: integer;
begin
  MpDirX := User.X;
  MpDirY := User.Y;
  for i := 0 to 15 do
    if MpTouchOID[i] = OID then begin
      if GetTickCount - MpTouchAt[i] >= MpTouchGraceMs then begin   // one touch per grace time
        MpTouchAt[i] := GetTickCount;
        Inc(MpTouchCnt[i]);
      end;
      exit;
    end;
  MpTouchOID[MpTouchHead] := OID;
  MpTouchAt[MpTouchHead] := GetTickCount;
  MpTouchCnt[MpTouchHead] := 1;
  MpTouchHead := (MpTouchHead + 1) mod 16;
end;

function MpTouchSlot(OID: integer): integer;
var i: integer;
begin
  result := -1;
  for i := 0 to 15 do
    if MpTouchOID[i] = OID then begin
      result := i;
      exit;
    end;
end;

// the next free mob within MaxDist (0 = none): nearest first, one behind us costs back_penalty more
// (we run on along the zone, not back and forth); a just touched one only if nothing else is free;
// touched touch_max times without aggro -> passive, skipped
// the place of the mob OID in the planned order of the tap pull (the index of its group in run order); 99 = not in
// the plan (seen only after it was made / next to a mob that must not come: last)
function MpTapRank(OID: integer): integer;
var j: integer;
begin
  result := 99;
  for j := 0 to SwMobN - 1 do
    if SwMobOID[j] = OID then begin
      if SwMobPt[j] >= 0 then result := SwMobPt[j];
      exit;
    end;
end;

function MpFindFree(MaxDist: integer): integer;
var i, NX, NY, NZ, OID, UX, UY, Slot, Pass, Rk: integer;
  D, BestD, Cost, FX, FY, FL, MXd, MYd, CosA, LDX, LDY, LD, LimD: double;
  T, Grace: cardinal;
begin
  result := 0;
  UX := User.X;
  UY := User.Y;
  FX := UX - MpDirX;
  FY := UY - MpDirY;
  FL := Sqrt(FX * FX + FY * FY);
  Grace := MpTouchGraceMs;
  if (MpTapWeapon > 0) or (MpTapSkill > 0) then Grace := MpTapAfterMs;   // no aggro soon -> it gets tapped
  PlSkBehind := 0;
  PlSkOut := 0;
  MpCntAll := 0;
  MpCntArea := 0;
  MpCntRange := 0;
  MpCntZ := 0;
  MpCntSkip := 0;
  for Pass := 0 to 1 do begin
    BestD := 999999999;
    for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
      if NpcList(i).Dead or MpNameIgnored(i) then continue;
      if PullIsAggro(i) then continue;
      if not MpWhitelisted(i) then continue;
      if Pass = 0 then Inc(MpCntAll);
      OID := NpcList(i).OID;
      if MpWasHit(OID) or MpProvoked(OID) then continue;   // hit by our tap / provoked by our AoE: ours already, it comes
      if MpSkipped(OID) or MpSkippedHard(OID) or PullIsShooterAt(i) then begin
        if Pass = 0 then Inc(MpCntSkip);
        continue;
      end;
      Slot := MpTouchSlot(OID);
      if Slot >= 0 then begin
        T := GetTickCount - MpTouchAt[Slot];
        if (MpTouchCnt[Slot] >= MpTouchMax) and (T >= MpTouchGraceMs) then begin
          PullIgnore(OID, MpIgnoreMs);   // ran past it again and again, it never comes: passive
          MpTouchOID[Slot] := 0;
          continue;
        end;
        if (Pass = 0) and (T < Grace) then continue;
      end;
      NX := NpcList(i).X;
      NY := NpcList(i).Y;
      NZ := NpcList(i).Z;
      if not PullInArea(NX, NY, NZ) then begin
        if Pass = 0 then Inc(MpCntArea);
        continue;
      end;
      if not MpZOk(NZ) then begin
        if Pass = 0 then Inc(MpCntZ);
        continue;
      end;
      D := MpDist(NX, NY);
      if D > MaxDist then continue;
      // pull_range: with a pack behind us a free mob farther than this is not taken (we would run
      // away from the pack); the first mob of a pull may be anywhere in the area
      if (MpPullRange > 0) and MpHavePack and (D > MpPullRange) then begin
        if Pass = 0 then Inc(MpCntRange);
        continue;
      end;
      // (leash: no filter here - a stretched pack is kept together by the zigzag in PullRun)
      LimD := MpTouchDist * 2;
      if (Pass = 1) and (D <= LimD) then continue;   // just touched and still next to us: no use
      Cost := D;
      if (PpN >= 3) and TpOn then begin
        // a room with its order planned (MpTapPlan: the far groups first, the near ones on the way back to the
        // farm spot): the first group left in the order, of it the nearest to us; a mob behind a wall later
        // never back with the pack: a mob of a group passed already (a skip ran out, it fell behind, came up
        // there) or not in the plan (left behind us when it was made anew) waits for the next pull - unless it is
        // right by us
        Rk := MpTapRank(OID);
        if ((Rk < TpMinRank) or (Rk = 99)) and (D > 400) then begin
          if Pass = 0 then
            if Rk = 99 then Inc(PlSkOut) else Inc(PlSkBehind);
          continue;
        end;
        Cost := Rk * 100000.0 + D;
        if (Cost < BestD) and (not NavSee(UX, UY, NX, NY)) then Cost := Cost + 400;
      end else if PpN >= 3 then begin
        // a room, no plan: from where the pull began (the entry) to the far end - near us AND near the entry
        // first, a mob behind a wall (not seen straight) later
        LDX := NX - MpDirX;
        LDY := NY - MpDirY;
        LD := Sqrt(LDX * LDX + LDY * LDY);
        Cost := D + LD * 0.7;
        // the sight check is a line through the map: only for a mob that could still win
        if (Cost < BestD) and (not NavSee(UX, UY, NX, NY)) then Cost := Cost + 400;
      end else if (FL > 50) and (D > 1) then begin
        MXd := NX - UX;
        MYd := NY - UY;
        CosA := (FX * MXd + FY * MYd) / (FL * D);
        Cost := D + MpBackPenalty * (1 - CosA) / 2;
      end;
      if Cost < BestD then begin
        BestD := Cost;
        result := OID;
      end;
    end;
    if result <> 0 then exit;
  end;
end;

// ---------- one by one ----------

// a free mob we may take: alive, on the list, not ignored / skipped / on us, in the area, our floor
// a free mob we may take; Poly = only inside the room we farm now (PullPolyAdd), else anywhere in the area
function MpFreeAt(i: integer; Poly: boolean): boolean;
var OID, NX, NY, NZ: integer;
begin
  result := false;
  if NpcList(i).Dead or MpNameIgnored(i) then exit;
  if PullIsAggro(i) or (not MpWhitelisted(i)) then exit;
  OID := NpcList(i).OID;
  if MpWasHit(OID) or MpProvoked(OID) or MpSkipped(OID) or MpSkippedHard(OID) or PullIsShooterAt(i) then exit;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  if Poly and (not MpInPoly(NX, NY)) then exit;
  if not MpInZone(NX, NY, NZ) then exit;
  result := MpZOk(NZ);
end;

function MpFreeOK(i: integer): boolean;
begin
  result := MpFreeAt(i, true);
end;

// the verdict on NpcList(i) for the pull log: 'FREE' or why not (the checks of MpFreeAt, in its order)
function MpWhyNot(i: integer): string;
var OID, NX, NY, NZ, k: integer;
begin
  OID := NpcList(i).OID;
  NX := NpcList(i).X;
  NY := NpcList(i).Y;
  NZ := NpcList(i).Z;
  if NpcList(i).Dead then result := 'dead'
  else if MpNameIgnored(i) then result := 'its name is on the ignore list'
  else if PullIsAggro(i) then result := 'on us already'
  else if not MpWhitelisted(i) then result := 'not of the pack list (its ID ' + IntToStr(NpcList(i).ID) + ')'
  else if MpWasHit(OID) then result := 'hit by our tap (ours, comes)'
  else if MpProvoked(OID) then result := 'provoked by our AoE (ours, comes)'
  else if MpSkippedHard(OID) then result := 'skipped hard (unreachable before)'
  else if MpSkipped(OID) then begin
    result := 'skipped for now';
    for k := 0 to 63 do
      if (MpSkipOID[k] = OID) and (GetTickCount < MpSkipUntil[k]) then
        result := 'skipped for ' + IntToStr((MpSkipUntil[k] - GetTickCount) div 1000) + ' s more (stuck / no hit / not coming before)';
  end
  else if PullIsChampion(i) then result := 'a champion (skip_champions)'
  else if PullIsShooterAt(i) then result := 'on the ignore list (K ignore)'
  else if (PpN >= 3) and (not MpInPoly(NX, NY)) then result := 'outside the room polygon'
  else if not MpInZone(NX, NY, NZ) then result := 'off the map (zone / nav grid)'
  else if not MpZOk(NZ) then result := 'another floor (z ' + IntToStr(NZ - User.Z) + ' > zrange ' + IntToStr(MpZRange) + ')'
  else result := 'FREE';
end;

// every live mob the bot sees within 4000 of us with its verdict (and its group of the plan, if any)
procedure PlSnapshot(Tag: string);
var i, n, nf, D, Farthest, OID, j, G: integer;
  S: string;
begin
  n := 0;
  nf := 0;
  Farthest := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if NpcList(i).Dead then continue;
    D := Round(MpDist(NpcList(i).X, NpcList(i).Y));
    if D > Farthest then Farthest := D;
    if D > 4000 then continue;
    Inc(n);
    OID := NpcList(i).OID;
    S := MpWhyNot(i);
    if S = 'FREE' then Inc(nf);
    G := -1;
    if TpOn then
      for j := 0 to SwMobN - 1 do
        if SwMobOID[j] = OID then G := SwMobPt[j];
    if G >= 0 then S := S + ', plan group ' + IntToStr(G + 1)
    else if TpOn and (S = 'FREE') then S := S + ', NOT in the plan';
    PlLog('  ' + IntToStr(OID) + ' ' + PullNpcName(i) + ' at ' + IntToStr(NpcList(i).X) + ',' + IntToStr(NpcList(i).Y) +
      ' d ' + IntToStr(D) + ': ' + S);
  end;
  PlLog(Tag + ': ' + IntToStr(n) + ' live mobs within 4000 (' + IntToStr(nf) + ' free), the farthest the bot sees ' +
    IntToStr(Farthest) + ' away; we at ' + IntToStr(User.X) + ',' + IntToStr(User.Y) + ', HP ' + IntToStr(User.HP) + '%');
end;

function PullIsFree(i: integer): boolean;
begin
  MpInit();
  result := MpFreeOK(i);
end;

function PullIsFreeAnyRoom(i: integer): boolean;
begin
  MpInit();
  result := MpFreeAt(i, false);
end;

procedure PullSetPackLive(Enable: boolean);
begin
  MpPackLive := Enable;
end;

// every free mob we may take now (the area / the room polygon, our floor)
procedure MpMsg(Text: string);
begin
  Engine.Msg('[Pull]', Text, 0);
  Dbg('[Pull]', Text);
  PlLog('msg: ' + Text);
end;

// debug log: every live mob within 2500 - distance, on us / free / skipped / champion / area / floor
procedure PullDbgMobs(Tag: string);
var i, OID, NX, NY, NZ, Atk, Tgt: integer;
  S: string;
begin
  if not DbgOn() then exit;
  Dbg(Tag, 'mobs (OID name dist atk tgt stale | aggro free skip hard champ area z):');
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if NpcList(i).Dead then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    NZ := NpcList(i).Z;
    if MpDist(NX, NY) > 2500 then continue;
    OID := NpcList(i).OID;
    Atk := NpcList(i).AtkOID;
    Tgt := PullMobTarget(i);
    S := '  ' + IntToStr(OID) + ' ' + PullNpcName(i) + ' d=' + IntToStr(Round(MpDist(NX, NY))) +
      ' atk=' + IntToStr(Ord(Atk = User.OID)) + ' tgt=' + IntToStr(Ord(Tgt = User.OID)) +
      ' st=' + IntToStr(Ord(PullIsStale(i))) + ' | ' + IntToStr(Ord(PullIsAggro(i))) + ' ' + IntToStr(Ord(MpFreeOK(i))) + ' ' +
      IntToStr(Ord(MpSkipped(OID))) + ' ' + IntToStr(Ord(MpSkippedHard(OID))) + ' ' +
      IntToStr(Ord(PullIsChampion(i))) + ' ' + IntToStr(Ord(PullInArea(NX, NY, NZ))) + ' ' +
      IntToStr(Ord(MpZOk(NZ))) + ' z=' + IntToStr(NZ - User.Z);
    Dbg(Tag, S);
  end;
end;

function MpCountFreeAll(): integer;
var i: integer;
begin
  result := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then
    if MpFreeOK(i) then Inc(result);
end;

function PullCountFree(X, Y, R: integer): integer;
var i, NX, NY: integer;
  DX, DY: double;
begin
  MpInit();
  result := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if not MpFreeOK(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    DX := NX - X;
    DY := NY - Y;
    if Sqrt(DX * DX + DY * DY) <= R then Inc(result);
  end;
end;

function PullDensity(): integer;
begin
  MpInit();
  result := MpPackDensity;
  if result <= 0 then result := MpPack div 2;
  if result < 2 then result := 2;
end;

// the nearest by the way: the 6 nearest in a straight line are measured along the nav map
function PullPickSingle(): integer;
var i, k, n, NX, NY, Best: integer;
  D, BestD, PL: double;
  CandOID: array[0..5] of integer;
  CandD: array[0..5] of double;
  CandX, CandY: array[0..5] of integer;
begin
  MpInit();
  result := 0;
  n := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if not MpFreeOK(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    D := MpDist(NX, NY);
    if D > MpSingleRange then continue;
    // keep the 6 nearest (straight)
    if n < 6 then begin
      CandOID[n] := NpcList(i).OID;
      CandD[n] := D;
      CandX[n] := NX;
      CandY[n] := NY;
      Inc(n);
    end else begin
      Best := 0;
      for k := 1 to 5 do if CandD[k] > CandD[Best] then Best := k;
      if D < CandD[Best] then begin
        CandOID[Best] := NpcList(i).OID;
        CandD[Best] := D;
        CandX[Best] := NX;
        CandY[Best] := NY;
      end;
    end;
  end;
  BestD := 1E18;
  for k := 0 to n - 1 do begin
    PL := CandD[k];
    NX := CandX[k];
    NY := CandY[k];
    if NavIsReady() then PL := NavPathLen(NX, NY);
    if (PL < 0) or (PL > MpSingleRange) then continue;   // no way / too far by the way
    if PL < BestD then begin
      BestD := PL;
      result := CandOID[k];
    end;
  end;
end;

procedure PullChase(OID: integer; First: boolean);
var i, MX, MY, MZ: integer;
begin
  MpInit();
  i := MpIdx(OID);
  if i < 0 then exit;
  MX := NpcList(i).X;
  MY := NpcList(i).Y;
  MZ := NpcList(i).Z;
  if First then MpMoveReset();
  MpChase(MX, MY, MZ, First);
end;

// ---------- tap weapon ----------

// the bot's own search first (TL2List.ByID); the other copies with that ID only when it is not on
function MpEquipped(ItemID: integer): boolean;
var i, ID: integer;
  It: TL2Item;
begin
  result := false;
  if not Inventory.User.ByID(ItemID, It) then exit;
  if It.Equipped then begin
    result := true;
    exit;
  end;
  for i := 0 to Inventory.User.Count - 1 do if i < Inventory.User.Count then begin
    It := Inventory.User.Items(i);
    if It = nil then continue;
    ID := It.ID;
    if (ID = ItemID) and It.Equipped then begin
      result := true;
      exit;
    end;
  end;
end;

// the weapon in hands now (right hand $0080 / two hands $4000), from a fresh inventory; 0 = none
function MpCurrentWeapon(): integer;
var i, Part: integer;
  It: TL2Item;
begin
  result := 0;
  NavSend('14');
  Delay(1500);
  for i := 0 to Inventory.User.Count - 1 do if i < Inventory.User.Count then begin
    It := Inventory.User.Items(i);     // each item read once
    if It = nil then continue;
    if not It.Equipped then continue;
    Part := It.BodyPart;
    if (Part = $0080) or (Part = $4000) then begin
      result := It.ID;
      exit;
    end;
  end;
end;

// puts weapon W on without blocking (call every tick); true = on. Fast: by the bag as the bot knows it
// now - on already -> done, else UseItem at once; the server answers it with an inventory update, so it
// is seen on within a moment. No answer in 1.5 s -> the slow safe way: a fresh inventory first and a
// second UseItem only if it is still not on (a 2nd UseItem of a weapon that is on takes it OFF)
function MpWear(W: integer): boolean;
var T: cardinal;
begin
  result := false;
  T := GetTickCount;
  if MpWearID <> W then begin
    MpWearID := W;
    MpWearOK := false;
    MpWearRefAt := 0;
    if MpEquipped(W) then begin
      MpWearOK := true;
      result := true;
      exit;
    end;
    Engine.UseItem(W);
    MpWearUseAt := T;
    exit;
  end;
  if MpWearOK then begin
    result := true;
    exit;
  end;
  if (T - MpWearUseAt >= 150) and MpEquipped(W) then begin   // the server's answer to the UseItem
    MpWearOK := true;
    result := true;
    exit;
  end;
  if T - MpWearUseAt < 1500 then exit;
  if MpWearRefAt <= MpWearUseAt then begin   // no answer: a fresh inventory before anything else
    NavSend('14');
    MpWearRefAt := T;
    exit;
  end;
  if T - MpWearRefAt < 800 then exit;
  if MpEquipped(W) then begin
    MpWearOK := true;
    result := true;
    exit;
  end;
  Engine.Msg('[Weapon]', 'Item ' + IntToStr(W) + ' still not on, using it again', 0);
  Engine.UseItem(W);
  MpWearUseAt := T;
end;

function MpTapReady(): boolean;
var W: integer;
begin
  if not MpTapOn then begin
    MpTapMain := MpFarmWeapon;
    if MpTapMain <= 0 then MpTapMain := MpCurrentWeapon();
    MpTapOn := true;
    if MpTapMain = MpTapWeapon then begin
      if not MpTapSameTold then
        Engine.Msg('[Weapon]', 'Farm weapon = tap weapon ' + IntToStr(MpTapMain) +
          ' - the tap is a hit with it (another tap weapon: set the farm weapon in the script)', 128);
      MpTapSameTold := true;
    end else
      Engine.Msg('[Weapon]', 'Pull: tap weapon ' + IntToStr(MpTapWeapon) + ', farm weapon ' +
        IntToStr(MpTapMain) + ' after it', 0);
  end;
  W := MpTapWeapon;
  result := MpWear(W);
end;

// the reuse left of our skill (0 = ready); false in Has = this character has no such skill
function MpSkillLeft(ID: integer; var Has: boolean): cardinal;
var Sk: TL2Skill;
begin
  result := 0;
  Has := SkillList.ByID(ID, Sk);
  if Has then result := Sk.EndTime;
end;

function PullTapActive(): boolean;
begin
  result := MpTapOn;
end;

procedure PullTapRestore();
var W: integer;
begin
  if not MpTapOn then exit;
  W := MpTapMain;
  if (W <= 0) or MpWear(W) then begin
    MpTapOn := false;
    if W <> MpTapWeapon then Engine.Msg('[Weapon]', 'Farm weapon ' + IntToStr(W) + ' is on', 0);
  end;
end;

// this mob is to be tapped: we ran past it tap_after_ms ago without aggro, or nobody is on us yet
// and it stands next to us without aggro (or tap always)
function MpNeedTap(OID, Cnt: integer; NearSince: cardinal): boolean;
var Slot: integer;
begin
  result := false;
  if (MpTapWeapon <= 0) and (MpTapSkill <= 0) then exit;
  if MpTapAlways then begin
    result := true;
    exit;
  end;
  Slot := MpTouchSlot(OID);
  if (Slot >= 0) and (GetTickCount - MpTouchAt[Slot] >= MpTapAfterMs) then result := true;
  if (Cnt = 0) and (NearSince > 0) and (GetTickCount - NearSince >= MpTouchWaitMs) then result := true;
end;

function MpMustStop(): boolean;
begin
  result := MpStop or User.Dead;
end;

// the most lagging mob of the pack on us (farthest from us)
procedure MpUpdatePack();
var i, NX, NY: integer;
  D: double;
begin
  MpHavePack := false;
  MpFarD := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if not PullIsAggro(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    D := MpDist(NX, NY);
    if (not MpHavePack) or (D > MpFarD) then begin
      MpFarD := D;
      MpFarX := NX;
      MpFarY := NY;
      MpFarOID := NpcList(i).OID;
      MpHavePack := true;
    end;
  end;
end;

// the pack is stretched: keep moving (standing = being hit) but not farther from the lagging mob:
// run across the way to it, side to side by "zig", a little towards it, until it catches up
procedure MpZigzag();
var UX, UY, UZ, TX, TY: integer;
  VX, VY, L: double;
begin
  UX := User.X;
  UY := User.Y;
  UZ := User.Z;
  VX := MpFarX - UX;
  VY := MpFarY - UY;
  L := Sqrt(VX * VX + VY * VY);
  if L < 1 then exit;
  VX := VX / L;
  VY := VY / L;
  // the side is changed before we reach the side point (no stop there)
  if (MpZigAt = 0) or (GetTickCount - MpZigAt > 1500) or (MpStillMs() >= MpStopMs) or
     (Sqrt(MpSq(MpClickX - UX) + MpSq(MpClickY - UY)) < 60) then begin
    if MpZigSign = 0 then MpZigSign := 1 else MpZigSign := -MpZigSign;
    TX := UX + Round(-VY * MpZig * MpZigSign + VX * 40);
    TY := UY + Round(VX * MpZig * MpZigSign + VY * 40);
    if not PullInArea(TX, TY, UZ) then begin   // that side is a wall / out of the area: the other side
      MpZigSign := -MpZigSign;
      TX := UX + Round(-VY * MpZig * MpZigSign + VX * 40);
      TY := UY + Round(VX * MpZig * MpZigSign + VY * 40);
    end;
    MpMoveReset();
    MpClick(TX, TY, UZ);
    MpZigAt := GetTickCount;
  end;
end;

function PullLeashTick(): boolean;
var Idx: integer;
  L, LimHi, LimLo: double;
begin
  MpInit();
  result := false;
  L := MpLeash;
  if L <= 0 then L := 800;
  MpUpdatePack();
  if not MpHavePack then begin
    MpWaiting := false;
    exit;
  end;
  LimHi := L * 0.85;
  LimLo := L * 0.6;
  if (not MpWaiting) and (MpFarD > LimHi) then begin
    MpWaiting := true;
    MpZigAt := 0;
    MpWaitOID := MpFarOID;
    MpWaitD0 := MpFarD;
    MpWaitAt := GetTickCount;
    MpMsg('Pack stretched (' + IntToStr(Round(MpFarD)) + ') on the way to the spot, zigzag');
  end else if MpWaiting and (MpFarD < LimLo) then MpWaiting := false;
  if not MpWaiting then exit;
  if MpFarOID <> MpWaitOID then begin
    MpWaitOID := MpFarOID;
    MpWaitD0 := MpFarD;
    MpWaitAt := GetTickCount;
  end else if GetTickCount - MpWaitAt > 4000 then begin
    if MpFarD > MpWaitD0 - 100 then begin   // it does not come (wall): not waiting for it
      Idx := MpIdx(MpWaitOID);
      if Idx >= 0 then
        MpMsg(PullNpcName(Idx) + ' does not come (' + IntToStr(Round(MpFarD)) + '), not waiting for it');
      PullForget(MpWaitOID, MpIgnoreMs);
      MpWaiting := false;
      exit;
    end;
    MpWaitD0 := MpFarD;
    MpWaitAt := GetTickCount;
  end;
  MpZigzag();
  result := true;
end;

// ---------- the pull ----------

// the time a tap gets to land its hit: the run to the mob by the map at our speed + tap_ms (the swing)
function MpTapTime(MX, MY: integer): cardinal;
var Spd, Path: double;
begin
  Spd := User.Speed;
  if (Spd < 50) or (Spd > 2000) then Spd := 120;   // not known: a slow run (more time, never less)
  Path := MpDist(MX, MY);
  if NavIsReady() then begin
    Path := NavPathLen(MX, MY);
    if Path < 0 then Path := MpDist(MX, MY);      // no way by the map: straight
  end;
  result := Round(Path / Spd * 1000) + MpTapMs;
  Dbg('[Pull]', 'tap time ' + IntToStr(result) + ' ms: way ' + IntToStr(Round(Path)) + ' at speed ' +
    IntToStr(Round(User.Speed)) + ' + ' + IntToStr(MpTapMs));
end;

// the tap skills this character does not have (its skill list is loaded) leave the list, said once;
// none left -> the pull runs past them (no tap skill)
procedure MpTapDropMissing();
var k, n: integer;
  Has: boolean;
begin
  n := 0;
  for k := 0 to Length(MpTapSks) - 1 do begin
    MpSkillLeft(MpTapSks[k], Has);
    if Has then begin
      MpTapSks[n] := MpTapSks[k];
      MpTapRngs[n] := MpTapRngs[k];
      Inc(n);
    end else
      Engine.Msg('[Pull]', 'No tap skill ' + IntToStr(MpTapSks[k]) + ' on this character - not used for the pull', 128);
  end;
  SetLength(MpTapSks, n);
  SetLength(MpTapRngs, n);
  if n > 0 then begin
    MpTapSkill := MpTapSks[0];
    MpTapRange := MpTapRngs[0];
  end else begin
    Engine.Msg('[Pull]', 'No tap skill left - pulling by running past them', 128);
    MpTapSkill := 0;
  end;
end;

// the tap skill for a mob D away: the first of the list that is ready (no reuse) and reaches it; none ->
// the first ready one at all (we go up to its range); none ready -> the one ready soonest (we wait at its
// range). Rng = its range. 0 = no tap skills
function MpTapPick(D: double; var Rng: integer): integer;
var k: integer;
  Left, Best: cardinal;
  Has: boolean;
begin
  result := 0;
  Rng := MpTapRange;
  for k := 0 to Length(MpTapSks) - 1 do
    if (MpSkillLeft(MpTapSks[k], Has) = 0) and (D <= MpTapRngs[k]) then begin
      result := MpTapSks[k];
      Rng := MpTapRngs[k];
      exit;
    end;
  for k := 0 to Length(MpTapSks) - 1 do
    if MpSkillLeft(MpTapSks[k], Has) = 0 then begin
      result := MpTapSks[k];
      Rng := MpTapRngs[k];
      exit;
    end;
  Best := 0;
  for k := 0 to Length(MpTapSks) - 1 do begin
    Left := MpSkillLeft(MpTapSks[k], Has);
    if (result = 0) or (Left < Best) then begin
      result := MpTapSks[k];
      Rng := MpTapRngs[k];
      Best := Left;
    end;
  end;
end;

// the tap skill needs the mob in sight: a wall of the nav map between us and it (we stand in the passage,
// it is round the corner) -> no cast from here, we run on (round the wall, NavWaypoint) until it is in
// sight and within the range. No nav map / no tap skill: never blind
function MpTapBlind(MX, MY: integer): boolean;
var UX, UY: integer;
begin
  result := false;
  if (MpTapSkill <= 0) or (not NavIsReady()) then exit;
  UX := User.X;
  UY := User.Y;
  result := not NavSee(UX, UY, MX, MY);
end;

// the drain target within R: the nearest live mob on us / hit by our tap, in sight; none -> the nearest
// free mob of the pull in sight (it is pulled anyway); 0 = none
function MpHealTarget(R: integer): integer;
var i, OID, NX, NY, UX, UY, Pass: integer;
  D, BestD: double;
  Ok: boolean;
begin
  result := 0;
  UX := User.X;
  UY := User.Y;
  for Pass := 0 to 1 do begin
    BestD := R + 1;
    for i := 0 to NpcList.Count - 1 do begin
      if i >= NpcList.Count then break;  // the list got shorter while we walk it
      if NpcList(i).Dead then continue;
      OID := NpcList(i).OID;
      if Pass = 0 then Ok := PullIsAggro(i) or MpWasHit(OID) else Ok := PullIsFree(i);
      if not Ok then continue;
      NX := NpcList(i).X;
      NY := NpcList(i).Y;
      D := MpDist(NX, NY);
      if D >= BestD then continue;
      if NavIsReady() and (not NavSee(UX, UY, NX, NY)) then continue;
      BestD := D;
      result := OID;
    end;
    if result <> 0 then exit;
  end;
end;

function PullHealTick(): boolean;
var k, OID, HP0: integer;
  T0: cardinal;
  Has, Landed: boolean;
begin
  result := false;
  if Length(MpHealSk) = 0 then exit;
  if User.Dead then exit;
  for k := 0 to Length(MpHealSk) - 1 do begin
    if User.HP >= MpHealHP[k] then continue;
    if GetTickCount < MpHealFail[k] then continue;
    if MpSkillLeft(MpHealSk[k], Has) > 0 then continue;        // reuse
    if (SkillList.Count > 0) and (not Has) then continue;      // this character has no such skill
    OID := 0;
    if MpHealRng[k] > 0 then begin
      OID := MpHealTarget(MpHealRng[k]);
      if OID = 0 then continue;        // nobody to drain within its range: the next one (a heal on us)
      Engine.SetTarget(OID);
    end;
    HP0 := User.HP;
    Engine.DUseSkill(MpHealSk[k], false, false);   // no waiting in the bot: we stand for it below
    MpMsg('HP ' + IntToStr(HP0) + '% - skill ' + IntToStr(MpHealSk[k]) + ' to heal');
    // we stand for its cast (a move order would break it): until our HP goes up (it landed), at most
    // heal_cast_ms
    T0 := GetTickCount;
    Landed := false;
    while GetTickCount - T0 < cardinal(MpHealCastMs) do begin
      Delay(100);
      if User.Dead then break;
      if (GetTickCount - T0 >= 400) and (User.HP > HP0) then begin
        Landed := true;
        break;
      end;
    end;
    // no reuse started and no HP gained: the cast did not go (MP, out of sight...) - not again for 3 s
    if (not Landed) and (MpSkillLeft(MpHealSk[k], Has) = 0) then MpHealFail[k] := GetTickCount + 3000;
    result := true;
    exit;
  end;
end;

// ---------- the run of a pull with an AoE skill (PullAddAoeSkill) ----------

// the AoE pull skill k may be pressed now: this character has it, not held (it did not go a moment ago), out of
// its reuse and of its "at most every"
function MpSwReady(k: integer): boolean;
var Has: boolean;
begin
  result := false;
  if GetTickCount < MpAoeHold[k] then exit;
  if (MpAoeLast[k] <> 0) and (GetTickCount - MpAoeLast[k] < cardinal(MpAoeEvery[k])) then exit;
  if MpSkillLeft(MpAoeSk[k], Has) > 0 then exit;
  result := Has;
end;

// the run may be made: an AoE pull skill this character has (one it has not: told once). R = the biggest radius
// of those it has (the areas of the plan)
function MpSwOn(var R: integer): boolean;
var k: integer;
  Left: cardinal;
  Has: boolean;
begin
  result := false;
  R := 0;
  if (Length(MpAoeSk) = 0) or (SkillList.Count = 0) then exit;
  for k := 0 to Length(MpAoeSk) - 1 do begin
    Left := MpSkillLeft(MpAoeSk[k], Has);
    if Has then begin
      result := true;
      if MpAoeRad[k] > R then R := MpAoeRad[k];
    end else if not MpAoeTold[k] then begin
      MpAoeTold[k] := true;
      Engine.Msg('[Pull]', 'No pull skill ' + IntToStr(MpAoeSk[k]) + ' on this character - not used', 128);
    end;
  end;
end;

procedure MpSwSwapMob(a, b: integer);
var T: integer;
begin
  T := SwMobOID[a];
  SwMobOID[a] := SwMobOID[b];
  SwMobOID[b] := T;
  T := SwMobX[a];
  SwMobX[a] := SwMobX[b];
  SwMobX[b] := T;
  T := SwMobY[a];
  SwMobY[a] := SwMobY[b];
  SwMobY[b] := T;
  T := SwMobZ[a];
  SwMobZ[a] := SwMobZ[b];
  SwMobZ[b] := T;
end;

// the plan, 1: the free mobs of the pull now - a room: all of it; else the ones within pull_range (2000) of us, the
// Need nearest (as many as the pack lacks: the rest stay for the next pull) - and the mobs that must not come
procedure MpSwSnap(Need: integer);
var i, j, k, NX, NY, FarR: integer;
begin
  SwMobN := 0;
  SwBadN := 0;
  FarR := MpPullRange;
  if FarR <= 0 then FarR := 2000;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if NpcList(i).Dead then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    if PullIsShooterAt(i) then begin
      if (SwBadN < 32) and (MpDist(NX, NY) < 5000) then begin
        SwBadX[SwBadN] := NX;
        SwBadY[SwBadN] := NY;
        Inc(SwBadN);
      end;
      continue;
    end;
    if not MpFreeOK(i) then continue;
    if (PpN < 3) and (MpDist(NX, NY) > FarR) then continue;
    if SwMobN >= 128 then continue;
    SwMobOID[SwMobN] := NpcList(i).OID;
    SwMobX[SwMobN] := NX;
    SwMobY[SwMobN] := NY;
    SwMobZ[SwMobN] := NpcList(i).Z;
    Inc(SwMobN);
  end;
  if (PpN < 3) and (Need > 0) and (SwMobN > Need) then begin
    for j := 0 to Need - 1 do begin     // the Need nearest to the front
      k := j;
      for i := j + 1 to SwMobN - 1 do
        if MpDist(SwMobX[i], SwMobY[i]) < MpDist(SwMobX[k], SwMobY[k]) then k := i;
      if k <> j then MpSwSwapMob(j, k);
    end;
    SwMobN := Need;
  end;
  for i := 0 to SwMobN - 1 do SwMobPt[i] := -1;
end;

// the plan, 2: the mobs grouped into areas of the skill (radius R with a margin): the area round one of them that
// takes the most of the ones left first (a mob stands on walkable ground: we can get there); never an area with a
// mob that must not come near it; a mob behind a wall of the map from its middle goes to another area
procedure MpSwCover(R: integer);
var c, j, b, Best, BestC, Cnt: integer;
  RE, RB: double;
  Ok, Sight: boolean;
begin
  SwN := 0;
  RE := MpSq(R * 0.8);
  RB := MpSq(R + 150);
  Sight := NavIsReady();
  while SwN < 32 do begin
    BestC := -1;
    Best := 0;
    for c := 0 to SwMobN - 1 do begin
      if SwMobPt[c] <> -1 then continue;
      Ok := true;
      if not SwNoBad then
      for b := 0 to SwBadN - 1 do
        if MpSq(SwBadX[b] - SwMobX[c]) + MpSq(SwBadY[b] - SwMobY[c]) <= RB then begin
          Ok := false;
          break;
        end;
      if not Ok then continue;
      Cnt := 0;
      for j := 0 to SwMobN - 1 do
        if (SwMobPt[j] = -1) and (MpSq(SwMobX[j] - SwMobX[c]) + MpSq(SwMobY[j] - SwMobY[c]) <= RE) then Inc(Cnt);
      if Cnt > Best then begin
        Best := Cnt;
        BestC := c;
      end;
    end;
    if BestC < 0 then break;           // the ones left are next to a mob that must not come
    SwPX[SwN] := SwMobX[BestC];
    SwPY[SwN] := SwMobY[BestC];
    SwPZ[SwN] := SwMobZ[BestC];
    for j := 0 to SwMobN - 1 do
      if (SwMobPt[j] = -1) and (MpSq(SwMobX[j] - SwMobX[BestC]) + MpSq(SwMobY[j] - SwMobY[BestC]) <= RE) and
         ((j = BestC) or (not Sight) or NavSee(SwMobX[BestC], SwMobY[BestC], SwMobX[j], SwMobY[j])) then
        SwMobPt[j] := SwN;
    Inc(SwN);
  end;
end;

// the cost of the order SwTry: from us (32) through the n points, to the end (33) if HasEnd. Each leg: its way x
// (1 + sweep_pack_w % per mob behind us on it) - the mobs hit while they run after us: a run with the pack short
// (the far ones first, the near ones on the way back to the spot) beats an equal way with the pack long
function MpSwCost(n: integer; HasEnd: boolean): double;
var i, Pk: integer;
  W: double;
begin
  W := MpSwPackW / 100;
  Pk := SwCarry;
  result := SwDM[32 * 34 + SwTry[0]] * (1 + W * Pk);
  Pk := Pk + SwPW[SwTry[0]];
  for i := 1 to n - 1 do begin
    result := result + SwDM[SwTry[i - 1] * 34 + SwTry[i]] * (1 + W * Pk);
    Pk := Pk + SwPW[SwTry[i]];
  end;
  if HasEnd then result := result + SwDM[SwTry[n - 1] * 34 + 33] * (1 + W * Pk);
end;

procedure MpSwRev(a, b: integer);
var T: integer;
begin
  while a < b do begin
    T := SwTry[a];
    SwTry[a] := SwTry[b];
    SwTry[b] := T;
    Inc(a);
    Dec(b);
  end;
end;

// SwTry: the point at place a moved to place b (the ones between shift)
procedure MpSwMove(a, b: integer);
var T, k: integer;
begin
  T := SwTry[a];
  if a < b then
    for k := a to b - 1 do SwTry[k] := SwTry[k + 1]
  else
    for k := a downto b + 1 do SwTry[k] := SwTry[k - 1];
  SwTry[b] := T;
end;

// SwTry made cheaper by MpSwCost (to the end): a piece turned round (2-opt), one point moved elsewhere (or-opt),
// while it gets cheaper (8 passes at most). Result: its cost
function MpSwImprove(n: integer): double;
var i, j, k, Pass: integer;
  C: double;
  Better: boolean;
begin
  result := MpSwCost(n, true);
  Better := true;
  Pass := 0;
  while Better and (Pass < 8) do begin
    Better := false;
    Inc(Pass);
    for i := 0 to n - 2 do
      for j := i + 1 to n - 1 do begin
        MpSwRev(i, j);
        C := MpSwCost(n, true);
        if C < result - 1 then begin
          result := C;
          Better := true;
        end else MpSwRev(i, j);
      end;
    for i := 0 to n - 1 do
      for j := 0 to n - 1 do begin
        if i = j then continue;
        for k := 0 to n - 1 do SwTmp[k] := SwTry[k];
        MpSwMove(i, j);
        C := MpSwCost(n, true);
        if C < result - 1 then begin
          result := C;
          Better := true;
        end else
          for k := 0 to n - 1 do SwTry[k] := SwTmp[k];
      end;
  end;
end;

// the plan, 3: the order of the n points - the cheapest run from us through all of them (to the end if HasEnd; the
// cost: MpSwCost): up to 7 points every order is tried, more - two starts (the nearest next; the farthest from the
// end first), each with a piece turned round while it gets cheaper. SwOrd = the order, result = its cost
function MpSwOrder(n: integer; HasEnd: boolean): double;
var i, j, k, T, Pass, Start: integer;
  C, Best: double;
  Better: boolean;
begin
  for i := 0 to n - 1 do SwTry[i] := i;
  if n <= 7 then begin
    Best := MpSwCost(n, HasEnd);
    for i := 0 to n - 1 do SwOrd[i] := SwTry[i];
    while true do begin                // the next order (lexicographic)
      i := n - 2;
      while (i >= 0) and (SwTry[i] >= SwTry[i + 1]) do Dec(i);
      if i < 0 then break;
      j := n - 1;
      while SwTry[j] <= SwTry[i] do Dec(j);
      T := SwTry[i];
      SwTry[i] := SwTry[j];
      SwTry[j] := T;
      MpSwRev(i + 1, n - 1);
      C := MpSwCost(n, HasEnd);
      if C < Best then begin
        Best := C;
        for k := 0 to n - 1 do SwOrd[k] := SwTry[k];
      end;
    end;
    result := Best;
    exit;
  end;
  result := 1E18;
  for Start := 0 to 1 do begin
    if (Start = 1) and (not HasEnd) then break;
    for i := 0 to n - 1 do SwUsed[i] := false;
    k := 32;
    for i := 0 to n - 1 do begin       // start 0: the nearest next from us; 1: the farthest from the end first
      T := -1;
      for j := 0 to n - 1 do begin
        if SwUsed[j] then continue;
        if T < 0 then T := j
        else if (Start = 0) and (SwDM[k * 34 + j] < SwDM[k * 34 + T]) then T := j
        else if (Start = 1) and (SwDM[j * 34 + 33] > SwDM[T * 34 + 33]) then T := j;
      end;
      SwUsed[T] := true;
      SwTry[i] := T;
      k := T;
    end;
    Best := MpSwCost(n, HasEnd);
    Better := true;
    Pass := 0;
    while Better and (Pass < 6) do begin   // a piece turned round: kept when the cost gets lower
      Better := false;
      Inc(Pass);
      for i := 0 to n - 2 do
        for j := i + 1 to n - 1 do begin
          MpSwRev(i, j);
          C := MpSwCost(n, HasEnd);
          if C < Best - 1 then begin
            Best := C;
            Better := true;
          end else MpSwRev(i, j);
        end;
    end;
    if Best < result then begin
      result := Best;
      for i := 0 to n - 1 do SwOrd[i] := SwTry[i];
    end;
  end;
end;

// the order to the end point (column 33 of SwDM: each point's way to the farm spot along the map) by the rule of the
// user: the farthest from the spot first, then nearer and nearer - we run there with nothing behind us and come back
// with the pack, the last mob the nearest to the spot. Points of about the same depth (within MP_FAR_TOL of the
// farthest left) are taken nearest to where we are first (no running to and fro between them). Into SwOrd
procedure MpSwOrderFar(n: integer);
const
  MP_FAR_TOL = 100;
var s, i, Cur, Best: integer;
  Deep: double;
begin
  for i := 0 to n - 1 do SwUsed[i] := false;
  Cur := 32;
  for s := 0 to n - 1 do begin
    Deep := -1;
    for i := 0 to n - 1 do
      if (not SwUsed[i]) and (SwDM[i * 34 + 33] > Deep) then Deep := SwDM[i * 34 + 33];
    Best := -1;
    for i := 0 to n - 1 do begin
      if SwUsed[i] or (SwDM[i * 34 + 33] < Deep - MP_FAR_TOL) then continue;
      if (Best < 0) or (SwDM[Cur * 34 + i] < SwDM[Cur * 34 + Best]) then Best := i;
    end;
    SwUsed[Best] := true;
    SwOrd[s] := Best;
    Cur := Best;
  end;
end;

// the way between two points of the plan: along the nav map when ByMap (no way there: the straight one, dearer)
function MpWay(X1, Y1, X2, Y2: integer; ByMap: boolean): double;
var D: double;
begin
  result := Sqrt(MpSq(X2 - X1) + MpSq(Y2 - Y1));
  if (not ByMap) or (result < 1) then exit;
  D := NavWayLen(X1, Y1, X2, Y2);
  if D < 0 then result := result * 1.5
  else if D > result then result := D;
end;

// the plan, 4: the ways (along the nav map: a corridor counts as long as it is, not as the line through the wall;
// straight with no map / too many points for its 12 way tables), the mobs of each point, the order for each end
// point (PullSweepEndAdd) - the cheapest whole run is taken (MpSwEndPick); none - the run ends at the last point.
// SwX / SwY / SwZ = the points in run order, SwMobPt -> them
procedure MpSwPlan();
var i, j, e, k, T, UX, UY: integer;
  C, C2, Best: double;
  T0: cardinal;
begin
  T0 := GetTickCount;
  UX := User.X;
  UY := User.Y;
  SwPlanMap := NavIsReady();
  for i := 0 to SwN - 1 do SwPW[i] := 0;
  for j := 0 to SwMobN - 1 do
    if SwMobPt[j] >= 0 then SwPW[SwMobPt[j]] := SwPW[SwMobPt[j]] + 1;
  SwCarry := PullCountOurs();
  // target after target: its way table (NmFieldOf) is made once and serves every way to it (no 12-table limit)
  for j := 0 to SwN - 1 do begin
    SwDM[j * 34 + j] := 0;
    for i := 0 to SwN - 1 do
      if i <> j then SwDM[i * 34 + j] := MpWay(SwPX[i], SwPY[i], SwPX[j], SwPY[j], SwPlanMap);
    SwDM[32 * 34 + j] := MpWay(UX, UY, SwPX[j], SwPY[j], SwPlanMap);
  end;
  // to the farm spots: always along the map (one table per spot - cheap): the order goes by these
  for e := 0 to MpSwEndN - 1 do
    for i := 0 to SwN - 1 do
      SwEndD[i * 8 + e] := MpWay(SwPX[i], SwPY[i], MpSwEndX[e], MpSwEndY[e], NavIsReady());
  MpSwEndPick := -1;
  if MpSwEndN = 0 then begin
    MpSwOrder(SwN, false);
    for i := 0 to SwN - 1 do SwBest[i] := SwOrd[i];
  end else begin
    Best := 1E18;
    for e := 0 to MpSwEndN - 1 do begin
      for i := 0 to SwN - 1 do SwDM[i * 34 + 33] := SwEndD[i * 8 + e];
      // the least way the pack runs (MpSwCost: our empty run nearly free): from the farthest-first order and from
      // the nearest-next one, each made cheaper (MpSwImprove) - the better of the two
      MpSwOrderFar(SwN);
      for i := 0 to SwN - 1 do SwTry[i] := SwOrd[i];
      C := MpSwImprove(SwN);
      for i := 0 to SwN - 1 do SwTmp[i] := SwTry[i];
      for i := 0 to SwN - 1 do SwUsed[i] := false;
      k := 32;
      for i := 0 to SwN - 1 do begin
        T := -1;
        for j := 0 to SwN - 1 do
          if (not SwUsed[j]) and ((T < 0) or (SwDM[k * 34 + j] < SwDM[k * 34 + T])) then T := j;
        SwUsed[T] := true;
        SwTry[i] := T;
        k := T;
      end;
      C2 := MpSwImprove(SwN);
      if C2 < C then C := C2
      else for i := 0 to SwN - 1 do SwTry[i] := SwTmp[i];
      for i := 0 to SwN - 1 do SwOrd[i] := SwTry[i];
      if C < Best then begin
        Best := C;
        MpSwEndPick := e;
        for i := 0 to SwN - 1 do SwBest[i] := SwOrd[i];
      end;
    end;
  end;
  for i := 0 to SwN - 1 do begin
    SwX[i] := SwPX[SwBest[i]];
    SwY[i] := SwPY[SwBest[i]];
    SwZ[i] := SwPZ[SwBest[i]];
    SwInv[SwBest[i]] := i;
  end;
  for j := 0 to SwMobN - 1 do
    if SwMobPt[j] >= 0 then SwMobPt[j] := SwInv[SwMobPt[j]];
  SwPlanMs := GetTickCount - T0;
end;

// the mobs of point p still to pull (alive, free: not on us, not provoked / hit by us) and where they stand now ->
// SwLN / SwLX / SwLY / SwLOID; TX, TY, TZ = the one nearest to the point as planned (the run goes at it)
procedure MpSwLook(p: integer; var TX, TY, TZ: integer);
var j, Idx, NX, NY: integer;
  D, Best: double;
begin
  SwLN := 0;
  Best := 1E18;
  TX := SwX[p];
  TY := SwY[p];
  TZ := SwZ[p];
  for j := 0 to SwMobN - 1 do begin
    if SwMobPt[j] <> p then continue;
    Idx := MpIdx(SwMobOID[j]);
    if Idx < 0 then continue;
    if not MpFreeOK(Idx) then continue;
    NX := NpcList(Idx).X;
    NY := NpcList(Idx).Y;
    SwLOID[SwLN] := SwMobOID[j];
    SwLX[SwLN] := NX;
    SwLY[SwLN] := NY;
    Inc(SwLN);
    D := MpSq(NX - SwX[p]) + MpSq(NY - SwY[p]);
    if D < Best then begin
      Best := D;
      TX := NX;
      TY := NY;
      TZ := NpcList(Idx).Z;
    end;
  end;
end;

// of the mobs left of the point (MpSwLook): how many are within R of CX, CY and in sight from there
function MpSwInR(CX, CY, R: integer): integer;
var j: integer;
  Sight: boolean;
begin
  result := 0;
  Sight := NavIsReady();
  for j := 0 to SwLN - 1 do
    if (MpSq(SwLX[j] - CX) + MpSq(SwLY[j] - CY) <= MpSq(R)) and
       ((not Sight) or NavSee(CX, CY, SwLX[j], SwLY[j])) then Inc(result);
end;

// a mob that must not come (the ignore list / a skipped champion) within R of CX, CY
function MpSwBad(CX, CY, R: integer): boolean;
var i, NX, NY: integer;
begin
  result := false;
  if (Length(MpIgnIDs) = 0) and (MpChampHP <= 0) then exit;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if NpcList(i).Dead or (not PullIsShooterAt(i)) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    if MpSq(NX - CX) + MpSq(NY - CY) <= MpSq(R) then begin
      result := true;
      exit;
    end;
  end;
end;

// an AoE at a mob (skill k): the mob left of the point to cast it at - within its cast range of us and in sight,
// the one whose area takes the most of the ones left (N); its place CX, CY. 0 = none in reach
function MpSwAtMob(k: integer; var N, CX, CY: integer): integer;
var j, c, UX, UY: integer;
begin
  result := 0;
  N := 0;
  UX := User.X;
  UY := User.Y;
  for j := 0 to SwLN - 1 do begin
    if MpSq(SwLX[j] - UX) + MpSq(SwLY[j] - UY) > MpSq(MpAoeRng[k]) then continue;
    if NavIsReady() and (not NavSee(UX, UY, SwLX[j], SwLY[j])) then continue;
    c := MpSwInR(SwLX[j], SwLY[j], MpAoeRad[k] * 95 div 100);
    if c > N then begin
      N := c;
      result := SwLOID[j];
      CX := SwLX[j];
      CY := SwLY[j];
    end;
  end;
end;

// press the AoE skill k (round us, or at the mob TgtOID standing at CX, CY): sent on the run until it starts (its
// reuse) - no move order meanwhile (it would take the place of the skill on the server). It went: every free mob
// in its area (in sight of its middle) is ours from now (provoked) and the run goes on at once; the target stays
// (dropping it would break the cast). true = it went
function MpSwPress(k, TgtOID, CX, CY: integer): boolean;
var T0, SentAt: cardinal;
  Has: boolean;
  i, n, NX, NY, R: integer;
begin
  result := false;
  if MpAoeAtMob[k] then Engine.SetTarget(TgtOID);
  T0 := GetTickCount;
  SentAt := 0;
  while (not User.Dead) and (not MpStop) and (GetTickCount - T0 < cardinal(MpTapFireMs)) do begin
    if MpSkillLeft(MpAoeSk[k], Has) > 0 then begin
      result := true;
      break;
    end;
    if (SentAt = 0) or (GetTickCount - SentAt >= cardinal(MpTapResendMs)) then begin
      Engine.DUseSkill(MpAoeSk[k], false, false);
      SentAt := GetTickCount;
    end;
    Delay(30);
  end;
  MpMoveReset();                       // no "stuck" from the time it was sent
  if not result then begin
    MpAoeHold[k] := GetTickCount + 1000;
    MpMsg('Pull skill ' + IntToStr(MpAoeSk[k]) + ' did not go (MP? out of sight?) - running on, again in 1 s');
    exit;
  end;
  MpAoeLast[k] := GetTickCount;
  MpAoeRunAt := GetTickCount;
  if not MpAoeAtMob[k] then begin      // round us: from where it went
    CX := User.X;
    CY := User.Y;
  end;
  R := MpAoeRad[k];
  n := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if not MpFreeOK(i) then continue;
    NX := NpcList(i).X;
    NY := NpcList(i).Y;
    if MpSq(NX - CX) + MpSq(NY - CY) > MpSq(R) then continue;
    if NavIsReady() and (not NavSee(CX, CY, NX, NY)) then continue;
    MpPrvAdd(NpcList(i).OID);
    Inc(n);
  end;
  MpMsg('Pull skill ' + IntToStr(MpAoeSk[k]) + ' went ' + IntToStr(GetTickCount - T0) + ' ms after the first send: ' +
    IntToStr(n) + ' free mobs in its area are ours now - running on');
end;

// the tap / body pull of a room (no AoE skill): its order planned as the AoE run's - every free mob of the room in
// groups (the ones within MP_TAP_GROUP*0.8 of each other), the cheapest run from us through the groups to the farm
// spot (MpSwPlan: the ways along the map, each leg dearer by the pack behind us) = the far groups first, the near
// ones on the way back, the last mob near the spot. MpFindFree then takes the first group left in that order
// the run order as text: "3 mobs 3100 -> 2 mobs 2600 -> ... -> spot" (each group's mobs and its way to the spot)
function MpSwOrderText(): string;
var p, k: integer;
begin
  result := '';
  for p := 0 to SwN - 1 do begin
    if p > 0 then result := result + ' -> ';
    k := SwBest[p];
    result := result + IntToStr(SwPW[k]) + ' mobs';
    if MpSwEndPick >= 0 then result := result + ' ' + IntToStr(Round(SwEndD[k * 8 + MpSwEndPick]));
  end;
  if MpSwEndPick >= 0 then result := result + ' -> the spot';
end;

// the plan just made into the pull log: each group in run order - its mobs, middle, way to the farm spot, from us
procedure PlPlan(Kind: string);
var p, k, j, n: integer;
  S: string;
begin
  S := Kind + ' plan: ' + IntToStr(SwN) + ' groups, ' + IntToStr(SwMobN) + ' free mobs; end point ' + IntToStr(MpSwEndPick + 1);
  if MpSwEndPick >= 0 then S := S + ' at ' + IntToStr(MpSwEndX[MpSwEndPick]) + ',' + IntToStr(MpSwEndY[MpSwEndPick])
  else S := S + ' (none: the run ends anywhere!)';
  if SwPlanMap then S := S + ', ways along the map' else S := S + ', ways straight';
  PlLog(S + ', ' + IntToStr(SwPlanMs) + ' ms');
  for p := 0 to SwN - 1 do begin
    k := SwBest[p];
    n := 0;
    for j := 0 to SwMobN - 1 do if SwMobPt[j] = p then Inc(n);
    S := '  group ' + IntToStr(p + 1) + ': ' + IntToStr(SwPW[k]) + ' mobs (' + IntToStr(n) + ' still in) at ' +
      IntToStr(SwX[p]) + ',' + IntToStr(SwY[p]) + ', from us ' + IntToStr(Round(MpDist(SwX[p], SwY[p])));
    if MpSwEndPick >= 0 then S := S + ', way to the spot ' + IntToStr(Round(SwEndD[k * 8 + MpSwEndPick]));
    PlLog(S);
  end;
end;

procedure MpTapPlan();
const
  MP_TAP_GROUP = 350;
  MP_BACK_NEAR = 400;                  // a mob of a passed group is taken again only this close to us
var j, p, N: integer;
  S: string;
begin
  TpOn := false;
  TpMinRank := 0;
  TpBehind := 0;
  MpSwSnap(0);
  if SwMobN = 0 then exit;
  SwNoBad := true;                     // a tap takes one mob: an ignored one near it does not matter
  MpSwCover(MP_TAP_GROUP);
  SwNoBad := false;
  if SwN = 0 then exit;
  MpSwPlan();
  // made anew in the pull: the mobs of the groups we passed already stay passed (never back with the pack - it
  // hits; the run there and back with it is how one dies) unless right by us. Only the ones passed in the plan -
  // a group ahead of us stays ahead however deep it is
  if TpPassedN > 0 then
    for j := 0 to SwMobN - 1 do begin
      if SwMobPt[j] < 0 then continue;
      for p := 0 to TpPassedN - 1 do
        if TpPassed[p] = SwMobOID[j] then begin
          if MpDist(SwMobX[j], SwMobY[j]) > MP_BACK_NEAR then begin
            SwMobPt[j] := -1;
            Inc(TpBehind);
          end;
          break;
        end;
    end;
  TpOn := true;
  TpAt := GetTickCount;
  N := 0;
  for j := 0 to SwMobN - 1 do if SwMobPt[j] >= 0 then Inc(N);
  S := 'Pull order: ' + IntToStr(N) + ' free mobs of the room in ' + IntToStr(SwN) + ' groups, the farthest from the ' +
    'farm spot first (way along the map): ' + MpSwOrderText();
  if MpSwEndPick >= 0 then S := S + ' to end point ' + IntToStr(MpSwEndPick + 1);
  if SwPlanMap then S := S + '; planned along the map' else S := S + '; planned straight';
  S := S + ' in ' + IntToStr(SwPlanMs) + ' ms';
  if TpPlans > 0 then S := S + ' (again: mobs seen on the way)';
  if TpBehind > 0 then S := S + '; ' + IntToStr(TpBehind) + ' of the groups passed left for the next pull (never back with the pack)';
  MpMsg(S);
  PlPlan('tap');
  if DbgOn() then
    for j := 0 to SwN - 1 do
      Dbg('[Pull]', 'order ' + IntToStr(j + 1) + ': group at ' + IntToStr(SwX[j]) + ',' + IntToStr(SwY[j]) + ', ' +
        IntToStr(Round(MpDist(SwX[j], SwY[j]))) + ' from us in a line');
end;

// free mobs of the room the plan does not have (the bot did not see them when it was made: out of the client's sight
// from where we were, or up from the dead since)
function MpSwNewFree(): integer;
var i, j, OID: integer;
  Known: boolean;
begin
  result := 0;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if not MpFreeOK(i) then continue;
    OID := NpcList(i).OID;
    Known := false;
    for j := 0 to SwMobN - 1 do
      if SwMobOID[j] = OID then begin
        Known := true;
        break;
      end;
    if not Known then Inc(result);
  end;
end;

// the rush sent (PullRushTick): its start is watched every tick of the caller - no waiting in here, the caller goes
// on (HP, the pack...) but does not click meanwhile (a click before the cast starts would stop it). Not started:
// sent again every tap_resend_ms; none in tap_fire_ms standing (4 times that while the server runs us into its range)
// -> not at that mob for 5 s. Started (its reuse): a free mob it went at is ours (hit - it comes) and at once a click
// on our way - the server keeps that move until the cast ends and runs it then INSTEAD of the hit the skill would
// start (no swing at the mob after the dash). true = the caller skips its click this tick (the start is waited for /
// we clicked just now)
function MpRushGoOn(GX, GY: integer): boolean;
var T: cardinal;
  Has: boolean;
  Idx, UZ: integer;
  Nm, S: string;
begin
  result := false;
  T := GetTickCount;
  if User.Dead or MpStop or (T - MpRushPAt > 6000) then begin   // stopped / not called for long: forgotten
    MpRushPOID := 0;
    exit;
  end;
  Idx := MpIdx(MpRushPOID);
  Nm := '';
  if Idx >= 0 then Nm := PullNpcName(Idx);
  if MpSkillLeft(MpRushPSk, Has) > 0 then begin
    Inc(MpRushN);
    S := 'on us';
    if not MpRushPOurs then begin
      MpHitAdd(MpRushPOID);            // a free mob it went at: ours now, it comes
      S := 'free';
    end;
    UZ := User.Z;
    MpChase(GX, GY, UZ, true);         // on our way at once: the server runs it after the cast, no hit
    PlLog('rush ' + IntToStr(MpRushPSk) + ' at ' + IntToStr(MpRushPOID) + ' ' + Nm + ' (d ' + IntToStr(MpRushPD) + ', ' +
      IntToStr(MpRushPGain) + ' closer to the goal ' + IntToStr(MpRushPWG) + ' away, ' + S + ') - started after ' +
      IntToStr(T - MpRushPAt) + ' ms, on at once');
    Dbg('[Pull]', 'rush ' + IntToStr(MpRushPSk) + ' at ' + IntToStr(MpRushPOID) + ' started after ' + IntToStr(T - MpRushPAt) +
      ' ms, we at ' + IntToStr(User.X) + ',' + IntToStr(User.Y) + ' - clicked on to ' + IntToStr(GX) + ',' + IntToStr(GY));
    MpRushPOID := 0;
    MpMoveReset();
    result := true;
    exit;
  end;
  if (T - MpRushPAt > cardinal(MpTapFireMs)) and ((MpStillMs() >= 300) or (T - MpRushPAt > cardinal(MpTapFireMs) * 4)) then begin
    MpRushBadOID := MpRushPOID;
    MpRushBadUntil := T + 5000;
    if (MpRushPK >= 0) and (MpRushPK < Length(MpRushHold)) then MpRushHold[MpRushPK] := T + 300;
    PlLog('rush ' + IntToStr(MpRushPSk) + ' at ' + IntToStr(MpRushPOID) + ' ' + Nm + ' (d ' + IntToStr(MpRushPD) +
      '): no start in ' + IntToStr(T - MpRushPAt) + ' ms - not at it for 5 s');
    Dbg('[Pull]', 'rush ' + IntToStr(MpRushPSk) + ' at ' + IntToStr(MpRushPOID) + ' did not start in ' + IntToStr(T - MpRushPAt) + ' ms');
    MpRushPOID := 0;
    MpMoveReset();
    exit;
  end;
  if T - MpRushPSent >= cardinal(MpTapResendMs) then begin
    Engine.DUseSkill(MpRushPSk, false, false);
    MpRushPSent := T;
  end;
  result := true;
end;

// the rush (PullAddRushSkill) now, if one is worth it on the way to GX, GY: every tick of the caller (as often as it
// can go). One sent already -> its start watched (MpRushGoOn). Else the first ready rush skill; a live mob within its
// range and not nearer than its MinDash, in sight and on a line we may run (a dash over red / onto a ledge: no), not
// ignored / a skipped champion / on another floor, on us / hit / provoked - or free (FreeOk: a mob the pull may
// take); the dash must bring us closer to GX, GY (the way along the map) by at least half its length (forward, never
// back) - of those the one that brings us the closest. Target, DUseSkill, true (the caller does not click until it
// started: MpRushGoOn)
function PullRushTick(GX, GY: integer; FreeOk: boolean): boolean;
var k, Sk, SkK, Rng, MinD, i, OID, BestOID, UX, UY, MX, MY: integer;
  D, WG, W, Gain, BestGain, BestD: double;
  Has, Ours, IsFree, BestOurs, WGDone: boolean;
  Nm: string;
begin
  result := false;
  if Length(MpRushSk) = 0 then exit;
  if MpRushPOID <> 0 then begin
    result := MpRushGoOn(GX, GY);
    exit;
  end;
  if User.Dead or MpStop then exit;
  Sk := 0;
  SkK := -1;
  Rng := 0;
  MinD := 0;
  for k := 0 to Length(MpRushSk) - 1 do begin
    if GetTickCount < MpRushHold[k] then continue;
    if MpSkillLeft(MpRushSk[k], Has) > 0 then continue;      // reuse
    if (SkillList.Count > 0) and (not Has) then begin
      Engine.Msg('[Pull]', 'No rush skill ' + IntToStr(MpRushSk[k]) + ' on this character - not used', 128);
      MpRushHold[k] := GetTickCount + 600000;
      continue;
    end;
    Sk := MpRushSk[k];
    SkK := k;
    Rng := MpRushRng[k];
    MinD := MpRushMin[k];
    break;
  end;
  if Sk = 0 then exit;
  UX := User.X;
  UY := User.Y;
  WG := 0;
  WGDone := false;                     // the way to the goal: only once a mob passed the cheap checks
  BestOID := 0;
  BestGain := 0;
  BestD := 0;
  BestOurs := false;
  for i := 0 to NpcList.Count - 1 do if i < NpcList.Count then begin
    if NpcList(i).Dead then continue;
    MX := NpcList(i).X;
    MY := NpcList(i).Y;
    D := MpDist(MX, MY);
    if (D > Rng) or (D < MinD) then continue;
    OID := NpcList(i).OID;
    if (OID = MpRushBadOID) and (GetTickCount < MpRushBadUntil) then continue;
    if PullIsShooterAt(i) or MpNameIgnored(i) then continue;
    if not MpZOk(NpcList(i).Z) then continue;
    Ours := PullIsAggro(i) or MpWasHit(OID) or MpProvoked(OID);
    IsFree := false;
    if (not Ours) and FreeOk then IsFree := MpFreeOK(i);
    if (not Ours) and (not IsFree) then continue;
    if NavIsReady() then begin
      if not NavSee(UX, UY, MX, MY) then continue;
      if not NavWalkLine(UX, UY, MX, MY) then continue;
    end;
    if not WGDone then begin
      WG := MpWay(UX, UY, GX, GY, true);
      WGDone := true;
    end;
    if WG < MinD then exit;            // the goal is nearer than a dash: no use
    W := MpWay(MX, MY, GX, GY, true);
    Gain := WG - W;
    if Gain < D * 0.5 then continue;   // not forward on our way
    if Gain > BestGain then begin
      BestGain := Gain;
      BestOID := OID;
      BestD := D;
      BestOurs := Ours;
    end;
  end;
  if BestOID = 0 then exit;
  i := MpIdx(BestOID);
  Nm := '';
  if i >= 0 then Nm := PullNpcName(i);
  Dbg('[Pull]', 'rush ' + IntToStr(Sk) + ' at ' + IntToStr(BestOID) + ' ' + Nm + ' d=' + IntToStr(Round(BestD)) + ' ours ' +
    IntToStr(Ord(BestOurs)) + ': ' + IntToStr(Round(BestGain)) + ' closer to ' + IntToStr(GX) + ',' + IntToStr(GY) +
    ' (' + IntToStr(Round(WG)) + ' away)');
  Engine.SetTarget(BestOID);
  Engine.DUseSkill(Sk, false, false);
  MpRushPOID := BestOID;
  MpRushPSk := Sk;
  MpRushPK := SkK;
  MpRushPAt := GetTickCount;
  MpRushPSent := MpRushPAt;
  MpRushPOurs := BestOurs;
  MpRushPD := Round(BestD);
  MpRushPGain := Round(BestGain);
  MpRushPWG := Round(WG);
  MpMoveReset();                       // the "standing" of its start counts from here
  result := true;
end;

// the run: the whole pull is one run planned at its start (MpSwSnap / MpSwCover / MpSwPlan) - point after point the
// AoE skill is pressed on the run as soon as every mob of the point left is in its reach (the earliest place: no need
// to get to the point), then at once on to the next. Mobs that came by themselves / an earlier press took: the point
// is skipped. At the point and the skill not ready yet: through it and back (never standing) until it is, at most
// sweep_wait_ms, then on. Ends at the last point - the caller leads the pack to the spot (the end the plan took,
// PullSweepEndPicked). A room: every MP_SW_REPLAN_MS on the run, free mobs of the room the plan does not have
// (the client did not see them from where the run started / up from the dead) -> the rest of the run planned anew
// from here (the pack behind us counted), up to MP_SW_REPLANS times. false = nothing to plan (the usual pull goes on)
function MpSweep(): boolean;
const
  MP_SW_REPLAN_MS = 1500;
  MP_SW_REPLANS = 8;
var p, k, j, R, Need, TX, TY, TZ, CX, CY, UX, UY, TgtOID, N, BestK, Presses, Replans, NewN: integer;
  T0, AtAt, Started, ReplanAt: cardinal;
  First, Again: boolean;
  S: string;
begin
  result := false;
  MpSwEndPick := -1;
  if not MpSwOn(R) then exit;
  Need := 0;
  if PpN < 3 then begin                // not a room: as many as the pack lacks
    Need := MpPack - PullCountOurs();
    if Need < 1 then exit;
  end;
  MpSwSnap(Need);
  if SwMobN = 0 then exit;
  MpSwCover(R);
  if SwN = 0 then begin
    MpMsg('Pull run: ' + IntToStr(SwMobN) + ' free mobs, every one next to an ignored mob / a skipped champion - no run');
    exit;
  end;
  MpSwPlan();
  result := true;
  N := 0;
  for j := 0 to SwMobN - 1 do if SwMobPt[j] >= 0 then Inc(N);
  S := 'Pull run: ' + IntToStr(N) + ' free mobs in ' + IntToStr(SwN) + ' areas of the skill (radius ' + IntToStr(R) + ')';
  if MpSwEndPick >= 0 then S := S + ', ends at end point ' + IntToStr(MpSwEndPick + 1);
  S := S + ': ' + MpSwOrderText();
  if SwPlanMap then S := S + '; planned along the map' else S := S + '; planned straight';
  S := S + ' in ' + IntToStr(SwPlanMs) + ' ms, the pack counts ' + IntToStr(MpSwPackW) + ' % per mob';
  if N < SwMobN then S := S + '; ' + IntToStr(SwMobN - N) + ' left (next to an ignored mob / a champion)';
  MpMsg(S);
  PlPlan('AoE run');
  if DbgOn() then
    for p := 0 to SwN - 1 do begin
      N := 0;
      for j := 0 to SwMobN - 1 do if SwMobPt[j] = p then Inc(N);
      Dbg('[Pull]', 'run point ' + IntToStr(p + 1) + ' at ' + IntToStr(SwX[p]) + ',' + IntToStr(SwY[p]) + ': ' + IntToStr(N) + ' mobs' +
        ', ' + IntToStr(Round(MpDist(SwX[p], SwY[p]))) + ' from us in a line');
    end;
  Presses := 0;
  Replans := 0;
  Started := GetTickCount;
  ReplanAt := GetTickCount;
  p := 0;
  while p < SwN do begin
    First := true;
    T0 := GetTickCount;
    AtAt := 0;
    Again := false;
    while true do begin
      if MpMustStop() then exit;
      // a room: mobs the plan does not have (seen only now) -> the rest of the run planned anew from here
      if (PpN >= 3) and (Replans < MP_SW_REPLANS) and (GetTickCount - ReplanAt >= MP_SW_REPLAN_MS) then begin
        ReplanAt := GetTickCount;
        NewN := MpSwNewFree();
        if NewN > 0 then begin
          Inc(Replans);
          MpSwSnap(0);
          MpSwCover(R);
          if SwN > 0 then MpSwPlan();
          N := 0;
          for j := 0 to SwMobN - 1 do if SwMobPt[j] >= 0 then Inc(N);
          MpMsg('Pull run: ' + IntToStr(NewN) + ' new free mobs in the room (not seen before) - the rest planned anew: ' +
            IntToStr(N) + ' free mobs in ' + IntToStr(SwN) + ' areas, ' + IntToStr(PullCountOurs()) + ' ours already');
          Again := true;
          break;
        end;
      end;
      DbgTick();
      if GetTickCount - Started > cardinal(MpMaxMs) then begin
        MpMsg('Pull run: the pull time is over');
        exit;
      end;
      if (User.HP < MpMinHP) and (PullCountAggro() > 0) then begin
        MpMsg('Pull run: HP ' + IntToStr(User.HP) + '% - to the fight');
        exit;
      end;
      if PullHealTick() then begin     // our HP low: a heal / drain of PullAddHeal, then on
        First := true;
        continue;
      end;
      MpSwLook(p, TX, TY, TZ);
      if SwLN = 0 then break;          // all of them ours already: the next point
      UX := User.X;
      UY := User.Y;
      if (AtAt = 0) and (MpDist(TX, TY) < 150) then AtAt := GetTickCount;
      // a ready skill whose area from here takes every one left (at the point: whatever it takes)
      BestK := -1;
      TgtOID := 0;
      for k := 0 to Length(MpAoeSk) - 1 do begin
        if not MpSwReady(k) then continue;
        if MpAoeAtMob[k] then begin
          TgtOID := MpSwAtMob(k, N, CX, CY);
          if (TgtOID <> 0) and ((N >= SwLN) or (AtAt <> 0)) and (not MpSwBad(CX, CY, MpAoeRad[k] + 50)) then BestK := k;
        end else begin
          N := MpSwInR(UX, UY, MpAoeRad[k] * 95 div 100);
          CX := UX;
          CY := UY;
          if (N > 0) and ((N >= SwLN) or (AtAt <> 0)) and (not MpSwBad(UX, UY, MpAoeRad[k] + 50)) then BestK := k;
        end;
        if BestK >= 0 then break;
      end;
      if BestK >= 0 then begin
        if MpSwPress(BestK, TgtOID, CX, CY) then Inc(Presses);
        First := true;                 // the next click at once
        AtAt := 0;                     // some left there (out of its reach): their wait starts anew
        T0 := GetTickCount;
        continue;
      end;
      if (AtAt <> 0) and (GetTickCount - AtAt > cardinal(MpSwWaitMs)) then begin
        MpMsg('Pull run: point ' + IntToStr(p + 1) + ' - the skill not ready / not in reach for ' +
          IntToStr(MpSwWaitMs div 1000) + ' s, on (' + IntToStr(SwLN) + ' left there)');
        break;
      end;
      if GetTickCount - T0 > 30000 then begin
        MpMsg('Pull run: point ' + IntToStr(p + 1) + ' not reached in 30 s, on');
        break;
      end;
      if PullRushTick(TX, TY, true) then begin   // a dash on the way to the point (its start waited for: no click)
        First := true;                 // the next click at once
        Delay(MpTickMs);
        continue;
      end;
      if First then MpMoveReset();     // a new run: the "stuck" clock afresh
      MpChase(TX, TY, TZ, First);      // through it, never stopping (waiting there: through it and back)
      First := false;
      if MpStuck() then begin
        MpMsg('Pull run: stuck on the way to point ' + IntToStr(p + 1) + ', on');
        MpMoveReset();
        break;
      end;
      Delay(MpTickMs);
    end;
    if Again then p := 0                 // the new plan: from its first point
    else Inc(p);
  end;
  S := '';
  if Replans > 0 then S := ', planned anew ' + IntToStr(Replans) + ' times (mobs seen on the way)';
  MpMsg('Pull run done: ' + IntToStr(Presses) + ' presses, ' + IntToStr(PullCountOurs()) + ' ours' + S);
end;

function MpPullBody(): integer;
var OID, Idx, MX, MY, MZ, Cnt, Prev, Limit, HP, TapHP0, PassFrom: integer;
  Started, LastGain, NearSince, LastSend, ApproachSince, TapStart, TapArmedAt, TapCloseUntil: cardinal;
  ApproachBest: double;                // the closest we got to the mob we run to (ApproachSince: when we last got closer)
  Tapped, Tapping, TapOk: boolean;
  TapTries: integer;                   // tap again from right next to it (the whole room must aggro)
  TapTime: cardinal;                   // the time this tap gets to land its hit (MpTapTime)
  TapUA0, UA: integer;                 // User.AtkOID at the tap start / now
  TapUT0, TapMy0: cardinal;            // User.AtkTime / the mob's MyAtkTime at the tap start
  TapMine: boolean;                    // an attack of ours on the tapped mob was seen
  DbgAt: cardinal;                     // debug log: the last state line
  LimHi, LimLo: double;
  PackMax: integer;                    // the biggest pack size of this pull (for the log)
  UX, UY, UZ: integer;
  TapHas: boolean;                     // tap skill: this character has it
  TapSk, TapRng: integer;              // tap skills: the one for this mob now (MpTapPick), its range
  TapFired: boolean;                   // tap skill: the one sent went into reuse (it started)
  TapSendX, TapSendY: integer;         // tap skill: where we stood when it was sent (the server may run us closer)
  TapGo: double;                       // ... how far the server ran us before it started
  TapLastSend: cardinal;               // tap skill: the last packet of it (re-sent until it starts)
  TapCloseD: integer;                  // the run closer after no hit / no start goes this close (a skill: half the way)
  k: integer;
begin
  MpInit();
  result := 0;
  Tapping := false;
  TapSk := 0;
  TapRng := MpTapRange;
  TapFired := false;
  TapSendX := 0;
  TapSendY := 0;
  TapLastSend := 0;
  TapCloseD := 40;
  TapHP0 := 0;
  TapStart := 0;
  TapArmedAt := 0;
  TapCloseUntil := 0;
  TapTries := 0;
  TapTime := MpTapMs;
  Started := GetTickCount;
  LastGain := GetTickCount;
  Prev := -1;
  OID := 0;
  Tapped := false;
  NearSince := 0;
  LastSend := 0;
  ApproachSince := 0;
  ApproachBest := 1E18;
  MpDirX := User.X;
  MpDirY := User.Y;
  MpWaiting := false;                  // a new pull: no waiting carried over
  MpAoeRunAt := 0;
  PackMax := MpPack;
  DbgAt := 0;
  Dbg('[Pull]', 'start: pack ' + IntToStr(MpPack) + ' live ' + IntToStr(Ord(MpPackLive)) + ' leash ' + IntToStr(MpLeash) +
    ' tap ' + IntToStr(MpTapWeapon) + ' skill ' + IntToStr(MpTapSkill) + ' range ' + IntToStr(MpTapRange) + ' always ' +
    IntToStr(Ord(MpTapAlways)) + ' room pts ' + IntToStr(PpN) + ' tap skills ' + IntToStr(Length(MpTapSks)) +
    ' aoe skills ' + IntToStr(Length(MpAoeSk)));
  // tap skills this character does not have (the skill list is loaded) leave the list; none left -> pulled
  // by running past them
  if (MpTapSkill > 0) and (SkillList.Count > 0) then MpTapDropMissing();
  PullDbgMobs('[Pull]');
  // an AoE pull skill: the whole pull is one run planned now (MpSweep) - it ends with it, no chase after
  if MpSweep() then begin
    result := PullCountOurs();
    MpMsg('Pull end: ' + IntToStr(result) + ' ours (the run is done)');
    PullDbgMobs('[Pull] end');
    exit;
  end;
  // a room with no AoE skill: the order of the taps planned now (far first, back toward the farm spot)
  TpOn := false;
  TpPlans := 0;
  TpPassedN := 0;
  if PpN >= 3 then MpTapPlan();
  while not MpMustStop() do begin
    DbgTick();
    PullCheckShooters();
    // mobs of the room the plan does not have (seen only now): planned anew from here, the pack behind us counted
    if TpOn and (TpPlans < 8) and (GetTickCount - TpAt >= 1500) then begin
      TpAt := GetTickCount;
      if MpSwNewFree() > 0 then begin
        Inc(TpPlans);
        MpTapPlan();
      end;
    end;
    Cnt := PullCountAggro() + MpCountHit() + MpCountPrv();   // + the mobs our tap hit / our AoE took (they come)
    result := Cnt;
    // a mob that came up meanwhile is taken too; the planned pull of a room (TpOn): always - the pack is the whole
    // room as seen now (the mobs seen only on the way in too, not just the ones seen from where the pull began)
    if MpPackLive or TpOn then begin
      Limit := Cnt + MpCountFreeAll();
      if Limit < 1 then Limit := 1;
      // said only when bigger than ever in this pull: a mob counted / not counted in turn (skipped a
      // moment, at the edge) made it say "2 -> 3" again and again
      if Limit > PackMax then begin
        if PackMax > 0 then
          MpMsg('New mobs in the room: pack ' + IntToStr(PackMax) + ' -> ' + IntToStr(Limit));
        PackMax := Limit;
      end;
      MpPack := Limit;
    end;
    if GetTickCount - PlTickAt >= 1000 then begin
      PlTickAt := GetTickCount;
      PlLog('tick: at ' + IntToStr(User.X) + ',' + IntToStr(User.Y) + ' ours ' + IntToStr(Cnt) + '/' + IntToStr(MpPack) +
        ', target ' + IntToStr(OID) + ' (group ' + IntToStr(MpTapRank(OID) + 1) + '), passed groups ' + IntToStr(TpMinRank) +
        ', HP ' + IntToStr(User.HP) + '%, still ' + IntToStr(MpStillMs()) + ' ms');
    end;
    if Cnt <> Prev then begin
      if Cnt > Prev then LastGain := GetTickCount;
      MpMsg('Aggro ' + IntToStr(Cnt) + '/' + IntToStr(MpPack));
      Prev := Cnt;
    end;
    if Cnt >= MpPackMult * MpPack then begin
      MpMsg('Pull end: ' + IntToStr(Cnt) + ' (' + IntToStr(MpPackMult) + ' packs)');

      PullDbgMobs('[Pull] end');
      exit;
    end;
    Limit := 999999;
    if Cnt >= MpPack then Limit := MpExtraRange;   // pack full: only free mobs right on the way
    if Cnt > 0 then begin
      if User.HP < MpMinHP then begin
        MpMsg('Pull end: ' + IntToStr(Cnt) + ', HP low');

        PullDbgMobs('[Pull] end');
        exit;
      end;
      if GetTickCount - LastGain > MpNoGainMs then begin
        MpMsg('Pull end: ' + IntToStr(Cnt) + ', no new aggro ' + IntToStr(MpNoGainMs div 1000) + ' sec');

        PullDbgMobs('[Pull] end');
        exit;
      end;
      if GetTickCount - Started > MpMaxMs then begin
        MpMsg('Pull end: ' + IntToStr(Cnt) + ', pull time is over');

        PullDbgMobs('[Pull] end');
        exit;
      end;
    end;

    // our HP low: a heal / drain of PullAddHeal first (we stand for its cast); the pull goes on after it -
    // the mob we were tapping is tapped again (the drain changed the target)
    if PullHealTick() then begin
      LastGain := GetTickCount;        // healing is not "no new aggro"
      if Tapping then begin
        Tapping := false;
        TapArmedAt := 0;
        TapCloseUntil := 0;
      end;
      continue;
    end;

    // leash: the most lagging pack mob is about to lose us -> zigzag until it catches up
    MpUpdatePack();
    if (MpLeash > 0) and MpHavePack then begin
      LimHi := MpLeash * 0.85;
      LimLo := MpLeash * 0.6;
      if (not MpWaiting) and (MpFarD > LimHi) then begin
        MpWaiting := true;
        MpZigAt := 0;
        MpWaitOID := MpFarOID;
        MpWaitD0 := MpFarD;
        MpWaitAt := GetTickCount;
        MpMsg('Pack stretched (' + IntToStr(Round(MpFarD)) + '), zigzag until it catches up');
      end else if MpWaiting and (MpFarD < LimLo) then begin
        MpWaiting := false;
        OID := 0;                      // pick the next mob from here
      end;
      // the lagging mob does not come closer (stuck behind a wall / does not chase us): we do not
      // wait for it - it is dropped from the pack for a while, the pull goes on
      if MpWaiting then begin
        if MpFarOID <> MpWaitOID then begin
          MpWaitOID := MpFarOID;
          MpWaitD0 := MpFarD;
          MpWaitAt := GetTickCount;
        end else if GetTickCount - MpWaitAt > 4000 then begin
          if MpFarD > MpWaitD0 - 100 then begin
            Idx := MpIdx(MpWaitOID);
            if Idx >= 0 then
              MpMsg(PullNpcName(Idx) + ' does not come (' + IntToStr(Round(MpFarD)) +
                '), not waiting for it');
            PullForget(MpWaitOID, MpIgnoreMs);
            MpWaiting := false;
            continue;
          end;
          MpWaitD0 := MpFarD;          // it comes: measure the next 4 s
          MpWaitAt := GetTickCount;
        end;
      end;
      if MpWaiting and ((Cnt >= MpPack) or (MpFindFree(Limit) = 0)) then begin
        // nothing more to pull (or the pack is full): no use waiting here - to the fight, the
        // lagging ones come to the corner
        MpWaiting := false;
        MpMsg('Pull end: ' + IntToStr(Cnt) + ', nothing more to pull, no zigzag');

        PullDbgMobs('[Pull] end');
        exit;
      end;
      if MpWaiting then begin
        LastGain := GetTickCount;      // waiting for the pack is not "no new aggro"
        MpZigzag();
        Delay(MpTickMs);
        continue;
      end;
    end;                               // (an aggro flicker does not end the wait)

    if DbgOn() and (GetTickCount - DbgAt >= 250) then begin
      DbgAt := GetTickCount;
      Idx := MpIdx(OID);
      if Idx >= 0 then
        Dbg('[Pull]', 'tick cnt ' + IntToStr(Cnt) + '/' + IntToStr(MpPack) + ' lim ' + IntToStr(Limit) + ' at ' +
          IntToStr(User.X) + ',' + IntToStr(User.Y) + ' oid ' +
          IntToStr(OID) + ' ' + PullNpcName(Idx) + ' d=' + IntToStr(Round(MpDist(NpcList(Idx).X, NpcList(Idx).Y))) +
          ' aggro=' + IntToStr(Ord(PullIsAggro(Idx))) + ' free=' + IntToStr(Ord(MpFreeOK(Idx))) +
          ' tapping=' + IntToStr(Ord(Tapping)) + ' armed=' + IntToStr(Ord(TapArmedAt <> 0)) + ' sk=' + IntToStr(TapSk) +
          ' left=' + IntToStr(MpSkillLeft(TapSk, TapHas)) + ' fired=' + IntToStr(Ord(TapFired)) + ' tries=' +
          IntToStr(TapTries) + ' wait=' + IntToStr(Ord(MpWaiting)) + ' far=' + IntToStr(Round(MpFarD)) +
          ' still=' + IntToStr(MpStillMs()) + ' gain=' + IntToStr(GetTickCount - LastGain) + ' t=' +
          IntToStr(GetTickCount - Started) + ' gameTgt=' + IntToStr(Ord(User.Target <> nil)))
      else
        Dbg('[Pull]', 'tick cnt ' + IntToStr(Cnt) + '/' + IntToStr(MpPack) + ' lim ' + IntToStr(Limit) + ' oid ' +
          IntToStr(OID) + ' wait=' + IntToStr(Ord(MpWaiting)) + ' far=' + IntToStr(Round(MpFarD)) + ' gain=' +
          IntToStr(GetTickCount - LastGain) + ' t=' + IntToStr(GetTickCount - Started));
    end;

    // the pull mob aggroed / died / vanished / too far for an extra -> the next one
    if OID <> 0 then begin
      Idx := MpIdx(OID);
      if (Idx < 0) or NpcList(Idx).Dead or PullIsAggro(Idx) or MpWasHit(OID) or PullIsShooter(OID) then begin
        if Idx < 0 then Dbg('[Pull]', 'target ' + IntToStr(OID) + ' dropped: gone')
        else Dbg('[Pull]', 'target ' + IntToStr(OID) + ' dropped: dead ' + IntToStr(Ord(NpcList(Idx).Dead)) +
          ' aggro ' + IntToStr(Ord(PullIsAggro(Idx))) + ' hit ' + IntToStr(Ord(MpWasHit(OID))) +
          ' shooter/champ ' + IntToStr(Ord(PullIsShooter(OID))));
        OID := 0;
      end else begin
        MX := NpcList(Idx).X;
        MY := NpcList(Idx).Y;
        if MpDist(MX, MY) > Limit then begin
          Dbg('[Pull]', 'target ' + IntToStr(OID) + ' dropped: d=' + IntToStr(Round(MpDist(MX, MY))) + ' > lim ' + IntToStr(Limit));
          OID := 0;
        end;
      end;
    end;
    if OID = 0 then begin
      OID := MpFindFree(Limit);
      // the planned pull: a run to the next mob of the plan is the pull going on (a long run between two rooms is
      // not "no new aggro") - a mob we cannot get to is skipped by the approach time, the whole pull ends by max_ms
      if TpOn and (OID <> 0) then begin
        LastGain := GetTickCount;
        k := MpTapRank(OID);
        if (k <> 99) and (k > TpMinRank) then begin
          PassFrom := TpMinRank;         // the groups PassFrom..k-1 are passed now (their mobs kept as passed)
          TpMinRank := k;
          for Idx := 0 to SwMobN - 1 do
            if (SwMobPt[Idx] >= PassFrom) and (SwMobPt[Idx] < k) and (TpPassedN < 128) then begin
              TpPassed[TpPassedN] := SwMobOID[Idx];
              Inc(TpPassedN);
            end;
          PlLog('on to group ' + IntToStr(k + 1) + ': the groups before it passed (' + IntToStr(TpPassedN) + ' mobs kept as passed)');
        end;
      end;
      if OID <> 0 then begin
        Idx := MpIdx(OID);
        if Idx >= 0 then
          PlLog('pick ' + IntToStr(OID) + ' ' + PullNpcName(Idx) + ': group ' + IntToStr(MpTapRank(OID) + 1) + ', d ' +
            IntToStr(Round(MpDist(NpcList(Idx).X, NpcList(Idx).Y))) + ' (lim ' + IntToStr(Limit) + '); passed over now: ' +
            IntToStr(PlSkBehind) + ' behind us, ' + IntToStr(PlSkOut) + ' not in the plan');
      end else
        PlLog('pick: none (lim ' + IntToStr(Limit) + '; passed over: ' + IntToStr(PlSkBehind) + ' behind us, ' +
          IntToStr(PlSkOut) + ' not in the plan; ' + IntToStr(MpCntAll) + ' of the list, ' + IntToStr(MpCntArea) +
          ' out of the room, ' + IntToStr(MpCntZ) + ' other floor, ' + IntToStr(MpCntSkip) + ' skipped)');
      if OID <> 0 then begin
        Idx := MpIdx(OID);
        if Idx >= 0 then Dbg('[Pull]', 'new target ' + IntToStr(OID) + ' ' + PullNpcName(Idx) + ' d=' +
          IntToStr(Round(MpDist(NpcList(Idx).X, NpcList(Idx).Y))) + ' (lim ' + IntToStr(Limit) + ')');
      end;
      Tapped := false;
      Tapping := false;
      NearSince := 0;
      LastSend := 0;
      ApproachSince := GetTickCount;
      ApproachBest := 1E18;
      if OID = 0 then begin
        if Cnt > 0 then begin
          if Cnt >= MpPack then
            MpMsg('Pull end: ' + IntToStr(Cnt) + ' (pack full, nothing close)')
          else
            MpMsg('Pull end: ' + IntToStr(Cnt) + ', no free mobs: ' + IntToStr(MpCntAll) +
              ' of the list in sight, ' + IntToStr(MpCntArea) + ' out of the area, ' + IntToStr(MpCntRange) +
              ' farther than pull_range, ' + IntToStr(MpCntZ) + ' on another floor, ' + IntToStr(MpCntSkip) +
              ' skipped / ignored');
          PullDbgMobs('[Pull] end');
        end;
        if (Cnt = 0) and ((MpWhyAt = 0) or (GetTickCount - MpWhyAt > 10000)) then begin
          MpWhyAt := GetTickCount;
          MpMsg('Nothing to pull: ' + IntToStr(MpCntAll) + ' mobs of the list in sight, ' +
            IntToStr(MpCntArea) + ' out of the area' + ', ' + IntToStr(MpCntZ) + ' on another floor, ' +
            IntToStr(MpCntSkip) + ' skipped for a while');
        end;
        exit;                          // nothing on us and nothing to pull: the caller idles
      end;
    end;

    Idx := MpIdx(OID);
    if Idx < 0 then begin
      OID := 0;
      continue;
    end;
    MX := NpcList(Idx).X;
    MY := NpcList(Idx).Y;
    MZ := NpcList(Idx).Z;

    // tap weapon / tap skill: it does not aggro from the run past it (tap always: every mob) -> one hit from
    // tap range, at once run on
    if Tapping or MpNeedTap(OID, Cnt, NearSince) then begin
      if not Tapping then begin
        // tap skills: the one for this mob now (ready and reaching it, else ready, else ready soonest), its range
        TapRng := MpTapRange;
        if MpTapSkill > 0 then TapSk := MpTapPick(MpDist(MX, MY), TapRng);
        // farther than the tap range - or a tap skill and a wall between us (no cast through walls)
        if (MpDist(MX, MY) > TapRng) or MpTapBlind(MX, MY) then begin
          if LastSend = 0 then MpMoveReset();
          if MpStuck() then begin
            MpMsg('Cannot get to ' + PullNpcName(Idx) + ' (stuck on the way), skipping it');
            PullIgnore(OID, MpSkipMs);
            OID := 0;
            continue;
          end;
          if PullRushTick(MX, MY, Cnt < MpPack) then begin   // a dash on the way (at it / a mob toward it)
            LastSend := 0;                 // its start waited for (no click) / it went: the run clicks again at once
            Delay(MpTickMs);
            continue;
          end;
          if MpTapSkill <= 0 then TapOk := MpTapReady();   // the tap weapon goes on while we run, not at the mob
          MpChase(MX, MY, MZ, LastSend = 0);
          LastSend := GetTickCount;
          Delay(MpTickMs);
          continue;
        end;
        if MpTapSkill > 0 then begin   // the skill: we stop here (the run clicks past the mob), the cast goes from here
          UX := User.X;
          UY := User.Y;
          UZ := User.Z;
          if NavDebugOn() then
            Dbg('[Move]', 'pull: stop at ' + IntToStr(UX) + ',' + IntToStr(UY) + ' for the cast at ' + IntToStr(OID) +
              ' d=' + IntToStr(Round(MpDist(MX, MY))) + ' (range ' + IntToStr(TapRng) + ')');
          MpClick(UX, UY, UZ);
        end;
        Tapping := true;
        TapStart := GetTickCount;
        TapArmedAt := 0;
        TapCloseUntil := 0;
        TapTries := 0;
        TapHP0 := NpcList(Idx).CurHP;
        TapUA0 := User.AtkOID;
        TapUT0 := User.AtkTime;
        TapMy0 := NpcList(Idx).MyAtkTime;
        TapMine := false;
        TapFired := false;
        Dbg('[Pull]', 'tap start on ' + IntToStr(OID) + ' ' + PullNpcName(Idx) + ' d=' + IntToStr(Round(MpDist(MX, MY))) +
          ' skill ' + IntToStr(TapSk) + ' range ' + IntToStr(TapRng) +
          ' (we attacked ' + IntToStr(TapUA0) + ' at ' + IntToStr(TapUT0) + ', its MyAtkTime ' + IntToStr(TapMy0) + ')');
        Engine.SetTarget(OID);
      end;
      // the mob is ours when it targets us (the check at the top of the loop) OR OUR hit landed: our attack
      // on it was seen (User.AtkOID / its MyAtkTime changed) and its HP went down after that. A drop without
      // an attack of ours is somebody else's (the party assists our target at once: -2500 in 140 ms) - it
      // does not count. One hit is enough - the target goes off (no 2nd swing), it counts in the pack
      // (MpCountHit) and we run on to the next one at once; no waiting for its aggro
      LastGain := GetTickCount;        // a tap going on is not "no new aggro" (it has its own time limits)
      HP := NpcList(Idx).CurHP;
      UA := User.AtkOID;
      if (not TapMine) and (((UA = OID) and ((TapUA0 <> OID) or (User.AtkTime <> TapUT0))) or
         (NpcList(Idx).MyAtkTime <> TapMy0)) then begin
        TapMine := true;
        MpAtkWorks := true;
        TapHP0 := HP;                  // only a drop from here on is our hit
        Dbg('[Pull]', 'our attack on ' + IntToStr(OID) + ' seen after ' + IntToStr(GetTickCount - TapStart) +
          ' ms (we attack it ' + IntToStr(Ord(UA = OID)) + ', its MyAtkTime ' + IntToStr(NpcList(Idx).MyAtkTime) + ')');
      end;
      if HP < TapHP0 then begin
        // no attack of ours seen at all yet (the bot may not fill these): a drop counts only from 300 ms
        // after our weapon is on (our swing), never right after the target
        // (a tap skill: a drop after it started is ours - the bot does not show our attack for a skill)
        if TapMine or TapFired or ((not MpAtkWorks) and (TapArmedAt <> 0) and (GetTickCount - TapArmedAt >= 300)) then begin
          MpHitAdd(OID);
          Engine.CancelTarget;
          Dbg('[Pull]', 'hit on ' + IntToStr(OID) + ': hp ' + IntToStr(TapHP0) + '->' + IntToStr(HP) + ' after ' +
            IntToStr(GetTickCount - TapStart) + ' ms - ours, on to the next');
          Tapping := false;
          OID := 0;
          continue;
        end;
        Dbg('[Pull]', 'hp ' + IntToStr(TapHP0) + '->' + IntToStr(HP) + ' on ' + IntToStr(OID) + ' after ' +
          IntToStr(GetTickCount - TapStart) + ' ms: not our hit (no attack of ours yet) - hitting it ourselves');
        TapHP0 := HP;
      end;
      // the tap time (MpTapTime: the way to the mob / our speed + tap_ms) counts from the moment the tap
      // weapon is really on (a short run to the mob: the swap was not done yet and the time ran out before
      // a single hit - it ran up to the mob and away); the swap itself gets 6 s more at most
      if (TapArmedAt = 0) and (MpTapSkill > 0) then begin
        // the tap skills: the first of the list that is ready and reaches the mob is cast as soon as it is
        // ready (all in reuse: we wait standing); the one ready now reaches less than the mob is away (a
        // shorter one, the longer ones in reuse) -> closer, up to its range. The time for its hit counts from
        // the cast. Not castable 15 s (MP, reuse...) -> the mob is skipped
        TapSk := MpTapPick(MpDist(MX, MY), TapRng);
        if (TapCloseUntil = 0) and (MpSkillLeft(TapSk, TapHas) = 0) and
           (MpDist(MX, MY) > TapRng + TapRng div 9) then begin
          Dbg('[Pull]', 'tap skill ' + IntToStr(TapSk) + ' is ready but reaches ' + IntToStr(TapRng) + ', d=' +
            IntToStr(Round(MpDist(MX, MY))) + ' - closer');
          Tapping := false;
          Delay(MpTickMs);
          continue;
        end;
        if MpSkillLeft(TapSk, TapHas) = 0 then begin
          // sent with DUseSkill as the fight does (no waiting for the cast: a blocking cast held the pull for
          // seconds on a dead / unseen mob); its start (the reuse) is watched below
          Engine.DUseSkill(TapSk, false, false);
          TapLastSend := GetTickCount;
          TapSendX := User.X;
          TapSendY := User.Y;
          Dbg('[Pull]', 'tap skill ' + IntToStr(TapSk) + ' sent at ' + IntToStr(OID) + ' after ' +
            IntToStr(GetTickCount - TapStart) + ' ms, d=' + IntToStr(Round(MpDist(MX, MY))) + ' (its range ' +
            IntToStr(TapRng) + ')');
          TapArmedAt := GetTickCount;
          TapTime := MpTapSkillMs;
          TapFired := false;
        end else if GetTickCount - TapStart > 15000 then begin
          MpMsg('Tap skill ' + IntToStr(TapSk) + ' could not be cast at ' + PullNpcName(Idx) + ' in 15 s, skipping it');
          PullIgnore(OID, MpIgnoreMs);
          Engine.CancelTarget;
          Tapping := false;
          OID := 0;
          continue;
        end;
      end else if TapArmedAt = 0 then begin
        if MpTapReady() then begin
          Dbg('[Pull]', 'tap weapon on after ' + IntToStr(GetTickCount - TapStart) + ' ms');
          TapArmedAt := GetTickCount;
          TapTime := MpTapTime(MX, MY);
          Engine.SetTarget(OID);       // the swap (UseItem) may have dropped the target
        end else if GetTickCount - TapStart > MpTapMs + 6000 then begin
          MpMsg('Tap weapon did not go on for ' + PullNpcName(Idx) + ', skipping it');
          PullIgnore(OID, MpIgnoreMs);
          Engine.CancelTarget;         // the skipped mob does not stay in the target (the fight later)
          Tapping := false;
          OID := 0;
          continue;
        end;
      end;
      // the tap skill sent: its reuse shows it started -> the time for its hit counts from there; no start
      // in tap_fire_ms (out of sight, out of range) -> as if it did not hit: right up to it and again
      if (MpTapSkill > 0) and (TapArmedAt <> 0) and (not TapFired) and (TapCloseUntil = 0) then begin
        if MpSkillLeft(TapSk, TapHas) > 0 then begin
          TapFired := true;
          TapArmedAt := GetTickCount;
          TapGo := Sqrt(MpSq(User.X - TapSendX) + MpSq(User.Y - TapSendY));
          Dbg('[Pull]', 'tap skill ' + IntToStr(TapSk) + ' started on ' + IntToStr(OID) + ' after ' +
            IntToStr(GetTickCount - TapStart) + ' ms, d=' + IntToStr(Round(MpDist(MX, MY))) + ', the server ran us ' +
            IntToStr(Round(TapGo)));
          // the server had to run us closer before it started: its real range is shorter than the list says -
          // the next mobs get it from where it really reaches (no run-ups, no "no start" in between)
          if TapGo > 80 then
            for k := 0 to Length(MpTapSks) - 1 do
              if (MpTapSks[k] = TapSk) and (Round(MpDist(MX, MY)) - 20 < MpTapRngs[k] - 50) then begin
                MpTapRngs[k] := Round(MpDist(MX, MY)) - 20;
                if MpTapRngs[k] < 150 then MpTapRngs[k] := 150;
                if k = 0 then MpTapRange := MpTapRngs[k];
                MpMsg('Skill ' + IntToStr(TapSk) + ' started only at ' + IntToStr(Round(MpDist(MX, MY))) +
                  ' (the server ran us ' + IntToStr(Round(TapGo)) + ' closer): pulling with it from ' +
                  IntToStr(MpTapRngs[k]) + ' now - set its range in skills.json');
              end;
        end else if (GetTickCount - TapArmedAt <= cardinal(MpTapFireMs)) or
                    ((MpStillMs() < 300) and (GetTickCount - TapArmedAt <= cardinal(MpTapFireMs) * 4)) then begin
          // not started yet: sent again every tap_resend_ms (as sh_solo spams) - one packet right at the end of
          // its reuse is dropped by the server (our clock said ready a moment early). Still moving: the server
          // runs us into its cast range - not a failure, wait
          if GetTickCount - TapLastSend >= cardinal(MpTapResendMs) then begin
            Engine.DUseSkill(TapSk, false, false);
            TapLastSend := GetTickCount;
          end;
        end else begin
          Dbg('[Pull]', 'tap skill ' + IntToStr(TapSk) + ' did not start on ' + IntToStr(OID) + ' in ' +
            IntToStr(MpTapFireMs) + ' ms (out of sight?) - as no hit');
          TapArmedAt := GetTickCount - TapTime - 1;   // -> the step below: right up to it, again
        end;
      end;
      // did not land in its time (behind something, out of sight, a bad spot): right up to it and hit
      // again, twice; only then it is skipped - every mob of the room must come
      if (TapArmedAt <> 0) and (GetTickCount - TapArmedAt > TapTime) and (TapTries < 2) then begin
        Inc(TapTries);
        // the weapon: right up to it; a skill: half the way (no closer than 150) - from there it is in sight
        TapCloseD := 40;
        if MpTapSkill > 0 then begin
          TapCloseD := Round(MpDist(MX, MY)) div 2;
          if TapCloseD < 150 then TapCloseD := 150;
        end;
        MpMsg('Tap on ' + PullNpcName(Idx) + ': no hit in ' + IntToStr(TapTime) + ' ms - closer (to ' +
          IntToStr(TapCloseD) + '), again (' + IntToStr(TapTries) + '/2)');
        TapCloseUntil := GetTickCount + MpTapTime(MX, MY);   // the run up to it
        TapArmedAt := GetTickCount;
        MpMoveReset();
        if NavDebugOn() then
          Dbg('[Move]', 'pull: closer to ' + IntToStr(OID) + ' at ' + IntToStr(MX) + ',' + IntToStr(MY) + ' d=' +
            IntToStr(Round(MpDist(MX, MY))) + ' -> ' + IntToStr(TapCloseD) + ' (no hit / no start)');
        MpClick(MX, MY, MZ);
        Delay(MpTickMs);
        continue;
      end;
      if (TapCloseUntil <> 0) and (GetTickCount < TapCloseUntil) and (MpDist(MX, MY) > TapCloseD) then begin
        if MpNeedClick(MX, MY) then MpClick(MX, MY, MZ);   // still on the way to it
        TapArmedAt := GetTickCount;    // the tap time starts when we stand at it
        Delay(MpTickMs);
        continue;
      end;
      if (TapCloseUntil <> 0) and (GetTickCount >= TapCloseUntil) or ((TapCloseUntil <> 0) and (MpDist(MX, MY) <= TapCloseD)) then begin
        TapCloseUntil := 0;
        TapTime := MpTapTime(MX, MY);  // its time from where we stand now
        Engine.SetTarget(OID);
        if MpTapSkill > 0 then begin   // the skill is cast again from here (the next tick): we stop first
          TapArmedAt := 0;
          UX := User.X;
          UY := User.Y;
          UZ := User.Z;
          MpClick(UX, UY, UZ);
        end;
      end;
      if (TapArmedAt <> 0) and (GetTickCount - TapArmedAt > TapTime) then begin
        MpMsg('Tap on ' + PullNpcName(Idx) + ': no hit after 3 tries, skipping it');
        PullIgnore(OID, MpIgnoreMs);
        Engine.CancelTarget;           // the skipped mob does not stay in the target (the fight later)
        Tapping := false;
        OID := 0;
        continue;
      end;
      if (TapArmedAt <> 0) and (MpTapSkill <= 0) then Engine.Attack(MpTickMs) else Delay(MpTickMs);
      continue;
    end;

    if MpDist(MX, MY) > MpTouchDist then begin
      NearSince := 0;
      if LastSend = 0 then MpMoveReset();
      // we run and get closer: on, however long the way is (a far room first). Skipped only when MpApproachMs went
      // by with no step closer (running round a wall) or we do not move at all (stuck)
      if MpDist(MX, MY) < ApproachBest - 50 then begin
        ApproachBest := MpDist(MX, MY);
        ApproachSince := GetTickCount;
      end;
      if (GetTickCount - ApproachSince > MpApproachMs) or MpStuck() then begin
        MpMsg('Cannot get to ' + PullNpcName(Idx) + ': ' + IntToStr(MpApproachMs div 1000) + ' s no closer than ' +
          IntToStr(Round(ApproachBest)) + ' (a wall?) / stuck - skipping it');
        PullIgnore(OID, MpSkipMs);
        OID := 0;
        continue;
      end;
      if PullRushTick(MX, MY, Cnt < MpPack) then begin   // a dash on the way (at it / a mob toward it)
        LastSend := 0;                     // its start waited for (no click) / it went: the run clicks again at once
        Delay(MpTickMs);
        continue;
      end;
      MpChase(MX, MY, MZ, LastSend = 0);   // by the nav map if it is behind a wall
      LastSend := GetTickCount;
    end else if Cnt > 0 then begin
      MpTouch(OID);                    // mobs are on us: no stop - this one should follow, on to the next
      OID := 0;
      continue;
    end else begin
      if NearSince = 0 then NearSince := GetTickCount;
      if GetTickCount - NearSince >= MpTouchWaitMs then begin
        if not Tapped then begin
          if MpDist(MX, MY) > MpHitRange then begin
            MpChase(MX, MY, MZ, LastSend = 0);
            LastSend := GetTickCount;
          end else begin
            Engine.SetTarget(OID);
            Engine.Attack(300);
            Engine.CancelTarget;
            Tapped := true;
            NearSince := GetTickCount;
          end;
        end else begin
          PullIgnore(OID, MpIgnoreMs);   // does not aggro at all
          OID := 0;
        end;
      end;
    end;
    Delay(MpTickMs);
  end;
end;


// the pull with its log: what it saw at the start, the pull itself (MpPullBody), what it left at the end
function PullRun(): integer;
var e, Rush0: integer;
  S: string;
begin
  MpInit();
  Rush0 := MpRushN;
  PlLog('=== PULL START at ' + IntToStr(User.X) + ',' + IntToStr(User.Y) + ': pack ' + IntToStr(MpPack) + ', room polygon ' +
    IntToStr(PpN) + ' points, tap skills ' + IntToStr(Length(MpTapSks)) + ', AoE skills ' + IntToStr(Length(MpAoeSk)) +
    ', ours now ' + IntToStr(PullCountOurs()));
  S := '';
  for e := 0 to MpSwEndN - 1 do S := S + ' ' + IntToStr(MpSwEndX[e]) + ',' + IntToStr(MpSwEndY[e]);
  if S = '' then S := ' none';
  PlLog('end points (farm spots):' + S);
  PlSnapshot('seen at the start');
  PlTickAt := 0;
  result := MpPullBody();
  S := '';
  if Length(MpRushSk) > 0 then S := ', rushes ' + IntToStr(MpRushN - Rush0);
  PlLog('=== PULL END: ' + IntToStr(result) + ' ours, ' + IntToStr(PullCountOurs()) + ' counted now' + S);
  PlSnapshot('left at the end');
  PlFlush();
end;

end.
